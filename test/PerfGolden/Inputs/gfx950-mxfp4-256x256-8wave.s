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
		v_mov_b32_e32 v2, 4
		ds_write_b32 v2, v1
		v_mov_b32_e32 v3, 8
		ds_write_b32 v3, v1
		v_mov_b32_e32 v3, 12
		ds_write_b32 v3, v1
		v_mov_b32_e32 v3, 16
		ds_write_b32 v3, v1
		v_mov_b32_e32 v3, 20
		ds_write_b32 v3, v1
		v_mov_b32_e32 v3, 24
		ds_write_b32 v3, v1
		s_mov_b64 exec, s[18:19]
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mov_b32 s22, 0x7fffffff
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
		s_add_u32 s28, s6, s12
		s_addc_u32 s29, s7, 0
		s_mov_b32 s30, 0x20000
		s_mov_b32 s31, s23
		v_readfirstlane_b32 s6, v0
		s_lshr_b32 s7, s6, 6
		s_lshl_b32 s12, s7, 10
		s_add_i32 s14, s12, 0x2000
		s_add_i32 s15, s12, 0x4000
		s_add_i32 s18, s12, 0x6000
		s_add_i32 s19, s12, 0x8000
		s_add_i32 s32, s12, 0xa000
		s_add_i32 s33, s12, 0xc000
		s_add_i32 s34, s12, 0xe000
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		v_lshrrev_b32_e32 v3, 6, v0
		v_and_b32_e32 v8, 63, v0
		v_lshrrev_b32_e32 v9, 2, v8
		v_lshlrev_b32_e32 v9, 12, v9
		v_lshl_add_u32 v9, v3, 16, v9
		v_lshrrev_b32_e32 v10, 3, v8
		v_and_b32_e32 v11, 3, v10
		v_and_b32_e32 v12, 3, v8
		v_xor_b32_e32 v11, v11, v12
		v_lshl_add_u32 v9, v11, 4, v9
		s_lshl_b32 s35, s5, 22
		s_lshl_b32 s36, s4, 20
		s_add_i32 s37, s35, s36
		v_add_u32_e32 v11, s37, v9
		s_add_i32 m0, s12, 28
		s_nop 0
		buffer_load_dwordx4 v11, s[8:11], 0 offen lds
		s_add_i32 s37, s35, 0x80000
		v_add_u32_e32 v12, s36, v9
		v_add_u32_e32 v13, s37, v12
		s_add_i32 m0, s12, 0x201c
		s_nop 0
		buffer_load_dwordx4 v13, s[8:11], 0 offen lds
		v_add3_u32 v13, s35, 64, v12
		s_add_i32 m0, s12, 0x401c
		s_nop 0
		buffer_load_dwordx4 v13, s[8:11], 0 offen lds
		s_add_i32 s37, s35, 0x80040
		v_add_u32_e32 v12, s37, v12
		s_add_i32 m0, s12, 0x601c
		s_nop 0
		buffer_load_dwordx4 v12, s[8:11], 0 offen lds
		s_lshl_b32 s37, s13, 20
		v_add_u32_e32 v12, s37, v9
		s_add_i32 m0, s12, 0x801c
		s_nop 0
		buffer_load_dwordx4 v12, s[0:3], 0 offen lds
		s_add_i32 s38, s37, 0x80000
		v_add_u32_e32 v13, s38, v9
		s_add_i32 m0, s12, 0xa01c
		s_nop 0
		buffer_load_dwordx4 v13, s[0:3], 0 offen lds
		v_add3_u32 v13, s37, 64, v9
		s_add_i32 m0, s12, 0xc01c
		s_nop 0
		buffer_load_dwordx4 v13, s[0:3], 0 offen lds
		s_add_i32 s38, s37, 0x80040
		v_add_u32_e32 v13, s38, v9
		v_and_b32_e32 v14, 39, v0
		v_and_or_b32 v15, 1, v3, v14
		s_mov_b32 s38, 0
		v_cmp_eq_u32_e64 vcc, v15, s38
		s_mov_b64 s[40:41], vcc
		s_lshr_b32 s6, s6, 7
		s_lshl_b32 s39, s6, 9
		s_lshl_b32 s5, s5, 10
		s_lshl_b32 s6, s6, 6
		s_add_i32 s42, s5, s6
		s_lshl_b32 s4, s4, 8
		s_add_i32 s42, s42, s4
		v_lshl_add_u32 v15, v10, 12, s42
		v_lshl_add_u32 v16, v10, 12, s4
		v_add_u32_e32 v16, s6, v16
		v_add3_u32 v17, s5, 16, v16
		v_add3_u32 v18, s5, 32, v16
		v_add3_u32 v16, s5, 48, v16
		s_add_i32 m0, s12, 0xe01c
		s_nop 0
		buffer_load_dwordx4 v13, s[0:3], 0 offen lds
		s_and_saveexec_b64 s[58:59], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_0
		s_add_i32 m0, s39, 0x2001c
		s_nop 0
		buffer_load_dwordx4 v15, s[24:27], 0 offen lds
		s_add_i32 m0, s39, 0x2002c
		s_nop 0
		buffer_load_dwordx4 v17, s[24:27], 0 offen lds
		s_add_i32 m0, s39, 0x2003c
		s_nop 0
		buffer_load_dwordx4 v18, s[24:27], 0 offen lds
		s_add_i32 m0, s39, 0x2004c
		s_nop 0
		buffer_load_dwordx4 v16, s[24:27], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_0:
		s_andn2_b64 exec, s[58:59], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_0
.Lwmma_f16_matmul_tiled.exec_endif_0:
		s_mov_b64 exec, s[58:59]
		v_lshrrev_b32_e32 v13, 1, v3
		v_or_b32_e32 v13, v14, v13
		v_cmp_eq_u32_e64 vcc, v13, s38
		s_mov_b64 s[42:43], vcc
		s_and_b32 s7, s7, 1
		s_lshl_b32 s44, s7, 10
		s_lshl_b32 s13, s13, 8
		s_lshl_b32 s7, s7, 7
		s_add_i32 s45, s13, s7
		v_lshl_add_u32 v13, v10, 12, s45
		s_add_i32 s45, s13, 16
		s_add_i32 s45, s45, s7
		v_lshl_add_u32 v14, v10, 12, s45
		v_lshl_add_u32 v15, v10, 12, s7
		v_add3_u32 v16, s13, 32, v15
		v_add3_u32 v17, s13, 48, v15
		v_add3_u32 v15, s13, 64, v15
		v_lshl_add_u32 v18, v10, 12, s7
		v_add_u32_e32 v18, s13, v18
		v_add_u32_e32 v19, 0x50, v18
		v_add_u32_e32 v20, 0x60, v18
		v_add_u32_e32 v18, 0x70, v18
		s_and_saveexec_b64 s[58:59], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_1
		s_add_i32 m0, s44, 0x2081c
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		s_add_i32 m0, s44, 0x2082c
		s_nop 0
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		s_add_i32 m0, s44, 0x2083c
		s_nop 0
		buffer_load_dwordx4 v16, s[20:23], 0 offen lds
		s_add_i32 m0, s44, 0x2084c
		s_nop 0
		buffer_load_dwordx4 v17, s[20:23], 0 offen lds
		s_add_i32 m0, s44, 0x20a1c
		s_nop 0
		buffer_load_dwordx4 v15, s[20:23], 0 offen lds
		s_add_i32 m0, s44, 0x20a2c
		s_nop 0
		buffer_load_dwordx4 v19, s[20:23], 0 offen lds
		s_add_i32 m0, s44, 0x20a3c
		s_nop 0
		buffer_load_dwordx4 v20, s[20:23], 0 offen lds
		s_add_i32 m0, s44, 0x20a4c
		s_nop 0
		buffer_load_dwordx4 v18, s[20:23], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_1:
		s_andn2_b64 exec, s[58:59], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_1
.Lwmma_f16_matmul_tiled.exec_endif_1:
		s_mov_b64 exec, s[58:59]
		s_add_i32 s45, s5, 0x4000
		s_add_i32 s45, s45, s6
		s_add_i32 s45, s45, s4
		v_lshl_add_u32 v13, v10, 12, s45
		v_lshl_add_u32 v14, v10, 12, s4
		v_add_u32_e32 v14, s6, v14
		v_add_u32_e32 v14, s5, v14
		v_add_u32_e32 v15, 0x4010, v14
		v_add_u32_e32 v16, 0x4020, v14
		v_add_u32_e32 v14, 0x4030, v14
		s_and_saveexec_b64 s[58:59], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_2
		s_add_i32 m0, s39, 0x2101c
		s_nop 0
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		s_add_i32 m0, s39, 0x2102c
		s_nop 0
		buffer_load_dwordx4 v15, s[24:27], 0 offen lds
		s_add_i32 m0, s39, 0x2103c
		s_nop 0
		buffer_load_dwordx4 v16, s[24:27], 0 offen lds
		s_add_i32 m0, s39, 0x2104c
		s_nop 0
		buffer_load_dwordx4 v14, s[24:27], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_2:
		s_andn2_b64 exec, s[58:59], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_2
.Lwmma_f16_matmul_tiled.exec_endif_2:
		s_mov_b64 exec, s[58:59]
		s_add_i32 s45, s13, 0x4000
		s_add_i32 s45, s45, s7
		v_lshl_add_u32 v13, v10, 12, s45
		s_add_i32 s45, s13, 0x4010
		s_add_i32 s45, s45, s7
		v_lshl_add_u32 v14, v10, 12, s45
		v_lshl_add_u32 v15, v10, 12, s7
		v_add_u32_e32 v15, s13, v15
		v_add_u32_e32 v16, 0x4020, v15
		v_add_u32_e32 v17, 0x4030, v15
		v_add_u32_e32 v15, 0x4040, v15
		v_lshl_add_u32 v18, v10, 12, s7
		v_add_u32_e32 v18, s13, v18
		v_add_u32_e32 v19, 0x4050, v18
		v_add_u32_e32 v20, 0x4060, v18
		v_add_u32_e32 v18, 0x4070, v18
		s_and_saveexec_b64 s[58:59], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_3
		s_add_i32 m0, s44, 0x2181c
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		s_add_i32 m0, s44, 0x2182c
		s_nop 0
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		s_add_i32 m0, s44, 0x2183c
		s_nop 0
		buffer_load_dwordx4 v16, s[20:23], 0 offen lds
		s_add_i32 m0, s44, 0x2184c
		s_nop 0
		buffer_load_dwordx4 v17, s[20:23], 0 offen lds
		s_add_i32 m0, s44, 0x21a1c
		s_nop 0
		buffer_load_dwordx4 v15, s[20:23], 0 offen lds
		s_add_i32 m0, s44, 0x21a2c
		s_nop 0
		buffer_load_dwordx4 v19, s[20:23], 0 offen lds
		s_add_i32 m0, s44, 0x21a3c
		s_nop 0
		buffer_load_dwordx4 v20, s[20:23], 0 offen lds
		s_add_i32 m0, s44, 0x21a4c
		s_nop 0
		buffer_load_dwordx4 v18, s[20:23], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_3:
		s_andn2_b64 exec, s[58:59], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_3
.Lwmma_f16_matmul_tiled.exec_endif_3:
		s_mov_b64 exec, s[58:59]
		s_add_i32 s45, s5, 0x8000
		s_add_i32 s45, s45, s6
		s_add_i32 s45, s45, s4
		v_lshl_add_u32 v13, v10, 12, s45
		v_lshl_add_u32 v14, v10, 12, s4
		v_add_u32_e32 v14, s6, v14
		v_add_u32_e32 v14, s5, v14
		v_add_u32_e32 v15, 0x8010, v14
		v_add_u32_e32 v16, 0x8020, v14
		v_add_u32_e32 v14, 0x8030, v14
		s_and_saveexec_b64 s[58:59], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_4
		s_add_i32 m0, s39, 0x2201c
		s_nop 0
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		s_add_i32 m0, s39, 0x2202c
		s_nop 0
		buffer_load_dwordx4 v15, s[24:27], 0 offen lds
		s_add_i32 m0, s39, 0x2203c
		s_nop 0
		buffer_load_dwordx4 v16, s[24:27], 0 offen lds
		s_add_i32 m0, s39, 0x2204c
		s_nop 0
		buffer_load_dwordx4 v14, s[24:27], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_4:
		s_andn2_b64 exec, s[58:59], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_4
.Lwmma_f16_matmul_tiled.exec_endif_4:
		s_mov_b64 exec, s[58:59]
		s_add_i32 s45, s13, 0x8000
		s_add_i32 s45, s45, s7
		v_lshl_add_u32 v13, v10, 12, s45
		s_add_i32 s45, s13, 0x8010
		s_add_i32 s45, s45, s7
		v_lshl_add_u32 v14, v10, 12, s45
		v_lshl_add_u32 v15, v10, 12, s7
		v_add_u32_e32 v15, s13, v15
		v_add_u32_e32 v16, 0x8020, v15
		v_add_u32_e32 v17, 0x8030, v15
		v_add_u32_e32 v15, 0x8040, v15
		v_lshl_add_u32 v18, v10, 12, s7
		v_add_u32_e32 v18, s13, v18
		v_add_u32_e32 v19, 0x8050, v18
		v_add_u32_e32 v20, 0x8060, v18
		v_add_u32_e32 v18, 0x8070, v18
		s_and_saveexec_b64 s[58:59], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_5
		s_add_i32 m0, s44, 0x2281c
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		s_add_i32 m0, s44, 0x2282c
		s_nop 0
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		s_add_i32 m0, s44, 0x2283c
		s_nop 0
		buffer_load_dwordx4 v16, s[20:23], 0 offen lds
		s_add_i32 m0, s44, 0x2284c
		s_nop 0
		buffer_load_dwordx4 v17, s[20:23], 0 offen lds
		s_add_i32 m0, s44, 0x22a1c
		s_nop 0
		buffer_load_dwordx4 v15, s[20:23], 0 offen lds
		s_add_i32 m0, s44, 0x22a2c
		s_nop 0
		buffer_load_dwordx4 v19, s[20:23], 0 offen lds
		s_add_i32 m0, s44, 0x22a3c
		s_nop 0
		buffer_load_dwordx4 v20, s[20:23], 0 offen lds
		s_add_i32 m0, s44, 0x22a4c
		s_nop 0
		buffer_load_dwordx4 v18, s[20:23], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_5:
		s_andn2_b64 exec, s[58:59], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_5
.Lwmma_f16_matmul_tiled.exec_endif_5:
		s_mov_b64 exec, s[58:59]
		s_add_i32 s45, s5, 0xc000
		s_add_i32 s45, s45, s6
		s_add_i32 s45, s45, s4
		v_lshl_add_u32 v13, v10, 12, s45
		v_lshl_add_u32 v14, v10, 12, s4
		v_add_u32_e32 v14, s6, v14
		v_add_u32_e32 v14, s5, v14
		v_add_u32_e32 v15, 0xc010, v14
		v_add_u32_e32 v16, 0xc020, v14
		v_add_u32_e32 v14, 0xc030, v14
		s_and_saveexec_b64 s[58:59], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_6
		s_add_i32 m0, s39, 0x2301c
		s_nop 0
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		s_add_i32 m0, s39, 0x2302c
		s_nop 0
		buffer_load_dwordx4 v15, s[24:27], 0 offen lds
		s_add_i32 m0, s39, 0x2303c
		s_nop 0
		buffer_load_dwordx4 v16, s[24:27], 0 offen lds
		s_add_i32 m0, s39, 0x2304c
		s_nop 0
		buffer_load_dwordx4 v14, s[24:27], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_6:
		s_andn2_b64 exec, s[58:59], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_6
.Lwmma_f16_matmul_tiled.exec_endif_6:
		s_mov_b64 exec, s[58:59]
		s_add_i32 s45, s13, 0xc000
		s_add_i32 s45, s45, s7
		v_lshl_add_u32 v13, v10, 12, s45
		s_add_i32 s45, s13, 0xc010
		s_add_i32 s45, s45, s7
		v_lshl_add_u32 v14, v10, 12, s45
		v_lshl_add_u32 v15, v10, 12, s7
		v_add_u32_e32 v15, s13, v15
		v_add_u32_e32 v16, 0xc020, v15
		v_add_u32_e32 v17, 0xc030, v15
		v_add_u32_e32 v15, 0xc040, v15
		v_lshl_add_u32 v18, v10, 12, s7
		v_add_u32_e32 v18, s13, v18
		v_add_u32_e32 v19, 0xc050, v18
		v_add_u32_e32 v20, 0xc060, v18
		v_add_u32_e32 v18, 0xc070, v18
		s_and_saveexec_b64 s[58:59], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_7
		s_add_i32 m0, s44, 0x2381c
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		s_add_i32 m0, s44, 0x2382c
		s_nop 0
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		s_add_i32 m0, s44, 0x2383c
		s_nop 0
		buffer_load_dwordx4 v16, s[20:23], 0 offen lds
		s_add_i32 m0, s44, 0x2384c
		s_nop 0
		buffer_load_dwordx4 v17, s[20:23], 0 offen lds
		s_add_i32 m0, s44, 0x23a1c
		s_nop 0
		buffer_load_dwordx4 v15, s[20:23], 0 offen lds
		s_add_i32 m0, s44, 0x23a2c
		s_nop 0
		buffer_load_dwordx4 v19, s[20:23], 0 offen lds
		s_add_i32 m0, s44, 0x23a3c
		s_nop 0
		buffer_load_dwordx4 v20, s[20:23], 0 offen lds
		s_add_i32 m0, s44, 0x23a4c
		s_nop 0
		buffer_load_dwordx4 v18, s[20:23], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_7:
		s_andn2_b64 exec, s[58:59], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_7
.Lwmma_f16_matmul_tiled.exec_endif_7:
		s_mov_b64 exec, s[58:59]
		v_mov_b32_e32 v13, 1
		s_and_saveexec_b64 s[46:47], s[16:17]
		s_waitcnt vmcnt(0)
		ds_add_rtn_u32 v14, v1, v13
		s_mov_b64 exec, s[46:47]
		s_add_i32 s45, s35, 0x80
		s_add_i32 s45, s45, s36
		v_add_u32_e32 v15, s45, v9
		s_add_i32 m0, s12, 0x1001c
		s_nop 0
		buffer_load_dwordx4 v15, s[8:11], 0 offen lds
		v_add_u32_e32 v15, s36, v9
		v_add_u32_e32 v15, s35, v15
		v_add_u32_e32 v16, 0x80080, v15
		s_add_i32 m0, s12, 0x1201c
		s_nop 0
		buffer_load_dwordx4 v16, s[8:11], 0 offen lds
		v_add_u32_e32 v16, 0xc0, v15
		s_add_i32 m0, s12, 0x1401c
		s_nop 0
		buffer_load_dwordx4 v16, s[8:11], 0 offen lds
		v_add_u32_e32 v15, 0x800c0, v15
		s_add_i32 m0, s12, 0x1601c
		s_nop 0
		buffer_load_dwordx4 v15, s[8:11], 0 offen lds
		s_add_i32 s35, s37, 0x80
		v_add_u32_e32 v15, s35, v9
		s_add_i32 m0, s12, 0x1801c
		s_nop 0
		buffer_load_dwordx4 v15, s[0:3], 0 offen lds
		v_add_u32_e32 v9, s37, v9
		v_add_u32_e32 v15, 0x80080, v9
		s_add_i32 m0, s12, 0x1a01c
		s_nop 0
		buffer_load_dwordx4 v15, s[0:3], 0 offen lds
		v_add_u32_e32 v15, 0xc0, v9
		s_add_i32 m0, s12, 0x1c01c
		s_nop 0
		buffer_load_dwordx4 v15, s[0:3], 0 offen lds
		v_add_u32_e32 v9, 0x800c0, v9
		v_lshrrev_b32_e32 v15, 7, v0
		v_lshlrev_b32_e32 v16, 12, v15
		v_and_b32_e32 v17, 15, v0
		v_lshlrev_b32_e32 v18, 6, v17
		v_lshrrev_b32_e32 v19, 4, v8
		v_lshrrev_b32_e32 v17, 1, v17
		v_and_b32_e32 v17, 3, v17
		v_xor_b32_e32 v17, v19, v17
		v_lshlrev_b32_e32 v17, 4, v17
		v_add3_u32 v16, v16, v18, v17
		v_and_b32_e32 v3, 1, v3
		v_lshlrev_b32_e32 v19, 13, v3
		v_add3_u32 v18, v18, v19, v17
		v_add_u32_e32 v20, 0x100, v11
		v_add_u32_e32 v21, 0x80100, v11
		v_add_u32_e32 v22, 0x140, v11
		v_add_u32_e32 v23, 0x80140, v11
		v_add_u32_e32 v11, 0x100, v12
		v_add_u32_e32 v24, 0x80100, v12
		v_add_u32_e32 v25, 0x140, v12
		s_add_i32 m0, s12, 0x1e01c
		s_nop 0
		buffer_load_dwordx4 v9, s[0:3], 0 offen lds
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s35, v14
		s_and_b32 s35, s35, -8
		s_add_i32 s35, s35, 8
		s_and_saveexec_b64 s[36:37], s[16:17]
.Lwmma_f16_matmul_tiled.loop_head_0:
		ds_read_b32 v9, v1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s45, v9
		s_xor_b32 s46, s35, -1
		s_add_i32 s46, s46, 1
		s_add_i32 s45, s45, s46
		s_cmp_ge_u32 s45, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_mov_b64 exec, s[36:37]
		v_add_u32_e32 v1, 28, v16
		ds_read_b128 v[28:31], v1
		ds_read_b128 v[32:35], v1 offset:1024
		ds_read_b128 v[36:39], v1 offset:2048
		ds_read_b128 v[40:43], v1 offset:3072
		ds_read_b128 v[44:47], v1 offset:16384
		ds_read_b128 v[48:51], v1 offset:17408
		ds_read_b128 v[52:55], v1 offset:18432
		ds_read_b128 v[56:59], v1 offset:19456
		v_add_u32_e32 v1, 28, v18
		ds_read_b128 v[60:63], v1 offset:32768
		ds_read_b128 v[64:67], v1 offset:33792
		ds_read_b128 v[68:71], v1 offset:34816
		ds_read_b128 v[72:75], v1 offset:35840
		ds_read_b128 v[76:79], v1 offset:36864
		ds_read_b128 v[80:83], v1 offset:37888
		ds_read_b128 v[84:87], v1 offset:38912
		ds_read_b128 v[88:91], v1 offset:39936
		ds_read_b128 v[92:95], v1 offset:49152
		ds_read_b128 v[96:99], v1 offset:50176
		ds_read_b128 v[100:103], v1 offset:51200
		ds_read_b128 v[104:107], v1 offset:52224
		ds_read_b128 v[108:111], v1 offset:53248
		ds_read_b128 v[112:115], v1 offset:54272
		ds_read_b128 v[116:119], v1 offset:55296
		ds_read_b128 v[120:123], v1 offset:56320
		v_add_u32_e32 v1, 0x80140, v12
		v_lshlrev_b32_e32 v9, 9, v15
		v_lshlrev_b32_e32 v8, 3, v8
		v_lshlrev_b32_e32 v3, 10, v3
		s_add_i32 s35, s5, 0x10000
		s_add_i32 s35, s35, s6
		s_add_i32 s35, s35, s4
		s_add_i32 s36, s5, 0x10010
		s_add_i32 s36, s36, s6
		s_add_i32 s36, s36, s4
		s_add_i32 s37, s5, 0x10020
		s_add_i32 s37, s37, s6
		s_add_i32 s37, s37, s4
		s_add_i32 s45, s5, 0x10030
		s_add_i32 s45, s45, s6
		s_add_i32 s45, s45, s4
		s_add_i32 s46, s13, 0x10000
		s_add_i32 s46, s46, s7
		s_add_i32 s47, s13, 0x10010
		s_add_i32 s47, s47, s7
		s_add_i32 s48, s5, 0x14000
		s_add_i32 s48, s48, s6
		s_add_i32 s48, s48, s4
		s_add_i32 s49, s5, 0x14010
		s_add_i32 s49, s49, s6
		s_add_i32 s49, s49, s4
		s_add_i32 s50, s5, 0x14020
		s_add_i32 s50, s50, s6
		s_add_i32 s50, s50, s4
		s_add_i32 s5, s5, 0x14030
		s_add_i32 s5, s5, s6
		s_add_i32 s4, s5, s4
		s_add_i32 s5, s13, 0x14000
		s_add_i32 s5, s5, s7
		s_add_i32 s6, s13, 0x14010
		s_add_i32 s6, s6, s7
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
		v_mov_b64_e32 v[244:245], 0
		v_mov_b64_e32 v[246:247], 0
.Lwmma_f16_matmul_tiled.loop_head_1:
		s_and_saveexec_b64 s[52:53], s[16:17]
		s_waitcnt vmcnt(8) lgkmcnt(0)
		ds_add_rtn_u32 v12, v2, v13
		s_mov_b64 exec, s[52:53]
		s_and_b32 s51, s38, 1
		s_lshl_b32 s51, s51, 13
		s_add_i32 s52, s51, 0x20000
		v_add3_u32 v14, s52, v9, v8
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s53, v12
		s_and_b32 s53, s53, -8
		s_add_i32 s53, s53, 8
		s_and_saveexec_b64 s[54:55], s[16:17]
.Lwmma_f16_matmul_tiled.loop_head_2:
		ds_read_b32 v12, v2
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s56, v12
		s_xor_b32 s57, s53, -1
		s_add_i32 s57, s57, 1
		s_add_i32 s56, s56, s57
		s_cmp_ge_u32 s56, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_2
.Lwmma_f16_matmul_tiled.loop_exit_2:
		s_mov_b64 exec, s[54:55]
		v_add_u32_e32 v12, 28, v14
		ds_read_b64_tr_b8 v[14:15], v12
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v15, s52, v8, v3
		v_add_u32_e32 v15, 28, v15
		ds_read_b64_tr_b8 v[26:27], v15 offset:2048
		ds_read_b64_tr_b8 v[248:249], v15 offset:2560
		ds_read_b64_tr_b8 v[250:251], v12 offset:4096
		s_and_b32 s52, s38, 1
		s_lshl_b32 s52, s52, 13
		s_add_i32 s52, s52, 0x20000
		v_and_b32_e32 v12, 63, v0
		v_lshlrev_b32_e32 v12, 3, v12
		v_lshrrev_b32_e32 v15, 6, v0
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 10, v15
		v_add3_u32 v12, s52, v12, v15
		v_add_u32_e32 v12, 28, v12
		ds_read_b64_tr_b8 v[252:253], v12 offset:6144
		ds_read_b64_tr_b8 v[254:255], v12 offset:6656
		s_and_saveexec_b64 s[52:53], s[16:17]
		v_mov_b32_e32 v12, 8
		v_mov_b32_e32 v15, 1
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v16, v12, v15
		s_mov_b64 exec, s[52:53]
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[28:31], v[60:63], v[4:7], v14, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[28:31], v[64:67], v[124:127], v14, v26 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[28:31], v[68:71], v[128:131], v14, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[28:31], v[72:75], v[132:135], v14, v26 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[32:35], v[72:75], v[164:167], v14, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[32:35], v[60:63], v[152:155], v14, v26 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[32:35], v[64:67], v[156:159], v14, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[32:35], v[68:71], v[160:163], v14, v26 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[36:39], v[68:71], v[192:195], v14, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[36:39], v[60:63], v[184:187], v14, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[36:39], v[64:67], v[188:191], v14, v26 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[36:39], v[72:75], v[196:199], v14, v26 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[40:43], v[72:75], v[228:231], v14, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[40:43], v[60:63], v[216:219], v14, v26 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[40:43], v[64:67], v[220:223], v14, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[40:43], v[68:71], v[224:227], v14, v26 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[44:47], v[92:95], v[4:7], v250, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[44:47], v[96:99], v[124:127], v250, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[44:47], v[100:103], v[128:131], v250, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[44:47], v[104:107], v[132:135], v250, v252 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[48:51], v[104:107], v[164:167], v250, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[48:51], v[92:95], v[152:155], v250, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[48:51], v[96:99], v[156:159], v250, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[48:51], v[100:103], v[160:163], v250, v252 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[52:55], v[100:103], v[192:195], v250, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[52:55], v[92:95], v[184:187], v250, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[52:55], v[96:99], v[188:191], v250, v252 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[52:55], v[104:107], v[196:199], v250, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[56:59], v[104:107], v[228:231], v250, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[56:59], v[92:95], v[216:219], v250, v252 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[56:59], v[96:99], v[220:223], v250, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[56:59], v[100:103], v[224:227], v250, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s52, v16
		s_and_b32 s52, s52, -8
		s_add_i32 s52, s52, 8
		s_and_saveexec_b64 s[54:55], s[16:17]
.Lwmma_f16_matmul_tiled.loop_head_3:
		ds_read_b32 v16, v12
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s53, v16
		s_xor_b32 s56, s52, -1
		s_add_i32 s56, s56, 1
		s_add_i32 s53, s53, s56
		s_cmp_ge_u32 s53, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_3
.Lwmma_f16_matmul_tiled.loop_exit_3:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s52, s39, s51
		s_lshl_b32 s53, s38, 15
		s_add_i32 s54, s35, s53
		v_lshl_add_u32 v12, v10, 12, s54
		s_add_i32 s54, s36, s53
		v_lshl_add_u32 v16, v10, 12, s54
		s_add_i32 s54, s37, s53
		v_lshl_add_u32 v18, v10, 12, s54
		s_add_i32 s54, s45, s53
		v_lshl_add_u32 v26, v10, 12, s54
		s_and_saveexec_b64 s[58:59], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_8
		s_add_i32 m0, s52, 0x2001c
		s_nop 0
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		s_add_i32 m0, s52, 0x2002c
		s_nop 0
		buffer_load_dwordx4 v16, s[24:27], 0 offen lds
		s_add_i32 m0, s52, 0x2003c
		s_nop 0
		buffer_load_dwordx4 v18, s[24:27], 0 offen lds
		s_add_i32 m0, s52, 0x2004c
		s_nop 0
		buffer_load_dwordx4 v26, s[24:27], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_8:
		s_andn2_b64 exec, s[58:59], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_8
.Lwmma_f16_matmul_tiled.exec_endif_8:
		s_mov_b64 exec, s[58:59]
		s_add_i32 s51, s44, s51
		s_add_i32 s54, s46, s53
		v_lshl_add_u32 v12, v10, 12, s54
		s_add_i32 s54, s47, s53
		v_lshl_add_u32 v16, v10, 12, s54
		v_lshl_add_u32 v18, v10, 12, s53
		v_add_u32_e32 v18, s7, v18
		v_add_u32_e32 v18, s13, v18
		v_add_u32_e32 v26, 0x10020, v18
		v_add_u32_e32 v27, 0x10030, v18
		v_add_u32_e32 v18, 0x10040, v18
		v_lshl_add_u32 v60, v10, 12, s53
		v_add_u32_e32 v60, s7, v60
		v_add_u32_e32 v60, s13, v60
		v_add_u32_e32 v61, 0x10050, v60
		v_add_u32_e32 v62, 0x10060, v60
		v_add_u32_e32 v60, 0x10070, v60
		s_and_saveexec_b64 s[58:59], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_9
		s_add_i32 m0, s51, 0x2081c
		s_nop 0
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_add_i32 m0, s51, 0x2082c
		s_nop 0
		buffer_load_dwordx4 v16, s[20:23], 0 offen lds
		s_add_i32 m0, s51, 0x2083c
		s_nop 0
		buffer_load_dwordx4 v26, s[20:23], 0 offen lds
		s_add_i32 m0, s51, 0x2084c
		s_nop 0
		buffer_load_dwordx4 v27, s[20:23], 0 offen lds
		s_add_i32 m0, s51, 0x20a1c
		s_nop 0
		buffer_load_dwordx4 v18, s[20:23], 0 offen lds
		s_add_i32 m0, s51, 0x20a2c
		s_nop 0
		buffer_load_dwordx4 v61, s[20:23], 0 offen lds
		s_add_i32 m0, s51, 0x20a3c
		s_nop 0
		buffer_load_dwordx4 v62, s[20:23], 0 offen lds
		s_add_i32 m0, s51, 0x20a4c
		s_nop 0
		buffer_load_dwordx4 v60, s[20:23], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_9:
		s_andn2_b64 exec, s[58:59], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_9
.Lwmma_f16_matmul_tiled.exec_endif_9:
		s_mov_b64 exec, s[58:59]
		s_add_i32 s54, s48, s53
		v_lshl_add_u32 v12, v10, 12, s54
		s_add_i32 s54, s49, s53
		v_lshl_add_u32 v16, v10, 12, s54
		s_add_i32 s54, s50, s53
		v_lshl_add_u32 v18, v10, 12, s54
		s_add_i32 s54, s4, s53
		v_lshl_add_u32 v26, v10, 12, s54
		s_and_saveexec_b64 s[58:59], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_10
		s_add_i32 m0, s52, 0x2101c
		s_nop 0
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		s_add_i32 m0, s52, 0x2102c
		s_nop 0
		buffer_load_dwordx4 v16, s[24:27], 0 offen lds
		s_add_i32 m0, s52, 0x2103c
		s_nop 0
		buffer_load_dwordx4 v18, s[24:27], 0 offen lds
		s_add_i32 m0, s52, 0x2104c
		s_nop 0
		buffer_load_dwordx4 v26, s[24:27], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_10:
		s_andn2_b64 exec, s[58:59], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_10
.Lwmma_f16_matmul_tiled.exec_endif_10:
		s_mov_b64 exec, s[58:59]
		s_add_i32 s52, s5, s53
		v_lshl_add_u32 v12, v10, 12, s52
		s_add_i32 s52, s6, s53
		v_lshl_add_u32 v16, v10, 12, s52
		v_lshl_add_u32 v18, v10, 12, s53
		v_add_u32_e32 v18, s7, v18
		v_add_u32_e32 v18, s13, v18
		v_add_u32_e32 v26, 0x14020, v18
		v_add_u32_e32 v27, 0x14030, v18
		v_add_u32_e32 v18, 0x14040, v18
		v_lshl_add_u32 v60, v10, 12, s53
		v_add_u32_e32 v60, s7, v60
		v_add_u32_e32 v60, s13, v60
		v_add_u32_e32 v61, 0x14050, v60
		v_add_u32_e32 v62, 0x14060, v60
		v_add_u32_e32 v60, 0x14070, v60
		s_and_saveexec_b64 s[58:59], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_11
		s_add_i32 m0, s51, 0x2181c
		s_nop 0
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_add_i32 m0, s51, 0x2182c
		s_nop 0
		buffer_load_dwordx4 v16, s[20:23], 0 offen lds
		s_add_i32 m0, s51, 0x2183c
		s_nop 0
		buffer_load_dwordx4 v26, s[20:23], 0 offen lds
		s_add_i32 m0, s51, 0x2184c
		s_nop 0
		buffer_load_dwordx4 v27, s[20:23], 0 offen lds
		s_add_i32 m0, s51, 0x21a1c
		s_nop 0
		buffer_load_dwordx4 v18, s[20:23], 0 offen lds
		s_add_i32 m0, s51, 0x21a2c
		s_nop 0
		buffer_load_dwordx4 v61, s[20:23], 0 offen lds
		s_add_i32 m0, s51, 0x21a3c
		s_nop 0
		buffer_load_dwordx4 v62, s[20:23], 0 offen lds
		s_add_i32 m0, s51, 0x21a4c
		s_nop 0
		buffer_load_dwordx4 v60, s[20:23], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_11:
		s_andn2_b64 exec, s[58:59], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_11
.Lwmma_f16_matmul_tiled.exec_endif_11:
		s_mov_b64 exec, s[58:59]
		s_and_saveexec_b64 s[52:53], s[16:17]
		v_mov_b32_e32 v12, 12
		s_waitcnt vmcnt(0)
		ds_add_rtn_u32 v16, v12, v15
		s_mov_b64 exec, s[52:53]
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[28:31], v[76:79], v[136:139], v14, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[28:31], v[80:83], v[140:143], v14, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[28:31], v[84:87], v[144:147], v14, v248 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[28:31], v[88:91], v[148:151], v14, v248 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[32:35], v[88:91], v[180:183], v14, v248 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[32:35], v[76:79], v[168:171], v14, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[32:35], v[80:83], v[172:175], v14, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[32:35], v[84:87], v[176:179], v14, v248 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[36:39], v[84:87], v[208:211], v14, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[36:39], v[76:79], v[200:203], v14, v248 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[36:39], v[80:83], v[204:207], v14, v248 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[36:39], v[88:91], v[212:215], v14, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[40:43], v[88:91], v[244:247], v14, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[40:43], v[76:79], v[232:235], v14, v248 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[40:43], v[80:83], v[236:239], v14, v248 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[40:43], v[84:87], v[240:243], v14, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[44:47], v[108:111], v[136:139], v250, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[44:47], v[112:115], v[140:143], v250, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[44:47], v[116:119], v[144:147], v250, v254 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[44:47], v[120:123], v[148:151], v250, v254 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[48:51], v[120:123], v[180:183], v250, v254 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[48:51], v[108:111], v[168:171], v250, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[48:51], v[112:115], v[172:175], v250, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[48:51], v[116:119], v[176:179], v250, v254 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[52:55], v[116:119], v[208:211], v250, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[52:55], v[108:111], v[200:203], v250, v254 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[52:55], v[112:115], v[204:207], v250, v254 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[52:55], v[120:123], v[212:215], v250, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[56:59], v[120:123], v[244:247], v250, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[56:59], v[108:111], v[232:235], v250, v254 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[56:59], v[112:115], v[236:239], v250, v254 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[56:59], v[116:119], v[240:243], v250, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_lshl_b32 s51, s38, 7
		s_add_i32 m0, s12, 28
		s_nop 0
		buffer_load_dwordx4 v20, s[8:11], s51 offen lds
		s_add_i32 s52, s32, 0x10000
		s_add_i32 m0, s14, 28
		s_nop 0
		buffer_load_dwordx4 v21, s[8:11], s51 offen lds
		s_add_i32 s53, s19, 0x10000
		s_add_i32 m0, s15, 28
		s_nop 0
		buffer_load_dwordx4 v22, s[8:11], s51 offen lds
		s_add_i32 s54, s18, 0x10000
		s_add_i32 m0, s18, 28
		s_nop 0
		buffer_load_dwordx4 v23, s[8:11], s51 offen lds
		s_add_i32 s15, s15, 0x10000
		s_add_i32 m0, s19, 28
		s_nop 0
		buffer_load_dwordx4 v11, s[0:3], s51 offen lds
		s_add_i32 s14, s14, 0x10000
		s_add_i32 m0, s32, 28
		s_nop 0
		buffer_load_dwordx4 v24, s[0:3], s51 offen lds
		s_add_i32 s12, s12, 0x10000
		s_add_i32 m0, s33, 28
		s_nop 0
		buffer_load_dwordx4 v25, s[0:3], s51 offen lds
		s_add_i32 s38, s38, 1
		s_and_b32 s18, s38, 1
		s_lshl_b32 s18, s18, 16
		v_lshrrev_b32_e32 v14, 7, v0
		v_lshlrev_b32_e32 v14, 12, v14
		v_add_u32_e32 v14, s18, v14
		v_and_b32_e32 v15, 15, v0
		v_lshlrev_b32_e32 v15, 6, v15
		v_add3_u32 v14, v14, v15, v17
		v_add_u32_e32 v15, s18, v15
		v_add3_u32 v15, v15, v19, v17
		s_and_b32 s12, s12, 0x1ffff
		s_and_b32 s14, s14, 0x1ffff
		s_and_b32 s15, s15, 0x1ffff
		s_and_b32 s18, s54, 0x1ffff
		s_and_b32 s19, s53, 0x1ffff
		s_and_b32 s32, s52, 0x1ffff
		s_add_i32 s33, s33, 0x10000
		s_and_b32 s33, s33, 0x1ffff
		s_add_i32 s52, s34, 0x10000
		s_and_b32 s52, s52, 0x1ffff
		s_cmp_lt_i32 s38, 30
		s_cselect_b32 s53, 1, 0
		s_add_i32 m0, s34, 28
		s_nop 0
		buffer_load_dwordx4 v1, s[0:3], s51 offen lds
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s34, v16
		s_and_b32 s34, s34, -8
		s_add_i32 s34, s34, 8
		s_and_saveexec_b64 s[54:55], s[16:17]
.Lwmma_f16_matmul_tiled.loop_head_4:
		ds_read_b32 v16, v12
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s51, v16
		s_xor_b32 s56, s34, -1
		s_add_i32 s56, s56, 1
		s_add_i32 s51, s51, s56
		s_cmp_ge_u32 s51, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_4
.Lwmma_f16_matmul_tiled.loop_exit_4:
		s_mov_b64 exec, s[54:55]
		v_add_u32_e32 v12, 28, v14
		ds_read_b128 v[28:31], v12
		ds_read_b128 v[32:35], v12 offset:1024
		ds_read_b128 v[36:39], v12 offset:2048
		ds_read_b128 v[40:43], v12 offset:3072
		ds_read_b128 v[44:47], v12 offset:16384
		ds_read_b128 v[48:51], v12 offset:17408
		ds_read_b128 v[52:55], v12 offset:18432
		ds_read_b128 v[56:59], v12 offset:19456
		v_add_u32_e32 v12, 28, v15
		ds_read_b128 v[60:63], v12 offset:32768
		ds_read_b128 v[64:67], v12 offset:33792
		ds_read_b128 v[68:71], v12 offset:34816
		ds_read_b128 v[72:75], v12 offset:35840
		ds_read_b128 v[76:79], v12 offset:36864
		ds_read_b128 v[80:83], v12 offset:37888
		ds_read_b128 v[84:87], v12 offset:38912
		ds_read_b128 v[88:91], v12 offset:39936
		ds_read_b128 v[92:95], v12 offset:49152
		ds_read_b128 v[96:99], v12 offset:50176
		ds_read_b128 v[100:103], v12 offset:51200
		ds_read_b128 v[104:107], v12 offset:52224
		ds_read_b128 v[108:111], v12 offset:53248
		ds_read_b128 v[112:115], v12 offset:54272
		ds_read_b128 v[116:119], v12 offset:55296
		ds_read_b128 v[120:123], v12 offset:56320
		s_cmp_lg_u32 s53, 0
		s_mov_b32 s34, s52
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_1
.Lwmma_f16_matmul_tiled.loop_exit_1:
		s_and_saveexec_b64 s[0:1], s[16:17]
		v_mov_b32_e32 v1, 16
		v_mov_b32_e32 v2, 1
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v3, v1, v2
		s_mov_b64 exec, s[0:1]
		s_and_saveexec_b64 s[0:1], s[16:17]
		v_mov_b32_e32 v8, 20
		s_waitcnt vmcnt(0)
		ds_add_rtn_u32 v9, v8, v2
		s_mov_b64 exec, s[0:1]
		v_lshrrev_b32_e32 v10, 7, v0
		v_lshlrev_b32_e32 v10, 9, v10
		v_add_u32_e32 v10, 0x20000, v10
		v_and_b32_e32 v11, 63, v0
		v_lshlrev_b32_e32 v11, 3, v11
		v_add_u32_e32 v10, v10, v11
		v_add_u32_e32 v12, 0x20000, v11
		s_waitcnt lgkmcnt(1)
		v_readfirstlane_b32 s0, v3
		s_and_b32 s0, s0, -8
		s_add_i32 s0, s0, 8
		s_and_saveexec_b64 s[2:3], s[16:17]
.Lwmma_f16_matmul_tiled.loop_head_5:
		ds_read_b32 v3, v1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v3
		s_xor_b32 s4, s0, -1
		s_add_i32 s4, s4, 1
		s_add_i32 s1, s1, s4
		s_cmp_ge_u32 s1, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_5
.Lwmma_f16_matmul_tiled.loop_exit_5:
		s_mov_b64 exec, s[2:3]
		v_add_u32_e32 v1, 28, v10
		ds_read_b64_tr_b8 v[14:15], v1
		v_lshrrev_b32_e32 v3, 6, v0
		v_and_b32_e32 v3, 1, v3
		v_lshl_add_u32 v3, v3, 10, v12
		v_add_u32_e32 v3, 28, v3
		ds_read_b64_tr_b8 v[12:13], v3 offset:2048
		ds_read_b64_tr_b8 v[20:21], v3 offset:2560
		ds_read_b64_tr_b8 v[22:23], v1 offset:4096
		ds_read_b64_tr_b8 v[24:25], v3 offset:6144
		ds_read_b64_tr_b8 v[26:27], v3 offset:6656
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[28:31], v[60:63], v[4:7], v14, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[28:31], v[64:67], v[124:127], v14, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[28:31], v[68:71], v[128:131], v14, v12 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[28:31], v[72:75], v[132:135], v14, v12 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[28:31], v[76:79], v[136:139], v14, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[28:31], v[80:83], v[140:143], v14, v20 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[28:31], v[84:87], v[144:147], v14, v20 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[28:31], v[88:91], v[148:151], v14, v20 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[32:35], v[88:91], v[180:183], v14, v20 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[32:35], v[76:79], v[168:171], v14, v20 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[32:35], v[80:83], v[172:175], v14, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[32:35], v[84:87], v[176:179], v14, v20 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[36:39], v[84:87], v[208:211], v14, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[36:39], v[76:79], v[200:203], v14, v20 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[36:39], v[80:83], v[204:207], v14, v20 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[36:39], v[88:91], v[212:215], v14, v20 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[40:43], v[88:91], v[244:247], v14, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[40:43], v[76:79], v[232:235], v14, v20 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[40:43], v[80:83], v[236:239], v14, v20 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[40:43], v[84:87], v[240:243], v14, v20 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[40:43], v[60:63], v[216:219], v14, v12 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[32:35], v[60:63], v[152:155], v14, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[32:35], v[64:67], v[156:159], v14, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[32:35], v[68:71], v[160:163], v14, v12 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[32:35], v[72:75], v[164:167], v14, v12 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[36:39], v[72:75], v[196:199], v14, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[36:39], v[60:63], v[184:187], v14, v12 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[36:39], v[64:67], v[188:191], v14, v12 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[36:39], v[68:71], v[192:195], v14, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[40:43], v[68:71], v[224:227], v14, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[40:43], v[64:67], v[220:223], v14, v12 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[40:43], v[72:75], v[228:231], v14, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[44:47], v[92:95], v[4:7], v22, v24 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[44:47], v[96:99], v[124:127], v22, v24 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[44:47], v[100:103], v[128:131], v22, v24 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[44:47], v[104:107], v[132:135], v22, v24 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[44:47], v[108:111], v[136:139], v22, v26 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[44:47], v[112:115], v[140:143], v22, v26 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[44:47], v[116:119], v[144:147], v22, v26 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[44:47], v[120:123], v[148:151], v22, v26 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[48:51], v[120:123], v[180:183], v22, v26 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[48:51], v[108:111], v[168:171], v22, v26 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[48:51], v[112:115], v[172:175], v22, v26 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[48:51], v[116:119], v[176:179], v22, v26 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[52:55], v[116:119], v[208:211], v22, v26 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[52:55], v[108:111], v[200:203], v22, v26 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[52:55], v[112:115], v[204:207], v22, v26 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[52:55], v[120:123], v[212:215], v22, v26 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[56:59], v[120:123], v[244:247], v22, v26 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[56:59], v[108:111], v[232:235], v22, v26 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[56:59], v[112:115], v[236:239], v22, v26 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[56:59], v[116:119], v[240:243], v22, v26 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[56:59], v[92:95], v[216:219], v22, v24 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[48:51], v[92:95], v[152:155], v22, v24 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[48:51], v[96:99], v[156:159], v22, v24 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[48:51], v[100:103], v[160:163], v22, v24 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[48:51], v[104:107], v[164:167], v22, v24 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[52:55], v[104:107], v[196:199], v22, v24 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[52:55], v[92:95], v[184:187], v22, v24 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[52:55], v[96:99], v[188:191], v22, v24 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[52:55], v[100:103], v[192:195], v22, v24 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[56:59], v[100:103], v[224:227], v22, v24 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[56:59], v[96:99], v[220:223], v22, v24 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[56:59], v[104:107], v[228:231], v22, v24 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_readfirstlane_b32 s0, v9
		s_and_b32 s0, s0, -8
		s_add_i32 s0, s0, 8
		s_and_saveexec_b64 s[2:3], s[16:17]
.Lwmma_f16_matmul_tiled.loop_head_6:
		ds_read_b32 v9, v8
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v9
		s_xor_b32 s4, s0, -1
		s_add_i32 s4, s4, 1
		s_add_i32 s1, s1, s4
		s_cmp_ge_u32 s1, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_6
.Lwmma_f16_matmul_tiled.loop_exit_6:
		s_mov_b64 exec, s[2:3]
		v_lshrrev_b32_e32 v8, 7, v0
		v_lshlrev_b32_e32 v8, 12, v8
		v_add_u32_e32 v8, 0x10000, v8
		v_and_b32_e32 v9, 15, v0
		v_lshlrev_b32_e32 v9, 6, v9
		v_add3_u32 v8, v8, v9, v17
		v_add_u32_e32 v8, 28, v8
		ds_read_b128 v[12:15], v8
		ds_read_b128 v[20:23], v8 offset:1024
		ds_read_b128 v[24:27], v8 offset:2048
		ds_read_b128 v[28:31], v8 offset:3072
		ds_read_b128 v[32:35], v8 offset:16384
		ds_read_b128 v[36:39], v8 offset:17408
		ds_read_b128 v[40:43], v8 offset:18432
		ds_read_b128 v[44:47], v8 offset:19456
		v_add_u32_e32 v8, 0x10000, v9
		v_add3_u32 v8, v8, v19, v17
		v_add_u32_e32 v8, 28, v8
		ds_read_b128 v[16:19], v8 offset:32768
		ds_read_b128 v[48:51], v8 offset:33792
		ds_read_b128 v[52:55], v8 offset:34816
		ds_read_b128 v[56:59], v8 offset:35840
		ds_read_b128 v[60:63], v8 offset:36864
		ds_read_b128 v[64:67], v8 offset:37888
		ds_read_b128 v[68:71], v8 offset:38912
		ds_read_b128 v[72:75], v8 offset:39936
		ds_read_b128 v[76:79], v8 offset:49152
		ds_read_b128 v[80:83], v8 offset:50176
		ds_read_b128 v[84:87], v8 offset:51200
		ds_read_b128 v[88:91], v8 offset:52224
		ds_read_b128 v[92:95], v8 offset:53248
		ds_read_b128 v[96:99], v8 offset:54272
		ds_read_b128 v[100:103], v8 offset:55296
		ds_read_b128 v[104:107], v8 offset:56320
		s_and_saveexec_b64 s[0:1], s[16:17]
		v_mov_b32_e32 v8, 24
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v9, v8, v2
		s_mov_b64 exec, s[0:1]
		v_lshrrev_b32_e32 v0, 6, v0
		v_lshl_add_u32 v0, v0, 14, v11
		s_mov_b32 s0, 0x1000
		s_mov_b32 s1, 0x2000
		s_mov_b32 s2, 0x3000
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s3, v9
		s_and_b32 s3, s3, -8
		s_add_i32 s3, s3, 8
		s_and_saveexec_b64 s[4:5], s[16:17]
.Lwmma_f16_matmul_tiled.loop_head_7:
		ds_read_b32 v2, v8
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s6, v2
		s_xor_b32 s7, s3, -1
		s_add_i32 s7, s7, 1
		s_add_i32 s6, s6, s7
		s_cmp_ge_u32 s6, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_7
.Lwmma_f16_matmul_tiled.loop_exit_7:
		s_mov_b64 exec, s[4:5]
		ds_read_b64_tr_b8 v[8:9], v1 offset:8192
		ds_read_b64_tr_b8 v[10:11], v3 offset:10240
		ds_read_b64_tr_b8 v[108:109], v3 offset:10752
		ds_read_b64_tr_b8 v[110:111], v1 offset:12288
		ds_read_b64_tr_b8 v[112:113], v3 offset:14336
		ds_read_b64_tr_b8 v[114:115], v3 offset:14848
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[12:15], v[16:19], v[4:7], v8, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[12:15], v[48:51], v[124:127], v8, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[12:15], v[52:55], v[128:131], v8, v10 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[12:15], v[56:59], v[132:135], v8, v10 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[56:59], v[164:167], v8, v10 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[16:19], v[152:155], v8, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[48:51], v[156:159], v8, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[52:55], v[160:163], v8, v10 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[52:55], v[192:195], v8, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[16:19], v[184:187], v8, v10 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[48:51], v[188:191], v8, v10 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[56:59], v[196:199], v8, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], v[56:59], v[228:231], v8, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[28:31], v[16:19], v[216:219], v8, v10 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[28:31], v[48:51], v[220:223], v8, v10 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[52:55], v[224:227], v8, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[32:35], v[76:79], v[4:7], v110, v112 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], v[80:83], v[124:127], v110, v112 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[32:35], v[84:87], v[128:131], v110, v112 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], v[88:91], v[132:135], v110, v112 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], v[88:91], v[164:167], v110, v112 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[36:39], v[76:79], v[152:155], v110, v112 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[36:39], v[80:83], v[156:159], v110, v112 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[36:39], v[84:87], v[160:163], v110, v112 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[40:43], v[84:87], v[192:195], v110, v112 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[40:43], v[76:79], v[184:187], v110, v112 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[40:43], v[80:83], v[188:191], v110, v112 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[40:43], v[88:91], v[196:199], v110, v112 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[44:47], v[88:91], v[228:231], v110, v112 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[44:47], v[76:79], v[216:219], v110, v112 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[44:47], v[80:83], v[220:223], v110, v112 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[44:47], v[84:87], v[224:227], v110, v112 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v4, v5
		v_cvt_pk_f16_f32 v3, v6, v7
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx2 v[2:3], v0, s[28:31], 0 offen
		v_cvt_pk_f16_f32 v2, v124, v125
		v_cvt_pk_f16_f32 v3, v126, v127
		buffer_store_dwordx2 v[2:3], v0, s[28:31], 0 offen offset:512
		v_cvt_pk_f16_f32 v2, v128, v129
		v_cvt_pk_f16_f32 v3, v130, v131
		buffer_store_dwordx2 v[2:3], v0, s[28:31], 0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v132, v133
		v_cvt_pk_f16_f32 v3, v134, v135
		buffer_store_dwordx2 v[2:3], v0, s[28:31], 0 offen offset:1536
		v_cvt_pk_f16_f32 v2, v152, v153
		v_cvt_pk_f16_f32 v3, v154, v155
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s0 offen
		v_cvt_pk_f16_f32 v2, v156, v157
		v_cvt_pk_f16_f32 v3, v158, v159
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s0 offen offset:512
		v_cvt_pk_f16_f32 v2, v160, v161
		v_cvt_pk_f16_f32 v3, v162, v163
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v164, v165
		v_cvt_pk_f16_f32 v3, v166, v167
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s0 offen offset:1536
		v_cvt_pk_f16_f32 v2, v184, v185
		v_cvt_pk_f16_f32 v3, v186, v187
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s1 offen
		v_cvt_pk_f16_f32 v2, v188, v189
		v_cvt_pk_f16_f32 v3, v190, v191
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s1 offen offset:512
		v_cvt_pk_f16_f32 v2, v192, v193
		v_cvt_pk_f16_f32 v3, v194, v195
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s1 offen offset:1024
		v_cvt_pk_f16_f32 v2, v196, v197
		v_cvt_pk_f16_f32 v3, v198, v199
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s1 offen offset:1536
		v_cvt_pk_f16_f32 v2, v216, v217
		v_cvt_pk_f16_f32 v3, v218, v219
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen
		v_cvt_pk_f16_f32 v2, v220, v221
		v_cvt_pk_f16_f32 v3, v222, v223
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen offset:512
		v_cvt_pk_f16_f32 v2, v224, v225
		v_cvt_pk_f16_f32 v3, v226, v227
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen offset:1024
		v_cvt_pk_f16_f32 v2, v228, v229
		v_cvt_pk_f16_f32 v3, v230, v231
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen offset:1536
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[12:15], v[60:63], v[136:139], v8, v108 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[12:15], v[64:67], v[140:143], v8, v108 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[12:15], v[68:71], v[144:147], v8, v108 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[12:15], v[72:75], v[148:151], v8, v108 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[20:23], v[72:75], v[180:183], v8, v108 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[60:63], v[168:171], v8, v108 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[64:67], v[172:175], v8, v108 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[20:23], v[68:71], v[176:179], v8, v108 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], v[68:71], v[208:211], v8, v108 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[60:63], v[200:203], v8, v108 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[64:67], v[204:207], v8, v108 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[24:27], v[72:75], v[212:215], v8, v108 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[28:31], v[72:75], v[244:247], v8, v108 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[28:31], v[60:63], v[232:235], v8, v108 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[28:31], v[64:67], v[236:239], v8, v108 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[28:31], v[68:71], v[240:243], v8, v108 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[32:35], v[92:95], v[136:139], v110, v114 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[32:35], v[96:99], v[140:143], v110, v114 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[32:35], v[100:103], v[144:147], v110, v114 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[32:35], v[104:107], v[148:151], v110, v114 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[36:39], v[104:107], v[180:183], v110, v114 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], v[92:95], v[168:171], v110, v114 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[36:39], v[96:99], v[172:175], v110, v114 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[36:39], v[100:103], v[176:179], v110, v114 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[40:43], v[100:103], v[208:211], v110, v114 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], v[92:95], v[200:203], v110, v114 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[40:43], v[96:99], v[204:207], v110, v114 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[40:43], v[104:107], v[212:215], v110, v114 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[44:47], v[104:107], v[244:247], v110, v114 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[44:47], v[92:95], v[232:235], v110, v114 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[44:47], v[96:99], v[236:239], v110, v114 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[44:47], v[100:103], v[240:243], v110, v114 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v136, v137
		v_cvt_pk_f16_f32 v3, v138, v139
		buffer_store_dwordx2 v[2:3], v0, s[28:31], 0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v140, v141
		v_cvt_pk_f16_f32 v3, v142, v143
		buffer_store_dwordx2 v[2:3], v0, s[28:31], 0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v144, v145
		v_cvt_pk_f16_f32 v3, v146, v147
		buffer_store_dwordx2 v[2:3], v0, s[28:31], 0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v148, v149
		v_cvt_pk_f16_f32 v3, v150, v151
		buffer_store_dwordx2 v[2:3], v0, s[28:31], 0 offen offset:3584
		v_cvt_pk_f16_f32 v2, v168, v169
		v_cvt_pk_f16_f32 v3, v170, v171
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v172, v173
		v_cvt_pk_f16_f32 v3, v174, v175
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v176, v177
		v_cvt_pk_f16_f32 v3, v178, v179
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v180, v181
		v_cvt_pk_f16_f32 v3, v182, v183
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s0 offen offset:3584
		v_cvt_pk_f16_f32 v2, v200, v201
		v_cvt_pk_f16_f32 v3, v202, v203
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s1 offen offset:2048
		v_cvt_pk_f16_f32 v2, v204, v205
		v_cvt_pk_f16_f32 v3, v206, v207
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s1 offen offset:2560
		v_cvt_pk_f16_f32 v2, v208, v209
		v_cvt_pk_f16_f32 v3, v210, v211
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s1 offen offset:3072
		v_cvt_pk_f16_f32 v2, v212, v213
		v_cvt_pk_f16_f32 v3, v214, v215
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s1 offen offset:3584
		v_cvt_pk_f16_f32 v2, v232, v233
		v_cvt_pk_f16_f32 v3, v234, v235
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen offset:2048
		v_cvt_pk_f16_f32 v2, v236, v237
		v_cvt_pk_f16_f32 v3, v238, v239
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen offset:2560
		v_cvt_pk_f16_f32 v2, v240, v241
		v_cvt_pk_f16_f32 v3, v242, v243
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen offset:3072
		v_cvt_pk_f16_f32 v2, v244, v245
		v_cvt_pk_f16_f32 v3, v246, v247
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen offset:3584
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 28
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
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 60
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
    .group_segment_fixed_size: 28
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
    wave.regalloc.iterations: 14
    wave.regalloc.agpr.dwords: 0
    wave.regalloc.remat.dwords: 16
    wave.regalloc.sgpr_to_vgpr.dwords: 0
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
