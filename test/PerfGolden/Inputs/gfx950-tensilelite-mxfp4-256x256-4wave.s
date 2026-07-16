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
		v_readfirstlane_b32 s15, v0
		s_lshl_b32 s15, s15, 2
		s_mov_b32 s18, 0x80000000
		s_mov_b32 s23, 0x31016000
		s_mov_b32 s22, 0x1000000
		s_mov_b32 s20, s2
		s_mov_b32 s21, s3
		s_mov_b32 s0, s4
		s_mov_b32 s1, s5
		s_mov_b32 s2, s22
		s_mov_b32 s3, s23
		s_mov_b32 s24, s8
		s_mov_b32 s25, s9
		s_mov_b32 s26, s22
		s_mov_b32 s27, s23
		s_mov_b32 s28, s10
		s_mov_b32 s29, s11
		s_mov_b32 s30, s22
		s_mov_b32 s31, s23
		v_readfirstlane_b32 s4, v0
		s_lshl_b32 s5, s13, 20
		v_lshrrev_b32_e32 v1, 6, v0
		v_lshlrev_b32_e32 v2, 16, v1
		v_add_u32_e32 v3, s5, v2
		v_and_b32_e32 v4, 63, v0
		v_lshrrev_b32_e32 v5, 2, v4
		v_lshlrev_b32_e32 v5, 12, v5
		v_lshrrev_b32_e32 v6, 3, v4
		v_bitop3_b32 v6, v6, 3, v4 bitop3:0x48
		v_lshlrev_b32_e32 v6, 4, v6
		v_add3_u32 v3, v3, v5, v6
		s_add_i32 s8, s5, 0x40000
		v_add_u32_e32 v7, v2, v5
		s_add_i32 s9, s5, 0x80000
		s_add_i32 s10, s5, 0xc0000
		s_add_i32 s11, s5, 64
		v_add_u32_e32 v8, v2, v5
		s_add_i32 s16, s5, 0x40040
		s_add_i32 s17, s5, 0x80040
		s_add_i32 s19, s5, 0xc0040
		v_add_u32_e32 v9, v2, v5
		s_lshl_b32 s32, s14, 20
		s_add_i32 s33, s32, 0x40000
		s_add_i32 s34, s32, 0x80000
		v_add3_u32 v10, v2, v5, v6
		s_add_i32 s35, s32, 0xc0000
		s_add_i32 s36, s32, 0x40040
		v_add_u32_e32 v11, v2, v5
		s_add_i32 s37, s32, 0x80040
		s_add_i32 s38, s32, 0xc0040
		s_lshr_b32 s39, s4, 6
		s_lshl_b32 s40, s39, 10
		s_add_i32 m0, s40, 0x6000
		v_mov_b64_e32 v[12:13], 0
		v_mov_b64_e32 v[14:15], 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add3_u32 v3, v6, v7, s8
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v16, v6, v7, s9
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add3_u32 v3, v6, v7, s10
		v_add3_u32 v7, v6, v8, s11
		s_add_i32 m0, s40, 0x8000
		s_nop 0
		buffer_load_dwordx4 v16, s[20:23], 0 offen lds
		v_add3_u32 v16, v6, v8, s16
		v_add3_u32 v8, v6, v8, s17
		s_add_i32 m0, s40, 0x9000
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add3_u32 v3, v6, v9, s19
		v_add3_u32 v17, v6, v9, s32
		s_add_i32 m0, s40, 0xa000
		s_nop 0
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		v_add3_u32 v7, v6, v9, s33
		v_add_u32_e32 v9, s34, v10
		s_add_i32 m0, s40, 0xb000
		s_nop 0
		buffer_load_dwordx4 v16, s[20:23], 0 offen lds
		v_add_u32_e32 v16, s35, v10
		v_add3_u32 v10, v10, s32, 64
		s_add_i32 m0, s40, 0xc000
		s_nop 0
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		v_add3_u32 v8, v6, v11, s36
		v_add3_u32 v18, v6, v11, s37
		s_add_i32 m0, s40, 0xd000
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add3_u32 v3, v6, v11, s38
		v_mov_b32_e32 v11, 0x80040
		s_add_i32 m0, s40, 0xe000
		s_nop 0
		buffer_load_dwordx4 v17, s[0:3], 0 offen lds
		v_mov_b32_e32 v17, 0x40040
		v_mov_b32_e32 v19, 64
		s_add_i32 m0, s40, 0xf000
		s_nop 0
		buffer_load_dwordx4 v7, s[0:3], 0 offen lds
		v_mov_b32_e32 v7, 0xc0000
		v_add_u32_e32 v20, v2, v5
		s_add_i32 m0, s40, 0x10000
		s_nop 0
		buffer_load_dwordx4 v9, s[0:3], 0 offen lds
		v_add_u32_e32 v9, v2, v5
		v_add_u32_e32 v21, v2, v5
		s_add_i32 m0, s40, 0x11000
		s_nop 0
		buffer_load_dwordx4 v16, s[0:3], 0 offen lds
		v_add_u32_e32 v16, v2, v5
		v_add_u32_e32 v22, v2, v5
		s_add_i32 m0, s40, 0x12000
		s_nop 0
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		v_lshlrev_b32_e32 v10, 2, v4
		v_lshrrev_b32_e32 v23, 4, v4
		s_add_i32 m0, s40, 0x13000
		s_nop 0
		buffer_load_dwordx4 v8, s[0:3], 0 offen lds
		s_and_b32 s8, s39, 1
		v_and_b32_e32 v1, 1, v1
		s_add_i32 m0, s40, 0x14000
		s_nop 0
		buffer_load_dwordx4 v18, s[0:3], 0 offen lds
		v_lshlrev_b32_e32 v4, 4, v4
		s_lshl_b32 s9, s14, 16
		s_add_i32 m0, s40, 0x15000
		s_nop 0
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		s_add_i32 s10, s5, s9
		v_lshrrev_b32_e32 v3, 7, v0
		v_lshlrev_b32_e32 v8, 10, v3
		s_lshr_b32 s4, s4, 7
		s_lshl_b32 s11, s4, 10
		v_lshlrev_b32_e32 v18, 10, v1
		s_lshl_b32 s4, s8, 10
		v_add3_u32 v24, s10, v8, v4
		s_add_i32 m0, s11, 0x26000
		s_nop 0
		buffer_load_dwordx4 v24, s[24:27], 0 offen lds
		v_add3_u32 v24, s10, v4, v18
		s_add_i32 s8, s4, 0x800
		s_add_i32 m0, s4, 0x26800
		s_nop 0
		buffer_load_dwordx4 v24, s[28:31], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v3, 13, v3
		v_and_b32_e32 v24, 15, v0
		v_lshlrev_b32_e32 v25, 6, v24
		v_lshrrev_b32_e32 v24, 1, v24
		v_bitop3_b32 v23, v23, v24, 3 bitop3:0x78
		v_lshlrev_b32_e32 v23, 4, v23
		v_add3_u32 v24, v3, v25, v23
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b128 a[0:3], v26
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b128 a[4:7], v26 offset:1024
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b128 a[8:11], v26 offset:2048
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b128 a[12:15], v26 offset:3072
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b128 v[28:31], v26 offset:4096
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b128 v[32:35], v26 offset:5120
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b128 v[36:39], v26 offset:6144
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		ds_read_b128 v[40:43], v24 offset:7168
		v_lshlrev_b32_e32 v1, 13, v1
		v_add3_u32 v24, v25, v1, v23
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b128 v[44:47], v26 offset:32768
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b128 v[48:51], v26 offset:33792
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b128 v[52:55], v26 offset:34816
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b128 v[56:59], v26 offset:35840
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b128 v[60:63], v26 offset:36864
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b128 v[64:67], v26 offset:37888
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b128 v[68:71], v26 offset:38912
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		ds_read_b128 v[72:75], v24 offset:39936
		v_add_u32_e32 v24, 0x20000, v8
		v_add_u32_e32 v24, v24, v10
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b32 v27, v26
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b32 v76, v26 offset:256
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b32 v77, v26 offset:512
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		ds_read_b32 v26, v24 offset:768
		v_add_u32_e32 v10, 0x20000, v10
		v_add_u32_e32 v10, v10, v18
		v_add_u32_e32 v24, 0x800, v10
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		ds_read_b32 v78, v24 offset:2048
		v_add_u32_e32 v24, 0x800, v10
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		ds_read_b32 v79, v24 offset:2304
		v_add_u32_e32 v24, 0x800, v10
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x400, v24
		ds_read_b32 v80, v24 offset:2560
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		ds_read_b32 v24, v10 offset:2816
		s_add_i32 s10, s5, 0x80
		v_add_u32_e32 v2, s10, v2
		s_add_i32 s10, s5, 0x40080
		s_add_i32 s16, s5, 0x80080
		s_add_i32 s17, s5, 0xc0080
		s_add_i32 s19, s5, 0xc0
		s_add_i32 s33, s5, 0x400c0
		s_add_i32 s34, s5, 0x800c0
		s_add_i32 s35, s5, 0xc00c0
		s_add_i32 s36, s32, 0x80
		s_add_i32 s37, s32, 0x40080
		s_add_i32 s38, s32, 0x80080
		s_add_i32 s41, s32, 0xc0080
		s_add_i32 s42, s32, 0xc0
		s_add_i32 s43, s32, 0x400c0
		s_add_i32 s44, s32, 0x800c0
		s_add_i32 s32, s32, 0xc00c0
		v_add3_u32 v2, v2, v5, v6
		s_add_i32 m0, s40, 0x16000
		s_nop 0
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		v_add3_u32 v2, v6, v22, s10
		v_add3_u32 v5, v6, v22, s16
		s_add_i32 m0, s40, 0x17000
		s_nop 0
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		v_add3_u32 v2, v6, v22, s17
		v_add3_u32 v10, v6, v16, s19
		s_add_i32 m0, s40, 0x18000
		s_nop 0
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		v_add3_u32 v5, v6, v16, s33
		v_add3_u32 v16, v6, v16, s34
		s_add_i32 m0, s40, 0x19000
		s_nop 0
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		v_add3_u32 v2, v6, v21, s35
		v_add3_u32 v22, v6, v21, s36
		s_add_i32 m0, s40, 0x1a000
		s_nop 0
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		v_add3_u32 v10, v6, v21, s37
		v_add3_u32 v21, v6, v9, s38
		s_add_i32 m0, s40, 0x1b000
		s_nop 0
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		v_add3_u32 v5, v6, v9, s41
		v_add3_u32 v9, v6, v9, s42
		s_add_i32 m0, s40, 0x1c000
		s_nop 0
		buffer_load_dwordx4 v16, s[20:23], 0 offen lds
		v_add3_u32 v16, v6, v20, s43
		v_add3_u32 v81, v6, v20, s44
		s_add_i32 m0, s40, 0x1d000
		s_nop 0
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		v_add3_u32 v2, v6, v20, s32
		v_mov_b32_e32 v6, 0x80000
		s_add_i32 m0, s40, 0x1e000
		s_nop 0
		buffer_load_dwordx4 v22, s[0:3], 0 offen lds
		v_mov_b32_e32 v20, 0x40000
		s_mov_b32 s16, 0x80
		s_mov_b32 s17, 0
		s_add_i32 m0, s40, 0x1f000
		s_nop 0
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		s_mov_b32 s32, 16
		s_mov_b32 s33, 0
		v_mov_b32_e32 v10, 3
		s_add_i32 m0, s40, 0x20000
		s_nop 0
		buffer_load_dwordx4 v21, s[0:3], 0 offen lds
		s_mov_b32 s34, 0x1000
		s_mov_b32 s35, 0
		v_mov_b32_e32 v21, 63
		s_add_i32 m0, s40, 0x21000
		s_nop 0
		buffer_load_dwordx4 v5, s[0:3], 0 offen lds
		s_mov_b32 s36, 0x10000
		s_mov_b32 s37, 0
		v_mov_b32_e32 v82, v0
		s_add_i32 m0, s40, 0x22000
		s_nop 0
		buffer_load_dwordx4 v9, s[0:3], 0 offen lds
		s_mov_b32 s42, 1
		s_mov_b32 s43, 0
		s_mov_b32 s44, 0x100000
		s_mov_b32 s45, 0
		s_add_i32 m0, s40, 0x23000
		s_nop 0
		buffer_load_dwordx4 v16, s[0:3], 0 offen lds
		v_mov_b32_e32 v85, 0
		v_mov_b32_e32 v84, s13
		s_add_i32 m0, s40, 0x24000
		s_nop 0
		buffer_load_dwordx4 v81, s[0:3], 0 offen lds
		s_mov_b32 s10, 2
		s_add_i32 s5, s5, 0x800
		s_add_i32 m0, s40, 0x25000
		s_nop 0
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_add_i32 s5, s5, s9
		v_add3_u32 v2, s5, v8, v4
		s_add_i32 m0, s11, 0x27000
		s_nop 0
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		v_add3_u32 v2, s5, v4, v18
		s_add_i32 s5, s12, 1
		s_add_i32 m0, s4, 0x27800
		s_nop 0
		buffer_load_dwordx4 v2, s[28:31], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		v_mov_b32_e32 v4, s44
		v_mov_b32_e32 v5, s45
		v_mul_lo_u32 v8, v4, v84
		v_mul_hi_u32 v9, v4, v84
		v_mul_lo_u32 v2, v4, v85
		v_add_u32_e32 v9, v9, v2
		v_mul_lo_u32 v2, v5, v84
		v_add_u32_e32 v9, v9, v2
		v_mov_b32_e32 v86, s42
		v_mov_b32_e32 v87, s43
		v_mov_b32_e32 v83, 0
		v_mul_lo_u32 v88, v86, v82
		v_mul_hi_u32 v89, v86, v82
		v_mul_lo_u32 v2, v86, v83
		v_add_u32_e32 v89, v89, v2
		v_mul_lo_u32 v2, v87, v82
		v_add_u32_e32 v89, v89, v2
		v_lshrrev_b64 v[90:91], 6, v[88:89]
		v_mov_b32_e32 v92, s36
		v_mov_b32_e32 v93, s37
		v_mul_lo_u32 v94, v92, v90
		v_mul_hi_u32 v95, v92, v90
		v_mul_lo_u32 v2, v92, v91
		v_add_u32_e32 v95, v95, v2
		v_mul_lo_u32 v2, v93, v90
		v_add_u32_e32 v95, v95, v2
		v_add_co_u32_e64 v96, vcc, v8, v94
		v_addc_co_u32_e64 v97, vcc, v9, v95, vcc
		v_and_b32_e32 v98, v82, v21
		v_and_b32_e32 v99, v85, v85
		v_mul_lo_u32 v82, v86, v98
		v_mul_hi_u32 v83, v86, v98
		v_mul_lo_u32 v2, v86, v99
		v_add_u32_e32 v83, v83, v2
		v_mul_lo_u32 v2, v87, v98
		v_add_u32_e32 v83, v83, v2
		v_lshrrev_b64 v[86:87], 2, v[82:83]
		v_mov_b32_e32 v100, s34
		v_mov_b32_e32 v101, s35
		v_mul_lo_u32 v102, v100, v86
		v_mul_hi_u32 v103, v100, v86
		v_mul_lo_u32 v2, v100, v87
		v_add_u32_e32 v103, v103, v2
		v_mul_lo_u32 v2, v101, v86
		v_add_u32_e32 v103, v103, v2
		v_add_co_u32_e64 v86, vcc, v96, v102
		v_addc_co_u32_e64 v87, vcc, v97, v103, vcc
		v_lshrrev_b64 v[96:97], 3, v[82:83]
		v_and_b32_e32 v82, v96, v10
		v_and_b32_e32 v83, v97, v85
		v_and_b32_e32 v96, v98, v10
		v_and_b32_e32 v97, v99, v85
		v_xor_b32_e32 v82, v82, v96
		v_xor_b32_e32 v83, v83, v97
		v_mov_b32_e32 v96, s32
		v_mov_b32_e32 v97, s33
		v_mul_lo_u32 v100, v96, v82
		v_mul_hi_u32 v101, v96, v82
		v_mul_lo_u32 v2, v96, v83
		v_add_u32_e32 v101, v101, v2
		v_mul_lo_u32 v2, v97, v82
		v_add_u32_e32 v101, v101, v2
		v_add_co_u32_e64 v82, vcc, v86, v100
		v_addc_co_u32_e64 v83, vcc, v87, v101, vcc
		v_mov_b32_e32 v86, s16
		v_mov_b32_e32 v87, s17
		v_add_co_u32_e64 v104, vcc, v8, v20
		v_addc_co_u32_e64 v105, vcc, v9, 0, vcc
		v_add_co_u32_e64 v106, vcc, v104, v94
		v_addc_co_u32_e64 v107, vcc, v105, v95, vcc
		v_add_co_u32_e64 v104, vcc, v106, v102
		v_addc_co_u32_e64 v105, vcc, v107, v103, vcc
		v_add_co_u32_e64 v106, vcc, v104, v100
		v_addc_co_u32_e64 v107, vcc, v105, v101, vcc
		v_add_co_u32_e64 v104, vcc, v8, v6
		v_addc_co_u32_e64 v105, vcc, v9, 0, vcc
		v_add_co_u32_e64 v108, vcc, v104, v94
		v_addc_co_u32_e64 v109, vcc, v105, v95, vcc
		v_add_co_u32_e64 v104, vcc, v108, v102
		v_addc_co_u32_e64 v105, vcc, v109, v103, vcc
		v_add_co_u32_e64 v108, vcc, v104, v100
		v_addc_co_u32_e64 v109, vcc, v105, v101, vcc
		v_add_co_u32_e64 v104, vcc, v8, v7
		v_addc_co_u32_e64 v105, vcc, v9, 0, vcc
		v_add_co_u32_e64 v110, vcc, v104, v94
		v_addc_co_u32_e64 v111, vcc, v105, v95, vcc
		v_add_co_u32_e64 v104, vcc, v110, v102
		v_addc_co_u32_e64 v105, vcc, v111, v103, vcc
		v_add_co_u32_e64 v110, vcc, v104, v100
		v_addc_co_u32_e64 v111, vcc, v105, v101, vcc
		v_add_co_u32_e64 v104, vcc, v8, v19
		v_addc_co_u32_e64 v105, vcc, v9, 0, vcc
		v_add_co_u32_e64 v112, vcc, v104, v94
		v_addc_co_u32_e64 v113, vcc, v105, v95, vcc
		v_add_co_u32_e64 v104, vcc, v112, v102
		v_addc_co_u32_e64 v105, vcc, v113, v103, vcc
		v_add_co_u32_e64 v112, vcc, v104, v100
		v_addc_co_u32_e64 v113, vcc, v105, v101, vcc
		v_add_co_u32_e64 v104, vcc, v8, v17
		v_addc_co_u32_e64 v105, vcc, v9, 0, vcc
		v_add_co_u32_e64 v114, vcc, v104, v94
		v_addc_co_u32_e64 v115, vcc, v105, v95, vcc
		v_add_co_u32_e64 v104, vcc, v114, v102
		v_addc_co_u32_e64 v105, vcc, v115, v103, vcc
		v_add_co_u32_e64 v114, vcc, v104, v100
		v_addc_co_u32_e64 v115, vcc, v105, v101, vcc
		v_add_co_u32_e64 v104, vcc, v8, v11
		v_addc_co_u32_e64 v105, vcc, v9, 0, vcc
		v_add_co_u32_e64 v116, vcc, v104, v94
		v_addc_co_u32_e64 v117, vcc, v105, v95, vcc
		v_add_co_u32_e64 v104, vcc, v116, v102
		v_addc_co_u32_e64 v105, vcc, v117, v103, vcc
		v_add_co_u32_e64 v116, vcc, v104, v100
		v_addc_co_u32_e64 v117, vcc, v105, v101, vcc
		v_mov_b32_e32 v2, 0xc0040
		v_add_co_u32_e64 v104, vcc, v8, v2
		v_addc_co_u32_e64 v105, vcc, v9, 0, vcc
		v_add_co_u32_e64 v118, vcc, v104, v94
		v_addc_co_u32_e64 v119, vcc, v105, v95, vcc
		v_add_co_u32_e64 v104, vcc, v118, v102
		v_addc_co_u32_e64 v105, vcc, v119, v103, vcc
		v_add_co_u32_e64 v118, vcc, v104, v100
		v_addc_co_u32_e64 v119, vcc, v105, v101, vcc
		v_mov_b32_e32 v104, s14
		v_mov_b32_e32 v105, 0
		v_mul_lo_u32 v120, v4, v104
		v_mul_hi_u32 v121, v4, v104
		v_mul_lo_u32 v10, v4, v105
		v_add_u32_e32 v121, v121, v10
		v_mul_lo_u32 v10, v5, v104
		v_add_u32_e32 v121, v121, v10
		v_add_co_u32_e64 v4, vcc, v120, v94
		v_addc_co_u32_e64 v5, vcc, v121, v95, vcc
		v_add_co_u32_e64 v122, vcc, v4, v102
		v_addc_co_u32_e64 v123, vcc, v5, v103, vcc
		v_add_co_u32_e64 v4, vcc, v122, v100
		v_addc_co_u32_e64 v5, vcc, v123, v101, vcc
		v_add_co_u32_e64 v122, vcc, v120, v20
		v_addc_co_u32_e64 v123, vcc, v121, 0, vcc
		v_add_co_u32_e64 v20, vcc, v122, v94
		v_addc_co_u32_e64 v21, vcc, v123, v95, vcc
		v_add_co_u32_e64 v122, vcc, v20, v102
		v_addc_co_u32_e64 v123, vcc, v21, v103, vcc
		v_add_co_u32_e64 v20, vcc, v122, v100
		v_addc_co_u32_e64 v21, vcc, v123, v101, vcc
		v_add_co_u32_e64 v122, vcc, v120, v6
		v_addc_co_u32_e64 v123, vcc, v121, 0, vcc
		v_add_co_u32_e64 v124, vcc, v122, v94
		v_addc_co_u32_e64 v125, vcc, v123, v95, vcc
		v_add_co_u32_e64 v122, vcc, v124, v102
		v_addc_co_u32_e64 v123, vcc, v125, v103, vcc
		v_add_co_u32_e64 v124, vcc, v122, v100
		v_addc_co_u32_e64 v125, vcc, v123, v101, vcc
		v_add_co_u32_e64 v122, vcc, v120, v7
		v_addc_co_u32_e64 v123, vcc, v121, 0, vcc
		v_add_co_u32_e64 v6, vcc, v122, v94
		v_addc_co_u32_e64 v7, vcc, v123, v95, vcc
		v_add_co_u32_e64 v122, vcc, v6, v102
		v_addc_co_u32_e64 v123, vcc, v7, v103, vcc
		v_add_co_u32_e64 v6, vcc, v122, v100
		v_addc_co_u32_e64 v7, vcc, v123, v101, vcc
		v_add_co_u32_e64 v122, vcc, v120, v19
		v_addc_co_u32_e64 v123, vcc, v121, 0, vcc
		v_add_co_u32_e64 v18, vcc, v122, v94
		v_addc_co_u32_e64 v19, vcc, v123, v95, vcc
		v_add_co_u32_e64 v122, vcc, v18, v102
		v_addc_co_u32_e64 v123, vcc, v19, v103, vcc
		v_add_co_u32_e64 v18, vcc, v122, v100
		v_addc_co_u32_e64 v19, vcc, v123, v101, vcc
		v_add_co_u32_e64 v122, vcc, v120, v17
		v_addc_co_u32_e64 v123, vcc, v121, 0, vcc
		v_add_co_u32_e64 v16, vcc, v122, v94
		v_addc_co_u32_e64 v17, vcc, v123, v95, vcc
		v_add_co_u32_e64 v122, vcc, v16, v102
		v_addc_co_u32_e64 v123, vcc, v17, v103, vcc
		v_add_co_u32_e64 v16, vcc, v122, v100
		v_addc_co_u32_e64 v17, vcc, v123, v101, vcc
		v_add_co_u32_e64 v122, vcc, v120, v11
		v_addc_co_u32_e64 v123, vcc, v121, 0, vcc
		v_add_co_u32_e64 v10, vcc, v122, v94
		v_addc_co_u32_e64 v11, vcc, v123, v95, vcc
		v_add_co_u32_e64 v122, vcc, v10, v102
		v_addc_co_u32_e64 v123, vcc, v11, v103, vcc
		v_add_co_u32_e64 v10, vcc, v122, v100
		v_addc_co_u32_e64 v11, vcc, v123, v101, vcc
		v_add_co_u32_e64 v122, vcc, v120, v2
		v_addc_co_u32_e64 v123, vcc, v121, 0, vcc
		v_add_co_u32_e64 v126, vcc, v122, v94
		v_addc_co_u32_e64 v127, vcc, v123, v95, vcc
		v_add_co_u32_e64 v122, vcc, v126, v102
		v_addc_co_u32_e64 v123, vcc, v127, v103, vcc
		v_add_co_u32_e64 v126, vcc, v122, v100
		v_addc_co_u32_e64 v127, vcc, v123, v101, vcc
		v_mul_lo_u32 v122, v92, v104
		v_mul_hi_u32 v123, v92, v104
		v_mul_lo_u32 v2, v92, v105
		v_add_u32_e32 v123, v123, v2
		v_mul_lo_u32 v2, v93, v104
		v_add_u32_e32 v123, v123, v2
		v_add_co_u32_e64 v92, vcc, v8, v122
		v_addc_co_u32_e64 v93, vcc, v9, v123, vcc
		v_lshrrev_b64 v[104:105], 7, v[88:89]
		s_mov_b32 s16, 0x400
		s_mov_b32 s17, 0
		v_mov_b32_e32 v88, s16
		v_mov_b32_e32 v89, s17
		v_mul_lo_u32 v128, v88, v104
		v_mul_hi_u32 v129, v88, v104
		v_mul_lo_u32 v2, v88, v105
		v_add_u32_e32 v129, v129, v2
		v_mul_lo_u32 v2, v89, v104
		v_add_u32_e32 v129, v129, v2
		v_add_co_u32_e64 v104, vcc, v92, v128
		v_addc_co_u32_e64 v105, vcc, v93, v129, vcc
		v_mul_lo_u32 v130, v96, v98
		v_mul_hi_u32 v131, v96, v98
		v_mul_lo_u32 v2, v96, v99
		v_add_u32_e32 v131, v131, v2
		v_mul_lo_u32 v2, v97, v98
		v_add_u32_e32 v131, v131, v2
		v_add_co_u32_e64 v96, vcc, v104, v130
		v_addc_co_u32_e64 v97, vcc, v105, v131, vcc
		s_mov_b32 s16, 0x800
		s_mov_b32 s17, 0
		v_mov_b32_e32 v98, s16
		v_mov_b32_e32 v99, s17
		v_add_co_u32_e64 v104, vcc, v92, v130
		v_addc_co_u32_e64 v105, vcc, v93, v131, vcc
		v_mov_b32_e32 v2, 1
		v_and_b32_e32 v92, v90, v2
		v_and_b32_e32 v93, v91, v85
		v_mul_lo_u32 v84, v88, v92
		v_mul_hi_u32 v85, v88, v92
		v_mul_lo_u32 v2, v88, v93
		v_add_u32_e32 v85, v85, v2
		v_mul_lo_u32 v2, v89, v92
		v_add_u32_e32 v85, v85, v2
		v_add_co_u32_e64 v88, vcc, v104, v84
		v_addc_co_u32_e64 v89, vcc, v105, v85, vcc
		v_mov_b32_e32 v2, 0x80
		v_add_co_u32_e64 v90, vcc, v8, v2
		v_addc_co_u32_e64 v91, vcc, v9, 0, vcc
		v_add_co_u32_e64 v92, vcc, v90, v94
		v_addc_co_u32_e64 v93, vcc, v91, v95, vcc
		v_add_co_u32_e64 v90, vcc, v92, v102
		v_addc_co_u32_e64 v91, vcc, v93, v103, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v92, vcc, v90, v100
		v_addc_co_u32_e64 v93, vcc, v91, v101, vcc
		ds_write_addtid_b32 v92
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v93 offset:1024
		v_mov_b32_e32 v22, 0x40080
		v_add_co_u32_e64 v90, vcc, v8, v22
		v_addc_co_u32_e64 v91, vcc, v9, 0, vcc
		v_add_co_u32_e64 v92, vcc, v90, v94
		v_addc_co_u32_e64 v93, vcc, v91, v95, vcc
		v_add_co_u32_e64 v90, vcc, v92, v102
		v_addc_co_u32_e64 v91, vcc, v93, v103, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v92, vcc, v90, v100
		v_addc_co_u32_e64 v93, vcc, v91, v101, vcc
		ds_write_addtid_b32 v92 offset:2048
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v93 offset:3072
		v_mov_b32_e32 v81, 0x80080
		v_add_co_u32_e64 v90, vcc, v8, v81
		v_addc_co_u32_e64 v91, vcc, v9, 0, vcc
		v_add_co_u32_e64 v92, vcc, v90, v94
		v_addc_co_u32_e64 v93, vcc, v91, v95, vcc
		v_add_co_u32_e64 v90, vcc, v92, v102
		v_addc_co_u32_e64 v91, vcc, v93, v103, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v92, vcc, v90, v100
		v_addc_co_u32_e64 v93, vcc, v91, v101, vcc
		ds_write_addtid_b32 v92 offset:4096
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v93 offset:5120
		v_mov_b32_e32 v90, 0xc0080
		v_add_co_u32_e64 v92, vcc, v8, v90
		v_addc_co_u32_e64 v93, vcc, v9, 0, vcc
		v_add_co_u32_e64 v104, vcc, v92, v94
		v_addc_co_u32_e64 v105, vcc, v93, v95, vcc
		v_add_co_u32_e64 v92, vcc, v104, v102
		v_addc_co_u32_e64 v93, vcc, v105, v103, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v104, vcc, v92, v100
		v_addc_co_u32_e64 v105, vcc, v93, v101, vcc
		ds_write_addtid_b32 v104 offset:6144
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v105 offset:7168
		v_mov_b32_e32 v91, 0xc0
		v_add_co_u32_e64 v92, vcc, v8, v91
		v_addc_co_u32_e64 v93, vcc, v9, 0, vcc
		v_add_co_u32_e64 v104, vcc, v92, v94
		v_addc_co_u32_e64 v105, vcc, v93, v95, vcc
		v_add_co_u32_e64 v92, vcc, v104, v102
		v_addc_co_u32_e64 v93, vcc, v105, v103, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v104, vcc, v92, v100
		v_addc_co_u32_e64 v105, vcc, v93, v101, vcc
		ds_write_addtid_b32 v104 offset:9216
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v105 offset:10240
		v_mov_b32_e32 v92, 0x400c0
		v_add_co_u32_e64 v104, vcc, v8, v92
		v_addc_co_u32_e64 v105, vcc, v9, 0, vcc
		v_add_co_u32_e64 v132, vcc, v104, v94
		v_addc_co_u32_e64 v133, vcc, v105, v95, vcc
		v_add_co_u32_e64 v104, vcc, v132, v102
		v_addc_co_u32_e64 v105, vcc, v133, v103, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v132, vcc, v104, v100
		v_addc_co_u32_e64 v133, vcc, v105, v101, vcc
		ds_write_addtid_b32 v132 offset:11264
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v133 offset:12288
		v_mov_b32_e32 v93, 0x800c0
		v_add_co_u32_e64 v104, vcc, v8, v93
		v_addc_co_u32_e64 v105, vcc, v9, 0, vcc
		v_add_co_u32_e64 v132, vcc, v104, v94
		v_addc_co_u32_e64 v133, vcc, v105, v95, vcc
		v_add_co_u32_e64 v104, vcc, v132, v102
		v_addc_co_u32_e64 v105, vcc, v133, v103, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v132, vcc, v104, v100
		v_addc_co_u32_e64 v133, vcc, v105, v101, vcc
		ds_write_addtid_b32 v132 offset:13312
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v133 offset:14336
		v_mov_b32_e32 v104, 0xc00c0
		v_add_co_u32_e64 v132, vcc, v8, v104
		v_addc_co_u32_e64 v133, vcc, v9, 0, vcc
		v_add_co_u32_e64 v134, vcc, v132, v94
		v_addc_co_u32_e64 v135, vcc, v133, v95, vcc
		v_add_co_u32_e64 v132, vcc, v134, v102
		v_addc_co_u32_e64 v133, vcc, v135, v103, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v134, vcc, v132, v100
		v_addc_co_u32_e64 v135, vcc, v133, v101, vcc
		ds_write_addtid_b32 v134 offset:15360
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v135 offset:16384
		v_add_co_u32_e64 v132, vcc, v120, v2
		v_addc_co_u32_e64 v133, vcc, v121, 0, vcc
		v_add_co_u32_e64 v134, vcc, v132, v94
		v_addc_co_u32_e64 v135, vcc, v133, v95, vcc
		v_add_co_u32_e64 v132, vcc, v134, v102
		v_addc_co_u32_e64 v133, vcc, v135, v103, vcc
		v_add_co_u32_e64 v134, vcc, v132, v100
		v_addc_co_u32_e64 v135, vcc, v133, v101, vcc
		v_add_co_u32_e64 v132, vcc, v120, v22
		v_addc_co_u32_e64 v133, vcc, v121, 0, vcc
		v_add_co_u32_e64 v136, vcc, v132, v94
		v_addc_co_u32_e64 v137, vcc, v133, v95, vcc
		v_add_co_u32_e64 v132, vcc, v136, v102
		v_addc_co_u32_e64 v133, vcc, v137, v103, vcc
		v_add_co_u32_e64 v136, vcc, v132, v100
		v_addc_co_u32_e64 v137, vcc, v133, v101, vcc
		v_add_co_u32_e64 v132, vcc, v120, v81
		v_addc_co_u32_e64 v133, vcc, v121, 0, vcc
		v_add_co_u32_e64 v138, vcc, v132, v94
		v_addc_co_u32_e64 v139, vcc, v133, v95, vcc
		v_add_co_u32_e64 v132, vcc, v138, v102
		v_addc_co_u32_e64 v133, vcc, v139, v103, vcc
		v_add_co_u32_e64 v138, vcc, v132, v100
		v_addc_co_u32_e64 v139, vcc, v133, v101, vcc
		v_add_co_u32_e64 v132, vcc, v120, v90
		v_addc_co_u32_e64 v133, vcc, v121, 0, vcc
		v_add_co_u32_e64 v140, vcc, v132, v94
		v_addc_co_u32_e64 v141, vcc, v133, v95, vcc
		v_add_co_u32_e64 v132, vcc, v140, v102
		v_addc_co_u32_e64 v133, vcc, v141, v103, vcc
		v_add_co_u32_e64 v140, vcc, v132, v100
		v_addc_co_u32_e64 v141, vcc, v133, v101, vcc
		v_add_co_u32_e64 v132, vcc, v120, v91
		v_addc_co_u32_e64 v133, vcc, v121, 0, vcc
		v_add_co_u32_e64 v90, vcc, v132, v94
		v_addc_co_u32_e64 v91, vcc, v133, v95, vcc
		v_add_co_u32_e64 v132, vcc, v90, v102
		v_addc_co_u32_e64 v133, vcc, v91, v103, vcc
		v_add_co_u32_e64 v90, vcc, v132, v100
		v_addc_co_u32_e64 v91, vcc, v133, v101, vcc
		v_add_co_u32_e64 v132, vcc, v120, v92
		v_addc_co_u32_e64 v133, vcc, v121, 0, vcc
		v_add_co_u32_e64 v142, vcc, v132, v94
		v_addc_co_u32_e64 v143, vcc, v133, v95, vcc
		v_add_co_u32_e64 v132, vcc, v142, v102
		v_addc_co_u32_e64 v133, vcc, v143, v103, vcc
		v_add_co_u32_e64 v142, vcc, v132, v100
		v_addc_co_u32_e64 v143, vcc, v133, v101, vcc
		v_add_co_u32_e64 v132, vcc, v120, v93
		v_addc_co_u32_e64 v133, vcc, v121, 0, vcc
		v_add_co_u32_e64 v92, vcc, v132, v94
		v_addc_co_u32_e64 v93, vcc, v133, v95, vcc
		v_add_co_u32_e64 v132, vcc, v92, v102
		v_addc_co_u32_e64 v133, vcc, v93, v103, vcc
		v_add_co_u32_e64 v92, vcc, v132, v100
		v_addc_co_u32_e64 v93, vcc, v133, v101, vcc
		v_add_co_u32_e64 v132, vcc, v120, v104
		v_addc_co_u32_e64 v133, vcc, v121, 0, vcc
		v_add_co_u32_e64 v104, vcc, v132, v94
		v_addc_co_u32_e64 v105, vcc, v133, v95, vcc
		v_add_co_u32_e64 v94, vcc, v104, v102
		v_addc_co_u32_e64 v95, vcc, v105, v103, vcc
		v_add_co_u32_e64 v102, vcc, v94, v100
		v_addc_co_u32_e64 v103, vcc, v95, v101, vcc
		s_mov_b32 s4, 0
		scratch_store_dword off, v102, s4
		scratch_store_dword off, v103, s4 offset:4
		v_mov_b32_e32 v2, 0x800
		v_add_co_u32_e64 v94, vcc, v8, v2
		v_addc_co_u32_e64 v95, vcc, v9, 0, vcc
		v_add_co_u32_e64 v8, vcc, v94, v122
		v_addc_co_u32_e64 v9, vcc, v95, v123, vcc
		v_add_co_u32_e64 v94, vcc, v8, v128
		v_addc_co_u32_e64 v95, vcc, v9, v129, vcc
		v_add_co_u32_e64 v100, vcc, v94, v130
		v_addc_co_u32_e64 v101, vcc, v95, v131, vcc
		s_mov_b32 s4, 0
		scratch_store_dword off, v100, s4 offset:8
		scratch_store_dword off, v101, s4 offset:12
		v_add_co_u32_e64 v94, vcc, v8, v130
		v_addc_co_u32_e64 v95, vcc, v9, v131, vcc
		v_add_co_u32_e64 v8, vcc, v94, v84
		v_addc_co_u32_e64 v9, vcc, v95, v85, vcc
		v_mov_b32_e32 v84, s10
		v_mov_b32_e32 v85, 0
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_mov_b64_e32 v[120:121], 0
		v_mov_b64_e32 v[122:123], 0
		v_mov_b64_e32 v[128:129], 0
		v_mov_b64_e32 v[130:131], 0
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
		v_accvgpr_write_b32 a16, 0
		v_accvgpr_write_b32 a17, 0
		v_accvgpr_write_b32 a18, 0
		v_accvgpr_write_b32 a19, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a20, 0
		v_accvgpr_write_b32 a21, 0
		v_accvgpr_write_b32 a22, 0
		v_accvgpr_write_b32 a23, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a24, 0
		v_accvgpr_write_b32 a25, 0
		v_accvgpr_write_b32 a26, 0
		v_accvgpr_write_b32 a27, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a28, 0
		v_accvgpr_write_b32 a29, 0
		v_accvgpr_write_b32 a30, 0
		v_accvgpr_write_b32 a31, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a32, 0
		v_accvgpr_write_b32 a33, 0
		v_accvgpr_write_b32 a34, 0
		v_accvgpr_write_b32 a35, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a36, 0
		v_accvgpr_write_b32 a37, 0
		v_accvgpr_write_b32 a38, 0
		v_accvgpr_write_b32 a39, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a40, 0
		v_accvgpr_write_b32 a41, 0
		v_accvgpr_write_b32 a42, 0
		v_accvgpr_write_b32 a43, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a44, 0
		v_accvgpr_write_b32 a45, 0
		v_accvgpr_write_b32 a46, 0
		v_accvgpr_write_b32 a47, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a48, 0
		v_accvgpr_write_b32 a49, 0
		v_accvgpr_write_b32 a50, 0
		v_accvgpr_write_b32 a51, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a52, 0
		v_accvgpr_write_b32 a53, 0
		v_accvgpr_write_b32 a54, 0
		v_accvgpr_write_b32 a55, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a56, 0
		v_accvgpr_write_b32 a57, 0
		v_accvgpr_write_b32 a58, 0
		v_accvgpr_write_b32 a59, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a60, 0
		v_accvgpr_write_b32 a61, 0
		v_accvgpr_write_b32 a62, 0
		v_accvgpr_write_b32 a63, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a64, 0
		v_accvgpr_write_b32 a65, 0
		v_accvgpr_write_b32 a66, 0
		v_accvgpr_write_b32 a67, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a68, 0
		v_accvgpr_write_b32 a69, 0
		v_accvgpr_write_b32 a70, 0
		v_accvgpr_write_b32 a71, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a72, 0
		v_accvgpr_write_b32 a73, 0
		v_accvgpr_write_b32 a74, 0
		v_accvgpr_write_b32 a75, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a76, 0
		v_accvgpr_write_b32 a77, 0
		v_accvgpr_write_b32 a78, 0
		v_accvgpr_write_b32 a79, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a80, 0
		v_accvgpr_write_b32 a81, 0
		v_accvgpr_write_b32 a82, 0
		v_accvgpr_write_b32 a83, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a84, 0
		v_accvgpr_write_b32 a85, 0
		v_accvgpr_write_b32 a86, 0
		v_accvgpr_write_b32 a87, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a88, 0
		v_accvgpr_write_b32 a89, 0
		v_accvgpr_write_b32 a90, 0
		v_accvgpr_write_b32 a91, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a92, 0
		v_accvgpr_write_b32 a93, 0
		v_accvgpr_write_b32 a94, 0
		v_accvgpr_write_b32 a95, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a96, 0
		v_accvgpr_write_b32 a97, 0
		v_accvgpr_write_b32 a98, 0
		v_accvgpr_write_b32 a99, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a100, 0
		v_accvgpr_write_b32 a101, 0
		v_accvgpr_write_b32 a102, 0
		v_accvgpr_write_b32 a103, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a104, 0
		v_accvgpr_write_b32 a105, 0
		v_accvgpr_write_b32 a106, 0
		v_accvgpr_write_b32 a107, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a108, 0
		v_accvgpr_write_b32 a109, 0
		v_accvgpr_write_b32 a110, 0
		v_accvgpr_write_b32 a111, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a112, 0
		v_accvgpr_write_b32 a113, 0
		v_accvgpr_write_b32 a114, 0
		v_accvgpr_write_b32 a115, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a116, 0
		v_accvgpr_write_b32 a117, 0
		v_accvgpr_write_b32 a118, 0
		v_accvgpr_write_b32 a119, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a120, 0
		v_accvgpr_write_b32 a121, 0
		v_accvgpr_write_b32 a122, 0
		v_accvgpr_write_b32 a123, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a124, 0
		v_accvgpr_write_b32 a125, 0
		v_accvgpr_write_b32 a126, 0
		v_accvgpr_write_b32 a127, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a128, 0
		v_accvgpr_write_b32 a129, 0
		v_accvgpr_write_b32 a130, 0
		v_accvgpr_write_b32 a131, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a132, 0
		v_accvgpr_write_b32 a133, 0
		v_accvgpr_write_b32 a134, 0
		v_accvgpr_write_b32 a135, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a136, 0
		v_accvgpr_write_b32 a137, 0
		v_accvgpr_write_b32 a138, 0
		v_accvgpr_write_b32 a139, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a140, 0
		v_accvgpr_write_b32 a141, 0
		v_accvgpr_write_b32 a142, 0
		v_accvgpr_write_b32 a143, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a144, 0
		v_accvgpr_write_b32 a145, 0
		v_accvgpr_write_b32 a146, 0
		v_accvgpr_write_b32 a147, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a148, 0
		v_accvgpr_write_b32 a149, 0
		v_accvgpr_write_b32 a150, 0
		v_accvgpr_write_b32 a151, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a152, 0
		v_accvgpr_write_b32 a153, 0
		v_accvgpr_write_b32 a154, 0
		v_accvgpr_write_b32 a155, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a156, 0
		v_accvgpr_write_b32 a157, 0
		v_accvgpr_write_b32 a158, 0
		v_accvgpr_write_b32 a159, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a160, 0
		v_accvgpr_write_b32 a161, 0
		v_accvgpr_write_b32 a162, 0
		v_accvgpr_write_b32 a163, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a164, 0
		v_accvgpr_write_b32 a165, 0
		v_accvgpr_write_b32 a166, 0
		v_accvgpr_write_b32 a167, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a168, 0
		v_accvgpr_write_b32 a169, 0
		v_accvgpr_write_b32 a170, 0
		v_accvgpr_write_b32 a171, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a172, 0
		v_accvgpr_write_b32 a173, 0
		v_accvgpr_write_b32 a174, 0
		v_accvgpr_write_b32 a175, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a176, 0
		v_accvgpr_write_b32 a177, 0
		v_accvgpr_write_b32 a178, 0
		v_accvgpr_write_b32 a179, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a180, 0
		v_accvgpr_write_b32 a181, 0
		v_accvgpr_write_b32 a182, 0
		v_accvgpr_write_b32 a183, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a184, 0
		v_accvgpr_write_b32 a185, 0
		v_accvgpr_write_b32 a186, 0
		v_accvgpr_write_b32 a187, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a188, 0
		v_accvgpr_write_b32 a189, 0
		v_accvgpr_write_b32 a190, 0
		v_accvgpr_write_b32 a191, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a192, 0
		v_accvgpr_write_b32 a193, 0
		v_accvgpr_write_b32 a194, 0
		v_accvgpr_write_b32 a195, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a196, 0
		v_accvgpr_write_b32 a197, 0
		v_accvgpr_write_b32 a198, 0
		v_accvgpr_write_b32 a199, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a200, 0
		v_accvgpr_write_b32 a201, 0
		v_accvgpr_write_b32 a202, 0
		v_accvgpr_write_b32 a203, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a204, 0
		v_accvgpr_write_b32 a205, 0
		v_accvgpr_write_b32 a206, 0
		v_accvgpr_write_b32 a207, 0
		v_mov_b64_e32 v[188:189], 0
		v_mov_b64_e32 v[190:191], 0
		v_accvgpr_write_b32 a208, 0
		v_accvgpr_write_b32 a209, 0
		v_accvgpr_write_b32 a210, 0
		v_accvgpr_write_b32 a211, 0
.Lwmma_f16_matmul_tiled.loop_head_0:
		v_mov_b32_e32 v84, s10
		v_mul_lo_u32 v94, v86, v84
		v_mul_hi_u32 v95, v86, v84
		v_mul_lo_u32 v2, v86, v85
		v_add_u32_e32 v95, v95, v2
		v_mul_lo_u32 v2, v87, v84
		v_add_u32_e32 v95, v95, v2
		v_add_co_u32_e64 v104, vcc, v82, v94
		v_addc_co_u32_e64 v105, vcc, v83, v95, vcc
		v_add_co_u32_e64 v132, vcc, v106, v94
		v_addc_co_u32_e64 v133, vcc, v107, v95, vcc
		v_add_co_u32_e64 v188, vcc, v108, v94
		v_addc_co_u32_e64 v189, vcc, v109, v95, vcc
		v_add_co_u32_e64 v190, vcc, v110, v94
		v_addc_co_u32_e64 v191, vcc, v111, v95, vcc
		v_add_co_u32_e64 v192, vcc, v112, v94
		v_addc_co_u32_e64 v193, vcc, v113, v95, vcc
		v_add_co_u32_e64 v194, vcc, v114, v94
		v_addc_co_u32_e64 v195, vcc, v115, v95, vcc
		v_add_co_u32_e64 v196, vcc, v116, v94
		v_addc_co_u32_e64 v197, vcc, v117, v95, vcc
		v_add_co_u32_e64 v198, vcc, v118, v94
		v_addc_co_u32_e64 v199, vcc, v119, v95, vcc
		v_add_co_u32_e64 v200, vcc, v4, v94
		v_addc_co_u32_e64 v201, vcc, v5, v95, vcc
		v_add_co_u32_e64 v202, vcc, v20, v94
		v_addc_co_u32_e64 v203, vcc, v21, v95, vcc
		v_add_co_u32_e64 v204, vcc, v124, v94
		v_addc_co_u32_e64 v205, vcc, v125, v95, vcc
		v_add_co_u32_e64 v206, vcc, v6, v94
		v_addc_co_u32_e64 v207, vcc, v7, v95, vcc
		v_add_co_u32_e64 v208, vcc, v18, v94
		v_addc_co_u32_e64 v209, vcc, v19, v95, vcc
		v_add_co_u32_e64 v210, vcc, v16, v94
		v_addc_co_u32_e64 v211, vcc, v17, v95, vcc
		v_add_co_u32_e64 v212, vcc, v10, v94
		v_addc_co_u32_e64 v213, vcc, v11, v95, vcc
		v_add_co_u32_e64 v214, vcc, v126, v94
		v_addc_co_u32_e64 v215, vcc, v127, v95, vcc
		v_mul_lo_u32 v216, v98, v84
		v_mul_hi_u32 v217, v98, v84
		v_mul_lo_u32 v2, v98, v85
		v_add_u32_e32 v217, v217, v2
		v_mul_lo_u32 v2, v99, v84
		v_add_u32_e32 v217, v217, v2
		v_add_co_u32_e64 v218, vcc, v96, v216
		v_addc_co_u32_e64 v219, vcc, v97, v217, vcc
		v_add_co_u32_e64 v220, vcc, v88, v216
		v_addc_co_u32_e64 v221, vcc, v89, v217, vcc
		s_waitcnt lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], a[0:3], v[44:47], v[12:15], v27, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s4, s10, 1
		s_lshl_b32 s9, s4, 16
		v_add_u32_e32 v2, s9, v3
		v_add3_u32 v2, v2, v25, v23
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 a[212:215], v22 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[0:3], v[48:51], v[100:103], v27, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 a[216:219], v22 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[0:3], v[52:55], v[120:123], v27, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 a[220:223], v22 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[0:3], v[56:59], v[128:131], v27, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 a[224:227], v22 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[0:3], v[60:63], v[144:147], v27, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 a[228:231], v22 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[0:3], v[64:67], v[148:151], v27, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 a[232:235], v22 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[0:3], v[68:71], v[152:155], v27, v24 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 a[236:239], v22 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[0:3], v[72:75], v[156:159], v27, v24 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 a[240:243], v2 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[4:7], v[44:47], v[160:163], v27, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, s9, v25
		v_add3_u32 v2, v2, v1, v23
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 a[244:247], v22 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[4:7], v[48:51], v[164:167], v27, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 a[248:251], v22 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[4:7], v[52:55], v[168:171], v27, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 a[252:255], v22 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[4:7], v[56:59], v[172:175], v27, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 v[224:227], v22 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[4:7], v[60:63], v[176:179], v27, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 v[228:231], v22 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[4:7], v[64:67], v[180:183], v27, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[232:235], v2 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[4:7], v[68:71], v[184:187], v27, v24 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s9, s10, 1
		s_lshl_b32 s9, s9, 16
		v_and_b32_e32 v2, 15, v0
		v_lshlrev_b32_e32 v22, 6, v2
		v_add_u32_e32 v22, s9, v22
		v_lshrrev_b32_e32 v81, 6, v0
		v_and_b32_e32 v81, 1, v81
		v_lshlrev_b32_e32 v81, 13, v81
		v_and_b32_e32 v222, 63, v0
		v_lshrrev_b32_e32 v222, 4, v222
		v_lshrrev_b32_e32 v2, 1, v2
		v_bitop3_b32 v2, v222, v2, 3 bitop3:0x78
		v_lshlrev_b32_e32 v2, 4, v2
		s_mov_b32 m0, s15
		v_add3_u32 v2, v22, v81, v2
		ds_write_addtid_b32 v2 offset:8192
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 v[236:239], v22 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[4:7], v[72:75], a[16:19], v27, v24 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 v[240:243], v22 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[8:11], v[44:47], a[20:23], v76, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s40, 0x6000
		s_nop 0
		buffer_load_dwordx4 v104, s[20:23], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[8:11], v[48:51], a[24:27], v76, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v132, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[8:11], v[52:55], a[28:31], v76, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s40, 0x8000
		s_nop 0
		buffer_load_dwordx4 v188, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[8:11], v[56:59], a[32:35], v76, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s40, 0x9000
		s_nop 0
		buffer_load_dwordx4 v190, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[8:11], v[60:63], a[36:39], v76, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s40, 0xa000
		s_nop 0
		buffer_load_dwordx4 v192, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[8:11], v[64:67], a[40:43], v76, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s40, 0xb000
		s_nop 0
		buffer_load_dwordx4 v194, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[8:11], v[68:71], a[44:47], v76, v24 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s40, 0xc000
		s_nop 0
		buffer_load_dwordx4 v196, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[8:11], v[72:75], a[48:51], v76, v24 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s40, 0xd000
		s_nop 0
		buffer_load_dwordx4 v198, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[12:15], v[44:47], a[52:55], v76, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s40, 0xe000
		s_nop 0
		buffer_load_dwordx4 v200, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[12:15], v[48:51], a[56:59], v76, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s40, 0xf000
		s_nop 0
		buffer_load_dwordx4 v202, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[12:15], v[52:55], a[60:63], v76, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s40, 0x10000
		s_nop 0
		buffer_load_dwordx4 v204, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[12:15], v[56:59], a[64:67], v76, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s40, 0x11000
		s_nop 0
		buffer_load_dwordx4 v206, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[12:15], v[60:63], a[68:71], v76, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s40, 0x12000
		s_nop 0
		buffer_load_dwordx4 v208, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[12:15], v[64:67], a[72:75], v76, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s40, 0x13000
		s_nop 0
		buffer_load_dwordx4 v210, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[12:15], v[68:71], a[76:79], v76, v24 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s40, 0x14000
		s_nop 0
		buffer_load_dwordx4 v212, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[12:15], v[72:75], a[80:83], v76, v24 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s40, 0x15000
		s_nop 0
		buffer_load_dwordx4 v214, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[28:31], v[44:47], a[84:87], v77, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s9, s10, 1
		s_add_i32 m0, s11, 0x26000
		s_nop 0
		buffer_load_dwordx4 v218, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[28:31], v[48:51], a[88:91], v77, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshl_b32 s4, s4, 12
		s_add_i32 m0, s8, 0x26000
		s_nop 0
		buffer_load_dwordx4 v220, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[28:31], v[52:55], a[92:95], v77, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		s_and_b32 s16, s10, 1
		s_lshl_b32 s16, s16, 16
		v_lshrrev_b32_e32 v22, 7, v0
		v_lshlrev_b32_e32 v22, 13, v22
		v_add_u32_e32 v22, s16, v22
		v_and_b32_e32 v81, 15, v0
		v_lshlrev_b32_e32 v104, 6, v81
		v_and_b32_e32 v105, 63, v0
		v_lshrrev_b32_e32 v105, 4, v105
		v_lshrrev_b32_e32 v81, 1, v81
		v_bitop3_b32 v81, v105, v81, 3 bitop3:0x78
		v_lshlrev_b32_e32 v81, 4, v81
		v_add3_u32 v22, v22, v104, v81
		v_add_u32_e32 v81, 0x800, v22
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		ds_read_b128 a[0:3], v81
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[28:31], v[56:59], a[96:99], v77, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v81, 0x800, v22
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		ds_read_b128 a[4:7], v81 offset:1024
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[28:31], v[60:63], a[100:103], v77, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v81, 0x800, v22
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		ds_read_b128 a[8:11], v81 offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[28:31], v[64:67], a[104:107], v77, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v81, 0x800, v22
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		ds_read_b128 a[12:15], v81 offset:3072
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[28:31], v[68:71], a[108:111], v77, v24 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v81, 0x800, v22
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x800, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		v_add_u32_e32 v81, 0x400, v81
		ds_read_b128 v[188:191], v81 offset:4096
		s_mov_b32 s16, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v188, s16 offset:16
		scratch_store_dword off, v189, s16 offset:20
		scratch_store_dword off, v190, s16 offset:24
		scratch_store_dword off, v191, s16 offset:28
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[28:31], v[72:75], a[112:115], v77, v24 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v28, 0x800, v22
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		ds_read_b128 v[188:191], v28 offset:5120
		s_mov_b32 s16, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v188, s16 offset:32
		scratch_store_dword off, v189, s16 offset:36
		scratch_store_dword off, v190, s16 offset:40
		scratch_store_dword off, v191, s16 offset:44
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[32:35], v[44:47], a[116:119], v77, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v28, 0x800, v22
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		ds_read_b128 v[188:191], v28 offset:6144
		s_mov_b32 s16, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v188, s16 offset:48
		scratch_store_dword off, v189, s16 offset:52
		scratch_store_dword off, v190, s16 offset:56
		scratch_store_dword off, v191, s16 offset:60
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[32:35], v[48:51], a[120:123], v77, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 v[28:31], v22 offset:7168
		s_mov_b32 s16, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v28, s16 offset:64
		scratch_store_dword off, v29, s16 offset:68
		scratch_store_dword off, v30, s16 offset:72
		scratch_store_dword off, v31, s16 offset:76
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[32:35], v[52:55], a[124:127], v77, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 v[28:31], v22 offset:32768
		s_mov_b32 s16, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v28, s16 offset:80
		scratch_store_dword off, v29, s16 offset:84
		scratch_store_dword off, v30, s16 offset:88
		scratch_store_dword off, v31, s16 offset:92
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[32:35], v[56:59], a[128:131], v77, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 v[28:31], v22 offset:33792
		s_mov_b32 s16, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v28, s16 offset:96
		scratch_store_dword off, v29, s16 offset:100
		scratch_store_dword off, v30, s16 offset:104
		scratch_store_dword off, v31, s16 offset:108
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[32:35], v[60:63], a[132:135], v77, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 v[28:31], v22 offset:34816
		s_mov_b32 s16, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v28, s16 offset:112
		scratch_store_dword off, v29, s16 offset:116
		scratch_store_dword off, v30, s16 offset:120
		scratch_store_dword off, v31, s16 offset:124
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[32:35], v[64:67], a[136:139], v77, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 v[28:31], v22 offset:35840
		s_mov_b32 s16, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v28, s16 offset:128
		scratch_store_dword off, v29, s16 offset:132
		scratch_store_dword off, v30, s16 offset:136
		scratch_store_dword off, v31, s16 offset:140
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[32:35], v[68:71], a[140:143], v77, v24 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 v[28:31], v22 offset:36864
		s_mov_b32 s16, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v28, s16 offset:144
		scratch_store_dword off, v29, s16 offset:148
		scratch_store_dword off, v30, s16 offset:152
		scratch_store_dword off, v31, s16 offset:156
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], v[72:75], a[144:147], v77, v24 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 v[28:31], v22 offset:37888
		s_mov_b32 s16, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v28, s16 offset:160
		scratch_store_dword off, v29, s16 offset:164
		scratch_store_dword off, v30, s16 offset:168
		scratch_store_dword off, v31, s16 offset:172
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[36:39], v[44:47], a[148:151], v26, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[28:31], v2 offset:38912
		s_mov_b32 s16, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v28, s16 offset:176
		scratch_store_dword off, v29, s16 offset:180
		scratch_store_dword off, v30, s16 offset:184
		scratch_store_dword off, v31, s16 offset:188
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[36:39], v[48:51], a[152:155], v26, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v2 offset:8192
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[28:31], v2 offset:39936
		s_mov_b32 s16, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v28, s16 offset:192
		scratch_store_dword off, v29, s16 offset:196
		scratch_store_dword off, v30, s16 offset:200
		scratch_store_dword off, v31, s16 offset:204
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[36:39], v[52:55], a[156:159], v26, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s4, s4, 0x20000
		v_lshrrev_b32_e32 v2, 7, v0
		s_mov_b32 m0, s15
		v_lshlrev_b32_e32 v2, 10, v2
		ds_write_addtid_b32 v2 offset:17408
		v_and_b32_e32 v22, 63, v0
		v_lshlrev_b32_e32 v22, 2, v22
		v_add3_u32 v2, s4, v2, v22
		v_add_u32_e32 v28, 0x800, v2
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		ds_read_b32 v29, v28
		s_mov_b32 m0, s15
		s_waitcnt lgkmcnt(0)
		s_nop 0
		ds_write_addtid_b32 v29 offset:18432
		v_add_u32_e32 v28, 0x800, v2
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		ds_read_b32 v29, v28 offset:256
		s_mov_b32 m0, s15
		s_waitcnt lgkmcnt(0)
		s_nop 0
		ds_write_addtid_b32 v29 offset:19456
		v_add_u32_e32 v28, 0x800, v2
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		ds_read_b32 v29, v28 offset:512
		s_mov_b32 m0, s15
		s_waitcnt lgkmcnt(0)
		s_nop 0
		ds_write_addtid_b32 v29 offset:20480
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b32 v28, v2 offset:768
		s_mov_b32 m0, s15
		s_waitcnt lgkmcnt(0)
		s_nop 0
		ds_write_addtid_b32 v28 offset:21504
		v_lshrrev_b32_e32 v2, 6, v0
		v_and_b32_e32 v2, 1, v2
		v_lshlrev_b32_e32 v2, 10, v2
		v_add3_u32 v28, s4, v22, v2
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		ds_read_b32 v29, v28 offset:2048
		s_mov_b32 m0, s15
		s_waitcnt lgkmcnt(0)
		s_nop 0
		ds_write_addtid_b32 v29 offset:22528
		s_and_b32 s4, s10, 1
		s_lshl_b32 s4, s4, 12
		s_add_i32 s4, s4, 0x20000
		v_add3_u32 v28, s4, v22, v2
		v_add_u32_e32 v29, 0x800, v28
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x400, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x400, v29
		v_add_u32_e32 v29, 0x400, v29
		v_add_u32_e32 v29, 0x400, v29
		v_add_u32_e32 v29, 0x400, v29
		v_add_u32_e32 v29, 0x400, v29
		v_add_u32_e32 v29, 0x400, v29
		v_add_u32_e32 v29, 0x400, v29
		ds_read_b32 v30, v29 offset:2304
		s_mov_b32 m0, s15
		s_waitcnt lgkmcnt(0)
		s_nop 0
		ds_write_addtid_b32 v30 offset:23552
		v_add_u32_e32 v29, 0x800, v28
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x400, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x400, v29
		v_add_u32_e32 v29, 0x400, v29
		v_add_u32_e32 v29, 0x400, v29
		v_add_u32_e32 v29, 0x400, v29
		v_add_u32_e32 v29, 0x400, v29
		v_add_u32_e32 v29, 0x400, v29
		v_add_u32_e32 v29, 0x400, v29
		ds_read_b32 v30, v29 offset:2560
		s_mov_b32 s4, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v30, s4 offset:208
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		ds_read_b32 v29, v28 offset:2816
		s_mov_b32 s4, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v29, s4 offset:212
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], v[56:59], a[160:163], v26, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[40:43], v[56:59], a[192:195], v26, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[40:43], v[52:55], a[188:191], v26, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[40:43], v[44:47], a[180:183], v26, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[40:43], v[48:51], a[184:187], v26, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[40:43], v[60:63], a[196:199], v26, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[36:39], v[60:63], a[164:167], v26, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[36:39], v[64:67], a[168:171], v26, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[40:43], v[64:67], a[200:203], v26, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[40:43], v[68:71], a[204:207], v26, v24 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[36:39], v[68:71], a[172:175], v26, v24 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[36:39], v[72:75], a[176:179], v26, v24 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[40:43], v[72:75], a[208:211], v26, v24 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[236:239], v[236:239], a[172:175], v26, v24 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[236:239], v[240:243], a[176:179], v26, v24 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[240:243], v[240:243], a[208:211], v26, v24 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[240:243], v[236:239], a[204:207], v26, v24 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[212:215], v[236:239], v[152:155], v27, v24 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[212:215], v[240:243], v[156:159], v27, v24 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[216:219], v[240:243], a[16:19], v27, v24 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[216:219], v[236:239], v[184:187], v27, v24 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[216:219], a[244:247], v[160:163], v27, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], a[212:215], a[244:247], v[12:15], v27, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[212:215], a[248:251], v[100:103], v27, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[216:219], a[248:251], v[164:167], v27, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[216:219], a[252:255], v[168:171], v27, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[212:215], a[252:255], v[120:123], v27, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[212:215], v[224:227], v[128:131], v27, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[216:219], v[224:227], v[172:175], v27, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[216:219], v[228:231], v[176:179], v27, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[212:215], v[228:231], v[144:147], v27, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[212:215], v[232:235], v[148:151], v27, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[216:219], v[232:235], v[180:183], v27, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[220:223], v[232:235], a[40:43], v76, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[220:223], v[228:231], a[36:39], v76, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[224:227], v[228:231], a[68:71], v76, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[224:227], v[232:235], a[72:75], v76, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[224:227], a[244:247], a[52:55], v76, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[220:223], a[244:247], a[20:23], v76, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[220:223], a[248:251], a[24:27], v76, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[224:227], a[248:251], a[56:59], v76, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[224:227], a[252:255], a[60:63], v76, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[220:223], a[252:255], a[28:31], v76, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[220:223], v[224:227], a[32:35], v76, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[224:227], v[224:227], a[64:67], v76, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[224:227], v[236:239], a[76:79], v76, v24 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[220:223], v[236:239], a[44:47], v76, v24 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[220:223], v[240:243], a[48:51], v76, v24 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[224:227], v[240:243], a[80:83], v76, v24 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[228:231], v[240:243], a[112:115], v77, v24 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[228:231], v[236:239], a[108:111], v77, v24 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[232:235], v[236:239], a[140:143], v77, v24 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[232:235], v[240:243], a[144:147], v77, v24 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[232:235], a[244:247], a[116:119], v77, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[228:231], a[244:247], a[84:87], v77, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], a[228:231], a[248:251], a[88:91], v77, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[232:235], a[248:251], a[120:123], v77, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[232:235], a[252:255], a[124:127], v77, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], a[228:231], a[252:255], a[92:95], v77, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[228:231], v[224:227], a[96:99], v77, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[232:235], v[224:227], a[128:131], v77, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[232:235], v[228:231], a[132:135], v77, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[228:231], v[228:231], a[100:103], v77, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[228:231], v[232:235], a[104:107], v77, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[232:235], v[232:235], a[136:139], v77, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[236:239], v[232:235], a[168:171], v26, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[236:239], v[228:231], a[164:167], v26, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[240:243], v[228:231], a[196:199], v26, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[240:243], v[232:235], a[200:203], v26, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[240:243], a[244:247], a[180:183], v26, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[236:239], a[244:247], a[148:151], v26, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[236:239], a[248:251], a[152:155], v26, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[240:243], a[248:251], a[184:187], v26, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[240:243], a[252:255], a[188:191], v26, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[236:239], a[252:255], a[156:159], v26, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[236:239], v[224:227], a[160:163], v26, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[240:243], v[224:227], a[192:195], v26, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s4, s9, 1
		s_lshl_b32 s9, s4, 16
		v_lshrrev_b32_e32 v24, 7, v0
		v_lshlrev_b32_e32 v24, 13, v24
		v_add_u32_e32 v24, s9, v24
		v_and_b32_e32 v26, 15, v0
		v_lshlrev_b32_e32 v26, 6, v26
		v_and_b32_e32 v27, 63, v0
		v_lshrrev_b32_e32 v27, 4, v27
		v_and_b32_e32 v28, 15, v0
		v_lshrrev_b32_e32 v28, 1, v28
		v_bitop3_b32 v27, v27, v28, 3 bitop3:0x78
		v_lshlrev_b32_e32 v27, 4, v27
		v_add3_u32 v24, v24, v26, v27
		v_add_u32_e32 v28, 0x800, v24
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		ds_read_b128 v[32:35], v28
		v_add_u32_e32 v28, 0x800, v24
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		ds_read_b128 v[36:39], v28 offset:1024
		s_mov_b32 s16, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v36, s16 offset:320
		scratch_store_dword off, v37, s16 offset:324
		scratch_store_dword off, v38, s16 offset:328
		scratch_store_dword off, v39, s16 offset:332
		v_add_u32_e32 v28, 0x800, v24
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		ds_read_b128 v[40:43], v28 offset:2048
		s_mov_b32 s16, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v40, s16 offset:380
		scratch_store_dword off, v41, s16 offset:384
		scratch_store_dword off, v42, s16 offset:388
		scratch_store_dword off, v43, s16 offset:392
		v_add_u32_e32 v28, 0x800, v24
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		ds_read_b128 v[40:43], v28 offset:3072
		s_mov_b32 s16, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v40, s16 offset:396
		scratch_store_dword off, v41, s16 offset:400
		scratch_store_dword off, v42, s16 offset:404
		scratch_store_dword off, v43, s16 offset:408
		v_add_u32_e32 v28, 0x800, v24
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		ds_read_b128 v[188:191], v28 offset:4096
		v_add_u32_e32 v28, 0x800, v24
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		ds_read_b128 a[212:215], v28 offset:5120
		v_add_u32_e32 v28, 0x800, v24
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		ds_read_b128 a[216:219], v28 offset:6144
		v_add_u32_e32 v28, 0x800, v24
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		ds_read_b128 a[220:223], v28 offset:7168
		v_add_u32_e32 v26, s9, v26
		v_lshrrev_b32_e32 v28, 6, v0
		v_and_b32_e32 v28, 1, v28
		v_lshlrev_b32_e32 v28, 13, v28
		v_add3_u32 v26, v26, v28, v27
		s_mov_b32 s9, 0
		scratch_store_dword off, v26, s9 offset:336
		v_add_u32_e32 v27, 0x800, v26
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		ds_read_b128 a[224:227], v27 offset:32768
		v_add_u32_e32 v27, 0x800, v26
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		ds_read_b128 a[228:231], v27 offset:33792
		v_add_u32_e32 v27, 0x800, v26
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		ds_read_b128 a[232:235], v27 offset:34816
		v_add_u32_e32 v27, 0x800, v26
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		ds_read_b128 a[236:239], v27 offset:35840
		v_add_u32_e32 v27, 0x800, v26
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		ds_read_b128 a[240:243], v27 offset:36864
		v_add_u32_e32 v27, 0x800, v26
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		ds_read_b128 a[244:247], v27 offset:37888
		v_add_u32_e32 v27, 0x800, v26
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		ds_read_b128 a[248:251], v27 offset:38912
		v_add_u32_e32 v27, 0x800, v26
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		ds_read_b128 a[252:255], v27 offset:39936
		s_lshl_b32 s4, s4, 12
		s_mov_b32 m0, s15
		s_add_i32 s4, s4, 0x20000
		ds_read_addtid_b32 v27 offset:17408
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v27, s4, v27, v22
		v_add_u32_e32 v28, 0x800, v27
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		ds_read_b32 v79, v28
		v_add_u32_e32 v28, 0x800, v27
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		ds_read_b32 v80, v28 offset:256
		v_add_u32_e32 v28, 0x800, v27
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x400, v28
		ds_read_b32 v81, v28 offset:512
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x400, v27
		ds_read_b32 v104, v27 offset:768
		v_add3_u32 v2, s4, v22, v2
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b32 v105, v22 offset:2048
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b32 v132, v22 offset:2304
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b32 v133, v22 offset:2560
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b32 v22, v2 offset:2816
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v28
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v29 offset:1024
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v30, vcc, v28, v94
		v_addc_co_u32_e64 v31, vcc, v29, v95, vcc
		s_mov_b32 s4, 0
		scratch_store_dword off, v30, s4 offset:216
		scratch_store_dword off, v31, s4 offset:220
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v28 offset:2048
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v29 offset:3072
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v30, vcc, v28, v94
		v_addc_co_u32_e64 v31, vcc, v29, v95, vcc
		s_mov_b32 s4, 0
		scratch_store_dword off, v30, s4 offset:224
		scratch_store_dword off, v31, s4 offset:228
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v28 offset:4096
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v29 offset:5120
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v30, vcc, v28, v94
		v_addc_co_u32_e64 v31, vcc, v29, v95, vcc
		s_mov_b32 s4, 0
		scratch_store_dword off, v30, s4 offset:232
		scratch_store_dword off, v31, s4 offset:236
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v28 offset:6144
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v29 offset:7168
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v30, vcc, v28, v94
		v_addc_co_u32_e64 v31, vcc, v29, v95, vcc
		s_mov_b32 s4, 0
		scratch_store_dword off, v30, s4 offset:240
		scratch_store_dword off, v31, s4 offset:244
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v28 offset:9216
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v29 offset:10240
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v30, vcc, v28, v94
		v_addc_co_u32_e64 v31, vcc, v29, v95, vcc
		s_mov_b32 s4, 0
		scratch_store_dword off, v30, s4 offset:248
		scratch_store_dword off, v31, s4 offset:252
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v28 offset:11264
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v29 offset:12288
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v30, vcc, v28, v94
		v_addc_co_u32_e64 v31, vcc, v29, v95, vcc
		s_mov_b32 s4, 0
		scratch_store_dword off, v30, s4 offset:256
		scratch_store_dword off, v31, s4 offset:260
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v28 offset:13312
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v29 offset:14336
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v30, vcc, v28, v94
		v_addc_co_u32_e64 v31, vcc, v29, v95, vcc
		s_mov_b32 s4, 0
		scratch_store_dword off, v30, s4 offset:264
		scratch_store_dword off, v31, s4 offset:268
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v28 offset:15360
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v29 offset:16384
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v30, vcc, v28, v94
		v_addc_co_u32_e64 v31, vcc, v29, v95, vcc
		s_mov_b32 s4, 0
		scratch_store_dword off, v30, s4 offset:272
		scratch_store_dword off, v31, s4 offset:276
		v_add_co_u32_e64 v28, vcc, v134, v94
		v_addc_co_u32_e64 v29, vcc, v135, v95, vcc
		s_mov_b32 s4, 0
		scratch_store_dword off, v28, s4 offset:280
		scratch_store_dword off, v29, s4 offset:284
		v_add_co_u32_e64 v28, vcc, v136, v94
		v_addc_co_u32_e64 v29, vcc, v137, v95, vcc
		s_mov_b32 s4, 0
		scratch_store_dword off, v28, s4 offset:288
		scratch_store_dword off, v29, s4 offset:292
		v_add_co_u32_e64 v28, vcc, v138, v94
		v_addc_co_u32_e64 v29, vcc, v139, v95, vcc
		s_mov_b32 s4, 0
		scratch_store_dword off, v28, s4 offset:296
		scratch_store_dword off, v29, s4 offset:300
		v_add_co_u32_e64 v28, vcc, v140, v94
		v_addc_co_u32_e64 v29, vcc, v141, v95, vcc
		s_mov_b32 s4, 0
		scratch_store_dword off, v28, s4 offset:304
		scratch_store_dword off, v29, s4 offset:308
		v_add_co_u32_e64 v28, vcc, v90, v94
		v_addc_co_u32_e64 v29, vcc, v91, v95, vcc
		s_mov_b32 s4, 0
		scratch_store_dword off, v28, s4 offset:312
		scratch_store_dword off, v29, s4 offset:316
		v_add_co_u32_e64 v28, vcc, v142, v94
		v_addc_co_u32_e64 v29, vcc, v143, v95, vcc
		s_mov_b32 s4, 0
		scratch_store_dword off, v28, s4 offset:340
		scratch_store_dword off, v29, s4 offset:344
		v_add_co_u32_e64 v28, vcc, v92, v94
		v_addc_co_u32_e64 v29, vcc, v93, v95, vcc
		s_mov_b32 s4, 0
		scratch_store_dword off, v28, s4 offset:348
		scratch_store_dword off, v29, s4 offset:352
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(63) expcnt(7) lgkmcnt(15)
		scratch_load_dword v28, off, s4
		scratch_load_dword v29, off, s4 offset:4
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v30, vcc, v28, v94
		v_addc_co_u32_e64 v31, vcc, v29, v95, vcc
		s_mov_b32 s4, 0
		scratch_store_dword off, v30, s4 offset:356
		scratch_store_dword off, v31, s4 offset:360
		s_mov_b32 s4, 0
		scratch_load_dword v28, off, s4 offset:8
		scratch_load_dword v29, off, s4 offset:12
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v30, vcc, v28, v216
		v_addc_co_u32_e64 v31, vcc, v29, v217, vcc
		s_mov_b32 s4, 0
		scratch_store_dword off, v30, s4 offset:364
		scratch_store_dword off, v31, s4 offset:368
		v_add_co_u32_e64 v28, vcc, v8, v216
		v_addc_co_u32_e64 v29, vcc, v9, v217, vcc
		s_mov_b32 s4, 0
		scratch_store_dword off, v28, s4 offset:372
		scratch_store_dword off, v29, s4 offset:376
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[32:35], a[224:227], v[12:15], v79, v105 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v24
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[192:195], v2 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[32:35], a[228:231], v[100:103], v79, v105 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v24
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[196:199], v2 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[32:35], a[232:235], v[120:123], v79, v132 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v24
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[200:203], v2 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[32:35], a[236:239], v[128:131], v79, v132 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v24
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[204:207], v2 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[32:35], a[240:243], v[144:147], v79, v133 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v24
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[208:211], v2 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[32:35], a[244:247], v[148:151], v79, v133 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v24
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[212:215], v2 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[32:35], a[248:251], v[152:155], v79, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v24
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[216:219], v2 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[32:35], a[252:255], v[156:159], v79, v22 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v24
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[220:223], v2 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[36:39], a[224:227], v[160:163], v79, v105 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v26
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[224:227], v2 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], a[228:231], v[164:167], v79, v105 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v26
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[228:231], v2 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], a[232:235], v[168:171], v79, v132 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v26
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[232:235], v2 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[36:39], a[236:239], v[172:175], v79, v132 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v26
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[236:239], v2 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[36:39], a[240:243], v[176:179], v79, v133 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v26
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[240:243], v2 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[36:39], a[244:247], v[180:183], v79, v133 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v26
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[244:247], v2 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[36:39], a[248:251], v[184:187], v79, v22 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v26
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[248:251], v2 offset:55296
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(45)
		scratch_load_dword v28, off, s4 offset:320
		scratch_load_dword v29, off, s4 offset:324
		scratch_load_dword v30, off, s4 offset:328
		scratch_load_dword v31, off, s4 offset:332
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[28:31], a[252:255], a[16:19], v79, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(36)
		scratch_load_dword v2, off, s4 offset:336
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[252:255], v2 offset:56320
		s_mov_b32 s4, 0
		scratch_load_dword v28, off, s4 offset:380
		scratch_load_dword v29, off, s4 offset:384
		scratch_load_dword v30, off, s4 offset:388
		scratch_load_dword v31, off, s4 offset:392
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[28:31], a[224:227], a[20:23], v80, v105 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(34)
		scratch_load_dword v26, off, s4 offset:216
		scratch_load_dword v27, off, s4 offset:220
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v2 offset:22528
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v78, v2
		s_add_i32 m0, s40, 0x16000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v26, s[20:23], 0 offen lds
		s_mov_b32 s4, 0
		scratch_load_dword v28, off, s4 offset:380
		scratch_load_dword v29, off, s4 offset:384
		scratch_load_dword v30, off, s4 offset:388
		scratch_load_dword v31, off, s4 offset:392
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[28:31], a[228:231], a[24:27], v80, v105 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(32)
		scratch_load_dword v28, off, s4 offset:224
		scratch_load_dword v29, off, s4 offset:228
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v2 offset:21504
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v26, v2
		s_add_i32 m0, s40, 0x17000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v28, s[20:23], 0 offen lds
		s_mov_b32 s4, 0
		scratch_load_dword v28, off, s4 offset:380
		scratch_load_dword v29, off, s4 offset:384
		scratch_load_dword v30, off, s4 offset:388
		scratch_load_dword v31, off, s4 offset:392
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[28:31], a[232:235], a[28:31], v80, v132 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(30)
		scratch_load_dword v28, off, s4 offset:232
		scratch_load_dword v29, off, s4 offset:236
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v2 offset:20480
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v77, v2
		s_add_i32 m0, s40, 0x18000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v28, s[20:23], 0 offen lds
		s_mov_b32 s4, 0
		scratch_load_dword v28, off, s4 offset:380
		scratch_load_dword v29, off, s4 offset:384
		scratch_load_dword v30, off, s4 offset:388
		scratch_load_dword v31, off, s4 offset:392
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[28:31], a[236:239], a[32:35], v80, v132 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(28)
		scratch_load_dword v28, off, s4 offset:240
		scratch_load_dword v29, off, s4 offset:244
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v2 offset:19456
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v76, v2
		s_add_i32 m0, s40, 0x19000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v28, s[20:23], 0 offen lds
		s_mov_b32 s4, 0
		scratch_load_dword v28, off, s4 offset:380
		scratch_load_dword v29, off, s4 offset:384
		scratch_load_dword v30, off, s4 offset:388
		scratch_load_dword v31, off, s4 offset:392
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[28:31], a[240:243], a[36:39], v80, v133 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(26)
		scratch_load_dword v28, off, s4 offset:248
		scratch_load_dword v29, off, s4 offset:252
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v2 offset:18432
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v27, v2
		s_add_i32 m0, s40, 0x1a000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v28, s[20:23], 0 offen lds
		s_mov_b32 s4, 0
		scratch_load_dword v28, off, s4 offset:380
		scratch_load_dword v29, off, s4 offset:384
		scratch_load_dword v30, off, s4 offset:388
		scratch_load_dword v31, off, s4 offset:392
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[28:31], a[244:247], a[40:43], v80, v133 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v28, off, s4 offset:256
		scratch_load_dword v29, off, s4 offset:260
		s_mov_b32 s4, 0
		scratch_load_dword v32, off, s4 offset:192
		scratch_load_dword v33, off, s4 offset:196
		scratch_load_dword v34, off, s4 offset:200
		scratch_load_dword v35, off, s4 offset:204
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v72, v32
		v_mov_b32_e32 v73, v33
		v_mov_b32_e32 v74, v34
		v_mov_b32_e32 v75, v35
		s_add_i32 m0, s40, 0x1b000
		s_nop 0
		buffer_load_dwordx4 v28, s[20:23], 0 offen lds
		s_mov_b32 s4, 0
		scratch_load_dword v28, off, s4 offset:380
		scratch_load_dword v29, off, s4 offset:384
		scratch_load_dword v30, off, s4 offset:388
		scratch_load_dword v31, off, s4 offset:392
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[28:31], a[248:251], a[44:47], v80, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(22)
		scratch_load_dword v28, off, s4 offset:264
		scratch_load_dword v29, off, s4 offset:268
		s_mov_b32 s4, 0
		scratch_load_dword v32, off, s4 offset:176
		scratch_load_dword v33, off, s4 offset:180
		scratch_load_dword v34, off, s4 offset:184
		scratch_load_dword v35, off, s4 offset:188
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v68, v32
		v_mov_b32_e32 v69, v33
		v_mov_b32_e32 v70, v34
		v_mov_b32_e32 v71, v35
		s_add_i32 m0, s40, 0x1c000
		s_nop 0
		buffer_load_dwordx4 v28, s[20:23], 0 offen lds
		s_mov_b32 s4, 0
		scratch_load_dword v28, off, s4 offset:380
		scratch_load_dword v29, off, s4 offset:384
		scratch_load_dword v30, off, s4 offset:388
		scratch_load_dword v31, off, s4 offset:392
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[28:31], a[252:255], a[48:51], v80, v22 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(20)
		scratch_load_dword v28, off, s4 offset:272
		scratch_load_dword v29, off, s4 offset:276
		s_mov_b32 s4, 0
		scratch_load_dword v32, off, s4 offset:160
		scratch_load_dword v33, off, s4 offset:164
		scratch_load_dword v34, off, s4 offset:168
		scratch_load_dword v35, off, s4 offset:172
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v64, v32
		v_mov_b32_e32 v65, v33
		v_mov_b32_e32 v66, v34
		v_mov_b32_e32 v67, v35
		s_add_i32 m0, s40, 0x1d000
		s_nop 0
		buffer_load_dwordx4 v28, s[20:23], 0 offen lds
		s_mov_b32 s4, 0
		scratch_load_dword v28, off, s4 offset:396
		scratch_load_dword v29, off, s4 offset:400
		scratch_load_dword v30, off, s4 offset:404
		scratch_load_dword v31, off, s4 offset:408
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[28:31], a[224:227], a[52:55], v80, v105 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(18)
		scratch_load_dword v28, off, s4 offset:280
		scratch_load_dword v29, off, s4 offset:284
		s_mov_b32 s4, 0
		scratch_load_dword v32, off, s4 offset:144
		scratch_load_dword v33, off, s4 offset:148
		scratch_load_dword v34, off, s4 offset:152
		scratch_load_dword v35, off, s4 offset:156
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v60, v32
		v_mov_b32_e32 v61, v33
		v_mov_b32_e32 v62, v34
		v_mov_b32_e32 v63, v35
		s_add_i32 m0, s40, 0x1e000
		s_nop 0
		buffer_load_dwordx4 v28, s[0:3], 0 offen lds
		s_mov_b32 s4, 0
		scratch_load_dword v28, off, s4 offset:396
		scratch_load_dword v29, off, s4 offset:400
		scratch_load_dword v30, off, s4 offset:404
		scratch_load_dword v31, off, s4 offset:408
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[28:31], a[228:231], a[56:59], v80, v105 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v28, off, s4 offset:288
		scratch_load_dword v29, off, s4 offset:292
		s_mov_b32 s4, 0
		scratch_load_dword v32, off, s4 offset:128
		scratch_load_dword v33, off, s4 offset:132
		scratch_load_dword v34, off, s4 offset:136
		scratch_load_dword v35, off, s4 offset:140
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v56, v32
		v_mov_b32_e32 v57, v33
		v_mov_b32_e32 v58, v34
		v_mov_b32_e32 v59, v35
		s_add_i32 m0, s40, 0x1f000
		s_nop 0
		buffer_load_dwordx4 v28, s[0:3], 0 offen lds
		s_mov_b32 s4, 0
		scratch_load_dword v28, off, s4 offset:396
		scratch_load_dword v29, off, s4 offset:400
		scratch_load_dword v30, off, s4 offset:404
		scratch_load_dword v31, off, s4 offset:408
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[28:31], a[232:235], a[60:63], v80, v132 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(14)
		scratch_load_dword v28, off, s4 offset:296
		scratch_load_dword v29, off, s4 offset:300
		s_mov_b32 s4, 0
		scratch_load_dword v32, off, s4 offset:112
		scratch_load_dword v33, off, s4 offset:116
		scratch_load_dword v34, off, s4 offset:120
		scratch_load_dword v35, off, s4 offset:124
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v52, v32
		v_mov_b32_e32 v53, v33
		v_mov_b32_e32 v54, v34
		v_mov_b32_e32 v55, v35
		s_add_i32 m0, s40, 0x20000
		s_nop 0
		buffer_load_dwordx4 v28, s[0:3], 0 offen lds
		s_mov_b32 s4, 0
		scratch_load_dword v28, off, s4 offset:396
		scratch_load_dword v29, off, s4 offset:400
		scratch_load_dword v30, off, s4 offset:404
		scratch_load_dword v31, off, s4 offset:408
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[28:31], a[236:239], a[64:67], v80, v132 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(12)
		scratch_load_dword v28, off, s4 offset:304
		scratch_load_dword v29, off, s4 offset:308
		s_mov_b32 s4, 0
		scratch_load_dword v32, off, s4 offset:96
		scratch_load_dword v33, off, s4 offset:100
		scratch_load_dword v34, off, s4 offset:104
		scratch_load_dword v35, off, s4 offset:108
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v48, v32
		v_mov_b32_e32 v49, v33
		v_mov_b32_e32 v50, v34
		v_mov_b32_e32 v51, v35
		s_add_i32 m0, s40, 0x21000
		s_nop 0
		buffer_load_dwordx4 v28, s[0:3], 0 offen lds
		s_mov_b32 s4, 0
		scratch_load_dword v28, off, s4 offset:396
		scratch_load_dword v29, off, s4 offset:400
		scratch_load_dword v30, off, s4 offset:404
		scratch_load_dword v31, off, s4 offset:408
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[28:31], a[240:243], a[68:71], v80, v133 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(10)
		scratch_load_dword v28, off, s4 offset:312
		scratch_load_dword v29, off, s4 offset:316
		s_mov_b32 s4, 0
		scratch_load_dword v32, off, s4 offset:80
		scratch_load_dword v33, off, s4 offset:84
		scratch_load_dword v34, off, s4 offset:88
		scratch_load_dword v35, off, s4 offset:92
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v44, v32
		v_mov_b32_e32 v45, v33
		v_mov_b32_e32 v46, v34
		v_mov_b32_e32 v47, v35
		s_add_i32 m0, s40, 0x22000
		s_nop 0
		buffer_load_dwordx4 v28, s[0:3], 0 offen lds
		s_mov_b32 s4, 0
		scratch_load_dword v28, off, s4 offset:396
		scratch_load_dword v29, off, s4 offset:400
		scratch_load_dword v30, off, s4 offset:404
		scratch_load_dword v31, off, s4 offset:408
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[28:31], a[244:247], a[72:75], v80, v133 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v28, off, s4 offset:340
		scratch_load_dword v29, off, s4 offset:344
		s_mov_b32 s4, 0
		scratch_load_dword v32, off, s4 offset:64
		scratch_load_dword v33, off, s4 offset:68
		scratch_load_dword v34, off, s4 offset:72
		scratch_load_dword v35, off, s4 offset:76
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v40, v32
		v_mov_b32_e32 v41, v33
		v_mov_b32_e32 v42, v34
		v_mov_b32_e32 v43, v35
		s_add_i32 m0, s40, 0x23000
		s_nop 0
		buffer_load_dwordx4 v28, s[0:3], 0 offen lds
		s_mov_b32 s4, 0
		scratch_load_dword v28, off, s4 offset:396
		scratch_load_dword v29, off, s4 offset:400
		scratch_load_dword v30, off, s4 offset:404
		scratch_load_dword v31, off, s4 offset:408
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[28:31], a[248:251], a[76:79], v80, v22 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(6)
		scratch_load_dword v28, off, s4 offset:348
		scratch_load_dword v29, off, s4 offset:352
		s_mov_b32 s4, 0
		scratch_load_dword v32, off, s4 offset:48
		scratch_load_dword v33, off, s4 offset:52
		scratch_load_dword v34, off, s4 offset:56
		scratch_load_dword v35, off, s4 offset:60
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v36, v32
		v_mov_b32_e32 v37, v33
		v_mov_b32_e32 v38, v34
		v_mov_b32_e32 v39, v35
		s_add_i32 m0, s40, 0x24000
		s_nop 0
		buffer_load_dwordx4 v28, s[0:3], 0 offen lds
		s_mov_b32 s4, 0
		scratch_load_dword v28, off, s4 offset:396
		scratch_load_dword v29, off, s4 offset:400
		scratch_load_dword v30, off, s4 offset:404
		scratch_load_dword v31, off, s4 offset:408
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[28:31], a[252:255], a[80:83], v80, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v28, off, s4 offset:356
		scratch_load_dword v29, off, s4 offset:360
		s_mov_b32 s4, 0
		scratch_load_dword v32, off, s4 offset:32
		scratch_load_dword v33, off, s4 offset:36
		scratch_load_dword v34, off, s4 offset:40
		scratch_load_dword v35, off, s4 offset:44
		s_add_i32 m0, s40, 0x25000
		s_waitcnt vmcnt(4)
		s_nop 0
		buffer_load_dwordx4 v28, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[188:191], a[224:227], a[84:87], v81, v105 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(2)
		scratch_load_dword v94, off, s4 offset:364
		scratch_load_dword v95, off, s4 offset:368
		s_mov_b32 s4, 0
		scratch_load_dword v28, off, s4 offset:16
		scratch_load_dword v29, off, s4 offset:20
		scratch_load_dword v30, off, s4 offset:24
		scratch_load_dword v31, off, s4 offset:28
		s_add_i32 m0, s11, 0x27000
		s_waitcnt vmcnt(4)
		s_nop 0
		buffer_load_dwordx4 v94, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[188:191], a[228:231], a[88:91], v81, v105 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s10, s10, 2
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v94, off, s4 offset:372
		scratch_load_dword v95, off, s4 offset:376
		s_add_i32 m0, s8, 0x27000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v94, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[188:191], a[232:235], a[92:95], v81, v132 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[188:191], a[236:239], a[96:99], v81, v132 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[212:215], a[236:239], a[128:131], v81, v132 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[212:215], a[232:235], a[124:127], v81, v132 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[212:215], a[224:227], a[116:119], v81, v105 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[212:215], a[228:231], a[120:123], v81, v105 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[212:215], a[240:243], a[132:135], v81, v133 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[188:191], a[240:243], a[100:103], v81, v133 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[188:191], a[244:247], a[104:107], v81, v133 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[212:215], a[244:247], a[136:139], v81, v133 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[212:215], a[248:251], a[140:143], v81, v22 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[188:191], a[248:251], a[108:111], v81, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[188:191], a[252:255], a[112:115], v81, v22 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[212:215], a[252:255], a[144:147], v81, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[216:219], a[252:255], a[176:179], v104, v22 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[216:219], a[248:251], a[172:175], v104, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[220:223], a[248:251], a[204:207], v104, v22 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[220:223], a[252:255], a[208:211], v104, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[220:223], a[224:227], a[180:183], v104, v105 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[216:219], a[224:227], a[148:151], v104, v105 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[216:219], a[228:231], a[152:155], v104, v105 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[220:223], a[228:231], a[184:187], v104, v105 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[220:223], a[232:235], a[188:191], v104, v132 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[216:219], a[232:235], a[156:159], v104, v132 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[216:219], a[236:239], a[160:163], v104, v132 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[220:223], a[236:239], a[192:195], v104, v132 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[220:223], a[240:243], a[196:199], v104, v133 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[216:219], a[240:243], a[164:167], v104, v133 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[216:219], a[244:247], a[168:171], v104, v133 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[220:223], a[244:247], a[200:203], v104, v133 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[192:195], v[224:227], v[12:15], v79, v105 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[192:195], v[228:231], v[100:103], v79, v105 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[196:199], v[228:231], v[164:167], v79, v105 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[196:199], v[224:227], v[160:163], v79, v105 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[196:199], v[232:235], v[168:171], v79, v132 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[192:195], v[232:235], v[120:123], v79, v132 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[192:195], v[236:239], v[128:131], v79, v132 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[196:199], v[236:239], v[172:175], v79, v132 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[196:199], v[240:243], v[176:179], v79, v133 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[192:195], v[240:243], v[144:147], v79, v133 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[192:195], v[244:247], v[148:151], v79, v133 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[196:199], v[244:247], v[180:183], v79, v133 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[196:199], v[248:251], v[184:187], v79, v22 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[192:195], v[248:251], v[152:155], v79, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[192:195], v[252:255], v[156:159], v79, v22 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[196:199], v[252:255], a[16:19], v79, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[200:203], v[252:255], a[48:51], v80, v22 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[200:203], v[248:251], a[44:47], v80, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[204:207], v[248:251], a[76:79], v80, v22 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[204:207], v[252:255], a[80:83], v80, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[204:207], v[224:227], a[52:55], v80, v105 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[200:203], v[224:227], a[20:23], v80, v105 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[200:203], v[228:231], a[24:27], v80, v105 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[204:207], v[228:231], a[56:59], v80, v105 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[204:207], v[232:235], a[60:63], v80, v132 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[200:203], v[232:235], a[28:31], v80, v132 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[200:203], v[236:239], a[32:35], v80, v132 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[204:207], v[236:239], a[64:67], v80, v132 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[204:207], v[240:243], a[68:71], v80, v133 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[200:203], v[240:243], a[36:39], v80, v133 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[200:203], v[244:247], a[40:43], v80, v133 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[204:207], v[244:247], a[72:75], v80, v133 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[208:211], v[244:247], a[104:107], v81, v133 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[208:211], v[240:243], a[100:103], v81, v133 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[212:215], v[240:243], a[132:135], v81, v133 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[212:215], v[244:247], a[136:139], v81, v133 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[212:215], v[224:227], a[116:119], v81, v105 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[208:211], v[224:227], a[84:87], v81, v105 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[208:211], v[228:231], a[88:91], v81, v105 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[212:215], v[228:231], a[120:123], v81, v105 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[212:215], v[232:235], a[124:127], v81, v132 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[208:211], v[232:235], a[92:95], v81, v132 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[208:211], v[236:239], a[96:99], v81, v132 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[212:215], v[236:239], a[128:131], v81, v132 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[212:215], v[248:251], a[140:143], v81, v22 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[208:211], v[248:251], a[108:111], v81, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[208:211], v[252:255], a[112:115], v81, v22 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[212:215], v[252:255], a[144:147], v81, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[216:219], v[252:255], a[176:179], v104, v22 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[216:219], v[248:251], a[172:175], v104, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[220:223], v[248:251], a[204:207], v104, v22 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[220:223], v[252:255], a[208:211], v104, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[220:223], v[224:227], a[180:183], v104, v105 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[216:219], v[224:227], a[148:151], v104, v105 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[216:219], v[228:231], a[152:155], v104, v105 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[220:223], v[228:231], a[184:187], v104, v105 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[220:223], v[232:235], a[188:191], v104, v132 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[216:219], v[232:235], a[156:159], v104, v132 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[216:219], v[236:239], a[160:163], v104, v132 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[220:223], v[236:239], a[192:195], v104, v132 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[220:223], v[240:243], a[196:199], v104, v133 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[216:219], v[240:243], a[164:167], v104, v133 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[216:219], v[244:247], a[168:171], v104, v133 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[220:223], v[244:247], a[200:203], v104, v133 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_cmp_lt_i32 s10, s5
		ds_read_addtid_b32 v2 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v79, v2
		s_mov_b32 s4, 0
		scratch_load_dword v2, off, s4 offset:208
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v80, v2
		s_mov_b32 s4, 0
		scratch_load_dword v2, off, s4 offset:212
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v24, v2
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_add_i32 s0, s12, -1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], a[0:3], v[44:47], v[12:15], v27, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s0, s0, 1
		s_lshl_b32 s0, s0, 16
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v1, 13, v1
		v_add_u32_e32 v2, s0, v1
		v_and_b32_e32 v3, 15, v0
		v_lshlrev_b32_e32 v3, 6, v3
		v_and_b32_e32 v4, 63, v0
		v_lshrrev_b32_e32 v4, 4, v4
		v_and_b32_e32 v5, 15, v0
		v_lshrrev_b32_e32 v5, 1, v5
		v_bitop3_b32 v4, v4, v5, 3 bitop3:0x78
		v_lshlrev_b32_e32 v4, 4, v4
		v_add3_u32 v2, v2, v3, v4
		v_add_u32_e32 v5, 0x800, v2
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		ds_read_b128 v[8:11], v5 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[0:3], v[48:51], v[100:103], v27, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x800, v2
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		ds_read_b128 v[16:19], v5 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], a[0:3], v[52:55], v[120:123], v27, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x800, v2
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		ds_read_b128 v[20:23], v5 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[0:3], v[56:59], v[128:131], v27, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x800, v2
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		ds_read_b128 v[84:87], v5 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[0:3], v[60:63], v[144:147], v27, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x800, v2
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		ds_read_b128 v[88:91], v5 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[0:3], v[64:67], v[148:151], v27, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x800, v2
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		ds_read_b128 v[92:95], v5 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[0:3], v[68:71], v[152:155], v27, v24 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x800, v2
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		ds_read_b128 v[96:99], v5 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[0:3], v[72:75], v[156:159], v27, v24 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[104:107], v2 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[4:7], v[44:47], v[160:163], v27, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, s0, v3
		v_lshrrev_b32_e32 v5, 6, v0
		v_and_b32_e32 v5, 1, v5
		v_lshlrev_b32_e32 v5, 13, v5
		v_add3_u32 v2, v2, v5, v4
		v_add_u32_e32 v6, 0x800, v2
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		ds_read_b128 v[108:111], v6 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[4:7], v[48:51], v[164:167], v27, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v6, 0x800, v2
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		ds_read_b128 v[112:115], v6 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[4:7], v[52:55], v[168:171], v27, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v6, 0x800, v2
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		ds_read_b128 v[116:119], v6 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[4:7], v[56:59], v[172:175], v27, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v6, 0x800, v2
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		ds_read_b128 v[124:127], v6 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[4:7], v[60:63], v[176:179], v27, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v6, 0x800, v2
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		ds_read_b128 v[132:135], v6 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[4:7], v[64:67], v[180:183], v27, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v6, 0x800, v2
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		ds_read_b128 v[136:139], v6 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[4:7], v[68:71], v[184:187], v27, v24 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v6, 0x800, v2
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		ds_read_b128 v[140:143], v6 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[4:7], v[72:75], a[16:19], v27, v24 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[188:191], v2 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[8:11], v[44:47], a[20:23], v76, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[8:11], v[48:51], a[24:27], v76, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[12:15], v[48:51], a[56:59], v76, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[12:15], v[44:47], a[52:55], v76, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[12:15], v[52:55], a[60:63], v76, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[8:11], v[52:55], a[28:31], v76, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[8:11], v[56:59], a[32:35], v76, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[12:15], v[56:59], a[64:67], v76, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[12:15], v[60:63], a[68:71], v76, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[8:11], v[60:63], a[36:39], v76, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[8:11], v[64:67], a[40:43], v76, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[12:15], v[64:67], a[72:75], v76, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[12:15], v[68:71], a[76:79], v76, v24 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[8:11], v[68:71], a[44:47], v76, v24 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[8:11], v[72:75], a[48:51], v76, v24 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[12:15], v[72:75], a[80:83], v76, v24 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[28:31], v[72:75], a[112:115], v77, v24 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[28:31], v[68:71], a[108:111], v77, v24 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[32:35], v[68:71], a[140:143], v77, v24 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], v[72:75], a[144:147], v77, v24 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[32:35], v[44:47], a[116:119], v77, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[28:31], v[44:47], a[84:87], v77, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[28:31], v[48:51], a[88:91], v77, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[32:35], v[48:51], a[120:123], v77, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[32:35], v[52:55], a[124:127], v77, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[28:31], v[52:55], a[92:95], v77, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[28:31], v[56:59], a[96:99], v77, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[32:35], v[56:59], a[128:131], v77, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[32:35], v[60:63], a[132:135], v77, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[28:31], v[60:63], a[100:103], v77, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[28:31], v[64:67], a[104:107], v77, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[32:35], v[64:67], a[136:139], v77, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[36:39], v[64:67], a[168:171], v26, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[36:39], v[60:63], a[164:167], v26, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[40:43], v[60:63], a[196:199], v26, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[40:43], v[64:67], a[200:203], v26, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[40:43], v[44:47], a[180:183], v26, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[36:39], v[44:47], a[148:151], v26, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[36:39], v[48:51], a[152:155], v26, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[40:43], v[48:51], a[184:187], v26, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[40:43], v[52:55], a[188:191], v26, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[36:39], v[52:55], a[156:159], v26, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], v[56:59], a[160:163], v26, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[40:43], v[56:59], a[192:195], v26, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[40:43], v[68:71], a[204:207], v26, v24 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[36:39], v[68:71], a[172:175], v26, v24 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[36:39], v[72:75], a[176:179], v26, v24 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[40:43], v[72:75], a[208:211], v26, v24 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[96:99], v[140:143], a[172:175], v26, v24 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[96:99], v[188:191], a[176:179], v26, v24 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[104:107], v[188:191], a[208:211], v26, v24 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[104:107], v[140:143], a[204:207], v26, v24 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[8:11], v[140:143], v[152:155], v27, v24 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[8:11], v[188:191], v[156:159], v27, v24 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[16:19], v[188:191], a[16:19], v27, v24 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[16:19], v[140:143], v[184:187], v27, v24 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[16:19], v[108:111], v[160:163], v27, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[8:11], v[108:111], v[12:15], v27, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[8:11], v[112:115], v[100:103], v27, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[16:19], v[112:115], v[164:167], v27, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[16:19], v[116:119], v[168:171], v27, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[8:11], v[116:119], v[120:123], v27, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[8:11], v[124:127], v[128:131], v27, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[16:19], v[124:127], v[172:175], v27, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[16:19], v[132:135], v[176:179], v27, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[8:11], v[132:135], v[144:147], v27, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[8:11], v[136:139], v[148:151], v27, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[16:19], v[136:139], v[180:183], v27, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[20:23], v[136:139], a[40:43], v76, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[20:23], v[132:135], a[36:39], v76, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[84:87], v[132:135], a[68:71], v76, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[84:87], v[136:139], a[72:75], v76, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[84:87], v[108:111], a[52:55], v76, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[20:23], v[108:111], a[20:23], v76, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[20:23], v[112:115], a[24:27], v76, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[84:87], v[112:115], a[56:59], v76, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[84:87], v[116:119], a[60:63], v76, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[20:23], v[116:119], a[28:31], v76, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[20:23], v[124:127], a[32:35], v76, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[84:87], v[124:127], a[64:67], v76, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[84:87], v[140:143], a[76:79], v76, v24 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[20:23], v[140:143], a[44:47], v76, v24 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[20:23], v[188:191], a[48:51], v76, v24 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[84:87], v[188:191], a[80:83], v76, v24 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[88:91], v[188:191], a[112:115], v77, v24 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[88:91], v[140:143], a[108:111], v77, v24 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[92:95], v[140:143], a[140:143], v77, v24 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[92:95], v[188:191], a[144:147], v77, v24 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[92:95], v[108:111], a[116:119], v77, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[88:91], v[108:111], a[84:87], v77, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[88:91], v[112:115], a[88:91], v77, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[92:95], v[112:115], a[120:123], v77, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[92:95], v[116:119], a[124:127], v77, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[88:91], v[116:119], a[92:95], v77, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[88:91], v[124:127], a[96:99], v77, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[92:95], v[124:127], a[128:131], v77, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[92:95], v[132:135], a[132:135], v77, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[88:91], v[132:135], a[100:103], v77, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[88:91], v[136:139], a[104:107], v77, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[92:95], v[136:139], a[136:139], v77, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[96:99], v[136:139], a[168:171], v26, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[96:99], v[132:135], a[164:167], v26, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[104:107], v[132:135], a[196:199], v26, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[104:107], v[136:139], a[200:203], v26, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[104:107], v[108:111], a[180:183], v26, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[96:99], v[108:111], a[148:151], v26, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[96:99], v[112:115], a[152:155], v26, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[104:107], v[112:115], a[184:187], v26, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[104:107], v[116:119], a[188:191], v26, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[96:99], v[116:119], a[156:159], v26, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[96:99], v[124:127], a[160:163], v26, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[104:107], v[124:127], a[192:195], v26, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s0, s12, 1
		s_lshl_b32 s1, s0, 16
		v_add_u32_e32 v1, s1, v1
		v_add3_u32 v1, v1, v3, v4
		v_add_u32_e32 v2, 0x800, v1
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[8:11], v2
		v_add_u32_e32 v2, 0x800, v1
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[16:19], v2 offset:1024
		v_add_u32_e32 v2, 0x800, v1
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[20:23], v2 offset:2048
		v_add_u32_e32 v2, 0x800, v1
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[24:27], v2 offset:3072
		v_add_u32_e32 v2, 0x800, v1
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[28:31], v2 offset:4096
		v_add_u32_e32 v2, 0x800, v1
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[32:35], v2 offset:5120
		v_add_u32_e32 v2, 0x800, v1
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[36:39], v2 offset:6144
		v_add_u32_e32 v2, 0x800, v1
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[40:43], v2 offset:7168
		v_add_u32_e32 v2, s1, v3
		v_add3_u32 v2, v2, v5, v4
		v_add_u32_e32 v3, 0x800, v2
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[4:7], v3 offset:32768
		v_add_u32_e32 v3, 0x800, v2
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[44:47], v3 offset:33792
		v_add_u32_e32 v3, 0x800, v2
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[48:51], v3 offset:34816
		v_add_u32_e32 v3, 0x800, v2
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[52:55], v3 offset:35840
		v_add_u32_e32 v3, 0x800, v2
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[56:59], v3 offset:36864
		v_add_u32_e32 v3, 0x800, v2
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[60:63], v3 offset:37888
		v_add_u32_e32 v3, 0x800, v2
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[64:67], v3 offset:38912
		v_add_u32_e32 v3, 0x800, v2
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[68:71], v3 offset:39936
		s_lshl_b32 s0, s0, 12
		s_add_i32 s0, s0, 0x20000
		v_lshrrev_b32_e32 v3, 7, v0
		v_lshlrev_b32_e32 v3, 10, v3
		v_and_b32_e32 v72, 63, v0
		v_lshlrev_b32_e32 v72, 2, v72
		v_add3_u32 v3, s0, v3, v72
		v_add_u32_e32 v73, 0x800, v3
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		ds_read_b32 v74, v73
		v_add_u32_e32 v73, 0x800, v3
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		ds_read_b32 v75, v73 offset:256
		v_add_u32_e32 v73, 0x800, v3
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		ds_read_b32 v76, v73 offset:512
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b32 v73, v3 offset:768
		v_lshrrev_b32_e32 v3, 6, v0
		v_and_b32_e32 v3, 1, v3
		v_lshlrev_b32_e32 v3, 10, v3
		v_add3_u32 v3, s0, v72, v3
		v_add_u32_e32 v72, 0x800, v3
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		ds_read_b32 v77, v72 offset:2048
		v_add_u32_e32 v72, 0x800, v3
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		ds_read_b32 v78, v72 offset:2304
		v_add_u32_e32 v72, 0x800, v3
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		ds_read_b32 v79, v72 offset:2560
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b32 v72, v3 offset:2816
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[8:11], v[4:7], v[12:15], v74, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x800, v1
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[80:83], v3 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[8:11], v[44:47], v[100:103], v74, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x800, v1
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[84:87], v3 offset:17408
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[8:11], v[48:51], v[120:123], v74, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x800, v1
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[88:91], v3 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[8:11], v[52:55], v[128:131], v74, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x800, v1
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[92:95], v3 offset:19456
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[8:11], v[56:59], v[144:147], v74, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x800, v1
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[96:99], v3 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[8:11], v[60:63], v[148:151], v74, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x800, v1
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[104:107], v3 offset:21504
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[8:11], v[64:67], v[152:155], v74, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x800, v1
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[108:111], v3 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[8:11], v[68:71], v[156:159], v74, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		ds_read_b128 v[8:11], v1 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[16:19], v[4:7], v[160:163], v74, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x800, v2
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		ds_read_b128 v[112:115], v1 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[16:19], v[44:47], v[164:167], v74, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x800, v2
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		ds_read_b128 v[116:119], v1 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[16:19], v[48:51], v[168:171], v74, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x800, v2
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		ds_read_b128 v[124:127], v1 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[16:19], v[52:55], v[172:175], v74, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x800, v2
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		ds_read_b128 v[132:135], v1 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[16:19], v[56:59], v[176:179], v74, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x800, v2
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		ds_read_b128 v[136:139], v1 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[16:19], v[60:63], v[180:183], v74, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x800, v2
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		ds_read_b128 v[140:143], v1 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[16:19], v[64:67], v[184:187], v74, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x800, v2
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		ds_read_b128 v[188:191], v1 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[16:19], v[68:71], a[16:19], v74, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x800, v2
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		ds_read_b128 v[16:19], v1 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[20:23], v[4:7], a[20:23], v75, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[20:23], v[44:47], a[24:27], v75, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[24:27], v[44:47], a[56:59], v75, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[24:27], v[4:7], a[52:55], v75, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[24:27], v[48:51], a[60:63], v75, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[20:23], v[48:51], a[28:31], v75, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[20:23], v[52:55], a[32:35], v75, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[24:27], v[52:55], a[64:67], v75, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[24:27], v[56:59], a[68:71], v75, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[20:23], v[56:59], a[36:39], v75, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[20:23], v[60:63], a[40:43], v75, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[24:27], v[60:63], a[72:75], v75, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[24:27], v[64:67], a[76:79], v75, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[20:23], v[64:67], a[44:47], v75, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[20:23], v[68:71], a[48:51], v75, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[24:27], v[68:71], a[80:83], v75, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[28:31], v[68:71], a[112:115], v76, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[28:31], v[64:67], a[108:111], v76, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[32:35], v[64:67], a[140:143], v76, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], v[68:71], a[144:147], v76, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[32:35], v[4:7], a[116:119], v76, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[28:31], v[4:7], a[84:87], v76, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[28:31], v[44:47], a[88:91], v76, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[32:35], v[44:47], a[120:123], v76, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[32:35], v[48:51], a[124:127], v76, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[28:31], v[48:51], a[92:95], v76, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[28:31], v[52:55], a[96:99], v76, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[32:35], v[52:55], a[128:131], v76, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[32:35], v[56:59], a[132:135], v76, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[28:31], v[56:59], a[100:103], v76, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[28:31], v[60:63], a[104:107], v76, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[32:35], v[60:63], a[136:139], v76, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[36:39], v[60:63], a[168:171], v73, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[36:39], v[56:59], a[164:167], v73, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[40:43], v[56:59], a[196:199], v73, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[40:43], v[60:63], a[200:203], v73, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[40:43], v[4:7], a[180:183], v73, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[36:39], v[4:7], a[148:151], v73, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[36:39], v[44:47], a[152:155], v73, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[40:43], v[44:47], a[184:187], v73, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[40:43], v[48:51], a[188:191], v73, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[36:39], v[48:51], a[156:159], v73, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], v[52:55], a[160:163], v73, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[40:43], v[52:55], a[192:195], v73, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[40:43], v[64:67], a[204:207], v73, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[36:39], v[64:67], a[172:175], v73, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[36:39], v[68:71], a[176:179], v73, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[40:43], v[68:71], a[208:211], v73, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[108:111], v[188:191], a[172:175], v73, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[108:111], v[16:19], a[176:179], v73, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[8:11], v[16:19], a[208:211], v73, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[8:11], v[188:191], a[204:207], v73, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[80:83], v[188:191], v[152:155], v74, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[80:83], v[16:19], v[156:159], v74, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[84:87], v[16:19], a[16:19], v74, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[84:87], v[188:191], v[184:187], v74, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[84:87], v[112:115], v[160:163], v74, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[80:83], v[112:115], v[12:15], v74, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[80:83], v[116:119], v[100:103], v74, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[84:87], v[116:119], v[164:167], v74, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[84:87], v[124:127], v[168:171], v74, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[80:83], v[124:127], v[120:123], v74, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[80:83], v[132:135], v[128:131], v74, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[84:87], v[132:135], v[172:175], v74, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[84:87], v[136:139], v[176:179], v74, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[80:83], v[136:139], v[144:147], v74, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[80:83], v[140:143], v[148:151], v74, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[84:87], v[140:143], v[180:183], v74, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[88:91], v[140:143], a[40:43], v75, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[88:91], v[136:139], a[36:39], v75, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[92:95], v[136:139], a[68:71], v75, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[92:95], v[140:143], a[72:75], v75, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[92:95], v[112:115], a[52:55], v75, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[88:91], v[112:115], a[20:23], v75, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[88:91], v[116:119], a[24:27], v75, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[92:95], v[116:119], a[56:59], v75, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[92:95], v[124:127], a[60:63], v75, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[88:91], v[124:127], a[28:31], v75, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[88:91], v[132:135], a[32:35], v75, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[92:95], v[132:135], a[64:67], v75, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[92:95], v[188:191], a[76:79], v75, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[88:91], v[188:191], a[44:47], v75, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[88:91], v[16:19], a[48:51], v75, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[92:95], v[16:19], a[80:83], v75, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[96:99], v[16:19], a[112:115], v76, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[96:99], v[188:191], a[108:111], v76, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[104:107], v[188:191], a[140:143], v76, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[104:107], v[16:19], a[144:147], v76, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[104:107], v[112:115], a[116:119], v76, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[96:99], v[112:115], a[84:87], v76, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[96:99], v[116:119], a[88:91], v76, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[104:107], v[116:119], a[120:123], v76, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[104:107], v[124:127], a[124:127], v76, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[96:99], v[124:127], a[92:95], v76, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[96:99], v[132:135], a[96:99], v76, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[104:107], v[132:135], a[128:131], v76, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[104:107], v[136:139], a[132:135], v76, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[96:99], v[136:139], a[100:103], v76, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[96:99], v[140:143], a[104:107], v76, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[104:107], v[140:143], a[136:139], v76, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[108:111], v[140:143], a[168:171], v73, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[108:111], v[136:139], a[164:167], v73, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[8:11], v[136:139], a[196:199], v73, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[8:11], v[140:143], a[200:203], v73, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[8:11], v[112:115], a[180:183], v73, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[108:111], v[112:115], a[148:151], v73, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[108:111], v[116:119], a[152:155], v73, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[8:11], v[116:119], a[184:187], v73, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[8:11], v[124:127], a[188:191], v73, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[108:111], v[124:127], a[156:159], v73, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[108:111], v[132:135], a[160:163], v73, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[8:11], v[132:135], a[192:195], v73, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v12, v13
		v_cvt_pk_f16_f32 v3, v14, v15
		v_and_b32_e32 v0, 63, v0
		v_lshlrev_b32_e32 v0, 3, v0
		v_lshl_add_u32 v0, s39, 15, v0
		s_lshl_b32 s0, s13, 21
		s_lshl_b32 s1, s14, 17
		s_add_i32 s2, s0, s1
		s_mov_b32 s16, s6
		s_mov_b32 s17, s7
		s_mov_b32 s19, s23
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen
		v_cvt_pk_f16_f32 v2, v100, v101
		v_cvt_pk_f16_f32 v3, v102, v103
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:512
		v_cvt_pk_f16_f32 v2, v120, v121
		v_cvt_pk_f16_f32 v3, v122, v123
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:1024
		v_cvt_pk_f16_f32 v2, v128, v129
		v_cvt_pk_f16_f32 v3, v130, v131
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:1536
		v_cvt_pk_f16_f32 v2, v144, v145
		v_cvt_pk_f16_f32 v3, v146, v147
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:2048
		v_cvt_pk_f16_f32 v2, v148, v149
		v_cvt_pk_f16_f32 v3, v150, v151
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:2560
		v_cvt_pk_f16_f32 v2, v152, v153
		v_cvt_pk_f16_f32 v3, v154, v155
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:3072
		v_cvt_pk_f16_f32 v2, v156, v157
		v_cvt_pk_f16_f32 v3, v158, v159
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:3584
		v_cvt_pk_f16_f32 v2, v160, v161
		v_cvt_pk_f16_f32 v3, v162, v163
		s_add_i32 s2, s0, 0x1000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen
		v_cvt_pk_f16_f32 v2, v164, v165
		v_cvt_pk_f16_f32 v3, v166, v167
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:512
		v_cvt_pk_f16_f32 v2, v168, v169
		v_cvt_pk_f16_f32 v3, v170, v171
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:1024
		v_cvt_pk_f16_f32 v2, v172, v173
		v_cvt_pk_f16_f32 v3, v174, v175
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:1536
		v_cvt_pk_f16_f32 v2, v176, v177
		v_cvt_pk_f16_f32 v3, v178, v179
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:2048
		v_cvt_pk_f16_f32 v2, v180, v181
		v_cvt_pk_f16_f32 v3, v182, v183
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:2560
		v_cvt_pk_f16_f32 v2, v184, v185
		v_cvt_pk_f16_f32 v3, v186, v187
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:3072
		v_accvgpr_read_b32 v1, a16
		v_accvgpr_read_b32 v2, a17
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a18
		v_accvgpr_read_b32 v2, a19
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a20
		v_accvgpr_read_b32 v2, a21
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a22
		v_accvgpr_read_b32 v2, a23
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x2000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen
		v_accvgpr_read_b32 v1, a24
		v_accvgpr_read_b32 v2, a25
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a26
		v_accvgpr_read_b32 v2, a27
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:512
		v_accvgpr_read_b32 v1, a28
		v_accvgpr_read_b32 v2, a29
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a30
		v_accvgpr_read_b32 v2, a31
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1024
		v_accvgpr_read_b32 v1, a32
		v_accvgpr_read_b32 v2, a33
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a34
		v_accvgpr_read_b32 v2, a35
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1536
		v_accvgpr_read_b32 v1, a36
		v_accvgpr_read_b32 v2, a37
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a38
		v_accvgpr_read_b32 v2, a39
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2048
		v_accvgpr_read_b32 v1, a40
		v_accvgpr_read_b32 v2, a41
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a42
		v_accvgpr_read_b32 v2, a43
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2560
		v_accvgpr_read_b32 v1, a44
		v_accvgpr_read_b32 v2, a45
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a46
		v_accvgpr_read_b32 v2, a47
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3072
		v_accvgpr_read_b32 v1, a48
		v_accvgpr_read_b32 v2, a49
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a50
		v_accvgpr_read_b32 v2, a51
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a52
		v_accvgpr_read_b32 v2, a53
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a54
		v_accvgpr_read_b32 v2, a55
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x3000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen
		v_accvgpr_read_b32 v1, a56
		v_accvgpr_read_b32 v2, a57
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a58
		v_accvgpr_read_b32 v2, a59
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:512
		v_accvgpr_read_b32 v1, a60
		v_accvgpr_read_b32 v2, a61
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a62
		v_accvgpr_read_b32 v2, a63
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1024
		v_accvgpr_read_b32 v1, a64
		v_accvgpr_read_b32 v2, a65
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a66
		v_accvgpr_read_b32 v2, a67
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1536
		v_accvgpr_read_b32 v1, a68
		v_accvgpr_read_b32 v2, a69
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a70
		v_accvgpr_read_b32 v2, a71
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2048
		v_accvgpr_read_b32 v1, a72
		v_accvgpr_read_b32 v2, a73
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a74
		v_accvgpr_read_b32 v2, a75
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2560
		v_accvgpr_read_b32 v1, a76
		v_accvgpr_read_b32 v2, a77
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a78
		v_accvgpr_read_b32 v2, a79
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3072
		v_accvgpr_read_b32 v1, a80
		v_accvgpr_read_b32 v2, a81
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a82
		v_accvgpr_read_b32 v2, a83
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a84
		v_accvgpr_read_b32 v2, a85
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a86
		v_accvgpr_read_b32 v2, a87
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x4000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen
		v_accvgpr_read_b32 v1, a88
		v_accvgpr_read_b32 v2, a89
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a90
		v_accvgpr_read_b32 v2, a91
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:512
		v_accvgpr_read_b32 v1, a92
		v_accvgpr_read_b32 v2, a93
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a94
		v_accvgpr_read_b32 v2, a95
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1024
		v_accvgpr_read_b32 v1, a96
		v_accvgpr_read_b32 v2, a97
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a98
		v_accvgpr_read_b32 v2, a99
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1536
		v_accvgpr_read_b32 v1, a100
		v_accvgpr_read_b32 v2, a101
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a102
		v_accvgpr_read_b32 v2, a103
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2048
		v_accvgpr_read_b32 v1, a104
		v_accvgpr_read_b32 v2, a105
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a106
		v_accvgpr_read_b32 v2, a107
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2560
		v_accvgpr_read_b32 v1, a108
		v_accvgpr_read_b32 v2, a109
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a110
		v_accvgpr_read_b32 v2, a111
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3072
		v_accvgpr_read_b32 v1, a112
		v_accvgpr_read_b32 v2, a113
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a114
		v_accvgpr_read_b32 v2, a115
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a116
		v_accvgpr_read_b32 v2, a117
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a118
		v_accvgpr_read_b32 v2, a119
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x5000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen
		v_accvgpr_read_b32 v1, a120
		v_accvgpr_read_b32 v2, a121
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a122
		v_accvgpr_read_b32 v2, a123
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:512
		v_accvgpr_read_b32 v1, a124
		v_accvgpr_read_b32 v2, a125
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a126
		v_accvgpr_read_b32 v2, a127
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1024
		v_accvgpr_read_b32 v1, a128
		v_accvgpr_read_b32 v2, a129
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a130
		v_accvgpr_read_b32 v2, a131
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1536
		v_accvgpr_read_b32 v1, a132
		v_accvgpr_read_b32 v2, a133
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a134
		v_accvgpr_read_b32 v2, a135
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2048
		v_accvgpr_read_b32 v1, a136
		v_accvgpr_read_b32 v2, a137
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a138
		v_accvgpr_read_b32 v2, a139
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2560
		v_accvgpr_read_b32 v1, a140
		v_accvgpr_read_b32 v2, a141
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a142
		v_accvgpr_read_b32 v2, a143
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3072
		v_accvgpr_read_b32 v1, a144
		v_accvgpr_read_b32 v2, a145
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a146
		v_accvgpr_read_b32 v2, a147
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a148
		v_accvgpr_read_b32 v2, a149
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a150
		v_accvgpr_read_b32 v2, a151
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x6000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen
		v_accvgpr_read_b32 v1, a152
		v_accvgpr_read_b32 v2, a153
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a154
		v_accvgpr_read_b32 v2, a155
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:512
		v_accvgpr_read_b32 v1, a156
		v_accvgpr_read_b32 v2, a157
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a158
		v_accvgpr_read_b32 v2, a159
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1024
		v_accvgpr_read_b32 v1, a160
		v_accvgpr_read_b32 v2, a161
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a162
		v_accvgpr_read_b32 v2, a163
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1536
		v_accvgpr_read_b32 v1, a164
		v_accvgpr_read_b32 v2, a165
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a166
		v_accvgpr_read_b32 v2, a167
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2048
		v_accvgpr_read_b32 v1, a168
		v_accvgpr_read_b32 v2, a169
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a170
		v_accvgpr_read_b32 v2, a171
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2560
		v_accvgpr_read_b32 v1, a172
		v_accvgpr_read_b32 v2, a173
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a174
		v_accvgpr_read_b32 v2, a175
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3072
		v_accvgpr_read_b32 v1, a176
		v_accvgpr_read_b32 v2, a177
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a178
		v_accvgpr_read_b32 v2, a179
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a180
		v_accvgpr_read_b32 v2, a181
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a182
		v_accvgpr_read_b32 v2, a183
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s0, s0, 0x7000
		s_add_i32 s0, s0, s1
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen
		v_accvgpr_read_b32 v1, a184
		v_accvgpr_read_b32 v2, a185
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a186
		v_accvgpr_read_b32 v2, a187
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:512
		v_accvgpr_read_b32 v1, a188
		v_accvgpr_read_b32 v2, a189
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a190
		v_accvgpr_read_b32 v2, a191
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:1024
		v_accvgpr_read_b32 v1, a192
		v_accvgpr_read_b32 v2, a193
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a194
		v_accvgpr_read_b32 v2, a195
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:1536
		v_accvgpr_read_b32 v1, a196
		v_accvgpr_read_b32 v2, a197
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a198
		v_accvgpr_read_b32 v2, a199
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:2048
		v_accvgpr_read_b32 v1, a200
		v_accvgpr_read_b32 v2, a201
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a202
		v_accvgpr_read_b32 v2, a203
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:2560
		v_accvgpr_read_b32 v1, a204
		v_accvgpr_read_b32 v2, a205
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a206
		v_accvgpr_read_b32 v2, a207
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:3072
		v_accvgpr_read_b32 v1, a208
		v_accvgpr_read_b32 v2, a209
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a210
		v_accvgpr_read_b32 v2, a211
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:3584
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 24576
		.amdhsa_private_segment_fixed_size 412
		.amdhsa_kernarg_size 48
		.amdhsa_user_sgpr_count 13
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_user_sgpr_kernarg_preload_length 11
		.amdhsa_user_sgpr_kernarg_preload_offset 0
		.amdhsa_enable_private_segment 1
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 1
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 512
		.amdhsa_next_free_sgpr 46
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
	.set .Lwmma_f16_matmul_tiled.num_agpr, 256
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 46
	.set .Lwmma_f16_matmul_tiled.num_named_barrier, 0
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 412
	.set .Lwmma_f16_matmul_tiled.uses_vcc, 1
	.set .Lwmma_f16_matmul_tiled.uses_flat_scratch, 1
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
    .group_segment_fixed_size: 24576
    .kernarg_segment_align: 8
    .kernarg_segment_size: 48
    .max_flat_workgroup_size: 256
    .name:           wmma_f16_matmul_tiled
    .private_segment_fixed_size: 412
    .sgpr_count:     46
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     512
    .agpr_count:     256
    .vgpr_spill_count: 103
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 141
    wave.regalloc.agpr.dwords: 300
    wave.regalloc.remat.dwords: 12
    wave.regalloc.sgpr_to_vgpr.dwords: 0
    wave.regalloc.lds.dwords: 24
    wave.regalloc.scratch.dwords: 103
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
