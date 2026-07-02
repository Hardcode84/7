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
		s_mov_b32 s0, s10
		s_mov_b32 s1, s11
		s_mov_b32 s2, 0x7fffffff
		s_mov_b32 s3, 0x31016000
		s_mov_b32 s24, s8
		s_mov_b32 s25, s9
		s_mov_b32 s26, 0x7fffffff
		s_mov_b32 s27, 0x31016000
		s_lshr_b32 s4, s13, 3
		s_lshl_b32 s5, s14, 1
		s_add_i32 s4, s5, s4
		s_and_b32 s5, s13, 7
		s_lshl_b32 s5, s5, 5
		s_add_i32 s4, s4, s5
		s_lshr_b32 s5, s4, 6
		s_lshl_b32 s8, s5, 23
		s_and_b32 s4, s4, 63
		s_lshr_b32 s9, s4, 2
		s_lshl_b32 s10, s9, 17
		s_add_i32 s8, s8, s10
		v_readfirstlane_b32 s10, v0
		s_and_b32 s4, s4, 3
		s_lshl_b32 s11, s4, 21
		s_add_i32 s8, s8, s11
		s_add_u32 s6, s6, s8
		s_addc_u32 s7, s7, 0
		s_mov_b32 s12, s6
		s_mov_b32 s13, s7
		s_mov_b32 s14, 0x20000
		s_mov_b32 s15, 0x31016000
		v_and_b32_e32 v1, 63, v0
		s_lshr_b32 s6, s10, 6
		s_lshl_b32 s7, s6, 10
		s_add_i32 s6, s7, 0x1000
		s_add_i32 s8, s7, 0x2000
		v_lshrrev_b32_e32 v2, 2, v1
		v_lshrrev_b32_e32 v3, 3, v1
		s_add_i32 s10, s7, 0x3000
		s_add_i32 s11, s7, 0x4000
		s_add_i32 s28, s7, 0x5000
		s_add_i32 s29, s7, 0x6000
		v_lshrrev_b32_e32 v4, 6, v0
		v_lshlrev_b32_e32 v2, 12, v2
		v_and_b32_e32 v3, 3, v3
		v_and_b32_e32 v5, 3, v1
		s_add_i32 s30, s7, 0x7000
		s_add_i32 s31, s7, 0x8000
		s_add_i32 s32, s7, 0x9000
		s_add_i32 s33, s7, 0xa000
		v_lshl_add_u32 v2, v4, 16, v2
		v_xor_b32_e32 v3, v3, v5
		s_add_i32 s34, s7, 0xb000
		s_add_i32 s35, s7, 0xc000
		s_add_i32 s36, s7, 0xd000
		s_add_i32 s37, s7, 0xe000
		v_lshl_add_u32 v2, v3, 4, v2
		s_add_i32 s38, s7, 0xf000
		s_lshl_b32 s39, s5, 22
		s_lshl_b32 s40, s4, 20
		s_add_i32 s41, s39, s40
		s_mov_b32 m0, s7
		v_add_u32_e32 v3, s41, v2
		buffer_load_dwordx4 v3, s[16:19], 0 offen lds
		s_add_i32 s41, s39, 0x40000
		s_add_i32 s41, s41, s40
		s_mov_b32 m0, s6
		v_add_u32_e32 v5, s41, v2
		buffer_load_dwordx4 v5, s[16:19], 0 offen lds
		v_add_u32_e32 v5, s40, v2
		s_add_i32 s41, s39, 0x80000
		s_mov_b32 m0, s8
		v_add_u32_e32 v6, s41, v5
		buffer_load_dwordx4 v6, s[16:19], 0 offen lds
		s_add_i32 s41, s39, 0xc0000
		s_mov_b32 m0, s10
		v_add_u32_e32 v6, s41, v5
		buffer_load_dwordx4 v6, s[16:19], 0 offen lds
		s_mov_b32 m0, s11
		v_add3_u32 v5, s39, 64, v5
		buffer_load_dwordx4 v5, s[16:19], 0 offen lds
		v_add_u32_e32 v5, s40, v2
		v_add_u32_e32 v5, s39, v5
		s_mov_b32 m0, s28
		v_add_u32_e32 v6, 0x40040, v5
		buffer_load_dwordx4 v6, s[16:19], 0 offen lds
		s_mov_b32 m0, s29
		v_add_u32_e32 v6, 0x80040, v5
		buffer_load_dwordx4 v6, s[16:19], 0 offen lds
		s_mov_b32 m0, s30
		v_add_u32_e32 v5, 0xc0040, v5
		buffer_load_dwordx4 v5, s[16:19], 0 offen lds
		s_lshl_b32 s41, s9, 20
		s_mov_b32 m0, s31
		v_add_u32_e32 v5, s41, v2
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		v_add_u32_e32 v6, s41, v2
		s_mov_b32 m0, s32
		v_add_u32_e32 v7, 0x40000, v6
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		s_mov_b32 m0, s33
		v_add_u32_e32 v7, 0x80000, v6
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		s_mov_b32 m0, s34
		v_add_u32_e32 v6, 0xc0000, v6
		buffer_load_dwordx4 v6, s[20:23], 0 offen lds
		s_mov_b32 m0, s35
		v_add3_u32 v6, s41, 64, v2
		buffer_load_dwordx4 v6, s[20:23], 0 offen lds
		v_add_u32_e32 v6, s41, v2
		s_mov_b32 m0, s36
		v_add_u32_e32 v7, 0x40040, v6
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		s_mov_b32 m0, s37
		v_add_u32_e32 v7, 0x80040, v6
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		s_mov_b32 m0, s38
		v_add_u32_e32 v6, 0xc0040, v6
		buffer_load_dwordx4 v6, s[20:23], 0 offen lds
		v_lshrrev_b32_e32 v6, 7, v0
		v_lshrrev_b32_e32 v7, 4, v1
		v_and_b32_e32 v8, 15, v0
		v_lshlrev_b32_e32 v9, 10, v6
		v_and_b32_e32 v10, 1, v4
		v_lshlrev_b32_e32 v11, 7, v6
		v_lshlrev_b32_e32 v12, 12, v7
		v_lshlrev_b32_e32 v13, 2, v8
		v_add_u32_e32 v14, 0x20000, v9
		v_accvgpr_write_b32 a0, v14
		v_lshlrev_b32_e32 v14, 7, v7
		s_mov_b32 s42, 0
		s_lshl_b32 s5, s5, 10
		v_mov_b64_e32 v[16:17], 0
		v_mov_b64_e32 v[18:19], 0
		v_cmp_eq_u32_e64 vcc, v10, s42
		s_mov_b64 s[44:45], vcc
		v_add3_u32 v10, v11, v12, v13
		v_accvgpr_read_b32 v11, a0
		v_add3_u32 v11, v11, v14, v13
		s_lshl_b32 s4, s4, 8
		s_add_i32 s43, s5, s4
		s_add_i32 s46, s5, 0x4000
		s_add_i32 s46, s46, s4
		s_and_saveexec_b64 s[54:55], s[44:45]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_0
		buffer_load_dword v12, v10, s[24:27], s43 offen
		buffer_load_dword v15, v10, s[24:27], s43 offen offset:64
		buffer_load_dword v20, v10, s[24:27], s46 offen
		buffer_load_dword v21, v10, s[24:27], s46 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write_b32 v11, v12
		ds_write_b32 v11, v15 offset:512
		ds_write_b32 v11, v20 offset:4096
		ds_write_b32 v11, v21 offset:4608
.Lwmma_f16_matmul_tiled.exec_else_0:
		s_andn2_b64 exec, s[54:55], s[44:45]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_0
.Lwmma_f16_matmul_tiled.exec_endif_0:
		s_mov_b64 exec, s[54:55]
		v_add_u32_e32 v12, 0x20000, v14
		v_lshrrev_b32_e32 v15, 1, v4
		v_lshl_add_u32 v20, v7, 12, v13
		v_and_b32_e32 v21, 1, v4
		v_add_u32_e32 v12, v12, v13
		v_cmp_eq_u32_e64 vcc, v15, s42
		s_mov_b64 s[46:47], vcc
		v_lshl_add_u32 v15, v21, 7, v20
		v_lshl_add_u32 v12, v21, 10, v12
		s_lshl_b32 s9, s9, 8
		s_add_i32 s43, s9, 0x4000
		s_and_saveexec_b64 s[54:55], s[46:47]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_1
		buffer_load_dword v20, v15, s[0:3], s9 offen
		buffer_load_dword v22, v15, s[0:3], s9 offen offset:64
		buffer_load_dword v23, v15, s[0:3], s43 offen
		buffer_load_dword v24, v15, s[0:3], s43 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write_b32 v12, v20 offset:2048
		ds_write_b32 v12, v22 offset:2560
		ds_write_b32 v12, v23 offset:6144
		ds_write_b32 v12, v24 offset:6656
.Lwmma_f16_matmul_tiled.exec_else_1:
		s_andn2_b64 exec, s[54:55], s[46:47]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_1
.Lwmma_f16_matmul_tiled.exec_endif_1:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s43, s5, 0x8000
		s_add_i32 s43, s43, s4
		s_add_i32 s48, s5, 0xc000
		s_add_i32 s48, s48, s4
		s_and_saveexec_b64 s[54:55], s[44:45]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_2
		buffer_load_dword v20, v10, s[24:27], s43 offen
		buffer_load_dword v22, v10, s[24:27], s43 offen offset:64
		buffer_load_dword v23, v10, s[24:27], s48 offen
		buffer_load_dword v24, v10, s[24:27], s48 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write_b32 v11, v20 offset:8192
		ds_write_b32 v11, v22 offset:8704
		ds_write_b32 v11, v23 offset:12288
		ds_write_b32 v11, v24 offset:12800
.Lwmma_f16_matmul_tiled.exec_else_2:
		s_andn2_b64 exec, s[54:55], s[44:45]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_2
.Lwmma_f16_matmul_tiled.exec_endif_2:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s43, s9, 0x8000
		s_add_i32 s48, s9, 0xc000
		s_and_saveexec_b64 s[54:55], s[46:47]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_3
		buffer_load_dword v11, v15, s[0:3], s43 offen
		buffer_load_dword v20, v15, s[0:3], s43 offen offset:64
		buffer_load_dword v22, v15, s[0:3], s48 offen
		buffer_load_dword v23, v15, s[0:3], s48 offen offset:64
		s_waitcnt vmcnt(0)
		ds_write_b32 v12, v11 offset:10240
		ds_write_b32 v12, v20 offset:10752
		ds_write_b32 v12, v22 offset:14336
		ds_write_b32 v12, v23 offset:14848
.Lwmma_f16_matmul_tiled.exec_else_3:
		s_andn2_b64 exec, s[54:55], s[46:47]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_3
.Lwmma_f16_matmul_tiled.exec_endif_3:
		s_mov_b64 exec, s[54:55]
		s_add_i32 m0, s7, 0x10000
		s_add_i32 s43, s39, 0x80
		s_add_i32 s43, s43, s40
		v_add_u32_e32 v11, s43, v2
		buffer_load_dwordx4 v11, s[16:19], 0 offen lds
		s_add_i32 m0, s7, 0x11000
		s_add_i32 s43, s39, 0x40080
		s_add_i32 s43, s43, s40
		v_add_u32_e32 v11, s43, v2
		buffer_load_dwordx4 v11, s[16:19], 0 offen lds
		s_add_i32 m0, s7, 0x12000
		v_add_u32_e32 v11, s40, v2
		v_add_u32_e32 v11, s39, v11
		v_add_u32_e32 v12, 0x80080, v11
		buffer_load_dwordx4 v12, s[16:19], 0 offen lds
		s_add_i32 m0, s7, 0x13000
		v_add_u32_e32 v12, 0xc0080, v11
		buffer_load_dwordx4 v12, s[16:19], 0 offen lds
		s_add_i32 m0, s7, 0x14000
		v_add_u32_e32 v11, 0xc0, v11
		buffer_load_dwordx4 v11, s[16:19], 0 offen lds
		s_add_i32 m0, s7, 0x15000
		v_add_u32_e32 v11, s40, v2
		v_add_u32_e32 v11, s39, v11
		v_add_u32_e32 v12, 0x400c0, v11
		buffer_load_dwordx4 v12, s[16:19], 0 offen lds
		s_add_i32 m0, s7, 0x16000
		v_add_u32_e32 v12, 0x800c0, v11
		buffer_load_dwordx4 v12, s[16:19], 0 offen lds
		s_add_i32 m0, s7, 0x17000
		v_add_u32_e32 v11, 0xc00c0, v11
		buffer_load_dwordx4 v11, s[16:19], 0 offen lds
		s_add_i32 m0, s7, 0x18000
		s_add_i32 s39, s41, 0x80
		v_add_u32_e32 v11, s39, v2
		buffer_load_dwordx4 v11, s[20:23], 0 offen lds
		s_add_i32 m0, s7, 0x19000
		s_add_i32 s39, s41, 0x40080
		v_add_u32_e32 v11, s39, v2
		buffer_load_dwordx4 v11, s[20:23], 0 offen lds
		s_add_i32 m0, s7, 0x1a000
		v_add_u32_e32 v11, s41, v2
		v_add_u32_e32 v12, 0x80080, v11
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_add_i32 m0, s7, 0x1b000
		v_add_u32_e32 v12, 0xc0080, v11
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_add_i32 m0, s7, 0x1c000
		v_add_u32_e32 v11, 0xc0, v11
		buffer_load_dwordx4 v11, s[20:23], 0 offen lds
		s_add_i32 m0, s7, 0x1d000
		v_add_u32_e32 v2, s41, v2
		v_add_u32_e32 v11, 0x400c0, v2
		buffer_load_dwordx4 v11, s[20:23], 0 offen lds
		s_add_i32 m0, s7, 0x1e000
		v_add_u32_e32 v11, 0x800c0, v2
		buffer_load_dwordx4 v11, s[20:23], 0 offen lds
		s_add_i32 m0, s7, 0x1f000
		v_add_u32_e32 v2, 0xc00c0, v2
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		s_waitcnt vmcnt(16)
		s_barrier
		v_lshlrev_b32_e32 v2, 13, v6
		v_lshlrev_b32_e32 v6, 6, v8
		v_lshrrev_b32_e32 v8, 1, v8
		v_and_b32_e32 v8, 3, v8
		v_xor_b32_e32 v8, v7, v8
		v_lshlrev_b32_e32 v8, 4, v8
		v_add3_u32 v11, v2, v6, v8
		ds_read_b128 v[24:27], v11
		ds_read_b128 v[28:31], v11 offset:1024
		ds_read_b128 v[32:35], v11 offset:2048
		ds_read_b128 v[36:39], v11 offset:3072
		ds_read_b128 v[40:43], v11 offset:4096
		ds_read_b128 v[44:47], v11 offset:5120
		ds_read_b128 v[48:51], v11 offset:6144
		ds_read_b128 v[52:55], v11 offset:7168
		ds_read_b128 v[56:59], v11 offset:16384
		ds_read_b128 v[60:63], v11 offset:17408
		ds_read_b128 v[64:67], v11 offset:18432
		ds_read_b128 v[68:71], v11 offset:19456
		ds_read_b128 v[72:75], v11 offset:20480
		ds_read_b128 v[76:79], v11 offset:21504
		ds_read_b128 v[80:83], v11 offset:22528
		ds_read_b128 v[84:87], v11 offset:23552
		v_lshlrev_b32_e32 v11, 13, v21
		v_add3_u32 v12, v6, v11, v8
		ds_read_b128 v[88:91], v12 offset:32768
		ds_read_b128 v[92:95], v12 offset:33792
		ds_read_b128 v[96:99], v12 offset:34816
		ds_read_b128 v[100:103], v12 offset:35840
		ds_read_b128 v[104:107], v12 offset:36864
		ds_read_b128 v[108:111], v12 offset:37888
		ds_read_b128 v[112:115], v12 offset:38912
		ds_read_b128 v[116:119], v12 offset:39936
		ds_read_b128 v[120:123], v12 offset:49152
		ds_read_b128 v[124:127], v12 offset:50176
		ds_read_b128 v[128:131], v12 offset:51200
		ds_read_b128 v[132:135], v12 offset:52224
		ds_read_b128 v[136:139], v12 offset:53248
		ds_read_b128 v[140:143], v12 offset:54272
		ds_read_b128 v[144:147], v12 offset:55296
		ds_read_b128 v[148:151], v12 offset:56320
		v_add_u32_e32 v12, 0x100, v3
		v_add_u32_e32 v20, 0x40100, v3
		v_add_u32_e32 v22, 0x80100, v3
		v_add_u32_e32 v23, 0xc0100, v3
		v_add_u32_e32 v152, 0x140, v3
		v_add_u32_e32 v153, 0x40140, v3
		v_add_u32_e32 v154, 0x80140, v3
		v_add_u32_e32 v155, 0xc0140, v3
		v_add_u32_e32 v3, 0x100, v5
		v_add_u32_e32 v156, 0x40100, v5
		v_add_u32_e32 v157, 0x80100, v5
		v_add_u32_e32 v158, 0xc0100, v5
		v_add_u32_e32 v159, 0x140, v5
		v_add_u32_e32 v160, 0x40140, v5
		v_add_u32_e32 v161, 0x80140, v5
		v_add_u32_e32 v162, 0xc0140, v5
		v_lshlrev_b32_e32 v5, 3, v1
		v_lshlrev_b32_e32 v163, 10, v21
		s_add_i32 s39, s5, 0x10000
		s_add_i32 s39, s39, s4
		s_add_i32 s5, s5, 0x14000
		s_add_i32 s4, s5, s4
		v_add_u32_e32 v164, v9, v14
		s_add_i32 s5, s9, 0x10000
		s_add_i32 s9, s9, 0x14000
		v_lshl_add_u32 v165, v7, 7, v13
		v_mov_b64_e32 v[168:169], 0
		v_mov_b64_e32 v[170:171], 0
		v_mov_b64_e32 v[172:173], 0
		v_mov_b64_e32 v[174:175], 0
		v_mov_b64_e32 v[176:177], 0
		v_mov_b64_e32 v[178:179], 0
		v_mov_b64_e32 v[180:181], 0
		v_mov_b64_e32 v[182:183], 0
		v_accvgpr_write_b32 a4, 0
		v_accvgpr_write_b32 a5, 0
		v_accvgpr_write_b32 a6, 0
		v_accvgpr_write_b32 a7, 0
		v_mov_b64_e32 v[180:181], 0
		v_mov_b64_e32 v[182:183], 0
		v_accvgpr_write_b32 a8, 0
		v_accvgpr_write_b32 a9, 0
		v_accvgpr_write_b32 a10, 0
		v_accvgpr_write_b32 a11, 0
		v_mov_b64_e32 v[180:181], 0
		v_mov_b64_e32 v[182:183], 0
		v_accvgpr_write_b32 a12, 0
		v_accvgpr_write_b32 a13, 0
		v_accvgpr_write_b32 a14, 0
		v_accvgpr_write_b32 a15, 0
		v_mov_b64_e32 v[180:181], 0
		v_mov_b64_e32 v[182:183], 0
		v_accvgpr_write_b32 a16, 0
		v_accvgpr_write_b32 a17, 0
		v_accvgpr_write_b32 a18, 0
		v_accvgpr_write_b32 a19, 0
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
		v_accvgpr_write_b32 a20, 0
		v_accvgpr_write_b32 a21, 0
		v_accvgpr_write_b32 a22, 0
		v_accvgpr_write_b32 a23, 0
		v_mov_b64_e32 v[196:197], 0
		v_mov_b64_e32 v[198:199], 0
		v_accvgpr_write_b32 a24, 0
		v_accvgpr_write_b32 a25, 0
		v_accvgpr_write_b32 a26, 0
		v_accvgpr_write_b32 a27, 0
		v_mov_b64_e32 v[196:197], 0
		v_mov_b64_e32 v[198:199], 0
		v_accvgpr_write_b32 a28, 0
		v_accvgpr_write_b32 a29, 0
		v_accvgpr_write_b32 a30, 0
		v_accvgpr_write_b32 a31, 0
		v_mov_b64_e32 v[196:197], 0
		v_mov_b64_e32 v[198:199], 0
		v_accvgpr_write_b32 a32, 0
		v_accvgpr_write_b32 a33, 0
		v_accvgpr_write_b32 a34, 0
		v_accvgpr_write_b32 a35, 0
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
		v_accvgpr_write_b32 a36, 0
		v_accvgpr_write_b32 a37, 0
		v_accvgpr_write_b32 a38, 0
		v_accvgpr_write_b32 a39, 0
		v_mov_b64_e32 v[212:213], 0
		v_mov_b64_e32 v[214:215], 0
		v_accvgpr_write_b32 a40, 0
		v_accvgpr_write_b32 a41, 0
		v_accvgpr_write_b32 a42, 0
		v_accvgpr_write_b32 a43, 0
		v_mov_b64_e32 v[212:213], 0
		v_mov_b64_e32 v[214:215], 0
		v_accvgpr_write_b32 a44, 0
		v_accvgpr_write_b32 a45, 0
		v_accvgpr_write_b32 a46, 0
		v_accvgpr_write_b32 a47, 0
		v_mov_b64_e32 v[212:213], 0
		v_mov_b64_e32 v[214:215], 0
		v_accvgpr_write_b32 a48, 0
		v_accvgpr_write_b32 a49, 0
		v_accvgpr_write_b32 a50, 0
		v_accvgpr_write_b32 a51, 0
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
		v_accvgpr_write_b32 a52, 0
		v_accvgpr_write_b32 a53, 0
		v_accvgpr_write_b32 a54, 0
		v_accvgpr_write_b32 a55, 0
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a56, 0
		v_accvgpr_write_b32 a57, 0
		v_accvgpr_write_b32 a58, 0
		v_accvgpr_write_b32 a59, 0
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a60, 0
		v_accvgpr_write_b32 a61, 0
		v_accvgpr_write_b32 a62, 0
		v_accvgpr_write_b32 a63, 0
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_accvgpr_write_b32 a64, 0
		v_accvgpr_write_b32 a65, 0
		v_accvgpr_write_b32 a66, 0
		v_accvgpr_write_b32 a67, 0
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
		v_mov_b64_e32 v[232:233], 0
		v_mov_b64_e32 v[234:235], 0
		v_mov_b64_e32 v[236:237], 0
		v_mov_b64_e32 v[238:239], 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a68, 0
		v_accvgpr_write_b32 a69, 0
		v_accvgpr_write_b32 a70, 0
		v_accvgpr_write_b32 a71, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a72, 0
		v_accvgpr_write_b32 a73, 0
		v_accvgpr_write_b32 a74, 0
		v_accvgpr_write_b32 a75, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a76, 0
		v_accvgpr_write_b32 a77, 0
		v_accvgpr_write_b32 a78, 0
		v_accvgpr_write_b32 a79, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a80, 0
		v_accvgpr_write_b32 a81, 0
		v_accvgpr_write_b32 a82, 0
		v_accvgpr_write_b32 a83, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a84, 0
		v_accvgpr_write_b32 a85, 0
		v_accvgpr_write_b32 a86, 0
		v_accvgpr_write_b32 a87, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a88, 0
		v_accvgpr_write_b32 a89, 0
		v_accvgpr_write_b32 a90, 0
		v_accvgpr_write_b32 a91, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a92, 0
		v_accvgpr_write_b32 a93, 0
		v_accvgpr_write_b32 a94, 0
		v_accvgpr_write_b32 a95, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a96, 0
		v_accvgpr_write_b32 a97, 0
		v_accvgpr_write_b32 a98, 0
		v_accvgpr_write_b32 a99, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a100, 0
		v_accvgpr_write_b32 a101, 0
		v_accvgpr_write_b32 a102, 0
		v_accvgpr_write_b32 a103, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a104, 0
		v_accvgpr_write_b32 a105, 0
		v_accvgpr_write_b32 a106, 0
		v_accvgpr_write_b32 a107, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a108, 0
		v_accvgpr_write_b32 a109, 0
		v_accvgpr_write_b32 a110, 0
		v_accvgpr_write_b32 a111, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a112, 0
		v_accvgpr_write_b32 a113, 0
		v_accvgpr_write_b32 a114, 0
		v_accvgpr_write_b32 a115, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a116, 0
		v_accvgpr_write_b32 a117, 0
		v_accvgpr_write_b32 a118, 0
		v_accvgpr_write_b32 a119, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a120, 0
		v_accvgpr_write_b32 a121, 0
		v_accvgpr_write_b32 a122, 0
		v_accvgpr_write_b32 a123, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a124, 0
		v_accvgpr_write_b32 a125, 0
		v_accvgpr_write_b32 a126, 0
		v_accvgpr_write_b32 a127, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a128, 0
		v_accvgpr_write_b32 a129, 0
		v_accvgpr_write_b32 a130, 0
		v_accvgpr_write_b32 a131, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a132, 0
		v_accvgpr_write_b32 a133, 0
		v_accvgpr_write_b32 a134, 0
		v_accvgpr_write_b32 a135, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a136, 0
		v_accvgpr_write_b32 a137, 0
		v_accvgpr_write_b32 a138, 0
		v_accvgpr_write_b32 a139, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a140, 0
		v_accvgpr_write_b32 a141, 0
		v_accvgpr_write_b32 a142, 0
		v_accvgpr_write_b32 a143, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a144, 0
		v_accvgpr_write_b32 a145, 0
		v_accvgpr_write_b32 a146, 0
		v_accvgpr_write_b32 a147, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a148, 0
		v_accvgpr_write_b32 a149, 0
		v_accvgpr_write_b32 a150, 0
		v_accvgpr_write_b32 a151, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a152, 0
		v_accvgpr_write_b32 a153, 0
		v_accvgpr_write_b32 a154, 0
		v_accvgpr_write_b32 a155, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a156, 0
		v_accvgpr_write_b32 a157, 0
		v_accvgpr_write_b32 a158, 0
		v_accvgpr_write_b32 a159, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a160, 0
		v_accvgpr_write_b32 a161, 0
		v_accvgpr_write_b32 a162, 0
		v_accvgpr_write_b32 a163, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a164, 0
		v_accvgpr_write_b32 a165, 0
		v_accvgpr_write_b32 a166, 0
		v_accvgpr_write_b32 a167, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a168, 0
		v_accvgpr_write_b32 a169, 0
		v_accvgpr_write_b32 a170, 0
		v_accvgpr_write_b32 a171, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a172, 0
		v_accvgpr_write_b32 a173, 0
		v_accvgpr_write_b32 a174, 0
		v_accvgpr_write_b32 a175, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a176, 0
		v_accvgpr_write_b32 a177, 0
		v_accvgpr_write_b32 a178, 0
		v_accvgpr_write_b32 a179, 0
		v_mov_b64_e32 v[240:241], 0
		v_mov_b64_e32 v[242:243], 0
		v_accvgpr_write_b32 a180, 0
		v_accvgpr_write_b32 a181, 0
		v_accvgpr_write_b32 a182, 0
		v_accvgpr_write_b32 a183, 0
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_lshl_b32 s40, s42, 7
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_b32 s41, s42, 1
		s_lshl_b32 s41, s41, 13
		s_add_i32 s43, s41, 0x20000
		v_add_u32_e32 v166, s43, v9
		v_add_u32_e32 v167, v166, v5
		ds_read_b64_tr_b8 v[240:241], v167
		ds_read_b64_tr_b8 v[242:243], v167 offset:512
		v_add3_u32 v244, s43, v5, v163
		ds_read_b64_tr_b8 v[246:247], v244 offset:2048
		ds_read_b64_tr_b8 v[248:249], v167 offset:4096
		ds_read_b64_tr_b8 v[250:251], v167 offset:4608
		ds_read_b64_tr_b8 v[252:253], v244 offset:6144
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[24:27], v[88:91], v[16:19], v240, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[24:27], v[92:95], v[168:171], v240, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[24:27], v[96:99], v[172:175], v240, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[24:27], v[100:103], v[176:179], v240, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[88:91], v[180:183], v240, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[92:95], v[184:187], v240, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[96:99], v[188:191], v240, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[28:31], v[100:103], v[192:195], v240, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[32:35], v[88:91], v[196:199], v240, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[32:35], v[92:95], v[200:203], v240, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[32:35], v[96:99], v[204:207], v240, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[100:103], v[208:211], v240, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[36:39], v[88:91], v[212:215], v240, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[36:39], v[92:95], v[216:219], v240, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[36:39], v[96:99], v[220:223], v240, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[36:39], v[100:103], v[224:227], v240, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[40:43], v[88:91], v[228:231], v242, v246 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[40:43], v[92:95], v[232:235], v242, v246 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[40:43], v[96:99], v[236:239], v242, v246 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[40:43], v[100:103], a[68:71], v242, v246 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[44:47], v[88:91], a[88:91], v242, v246 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[44:47], v[92:95], a[92:95], v242, v246 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[44:47], v[96:99], a[96:99], v242, v246 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[44:47], v[100:103], a[100:103], v242, v246 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[48:51], v[88:91], a[120:123], v242, v246 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[48:51], v[92:95], a[124:127], v242, v246 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[48:51], v[96:99], a[128:131], v242, v246 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[48:51], v[100:103], a[132:135], v242, v246 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[52:55], v[88:91], a[152:155], v242, v246 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[52:55], v[92:95], a[156:159], v242, v246 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[52:55], v[96:99], a[160:163], v242, v246 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[52:55], v[100:103], a[164:167], v242, v246 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[56:59], v[120:123], v[16:19], v248, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[56:59], v[124:127], v[168:171], v248, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[56:59], v[128:131], v[172:175], v248, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[56:59], v[132:135], v[176:179], v248, v252 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[60:63], v[120:123], v[180:183], v248, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[60:63], v[124:127], v[184:187], v248, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[60:63], v[128:131], v[188:191], v248, v252 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[60:63], v[132:135], v[192:195], v248, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[64:67], v[120:123], v[196:199], v248, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[64:67], v[124:127], v[200:203], v248, v252 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[64:67], v[128:131], v[204:207], v248, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[64:67], v[132:135], v[208:211], v248, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[68:71], v[120:123], v[212:215], v248, v252 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[68:71], v[124:127], v[216:219], v248, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[68:71], v[128:131], v[220:223], v248, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[68:71], v[132:135], v[224:227], v248, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[72:75], v[120:123], v[228:231], v250, v252 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[72:75], v[124:127], v[232:235], v250, v252 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[72:75], v[128:131], v[236:239], v250, v252 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[72:75], v[132:135], a[68:71], v250, v252 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[76:79], v[120:123], a[88:91], v250, v252 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[76:79], v[124:127], a[92:95], v250, v252 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[76:79], v[128:131], a[96:99], v250, v252 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[76:79], v[132:135], a[100:103], v250, v252 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[80:83], v[120:123], a[120:123], v250, v252 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[80:83], v[124:127], a[124:127], v250, v252 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[80:83], v[128:131], a[128:131], v250, v252 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[80:83], v[132:135], a[132:135], v250, v252 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[84:87], v[120:123], a[152:155], v250, v252 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[84:87], v[124:127], a[156:159], v250, v252 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[84:87], v[128:131], a[160:163], v250, v252 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[84:87], v[132:135], a[164:167], v250, v252 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_b64_tr_b8 v[88:89], v244 offset:2560
		ds_read_b64_tr_b8 v[90:91], v244 offset:6656
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_lshl_b32 s43, s42, 15
		s_add_i32 s48, s39, s43
		s_add_i32 s49, s4, s43
		s_add_i32 s50, s41, 0x20200
		s_add_i32 s51, s41, 0x21000
		s_add_i32 s52, s41, 0x21200
		s_and_saveexec_b64 s[54:55], s[44:45]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_4
		buffer_load_dword v92, v10, s[24:27], s48 offen
		buffer_load_dword v93, v10, s[24:27], s48 offen offset:64
		buffer_load_dword v94, v10, s[24:27], s49 offen
		buffer_load_dword v95, v10, s[24:27], s49 offen offset:64
		v_add3_u32 v96, v166, v14, v13
		v_add3_u32 v97, v13, v164, s50
		v_add3_u32 v98, v13, v164, s51
		v_add3_u32 v99, v13, v164, s52
.Lwmma_f16_matmul_tiled.exec_endif_4:
		s_mov_b64 exec, s[54:55]
		s_add_i32 s48, s5, s43
		s_add_i32 s43, s9, s43
		s_add_i32 s49, s41, 0x20800
		v_lshl_add_u32 v100, v7, 7, s49
		s_add_i32 s49, s41, 0x20a00
		s_add_i32 s50, s41, 0x21800
		s_add_i32 s41, s41, 0x21a00
		s_and_saveexec_b64 s[54:55], s[46:47]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_5
		buffer_load_dword v101, v15, s[0:3], s48 offen
		buffer_load_dword v102, v15, s[0:3], s48 offen offset:64
		buffer_load_dword v103, v15, s[0:3], s43 offen
		buffer_load_dword v120, v15, s[0:3], s43 offen offset:64
		v_add3_u32 v121, v100, v13, v163
		v_add3_u32 v122, v163, v165, s49
		v_add3_u32 v123, v163, v165, s50
		v_add3_u32 v124, v163, v165, s41
.Lwmma_f16_matmul_tiled.exec_endif_5:
		s_mov_b64 exec, s[54:55]
		s_mov_b32 m0, s7
		s_nop 0
		buffer_load_dwordx4 v12, s[16:19], s40 offen lds
		s_mov_b32 m0, s6
		s_nop 0
		buffer_load_dwordx4 v20, s[16:19], s40 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[24:27], v[104:107], a[4:7], v240, v88 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[24:27], v[108:111], a[8:11], v240, v88 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[24:27], v[112:115], a[12:15], v240, v88 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s8
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[24:27], v[116:119], a[16:19], v240, v88 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v22, s[16:19], s40 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[28:31], v[104:107], a[20:23], v240, v88 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[28:31], v[108:111], a[24:27], v240, v88 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[28:31], v[112:115], a[28:31], v240, v88 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[28:31], v[116:119], a[32:35], v240, v88 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[32:35], v[104:107], a[36:39], v240, v88 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s10
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[32:35], v[108:111], a[40:43], v240, v88 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v23, s[16:19], s40 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[32:35], v[112:115], a[44:47], v240, v88 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[32:35], v[116:119], a[48:51], v240, v88 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[36:39], v[104:107], a[52:55], v240, v88 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[36:39], v[108:111], a[56:59], v240, v88 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[36:39], v[112:115], a[60:63], v240, v88 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s11
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[36:39], v[116:119], a[64:67], v240, v88 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v152, s[16:19], s40 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[40:43], v[104:107], a[72:75], v242, v88 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[40:43], v[108:111], a[76:79], v242, v88 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[40:43], v[112:115], a[80:83], v242, v88 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[40:43], v[116:119], a[84:87], v242, v88 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[44:47], v[104:107], a[104:107], v242, v88 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s28
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[44:47], v[108:111], a[108:111], v242, v88 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v153, s[16:19], s40 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[44:47], v[112:115], a[112:115], v242, v88 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[44:47], v[116:119], a[116:119], v242, v88 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[48:51], v[104:107], a[136:139], v242, v88 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[48:51], v[108:111], a[140:143], v242, v88 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[48:51], v[112:115], a[144:147], v242, v88 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s29
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[48:51], v[116:119], a[148:151], v242, v88 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v154, s[16:19], s40 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[52:55], v[104:107], a[168:171], v242, v88 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[52:55], v[108:111], a[172:175], v242, v88 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[52:55], v[112:115], a[176:179], v242, v88 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[52:55], v[116:119], a[180:183], v242, v88 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[56:59], v[136:139], a[4:7], v248, v90 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s30
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[56:59], v[140:143], a[8:11], v248, v90 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v155, s[16:19], s40 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[56:59], v[144:147], a[12:15], v248, v90 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[56:59], v[148:151], a[16:19], v248, v90 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[60:63], v[136:139], a[20:23], v248, v90 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[60:63], v[140:143], a[24:27], v248, v90 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[60:63], v[144:147], a[28:31], v248, v90 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s31
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[60:63], v[148:151], a[32:35], v248, v90 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v3, s[20:23], s40 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[64:67], v[136:139], a[36:39], v248, v90 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[64:67], v[140:143], a[40:43], v248, v90 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[64:67], v[144:147], a[44:47], v248, v90 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[64:67], v[148:151], a[48:51], v248, v90 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[68:71], v[136:139], a[52:55], v248, v90 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s33
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[68:71], v[140:143], a[56:59], v248, v90 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v157, s[20:23], s40 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[68:71], v[144:147], a[60:63], v248, v90 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[68:71], v[148:151], a[64:67], v248, v90 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[72:75], v[136:139], a[72:75], v250, v90 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[72:75], v[140:143], a[76:79], v250, v90 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[72:75], v[144:147], a[80:83], v250, v90 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s35
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[72:75], v[148:151], a[84:87], v250, v90 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v159, s[20:23], s40 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[76:79], v[136:139], a[104:107], v250, v90 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[76:79], v[140:143], a[108:111], v250, v90 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[76:79], v[144:147], a[112:115], v250, v90 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[76:79], v[148:151], a[116:119], v250, v90 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[80:83], v[136:139], a[136:139], v250, v90 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s37
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[80:83], v[140:143], a[140:143], v250, v90 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v161, s[20:23], s40 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[80:83], v[144:147], a[144:147], v250, v90 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[80:83], v[148:151], a[148:151], v250, v90 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[84:87], v[136:139], a[168:171], v250, v90 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[84:87], v[140:143], a[172:175], v250, v90 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[84:87], v[144:147], a[176:179], v250, v90 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[84:87], v[148:151], a[180:183], v250, v90 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_saveexec_b64 s[54:55], s[44:45]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_6
		s_waitcnt vmcnt(16)
		ds_write_b32 v96, v92
		ds_write_b32 v97, v93
		ds_write_b32 v98, v94
		ds_write_b32 v99, v95
.Lwmma_f16_matmul_tiled.exec_else_6:
		s_andn2_b64 exec, s[54:55], s[44:45]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_6
.Lwmma_f16_matmul_tiled.exec_endif_6:
		s_mov_b64 exec, s[54:55]
		s_and_saveexec_b64 s[54:55], s[46:47]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_else_7
		s_waitcnt vmcnt(12)
		ds_write_b32 v121, v101
		ds_write_b32 v122, v102
		ds_write_b32 v123, v103
		ds_write_b32 v124, v120
.Lwmma_f16_matmul_tiled.exec_else_7:
		s_andn2_b64 exec, s[54:55], s[46:47]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_7
.Lwmma_f16_matmul_tiled.exec_endif_7:
		s_mov_b64 exec, s[54:55]
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v156, s[20:23], s40 offen lds
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v158, s[20:23], s40 offen lds
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v160, s[20:23], s40 offen lds
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v162, s[20:23], s40 offen lds
		s_waitcnt vmcnt(24)
		s_barrier
		s_add_i32 s42, s42, 1
		s_and_b32 s40, s42, 1
		s_lshl_b32 s40, s40, 16
		v_add_u32_e32 v24, s40, v2
		v_add3_u32 v88, v24, v6, v8
		ds_read_b128 v[24:27], v88
		ds_read_b128 v[28:31], v88 offset:1024
		ds_read_b128 v[32:35], v88 offset:2048
		ds_read_b128 v[36:39], v88 offset:3072
		ds_read_b128 v[40:43], v88 offset:4096
		ds_read_b128 v[44:47], v88 offset:5120
		ds_read_b128 v[48:51], v88 offset:6144
		ds_read_b128 v[52:55], v88 offset:7168
		ds_read_b128 v[56:59], v88 offset:16384
		ds_read_b128 v[60:63], v88 offset:17408
		ds_read_b128 v[64:67], v88 offset:18432
		ds_read_b128 v[68:71], v88 offset:19456
		ds_read_b128 v[72:75], v88 offset:20480
		ds_read_b128 v[76:79], v88 offset:21504
		ds_read_b128 v[80:83], v88 offset:22528
		ds_read_b128 v[84:87], v88 offset:23552
		v_add_u32_e32 v88, s40, v6
		v_add3_u32 v166, v88, v11, v8
		ds_read_b128 v[88:91], v166 offset:32768
		ds_read_b128 v[92:95], v166 offset:33792
		ds_read_b128 v[96:99], v166 offset:34816
		ds_read_b128 v[100:103], v166 offset:35840
		ds_read_b128 v[104:107], v166 offset:36864
		ds_read_b128 v[108:111], v166 offset:37888
		ds_read_b128 v[112:115], v166 offset:38912
		ds_read_b128 v[116:119], v166 offset:39936
		ds_read_b128 v[120:123], v166 offset:49152
		ds_read_b128 v[124:127], v166 offset:50176
		ds_read_b128 v[128:131], v166 offset:51200
		ds_read_b128 v[132:135], v166 offset:52224
		ds_read_b128 v[136:139], v166 offset:53248
		ds_read_b128 v[140:143], v166 offset:54272
		ds_read_b128 v[144:147], v166 offset:55296
		ds_read_b128 v[148:151], v166 offset:56320
		s_add_i32 s7, s7, 0x10000
		s_and_b32 s7, s7, 0x1ffff
		s_add_i32 s6, s6, 0x10000
		s_and_b32 s6, s6, 0x1ffff
		s_add_i32 s8, s8, 0x10000
		s_and_b32 s8, s8, 0x1ffff
		s_add_i32 s10, s10, 0x10000
		s_and_b32 s10, s10, 0x1ffff
		s_add_i32 s11, s11, 0x10000
		s_and_b32 s11, s11, 0x1ffff
		s_add_i32 s28, s28, 0x10000
		s_and_b32 s28, s28, 0x1ffff
		s_add_i32 s29, s29, 0x10000
		s_and_b32 s29, s29, 0x1ffff
		s_add_i32 s30, s30, 0x10000
		s_and_b32 s30, s30, 0x1ffff
		s_add_i32 s31, s31, 0x10000
		s_and_b32 s31, s31, 0x1ffff
		s_add_i32 s33, s33, 0x10000
		s_and_b32 s33, s33, 0x1ffff
		s_add_i32 s35, s35, 0x10000
		s_and_b32 s35, s35, 0x1ffff
		s_add_i32 s37, s37, 0x10000
		s_and_b32 s37, s37, 0x1ffff
		s_add_i32 s32, s32, 0x10000
		s_and_b32 s32, s32, 0x1ffff
		s_add_i32 s34, s34, 0x10000
		s_and_b32 s34, s34, 0x1ffff
		s_add_i32 s36, s36, 0x10000
		s_and_b32 s36, s36, 0x1ffff
		s_add_i32 s38, s38, 0x10000
		s_and_b32 s38, s38, 0x1ffff
		s_cmp_lt_i32 s42, 30
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v3, a0
		v_add_u32_e32 v3, v3, v5
		ds_read_b64_tr_b8 v[12:13], v3
		ds_read_b64_tr_b8 v[14:15], v3 offset:512
		v_add_u32_e32 v7, 0x20000, v5
		v_lshl_add_u32 v7, v21, 10, v7
		ds_read_b64_tr_b8 v[20:21], v7 offset:2048
		ds_read_b64_tr_b8 v[22:23], v7 offset:2560
		ds_read_b64_tr_b8 v[152:153], v3 offset:4096
		ds_read_b64_tr_b8 v[154:155], v3 offset:4608
		ds_read_b64_tr_b8 v[156:157], v7 offset:6144
		ds_read_b64_tr_b8 v[158:159], v7 offset:6656
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[24:27], v[88:91], v[16:19], v12, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[24:27], v[92:95], v[168:171], v12, v20 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[24:27], v[96:99], v[172:175], v12, v20 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[24:27], v[100:103], v[176:179], v12, v20 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[24:27], v[104:107], a[4:7], v12, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[24:27], v[108:111], a[8:11], v12, v22 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[24:27], v[112:115], a[12:15], v12, v22 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[24:27], v[116:119], a[16:19], v12, v22 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[88:91], v[180:183], v12, v20 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[92:95], v[184:187], v12, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[96:99], v[188:191], v12, v20 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[28:31], v[100:103], v[192:195], v12, v20 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[28:31], v[104:107], a[20:23], v12, v22 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[28:31], v[108:111], a[24:27], v12, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[28:31], v[112:115], a[28:31], v12, v22 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[28:31], v[116:119], a[32:35], v12, v22 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[32:35], v[88:91], v[196:199], v12, v20 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[32:35], v[92:95], v[200:203], v12, v20 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[32:35], v[96:99], v[204:207], v12, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[100:103], v[208:211], v12, v20 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[32:35], v[104:107], a[36:39], v12, v22 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[32:35], v[108:111], a[40:43], v12, v22 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[32:35], v[112:115], a[44:47], v12, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[32:35], v[116:119], a[48:51], v12, v22 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[36:39], v[88:91], v[212:215], v12, v20 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[36:39], v[92:95], v[216:219], v12, v20 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[36:39], v[96:99], v[220:223], v12, v20 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[36:39], v[100:103], v[224:227], v12, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[36:39], v[104:107], a[52:55], v12, v22 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[36:39], v[108:111], a[56:59], v12, v22 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[36:39], v[112:115], a[60:63], v12, v22 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[36:39], v[116:119], a[64:67], v12, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[40:43], v[88:91], v[228:231], v14, v20 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[40:43], v[92:95], v[232:235], v14, v20 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[40:43], v[96:99], v[236:239], v14, v20 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[40:43], v[100:103], a[68:71], v14, v20 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[40:43], v[104:107], a[72:75], v14, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[40:43], v[108:111], a[76:79], v14, v22 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[40:43], v[112:115], a[80:83], v14, v22 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[40:43], v[116:119], a[84:87], v14, v22 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[44:47], v[88:91], a[88:91], v14, v20 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[44:47], v[92:95], a[92:95], v14, v20 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[44:47], v[96:99], a[96:99], v14, v20 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[44:47], v[100:103], a[100:103], v14, v20 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[44:47], v[104:107], a[104:107], v14, v22 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[44:47], v[108:111], a[108:111], v14, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[44:47], v[112:115], a[112:115], v14, v22 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[44:47], v[116:119], a[116:119], v14, v22 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[48:51], v[88:91], a[120:123], v14, v20 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[48:51], v[92:95], a[124:127], v14, v20 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[48:51], v[96:99], a[128:131], v14, v20 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[48:51], v[100:103], a[132:135], v14, v20 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[48:51], v[104:107], a[136:139], v14, v22 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[48:51], v[108:111], a[140:143], v14, v22 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[48:51], v[112:115], a[144:147], v14, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[48:51], v[116:119], a[148:151], v14, v22 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[52:55], v[88:91], a[152:155], v14, v20 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[52:55], v[92:95], a[156:159], v14, v20 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[52:55], v[96:99], a[160:163], v14, v20 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[52:55], v[100:103], a[164:167], v14, v20 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[52:55], v[104:107], a[168:171], v14, v22 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[52:55], v[108:111], a[172:175], v14, v22 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[52:55], v[112:115], a[176:179], v14, v22 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[52:55], v[116:119], a[180:183], v14, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[56:59], v[120:123], v[16:19], v152, v156 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[56:59], v[124:127], v[168:171], v152, v156 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[56:59], v[128:131], v[172:175], v152, v156 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[56:59], v[132:135], v[176:179], v152, v156 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[56:59], v[136:139], a[4:7], v152, v158 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[56:59], v[140:143], a[8:11], v152, v158 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[56:59], v[144:147], a[12:15], v152, v158 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[56:59], v[148:151], a[16:19], v152, v158 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[60:63], v[120:123], v[180:183], v152, v156 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[60:63], v[124:127], v[184:187], v152, v156 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[60:63], v[128:131], v[188:191], v152, v156 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[60:63], v[132:135], v[192:195], v152, v156 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[60:63], v[136:139], a[20:23], v152, v158 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[60:63], v[140:143], a[24:27], v152, v158 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[60:63], v[144:147], a[28:31], v152, v158 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[60:63], v[148:151], a[32:35], v152, v158 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[64:67], v[120:123], v[196:199], v152, v156 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[64:67], v[124:127], v[200:203], v152, v156 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[64:67], v[128:131], v[204:207], v152, v156 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[64:67], v[132:135], v[208:211], v152, v156 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[64:67], v[136:139], a[36:39], v152, v158 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[64:67], v[140:143], a[40:43], v152, v158 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[64:67], v[144:147], a[44:47], v152, v158 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[64:67], v[148:151], a[48:51], v152, v158 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[68:71], v[120:123], v[212:215], v152, v156 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[68:71], v[124:127], v[216:219], v152, v156 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[68:71], v[128:131], v[220:223], v152, v156 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[68:71], v[132:135], v[224:227], v152, v156 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[68:71], v[136:139], a[52:55], v152, v158 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[68:71], v[140:143], a[56:59], v152, v158 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[68:71], v[144:147], a[60:63], v152, v158 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[68:71], v[148:151], a[64:67], v152, v158 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[72:75], v[120:123], v[228:231], v154, v156 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[72:75], v[124:127], v[232:235], v154, v156 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[72:75], v[128:131], v[236:239], v154, v156 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[72:75], v[132:135], a[68:71], v154, v156 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[72:75], v[136:139], a[72:75], v154, v158 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[72:75], v[140:143], a[76:79], v154, v158 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[72:75], v[144:147], a[80:83], v154, v158 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[72:75], v[148:151], a[84:87], v154, v158 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[76:79], v[120:123], a[88:91], v154, v156 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[76:79], v[124:127], a[92:95], v154, v156 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[76:79], v[128:131], a[96:99], v154, v156 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[76:79], v[132:135], a[100:103], v154, v156 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[76:79], v[136:139], a[104:107], v154, v158 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[76:79], v[140:143], a[108:111], v154, v158 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[76:79], v[144:147], a[112:115], v154, v158 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[76:79], v[148:151], a[116:119], v154, v158 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[80:83], v[120:123], a[120:123], v154, v156 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[80:83], v[124:127], a[124:127], v154, v156 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[80:83], v[128:131], a[128:131], v154, v156 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[80:83], v[132:135], a[132:135], v154, v156 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[80:83], v[136:139], a[136:139], v154, v158 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[80:83], v[140:143], a[140:143], v154, v158 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[80:83], v[144:147], a[144:147], v154, v158 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[80:83], v[148:151], a[148:151], v154, v158 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[84:87], v[120:123], a[152:155], v154, v156 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[84:87], v[124:127], a[156:159], v154, v156 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[84:87], v[128:131], a[160:163], v154, v156 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[84:87], v[132:135], a[164:167], v154, v156 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[84:87], v[136:139], a[168:171], v154, v158 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[84:87], v[140:143], a[172:175], v154, v158 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[84:87], v[144:147], a[176:179], v154, v158 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[84:87], v[148:151], a[180:183], v154, v158 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		v_add_u32_e32 v2, 0x10000, v2
		v_add3_u32 v2, v2, v6, v8
		ds_read_b128 v[12:15], v2
		ds_read_b128 v[20:23], v2 offset:1024
		ds_read_b128 v[24:27], v2 offset:2048
		ds_read_b128 v[28:31], v2 offset:3072
		ds_read_b128 v[32:35], v2 offset:4096
		ds_read_b128 v[36:39], v2 offset:5120
		ds_read_b128 v[40:43], v2 offset:6144
		ds_read_b128 v[44:47], v2 offset:7168
		ds_read_b128 v[48:51], v2 offset:16384
		ds_read_b128 v[52:55], v2 offset:17408
		ds_read_b128 v[56:59], v2 offset:18432
		ds_read_b128 v[60:63], v2 offset:19456
		ds_read_b128 v[64:67], v2 offset:20480
		ds_read_b128 v[68:71], v2 offset:21504
		ds_read_b128 v[72:75], v2 offset:22528
		ds_read_b128 v[76:79], v2 offset:23552
		v_add_u32_e32 v2, 0x10000, v6
		v_add3_u32 v2, v2, v11, v8
		ds_read_b128 v[8:11], v2 offset:32768
		ds_read_b128 v[80:83], v2 offset:33792
		ds_read_b128 v[84:87], v2 offset:34816
		ds_read_b128 v[88:91], v2 offset:35840
		ds_read_b128 v[92:95], v2 offset:36864
		ds_read_b128 v[96:99], v2 offset:37888
		ds_read_b128 v[100:103], v2 offset:38912
		ds_read_b128 v[104:107], v2 offset:39936
		ds_read_b128 v[108:111], v2 offset:49152
		ds_read_b128 v[112:115], v2 offset:50176
		ds_read_b128 v[116:119], v2 offset:51200
		ds_read_b128 v[120:123], v2 offset:52224
		ds_read_b128 v[124:127], v2 offset:53248
		ds_read_b128 v[128:131], v2 offset:54272
		ds_read_b128 v[132:135], v2 offset:55296
		ds_read_b128 v[136:139], v2 offset:56320
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b64_tr_b8 v[140:141], v3 offset:8192
		ds_read_b64_tr_b8 v[142:143], v3 offset:8704
		ds_read_b64_tr_b8 v[144:145], v7 offset:10240
		ds_read_b64_tr_b8 v[146:147], v7 offset:10752
		ds_read_b64_tr_b8 v[148:149], v3 offset:12288
		ds_read_b64_tr_b8 v[150:151], v3 offset:12800
		ds_read_b64_tr_b8 v[2:3], v7 offset:14336
		ds_read_b64_tr_b8 v[152:153], v7 offset:14848
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[12:15], v[8:11], v[16:19], v140, v144 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[12:15], v[80:83], v[168:171], v140, v144 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[12:15], v[84:87], v[172:175], v140, v144 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[12:15], v[88:91], v[176:179], v140, v144 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[20:23], v[8:11], v[180:183], v140, v144 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[20:23], v[80:83], v[184:187], v140, v144 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[20:23], v[84:87], v[188:191], v140, v144 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[20:23], v[88:91], v[192:195], v140, v144 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[8:11], v[196:199], v140, v144 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[80:83], v[200:203], v140, v144 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[84:87], v[204:207], v140, v144 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], v[88:91], v[208:211], v140, v144 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[8:11], v[212:215], v140, v144 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[28:31], v[80:83], v[216:219], v140, v144 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[28:31], v[84:87], v[220:223], v140, v144 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[88:91], v[224:227], v140, v144 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], v[8:11], v[228:231], v142, v144 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[32:35], v[80:83], v[232:235], v142, v144 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[32:35], v[84:87], v[236:239], v142, v144 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[32:35], v[88:91], a[68:71], v142, v144 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[36:39], v[8:11], a[88:91], v142, v144 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[36:39], v[80:83], a[92:95], v142, v144 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[36:39], v[84:87], a[96:99], v142, v144 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[36:39], v[88:91], a[100:103], v142, v144 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[40:43], v[8:11], a[120:123], v142, v144 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[40:43], v[80:83], a[124:127], v142, v144 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[40:43], v[84:87], a[128:131], v142, v144 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[40:43], v[88:91], a[132:135], v142, v144 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[44:47], v[8:11], a[152:155], v142, v144 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[44:47], v[80:83], a[156:159], v142, v144 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[44:47], v[84:87], a[160:163], v142, v144 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[44:47], v[88:91], a[164:167], v142, v144 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[48:51], v[108:111], v[16:19], v148, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[48:51], v[112:115], v[168:171], v148, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[48:51], v[116:119], v[172:175], v148, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[48:51], v[120:123], v[176:179], v148, v2 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[52:55], v[108:111], v[180:183], v148, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[52:55], v[112:115], v[184:187], v148, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[52:55], v[116:119], v[188:191], v148, v2 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[52:55], v[120:123], v[192:195], v148, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[56:59], v[108:111], v[196:199], v148, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[56:59], v[112:115], v[200:203], v148, v2 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[56:59], v[116:119], v[204:207], v148, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[56:59], v[120:123], v[208:211], v148, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[60:63], v[108:111], v[212:215], v148, v2 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[60:63], v[112:115], v[216:219], v148, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[60:63], v[116:119], v[220:223], v148, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[60:63], v[120:123], v[224:227], v148, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[64:67], v[108:111], v[228:231], v150, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[64:67], v[112:115], v[232:235], v150, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[64:67], v[116:119], v[236:239], v150, v2 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[64:67], v[120:123], a[68:71], v150, v2 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[68:71], v[108:111], a[88:91], v150, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[68:71], v[112:115], a[92:95], v150, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[68:71], v[116:119], a[96:99], v150, v2 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[68:71], v[120:123], a[100:103], v150, v2 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[72:75], v[108:111], a[120:123], v150, v2 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[72:75], v[112:115], a[124:127], v150, v2 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[72:75], v[116:119], a[128:131], v150, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[72:75], v[120:123], a[132:135], v150, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[76:79], v[108:111], a[152:155], v150, v2 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[76:79], v[112:115], a[156:159], v150, v2 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[76:79], v[116:119], a[160:163], v150, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[76:79], v[120:123], a[164:167], v150, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_cvt_pk_f16_f32 v2, v16, v17
		v_cvt_pk_f16_f32 v3, v18, v19
		v_lshlrev_b32_e32 v4, 15, v4
		v_add_u32_e32 v5, v4, v5
		ds_write_b64 v5, v[2:3]
		v_cvt_pk_f16_f32 v2, v168, v169
		v_cvt_pk_f16_f32 v3, v170, v171
		ds_write_b64 v5, v[2:3] offset:512
		v_cvt_pk_f16_f32 v2, v172, v173
		v_cvt_pk_f16_f32 v3, v174, v175
		ds_write_b64 v5, v[2:3] offset:1024
		v_cvt_pk_f16_f32 v2, v176, v177
		v_cvt_pk_f16_f32 v3, v178, v179
		ds_write_b64 v5, v[2:3] offset:1536
		v_cvt_pk_f16_f32 v2, v180, v181
		v_cvt_pk_f16_f32 v3, v182, v183
		ds_write_b64 v5, v[2:3] offset:4096
		v_cvt_pk_f16_f32 v2, v184, v185
		v_cvt_pk_f16_f32 v3, v186, v187
		ds_write_b64 v5, v[2:3] offset:4608
		v_cvt_pk_f16_f32 v2, v188, v189
		v_cvt_pk_f16_f32 v3, v190, v191
		ds_write_b64 v5, v[2:3] offset:5120
		v_cvt_pk_f16_f32 v2, v192, v193
		v_cvt_pk_f16_f32 v3, v194, v195
		ds_write_b64 v5, v[2:3] offset:5632
		v_cvt_pk_f16_f32 v2, v196, v197
		v_cvt_pk_f16_f32 v3, v198, v199
		ds_write_b64 v5, v[2:3] offset:8192
		v_cvt_pk_f16_f32 v2, v200, v201
		v_cvt_pk_f16_f32 v3, v202, v203
		ds_write_b64 v5, v[2:3] offset:8704
		v_cvt_pk_f16_f32 v2, v204, v205
		v_cvt_pk_f16_f32 v3, v206, v207
		ds_write_b64 v5, v[2:3] offset:9216
		v_cvt_pk_f16_f32 v2, v208, v209
		v_cvt_pk_f16_f32 v3, v210, v211
		ds_write_b64 v5, v[2:3] offset:9728
		v_cvt_pk_f16_f32 v2, v212, v213
		v_cvt_pk_f16_f32 v3, v214, v215
		ds_write_b64 v5, v[2:3] offset:12288
		v_cvt_pk_f16_f32 v2, v216, v217
		v_cvt_pk_f16_f32 v3, v218, v219
		ds_write_b64 v5, v[2:3] offset:12800
		v_cvt_pk_f16_f32 v2, v220, v221
		v_cvt_pk_f16_f32 v3, v222, v223
		ds_write_b64 v5, v[2:3] offset:13312
		v_cvt_pk_f16_f32 v2, v224, v225
		v_cvt_pk_f16_f32 v3, v226, v227
		ds_write_b64 v5, v[2:3] offset:13824
		v_cvt_pk_f16_f32 v2, v228, v229
		v_cvt_pk_f16_f32 v3, v230, v231
		ds_write_b64 v5, v[2:3] offset:16384
		v_cvt_pk_f16_f32 v2, v232, v233
		v_cvt_pk_f16_f32 v3, v234, v235
		ds_write_b64 v5, v[2:3] offset:16896
		v_cvt_pk_f16_f32 v2, v236, v237
		v_cvt_pk_f16_f32 v3, v238, v239
		ds_write_b64 v5, v[2:3] offset:17408
		v_accvgpr_read_b32 v2, a68
		v_accvgpr_read_b32 v3, a69
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a70
		v_accvgpr_read_b32 v3, a71
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v5, v[6:7] offset:17920
		v_accvgpr_read_b32 v2, a88
		v_accvgpr_read_b32 v3, a89
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a90
		v_accvgpr_read_b32 v3, a91
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v5, v[6:7] offset:20480
		v_accvgpr_read_b32 v2, a92
		v_accvgpr_read_b32 v3, a93
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a94
		v_accvgpr_read_b32 v3, a95
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v5, v[6:7] offset:20992
		v_accvgpr_read_b32 v2, a96
		v_accvgpr_read_b32 v3, a97
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a98
		v_accvgpr_read_b32 v3, a99
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v5, v[6:7] offset:21504
		v_accvgpr_read_b32 v2, a100
		v_accvgpr_read_b32 v3, a101
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a102
		v_accvgpr_read_b32 v3, a103
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v5, v[6:7] offset:22016
		v_accvgpr_read_b32 v2, a120
		v_accvgpr_read_b32 v3, a121
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a122
		v_accvgpr_read_b32 v3, a123
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v5, v[6:7] offset:24576
		v_accvgpr_read_b32 v2, a124
		v_accvgpr_read_b32 v3, a125
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a126
		v_accvgpr_read_b32 v3, a127
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v5, v[6:7] offset:25088
		v_accvgpr_read_b32 v2, a128
		v_accvgpr_read_b32 v3, a129
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a130
		v_accvgpr_read_b32 v3, a131
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v5, v[6:7] offset:25600
		v_accvgpr_read_b32 v2, a132
		v_accvgpr_read_b32 v3, a133
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a134
		v_accvgpr_read_b32 v3, a135
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v5, v[6:7] offset:26112
		v_accvgpr_read_b32 v2, a152
		v_accvgpr_read_b32 v3, a153
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a154
		v_accvgpr_read_b32 v3, a155
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v5, v[6:7] offset:28672
		v_accvgpr_read_b32 v2, a156
		v_accvgpr_read_b32 v3, a157
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a158
		v_accvgpr_read_b32 v3, a159
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v5, v[6:7] offset:29184
		v_accvgpr_read_b32 v2, a160
		v_accvgpr_read_b32 v3, a161
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a162
		v_accvgpr_read_b32 v3, a163
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v5, v[6:7] offset:29696
		v_accvgpr_read_b32 v2, a164
		v_accvgpr_read_b32 v3, a165
		v_cvt_pk_f16_f32 v6, v2, v3
		v_accvgpr_read_b32 v2, a166
		v_accvgpr_read_b32 v3, a167
		v_cvt_pk_f16_f32 v7, v2, v3
		ds_write_b64 v5, v[6:7] offset:30208
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v0, 63, v0
		s_mov_b32 s0, 32
		v_cmp_lt_u32_e64 vcc, v0, s0
		s_mov_b64 s[2:3], vcc
		v_lshl_add_u32 v0, v1, 4, v4
		s_mov_b32 s0, 0x1000
		s_mov_b32 s1, 0x2000
		s_mov_b32 s4, 0x3000
		s_mov_b32 s5, 0x4000
		s_mov_b32 s6, 0x5000
		s_mov_b32 s7, 0x6000
		s_mov_b32 s8, 0x7000
		s_and_saveexec_b64 s[54:55], s[2:3]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_8
		ds_read_b128 v[8:11], v0
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], 0 offen
		ds_read_b128 v[8:11], v0 offset:512
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], 0 offen offset:512
		ds_read_b128 v[8:11], v0 offset:1024
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], 0 offen offset:1024
		ds_read_b128 v[8:11], v0 offset:1536
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], 0 offen offset:1536
		ds_read_b128 v[8:11], v0 offset:4096
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], s0 offen
		ds_read_b128 v[8:11], v0 offset:4608
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], s0 offen offset:512
		ds_read_b128 v[8:11], v0 offset:5120
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], s0 offen offset:1024
		ds_read_b128 v[8:11], v0 offset:5632
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], s0 offen offset:1536
		ds_read_b128 v[8:11], v0 offset:8192
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], s1 offen
		ds_read_b128 v[8:11], v0 offset:8704
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], s1 offen offset:512
		ds_read_b128 v[8:11], v0 offset:9216
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], s1 offen offset:1024
		ds_read_b128 v[8:11], v0 offset:9728
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], s1 offen offset:1536
		ds_read_b128 v[8:11], v0 offset:12288
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], s4 offen
		ds_read_b128 v[8:11], v0 offset:12800
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], s4 offen offset:512
		ds_read_b128 v[8:11], v0 offset:13312
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], s4 offen offset:1024
		ds_read_b128 v[8:11], v0 offset:13824
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], s4 offen offset:1536
		ds_read_b128 v[8:11], v0 offset:16384
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], s5 offen
		ds_read_b128 v[8:11], v0 offset:16896
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], s5 offen offset:512
		ds_read_b128 v[8:11], v0 offset:17408
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], s5 offen offset:1024
		ds_read_b128 v[8:11], v0 offset:17920
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], s5 offen offset:1536
		ds_read_b128 v[8:11], v0 offset:20480
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], s6 offen
		ds_read_b128 v[8:11], v0 offset:20992
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], s6 offen offset:512
		ds_read_b128 v[8:11], v0 offset:21504
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], s6 offen offset:1024
		ds_read_b128 v[8:11], v0 offset:22016
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], s6 offen offset:1536
		ds_read_b128 v[8:11], v0 offset:24576
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], s7 offen
		ds_read_b128 v[8:11], v0 offset:25088
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], s7 offen offset:512
		ds_read_b128 v[8:11], v0 offset:25600
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], s7 offen offset:1024
		ds_read_b128 v[8:11], v0 offset:26112
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], s7 offen offset:1536
		ds_read_b128 v[8:11], v0 offset:28672
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], s8 offen
		ds_read_b128 v[8:11], v0 offset:29184
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], s8 offen offset:512
		ds_read_b128 v[8:11], v0 offset:29696
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], s8 offen offset:1024
		ds_read_b128 v[8:11], v0 offset:30208
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[8:11], v0, s[12:15], s8 offen offset:1536
.Lwmma_f16_matmul_tiled.exec_endif_8:
		s_mov_b64 exec, s[54:55]
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[12:15], v[92:95], a[4:7], v140, v146 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[12:15], v[96:99], a[8:11], v140, v146 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[12:15], v[100:103], a[12:15], v140, v146 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[12:15], v[104:107], a[16:19], v140, v146 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[20:23], v[92:95], a[20:23], v140, v146 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[20:23], v[96:99], a[24:27], v140, v146 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[20:23], v[100:103], a[28:31], v140, v146 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[20:23], v[104:107], a[32:35], v140, v146 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[24:27], v[92:95], a[36:39], v140, v146 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[24:27], v[96:99], a[40:43], v140, v146 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[24:27], v[100:103], a[44:47], v140, v146 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[24:27], v[104:107], a[48:51], v140, v146 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[28:31], v[92:95], a[52:55], v140, v146 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[28:31], v[96:99], a[56:59], v140, v146 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[28:31], v[100:103], a[60:63], v140, v146 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[28:31], v[104:107], a[64:67], v140, v146 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[32:35], v[92:95], a[72:75], v142, v146 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[32:35], v[96:99], a[76:79], v142, v146 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[32:35], v[100:103], a[80:83], v142, v146 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[32:35], v[104:107], a[84:87], v142, v146 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[36:39], v[92:95], a[104:107], v142, v146 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[36:39], v[96:99], a[108:111], v142, v146 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[36:39], v[100:103], a[112:115], v142, v146 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[36:39], v[104:107], a[116:119], v142, v146 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[40:43], v[92:95], a[136:139], v142, v146 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[40:43], v[96:99], a[140:143], v142, v146 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[40:43], v[100:103], a[144:147], v142, v146 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[40:43], v[104:107], a[148:151], v142, v146 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[44:47], v[92:95], a[168:171], v142, v146 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[44:47], v[96:99], a[172:175], v142, v146 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[44:47], v[100:103], a[176:179], v142, v146 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[44:47], v[104:107], a[180:183], v142, v146 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[48:51], v[124:127], a[4:7], v148, v152 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[48:51], v[128:131], a[8:11], v148, v152 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[48:51], v[132:135], a[12:15], v148, v152 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[48:51], v[136:139], a[16:19], v148, v152 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[52:55], v[124:127], a[20:23], v148, v152 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[52:55], v[128:131], a[24:27], v148, v152 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[52:55], v[132:135], a[28:31], v148, v152 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[52:55], v[136:139], a[32:35], v148, v152 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[56:59], v[124:127], a[36:39], v148, v152 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[56:59], v[128:131], a[40:43], v148, v152 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[56:59], v[132:135], a[44:47], v148, v152 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[56:59], v[136:139], a[48:51], v148, v152 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[60:63], v[124:127], a[52:55], v148, v152 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[60:63], v[128:131], a[56:59], v148, v152 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[60:63], v[132:135], a[60:63], v148, v152 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[60:63], v[136:139], a[64:67], v148, v152 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[64:67], v[124:127], a[72:75], v150, v152 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[64:67], v[128:131], a[76:79], v150, v152 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[64:67], v[132:135], a[80:83], v150, v152 op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[64:67], v[136:139], a[84:87], v150, v152 op_sel:[0,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[68:71], v[124:127], a[104:107], v150, v152 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[68:71], v[128:131], a[108:111], v150, v152 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[68:71], v[132:135], a[112:115], v150, v152 op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[68:71], v[136:139], a[116:119], v150, v152 op_sel:[1,1,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[72:75], v[124:127], a[136:139], v150, v152 op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[72:75], v[128:131], a[140:143], v150, v152 op_sel:[0,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[72:75], v[132:135], a[144:147], v150, v152 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[72:75], v[136:139], a[148:151], v150, v152 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[76:79], v[124:127], a[168:171], v150, v152 op_sel:[1,0,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[76:79], v[128:131], a[172:175], v150, v152 op_sel:[1,1,0] op_sel_hi:[1,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[76:79], v[132:135], a[176:179], v150, v152 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[76:79], v[136:139], a[180:183], v150, v152 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v1, a4
		v_accvgpr_read_b32 v2, a5
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a6
		v_accvgpr_read_b32 v2, a7
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:2048
		v_accvgpr_read_b32 v1, a8
		v_accvgpr_read_b32 v2, a9
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a10
		v_accvgpr_read_b32 v2, a11
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:2560
		v_accvgpr_read_b32 v1, a12
		v_accvgpr_read_b32 v2, a13
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a14
		v_accvgpr_read_b32 v2, a15
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:3072
		v_accvgpr_read_b32 v1, a16
		v_accvgpr_read_b32 v2, a17
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a18
		v_accvgpr_read_b32 v2, a19
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:3584
		v_accvgpr_read_b32 v1, a20
		v_accvgpr_read_b32 v2, a21
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a22
		v_accvgpr_read_b32 v2, a23
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:6144
		v_accvgpr_read_b32 v1, a24
		v_accvgpr_read_b32 v2, a25
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a26
		v_accvgpr_read_b32 v2, a27
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:6656
		v_accvgpr_read_b32 v1, a28
		v_accvgpr_read_b32 v2, a29
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a30
		v_accvgpr_read_b32 v2, a31
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:7168
		v_accvgpr_read_b32 v1, a32
		v_accvgpr_read_b32 v2, a33
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a34
		v_accvgpr_read_b32 v2, a35
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:7680
		v_accvgpr_read_b32 v1, a36
		v_accvgpr_read_b32 v2, a37
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a38
		v_accvgpr_read_b32 v2, a39
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:10240
		v_accvgpr_read_b32 v1, a40
		v_accvgpr_read_b32 v2, a41
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a42
		v_accvgpr_read_b32 v2, a43
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:10752
		v_accvgpr_read_b32 v1, a44
		v_accvgpr_read_b32 v2, a45
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a46
		v_accvgpr_read_b32 v2, a47
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:11264
		v_accvgpr_read_b32 v1, a48
		v_accvgpr_read_b32 v2, a49
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a50
		v_accvgpr_read_b32 v2, a51
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:11776
		v_accvgpr_read_b32 v1, a52
		v_accvgpr_read_b32 v2, a53
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a54
		v_accvgpr_read_b32 v2, a55
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:14336
		v_accvgpr_read_b32 v1, a56
		v_accvgpr_read_b32 v2, a57
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a58
		v_accvgpr_read_b32 v2, a59
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:14848
		v_accvgpr_read_b32 v1, a60
		v_accvgpr_read_b32 v2, a61
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a62
		v_accvgpr_read_b32 v2, a63
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:15360
		v_accvgpr_read_b32 v1, a64
		v_accvgpr_read_b32 v2, a65
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a66
		v_accvgpr_read_b32 v2, a67
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:15872
		v_accvgpr_read_b32 v1, a72
		v_accvgpr_read_b32 v2, a73
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a74
		v_accvgpr_read_b32 v2, a75
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:18432
		v_accvgpr_read_b32 v1, a76
		v_accvgpr_read_b32 v2, a77
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a78
		v_accvgpr_read_b32 v2, a79
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:18944
		v_accvgpr_read_b32 v1, a80
		v_accvgpr_read_b32 v2, a81
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a82
		v_accvgpr_read_b32 v2, a83
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:19456
		v_accvgpr_read_b32 v1, a84
		v_accvgpr_read_b32 v2, a85
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a86
		v_accvgpr_read_b32 v2, a87
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:19968
		v_accvgpr_read_b32 v1, a104
		v_accvgpr_read_b32 v2, a105
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a106
		v_accvgpr_read_b32 v2, a107
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:22528
		v_accvgpr_read_b32 v1, a108
		v_accvgpr_read_b32 v2, a109
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a110
		v_accvgpr_read_b32 v2, a111
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:23040
		v_accvgpr_read_b32 v1, a112
		v_accvgpr_read_b32 v2, a113
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a114
		v_accvgpr_read_b32 v2, a115
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:23552
		v_accvgpr_read_b32 v1, a116
		v_accvgpr_read_b32 v2, a117
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a118
		v_accvgpr_read_b32 v2, a119
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:24064
		v_accvgpr_read_b32 v1, a136
		v_accvgpr_read_b32 v2, a137
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a138
		v_accvgpr_read_b32 v2, a139
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:26624
		v_accvgpr_read_b32 v1, a140
		v_accvgpr_read_b32 v2, a141
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a142
		v_accvgpr_read_b32 v2, a143
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:27136
		v_accvgpr_read_b32 v1, a144
		v_accvgpr_read_b32 v2, a145
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a146
		v_accvgpr_read_b32 v2, a147
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:27648
		v_accvgpr_read_b32 v1, a148
		v_accvgpr_read_b32 v2, a149
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a150
		v_accvgpr_read_b32 v2, a151
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:28160
		v_accvgpr_read_b32 v1, a168
		v_accvgpr_read_b32 v2, a169
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a170
		v_accvgpr_read_b32 v2, a171
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:30720
		v_accvgpr_read_b32 v1, a172
		v_accvgpr_read_b32 v2, a173
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a174
		v_accvgpr_read_b32 v2, a175
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:31232
		v_accvgpr_read_b32 v1, a176
		v_accvgpr_read_b32 v2, a177
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a178
		v_accvgpr_read_b32 v2, a179
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:31744
		v_accvgpr_read_b32 v1, a180
		v_accvgpr_read_b32 v2, a181
		v_cvt_pk_f16_f32 v6, v1, v2
		v_accvgpr_read_b32 v1, a182
		v_accvgpr_read_b32 v2, a183
		v_cvt_pk_f16_f32 v7, v1, v2
		ds_write_b64 v5, v[6:7] offset:32256
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_and_saveexec_b64 s[54:55], s[2:3]
		s_cbranch_execz .Lwmma_f16_matmul_tiled.exec_endif_9
		ds_read_b128 v[4:7], v0 offset:2048
		ds_read_b128 v[8:11], v0 offset:2560
		ds_read_b128 v[12:15], v0 offset:3072
		ds_read_b128 v[16:19], v0 offset:3584
		ds_read_b128 v[20:23], v0 offset:6144
		ds_read_b128 v[24:27], v0 offset:6656
		ds_read_b128 v[28:31], v0 offset:7168
		ds_read_b128 v[32:35], v0 offset:7680
		ds_read_b128 v[36:39], v0 offset:10240
		ds_read_b128 v[40:43], v0 offset:10752
		ds_read_b128 v[44:47], v0 offset:11264
		ds_read_b128 v[48:51], v0 offset:11776
		ds_read_b128 v[52:55], v0 offset:14336
		ds_read_b128 v[56:59], v0 offset:14848
		ds_read_b128 v[60:63], v0 offset:15360
		ds_read_b128 v[64:67], v0 offset:15872
		ds_read_b128 v[68:71], v0 offset:18432
		ds_read_b128 v[72:75], v0 offset:18944
		ds_read_b128 v[76:79], v0 offset:19456
		ds_read_b128 v[80:83], v0 offset:19968
		ds_read_b128 v[84:87], v0 offset:22528
		ds_read_b128 v[88:91], v0 offset:23040
		ds_read_b128 v[92:95], v0 offset:23552
		ds_read_b128 v[96:99], v0 offset:24064
		ds_read_b128 v[100:103], v0 offset:26624
		ds_read_b128 v[104:107], v0 offset:27136
		ds_read_b128 v[108:111], v0 offset:27648
		ds_read_b128 v[112:115], v0 offset:28160
		ds_read_b128 v[116:119], v0 offset:30720
		ds_read_b128 v[120:123], v0 offset:31232
		ds_read_b128 v[124:127], v0 offset:31744
		ds_read_b128 v[128:131], v0 offset:32256
		s_waitcnt lgkmcnt(14)
		buffer_store_dwordx4 v[4:7], v0, s[12:15], 0 offen offset:2048
		buffer_store_dwordx4 v[8:11], v0, s[12:15], 0 offen offset:2560
		buffer_store_dwordx4 v[12:15], v0, s[12:15], 0 offen offset:3072
		buffer_store_dwordx4 v[16:19], v0, s[12:15], 0 offen offset:3584
		buffer_store_dwordx4 v[20:23], v0, s[12:15], s0 offen offset:2048
		buffer_store_dwordx4 v[24:27], v0, s[12:15], s0 offen offset:2560
		buffer_store_dwordx4 v[28:31], v0, s[12:15], s0 offen offset:3072
		buffer_store_dwordx4 v[32:35], v0, s[12:15], s0 offen offset:3584
		buffer_store_dwordx4 v[36:39], v0, s[12:15], s1 offen offset:2048
		buffer_store_dwordx4 v[40:43], v0, s[12:15], s1 offen offset:2560
		buffer_store_dwordx4 v[44:47], v0, s[12:15], s1 offen offset:3072
		buffer_store_dwordx4 v[48:51], v0, s[12:15], s1 offen offset:3584
		buffer_store_dwordx4 v[52:55], v0, s[12:15], s4 offen offset:2048
		buffer_store_dwordx4 v[56:59], v0, s[12:15], s4 offen offset:2560
		buffer_store_dwordx4 v[60:63], v0, s[12:15], s4 offen offset:3072
		buffer_store_dwordx4 v[64:67], v0, s[12:15], s4 offen offset:3584
		buffer_store_dwordx4 v[68:71], v0, s[12:15], s5 offen offset:2048
		buffer_store_dwordx4 v[72:75], v0, s[12:15], s5 offen offset:2560
		s_waitcnt lgkmcnt(13)
		buffer_store_dwordx4 v[76:79], v0, s[12:15], s5 offen offset:3072
		s_waitcnt lgkmcnt(12)
		buffer_store_dwordx4 v[80:83], v0, s[12:15], s5 offen offset:3584
		s_waitcnt lgkmcnt(11)
		buffer_store_dwordx4 v[84:87], v0, s[12:15], s6 offen offset:2048
		s_waitcnt lgkmcnt(10)
		buffer_store_dwordx4 v[88:91], v0, s[12:15], s6 offen offset:2560
		s_waitcnt lgkmcnt(9)
		buffer_store_dwordx4 v[92:95], v0, s[12:15], s6 offen offset:3072
		s_waitcnt lgkmcnt(8)
		buffer_store_dwordx4 v[96:99], v0, s[12:15], s6 offen offset:3584
		s_waitcnt lgkmcnt(7)
		buffer_store_dwordx4 v[100:103], v0, s[12:15], s7 offen offset:2048
		s_waitcnt lgkmcnt(6)
		buffer_store_dwordx4 v[104:107], v0, s[12:15], s7 offen offset:2560
		s_waitcnt lgkmcnt(5)
		buffer_store_dwordx4 v[108:111], v0, s[12:15], s7 offen offset:3072
		s_waitcnt lgkmcnt(4)
		buffer_store_dwordx4 v[112:115], v0, s[12:15], s7 offen offset:3584
		s_waitcnt lgkmcnt(3)
		buffer_store_dwordx4 v[116:119], v0, s[12:15], s8 offen offset:2048
		s_waitcnt lgkmcnt(2)
		buffer_store_dwordx4 v[120:123], v0, s[12:15], s8 offen offset:2560
		s_waitcnt lgkmcnt(1)
		buffer_store_dwordx4 v[124:127], v0, s[12:15], s8 offen offset:3072
		s_waitcnt lgkmcnt(0)
		buffer_store_dwordx4 v[128:131], v0, s[12:15], s8 offen offset:3584
.Lwmma_f16_matmul_tiled.exec_endif_9:
		s_mov_b64 exec, s[54:55]
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
		.amdhsa_next_free_vgpr 440
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
	.set .Lwmma_f16_matmul_tiled.num_vgpr, 254
	.set .Lwmma_f16_matmul_tiled.num_agpr, 184
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
    .max_flat_workgroup_size: 256
    .name:           wmma_f16_matmul_tiled
    .private_segment_fixed_size: 0
    .sgpr_count:     56
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     440
    .agpr_count:     184
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 47
    wave.regalloc.agpr.dwords: 181
    wave.regalloc.remat.dwords: 0
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
