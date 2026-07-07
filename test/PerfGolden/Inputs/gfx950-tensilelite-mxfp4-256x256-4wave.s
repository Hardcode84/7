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
		s_mov_b32 s18, 0x7fffffff
		s_mov_b32 s19, 0x31016000
		s_mov_b32 s16, s6
		s_mov_b32 s17, s7
		s_mov_b32 s22, 0x1000000
		s_mov_b32 s20, s2
		s_mov_b32 s21, s3
		s_mov_b32 s23, s19
		s_mov_b32 s0, s4
		s_mov_b32 s1, s5
		s_mov_b32 s2, s22
		s_mov_b32 s3, s19
		s_mov_b32 s4, s8
		s_mov_b32 s5, s9
		s_mov_b32 s6, s22
		s_mov_b32 s7, s19
		s_mov_b32 s24, s10
		s_mov_b32 s25, s11
		s_mov_b32 s26, s22
		s_mov_b32 s27, s19
		v_readfirstlane_b32 s8, v0
		s_lshl_b32 s9, s13, 20
		v_lshrrev_b32_e32 v1, 6, v0
		v_lshlrev_b32_e32 v2, 16, v1
		v_add_u32_e32 v3, s9, v2
		v_and_b32_e32 v4, 63, v0
		v_lshrrev_b32_e32 v5, 2, v4
		v_lshlrev_b32_e32 v5, 12, v5
		v_lshrrev_b32_e32 v6, 3, v4
		v_bitop3_b32 v6, v6, 3, v4 bitop3:0x48
		v_lshlrev_b32_e32 v6, 4, v6
		v_add3_u32 v3, v3, v5, v6
		s_add_i32 s10, s9, 0x40000
		v_add_u32_e32 v7, v2, v5
		s_add_i32 s11, s9, 0x80000
		s_add_i32 s28, s9, 0xc0000
		s_add_i32 s29, s9, 64
		v_add_u32_e32 v8, v2, v5
		s_add_i32 s30, s9, 0x40040
		s_add_i32 s31, s9, 0x80040
		s_add_i32 s32, s9, 0xc0040
		v_add_u32_e32 v9, v2, v5
		s_lshl_b32 s33, s14, 20
		s_add_i32 s34, s33, 0x40000
		s_add_i32 s35, s33, 0x80000
		v_add3_u32 v10, v2, v5, v6
		s_add_i32 s36, s33, 0xc0000
		s_add_i32 s37, s33, 0x40040
		v_add_u32_e32 v11, v2, v5
		s_add_i32 s38, s33, 0x80040
		s_add_i32 s39, s33, 0xc0040
		s_lshr_b32 s40, s8, 6
		s_lshl_b32 s41, s40, 10
		v_mov_b64_e32 v[12:13], 0
		v_mov_b64_e32 v[14:15], 0
		s_add_i32 m0, s41, 0x6000
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add3_u32 v3, v6, v7, s10
		s_add_i32 m0, s41, 0x7000
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add3_u32 v3, v6, v7, s11
		s_add_i32 m0, s41, 0x8000
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add3_u32 v3, v6, v7, s28
		s_add_i32 m0, s41, 0x9000
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add3_u32 v3, v6, v8, s29
		s_add_i32 m0, s41, 0xa000
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add3_u32 v3, v6, v8, s30
		s_add_i32 m0, s41, 0xb000
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add3_u32 v3, v6, v8, s31
		s_add_i32 m0, s41, 0xc000
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add3_u32 v3, v6, v9, s32
		s_add_i32 m0, s41, 0xd000
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add3_u32 v3, v6, v9, s33
		s_add_i32 m0, s41, 0xe000
		s_nop 0
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		v_add3_u32 v3, v6, v9, s34
		s_add_i32 m0, s41, 0xf000
		s_nop 0
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		v_add_u32_e32 v3, s35, v10
		s_add_i32 m0, s41, 0x10000
		s_nop 0
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		v_add_u32_e32 v3, s36, v10
		s_add_i32 m0, s41, 0x11000
		s_nop 0
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		v_add3_u32 v3, v10, s33, 64
		s_add_i32 m0, s41, 0x12000
		s_nop 0
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		v_add3_u32 v3, v6, v11, s37
		s_add_i32 m0, s41, 0x13000
		s_nop 0
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		v_add3_u32 v3, v6, v11, s38
		s_add_i32 m0, s41, 0x14000
		s_nop 0
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		v_add3_u32 v3, v6, v11, s39
		s_add_i32 m0, s41, 0x15000
		s_nop 0
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		s_lshl_b32 s10, s14, 16
		s_add_i32 s11, s9, s10
		v_lshrrev_b32_e32 v3, 7, v0
		v_lshlrev_b32_e32 v7, 10, v3
		v_lshlrev_b32_e32 v8, 4, v4
		v_add3_u32 v9, s11, v7, v8
		s_lshr_b32 s8, s8, 7
		s_lshl_b32 s28, s8, 10
		v_and_b32_e32 v1, 1, v1
		v_lshlrev_b32_e32 v10, 10, v1
		v_add3_u32 v11, s11, v8, v10
		s_and_b32 s8, s40, 1
		s_lshl_b32 s8, s8, 10
		s_add_i32 s11, s41, 0x1000
		s_add_i32 m0, s28, 0x26000
		s_nop 0
		buffer_load_dwordx4 v9, s[4:7], 0 offen lds
		s_add_i32 s29, s41, 0x2000
		s_add_i32 m0, s8, 0x26800
		s_nop 0
		buffer_load_dwordx4 v11, s[24:27], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v3, 13, v3
		v_and_b32_e32 v9, 15, v0
		v_lshlrev_b32_e32 v11, 6, v9
		v_lshrrev_b32_e32 v16, 4, v4
		v_lshrrev_b32_e32 v9, 1, v9
		s_mov_b32 m0, s15
		v_bitop3_b32 v9, v16, v9, 3 bitop3:0x78
		ds_write_addtid_b32 v9
		v_lshlrev_b32_e32 v16, 4, v9
		v_add3_u32 v17, v3, v11, v16
		v_add_u32_e32 v18, 0x400, v17
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		ds_read_b128 a[0:3], v18
		v_add_u32_e32 v18, 0x400, v17
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		ds_read_b128 a[4:7], v18 offset:1024
		v_add_u32_e32 v18, 0x400, v17
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		ds_read_b128 a[8:11], v18 offset:2048
		v_add_u32_e32 v18, 0x400, v17
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		ds_read_b128 a[12:15], v18 offset:3072
		v_add_u32_e32 v18, 0x400, v17
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		ds_read_b128 v[20:23], v18 offset:4096
		v_add_u32_e32 v18, 0x400, v17
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		ds_read_b128 v[24:27], v18 offset:5120
		v_add_u32_e32 v18, 0x400, v17
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		ds_read_b128 v[28:31], v18 offset:6144
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		ds_read_b128 v[32:35], v17 offset:7168
		s_mov_b32 m0, s15
		v_lshlrev_b32_e32 v1, 13, v1
		ds_write_addtid_b32 v1 offset:1024
		v_add3_u32 v17, v11, v1, v16
		v_add_u32_e32 v18, 0x400, v17
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		ds_read_b128 v[36:39], v18 offset:32768
		v_add_u32_e32 v18, 0x400, v17
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		ds_read_b128 v[40:43], v18 offset:33792
		v_add_u32_e32 v18, 0x400, v17
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		ds_read_b128 v[44:47], v18 offset:34816
		v_add_u32_e32 v18, 0x400, v17
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		ds_read_b128 v[48:51], v18 offset:35840
		v_add_u32_e32 v18, 0x400, v17
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		ds_read_b128 v[52:55], v18 offset:36864
		v_add_u32_e32 v18, 0x400, v17
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		ds_read_b128 v[56:59], v18 offset:37888
		v_add_u32_e32 v18, 0x400, v17
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		ds_read_b128 v[60:63], v18 offset:38912
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		ds_read_b128 v[64:67], v17 offset:39936
		v_add_u32_e32 v17, 0x20000, v7
		v_lshlrev_b32_e32 v4, 2, v4
		v_add_u32_e32 v17, v17, v4
		v_add_u32_e32 v18, 0x400, v17
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		ds_read_b32 v19, v18
		v_add_u32_e32 v18, 0x400, v17
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		ds_read_b32 v68, v18 offset:256
		v_add_u32_e32 v18, 0x400, v17
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		ds_read_b32 v69, v18 offset:512
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		ds_read_b32 v18, v17 offset:768
		v_add_u32_e32 v4, 0x20000, v4
		v_add_u32_e32 v4, v4, v10
		v_add_u32_e32 v17, 0x400, v4
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		ds_read_b32 v70, v17 offset:2048
		v_add_u32_e32 v17, 0x400, v4
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		ds_read_b32 v71, v17 offset:2304
		v_add_u32_e32 v17, 0x400, v4
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x800, v17
		ds_read_b32 v72, v17 offset:2560
		v_add_u32_e32 v4, 0x400, v4
		v_add_u32_e32 v4, 0x400, v4
		v_add_u32_e32 v4, 0x400, v4
		v_add_u32_e32 v4, 0x400, v4
		v_add_u32_e32 v4, 0x400, v4
		v_add_u32_e32 v4, 0x400, v4
		v_add_u32_e32 v4, 0x800, v4
		v_add_u32_e32 v4, 0x800, v4
		v_add_u32_e32 v4, 0x800, v4
		v_add_u32_e32 v4, 0x800, v4
		v_add_u32_e32 v4, 0x800, v4
		v_add_u32_e32 v4, 0x800, v4
		v_add_u32_e32 v4, 0x800, v4
		v_add_u32_e32 v4, 0x800, v4
		v_add_u32_e32 v4, 0x800, v4
		ds_read_b32 v17, v4 offset:2816
		s_add_i32 s30, s9, 0x80
		v_add_u32_e32 v4, s30, v2
		v_add3_u32 v4, v4, v5, v6
		s_add_i32 s30, s9, 0x40080
		v_add_u32_e32 v73, v2, v5
		v_add3_u32 v74, v6, v73, s30
		s_add_i32 s30, s9, 0x80080
		v_add3_u32 v75, v6, v73, s30
		s_add_i32 s30, s9, 0xc0080
		v_add3_u32 v73, v6, v73, s30
		s_add_i32 s30, s9, 0xc0
		v_add_u32_e32 v76, v2, v5
		v_add3_u32 v77, v6, v76, s30
		s_add_i32 s30, s9, 0x400c0
		v_add3_u32 v78, v6, v76, s30
		s_add_i32 s30, s9, 0x800c0
		v_add3_u32 v76, v6, v76, s30
		s_add_i32 s30, s9, 0xc00c0
		v_add_u32_e32 v79, v2, v5
		v_add3_u32 v80, v6, v79, s30
		s_add_i32 s30, s33, 0x80
		v_add3_u32 v81, v6, v79, s30
		s_add_i32 s30, s33, 0x40080
		v_add3_u32 v79, v6, v79, s30
		s_add_i32 s30, s33, 0x80080
		v_add_u32_e32 v82, v2, v5
		v_add3_u32 v83, v6, v82, s30
		s_add_i32 s30, s33, 0xc0080
		v_add3_u32 v84, v6, v82, s30
		s_add_i32 s30, s33, 0xc0
		v_add3_u32 v82, v6, v82, s30
		s_add_i32 s30, s33, 0x400c0
		v_add_u32_e32 v2, v2, v5
		v_add3_u32 v5, v6, v2, s30
		s_add_i32 s30, s33, 0x800c0
		s_add_i32 s31, s33, 0xc00c0
		s_add_i32 s32, s41, 0x12000
		s_add_i32 s33, s41, 0x13000
		s_add_i32 s34, s41, 0x14000
		s_add_i32 s35, s41, 0x15000
		s_add_i32 s36, s41, 0x16000
		s_add_i32 s37, s41, 0x17000
		s_add_i32 s38, s41, 0x18000
		s_add_i32 s39, s41, 0x19000
		s_add_i32 s40, s41, 0x1a000
		s_add_i32 s42, s41, 0x1b000
		s_add_i32 s43, s41, 0x1c000
		s_add_i32 s44, s41, 0x1d000
		s_add_i32 s45, s41, 0x1e000
		s_add_i32 s46, s41, 0x1f000
		s_add_i32 s47, s41, 0x3000
		s_add_i32 m0, s41, 0x16000
		s_nop 0
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		s_add_i32 s48, s41, 0x4000
		s_add_i32 m0, s41, 0x17000
		s_nop 0
		buffer_load_dwordx4 v74, s[20:23], 0 offen lds
		s_add_i32 s49, s41, 0x5000
		s_add_i32 m0, s41, 0x18000
		s_nop 0
		buffer_load_dwordx4 v75, s[20:23], 0 offen lds
		s_add_i32 s50, s41, 0x6000
		s_add_i32 m0, s41, 0x19000
		s_nop 0
		buffer_load_dwordx4 v73, s[20:23], 0 offen lds
		s_add_i32 s51, s41, 0x7000
		s_add_i32 m0, s41, 0x1a000
		s_nop 0
		buffer_load_dwordx4 v77, s[20:23], 0 offen lds
		s_add_i32 s52, s41, 0x8000
		s_add_i32 m0, s41, 0x1b000
		s_nop 0
		buffer_load_dwordx4 v78, s[20:23], 0 offen lds
		s_add_i32 s53, s41, 0x9000
		s_add_i32 m0, s41, 0x1c000
		s_nop 0
		buffer_load_dwordx4 v76, s[20:23], 0 offen lds
		s_add_i32 s54, s41, 0xa000
		s_add_i32 m0, s41, 0x1d000
		s_nop 0
		buffer_load_dwordx4 v80, s[20:23], 0 offen lds
		s_add_i32 s55, s41, 0xb000
		s_add_i32 m0, s41, 0x1e000
		s_nop 0
		buffer_load_dwordx4 v81, s[0:3], 0 offen lds
		s_add_i32 s56, s41, 0xc000
		s_add_i32 m0, s41, 0x1f000
		s_nop 0
		buffer_load_dwordx4 v79, s[0:3], 0 offen lds
		s_add_i32 s57, s41, 0xd000
		s_add_i32 m0, s41, 0x20000
		s_nop 0
		buffer_load_dwordx4 v83, s[0:3], 0 offen lds
		s_add_i32 s58, s41, 0xe000
		s_add_i32 m0, s41, 0x21000
		s_nop 0
		buffer_load_dwordx4 v84, s[0:3], 0 offen lds
		s_add_i32 s59, s41, 0xf000
		s_add_i32 m0, s41, 0x22000
		s_nop 0
		buffer_load_dwordx4 v82, s[0:3], 0 offen lds
		s_add_i32 s60, s8, 0x800
		s_add_i32 m0, s41, 0x23000
		s_nop 0
		buffer_load_dwordx4 v5, s[0:3], 0 offen lds
		v_add3_u32 v4, v6, v2, s30
		s_add_i32 m0, s41, 0x24000
		s_nop 0
		buffer_load_dwordx4 v4, s[0:3], 0 offen lds
		v_add3_u32 v2, v6, v2, s31
		s_add_i32 m0, s41, 0x25000
		s_nop 0
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_add_i32 s9, s9, 0x800
		s_add_i32 s9, s9, s10
		v_add3_u32 v2, s9, v7, v8
		s_add_i32 s10, s28, 0x1000
		v_add3_u32 v4, s9, v8, v10
		s_add_i32 s9, s8, 0x1800
		s_add_i32 s30, s41, 0x10000
		s_add_i32 m0, s28, 0x27000
		s_nop 0
		buffer_load_dwordx4 v2, s[4:7], 0 offen lds
		s_add_i32 s31, s41, 0x11000
		s_add_i32 m0, s8, 0x27800
		s_nop 0
		buffer_load_dwordx4 v4, s[24:27], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s8, s12, 1
		s_mov_b32 s61, 2
		v_mov_b32_e32 v4, s13
		v_mov_b32_e32 v5, 0
		s_mov_b32 s62, 0x100000
		s_mov_b32 s63, 0
		v_mov_b32_e32 v6, s62
		v_mov_b32_e32 v7, s63
		v_mul_lo_u32 v74, v6, v4
		v_mul_hi_u32 v75, v6, v4
		v_mul_lo_u32 v2, v6, v5
		v_add_u32_e32 v75, v75, v2
		v_mul_lo_u32 v2, v7, v4
		v_add_u32_e32 v75, v75, v2
		s_mov_b32 s62, 1
		s_mov_b32 s63, 0
		v_mov_b32_e32 v76, v0
		v_mov_b32_e32 v77, 0
		v_mov_b32_e32 v78, s62
		v_mov_b32_e32 v79, s63
		v_mul_lo_u32 v80, v78, v76
		v_mul_hi_u32 v81, v78, v76
		v_mul_lo_u32 v2, v78, v77
		v_add_u32_e32 v81, v81, v2
		v_mul_lo_u32 v2, v79, v76
		v_add_u32_e32 v81, v81, v2
		v_lshrrev_b64 v[82:83], 6, v[80:81]
		s_mov_b32 s62, 0x10000
		s_mov_b32 s63, 0
		v_mov_b32_e32 v84, s62
		v_mov_b32_e32 v85, s63
		v_mul_lo_u32 v86, v84, v82
		v_mul_hi_u32 v87, v84, v82
		v_mul_lo_u32 v2, v84, v83
		v_add_u32_e32 v87, v87, v2
		v_mul_lo_u32 v2, v85, v82
		v_add_u32_e32 v87, v87, v2
		v_add_co_u32_e64 v88, vcc, v74, v86
		v_addc_co_u32_e64 v89, vcc, v75, v87, vcc
		v_mov_b32_e32 v2, 63
		v_and_b32_e32 v90, v76, v2
		v_and_b32_e32 v91, v5, v5
		v_mul_lo_u32 v76, v78, v90
		v_mul_hi_u32 v77, v78, v90
		v_mul_lo_u32 v2, v78, v91
		v_add_u32_e32 v77, v77, v2
		v_mul_lo_u32 v2, v79, v90
		v_add_u32_e32 v77, v77, v2
		v_lshrrev_b64 v[78:79], 2, v[76:77]
		s_mov_b32 s62, 0x1000
		s_mov_b32 s63, 0
		v_mov_b32_e32 v92, s62
		v_mov_b32_e32 v93, s63
		v_mul_lo_u32 v94, v92, v78
		v_mul_hi_u32 v95, v92, v78
		v_mul_lo_u32 v2, v92, v79
		v_add_u32_e32 v95, v95, v2
		v_mul_lo_u32 v2, v93, v78
		v_add_u32_e32 v95, v95, v2
		v_add_co_u32_e64 v78, vcc, v88, v94
		v_addc_co_u32_e64 v79, vcc, v89, v95, vcc
		v_lshrrev_b64 v[88:89], 3, v[76:77]
		v_mov_b32_e32 v2, 3
		v_and_b32_e32 v76, v88, v2
		v_and_b32_e32 v77, v89, v5
		v_and_b32_e32 v88, v90, v2
		v_and_b32_e32 v89, v91, v5
		v_xor_b32_e32 v76, v76, v88
		v_xor_b32_e32 v77, v77, v89
		s_mov_b32 s62, 16
		s_mov_b32 s63, 0
		v_mov_b32_e32 v88, s62
		v_mov_b32_e32 v89, s63
		v_mul_lo_u32 v92, v88, v76
		v_mul_hi_u32 v93, v88, v76
		v_mul_lo_u32 v2, v88, v77
		v_add_u32_e32 v93, v93, v2
		v_mul_lo_u32 v2, v89, v76
		v_add_u32_e32 v93, v93, v2
		v_add_co_u32_e64 v76, vcc, v78, v92
		v_addc_co_u32_e64 v77, vcc, v79, v93, vcc
		s_mov_b32 s62, 0x80
		s_mov_b32 s63, 0
		v_mov_b32_e32 v78, s62
		v_mov_b32_e32 v79, s63
		v_mov_b32_e32 v2, 0x40000
		v_add_co_u32_e64 v96, vcc, v74, v2
		v_addc_co_u32_e64 v97, vcc, v75, 0, vcc
		v_add_co_u32_e64 v98, vcc, v96, v86
		v_addc_co_u32_e64 v99, vcc, v97, v87, vcc
		v_add_co_u32_e64 v96, vcc, v98, v94
		v_addc_co_u32_e64 v97, vcc, v99, v95, vcc
		v_add_co_u32_e64 v98, vcc, v96, v92
		v_addc_co_u32_e64 v99, vcc, v97, v93, vcc
		v_mov_b32_e32 v4, 0x80000
		v_add_co_u32_e64 v96, vcc, v74, v4
		v_addc_co_u32_e64 v97, vcc, v75, 0, vcc
		v_add_co_u32_e64 v100, vcc, v96, v86
		v_addc_co_u32_e64 v101, vcc, v97, v87, vcc
		v_add_co_u32_e64 v96, vcc, v100, v94
		v_addc_co_u32_e64 v97, vcc, v101, v95, vcc
		v_add_co_u32_e64 v100, vcc, v96, v92
		v_addc_co_u32_e64 v101, vcc, v97, v93, vcc
		v_mov_b32_e32 v8, 0xc0000
		v_add_co_u32_e64 v96, vcc, v74, v8
		v_addc_co_u32_e64 v97, vcc, v75, 0, vcc
		v_add_co_u32_e64 v102, vcc, v96, v86
		v_addc_co_u32_e64 v103, vcc, v97, v87, vcc
		v_add_co_u32_e64 v96, vcc, v102, v94
		v_addc_co_u32_e64 v97, vcc, v103, v95, vcc
		v_add_co_u32_e64 v102, vcc, v96, v92
		v_addc_co_u32_e64 v103, vcc, v97, v93, vcc
		v_mov_b32_e32 v10, 64
		v_add_co_u32_e64 v96, vcc, v74, v10
		v_addc_co_u32_e64 v97, vcc, v75, 0, vcc
		v_add_co_u32_e64 v104, vcc, v96, v86
		v_addc_co_u32_e64 v105, vcc, v97, v87, vcc
		v_add_co_u32_e64 v96, vcc, v104, v94
		v_addc_co_u32_e64 v97, vcc, v105, v95, vcc
		v_add_co_u32_e64 v104, vcc, v96, v92
		v_addc_co_u32_e64 v105, vcc, v97, v93, vcc
		v_mov_b32_e32 v73, 0x40040
		v_add_co_u32_e64 v96, vcc, v74, v73
		v_addc_co_u32_e64 v97, vcc, v75, 0, vcc
		v_add_co_u32_e64 v106, vcc, v96, v86
		v_addc_co_u32_e64 v107, vcc, v97, v87, vcc
		v_add_co_u32_e64 v96, vcc, v106, v94
		v_addc_co_u32_e64 v97, vcc, v107, v95, vcc
		v_add_co_u32_e64 v106, vcc, v96, v92
		v_addc_co_u32_e64 v107, vcc, v97, v93, vcc
		v_mov_b32_e32 v96, 0x80040
		v_add_co_u32_e64 v108, vcc, v74, v96
		v_addc_co_u32_e64 v109, vcc, v75, 0, vcc
		v_add_co_u32_e64 v110, vcc, v108, v86
		v_addc_co_u32_e64 v111, vcc, v109, v87, vcc
		v_add_co_u32_e64 v108, vcc, v110, v94
		v_addc_co_u32_e64 v109, vcc, v111, v95, vcc
		v_add_co_u32_e64 v110, vcc, v108, v92
		v_addc_co_u32_e64 v111, vcc, v109, v93, vcc
		v_mov_b32_e32 v97, 0xc0040
		v_add_co_u32_e64 v108, vcc, v74, v97
		v_addc_co_u32_e64 v109, vcc, v75, 0, vcc
		v_add_co_u32_e64 v112, vcc, v108, v86
		v_addc_co_u32_e64 v113, vcc, v109, v87, vcc
		v_add_co_u32_e64 v108, vcc, v112, v94
		v_addc_co_u32_e64 v109, vcc, v113, v95, vcc
		v_add_co_u32_e64 v112, vcc, v108, v92
		v_addc_co_u32_e64 v113, vcc, v109, v93, vcc
		v_mov_b32_e32 v108, s14
		v_mov_b32_e32 v109, 0
		v_mul_lo_u32 v114, v6, v108
		v_mul_hi_u32 v115, v6, v108
		v_mul_lo_u32 v116, v6, v109
		v_add_u32_e32 v115, v115, v116
		v_mul_lo_u32 v116, v7, v108
		v_add_u32_e32 v115, v115, v116
		v_add_co_u32_e64 v6, vcc, v114, v86
		v_addc_co_u32_e64 v7, vcc, v115, v87, vcc
		v_add_co_u32_e64 v116, vcc, v6, v94
		v_addc_co_u32_e64 v117, vcc, v7, v95, vcc
		v_add_co_u32_e64 v6, vcc, v116, v92
		v_addc_co_u32_e64 v7, vcc, v117, v93, vcc
		v_add_co_u32_e64 v116, vcc, v114, v2
		v_addc_co_u32_e64 v117, vcc, v115, 0, vcc
		v_add_co_u32_e64 v118, vcc, v116, v86
		v_addc_co_u32_e64 v119, vcc, v117, v87, vcc
		v_add_co_u32_e64 v116, vcc, v118, v94
		v_addc_co_u32_e64 v117, vcc, v119, v95, vcc
		v_add_co_u32_e64 v118, vcc, v116, v92
		v_addc_co_u32_e64 v119, vcc, v117, v93, vcc
		v_add_co_u32_e64 v116, vcc, v114, v4
		v_addc_co_u32_e64 v117, vcc, v115, 0, vcc
		v_add_co_u32_e64 v120, vcc, v116, v86
		v_addc_co_u32_e64 v121, vcc, v117, v87, vcc
		v_add_co_u32_e64 v116, vcc, v120, v94
		v_addc_co_u32_e64 v117, vcc, v121, v95, vcc
		v_add_co_u32_e64 v120, vcc, v116, v92
		v_addc_co_u32_e64 v121, vcc, v117, v93, vcc
		v_add_co_u32_e64 v116, vcc, v114, v8
		v_addc_co_u32_e64 v117, vcc, v115, 0, vcc
		v_add_co_u32_e64 v122, vcc, v116, v86
		v_addc_co_u32_e64 v123, vcc, v117, v87, vcc
		v_add_co_u32_e64 v116, vcc, v122, v94
		v_addc_co_u32_e64 v117, vcc, v123, v95, vcc
		v_add_co_u32_e64 v122, vcc, v116, v92
		v_addc_co_u32_e64 v123, vcc, v117, v93, vcc
		v_add_co_u32_e64 v116, vcc, v114, v10
		v_addc_co_u32_e64 v117, vcc, v115, 0, vcc
		v_add_co_u32_e64 v124, vcc, v116, v86
		v_addc_co_u32_e64 v125, vcc, v117, v87, vcc
		v_add_co_u32_e64 v116, vcc, v124, v94
		v_addc_co_u32_e64 v117, vcc, v125, v95, vcc
		v_add_co_u32_e64 v124, vcc, v116, v92
		v_addc_co_u32_e64 v125, vcc, v117, v93, vcc
		v_add_co_u32_e64 v116, vcc, v114, v73
		v_addc_co_u32_e64 v117, vcc, v115, 0, vcc
		v_add_co_u32_e64 v126, vcc, v116, v86
		v_addc_co_u32_e64 v127, vcc, v117, v87, vcc
		v_add_co_u32_e64 v116, vcc, v126, v94
		v_addc_co_u32_e64 v117, vcc, v127, v95, vcc
		v_add_co_u32_e64 v126, vcc, v116, v92
		v_addc_co_u32_e64 v127, vcc, v117, v93, vcc
		v_add_co_u32_e64 v116, vcc, v114, v96
		v_addc_co_u32_e64 v117, vcc, v115, 0, vcc
		v_add_co_u32_e64 v128, vcc, v116, v86
		v_addc_co_u32_e64 v129, vcc, v117, v87, vcc
		v_add_co_u32_e64 v116, vcc, v128, v94
		v_addc_co_u32_e64 v117, vcc, v129, v95, vcc
		v_add_co_u32_e64 v128, vcc, v116, v92
		v_addc_co_u32_e64 v129, vcc, v117, v93, vcc
		v_add_co_u32_e64 v116, vcc, v114, v97
		v_addc_co_u32_e64 v117, vcc, v115, 0, vcc
		v_add_co_u32_e64 v96, vcc, v116, v86
		v_addc_co_u32_e64 v97, vcc, v117, v87, vcc
		v_add_co_u32_e64 v116, vcc, v96, v94
		v_addc_co_u32_e64 v117, vcc, v97, v95, vcc
		v_add_co_u32_e64 v96, vcc, v116, v92
		v_addc_co_u32_e64 v97, vcc, v117, v93, vcc
		v_mul_lo_u32 v116, v84, v108
		v_mul_hi_u32 v117, v84, v108
		v_mul_lo_u32 v2, v84, v109
		v_add_u32_e32 v117, v117, v2
		v_mul_lo_u32 v2, v85, v108
		v_add_u32_e32 v117, v117, v2
		v_add_co_u32_e64 v84, vcc, v74, v116
		v_addc_co_u32_e64 v85, vcc, v75, v117, vcc
		v_lshrrev_b64 v[108:109], 7, v[80:81]
		s_mov_b32 s62, 0x400
		s_mov_b32 s63, 0
		v_mov_b32_e32 v80, s62
		v_mov_b32_e32 v81, s63
		v_mul_lo_u32 v130, v80, v108
		v_mul_hi_u32 v131, v80, v108
		v_mul_lo_u32 v2, v80, v109
		v_add_u32_e32 v131, v131, v2
		v_mul_lo_u32 v2, v81, v108
		v_add_u32_e32 v131, v131, v2
		v_add_co_u32_e64 v108, vcc, v84, v130
		v_addc_co_u32_e64 v109, vcc, v85, v131, vcc
		v_mul_lo_u32 v132, v88, v90
		v_mul_hi_u32 v133, v88, v90
		v_mul_lo_u32 v2, v88, v91
		v_add_u32_e32 v133, v133, v2
		v_mul_lo_u32 v2, v89, v90
		v_add_u32_e32 v133, v133, v2
		v_add_co_u32_e64 v88, vcc, v108, v132
		v_addc_co_u32_e64 v89, vcc, v109, v133, vcc
		s_mov_b32 s62, 0x800
		s_mov_b32 s63, 0
		v_mov_b32_e32 v90, s62
		v_mov_b32_e32 v91, s63
		v_add_co_u32_e64 v108, vcc, v84, v132
		v_addc_co_u32_e64 v109, vcc, v85, v133, vcc
		v_mov_b32_e32 v2, 1
		v_and_b32_e32 v84, v82, v2
		v_and_b32_e32 v85, v83, v5
		v_mul_lo_u32 v4, v80, v84
		v_mul_hi_u32 v5, v80, v84
		v_mul_lo_u32 v2, v80, v85
		v_add_u32_e32 v5, v5, v2
		v_mul_lo_u32 v2, v81, v84
		v_add_u32_e32 v5, v5, v2
		v_add_co_u32_e64 v80, vcc, v108, v4
		v_addc_co_u32_e64 v81, vcc, v109, v5, vcc
		v_mov_b32_e32 v2, 0x80
		v_add_co_u32_e64 v82, vcc, v74, v2
		v_addc_co_u32_e64 v83, vcc, v75, 0, vcc
		v_add_co_u32_e64 v84, vcc, v82, v86
		v_addc_co_u32_e64 v85, vcc, v83, v87, vcc
		v_add_co_u32_e64 v82, vcc, v84, v94
		v_addc_co_u32_e64 v83, vcc, v85, v95, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v84, vcc, v82, v92
		v_addc_co_u32_e64 v85, vcc, v83, v93, vcc
		ds_write_addtid_b32 v84 offset:6144
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v85 offset:7168
		v_mov_b32_e32 v8, 0x40080
		v_add_co_u32_e64 v82, vcc, v74, v8
		v_addc_co_u32_e64 v83, vcc, v75, 0, vcc
		v_add_co_u32_e64 v84, vcc, v82, v86
		v_addc_co_u32_e64 v85, vcc, v83, v87, vcc
		v_add_co_u32_e64 v82, vcc, v84, v94
		v_addc_co_u32_e64 v83, vcc, v85, v95, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v84, vcc, v82, v92
		v_addc_co_u32_e64 v85, vcc, v83, v93, vcc
		ds_write_addtid_b32 v84 offset:8192
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v85 offset:9216
		v_mov_b32_e32 v10, 0x80080
		v_add_co_u32_e64 v82, vcc, v74, v10
		v_addc_co_u32_e64 v83, vcc, v75, 0, vcc
		v_add_co_u32_e64 v84, vcc, v82, v86
		v_addc_co_u32_e64 v85, vcc, v83, v87, vcc
		v_add_co_u32_e64 v82, vcc, v84, v94
		v_addc_co_u32_e64 v83, vcc, v85, v95, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v84, vcc, v82, v92
		v_addc_co_u32_e64 v85, vcc, v83, v93, vcc
		ds_write_addtid_b32 v84 offset:10240
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v85 offset:11264
		v_mov_b32_e32 v73, 0xc0080
		v_add_co_u32_e64 v82, vcc, v74, v73
		v_addc_co_u32_e64 v83, vcc, v75, 0, vcc
		v_add_co_u32_e64 v84, vcc, v82, v86
		v_addc_co_u32_e64 v85, vcc, v83, v87, vcc
		v_add_co_u32_e64 v82, vcc, v84, v94
		v_addc_co_u32_e64 v83, vcc, v85, v95, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v84, vcc, v82, v92
		v_addc_co_u32_e64 v85, vcc, v83, v93, vcc
		ds_write_addtid_b32 v84 offset:12288
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v85 offset:13312
		v_mov_b32_e32 v82, 0xc0
		v_add_co_u32_e64 v84, vcc, v74, v82
		v_addc_co_u32_e64 v85, vcc, v75, 0, vcc
		v_add_co_u32_e64 v108, vcc, v84, v86
		v_addc_co_u32_e64 v109, vcc, v85, v87, vcc
		v_add_co_u32_e64 v84, vcc, v108, v94
		v_addc_co_u32_e64 v85, vcc, v109, v95, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v108, vcc, v84, v92
		v_addc_co_u32_e64 v109, vcc, v85, v93, vcc
		ds_write_addtid_b32 v108 offset:14336
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v109 offset:15360
		v_mov_b32_e32 v83, 0x400c0
		v_add_co_u32_e64 v84, vcc, v74, v83
		v_addc_co_u32_e64 v85, vcc, v75, 0, vcc
		v_add_co_u32_e64 v108, vcc, v84, v86
		v_addc_co_u32_e64 v109, vcc, v85, v87, vcc
		v_add_co_u32_e64 v84, vcc, v108, v94
		v_addc_co_u32_e64 v85, vcc, v109, v95, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v108, vcc, v84, v92
		v_addc_co_u32_e64 v109, vcc, v85, v93, vcc
		ds_write_addtid_b32 v108 offset:16384
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v109 offset:17408
		v_mov_b32_e32 v84, 0x800c0
		v_add_co_u32_e64 v108, vcc, v74, v84
		v_addc_co_u32_e64 v109, vcc, v75, 0, vcc
		v_add_co_u32_e64 v134, vcc, v108, v86
		v_addc_co_u32_e64 v135, vcc, v109, v87, vcc
		v_add_co_u32_e64 v108, vcc, v134, v94
		v_addc_co_u32_e64 v109, vcc, v135, v95, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v134, vcc, v108, v92
		v_addc_co_u32_e64 v135, vcc, v109, v93, vcc
		ds_write_addtid_b32 v134 offset:18432
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v135 offset:19456
		v_mov_b32_e32 v85, 0xc00c0
		v_add_co_u32_e64 v108, vcc, v74, v85
		v_addc_co_u32_e64 v109, vcc, v75, 0, vcc
		v_add_co_u32_e64 v134, vcc, v108, v86
		v_addc_co_u32_e64 v135, vcc, v109, v87, vcc
		v_add_co_u32_e64 v108, vcc, v134, v94
		v_addc_co_u32_e64 v109, vcc, v135, v95, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v134, vcc, v108, v92
		v_addc_co_u32_e64 v135, vcc, v109, v93, vcc
		ds_write_addtid_b32 v134 offset:20480
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v135 offset:21504
		v_add_co_u32_e64 v108, vcc, v114, v2
		v_addc_co_u32_e64 v109, vcc, v115, 0, vcc
		v_add_co_u32_e64 v134, vcc, v108, v86
		v_addc_co_u32_e64 v135, vcc, v109, v87, vcc
		v_add_co_u32_e64 v108, vcc, v134, v94
		v_addc_co_u32_e64 v109, vcc, v135, v95, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v134, vcc, v108, v92
		v_addc_co_u32_e64 v135, vcc, v109, v93, vcc
		ds_write_addtid_b32 v134 offset:22528
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v135 offset:23552
		v_add_co_u32_e64 v108, vcc, v114, v8
		v_addc_co_u32_e64 v109, vcc, v115, 0, vcc
		v_add_co_u32_e64 v134, vcc, v108, v86
		v_addc_co_u32_e64 v135, vcc, v109, v87, vcc
		v_add_co_u32_e64 v108, vcc, v134, v94
		v_addc_co_u32_e64 v109, vcc, v135, v95, vcc
		v_add_co_u32_e64 v134, vcc, v108, v92
		v_addc_co_u32_e64 v135, vcc, v109, v93, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v134, s62
		scratch_store_dword off, v135, s62 offset:4
		v_add_co_u32_e64 v108, vcc, v114, v10
		v_addc_co_u32_e64 v109, vcc, v115, 0, vcc
		v_add_co_u32_e64 v134, vcc, v108, v86
		v_addc_co_u32_e64 v135, vcc, v109, v87, vcc
		v_add_co_u32_e64 v108, vcc, v134, v94
		v_addc_co_u32_e64 v109, vcc, v135, v95, vcc
		v_add_co_u32_e64 v134, vcc, v108, v92
		v_addc_co_u32_e64 v135, vcc, v109, v93, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v134, s62 offset:8
		scratch_store_dword off, v135, s62 offset:12
		v_add_co_u32_e64 v108, vcc, v114, v73
		v_addc_co_u32_e64 v109, vcc, v115, 0, vcc
		v_add_co_u32_e64 v134, vcc, v108, v86
		v_addc_co_u32_e64 v135, vcc, v109, v87, vcc
		v_add_co_u32_e64 v108, vcc, v134, v94
		v_addc_co_u32_e64 v109, vcc, v135, v95, vcc
		v_add_co_u32_e64 v134, vcc, v108, v92
		v_addc_co_u32_e64 v135, vcc, v109, v93, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v134, s62 offset:16
		scratch_store_dword off, v135, s62 offset:20
		v_add_co_u32_e64 v108, vcc, v114, v82
		v_addc_co_u32_e64 v109, vcc, v115, 0, vcc
		v_add_co_u32_e64 v134, vcc, v108, v86
		v_addc_co_u32_e64 v135, vcc, v109, v87, vcc
		v_add_co_u32_e64 v108, vcc, v134, v94
		v_addc_co_u32_e64 v109, vcc, v135, v95, vcc
		v_add_co_u32_e64 v134, vcc, v108, v92
		v_addc_co_u32_e64 v135, vcc, v109, v93, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v134, s62 offset:24
		scratch_store_dword off, v135, s62 offset:28
		v_add_co_u32_e64 v108, vcc, v114, v83
		v_addc_co_u32_e64 v109, vcc, v115, 0, vcc
		v_add_co_u32_e64 v82, vcc, v108, v86
		v_addc_co_u32_e64 v83, vcc, v109, v87, vcc
		v_add_co_u32_e64 v108, vcc, v82, v94
		v_addc_co_u32_e64 v109, vcc, v83, v95, vcc
		v_add_co_u32_e64 v82, vcc, v108, v92
		v_addc_co_u32_e64 v83, vcc, v109, v93, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v82, s62 offset:32
		scratch_store_dword off, v83, s62 offset:36
		v_add_co_u32_e64 v82, vcc, v114, v84
		v_addc_co_u32_e64 v83, vcc, v115, 0, vcc
		v_add_co_u32_e64 v108, vcc, v82, v86
		v_addc_co_u32_e64 v109, vcc, v83, v87, vcc
		v_add_co_u32_e64 v82, vcc, v108, v94
		v_addc_co_u32_e64 v83, vcc, v109, v95, vcc
		v_add_co_u32_e64 v108, vcc, v82, v92
		v_addc_co_u32_e64 v109, vcc, v83, v93, vcc
		v_add_co_u32_e64 v82, vcc, v114, v85
		v_addc_co_u32_e64 v83, vcc, v115, 0, vcc
		v_add_co_u32_e64 v84, vcc, v82, v86
		v_addc_co_u32_e64 v85, vcc, v83, v87, vcc
		v_add_co_u32_e64 v82, vcc, v84, v94
		v_addc_co_u32_e64 v83, vcc, v85, v95, vcc
		v_add_co_u32_e64 v84, vcc, v82, v92
		v_addc_co_u32_e64 v85, vcc, v83, v93, vcc
		v_mov_b32_e32 v2, 0x800
		v_add_co_u32_e64 v82, vcc, v74, v2
		v_addc_co_u32_e64 v83, vcc, v75, 0, vcc
		v_add_co_u32_e64 v74, vcc, v82, v116
		v_addc_co_u32_e64 v75, vcc, v83, v117, vcc
		v_add_co_u32_e64 v82, vcc, v74, v130
		v_addc_co_u32_e64 v83, vcc, v75, v131, vcc
		v_add_co_u32_e64 v86, vcc, v82, v132
		v_addc_co_u32_e64 v87, vcc, v83, v133, vcc
		v_add_co_u32_e64 v82, vcc, v74, v132
		v_addc_co_u32_e64 v83, vcc, v75, v133, vcc
		v_add_co_u32_e64 v74, vcc, v82, v4
		v_addc_co_u32_e64 v75, vcc, v83, v5, vcc
		v_mov_b32_e32 v4, s61
		v_mov_b32_e32 v5, 0
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
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
		v_accvgpr_write_b32 a16, 0
		v_accvgpr_write_b32 a17, 0
		v_accvgpr_write_b32 a18, 0
		v_accvgpr_write_b32 a19, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a20, 0
		v_accvgpr_write_b32 a21, 0
		v_accvgpr_write_b32 a22, 0
		v_accvgpr_write_b32 a23, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a24, 0
		v_accvgpr_write_b32 a25, 0
		v_accvgpr_write_b32 a26, 0
		v_accvgpr_write_b32 a27, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a28, 0
		v_accvgpr_write_b32 a29, 0
		v_accvgpr_write_b32 a30, 0
		v_accvgpr_write_b32 a31, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a32, 0
		v_accvgpr_write_b32 a33, 0
		v_accvgpr_write_b32 a34, 0
		v_accvgpr_write_b32 a35, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a36, 0
		v_accvgpr_write_b32 a37, 0
		v_accvgpr_write_b32 a38, 0
		v_accvgpr_write_b32 a39, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a40, 0
		v_accvgpr_write_b32 a41, 0
		v_accvgpr_write_b32 a42, 0
		v_accvgpr_write_b32 a43, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a44, 0
		v_accvgpr_write_b32 a45, 0
		v_accvgpr_write_b32 a46, 0
		v_accvgpr_write_b32 a47, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a48, 0
		v_accvgpr_write_b32 a49, 0
		v_accvgpr_write_b32 a50, 0
		v_accvgpr_write_b32 a51, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a52, 0
		v_accvgpr_write_b32 a53, 0
		v_accvgpr_write_b32 a54, 0
		v_accvgpr_write_b32 a55, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a56, 0
		v_accvgpr_write_b32 a57, 0
		v_accvgpr_write_b32 a58, 0
		v_accvgpr_write_b32 a59, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a60, 0
		v_accvgpr_write_b32 a61, 0
		v_accvgpr_write_b32 a62, 0
		v_accvgpr_write_b32 a63, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a64, 0
		v_accvgpr_write_b32 a65, 0
		v_accvgpr_write_b32 a66, 0
		v_accvgpr_write_b32 a67, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a68, 0
		v_accvgpr_write_b32 a69, 0
		v_accvgpr_write_b32 a70, 0
		v_accvgpr_write_b32 a71, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a72, 0
		v_accvgpr_write_b32 a73, 0
		v_accvgpr_write_b32 a74, 0
		v_accvgpr_write_b32 a75, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a76, 0
		v_accvgpr_write_b32 a77, 0
		v_accvgpr_write_b32 a78, 0
		v_accvgpr_write_b32 a79, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a80, 0
		v_accvgpr_write_b32 a81, 0
		v_accvgpr_write_b32 a82, 0
		v_accvgpr_write_b32 a83, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a84, 0
		v_accvgpr_write_b32 a85, 0
		v_accvgpr_write_b32 a86, 0
		v_accvgpr_write_b32 a87, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a88, 0
		v_accvgpr_write_b32 a89, 0
		v_accvgpr_write_b32 a90, 0
		v_accvgpr_write_b32 a91, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a92, 0
		v_accvgpr_write_b32 a93, 0
		v_accvgpr_write_b32 a94, 0
		v_accvgpr_write_b32 a95, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a96, 0
		v_accvgpr_write_b32 a97, 0
		v_accvgpr_write_b32 a98, 0
		v_accvgpr_write_b32 a99, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a100, 0
		v_accvgpr_write_b32 a101, 0
		v_accvgpr_write_b32 a102, 0
		v_accvgpr_write_b32 a103, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a104, 0
		v_accvgpr_write_b32 a105, 0
		v_accvgpr_write_b32 a106, 0
		v_accvgpr_write_b32 a107, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a108, 0
		v_accvgpr_write_b32 a109, 0
		v_accvgpr_write_b32 a110, 0
		v_accvgpr_write_b32 a111, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a112, 0
		v_accvgpr_write_b32 a113, 0
		v_accvgpr_write_b32 a114, 0
		v_accvgpr_write_b32 a115, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a116, 0
		v_accvgpr_write_b32 a117, 0
		v_accvgpr_write_b32 a118, 0
		v_accvgpr_write_b32 a119, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a120, 0
		v_accvgpr_write_b32 a121, 0
		v_accvgpr_write_b32 a122, 0
		v_accvgpr_write_b32 a123, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a124, 0
		v_accvgpr_write_b32 a125, 0
		v_accvgpr_write_b32 a126, 0
		v_accvgpr_write_b32 a127, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a128, 0
		v_accvgpr_write_b32 a129, 0
		v_accvgpr_write_b32 a130, 0
		v_accvgpr_write_b32 a131, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a132, 0
		v_accvgpr_write_b32 a133, 0
		v_accvgpr_write_b32 a134, 0
		v_accvgpr_write_b32 a135, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a136, 0
		v_accvgpr_write_b32 a137, 0
		v_accvgpr_write_b32 a138, 0
		v_accvgpr_write_b32 a139, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a140, 0
		v_accvgpr_write_b32 a141, 0
		v_accvgpr_write_b32 a142, 0
		v_accvgpr_write_b32 a143, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a144, 0
		v_accvgpr_write_b32 a145, 0
		v_accvgpr_write_b32 a146, 0
		v_accvgpr_write_b32 a147, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a148, 0
		v_accvgpr_write_b32 a149, 0
		v_accvgpr_write_b32 a150, 0
		v_accvgpr_write_b32 a151, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a152, 0
		v_accvgpr_write_b32 a153, 0
		v_accvgpr_write_b32 a154, 0
		v_accvgpr_write_b32 a155, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a156, 0
		v_accvgpr_write_b32 a157, 0
		v_accvgpr_write_b32 a158, 0
		v_accvgpr_write_b32 a159, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a160, 0
		v_accvgpr_write_b32 a161, 0
		v_accvgpr_write_b32 a162, 0
		v_accvgpr_write_b32 a163, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a164, 0
		v_accvgpr_write_b32 a165, 0
		v_accvgpr_write_b32 a166, 0
		v_accvgpr_write_b32 a167, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a168, 0
		v_accvgpr_write_b32 a169, 0
		v_accvgpr_write_b32 a170, 0
		v_accvgpr_write_b32 a171, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a172, 0
		v_accvgpr_write_b32 a173, 0
		v_accvgpr_write_b32 a174, 0
		v_accvgpr_write_b32 a175, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a176, 0
		v_accvgpr_write_b32 a177, 0
		v_accvgpr_write_b32 a178, 0
		v_accvgpr_write_b32 a179, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a180, 0
		v_accvgpr_write_b32 a181, 0
		v_accvgpr_write_b32 a182, 0
		v_accvgpr_write_b32 a183, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a184, 0
		v_accvgpr_write_b32 a185, 0
		v_accvgpr_write_b32 a186, 0
		v_accvgpr_write_b32 a187, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a188, 0
		v_accvgpr_write_b32 a189, 0
		v_accvgpr_write_b32 a190, 0
		v_accvgpr_write_b32 a191, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a192, 0
		v_accvgpr_write_b32 a193, 0
		v_accvgpr_write_b32 a194, 0
		v_accvgpr_write_b32 a195, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a196, 0
		v_accvgpr_write_b32 a197, 0
		v_accvgpr_write_b32 a198, 0
		v_accvgpr_write_b32 a199, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a200, 0
		v_accvgpr_write_b32 a201, 0
		v_accvgpr_write_b32 a202, 0
		v_accvgpr_write_b32 a203, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a204, 0
		v_accvgpr_write_b32 a205, 0
		v_accvgpr_write_b32 a206, 0
		v_accvgpr_write_b32 a207, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a208, 0
		v_accvgpr_write_b32 a209, 0
		v_accvgpr_write_b32 a210, 0
		v_accvgpr_write_b32 a211, 0
.Lwmma_f16_matmul_tiled.loop_head_0:
		v_mov_b32_e32 v4, s61
		v_mul_lo_u32 v82, v78, v4
		v_mul_hi_u32 v83, v78, v4
		v_mul_lo_u32 v2, v78, v5
		v_add_u32_e32 v83, v83, v2
		v_mul_lo_u32 v2, v79, v4
		v_add_u32_e32 v83, v83, v2
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v114, vcc, v76, v82
		v_addc_co_u32_e64 v115, vcc, v77, v83, vcc
		ds_write_addtid_b32 v114 offset:2048
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v114, vcc, v98, v82
		v_addc_co_u32_e64 v115, vcc, v99, v83, vcc
		ds_write_addtid_b32 v114 offset:3072
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v114, vcc, v100, v82
		v_addc_co_u32_e64 v115, vcc, v101, v83, vcc
		ds_write_addtid_b32 v114 offset:4096
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v114, vcc, v102, v82
		v_addc_co_u32_e64 v115, vcc, v103, v83, vcc
		ds_write_addtid_b32 v114 offset:5120
		v_add_co_u32_e64 v114, vcc, v104, v82
		v_addc_co_u32_e64 v115, vcc, v105, v83, vcc
		v_add_co_u32_e64 v116, vcc, v106, v82
		v_addc_co_u32_e64 v117, vcc, v107, v83, vcc
		v_add_co_u32_e64 v130, vcc, v110, v82
		v_addc_co_u32_e64 v131, vcc, v111, v83, vcc
		v_add_co_u32_e64 v184, vcc, v112, v82
		v_addc_co_u32_e64 v185, vcc, v113, v83, vcc
		v_add_co_u32_e64 v186, vcc, v6, v82
		v_addc_co_u32_e64 v187, vcc, v7, v83, vcc
		v_add_co_u32_e64 v188, vcc, v118, v82
		v_addc_co_u32_e64 v189, vcc, v119, v83, vcc
		v_add_co_u32_e64 v190, vcc, v120, v82
		v_addc_co_u32_e64 v191, vcc, v121, v83, vcc
		v_add_co_u32_e64 v192, vcc, v122, v82
		v_addc_co_u32_e64 v193, vcc, v123, v83, vcc
		v_add_co_u32_e64 v194, vcc, v124, v82
		v_addc_co_u32_e64 v195, vcc, v125, v83, vcc
		v_add_co_u32_e64 v196, vcc, v126, v82
		v_addc_co_u32_e64 v197, vcc, v127, v83, vcc
		v_add_co_u32_e64 v198, vcc, v128, v82
		v_addc_co_u32_e64 v199, vcc, v129, v83, vcc
		v_add_co_u32_e64 v200, vcc, v96, v82
		v_addc_co_u32_e64 v201, vcc, v97, v83, vcc
		v_mul_lo_u32 v202, v90, v4
		v_mul_hi_u32 v203, v90, v4
		v_mul_lo_u32 v2, v90, v5
		v_add_u32_e32 v203, v203, v2
		v_mul_lo_u32 v2, v91, v4
		v_add_u32_e32 v203, v203, v2
		v_add_co_u32_e64 v204, vcc, v88, v202
		v_addc_co_u32_e64 v205, vcc, v89, v203, vcc
		v_add_co_u32_e64 v206, vcc, v80, v202
		v_addc_co_u32_e64 v207, vcc, v81, v203, vcc
		s_waitcnt lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], a[0:3], v[36:39], v[12:15], v19, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s62, s61, 1
		s_lshl_b32 s63, s62, 16
		v_add_u32_e32 v2, s63, v3
		v_add3_u32 v2, v2, v11, v16
		v_add_u32_e32 v8, 0x400, v2
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		ds_read_b128 a[212:215], v8 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[0:3], v[40:43], v[92:95], v19, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v8, 0x400, v2
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		ds_read_b128 a[216:219], v8 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[0:3], v[44:47], v[132:135], v19, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v8, 0x400, v2
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		ds_read_b128 a[220:223], v8 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[0:3], v[48:51], v[136:139], v19, v71 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v8, 0x400, v2
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		ds_read_b128 a[224:227], v8 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[0:3], v[52:55], v[140:143], v19, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v8, 0x400, v2
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		ds_read_b128 a[228:231], v8 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[0:3], v[56:59], v[144:147], v19, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v8, 0x400, v2
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		ds_read_b128 a[232:235], v8 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[0:3], v[60:63], v[148:151], v19, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v8, 0x400, v2
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		ds_read_b128 a[236:239], v8 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[0:3], v[64:67], v[152:155], v19, v17 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v8, 0x400, v2
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		ds_read_b128 a[240:243], v8 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[4:7], v[36:39], v[156:159], v19, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v8, s63, v11
		v_add3_u32 v8, v8, v1, v16
		v_add_u32_e32 v10, 0x400, v8
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		ds_read_b128 a[244:247], v10 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[4:7], v[40:43], v[160:163], v19, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v10, 0x400, v8
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		ds_read_b128 a[248:251], v10 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[4:7], v[44:47], v[164:167], v19, v71 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v10, 0x400, v8
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		ds_read_b128 a[252:255], v10 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[4:7], v[48:51], v[168:171], v19, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		ds_read_b128 v[208:211], v8 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[4:7], v[52:55], v[172:175], v19, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s63, s61, 1
		s_lshl_b32 s63, s63, 16
		v_and_b32_e32 v8, 15, v0
		v_lshlrev_b32_e32 v8, 6, v8
		v_add_u32_e32 v8, s63, v8
		v_lshrrev_b32_e32 v10, 6, v0
		v_and_b32_e32 v10, 1, v10
		v_lshlrev_b32_e32 v10, 13, v10
		v_lshlrev_b32_e32 v73, 4, v9
		v_add3_u32 v8, v8, v10, v73
		v_add_u32_e32 v10, 0x400, v8
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		ds_read_b128 v[212:215], v10 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[4:7], v[56:59], v[176:179], v19, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v10, 0x400, v8
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		ds_read_b128 v[216:219], v10 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[4:7], v[60:63], v[180:183], v19, v17 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v10, 0x400, v8
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		ds_read_b128 v[220:223], v10 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[4:7], v[64:67], a[16:19], v19, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v10, 0x400, v8
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		ds_read_b128 v[224:227], v10 offset:56320
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[8:11], v[36:39], a[20:23], v68, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(14)
		ds_read_addtid_b32 v10 offset:2048
		s_add_i32 m0, s41, 0x6000
		s_waitcnt lgkmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[8:11], v[40:43], a[24:27], v68, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v10 offset:3072
		s_add_i32 m0, s11, 0x6000
		s_waitcnt lgkmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[8:11], v[44:47], a[28:31], v68, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v10 offset:4096
		s_add_i32 m0, s29, 0x6000
		s_waitcnt lgkmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[8:11], v[48:51], a[32:35], v68, v71 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v10 offset:5120
		s_add_i32 m0, s47, 0x6000
		s_waitcnt lgkmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[8:11], v[52:55], a[36:39], v68, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s48, 0x6000
		s_nop 0
		buffer_load_dwordx4 v114, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[8:11], v[56:59], a[40:43], v68, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s49, 0x6000
		s_nop 0
		buffer_load_dwordx4 v116, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[8:11], v[60:63], a[44:47], v68, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s50, 0x6000
		s_nop 0
		buffer_load_dwordx4 v130, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[8:11], v[64:67], a[48:51], v68, v17 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s51, 0x6000
		s_nop 0
		buffer_load_dwordx4 v184, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[12:15], v[36:39], a[52:55], v68, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s52, 0x6000
		s_nop 0
		buffer_load_dwordx4 v186, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[12:15], v[40:43], a[56:59], v68, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s53, 0x6000
		s_nop 0
		buffer_load_dwordx4 v188, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[12:15], v[44:47], a[60:63], v68, v71 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s54, 0x6000
		s_nop 0
		buffer_load_dwordx4 v190, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[12:15], v[48:51], a[64:67], v68, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s55, 0x6000
		s_nop 0
		buffer_load_dwordx4 v192, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[12:15], v[52:55], a[68:71], v68, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s56, 0x6000
		s_nop 0
		buffer_load_dwordx4 v194, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[12:15], v[56:59], a[72:75], v68, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s57, 0x6000
		s_nop 0
		buffer_load_dwordx4 v196, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[12:15], v[60:63], a[76:79], v68, v17 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s58, 0x6000
		s_nop 0
		buffer_load_dwordx4 v198, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[12:15], v[64:67], a[80:83], v68, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s59, 0x6000
		s_nop 0
		buffer_load_dwordx4 v200, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[20:23], v[36:39], a[84:87], v69, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s63, s61, 1
		s_add_i32 m0, s28, 0x26000
		s_nop 0
		buffer_load_dwordx4 v204, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[20:23], v[40:43], a[88:91], v69, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshl_b32 s62, s62, 12
		s_add_i32 m0, s60, 0x26000
		s_nop 0
		buffer_load_dwordx4 v206, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[20:23], v[44:47], a[92:95], v69, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		v_add_u32_e32 v10, 0x400, v2
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		ds_read_b128 a[0:3], v10
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[20:23], v[48:51], a[96:99], v69, v71 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v10, 0x400, v2
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		ds_read_b128 a[4:7], v10 offset:1024
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[20:23], v[52:55], a[100:103], v69, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v10, 0x400, v2
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		ds_read_b128 a[8:11], v10 offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[20:23], v[56:59], a[104:107], v69, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v10, 0x400, v2
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		ds_read_b128 a[12:15], v10 offset:3072
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[20:23], v[60:63], a[108:111], v69, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v10, 0x400, v2
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		ds_read_b128 v[184:187], v10 offset:4096
		s_mov_b32 s64, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v184, s64 offset:40
		scratch_store_dword off, v185, s64 offset:44
		scratch_store_dword off, v186, s64 offset:48
		scratch_store_dword off, v187, s64 offset:52
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[20:23], v[64:67], a[112:115], v69, v17 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v10, 0x400, v2
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		ds_read_b128 v[20:23], v10 offset:5120
		s_mov_b32 s64, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s64 offset:56
		scratch_store_dword off, v21, s64 offset:60
		scratch_store_dword off, v22, s64 offset:64
		scratch_store_dword off, v23, s64 offset:68
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[24:27], v[36:39], a[116:119], v69, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v10, 0x400, v2
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		ds_read_b128 v[20:23], v10 offset:6144
		s_mov_b32 s64, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s64 offset:72
		scratch_store_dword off, v21, s64 offset:76
		scratch_store_dword off, v22, s64 offset:80
		scratch_store_dword off, v23, s64 offset:84
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[24:27], v[40:43], a[120:123], v69, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[20:23], v2 offset:7168
		s_mov_b32 s64, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s64 offset:88
		scratch_store_dword off, v21, s64 offset:92
		scratch_store_dword off, v22, s64 offset:96
		scratch_store_dword off, v23, s64 offset:100
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[24:27], v[44:47], a[124:127], v69, v71 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v8
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[20:23], v2 offset:32768
		s_mov_b32 s64, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s64 offset:104
		scratch_store_dword off, v21, s64 offset:108
		scratch_store_dword off, v22, s64 offset:112
		scratch_store_dword off, v23, s64 offset:116
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[24:27], v[48:51], a[128:131], v69, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v8
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[20:23], v2 offset:33792
		s_mov_b32 s64, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s64 offset:120
		scratch_store_dword off, v21, s64 offset:124
		scratch_store_dword off, v22, s64 offset:128
		scratch_store_dword off, v23, s64 offset:132
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[24:27], v[52:55], a[132:135], v69, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v8
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[20:23], v2 offset:34816
		s_mov_b32 s64, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s64 offset:136
		scratch_store_dword off, v21, s64 offset:140
		scratch_store_dword off, v22, s64 offset:144
		scratch_store_dword off, v23, s64 offset:148
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[24:27], v[56:59], a[136:139], v69, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v8
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[20:23], v2 offset:35840
		s_mov_b32 s64, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s64 offset:152
		scratch_store_dword off, v21, s64 offset:156
		scratch_store_dword off, v22, s64 offset:160
		scratch_store_dword off, v23, s64 offset:164
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[24:27], v[60:63], a[140:143], v69, v17 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v8
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[20:23], v2 offset:36864
		s_mov_b32 s64, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s64 offset:168
		scratch_store_dword off, v21, s64 offset:172
		scratch_store_dword off, v22, s64 offset:176
		scratch_store_dword off, v23, s64 offset:180
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[24:27], v[64:67], a[144:147], v69, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v8
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[20:23], v2 offset:37888
		s_mov_b32 s64, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s64 offset:184
		scratch_store_dword off, v21, s64 offset:188
		scratch_store_dword off, v22, s64 offset:192
		scratch_store_dword off, v23, s64 offset:196
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[28:31], v[36:39], a[148:151], v18, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v8
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[20:23], v2 offset:38912
		s_mov_b32 s64, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s64 offset:200
		scratch_store_dword off, v21, s64 offset:204
		scratch_store_dword off, v22, s64 offset:208
		scratch_store_dword off, v23, s64 offset:212
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[28:31], v[40:43], a[152:155], v18, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v8
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[184:187], v2 offset:39936
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[28:31], v[44:47], a[156:159], v18, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s62, s62, 0x20000
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v2, 10, v2
		v_and_b32_e32 v8, 63, v0
		v_lshlrev_b32_e32 v8, 2, v8
		v_add3_u32 v10, s62, v2, v8
		v_add_u32_e32 v20, 0x400, v10
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		ds_read_b32 v73, v20
		v_add_u32_e32 v20, 0x400, v10
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		ds_read_b32 v114, v20 offset:256
		v_add_u32_e32 v20, 0x400, v10
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		ds_read_b32 v115, v20 offset:512
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		ds_read_b32 v116, v10 offset:768
		v_lshrrev_b32_e32 v10, 6, v0
		v_and_b32_e32 v10, 1, v10
		v_lshlrev_b32_e32 v10, 10, v10
		v_add3_u32 v20, s62, v8, v10
		v_add_u32_e32 v21, 0x400, v20
		v_add_u32_e32 v21, 0x400, v21
		v_add_u32_e32 v21, 0x400, v21
		v_add_u32_e32 v21, 0x400, v21
		v_add_u32_e32 v21, 0x400, v21
		v_add_u32_e32 v21, 0x400, v21
		v_add_u32_e32 v21, 0x800, v21
		v_add_u32_e32 v21, 0x800, v21
		v_add_u32_e32 v21, 0x800, v21
		v_add_u32_e32 v21, 0x800, v21
		v_add_u32_e32 v21, 0x800, v21
		v_add_u32_e32 v21, 0x800, v21
		v_add_u32_e32 v21, 0x800, v21
		v_add_u32_e32 v21, 0x800, v21
		v_add_u32_e32 v21, 0x800, v21
		ds_read_b32 v117, v21 offset:2048
		v_add_u32_e32 v21, 0x400, v20
		v_add_u32_e32 v21, 0x400, v21
		v_add_u32_e32 v21, 0x400, v21
		v_add_u32_e32 v21, 0x400, v21
		v_add_u32_e32 v21, 0x400, v21
		v_add_u32_e32 v21, 0x400, v21
		v_add_u32_e32 v21, 0x800, v21
		v_add_u32_e32 v21, 0x800, v21
		v_add_u32_e32 v21, 0x800, v21
		v_add_u32_e32 v21, 0x800, v21
		v_add_u32_e32 v21, 0x800, v21
		v_add_u32_e32 v21, 0x800, v21
		v_add_u32_e32 v21, 0x800, v21
		v_add_u32_e32 v21, 0x800, v21
		v_add_u32_e32 v21, 0x800, v21
		ds_read_b32 v130, v21 offset:2304
		v_add_u32_e32 v21, 0x400, v20
		v_add_u32_e32 v21, 0x400, v21
		v_add_u32_e32 v21, 0x400, v21
		v_add_u32_e32 v21, 0x400, v21
		v_add_u32_e32 v21, 0x400, v21
		v_add_u32_e32 v21, 0x400, v21
		v_add_u32_e32 v21, 0x800, v21
		v_add_u32_e32 v21, 0x800, v21
		v_add_u32_e32 v21, 0x800, v21
		v_add_u32_e32 v21, 0x800, v21
		v_add_u32_e32 v21, 0x800, v21
		v_add_u32_e32 v21, 0x800, v21
		v_add_u32_e32 v21, 0x800, v21
		v_add_u32_e32 v21, 0x800, v21
		v_add_u32_e32 v21, 0x800, v21
		ds_read_b32 v131, v21 offset:2560
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		ds_read_b32 v188, v20 offset:2816
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[28:31], v[48:51], a[160:163], v18, v71 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[32:35], v[48:51], a[192:195], v18, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[32:35], v[44:47], a[188:191], v18, v71 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[32:35], v[36:39], a[180:183], v18, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[32:35], v[40:43], a[184:187], v18, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[32:35], v[52:55], a[196:199], v18, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[28:31], v[52:55], a[164:167], v18, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[28:31], v[56:59], a[168:171], v18, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[32:35], v[56:59], a[200:203], v18, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[32:35], v[60:63], a[204:207], v18, v17 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[28:31], v[60:63], a[172:175], v18, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[28:31], v[64:67], a[176:179], v18, v17 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[32:35], v[64:67], a[208:211], v18, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[236:239], v[220:223], a[172:175], v18, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[236:239], v[224:227], a[176:179], v18, v17 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[240:243], v[224:227], a[208:211], v18, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[240:243], v[220:223], a[204:207], v18, v17 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[212:215], v[220:223], v[148:151], v19, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[212:215], v[224:227], v[152:155], v19, v17 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[216:219], v[224:227], a[16:19], v19, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[216:219], v[220:223], v[180:183], v19, v17 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[216:219], a[244:247], v[156:159], v19, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], a[212:215], a[244:247], v[12:15], v19, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[212:215], a[248:251], v[92:95], v19, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[216:219], a[248:251], v[160:163], v19, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[216:219], a[252:255], v[164:167], v19, v71 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[212:215], a[252:255], v[132:135], v19, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[212:215], v[208:211], v[136:139], v19, v71 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[216:219], v[208:211], v[168:171], v19, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[216:219], v[212:215], v[172:175], v19, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[212:215], v[212:215], v[140:143], v19, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[212:215], v[216:219], v[144:147], v19, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[216:219], v[216:219], v[176:179], v19, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[220:223], v[216:219], a[40:43], v68, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[220:223], v[212:215], a[36:39], v68, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[224:227], v[212:215], a[68:71], v68, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[224:227], v[216:219], a[72:75], v68, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[224:227], a[244:247], a[52:55], v68, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[220:223], a[244:247], a[20:23], v68, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[220:223], a[248:251], a[24:27], v68, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[224:227], a[248:251], a[56:59], v68, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[224:227], a[252:255], a[60:63], v68, v71 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[220:223], a[252:255], a[28:31], v68, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[220:223], v[208:211], a[32:35], v68, v71 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[224:227], v[208:211], a[64:67], v68, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[224:227], v[220:223], a[76:79], v68, v17 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[220:223], v[220:223], a[44:47], v68, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[220:223], v[224:227], a[48:51], v68, v17 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[224:227], v[224:227], a[80:83], v68, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[228:231], v[224:227], a[112:115], v69, v17 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[228:231], v[220:223], a[108:111], v69, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[232:235], v[220:223], a[140:143], v69, v17 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[232:235], v[224:227], a[144:147], v69, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[232:235], a[244:247], a[116:119], v69, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[228:231], a[244:247], a[84:87], v69, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], a[228:231], a[248:251], a[88:91], v69, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[232:235], a[248:251], a[120:123], v69, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[232:235], a[252:255], a[124:127], v69, v71 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], a[228:231], a[252:255], a[92:95], v69, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[228:231], v[208:211], a[96:99], v69, v71 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[232:235], v[208:211], a[128:131], v69, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[232:235], v[212:215], a[132:135], v69, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[228:231], v[212:215], a[100:103], v69, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[228:231], v[216:219], a[104:107], v69, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[232:235], v[216:219], a[136:139], v69, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[236:239], v[216:219], a[168:171], v18, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[236:239], v[212:215], a[164:167], v18, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[240:243], v[212:215], a[196:199], v18, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[240:243], v[216:219], a[200:203], v18, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[240:243], a[244:247], a[180:183], v18, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[236:239], a[244:247], a[148:151], v18, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[236:239], a[248:251], a[152:155], v18, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[240:243], a[248:251], a[184:187], v18, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[240:243], a[252:255], a[188:191], v18, v71 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[236:239], a[252:255], a[156:159], v18, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[236:239], v[208:211], a[160:163], v18, v71 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[240:243], v[208:211], a[192:195], v18, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s62, s63, 1
		s_lshl_b32 s63, s62, 16
		v_lshrrev_b32_e32 v17, 7, v0
		v_lshlrev_b32_e32 v17, 13, v17
		s_mov_b32 m0, s15
		v_add_u32_e32 v17, s63, v17
		ds_read_addtid_b32 v18
		s_waitcnt lgkmcnt(0)
		v_lshlrev_b32_e32 v18, 4, v18
		v_and_b32_e32 v19, 15, v0
		v_lshlrev_b32_e32 v19, 6, v19
		v_add3_u32 v17, v17, v19, v18
		v_add_u32_e32 v20, 0x400, v17
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		ds_read_b128 v[24:27], v20
		v_add_u32_e32 v20, 0x400, v17
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		ds_read_b128 v[28:31], v20 offset:1024
		v_add_u32_e32 v20, 0x400, v17
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		ds_read_b128 v[32:35], v20 offset:2048
		v_add_u32_e32 v20, 0x400, v17
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		ds_read_b128 v[36:39], v20 offset:3072
		v_add_u32_e32 v20, 0x400, v17
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		ds_read_b128 v[40:43], v20 offset:4096
		v_add_u32_e32 v20, 0x400, v17
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		ds_read_b128 v[44:47], v20 offset:5120
		v_add_u32_e32 v20, 0x400, v17
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		ds_read_b128 a[212:215], v20 offset:6144
		v_add_u32_e32 v20, 0x400, v17
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x800, v20
		ds_read_b128 a[216:219], v20 offset:7168
		s_mov_b32 m0, s15
		v_add_u32_e32 v19, s63, v19
		ds_read_addtid_b32 v20 offset:1024
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v18, v19, v20, v18
		v_add_u32_e32 v19, 0x400, v18
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		ds_read_b128 a[220:223], v19 offset:32768
		v_add_u32_e32 v19, 0x400, v18
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		ds_read_b128 a[224:227], v19 offset:33792
		v_add_u32_e32 v19, 0x400, v18
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		ds_read_b128 a[228:231], v19 offset:34816
		v_add_u32_e32 v19, 0x400, v18
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		ds_read_b128 a[232:235], v19 offset:35840
		v_add_u32_e32 v19, 0x400, v18
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		ds_read_b128 a[236:239], v19 offset:36864
		v_add_u32_e32 v19, 0x400, v18
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		ds_read_b128 a[240:243], v19 offset:37888
		v_add_u32_e32 v19, 0x400, v18
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		ds_read_b128 v[20:23], v19 offset:38912
		v_add_u32_e32 v19, 0x400, v18
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		ds_read_b128 a[244:247], v19 offset:39936
		s_lshl_b32 s62, s62, 12
		s_add_i32 s62, s62, 0x20000
		v_add3_u32 v2, s62, v2, v8
		v_add_u32_e32 v19, 0x400, v2
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		ds_read_b32 v48, v19
		v_add_u32_e32 v19, 0x400, v2
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		ds_read_b32 v49, v19 offset:256
		v_add_u32_e32 v19, 0x400, v2
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x400, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		v_add_u32_e32 v19, 0x800, v19
		ds_read_b32 v50, v19 offset:512
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b32 v19, v2 offset:768
		v_add3_u32 v2, s62, v8, v10
		v_add_u32_e32 v8, 0x400, v2
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		ds_read_b32 v10, v8 offset:2048
		v_add_u32_e32 v8, 0x400, v2
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		ds_read_b32 v51, v8 offset:2304
		v_add_u32_e32 v8, 0x400, v2
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		ds_read_b32 v52, v8 offset:2560
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b32 v8, v2 offset:2816
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v54 offset:6144
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v55 offset:7168
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v56, vcc, v54, v82
		v_addc_co_u32_e64 v57, vcc, v55, v83, vcc
		ds_read_addtid_b32 v54 offset:8192
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v55 offset:9216
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v58, vcc, v54, v82
		v_addc_co_u32_e64 v59, vcc, v55, v83, vcc
		ds_read_addtid_b32 v54 offset:10240
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v55 offset:11264
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v60, vcc, v54, v82
		v_addc_co_u32_e64 v61, vcc, v55, v83, vcc
		ds_read_addtid_b32 v54 offset:12288
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v55 offset:13312
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v62, vcc, v54, v82
		v_addc_co_u32_e64 v63, vcc, v55, v83, vcc
		ds_read_addtid_b32 v54 offset:14336
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v55 offset:15360
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v64, vcc, v54, v82
		v_addc_co_u32_e64 v65, vcc, v55, v83, vcc
		ds_read_addtid_b32 v54 offset:16384
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v55 offset:17408
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v66, vcc, v54, v82
		v_addc_co_u32_e64 v67, vcc, v55, v83, vcc
		ds_read_addtid_b32 v54 offset:18432
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v55 offset:19456
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v68, vcc, v54, v82
		v_addc_co_u32_e64 v69, vcc, v55, v83, vcc
		ds_read_addtid_b32 v54 offset:20480
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v55 offset:21504
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v70, vcc, v54, v82
		v_addc_co_u32_e64 v71, vcc, v55, v83, vcc
		ds_read_addtid_b32 v54 offset:22528
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v55 offset:23552
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v190, vcc, v54, v82
		v_addc_co_u32_e64 v191, vcc, v55, v83, vcc
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(52)
		scratch_load_dword v54, off, s62
		scratch_load_dword v55, off, s62 offset:4
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v192, vcc, v54, v82
		v_addc_co_u32_e64 v193, vcc, v55, v83, vcc
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(50)
		scratch_load_dword v54, off, s62 offset:8
		scratch_load_dword v55, off, s62 offset:12
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v194, vcc, v54, v82
		v_addc_co_u32_e64 v195, vcc, v55, v83, vcc
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(48)
		scratch_load_dword v54, off, s62 offset:16
		scratch_load_dword v55, off, s62 offset:20
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v196, vcc, v54, v82
		v_addc_co_u32_e64 v197, vcc, v55, v83, vcc
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(46)
		scratch_load_dword v54, off, s62 offset:24
		scratch_load_dword v55, off, s62 offset:28
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v198, vcc, v54, v82
		v_addc_co_u32_e64 v199, vcc, v55, v83, vcc
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(44)
		scratch_load_dword v54, off, s62 offset:32
		scratch_load_dword v55, off, s62 offset:36
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v200, vcc, v54, v82
		v_addc_co_u32_e64 v201, vcc, v55, v83, vcc
		v_add_co_u32_e64 v54, vcc, v108, v82
		v_addc_co_u32_e64 v55, vcc, v109, v83, vcc
		v_add_co_u32_e64 v204, vcc, v84, v82
		v_addc_co_u32_e64 v205, vcc, v85, v83, vcc
		v_add_co_u32_e64 v82, vcc, v86, v202
		v_addc_co_u32_e64 v83, vcc, v87, v203, vcc
		v_add_co_u32_e64 v206, vcc, v74, v202
		v_addc_co_u32_e64 v207, vcc, v75, v203, vcc
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[24:27], a[220:223], v[12:15], v48, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v17
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 a[248:251], v2 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[24:27], a[224:227], v[92:95], v48, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v17
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 a[252:255], v2 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[24:27], a[228:231], v[132:135], v48, v51 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v17
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[208:211], v2 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[24:27], a[232:235], v[136:139], v48, v51 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v17
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[212:215], v2 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[24:27], a[236:239], v[140:143], v48, v52 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v17
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[216:219], v2 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], a[240:243], v[144:147], v48, v52 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v17
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[220:223], v2 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[20:23], v[148:151], v48, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v17
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[224:227], v2 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], a[244:247], v[152:155], v48, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v17
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[24:27], v2 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[28:31], a[220:223], v[156:159], v48, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v18
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[228:231], v2 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[28:31], a[224:227], v[160:163], v48, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v18
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[232:235], v2 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[28:31], a[228:231], v[164:167], v48, v51 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v18
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[236:239], v2 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[28:31], a[232:235], v[168:171], v48, v51 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v18
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[240:243], v2 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[28:31], a[236:239], v[172:175], v48, v52 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v18
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[244:247], v2 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], a[240:243], v[176:179], v48, v52 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v18
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[248:251], v2 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[20:23], v[180:183], v48, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v18
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[252:255], v2 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[28:31], a[244:247], a[16:19], v48, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v18
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[28:31], v2 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[32:35], a[220:223], a[20:23], v49, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s30, 0x6000
		s_nop 0
		buffer_load_dwordx4 v56, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[32:35], a[224:227], a[24:27], v49, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s31, 0x6000
		s_nop 0
		buffer_load_dwordx4 v58, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[32:35], a[228:231], a[28:31], v49, v51 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s32, 0x6000
		s_nop 0
		buffer_load_dwordx4 v60, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[32:35], a[232:235], a[32:35], v49, v51 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s33, 0x6000
		s_nop 0
		buffer_load_dwordx4 v62, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[32:35], a[236:239], a[36:39], v49, v52 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s34, 0x6000
		s_nop 0
		buffer_load_dwordx4 v64, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[32:35], a[240:243], a[40:43], v49, v52 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s35, 0x6000
		s_nop 0
		buffer_load_dwordx4 v66, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[32:35], v[20:23], a[44:47], v49, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s36, 0x6000
		s_nop 0
		buffer_load_dwordx4 v68, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[32:35], a[244:247], a[48:51], v49, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s37, 0x6000
		s_nop 0
		buffer_load_dwordx4 v70, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[36:39], a[220:223], a[52:55], v49, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s38, 0x6000
		s_nop 0
		buffer_load_dwordx4 v190, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[36:39], a[224:227], a[56:59], v49, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s39, 0x6000
		s_nop 0
		buffer_load_dwordx4 v192, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[36:39], a[228:231], a[60:63], v49, v51 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s40, 0x6000
		s_nop 0
		buffer_load_dwordx4 v194, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[36:39], a[232:235], a[64:67], v49, v51 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s42, 0x6000
		s_nop 0
		buffer_load_dwordx4 v196, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[36:39], a[236:239], a[68:71], v49, v52 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s43, 0x6000
		s_nop 0
		buffer_load_dwordx4 v198, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[36:39], a[240:243], a[72:75], v49, v52 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s44, 0x6000
		s_nop 0
		buffer_load_dwordx4 v200, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[36:39], v[20:23], a[76:79], v49, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s45, 0x6000
		s_nop 0
		buffer_load_dwordx4 v54, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[36:39], a[244:247], a[80:83], v49, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s46, 0x6000
		s_nop 0
		buffer_load_dwordx4 v204, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[40:43], a[220:223], a[84:87], v50, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s10, 0x26000
		s_nop 0
		buffer_load_dwordx4 v82, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[40:43], a[224:227], a[88:91], v50, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s61, s61, 2
		s_add_i32 m0, s9, 0x26000
		s_nop 0
		buffer_load_dwordx4 v206, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[40:43], a[228:231], a[92:95], v50, v51 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[40:43], a[232:235], a[96:99], v50, v51 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[44:47], a[232:235], a[128:131], v50, v51 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[44:47], a[228:231], a[124:127], v50, v51 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[44:47], a[220:223], a[116:119], v50, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[44:47], a[224:227], a[120:123], v50, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[44:47], a[236:239], a[132:135], v50, v52 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[40:43], a[236:239], a[100:103], v50, v52 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[40:43], a[240:243], a[104:107], v50, v52 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[44:47], a[240:243], a[136:139], v50, v52 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[44:47], v[20:23], a[140:143], v50, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[40:43], v[20:23], a[108:111], v50, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[40:43], a[244:247], a[112:115], v50, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[44:47], a[244:247], a[144:147], v50, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[212:215], a[244:247], a[176:179], v19, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[212:215], v[20:23], a[172:175], v19, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[216:219], v[20:23], a[204:207], v19, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[216:219], a[244:247], a[208:211], v19, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[216:219], a[220:223], a[180:183], v19, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[212:215], a[220:223], a[148:151], v19, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[212:215], a[224:227], a[152:155], v19, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[216:219], a[224:227], a[184:187], v19, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[216:219], a[228:231], a[188:191], v19, v51 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[212:215], a[228:231], a[156:159], v19, v51 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[212:215], a[232:235], a[160:163], v19, v51 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[216:219], a[232:235], a[192:195], v19, v51 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[216:219], a[236:239], a[196:199], v19, v52 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[212:215], a[236:239], a[164:167], v19, v52 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[212:215], a[240:243], a[168:171], v19, v52 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[216:219], a[240:243], a[200:203], v19, v52 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		s_waitcnt lgkmcnt(7)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], a[248:251], v[228:231], v[12:15], v48, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[248:251], v[232:235], v[92:95], v48, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[252:255], v[232:235], v[160:163], v48, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[252:255], v[228:231], v[156:159], v48, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[252:255], v[236:239], v[164:167], v48, v51 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[248:251], v[236:239], v[132:135], v48, v51 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[248:251], v[240:243], v[136:139], v48, v51 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[252:255], v[240:243], v[168:171], v48, v51 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[252:255], v[244:247], v[172:175], v48, v52 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[248:251], v[244:247], v[140:143], v48, v52 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[248:251], v[248:251], v[144:147], v48, v52 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[252:255], v[248:251], v[176:179], v48, v52 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[252:255], v[252:255], v[180:183], v48, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[248:251], v[252:255], v[148:151], v48, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[248:251], v[28:31], v[152:155], v48, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[252:255], v[28:31], a[16:19], v48, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[208:211], v[28:31], a[48:51], v49, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[208:211], v[252:255], a[44:47], v49, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[212:215], v[252:255], a[76:79], v49, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[212:215], v[28:31], a[80:83], v49, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[212:215], v[228:231], a[52:55], v49, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[208:211], v[228:231], a[20:23], v49, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[208:211], v[232:235], a[24:27], v49, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[212:215], v[232:235], a[56:59], v49, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[212:215], v[236:239], a[60:63], v49, v51 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[208:211], v[236:239], a[28:31], v49, v51 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[208:211], v[240:243], a[32:35], v49, v51 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[212:215], v[240:243], a[64:67], v49, v51 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[212:215], v[244:247], a[68:71], v49, v52 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[208:211], v[244:247], a[36:39], v49, v52 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[208:211], v[248:251], a[40:43], v49, v52 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[212:215], v[248:251], a[72:75], v49, v52 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[216:219], v[248:251], a[104:107], v50, v52 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[216:219], v[244:247], a[100:103], v50, v52 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[220:223], v[244:247], a[132:135], v50, v52 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[220:223], v[248:251], a[136:139], v50, v52 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[220:223], v[228:231], a[116:119], v50, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[216:219], v[228:231], a[84:87], v50, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[216:219], v[232:235], a[88:91], v50, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[220:223], v[232:235], a[120:123], v50, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[220:223], v[236:239], a[124:127], v50, v51 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[216:219], v[236:239], a[92:95], v50, v51 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[216:219], v[240:243], a[96:99], v50, v51 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[220:223], v[240:243], a[128:131], v50, v51 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[220:223], v[252:255], a[140:143], v50, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[216:219], v[252:255], a[108:111], v50, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[216:219], v[28:31], a[112:115], v50, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[220:223], v[28:31], a[144:147], v50, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[224:227], v[28:31], a[176:179], v19, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[224:227], v[252:255], a[172:175], v19, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[24:27], v[252:255], a[204:207], v19, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[24:27], v[28:31], a[208:211], v19, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[24:27], v[228:231], a[180:183], v19, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[224:227], v[228:231], a[148:151], v19, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[224:227], v[232:235], a[152:155], v19, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[24:27], v[232:235], a[184:187], v19, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[24:27], v[236:239], a[188:191], v19, v51 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[224:227], v[236:239], a[156:159], v19, v51 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[224:227], v[240:243], a[160:163], v19, v51 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[24:27], v[240:243], a[192:195], v19, v51 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[24:27], v[244:247], a[196:199], v19, v52 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[224:227], v[244:247], a[164:167], v19, v52 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[224:227], v[248:251], a[168:171], v19, v52 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[24:27], v[248:251], a[200:203], v19, v52 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(40)
		scratch_load_dword v24, off, s62 offset:40
		scratch_load_dword v25, off, s62 offset:44
		scratch_load_dword v26, off, s62 offset:48
		scratch_load_dword v27, off, s62 offset:52
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v20, v24
		v_mov_b32_e32 v21, v25
		v_mov_b32_e32 v22, v26
		v_mov_b32_e32 v23, v27
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(36)
		scratch_load_dword v28, off, s62 offset:56
		scratch_load_dword v29, off, s62 offset:60
		scratch_load_dword v30, off, s62 offset:64
		scratch_load_dword v31, off, s62 offset:68
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v24, v28
		v_mov_b32_e32 v25, v29
		v_mov_b32_e32 v26, v30
		v_mov_b32_e32 v27, v31
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(32)
		scratch_load_dword v32, off, s62 offset:72
		scratch_load_dword v33, off, s62 offset:76
		scratch_load_dword v34, off, s62 offset:80
		scratch_load_dword v35, off, s62 offset:84
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v28, v32
		v_mov_b32_e32 v29, v33
		v_mov_b32_e32 v30, v34
		v_mov_b32_e32 v31, v35
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(28)
		scratch_load_dword v36, off, s62 offset:88
		scratch_load_dword v37, off, s62 offset:92
		scratch_load_dword v38, off, s62 offset:96
		scratch_load_dword v39, off, s62 offset:100
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v32, v36
		v_mov_b32_e32 v33, v37
		v_mov_b32_e32 v34, v38
		v_mov_b32_e32 v35, v39
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v40, off, s62 offset:104
		scratch_load_dword v41, off, s62 offset:108
		scratch_load_dword v42, off, s62 offset:112
		scratch_load_dword v43, off, s62 offset:116
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v36, v40
		v_mov_b32_e32 v37, v41
		v_mov_b32_e32 v38, v42
		v_mov_b32_e32 v39, v43
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(20)
		scratch_load_dword v44, off, s62 offset:120
		scratch_load_dword v45, off, s62 offset:124
		scratch_load_dword v46, off, s62 offset:128
		scratch_load_dword v47, off, s62 offset:132
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v40, v44
		v_mov_b32_e32 v41, v45
		v_mov_b32_e32 v42, v46
		v_mov_b32_e32 v43, v47
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v48, off, s62 offset:136
		scratch_load_dword v49, off, s62 offset:140
		scratch_load_dword v50, off, s62 offset:144
		scratch_load_dword v51, off, s62 offset:148
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v44, v48
		v_mov_b32_e32 v45, v49
		v_mov_b32_e32 v46, v50
		v_mov_b32_e32 v47, v51
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(12)
		scratch_load_dword v52, off, s62 offset:152
		scratch_load_dword v53, off, s62 offset:156
		scratch_load_dword v54, off, s62 offset:160
		scratch_load_dword v55, off, s62 offset:164
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v48, v52
		v_mov_b32_e32 v49, v53
		v_mov_b32_e32 v50, v54
		v_mov_b32_e32 v51, v55
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v56, off, s62 offset:168
		scratch_load_dword v57, off, s62 offset:172
		scratch_load_dword v58, off, s62 offset:176
		scratch_load_dword v59, off, s62 offset:180
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v52, v56
		v_mov_b32_e32 v53, v57
		v_mov_b32_e32 v54, v58
		v_mov_b32_e32 v55, v59
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v60, off, s62 offset:184
		scratch_load_dword v61, off, s62 offset:188
		scratch_load_dword v62, off, s62 offset:192
		scratch_load_dword v63, off, s62 offset:196
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v56, v60
		v_mov_b32_e32 v57, v61
		v_mov_b32_e32 v58, v62
		v_mov_b32_e32 v59, v63
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v64, off, s62 offset:200
		scratch_load_dword v65, off, s62 offset:204
		scratch_load_dword v66, off, s62 offset:208
		scratch_load_dword v67, off, s62 offset:212
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v60, v64
		v_mov_b32_e32 v61, v65
		v_mov_b32_e32 v62, v66
		v_mov_b32_e32 v63, v67
		v_mov_b32_e32 v64, v184
		v_mov_b32_e32 v65, v185
		v_mov_b32_e32 v66, v186
		v_mov_b32_e32 v67, v187
		v_mov_b32_e32 v19, v73
		v_mov_b32_e32 v68, v114
		v_mov_b32_e32 v69, v115
		v_mov_b32_e32 v18, v116
		v_mov_b32_e32 v70, v117
		v_mov_b32_e32 v71, v130
		v_mov_b32_e32 v72, v131
		v_mov_b32_e32 v17, v188
		s_cmp_lt_i32 s61, s8
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_add_i32 s0, s12, -1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], a[0:3], v[36:39], v[12:15], v19, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s0, s0, 1
		s_lshl_b32 s0, s0, 16
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v1, 13, v1
		s_mov_b32 m0, s15
		v_add_u32_e32 v2, s0, v1
		ds_read_addtid_b32 v3
		s_waitcnt lgkmcnt(0)
		v_lshlrev_b32_e32 v3, 4, v3
		v_and_b32_e32 v4, 15, v0
		v_lshlrev_b32_e32 v4, 6, v4
		v_add3_u32 v2, v2, v4, v3
		v_add_u32_e32 v5, 0x400, v2
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[8:11], v5 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], a[0:3], v[40:43], v[92:95], v19, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x400, v2
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[76:79], v5 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[0:3], v[44:47], v[132:135], v19, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x400, v2
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[80:83], v5 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[0:3], v[48:51], v[136:139], v19, v71 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x400, v2
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[84:87], v5 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[0:3], v[52:55], v[140:143], v19, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x400, v2
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[88:91], v5 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[0:3], v[56:59], v[144:147], v19, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x400, v2
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[96:99], v5 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[0:3], v[60:63], v[148:151], v19, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x400, v2
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[100:103], v5 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[0:3], v[64:67], v[152:155], v19, v17 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[104:107], v2 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[4:7], v[36:39], v[156:159], v19, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		v_add_u32_e32 v2, s0, v4
		ds_read_addtid_b32 v5 offset:1024
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v2, v2, v5, v3
		v_add_u32_e32 v5, 0x400, v2
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[108:111], v5 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[4:7], v[40:43], v[160:163], v19, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x400, v2
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[112:115], v5 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[4:7], v[44:47], v[164:167], v19, v71 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x400, v2
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[116:119], v5 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[4:7], v[48:51], v[168:171], v19, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x400, v2
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[120:123], v5 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[4:7], v[52:55], v[172:175], v19, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x400, v2
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[124:127], v5 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[4:7], v[56:59], v[176:179], v19, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x400, v2
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[128:131], v5 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[4:7], v[60:63], v[180:183], v19, v17 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x400, v2
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x400, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[184:187], v5 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[4:7], v[64:67], a[16:19], v19, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[188:191], v2 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[8:11], v[36:39], a[20:23], v68, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[8:11], v[40:43], a[24:27], v68, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[12:15], v[40:43], a[56:59], v68, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[12:15], v[36:39], a[52:55], v68, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[12:15], v[44:47], a[60:63], v68, v71 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[8:11], v[44:47], a[28:31], v68, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[8:11], v[48:51], a[32:35], v68, v71 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[12:15], v[48:51], a[64:67], v68, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[12:15], v[52:55], a[68:71], v68, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[8:11], v[52:55], a[36:39], v68, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[8:11], v[56:59], a[40:43], v68, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[12:15], v[56:59], a[72:75], v68, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[12:15], v[60:63], a[76:79], v68, v17 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[8:11], v[60:63], a[44:47], v68, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[8:11], v[64:67], a[48:51], v68, v17 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[12:15], v[64:67], a[80:83], v68, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[20:23], v[64:67], a[112:115], v69, v17 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[20:23], v[60:63], a[108:111], v69, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[24:27], v[60:63], a[140:143], v69, v17 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[24:27], v[64:67], a[144:147], v69, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[24:27], v[36:39], a[116:119], v69, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[20:23], v[36:39], a[84:87], v69, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[20:23], v[40:43], a[88:91], v69, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[24:27], v[40:43], a[120:123], v69, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[24:27], v[44:47], a[124:127], v69, v71 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[20:23], v[44:47], a[92:95], v69, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[20:23], v[48:51], a[96:99], v69, v71 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[24:27], v[48:51], a[128:131], v69, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[24:27], v[52:55], a[132:135], v69, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[20:23], v[52:55], a[100:103], v69, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[20:23], v[56:59], a[104:107], v69, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[24:27], v[56:59], a[136:139], v69, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[28:31], v[56:59], a[168:171], v18, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[28:31], v[52:55], a[164:167], v18, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[32:35], v[52:55], a[196:199], v18, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[32:35], v[56:59], a[200:203], v18, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[32:35], v[36:39], a[180:183], v18, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[28:31], v[36:39], a[148:151], v18, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[28:31], v[40:43], a[152:155], v18, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[32:35], v[40:43], a[184:187], v18, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[32:35], v[44:47], a[188:191], v18, v71 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[28:31], v[44:47], a[156:159], v18, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[28:31], v[48:51], a[160:163], v18, v71 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[32:35], v[48:51], a[192:195], v18, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[32:35], v[60:63], a[204:207], v18, v17 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[28:31], v[60:63], a[172:175], v18, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[28:31], v[64:67], a[176:179], v18, v17 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[32:35], v[64:67], a[208:211], v18, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[100:103], v[184:187], a[172:175], v18, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[100:103], v[188:191], a[176:179], v18, v17 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[104:107], v[188:191], a[208:211], v18, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[104:107], v[184:187], a[204:207], v18, v17 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[8:11], v[184:187], v[148:151], v19, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[8:11], v[188:191], v[152:155], v19, v17 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[76:79], v[188:191], a[16:19], v19, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[76:79], v[184:187], v[180:183], v19, v17 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[76:79], v[108:111], v[156:159], v19, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[8:11], v[108:111], v[12:15], v19, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[8:11], v[112:115], v[92:95], v19, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[76:79], v[112:115], v[160:163], v19, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[76:79], v[116:119], v[164:167], v19, v71 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[8:11], v[116:119], v[132:135], v19, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[8:11], v[120:123], v[136:139], v19, v71 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[76:79], v[120:123], v[168:171], v19, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[76:79], v[124:127], v[172:175], v19, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[8:11], v[124:127], v[140:143], v19, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[8:11], v[128:131], v[144:147], v19, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[76:79], v[128:131], v[176:179], v19, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[80:83], v[128:131], a[40:43], v68, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[80:83], v[124:127], a[36:39], v68, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[84:87], v[124:127], a[68:71], v68, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[84:87], v[128:131], a[72:75], v68, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[84:87], v[108:111], a[52:55], v68, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[80:83], v[108:111], a[20:23], v68, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[80:83], v[112:115], a[24:27], v68, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[84:87], v[112:115], a[56:59], v68, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[84:87], v[116:119], a[60:63], v68, v71 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[80:83], v[116:119], a[28:31], v68, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[80:83], v[120:123], a[32:35], v68, v71 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[84:87], v[120:123], a[64:67], v68, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[84:87], v[184:187], a[76:79], v68, v17 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[80:83], v[184:187], a[44:47], v68, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[80:83], v[188:191], a[48:51], v68, v17 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[84:87], v[188:191], a[80:83], v68, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[88:91], v[188:191], a[112:115], v69, v17 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[88:91], v[184:187], a[108:111], v69, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[96:99], v[184:187], a[140:143], v69, v17 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[96:99], v[188:191], a[144:147], v69, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[96:99], v[108:111], a[116:119], v69, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[88:91], v[108:111], a[84:87], v69, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[88:91], v[112:115], a[88:91], v69, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[96:99], v[112:115], a[120:123], v69, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[96:99], v[116:119], a[124:127], v69, v71 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[88:91], v[116:119], a[92:95], v69, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[88:91], v[120:123], a[96:99], v69, v71 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[96:99], v[120:123], a[128:131], v69, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[96:99], v[124:127], a[132:135], v69, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[88:91], v[124:127], a[100:103], v69, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[88:91], v[128:131], a[104:107], v69, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[96:99], v[128:131], a[136:139], v69, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[100:103], v[128:131], a[168:171], v18, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[100:103], v[124:127], a[164:167], v18, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[104:107], v[124:127], a[196:199], v18, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[104:107], v[128:131], a[200:203], v18, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[104:107], v[108:111], a[180:183], v18, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[100:103], v[108:111], a[148:151], v18, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[100:103], v[112:115], a[152:155], v18, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[104:107], v[112:115], a[184:187], v18, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[104:107], v[116:119], a[188:191], v18, v71 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[100:103], v[116:119], a[156:159], v18, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[100:103], v[120:123], a[160:163], v18, v71 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[104:107], v[120:123], a[192:195], v18, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s0, s12, 1
		s_lshl_b32 s1, s0, 16
		v_add_u32_e32 v1, s1, v1
		v_add3_u32 v1, v1, v4, v3
		v_add_u32_e32 v2, 0x400, v1
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[8:11], v2
		v_add_u32_e32 v2, 0x400, v1
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[16:19], v2 offset:1024
		v_add_u32_e32 v2, 0x400, v1
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[20:23], v2 offset:2048
		v_add_u32_e32 v2, 0x400, v1
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[24:27], v2 offset:3072
		v_add_u32_e32 v2, 0x400, v1
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[28:31], v2 offset:4096
		v_add_u32_e32 v2, 0x400, v1
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[32:35], v2 offset:5120
		v_add_u32_e32 v2, 0x400, v1
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[36:39], v2 offset:6144
		v_add_u32_e32 v2, 0x400, v1
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[40:43], v2 offset:7168
		s_mov_b32 m0, s15
		v_add_u32_e32 v2, s1, v4
		ds_read_addtid_b32 v4 offset:1024
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v2, v2, v4, v3
		v_add_u32_e32 v3, 0x400, v2
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		ds_read_b128 v[4:7], v3 offset:32768
		v_add_u32_e32 v3, 0x400, v2
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		ds_read_b128 v[44:47], v3 offset:33792
		v_add_u32_e32 v3, 0x400, v2
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		ds_read_b128 v[48:51], v3 offset:34816
		v_add_u32_e32 v3, 0x400, v2
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		ds_read_b128 v[52:55], v3 offset:35840
		v_add_u32_e32 v3, 0x400, v2
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		ds_read_b128 v[56:59], v3 offset:36864
		v_add_u32_e32 v3, 0x400, v2
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		ds_read_b128 v[60:63], v3 offset:37888
		v_add_u32_e32 v3, 0x400, v2
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		ds_read_b128 v[64:67], v3 offset:38912
		v_add_u32_e32 v3, 0x400, v2
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		ds_read_b128 v[68:71], v3 offset:39936
		s_lshl_b32 s0, s0, 12
		s_add_i32 s0, s0, 0x20000
		v_lshrrev_b32_e32 v3, 7, v0
		v_lshlrev_b32_e32 v3, 10, v3
		v_and_b32_e32 v72, 63, v0
		v_lshlrev_b32_e32 v72, 2, v72
		v_add3_u32 v3, s0, v3, v72
		v_add_u32_e32 v73, 0x400, v3
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		ds_read_b32 v74, v73
		v_add_u32_e32 v73, 0x400, v3
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		ds_read_b32 v75, v73 offset:256
		v_add_u32_e32 v73, 0x400, v3
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		ds_read_b32 v76, v73 offset:512
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		ds_read_b32 v73, v3 offset:768
		v_lshrrev_b32_e32 v3, 6, v0
		v_and_b32_e32 v3, 1, v3
		v_lshlrev_b32_e32 v3, 10, v3
		v_add3_u32 v3, s0, v72, v3
		v_add_u32_e32 v72, 0x400, v3
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		ds_read_b32 v77, v72 offset:2048
		v_add_u32_e32 v72, 0x400, v3
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		ds_read_b32 v78, v72 offset:2304
		v_add_u32_e32 v72, 0x400, v3
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		ds_read_b32 v79, v72 offset:2560
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		ds_read_b32 v72, v3 offset:2816
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[8:11], v[4:7], v[12:15], v74, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x400, v1
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		ds_read_b128 v[80:83], v3 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[8:11], v[44:47], v[92:95], v74, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x400, v1
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		ds_read_b128 v[84:87], v3 offset:17408
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[8:11], v[48:51], v[132:135], v74, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x400, v1
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		ds_read_b128 v[88:91], v3 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[8:11], v[52:55], v[136:139], v74, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x400, v1
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		ds_read_b128 v[96:99], v3 offset:19456
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[8:11], v[56:59], v[140:143], v74, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x400, v1
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		ds_read_b128 v[100:103], v3 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[8:11], v[60:63], v[144:147], v74, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x400, v1
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		ds_read_b128 v[104:107], v3 offset:21504
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[8:11], v[64:67], v[148:151], v74, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x400, v1
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		ds_read_b128 v[108:111], v3 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[8:11], v[68:71], v[152:155], v74, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		ds_read_b128 v[8:11], v1 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[16:19], v[4:7], v[156:159], v74, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x400, v2
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		ds_read_b128 v[112:115], v1 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[16:19], v[44:47], v[160:163], v74, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x400, v2
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		ds_read_b128 v[116:119], v1 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[16:19], v[48:51], v[164:167], v74, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x400, v2
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		ds_read_b128 v[120:123], v1 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[16:19], v[52:55], v[168:171], v74, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x400, v2
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		ds_read_b128 v[124:127], v1 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[16:19], v[56:59], v[172:175], v74, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x400, v2
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		ds_read_b128 v[128:131], v1 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[16:19], v[60:63], v[176:179], v74, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x400, v2
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		ds_read_b128 v[184:187], v1 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[16:19], v[64:67], v[180:183], v74, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x400, v2
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		ds_read_b128 v[188:191], v1 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[16:19], v[68:71], a[16:19], v74, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x400, v2
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
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
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[80:83], v[188:191], v[148:151], v74, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[80:83], v[16:19], v[152:155], v74, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[84:87], v[16:19], a[16:19], v74, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[84:87], v[188:191], v[180:183], v74, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[84:87], v[112:115], v[156:159], v74, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[80:83], v[112:115], v[12:15], v74, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[80:83], v[116:119], v[92:95], v74, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[84:87], v[116:119], v[160:163], v74, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[84:87], v[120:123], v[164:167], v74, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[80:83], v[120:123], v[132:135], v74, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[80:83], v[124:127], v[136:139], v74, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[84:87], v[124:127], v[168:171], v74, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[84:87], v[128:131], v[172:175], v74, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[80:83], v[128:131], v[140:143], v74, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[80:83], v[184:187], v[144:147], v74, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[84:87], v[184:187], v[176:179], v74, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[88:91], v[184:187], a[40:43], v75, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[88:91], v[128:131], a[36:39], v75, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[96:99], v[128:131], a[68:71], v75, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[96:99], v[184:187], a[72:75], v75, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[96:99], v[112:115], a[52:55], v75, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[88:91], v[112:115], a[20:23], v75, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[88:91], v[116:119], a[24:27], v75, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[96:99], v[116:119], a[56:59], v75, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[96:99], v[120:123], a[60:63], v75, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[88:91], v[120:123], a[28:31], v75, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[88:91], v[124:127], a[32:35], v75, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[96:99], v[124:127], a[64:67], v75, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[96:99], v[188:191], a[76:79], v75, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[88:91], v[188:191], a[44:47], v75, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[88:91], v[16:19], a[48:51], v75, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[96:99], v[16:19], a[80:83], v75, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[100:103], v[16:19], a[112:115], v76, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[100:103], v[188:191], a[108:111], v76, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[104:107], v[188:191], a[140:143], v76, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[104:107], v[16:19], a[144:147], v76, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[104:107], v[112:115], a[116:119], v76, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[100:103], v[112:115], a[84:87], v76, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[100:103], v[116:119], a[88:91], v76, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[104:107], v[116:119], a[120:123], v76, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[104:107], v[120:123], a[124:127], v76, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[100:103], v[120:123], a[92:95], v76, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[100:103], v[124:127], a[96:99], v76, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[104:107], v[124:127], a[128:131], v76, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[104:107], v[128:131], a[132:135], v76, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[100:103], v[128:131], a[100:103], v76, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[100:103], v[184:187], a[104:107], v76, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[104:107], v[184:187], a[136:139], v76, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[108:111], v[184:187], a[168:171], v73, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[108:111], v[128:131], a[164:167], v73, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[8:11], v[128:131], a[196:199], v73, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[8:11], v[184:187], a[200:203], v73, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[8:11], v[112:115], a[180:183], v73, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[108:111], v[112:115], a[148:151], v73, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[108:111], v[116:119], a[152:155], v73, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[8:11], v[116:119], a[184:187], v73, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[8:11], v[120:123], a[188:191], v73, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[108:111], v[120:123], a[156:159], v73, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[108:111], v[124:127], a[160:163], v73, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[8:11], v[124:127], a[192:195], v73, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v12, v13
		v_cvt_pk_f16_f32 v3, v14, v15
		v_and_b32_e32 v1, 63, v0
		v_lshlrev_b32_e32 v1, 3, v1
		v_lshrrev_b32_e32 v0, 6, v0
		v_lshl_add_u32 v0, v0, 15, v1
		s_lshl_b32 s0, s13, 21
		s_lshl_b32 s1, s14, 17
		s_add_i32 s2, s0, s1
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen
		v_cvt_pk_f16_f32 v2, v92, v93
		v_cvt_pk_f16_f32 v3, v94, v95
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:512
		v_cvt_pk_f16_f32 v2, v132, v133
		v_cvt_pk_f16_f32 v3, v134, v135
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:1024
		v_cvt_pk_f16_f32 v2, v136, v137
		v_cvt_pk_f16_f32 v3, v138, v139
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:1536
		v_cvt_pk_f16_f32 v2, v140, v141
		v_cvt_pk_f16_f32 v3, v142, v143
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:2048
		v_cvt_pk_f16_f32 v2, v144, v145
		v_cvt_pk_f16_f32 v3, v146, v147
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:2560
		v_cvt_pk_f16_f32 v2, v148, v149
		v_cvt_pk_f16_f32 v3, v150, v151
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:3072
		v_cvt_pk_f16_f32 v2, v152, v153
		v_cvt_pk_f16_f32 v3, v154, v155
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:3584
		v_cvt_pk_f16_f32 v2, v156, v157
		v_cvt_pk_f16_f32 v3, v158, v159
		s_add_i32 s2, s0, 0x1000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen
		v_cvt_pk_f16_f32 v2, v160, v161
		v_cvt_pk_f16_f32 v3, v162, v163
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:512
		v_cvt_pk_f16_f32 v2, v164, v165
		v_cvt_pk_f16_f32 v3, v166, v167
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:1024
		v_cvt_pk_f16_f32 v2, v168, v169
		v_cvt_pk_f16_f32 v3, v170, v171
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:1536
		v_cvt_pk_f16_f32 v2, v172, v173
		v_cvt_pk_f16_f32 v3, v174, v175
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:2048
		v_cvt_pk_f16_f32 v2, v176, v177
		v_cvt_pk_f16_f32 v3, v178, v179
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:2560
		v_cvt_pk_f16_f32 v2, v180, v181
		v_cvt_pk_f16_f32 v3, v182, v183
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
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 24576
		.amdhsa_private_segment_fixed_size 216
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
		.amdhsa_next_free_sgpr 65
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
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 65
	.set .Lwmma_f16_matmul_tiled.num_named_barrier, 0
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 216
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
    .private_segment_fixed_size: 216
    .sgpr_count:     65
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     512
    .agpr_count:     256
    .vgpr_spill_count: 54
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 116
    wave.regalloc.agpr.dwords: 300
    wave.regalloc.remat.dwords: 15
    wave.regalloc.sgpr_to_vgpr.dwords: 0
    wave.regalloc.lds.dwords: 24
    wave.regalloc.scratch.dwords: 54
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
