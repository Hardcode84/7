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
		s_mov_b32 m0, s15
		v_and_b32_e32 v4, 63, v0
		ds_write_addtid_b32 v4
		v_lshrrev_b32_e32 v5, 2, v4
		v_lshlrev_b32_e32 v5, 12, v5
		v_lshrrev_b32_e32 v6, 3, v4
		v_bitop3_b32 v6, v6, 3, v4 bitop3:0x48
		v_lshlrev_b32_e32 v6, 4, v6
		v_add3_u32 v3, v3, v5, v6
		s_add_i32 s8, s5, 0x80000
		v_add_u32_e32 v7, s8, v2
		s_add_i32 s8, s5, 64
		v_add_u32_e32 v8, v2, v5
		s_add_i32 s9, s5, 0x80040
		s_lshl_b32 s10, s14, 20
		s_add_i32 s11, s10, 0x80000
		v_add3_u32 v9, v2, v5, v6
		s_add_i32 s16, s10, 0x80040
		s_lshr_b32 s17, s4, 6
		s_lshl_b32 s19, s17, 10
		v_mov_b64_e32 v[12:13], 0
		v_mov_b64_e32 v[14:15], 0
		s_add_i32 m0, s19, 0x6000
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add3_u32 v3, v7, v5, v6
		s_add_i32 m0, s19, 0x8000
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add3_u32 v3, v6, v8, s8
		s_add_i32 m0, s19, 0xa000
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add3_u32 v3, v6, v8, s9
		s_add_i32 m0, s19, 0xc000
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add3_u32 v3, v6, v8, s10
		s_add_i32 m0, s19, 0xe000
		s_nop 0
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		v_add_u32_e32 v3, s11, v9
		s_add_i32 m0, s19, 0x10000
		s_nop 0
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		v_add3_u32 v3, v9, s10, 64
		s_add_i32 m0, s19, 0x12000
		s_nop 0
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		v_add_u32_e32 v3, s16, v9
		s_add_i32 m0, s19, 0x14000
		s_nop 0
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		s_lshl_b32 s8, s14, 16
		s_add_i32 s9, s5, s8
		v_lshrrev_b32_e32 v3, 7, v0
		s_mov_b32 m0, s15
		v_lshlrev_b32_e32 v7, 9, v3
		ds_write_addtid_b32 v7 offset:2048
		v_lshlrev_b32_e32 v8, 2, v4
		s_mov_b32 s11, 0
		scratch_store_dword off, v8, s11 offset:196
		v_add3_u32 v9, s9, v7, v8
		s_lshr_b32 s4, s4, 7
		s_lshl_b32 s11, s4, 9
		s_add_i32 s4, s5, 0x100
		s_add_i32 s4, s4, s8
		v_add3_u32 v10, s4, v7, v8
		v_lshlrev_b32_e32 v11, 4, v4
		v_and_b32_e32 v1, 1, v1
		s_mov_b32 m0, s15
		v_lshlrev_b32_e32 v16, 10, v1
		ds_write_addtid_b32 v16 offset:4096
		v_add3_u32 v17, s9, v11, v16
		s_and_b32 s4, s17, 1
		s_lshl_b32 s4, s4, 10
		s_add_i32 s9, s19, 0x2000
		s_add_i32 m0, s11, 0x26000
		s_nop 0
		buffer_load_dword v9, s[24:27], 0 offen lds
		s_add_i32 s16, s19, 0x4000
		s_add_i32 m0, s11, 0x26100
		s_nop 0
		buffer_load_dword v10, s[24:27], 0 offen lds
		s_add_i32 s32, s19, 0x6000
		s_add_i32 m0, s4, 0x26800
		s_nop 0
		buffer_load_dwordx4 v17, s[28:31], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		s_mov_b32 m0, s15
		v_lshlrev_b32_e32 v3, 12, v3
		ds_write_addtid_b32 v3 offset:22528
		v_and_b32_e32 v9, 15, v0
		v_lshlrev_b32_e32 v10, 6, v9
		s_mov_b32 s33, 0
		scratch_store_dword off, v10, s33 offset:180
		v_lshrrev_b32_e32 v4, 4, v4
		v_lshrrev_b32_e32 v9, 1, v9
		v_bitop3_b32 v4, v4, v9, 3 bitop3:0x78
		v_lshlrev_b32_e32 v4, 4, v4
		s_mov_b32 s33, 0
		scratch_store_dword off, v4, s33 offset:184
		v_add3_u32 v3, v3, v10, v4
		v_add_u32_e32 v9, 0x800, v3
		v_add_u32_e32 v9, 0x800, v9
		v_add_u32_e32 v9, 0x800, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x800, v9
		ds_read_b128 v[20:23], v9
		v_add_u32_e32 v9, 0x800, v3
		v_add_u32_e32 v9, 0x800, v9
		v_add_u32_e32 v9, 0x800, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x800, v9
		ds_read_b128 v[24:27], v9 offset:1024
		v_add_u32_e32 v9, 0x800, v3
		v_add_u32_e32 v9, 0x800, v9
		v_add_u32_e32 v9, 0x800, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x800, v9
		ds_read_b128 v[28:31], v9 offset:2048
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x800, v3
		ds_read_b128 v[32:35], v3 offset:3072
		v_lshlrev_b32_e32 v1, 13, v1
		s_mov_b32 s33, 0
		scratch_store_dword off, v1, s33 offset:88
		v_add3_u32 v3, v10, v1, v4
		v_add_u32_e32 v9, 0x800, v3
		v_add_u32_e32 v9, 0x800, v9
		v_add_u32_e32 v9, 0x800, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x800, v9
		ds_read_b128 v[36:39], v9 offset:32768
		v_add_u32_e32 v9, 0x800, v3
		v_add_u32_e32 v9, 0x800, v9
		v_add_u32_e32 v9, 0x800, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x800, v9
		ds_read_b128 v[40:43], v9 offset:33792
		v_add_u32_e32 v9, 0x800, v3
		v_add_u32_e32 v9, 0x800, v9
		v_add_u32_e32 v9, 0x800, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x800, v9
		ds_read_b128 v[44:47], v9 offset:34816
		v_add_u32_e32 v9, 0x800, v3
		v_add_u32_e32 v9, 0x800, v9
		v_add_u32_e32 v9, 0x800, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x800, v9
		ds_read_b128 v[48:51], v9 offset:35840
		v_add_u32_e32 v9, 0x800, v3
		v_add_u32_e32 v9, 0x800, v9
		v_add_u32_e32 v9, 0x800, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x800, v9
		ds_read_b128 v[52:55], v9 offset:36864
		v_add_u32_e32 v9, 0x800, v3
		v_add_u32_e32 v9, 0x800, v9
		v_add_u32_e32 v9, 0x800, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x800, v9
		ds_read_b128 v[56:59], v9 offset:37888
		v_add_u32_e32 v9, 0x800, v3
		v_add_u32_e32 v9, 0x800, v9
		v_add_u32_e32 v9, 0x800, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x800, v9
		ds_read_b128 v[60:63], v9 offset:38912
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x800, v3
		ds_read_b128 v[64:67], v3 offset:39936
		v_add_u32_e32 v3, 0x20000, v7
		v_add_u32_e32 v3, v3, v8
		v_add_u32_e32 v9, 0x800, v3
		v_add_u32_e32 v9, 0x800, v9
		v_add_u32_e32 v9, 0x800, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x800, v9
		ds_read_b32 v17, v9
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x800, v3
		ds_read_b32 v9, v3 offset:256
		v_add_u32_e32 v3, 0x20000, v8
		v_add_u32_e32 v3, v3, v16
		v_add_u32_e32 v18, 0x800, v3
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x1000, v18
		v_add_u32_e32 v18, 0x1000, v18
		v_add_u32_e32 v18, 0x1000, v18
		v_add_u32_e32 v18, 0x1000, v18
		v_add_u32_e32 v18, 0x800, v18
		ds_read_b32 v19, v18 offset:2048
		v_add_u32_e32 v18, 0x800, v3
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x1000, v18
		v_add_u32_e32 v18, 0x1000, v18
		v_add_u32_e32 v18, 0x1000, v18
		v_add_u32_e32 v18, 0x1000, v18
		v_add_u32_e32 v18, 0x800, v18
		ds_read_b32 v68, v18 offset:2304
		v_add_u32_e32 v18, 0x800, v3
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x800, v18
		v_add_u32_e32 v18, 0x1000, v18
		v_add_u32_e32 v18, 0x1000, v18
		v_add_u32_e32 v18, 0x1000, v18
		v_add_u32_e32 v18, 0x1000, v18
		v_add_u32_e32 v18, 0x800, v18
		ds_read_b32 v69, v18 offset:2560
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x800, v3
		ds_read_b32 v18, v3 offset:2816
		s_add_i32 s33, s5, 0x80
		v_add_u32_e32 v3, s33, v2
		v_add3_u32 v3, v3, v5, v6
		s_add_i32 s33, s5, 0x80080
		v_add_u32_e32 v70, s33, v2
		v_add3_u32 v70, v70, v5, v6
		s_add_i32 s33, s5, 0xc0
		v_add_u32_e32 v71, v2, v5
		v_add3_u32 v72, v6, v71, s33
		s_add_i32 s33, s5, 0x800c0
		v_add3_u32 v73, v6, v71, s33
		s_add_i32 s33, s10, 0x80
		v_add3_u32 v71, v6, v71, s33
		s_add_i32 s33, s10, 0x80080
		v_add_u32_e32 v2, v2, v5
		v_add3_u32 v5, v6, v2, s33
		s_add_i32 s33, s10, 0xc0
		s_add_i32 s10, s10, 0x800c0
		s_add_i32 s34, s19, 0x16000
		s_add_i32 s35, s19, 0x18000
		s_add_i32 s36, s19, 0x1a000
		s_add_i32 s37, s19, 0x1c000
		s_add_i32 s38, s19, 0x1e000
		s_add_i32 s39, s19, 0x8000
		s_add_i32 m0, s19, 0x16000
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		s_add_i32 s40, s19, 0xa000
		s_add_i32 m0, s19, 0x18000
		s_nop 0
		buffer_load_dwordx4 v70, s[20:23], 0 offen lds
		s_add_i32 s41, s19, 0xc000
		s_add_i32 m0, s19, 0x1a000
		s_nop 0
		buffer_load_dwordx4 v72, s[20:23], 0 offen lds
		s_add_i32 s42, s19, 0xe000
		s_add_i32 m0, s19, 0x1c000
		s_nop 0
		buffer_load_dwordx4 v73, s[20:23], 0 offen lds
		s_add_i32 s43, s11, 0x100
		s_add_i32 m0, s19, 0x1e000
		s_nop 0
		buffer_load_dwordx4 v71, s[0:3], 0 offen lds
		s_add_i32 s44, s4, 0x800
		s_add_i32 m0, s19, 0x20000
		s_nop 0
		buffer_load_dwordx4 v5, s[0:3], 0 offen lds
		v_add3_u32 v3, v6, v2, s33
		s_add_i32 m0, s19, 0x22000
		s_nop 0
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		v_add3_u32 v2, v6, v2, s10
		s_add_i32 m0, s19, 0x24000
		s_nop 0
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_add_i32 s10, s5, 0x800
		s_add_i32 s10, s10, s8
		v_add3_u32 v2, s10, v7, v8
		s_add_i32 s33, s11, 0x1000
		s_add_i32 s5, s5, 0x900
		s_add_i32 s5, s5, s8
		v_add3_u32 v3, s5, v7, v8
		s_add_i32 s5, s11, 0x1100
		v_add3_u32 v5, s10, v11, v16
		s_add_i32 s8, s4, 0x1800
		s_add_i32 s10, s19, 0x10000
		s_add_i32 m0, s11, 0x27000
		s_nop 0
		buffer_load_dword v2, s[24:27], 0 offen lds
		s_add_i32 s45, s19, 0x12000
		s_add_i32 m0, s11, 0x27100
		s_nop 0
		buffer_load_dword v3, s[24:27], 0 offen lds
		s_add_i32 s46, s19, 0x14000
		s_add_i32 m0, s4, 0x27800
		s_nop 0
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s4, s12, 1
		s_mov_b32 s47, 2
		v_mov_b32_e32 v2, s13
		v_mov_b32_e32 v3, 0
		s_mov_b32 s48, 0x100000
		s_mov_b32 s49, 0
		v_mov_b32_e32 v6, s48
		v_mov_b32_e32 v7, s49
		v_mul_lo_u32 v70, v6, v2
		v_mul_hi_u32 v71, v6, v2
		v_mul_lo_u32 v5, v6, v3
		v_add_u32_e32 v71, v71, v5
		v_mul_lo_u32 v5, v7, v2
		v_add_u32_e32 v71, v71, v5
		s_mov_b32 s48, 1
		s_mov_b32 s49, 0
		v_mov_b32_e32 v72, v0
		v_mov_b32_e32 v74, s48
		v_mov_b32_e32 v75, s49
		v_mov_b32_e32 v73, 0
		v_mul_lo_u32 v76, v74, v72
		v_mul_hi_u32 v77, v74, v72
		v_mul_lo_u32 v0, v74, v73
		v_add_u32_e32 v77, v77, v0
		v_mul_lo_u32 v0, v75, v72
		v_add_u32_e32 v77, v77, v0
		v_lshrrev_b64 v[78:79], 6, v[76:77]
		s_mov_b32 s48, 0x10000
		s_mov_b32 s49, 0
		v_mov_b32_e32 v80, s48
		v_mov_b32_e32 v81, s49
		v_mul_lo_u32 v82, v80, v78
		v_mul_hi_u32 v83, v80, v78
		v_mul_lo_u32 v0, v80, v79
		v_add_u32_e32 v83, v83, v0
		v_mul_lo_u32 v0, v81, v78
		v_add_u32_e32 v83, v83, v0
		v_add_co_u32_e64 v84, vcc, v70, v82
		v_addc_co_u32_e64 v85, vcc, v71, v83, vcc
		v_mov_b32_e32 v0, 63
		v_and_b32_e32 v86, v72, v0
		v_and_b32_e32 v87, v3, v3
		v_mul_lo_u32 v72, v74, v86
		v_mul_hi_u32 v73, v74, v86
		v_mul_lo_u32 v0, v74, v87
		v_add_u32_e32 v73, v73, v0
		v_mul_lo_u32 v0, v75, v86
		v_add_u32_e32 v73, v73, v0
		v_lshrrev_b64 v[74:75], 2, v[72:73]
		s_mov_b32 s48, 0x1000
		s_mov_b32 s49, 0
		v_mov_b32_e32 v88, s48
		v_mov_b32_e32 v89, s49
		v_mul_lo_u32 v90, v88, v74
		v_mul_hi_u32 v91, v88, v74
		v_mul_lo_u32 v0, v88, v75
		v_add_u32_e32 v91, v91, v0
		v_mul_lo_u32 v0, v89, v74
		v_add_u32_e32 v91, v91, v0
		v_add_co_u32_e64 v74, vcc, v84, v90
		v_addc_co_u32_e64 v75, vcc, v85, v91, vcc
		v_lshrrev_b64 v[84:85], 3, v[72:73]
		v_mov_b32_e32 v0, 3
		v_and_b32_e32 v72, v84, v0
		v_and_b32_e32 v73, v85, v3
		v_and_b32_e32 v84, v86, v0
		v_and_b32_e32 v85, v87, v3
		v_xor_b32_e32 v72, v72, v84
		v_xor_b32_e32 v73, v73, v85
		s_mov_b32 s48, 16
		s_mov_b32 s49, 0
		v_mov_b32_e32 v84, s48
		v_mov_b32_e32 v85, s49
		v_mul_lo_u32 v88, v84, v72
		v_mul_hi_u32 v89, v84, v72
		v_mul_lo_u32 v0, v84, v73
		v_add_u32_e32 v89, v89, v0
		v_mul_lo_u32 v0, v85, v72
		v_add_u32_e32 v89, v89, v0
		v_add_co_u32_e64 v72, vcc, v74, v88
		v_addc_co_u32_e64 v73, vcc, v75, v89, vcc
		s_mov_b32 s48, 0x80
		s_mov_b32 s49, 0
		v_mov_b32_e32 v74, s48
		v_mov_b32_e32 v75, s49
		v_mov_b32_e32 v0, 0x80000
		v_add_co_u32_e64 v92, vcc, v70, v0
		v_addc_co_u32_e64 v93, vcc, v71, 0, vcc
		v_add_co_u32_e64 v94, vcc, v92, v82
		v_addc_co_u32_e64 v95, vcc, v93, v83, vcc
		v_add_co_u32_e64 v92, vcc, v94, v90
		v_addc_co_u32_e64 v93, vcc, v95, v91, vcc
		v_add_co_u32_e64 v94, vcc, v92, v88
		v_addc_co_u32_e64 v95, vcc, v93, v89, vcc
		v_mov_b32_e32 v2, 64
		v_add_co_u32_e64 v92, vcc, v70, v2
		v_addc_co_u32_e64 v93, vcc, v71, 0, vcc
		v_add_co_u32_e64 v96, vcc, v92, v82
		v_addc_co_u32_e64 v97, vcc, v93, v83, vcc
		v_add_co_u32_e64 v92, vcc, v96, v90
		v_addc_co_u32_e64 v93, vcc, v97, v91, vcc
		v_add_co_u32_e64 v96, vcc, v92, v88
		v_addc_co_u32_e64 v97, vcc, v93, v89, vcc
		v_mov_b32_e32 v5, 0x80040
		v_add_co_u32_e64 v92, vcc, v70, v5
		v_addc_co_u32_e64 v93, vcc, v71, 0, vcc
		v_add_co_u32_e64 v98, vcc, v92, v82
		v_addc_co_u32_e64 v99, vcc, v93, v83, vcc
		v_add_co_u32_e64 v92, vcc, v98, v90
		v_addc_co_u32_e64 v93, vcc, v99, v91, vcc
		v_add_co_u32_e64 v98, vcc, v92, v88
		v_addc_co_u32_e64 v99, vcc, v93, v89, vcc
		v_mov_b32_e32 v92, s14
		v_mov_b32_e32 v93, 0
		v_mul_lo_u32 v100, v6, v92
		v_mul_hi_u32 v101, v6, v92
		v_mul_lo_u32 v8, v6, v93
		v_add_u32_e32 v101, v101, v8
		v_mul_lo_u32 v8, v7, v92
		v_add_u32_e32 v101, v101, v8
		v_add_co_u32_e64 v6, vcc, v100, v82
		v_addc_co_u32_e64 v7, vcc, v101, v83, vcc
		v_add_co_u32_e64 v102, vcc, v6, v90
		v_addc_co_u32_e64 v103, vcc, v7, v91, vcc
		v_add_co_u32_e64 v6, vcc, v102, v88
		v_addc_co_u32_e64 v7, vcc, v103, v89, vcc
		v_add_co_u32_e64 v102, vcc, v100, v0
		v_addc_co_u32_e64 v103, vcc, v101, 0, vcc
		v_add_co_u32_e64 v104, vcc, v102, v82
		v_addc_co_u32_e64 v105, vcc, v103, v83, vcc
		v_add_co_u32_e64 v102, vcc, v104, v90
		v_addc_co_u32_e64 v103, vcc, v105, v91, vcc
		v_add_co_u32_e64 v104, vcc, v102, v88
		v_addc_co_u32_e64 v105, vcc, v103, v89, vcc
		v_add_co_u32_e64 v102, vcc, v100, v2
		v_addc_co_u32_e64 v103, vcc, v101, 0, vcc
		v_add_co_u32_e64 v106, vcc, v102, v82
		v_addc_co_u32_e64 v107, vcc, v103, v83, vcc
		v_add_co_u32_e64 v102, vcc, v106, v90
		v_addc_co_u32_e64 v103, vcc, v107, v91, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v106, vcc, v102, v88
		v_addc_co_u32_e64 v107, vcc, v103, v89, vcc
		ds_write_addtid_b32 v106 offset:6144
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v107 offset:8192
		v_add_co_u32_e64 v102, vcc, v100, v5
		v_addc_co_u32_e64 v103, vcc, v101, 0, vcc
		v_add_co_u32_e64 v106, vcc, v102, v82
		v_addc_co_u32_e64 v107, vcc, v103, v83, vcc
		v_add_co_u32_e64 v102, vcc, v106, v90
		v_addc_co_u32_e64 v103, vcc, v107, v91, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v106, vcc, v102, v88
		v_addc_co_u32_e64 v107, vcc, v103, v89, vcc
		ds_write_addtid_b32 v106 offset:10240
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v107 offset:12288
		v_mul_lo_u32 v102, v80, v92
		v_mul_hi_u32 v103, v80, v92
		v_mul_lo_u32 v0, v80, v93
		v_add_u32_e32 v103, v103, v0
		v_mul_lo_u32 v0, v81, v92
		v_add_u32_e32 v103, v103, v0
		v_add_co_u32_e64 v80, vcc, v70, v102
		v_addc_co_u32_e64 v81, vcc, v71, v103, vcc
		v_lshrrev_b64 v[92:93], 7, v[76:77]
		s_mov_b32 s48, 0x200
		s_mov_b32 s49, 0
		v_mov_b32_e32 v76, s48
		v_mov_b32_e32 v77, s49
		v_mul_lo_u32 v106, v76, v92
		v_mul_hi_u32 v107, v76, v92
		v_mul_lo_u32 v0, v76, v93
		v_add_u32_e32 v107, v107, v0
		v_mul_lo_u32 v0, v77, v92
		v_add_u32_e32 v107, v107, v0
		v_add_co_u32_e64 v76, vcc, v80, v106
		v_addc_co_u32_e64 v77, vcc, v81, v107, vcc
		s_mov_b32 s48, 4
		s_mov_b32 s49, 0
		v_mov_b32_e32 v92, s48
		v_mov_b32_e32 v93, s49
		v_mul_lo_u32 v108, v92, v86
		v_mul_hi_u32 v109, v92, v86
		v_mul_lo_u32 v0, v92, v87
		v_add_u32_e32 v109, v109, v0
		v_mul_lo_u32 v0, v93, v86
		v_add_u32_e32 v109, v109, v0
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v92, vcc, v76, v108
		v_addc_co_u32_e64 v93, vcc, v77, v109, vcc
		ds_write_addtid_b32 v92 offset:14336
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v93 offset:16384
		s_mov_b32 s48, 0x800
		s_mov_b32 s49, 0
		s_mov_b32 m0, s15
		v_mov_b32_e32 v76, s48
		v_mov_b32_e32 v77, s49
		ds_write_addtid_b32 v76 offset:18432
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v77 offset:20480
		v_mov_b32_e32 v0, 0x100
		v_add_co_u32_e64 v76, vcc, v70, v0
		v_addc_co_u32_e64 v77, vcc, v71, 0, vcc
		v_add_co_u32_e64 v92, vcc, v76, v102
		v_addc_co_u32_e64 v93, vcc, v77, v103, vcc
		v_add_co_u32_e64 v76, vcc, v92, v106
		v_addc_co_u32_e64 v77, vcc, v93, v107, vcc
		v_add_co_u32_e64 v92, vcc, v76, v108
		v_addc_co_u32_e64 v93, vcc, v77, v109, vcc
		v_mul_lo_u32 v76, v84, v86
		v_mul_hi_u32 v77, v84, v86
		v_mul_lo_u32 v0, v84, v87
		v_add_u32_e32 v77, v77, v0
		v_mul_lo_u32 v0, v85, v86
		v_add_u32_e32 v77, v77, v0
		v_add_co_u32_e64 v84, vcc, v80, v76
		v_addc_co_u32_e64 v85, vcc, v81, v77, vcc
		v_mov_b32_e32 v0, 1
		v_and_b32_e32 v80, v78, v0
		v_and_b32_e32 v81, v79, v3
		s_mov_b32 s48, 0x400
		s_mov_b32 s49, 0
		v_mov_b32_e32 v2, s48
		v_mov_b32_e32 v3, s49
		v_mul_lo_u32 v78, v2, v80
		v_mul_hi_u32 v79, v2, v80
		v_mul_lo_u32 v0, v2, v81
		v_add_u32_e32 v79, v79, v0
		v_mul_lo_u32 v0, v3, v80
		v_add_u32_e32 v79, v79, v0
		v_add_co_u32_e64 v2, vcc, v84, v78
		v_addc_co_u32_e64 v3, vcc, v85, v79, vcc
		v_mov_b32_e32 v0, 0x80
		v_add_co_u32_e64 v80, vcc, v70, v0
		v_addc_co_u32_e64 v81, vcc, v71, 0, vcc
		v_add_co_u32_e64 v84, vcc, v80, v82
		v_addc_co_u32_e64 v85, vcc, v81, v83, vcc
		v_add_co_u32_e64 v80, vcc, v84, v90
		v_addc_co_u32_e64 v81, vcc, v85, v91, vcc
		v_add_co_u32_e64 v84, vcc, v80, v88
		v_addc_co_u32_e64 v85, vcc, v81, v89, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v84, s48
		scratch_store_dword off, v85, s48 offset:4
		v_mov_b32_e32 v5, 0x80080
		v_add_co_u32_e64 v80, vcc, v70, v5
		v_addc_co_u32_e64 v81, vcc, v71, 0, vcc
		v_add_co_u32_e64 v84, vcc, v80, v82
		v_addc_co_u32_e64 v85, vcc, v81, v83, vcc
		v_add_co_u32_e64 v80, vcc, v84, v90
		v_addc_co_u32_e64 v81, vcc, v85, v91, vcc
		v_add_co_u32_e64 v84, vcc, v80, v88
		v_addc_co_u32_e64 v85, vcc, v81, v89, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v84, s48 offset:8
		scratch_store_dword off, v85, s48 offset:12
		v_mov_b32_e32 v8, 0xc0
		v_add_co_u32_e64 v80, vcc, v70, v8
		v_addc_co_u32_e64 v81, vcc, v71, 0, vcc
		v_add_co_u32_e64 v84, vcc, v80, v82
		v_addc_co_u32_e64 v85, vcc, v81, v83, vcc
		v_add_co_u32_e64 v80, vcc, v84, v90
		v_addc_co_u32_e64 v81, vcc, v85, v91, vcc
		v_add_co_u32_e64 v84, vcc, v80, v88
		v_addc_co_u32_e64 v85, vcc, v81, v89, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v84, s48 offset:16
		scratch_store_dword off, v85, s48 offset:20
		v_mov_b32_e32 v11, 0x800c0
		v_add_co_u32_e64 v80, vcc, v70, v11
		v_addc_co_u32_e64 v81, vcc, v71, 0, vcc
		v_add_co_u32_e64 v84, vcc, v80, v82
		v_addc_co_u32_e64 v85, vcc, v81, v83, vcc
		v_add_co_u32_e64 v80, vcc, v84, v90
		v_addc_co_u32_e64 v81, vcc, v85, v91, vcc
		v_add_co_u32_e64 v84, vcc, v80, v88
		v_addc_co_u32_e64 v85, vcc, v81, v89, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v84, s48 offset:24
		scratch_store_dword off, v85, s48 offset:28
		v_add_co_u32_e64 v80, vcc, v100, v0
		v_addc_co_u32_e64 v81, vcc, v101, 0, vcc
		v_add_co_u32_e64 v84, vcc, v80, v82
		v_addc_co_u32_e64 v85, vcc, v81, v83, vcc
		v_add_co_u32_e64 v80, vcc, v84, v90
		v_addc_co_u32_e64 v81, vcc, v85, v91, vcc
		v_add_co_u32_e64 v84, vcc, v80, v88
		v_addc_co_u32_e64 v85, vcc, v81, v89, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v84, s48 offset:32
		scratch_store_dword off, v85, s48 offset:36
		v_add_co_u32_e64 v80, vcc, v100, v5
		v_addc_co_u32_e64 v81, vcc, v101, 0, vcc
		v_add_co_u32_e64 v84, vcc, v80, v82
		v_addc_co_u32_e64 v85, vcc, v81, v83, vcc
		v_add_co_u32_e64 v80, vcc, v84, v90
		v_addc_co_u32_e64 v81, vcc, v85, v91, vcc
		v_add_co_u32_e64 v84, vcc, v80, v88
		v_addc_co_u32_e64 v85, vcc, v81, v89, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v84, s48 offset:40
		scratch_store_dword off, v85, s48 offset:44
		v_add_co_u32_e64 v80, vcc, v100, v8
		v_addc_co_u32_e64 v81, vcc, v101, 0, vcc
		v_add_co_u32_e64 v84, vcc, v80, v82
		v_addc_co_u32_e64 v85, vcc, v81, v83, vcc
		v_add_co_u32_e64 v80, vcc, v84, v90
		v_addc_co_u32_e64 v81, vcc, v85, v91, vcc
		v_add_co_u32_e64 v84, vcc, v80, v88
		v_addc_co_u32_e64 v85, vcc, v81, v89, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v84, s48 offset:48
		scratch_store_dword off, v85, s48 offset:52
		v_add_co_u32_e64 v80, vcc, v100, v11
		v_addc_co_u32_e64 v81, vcc, v101, 0, vcc
		v_add_co_u32_e64 v84, vcc, v80, v82
		v_addc_co_u32_e64 v85, vcc, v81, v83, vcc
		v_add_co_u32_e64 v80, vcc, v84, v90
		v_addc_co_u32_e64 v81, vcc, v85, v91, vcc
		v_add_co_u32_e64 v82, vcc, v80, v88
		v_addc_co_u32_e64 v83, vcc, v81, v89, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v82, s48 offset:56
		scratch_store_dword off, v83, s48 offset:60
		v_mov_b32_e32 v0, 0x800
		v_add_co_u32_e64 v80, vcc, v70, v0
		v_addc_co_u32_e64 v81, vcc, v71, 0, vcc
		v_add_co_u32_e64 v82, vcc, v80, v102
		v_addc_co_u32_e64 v83, vcc, v81, v103, vcc
		v_add_co_u32_e64 v80, vcc, v82, v106
		v_addc_co_u32_e64 v81, vcc, v83, v107, vcc
		v_add_co_u32_e64 v84, vcc, v80, v108
		v_addc_co_u32_e64 v85, vcc, v81, v109, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v84, s48 offset:64
		scratch_store_dword off, v85, s48 offset:68
		v_mov_b32_e32 v0, 0x900
		v_add_co_u32_e64 v80, vcc, v70, v0
		v_addc_co_u32_e64 v81, vcc, v71, 0, vcc
		v_add_co_u32_e64 v70, vcc, v80, v102
		v_addc_co_u32_e64 v71, vcc, v81, v103, vcc
		v_add_co_u32_e64 v80, vcc, v70, v106
		v_addc_co_u32_e64 v81, vcc, v71, v107, vcc
		v_add_co_u32_e64 v70, vcc, v80, v108
		v_addc_co_u32_e64 v71, vcc, v81, v109, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v70, s48 offset:72
		scratch_store_dword off, v71, s48 offset:76
		v_add_co_u32_e64 v70, vcc, v82, v76
		v_addc_co_u32_e64 v71, vcc, v83, v77, vcc
		v_add_co_u32_e64 v76, vcc, v70, v78
		v_addc_co_u32_e64 v77, vcc, v71, v79, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v76, s48 offset:80
		scratch_store_dword off, v77, s48 offset:84
		v_mov_b32_e32 v70, s47
		v_mov_b32_e32 v71, 0
		v_mov_b64_e32 v[76:77], 0
		v_mov_b64_e32 v[78:79], 0
		v_mov_b64_e32 v[80:81], 0
		v_mov_b64_e32 v[82:83], 0
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
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
.Lwmma_f16_matmul_tiled.loop_head_0:
		v_mov_b32_e32 v70, s47
		v_mul_lo_u32 v106, v74, v70
		v_mul_hi_u32 v107, v74, v70
		v_mul_lo_u32 v0, v74, v71
		v_add_u32_e32 v107, v107, v0
		v_mul_lo_u32 v0, v75, v70
		v_add_u32_e32 v107, v107, v0
		v_add_co_u32_e64 v212, vcc, v72, v106
		v_addc_co_u32_e64 v213, vcc, v73, v107, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v212, s48 offset:92
		scratch_store_dword off, v213, s48 offset:96
		v_add_co_u32_e64 v212, vcc, v94, v106
		v_addc_co_u32_e64 v213, vcc, v95, v107, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v212, s48 offset:100
		scratch_store_dword off, v213, s48 offset:104
		v_add_co_u32_e64 v212, vcc, v96, v106
		v_addc_co_u32_e64 v213, vcc, v97, v107, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v212, s48 offset:108
		scratch_store_dword off, v213, s48 offset:112
		v_add_co_u32_e64 v212, vcc, v98, v106
		v_addc_co_u32_e64 v213, vcc, v99, v107, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v212, s48 offset:116
		scratch_store_dword off, v213, s48 offset:120
		v_add_co_u32_e64 v212, vcc, v6, v106
		v_addc_co_u32_e64 v213, vcc, v7, v107, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v212, s48 offset:124
		scratch_store_dword off, v213, s48 offset:128
		v_add_co_u32_e64 v212, vcc, v104, v106
		v_addc_co_u32_e64 v213, vcc, v105, v107, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v212, s48 offset:132
		scratch_store_dword off, v213, s48 offset:136
		s_mov_b32 m0, s15
		s_waitcnt lgkmcnt(6)
		s_nop 0
		ds_read_addtid_b32 v212 offset:6144
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v213 offset:8192
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v214, vcc, v212, v106
		v_addc_co_u32_e64 v215, vcc, v213, v107, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v214, s48 offset:140
		scratch_store_dword off, v215, s48 offset:144
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v212 offset:10240
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v213 offset:12288
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v214, vcc, v212, v106
		v_addc_co_u32_e64 v215, vcc, v213, v107, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v214, s48 offset:148
		scratch_store_dword off, v215, s48 offset:152
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v212 offset:18432
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v213 offset:20480
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v214, v212, v70
		v_mul_hi_u32 v215, v212, v70
		v_mul_lo_u32 v0, v212, v71
		v_add_u32_e32 v215, v215, v0
		v_mul_lo_u32 v0, v213, v70
		v_add_u32_e32 v215, v215, v0
		s_mov_b32 s48, 0
		scratch_store_dword off, v214, s48 offset:188
		scratch_store_dword off, v215, s48 offset:192
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v212 offset:14336
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v213 offset:16384
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v216, vcc, v212, v214
		v_addc_co_u32_e64 v217, vcc, v213, v215, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v216, s48 offset:156
		scratch_store_dword off, v217, s48 offset:160
		v_add_co_u32_e64 v212, vcc, v92, v214
		v_addc_co_u32_e64 v213, vcc, v93, v215, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v212, s48 offset:164
		scratch_store_dword off, v213, s48 offset:168
		v_add_co_u32_e64 v212, vcc, v2, v214
		v_addc_co_u32_e64 v213, vcc, v3, v215, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v212, s48 offset:172
		scratch_store_dword off, v213, s48 offset:176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[20:23], v[36:39], v[12:15], v17, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s48, s47, 1
		s_mov_b32 m0, s15
		s_lshl_b32 s49, s48, 16
		ds_read_addtid_b32 v0 offset:22528
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v0, s49, v0
		v_add3_u32 v0, v0, v10, v4
		s_mov_b32 s50, 0
		scratch_store_dword off, v0, s50 offset:200
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[212:215], v5 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[20:23], v[40:43], v[76:79], v17, v19 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[216:219], v5 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[20:23], v[44:47], v[80:83], v17, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[220:223], v5 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[20:23], v[48:51], v[84:87], v17, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x800, v0
		ds_read_b128 v[224:227], v0 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[20:23], v[52:55], v[88:91], v17, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v0, s49, v10
		v_add3_u32 v0, v0, v1, v4
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[228:231], v5 offset:49152
		s_mov_b32 s49, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s49 offset:204
		scratch_store_dword off, v229, s49 offset:208
		scratch_store_dword off, v230, s49 offset:212
		scratch_store_dword off, v231, s49 offset:216
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[20:23], v[56:59], v[100:103], v17, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[228:231], v5 offset:50176
		s_mov_b32 s49, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s49 offset:220
		scratch_store_dword off, v229, s49 offset:224
		scratch_store_dword off, v230, s49 offset:228
		scratch_store_dword off, v231, s49 offset:232
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[20:23], v[60:63], v[108:111], v17, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[228:231], v5 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[20:23], v[64:67], v[112:115], v17, v18 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[232:235], v5 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[24:27], v[36:39], v[116:119], v17, v19 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[236:239], v5 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[24:27], v[40:43], v[120:123], v17, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[240:243], v5 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[24:27], v[44:47], v[124:127], v17, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[244:247], v5 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[24:27], v[48:51], v[128:131], v17, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[248:251], v5 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[24:27], v[52:55], v[132:135], v17, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(31)
		scratch_load_dword v20, off, s49 offset:92
		scratch_load_dword v21, off, s49 offset:96
		s_add_i32 m0, s19, 0x6000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v20, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[24:27], v[56:59], v[136:139], v17, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(29)
		scratch_load_dword v20, off, s49 offset:100
		scratch_load_dword v21, off, s49 offset:104
		s_add_i32 m0, s9, 0x6000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v20, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[24:27], v[60:63], v[140:143], v17, v18 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(27)
		scratch_load_dword v20, off, s49 offset:108
		scratch_load_dword v21, off, s49 offset:112
		s_add_i32 m0, s16, 0x6000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v20, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[64:67], v[144:147], v17, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(25)
		scratch_load_dword v20, off, s49 offset:116
		scratch_load_dword v21, off, s49 offset:120
		s_add_i32 m0, s32, 0x6000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v20, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[28:31], v[36:39], v[148:151], v9, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(23)
		scratch_load_dword v20, off, s49 offset:124
		scratch_load_dword v21, off, s49 offset:128
		s_add_i32 m0, s39, 0x6000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v20, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[28:31], v[40:43], v[152:155], v9, v19 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(21)
		scratch_load_dword v20, off, s49 offset:132
		scratch_load_dword v21, off, s49 offset:136
		s_add_i32 m0, s40, 0x6000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v20, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[28:31], v[44:47], v[156:159], v9, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(19)
		scratch_load_dword v20, off, s49 offset:140
		scratch_load_dword v21, off, s49 offset:144
		s_add_i32 m0, s41, 0x6000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v20, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[28:31], v[48:51], v[160:163], v9, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(17)
		scratch_load_dword v20, off, s49 offset:148
		scratch_load_dword v21, off, s49 offset:152
		s_add_i32 m0, s42, 0x6000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v20, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[28:31], v[52:55], v[164:167], v9, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(13)
		scratch_load_dword v20, off, s49 offset:156
		scratch_load_dword v21, off, s49 offset:160
		s_add_i32 m0, s11, 0x26000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dword v20, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[28:31], v[56:59], v[168:171], v9, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s49, s47, 1
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(11)
		scratch_load_dword v20, off, s50 offset:164
		scratch_load_dword v21, off, s50 offset:168
		s_add_i32 m0, s43, 0x26000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dword v20, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[28:31], v[60:63], v[172:175], v9, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshl_b32 s48, s48, 12
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(9)
		scratch_load_dword v20, off, s50 offset:172
		scratch_load_dword v21, off, s50 offset:176
		s_add_i32 m0, s44, 0x26000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[64:67], v[176:179], v9, v18 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v5, off, s50 offset:200
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[20:23], v5
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[32:35], v[36:39], v[180:183], v9, v19 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v5, off, s50 offset:200
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[24:27], v5 offset:1024
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[32:35], v[40:43], v[184:187], v9, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v5, off, s50 offset:200
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[28:31], v5 offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[32:35], v[44:47], v[188:191], v9, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v5, off, s50 offset:200
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[36:39], v5 offset:3072
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v36, s50 offset:236
		scratch_store_dword off, v37, s50 offset:240
		scratch_store_dword off, v38, s50 offset:244
		scratch_store_dword off, v39, s50 offset:248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[32:35], v[48:51], v[192:195], v9, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[36:39], v5 offset:32768
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[32:35], v[52:55], v[196:199], v9, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[40:43], v5 offset:33792
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[32:35], v[56:59], v[200:203], v9, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[44:47], v5 offset:34816
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[32:35], v[60:63], v[204:207], v9, v18 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[48:51], v5 offset:35840
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[64:67], v[208:211], v9, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[52:55], v5 offset:36864
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[56:59], v5 offset:37888
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[60:63], v5 offset:38912
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x800, v0
		ds_read_b128 v[64:67], v0 offset:39936
		s_mov_b32 m0, s15
		s_add_i32 s48, s48, 0x20000
		ds_read_addtid_b32 v0 offset:2048
		s_mov_b32 s50, 0
		scratch_load_dword v5, off, s50 offset:196
		s_waitcnt vmcnt(0) lgkmcnt(0)
		v_add3_u32 v0, s48, v0, v5
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b32 v8, v5
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v8, s50 offset:252
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x800, v0
		ds_read_b32 v5, v0 offset:256
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v5, s50 offset:256
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v0 offset:4096
		s_mov_b32 s50, 0
		scratch_load_dword v5, off, s50 offset:196
		s_waitcnt vmcnt(0) lgkmcnt(0)
		v_add3_u32 v0, s48, v5, v0
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b32 v8, v5 offset:2048
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v8, s48 offset:260
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b32 v8, v5 offset:2304
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v8, s48 offset:264
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b32 v8, v5 offset:2560
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v8, s48 offset:268
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x800, v0
		ds_read_b32 v5, v0 offset:2816
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v5, s48 offset:272
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(14)
		scratch_load_dword v32, off, s48 offset:204
		scratch_load_dword v33, off, s48 offset:208
		scratch_load_dword v34, off, s48 offset:212
		scratch_load_dword v35, off, s48 offset:216
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[212:215], v[32:35], v[12:15], v17, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(10)
		scratch_load_dword v32, off, s48 offset:220
		scratch_load_dword v33, off, s48 offset:224
		scratch_load_dword v34, off, s48 offset:228
		scratch_load_dword v35, off, s48 offset:232
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[212:215], v[32:35], v[76:79], v17, v19 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v32, off, s48 offset:220
		scratch_load_dword v33, off, s48 offset:224
		scratch_load_dword v34, off, s48 offset:228
		scratch_load_dword v35, off, s48 offset:232
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[216:219], v[32:35], v[120:123], v17, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v32, off, s48 offset:204
		scratch_load_dword v33, off, s48 offset:208
		scratch_load_dword v34, off, s48 offset:212
		scratch_load_dword v35, off, s48 offset:216
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[216:219], v[32:35], v[116:119], v17, v19 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[216:219], v[228:231], v[124:127], v17, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[212:215], v[228:231], v[80:83], v17, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[212:215], v[232:235], v[84:87], v17, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[216:219], v[232:235], v[128:131], v17, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[216:219], v[236:239], v[132:135], v17, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[212:215], v[236:239], v[88:91], v17, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[212:215], v[240:243], v[100:103], v17, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[216:219], v[240:243], v[136:139], v17, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[216:219], v[244:247], v[140:143], v17, v18 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[212:215], v[244:247], v[108:111], v17, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[212:215], v[248:251], v[112:115], v17, v18 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[216:219], v[248:251], v[144:147], v17, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[220:223], v[248:251], v[176:179], v9, v18 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[220:223], v[244:247], v[172:175], v9, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[224:227], v[244:247], v[204:207], v9, v18 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[224:227], v[248:251], v[208:211], v9, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v32, off, s48 offset:204
		scratch_load_dword v33, off, s48 offset:208
		scratch_load_dword v34, off, s48 offset:212
		scratch_load_dword v35, off, s48 offset:216
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[224:227], v[32:35], v[180:183], v9, v19 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v32, off, s48 offset:204
		scratch_load_dword v33, off, s48 offset:208
		scratch_load_dword v34, off, s48 offset:212
		scratch_load_dword v35, off, s48 offset:216
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[220:223], v[32:35], v[148:151], v9, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v32, off, s48 offset:220
		scratch_load_dword v33, off, s48 offset:224
		scratch_load_dword v34, off, s48 offset:228
		scratch_load_dword v35, off, s48 offset:232
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[220:223], v[32:35], v[152:155], v9, v19 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v32, off, s48 offset:220
		scratch_load_dword v33, off, s48 offset:224
		scratch_load_dword v34, off, s48 offset:228
		scratch_load_dword v35, off, s48 offset:232
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[224:227], v[32:35], v[184:187], v9, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[224:227], v[228:231], v[188:191], v9, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[220:223], v[228:231], v[156:159], v9, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[220:223], v[232:235], v[160:163], v9, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[224:227], v[232:235], v[192:195], v9, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[224:227], v[236:239], v[196:199], v9, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[220:223], v[236:239], v[164:167], v9, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[220:223], v[240:243], v[168:171], v9, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[224:227], v[240:243], v[200:203], v9, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s48, s49, 1
		s_mov_b32 m0, s15
		s_lshl_b32 s49, s48, 16
		ds_read_addtid_b32 v0 offset:22528
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v0, s49, v0
		s_mov_b32 s50, 0
		scratch_load_dword v5, off, s50 offset:180
		s_mov_b32 s50, 0
		scratch_load_dword v8, off, s50 offset:184
		s_waitcnt vmcnt(0)
		v_add3_u32 v0, v0, v5, v8
		s_mov_b32 s50, 0
		scratch_store_dword off, v0, s50 offset:276
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[16:19], v5
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v16, s50 offset:432
		scratch_store_dword off, v17, s50 offset:436
		scratch_store_dword off, v18, s50 offset:440
		scratch_store_dword off, v19, s50 offset:444
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[32:35], v5 offset:1024
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v32, s50 offset:564
		scratch_store_dword off, v33, s50 offset:568
		scratch_store_dword off, v34, s50 offset:572
		scratch_store_dword off, v35, s50 offset:576
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[212:215], v5 offset:2048
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v212, s50 offset:596
		scratch_store_dword off, v213, s50 offset:600
		scratch_store_dword off, v214, s50 offset:604
		scratch_store_dword off, v215, s50 offset:608
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x800, v0
		ds_read_b128 v[216:219], v0 offset:3072
		s_mov_b32 s50, 0
		scratch_load_dword v0, off, s50 offset:180
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v0, s49, v0
		s_mov_b32 s49, 0
		scratch_load_dword v5, off, s49 offset:88
		s_mov_b32 s49, 0
		scratch_load_dword v8, off, s49 offset:184
		s_waitcnt vmcnt(0)
		v_add3_u32 v0, v0, v5, v8
		s_mov_b32 s49, 0
		scratch_store_dword off, v0, s49 offset:512
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[220:223], v5 offset:32768
		s_mov_b32 s49, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v220, s49 offset:280
		scratch_store_dword off, v221, s49 offset:284
		scratch_store_dword off, v222, s49 offset:288
		scratch_store_dword off, v223, s49 offset:292
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[220:223], v5 offset:33792
		s_mov_b32 s49, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v220, s49 offset:384
		scratch_store_dword off, v221, s49 offset:388
		scratch_store_dword off, v222, s49 offset:392
		scratch_store_dword off, v223, s49 offset:396
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[224:227], v5 offset:34816
		s_mov_b32 s49, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v224, s49 offset:400
		scratch_store_dword off, v225, s49 offset:404
		scratch_store_dword off, v226, s49 offset:408
		scratch_store_dword off, v227, s49 offset:412
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[228:231], v5 offset:35840
		s_mov_b32 s49, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s49 offset:416
		scratch_store_dword off, v229, s49 offset:420
		scratch_store_dword off, v230, s49 offset:424
		scratch_store_dword off, v231, s49 offset:428
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[232:235], v5 offset:36864
		s_mov_b32 s49, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v232, s49 offset:448
		scratch_store_dword off, v233, s49 offset:452
		scratch_store_dword off, v234, s49 offset:456
		scratch_store_dword off, v235, s49 offset:460
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[236:239], v5 offset:37888
		s_mov_b32 s49, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s49 offset:464
		scratch_store_dword off, v237, s49 offset:468
		scratch_store_dword off, v238, s49 offset:472
		scratch_store_dword off, v239, s49 offset:476
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[240:243], v5 offset:38912
		s_mov_b32 s49, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v240, s49 offset:480
		scratch_store_dword off, v241, s49 offset:484
		scratch_store_dword off, v242, s49 offset:488
		scratch_store_dword off, v243, s49 offset:492
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[244:247], v5 offset:39936
		s_mov_b32 s49, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v244, s49 offset:496
		scratch_store_dword off, v245, s49 offset:500
		scratch_store_dword off, v246, s49 offset:504
		scratch_store_dword off, v247, s49 offset:508
		s_lshl_b32 s48, s48, 12
		s_mov_b32 m0, s15
		s_add_i32 s48, s48, 0x20000
		ds_read_addtid_b32 v5 offset:2048
		s_mov_b32 s49, 0
		scratch_load_dword v8, off, s49 offset:196
		s_waitcnt vmcnt(0) lgkmcnt(0)
		v_add3_u32 v5, s48, v5, v8
		v_add_u32_e32 v8, 0x800, v5
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x800, v8
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x800, v8
		ds_read_b32 v11, v8
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b32 v8, v5 offset:256
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v5 offset:4096
		s_mov_b32 s49, 0
		scratch_load_dword v9, off, s49 offset:196
		s_waitcnt vmcnt(0) lgkmcnt(0)
		v_add3_u32 v5, s48, v9, v5
		v_add_u32_e32 v9, 0x800, v5
		v_add_u32_e32 v9, 0x800, v9
		v_add_u32_e32 v9, 0x800, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x800, v9
		ds_read_b32 v248, v9 offset:2048
		v_add_u32_e32 v9, 0x800, v5
		v_add_u32_e32 v9, 0x800, v9
		v_add_u32_e32 v9, 0x800, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x800, v9
		ds_read_b32 v249, v9 offset:2304
		v_add_u32_e32 v9, 0x800, v5
		v_add_u32_e32 v9, 0x800, v9
		v_add_u32_e32 v9, 0x800, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x1000, v9
		v_add_u32_e32 v9, 0x800, v9
		ds_read_b32 v250, v9 offset:2560
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b32 v251, v5 offset:2816
		s_mov_b32 s48, 0
		scratch_load_dword v68, off, s48
		scratch_load_dword v69, off, s48 offset:4
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v252, vcc, v68, v106
		v_addc_co_u32_e64 v253, vcc, v69, v107, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v252, s48 offset:296
		scratch_store_dword off, v253, s48 offset:300
		s_mov_b32 s48, 0
		scratch_load_dword v68, off, s48 offset:8
		scratch_load_dword v69, off, s48 offset:12
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v252, vcc, v68, v106
		v_addc_co_u32_e64 v253, vcc, v69, v107, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v252, s48 offset:304
		scratch_store_dword off, v253, s48 offset:308
		s_mov_b32 s48, 0
		scratch_load_dword v68, off, s48 offset:16
		scratch_load_dword v69, off, s48 offset:20
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v252, vcc, v68, v106
		v_addc_co_u32_e64 v253, vcc, v69, v107, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v252, s48 offset:312
		scratch_store_dword off, v253, s48 offset:316
		s_mov_b32 s48, 0
		scratch_load_dword v68, off, s48 offset:24
		scratch_load_dword v69, off, s48 offset:28
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v252, vcc, v68, v106
		v_addc_co_u32_e64 v253, vcc, v69, v107, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v252, s48 offset:320
		scratch_store_dword off, v253, s48 offset:324
		s_mov_b32 s48, 0
		scratch_load_dword v68, off, s48 offset:32
		scratch_load_dword v69, off, s48 offset:36
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v252, vcc, v68, v106
		v_addc_co_u32_e64 v253, vcc, v69, v107, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v252, s48 offset:328
		scratch_store_dword off, v253, s48 offset:332
		s_mov_b32 s48, 0
		scratch_load_dword v68, off, s48 offset:40
		scratch_load_dword v69, off, s48 offset:44
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v252, vcc, v68, v106
		v_addc_co_u32_e64 v253, vcc, v69, v107, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v252, s48 offset:336
		scratch_store_dword off, v253, s48 offset:340
		s_mov_b32 s48, 0
		scratch_load_dword v68, off, s48 offset:48
		scratch_load_dword v69, off, s48 offset:52
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v252, vcc, v68, v106
		v_addc_co_u32_e64 v253, vcc, v69, v107, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v252, s48 offset:344
		scratch_store_dword off, v253, s48 offset:348
		s_mov_b32 s48, 0
		scratch_load_dword v68, off, s48 offset:56
		scratch_load_dword v69, off, s48 offset:60
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v252, vcc, v68, v106
		v_addc_co_u32_e64 v253, vcc, v69, v107, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v252, s48 offset:352
		scratch_store_dword off, v253, s48 offset:356
		s_mov_b32 s48, 0
		scratch_load_dword v68, off, s48 offset:64
		scratch_load_dword v69, off, s48 offset:68
		s_mov_b32 s48, 0
		scratch_load_dword v106, off, s48 offset:188
		scratch_load_dword v107, off, s48 offset:192
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v252, vcc, v68, v106
		v_addc_co_u32_e64 v253, vcc, v69, v107, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v252, s48 offset:360
		scratch_store_dword off, v253, s48 offset:364
		s_mov_b32 s48, 0
		scratch_load_dword v68, off, s48 offset:72
		scratch_load_dword v69, off, s48 offset:76
		s_mov_b32 s48, 0
		scratch_load_dword v106, off, s48 offset:188
		scratch_load_dword v107, off, s48 offset:192
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v252, vcc, v68, v106
		v_addc_co_u32_e64 v253, vcc, v69, v107, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v252, s48 offset:368
		scratch_store_dword off, v253, s48 offset:372
		s_mov_b32 s48, 0
		scratch_load_dword v68, off, s48 offset:80
		scratch_load_dword v69, off, s48 offset:84
		s_mov_b32 s48, 0
		scratch_load_dword v106, off, s48 offset:188
		scratch_load_dword v107, off, s48 offset:192
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v252, vcc, v68, v106
		v_addc_co_u32_e64 v253, vcc, v69, v107, vcc
		s_mov_b32 s48, 0
		scratch_store_dword off, v252, s48 offset:376
		scratch_store_dword off, v253, s48 offset:380
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(50)
		scratch_load_dword v252, off, s48 offset:280
		scratch_load_dword v253, off, s48 offset:284
		scratch_load_dword v254, off, s48 offset:288
		scratch_load_dword v255, off, s48 offset:292
		s_waitcnt vmcnt(0) lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[16:19], v[252:255], v[12:15], v11, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v5, off, s48 offset:276
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[252:255], v5 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[16:19], v[220:223], v[76:79], v11, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v5, off, s48 offset:276
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[220:223], v5 offset:17408
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[16:19], v[224:227], v[80:83], v11, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v5, off, s48 offset:276
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[224:227], v5 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[16:19], v[228:231], v[84:87], v11, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v5, off, s48 offset:276
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[228:231], v5 offset:19456
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[16:19], v[232:235], v[88:91], v11, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[16:19], v5 offset:49152
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v16, s48 offset:516
		scratch_store_dword off, v17, s48 offset:520
		scratch_store_dword off, v18, s48 offset:524
		scratch_store_dword off, v19, s48 offset:528
		s_mov_b32 s48, 0
		scratch_load_dword v16, off, s48 offset:432
		scratch_load_dword v17, off, s48 offset:436
		scratch_load_dword v18, off, s48 offset:440
		scratch_load_dword v19, off, s48 offset:444
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[16:19], v[236:239], v[100:103], v11, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[16:19], v5 offset:50176
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v16, s48 offset:532
		scratch_store_dword off, v17, s48 offset:536
		scratch_store_dword off, v18, s48 offset:540
		scratch_store_dword off, v19, s48 offset:544
		s_mov_b32 s48, 0
		scratch_load_dword v16, off, s48 offset:432
		scratch_load_dword v17, off, s48 offset:436
		scratch_load_dword v18, off, s48 offset:440
		scratch_load_dword v19, off, s48 offset:444
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[16:19], v[240:243], v[108:111], v11, v251 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[16:19], v5 offset:51200
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v16, s48 offset:548
		scratch_store_dword off, v17, s48 offset:552
		scratch_store_dword off, v18, s48 offset:556
		scratch_store_dword off, v19, s48 offset:560
		s_mov_b32 s48, 0
		scratch_load_dword v16, off, s48 offset:432
		scratch_load_dword v17, off, s48 offset:436
		scratch_load_dword v18, off, s48 offset:440
		scratch_load_dword v19, off, s48 offset:444
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[16:19], v[244:247], v[112:115], v11, v251 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v5, 0x800, v0
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x800, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x800, v5
		ds_read_b128 v[16:19], v5 offset:52224
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v16, s48 offset:580
		scratch_store_dword off, v17, s48 offset:584
		scratch_store_dword off, v18, s48 offset:588
		scratch_store_dword off, v19, s48 offset:592
		s_mov_b32 s48, 0
		scratch_load_dword v16, off, s48 offset:280
		scratch_load_dword v17, off, s48 offset:284
		scratch_load_dword v18, off, s48 offset:288
		scratch_load_dword v19, off, s48 offset:292
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[32:35], v[16:19], v[116:119], v11, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x800, v0
		ds_read_b128 v[16:19], v0 offset:53248
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v16, s48 offset:612
		scratch_store_dword off, v17, s48 offset:616
		scratch_store_dword off, v18, s48 offset:620
		scratch_store_dword off, v19, s48 offset:624
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(63) expcnt(7) lgkmcnt(15)
		scratch_load_dword v16, off, s48 offset:384
		scratch_load_dword v17, off, s48 offset:388
		scratch_load_dword v18, off, s48 offset:392
		scratch_load_dword v19, off, s48 offset:396
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[32:35], v[16:19], v[120:123], v11, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v0, off, s48 offset:512
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x800, v0
		ds_read_b128 v[232:235], v0 offset:54272
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(62)
		scratch_load_dword v16, off, s48 offset:400
		scratch_load_dword v17, off, s48 offset:404
		scratch_load_dword v18, off, s48 offset:408
		scratch_load_dword v19, off, s48 offset:412
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], v[16:19], v[124:127], v11, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v0, off, s48 offset:512
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x800, v0
		ds_read_b128 v[236:239], v0 offset:55296
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(58)
		scratch_load_dword v16, off, s48 offset:416
		scratch_load_dword v17, off, s48 offset:420
		scratch_load_dword v18, off, s48 offset:424
		scratch_load_dword v19, off, s48 offset:428
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[32:35], v[16:19], v[128:131], v11, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v0, off, s48 offset:512
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x800, v0
		ds_read_b128 v[240:243], v0 offset:56320
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(54)
		scratch_load_dword v16, off, s48 offset:448
		scratch_load_dword v17, off, s48 offset:452
		scratch_load_dword v18, off, s48 offset:456
		scratch_load_dword v19, off, s48 offset:460
		s_mov_b32 s48, 0
		scratch_load_dword v32, off, s48 offset:564
		scratch_load_dword v33, off, s48 offset:568
		scratch_load_dword v34, off, s48 offset:572
		scratch_load_dword v35, off, s48 offset:576
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], v[16:19], v[132:135], v11, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(40)
		scratch_load_dword v16, off, s48 offset:296
		scratch_load_dword v17, off, s48 offset:300
		s_add_i32 m0, s10, 0x6000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v16, s[20:23], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v16, off, s48 offset:464
		scratch_load_dword v17, off, s48 offset:468
		scratch_load_dword v18, off, s48 offset:472
		scratch_load_dword v19, off, s48 offset:476
		s_mov_b32 s48, 0
		scratch_load_dword v32, off, s48 offset:564
		scratch_load_dword v33, off, s48 offset:568
		scratch_load_dword v34, off, s48 offset:572
		scratch_load_dword v35, off, s48 offset:576
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[32:35], v[16:19], v[136:139], v11, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(38)
		scratch_load_dword v16, off, s48 offset:304
		scratch_load_dword v17, off, s48 offset:308
		s_add_i32 m0, s45, 0x6000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v16, s[20:23], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v16, off, s48 offset:480
		scratch_load_dword v17, off, s48 offset:484
		scratch_load_dword v18, off, s48 offset:488
		scratch_load_dword v19, off, s48 offset:492
		s_mov_b32 s48, 0
		scratch_load_dword v32, off, s48 offset:564
		scratch_load_dword v33, off, s48 offset:568
		scratch_load_dword v34, off, s48 offset:572
		scratch_load_dword v35, off, s48 offset:576
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[32:35], v[16:19], v[140:143], v11, v251 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(36)
		scratch_load_dword v16, off, s48 offset:312
		scratch_load_dword v17, off, s48 offset:316
		s_add_i32 m0, s46, 0x6000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v16, s[20:23], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v16, off, s48 offset:496
		scratch_load_dword v17, off, s48 offset:500
		scratch_load_dword v18, off, s48 offset:504
		scratch_load_dword v19, off, s48 offset:508
		s_mov_b32 s48, 0
		scratch_load_dword v32, off, s48 offset:564
		scratch_load_dword v33, off, s48 offset:568
		scratch_load_dword v34, off, s48 offset:572
		scratch_load_dword v35, off, s48 offset:576
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[32:35], v[16:19], v[144:147], v11, v251 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(34)
		scratch_load_dword v16, off, s48 offset:320
		scratch_load_dword v17, off, s48 offset:324
		s_mov_b32 s48, 0
		scratch_load_dword v0, off, s48 offset:272
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v18, v0
		s_add_i32 m0, s34, 0x6000
		s_nop 0
		buffer_load_dwordx4 v16, s[20:23], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v32, off, s48 offset:280
		scratch_load_dword v33, off, s48 offset:284
		scratch_load_dword v34, off, s48 offset:288
		scratch_load_dword v35, off, s48 offset:292
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[212:215], v[32:35], v[148:151], v8, v248 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(32)
		scratch_load_dword v16, off, s48 offset:328
		scratch_load_dword v17, off, s48 offset:332
		s_mov_b32 s48, 0
		scratch_load_dword v0, off, s48 offset:268
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v69, v0
		s_add_i32 m0, s35, 0x6000
		s_nop 0
		buffer_load_dwordx4 v16, s[0:3], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v32, off, s48 offset:384
		scratch_load_dword v33, off, s48 offset:388
		scratch_load_dword v34, off, s48 offset:392
		scratch_load_dword v35, off, s48 offset:396
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[212:215], v[32:35], v[152:155], v8, v248 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(30)
		scratch_load_dword v16, off, s48 offset:336
		scratch_load_dword v17, off, s48 offset:340
		s_mov_b32 s48, 0
		scratch_load_dword v0, off, s48 offset:264
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v68, v0
		s_add_i32 m0, s36, 0x6000
		s_nop 0
		buffer_load_dwordx4 v16, s[0:3], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v32, off, s48 offset:400
		scratch_load_dword v33, off, s48 offset:404
		scratch_load_dword v34, off, s48 offset:408
		scratch_load_dword v35, off, s48 offset:412
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[212:215], v[32:35], v[156:159], v8, v249 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(28)
		scratch_load_dword v16, off, s48 offset:344
		scratch_load_dword v17, off, s48 offset:348
		s_mov_b32 s48, 0
		scratch_load_dword v0, off, s48 offset:260
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v19, v0
		s_add_i32 m0, s37, 0x6000
		s_nop 0
		buffer_load_dwordx4 v16, s[0:3], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v32, off, s48 offset:416
		scratch_load_dword v33, off, s48 offset:420
		scratch_load_dword v34, off, s48 offset:424
		scratch_load_dword v35, off, s48 offset:428
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[212:215], v[32:35], v[160:163], v8, v249 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(26)
		scratch_load_dword v16, off, s48 offset:352
		scratch_load_dword v17, off, s48 offset:356
		s_mov_b32 s48, 0
		scratch_load_dword v0, off, s48 offset:256
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v9, v0
		s_add_i32 m0, s38, 0x6000
		s_nop 0
		buffer_load_dwordx4 v16, s[0:3], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v32, off, s48 offset:448
		scratch_load_dword v33, off, s48 offset:452
		scratch_load_dword v34, off, s48 offset:456
		scratch_load_dword v35, off, s48 offset:460
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[212:215], v[32:35], v[164:167], v8, v250 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v32, off, s48 offset:360
		scratch_load_dword v33, off, s48 offset:364
		s_mov_b32 s48, 0
		scratch_load_dword v0, off, s48 offset:252
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v17, v0
		s_add_i32 m0, s33, 0x26000
		s_nop 0
		buffer_load_dword v32, s[24:27], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v32, off, s48 offset:464
		scratch_load_dword v33, off, s48 offset:468
		scratch_load_dword v34, off, s48 offset:472
		scratch_load_dword v35, off, s48 offset:476
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[212:215], v[32:35], v[168:171], v8, v250 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(22)
		scratch_load_dword v106, off, s48 offset:368
		scratch_load_dword v107, off, s48 offset:372
		s_mov_b32 s48, 0
		scratch_load_dword v32, off, s48 offset:236
		scratch_load_dword v33, off, s48 offset:240
		scratch_load_dword v34, off, s48 offset:244
		scratch_load_dword v35, off, s48 offset:248
		s_add_i32 m0, s5, 0x26000
		s_waitcnt vmcnt(4)
		s_nop 0
		buffer_load_dword v106, s[24:27], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v212, off, s48 offset:480
		scratch_load_dword v213, off, s48 offset:484
		scratch_load_dword v214, off, s48 offset:488
		scratch_load_dword v215, off, s48 offset:492
		s_mov_b32 s48, 0
		scratch_load_dword v244, off, s48 offset:596
		scratch_load_dword v245, off, s48 offset:600
		scratch_load_dword v246, off, s48 offset:604
		scratch_load_dword v247, off, s48 offset:608
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[244:247], v[212:215], v[172:175], v8, v251 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s47, s47, 2
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(20)
		scratch_load_dword v106, off, s48 offset:376
		scratch_load_dword v107, off, s48 offset:380
		s_add_i32 m0, s8, 0x26000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v106, s[28:31], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v212, off, s48 offset:496
		scratch_load_dword v213, off, s48 offset:500
		scratch_load_dword v214, off, s48 offset:504
		scratch_load_dword v215, off, s48 offset:508
		s_mov_b32 s48, 0
		scratch_load_dword v244, off, s48 offset:596
		scratch_load_dword v245, off, s48 offset:600
		scratch_load_dword v246, off, s48 offset:604
		scratch_load_dword v247, off, s48 offset:608
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[244:247], v[212:215], v[176:179], v8, v251 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v212, off, s48 offset:496
		scratch_load_dword v213, off, s48 offset:500
		scratch_load_dword v214, off, s48 offset:504
		scratch_load_dword v215, off, s48 offset:508
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[216:219], v[212:215], v[208:211], v8, v251 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v212, off, s48 offset:480
		scratch_load_dword v213, off, s48 offset:484
		scratch_load_dword v214, off, s48 offset:488
		scratch_load_dword v215, off, s48 offset:492
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[216:219], v[212:215], v[204:207], v8, v251 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v212, off, s48 offset:280
		scratch_load_dword v213, off, s48 offset:284
		scratch_load_dword v214, off, s48 offset:288
		scratch_load_dword v215, off, s48 offset:292
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[216:219], v[212:215], v[180:183], v8, v248 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v212, off, s48 offset:384
		scratch_load_dword v213, off, s48 offset:388
		scratch_load_dword v214, off, s48 offset:392
		scratch_load_dword v215, off, s48 offset:396
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[216:219], v[212:215], v[184:187], v8, v248 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v212, off, s48 offset:400
		scratch_load_dword v213, off, s48 offset:404
		scratch_load_dword v214, off, s48 offset:408
		scratch_load_dword v215, off, s48 offset:412
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[216:219], v[212:215], v[188:191], v8, v249 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v212, off, s48 offset:416
		scratch_load_dword v213, off, s48 offset:420
		scratch_load_dword v214, off, s48 offset:424
		scratch_load_dword v215, off, s48 offset:428
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[216:219], v[212:215], v[192:195], v8, v249 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v212, off, s48 offset:448
		scratch_load_dword v213, off, s48 offset:452
		scratch_load_dword v214, off, s48 offset:456
		scratch_load_dword v215, off, s48 offset:460
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[216:219], v[212:215], v[196:199], v8, v250 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v212, off, s48 offset:464
		scratch_load_dword v213, off, s48 offset:468
		scratch_load_dword v214, off, s48 offset:472
		scratch_load_dword v215, off, s48 offset:476
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[216:219], v[212:215], v[200:203], v8, v250 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v212, off, s48 offset:516
		scratch_load_dword v213, off, s48 offset:520
		scratch_load_dword v214, off, s48 offset:524
		scratch_load_dword v215, off, s48 offset:528
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[252:255], v[212:215], v[12:15], v11, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(12)
		scratch_load_dword v212, off, s48 offset:532
		scratch_load_dword v213, off, s48 offset:536
		scratch_load_dword v214, off, s48 offset:540
		scratch_load_dword v215, off, s48 offset:544
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[252:255], v[212:215], v[76:79], v11, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v212, off, s48 offset:532
		scratch_load_dword v213, off, s48 offset:536
		scratch_load_dword v214, off, s48 offset:540
		scratch_load_dword v215, off, s48 offset:544
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[220:223], v[212:215], v[120:123], v11, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v212, off, s48 offset:516
		scratch_load_dword v213, off, s48 offset:520
		scratch_load_dword v214, off, s48 offset:524
		scratch_load_dword v215, off, s48 offset:528
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[220:223], v[212:215], v[116:119], v11, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v212, off, s48 offset:548
		scratch_load_dword v213, off, s48 offset:552
		scratch_load_dword v214, off, s48 offset:556
		scratch_load_dword v215, off, s48 offset:560
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[220:223], v[212:215], v[124:127], v11, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v212, off, s48 offset:548
		scratch_load_dword v213, off, s48 offset:552
		scratch_load_dword v214, off, s48 offset:556
		scratch_load_dword v215, off, s48 offset:560
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[252:255], v[212:215], v[80:83], v11, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v212, off, s48 offset:580
		scratch_load_dword v213, off, s48 offset:584
		scratch_load_dword v214, off, s48 offset:588
		scratch_load_dword v215, off, s48 offset:592
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[252:255], v[212:215], v[84:87], v11, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v212, off, s48 offset:580
		scratch_load_dword v213, off, s48 offset:584
		scratch_load_dword v214, off, s48 offset:588
		scratch_load_dword v215, off, s48 offset:592
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[220:223], v[212:215], v[128:131], v11, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v212, off, s48 offset:612
		scratch_load_dword v213, off, s48 offset:616
		scratch_load_dword v214, off, s48 offset:620
		scratch_load_dword v215, off, s48 offset:624
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[220:223], v[212:215], v[132:135], v11, v250 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v212, off, s48 offset:612
		scratch_load_dword v213, off, s48 offset:616
		scratch_load_dword v214, off, s48 offset:620
		scratch_load_dword v215, off, s48 offset:624
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[252:255], v[212:215], v[88:91], v11, v250 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[252:255], v[232:235], v[100:103], v11, v250 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[220:223], v[232:235], v[136:139], v11, v250 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[220:223], v[236:239], v[140:143], v11, v251 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[252:255], v[236:239], v[108:111], v11, v251 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[252:255], v[240:243], v[112:115], v11, v251 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[220:223], v[240:243], v[144:147], v11, v251 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[224:227], v[240:243], v[176:179], v8, v251 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[224:227], v[236:239], v[172:175], v8, v251 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[228:231], v[236:239], v[204:207], v8, v251 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[228:231], v[240:243], v[208:211], v8, v251 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v212, off, s48 offset:516
		scratch_load_dword v213, off, s48 offset:520
		scratch_load_dword v214, off, s48 offset:524
		scratch_load_dword v215, off, s48 offset:528
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[228:231], v[212:215], v[180:183], v8, v248 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v212, off, s48 offset:516
		scratch_load_dword v213, off, s48 offset:520
		scratch_load_dword v214, off, s48 offset:524
		scratch_load_dword v215, off, s48 offset:528
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[224:227], v[212:215], v[148:151], v8, v248 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v212, off, s48 offset:532
		scratch_load_dword v213, off, s48 offset:536
		scratch_load_dword v214, off, s48 offset:540
		scratch_load_dword v215, off, s48 offset:544
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[224:227], v[212:215], v[152:155], v8, v248 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v212, off, s48 offset:532
		scratch_load_dword v213, off, s48 offset:536
		scratch_load_dword v214, off, s48 offset:540
		scratch_load_dword v215, off, s48 offset:544
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[228:231], v[212:215], v[184:187], v8, v248 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v212, off, s48 offset:548
		scratch_load_dword v213, off, s48 offset:552
		scratch_load_dword v214, off, s48 offset:556
		scratch_load_dword v215, off, s48 offset:560
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[228:231], v[212:215], v[188:191], v8, v249 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v212, off, s48 offset:548
		scratch_load_dword v213, off, s48 offset:552
		scratch_load_dword v214, off, s48 offset:556
		scratch_load_dword v215, off, s48 offset:560
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[224:227], v[212:215], v[156:159], v8, v249 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v212, off, s48 offset:580
		scratch_load_dword v213, off, s48 offset:584
		scratch_load_dword v214, off, s48 offset:588
		scratch_load_dword v215, off, s48 offset:592
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[224:227], v[212:215], v[160:163], v8, v249 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v212, off, s48 offset:580
		scratch_load_dword v213, off, s48 offset:584
		scratch_load_dword v214, off, s48 offset:588
		scratch_load_dword v215, off, s48 offset:592
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[228:231], v[212:215], v[192:195], v8, v249 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v212, off, s48 offset:612
		scratch_load_dword v213, off, s48 offset:616
		scratch_load_dword v214, off, s48 offset:620
		scratch_load_dword v215, off, s48 offset:624
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[228:231], v[212:215], v[196:199], v8, v250 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		scratch_load_dword v212, off, s48 offset:612
		scratch_load_dword v213, off, s48 offset:616
		scratch_load_dword v214, off, s48 offset:620
		scratch_load_dword v215, off, s48 offset:624
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[224:227], v[212:215], v[164:167], v8, v250 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[224:227], v[232:235], v[168:171], v8, v250 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[228:231], v[232:235], v[200:203], v8, v250 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_cmp_lt_i32 s47, s4
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_add_i32 s0, s12, -1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[20:23], v[36:39], v[12:15], v17, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s0, s0, 1
		s_mov_b32 m0, s15
		s_lshl_b32 s0, s0, 16
		ds_read_addtid_b32 v0 offset:22528
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v0, s0, v0
		s_mov_b32 s1, 0
		scratch_load_dword v1, off, s1 offset:180
		s_mov_b32 s1, 0
		scratch_load_dword v2, off, s1 offset:184
		s_waitcnt vmcnt(0)
		v_add3_u32 v0, v0, v1, v2
		v_add_u32_e32 v1, 0x800, v0
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x800, v1
		ds_read_b128 v[4:7], v1 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[20:23], v[40:43], v[76:79], v17, v19 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x800, v0
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x800, v1
		ds_read_b128 v[72:75], v1 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[20:23], v[44:47], v[80:83], v17, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x800, v0
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x800, v1
		ds_read_b128 v[92:95], v1 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[20:23], v[48:51], v[84:87], v17, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x800, v0
		ds_read_b128 v[96:99], v0 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[20:23], v[52:55], v[88:91], v17, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s1, 0
		scratch_load_dword v0, off, s1 offset:180
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v0, s0, v0
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:88
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:184
		s_waitcnt vmcnt(0)
		v_add3_u32 v0, v0, v1, v2
		v_add_u32_e32 v1, 0x800, v0
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x800, v1
		ds_read_b128 v[104:107], v1 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[20:23], v[56:59], v[100:103], v17, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x800, v0
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x800, v1
		ds_read_b128 v[212:215], v1 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[20:23], v[60:63], v[108:111], v17, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x800, v0
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x800, v1
		ds_read_b128 v[216:219], v1 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[20:23], v[64:67], v[112:115], v17, v18 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x800, v0
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x800, v1
		ds_read_b128 v[20:23], v1 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[24:27], v[36:39], v[116:119], v17, v19 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x800, v0
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x800, v1
		ds_read_b128 v[220:223], v1 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[24:27], v[40:43], v[120:123], v17, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x800, v0
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x800, v1
		ds_read_b128 v[224:227], v1 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[24:27], v[44:47], v[124:127], v17, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x800, v0
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x800, v1
		ds_read_b128 v[228:231], v1 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[24:27], v[48:51], v[128:131], v17, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x800, v0
		ds_read_b128 v[232:235], v0 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[24:27], v[52:55], v[132:135], v17, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[24:27], v[56:59], v[136:139], v17, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[24:27], v[60:63], v[140:143], v17, v18 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[64:67], v[144:147], v17, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[64:67], v[176:179], v9, v18 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[28:31], v[60:63], v[172:175], v9, v18 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[32:35], v[60:63], v[204:207], v9, v18 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[64:67], v[208:211], v9, v18 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[32:35], v[36:39], v[180:183], v9, v19 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[28:31], v[36:39], v[148:151], v9, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[28:31], v[40:43], v[152:155], v9, v19 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[32:35], v[40:43], v[184:187], v9, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[32:35], v[44:47], v[188:191], v9, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[28:31], v[44:47], v[156:159], v9, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[28:31], v[48:51], v[160:163], v9, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[32:35], v[48:51], v[192:195], v9, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[32:35], v[52:55], v[196:199], v9, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[28:31], v[52:55], v[164:167], v9, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[28:31], v[56:59], v[168:171], v9, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[32:35], v[56:59], v[200:203], v9, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[92:95], v[220:223], v[164:167], v9, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[92:95], v[224:227], v[168:171], v9, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[96:99], v[224:227], v[200:203], v9, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[96:99], v[220:223], v[196:199], v9, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[4:7], v[220:223], v[88:91], v17, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[4:7], v[224:227], v[100:103], v17, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[72:75], v[224:227], v[136:139], v17, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[72:75], v[220:223], v[132:135], v17, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[72:75], v[104:107], v[116:119], v17, v19 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[4:7], v[104:107], v[12:15], v17, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[4:7], v[212:215], v[76:79], v17, v19 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[72:75], v[212:215], v[120:123], v17, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[72:75], v[216:219], v[124:127], v17, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[4:7], v[216:219], v[80:83], v17, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[4:7], v[20:23], v[84:87], v17, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[72:75], v[20:23], v[128:131], v17, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[72:75], v[228:231], v[140:143], v17, v18 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[4:7], v[228:231], v[108:111], v17, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[4:7], v[232:235], v[112:115], v17, v18 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[72:75], v[232:235], v[144:147], v17, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[92:95], v[232:235], v[176:179], v9, v18 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[92:95], v[228:231], v[172:175], v9, v18 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[96:99], v[228:231], v[204:207], v9, v18 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[96:99], v[232:235], v[208:211], v9, v18 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[96:99], v[104:107], v[180:183], v9, v19 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[92:95], v[104:107], v[148:151], v9, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[92:95], v[212:215], v[152:155], v9, v19 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[96:99], v[212:215], v[184:187], v9, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[96:99], v[216:219], v[188:191], v9, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[92:95], v[216:219], v[156:159], v9, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[92:95], v[20:23], v[160:163], v9, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[96:99], v[20:23], v[192:195], v9, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s0, s12, 1
		s_mov_b32 m0, s15
		s_lshl_b32 s1, s0, 16
		ds_read_addtid_b32 v0 offset:22528
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v0, s1, v0
		s_mov_b32 s2, 0
		scratch_load_dword v1, off, s2 offset:180
		s_mov_b32 s2, 0
		scratch_load_dword v2, off, s2 offset:184
		s_waitcnt vmcnt(0)
		v_add3_u32 v0, v0, v1, v2
		v_add_u32_e32 v1, 0x800, v0
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x800, v1
		ds_read_b128 v[4:7], v1
		v_add_u32_e32 v1, 0x800, v0
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x800, v1
		ds_read_b128 v[8:11], v1 offset:1024
		v_add_u32_e32 v1, 0x800, v0
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x800, v1
		ds_read_b128 v[16:19], v1 offset:2048
		v_add_u32_e32 v1, 0x800, v0
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x800, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x800, v1
		ds_read_b128 v[20:23], v1 offset:3072
		s_mov_b32 s2, 0
		scratch_load_dword v1, off, s2 offset:180
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v1, s1, v1
		s_mov_b32 s1, 0
		scratch_load_dword v2, off, s1 offset:88
		s_mov_b32 s1, 0
		scratch_load_dword v3, off, s1 offset:184
		s_waitcnt vmcnt(0)
		v_add3_u32 v1, v1, v2, v3
		v_add_u32_e32 v2, 0x800, v1
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[24:27], v2 offset:32768
		v_add_u32_e32 v2, 0x800, v1
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[28:31], v2 offset:33792
		v_add_u32_e32 v2, 0x800, v1
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[32:35], v2 offset:34816
		v_add_u32_e32 v2, 0x800, v1
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[36:39], v2 offset:35840
		v_add_u32_e32 v2, 0x800, v1
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[40:43], v2 offset:36864
		v_add_u32_e32 v2, 0x800, v1
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[44:47], v2 offset:37888
		v_add_u32_e32 v2, 0x800, v1
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[48:51], v2 offset:38912
		v_add_u32_e32 v2, 0x800, v1
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[52:55], v2 offset:39936
		s_lshl_b32 s0, s0, 12
		s_mov_b32 m0, s15
		s_add_i32 s0, s0, 0x20000
		ds_read_addtid_b32 v2 offset:2048
		s_mov_b32 s1, 0
		scratch_load_dword v3, off, s1 offset:196
		s_waitcnt vmcnt(0) lgkmcnt(0)
		v_add3_u32 v2, s0, v2, v3
		v_add_u32_e32 v3, 0x800, v2
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x800, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x800, v3
		ds_read_b32 v56, v3
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b32 v3, v2 offset:256
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v2 offset:4096
		s_mov_b32 s1, 0
		scratch_load_dword v57, off, s1 offset:196
		s_waitcnt vmcnt(0) lgkmcnt(0)
		v_add3_u32 v2, s0, v57, v2
		v_add_u32_e32 v57, 0x800, v2
		v_add_u32_e32 v57, 0x800, v57
		v_add_u32_e32 v57, 0x800, v57
		v_add_u32_e32 v57, 0x1000, v57
		v_add_u32_e32 v57, 0x1000, v57
		v_add_u32_e32 v57, 0x1000, v57
		v_add_u32_e32 v57, 0x1000, v57
		v_add_u32_e32 v57, 0x800, v57
		ds_read_b32 v58, v57 offset:2048
		v_add_u32_e32 v57, 0x800, v2
		v_add_u32_e32 v57, 0x800, v57
		v_add_u32_e32 v57, 0x800, v57
		v_add_u32_e32 v57, 0x1000, v57
		v_add_u32_e32 v57, 0x1000, v57
		v_add_u32_e32 v57, 0x1000, v57
		v_add_u32_e32 v57, 0x1000, v57
		v_add_u32_e32 v57, 0x800, v57
		ds_read_b32 v59, v57 offset:2304
		v_add_u32_e32 v57, 0x800, v2
		v_add_u32_e32 v57, 0x800, v57
		v_add_u32_e32 v57, 0x800, v57
		v_add_u32_e32 v57, 0x1000, v57
		v_add_u32_e32 v57, 0x1000, v57
		v_add_u32_e32 v57, 0x1000, v57
		v_add_u32_e32 v57, 0x1000, v57
		v_add_u32_e32 v57, 0x800, v57
		ds_read_b32 v60, v57 offset:2560
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b32 v57, v2 offset:2816
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[4:7], v[24:27], v[12:15], v56, v58 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v0
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[64:67], v2 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[4:7], v[28:31], v[76:79], v56, v58 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v0
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[68:71], v2 offset:17408
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[4:7], v[32:35], v[80:83], v56, v59 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x800, v0
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x800, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x800, v2
		ds_read_b128 v[72:75], v2 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[4:7], v[36:39], v[84:87], v56, v59 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x800, v0
		ds_read_b128 v[92:95], v0 offset:19456
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[4:7], v[40:43], v[88:91], v56, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v0, 0x800, v1
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x800, v0
		ds_read_b128 v[96:99], v0 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[4:7], v[44:47], v[100:103], v56, v60 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v0, 0x800, v1
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x800, v0
		ds_read_b128 v[104:107], v0 offset:50176
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[4:7], v[48:51], v[108:111], v56, v57 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v0, 0x800, v1
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x800, v0
		ds_read_b128 v[212:215], v0 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[4:7], v[52:55], v[112:115], v56, v57 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v0, 0x800, v1
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x800, v0
		ds_read_b128 v[4:7], v0 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[8:11], v[24:27], v[116:119], v56, v58 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v0, 0x800, v1
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x800, v0
		ds_read_b128 v[216:219], v0 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[8:11], v[28:31], v[120:123], v56, v58 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v0, 0x800, v1
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x800, v0
		ds_read_b128 v[220:223], v0 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[8:11], v[32:35], v[124:127], v56, v59 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v0, 0x800, v1
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x800, v0
		ds_read_b128 v[224:227], v0 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[8:11], v[36:39], v[128:131], v56, v59 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v0, 0x800, v1
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x800, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x1000, v0
		v_add_u32_e32 v0, 0x800, v0
		ds_read_b128 v[228:231], v0 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[8:11], v[40:43], v[132:135], v56, v60 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[8:11], v[44:47], v[136:139], v56, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[8:11], v[48:51], v[140:143], v56, v57 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[8:11], v[52:55], v[144:147], v56, v57 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[16:19], v[52:55], v[176:179], v3, v57 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[16:19], v[48:51], v[172:175], v3, v57 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[20:23], v[48:51], v[204:207], v3, v57 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[20:23], v[52:55], v[208:211], v3, v57 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[20:23], v[24:27], v[180:183], v3, v58 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[16:19], v[24:27], v[148:151], v3, v58 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[16:19], v[28:31], v[152:155], v3, v58 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[20:23], v[28:31], v[184:187], v3, v58 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[20:23], v[32:35], v[188:191], v3, v59 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[16:19], v[32:35], v[156:159], v3, v59 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[16:19], v[36:39], v[160:163], v3, v59 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[20:23], v[36:39], v[192:195], v3, v59 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[20:23], v[40:43], v[196:199], v3, v60 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[16:19], v[40:43], v[164:167], v3, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[16:19], v[44:47], v[168:171], v3, v60 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[20:23], v[44:47], v[200:203], v3, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[72:75], v[216:219], v[164:167], v3, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[72:75], v[220:223], v[168:171], v3, v60 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[92:95], v[220:223], v[200:203], v3, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[92:95], v[216:219], v[196:199], v3, v60 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[64:67], v[216:219], v[88:91], v56, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[64:67], v[220:223], v[100:103], v56, v60 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[68:71], v[220:223], v[136:139], v56, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[68:71], v[216:219], v[132:135], v56, v60 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[68:71], v[96:99], v[116:119], v56, v58 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[64:67], v[96:99], v[12:15], v56, v58 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[64:67], v[104:107], v[76:79], v56, v58 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[68:71], v[104:107], v[120:123], v56, v58 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[68:71], v[212:215], v[124:127], v56, v59 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[64:67], v[212:215], v[80:83], v56, v59 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[64:67], v[4:7], v[84:87], v56, v59 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[68:71], v[4:7], v[128:131], v56, v59 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[68:71], v[224:227], v[140:143], v56, v57 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[64:67], v[224:227], v[108:111], v56, v57 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[64:67], v[228:231], v[112:115], v56, v57 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[68:71], v[228:231], v[144:147], v56, v57 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[72:75], v[228:231], v[176:179], v3, v57 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[72:75], v[224:227], v[172:175], v3, v57 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[92:95], v[224:227], v[204:207], v3, v57 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[92:95], v[228:231], v[208:211], v3, v57 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[92:95], v[96:99], v[180:183], v3, v58 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[72:75], v[96:99], v[148:151], v3, v58 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[72:75], v[104:107], v[152:155], v3, v58 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[92:95], v[104:107], v[184:187], v3, v58 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[92:95], v[212:215], v[188:191], v3, v59 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[72:75], v[212:215], v[156:159], v3, v59 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[72:75], v[4:7], v[160:163], v3, v59 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[92:95], v[4:7], v[192:195], v3, v59 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v12, v13
		s_mov_b32 m0, s15
		v_cvt_pk_f16_f32 v1, v14, v15
		ds_read_addtid_b32 v2
		s_waitcnt lgkmcnt(0)
		v_lshlrev_b32_e32 v2, 3, v2
		v_lshl_add_u32 v2, s17, 14, v2
		s_lshl_b32 s0, s13, 21
		s_lshl_b32 s1, s14, 17
		s_add_i32 s2, s0, s1
		s_mov_b32 s16, s6
		s_mov_b32 s17, s7
		s_mov_b32 s19, s23
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s2 offen
		v_cvt_pk_f16_f32 v0, v76, v77
		v_cvt_pk_f16_f32 v1, v78, v79
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s2 offen offset:512
		v_cvt_pk_f16_f32 v0, v80, v81
		v_cvt_pk_f16_f32 v1, v82, v83
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s2 offen offset:1024
		v_cvt_pk_f16_f32 v0, v84, v85
		v_cvt_pk_f16_f32 v1, v86, v87
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s2 offen offset:1536
		v_cvt_pk_f16_f32 v0, v88, v89
		v_cvt_pk_f16_f32 v1, v90, v91
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s2 offen offset:2048
		v_cvt_pk_f16_f32 v0, v100, v101
		v_cvt_pk_f16_f32 v1, v102, v103
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s2 offen offset:2560
		v_cvt_pk_f16_f32 v0, v108, v109
		v_cvt_pk_f16_f32 v1, v110, v111
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s2 offen offset:3072
		v_cvt_pk_f16_f32 v0, v112, v113
		v_cvt_pk_f16_f32 v1, v114, v115
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s2 offen offset:3584
		v_cvt_pk_f16_f32 v0, v116, v117
		v_cvt_pk_f16_f32 v1, v118, v119
		s_add_i32 s2, s0, 0x1000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s2 offen
		v_cvt_pk_f16_f32 v0, v120, v121
		v_cvt_pk_f16_f32 v1, v122, v123
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s2 offen offset:512
		v_cvt_pk_f16_f32 v0, v124, v125
		v_cvt_pk_f16_f32 v1, v126, v127
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s2 offen offset:1024
		v_cvt_pk_f16_f32 v0, v128, v129
		v_cvt_pk_f16_f32 v1, v130, v131
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s2 offen offset:1536
		v_cvt_pk_f16_f32 v0, v132, v133
		v_cvt_pk_f16_f32 v1, v134, v135
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s2 offen offset:2048
		v_cvt_pk_f16_f32 v0, v136, v137
		v_cvt_pk_f16_f32 v1, v138, v139
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s2 offen offset:2560
		v_cvt_pk_f16_f32 v0, v140, v141
		v_cvt_pk_f16_f32 v1, v142, v143
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s2 offen offset:3072
		v_cvt_pk_f16_f32 v0, v144, v145
		v_cvt_pk_f16_f32 v1, v146, v147
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s2 offen offset:3584
		v_cvt_pk_f16_f32 v0, v148, v149
		v_cvt_pk_f16_f32 v1, v150, v151
		s_add_i32 s2, s0, 0x2000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s2 offen
		v_cvt_pk_f16_f32 v0, v152, v153
		v_cvt_pk_f16_f32 v1, v154, v155
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s2 offen offset:512
		v_cvt_pk_f16_f32 v0, v156, v157
		v_cvt_pk_f16_f32 v1, v158, v159
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s2 offen offset:1024
		v_cvt_pk_f16_f32 v0, v160, v161
		v_cvt_pk_f16_f32 v1, v162, v163
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s2 offen offset:1536
		v_cvt_pk_f16_f32 v0, v164, v165
		v_cvt_pk_f16_f32 v1, v166, v167
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s2 offen offset:2048
		v_cvt_pk_f16_f32 v0, v168, v169
		v_cvt_pk_f16_f32 v1, v170, v171
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s2 offen offset:2560
		v_cvt_pk_f16_f32 v0, v172, v173
		v_cvt_pk_f16_f32 v1, v174, v175
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s2 offen offset:3072
		v_cvt_pk_f16_f32 v0, v176, v177
		v_cvt_pk_f16_f32 v1, v178, v179
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s2 offen offset:3584
		v_cvt_pk_f16_f32 v0, v180, v181
		v_cvt_pk_f16_f32 v1, v182, v183
		s_add_i32 s0, s0, 0x3000
		s_add_i32 s0, s0, s1
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s0 offen
		v_cvt_pk_f16_f32 v0, v184, v185
		v_cvt_pk_f16_f32 v1, v186, v187
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s0 offen offset:512
		v_cvt_pk_f16_f32 v0, v188, v189
		v_cvt_pk_f16_f32 v1, v190, v191
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s0 offen offset:1024
		v_cvt_pk_f16_f32 v0, v192, v193
		v_cvt_pk_f16_f32 v1, v194, v195
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s0 offen offset:1536
		v_cvt_pk_f16_f32 v0, v196, v197
		v_cvt_pk_f16_f32 v1, v198, v199
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s0 offen offset:2048
		v_cvt_pk_f16_f32 v0, v200, v201
		v_cvt_pk_f16_f32 v1, v202, v203
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s0 offen offset:2560
		v_cvt_pk_f16_f32 v0, v204, v205
		v_cvt_pk_f16_f32 v1, v206, v207
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s0 offen offset:3072
		v_cvt_pk_f16_f32 v0, v208, v209
		v_cvt_pk_f16_f32 v1, v210, v211
		buffer_store_dwordx2 v[0:1], v2, s[16:19], s0 offen offset:3584
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 24576
		.amdhsa_private_segment_fixed_size 628
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
		.amdhsa_next_free_vgpr 256
		.amdhsa_next_free_sgpr 51
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
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 51
	.set .Lwmma_f16_matmul_tiled.num_named_barrier, 0
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 628
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
    .max_flat_workgroup_size: 512
    .name:           wmma_f16_matmul_tiled
    .private_segment_fixed_size: 628
    .sgpr_count:     51
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     256
    .agpr_count:     0
    .vgpr_spill_count: 157
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 75
    wave.regalloc.agpr.dwords: 0
    wave.regalloc.remat.dwords: 0
    wave.regalloc.sgpr_to_vgpr.dwords: 0
    wave.regalloc.lds.dwords: 12
    wave.regalloc.scratch.dwords: 157
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
