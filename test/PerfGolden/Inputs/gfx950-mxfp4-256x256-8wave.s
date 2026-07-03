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
		s_lshr_b32 s0, s13, 3
		s_lshl_b32 s1, s14, 1
		s_add_i32 s0, s1, s0
		s_and_b32 s1, s13, 7
		s_lshl_b32 s1, s1, 5
		s_add_i32 s0, s0, s1
		s_lshr_b32 s1, s0, 6
		s_lshl_b32 s12, s1, 23
		v_and_b32_e32 v1, 63, v0
		s_and_b32 s0, s0, 63
		s_lshr_b32 s13, s0, 2
		s_lshl_b32 s14, s13, 17
		s_add_i32 s12, s12, s14
		v_readfirstlane_b32 s14, v0
		v_lshrrev_b32_e32 v2, 2, v1
		v_lshrrev_b32_e32 v3, 3, v1
		s_and_b32 s0, s0, 3
		s_lshl_b32 s15, s0, 21
		s_add_i32 s12, s12, s15
		s_add_u32 s16, s6, s12
		s_addc_u32 s17, s7, 0
		v_lshrrev_b32_e32 v4, 6, v0
		v_lshlrev_b32_e32 v2, 12, v2
		v_and_b32_e32 v5, 3, v3
		v_and_b32_e32 v6, 3, v1
		s_lshr_b32 s6, s14, 6
		s_lshl_b32 s7, s6, 10
		s_add_i32 s12, s7, 0x2000
		s_add_i32 s15, s7, 0x4000
		v_lshl_add_u32 v2, v4, 16, v2
		v_xor_b32_e32 v5, v5, v6
		s_add_i32 s20, s7, 0x6000
		s_add_i32 s21, s7, 0x8000
		s_add_i32 s22, s7, 0xa000
		s_add_i32 s23, s7, 0xc000
		v_lshl_add_u32 v2, v5, 4, v2
		s_add_i32 s24, s7, 0xe000
		s_lshl_b32 s25, s1, 22
		s_lshl_b32 s26, s0, 20
		s_add_i32 s18, s25, s26
		v_add_u32_e32 v5, s18, v2
		s_mov_b32 s31, 0x31016000
		s_mov_b32 s34, 0x1000000
		s_mov_b32 s32, s2
		s_mov_b32 s33, s3
		s_mov_b32 m0, s7
		s_mov_b32 s35, s31
		buffer_load_dwordx4 v5, s[32:35], 0 offen lds
		v_add_u32_e32 v6, s26, v2
		s_add_i32 m0, s7, 0x2000
		s_add_i32 s2, s25, 0x80000
		v_add_u32_e32 v7, s2, v6
		buffer_load_dwordx4 v7, s[32:35], 0 offen lds
		v_add3_u32 v7, s25, 64, v6
		s_add_i32 m0, s7, 0x4000
		s_nop 0
		buffer_load_dwordx4 v7, s[32:35], 0 offen lds
		s_add_i32 m0, s7, 0x6000
		s_add_i32 s2, s25, 0x80040
		v_add_u32_e32 v6, s2, v6
		buffer_load_dwordx4 v6, s[32:35], 0 offen lds
		s_add_i32 m0, s7, 0x8000
		s_lshl_b32 s2, s13, 20
		v_add_u32_e32 v6, s2, v2
		s_mov_b32 s36, s4
		s_mov_b32 s37, s5
		s_mov_b32 s38, s34
		s_mov_b32 s39, s35
		buffer_load_dwordx4 v6, s[36:39], 0 offen lds
		s_add_i32 m0, s7, 0xa000
		s_add_i32 s3, s2, 0x80000
		v_add_u32_e32 v7, s3, v2
		buffer_load_dwordx4 v7, s[36:39], 0 offen lds
		v_add3_u32 v7, s2, 64, v2
		s_add_i32 m0, s7, 0xc000
		s_nop 0
		buffer_load_dwordx4 v7, s[36:39], 0 offen lds
		s_add_i32 m0, s7, 0xe000
		s_add_i32 s3, s2, 0x80040
		v_add_u32_e32 v7, s3, v2
		buffer_load_dwordx4 v7, s[36:39], 0 offen lds
		s_lshr_b32 s3, s14, 7
		s_lshl_b32 s4, s3, 9
		s_lshl_b32 s1, s1, 10
		s_lshl_b32 s3, s3, 6
		s_add_i32 s5, s1, s3
		s_lshl_b32 s0, s0, 8
		v_and_b32_e32 v7, 39, v0
		v_lshl_add_u32 v8, v3, 12, s0
		v_and_or_b32 v9, 1, v4, v7
		v_add_u32_e32 v8, s3, v8
		s_mov_b32 s14, 0
		s_add_i32 s5, s5, s0
		v_mov_b64_e32 v[12:13], 0
		v_mov_b64_e32 v[14:15], 0
		v_cmp_eq_u32_e64 vcc, v9, s14
		s_mov_b64 s[40:41], vcc
		v_lshl_add_u32 v9, v3, 12, s5
		v_add3_u32 v10, s1, 16, v8
		v_add3_u32 v11, s1, 32, v8
		v_add3_u32 v8, s1, 48, v8
		s_mov_b32 s30, 0x7fffffff
		s_mov_b32 s28, s10
		s_mov_b32 s29, s11
		s_mov_b32 s44, s8
		s_mov_b32 s45, s9
		s_mov_b32 s46, s30
		s_mov_b32 s47, s35
		s_mov_b32 s18, 0x20000
		s_mov_b32 s19, s35
		s_and_saveexec_b64 s[54:55], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_0
		s_add_i32 m0, s4, 0x20000
		s_nop 0
		buffer_load_dwordx4 v9, s[44:47], 0 offen lds
		s_add_i32 m0, s4, 0x20010
		s_nop 0
		buffer_load_dwordx4 v10, s[44:47], 0 offen lds
		s_add_i32 m0, s4, 0x20020
		s_nop 0
		buffer_load_dwordx4 v11, s[44:47], 0 offen lds
		s_add_i32 m0, s4, 0x20030
		s_nop 0
		buffer_load_dwordx4 v8, s[44:47], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_0:
		s_andn2_b64 exec, s[54:55], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_0
.Lwmma_f16_matmul_tiled.exec_endif_0:
		s_mov_b64 exec, s[54:55]
		v_lshrrev_b32_e32 v8, 1, v4
		v_or_b32_e32 v7, v7, v8
		v_cmp_eq_u32_e64 vcc, v7, s14
		s_mov_b64 s[8:9], vcc
		s_and_b32 s5, s6, 1
		s_lshl_b32 s6, s5, 10
		s_lshl_b32 s10, s13, 8
		s_lshl_b32 s5, s5, 7
		s_add_i32 s11, s10, s5
		v_lshl_add_u32 v7, v3, 12, s11
		s_add_i32 s11, s10, 16
		s_add_i32 s11, s11, s5
		v_lshl_add_u32 v8, v3, 12, s11
		v_lshl_add_u32 v9, v3, 12, s5
		v_add3_u32 v10, s10, 32, v9
		v_add3_u32 v11, s10, 48, v9
		v_add3_u32 v9, s10, 64, v9
		v_lshl_add_u32 v16, v3, 12, s5
		v_add_u32_e32 v16, s10, v16
		v_add_u32_e32 v17, 0x50, v16
		v_add_u32_e32 v18, 0x60, v16
		v_add_u32_e32 v16, 0x70, v16
		s_and_saveexec_b64 s[54:55], s[8:9]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_1
		s_add_i32 m0, s6, 0x20800
		s_nop 0
		buffer_load_dwordx4 v7, s[28:31], 0 offen lds
		s_add_i32 m0, s6, 0x20810
		s_nop 0
		buffer_load_dwordx4 v8, s[28:31], 0 offen lds
		s_add_i32 m0, s6, 0x20820
		s_nop 0
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		s_add_i32 m0, s6, 0x20830
		s_nop 0
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		s_add_i32 m0, s6, 0x20a00
		s_nop 0
		buffer_load_dwordx4 v9, s[28:31], 0 offen lds
		s_add_i32 m0, s6, 0x20a10
		s_nop 0
		buffer_load_dwordx4 v17, s[28:31], 0 offen lds
		s_add_i32 m0, s6, 0x20a20
		s_nop 0
		buffer_load_dwordx4 v18, s[28:31], 0 offen lds
		s_add_i32 m0, s6, 0x20a30
		s_nop 0
		buffer_load_dwordx4 v16, s[28:31], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_1:
		s_andn2_b64 exec, s[54:55], s[8:9]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_1
.Lwmma_f16_matmul_tiled.exec_endif_1:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s11, s1, 0x4000
		s_add_i32 s11, s11, s3
		s_add_i32 s11, s11, s0
		v_lshl_add_u32 v7, v3, 12, s11
		v_lshl_add_u32 v8, v3, 12, s0
		v_add_u32_e32 v8, s3, v8
		v_add_u32_e32 v8, s1, v8
		v_add_u32_e32 v9, 0x4010, v8
		v_add_u32_e32 v10, 0x4020, v8
		v_add_u32_e32 v8, 0x4030, v8
		s_and_saveexec_b64 s[54:55], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_2
		s_add_i32 m0, s4, 0x21000
		s_nop 0
		buffer_load_dwordx4 v7, s[44:47], 0 offen lds
		s_add_i32 m0, s4, 0x21010
		s_nop 0
		buffer_load_dwordx4 v9, s[44:47], 0 offen lds
		s_add_i32 m0, s4, 0x21020
		s_nop 0
		buffer_load_dwordx4 v10, s[44:47], 0 offen lds
		s_add_i32 m0, s4, 0x21030
		s_nop 0
		buffer_load_dwordx4 v8, s[44:47], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_2:
		s_andn2_b64 exec, s[54:55], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_2
.Lwmma_f16_matmul_tiled.exec_endif_2:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s11, s10, 0x4000
		s_add_i32 s11, s11, s5
		v_lshl_add_u32 v7, v3, 12, s11
		s_add_i32 s11, s10, 0x4010
		s_add_i32 s11, s11, s5
		v_lshl_add_u32 v8, v3, 12, s11
		v_lshl_add_u32 v9, v3, 12, s5
		v_add_u32_e32 v9, s10, v9
		v_add_u32_e32 v10, 0x4020, v9
		v_add_u32_e32 v11, 0x4030, v9
		v_add_u32_e32 v9, 0x4040, v9
		v_lshl_add_u32 v16, v3, 12, s5
		v_add_u32_e32 v16, s10, v16
		v_add_u32_e32 v17, 0x4050, v16
		v_add_u32_e32 v18, 0x4060, v16
		v_add_u32_e32 v16, 0x4070, v16
		s_and_saveexec_b64 s[54:55], s[8:9]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_3
		s_add_i32 m0, s6, 0x21800
		s_nop 0
		buffer_load_dwordx4 v7, s[28:31], 0 offen lds
		s_add_i32 m0, s6, 0x21810
		s_nop 0
		buffer_load_dwordx4 v8, s[28:31], 0 offen lds
		s_add_i32 m0, s6, 0x21820
		s_nop 0
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		s_add_i32 m0, s6, 0x21830
		s_nop 0
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		s_add_i32 m0, s6, 0x21a00
		s_nop 0
		buffer_load_dwordx4 v9, s[28:31], 0 offen lds
		s_add_i32 m0, s6, 0x21a10
		s_nop 0
		buffer_load_dwordx4 v17, s[28:31], 0 offen lds
		s_add_i32 m0, s6, 0x21a20
		s_nop 0
		buffer_load_dwordx4 v18, s[28:31], 0 offen lds
		s_add_i32 m0, s6, 0x21a30
		s_nop 0
		buffer_load_dwordx4 v16, s[28:31], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_3:
		s_andn2_b64 exec, s[54:55], s[8:9]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_3
.Lwmma_f16_matmul_tiled.exec_endif_3:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s11, s1, 0x8000
		s_add_i32 s11, s11, s3
		s_add_i32 s11, s11, s0
		v_lshl_add_u32 v7, v3, 12, s11
		v_lshl_add_u32 v8, v3, 12, s0
		v_add_u32_e32 v8, s3, v8
		v_add_u32_e32 v8, s1, v8
		v_add_u32_e32 v9, 0x8010, v8
		v_add_u32_e32 v10, 0x8020, v8
		v_add_u32_e32 v8, 0x8030, v8
		s_and_saveexec_b64 s[54:55], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_4
		s_add_i32 m0, s4, 0x22000
		s_nop 0
		buffer_load_dwordx4 v7, s[44:47], 0 offen lds
		s_add_i32 m0, s4, 0x22010
		s_nop 0
		buffer_load_dwordx4 v9, s[44:47], 0 offen lds
		s_add_i32 m0, s4, 0x22020
		s_nop 0
		buffer_load_dwordx4 v10, s[44:47], 0 offen lds
		s_add_i32 m0, s4, 0x22030
		s_nop 0
		buffer_load_dwordx4 v8, s[44:47], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_4:
		s_andn2_b64 exec, s[54:55], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_4
.Lwmma_f16_matmul_tiled.exec_endif_4:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s11, s10, 0x8000
		s_add_i32 s11, s11, s5
		v_lshl_add_u32 v7, v3, 12, s11
		s_add_i32 s11, s10, 0x8010
		s_add_i32 s11, s11, s5
		v_lshl_add_u32 v8, v3, 12, s11
		v_lshl_add_u32 v9, v3, 12, s5
		v_add_u32_e32 v9, s10, v9
		v_add_u32_e32 v10, 0x8020, v9
		v_add_u32_e32 v11, 0x8030, v9
		v_add_u32_e32 v9, 0x8040, v9
		v_lshl_add_u32 v16, v3, 12, s5
		v_add_u32_e32 v16, s10, v16
		v_add_u32_e32 v17, 0x8050, v16
		v_add_u32_e32 v18, 0x8060, v16
		v_add_u32_e32 v16, 0x8070, v16
		s_and_saveexec_b64 s[54:55], s[8:9]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_5
		s_add_i32 m0, s6, 0x22800
		s_nop 0
		buffer_load_dwordx4 v7, s[28:31], 0 offen lds
		s_add_i32 m0, s6, 0x22810
		s_nop 0
		buffer_load_dwordx4 v8, s[28:31], 0 offen lds
		s_add_i32 m0, s6, 0x22820
		s_nop 0
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		s_add_i32 m0, s6, 0x22830
		s_nop 0
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		s_add_i32 m0, s6, 0x22a00
		s_nop 0
		buffer_load_dwordx4 v9, s[28:31], 0 offen lds
		s_add_i32 m0, s6, 0x22a10
		s_nop 0
		buffer_load_dwordx4 v17, s[28:31], 0 offen lds
		s_add_i32 m0, s6, 0x22a20
		s_nop 0
		buffer_load_dwordx4 v18, s[28:31], 0 offen lds
		s_add_i32 m0, s6, 0x22a30
		s_nop 0
		buffer_load_dwordx4 v16, s[28:31], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_5:
		s_andn2_b64 exec, s[54:55], s[8:9]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_5
.Lwmma_f16_matmul_tiled.exec_endif_5:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s11, s1, 0xc000
		s_add_i32 s11, s11, s3
		s_add_i32 s11, s11, s0
		v_lshl_add_u32 v7, v3, 12, s11
		v_lshl_add_u32 v8, v3, 12, s0
		v_add_u32_e32 v8, s3, v8
		v_add_u32_e32 v8, s1, v8
		v_add_u32_e32 v9, 0xc010, v8
		v_add_u32_e32 v10, 0xc020, v8
		v_add_u32_e32 v8, 0xc030, v8
		s_and_saveexec_b64 s[54:55], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_6
		s_add_i32 m0, s4, 0x23000
		s_nop 0
		buffer_load_dwordx4 v7, s[44:47], 0 offen lds
		s_add_i32 m0, s4, 0x23010
		s_nop 0
		buffer_load_dwordx4 v9, s[44:47], 0 offen lds
		s_add_i32 m0, s4, 0x23020
		s_nop 0
		buffer_load_dwordx4 v10, s[44:47], 0 offen lds
		s_add_i32 m0, s4, 0x23030
		s_nop 0
		buffer_load_dwordx4 v8, s[44:47], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_6:
		s_andn2_b64 exec, s[54:55], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_6
.Lwmma_f16_matmul_tiled.exec_endif_6:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s11, s10, 0xc000
		s_add_i32 s11, s11, s5
		v_lshl_add_u32 v7, v3, 12, s11
		s_add_i32 s11, s10, 0xc010
		s_add_i32 s11, s11, s5
		v_lshl_add_u32 v8, v3, 12, s11
		v_lshl_add_u32 v9, v3, 12, s5
		v_add_u32_e32 v9, s10, v9
		v_add_u32_e32 v10, 0xc020, v9
		v_add_u32_e32 v11, 0xc030, v9
		v_add_u32_e32 v9, 0xc040, v9
		v_lshl_add_u32 v16, v3, 12, s5
		v_add_u32_e32 v16, s10, v16
		v_add_u32_e32 v17, 0xc050, v16
		v_add_u32_e32 v18, 0xc060, v16
		v_add_u32_e32 v16, 0xc070, v16
		s_and_saveexec_b64 s[54:55], s[8:9]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_7
		s_add_i32 m0, s6, 0x23800
		s_nop 0
		buffer_load_dwordx4 v7, s[28:31], 0 offen lds
		s_add_i32 m0, s6, 0x23810
		s_nop 0
		buffer_load_dwordx4 v8, s[28:31], 0 offen lds
		s_add_i32 m0, s6, 0x23820
		s_nop 0
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		s_add_i32 m0, s6, 0x23830
		s_nop 0
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		s_add_i32 m0, s6, 0x23a00
		s_nop 0
		buffer_load_dwordx4 v9, s[28:31], 0 offen lds
		s_add_i32 m0, s6, 0x23a10
		s_nop 0
		buffer_load_dwordx4 v17, s[28:31], 0 offen lds
		s_add_i32 m0, s6, 0x23a20
		s_nop 0
		buffer_load_dwordx4 v18, s[28:31], 0 offen lds
		s_add_i32 m0, s6, 0x23a30
		s_nop 0
		buffer_load_dwordx4 v16, s[28:31], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_7:
		s_andn2_b64 exec, s[54:55], s[8:9]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_7
.Lwmma_f16_matmul_tiled.exec_endif_7:
		s_mov_b64 exec, s[54:55]
		s_add_i32 m0, s7, 0x10000
		s_add_i32 s11, s25, 0x80
		s_add_i32 s11, s11, s26
		v_add_u32_e32 v7, s11, v2
		buffer_load_dwordx4 v7, s[32:35], 0 offen lds
		s_add_i32 m0, s7, 0x12000
		v_add_u32_e32 v7, s26, v2
		v_add_u32_e32 v7, s25, v7
		v_add_u32_e32 v8, 0x80080, v7
		buffer_load_dwordx4 v8, s[32:35], 0 offen lds
		s_add_i32 m0, s7, 0x14000
		v_add_u32_e32 v8, 0xc0, v7
		buffer_load_dwordx4 v8, s[32:35], 0 offen lds
		s_add_i32 m0, s7, 0x16000
		v_add_u32_e32 v7, 0x800c0, v7
		buffer_load_dwordx4 v7, s[32:35], 0 offen lds
		s_add_i32 m0, s7, 0x18000
		s_add_i32 s11, s2, 0x80
		v_add_u32_e32 v7, s11, v2
		buffer_load_dwordx4 v7, s[36:39], 0 offen lds
		s_add_i32 m0, s7, 0x1a000
		v_add_u32_e32 v2, s2, v2
		v_add_u32_e32 v7, 0x80080, v2
		buffer_load_dwordx4 v7, s[36:39], 0 offen lds
		s_add_i32 m0, s7, 0x1c000
		v_add_u32_e32 v7, 0xc0, v2
		buffer_load_dwordx4 v7, s[36:39], 0 offen lds
		s_add_i32 m0, s7, 0x1e000
		v_add_u32_e32 v2, 0x800c0, v2
		buffer_load_dwordx4 v2, s[36:39], 0 offen lds
		s_waitcnt vmcnt(8)
		s_barrier
		s_add_i32 s2, s1, 0x10000
		s_add_i32 s2, s2, s3
		s_add_i32 s2, s2, s0
		v_and_b32_e32 v2, 15, v0
		s_add_i32 s11, s1, 0x10010
		s_add_i32 s11, s11, s3
		s_add_i32 s11, s11, s0
		s_add_i32 s13, s1, 0x10020
		v_lshrrev_b32_e32 v7, 1, v2
		s_add_i32 s13, s13, s3
		s_add_i32 s13, s13, s0
		s_add_i32 s25, s1, 0x10030
		s_add_i32 s25, s25, s3
		v_lshrrev_b32_e32 v8, 4, v1
		v_and_b32_e32 v7, 3, v7
		s_add_i32 s25, s25, s0
		s_add_i32 s26, s10, 0x10000
		s_add_i32 s26, s26, s5
		s_add_i32 s27, s10, 0x10010
		v_lshrrev_b32_e32 v0, 7, v0
		v_xor_b32_e32 v7, v8, v7
		v_and_b32_e32 v8, 1, v4
		s_add_i32 s27, s27, s5
		s_add_i32 s42, s1, 0x14000
		s_add_i32 s42, s42, s3
		s_add_i32 s42, s42, s0
		v_lshlrev_b32_e32 v9, 12, v0
		v_lshlrev_b32_e32 v2, 6, v2
		v_lshlrev_b32_e32 v7, 4, v7
		v_lshlrev_b32_e32 v10, 13, v8
		s_add_i32 s43, s1, 0x14010
		s_add_i32 s43, s43, s3
		s_add_i32 s43, s43, s0
		s_add_i32 s48, s1, 0x14020
		v_add3_u32 v11, v9, v2, v7
		v_add3_u32 v16, v2, v10, v7
		s_add_i32 s48, s48, s3
		s_add_i32 s48, s48, s0
		s_add_i32 s1, s1, 0x14030
		s_add_i32 s1, s1, s3
		ds_read_b128 v[20:23], v11
		ds_read_b128 v[24:27], v11 offset:1024
		ds_read_b128 v[28:31], v11 offset:2048
		ds_read_b128 v[32:35], v11 offset:3072
		ds_read_b128 v[36:39], v11 offset:16384
		ds_read_b128 v[40:43], v11 offset:17408
		ds_read_b128 v[44:47], v11 offset:18432
		ds_read_b128 v[48:51], v11 offset:19456
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
		s_add_i32 s0, s1, s0
		v_add_u32_e32 v11, 0x100, v5
		v_add_u32_e32 v16, 0x80100, v5
		v_add_u32_e32 v17, 0x140, v5
		v_add_u32_e32 v18, 0x80140, v5
		v_add_u32_e32 v5, 0x100, v6
		v_add_u32_e32 v19, 0x80100, v6
		v_add_u32_e32 v116, 0x140, v6
		v_add_u32_e32 v117, 0x80140, v6
		v_lshlrev_b32_e32 v0, 9, v0
		v_lshlrev_b32_e32 v1, 3, v1
		v_lshlrev_b32_e32 v6, 10, v8
		s_add_i32 s1, s10, 0x14000
		s_add_i32 s1, s1, s5
		s_add_i32 s3, s10, 0x14010
		s_add_i32 s3, s3, s5
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
		s_lshl_b32 s49, s14, 7
		s_waitcnt vmcnt(8) lgkmcnt(0)
		s_barrier
		s_and_b32 s50, s14, 1
		s_lshl_b32 s50, s50, 13
		s_add_i32 s51, s50, 0x20000
		v_add3_u32 v118, s51, v0, v1
		ds_read_b64_tr_b8 v[244:245], v118
		v_add3_u32 v119, s51, v1, v6
		ds_read_b64_tr_b8 v[246:247], v119 offset:2048
		ds_read_b64_tr_b8 v[248:249], v119 offset:2560
		ds_read_b64_tr_b8 v[250:251], v118 offset:4096
		ds_read_b64_tr_b8 v[252:253], v119 offset:6144
		ds_read_b64_tr_b8 v[254:255], v119 offset:6656
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[20:23], v[52:55], v[12:15], v244, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], v[56:59], v[120:123], v244, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], v[60:63], v[124:127], v244, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[20:23], v[64:67], v[128:131], v244, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[52:55], v[148:151], v244, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[56:59], v[152:155], v244, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[60:63], v[156:159], v244, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[24:27], v[64:67], v[160:163], v244, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[52:55], v[180:183], v244, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[56:59], v[184:187], v244, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[60:63], v[188:191], v244, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[28:31], v[64:67], v[192:195], v244, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[52:55], v[212:215], v244, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[56:59], v[216:219], v244, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], v[60:63], v[220:223], v244, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[32:35], v[64:67], v[224:227], v244, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[36:39], v[84:87], v[12:15], v250, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[36:39], v[88:91], v[120:123], v250, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[36:39], v[92:95], v[124:127], v250, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[36:39], v[96:99], v[128:131], v250, v252 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[40:43], v[84:87], v[148:151], v250, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[40:43], v[88:91], v[152:155], v250, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[40:43], v[92:95], v[156:159], v250, v252 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[40:43], v[96:99], v[160:163], v250, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[44:47], v[84:87], v[180:183], v250, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[44:47], v[88:91], v[184:187], v250, v252 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[44:47], v[92:95], v[188:191], v250, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[44:47], v[96:99], v[192:195], v250, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[48:51], v[84:87], v[212:215], v250, v252 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[48:51], v[88:91], v[216:219], v250, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[48:51], v[92:95], v[220:223], v250, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[48:51], v[96:99], v[224:227], v250, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s51, s4, s50
		s_lshl_b32 s52, s14, 15
		s_add_i32 s53, s2, s52
		v_lshl_add_u32 v52, v3, 12, s53
		s_add_i32 s53, s11, s52
		v_lshl_add_u32 v53, v3, 12, s53
		s_add_i32 s53, s13, s52
		v_lshl_add_u32 v54, v3, 12, s53
		s_add_i32 s53, s25, s52
		v_lshl_add_u32 v55, v3, 12, s53
		s_and_saveexec_b64 s[54:55], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_8
		s_add_i32 m0, s51, 0x20000
		s_nop 0
		buffer_load_dwordx4 v52, s[44:47], 0 offen lds
		s_add_i32 m0, s51, 0x20010
		s_nop 0
		buffer_load_dwordx4 v53, s[44:47], 0 offen lds
		s_add_i32 m0, s51, 0x20020
		s_nop 0
		buffer_load_dwordx4 v54, s[44:47], 0 offen lds
		s_add_i32 m0, s51, 0x20030
		s_nop 0
		buffer_load_dwordx4 v55, s[44:47], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_8:
		s_andn2_b64 exec, s[54:55], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_8
.Lwmma_f16_matmul_tiled.exec_endif_8:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s50, s6, s50
		s_add_i32 s53, s26, s52
		v_lshl_add_u32 v52, v3, 12, s53
		s_add_i32 s53, s27, s52
		v_lshl_add_u32 v53, v3, 12, s53
		v_lshl_add_u32 v54, v3, 12, s52
		v_add_u32_e32 v54, s5, v54
		v_add_u32_e32 v54, s10, v54
		v_add_u32_e32 v55, 0x10020, v54
		v_add_u32_e32 v56, 0x10030, v54
		v_add_u32_e32 v54, 0x10040, v54
		v_lshl_add_u32 v57, v3, 12, s52
		v_add_u32_e32 v57, s5, v57
		v_add_u32_e32 v57, s10, v57
		v_add_u32_e32 v58, 0x10050, v57
		v_add_u32_e32 v59, 0x10060, v57
		v_add_u32_e32 v57, 0x10070, v57
		s_and_saveexec_b64 s[54:55], s[8:9]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_9
		s_add_i32 m0, s50, 0x20800
		s_nop 0
		buffer_load_dwordx4 v52, s[28:31], 0 offen lds
		s_add_i32 m0, s50, 0x20810
		s_nop 0
		buffer_load_dwordx4 v53, s[28:31], 0 offen lds
		s_add_i32 m0, s50, 0x20820
		s_nop 0
		buffer_load_dwordx4 v55, s[28:31], 0 offen lds
		s_add_i32 m0, s50, 0x20830
		s_nop 0
		buffer_load_dwordx4 v56, s[28:31], 0 offen lds
		s_add_i32 m0, s50, 0x20a00
		s_nop 0
		buffer_load_dwordx4 v54, s[28:31], 0 offen lds
		s_add_i32 m0, s50, 0x20a10
		s_nop 0
		buffer_load_dwordx4 v58, s[28:31], 0 offen lds
		s_add_i32 m0, s50, 0x20a20
		s_nop 0
		buffer_load_dwordx4 v59, s[28:31], 0 offen lds
		s_add_i32 m0, s50, 0x20a30
		s_nop 0
		buffer_load_dwordx4 v57, s[28:31], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_9:
		s_andn2_b64 exec, s[54:55], s[8:9]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_9
.Lwmma_f16_matmul_tiled.exec_endif_9:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s53, s42, s52
		v_lshl_add_u32 v52, v3, 12, s53
		s_add_i32 s53, s43, s52
		v_lshl_add_u32 v53, v3, 12, s53
		s_add_i32 s53, s48, s52
		v_lshl_add_u32 v54, v3, 12, s53
		s_add_i32 s53, s0, s52
		v_lshl_add_u32 v55, v3, 12, s53
		s_and_saveexec_b64 s[54:55], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_10
		s_add_i32 m0, s51, 0x21000
		s_nop 0
		buffer_load_dwordx4 v52, s[44:47], 0 offen lds
		s_add_i32 m0, s51, 0x21010
		s_nop 0
		buffer_load_dwordx4 v53, s[44:47], 0 offen lds
		s_add_i32 m0, s51, 0x21020
		s_nop 0
		buffer_load_dwordx4 v54, s[44:47], 0 offen lds
		s_add_i32 m0, s51, 0x21030
		s_nop 0
		buffer_load_dwordx4 v55, s[44:47], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_10:
		s_andn2_b64 exec, s[54:55], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_10
.Lwmma_f16_matmul_tiled.exec_endif_10:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s51, s1, s52
		v_lshl_add_u32 v52, v3, 12, s51
		s_add_i32 s51, s3, s52
		v_lshl_add_u32 v53, v3, 12, s51
		v_lshl_add_u32 v54, v3, 12, s52
		v_add_u32_e32 v54, s5, v54
		v_add_u32_e32 v54, s10, v54
		v_add_u32_e32 v55, 0x14020, v54
		v_add_u32_e32 v56, 0x14030, v54
		v_add_u32_e32 v54, 0x14040, v54
		v_lshl_add_u32 v57, v3, 12, s52
		v_add_u32_e32 v57, s5, v57
		v_add_u32_e32 v57, s10, v57
		v_add_u32_e32 v58, 0x14050, v57
		v_add_u32_e32 v59, 0x14060, v57
		v_add_u32_e32 v57, 0x14070, v57
		s_and_saveexec_b64 s[54:55], s[8:9]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_11
		s_add_i32 m0, s50, 0x21800
		s_nop 0
		buffer_load_dwordx4 v52, s[28:31], 0 offen lds
		s_add_i32 m0, s50, 0x21810
		s_nop 0
		buffer_load_dwordx4 v53, s[28:31], 0 offen lds
		s_add_i32 m0, s50, 0x21820
		s_nop 0
		buffer_load_dwordx4 v55, s[28:31], 0 offen lds
		s_add_i32 m0, s50, 0x21830
		s_nop 0
		buffer_load_dwordx4 v56, s[28:31], 0 offen lds
		s_add_i32 m0, s50, 0x21a00
		s_nop 0
		buffer_load_dwordx4 v54, s[28:31], 0 offen lds
		s_add_i32 m0, s50, 0x21a10
		s_nop 0
		buffer_load_dwordx4 v58, s[28:31], 0 offen lds
		s_add_i32 m0, s50, 0x21a20
		s_nop 0
		buffer_load_dwordx4 v59, s[28:31], 0 offen lds
		s_add_i32 m0, s50, 0x21a30
		s_nop 0
		buffer_load_dwordx4 v57, s[28:31], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_11:
		s_andn2_b64 exec, s[54:55], s[8:9]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_11
.Lwmma_f16_matmul_tiled.exec_endif_11:
		s_mov_b64 exec, s[54:55]
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[20:23], v[68:71], v[132:135], v244, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[20:23], v[72:75], v[136:139], v244, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[20:23], v[76:79], v[140:143], v244, v248 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[20:23], v[80:83], v[144:147], v244, v248 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[24:27], v[68:71], v[164:167], v244, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[24:27], v[72:75], v[168:171], v244, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[24:27], v[76:79], v[172:175], v244, v248 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[24:27], v[80:83], v[176:179], v244, v248 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], v[68:71], v[196:199], v244, v248 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[28:31], v[72:75], v[200:203], v244, v248 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[28:31], v[76:79], v[204:207], v244, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[28:31], v[80:83], v[208:211], v244, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], v[68:71], v[228:231], v244, v248 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[32:35], v[72:75], v[232:235], v244, v248 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[32:35], v[76:79], v[236:239], v244, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[32:35], v[80:83], v[240:243], v244, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[36:39], v[100:103], v[132:135], v250, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[36:39], v[104:107], v[136:139], v250, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[36:39], v[108:111], v[140:143], v250, v254 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[36:39], v[112:115], v[144:147], v250, v254 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[40:43], v[100:103], v[164:167], v250, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[40:43], v[104:107], v[168:171], v250, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[40:43], v[108:111], v[172:175], v250, v254 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[40:43], v[112:115], v[176:179], v250, v254 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[44:47], v[100:103], v[196:199], v250, v254 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[44:47], v[104:107], v[200:203], v250, v254 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[44:47], v[108:111], v[204:207], v250, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[44:47], v[112:115], v[208:211], v250, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s7
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[48:51], v[100:103], v[228:231], v250, v254 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v11, s[32:35], s49 offen lds
		s_mov_b32 m0, s12
		s_nop 0
		buffer_load_dwordx4 v16, s[32:35], s49 offen lds
		s_mov_b32 m0, s15
		s_nop 0
		buffer_load_dwordx4 v17, s[32:35], s49 offen lds
		s_mov_b32 m0, s20
		s_nop 0
		buffer_load_dwordx4 v18, s[32:35], s49 offen lds
		s_mov_b32 m0, s21
		s_nop 0
		buffer_load_dwordx4 v5, s[36:39], s49 offen lds
		s_mov_b32 m0, s22
		s_nop 0
		buffer_load_dwordx4 v19, s[36:39], s49 offen lds
		s_mov_b32 m0, s23
		s_nop 0
		buffer_load_dwordx4 v116, s[36:39], s49 offen lds
		s_mov_b32 m0, s24
		s_nop 0
		buffer_load_dwordx4 v117, s[36:39], s49 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[48:51], v[104:107], v[232:235], v250, v254 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[48:51], v[108:111], v[236:239], v250, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[48:51], v[112:115], v[240:243], v250, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(8)
		s_barrier
		s_add_i32 s14, s14, 1
		s_and_b32 s49, s14, 1
		s_lshl_b32 s49, s49, 16
		v_add_u32_e32 v20, s49, v9
		v_add3_u32 v52, v20, v2, v7
		ds_read_b128 v[20:23], v52
		ds_read_b128 v[24:27], v52 offset:1024
		ds_read_b128 v[28:31], v52 offset:2048
		ds_read_b128 v[32:35], v52 offset:3072
		ds_read_b128 v[36:39], v52 offset:16384
		ds_read_b128 v[40:43], v52 offset:17408
		ds_read_b128 v[44:47], v52 offset:18432
		ds_read_b128 v[48:51], v52 offset:19456
		v_add_u32_e32 v52, s49, v2
		v_add3_u32 v118, v52, v10, v7
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
		s_add_i32 s7, s7, 0x10000
		s_and_b32 s7, s7, 0x1ffff
		s_add_i32 s12, s12, 0x10000
		s_and_b32 s12, s12, 0x1ffff
		s_add_i32 s15, s15, 0x10000
		s_and_b32 s15, s15, 0x1ffff
		s_add_i32 s20, s20, 0x10000
		s_and_b32 s20, s20, 0x1ffff
		s_add_i32 s21, s21, 0x10000
		s_and_b32 s21, s21, 0x1ffff
		s_add_i32 s22, s22, 0x10000
		s_and_b32 s22, s22, 0x1ffff
		s_add_i32 s23, s23, 0x10000
		s_and_b32 s23, s23, 0x1ffff
		s_add_i32 s24, s24, 0x10000
		s_and_b32 s24, s24, 0x1ffff
		s_cmp_lt_i32 s14, 30
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(0)
		s_barrier
		v_add_u32_e32 v0, 0x20000, v0
		v_add_u32_e32 v0, v0, v1
		ds_read_b64_tr_b8 v[16:17], v0
		ds_read_b64_tr_b8 v[18:19], v0 offset:4096
		v_add_u32_e32 v3, 0x20000, v1
		v_lshl_add_u32 v3, v8, 10, v3
		ds_read_b64_tr_b8 v[116:117], v3 offset:2048
		ds_read_b64_tr_b8 v[118:119], v3 offset:2560
		ds_read_b64_tr_b8 v[244:245], v3 offset:6144
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[20:23], v[52:55], v[12:15], v16, v116 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b64_tr_b8 v[246:247], v3 offset:6656
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], v[56:59], v[120:123], v16, v116 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], v[60:63], v[124:127], v16, v116 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[20:23], v[64:67], v[128:131], v16, v116 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[52:55], v[148:151], v16, v116 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[56:59], v[152:155], v16, v116 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[60:63], v[156:159], v16, v116 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[24:27], v[64:67], v[160:163], v16, v116 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[52:55], v[180:183], v16, v116 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[56:59], v[184:187], v16, v116 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[60:63], v[188:191], v16, v116 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[28:31], v[64:67], v[192:195], v16, v116 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[52:55], v[212:215], v16, v116 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[56:59], v[216:219], v16, v116 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], v[60:63], v[220:223], v16, v116 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[32:35], v[64:67], v[224:227], v16, v116 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[20:23], v[68:71], v[132:135], v16, v118 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[20:23], v[72:75], v[136:139], v16, v118 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[20:23], v[76:79], v[140:143], v16, v118 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[20:23], v[80:83], v[144:147], v16, v118 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[24:27], v[68:71], v[164:167], v16, v118 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[24:27], v[72:75], v[168:171], v16, v118 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[24:27], v[76:79], v[172:175], v16, v118 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[24:27], v[80:83], v[176:179], v16, v118 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], v[68:71], v[196:199], v16, v118 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[28:31], v[72:75], v[200:203], v16, v118 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[28:31], v[76:79], v[204:207], v16, v118 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[28:31], v[80:83], v[208:211], v16, v118 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], v[68:71], v[228:231], v16, v118 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[32:35], v[72:75], v[232:235], v16, v118 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[32:35], v[76:79], v[236:239], v16, v118 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[32:35], v[80:83], v[240:243], v16, v118 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[36:39], v[84:87], v[12:15], v18, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[36:39], v[88:91], v[120:123], v18, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[36:39], v[92:95], v[124:127], v18, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[36:39], v[96:99], v[128:131], v18, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[40:43], v[84:87], v[148:151], v18, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[40:43], v[88:91], v[152:155], v18, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[40:43], v[92:95], v[156:159], v18, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[40:43], v[96:99], v[160:163], v18, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[44:47], v[84:87], v[180:183], v18, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[44:47], v[88:91], v[184:187], v18, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[44:47], v[92:95], v[188:191], v18, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[44:47], v[96:99], v[192:195], v18, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[48:51], v[84:87], v[212:215], v18, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[48:51], v[88:91], v[216:219], v18, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[48:51], v[92:95], v[220:223], v18, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[48:51], v[96:99], v[224:227], v18, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[36:39], v[100:103], v[132:135], v18, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[36:39], v[104:107], v[136:139], v18, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[36:39], v[108:111], v[140:143], v18, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[36:39], v[112:115], v[144:147], v18, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[40:43], v[100:103], v[164:167], v18, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[40:43], v[104:107], v[168:171], v18, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[40:43], v[108:111], v[172:175], v18, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[40:43], v[112:115], v[176:179], v18, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[44:47], v[100:103], v[196:199], v18, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[44:47], v[104:107], v[200:203], v18, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[44:47], v[108:111], v[204:207], v18, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[44:47], v[112:115], v[208:211], v18, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[48:51], v[100:103], v[228:231], v18, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[48:51], v[104:107], v[232:235], v18, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[48:51], v[108:111], v[236:239], v18, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[48:51], v[112:115], v[240:243], v18, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x10000, v9
		v_add3_u32 v5, v5, v2, v7
		ds_read_b128 v[16:19], v5
		ds_read_b128 v[20:23], v5 offset:1024
		ds_read_b128 v[24:27], v5 offset:2048
		ds_read_b128 v[28:31], v5 offset:3072
		ds_read_b128 v[32:35], v5 offset:16384
		ds_read_b128 v[36:39], v5 offset:17408
		ds_read_b128 v[40:43], v5 offset:18432
		ds_read_b128 v[44:47], v5 offset:19456
		v_add_u32_e32 v2, 0x10000, v2
		v_add3_u32 v2, v2, v10, v7
		ds_read_b128 v[8:11], v2 offset:32768
		ds_read_b128 v[48:51], v2 offset:33792
		ds_read_b128 v[52:55], v2 offset:34816
		ds_read_b128 v[56:59], v2 offset:35840
		ds_read_b128 v[60:63], v2 offset:36864
		ds_read_b128 v[64:67], v2 offset:37888
		ds_read_b128 v[68:71], v2 offset:38912
		ds_read_b128 v[72:75], v2 offset:39936
		ds_read_b128 v[76:79], v2 offset:49152
		ds_read_b128 v[80:83], v2 offset:50176
		ds_read_b128 v[84:87], v2 offset:51200
		ds_read_b128 v[88:91], v2 offset:52224
		ds_read_b128 v[92:95], v2 offset:53248
		ds_read_b128 v[96:99], v2 offset:54272
		ds_read_b128 v[100:103], v2 offset:55296
		ds_read_b128 v[104:107], v2 offset:56320
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[6:7], v0 offset:8192
		ds_read_b64_tr_b8 v[108:109], v3 offset:10240
		ds_read_b64_tr_b8 v[110:111], v3 offset:10752
		ds_read_b64_tr_b8 v[112:113], v0 offset:12288
		ds_read_b64_tr_b8 v[114:115], v3 offset:14336
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[16:19], v[8:11], v[12:15], v6, v108 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b64_tr_b8 v[116:117], v3 offset:14848
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[16:19], v[48:51], v[120:123], v6, v108 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[52:55], v[124:127], v6, v108 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[56:59], v[128:131], v6, v108 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], v[8:11], v[148:151], v6, v108 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[48:51], v[152:155], v6, v108 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[52:55], v[156:159], v6, v108 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[56:59], v[160:163], v6, v108 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[8:11], v[180:183], v6, v108 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[48:51], v[184:187], v6, v108 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[52:55], v[188:191], v6, v108 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[56:59], v[192:195], v6, v108 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[8:11], v[212:215], v6, v108 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[28:31], v[48:51], v[216:219], v6, v108 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[28:31], v[52:55], v[220:223], v6, v108 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[56:59], v[224:227], v6, v108 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[32:35], v[76:79], v[12:15], v112, v114 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[32:35], v[80:83], v[120:123], v112, v114 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], v[84:87], v[124:127], v112, v114 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[32:35], v[88:91], v[128:131], v112, v114 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[36:39], v[76:79], v[148:151], v112, v114 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[36:39], v[80:83], v[152:155], v112, v114 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[36:39], v[84:87], v[156:159], v112, v114 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[36:39], v[88:91], v[160:163], v112, v114 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[40:43], v[76:79], v[180:183], v112, v114 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[40:43], v[80:83], v[184:187], v112, v114 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[40:43], v[84:87], v[188:191], v112, v114 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[40:43], v[88:91], v[192:195], v112, v114 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[44:47], v[76:79], v[212:215], v112, v114 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[44:47], v[80:83], v[216:219], v112, v114 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[44:47], v[84:87], v[220:223], v112, v114 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[44:47], v[88:91], v[224:227], v112, v114 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[16:19], v[60:63], v[132:135], v6, v110 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v12, v13
		s_mov_b32 s0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[64:67], v[136:139], v6, v110 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v3, v14, v15
		s_mov_b32 s1, 0x2000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[16:19], v[68:71], v[140:143], v6, v110 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_lshl_add_u32 v0, v4, 14, v1
		buffer_store_dwordx2 v[2:3], v0, s[16:19], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[16:19], v[72:75], v[144:147], v6, v110 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v120, v121
		s_mov_b32 s2, 0x3000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[60:63], v[164:167], v6, v110 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v3, v122, v123
		buffer_store_dwordx2 v[2:3], v0, s[16:19], 0 offen offset:512
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[64:67], v[168:171], v6, v110 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v124, v125
		v_cvt_pk_f16_f32 v3, v126, v127
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[68:71], v[172:175], v6, v110 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_store_dwordx2 v[2:3], v0, s[16:19], 0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v128, v129
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[20:23], v[72:75], v[176:179], v6, v110 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v3, v130, v131
		buffer_store_dwordx2 v[2:3], v0, s[16:19], 0 offen offset:1536
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[60:63], v[196:199], v6, v110 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v148, v149
		v_cvt_pk_f16_f32 v3, v150, v151
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[64:67], v[200:203], v6, v110 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen
		v_cvt_pk_f16_f32 v2, v152, v153
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[68:71], v[204:207], v6, v110 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v3, v154, v155
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:512
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], v[72:75], v[208:211], v6, v110 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v156, v157
		v_cvt_pk_f16_f32 v3, v158, v159
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], v[60:63], v[228:231], v6, v110 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v160, v161
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[28:31], v[64:67], v[232:235], v6, v110 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v3, v162, v163
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:1536
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[28:31], v[68:71], v[236:239], v6, v110 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v180, v181
		v_cvt_pk_f16_f32 v3, v182, v183
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[28:31], v[72:75], v[240:243], v6, v110 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s1 offen
		v_cvt_pk_f16_f32 v2, v184, v185
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], v[92:95], v[132:135], v112, v116 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v3, v186, v187
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s1 offen offset:512
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[32:35], v[96:99], v[136:139], v112, v116 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v188, v189
		v_cvt_pk_f16_f32 v3, v190, v191
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[32:35], v[100:103], v[140:143], v112, v116 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s1 offen offset:1024
		v_cvt_pk_f16_f32 v2, v192, v193
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[32:35], v[104:107], v[144:147], v112, v116 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v3, v194, v195
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s1 offen offset:1536
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], v[92:95], v[164:167], v112, v116 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v212, v213
		v_cvt_pk_f16_f32 v3, v214, v215
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], v[96:99], v[168:171], v112, v116 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen
		v_cvt_pk_f16_f32 v2, v216, v217
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[36:39], v[100:103], v[172:175], v112, v116 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v3, v218, v219
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:512
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[36:39], v[104:107], v[176:179], v112, v116 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v220, v221
		v_cvt_pk_f16_f32 v3, v222, v223
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[40:43], v[92:95], v[196:199], v112, v116 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:1024
		v_cvt_pk_f16_f32 v2, v224, v225
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], v[96:99], v[200:203], v112, v116 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v3, v226, v227
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:1536
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[40:43], v[100:103], v[204:207], v112, v116 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v132, v133
		v_cvt_pk_f16_f32 v3, v134, v135
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[40:43], v[104:107], v[208:211], v112, v116 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_store_dwordx2 v[2:3], v0, s[16:19], 0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v136, v137
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[44:47], v[92:95], v[228:231], v112, v116 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v3, v138, v139
		buffer_store_dwordx2 v[2:3], v0, s[16:19], 0 offen offset:2560
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[44:47], v[96:99], v[232:235], v112, v116 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v140, v141
		v_cvt_pk_f16_f32 v3, v142, v143
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[44:47], v[100:103], v[236:239], v112, v116 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_store_dwordx2 v[2:3], v0, s[16:19], 0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v144, v145
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[44:47], v[104:107], v[240:243], v112, v116 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v3, v146, v147
		buffer_store_dwordx2 v[2:3], v0, s[16:19], 0 offen offset:3584
		v_cvt_pk_f16_f32 v2, v164, v165
		v_cvt_pk_f16_f32 v3, v166, v167
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v168, v169
		v_cvt_pk_f16_f32 v3, v170, v171
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v172, v173
		v_cvt_pk_f16_f32 v3, v174, v175
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v176, v177
		v_cvt_pk_f16_f32 v3, v178, v179
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:3584
		v_cvt_pk_f16_f32 v2, v196, v197
		v_cvt_pk_f16_f32 v3, v198, v199
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s1 offen offset:2048
		v_cvt_pk_f16_f32 v2, v200, v201
		v_cvt_pk_f16_f32 v3, v202, v203
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s1 offen offset:2560
		v_cvt_pk_f16_f32 v2, v204, v205
		v_cvt_pk_f16_f32 v3, v206, v207
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s1 offen offset:3072
		v_cvt_pk_f16_f32 v2, v208, v209
		v_cvt_pk_f16_f32 v3, v210, v211
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s1 offen offset:3584
		v_cvt_pk_f16_f32 v2, v228, v229
		v_cvt_pk_f16_f32 v3, v230, v231
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:2048
		v_cvt_pk_f16_f32 v2, v232, v233
		v_cvt_pk_f16_f32 v3, v234, v235
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:2560
		v_cvt_pk_f16_f32 v2, v236, v237
		v_cvt_pk_f16_f32 v3, v238, v239
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:3072
		v_cvt_pk_f16_f32 v2, v240, v241
		v_cvt_pk_f16_f32 v3, v242, v243
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:3584
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
		.amdhsa_next_free_vgpr 256
		.amdhsa_next_free_sgpr 56
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
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 56
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
    .sgpr_count:     56
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
