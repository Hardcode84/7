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
		v_readfirstlane_b32 s12, v0
		s_lshl_b32 s12, s12, 2
		s_add_i32 s12, s12, 0x24000
		s_mov_b32 s16, s10
		s_mov_b32 s17, s11
		s_mov_b32 s18, 0x7fffffff
		s_mov_b32 s19, 0x31016000
		s_mov_b32 s20, s8
		s_mov_b32 s21, s9
		s_mov_b32 s22, 0x7fffffff
		s_mov_b32 s23, 0x31016000
		s_mov_b32 s8, s2
		s_mov_b32 s9, s3
		s_mov_b32 s10, 0x1000000
		s_mov_b32 s11, 0x31016000
		s_mov_b32 s0, s4
		s_mov_b32 s1, s5
		s_mov_b32 s2, 0x1000000
		s_mov_b32 s3, 0x31016000
		s_lshr_b32 s4, s13, 3
		s_lshl_b32 s5, s14, 1
		s_add_i32 s4, s5, s4
		s_and_b32 s5, s13, 7
		s_lshl_b32 s5, s5, 5
		s_add_i32 s4, s4, s5
		s_lshr_b32 s5, s4, 6
		s_lshl_b32 s13, s5, 23
		s_and_b32 s4, s4, 63
		s_lshr_b32 s14, s4, 2
		s_lshl_b32 s15, s14, 17
		s_add_i32 s13, s13, s15
		s_and_b32 s4, s4, 3
		s_lshl_b32 s15, s4, 21
		s_add_i32 s13, s13, s15
		s_add_u32 s6, s6, s13
		s_addc_u32 s7, s7, 0
		s_mov_b32 s24, s6
		s_mov_b32 s25, s7
		s_mov_b32 s26, 0x20000
		s_mov_b32 s27, 0x31016000
		v_readfirstlane_b32 s6, v0
		s_lshr_b32 s7, s6, 6
		s_lshl_b32 s13, s7, 10
		s_add_i32 s15, s13, 0x2000
		s_add_i32 s28, s13, 0x4000
		s_add_i32 s29, s13, 0x6000
		s_add_i32 s30, s13, 0x8000
		s_add_i32 s31, s13, 0xa000
		s_add_i32 s32, s13, 0xc000
		s_add_i32 s33, s13, 0xe000
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 m0, s13
		s_mov_b32 m0, s12
		v_lshrrev_b32_e32 v1, 6, v0
		ds_write_addtid_b32 v1
		v_and_b32_e32 v2, 63, v0
		v_lshrrev_b32_e32 v3, 2, v2
		v_lshlrev_b32_e32 v3, 12, v3
		v_lshl_add_u32 v3, v1, 16, v3
		v_lshrrev_b32_e32 v8, 3, v2
		v_and_b32_e32 v9, 3, v8
		v_and_b32_e32 v10, 3, v2
		v_xor_b32_e32 v9, v9, v10
		v_lshl_add_u32 v3, v9, 4, v3
		s_lshl_b32 s34, s5, 22
		s_lshl_b32 s35, s4, 20
		s_add_i32 s36, s34, s35
		s_mov_b32 m0, s13
		v_add_u32_e32 v9, s36, v3
		buffer_load_dwordx4 v9, s[8:11], 0 offen lds
		s_mov_b32 m0, s15
		s_add_i32 s36, s34, 0x80000
		v_add_u32_e32 v10, s35, v3
		v_add_u32_e32 v11, s36, v10
		buffer_load_dwordx4 v11, s[8:11], 0 offen lds
		s_mov_b32 m0, s28
		v_add3_u32 v11, s34, 64, v10
		buffer_load_dwordx4 v11, s[8:11], 0 offen lds
		s_mov_b32 m0, s29
		s_add_i32 s36, s34, 0x80040
		v_add_u32_e32 v10, s36, v10
		buffer_load_dwordx4 v10, s[8:11], 0 offen lds
		s_mov_b32 m0, s30
		s_lshl_b32 s36, s14, 20
		v_add_u32_e32 v10, s36, v3
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		s_mov_b32 m0, s31
		s_add_i32 s37, s36, 0x80000
		v_add_u32_e32 v11, s37, v3
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		s_mov_b32 m0, s32
		v_add3_u32 v11, s36, 64, v3
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		s_mov_b32 m0, s33
		s_add_i32 s37, s36, 0x80040
		v_add_u32_e32 v11, s37, v3
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		v_and_b32_e32 v11, 39, v0
		v_and_or_b32 v12, 1, v1, v11
		s_mov_b32 s37, 0
		v_cmp_eq_u32_e64 vcc, v12, s37
		s_mov_b64 s[38:39], vcc
		s_lshr_b32 s6, s6, 7
		s_lshl_b32 s40, s6, 9
		s_lshl_b32 s5, s5, 10
		s_lshl_b32 s6, s6, 6
		s_add_i32 s41, s5, s6
		s_lshl_b32 s4, s4, 8
		s_add_i32 s41, s41, s4
		v_lshl_add_u32 v12, v8, 12, s41
		v_lshl_add_u32 v13, v8, 12, s4
		v_add_u32_e32 v13, s6, v13
		v_add3_u32 v14, s5, 16, v13
		v_add3_u32 v15, s5, 32, v13
		v_add3_u32 v13, s5, 48, v13
		s_and_saveexec_b64 s[56:57], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_0
		s_add_i32 m0, s40, 0x20000
		s_nop 0
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_add_i32 m0, s40, 0x20010
		s_nop 0
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		s_add_i32 m0, s40, 0x20020
		s_nop 0
		buffer_load_dwordx4 v15, s[20:23], 0 offen lds
		s_add_i32 m0, s40, 0x20030
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_0:
		s_andn2_b64 exec, s[56:57], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_0
.Lwmma_f16_matmul_tiled.exec_endif_0:
		s_mov_b64 exec, s[56:57]
		v_lshrrev_b32_e32 v12, 1, v1
		v_or_b32_e32 v11, v11, v12
		v_cmp_eq_u32_e64 vcc, v11, s37
		s_mov_b64 s[42:43], vcc
		s_and_b32 s7, s7, 1
		s_lshl_b32 s41, s7, 10
		s_lshl_b32 s14, s14, 8
		s_lshl_b32 s7, s7, 7
		s_add_i32 s44, s14, s7
		v_lshl_add_u32 v11, v8, 12, s44
		s_add_i32 s44, s14, 16
		s_add_i32 s44, s44, s7
		v_lshl_add_u32 v12, v8, 12, s44
		v_lshl_add_u32 v13, v8, 12, s7
		v_add3_u32 v14, s14, 32, v13
		v_add3_u32 v15, s14, 48, v13
		v_add3_u32 v13, s14, 64, v13
		v_lshl_add_u32 v16, v8, 12, s7
		v_add_u32_e32 v16, s14, v16
		v_add_u32_e32 v17, 0x50, v16
		v_add_u32_e32 v18, 0x60, v16
		v_add_u32_e32 v16, 0x70, v16
		s_and_saveexec_b64 s[56:57], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_1
		s_add_i32 m0, s41, 0x20800
		s_nop 0
		buffer_load_dwordx4 v11, s[16:19], 0 offen lds
		s_add_i32 m0, s41, 0x20810
		s_nop 0
		buffer_load_dwordx4 v12, s[16:19], 0 offen lds
		s_add_i32 m0, s41, 0x20820
		s_nop 0
		buffer_load_dwordx4 v14, s[16:19], 0 offen lds
		s_add_i32 m0, s41, 0x20830
		s_nop 0
		buffer_load_dwordx4 v15, s[16:19], 0 offen lds
		s_add_i32 m0, s41, 0x20a00
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 m0, s41, 0x20a10
		s_nop 0
		buffer_load_dwordx4 v17, s[16:19], 0 offen lds
		s_add_i32 m0, s41, 0x20a20
		s_nop 0
		buffer_load_dwordx4 v18, s[16:19], 0 offen lds
		s_add_i32 m0, s41, 0x20a30
		s_nop 0
		buffer_load_dwordx4 v16, s[16:19], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_1:
		s_andn2_b64 exec, s[56:57], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_1
.Lwmma_f16_matmul_tiled.exec_endif_1:
		s_mov_b64 exec, s[56:57]
		s_add_i32 s44, s5, 0x4000
		s_add_i32 s44, s44, s6
		s_add_i32 s44, s44, s4
		v_lshl_add_u32 v11, v8, 12, s44
		v_lshl_add_u32 v12, v8, 12, s4
		v_add_u32_e32 v12, s6, v12
		v_add_u32_e32 v12, s5, v12
		v_add_u32_e32 v13, 0x4010, v12
		v_add_u32_e32 v14, 0x4020, v12
		v_add_u32_e32 v12, 0x4030, v12
		s_and_saveexec_b64 s[56:57], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_2
		s_add_i32 m0, s40, 0x21000
		s_nop 0
		buffer_load_dwordx4 v11, s[20:23], 0 offen lds
		s_add_i32 m0, s40, 0x21010
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		s_add_i32 m0, s40, 0x21020
		s_nop 0
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		s_add_i32 m0, s40, 0x21030
		s_nop 0
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_2:
		s_andn2_b64 exec, s[56:57], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_2
.Lwmma_f16_matmul_tiled.exec_endif_2:
		s_mov_b64 exec, s[56:57]
		s_add_i32 s44, s14, 0x4000
		s_add_i32 s44, s44, s7
		v_lshl_add_u32 v11, v8, 12, s44
		s_add_i32 s44, s14, 0x4010
		s_add_i32 s44, s44, s7
		v_lshl_add_u32 v12, v8, 12, s44
		v_lshl_add_u32 v13, v8, 12, s7
		v_add_u32_e32 v13, s14, v13
		v_add_u32_e32 v14, 0x4020, v13
		v_add_u32_e32 v15, 0x4030, v13
		v_add_u32_e32 v13, 0x4040, v13
		v_lshl_add_u32 v16, v8, 12, s7
		v_add_u32_e32 v16, s14, v16
		v_add_u32_e32 v17, 0x4050, v16
		v_add_u32_e32 v18, 0x4060, v16
		v_add_u32_e32 v16, 0x4070, v16
		s_and_saveexec_b64 s[56:57], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_3
		s_add_i32 m0, s41, 0x21800
		s_nop 0
		buffer_load_dwordx4 v11, s[16:19], 0 offen lds
		s_add_i32 m0, s41, 0x21810
		s_nop 0
		buffer_load_dwordx4 v12, s[16:19], 0 offen lds
		s_add_i32 m0, s41, 0x21820
		s_nop 0
		buffer_load_dwordx4 v14, s[16:19], 0 offen lds
		s_add_i32 m0, s41, 0x21830
		s_nop 0
		buffer_load_dwordx4 v15, s[16:19], 0 offen lds
		s_add_i32 m0, s41, 0x21a00
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 m0, s41, 0x21a10
		s_nop 0
		buffer_load_dwordx4 v17, s[16:19], 0 offen lds
		s_add_i32 m0, s41, 0x21a20
		s_nop 0
		buffer_load_dwordx4 v18, s[16:19], 0 offen lds
		s_add_i32 m0, s41, 0x21a30
		s_nop 0
		buffer_load_dwordx4 v16, s[16:19], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_3:
		s_andn2_b64 exec, s[56:57], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_3
.Lwmma_f16_matmul_tiled.exec_endif_3:
		s_mov_b64 exec, s[56:57]
		s_add_i32 s44, s5, 0x8000
		s_add_i32 s44, s44, s6
		s_add_i32 s44, s44, s4
		v_lshl_add_u32 v11, v8, 12, s44
		v_lshl_add_u32 v12, v8, 12, s4
		v_add_u32_e32 v12, s6, v12
		v_add_u32_e32 v12, s5, v12
		v_add_u32_e32 v13, 0x8010, v12
		v_add_u32_e32 v14, 0x8020, v12
		v_add_u32_e32 v12, 0x8030, v12
		s_and_saveexec_b64 s[56:57], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_4
		s_add_i32 m0, s40, 0x22000
		s_nop 0
		buffer_load_dwordx4 v11, s[20:23], 0 offen lds
		s_add_i32 m0, s40, 0x22010
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		s_add_i32 m0, s40, 0x22020
		s_nop 0
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		s_add_i32 m0, s40, 0x22030
		s_nop 0
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_4:
		s_andn2_b64 exec, s[56:57], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_4
.Lwmma_f16_matmul_tiled.exec_endif_4:
		s_mov_b64 exec, s[56:57]
		s_add_i32 s44, s14, 0x8000
		s_add_i32 s44, s44, s7
		v_lshl_add_u32 v11, v8, 12, s44
		s_add_i32 s44, s14, 0x8010
		s_add_i32 s44, s44, s7
		v_lshl_add_u32 v12, v8, 12, s44
		v_lshl_add_u32 v13, v8, 12, s7
		v_add_u32_e32 v13, s14, v13
		v_add_u32_e32 v14, 0x8020, v13
		v_add_u32_e32 v15, 0x8030, v13
		v_add_u32_e32 v13, 0x8040, v13
		v_lshl_add_u32 v16, v8, 12, s7
		v_add_u32_e32 v16, s14, v16
		v_add_u32_e32 v17, 0x8050, v16
		v_add_u32_e32 v18, 0x8060, v16
		v_add_u32_e32 v16, 0x8070, v16
		s_and_saveexec_b64 s[56:57], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_5
		s_add_i32 m0, s41, 0x22800
		s_nop 0
		buffer_load_dwordx4 v11, s[16:19], 0 offen lds
		s_add_i32 m0, s41, 0x22810
		s_nop 0
		buffer_load_dwordx4 v12, s[16:19], 0 offen lds
		s_add_i32 m0, s41, 0x22820
		s_nop 0
		buffer_load_dwordx4 v14, s[16:19], 0 offen lds
		s_add_i32 m0, s41, 0x22830
		s_nop 0
		buffer_load_dwordx4 v15, s[16:19], 0 offen lds
		s_add_i32 m0, s41, 0x22a00
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 m0, s41, 0x22a10
		s_nop 0
		buffer_load_dwordx4 v17, s[16:19], 0 offen lds
		s_add_i32 m0, s41, 0x22a20
		s_nop 0
		buffer_load_dwordx4 v18, s[16:19], 0 offen lds
		s_add_i32 m0, s41, 0x22a30
		s_nop 0
		buffer_load_dwordx4 v16, s[16:19], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_5:
		s_andn2_b64 exec, s[56:57], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_5
.Lwmma_f16_matmul_tiled.exec_endif_5:
		s_mov_b64 exec, s[56:57]
		s_add_i32 s44, s5, 0xc000
		s_add_i32 s44, s44, s6
		s_add_i32 s44, s44, s4
		v_lshl_add_u32 v11, v8, 12, s44
		v_lshl_add_u32 v12, v8, 12, s4
		v_add_u32_e32 v12, s6, v12
		v_add_u32_e32 v12, s5, v12
		v_add_u32_e32 v13, 0xc010, v12
		v_add_u32_e32 v14, 0xc020, v12
		v_add_u32_e32 v12, 0xc030, v12
		s_and_saveexec_b64 s[56:57], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_6
		s_add_i32 m0, s40, 0x23000
		s_nop 0
		buffer_load_dwordx4 v11, s[20:23], 0 offen lds
		s_add_i32 m0, s40, 0x23010
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		s_add_i32 m0, s40, 0x23020
		s_nop 0
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		s_add_i32 m0, s40, 0x23030
		s_nop 0
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_6:
		s_andn2_b64 exec, s[56:57], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_6
.Lwmma_f16_matmul_tiled.exec_endif_6:
		s_mov_b64 exec, s[56:57]
		s_add_i32 s44, s14, 0xc000
		s_add_i32 s44, s44, s7
		v_lshl_add_u32 v11, v8, 12, s44
		s_add_i32 s44, s14, 0xc010
		s_add_i32 s44, s44, s7
		v_lshl_add_u32 v12, v8, 12, s44
		v_lshl_add_u32 v13, v8, 12, s7
		v_add_u32_e32 v13, s14, v13
		v_add_u32_e32 v14, 0xc020, v13
		v_add_u32_e32 v15, 0xc030, v13
		v_add_u32_e32 v13, 0xc040, v13
		v_lshl_add_u32 v16, v8, 12, s7
		v_add_u32_e32 v16, s14, v16
		v_add_u32_e32 v17, 0xc050, v16
		v_add_u32_e32 v18, 0xc060, v16
		v_add_u32_e32 v16, 0xc070, v16
		s_and_saveexec_b64 s[56:57], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_7
		s_add_i32 m0, s41, 0x23800
		s_nop 0
		buffer_load_dwordx4 v11, s[16:19], 0 offen lds
		s_add_i32 m0, s41, 0x23810
		s_nop 0
		buffer_load_dwordx4 v12, s[16:19], 0 offen lds
		s_add_i32 m0, s41, 0x23820
		s_nop 0
		buffer_load_dwordx4 v14, s[16:19], 0 offen lds
		s_add_i32 m0, s41, 0x23830
		s_nop 0
		buffer_load_dwordx4 v15, s[16:19], 0 offen lds
		s_add_i32 m0, s41, 0x23a00
		s_nop 0
		buffer_load_dwordx4 v13, s[16:19], 0 offen lds
		s_add_i32 m0, s41, 0x23a10
		s_nop 0
		buffer_load_dwordx4 v17, s[16:19], 0 offen lds
		s_add_i32 m0, s41, 0x23a20
		s_nop 0
		buffer_load_dwordx4 v18, s[16:19], 0 offen lds
		s_add_i32 m0, s41, 0x23a30
		s_nop 0
		buffer_load_dwordx4 v16, s[16:19], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_7:
		s_andn2_b64 exec, s[56:57], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_7
.Lwmma_f16_matmul_tiled.exec_endif_7:
		s_mov_b64 exec, s[56:57]
		s_add_i32 m0, s13, 0x10000
		s_add_i32 s44, s34, 0x80
		s_add_i32 s44, s44, s35
		v_add_u32_e32 v11, s44, v3
		buffer_load_dwordx4 v11, s[8:11], 0 offen lds
		s_add_i32 m0, s13, 0x12000
		v_add_u32_e32 v11, s35, v3
		v_add_u32_e32 v11, s34, v11
		v_add_u32_e32 v12, 0x80080, v11
		buffer_load_dwordx4 v12, s[8:11], 0 offen lds
		s_add_i32 m0, s13, 0x14000
		v_add_u32_e32 v12, 0xc0, v11
		buffer_load_dwordx4 v12, s[8:11], 0 offen lds
		s_add_i32 m0, s13, 0x16000
		v_add_u32_e32 v11, 0x800c0, v11
		buffer_load_dwordx4 v11, s[8:11], 0 offen lds
		s_add_i32 m0, s13, 0x18000
		s_add_i32 s34, s36, 0x80
		v_add_u32_e32 v11, s34, v3
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		s_add_i32 m0, s13, 0x1a000
		v_add_u32_e32 v3, s36, v3
		v_add_u32_e32 v11, 0x80080, v3
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		s_add_i32 m0, s13, 0x1c000
		v_add_u32_e32 v11, 0xc0, v3
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		s_add_i32 m0, s13, 0x1e000
		v_add_u32_e32 v3, 0x800c0, v3
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		s_waitcnt vmcnt(8)
		s_barrier
		s_add_i32 s34, s5, 0x10000
		s_add_i32 s34, s34, s6
		s_add_i32 s34, s34, s4
		v_and_b32_e32 v3, 15, v0
		s_add_i32 s35, s5, 0x10010
		s_add_i32 s35, s35, s6
		s_add_i32 s35, s35, s4
		s_add_i32 s36, s5, 0x10020
		v_lshrrev_b32_e32 v11, 1, v3
		s_add_i32 s36, s36, s6
		s_add_i32 s36, s36, s4
		s_add_i32 s44, s5, 0x10030
		s_add_i32 s44, s44, s6
		v_lshrrev_b32_e32 v12, 4, v2
		v_and_b32_e32 v11, 3, v11
		s_add_i32 s44, s44, s4
		s_add_i32 s45, s14, 0x10000
		s_add_i32 s45, s45, s7
		s_add_i32 s46, s14, 0x10010
		v_lshrrev_b32_e32 v0, 7, v0
		v_xor_b32_e32 v11, v12, v11
		v_and_b32_e32 v1, 1, v1
		s_add_i32 s46, s46, s7
		s_add_i32 s47, s5, 0x14000
		s_add_i32 s47, s47, s6
		s_add_i32 s47, s47, s4
		v_lshlrev_b32_e32 v12, 12, v0
		v_lshlrev_b32_e32 v3, 6, v3
		v_lshlrev_b32_e32 v11, 4, v11
		v_lshlrev_b32_e32 v13, 13, v1
		s_add_i32 s48, s5, 0x14010
		s_add_i32 s48, s48, s6
		s_add_i32 s48, s48, s4
		s_add_i32 s49, s5, 0x14020
		v_add3_u32 v14, v12, v3, v11
		v_add3_u32 v15, v3, v13, v11
		s_add_i32 s49, s49, s6
		s_add_i32 s49, s49, s4
		s_add_i32 s5, s5, 0x14030
		s_add_i32 s5, s5, s6
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
		s_add_i32 s4, s5, s4
		v_add_u32_e32 v14, 0x100, v9
		v_add_u32_e32 v15, 0x80100, v9
		v_add_u32_e32 v112, 0x140, v9
		v_add_u32_e32 v113, 0x80140, v9
		v_add_u32_e32 v9, 0x100, v10
		v_add_u32_e32 v114, 0x80100, v10
		v_add_u32_e32 v115, 0x140, v10
		v_add_u32_e32 v116, 0x80140, v10
		v_lshlrev_b32_e32 v0, 9, v0
		v_lshlrev_b32_e32 v2, 3, v2
		v_lshlrev_b32_e32 v10, 10, v1
		s_add_i32 s5, s14, 0x14000
		s_add_i32 s5, s5, s7
		s_add_i32 s6, s14, 0x14010
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
		s_waitcnt vmcnt(8)
		s_barrier
		s_lshl_b32 s50, s37, 7
		s_and_b32 s51, s37, 1
		s_lshl_b32 s51, s51, 13
		s_add_i32 s52, s51, 0x20000
		v_add3_u32 v117, s52, v0, v2
		ds_read_b64_tr_b8 v[118:119], v117
		ds_read_b64_tr_b8 v[244:245], v117 offset:4096
		v_add3_u32 v117, s52, v2, v10
		ds_read_b64_tr_b8 v[246:247], v117 offset:2048
		ds_read_b64_tr_b8 v[248:249], v117 offset:2560
		ds_read_b64_tr_b8 v[250:251], v117 offset:6144
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[16:19], v[48:51], v[4:7], v118, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b64_tr_b8 v[252:253], v117 offset:6656
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[16:19], v[52:55], v[120:123], v118, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[56:59], v[124:127], v118, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[60:63], v[128:131], v118, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], v[48:51], v[148:151], v118, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[52:55], v[152:155], v118, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[56:59], v[156:159], v118, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[60:63], v[160:163], v118, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[48:51], v[180:183], v118, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[52:55], v[184:187], v118, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[56:59], v[188:191], v118, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[60:63], v[192:195], v118, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[48:51], v[212:215], v118, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[28:31], v[52:55], v[216:219], v118, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[28:31], v[56:59], v[220:223], v118, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[60:63], v[224:227], v118, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[32:35], v[80:83], v[4:7], v244, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[32:35], v[84:87], v[120:123], v244, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], v[88:91], v[124:127], v244, v250 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[32:35], v[92:95], v[128:131], v244, v250 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[36:39], v[80:83], v[148:151], v244, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[36:39], v[84:87], v[152:155], v244, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[36:39], v[88:91], v[156:159], v244, v250 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[36:39], v[92:95], v[160:163], v244, v250 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[40:43], v[80:83], v[180:183], v244, v250 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[40:43], v[84:87], v[184:187], v244, v250 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[40:43], v[88:91], v[188:191], v244, v250 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[40:43], v[92:95], v[192:195], v244, v250 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[44:47], v[80:83], v[212:215], v244, v250 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[44:47], v[84:87], v[216:219], v244, v250 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[44:47], v[88:91], v[220:223], v244, v250 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[44:47], v[92:95], v[224:227], v244, v250 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s52, s40, s51
		s_lshl_b32 s53, s37, 15
		s_add_i32 s54, s34, s53
		v_lshl_add_u32 v48, v8, 12, s54
		s_add_i32 s54, s35, s53
		v_lshl_add_u32 v49, v8, 12, s54
		s_add_i32 s54, s36, s53
		v_lshl_add_u32 v50, v8, 12, s54
		s_add_i32 s54, s44, s53
		v_lshl_add_u32 v51, v8, 12, s54
		s_and_saveexec_b64 s[56:57], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_8
		s_add_i32 m0, s52, 0x20000
		s_nop 0
		buffer_load_dwordx4 v48, s[20:23], 0 offen lds
		s_add_i32 m0, s52, 0x20010
		s_nop 0
		buffer_load_dwordx4 v49, s[20:23], 0 offen lds
		s_add_i32 m0, s52, 0x20020
		s_nop 0
		buffer_load_dwordx4 v50, s[20:23], 0 offen lds
		s_add_i32 m0, s52, 0x20030
		s_nop 0
		buffer_load_dwordx4 v51, s[20:23], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_8:
		s_andn2_b64 exec, s[56:57], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_8
.Lwmma_f16_matmul_tiled.exec_endif_8:
		s_mov_b64 exec, s[56:57]
		s_add_i32 s51, s41, s51
		s_add_i32 s54, s45, s53
		v_lshl_add_u32 v48, v8, 12, s54
		s_add_i32 s54, s46, s53
		v_lshl_add_u32 v49, v8, 12, s54
		v_lshl_add_u32 v50, v8, 12, s53
		v_add_u32_e32 v50, s7, v50
		v_add_u32_e32 v50, s14, v50
		v_add_u32_e32 v51, 0x10020, v50
		v_add_u32_e32 v52, 0x10030, v50
		v_add_u32_e32 v50, 0x10040, v50
		v_lshl_add_u32 v53, v8, 12, s53
		v_add_u32_e32 v53, s7, v53
		v_add_u32_e32 v53, s14, v53
		v_add_u32_e32 v54, 0x10050, v53
		v_add_u32_e32 v55, 0x10060, v53
		v_add_u32_e32 v53, 0x10070, v53
		s_and_saveexec_b64 s[56:57], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_9
		s_add_i32 m0, s51, 0x20800
		s_nop 0
		buffer_load_dwordx4 v48, s[16:19], 0 offen lds
		s_add_i32 m0, s51, 0x20810
		s_nop 0
		buffer_load_dwordx4 v49, s[16:19], 0 offen lds
		s_add_i32 m0, s51, 0x20820
		s_nop 0
		buffer_load_dwordx4 v51, s[16:19], 0 offen lds
		s_add_i32 m0, s51, 0x20830
		s_nop 0
		buffer_load_dwordx4 v52, s[16:19], 0 offen lds
		s_add_i32 m0, s51, 0x20a00
		s_nop 0
		buffer_load_dwordx4 v50, s[16:19], 0 offen lds
		s_add_i32 m0, s51, 0x20a10
		s_nop 0
		buffer_load_dwordx4 v54, s[16:19], 0 offen lds
		s_add_i32 m0, s51, 0x20a20
		s_nop 0
		buffer_load_dwordx4 v55, s[16:19], 0 offen lds
		s_add_i32 m0, s51, 0x20a30
		s_nop 0
		buffer_load_dwordx4 v53, s[16:19], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_9:
		s_andn2_b64 exec, s[56:57], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_9
.Lwmma_f16_matmul_tiled.exec_endif_9:
		s_mov_b64 exec, s[56:57]
		s_add_i32 s54, s47, s53
		v_lshl_add_u32 v48, v8, 12, s54
		s_add_i32 s54, s48, s53
		v_lshl_add_u32 v49, v8, 12, s54
		s_add_i32 s54, s49, s53
		v_lshl_add_u32 v50, v8, 12, s54
		s_add_i32 s54, s4, s53
		v_lshl_add_u32 v51, v8, 12, s54
		s_and_saveexec_b64 s[56:57], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_10
		s_add_i32 m0, s52, 0x21000
		s_nop 0
		buffer_load_dwordx4 v48, s[20:23], 0 offen lds
		s_add_i32 m0, s52, 0x21010
		s_nop 0
		buffer_load_dwordx4 v49, s[20:23], 0 offen lds
		s_add_i32 m0, s52, 0x21020
		s_nop 0
		buffer_load_dwordx4 v50, s[20:23], 0 offen lds
		s_add_i32 m0, s52, 0x21030
		s_nop 0
		buffer_load_dwordx4 v51, s[20:23], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_10:
		s_andn2_b64 exec, s[56:57], s[38:39]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_10
.Lwmma_f16_matmul_tiled.exec_endif_10:
		s_mov_b64 exec, s[56:57]
		s_add_i32 s52, s5, s53
		v_lshl_add_u32 v48, v8, 12, s52
		s_add_i32 s52, s6, s53
		v_lshl_add_u32 v49, v8, 12, s52
		v_lshl_add_u32 v50, v8, 12, s53
		v_add_u32_e32 v50, s7, v50
		v_add_u32_e32 v50, s14, v50
		v_add_u32_e32 v51, 0x14020, v50
		v_add_u32_e32 v52, 0x14030, v50
		v_add_u32_e32 v50, 0x14040, v50
		v_lshl_add_u32 v53, v8, 12, s53
		v_add_u32_e32 v53, s7, v53
		v_add_u32_e32 v53, s14, v53
		v_add_u32_e32 v54, 0x14050, v53
		v_add_u32_e32 v55, 0x14060, v53
		v_add_u32_e32 v53, 0x14070, v53
		s_and_saveexec_b64 s[56:57], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_11
		s_add_i32 m0, s51, 0x21800
		s_nop 0
		buffer_load_dwordx4 v48, s[16:19], 0 offen lds
		s_add_i32 m0, s51, 0x21810
		s_nop 0
		buffer_load_dwordx4 v49, s[16:19], 0 offen lds
		s_add_i32 m0, s51, 0x21820
		s_nop 0
		buffer_load_dwordx4 v51, s[16:19], 0 offen lds
		s_add_i32 m0, s51, 0x21830
		s_nop 0
		buffer_load_dwordx4 v52, s[16:19], 0 offen lds
		s_add_i32 m0, s51, 0x21a00
		s_nop 0
		buffer_load_dwordx4 v50, s[16:19], 0 offen lds
		s_add_i32 m0, s51, 0x21a10
		s_nop 0
		buffer_load_dwordx4 v54, s[16:19], 0 offen lds
		s_add_i32 m0, s51, 0x21a20
		s_nop 0
		buffer_load_dwordx4 v55, s[16:19], 0 offen lds
		s_add_i32 m0, s51, 0x21a30
		s_nop 0
		buffer_load_dwordx4 v53, s[16:19], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_11:
		s_andn2_b64 exec, s[56:57], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_11
.Lwmma_f16_matmul_tiled.exec_endif_11:
		s_mov_b64 exec, s[56:57]
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[16:19], v[64:67], v[132:135], v118, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[68:71], v[136:139], v118, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[16:19], v[72:75], v[140:143], v118, v248 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[16:19], v[76:79], v[144:147], v118, v248 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[64:67], v[164:167], v118, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[68:71], v[168:171], v118, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[72:75], v[172:175], v118, v248 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[20:23], v[76:79], v[176:179], v118, v248 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[64:67], v[196:199], v118, v248 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[68:71], v[200:203], v118, v248 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[72:75], v[204:207], v118, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], v[76:79], v[208:211], v118, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], v[64:67], v[228:231], v118, v248 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[28:31], v[68:71], v[232:235], v118, v248 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[28:31], v[72:75], v[236:239], v118, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[28:31], v[76:79], v[240:243], v118, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], v[96:99], v[132:135], v244, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[32:35], v[100:103], v[136:139], v244, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[32:35], v[104:107], v[140:143], v244, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[32:35], v[108:111], v[144:147], v244, v252 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], v[96:99], v[164:167], v244, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], v[100:103], v[168:171], v244, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[36:39], v[104:107], v[172:175], v244, v252 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[36:39], v[108:111], v[176:179], v244, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[40:43], v[96:99], v[196:199], v244, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], v[100:103], v[200:203], v244, v252 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[40:43], v[104:107], v[204:207], v244, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[40:43], v[108:111], v[208:211], v244, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s13
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[44:47], v[96:99], v[228:231], v244, v252 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v14, s[8:11], s50 offen lds
		s_mov_b32 m0, s15
		s_nop 0
		buffer_load_dwordx4 v15, s[8:11], s50 offen lds
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v112, s[8:11], s50 offen lds
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v113, s[8:11], s50 offen lds
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v9, s[0:3], s50 offen lds
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v114, s[0:3], s50 offen lds
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v115, s[0:3], s50 offen lds
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v116, s[0:3], s50 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[44:47], v[100:103], v[232:235], v244, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[44:47], v[104:107], v[236:239], v244, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[44:47], v[108:111], v[240:243], v244, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(8)
		s_barrier
		s_add_i32 s37, s37, 1
		s_and_b32 s50, s37, 1
		s_lshl_b32 s50, s50, 16
		v_add_u32_e32 v16, s50, v12
		v_add3_u32 v48, v16, v3, v11
		ds_read_b128 v[16:19], v48
		ds_read_b128 v[20:23], v48 offset:1024
		ds_read_b128 v[24:27], v48 offset:2048
		ds_read_b128 v[28:31], v48 offset:3072
		ds_read_b128 v[32:35], v48 offset:16384
		ds_read_b128 v[36:39], v48 offset:17408
		ds_read_b128 v[40:43], v48 offset:18432
		ds_read_b128 v[44:47], v48 offset:19456
		v_add_u32_e32 v48, s50, v3
		v_add3_u32 v117, v48, v13, v11
		ds_read_b128 v[48:51], v117 offset:32768
		ds_read_b128 v[52:55], v117 offset:33792
		ds_read_b128 v[56:59], v117 offset:34816
		ds_read_b128 v[60:63], v117 offset:35840
		ds_read_b128 v[64:67], v117 offset:36864
		ds_read_b128 v[68:71], v117 offset:37888
		ds_read_b128 v[72:75], v117 offset:38912
		ds_read_b128 v[76:79], v117 offset:39936
		ds_read_b128 v[80:83], v117 offset:49152
		ds_read_b128 v[84:87], v117 offset:50176
		ds_read_b128 v[88:91], v117 offset:51200
		ds_read_b128 v[92:95], v117 offset:52224
		ds_read_b128 v[96:99], v117 offset:53248
		ds_read_b128 v[100:103], v117 offset:54272
		ds_read_b128 v[104:107], v117 offset:55296
		ds_read_b128 v[108:111], v117 offset:56320
		s_add_i32 s13, s13, 0x10000
		s_and_b32 s13, s13, 0x1ffff
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
		s_add_i32 s33, s33, 0x10000
		s_and_b32 s33, s33, 0x1ffff
		s_cmp_lt_i32 s37, 30
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_barrier
		s_waitcnt vmcnt(0)
		s_barrier
		s_barrier
		v_add_u32_e32 v0, 0x20000, v0
		v_add_u32_e32 v0, v0, v2
		ds_read_b64_tr_b8 v[8:9], v0
		ds_read_b64_tr_b8 v[14:15], v0 offset:4096
		ds_read_b64_tr_b8 v[112:113], v0 offset:8192
		ds_read_b64_tr_b8 v[114:115], v0 offset:12288
		v_add_u32_e32 v0, 0x20000, v2
		v_lshl_add_u32 v0, v1, 10, v0
		ds_read_b64_tr_b8 v[116:117], v0 offset:2048
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[16:19], v[48:51], v[4:7], v8, v116 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b64_tr_b8 v[118:119], v0 offset:2560
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[16:19], v[52:55], v[120:123], v8, v116 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b64_tr_b8 v[244:245], v0 offset:6144
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[56:59], v[124:127], v8, v116 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b64_tr_b8 v[246:247], v0 offset:6656
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[60:63], v[128:131], v8, v116 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b64_tr_b8 v[248:249], v0 offset:10240
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], v[48:51], v[148:151], v8, v116 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b64_tr_b8 v[250:251], v0 offset:10752
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[52:55], v[152:155], v8, v116 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b64_tr_b8 v[252:253], v0 offset:14336
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[56:59], v[156:159], v8, v116 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b64_tr_b8 v[254:255], v0 offset:14848
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[60:63], v[160:163], v8, v116 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[48:51], v[180:183], v8, v116 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[52:55], v[184:187], v8, v116 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[56:59], v[188:191], v8, v116 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[60:63], v[192:195], v8, v116 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[48:51], v[212:215], v8, v116 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[28:31], v[52:55], v[216:219], v8, v116 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[28:31], v[56:59], v[220:223], v8, v116 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[60:63], v[224:227], v8, v116 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[16:19], v[64:67], v[132:135], v8, v118 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[68:71], v[136:139], v8, v118 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[16:19], v[72:75], v[140:143], v8, v118 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[16:19], v[76:79], v[144:147], v8, v118 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[64:67], v[164:167], v8, v118 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[68:71], v[168:171], v8, v118 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[72:75], v[172:175], v8, v118 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[20:23], v[76:79], v[176:179], v8, v118 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[64:67], v[196:199], v8, v118 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[68:71], v[200:203], v8, v118 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[72:75], v[204:207], v8, v118 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], v[76:79], v[208:211], v8, v118 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], v[64:67], v[228:231], v8, v118 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[28:31], v[68:71], v[232:235], v8, v118 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[28:31], v[72:75], v[236:239], v8, v118 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[28:31], v[76:79], v[240:243], v8, v118 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[32:35], v[80:83], v[4:7], v14, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[32:35], v[84:87], v[120:123], v14, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], v[88:91], v[124:127], v14, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[32:35], v[92:95], v[128:131], v14, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[36:39], v[80:83], v[148:151], v14, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[36:39], v[84:87], v[152:155], v14, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[36:39], v[88:91], v[156:159], v14, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[36:39], v[92:95], v[160:163], v14, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[40:43], v[80:83], v[180:183], v14, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[40:43], v[84:87], v[184:187], v14, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[40:43], v[88:91], v[188:191], v14, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[40:43], v[92:95], v[192:195], v14, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[44:47], v[80:83], v[212:215], v14, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[44:47], v[84:87], v[216:219], v14, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[44:47], v[88:91], v[220:223], v14, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[44:47], v[92:95], v[224:227], v14, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], v[96:99], v[132:135], v14, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[32:35], v[100:103], v[136:139], v14, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[32:35], v[104:107], v[140:143], v14, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[32:35], v[108:111], v[144:147], v14, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], v[96:99], v[164:167], v14, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], v[100:103], v[168:171], v14, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[36:39], v[104:107], v[172:175], v14, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[36:39], v[108:111], v[176:179], v14, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[40:43], v[96:99], v[196:199], v14, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], v[100:103], v[200:203], v14, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[40:43], v[104:107], v[204:207], v14, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[40:43], v[108:111], v[208:211], v14, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[44:47], v[96:99], v[228:231], v14, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[44:47], v[100:103], v[232:235], v14, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[44:47], v[104:107], v[236:239], v14, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[44:47], v[108:111], v[240:243], v14, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_add_u32_e32 v0, 0x10000, v12
		v_add3_u32 v0, v0, v3, v11
		ds_read_b128 v[16:19], v0
		ds_read_b128 v[20:23], v0 offset:1024
		ds_read_b128 v[24:27], v0 offset:2048
		ds_read_b128 v[28:31], v0 offset:3072
		ds_read_b128 v[32:35], v0 offset:16384
		ds_read_b128 v[36:39], v0 offset:17408
		ds_read_b128 v[40:43], v0 offset:18432
		ds_read_b128 v[44:47], v0 offset:19456
		v_add_u32_e32 v0, 0x10000, v3
		v_add3_u32 v0, v0, v13, v11
		ds_read_b128 v[8:11], v0 offset:32768
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[16:19], v[8:11], v[4:7], v112, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[12:15], v0 offset:33792
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[16:19], v[12:15], v[120:123], v112, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[48:51], v0 offset:34816
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[48:51], v[124:127], v112, v248 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[52:55], v0 offset:35840
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[52:55], v[128:131], v112, v248 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[56:59], v0 offset:36864
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], v[8:11], v[148:151], v112, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[60:63], v0 offset:37888
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[12:15], v[152:155], v112, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[64:67], v0 offset:38912
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[48:51], v[156:159], v112, v248 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[68:71], v0 offset:39936
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[52:55], v[160:163], v112, v248 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[72:75], v0 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[8:11], v[180:183], v112, v248 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		ds_read_b128 v[76:79], v0 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[12:15], v[184:187], v112, v248 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		ds_read_b128 v[80:83], v0 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[48:51], v[188:191], v112, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_b128 v[84:87], v0 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[52:55], v[192:195], v112, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v0 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[8:11], v[212:215], v112, v248 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		ds_read_b128 v[8:11], v0 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[28:31], v[12:15], v[216:219], v112, v248 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		ds_read_b128 v[12:15], v0 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[28:31], v[48:51], v[220:223], v112, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_b128 v[48:51], v0 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[52:55], v[224:227], v112, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(7)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[32:35], v[72:75], v[4:7], v114, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[32:35], v[76:79], v[120:123], v114, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], v[80:83], v[124:127], v114, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[32:35], v[84:87], v[128:131], v114, v252 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[36:39], v[72:75], v[148:151], v114, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[36:39], v[76:79], v[152:155], v114, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[36:39], v[80:83], v[156:159], v114, v252 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[36:39], v[84:87], v[160:163], v114, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[40:43], v[72:75], v[180:183], v114, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[40:43], v[76:79], v[184:187], v114, v252 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[40:43], v[80:83], v[188:191], v114, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[40:43], v[84:87], v[192:195], v114, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[44:47], v[72:75], v[212:215], v114, v252 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[44:47], v[76:79], v[216:219], v114, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[44:47], v[80:83], v[220:223], v114, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[44:47], v[84:87], v[224:227], v114, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[16:19], v[56:59], v[132:135], v112, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v4, v5
		s_mov_b32 s0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[60:63], v[136:139], v112, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v1, v6, v7
		s_mov_b32 s1, 0x2000
		s_mov_b32 m0, s12
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[16:19], v[64:67], v[140:143], v112, v250 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v3
		s_waitcnt lgkmcnt(0)
		v_lshl_add_u32 v2, v3, 14, v2
		buffer_store_dwordx2 v[0:1], v2, s[24:27], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[16:19], v[68:71], v[144:147], v112, v250 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v120, v121
		s_mov_b32 s2, 0x3000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[56:59], v[164:167], v112, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v1, v122, v123
		buffer_store_dwordx2 v[0:1], v2, s[24:27], 0 offen offset:512
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[60:63], v[168:171], v112, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v124, v125
		v_cvt_pk_f16_f32 v1, v126, v127
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[64:67], v[172:175], v112, v250 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_store_dwordx2 v[0:1], v2, s[24:27], 0 offen offset:1024
		v_cvt_pk_f16_f32 v0, v128, v129
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[20:23], v[68:71], v[176:179], v112, v250 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v1, v130, v131
		buffer_store_dwordx2 v[0:1], v2, s[24:27], 0 offen offset:1536
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[56:59], v[196:199], v112, v250 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v148, v149
		v_cvt_pk_f16_f32 v1, v150, v151
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[60:63], v[200:203], v112, v250 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_store_dwordx2 v[0:1], v2, s[24:27], s0 offen
		v_cvt_pk_f16_f32 v0, v152, v153
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[64:67], v[204:207], v112, v250 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v1, v154, v155
		buffer_store_dwordx2 v[0:1], v2, s[24:27], s0 offen offset:512
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], v[68:71], v[208:211], v112, v250 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v156, v157
		v_cvt_pk_f16_f32 v1, v158, v159
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], v[56:59], v[228:231], v112, v250 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_store_dwordx2 v[0:1], v2, s[24:27], s0 offen offset:1024
		v_cvt_pk_f16_f32 v0, v160, v161
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[28:31], v[60:63], v[232:235], v112, v250 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v1, v162, v163
		buffer_store_dwordx2 v[0:1], v2, s[24:27], s0 offen offset:1536
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[28:31], v[64:67], v[236:239], v112, v250 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v180, v181
		v_cvt_pk_f16_f32 v1, v182, v183
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[28:31], v[68:71], v[240:243], v112, v250 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_store_dwordx2 v[0:1], v2, s[24:27], s1 offen
		v_cvt_pk_f16_f32 v0, v184, v185
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], v[88:91], v[132:135], v114, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v1, v186, v187
		buffer_store_dwordx2 v[0:1], v2, s[24:27], s1 offen offset:512
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[32:35], v[8:11], v[136:139], v114, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v188, v189
		v_cvt_pk_f16_f32 v1, v190, v191
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[32:35], v[12:15], v[140:143], v114, v254 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_store_dwordx2 v[0:1], v2, s[24:27], s1 offen offset:1024
		v_cvt_pk_f16_f32 v0, v192, v193
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[32:35], v[48:51], v[144:147], v114, v254 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v1, v194, v195
		buffer_store_dwordx2 v[0:1], v2, s[24:27], s1 offen offset:1536
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], v[88:91], v[164:167], v114, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v212, v213
		v_cvt_pk_f16_f32 v1, v214, v215
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], v[8:11], v[168:171], v114, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_store_dwordx2 v[0:1], v2, s[24:27], s2 offen
		v_cvt_pk_f16_f32 v0, v216, v217
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[36:39], v[12:15], v[172:175], v114, v254 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v1, v218, v219
		buffer_store_dwordx2 v[0:1], v2, s[24:27], s2 offen offset:512
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[36:39], v[48:51], v[176:179], v114, v254 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v220, v221
		v_cvt_pk_f16_f32 v1, v222, v223
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[40:43], v[88:91], v[196:199], v114, v254 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_store_dwordx2 v[0:1], v2, s[24:27], s2 offen offset:1024
		v_cvt_pk_f16_f32 v0, v224, v225
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], v[8:11], v[200:203], v114, v254 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v1, v226, v227
		buffer_store_dwordx2 v[0:1], v2, s[24:27], s2 offen offset:1536
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[40:43], v[12:15], v[204:207], v114, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v132, v133
		v_cvt_pk_f16_f32 v1, v134, v135
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[40:43], v[48:51], v[208:211], v114, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_store_dwordx2 v[0:1], v2, s[24:27], 0 offen offset:2048
		v_cvt_pk_f16_f32 v0, v136, v137
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[44:47], v[88:91], v[228:231], v114, v254 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v1, v138, v139
		buffer_store_dwordx2 v[0:1], v2, s[24:27], 0 offen offset:2560
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[44:47], v[8:11], v[232:235], v114, v254 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v140, v141
		v_cvt_pk_f16_f32 v1, v142, v143
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[44:47], v[12:15], v[236:239], v114, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_store_dwordx2 v[0:1], v2, s[24:27], 0 offen offset:3072
		v_cvt_pk_f16_f32 v0, v144, v145
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[44:47], v[48:51], v[240:243], v114, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v1, v146, v147
		buffer_store_dwordx2 v[0:1], v2, s[24:27], 0 offen offset:3584
		v_cvt_pk_f16_f32 v0, v164, v165
		v_cvt_pk_f16_f32 v1, v166, v167
		buffer_store_dwordx2 v[0:1], v2, s[24:27], s0 offen offset:2048
		v_cvt_pk_f16_f32 v0, v168, v169
		v_cvt_pk_f16_f32 v1, v170, v171
		buffer_store_dwordx2 v[0:1], v2, s[24:27], s0 offen offset:2560
		v_cvt_pk_f16_f32 v0, v172, v173
		v_cvt_pk_f16_f32 v1, v174, v175
		buffer_store_dwordx2 v[0:1], v2, s[24:27], s0 offen offset:3072
		v_cvt_pk_f16_f32 v0, v176, v177
		v_cvt_pk_f16_f32 v1, v178, v179
		buffer_store_dwordx2 v[0:1], v2, s[24:27], s0 offen offset:3584
		v_cvt_pk_f16_f32 v0, v196, v197
		v_cvt_pk_f16_f32 v1, v198, v199
		buffer_store_dwordx2 v[0:1], v2, s[24:27], s1 offen offset:2048
		v_cvt_pk_f16_f32 v0, v200, v201
		v_cvt_pk_f16_f32 v1, v202, v203
		buffer_store_dwordx2 v[0:1], v2, s[24:27], s1 offen offset:2560
		v_cvt_pk_f16_f32 v0, v204, v205
		v_cvt_pk_f16_f32 v1, v206, v207
		buffer_store_dwordx2 v[0:1], v2, s[24:27], s1 offen offset:3072
		v_cvt_pk_f16_f32 v0, v208, v209
		v_cvt_pk_f16_f32 v1, v210, v211
		buffer_store_dwordx2 v[0:1], v2, s[24:27], s1 offen offset:3584
		v_cvt_pk_f16_f32 v0, v228, v229
		v_cvt_pk_f16_f32 v1, v230, v231
		buffer_store_dwordx2 v[0:1], v2, s[24:27], s2 offen offset:2048
		v_cvt_pk_f16_f32 v0, v232, v233
		v_cvt_pk_f16_f32 v1, v234, v235
		buffer_store_dwordx2 v[0:1], v2, s[24:27], s2 offen offset:2560
		v_cvt_pk_f16_f32 v0, v236, v237
		v_cvt_pk_f16_f32 v1, v238, v239
		buffer_store_dwordx2 v[0:1], v2, s[24:27], s2 offen offset:3072
		v_cvt_pk_f16_f32 v0, v240, v241
		v_cvt_pk_f16_f32 v1, v242, v243
		buffer_store_dwordx2 v[0:1], v2, s[24:27], s2 offen offset:3584
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 2048
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
		.amdhsa_next_free_sgpr 58
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
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 58
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
    .group_segment_fixed_size: 2048
    .kernarg_segment_align: 8
    .kernarg_segment_size: 48
    .max_flat_workgroup_size: 512
    .name:           wmma_f16_matmul_tiled
    .private_segment_fixed_size: 0
    .sgpr_count:     58
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     256
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
