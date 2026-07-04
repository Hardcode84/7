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
		s_mov_b32 s18, 0x7fffffff
		s_mov_b32 s19, 0x31016000
		s_mov_b32 s16, s10
		s_mov_b32 s17, s11
		s_mov_b32 s20, s8
		s_mov_b32 s21, s9
		s_mov_b32 s22, s18
		s_mov_b32 s23, s19
		s_mov_b32 s10, 0x1000000
		s_mov_b32 s8, s2
		s_mov_b32 s9, s3
		s_mov_b32 s11, s19
		s_mov_b32 s0, s4
		s_mov_b32 s1, s5
		s_mov_b32 s2, s10
		s_mov_b32 s3, s19
		s_lshr_b32 s4, s13, 3
		s_lshl_b32 s5, s14, 1
		s_add_i32 s4, s5, s4
		s_and_b32 s5, s13, 7
		s_lshl_b32 s5, s5, 5
		s_add_i32 s4, s4, s5
		s_lshr_b32 s5, s4, 6
		s_lshl_b32 s12, s5, 23
		s_and_b32 s4, s4, 63
		s_lshr_b32 s13, s4, 2
		s_lshl_b32 s14, s13, 17
		s_add_i32 s12, s12, s14
		s_and_b32 s4, s4, 3
		s_lshl_b32 s14, s4, 21
		s_add_i32 s12, s12, s14
		s_add_u32 s24, s6, s12
		s_addc_u32 s25, s7, 0
		s_mov_b32 s26, 0x20000
		s_mov_b32 s27, s19
		v_readfirstlane_b32 s6, v0
		s_lshr_b32 s7, s6, 6
		s_lshl_b32 s12, s7, 10
		s_add_i32 s14, s12, 0x2000
		s_add_i32 s15, s12, 0x4000
		s_add_i32 s28, s12, 0x6000
		s_add_i32 s29, s12, 0x8000
		s_add_i32 s30, s12, 0xa000
		s_add_i32 s31, s12, 0xc000
		s_add_i32 s32, s12, 0xe000
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 m0, s12
		v_lshrrev_b32_e32 v1, 6, v0
		v_and_b32_e32 v2, 63, v0
		v_lshrrev_b32_e32 v3, 2, v2
		v_lshlrev_b32_e32 v3, 12, v3
		v_lshl_add_u32 v3, v1, 16, v3
		v_lshrrev_b32_e32 v8, 3, v2
		v_and_b32_e32 v9, 3, v8
		v_and_b32_e32 v10, 3, v2
		v_xor_b32_e32 v9, v9, v10
		v_lshl_add_u32 v3, v9, 4, v3
		s_lshl_b32 s33, s5, 22
		s_lshl_b32 s34, s4, 20
		s_add_i32 s35, s33, s34
		v_add_u32_e32 v9, s35, v3
		buffer_load_dwordx4 v9, s[8:11], 0 offen lds
		s_add_i32 m0, s12, 0x2000
		s_add_i32 s35, s33, 0x80000
		v_add_u32_e32 v10, s34, v3
		v_add_u32_e32 v11, s35, v10
		buffer_load_dwordx4 v11, s[8:11], 0 offen lds
		s_add_i32 m0, s12, 0x4000
		v_add3_u32 v11, s33, 64, v10
		buffer_load_dwordx4 v11, s[8:11], 0 offen lds
		s_add_i32 m0, s12, 0x6000
		s_add_i32 s35, s33, 0x80040
		v_add_u32_e32 v10, s35, v10
		buffer_load_dwordx4 v10, s[8:11], 0 offen lds
		s_add_i32 m0, s12, 0x8000
		s_lshl_b32 s35, s13, 20
		v_add_u32_e32 v10, s35, v3
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		s_add_i32 m0, s12, 0xa000
		s_add_i32 s36, s35, 0x80000
		v_add_u32_e32 v11, s36, v3
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		s_add_i32 m0, s12, 0xc000
		v_add3_u32 v11, s35, 64, v3
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		s_add_i32 m0, s12, 0xe000
		s_add_i32 s36, s35, 0x80040
		v_add_u32_e32 v11, s36, v3
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		v_and_b32_e32 v11, 39, v0
		v_and_or_b32 v12, 1, v1, v11
		s_mov_b32 s36, 0
		v_cmp_eq_u32_e64 vcc, v12, s36
		s_mov_b64 s[38:39], vcc
		s_lshr_b32 s6, s6, 7
		s_lshl_b32 s37, s6, 9
		s_lshl_b32 s5, s5, 10
		s_lshl_b32 s6, s6, 6
		s_add_i32 s40, s5, s6
		s_lshl_b32 s4, s4, 8
		s_add_i32 s40, s40, s4
		v_lshl_add_u32 v12, v8, 12, s40
		v_lshl_add_u32 v13, v8, 12, s4
		v_add_u32_e32 v13, s6, v13
		v_add3_u32 v14, s5, 16, v13
		v_add3_u32 v15, s5, 32, v13
		v_add3_u32 v13, s5, 48, v13
		s_and_saveexec_b64 s[54:55], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_0
		s_add_i32 m0, s37, 0x20000
		s_nop 0
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_add_i32 m0, s37, 0x20010
		s_nop 0
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		s_add_i32 m0, s37, 0x20020
		s_nop 0
		buffer_load_dwordx4 v15, s[20:23], 0 offen lds
		s_add_i32 m0, s37, 0x20030
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_0:
		s_andn2_b64 exec, s[54:55], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_0
.Lwmma_f16_matmul_tiled.exec_endif_0:
		s_mov_b64 exec, s[54:55]
		v_lshrrev_b32_e32 v12, 1, v1
		v_or_b32_e32 v11, v11, v12
		v_cmp_eq_u32_e64 vcc, v11, s36
		s_mov_b64 s[40:41], vcc
		s_and_b32 s7, s7, 1
		s_lshl_b32 s42, s7, 10
		s_lshl_b32 s13, s13, 8
		s_lshl_b32 s7, s7, 7
		s_add_i32 s43, s13, s7
		v_lshl_add_u32 v11, v8, 12, s43
		s_add_i32 s43, s13, 16
		s_add_i32 s43, s43, s7
		v_lshl_add_u32 v12, v8, 12, s43
		v_lshl_add_u32 v13, v8, 12, s7
		v_add3_u32 v14, s13, 32, v13
		v_add3_u32 v15, s13, 48, v13
		v_add3_u32 v13, s13, 64, v13
		v_lshl_add_u32 v16, v8, 12, s7
		v_add_u32_e32 v16, s13, v16
		v_add_u32_e32 v17, 0x50, v16
		v_add_u32_e32 v18, 0x60, v16
		v_add_u32_e32 v16, 0x70, v16
		s_and_saveexec_b64 s[54:55], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_1
		s_add_i32 m0, s42, 0x20800
		s_nop 0
		buffer_load_dwordx4 v11, s[16:19], 0 offen lds
		s_add_i32 m0, s42, 0x20810
		s_nop 0
		buffer_load_dwordx4 v12, s[16:19], 0 offen lds
		s_add_i32 m0, s42, 0x20820
		s_nop 0
		buffer_load_dwordx4 v14, s[16:19], 0 offen lds
		s_add_i32 m0, s42, 0x20830
		s_nop 0
		buffer_load_dwordx4 v15, s[16:19], 0 offen lds
		s_add_i32 m0, s42, 0x20a00
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 m0, s42, 0x20a10
		s_nop 0
		buffer_load_dwordx4 v17, s[16:19], 0 offen lds
		s_add_i32 m0, s42, 0x20a20
		s_nop 0
		buffer_load_dwordx4 v18, s[16:19], 0 offen lds
		s_add_i32 m0, s42, 0x20a30
		s_nop 0
		buffer_load_dwordx4 v16, s[16:19], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_1:
		s_andn2_b64 exec, s[54:55], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_1
.Lwmma_f16_matmul_tiled.exec_endif_1:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s43, s5, 0x4000
		s_add_i32 s43, s43, s6
		s_add_i32 s43, s43, s4
		v_lshl_add_u32 v11, v8, 12, s43
		v_lshl_add_u32 v12, v8, 12, s4
		v_add_u32_e32 v12, s6, v12
		v_add_u32_e32 v12, s5, v12
		v_add_u32_e32 v13, 0x4010, v12
		v_add_u32_e32 v14, 0x4020, v12
		v_add_u32_e32 v12, 0x4030, v12
		s_and_saveexec_b64 s[54:55], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_2
		s_add_i32 m0, s37, 0x21000
		s_nop 0
		buffer_load_dwordx4 v11, s[20:23], 0 offen lds
		s_add_i32 m0, s37, 0x21010
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		s_add_i32 m0, s37, 0x21020
		s_nop 0
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		s_add_i32 m0, s37, 0x21030
		s_nop 0
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_2:
		s_andn2_b64 exec, s[54:55], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_2
.Lwmma_f16_matmul_tiled.exec_endif_2:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s43, s13, 0x4000
		s_add_i32 s43, s43, s7
		v_lshl_add_u32 v11, v8, 12, s43
		s_add_i32 s43, s13, 0x4010
		s_add_i32 s43, s43, s7
		v_lshl_add_u32 v12, v8, 12, s43
		v_lshl_add_u32 v13, v8, 12, s7
		v_add_u32_e32 v13, s13, v13
		v_add_u32_e32 v14, 0x4020, v13
		v_add_u32_e32 v15, 0x4030, v13
		v_add_u32_e32 v13, 0x4040, v13
		v_lshl_add_u32 v16, v8, 12, s7
		v_add_u32_e32 v16, s13, v16
		v_add_u32_e32 v17, 0x4050, v16
		v_add_u32_e32 v18, 0x4060, v16
		v_add_u32_e32 v16, 0x4070, v16
		s_and_saveexec_b64 s[54:55], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_3
		s_add_i32 m0, s42, 0x21800
		s_nop 0
		buffer_load_dwordx4 v11, s[16:19], 0 offen lds
		s_add_i32 m0, s42, 0x21810
		s_nop 0
		buffer_load_dwordx4 v12, s[16:19], 0 offen lds
		s_add_i32 m0, s42, 0x21820
		s_nop 0
		buffer_load_dwordx4 v14, s[16:19], 0 offen lds
		s_add_i32 m0, s42, 0x21830
		s_nop 0
		buffer_load_dwordx4 v15, s[16:19], 0 offen lds
		s_add_i32 m0, s42, 0x21a00
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 m0, s42, 0x21a10
		s_nop 0
		buffer_load_dwordx4 v17, s[16:19], 0 offen lds
		s_add_i32 m0, s42, 0x21a20
		s_nop 0
		buffer_load_dwordx4 v18, s[16:19], 0 offen lds
		s_add_i32 m0, s42, 0x21a30
		s_nop 0
		buffer_load_dwordx4 v16, s[16:19], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_3:
		s_andn2_b64 exec, s[54:55], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_3
.Lwmma_f16_matmul_tiled.exec_endif_3:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s43, s5, 0x8000
		s_add_i32 s43, s43, s6
		s_add_i32 s43, s43, s4
		v_lshl_add_u32 v11, v8, 12, s43
		v_lshl_add_u32 v12, v8, 12, s4
		v_add_u32_e32 v12, s6, v12
		v_add_u32_e32 v12, s5, v12
		v_add_u32_e32 v13, 0x8010, v12
		v_add_u32_e32 v14, 0x8020, v12
		v_add_u32_e32 v12, 0x8030, v12
		s_and_saveexec_b64 s[54:55], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_4
		s_add_i32 m0, s37, 0x22000
		s_nop 0
		buffer_load_dwordx4 v11, s[20:23], 0 offen lds
		s_add_i32 m0, s37, 0x22010
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		s_add_i32 m0, s37, 0x22020
		s_nop 0
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		s_add_i32 m0, s37, 0x22030
		s_nop 0
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_4:
		s_andn2_b64 exec, s[54:55], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_4
.Lwmma_f16_matmul_tiled.exec_endif_4:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s43, s13, 0x8000
		s_add_i32 s43, s43, s7
		v_lshl_add_u32 v11, v8, 12, s43
		s_add_i32 s43, s13, 0x8010
		s_add_i32 s43, s43, s7
		v_lshl_add_u32 v12, v8, 12, s43
		v_lshl_add_u32 v13, v8, 12, s7
		v_add_u32_e32 v13, s13, v13
		v_add_u32_e32 v14, 0x8020, v13
		v_add_u32_e32 v15, 0x8030, v13
		v_add_u32_e32 v13, 0x8040, v13
		v_lshl_add_u32 v16, v8, 12, s7
		v_add_u32_e32 v16, s13, v16
		v_add_u32_e32 v17, 0x8050, v16
		v_add_u32_e32 v18, 0x8060, v16
		v_add_u32_e32 v16, 0x8070, v16
		s_and_saveexec_b64 s[54:55], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_5
		s_add_i32 m0, s42, 0x22800
		s_nop 0
		buffer_load_dwordx4 v11, s[16:19], 0 offen lds
		s_add_i32 m0, s42, 0x22810
		s_nop 0
		buffer_load_dwordx4 v12, s[16:19], 0 offen lds
		s_add_i32 m0, s42, 0x22820
		s_nop 0
		buffer_load_dwordx4 v14, s[16:19], 0 offen lds
		s_add_i32 m0, s42, 0x22830
		s_nop 0
		buffer_load_dwordx4 v15, s[16:19], 0 offen lds
		s_add_i32 m0, s42, 0x22a00
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 m0, s42, 0x22a10
		s_nop 0
		buffer_load_dwordx4 v17, s[16:19], 0 offen lds
		s_add_i32 m0, s42, 0x22a20
		s_nop 0
		buffer_load_dwordx4 v18, s[16:19], 0 offen lds
		s_add_i32 m0, s42, 0x22a30
		s_nop 0
		buffer_load_dwordx4 v16, s[16:19], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_5:
		s_andn2_b64 exec, s[54:55], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_5
.Lwmma_f16_matmul_tiled.exec_endif_5:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s43, s5, 0xc000
		s_add_i32 s43, s43, s6
		s_add_i32 s43, s43, s4
		v_lshl_add_u32 v11, v8, 12, s43
		v_lshl_add_u32 v12, v8, 12, s4
		v_add_u32_e32 v12, s6, v12
		v_add_u32_e32 v12, s5, v12
		v_add_u32_e32 v13, 0xc010, v12
		v_add_u32_e32 v14, 0xc020, v12
		v_add_u32_e32 v12, 0xc030, v12
		s_and_saveexec_b64 s[54:55], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_6
		s_add_i32 m0, s37, 0x23000
		s_nop 0
		buffer_load_dwordx4 v11, s[20:23], 0 offen lds
		s_add_i32 m0, s37, 0x23010
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		s_add_i32 m0, s37, 0x23020
		s_nop 0
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		s_add_i32 m0, s37, 0x23030
		s_nop 0
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_6:
		s_andn2_b64 exec, s[54:55], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_6
.Lwmma_f16_matmul_tiled.exec_endif_6:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s43, s13, 0xc000
		s_add_i32 s43, s43, s7
		v_lshl_add_u32 v11, v8, 12, s43
		s_add_i32 s43, s13, 0xc010
		s_add_i32 s43, s43, s7
		v_lshl_add_u32 v12, v8, 12, s43
		v_lshl_add_u32 v13, v8, 12, s7
		v_add_u32_e32 v13, s13, v13
		v_add_u32_e32 v14, 0xc020, v13
		v_add_u32_e32 v15, 0xc030, v13
		v_add_u32_e32 v13, 0xc040, v13
		v_lshl_add_u32 v16, v8, 12, s7
		v_add_u32_e32 v16, s13, v16
		v_add_u32_e32 v17, 0xc050, v16
		v_add_u32_e32 v18, 0xc060, v16
		v_add_u32_e32 v16, 0xc070, v16
		s_and_saveexec_b64 s[54:55], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_7
		s_add_i32 m0, s42, 0x23800
		s_nop 0
		buffer_load_dwordx4 v11, s[16:19], 0 offen lds
		s_add_i32 m0, s42, 0x23810
		s_nop 0
		buffer_load_dwordx4 v12, s[16:19], 0 offen lds
		s_add_i32 m0, s42, 0x23820
		s_nop 0
		buffer_load_dwordx4 v14, s[16:19], 0 offen lds
		s_add_i32 m0, s42, 0x23830
		s_nop 0
		buffer_load_dwordx4 v15, s[16:19], 0 offen lds
		s_add_i32 m0, s42, 0x23a00
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 m0, s42, 0x23a10
		s_nop 0
		buffer_load_dwordx4 v17, s[16:19], 0 offen lds
		s_add_i32 m0, s42, 0x23a20
		s_nop 0
		buffer_load_dwordx4 v18, s[16:19], 0 offen lds
		s_add_i32 m0, s42, 0x23a30
		s_nop 0
		buffer_load_dwordx4 v16, s[16:19], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_7:
		s_andn2_b64 exec, s[54:55], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_7
.Lwmma_f16_matmul_tiled.exec_endif_7:
		s_mov_b64 exec, s[54:55]
		s_add_i32 m0, s12, 0x10000
		s_add_i32 s43, s33, 0x80
		s_add_i32 s43, s43, s34
		v_add_u32_e32 v11, s43, v3
		buffer_load_dwordx4 v11, s[8:11], 0 offen lds
		s_add_i32 m0, s12, 0x12000
		v_add_u32_e32 v11, s34, v3
		v_add_u32_e32 v11, s33, v11
		v_add_u32_e32 v12, 0x80080, v11
		buffer_load_dwordx4 v12, s[8:11], 0 offen lds
		s_add_i32 m0, s12, 0x14000
		v_add_u32_e32 v12, 0xc0, v11
		buffer_load_dwordx4 v12, s[8:11], 0 offen lds
		s_add_i32 m0, s12, 0x16000
		v_add_u32_e32 v11, 0x800c0, v11
		buffer_load_dwordx4 v11, s[8:11], 0 offen lds
		s_add_i32 m0, s12, 0x18000
		s_add_i32 s33, s35, 0x80
		v_add_u32_e32 v11, s33, v3
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		s_add_i32 m0, s12, 0x1a000
		v_add_u32_e32 v3, s35, v3
		v_add_u32_e32 v11, 0x80080, v3
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		s_add_i32 m0, s12, 0x1c000
		v_add_u32_e32 v11, 0xc0, v3
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		s_add_i32 m0, s12, 0x1e000
		v_add_u32_e32 v3, 0x800c0, v3
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		s_waitcnt vmcnt(8)
		s_barrier
		v_lshrrev_b32_e32 v3, 7, v0
		v_lshlrev_b32_e32 v11, 12, v3
		v_and_b32_e32 v0, 15, v0
		v_lshlrev_b32_e32 v12, 6, v0
		v_lshrrev_b32_e32 v13, 4, v2
		v_lshrrev_b32_e32 v0, 1, v0
		v_and_b32_e32 v0, 3, v0
		v_xor_b32_e32 v0, v13, v0
		v_lshlrev_b32_e32 v0, 4, v0
		v_add3_u32 v13, v11, v12, v0
		ds_read_b128 v[16:19], v13
		ds_read_b128 v[20:23], v13 offset:1024
		ds_read_b128 v[24:27], v13 offset:2048
		ds_read_b128 v[28:31], v13 offset:3072
		ds_read_b128 v[32:35], v13 offset:16384
		ds_read_b128 v[36:39], v13 offset:17408
		ds_read_b128 v[40:43], v13 offset:18432
		ds_read_b128 v[44:47], v13 offset:19456
		v_and_b32_e32 v13, 1, v1
		v_lshlrev_b32_e32 v14, 13, v13
		v_add3_u32 v15, v12, v14, v0
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
		v_add_u32_e32 v15, 0x100, v9
		v_add_u32_e32 v112, 0x80100, v9
		v_add_u32_e32 v113, 0x140, v9
		v_add_u32_e32 v114, 0x80140, v9
		v_add_u32_e32 v9, 0x100, v10
		v_add_u32_e32 v115, 0x80100, v10
		v_add_u32_e32 v116, 0x140, v10
		v_add_u32_e32 v117, 0x80140, v10
		v_lshlrev_b32_e32 v3, 9, v3
		v_lshlrev_b32_e32 v2, 3, v2
		v_lshlrev_b32_e32 v10, 10, v13
		s_add_i32 s33, s5, 0x10000
		s_add_i32 s33, s33, s6
		s_add_i32 s33, s33, s4
		s_add_i32 s34, s5, 0x10010
		s_add_i32 s34, s34, s6
		s_add_i32 s34, s34, s4
		s_add_i32 s35, s5, 0x10020
		s_add_i32 s35, s35, s6
		s_add_i32 s35, s35, s4
		s_add_i32 s43, s5, 0x10030
		s_add_i32 s43, s43, s6
		s_add_i32 s43, s43, s4
		s_add_i32 s44, s13, 0x10000
		s_add_i32 s44, s44, s7
		s_add_i32 s45, s13, 0x10010
		s_add_i32 s45, s45, s7
		s_add_i32 s46, s5, 0x14000
		s_add_i32 s46, s46, s6
		s_add_i32 s46, s46, s4
		s_add_i32 s47, s5, 0x14010
		s_add_i32 s47, s47, s6
		s_add_i32 s47, s47, s4
		s_add_i32 s48, s5, 0x14020
		s_add_i32 s48, s48, s6
		s_add_i32 s48, s48, s4
		s_add_i32 s5, s5, 0x14030
		s_add_i32 s5, s5, s6
		s_add_i32 s4, s5, s4
		s_add_i32 s5, s13, 0x14000
		s_add_i32 s5, s5, s7
		s_add_i32 s6, s13, 0x14010
		s_add_i32 s6, s6, s7
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
		s_lshl_b32 s49, s36, 7
		s_waitcnt vmcnt(8) lgkmcnt(0)
		s_barrier
		s_and_b32 s50, s36, 1
		s_lshl_b32 s50, s50, 13
		s_add_i32 s51, s50, 0x20000
		v_add3_u32 v118, s51, v3, v2
		ds_read_b64_tr_b8 v[244:245], v118
		v_add3_u32 v119, s51, v2, v10
		ds_read_b64_tr_b8 v[246:247], v119 offset:2048
		ds_read_b64_tr_b8 v[248:249], v119 offset:2560
		ds_read_b64_tr_b8 v[250:251], v118 offset:4096
		ds_read_b64_tr_b8 v[252:253], v119 offset:6144
		ds_read_b64_tr_b8 v[254:255], v119 offset:6656
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[16:19], v[48:51], v[4:7], v244, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[16:19], v[52:55], v[120:123], v244, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[56:59], v[124:127], v244, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[60:63], v[128:131], v244, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], v[48:51], v[148:151], v244, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[52:55], v[152:155], v244, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[56:59], v[156:159], v244, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[60:63], v[160:163], v244, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[48:51], v[180:183], v244, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[52:55], v[184:187], v244, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[56:59], v[188:191], v244, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[60:63], v[192:195], v244, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[48:51], v[212:215], v244, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[28:31], v[52:55], v[216:219], v244, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[28:31], v[56:59], v[220:223], v244, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[60:63], v[224:227], v244, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[32:35], v[80:83], v[4:7], v250, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[32:35], v[84:87], v[120:123], v250, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], v[88:91], v[124:127], v250, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[32:35], v[92:95], v[128:131], v250, v252 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[36:39], v[80:83], v[148:151], v250, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[36:39], v[84:87], v[152:155], v250, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[36:39], v[88:91], v[156:159], v250, v252 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[36:39], v[92:95], v[160:163], v250, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[40:43], v[80:83], v[180:183], v250, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[40:43], v[84:87], v[184:187], v250, v252 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[40:43], v[88:91], v[188:191], v250, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[40:43], v[92:95], v[192:195], v250, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[44:47], v[80:83], v[212:215], v250, v252 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[44:47], v[84:87], v[216:219], v250, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[44:47], v[88:91], v[220:223], v250, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[44:47], v[92:95], v[224:227], v250, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s51, s37, s50
		s_lshl_b32 s52, s36, 15
		s_add_i32 s53, s33, s52
		v_lshl_add_u32 v48, v8, 12, s53
		s_add_i32 s53, s34, s52
		v_lshl_add_u32 v49, v8, 12, s53
		s_add_i32 s53, s35, s52
		v_lshl_add_u32 v50, v8, 12, s53
		s_add_i32 s53, s43, s52
		v_lshl_add_u32 v51, v8, 12, s53
		s_and_saveexec_b64 s[54:55], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_8
		s_add_i32 m0, s51, 0x20000
		s_nop 0
		buffer_load_dwordx4 v48, s[20:23], 0 offen lds
		s_add_i32 m0, s51, 0x20010
		s_nop 0
		buffer_load_dwordx4 v49, s[20:23], 0 offen lds
		s_add_i32 m0, s51, 0x20020
		s_nop 0
		buffer_load_dwordx4 v50, s[20:23], 0 offen lds
		s_add_i32 m0, s51, 0x20030
		s_nop 0
		buffer_load_dwordx4 v51, s[20:23], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_8:
		s_andn2_b64 exec, s[54:55], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_8
.Lwmma_f16_matmul_tiled.exec_endif_8:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s50, s42, s50
		s_add_i32 s53, s44, s52
		v_lshl_add_u32 v48, v8, 12, s53
		s_add_i32 s53, s45, s52
		v_lshl_add_u32 v49, v8, 12, s53
		v_lshl_add_u32 v50, v8, 12, s52
		v_add_u32_e32 v50, s7, v50
		v_add_u32_e32 v50, s13, v50
		v_add_u32_e32 v51, 0x10020, v50
		v_add_u32_e32 v52, 0x10030, v50
		v_add_u32_e32 v50, 0x10040, v50
		v_lshl_add_u32 v53, v8, 12, s52
		v_add_u32_e32 v53, s7, v53
		v_add_u32_e32 v53, s13, v53
		v_add_u32_e32 v54, 0x10050, v53
		v_add_u32_e32 v55, 0x10060, v53
		v_add_u32_e32 v53, 0x10070, v53
		s_and_saveexec_b64 s[54:55], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_9
		s_add_i32 m0, s50, 0x20800
		s_nop 0
		buffer_load_dwordx4 v48, s[16:19], 0 offen lds
		s_add_i32 m0, s50, 0x20810
		s_nop 0
		buffer_load_dwordx4 v49, s[16:19], 0 offen lds
		s_add_i32 m0, s50, 0x20820
		s_nop 0
		buffer_load_dwordx4 v51, s[16:19], 0 offen lds
		s_add_i32 m0, s50, 0x20830
		s_nop 0
		buffer_load_dwordx4 v52, s[16:19], 0 offen lds
		s_add_i32 m0, s50, 0x20a00
		s_nop 0
		buffer_load_dwordx4 v50, s[16:19], 0 offen lds
		s_add_i32 m0, s50, 0x20a10
		s_nop 0
		buffer_load_dwordx4 v54, s[16:19], 0 offen lds
		s_add_i32 m0, s50, 0x20a20
		s_nop 0
		buffer_load_dwordx4 v55, s[16:19], 0 offen lds
		s_add_i32 m0, s50, 0x20a30
		s_nop 0
		buffer_load_dwordx4 v53, s[16:19], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_9:
		s_andn2_b64 exec, s[54:55], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_9
.Lwmma_f16_matmul_tiled.exec_endif_9:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s53, s46, s52
		v_lshl_add_u32 v48, v8, 12, s53
		s_add_i32 s53, s47, s52
		v_lshl_add_u32 v49, v8, 12, s53
		s_add_i32 s53, s48, s52
		v_lshl_add_u32 v50, v8, 12, s53
		s_add_i32 s53, s4, s52
		v_lshl_add_u32 v51, v8, 12, s53
		s_and_saveexec_b64 s[54:55], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_10
		s_add_i32 m0, s51, 0x21000
		s_nop 0
		buffer_load_dwordx4 v48, s[20:23], 0 offen lds
		s_add_i32 m0, s51, 0x21010
		s_nop 0
		buffer_load_dwordx4 v49, s[20:23], 0 offen lds
		s_add_i32 m0, s51, 0x21020
		s_nop 0
		buffer_load_dwordx4 v50, s[20:23], 0 offen lds
		s_add_i32 m0, s51, 0x21030
		s_nop 0
		buffer_load_dwordx4 v51, s[20:23], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_10:
		s_andn2_b64 exec, s[54:55], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_10
.Lwmma_f16_matmul_tiled.exec_endif_10:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s51, s5, s52
		v_lshl_add_u32 v48, v8, 12, s51
		s_add_i32 s51, s6, s52
		v_lshl_add_u32 v49, v8, 12, s51
		v_lshl_add_u32 v50, v8, 12, s52
		v_add_u32_e32 v50, s7, v50
		v_add_u32_e32 v50, s13, v50
		v_add_u32_e32 v51, 0x14020, v50
		v_add_u32_e32 v52, 0x14030, v50
		v_add_u32_e32 v50, 0x14040, v50
		v_lshl_add_u32 v53, v8, 12, s52
		v_add_u32_e32 v53, s7, v53
		v_add_u32_e32 v53, s13, v53
		v_add_u32_e32 v54, 0x14050, v53
		v_add_u32_e32 v55, 0x14060, v53
		v_add_u32_e32 v53, 0x14070, v53
		s_and_saveexec_b64 s[54:55], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_11
		s_add_i32 m0, s50, 0x21800
		s_nop 0
		buffer_load_dwordx4 v48, s[16:19], 0 offen lds
		s_add_i32 m0, s50, 0x21810
		s_nop 0
		buffer_load_dwordx4 v49, s[16:19], 0 offen lds
		s_add_i32 m0, s50, 0x21820
		s_nop 0
		buffer_load_dwordx4 v51, s[16:19], 0 offen lds
		s_add_i32 m0, s50, 0x21830
		s_nop 0
		buffer_load_dwordx4 v52, s[16:19], 0 offen lds
		s_add_i32 m0, s50, 0x21a00
		s_nop 0
		buffer_load_dwordx4 v50, s[16:19], 0 offen lds
		s_add_i32 m0, s50, 0x21a10
		s_nop 0
		buffer_load_dwordx4 v54, s[16:19], 0 offen lds
		s_add_i32 m0, s50, 0x21a20
		s_nop 0
		buffer_load_dwordx4 v55, s[16:19], 0 offen lds
		s_add_i32 m0, s50, 0x21a30
		s_nop 0
		buffer_load_dwordx4 v53, s[16:19], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_11:
		s_andn2_b64 exec, s[54:55], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_11
.Lwmma_f16_matmul_tiled.exec_endif_11:
		s_mov_b64 exec, s[54:55]
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[16:19], v[64:67], v[132:135], v244, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[68:71], v[136:139], v244, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[16:19], v[72:75], v[140:143], v244, v248 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[16:19], v[76:79], v[144:147], v244, v248 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[64:67], v[164:167], v244, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[68:71], v[168:171], v244, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[72:75], v[172:175], v244, v248 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[20:23], v[76:79], v[176:179], v244, v248 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[64:67], v[196:199], v244, v248 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[68:71], v[200:203], v244, v248 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[72:75], v[204:207], v244, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], v[76:79], v[208:211], v244, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], v[64:67], v[228:231], v244, v248 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[28:31], v[68:71], v[232:235], v244, v248 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[28:31], v[72:75], v[236:239], v244, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[28:31], v[76:79], v[240:243], v244, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], v[96:99], v[132:135], v250, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[32:35], v[100:103], v[136:139], v250, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[32:35], v[104:107], v[140:143], v250, v254 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[32:35], v[108:111], v[144:147], v250, v254 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], v[96:99], v[164:167], v250, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], v[100:103], v[168:171], v250, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[36:39], v[104:107], v[172:175], v250, v254 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[36:39], v[108:111], v[176:179], v250, v254 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[40:43], v[96:99], v[196:199], v250, v254 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], v[100:103], v[200:203], v250, v254 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[40:43], v[104:107], v[204:207], v250, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[40:43], v[108:111], v[208:211], v250, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[44:47], v[96:99], v[228:231], v250, v254 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[44:47], v[100:103], v[232:235], v250, v254 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[44:47], v[104:107], v[236:239], v250, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[44:47], v[108:111], v[240:243], v250, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s12
		s_waitcnt vmcnt(0)
		s_barrier
		buffer_load_dwordx4 v15, s[8:11], s49 offen lds
		s_mov_b32 m0, s14
		s_add_i32 s36, s36, 1
		buffer_load_dwordx4 v112, s[8:11], s49 offen lds
		s_mov_b32 m0, s15
		s_and_b32 s50, s36, 1
		buffer_load_dwordx4 v113, s[8:11], s49 offen lds
		s_mov_b32 m0, s28
		s_lshl_b32 s50, s50, 16
		buffer_load_dwordx4 v114, s[8:11], s49 offen lds
		s_mov_b32 m0, s29
		v_add_u32_e32 v16, s50, v11
		buffer_load_dwordx4 v9, s[0:3], s49 offen lds
		s_mov_b32 m0, s30
		v_add3_u32 v48, v16, v12, v0
		buffer_load_dwordx4 v115, s[0:3], s49 offen lds
		s_mov_b32 m0, s31
		ds_read_b128 v[16:19], v48
		buffer_load_dwordx4 v116, s[0:3], s49 offen lds
		s_mov_b32 m0, s32
		ds_read_b128 v[20:23], v48 offset:1024
		buffer_load_dwordx4 v117, s[0:3], s49 offen lds
		ds_read_b128 v[24:27], v48 offset:2048
		ds_read_b128 v[28:31], v48 offset:3072
		ds_read_b128 v[32:35], v48 offset:16384
		ds_read_b128 v[36:39], v48 offset:17408
		ds_read_b128 v[40:43], v48 offset:18432
		ds_read_b128 v[44:47], v48 offset:19456
		v_add_u32_e32 v48, s50, v12
		v_add3_u32 v118, v48, v14, v0
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
		s_add_i32 s12, s12, 0x10000
		s_and_b32 s12, s12, 0x1ffff
		s_add_i32 s14, s14, 0x10000
		s_and_b32 s14, s14, 0x1ffff
		s_add_i32 s15, s15, 0x10000
		s_and_b32 s15, s15, 0x1ffff
		s_add_i32 s28, s28, 0x10000
		s_and_b32 s28, s28, 0x1ffff
		s_add_i32 s29, s29, 0x10000
		s_and_b32 s29, s29, 0x1ffff
		s_add_i32 s30, s30, 0x10000
		s_and_b32 s30, s30, 0x1ffff
		s_add_i32 s31, s31, 0x10000
		s_and_b32 s31, s31, 0x1ffff
		s_add_i32 s32, s32, 0x10000
		s_and_b32 s32, s32, 0x1ffff
		s_cmp_lt_i32 s36, 30
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v3, 0x20000, v3
		v_add_u32_e32 v3, v3, v2
		ds_read_b64_tr_b8 v[8:9], v3
		v_add_u32_e32 v9, 0x20000, v2
		v_lshl_add_u32 v9, v13, 10, v9
		ds_read_b64_tr_b8 v[112:113], v9 offset:2048
		ds_read_b64_tr_b8 v[114:115], v9 offset:2560
		ds_read_b64_tr_b8 v[116:117], v3 offset:4096
		ds_read_b64_tr_b8 v[118:119], v9 offset:6144
		ds_read_b64_tr_b8 v[244:245], v9 offset:6656
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[16:19], v[48:51], v[4:7], v8, v112 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[16:19], v[52:55], v[120:123], v8, v112 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[56:59], v[124:127], v8, v112 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[60:63], v[128:131], v8, v112 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[16:19], v[64:67], v[132:135], v8, v114 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[68:71], v[136:139], v8, v114 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[16:19], v[72:75], v[140:143], v8, v114 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[16:19], v[76:79], v[144:147], v8, v114 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], v[48:51], v[148:151], v8, v112 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[52:55], v[152:155], v8, v112 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[56:59], v[156:159], v8, v112 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[60:63], v[160:163], v8, v112 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[64:67], v[164:167], v8, v114 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[68:71], v[168:171], v8, v114 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[72:75], v[172:175], v8, v114 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[20:23], v[76:79], v[176:179], v8, v114 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[48:51], v[180:183], v8, v112 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[52:55], v[184:187], v8, v112 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[56:59], v[188:191], v8, v112 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[60:63], v[192:195], v8, v112 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[64:67], v[196:199], v8, v114 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[68:71], v[200:203], v8, v114 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[72:75], v[204:207], v8, v114 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], v[76:79], v[208:211], v8, v114 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[48:51], v[212:215], v8, v112 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[28:31], v[52:55], v[216:219], v8, v112 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[28:31], v[56:59], v[220:223], v8, v112 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[60:63], v[224:227], v8, v112 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], v[64:67], v[228:231], v8, v114 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[28:31], v[68:71], v[232:235], v8, v114 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[28:31], v[72:75], v[236:239], v8, v114 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[28:31], v[76:79], v[240:243], v8, v114 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[32:35], v[80:83], v[4:7], v116, v118 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[32:35], v[84:87], v[120:123], v116, v118 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], v[88:91], v[124:127], v116, v118 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[32:35], v[92:95], v[128:131], v116, v118 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], v[96:99], v[132:135], v116, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[32:35], v[100:103], v[136:139], v116, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[32:35], v[104:107], v[140:143], v116, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[32:35], v[108:111], v[144:147], v116, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[36:39], v[80:83], v[148:151], v116, v118 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[36:39], v[84:87], v[152:155], v116, v118 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[36:39], v[88:91], v[156:159], v116, v118 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[36:39], v[92:95], v[160:163], v116, v118 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], v[96:99], v[164:167], v116, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], v[100:103], v[168:171], v116, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[36:39], v[104:107], v[172:175], v116, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[36:39], v[108:111], v[176:179], v116, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[40:43], v[80:83], v[180:183], v116, v118 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[40:43], v[84:87], v[184:187], v116, v118 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[40:43], v[88:91], v[188:191], v116, v118 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[40:43], v[92:95], v[192:195], v116, v118 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[40:43], v[96:99], v[196:199], v116, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], v[100:103], v[200:203], v116, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[40:43], v[104:107], v[204:207], v116, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[40:43], v[108:111], v[208:211], v116, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[44:47], v[80:83], v[212:215], v116, v118 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[44:47], v[84:87], v[216:219], v116, v118 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[44:47], v[88:91], v[220:223], v116, v118 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[44:47], v[92:95], v[224:227], v116, v118 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[44:47], v[96:99], v[228:231], v116, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[44:47], v[100:103], v[232:235], v116, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[44:47], v[104:107], v[236:239], v116, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[44:47], v[108:111], v[240:243], v116, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		v_add_u32_e32 v8, 0x10000, v11
		v_add3_u32 v8, v8, v12, v0
		ds_read_b128 v[16:19], v8
		ds_read_b128 v[20:23], v8 offset:1024
		ds_read_b128 v[24:27], v8 offset:2048
		ds_read_b128 v[28:31], v8 offset:3072
		ds_read_b128 v[32:35], v8 offset:16384
		ds_read_b128 v[36:39], v8 offset:17408
		ds_read_b128 v[40:43], v8 offset:18432
		ds_read_b128 v[44:47], v8 offset:19456
		v_add_u32_e32 v8, 0x10000, v12
		v_add3_u32 v0, v8, v14, v0
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
		v_lshl_add_u32 v0, v1, 14, v2
		s_mov_b32 s0, 0x1000
		s_mov_b32 s1, 0x2000
		s_mov_b32 s2, 0x3000
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[10:11], v3 offset:8192
		ds_read_b64_tr_b8 v[108:109], v9 offset:10240
		ds_read_b64_tr_b8 v[110:111], v9 offset:10752
		ds_read_b64_tr_b8 v[112:113], v3 offset:12288
		ds_read_b64_tr_b8 v[2:3], v9 offset:14336
		ds_read_b64_tr_b8 v[114:115], v9 offset:14848
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[16:19], v[12:15], v[4:7], v10, v108 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[16:19], v[48:51], v[120:123], v10, v108 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[52:55], v[124:127], v10, v108 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[56:59], v[128:131], v10, v108 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], v[12:15], v[148:151], v10, v108 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[48:51], v[152:155], v10, v108 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[52:55], v[156:159], v10, v108 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[56:59], v[160:163], v10, v108 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[12:15], v[180:183], v10, v108 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[48:51], v[184:187], v10, v108 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[52:55], v[188:191], v10, v108 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[56:59], v[192:195], v10, v108 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[12:15], v[212:215], v10, v108 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[28:31], v[48:51], v[216:219], v10, v108 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[28:31], v[52:55], v[220:223], v10, v108 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[56:59], v[224:227], v10, v108 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[32:35], v[76:79], v[4:7], v112, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[32:35], v[80:83], v[120:123], v112, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], v[84:87], v[124:127], v112, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[32:35], v[88:91], v[128:131], v112, v2 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[36:39], v[76:79], v[148:151], v112, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[36:39], v[80:83], v[152:155], v112, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[36:39], v[84:87], v[156:159], v112, v2 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[36:39], v[88:91], v[160:163], v112, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[40:43], v[76:79], v[180:183], v112, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[40:43], v[80:83], v[184:187], v112, v2 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[40:43], v[84:87], v[188:191], v112, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[40:43], v[88:91], v[192:195], v112, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[44:47], v[76:79], v[212:215], v112, v2 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[44:47], v[80:83], v[216:219], v112, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[44:47], v[84:87], v[220:223], v112, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[44:47], v[88:91], v[224:227], v112, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v4, v5
		v_cvt_pk_f16_f32 v3, v6, v7
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx2 v[2:3], v0, s[24:27], 0 offen
		v_cvt_pk_f16_f32 v2, v120, v121
		v_cvt_pk_f16_f32 v3, v122, v123
		buffer_store_dwordx2 v[2:3], v0, s[24:27], 0 offen offset:512
		v_cvt_pk_f16_f32 v2, v124, v125
		v_cvt_pk_f16_f32 v3, v126, v127
		buffer_store_dwordx2 v[2:3], v0, s[24:27], 0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v128, v129
		v_cvt_pk_f16_f32 v3, v130, v131
		buffer_store_dwordx2 v[2:3], v0, s[24:27], 0 offen offset:1536
		v_cvt_pk_f16_f32 v2, v148, v149
		v_cvt_pk_f16_f32 v3, v150, v151
		buffer_store_dwordx2 v[2:3], v0, s[24:27], s0 offen
		v_cvt_pk_f16_f32 v2, v152, v153
		v_cvt_pk_f16_f32 v3, v154, v155
		buffer_store_dwordx2 v[2:3], v0, s[24:27], s0 offen offset:512
		v_cvt_pk_f16_f32 v2, v156, v157
		v_cvt_pk_f16_f32 v3, v158, v159
		buffer_store_dwordx2 v[2:3], v0, s[24:27], s0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v160, v161
		v_cvt_pk_f16_f32 v3, v162, v163
		buffer_store_dwordx2 v[2:3], v0, s[24:27], s0 offen offset:1536
		v_cvt_pk_f16_f32 v2, v180, v181
		v_cvt_pk_f16_f32 v3, v182, v183
		buffer_store_dwordx2 v[2:3], v0, s[24:27], s1 offen
		v_cvt_pk_f16_f32 v2, v184, v185
		v_cvt_pk_f16_f32 v3, v186, v187
		buffer_store_dwordx2 v[2:3], v0, s[24:27], s1 offen offset:512
		v_cvt_pk_f16_f32 v2, v188, v189
		v_cvt_pk_f16_f32 v3, v190, v191
		buffer_store_dwordx2 v[2:3], v0, s[24:27], s1 offen offset:1024
		v_cvt_pk_f16_f32 v2, v192, v193
		v_cvt_pk_f16_f32 v3, v194, v195
		buffer_store_dwordx2 v[2:3], v0, s[24:27], s1 offen offset:1536
		v_cvt_pk_f16_f32 v2, v212, v213
		v_cvt_pk_f16_f32 v3, v214, v215
		buffer_store_dwordx2 v[2:3], v0, s[24:27], s2 offen
		v_cvt_pk_f16_f32 v2, v216, v217
		v_cvt_pk_f16_f32 v3, v218, v219
		buffer_store_dwordx2 v[2:3], v0, s[24:27], s2 offen offset:512
		v_cvt_pk_f16_f32 v2, v220, v221
		v_cvt_pk_f16_f32 v3, v222, v223
		buffer_store_dwordx2 v[2:3], v0, s[24:27], s2 offen offset:1024
		v_cvt_pk_f16_f32 v2, v224, v225
		v_cvt_pk_f16_f32 v3, v226, v227
		buffer_store_dwordx2 v[2:3], v0, s[24:27], s2 offen offset:1536
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[16:19], v[60:63], v[132:135], v10, v110 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[64:67], v[136:139], v10, v110 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[16:19], v[68:71], v[140:143], v10, v110 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[16:19], v[72:75], v[144:147], v10, v110 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[60:63], v[164:167], v10, v110 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[64:67], v[168:171], v10, v110 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[68:71], v[172:175], v10, v110 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[20:23], v[72:75], v[176:179], v10, v110 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[60:63], v[196:199], v10, v110 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[64:67], v[200:203], v10, v110 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[68:71], v[204:207], v10, v110 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], v[72:75], v[208:211], v10, v110 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], v[60:63], v[228:231], v10, v110 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[28:31], v[64:67], v[232:235], v10, v110 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[28:31], v[68:71], v[236:239], v10, v110 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[28:31], v[72:75], v[240:243], v10, v110 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], v[92:95], v[132:135], v112, v114 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[32:35], v[96:99], v[136:139], v112, v114 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[32:35], v[100:103], v[140:143], v112, v114 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[32:35], v[104:107], v[144:147], v112, v114 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], v[92:95], v[164:167], v112, v114 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], v[96:99], v[168:171], v112, v114 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[36:39], v[100:103], v[172:175], v112, v114 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[36:39], v[104:107], v[176:179], v112, v114 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[40:43], v[92:95], v[196:199], v112, v114 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], v[96:99], v[200:203], v112, v114 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[40:43], v[100:103], v[204:207], v112, v114 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[40:43], v[104:107], v[208:211], v112, v114 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[44:47], v[92:95], v[228:231], v112, v114 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[44:47], v[96:99], v[232:235], v112, v114 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[44:47], v[100:103], v[236:239], v112, v114 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[44:47], v[104:107], v[240:243], v112, v114 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v132, v133
		v_cvt_pk_f16_f32 v3, v134, v135
		buffer_store_dwordx2 v[2:3], v0, s[24:27], 0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v136, v137
		v_cvt_pk_f16_f32 v3, v138, v139
		buffer_store_dwordx2 v[2:3], v0, s[24:27], 0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v140, v141
		v_cvt_pk_f16_f32 v3, v142, v143
		buffer_store_dwordx2 v[2:3], v0, s[24:27], 0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v144, v145
		v_cvt_pk_f16_f32 v3, v146, v147
		buffer_store_dwordx2 v[2:3], v0, s[24:27], 0 offen offset:3584
		v_cvt_pk_f16_f32 v2, v164, v165
		v_cvt_pk_f16_f32 v3, v166, v167
		buffer_store_dwordx2 v[2:3], v0, s[24:27], s0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v168, v169
		v_cvt_pk_f16_f32 v3, v170, v171
		buffer_store_dwordx2 v[2:3], v0, s[24:27], s0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v172, v173
		v_cvt_pk_f16_f32 v3, v174, v175
		buffer_store_dwordx2 v[2:3], v0, s[24:27], s0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v176, v177
		v_cvt_pk_f16_f32 v3, v178, v179
		buffer_store_dwordx2 v[2:3], v0, s[24:27], s0 offen offset:3584
		v_cvt_pk_f16_f32 v2, v196, v197
		v_cvt_pk_f16_f32 v3, v198, v199
		buffer_store_dwordx2 v[2:3], v0, s[24:27], s1 offen offset:2048
		v_cvt_pk_f16_f32 v2, v200, v201
		v_cvt_pk_f16_f32 v3, v202, v203
		buffer_store_dwordx2 v[2:3], v0, s[24:27], s1 offen offset:2560
		v_cvt_pk_f16_f32 v2, v204, v205
		v_cvt_pk_f16_f32 v3, v206, v207
		buffer_store_dwordx2 v[2:3], v0, s[24:27], s1 offen offset:3072
		v_cvt_pk_f16_f32 v2, v208, v209
		v_cvt_pk_f16_f32 v3, v210, v211
		buffer_store_dwordx2 v[2:3], v0, s[24:27], s1 offen offset:3584
		v_cvt_pk_f16_f32 v2, v228, v229
		v_cvt_pk_f16_f32 v3, v230, v231
		buffer_store_dwordx2 v[2:3], v0, s[24:27], s2 offen offset:2048
		v_cvt_pk_f16_f32 v2, v232, v233
		v_cvt_pk_f16_f32 v3, v234, v235
		buffer_store_dwordx2 v[2:3], v0, s[24:27], s2 offen offset:2560
		v_cvt_pk_f16_f32 v2, v236, v237
		v_cvt_pk_f16_f32 v3, v238, v239
		buffer_store_dwordx2 v[2:3], v0, s[24:27], s2 offen offset:3072
		v_cvt_pk_f16_f32 v2, v240, v241
		v_cvt_pk_f16_f32 v3, v242, v243
		buffer_store_dwordx2 v[2:3], v0, s[24:27], s2 offen offset:3584
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
