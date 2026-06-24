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
		s_mov_b32 s16, s6
		s_mov_b32 s17, s7
		s_mov_b32 s18, 0x7fffffff
		s_mov_b32 s19, 0x31016000
		s_mov_b32 s20, s2
		s_mov_b32 s21, s3
		s_mov_b32 s22, 0x1000000
		s_mov_b32 s23, 0x31016000
		s_mov_b32 s0, s4
		s_mov_b32 s1, s5
		s_mov_b32 s2, 0x1000000
		s_mov_b32 s3, 0x31016000
		s_mov_b32 s4, s8
		s_mov_b32 s5, s9
		s_mov_b32 s6, 0x1000000
		s_mov_b32 s7, 0x31016000
		s_mov_b32 s24, s10
		s_mov_b32 s25, s11
		s_mov_b32 s26, 0x1000000
		s_mov_b32 s27, 0x31016000
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_mov_b32 s8, 0
		scratch_store_dword off, v4, s8 offset:336
		scratch_store_dword off, v5, s8 offset:340
		scratch_store_dword off, v6, s8 offset:344
		scratch_store_dword off, v7, s8 offset:348
		v_readfirstlane_b32 s8, v0
		s_lshl_b32 s9, s13, 20
		v_lshrrev_b32_e32 v1, 6, v0
		v_accvgpr_write_b32 a0, v1
		v_accvgpr_read_b32 v1, a0
		v_lshlrev_b32_e32 v2, 2, v0
		ds_write_b32 v2, v1 offset:7168
		v_lshlrev_b32_e32 v1, 2, v0
		s_waitcnt lgkmcnt(0)
		ds_read_b32 v2, v1 offset:7168
		s_waitcnt lgkmcnt(0)
		v_lshlrev_b32_e32 v1, 16, v2
		v_add_u32_e32 v2, s9, v1
		v_and_b32_e32 v3, 63, v0
		v_accvgpr_write_b32 a0, v3
		v_accvgpr_read_b32 v3, a0
		v_lshlrev_b32_e32 v4, 2, v0
		ds_write_b32 v4, v3 offset:8192
		v_lshlrev_b32_e32 v3, 2, v0
		s_waitcnt lgkmcnt(0)
		ds_read_b32 v4, v3 offset:8192
		s_waitcnt lgkmcnt(0)
		v_lshrrev_b32_e32 v3, 2, v4
		v_lshlrev_b32_e32 v4, 12, v3
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v5, v3 offset:8192
		s_waitcnt lgkmcnt(0)
		v_lshrrev_b32_e32 v3, 3, v5
		v_and_b32_e32 v5, 3, v3
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v6, v3 offset:8192
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v3, 3, v6
		v_xor_b32_e32 v6, v5, v3
		v_lshlrev_b32_e32 v3, 4, v6
		v_add3_u32 v5, v2, v4, v3
		s_add_i32 s10, s9, 0x40000
		v_add_u32_e32 v2, s10, v1
		v_add3_u32 v6, v2, v4, v3
		s_add_i32 s10, s9, 0x80000
		v_add_u32_e32 v2, s10, v1
		v_add3_u32 v7, v2, v4, v3
		s_add_i32 s10, s9, 0xc0000
		v_add_u32_e32 v2, s10, v1
		v_add3_u32 v8, v2, v4, v3
		v_add3_u32 v2, s9, 64, v1
		v_add3_u32 v9, v2, v4, v3
		s_add_i32 s10, s9, 0x40040
		v_add_u32_e32 v2, s10, v1
		v_add3_u32 v10, v2, v4, v3
		s_add_i32 s10, s9, 0x80040
		v_add_u32_e32 v2, s10, v1
		v_add3_u32 v11, v2, v4, v3
		s_add_i32 s10, s9, 0xc0040
		v_add_u32_e32 v2, s10, v1
		v_add3_u32 v12, v2, v4, v3
		s_lshl_b32 s10, s14, 20
		v_add_u32_e32 v2, s10, v1
		v_add3_u32 v13, v2, v4, v3
		s_add_i32 s11, s10, 0x40000
		v_add_u32_e32 v2, s11, v1
		v_add3_u32 v14, v2, v4, v3
		s_add_i32 s11, s10, 0x80000
		v_add_u32_e32 v2, s11, v1
		v_add3_u32 v15, v2, v4, v3
		s_add_i32 s11, s10, 0xc0000
		v_add_u32_e32 v2, s11, v1
		v_add3_u32 v16, v2, v4, v3
		v_add3_u32 v2, s10, 64, v1
		v_add3_u32 v17, v2, v4, v3
		s_add_i32 s11, s10, 0x40040
		v_add_u32_e32 v2, s11, v1
		v_add3_u32 v18, v2, v4, v3
		s_add_i32 s11, s10, 0x80040
		v_add_u32_e32 v2, s11, v1
		v_add3_u32 v19, v2, v4, v3
		s_add_i32 s11, s10, 0xc0040
		v_add_u32_e32 v2, s11, v1
		v_add3_u32 v20, v2, v4, v3
		s_lshr_b32 s11, s8, 6
		s_lshl_b32 s15, s11, 10
		s_mov_b32 m0, s15
		s_nop 0
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		s_add_i32 s28, s15, 0x1000
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v6, s[20:23], 0 offen lds
		s_add_i32 s29, s15, 0x2000
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		s_add_i32 s30, s15, 0x3000
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		s_add_i32 s31, s15, 0x4000
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v9, s[20:23], 0 offen lds
		s_add_i32 s32, s15, 0x5000
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		s_add_i32 s33, s15, 0x6000
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v11, s[20:23], 0 offen lds
		s_add_i32 s34, s15, 0x7000
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_add_i32 s35, s15, 0x8000
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v13, s[0:3], 0 offen lds
		s_add_i32 s36, s15, 0x9000
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v14, s[0:3], 0 offen lds
		s_add_i32 s37, s15, 0xa000
		s_mov_b32 m0, s37
		s_nop 0
		buffer_load_dwordx4 v15, s[0:3], 0 offen lds
		s_add_i32 s38, s15, 0xb000
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v16, s[0:3], 0 offen lds
		s_add_i32 s39, s15, 0xc000
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v17, s[0:3], 0 offen lds
		s_add_i32 s40, s15, 0xd000
		s_mov_b32 m0, s40
		s_nop 0
		buffer_load_dwordx4 v18, s[0:3], 0 offen lds
		s_add_i32 s41, s15, 0xe000
		s_mov_b32 m0, s41
		s_nop 0
		buffer_load_dwordx4 v19, s[0:3], 0 offen lds
		s_add_i32 s42, s15, 0xf000
		s_mov_b32 m0, s42
		s_nop 0
		buffer_load_dwordx4 v20, s[0:3], 0 offen lds
		s_lshl_b32 s43, s14, 16
		s_add_i32 s44, s9, s43
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v5, 10, v2
		v_lshlrev_b32_e32 v6, 2, v0
		ds_write_b32 v6, v5 offset:3072
		v_lshlrev_b32_e32 v5, 2, v0
		ds_read_b32 v6, v5 offset:8192
		s_waitcnt lgkmcnt(0)
		v_lshlrev_b32_e32 v5, 4, v6
		v_lshlrev_b32_e32 v6, 2, v0
		ds_read_b32 v7, v6 offset:3072
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v6, s44, v7, v5
		v_lshlrev_b32_e32 v7, 2, v0
		ds_read_b32 v8, v7 offset:7168
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v7, 1, v8
		v_lshlrev_b32_e32 v8, 10, v7
		v_lshlrev_b32_e32 v9, 2, v0
		ds_write_b32 v9, v8 offset:2048
		v_lshlrev_b32_e32 v8, 2, v0
		s_waitcnt lgkmcnt(0)
		ds_read_b32 v9, v8 offset:2048
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v8, s44, v5, v9
		s_lshr_b32 s44, s8, 7
		s_lshl_b32 s8, s44, 10
		s_add_i32 m0, s8, 0x20000
		s_nop 0
		buffer_load_dwordx4 v6, s[4:7], 0 offen lds
		s_and_b32 s44, s11, 1
		s_lshl_b32 s11, s44, 10
		s_add_i32 m0, s11, 0x20800
		s_nop 0
		buffer_load_dwordx4 v8, s[24:27], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v6, 13, v2
		v_lshlrev_b32_e32 v2, 2, v0
		ds_write_b32 v2, v6 offset:1024
		v_and_b32_e32 v2, 15, v0
		v_lshlrev_b32_e32 v6, 6, v2
		v_lshlrev_b32_e32 v8, 2, v0
		ds_write_b32 v8, v6 offset:6144
		v_lshlrev_b32_e32 v6, 2, v0
		ds_read_b32 v8, v6 offset:8192
		s_waitcnt lgkmcnt(0)
		v_lshrrev_b32_e32 v6, 4, v8
		v_lshrrev_b32_e32 v8, 1, v2
		v_and_b32_e32 v2, 3, v8
		v_xor_b32_e32 v8, v6, v2
		v_lshlrev_b32_e32 v2, 4, v8
		v_lshlrev_b32_e32 v6, 2, v0
		ds_write_b32 v6, v2 offset:5120
		v_lshlrev_b32_e32 v2, 2, v0
		ds_read_b32 v6, v2 offset:1024
		v_lshlrev_b32_e32 v2, 2, v0
		s_waitcnt lgkmcnt(1)
		ds_read_b32 v8, v2 offset:5120
		v_lshlrev_b32_e32 v2, 2, v0
		ds_read_b32 v9, v2 offset:6144
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v2, v6, v9, v8
		ds_read_b128 v[8:11], v2
		ds_read_b128 v[12:15], v2 offset:1024
		ds_read_b128 v[16:19], v2 offset:2048
		ds_read_b128 v[20:23], v2 offset:3072
		ds_read_b128 v[24:27], v2 offset:4096
		ds_read_b128 v[28:31], v2 offset:5120
		ds_read_b128 v[32:35], v2 offset:6144
		ds_read_b128 v[36:39], v2 offset:7168
		v_lshlrev_b32_e32 v2, 13, v7
		v_lshlrev_b32_e32 v6, 2, v0
		ds_write_b32 v6, v2
		v_lshlrev_b32_e32 v2, 2, v0
		s_waitcnt lgkmcnt(0)
		ds_read_b32 v6, v2
		v_lshlrev_b32_e32 v2, 2, v0
		ds_read_b32 v7, v2 offset:5120
		v_lshlrev_b32_e32 v2, 2, v0
		ds_read_b32 v40, v2 offset:6144
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v2, v40, v6, v7
		ds_read_b128 v[40:43], v2 offset:32768
		ds_read_b128 v[44:47], v2 offset:33792
		ds_read_b128 v[48:51], v2 offset:34816
		ds_read_b128 v[52:55], v2 offset:35840
		ds_read_b128 v[56:59], v2 offset:36864
		ds_read_b128 v[60:63], v2 offset:37888
		ds_read_b128 v[64:67], v2 offset:38912
		ds_read_b128 v[68:71], v2 offset:39936
		v_lshlrev_b32_e32 v2, 2, v0
		ds_read_b32 v6, v2 offset:3072
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v2, 0x20000, v6
		v_lshlrev_b32_e32 v6, 2, v0
		ds_read_b32 v7, v6 offset:8192
		s_waitcnt lgkmcnt(0)
		v_lshlrev_b32_e32 v6, 2, v7
		v_lshlrev_b32_e32 v7, 2, v0
		ds_write_b32 v7, v6 offset:4096
		v_lshlrev_b32_e32 v6, 2, v0
		s_waitcnt lgkmcnt(0)
		ds_read_b32 v7, v6 offset:4096
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v6, v2, v7
		ds_read_b32 v2, v6
		ds_read_b32 v7, v6 offset:256
		ds_read_b32 v72, v6 offset:512
		ds_read_b32 v73, v6 offset:768
		v_lshlrev_b32_e32 v6, 2, v0
		ds_read_b32 v74, v6 offset:4096
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v6, 0x20000, v74
		v_lshlrev_b32_e32 v74, 2, v0
		ds_read_b32 v75, v74 offset:2048
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v74, v6, v75
		ds_read_b32 v6, v74 offset:2048
		ds_read_b32 v75, v74 offset:2304
		ds_read_b32 v76, v74 offset:2560
		ds_read_b32 v77, v74 offset:2816
		s_waitcnt lgkmcnt(0)
		s_add_i32 s44, s9, 0x80
		v_add_u32_e32 v74, s44, v1
		v_add3_u32 v78, v74, v4, v3
		s_add_i32 s44, s9, 0x40080
		v_add_u32_e32 v74, s44, v1
		v_add3_u32 v79, v74, v4, v3
		s_add_i32 s44, s9, 0x80080
		v_add_u32_e32 v74, s44, v1
		v_add3_u32 v80, v74, v4, v3
		s_add_i32 s44, s9, 0xc0080
		v_add_u32_e32 v74, s44, v1
		v_add3_u32 v81, v74, v4, v3
		s_add_i32 s44, s9, 0xc0
		v_add_u32_e32 v74, s44, v1
		v_add3_u32 v82, v74, v4, v3
		s_add_i32 s44, s9, 0x400c0
		v_add_u32_e32 v74, s44, v1
		v_add3_u32 v83, v74, v4, v3
		s_add_i32 s44, s9, 0x800c0
		v_add_u32_e32 v74, s44, v1
		v_add3_u32 v84, v74, v4, v3
		s_add_i32 s44, s9, 0xc00c0
		v_add_u32_e32 v74, s44, v1
		v_add3_u32 v85, v74, v4, v3
		s_add_i32 s44, s10, 0x80
		v_add_u32_e32 v74, s44, v1
		v_add3_u32 v86, v74, v4, v3
		s_add_i32 s44, s10, 0x40080
		v_add_u32_e32 v74, s44, v1
		v_add3_u32 v87, v74, v4, v3
		s_add_i32 s44, s10, 0x80080
		v_add_u32_e32 v74, s44, v1
		v_add3_u32 v88, v74, v4, v3
		s_add_i32 s44, s10, 0xc0080
		v_add_u32_e32 v74, s44, v1
		v_add3_u32 v89, v74, v4, v3
		s_add_i32 s44, s10, 0xc0
		v_add_u32_e32 v74, s44, v1
		v_add3_u32 v90, v74, v4, v3
		s_add_i32 s44, s10, 0x400c0
		v_add_u32_e32 v74, s44, v1
		v_add3_u32 v91, v74, v4, v3
		s_add_i32 s44, s10, 0x800c0
		v_add_u32_e32 v74, s44, v1
		v_add3_u32 v92, v74, v4, v3
		s_add_i32 s44, s10, 0xc00c0
		v_add_u32_e32 v74, s44, v1
		v_add3_u32 v1, v74, v4, v3
		s_add_i32 s10, s15, 0x10000
		s_mov_b32 m0, s10
		s_nop 0
		buffer_load_dwordx4 v78, s[20:23], 0 offen lds
		s_add_i32 s44, s15, 0x11000
		s_mov_b32 m0, s44
		s_nop 0
		buffer_load_dwordx4 v79, s[20:23], 0 offen lds
		s_add_i32 s45, s15, 0x12000
		s_mov_b32 m0, s45
		s_nop 0
		buffer_load_dwordx4 v80, s[20:23], 0 offen lds
		s_add_i32 s46, s15, 0x13000
		s_mov_b32 m0, s46
		s_nop 0
		buffer_load_dwordx4 v81, s[20:23], 0 offen lds
		s_add_i32 s47, s15, 0x14000
		s_mov_b32 m0, s47
		s_nop 0
		buffer_load_dwordx4 v82, s[20:23], 0 offen lds
		s_add_i32 s48, s15, 0x15000
		s_mov_b32 m0, s48
		s_nop 0
		buffer_load_dwordx4 v83, s[20:23], 0 offen lds
		s_add_i32 s49, s15, 0x16000
		s_mov_b32 m0, s49
		s_nop 0
		buffer_load_dwordx4 v84, s[20:23], 0 offen lds
		s_add_i32 s50, s15, 0x17000
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v85, s[20:23], 0 offen lds
		s_add_i32 s51, s15, 0x18000
		s_mov_b32 m0, s51
		s_nop 0
		buffer_load_dwordx4 v86, s[0:3], 0 offen lds
		s_add_i32 s52, s15, 0x19000
		s_mov_b32 m0, s52
		s_nop 0
		buffer_load_dwordx4 v87, s[0:3], 0 offen lds
		s_add_i32 s53, s15, 0x1a000
		s_mov_b32 m0, s53
		s_nop 0
		buffer_load_dwordx4 v88, s[0:3], 0 offen lds
		s_add_i32 s54, s15, 0x1b000
		s_mov_b32 m0, s54
		s_nop 0
		buffer_load_dwordx4 v89, s[0:3], 0 offen lds
		s_add_i32 s55, s15, 0x1c000
		s_mov_b32 m0, s55
		s_nop 0
		buffer_load_dwordx4 v90, s[0:3], 0 offen lds
		s_add_i32 s56, s15, 0x1d000
		s_mov_b32 m0, s56
		s_nop 0
		buffer_load_dwordx4 v91, s[0:3], 0 offen lds
		s_add_i32 s57, s15, 0x1e000
		s_mov_b32 m0, s57
		s_nop 0
		buffer_load_dwordx4 v92, s[0:3], 0 offen lds
		s_add_i32 s58, s15, 0x1f000
		s_mov_b32 m0, s58
		s_nop 0
		buffer_load_dwordx4 v1, s[0:3], 0 offen lds
		s_add_i32 s59, s9, 0x800
		s_add_i32 s9, s59, s43
		v_lshlrev_b32_e32 v1, 2, v0
		ds_read_b32 v3, v1 offset:3072
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v1, s9, v3, v5
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v4, v3 offset:2048
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v3, s9, v5, v4
		s_add_i32 m0, s8, 0x21000
		s_nop 0
		buffer_load_dwordx4 v1, s[4:7], 0 offen lds
		s_add_i32 m0, s11, 0x21800
		s_nop 0
		buffer_load_dwordx4 v3, s[24:27], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s9, s12, 1
		v_mov_b32_e32 v1, s9
		s_add_i32 s9, s11, 0x800
		s_add_i32 s43, s8, 0x1000
		s_add_i32 s59, s11, 0x1800
		s_mov_b32 s11, 2
		v_mov_b32_e32 v4, s13
		v_mov_b32_e32 v5, 0
		s_mov_b32 s60, 0x100000
		s_mov_b32 s61, 0
		v_mov_b32_e32 v78, s60
		v_mov_b32_e32 v79, s61
		v_mul_lo_u32 v80, v78, v4
		v_mul_hi_u32 v81, v78, v4
		v_mul_lo_u32 v3, v78, v5
		v_add_u32_e32 v81, v81, v3
		v_mul_lo_u32 v3, v79, v4
		v_add_u32_e32 v81, v81, v3
		s_mov_b32 s60, 1
		s_mov_b32 s61, 0
		v_mov_b32_e32 v82, v0
		v_mov_b32_e32 v83, 0
		v_mov_b32_e32 v84, s60
		v_mov_b32_e32 v85, s61
		v_mul_lo_u32 v86, v84, v82
		v_mul_hi_u32 v87, v84, v82
		v_mul_lo_u32 v3, v84, v83
		v_add_u32_e32 v87, v87, v3
		v_mul_lo_u32 v3, v85, v82
		v_add_u32_e32 v87, v87, v3
		v_lshrrev_b64 v[88:89], 6, v[86:87]
		s_mov_b32 s60, 0x10000
		s_mov_b32 s61, 0
		v_mov_b32_e32 v90, s60
		v_mov_b32_e32 v91, s61
		v_mul_lo_u32 v92, v90, v88
		v_mul_hi_u32 v93, v90, v88
		v_mul_lo_u32 v3, v90, v89
		v_add_u32_e32 v93, v93, v3
		v_mul_lo_u32 v3, v91, v88
		v_add_u32_e32 v93, v93, v3
		v_add_co_u32_e64 v94, vcc, v80, v92
		v_addc_co_u32_e64 v95, vcc, v81, v93, vcc
		v_mov_b32_e32 v3, 63
		v_and_b32_e32 v96, v82, v3
		v_and_b32_e32 v97, v5, v5
		v_mul_lo_u32 v82, v84, v96
		v_mul_hi_u32 v83, v84, v96
		v_mul_lo_u32 v3, v84, v97
		v_add_u32_e32 v83, v83, v3
		v_mul_lo_u32 v3, v85, v96
		v_add_u32_e32 v83, v83, v3
		v_lshrrev_b64 v[84:85], 2, v[82:83]
		s_mov_b32 s60, 0x1000
		s_mov_b32 s61, 0
		v_mov_b32_e32 v98, s60
		v_mov_b32_e32 v99, s61
		v_mul_lo_u32 v100, v98, v84
		v_mul_hi_u32 v101, v98, v84
		v_mul_lo_u32 v3, v98, v85
		v_add_u32_e32 v101, v101, v3
		v_mul_lo_u32 v3, v99, v84
		v_add_u32_e32 v101, v101, v3
		v_add_co_u32_e64 v84, vcc, v94, v100
		v_addc_co_u32_e64 v85, vcc, v95, v101, vcc
		v_lshrrev_b64 v[94:95], 3, v[82:83]
		v_mov_b32_e32 v3, 3
		v_and_b32_e32 v82, v94, v3
		v_and_b32_e32 v83, v95, v5
		v_and_b32_e32 v94, v96, v3
		v_and_b32_e32 v95, v97, v5
		v_xor_b32_e32 v98, v82, v94
		v_xor_b32_e32 v99, v83, v95
		s_mov_b32 s60, 16
		s_mov_b32 s61, 0
		v_mov_b32_e32 v82, s60
		v_mov_b32_e32 v83, s61
		v_mul_lo_u32 v94, v82, v98
		v_mul_hi_u32 v95, v82, v98
		v_mul_lo_u32 v3, v82, v99
		v_add_u32_e32 v95, v95, v3
		v_mul_lo_u32 v3, v83, v98
		v_add_u32_e32 v95, v95, v3
		v_add_co_u32_e64 v98, vcc, v84, v94
		v_addc_co_u32_e64 v99, vcc, v85, v95, vcc
		v_accvgpr_write_b32 a0, v98
		v_accvgpr_write_b32 a1, v99
		s_mov_b32 s60, 0x80
		s_mov_b32 s61, 0
		v_mov_b32_e32 v84, s60
		v_mov_b32_e32 v85, s61
		v_accvgpr_write_b32 a2, v84
		v_accvgpr_write_b32 a3, v85
		v_mov_b32_e32 v3, 0x40000
		v_add_co_u32_e64 v84, vcc, v80, v3
		v_addc_co_u32_e64 v85, vcc, v81, 0, vcc
		v_add_co_u32_e64 v98, vcc, v84, v92
		v_addc_co_u32_e64 v99, vcc, v85, v93, vcc
		v_add_co_u32_e64 v84, vcc, v98, v100
		v_addc_co_u32_e64 v85, vcc, v99, v101, vcc
		v_add_co_u32_e64 v98, vcc, v84, v94
		v_addc_co_u32_e64 v99, vcc, v85, v95, vcc
		v_mov_b32_e32 v4, 0x80000
		v_add_co_u32_e64 v84, vcc, v80, v4
		v_addc_co_u32_e64 v85, vcc, v81, 0, vcc
		v_add_co_u32_e64 v102, vcc, v84, v92
		v_addc_co_u32_e64 v103, vcc, v85, v93, vcc
		v_add_co_u32_e64 v84, vcc, v102, v100
		v_addc_co_u32_e64 v85, vcc, v103, v101, vcc
		v_add_co_u32_e64 v102, vcc, v84, v94
		v_addc_co_u32_e64 v103, vcc, v85, v95, vcc
		v_mov_b32_e32 v74, 0xc0000
		v_add_co_u32_e64 v84, vcc, v80, v74
		v_addc_co_u32_e64 v85, vcc, v81, 0, vcc
		v_add_co_u32_e64 v104, vcc, v84, v92
		v_addc_co_u32_e64 v105, vcc, v85, v93, vcc
		v_add_co_u32_e64 v84, vcc, v104, v100
		v_addc_co_u32_e64 v85, vcc, v105, v101, vcc
		v_add_co_u32_e64 v104, vcc, v84, v94
		v_addc_co_u32_e64 v105, vcc, v85, v95, vcc
		v_mov_b32_e32 v84, 64
		v_add_co_u32_e64 v106, vcc, v80, v84
		v_addc_co_u32_e64 v107, vcc, v81, 0, vcc
		v_add_co_u32_e64 v108, vcc, v106, v92
		v_addc_co_u32_e64 v109, vcc, v107, v93, vcc
		v_add_co_u32_e64 v106, vcc, v108, v100
		v_addc_co_u32_e64 v107, vcc, v109, v101, vcc
		v_add_co_u32_e64 v108, vcc, v106, v94
		v_addc_co_u32_e64 v109, vcc, v107, v95, vcc
		v_mov_b32_e32 v85, 0x40040
		v_add_co_u32_e64 v106, vcc, v80, v85
		v_addc_co_u32_e64 v107, vcc, v81, 0, vcc
		v_add_co_u32_e64 v110, vcc, v106, v92
		v_addc_co_u32_e64 v111, vcc, v107, v93, vcc
		v_add_co_u32_e64 v106, vcc, v110, v100
		v_addc_co_u32_e64 v107, vcc, v111, v101, vcc
		v_add_co_u32_e64 v110, vcc, v106, v94
		v_addc_co_u32_e64 v111, vcc, v107, v95, vcc
		v_mov_b32_e32 v106, 0x80040
		v_add_co_u32_e64 v112, vcc, v80, v106
		v_addc_co_u32_e64 v113, vcc, v81, 0, vcc
		v_add_co_u32_e64 v114, vcc, v112, v92
		v_addc_co_u32_e64 v115, vcc, v113, v93, vcc
		v_add_co_u32_e64 v112, vcc, v114, v100
		v_addc_co_u32_e64 v113, vcc, v115, v101, vcc
		v_add_co_u32_e64 v114, vcc, v112, v94
		v_addc_co_u32_e64 v115, vcc, v113, v95, vcc
		v_mov_b32_e32 v107, 0xc0040
		v_add_co_u32_e64 v112, vcc, v80, v107
		v_addc_co_u32_e64 v113, vcc, v81, 0, vcc
		v_add_co_u32_e64 v116, vcc, v112, v92
		v_addc_co_u32_e64 v117, vcc, v113, v93, vcc
		v_add_co_u32_e64 v112, vcc, v116, v100
		v_addc_co_u32_e64 v113, vcc, v117, v101, vcc
		v_add_co_u32_e64 v116, vcc, v112, v94
		v_addc_co_u32_e64 v117, vcc, v113, v95, vcc
		v_mov_b32_e32 v112, s14
		v_mov_b32_e32 v113, 0
		v_mul_lo_u32 v118, v78, v112
		v_mul_hi_u32 v119, v78, v112
		v_mul_lo_u32 v120, v78, v113
		v_add_u32_e32 v119, v119, v120
		v_mul_lo_u32 v120, v79, v112
		v_add_u32_e32 v119, v119, v120
		v_add_co_u32_e64 v78, vcc, v118, v92
		v_addc_co_u32_e64 v79, vcc, v119, v93, vcc
		v_add_co_u32_e64 v120, vcc, v78, v100
		v_addc_co_u32_e64 v121, vcc, v79, v101, vcc
		v_add_co_u32_e64 v78, vcc, v120, v94
		v_addc_co_u32_e64 v79, vcc, v121, v95, vcc
		v_add_co_u32_e64 v120, vcc, v118, v3
		v_addc_co_u32_e64 v121, vcc, v119, 0, vcc
		v_add_co_u32_e64 v122, vcc, v120, v92
		v_addc_co_u32_e64 v123, vcc, v121, v93, vcc
		v_add_co_u32_e64 v120, vcc, v122, v100
		v_addc_co_u32_e64 v121, vcc, v123, v101, vcc
		v_add_co_u32_e64 v122, vcc, v120, v94
		v_addc_co_u32_e64 v123, vcc, v121, v95, vcc
		v_add_co_u32_e64 v120, vcc, v118, v4
		v_addc_co_u32_e64 v121, vcc, v119, 0, vcc
		v_add_co_u32_e64 v124, vcc, v120, v92
		v_addc_co_u32_e64 v125, vcc, v121, v93, vcc
		v_add_co_u32_e64 v120, vcc, v124, v100
		v_addc_co_u32_e64 v121, vcc, v125, v101, vcc
		v_add_co_u32_e64 v124, vcc, v120, v94
		v_addc_co_u32_e64 v125, vcc, v121, v95, vcc
		v_add_co_u32_e64 v120, vcc, v118, v74
		v_addc_co_u32_e64 v121, vcc, v119, 0, vcc
		v_add_co_u32_e64 v126, vcc, v120, v92
		v_addc_co_u32_e64 v127, vcc, v121, v93, vcc
		v_add_co_u32_e64 v120, vcc, v126, v100
		v_addc_co_u32_e64 v121, vcc, v127, v101, vcc
		v_add_co_u32_e64 v126, vcc, v120, v94
		v_addc_co_u32_e64 v127, vcc, v121, v95, vcc
		v_add_co_u32_e64 v120, vcc, v118, v84
		v_addc_co_u32_e64 v121, vcc, v119, 0, vcc
		v_add_co_u32_e64 v128, vcc, v120, v92
		v_addc_co_u32_e64 v129, vcc, v121, v93, vcc
		v_add_co_u32_e64 v120, vcc, v128, v100
		v_addc_co_u32_e64 v121, vcc, v129, v101, vcc
		v_add_co_u32_e64 v128, vcc, v120, v94
		v_addc_co_u32_e64 v129, vcc, v121, v95, vcc
		v_add_co_u32_e64 v120, vcc, v118, v85
		v_addc_co_u32_e64 v121, vcc, v119, 0, vcc
		v_add_co_u32_e64 v84, vcc, v120, v92
		v_addc_co_u32_e64 v85, vcc, v121, v93, vcc
		v_add_co_u32_e64 v120, vcc, v84, v100
		v_addc_co_u32_e64 v121, vcc, v85, v101, vcc
		v_add_co_u32_e64 v84, vcc, v120, v94
		v_addc_co_u32_e64 v85, vcc, v121, v95, vcc
		v_add_co_u32_e64 v120, vcc, v118, v106
		v_addc_co_u32_e64 v121, vcc, v119, 0, vcc
		v_add_co_u32_e64 v130, vcc, v120, v92
		v_addc_co_u32_e64 v131, vcc, v121, v93, vcc
		v_add_co_u32_e64 v120, vcc, v130, v100
		v_addc_co_u32_e64 v121, vcc, v131, v101, vcc
		v_add_co_u32_e64 v130, vcc, v120, v94
		v_addc_co_u32_e64 v131, vcc, v121, v95, vcc
		v_add_co_u32_e64 v120, vcc, v118, v107
		v_addc_co_u32_e64 v121, vcc, v119, 0, vcc
		v_add_co_u32_e64 v106, vcc, v120, v92
		v_addc_co_u32_e64 v107, vcc, v121, v93, vcc
		v_add_co_u32_e64 v120, vcc, v106, v100
		v_addc_co_u32_e64 v121, vcc, v107, v101, vcc
		v_add_co_u32_e64 v106, vcc, v120, v94
		v_addc_co_u32_e64 v107, vcc, v121, v95, vcc
		v_mul_lo_u32 v120, v90, v112
		v_mul_hi_u32 v121, v90, v112
		v_mul_lo_u32 v3, v90, v113
		v_add_u32_e32 v121, v121, v3
		v_mul_lo_u32 v3, v91, v112
		v_add_u32_e32 v121, v121, v3
		v_add_co_u32_e64 v90, vcc, v80, v120
		v_addc_co_u32_e64 v91, vcc, v81, v121, vcc
		v_lshrrev_b64 v[112:113], 7, v[86:87]
		s_mov_b32 s60, 0x400
		s_mov_b32 s61, 0
		v_mov_b32_e32 v86, s60
		v_mov_b32_e32 v87, s61
		v_mul_lo_u32 v132, v86, v112
		v_mul_hi_u32 v133, v86, v112
		v_mul_lo_u32 v3, v86, v113
		v_add_u32_e32 v133, v133, v3
		v_mul_lo_u32 v3, v87, v112
		v_add_u32_e32 v133, v133, v3
		v_add_co_u32_e64 v112, vcc, v90, v132
		v_addc_co_u32_e64 v113, vcc, v91, v133, vcc
		v_mul_lo_u32 v134, v82, v96
		v_mul_hi_u32 v135, v82, v96
		v_mul_lo_u32 v3, v82, v97
		v_add_u32_e32 v135, v135, v3
		v_mul_lo_u32 v3, v83, v96
		v_add_u32_e32 v135, v135, v3
		v_add_co_u32_e64 v82, vcc, v112, v134
		v_addc_co_u32_e64 v83, vcc, v113, v135, vcc
		s_mov_b32 s60, 0x800
		s_mov_b32 s61, 0
		v_mov_b32_e32 v96, s60
		v_mov_b32_e32 v97, s61
		v_add_co_u32_e64 v112, vcc, v90, v134
		v_addc_co_u32_e64 v113, vcc, v91, v135, vcc
		v_mov_b32_e32 v3, 1
		v_and_b32_e32 v90, v88, v3
		v_and_b32_e32 v91, v89, v5
		v_mul_lo_u32 v4, v86, v90
		v_mul_hi_u32 v5, v86, v90
		v_mul_lo_u32 v3, v86, v91
		v_add_u32_e32 v5, v5, v3
		v_mul_lo_u32 v3, v87, v90
		v_add_u32_e32 v5, v5, v3
		v_add_co_u32_e64 v86, vcc, v112, v4
		v_addc_co_u32_e64 v87, vcc, v113, v5, vcc
		v_mov_b32_e32 v3, 0x80
		v_add_co_u32_e64 v88, vcc, v80, v3
		v_addc_co_u32_e64 v89, vcc, v81, 0, vcc
		v_add_co_u32_e64 v90, vcc, v88, v92
		v_addc_co_u32_e64 v91, vcc, v89, v93, vcc
		v_add_co_u32_e64 v88, vcc, v90, v100
		v_addc_co_u32_e64 v89, vcc, v91, v101, vcc
		v_add_co_u32_e64 v90, vcc, v88, v94
		v_addc_co_u32_e64 v91, vcc, v89, v95, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v90, s60
		scratch_store_dword off, v91, s60 offset:4
		v_mov_b32_e32 v74, 0x40080
		v_add_co_u32_e64 v88, vcc, v80, v74
		v_addc_co_u32_e64 v89, vcc, v81, 0, vcc
		v_add_co_u32_e64 v90, vcc, v88, v92
		v_addc_co_u32_e64 v91, vcc, v89, v93, vcc
		v_add_co_u32_e64 v88, vcc, v90, v100
		v_addc_co_u32_e64 v89, vcc, v91, v101, vcc
		v_add_co_u32_e64 v90, vcc, v88, v94
		v_addc_co_u32_e64 v91, vcc, v89, v95, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v90, s60 offset:8
		scratch_store_dword off, v91, s60 offset:12
		v_mov_b32_e32 v88, 0x80080
		v_add_co_u32_e64 v90, vcc, v80, v88
		v_addc_co_u32_e64 v91, vcc, v81, 0, vcc
		v_add_co_u32_e64 v112, vcc, v90, v92
		v_addc_co_u32_e64 v113, vcc, v91, v93, vcc
		v_add_co_u32_e64 v90, vcc, v112, v100
		v_addc_co_u32_e64 v91, vcc, v113, v101, vcc
		v_add_co_u32_e64 v112, vcc, v90, v94
		v_addc_co_u32_e64 v113, vcc, v91, v95, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v112, s60 offset:16
		scratch_store_dword off, v113, s60 offset:20
		v_mov_b32_e32 v89, 0xc0080
		v_add_co_u32_e64 v90, vcc, v80, v89
		v_addc_co_u32_e64 v91, vcc, v81, 0, vcc
		v_add_co_u32_e64 v112, vcc, v90, v92
		v_addc_co_u32_e64 v113, vcc, v91, v93, vcc
		v_add_co_u32_e64 v90, vcc, v112, v100
		v_addc_co_u32_e64 v91, vcc, v113, v101, vcc
		v_add_co_u32_e64 v112, vcc, v90, v94
		v_addc_co_u32_e64 v113, vcc, v91, v95, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v112, s60 offset:24
		scratch_store_dword off, v113, s60 offset:28
		v_mov_b32_e32 v90, 0xc0
		v_add_co_u32_e64 v112, vcc, v80, v90
		v_addc_co_u32_e64 v113, vcc, v81, 0, vcc
		v_add_co_u32_e64 v136, vcc, v112, v92
		v_addc_co_u32_e64 v137, vcc, v113, v93, vcc
		v_add_co_u32_e64 v112, vcc, v136, v100
		v_addc_co_u32_e64 v113, vcc, v137, v101, vcc
		v_add_co_u32_e64 v136, vcc, v112, v94
		v_addc_co_u32_e64 v137, vcc, v113, v95, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v136, s60 offset:32
		scratch_store_dword off, v137, s60 offset:36
		v_mov_b32_e32 v91, 0x400c0
		v_add_co_u32_e64 v112, vcc, v80, v91
		v_addc_co_u32_e64 v113, vcc, v81, 0, vcc
		v_add_co_u32_e64 v136, vcc, v112, v92
		v_addc_co_u32_e64 v137, vcc, v113, v93, vcc
		v_add_co_u32_e64 v112, vcc, v136, v100
		v_addc_co_u32_e64 v113, vcc, v137, v101, vcc
		v_add_co_u32_e64 v136, vcc, v112, v94
		v_addc_co_u32_e64 v137, vcc, v113, v95, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v136, s60 offset:40
		scratch_store_dword off, v137, s60 offset:44
		v_mov_b32_e32 v112, 0x800c0
		v_add_co_u32_e64 v136, vcc, v80, v112
		v_addc_co_u32_e64 v137, vcc, v81, 0, vcc
		v_add_co_u32_e64 v138, vcc, v136, v92
		v_addc_co_u32_e64 v139, vcc, v137, v93, vcc
		v_add_co_u32_e64 v136, vcc, v138, v100
		v_addc_co_u32_e64 v137, vcc, v139, v101, vcc
		v_add_co_u32_e64 v138, vcc, v136, v94
		v_addc_co_u32_e64 v139, vcc, v137, v95, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v138, s60 offset:48
		scratch_store_dword off, v139, s60 offset:52
		v_mov_b32_e32 v113, 0xc00c0
		v_add_co_u32_e64 v136, vcc, v80, v113
		v_addc_co_u32_e64 v137, vcc, v81, 0, vcc
		v_add_co_u32_e64 v138, vcc, v136, v92
		v_addc_co_u32_e64 v139, vcc, v137, v93, vcc
		v_add_co_u32_e64 v136, vcc, v138, v100
		v_addc_co_u32_e64 v137, vcc, v139, v101, vcc
		v_add_co_u32_e64 v138, vcc, v136, v94
		v_addc_co_u32_e64 v139, vcc, v137, v95, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v138, s60 offset:56
		scratch_store_dword off, v139, s60 offset:60
		v_add_co_u32_e64 v136, vcc, v118, v3
		v_addc_co_u32_e64 v137, vcc, v119, 0, vcc
		v_add_co_u32_e64 v138, vcc, v136, v92
		v_addc_co_u32_e64 v139, vcc, v137, v93, vcc
		v_add_co_u32_e64 v136, vcc, v138, v100
		v_addc_co_u32_e64 v137, vcc, v139, v101, vcc
		v_add_co_u32_e64 v138, vcc, v136, v94
		v_addc_co_u32_e64 v139, vcc, v137, v95, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v138, s60 offset:64
		scratch_store_dword off, v139, s60 offset:68
		v_add_co_u32_e64 v136, vcc, v118, v74
		v_addc_co_u32_e64 v137, vcc, v119, 0, vcc
		v_add_co_u32_e64 v138, vcc, v136, v92
		v_addc_co_u32_e64 v139, vcc, v137, v93, vcc
		v_add_co_u32_e64 v136, vcc, v138, v100
		v_addc_co_u32_e64 v137, vcc, v139, v101, vcc
		v_add_co_u32_e64 v138, vcc, v136, v94
		v_addc_co_u32_e64 v139, vcc, v137, v95, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v138, s60 offset:72
		scratch_store_dword off, v139, s60 offset:76
		v_add_co_u32_e64 v136, vcc, v118, v88
		v_addc_co_u32_e64 v137, vcc, v119, 0, vcc
		v_add_co_u32_e64 v138, vcc, v136, v92
		v_addc_co_u32_e64 v139, vcc, v137, v93, vcc
		v_add_co_u32_e64 v136, vcc, v138, v100
		v_addc_co_u32_e64 v137, vcc, v139, v101, vcc
		v_add_co_u32_e64 v138, vcc, v136, v94
		v_addc_co_u32_e64 v139, vcc, v137, v95, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v138, s60 offset:80
		scratch_store_dword off, v139, s60 offset:84
		v_add_co_u32_e64 v136, vcc, v118, v89
		v_addc_co_u32_e64 v137, vcc, v119, 0, vcc
		v_add_co_u32_e64 v88, vcc, v136, v92
		v_addc_co_u32_e64 v89, vcc, v137, v93, vcc
		v_add_co_u32_e64 v136, vcc, v88, v100
		v_addc_co_u32_e64 v137, vcc, v89, v101, vcc
		v_add_co_u32_e64 v88, vcc, v136, v94
		v_addc_co_u32_e64 v89, vcc, v137, v95, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v88, s60 offset:88
		scratch_store_dword off, v89, s60 offset:92
		v_add_co_u32_e64 v88, vcc, v118, v90
		v_addc_co_u32_e64 v89, vcc, v119, 0, vcc
		v_add_co_u32_e64 v136, vcc, v88, v92
		v_addc_co_u32_e64 v137, vcc, v89, v93, vcc
		v_add_co_u32_e64 v88, vcc, v136, v100
		v_addc_co_u32_e64 v89, vcc, v137, v101, vcc
		v_add_co_u32_e64 v136, vcc, v88, v94
		v_addc_co_u32_e64 v137, vcc, v89, v95, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v136, s60 offset:96
		scratch_store_dword off, v137, s60 offset:100
		v_add_co_u32_e64 v88, vcc, v118, v91
		v_addc_co_u32_e64 v89, vcc, v119, 0, vcc
		v_add_co_u32_e64 v90, vcc, v88, v92
		v_addc_co_u32_e64 v91, vcc, v89, v93, vcc
		v_add_co_u32_e64 v88, vcc, v90, v100
		v_addc_co_u32_e64 v89, vcc, v91, v101, vcc
		v_add_co_u32_e64 v90, vcc, v88, v94
		v_addc_co_u32_e64 v91, vcc, v89, v95, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v90, s60 offset:104
		scratch_store_dword off, v91, s60 offset:108
		v_add_co_u32_e64 v88, vcc, v118, v112
		v_addc_co_u32_e64 v89, vcc, v119, 0, vcc
		v_add_co_u32_e64 v90, vcc, v88, v92
		v_addc_co_u32_e64 v91, vcc, v89, v93, vcc
		v_add_co_u32_e64 v88, vcc, v90, v100
		v_addc_co_u32_e64 v89, vcc, v91, v101, vcc
		v_add_co_u32_e64 v90, vcc, v88, v94
		v_addc_co_u32_e64 v91, vcc, v89, v95, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v90, s60 offset:112
		scratch_store_dword off, v91, s60 offset:116
		v_add_co_u32_e64 v88, vcc, v118, v113
		v_addc_co_u32_e64 v89, vcc, v119, 0, vcc
		v_add_co_u32_e64 v90, vcc, v88, v92
		v_addc_co_u32_e64 v91, vcc, v89, v93, vcc
		v_add_co_u32_e64 v88, vcc, v90, v100
		v_addc_co_u32_e64 v89, vcc, v91, v101, vcc
		v_add_co_u32_e64 v90, vcc, v88, v94
		v_addc_co_u32_e64 v91, vcc, v89, v95, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v90, s60 offset:120
		scratch_store_dword off, v91, s60 offset:124
		v_mov_b32_e32 v3, 0x800
		v_add_co_u32_e64 v88, vcc, v80, v3
		v_addc_co_u32_e64 v89, vcc, v81, 0, vcc
		v_add_co_u32_e64 v80, vcc, v88, v120
		v_addc_co_u32_e64 v81, vcc, v89, v121, vcc
		v_add_co_u32_e64 v88, vcc, v80, v132
		v_addc_co_u32_e64 v89, vcc, v81, v133, vcc
		v_add_co_u32_e64 v90, vcc, v88, v134
		v_addc_co_u32_e64 v91, vcc, v89, v135, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v90, s60 offset:128
		scratch_store_dword off, v91, s60 offset:132
		v_add_co_u32_e64 v88, vcc, v80, v134
		v_addc_co_u32_e64 v89, vcc, v81, v135, vcc
		v_add_co_u32_e64 v80, vcc, v88, v4
		v_addc_co_u32_e64 v81, vcc, v89, v5, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v80, s60 offset:136
		scratch_store_dword off, v81, s60 offset:140
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a4, v88
		v_accvgpr_write_b32 a5, v89
		v_accvgpr_write_b32 a6, v90
		v_accvgpr_write_b32 a7, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a8, v88
		v_accvgpr_write_b32 a9, v89
		v_accvgpr_write_b32 a10, v90
		v_accvgpr_write_b32 a11, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a12, v88
		v_accvgpr_write_b32 a13, v89
		v_accvgpr_write_b32 a14, v90
		v_accvgpr_write_b32 a15, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a16, v88
		v_accvgpr_write_b32 a17, v89
		v_accvgpr_write_b32 a18, v90
		v_accvgpr_write_b32 a19, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a20, v88
		v_accvgpr_write_b32 a21, v89
		v_accvgpr_write_b32 a22, v90
		v_accvgpr_write_b32 a23, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a24, v88
		v_accvgpr_write_b32 a25, v89
		v_accvgpr_write_b32 a26, v90
		v_accvgpr_write_b32 a27, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a28, v88
		v_accvgpr_write_b32 a29, v89
		v_accvgpr_write_b32 a30, v90
		v_accvgpr_write_b32 a31, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a32, v88
		v_accvgpr_write_b32 a33, v89
		v_accvgpr_write_b32 a34, v90
		v_accvgpr_write_b32 a35, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a36, v88
		v_accvgpr_write_b32 a37, v89
		v_accvgpr_write_b32 a38, v90
		v_accvgpr_write_b32 a39, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a40, v88
		v_accvgpr_write_b32 a41, v89
		v_accvgpr_write_b32 a42, v90
		v_accvgpr_write_b32 a43, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a44, v88
		v_accvgpr_write_b32 a45, v89
		v_accvgpr_write_b32 a46, v90
		v_accvgpr_write_b32 a47, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a48, v88
		v_accvgpr_write_b32 a49, v89
		v_accvgpr_write_b32 a50, v90
		v_accvgpr_write_b32 a51, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a52, v88
		v_accvgpr_write_b32 a53, v89
		v_accvgpr_write_b32 a54, v90
		v_accvgpr_write_b32 a55, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a56, v88
		v_accvgpr_write_b32 a57, v89
		v_accvgpr_write_b32 a58, v90
		v_accvgpr_write_b32 a59, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a60, v88
		v_accvgpr_write_b32 a61, v89
		v_accvgpr_write_b32 a62, v90
		v_accvgpr_write_b32 a63, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a64, v88
		v_accvgpr_write_b32 a65, v89
		v_accvgpr_write_b32 a66, v90
		v_accvgpr_write_b32 a67, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a68, v88
		v_accvgpr_write_b32 a69, v89
		v_accvgpr_write_b32 a70, v90
		v_accvgpr_write_b32 a71, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a72, v88
		v_accvgpr_write_b32 a73, v89
		v_accvgpr_write_b32 a74, v90
		v_accvgpr_write_b32 a75, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a76, v88
		v_accvgpr_write_b32 a77, v89
		v_accvgpr_write_b32 a78, v90
		v_accvgpr_write_b32 a79, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a80, v88
		v_accvgpr_write_b32 a81, v89
		v_accvgpr_write_b32 a82, v90
		v_accvgpr_write_b32 a83, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a84, v88
		v_accvgpr_write_b32 a85, v89
		v_accvgpr_write_b32 a86, v90
		v_accvgpr_write_b32 a87, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a88, v88
		v_accvgpr_write_b32 a89, v89
		v_accvgpr_write_b32 a90, v90
		v_accvgpr_write_b32 a91, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a92, v88
		v_accvgpr_write_b32 a93, v89
		v_accvgpr_write_b32 a94, v90
		v_accvgpr_write_b32 a95, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a96, v88
		v_accvgpr_write_b32 a97, v89
		v_accvgpr_write_b32 a98, v90
		v_accvgpr_write_b32 a99, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a100, v88
		v_accvgpr_write_b32 a101, v89
		v_accvgpr_write_b32 a102, v90
		v_accvgpr_write_b32 a103, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a104, v88
		v_accvgpr_write_b32 a105, v89
		v_accvgpr_write_b32 a106, v90
		v_accvgpr_write_b32 a107, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a108, v88
		v_accvgpr_write_b32 a109, v89
		v_accvgpr_write_b32 a110, v90
		v_accvgpr_write_b32 a111, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a112, v88
		v_accvgpr_write_b32 a113, v89
		v_accvgpr_write_b32 a114, v90
		v_accvgpr_write_b32 a115, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a116, v88
		v_accvgpr_write_b32 a117, v89
		v_accvgpr_write_b32 a118, v90
		v_accvgpr_write_b32 a119, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a120, v88
		v_accvgpr_write_b32 a121, v89
		v_accvgpr_write_b32 a122, v90
		v_accvgpr_write_b32 a123, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a124, v88
		v_accvgpr_write_b32 a125, v89
		v_accvgpr_write_b32 a126, v90
		v_accvgpr_write_b32 a127, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a128, v88
		v_accvgpr_write_b32 a129, v89
		v_accvgpr_write_b32 a130, v90
		v_accvgpr_write_b32 a131, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a132, v88
		v_accvgpr_write_b32 a133, v89
		v_accvgpr_write_b32 a134, v90
		v_accvgpr_write_b32 a135, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a136, v88
		v_accvgpr_write_b32 a137, v89
		v_accvgpr_write_b32 a138, v90
		v_accvgpr_write_b32 a139, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a140, v88
		v_accvgpr_write_b32 a141, v89
		v_accvgpr_write_b32 a142, v90
		v_accvgpr_write_b32 a143, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a144, v88
		v_accvgpr_write_b32 a145, v89
		v_accvgpr_write_b32 a146, v90
		v_accvgpr_write_b32 a147, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a148, v88
		v_accvgpr_write_b32 a149, v89
		v_accvgpr_write_b32 a150, v90
		v_accvgpr_write_b32 a151, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a152, v88
		v_accvgpr_write_b32 a153, v89
		v_accvgpr_write_b32 a154, v90
		v_accvgpr_write_b32 a155, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a156, v88
		v_accvgpr_write_b32 a157, v89
		v_accvgpr_write_b32 a158, v90
		v_accvgpr_write_b32 a159, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a160, v88
		v_accvgpr_write_b32 a161, v89
		v_accvgpr_write_b32 a162, v90
		v_accvgpr_write_b32 a163, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a164, v88
		v_accvgpr_write_b32 a165, v89
		v_accvgpr_write_b32 a166, v90
		v_accvgpr_write_b32 a167, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a168, v88
		v_accvgpr_write_b32 a169, v89
		v_accvgpr_write_b32 a170, v90
		v_accvgpr_write_b32 a171, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a172, v88
		v_accvgpr_write_b32 a173, v89
		v_accvgpr_write_b32 a174, v90
		v_accvgpr_write_b32 a175, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a176, v88
		v_accvgpr_write_b32 a177, v89
		v_accvgpr_write_b32 a178, v90
		v_accvgpr_write_b32 a179, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a180, v88
		v_accvgpr_write_b32 a181, v89
		v_accvgpr_write_b32 a182, v90
		v_accvgpr_write_b32 a183, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a184, v88
		v_accvgpr_write_b32 a185, v89
		v_accvgpr_write_b32 a186, v90
		v_accvgpr_write_b32 a187, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a188, v88
		v_accvgpr_write_b32 a189, v89
		v_accvgpr_write_b32 a190, v90
		v_accvgpr_write_b32 a191, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a192, v88
		v_accvgpr_write_b32 a193, v89
		v_accvgpr_write_b32 a194, v90
		v_accvgpr_write_b32 a195, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a196, v88
		v_accvgpr_write_b32 a197, v89
		v_accvgpr_write_b32 a198, v90
		v_accvgpr_write_b32 a199, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a200, v88
		v_accvgpr_write_b32 a201, v89
		v_accvgpr_write_b32 a202, v90
		v_accvgpr_write_b32 a203, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a204, v88
		v_accvgpr_write_b32 a205, v89
		v_accvgpr_write_b32 a206, v90
		v_accvgpr_write_b32 a207, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a208, v88
		v_accvgpr_write_b32 a209, v89
		v_accvgpr_write_b32 a210, v90
		v_accvgpr_write_b32 a211, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a212, v88
		v_accvgpr_write_b32 a213, v89
		v_accvgpr_write_b32 a214, v90
		v_accvgpr_write_b32 a215, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a216, v88
		v_accvgpr_write_b32 a217, v89
		v_accvgpr_write_b32 a218, v90
		v_accvgpr_write_b32 a219, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a220, v88
		v_accvgpr_write_b32 a221, v89
		v_accvgpr_write_b32 a222, v90
		v_accvgpr_write_b32 a223, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a224, v88
		v_accvgpr_write_b32 a225, v89
		v_accvgpr_write_b32 a226, v90
		v_accvgpr_write_b32 a227, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a228, v88
		v_accvgpr_write_b32 a229, v89
		v_accvgpr_write_b32 a230, v90
		v_accvgpr_write_b32 a231, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a232, v88
		v_accvgpr_write_b32 a233, v89
		v_accvgpr_write_b32 a234, v90
		v_accvgpr_write_b32 a235, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a236, v88
		v_accvgpr_write_b32 a237, v89
		v_accvgpr_write_b32 a238, v90
		v_accvgpr_write_b32 a239, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a240, v88
		v_accvgpr_write_b32 a241, v89
		v_accvgpr_write_b32 a242, v90
		v_accvgpr_write_b32 a243, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a244, v88
		v_accvgpr_write_b32 a245, v89
		v_accvgpr_write_b32 a246, v90
		v_accvgpr_write_b32 a247, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a248, v88
		v_accvgpr_write_b32 a249, v89
		v_accvgpr_write_b32 a250, v90
		v_accvgpr_write_b32 a251, v91
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_accvgpr_write_b32 a252, v88
		v_accvgpr_write_b32 a253, v89
		v_accvgpr_write_b32 a254, v90
		v_accvgpr_write_b32 a255, v91
.Lwmma_f16_matmul_tiled.loop_head_0:
		v_mov_b32_e32 v4, s11
		v_mov_b32_e32 v5, 0
		v_accvgpr_read_b32 v80, a2
		v_accvgpr_read_b32 v81, a3
		v_mul_lo_u32 v88, v80, v4
		v_mul_hi_u32 v89, v80, v4
		v_mul_lo_u32 v3, v80, v5
		v_add_u32_e32 v89, v89, v3
		v_mul_lo_u32 v3, v81, v4
		v_add_u32_e32 v89, v89, v3
		v_accvgpr_read_b32 v80, a0
		v_accvgpr_read_b32 v81, a1
		v_add_co_u32_e64 v90, vcc, v80, v88
		v_addc_co_u32_e64 v91, vcc, v81, v89, vcc
		v_add_co_u32_e64 v80, vcc, v98, v88
		v_addc_co_u32_e64 v81, vcc, v99, v89, vcc
		v_add_co_u32_e64 v92, vcc, v102, v88
		v_addc_co_u32_e64 v93, vcc, v103, v89, vcc
		v_add_co_u32_e64 v94, vcc, v104, v88
		v_addc_co_u32_e64 v95, vcc, v105, v89, vcc
		v_add_co_u32_e64 v100, vcc, v108, v88
		v_addc_co_u32_e64 v101, vcc, v109, v89, vcc
		v_add_co_u32_e64 v112, vcc, v110, v88
		v_addc_co_u32_e64 v113, vcc, v111, v89, vcc
		v_add_co_u32_e64 v118, vcc, v114, v88
		v_addc_co_u32_e64 v119, vcc, v115, v89, vcc
		v_add_co_u32_e64 v120, vcc, v116, v88
		v_addc_co_u32_e64 v121, vcc, v117, v89, vcc
		v_add_co_u32_e64 v132, vcc, v78, v88
		v_addc_co_u32_e64 v133, vcc, v79, v89, vcc
		v_add_co_u32_e64 v134, vcc, v122, v88
		v_addc_co_u32_e64 v135, vcc, v123, v89, vcc
		v_add_co_u32_e64 v136, vcc, v124, v88
		v_addc_co_u32_e64 v137, vcc, v125, v89, vcc
		v_add_co_u32_e64 v138, vcc, v126, v88
		v_addc_co_u32_e64 v139, vcc, v127, v89, vcc
		v_add_co_u32_e64 v140, vcc, v128, v88
		v_addc_co_u32_e64 v141, vcc, v129, v89, vcc
		v_add_co_u32_e64 v142, vcc, v84, v88
		v_addc_co_u32_e64 v143, vcc, v85, v89, vcc
		v_add_co_u32_e64 v144, vcc, v130, v88
		v_addc_co_u32_e64 v145, vcc, v131, v89, vcc
		v_add_co_u32_e64 v146, vcc, v106, v88
		v_addc_co_u32_e64 v147, vcc, v107, v89, vcc
		v_mul_lo_u32 v148, v96, v4
		v_mul_hi_u32 v149, v96, v4
		v_mul_lo_u32 v3, v96, v5
		v_add_u32_e32 v149, v149, v3
		v_mul_lo_u32 v3, v97, v4
		v_add_u32_e32 v149, v149, v3
		v_add_co_u32_e64 v4, vcc, v82, v148
		v_addc_co_u32_e64 v5, vcc, v83, v149, vcc
		v_add_co_u32_e64 v150, vcc, v86, v148
		v_addc_co_u32_e64 v151, vcc, v87, v149, vcc
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v152, off, s60 offset:336
		scratch_load_dword v153, off, s60 offset:340
		scratch_load_dword v154, off, s60 offset:344
		scratch_load_dword v155, off, s60 offset:348
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[8:11], v[40:43], v[152:155], v2, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s60, s11, 1
		v_mov_b32_e32 v3, s60
		s_nop 0
		v_readfirstlane_b32 s60, v3
		s_lshl_b32 s61, s60, 16
		v_mov_b32_e32 v5, s61
		s_nop 0
		v_readfirstlane_b32 s60, v5
		v_lshlrev_b32_e32 v74, 2, v0
		ds_read_b32 v81, v74 offset:1024
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v74, s60, v81
		v_lshlrev_b32_e32 v81, 2, v0
		ds_read_b32 v91, v81 offset:5120
		v_lshlrev_b32_e32 v81, 2, v0
		ds_read_b32 v93, v81 offset:6144
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v81, v74, v93, v91
		ds_read_b128 v[156:159], v81 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[8:11], v[44:47], a[4:7], v2, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[160:163], v81 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[8:11], v[48:51], a[8:11], v2, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[164:167], v81 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[8:11], v[52:55], a[12:15], v2, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[168:171], v81 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[8:11], v[56:59], a[16:19], v2, v76 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[172:175], v81 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[8:11], v[60:63], a[20:23], v2, v76 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[176:179], v81 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[8:11], v[64:67], a[24:27], v2, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[180:183], v81 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[8:11], v[68:71], a[28:31], v2, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[184:187], v81 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[12:15], v[40:43], a[32:35], v2, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_readfirstlane_b32 s60, v5
		v_lshlrev_b32_e32 v5, 2, v0
		ds_read_b32 v74, v5 offset:6144
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v5, s60, v74
		v_lshlrev_b32_e32 v74, 2, v0
		ds_read_b32 v91, v74
		v_lshlrev_b32_e32 v74, 2, v0
		ds_read_b32 v93, v74 offset:5120
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v74, v5, v91, v93
		ds_read_b128 v[188:191], v74 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[12:15], v[44:47], a[36:39], v2, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[192:195], v74 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[12:15], v[48:51], a[40:43], v2, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[196:199], v74 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[12:15], v[52:55], a[44:47], v2, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[200:203], v74 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[12:15], v[56:59], a[48:51], v2, v76 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[204:207], v74 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[12:15], v[60:63], a[52:55], v2, v76 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[208:211], v74 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[12:15], v[64:67], a[56:59], v2, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[212:215], v74 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[12:15], v[68:71], a[60:63], v2, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v74 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[16:19], v[40:43], a[64:67], v7, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_nop 0
		buffer_load_dwordx4 v90, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[16:19], v[44:47], a[68:71], v7, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v80, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[16:19], v[48:51], a[72:75], v7, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v92, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[16:19], v[52:55], a[76:79], v7, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v94, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[16:19], v[56:59], a[80:83], v7, v76 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v100, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[16:19], v[60:63], a[84:87], v7, v76 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v112, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[16:19], v[64:67], a[88:91], v7, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v118, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[16:19], v[68:71], a[92:95], v7, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v120, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[20:23], v[40:43], a[96:99], v7, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v132, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[20:23], v[44:47], a[100:103], v7, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v134, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[20:23], v[48:51], a[104:107], v7, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s37
		s_nop 0
		buffer_load_dwordx4 v136, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[20:23], v[52:55], a[108:111], v7, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v138, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[20:23], v[56:59], a[112:115], v7, v76 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v140, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[20:23], v[60:63], a[116:119], v7, v76 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s40
		s_nop 0
		buffer_load_dwordx4 v142, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[20:23], v[64:67], a[120:123], v7, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s41
		s_nop 0
		buffer_load_dwordx4 v144, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[20:23], v[68:71], a[124:127], v7, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s42
		s_nop 0
		buffer_load_dwordx4 v146, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[24:27], v[40:43], a[128:131], v72, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s8, 0x20000
		s_nop 0
		buffer_load_dwordx4 v4, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[24:27], v[44:47], a[132:135], v72, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s9, 0x20000
		s_nop 0
		buffer_load_dwordx4 v150, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[24:27], v[48:51], a[136:139], v72, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		ds_read_b128 v[8:11], v81
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[24:27], v[52:55], a[140:143], v72, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[12:15], v81 offset:1024
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[24:27], v[56:59], a[144:147], v72, v76 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[16:19], v81 offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[24:27], v[60:63], a[148:151], v72, v76 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v81 offset:3072
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[24:27], v[64:67], a[152:155], v72, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v81 offset:4096
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v92, s60 offset:320
		scratch_store_dword off, v93, s60 offset:324
		scratch_store_dword off, v94, s60 offset:328
		scratch_store_dword off, v95, s60 offset:332
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[24:27], v[68:71], a[156:159], v72, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v81 offset:5120
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v92, s60 offset:304
		scratch_store_dword off, v93, s60 offset:308
		scratch_store_dword off, v94, s60 offset:312
		scratch_store_dword off, v95, s60 offset:316
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[28:31], v[40:43], a[160:163], v72, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v81 offset:6144
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v92, s60 offset:288
		scratch_store_dword off, v93, s60 offset:292
		scratch_store_dword off, v94, s60 offset:296
		scratch_store_dword off, v95, s60 offset:300
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[28:31], v[44:47], a[164:167], v72, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v81 offset:7168
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v92, s60 offset:272
		scratch_store_dword off, v93, s60 offset:276
		scratch_store_dword off, v94, s60 offset:280
		scratch_store_dword off, v95, s60 offset:284
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[28:31], v[48:51], a[168:171], v72, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v74 offset:32768
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v92, s60 offset:256
		scratch_store_dword off, v93, s60 offset:260
		scratch_store_dword off, v94, s60 offset:264
		scratch_store_dword off, v95, s60 offset:268
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[28:31], v[52:55], a[172:175], v72, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v74 offset:33792
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v92, s60 offset:240
		scratch_store_dword off, v93, s60 offset:244
		scratch_store_dword off, v94, s60 offset:248
		scratch_store_dword off, v95, s60 offset:252
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[28:31], v[56:59], a[176:179], v72, v76 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v74 offset:34816
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v92, s60 offset:224
		scratch_store_dword off, v93, s60 offset:228
		scratch_store_dword off, v94, s60 offset:232
		scratch_store_dword off, v95, s60 offset:236
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[28:31], v[60:63], a[180:183], v72, v76 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v74 offset:35840
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v92, s60 offset:208
		scratch_store_dword off, v93, s60 offset:212
		scratch_store_dword off, v94, s60 offset:216
		scratch_store_dword off, v95, s60 offset:220
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[28:31], v[64:67], a[184:187], v72, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v74 offset:36864
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v92, s60 offset:192
		scratch_store_dword off, v93, s60 offset:196
		scratch_store_dword off, v94, s60 offset:200
		scratch_store_dword off, v95, s60 offset:204
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[28:31], v[68:71], a[188:191], v72, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v74 offset:37888
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v92, s60 offset:176
		scratch_store_dword off, v93, s60 offset:180
		scratch_store_dword off, v94, s60 offset:184
		scratch_store_dword off, v95, s60 offset:188
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[32:35], v[40:43], a[192:195], v73, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v74 offset:38912
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v92, s60 offset:144
		scratch_store_dword off, v93, s60 offset:148
		scratch_store_dword off, v94, s60 offset:152
		scratch_store_dword off, v95, s60 offset:156
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[32:35], v[44:47], a[196:199], v73, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v74 offset:39936
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v92, s60 offset:160
		scratch_store_dword off, v93, s60 offset:164
		scratch_store_dword off, v94, s60 offset:168
		scratch_store_dword off, v95, s60 offset:172
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[32:35], v[48:51], a[200:203], v73, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_readfirstlane_b32 s60, v3
		s_lshl_b32 s61, s60, 12
		s_add_i32 s60, s61, 0x20000
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v4, v3 offset:3072
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v5, v3 offset:4096
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v3, s60, v4, v5
		ds_read_b32 v4, v3
		ds_read_b32 v5, v3 offset:256
		ds_read_b32 v74, v3 offset:512
		ds_read_b32 v80, v3 offset:768
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v81, v3 offset:2048
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v90, v3 offset:4096
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v3, s60, v90, v81
		ds_read_b32 v81, v3 offset:2048
		ds_read_b32 v90, v3 offset:2304
		ds_read_b32 v91, v3 offset:2560
		ds_read_b32 v92, v3 offset:2816
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[32:35], v[52:55], a[204:207], v73, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[32:35], v[56:59], a[208:211], v73, v76 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[32:35], v[60:63], a[212:215], v73, v76 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[32:35], v[64:67], a[216:219], v73, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[32:35], v[68:71], a[220:223], v73, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[36:39], v[40:43], a[224:227], v73, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[36:39], v[44:47], a[228:231], v73, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[36:39], v[48:51], a[232:235], v73, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[36:39], v[52:55], a[236:239], v73, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[36:39], v[56:59], a[240:243], v73, v76 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[36:39], v[60:63], a[244:247], v73, v76 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[36:39], v[64:67], a[248:251], v73, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[36:39], v[68:71], a[252:255], v73, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[156:159], v[188:191], v[152:155], v2, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[156:159], v[192:195], a[4:7], v2, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[156:159], v[196:199], a[8:11], v2, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[156:159], v[200:203], a[12:15], v2, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[156:159], v[204:207], a[16:19], v2, v76 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[156:159], v[208:211], a[20:23], v2, v76 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[156:159], v[212:215], a[24:27], v2, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[156:159], v[216:219], a[28:31], v2, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[160:163], v[188:191], a[32:35], v2, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[160:163], v[192:195], a[36:39], v2, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[160:163], v[196:199], a[40:43], v2, v75 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[160:163], v[200:203], a[44:47], v2, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[160:163], v[204:207], a[48:51], v2, v76 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[160:163], v[208:211], a[52:55], v2, v76 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[160:163], v[212:215], a[56:59], v2, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[160:163], v[216:219], a[60:63], v2, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[164:167], v[188:191], a[64:67], v7, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[164:167], v[192:195], a[68:71], v7, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[164:167], v[196:199], a[72:75], v7, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[164:167], v[200:203], a[76:79], v7, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[164:167], v[204:207], a[80:83], v7, v76 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[164:167], v[208:211], a[84:87], v7, v76 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[164:167], v[212:215], a[88:91], v7, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[164:167], v[216:219], a[92:95], v7, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[168:171], v[188:191], a[96:99], v7, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[168:171], v[192:195], a[100:103], v7, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[168:171], v[196:199], a[104:107], v7, v75 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[168:171], v[200:203], a[108:111], v7, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[168:171], v[204:207], a[112:115], v7, v76 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[168:171], v[208:211], a[116:119], v7, v76 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[168:171], v[212:215], a[120:123], v7, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[168:171], v[216:219], a[124:127], v7, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[172:175], v[188:191], a[128:131], v72, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[172:175], v[192:195], a[132:135], v72, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[172:175], v[196:199], a[136:139], v72, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[172:175], v[200:203], a[140:143], v72, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[172:175], v[204:207], a[144:147], v72, v76 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[172:175], v[208:211], a[148:151], v72, v76 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[172:175], v[212:215], a[152:155], v72, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[172:175], v[216:219], a[156:159], v72, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[176:179], v[188:191], a[160:163], v72, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[176:179], v[192:195], a[164:167], v72, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[176:179], v[196:199], a[168:171], v72, v75 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[176:179], v[200:203], a[172:175], v72, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[176:179], v[204:207], a[176:179], v72, v76 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[176:179], v[208:211], a[180:183], v72, v76 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[176:179], v[212:215], a[184:187], v72, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[176:179], v[216:219], a[188:191], v72, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[180:183], v[188:191], a[192:195], v73, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[180:183], v[192:195], a[196:199], v73, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[180:183], v[196:199], a[200:203], v73, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[180:183], v[200:203], a[204:207], v73, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[180:183], v[204:207], a[208:211], v73, v76 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[180:183], v[208:211], a[212:215], v73, v76 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[180:183], v[212:215], a[216:219], v73, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[180:183], v[216:219], a[220:223], v73, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[184:187], v[188:191], a[224:227], v73, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[184:187], v[192:195], a[228:231], v73, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[184:187], v[196:199], a[232:235], v73, v75 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[184:187], v[200:203], a[236:239], v73, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[184:187], v[204:207], a[240:243], v73, v76 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[184:187], v[208:211], a[244:247], v73, v76 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[184:187], v[212:215], a[248:251], v73, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[184:187], v[216:219], a[252:255], v73, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		s_add_i32 s60, s11, 1
		s_and_b32 s61, s60, 1
		s_lshl_b32 s60, s61, 16
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v93, v3 offset:1024
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v3, s60, v93
		v_lshlrev_b32_e32 v93, 2, v0
		ds_read_b32 v94, v93 offset:5120
		v_lshlrev_b32_e32 v93, 2, v0
		ds_read_b32 v95, v93 offset:6144
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v93, v3, v95, v94
		ds_read_b128 v[132:135], v93
		ds_read_b128 v[136:139], v93 offset:1024
		ds_read_b128 v[140:143], v93 offset:2048
		ds_read_b128 v[144:147], v93 offset:3072
		ds_read_b128 v[156:159], v93 offset:4096
		ds_read_b128 v[160:163], v93 offset:5120
		ds_read_b128 v[164:167], v93 offset:6144
		ds_read_b128 v[168:171], v93 offset:7168
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v94, v3 offset:6144
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v3, s60, v94
		v_lshlrev_b32_e32 v94, 2, v0
		ds_read_b32 v95, v94
		v_lshlrev_b32_e32 v94, 2, v0
		ds_read_b32 v100, v94 offset:5120
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v94, v3, v95, v100
		ds_read_b128 v[172:175], v94 offset:32768
		ds_read_b128 v[176:179], v94 offset:33792
		ds_read_b128 v[180:183], v94 offset:34816
		ds_read_b128 v[184:187], v94 offset:35840
		ds_read_b128 v[188:191], v94 offset:36864
		ds_read_b128 v[192:195], v94 offset:37888
		ds_read_b128 v[196:199], v94 offset:38912
		ds_read_b128 v[200:203], v94 offset:39936
		s_lshl_b32 s60, s61, 12
		s_add_i32 s61, s60, 0x20000
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v95, v3 offset:3072
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v100, v3 offset:4096
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v3, s61, v95, v100
		ds_read_b32 v95, v3
		ds_read_b32 v100, v3 offset:256
		ds_read_b32 v101, v3 offset:512
		ds_read_b32 v112, v3 offset:768
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v113, v3 offset:2048
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v118, v3 offset:4096
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v3, s61, v118, v113
		ds_read_b32 v113, v3 offset:2048
		ds_read_b32 v118, v3 offset:2304
		ds_read_b32 v119, v3 offset:2560
		ds_read_b32 v120, v3 offset:2816
		s_waitcnt lgkmcnt(0)
		s_mov_b32 s60, 0
		scratch_load_dword v150, off, s60
		scratch_load_dword v151, off, s60 offset:4
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v204, vcc, v150, v88
		v_addc_co_u32_e64 v205, vcc, v151, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v150, off, s60 offset:8
		scratch_load_dword v151, off, s60 offset:12
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v206, vcc, v150, v88
		v_addc_co_u32_e64 v207, vcc, v151, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v150, off, s60 offset:16
		scratch_load_dword v151, off, s60 offset:20
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v208, vcc, v150, v88
		v_addc_co_u32_e64 v209, vcc, v151, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v150, off, s60 offset:24
		scratch_load_dword v151, off, s60 offset:28
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v210, vcc, v150, v88
		v_addc_co_u32_e64 v211, vcc, v151, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v150, off, s60 offset:32
		scratch_load_dword v151, off, s60 offset:36
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v212, vcc, v150, v88
		v_addc_co_u32_e64 v213, vcc, v151, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v150, off, s60 offset:40
		scratch_load_dword v151, off, s60 offset:44
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v214, vcc, v150, v88
		v_addc_co_u32_e64 v215, vcc, v151, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v150, off, s60 offset:48
		scratch_load_dword v151, off, s60 offset:52
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v216, vcc, v150, v88
		v_addc_co_u32_e64 v217, vcc, v151, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v150, off, s60 offset:56
		scratch_load_dword v151, off, s60 offset:60
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v218, vcc, v150, v88
		v_addc_co_u32_e64 v219, vcc, v151, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v150, off, s60 offset:64
		scratch_load_dword v151, off, s60 offset:68
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v220, vcc, v150, v88
		v_addc_co_u32_e64 v221, vcc, v151, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v150, off, s60 offset:72
		scratch_load_dword v151, off, s60 offset:76
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v222, vcc, v150, v88
		v_addc_co_u32_e64 v223, vcc, v151, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v150, off, s60 offset:80
		scratch_load_dword v151, off, s60 offset:84
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v224, vcc, v150, v88
		v_addc_co_u32_e64 v225, vcc, v151, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v150, off, s60 offset:88
		scratch_load_dword v151, off, s60 offset:92
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v226, vcc, v150, v88
		v_addc_co_u32_e64 v227, vcc, v151, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v150, off, s60 offset:96
		scratch_load_dword v151, off, s60 offset:100
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v228, vcc, v150, v88
		v_addc_co_u32_e64 v229, vcc, v151, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v150, off, s60 offset:104
		scratch_load_dword v151, off, s60 offset:108
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v230, vcc, v150, v88
		v_addc_co_u32_e64 v231, vcc, v151, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v150, off, s60 offset:112
		scratch_load_dword v151, off, s60 offset:116
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v232, vcc, v150, v88
		v_addc_co_u32_e64 v233, vcc, v151, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v150, off, s60 offset:120
		scratch_load_dword v151, off, s60 offset:124
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v234, vcc, v150, v88
		v_addc_co_u32_e64 v235, vcc, v151, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v88, off, s60 offset:128
		scratch_load_dword v89, off, s60 offset:132
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v150, vcc, v88, v148
		v_addc_co_u32_e64 v151, vcc, v89, v149, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v88, off, s60 offset:136
		scratch_load_dword v89, off, s60 offset:140
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v236, vcc, v88, v148
		v_addc_co_u32_e64 v237, vcc, v89, v149, vcc
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[132:135], v[172:175], v[152:155], v95, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v93 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[132:135], v[176:179], a[4:7], v95, v113 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[244:247], v93 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[132:135], v[180:183], a[8:11], v95, v118 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v93 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[132:135], v[184:187], a[12:15], v95, v118 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[252:255], v93 offset:19456
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v252, s60 offset:480
		scratch_store_dword off, v253, s60 offset:484
		scratch_store_dword off, v254, s60 offset:488
		scratch_store_dword off, v255, s60 offset:492
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[132:135], v[188:191], a[16:19], v95, v119 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[252:255], v93 offset:20480
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v252, s60 offset:496
		scratch_store_dword off, v253, s60 offset:500
		scratch_store_dword off, v254, s60 offset:504
		scratch_store_dword off, v255, s60 offset:508
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[132:135], v[192:195], a[20:23], v95, v119 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[252:255], v93 offset:21504
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v252, s60 offset:352
		scratch_store_dword off, v253, s60 offset:356
		scratch_store_dword off, v254, s60 offset:360
		scratch_store_dword off, v255, s60 offset:364
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[132:135], v[196:199], a[24:27], v95, v120 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[252:255], v93 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[132:135], v[200:203], a[28:31], v95, v120 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[132:135], v93 offset:23552
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v132, s60 offset:368
		scratch_store_dword off, v133, s60 offset:372
		scratch_store_dword off, v134, s60 offset:376
		scratch_store_dword off, v135, s60 offset:380
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[136:139], v[172:175], a[32:35], v95, v113 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[132:135], v94 offset:49152
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v132, s60 offset:384
		scratch_store_dword off, v133, s60 offset:388
		scratch_store_dword off, v134, s60 offset:392
		scratch_store_dword off, v135, s60 offset:396
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[136:139], v[176:179], a[36:39], v95, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[132:135], v94 offset:50176
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v132, s60 offset:400
		scratch_store_dword off, v133, s60 offset:404
		scratch_store_dword off, v134, s60 offset:408
		scratch_store_dword off, v135, s60 offset:412
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[136:139], v[180:183], a[40:43], v95, v118 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[132:135], v94 offset:51200
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v132, s60 offset:416
		scratch_store_dword off, v133, s60 offset:420
		scratch_store_dword off, v134, s60 offset:424
		scratch_store_dword off, v135, s60 offset:428
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[136:139], v[184:187], a[44:47], v95, v118 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[132:135], v94 offset:52224
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v132, s60 offset:432
		scratch_store_dword off, v133, s60 offset:436
		scratch_store_dword off, v134, s60 offset:440
		scratch_store_dword off, v135, s60 offset:444
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[136:139], v[188:191], a[48:51], v95, v119 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[132:135], v94 offset:53248
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v132, s60 offset:448
		scratch_store_dword off, v133, s60 offset:452
		scratch_store_dword off, v134, s60 offset:456
		scratch_store_dword off, v135, s60 offset:460
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[136:139], v[192:195], a[52:55], v95, v119 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[132:135], v94 offset:54272
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v132, s60 offset:464
		scratch_store_dword off, v133, s60 offset:468
		scratch_store_dword off, v134, s60 offset:472
		scratch_store_dword off, v135, s60 offset:476
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[136:139], v[196:199], a[56:59], v95, v120 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[132:135], v94 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[136:139], v[200:203], a[60:63], v95, v120 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[136:139], v94 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[140:143], v[172:175], a[64:67], v100, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s10
		s_nop 0
		buffer_load_dwordx4 v204, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[140:143], v[176:179], a[68:71], v100, v113 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s44
		s_nop 0
		buffer_load_dwordx4 v206, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[140:143], v[180:183], a[72:75], v100, v118 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s45
		s_nop 0
		buffer_load_dwordx4 v208, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[140:143], v[184:187], a[76:79], v100, v118 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s46
		s_nop 0
		buffer_load_dwordx4 v210, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[140:143], v[188:191], a[80:83], v100, v119 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s47
		s_nop 0
		buffer_load_dwordx4 v212, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[140:143], v[192:195], a[84:87], v100, v119 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s48
		s_nop 0
		buffer_load_dwordx4 v214, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[140:143], v[196:199], a[88:91], v100, v120 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s49
		s_nop 0
		buffer_load_dwordx4 v216, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[140:143], v[200:203], a[92:95], v100, v120 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v218, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[144:147], v[172:175], a[96:99], v100, v113 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s51
		s_nop 0
		buffer_load_dwordx4 v220, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[144:147], v[176:179], a[100:103], v100, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s52
		s_nop 0
		buffer_load_dwordx4 v222, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[144:147], v[180:183], a[104:107], v100, v118 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s53
		s_nop 0
		buffer_load_dwordx4 v224, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[144:147], v[184:187], a[108:111], v100, v118 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s54
		s_nop 0
		buffer_load_dwordx4 v226, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[144:147], v[188:191], a[112:115], v100, v119 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s55
		s_nop 0
		buffer_load_dwordx4 v228, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[144:147], v[192:195], a[116:119], v100, v119 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s56
		s_nop 0
		buffer_load_dwordx4 v230, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[144:147], v[196:199], a[120:123], v100, v120 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s57
		s_nop 0
		buffer_load_dwordx4 v232, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[144:147], v[200:203], a[124:127], v100, v120 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s58
		s_nop 0
		buffer_load_dwordx4 v234, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[156:159], v[172:175], a[128:131], v101, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s43, 0x20000
		s_nop 0
		buffer_load_dwordx4 v150, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[156:159], v[176:179], a[132:135], v101, v113 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s59, 0x20000
		s_nop 0
		buffer_load_dwordx4 v236, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[156:159], v[180:183], a[136:139], v101, v118 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[156:159], v[184:187], a[140:143], v101, v118 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[156:159], v[188:191], a[144:147], v101, v119 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[156:159], v[192:195], a[148:151], v101, v119 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[156:159], v[196:199], a[152:155], v101, v120 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[156:159], v[200:203], a[156:159], v101, v120 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[160:163], v[172:175], a[160:163], v101, v113 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[160:163], v[176:179], a[164:167], v101, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[160:163], v[180:183], a[168:171], v101, v118 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[160:163], v[184:187], a[172:175], v101, v118 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[160:163], v[188:191], a[176:179], v101, v119 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[160:163], v[192:195], a[180:183], v101, v119 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[160:163], v[196:199], a[184:187], v101, v120 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[160:163], v[200:203], a[188:191], v101, v120 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[164:167], v[172:175], a[192:195], v112, v113 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[164:167], v[176:179], a[196:199], v112, v113 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[164:167], v[180:183], a[200:203], v112, v118 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[164:167], v[184:187], a[204:207], v112, v118 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[164:167], v[188:191], a[208:211], v112, v119 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[164:167], v[192:195], a[212:215], v112, v119 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[164:167], v[196:199], a[216:219], v112, v120 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[164:167], v[200:203], a[220:223], v112, v120 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[168:171], v[172:175], a[224:227], v112, v113 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[168:171], v[176:179], a[228:231], v112, v113 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[168:171], v[180:183], a[232:235], v112, v118 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[168:171], v[184:187], a[236:239], v112, v118 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[168:171], v[188:191], a[240:243], v112, v119 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[168:171], v[192:195], a[244:247], v112, v119 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[168:171], v[196:199], a[248:251], v112, v120 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[168:171], v[200:203], a[252:255], v112, v120 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		s_waitcnt lgkmcnt(0)
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(20)
		scratch_load_dword v140, off, s60 offset:384
		scratch_load_dword v141, off, s60 offset:388
		scratch_load_dword v142, off, s60 offset:392
		scratch_load_dword v143, off, s60 offset:396
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[240:243], v[140:143], v[152:155], v95, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v140, off, s60 offset:400
		scratch_load_dword v141, off, s60 offset:404
		scratch_load_dword v142, off, s60 offset:408
		scratch_load_dword v143, off, s60 offset:412
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[240:243], v[140:143], a[4:7], v95, v113 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(12)
		scratch_load_dword v140, off, s60 offset:416
		scratch_load_dword v141, off, s60 offset:420
		scratch_load_dword v142, off, s60 offset:424
		scratch_load_dword v143, off, s60 offset:428
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[240:243], v[140:143], a[8:11], v95, v118 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v140, off, s60 offset:432
		scratch_load_dword v141, off, s60 offset:436
		scratch_load_dword v142, off, s60 offset:440
		scratch_load_dword v143, off, s60 offset:444
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[240:243], v[140:143], a[12:15], v95, v118 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v140, off, s60 offset:448
		scratch_load_dword v141, off, s60 offset:452
		scratch_load_dword v142, off, s60 offset:456
		scratch_load_dword v143, off, s60 offset:460
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[240:243], v[140:143], a[16:19], v95, v119 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v140, off, s60 offset:464
		scratch_load_dword v141, off, s60 offset:468
		scratch_load_dword v142, off, s60 offset:472
		scratch_load_dword v143, off, s60 offset:476
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[240:243], v[140:143], a[20:23], v95, v119 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[240:243], v[132:135], a[24:27], v95, v120 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[240:243], v[136:139], a[28:31], v95, v120 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:384
		scratch_load_dword v141, off, s60 offset:388
		scratch_load_dword v142, off, s60 offset:392
		scratch_load_dword v143, off, s60 offset:396
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[244:247], v[140:143], a[32:35], v95, v113 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:400
		scratch_load_dword v141, off, s60 offset:404
		scratch_load_dword v142, off, s60 offset:408
		scratch_load_dword v143, off, s60 offset:412
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[244:247], v[140:143], a[36:39], v95, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:416
		scratch_load_dword v141, off, s60 offset:420
		scratch_load_dword v142, off, s60 offset:424
		scratch_load_dword v143, off, s60 offset:428
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[244:247], v[140:143], a[40:43], v95, v118 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:432
		scratch_load_dword v141, off, s60 offset:436
		scratch_load_dword v142, off, s60 offset:440
		scratch_load_dword v143, off, s60 offset:444
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[244:247], v[140:143], a[44:47], v95, v118 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:448
		scratch_load_dword v141, off, s60 offset:452
		scratch_load_dword v142, off, s60 offset:456
		scratch_load_dword v143, off, s60 offset:460
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[244:247], v[140:143], a[48:51], v95, v119 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:464
		scratch_load_dword v141, off, s60 offset:468
		scratch_load_dword v142, off, s60 offset:472
		scratch_load_dword v143, off, s60 offset:476
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[244:247], v[140:143], a[52:55], v95, v119 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[244:247], v[132:135], a[56:59], v95, v120 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[244:247], v[136:139], a[60:63], v95, v120 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:384
		scratch_load_dword v141, off, s60 offset:388
		scratch_load_dword v142, off, s60 offset:392
		scratch_load_dword v143, off, s60 offset:396
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[248:251], v[140:143], a[64:67], v100, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:400
		scratch_load_dword v141, off, s60 offset:404
		scratch_load_dword v142, off, s60 offset:408
		scratch_load_dword v143, off, s60 offset:412
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[248:251], v[140:143], a[68:71], v100, v113 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:416
		scratch_load_dword v141, off, s60 offset:420
		scratch_load_dword v142, off, s60 offset:424
		scratch_load_dword v143, off, s60 offset:428
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[248:251], v[140:143], a[72:75], v100, v118 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:432
		scratch_load_dword v141, off, s60 offset:436
		scratch_load_dword v142, off, s60 offset:440
		scratch_load_dword v143, off, s60 offset:444
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[248:251], v[140:143], a[76:79], v100, v118 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:448
		scratch_load_dword v141, off, s60 offset:452
		scratch_load_dword v142, off, s60 offset:456
		scratch_load_dword v143, off, s60 offset:460
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[248:251], v[140:143], a[80:83], v100, v119 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:464
		scratch_load_dword v141, off, s60 offset:468
		scratch_load_dword v142, off, s60 offset:472
		scratch_load_dword v143, off, s60 offset:476
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[248:251], v[140:143], a[84:87], v100, v119 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[248:251], v[132:135], a[88:91], v100, v120 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[248:251], v[136:139], a[92:95], v100, v120 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:384
		scratch_load_dword v141, off, s60 offset:388
		scratch_load_dword v142, off, s60 offset:392
		scratch_load_dword v143, off, s60 offset:396
		s_mov_b32 s60, 0
		scratch_load_dword v144, off, s60 offset:480
		scratch_load_dword v145, off, s60 offset:484
		scratch_load_dword v146, off, s60 offset:488
		scratch_load_dword v147, off, s60 offset:492
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[144:147], v[140:143], a[96:99], v100, v113 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:400
		scratch_load_dword v141, off, s60 offset:404
		scratch_load_dword v142, off, s60 offset:408
		scratch_load_dword v143, off, s60 offset:412
		s_mov_b32 s60, 0
		scratch_load_dword v144, off, s60 offset:480
		scratch_load_dword v145, off, s60 offset:484
		scratch_load_dword v146, off, s60 offset:488
		scratch_load_dword v147, off, s60 offset:492
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[144:147], v[140:143], a[100:103], v100, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:416
		scratch_load_dword v141, off, s60 offset:420
		scratch_load_dword v142, off, s60 offset:424
		scratch_load_dword v143, off, s60 offset:428
		s_mov_b32 s60, 0
		scratch_load_dword v144, off, s60 offset:480
		scratch_load_dword v145, off, s60 offset:484
		scratch_load_dword v146, off, s60 offset:488
		scratch_load_dword v147, off, s60 offset:492
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[144:147], v[140:143], a[104:107], v100, v118 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:432
		scratch_load_dword v141, off, s60 offset:436
		scratch_load_dword v142, off, s60 offset:440
		scratch_load_dword v143, off, s60 offset:444
		s_mov_b32 s60, 0
		scratch_load_dword v144, off, s60 offset:480
		scratch_load_dword v145, off, s60 offset:484
		scratch_load_dword v146, off, s60 offset:488
		scratch_load_dword v147, off, s60 offset:492
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[144:147], v[140:143], a[108:111], v100, v118 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:448
		scratch_load_dword v141, off, s60 offset:452
		scratch_load_dword v142, off, s60 offset:456
		scratch_load_dword v143, off, s60 offset:460
		s_mov_b32 s60, 0
		scratch_load_dword v144, off, s60 offset:480
		scratch_load_dword v145, off, s60 offset:484
		scratch_load_dword v146, off, s60 offset:488
		scratch_load_dword v147, off, s60 offset:492
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[144:147], v[140:143], a[112:115], v100, v119 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:464
		scratch_load_dword v141, off, s60 offset:468
		scratch_load_dword v142, off, s60 offset:472
		scratch_load_dword v143, off, s60 offset:476
		s_mov_b32 s60, 0
		scratch_load_dword v144, off, s60 offset:480
		scratch_load_dword v145, off, s60 offset:484
		scratch_load_dword v146, off, s60 offset:488
		scratch_load_dword v147, off, s60 offset:492
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[144:147], v[140:143], a[116:119], v100, v119 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:480
		scratch_load_dword v141, off, s60 offset:484
		scratch_load_dword v142, off, s60 offset:488
		scratch_load_dword v143, off, s60 offset:492
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[140:143], v[132:135], a[120:123], v100, v120 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:480
		scratch_load_dword v141, off, s60 offset:484
		scratch_load_dword v142, off, s60 offset:488
		scratch_load_dword v143, off, s60 offset:492
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[140:143], v[136:139], a[124:127], v100, v120 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:384
		scratch_load_dword v141, off, s60 offset:388
		scratch_load_dword v142, off, s60 offset:392
		scratch_load_dword v143, off, s60 offset:396
		s_mov_b32 s60, 0
		scratch_load_dword v144, off, s60 offset:496
		scratch_load_dword v145, off, s60 offset:500
		scratch_load_dword v146, off, s60 offset:504
		scratch_load_dword v147, off, s60 offset:508
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[144:147], v[140:143], a[128:131], v101, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:400
		scratch_load_dword v141, off, s60 offset:404
		scratch_load_dword v142, off, s60 offset:408
		scratch_load_dword v143, off, s60 offset:412
		s_mov_b32 s60, 0
		scratch_load_dword v144, off, s60 offset:496
		scratch_load_dword v145, off, s60 offset:500
		scratch_load_dword v146, off, s60 offset:504
		scratch_load_dword v147, off, s60 offset:508
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[144:147], v[140:143], a[132:135], v101, v113 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:416
		scratch_load_dword v141, off, s60 offset:420
		scratch_load_dword v142, off, s60 offset:424
		scratch_load_dword v143, off, s60 offset:428
		s_mov_b32 s60, 0
		scratch_load_dword v144, off, s60 offset:496
		scratch_load_dword v145, off, s60 offset:500
		scratch_load_dword v146, off, s60 offset:504
		scratch_load_dword v147, off, s60 offset:508
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[144:147], v[140:143], a[136:139], v101, v118 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:432
		scratch_load_dword v141, off, s60 offset:436
		scratch_load_dword v142, off, s60 offset:440
		scratch_load_dword v143, off, s60 offset:444
		s_mov_b32 s60, 0
		scratch_load_dword v144, off, s60 offset:496
		scratch_load_dword v145, off, s60 offset:500
		scratch_load_dword v146, off, s60 offset:504
		scratch_load_dword v147, off, s60 offset:508
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[144:147], v[140:143], a[140:143], v101, v118 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:448
		scratch_load_dword v141, off, s60 offset:452
		scratch_load_dword v142, off, s60 offset:456
		scratch_load_dword v143, off, s60 offset:460
		s_mov_b32 s60, 0
		scratch_load_dword v144, off, s60 offset:496
		scratch_load_dword v145, off, s60 offset:500
		scratch_load_dword v146, off, s60 offset:504
		scratch_load_dword v147, off, s60 offset:508
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[144:147], v[140:143], a[144:147], v101, v119 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:464
		scratch_load_dword v141, off, s60 offset:468
		scratch_load_dword v142, off, s60 offset:472
		scratch_load_dword v143, off, s60 offset:476
		s_mov_b32 s60, 0
		scratch_load_dword v144, off, s60 offset:496
		scratch_load_dword v145, off, s60 offset:500
		scratch_load_dword v146, off, s60 offset:504
		scratch_load_dword v147, off, s60 offset:508
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[144:147], v[140:143], a[148:151], v101, v119 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:496
		scratch_load_dword v141, off, s60 offset:500
		scratch_load_dword v142, off, s60 offset:504
		scratch_load_dword v143, off, s60 offset:508
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[140:143], v[132:135], a[152:155], v101, v120 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:496
		scratch_load_dword v141, off, s60 offset:500
		scratch_load_dword v142, off, s60 offset:504
		scratch_load_dword v143, off, s60 offset:508
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[140:143], v[136:139], a[156:159], v101, v120 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:352
		scratch_load_dword v141, off, s60 offset:356
		scratch_load_dword v142, off, s60 offset:360
		scratch_load_dword v143, off, s60 offset:364
		s_mov_b32 s60, 0
		scratch_load_dword v144, off, s60 offset:384
		scratch_load_dword v145, off, s60 offset:388
		scratch_load_dword v146, off, s60 offset:392
		scratch_load_dword v147, off, s60 offset:396
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[140:143], v[144:147], a[160:163], v101, v113 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:352
		scratch_load_dword v141, off, s60 offset:356
		scratch_load_dword v142, off, s60 offset:360
		scratch_load_dword v143, off, s60 offset:364
		s_mov_b32 s60, 0
		scratch_load_dword v144, off, s60 offset:400
		scratch_load_dword v145, off, s60 offset:404
		scratch_load_dword v146, off, s60 offset:408
		scratch_load_dword v147, off, s60 offset:412
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[140:143], v[144:147], a[164:167], v101, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:352
		scratch_load_dword v141, off, s60 offset:356
		scratch_load_dword v142, off, s60 offset:360
		scratch_load_dword v143, off, s60 offset:364
		s_mov_b32 s60, 0
		scratch_load_dword v144, off, s60 offset:416
		scratch_load_dword v145, off, s60 offset:420
		scratch_load_dword v146, off, s60 offset:424
		scratch_load_dword v147, off, s60 offset:428
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[140:143], v[144:147], a[168:171], v101, v118 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:352
		scratch_load_dword v141, off, s60 offset:356
		scratch_load_dword v142, off, s60 offset:360
		scratch_load_dword v143, off, s60 offset:364
		s_mov_b32 s60, 0
		scratch_load_dword v144, off, s60 offset:432
		scratch_load_dword v145, off, s60 offset:436
		scratch_load_dword v146, off, s60 offset:440
		scratch_load_dword v147, off, s60 offset:444
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[140:143], v[144:147], a[172:175], v101, v118 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:352
		scratch_load_dword v141, off, s60 offset:356
		scratch_load_dword v142, off, s60 offset:360
		scratch_load_dword v143, off, s60 offset:364
		s_mov_b32 s60, 0
		scratch_load_dword v144, off, s60 offset:448
		scratch_load_dword v145, off, s60 offset:452
		scratch_load_dword v146, off, s60 offset:456
		scratch_load_dword v147, off, s60 offset:460
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[140:143], v[144:147], a[176:179], v101, v119 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:352
		scratch_load_dword v141, off, s60 offset:356
		scratch_load_dword v142, off, s60 offset:360
		scratch_load_dword v143, off, s60 offset:364
		s_mov_b32 s60, 0
		scratch_load_dword v144, off, s60 offset:464
		scratch_load_dword v145, off, s60 offset:468
		scratch_load_dword v146, off, s60 offset:472
		scratch_load_dword v147, off, s60 offset:476
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[140:143], v[144:147], a[180:183], v101, v119 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:352
		scratch_load_dword v141, off, s60 offset:356
		scratch_load_dword v142, off, s60 offset:360
		scratch_load_dword v143, off, s60 offset:364
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[140:143], v[132:135], a[184:187], v101, v120 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:352
		scratch_load_dword v141, off, s60 offset:356
		scratch_load_dword v142, off, s60 offset:360
		scratch_load_dword v143, off, s60 offset:364
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[140:143], v[136:139], a[188:191], v101, v120 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:384
		scratch_load_dword v141, off, s60 offset:388
		scratch_load_dword v142, off, s60 offset:392
		scratch_load_dword v143, off, s60 offset:396
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[252:255], v[140:143], a[192:195], v112, v113 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:400
		scratch_load_dword v141, off, s60 offset:404
		scratch_load_dword v142, off, s60 offset:408
		scratch_load_dword v143, off, s60 offset:412
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[252:255], v[140:143], a[196:199], v112, v113 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:416
		scratch_load_dword v141, off, s60 offset:420
		scratch_load_dword v142, off, s60 offset:424
		scratch_load_dword v143, off, s60 offset:428
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[252:255], v[140:143], a[200:203], v112, v118 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:432
		scratch_load_dword v141, off, s60 offset:436
		scratch_load_dword v142, off, s60 offset:440
		scratch_load_dword v143, off, s60 offset:444
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[252:255], v[140:143], a[204:207], v112, v118 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:448
		scratch_load_dword v141, off, s60 offset:452
		scratch_load_dword v142, off, s60 offset:456
		scratch_load_dword v143, off, s60 offset:460
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[252:255], v[140:143], a[208:211], v112, v119 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:464
		scratch_load_dword v141, off, s60 offset:468
		scratch_load_dword v142, off, s60 offset:472
		scratch_load_dword v143, off, s60 offset:476
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[252:255], v[140:143], a[212:215], v112, v119 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[252:255], v[132:135], a[216:219], v112, v120 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[252:255], v[136:139], a[220:223], v112, v120 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:368
		scratch_load_dword v141, off, s60 offset:372
		scratch_load_dword v142, off, s60 offset:376
		scratch_load_dword v143, off, s60 offset:380
		s_mov_b32 s60, 0
		scratch_load_dword v144, off, s60 offset:384
		scratch_load_dword v145, off, s60 offset:388
		scratch_load_dword v146, off, s60 offset:392
		scratch_load_dword v147, off, s60 offset:396
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[140:143], v[144:147], a[224:227], v112, v113 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:368
		scratch_load_dword v141, off, s60 offset:372
		scratch_load_dword v142, off, s60 offset:376
		scratch_load_dword v143, off, s60 offset:380
		s_mov_b32 s60, 0
		scratch_load_dword v144, off, s60 offset:400
		scratch_load_dword v145, off, s60 offset:404
		scratch_load_dword v146, off, s60 offset:408
		scratch_load_dword v147, off, s60 offset:412
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[140:143], v[144:147], a[228:231], v112, v113 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:368
		scratch_load_dword v141, off, s60 offset:372
		scratch_load_dword v142, off, s60 offset:376
		scratch_load_dword v143, off, s60 offset:380
		s_mov_b32 s60, 0
		scratch_load_dword v144, off, s60 offset:416
		scratch_load_dword v145, off, s60 offset:420
		scratch_load_dword v146, off, s60 offset:424
		scratch_load_dword v147, off, s60 offset:428
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[140:143], v[144:147], a[232:235], v112, v118 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:368
		scratch_load_dword v141, off, s60 offset:372
		scratch_load_dword v142, off, s60 offset:376
		scratch_load_dword v143, off, s60 offset:380
		s_mov_b32 s60, 0
		scratch_load_dword v144, off, s60 offset:432
		scratch_load_dword v145, off, s60 offset:436
		scratch_load_dword v146, off, s60 offset:440
		scratch_load_dword v147, off, s60 offset:444
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[140:143], v[144:147], a[236:239], v112, v118 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:368
		scratch_load_dword v141, off, s60 offset:372
		scratch_load_dword v142, off, s60 offset:376
		scratch_load_dword v143, off, s60 offset:380
		s_mov_b32 s60, 0
		scratch_load_dword v144, off, s60 offset:448
		scratch_load_dword v145, off, s60 offset:452
		scratch_load_dword v146, off, s60 offset:456
		scratch_load_dword v147, off, s60 offset:460
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[140:143], v[144:147], a[240:243], v112, v119 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:368
		scratch_load_dword v141, off, s60 offset:372
		scratch_load_dword v142, off, s60 offset:376
		scratch_load_dword v143, off, s60 offset:380
		s_mov_b32 s60, 0
		scratch_load_dword v144, off, s60 offset:464
		scratch_load_dword v145, off, s60 offset:468
		scratch_load_dword v146, off, s60 offset:472
		scratch_load_dword v147, off, s60 offset:476
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[140:143], v[144:147], a[244:247], v112, v119 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v140, off, s60 offset:368
		scratch_load_dword v141, off, s60 offset:372
		scratch_load_dword v142, off, s60 offset:376
		scratch_load_dword v143, off, s60 offset:380
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[140:143], v[132:135], a[248:251], v112, v120 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s60, 0
		scratch_load_dword v132, off, s60 offset:368
		scratch_load_dword v133, off, s60 offset:372
		scratch_load_dword v134, off, s60 offset:376
		scratch_load_dword v135, off, s60 offset:380
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[132:135], v[136:139], a[252:255], v112, v120 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s11, s11, 2
		v_readfirstlane_b32 s60, v1
		s_cmp_lt_i32 s11, s60
		s_mov_b32 s60, 0
		s_nop 2
		scratch_load_dword v132, off, s60 offset:320
		scratch_load_dword v133, off, s60 offset:324
		scratch_load_dword v134, off, s60 offset:328
		scratch_load_dword v135, off, s60 offset:332
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v24, v132
		v_mov_b32_e32 v25, v133
		v_mov_b32_e32 v26, v134
		v_mov_b32_e32 v27, v135
		s_mov_b32 s60, 0
		scratch_load_dword v132, off, s60 offset:304
		scratch_load_dword v133, off, s60 offset:308
		scratch_load_dword v134, off, s60 offset:312
		scratch_load_dword v135, off, s60 offset:316
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v28, v132
		v_mov_b32_e32 v29, v133
		v_mov_b32_e32 v30, v134
		v_mov_b32_e32 v31, v135
		s_mov_b32 s60, 0
		scratch_load_dword v132, off, s60 offset:288
		scratch_load_dword v133, off, s60 offset:292
		scratch_load_dword v134, off, s60 offset:296
		scratch_load_dword v135, off, s60 offset:300
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v32, v132
		v_mov_b32_e32 v33, v133
		v_mov_b32_e32 v34, v134
		v_mov_b32_e32 v35, v135
		s_mov_b32 s60, 0
		scratch_load_dword v132, off, s60 offset:272
		scratch_load_dword v133, off, s60 offset:276
		scratch_load_dword v134, off, s60 offset:280
		scratch_load_dword v135, off, s60 offset:284
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v36, v132
		v_mov_b32_e32 v37, v133
		v_mov_b32_e32 v38, v134
		v_mov_b32_e32 v39, v135
		s_mov_b32 s60, 0
		scratch_load_dword v132, off, s60 offset:256
		scratch_load_dword v133, off, s60 offset:260
		scratch_load_dword v134, off, s60 offset:264
		scratch_load_dword v135, off, s60 offset:268
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v40, v132
		v_mov_b32_e32 v41, v133
		v_mov_b32_e32 v42, v134
		v_mov_b32_e32 v43, v135
		s_mov_b32 s60, 0
		scratch_load_dword v132, off, s60 offset:240
		scratch_load_dword v133, off, s60 offset:244
		scratch_load_dword v134, off, s60 offset:248
		scratch_load_dword v135, off, s60 offset:252
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v44, v132
		v_mov_b32_e32 v45, v133
		v_mov_b32_e32 v46, v134
		v_mov_b32_e32 v47, v135
		s_mov_b32 s60, 0
		scratch_load_dword v132, off, s60 offset:224
		scratch_load_dword v133, off, s60 offset:228
		scratch_load_dword v134, off, s60 offset:232
		scratch_load_dword v135, off, s60 offset:236
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v48, v132
		v_mov_b32_e32 v49, v133
		v_mov_b32_e32 v50, v134
		v_mov_b32_e32 v51, v135
		s_mov_b32 s60, 0
		scratch_load_dword v132, off, s60 offset:208
		scratch_load_dword v133, off, s60 offset:212
		scratch_load_dword v134, off, s60 offset:216
		scratch_load_dword v135, off, s60 offset:220
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v52, v132
		v_mov_b32_e32 v53, v133
		v_mov_b32_e32 v54, v134
		v_mov_b32_e32 v55, v135
		s_mov_b32 s60, 0
		scratch_load_dword v132, off, s60 offset:192
		scratch_load_dword v133, off, s60 offset:196
		scratch_load_dword v134, off, s60 offset:200
		scratch_load_dword v135, off, s60 offset:204
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v56, v132
		v_mov_b32_e32 v57, v133
		v_mov_b32_e32 v58, v134
		v_mov_b32_e32 v59, v135
		s_mov_b32 s60, 0
		scratch_load_dword v132, off, s60 offset:176
		scratch_load_dword v133, off, s60 offset:180
		scratch_load_dword v134, off, s60 offset:184
		scratch_load_dword v135, off, s60 offset:188
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v60, v132
		v_mov_b32_e32 v61, v133
		v_mov_b32_e32 v62, v134
		v_mov_b32_e32 v63, v135
		s_mov_b32 s60, 0
		scratch_load_dword v132, off, s60 offset:144
		scratch_load_dword v133, off, s60 offset:148
		scratch_load_dword v134, off, s60 offset:152
		scratch_load_dword v135, off, s60 offset:156
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v64, v132
		v_mov_b32_e32 v65, v133
		v_mov_b32_e32 v66, v134
		v_mov_b32_e32 v67, v135
		s_mov_b32 s60, 0
		scratch_load_dword v132, off, s60 offset:160
		scratch_load_dword v133, off, s60 offset:164
		scratch_load_dword v134, off, s60 offset:168
		scratch_load_dword v135, off, s60 offset:172
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v68, v132
		v_mov_b32_e32 v69, v133
		v_mov_b32_e32 v70, v134
		v_mov_b32_e32 v71, v135
		v_mov_b32_e32 v2, v4
		v_mov_b32_e32 v7, v5
		v_mov_b32_e32 v72, v74
		v_mov_b32_e32 v73, v80
		v_mov_b32_e32 v6, v81
		v_mov_b32_e32 v75, v90
		v_mov_b32_e32 v76, v91
		v_mov_b32_e32 v77, v92
		s_mov_b32 s60, 0
		scratch_store_dword off, v152, s60 offset:336
		scratch_store_dword off, v153, s60 offset:340
		scratch_store_dword off, v154, s60 offset:344
		scratch_store_dword off, v155, s60 offset:348
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v80, off, s0 offset:336
		scratch_load_dword v81, off, s0 offset:340
		scratch_load_dword v82, off, s0 offset:344
		scratch_load_dword v83, off, s0 offset:348
		s_add_i32 s0, s12, -1
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[8:11], v[40:43], v[80:83], v2, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s1, s0, 1
		s_lshl_b32 s0, s1, 16
		v_lshlrev_b32_e32 v1, 2, v0
		ds_read_b32 v3, v1 offset:1024
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v1, s0, v3
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v4, v3 offset:5120
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v5, v3 offset:6144
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v3, v1, v5, v4
		ds_read_b128 v[84:87], v3 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[8:11], v[44:47], a[4:7], v2, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v3 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[8:11], v[48:51], a[8:11], v2, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v3 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[8:11], v[52:55], a[12:15], v2, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v3 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[8:11], v[56:59], a[16:19], v2, v76 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v3 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[8:11], v[60:63], a[20:23], v2, v76 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[104:107], v3 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[8:11], v[64:67], a[24:27], v2, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[108:111], v3 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[8:11], v[68:71], a[28:31], v2, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[8:11], v3 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[12:15], v[40:43], a[32:35], v2, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_lshlrev_b32_e32 v1, 2, v0
		ds_read_b32 v3, v1 offset:6144
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v1, s0, v3
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v4, v3
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v5, v3 offset:5120
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v3, v1, v4, v5
		ds_read_b128 v[112:115], v3 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[12:15], v[44:47], a[36:39], v2, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[116:119], v3 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[12:15], v[48:51], a[40:43], v2, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[120:123], v3 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[12:15], v[52:55], a[44:47], v2, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[124:127], v3 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[12:15], v[56:59], a[48:51], v2, v76 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[128:131], v3 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[12:15], v[60:63], a[52:55], v2, v76 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[132:135], v3 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[12:15], v[64:67], a[56:59], v2, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[136:139], v3 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[12:15], v[68:71], a[60:63], v2, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[12:15], v3 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[16:19], v[40:43], a[64:67], v7, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[16:19], v[44:47], a[68:71], v7, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[16:19], v[48:51], a[72:75], v7, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[16:19], v[52:55], a[76:79], v7, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[16:19], v[56:59], a[80:83], v7, v76 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[16:19], v[60:63], a[84:87], v7, v76 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[16:19], v[64:67], a[88:91], v7, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[16:19], v[68:71], a[92:95], v7, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[20:23], v[40:43], a[96:99], v7, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[20:23], v[44:47], a[100:103], v7, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[20:23], v[48:51], a[104:107], v7, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[20:23], v[52:55], a[108:111], v7, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[20:23], v[56:59], a[112:115], v7, v76 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[20:23], v[60:63], a[116:119], v7, v76 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[20:23], v[64:67], a[120:123], v7, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[20:23], v[68:71], a[124:127], v7, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[24:27], v[40:43], a[128:131], v72, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[24:27], v[44:47], a[132:135], v72, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[24:27], v[48:51], a[136:139], v72, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[24:27], v[52:55], a[140:143], v72, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[24:27], v[56:59], a[144:147], v72, v76 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[24:27], v[60:63], a[148:151], v72, v76 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[24:27], v[64:67], a[152:155], v72, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[24:27], v[68:71], a[156:159], v72, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[28:31], v[40:43], a[160:163], v72, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[28:31], v[44:47], a[164:167], v72, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[28:31], v[48:51], a[168:171], v72, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[28:31], v[52:55], a[172:175], v72, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[28:31], v[56:59], a[176:179], v72, v76 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[28:31], v[60:63], a[180:183], v72, v76 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[28:31], v[64:67], a[184:187], v72, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[28:31], v[68:71], a[188:191], v72, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[32:35], v[40:43], a[192:195], v73, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[32:35], v[44:47], a[196:199], v73, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[32:35], v[48:51], a[200:203], v73, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[32:35], v[52:55], a[204:207], v73, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[32:35], v[56:59], a[208:211], v73, v76 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[32:35], v[60:63], a[212:215], v73, v76 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[32:35], v[64:67], a[216:219], v73, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[32:35], v[68:71], a[220:223], v73, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[36:39], v[40:43], a[224:227], v73, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[36:39], v[44:47], a[228:231], v73, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[36:39], v[48:51], a[232:235], v73, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[36:39], v[52:55], a[236:239], v73, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[36:39], v[56:59], a[240:243], v73, v76 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[36:39], v[60:63], a[244:247], v73, v76 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[36:39], v[64:67], a[248:251], v73, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[36:39], v[68:71], a[252:255], v73, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[84:87], v[112:115], v[80:83], v2, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[84:87], v[116:119], a[4:7], v2, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[84:87], v[120:123], a[8:11], v2, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[84:87], v[124:127], a[12:15], v2, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[84:87], v[128:131], a[16:19], v2, v76 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[84:87], v[132:135], a[20:23], v2, v76 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[84:87], v[136:139], a[24:27], v2, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[84:87], v[12:15], a[28:31], v2, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[88:91], v[112:115], a[32:35], v2, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[88:91], v[116:119], a[36:39], v2, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[88:91], v[120:123], a[40:43], v2, v75 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[88:91], v[124:127], a[44:47], v2, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[88:91], v[128:131], a[48:51], v2, v76 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[88:91], v[132:135], a[52:55], v2, v76 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[88:91], v[136:139], a[56:59], v2, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[88:91], v[12:15], a[60:63], v2, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[92:95], v[112:115], a[64:67], v7, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[92:95], v[116:119], a[68:71], v7, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[92:95], v[120:123], a[72:75], v7, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[92:95], v[124:127], a[76:79], v7, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[92:95], v[128:131], a[80:83], v7, v76 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[92:95], v[132:135], a[84:87], v7, v76 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[92:95], v[136:139], a[88:91], v7, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[92:95], v[12:15], a[92:95], v7, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[96:99], v[112:115], a[96:99], v7, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[96:99], v[116:119], a[100:103], v7, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[96:99], v[120:123], a[104:107], v7, v75 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[96:99], v[124:127], a[108:111], v7, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[96:99], v[128:131], a[112:115], v7, v76 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[96:99], v[132:135], a[116:119], v7, v76 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[96:99], v[136:139], a[120:123], v7, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[96:99], v[12:15], a[124:127], v7, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[100:103], v[112:115], a[128:131], v72, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[100:103], v[116:119], a[132:135], v72, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[100:103], v[120:123], a[136:139], v72, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[100:103], v[124:127], a[140:143], v72, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[100:103], v[128:131], a[144:147], v72, v76 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[100:103], v[132:135], a[148:151], v72, v76 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[100:103], v[136:139], a[152:155], v72, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[100:103], v[12:15], a[156:159], v72, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[104:107], v[112:115], a[160:163], v72, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[104:107], v[116:119], a[164:167], v72, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[104:107], v[120:123], a[168:171], v72, v75 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[104:107], v[124:127], a[172:175], v72, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[104:107], v[128:131], a[176:179], v72, v76 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[104:107], v[132:135], a[180:183], v72, v76 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[104:107], v[136:139], a[184:187], v72, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[104:107], v[12:15], a[188:191], v72, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[108:111], v[112:115], a[192:195], v73, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[108:111], v[116:119], a[196:199], v73, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[108:111], v[120:123], a[200:203], v73, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[108:111], v[124:127], a[204:207], v73, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[108:111], v[128:131], a[208:211], v73, v76 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[108:111], v[132:135], a[212:215], v73, v76 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[108:111], v[136:139], a[216:219], v73, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[108:111], v[12:15], a[220:223], v73, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[8:11], v[112:115], a[224:227], v73, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[8:11], v[116:119], a[228:231], v73, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[8:11], v[120:123], a[232:235], v73, v75 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[8:11], v[124:127], a[236:239], v73, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[8:11], v[128:131], a[240:243], v73, v76 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[8:11], v[132:135], a[244:247], v73, v76 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[8:11], v[136:139], a[248:251], v73, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[8:11], v[12:15], a[252:255], v73, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s0, s12, 1
		s_lshl_b32 s1, s0, 16
		v_lshlrev_b32_e32 v1, 2, v0
		ds_read_b32 v2, v1 offset:1024
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v1, s1, v2
		v_lshlrev_b32_e32 v2, 2, v0
		ds_read_b32 v3, v2 offset:5120
		v_lshlrev_b32_e32 v2, 2, v0
		ds_read_b32 v4, v2 offset:6144
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v2, v1, v4, v3
		ds_read_b128 v[4:7], v2
		ds_read_b128 v[8:11], v2 offset:1024
		ds_read_b128 v[12:15], v2 offset:2048
		ds_read_b128 v[16:19], v2 offset:3072
		ds_read_b128 v[20:23], v2 offset:4096
		ds_read_b128 v[24:27], v2 offset:5120
		ds_read_b128 v[28:31], v2 offset:6144
		ds_read_b128 v[32:35], v2 offset:7168
		v_lshlrev_b32_e32 v1, 2, v0
		ds_read_b32 v3, v1 offset:6144
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v1, s1, v3
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v36, v3
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v37, v3 offset:5120
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v3, v1, v36, v37
		ds_read_b128 v[36:39], v3 offset:32768
		ds_read_b128 v[40:43], v3 offset:33792
		ds_read_b128 v[44:47], v3 offset:34816
		ds_read_b128 v[48:51], v3 offset:35840
		ds_read_b128 v[52:55], v3 offset:36864
		ds_read_b128 v[56:59], v3 offset:37888
		ds_read_b128 v[60:63], v3 offset:38912
		ds_read_b128 v[64:67], v3 offset:39936
		s_lshl_b32 s1, s0, 12
		s_add_i32 s0, s1, 0x20000
		v_lshlrev_b32_e32 v1, 2, v0
		ds_read_b32 v68, v1 offset:3072
		v_lshlrev_b32_e32 v1, 2, v0
		ds_read_b32 v69, v1 offset:4096
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v1, s0, v68, v69
		ds_read_b32 v68, v1
		ds_read_b32 v69, v1 offset:256
		ds_read_b32 v70, v1 offset:512
		ds_read_b32 v71, v1 offset:768
		v_lshlrev_b32_e32 v1, 2, v0
		ds_read_b32 v72, v1 offset:2048
		v_lshlrev_b32_e32 v1, 2, v0
		ds_read_b32 v73, v1 offset:4096
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v1, s0, v73, v72
		ds_read_b32 v72, v1 offset:2048
		ds_read_b32 v73, v1 offset:2304
		ds_read_b32 v74, v1 offset:2560
		ds_read_b32 v75, v1 offset:2816
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[4:7], v[36:39], v[80:83], v68, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[76:79], v2 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[4:7], v[40:43], a[4:7], v68, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[84:87], v2 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[4:7], v[44:47], a[8:11], v68, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v2 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[4:7], v[48:51], a[12:15], v68, v73 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v2 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[4:7], v[52:55], a[16:19], v68, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v2 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[4:7], v[56:59], a[20:23], v68, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v2 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[4:7], v[60:63], a[24:27], v68, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[104:107], v2 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[4:7], v[64:67], a[28:31], v68, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[4:7], v2 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[8:11], v[36:39], a[32:35], v68, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[108:111], v3 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[8:11], v[40:43], a[36:39], v68, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[112:115], v3 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[8:11], v[44:47], a[40:43], v68, v73 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[116:119], v3 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[8:11], v[48:51], a[44:47], v68, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[120:123], v3 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[8:11], v[52:55], a[48:51], v68, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[124:127], v3 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[8:11], v[56:59], a[52:55], v68, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[128:131], v3 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[8:11], v[60:63], a[56:59], v68, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[132:135], v3 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[8:11], v[64:67], a[60:63], v68, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[8:11], v3 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[12:15], v[36:39], a[64:67], v69, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[12:15], v[40:43], a[68:71], v69, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[12:15], v[44:47], a[72:75], v69, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[12:15], v[48:51], a[76:79], v69, v73 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[12:15], v[52:55], a[80:83], v69, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[12:15], v[56:59], a[84:87], v69, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[12:15], v[60:63], a[88:91], v69, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[12:15], v[64:67], a[92:95], v69, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[16:19], v[36:39], a[96:99], v69, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[16:19], v[40:43], a[100:103], v69, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[16:19], v[44:47], a[104:107], v69, v73 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[16:19], v[48:51], a[108:111], v69, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[16:19], v[52:55], a[112:115], v69, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[16:19], v[56:59], a[116:119], v69, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[16:19], v[60:63], a[120:123], v69, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[16:19], v[64:67], a[124:127], v69, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[20:23], v[36:39], a[128:131], v70, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[20:23], v[40:43], a[132:135], v70, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[20:23], v[44:47], a[136:139], v70, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[20:23], v[48:51], a[140:143], v70, v73 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[20:23], v[52:55], a[144:147], v70, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[20:23], v[56:59], a[148:151], v70, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[20:23], v[60:63], a[152:155], v70, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[20:23], v[64:67], a[156:159], v70, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[24:27], v[36:39], a[160:163], v70, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[24:27], v[40:43], a[164:167], v70, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[24:27], v[44:47], a[168:171], v70, v73 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[24:27], v[48:51], a[172:175], v70, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[24:27], v[52:55], a[176:179], v70, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[24:27], v[56:59], a[180:183], v70, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[24:27], v[60:63], a[184:187], v70, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[24:27], v[64:67], a[188:191], v70, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[28:31], v[36:39], a[192:195], v71, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[28:31], v[40:43], a[196:199], v71, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[28:31], v[44:47], a[200:203], v71, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[28:31], v[48:51], a[204:207], v71, v73 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[28:31], v[52:55], a[208:211], v71, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[28:31], v[56:59], a[212:215], v71, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[28:31], v[60:63], a[216:219], v71, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[28:31], v[64:67], a[220:223], v71, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[32:35], v[36:39], a[224:227], v71, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[32:35], v[40:43], a[228:231], v71, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[32:35], v[44:47], a[232:235], v71, v73 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[32:35], v[48:51], a[236:239], v71, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[32:35], v[52:55], a[240:243], v71, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[32:35], v[56:59], a[244:247], v71, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[32:35], v[60:63], a[248:251], v71, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[32:35], v[64:67], a[252:255], v71, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[76:79], v[108:111], v[80:83], v68, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[76:79], v[112:115], a[4:7], v68, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[76:79], v[116:119], a[8:11], v68, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[76:79], v[120:123], a[12:15], v68, v73 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[76:79], v[124:127], a[16:19], v68, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[76:79], v[128:131], a[20:23], v68, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[76:79], v[132:135], a[24:27], v68, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[76:79], v[8:11], a[28:31], v68, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[84:87], v[108:111], a[32:35], v68, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[84:87], v[112:115], a[36:39], v68, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[84:87], v[116:119], a[40:43], v68, v73 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[84:87], v[120:123], a[44:47], v68, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[84:87], v[124:127], a[48:51], v68, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[84:87], v[128:131], a[52:55], v68, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[84:87], v[132:135], a[56:59], v68, v75 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[84:87], v[8:11], a[60:63], v68, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[88:91], v[108:111], a[64:67], v69, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[88:91], v[112:115], a[68:71], v69, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[88:91], v[116:119], a[72:75], v69, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[88:91], v[120:123], a[76:79], v69, v73 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[88:91], v[124:127], a[80:83], v69, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[88:91], v[128:131], a[84:87], v69, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[88:91], v[132:135], a[88:91], v69, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[88:91], v[8:11], a[92:95], v69, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[92:95], v[108:111], a[96:99], v69, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[92:95], v[112:115], a[100:103], v69, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[92:95], v[116:119], a[104:107], v69, v73 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[92:95], v[120:123], a[108:111], v69, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[92:95], v[124:127], a[112:115], v69, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[92:95], v[128:131], a[116:119], v69, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[92:95], v[132:135], a[120:123], v69, v75 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[92:95], v[8:11], a[124:127], v69, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[96:99], v[108:111], a[128:131], v70, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[96:99], v[112:115], a[132:135], v70, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[96:99], v[116:119], a[136:139], v70, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[96:99], v[120:123], a[140:143], v70, v73 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[96:99], v[124:127], a[144:147], v70, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[96:99], v[128:131], a[148:151], v70, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[96:99], v[132:135], a[152:155], v70, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[96:99], v[8:11], a[156:159], v70, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[100:103], v[108:111], a[160:163], v70, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[100:103], v[112:115], a[164:167], v70, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[100:103], v[116:119], a[168:171], v70, v73 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[100:103], v[120:123], a[172:175], v70, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[100:103], v[124:127], a[176:179], v70, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[100:103], v[128:131], a[180:183], v70, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[100:103], v[132:135], a[184:187], v70, v75 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[100:103], v[8:11], a[188:191], v70, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[104:107], v[108:111], a[192:195], v71, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[104:107], v[112:115], a[196:199], v71, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[104:107], v[116:119], a[200:203], v71, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[104:107], v[120:123], a[204:207], v71, v73 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[104:107], v[124:127], a[208:211], v71, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[104:107], v[128:131], a[212:215], v71, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[104:107], v[132:135], a[216:219], v71, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[104:107], v[8:11], a[220:223], v71, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[4:7], v[108:111], a[224:227], v71, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[4:7], v[112:115], a[228:231], v71, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[4:7], v[116:119], a[232:235], v71, v73 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[4:7], v[120:123], a[236:239], v71, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[4:7], v[124:127], a[240:243], v71, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[4:7], v[128:131], a[244:247], v71, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[4:7], v[132:135], a[248:251], v71, v75 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[4:7], v[8:11], a[252:255], v71, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v80, v81
		v_cvt_pk_f16_f32 v3, v82, v83
		v_lshlrev_b32_e32 v1, 2, v0
		ds_read_b32 v4, v1 offset:8192
		s_waitcnt lgkmcnt(0)
		v_lshlrev_b32_e32 v1, 3, v4
		v_lshlrev_b32_e32 v4, 2, v0
		ds_read_b32 v0, v4 offset:7168
		s_waitcnt lgkmcnt(0)
		v_lshl_add_u32 v4, v0, 15, v1
		s_lshl_b32 s0, s13, 21
		s_lshl_b32 s1, s14, 17
		s_add_i32 s2, s0, s1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s2 offen
		v_accvgpr_read_b32 v0, a4
		v_accvgpr_read_b32 v1, a5
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a6
		v_accvgpr_read_b32 v1, a7
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s2 offen offset:512
		v_accvgpr_read_b32 v0, a8
		v_accvgpr_read_b32 v1, a9
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a10
		v_accvgpr_read_b32 v1, a11
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s2 offen offset:1024
		v_accvgpr_read_b32 v0, a12
		v_accvgpr_read_b32 v1, a13
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a14
		v_accvgpr_read_b32 v1, a15
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s2 offen offset:1536
		v_accvgpr_read_b32 v0, a16
		v_accvgpr_read_b32 v1, a17
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a18
		v_accvgpr_read_b32 v1, a19
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s2 offen offset:2048
		v_accvgpr_read_b32 v0, a20
		v_accvgpr_read_b32 v1, a21
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a22
		v_accvgpr_read_b32 v1, a23
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s2 offen offset:2560
		v_accvgpr_read_b32 v0, a24
		v_accvgpr_read_b32 v1, a25
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a26
		v_accvgpr_read_b32 v1, a27
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s2 offen offset:3072
		v_accvgpr_read_b32 v0, a28
		v_accvgpr_read_b32 v1, a29
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a30
		v_accvgpr_read_b32 v1, a31
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s2 offen offset:3584
		v_accvgpr_read_b32 v0, a32
		v_accvgpr_read_b32 v1, a33
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a34
		v_accvgpr_read_b32 v1, a35
		v_cvt_pk_f16_f32 v3, v0, v1
		s_add_i32 s2, s0, 0x1000
		s_add_i32 s3, s2, s1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen
		v_accvgpr_read_b32 v0, a36
		v_accvgpr_read_b32 v1, a37
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a38
		v_accvgpr_read_b32 v1, a39
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:512
		v_accvgpr_read_b32 v0, a40
		v_accvgpr_read_b32 v1, a41
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a42
		v_accvgpr_read_b32 v1, a43
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:1024
		v_accvgpr_read_b32 v0, a44
		v_accvgpr_read_b32 v1, a45
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a46
		v_accvgpr_read_b32 v1, a47
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:1536
		v_accvgpr_read_b32 v0, a48
		v_accvgpr_read_b32 v1, a49
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a50
		v_accvgpr_read_b32 v1, a51
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:2048
		v_accvgpr_read_b32 v0, a52
		v_accvgpr_read_b32 v1, a53
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a54
		v_accvgpr_read_b32 v1, a55
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:2560
		v_accvgpr_read_b32 v0, a56
		v_accvgpr_read_b32 v1, a57
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a58
		v_accvgpr_read_b32 v1, a59
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:3072
		v_accvgpr_read_b32 v0, a60
		v_accvgpr_read_b32 v1, a61
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a62
		v_accvgpr_read_b32 v1, a63
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:3584
		v_accvgpr_read_b32 v0, a64
		v_accvgpr_read_b32 v1, a65
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a66
		v_accvgpr_read_b32 v1, a67
		v_cvt_pk_f16_f32 v3, v0, v1
		s_add_i32 s2, s0, 0x2000
		s_add_i32 s3, s2, s1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen
		v_accvgpr_read_b32 v0, a68
		v_accvgpr_read_b32 v1, a69
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a70
		v_accvgpr_read_b32 v1, a71
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:512
		v_accvgpr_read_b32 v0, a72
		v_accvgpr_read_b32 v1, a73
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a74
		v_accvgpr_read_b32 v1, a75
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:1024
		v_accvgpr_read_b32 v0, a76
		v_accvgpr_read_b32 v1, a77
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a78
		v_accvgpr_read_b32 v1, a79
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:1536
		v_accvgpr_read_b32 v0, a80
		v_accvgpr_read_b32 v1, a81
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a82
		v_accvgpr_read_b32 v1, a83
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:2048
		v_accvgpr_read_b32 v0, a84
		v_accvgpr_read_b32 v1, a85
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a86
		v_accvgpr_read_b32 v1, a87
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:2560
		v_accvgpr_read_b32 v0, a88
		v_accvgpr_read_b32 v1, a89
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a90
		v_accvgpr_read_b32 v1, a91
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:3072
		v_accvgpr_read_b32 v0, a92
		v_accvgpr_read_b32 v1, a93
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a94
		v_accvgpr_read_b32 v1, a95
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:3584
		v_accvgpr_read_b32 v0, a96
		v_accvgpr_read_b32 v1, a97
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a98
		v_accvgpr_read_b32 v1, a99
		v_cvt_pk_f16_f32 v3, v0, v1
		s_add_i32 s2, s0, 0x3000
		s_add_i32 s3, s2, s1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen
		v_accvgpr_read_b32 v0, a100
		v_accvgpr_read_b32 v1, a101
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a102
		v_accvgpr_read_b32 v1, a103
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:512
		v_accvgpr_read_b32 v0, a104
		v_accvgpr_read_b32 v1, a105
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a106
		v_accvgpr_read_b32 v1, a107
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:1024
		v_accvgpr_read_b32 v0, a108
		v_accvgpr_read_b32 v1, a109
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a110
		v_accvgpr_read_b32 v1, a111
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:1536
		v_accvgpr_read_b32 v0, a112
		v_accvgpr_read_b32 v1, a113
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a114
		v_accvgpr_read_b32 v1, a115
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:2048
		v_accvgpr_read_b32 v0, a116
		v_accvgpr_read_b32 v1, a117
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a118
		v_accvgpr_read_b32 v1, a119
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:2560
		v_accvgpr_read_b32 v0, a120
		v_accvgpr_read_b32 v1, a121
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a122
		v_accvgpr_read_b32 v1, a123
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:3072
		v_accvgpr_read_b32 v0, a124
		v_accvgpr_read_b32 v1, a125
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a126
		v_accvgpr_read_b32 v1, a127
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:3584
		v_accvgpr_read_b32 v0, a128
		v_accvgpr_read_b32 v1, a129
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a130
		v_accvgpr_read_b32 v1, a131
		v_cvt_pk_f16_f32 v3, v0, v1
		s_add_i32 s2, s0, 0x4000
		s_add_i32 s3, s2, s1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen
		v_accvgpr_read_b32 v0, a132
		v_accvgpr_read_b32 v1, a133
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a134
		v_accvgpr_read_b32 v1, a135
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:512
		v_accvgpr_read_b32 v0, a136
		v_accvgpr_read_b32 v1, a137
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a138
		v_accvgpr_read_b32 v1, a139
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:1024
		v_accvgpr_read_b32 v0, a140
		v_accvgpr_read_b32 v1, a141
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a142
		v_accvgpr_read_b32 v1, a143
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:1536
		v_accvgpr_read_b32 v0, a144
		v_accvgpr_read_b32 v1, a145
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a146
		v_accvgpr_read_b32 v1, a147
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:2048
		v_accvgpr_read_b32 v0, a148
		v_accvgpr_read_b32 v1, a149
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a150
		v_accvgpr_read_b32 v1, a151
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:2560
		v_accvgpr_read_b32 v0, a152
		v_accvgpr_read_b32 v1, a153
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a154
		v_accvgpr_read_b32 v1, a155
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:3072
		v_accvgpr_read_b32 v0, a156
		v_accvgpr_read_b32 v1, a157
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a158
		v_accvgpr_read_b32 v1, a159
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:3584
		v_accvgpr_read_b32 v0, a160
		v_accvgpr_read_b32 v1, a161
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a162
		v_accvgpr_read_b32 v1, a163
		v_cvt_pk_f16_f32 v3, v0, v1
		s_add_i32 s2, s0, 0x5000
		s_add_i32 s3, s2, s1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen
		v_accvgpr_read_b32 v0, a164
		v_accvgpr_read_b32 v1, a165
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a166
		v_accvgpr_read_b32 v1, a167
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:512
		v_accvgpr_read_b32 v0, a168
		v_accvgpr_read_b32 v1, a169
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a170
		v_accvgpr_read_b32 v1, a171
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:1024
		v_accvgpr_read_b32 v0, a172
		v_accvgpr_read_b32 v1, a173
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a174
		v_accvgpr_read_b32 v1, a175
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:1536
		v_accvgpr_read_b32 v0, a176
		v_accvgpr_read_b32 v1, a177
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a178
		v_accvgpr_read_b32 v1, a179
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:2048
		v_accvgpr_read_b32 v0, a180
		v_accvgpr_read_b32 v1, a181
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a182
		v_accvgpr_read_b32 v1, a183
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:2560
		v_accvgpr_read_b32 v0, a184
		v_accvgpr_read_b32 v1, a185
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a186
		v_accvgpr_read_b32 v1, a187
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:3072
		v_accvgpr_read_b32 v0, a188
		v_accvgpr_read_b32 v1, a189
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a190
		v_accvgpr_read_b32 v1, a191
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:3584
		v_accvgpr_read_b32 v0, a192
		v_accvgpr_read_b32 v1, a193
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a194
		v_accvgpr_read_b32 v1, a195
		v_cvt_pk_f16_f32 v3, v0, v1
		s_add_i32 s2, s0, 0x6000
		s_add_i32 s3, s2, s1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen
		v_accvgpr_read_b32 v0, a196
		v_accvgpr_read_b32 v1, a197
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a198
		v_accvgpr_read_b32 v1, a199
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:512
		v_accvgpr_read_b32 v0, a200
		v_accvgpr_read_b32 v1, a201
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a202
		v_accvgpr_read_b32 v1, a203
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:1024
		v_accvgpr_read_b32 v0, a204
		v_accvgpr_read_b32 v1, a205
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a206
		v_accvgpr_read_b32 v1, a207
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:1536
		v_accvgpr_read_b32 v0, a208
		v_accvgpr_read_b32 v1, a209
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a210
		v_accvgpr_read_b32 v1, a211
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:2048
		v_accvgpr_read_b32 v0, a212
		v_accvgpr_read_b32 v1, a213
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a214
		v_accvgpr_read_b32 v1, a215
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:2560
		v_accvgpr_read_b32 v0, a216
		v_accvgpr_read_b32 v1, a217
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a218
		v_accvgpr_read_b32 v1, a219
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:3072
		v_accvgpr_read_b32 v0, a220
		v_accvgpr_read_b32 v1, a221
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a222
		v_accvgpr_read_b32 v1, a223
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s3 offen offset:3584
		v_accvgpr_read_b32 v0, a224
		v_accvgpr_read_b32 v1, a225
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a226
		v_accvgpr_read_b32 v1, a227
		v_cvt_pk_f16_f32 v3, v0, v1
		s_add_i32 s2, s0, 0x7000
		s_add_i32 s0, s2, s1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s0 offen
		v_accvgpr_read_b32 v0, a228
		v_accvgpr_read_b32 v1, a229
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a230
		v_accvgpr_read_b32 v1, a231
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s0 offen offset:512
		v_accvgpr_read_b32 v0, a232
		v_accvgpr_read_b32 v1, a233
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a234
		v_accvgpr_read_b32 v1, a235
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s0 offen offset:1024
		v_accvgpr_read_b32 v0, a236
		v_accvgpr_read_b32 v1, a237
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a238
		v_accvgpr_read_b32 v1, a239
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s0 offen offset:1536
		v_accvgpr_read_b32 v0, a240
		v_accvgpr_read_b32 v1, a241
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a242
		v_accvgpr_read_b32 v1, a243
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s0 offen offset:2048
		v_accvgpr_read_b32 v0, a244
		v_accvgpr_read_b32 v1, a245
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a246
		v_accvgpr_read_b32 v1, a247
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s0 offen offset:2560
		v_accvgpr_read_b32 v0, a248
		v_accvgpr_read_b32 v1, a249
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a250
		v_accvgpr_read_b32 v1, a251
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s0 offen offset:3072
		v_accvgpr_read_b32 v0, a252
		v_accvgpr_read_b32 v1, a253
		v_cvt_pk_f16_f32 v2, v0, v1
		v_accvgpr_read_b32 v0, a254
		v_accvgpr_read_b32 v1, a255
		v_cvt_pk_f16_f32 v3, v0, v1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s0 offen offset:3584
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 9216
		.amdhsa_private_segment_fixed_size 512
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
		.amdhsa_next_free_sgpr 62
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
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 62
	.set .Lwmma_f16_matmul_tiled.num_named_barrier, 0
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 512
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
    .group_segment_fixed_size: 9216
    .kernarg_segment_align: 8
    .kernarg_segment_size: 48
    .max_flat_workgroup_size: 256
    .name:           wmma_f16_matmul_tiled
    .private_segment_fixed_size: 512
    .sgpr_count:     62
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     512
    .agpr_count:     256
    .vgpr_spill_count: 132
    .wavefront_size: 64
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
