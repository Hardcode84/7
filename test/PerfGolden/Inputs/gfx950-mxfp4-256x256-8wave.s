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
		s_mov_b32 s16, s2
		s_mov_b32 s17, s3
		s_mov_b32 s18, 0x1000000
		s_mov_b32 s19, 0x31016000
		s_mov_b32 s20, s4
		s_mov_b32 s21, s5
		s_mov_b32 s22, 0x1000000
		s_mov_b32 s23, 0x31016000
		s_mov_b32 s0, s10
		s_mov_b32 s1, s11
		s_mov_b32 s2, 0x7fffffff
		s_mov_b32 s3, 0x31016000
		s_mov_b32 s24, s8
		s_mov_b32 s25, s9
		s_mov_b32 s26, 0x7fffffff
		s_mov_b32 s27, 0x31016000
		v_readfirstlane_b32 s4, v0
		s_lshr_b32 s5, s13, 3
		s_mov_b32 m0, s12
		v_lshrrev_b32_e32 v1, 6, v0
		ds_write_addtid_b32 v1
		s_lshl_b32 s8, s14, 1
		v_and_b32_e32 v2, 63, v0
		s_add_i32 s5, s8, s5
		v_lshrrev_b32_e32 v3, 2, v2
		s_and_b32 s8, s13, 7
		v_lshlrev_b32_e32 v3, 12, v3
		s_lshl_b32 s8, s8, 5
		v_lshl_add_u32 v3, v1, 16, v3
		s_add_i32 s5, s5, s8
		v_lshrrev_b32_e32 v4, 3, v2
		s_lshr_b32 s8, s5, 6
		v_and_b32_e32 v5, 3, v4
		s_lshl_b32 s9, s8, 23
		v_and_b32_e32 v6, 3, v2
		s_and_b32 s5, s5, 63
		v_xor_b32_e32 v5, v5, v6
		s_lshr_b32 s10, s5, 2
		v_lshl_add_u32 v3, v5, 4, v3
		s_lshl_b32 s11, s10, 17
		s_add_i32 s9, s9, s11
		s_and_b32 s5, s5, 3
		s_lshl_b32 s11, s5, 21
		s_add_i32 s9, s9, s11
		s_add_u32 s6, s6, s9
		s_addc_u32 s7, s7, 0
		s_mov_b32 s28, s6
		s_mov_b32 s29, s7
		s_mov_b32 s30, 0x20000
		s_mov_b32 s31, 0x31016000
		s_lshr_b32 s6, s4, 6
		s_lshl_b32 s7, s6, 10
		s_add_i32 s9, s7, 0x2000
		s_add_i32 s11, s7, 0x4000
		s_add_i32 s13, s7, 0x6000
		s_add_i32 s14, s7, 0x8000
		s_add_i32 s15, s7, 0xa000
		s_add_i32 s32, s7, 0xc000
		s_add_i32 s33, s7, 0xe000
		s_mov_b32 m0, s7
		s_lshl_b32 s34, s8, 22
		s_lshl_b32 s35, s5, 20
		s_add_i32 s36, s34, s35
		v_add_u32_e32 v5, s36, v3
		buffer_load_dwordx4 v5, s[16:19], 0 offen lds
		s_mov_b32 m0, s9
		s_add_i32 s36, s34, 0x80000
		s_add_i32 s36, s36, s35
		v_add_u32_e32 v6, s36, v3
		buffer_load_dwordx4 v6, s[16:19], 0 offen lds
		s_mov_b32 m0, s11
		s_add_i32 s36, s34, 64
		s_add_i32 s36, s36, s35
		v_add_u32_e32 v6, s36, v3
		buffer_load_dwordx4 v6, s[16:19], 0 offen lds
		s_mov_b32 m0, s13
		s_add_i32 s36, s34, 0x80040
		s_add_i32 s36, s36, s35
		v_add_u32_e32 v6, s36, v3
		buffer_load_dwordx4 v6, s[16:19], 0 offen lds
		s_mov_b32 m0, s14
		s_lshl_b32 s36, s10, 20
		v_add_u32_e32 v6, s36, v3
		buffer_load_dwordx4 v6, s[20:23], 0 offen lds
		s_add_i32 s37, s36, 0x80000
		s_mov_b32 m0, s15
		v_add_u32_e32 v7, s37, v3
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		s_mov_b32 m0, s32
		v_add3_u32 v7, s36, 64, v3
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		s_add_i32 s37, s36, 0x80040
		s_mov_b32 m0, s33
		v_add_u32_e32 v7, s37, v3
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		s_lshr_b32 s4, s4, 7
		v_and_b32_e32 v7, 39, v0
		s_lshl_b32 s37, s4, 9
		v_and_or_b32 v8, 1, v1, v7
		s_lshl_b32 s8, s8, 10
		v_mov_b64_e32 v[12:13], 0
		v_mov_b64_e32 v[14:15], 0
		s_lshl_b32 s4, s4, 6
		s_add_i32 s38, s8, s4
		s_lshl_b32 s5, s5, 8
		s_add_i32 s38, s38, s5
		v_lshl_add_u32 v9, v4, 12, s38
		s_add_i32 s38, s8, 16
		s_add_i32 s38, s38, s4
		s_add_i32 s38, s38, s5
		v_lshl_add_u32 v10, v4, 12, s38
		s_add_i32 s38, s8, 32
		s_add_i32 s38, s38, s4
		s_add_i32 s38, s38, s5
		v_lshl_add_u32 v11, v4, 12, s38
		s_add_i32 s38, s8, 48
		s_add_i32 s38, s38, s4
		s_mov_b32 s39, 0
		v_cmp_eq_u32_e64 vcc, v8, s39
		s_mov_b64 s[40:41], vcc
		s_add_i32 s38, s38, s5
		v_lshl_add_u32 v8, v4, 12, s38
		s_and_saveexec_b64 s[66:67], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_0
		s_add_i32 m0, s37, 0x20000
		s_nop 0
		buffer_load_dwordx4 v9, s[24:27], 0 offen lds
		s_add_i32 m0, s37, 0x20010
		s_nop 0
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		s_add_i32 m0, s37, 0x20020
		s_nop 0
		buffer_load_dwordx4 v11, s[24:27], 0 offen lds
		s_add_i32 m0, s37, 0x20030
		s_nop 0
		buffer_load_dwordx4 v8, s[24:27], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_0:
		s_andn2_b64 exec, s[66:67], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_0
.Lwmma_f16_matmul_tiled.exec_endif_0:
		s_mov_b64 exec, s[66:67]
		v_lshrrev_b32_e32 v8, 1, v1
		v_or_b32_e32 v7, v7, v8
		v_cmp_eq_u32_e64 vcc, v7, s39
		s_mov_b64 s[42:43], vcc
		s_and_b32 s6, s6, 1
		s_lshl_b32 s38, s6, 10
		s_lshl_b32 s10, s10, 8
		s_lshl_b32 s6, s6, 7
		s_add_i32 s44, s10, s6
		v_lshl_add_u32 v7, v4, 12, s44
		s_add_i32 s44, s10, 16
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v8, v4, 12, s44
		s_add_i32 s44, s10, 32
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v9, v4, 12, s44
		s_add_i32 s44, s10, 48
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v10, v4, 12, s44
		s_add_i32 s44, s10, 64
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v11, v4, 12, s44
		s_add_i32 s44, s10, 0x50
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v16, v4, 12, s44
		s_add_i32 s44, s10, 0x60
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v17, v4, 12, s44
		s_add_i32 s44, s10, 0x70
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v18, v4, 12, s44
		s_and_saveexec_b64 s[66:67], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_1
		s_add_i32 m0, s38, 0x20800
		s_nop 0
		buffer_load_dwordx4 v7, s[0:3], 0 offen lds
		s_add_i32 m0, s38, 0x20810
		s_nop 0
		buffer_load_dwordx4 v8, s[0:3], 0 offen lds
		s_add_i32 m0, s38, 0x20820
		s_nop 0
		buffer_load_dwordx4 v9, s[0:3], 0 offen lds
		s_add_i32 m0, s38, 0x20830
		s_nop 0
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		s_add_i32 m0, s38, 0x20a00
		s_nop 0
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		s_add_i32 m0, s38, 0x20a10
		s_nop 0
		buffer_load_dwordx4 v16, s[0:3], 0 offen lds
		s_add_i32 m0, s38, 0x20a20
		s_nop 0
		buffer_load_dwordx4 v17, s[0:3], 0 offen lds
		s_add_i32 m0, s38, 0x20a30
		s_nop 0
		buffer_load_dwordx4 v18, s[0:3], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_1:
		s_andn2_b64 exec, s[66:67], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_1
.Lwmma_f16_matmul_tiled.exec_endif_1:
		s_mov_b64 exec, s[66:67]
		s_add_i32 s44, s8, 0x4000
		s_add_i32 s44, s44, s4
		s_add_i32 s44, s44, s5
		v_lshl_add_u32 v7, v4, 12, s44
		s_add_i32 s44, s8, 0x4010
		s_add_i32 s44, s44, s4
		s_add_i32 s44, s44, s5
		v_lshl_add_u32 v8, v4, 12, s44
		s_add_i32 s44, s8, 0x4020
		s_add_i32 s44, s44, s4
		s_add_i32 s44, s44, s5
		v_lshl_add_u32 v9, v4, 12, s44
		s_add_i32 s44, s8, 0x4030
		s_add_i32 s44, s44, s4
		s_add_i32 s44, s44, s5
		v_lshl_add_u32 v10, v4, 12, s44
		s_and_saveexec_b64 s[66:67], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_2
		s_add_i32 m0, s37, 0x21000
		s_nop 0
		buffer_load_dwordx4 v7, s[24:27], 0 offen lds
		s_add_i32 m0, s37, 0x21010
		s_nop 0
		buffer_load_dwordx4 v8, s[24:27], 0 offen lds
		s_add_i32 m0, s37, 0x21020
		s_nop 0
		buffer_load_dwordx4 v9, s[24:27], 0 offen lds
		s_add_i32 m0, s37, 0x21030
		s_nop 0
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_2:
		s_andn2_b64 exec, s[66:67], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_2
.Lwmma_f16_matmul_tiled.exec_endif_2:
		s_mov_b64 exec, s[66:67]
		s_add_i32 s44, s10, 0x4000
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v7, v4, 12, s44
		s_add_i32 s44, s10, 0x4010
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v8, v4, 12, s44
		s_add_i32 s44, s10, 0x4020
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v9, v4, 12, s44
		s_add_i32 s44, s10, 0x4030
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v10, v4, 12, s44
		s_add_i32 s44, s10, 0x4040
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v11, v4, 12, s44
		s_add_i32 s44, s10, 0x4050
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v16, v4, 12, s44
		s_add_i32 s44, s10, 0x4060
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v17, v4, 12, s44
		s_add_i32 s44, s10, 0x4070
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v18, v4, 12, s44
		s_and_saveexec_b64 s[66:67], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_3
		s_add_i32 m0, s38, 0x21800
		s_nop 0
		buffer_load_dwordx4 v7, s[0:3], 0 offen lds
		s_add_i32 m0, s38, 0x21810
		s_nop 0
		buffer_load_dwordx4 v8, s[0:3], 0 offen lds
		s_add_i32 m0, s38, 0x21820
		s_nop 0
		buffer_load_dwordx4 v9, s[0:3], 0 offen lds
		s_add_i32 m0, s38, 0x21830
		s_nop 0
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		s_add_i32 m0, s38, 0x21a00
		s_nop 0
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		s_add_i32 m0, s38, 0x21a10
		s_nop 0
		buffer_load_dwordx4 v16, s[0:3], 0 offen lds
		s_add_i32 m0, s38, 0x21a20
		s_nop 0
		buffer_load_dwordx4 v17, s[0:3], 0 offen lds
		s_add_i32 m0, s38, 0x21a30
		s_nop 0
		buffer_load_dwordx4 v18, s[0:3], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_3:
		s_andn2_b64 exec, s[66:67], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_3
.Lwmma_f16_matmul_tiled.exec_endif_3:
		s_mov_b64 exec, s[66:67]
		s_add_i32 s44, s8, 0x8000
		s_add_i32 s44, s44, s4
		s_add_i32 s44, s44, s5
		v_lshl_add_u32 v7, v4, 12, s44
		s_add_i32 s44, s8, 0x8010
		s_add_i32 s44, s44, s4
		s_add_i32 s44, s44, s5
		v_lshl_add_u32 v8, v4, 12, s44
		s_add_i32 s44, s8, 0x8020
		s_add_i32 s44, s44, s4
		s_add_i32 s44, s44, s5
		v_lshl_add_u32 v9, v4, 12, s44
		s_add_i32 s44, s8, 0x8030
		s_add_i32 s44, s44, s4
		s_add_i32 s44, s44, s5
		v_lshl_add_u32 v10, v4, 12, s44
		s_and_saveexec_b64 s[66:67], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_4
		s_add_i32 m0, s37, 0x22000
		s_nop 0
		buffer_load_dwordx4 v7, s[24:27], 0 offen lds
		s_add_i32 m0, s37, 0x22010
		s_nop 0
		buffer_load_dwordx4 v8, s[24:27], 0 offen lds
		s_add_i32 m0, s37, 0x22020
		s_nop 0
		buffer_load_dwordx4 v9, s[24:27], 0 offen lds
		s_add_i32 m0, s37, 0x22030
		s_nop 0
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_4:
		s_andn2_b64 exec, s[66:67], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_4
.Lwmma_f16_matmul_tiled.exec_endif_4:
		s_mov_b64 exec, s[66:67]
		s_add_i32 s44, s10, 0x8000
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v7, v4, 12, s44
		s_add_i32 s44, s10, 0x8010
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v8, v4, 12, s44
		s_add_i32 s44, s10, 0x8020
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v9, v4, 12, s44
		s_add_i32 s44, s10, 0x8030
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v10, v4, 12, s44
		s_add_i32 s44, s10, 0x8040
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v11, v4, 12, s44
		s_add_i32 s44, s10, 0x8050
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v16, v4, 12, s44
		s_add_i32 s44, s10, 0x8060
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v17, v4, 12, s44
		s_add_i32 s44, s10, 0x8070
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v18, v4, 12, s44
		s_and_saveexec_b64 s[66:67], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_5
		s_add_i32 m0, s38, 0x22800
		s_nop 0
		buffer_load_dwordx4 v7, s[0:3], 0 offen lds
		s_add_i32 m0, s38, 0x22810
		s_nop 0
		buffer_load_dwordx4 v8, s[0:3], 0 offen lds
		s_add_i32 m0, s38, 0x22820
		s_nop 0
		buffer_load_dwordx4 v9, s[0:3], 0 offen lds
		s_add_i32 m0, s38, 0x22830
		s_nop 0
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		s_add_i32 m0, s38, 0x22a00
		s_nop 0
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		s_add_i32 m0, s38, 0x22a10
		s_nop 0
		buffer_load_dwordx4 v16, s[0:3], 0 offen lds
		s_add_i32 m0, s38, 0x22a20
		s_nop 0
		buffer_load_dwordx4 v17, s[0:3], 0 offen lds
		s_add_i32 m0, s38, 0x22a30
		s_nop 0
		buffer_load_dwordx4 v18, s[0:3], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_5:
		s_andn2_b64 exec, s[66:67], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_5
.Lwmma_f16_matmul_tiled.exec_endif_5:
		s_mov_b64 exec, s[66:67]
		s_add_i32 s44, s8, 0xc000
		s_add_i32 s44, s44, s4
		s_add_i32 s44, s44, s5
		v_lshl_add_u32 v7, v4, 12, s44
		s_add_i32 s44, s8, 0xc010
		s_add_i32 s44, s44, s4
		s_add_i32 s44, s44, s5
		v_lshl_add_u32 v8, v4, 12, s44
		s_add_i32 s44, s8, 0xc020
		s_add_i32 s44, s44, s4
		s_add_i32 s44, s44, s5
		v_lshl_add_u32 v9, v4, 12, s44
		s_add_i32 s44, s8, 0xc030
		s_add_i32 s44, s44, s4
		s_add_i32 s44, s44, s5
		v_lshl_add_u32 v10, v4, 12, s44
		s_and_saveexec_b64 s[66:67], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_6
		s_add_i32 m0, s37, 0x23000
		s_nop 0
		buffer_load_dwordx4 v7, s[24:27], 0 offen lds
		s_add_i32 m0, s37, 0x23010
		s_nop 0
		buffer_load_dwordx4 v8, s[24:27], 0 offen lds
		s_add_i32 m0, s37, 0x23020
		s_nop 0
		buffer_load_dwordx4 v9, s[24:27], 0 offen lds
		s_add_i32 m0, s37, 0x23030
		s_nop 0
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_6:
		s_andn2_b64 exec, s[66:67], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_6
.Lwmma_f16_matmul_tiled.exec_endif_6:
		s_mov_b64 exec, s[66:67]
		s_add_i32 s44, s10, 0xc000
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v7, v4, 12, s44
		s_add_i32 s44, s10, 0xc010
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v8, v4, 12, s44
		s_add_i32 s44, s10, 0xc020
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v9, v4, 12, s44
		s_add_i32 s44, s10, 0xc030
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v10, v4, 12, s44
		s_add_i32 s44, s10, 0xc040
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v11, v4, 12, s44
		s_add_i32 s44, s10, 0xc050
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v16, v4, 12, s44
		s_add_i32 s44, s10, 0xc060
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v17, v4, 12, s44
		s_add_i32 s44, s10, 0xc070
		s_add_i32 s44, s44, s6
		v_lshl_add_u32 v18, v4, 12, s44
		s_and_saveexec_b64 s[66:67], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_7
		s_add_i32 m0, s38, 0x23800
		s_nop 0
		buffer_load_dwordx4 v7, s[0:3], 0 offen lds
		s_add_i32 m0, s38, 0x23810
		s_nop 0
		buffer_load_dwordx4 v8, s[0:3], 0 offen lds
		s_add_i32 m0, s38, 0x23820
		s_nop 0
		buffer_load_dwordx4 v9, s[0:3], 0 offen lds
		s_add_i32 m0, s38, 0x23830
		s_nop 0
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		s_add_i32 m0, s38, 0x23a00
		s_nop 0
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		s_add_i32 m0, s38, 0x23a10
		s_nop 0
		buffer_load_dwordx4 v16, s[0:3], 0 offen lds
		s_add_i32 m0, s38, 0x23a20
		s_nop 0
		buffer_load_dwordx4 v17, s[0:3], 0 offen lds
		s_add_i32 m0, s38, 0x23a30
		s_nop 0
		buffer_load_dwordx4 v18, s[0:3], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_7:
		s_andn2_b64 exec, s[66:67], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_7
.Lwmma_f16_matmul_tiled.exec_endif_7:
		s_mov_b64 exec, s[66:67]
		s_add_i32 m0, s7, 0x10000
		s_add_i32 s44, s34, 0x80
		s_add_i32 s44, s44, s35
		v_add_u32_e32 v7, s44, v3
		buffer_load_dwordx4 v7, s[16:19], 0 offen lds
		s_add_i32 m0, s7, 0x12000
		s_add_i32 s44, s34, 0x80080
		s_add_i32 s44, s44, s35
		v_add_u32_e32 v7, s44, v3
		buffer_load_dwordx4 v7, s[16:19], 0 offen lds
		s_add_i32 m0, s7, 0x14000
		s_add_i32 s44, s34, 0xc0
		s_add_i32 s44, s44, s35
		v_add_u32_e32 v7, s44, v3
		buffer_load_dwordx4 v7, s[16:19], 0 offen lds
		s_add_i32 m0, s7, 0x16000
		s_add_i32 s34, s34, 0x800c0
		s_add_i32 s34, s34, s35
		v_add_u32_e32 v7, s34, v3
		buffer_load_dwordx4 v7, s[16:19], 0 offen lds
		s_add_i32 m0, s7, 0x18000
		s_add_i32 s34, s36, 0x80
		v_add_u32_e32 v7, s34, v3
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		s_add_i32 m0, s7, 0x1a000
		s_add_i32 s34, s36, 0x80080
		v_add_u32_e32 v7, s34, v3
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		s_add_i32 m0, s7, 0x1c000
		s_add_i32 s34, s36, 0xc0
		v_add_u32_e32 v7, s34, v3
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		s_add_i32 m0, s7, 0x1e000
		s_add_i32 s34, s36, 0x800c0
		v_add_u32_e32 v3, s34, v3
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		s_waitcnt vmcnt(8)
		s_barrier
		s_cmp_lt_i32 0, 30
		s_cselect_b32 s34, 1, 0
		s_add_i32 s35, s8, 0x10000
		s_add_i32 s35, s35, s4
		s_add_i32 s35, s35, s5
		s_add_i32 s36, s8, 0x10010
		s_add_i32 s36, s36, s4
		s_add_i32 s36, s36, s5
		s_add_i32 s44, s8, 0x10020
		s_add_i32 s44, s44, s4
		s_add_i32 s44, s44, s5
		s_add_i32 s45, s8, 0x10030
		s_add_i32 s45, s45, s4
		s_add_i32 s45, s45, s5
		s_add_i32 s46, s10, 0x10000
		s_add_i32 s46, s46, s6
		s_add_i32 s47, s10, 0x10010
		s_add_i32 s47, s47, s6
		s_add_i32 s48, s10, 0x10020
		s_add_i32 s48, s48, s6
		s_add_i32 s49, s10, 0x10030
		s_add_i32 s49, s49, s6
		s_add_i32 s50, s10, 0x10040
		s_add_i32 s50, s50, s6
		s_add_i32 s51, s10, 0x10050
		s_add_i32 s51, s51, s6
		s_add_i32 s52, s10, 0x10060
		s_add_i32 s52, s52, s6
		s_add_i32 s53, s10, 0x10070
		v_and_b32_e32 v3, 15, v0
		s_add_i32 s53, s53, s6
		s_add_i32 s54, s8, 0x14000
		s_add_i32 s54, s54, s4
		s_add_i32 s54, s54, s5
		v_lshrrev_b32_e32 v7, 1, v3
		s_add_i32 s55, s8, 0x14010
		s_add_i32 s55, s55, s4
		s_add_i32 s55, s55, s5
		s_add_i32 s56, s8, 0x14020
		v_lshrrev_b32_e32 v8, 4, v2
		v_and_b32_e32 v7, 3, v7
		s_add_i32 s56, s56, s4
		s_add_i32 s56, s56, s5
		s_add_i32 s8, s8, 0x14030
		s_add_i32 s4, s8, s4
		v_lshrrev_b32_e32 v0, 7, v0
		v_xor_b32_e32 v7, v8, v7
		v_and_b32_e32 v1, 1, v1
		s_add_i32 s4, s4, s5
		s_add_i32 s5, s10, 0x14000
		s_add_i32 s5, s5, s6
		s_add_i32 s8, s10, 0x14010
		v_lshlrev_b32_e32 v8, 12, v0
		v_lshlrev_b32_e32 v3, 6, v3
		v_lshlrev_b32_e32 v7, 4, v7
		v_lshlrev_b32_e32 v9, 13, v1
		s_add_i32 s8, s8, s6
		s_add_i32 s57, s10, 0x14020
		s_add_i32 s57, s57, s6
		s_add_i32 s58, s10, 0x14030
		v_add3_u32 v10, v8, v3, v7
		v_add3_u32 v11, v3, v9, v7
		s_add_i32 s58, s58, s6
		s_add_i32 s59, s10, 0x14040
		s_add_i32 s59, s59, s6
		s_add_i32 s60, s10, 0x14050
		ds_read_b128 v[16:19], v10
		ds_read_b128 v[20:23], v10 offset:1024
		ds_read_b128 v[24:27], v10 offset:2048
		ds_read_b128 v[28:31], v10 offset:3072
		ds_read_b128 v[32:35], v10 offset:16384
		ds_read_b128 v[36:39], v10 offset:17408
		ds_read_b128 v[40:43], v10 offset:18432
		ds_read_b128 v[44:47], v10 offset:19456
		ds_read_b128 v[48:51], v11 offset:32768
		ds_read_b128 v[52:55], v11 offset:33792
		ds_read_b128 v[56:59], v11 offset:34816
		ds_read_b128 v[60:63], v11 offset:35840
		ds_read_b128 v[64:67], v11 offset:36864
		ds_read_b128 v[68:71], v11 offset:37888
		ds_read_b128 v[72:75], v11 offset:38912
		ds_read_b128 v[76:79], v11 offset:39936
		ds_read_b128 v[80:83], v11 offset:49152
		ds_read_b128 v[84:87], v11 offset:50176
		ds_read_b128 v[88:91], v11 offset:51200
		ds_read_b128 v[92:95], v11 offset:52224
		ds_read_b128 v[96:99], v11 offset:53248
		ds_read_b128 v[100:103], v11 offset:54272
		ds_read_b128 v[104:107], v11 offset:55296
		ds_read_b128 v[108:111], v11 offset:56320
		s_add_i32 s60, s60, s6
		v_add_u32_e32 v10, 0x100, v5
		v_add_u32_e32 v11, 0x80100, v5
		v_add_u32_e32 v112, 0x140, v5
		v_add_u32_e32 v113, 0x80140, v5
		v_add_u32_e32 v5, 0x100, v6
		v_add_u32_e32 v114, 0x80100, v6
		v_add_u32_e32 v115, 0x140, v6
		v_add_u32_e32 v116, 0x80140, v6
		v_lshlrev_b32_e32 v0, 9, v0
		v_lshlrev_b32_e32 v2, 3, v2
		v_lshlrev_b32_e32 v6, 10, v1
		s_add_i32 s61, s10, 0x14060
		s_add_i32 s61, s61, s6
		s_add_i32 s10, s10, 0x14070
		s_add_i32 s6, s10, s6
		s_cmp_lg_u32 s34, 0
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
		s_cbranch_scc0 .Lwmma_f16_matmul_tiled.loop_exit_0
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_waitcnt vmcnt(8)
		s_barrier
		s_lshl_b32 s10, s39, 7
		s_and_b32 s34, s39, 1
		s_lshl_b32 s34, s34, 13
		s_add_i32 s62, s34, 0x20000
		v_add3_u32 v117, s62, v0, v2
		ds_read_b64_tr_b8 v[118:119], v117
		ds_read_b64_tr_b8 v[244:245], v117 offset:4096
		v_add3_u32 v117, s62, v2, v6
		ds_read_b64_tr_b8 v[246:247], v117 offset:2048
		ds_read_b64_tr_b8 v[248:249], v117 offset:2560
		ds_read_b64_tr_b8 v[250:251], v117 offset:6144
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[16:19], v[48:51], v[12:15], v118, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
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
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[32:35], v[80:83], v[12:15], v244, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
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
		s_add_i32 s62, s37, s34
		s_lshl_b32 s63, s39, 15
		s_add_i32 s64, s35, s63
		v_lshl_add_u32 v48, v4, 12, s64
		s_add_i32 s64, s36, s63
		v_lshl_add_u32 v49, v4, 12, s64
		s_add_i32 s64, s44, s63
		v_lshl_add_u32 v50, v4, 12, s64
		s_add_i32 s64, s45, s63
		v_lshl_add_u32 v51, v4, 12, s64
		s_and_saveexec_b64 s[66:67], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_8
		s_add_i32 m0, s62, 0x20000
		s_nop 0
		buffer_load_dwordx4 v48, s[24:27], 0 offen lds
		s_add_i32 m0, s62, 0x20010
		s_nop 0
		buffer_load_dwordx4 v49, s[24:27], 0 offen lds
		s_add_i32 m0, s62, 0x20020
		s_nop 0
		buffer_load_dwordx4 v50, s[24:27], 0 offen lds
		s_add_i32 m0, s62, 0x20030
		s_nop 0
		buffer_load_dwordx4 v51, s[24:27], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_8:
		s_andn2_b64 exec, s[66:67], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_8
.Lwmma_f16_matmul_tiled.exec_endif_8:
		s_mov_b64 exec, s[66:67]
		s_add_i32 s34, s38, s34
		s_add_i32 s64, s46, s63
		v_lshl_add_u32 v48, v4, 12, s64
		s_add_i32 s64, s47, s63
		v_lshl_add_u32 v49, v4, 12, s64
		s_add_i32 s64, s48, s63
		v_lshl_add_u32 v50, v4, 12, s64
		s_add_i32 s64, s49, s63
		v_lshl_add_u32 v51, v4, 12, s64
		s_add_i32 s64, s50, s63
		v_lshl_add_u32 v52, v4, 12, s64
		s_add_i32 s64, s51, s63
		v_lshl_add_u32 v53, v4, 12, s64
		s_add_i32 s64, s52, s63
		v_lshl_add_u32 v54, v4, 12, s64
		s_add_i32 s64, s53, s63
		v_lshl_add_u32 v55, v4, 12, s64
		s_and_saveexec_b64 s[66:67], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_9
		s_add_i32 m0, s34, 0x20800
		s_nop 0
		buffer_load_dwordx4 v48, s[0:3], 0 offen lds
		s_add_i32 m0, s34, 0x20810
		s_nop 0
		buffer_load_dwordx4 v49, s[0:3], 0 offen lds
		s_add_i32 m0, s34, 0x20820
		s_nop 0
		buffer_load_dwordx4 v50, s[0:3], 0 offen lds
		s_add_i32 m0, s34, 0x20830
		s_nop 0
		buffer_load_dwordx4 v51, s[0:3], 0 offen lds
		s_add_i32 m0, s34, 0x20a00
		s_nop 0
		buffer_load_dwordx4 v52, s[0:3], 0 offen lds
		s_add_i32 m0, s34, 0x20a10
		s_nop 0
		buffer_load_dwordx4 v53, s[0:3], 0 offen lds
		s_add_i32 m0, s34, 0x20a20
		s_nop 0
		buffer_load_dwordx4 v54, s[0:3], 0 offen lds
		s_add_i32 m0, s34, 0x20a30
		s_nop 0
		buffer_load_dwordx4 v55, s[0:3], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_9:
		s_andn2_b64 exec, s[66:67], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_9
.Lwmma_f16_matmul_tiled.exec_endif_9:
		s_mov_b64 exec, s[66:67]
		s_add_i32 s64, s54, s63
		v_lshl_add_u32 v48, v4, 12, s64
		s_add_i32 s64, s55, s63
		v_lshl_add_u32 v49, v4, 12, s64
		s_add_i32 s64, s56, s63
		v_lshl_add_u32 v50, v4, 12, s64
		s_add_i32 s64, s4, s63
		v_lshl_add_u32 v51, v4, 12, s64
		s_and_saveexec_b64 s[66:67], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_10
		s_add_i32 m0, s62, 0x21000
		s_nop 0
		buffer_load_dwordx4 v48, s[24:27], 0 offen lds
		s_add_i32 m0, s62, 0x21010
		s_nop 0
		buffer_load_dwordx4 v49, s[24:27], 0 offen lds
		s_add_i32 m0, s62, 0x21020
		s_nop 0
		buffer_load_dwordx4 v50, s[24:27], 0 offen lds
		s_add_i32 m0, s62, 0x21030
		s_nop 0
		buffer_load_dwordx4 v51, s[24:27], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_10:
		s_andn2_b64 exec, s[66:67], s[40:41]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_10
.Lwmma_f16_matmul_tiled.exec_endif_10:
		s_mov_b64 exec, s[66:67]
		s_add_i32 s62, s5, s63
		v_lshl_add_u32 v48, v4, 12, s62
		s_add_i32 s62, s8, s63
		v_lshl_add_u32 v49, v4, 12, s62
		s_add_i32 s62, s57, s63
		v_lshl_add_u32 v50, v4, 12, s62
		s_add_i32 s62, s58, s63
		v_lshl_add_u32 v51, v4, 12, s62
		s_add_i32 s62, s59, s63
		v_lshl_add_u32 v52, v4, 12, s62
		s_add_i32 s62, s60, s63
		v_lshl_add_u32 v53, v4, 12, s62
		s_add_i32 s62, s61, s63
		v_lshl_add_u32 v54, v4, 12, s62
		s_add_i32 s62, s6, s63
		v_lshl_add_u32 v55, v4, 12, s62
		s_and_saveexec_b64 s[66:67], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_11
		s_add_i32 m0, s34, 0x21800
		s_nop 0
		buffer_load_dwordx4 v48, s[0:3], 0 offen lds
		s_add_i32 m0, s34, 0x21810
		s_nop 0
		buffer_load_dwordx4 v49, s[0:3], 0 offen lds
		s_add_i32 m0, s34, 0x21820
		s_nop 0
		buffer_load_dwordx4 v50, s[0:3], 0 offen lds
		s_add_i32 m0, s34, 0x21830
		s_nop 0
		buffer_load_dwordx4 v51, s[0:3], 0 offen lds
		s_add_i32 m0, s34, 0x21a00
		s_nop 0
		buffer_load_dwordx4 v52, s[0:3], 0 offen lds
		s_add_i32 m0, s34, 0x21a10
		s_nop 0
		buffer_load_dwordx4 v53, s[0:3], 0 offen lds
		s_add_i32 m0, s34, 0x21a20
		s_nop 0
		buffer_load_dwordx4 v54, s[0:3], 0 offen lds
		s_add_i32 m0, s34, 0x21a30
		s_nop 0
		buffer_load_dwordx4 v55, s[0:3], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_11:
		s_andn2_b64 exec, s[66:67], s[42:43]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_11
.Lwmma_f16_matmul_tiled.exec_endif_11:
		s_mov_b64 exec, s[66:67]
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
		s_mov_b32 m0, s7
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[44:47], v[96:99], v[228:231], v244, v252 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v10, s[16:19], s10 offen lds
		s_mov_b32 m0, s9
		s_nop 0
		buffer_load_dwordx4 v11, s[16:19], s10 offen lds
		s_mov_b32 m0, s11
		s_nop 0
		buffer_load_dwordx4 v112, s[16:19], s10 offen lds
		s_mov_b32 m0, s13
		s_nop 0
		buffer_load_dwordx4 v113, s[16:19], s10 offen lds
		s_mov_b32 m0, s14
		s_nop 0
		buffer_load_dwordx4 v5, s[20:23], s10 offen lds
		s_mov_b32 m0, s15
		s_nop 0
		buffer_load_dwordx4 v114, s[20:23], s10 offen lds
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v115, s[20:23], s10 offen lds
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v116, s[20:23], s10 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[44:47], v[100:103], v[232:235], v244, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[44:47], v[104:107], v[236:239], v244, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[44:47], v[108:111], v[240:243], v244, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(8)
		s_barrier
		s_add_i32 s39, s39, 1
		s_and_b32 s10, s39, 1
		s_lshl_b32 s10, s10, 16
		v_add_u32_e32 v16, s10, v8
		v_add3_u32 v48, v16, v3, v7
		ds_read_b128 v[16:19], v48
		ds_read_b128 v[20:23], v48 offset:1024
		ds_read_b128 v[24:27], v48 offset:2048
		ds_read_b128 v[28:31], v48 offset:3072
		ds_read_b128 v[32:35], v48 offset:16384
		ds_read_b128 v[36:39], v48 offset:17408
		ds_read_b128 v[40:43], v48 offset:18432
		ds_read_b128 v[44:47], v48 offset:19456
		v_add_u32_e32 v48, s10, v3
		v_add3_u32 v117, v48, v9, v7
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
		s_add_i32 s7, s7, 0x10000
		s_and_b32 s7, s7, 0x1ffff
		s_add_i32 s9, s9, 0x10000
		s_and_b32 s9, s9, 0x1ffff
		s_add_i32 s10, s11, 0x10000
		s_and_b32 s11, s10, 0x1ffff
		s_add_i32 s10, s13, 0x10000
		s_and_b32 s13, s10, 0x1ffff
		s_add_i32 s10, s14, 0x10000
		s_and_b32 s14, s10, 0x1ffff
		s_add_i32 s10, s15, 0x10000
		s_and_b32 s15, s10, 0x1ffff
		s_add_i32 s10, s32, 0x10000
		s_and_b32 s32, s10, 0x1ffff
		s_add_i32 s10, s33, 0x10000
		s_and_b32 s33, s10, 0x1ffff
		s_cmp_lt_i32 s39, 30
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt vmcnt(8)
		s_barrier
		s_waitcnt vmcnt(0)
		s_barrier
		s_barrier
		v_add_u32_e32 v0, 0x20000, v0
		v_add_u32_e32 v0, v0, v2
		ds_read_b64_tr_b8 v[4:5], v0
		ds_read_b64_tr_b8 v[10:11], v0 offset:4096
		ds_read_b64_tr_b8 v[112:113], v0 offset:8192
		ds_read_b64_tr_b8 v[114:115], v0 offset:12288
		v_add_u32_e32 v0, 0x20000, v2
		v_lshl_add_u32 v0, v1, 10, v0
		ds_read_b64_tr_b8 v[116:117], v0 offset:2048
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[16:19], v[48:51], v[12:15], v4, v116 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b64_tr_b8 v[118:119], v0 offset:2560
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[16:19], v[52:55], v[120:123], v4, v116 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b64_tr_b8 v[244:245], v0 offset:6144
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[56:59], v[124:127], v4, v116 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b64_tr_b8 v[246:247], v0 offset:6656
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[60:63], v[128:131], v4, v116 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b64_tr_b8 v[248:249], v0 offset:10240
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], v[48:51], v[148:151], v4, v116 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b64_tr_b8 v[250:251], v0 offset:10752
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[52:55], v[152:155], v4, v116 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b64_tr_b8 v[252:253], v0 offset:14336
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[56:59], v[156:159], v4, v116 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b64_tr_b8 v[254:255], v0 offset:14848
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[60:63], v[160:163], v4, v116 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[48:51], v[180:183], v4, v116 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[52:55], v[184:187], v4, v116 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[56:59], v[188:191], v4, v116 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[60:63], v[192:195], v4, v116 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[48:51], v[212:215], v4, v116 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[28:31], v[52:55], v[216:219], v4, v116 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[28:31], v[56:59], v[220:223], v4, v116 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[60:63], v[224:227], v4, v116 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[16:19], v[64:67], v[132:135], v4, v118 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[68:71], v[136:139], v4, v118 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[16:19], v[72:75], v[140:143], v4, v118 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[16:19], v[76:79], v[144:147], v4, v118 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[64:67], v[164:167], v4, v118 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[68:71], v[168:171], v4, v118 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[72:75], v[172:175], v4, v118 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[20:23], v[76:79], v[176:179], v4, v118 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[64:67], v[196:199], v4, v118 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[68:71], v[200:203], v4, v118 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[72:75], v[204:207], v4, v118 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], v[76:79], v[208:211], v4, v118 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], v[64:67], v[228:231], v4, v118 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[28:31], v[68:71], v[232:235], v4, v118 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[28:31], v[72:75], v[236:239], v4, v118 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[28:31], v[76:79], v[240:243], v4, v118 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[32:35], v[80:83], v[12:15], v10, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[32:35], v[84:87], v[120:123], v10, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], v[88:91], v[124:127], v10, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[32:35], v[92:95], v[128:131], v10, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[36:39], v[80:83], v[148:151], v10, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[36:39], v[84:87], v[152:155], v10, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[36:39], v[88:91], v[156:159], v10, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[36:39], v[92:95], v[160:163], v10, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[40:43], v[80:83], v[180:183], v10, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[40:43], v[84:87], v[184:187], v10, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[40:43], v[88:91], v[188:191], v10, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[40:43], v[92:95], v[192:195], v10, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[44:47], v[80:83], v[212:215], v10, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[44:47], v[84:87], v[216:219], v10, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[44:47], v[88:91], v[220:223], v10, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[44:47], v[92:95], v[224:227], v10, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], v[96:99], v[132:135], v10, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[32:35], v[100:103], v[136:139], v10, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[32:35], v[104:107], v[140:143], v10, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[32:35], v[108:111], v[144:147], v10, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], v[96:99], v[164:167], v10, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], v[100:103], v[168:171], v10, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[36:39], v[104:107], v[172:175], v10, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[36:39], v[108:111], v[176:179], v10, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[40:43], v[96:99], v[196:199], v10, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], v[100:103], v[200:203], v10, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[40:43], v[104:107], v[204:207], v10, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[40:43], v[108:111], v[208:211], v10, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[44:47], v[96:99], v[228:231], v10, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[44:47], v[100:103], v[232:235], v10, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[44:47], v[104:107], v[236:239], v10, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[44:47], v[108:111], v[240:243], v10, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_add_u32_e32 v0, 0x10000, v8
		v_add3_u32 v0, v0, v3, v7
		ds_read_b128 v[16:19], v0
		ds_read_b128 v[20:23], v0 offset:1024
		ds_read_b128 v[24:27], v0 offset:2048
		ds_read_b128 v[28:31], v0 offset:3072
		ds_read_b128 v[32:35], v0 offset:16384
		ds_read_b128 v[36:39], v0 offset:17408
		ds_read_b128 v[40:43], v0 offset:18432
		ds_read_b128 v[44:47], v0 offset:19456
		v_add_u32_e32 v0, 0x10000, v3
		v_add3_u32 v0, v0, v9, v7
		ds_read_b128 v[4:7], v0 offset:32768
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[16:19], v[4:7], v[12:15], v112, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[8:11], v0 offset:33792
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[16:19], v[8:11], v[120:123], v112, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[48:51], v0 offset:34816
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[48:51], v[124:127], v112, v248 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[52:55], v0 offset:35840
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[52:55], v[128:131], v112, v248 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[56:59], v0 offset:36864
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], v[4:7], v[148:151], v112, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[60:63], v0 offset:37888
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[8:11], v[152:155], v112, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[64:67], v0 offset:38912
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[48:51], v[156:159], v112, v248 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[68:71], v0 offset:39936
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[52:55], v[160:163], v112, v248 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_b128 v[72:75], v0 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[4:7], v[180:183], v112, v248 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		ds_read_b128 v[76:79], v0 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[8:11], v[184:187], v112, v248 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		ds_read_b128 v[80:83], v0 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[48:51], v[188:191], v112, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_b128 v[84:87], v0 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[52:55], v[192:195], v112, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v0 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[4:7], v[212:215], v112, v248 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		ds_read_b128 v[4:7], v0 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[28:31], v[8:11], v[216:219], v112, v248 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		ds_read_b128 v[8:11], v0 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[28:31], v[48:51], v[220:223], v112, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_b128 v[48:51], v0 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[52:55], v[224:227], v112, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(7)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[32:35], v[72:75], v[12:15], v114, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
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
		v_cvt_pk_f16_f32 v0, v12, v13
		s_mov_b32 s0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[60:63], v[136:139], v112, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v1, v14, v15
		s_mov_b32 s1, 0x2000
		s_mov_b32 m0, s12
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[16:19], v[64:67], v[140:143], v112, v250 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v3
		s_waitcnt lgkmcnt(0)
		v_lshl_add_u32 v2, v3, 14, v2
		buffer_store_dwordx2 v[0:1], v2, s[28:31], 0 offen
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[16:19], v[68:71], v[144:147], v112, v250 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v120, v121
		s_mov_b32 s2, 0x3000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[56:59], v[164:167], v112, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v1, v122, v123
		buffer_store_dwordx2 v[0:1], v2, s[28:31], 0 offen offset:512
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[60:63], v[168:171], v112, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v124, v125
		v_cvt_pk_f16_f32 v1, v126, v127
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[64:67], v[172:175], v112, v250 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_store_dwordx2 v[0:1], v2, s[28:31], 0 offen offset:1024
		v_cvt_pk_f16_f32 v0, v128, v129
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[20:23], v[68:71], v[176:179], v112, v250 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v1, v130, v131
		buffer_store_dwordx2 v[0:1], v2, s[28:31], 0 offen offset:1536
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[56:59], v[196:199], v112, v250 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v148, v149
		v_cvt_pk_f16_f32 v1, v150, v151
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[60:63], v[200:203], v112, v250 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_store_dwordx2 v[0:1], v2, s[28:31], s0 offen
		v_cvt_pk_f16_f32 v0, v152, v153
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[64:67], v[204:207], v112, v250 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v1, v154, v155
		buffer_store_dwordx2 v[0:1], v2, s[28:31], s0 offen offset:512
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], v[68:71], v[208:211], v112, v250 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v156, v157
		v_cvt_pk_f16_f32 v1, v158, v159
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], v[56:59], v[228:231], v112, v250 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_store_dwordx2 v[0:1], v2, s[28:31], s0 offen offset:1024
		v_cvt_pk_f16_f32 v0, v160, v161
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[28:31], v[60:63], v[232:235], v112, v250 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v1, v162, v163
		buffer_store_dwordx2 v[0:1], v2, s[28:31], s0 offen offset:1536
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[28:31], v[64:67], v[236:239], v112, v250 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v180, v181
		v_cvt_pk_f16_f32 v1, v182, v183
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[28:31], v[68:71], v[240:243], v112, v250 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_store_dwordx2 v[0:1], v2, s[28:31], s1 offen
		v_cvt_pk_f16_f32 v0, v184, v185
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], v[88:91], v[132:135], v114, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v1, v186, v187
		buffer_store_dwordx2 v[0:1], v2, s[28:31], s1 offen offset:512
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[32:35], v[4:7], v[136:139], v114, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v188, v189
		v_cvt_pk_f16_f32 v1, v190, v191
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[32:35], v[8:11], v[140:143], v114, v254 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_store_dwordx2 v[0:1], v2, s[28:31], s1 offen offset:1024
		v_cvt_pk_f16_f32 v0, v192, v193
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[32:35], v[48:51], v[144:147], v114, v254 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v1, v194, v195
		buffer_store_dwordx2 v[0:1], v2, s[28:31], s1 offen offset:1536
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], v[88:91], v[164:167], v114, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v212, v213
		v_cvt_pk_f16_f32 v1, v214, v215
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], v[4:7], v[168:171], v114, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_store_dwordx2 v[0:1], v2, s[28:31], s2 offen
		v_cvt_pk_f16_f32 v0, v216, v217
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[36:39], v[8:11], v[172:175], v114, v254 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v1, v218, v219
		buffer_store_dwordx2 v[0:1], v2, s[28:31], s2 offen offset:512
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[36:39], v[48:51], v[176:179], v114, v254 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v220, v221
		v_cvt_pk_f16_f32 v1, v222, v223
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[40:43], v[88:91], v[196:199], v114, v254 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_store_dwordx2 v[0:1], v2, s[28:31], s2 offen offset:1024
		v_cvt_pk_f16_f32 v0, v224, v225
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], v[4:7], v[200:203], v114, v254 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v1, v226, v227
		buffer_store_dwordx2 v[0:1], v2, s[28:31], s2 offen offset:1536
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[40:43], v[8:11], v[204:207], v114, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v132, v133
		v_cvt_pk_f16_f32 v1, v134, v135
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[40:43], v[48:51], v[208:211], v114, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_store_dwordx2 v[0:1], v2, s[28:31], 0 offen offset:2048
		v_cvt_pk_f16_f32 v0, v136, v137
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[44:47], v[88:91], v[228:231], v114, v254 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v1, v138, v139
		buffer_store_dwordx2 v[0:1], v2, s[28:31], 0 offen offset:2560
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[44:47], v[4:7], v[232:235], v114, v254 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v140, v141
		v_cvt_pk_f16_f32 v1, v142, v143
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[44:47], v[8:11], v[236:239], v114, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_store_dwordx2 v[0:1], v2, s[28:31], 0 offen offset:3072
		v_cvt_pk_f16_f32 v0, v144, v145
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[44:47], v[48:51], v[240:243], v114, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v1, v146, v147
		buffer_store_dwordx2 v[0:1], v2, s[28:31], 0 offen offset:3584
		v_cvt_pk_f16_f32 v0, v164, v165
		v_cvt_pk_f16_f32 v1, v166, v167
		buffer_store_dwordx2 v[0:1], v2, s[28:31], s0 offen offset:2048
		v_cvt_pk_f16_f32 v0, v168, v169
		v_cvt_pk_f16_f32 v1, v170, v171
		buffer_store_dwordx2 v[0:1], v2, s[28:31], s0 offen offset:2560
		v_cvt_pk_f16_f32 v0, v172, v173
		v_cvt_pk_f16_f32 v1, v174, v175
		buffer_store_dwordx2 v[0:1], v2, s[28:31], s0 offen offset:3072
		v_cvt_pk_f16_f32 v0, v176, v177
		v_cvt_pk_f16_f32 v1, v178, v179
		buffer_store_dwordx2 v[0:1], v2, s[28:31], s0 offen offset:3584
		v_cvt_pk_f16_f32 v0, v196, v197
		v_cvt_pk_f16_f32 v1, v198, v199
		buffer_store_dwordx2 v[0:1], v2, s[28:31], s1 offen offset:2048
		v_cvt_pk_f16_f32 v0, v200, v201
		v_cvt_pk_f16_f32 v1, v202, v203
		buffer_store_dwordx2 v[0:1], v2, s[28:31], s1 offen offset:2560
		v_cvt_pk_f16_f32 v0, v204, v205
		v_cvt_pk_f16_f32 v1, v206, v207
		buffer_store_dwordx2 v[0:1], v2, s[28:31], s1 offen offset:3072
		v_cvt_pk_f16_f32 v0, v208, v209
		v_cvt_pk_f16_f32 v1, v210, v211
		buffer_store_dwordx2 v[0:1], v2, s[28:31], s1 offen offset:3584
		v_cvt_pk_f16_f32 v0, v228, v229
		v_cvt_pk_f16_f32 v1, v230, v231
		buffer_store_dwordx2 v[0:1], v2, s[28:31], s2 offen offset:2048
		v_cvt_pk_f16_f32 v0, v232, v233
		v_cvt_pk_f16_f32 v1, v234, v235
		buffer_store_dwordx2 v[0:1], v2, s[28:31], s2 offen offset:2560
		v_cvt_pk_f16_f32 v0, v236, v237
		v_cvt_pk_f16_f32 v1, v238, v239
		buffer_store_dwordx2 v[0:1], v2, s[28:31], s2 offen offset:3072
		v_cvt_pk_f16_f32 v0, v240, v241
		v_cvt_pk_f16_f32 v1, v242, v243
		buffer_store_dwordx2 v[0:1], v2, s[28:31], s2 offen offset:3584
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
		.amdhsa_next_free_sgpr 68
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
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 68
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
    .sgpr_count:     68
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
