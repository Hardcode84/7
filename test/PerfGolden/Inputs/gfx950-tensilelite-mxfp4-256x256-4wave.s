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
		v_mov_b64_e32 v[12:13], 0
		v_mov_b64_e32 v[14:15], 0
		s_add_i32 m0, s40, 0x6000
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add3_u32 v3, v6, v7, s8
		s_add_i32 m0, s40, 0x7000
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add3_u32 v3, v6, v7, s9
		s_add_i32 m0, s40, 0x8000
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add3_u32 v3, v6, v7, s10
		s_add_i32 m0, s40, 0x9000
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add3_u32 v3, v6, v8, s11
		s_add_i32 m0, s40, 0xa000
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add3_u32 v3, v6, v8, s16
		s_add_i32 m0, s40, 0xb000
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add3_u32 v3, v6, v8, s17
		s_add_i32 m0, s40, 0xc000
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add3_u32 v3, v6, v9, s19
		s_add_i32 m0, s40, 0xd000
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add3_u32 v3, v6, v9, s32
		s_add_i32 m0, s40, 0xe000
		s_nop 0
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		v_add3_u32 v3, v6, v9, s33
		s_add_i32 m0, s40, 0xf000
		s_nop 0
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		v_add_u32_e32 v3, s34, v10
		s_add_i32 m0, s40, 0x10000
		s_nop 0
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		v_add_u32_e32 v3, s35, v10
		s_add_i32 m0, s40, 0x11000
		s_nop 0
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		v_add3_u32 v3, v10, s32, 64
		s_add_i32 m0, s40, 0x12000
		s_nop 0
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		v_add3_u32 v3, v6, v11, s36
		s_add_i32 m0, s40, 0x13000
		s_nop 0
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		v_add3_u32 v3, v6, v11, s37
		s_add_i32 m0, s40, 0x14000
		s_nop 0
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		v_add3_u32 v3, v6, v11, s38
		s_add_i32 m0, s40, 0x15000
		s_nop 0
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		s_lshl_b32 s8, s14, 16
		s_add_i32 s9, s5, s8
		v_lshrrev_b32_e32 v3, 7, v0
		v_lshlrev_b32_e32 v7, 10, v3
		v_lshlrev_b32_e32 v8, 4, v4
		v_add3_u32 v9, s9, v7, v8
		s_lshr_b32 s4, s4, 7
		s_lshl_b32 s10, s4, 10
		v_and_b32_e32 v1, 1, v1
		s_mov_b32 m0, s15
		v_lshlrev_b32_e32 v10, 10, v1
		ds_write_addtid_b32 v10 offset:1024
		v_add3_u32 v11, s9, v8, v10
		s_and_b32 s4, s39, 1
		s_lshl_b32 s4, s4, 10
		s_add_i32 s9, s40, 0x1000
		s_add_i32 m0, s10, 0x26000
		s_nop 0
		buffer_load_dwordx4 v9, s[24:27], 0 offen lds
		s_add_i32 s11, s40, 0x2000
		s_add_i32 m0, s4, 0x26800
		s_nop 0
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v3, 13, v3
		v_and_b32_e32 v9, 15, v0
		v_lshlrev_b32_e32 v11, 6, v9
		v_lshrrev_b32_e32 v16, 4, v4
		v_lshrrev_b32_e32 v9, 1, v9
		v_bitop3_b32 v9, v16, v9, 3 bitop3:0x78
		v_lshlrev_b32_e32 v9, 4, v9
		v_add3_u32 v16, v3, v11, v9
		v_add_u32_e32 v17, 0x400, v16
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
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		ds_read_b128 a[0:3], v17
		v_add_u32_e32 v17, 0x400, v16
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
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		ds_read_b128 a[4:7], v17 offset:1024
		v_add_u32_e32 v17, 0x400, v16
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
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		ds_read_b128 a[8:11], v17 offset:2048
		v_add_u32_e32 v17, 0x400, v16
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
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		ds_read_b128 a[12:15], v17 offset:3072
		v_add_u32_e32 v17, 0x400, v16
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
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		ds_read_b128 v[20:23], v17 offset:4096
		v_add_u32_e32 v17, 0x400, v16
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
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		ds_read_b128 v[24:27], v17 offset:5120
		v_add_u32_e32 v17, 0x400, v16
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
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		ds_read_b128 v[28:31], v17 offset:6144
		v_add_u32_e32 v16, 0x400, v16
		v_add_u32_e32 v16, 0x400, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x400, v16
		v_add_u32_e32 v16, 0x400, v16
		ds_read_b128 v[32:35], v16 offset:7168
		s_mov_b32 m0, s15
		v_lshlrev_b32_e32 v1, 13, v1
		ds_write_addtid_b32 v1
		v_add3_u32 v16, v11, v1, v9
		v_add_u32_e32 v17, 0x400, v16
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
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		ds_read_b128 v[36:39], v17 offset:32768
		v_add_u32_e32 v17, 0x400, v16
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
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		ds_read_b128 v[40:43], v17 offset:33792
		v_add_u32_e32 v17, 0x400, v16
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
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		ds_read_b128 v[44:47], v17 offset:34816
		v_add_u32_e32 v17, 0x400, v16
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
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		ds_read_b128 v[48:51], v17 offset:35840
		v_add_u32_e32 v17, 0x400, v16
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
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		ds_read_b128 v[52:55], v17 offset:36864
		v_add_u32_e32 v17, 0x400, v16
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
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		ds_read_b128 v[56:59], v17 offset:37888
		v_add_u32_e32 v17, 0x400, v16
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
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		ds_read_b128 v[60:63], v17 offset:38912
		v_add_u32_e32 v16, 0x400, v16
		v_add_u32_e32 v16, 0x400, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x400, v16
		v_add_u32_e32 v16, 0x400, v16
		ds_read_b128 v[64:67], v16 offset:39936
		v_add_u32_e32 v16, 0x20000, v7
		v_lshlrev_b32_e32 v4, 2, v4
		v_add_u32_e32 v16, v16, v4
		v_add_u32_e32 v17, 0x400, v16
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
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		ds_read_b32 v18, v17
		s_mov_b32 m0, s15
		s_waitcnt lgkmcnt(0)
		s_nop 0
		ds_write_addtid_b32 v18 offset:23552
		v_add_u32_e32 v17, 0x400, v16
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
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		ds_read_b32 v18, v17 offset:256
		v_add_u32_e32 v17, 0x400, v16
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
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		ds_read_b32 v19, v17 offset:512
		v_add_u32_e32 v16, 0x400, v16
		v_add_u32_e32 v16, 0x400, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x400, v16
		v_add_u32_e32 v16, 0x400, v16
		ds_read_b32 v17, v16 offset:768
		v_add_u32_e32 v4, 0x20000, v4
		v_add_u32_e32 v4, v4, v10
		v_add_u32_e32 v16, 0x400, v4
		v_add_u32_e32 v16, 0x400, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x400, v16
		v_add_u32_e32 v16, 0x400, v16
		ds_read_b32 v68, v16 offset:2048
		v_add_u32_e32 v16, 0x400, v4
		v_add_u32_e32 v16, 0x400, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x400, v16
		v_add_u32_e32 v16, 0x400, v16
		ds_read_b32 v69, v16 offset:2304
		v_add_u32_e32 v16, 0x400, v4
		v_add_u32_e32 v16, 0x400, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x800, v16
		v_add_u32_e32 v16, 0x400, v16
		v_add_u32_e32 v16, 0x400, v16
		ds_read_b32 v70, v16 offset:2560
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
		v_add_u32_e32 v4, 0x800, v4
		v_add_u32_e32 v4, 0x400, v4
		v_add_u32_e32 v4, 0x400, v4
		ds_read_b32 v16, v4 offset:2816
		s_add_i32 s16, s5, 0x80
		v_add_u32_e32 v4, s16, v2
		v_add3_u32 v4, v4, v5, v6
		s_add_i32 s16, s5, 0x40080
		v_add_u32_e32 v71, v2, v5
		v_add3_u32 v72, v6, v71, s16
		s_add_i32 s16, s5, 0x80080
		v_add3_u32 v73, v6, v71, s16
		s_add_i32 s16, s5, 0xc0080
		v_add3_u32 v71, v6, v71, s16
		s_add_i32 s16, s5, 0xc0
		v_add_u32_e32 v74, v2, v5
		v_add3_u32 v75, v6, v74, s16
		s_add_i32 s16, s5, 0x400c0
		v_add3_u32 v76, v6, v74, s16
		s_add_i32 s16, s5, 0x800c0
		v_add3_u32 v74, v6, v74, s16
		s_add_i32 s16, s5, 0xc00c0
		v_add_u32_e32 v77, v2, v5
		v_add3_u32 v78, v6, v77, s16
		s_add_i32 s16, s32, 0x80
		v_add3_u32 v79, v6, v77, s16
		s_add_i32 s16, s32, 0x40080
		v_add3_u32 v77, v6, v77, s16
		s_add_i32 s16, s32, 0x80080
		v_add_u32_e32 v80, v2, v5
		v_add3_u32 v81, v6, v80, s16
		s_add_i32 s16, s32, 0xc0080
		v_add3_u32 v82, v6, v80, s16
		s_add_i32 s16, s32, 0xc0
		v_add3_u32 v80, v6, v80, s16
		s_add_i32 s16, s32, 0x400c0
		v_add_u32_e32 v2, v2, v5
		v_add3_u32 v5, v6, v2, s16
		s_add_i32 s16, s32, 0x800c0
		s_add_i32 s17, s32, 0xc00c0
		s_add_i32 s19, s40, 0x12000
		s_add_i32 s32, s40, 0x13000
		s_add_i32 s33, s40, 0x14000
		s_add_i32 s34, s40, 0x15000
		s_add_i32 s35, s40, 0x16000
		s_add_i32 s36, s40, 0x17000
		s_add_i32 s37, s40, 0x18000
		s_add_i32 s38, s40, 0x19000
		s_add_i32 s41, s40, 0x1a000
		s_add_i32 s42, s40, 0x1b000
		s_add_i32 s43, s40, 0x1c000
		s_add_i32 s44, s40, 0x1d000
		s_add_i32 s45, s40, 0x1e000
		s_add_i32 s46, s40, 0x1f000
		s_add_i32 s47, s40, 0x3000
		s_add_i32 m0, s40, 0x16000
		s_nop 0
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		s_add_i32 s48, s40, 0x4000
		s_add_i32 m0, s40, 0x17000
		s_nop 0
		buffer_load_dwordx4 v72, s[20:23], 0 offen lds
		s_add_i32 s49, s40, 0x5000
		s_add_i32 m0, s40, 0x18000
		s_nop 0
		buffer_load_dwordx4 v73, s[20:23], 0 offen lds
		s_add_i32 s50, s40, 0x6000
		s_add_i32 m0, s40, 0x19000
		s_nop 0
		buffer_load_dwordx4 v71, s[20:23], 0 offen lds
		s_add_i32 s51, s40, 0x7000
		s_add_i32 m0, s40, 0x1a000
		s_nop 0
		buffer_load_dwordx4 v75, s[20:23], 0 offen lds
		s_add_i32 s52, s40, 0x8000
		s_add_i32 m0, s40, 0x1b000
		s_nop 0
		buffer_load_dwordx4 v76, s[20:23], 0 offen lds
		s_add_i32 s53, s40, 0x9000
		s_add_i32 m0, s40, 0x1c000
		s_nop 0
		buffer_load_dwordx4 v74, s[20:23], 0 offen lds
		s_add_i32 s54, s40, 0xa000
		s_add_i32 m0, s40, 0x1d000
		s_nop 0
		buffer_load_dwordx4 v78, s[20:23], 0 offen lds
		s_add_i32 s55, s40, 0xb000
		s_add_i32 m0, s40, 0x1e000
		s_nop 0
		buffer_load_dwordx4 v79, s[0:3], 0 offen lds
		s_add_i32 s56, s40, 0xc000
		s_add_i32 m0, s40, 0x1f000
		s_nop 0
		buffer_load_dwordx4 v77, s[0:3], 0 offen lds
		s_add_i32 s57, s40, 0xd000
		s_add_i32 m0, s40, 0x20000
		s_nop 0
		buffer_load_dwordx4 v81, s[0:3], 0 offen lds
		s_add_i32 s58, s40, 0xe000
		s_add_i32 m0, s40, 0x21000
		s_nop 0
		buffer_load_dwordx4 v82, s[0:3], 0 offen lds
		s_add_i32 s59, s40, 0xf000
		s_add_i32 m0, s40, 0x22000
		s_nop 0
		buffer_load_dwordx4 v80, s[0:3], 0 offen lds
		s_add_i32 s60, s4, 0x800
		s_add_i32 m0, s40, 0x23000
		s_nop 0
		buffer_load_dwordx4 v5, s[0:3], 0 offen lds
		v_add3_u32 v4, v6, v2, s16
		s_add_i32 m0, s40, 0x24000
		s_nop 0
		buffer_load_dwordx4 v4, s[0:3], 0 offen lds
		v_add3_u32 v2, v6, v2, s17
		s_add_i32 m0, s40, 0x25000
		s_nop 0
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_add_i32 s5, s5, 0x800
		s_add_i32 s5, s5, s8
		v_add3_u32 v2, s5, v7, v8
		s_add_i32 s8, s10, 0x1000
		v_add3_u32 v4, s5, v8, v10
		s_add_i32 s5, s4, 0x1800
		s_add_i32 s16, s40, 0x10000
		s_add_i32 m0, s10, 0x27000
		s_nop 0
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		s_add_i32 s17, s40, 0x11000
		s_add_i32 m0, s4, 0x27800
		s_nop 0
		buffer_load_dwordx4 v4, s[28:31], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s4, s12, 1
		s_mov_b32 s61, 2
		v_mov_b32_e32 v4, s13
		v_mov_b32_e32 v5, 0
		s_mov_b32 s62, 0x100000
		s_mov_b32 s63, 0
		v_mov_b32_e32 v6, s62
		v_mov_b32_e32 v7, s63
		v_mul_lo_u32 v72, v6, v4
		v_mul_hi_u32 v73, v6, v4
		v_mul_lo_u32 v2, v6, v5
		v_add_u32_e32 v73, v73, v2
		v_mul_lo_u32 v2, v7, v4
		v_add_u32_e32 v73, v73, v2
		s_mov_b32 s62, 1
		s_mov_b32 s63, 0
		v_mov_b32_e32 v74, v0
		v_mov_b32_e32 v76, s62
		v_mov_b32_e32 v77, s63
		v_mov_b32_e32 v75, 0
		v_mul_lo_u32 v78, v76, v74
		v_mul_hi_u32 v79, v76, v74
		v_mul_lo_u32 v2, v76, v75
		v_add_u32_e32 v79, v79, v2
		v_mul_lo_u32 v2, v77, v74
		v_add_u32_e32 v79, v79, v2
		v_lshrrev_b64 v[80:81], 6, v[78:79]
		s_mov_b32 s62, 0x10000
		s_mov_b32 s63, 0
		v_mov_b32_e32 v82, s62
		v_mov_b32_e32 v83, s63
		v_mul_lo_u32 v84, v82, v80
		v_mul_hi_u32 v85, v82, v80
		v_mul_lo_u32 v2, v82, v81
		v_add_u32_e32 v85, v85, v2
		v_mul_lo_u32 v2, v83, v80
		v_add_u32_e32 v85, v85, v2
		v_add_co_u32_e64 v86, vcc, v72, v84
		v_addc_co_u32_e64 v87, vcc, v73, v85, vcc
		v_mov_b32_e32 v2, 63
		v_and_b32_e32 v88, v74, v2
		v_and_b32_e32 v89, v5, v5
		v_mul_lo_u32 v74, v76, v88
		v_mul_hi_u32 v75, v76, v88
		v_mul_lo_u32 v2, v76, v89
		v_add_u32_e32 v75, v75, v2
		v_mul_lo_u32 v2, v77, v88
		v_add_u32_e32 v75, v75, v2
		v_lshrrev_b64 v[76:77], 2, v[74:75]
		s_mov_b32 s62, 0x1000
		s_mov_b32 s63, 0
		v_mov_b32_e32 v90, s62
		v_mov_b32_e32 v91, s63
		v_mul_lo_u32 v92, v90, v76
		v_mul_hi_u32 v93, v90, v76
		v_mul_lo_u32 v2, v90, v77
		v_add_u32_e32 v93, v93, v2
		v_mul_lo_u32 v2, v91, v76
		v_add_u32_e32 v93, v93, v2
		v_add_co_u32_e64 v76, vcc, v86, v92
		v_addc_co_u32_e64 v77, vcc, v87, v93, vcc
		v_lshrrev_b64 v[86:87], 3, v[74:75]
		v_mov_b32_e32 v2, 3
		v_and_b32_e32 v74, v86, v2
		v_and_b32_e32 v75, v87, v5
		v_and_b32_e32 v86, v88, v2
		v_and_b32_e32 v87, v89, v5
		v_xor_b32_e32 v74, v74, v86
		v_xor_b32_e32 v75, v75, v87
		s_mov_b32 s62, 16
		s_mov_b32 s63, 0
		v_mov_b32_e32 v86, s62
		v_mov_b32_e32 v87, s63
		v_mul_lo_u32 v90, v86, v74
		v_mul_hi_u32 v91, v86, v74
		v_mul_lo_u32 v2, v86, v75
		v_add_u32_e32 v91, v91, v2
		v_mul_lo_u32 v2, v87, v74
		v_add_u32_e32 v91, v91, v2
		v_add_co_u32_e64 v74, vcc, v76, v90
		v_addc_co_u32_e64 v75, vcc, v77, v91, vcc
		s_mov_b32 s62, 0x80
		s_mov_b32 s63, 0
		v_mov_b32_e32 v76, s62
		v_mov_b32_e32 v77, s63
		v_mov_b32_e32 v2, 0x40000
		v_add_co_u32_e64 v94, vcc, v72, v2
		v_addc_co_u32_e64 v95, vcc, v73, 0, vcc
		v_add_co_u32_e64 v96, vcc, v94, v84
		v_addc_co_u32_e64 v97, vcc, v95, v85, vcc
		v_add_co_u32_e64 v94, vcc, v96, v92
		v_addc_co_u32_e64 v95, vcc, v97, v93, vcc
		v_add_co_u32_e64 v96, vcc, v94, v90
		v_addc_co_u32_e64 v97, vcc, v95, v91, vcc
		v_mov_b32_e32 v4, 0x80000
		v_add_co_u32_e64 v94, vcc, v72, v4
		v_addc_co_u32_e64 v95, vcc, v73, 0, vcc
		v_add_co_u32_e64 v98, vcc, v94, v84
		v_addc_co_u32_e64 v99, vcc, v95, v85, vcc
		v_add_co_u32_e64 v94, vcc, v98, v92
		v_addc_co_u32_e64 v95, vcc, v99, v93, vcc
		v_add_co_u32_e64 v98, vcc, v94, v90
		v_addc_co_u32_e64 v99, vcc, v95, v91, vcc
		v_mov_b32_e32 v8, 0xc0000
		v_add_co_u32_e64 v94, vcc, v72, v8
		v_addc_co_u32_e64 v95, vcc, v73, 0, vcc
		v_add_co_u32_e64 v100, vcc, v94, v84
		v_addc_co_u32_e64 v101, vcc, v95, v85, vcc
		v_add_co_u32_e64 v94, vcc, v100, v92
		v_addc_co_u32_e64 v95, vcc, v101, v93, vcc
		v_add_co_u32_e64 v100, vcc, v94, v90
		v_addc_co_u32_e64 v101, vcc, v95, v91, vcc
		v_mov_b32_e32 v10, 64
		v_add_co_u32_e64 v94, vcc, v72, v10
		v_addc_co_u32_e64 v95, vcc, v73, 0, vcc
		v_add_co_u32_e64 v102, vcc, v94, v84
		v_addc_co_u32_e64 v103, vcc, v95, v85, vcc
		v_add_co_u32_e64 v94, vcc, v102, v92
		v_addc_co_u32_e64 v95, vcc, v103, v93, vcc
		v_add_co_u32_e64 v102, vcc, v94, v90
		v_addc_co_u32_e64 v103, vcc, v95, v91, vcc
		v_mov_b32_e32 v71, 0x40040
		v_add_co_u32_e64 v94, vcc, v72, v71
		v_addc_co_u32_e64 v95, vcc, v73, 0, vcc
		v_add_co_u32_e64 v104, vcc, v94, v84
		v_addc_co_u32_e64 v105, vcc, v95, v85, vcc
		v_add_co_u32_e64 v94, vcc, v104, v92
		v_addc_co_u32_e64 v95, vcc, v105, v93, vcc
		v_add_co_u32_e64 v104, vcc, v94, v90
		v_addc_co_u32_e64 v105, vcc, v95, v91, vcc
		v_mov_b32_e32 v94, 0x80040
		v_add_co_u32_e64 v106, vcc, v72, v94
		v_addc_co_u32_e64 v107, vcc, v73, 0, vcc
		v_add_co_u32_e64 v108, vcc, v106, v84
		v_addc_co_u32_e64 v109, vcc, v107, v85, vcc
		v_add_co_u32_e64 v106, vcc, v108, v92
		v_addc_co_u32_e64 v107, vcc, v109, v93, vcc
		v_add_co_u32_e64 v108, vcc, v106, v90
		v_addc_co_u32_e64 v109, vcc, v107, v91, vcc
		v_mov_b32_e32 v95, 0xc0040
		v_add_co_u32_e64 v106, vcc, v72, v95
		v_addc_co_u32_e64 v107, vcc, v73, 0, vcc
		v_add_co_u32_e64 v110, vcc, v106, v84
		v_addc_co_u32_e64 v111, vcc, v107, v85, vcc
		v_add_co_u32_e64 v106, vcc, v110, v92
		v_addc_co_u32_e64 v107, vcc, v111, v93, vcc
		v_add_co_u32_e64 v110, vcc, v106, v90
		v_addc_co_u32_e64 v111, vcc, v107, v91, vcc
		v_mov_b32_e32 v106, s14
		v_mov_b32_e32 v107, 0
		v_mul_lo_u32 v112, v6, v106
		v_mul_hi_u32 v113, v6, v106
		v_mul_lo_u32 v114, v6, v107
		v_add_u32_e32 v113, v113, v114
		v_mul_lo_u32 v114, v7, v106
		v_add_u32_e32 v113, v113, v114
		v_add_co_u32_e64 v6, vcc, v112, v84
		v_addc_co_u32_e64 v7, vcc, v113, v85, vcc
		v_add_co_u32_e64 v114, vcc, v6, v92
		v_addc_co_u32_e64 v115, vcc, v7, v93, vcc
		v_add_co_u32_e64 v6, vcc, v114, v90
		v_addc_co_u32_e64 v7, vcc, v115, v91, vcc
		v_add_co_u32_e64 v114, vcc, v112, v2
		v_addc_co_u32_e64 v115, vcc, v113, 0, vcc
		v_add_co_u32_e64 v116, vcc, v114, v84
		v_addc_co_u32_e64 v117, vcc, v115, v85, vcc
		v_add_co_u32_e64 v114, vcc, v116, v92
		v_addc_co_u32_e64 v115, vcc, v117, v93, vcc
		v_add_co_u32_e64 v116, vcc, v114, v90
		v_addc_co_u32_e64 v117, vcc, v115, v91, vcc
		v_add_co_u32_e64 v114, vcc, v112, v4
		v_addc_co_u32_e64 v115, vcc, v113, 0, vcc
		v_add_co_u32_e64 v118, vcc, v114, v84
		v_addc_co_u32_e64 v119, vcc, v115, v85, vcc
		v_add_co_u32_e64 v114, vcc, v118, v92
		v_addc_co_u32_e64 v115, vcc, v119, v93, vcc
		v_add_co_u32_e64 v118, vcc, v114, v90
		v_addc_co_u32_e64 v119, vcc, v115, v91, vcc
		v_add_co_u32_e64 v114, vcc, v112, v8
		v_addc_co_u32_e64 v115, vcc, v113, 0, vcc
		v_add_co_u32_e64 v120, vcc, v114, v84
		v_addc_co_u32_e64 v121, vcc, v115, v85, vcc
		v_add_co_u32_e64 v114, vcc, v120, v92
		v_addc_co_u32_e64 v115, vcc, v121, v93, vcc
		v_add_co_u32_e64 v120, vcc, v114, v90
		v_addc_co_u32_e64 v121, vcc, v115, v91, vcc
		v_add_co_u32_e64 v114, vcc, v112, v10
		v_addc_co_u32_e64 v115, vcc, v113, 0, vcc
		v_add_co_u32_e64 v122, vcc, v114, v84
		v_addc_co_u32_e64 v123, vcc, v115, v85, vcc
		v_add_co_u32_e64 v114, vcc, v122, v92
		v_addc_co_u32_e64 v115, vcc, v123, v93, vcc
		v_add_co_u32_e64 v122, vcc, v114, v90
		v_addc_co_u32_e64 v123, vcc, v115, v91, vcc
		v_add_co_u32_e64 v114, vcc, v112, v71
		v_addc_co_u32_e64 v115, vcc, v113, 0, vcc
		v_add_co_u32_e64 v124, vcc, v114, v84
		v_addc_co_u32_e64 v125, vcc, v115, v85, vcc
		v_add_co_u32_e64 v114, vcc, v124, v92
		v_addc_co_u32_e64 v115, vcc, v125, v93, vcc
		v_add_co_u32_e64 v124, vcc, v114, v90
		v_addc_co_u32_e64 v125, vcc, v115, v91, vcc
		v_add_co_u32_e64 v114, vcc, v112, v94
		v_addc_co_u32_e64 v115, vcc, v113, 0, vcc
		v_add_co_u32_e64 v126, vcc, v114, v84
		v_addc_co_u32_e64 v127, vcc, v115, v85, vcc
		v_add_co_u32_e64 v114, vcc, v126, v92
		v_addc_co_u32_e64 v115, vcc, v127, v93, vcc
		v_add_co_u32_e64 v126, vcc, v114, v90
		v_addc_co_u32_e64 v127, vcc, v115, v91, vcc
		v_add_co_u32_e64 v114, vcc, v112, v95
		v_addc_co_u32_e64 v115, vcc, v113, 0, vcc
		v_add_co_u32_e64 v94, vcc, v114, v84
		v_addc_co_u32_e64 v95, vcc, v115, v85, vcc
		v_add_co_u32_e64 v114, vcc, v94, v92
		v_addc_co_u32_e64 v115, vcc, v95, v93, vcc
		v_add_co_u32_e64 v94, vcc, v114, v90
		v_addc_co_u32_e64 v95, vcc, v115, v91, vcc
		v_mul_lo_u32 v114, v82, v106
		v_mul_hi_u32 v115, v82, v106
		v_mul_lo_u32 v2, v82, v107
		v_add_u32_e32 v115, v115, v2
		v_mul_lo_u32 v2, v83, v106
		v_add_u32_e32 v115, v115, v2
		v_add_co_u32_e64 v82, vcc, v72, v114
		v_addc_co_u32_e64 v83, vcc, v73, v115, vcc
		v_lshrrev_b64 v[106:107], 7, v[78:79]
		s_mov_b32 s62, 0x400
		s_mov_b32 s63, 0
		v_mov_b32_e32 v78, s62
		v_mov_b32_e32 v79, s63
		v_mul_lo_u32 v128, v78, v106
		v_mul_hi_u32 v129, v78, v106
		v_mul_lo_u32 v2, v78, v107
		v_add_u32_e32 v129, v129, v2
		v_mul_lo_u32 v2, v79, v106
		v_add_u32_e32 v129, v129, v2
		v_add_co_u32_e64 v106, vcc, v82, v128
		v_addc_co_u32_e64 v107, vcc, v83, v129, vcc
		v_mul_lo_u32 v130, v86, v88
		v_mul_hi_u32 v131, v86, v88
		v_mul_lo_u32 v2, v86, v89
		v_add_u32_e32 v131, v131, v2
		v_mul_lo_u32 v2, v87, v88
		v_add_u32_e32 v131, v131, v2
		v_add_co_u32_e64 v86, vcc, v106, v130
		v_addc_co_u32_e64 v87, vcc, v107, v131, vcc
		s_mov_b32 s62, 0x800
		s_mov_b32 s63, 0
		v_mov_b32_e32 v88, s62
		v_mov_b32_e32 v89, s63
		v_add_co_u32_e64 v106, vcc, v82, v130
		v_addc_co_u32_e64 v107, vcc, v83, v131, vcc
		v_mov_b32_e32 v2, 1
		v_and_b32_e32 v82, v80, v2
		v_and_b32_e32 v83, v81, v5
		v_mul_lo_u32 v4, v78, v82
		v_mul_hi_u32 v5, v78, v82
		v_mul_lo_u32 v2, v78, v83
		v_add_u32_e32 v5, v5, v2
		v_mul_lo_u32 v2, v79, v82
		v_add_u32_e32 v5, v5, v2
		v_add_co_u32_e64 v78, vcc, v106, v4
		v_addc_co_u32_e64 v79, vcc, v107, v5, vcc
		v_mov_b32_e32 v2, 0x80
		v_add_co_u32_e64 v80, vcc, v72, v2
		v_addc_co_u32_e64 v81, vcc, v73, 0, vcc
		v_add_co_u32_e64 v82, vcc, v80, v84
		v_addc_co_u32_e64 v83, vcc, v81, v85, vcc
		v_add_co_u32_e64 v80, vcc, v82, v92
		v_addc_co_u32_e64 v81, vcc, v83, v93, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v82, vcc, v80, v90
		v_addc_co_u32_e64 v83, vcc, v81, v91, vcc
		ds_write_addtid_b32 v82 offset:2048
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v83 offset:3072
		v_mov_b32_e32 v8, 0x40080
		v_add_co_u32_e64 v80, vcc, v72, v8
		v_addc_co_u32_e64 v81, vcc, v73, 0, vcc
		v_add_co_u32_e64 v82, vcc, v80, v84
		v_addc_co_u32_e64 v83, vcc, v81, v85, vcc
		v_add_co_u32_e64 v80, vcc, v82, v92
		v_addc_co_u32_e64 v81, vcc, v83, v93, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v82, vcc, v80, v90
		v_addc_co_u32_e64 v83, vcc, v81, v91, vcc
		ds_write_addtid_b32 v82 offset:4096
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v83 offset:5120
		v_mov_b32_e32 v10, 0x80080
		v_add_co_u32_e64 v80, vcc, v72, v10
		v_addc_co_u32_e64 v81, vcc, v73, 0, vcc
		v_add_co_u32_e64 v82, vcc, v80, v84
		v_addc_co_u32_e64 v83, vcc, v81, v85, vcc
		v_add_co_u32_e64 v80, vcc, v82, v92
		v_addc_co_u32_e64 v81, vcc, v83, v93, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v82, vcc, v80, v90
		v_addc_co_u32_e64 v83, vcc, v81, v91, vcc
		ds_write_addtid_b32 v82 offset:6144
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v83 offset:7168
		v_mov_b32_e32 v71, 0xc0080
		v_add_co_u32_e64 v80, vcc, v72, v71
		v_addc_co_u32_e64 v81, vcc, v73, 0, vcc
		v_add_co_u32_e64 v82, vcc, v80, v84
		v_addc_co_u32_e64 v83, vcc, v81, v85, vcc
		v_add_co_u32_e64 v80, vcc, v82, v92
		v_addc_co_u32_e64 v81, vcc, v83, v93, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v82, vcc, v80, v90
		v_addc_co_u32_e64 v83, vcc, v81, v91, vcc
		ds_write_addtid_b32 v82 offset:8192
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v83 offset:9216
		v_mov_b32_e32 v80, 0xc0
		v_add_co_u32_e64 v82, vcc, v72, v80
		v_addc_co_u32_e64 v83, vcc, v73, 0, vcc
		v_add_co_u32_e64 v106, vcc, v82, v84
		v_addc_co_u32_e64 v107, vcc, v83, v85, vcc
		v_add_co_u32_e64 v82, vcc, v106, v92
		v_addc_co_u32_e64 v83, vcc, v107, v93, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v106, vcc, v82, v90
		v_addc_co_u32_e64 v107, vcc, v83, v91, vcc
		ds_write_addtid_b32 v106 offset:10240
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v107 offset:11264
		v_mov_b32_e32 v81, 0x400c0
		v_add_co_u32_e64 v82, vcc, v72, v81
		v_addc_co_u32_e64 v83, vcc, v73, 0, vcc
		v_add_co_u32_e64 v106, vcc, v82, v84
		v_addc_co_u32_e64 v107, vcc, v83, v85, vcc
		v_add_co_u32_e64 v82, vcc, v106, v92
		v_addc_co_u32_e64 v83, vcc, v107, v93, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v106, vcc, v82, v90
		v_addc_co_u32_e64 v107, vcc, v83, v91, vcc
		ds_write_addtid_b32 v106 offset:12288
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v107 offset:13312
		v_mov_b32_e32 v82, 0x800c0
		v_add_co_u32_e64 v106, vcc, v72, v82
		v_addc_co_u32_e64 v107, vcc, v73, 0, vcc
		v_add_co_u32_e64 v132, vcc, v106, v84
		v_addc_co_u32_e64 v133, vcc, v107, v85, vcc
		v_add_co_u32_e64 v106, vcc, v132, v92
		v_addc_co_u32_e64 v107, vcc, v133, v93, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v132, vcc, v106, v90
		v_addc_co_u32_e64 v133, vcc, v107, v91, vcc
		ds_write_addtid_b32 v132 offset:14336
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v133 offset:15360
		v_mov_b32_e32 v83, 0xc00c0
		v_add_co_u32_e64 v106, vcc, v72, v83
		v_addc_co_u32_e64 v107, vcc, v73, 0, vcc
		v_add_co_u32_e64 v132, vcc, v106, v84
		v_addc_co_u32_e64 v133, vcc, v107, v85, vcc
		v_add_co_u32_e64 v106, vcc, v132, v92
		v_addc_co_u32_e64 v107, vcc, v133, v93, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v132, vcc, v106, v90
		v_addc_co_u32_e64 v133, vcc, v107, v91, vcc
		ds_write_addtid_b32 v132 offset:16384
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v133 offset:17408
		v_add_co_u32_e64 v106, vcc, v112, v2
		v_addc_co_u32_e64 v107, vcc, v113, 0, vcc
		v_add_co_u32_e64 v132, vcc, v106, v84
		v_addc_co_u32_e64 v133, vcc, v107, v85, vcc
		v_add_co_u32_e64 v106, vcc, v132, v92
		v_addc_co_u32_e64 v107, vcc, v133, v93, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v132, vcc, v106, v90
		v_addc_co_u32_e64 v133, vcc, v107, v91, vcc
		ds_write_addtid_b32 v132 offset:18432
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v133 offset:19456
		v_add_co_u32_e64 v106, vcc, v112, v8
		v_addc_co_u32_e64 v107, vcc, v113, 0, vcc
		v_add_co_u32_e64 v132, vcc, v106, v84
		v_addc_co_u32_e64 v133, vcc, v107, v85, vcc
		v_add_co_u32_e64 v106, vcc, v132, v92
		v_addc_co_u32_e64 v107, vcc, v133, v93, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v132, vcc, v106, v90
		v_addc_co_u32_e64 v133, vcc, v107, v91, vcc
		ds_write_addtid_b32 v132 offset:20480
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v133 offset:21504
		v_add_co_u32_e64 v106, vcc, v112, v10
		v_addc_co_u32_e64 v107, vcc, v113, 0, vcc
		v_add_co_u32_e64 v132, vcc, v106, v84
		v_addc_co_u32_e64 v133, vcc, v107, v85, vcc
		v_add_co_u32_e64 v106, vcc, v132, v92
		v_addc_co_u32_e64 v107, vcc, v133, v93, vcc
		v_add_co_u32_e64 v132, vcc, v106, v90
		v_addc_co_u32_e64 v133, vcc, v107, v91, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v132, s62
		scratch_store_dword off, v133, s62 offset:4
		v_add_co_u32_e64 v106, vcc, v112, v71
		v_addc_co_u32_e64 v107, vcc, v113, 0, vcc
		v_add_co_u32_e64 v132, vcc, v106, v84
		v_addc_co_u32_e64 v133, vcc, v107, v85, vcc
		v_add_co_u32_e64 v106, vcc, v132, v92
		v_addc_co_u32_e64 v107, vcc, v133, v93, vcc
		v_add_co_u32_e64 v132, vcc, v106, v90
		v_addc_co_u32_e64 v133, vcc, v107, v91, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v132, s62 offset:8
		scratch_store_dword off, v133, s62 offset:12
		v_add_co_u32_e64 v106, vcc, v112, v80
		v_addc_co_u32_e64 v107, vcc, v113, 0, vcc
		v_add_co_u32_e64 v132, vcc, v106, v84
		v_addc_co_u32_e64 v133, vcc, v107, v85, vcc
		v_add_co_u32_e64 v106, vcc, v132, v92
		v_addc_co_u32_e64 v107, vcc, v133, v93, vcc
		v_add_co_u32_e64 v132, vcc, v106, v90
		v_addc_co_u32_e64 v133, vcc, v107, v91, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v132, s62 offset:16
		scratch_store_dword off, v133, s62 offset:20
		v_add_co_u32_e64 v106, vcc, v112, v81
		v_addc_co_u32_e64 v107, vcc, v113, 0, vcc
		v_add_co_u32_e64 v80, vcc, v106, v84
		v_addc_co_u32_e64 v81, vcc, v107, v85, vcc
		v_add_co_u32_e64 v106, vcc, v80, v92
		v_addc_co_u32_e64 v107, vcc, v81, v93, vcc
		v_add_co_u32_e64 v80, vcc, v106, v90
		v_addc_co_u32_e64 v81, vcc, v107, v91, vcc
		v_add_co_u32_e64 v106, vcc, v112, v82
		v_addc_co_u32_e64 v107, vcc, v113, 0, vcc
		v_add_co_u32_e64 v132, vcc, v106, v84
		v_addc_co_u32_e64 v133, vcc, v107, v85, vcc
		v_add_co_u32_e64 v106, vcc, v132, v92
		v_addc_co_u32_e64 v107, vcc, v133, v93, vcc
		v_add_co_u32_e64 v132, vcc, v106, v90
		v_addc_co_u32_e64 v133, vcc, v107, v91, vcc
		v_add_co_u32_e64 v106, vcc, v112, v83
		v_addc_co_u32_e64 v107, vcc, v113, 0, vcc
		v_add_co_u32_e64 v82, vcc, v106, v84
		v_addc_co_u32_e64 v83, vcc, v107, v85, vcc
		v_add_co_u32_e64 v84, vcc, v82, v92
		v_addc_co_u32_e64 v85, vcc, v83, v93, vcc
		v_add_co_u32_e64 v82, vcc, v84, v90
		v_addc_co_u32_e64 v83, vcc, v85, v91, vcc
		v_mov_b32_e32 v2, 0x800
		v_add_co_u32_e64 v84, vcc, v72, v2
		v_addc_co_u32_e64 v85, vcc, v73, 0, vcc
		v_add_co_u32_e64 v72, vcc, v84, v114
		v_addc_co_u32_e64 v73, vcc, v85, v115, vcc
		v_add_co_u32_e64 v84, vcc, v72, v128
		v_addc_co_u32_e64 v85, vcc, v73, v129, vcc
		v_add_co_u32_e64 v90, vcc, v84, v130
		v_addc_co_u32_e64 v91, vcc, v85, v131, vcc
		v_add_co_u32_e64 v84, vcc, v72, v130
		v_addc_co_u32_e64 v85, vcc, v73, v131, vcc
		v_add_co_u32_e64 v72, vcc, v84, v4
		v_addc_co_u32_e64 v73, vcc, v85, v5, vcc
		v_mov_b32_e32 v4, s61
		v_mov_b32_e32 v5, 0
		v_mov_b64_e32 v[112:113], 0
		v_mov_b64_e32 v[114:115], 0
		v_mov_b64_e32 v[128:129], 0
		v_mov_b64_e32 v[130:131], 0
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
.Lwmma_f16_matmul_tiled.loop_head_0:
		v_mov_b32_e32 v4, s61
		v_mul_lo_u32 v84, v76, v4
		v_mul_hi_u32 v85, v76, v4
		v_mul_lo_u32 v2, v76, v5
		v_add_u32_e32 v85, v85, v2
		v_mul_lo_u32 v2, v77, v4
		v_add_u32_e32 v85, v85, v2
		v_add_co_u32_e64 v92, vcc, v74, v84
		v_addc_co_u32_e64 v93, vcc, v75, v85, vcc
		v_add_co_u32_e64 v106, vcc, v96, v84
		v_addc_co_u32_e64 v107, vcc, v97, v85, vcc
		v_add_co_u32_e64 v134, vcc, v98, v84
		v_addc_co_u32_e64 v135, vcc, v99, v85, vcc
		v_add_co_u32_e64 v188, vcc, v100, v84
		v_addc_co_u32_e64 v189, vcc, v101, v85, vcc
		v_add_co_u32_e64 v190, vcc, v102, v84
		v_addc_co_u32_e64 v191, vcc, v103, v85, vcc
		v_add_co_u32_e64 v192, vcc, v104, v84
		v_addc_co_u32_e64 v193, vcc, v105, v85, vcc
		v_add_co_u32_e64 v194, vcc, v108, v84
		v_addc_co_u32_e64 v195, vcc, v109, v85, vcc
		v_add_co_u32_e64 v196, vcc, v110, v84
		v_addc_co_u32_e64 v197, vcc, v111, v85, vcc
		v_add_co_u32_e64 v198, vcc, v6, v84
		v_addc_co_u32_e64 v199, vcc, v7, v85, vcc
		v_add_co_u32_e64 v200, vcc, v116, v84
		v_addc_co_u32_e64 v201, vcc, v117, v85, vcc
		v_add_co_u32_e64 v202, vcc, v118, v84
		v_addc_co_u32_e64 v203, vcc, v119, v85, vcc
		v_add_co_u32_e64 v204, vcc, v120, v84
		v_addc_co_u32_e64 v205, vcc, v121, v85, vcc
		v_add_co_u32_e64 v206, vcc, v122, v84
		v_addc_co_u32_e64 v207, vcc, v123, v85, vcc
		v_add_co_u32_e64 v208, vcc, v124, v84
		v_addc_co_u32_e64 v209, vcc, v125, v85, vcc
		v_add_co_u32_e64 v210, vcc, v126, v84
		v_addc_co_u32_e64 v211, vcc, v127, v85, vcc
		v_add_co_u32_e64 v212, vcc, v94, v84
		v_addc_co_u32_e64 v213, vcc, v95, v85, vcc
		v_mul_lo_u32 v214, v88, v4
		v_mul_hi_u32 v215, v88, v4
		v_mul_lo_u32 v2, v88, v5
		v_add_u32_e32 v215, v215, v2
		v_mul_lo_u32 v2, v89, v4
		v_add_u32_e32 v215, v215, v2
		v_add_co_u32_e64 v216, vcc, v86, v214
		v_addc_co_u32_e64 v217, vcc, v87, v215, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v218, vcc, v78, v214
		v_addc_co_u32_e64 v219, vcc, v79, v215, vcc
		s_waitcnt lgkmcnt(0)
		ds_read_addtid_b32 v2 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], a[0:3], v[36:39], v[12:15], v2, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s62, s61, 1
		s_lshl_b32 s63, s62, 16
		v_add_u32_e32 v2, s63, v3
		v_add3_u32 v2, v2, v11, v9
		v_add_u32_e32 v8, 0x400, v2
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
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		ds_read_b128 a[208:211], v8 offset:16384
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v8 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[0:3], v[40:43], v[112:115], v8, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v8, 0x400, v2
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
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		ds_read_b128 a[212:215], v8 offset:17408
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v8 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[0:3], v[44:47], v[128:131], v8, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v8, 0x400, v2
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
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		ds_read_b128 a[216:219], v8 offset:18432
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v8 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[0:3], v[48:51], v[136:139], v8, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v8, 0x400, v2
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
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		ds_read_b128 a[220:223], v8 offset:19456
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v8 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[0:3], v[52:55], v[140:143], v8, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v8, 0x400, v2
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
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		ds_read_b128 a[224:227], v8 offset:20480
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v8 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[0:3], v[56:59], v[144:147], v8, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v8, 0x400, v2
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
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		ds_read_b128 a[228:231], v8 offset:21504
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v8 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[0:3], v[60:63], v[148:151], v8, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v8, 0x400, v2
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
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		ds_read_b128 a[232:235], v8 offset:22528
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v8 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[0:3], v[64:67], v[152:155], v8, v16 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v8, 0x400, v2
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
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		ds_read_b128 a[236:239], v8 offset:23552
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v8 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[4:7], v[36:39], v[156:159], v8, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v8, s63, v11
		v_add3_u32 v8, v8, v1, v9
		v_add_u32_e32 v10, 0x400, v8
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
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		ds_read_b128 a[240:243], v10 offset:49152
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v10 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[4:7], v[40:43], v[160:163], v10, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v10, 0x400, v8
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
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		ds_read_b128 a[244:247], v10 offset:50176
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v10 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[4:7], v[44:47], v[164:167], v10, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v10, 0x400, v8
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
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		ds_read_b128 a[248:251], v10 offset:51200
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v10 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[4:7], v[48:51], v[168:171], v10, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v10, 0x400, v8
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
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		ds_read_b128 a[252:255], v10 offset:52224
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v10 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[4:7], v[52:55], v[172:175], v10, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
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
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		ds_read_b128 v[220:223], v8 offset:53248
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v8 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[4:7], v[56:59], v[176:179], v8, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s63, s61, 1
		s_lshl_b32 s63, s63, 16
		v_and_b32_e32 v8, 15, v0
		v_lshlrev_b32_e32 v10, 6, v8
		v_add_u32_e32 v10, s63, v10
		v_lshrrev_b32_e32 v71, 6, v0
		v_and_b32_e32 v71, 1, v71
		v_lshlrev_b32_e32 v71, 13, v71
		v_and_b32_e32 v224, 63, v0
		v_lshrrev_b32_e32 v224, 4, v224
		v_lshrrev_b32_e32 v8, 1, v8
		v_bitop3_b32 v8, v224, v8, 3 bitop3:0x78
		v_lshlrev_b32_e32 v8, 4, v8
		s_mov_b32 m0, s15
		v_add3_u32 v8, v10, v71, v8
		ds_write_addtid_b32 v8 offset:22528
		v_add_u32_e32 v10, 0x400, v8
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
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		ds_read_b128 v[224:227], v10 offset:54272
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v10 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[4:7], v[60:63], v[180:183], v10, v16 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v10, 0x400, v8
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
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		ds_read_b128 v[228:231], v10 offset:55296
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v10 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[4:7], v[64:67], v[184:187], v10, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v10, 0x400, v8
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
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		ds_read_b128 v[232:235], v10 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[8:11], v[36:39], a[16:19], v18, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s40, 0x6000
		s_nop 0
		buffer_load_dwordx4 v92, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[8:11], v[40:43], a[20:23], v18, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s9, 0x6000
		s_nop 0
		buffer_load_dwordx4 v106, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[8:11], v[44:47], a[24:27], v18, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s11, 0x6000
		s_nop 0
		buffer_load_dwordx4 v134, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[8:11], v[48:51], a[28:31], v18, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s47, 0x6000
		s_nop 0
		buffer_load_dwordx4 v188, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[8:11], v[52:55], a[32:35], v18, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s48, 0x6000
		s_nop 0
		buffer_load_dwordx4 v190, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[8:11], v[56:59], a[36:39], v18, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s49, 0x6000
		s_nop 0
		buffer_load_dwordx4 v192, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[8:11], v[60:63], a[40:43], v18, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s50, 0x6000
		s_nop 0
		buffer_load_dwordx4 v194, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[8:11], v[64:67], a[44:47], v18, v16 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s51, 0x6000
		s_nop 0
		buffer_load_dwordx4 v196, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[12:15], v[36:39], a[48:51], v18, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s52, 0x6000
		s_nop 0
		buffer_load_dwordx4 v198, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[12:15], v[40:43], a[52:55], v18, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s53, 0x6000
		s_nop 0
		buffer_load_dwordx4 v200, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[12:15], v[44:47], a[56:59], v18, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s54, 0x6000
		s_nop 0
		buffer_load_dwordx4 v202, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[12:15], v[48:51], a[60:63], v18, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s55, 0x6000
		s_nop 0
		buffer_load_dwordx4 v204, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[12:15], v[52:55], a[64:67], v18, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s56, 0x6000
		s_nop 0
		buffer_load_dwordx4 v206, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[12:15], v[56:59], a[68:71], v18, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s57, 0x6000
		s_nop 0
		buffer_load_dwordx4 v208, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[12:15], v[60:63], a[72:75], v18, v16 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s58, 0x6000
		s_nop 0
		buffer_load_dwordx4 v210, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[12:15], v[64:67], a[76:79], v18, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s59, 0x6000
		s_nop 0
		buffer_load_dwordx4 v212, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[20:23], v[36:39], a[80:83], v19, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s63, s61, 1
		s_add_i32 m0, s10, 0x26000
		s_nop 0
		buffer_load_dwordx4 v216, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[20:23], v[40:43], a[84:87], v19, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshl_b32 s62, s62, 12
		s_add_i32 m0, s60, 0x26000
		s_nop 0
		buffer_load_dwordx4 v218, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[20:23], v[44:47], a[88:91], v19, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		v_add_u32_e32 v10, 0x400, v2
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
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		ds_read_b128 a[0:3], v10
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[20:23], v[48:51], a[92:95], v19, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v10, 0x400, v2
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
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		ds_read_b128 a[4:7], v10 offset:1024
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[20:23], v[52:55], a[96:99], v19, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v10, 0x400, v2
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
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		ds_read_b128 a[8:11], v10 offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[20:23], v[56:59], a[100:103], v19, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v10, 0x400, v2
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
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		ds_read_b128 a[12:15], v10 offset:3072
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[20:23], v[60:63], a[104:107], v19, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v10, 0x400, v2
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
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		ds_read_b128 v[188:191], v10 offset:4096
		s_mov_b32 s64, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v188, s64 offset:24
		scratch_store_dword off, v189, s64 offset:28
		scratch_store_dword off, v190, s64 offset:32
		scratch_store_dword off, v191, s64 offset:36
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[20:23], v[64:67], a[108:111], v19, v16 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v10, 0x400, v2
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
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		ds_read_b128 v[20:23], v10 offset:5120
		s_mov_b32 s64, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s64 offset:40
		scratch_store_dword off, v21, s64 offset:44
		scratch_store_dword off, v22, s64 offset:48
		scratch_store_dword off, v23, s64 offset:52
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[24:27], v[36:39], a[112:115], v19, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v10, 0x400, v2
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
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		ds_read_b128 v[20:23], v10 offset:6144
		s_mov_b32 s64, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s64 offset:56
		scratch_store_dword off, v21, s64 offset:60
		scratch_store_dword off, v22, s64 offset:64
		scratch_store_dword off, v23, s64 offset:68
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[24:27], v[40:43], a[116:119], v19, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[20:23], v2 offset:7168
		s_mov_b32 s64, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s64 offset:72
		scratch_store_dword off, v21, s64 offset:76
		scratch_store_dword off, v22, s64 offset:80
		scratch_store_dword off, v23, s64 offset:84
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[24:27], v[44:47], a[120:123], v19, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v8
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[20:23], v2 offset:32768
		s_mov_b32 s64, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s64 offset:88
		scratch_store_dword off, v21, s64 offset:92
		scratch_store_dword off, v22, s64 offset:96
		scratch_store_dword off, v23, s64 offset:100
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[24:27], v[48:51], a[124:127], v19, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v8
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[20:23], v2 offset:33792
		s_mov_b32 s64, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s64 offset:104
		scratch_store_dword off, v21, s64 offset:108
		scratch_store_dword off, v22, s64 offset:112
		scratch_store_dword off, v23, s64 offset:116
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[24:27], v[52:55], a[128:131], v19, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v8
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[20:23], v2 offset:34816
		s_mov_b32 s64, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s64 offset:120
		scratch_store_dword off, v21, s64 offset:124
		scratch_store_dword off, v22, s64 offset:128
		scratch_store_dword off, v23, s64 offset:132
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[24:27], v[56:59], a[132:135], v19, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v8
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[20:23], v2 offset:35840
		s_mov_b32 s64, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s64 offset:136
		scratch_store_dword off, v21, s64 offset:140
		scratch_store_dword off, v22, s64 offset:144
		scratch_store_dword off, v23, s64 offset:148
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[24:27], v[60:63], a[136:139], v19, v16 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v8
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[20:23], v2 offset:36864
		s_mov_b32 s64, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s64 offset:152
		scratch_store_dword off, v21, s64 offset:156
		scratch_store_dword off, v22, s64 offset:160
		scratch_store_dword off, v23, s64 offset:164
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[24:27], v[64:67], a[140:143], v19, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v8
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[20:23], v2 offset:37888
		s_mov_b32 s64, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s64 offset:168
		scratch_store_dword off, v21, s64 offset:172
		scratch_store_dword off, v22, s64 offset:176
		scratch_store_dword off, v23, s64 offset:180
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[28:31], v[36:39], a[144:147], v17, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v8
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[20:23], v2 offset:38912
		s_mov_b32 s64, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s64 offset:184
		scratch_store_dword off, v21, s64 offset:188
		scratch_store_dword off, v22, s64 offset:192
		scratch_store_dword off, v23, s64 offset:196
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[28:31], v[40:43], a[148:151], v17, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v2 offset:22528
		s_waitcnt lgkmcnt(0)
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[188:191], v2 offset:39936
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[28:31], v[44:47], a[152:155], v17, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s62, s62, 0x20000
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v2, 10, v2
		v_and_b32_e32 v8, 63, v0
		v_lshlrev_b32_e32 v8, 2, v8
		v_add3_u32 v10, s62, v2, v8
		v_add_u32_e32 v20, 0x400, v10
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
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		ds_read_b32 v71, v20
		v_add_u32_e32 v20, 0x400, v10
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
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		ds_read_b32 v92, v20 offset:256
		v_add_u32_e32 v20, 0x400, v10
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
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		ds_read_b32 v93, v20 offset:512
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
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		ds_read_b32 v106, v10 offset:768
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v10 offset:1024
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v10, s62, v8, v10
		v_add_u32_e32 v20, 0x400, v10
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
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		ds_read_b32 v107, v20 offset:2048
		v_add_u32_e32 v20, 0x400, v10
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
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		ds_read_b32 v134, v20 offset:2304
		v_add_u32_e32 v20, 0x400, v10
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
		v_add_u32_e32 v20, 0x800, v20
		v_add_u32_e32 v20, 0x400, v20
		v_add_u32_e32 v20, 0x400, v20
		ds_read_b32 v135, v20 offset:2560
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
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x400, v10
		ds_read_b32 v192, v10 offset:2816
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[28:31], v[48:51], a[156:159], v17, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[32:35], v[48:51], a[188:191], v17, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[32:35], v[44:47], a[184:187], v17, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[32:35], v[36:39], a[176:179], v17, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[32:35], v[40:43], a[180:183], v17, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[32:35], v[52:55], a[192:195], v17, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[28:31], v[52:55], a[160:163], v17, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[28:31], v[56:59], a[164:167], v17, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[32:35], v[56:59], a[196:199], v17, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[32:35], v[60:63], a[200:203], v17, v16 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[28:31], v[60:63], a[168:171], v17, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[28:31], v[64:67], a[172:175], v17, v16 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[32:35], v[64:67], a[204:207], v17, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[232:235], v[228:231], a[168:171], v17, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[232:235], v[232:235], a[172:175], v17, v16 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[236:239], v[232:235], a[204:207], v17, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[236:239], v[228:231], a[200:203], v17, v16 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v10 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[208:211], v[228:231], v[148:151], v10, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v10 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[208:211], v[232:235], v[152:155], v10, v16 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v10 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[212:215], v[232:235], v[184:187], v10, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v10 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[212:215], v[228:231], v[180:183], v10, v16 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v10 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[212:215], a[240:243], v[156:159], v10, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v10 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], a[208:211], a[240:243], v[12:15], v10, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v10 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[208:211], a[244:247], v[112:115], v10, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v10 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[212:215], a[244:247], v[160:163], v10, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v10 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[212:215], a[248:251], v[164:167], v10, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v10 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[208:211], a[248:251], v[128:131], v10, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v10 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[208:211], a[252:255], v[136:139], v10, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v10 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[212:215], a[252:255], v[168:171], v10, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v10 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[212:215], v[220:223], v[172:175], v10, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v10 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[208:211], v[220:223], v[140:143], v10, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v10 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[208:211], v[224:227], v[144:147], v10, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v10 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[212:215], v[224:227], v[176:179], v10, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[216:219], v[224:227], a[36:39], v18, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[216:219], v[220:223], a[32:35], v18, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[220:223], v[220:223], a[64:67], v18, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[220:223], v[224:227], a[68:71], v18, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[220:223], a[240:243], a[48:51], v18, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[216:219], a[240:243], a[16:19], v18, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[216:219], a[244:247], a[20:23], v18, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[220:223], a[244:247], a[52:55], v18, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[220:223], a[248:251], a[56:59], v18, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[216:219], a[248:251], a[24:27], v18, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[216:219], a[252:255], a[28:31], v18, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[220:223], a[252:255], a[60:63], v18, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[220:223], v[228:231], a[72:75], v18, v16 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[216:219], v[228:231], a[40:43], v18, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[216:219], v[232:235], a[44:47], v18, v16 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[220:223], v[232:235], a[76:79], v18, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[224:227], v[232:235], a[108:111], v19, v16 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[224:227], v[228:231], a[104:107], v19, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[228:231], v[228:231], a[136:139], v19, v16 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[228:231], v[232:235], a[140:143], v19, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[228:231], a[240:243], a[112:115], v19, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[224:227], a[240:243], a[80:83], v19, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[224:227], a[244:247], a[84:87], v19, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[228:231], a[244:247], a[116:119], v19, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[228:231], a[248:251], a[120:123], v19, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], a[224:227], a[248:251], a[88:91], v19, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], a[224:227], a[252:255], a[92:95], v19, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[228:231], a[252:255], a[124:127], v19, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[228:231], v[220:223], a[128:131], v19, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[224:227], v[220:223], a[96:99], v19, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[224:227], v[224:227], a[100:103], v19, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[228:231], v[224:227], a[132:135], v19, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[232:235], v[224:227], a[164:167], v17, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[232:235], v[220:223], a[160:163], v17, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[236:239], v[220:223], a[192:195], v17, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[236:239], v[224:227], a[196:199], v17, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[236:239], a[240:243], a[176:179], v17, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[232:235], a[240:243], a[144:147], v17, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[232:235], a[244:247], a[148:151], v17, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[236:239], a[244:247], a[180:183], v17, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[236:239], a[248:251], a[184:187], v17, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[232:235], a[248:251], a[152:155], v17, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[232:235], a[252:255], a[156:159], v17, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[236:239], a[252:255], a[188:191], v17, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s62, s63, 1
		s_lshl_b32 s63, s62, 16
		v_lshrrev_b32_e32 v10, 7, v0
		v_lshlrev_b32_e32 v10, 13, v10
		v_add_u32_e32 v10, s63, v10
		v_and_b32_e32 v16, 15, v0
		v_lshlrev_b32_e32 v16, 6, v16
		v_and_b32_e32 v17, 63, v0
		v_lshrrev_b32_e32 v17, 4, v17
		v_and_b32_e32 v18, 15, v0
		v_lshrrev_b32_e32 v18, 1, v18
		v_bitop3_b32 v17, v17, v18, 3 bitop3:0x78
		v_lshlrev_b32_e32 v17, 4, v17
		v_add3_u32 v10, v10, v16, v17
		v_add_u32_e32 v18, 0x400, v10
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
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		ds_read_b128 v[20:23], v18
		v_add_u32_e32 v18, 0x400, v10
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
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		ds_read_b128 v[24:27], v18 offset:1024
		v_add_u32_e32 v18, 0x400, v10
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
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		ds_read_b128 v[28:31], v18 offset:2048
		v_add_u32_e32 v18, 0x400, v10
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
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		ds_read_b128 v[32:35], v18 offset:3072
		v_add_u32_e32 v18, 0x400, v10
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
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		ds_read_b128 v[36:39], v18 offset:4096
		v_add_u32_e32 v18, 0x400, v10
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
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		ds_read_b128 v[40:43], v18 offset:5120
		v_add_u32_e32 v18, 0x400, v10
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
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		ds_read_b128 a[208:211], v18 offset:6144
		v_add_u32_e32 v18, 0x400, v10
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
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x400, v18
		v_add_u32_e32 v18, 0x400, v18
		ds_read_b128 a[212:215], v18 offset:7168
		s_mov_b32 m0, s15
		v_add_u32_e32 v16, s63, v16
		ds_read_addtid_b32 v18
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v16, v16, v18, v17
		v_add_u32_e32 v17, 0x400, v16
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
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		ds_read_b128 a[216:219], v17 offset:32768
		v_add_u32_e32 v17, 0x400, v16
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
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		ds_read_b128 a[220:223], v17 offset:33792
		v_add_u32_e32 v17, 0x400, v16
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
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		ds_read_b128 a[224:227], v17 offset:34816
		v_add_u32_e32 v17, 0x400, v16
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
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		ds_read_b128 a[228:231], v17 offset:35840
		v_add_u32_e32 v17, 0x400, v16
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
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		ds_read_b128 a[232:235], v17 offset:36864
		v_add_u32_e32 v17, 0x400, v16
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
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		ds_read_b128 a[236:239], v17 offset:37888
		v_add_u32_e32 v17, 0x400, v16
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
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		ds_read_b128 a[240:243], v17 offset:38912
		v_add_u32_e32 v17, 0x400, v16
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
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		ds_read_b128 a[244:247], v17 offset:39936
		s_lshl_b32 s62, s62, 12
		s_add_i32 s62, s62, 0x20000
		v_add3_u32 v2, s62, v2, v8
		v_add_u32_e32 v17, 0x400, v2
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
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		ds_read_b32 v18, v17
		v_add_u32_e32 v17, 0x400, v2
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
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		ds_read_b32 v19, v17 offset:256
		v_add_u32_e32 v17, 0x400, v2
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
		v_add_u32_e32 v17, 0x800, v17
		v_add_u32_e32 v17, 0x400, v17
		v_add_u32_e32 v17, 0x400, v17
		ds_read_b32 v44, v17 offset:512
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b32 v17, v2 offset:768
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v2 offset:1024
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v2, s62, v8, v2
		v_add_u32_e32 v8, 0x400, v2
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
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		ds_read_b32 v45, v8 offset:2048
		v_add_u32_e32 v8, 0x400, v2
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
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		ds_read_b32 v46, v8 offset:2304
		v_add_u32_e32 v8, 0x400, v2
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
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x400, v8
		v_add_u32_e32 v8, 0x400, v8
		ds_read_b32 v47, v8 offset:2560
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b32 v8, v2 offset:2816
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v48 offset:2048
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v49 offset:3072
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v50, vcc, v48, v84
		v_addc_co_u32_e64 v51, vcc, v49, v85, vcc
		ds_read_addtid_b32 v48 offset:4096
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v49 offset:5120
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v52, vcc, v48, v84
		v_addc_co_u32_e64 v53, vcc, v49, v85, vcc
		ds_read_addtid_b32 v48 offset:6144
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v49 offset:7168
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v54, vcc, v48, v84
		v_addc_co_u32_e64 v55, vcc, v49, v85, vcc
		ds_read_addtid_b32 v48 offset:8192
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v49 offset:9216
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v56, vcc, v48, v84
		v_addc_co_u32_e64 v57, vcc, v49, v85, vcc
		ds_read_addtid_b32 v48 offset:10240
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v49 offset:11264
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v58, vcc, v48, v84
		v_addc_co_u32_e64 v59, vcc, v49, v85, vcc
		ds_read_addtid_b32 v48 offset:12288
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v49 offset:13312
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v60, vcc, v48, v84
		v_addc_co_u32_e64 v61, vcc, v49, v85, vcc
		ds_read_addtid_b32 v48 offset:14336
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v49 offset:15360
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v62, vcc, v48, v84
		v_addc_co_u32_e64 v63, vcc, v49, v85, vcc
		ds_read_addtid_b32 v48 offset:16384
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v49 offset:17408
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v64, vcc, v48, v84
		v_addc_co_u32_e64 v65, vcc, v49, v85, vcc
		ds_read_addtid_b32 v48 offset:18432
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v49 offset:19456
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v66, vcc, v48, v84
		v_addc_co_u32_e64 v67, vcc, v49, v85, vcc
		ds_read_addtid_b32 v48 offset:20480
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v49 offset:21504
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v68, vcc, v48, v84
		v_addc_co_u32_e64 v69, vcc, v49, v85, vcc
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(48)
		scratch_load_dword v48, off, s62
		scratch_load_dword v49, off, s62 offset:4
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v194, vcc, v48, v84
		v_addc_co_u32_e64 v195, vcc, v49, v85, vcc
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(46)
		scratch_load_dword v48, off, s62 offset:8
		scratch_load_dword v49, off, s62 offset:12
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v196, vcc, v48, v84
		v_addc_co_u32_e64 v197, vcc, v49, v85, vcc
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(44)
		scratch_load_dword v48, off, s62 offset:16
		scratch_load_dword v49, off, s62 offset:20
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v198, vcc, v48, v84
		v_addc_co_u32_e64 v199, vcc, v49, v85, vcc
		v_add_co_u32_e64 v48, vcc, v80, v84
		v_addc_co_u32_e64 v49, vcc, v81, v85, vcc
		v_add_co_u32_e64 v200, vcc, v132, v84
		v_addc_co_u32_e64 v201, vcc, v133, v85, vcc
		v_add_co_u32_e64 v202, vcc, v82, v84
		v_addc_co_u32_e64 v203, vcc, v83, v85, vcc
		v_add_co_u32_e64 v84, vcc, v90, v214
		v_addc_co_u32_e64 v85, vcc, v91, v215, vcc
		v_add_co_u32_e64 v204, vcc, v72, v214
		v_addc_co_u32_e64 v205, vcc, v73, v215, vcc
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[20:23], a[216:219], v[12:15], v18, v45 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v10
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 a[248:251], v2 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[20:23], a[220:223], v[112:115], v18, v45 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v10
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 a[252:255], v2 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[20:23], a[224:227], v[128:131], v18, v46 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v10
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[208:211], v2 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[20:23], a[228:231], v[136:139], v18, v46 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v10
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[212:215], v2 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[20:23], a[232:235], v[140:143], v18, v47 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v10
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[216:219], v2 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[20:23], a[236:239], v[144:147], v18, v47 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v10
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[220:223], v2 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], a[240:243], v[148:151], v18, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v10
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[224:227], v2 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], a[244:247], v[152:155], v18, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v10
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[20:23], v2 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], a[216:219], v[156:159], v18, v45 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v16
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[228:231], v2 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[24:27], a[220:223], v[160:163], v18, v45 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v16
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[232:235], v2 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[24:27], a[224:227], v[164:167], v18, v46 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v16
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[236:239], v2 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[24:27], a[228:231], v[168:171], v18, v46 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v16
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[240:243], v2 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[24:27], a[232:235], v[172:175], v18, v47 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v16
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[244:247], v2 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[24:27], a[236:239], v[176:179], v18, v47 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v16
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[248:251], v2 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], a[240:243], v[180:183], v18, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v16
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[252:255], v2 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], a[244:247], v[184:187], v18, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x400, v16
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[24:27], v2 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[28:31], a[216:219], a[16:19], v19, v45 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s16, 0x6000
		s_nop 0
		buffer_load_dwordx4 v50, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[28:31], a[220:223], a[20:23], v19, v45 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s17, 0x6000
		s_nop 0
		buffer_load_dwordx4 v52, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[28:31], a[224:227], a[24:27], v19, v46 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s19, 0x6000
		s_nop 0
		buffer_load_dwordx4 v54, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[28:31], a[228:231], a[28:31], v19, v46 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s32, 0x6000
		s_nop 0
		buffer_load_dwordx4 v56, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[28:31], a[232:235], a[32:35], v19, v47 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s33, 0x6000
		s_nop 0
		buffer_load_dwordx4 v58, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[28:31], a[236:239], a[36:39], v19, v47 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s34, 0x6000
		s_nop 0
		buffer_load_dwordx4 v60, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[28:31], a[240:243], a[40:43], v19, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s35, 0x6000
		s_nop 0
		buffer_load_dwordx4 v62, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[28:31], a[244:247], a[44:47], v19, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s36, 0x6000
		s_nop 0
		buffer_load_dwordx4 v64, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[32:35], a[216:219], a[48:51], v19, v45 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s37, 0x6000
		s_nop 0
		buffer_load_dwordx4 v66, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[32:35], a[220:223], a[52:55], v19, v45 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s38, 0x6000
		s_nop 0
		buffer_load_dwordx4 v68, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[32:35], a[224:227], a[56:59], v19, v46 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s41, 0x6000
		s_nop 0
		buffer_load_dwordx4 v194, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[32:35], a[228:231], a[60:63], v19, v46 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s42, 0x6000
		s_nop 0
		buffer_load_dwordx4 v196, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[32:35], a[232:235], a[64:67], v19, v47 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s43, 0x6000
		s_nop 0
		buffer_load_dwordx4 v198, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[32:35], a[236:239], a[68:71], v19, v47 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s44, 0x6000
		s_nop 0
		buffer_load_dwordx4 v48, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[32:35], a[240:243], a[72:75], v19, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s45, 0x6000
		s_nop 0
		buffer_load_dwordx4 v200, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[32:35], a[244:247], a[76:79], v19, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s46, 0x6000
		s_nop 0
		buffer_load_dwordx4 v202, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[36:39], a[216:219], a[80:83], v44, v45 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s8, 0x26000
		s_nop 0
		buffer_load_dwordx4 v84, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[36:39], a[220:223], a[84:87], v44, v45 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s61, s61, 2
		s_add_i32 m0, s5, 0x26000
		s_nop 0
		buffer_load_dwordx4 v204, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[36:39], a[224:227], a[88:91], v44, v46 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[36:39], a[228:231], a[92:95], v44, v46 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[40:43], a[228:231], a[124:127], v44, v46 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[40:43], a[224:227], a[120:123], v44, v46 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[40:43], a[216:219], a[112:115], v44, v45 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[40:43], a[220:223], a[116:119], v44, v45 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[40:43], a[232:235], a[128:131], v44, v47 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[36:39], a[232:235], a[96:99], v44, v47 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[36:39], a[236:239], a[100:103], v44, v47 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[40:43], a[236:239], a[132:135], v44, v47 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[40:43], a[240:243], a[136:139], v44, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[36:39], a[240:243], a[104:107], v44, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[36:39], a[244:247], a[108:111], v44, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[40:43], a[244:247], a[140:143], v44, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[208:211], a[244:247], a[172:175], v17, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[208:211], a[240:243], a[168:171], v17, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[212:215], a[240:243], a[200:203], v17, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[212:215], a[244:247], a[204:207], v17, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[212:215], a[216:219], a[176:179], v17, v45 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[208:211], a[216:219], a[144:147], v17, v45 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[208:211], a[220:223], a[148:151], v17, v45 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[212:215], a[220:223], a[180:183], v17, v45 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[212:215], a[224:227], a[184:187], v17, v46 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[208:211], a[224:227], a[152:155], v17, v46 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[208:211], a[228:231], a[156:159], v17, v46 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[212:215], a[228:231], a[188:191], v17, v46 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[212:215], a[232:235], a[192:195], v17, v47 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[208:211], a[232:235], a[160:163], v17, v47 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[208:211], a[236:239], a[164:167], v17, v47 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[212:215], a[236:239], a[196:199], v17, v47 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		s_waitcnt lgkmcnt(7)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], a[248:251], v[228:231], v[12:15], v18, v45 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[248:251], v[232:235], v[112:115], v18, v45 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[252:255], v[232:235], v[160:163], v18, v45 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[252:255], v[228:231], v[156:159], v18, v45 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[252:255], v[236:239], v[164:167], v18, v46 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[248:251], v[236:239], v[128:131], v18, v46 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[248:251], v[240:243], v[136:139], v18, v46 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[252:255], v[240:243], v[168:171], v18, v46 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[252:255], v[244:247], v[172:175], v18, v47 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[248:251], v[244:247], v[140:143], v18, v47 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[248:251], v[248:251], v[144:147], v18, v47 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[252:255], v[248:251], v[176:179], v18, v47 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[252:255], v[252:255], v[180:183], v18, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[248:251], v[252:255], v[148:151], v18, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[248:251], v[24:27], v[152:155], v18, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[252:255], v[24:27], v[184:187], v18, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[208:211], v[24:27], a[44:47], v19, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[208:211], v[252:255], a[40:43], v19, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[212:215], v[252:255], a[72:75], v19, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[212:215], v[24:27], a[76:79], v19, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[212:215], v[228:231], a[48:51], v19, v45 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[208:211], v[228:231], a[16:19], v19, v45 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[208:211], v[232:235], a[20:23], v19, v45 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[212:215], v[232:235], a[52:55], v19, v45 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[212:215], v[236:239], a[56:59], v19, v46 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[208:211], v[236:239], a[24:27], v19, v46 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[208:211], v[240:243], a[28:31], v19, v46 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[212:215], v[240:243], a[60:63], v19, v46 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[212:215], v[244:247], a[64:67], v19, v47 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[208:211], v[244:247], a[32:35], v19, v47 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[208:211], v[248:251], a[36:39], v19, v47 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[212:215], v[248:251], a[68:71], v19, v47 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[216:219], v[248:251], a[100:103], v44, v47 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[216:219], v[244:247], a[96:99], v44, v47 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[220:223], v[244:247], a[128:131], v44, v47 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[220:223], v[248:251], a[132:135], v44, v47 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[220:223], v[228:231], a[112:115], v44, v45 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[216:219], v[228:231], a[80:83], v44, v45 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[216:219], v[232:235], a[84:87], v44, v45 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[220:223], v[232:235], a[116:119], v44, v45 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[220:223], v[236:239], a[120:123], v44, v46 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[216:219], v[236:239], a[88:91], v44, v46 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[216:219], v[240:243], a[92:95], v44, v46 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[220:223], v[240:243], a[124:127], v44, v46 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[220:223], v[252:255], a[136:139], v44, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[216:219], v[252:255], a[104:107], v44, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[216:219], v[24:27], a[108:111], v44, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[220:223], v[24:27], a[140:143], v44, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[224:227], v[24:27], a[172:175], v17, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[224:227], v[252:255], a[168:171], v17, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[20:23], v[252:255], a[200:203], v17, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[20:23], v[24:27], a[204:207], v17, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[20:23], v[228:231], a[176:179], v17, v45 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[224:227], v[228:231], a[144:147], v17, v45 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[224:227], v[232:235], a[148:151], v17, v45 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[20:23], v[232:235], a[180:183], v17, v45 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[20:23], v[236:239], a[184:187], v17, v46 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[224:227], v[236:239], a[152:155], v17, v46 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[224:227], v[240:243], a[156:159], v17, v46 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[20:23], v[240:243], a[188:191], v17, v46 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[20:23], v[244:247], a[192:195], v17, v47 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[224:227], v[244:247], a[160:163], v17, v47 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[224:227], v[248:251], a[164:167], v17, v47 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[20:23], v[248:251], a[196:199], v17, v47 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_cmp_lt_i32 s61, s4
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(40)
		scratch_load_dword v16, off, s62 offset:24
		scratch_load_dword v17, off, s62 offset:28
		scratch_load_dword v18, off, s62 offset:32
		scratch_load_dword v19, off, s62 offset:36
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v20, v16
		v_mov_b32_e32 v21, v17
		v_mov_b32_e32 v22, v18
		v_mov_b32_e32 v23, v19
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(36)
		scratch_load_dword v16, off, s62 offset:40
		scratch_load_dword v17, off, s62 offset:44
		scratch_load_dword v18, off, s62 offset:48
		scratch_load_dword v19, off, s62 offset:52
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v24, v16
		v_mov_b32_e32 v25, v17
		v_mov_b32_e32 v26, v18
		v_mov_b32_e32 v27, v19
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(32)
		scratch_load_dword v16, off, s62 offset:56
		scratch_load_dword v17, off, s62 offset:60
		scratch_load_dword v18, off, s62 offset:64
		scratch_load_dword v19, off, s62 offset:68
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v28, v16
		v_mov_b32_e32 v29, v17
		v_mov_b32_e32 v30, v18
		v_mov_b32_e32 v31, v19
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(28)
		scratch_load_dword v16, off, s62 offset:72
		scratch_load_dword v17, off, s62 offset:76
		scratch_load_dword v18, off, s62 offset:80
		scratch_load_dword v19, off, s62 offset:84
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v32, v16
		v_mov_b32_e32 v33, v17
		v_mov_b32_e32 v34, v18
		v_mov_b32_e32 v35, v19
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v16, off, s62 offset:88
		scratch_load_dword v17, off, s62 offset:92
		scratch_load_dword v18, off, s62 offset:96
		scratch_load_dword v19, off, s62 offset:100
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v36, v16
		v_mov_b32_e32 v37, v17
		v_mov_b32_e32 v38, v18
		v_mov_b32_e32 v39, v19
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(20)
		scratch_load_dword v16, off, s62 offset:104
		scratch_load_dword v17, off, s62 offset:108
		scratch_load_dword v18, off, s62 offset:112
		scratch_load_dword v19, off, s62 offset:116
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v40, v16
		v_mov_b32_e32 v41, v17
		v_mov_b32_e32 v42, v18
		v_mov_b32_e32 v43, v19
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v16, off, s62 offset:120
		scratch_load_dword v17, off, s62 offset:124
		scratch_load_dword v18, off, s62 offset:128
		scratch_load_dword v19, off, s62 offset:132
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v44, v16
		v_mov_b32_e32 v45, v17
		v_mov_b32_e32 v46, v18
		v_mov_b32_e32 v47, v19
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(12)
		scratch_load_dword v16, off, s62 offset:136
		scratch_load_dword v17, off, s62 offset:140
		scratch_load_dword v18, off, s62 offset:144
		scratch_load_dword v19, off, s62 offset:148
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v48, v16
		v_mov_b32_e32 v49, v17
		v_mov_b32_e32 v50, v18
		v_mov_b32_e32 v51, v19
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v16, off, s62 offset:152
		scratch_load_dword v17, off, s62 offset:156
		scratch_load_dword v18, off, s62 offset:160
		scratch_load_dword v19, off, s62 offset:164
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v52, v16
		v_mov_b32_e32 v53, v17
		v_mov_b32_e32 v54, v18
		v_mov_b32_e32 v55, v19
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v16, off, s62 offset:168
		scratch_load_dword v17, off, s62 offset:172
		scratch_load_dword v18, off, s62 offset:176
		scratch_load_dword v19, off, s62 offset:180
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v56, v16
		v_mov_b32_e32 v57, v17
		v_mov_b32_e32 v58, v18
		v_mov_b32_e32 v59, v19
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v16, off, s62 offset:184
		scratch_load_dword v17, off, s62 offset:188
		scratch_load_dword v18, off, s62 offset:192
		scratch_load_dword v19, off, s62 offset:196
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v60, v16
		v_mov_b32_e32 v61, v17
		v_mov_b32_e32 v62, v18
		v_mov_b32_e32 v63, v19
		v_mov_b32_e32 v64, v188
		v_mov_b32_e32 v65, v189
		v_mov_b32_e32 v66, v190
		v_mov_b32_e32 v67, v191
		v_mov_b32_e32 v2, v71
		v_mov_b32_e32 v18, v92
		v_mov_b32_e32 v19, v93
		v_mov_b32_e32 v17, v106
		v_mov_b32_e32 v68, v107
		v_mov_b32_e32 v69, v134
		v_mov_b32_e32 v70, v135
		s_mov_b32 m0, s15
		v_mov_b32_e32 v16, v192
		ds_write_addtid_b32 v2 offset:23552
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_mov_b32 m0, s15
		s_waitcnt lgkmcnt(0)
		s_nop 0
		ds_read_addtid_b32 v1 offset:23552
		s_add_i32 s0, s12, -1
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], a[0:3], v[36:39], v[12:15], v1, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s0, s0, 1
		s_lshl_b32 s0, s0, 16
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v2, 13, v2
		v_add_u32_e32 v3, s0, v2
		v_and_b32_e32 v4, 15, v0
		v_lshlrev_b32_e32 v4, 6, v4
		v_and_b32_e32 v5, 63, v0
		v_lshrrev_b32_e32 v5, 4, v5
		v_and_b32_e32 v6, 15, v0
		v_lshrrev_b32_e32 v6, 1, v6
		v_bitop3_b32 v5, v5, v6, 3 bitop3:0x78
		v_lshlrev_b32_e32 v5, 4, v5
		v_add3_u32 v3, v3, v4, v5
		v_add_u32_e32 v6, 0x400, v3
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		ds_read_b128 v[8:11], v6 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], a[0:3], v[40:43], v[112:115], v1, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v6, 0x400, v3
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		ds_read_b128 v[72:75], v6 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[0:3], v[44:47], v[128:131], v1, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v6, 0x400, v3
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		ds_read_b128 v[76:79], v6 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[0:3], v[48:51], v[136:139], v1, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v6, 0x400, v3
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		ds_read_b128 v[80:83], v6 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[0:3], v[52:55], v[140:143], v1, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v6, 0x400, v3
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		ds_read_b128 v[84:87], v6 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[0:3], v[56:59], v[144:147], v1, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v6, 0x400, v3
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		ds_read_b128 v[88:91], v6 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[0:3], v[60:63], v[148:151], v1, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v6, 0x400, v3
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		ds_read_b128 v[92:95], v6 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[0:3], v[64:67], v[152:155], v1, v16 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
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
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[96:99], v3 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[4:7], v[36:39], v[156:159], v1, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		v_add_u32_e32 v3, s0, v4
		ds_read_addtid_b32 v6
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v3, v3, v6, v5
		v_add_u32_e32 v6, 0x400, v3
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		ds_read_b128 v[100:103], v6 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[4:7], v[40:43], v[160:163], v1, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v6, 0x400, v3
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		ds_read_b128 v[104:107], v6 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[4:7], v[44:47], v[164:167], v1, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v6, 0x400, v3
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		ds_read_b128 v[108:111], v6 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[4:7], v[48:51], v[168:171], v1, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v6, 0x400, v3
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		ds_read_b128 v[116:119], v6 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[4:7], v[52:55], v[172:175], v1, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v6, 0x400, v3
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		ds_read_b128 v[120:123], v6 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[4:7], v[56:59], v[176:179], v1, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v6, 0x400, v3
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		ds_read_b128 v[124:127], v6 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[4:7], v[60:63], v[180:183], v1, v16 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v6, 0x400, v3
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x400, v6
		ds_read_b128 v[132:135], v6 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[4:7], v[64:67], v[184:187], v1, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
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
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[188:191], v3 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[8:11], v[36:39], a[16:19], v18, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[8:11], v[40:43], a[20:23], v18, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[12:15], v[40:43], a[52:55], v18, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[12:15], v[36:39], a[48:51], v18, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[12:15], v[44:47], a[56:59], v18, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[8:11], v[44:47], a[24:27], v18, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[8:11], v[48:51], a[28:31], v18, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[12:15], v[48:51], a[60:63], v18, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[12:15], v[52:55], a[64:67], v18, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[8:11], v[52:55], a[32:35], v18, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[8:11], v[56:59], a[36:39], v18, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[12:15], v[56:59], a[68:71], v18, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[12:15], v[60:63], a[72:75], v18, v16 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[8:11], v[60:63], a[40:43], v18, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[8:11], v[64:67], a[44:47], v18, v16 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[12:15], v[64:67], a[76:79], v18, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[20:23], v[64:67], a[108:111], v19, v16 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[20:23], v[60:63], a[104:107], v19, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[24:27], v[60:63], a[136:139], v19, v16 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[24:27], v[64:67], a[140:143], v19, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[24:27], v[36:39], a[112:115], v19, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[20:23], v[36:39], a[80:83], v19, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[20:23], v[40:43], a[84:87], v19, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[24:27], v[40:43], a[116:119], v19, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[24:27], v[44:47], a[120:123], v19, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[20:23], v[44:47], a[88:91], v19, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[20:23], v[48:51], a[92:95], v19, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[24:27], v[48:51], a[124:127], v19, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[24:27], v[52:55], a[128:131], v19, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[20:23], v[52:55], a[96:99], v19, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[20:23], v[56:59], a[100:103], v19, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[24:27], v[56:59], a[132:135], v19, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[28:31], v[56:59], a[164:167], v17, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[28:31], v[52:55], a[160:163], v17, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[32:35], v[52:55], a[192:195], v17, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[32:35], v[56:59], a[196:199], v17, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[32:35], v[36:39], a[176:179], v17, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[28:31], v[36:39], a[144:147], v17, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[28:31], v[40:43], a[148:151], v17, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[32:35], v[40:43], a[180:183], v17, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[32:35], v[44:47], a[184:187], v17, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[28:31], v[44:47], a[152:155], v17, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[28:31], v[48:51], a[156:159], v17, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[32:35], v[48:51], a[188:191], v17, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[32:35], v[60:63], a[200:203], v17, v16 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[28:31], v[60:63], a[168:171], v17, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[28:31], v[64:67], a[172:175], v17, v16 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[32:35], v[64:67], a[204:207], v17, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[92:95], v[132:135], a[168:171], v17, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[92:95], v[188:191], a[172:175], v17, v16 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[96:99], v[188:191], a[204:207], v17, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[96:99], v[132:135], a[200:203], v17, v16 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[8:11], v[132:135], v[148:151], v1, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[8:11], v[188:191], v[152:155], v1, v16 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[72:75], v[188:191], v[184:187], v1, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[72:75], v[132:135], v[180:183], v1, v16 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[72:75], v[100:103], v[156:159], v1, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[8:11], v[100:103], v[12:15], v1, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[8:11], v[104:107], v[112:115], v1, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[72:75], v[104:107], v[160:163], v1, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[72:75], v[108:111], v[164:167], v1, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[8:11], v[108:111], v[128:131], v1, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[8:11], v[116:119], v[136:139], v1, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[72:75], v[116:119], v[168:171], v1, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[72:75], v[120:123], v[172:175], v1, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[8:11], v[120:123], v[140:143], v1, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[8:11], v[124:127], v[144:147], v1, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[72:75], v[124:127], v[176:179], v1, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[76:79], v[124:127], a[36:39], v18, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[76:79], v[120:123], a[32:35], v18, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[80:83], v[120:123], a[64:67], v18, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[80:83], v[124:127], a[68:71], v18, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[80:83], v[100:103], a[48:51], v18, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[76:79], v[100:103], a[16:19], v18, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[76:79], v[104:107], a[20:23], v18, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[80:83], v[104:107], a[52:55], v18, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[80:83], v[108:111], a[56:59], v18, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[76:79], v[108:111], a[24:27], v18, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[76:79], v[116:119], a[28:31], v18, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[80:83], v[116:119], a[60:63], v18, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[80:83], v[132:135], a[72:75], v18, v16 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[76:79], v[132:135], a[40:43], v18, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[76:79], v[188:191], a[44:47], v18, v16 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[80:83], v[188:191], a[76:79], v18, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[84:87], v[188:191], a[108:111], v19, v16 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[84:87], v[132:135], a[104:107], v19, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[88:91], v[132:135], a[136:139], v19, v16 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[88:91], v[188:191], a[140:143], v19, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[88:91], v[100:103], a[112:115], v19, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[84:87], v[100:103], a[80:83], v19, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[84:87], v[104:107], a[84:87], v19, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[88:91], v[104:107], a[116:119], v19, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[88:91], v[108:111], a[120:123], v19, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[84:87], v[108:111], a[88:91], v19, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[84:87], v[116:119], a[92:95], v19, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[88:91], v[116:119], a[124:127], v19, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[88:91], v[120:123], a[128:131], v19, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[84:87], v[120:123], a[96:99], v19, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[84:87], v[124:127], a[100:103], v19, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[88:91], v[124:127], a[132:135], v19, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[92:95], v[124:127], a[164:167], v17, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[92:95], v[120:123], a[160:163], v17, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[96:99], v[120:123], a[192:195], v17, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[96:99], v[124:127], a[196:199], v17, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[96:99], v[100:103], a[176:179], v17, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[92:95], v[100:103], a[144:147], v17, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[92:95], v[104:107], a[148:151], v17, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[96:99], v[104:107], a[180:183], v17, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[96:99], v[108:111], a[184:187], v17, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[92:95], v[108:111], a[152:155], v17, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[92:95], v[116:119], a[156:159], v17, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[96:99], v[116:119], a[188:191], v17, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s0, s12, 1
		s_lshl_b32 s1, s0, 16
		v_add_u32_e32 v1, s1, v2
		v_add3_u32 v1, v1, v4, v5
		v_add_u32_e32 v2, 0x400, v1
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[8:11], v2
		v_add_u32_e32 v2, 0x400, v1
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[16:19], v2 offset:1024
		v_add_u32_e32 v2, 0x400, v1
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[20:23], v2 offset:2048
		v_add_u32_e32 v2, 0x400, v1
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[24:27], v2 offset:3072
		v_add_u32_e32 v2, 0x400, v1
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[28:31], v2 offset:4096
		v_add_u32_e32 v2, 0x400, v1
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[32:35], v2 offset:5120
		v_add_u32_e32 v2, 0x400, v1
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[36:39], v2 offset:6144
		v_add_u32_e32 v2, 0x400, v1
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
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[40:43], v2 offset:7168
		s_mov_b32 m0, s15
		v_add_u32_e32 v2, s1, v4
		ds_read_addtid_b32 v3
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v2, v2, v3, v5
		v_add_u32_e32 v3, 0x400, v2
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
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[4:7], v3 offset:32768
		v_add_u32_e32 v3, 0x400, v2
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
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[44:47], v3 offset:33792
		v_add_u32_e32 v3, 0x400, v2
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
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[48:51], v3 offset:34816
		v_add_u32_e32 v3, 0x400, v2
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
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[52:55], v3 offset:35840
		v_add_u32_e32 v3, 0x400, v2
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
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[56:59], v3 offset:36864
		v_add_u32_e32 v3, 0x400, v2
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
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[60:63], v3 offset:37888
		v_add_u32_e32 v3, 0x400, v2
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
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[64:67], v3 offset:38912
		v_add_u32_e32 v3, 0x400, v2
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
		v_add_u32_e32 v3, 0x800, v3
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
		v_add_u32_e32 v73, 0x400, v3
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
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		ds_read_b32 v74, v73
		v_add_u32_e32 v73, 0x400, v3
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
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		ds_read_b32 v75, v73 offset:256
		v_add_u32_e32 v73, 0x400, v3
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
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x400, v73
		ds_read_b32 v76, v73 offset:512
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
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b32 v73, v3 offset:768
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v3 offset:1024
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v3, s0, v72, v3
		v_add_u32_e32 v72, 0x400, v3
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
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		ds_read_b32 v77, v72 offset:2048
		v_add_u32_e32 v72, 0x400, v3
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
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		ds_read_b32 v78, v72 offset:2304
		v_add_u32_e32 v72, 0x400, v3
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
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x400, v72
		ds_read_b32 v79, v72 offset:2560
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
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b32 v72, v3 offset:2816
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[8:11], v[4:7], v[12:15], v74, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x400, v1
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
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[80:83], v3 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[8:11], v[44:47], v[112:115], v74, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x400, v1
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
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[84:87], v3 offset:17408
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[8:11], v[48:51], v[128:131], v74, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x400, v1
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
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[88:91], v3 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[8:11], v[52:55], v[136:139], v74, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x400, v1
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
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[92:95], v3 offset:19456
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[8:11], v[56:59], v[140:143], v74, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x400, v1
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
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[96:99], v3 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[8:11], v[60:63], v[144:147], v74, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x400, v1
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
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[100:103], v3 offset:21504
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[8:11], v[64:67], v[148:151], v74, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x400, v1
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
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[104:107], v3 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[8:11], v[68:71], v[152:155], v74, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
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
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		ds_read_b128 v[8:11], v1 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[16:19], v[4:7], v[156:159], v74, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x400, v2
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
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		ds_read_b128 v[108:111], v1 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[16:19], v[44:47], v[160:163], v74, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x400, v2
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
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		ds_read_b128 v[116:119], v1 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[16:19], v[48:51], v[164:167], v74, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x400, v2
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
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		ds_read_b128 v[120:123], v1 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[16:19], v[52:55], v[168:171], v74, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x400, v2
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
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		ds_read_b128 v[124:127], v1 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[16:19], v[56:59], v[172:175], v74, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x400, v2
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
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		ds_read_b128 v[132:135], v1 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[16:19], v[60:63], v[176:179], v74, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x400, v2
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
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		ds_read_b128 v[188:191], v1 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[16:19], v[64:67], v[180:183], v74, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x400, v2
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
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		ds_read_b128 v[192:195], v1 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[16:19], v[68:71], v[184:187], v74, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x400, v2
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
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x400, v1
		ds_read_b128 v[16:19], v1 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[20:23], v[4:7], a[16:19], v75, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[20:23], v[44:47], a[20:23], v75, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[24:27], v[44:47], a[52:55], v75, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[24:27], v[4:7], a[48:51], v75, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[24:27], v[48:51], a[56:59], v75, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[20:23], v[48:51], a[24:27], v75, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[20:23], v[52:55], a[28:31], v75, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[24:27], v[52:55], a[60:63], v75, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[24:27], v[56:59], a[64:67], v75, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[20:23], v[56:59], a[32:35], v75, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[20:23], v[60:63], a[36:39], v75, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[24:27], v[60:63], a[68:71], v75, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[24:27], v[64:67], a[72:75], v75, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[20:23], v[64:67], a[40:43], v75, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[20:23], v[68:71], a[44:47], v75, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[24:27], v[68:71], a[76:79], v75, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[28:31], v[68:71], a[108:111], v76, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[28:31], v[64:67], a[104:107], v76, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[32:35], v[64:67], a[136:139], v76, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[32:35], v[68:71], a[140:143], v76, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[32:35], v[4:7], a[112:115], v76, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[28:31], v[4:7], a[80:83], v76, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[28:31], v[44:47], a[84:87], v76, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[32:35], v[44:47], a[116:119], v76, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[32:35], v[48:51], a[120:123], v76, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[28:31], v[48:51], a[88:91], v76, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[28:31], v[52:55], a[92:95], v76, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[32:35], v[52:55], a[124:127], v76, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[32:35], v[56:59], a[128:131], v76, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[28:31], v[56:59], a[96:99], v76, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[28:31], v[60:63], a[100:103], v76, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[32:35], v[60:63], a[132:135], v76, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[36:39], v[60:63], a[164:167], v73, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], v[56:59], a[160:163], v73, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[40:43], v[56:59], a[192:195], v73, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[40:43], v[60:63], a[196:199], v73, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[40:43], v[4:7], a[176:179], v73, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[36:39], v[4:7], a[144:147], v73, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[36:39], v[44:47], a[148:151], v73, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[40:43], v[44:47], a[180:183], v73, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[40:43], v[48:51], a[184:187], v73, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[36:39], v[48:51], a[152:155], v73, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[36:39], v[52:55], a[156:159], v73, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[40:43], v[52:55], a[188:191], v73, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[40:43], v[64:67], a[200:203], v73, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[36:39], v[64:67], a[168:171], v73, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[36:39], v[68:71], a[172:175], v73, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[40:43], v[68:71], a[204:207], v73, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[104:107], v[192:195], a[168:171], v73, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[104:107], v[16:19], a[172:175], v73, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[8:11], v[16:19], a[204:207], v73, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[8:11], v[192:195], a[200:203], v73, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[80:83], v[192:195], v[148:151], v74, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[80:83], v[16:19], v[152:155], v74, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[84:87], v[16:19], v[184:187], v74, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[84:87], v[192:195], v[180:183], v74, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[84:87], v[108:111], v[156:159], v74, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[80:83], v[108:111], v[12:15], v74, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[80:83], v[116:119], v[112:115], v74, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[84:87], v[116:119], v[160:163], v74, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[84:87], v[120:123], v[164:167], v74, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[80:83], v[120:123], v[128:131], v74, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[80:83], v[124:127], v[136:139], v74, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[84:87], v[124:127], v[168:171], v74, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[84:87], v[132:135], v[172:175], v74, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[80:83], v[132:135], v[140:143], v74, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[80:83], v[188:191], v[144:147], v74, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[84:87], v[188:191], v[176:179], v74, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[88:91], v[188:191], a[36:39], v75, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[88:91], v[132:135], a[32:35], v75, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[92:95], v[132:135], a[64:67], v75, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[92:95], v[188:191], a[68:71], v75, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[92:95], v[108:111], a[48:51], v75, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[88:91], v[108:111], a[16:19], v75, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[88:91], v[116:119], a[20:23], v75, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[92:95], v[116:119], a[52:55], v75, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[92:95], v[120:123], a[56:59], v75, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[88:91], v[120:123], a[24:27], v75, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[88:91], v[124:127], a[28:31], v75, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[92:95], v[124:127], a[60:63], v75, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[92:95], v[192:195], a[72:75], v75, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[88:91], v[192:195], a[40:43], v75, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[88:91], v[16:19], a[44:47], v75, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[92:95], v[16:19], a[76:79], v75, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[96:99], v[16:19], a[108:111], v76, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[96:99], v[192:195], a[104:107], v76, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[100:103], v[192:195], a[136:139], v76, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[100:103], v[16:19], a[140:143], v76, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[100:103], v[108:111], a[112:115], v76, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[96:99], v[108:111], a[80:83], v76, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[96:99], v[116:119], a[84:87], v76, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[100:103], v[116:119], a[116:119], v76, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[100:103], v[120:123], a[120:123], v76, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[96:99], v[120:123], a[88:91], v76, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[96:99], v[124:127], a[92:95], v76, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[100:103], v[124:127], a[124:127], v76, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[100:103], v[132:135], a[128:131], v76, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[96:99], v[132:135], a[96:99], v76, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[96:99], v[188:191], a[100:103], v76, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[100:103], v[188:191], a[132:135], v76, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[104:107], v[188:191], a[164:167], v73, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[104:107], v[132:135], a[160:163], v73, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[8:11], v[132:135], a[192:195], v73, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[8:11], v[188:191], a[196:199], v73, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[8:11], v[108:111], a[176:179], v73, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[104:107], v[108:111], a[144:147], v73, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[104:107], v[116:119], a[148:151], v73, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[8:11], v[116:119], a[180:183], v73, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[8:11], v[120:123], a[184:187], v73, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[104:107], v[120:123], a[152:155], v73, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[104:107], v[124:127], a[156:159], v73, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[8:11], v[124:127], a[188:191], v73, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
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
		v_cvt_pk_f16_f32 v2, v112, v113
		v_cvt_pk_f16_f32 v3, v114, v115
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:512
		v_cvt_pk_f16_f32 v2, v128, v129
		v_cvt_pk_f16_f32 v3, v130, v131
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
		v_cvt_pk_f16_f32 v2, v184, v185
		v_cvt_pk_f16_f32 v3, v186, v187
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a16
		v_accvgpr_read_b32 v2, a17
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a18
		v_accvgpr_read_b32 v2, a19
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x2000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen
		v_accvgpr_read_b32 v1, a20
		v_accvgpr_read_b32 v2, a21
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a22
		v_accvgpr_read_b32 v2, a23
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:512
		v_accvgpr_read_b32 v1, a24
		v_accvgpr_read_b32 v2, a25
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a26
		v_accvgpr_read_b32 v2, a27
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1024
		v_accvgpr_read_b32 v1, a28
		v_accvgpr_read_b32 v2, a29
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a30
		v_accvgpr_read_b32 v2, a31
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1536
		v_accvgpr_read_b32 v1, a32
		v_accvgpr_read_b32 v2, a33
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a34
		v_accvgpr_read_b32 v2, a35
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2048
		v_accvgpr_read_b32 v1, a36
		v_accvgpr_read_b32 v2, a37
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a38
		v_accvgpr_read_b32 v2, a39
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2560
		v_accvgpr_read_b32 v1, a40
		v_accvgpr_read_b32 v2, a41
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a42
		v_accvgpr_read_b32 v2, a43
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3072
		v_accvgpr_read_b32 v1, a44
		v_accvgpr_read_b32 v2, a45
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a46
		v_accvgpr_read_b32 v2, a47
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a48
		v_accvgpr_read_b32 v2, a49
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a50
		v_accvgpr_read_b32 v2, a51
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x3000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen
		v_accvgpr_read_b32 v1, a52
		v_accvgpr_read_b32 v2, a53
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a54
		v_accvgpr_read_b32 v2, a55
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:512
		v_accvgpr_read_b32 v1, a56
		v_accvgpr_read_b32 v2, a57
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a58
		v_accvgpr_read_b32 v2, a59
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1024
		v_accvgpr_read_b32 v1, a60
		v_accvgpr_read_b32 v2, a61
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a62
		v_accvgpr_read_b32 v2, a63
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1536
		v_accvgpr_read_b32 v1, a64
		v_accvgpr_read_b32 v2, a65
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a66
		v_accvgpr_read_b32 v2, a67
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2048
		v_accvgpr_read_b32 v1, a68
		v_accvgpr_read_b32 v2, a69
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a70
		v_accvgpr_read_b32 v2, a71
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2560
		v_accvgpr_read_b32 v1, a72
		v_accvgpr_read_b32 v2, a73
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a74
		v_accvgpr_read_b32 v2, a75
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3072
		v_accvgpr_read_b32 v1, a76
		v_accvgpr_read_b32 v2, a77
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a78
		v_accvgpr_read_b32 v2, a79
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a80
		v_accvgpr_read_b32 v2, a81
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a82
		v_accvgpr_read_b32 v2, a83
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x4000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen
		v_accvgpr_read_b32 v1, a84
		v_accvgpr_read_b32 v2, a85
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a86
		v_accvgpr_read_b32 v2, a87
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:512
		v_accvgpr_read_b32 v1, a88
		v_accvgpr_read_b32 v2, a89
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a90
		v_accvgpr_read_b32 v2, a91
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1024
		v_accvgpr_read_b32 v1, a92
		v_accvgpr_read_b32 v2, a93
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a94
		v_accvgpr_read_b32 v2, a95
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1536
		v_accvgpr_read_b32 v1, a96
		v_accvgpr_read_b32 v2, a97
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a98
		v_accvgpr_read_b32 v2, a99
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2048
		v_accvgpr_read_b32 v1, a100
		v_accvgpr_read_b32 v2, a101
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a102
		v_accvgpr_read_b32 v2, a103
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2560
		v_accvgpr_read_b32 v1, a104
		v_accvgpr_read_b32 v2, a105
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a106
		v_accvgpr_read_b32 v2, a107
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3072
		v_accvgpr_read_b32 v1, a108
		v_accvgpr_read_b32 v2, a109
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a110
		v_accvgpr_read_b32 v2, a111
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a112
		v_accvgpr_read_b32 v2, a113
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a114
		v_accvgpr_read_b32 v2, a115
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x5000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen
		v_accvgpr_read_b32 v1, a116
		v_accvgpr_read_b32 v2, a117
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a118
		v_accvgpr_read_b32 v2, a119
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:512
		v_accvgpr_read_b32 v1, a120
		v_accvgpr_read_b32 v2, a121
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a122
		v_accvgpr_read_b32 v2, a123
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1024
		v_accvgpr_read_b32 v1, a124
		v_accvgpr_read_b32 v2, a125
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a126
		v_accvgpr_read_b32 v2, a127
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1536
		v_accvgpr_read_b32 v1, a128
		v_accvgpr_read_b32 v2, a129
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a130
		v_accvgpr_read_b32 v2, a131
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2048
		v_accvgpr_read_b32 v1, a132
		v_accvgpr_read_b32 v2, a133
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a134
		v_accvgpr_read_b32 v2, a135
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2560
		v_accvgpr_read_b32 v1, a136
		v_accvgpr_read_b32 v2, a137
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a138
		v_accvgpr_read_b32 v2, a139
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3072
		v_accvgpr_read_b32 v1, a140
		v_accvgpr_read_b32 v2, a141
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a142
		v_accvgpr_read_b32 v2, a143
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a144
		v_accvgpr_read_b32 v2, a145
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a146
		v_accvgpr_read_b32 v2, a147
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x6000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen
		v_accvgpr_read_b32 v1, a148
		v_accvgpr_read_b32 v2, a149
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a150
		v_accvgpr_read_b32 v2, a151
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:512
		v_accvgpr_read_b32 v1, a152
		v_accvgpr_read_b32 v2, a153
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a154
		v_accvgpr_read_b32 v2, a155
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1024
		v_accvgpr_read_b32 v1, a156
		v_accvgpr_read_b32 v2, a157
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a158
		v_accvgpr_read_b32 v2, a159
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1536
		v_accvgpr_read_b32 v1, a160
		v_accvgpr_read_b32 v2, a161
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a162
		v_accvgpr_read_b32 v2, a163
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2048
		v_accvgpr_read_b32 v1, a164
		v_accvgpr_read_b32 v2, a165
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a166
		v_accvgpr_read_b32 v2, a167
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2560
		v_accvgpr_read_b32 v1, a168
		v_accvgpr_read_b32 v2, a169
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a170
		v_accvgpr_read_b32 v2, a171
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3072
		v_accvgpr_read_b32 v1, a172
		v_accvgpr_read_b32 v2, a173
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a174
		v_accvgpr_read_b32 v2, a175
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a176
		v_accvgpr_read_b32 v2, a177
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a178
		v_accvgpr_read_b32 v2, a179
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s0, s0, 0x7000
		s_add_i32 s0, s0, s1
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen
		v_accvgpr_read_b32 v1, a180
		v_accvgpr_read_b32 v2, a181
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a182
		v_accvgpr_read_b32 v2, a183
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:512
		v_accvgpr_read_b32 v1, a184
		v_accvgpr_read_b32 v2, a185
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a186
		v_accvgpr_read_b32 v2, a187
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:1024
		v_accvgpr_read_b32 v1, a188
		v_accvgpr_read_b32 v2, a189
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a190
		v_accvgpr_read_b32 v2, a191
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:1536
		v_accvgpr_read_b32 v1, a192
		v_accvgpr_read_b32 v2, a193
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a194
		v_accvgpr_read_b32 v2, a195
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:2048
		v_accvgpr_read_b32 v1, a196
		v_accvgpr_read_b32 v2, a197
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a198
		v_accvgpr_read_b32 v2, a199
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:2560
		v_accvgpr_read_b32 v1, a200
		v_accvgpr_read_b32 v2, a201
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a202
		v_accvgpr_read_b32 v2, a203
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:3072
		v_accvgpr_read_b32 v1, a204
		v_accvgpr_read_b32 v2, a205
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a206
		v_accvgpr_read_b32 v2, a207
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:3584
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 24576
		.amdhsa_private_segment_fixed_size 200
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
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 200
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
    .private_segment_fixed_size: 200
    .sgpr_count:     65
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     512
    .agpr_count:     256
    .vgpr_spill_count: 50
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 112
    wave.regalloc.agpr.dwords: 304
    wave.regalloc.remat.dwords: 12
    wave.regalloc.sgpr_to_vgpr.dwords: 0
    wave.regalloc.lds.dwords: 24
    wave.regalloc.scratch.dwords: 50
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
