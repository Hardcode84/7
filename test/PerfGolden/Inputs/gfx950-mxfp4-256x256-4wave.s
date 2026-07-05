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
		v_mov_b32_e32 v4, 12
		ds_write_b32 v4, v1
		v_mov_b32_e32 v5, 16
		ds_write_b32 v5, v1
		v_mov_b32_e32 v6, 20
		ds_write_b32 v6, v1
		v_mov_b32_e32 v7, 24
		ds_write_b32 v7, v1
		v_mov_b32_e32 v8, 28
		ds_write_b32 v8, v1
		v_mov_b32_e32 v9, 32
		ds_write_b32 v9, v1
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
		s_lshr_b32 s6, s6, 6
		s_lshl_b32 s7, s6, 10
		s_add_i32 s6, s7, 0x1000
		s_add_i32 s12, s7, 0x2000
		s_add_i32 s14, s7, 0x3000
		s_add_i32 s15, s7, 0x4000
		s_add_i32 s18, s7, 0x5000
		s_add_i32 s19, s7, 0x6000
		s_add_i32 s32, s7, 0x7000
		s_add_i32 s33, s7, 0x8000
		s_add_i32 s34, s7, 0x9000
		s_add_i32 s35, s7, 0xa000
		s_add_i32 s36, s7, 0xb000
		s_add_i32 s37, s7, 0xc000
		s_add_i32 s38, s7, 0xd000
		s_add_i32 s39, s7, 0xe000
		s_add_i32 s40, s7, 0xf000
		v_mov_b64_e32 v[12:13], 0
		v_mov_b64_e32 v[14:15], 0
		v_lshrrev_b32_e32 v10, 6, v0
		v_and_b32_e32 v11, 63, v0
		v_lshrrev_b32_e32 v16, 2, v11
		v_lshlrev_b32_e32 v16, 12, v16
		v_lshl_add_u32 v16, v10, 16, v16
		v_lshrrev_b32_e32 v17, 3, v11
		v_and_b32_e32 v17, 3, v17
		v_and_b32_e32 v18, 3, v11
		v_xor_b32_e32 v17, v17, v18
		v_lshl_add_u32 v16, v17, 4, v16
		s_lshl_b32 s41, s5, 22
		s_lshl_b32 s42, s4, 20
		s_add_i32 s43, s41, s42
		v_add_u32_e32 v17, s43, v16
		s_add_i32 m0, s7, 48
		s_nop 0
		buffer_load_dwordx4 v17, s[8:11], 0 offen lds
		s_add_i32 s43, s41, 0x40000
		s_add_i32 s43, s43, s42
		v_add_u32_e32 v18, s43, v16
		s_add_i32 m0, s7, 0x1030
		s_nop 0
		buffer_load_dwordx4 v18, s[8:11], 0 offen lds
		s_add_i32 s43, s41, 0x80000
		v_add_u32_e32 v18, s42, v16
		v_add_u32_e32 v19, s43, v18
		s_add_i32 m0, s7, 0x2030
		s_nop 0
		buffer_load_dwordx4 v19, s[8:11], 0 offen lds
		s_add_i32 s43, s41, 0xc0000
		v_add_u32_e32 v19, s43, v18
		s_add_i32 m0, s7, 0x3030
		s_nop 0
		buffer_load_dwordx4 v19, s[8:11], 0 offen lds
		v_add3_u32 v18, s41, 64, v18
		s_add_i32 m0, s7, 0x4030
		s_nop 0
		buffer_load_dwordx4 v18, s[8:11], 0 offen lds
		v_add_u32_e32 v18, s42, v16
		v_add_u32_e32 v18, s41, v18
		v_add_u32_e32 v19, 0x40040, v18
		s_add_i32 m0, s7, 0x5030
		s_nop 0
		buffer_load_dwordx4 v19, s[8:11], 0 offen lds
		v_add_u32_e32 v19, 0x80040, v18
		s_add_i32 m0, s7, 0x6030
		s_nop 0
		buffer_load_dwordx4 v19, s[8:11], 0 offen lds
		v_add_u32_e32 v18, 0xc0040, v18
		v_and_b32_e32 v19, 1, v10
		s_mov_b32 s43, 0
		v_cmp_eq_u32_e64 vcc, v19, s43
		s_mov_b64 s[44:45], vcc
		v_lshrrev_b32_e32 v19, 7, v0
		v_lshlrev_b32_e32 v20, 7, v19
		v_lshrrev_b32_e32 v21, 4, v11
		v_lshlrev_b32_e32 v22, 12, v21
		v_and_b32_e32 v23, 15, v0
		v_lshlrev_b32_e32 v24, 2, v23
		v_add3_u32 v20, v20, v22, v24
		v_lshlrev_b32_e32 v22, 10, v19
		v_add_u32_e32 v25, 0x20000, v22
		v_accvgpr_write_b32 a0, v25
		v_lshlrev_b32_e32 v25, 7, v21
		v_accvgpr_read_b32 v26, a0
		v_add3_u32 v26, v26, v25, v24
		s_add_i32 m0, s7, 0x7030
		s_nop 0
		buffer_load_dwordx4 v18, s[8:11], 0 offen lds
		s_lshl_b32 s46, s13, 20
		v_add_u32_e32 v18, s46, v16
		v_add_u32_e32 v27, s46, v16
		s_add_i32 m0, s7, 0x8030
		s_nop 0
		buffer_load_dwordx4 v18, s[0:3], 0 offen lds
		v_add_u32_e32 v28, 0x40000, v27
		v_add_u32_e32 v29, 0x80000, v27
		v_add_u32_e32 v27, 0xc0000, v27
		s_add_i32 m0, s7, 0x9030
		s_nop 0
		buffer_load_dwordx4 v28, s[0:3], 0 offen lds
		v_add3_u32 v28, s46, 64, v16
		v_add_u32_e32 v30, s46, v16
		s_add_i32 m0, s7, 0xa030
		s_nop 0
		buffer_load_dwordx4 v29, s[0:3], 0 offen lds
		v_add_u32_e32 v29, 0x40040, v30
		s_add_i32 m0, s7, 0xb030
		s_nop 0
		buffer_load_dwordx4 v27, s[0:3], 0 offen lds
		v_add_u32_e32 v27, 0x80040, v30
		v_add_u32_e32 v30, 0xc0040, v30
		s_add_i32 m0, s7, 0xc030
		s_nop 0
		buffer_load_dwordx4 v28, s[0:3], 0 offen lds
		s_add_i32 m0, s7, 0xd030
		s_nop 0
		buffer_load_dwordx4 v29, s[0:3], 0 offen lds
		s_add_i32 m0, s7, 0xe030
		s_nop 0
		buffer_load_dwordx4 v27, s[0:3], 0 offen lds
		s_lshl_b32 s5, s5, 10
		s_lshl_b32 s4, s4, 8
		s_add_i32 s47, s5, s4
		s_add_i32 m0, s7, 0xf030
		s_nop 0
		buffer_load_dwordx4 v30, s[0:3], 0 offen lds
		s_add_i32 s48, s5, 0x4000
		s_add_i32 s48, s48, s4
		s_and_saveexec_b64 s[56:57], s[44:45]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_0
		buffer_load_dword v27, v20, s[24:27], s47 offen
		buffer_load_dword v28, v20, s[24:27], s47 offen offset:64
		buffer_load_dword v29, v20, s[24:27], s48 offen
		buffer_load_dword v30, v20, s[24:27], s48 offen offset:64
		v_add_u32_e32 v31, 48, v26
		s_waitcnt vmcnt(0)
		ds_write_b32 v31, v27
		ds_write_b32 v31, v28 offset:512
		ds_write_b32 v31, v29 offset:4096
		ds_write_b32 v31, v30 offset:4608
.Lwmma_f16_matmul_tiled.exec_else_0:
		s_andn2_b64 exec, s[56:57], s[44:45]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_0
.Lwmma_f16_matmul_tiled.exec_endif_0:
		s_mov_b64 exec, s[56:57]
		v_lshrrev_b32_e32 v27, 1, v10
		v_cmp_eq_u32_e64 vcc, v27, s43
		s_mov_b64 s[48:49], vcc
		v_lshl_add_u32 v27, v21, 12, v24
		v_and_b32_e32 v28, 1, v10
		v_lshl_add_u32 v27, v28, 7, v27
		s_lshl_b32 s13, s13, 8
		s_add_i32 s47, s13, 0x4000
		v_add_u32_e32 v29, 0x20000, v25
		v_add_u32_e32 v29, v29, v24
		v_lshl_add_u32 v29, v28, 10, v29
		s_and_saveexec_b64 s[56:57], s[48:49]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_1
		buffer_load_dword v30, v27, s[20:23], s13 offen
		buffer_load_dword v31, v27, s[20:23], s13 offen offset:64
		buffer_load_dword v32, v27, s[20:23], s47 offen
		buffer_load_dword v33, v27, s[20:23], s47 offen offset:64
		v_add_u32_e32 v34, 48, v29
		s_waitcnt vmcnt(0)
		ds_write_b32 v34, v30 offset:2048
		ds_write_b32 v34, v31 offset:2560
		ds_write_b32 v34, v32 offset:6144
		ds_write_b32 v34, v33 offset:6656
.Lwmma_f16_matmul_tiled.exec_else_1:
		s_andn2_b64 exec, s[56:57], s[48:49]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_1
.Lwmma_f16_matmul_tiled.exec_endif_1:
		s_mov_b64 exec, s[56:57]
		s_add_i32 s47, s5, 0x8000
		s_add_i32 s47, s47, s4
		s_add_i32 s50, s5, 0xc000
		s_add_i32 s50, s50, s4
		s_and_saveexec_b64 s[56:57], s[44:45]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_2
		buffer_load_dword v30, v20, s[24:27], s47 offen
		buffer_load_dword v31, v20, s[24:27], s47 offen offset:64
		buffer_load_dword v32, v20, s[24:27], s50 offen
		buffer_load_dword v33, v20, s[24:27], s50 offen offset:64
		v_add_u32_e32 v26, 48, v26
		s_waitcnt vmcnt(0)
		ds_write_b32 v26, v30 offset:8192
		ds_write_b32 v26, v31 offset:8704
		ds_write_b32 v26, v32 offset:12288
		ds_write_b32 v26, v33 offset:12800
.Lwmma_f16_matmul_tiled.exec_else_2:
		s_andn2_b64 exec, s[56:57], s[44:45]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_2
.Lwmma_f16_matmul_tiled.exec_endif_2:
		s_mov_b64 exec, s[56:57]
		s_add_i32 s47, s13, 0x8000
		s_add_i32 s50, s13, 0xc000
		s_and_saveexec_b64 s[56:57], s[48:49]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_3
		buffer_load_dword v26, v27, s[20:23], s47 offen
		buffer_load_dword v30, v27, s[20:23], s47 offen offset:64
		buffer_load_dword v31, v27, s[20:23], s50 offen
		buffer_load_dword v32, v27, s[20:23], s50 offen offset:64
		v_add_u32_e32 v29, 48, v29
		s_waitcnt vmcnt(0)
		ds_write_b32 v29, v26 offset:10240
		ds_write_b32 v29, v30 offset:10752
		ds_write_b32 v29, v31 offset:14336
		ds_write_b32 v29, v32 offset:14848
.Lwmma_f16_matmul_tiled.exec_else_3:
		s_andn2_b64 exec, s[56:57], s[48:49]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_3
.Lwmma_f16_matmul_tiled.exec_endif_3:
		s_mov_b64 exec, s[56:57]
		v_mov_b32_e32 v26, 1
		s_and_saveexec_b64 s[50:51], s[16:17]
		s_waitcnt vmcnt(0)
		ds_add_rtn_u32 v29, v1, v26
		s_mov_b64 exec, s[50:51]
		s_add_i32 s47, s41, 0x80
		s_add_i32 s47, s47, s42
		v_add_u32_e32 v30, s47, v16
		s_add_i32 m0, s7, 0x10030
		s_nop 0
		buffer_load_dwordx4 v30, s[8:11], 0 offen lds
		s_add_i32 s47, s41, 0x40080
		s_add_i32 s47, s47, s42
		v_add_u32_e32 v30, s47, v16
		s_add_i32 m0, s7, 0x11030
		s_nop 0
		buffer_load_dwordx4 v30, s[8:11], 0 offen lds
		v_add_u32_e32 v30, s42, v16
		v_add_u32_e32 v30, s41, v30
		v_add_u32_e32 v31, 0x80080, v30
		s_add_i32 m0, s7, 0x12030
		s_nop 0
		buffer_load_dwordx4 v31, s[8:11], 0 offen lds
		v_add_u32_e32 v31, 0xc0080, v30
		s_add_i32 m0, s7, 0x13030
		s_nop 0
		buffer_load_dwordx4 v31, s[8:11], 0 offen lds
		v_add_u32_e32 v30, 0xc0, v30
		s_add_i32 m0, s7, 0x14030
		s_nop 0
		buffer_load_dwordx4 v30, s[8:11], 0 offen lds
		v_add_u32_e32 v30, s42, v16
		v_add_u32_e32 v30, s41, v30
		v_add_u32_e32 v31, 0x400c0, v30
		s_add_i32 m0, s7, 0x15030
		s_nop 0
		buffer_load_dwordx4 v31, s[8:11], 0 offen lds
		v_add_u32_e32 v31, 0x800c0, v30
		s_add_i32 m0, s7, 0x16030
		s_nop 0
		buffer_load_dwordx4 v31, s[8:11], 0 offen lds
		v_add_u32_e32 v30, 0xc00c0, v30
		v_add_u32_e32 v31, s46, v16
		v_add_u32_e32 v32, 0x80080, v31
		v_add_u32_e32 v33, 0xc0080, v31
		v_add_u32_e32 v31, 0xc0, v31
		v_add_u32_e32 v34, s46, v16
		v_add_u32_e32 v35, 0x400c0, v34
		v_add_u32_e32 v36, 0x800c0, v34
		v_add_u32_e32 v34, 0xc00c0, v34
		v_lshlrev_b32_e32 v19, 13, v19
		v_lshlrev_b32_e32 v37, 6, v23
		v_lshrrev_b32_e32 v23, 1, v23
		v_and_b32_e32 v23, 3, v23
		v_xor_b32_e32 v23, v21, v23
		v_lshlrev_b32_e32 v23, 4, v23
		v_add3_u32 v38, v19, v37, v23
		v_lshlrev_b32_e32 v39, 13, v28
		v_add3_u32 v40, v37, v39, v23
		v_add_u32_e32 v41, 0x100, v17
		s_add_i32 m0, s7, 0x17030
		s_nop 0
		buffer_load_dwordx4 v30, s[8:11], 0 offen lds
		s_add_i32 s41, s46, 0x80
		v_add_u32_e32 v30, s41, v16
		v_add_u32_e32 v42, 0x40100, v17
		s_add_i32 m0, s7, 0x18030
		s_nop 0
		buffer_load_dwordx4 v30, s[0:3], 0 offen lds
		s_add_i32 s41, s46, 0x40080
		v_add_u32_e32 v16, s41, v16
		v_add_u32_e32 v30, 0x80100, v17
		s_add_i32 m0, s7, 0x19030
		s_nop 0
		buffer_load_dwordx4 v16, s[0:3], 0 offen lds
		v_add_u32_e32 v16, 0xc0100, v17
		s_add_i32 m0, s7, 0x1a030
		s_nop 0
		buffer_load_dwordx4 v32, s[0:3], 0 offen lds
		v_add_u32_e32 v32, 0x140, v17
		s_add_i32 m0, s7, 0x1b030
		s_nop 0
		buffer_load_dwordx4 v33, s[0:3], 0 offen lds
		v_add_u32_e32 v33, 0x40140, v17
		v_add_u32_e32 v43, 0x80140, v17
		v_add_u32_e32 v44, 0xc0140, v17
		s_add_i32 m0, s7, 0x1c030
		s_nop 0
		buffer_load_dwordx4 v31, s[0:3], 0 offen lds
		v_add_u32_e32 v17, 0x100, v18
		s_add_i32 m0, s7, 0x1d030
		s_nop 0
		buffer_load_dwordx4 v35, s[0:3], 0 offen lds
		v_add_u32_e32 v31, 0x40100, v18
		v_add_u32_e32 v35, 0x80100, v18
		v_add_u32_e32 v45, 0xc0100, v18
		v_add_u32_e32 v46, 0x140, v18
		v_add_u32_e32 v47, 0x40140, v18
		v_add_u32_e32 v48, 0x80140, v18
		v_add_u32_e32 v49, 0xc0140, v18
		v_lshlrev_b32_e32 v18, 3, v11
		v_lshlrev_b32_e32 v50, 10, v28
		v_add_u32_e32 v51, v22, v25
		v_lshl_add_u32 v52, v21, 7, v24
		s_add_i32 m0, s7, 0x1e030
		s_nop 0
		buffer_load_dwordx4 v36, s[0:3], 0 offen lds
		s_add_i32 s41, s5, 0x10000
		s_add_i32 s41, s41, s4
		s_add_i32 s5, s5, 0x14000
		s_add_i32 m0, s7, 0x1f030
		s_nop 0
		buffer_load_dwordx4 v34, s[0:3], 0 offen lds
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s42, v29
		s_and_b32 s42, s42, -4
		s_add_i32 s42, s42, 4
		s_and_saveexec_b64 s[46:47], s[16:17]
.Lwmma_f16_matmul_tiled.loop_head_0:
		ds_read_b32 v29, v1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s50, v29
		s_xor_b32 s51, s42, -1
		s_add_i32 s51, s51, 1
		s_add_i32 s50, s50, s51
		s_cmp_ge_u32 s50, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_mov_b64 exec, s[46:47]
		v_add_u32_e32 v1, 48, v38
		ds_read_b128 a[4:7], v1
		ds_read_b128 a[8:11], v1 offset:1024
		ds_read_b128 a[12:15], v1 offset:2048
		ds_read_b128 a[16:19], v1 offset:3072
		ds_read_b128 a[20:23], v1 offset:4096
		ds_read_b128 a[24:27], v1 offset:5120
		ds_read_b128 a[28:31], v1 offset:6144
		ds_read_b128 a[32:35], v1 offset:7168
		ds_read_b128 a[36:39], v1 offset:16384
		ds_read_b128 a[40:43], v1 offset:17408
		ds_read_b128 a[44:47], v1 offset:18432
		ds_read_b128 a[48:51], v1 offset:19456
		ds_read_b128 a[52:55], v1 offset:20480
		ds_read_b128 a[56:59], v1 offset:21504
		ds_read_b128 a[60:63], v1 offset:22528
		ds_read_b128 a[64:67], v1 offset:23552
		v_add_u32_e32 v1, 48, v40
		ds_read_b128 a[68:71], v1 offset:32768
		ds_read_b128 a[72:75], v1 offset:33792
		ds_read_b128 a[76:79], v1 offset:34816
		ds_read_b128 a[80:83], v1 offset:35840
		ds_read_b128 a[84:87], v1 offset:36864
		ds_read_b128 a[88:91], v1 offset:37888
		ds_read_b128 a[92:95], v1 offset:38912
		ds_read_b128 a[96:99], v1 offset:39936
		ds_read_b128 a[100:103], v1 offset:49152
		ds_read_b128 a[104:107], v1 offset:50176
		ds_read_b128 a[108:111], v1 offset:51200
		ds_read_b128 a[112:115], v1 offset:52224
		ds_read_b128 a[116:119], v1 offset:53248
		ds_read_b128 a[120:123], v1 offset:54272
		ds_read_b128 a[124:127], v1 offset:55296
		ds_read_b128 a[128:131], v1 offset:56320
		s_add_i32 s4, s5, s4
		s_add_i32 s5, s13, 0x10000
		s_add_i32 s13, s13, 0x14000
		v_mov_b64_e32 v[56:57], 0
		v_mov_b64_e32 v[58:59], 0
		v_mov_b64_e32 v[60:61], 0
		v_mov_b64_e32 v[62:63], 0
		v_mov_b64_e32 v[64:65], 0
		v_mov_b64_e32 v[66:67], 0
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_mov_b64_e32 v[72:73], 0
		v_mov_b64_e32 v[74:75], 0
		v_mov_b64_e32 v[76:77], 0
		v_mov_b64_e32 v[78:79], 0
		v_mov_b64_e32 v[80:81], 0
		v_mov_b64_e32 v[82:83], 0
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_mov_b64_e32 v[104:105], 0
		v_mov_b64_e32 v[106:107], 0
		v_mov_b64_e32 v[108:109], 0
		v_mov_b64_e32 v[110:111], 0
		v_mov_b64_e32 v[112:113], 0
		v_mov_b64_e32 v[114:115], 0
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
		v_accvgpr_write_b32 a132, 0
		v_accvgpr_write_b32 a133, 0
		v_accvgpr_write_b32 a134, 0
		v_accvgpr_write_b32 a135, 0
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
		v_accvgpr_write_b32 a136, 0
		v_accvgpr_write_b32 a137, 0
		v_accvgpr_write_b32 a138, 0
		v_accvgpr_write_b32 a139, 0
		v_mov_b64_e32 v[192:193], 0
		v_mov_b64_e32 v[194:195], 0
		v_accvgpr_write_b32 a140, 0
		v_accvgpr_write_b32 a141, 0
		v_accvgpr_write_b32 a142, 0
		v_accvgpr_write_b32 a143, 0
		v_mov_b64_e32 v[192:193], 0
		v_mov_b64_e32 v[194:195], 0
		v_accvgpr_write_b32 a144, 0
		v_accvgpr_write_b32 a145, 0
		v_accvgpr_write_b32 a146, 0
		v_accvgpr_write_b32 a147, 0
		v_mov_b64_e32 v[192:193], 0
		v_mov_b64_e32 v[194:195], 0
		v_accvgpr_write_b32 a148, 0
		v_accvgpr_write_b32 a149, 0
		v_accvgpr_write_b32 a150, 0
		v_accvgpr_write_b32 a151, 0
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
		v_accvgpr_write_b32 a152, 0
		v_accvgpr_write_b32 a153, 0
		v_accvgpr_write_b32 a154, 0
		v_accvgpr_write_b32 a155, 0
		v_mov_b64_e32 v[208:209], 0
		v_mov_b64_e32 v[210:211], 0
		v_accvgpr_write_b32 a156, 0
		v_accvgpr_write_b32 a157, 0
		v_accvgpr_write_b32 a158, 0
		v_accvgpr_write_b32 a159, 0
		v_mov_b64_e32 v[208:209], 0
		v_mov_b64_e32 v[210:211], 0
		v_accvgpr_write_b32 a160, 0
		v_accvgpr_write_b32 a161, 0
		v_accvgpr_write_b32 a162, 0
		v_accvgpr_write_b32 a163, 0
		v_mov_b64_e32 v[208:209], 0
		v_mov_b64_e32 v[210:211], 0
		v_accvgpr_write_b32 a164, 0
		v_accvgpr_write_b32 a165, 0
		v_accvgpr_write_b32 a166, 0
		v_accvgpr_write_b32 a167, 0
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
		v_accvgpr_write_b32 a168, 0
		v_accvgpr_write_b32 a169, 0
		v_accvgpr_write_b32 a170, 0
		v_accvgpr_write_b32 a171, 0
		v_mov_b64_e32 v[224:225], 0
		v_mov_b64_e32 v[226:227], 0
		v_accvgpr_write_b32 a172, 0
		v_accvgpr_write_b32 a173, 0
		v_accvgpr_write_b32 a174, 0
		v_accvgpr_write_b32 a175, 0
		v_mov_b64_e32 v[224:225], 0
		v_mov_b64_e32 v[226:227], 0
		v_accvgpr_write_b32 a176, 0
		v_accvgpr_write_b32 a177, 0
		v_accvgpr_write_b32 a178, 0
		v_accvgpr_write_b32 a179, 0
		v_mov_b64_e32 v[224:225], 0
		v_mov_b64_e32 v[226:227], 0
		v_accvgpr_write_b32 a180, 0
		v_accvgpr_write_b32 a181, 0
		v_accvgpr_write_b32 a182, 0
		v_accvgpr_write_b32 a183, 0
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
		v_accvgpr_write_b32 a184, 0
		v_accvgpr_write_b32 a185, 0
		v_accvgpr_write_b32 a186, 0
		v_accvgpr_write_b32 a187, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a188, 0
		v_accvgpr_write_b32 a189, 0
		v_accvgpr_write_b32 a190, 0
		v_accvgpr_write_b32 a191, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a192, 0
		v_accvgpr_write_b32 a193, 0
		v_accvgpr_write_b32 a194, 0
		v_accvgpr_write_b32 a195, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a196, 0
		v_accvgpr_write_b32 a197, 0
		v_accvgpr_write_b32 a198, 0
		v_accvgpr_write_b32 a199, 0
.Lwmma_f16_matmul_tiled.loop_head_1:
		s_and_saveexec_b64 s[46:47], s[16:17]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v1, v2, v26
		s_mov_b64 exec, s[46:47]
		s_and_b32 s42, s43, 1
		s_lshl_b32 s42, s42, 13
		s_add_i32 s46, s42, 0x20000
		v_add_u32_e32 v29, s46, v22
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s47, v1
		s_and_b32 s47, s47, -4
		s_add_i32 s47, s47, 4
		s_and_saveexec_b64 s[50:51], s[16:17]
.Lwmma_f16_matmul_tiled.loop_head_2:
		ds_read_b32 v1, v2
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s52, v1
		s_xor_b32 s53, s47, -1
		s_add_i32 s53, s53, 1
		s_add_i32 s52, s52, s53
		s_cmp_ge_u32 s52, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_2
.Lwmma_f16_matmul_tiled.loop_exit_2:
		s_mov_b64 exec, s[50:51]
		v_add_u32_e32 v1, v29, v18
		v_add_u32_e32 v1, 48, v1
		ds_read_b64_tr_b8 v[54:55], v1
		ds_read_b64_tr_b8 v[240:241], v1 offset:512
		s_waitcnt vmcnt(22)
		v_add3_u32 v34, s46, v18, v50
		v_add_u32_e32 v34, 48, v34
		s_waitcnt vmcnt(18)
		ds_read_b64_tr_b8 v[242:243], v34 offset:2048
		s_waitcnt vmcnt(17)
		ds_read_b64_tr_b8 v[244:245], v1 offset:4096
		s_waitcnt vmcnt(16)
		ds_read_b64_tr_b8 v[246:247], v1 offset:4608
		ds_read_b64_tr_b8 v[248:249], v34 offset:6144
		ds_read_b64_tr_b8 v[250:251], v34 offset:2560
		ds_read_b64_tr_b8 v[252:253], v34 offset:6656
		s_and_saveexec_b64 s[46:47], s[16:17]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v1, v3, v26
		s_mov_b64 exec, s[46:47]
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], a[4:7], a[68:71], v[12:15], v54, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[4:7], a[72:75], v[56:59], v54, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[4:7], a[76:79], v[60:63], v54, v242 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[4:7], a[80:83], v[64:67], v54, v242 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s46, v1
		s_and_b32 s46, s46, -4
		s_add_i32 s46, s46, 4
		s_and_saveexec_b64 s[50:51], s[16:17]
.Lwmma_f16_matmul_tiled.loop_head_3:
		ds_read_b32 v1, v3
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s47, v1
		s_xor_b32 s52, s46, -1
		s_add_i32 s52, s52, 1
		s_add_i32 s47, s47, s52
		s_cmp_ge_u32 s47, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_3
.Lwmma_f16_matmul_tiled.loop_exit_3:
		s_mov_b64 exec, s[50:51]
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[8:11], a[80:83], v[96:99], v54, v242 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[8:11], a[68:71], v[84:87], v54, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[8:11], a[72:75], v[88:91], v54, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[8:11], a[76:79], v[92:95], v54, v242 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[12:15], a[76:79], v[124:127], v54, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[12:15], a[68:71], v[116:119], v54, v242 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[12:15], a[72:75], v[120:123], v54, v242 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[12:15], a[80:83], v[128:131], v54, v242 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[16:19], a[80:83], v[160:163], v54, v242 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[16:19], a[68:71], v[148:151], v54, v242 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[16:19], a[72:75], v[152:155], v54, v242 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[16:19], a[76:79], v[156:159], v54, v242 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[20:23], a[68:71], v[176:179], v240, v242 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[20:23], a[72:75], v[180:183], v240, v242 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[20:23], a[76:79], v[184:187], v240, v242 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[20:23], a[80:83], v[188:191], v240, v242 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[24:27], a[80:83], v[204:207], v240, v242 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[24:27], a[68:71], v[192:195], v240, v242 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[24:27], a[72:75], v[196:199], v240, v242 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[24:27], a[76:79], v[200:203], v240, v242 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[28:31], a[76:79], v[216:219], v240, v242 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[28:31], a[68:71], v[208:211], v240, v242 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[28:31], a[72:75], v[212:215], v240, v242 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[28:31], a[80:83], v[220:223], v240, v242 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[32:35], a[80:83], v[236:239], v240, v242 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[32:35], a[68:71], v[224:227], v240, v242 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[32:35], a[72:75], v[228:231], v240, v242 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[32:35], a[76:79], v[232:235], v240, v242 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], a[36:39], a[100:103], v[12:15], v244, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[36:39], a[104:107], v[56:59], v244, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[36:39], a[108:111], v[60:63], v244, v248 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[36:39], a[112:115], v[64:67], v244, v248 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[40:43], a[112:115], v[96:99], v244, v248 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[40:43], a[100:103], v[84:87], v244, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[40:43], a[104:107], v[88:91], v244, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[40:43], a[108:111], v[92:95], v244, v248 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[44:47], a[108:111], v[124:127], v244, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[44:47], a[100:103], v[116:119], v244, v248 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[44:47], a[104:107], v[120:123], v244, v248 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[44:47], a[112:115], v[128:131], v244, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[48:51], a[112:115], v[160:163], v244, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[48:51], a[100:103], v[148:151], v244, v248 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[48:51], a[104:107], v[152:155], v244, v248 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[48:51], a[108:111], v[156:159], v244, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[52:55], a[100:103], v[176:179], v246, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[52:55], a[104:107], v[180:183], v246, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[52:55], a[108:111], v[184:187], v246, v248 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[52:55], a[112:115], v[188:191], v246, v248 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[56:59], a[112:115], v[204:207], v246, v248 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[56:59], a[100:103], v[192:195], v246, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[56:59], a[104:107], v[196:199], v246, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[56:59], a[108:111], v[200:203], v246, v248 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[60:63], a[108:111], v[216:219], v246, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[60:63], a[100:103], v[208:211], v246, v248 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[60:63], a[104:107], v[212:215], v246, v248 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[60:63], a[112:115], v[220:223], v246, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[64:67], a[112:115], v[236:239], v246, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[64:67], a[100:103], v[224:227], v246, v248 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[64:67], a[104:107], v[228:231], v246, v248 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[64:67], a[108:111], v[232:235], v246, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_lshl_b32 s46, s43, 15
		s_add_i32 s47, s41, s46
		s_add_i32 s50, s4, s46
		s_add_i32 s51, s42, 0x20200
		s_add_i32 s52, s42, 0x21000
		s_add_i32 s53, s42, 0x21200
		s_and_saveexec_b64 s[56:57], s[44:45]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_4
		buffer_load_dword v1, v20, s[24:27], s47 offen
		buffer_load_dword v34, v20, s[24:27], s47 offen offset:64
		buffer_load_dword v36, v20, s[24:27], s50 offen
		buffer_load_dword v38, v20, s[24:27], s50 offen offset:64
		v_add3_u32 v40, v29, v25, v24
		v_add3_u32 v53, v24, v51, s51
		v_add3_u32 v55, v24, v51, s52
		v_add3_u32 v241, v24, v51, s53
.Lwmma_f16_matmul_tiled.exec_endif_4:
		s_mov_b64 exec, s[56:57]
		s_add_i32 s47, s5, s46
		s_add_i32 s46, s13, s46
		s_add_i32 s50, s42, 0x20800
		v_lshl_add_u32 v29, v21, 7, s50
		s_add_i32 s50, s42, 0x20a00
		s_add_i32 s51, s42, 0x21800
		s_add_i32 s42, s42, 0x21a00
		s_and_saveexec_b64 s[56:57], s[48:49]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_5
		buffer_load_dword v242, v27, s[20:23], s47 offen
		buffer_load_dword v243, v27, s[20:23], s47 offen offset:64
		buffer_load_dword v245, v27, s[20:23], s46 offen
		buffer_load_dword v247, v27, s[20:23], s46 offen offset:64
		v_add3_u32 v248, v29, v24, v50
		v_add3_u32 v249, v50, v52, s50
		v_add3_u32 v254, v50, v52, s51
		v_add3_u32 v255, v50, v52, s42
.Lwmma_f16_matmul_tiled.exec_endif_5:
		s_mov_b64 exec, s[56:57]
		s_lshl_b32 s42, s43, 7
		s_add_i32 m0, s7, 48
		s_nop 0
		buffer_load_dwordx4 v41, s[8:11], s42 offen lds
		s_add_i32 s46, s36, 0x10000
		s_add_i32 m0, s6, 48
		s_nop 0
		buffer_load_dwordx4 v42, s[8:11], s42 offen lds
		s_add_i32 s47, s34, 0x10000
		s_add_i32 m0, s12, 48
		s_nop 0
		buffer_load_dwordx4 v30, s[8:11], s42 offen lds
		s_add_i32 s50, s39, 0x10000
		s_add_i32 m0, s14, 48
		s_nop 0
		buffer_load_dwordx4 v16, s[8:11], s42 offen lds
		s_add_i32 s51, s37, 0x10000
		s_add_i32 m0, s15, 48
		s_nop 0
		buffer_load_dwordx4 v32, s[8:11], s42 offen lds
		s_add_i32 s52, s35, 0x10000
		s_add_i32 m0, s18, 48
		s_nop 0
		buffer_load_dwordx4 v33, s[8:11], s42 offen lds
		s_add_i32 s53, s33, 0x10000
		s_add_i32 m0, s19, 48
		s_nop 0
		buffer_load_dwordx4 v43, s[8:11], s42 offen lds
		s_add_i32 s54, s32, 0x10000
		s_add_i32 s19, s19, 0x10000
		s_add_i32 s18, s18, 0x10000
		s_add_i32 s15, s15, 0x10000
		s_add_i32 s14, s14, 0x10000
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[4:7], a[84:87], v[68:71], v54, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[4:7], a[88:91], v[72:75], v54, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[4:7], a[92:95], v[76:79], v54, v250 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[4:7], a[96:99], v[80:83], v54, v250 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[8:11], a[96:99], v[112:115], v54, v250 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[8:11], a[84:87], v[100:103], v54, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[8:11], a[88:91], v[104:107], v54, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[8:11], a[92:95], v[108:111], v54, v250 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[12:15], a[92:95], v[140:143], v54, v250 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[12:15], a[84:87], v[132:135], v54, v250 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[12:15], a[88:91], v[136:139], v54, v250 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[12:15], a[96:99], v[144:147], v54, v250 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[16:19], a[96:99], a[132:135], v54, v250 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[16:19], a[84:87], v[164:167], v54, v250 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[16:19], a[88:91], v[168:171], v54, v250 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[16:19], a[92:95], v[172:175], v54, v250 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[20:23], a[92:95], a[144:147], v240, v250 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[20:23], a[84:87], a[136:139], v240, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[20:23], a[88:91], a[140:143], v240, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[20:23], a[96:99], a[148:151], v240, v250 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, s32, 48
		s_nop 0
		buffer_load_dwordx4 v44, s[8:11], s42 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[24:27], a[96:99], a[164:167], v240, v250 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, s33, 48
		s_nop 0
		buffer_load_dwordx4 v17, s[0:3], s42 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[24:27], a[84:87], a[152:155], v240, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s35, 48
		s_nop 0
		buffer_load_dwordx4 v35, s[0:3], s42 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[24:27], a[88:91], a[156:159], v240, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s37, 48
		s_nop 0
		buffer_load_dwordx4 v46, s[0:3], s42 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[24:27], a[92:95], a[160:163], v240, v250 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_add_i32 m0, s39, 48
		s_nop 0
		buffer_load_dwordx4 v48, s[0:3], s42 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[28:31], a[92:95], a[176:179], v240, v250 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[28:31], a[84:87], a[168:171], v240, v250 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[28:31], a[88:91], a[172:175], v240, v250 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[28:31], a[96:99], a[180:183], v240, v250 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[32:35], a[96:99], a[196:199], v240, v250 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[32:35], a[84:87], a[184:187], v240, v250 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[32:35], a[88:91], a[188:191], v240, v250 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[32:35], a[92:95], a[192:195], v240, v250 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[36:39], a[116:119], v[68:71], v244, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[36:39], a[120:123], v[72:75], v244, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[36:39], a[124:127], v[76:79], v244, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[36:39], a[128:131], v[80:83], v244, v252 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[40:43], a[128:131], v[112:115], v244, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[40:43], a[116:119], v[100:103], v244, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[40:43], a[120:123], v[104:107], v244, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[40:43], a[124:127], v[108:111], v244, v252 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[44:47], a[124:127], v[140:143], v244, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[44:47], a[116:119], v[132:135], v244, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[44:47], a[120:123], v[136:139], v244, v252 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[44:47], a[128:131], v[144:147], v244, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[48:51], a[128:131], a[132:135], v244, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[48:51], a[116:119], v[164:167], v244, v252 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[48:51], a[120:123], v[168:171], v244, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[48:51], a[124:127], v[172:175], v244, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[52:55], a[124:127], a[144:147], v246, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[52:55], a[116:119], a[136:139], v246, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[52:55], a[120:123], a[140:143], v246, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[52:55], a[128:131], a[148:151], v246, v252 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[56:59], a[128:131], a[164:167], v246, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[56:59], a[116:119], a[152:155], v246, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[56:59], a[120:123], a[156:159], v246, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[56:59], a[124:127], a[160:163], v246, v252 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[60:63], a[124:127], a[176:179], v246, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[60:63], a[116:119], a[168:171], v246, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[60:63], a[120:123], a[172:175], v246, v252 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[60:63], a[128:131], a[180:183], v246, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[64:67], a[128:131], a[196:199], v246, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[64:67], a[116:119], a[184:187], v246, v252 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[64:67], a[120:123], a[188:191], v246, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[64:67], a[124:127], a[192:195], v246, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_saveexec_b64 s[56:57], s[44:45]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_6
		v_add_u32_e32 v29, 48, v40
		s_waitcnt vmcnt(16)
		ds_write_b32 v29, v1
		v_add_u32_e32 v1, 48, v53
		ds_write_b32 v1, v34
		v_add_u32_e32 v1, 48, v55
		ds_write_b32 v1, v36
		v_add_u32_e32 v1, 48, v241
		ds_write_b32 v1, v38
.Lwmma_f16_matmul_tiled.exec_else_6:
		s_andn2_b64 exec, s[56:57], s[44:45]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_6
.Lwmma_f16_matmul_tiled.exec_endif_6:
		s_mov_b64 exec, s[56:57]
		s_and_saveexec_b64 s[56:57], s[48:49]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_7
		s_waitcnt vmcnt(19)
		v_add_u32_e32 v1, 48, v248
		s_waitcnt vmcnt(12)
		ds_write_b32 v1, v242
		v_add_u32_e32 v1, 48, v249
		ds_write_b32 v1, v243
		v_add_u32_e32 v1, 48, v254
		ds_write_b32 v1, v245
		v_add_u32_e32 v1, 48, v255
		ds_write_b32 v1, v247
.Lwmma_f16_matmul_tiled.exec_else_7:
		s_andn2_b64 exec, s[56:57], s[48:49]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_7
.Lwmma_f16_matmul_tiled.exec_endif_7:
		s_mov_b64 exec, s[56:57]
		s_and_saveexec_b64 s[32:33], s[16:17]
		s_waitcnt vmcnt(19)
		ds_add_rtn_u32 v1, v4, v26
		s_mov_b64 exec, s[32:33]
		s_add_i32 s12, s12, 0x10000
		s_add_i32 m0, s34, 48
		s_nop 0
		buffer_load_dwordx4 v31, s[0:3], s42 offen lds
		s_add_i32 s6, s6, 0x10000
		s_add_i32 m0, s36, 48
		s_nop 0
		buffer_load_dwordx4 v45, s[0:3], s42 offen lds
		s_add_i32 s7, s7, 0x10000
		s_add_i32 m0, s38, 48
		s_nop 0
		buffer_load_dwordx4 v47, s[0:3], s42 offen lds
		s_add_i32 s43, s43, 1
		s_add_i32 m0, s40, 48
		s_nop 0
		buffer_load_dwordx4 v49, s[0:3], s42 offen lds
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s32, v1
		s_and_b32 s32, s32, -4
		s_add_i32 s32, s32, 4
		s_and_saveexec_b64 s[34:35], s[16:17]
.Lwmma_f16_matmul_tiled.loop_head_4:
		ds_read_b32 v1, v4
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s33, v1
		s_xor_b32 s36, s32, -1
		s_add_i32 s36, s36, 1
		s_add_i32 s33, s33, s36
		s_cmp_ge_u32 s33, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_4
.Lwmma_f16_matmul_tiled.loop_exit_4:
		s_mov_b64 exec, s[34:35]
		s_and_b32 s32, s43, 1
		s_lshl_b32 s32, s32, 16
		v_add_u32_e32 v1, s32, v19
		v_add3_u32 v1, v1, v37, v23
		v_add_u32_e32 v1, 48, v1
		ds_read_b128 a[4:7], v1
		ds_read_b128 a[8:11], v1 offset:1024
		ds_read_b128 a[12:15], v1 offset:2048
		ds_read_b128 a[16:19], v1 offset:3072
		ds_read_b128 a[20:23], v1 offset:4096
		ds_read_b128 a[24:27], v1 offset:5120
		ds_read_b128 a[28:31], v1 offset:6144
		ds_read_b128 a[32:35], v1 offset:7168
		ds_read_b128 a[36:39], v1 offset:16384
		ds_read_b128 a[40:43], v1 offset:17408
		ds_read_b128 a[44:47], v1 offset:18432
		ds_read_b128 a[48:51], v1 offset:19456
		ds_read_b128 a[52:55], v1 offset:20480
		ds_read_b128 a[56:59], v1 offset:21504
		ds_read_b128 a[60:63], v1 offset:22528
		ds_read_b128 a[64:67], v1 offset:23552
		v_add_u32_e32 v1, s32, v37
		v_add3_u32 v1, v1, v39, v23
		v_add_u32_e32 v1, 48, v1
		ds_read_b128 a[68:71], v1 offset:32768
		ds_read_b128 a[72:75], v1 offset:33792
		ds_read_b128 a[76:79], v1 offset:34816
		ds_read_b128 a[80:83], v1 offset:35840
		ds_read_b128 a[84:87], v1 offset:36864
		ds_read_b128 a[88:91], v1 offset:37888
		ds_read_b128 a[92:95], v1 offset:38912
		ds_read_b128 a[96:99], v1 offset:39936
		ds_read_b128 a[100:103], v1 offset:49152
		ds_read_b128 a[104:107], v1 offset:50176
		ds_read_b128 a[108:111], v1 offset:51200
		ds_read_b128 a[112:115], v1 offset:52224
		ds_read_b128 a[116:119], v1 offset:53248
		ds_read_b128 a[120:123], v1 offset:54272
		ds_read_b128 a[124:127], v1 offset:55296
		ds_read_b128 a[128:131], v1 offset:56320
		s_and_b32 s7, s7, 0x1ffff
		s_and_b32 s6, s6, 0x1ffff
		s_and_b32 s12, s12, 0x1ffff
		s_and_b32 s14, s14, 0x1ffff
		s_and_b32 s15, s15, 0x1ffff
		s_and_b32 s18, s18, 0x1ffff
		s_and_b32 s19, s19, 0x1ffff
		s_and_b32 s32, s54, 0x1ffff
		s_and_b32 s33, s53, 0x1ffff
		s_and_b32 s35, s52, 0x1ffff
		s_and_b32 s37, s51, 0x1ffff
		s_and_b32 s39, s50, 0x1ffff
		s_and_b32 s34, s47, 0x1ffff
		s_and_b32 s36, s46, 0x1ffff
		s_add_i32 s38, s38, 0x10000
		s_and_b32 s38, s38, 0x1ffff
		s_add_i32 s40, s40, 0x10000
		s_and_b32 s40, s40, 0x1ffff
		s_cmp_lt_i32 s43, 30
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_1
.Lwmma_f16_matmul_tiled.loop_exit_1:
		s_and_saveexec_b64 s[0:1], s[16:17]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v1, v5, v26
		s_mov_b64 exec, s[0:1]
		s_and_saveexec_b64 s[0:1], s[16:17]
		s_waitcnt vmcnt(0)
		ds_add_rtn_u32 v2, v6, v26
		s_mov_b64 exec, s[0:1]
		v_accvgpr_read_b32 v3, a0
		v_add_u32_e32 v3, v3, v18
		v_add_u32_e32 v4, 0x20000, v18
		v_lshl_add_u32 v4, v28, 10, v4
		s_waitcnt lgkmcnt(1)
		v_readfirstlane_b32 s0, v1
		s_and_b32 s0, s0, -4
		s_add_i32 s0, s0, 4
		s_and_saveexec_b64 s[2:3], s[16:17]
.Lwmma_f16_matmul_tiled.loop_head_5:
		ds_read_b32 v1, v5
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v1
		s_xor_b32 s4, s0, -1
		s_add_i32 s4, s4, 1
		s_add_i32 s1, s1, s4
		s_cmp_ge_u32 s1, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_5
.Lwmma_f16_matmul_tiled.loop_exit_5:
		s_mov_b64 exec, s[2:3]
		v_add_u32_e32 v1, 48, v3
		ds_read_b64_tr_b8 v[16:17], v1
		ds_read_b64_tr_b8 v[20:21], v1 offset:512
		v_add_u32_e32 v3, 48, v4
		ds_read_b64_tr_b8 v[4:5], v3 offset:2048
		ds_read_b64_tr_b8 v[24:25], v3 offset:2560
		ds_read_b64_tr_b8 v[28:29], v1 offset:4096
		ds_read_b64_tr_b8 v[30:31], v1 offset:4608
		ds_read_b64_tr_b8 v[32:33], v3 offset:6144
		ds_read_b64_tr_b8 v[34:35], v3 offset:6656
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], a[4:7], a[68:71], v[12:15], v16, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[4:7], a[72:75], v[56:59], v16, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[4:7], a[76:79], v[60:63], v16, v4 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[4:7], a[80:83], v[64:67], v16, v4 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[4:7], a[84:87], v[68:71], v16, v24 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[4:7], a[88:91], v[72:75], v16, v24 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[4:7], a[92:95], v[76:79], v16, v24 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[4:7], a[96:99], v[80:83], v16, v24 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[8:11], a[96:99], v[112:115], v16, v24 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[8:11], a[84:87], v[100:103], v16, v24 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[8:11], a[88:91], v[104:107], v16, v24 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[8:11], a[92:95], v[108:111], v16, v24 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[12:15], a[92:95], v[140:143], v16, v24 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[12:15], a[84:87], v[132:135], v16, v24 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[12:15], a[88:91], v[136:139], v16, v24 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[12:15], a[96:99], v[144:147], v16, v24 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[16:19], a[96:99], a[132:135], v16, v24 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[16:19], a[84:87], v[164:167], v16, v24 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[16:19], a[88:91], v[168:171], v16, v24 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[16:19], a[92:95], v[172:175], v16, v24 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[16:19], a[68:71], v[148:151], v16, v4 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[8:11], a[68:71], v[84:87], v16, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[8:11], a[72:75], v[88:91], v16, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[8:11], a[76:79], v[92:95], v16, v4 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[8:11], a[80:83], v[96:99], v16, v4 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[12:15], a[80:83], v[128:131], v16, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[12:15], a[68:71], v[116:119], v16, v4 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[12:15], a[72:75], v[120:123], v16, v4 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[12:15], a[76:79], v[124:127], v16, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[16:19], a[76:79], v[156:159], v16, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[16:19], a[72:75], v[152:155], v16, v4 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[16:19], a[80:83], v[160:163], v16, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[20:23], a[68:71], v[176:179], v20, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[20:23], a[72:75], v[180:183], v20, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[20:23], a[76:79], v[184:187], v20, v4 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[20:23], a[80:83], v[188:191], v20, v4 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[24:27], a[80:83], v[204:207], v20, v4 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[24:27], a[68:71], v[192:195], v20, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[24:27], a[72:75], v[196:199], v20, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[24:27], a[76:79], v[200:203], v20, v4 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[28:31], a[76:79], v[216:219], v20, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[28:31], a[68:71], v[208:211], v20, v4 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[28:31], a[72:75], v[212:215], v20, v4 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[28:31], a[80:83], v[220:223], v20, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[32:35], a[80:83], v[236:239], v20, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[32:35], a[68:71], v[224:227], v20, v4 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[32:35], a[72:75], v[228:231], v20, v4 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[32:35], a[76:79], v[232:235], v20, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[32:35], a[84:87], a[184:187], v20, v24 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[20:23], a[84:87], a[136:139], v20, v24 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[20:23], a[88:91], a[140:143], v20, v24 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[20:23], a[92:95], a[144:147], v20, v24 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[20:23], a[96:99], a[148:151], v20, v24 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[24:27], a[96:99], a[164:167], v20, v24 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[24:27], a[84:87], a[152:155], v20, v24 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[24:27], a[88:91], a[156:159], v20, v24 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[24:27], a[92:95], a[160:163], v20, v24 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[28:31], a[92:95], a[176:179], v20, v24 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[28:31], a[84:87], a[168:171], v20, v24 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[28:31], a[88:91], a[172:175], v20, v24 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[28:31], a[96:99], a[180:183], v20, v24 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[32:35], a[96:99], a[196:199], v20, v24 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[32:35], a[88:91], a[188:191], v20, v24 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[32:35], a[92:95], a[192:195], v20, v24 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], a[36:39], a[100:103], v[12:15], v28, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[36:39], a[104:107], v[56:59], v28, v32 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[36:39], a[108:111], v[60:63], v28, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[36:39], a[112:115], v[64:67], v28, v32 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[36:39], a[116:119], v[68:71], v28, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[36:39], a[120:123], v[72:75], v28, v34 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[36:39], a[124:127], v[76:79], v28, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[36:39], a[128:131], v[80:83], v28, v34 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[40:43], a[128:131], v[112:115], v28, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[40:43], a[116:119], v[100:103], v28, v34 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[40:43], a[120:123], v[104:107], v28, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[40:43], a[124:127], v[108:111], v28, v34 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[44:47], a[124:127], v[140:143], v28, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[44:47], a[116:119], v[132:135], v28, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[44:47], a[120:123], v[136:139], v28, v34 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[44:47], a[128:131], v[144:147], v28, v34 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[48:51], a[128:131], a[132:135], v28, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[48:51], a[116:119], v[164:167], v28, v34 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[48:51], a[120:123], v[168:171], v28, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[48:51], a[124:127], v[172:175], v28, v34 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[48:51], a[100:103], v[148:151], v28, v32 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[40:43], a[100:103], v[84:87], v28, v32 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[40:43], a[104:107], v[88:91], v28, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[40:43], a[108:111], v[92:95], v28, v32 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[40:43], a[112:115], v[96:99], v28, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[44:47], a[112:115], v[128:131], v28, v32 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[44:47], a[100:103], v[116:119], v28, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[44:47], a[104:107], v[120:123], v28, v32 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[44:47], a[108:111], v[124:127], v28, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[48:51], a[108:111], v[156:159], v28, v32 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[48:51], a[104:107], v[152:155], v28, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[48:51], a[112:115], v[160:163], v28, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[52:55], a[100:103], v[176:179], v30, v32 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[52:55], a[104:107], v[180:183], v30, v32 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[52:55], a[108:111], v[184:187], v30, v32 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[52:55], a[112:115], v[188:191], v30, v32 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[56:59], a[112:115], v[204:207], v30, v32 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[56:59], a[100:103], v[192:195], v30, v32 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[56:59], a[104:107], v[196:199], v30, v32 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[56:59], a[108:111], v[200:203], v30, v32 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[60:63], a[108:111], v[216:219], v30, v32 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[60:63], a[100:103], v[208:211], v30, v32 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[60:63], a[104:107], v[212:215], v30, v32 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[60:63], a[112:115], v[220:223], v30, v32 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[64:67], a[112:115], v[236:239], v30, v32 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[64:67], a[100:103], v[224:227], v30, v32 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[64:67], a[104:107], v[228:231], v30, v32 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[64:67], a[108:111], v[232:235], v30, v32 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[64:67], a[116:119], a[184:187], v30, v34 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[52:55], a[116:119], a[136:139], v30, v34 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[52:55], a[120:123], a[140:143], v30, v34 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[52:55], a[124:127], a[144:147], v30, v34 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[52:55], a[128:131], a[148:151], v30, v34 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[56:59], a[128:131], a[164:167], v30, v34 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[56:59], a[116:119], a[152:155], v30, v34 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[56:59], a[120:123], a[156:159], v30, v34 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[56:59], a[124:127], a[160:163], v30, v34 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[60:63], a[124:127], a[176:179], v30, v34 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[60:63], a[116:119], a[168:171], v30, v34 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[60:63], a[120:123], a[172:175], v30, v34 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[60:63], a[128:131], a[180:183], v30, v34 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[64:67], a[128:131], a[196:199], v30, v34 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[64:67], a[120:123], a[188:191], v30, v34 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[64:67], a[124:127], a[192:195], v30, v34 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_readfirstlane_b32 s0, v2
		s_and_b32 s0, s0, -4
		s_add_i32 s0, s0, 4
		s_and_saveexec_b64 s[2:3], s[16:17]
.Lwmma_f16_matmul_tiled.loop_head_6:
		ds_read_b32 v2, v6
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v2
		s_xor_b32 s4, s0, -1
		s_add_i32 s4, s4, 1
		s_add_i32 s1, s1, s4
		s_cmp_ge_u32 s1, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_6
.Lwmma_f16_matmul_tiled.loop_exit_6:
		s_mov_b64 exec, s[2:3]
		v_add_u32_e32 v2, 0x10000, v19
		v_add3_u32 v2, v2, v37, v23
		v_add_u32_e32 v2, 48, v2
		ds_read_b128 v[28:31], v2
		ds_read_b128 v[32:35], v2 offset:1024
		ds_read_b128 a[0:3], v2 offset:2048
		ds_read_b128 a[4:7], v2 offset:3072
		ds_read_b128 a[8:11], v2 offset:4096
		ds_read_b128 a[12:15], v2 offset:5120
		ds_read_b128 a[16:19], v2 offset:6144
		ds_read_b128 a[20:23], v2 offset:7168
		ds_read_b128 a[24:27], v2 offset:16384
		ds_read_b128 a[28:31], v2 offset:17408
		ds_read_b128 a[32:35], v2 offset:18432
		ds_read_b128 a[36:39], v2 offset:19456
		ds_read_b128 a[40:43], v2 offset:20480
		ds_read_b128 a[44:47], v2 offset:21504
		ds_read_b128 a[48:51], v2 offset:22528
		ds_read_b128 a[52:55], v2 offset:23552
		v_add_u32_e32 v2, 0x10000, v37
		v_add3_u32 v2, v2, v39, v23
		v_add_u32_e32 v2, 48, v2
		ds_read_b128 v[20:23], v2 offset:32768
		ds_read_b128 v[36:39], v2 offset:33792
		ds_read_b128 v[40:43], v2 offset:34816
		ds_read_b128 v[44:47], v2 offset:35840
		ds_read_b128 a[56:59], v2 offset:36864
		ds_read_b128 a[60:63], v2 offset:37888
		ds_read_b128 a[64:67], v2 offset:38912
		ds_read_b128 a[68:71], v2 offset:39936
		ds_read_b128 v[48:51], v2 offset:49152
		ds_read_b128 v[52:55], v2 offset:50176
		ds_read_b128 v[240:243], v2 offset:51200
		ds_read_b128 v[244:247], v2 offset:52224
		ds_read_b128 a[72:75], v2 offset:53248
		ds_read_b128 a[76:79], v2 offset:54272
		ds_read_b128 a[80:83], v2 offset:55296
		ds_read_b128 a[84:87], v2 offset:56320
		s_and_saveexec_b64 s[0:1], s[16:17]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v2, v7, v26
		s_mov_b64 exec, s[0:1]
		v_lshlrev_b32_e32 v4, 15, v10
		v_add_u32_e32 v5, v4, v18
		v_and_b32_e32 v0, 63, v0
		s_mov_b32 s0, 32
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v2
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[16:17]
.Lwmma_f16_matmul_tiled.loop_head_7:
		ds_read_b32 v2, v7
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v2
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_7
.Lwmma_f16_matmul_tiled.loop_exit_7:
		s_mov_b64 exec, s[2:3]
		ds_read_b64_tr_b8 v[6:7], v1 offset:8192
		ds_read_b64_tr_b8 v[16:17], v1 offset:8704
		ds_read_b64_tr_b8 v[18:19], v3 offset:10240
		ds_read_b64_tr_b8 v[24:25], v3 offset:10752
		ds_read_b64_tr_b8 v[248:249], v1 offset:12288
		ds_read_b64_tr_b8 v[250:251], v1 offset:12800
		ds_read_b64_tr_b8 v[252:253], v3 offset:14336
		ds_read_b64_tr_b8 v[254:255], v3 offset:14848
		s_and_saveexec_b64 s[2:3], s[16:17]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v1, v8, v26
		s_mov_b64 exec, s[2:3]
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[28:31], v[20:23], v[12:15], v6, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], v[28:31], v[36:39], v[56:59], v6, v18 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[28:31], v[40:43], v[60:63], v6, v18 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], v[28:31], v[44:47], v[64:67], v6, v18 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[32:35], v[44:47], v[96:99], v6, v18 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[32:35], v[20:23], v[84:87], v6, v18 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[32:35], v[36:39], v[88:91], v6, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[32:35], v[40:43], v[92:95], v6, v18 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[0:3], v[40:43], v[124:127], v6, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[0:3], v[20:23], v[116:119], v6, v18 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[0:3], v[36:39], v[120:123], v6, v18 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[0:3], v[44:47], v[128:131], v6, v18 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[4:7], v[44:47], v[160:163], v6, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[4:7], v[20:23], v[148:151], v6, v18 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[4:7], v[36:39], v[152:155], v6, v18 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[4:7], v[40:43], v[156:159], v6, v18 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[8:11], v[20:23], v[176:179], v16, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[8:11], v[36:39], v[180:183], v16, v18 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[8:11], v[40:43], v[184:187], v16, v18 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[8:11], v[44:47], v[188:191], v16, v18 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[12:15], v[44:47], v[204:207], v16, v18 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[12:15], v[20:23], v[192:195], v16, v18 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[12:15], v[36:39], v[196:199], v16, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[12:15], v[40:43], v[200:203], v16, v18 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[16:19], v[40:43], v[216:219], v16, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[16:19], v[20:23], v[208:211], v16, v18 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[16:19], v[36:39], v[212:215], v16, v18 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[16:19], v[44:47], v[220:223], v16, v18 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[20:23], v[44:47], v[236:239], v16, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[20:23], v[20:23], v[224:227], v16, v18 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[20:23], v[36:39], v[228:231], v16, v18 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[20:23], v[40:43], v[232:235], v16, v18 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], a[24:27], v[48:51], v[12:15], v248, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[56:59], a[24:27], v[52:55], v[56:59], v248, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], a[24:27], v[240:243], v[60:63], v248, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[64:67], a[24:27], v[244:247], v[64:67], v248, v252 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[28:31], v[244:247], v[96:99], v248, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], a[28:31], v[48:51], v[84:87], v248, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], a[28:31], v[52:55], v[88:91], v248, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[28:31], v[240:243], v[92:95], v248, v252 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], a[32:35], v[240:243], v[124:127], v248, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], a[32:35], v[48:51], v[116:119], v248, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[32:35], v[52:55], v[120:123], v248, v252 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[32:35], v[244:247], v[128:131], v248, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[36:39], v[244:247], v[160:163], v248, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[36:39], v[48:51], v[148:151], v248, v252 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[36:39], v[52:55], v[152:155], v248, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[36:39], v[240:243], v[156:159], v248, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[40:43], v[48:51], v[176:179], v250, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[40:43], v[52:55], v[180:183], v250, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[40:43], v[240:243], v[184:187], v250, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[40:43], v[244:247], v[188:191], v250, v252 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], a[44:47], v[244:247], v[204:207], v250, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[44:47], v[48:51], v[192:195], v250, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], a[44:47], v[52:55], v[196:199], v250, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], a[44:47], v[240:243], v[200:203], v250, v252 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], a[48:51], v[240:243], v[216:219], v250, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], a[48:51], v[48:51], v[208:211], v250, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], a[48:51], v[52:55], v[212:215], v250, v252 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], a[48:51], v[244:247], v[220:223], v250, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], a[52:55], v[244:247], v[236:239], v250, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], a[52:55], v[48:51], v[224:227], v250, v252 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], a[52:55], v[52:55], v[228:231], v250, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], a[52:55], v[240:243], v[232:235], v250, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v1
		s_and_b32 s1, s1, -4
		s_add_i32 s1, s1, 4
		s_and_saveexec_b64 s[2:3], s[16:17]
.Lwmma_f16_matmul_tiled.loop_head_8:
		ds_read_b32 v1, v8
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v1
		s_xor_b32 s5, s1, -1
		s_add_i32 s5, s5, 1
		s_add_i32 s4, s4, s5
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_8
.Lwmma_f16_matmul_tiled.loop_exit_8:
		s_mov_b64 exec, s[2:3]
		v_cvt_pk_f16_f32 v2, v12, v13
		v_cvt_pk_f16_f32 v3, v14, v15
		v_add_u32_e32 v1, 48, v5
		ds_write_b64 v1, v[2:3]
		v_cvt_pk_f16_f32 v2, v56, v57
		v_cvt_pk_f16_f32 v3, v58, v59
		ds_write_b64 v1, v[2:3] offset:512
		v_cvt_pk_f16_f32 v2, v60, v61
		v_cvt_pk_f16_f32 v3, v62, v63
		ds_write_b64 v1, v[2:3] offset:1024
		v_cvt_pk_f16_f32 v2, v64, v65
		v_cvt_pk_f16_f32 v3, v66, v67
		ds_write_b64 v1, v[2:3] offset:1536
		v_cvt_pk_f16_f32 v2, v84, v85
		v_cvt_pk_f16_f32 v3, v86, v87
		ds_write_b64 v1, v[2:3] offset:4096
		v_cvt_pk_f16_f32 v2, v88, v89
		v_cvt_pk_f16_f32 v3, v90, v91
		ds_write_b64 v1, v[2:3] offset:4608
		v_cvt_pk_f16_f32 v2, v92, v93
		v_cvt_pk_f16_f32 v3, v94, v95
		ds_write_b64 v1, v[2:3] offset:5120
		v_cvt_pk_f16_f32 v2, v96, v97
		v_cvt_pk_f16_f32 v3, v98, v99
		ds_write_b64 v1, v[2:3] offset:5632
		v_cvt_pk_f16_f32 v2, v116, v117
		v_cvt_pk_f16_f32 v3, v118, v119
		ds_write_b64 v1, v[2:3] offset:8192
		v_cvt_pk_f16_f32 v2, v120, v121
		v_cvt_pk_f16_f32 v3, v122, v123
		ds_write_b64 v1, v[2:3] offset:8704
		v_cvt_pk_f16_f32 v2, v124, v125
		v_cvt_pk_f16_f32 v3, v126, v127
		ds_write_b64 v1, v[2:3] offset:9216
		v_cvt_pk_f16_f32 v2, v128, v129
		v_cvt_pk_f16_f32 v3, v130, v131
		ds_write_b64 v1, v[2:3] offset:9728
		v_cvt_pk_f16_f32 v2, v148, v149
		v_cvt_pk_f16_f32 v3, v150, v151
		ds_write_b64 v1, v[2:3] offset:12288
		v_cvt_pk_f16_f32 v2, v152, v153
		v_cvt_pk_f16_f32 v3, v154, v155
		ds_write_b64 v1, v[2:3] offset:12800
		v_cvt_pk_f16_f32 v2, v156, v157
		v_cvt_pk_f16_f32 v3, v158, v159
		ds_write_b64 v1, v[2:3] offset:13312
		v_cvt_pk_f16_f32 v2, v160, v161
		v_cvt_pk_f16_f32 v3, v162, v163
		ds_write_b64 v1, v[2:3] offset:13824
		v_cvt_pk_f16_f32 v2, v176, v177
		v_cvt_pk_f16_f32 v3, v178, v179
		ds_write_b64 v1, v[2:3] offset:16384
		v_cvt_pk_f16_f32 v2, v180, v181
		v_cvt_pk_f16_f32 v3, v182, v183
		ds_write_b64 v1, v[2:3] offset:16896
		v_cvt_pk_f16_f32 v2, v184, v185
		v_cvt_pk_f16_f32 v3, v186, v187
		ds_write_b64 v1, v[2:3] offset:17408
		v_cvt_pk_f16_f32 v2, v188, v189
		v_cvt_pk_f16_f32 v3, v190, v191
		ds_write_b64 v1, v[2:3] offset:17920
		v_cvt_pk_f16_f32 v2, v192, v193
		v_cvt_pk_f16_f32 v3, v194, v195
		ds_write_b64 v1, v[2:3] offset:20480
		v_cvt_pk_f16_f32 v2, v196, v197
		v_cvt_pk_f16_f32 v3, v198, v199
		ds_write_b64 v1, v[2:3] offset:20992
		v_cvt_pk_f16_f32 v2, v200, v201
		v_cvt_pk_f16_f32 v3, v202, v203
		ds_write_b64 v1, v[2:3] offset:21504
		v_cvt_pk_f16_f32 v2, v204, v205
		v_cvt_pk_f16_f32 v3, v206, v207
		ds_write_b64 v1, v[2:3] offset:22016
		v_cvt_pk_f16_f32 v2, v208, v209
		v_cvt_pk_f16_f32 v3, v210, v211
		ds_write_b64 v1, v[2:3] offset:24576
		v_cvt_pk_f16_f32 v2, v212, v213
		v_cvt_pk_f16_f32 v3, v214, v215
		ds_write_b64 v1, v[2:3] offset:25088
		v_cvt_pk_f16_f32 v2, v216, v217
		v_cvt_pk_f16_f32 v3, v218, v219
		ds_write_b64 v1, v[2:3] offset:25600
		v_cvt_pk_f16_f32 v2, v220, v221
		v_cvt_pk_f16_f32 v3, v222, v223
		ds_write_b64 v1, v[2:3] offset:26112
		v_cvt_pk_f16_f32 v2, v224, v225
		v_cvt_pk_f16_f32 v3, v226, v227
		ds_write_b64 v1, v[2:3] offset:28672
		v_cvt_pk_f16_f32 v2, v228, v229
		v_cvt_pk_f16_f32 v3, v230, v231
		ds_write_b64 v1, v[2:3] offset:29184
		v_cvt_pk_f16_f32 v2, v232, v233
		v_cvt_pk_f16_f32 v3, v234, v235
		ds_write_b64 v1, v[2:3] offset:29696
		v_cvt_pk_f16_f32 v2, v236, v237
		v_cvt_pk_f16_f32 v3, v238, v239
		ds_write_b64 v1, v[2:3] offset:30208
		s_and_saveexec_b64 s[2:3], s[16:17]
		s_waitcnt lgkmcnt(0)
		ds_add_rtn_u32 v2, v9, v26
		s_mov_b64 exec, s[2:3]
		v_cmp_lt_u32_e64 vcc, v0, s0
		s_mov_b64 s[2:3], vcc
		v_lshl_add_u32 v0, v11, 4, v4
		s_mov_b32 s0, 0x1000
		s_mov_b32 s1, 0x2000
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v2
		s_and_b32 s4, s4, -4
		s_add_i32 s4, s4, 4
		s_and_saveexec_b64 s[6:7], s[16:17]
.Lwmma_f16_matmul_tiled.loop_head_9:
		ds_read_b32 v2, v9
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s5, v2
		s_xor_b32 s8, s4, -1
		s_add_i32 s8, s8, 1
		s_add_i32 s5, s5, s8
		s_cmp_ge_u32 s5, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_9
.Lwmma_f16_matmul_tiled.loop_exit_9:
		s_mov_b64 exec, s[6:7]
		s_mov_b32 s4, 0x3000
		s_mov_b32 s5, 0x4000
		s_mov_b32 s6, 0x5000
		s_mov_b32 s7, 0x6000
		s_mov_b32 s8, 0x7000
		s_and_saveexec_b64 s[56:57], s[2:3]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_8
		v_add_u32_e32 v2, 48, v0
		ds_read_b128 v[8:11], v2
		ds_read_b128 v[12:15], v2 offset:512
		ds_read_b128 v[20:23], v2 offset:1024
		ds_read_b128 v[36:39], v2 offset:1536
		ds_read_b128 v[40:43], v2 offset:4096
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[8:11], v0, s[28:31], 0 offen
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[12:15], v0, s[28:31], 0 offen offset:512
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[20:23], v0, s[28:31], 0 offen offset:1024
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[36:39], v0, s[28:31], 0 offen offset:1536
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[40:43], v0, s[28:31], s0 offen
		ds_read_b128 v[8:11], v2 offset:4608
		ds_read_b128 v[12:15], v2 offset:5120
		ds_read_b128 v[20:23], v2 offset:5632
		ds_read_b128 v[36:39], v2 offset:8192
		ds_read_b128 v[40:43], v2 offset:8704
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[8:11], v0, s[28:31], s0 offen offset:512
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[12:15], v0, s[28:31], s0 offen offset:1024
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[20:23], v0, s[28:31], s0 offen offset:1536
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[36:39], v0, s[28:31], s1 offen
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[40:43], v0, s[28:31], s1 offen offset:512
		ds_read_b128 v[8:11], v2 offset:9216
		ds_read_b128 v[12:15], v2 offset:9728
		ds_read_b128 v[20:23], v2 offset:12288
		ds_read_b128 v[36:39], v2 offset:12800
		ds_read_b128 v[40:43], v2 offset:13312
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[8:11], v0, s[28:31], s1 offen offset:1024
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[12:15], v0, s[28:31], s1 offen offset:1536
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[20:23], v0, s[28:31], s4 offen
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[36:39], v0, s[28:31], s4 offen offset:512
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[40:43], v0, s[28:31], s4 offen offset:1024
		ds_read_b128 v[8:11], v2 offset:13824
		ds_read_b128 v[12:15], v2 offset:16384
		ds_read_b128 v[20:23], v2 offset:16896
		ds_read_b128 v[36:39], v2 offset:17408
		ds_read_b128 v[40:43], v2 offset:17920
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[8:11], v0, s[28:31], s4 offen offset:1536
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[12:15], v0, s[28:31], s5 offen
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[20:23], v0, s[28:31], s5 offen offset:512
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[36:39], v0, s[28:31], s5 offen offset:1024
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[40:43], v0, s[28:31], s5 offen offset:1536
		ds_read_b128 v[8:11], v2 offset:20480
		ds_read_b128 v[12:15], v2 offset:20992
		ds_read_b128 v[20:23], v2 offset:21504
		ds_read_b128 v[36:39], v2 offset:22016
		ds_read_b128 v[40:43], v2 offset:24576
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[8:11], v0, s[28:31], s6 offen
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[12:15], v0, s[28:31], s6 offen offset:512
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[20:23], v0, s[28:31], s6 offen offset:1024
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[36:39], v0, s[28:31], s6 offen offset:1536
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[40:43], v0, s[28:31], s7 offen
		ds_read_b128 v[8:11], v2 offset:25088
		ds_read_b128 v[12:15], v2 offset:25600
		ds_read_b128 v[20:23], v2 offset:26112
		ds_read_b128 v[36:39], v2 offset:28672
		ds_read_b128 v[40:43], v2 offset:29184
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[8:11], v0, s[28:31], s7 offen offset:512
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[12:15], v0, s[28:31], s7 offen offset:1024
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[20:23], v0, s[28:31], s7 offen offset:1536
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[36:39], v0, s[28:31], s8 offen
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[40:43], v0, s[28:31], s8 offen offset:512
		ds_read_b128 v[8:11], v2 offset:29696
		ds_read_b128 v[12:15], v2 offset:30208
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[8:11], v0, s[28:31], s8 offen offset:1024
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[12:15], v0, s[28:31], s8 offen offset:1536
.Lwmma_f16_matmul_tiled.exec_endif_8:
		s_mov_b64 exec, s[56:57]
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[28:31], a[56:59], v[68:71], v6, v24 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[28:31], a[60:63], v[72:75], v6, v24 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[28:31], a[64:67], v[76:79], v6, v24 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[28:31], a[68:71], v[80:83], v6, v24 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[32:35], a[68:71], v[112:115], v6, v24 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[32:35], a[56:59], v[100:103], v6, v24 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[32:35], a[60:63], v[104:107], v6, v24 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[32:35], a[64:67], v[108:111], v6, v24 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[0:3], a[64:67], v[140:143], v6, v24 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[0:3], a[56:59], v[132:135], v6, v24 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[0:3], a[60:63], v[136:139], v6, v24 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[0:3], a[68:71], v[144:147], v6, v24 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[4:7], a[68:71], a[132:135], v6, v24 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[4:7], a[56:59], v[164:167], v6, v24 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[4:7], a[60:63], v[168:171], v6, v24 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[4:7], a[64:67], v[172:175], v6, v24 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[8:11], a[64:67], a[144:147], v16, v24 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[8:11], a[56:59], a[136:139], v16, v24 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[8:11], a[60:63], a[140:143], v16, v24 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[8:11], a[68:71], a[148:151], v16, v24 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[12:15], a[68:71], a[164:167], v16, v24 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[12:15], a[56:59], a[152:155], v16, v24 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[12:15], a[60:63], a[156:159], v16, v24 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[12:15], a[64:67], a[160:163], v16, v24 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[16:19], a[64:67], a[176:179], v16, v24 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[16:19], a[56:59], a[168:171], v16, v24 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[16:19], a[60:63], a[172:175], v16, v24 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[16:19], a[68:71], a[180:183], v16, v24 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[20:23], a[68:71], a[196:199], v16, v24 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[20:23], a[56:59], a[184:187], v16, v24 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[20:23], a[60:63], a[188:191], v16, v24 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[20:23], a[64:67], a[192:195], v16, v24 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], a[24:27], a[72:75], v[68:71], v248, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], a[24:27], a[76:79], v[72:75], v248, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], a[24:27], a[80:83], v[76:79], v248, v254 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], a[24:27], a[84:87], v[80:83], v248, v254 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[28:31], a[84:87], v[112:115], v248, v254 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[28:31], a[72:75], v[100:103], v248, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], a[28:31], a[76:79], v[104:107], v248, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], a[28:31], a[80:83], v[108:111], v248, v254 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[32:35], a[80:83], v[140:143], v248, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[32:35], a[72:75], v[132:135], v248, v254 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[32:35], a[76:79], v[136:139], v248, v254 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[32:35], a[84:87], v[144:147], v248, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[36:39], a[84:87], a[132:135], v248, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[36:39], a[72:75], v[164:167], v248, v254 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[36:39], a[76:79], v[168:171], v248, v254 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[36:39], a[80:83], v[172:175], v248, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[40:43], a[80:83], a[144:147], v250, v254 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[40:43], a[72:75], a[136:139], v250, v254 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[40:43], a[76:79], a[140:143], v250, v254 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[40:43], a[84:87], a[148:151], v250, v254 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[44:47], a[84:87], a[164:167], v250, v254 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[44:47], a[72:75], a[152:155], v250, v254 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[44:47], a[76:79], a[156:159], v250, v254 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[44:47], a[80:83], a[160:163], v250, v254 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[48:51], a[80:83], a[176:179], v250, v254 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[48:51], a[72:75], a[168:171], v250, v254 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[48:51], a[76:79], a[172:175], v250, v254 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[48:51], a[84:87], a[180:183], v250, v254 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[52:55], a[84:87], a[196:199], v250, v254 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[52:55], a[72:75], a[184:187], v250, v254 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[52:55], a[76:79], a[188:191], v250, v254 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[52:55], a[80:83], a[192:195], v250, v254 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v68, v69
		v_cvt_pk_f16_f32 v3, v70, v71
		ds_write_b64 v1, v[2:3] offset:2048
		v_cvt_pk_f16_f32 v2, v72, v73
		v_cvt_pk_f16_f32 v3, v74, v75
		ds_write_b64 v1, v[2:3] offset:2560
		v_cvt_pk_f16_f32 v2, v76, v77
		v_cvt_pk_f16_f32 v3, v78, v79
		ds_write_b64 v1, v[2:3] offset:3072
		v_cvt_pk_f16_f32 v2, v80, v81
		v_cvt_pk_f16_f32 v3, v82, v83
		ds_write_b64 v1, v[2:3] offset:3584
		v_cvt_pk_f16_f32 v2, v100, v101
		v_cvt_pk_f16_f32 v3, v102, v103
		ds_write_b64 v1, v[2:3] offset:6144
		v_cvt_pk_f16_f32 v2, v104, v105
		v_cvt_pk_f16_f32 v3, v106, v107
		ds_write_b64 v1, v[2:3] offset:6656
		v_cvt_pk_f16_f32 v2, v108, v109
		v_cvt_pk_f16_f32 v3, v110, v111
		ds_write_b64 v1, v[2:3] offset:7168
		v_cvt_pk_f16_f32 v2, v112, v113
		v_cvt_pk_f16_f32 v3, v114, v115
		ds_write_b64 v1, v[2:3] offset:7680
		v_cvt_pk_f16_f32 v2, v132, v133
		v_cvt_pk_f16_f32 v3, v134, v135
		ds_write_b64 v1, v[2:3] offset:10240
		v_cvt_pk_f16_f32 v2, v136, v137
		v_cvt_pk_f16_f32 v3, v138, v139
		ds_write_b64 v1, v[2:3] offset:10752
		v_cvt_pk_f16_f32 v2, v140, v141
		v_cvt_pk_f16_f32 v3, v142, v143
		ds_write_b64 v1, v[2:3] offset:11264
		v_cvt_pk_f16_f32 v2, v144, v145
		v_cvt_pk_f16_f32 v3, v146, v147
		ds_write_b64 v1, v[2:3] offset:11776
		v_cvt_pk_f16_f32 v2, v164, v165
		v_cvt_pk_f16_f32 v3, v166, v167
		ds_write_b64 v1, v[2:3] offset:14336
		v_cvt_pk_f16_f32 v2, v168, v169
		v_cvt_pk_f16_f32 v3, v170, v171
		ds_write_b64 v1, v[2:3] offset:14848
		v_cvt_pk_f16_f32 v2, v172, v173
		v_cvt_pk_f16_f32 v3, v174, v175
		ds_write_b64 v1, v[2:3] offset:15360
		v_accvgpr_read_b32 v2, a132
		v_accvgpr_read_b32 v3, a133
		v_cvt_pk_f16_f32 v4, v2, v3
		v_accvgpr_read_b32 v2, a134
		v_accvgpr_read_b32 v3, a135
		v_cvt_pk_f16_f32 v5, v2, v3
		ds_write_b64 v1, v[4:5] offset:15872
		v_accvgpr_read_b32 v2, a136
		v_accvgpr_read_b32 v3, a137
		v_cvt_pk_f16_f32 v4, v2, v3
		v_accvgpr_read_b32 v2, a138
		v_accvgpr_read_b32 v3, a139
		v_cvt_pk_f16_f32 v5, v2, v3
		ds_write_b64 v1, v[4:5] offset:18432
		v_accvgpr_read_b32 v2, a140
		v_accvgpr_read_b32 v3, a141
		v_cvt_pk_f16_f32 v4, v2, v3
		v_accvgpr_read_b32 v2, a142
		v_accvgpr_read_b32 v3, a143
		v_cvt_pk_f16_f32 v5, v2, v3
		ds_write_b64 v1, v[4:5] offset:18944
		v_accvgpr_read_b32 v2, a144
		v_accvgpr_read_b32 v3, a145
		v_cvt_pk_f16_f32 v4, v2, v3
		v_accvgpr_read_b32 v2, a146
		v_accvgpr_read_b32 v3, a147
		v_cvt_pk_f16_f32 v5, v2, v3
		ds_write_b64 v1, v[4:5] offset:19456
		v_accvgpr_read_b32 v2, a148
		v_accvgpr_read_b32 v3, a149
		v_cvt_pk_f16_f32 v4, v2, v3
		v_accvgpr_read_b32 v2, a150
		v_accvgpr_read_b32 v3, a151
		v_cvt_pk_f16_f32 v5, v2, v3
		ds_write_b64 v1, v[4:5] offset:19968
		v_accvgpr_read_b32 v2, a152
		v_accvgpr_read_b32 v3, a153
		v_cvt_pk_f16_f32 v4, v2, v3
		v_accvgpr_read_b32 v2, a154
		v_accvgpr_read_b32 v3, a155
		v_cvt_pk_f16_f32 v5, v2, v3
		ds_write_b64 v1, v[4:5] offset:22528
		v_accvgpr_read_b32 v2, a156
		v_accvgpr_read_b32 v3, a157
		v_cvt_pk_f16_f32 v4, v2, v3
		v_accvgpr_read_b32 v2, a158
		v_accvgpr_read_b32 v3, a159
		v_cvt_pk_f16_f32 v5, v2, v3
		ds_write_b64 v1, v[4:5] offset:23040
		v_accvgpr_read_b32 v2, a160
		v_accvgpr_read_b32 v3, a161
		v_cvt_pk_f16_f32 v4, v2, v3
		v_accvgpr_read_b32 v2, a162
		v_accvgpr_read_b32 v3, a163
		v_cvt_pk_f16_f32 v5, v2, v3
		ds_write_b64 v1, v[4:5] offset:23552
		v_accvgpr_read_b32 v2, a164
		v_accvgpr_read_b32 v3, a165
		v_cvt_pk_f16_f32 v4, v2, v3
		v_accvgpr_read_b32 v2, a166
		v_accvgpr_read_b32 v3, a167
		v_cvt_pk_f16_f32 v5, v2, v3
		ds_write_b64 v1, v[4:5] offset:24064
		v_accvgpr_read_b32 v2, a168
		v_accvgpr_read_b32 v3, a169
		v_cvt_pk_f16_f32 v4, v2, v3
		v_accvgpr_read_b32 v2, a170
		v_accvgpr_read_b32 v3, a171
		v_cvt_pk_f16_f32 v5, v2, v3
		ds_write_b64 v1, v[4:5] offset:26624
		v_accvgpr_read_b32 v2, a172
		v_accvgpr_read_b32 v3, a173
		v_cvt_pk_f16_f32 v4, v2, v3
		v_accvgpr_read_b32 v2, a174
		v_accvgpr_read_b32 v3, a175
		v_cvt_pk_f16_f32 v5, v2, v3
		ds_write_b64 v1, v[4:5] offset:27136
		v_accvgpr_read_b32 v2, a176
		v_accvgpr_read_b32 v3, a177
		v_cvt_pk_f16_f32 v4, v2, v3
		v_accvgpr_read_b32 v2, a178
		v_accvgpr_read_b32 v3, a179
		v_cvt_pk_f16_f32 v5, v2, v3
		ds_write_b64 v1, v[4:5] offset:27648
		v_accvgpr_read_b32 v2, a180
		v_accvgpr_read_b32 v3, a181
		v_cvt_pk_f16_f32 v4, v2, v3
		v_accvgpr_read_b32 v2, a182
		v_accvgpr_read_b32 v3, a183
		v_cvt_pk_f16_f32 v5, v2, v3
		ds_write_b64 v1, v[4:5] offset:28160
		v_accvgpr_read_b32 v2, a184
		v_accvgpr_read_b32 v3, a185
		v_cvt_pk_f16_f32 v4, v2, v3
		v_accvgpr_read_b32 v2, a186
		v_accvgpr_read_b32 v3, a187
		v_cvt_pk_f16_f32 v5, v2, v3
		ds_write_b64 v1, v[4:5] offset:30720
		v_accvgpr_read_b32 v2, a188
		v_accvgpr_read_b32 v3, a189
		v_cvt_pk_f16_f32 v4, v2, v3
		v_accvgpr_read_b32 v2, a190
		v_accvgpr_read_b32 v3, a191
		v_cvt_pk_f16_f32 v5, v2, v3
		ds_write_b64 v1, v[4:5] offset:31232
		v_accvgpr_read_b32 v2, a192
		v_accvgpr_read_b32 v3, a193
		v_cvt_pk_f16_f32 v4, v2, v3
		v_accvgpr_read_b32 v2, a194
		v_accvgpr_read_b32 v3, a195
		v_cvt_pk_f16_f32 v5, v2, v3
		ds_write_b64 v1, v[4:5] offset:31744
		v_accvgpr_read_b32 v2, a196
		v_accvgpr_read_b32 v3, a197
		v_cvt_pk_f16_f32 v4, v2, v3
		v_accvgpr_read_b32 v2, a198
		v_accvgpr_read_b32 v3, a199
		v_cvt_pk_f16_f32 v5, v2, v3
		ds_write_b64 v1, v[4:5] offset:32256
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[56:57], s[2:3]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_9
		v_add_u32_e32 v1, 48, v0
		ds_read_b128 v[4:7], v1 offset:2048
		ds_read_b128 v[8:11], v1 offset:2560
		ds_read_b128 v[12:15], v1 offset:3072
		ds_read_b128 v[16:19], v1 offset:3584
		ds_read_b128 v[20:23], v1 offset:6144
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v0, s[28:31], 0 offen offset:2048
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[8:11], v0, s[28:31], 0 offen offset:2560
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[12:15], v0, s[28:31], 0 offen offset:3072
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[16:19], v0, s[28:31], 0 offen offset:3584
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[20:23], v0, s[28:31], s0 offen offset:2048
		ds_read_b128 v[4:7], v1 offset:6656
		ds_read_b128 v[8:11], v1 offset:7168
		ds_read_b128 v[12:15], v1 offset:7680
		ds_read_b128 v[16:19], v1 offset:10240
		ds_read_b128 v[20:23], v1 offset:10752
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v0, s[28:31], s0 offen offset:2560
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[8:11], v0, s[28:31], s0 offen offset:3072
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[12:15], v0, s[28:31], s0 offen offset:3584
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[16:19], v0, s[28:31], s1 offen offset:2048
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[20:23], v0, s[28:31], s1 offen offset:2560
		ds_read_b128 v[4:7], v1 offset:11264
		ds_read_b128 v[8:11], v1 offset:11776
		ds_read_b128 v[12:15], v1 offset:14336
		ds_read_b128 v[16:19], v1 offset:14848
		ds_read_b128 v[20:23], v1 offset:15360
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v0, s[28:31], s1 offen offset:3072
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[8:11], v0, s[28:31], s1 offen offset:3584
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[12:15], v0, s[28:31], s4 offen offset:2048
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[16:19], v0, s[28:31], s4 offen offset:2560
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[20:23], v0, s[28:31], s4 offen offset:3072
		ds_read_b128 v[4:7], v1 offset:15872
		ds_read_b128 v[8:11], v1 offset:18432
		ds_read_b128 v[12:15], v1 offset:18944
		ds_read_b128 v[16:19], v1 offset:19456
		ds_read_b128 v[20:23], v1 offset:19968
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v0, s[28:31], s4 offen offset:3584
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[8:11], v0, s[28:31], s5 offen offset:2048
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[12:15], v0, s[28:31], s5 offen offset:2560
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[16:19], v0, s[28:31], s5 offen offset:3072
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[20:23], v0, s[28:31], s5 offen offset:3584
		ds_read_b128 v[4:7], v1 offset:22528
		ds_read_b128 v[8:11], v1 offset:23040
		ds_read_b128 v[12:15], v1 offset:23552
		ds_read_b128 v[16:19], v1 offset:24064
		ds_read_b128 v[20:23], v1 offset:26624
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v0, s[28:31], s6 offen offset:2048
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[8:11], v0, s[28:31], s6 offen offset:2560
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[12:15], v0, s[28:31], s6 offen offset:3072
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[16:19], v0, s[28:31], s6 offen offset:3584
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[20:23], v0, s[28:31], s7 offen offset:2048
		ds_read_b128 v[4:7], v1 offset:27136
		ds_read_b128 v[8:11], v1 offset:27648
		ds_read_b128 v[12:15], v1 offset:28160
		ds_read_b128 v[16:19], v1 offset:30720
		ds_read_b128 v[20:23], v1 offset:31232
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[4:7], v0, s[28:31], s7 offen offset:2560
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[8:11], v0, s[28:31], s7 offen offset:3072
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[12:15], v0, s[28:31], s7 offen offset:3584
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[16:19], v0, s[28:31], s8 offen offset:2048
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[20:23], v0, s[28:31], s8 offen offset:2560
		ds_read_b128 v[4:7], v1 offset:31744
		ds_read_b128 v[8:11], v1 offset:32256
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[4:7], v0, s[28:31], s8 offen offset:3072
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[28:31], s8 offen offset:3584
.Lwmma_f16_matmul_tiled.exec_endif_9:
		s_mov_b64 exec, s[56:57]
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 48
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
		.amdhsa_next_free_vgpr 456
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
	.set .Lwmma_f16_matmul_tiled.num_agpr, 200
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
    .group_segment_fixed_size: 48
    .kernarg_segment_align: 8
    .kernarg_segment_size: 48
    .max_flat_workgroup_size: 256
    .name:           wmma_f16_matmul_tiled
    .private_segment_fixed_size: 0
    .sgpr_count:     58
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     456
    .agpr_count:     200
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 73
    wave.regalloc.agpr.dwords: 285
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
