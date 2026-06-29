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
		s_add_i32 s3, s4, s3
		v_lshrrev_b32_e32 v3, 3, v2
		s_and_b32 s4, s13, 7
		v_and_b32_e32 v4, 3, v3
		s_lshl_b32 s4, s4, 5
		v_and_b32_e32 v5, 3, v2
		s_add_i32 s3, s3, s4
		v_xor_b32_e32 v4, v4, v5
		s_lshr_b32 s4, s3, 6
		v_lshrrev_b32_e32 v5, 2, v2
		s_lshl_b32 s5, s4, 23
		v_lshlrev_b32_e32 v5, 12, v5
		s_and_b32 s3, s3, 63
		v_lshl_add_u32 v5, v1, 16, v5
		s_lshr_b32 s12, s3, 2
		v_lshl_add_u32 v4, v4, 4, v5
		s_lshl_b32 s13, s12, 17
		s_add_i32 s5, s5, s13
		s_and_b32 s3, s3, 3
		s_lshl_b32 s13, s3, 21
		s_add_i32 s5, s5, s13
		s_add_u32 s6, s6, s5
		s_addc_u32 s7, s7, 0
		s_lshr_b32 s5, s2, 6
		s_lshl_b32 s13, s5, 10
		s_add_i32 s14, s13, 0x2000
		s_add_i32 s15, s13, 0x4000
		s_add_i32 s24, s13, 0x6000
		s_add_i32 s25, s13, 0x8000
		s_add_i32 s26, s13, 0xa000
		s_add_i32 s27, s13, 0xc000
		s_add_i32 s28, s13, 0xe000
		s_mov_b32 m0, s13
		s_lshl_b32 s29, s4, 22
		s_lshl_b32 s30, s3, 20
		s_add_i32 s31, s29, s30
		v_add_u32_e32 v5, s31, v4
		buffer_load_dwordx4 v5, s[16:19], 0 offen lds
		s_mov_b32 m0, s14
		s_add_i32 s31, s29, 0x80000
		s_add_i32 s31, s31, s30
		v_add_u32_e32 v6, s31, v4
		buffer_load_dwordx4 v6, s[16:19], 0 offen lds
		s_mov_b32 m0, s15
		s_add_i32 s31, s29, 64
		s_add_i32 s31, s31, s30
		v_add_u32_e32 v6, s31, v4
		buffer_load_dwordx4 v6, s[16:19], 0 offen lds
		s_mov_b32 m0, s24
		s_add_i32 s31, s29, 0x80040
		s_add_i32 s31, s31, s30
		v_add_u32_e32 v6, s31, v4
		buffer_load_dwordx4 v6, s[16:19], 0 offen lds
		s_mov_b32 m0, s25
		s_lshl_b32 s31, s12, 20
		v_add_u32_e32 v6, s31, v4
		buffer_load_dwordx4 v6, s[20:23], 0 offen lds
		s_add_i32 s32, s31, 0x80000
		v_add_u32_e32 v7, s32, v4
		s_mov_b32 m0, s26
		s_nop 0
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		v_add3_u32 v7, s31, 64, v4
		s_mov_b32 m0, s27
		s_nop 0
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		s_add_i32 s32, s31, 0x80040
		v_add_u32_e32 v7, s32, v4
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		s_lshr_b32 s2, s2, 7
		v_mov_b64_e32 v[8:9], 0
		v_mov_b64_e32 v[10:11], 0
		s_lshl_b32 s32, s2, 9
		v_and_b32_e32 v7, 39, v0
		s_lshl_b32 s4, s4, 10
		v_and_or_b32 v12, 1, v1, v7
		s_lshl_b32 s2, s2, 6
		s_mov_b32 s36, s10
		s_mov_b32 s37, s11
		s_mov_b32 s38, 0x7fffffff
		s_mov_b32 s39, 0x31016000
		s_mov_b32 s40, s8
		s_mov_b32 s41, s9
		s_mov_b32 s42, 0x7fffffff
		s_mov_b32 s43, 0x31016000
		s_mov_b32 s8, s6
		s_mov_b32 s9, s7
		s_mov_b32 s10, 0x20000
		s_mov_b32 s11, 0x31016000
		s_add_i32 s0, s4, s2
		s_lshl_b32 s1, s3, 8
		s_add_i32 s0, s0, s1
		v_lshl_add_u32 v13, v3, 12, s0
		s_add_i32 s0, s4, 16
		s_add_i32 s0, s0, s2
		s_add_i32 s0, s0, s1
		v_lshl_add_u32 v14, v3, 12, s0
		s_add_i32 s0, s4, 32
		s_add_i32 s0, s0, s2
		s_add_i32 s0, s0, s1
		v_lshl_add_u32 v15, v3, 12, s0
		s_add_i32 s0, s4, 48
		s_add_i32 s0, s0, s2
		s_mov_b32 s3, 0
		v_cmp_eq_u32_e64 vcc, v12, s3
		s_mov_b64 s[6:7], vcc
		s_add_i32 s0, s0, s1
		v_lshl_add_u32 v12, v3, 12, s0
		s_and_saveexec_b64 s[64:65], s[6:7]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_0
		s_add_i32 m0, s32, 0x20000
		s_nop 0
		buffer_load_dwordx4 v13, s[40:43], 0 offen lds
		s_add_i32 m0, s32, 0x20010
		s_nop 0
		buffer_load_dwordx4 v14, s[40:43], 0 offen lds
		s_add_i32 m0, s32, 0x20020
		s_nop 0
		buffer_load_dwordx4 v15, s[40:43], 0 offen lds
		s_add_i32 m0, s32, 0x20030
		s_nop 0
		buffer_load_dwordx4 v12, s[40:43], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_0:
		s_andn2_b64 exec, s[64:65], s[6:7]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_0
.Lwmma_f16_matmul_tiled.exec_endif_0:
		s_mov_b64 exec, s[64:65]
		v_lshrrev_b32_e32 v12, 1, v1
		v_or_b32_e32 v7, v7, v12
		v_cmp_eq_u32_e64 vcc, v7, s3
		s_mov_b64 s[34:35], vcc
		s_and_b32 s0, s5, 1
		s_lshl_b32 s5, s0, 10
		s_lshl_b32 s12, s12, 8
		s_lshl_b32 s0, s0, 7
		s_add_i32 s33, s12, s0
		v_lshl_add_u32 v7, v3, 12, s33
		s_add_i32 s33, s12, 16
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v12, v3, 12, s33
		s_add_i32 s33, s12, 32
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v13, v3, 12, s33
		s_add_i32 s33, s12, 48
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v14, v3, 12, s33
		s_add_i32 s33, s12, 64
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v15, v3, 12, s33
		s_add_i32 s33, s12, 0x50
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v16, v3, 12, s33
		s_add_i32 s33, s12, 0x60
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v17, v3, 12, s33
		s_add_i32 s33, s12, 0x70
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v18, v3, 12, s33
		s_and_saveexec_b64 s[64:65], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_1
		s_add_i32 m0, s5, 0x20800
		s_nop 0
		buffer_load_dwordx4 v7, s[36:39], 0 offen lds
		s_add_i32 m0, s5, 0x20810
		s_nop 0
		buffer_load_dwordx4 v12, s[36:39], 0 offen lds
		s_add_i32 m0, s5, 0x20820
		s_nop 0
		buffer_load_dwordx4 v13, s[36:39], 0 offen lds
		s_add_i32 m0, s5, 0x20830
		s_nop 0
		buffer_load_dwordx4 v14, s[36:39], 0 offen lds
		s_add_i32 m0, s5, 0x20a00
		s_nop 0
		buffer_load_dwordx4 v15, s[36:39], 0 offen lds
		s_add_i32 m0, s5, 0x20a10
		s_nop 0
		buffer_load_dwordx4 v16, s[36:39], 0 offen lds
		s_add_i32 m0, s5, 0x20a20
		s_nop 0
		buffer_load_dwordx4 v17, s[36:39], 0 offen lds
		s_add_i32 m0, s5, 0x20a30
		s_nop 0
		buffer_load_dwordx4 v18, s[36:39], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_1:
		s_andn2_b64 exec, s[64:65], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_1
.Lwmma_f16_matmul_tiled.exec_endif_1:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s33, s4, 0x4000
		s_add_i32 s33, s33, s2
		s_add_i32 s33, s33, s1
		v_lshl_add_u32 v7, v3, 12, s33
		s_add_i32 s33, s4, 0x4010
		s_add_i32 s33, s33, s2
		s_add_i32 s33, s33, s1
		v_lshl_add_u32 v12, v3, 12, s33
		s_add_i32 s33, s4, 0x4020
		s_add_i32 s33, s33, s2
		s_add_i32 s33, s33, s1
		v_lshl_add_u32 v13, v3, 12, s33
		s_add_i32 s33, s4, 0x4030
		s_add_i32 s33, s33, s2
		s_add_i32 s33, s33, s1
		v_lshl_add_u32 v14, v3, 12, s33
		s_and_saveexec_b64 s[64:65], s[6:7]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_2
		s_add_i32 m0, s32, 0x21000
		s_nop 0
		buffer_load_dwordx4 v7, s[40:43], 0 offen lds
		s_add_i32 m0, s32, 0x21010
		s_nop 0
		buffer_load_dwordx4 v12, s[40:43], 0 offen lds
		s_add_i32 m0, s32, 0x21020
		s_nop 0
		buffer_load_dwordx4 v13, s[40:43], 0 offen lds
		s_add_i32 m0, s32, 0x21030
		s_nop 0
		buffer_load_dwordx4 v14, s[40:43], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_2:
		s_andn2_b64 exec, s[64:65], s[6:7]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_2
.Lwmma_f16_matmul_tiled.exec_endif_2:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s33, s12, 0x4000
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v7, v3, 12, s33
		s_add_i32 s33, s12, 0x4010
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v12, v3, 12, s33
		s_add_i32 s33, s12, 0x4020
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v13, v3, 12, s33
		s_add_i32 s33, s12, 0x4030
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v14, v3, 12, s33
		s_add_i32 s33, s12, 0x4040
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v15, v3, 12, s33
		s_add_i32 s33, s12, 0x4050
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v16, v3, 12, s33
		s_add_i32 s33, s12, 0x4060
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v17, v3, 12, s33
		s_add_i32 s33, s12, 0x4070
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v18, v3, 12, s33
		s_and_saveexec_b64 s[64:65], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_3
		s_add_i32 m0, s5, 0x21800
		s_nop 0
		buffer_load_dwordx4 v7, s[36:39], 0 offen lds
		s_add_i32 m0, s5, 0x21810
		s_nop 0
		buffer_load_dwordx4 v12, s[36:39], 0 offen lds
		s_add_i32 m0, s5, 0x21820
		s_nop 0
		buffer_load_dwordx4 v13, s[36:39], 0 offen lds
		s_add_i32 m0, s5, 0x21830
		s_nop 0
		buffer_load_dwordx4 v14, s[36:39], 0 offen lds
		s_add_i32 m0, s5, 0x21a00
		s_nop 0
		buffer_load_dwordx4 v15, s[36:39], 0 offen lds
		s_add_i32 m0, s5, 0x21a10
		s_nop 0
		buffer_load_dwordx4 v16, s[36:39], 0 offen lds
		s_add_i32 m0, s5, 0x21a20
		s_nop 0
		buffer_load_dwordx4 v17, s[36:39], 0 offen lds
		s_add_i32 m0, s5, 0x21a30
		s_nop 0
		buffer_load_dwordx4 v18, s[36:39], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_3:
		s_andn2_b64 exec, s[64:65], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_3
.Lwmma_f16_matmul_tiled.exec_endif_3:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s33, s4, 0x8000
		s_add_i32 s33, s33, s2
		s_add_i32 s33, s33, s1
		v_lshl_add_u32 v7, v3, 12, s33
		s_add_i32 s33, s4, 0x8010
		s_add_i32 s33, s33, s2
		s_add_i32 s33, s33, s1
		v_lshl_add_u32 v12, v3, 12, s33
		s_add_i32 s33, s4, 0x8020
		s_add_i32 s33, s33, s2
		s_add_i32 s33, s33, s1
		v_lshl_add_u32 v13, v3, 12, s33
		s_add_i32 s33, s4, 0x8030
		s_add_i32 s33, s33, s2
		s_add_i32 s33, s33, s1
		v_lshl_add_u32 v14, v3, 12, s33
		s_and_saveexec_b64 s[64:65], s[6:7]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_4
		s_add_i32 m0, s32, 0x22000
		s_nop 0
		buffer_load_dwordx4 v7, s[40:43], 0 offen lds
		s_add_i32 m0, s32, 0x22010
		s_nop 0
		buffer_load_dwordx4 v12, s[40:43], 0 offen lds
		s_add_i32 m0, s32, 0x22020
		s_nop 0
		buffer_load_dwordx4 v13, s[40:43], 0 offen lds
		s_add_i32 m0, s32, 0x22030
		s_nop 0
		buffer_load_dwordx4 v14, s[40:43], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_4:
		s_andn2_b64 exec, s[64:65], s[6:7]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_4
.Lwmma_f16_matmul_tiled.exec_endif_4:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s33, s12, 0x8000
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v7, v3, 12, s33
		s_add_i32 s33, s12, 0x8010
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v12, v3, 12, s33
		s_add_i32 s33, s12, 0x8020
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v13, v3, 12, s33
		s_add_i32 s33, s12, 0x8030
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v14, v3, 12, s33
		s_add_i32 s33, s12, 0x8040
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v15, v3, 12, s33
		s_add_i32 s33, s12, 0x8050
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v16, v3, 12, s33
		s_add_i32 s33, s12, 0x8060
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v17, v3, 12, s33
		s_add_i32 s33, s12, 0x8070
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v18, v3, 12, s33
		s_and_saveexec_b64 s[64:65], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_5
		s_add_i32 m0, s5, 0x22800
		s_nop 0
		buffer_load_dwordx4 v7, s[36:39], 0 offen lds
		s_add_i32 m0, s5, 0x22810
		s_nop 0
		buffer_load_dwordx4 v12, s[36:39], 0 offen lds
		s_add_i32 m0, s5, 0x22820
		s_nop 0
		buffer_load_dwordx4 v13, s[36:39], 0 offen lds
		s_add_i32 m0, s5, 0x22830
		s_nop 0
		buffer_load_dwordx4 v14, s[36:39], 0 offen lds
		s_add_i32 m0, s5, 0x22a00
		s_nop 0
		buffer_load_dwordx4 v15, s[36:39], 0 offen lds
		s_add_i32 m0, s5, 0x22a10
		s_nop 0
		buffer_load_dwordx4 v16, s[36:39], 0 offen lds
		s_add_i32 m0, s5, 0x22a20
		s_nop 0
		buffer_load_dwordx4 v17, s[36:39], 0 offen lds
		s_add_i32 m0, s5, 0x22a30
		s_nop 0
		buffer_load_dwordx4 v18, s[36:39], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_5:
		s_andn2_b64 exec, s[64:65], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_5
.Lwmma_f16_matmul_tiled.exec_endif_5:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s33, s4, 0xc000
		s_add_i32 s33, s33, s2
		s_add_i32 s33, s33, s1
		v_lshl_add_u32 v7, v3, 12, s33
		s_add_i32 s33, s4, 0xc010
		s_add_i32 s33, s33, s2
		s_add_i32 s33, s33, s1
		v_lshl_add_u32 v12, v3, 12, s33
		s_add_i32 s33, s4, 0xc020
		s_add_i32 s33, s33, s2
		s_add_i32 s33, s33, s1
		v_lshl_add_u32 v13, v3, 12, s33
		s_add_i32 s33, s4, 0xc030
		s_add_i32 s33, s33, s2
		s_add_i32 s33, s33, s1
		v_lshl_add_u32 v14, v3, 12, s33
		s_and_saveexec_b64 s[64:65], s[6:7]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_6
		s_add_i32 m0, s32, 0x23000
		s_nop 0
		buffer_load_dwordx4 v7, s[40:43], 0 offen lds
		s_add_i32 m0, s32, 0x23010
		s_nop 0
		buffer_load_dwordx4 v12, s[40:43], 0 offen lds
		s_add_i32 m0, s32, 0x23020
		s_nop 0
		buffer_load_dwordx4 v13, s[40:43], 0 offen lds
		s_add_i32 m0, s32, 0x23030
		s_nop 0
		buffer_load_dwordx4 v14, s[40:43], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_6:
		s_andn2_b64 exec, s[64:65], s[6:7]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_6
.Lwmma_f16_matmul_tiled.exec_endif_6:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s33, s12, 0xc000
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v7, v3, 12, s33
		s_add_i32 s33, s12, 0xc010
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v12, v3, 12, s33
		s_add_i32 s33, s12, 0xc020
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v13, v3, 12, s33
		s_add_i32 s33, s12, 0xc030
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v14, v3, 12, s33
		s_add_i32 s33, s12, 0xc040
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v15, v3, 12, s33
		s_add_i32 s33, s12, 0xc050
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v16, v3, 12, s33
		s_add_i32 s33, s12, 0xc060
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v17, v3, 12, s33
		s_add_i32 s33, s12, 0xc070
		s_add_i32 s33, s33, s0
		v_lshl_add_u32 v18, v3, 12, s33
		s_and_saveexec_b64 s[64:65], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_7
		s_add_i32 m0, s5, 0x23800
		s_nop 0
		buffer_load_dwordx4 v7, s[36:39], 0 offen lds
		s_add_i32 m0, s5, 0x23810
		s_nop 0
		buffer_load_dwordx4 v12, s[36:39], 0 offen lds
		s_add_i32 m0, s5, 0x23820
		s_nop 0
		buffer_load_dwordx4 v13, s[36:39], 0 offen lds
		s_add_i32 m0, s5, 0x23830
		s_nop 0
		buffer_load_dwordx4 v14, s[36:39], 0 offen lds
		s_add_i32 m0, s5, 0x23a00
		s_nop 0
		buffer_load_dwordx4 v15, s[36:39], 0 offen lds
		s_add_i32 m0, s5, 0x23a10
		s_nop 0
		buffer_load_dwordx4 v16, s[36:39], 0 offen lds
		s_add_i32 m0, s5, 0x23a20
		s_nop 0
		buffer_load_dwordx4 v17, s[36:39], 0 offen lds
		s_add_i32 m0, s5, 0x23a30
		s_nop 0
		buffer_load_dwordx4 v18, s[36:39], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_7:
		s_andn2_b64 exec, s[64:65], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_7
.Lwmma_f16_matmul_tiled.exec_endif_7:
		s_mov_b64 exec, s[64:65]
		s_add_i32 m0, s13, 0x10000
		s_add_i32 s33, s29, 0x80
		s_add_i32 s33, s33, s30
		v_add_u32_e32 v7, s33, v4
		buffer_load_dwordx4 v7, s[16:19], 0 offen lds
		s_add_i32 m0, s13, 0x12000
		s_add_i32 s33, s29, 0x80080
		s_add_i32 s33, s33, s30
		v_add_u32_e32 v7, s33, v4
		buffer_load_dwordx4 v7, s[16:19], 0 offen lds
		s_add_i32 m0, s13, 0x14000
		s_add_i32 s33, s29, 0xc0
		s_add_i32 s33, s33, s30
		v_add_u32_e32 v7, s33, v4
		buffer_load_dwordx4 v7, s[16:19], 0 offen lds
		s_add_i32 m0, s13, 0x16000
		s_add_i32 s29, s29, 0x800c0
		s_add_i32 s29, s29, s30
		v_add_u32_e32 v7, s29, v4
		buffer_load_dwordx4 v7, s[16:19], 0 offen lds
		s_add_i32 m0, s13, 0x18000
		s_add_i32 s29, s31, 0x80
		v_add_u32_e32 v7, s29, v4
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		s_add_i32 m0, s13, 0x1a000
		s_add_i32 s29, s31, 0x80080
		v_add_u32_e32 v7, s29, v4
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		s_add_i32 m0, s13, 0x1c000
		s_add_i32 s29, s31, 0xc0
		v_add_u32_e32 v7, s29, v4
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		s_add_i32 m0, s13, 0x1e000
		s_add_i32 s29, s31, 0x800c0
		v_add_u32_e32 v4, s29, v4
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		s_waitcnt vmcnt(8)
		s_barrier
		s_cmp_lt_i32 0, 30
		s_cselect_b32 s29, 1, 0
		s_add_i32 s30, s4, 0x10000
		s_add_i32 s30, s30, s2
		s_add_i32 s30, s30, s1
		s_add_i32 s31, s4, 0x10010
		s_add_i32 s31, s31, s2
		s_add_i32 s31, s31, s1
		s_add_i32 s33, s4, 0x10020
		s_add_i32 s33, s33, s2
		s_add_i32 s33, s33, s1
		s_add_i32 s44, s4, 0x10030
		s_add_i32 s44, s44, s2
		s_add_i32 s44, s44, s1
		s_add_i32 s45, s12, 0x10000
		s_add_i32 s45, s45, s0
		s_add_i32 s46, s12, 0x10010
		s_add_i32 s46, s46, s0
		s_add_i32 s47, s12, 0x10020
		s_add_i32 s47, s47, s0
		s_add_i32 s48, s12, 0x10030
		s_add_i32 s48, s48, s0
		s_add_i32 s49, s12, 0x10040
		s_add_i32 s49, s49, s0
		s_add_i32 s50, s12, 0x10050
		s_add_i32 s50, s50, s0
		s_add_i32 s51, s12, 0x10060
		s_add_i32 s51, s51, s0
		s_add_i32 s52, s12, 0x10070
		s_add_i32 s52, s52, s0
		v_and_b32_e32 v4, 15, v0
		s_add_i32 s53, s4, 0x14000
		s_add_i32 s53, s53, s2
		s_add_i32 s53, s53, s1
		v_lshrrev_b32_e32 v7, 1, v4
		s_add_i32 s54, s4, 0x14010
		s_add_i32 s54, s54, s2
		s_add_i32 s54, s54, s1
		s_add_i32 s55, s4, 0x14020
		v_lshrrev_b32_e32 v12, 4, v2
		v_and_b32_e32 v7, 3, v7
		s_add_i32 s55, s55, s2
		s_add_i32 s55, s55, s1
		s_add_i32 s4, s4, 0x14030
		s_add_i32 s2, s4, s2
		v_lshrrev_b32_e32 v0, 7, v0
		v_xor_b32_e32 v7, v12, v7
		v_and_b32_e32 v12, 1, v1
		s_add_i32 s1, s2, s1
		s_add_i32 s2, s12, 0x14000
		s_add_i32 s2, s2, s0
		s_add_i32 s4, s12, 0x14010
		v_lshlrev_b32_e32 v13, 12, v0
		v_lshlrev_b32_e32 v4, 6, v4
		v_lshlrev_b32_e32 v7, 4, v7
		s_add_i32 s4, s4, s0
		v_lshlrev_b32_e32 v14, 13, v12
		s_add_i32 s56, s12, 0x14020
		s_add_i32 s56, s56, s0
		s_add_i32 s57, s12, 0x14030
		v_add3_u32 v15, v13, v4, v7
		v_add3_u32 v16, v4, v14, v7
		s_add_i32 s57, s57, s0
		s_add_i32 s58, s12, 0x14040
		s_add_i32 s58, s58, s0
		s_add_i32 s59, s12, 0x14050
		ds_read_b128 v[20:23], v15
		ds_read_b128 v[24:27], v15 offset:1024
		ds_read_b128 v[28:31], v15 offset:2048
		ds_read_b128 v[32:35], v15 offset:3072
		ds_read_b128 v[36:39], v15 offset:16384
		ds_read_b128 v[40:43], v15 offset:17408
		ds_read_b128 v[44:47], v15 offset:18432
		ds_read_b128 v[48:51], v15 offset:19456
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
		s_add_i32 s59, s59, s0
		v_lshlrev_b32_e32 v0, 9, v0
		v_lshlrev_b32_e32 v2, 3, v2
		v_lshlrev_b32_e32 v15, 10, v12
		v_add_u32_e32 v16, 0x100, v5
		v_add_u32_e32 v17, 0x100, v6
		v_add_u32_e32 v18, 0x80100, v5
		v_add_u32_e32 v19, 0x80100, v6
		v_add_u32_e32 v116, 0x140, v5
		v_add_u32_e32 v117, 0x140, v6
		v_add_u32_e32 v118, 0x80140, v5
		v_add_u32_e32 v5, 0x80140, v6
		s_add_i32 s60, s12, 0x14060
		s_add_i32 s60, s60, s0
		s_add_i32 s12, s12, 0x14070
		s_add_i32 s0, s12, s0
		s_cmp_lg_u32 s29, 0
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
		s_lshl_b32 s12, s3, 7
		s_and_b32 s29, s3, 1
		s_lshl_b32 s29, s29, 13
		s_add_i32 s61, s29, 0x20000
		v_add3_u32 v6, s61, v0, v2
		ds_read_b64_tr_b8 v[244:245], v6
		ds_read_b64_tr_b8 v[246:247], v6 offset:4096
		v_add3_u32 v6, s61, v2, v15
		ds_read_b64_tr_b8 v[248:249], v6 offset:2048
		ds_read_b64_tr_b8 v[250:251], v6 offset:2560
		ds_read_b64_tr_b8 v[252:253], v6 offset:6144
		ds_read_b64_tr_b8 v[254:255], v6 offset:6656
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[20:23], v[52:55], v[8:11], v244, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], v[56:59], v[120:123], v244, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], v[60:63], v[124:127], v244, v248 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[20:23], v[64:67], v[128:131], v244, v248 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[52:55], v[148:151], v244, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[56:59], v[152:155], v244, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[60:63], v[156:159], v244, v248 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[24:27], v[64:67], v[160:163], v244, v248 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[52:55], v[180:183], v244, v248 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[56:59], v[184:187], v244, v248 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[60:63], v[188:191], v244, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[28:31], v[64:67], v[192:195], v244, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[52:55], v[212:215], v244, v248 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[56:59], v[216:219], v244, v248 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], v[60:63], v[220:223], v244, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[32:35], v[64:67], v[224:227], v244, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[36:39], v[84:87], v[8:11], v246, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[36:39], v[88:91], v[120:123], v246, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[36:39], v[92:95], v[124:127], v246, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[36:39], v[96:99], v[128:131], v246, v252 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[40:43], v[84:87], v[148:151], v246, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[40:43], v[88:91], v[152:155], v246, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[40:43], v[92:95], v[156:159], v246, v252 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[40:43], v[96:99], v[160:163], v246, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[44:47], v[84:87], v[180:183], v246, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[44:47], v[88:91], v[184:187], v246, v252 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[44:47], v[92:95], v[188:191], v246, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[44:47], v[96:99], v[192:195], v246, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[48:51], v[84:87], v[212:215], v246, v252 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[48:51], v[88:91], v[216:219], v246, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[48:51], v[92:95], v[220:223], v246, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[48:51], v[96:99], v[224:227], v246, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s61, s32, s29
		s_lshl_b32 s62, s3, 15
		s_add_i32 s63, s30, s62
		v_lshl_add_u32 v6, v3, 12, s63
		s_add_i32 s63, s31, s62
		v_lshl_add_u32 v52, v3, 12, s63
		s_add_i32 s63, s33, s62
		v_lshl_add_u32 v53, v3, 12, s63
		s_add_i32 s63, s44, s62
		v_lshl_add_u32 v54, v3, 12, s63
		s_and_saveexec_b64 s[64:65], s[6:7]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_8
		s_add_i32 m0, s61, 0x20000
		s_nop 0
		buffer_load_dwordx4 v6, s[40:43], 0 offen lds
		s_add_i32 m0, s61, 0x20010
		s_nop 0
		buffer_load_dwordx4 v52, s[40:43], 0 offen lds
		s_add_i32 m0, s61, 0x20020
		s_nop 0
		buffer_load_dwordx4 v53, s[40:43], 0 offen lds
		s_add_i32 m0, s61, 0x20030
		s_nop 0
		buffer_load_dwordx4 v54, s[40:43], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_8:
		s_andn2_b64 exec, s[64:65], s[6:7]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_8
.Lwmma_f16_matmul_tiled.exec_endif_8:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s29, s5, s29
		s_add_i32 s63, s45, s62
		v_lshl_add_u32 v6, v3, 12, s63
		s_add_i32 s63, s46, s62
		v_lshl_add_u32 v52, v3, 12, s63
		s_add_i32 s63, s47, s62
		v_lshl_add_u32 v53, v3, 12, s63
		s_add_i32 s63, s48, s62
		v_lshl_add_u32 v54, v3, 12, s63
		s_add_i32 s63, s49, s62
		v_lshl_add_u32 v55, v3, 12, s63
		s_add_i32 s63, s50, s62
		v_lshl_add_u32 v56, v3, 12, s63
		s_add_i32 s63, s51, s62
		v_lshl_add_u32 v57, v3, 12, s63
		s_add_i32 s63, s52, s62
		v_lshl_add_u32 v58, v3, 12, s63
		s_and_saveexec_b64 s[64:65], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_9
		s_add_i32 m0, s29, 0x20800
		s_nop 0
		buffer_load_dwordx4 v6, s[36:39], 0 offen lds
		s_add_i32 m0, s29, 0x20810
		s_nop 0
		buffer_load_dwordx4 v52, s[36:39], 0 offen lds
		s_add_i32 m0, s29, 0x20820
		s_nop 0
		buffer_load_dwordx4 v53, s[36:39], 0 offen lds
		s_add_i32 m0, s29, 0x20830
		s_nop 0
		buffer_load_dwordx4 v54, s[36:39], 0 offen lds
		s_add_i32 m0, s29, 0x20a00
		s_nop 0
		buffer_load_dwordx4 v55, s[36:39], 0 offen lds
		s_add_i32 m0, s29, 0x20a10
		s_nop 0
		buffer_load_dwordx4 v56, s[36:39], 0 offen lds
		s_add_i32 m0, s29, 0x20a20
		s_nop 0
		buffer_load_dwordx4 v57, s[36:39], 0 offen lds
		s_add_i32 m0, s29, 0x20a30
		s_nop 0
		buffer_load_dwordx4 v58, s[36:39], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_9:
		s_andn2_b64 exec, s[64:65], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_9
.Lwmma_f16_matmul_tiled.exec_endif_9:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s63, s53, s62
		v_lshl_add_u32 v6, v3, 12, s63
		s_add_i32 s63, s54, s62
		v_lshl_add_u32 v52, v3, 12, s63
		s_add_i32 s63, s55, s62
		v_lshl_add_u32 v53, v3, 12, s63
		s_add_i32 s63, s1, s62
		v_lshl_add_u32 v54, v3, 12, s63
		s_and_saveexec_b64 s[64:65], s[6:7]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_10
		s_add_i32 m0, s61, 0x21000
		s_nop 0
		buffer_load_dwordx4 v6, s[40:43], 0 offen lds
		s_add_i32 m0, s61, 0x21010
		s_nop 0
		buffer_load_dwordx4 v52, s[40:43], 0 offen lds
		s_add_i32 m0, s61, 0x21020
		s_nop 0
		buffer_load_dwordx4 v53, s[40:43], 0 offen lds
		s_add_i32 m0, s61, 0x21030
		s_nop 0
		buffer_load_dwordx4 v54, s[40:43], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_10:
		s_andn2_b64 exec, s[64:65], s[6:7]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_10
.Lwmma_f16_matmul_tiled.exec_endif_10:
		s_mov_b64 exec, s[64:65]
		s_add_i32 s61, s2, s62
		v_lshl_add_u32 v6, v3, 12, s61
		s_add_i32 s61, s4, s62
		v_lshl_add_u32 v52, v3, 12, s61
		s_add_i32 s61, s56, s62
		v_lshl_add_u32 v53, v3, 12, s61
		s_add_i32 s61, s57, s62
		v_lshl_add_u32 v54, v3, 12, s61
		s_add_i32 s61, s58, s62
		v_lshl_add_u32 v55, v3, 12, s61
		s_add_i32 s61, s59, s62
		v_lshl_add_u32 v56, v3, 12, s61
		s_add_i32 s61, s60, s62
		v_lshl_add_u32 v57, v3, 12, s61
		s_add_i32 s61, s0, s62
		v_lshl_add_u32 v58, v3, 12, s61
		s_and_saveexec_b64 s[64:65], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_11
		s_add_i32 m0, s29, 0x21800
		s_nop 0
		buffer_load_dwordx4 v6, s[36:39], 0 offen lds
		s_add_i32 m0, s29, 0x21810
		s_nop 0
		buffer_load_dwordx4 v52, s[36:39], 0 offen lds
		s_add_i32 m0, s29, 0x21820
		s_nop 0
		buffer_load_dwordx4 v53, s[36:39], 0 offen lds
		s_add_i32 m0, s29, 0x21830
		s_nop 0
		buffer_load_dwordx4 v54, s[36:39], 0 offen lds
		s_add_i32 m0, s29, 0x21a00
		s_nop 0
		buffer_load_dwordx4 v55, s[36:39], 0 offen lds
		s_add_i32 m0, s29, 0x21a10
		s_nop 0
		buffer_load_dwordx4 v56, s[36:39], 0 offen lds
		s_add_i32 m0, s29, 0x21a20
		s_nop 0
		buffer_load_dwordx4 v57, s[36:39], 0 offen lds
		s_add_i32 m0, s29, 0x21a30
		s_nop 0
		buffer_load_dwordx4 v58, s[36:39], 0 offen lds
.Lwmma_f16_matmul_tiled.exec_else_11:
		s_andn2_b64 exec, s[64:65], s[34:35]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_11
.Lwmma_f16_matmul_tiled.exec_endif_11:
		s_mov_b64 exec, s[64:65]
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[20:23], v[68:71], v[132:135], v244, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[20:23], v[72:75], v[136:139], v244, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[20:23], v[76:79], v[140:143], v244, v250 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[20:23], v[80:83], v[144:147], v244, v250 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[24:27], v[68:71], v[164:167], v244, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[24:27], v[72:75], v[168:171], v244, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[24:27], v[76:79], v[172:175], v244, v250 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[24:27], v[80:83], v[176:179], v244, v250 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], v[68:71], v[196:199], v244, v250 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[28:31], v[72:75], v[200:203], v244, v250 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[28:31], v[76:79], v[204:207], v244, v250 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[28:31], v[80:83], v[208:211], v244, v250 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], v[68:71], v[228:231], v244, v250 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[32:35], v[72:75], v[232:235], v244, v250 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[32:35], v[76:79], v[236:239], v244, v250 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[32:35], v[80:83], v[240:243], v244, v250 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[36:39], v[100:103], v[132:135], v246, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[36:39], v[104:107], v[136:139], v246, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[36:39], v[108:111], v[140:143], v246, v254 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[36:39], v[112:115], v[144:147], v246, v254 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[40:43], v[100:103], v[164:167], v246, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[40:43], v[104:107], v[168:171], v246, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[40:43], v[108:111], v[172:175], v246, v254 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[40:43], v[112:115], v[176:179], v246, v254 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[44:47], v[100:103], v[196:199], v246, v254 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[44:47], v[104:107], v[200:203], v246, v254 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[44:47], v[108:111], v[204:207], v246, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[44:47], v[112:115], v[208:211], v246, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[48:51], v[100:103], v[228:231], v246, v254 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s13
		s_nop 0
		buffer_load_dwordx4 v16, s[16:19], s12 offen lds
		s_mov_b32 m0, s14
		s_nop 0
		buffer_load_dwordx4 v18, s[16:19], s12 offen lds
		s_mov_b32 m0, s15
		s_nop 0
		buffer_load_dwordx4 v116, s[16:19], s12 offen lds
		s_mov_b32 m0, s24
		s_nop 0
		buffer_load_dwordx4 v118, s[16:19], s12 offen lds
		s_mov_b32 m0, s25
		s_nop 0
		buffer_load_dwordx4 v17, s[20:23], s12 offen lds
		s_mov_b32 m0, s26
		s_nop 0
		buffer_load_dwordx4 v19, s[20:23], s12 offen lds
		s_mov_b32 m0, s27
		s_nop 0
		buffer_load_dwordx4 v117, s[20:23], s12 offen lds
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v5, s[20:23], s12 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[48:51], v[104:107], v[232:235], v246, v254 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[48:51], v[108:111], v[236:239], v246, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[48:51], v[112:115], v[240:243], v246, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(8)
		s_barrier
		s_add_i32 s3, s3, 1
		s_and_b32 s12, s3, 1
		s_lshl_b32 s12, s12, 16
		v_add_u32_e32 v6, s12, v13
		v_add3_u32 v6, v6, v4, v7
		ds_read_b128 v[20:23], v6
		ds_read_b128 v[24:27], v6 offset:1024
		ds_read_b128 v[28:31], v6 offset:2048
		ds_read_b128 v[32:35], v6 offset:3072
		ds_read_b128 v[36:39], v6 offset:16384
		ds_read_b128 v[40:43], v6 offset:17408
		ds_read_b128 v[44:47], v6 offset:18432
		ds_read_b128 v[48:51], v6 offset:19456
		v_add_u32_e32 v6, s12, v4
		v_add3_u32 v6, v6, v14, v7
		ds_read_b128 v[52:55], v6 offset:32768
		ds_read_b128 v[56:59], v6 offset:33792
		ds_read_b128 v[60:63], v6 offset:34816
		ds_read_b128 v[64:67], v6 offset:35840
		ds_read_b128 v[68:71], v6 offset:36864
		ds_read_b128 v[72:75], v6 offset:37888
		ds_read_b128 v[76:79], v6 offset:38912
		ds_read_b128 v[80:83], v6 offset:39936
		ds_read_b128 v[84:87], v6 offset:49152
		ds_read_b128 v[88:91], v6 offset:50176
		ds_read_b128 v[92:95], v6 offset:51200
		ds_read_b128 v[96:99], v6 offset:52224
		ds_read_b128 v[100:103], v6 offset:53248
		ds_read_b128 v[104:107], v6 offset:54272
		ds_read_b128 v[108:111], v6 offset:55296
		ds_read_b128 v[112:115], v6 offset:56320
		s_add_i32 s12, s13, 0x10000
		s_and_b32 s13, s12, 0x1ffff
		s_add_i32 s12, s14, 0x10000
		s_and_b32 s14, s12, 0x1ffff
		s_add_i32 s12, s15, 0x10000
		s_and_b32 s15, s12, 0x1ffff
		s_add_i32 s12, s24, 0x10000
		s_and_b32 s24, s12, 0x1ffff
		s_add_i32 s12, s25, 0x10000
		s_and_b32 s25, s12, 0x1ffff
		s_add_i32 s12, s26, 0x10000
		s_and_b32 s26, s12, 0x1ffff
		s_add_i32 s12, s27, 0x10000
		s_and_b32 s27, s12, 0x1ffff
		s_add_i32 s12, s28, 0x10000
		s_and_b32 s28, s12, 0x1ffff
		s_cmp_lt_i32 s3, 30
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt vmcnt(8)
		s_barrier
		v_add_u32_e32 v0, 0x20000, v0
		v_add_u32_e32 v0, v0, v2
		ds_read_b64_tr_b8 v[16:17], v0
		v_add_u32_e32 v3, 0x20000, v2
		v_lshl_add_u32 v3, v12, 10, v3
		ds_read_b64_tr_b8 v[18:19], v3 offset:2048
		ds_read_b64_tr_b8 v[116:117], v3 offset:2560
		ds_read_b64_tr_b8 v[118:119], v0 offset:4096
		ds_read_b64_tr_b8 v[244:245], v3 offset:6144
		ds_read_b64_tr_b8 v[246:247], v3 offset:6656
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[20:23], v[52:55], v[8:11], v16, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], v[56:59], v[120:123], v16, v18 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], v[60:63], v[124:127], v16, v18 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[20:23], v[64:67], v[128:131], v16, v18 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[20:23], v[68:71], v[132:135], v16, v116 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[20:23], v[72:75], v[136:139], v16, v116 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[20:23], v[76:79], v[140:143], v16, v116 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[20:23], v[80:83], v[144:147], v16, v116 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[52:55], v[148:151], v16, v18 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[56:59], v[152:155], v16, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[60:63], v[156:159], v16, v18 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[24:27], v[64:67], v[160:163], v16, v18 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[24:27], v[68:71], v[164:167], v16, v116 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[24:27], v[72:75], v[168:171], v16, v116 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[24:27], v[76:79], v[172:175], v16, v116 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[24:27], v[80:83], v[176:179], v16, v116 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[52:55], v[180:183], v16, v18 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[56:59], v[184:187], v16, v18 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[60:63], v[188:191], v16, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[28:31], v[64:67], v[192:195], v16, v18 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], v[68:71], v[196:199], v16, v116 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[28:31], v[72:75], v[200:203], v16, v116 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[28:31], v[76:79], v[204:207], v16, v116 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[28:31], v[80:83], v[208:211], v16, v116 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[52:55], v[212:215], v16, v18 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[56:59], v[216:219], v16, v18 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], v[60:63], v[220:223], v16, v18 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[32:35], v[64:67], v[224:227], v16, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], v[68:71], v[228:231], v16, v116 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[32:35], v[72:75], v[232:235], v16, v116 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[32:35], v[76:79], v[236:239], v16, v116 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[32:35], v[80:83], v[240:243], v16, v116 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[36:39], v[84:87], v[8:11], v118, v244 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[36:39], v[88:91], v[120:123], v118, v244 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[36:39], v[92:95], v[124:127], v118, v244 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[36:39], v[96:99], v[128:131], v118, v244 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[36:39], v[100:103], v[132:135], v118, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[36:39], v[104:107], v[136:139], v118, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[36:39], v[108:111], v[140:143], v118, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[36:39], v[112:115], v[144:147], v118, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[40:43], v[84:87], v[148:151], v118, v244 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[40:43], v[88:91], v[152:155], v118, v244 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[40:43], v[92:95], v[156:159], v118, v244 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[40:43], v[96:99], v[160:163], v118, v244 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[40:43], v[100:103], v[164:167], v118, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[40:43], v[104:107], v[168:171], v118, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[40:43], v[108:111], v[172:175], v118, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[40:43], v[112:115], v[176:179], v118, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[44:47], v[84:87], v[180:183], v118, v244 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[44:47], v[88:91], v[184:187], v118, v244 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[44:47], v[92:95], v[188:191], v118, v244 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[44:47], v[96:99], v[192:195], v118, v244 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[44:47], v[100:103], v[196:199], v118, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[44:47], v[104:107], v[200:203], v118, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[44:47], v[108:111], v[204:207], v118, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[44:47], v[112:115], v[208:211], v118, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[48:51], v[84:87], v[212:215], v118, v244 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[48:51], v[88:91], v[216:219], v118, v244 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[48:51], v[92:95], v[220:223], v118, v244 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[48:51], v[96:99], v[224:227], v118, v244 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[48:51], v[100:103], v[228:231], v118, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[48:51], v[104:107], v[232:235], v118, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[48:51], v[108:111], v[236:239], v118, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[48:51], v[112:115], v[240:243], v118, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		v_add_u32_e32 v5, 0x10000, v13
		v_add3_u32 v5, v5, v4, v7
		ds_read_b128 v[16:19], v5
		ds_read_b128 v[20:23], v5 offset:1024
		ds_read_b128 v[24:27], v5 offset:2048
		ds_read_b128 v[28:31], v5 offset:3072
		ds_read_b128 v[32:35], v5 offset:16384
		ds_read_b128 v[36:39], v5 offset:17408
		ds_read_b128 v[40:43], v5 offset:18432
		ds_read_b128 v[44:47], v5 offset:19456
		v_add_u32_e32 v4, 0x10000, v4
		v_add3_u32 v4, v4, v14, v7
		ds_read_b128 v[12:15], v4 offset:32768
		ds_read_b128 v[48:51], v4 offset:33792
		ds_read_b128 v[52:55], v4 offset:34816
		ds_read_b128 v[56:59], v4 offset:35840
		ds_read_b128 v[60:63], v4 offset:36864
		ds_read_b128 v[64:67], v4 offset:37888
		ds_read_b128 v[68:71], v4 offset:38912
		ds_read_b128 v[72:75], v4 offset:39936
		ds_read_b128 v[76:79], v4 offset:49152
		ds_read_b128 v[80:83], v4 offset:50176
		ds_read_b128 v[84:87], v4 offset:51200
		ds_read_b128 v[88:91], v4 offset:52224
		ds_read_b128 v[92:95], v4 offset:53248
		ds_read_b128 v[96:99], v4 offset:54272
		ds_read_b128 v[100:103], v4 offset:55296
		ds_read_b128 v[104:107], v4 offset:56320
		s_barrier
		ds_read_b64_tr_b8 v[4:5], v0 offset:8192
		ds_read_b64_tr_b8 v[6:7], v3 offset:10240
		ds_read_b64_tr_b8 v[108:109], v3 offset:10752
		ds_read_b64_tr_b8 v[110:111], v0 offset:12288
		ds_read_b64_tr_b8 v[112:113], v3 offset:14336
		ds_read_b64_tr_b8 v[114:115], v3 offset:14848
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[16:19], v[12:15], v[8:11], v4, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[16:19], v[48:51], v[120:123], v4, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[52:55], v[124:127], v4, v6 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[56:59], v[128:131], v4, v6 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], v[12:15], v[148:151], v4, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[48:51], v[152:155], v4, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[52:55], v[156:159], v4, v6 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[56:59], v[160:163], v4, v6 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[12:15], v[180:183], v4, v6 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[48:51], v[184:187], v4, v6 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[52:55], v[188:191], v4, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[56:59], v[192:195], v4, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[12:15], v[212:215], v4, v6 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[28:31], v[48:51], v[216:219], v4, v6 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[28:31], v[52:55], v[220:223], v4, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[56:59], v[224:227], v4, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[32:35], v[76:79], v[8:11], v110, v112 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[32:35], v[80:83], v[120:123], v110, v112 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], v[84:87], v[124:127], v110, v112 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[32:35], v[88:91], v[128:131], v110, v112 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[36:39], v[76:79], v[148:151], v110, v112 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[36:39], v[80:83], v[152:155], v110, v112 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[36:39], v[84:87], v[156:159], v110, v112 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[36:39], v[88:91], v[160:163], v110, v112 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[40:43], v[76:79], v[180:183], v110, v112 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[40:43], v[80:83], v[184:187], v110, v112 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[40:43], v[84:87], v[188:191], v110, v112 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[40:43], v[88:91], v[192:195], v110, v112 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[44:47], v[76:79], v[212:215], v110, v112 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[44:47], v[80:83], v[216:219], v110, v112 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[44:47], v[84:87], v[220:223], v110, v112 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[44:47], v[88:91], v[224:227], v110, v112 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_cvt_pk_f16_f32 v6, v8, v9
		v_cvt_pk_f16_f32 v7, v10, v11
		v_lshl_add_u32 v0, v1, 14, v2
		buffer_store_dwordx2 v[6:7], v0, s[8:11], 0 offen
		v_cvt_pk_f16_f32 v2, v120, v121
		v_cvt_pk_f16_f32 v3, v122, v123
		buffer_store_dwordx2 v[2:3], v0, s[8:11], 0 offen offset:512
		v_cvt_pk_f16_f32 v2, v124, v125
		v_cvt_pk_f16_f32 v3, v126, v127
		buffer_store_dwordx2 v[2:3], v0, s[8:11], 0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v128, v129
		v_cvt_pk_f16_f32 v3, v130, v131
		buffer_store_dwordx2 v[2:3], v0, s[8:11], 0 offen offset:1536
		v_cvt_pk_f16_f32 v2, v148, v149
		v_cvt_pk_f16_f32 v3, v150, v151
		s_mov_b32 s0, 0x1000
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s0 offen
		v_cvt_pk_f16_f32 v2, v152, v153
		v_cvt_pk_f16_f32 v3, v154, v155
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s0 offen offset:512
		v_cvt_pk_f16_f32 v2, v156, v157
		v_cvt_pk_f16_f32 v3, v158, v159
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v160, v161
		v_cvt_pk_f16_f32 v3, v162, v163
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s0 offen offset:1536
		v_cvt_pk_f16_f32 v2, v180, v181
		v_cvt_pk_f16_f32 v3, v182, v183
		s_mov_b32 s1, 0x2000
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s1 offen
		v_cvt_pk_f16_f32 v2, v184, v185
		v_cvt_pk_f16_f32 v3, v186, v187
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s1 offen offset:512
		v_cvt_pk_f16_f32 v2, v188, v189
		v_cvt_pk_f16_f32 v3, v190, v191
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s1 offen offset:1024
		v_cvt_pk_f16_f32 v2, v192, v193
		v_cvt_pk_f16_f32 v3, v194, v195
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s1 offen offset:1536
		v_cvt_pk_f16_f32 v2, v212, v213
		v_cvt_pk_f16_f32 v3, v214, v215
		s_mov_b32 s2, 0x3000
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s2 offen
		v_cvt_pk_f16_f32 v2, v216, v217
		v_cvt_pk_f16_f32 v3, v218, v219
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s2 offen offset:512
		v_cvt_pk_f16_f32 v2, v220, v221
		v_cvt_pk_f16_f32 v3, v222, v223
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s2 offen offset:1024
		v_cvt_pk_f16_f32 v2, v224, v225
		v_cvt_pk_f16_f32 v3, v226, v227
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s2 offen offset:1536
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[16:19], v[60:63], v[132:135], v4, v108 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[64:67], v[136:139], v4, v108 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[16:19], v[68:71], v[140:143], v4, v108 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[16:19], v[72:75], v[144:147], v4, v108 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[60:63], v[164:167], v4, v108 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[64:67], v[168:171], v4, v108 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[68:71], v[172:175], v4, v108 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[20:23], v[72:75], v[176:179], v4, v108 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[60:63], v[196:199], v4, v108 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[64:67], v[200:203], v4, v108 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[68:71], v[204:207], v4, v108 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], v[72:75], v[208:211], v4, v108 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], v[60:63], v[228:231], v4, v108 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[28:31], v[64:67], v[232:235], v4, v108 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[28:31], v[68:71], v[236:239], v4, v108 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[28:31], v[72:75], v[240:243], v4, v108 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], v[92:95], v[132:135], v110, v114 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[32:35], v[96:99], v[136:139], v110, v114 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[32:35], v[100:103], v[140:143], v110, v114 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[32:35], v[104:107], v[144:147], v110, v114 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], v[92:95], v[164:167], v110, v114 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], v[96:99], v[168:171], v110, v114 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[36:39], v[100:103], v[172:175], v110, v114 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[36:39], v[104:107], v[176:179], v110, v114 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[40:43], v[92:95], v[196:199], v110, v114 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[40:43], v[96:99], v[200:203], v110, v114 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[40:43], v[100:103], v[204:207], v110, v114 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[40:43], v[104:107], v[208:211], v110, v114 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[44:47], v[92:95], v[228:231], v110, v114 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[44:47], v[96:99], v[232:235], v110, v114 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[44:47], v[100:103], v[236:239], v110, v114 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[44:47], v[104:107], v[240:243], v110, v114 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v132, v133
		v_cvt_pk_f16_f32 v3, v134, v135
		buffer_store_dwordx2 v[2:3], v0, s[8:11], 0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v136, v137
		v_cvt_pk_f16_f32 v3, v138, v139
		buffer_store_dwordx2 v[2:3], v0, s[8:11], 0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v140, v141
		v_cvt_pk_f16_f32 v3, v142, v143
		buffer_store_dwordx2 v[2:3], v0, s[8:11], 0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v144, v145
		v_cvt_pk_f16_f32 v3, v146, v147
		buffer_store_dwordx2 v[2:3], v0, s[8:11], 0 offen offset:3584
		v_cvt_pk_f16_f32 v2, v164, v165
		v_cvt_pk_f16_f32 v3, v166, v167
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v168, v169
		v_cvt_pk_f16_f32 v3, v170, v171
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v172, v173
		v_cvt_pk_f16_f32 v3, v174, v175
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v176, v177
		v_cvt_pk_f16_f32 v3, v178, v179
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s0 offen offset:3584
		v_cvt_pk_f16_f32 v2, v196, v197
		v_cvt_pk_f16_f32 v3, v198, v199
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s1 offen offset:2048
		v_cvt_pk_f16_f32 v2, v200, v201
		v_cvt_pk_f16_f32 v3, v202, v203
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s1 offen offset:2560
		v_cvt_pk_f16_f32 v2, v204, v205
		v_cvt_pk_f16_f32 v3, v206, v207
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s1 offen offset:3072
		v_cvt_pk_f16_f32 v2, v208, v209
		v_cvt_pk_f16_f32 v3, v210, v211
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s1 offen offset:3584
		v_cvt_pk_f16_f32 v2, v228, v229
		v_cvt_pk_f16_f32 v3, v230, v231
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s2 offen offset:2048
		v_cvt_pk_f16_f32 v2, v232, v233
		v_cvt_pk_f16_f32 v3, v234, v235
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s2 offen offset:2560
		v_cvt_pk_f16_f32 v2, v236, v237
		v_cvt_pk_f16_f32 v3, v238, v239
		buffer_store_dwordx2 v[2:3], v0, s[8:11], s2 offen offset:3072
		v_cvt_pk_f16_f32 v2, v240, v241
		v_cvt_pk_f16_f32 v3, v242, v243
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
		.amdhsa_next_free_vgpr 256
		.amdhsa_next_free_sgpr 66
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
