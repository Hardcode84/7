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
		scratch_store_dword off, v4, s8 offset:112
		scratch_store_dword off, v5, s8 offset:116
		scratch_store_dword off, v6, s8 offset:120
		scratch_store_dword off, v7, s8 offset:124
		v_readfirstlane_b32 s8, v0
		s_lshl_b32 s9, s13, 20
		v_lshrrev_b32_e32 v1, 6, v0
		v_accvgpr_write_b32 a0, v1
		v_accvgpr_read_b32 v1, a0
		v_lshlrev_b32_e32 v2, 16, v1
		v_add_u32_e32 v1, s9, v2
		v_and_b32_e32 v3, 63, v0
		v_accvgpr_write_b32 a1, v3
		v_accvgpr_read_b32 v3, a1
		v_lshrrev_b32_e32 v4, 2, v3
		v_lshlrev_b32_e32 v3, 12, v4
		v_accvgpr_read_b32 v4, a1
		v_lshrrev_b32_e32 v5, 3, v4
		v_and_b32_e32 v4, 3, v5
		v_accvgpr_read_b32 v5, a1
		v_and_b32_e32 v6, 3, v5
		v_xor_b32_e32 v5, v4, v6
		v_lshlrev_b32_e32 v4, 4, v5
		v_add3_u32 v5, v1, v3, v4
		s_add_i32 s10, s9, 0x40000
		v_add_u32_e32 v1, s10, v2
		v_add3_u32 v6, v1, v3, v4
		s_add_i32 s10, s9, 0x80000
		v_add_u32_e32 v1, s10, v2
		v_add3_u32 v7, v1, v3, v4
		s_add_i32 s10, s9, 0xc0000
		v_add_u32_e32 v1, s10, v2
		v_add3_u32 v8, v1, v3, v4
		v_add3_u32 v1, s9, 64, v2
		v_add3_u32 v9, v1, v3, v4
		s_add_i32 s10, s9, 0x40040
		v_add_u32_e32 v1, s10, v2
		v_add3_u32 v10, v1, v3, v4
		s_add_i32 s10, s9, 0x80040
		v_add_u32_e32 v1, s10, v2
		v_add3_u32 v11, v1, v3, v4
		s_add_i32 s10, s9, 0xc0040
		v_add_u32_e32 v1, s10, v2
		v_add3_u32 v12, v1, v3, v4
		s_lshl_b32 s10, s14, 20
		v_add_u32_e32 v1, s10, v2
		v_add3_u32 v13, v1, v3, v4
		s_add_i32 s11, s10, 0x40000
		v_add_u32_e32 v1, s11, v2
		v_add3_u32 v14, v1, v3, v4
		s_add_i32 s11, s10, 0x80000
		v_add_u32_e32 v1, s11, v2
		v_add3_u32 v15, v1, v3, v4
		s_add_i32 s11, s10, 0xc0000
		v_add_u32_e32 v1, s11, v2
		v_add3_u32 v16, v1, v3, v4
		v_add3_u32 v1, s10, 64, v2
		v_add3_u32 v17, v1, v3, v4
		s_add_i32 s11, s10, 0x40040
		v_add_u32_e32 v1, s11, v2
		v_add3_u32 v18, v1, v3, v4
		s_add_i32 s11, s10, 0x80040
		v_add_u32_e32 v1, s11, v2
		v_add3_u32 v19, v1, v3, v4
		s_add_i32 s11, s10, 0xc0040
		v_add_u32_e32 v1, s11, v2
		v_add3_u32 v20, v1, v3, v4
		s_lshr_b32 s11, s8, 6
		s_lshl_b32 s15, s11, 10
		s_add_i32 s28, s15, 0x1000
		s_add_i32 s29, s15, 0x2000
		s_add_i32 s30, s15, 0x3000
		s_add_i32 s31, s15, 0x4000
		s_add_i32 s32, s15, 0x5000
		s_add_i32 s33, s15, 0x6000
		s_add_i32 s34, s15, 0x7000
		s_add_i32 s35, s15, 0x8000
		s_add_i32 s36, s15, 0x9000
		s_add_i32 s37, s15, 0xa000
		s_add_i32 s38, s15, 0xb000
		s_add_i32 s39, s15, 0xc000
		s_add_i32 s40, s15, 0xd000
		s_add_i32 s41, s15, 0xe000
		s_add_i32 s42, s15, 0xf000
		s_mov_b32 m0, s15
		s_nop 0
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v6, s[20:23], 0 offen lds
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v9, s[20:23], 0 offen lds
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v11, s[20:23], 0 offen lds
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v13, s[0:3], 0 offen lds
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v14, s[0:3], 0 offen lds
		s_mov_b32 m0, s37
		s_nop 0
		buffer_load_dwordx4 v15, s[0:3], 0 offen lds
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v16, s[0:3], 0 offen lds
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v17, s[0:3], 0 offen lds
		s_mov_b32 m0, s40
		s_nop 0
		buffer_load_dwordx4 v18, s[0:3], 0 offen lds
		s_mov_b32 m0, s41
		s_nop 0
		buffer_load_dwordx4 v19, s[0:3], 0 offen lds
		s_mov_b32 m0, s42
		s_nop 0
		buffer_load_dwordx4 v20, s[0:3], 0 offen lds
		s_lshl_b32 s43, s14, 16
		s_add_i32 s44, s9, s43
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v5, 10, v1
		s_mov_b32 s45, 0
		scratch_store_dword off, v5, s45 offset:108
		v_accvgpr_read_b32 v5, a1
		v_lshlrev_b32_e32 v6, 4, v5
		s_mov_b32 s45, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v5, off, s45 offset:108
		s_waitcnt vmcnt(0)
		v_add3_u32 v7, s44, v5, v6
		s_lshr_b32 s45, s8, 7
		s_lshl_b32 s8, s45, 10
		v_accvgpr_read_b32 v5, a0
		v_and_b32_e32 v8, 1, v5
		v_lshlrev_b32_e32 v5, 10, v8
		s_mov_b32 s45, 0
		scratch_store_dword off, v5, s45 offset:104
		s_mov_b32 s45, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v5, off, s45 offset:104
		s_waitcnt vmcnt(0)
		v_add3_u32 v9, s44, v6, v5
		s_and_b32 s44, s11, 1
		s_lshl_b32 s11, s44, 10
		s_add_i32 s44, s11, 0x800
		s_add_i32 m0, s8, 0x20000
		s_nop 0
		buffer_load_dwordx4 v7, s[4:7], 0 offen lds
		s_add_i32 m0, s11, 0x20800
		s_nop 0
		buffer_load_dwordx4 v9, s[24:27], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v5, 13, v1
		s_mov_b32 s45, 0
		scratch_store_dword off, v5, s45 offset:100
		v_and_b32_e32 v1, 15, v0
		v_lshlrev_b32_e32 v5, 6, v1
		s_mov_b32 s45, 0
		scratch_store_dword off, v5, s45 offset:520
		v_accvgpr_read_b32 v5, a1
		v_lshrrev_b32_e32 v7, 4, v5
		v_lshrrev_b32_e32 v5, 1, v1
		v_and_b32_e32 v1, 3, v5
		v_xor_b32_e32 v5, v7, v1
		v_lshlrev_b32_e32 v1, 4, v5
		s_mov_b32 s45, 0
		scratch_store_dword off, v1, s45 offset:516
		s_mov_b32 s45, 0
		s_waitcnt vmcnt(2)
		scratch_load_dword v1, off, s45 offset:100
		s_mov_b32 s45, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v5, off, s45 offset:516
		s_mov_b32 s45, 0
		scratch_load_dword v7, off, s45 offset:520
		s_waitcnt vmcnt(0)
		v_add3_u32 v9, v1, v7, v5
		ds_read_b128 v[12:15], v9
		ds_read_b128 v[16:19], v9 offset:1024
		ds_read_b128 v[20:23], v9 offset:2048
		ds_read_b128 v[24:27], v9 offset:3072
		ds_read_b128 v[28:31], v9 offset:4096
		ds_read_b128 v[32:35], v9 offset:5120
		ds_read_b128 v[36:39], v9 offset:6144
		ds_read_b128 v[40:43], v9 offset:7168
		v_lshlrev_b32_e32 v1, 13, v8
		s_mov_b32 s45, 0
		scratch_store_dword off, v1, s45 offset:96
		s_mov_b32 s45, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v1, off, s45 offset:96
		s_mov_b32 s45, 0
		scratch_load_dword v5, off, s45 offset:516
		s_mov_b32 s45, 0
		scratch_load_dword v7, off, s45 offset:520
		s_waitcnt vmcnt(0)
		v_add3_u32 v8, v7, v1, v5
		ds_read_b128 v[44:47], v8 offset:32768
		ds_read_b128 v[48:51], v8 offset:33792
		ds_read_b128 v[52:55], v8 offset:34816
		ds_read_b128 v[56:59], v8 offset:35840
		ds_read_b128 v[60:63], v8 offset:36864
		ds_read_b128 v[64:67], v8 offset:37888
		ds_read_b128 v[68:71], v8 offset:38912
		ds_read_b128 v[72:75], v8 offset:39936
		s_mov_b32 s45, 0
		scratch_load_dword v1, off, s45 offset:108
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v5, 0x20000, v1
		v_accvgpr_read_b32 v1, a1
		v_lshlrev_b32_e32 v7, 2, v1
		s_mov_b32 s45, 0
		scratch_store_dword off, v7, s45 offset:512
		s_mov_b32 s45, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v1, off, s45 offset:512
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v7, v5, v1
		ds_read_b32 v1, v7
		ds_read_b32 v5, v7 offset:256
		ds_read_b32 v8, v7 offset:512
		ds_read_b32 v9, v7 offset:768
		s_mov_b32 s45, 0
		scratch_load_dword v7, off, s45 offset:512
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v10, 0x20000, v7
		s_mov_b32 s45, 0
		scratch_load_dword v7, off, s45 offset:104
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v11, v10, v7
		ds_read_b32 v7, v11 offset:2048
		ds_read_b32 v10, v11 offset:2304
		ds_read_b32 v76, v11 offset:2560
		ds_read_b32 v77, v11 offset:2816
		s_waitcnt lgkmcnt(0)
		s_add_i32 s45, s9, 0x80
		v_add_u32_e32 v11, s45, v2
		v_add3_u32 v78, v11, v3, v4
		s_add_i32 s45, s9, 0x40080
		v_add_u32_e32 v11, s45, v2
		v_add3_u32 v79, v11, v3, v4
		s_add_i32 s45, s9, 0x80080
		v_add_u32_e32 v11, s45, v2
		v_add3_u32 v80, v11, v3, v4
		s_add_i32 s45, s9, 0xc0080
		v_add_u32_e32 v11, s45, v2
		v_add3_u32 v81, v11, v3, v4
		s_add_i32 s45, s9, 0xc0
		v_add_u32_e32 v11, s45, v2
		v_add3_u32 v82, v11, v3, v4
		s_add_i32 s45, s9, 0x400c0
		v_add_u32_e32 v11, s45, v2
		v_add3_u32 v83, v11, v3, v4
		s_add_i32 s45, s9, 0x800c0
		v_add_u32_e32 v11, s45, v2
		v_add3_u32 v84, v11, v3, v4
		s_add_i32 s45, s9, 0xc00c0
		v_add_u32_e32 v11, s45, v2
		v_add3_u32 v85, v11, v3, v4
		s_add_i32 s45, s10, 0x80
		v_add_u32_e32 v11, s45, v2
		v_add3_u32 v86, v11, v3, v4
		s_add_i32 s45, s10, 0x40080
		v_add_u32_e32 v11, s45, v2
		v_add3_u32 v87, v11, v3, v4
		s_add_i32 s45, s10, 0x80080
		v_add_u32_e32 v11, s45, v2
		v_add3_u32 v88, v11, v3, v4
		s_add_i32 s45, s10, 0xc0080
		v_add_u32_e32 v11, s45, v2
		v_add3_u32 v89, v11, v3, v4
		s_add_i32 s45, s10, 0xc0
		v_add_u32_e32 v11, s45, v2
		v_add3_u32 v90, v11, v3, v4
		s_add_i32 s45, s10, 0x400c0
		v_add_u32_e32 v11, s45, v2
		v_add3_u32 v91, v11, v3, v4
		s_add_i32 s45, s10, 0x800c0
		v_add_u32_e32 v11, s45, v2
		v_add3_u32 v92, v11, v3, v4
		s_add_i32 s45, s10, 0xc00c0
		v_add_u32_e32 v11, s45, v2
		v_add3_u32 v2, v11, v3, v4
		s_add_i32 s10, s15, 0x10000
		s_add_i32 s45, s15, 0x11000
		s_add_i32 s46, s15, 0x12000
		s_add_i32 s47, s15, 0x13000
		s_add_i32 s48, s15, 0x14000
		s_add_i32 s49, s15, 0x15000
		s_add_i32 s50, s15, 0x16000
		s_add_i32 s51, s15, 0x17000
		s_add_i32 s52, s15, 0x18000
		s_add_i32 s53, s15, 0x19000
		s_add_i32 s54, s15, 0x1a000
		s_add_i32 s55, s15, 0x1b000
		s_add_i32 s56, s15, 0x1c000
		s_add_i32 s57, s15, 0x1d000
		s_add_i32 s58, s15, 0x1e000
		s_add_i32 s59, s15, 0x1f000
		s_mov_b32 m0, s10
		s_nop 0
		buffer_load_dwordx4 v78, s[20:23], 0 offen lds
		s_mov_b32 m0, s45
		s_nop 0
		buffer_load_dwordx4 v79, s[20:23], 0 offen lds
		s_mov_b32 m0, s46
		s_nop 0
		buffer_load_dwordx4 v80, s[20:23], 0 offen lds
		s_mov_b32 m0, s47
		s_nop 0
		buffer_load_dwordx4 v81, s[20:23], 0 offen lds
		s_mov_b32 m0, s48
		s_nop 0
		buffer_load_dwordx4 v82, s[20:23], 0 offen lds
		s_mov_b32 m0, s49
		s_nop 0
		buffer_load_dwordx4 v83, s[20:23], 0 offen lds
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v84, s[20:23], 0 offen lds
		s_mov_b32 m0, s51
		s_nop 0
		buffer_load_dwordx4 v85, s[20:23], 0 offen lds
		s_mov_b32 m0, s52
		s_nop 0
		buffer_load_dwordx4 v86, s[0:3], 0 offen lds
		s_mov_b32 m0, s53
		s_nop 0
		buffer_load_dwordx4 v87, s[0:3], 0 offen lds
		s_mov_b32 m0, s54
		s_nop 0
		buffer_load_dwordx4 v88, s[0:3], 0 offen lds
		s_mov_b32 m0, s55
		s_nop 0
		buffer_load_dwordx4 v89, s[0:3], 0 offen lds
		s_mov_b32 m0, s56
		s_nop 0
		buffer_load_dwordx4 v90, s[0:3], 0 offen lds
		s_mov_b32 m0, s57
		s_nop 0
		buffer_load_dwordx4 v91, s[0:3], 0 offen lds
		s_mov_b32 m0, s58
		s_nop 0
		buffer_load_dwordx4 v92, s[0:3], 0 offen lds
		s_mov_b32 m0, s59
		s_nop 0
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_add_i32 s60, s9, 0x800
		s_add_i32 s9, s60, s43
		s_mov_b32 s43, 0
		scratch_load_dword v2, off, s43 offset:108
		s_waitcnt vmcnt(0)
		v_add3_u32 v3, s9, v2, v6
		s_add_i32 s43, s8, 0x1000
		s_mov_b32 s60, 0
		scratch_load_dword v2, off, s60 offset:104
		s_waitcnt vmcnt(0)
		v_add3_u32 v4, s9, v6, v2
		s_add_i32 s9, s11, 0x1800
		s_add_i32 m0, s8, 0x21000
		s_nop 0
		buffer_load_dwordx4 v3, s[4:7], 0 offen lds
		s_add_i32 m0, s11, 0x21800
		s_nop 0
		buffer_load_dwordx4 v4, s[24:27], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s11, s12, 1
		s_mov_b32 s60, 2
		v_mov_b32_e32 v2, s13
		v_mov_b32_e32 v3, 0
		s_mov_b32 s62, 0x100000
		s_mov_b32 s63, 0
		v_mov_b32_e32 v78, s62
		v_mov_b32_e32 v79, s63
		v_mul_lo_u32 v80, v78, v2
		v_mul_hi_u32 v81, v78, v2
		v_mul_lo_u32 v4, v78, v3
		v_add_u32_e32 v81, v81, v4
		v_mul_lo_u32 v4, v79, v2
		v_add_u32_e32 v81, v81, v4
		s_mov_b32 s62, 1
		s_mov_b32 s63, 0
		v_mov_b32_e32 v82, v0
		v_mov_b32_e32 v83, 0
		v_mov_b32_e32 v84, s62
		v_mov_b32_e32 v85, s63
		v_mul_lo_u32 v86, v84, v82
		v_mul_hi_u32 v87, v84, v82
		v_mul_lo_u32 v2, v84, v83
		v_add_u32_e32 v87, v87, v2
		v_mul_lo_u32 v2, v85, v82
		v_add_u32_e32 v87, v87, v2
		v_lshrrev_b64 v[88:89], 6, v[86:87]
		s_mov_b32 s62, 0x10000
		s_mov_b32 s63, 0
		v_mov_b32_e32 v90, s62
		v_mov_b32_e32 v91, s63
		v_mul_lo_u32 v92, v90, v88
		v_mul_hi_u32 v93, v90, v88
		v_mul_lo_u32 v2, v90, v89
		v_add_u32_e32 v93, v93, v2
		v_mul_lo_u32 v2, v91, v88
		v_add_u32_e32 v93, v93, v2
		v_add_co_u32_e64 v94, vcc, v80, v92
		v_addc_co_u32_e64 v95, vcc, v81, v93, vcc
		v_mov_b32_e32 v2, 63
		v_and_b32_e32 v96, v82, v2
		v_and_b32_e32 v97, v3, v3
		v_mul_lo_u32 v82, v84, v96
		v_mul_hi_u32 v83, v84, v96
		v_mul_lo_u32 v2, v84, v97
		v_add_u32_e32 v83, v83, v2
		v_mul_lo_u32 v2, v85, v96
		v_add_u32_e32 v83, v83, v2
		v_lshrrev_b64 v[84:85], 2, v[82:83]
		s_mov_b32 s62, 0x1000
		s_mov_b32 s63, 0
		v_mov_b32_e32 v98, s62
		v_mov_b32_e32 v99, s63
		v_mul_lo_u32 v100, v98, v84
		v_mul_hi_u32 v101, v98, v84
		v_mul_lo_u32 v2, v98, v85
		v_add_u32_e32 v101, v101, v2
		v_mul_lo_u32 v2, v99, v84
		v_add_u32_e32 v101, v101, v2
		v_add_co_u32_e64 v84, vcc, v94, v100
		v_addc_co_u32_e64 v85, vcc, v95, v101, vcc
		v_lshrrev_b64 v[94:95], 3, v[82:83]
		v_mov_b32_e32 v2, 3
		v_and_b32_e32 v82, v94, v2
		v_and_b32_e32 v83, v95, v3
		v_and_b32_e32 v94, v96, v2
		v_and_b32_e32 v95, v97, v3
		v_xor_b32_e32 v98, v82, v94
		v_xor_b32_e32 v99, v83, v95
		s_mov_b32 s62, 16
		s_mov_b32 s63, 0
		v_mov_b32_e32 v82, s62
		v_mov_b32_e32 v83, s63
		v_mul_lo_u32 v94, v82, v98
		v_mul_hi_u32 v95, v82, v98
		v_mul_lo_u32 v2, v82, v99
		v_add_u32_e32 v95, v95, v2
		v_mul_lo_u32 v2, v83, v98
		v_add_u32_e32 v95, v95, v2
		v_add_co_u32_e64 v98, vcc, v84, v94
		v_addc_co_u32_e64 v99, vcc, v85, v95, vcc
		v_accvgpr_write_b32 a2, v98
		v_accvgpr_write_b32 a3, v99
		s_mov_b32 s62, 0x80
		s_mov_b32 s63, 0
		v_mov_b32_e32 v84, s62
		v_mov_b32_e32 v85, s63
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v4, 0x22000, v2
		ds_write_b32 v4, v84
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v4, 0x22400, v2
		ds_write_b32 v4, v85
		v_mov_b32_e32 v2, 0x40000
		v_add_co_u32_e64 v84, vcc, v80, v2
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
		v_mov_b32_e32 v6, 0xc0000
		v_add_co_u32_e64 v84, vcc, v80, v6
		v_addc_co_u32_e64 v85, vcc, v81, 0, vcc
		v_add_co_u32_e64 v104, vcc, v84, v92
		v_addc_co_u32_e64 v105, vcc, v85, v93, vcc
		v_add_co_u32_e64 v84, vcc, v104, v100
		v_addc_co_u32_e64 v85, vcc, v105, v101, vcc
		v_add_co_u32_e64 v104, vcc, v84, v94
		v_addc_co_u32_e64 v105, vcc, v85, v95, vcc
		v_mov_b32_e32 v11, 64
		v_add_co_u32_e64 v84, vcc, v80, v11
		v_addc_co_u32_e64 v85, vcc, v81, 0, vcc
		v_add_co_u32_e64 v106, vcc, v84, v92
		v_addc_co_u32_e64 v107, vcc, v85, v93, vcc
		v_add_co_u32_e64 v84, vcc, v106, v100
		v_addc_co_u32_e64 v85, vcc, v107, v101, vcc
		v_add_co_u32_e64 v106, vcc, v84, v94
		v_addc_co_u32_e64 v107, vcc, v85, v95, vcc
		v_mov_b32_e32 v84, 0x40040
		v_add_co_u32_e64 v108, vcc, v80, v84
		v_addc_co_u32_e64 v109, vcc, v81, 0, vcc
		v_add_co_u32_e64 v110, vcc, v108, v92
		v_addc_co_u32_e64 v111, vcc, v109, v93, vcc
		v_add_co_u32_e64 v108, vcc, v110, v100
		v_addc_co_u32_e64 v109, vcc, v111, v101, vcc
		v_add_co_u32_e64 v110, vcc, v108, v94
		v_addc_co_u32_e64 v111, vcc, v109, v95, vcc
		v_mov_b32_e32 v85, 0x80040
		v_add_co_u32_e64 v108, vcc, v80, v85
		v_addc_co_u32_e64 v109, vcc, v81, 0, vcc
		v_add_co_u32_e64 v112, vcc, v108, v92
		v_addc_co_u32_e64 v113, vcc, v109, v93, vcc
		v_add_co_u32_e64 v108, vcc, v112, v100
		v_addc_co_u32_e64 v109, vcc, v113, v101, vcc
		v_add_co_u32_e64 v112, vcc, v108, v94
		v_addc_co_u32_e64 v113, vcc, v109, v95, vcc
		v_mov_b32_e32 v108, 0xc0040
		v_add_co_u32_e64 v114, vcc, v80, v108
		v_addc_co_u32_e64 v115, vcc, v81, 0, vcc
		v_add_co_u32_e64 v116, vcc, v114, v92
		v_addc_co_u32_e64 v117, vcc, v115, v93, vcc
		v_add_co_u32_e64 v114, vcc, v116, v100
		v_addc_co_u32_e64 v115, vcc, v117, v101, vcc
		v_add_co_u32_e64 v116, vcc, v114, v94
		v_addc_co_u32_e64 v117, vcc, v115, v95, vcc
		v_mov_b32_e32 v114, s14
		v_mov_b32_e32 v115, 0
		v_mul_lo_u32 v118, v78, v114
		v_mul_hi_u32 v119, v78, v114
		v_mul_lo_u32 v109, v78, v115
		v_add_u32_e32 v119, v119, v109
		v_mul_lo_u32 v109, v79, v114
		v_add_u32_e32 v119, v119, v109
		v_add_co_u32_e64 v78, vcc, v118, v92
		v_addc_co_u32_e64 v79, vcc, v119, v93, vcc
		v_add_co_u32_e64 v120, vcc, v78, v100
		v_addc_co_u32_e64 v121, vcc, v79, v101, vcc
		v_add_co_u32_e64 v78, vcc, v120, v94
		v_addc_co_u32_e64 v79, vcc, v121, v95, vcc
		v_add_co_u32_e64 v120, vcc, v118, v2
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
		v_add_co_u32_e64 v120, vcc, v118, v6
		v_addc_co_u32_e64 v121, vcc, v119, 0, vcc
		v_add_co_u32_e64 v126, vcc, v120, v92
		v_addc_co_u32_e64 v127, vcc, v121, v93, vcc
		v_add_co_u32_e64 v120, vcc, v126, v100
		v_addc_co_u32_e64 v121, vcc, v127, v101, vcc
		v_add_co_u32_e64 v126, vcc, v120, v94
		v_addc_co_u32_e64 v127, vcc, v121, v95, vcc
		v_add_co_u32_e64 v120, vcc, v118, v11
		v_addc_co_u32_e64 v121, vcc, v119, 0, vcc
		v_add_co_u32_e64 v128, vcc, v120, v92
		v_addc_co_u32_e64 v129, vcc, v121, v93, vcc
		v_add_co_u32_e64 v120, vcc, v128, v100
		v_addc_co_u32_e64 v121, vcc, v129, v101, vcc
		v_add_co_u32_e64 v128, vcc, v120, v94
		v_addc_co_u32_e64 v129, vcc, v121, v95, vcc
		v_add_co_u32_e64 v120, vcc, v118, v84
		v_addc_co_u32_e64 v121, vcc, v119, 0, vcc
		v_add_co_u32_e64 v130, vcc, v120, v92
		v_addc_co_u32_e64 v131, vcc, v121, v93, vcc
		v_add_co_u32_e64 v120, vcc, v130, v100
		v_addc_co_u32_e64 v121, vcc, v131, v101, vcc
		v_add_co_u32_e64 v130, vcc, v120, v94
		v_addc_co_u32_e64 v131, vcc, v121, v95, vcc
		v_add_co_u32_e64 v120, vcc, v118, v85
		v_addc_co_u32_e64 v121, vcc, v119, 0, vcc
		v_add_co_u32_e64 v84, vcc, v120, v92
		v_addc_co_u32_e64 v85, vcc, v121, v93, vcc
		v_add_co_u32_e64 v120, vcc, v84, v100
		v_addc_co_u32_e64 v121, vcc, v85, v101, vcc
		v_add_co_u32_e64 v84, vcc, v120, v94
		v_addc_co_u32_e64 v85, vcc, v121, v95, vcc
		v_add_co_u32_e64 v120, vcc, v118, v108
		v_addc_co_u32_e64 v121, vcc, v119, 0, vcc
		v_add_co_u32_e64 v108, vcc, v120, v92
		v_addc_co_u32_e64 v109, vcc, v121, v93, vcc
		v_add_co_u32_e64 v120, vcc, v108, v100
		v_addc_co_u32_e64 v121, vcc, v109, v101, vcc
		v_add_co_u32_e64 v108, vcc, v120, v94
		v_addc_co_u32_e64 v109, vcc, v121, v95, vcc
		v_mul_lo_u32 v120, v90, v114
		v_mul_hi_u32 v121, v90, v114
		v_mul_lo_u32 v2, v90, v115
		v_add_u32_e32 v121, v121, v2
		v_mul_lo_u32 v2, v91, v114
		v_add_u32_e32 v121, v121, v2
		v_add_co_u32_e64 v90, vcc, v80, v120
		v_addc_co_u32_e64 v91, vcc, v81, v121, vcc
		v_lshrrev_b64 v[114:115], 7, v[86:87]
		s_mov_b32 s64, 0x400
		s_mov_b32 s65, 0
		v_mov_b32_e32 v86, s64
		v_mov_b32_e32 v87, s65
		v_mul_lo_u32 v132, v86, v114
		v_mul_hi_u32 v133, v86, v114
		v_mul_lo_u32 v2, v86, v115
		v_add_u32_e32 v133, v133, v2
		v_mul_lo_u32 v2, v87, v114
		v_add_u32_e32 v133, v133, v2
		v_add_co_u32_e64 v114, vcc, v90, v132
		v_addc_co_u32_e64 v115, vcc, v91, v133, vcc
		v_mul_lo_u32 v134, v82, v96
		v_mul_hi_u32 v135, v82, v96
		v_mul_lo_u32 v2, v82, v97
		v_add_u32_e32 v135, v135, v2
		v_mul_lo_u32 v2, v83, v96
		v_add_u32_e32 v135, v135, v2
		v_add_co_u32_e64 v82, vcc, v114, v134
		v_addc_co_u32_e64 v83, vcc, v115, v135, vcc
		s_mov_b32 s64, 0x800
		s_mov_b32 s65, 0
		v_mov_b32_e32 v96, s64
		v_mov_b32_e32 v97, s65
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v4, 0x22800, v2
		ds_write_b32 v4, v96
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v4, 0x22c00, v2
		ds_write_b32 v4, v97
		v_add_co_u32_e64 v96, vcc, v90, v134
		v_addc_co_u32_e64 v97, vcc, v91, v135, vcc
		v_mov_b32_e32 v2, 1
		v_and_b32_e32 v90, v88, v2
		v_and_b32_e32 v91, v89, v3
		v_mul_lo_u32 v2, v86, v90
		v_mul_hi_u32 v3, v86, v90
		v_mul_lo_u32 v4, v86, v91
		v_add_u32_e32 v3, v3, v4
		v_mul_lo_u32 v4, v87, v90
		v_add_u32_e32 v3, v3, v4
		v_add_co_u32_e64 v86, vcc, v96, v2
		v_addc_co_u32_e64 v87, vcc, v97, v3, vcc
		v_mov_b32_e32 v4, 0x80
		v_add_co_u32_e64 v88, vcc, v80, v4
		v_addc_co_u32_e64 v89, vcc, v81, 0, vcc
		v_add_co_u32_e64 v90, vcc, v88, v92
		v_addc_co_u32_e64 v91, vcc, v89, v93, vcc
		v_add_co_u32_e64 v88, vcc, v90, v100
		v_addc_co_u32_e64 v89, vcc, v91, v101, vcc
		v_add_co_u32_e64 v90, vcc, v88, v94
		v_addc_co_u32_e64 v91, vcc, v89, v95, vcc
		v_lshlrev_b32_e32 v6, 2, v0
		v_add_u32_e32 v11, 0x23000, v6
		ds_write_b32 v11, v90
		v_lshlrev_b32_e32 v6, 2, v0
		v_add_u32_e32 v11, 0x23400, v6
		ds_write_b32 v11, v91
		v_mov_b32_e32 v6, 0x40080
		v_add_co_u32_e64 v88, vcc, v80, v6
		v_addc_co_u32_e64 v89, vcc, v81, 0, vcc
		v_add_co_u32_e64 v90, vcc, v88, v92
		v_addc_co_u32_e64 v91, vcc, v89, v93, vcc
		v_add_co_u32_e64 v88, vcc, v90, v100
		v_addc_co_u32_e64 v89, vcc, v91, v101, vcc
		v_add_co_u32_e64 v90, vcc, v88, v94
		v_addc_co_u32_e64 v91, vcc, v89, v95, vcc
		v_lshlrev_b32_e32 v11, 2, v0
		v_add_u32_e32 v88, 0x23800, v11
		ds_write_b32 v88, v90
		v_lshlrev_b32_e32 v11, 2, v0
		v_add_u32_e32 v88, 0x23c00, v11
		ds_write_b32 v88, v91
		v_mov_b32_e32 v11, 0x80080
		v_add_co_u32_e64 v88, vcc, v80, v11
		v_addc_co_u32_e64 v89, vcc, v81, 0, vcc
		v_add_co_u32_e64 v90, vcc, v88, v92
		v_addc_co_u32_e64 v91, vcc, v89, v93, vcc
		v_add_co_u32_e64 v88, vcc, v90, v100
		v_addc_co_u32_e64 v89, vcc, v91, v101, vcc
		v_add_co_u32_e64 v90, vcc, v88, v94
		v_addc_co_u32_e64 v91, vcc, v89, v95, vcc
		v_lshlrev_b32_e32 v88, 2, v0
		v_add_u32_e32 v89, 0x24000, v88
		ds_write_b32 v89, v90
		v_lshlrev_b32_e32 v88, 2, v0
		v_add_u32_e32 v89, 0x24400, v88
		ds_write_b32 v89, v91
		v_mov_b32_e32 v88, 0xc0080
		v_add_co_u32_e64 v90, vcc, v80, v88
		v_addc_co_u32_e64 v91, vcc, v81, 0, vcc
		v_add_co_u32_e64 v96, vcc, v90, v92
		v_addc_co_u32_e64 v97, vcc, v91, v93, vcc
		v_add_co_u32_e64 v90, vcc, v96, v100
		v_addc_co_u32_e64 v91, vcc, v97, v101, vcc
		v_add_co_u32_e64 v96, vcc, v90, v94
		v_addc_co_u32_e64 v97, vcc, v91, v95, vcc
		v_lshlrev_b32_e32 v89, 2, v0
		v_add_u32_e32 v90, 0x24800, v89
		ds_write_b32 v90, v96
		v_lshlrev_b32_e32 v89, 2, v0
		v_add_u32_e32 v90, 0x24c00, v89
		ds_write_b32 v90, v97
		v_mov_b32_e32 v89, 0xc0
		v_add_co_u32_e64 v90, vcc, v80, v89
		v_addc_co_u32_e64 v91, vcc, v81, 0, vcc
		v_add_co_u32_e64 v96, vcc, v90, v92
		v_addc_co_u32_e64 v97, vcc, v91, v93, vcc
		v_add_co_u32_e64 v90, vcc, v96, v100
		v_addc_co_u32_e64 v91, vcc, v97, v101, vcc
		v_add_co_u32_e64 v96, vcc, v90, v94
		v_addc_co_u32_e64 v97, vcc, v91, v95, vcc
		v_lshlrev_b32_e32 v90, 2, v0
		v_add_u32_e32 v91, 0x25000, v90
		ds_write_b32 v91, v96
		v_lshlrev_b32_e32 v90, 2, v0
		v_add_u32_e32 v91, 0x25400, v90
		ds_write_b32 v91, v97
		v_mov_b32_e32 v90, 0x400c0
		v_add_co_u32_e64 v96, vcc, v80, v90
		v_addc_co_u32_e64 v97, vcc, v81, 0, vcc
		v_add_co_u32_e64 v114, vcc, v96, v92
		v_addc_co_u32_e64 v115, vcc, v97, v93, vcc
		v_add_co_u32_e64 v96, vcc, v114, v100
		v_addc_co_u32_e64 v97, vcc, v115, v101, vcc
		v_add_co_u32_e64 v114, vcc, v96, v94
		v_addc_co_u32_e64 v115, vcc, v97, v95, vcc
		v_lshlrev_b32_e32 v91, 2, v0
		v_add_u32_e32 v96, 0x25800, v91
		ds_write_b32 v96, v114
		v_lshlrev_b32_e32 v91, 2, v0
		v_add_u32_e32 v96, 0x25c00, v91
		ds_write_b32 v96, v115
		v_mov_b32_e32 v91, 0x800c0
		v_add_co_u32_e64 v96, vcc, v80, v91
		v_addc_co_u32_e64 v97, vcc, v81, 0, vcc
		v_add_co_u32_e64 v114, vcc, v96, v92
		v_addc_co_u32_e64 v115, vcc, v97, v93, vcc
		v_add_co_u32_e64 v96, vcc, v114, v100
		v_addc_co_u32_e64 v97, vcc, v115, v101, vcc
		v_add_co_u32_e64 v114, vcc, v96, v94
		v_addc_co_u32_e64 v115, vcc, v97, v95, vcc
		v_lshlrev_b32_e32 v96, 2, v0
		v_add_u32_e32 v97, 0x26000, v96
		ds_write_b32 v97, v114
		v_lshlrev_b32_e32 v96, 2, v0
		v_add_u32_e32 v97, 0x26400, v96
		ds_write_b32 v97, v115
		v_mov_b32_e32 v96, 0xc00c0
		v_add_co_u32_e64 v114, vcc, v80, v96
		v_addc_co_u32_e64 v115, vcc, v81, 0, vcc
		v_add_co_u32_e64 v136, vcc, v114, v92
		v_addc_co_u32_e64 v137, vcc, v115, v93, vcc
		v_add_co_u32_e64 v114, vcc, v136, v100
		v_addc_co_u32_e64 v115, vcc, v137, v101, vcc
		v_add_co_u32_e64 v136, vcc, v114, v94
		v_addc_co_u32_e64 v137, vcc, v115, v95, vcc
		v_lshlrev_b32_e32 v97, 2, v0
		v_add_u32_e32 v114, 0x26800, v97
		ds_write_b32 v114, v136
		v_lshlrev_b32_e32 v97, 2, v0
		v_add_u32_e32 v114, 0x26c00, v97
		ds_write_b32 v114, v137
		v_add_co_u32_e64 v114, vcc, v118, v4
		v_addc_co_u32_e64 v115, vcc, v119, 0, vcc
		v_add_co_u32_e64 v136, vcc, v114, v92
		v_addc_co_u32_e64 v137, vcc, v115, v93, vcc
		v_add_co_u32_e64 v114, vcc, v136, v100
		v_addc_co_u32_e64 v115, vcc, v137, v101, vcc
		v_add_co_u32_e64 v136, vcc, v114, v94
		v_addc_co_u32_e64 v137, vcc, v115, v95, vcc
		v_lshlrev_b32_e32 v4, 2, v0
		v_add_u32_e32 v97, 0x27000, v4
		ds_write_b32 v97, v136
		v_lshlrev_b32_e32 v4, 2, v0
		v_add_u32_e32 v97, 0x27400, v4
		ds_write_b32 v97, v137
		v_add_co_u32_e64 v114, vcc, v118, v6
		v_addc_co_u32_e64 v115, vcc, v119, 0, vcc
		v_add_co_u32_e64 v136, vcc, v114, v92
		v_addc_co_u32_e64 v137, vcc, v115, v93, vcc
		v_add_co_u32_e64 v114, vcc, v136, v100
		v_addc_co_u32_e64 v115, vcc, v137, v101, vcc
		v_add_co_u32_e64 v136, vcc, v114, v94
		v_addc_co_u32_e64 v137, vcc, v115, v95, vcc
		v_lshlrev_b32_e32 v4, 2, v0
		v_add_u32_e32 v6, 0x27800, v4
		ds_write_b32 v6, v136
		v_lshlrev_b32_e32 v4, 2, v0
		v_add_u32_e32 v6, 0x27c00, v4
		ds_write_b32 v6, v137
		v_add_co_u32_e64 v114, vcc, v118, v11
		v_addc_co_u32_e64 v115, vcc, v119, 0, vcc
		v_add_co_u32_e64 v136, vcc, v114, v92
		v_addc_co_u32_e64 v137, vcc, v115, v93, vcc
		v_add_co_u32_e64 v114, vcc, v136, v100
		v_addc_co_u32_e64 v115, vcc, v137, v101, vcc
		v_add_co_u32_e64 v136, vcc, v114, v94
		v_addc_co_u32_e64 v137, vcc, v115, v95, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v136, s61
		scratch_store_dword off, v137, s61 offset:4
		v_add_co_u32_e64 v114, vcc, v118, v88
		v_addc_co_u32_e64 v115, vcc, v119, 0, vcc
		v_add_co_u32_e64 v136, vcc, v114, v92
		v_addc_co_u32_e64 v137, vcc, v115, v93, vcc
		v_add_co_u32_e64 v114, vcc, v136, v100
		v_addc_co_u32_e64 v115, vcc, v137, v101, vcc
		v_add_co_u32_e64 v136, vcc, v114, v94
		v_addc_co_u32_e64 v137, vcc, v115, v95, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v136, s61 offset:8
		scratch_store_dword off, v137, s61 offset:12
		v_add_co_u32_e64 v114, vcc, v118, v89
		v_addc_co_u32_e64 v115, vcc, v119, 0, vcc
		v_add_co_u32_e64 v88, vcc, v114, v92
		v_addc_co_u32_e64 v89, vcc, v115, v93, vcc
		v_add_co_u32_e64 v114, vcc, v88, v100
		v_addc_co_u32_e64 v115, vcc, v89, v101, vcc
		v_add_co_u32_e64 v88, vcc, v114, v94
		v_addc_co_u32_e64 v89, vcc, v115, v95, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v88, s61 offset:16
		scratch_store_dword off, v89, s61 offset:20
		v_add_co_u32_e64 v88, vcc, v118, v90
		v_addc_co_u32_e64 v89, vcc, v119, 0, vcc
		v_add_co_u32_e64 v114, vcc, v88, v92
		v_addc_co_u32_e64 v115, vcc, v89, v93, vcc
		v_add_co_u32_e64 v88, vcc, v114, v100
		v_addc_co_u32_e64 v89, vcc, v115, v101, vcc
		v_add_co_u32_e64 v114, vcc, v88, v94
		v_addc_co_u32_e64 v115, vcc, v89, v95, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v114, s61 offset:24
		scratch_store_dword off, v115, s61 offset:28
		v_add_co_u32_e64 v88, vcc, v118, v91
		v_addc_co_u32_e64 v89, vcc, v119, 0, vcc
		v_add_co_u32_e64 v90, vcc, v88, v92
		v_addc_co_u32_e64 v91, vcc, v89, v93, vcc
		v_add_co_u32_e64 v88, vcc, v90, v100
		v_addc_co_u32_e64 v89, vcc, v91, v101, vcc
		v_add_co_u32_e64 v90, vcc, v88, v94
		v_addc_co_u32_e64 v91, vcc, v89, v95, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v90, s61 offset:32
		scratch_store_dword off, v91, s61 offset:36
		v_add_co_u32_e64 v88, vcc, v118, v96
		v_addc_co_u32_e64 v89, vcc, v119, 0, vcc
		v_add_co_u32_e64 v90, vcc, v88, v92
		v_addc_co_u32_e64 v91, vcc, v89, v93, vcc
		v_add_co_u32_e64 v88, vcc, v90, v100
		v_addc_co_u32_e64 v89, vcc, v91, v101, vcc
		v_add_co_u32_e64 v90, vcc, v88, v94
		v_addc_co_u32_e64 v91, vcc, v89, v95, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v90, s61 offset:40
		scratch_store_dword off, v91, s61 offset:44
		v_mov_b32_e32 v4, 0x800
		v_add_co_u32_e64 v88, vcc, v80, v4
		v_addc_co_u32_e64 v89, vcc, v81, 0, vcc
		v_add_co_u32_e64 v80, vcc, v88, v120
		v_addc_co_u32_e64 v81, vcc, v89, v121, vcc
		v_add_co_u32_e64 v88, vcc, v80, v132
		v_addc_co_u32_e64 v89, vcc, v81, v133, vcc
		v_add_co_u32_e64 v90, vcc, v88, v134
		v_addc_co_u32_e64 v91, vcc, v89, v135, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v90, s61 offset:48
		scratch_store_dword off, v91, s61 offset:52
		v_add_co_u32_e64 v88, vcc, v80, v134
		v_addc_co_u32_e64 v89, vcc, v81, v135, vcc
		v_add_co_u32_e64 v80, vcc, v88, v2
		v_addc_co_u32_e64 v81, vcc, v89, v3, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v80, s61 offset:56
		scratch_store_dword off, v81, s61 offset:60
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
		v_mov_b32_e32 v2, s60
		v_mov_b32_e32 v3, 0
		v_lshlrev_b32_e32 v4, 2, v0
		v_add_u32_e32 v6, 0x22000, v4
		s_waitcnt lgkmcnt(6)
		ds_read_b32 v80, v6
		v_lshlrev_b32_e32 v4, 2, v0
		v_add_u32_e32 v6, 0x22400, v4
		ds_read_b32 v81, v6
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v88, v80, v2
		v_mul_hi_u32 v89, v80, v2
		v_mul_lo_u32 v4, v80, v3
		v_add_u32_e32 v89, v89, v4
		v_mul_lo_u32 v4, v81, v2
		v_add_u32_e32 v89, v89, v4
		v_accvgpr_read_b32 v80, a2
		v_accvgpr_read_b32 v81, a3
		v_add_co_u32_e64 v90, vcc, v80, v88
		v_addc_co_u32_e64 v91, vcc, v81, v89, vcc
		v_add_co_u32_e64 v80, vcc, v98, v88
		v_addc_co_u32_e64 v81, vcc, v99, v89, vcc
		v_add_co_u32_e64 v92, vcc, v102, v88
		v_addc_co_u32_e64 v93, vcc, v103, v89, vcc
		v_add_co_u32_e64 v94, vcc, v104, v88
		v_addc_co_u32_e64 v95, vcc, v105, v89, vcc
		v_add_co_u32_e64 v96, vcc, v106, v88
		v_addc_co_u32_e64 v97, vcc, v107, v89, vcc
		v_add_co_u32_e64 v100, vcc, v110, v88
		v_addc_co_u32_e64 v101, vcc, v111, v89, vcc
		v_add_co_u32_e64 v114, vcc, v112, v88
		v_addc_co_u32_e64 v115, vcc, v113, v89, vcc
		v_add_co_u32_e64 v118, vcc, v116, v88
		v_addc_co_u32_e64 v119, vcc, v117, v89, vcc
		v_add_co_u32_e64 v120, vcc, v78, v88
		v_addc_co_u32_e64 v121, vcc, v79, v89, vcc
		v_add_co_u32_e64 v132, vcc, v122, v88
		v_addc_co_u32_e64 v133, vcc, v123, v89, vcc
		v_add_co_u32_e64 v134, vcc, v124, v88
		v_addc_co_u32_e64 v135, vcc, v125, v89, vcc
		v_add_co_u32_e64 v136, vcc, v126, v88
		v_addc_co_u32_e64 v137, vcc, v127, v89, vcc
		v_add_co_u32_e64 v138, vcc, v128, v88
		v_addc_co_u32_e64 v139, vcc, v129, v89, vcc
		v_add_co_u32_e64 v140, vcc, v130, v88
		v_addc_co_u32_e64 v141, vcc, v131, v89, vcc
		v_add_co_u32_e64 v142, vcc, v84, v88
		v_addc_co_u32_e64 v143, vcc, v85, v89, vcc
		v_add_co_u32_e64 v144, vcc, v108, v88
		v_addc_co_u32_e64 v145, vcc, v109, v89, vcc
		v_lshlrev_b32_e32 v4, 2, v0
		v_add_u32_e32 v6, 0x22800, v4
		ds_read_b32 v88, v6
		v_lshlrev_b32_e32 v4, 2, v0
		v_add_u32_e32 v6, 0x22c00, v4
		ds_read_b32 v89, v6
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v146, v88, v2
		v_mul_hi_u32 v147, v88, v2
		v_mul_lo_u32 v4, v88, v3
		v_add_u32_e32 v147, v147, v4
		v_mul_lo_u32 v4, v89, v2
		v_add_u32_e32 v147, v147, v4
		v_add_co_u32_e64 v2, vcc, v82, v146
		v_addc_co_u32_e64 v3, vcc, v83, v147, vcc
		v_add_co_u32_e64 v88, vcc, v86, v146
		v_addc_co_u32_e64 v89, vcc, v87, v147, vcc
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v148, off, s61 offset:112
		scratch_load_dword v149, off, s61 offset:116
		scratch_load_dword v150, off, s61 offset:120
		scratch_load_dword v151, off, s61 offset:124
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[12:15], v[44:47], v[148:151], v1, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s61, s60, 1
		s_lshl_b32 s66, s61, 16
		s_mov_b32 s67, 0
		scratch_load_dword v3, off, s67 offset:100
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v4, s66, v3
		s_mov_b32 s67, 0
		scratch_load_dword v3, off, s67 offset:516
		s_mov_b32 s67, 0
		scratch_load_dword v6, off, s67 offset:520
		s_waitcnt vmcnt(0)
		v_add3_u32 v11, v4, v6, v3
		ds_read_b128 v[152:155], v11 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[12:15], v[48:51], a[4:7], v1, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[156:159], v11 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[12:15], v[52:55], a[8:11], v1, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[160:163], v11 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[12:15], v[56:59], a[12:15], v1, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[164:167], v11 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[12:15], v[60:63], a[16:19], v1, v76 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[168:171], v11 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[12:15], v[64:67], a[20:23], v1, v76 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[172:175], v11 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[12:15], v[68:71], a[24:27], v1, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[176:179], v11 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[12:15], v[72:75], a[28:31], v1, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[180:183], v11 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[16:19], v[44:47], a[32:35], v1, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s67, 0
		scratch_load_dword v3, off, s67 offset:520
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v4, s66, v3
		s_mov_b32 s66, 0
		scratch_load_dword v3, off, s66 offset:96
		s_mov_b32 s66, 0
		scratch_load_dword v6, off, s66 offset:516
		s_waitcnt vmcnt(0)
		v_add3_u32 v81, v4, v3, v6
		ds_read_b128 v[184:187], v81 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[16:19], v[48:51], a[36:39], v1, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[188:191], v81 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[16:19], v[52:55], a[40:43], v1, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[192:195], v81 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[16:19], v[56:59], a[44:47], v1, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[196:199], v81 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[16:19], v[60:63], a[48:51], v1, v76 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[200:203], v81 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[16:19], v[64:67], a[52:55], v1, v76 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[204:207], v81 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[16:19], v[68:71], a[56:59], v1, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[208:211], v81 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[16:19], v[72:75], a[60:63], v1, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[212:215], v81 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[20:23], v[44:47], a[64:67], v5, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_nop 0
		buffer_load_dwordx4 v90, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[20:23], v[48:51], a[68:71], v5, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v80, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[20:23], v[52:55], a[72:75], v5, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v92, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[20:23], v[56:59], a[76:79], v5, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v94, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[20:23], v[60:63], a[80:83], v5, v76 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v96, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[20:23], v[64:67], a[84:87], v5, v76 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v100, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[20:23], v[68:71], a[88:91], v5, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v114, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[20:23], v[72:75], a[92:95], v5, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v118, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[24:27], v[44:47], a[96:99], v5, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v120, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[24:27], v[48:51], a[100:103], v5, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v132, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[24:27], v[52:55], a[104:107], v5, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s37
		s_nop 0
		buffer_load_dwordx4 v134, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[24:27], v[56:59], a[108:111], v5, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v136, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[24:27], v[60:63], a[112:115], v5, v76 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v138, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[24:27], v[64:67], a[116:119], v5, v76 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s40
		s_nop 0
		buffer_load_dwordx4 v140, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[24:27], v[68:71], a[120:123], v5, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s41
		s_nop 0
		buffer_load_dwordx4 v142, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[24:27], v[72:75], a[124:127], v5, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s42
		s_nop 0
		buffer_load_dwordx4 v144, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[28:31], v[44:47], a[128:131], v8, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s8, 0x20000
		s_nop 0
		buffer_load_dwordx4 v2, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[28:31], v[48:51], a[132:135], v8, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s44, 0x20000
		s_nop 0
		buffer_load_dwordx4 v88, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[28:31], v[52:55], a[136:139], v8, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		ds_read_b128 v[12:15], v11
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[28:31], v[56:59], a[140:143], v8, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[16:19], v11 offset:1024
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[28:31], v[60:63], a[144:147], v8, v76 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v11 offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[28:31], v[64:67], a[148:151], v8, v76 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v11 offset:3072
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[28:31], v[68:71], a[152:155], v8, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v11 offset:4096
		s_mov_b32 s66, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v88, s66 offset:480
		scratch_store_dword off, v89, s66 offset:484
		scratch_store_dword off, v90, s66 offset:488
		scratch_store_dword off, v91, s66 offset:492
		s_mov_b32 s66, 0
		scratch_store_dword off, v88, s66 offset:496
		scratch_store_dword off, v89, s66 offset:500
		scratch_store_dword off, v90, s66 offset:504
		scratch_store_dword off, v91, s66 offset:508
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[28:31], v[72:75], a[156:159], v8, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v11 offset:5120
		s_mov_b32 s66, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v88, s66 offset:448
		scratch_store_dword off, v89, s66 offset:452
		scratch_store_dword off, v90, s66 offset:456
		scratch_store_dword off, v91, s66 offset:460
		s_mov_b32 s66, 0
		scratch_store_dword off, v88, s66 offset:464
		scratch_store_dword off, v89, s66 offset:468
		scratch_store_dword off, v90, s66 offset:472
		scratch_store_dword off, v91, s66 offset:476
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[32:35], v[44:47], a[160:163], v8, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v11 offset:6144
		s_mov_b32 s66, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v88, s66 offset:416
		scratch_store_dword off, v89, s66 offset:420
		scratch_store_dword off, v90, s66 offset:424
		scratch_store_dword off, v91, s66 offset:428
		s_mov_b32 s66, 0
		scratch_store_dword off, v88, s66 offset:432
		scratch_store_dword off, v89, s66 offset:436
		scratch_store_dword off, v90, s66 offset:440
		scratch_store_dword off, v91, s66 offset:444
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[32:35], v[48:51], a[164:167], v8, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v11 offset:7168
		s_mov_b32 s66, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v88, s66 offset:384
		scratch_store_dword off, v89, s66 offset:388
		scratch_store_dword off, v90, s66 offset:392
		scratch_store_dword off, v91, s66 offset:396
		s_mov_b32 s66, 0
		scratch_store_dword off, v88, s66 offset:400
		scratch_store_dword off, v89, s66 offset:404
		scratch_store_dword off, v90, s66 offset:408
		scratch_store_dword off, v91, s66 offset:412
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[32:35], v[52:55], a[168:171], v8, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v81 offset:32768
		s_mov_b32 s66, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v88, s66 offset:352
		scratch_store_dword off, v89, s66 offset:356
		scratch_store_dword off, v90, s66 offset:360
		scratch_store_dword off, v91, s66 offset:364
		s_mov_b32 s66, 0
		scratch_store_dword off, v88, s66 offset:368
		scratch_store_dword off, v89, s66 offset:372
		scratch_store_dword off, v90, s66 offset:376
		scratch_store_dword off, v91, s66 offset:380
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[32:35], v[56:59], a[172:175], v8, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v81 offset:33792
		s_mov_b32 s66, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v88, s66 offset:320
		scratch_store_dword off, v89, s66 offset:324
		scratch_store_dword off, v90, s66 offset:328
		scratch_store_dword off, v91, s66 offset:332
		s_mov_b32 s66, 0
		scratch_store_dword off, v88, s66 offset:336
		scratch_store_dword off, v89, s66 offset:340
		scratch_store_dword off, v90, s66 offset:344
		scratch_store_dword off, v91, s66 offset:348
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[32:35], v[60:63], a[176:179], v8, v76 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v81 offset:34816
		s_mov_b32 s66, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v88, s66 offset:288
		scratch_store_dword off, v89, s66 offset:292
		scratch_store_dword off, v90, s66 offset:296
		scratch_store_dword off, v91, s66 offset:300
		s_mov_b32 s66, 0
		scratch_store_dword off, v88, s66 offset:304
		scratch_store_dword off, v89, s66 offset:308
		scratch_store_dword off, v90, s66 offset:312
		scratch_store_dword off, v91, s66 offset:316
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[32:35], v[64:67], a[180:183], v8, v76 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v81 offset:35840
		s_mov_b32 s66, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v88, s66 offset:256
		scratch_store_dword off, v89, s66 offset:260
		scratch_store_dword off, v90, s66 offset:264
		scratch_store_dword off, v91, s66 offset:268
		s_mov_b32 s66, 0
		scratch_store_dword off, v88, s66 offset:272
		scratch_store_dword off, v89, s66 offset:276
		scratch_store_dword off, v90, s66 offset:280
		scratch_store_dword off, v91, s66 offset:284
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[32:35], v[68:71], a[184:187], v8, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v81 offset:36864
		s_mov_b32 s66, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v88, s66 offset:224
		scratch_store_dword off, v89, s66 offset:228
		scratch_store_dword off, v90, s66 offset:232
		scratch_store_dword off, v91, s66 offset:236
		s_mov_b32 s66, 0
		scratch_store_dword off, v88, s66 offset:240
		scratch_store_dword off, v89, s66 offset:244
		scratch_store_dword off, v90, s66 offset:248
		scratch_store_dword off, v91, s66 offset:252
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[32:35], v[72:75], a[188:191], v8, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v81 offset:37888
		s_mov_b32 s66, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v88, s66 offset:192
		scratch_store_dword off, v89, s66 offset:196
		scratch_store_dword off, v90, s66 offset:200
		scratch_store_dword off, v91, s66 offset:204
		s_mov_b32 s66, 0
		scratch_store_dword off, v88, s66 offset:208
		scratch_store_dword off, v89, s66 offset:212
		scratch_store_dword off, v90, s66 offset:216
		scratch_store_dword off, v91, s66 offset:220
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[36:39], v[44:47], a[192:195], v9, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v81 offset:38912
		s_mov_b32 s66, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v88, s66 offset:160
		scratch_store_dword off, v89, s66 offset:164
		scratch_store_dword off, v90, s66 offset:168
		scratch_store_dword off, v91, s66 offset:172
		s_mov_b32 s66, 0
		scratch_store_dword off, v88, s66 offset:176
		scratch_store_dword off, v89, s66 offset:180
		scratch_store_dword off, v90, s66 offset:184
		scratch_store_dword off, v91, s66 offset:188
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[36:39], v[48:51], a[196:199], v9, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v81 offset:39936
		s_mov_b32 s66, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v88, s66 offset:128
		scratch_store_dword off, v89, s66 offset:132
		scratch_store_dword off, v90, s66 offset:136
		scratch_store_dword off, v91, s66 offset:140
		s_mov_b32 s66, 0
		scratch_store_dword off, v88, s66 offset:144
		scratch_store_dword off, v89, s66 offset:148
		scratch_store_dword off, v90, s66 offset:152
		scratch_store_dword off, v91, s66 offset:156
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[36:39], v[52:55], a[200:203], v9, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshl_b32 s66, s61, 12
		s_add_i32 s61, s66, 0x20000
		s_mov_b32 s66, 0
		scratch_load_dword v2, off, s66 offset:108
		s_mov_b32 s66, 0
		scratch_load_dword v3, off, s66 offset:512
		s_waitcnt vmcnt(0)
		v_add3_u32 v4, s61, v2, v3
		ds_read_b32 v2, v4
		s_mov_b32 s66, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s66 offset:92
		ds_read_b32 v2, v4 offset:256
		s_mov_b32 s66, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s66 offset:88
		ds_read_b32 v2, v4 offset:512
		s_mov_b32 s66, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s66 offset:84
		ds_read_b32 v2, v4 offset:768
		s_mov_b32 s66, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s66 offset:80
		s_mov_b32 s66, 0
		scratch_load_dword v2, off, s66 offset:104
		s_mov_b32 s66, 0
		scratch_load_dword v3, off, s66 offset:512
		s_waitcnt vmcnt(0)
		v_add3_u32 v4, s61, v3, v2
		ds_read_b32 v2, v4 offset:2048
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s61 offset:76
		ds_read_b32 v2, v4 offset:2304
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s61 offset:72
		ds_read_b32 v2, v4 offset:2560
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s61 offset:68
		ds_read_b32 v2, v4 offset:2816
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s61 offset:64
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[36:39], v[56:59], a[204:207], v9, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[36:39], v[60:63], a[208:211], v9, v76 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[36:39], v[64:67], a[212:215], v9, v76 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[36:39], v[68:71], a[216:219], v9, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[36:39], v[72:75], a[220:223], v9, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[40:43], v[44:47], a[224:227], v9, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[40:43], v[48:51], a[228:231], v9, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[40:43], v[52:55], a[232:235], v9, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[40:43], v[56:59], a[236:239], v9, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[40:43], v[60:63], a[240:243], v9, v76 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[40:43], v[64:67], a[244:247], v9, v76 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[40:43], v[68:71], a[248:251], v9, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[40:43], v[72:75], a[252:255], v9, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[152:155], v[184:187], v[148:151], v1, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[152:155], v[188:191], a[4:7], v1, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[152:155], v[192:195], a[8:11], v1, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[152:155], v[196:199], a[12:15], v1, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[152:155], v[200:203], a[16:19], v1, v76 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[152:155], v[204:207], a[20:23], v1, v76 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[152:155], v[208:211], a[24:27], v1, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[152:155], v[212:215], a[28:31], v1, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[156:159], v[184:187], a[32:35], v1, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[156:159], v[188:191], a[36:39], v1, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[156:159], v[192:195], a[40:43], v1, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[156:159], v[196:199], a[44:47], v1, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[156:159], v[200:203], a[48:51], v1, v76 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[156:159], v[204:207], a[52:55], v1, v76 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[156:159], v[208:211], a[56:59], v1, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[156:159], v[212:215], a[60:63], v1, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[160:163], v[184:187], a[64:67], v5, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[160:163], v[188:191], a[68:71], v5, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[160:163], v[192:195], a[72:75], v5, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[160:163], v[196:199], a[76:79], v5, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[160:163], v[200:203], a[80:83], v5, v76 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[160:163], v[204:207], a[84:87], v5, v76 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[160:163], v[208:211], a[88:91], v5, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[160:163], v[212:215], a[92:95], v5, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[164:167], v[184:187], a[96:99], v5, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[164:167], v[188:191], a[100:103], v5, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[164:167], v[192:195], a[104:107], v5, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[164:167], v[196:199], a[108:111], v5, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[164:167], v[200:203], a[112:115], v5, v76 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[164:167], v[204:207], a[116:119], v5, v76 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[164:167], v[208:211], a[120:123], v5, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[164:167], v[212:215], a[124:127], v5, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[168:171], v[184:187], a[128:131], v8, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[168:171], v[188:191], a[132:135], v8, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[168:171], v[192:195], a[136:139], v8, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[168:171], v[196:199], a[140:143], v8, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[168:171], v[200:203], a[144:147], v8, v76 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[168:171], v[204:207], a[148:151], v8, v76 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[168:171], v[208:211], a[152:155], v8, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[168:171], v[212:215], a[156:159], v8, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[172:175], v[184:187], a[160:163], v8, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[172:175], v[188:191], a[164:167], v8, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[172:175], v[192:195], a[168:171], v8, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[172:175], v[196:199], a[172:175], v8, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[172:175], v[200:203], a[176:179], v8, v76 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[172:175], v[204:207], a[180:183], v8, v76 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[172:175], v[208:211], a[184:187], v8, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[172:175], v[212:215], a[188:191], v8, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[176:179], v[184:187], a[192:195], v9, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[176:179], v[188:191], a[196:199], v9, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[176:179], v[192:195], a[200:203], v9, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[176:179], v[196:199], a[204:207], v9, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[176:179], v[200:203], a[208:211], v9, v76 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[176:179], v[204:207], a[212:215], v9, v76 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[176:179], v[208:211], a[216:219], v9, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[176:179], v[212:215], a[220:223], v9, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[180:183], v[184:187], a[224:227], v9, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[180:183], v[188:191], a[228:231], v9, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[180:183], v[192:195], a[232:235], v9, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[180:183], v[196:199], a[236:239], v9, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[180:183], v[200:203], a[240:243], v9, v76 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[180:183], v[204:207], a[244:247], v9, v76 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[180:183], v[208:211], a[248:251], v9, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[180:183], v[212:215], a[252:255], v9, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s61, s60, 1
		s_and_b32 s66, s61, 1
		s_lshl_b32 s61, s66, 16
		s_mov_b32 s67, 0
		scratch_load_dword v2, off, s67 offset:100
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v3, s61, v2
		s_mov_b32 s67, 0
		scratch_load_dword v2, off, s67 offset:516
		s_mov_b32 s67, 0
		scratch_load_dword v4, off, s67 offset:520
		s_waitcnt vmcnt(0)
		v_add3_u32 v6, v3, v4, v2
		ds_read_b128 v[88:91], v6
		ds_read_b128 v[92:95], v6 offset:1024
		ds_read_b128 v[132:135], v6 offset:2048
		ds_read_b128 v[136:139], v6 offset:3072
		ds_read_b128 v[140:143], v6 offset:4096
		ds_read_b128 v[144:147], v6 offset:5120
		ds_read_b128 v[152:155], v6 offset:6144
		ds_read_b128 v[156:159], v6 offset:7168
		s_mov_b32 s67, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v156, s67 offset:524
		scratch_store_dword off, v157, s67 offset:528
		scratch_store_dword off, v158, s67 offset:532
		scratch_store_dword off, v159, s67 offset:536
		s_mov_b32 s67, 0
		scratch_store_dword off, v156, s67 offset:540
		scratch_store_dword off, v157, s67 offset:544
		scratch_store_dword off, v158, s67 offset:548
		scratch_store_dword off, v159, s67 offset:552
		s_mov_b32 s67, 0
		scratch_load_dword v2, off, s67 offset:520
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v3, s61, v2
		s_mov_b32 s61, 0
		scratch_load_dword v2, off, s61 offset:96
		s_mov_b32 s61, 0
		scratch_load_dword v4, off, s61 offset:516
		s_waitcnt vmcnt(0)
		v_add3_u32 v11, v3, v2, v4
		ds_read_b128 v[156:159], v11 offset:32768
		ds_read_b128 v[160:163], v11 offset:33792
		ds_read_b128 v[164:167], v11 offset:34816
		ds_read_b128 v[168:171], v11 offset:35840
		ds_read_b128 v[172:175], v11 offset:36864
		ds_read_b128 v[176:179], v11 offset:37888
		ds_read_b128 v[180:183], v11 offset:38912
		ds_read_b128 v[184:187], v11 offset:39936
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v184, s61 offset:588
		scratch_store_dword off, v185, s61 offset:592
		scratch_store_dword off, v186, s61 offset:596
		scratch_store_dword off, v187, s61 offset:600
		s_mov_b32 s61, 0
		scratch_store_dword off, v184, s61 offset:604
		scratch_store_dword off, v185, s61 offset:608
		scratch_store_dword off, v186, s61 offset:612
		scratch_store_dword off, v187, s61 offset:616
		s_lshl_b32 s61, s66, 12
		s_add_i32 s66, s61, 0x20000
		s_mov_b32 s61, 0
		scratch_load_dword v2, off, s61 offset:108
		s_mov_b32 s61, 0
		scratch_load_dword v3, off, s61 offset:512
		s_waitcnt vmcnt(0)
		v_add3_u32 v4, s66, v2, v3
		ds_read_b32 v2, v4
		ds_read_b32 v3, v4 offset:256
		ds_read_b32 v80, v4 offset:512
		ds_read_b32 v81, v4 offset:768
		s_mov_b32 s61, 0
		scratch_load_dword v4, off, s61 offset:104
		s_mov_b32 s61, 0
		scratch_load_dword v96, off, s61 offset:512
		s_waitcnt vmcnt(0)
		v_add3_u32 v97, s66, v96, v4
		ds_read_b32 v4, v97 offset:2048
		ds_read_b32 v96, v97 offset:2304
		ds_read_b32 v100, v97 offset:2560
		ds_read_b32 v101, v97 offset:2816
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v114, s62
		v_mov_b32_e32 v115, s63
		v_mov_b32_e32 v118, s60
		v_mov_b32_e32 v119, 0
		v_mul_lo_u32 v120, v114, v118
		v_mul_hi_u32 v121, v114, v118
		v_mul_lo_u32 v97, v114, v119
		v_add_u32_e32 v121, v121, v97
		v_mul_lo_u32 v97, v115, v118
		v_add_u32_e32 v121, v121, v97
		v_lshlrev_b32_e32 v97, 2, v0
		v_add_u32_e32 v114, 0x23000, v97
		ds_read_b32 v118, v114
		v_lshlrev_b32_e32 v97, 2, v0
		v_add_u32_e32 v114, 0x23400, v97
		ds_read_b32 v119, v114
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v114, vcc, v118, v120
		v_addc_co_u32_e64 v115, vcc, v119, v121, vcc
		v_lshlrev_b32_e32 v97, 2, v0
		v_add_u32_e32 v115, 0x23800, v97
		ds_read_b32 v118, v115
		v_lshlrev_b32_e32 v97, 2, v0
		v_add_u32_e32 v115, 0x23c00, v97
		ds_read_b32 v119, v115
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v184, vcc, v118, v120
		v_addc_co_u32_e64 v185, vcc, v119, v121, vcc
		v_lshlrev_b32_e32 v97, 2, v0
		v_add_u32_e32 v115, 0x24000, v97
		ds_read_b32 v118, v115
		v_lshlrev_b32_e32 v97, 2, v0
		v_add_u32_e32 v115, 0x24400, v97
		ds_read_b32 v119, v115
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v186, vcc, v118, v120
		v_addc_co_u32_e64 v187, vcc, v119, v121, vcc
		v_lshlrev_b32_e32 v97, 2, v0
		v_add_u32_e32 v115, 0x24800, v97
		ds_read_b32 v118, v115
		v_lshlrev_b32_e32 v97, 2, v0
		v_add_u32_e32 v115, 0x24c00, v97
		ds_read_b32 v119, v115
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v188, vcc, v118, v120
		v_addc_co_u32_e64 v189, vcc, v119, v121, vcc
		v_lshlrev_b32_e32 v97, 2, v0
		v_add_u32_e32 v115, 0x25000, v97
		ds_read_b32 v118, v115
		v_lshlrev_b32_e32 v97, 2, v0
		v_add_u32_e32 v115, 0x25400, v97
		ds_read_b32 v119, v115
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v190, vcc, v118, v120
		v_addc_co_u32_e64 v191, vcc, v119, v121, vcc
		v_lshlrev_b32_e32 v97, 2, v0
		v_add_u32_e32 v115, 0x25800, v97
		ds_read_b32 v118, v115
		v_lshlrev_b32_e32 v97, 2, v0
		v_add_u32_e32 v115, 0x25c00, v97
		ds_read_b32 v119, v115
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v192, vcc, v118, v120
		v_addc_co_u32_e64 v193, vcc, v119, v121, vcc
		v_lshlrev_b32_e32 v97, 2, v0
		v_add_u32_e32 v115, 0x26000, v97
		ds_read_b32 v118, v115
		v_lshlrev_b32_e32 v97, 2, v0
		v_add_u32_e32 v115, 0x26400, v97
		ds_read_b32 v119, v115
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v194, vcc, v118, v120
		v_addc_co_u32_e64 v195, vcc, v119, v121, vcc
		v_lshlrev_b32_e32 v97, 2, v0
		v_add_u32_e32 v115, 0x26800, v97
		ds_read_b32 v118, v115
		v_lshlrev_b32_e32 v97, 2, v0
		v_add_u32_e32 v115, 0x26c00, v97
		ds_read_b32 v119, v115
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v196, vcc, v118, v120
		v_addc_co_u32_e64 v197, vcc, v119, v121, vcc
		v_lshlrev_b32_e32 v97, 2, v0
		v_add_u32_e32 v115, 0x27000, v97
		ds_read_b32 v118, v115
		v_lshlrev_b32_e32 v97, 2, v0
		v_add_u32_e32 v115, 0x27400, v97
		ds_read_b32 v119, v115
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v198, vcc, v118, v120
		v_addc_co_u32_e64 v199, vcc, v119, v121, vcc
		v_lshlrev_b32_e32 v97, 2, v0
		v_add_u32_e32 v115, 0x27800, v97
		ds_read_b32 v118, v115
		v_lshlrev_b32_e32 v97, 2, v0
		v_add_u32_e32 v115, 0x27c00, v97
		ds_read_b32 v119, v115
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v200, vcc, v118, v120
		v_addc_co_u32_e64 v201, vcc, v119, v121, vcc
		s_mov_b32 s61, 0
		scratch_load_dword v118, off, s61
		scratch_load_dword v119, off, s61 offset:4
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v202, vcc, v118, v120
		v_addc_co_u32_e64 v203, vcc, v119, v121, vcc
		s_mov_b32 s61, 0
		scratch_load_dword v118, off, s61 offset:8
		scratch_load_dword v119, off, s61 offset:12
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v204, vcc, v118, v120
		v_addc_co_u32_e64 v205, vcc, v119, v121, vcc
		s_mov_b32 s61, 0
		scratch_load_dword v118, off, s61 offset:16
		scratch_load_dword v119, off, s61 offset:20
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v206, vcc, v118, v120
		v_addc_co_u32_e64 v207, vcc, v119, v121, vcc
		s_mov_b32 s61, 0
		scratch_load_dword v118, off, s61 offset:24
		scratch_load_dword v119, off, s61 offset:28
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v208, vcc, v118, v120
		v_addc_co_u32_e64 v209, vcc, v119, v121, vcc
		s_mov_b32 s61, 0
		scratch_load_dword v118, off, s61 offset:32
		scratch_load_dword v119, off, s61 offset:36
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v210, vcc, v118, v120
		v_addc_co_u32_e64 v211, vcc, v119, v121, vcc
		s_mov_b32 s61, 0
		scratch_load_dword v118, off, s61 offset:40
		scratch_load_dword v119, off, s61 offset:44
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v212, vcc, v118, v120
		v_addc_co_u32_e64 v213, vcc, v119, v121, vcc
		v_mov_b32_e32 v118, s64
		v_mov_b32_e32 v119, s65
		v_mov_b32_e32 v120, s60
		v_mov_b32_e32 v121, 0
		v_mul_lo_u32 v214, v118, v120
		v_mul_hi_u32 v215, v118, v120
		v_mul_lo_u32 v97, v118, v121
		v_add_u32_e32 v215, v215, v97
		v_mul_lo_u32 v97, v119, v120
		v_add_u32_e32 v215, v215, v97
		s_mov_b32 s61, 0
		scratch_load_dword v118, off, s61 offset:48
		scratch_load_dword v119, off, s61 offset:52
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v120, vcc, v118, v214
		v_addc_co_u32_e64 v121, vcc, v119, v215, vcc
		s_mov_b32 s61, 0
		scratch_load_dword v118, off, s61 offset:56
		scratch_load_dword v119, off, s61 offset:60
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v216, vcc, v118, v214
		v_addc_co_u32_e64 v217, vcc, v119, v215, vcc
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[88:91], v[156:159], v[148:151], v2, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v6 offset:16384
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v220, s61 offset:556
		scratch_store_dword off, v221, s61 offset:560
		scratch_store_dword off, v222, s61 offset:564
		scratch_store_dword off, v223, s61 offset:568
		s_mov_b32 s61, 0
		scratch_store_dword off, v220, s61 offset:572
		scratch_store_dword off, v221, s61 offset:576
		scratch_store_dword off, v222, s61 offset:580
		scratch_store_dword off, v223, s61 offset:584
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[88:91], v[160:163], a[4:7], v2, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v6 offset:17408
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v220, s61 offset:652
		scratch_store_dword off, v221, s61 offset:656
		scratch_store_dword off, v222, s61 offset:660
		scratch_store_dword off, v223, s61 offset:664
		s_mov_b32 s61, 0
		scratch_store_dword off, v220, s61 offset:668
		scratch_store_dword off, v221, s61 offset:672
		scratch_store_dword off, v222, s61 offset:676
		scratch_store_dword off, v223, s61 offset:680
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[88:91], v[164:167], a[8:11], v2, v96 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v6 offset:18432
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v220, s61 offset:620
		scratch_store_dword off, v221, s61 offset:624
		scratch_store_dword off, v222, s61 offset:628
		scratch_store_dword off, v223, s61 offset:632
		s_mov_b32 s61, 0
		scratch_store_dword off, v220, s61 offset:636
		scratch_store_dword off, v221, s61 offset:640
		scratch_store_dword off, v222, s61 offset:644
		scratch_store_dword off, v223, s61 offset:648
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[88:91], v[168:171], a[12:15], v2, v96 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v6 offset:19456
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v220, s61 offset:716
		scratch_store_dword off, v221, s61 offset:720
		scratch_store_dword off, v222, s61 offset:724
		scratch_store_dword off, v223, s61 offset:728
		s_mov_b32 s61, 0
		scratch_store_dword off, v220, s61 offset:732
		scratch_store_dword off, v221, s61 offset:736
		scratch_store_dword off, v222, s61 offset:740
		scratch_store_dword off, v223, s61 offset:744
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[88:91], v[172:175], a[16:19], v2, v100 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v6 offset:20480
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v220, s61 offset:684
		scratch_store_dword off, v221, s61 offset:688
		scratch_store_dword off, v222, s61 offset:692
		scratch_store_dword off, v223, s61 offset:696
		s_mov_b32 s61, 0
		scratch_store_dword off, v220, s61 offset:700
		scratch_store_dword off, v221, s61 offset:704
		scratch_store_dword off, v222, s61 offset:708
		scratch_store_dword off, v223, s61 offset:712
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[88:91], v[176:179], a[20:23], v2, v100 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v6 offset:21504
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v220, s61 offset:780
		scratch_store_dword off, v221, s61 offset:784
		scratch_store_dword off, v222, s61 offset:788
		scratch_store_dword off, v223, s61 offset:792
		s_mov_b32 s61, 0
		scratch_store_dword off, v220, s61 offset:796
		scratch_store_dword off, v221, s61 offset:800
		scratch_store_dword off, v222, s61 offset:804
		scratch_store_dword off, v223, s61 offset:808
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[88:91], v[180:183], a[24:27], v2, v101 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v6 offset:22528
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v220, s61 offset:748
		scratch_store_dword off, v221, s61 offset:752
		scratch_store_dword off, v222, s61 offset:756
		scratch_store_dword off, v223, s61 offset:760
		s_mov_b32 s61, 0
		scratch_store_dword off, v220, s61 offset:764
		scratch_store_dword off, v221, s61 offset:768
		scratch_store_dword off, v222, s61 offset:772
		scratch_store_dword off, v223, s61 offset:776
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(56)
		scratch_load_dword v220, off, s61 offset:604
		scratch_load_dword v221, off, s61 offset:608
		scratch_load_dword v222, off, s61 offset:612
		scratch_load_dword v223, off, s61 offset:616
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[88:91], v[220:223], a[28:31], v2, v101 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v6 offset:23552
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v88, s61 offset:812
		scratch_store_dword off, v89, s61 offset:816
		scratch_store_dword off, v90, s61 offset:820
		scratch_store_dword off, v91, s61 offset:824
		s_mov_b32 s61, 0
		scratch_store_dword off, v88, s61 offset:828
		scratch_store_dword off, v89, s61 offset:832
		scratch_store_dword off, v90, s61 offset:836
		scratch_store_dword off, v91, s61 offset:840
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[92:95], v[156:159], a[32:35], v2, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v11 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[92:95], v[160:163], a[36:39], v2, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v11 offset:50176
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v220, s61 offset:876
		scratch_store_dword off, v221, s61 offset:880
		scratch_store_dword off, v222, s61 offset:884
		scratch_store_dword off, v223, s61 offset:888
		s_mov_b32 s61, 0
		scratch_store_dword off, v220, s61 offset:892
		scratch_store_dword off, v221, s61 offset:896
		scratch_store_dword off, v222, s61 offset:900
		scratch_store_dword off, v223, s61 offset:904
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[92:95], v[164:167], a[40:43], v2, v96 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v11 offset:51200
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v220, s61 offset:844
		scratch_store_dword off, v221, s61 offset:848
		scratch_store_dword off, v222, s61 offset:852
		scratch_store_dword off, v223, s61 offset:856
		s_mov_b32 s61, 0
		scratch_store_dword off, v220, s61 offset:860
		scratch_store_dword off, v221, s61 offset:864
		scratch_store_dword off, v222, s61 offset:868
		scratch_store_dword off, v223, s61 offset:872
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[92:95], v[168:171], a[44:47], v2, v96 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v11 offset:52224
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v220, s61 offset:940
		scratch_store_dword off, v221, s61 offset:944
		scratch_store_dword off, v222, s61 offset:948
		scratch_store_dword off, v223, s61 offset:952
		s_mov_b32 s61, 0
		scratch_store_dword off, v220, s61 offset:956
		scratch_store_dword off, v221, s61 offset:960
		scratch_store_dword off, v222, s61 offset:964
		scratch_store_dword off, v223, s61 offset:968
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[92:95], v[172:175], a[48:51], v2, v100 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v11 offset:53248
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v220, s61 offset:908
		scratch_store_dword off, v221, s61 offset:912
		scratch_store_dword off, v222, s61 offset:916
		scratch_store_dword off, v223, s61 offset:920
		s_mov_b32 s61, 0
		scratch_store_dword off, v220, s61 offset:924
		scratch_store_dword off, v221, s61 offset:928
		scratch_store_dword off, v222, s61 offset:932
		scratch_store_dword off, v223, s61 offset:936
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[92:95], v[176:179], a[52:55], v2, v100 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v11 offset:54272
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v220, s61 offset:1004
		scratch_store_dword off, v221, s61 offset:1008
		scratch_store_dword off, v222, s61 offset:1012
		scratch_store_dword off, v223, s61 offset:1016
		s_mov_b32 s61, 0
		scratch_store_dword off, v220, s61 offset:1020
		scratch_store_dword off, v221, s61 offset:1024
		scratch_store_dword off, v222, s61 offset:1028
		scratch_store_dword off, v223, s61 offset:1032
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[92:95], v[180:183], a[56:59], v2, v101 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v11 offset:55296
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v220, s61 offset:972
		scratch_store_dword off, v221, s61 offset:976
		scratch_store_dword off, v222, s61 offset:980
		scratch_store_dword off, v223, s61 offset:984
		s_mov_b32 s61, 0
		scratch_store_dword off, v220, s61 offset:988
		scratch_store_dword off, v221, s61 offset:992
		scratch_store_dword off, v222, s61 offset:996
		scratch_store_dword off, v223, s61 offset:1000
		s_mov_b32 s61, 0
		scratch_load_dword v220, off, s61 offset:604
		scratch_load_dword v221, off, s61 offset:608
		scratch_load_dword v222, off, s61 offset:612
		scratch_load_dword v223, off, s61 offset:616
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[92:95], v[220:223], a[60:63], v2, v101 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v11 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[132:135], v[156:159], a[64:67], v3, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s10
		s_nop 0
		buffer_load_dwordx4 v114, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[132:135], v[160:163], a[68:71], v3, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s45
		s_nop 0
		buffer_load_dwordx4 v184, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[132:135], v[164:167], a[72:75], v3, v96 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s46
		s_nop 0
		buffer_load_dwordx4 v186, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[132:135], v[168:171], a[76:79], v3, v96 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s47
		s_nop 0
		buffer_load_dwordx4 v188, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[132:135], v[172:175], a[80:83], v3, v100 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s48
		s_nop 0
		buffer_load_dwordx4 v190, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[132:135], v[176:179], a[84:87], v3, v100 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s49
		s_nop 0
		buffer_load_dwordx4 v192, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[132:135], v[180:183], a[88:91], v3, v101 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v194, s[20:23], 0 offen lds
		s_mov_b32 s61, 0
		scratch_load_dword v184, off, s61 offset:604
		scratch_load_dword v185, off, s61 offset:608
		scratch_load_dword v186, off, s61 offset:612
		scratch_load_dword v187, off, s61 offset:616
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[132:135], v[184:187], a[92:95], v3, v101 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s51
		s_nop 0
		buffer_load_dwordx4 v196, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[136:139], v[156:159], a[96:99], v3, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s52
		s_nop 0
		buffer_load_dwordx4 v198, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[136:139], v[160:163], a[100:103], v3, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s53
		s_nop 0
		buffer_load_dwordx4 v200, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[136:139], v[164:167], a[104:107], v3, v96 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s54
		s_nop 0
		buffer_load_dwordx4 v202, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[136:139], v[168:171], a[108:111], v3, v96 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s55
		s_nop 0
		buffer_load_dwordx4 v204, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[136:139], v[172:175], a[112:115], v3, v100 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s56
		s_nop 0
		buffer_load_dwordx4 v206, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[136:139], v[176:179], a[116:119], v3, v100 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s57
		s_nop 0
		buffer_load_dwordx4 v208, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[136:139], v[180:183], a[120:123], v3, v101 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s58
		s_nop 0
		buffer_load_dwordx4 v210, s[0:3], 0 offen lds
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:604
		scratch_load_dword v133, off, s61 offset:608
		scratch_load_dword v134, off, s61 offset:612
		scratch_load_dword v135, off, s61 offset:616
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[136:139], v[132:135], a[124:127], v3, v101 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s59
		s_nop 0
		buffer_load_dwordx4 v212, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[140:143], v[156:159], a[128:131], v80, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s43, 0x20000
		s_nop 0
		buffer_load_dwordx4 v120, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[140:143], v[160:163], a[132:135], v80, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s9, 0x20000
		s_nop 0
		buffer_load_dwordx4 v216, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[140:143], v[164:167], a[136:139], v80, v96 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[140:143], v[168:171], a[140:143], v80, v96 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[140:143], v[172:175], a[144:147], v80, v100 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[140:143], v[176:179], a[148:151], v80, v100 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[140:143], v[180:183], a[152:155], v80, v101 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:604
		scratch_load_dword v133, off, s61 offset:608
		scratch_load_dword v134, off, s61 offset:612
		scratch_load_dword v135, off, s61 offset:616
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[140:143], v[132:135], a[156:159], v80, v101 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[144:147], v[156:159], a[160:163], v80, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[144:147], v[160:163], a[164:167], v80, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[144:147], v[164:167], a[168:171], v80, v96 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[144:147], v[168:171], a[172:175], v80, v96 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[144:147], v[172:175], a[176:179], v80, v100 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[144:147], v[176:179], a[180:183], v80, v100 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[144:147], v[180:183], a[184:187], v80, v101 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:604
		scratch_load_dword v133, off, s61 offset:608
		scratch_load_dword v134, off, s61 offset:612
		scratch_load_dword v135, off, s61 offset:616
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[144:147], v[132:135], a[188:191], v80, v101 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[152:155], v[156:159], a[192:195], v81, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[152:155], v[160:163], a[196:199], v81, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[152:155], v[164:167], a[200:203], v81, v96 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[152:155], v[168:171], a[204:207], v81, v96 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[152:155], v[172:175], a[208:211], v81, v100 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[152:155], v[176:179], a[212:215], v81, v100 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[152:155], v[180:183], a[216:219], v81, v101 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:604
		scratch_load_dword v133, off, s61 offset:608
		scratch_load_dword v134, off, s61 offset:612
		scratch_load_dword v135, off, s61 offset:616
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[152:155], v[132:135], a[220:223], v81, v101 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:540
		scratch_load_dword v133, off, s61 offset:544
		scratch_load_dword v134, off, s61 offset:548
		scratch_load_dword v135, off, s61 offset:552
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[132:135], v[156:159], a[224:227], v81, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:540
		scratch_load_dword v133, off, s61 offset:544
		scratch_load_dword v134, off, s61 offset:548
		scratch_load_dword v135, off, s61 offset:552
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[132:135], v[160:163], a[228:231], v81, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:540
		scratch_load_dword v133, off, s61 offset:544
		scratch_load_dword v134, off, s61 offset:548
		scratch_load_dword v135, off, s61 offset:552
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[132:135], v[164:167], a[232:235], v81, v96 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:540
		scratch_load_dword v133, off, s61 offset:544
		scratch_load_dword v134, off, s61 offset:548
		scratch_load_dword v135, off, s61 offset:552
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[132:135], v[168:171], a[236:239], v81, v96 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:540
		scratch_load_dword v133, off, s61 offset:544
		scratch_load_dword v134, off, s61 offset:548
		scratch_load_dword v135, off, s61 offset:552
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[132:135], v[172:175], a[240:243], v81, v100 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:540
		scratch_load_dword v133, off, s61 offset:544
		scratch_load_dword v134, off, s61 offset:548
		scratch_load_dword v135, off, s61 offset:552
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[132:135], v[176:179], a[244:247], v81, v100 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:540
		scratch_load_dword v133, off, s61 offset:544
		scratch_load_dword v134, off, s61 offset:548
		scratch_load_dword v135, off, s61 offset:552
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[132:135], v[180:183], a[248:251], v81, v101 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:540
		scratch_load_dword v133, off, s61 offset:544
		scratch_load_dword v134, off, s61 offset:548
		scratch_load_dword v135, off, s61 offset:552
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:604
		scratch_load_dword v137, off, s61 offset:608
		scratch_load_dword v138, off, s61 offset:612
		scratch_load_dword v139, off, s61 offset:616
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[132:135], v[136:139], a[252:255], v81, v101 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_waitcnt lgkmcnt(0)
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(63) expcnt(7) lgkmcnt(15)
		scratch_load_dword v132, off, s61 offset:572
		scratch_load_dword v133, off, s61 offset:576
		scratch_load_dword v134, off, s61 offset:580
		scratch_load_dword v135, off, s61 offset:584
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[132:135], v[88:91], v[148:151], v2, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:572
		scratch_load_dword v133, off, s61 offset:576
		scratch_load_dword v134, off, s61 offset:580
		scratch_load_dword v135, off, s61 offset:584
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(40)
		scratch_load_dword v136, off, s61 offset:892
		scratch_load_dword v137, off, s61 offset:896
		scratch_load_dword v138, off, s61 offset:900
		scratch_load_dword v139, off, s61 offset:904
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[132:135], v[136:139], a[4:7], v2, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:572
		scratch_load_dword v133, off, s61 offset:576
		scratch_load_dword v134, off, s61 offset:580
		scratch_load_dword v135, off, s61 offset:584
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(32)
		scratch_load_dword v136, off, s61 offset:860
		scratch_load_dword v137, off, s61 offset:864
		scratch_load_dword v138, off, s61 offset:868
		scratch_load_dword v139, off, s61 offset:872
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[132:135], v[136:139], a[8:11], v2, v96 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:572
		scratch_load_dword v133, off, s61 offset:576
		scratch_load_dword v134, off, s61 offset:580
		scratch_load_dword v135, off, s61 offset:584
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v136, off, s61 offset:956
		scratch_load_dword v137, off, s61 offset:960
		scratch_load_dword v138, off, s61 offset:964
		scratch_load_dword v139, off, s61 offset:968
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[132:135], v[136:139], a[12:15], v2, v96 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:572
		scratch_load_dword v133, off, s61 offset:576
		scratch_load_dword v134, off, s61 offset:580
		scratch_load_dword v135, off, s61 offset:584
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v136, off, s61 offset:924
		scratch_load_dword v137, off, s61 offset:928
		scratch_load_dword v138, off, s61 offset:932
		scratch_load_dword v139, off, s61 offset:936
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[132:135], v[136:139], a[16:19], v2, v100 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:572
		scratch_load_dword v133, off, s61 offset:576
		scratch_load_dword v134, off, s61 offset:580
		scratch_load_dword v135, off, s61 offset:584
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v136, off, s61 offset:1020
		scratch_load_dword v137, off, s61 offset:1024
		scratch_load_dword v138, off, s61 offset:1028
		scratch_load_dword v139, off, s61 offset:1032
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[132:135], v[136:139], a[20:23], v2, v100 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:572
		scratch_load_dword v133, off, s61 offset:576
		scratch_load_dword v134, off, s61 offset:580
		scratch_load_dword v135, off, s61 offset:584
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v136, off, s61 offset:988
		scratch_load_dword v137, off, s61 offset:992
		scratch_load_dword v138, off, s61 offset:996
		scratch_load_dword v139, off, s61 offset:1000
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[132:135], v[136:139], a[24:27], v2, v101 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:572
		scratch_load_dword v133, off, s61 offset:576
		scratch_load_dword v134, off, s61 offset:580
		scratch_load_dword v135, off, s61 offset:584
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[132:135], v[92:95], a[28:31], v2, v101 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:668
		scratch_load_dword v133, off, s61 offset:672
		scratch_load_dword v134, off, s61 offset:676
		scratch_load_dword v135, off, s61 offset:680
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[132:135], v[88:91], a[32:35], v2, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:668
		scratch_load_dword v133, off, s61 offset:672
		scratch_load_dword v134, off, s61 offset:676
		scratch_load_dword v135, off, s61 offset:680
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:892
		scratch_load_dword v137, off, s61 offset:896
		scratch_load_dword v138, off, s61 offset:900
		scratch_load_dword v139, off, s61 offset:904
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[132:135], v[136:139], a[36:39], v2, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:668
		scratch_load_dword v133, off, s61 offset:672
		scratch_load_dword v134, off, s61 offset:676
		scratch_load_dword v135, off, s61 offset:680
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:860
		scratch_load_dword v137, off, s61 offset:864
		scratch_load_dword v138, off, s61 offset:868
		scratch_load_dword v139, off, s61 offset:872
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[132:135], v[136:139], a[40:43], v2, v96 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:668
		scratch_load_dword v133, off, s61 offset:672
		scratch_load_dword v134, off, s61 offset:676
		scratch_load_dword v135, off, s61 offset:680
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:956
		scratch_load_dword v137, off, s61 offset:960
		scratch_load_dword v138, off, s61 offset:964
		scratch_load_dword v139, off, s61 offset:968
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[132:135], v[136:139], a[44:47], v2, v96 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:668
		scratch_load_dword v133, off, s61 offset:672
		scratch_load_dword v134, off, s61 offset:676
		scratch_load_dword v135, off, s61 offset:680
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:924
		scratch_load_dword v137, off, s61 offset:928
		scratch_load_dword v138, off, s61 offset:932
		scratch_load_dword v139, off, s61 offset:936
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[132:135], v[136:139], a[48:51], v2, v100 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:668
		scratch_load_dword v133, off, s61 offset:672
		scratch_load_dword v134, off, s61 offset:676
		scratch_load_dword v135, off, s61 offset:680
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:1020
		scratch_load_dword v137, off, s61 offset:1024
		scratch_load_dword v138, off, s61 offset:1028
		scratch_load_dword v139, off, s61 offset:1032
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[132:135], v[136:139], a[52:55], v2, v100 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:668
		scratch_load_dword v133, off, s61 offset:672
		scratch_load_dword v134, off, s61 offset:676
		scratch_load_dword v135, off, s61 offset:680
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:988
		scratch_load_dword v137, off, s61 offset:992
		scratch_load_dword v138, off, s61 offset:996
		scratch_load_dword v139, off, s61 offset:1000
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[132:135], v[136:139], a[56:59], v2, v101 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:668
		scratch_load_dword v133, off, s61 offset:672
		scratch_load_dword v134, off, s61 offset:676
		scratch_load_dword v135, off, s61 offset:680
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[132:135], v[92:95], a[60:63], v2, v101 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:636
		scratch_load_dword v133, off, s61 offset:640
		scratch_load_dword v134, off, s61 offset:644
		scratch_load_dword v135, off, s61 offset:648
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[132:135], v[88:91], a[64:67], v3, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:636
		scratch_load_dword v133, off, s61 offset:640
		scratch_load_dword v134, off, s61 offset:644
		scratch_load_dword v135, off, s61 offset:648
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:892
		scratch_load_dword v137, off, s61 offset:896
		scratch_load_dword v138, off, s61 offset:900
		scratch_load_dword v139, off, s61 offset:904
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[132:135], v[136:139], a[68:71], v3, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:636
		scratch_load_dword v133, off, s61 offset:640
		scratch_load_dword v134, off, s61 offset:644
		scratch_load_dword v135, off, s61 offset:648
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:860
		scratch_load_dword v137, off, s61 offset:864
		scratch_load_dword v138, off, s61 offset:868
		scratch_load_dword v139, off, s61 offset:872
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[132:135], v[136:139], a[72:75], v3, v96 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:636
		scratch_load_dword v133, off, s61 offset:640
		scratch_load_dword v134, off, s61 offset:644
		scratch_load_dword v135, off, s61 offset:648
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:956
		scratch_load_dword v137, off, s61 offset:960
		scratch_load_dword v138, off, s61 offset:964
		scratch_load_dword v139, off, s61 offset:968
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[132:135], v[136:139], a[76:79], v3, v96 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:636
		scratch_load_dword v133, off, s61 offset:640
		scratch_load_dword v134, off, s61 offset:644
		scratch_load_dword v135, off, s61 offset:648
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:924
		scratch_load_dword v137, off, s61 offset:928
		scratch_load_dword v138, off, s61 offset:932
		scratch_load_dword v139, off, s61 offset:936
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[132:135], v[136:139], a[80:83], v3, v100 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:636
		scratch_load_dword v133, off, s61 offset:640
		scratch_load_dword v134, off, s61 offset:644
		scratch_load_dword v135, off, s61 offset:648
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:1020
		scratch_load_dword v137, off, s61 offset:1024
		scratch_load_dword v138, off, s61 offset:1028
		scratch_load_dword v139, off, s61 offset:1032
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[132:135], v[136:139], a[84:87], v3, v100 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:636
		scratch_load_dword v133, off, s61 offset:640
		scratch_load_dword v134, off, s61 offset:644
		scratch_load_dword v135, off, s61 offset:648
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:988
		scratch_load_dword v137, off, s61 offset:992
		scratch_load_dword v138, off, s61 offset:996
		scratch_load_dword v139, off, s61 offset:1000
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[132:135], v[136:139], a[88:91], v3, v101 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:636
		scratch_load_dword v133, off, s61 offset:640
		scratch_load_dword v134, off, s61 offset:644
		scratch_load_dword v135, off, s61 offset:648
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[132:135], v[92:95], a[92:95], v3, v101 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:732
		scratch_load_dword v133, off, s61 offset:736
		scratch_load_dword v134, off, s61 offset:740
		scratch_load_dword v135, off, s61 offset:744
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[132:135], v[88:91], a[96:99], v3, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:732
		scratch_load_dword v133, off, s61 offset:736
		scratch_load_dword v134, off, s61 offset:740
		scratch_load_dword v135, off, s61 offset:744
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:892
		scratch_load_dword v137, off, s61 offset:896
		scratch_load_dword v138, off, s61 offset:900
		scratch_load_dword v139, off, s61 offset:904
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[132:135], v[136:139], a[100:103], v3, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:732
		scratch_load_dword v133, off, s61 offset:736
		scratch_load_dword v134, off, s61 offset:740
		scratch_load_dword v135, off, s61 offset:744
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:860
		scratch_load_dword v137, off, s61 offset:864
		scratch_load_dword v138, off, s61 offset:868
		scratch_load_dword v139, off, s61 offset:872
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[132:135], v[136:139], a[104:107], v3, v96 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:732
		scratch_load_dword v133, off, s61 offset:736
		scratch_load_dword v134, off, s61 offset:740
		scratch_load_dword v135, off, s61 offset:744
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:956
		scratch_load_dword v137, off, s61 offset:960
		scratch_load_dword v138, off, s61 offset:964
		scratch_load_dword v139, off, s61 offset:968
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[132:135], v[136:139], a[108:111], v3, v96 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:732
		scratch_load_dword v133, off, s61 offset:736
		scratch_load_dword v134, off, s61 offset:740
		scratch_load_dword v135, off, s61 offset:744
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:924
		scratch_load_dword v137, off, s61 offset:928
		scratch_load_dword v138, off, s61 offset:932
		scratch_load_dword v139, off, s61 offset:936
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[132:135], v[136:139], a[112:115], v3, v100 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:732
		scratch_load_dword v133, off, s61 offset:736
		scratch_load_dword v134, off, s61 offset:740
		scratch_load_dword v135, off, s61 offset:744
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:1020
		scratch_load_dword v137, off, s61 offset:1024
		scratch_load_dword v138, off, s61 offset:1028
		scratch_load_dword v139, off, s61 offset:1032
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[132:135], v[136:139], a[116:119], v3, v100 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:732
		scratch_load_dword v133, off, s61 offset:736
		scratch_load_dword v134, off, s61 offset:740
		scratch_load_dword v135, off, s61 offset:744
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:988
		scratch_load_dword v137, off, s61 offset:992
		scratch_load_dword v138, off, s61 offset:996
		scratch_load_dword v139, off, s61 offset:1000
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[132:135], v[136:139], a[120:123], v3, v101 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:732
		scratch_load_dword v133, off, s61 offset:736
		scratch_load_dword v134, off, s61 offset:740
		scratch_load_dword v135, off, s61 offset:744
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[132:135], v[92:95], a[124:127], v3, v101 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:700
		scratch_load_dword v133, off, s61 offset:704
		scratch_load_dword v134, off, s61 offset:708
		scratch_load_dword v135, off, s61 offset:712
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[132:135], v[88:91], a[128:131], v80, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:700
		scratch_load_dword v133, off, s61 offset:704
		scratch_load_dword v134, off, s61 offset:708
		scratch_load_dword v135, off, s61 offset:712
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:892
		scratch_load_dword v137, off, s61 offset:896
		scratch_load_dword v138, off, s61 offset:900
		scratch_load_dword v139, off, s61 offset:904
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[132:135], v[136:139], a[132:135], v80, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:700
		scratch_load_dword v133, off, s61 offset:704
		scratch_load_dword v134, off, s61 offset:708
		scratch_load_dword v135, off, s61 offset:712
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:860
		scratch_load_dword v137, off, s61 offset:864
		scratch_load_dword v138, off, s61 offset:868
		scratch_load_dword v139, off, s61 offset:872
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[132:135], v[136:139], a[136:139], v80, v96 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:700
		scratch_load_dword v133, off, s61 offset:704
		scratch_load_dword v134, off, s61 offset:708
		scratch_load_dword v135, off, s61 offset:712
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:956
		scratch_load_dword v137, off, s61 offset:960
		scratch_load_dword v138, off, s61 offset:964
		scratch_load_dword v139, off, s61 offset:968
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[132:135], v[136:139], a[140:143], v80, v96 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:700
		scratch_load_dword v133, off, s61 offset:704
		scratch_load_dword v134, off, s61 offset:708
		scratch_load_dword v135, off, s61 offset:712
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:924
		scratch_load_dword v137, off, s61 offset:928
		scratch_load_dword v138, off, s61 offset:932
		scratch_load_dword v139, off, s61 offset:936
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[132:135], v[136:139], a[144:147], v80, v100 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:700
		scratch_load_dword v133, off, s61 offset:704
		scratch_load_dword v134, off, s61 offset:708
		scratch_load_dword v135, off, s61 offset:712
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:1020
		scratch_load_dword v137, off, s61 offset:1024
		scratch_load_dword v138, off, s61 offset:1028
		scratch_load_dword v139, off, s61 offset:1032
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[132:135], v[136:139], a[148:151], v80, v100 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:700
		scratch_load_dword v133, off, s61 offset:704
		scratch_load_dword v134, off, s61 offset:708
		scratch_load_dword v135, off, s61 offset:712
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:988
		scratch_load_dword v137, off, s61 offset:992
		scratch_load_dword v138, off, s61 offset:996
		scratch_load_dword v139, off, s61 offset:1000
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[132:135], v[136:139], a[152:155], v80, v101 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:700
		scratch_load_dword v133, off, s61 offset:704
		scratch_load_dword v134, off, s61 offset:708
		scratch_load_dword v135, off, s61 offset:712
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[132:135], v[92:95], a[156:159], v80, v101 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:796
		scratch_load_dword v133, off, s61 offset:800
		scratch_load_dword v134, off, s61 offset:804
		scratch_load_dword v135, off, s61 offset:808
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[132:135], v[88:91], a[160:163], v80, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:796
		scratch_load_dword v133, off, s61 offset:800
		scratch_load_dword v134, off, s61 offset:804
		scratch_load_dword v135, off, s61 offset:808
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:892
		scratch_load_dword v137, off, s61 offset:896
		scratch_load_dword v138, off, s61 offset:900
		scratch_load_dword v139, off, s61 offset:904
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[132:135], v[136:139], a[164:167], v80, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:796
		scratch_load_dword v133, off, s61 offset:800
		scratch_load_dword v134, off, s61 offset:804
		scratch_load_dword v135, off, s61 offset:808
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:860
		scratch_load_dword v137, off, s61 offset:864
		scratch_load_dword v138, off, s61 offset:868
		scratch_load_dword v139, off, s61 offset:872
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[132:135], v[136:139], a[168:171], v80, v96 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:796
		scratch_load_dword v133, off, s61 offset:800
		scratch_load_dword v134, off, s61 offset:804
		scratch_load_dword v135, off, s61 offset:808
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:956
		scratch_load_dword v137, off, s61 offset:960
		scratch_load_dword v138, off, s61 offset:964
		scratch_load_dword v139, off, s61 offset:968
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[132:135], v[136:139], a[172:175], v80, v96 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:796
		scratch_load_dword v133, off, s61 offset:800
		scratch_load_dword v134, off, s61 offset:804
		scratch_load_dword v135, off, s61 offset:808
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:924
		scratch_load_dword v137, off, s61 offset:928
		scratch_load_dword v138, off, s61 offset:932
		scratch_load_dword v139, off, s61 offset:936
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[132:135], v[136:139], a[176:179], v80, v100 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:796
		scratch_load_dword v133, off, s61 offset:800
		scratch_load_dword v134, off, s61 offset:804
		scratch_load_dword v135, off, s61 offset:808
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:1020
		scratch_load_dword v137, off, s61 offset:1024
		scratch_load_dword v138, off, s61 offset:1028
		scratch_load_dword v139, off, s61 offset:1032
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[132:135], v[136:139], a[180:183], v80, v100 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:796
		scratch_load_dword v133, off, s61 offset:800
		scratch_load_dword v134, off, s61 offset:804
		scratch_load_dword v135, off, s61 offset:808
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:988
		scratch_load_dword v137, off, s61 offset:992
		scratch_load_dword v138, off, s61 offset:996
		scratch_load_dword v139, off, s61 offset:1000
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[132:135], v[136:139], a[184:187], v80, v101 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:796
		scratch_load_dword v133, off, s61 offset:800
		scratch_load_dword v134, off, s61 offset:804
		scratch_load_dword v135, off, s61 offset:808
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[132:135], v[92:95], a[188:191], v80, v101 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:764
		scratch_load_dword v133, off, s61 offset:768
		scratch_load_dword v134, off, s61 offset:772
		scratch_load_dword v135, off, s61 offset:776
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[132:135], v[88:91], a[192:195], v81, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:764
		scratch_load_dword v133, off, s61 offset:768
		scratch_load_dword v134, off, s61 offset:772
		scratch_load_dword v135, off, s61 offset:776
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:892
		scratch_load_dword v137, off, s61 offset:896
		scratch_load_dword v138, off, s61 offset:900
		scratch_load_dword v139, off, s61 offset:904
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[132:135], v[136:139], a[196:199], v81, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:764
		scratch_load_dword v133, off, s61 offset:768
		scratch_load_dword v134, off, s61 offset:772
		scratch_load_dword v135, off, s61 offset:776
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:860
		scratch_load_dword v137, off, s61 offset:864
		scratch_load_dword v138, off, s61 offset:868
		scratch_load_dword v139, off, s61 offset:872
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[132:135], v[136:139], a[200:203], v81, v96 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:764
		scratch_load_dword v133, off, s61 offset:768
		scratch_load_dword v134, off, s61 offset:772
		scratch_load_dword v135, off, s61 offset:776
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:956
		scratch_load_dword v137, off, s61 offset:960
		scratch_load_dword v138, off, s61 offset:964
		scratch_load_dword v139, off, s61 offset:968
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[132:135], v[136:139], a[204:207], v81, v96 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:764
		scratch_load_dword v133, off, s61 offset:768
		scratch_load_dword v134, off, s61 offset:772
		scratch_load_dword v135, off, s61 offset:776
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:924
		scratch_load_dword v137, off, s61 offset:928
		scratch_load_dword v138, off, s61 offset:932
		scratch_load_dword v139, off, s61 offset:936
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[132:135], v[136:139], a[208:211], v81, v100 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:764
		scratch_load_dword v133, off, s61 offset:768
		scratch_load_dword v134, off, s61 offset:772
		scratch_load_dword v135, off, s61 offset:776
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:1020
		scratch_load_dword v137, off, s61 offset:1024
		scratch_load_dword v138, off, s61 offset:1028
		scratch_load_dword v139, off, s61 offset:1032
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[132:135], v[136:139], a[212:215], v81, v100 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:764
		scratch_load_dword v133, off, s61 offset:768
		scratch_load_dword v134, off, s61 offset:772
		scratch_load_dword v135, off, s61 offset:776
		s_mov_b32 s61, 0
		scratch_load_dword v136, off, s61 offset:988
		scratch_load_dword v137, off, s61 offset:992
		scratch_load_dword v138, off, s61 offset:996
		scratch_load_dword v139, off, s61 offset:1000
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[132:135], v[136:139], a[216:219], v81, v101 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:764
		scratch_load_dword v133, off, s61 offset:768
		scratch_load_dword v134, off, s61 offset:772
		scratch_load_dword v135, off, s61 offset:776
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[132:135], v[92:95], a[220:223], v81, v101 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:828
		scratch_load_dword v133, off, s61 offset:832
		scratch_load_dword v134, off, s61 offset:836
		scratch_load_dword v135, off, s61 offset:840
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[132:135], v[88:91], a[224:227], v81, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v88, off, s61 offset:828
		scratch_load_dword v89, off, s61 offset:832
		scratch_load_dword v90, off, s61 offset:836
		scratch_load_dword v91, off, s61 offset:840
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:892
		scratch_load_dword v133, off, s61 offset:896
		scratch_load_dword v134, off, s61 offset:900
		scratch_load_dword v135, off, s61 offset:904
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[88:91], v[132:135], a[228:231], v81, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v88, off, s61 offset:828
		scratch_load_dword v89, off, s61 offset:832
		scratch_load_dword v90, off, s61 offset:836
		scratch_load_dword v91, off, s61 offset:840
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:860
		scratch_load_dword v133, off, s61 offset:864
		scratch_load_dword v134, off, s61 offset:868
		scratch_load_dword v135, off, s61 offset:872
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[88:91], v[132:135], a[232:235], v81, v96 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v88, off, s61 offset:828
		scratch_load_dword v89, off, s61 offset:832
		scratch_load_dword v90, off, s61 offset:836
		scratch_load_dword v91, off, s61 offset:840
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:956
		scratch_load_dword v133, off, s61 offset:960
		scratch_load_dword v134, off, s61 offset:964
		scratch_load_dword v135, off, s61 offset:968
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[88:91], v[132:135], a[236:239], v81, v96 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v88, off, s61 offset:828
		scratch_load_dword v89, off, s61 offset:832
		scratch_load_dword v90, off, s61 offset:836
		scratch_load_dword v91, off, s61 offset:840
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:924
		scratch_load_dword v133, off, s61 offset:928
		scratch_load_dword v134, off, s61 offset:932
		scratch_load_dword v135, off, s61 offset:936
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[88:91], v[132:135], a[240:243], v81, v100 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v88, off, s61 offset:828
		scratch_load_dword v89, off, s61 offset:832
		scratch_load_dword v90, off, s61 offset:836
		scratch_load_dword v91, off, s61 offset:840
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:1020
		scratch_load_dword v133, off, s61 offset:1024
		scratch_load_dword v134, off, s61 offset:1028
		scratch_load_dword v135, off, s61 offset:1032
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[88:91], v[132:135], a[244:247], v81, v100 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v88, off, s61 offset:828
		scratch_load_dword v89, off, s61 offset:832
		scratch_load_dword v90, off, s61 offset:836
		scratch_load_dword v91, off, s61 offset:840
		s_mov_b32 s61, 0
		scratch_load_dword v132, off, s61 offset:988
		scratch_load_dword v133, off, s61 offset:992
		scratch_load_dword v134, off, s61 offset:996
		scratch_load_dword v135, off, s61 offset:1000
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[88:91], v[132:135], a[248:251], v81, v101 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v88, off, s61 offset:828
		scratch_load_dword v89, off, s61 offset:832
		scratch_load_dword v90, off, s61 offset:836
		scratch_load_dword v91, off, s61 offset:840
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[88:91], v[92:95], a[252:255], v81, v101 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s60, s60, 2
		s_cmp_lt_i32 s60, s11
		s_mov_b32 s61, 0
		scratch_load_dword v88, off, s61 offset:496
		scratch_load_dword v89, off, s61 offset:500
		scratch_load_dword v90, off, s61 offset:504
		scratch_load_dword v91, off, s61 offset:508
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v28, v88
		v_mov_b32_e32 v29, v89
		v_mov_b32_e32 v30, v90
		v_mov_b32_e32 v31, v91
		s_mov_b32 s61, 0
		scratch_load_dword v88, off, s61 offset:464
		scratch_load_dword v89, off, s61 offset:468
		scratch_load_dword v90, off, s61 offset:472
		scratch_load_dword v91, off, s61 offset:476
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v32, v88
		v_mov_b32_e32 v33, v89
		v_mov_b32_e32 v34, v90
		v_mov_b32_e32 v35, v91
		s_mov_b32 s61, 0
		scratch_load_dword v88, off, s61 offset:432
		scratch_load_dword v89, off, s61 offset:436
		scratch_load_dword v90, off, s61 offset:440
		scratch_load_dword v91, off, s61 offset:444
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v36, v88
		v_mov_b32_e32 v37, v89
		v_mov_b32_e32 v38, v90
		v_mov_b32_e32 v39, v91
		s_mov_b32 s61, 0
		scratch_load_dword v88, off, s61 offset:400
		scratch_load_dword v89, off, s61 offset:404
		scratch_load_dword v90, off, s61 offset:408
		scratch_load_dword v91, off, s61 offset:412
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v40, v88
		v_mov_b32_e32 v41, v89
		v_mov_b32_e32 v42, v90
		v_mov_b32_e32 v43, v91
		s_mov_b32 s61, 0
		scratch_load_dword v88, off, s61 offset:368
		scratch_load_dword v89, off, s61 offset:372
		scratch_load_dword v90, off, s61 offset:376
		scratch_load_dword v91, off, s61 offset:380
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v44, v88
		v_mov_b32_e32 v45, v89
		v_mov_b32_e32 v46, v90
		v_mov_b32_e32 v47, v91
		s_mov_b32 s61, 0
		scratch_load_dword v88, off, s61 offset:336
		scratch_load_dword v89, off, s61 offset:340
		scratch_load_dword v90, off, s61 offset:344
		scratch_load_dword v91, off, s61 offset:348
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v48, v88
		v_mov_b32_e32 v49, v89
		v_mov_b32_e32 v50, v90
		v_mov_b32_e32 v51, v91
		s_mov_b32 s61, 0
		scratch_load_dword v88, off, s61 offset:304
		scratch_load_dword v89, off, s61 offset:308
		scratch_load_dword v90, off, s61 offset:312
		scratch_load_dword v91, off, s61 offset:316
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v52, v88
		v_mov_b32_e32 v53, v89
		v_mov_b32_e32 v54, v90
		v_mov_b32_e32 v55, v91
		s_mov_b32 s61, 0
		scratch_load_dword v88, off, s61 offset:272
		scratch_load_dword v89, off, s61 offset:276
		scratch_load_dword v90, off, s61 offset:280
		scratch_load_dword v91, off, s61 offset:284
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v56, v88
		v_mov_b32_e32 v57, v89
		v_mov_b32_e32 v58, v90
		v_mov_b32_e32 v59, v91
		s_mov_b32 s61, 0
		scratch_load_dword v88, off, s61 offset:240
		scratch_load_dword v89, off, s61 offset:244
		scratch_load_dword v90, off, s61 offset:248
		scratch_load_dword v91, off, s61 offset:252
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v60, v88
		v_mov_b32_e32 v61, v89
		v_mov_b32_e32 v62, v90
		v_mov_b32_e32 v63, v91
		s_mov_b32 s61, 0
		scratch_load_dword v88, off, s61 offset:208
		scratch_load_dword v89, off, s61 offset:212
		scratch_load_dword v90, off, s61 offset:216
		scratch_load_dword v91, off, s61 offset:220
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v64, v88
		v_mov_b32_e32 v65, v89
		v_mov_b32_e32 v66, v90
		v_mov_b32_e32 v67, v91
		s_mov_b32 s61, 0
		scratch_load_dword v88, off, s61 offset:176
		scratch_load_dword v89, off, s61 offset:180
		scratch_load_dword v90, off, s61 offset:184
		scratch_load_dword v91, off, s61 offset:188
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v68, v88
		v_mov_b32_e32 v69, v89
		v_mov_b32_e32 v70, v90
		v_mov_b32_e32 v71, v91
		s_mov_b32 s61, 0
		scratch_load_dword v88, off, s61 offset:144
		scratch_load_dword v89, off, s61 offset:148
		scratch_load_dword v90, off, s61 offset:152
		scratch_load_dword v91, off, s61 offset:156
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v72, v88
		v_mov_b32_e32 v73, v89
		v_mov_b32_e32 v74, v90
		v_mov_b32_e32 v75, v91
		s_mov_b32 s61, 0
		scratch_load_dword v2, off, s61 offset:92
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v1, v2
		s_mov_b32 s61, 0
		scratch_load_dword v2, off, s61 offset:88
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v5, v2
		s_mov_b32 s61, 0
		scratch_load_dword v2, off, s61 offset:84
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v8, v2
		s_mov_b32 s61, 0
		scratch_load_dword v2, off, s61 offset:80
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v9, v2
		s_mov_b32 s61, 0
		scratch_load_dword v2, off, s61 offset:76
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v7, v2
		s_mov_b32 s61, 0
		scratch_load_dword v2, off, s61 offset:72
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v10, v2
		s_mov_b32 s61, 0
		scratch_load_dword v2, off, s61 offset:68
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v76, v2
		s_mov_b32 s61, 0
		scratch_load_dword v2, off, s61 offset:64
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v77, v2
		s_mov_b32 s61, 0
		scratch_store_dword off, v148, s61 offset:112
		scratch_store_dword off, v149, s61 offset:116
		scratch_store_dword off, v150, s61 offset:120
		scratch_store_dword off, v151, s61 offset:124
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v80, off, s0 offset:112
		scratch_load_dword v81, off, s0 offset:116
		scratch_load_dword v82, off, s0 offset:120
		scratch_load_dword v83, off, s0 offset:124
		s_add_i32 s0, s12, -1
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[12:15], v[44:47], v[80:83], v1, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s1, s0, 1
		s_lshl_b32 s0, s1, 16
		s_mov_b32 s1, 0
		scratch_load_dword v0, off, s1 offset:100
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v2, s0, v0
		s_mov_b32 s1, 0
		scratch_load_dword v0, off, s1 offset:516
		s_mov_b32 s1, 0
		scratch_load_dword v3, off, s1 offset:520
		s_waitcnt vmcnt(0)
		v_add3_u32 v4, v2, v3, v0
		ds_read_b128 v[84:87], v4 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[12:15], v[48:51], a[4:7], v1, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v4 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[12:15], v[52:55], a[8:11], v1, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v4 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[12:15], v[56:59], a[12:15], v1, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v4 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[12:15], v[60:63], a[16:19], v1, v76 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v4 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[12:15], v[64:67], a[20:23], v1, v76 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[104:107], v4 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[12:15], v[68:71], a[24:27], v1, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[108:111], v4 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[12:15], v[72:75], a[28:31], v1, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[12:15], v4 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[16:19], v[44:47], a[32:35], v1, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s1, 0
		scratch_load_dword v0, off, s1 offset:520
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v2, s0, v0
		s_mov_b32 s0, 0
		scratch_load_dword v0, off, s0 offset:96
		s_mov_b32 s0, 0
		scratch_load_dword v3, off, s0 offset:516
		s_waitcnt vmcnt(0)
		v_add3_u32 v4, v2, v0, v3
		ds_read_b128 v[112:115], v4 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[16:19], v[48:51], a[36:39], v1, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[116:119], v4 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[16:19], v[52:55], a[40:43], v1, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[120:123], v4 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[16:19], v[56:59], a[44:47], v1, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[124:127], v4 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[16:19], v[60:63], a[48:51], v1, v76 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[128:131], v4 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[16:19], v[64:67], a[52:55], v1, v76 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[132:135], v4 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[16:19], v[68:71], a[56:59], v1, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[136:139], v4 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[16:19], v[72:75], a[60:63], v1, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[16:19], v4 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[20:23], v[44:47], a[64:67], v5, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[20:23], v[48:51], a[68:71], v5, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[20:23], v[52:55], a[72:75], v5, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[20:23], v[56:59], a[76:79], v5, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[20:23], v[60:63], a[80:83], v5, v76 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[20:23], v[64:67], a[84:87], v5, v76 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[20:23], v[68:71], a[88:91], v5, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[20:23], v[72:75], a[92:95], v5, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[24:27], v[44:47], a[96:99], v5, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[24:27], v[48:51], a[100:103], v5, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[24:27], v[52:55], a[104:107], v5, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[24:27], v[56:59], a[108:111], v5, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[24:27], v[60:63], a[112:115], v5, v76 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[24:27], v[64:67], a[116:119], v5, v76 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[24:27], v[68:71], a[120:123], v5, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[24:27], v[72:75], a[124:127], v5, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[28:31], v[44:47], a[128:131], v8, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[28:31], v[48:51], a[132:135], v8, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[28:31], v[52:55], a[136:139], v8, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[28:31], v[56:59], a[140:143], v8, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[28:31], v[60:63], a[144:147], v8, v76 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[28:31], v[64:67], a[148:151], v8, v76 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[28:31], v[68:71], a[152:155], v8, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[28:31], v[72:75], a[156:159], v8, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[32:35], v[44:47], a[160:163], v8, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[32:35], v[48:51], a[164:167], v8, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[32:35], v[52:55], a[168:171], v8, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[32:35], v[56:59], a[172:175], v8, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[32:35], v[60:63], a[176:179], v8, v76 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[32:35], v[64:67], a[180:183], v8, v76 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[32:35], v[68:71], a[184:187], v8, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[32:35], v[72:75], a[188:191], v8, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[36:39], v[44:47], a[192:195], v9, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[36:39], v[48:51], a[196:199], v9, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[36:39], v[52:55], a[200:203], v9, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[36:39], v[56:59], a[204:207], v9, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[36:39], v[60:63], a[208:211], v9, v76 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[36:39], v[64:67], a[212:215], v9, v76 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[36:39], v[68:71], a[216:219], v9, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[36:39], v[72:75], a[220:223], v9, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[40:43], v[44:47], a[224:227], v9, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[40:43], v[48:51], a[228:231], v9, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[40:43], v[52:55], a[232:235], v9, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[40:43], v[56:59], a[236:239], v9, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[40:43], v[60:63], a[240:243], v9, v76 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[40:43], v[64:67], a[244:247], v9, v76 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[40:43], v[68:71], a[248:251], v9, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[40:43], v[72:75], a[252:255], v9, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[84:87], v[112:115], v[80:83], v1, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[84:87], v[116:119], a[4:7], v1, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[84:87], v[120:123], a[8:11], v1, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[84:87], v[124:127], a[12:15], v1, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[84:87], v[128:131], a[16:19], v1, v76 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[84:87], v[132:135], a[20:23], v1, v76 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[84:87], v[136:139], a[24:27], v1, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[84:87], v[16:19], a[28:31], v1, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[88:91], v[112:115], a[32:35], v1, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[88:91], v[116:119], a[36:39], v1, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[88:91], v[120:123], a[40:43], v1, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[88:91], v[124:127], a[44:47], v1, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[88:91], v[128:131], a[48:51], v1, v76 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[88:91], v[132:135], a[52:55], v1, v76 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[88:91], v[136:139], a[56:59], v1, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[88:91], v[16:19], a[60:63], v1, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[92:95], v[112:115], a[64:67], v5, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[92:95], v[116:119], a[68:71], v5, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[92:95], v[120:123], a[72:75], v5, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[92:95], v[124:127], a[76:79], v5, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[92:95], v[128:131], a[80:83], v5, v76 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[92:95], v[132:135], a[84:87], v5, v76 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[92:95], v[136:139], a[88:91], v5, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[92:95], v[16:19], a[92:95], v5, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[96:99], v[112:115], a[96:99], v5, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[96:99], v[116:119], a[100:103], v5, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[96:99], v[120:123], a[104:107], v5, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[96:99], v[124:127], a[108:111], v5, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[96:99], v[128:131], a[112:115], v5, v76 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[96:99], v[132:135], a[116:119], v5, v76 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[96:99], v[136:139], a[120:123], v5, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[96:99], v[16:19], a[124:127], v5, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[100:103], v[112:115], a[128:131], v8, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[100:103], v[116:119], a[132:135], v8, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[100:103], v[120:123], a[136:139], v8, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[100:103], v[124:127], a[140:143], v8, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[100:103], v[128:131], a[144:147], v8, v76 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[100:103], v[132:135], a[148:151], v8, v76 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[100:103], v[136:139], a[152:155], v8, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[100:103], v[16:19], a[156:159], v8, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[104:107], v[112:115], a[160:163], v8, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[104:107], v[116:119], a[164:167], v8, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[104:107], v[120:123], a[168:171], v8, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[104:107], v[124:127], a[172:175], v8, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[104:107], v[128:131], a[176:179], v8, v76 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[104:107], v[132:135], a[180:183], v8, v76 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[104:107], v[136:139], a[184:187], v8, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[104:107], v[16:19], a[188:191], v8, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[108:111], v[112:115], a[192:195], v9, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[108:111], v[116:119], a[196:199], v9, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[108:111], v[120:123], a[200:203], v9, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[108:111], v[124:127], a[204:207], v9, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[108:111], v[128:131], a[208:211], v9, v76 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[108:111], v[132:135], a[212:215], v9, v76 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[108:111], v[136:139], a[216:219], v9, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[108:111], v[16:19], a[220:223], v9, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[12:15], v[112:115], a[224:227], v9, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[12:15], v[116:119], a[228:231], v9, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[12:15], v[120:123], a[232:235], v9, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[12:15], v[124:127], a[236:239], v9, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[12:15], v[128:131], a[240:243], v9, v76 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[12:15], v[132:135], a[244:247], v9, v76 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[12:15], v[136:139], a[248:251], v9, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[12:15], v[16:19], a[252:255], v9, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s0, s12, 1
		s_lshl_b32 s1, s0, 16
		s_mov_b32 s2, 0
		scratch_load_dword v0, off, s2 offset:100
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v1, s1, v0
		s_mov_b32 s2, 0
		scratch_load_dword v0, off, s2 offset:516
		s_mov_b32 s2, 0
		scratch_load_dword v2, off, s2 offset:520
		s_waitcnt vmcnt(0)
		v_add3_u32 v3, v1, v2, v0
		ds_read_b128 v[4:7], v3
		ds_read_b128 v[8:11], v3 offset:1024
		ds_read_b128 v[12:15], v3 offset:2048
		ds_read_b128 v[16:19], v3 offset:3072
		ds_read_b128 v[20:23], v3 offset:4096
		ds_read_b128 v[24:27], v3 offset:5120
		ds_read_b128 v[28:31], v3 offset:6144
		ds_read_b128 v[32:35], v3 offset:7168
		s_mov_b32 s2, 0
		scratch_load_dword v0, off, s2 offset:520
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v1, s1, v0
		s_mov_b32 s1, 0
		scratch_load_dword v0, off, s1 offset:96
		s_mov_b32 s1, 0
		scratch_load_dword v2, off, s1 offset:516
		s_waitcnt vmcnt(0)
		v_add3_u32 v36, v1, v0, v2
		ds_read_b128 v[40:43], v36 offset:32768
		ds_read_b128 v[44:47], v36 offset:33792
		ds_read_b128 v[48:51], v36 offset:34816
		ds_read_b128 v[52:55], v36 offset:35840
		ds_read_b128 v[56:59], v36 offset:36864
		ds_read_b128 v[60:63], v36 offset:37888
		ds_read_b128 v[64:67], v36 offset:38912
		ds_read_b128 v[68:71], v36 offset:39936
		s_lshl_b32 s1, s0, 12
		s_add_i32 s0, s1, 0x20000
		s_mov_b32 s1, 0
		scratch_load_dword v0, off, s1 offset:108
		s_mov_b32 s1, 0
		scratch_load_dword v1, off, s1 offset:512
		s_waitcnt vmcnt(0)
		v_add3_u32 v2, s0, v0, v1
		ds_read_b32 v0, v2
		ds_read_b32 v1, v2 offset:256
		ds_read_b32 v37, v2 offset:512
		ds_read_b32 v38, v2 offset:768
		s_mov_b32 s1, 0
		scratch_load_dword v2, off, s1 offset:104
		s_mov_b32 s1, 0
		scratch_load_dword v39, off, s1 offset:512
		s_waitcnt vmcnt(0)
		v_add3_u32 v72, s0, v39, v2
		ds_read_b32 v2, v72 offset:2048
		ds_read_b32 v39, v72 offset:2304
		ds_read_b32 v73, v72 offset:2560
		ds_read_b32 v74, v72 offset:2816
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[4:7], v[40:43], v[80:83], v0, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[76:79], v3 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[4:7], v[44:47], a[4:7], v0, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[84:87], v3 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[4:7], v[48:51], a[8:11], v0, v39 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v3 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[4:7], v[52:55], a[12:15], v0, v39 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v3 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[4:7], v[56:59], a[16:19], v0, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v3 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[4:7], v[60:63], a[20:23], v0, v73 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v3 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[4:7], v[64:67], a[24:27], v0, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[104:107], v3 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[4:7], v[68:71], a[28:31], v0, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[4:7], v3 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[8:11], v[40:43], a[32:35], v0, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[108:111], v36 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[8:11], v[44:47], a[36:39], v0, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[112:115], v36 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[8:11], v[48:51], a[40:43], v0, v39 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[116:119], v36 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[8:11], v[52:55], a[44:47], v0, v39 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[120:123], v36 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[8:11], v[56:59], a[48:51], v0, v73 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[124:127], v36 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[8:11], v[60:63], a[52:55], v0, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[128:131], v36 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[8:11], v[64:67], a[56:59], v0, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[132:135], v36 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[8:11], v[68:71], a[60:63], v0, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[8:11], v36 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[12:15], v[40:43], a[64:67], v1, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[12:15], v[44:47], a[68:71], v1, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[12:15], v[48:51], a[72:75], v1, v39 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[12:15], v[52:55], a[76:79], v1, v39 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[12:15], v[56:59], a[80:83], v1, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[12:15], v[60:63], a[84:87], v1, v73 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[12:15], v[64:67], a[88:91], v1, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[12:15], v[68:71], a[92:95], v1, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[16:19], v[40:43], a[96:99], v1, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[16:19], v[44:47], a[100:103], v1, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[16:19], v[48:51], a[104:107], v1, v39 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[16:19], v[52:55], a[108:111], v1, v39 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[16:19], v[56:59], a[112:115], v1, v73 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[16:19], v[60:63], a[116:119], v1, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[16:19], v[64:67], a[120:123], v1, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[16:19], v[68:71], a[124:127], v1, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[20:23], v[40:43], a[128:131], v37, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[20:23], v[44:47], a[132:135], v37, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[20:23], v[48:51], a[136:139], v37, v39 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[20:23], v[52:55], a[140:143], v37, v39 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[20:23], v[56:59], a[144:147], v37, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[20:23], v[60:63], a[148:151], v37, v73 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[20:23], v[64:67], a[152:155], v37, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[20:23], v[68:71], a[156:159], v37, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[24:27], v[40:43], a[160:163], v37, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[24:27], v[44:47], a[164:167], v37, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[24:27], v[48:51], a[168:171], v37, v39 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[24:27], v[52:55], a[172:175], v37, v39 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[24:27], v[56:59], a[176:179], v37, v73 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[24:27], v[60:63], a[180:183], v37, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[24:27], v[64:67], a[184:187], v37, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[24:27], v[68:71], a[188:191], v37, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[28:31], v[40:43], a[192:195], v38, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[28:31], v[44:47], a[196:199], v38, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[28:31], v[48:51], a[200:203], v38, v39 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[28:31], v[52:55], a[204:207], v38, v39 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[28:31], v[56:59], a[208:211], v38, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[28:31], v[60:63], a[212:215], v38, v73 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[28:31], v[64:67], a[216:219], v38, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[28:31], v[68:71], a[220:223], v38, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[32:35], v[40:43], a[224:227], v38, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[32:35], v[44:47], a[228:231], v38, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[32:35], v[48:51], a[232:235], v38, v39 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[32:35], v[52:55], a[236:239], v38, v39 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[32:35], v[56:59], a[240:243], v38, v73 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[32:35], v[60:63], a[244:247], v38, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[32:35], v[64:67], a[248:251], v38, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[32:35], v[68:71], a[252:255], v38, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[76:79], v[108:111], v[80:83], v0, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[76:79], v[112:115], a[4:7], v0, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[76:79], v[116:119], a[8:11], v0, v39 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[76:79], v[120:123], a[12:15], v0, v39 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[76:79], v[124:127], a[16:19], v0, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[76:79], v[128:131], a[20:23], v0, v73 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[76:79], v[132:135], a[24:27], v0, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[76:79], v[8:11], a[28:31], v0, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[84:87], v[108:111], a[32:35], v0, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[84:87], v[112:115], a[36:39], v0, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[84:87], v[116:119], a[40:43], v0, v39 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[84:87], v[120:123], a[44:47], v0, v39 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[84:87], v[124:127], a[48:51], v0, v73 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[84:87], v[128:131], a[52:55], v0, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[84:87], v[132:135], a[56:59], v0, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[84:87], v[8:11], a[60:63], v0, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[88:91], v[108:111], a[64:67], v1, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[88:91], v[112:115], a[68:71], v1, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[88:91], v[116:119], a[72:75], v1, v39 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[88:91], v[120:123], a[76:79], v1, v39 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[88:91], v[124:127], a[80:83], v1, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[88:91], v[128:131], a[84:87], v1, v73 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[88:91], v[132:135], a[88:91], v1, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[88:91], v[8:11], a[92:95], v1, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[92:95], v[108:111], a[96:99], v1, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[92:95], v[112:115], a[100:103], v1, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[92:95], v[116:119], a[104:107], v1, v39 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[92:95], v[120:123], a[108:111], v1, v39 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[92:95], v[124:127], a[112:115], v1, v73 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[92:95], v[128:131], a[116:119], v1, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[92:95], v[132:135], a[120:123], v1, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[92:95], v[8:11], a[124:127], v1, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[96:99], v[108:111], a[128:131], v37, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[96:99], v[112:115], a[132:135], v37, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[96:99], v[116:119], a[136:139], v37, v39 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[96:99], v[120:123], a[140:143], v37, v39 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[96:99], v[124:127], a[144:147], v37, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[96:99], v[128:131], a[148:151], v37, v73 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[96:99], v[132:135], a[152:155], v37, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[96:99], v[8:11], a[156:159], v37, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[100:103], v[108:111], a[160:163], v37, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[100:103], v[112:115], a[164:167], v37, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[100:103], v[116:119], a[168:171], v37, v39 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[100:103], v[120:123], a[172:175], v37, v39 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[100:103], v[124:127], a[176:179], v37, v73 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[100:103], v[128:131], a[180:183], v37, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[100:103], v[132:135], a[184:187], v37, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[100:103], v[8:11], a[188:191], v37, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[104:107], v[108:111], a[192:195], v38, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[104:107], v[112:115], a[196:199], v38, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[104:107], v[116:119], a[200:203], v38, v39 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[104:107], v[120:123], a[204:207], v38, v39 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[104:107], v[124:127], a[208:211], v38, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[104:107], v[128:131], a[212:215], v38, v73 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[104:107], v[132:135], a[216:219], v38, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[104:107], v[8:11], a[220:223], v38, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[4:7], v[108:111], a[224:227], v38, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[4:7], v[112:115], a[228:231], v38, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[4:7], v[116:119], a[232:235], v38, v39 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[4:7], v[120:123], a[236:239], v38, v39 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[4:7], v[124:127], a[240:243], v38, v73 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[4:7], v[128:131], a[244:247], v38, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[4:7], v[132:135], a[248:251], v38, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[4:7], v[8:11], a[252:255], v38, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v80, v81
		v_cvt_pk_f16_f32 v1, v82, v83
		v_accvgpr_read_b32 v2, a1
		v_lshlrev_b32_e32 v3, 3, v2
		v_accvgpr_read_b32 v2, a0
		v_lshl_add_u32 v4, v2, 15, v3
		s_lshl_b32 s0, s13, 21
		s_lshl_b32 s1, s14, 17
		s_add_i32 s2, s0, s1
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen
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
		.amdhsa_group_segment_fixed_size 24576
		.amdhsa_private_segment_fixed_size 1036
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
		.amdhsa_next_free_vgpr 480
		.amdhsa_next_free_sgpr 68
		.amdhsa_accum_offset 224
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
	.set .Lwmma_f16_matmul_tiled.num_vgpr, 224
	.set .Lwmma_f16_matmul_tiled.num_agpr, 256
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 68
	.set .Lwmma_f16_matmul_tiled.num_named_barrier, 0
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 1036
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
    .private_segment_fixed_size: 1036
    .sgpr_count:     68
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     480
    .agpr_count:     256
    .vgpr_spill_count: 263
    .wavefront_size: 64
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
