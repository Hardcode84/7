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
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v7, v6, v8, s11
		buffer_load_dwordx4 v16, s[20:23], 0 offen lds
		v_add3_u32 v16, v6, v8, s16
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v8, v6, v8, s17
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add3_u32 v3, v6, v9, s19
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v17, v6, v9, s32
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		v_add3_u32 v7, v6, v9, s33
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v9, s34, v10
		buffer_load_dwordx4 v16, s[20:23], 0 offen lds
		v_add_u32_e32 v16, s35, v10
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v10, v10, s32, 64
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		v_add3_u32 v8, v6, v11, s36
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v18, v6, v11, s37
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add3_u32 v3, v6, v11, s38
		s_add_i32 m0, m0, 0x1000
		v_mov_b32_e32 v11, 0x80040
		buffer_load_dwordx4 v17, s[0:3], 0 offen lds
		v_mov_b32_e32 v17, 0x40040
		s_add_i32 m0, m0, 0x1000
		v_mov_b32_e32 v19, 64
		buffer_load_dwordx4 v7, s[0:3], 0 offen lds
		v_mov_b32_e32 v7, 0xc0000
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v20, v2, v5
		buffer_load_dwordx4 v9, s[0:3], 0 offen lds
		v_add_u32_e32 v9, v2, v5
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v21, v2, v5
		buffer_load_dwordx4 v16, s[0:3], 0 offen lds
		v_add_u32_e32 v16, v2, v5
		s_add_i32 m0, m0, 0x1000
		v_add_u32_e32 v22, v2, v5
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		v_lshlrev_b32_e32 v10, 2, v4
		s_add_i32 m0, m0, 0x1000
		v_lshrrev_b32_e32 v23, 4, v4
		buffer_load_dwordx4 v8, s[0:3], 0 offen lds
		s_and_b32 s8, s39, 1
		s_add_i32 m0, m0, 0x1000
		v_and_b32_e32 v1, 1, v1
		buffer_load_dwordx4 v18, s[0:3], 0 offen lds
		v_lshlrev_b32_e32 v4, 4, v4
		s_add_i32 m0, m0, 0x1000
		s_lshl_b32 s9, s14, 16
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
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b128 a[0:3], v26
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b128 a[4:7], v26 offset:1024
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b128 a[8:11], v26 offset:2048
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b128 a[12:15], v26 offset:3072
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b128 v[28:31], v26 offset:4096
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b128 v[32:35], v26 offset:5120
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b128 v[36:39], v26 offset:6144
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x400, v24
		ds_read_b128 v[40:43], v24 offset:7168
		v_lshlrev_b32_e32 v1, 13, v1
		v_add3_u32 v24, v25, v1, v23
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b128 v[44:47], v26 offset:32768
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b128 v[48:51], v26 offset:33792
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b128 v[52:55], v26 offset:34816
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b128 v[56:59], v26 offset:35840
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b128 v[60:63], v26 offset:36864
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b128 v[64:67], v26 offset:37888
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b128 v[68:71], v26 offset:38912
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x400, v24
		ds_read_b128 v[72:75], v24 offset:39936
		v_add_u32_e32 v24, 0x20000, v8
		v_add_u32_e32 v24, v24, v10
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b32 v27, v26
		s_mov_b32 m0, s15
		s_waitcnt lgkmcnt(0)
		s_nop 0
		ds_write_addtid_b32 v27 offset:23552
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b32 v27, v26 offset:256
		v_add_u32_e32 v26, 0x800, v24
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x800, v26
		v_add_u32_e32 v26, 0x400, v26
		ds_read_b32 v76, v26 offset:512
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x400, v24
		ds_read_b32 v26, v24 offset:768
		v_add_u32_e32 v10, 0x20000, v10
		v_add_u32_e32 v10, v10, v18
		v_add_u32_e32 v24, 0x800, v10
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x400, v24
		ds_read_b32 v77, v24 offset:2048
		v_add_u32_e32 v24, 0x800, v10
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x400, v24
		ds_read_b32 v78, v24 offset:2304
		v_add_u32_e32 v24, 0x800, v10
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x400, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x800, v24
		v_add_u32_e32 v24, 0x400, v24
		ds_read_b32 v79, v24 offset:2560
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x400, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
		v_add_u32_e32 v10, 0x800, v10
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
		s_add_i32 m0, s40, 0x16000
		v_add3_u32 v2, v2, v5, v6
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		v_add3_u32 v2, v6, v22, s10
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v5, v6, v22, s16
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		v_add3_u32 v2, v6, v22, s17
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v10, v6, v16, s19
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		v_add3_u32 v5, v6, v16, s33
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v16, v6, v16, s34
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		v_add3_u32 v2, v6, v21, s35
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v22, v6, v21, s36
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		v_add3_u32 v10, v6, v21, s37
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v21, v6, v9, s38
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		v_add3_u32 v5, v6, v9, s41
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v9, v6, v9, s42
		buffer_load_dwordx4 v16, s[20:23], 0 offen lds
		v_add3_u32 v16, v6, v20, s43
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v80, v6, v20, s44
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		v_add3_u32 v2, v6, v20, s32
		s_add_i32 m0, m0, 0x1000
		v_mov_b32_e32 v6, 0x80000
		buffer_load_dwordx4 v22, s[0:3], 0 offen lds
		v_mov_b32_e32 v20, 0x40000
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s16, 0x80
		s_mov_b32 s17, 0
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		s_mov_b32 s32, 16
		s_mov_b32 s33, 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b32_e32 v10, 3
		buffer_load_dwordx4 v21, s[0:3], 0 offen lds
		s_mov_b32 s34, 0x1000
		s_mov_b32 s35, 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b32_e32 v21, 63
		buffer_load_dwordx4 v5, s[0:3], 0 offen lds
		s_mov_b32 s36, 0x10000
		s_mov_b32 s37, 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b32_e32 v82, v0
		buffer_load_dwordx4 v9, s[0:3], 0 offen lds
		s_mov_b32 s42, 1
		s_mov_b32 s43, 0
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s44, 0x100000
		s_mov_b32 s45, 0
		buffer_load_dwordx4 v16, s[0:3], 0 offen lds
		v_mov_b32_e32 v85, 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b32_e32 v84, s13
		buffer_load_dwordx4 v80, s[0:3], 0 offen lds
		s_mov_b32 s10, 2
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s5, s5, 0x800
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
		v_mov_b32_e32 v80, s42
		v_mov_b32_e32 v81, s43
		v_mov_b32_e32 v83, 0
		v_mul_lo_u32 v86, v80, v82
		v_mul_hi_u32 v87, v80, v82
		v_mul_lo_u32 v2, v80, v83
		v_add_u32_e32 v87, v87, v2
		v_mul_lo_u32 v2, v81, v82
		v_add_u32_e32 v87, v87, v2
		v_lshrrev_b64 v[88:89], 6, v[86:87]
		v_mov_b32_e32 v90, s36
		v_mov_b32_e32 v91, s37
		v_mul_lo_u32 v92, v90, v88
		v_mul_hi_u32 v93, v90, v88
		v_mul_lo_u32 v2, v90, v89
		v_add_u32_e32 v93, v93, v2
		v_mul_lo_u32 v2, v91, v88
		v_add_u32_e32 v93, v93, v2
		v_add_co_u32_e64 v94, vcc, v8, v92
		v_addc_co_u32_e64 v95, vcc, v9, v93, vcc
		v_and_b32_e32 v96, v82, v21
		v_and_b32_e32 v97, v85, v85
		v_mul_lo_u32 v82, v80, v96
		v_mul_hi_u32 v83, v80, v96
		v_mul_lo_u32 v2, v80, v97
		v_add_u32_e32 v83, v83, v2
		v_mul_lo_u32 v2, v81, v96
		v_add_u32_e32 v83, v83, v2
		v_lshrrev_b64 v[80:81], 2, v[82:83]
		v_mov_b32_e32 v98, s34
		v_mov_b32_e32 v99, s35
		v_mul_lo_u32 v100, v98, v80
		v_mul_hi_u32 v101, v98, v80
		v_mul_lo_u32 v2, v98, v81
		v_add_u32_e32 v101, v101, v2
		v_mul_lo_u32 v2, v99, v80
		v_add_u32_e32 v101, v101, v2
		v_add_co_u32_e64 v80, vcc, v94, v100
		v_addc_co_u32_e64 v81, vcc, v95, v101, vcc
		v_lshrrev_b64 v[94:95], 3, v[82:83]
		v_and_b32_e32 v82, v94, v10
		v_and_b32_e32 v83, v95, v85
		v_and_b32_e32 v94, v96, v10
		v_and_b32_e32 v95, v97, v85
		v_xor_b32_e32 v82, v82, v94
		v_xor_b32_e32 v83, v83, v95
		v_mov_b32_e32 v94, s32
		v_mov_b32_e32 v95, s33
		v_mul_lo_u32 v98, v94, v82
		v_mul_hi_u32 v99, v94, v82
		v_mul_lo_u32 v2, v94, v83
		v_add_u32_e32 v99, v99, v2
		v_mul_lo_u32 v2, v95, v82
		v_add_u32_e32 v99, v99, v2
		v_add_co_u32_e64 v82, vcc, v80, v98
		v_addc_co_u32_e64 v83, vcc, v81, v99, vcc
		v_mov_b32_e32 v80, s16
		v_mov_b32_e32 v81, s17
		v_add_co_u32_e64 v102, vcc, v8, v20
		v_addc_co_u32_e64 v103, vcc, v9, 0, vcc
		v_add_co_u32_e64 v104, vcc, v102, v92
		v_addc_co_u32_e64 v105, vcc, v103, v93, vcc
		v_add_co_u32_e64 v102, vcc, v104, v100
		v_addc_co_u32_e64 v103, vcc, v105, v101, vcc
		v_add_co_u32_e64 v104, vcc, v102, v98
		v_addc_co_u32_e64 v105, vcc, v103, v99, vcc
		v_add_co_u32_e64 v102, vcc, v8, v6
		v_addc_co_u32_e64 v103, vcc, v9, 0, vcc
		v_add_co_u32_e64 v106, vcc, v102, v92
		v_addc_co_u32_e64 v107, vcc, v103, v93, vcc
		v_add_co_u32_e64 v102, vcc, v106, v100
		v_addc_co_u32_e64 v103, vcc, v107, v101, vcc
		v_add_co_u32_e64 v106, vcc, v102, v98
		v_addc_co_u32_e64 v107, vcc, v103, v99, vcc
		v_add_co_u32_e64 v102, vcc, v8, v7
		v_addc_co_u32_e64 v103, vcc, v9, 0, vcc
		v_add_co_u32_e64 v108, vcc, v102, v92
		v_addc_co_u32_e64 v109, vcc, v103, v93, vcc
		v_add_co_u32_e64 v102, vcc, v108, v100
		v_addc_co_u32_e64 v103, vcc, v109, v101, vcc
		v_add_co_u32_e64 v108, vcc, v102, v98
		v_addc_co_u32_e64 v109, vcc, v103, v99, vcc
		v_add_co_u32_e64 v102, vcc, v8, v19
		v_addc_co_u32_e64 v103, vcc, v9, 0, vcc
		v_add_co_u32_e64 v110, vcc, v102, v92
		v_addc_co_u32_e64 v111, vcc, v103, v93, vcc
		v_add_co_u32_e64 v102, vcc, v110, v100
		v_addc_co_u32_e64 v103, vcc, v111, v101, vcc
		v_add_co_u32_e64 v110, vcc, v102, v98
		v_addc_co_u32_e64 v111, vcc, v103, v99, vcc
		v_add_co_u32_e64 v102, vcc, v8, v17
		v_addc_co_u32_e64 v103, vcc, v9, 0, vcc
		v_add_co_u32_e64 v112, vcc, v102, v92
		v_addc_co_u32_e64 v113, vcc, v103, v93, vcc
		v_add_co_u32_e64 v102, vcc, v112, v100
		v_addc_co_u32_e64 v103, vcc, v113, v101, vcc
		v_add_co_u32_e64 v112, vcc, v102, v98
		v_addc_co_u32_e64 v113, vcc, v103, v99, vcc
		v_add_co_u32_e64 v102, vcc, v8, v11
		v_addc_co_u32_e64 v103, vcc, v9, 0, vcc
		v_add_co_u32_e64 v114, vcc, v102, v92
		v_addc_co_u32_e64 v115, vcc, v103, v93, vcc
		v_add_co_u32_e64 v102, vcc, v114, v100
		v_addc_co_u32_e64 v103, vcc, v115, v101, vcc
		v_add_co_u32_e64 v114, vcc, v102, v98
		v_addc_co_u32_e64 v115, vcc, v103, v99, vcc
		v_mov_b32_e32 v2, 0xc0040
		v_add_co_u32_e64 v102, vcc, v8, v2
		v_addc_co_u32_e64 v103, vcc, v9, 0, vcc
		v_add_co_u32_e64 v116, vcc, v102, v92
		v_addc_co_u32_e64 v117, vcc, v103, v93, vcc
		v_add_co_u32_e64 v102, vcc, v116, v100
		v_addc_co_u32_e64 v103, vcc, v117, v101, vcc
		v_add_co_u32_e64 v116, vcc, v102, v98
		v_addc_co_u32_e64 v117, vcc, v103, v99, vcc
		v_mov_b32_e32 v102, s14
		v_mov_b32_e32 v103, 0
		v_mul_lo_u32 v118, v4, v102
		v_mul_hi_u32 v119, v4, v102
		v_mul_lo_u32 v10, v4, v103
		v_add_u32_e32 v119, v119, v10
		v_mul_lo_u32 v10, v5, v102
		v_add_u32_e32 v119, v119, v10
		v_add_co_u32_e64 v4, vcc, v118, v92
		v_addc_co_u32_e64 v5, vcc, v119, v93, vcc
		v_add_co_u32_e64 v120, vcc, v4, v100
		v_addc_co_u32_e64 v121, vcc, v5, v101, vcc
		v_add_co_u32_e64 v4, vcc, v120, v98
		v_addc_co_u32_e64 v5, vcc, v121, v99, vcc
		v_add_co_u32_e64 v120, vcc, v118, v20
		v_addc_co_u32_e64 v121, vcc, v119, 0, vcc
		v_add_co_u32_e64 v20, vcc, v120, v92
		v_addc_co_u32_e64 v21, vcc, v121, v93, vcc
		v_add_co_u32_e64 v120, vcc, v20, v100
		v_addc_co_u32_e64 v121, vcc, v21, v101, vcc
		v_add_co_u32_e64 v20, vcc, v120, v98
		v_addc_co_u32_e64 v21, vcc, v121, v99, vcc
		v_add_co_u32_e64 v120, vcc, v118, v6
		v_addc_co_u32_e64 v121, vcc, v119, 0, vcc
		v_add_co_u32_e64 v122, vcc, v120, v92
		v_addc_co_u32_e64 v123, vcc, v121, v93, vcc
		v_add_co_u32_e64 v120, vcc, v122, v100
		v_addc_co_u32_e64 v121, vcc, v123, v101, vcc
		v_add_co_u32_e64 v122, vcc, v120, v98
		v_addc_co_u32_e64 v123, vcc, v121, v99, vcc
		v_add_co_u32_e64 v120, vcc, v118, v7
		v_addc_co_u32_e64 v121, vcc, v119, 0, vcc
		v_add_co_u32_e64 v6, vcc, v120, v92
		v_addc_co_u32_e64 v7, vcc, v121, v93, vcc
		v_add_co_u32_e64 v120, vcc, v6, v100
		v_addc_co_u32_e64 v121, vcc, v7, v101, vcc
		v_add_co_u32_e64 v6, vcc, v120, v98
		v_addc_co_u32_e64 v7, vcc, v121, v99, vcc
		v_add_co_u32_e64 v120, vcc, v118, v19
		v_addc_co_u32_e64 v121, vcc, v119, 0, vcc
		v_add_co_u32_e64 v18, vcc, v120, v92
		v_addc_co_u32_e64 v19, vcc, v121, v93, vcc
		v_add_co_u32_e64 v120, vcc, v18, v100
		v_addc_co_u32_e64 v121, vcc, v19, v101, vcc
		v_add_co_u32_e64 v18, vcc, v120, v98
		v_addc_co_u32_e64 v19, vcc, v121, v99, vcc
		v_add_co_u32_e64 v120, vcc, v118, v17
		v_addc_co_u32_e64 v121, vcc, v119, 0, vcc
		v_add_co_u32_e64 v16, vcc, v120, v92
		v_addc_co_u32_e64 v17, vcc, v121, v93, vcc
		v_add_co_u32_e64 v120, vcc, v16, v100
		v_addc_co_u32_e64 v121, vcc, v17, v101, vcc
		v_add_co_u32_e64 v16, vcc, v120, v98
		v_addc_co_u32_e64 v17, vcc, v121, v99, vcc
		v_add_co_u32_e64 v120, vcc, v118, v11
		v_addc_co_u32_e64 v121, vcc, v119, 0, vcc
		v_add_co_u32_e64 v10, vcc, v120, v92
		v_addc_co_u32_e64 v11, vcc, v121, v93, vcc
		v_add_co_u32_e64 v120, vcc, v10, v100
		v_addc_co_u32_e64 v121, vcc, v11, v101, vcc
		v_add_co_u32_e64 v10, vcc, v120, v98
		v_addc_co_u32_e64 v11, vcc, v121, v99, vcc
		v_add_co_u32_e64 v120, vcc, v118, v2
		v_addc_co_u32_e64 v121, vcc, v119, 0, vcc
		v_add_co_u32_e64 v124, vcc, v120, v92
		v_addc_co_u32_e64 v125, vcc, v121, v93, vcc
		v_add_co_u32_e64 v120, vcc, v124, v100
		v_addc_co_u32_e64 v121, vcc, v125, v101, vcc
		v_add_co_u32_e64 v124, vcc, v120, v98
		v_addc_co_u32_e64 v125, vcc, v121, v99, vcc
		v_mul_lo_u32 v120, v90, v102
		v_mul_hi_u32 v121, v90, v102
		v_mul_lo_u32 v2, v90, v103
		v_add_u32_e32 v121, v121, v2
		v_mul_lo_u32 v2, v91, v102
		v_add_u32_e32 v121, v121, v2
		v_add_co_u32_e64 v90, vcc, v8, v120
		v_addc_co_u32_e64 v91, vcc, v9, v121, vcc
		v_lshrrev_b64 v[102:103], 7, v[86:87]
		s_mov_b32 s16, 0x400
		s_mov_b32 s17, 0
		v_mov_b32_e32 v86, s16
		v_mov_b32_e32 v87, s17
		v_mul_lo_u32 v126, v86, v102
		v_mul_hi_u32 v127, v86, v102
		v_mul_lo_u32 v2, v86, v103
		v_add_u32_e32 v127, v127, v2
		v_mul_lo_u32 v2, v87, v102
		v_add_u32_e32 v127, v127, v2
		v_add_co_u32_e64 v102, vcc, v90, v126
		v_addc_co_u32_e64 v103, vcc, v91, v127, vcc
		v_mul_lo_u32 v128, v94, v96
		v_mul_hi_u32 v129, v94, v96
		v_mul_lo_u32 v2, v94, v97
		v_add_u32_e32 v129, v129, v2
		v_mul_lo_u32 v2, v95, v96
		v_add_u32_e32 v129, v129, v2
		v_add_co_u32_e64 v94, vcc, v102, v128
		v_addc_co_u32_e64 v95, vcc, v103, v129, vcc
		s_mov_b32 s16, 0x800
		s_mov_b32 s17, 0
		v_mov_b32_e32 v96, s16
		v_mov_b32_e32 v97, s17
		v_add_co_u32_e64 v102, vcc, v90, v128
		v_addc_co_u32_e64 v103, vcc, v91, v129, vcc
		v_mov_b32_e32 v2, 1
		v_and_b32_e32 v90, v88, v2
		v_and_b32_e32 v91, v89, v85
		v_mul_lo_u32 v84, v86, v90
		v_mul_hi_u32 v85, v86, v90
		v_mul_lo_u32 v2, v86, v91
		v_add_u32_e32 v85, v85, v2
		v_mul_lo_u32 v2, v87, v90
		v_add_u32_e32 v85, v85, v2
		v_add_co_u32_e64 v86, vcc, v102, v84
		v_addc_co_u32_e64 v87, vcc, v103, v85, vcc
		v_mov_b32_e32 v2, 0x80
		v_add_co_u32_e64 v88, vcc, v8, v2
		v_addc_co_u32_e64 v89, vcc, v9, 0, vcc
		v_add_co_u32_e64 v90, vcc, v88, v92
		v_addc_co_u32_e64 v91, vcc, v89, v93, vcc
		v_add_co_u32_e64 v88, vcc, v90, v100
		v_addc_co_u32_e64 v89, vcc, v91, v101, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v90, vcc, v88, v98
		v_addc_co_u32_e64 v91, vcc, v89, v99, vcc
		ds_write_addtid_b32 v90
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v91 offset:1024
		v_mov_b32_e32 v22, 0x40080
		v_add_co_u32_e64 v88, vcc, v8, v22
		v_addc_co_u32_e64 v89, vcc, v9, 0, vcc
		v_add_co_u32_e64 v90, vcc, v88, v92
		v_addc_co_u32_e64 v91, vcc, v89, v93, vcc
		v_add_co_u32_e64 v88, vcc, v90, v100
		v_addc_co_u32_e64 v89, vcc, v91, v101, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v90, vcc, v88, v98
		v_addc_co_u32_e64 v91, vcc, v89, v99, vcc
		ds_write_addtid_b32 v90 offset:2048
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v91 offset:3072
		v_mov_b32_e32 v88, 0x80080
		v_add_co_u32_e64 v90, vcc, v8, v88
		v_addc_co_u32_e64 v91, vcc, v9, 0, vcc
		v_add_co_u32_e64 v102, vcc, v90, v92
		v_addc_co_u32_e64 v103, vcc, v91, v93, vcc
		v_add_co_u32_e64 v90, vcc, v102, v100
		v_addc_co_u32_e64 v91, vcc, v103, v101, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v102, vcc, v90, v98
		v_addc_co_u32_e64 v103, vcc, v91, v99, vcc
		ds_write_addtid_b32 v102 offset:4096
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v103 offset:5120
		v_mov_b32_e32 v89, 0xc0080
		v_add_co_u32_e64 v90, vcc, v8, v89
		v_addc_co_u32_e64 v91, vcc, v9, 0, vcc
		v_add_co_u32_e64 v102, vcc, v90, v92
		v_addc_co_u32_e64 v103, vcc, v91, v93, vcc
		v_add_co_u32_e64 v90, vcc, v102, v100
		v_addc_co_u32_e64 v91, vcc, v103, v101, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v102, vcc, v90, v98
		v_addc_co_u32_e64 v103, vcc, v91, v99, vcc
		ds_write_addtid_b32 v102 offset:6144
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v103 offset:7168
		v_mov_b32_e32 v90, 0xc0
		v_add_co_u32_e64 v102, vcc, v8, v90
		v_addc_co_u32_e64 v103, vcc, v9, 0, vcc
		v_add_co_u32_e64 v130, vcc, v102, v92
		v_addc_co_u32_e64 v131, vcc, v103, v93, vcc
		v_add_co_u32_e64 v102, vcc, v130, v100
		v_addc_co_u32_e64 v103, vcc, v131, v101, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v130, vcc, v102, v98
		v_addc_co_u32_e64 v131, vcc, v103, v99, vcc
		ds_write_addtid_b32 v130 offset:8192
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v131 offset:9216
		v_mov_b32_e32 v91, 0x400c0
		v_add_co_u32_e64 v102, vcc, v8, v91
		v_addc_co_u32_e64 v103, vcc, v9, 0, vcc
		v_add_co_u32_e64 v130, vcc, v102, v92
		v_addc_co_u32_e64 v131, vcc, v103, v93, vcc
		v_add_co_u32_e64 v102, vcc, v130, v100
		v_addc_co_u32_e64 v103, vcc, v131, v101, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v130, vcc, v102, v98
		v_addc_co_u32_e64 v131, vcc, v103, v99, vcc
		ds_write_addtid_b32 v130 offset:10240
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v131 offset:11264
		v_mov_b32_e32 v102, 0x800c0
		v_add_co_u32_e64 v130, vcc, v8, v102
		v_addc_co_u32_e64 v131, vcc, v9, 0, vcc
		v_add_co_u32_e64 v132, vcc, v130, v92
		v_addc_co_u32_e64 v133, vcc, v131, v93, vcc
		v_add_co_u32_e64 v130, vcc, v132, v100
		v_addc_co_u32_e64 v131, vcc, v133, v101, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v132, vcc, v130, v98
		v_addc_co_u32_e64 v133, vcc, v131, v99, vcc
		ds_write_addtid_b32 v132 offset:12288
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v133 offset:13312
		v_mov_b32_e32 v103, 0xc00c0
		v_add_co_u32_e64 v130, vcc, v8, v103
		v_addc_co_u32_e64 v131, vcc, v9, 0, vcc
		v_add_co_u32_e64 v132, vcc, v130, v92
		v_addc_co_u32_e64 v133, vcc, v131, v93, vcc
		v_add_co_u32_e64 v130, vcc, v132, v100
		v_addc_co_u32_e64 v131, vcc, v133, v101, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v132, vcc, v130, v98
		v_addc_co_u32_e64 v133, vcc, v131, v99, vcc
		ds_write_addtid_b32 v132 offset:14336
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v133 offset:15360
		v_add_co_u32_e64 v130, vcc, v118, v2
		v_addc_co_u32_e64 v131, vcc, v119, 0, vcc
		v_add_co_u32_e64 v132, vcc, v130, v92
		v_addc_co_u32_e64 v133, vcc, v131, v93, vcc
		v_add_co_u32_e64 v130, vcc, v132, v100
		v_addc_co_u32_e64 v131, vcc, v133, v101, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v132, vcc, v130, v98
		v_addc_co_u32_e64 v133, vcc, v131, v99, vcc
		ds_write_addtid_b32 v132 offset:17408
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v133 offset:18432
		v_add_co_u32_e64 v130, vcc, v118, v22
		v_addc_co_u32_e64 v131, vcc, v119, 0, vcc
		v_add_co_u32_e64 v132, vcc, v130, v92
		v_addc_co_u32_e64 v133, vcc, v131, v93, vcc
		v_add_co_u32_e64 v130, vcc, v132, v100
		v_addc_co_u32_e64 v131, vcc, v133, v101, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v132, vcc, v130, v98
		v_addc_co_u32_e64 v133, vcc, v131, v99, vcc
		ds_write_addtid_b32 v132 offset:19456
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v133 offset:20480
		v_add_co_u32_e64 v130, vcc, v118, v88
		v_addc_co_u32_e64 v131, vcc, v119, 0, vcc
		v_add_co_u32_e64 v132, vcc, v130, v92
		v_addc_co_u32_e64 v133, vcc, v131, v93, vcc
		v_add_co_u32_e64 v130, vcc, v132, v100
		v_addc_co_u32_e64 v131, vcc, v133, v101, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v132, vcc, v130, v98
		v_addc_co_u32_e64 v133, vcc, v131, v99, vcc
		ds_write_addtid_b32 v132 offset:21504
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v133 offset:22528
		v_add_co_u32_e64 v130, vcc, v118, v89
		v_addc_co_u32_e64 v131, vcc, v119, 0, vcc
		v_add_co_u32_e64 v88, vcc, v130, v92
		v_addc_co_u32_e64 v89, vcc, v131, v93, vcc
		v_add_co_u32_e64 v130, vcc, v88, v100
		v_addc_co_u32_e64 v131, vcc, v89, v101, vcc
		v_add_co_u32_e64 v88, vcc, v130, v98
		v_addc_co_u32_e64 v89, vcc, v131, v99, vcc
		s_mov_b32 s4, 0
		scratch_store_dword off, v88, s4
		scratch_store_dword off, v89, s4 offset:4
		v_add_co_u32_e64 v88, vcc, v118, v90
		v_addc_co_u32_e64 v89, vcc, v119, 0, vcc
		v_add_co_u32_e64 v130, vcc, v88, v92
		v_addc_co_u32_e64 v131, vcc, v89, v93, vcc
		v_add_co_u32_e64 v88, vcc, v130, v100
		v_addc_co_u32_e64 v89, vcc, v131, v101, vcc
		v_add_co_u32_e64 v130, vcc, v88, v98
		v_addc_co_u32_e64 v131, vcc, v89, v99, vcc
		s_mov_b32 s4, 0
		scratch_store_dword off, v130, s4 offset:8
		scratch_store_dword off, v131, s4 offset:12
		v_add_co_u32_e64 v88, vcc, v118, v91
		v_addc_co_u32_e64 v89, vcc, v119, 0, vcc
		v_add_co_u32_e64 v90, vcc, v88, v92
		v_addc_co_u32_e64 v91, vcc, v89, v93, vcc
		v_add_co_u32_e64 v88, vcc, v90, v100
		v_addc_co_u32_e64 v89, vcc, v91, v101, vcc
		v_add_co_u32_e64 v90, vcc, v88, v98
		v_addc_co_u32_e64 v91, vcc, v89, v99, vcc
		v_add_co_u32_e64 v88, vcc, v118, v102
		v_addc_co_u32_e64 v89, vcc, v119, 0, vcc
		v_add_co_u32_e64 v130, vcc, v88, v92
		v_addc_co_u32_e64 v131, vcc, v89, v93, vcc
		v_add_co_u32_e64 v88, vcc, v130, v100
		v_addc_co_u32_e64 v89, vcc, v131, v101, vcc
		v_add_co_u32_e64 v130, vcc, v88, v98
		v_addc_co_u32_e64 v131, vcc, v89, v99, vcc
		v_add_co_u32_e64 v88, vcc, v118, v103
		v_addc_co_u32_e64 v89, vcc, v119, 0, vcc
		v_add_co_u32_e64 v102, vcc, v88, v92
		v_addc_co_u32_e64 v103, vcc, v89, v93, vcc
		v_add_co_u32_e64 v88, vcc, v102, v100
		v_addc_co_u32_e64 v89, vcc, v103, v101, vcc
		v_add_co_u32_e64 v92, vcc, v88, v98
		v_addc_co_u32_e64 v93, vcc, v89, v99, vcc
		v_mov_b32_e32 v2, 0x800
		v_add_co_u32_e64 v88, vcc, v8, v2
		v_addc_co_u32_e64 v89, vcc, v9, 0, vcc
		v_add_co_u32_e64 v8, vcc, v88, v120
		v_addc_co_u32_e64 v9, vcc, v89, v121, vcc
		v_add_co_u32_e64 v88, vcc, v8, v126
		v_addc_co_u32_e64 v89, vcc, v9, v127, vcc
		v_add_co_u32_e64 v98, vcc, v88, v128
		v_addc_co_u32_e64 v99, vcc, v89, v129, vcc
		v_add_co_u32_e64 v88, vcc, v8, v128
		v_addc_co_u32_e64 v89, vcc, v9, v129, vcc
		v_add_co_u32_e64 v8, vcc, v88, v84
		v_addc_co_u32_e64 v9, vcc, v89, v85, vcc
		v_mov_b32_e32 v84, s10
		v_mov_b32_e32 v85, 0
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
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
		v_mov_b32_e32 v84, s10
		v_mul_lo_u32 v88, v80, v84
		v_mul_hi_u32 v89, v80, v84
		v_mul_lo_u32 v2, v80, v85
		v_add_u32_e32 v89, v89, v2
		v_mul_lo_u32 v2, v81, v84
		v_add_u32_e32 v89, v89, v2
		v_add_co_u32_e64 v118, vcc, v82, v88
		v_addc_co_u32_e64 v119, vcc, v83, v89, vcc
		v_add_co_u32_e64 v120, vcc, v104, v88
		v_addc_co_u32_e64 v121, vcc, v105, v89, vcc
		v_add_co_u32_e64 v126, vcc, v106, v88
		v_addc_co_u32_e64 v127, vcc, v107, v89, vcc
		v_add_co_u32_e64 v128, vcc, v108, v88
		v_addc_co_u32_e64 v129, vcc, v109, v89, vcc
		v_add_co_u32_e64 v184, vcc, v110, v88
		v_addc_co_u32_e64 v185, vcc, v111, v89, vcc
		v_add_co_u32_e64 v186, vcc, v112, v88
		v_addc_co_u32_e64 v187, vcc, v113, v89, vcc
		v_add_co_u32_e64 v188, vcc, v114, v88
		v_addc_co_u32_e64 v189, vcc, v115, v89, vcc
		v_add_co_u32_e64 v190, vcc, v116, v88
		v_addc_co_u32_e64 v191, vcc, v117, v89, vcc
		v_add_co_u32_e64 v192, vcc, v4, v88
		v_addc_co_u32_e64 v193, vcc, v5, v89, vcc
		v_add_co_u32_e64 v194, vcc, v20, v88
		v_addc_co_u32_e64 v195, vcc, v21, v89, vcc
		v_add_co_u32_e64 v196, vcc, v122, v88
		v_addc_co_u32_e64 v197, vcc, v123, v89, vcc
		v_add_co_u32_e64 v198, vcc, v6, v88
		v_addc_co_u32_e64 v199, vcc, v7, v89, vcc
		v_add_co_u32_e64 v200, vcc, v18, v88
		v_addc_co_u32_e64 v201, vcc, v19, v89, vcc
		v_add_co_u32_e64 v202, vcc, v16, v88
		v_addc_co_u32_e64 v203, vcc, v17, v89, vcc
		v_add_co_u32_e64 v204, vcc, v10, v88
		v_addc_co_u32_e64 v205, vcc, v11, v89, vcc
		v_add_co_u32_e64 v206, vcc, v124, v88
		v_addc_co_u32_e64 v207, vcc, v125, v89, vcc
		v_mul_lo_u32 v208, v96, v84
		v_mul_hi_u32 v209, v96, v84
		v_mul_lo_u32 v2, v96, v85
		v_add_u32_e32 v209, v209, v2
		v_mul_lo_u32 v2, v97, v84
		v_add_u32_e32 v209, v209, v2
		v_add_co_u32_e64 v210, vcc, v94, v208
		v_addc_co_u32_e64 v211, vcc, v95, v209, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v212, vcc, v86, v208
		v_addc_co_u32_e64 v213, vcc, v87, v209, vcc
		s_waitcnt lgkmcnt(0)
		ds_read_addtid_b32 v2 offset:23552
		s_waitcnt vmcnt(20) lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], a[0:3], v[44:47], v[12:15], v2, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s4, s10, 1
		s_lshl_b32 s9, s4, 16
		v_add_u32_e32 v2, s9, v3
		v_add3_u32 v2, v2, v25, v23
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 a[212:215], v22 offset:16384
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v22 offset:23552
		s_waitcnt vmcnt(16) lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[0:3], v[48:51], v[100:103], v22, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 a[216:219], v22 offset:17408
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v22 offset:23552
		s_waitcnt vmcnt(12) lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[0:3], v[52:55], v[132:135], v22, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 a[220:223], v22 offset:18432
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v22 offset:23552
		s_waitcnt vmcnt(8) lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[0:3], v[56:59], v[136:139], v22, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 a[224:227], v22 offset:19456
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v22 offset:23552
		s_waitcnt vmcnt(4) lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[0:3], v[60:63], v[140:143], v22, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 a[228:231], v22 offset:20480
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v22 offset:23552
		s_waitcnt vmcnt(0) lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[0:3], v[64:67], v[144:147], v22, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 a[232:235], v22 offset:21504
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v22 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[0:3], v[68:71], v[148:151], v22, v24 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 a[236:239], v22 offset:22528
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v22 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[0:3], v[72:75], v[152:155], v22, v24 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 a[240:243], v2 offset:23552
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v2 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[4:7], v[44:47], v[156:159], v2, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, s9, v25
		v_add3_u32 v2, v2, v1, v23
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 a[244:247], v22 offset:49152
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v22 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[4:7], v[48:51], v[160:163], v22, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 a[248:251], v22 offset:50176
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v22 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[4:7], v[52:55], v[164:167], v22, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 a[252:255], v22 offset:51200
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v22 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[4:7], v[56:59], v[168:171], v22, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 v[216:219], v22 offset:52224
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v22 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[4:7], v[60:63], v[172:175], v22, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 v[220:223], v22 offset:53248
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v22 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[4:7], v[64:67], v[176:179], v22, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[224:227], v2 offset:54272
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v2 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[4:7], v[68:71], v[180:183], v2, v24 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s9, s10, 1
		s_lshl_b32 s9, s9, 16
		v_and_b32_e32 v2, 15, v0
		v_lshlrev_b32_e32 v22, 6, v2
		v_add_u32_e32 v22, s9, v22
		v_lshrrev_b32_e32 v214, 6, v0
		v_and_b32_e32 v214, 1, v214
		v_lshlrev_b32_e32 v214, 13, v214
		v_and_b32_e32 v215, 63, v0
		v_lshrrev_b32_e32 v215, 4, v215
		v_lshrrev_b32_e32 v2, 1, v2
		v_bitop3_b32 v2, v215, v2, 3 bitop3:0x78
		v_lshlrev_b32_e32 v2, 4, v2
		s_mov_b32 m0, s15
		v_add3_u32 v2, v22, v214, v2
		ds_write_addtid_b32 v2 offset:16384
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 v[228:231], v22 offset:55296
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v22 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[4:7], v[72:75], a[16:19], v22, v24 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_accvgpr_write_b32 a0, v22
		v_accvgpr_read_b32 v22, a0
		v_add_u32_e32 v22, 0x800, v22
		v_accvgpr_write_b32 a0, v22
		v_accvgpr_read_b32 v22, a0
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 v[232:235], v22 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[8:11], v[44:47], a[20:23], v27, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s40, 0x6000
		s_nop 0
		buffer_load_dwordx4 v118, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[8:11], v[48:51], a[24:27], v27, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v120, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[8:11], v[52:55], a[28:31], v27, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v126, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[8:11], v[56:59], a[32:35], v27, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v128, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[8:11], v[60:63], a[36:39], v27, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v184, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[8:11], v[64:67], a[40:43], v27, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v186, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[8:11], v[68:71], a[44:47], v27, v24 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v188, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[8:11], v[72:75], a[48:51], v27, v24 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v190, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[12:15], v[44:47], a[52:55], v27, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v192, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[12:15], v[48:51], a[56:59], v27, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v194, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[12:15], v[52:55], a[60:63], v27, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v196, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[12:15], v[56:59], a[64:67], v27, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v198, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[12:15], v[60:63], a[68:71], v27, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v200, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[12:15], v[64:67], a[72:75], v27, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v202, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[12:15], v[68:71], a[76:79], v27, v24 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v204, s[0:3], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[12:15], v[72:75], a[80:83], v27, v24 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v206, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[28:31], v[44:47], a[84:87], v76, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s9, s10, 1
		s_add_i32 m0, s11, 0x26000
		s_nop 0
		buffer_load_dwordx4 v210, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[28:31], v[48:51], a[88:91], v76, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshl_b32 s4, s4, 12
		s_add_i32 m0, s8, 0x26000
		s_nop 0
		buffer_load_dwordx4 v212, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[28:31], v[52:55], a[92:95], v76, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		s_and_b32 s16, s10, 1
		s_lshl_b32 s16, s16, 16
		v_lshrrev_b32_e32 v22, 7, v0
		v_lshlrev_b32_e32 v22, 13, v22
		v_add_u32_e32 v22, s16, v22
		v_and_b32_e32 v118, 15, v0
		v_lshlrev_b32_e32 v119, 6, v118
		v_and_b32_e32 v120, 63, v0
		v_lshrrev_b32_e32 v120, 4, v120
		v_lshrrev_b32_e32 v118, 1, v118
		v_bitop3_b32 v118, v120, v118, 3 bitop3:0x78
		v_lshlrev_b32_e32 v118, 4, v118
		v_add3_u32 v22, v22, v119, v118
		v_add_u32_e32 v118, 0x800, v22
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x400, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x400, v118
		ds_read_b128 a[0:3], v118
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[28:31], v[56:59], a[96:99], v76, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v118, 0x800, v22
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x400, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x400, v118
		ds_read_b128 a[4:7], v118 offset:1024
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[28:31], v[60:63], a[100:103], v76, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v118, 0x800, v22
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x400, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x400, v118
		ds_read_b128 a[8:11], v118 offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[28:31], v[64:67], a[104:107], v76, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v118, 0x800, v22
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x400, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x400, v118
		ds_read_b128 a[12:15], v118 offset:3072
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[28:31], v[68:71], a[108:111], v76, v24 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v118, 0x800, v22
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x400, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x800, v118
		v_add_u32_e32 v118, 0x400, v118
		ds_read_b128 v[184:187], v118 offset:4096
		s_mov_b32 s16, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v184, s16 offset:16
		scratch_store_dword off, v185, s16 offset:20
		scratch_store_dword off, v186, s16 offset:24
		scratch_store_dword off, v187, s16 offset:28
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[28:31], v[72:75], a[112:115], v76, v24 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v28, 0x800, v22
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		ds_read_b128 v[184:187], v28 offset:5120
		s_mov_b32 s16, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v184, s16 offset:32
		scratch_store_dword off, v185, s16 offset:36
		scratch_store_dword off, v186, s16 offset:40
		scratch_store_dword off, v187, s16 offset:44
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[32:35], v[44:47], a[116:119], v76, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v28, 0x800, v22
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		ds_read_b128 v[184:187], v28 offset:6144
		s_mov_b32 s16, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v184, s16 offset:48
		scratch_store_dword off, v185, s16 offset:52
		scratch_store_dword off, v186, s16 offset:56
		scratch_store_dword off, v187, s16 offset:60
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[32:35], v[48:51], a[120:123], v76, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 v[28:31], v22 offset:7168
		s_mov_b32 s16, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v28, s16 offset:64
		scratch_store_dword off, v29, s16 offset:68
		scratch_store_dword off, v30, s16 offset:72
		scratch_store_dword off, v31, s16 offset:76
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[32:35], v[52:55], a[124:127], v76, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 v[28:31], v22 offset:32768
		s_mov_b32 s16, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v28, s16 offset:80
		scratch_store_dword off, v29, s16 offset:84
		scratch_store_dword off, v30, s16 offset:88
		scratch_store_dword off, v31, s16 offset:92
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[32:35], v[56:59], a[128:131], v76, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 v[28:31], v22 offset:33792
		s_mov_b32 s16, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v28, s16 offset:96
		scratch_store_dword off, v29, s16 offset:100
		scratch_store_dword off, v30, s16 offset:104
		scratch_store_dword off, v31, s16 offset:108
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[32:35], v[60:63], a[132:135], v76, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 v[28:31], v22 offset:34816
		s_mov_b32 s16, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v28, s16 offset:112
		scratch_store_dword off, v29, s16 offset:116
		scratch_store_dword off, v30, s16 offset:120
		scratch_store_dword off, v31, s16 offset:124
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[32:35], v[64:67], a[136:139], v76, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 v[28:31], v22 offset:35840
		s_mov_b32 s16, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v28, s16 offset:128
		scratch_store_dword off, v29, s16 offset:132
		scratch_store_dword off, v30, s16 offset:136
		scratch_store_dword off, v31, s16 offset:140
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[32:35], v[68:71], a[140:143], v76, v24 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 v[28:31], v22 offset:36864
		s_mov_b32 s16, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v28, s16 offset:144
		scratch_store_dword off, v29, s16 offset:148
		scratch_store_dword off, v30, s16 offset:152
		scratch_store_dword off, v31, s16 offset:156
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], v[72:75], a[144:147], v76, v24 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b128 v[28:31], v22 offset:37888
		s_mov_b32 s16, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v28, s16 offset:160
		scratch_store_dword off, v29, s16 offset:164
		scratch_store_dword off, v30, s16 offset:168
		scratch_store_dword off, v31, s16 offset:172
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[36:39], v[44:47], a[148:151], v26, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[184:187], v2 offset:38912
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[36:39], v[48:51], a[152:155], v26, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v2 offset:16384
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[188:191], v2 offset:39936
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[36:39], v[52:55], a[156:159], v26, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s4, s4, 0x20000
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v2, 10, v2
		v_and_b32_e32 v22, 63, v0
		v_lshlrev_b32_e32 v22, 2, v22
		v_add3_u32 v28, s4, v2, v22
		v_add_u32_e32 v29, 0x800, v28
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x400, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x400, v29
		ds_read_b32 v118, v29
		v_add_u32_e32 v29, 0x800, v28
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x400, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x400, v29
		ds_read_b32 v119, v29 offset:256
		v_add_u32_e32 v29, 0x800, v28
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x400, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x400, v29
		ds_read_b32 v120, v29 offset:512
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x800, v28
		v_add_u32_e32 v28, 0x400, v28
		ds_read_b32 v121, v28 offset:768
		v_lshrrev_b32_e32 v28, 6, v0
		v_and_b32_e32 v28, 1, v28
		v_lshlrev_b32_e32 v28, 10, v28
		v_add3_u32 v29, s4, v22, v28
		v_add_u32_e32 v30, 0x800, v29
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x400, v30
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x400, v30
		ds_read_b32 v126, v30 offset:2048
		v_add_u32_e32 v30, 0x800, v29
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x400, v30
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x400, v30
		ds_read_b32 v127, v30 offset:2304
		v_add_u32_e32 v30, 0x800, v29
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x400, v30
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x800, v30
		v_add_u32_e32 v30, 0x400, v30
		ds_read_b32 v128, v30 offset:2560
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x400, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x400, v29
		ds_read_b32 v129, v29 offset:2816
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], v[56:59], a[160:163], v26, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[40:43], v[56:59], a[192:195], v26, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[40:43], v[52:55], a[188:191], v26, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[40:43], v[44:47], a[180:183], v26, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[40:43], v[48:51], a[184:187], v26, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[40:43], v[60:63], a[196:199], v26, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[36:39], v[60:63], a[164:167], v26, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[36:39], v[64:67], a[168:171], v26, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[40:43], v[64:67], a[200:203], v26, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[40:43], v[68:71], a[204:207], v26, v24 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[36:39], v[68:71], a[172:175], v26, v24 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[36:39], v[72:75], a[176:179], v26, v24 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[40:43], v[72:75], a[208:211], v26, v24 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[236:239], v[228:231], a[172:175], v26, v24 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[236:239], v[232:235], a[176:179], v26, v24 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[240:243], v[232:235], a[208:211], v26, v24 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[240:243], v[228:231], a[204:207], v26, v24 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v29 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[212:215], v[228:231], v[148:151], v29, v24 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v29 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[212:215], v[232:235], v[152:155], v29, v24 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v29 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[216:219], v[232:235], a[16:19], v29, v24 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v29 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[216:219], v[228:231], v[180:183], v29, v24 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v29 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[216:219], a[244:247], v[156:159], v29, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v29 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], a[212:215], a[244:247], v[12:15], v29, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v29 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[212:215], a[248:251], v[100:103], v29, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v29 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[216:219], a[248:251], v[160:163], v29, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v29 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[216:219], a[252:255], v[164:167], v29, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v29 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[212:215], a[252:255], v[132:135], v29, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v29 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[212:215], v[216:219], v[136:139], v29, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v29 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[216:219], v[216:219], v[168:171], v29, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v29 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[216:219], v[220:223], v[172:175], v29, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v29 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[212:215], v[220:223], v[140:143], v29, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v29 offset:23552
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[212:215], v[224:227], v[144:147], v29, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v29 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[216:219], v[224:227], v[176:179], v29, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[220:223], v[224:227], a[40:43], v27, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[220:223], v[220:223], a[36:39], v27, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[224:227], v[220:223], a[68:71], v27, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[224:227], v[224:227], a[72:75], v27, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[224:227], a[244:247], a[52:55], v27, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[220:223], a[244:247], a[20:23], v27, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[220:223], a[248:251], a[24:27], v27, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[224:227], a[248:251], a[56:59], v27, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[224:227], a[252:255], a[60:63], v27, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[220:223], a[252:255], a[28:31], v27, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[220:223], v[216:219], a[32:35], v27, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[224:227], v[216:219], a[64:67], v27, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[224:227], v[228:231], a[76:79], v27, v24 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[220:223], v[228:231], a[44:47], v27, v24 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[220:223], v[232:235], a[48:51], v27, v24 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[224:227], v[232:235], a[80:83], v27, v24 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[228:231], v[232:235], a[112:115], v76, v24 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[228:231], v[228:231], a[108:111], v76, v24 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[232:235], v[228:231], a[140:143], v76, v24 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[232:235], v[232:235], a[144:147], v76, v24 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[232:235], a[244:247], a[116:119], v76, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[228:231], a[244:247], a[84:87], v76, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], a[228:231], a[248:251], a[88:91], v76, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[232:235], a[248:251], a[120:123], v76, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[232:235], a[252:255], a[124:127], v76, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], a[228:231], a[252:255], a[92:95], v76, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[228:231], v[216:219], a[96:99], v76, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[232:235], v[216:219], a[128:131], v76, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[232:235], v[220:223], a[132:135], v76, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[228:231], v[220:223], a[100:103], v76, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[228:231], v[224:227], a[104:107], v76, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[232:235], v[224:227], a[136:139], v76, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[236:239], v[224:227], a[168:171], v26, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[236:239], v[220:223], a[164:167], v26, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[240:243], v[220:223], a[196:199], v26, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[240:243], v[224:227], a[200:203], v26, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[240:243], a[244:247], a[180:183], v26, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[236:239], a[244:247], a[148:151], v26, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[236:239], a[248:251], a[152:155], v26, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[240:243], a[248:251], a[184:187], v26, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[240:243], a[252:255], a[188:191], v26, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[236:239], a[252:255], a[156:159], v26, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[236:239], v[216:219], a[160:163], v26, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[240:243], v[216:219], a[192:195], v26, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s4, s9, 1
		s_lshl_b32 s9, s4, 16
		v_lshrrev_b32_e32 v24, 7, v0
		v_lshlrev_b32_e32 v24, 13, v24
		v_add_u32_e32 v24, s9, v24
		v_and_b32_e32 v26, 15, v0
		v_lshlrev_b32_e32 v26, 6, v26
		v_and_b32_e32 v27, 63, v0
		v_lshrrev_b32_e32 v27, 4, v27
		v_and_b32_e32 v29, 15, v0
		v_lshrrev_b32_e32 v29, 1, v29
		v_bitop3_b32 v27, v27, v29, 3 bitop3:0x78
		v_lshlrev_b32_e32 v27, 4, v27
		v_add3_u32 v24, v24, v26, v27
		v_add_u32_e32 v29, 0x800, v24
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x400, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x400, v29
		ds_read_b128 v[32:35], v29
		v_add_u32_e32 v29, 0x800, v24
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x400, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x400, v29
		ds_read_b128 v[36:39], v29 offset:1024
		v_add_u32_e32 v29, 0x800, v24
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x400, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x400, v29
		ds_read_b128 v[40:43], v29 offset:2048
		v_add_u32_e32 v29, 0x800, v24
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x400, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x400, v29
		ds_read_b128 v[44:47], v29 offset:3072
		v_add_u32_e32 v29, 0x800, v24
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x400, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x400, v29
		ds_read_b128 v[48:51], v29 offset:4096
		v_add_u32_e32 v29, 0x800, v24
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x400, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x400, v29
		ds_read_b128 v[52:55], v29 offset:5120
		v_add_u32_e32 v29, 0x800, v24
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x400, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x400, v29
		ds_read_b128 a[212:215], v29 offset:6144
		v_add_u32_e32 v29, 0x800, v24
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x400, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x800, v29
		v_add_u32_e32 v29, 0x400, v29
		ds_read_b128 a[216:219], v29 offset:7168
		v_add_u32_e32 v26, s9, v26
		v_lshrrev_b32_e32 v29, 6, v0
		v_and_b32_e32 v29, 1, v29
		v_lshlrev_b32_e32 v29, 13, v29
		v_add3_u32 v26, v26, v29, v27
		v_add_u32_e32 v27, 0x800, v26
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		ds_read_b128 a[220:223], v27 offset:32768
		v_add_u32_e32 v27, 0x800, v26
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		ds_read_b128 a[224:227], v27 offset:33792
		v_add_u32_e32 v27, 0x800, v26
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		ds_read_b128 a[228:231], v27 offset:34816
		v_add_u32_e32 v27, 0x800, v26
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		ds_read_b128 a[232:235], v27 offset:35840
		v_add_u32_e32 v27, 0x800, v26
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		ds_read_b128 a[236:239], v27 offset:36864
		v_add_u32_e32 v27, 0x800, v26
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		ds_read_b128 a[240:243], v27 offset:37888
		v_add_u32_e32 v27, 0x800, v26
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		ds_read_b128 v[56:59], v27 offset:38912
		v_add_u32_e32 v27, 0x800, v26
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		ds_read_b128 a[244:247], v27 offset:39936
		s_lshl_b32 s4, s4, 12
		s_add_i32 s4, s4, 0x20000
		v_add3_u32 v2, s4, v2, v22
		v_add_u32_e32 v27, 0x800, v2
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		ds_read_b32 v29, v27
		v_add_u32_e32 v27, 0x800, v2
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		ds_read_b32 v30, v27 offset:256
		v_add_u32_e32 v27, 0x800, v2
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x800, v27
		v_add_u32_e32 v27, 0x400, v27
		ds_read_b32 v31, v27 offset:512
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b32 v27, v2 offset:768
		v_add3_u32 v2, s4, v22, v28
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b32 v28, v22 offset:2048
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b32 v60, v22 offset:2304
		v_add_u32_e32 v22, 0x800, v2
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x800, v22
		v_add_u32_e32 v22, 0x400, v22
		ds_read_b32 v61, v22 offset:2560
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b32 v22, v2 offset:2816
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v62
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v63 offset:1024
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v64, vcc, v62, v88
		v_addc_co_u32_e64 v65, vcc, v63, v89, vcc
		ds_read_addtid_b32 v62 offset:2048
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v63 offset:3072
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v66, vcc, v62, v88
		v_addc_co_u32_e64 v67, vcc, v63, v89, vcc
		ds_read_addtid_b32 v62 offset:4096
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v63 offset:5120
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v68, vcc, v62, v88
		v_addc_co_u32_e64 v69, vcc, v63, v89, vcc
		ds_read_addtid_b32 v62 offset:6144
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v63 offset:7168
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v70, vcc, v62, v88
		v_addc_co_u32_e64 v71, vcc, v63, v89, vcc
		ds_read_addtid_b32 v62 offset:8192
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v63 offset:9216
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v72, vcc, v62, v88
		v_addc_co_u32_e64 v73, vcc, v63, v89, vcc
		ds_read_addtid_b32 v62 offset:10240
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v63 offset:11264
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v74, vcc, v62, v88
		v_addc_co_u32_e64 v75, vcc, v63, v89, vcc
		ds_read_addtid_b32 v62 offset:12288
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v63 offset:13312
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v76, vcc, v62, v88
		v_addc_co_u32_e64 v77, vcc, v63, v89, vcc
		ds_read_addtid_b32 v62 offset:14336
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v63 offset:15360
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v78, vcc, v62, v88
		v_addc_co_u32_e64 v79, vcc, v63, v89, vcc
		ds_read_addtid_b32 v62 offset:17408
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v63 offset:18432
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v192, vcc, v62, v88
		v_addc_co_u32_e64 v193, vcc, v63, v89, vcc
		ds_read_addtid_b32 v62 offset:19456
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v63 offset:20480
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v194, vcc, v62, v88
		v_addc_co_u32_e64 v195, vcc, v63, v89, vcc
		ds_read_addtid_b32 v62 offset:21504
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v63 offset:22528
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v196, vcc, v62, v88
		v_addc_co_u32_e64 v197, vcc, v63, v89, vcc
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(42)
		scratch_load_dword v62, off, s4
		scratch_load_dword v63, off, s4 offset:4
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v198, vcc, v62, v88
		v_addc_co_u32_e64 v199, vcc, v63, v89, vcc
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(40)
		scratch_load_dword v62, off, s4 offset:8
		scratch_load_dword v63, off, s4 offset:12
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v200, vcc, v62, v88
		v_addc_co_u32_e64 v201, vcc, v63, v89, vcc
		v_add_co_u32_e64 v62, vcc, v90, v88
		v_addc_co_u32_e64 v63, vcc, v91, v89, vcc
		v_add_co_u32_e64 v202, vcc, v130, v88
		v_addc_co_u32_e64 v203, vcc, v131, v89, vcc
		v_add_co_u32_e64 v204, vcc, v92, v88
		v_addc_co_u32_e64 v205, vcc, v93, v89, vcc
		v_add_co_u32_e64 v88, vcc, v98, v208
		v_addc_co_u32_e64 v89, vcc, v99, v209, vcc
		v_add_co_u32_e64 v206, vcc, v8, v208
		v_addc_co_u32_e64 v207, vcc, v9, v209, vcc
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[32:35], a[220:223], v[12:15], v29, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v24
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 a[248:251], v2 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[32:35], a[224:227], v[100:103], v29, v28 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v24
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 a[252:255], v2 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], a[228:231], v[132:135], v29, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v24
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[208:211], v2 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[32:35], a[232:235], v[136:139], v29, v60 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v24
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[212:215], v2 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[32:35], a[236:239], v[140:143], v29, v61 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v24
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[216:219], v2 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[32:35], a[240:243], v[144:147], v29, v61 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v24
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[220:223], v2 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[32:35], v[56:59], v[148:151], v29, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v24
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[224:227], v2 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[32:35], a[244:247], v[152:155], v29, v22 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v24
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[32:35], v2 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[36:39], a[220:223], v[156:159], v29, v28 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v26
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[228:231], v2 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[36:39], a[224:227], v[160:163], v29, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v26
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[232:235], v2 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[36:39], a[228:231], v[164:167], v29, v60 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v26
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[236:239], v2 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[36:39], a[232:235], v[168:171], v29, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v26
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[240:243], v2 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[36:39], a[236:239], v[172:175], v29, v61 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v26
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[244:247], v2 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[36:39], a[240:243], v[176:179], v29, v61 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v26
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[248:251], v2 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[36:39], v[56:59], v[180:183], v29, v22 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v26
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[252:255], v2 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[36:39], a[244:247], a[16:19], v29, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v26
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[36:39], v2 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[40:43], a[220:223], a[20:23], v30, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s40, 0x16000
		s_nop 0
		buffer_load_dwordx4 v64, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[40:43], a[224:227], a[24:27], v30, v28 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v66, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[40:43], a[228:231], a[28:31], v30, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v68, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[40:43], a[232:235], a[32:35], v30, v60 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v70, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[40:43], a[236:239], a[36:39], v30, v61 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v72, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[40:43], a[240:243], a[40:43], v30, v61 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v74, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[40:43], v[56:59], a[44:47], v30, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v76, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[40:43], a[244:247], a[48:51], v30, v22 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v78, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[44:47], a[220:223], a[52:55], v30, v28 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v192, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[44:47], a[224:227], a[56:59], v30, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v194, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[44:47], a[228:231], a[60:63], v30, v60 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v196, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[44:47], a[232:235], a[64:67], v30, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v198, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[44:47], a[236:239], a[68:71], v30, v61 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v200, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[44:47], a[240:243], a[72:75], v30, v61 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v62, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[44:47], v[56:59], a[76:79], v30, v22 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v202, s[0:3], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[44:47], a[244:247], a[80:83], v30, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v204, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[48:51], a[220:223], a[84:87], v31, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s11, 0x27000
		s_nop 0
		buffer_load_dwordx4 v88, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[48:51], a[224:227], a[88:91], v31, v28 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s8, 0x27000
		s_nop 0
		buffer_load_dwordx4 v206, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[48:51], a[228:231], a[92:95], v31, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[48:51], a[232:235], a[96:99], v31, v60 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[52:55], a[232:235], a[128:131], v31, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[52:55], a[228:231], a[124:127], v31, v60 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[52:55], a[220:223], a[116:119], v31, v28 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[52:55], a[224:227], a[120:123], v31, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[52:55], a[236:239], a[132:135], v31, v61 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[48:51], a[236:239], a[100:103], v31, v61 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[48:51], a[240:243], a[104:107], v31, v61 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[52:55], a[240:243], a[136:139], v31, v61 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[52:55], v[56:59], a[140:143], v31, v22 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[48:51], v[56:59], a[108:111], v31, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[48:51], a[244:247], a[112:115], v31, v22 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[52:55], a[244:247], a[144:147], v31, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[212:215], a[244:247], a[176:179], v27, v22 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[212:215], v[56:59], a[172:175], v27, v22 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[216:219], v[56:59], a[204:207], v27, v22 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[216:219], a[244:247], a[208:211], v27, v22 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[216:219], a[220:223], a[180:183], v27, v28 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[212:215], a[220:223], a[148:151], v27, v28 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[212:215], a[224:227], a[152:155], v27, v28 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[216:219], a[224:227], a[184:187], v27, v28 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[216:219], a[228:231], a[188:191], v27, v60 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[212:215], a[228:231], a[156:159], v27, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[212:215], a[232:235], a[160:163], v27, v60 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[216:219], a[232:235], a[192:195], v27, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[216:219], a[236:239], a[196:199], v27, v61 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[212:215], a[236:239], a[164:167], v27, v61 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[212:215], a[240:243], a[168:171], v27, v61 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[216:219], a[240:243], a[200:203], v27, v61 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		s_waitcnt lgkmcnt(7)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], a[248:251], v[228:231], v[12:15], v29, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[248:251], v[232:235], v[100:103], v29, v28 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[252:255], v[232:235], v[160:163], v29, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[252:255], v[228:231], v[156:159], v29, v28 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[252:255], v[236:239], v[164:167], v29, v60 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[248:251], v[236:239], v[132:135], v29, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[248:251], v[240:243], v[136:139], v29, v60 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[252:255], v[240:243], v[168:171], v29, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[252:255], v[244:247], v[172:175], v29, v61 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[248:251], v[244:247], v[140:143], v29, v61 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[248:251], v[248:251], v[144:147], v29, v61 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[252:255], v[248:251], v[176:179], v29, v61 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[252:255], v[252:255], v[180:183], v29, v22 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[248:251], v[252:255], v[148:151], v29, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[248:251], v[36:39], v[152:155], v29, v22 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[252:255], v[36:39], a[16:19], v29, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[208:211], v[36:39], a[48:51], v30, v22 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[208:211], v[252:255], a[44:47], v30, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[212:215], v[252:255], a[76:79], v30, v22 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[212:215], v[36:39], a[80:83], v30, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[212:215], v[228:231], a[52:55], v30, v28 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[208:211], v[228:231], a[20:23], v30, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[208:211], v[232:235], a[24:27], v30, v28 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[212:215], v[232:235], a[56:59], v30, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[212:215], v[236:239], a[60:63], v30, v60 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[208:211], v[236:239], a[28:31], v30, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[208:211], v[240:243], a[32:35], v30, v60 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[212:215], v[240:243], a[64:67], v30, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[212:215], v[244:247], a[68:71], v30, v61 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[208:211], v[244:247], a[36:39], v30, v61 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[208:211], v[248:251], a[40:43], v30, v61 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[212:215], v[248:251], a[72:75], v30, v61 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[216:219], v[248:251], a[104:107], v31, v61 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[216:219], v[244:247], a[100:103], v31, v61 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[220:223], v[244:247], a[132:135], v31, v61 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[220:223], v[248:251], a[136:139], v31, v61 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[220:223], v[228:231], a[116:119], v31, v28 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[216:219], v[228:231], a[84:87], v31, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[216:219], v[232:235], a[88:91], v31, v28 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[220:223], v[232:235], a[120:123], v31, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[220:223], v[236:239], a[124:127], v31, v60 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[216:219], v[236:239], a[92:95], v31, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[216:219], v[240:243], a[96:99], v31, v60 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[220:223], v[240:243], a[128:131], v31, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[220:223], v[252:255], a[140:143], v31, v22 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[216:219], v[252:255], a[108:111], v31, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[216:219], v[36:39], a[112:115], v31, v22 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[220:223], v[36:39], a[144:147], v31, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[224:227], v[36:39], a[176:179], v27, v22 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[224:227], v[252:255], a[172:175], v27, v22 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[32:35], v[252:255], a[204:207], v27, v22 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[32:35], v[36:39], a[208:211], v27, v22 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[32:35], v[228:231], a[180:183], v27, v28 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[224:227], v[228:231], a[148:151], v27, v28 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[224:227], v[232:235], a[152:155], v27, v28 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[32:35], v[232:235], a[184:187], v27, v28 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[32:35], v[236:239], a[188:191], v27, v60 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[224:227], v[236:239], a[156:159], v27, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[224:227], v[240:243], a[160:163], v27, v60 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[32:35], v[240:243], a[192:195], v27, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[32:35], v[244:247], a[196:199], v27, v61 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[224:227], v[244:247], a[164:167], v27, v61 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[224:227], v[248:251], a[168:171], v27, v61 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[32:35], v[248:251], a[200:203], v27, v61 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s10, s10, 2
		s_cmp_lt_i32 s10, s5
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(36)
		scratch_load_dword v28, off, s4 offset:16
		scratch_load_dword v29, off, s4 offset:20
		scratch_load_dword v30, off, s4 offset:24
		scratch_load_dword v31, off, s4 offset:28
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(32)
		scratch_load_dword v32, off, s4 offset:32
		scratch_load_dword v33, off, s4 offset:36
		scratch_load_dword v34, off, s4 offset:40
		scratch_load_dword v35, off, s4 offset:44
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(28)
		scratch_load_dword v36, off, s4 offset:48
		scratch_load_dword v37, off, s4 offset:52
		scratch_load_dword v38, off, s4 offset:56
		scratch_load_dword v39, off, s4 offset:60
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v40, off, s4 offset:64
		scratch_load_dword v41, off, s4 offset:68
		scratch_load_dword v42, off, s4 offset:72
		scratch_load_dword v43, off, s4 offset:76
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(20)
		scratch_load_dword v44, off, s4 offset:80
		scratch_load_dword v45, off, s4 offset:84
		scratch_load_dword v46, off, s4 offset:88
		scratch_load_dword v47, off, s4 offset:92
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v48, off, s4 offset:96
		scratch_load_dword v49, off, s4 offset:100
		scratch_load_dword v50, off, s4 offset:104
		scratch_load_dword v51, off, s4 offset:108
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(12)
		scratch_load_dword v52, off, s4 offset:112
		scratch_load_dword v53, off, s4 offset:116
		scratch_load_dword v54, off, s4 offset:120
		scratch_load_dword v55, off, s4 offset:124
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v56, off, s4 offset:128
		scratch_load_dword v57, off, s4 offset:132
		scratch_load_dword v58, off, s4 offset:136
		scratch_load_dword v59, off, s4 offset:140
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v60, off, s4 offset:144
		scratch_load_dword v61, off, s4 offset:148
		scratch_load_dword v62, off, s4 offset:152
		scratch_load_dword v63, off, s4 offset:156
		s_mov_b32 s4, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v64, off, s4 offset:160
		scratch_load_dword v65, off, s4 offset:164
		scratch_load_dword v66, off, s4 offset:168
		scratch_load_dword v67, off, s4 offset:172
		v_mov_b32_e32 v68, v184
		v_mov_b32_e32 v69, v185
		v_mov_b32_e32 v70, v186
		v_mov_b32_e32 v71, v187
		v_mov_b32_e32 v72, v188
		v_mov_b32_e32 v73, v189
		v_mov_b32_e32 v74, v190
		v_mov_b32_e32 v75, v191
		v_mov_b32_e32 v2, v118
		v_mov_b32_e32 v27, v119
		v_mov_b32_e32 v76, v120
		v_mov_b32_e32 v26, v121
		v_mov_b32_e32 v77, v126
		v_mov_b32_e32 v78, v127
		v_mov_b32_e32 v79, v128
		s_mov_b32 m0, s15
		v_mov_b32_e32 v24, v129
		ds_write_addtid_b32 v2 offset:23552
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_mov_b32 m0, s15
		s_waitcnt lgkmcnt(0)
		s_nop 0
		ds_read_addtid_b32 v1 offset:23552
		s_add_i32 s0, s12, -1
		s_waitcnt vmcnt(20) lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], a[0:3], v[44:47], v[12:15], v1, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
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
		v_add_u32_e32 v6, 0x800, v3
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		ds_read_b128 v[8:11], v6 offset:16384
		s_waitcnt vmcnt(16)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], a[0:3], v[48:51], v[100:103], v1, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v6, 0x800, v3
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		ds_read_b128 v[16:19], v6 offset:17408
		s_waitcnt vmcnt(12)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[0:3], v[52:55], v[132:135], v1, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v6, 0x800, v3
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		ds_read_b128 v[20:23], v6 offset:18432
		s_waitcnt vmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[0:3], v[56:59], v[136:139], v1, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v6, 0x800, v3
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		ds_read_b128 v[80:83], v6 offset:19456
		s_waitcnt vmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[0:3], v[60:63], v[140:143], v1, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v6, 0x800, v3
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		ds_read_b128 v[84:87], v6 offset:20480
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[0:3], v[64:67], v[144:147], v1, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v6, 0x800, v3
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		ds_read_b128 v[88:91], v6 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[0:3], v[68:71], v[148:151], v1, v24 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v6, 0x800, v3
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x800, v6
		v_add_u32_e32 v6, 0x400, v6
		ds_read_b128 v[92:95], v6 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[0:3], v[72:75], v[152:155], v1, v24 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[96:99], v3 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[4:7], v[44:47], v[156:159], v1, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, s0, v4
		v_lshrrev_b32_e32 v6, 6, v0
		v_and_b32_e32 v6, 1, v6
		v_lshlrev_b32_e32 v6, 13, v6
		v_add3_u32 v3, v3, v6, v5
		v_add_u32_e32 v7, 0x800, v3
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x400, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x400, v7
		ds_read_b128 v[104:107], v7 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[4:7], v[48:51], v[160:163], v1, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v7, 0x800, v3
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x400, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x400, v7
		ds_read_b128 v[108:111], v7 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[4:7], v[52:55], v[164:167], v1, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v7, 0x800, v3
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x400, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x400, v7
		ds_read_b128 v[112:115], v7 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[4:7], v[56:59], v[168:171], v1, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v7, 0x800, v3
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x400, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x400, v7
		ds_read_b128 v[116:119], v7 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[4:7], v[60:63], v[172:175], v1, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v7, 0x800, v3
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x400, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x400, v7
		ds_read_b128 v[120:123], v7 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[4:7], v[64:67], v[176:179], v1, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v7, 0x800, v3
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x400, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x400, v7
		ds_read_b128 v[124:127], v7 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[4:7], v[68:71], v[180:183], v1, v24 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v7, 0x800, v3
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x400, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x800, v7
		v_add_u32_e32 v7, 0x400, v7
		ds_read_b128 v[128:131], v7 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[4:7], v[72:75], a[16:19], v1, v24 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[184:187], v3 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[8:11], v[44:47], a[20:23], v27, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[8:11], v[48:51], a[24:27], v27, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[12:15], v[48:51], a[56:59], v27, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[12:15], v[44:47], a[52:55], v27, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[12:15], v[52:55], a[60:63], v27, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[8:11], v[52:55], a[28:31], v27, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[8:11], v[56:59], a[32:35], v27, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[12:15], v[56:59], a[64:67], v27, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[12:15], v[60:63], a[68:71], v27, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[8:11], v[60:63], a[36:39], v27, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[8:11], v[64:67], a[40:43], v27, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[12:15], v[64:67], a[72:75], v27, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[12:15], v[68:71], a[76:79], v27, v24 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[8:11], v[68:71], a[44:47], v27, v24 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[8:11], v[72:75], a[48:51], v27, v24 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[12:15], v[72:75], a[80:83], v27, v24 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[28:31], v[72:75], a[112:115], v76, v24 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[28:31], v[68:71], a[108:111], v76, v24 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[32:35], v[68:71], a[140:143], v76, v24 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], v[72:75], a[144:147], v76, v24 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[32:35], v[44:47], a[116:119], v76, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[28:31], v[44:47], a[84:87], v76, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[28:31], v[48:51], a[88:91], v76, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[32:35], v[48:51], a[120:123], v76, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[32:35], v[52:55], a[124:127], v76, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[28:31], v[52:55], a[92:95], v76, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[28:31], v[56:59], a[96:99], v76, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[32:35], v[56:59], a[128:131], v76, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[32:35], v[60:63], a[132:135], v76, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[28:31], v[60:63], a[100:103], v76, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[28:31], v[64:67], a[104:107], v76, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[32:35], v[64:67], a[136:139], v76, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[36:39], v[64:67], a[168:171], v26, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[36:39], v[60:63], a[164:167], v26, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[40:43], v[60:63], a[196:199], v26, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[40:43], v[64:67], a[200:203], v26, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[40:43], v[44:47], a[180:183], v26, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[36:39], v[44:47], a[148:151], v26, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[36:39], v[48:51], a[152:155], v26, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[40:43], v[48:51], a[184:187], v26, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[40:43], v[52:55], a[188:191], v26, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[36:39], v[52:55], a[156:159], v26, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], v[56:59], a[160:163], v26, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[40:43], v[56:59], a[192:195], v26, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[40:43], v[68:71], a[204:207], v26, v24 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[36:39], v[68:71], a[172:175], v26, v24 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[36:39], v[72:75], a[176:179], v26, v24 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[40:43], v[72:75], a[208:211], v26, v24 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[92:95], v[128:131], a[172:175], v26, v24 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[92:95], v[184:187], a[176:179], v26, v24 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[96:99], v[184:187], a[208:211], v26, v24 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[96:99], v[128:131], a[204:207], v26, v24 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[8:11], v[128:131], v[148:151], v1, v24 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[8:11], v[184:187], v[152:155], v1, v24 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[16:19], v[184:187], a[16:19], v1, v24 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[16:19], v[128:131], v[180:183], v1, v24 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[16:19], v[104:107], v[156:159], v1, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[8:11], v[104:107], v[12:15], v1, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[8:11], v[108:111], v[100:103], v1, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[16:19], v[108:111], v[160:163], v1, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[16:19], v[112:115], v[164:167], v1, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[8:11], v[112:115], v[132:135], v1, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[8:11], v[116:119], v[136:139], v1, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[16:19], v[116:119], v[168:171], v1, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[16:19], v[120:123], v[172:175], v1, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[8:11], v[120:123], v[140:143], v1, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[8:11], v[124:127], v[144:147], v1, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[16:19], v[124:127], v[176:179], v1, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[20:23], v[124:127], a[40:43], v27, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[20:23], v[120:123], a[36:39], v27, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[80:83], v[120:123], a[68:71], v27, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[80:83], v[124:127], a[72:75], v27, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[80:83], v[104:107], a[52:55], v27, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[20:23], v[104:107], a[20:23], v27, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[20:23], v[108:111], a[24:27], v27, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[80:83], v[108:111], a[56:59], v27, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[80:83], v[112:115], a[60:63], v27, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[20:23], v[112:115], a[28:31], v27, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[20:23], v[116:119], a[32:35], v27, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[80:83], v[116:119], a[64:67], v27, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[80:83], v[128:131], a[76:79], v27, v24 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[20:23], v[128:131], a[44:47], v27, v24 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[20:23], v[184:187], a[48:51], v27, v24 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[80:83], v[184:187], a[80:83], v27, v24 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[84:87], v[184:187], a[112:115], v76, v24 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[84:87], v[128:131], a[108:111], v76, v24 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[88:91], v[128:131], a[140:143], v76, v24 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[88:91], v[184:187], a[144:147], v76, v24 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[88:91], v[104:107], a[116:119], v76, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[84:87], v[104:107], a[84:87], v76, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[84:87], v[108:111], a[88:91], v76, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[88:91], v[108:111], a[120:123], v76, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[88:91], v[112:115], a[124:127], v76, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[84:87], v[112:115], a[92:95], v76, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[84:87], v[116:119], a[96:99], v76, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[88:91], v[116:119], a[128:131], v76, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[88:91], v[120:123], a[132:135], v76, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[84:87], v[120:123], a[100:103], v76, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[84:87], v[124:127], a[104:107], v76, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[88:91], v[124:127], a[136:139], v76, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[92:95], v[124:127], a[168:171], v26, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[92:95], v[120:123], a[164:167], v26, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[96:99], v[120:123], a[196:199], v26, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[96:99], v[124:127], a[200:203], v26, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[96:99], v[104:107], a[180:183], v26, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[92:95], v[104:107], a[148:151], v26, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[92:95], v[108:111], a[152:155], v26, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[96:99], v[108:111], a[184:187], v26, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[96:99], v[112:115], a[188:191], v26, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[92:95], v[112:115], a[156:159], v26, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[92:95], v[116:119], a[160:163], v26, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[96:99], v[116:119], a[192:195], v26, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s0, s12, 1
		s_lshl_b32 s1, s0, 16
		v_add_u32_e32 v1, s1, v2
		v_add3_u32 v1, v1, v4, v5
		v_add_u32_e32 v2, 0x800, v1
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[8:11], v2
		v_add_u32_e32 v2, 0x800, v1
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[16:19], v2 offset:1024
		v_add_u32_e32 v2, 0x800, v1
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[20:23], v2 offset:2048
		v_add_u32_e32 v2, 0x800, v1
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[24:27], v2 offset:3072
		v_add_u32_e32 v2, 0x800, v1
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[28:31], v2 offset:4096
		v_add_u32_e32 v2, 0x800, v1
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[32:35], v2 offset:5120
		v_add_u32_e32 v2, 0x800, v1
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[36:39], v2 offset:6144
		v_add_u32_e32 v2, 0x800, v1
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x400, v2
		ds_read_b128 v[40:43], v2 offset:7168
		v_add_u32_e32 v2, s1, v4
		v_add3_u32 v2, v2, v6, v5
		v_add_u32_e32 v3, 0x800, v2
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[4:7], v3 offset:32768
		v_add_u32_e32 v3, 0x800, v2
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[44:47], v3 offset:33792
		v_add_u32_e32 v3, 0x800, v2
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[48:51], v3 offset:34816
		v_add_u32_e32 v3, 0x800, v2
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[52:55], v3 offset:35840
		v_add_u32_e32 v3, 0x800, v2
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[56:59], v3 offset:36864
		v_add_u32_e32 v3, 0x800, v2
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[60:63], v3 offset:37888
		v_add_u32_e32 v3, 0x800, v2
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[64:67], v3 offset:38912
		v_add_u32_e32 v3, 0x800, v2
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
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
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x400, v73
		ds_read_b32 v74, v73
		v_add_u32_e32 v73, 0x800, v3
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x400, v73
		ds_read_b32 v75, v73 offset:256
		v_add_u32_e32 v73, 0x800, v3
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x400, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x800, v73
		v_add_u32_e32 v73, 0x400, v73
		ds_read_b32 v76, v73 offset:512
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
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
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x400, v72
		ds_read_b32 v77, v72 offset:2048
		v_add_u32_e32 v72, 0x800, v3
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x400, v72
		ds_read_b32 v78, v72 offset:2304
		v_add_u32_e32 v72, 0x800, v3
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x400, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x800, v72
		v_add_u32_e32 v72, 0x400, v72
		ds_read_b32 v79, v72 offset:2560
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b32 v72, v3 offset:2816
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[8:11], v[4:7], v[12:15], v74, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x800, v1
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[80:83], v3 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[8:11], v[44:47], v[100:103], v74, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x800, v1
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[84:87], v3 offset:17408
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[8:11], v[48:51], v[132:135], v74, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x800, v1
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[88:91], v3 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[8:11], v[52:55], v[136:139], v74, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x800, v1
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[92:95], v3 offset:19456
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[8:11], v[56:59], v[140:143], v74, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x800, v1
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[96:99], v3 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[8:11], v[60:63], v[144:147], v74, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x800, v1
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[104:107], v3 offset:21504
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[8:11], v[64:67], v[148:151], v74, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x800, v1
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x400, v3
		ds_read_b128 v[108:111], v3 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[8:11], v[68:71], v[152:155], v74, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		ds_read_b128 v[8:11], v1 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[16:19], v[4:7], v[156:159], v74, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x800, v2
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		ds_read_b128 v[112:115], v1 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[16:19], v[44:47], v[160:163], v74, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x800, v2
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		ds_read_b128 v[116:119], v1 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[16:19], v[48:51], v[164:167], v74, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x800, v2
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		ds_read_b128 v[120:123], v1 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[16:19], v[52:55], v[168:171], v74, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x800, v2
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		ds_read_b128 v[124:127], v1 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[16:19], v[56:59], v[172:175], v74, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x800, v2
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		ds_read_b128 v[128:131], v1 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[16:19], v[60:63], v[176:179], v74, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x800, v2
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		ds_read_b128 v[184:187], v1 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[16:19], v[64:67], v[180:183], v74, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x800, v2
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		ds_read_b128 v[188:191], v1 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[16:19], v[68:71], a[16:19], v74, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x800, v2
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x400, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
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
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[80:83], v[188:191], v[148:151], v74, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[80:83], v[16:19], v[152:155], v74, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[84:87], v[16:19], a[16:19], v74, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[84:87], v[188:191], v[180:183], v74, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[84:87], v[112:115], v[156:159], v74, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[80:83], v[112:115], v[12:15], v74, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[80:83], v[116:119], v[100:103], v74, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
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
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[92:95], v[128:131], a[68:71], v75, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[92:95], v[184:187], a[72:75], v75, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[92:95], v[112:115], a[52:55], v75, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[88:91], v[112:115], a[20:23], v75, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[88:91], v[116:119], a[24:27], v75, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[92:95], v[116:119], a[56:59], v75, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[92:95], v[120:123], a[60:63], v75, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[88:91], v[120:123], a[28:31], v75, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[88:91], v[124:127], a[32:35], v75, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[92:95], v[124:127], a[64:67], v75, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
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
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[104:107], v[120:123], a[124:127], v76, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[96:99], v[120:123], a[92:95], v76, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[96:99], v[124:127], a[96:99], v76, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[104:107], v[124:127], a[128:131], v76, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[104:107], v[128:131], a[132:135], v76, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[96:99], v[128:131], a[100:103], v76, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[96:99], v[184:187], a[104:107], v76, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
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
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 24576
		.amdhsa_private_segment_fixed_size 176
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
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 176
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
    .private_segment_fixed_size: 176
    .sgpr_count:     46
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     512
    .agpr_count:     256
    .vgpr_spill_count: 44
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 112
    wave.regalloc.agpr.dwords: 302
    wave.regalloc.remat.dwords: 10
    wave.regalloc.sgpr_to_vgpr.dwords: 0
    wave.regalloc.lds.dwords: 24
    wave.regalloc.scratch.dwords: 44
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
