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
		v_accvgpr_write_b32 a0, v4
		v_accvgpr_write_b32 a1, v5
		v_accvgpr_write_b32 a2, v6
		v_accvgpr_write_b32 a3, v7
		v_readfirstlane_b32 s8, v0
		s_lshl_b32 s9, s13, 20
		v_lshrrev_b32_e32 v1, 6, v0
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v3, 0x22000, v2
		ds_write_b32 v3, v1
		v_lshlrev_b32_e32 v2, 16, v1
		v_add_u32_e32 v3, s9, v2
		v_and_b32_e32 v4, 63, v0
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v6, 0x22400, v5
		ds_write_b32 v6, v4
		v_lshrrev_b32_e32 v5, 2, v4
		v_lshlrev_b32_e32 v6, 12, v5
		v_lshrrev_b32_e32 v5, 3, v4
		v_and_b32_e32 v7, 3, v5
		v_and_b32_e32 v5, 3, v4
		v_xor_b32_e32 v8, v7, v5
		v_lshlrev_b32_e32 v5, 4, v8
		v_add3_u32 v7, v3, v6, v5
		s_add_i32 s10, s9, 0x40000
		v_add_u32_e32 v3, s10, v2
		v_add3_u32 v8, v3, v6, v5
		s_add_i32 s10, s9, 0x80000
		v_add_u32_e32 v3, s10, v2
		v_add3_u32 v9, v3, v6, v5
		s_add_i32 s10, s9, 0xc0000
		v_add_u32_e32 v3, s10, v2
		v_add3_u32 v10, v3, v6, v5
		v_add3_u32 v3, s9, 64, v2
		v_add3_u32 v11, v3, v6, v5
		s_add_i32 s10, s9, 0x40040
		v_add_u32_e32 v3, s10, v2
		v_add3_u32 v12, v3, v6, v5
		s_add_i32 s10, s9, 0x80040
		v_add_u32_e32 v3, s10, v2
		v_add3_u32 v13, v3, v6, v5
		s_add_i32 s10, s9, 0xc0040
		v_add_u32_e32 v3, s10, v2
		v_add3_u32 v14, v3, v6, v5
		s_lshl_b32 s10, s14, 20
		v_add_u32_e32 v3, s10, v2
		v_add3_u32 v15, v3, v6, v5
		s_add_i32 s11, s10, 0x40000
		v_add_u32_e32 v3, s11, v2
		v_add3_u32 v16, v3, v6, v5
		s_add_i32 s11, s10, 0x80000
		v_add_u32_e32 v3, s11, v2
		v_add3_u32 v17, v3, v6, v5
		s_add_i32 s11, s10, 0xc0000
		v_add_u32_e32 v3, s11, v2
		v_add3_u32 v18, v3, v6, v5
		v_add3_u32 v3, s10, 64, v2
		v_add3_u32 v19, v3, v6, v5
		s_add_i32 s11, s10, 0x40040
		v_add_u32_e32 v3, s11, v2
		v_add3_u32 v20, v3, v6, v5
		s_add_i32 s11, s10, 0x80040
		v_add_u32_e32 v3, s11, v2
		v_add3_u32 v21, v3, v6, v5
		s_add_i32 s11, s10, 0xc0040
		v_add_u32_e32 v3, s11, v2
		v_add3_u32 v22, v3, v6, v5
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
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v9, s[20:23], 0 offen lds
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v11, s[20:23], 0 offen lds
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v15, s[0:3], 0 offen lds
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v16, s[0:3], 0 offen lds
		s_mov_b32 m0, s37
		s_nop 0
		buffer_load_dwordx4 v17, s[0:3], 0 offen lds
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v18, s[0:3], 0 offen lds
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v19, s[0:3], 0 offen lds
		s_mov_b32 m0, s40
		s_nop 0
		buffer_load_dwordx4 v20, s[0:3], 0 offen lds
		s_mov_b32 m0, s41
		s_nop 0
		buffer_load_dwordx4 v21, s[0:3], 0 offen lds
		s_mov_b32 m0, s42
		s_nop 0
		buffer_load_dwordx4 v22, s[0:3], 0 offen lds
		s_lshl_b32 s43, s14, 16
		s_add_i32 s44, s9, s43
		v_lshrrev_b32_e32 v3, 7, v0
		v_lshlrev_b32_e32 v7, 10, v3
		s_mov_b32 s45, 0
		scratch_store_dword off, v7, s45 offset:104
		v_lshlrev_b32_e32 v8, 4, v4
		v_add3_u32 v9, s44, v7, v8
		s_lshr_b32 s45, s8, 7
		s_lshl_b32 s8, s45, 10
		v_and_b32_e32 v10, 1, v1
		v_lshlrev_b32_e32 v1, 10, v10
		s_mov_b32 s45, 0
		scratch_store_dword off, v1, s45 offset:108
		v_add3_u32 v11, s44, v8, v1
		s_and_b32 s44, s11, 1
		s_lshl_b32 s11, s44, 10
		s_add_i32 s44, s11, 0x800
		s_add_i32 m0, s8, 0x20000
		s_nop 0
		buffer_load_dwordx4 v9, s[4:7], 0 offen lds
		s_add_i32 m0, s11, 0x20800
		s_nop 0
		buffer_load_dwordx4 v11, s[24:27], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v9, 13, v3
		v_lshlrev_b32_e32 v3, 2, v0
		v_add_u32_e32 v11, 0x24400, v3
		ds_write_b32 v11, v9
		v_and_b32_e32 v3, 15, v0
		v_lshlrev_b32_e32 v11, 6, v3
		s_mov_b32 s45, 0
		scratch_store_dword off, v11, s45 offset:116
		v_lshrrev_b32_e32 v12, 4, v4
		v_lshrrev_b32_e32 v13, 1, v3
		v_and_b32_e32 v3, 3, v13
		v_xor_b32_e32 v13, v12, v3
		v_lshlrev_b32_e32 v3, 4, v13
		s_mov_b32 s45, 0
		scratch_store_dword off, v3, s45 offset:120
		v_add3_u32 v12, v9, v11, v3
		ds_read_b128 v[16:19], v12
		ds_read_b128 v[20:23], v12 offset:1024
		ds_read_b128 v[24:27], v12 offset:2048
		ds_read_b128 v[28:31], v12 offset:3072
		ds_read_b128 v[32:35], v12 offset:4096
		ds_read_b128 v[36:39], v12 offset:5120
		ds_read_b128 v[40:43], v12 offset:6144
		ds_read_b128 v[44:47], v12 offset:7168
		v_lshlrev_b32_e32 v12, 13, v10
		v_lshlrev_b32_e32 v10, 2, v0
		v_add_u32_e32 v13, 0x24000, v10
		ds_write_b32 v13, v12
		v_lshlrev_b32_e32 v10, 2, v0
		v_add_u32_e32 v13, 0x22800, v10
		ds_write_b32 v13, v12
		v_add3_u32 v10, v11, v12, v3
		ds_read_b128 v[48:51], v10 offset:32768
		ds_read_b128 v[52:55], v10 offset:33792
		ds_read_b128 v[56:59], v10 offset:34816
		ds_read_b128 v[60:63], v10 offset:35840
		ds_read_b128 v[64:67], v10 offset:36864
		ds_read_b128 v[68:71], v10 offset:37888
		ds_read_b128 v[72:75], v10 offset:38912
		ds_read_b128 v[76:79], v10 offset:39936
		v_add_u32_e32 v10, 0x20000, v7
		v_lshlrev_b32_e32 v13, 2, v4
		s_mov_b32 s45, 0
		scratch_store_dword off, v13, s45 offset:112
		v_add_u32_e32 v4, v10, v13
		ds_read_b32 v10, v4
		ds_read_b32 v14, v4 offset:256
		ds_read_b32 v15, v4 offset:512
		ds_read_b32 v80, v4 offset:768
		v_add_u32_e32 v4, 0x20000, v13
		v_add_u32_e32 v81, v4, v1
		ds_read_b32 v4, v81 offset:2048
		ds_read_b32 v82, v81 offset:2304
		ds_read_b32 v83, v81 offset:2560
		ds_read_b32 v84, v81 offset:2816
		s_waitcnt lgkmcnt(0)
		s_add_i32 s45, s9, 0x80
		v_add_u32_e32 v81, s45, v2
		v_add3_u32 v85, v81, v6, v5
		s_add_i32 s45, s9, 0x40080
		v_add_u32_e32 v81, s45, v2
		v_add3_u32 v86, v81, v6, v5
		s_add_i32 s45, s9, 0x80080
		v_add_u32_e32 v81, s45, v2
		v_add3_u32 v87, v81, v6, v5
		s_add_i32 s45, s9, 0xc0080
		v_add_u32_e32 v81, s45, v2
		v_add3_u32 v88, v81, v6, v5
		s_add_i32 s45, s9, 0xc0
		v_add_u32_e32 v81, s45, v2
		v_add3_u32 v89, v81, v6, v5
		s_add_i32 s45, s9, 0x400c0
		v_add_u32_e32 v81, s45, v2
		v_add3_u32 v90, v81, v6, v5
		s_add_i32 s45, s9, 0x800c0
		v_add_u32_e32 v81, s45, v2
		v_add3_u32 v91, v81, v6, v5
		s_add_i32 s45, s9, 0xc00c0
		v_add_u32_e32 v81, s45, v2
		v_add3_u32 v92, v81, v6, v5
		s_add_i32 s45, s10, 0x80
		v_add_u32_e32 v81, s45, v2
		v_add3_u32 v93, v81, v6, v5
		s_add_i32 s45, s10, 0x40080
		v_add_u32_e32 v81, s45, v2
		v_add3_u32 v94, v81, v6, v5
		s_add_i32 s45, s10, 0x80080
		v_add_u32_e32 v81, s45, v2
		v_add3_u32 v95, v81, v6, v5
		s_add_i32 s45, s10, 0xc0080
		v_add_u32_e32 v81, s45, v2
		v_add3_u32 v96, v81, v6, v5
		s_add_i32 s45, s10, 0xc0
		v_add_u32_e32 v81, s45, v2
		v_add3_u32 v97, v81, v6, v5
		s_add_i32 s45, s10, 0x400c0
		v_add_u32_e32 v81, s45, v2
		v_add3_u32 v98, v81, v6, v5
		s_add_i32 s45, s10, 0x800c0
		v_add_u32_e32 v81, s45, v2
		v_add3_u32 v99, v81, v6, v5
		s_add_i32 s45, s10, 0xc00c0
		v_add_u32_e32 v81, s45, v2
		v_add3_u32 v2, v81, v6, v5
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
		buffer_load_dwordx4 v85, s[20:23], 0 offen lds
		s_mov_b32 m0, s45
		s_nop 0
		buffer_load_dwordx4 v86, s[20:23], 0 offen lds
		s_mov_b32 m0, s46
		s_nop 0
		buffer_load_dwordx4 v87, s[20:23], 0 offen lds
		s_mov_b32 m0, s47
		s_nop 0
		buffer_load_dwordx4 v88, s[20:23], 0 offen lds
		s_mov_b32 m0, s48
		s_nop 0
		buffer_load_dwordx4 v89, s[20:23], 0 offen lds
		s_mov_b32 m0, s49
		s_nop 0
		buffer_load_dwordx4 v90, s[20:23], 0 offen lds
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v91, s[20:23], 0 offen lds
		s_mov_b32 m0, s51
		s_nop 0
		buffer_load_dwordx4 v92, s[20:23], 0 offen lds
		s_mov_b32 m0, s52
		s_nop 0
		buffer_load_dwordx4 v93, s[0:3], 0 offen lds
		s_mov_b32 m0, s53
		s_nop 0
		buffer_load_dwordx4 v94, s[0:3], 0 offen lds
		s_mov_b32 m0, s54
		s_nop 0
		buffer_load_dwordx4 v95, s[0:3], 0 offen lds
		s_mov_b32 m0, s55
		s_nop 0
		buffer_load_dwordx4 v96, s[0:3], 0 offen lds
		s_mov_b32 m0, s56
		s_nop 0
		buffer_load_dwordx4 v97, s[0:3], 0 offen lds
		s_mov_b32 m0, s57
		s_nop 0
		buffer_load_dwordx4 v98, s[0:3], 0 offen lds
		s_mov_b32 m0, s58
		s_nop 0
		buffer_load_dwordx4 v99, s[0:3], 0 offen lds
		s_mov_b32 m0, s59
		s_nop 0
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_add_i32 s60, s9, 0x800
		s_add_i32 s9, s60, s43
		v_add3_u32 v2, s9, v7, v8
		s_add_i32 s43, s8, 0x1000
		v_add3_u32 v5, s9, v8, v1
		s_add_i32 s9, s11, 0x1800
		s_add_i32 m0, s8, 0x21000
		s_nop 0
		buffer_load_dwordx4 v2, s[4:7], 0 offen lds
		s_add_i32 m0, s11, 0x21800
		s_nop 0
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s11, s12, 1
		s_mov_b32 s60, 2
		v_mov_b32_e32 v86, s13
		v_mov_b32_e32 v87, 0
		s_mov_b32 s62, 0x100000
		s_mov_b32 s63, 0
		v_mov_b32_e32 v88, s62
		v_mov_b32_e32 v89, s63
		v_mul_lo_u32 v90, v88, v86
		v_mul_hi_u32 v91, v88, v86
		v_mul_lo_u32 v2, v88, v87
		v_add_u32_e32 v91, v91, v2
		v_mul_lo_u32 v2, v89, v86
		v_add_u32_e32 v91, v91, v2
		s_mov_b32 s62, 1
		s_mov_b32 s63, 0
		v_mov_b32_e32 v92, v0
		v_mov_b32_e32 v93, 0
		v_mov_b32_e32 v94, s62
		v_mov_b32_e32 v95, s63
		v_mul_lo_u32 v96, v94, v92
		v_mul_hi_u32 v97, v94, v92
		v_mul_lo_u32 v2, v94, v93
		v_add_u32_e32 v97, v97, v2
		v_mul_lo_u32 v2, v95, v92
		v_add_u32_e32 v97, v97, v2
		v_lshrrev_b64 v[98:99], 6, v[96:97]
		s_mov_b32 s62, 0x10000
		s_mov_b32 s63, 0
		v_mov_b32_e32 v100, s62
		v_mov_b32_e32 v101, s63
		v_mul_lo_u32 v102, v100, v98
		v_mul_hi_u32 v103, v100, v98
		v_mul_lo_u32 v2, v100, v99
		v_add_u32_e32 v103, v103, v2
		v_mul_lo_u32 v2, v101, v98
		v_add_u32_e32 v103, v103, v2
		v_add_co_u32_e64 v104, vcc, v90, v102
		v_addc_co_u32_e64 v105, vcc, v91, v103, vcc
		v_mov_b32_e32 v2, 63
		v_and_b32_e32 v106, v92, v2
		v_and_b32_e32 v107, v87, v87
		v_mul_lo_u32 v92, v94, v106
		v_mul_hi_u32 v93, v94, v106
		v_mul_lo_u32 v2, v94, v107
		v_add_u32_e32 v93, v93, v2
		v_mul_lo_u32 v2, v95, v106
		v_add_u32_e32 v93, v93, v2
		v_lshrrev_b64 v[94:95], 2, v[92:93]
		s_mov_b32 s62, 0x1000
		s_mov_b32 s63, 0
		v_mov_b32_e32 v108, s62
		v_mov_b32_e32 v109, s63
		v_mul_lo_u32 v110, v108, v94
		v_mul_hi_u32 v111, v108, v94
		v_mul_lo_u32 v2, v108, v95
		v_add_u32_e32 v111, v111, v2
		v_mul_lo_u32 v2, v109, v94
		v_add_u32_e32 v111, v111, v2
		v_add_co_u32_e64 v94, vcc, v104, v110
		v_addc_co_u32_e64 v95, vcc, v105, v111, vcc
		v_lshrrev_b64 v[104:105], 3, v[92:93]
		v_mov_b32_e32 v2, 3
		v_and_b32_e32 v92, v104, v2
		v_and_b32_e32 v93, v105, v87
		v_and_b32_e32 v104, v106, v2
		v_and_b32_e32 v105, v107, v87
		v_xor_b32_e32 v108, v92, v104
		v_xor_b32_e32 v109, v93, v105
		s_mov_b32 s62, 16
		s_mov_b32 s63, 0
		v_mov_b32_e32 v92, s62
		v_mov_b32_e32 v93, s63
		v_mul_lo_u32 v104, v92, v108
		v_mul_hi_u32 v105, v92, v108
		v_mul_lo_u32 v2, v92, v109
		v_add_u32_e32 v105, v105, v2
		v_mul_lo_u32 v2, v93, v108
		v_add_u32_e32 v105, v105, v2
		v_add_co_u32_e64 v108, vcc, v94, v104
		v_addc_co_u32_e64 v109, vcc, v95, v105, vcc
		s_mov_b32 s62, 0x80
		s_mov_b32 s63, 0
		v_mov_b32_e32 v94, s62
		v_mov_b32_e32 v95, s63
		v_mov_b32_e32 v2, 0x40000
		v_add_co_u32_e64 v112, vcc, v90, v2
		v_addc_co_u32_e64 v113, vcc, v91, 0, vcc
		v_add_co_u32_e64 v114, vcc, v112, v102
		v_addc_co_u32_e64 v115, vcc, v113, v103, vcc
		v_add_co_u32_e64 v112, vcc, v114, v110
		v_addc_co_u32_e64 v113, vcc, v115, v111, vcc
		v_add_co_u32_e64 v114, vcc, v112, v104
		v_addc_co_u32_e64 v115, vcc, v113, v105, vcc
		v_mov_b32_e32 v5, 0x80000
		v_add_co_u32_e64 v112, vcc, v90, v5
		v_addc_co_u32_e64 v113, vcc, v91, 0, vcc
		v_add_co_u32_e64 v116, vcc, v112, v102
		v_addc_co_u32_e64 v117, vcc, v113, v103, vcc
		v_add_co_u32_e64 v112, vcc, v116, v110
		v_addc_co_u32_e64 v113, vcc, v117, v111, vcc
		v_add_co_u32_e64 v116, vcc, v112, v104
		v_addc_co_u32_e64 v117, vcc, v113, v105, vcc
		v_mov_b32_e32 v6, 0xc0000
		v_add_co_u32_e64 v112, vcc, v90, v6
		v_addc_co_u32_e64 v113, vcc, v91, 0, vcc
		v_add_co_u32_e64 v118, vcc, v112, v102
		v_addc_co_u32_e64 v119, vcc, v113, v103, vcc
		v_add_co_u32_e64 v112, vcc, v118, v110
		v_addc_co_u32_e64 v113, vcc, v119, v111, vcc
		v_add_co_u32_e64 v118, vcc, v112, v104
		v_addc_co_u32_e64 v119, vcc, v113, v105, vcc
		v_mov_b32_e32 v8, 64
		v_add_co_u32_e64 v112, vcc, v90, v8
		v_addc_co_u32_e64 v113, vcc, v91, 0, vcc
		v_add_co_u32_e64 v120, vcc, v112, v102
		v_addc_co_u32_e64 v121, vcc, v113, v103, vcc
		v_add_co_u32_e64 v112, vcc, v120, v110
		v_addc_co_u32_e64 v113, vcc, v121, v111, vcc
		v_add_co_u32_e64 v120, vcc, v112, v104
		v_addc_co_u32_e64 v121, vcc, v113, v105, vcc
		v_mov_b32_e32 v81, 0x40040
		v_add_co_u32_e64 v112, vcc, v90, v81
		v_addc_co_u32_e64 v113, vcc, v91, 0, vcc
		v_add_co_u32_e64 v122, vcc, v112, v102
		v_addc_co_u32_e64 v123, vcc, v113, v103, vcc
		v_add_co_u32_e64 v112, vcc, v122, v110
		v_addc_co_u32_e64 v113, vcc, v123, v111, vcc
		v_add_co_u32_e64 v122, vcc, v112, v104
		v_addc_co_u32_e64 v123, vcc, v113, v105, vcc
		v_mov_b32_e32 v85, 0x80040
		v_add_co_u32_e64 v112, vcc, v90, v85
		v_addc_co_u32_e64 v113, vcc, v91, 0, vcc
		v_add_co_u32_e64 v124, vcc, v112, v102
		v_addc_co_u32_e64 v125, vcc, v113, v103, vcc
		v_add_co_u32_e64 v112, vcc, v124, v110
		v_addc_co_u32_e64 v113, vcc, v125, v111, vcc
		v_add_co_u32_e64 v124, vcc, v112, v104
		v_addc_co_u32_e64 v125, vcc, v113, v105, vcc
		v_mov_b32_e32 v112, 0xc0040
		v_add_co_u32_e64 v126, vcc, v90, v112
		v_addc_co_u32_e64 v127, vcc, v91, 0, vcc
		v_add_co_u32_e64 v128, vcc, v126, v102
		v_addc_co_u32_e64 v129, vcc, v127, v103, vcc
		v_add_co_u32_e64 v126, vcc, v128, v110
		v_addc_co_u32_e64 v127, vcc, v129, v111, vcc
		v_add_co_u32_e64 v128, vcc, v126, v104
		v_addc_co_u32_e64 v129, vcc, v127, v105, vcc
		v_mov_b32_e32 v126, s14
		v_mov_b32_e32 v127, 0
		v_mul_lo_u32 v130, v88, v126
		v_mul_hi_u32 v131, v88, v126
		v_mul_lo_u32 v113, v88, v127
		v_add_u32_e32 v131, v131, v113
		v_mul_lo_u32 v113, v89, v126
		v_add_u32_e32 v131, v131, v113
		v_add_co_u32_e64 v88, vcc, v130, v102
		v_addc_co_u32_e64 v89, vcc, v131, v103, vcc
		v_add_co_u32_e64 v132, vcc, v88, v110
		v_addc_co_u32_e64 v133, vcc, v89, v111, vcc
		v_add_co_u32_e64 v88, vcc, v132, v104
		v_addc_co_u32_e64 v89, vcc, v133, v105, vcc
		v_add_co_u32_e64 v132, vcc, v130, v2
		v_addc_co_u32_e64 v133, vcc, v131, 0, vcc
		v_add_co_u32_e64 v134, vcc, v132, v102
		v_addc_co_u32_e64 v135, vcc, v133, v103, vcc
		v_add_co_u32_e64 v132, vcc, v134, v110
		v_addc_co_u32_e64 v133, vcc, v135, v111, vcc
		v_add_co_u32_e64 v134, vcc, v132, v104
		v_addc_co_u32_e64 v135, vcc, v133, v105, vcc
		v_add_co_u32_e64 v132, vcc, v130, v5
		v_addc_co_u32_e64 v133, vcc, v131, 0, vcc
		v_add_co_u32_e64 v136, vcc, v132, v102
		v_addc_co_u32_e64 v137, vcc, v133, v103, vcc
		v_add_co_u32_e64 v132, vcc, v136, v110
		v_addc_co_u32_e64 v133, vcc, v137, v111, vcc
		v_add_co_u32_e64 v136, vcc, v132, v104
		v_addc_co_u32_e64 v137, vcc, v133, v105, vcc
		v_add_co_u32_e64 v132, vcc, v130, v6
		v_addc_co_u32_e64 v133, vcc, v131, 0, vcc
		v_add_co_u32_e64 v138, vcc, v132, v102
		v_addc_co_u32_e64 v139, vcc, v133, v103, vcc
		v_add_co_u32_e64 v132, vcc, v138, v110
		v_addc_co_u32_e64 v133, vcc, v139, v111, vcc
		v_add_co_u32_e64 v138, vcc, v132, v104
		v_addc_co_u32_e64 v139, vcc, v133, v105, vcc
		v_add_co_u32_e64 v132, vcc, v130, v8
		v_addc_co_u32_e64 v133, vcc, v131, 0, vcc
		v_add_co_u32_e64 v140, vcc, v132, v102
		v_addc_co_u32_e64 v141, vcc, v133, v103, vcc
		v_add_co_u32_e64 v132, vcc, v140, v110
		v_addc_co_u32_e64 v133, vcc, v141, v111, vcc
		v_add_co_u32_e64 v140, vcc, v132, v104
		v_addc_co_u32_e64 v141, vcc, v133, v105, vcc
		v_add_co_u32_e64 v132, vcc, v130, v81
		v_addc_co_u32_e64 v133, vcc, v131, 0, vcc
		v_add_co_u32_e64 v142, vcc, v132, v102
		v_addc_co_u32_e64 v143, vcc, v133, v103, vcc
		v_add_co_u32_e64 v132, vcc, v142, v110
		v_addc_co_u32_e64 v133, vcc, v143, v111, vcc
		v_add_co_u32_e64 v142, vcc, v132, v104
		v_addc_co_u32_e64 v143, vcc, v133, v105, vcc
		v_add_co_u32_e64 v132, vcc, v130, v85
		v_addc_co_u32_e64 v133, vcc, v131, 0, vcc
		v_add_co_u32_e64 v144, vcc, v132, v102
		v_addc_co_u32_e64 v145, vcc, v133, v103, vcc
		v_add_co_u32_e64 v132, vcc, v144, v110
		v_addc_co_u32_e64 v133, vcc, v145, v111, vcc
		v_add_co_u32_e64 v144, vcc, v132, v104
		v_addc_co_u32_e64 v145, vcc, v133, v105, vcc
		v_add_co_u32_e64 v132, vcc, v130, v112
		v_addc_co_u32_e64 v133, vcc, v131, 0, vcc
		v_add_co_u32_e64 v112, vcc, v132, v102
		v_addc_co_u32_e64 v113, vcc, v133, v103, vcc
		v_add_co_u32_e64 v132, vcc, v112, v110
		v_addc_co_u32_e64 v133, vcc, v113, v111, vcc
		v_add_co_u32_e64 v112, vcc, v132, v104
		v_addc_co_u32_e64 v113, vcc, v133, v105, vcc
		v_mul_lo_u32 v132, v100, v126
		v_mul_hi_u32 v133, v100, v126
		v_mul_lo_u32 v2, v100, v127
		v_add_u32_e32 v133, v133, v2
		v_mul_lo_u32 v2, v101, v126
		v_add_u32_e32 v133, v133, v2
		v_add_co_u32_e64 v100, vcc, v90, v132
		v_addc_co_u32_e64 v101, vcc, v91, v133, vcc
		v_lshrrev_b64 v[126:127], 7, v[96:97]
		s_mov_b32 s62, 0x400
		s_mov_b32 s63, 0
		v_mov_b32_e32 v96, s62
		v_mov_b32_e32 v97, s63
		v_mul_lo_u32 v146, v96, v126
		v_mul_hi_u32 v147, v96, v126
		v_mul_lo_u32 v2, v96, v127
		v_add_u32_e32 v147, v147, v2
		v_mul_lo_u32 v2, v97, v126
		v_add_u32_e32 v147, v147, v2
		v_add_co_u32_e64 v126, vcc, v100, v146
		v_addc_co_u32_e64 v127, vcc, v101, v147, vcc
		v_mul_lo_u32 v148, v92, v106
		v_mul_hi_u32 v149, v92, v106
		v_mul_lo_u32 v2, v92, v107
		v_add_u32_e32 v149, v149, v2
		v_mul_lo_u32 v2, v93, v106
		v_add_u32_e32 v149, v149, v2
		v_add_co_u32_e64 v92, vcc, v126, v148
		v_addc_co_u32_e64 v93, vcc, v127, v149, vcc
		s_mov_b32 s62, 0x800
		s_mov_b32 s63, 0
		v_mov_b32_e32 v106, s62
		v_mov_b32_e32 v107, s63
		v_add_co_u32_e64 v126, vcc, v100, v148
		v_addc_co_u32_e64 v127, vcc, v101, v149, vcc
		v_mov_b32_e32 v2, 1
		v_and_b32_e32 v100, v98, v2
		v_and_b32_e32 v101, v99, v87
		v_mul_lo_u32 v86, v96, v100
		v_mul_hi_u32 v87, v96, v100
		v_mul_lo_u32 v2, v96, v101
		v_add_u32_e32 v87, v87, v2
		v_mul_lo_u32 v2, v97, v100
		v_add_u32_e32 v87, v87, v2
		v_add_co_u32_e64 v96, vcc, v126, v86
		v_addc_co_u32_e64 v97, vcc, v127, v87, vcc
		v_mov_b32_e32 v2, 0x80
		v_add_co_u32_e64 v98, vcc, v90, v2
		v_addc_co_u32_e64 v99, vcc, v91, 0, vcc
		v_add_co_u32_e64 v100, vcc, v98, v102
		v_addc_co_u32_e64 v101, vcc, v99, v103, vcc
		v_add_co_u32_e64 v98, vcc, v100, v110
		v_addc_co_u32_e64 v99, vcc, v101, v111, vcc
		v_add_co_u32_e64 v100, vcc, v98, v104
		v_addc_co_u32_e64 v101, vcc, v99, v105, vcc
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v6, 0x24800, v5
		ds_write_b32 v6, v100
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v6, 0x24c00, v5
		ds_write_b32 v6, v101
		v_mov_b32_e32 v5, 0x40080
		v_add_co_u32_e64 v98, vcc, v90, v5
		v_addc_co_u32_e64 v99, vcc, v91, 0, vcc
		v_add_co_u32_e64 v100, vcc, v98, v102
		v_addc_co_u32_e64 v101, vcc, v99, v103, vcc
		v_add_co_u32_e64 v98, vcc, v100, v110
		v_addc_co_u32_e64 v99, vcc, v101, v111, vcc
		v_add_co_u32_e64 v100, vcc, v98, v104
		v_addc_co_u32_e64 v101, vcc, v99, v105, vcc
		v_lshlrev_b32_e32 v6, 2, v0
		v_add_u32_e32 v8, 0x25000, v6
		ds_write_b32 v8, v100
		v_lshlrev_b32_e32 v6, 2, v0
		v_add_u32_e32 v8, 0x25400, v6
		ds_write_b32 v8, v101
		v_mov_b32_e32 v6, 0x80080
		v_add_co_u32_e64 v98, vcc, v90, v6
		v_addc_co_u32_e64 v99, vcc, v91, 0, vcc
		v_add_co_u32_e64 v100, vcc, v98, v102
		v_addc_co_u32_e64 v101, vcc, v99, v103, vcc
		v_add_co_u32_e64 v98, vcc, v100, v110
		v_addc_co_u32_e64 v99, vcc, v101, v111, vcc
		v_add_co_u32_e64 v100, vcc, v98, v104
		v_addc_co_u32_e64 v101, vcc, v99, v105, vcc
		v_lshlrev_b32_e32 v8, 2, v0
		v_add_u32_e32 v81, 0x25800, v8
		ds_write_b32 v81, v100
		v_lshlrev_b32_e32 v8, 2, v0
		v_add_u32_e32 v81, 0x25c00, v8
		ds_write_b32 v81, v101
		v_mov_b32_e32 v8, 0xc0080
		v_add_co_u32_e64 v98, vcc, v90, v8
		v_addc_co_u32_e64 v99, vcc, v91, 0, vcc
		v_add_co_u32_e64 v100, vcc, v98, v102
		v_addc_co_u32_e64 v101, vcc, v99, v103, vcc
		v_add_co_u32_e64 v98, vcc, v100, v110
		v_addc_co_u32_e64 v99, vcc, v101, v111, vcc
		v_add_co_u32_e64 v100, vcc, v98, v104
		v_addc_co_u32_e64 v101, vcc, v99, v105, vcc
		v_lshlrev_b32_e32 v81, 2, v0
		v_add_u32_e32 v85, 0x26000, v81
		ds_write_b32 v85, v100
		v_lshlrev_b32_e32 v81, 2, v0
		v_add_u32_e32 v85, 0x26400, v81
		ds_write_b32 v85, v101
		v_mov_b32_e32 v81, 0xc0
		v_add_co_u32_e64 v98, vcc, v90, v81
		v_addc_co_u32_e64 v99, vcc, v91, 0, vcc
		v_add_co_u32_e64 v100, vcc, v98, v102
		v_addc_co_u32_e64 v101, vcc, v99, v103, vcc
		v_add_co_u32_e64 v98, vcc, v100, v110
		v_addc_co_u32_e64 v99, vcc, v101, v111, vcc
		v_add_co_u32_e64 v100, vcc, v98, v104
		v_addc_co_u32_e64 v101, vcc, v99, v105, vcc
		v_lshlrev_b32_e32 v85, 2, v0
		v_add_u32_e32 v98, 0x26800, v85
		ds_write_b32 v98, v100
		v_lshlrev_b32_e32 v85, 2, v0
		v_add_u32_e32 v98, 0x26c00, v85
		ds_write_b32 v98, v101
		v_mov_b32_e32 v85, 0x400c0
		v_add_co_u32_e64 v98, vcc, v90, v85
		v_addc_co_u32_e64 v99, vcc, v91, 0, vcc
		v_add_co_u32_e64 v100, vcc, v98, v102
		v_addc_co_u32_e64 v101, vcc, v99, v103, vcc
		v_add_co_u32_e64 v98, vcc, v100, v110
		v_addc_co_u32_e64 v99, vcc, v101, v111, vcc
		v_add_co_u32_e64 v100, vcc, v98, v104
		v_addc_co_u32_e64 v101, vcc, v99, v105, vcc
		v_lshlrev_b32_e32 v98, 2, v0
		v_add_u32_e32 v99, 0x27000, v98
		ds_write_b32 v99, v100
		v_lshlrev_b32_e32 v98, 2, v0
		v_add_u32_e32 v99, 0x27400, v98
		ds_write_b32 v99, v101
		v_mov_b32_e32 v98, 0x800c0
		v_add_co_u32_e64 v100, vcc, v90, v98
		v_addc_co_u32_e64 v101, vcc, v91, 0, vcc
		v_add_co_u32_e64 v126, vcc, v100, v102
		v_addc_co_u32_e64 v127, vcc, v101, v103, vcc
		v_add_co_u32_e64 v100, vcc, v126, v110
		v_addc_co_u32_e64 v101, vcc, v127, v111, vcc
		v_add_co_u32_e64 v126, vcc, v100, v104
		v_addc_co_u32_e64 v127, vcc, v101, v105, vcc
		v_lshlrev_b32_e32 v99, 2, v0
		v_add_u32_e32 v100, 0x27800, v99
		ds_write_b32 v100, v126
		v_lshlrev_b32_e32 v99, 2, v0
		v_add_u32_e32 v100, 0x27c00, v99
		ds_write_b32 v100, v127
		v_mov_b32_e32 v99, 0xc00c0
		v_add_co_u32_e64 v100, vcc, v90, v99
		v_addc_co_u32_e64 v101, vcc, v91, 0, vcc
		v_add_co_u32_e64 v126, vcc, v100, v102
		v_addc_co_u32_e64 v127, vcc, v101, v103, vcc
		v_add_co_u32_e64 v100, vcc, v126, v110
		v_addc_co_u32_e64 v101, vcc, v127, v111, vcc
		v_add_co_u32_e64 v126, vcc, v100, v104
		v_addc_co_u32_e64 v127, vcc, v101, v105, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v126, s61
		scratch_store_dword off, v127, s61 offset:4
		v_add_co_u32_e64 v100, vcc, v130, v2
		v_addc_co_u32_e64 v101, vcc, v131, 0, vcc
		v_add_co_u32_e64 v126, vcc, v100, v102
		v_addc_co_u32_e64 v127, vcc, v101, v103, vcc
		v_add_co_u32_e64 v100, vcc, v126, v110
		v_addc_co_u32_e64 v101, vcc, v127, v111, vcc
		v_add_co_u32_e64 v126, vcc, v100, v104
		v_addc_co_u32_e64 v127, vcc, v101, v105, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v126, s61 offset:8
		scratch_store_dword off, v127, s61 offset:12
		v_add_co_u32_e64 v100, vcc, v130, v5
		v_addc_co_u32_e64 v101, vcc, v131, 0, vcc
		v_add_co_u32_e64 v126, vcc, v100, v102
		v_addc_co_u32_e64 v127, vcc, v101, v103, vcc
		v_add_co_u32_e64 v100, vcc, v126, v110
		v_addc_co_u32_e64 v101, vcc, v127, v111, vcc
		v_add_co_u32_e64 v126, vcc, v100, v104
		v_addc_co_u32_e64 v127, vcc, v101, v105, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v126, s61 offset:16
		scratch_store_dword off, v127, s61 offset:20
		v_add_co_u32_e64 v100, vcc, v130, v6
		v_addc_co_u32_e64 v101, vcc, v131, 0, vcc
		v_add_co_u32_e64 v126, vcc, v100, v102
		v_addc_co_u32_e64 v127, vcc, v101, v103, vcc
		v_add_co_u32_e64 v100, vcc, v126, v110
		v_addc_co_u32_e64 v101, vcc, v127, v111, vcc
		v_add_co_u32_e64 v126, vcc, v100, v104
		v_addc_co_u32_e64 v127, vcc, v101, v105, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v126, s61 offset:24
		scratch_store_dword off, v127, s61 offset:28
		v_add_co_u32_e64 v100, vcc, v130, v8
		v_addc_co_u32_e64 v101, vcc, v131, 0, vcc
		v_add_co_u32_e64 v126, vcc, v100, v102
		v_addc_co_u32_e64 v127, vcc, v101, v103, vcc
		v_add_co_u32_e64 v100, vcc, v126, v110
		v_addc_co_u32_e64 v101, vcc, v127, v111, vcc
		v_add_co_u32_e64 v126, vcc, v100, v104
		v_addc_co_u32_e64 v127, vcc, v101, v105, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v126, s61 offset:32
		scratch_store_dword off, v127, s61 offset:36
		v_add_co_u32_e64 v100, vcc, v130, v81
		v_addc_co_u32_e64 v101, vcc, v131, 0, vcc
		v_add_co_u32_e64 v126, vcc, v100, v102
		v_addc_co_u32_e64 v127, vcc, v101, v103, vcc
		v_add_co_u32_e64 v100, vcc, v126, v110
		v_addc_co_u32_e64 v101, vcc, v127, v111, vcc
		v_add_co_u32_e64 v126, vcc, v100, v104
		v_addc_co_u32_e64 v127, vcc, v101, v105, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v126, s61 offset:40
		scratch_store_dword off, v127, s61 offset:44
		v_add_co_u32_e64 v100, vcc, v130, v85
		v_addc_co_u32_e64 v101, vcc, v131, 0, vcc
		v_add_co_u32_e64 v126, vcc, v100, v102
		v_addc_co_u32_e64 v127, vcc, v101, v103, vcc
		v_add_co_u32_e64 v100, vcc, v126, v110
		v_addc_co_u32_e64 v101, vcc, v127, v111, vcc
		v_add_co_u32_e64 v126, vcc, v100, v104
		v_addc_co_u32_e64 v127, vcc, v101, v105, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v126, s61 offset:48
		scratch_store_dword off, v127, s61 offset:52
		v_add_co_u32_e64 v100, vcc, v130, v98
		v_addc_co_u32_e64 v101, vcc, v131, 0, vcc
		v_add_co_u32_e64 v126, vcc, v100, v102
		v_addc_co_u32_e64 v127, vcc, v101, v103, vcc
		v_add_co_u32_e64 v100, vcc, v126, v110
		v_addc_co_u32_e64 v101, vcc, v127, v111, vcc
		v_add_co_u32_e64 v126, vcc, v100, v104
		v_addc_co_u32_e64 v127, vcc, v101, v105, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v126, s61 offset:56
		scratch_store_dword off, v127, s61 offset:60
		v_add_co_u32_e64 v100, vcc, v130, v99
		v_addc_co_u32_e64 v101, vcc, v131, 0, vcc
		v_add_co_u32_e64 v98, vcc, v100, v102
		v_addc_co_u32_e64 v99, vcc, v101, v103, vcc
		v_add_co_u32_e64 v100, vcc, v98, v110
		v_addc_co_u32_e64 v101, vcc, v99, v111, vcc
		v_add_co_u32_e64 v98, vcc, v100, v104
		v_addc_co_u32_e64 v99, vcc, v101, v105, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v98, s61 offset:64
		scratch_store_dword off, v99, s61 offset:68
		v_mov_b32_e32 v2, 0x800
		v_add_co_u32_e64 v98, vcc, v90, v2
		v_addc_co_u32_e64 v99, vcc, v91, 0, vcc
		v_add_co_u32_e64 v90, vcc, v98, v132
		v_addc_co_u32_e64 v91, vcc, v99, v133, vcc
		v_add_co_u32_e64 v98, vcc, v90, v146
		v_addc_co_u32_e64 v99, vcc, v91, v147, vcc
		v_add_co_u32_e64 v100, vcc, v98, v148
		v_addc_co_u32_e64 v101, vcc, v99, v149, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v100, s61 offset:72
		scratch_store_dword off, v101, s61 offset:76
		v_add_co_u32_e64 v98, vcc, v90, v148
		v_addc_co_u32_e64 v99, vcc, v91, v149, vcc
		v_add_co_u32_e64 v90, vcc, v98, v86
		v_addc_co_u32_e64 v91, vcc, v99, v87, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v90, s61 offset:80
		scratch_store_dword off, v91, s61 offset:84
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a4, v100
		v_accvgpr_write_b32 a5, v101
		v_accvgpr_write_b32 a6, v102
		v_accvgpr_write_b32 a7, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a8, v100
		v_accvgpr_write_b32 a9, v101
		v_accvgpr_write_b32 a10, v102
		v_accvgpr_write_b32 a11, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a12, v100
		v_accvgpr_write_b32 a13, v101
		v_accvgpr_write_b32 a14, v102
		v_accvgpr_write_b32 a15, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a16, v100
		v_accvgpr_write_b32 a17, v101
		v_accvgpr_write_b32 a18, v102
		v_accvgpr_write_b32 a19, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a20, v100
		v_accvgpr_write_b32 a21, v101
		v_accvgpr_write_b32 a22, v102
		v_accvgpr_write_b32 a23, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a24, v100
		v_accvgpr_write_b32 a25, v101
		v_accvgpr_write_b32 a26, v102
		v_accvgpr_write_b32 a27, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a28, v100
		v_accvgpr_write_b32 a29, v101
		v_accvgpr_write_b32 a30, v102
		v_accvgpr_write_b32 a31, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a32, v100
		v_accvgpr_write_b32 a33, v101
		v_accvgpr_write_b32 a34, v102
		v_accvgpr_write_b32 a35, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a36, v100
		v_accvgpr_write_b32 a37, v101
		v_accvgpr_write_b32 a38, v102
		v_accvgpr_write_b32 a39, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a40, v100
		v_accvgpr_write_b32 a41, v101
		v_accvgpr_write_b32 a42, v102
		v_accvgpr_write_b32 a43, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a44, v100
		v_accvgpr_write_b32 a45, v101
		v_accvgpr_write_b32 a46, v102
		v_accvgpr_write_b32 a47, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a48, v100
		v_accvgpr_write_b32 a49, v101
		v_accvgpr_write_b32 a50, v102
		v_accvgpr_write_b32 a51, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a52, v100
		v_accvgpr_write_b32 a53, v101
		v_accvgpr_write_b32 a54, v102
		v_accvgpr_write_b32 a55, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a56, v100
		v_accvgpr_write_b32 a57, v101
		v_accvgpr_write_b32 a58, v102
		v_accvgpr_write_b32 a59, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a60, v100
		v_accvgpr_write_b32 a61, v101
		v_accvgpr_write_b32 a62, v102
		v_accvgpr_write_b32 a63, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a64, v100
		v_accvgpr_write_b32 a65, v101
		v_accvgpr_write_b32 a66, v102
		v_accvgpr_write_b32 a67, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a68, v100
		v_accvgpr_write_b32 a69, v101
		v_accvgpr_write_b32 a70, v102
		v_accvgpr_write_b32 a71, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a72, v100
		v_accvgpr_write_b32 a73, v101
		v_accvgpr_write_b32 a74, v102
		v_accvgpr_write_b32 a75, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a76, v100
		v_accvgpr_write_b32 a77, v101
		v_accvgpr_write_b32 a78, v102
		v_accvgpr_write_b32 a79, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a80, v100
		v_accvgpr_write_b32 a81, v101
		v_accvgpr_write_b32 a82, v102
		v_accvgpr_write_b32 a83, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a84, v100
		v_accvgpr_write_b32 a85, v101
		v_accvgpr_write_b32 a86, v102
		v_accvgpr_write_b32 a87, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a88, v100
		v_accvgpr_write_b32 a89, v101
		v_accvgpr_write_b32 a90, v102
		v_accvgpr_write_b32 a91, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a92, v100
		v_accvgpr_write_b32 a93, v101
		v_accvgpr_write_b32 a94, v102
		v_accvgpr_write_b32 a95, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a96, v100
		v_accvgpr_write_b32 a97, v101
		v_accvgpr_write_b32 a98, v102
		v_accvgpr_write_b32 a99, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a100, v100
		v_accvgpr_write_b32 a101, v101
		v_accvgpr_write_b32 a102, v102
		v_accvgpr_write_b32 a103, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a104, v100
		v_accvgpr_write_b32 a105, v101
		v_accvgpr_write_b32 a106, v102
		v_accvgpr_write_b32 a107, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a108, v100
		v_accvgpr_write_b32 a109, v101
		v_accvgpr_write_b32 a110, v102
		v_accvgpr_write_b32 a111, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a112, v100
		v_accvgpr_write_b32 a113, v101
		v_accvgpr_write_b32 a114, v102
		v_accvgpr_write_b32 a115, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a116, v100
		v_accvgpr_write_b32 a117, v101
		v_accvgpr_write_b32 a118, v102
		v_accvgpr_write_b32 a119, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a120, v100
		v_accvgpr_write_b32 a121, v101
		v_accvgpr_write_b32 a122, v102
		v_accvgpr_write_b32 a123, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a124, v100
		v_accvgpr_write_b32 a125, v101
		v_accvgpr_write_b32 a126, v102
		v_accvgpr_write_b32 a127, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a128, v100
		v_accvgpr_write_b32 a129, v101
		v_accvgpr_write_b32 a130, v102
		v_accvgpr_write_b32 a131, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a132, v100
		v_accvgpr_write_b32 a133, v101
		v_accvgpr_write_b32 a134, v102
		v_accvgpr_write_b32 a135, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a136, v100
		v_accvgpr_write_b32 a137, v101
		v_accvgpr_write_b32 a138, v102
		v_accvgpr_write_b32 a139, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a140, v100
		v_accvgpr_write_b32 a141, v101
		v_accvgpr_write_b32 a142, v102
		v_accvgpr_write_b32 a143, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a144, v100
		v_accvgpr_write_b32 a145, v101
		v_accvgpr_write_b32 a146, v102
		v_accvgpr_write_b32 a147, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a148, v100
		v_accvgpr_write_b32 a149, v101
		v_accvgpr_write_b32 a150, v102
		v_accvgpr_write_b32 a151, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a152, v100
		v_accvgpr_write_b32 a153, v101
		v_accvgpr_write_b32 a154, v102
		v_accvgpr_write_b32 a155, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a156, v100
		v_accvgpr_write_b32 a157, v101
		v_accvgpr_write_b32 a158, v102
		v_accvgpr_write_b32 a159, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a160, v100
		v_accvgpr_write_b32 a161, v101
		v_accvgpr_write_b32 a162, v102
		v_accvgpr_write_b32 a163, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a164, v100
		v_accvgpr_write_b32 a165, v101
		v_accvgpr_write_b32 a166, v102
		v_accvgpr_write_b32 a167, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a168, v100
		v_accvgpr_write_b32 a169, v101
		v_accvgpr_write_b32 a170, v102
		v_accvgpr_write_b32 a171, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a172, v100
		v_accvgpr_write_b32 a173, v101
		v_accvgpr_write_b32 a174, v102
		v_accvgpr_write_b32 a175, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a176, v100
		v_accvgpr_write_b32 a177, v101
		v_accvgpr_write_b32 a178, v102
		v_accvgpr_write_b32 a179, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a180, v100
		v_accvgpr_write_b32 a181, v101
		v_accvgpr_write_b32 a182, v102
		v_accvgpr_write_b32 a183, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a184, v100
		v_accvgpr_write_b32 a185, v101
		v_accvgpr_write_b32 a186, v102
		v_accvgpr_write_b32 a187, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a188, v100
		v_accvgpr_write_b32 a189, v101
		v_accvgpr_write_b32 a190, v102
		v_accvgpr_write_b32 a191, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a192, v100
		v_accvgpr_write_b32 a193, v101
		v_accvgpr_write_b32 a194, v102
		v_accvgpr_write_b32 a195, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a196, v100
		v_accvgpr_write_b32 a197, v101
		v_accvgpr_write_b32 a198, v102
		v_accvgpr_write_b32 a199, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a200, v100
		v_accvgpr_write_b32 a201, v101
		v_accvgpr_write_b32 a202, v102
		v_accvgpr_write_b32 a203, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a204, v100
		v_accvgpr_write_b32 a205, v101
		v_accvgpr_write_b32 a206, v102
		v_accvgpr_write_b32 a207, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a208, v100
		v_accvgpr_write_b32 a209, v101
		v_accvgpr_write_b32 a210, v102
		v_accvgpr_write_b32 a211, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a212, v100
		v_accvgpr_write_b32 a213, v101
		v_accvgpr_write_b32 a214, v102
		v_accvgpr_write_b32 a215, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a216, v100
		v_accvgpr_write_b32 a217, v101
		v_accvgpr_write_b32 a218, v102
		v_accvgpr_write_b32 a219, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a220, v100
		v_accvgpr_write_b32 a221, v101
		v_accvgpr_write_b32 a222, v102
		v_accvgpr_write_b32 a223, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a224, v100
		v_accvgpr_write_b32 a225, v101
		v_accvgpr_write_b32 a226, v102
		v_accvgpr_write_b32 a227, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a228, v100
		v_accvgpr_write_b32 a229, v101
		v_accvgpr_write_b32 a230, v102
		v_accvgpr_write_b32 a231, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a232, v100
		v_accvgpr_write_b32 a233, v101
		v_accvgpr_write_b32 a234, v102
		v_accvgpr_write_b32 a235, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a236, v100
		v_accvgpr_write_b32 a237, v101
		v_accvgpr_write_b32 a238, v102
		v_accvgpr_write_b32 a239, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a240, v100
		v_accvgpr_write_b32 a241, v101
		v_accvgpr_write_b32 a242, v102
		v_accvgpr_write_b32 a243, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a244, v100
		v_accvgpr_write_b32 a245, v101
		v_accvgpr_write_b32 a246, v102
		v_accvgpr_write_b32 a247, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a248, v100
		v_accvgpr_write_b32 a249, v101
		v_accvgpr_write_b32 a250, v102
		v_accvgpr_write_b32 a251, v103
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_accvgpr_write_b32 a252, v100
		v_accvgpr_write_b32 a253, v101
		v_accvgpr_write_b32 a254, v102
		v_accvgpr_write_b32 a255, v103
.Lwmma_f16_matmul_tiled.loop_head_0:
		v_mov_b32_e32 v86, s60
		v_mov_b32_e32 v87, 0
		v_mul_lo_u32 v90, v94, v86
		v_mul_hi_u32 v91, v94, v86
		v_mul_lo_u32 v2, v94, v87
		v_add_u32_e32 v91, v91, v2
		v_mul_lo_u32 v2, v95, v86
		v_add_u32_e32 v91, v91, v2
		v_add_co_u32_e64 v98, vcc, v108, v90
		v_addc_co_u32_e64 v99, vcc, v109, v91, vcc
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v5, 0x22c00, v2
		ds_write_b32 v5, v98
		v_add_co_u32_e64 v98, vcc, v114, v90
		v_addc_co_u32_e64 v99, vcc, v115, v91, vcc
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v5, 0x23000, v2
		ds_write_b32 v5, v98
		v_add_co_u32_e64 v98, vcc, v116, v90
		v_addc_co_u32_e64 v99, vcc, v117, v91, vcc
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v5, 0x23400, v2
		ds_write_b32 v5, v98
		v_add_co_u32_e64 v98, vcc, v118, v90
		v_addc_co_u32_e64 v99, vcc, v119, v91, vcc
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v5, 0x23800, v2
		ds_write_b32 v5, v98
		v_add_co_u32_e64 v98, vcc, v120, v90
		v_addc_co_u32_e64 v99, vcc, v121, v91, vcc
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v5, 0x23c00, v2
		ds_write_b32 v5, v98
		v_add_co_u32_e64 v98, vcc, v122, v90
		v_addc_co_u32_e64 v99, vcc, v123, v91, vcc
		v_add_co_u32_e64 v100, vcc, v124, v90
		v_addc_co_u32_e64 v101, vcc, v125, v91, vcc
		v_add_co_u32_e64 v102, vcc, v128, v90
		v_addc_co_u32_e64 v103, vcc, v129, v91, vcc
		v_add_co_u32_e64 v104, vcc, v88, v90
		v_addc_co_u32_e64 v105, vcc, v89, v91, vcc
		v_add_co_u32_e64 v110, vcc, v134, v90
		v_addc_co_u32_e64 v111, vcc, v135, v91, vcc
		v_add_co_u32_e64 v126, vcc, v136, v90
		v_addc_co_u32_e64 v127, vcc, v137, v91, vcc
		v_add_co_u32_e64 v130, vcc, v138, v90
		v_addc_co_u32_e64 v131, vcc, v139, v91, vcc
		v_add_co_u32_e64 v132, vcc, v140, v90
		v_addc_co_u32_e64 v133, vcc, v141, v91, vcc
		v_add_co_u32_e64 v146, vcc, v142, v90
		v_addc_co_u32_e64 v147, vcc, v143, v91, vcc
		v_add_co_u32_e64 v148, vcc, v144, v90
		v_addc_co_u32_e64 v149, vcc, v145, v91, vcc
		v_add_co_u32_e64 v150, vcc, v112, v90
		v_addc_co_u32_e64 v151, vcc, v113, v91, vcc
		v_mul_lo_u32 v152, v106, v86
		v_mul_hi_u32 v153, v106, v86
		v_mul_lo_u32 v2, v106, v87
		v_add_u32_e32 v153, v153, v2
		v_mul_lo_u32 v2, v107, v86
		v_add_u32_e32 v153, v153, v2
		v_add_co_u32_e64 v86, vcc, v92, v152
		v_addc_co_u32_e64 v87, vcc, v93, v153, vcc
		v_add_co_u32_e64 v154, vcc, v96, v152
		v_addc_co_u32_e64 v155, vcc, v97, v153, vcc
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[16:19], v[48:51], a[0:3], v10, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s61, s60, 1
		s_lshl_b32 s62, s61, 16
		v_add_u32_e32 v2, s62, v9
		v_add3_u32 v5, v2, v11, v3
		ds_read_b128 v[156:159], v5 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[16:19], v[52:55], a[4:7], v10, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[160:163], v5 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[16:19], v[56:59], a[8:11], v10, v82 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[164:167], v5 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[16:19], v[60:63], a[12:15], v10, v82 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[168:171], v5 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[16:19], v[64:67], a[16:19], v10, v83 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[172:175], v5 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[16:19], v[68:71], a[20:23], v10, v83 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[176:179], v5 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[16:19], v[72:75], a[24:27], v10, v84 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[180:183], v5 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[16:19], v[76:79], a[28:31], v10, v84 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[184:187], v5 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[20:23], v[48:51], a[32:35], v10, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, s62, v11
		v_add3_u32 v5, v2, v12, v3
		ds_read_b128 v[188:191], v5 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[20:23], v[52:55], a[36:39], v10, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[192:195], v5 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[20:23], v[56:59], a[40:43], v10, v82 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[196:199], v5 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[20:23], v[60:63], a[44:47], v10, v82 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[200:203], v5 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[20:23], v[64:67], a[48:51], v10, v83 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[204:207], v5 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[20:23], v[68:71], a[52:55], v10, v83 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[208:211], v5 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[20:23], v[72:75], a[56:59], v10, v84 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[212:215], v5 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[20:23], v[76:79], a[60:63], v10, v84 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v5 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[24:27], v[48:51], a[64:67], v14, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v5, 0x22c00, v2
		s_waitcnt lgkmcnt(4)
		ds_read_b32 v2, v5
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[24:27], v[52:55], a[68:71], v14, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s28
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v5, 0x23000, v2
		ds_read_b32 v2, v5
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[24:27], v[56:59], a[72:75], v14, v82 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s29
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v5, 0x23400, v2
		ds_read_b32 v2, v5
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[24:27], v[60:63], a[76:79], v14, v82 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s30
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v5, 0x23800, v2
		ds_read_b32 v2, v5
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[24:27], v[64:67], a[80:83], v14, v83 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s31
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v5, 0x23c00, v2
		ds_read_b32 v2, v5
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[24:27], v[68:71], a[84:87], v14, v83 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v98, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[24:27], v[72:75], a[88:91], v14, v84 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v100, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[24:27], v[76:79], a[92:95], v14, v84 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v102, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[28:31], v[48:51], a[96:99], v14, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v104, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[28:31], v[52:55], a[100:103], v14, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v110, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[28:31], v[56:59], a[104:107], v14, v82 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s37
		s_nop 0
		buffer_load_dwordx4 v126, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[28:31], v[60:63], a[108:111], v14, v82 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v130, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[28:31], v[64:67], a[112:115], v14, v83 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v132, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[28:31], v[68:71], a[116:119], v14, v83 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s40
		s_nop 0
		buffer_load_dwordx4 v146, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[28:31], v[72:75], a[120:123], v14, v84 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s41
		s_nop 0
		buffer_load_dwordx4 v148, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[28:31], v[76:79], a[124:127], v14, v84 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s42
		s_nop 0
		buffer_load_dwordx4 v150, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[32:35], v[48:51], a[128:131], v15, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s8, 0x20000
		s_nop 0
		buffer_load_dwordx4 v86, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[32:35], v[52:55], a[132:135], v15, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s44, 0x20000
		s_nop 0
		buffer_load_dwordx4 v154, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[32:35], v[56:59], a[136:139], v15, v82 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		s_lshl_b32 s62, s61, 16
		v_add_u32_e32 v2, s62, v9
		v_add3_u32 v5, v2, v11, v3
		ds_read_b128 v[16:19], v5
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[32:35], v[60:63], a[140:143], v15, v82 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v5 offset:1024
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], v[64:67], a[144:147], v15, v83 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v5 offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[32:35], v[68:71], a[148:151], v15, v83 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[28:31], v5 offset:3072
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[32:35], v[72:75], a[152:155], v15, v84 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v5 offset:4096
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v100, s62 offset:88
		scratch_store_dword off, v101, s62 offset:92
		scratch_store_dword off, v102, s62 offset:96
		scratch_store_dword off, v103, s62 offset:100
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[32:35], v[76:79], a[156:159], v15, v84 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v5 offset:5120
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v100, s62 offset:124
		scratch_store_dword off, v101, s62 offset:128
		scratch_store_dword off, v102, s62 offset:132
		scratch_store_dword off, v103, s62 offset:136
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], v[48:51], a[160:163], v15, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v5 offset:6144
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v100, s62 offset:140
		scratch_store_dword off, v101, s62 offset:144
		scratch_store_dword off, v102, s62 offset:148
		scratch_store_dword off, v103, s62 offset:152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[36:39], v[52:55], a[164:167], v15, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v5 offset:7168
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v100, s62 offset:156
		scratch_store_dword off, v101, s62 offset:160
		scratch_store_dword off, v102, s62 offset:164
		scratch_store_dword off, v103, s62 offset:168
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[36:39], v[56:59], a[168:171], v15, v82 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshl_b32 s62, s61, 16
		v_add_u32_e32 v2, s62, v11
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v6, 0x24000, v5
		ds_read_b32 v5, v6
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v6, v2, v5, v3
		ds_read_b128 v[100:103], v6 offset:32768
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v100, s62 offset:172
		scratch_store_dword off, v101, s62 offset:176
		scratch_store_dword off, v102, s62 offset:180
		scratch_store_dword off, v103, s62 offset:184
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[36:39], v[60:63], a[172:175], v15, v82 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v6 offset:33792
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v100, s62 offset:188
		scratch_store_dword off, v101, s62 offset:192
		scratch_store_dword off, v102, s62 offset:196
		scratch_store_dword off, v103, s62 offset:200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[36:39], v[64:67], a[176:179], v15, v83 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v6 offset:34816
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v100, s62 offset:204
		scratch_store_dword off, v101, s62 offset:208
		scratch_store_dword off, v102, s62 offset:212
		scratch_store_dword off, v103, s62 offset:216
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[36:39], v[68:71], a[180:183], v15, v83 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v6 offset:35840
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v100, s62 offset:220
		scratch_store_dword off, v101, s62 offset:224
		scratch_store_dword off, v102, s62 offset:228
		scratch_store_dword off, v103, s62 offset:232
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[36:39], v[72:75], a[184:187], v15, v84 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v6 offset:36864
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v100, s62 offset:236
		scratch_store_dword off, v101, s62 offset:240
		scratch_store_dword off, v102, s62 offset:244
		scratch_store_dword off, v103, s62 offset:248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[36:39], v[76:79], a[188:191], v15, v84 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v6 offset:37888
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v100, s62 offset:252
		scratch_store_dword off, v101, s62 offset:256
		scratch_store_dword off, v102, s62 offset:260
		scratch_store_dword off, v103, s62 offset:264
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[40:43], v[48:51], a[192:195], v80, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v6 offset:38912
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v100, s62 offset:268
		scratch_store_dword off, v101, s62 offset:272
		scratch_store_dword off, v102, s62 offset:276
		scratch_store_dword off, v103, s62 offset:280
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[40:43], v[52:55], a[196:199], v80, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v6 offset:39936
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v100, s62 offset:284
		scratch_store_dword off, v101, s62 offset:288
		scratch_store_dword off, v102, s62 offset:292
		scratch_store_dword off, v103, s62 offset:296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[40:43], v[56:59], a[200:203], v80, v82 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshl_b32 s62, s61, 12
		s_add_i32 s61, s62, 0x20000
		v_add3_u32 v2, s61, v7, v13
		ds_read_b32 v5, v2
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v5, s62 offset:300
		ds_read_b32 v5, v2 offset:256
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v5, s62 offset:304
		ds_read_b32 v5, v2 offset:512
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v5, s62 offset:308
		ds_read_b32 v5, v2 offset:768
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v5, s62 offset:312
		v_add3_u32 v2, s61, v13, v1
		ds_read_b32 v5, v2 offset:2048
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v5, s61 offset:316
		ds_read_b32 v5, v2 offset:2304
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v5, s61 offset:320
		ds_read_b32 v5, v2 offset:2560
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v5, s61 offset:324
		ds_read_b32 v5, v2 offset:2816
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v5, s61 offset:328
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[40:43], v[60:63], a[204:207], v80, v82 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[40:43], v[64:67], a[208:211], v80, v83 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[40:43], v[68:71], a[212:215], v80, v83 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[40:43], v[72:75], a[216:219], v80, v84 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[40:43], v[76:79], a[220:223], v80, v84 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[44:47], v[48:51], a[224:227], v80, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[44:47], v[52:55], a[228:231], v80, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[44:47], v[56:59], a[232:235], v80, v82 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[44:47], v[60:63], a[236:239], v80, v82 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[44:47], v[64:67], a[240:243], v80, v83 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[44:47], v[68:71], a[244:247], v80, v83 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[44:47], v[72:75], a[248:251], v80, v84 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[44:47], v[76:79], a[252:255], v80, v84 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[156:159], v[188:191], a[0:3], v10, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[156:159], v[192:195], a[4:7], v10, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[156:159], v[196:199], a[8:11], v10, v82 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[156:159], v[200:203], a[12:15], v10, v82 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[156:159], v[204:207], a[16:19], v10, v83 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[156:159], v[208:211], a[20:23], v10, v83 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[156:159], v[212:215], a[24:27], v10, v84 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[156:159], v[216:219], a[28:31], v10, v84 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[160:163], v[188:191], a[32:35], v10, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[160:163], v[192:195], a[36:39], v10, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[160:163], v[196:199], a[40:43], v10, v82 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[160:163], v[200:203], a[44:47], v10, v82 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[160:163], v[204:207], a[48:51], v10, v83 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[160:163], v[208:211], a[52:55], v10, v83 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[160:163], v[212:215], a[56:59], v10, v84 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[160:163], v[216:219], a[60:63], v10, v84 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[164:167], v[188:191], a[64:67], v14, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[164:167], v[192:195], a[68:71], v14, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[164:167], v[196:199], a[72:75], v14, v82 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[164:167], v[200:203], a[76:79], v14, v82 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[164:167], v[204:207], a[80:83], v14, v83 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[164:167], v[208:211], a[84:87], v14, v83 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[164:167], v[212:215], a[88:91], v14, v84 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[164:167], v[216:219], a[92:95], v14, v84 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[168:171], v[188:191], a[96:99], v14, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[168:171], v[192:195], a[100:103], v14, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[168:171], v[196:199], a[104:107], v14, v82 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[168:171], v[200:203], a[108:111], v14, v82 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[168:171], v[204:207], a[112:115], v14, v83 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[168:171], v[208:211], a[116:119], v14, v83 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[168:171], v[212:215], a[120:123], v14, v84 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[168:171], v[216:219], a[124:127], v14, v84 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[172:175], v[188:191], a[128:131], v15, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[172:175], v[192:195], a[132:135], v15, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[172:175], v[196:199], a[136:139], v15, v82 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[172:175], v[200:203], a[140:143], v15, v82 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[172:175], v[204:207], a[144:147], v15, v83 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[172:175], v[208:211], a[148:151], v15, v83 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[172:175], v[212:215], a[152:155], v15, v84 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[172:175], v[216:219], a[156:159], v15, v84 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[176:179], v[188:191], a[160:163], v15, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[176:179], v[192:195], a[164:167], v15, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[176:179], v[196:199], a[168:171], v15, v82 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[176:179], v[200:203], a[172:175], v15, v82 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[176:179], v[204:207], a[176:179], v15, v83 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[176:179], v[208:211], a[180:183], v15, v83 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[176:179], v[212:215], a[184:187], v15, v84 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[176:179], v[216:219], a[188:191], v15, v84 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[180:183], v[188:191], a[192:195], v80, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[180:183], v[192:195], a[196:199], v80, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[180:183], v[196:199], a[200:203], v80, v82 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[180:183], v[200:203], a[204:207], v80, v82 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[180:183], v[204:207], a[208:211], v80, v83 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[180:183], v[208:211], a[212:215], v80, v83 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[180:183], v[212:215], a[216:219], v80, v84 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[180:183], v[216:219], a[220:223], v80, v84 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[184:187], v[188:191], a[224:227], v80, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[184:187], v[192:195], a[228:231], v80, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[184:187], v[196:199], a[232:235], v80, v82 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[184:187], v[200:203], a[236:239], v80, v82 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[184:187], v[204:207], a[240:243], v80, v83 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[184:187], v[208:211], a[244:247], v80, v83 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[184:187], v[212:215], a[248:251], v80, v84 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[184:187], v[216:219], a[252:255], v80, v84 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s61, s60, 1
		s_and_b32 s62, s61, 1
		s_lshl_b32 s61, s62, 16
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v5, 0x24400, v2
		ds_read_b32 v2, v5
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v5, s61, v2
		v_add3_u32 v2, v5, v11, v3
		s_mov_b32 s63, 0
		scratch_store_dword off, v2, s63 offset:356
		ds_read_b128 v[100:103], v2
		s_mov_b32 s63, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v100, s63 offset:340
		scratch_store_dword off, v101, s63 offset:344
		scratch_store_dword off, v102, s63 offset:348
		scratch_store_dword off, v103, s63 offset:352
		ds_read_b128 v[148:151], v2 offset:1024
		s_mov_b32 s63, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v148, s63 offset:424
		scratch_store_dword off, v149, s63 offset:428
		scratch_store_dword off, v150, s63 offset:432
		scratch_store_dword off, v151, s63 offset:436
		ds_read_b128 v[156:159], v2 offset:2048
		ds_read_b128 v[160:163], v2 offset:3072
		ds_read_b128 v[164:167], v2 offset:4096
		ds_read_b128 v[168:171], v2 offset:5120
		ds_read_b128 v[172:175], v2 offset:6144
		ds_read_b128 v[176:179], v2 offset:7168
		v_add_u32_e32 v5, s61, v11
		v_lshlrev_b32_e32 v6, 2, v0
		v_add_u32_e32 v8, 0x22800, v6
		ds_read_b32 v6, v8
		s_waitcnt lgkmcnt(0)
		v_add3_u32 v8, v5, v6, v3
		s_mov_b32 s61, 0
		scratch_store_dword off, v8, s61 offset:440
		ds_read_b128 v[180:183], v8 offset:32768
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v180, s61 offset:444
		scratch_store_dword off, v181, s61 offset:448
		scratch_store_dword off, v182, s61 offset:452
		scratch_store_dword off, v183, s61 offset:456
		ds_read_b128 v[184:187], v8 offset:33792
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v184, s61 offset:460
		scratch_store_dword off, v185, s61 offset:464
		scratch_store_dword off, v186, s61 offset:468
		scratch_store_dword off, v187, s61 offset:472
		ds_read_b128 v[188:191], v8 offset:34816
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v188, s61 offset:476
		scratch_store_dword off, v189, s61 offset:480
		scratch_store_dword off, v190, s61 offset:484
		scratch_store_dword off, v191, s61 offset:488
		ds_read_b128 v[192:195], v8 offset:35840
		ds_read_b128 v[196:199], v8 offset:36864
		ds_read_b128 v[200:203], v8 offset:37888
		ds_read_b128 v[204:207], v8 offset:38912
		ds_read_b128 v[208:211], v8 offset:39936
		s_lshl_b32 s61, s62, 12
		s_add_i32 s62, s61, 0x20000
		v_add3_u32 v5, s62, v7, v13
		ds_read_b32 v6, v5
		ds_read_b32 v81, v5 offset:256
		ds_read_b32 v85, v5 offset:512
		ds_read_b32 v86, v5 offset:768
		v_add3_u32 v5, s62, v13, v1
		ds_read_b32 v87, v5 offset:2048
		ds_read_b32 v98, v5 offset:2304
		ds_read_b32 v99, v5 offset:2560
		ds_read_b32 v104, v5 offset:2816
		s_waitcnt lgkmcnt(0)
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v105, 0x24800, v5
		ds_read_b32 v110, v105
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v105, 0x24c00, v5
		ds_read_b32 v111, v105
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v126, vcc, v110, v90
		v_addc_co_u32_e64 v127, vcc, v111, v91, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v126, s61 offset:332
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v105, 0x25000, v5
		ds_read_b32 v110, v105
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v105, 0x25400, v5
		ds_read_b32 v111, v105
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v126, vcc, v110, v90
		v_addc_co_u32_e64 v127, vcc, v111, v91, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v126, s61 offset:336
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v105, 0x25800, v5
		ds_read_b32 v110, v105
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v105, 0x25c00, v5
		ds_read_b32 v111, v105
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v126, vcc, v110, v90
		v_addc_co_u32_e64 v127, vcc, v111, v91, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v126, s61 offset:360
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v105, 0x26000, v5
		ds_read_b32 v110, v105
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v105, 0x26400, v5
		ds_read_b32 v111, v105
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v126, vcc, v110, v90
		v_addc_co_u32_e64 v127, vcc, v111, v91, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v126, s61 offset:364
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v105, 0x26800, v5
		ds_read_b32 v110, v105
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v105, 0x26c00, v5
		ds_read_b32 v111, v105
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v126, vcc, v110, v90
		v_addc_co_u32_e64 v127, vcc, v111, v91, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v126, s61 offset:368
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v105, 0x27000, v5
		ds_read_b32 v110, v105
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v105, 0x27400, v5
		ds_read_b32 v111, v105
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v126, vcc, v110, v90
		v_addc_co_u32_e64 v127, vcc, v111, v91, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v126, s61 offset:372
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v105, 0x27800, v5
		ds_read_b32 v110, v105
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v105, 0x27c00, v5
		ds_read_b32 v111, v105
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v126, vcc, v110, v90
		v_addc_co_u32_e64 v127, vcc, v111, v91, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v126, s61 offset:376
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(63) expcnt(7) lgkmcnt(15)
		scratch_load_dword v110, off, s61
		scratch_load_dword v111, off, s61 offset:4
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v126, vcc, v110, v90
		v_addc_co_u32_e64 v127, vcc, v111, v91, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v126, s61 offset:380
		s_mov_b32 s61, 0
		scratch_load_dword v110, off, s61 offset:8
		scratch_load_dword v111, off, s61 offset:12
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v126, vcc, v110, v90
		v_addc_co_u32_e64 v127, vcc, v111, v91, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v126, s61 offset:384
		s_mov_b32 s61, 0
		scratch_load_dword v110, off, s61 offset:16
		scratch_load_dword v111, off, s61 offset:20
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v126, vcc, v110, v90
		v_addc_co_u32_e64 v127, vcc, v111, v91, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v126, s61 offset:388
		s_mov_b32 s61, 0
		scratch_load_dword v110, off, s61 offset:24
		scratch_load_dword v111, off, s61 offset:28
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v126, vcc, v110, v90
		v_addc_co_u32_e64 v127, vcc, v111, v91, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v126, s61 offset:392
		s_mov_b32 s61, 0
		scratch_load_dword v110, off, s61 offset:32
		scratch_load_dword v111, off, s61 offset:36
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v126, vcc, v110, v90
		v_addc_co_u32_e64 v127, vcc, v111, v91, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v126, s61 offset:396
		s_mov_b32 s61, 0
		scratch_load_dword v110, off, s61 offset:40
		scratch_load_dword v111, off, s61 offset:44
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v126, vcc, v110, v90
		v_addc_co_u32_e64 v127, vcc, v111, v91, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v126, s61 offset:400
		s_mov_b32 s61, 0
		scratch_load_dword v110, off, s61 offset:48
		scratch_load_dword v111, off, s61 offset:52
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v126, vcc, v110, v90
		v_addc_co_u32_e64 v127, vcc, v111, v91, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v126, s61 offset:404
		s_mov_b32 s61, 0
		scratch_load_dword v110, off, s61 offset:56
		scratch_load_dword v111, off, s61 offset:60
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v126, vcc, v110, v90
		v_addc_co_u32_e64 v127, vcc, v111, v91, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v126, s61 offset:408
		s_mov_b32 s61, 0
		scratch_load_dword v110, off, s61 offset:64
		scratch_load_dword v111, off, s61 offset:68
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v126, vcc, v110, v90
		v_addc_co_u32_e64 v127, vcc, v111, v91, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v126, s61 offset:412
		s_mov_b32 s61, 0
		scratch_load_dword v90, off, s61 offset:72
		scratch_load_dword v91, off, s61 offset:76
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v110, vcc, v90, v152
		v_addc_co_u32_e64 v111, vcc, v91, v153, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v110, s61 offset:416
		s_mov_b32 s61, 0
		scratch_load_dword v90, off, s61 offset:80
		scratch_load_dword v91, off, s61 offset:84
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v110, vcc, v90, v152
		v_addc_co_u32_e64 v111, vcc, v91, v153, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v110, s61 offset:420
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[100:103], v[180:183], a[0:3], v6, v87 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[152:155], v2 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[100:103], v[184:187], a[4:7], v6, v87 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[212:215], v2 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[100:103], v[188:191], a[8:11], v6, v98 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v2 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[100:103], v[192:195], a[12:15], v6, v98 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v2 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[100:103], v[196:199], a[16:19], v6, v99 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v2 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[100:103], v[200:203], a[20:23], v6, v99 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v2 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[100:103], v[204:207], a[24:27], v6, v104 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v2 offset:22528
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(35)
		scratch_load_dword v232, off, s61 offset:340
		scratch_load_dword v233, off, s61 offset:344
		scratch_load_dword v234, off, s61 offset:348
		scratch_load_dword v235, off, s61 offset:352
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[232:235], v[208:211], a[28:31], v6, v104 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v2, off, s61 offset:356
		s_waitcnt vmcnt(0)
		ds_read_b128 v[232:235], v2 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[148:151], v[180:183], a[32:35], v6, v87 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[180:183], v8 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[148:151], v[184:187], a[36:39], v6, v87 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[184:187], v8 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[148:151], v[188:191], a[40:43], v6, v98 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[188:191], v8 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[148:151], v[192:195], a[44:47], v6, v98 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[236:239], v8 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[148:151], v[196:199], a[48:51], v6, v99 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v8 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[148:151], v[200:203], a[52:55], v6, v99 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[148:151], v8 offset:54272
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(31)
		scratch_load_dword v244, off, s61 offset:424
		scratch_load_dword v245, off, s61 offset:428
		scratch_load_dword v246, off, s61 offset:432
		scratch_load_dword v247, off, s61 offset:436
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[244:247], v[204:207], a[56:59], v6, v104 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(30)
		scratch_load_dword v2, off, s61 offset:440
		s_waitcnt vmcnt(0)
		ds_read_b128 v[244:247], v2 offset:55296
		s_mov_b32 s61, 0
		scratch_load_dword v248, off, s61 offset:424
		scratch_load_dword v249, off, s61 offset:428
		scratch_load_dword v250, off, s61 offset:432
		scratch_load_dword v251, off, s61 offset:436
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[248:251], v[208:211], a[60:63], v6, v104 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v2, off, s61 offset:440
		s_waitcnt vmcnt(0)
		ds_read_b128 v[248:251], v2 offset:56320
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(26)
		scratch_load_dword v252, off, s61 offset:444
		scratch_load_dword v253, off, s61 offset:448
		scratch_load_dword v254, off, s61 offset:452
		scratch_load_dword v255, off, s61 offset:456
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[156:159], v[252:255], a[64:67], v81, v87 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s10
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(17)
		scratch_load_dword v2, off, s61 offset:332
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		s_mov_b32 s61, 0
		scratch_load_dword v252, off, s61 offset:460
		scratch_load_dword v253, off, s61 offset:464
		scratch_load_dword v254, off, s61 offset:468
		scratch_load_dword v255, off, s61 offset:472
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[156:159], v[252:255], a[68:71], v81, v87 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s45
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v2, off, s61 offset:336
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		s_mov_b32 s61, 0
		scratch_load_dword v252, off, s61 offset:476
		scratch_load_dword v253, off, s61 offset:480
		scratch_load_dword v254, off, s61 offset:484
		scratch_load_dword v255, off, s61 offset:488
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[156:159], v[252:255], a[72:75], v81, v98 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s46
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(15)
		scratch_load_dword v2, off, s61 offset:360
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[156:159], v[192:195], a[76:79], v81, v98 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s47
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(14)
		scratch_load_dword v2, off, s61 offset:364
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[156:159], v[196:199], a[80:83], v81, v99 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s48
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(13)
		scratch_load_dword v2, off, s61 offset:368
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[156:159], v[200:203], a[84:87], v81, v99 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s49
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(12)
		scratch_load_dword v2, off, s61 offset:372
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[156:159], v[204:207], a[88:91], v81, v104 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s50
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(11)
		scratch_load_dword v2, off, s61 offset:376
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[156:159], v[208:211], a[92:95], v81, v104 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s51
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(10)
		scratch_load_dword v2, off, s61 offset:380
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		s_mov_b32 s61, 0
		scratch_load_dword v156, off, s61 offset:444
		scratch_load_dword v157, off, s61 offset:448
		scratch_load_dword v158, off, s61 offset:452
		scratch_load_dword v159, off, s61 offset:456
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[160:163], v[156:159], a[96:99], v81, v87 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s52
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(9)
		scratch_load_dword v2, off, s61 offset:384
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_mov_b32 s61, 0
		scratch_load_dword v156, off, s61 offset:460
		scratch_load_dword v157, off, s61 offset:464
		scratch_load_dword v158, off, s61 offset:468
		scratch_load_dword v159, off, s61 offset:472
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[160:163], v[156:159], a[100:103], v81, v87 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s53
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v2, off, s61 offset:388
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_mov_b32 s61, 0
		scratch_load_dword v156, off, s61 offset:476
		scratch_load_dword v157, off, s61 offset:480
		scratch_load_dword v158, off, s61 offset:484
		scratch_load_dword v159, off, s61 offset:488
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[160:163], v[156:159], a[104:107], v81, v98 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s54
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(7)
		scratch_load_dword v2, off, s61 offset:392
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[160:163], v[192:195], a[108:111], v81, v98 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s55
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(6)
		scratch_load_dword v2, off, s61 offset:396
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[160:163], v[196:199], a[112:115], v81, v99 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s56
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(5)
		scratch_load_dword v2, off, s61 offset:400
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[160:163], v[200:203], a[116:119], v81, v99 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s57
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v2, off, s61 offset:404
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[160:163], v[204:207], a[120:123], v81, v104 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s58
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(3)
		scratch_load_dword v2, off, s61 offset:408
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[160:163], v[208:211], a[124:127], v81, v104 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s59
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(2)
		scratch_load_dword v2, off, s61 offset:412
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_mov_b32 s61, 0
		scratch_load_dword v156, off, s61 offset:444
		scratch_load_dword v157, off, s61 offset:448
		scratch_load_dword v158, off, s61 offset:452
		scratch_load_dword v159, off, s61 offset:456
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[164:167], v[156:159], a[128:131], v85, v87 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s43, 0x20000
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(1)
		scratch_load_dword v2, off, s61 offset:416
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v2, s[4:7], 0 offen lds
		s_mov_b32 s61, 0
		scratch_load_dword v156, off, s61 offset:460
		scratch_load_dword v157, off, s61 offset:464
		scratch_load_dword v158, off, s61 offset:468
		scratch_load_dword v159, off, s61 offset:472
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[164:167], v[156:159], a[132:135], v85, v87 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s9, 0x20000
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v2, off, s61 offset:420
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		s_mov_b32 s61, 0
		scratch_load_dword v156, off, s61 offset:476
		scratch_load_dword v157, off, s61 offset:480
		scratch_load_dword v158, off, s61 offset:484
		scratch_load_dword v159, off, s61 offset:488
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[164:167], v[156:159], a[136:139], v85, v98 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[164:167], v[192:195], a[140:143], v85, v98 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[164:167], v[196:199], a[144:147], v85, v99 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[164:167], v[200:203], a[148:151], v85, v99 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[164:167], v[204:207], a[152:155], v85, v104 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[164:167], v[208:211], a[156:159], v85, v104 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v156, off, s61 offset:444
		scratch_load_dword v157, off, s61 offset:448
		scratch_load_dword v158, off, s61 offset:452
		scratch_load_dword v159, off, s61 offset:456
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[168:171], v[156:159], a[160:163], v85, v87 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v156, off, s61 offset:460
		scratch_load_dword v157, off, s61 offset:464
		scratch_load_dword v158, off, s61 offset:468
		scratch_load_dword v159, off, s61 offset:472
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[168:171], v[156:159], a[164:167], v85, v87 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v156, off, s61 offset:476
		scratch_load_dword v157, off, s61 offset:480
		scratch_load_dword v158, off, s61 offset:484
		scratch_load_dword v159, off, s61 offset:488
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[168:171], v[156:159], a[168:171], v85, v98 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[168:171], v[192:195], a[172:175], v85, v98 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[168:171], v[196:199], a[176:179], v85, v99 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[168:171], v[200:203], a[180:183], v85, v99 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[168:171], v[204:207], a[184:187], v85, v104 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[168:171], v[208:211], a[188:191], v85, v104 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v156, off, s61 offset:444
		scratch_load_dword v157, off, s61 offset:448
		scratch_load_dword v158, off, s61 offset:452
		scratch_load_dword v159, off, s61 offset:456
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[172:175], v[156:159], a[192:195], v86, v87 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v156, off, s61 offset:460
		scratch_load_dword v157, off, s61 offset:464
		scratch_load_dword v158, off, s61 offset:468
		scratch_load_dword v159, off, s61 offset:472
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[172:175], v[156:159], a[196:199], v86, v87 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v156, off, s61 offset:476
		scratch_load_dword v157, off, s61 offset:480
		scratch_load_dword v158, off, s61 offset:484
		scratch_load_dword v159, off, s61 offset:488
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[172:175], v[156:159], a[200:203], v86, v98 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[172:175], v[192:195], a[204:207], v86, v98 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[172:175], v[196:199], a[208:211], v86, v99 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[172:175], v[200:203], a[212:215], v86, v99 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[172:175], v[204:207], a[216:219], v86, v104 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[172:175], v[208:211], a[220:223], v86, v104 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v156, off, s61 offset:444
		scratch_load_dword v157, off, s61 offset:448
		scratch_load_dword v158, off, s61 offset:452
		scratch_load_dword v159, off, s61 offset:456
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[176:179], v[156:159], a[224:227], v86, v87 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v156, off, s61 offset:460
		scratch_load_dword v157, off, s61 offset:464
		scratch_load_dword v158, off, s61 offset:468
		scratch_load_dword v159, off, s61 offset:472
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[176:179], v[156:159], a[228:231], v86, v87 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s61, 0
		scratch_load_dword v156, off, s61 offset:476
		scratch_load_dword v157, off, s61 offset:480
		scratch_load_dword v158, off, s61 offset:484
		scratch_load_dword v159, off, s61 offset:488
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[176:179], v[156:159], a[232:235], v86, v98 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[176:179], v[192:195], a[236:239], v86, v98 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[176:179], v[196:199], a[240:243], v86, v99 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[176:179], v[200:203], a[244:247], v86, v99 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[176:179], v[204:207], a[248:251], v86, v104 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[176:179], v[208:211], a[252:255], v86, v104 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[152:155], v[180:183], a[0:3], v6, v87 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[152:155], v[184:187], a[4:7], v6, v87 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[152:155], v[188:191], a[8:11], v6, v98 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[152:155], v[236:239], a[12:15], v6, v98 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[152:155], v[240:243], a[16:19], v6, v99 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[152:155], v[148:151], a[20:23], v6, v99 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[152:155], v[244:247], a[24:27], v6, v104 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[152:155], v[248:251], a[28:31], v6, v104 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[212:215], v[180:183], a[32:35], v6, v87 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[212:215], v[184:187], a[36:39], v6, v87 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[212:215], v[188:191], a[40:43], v6, v98 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[212:215], v[236:239], a[44:47], v6, v98 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[212:215], v[240:243], a[48:51], v6, v99 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[212:215], v[148:151], a[52:55], v6, v99 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[212:215], v[244:247], a[56:59], v6, v104 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[212:215], v[248:251], a[60:63], v6, v104 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[216:219], v[180:183], a[64:67], v81, v87 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[216:219], v[184:187], a[68:71], v81, v87 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[216:219], v[188:191], a[72:75], v81, v98 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[216:219], v[236:239], a[76:79], v81, v98 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[216:219], v[240:243], a[80:83], v81, v99 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[216:219], v[148:151], a[84:87], v81, v99 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[216:219], v[244:247], a[88:91], v81, v104 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[216:219], v[248:251], a[92:95], v81, v104 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[220:223], v[180:183], a[96:99], v81, v87 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[220:223], v[184:187], a[100:103], v81, v87 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[220:223], v[188:191], a[104:107], v81, v98 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[220:223], v[236:239], a[108:111], v81, v98 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[220:223], v[240:243], a[112:115], v81, v99 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[220:223], v[148:151], a[116:119], v81, v99 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[220:223], v[244:247], a[120:123], v81, v104 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[220:223], v[248:251], a[124:127], v81, v104 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[224:227], v[180:183], a[128:131], v85, v87 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[224:227], v[184:187], a[132:135], v85, v87 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[224:227], v[188:191], a[136:139], v85, v98 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[224:227], v[236:239], a[140:143], v85, v98 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[224:227], v[240:243], a[144:147], v85, v99 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[224:227], v[148:151], a[148:151], v85, v99 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[224:227], v[244:247], a[152:155], v85, v104 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[224:227], v[248:251], a[156:159], v85, v104 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[228:231], v[180:183], a[160:163], v85, v87 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[228:231], v[184:187], a[164:167], v85, v87 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[228:231], v[188:191], a[168:171], v85, v98 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[228:231], v[236:239], a[172:175], v85, v98 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[228:231], v[240:243], a[176:179], v85, v99 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[228:231], v[148:151], a[180:183], v85, v99 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[228:231], v[244:247], a[184:187], v85, v104 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[228:231], v[248:251], a[188:191], v85, v104 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[100:103], v[180:183], a[192:195], v86, v87 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[100:103], v[184:187], a[196:199], v86, v87 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[100:103], v[188:191], a[200:203], v86, v98 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[100:103], v[236:239], a[204:207], v86, v98 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[100:103], v[240:243], a[208:211], v86, v99 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[100:103], v[148:151], a[212:215], v86, v99 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[100:103], v[244:247], a[216:219], v86, v104 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[100:103], v[248:251], a[220:223], v86, v104 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[232:235], v[180:183], a[224:227], v86, v87 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[232:235], v[184:187], a[228:231], v86, v87 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[232:235], v[188:191], a[232:235], v86, v98 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[232:235], v[236:239], a[236:239], v86, v98 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[232:235], v[240:243], a[240:243], v86, v99 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[232:235], v[148:151], a[244:247], v86, v99 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[232:235], v[244:247], a[248:251], v86, v104 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[232:235], v[248:251], a[252:255], v86, v104 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s60, s60, 2
		s_cmp_lt_i32 s60, s11
		s_mov_b32 s61, 0
		scratch_load_dword v100, off, s61 offset:88
		scratch_load_dword v101, off, s61 offset:92
		scratch_load_dword v102, off, s61 offset:96
		scratch_load_dword v103, off, s61 offset:100
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v32, v100
		v_mov_b32_e32 v33, v101
		v_mov_b32_e32 v34, v102
		v_mov_b32_e32 v35, v103
		s_mov_b32 s61, 0
		scratch_load_dword v100, off, s61 offset:124
		scratch_load_dword v101, off, s61 offset:128
		scratch_load_dword v102, off, s61 offset:132
		scratch_load_dword v103, off, s61 offset:136
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v36, v100
		v_mov_b32_e32 v37, v101
		v_mov_b32_e32 v38, v102
		v_mov_b32_e32 v39, v103
		s_mov_b32 s61, 0
		scratch_load_dword v100, off, s61 offset:140
		scratch_load_dword v101, off, s61 offset:144
		scratch_load_dword v102, off, s61 offset:148
		scratch_load_dword v103, off, s61 offset:152
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v40, v100
		v_mov_b32_e32 v41, v101
		v_mov_b32_e32 v42, v102
		v_mov_b32_e32 v43, v103
		s_mov_b32 s61, 0
		scratch_load_dword v100, off, s61 offset:156
		scratch_load_dword v101, off, s61 offset:160
		scratch_load_dword v102, off, s61 offset:164
		scratch_load_dword v103, off, s61 offset:168
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v44, v100
		v_mov_b32_e32 v45, v101
		v_mov_b32_e32 v46, v102
		v_mov_b32_e32 v47, v103
		s_mov_b32 s61, 0
		scratch_load_dword v100, off, s61 offset:172
		scratch_load_dword v101, off, s61 offset:176
		scratch_load_dword v102, off, s61 offset:180
		scratch_load_dword v103, off, s61 offset:184
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v48, v100
		v_mov_b32_e32 v49, v101
		v_mov_b32_e32 v50, v102
		v_mov_b32_e32 v51, v103
		s_mov_b32 s61, 0
		scratch_load_dword v100, off, s61 offset:188
		scratch_load_dword v101, off, s61 offset:192
		scratch_load_dword v102, off, s61 offset:196
		scratch_load_dword v103, off, s61 offset:200
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v52, v100
		v_mov_b32_e32 v53, v101
		v_mov_b32_e32 v54, v102
		v_mov_b32_e32 v55, v103
		s_mov_b32 s61, 0
		scratch_load_dword v100, off, s61 offset:204
		scratch_load_dword v101, off, s61 offset:208
		scratch_load_dword v102, off, s61 offset:212
		scratch_load_dword v103, off, s61 offset:216
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v56, v100
		v_mov_b32_e32 v57, v101
		v_mov_b32_e32 v58, v102
		v_mov_b32_e32 v59, v103
		s_mov_b32 s61, 0
		scratch_load_dword v100, off, s61 offset:220
		scratch_load_dword v101, off, s61 offset:224
		scratch_load_dword v102, off, s61 offset:228
		scratch_load_dword v103, off, s61 offset:232
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v60, v100
		v_mov_b32_e32 v61, v101
		v_mov_b32_e32 v62, v102
		v_mov_b32_e32 v63, v103
		s_mov_b32 s61, 0
		scratch_load_dword v100, off, s61 offset:236
		scratch_load_dword v101, off, s61 offset:240
		scratch_load_dword v102, off, s61 offset:244
		scratch_load_dword v103, off, s61 offset:248
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v64, v100
		v_mov_b32_e32 v65, v101
		v_mov_b32_e32 v66, v102
		v_mov_b32_e32 v67, v103
		s_mov_b32 s61, 0
		scratch_load_dword v100, off, s61 offset:252
		scratch_load_dword v101, off, s61 offset:256
		scratch_load_dword v102, off, s61 offset:260
		scratch_load_dword v103, off, s61 offset:264
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v68, v100
		v_mov_b32_e32 v69, v101
		v_mov_b32_e32 v70, v102
		v_mov_b32_e32 v71, v103
		s_mov_b32 s61, 0
		scratch_load_dword v100, off, s61 offset:268
		scratch_load_dword v101, off, s61 offset:272
		scratch_load_dword v102, off, s61 offset:276
		scratch_load_dword v103, off, s61 offset:280
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v72, v100
		v_mov_b32_e32 v73, v101
		v_mov_b32_e32 v74, v102
		v_mov_b32_e32 v75, v103
		s_mov_b32 s61, 0
		scratch_load_dword v100, off, s61 offset:284
		scratch_load_dword v101, off, s61 offset:288
		scratch_load_dword v102, off, s61 offset:292
		scratch_load_dword v103, off, s61 offset:296
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v76, v100
		v_mov_b32_e32 v77, v101
		v_mov_b32_e32 v78, v102
		v_mov_b32_e32 v79, v103
		s_mov_b32 s61, 0
		scratch_load_dword v2, off, s61 offset:300
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v10, v2
		s_mov_b32 s61, 0
		scratch_load_dword v2, off, s61 offset:304
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v14, v2
		s_mov_b32 s61, 0
		scratch_load_dword v2, off, s61 offset:308
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v15, v2
		s_mov_b32 s61, 0
		scratch_load_dword v2, off, s61 offset:312
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v80, v2
		s_mov_b32 s61, 0
		scratch_load_dword v2, off, s61 offset:316
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v4, v2
		s_mov_b32 s61, 0
		scratch_load_dword v2, off, s61 offset:320
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v82, v2
		s_mov_b32 s61, 0
		scratch_load_dword v2, off, s61 offset:324
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v83, v2
		s_mov_b32 s61, 0
		scratch_load_dword v2, off, s61 offset:328
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v84, v2
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_add_i32 s0, s12, -1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[16:19], v[48:51], a[0:3], v10, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s1, s0, 1
		s_lshl_b32 s0, s1, 16
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x24400, v1
		ds_read_b32 v1, v2
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v2, s0, v1
		s_mov_b32 s1, 0
		scratch_load_dword v1, off, s1 offset:116
		s_mov_b32 s1, 0
		scratch_load_dword v3, off, s1 offset:120
		s_waitcnt vmcnt(0)
		v_add3_u32 v5, v2, v1, v3
		ds_read_b128 v[88:91], v5 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[16:19], v[52:55], a[4:7], v10, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v5 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[16:19], v[56:59], a[8:11], v10, v82 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v5 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[16:19], v[60:63], a[12:15], v10, v82 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v5 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[16:19], v[64:67], a[16:19], v10, v83 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[104:107], v5 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[16:19], v[68:71], a[20:23], v10, v83 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[108:111], v5 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[16:19], v[72:75], a[24:27], v10, v84 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[112:115], v5 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[16:19], v[76:79], a[28:31], v10, v84 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[16:19], v5 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[20:23], v[48:51], a[32:35], v10, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s1, 0
		scratch_load_dword v1, off, s1 offset:116
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v2, s0, v1
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v3, 0x22800, v1
		ds_read_b32 v1, v3
		s_mov_b32 s0, 0
		scratch_load_dword v3, off, s0 offset:120
		s_waitcnt vmcnt(0) lgkmcnt(0)
		v_add3_u32 v5, v2, v1, v3
		ds_read_b128 v[116:119], v5 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[20:23], v[52:55], a[36:39], v10, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[120:123], v5 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[20:23], v[56:59], a[40:43], v10, v82 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[124:127], v5 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[20:23], v[60:63], a[44:47], v10, v82 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[128:131], v5 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[20:23], v[64:67], a[48:51], v10, v83 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[132:135], v5 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[20:23], v[68:71], a[52:55], v10, v83 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[136:139], v5 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[20:23], v[72:75], a[56:59], v10, v84 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[140:143], v5 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[20:23], v[76:79], a[60:63], v10, v84 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v5 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[24:27], v[48:51], a[64:67], v14, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[24:27], v[52:55], a[68:71], v14, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[24:27], v[56:59], a[72:75], v14, v82 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[24:27], v[60:63], a[76:79], v14, v82 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[24:27], v[64:67], a[80:83], v14, v83 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[24:27], v[68:71], a[84:87], v14, v83 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[24:27], v[72:75], a[88:91], v14, v84 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[24:27], v[76:79], a[92:95], v14, v84 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[28:31], v[48:51], a[96:99], v14, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[28:31], v[52:55], a[100:103], v14, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[28:31], v[56:59], a[104:107], v14, v82 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[28:31], v[60:63], a[108:111], v14, v82 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[28:31], v[64:67], a[112:115], v14, v83 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[28:31], v[68:71], a[116:119], v14, v83 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[28:31], v[72:75], a[120:123], v14, v84 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[28:31], v[76:79], a[124:127], v14, v84 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[32:35], v[48:51], a[128:131], v15, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[32:35], v[52:55], a[132:135], v15, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[32:35], v[56:59], a[136:139], v15, v82 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[32:35], v[60:63], a[140:143], v15, v82 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], v[64:67], a[144:147], v15, v83 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[32:35], v[68:71], a[148:151], v15, v83 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[32:35], v[72:75], a[152:155], v15, v84 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[32:35], v[76:79], a[156:159], v15, v84 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], v[48:51], a[160:163], v15, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[36:39], v[52:55], a[164:167], v15, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[36:39], v[56:59], a[168:171], v15, v82 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[36:39], v[60:63], a[172:175], v15, v82 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[36:39], v[64:67], a[176:179], v15, v83 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[36:39], v[68:71], a[180:183], v15, v83 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[36:39], v[72:75], a[184:187], v15, v84 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[36:39], v[76:79], a[188:191], v15, v84 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[40:43], v[48:51], a[192:195], v80, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[40:43], v[52:55], a[196:199], v80, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[40:43], v[56:59], a[200:203], v80, v82 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[40:43], v[60:63], a[204:207], v80, v82 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[40:43], v[64:67], a[208:211], v80, v83 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[40:43], v[68:71], a[212:215], v80, v83 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[40:43], v[72:75], a[216:219], v80, v84 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[40:43], v[76:79], a[220:223], v80, v84 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[44:47], v[48:51], a[224:227], v80, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[44:47], v[52:55], a[228:231], v80, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[44:47], v[56:59], a[232:235], v80, v82 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[44:47], v[60:63], a[236:239], v80, v82 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[44:47], v[64:67], a[240:243], v80, v83 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[44:47], v[68:71], a[244:247], v80, v83 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[44:47], v[72:75], a[248:251], v80, v84 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[44:47], v[76:79], a[252:255], v80, v84 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[88:91], v[116:119], a[0:3], v10, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[88:91], v[120:123], a[4:7], v10, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[88:91], v[124:127], a[8:11], v10, v82 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[88:91], v[128:131], a[12:15], v10, v82 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[88:91], v[132:135], a[16:19], v10, v83 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[88:91], v[136:139], a[20:23], v10, v83 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[88:91], v[140:143], a[24:27], v10, v84 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[88:91], v[20:23], a[28:31], v10, v84 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[92:95], v[116:119], a[32:35], v10, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[92:95], v[120:123], a[36:39], v10, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[92:95], v[124:127], a[40:43], v10, v82 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[92:95], v[128:131], a[44:47], v10, v82 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[92:95], v[132:135], a[48:51], v10, v83 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[92:95], v[136:139], a[52:55], v10, v83 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[92:95], v[140:143], a[56:59], v10, v84 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[92:95], v[20:23], a[60:63], v10, v84 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[96:99], v[116:119], a[64:67], v14, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[96:99], v[120:123], a[68:71], v14, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[96:99], v[124:127], a[72:75], v14, v82 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[96:99], v[128:131], a[76:79], v14, v82 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[96:99], v[132:135], a[80:83], v14, v83 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[96:99], v[136:139], a[84:87], v14, v83 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[96:99], v[140:143], a[88:91], v14, v84 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[96:99], v[20:23], a[92:95], v14, v84 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[100:103], v[116:119], a[96:99], v14, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[100:103], v[120:123], a[100:103], v14, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[100:103], v[124:127], a[104:107], v14, v82 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[100:103], v[128:131], a[108:111], v14, v82 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[100:103], v[132:135], a[112:115], v14, v83 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[100:103], v[136:139], a[116:119], v14, v83 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[100:103], v[140:143], a[120:123], v14, v84 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[100:103], v[20:23], a[124:127], v14, v84 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[104:107], v[116:119], a[128:131], v15, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[104:107], v[120:123], a[132:135], v15, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[104:107], v[124:127], a[136:139], v15, v82 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[104:107], v[128:131], a[140:143], v15, v82 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[104:107], v[132:135], a[144:147], v15, v83 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[104:107], v[136:139], a[148:151], v15, v83 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[104:107], v[140:143], a[152:155], v15, v84 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[104:107], v[20:23], a[156:159], v15, v84 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[108:111], v[116:119], a[160:163], v15, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[108:111], v[120:123], a[164:167], v15, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[108:111], v[124:127], a[168:171], v15, v82 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[108:111], v[128:131], a[172:175], v15, v82 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[108:111], v[132:135], a[176:179], v15, v83 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[108:111], v[136:139], a[180:183], v15, v83 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[108:111], v[140:143], a[184:187], v15, v84 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[108:111], v[20:23], a[188:191], v15, v84 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[112:115], v[116:119], a[192:195], v80, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[112:115], v[120:123], a[196:199], v80, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[112:115], v[124:127], a[200:203], v80, v82 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[112:115], v[128:131], a[204:207], v80, v82 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[112:115], v[132:135], a[208:211], v80, v83 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[112:115], v[136:139], a[212:215], v80, v83 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[112:115], v[140:143], a[216:219], v80, v84 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[112:115], v[20:23], a[220:223], v80, v84 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[16:19], v[116:119], a[224:227], v80, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[16:19], v[120:123], a[228:231], v80, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[16:19], v[124:127], a[232:235], v80, v82 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[16:19], v[128:131], a[236:239], v80, v82 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[16:19], v[132:135], a[240:243], v80, v83 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[16:19], v[136:139], a[244:247], v80, v83 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[16:19], v[140:143], a[248:251], v80, v84 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[16:19], v[20:23], a[252:255], v80, v84 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s0, s12, 1
		s_lshl_b32 s1, s0, 16
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x24400, v1
		ds_read_b32 v1, v2
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v2, s1, v1
		s_mov_b32 s2, 0
		scratch_load_dword v1, off, s2 offset:116
		s_mov_b32 s2, 0
		scratch_load_dword v3, off, s2 offset:120
		s_waitcnt vmcnt(0)
		v_add3_u32 v4, v2, v1, v3
		ds_read_b128 v[8:11], v4
		ds_read_b128 v[12:15], v4 offset:1024
		ds_read_b128 v[16:19], v4 offset:2048
		ds_read_b128 v[20:23], v4 offset:3072
		ds_read_b128 v[24:27], v4 offset:4096
		ds_read_b128 v[28:31], v4 offset:5120
		ds_read_b128 v[32:35], v4 offset:6144
		ds_read_b128 v[36:39], v4 offset:7168
		s_mov_b32 s2, 0
		scratch_load_dword v1, off, s2 offset:116
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v2, s1, v1
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v3, 0x22800, v1
		ds_read_b32 v1, v3
		s_mov_b32 s1, 0
		scratch_load_dword v3, off, s1 offset:120
		s_waitcnt vmcnt(0) lgkmcnt(0)
		v_add3_u32 v5, v2, v1, v3
		ds_read_b128 v[40:43], v5 offset:32768
		ds_read_b128 v[44:47], v5 offset:33792
		ds_read_b128 v[48:51], v5 offset:34816
		ds_read_b128 v[52:55], v5 offset:35840
		ds_read_b128 v[56:59], v5 offset:36864
		ds_read_b128 v[60:63], v5 offset:37888
		ds_read_b128 v[64:67], v5 offset:38912
		ds_read_b128 v[68:71], v5 offset:39936
		s_lshl_b32 s1, s0, 12
		s_add_i32 s0, s1, 0x20000
		s_mov_b32 s1, 0
		scratch_load_dword v1, off, s1 offset:104
		s_mov_b32 s1, 0
		scratch_load_dword v2, off, s1 offset:112
		s_waitcnt vmcnt(0)
		v_add3_u32 v3, s0, v1, v2
		ds_read_b32 v1, v3
		ds_read_b32 v2, v3 offset:256
		ds_read_b32 v6, v3 offset:512
		ds_read_b32 v7, v3 offset:768
		s_mov_b32 s1, 0
		scratch_load_dword v3, off, s1 offset:108
		s_mov_b32 s1, 0
		scratch_load_dword v72, off, s1 offset:112
		s_waitcnt vmcnt(0)
		v_add3_u32 v73, s0, v72, v3
		ds_read_b32 v3, v73 offset:2048
		ds_read_b32 v72, v73 offset:2304
		ds_read_b32 v74, v73 offset:2560
		ds_read_b32 v75, v73 offset:2816
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[8:11], v[40:43], a[0:3], v1, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[76:79], v4 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[8:11], v[44:47], a[4:7], v1, v3 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[80:83], v4 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[8:11], v[48:51], a[8:11], v1, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[84:87], v4 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[8:11], v[52:55], a[12:15], v1, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v4 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[8:11], v[56:59], a[16:19], v1, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v4 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[8:11], v[60:63], a[20:23], v1, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v4 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[8:11], v[64:67], a[24:27], v1, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v4 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[8:11], v[68:71], a[28:31], v1, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[8:11], v4 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[12:15], v[40:43], a[32:35], v1, v3 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[104:107], v5 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[12:15], v[44:47], a[36:39], v1, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[108:111], v5 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[12:15], v[48:51], a[40:43], v1, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[112:115], v5 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[12:15], v[52:55], a[44:47], v1, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[116:119], v5 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[12:15], v[56:59], a[48:51], v1, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[120:123], v5 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[12:15], v[60:63], a[52:55], v1, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[124:127], v5 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[12:15], v[64:67], a[56:59], v1, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[128:131], v5 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[12:15], v[68:71], a[60:63], v1, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[12:15], v5 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[16:19], v[40:43], a[64:67], v2, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[16:19], v[44:47], a[68:71], v2, v3 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[16:19], v[48:51], a[72:75], v2, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[16:19], v[52:55], a[76:79], v2, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[16:19], v[56:59], a[80:83], v2, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[16:19], v[60:63], a[84:87], v2, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[16:19], v[64:67], a[88:91], v2, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[16:19], v[68:71], a[92:95], v2, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[20:23], v[40:43], a[96:99], v2, v3 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[20:23], v[44:47], a[100:103], v2, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[20:23], v[48:51], a[104:107], v2, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[20:23], v[52:55], a[108:111], v2, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[20:23], v[56:59], a[112:115], v2, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[20:23], v[60:63], a[116:119], v2, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[20:23], v[64:67], a[120:123], v2, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[20:23], v[68:71], a[124:127], v2, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[24:27], v[40:43], a[128:131], v6, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[24:27], v[44:47], a[132:135], v6, v3 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[24:27], v[48:51], a[136:139], v6, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[24:27], v[52:55], a[140:143], v6, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[24:27], v[56:59], a[144:147], v6, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[24:27], v[60:63], a[148:151], v6, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[24:27], v[64:67], a[152:155], v6, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[24:27], v[68:71], a[156:159], v6, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[28:31], v[40:43], a[160:163], v6, v3 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[28:31], v[44:47], a[164:167], v6, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[28:31], v[48:51], a[168:171], v6, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[28:31], v[52:55], a[172:175], v6, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[28:31], v[56:59], a[176:179], v6, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[28:31], v[60:63], a[180:183], v6, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[28:31], v[64:67], a[184:187], v6, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[28:31], v[68:71], a[188:191], v6, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[32:35], v[40:43], a[192:195], v7, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[32:35], v[44:47], a[196:199], v7, v3 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[32:35], v[48:51], a[200:203], v7, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[32:35], v[52:55], a[204:207], v7, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[32:35], v[56:59], a[208:211], v7, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[32:35], v[60:63], a[212:215], v7, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[32:35], v[64:67], a[216:219], v7, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[32:35], v[68:71], a[220:223], v7, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[36:39], v[40:43], a[224:227], v7, v3 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[36:39], v[44:47], a[228:231], v7, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[36:39], v[48:51], a[232:235], v7, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[36:39], v[52:55], a[236:239], v7, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[36:39], v[56:59], a[240:243], v7, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[36:39], v[60:63], a[244:247], v7, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[36:39], v[64:67], a[248:251], v7, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[36:39], v[68:71], a[252:255], v7, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[76:79], v[104:107], a[0:3], v1, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[76:79], v[108:111], a[4:7], v1, v3 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[76:79], v[112:115], a[8:11], v1, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[76:79], v[116:119], a[12:15], v1, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[76:79], v[120:123], a[16:19], v1, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[76:79], v[124:127], a[20:23], v1, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[76:79], v[128:131], a[24:27], v1, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[76:79], v[12:15], a[28:31], v1, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[80:83], v[104:107], a[32:35], v1, v3 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[80:83], v[108:111], a[36:39], v1, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[80:83], v[112:115], a[40:43], v1, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[80:83], v[116:119], a[44:47], v1, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[80:83], v[120:123], a[48:51], v1, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[80:83], v[124:127], a[52:55], v1, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[80:83], v[128:131], a[56:59], v1, v75 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[80:83], v[12:15], a[60:63], v1, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[84:87], v[104:107], a[64:67], v2, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[84:87], v[108:111], a[68:71], v2, v3 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[84:87], v[112:115], a[72:75], v2, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[84:87], v[116:119], a[76:79], v2, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[84:87], v[120:123], a[80:83], v2, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[84:87], v[124:127], a[84:87], v2, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[84:87], v[128:131], a[88:91], v2, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[84:87], v[12:15], a[92:95], v2, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[88:91], v[104:107], a[96:99], v2, v3 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[88:91], v[108:111], a[100:103], v2, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[88:91], v[112:115], a[104:107], v2, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[88:91], v[116:119], a[108:111], v2, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[88:91], v[120:123], a[112:115], v2, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[88:91], v[124:127], a[116:119], v2, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[88:91], v[128:131], a[120:123], v2, v75 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[88:91], v[12:15], a[124:127], v2, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[92:95], v[104:107], a[128:131], v6, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[92:95], v[108:111], a[132:135], v6, v3 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[92:95], v[112:115], a[136:139], v6, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[92:95], v[116:119], a[140:143], v6, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[92:95], v[120:123], a[144:147], v6, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[92:95], v[124:127], a[148:151], v6, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[92:95], v[128:131], a[152:155], v6, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[92:95], v[12:15], a[156:159], v6, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[96:99], v[104:107], a[160:163], v6, v3 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[96:99], v[108:111], a[164:167], v6, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[96:99], v[112:115], a[168:171], v6, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[96:99], v[116:119], a[172:175], v6, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[96:99], v[120:123], a[176:179], v6, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[96:99], v[124:127], a[180:183], v6, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[96:99], v[128:131], a[184:187], v6, v75 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[96:99], v[12:15], a[188:191], v6, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[100:103], v[104:107], a[192:195], v7, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[100:103], v[108:111], a[196:199], v7, v3 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[100:103], v[112:115], a[200:203], v7, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[100:103], v[116:119], a[204:207], v7, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[100:103], v[120:123], a[208:211], v7, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[100:103], v[124:127], a[212:215], v7, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[100:103], v[128:131], a[216:219], v7, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[100:103], v[12:15], a[220:223], v7, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[8:11], v[104:107], a[224:227], v7, v3 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[8:11], v[108:111], a[228:231], v7, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[8:11], v[112:115], a[232:235], v7, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[8:11], v[116:119], a[236:239], v7, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[8:11], v[120:123], a[240:243], v7, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[8:11], v[124:127], a[244:247], v7, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[8:11], v[128:131], a[248:251], v7, v75 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[8:11], v[12:15], a[252:255], v7, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v1, a0
		v_accvgpr_read_b32 v2, a1
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a2
		v_accvgpr_read_b32 v2, a3
		v_cvt_pk_f16_f32 v5, v1, v2
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x22400, v1
		ds_read_b32 v1, v2
		s_waitcnt lgkmcnt(0)
		v_lshlrev_b32_e32 v2, 3, v1
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v0, 0x22000, v1
		ds_read_b32 v1, v0
		s_waitcnt lgkmcnt(0)
		v_lshl_add_u32 v0, v1, 15, v2
		s_lshl_b32 s0, s13, 21
		s_lshl_b32 s1, s14, 17
		s_add_i32 s2, s0, s1
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen
		v_accvgpr_read_b32 v1, a4
		v_accvgpr_read_b32 v2, a5
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a6
		v_accvgpr_read_b32 v2, a7
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:512
		v_accvgpr_read_b32 v1, a8
		v_accvgpr_read_b32 v2, a9
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a10
		v_accvgpr_read_b32 v2, a11
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1024
		v_accvgpr_read_b32 v1, a12
		v_accvgpr_read_b32 v2, a13
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a14
		v_accvgpr_read_b32 v2, a15
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1536
		v_accvgpr_read_b32 v1, a16
		v_accvgpr_read_b32 v2, a17
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a18
		v_accvgpr_read_b32 v2, a19
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2048
		v_accvgpr_read_b32 v1, a20
		v_accvgpr_read_b32 v2, a21
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a22
		v_accvgpr_read_b32 v2, a23
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2560
		v_accvgpr_read_b32 v1, a24
		v_accvgpr_read_b32 v2, a25
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a26
		v_accvgpr_read_b32 v2, a27
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3072
		v_accvgpr_read_b32 v1, a28
		v_accvgpr_read_b32 v2, a29
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a30
		v_accvgpr_read_b32 v2, a31
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a32
		v_accvgpr_read_b32 v2, a33
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a34
		v_accvgpr_read_b32 v2, a35
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x1000
		s_add_i32 s3, s2, s1
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen
		v_accvgpr_read_b32 v1, a36
		v_accvgpr_read_b32 v2, a37
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a38
		v_accvgpr_read_b32 v2, a39
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:512
		v_accvgpr_read_b32 v1, a40
		v_accvgpr_read_b32 v2, a41
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a42
		v_accvgpr_read_b32 v2, a43
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:1024
		v_accvgpr_read_b32 v1, a44
		v_accvgpr_read_b32 v2, a45
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a46
		v_accvgpr_read_b32 v2, a47
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:1536
		v_accvgpr_read_b32 v1, a48
		v_accvgpr_read_b32 v2, a49
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a50
		v_accvgpr_read_b32 v2, a51
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:2048
		v_accvgpr_read_b32 v1, a52
		v_accvgpr_read_b32 v2, a53
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a54
		v_accvgpr_read_b32 v2, a55
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:2560
		v_accvgpr_read_b32 v1, a56
		v_accvgpr_read_b32 v2, a57
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a58
		v_accvgpr_read_b32 v2, a59
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:3072
		v_accvgpr_read_b32 v1, a60
		v_accvgpr_read_b32 v2, a61
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a62
		v_accvgpr_read_b32 v2, a63
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:3584
		v_accvgpr_read_b32 v1, a64
		v_accvgpr_read_b32 v2, a65
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a66
		v_accvgpr_read_b32 v2, a67
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x2000
		s_add_i32 s3, s2, s1
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen
		v_accvgpr_read_b32 v1, a68
		v_accvgpr_read_b32 v2, a69
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a70
		v_accvgpr_read_b32 v2, a71
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:512
		v_accvgpr_read_b32 v1, a72
		v_accvgpr_read_b32 v2, a73
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a74
		v_accvgpr_read_b32 v2, a75
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:1024
		v_accvgpr_read_b32 v1, a76
		v_accvgpr_read_b32 v2, a77
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a78
		v_accvgpr_read_b32 v2, a79
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:1536
		v_accvgpr_read_b32 v1, a80
		v_accvgpr_read_b32 v2, a81
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a82
		v_accvgpr_read_b32 v2, a83
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:2048
		v_accvgpr_read_b32 v1, a84
		v_accvgpr_read_b32 v2, a85
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a86
		v_accvgpr_read_b32 v2, a87
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:2560
		v_accvgpr_read_b32 v1, a88
		v_accvgpr_read_b32 v2, a89
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a90
		v_accvgpr_read_b32 v2, a91
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:3072
		v_accvgpr_read_b32 v1, a92
		v_accvgpr_read_b32 v2, a93
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a94
		v_accvgpr_read_b32 v2, a95
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:3584
		v_accvgpr_read_b32 v1, a96
		v_accvgpr_read_b32 v2, a97
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a98
		v_accvgpr_read_b32 v2, a99
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x3000
		s_add_i32 s3, s2, s1
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen
		v_accvgpr_read_b32 v1, a100
		v_accvgpr_read_b32 v2, a101
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a102
		v_accvgpr_read_b32 v2, a103
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:512
		v_accvgpr_read_b32 v1, a104
		v_accvgpr_read_b32 v2, a105
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a106
		v_accvgpr_read_b32 v2, a107
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:1024
		v_accvgpr_read_b32 v1, a108
		v_accvgpr_read_b32 v2, a109
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a110
		v_accvgpr_read_b32 v2, a111
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:1536
		v_accvgpr_read_b32 v1, a112
		v_accvgpr_read_b32 v2, a113
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a114
		v_accvgpr_read_b32 v2, a115
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:2048
		v_accvgpr_read_b32 v1, a116
		v_accvgpr_read_b32 v2, a117
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a118
		v_accvgpr_read_b32 v2, a119
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:2560
		v_accvgpr_read_b32 v1, a120
		v_accvgpr_read_b32 v2, a121
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a122
		v_accvgpr_read_b32 v2, a123
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:3072
		v_accvgpr_read_b32 v1, a124
		v_accvgpr_read_b32 v2, a125
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a126
		v_accvgpr_read_b32 v2, a127
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:3584
		v_accvgpr_read_b32 v1, a128
		v_accvgpr_read_b32 v2, a129
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a130
		v_accvgpr_read_b32 v2, a131
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x4000
		s_add_i32 s3, s2, s1
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen
		v_accvgpr_read_b32 v1, a132
		v_accvgpr_read_b32 v2, a133
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a134
		v_accvgpr_read_b32 v2, a135
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:512
		v_accvgpr_read_b32 v1, a136
		v_accvgpr_read_b32 v2, a137
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a138
		v_accvgpr_read_b32 v2, a139
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:1024
		v_accvgpr_read_b32 v1, a140
		v_accvgpr_read_b32 v2, a141
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a142
		v_accvgpr_read_b32 v2, a143
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:1536
		v_accvgpr_read_b32 v1, a144
		v_accvgpr_read_b32 v2, a145
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a146
		v_accvgpr_read_b32 v2, a147
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:2048
		v_accvgpr_read_b32 v1, a148
		v_accvgpr_read_b32 v2, a149
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a150
		v_accvgpr_read_b32 v2, a151
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:2560
		v_accvgpr_read_b32 v1, a152
		v_accvgpr_read_b32 v2, a153
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a154
		v_accvgpr_read_b32 v2, a155
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:3072
		v_accvgpr_read_b32 v1, a156
		v_accvgpr_read_b32 v2, a157
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a158
		v_accvgpr_read_b32 v2, a159
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:3584
		v_accvgpr_read_b32 v1, a160
		v_accvgpr_read_b32 v2, a161
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a162
		v_accvgpr_read_b32 v2, a163
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x5000
		s_add_i32 s3, s2, s1
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen
		v_accvgpr_read_b32 v1, a164
		v_accvgpr_read_b32 v2, a165
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a166
		v_accvgpr_read_b32 v2, a167
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:512
		v_accvgpr_read_b32 v1, a168
		v_accvgpr_read_b32 v2, a169
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a170
		v_accvgpr_read_b32 v2, a171
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:1024
		v_accvgpr_read_b32 v1, a172
		v_accvgpr_read_b32 v2, a173
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a174
		v_accvgpr_read_b32 v2, a175
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:1536
		v_accvgpr_read_b32 v1, a176
		v_accvgpr_read_b32 v2, a177
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a178
		v_accvgpr_read_b32 v2, a179
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:2048
		v_accvgpr_read_b32 v1, a180
		v_accvgpr_read_b32 v2, a181
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a182
		v_accvgpr_read_b32 v2, a183
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:2560
		v_accvgpr_read_b32 v1, a184
		v_accvgpr_read_b32 v2, a185
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a186
		v_accvgpr_read_b32 v2, a187
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:3072
		v_accvgpr_read_b32 v1, a188
		v_accvgpr_read_b32 v2, a189
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a190
		v_accvgpr_read_b32 v2, a191
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:3584
		v_accvgpr_read_b32 v1, a192
		v_accvgpr_read_b32 v2, a193
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a194
		v_accvgpr_read_b32 v2, a195
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x6000
		s_add_i32 s3, s2, s1
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen
		v_accvgpr_read_b32 v1, a196
		v_accvgpr_read_b32 v2, a197
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a198
		v_accvgpr_read_b32 v2, a199
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:512
		v_accvgpr_read_b32 v1, a200
		v_accvgpr_read_b32 v2, a201
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a202
		v_accvgpr_read_b32 v2, a203
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:1024
		v_accvgpr_read_b32 v1, a204
		v_accvgpr_read_b32 v2, a205
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a206
		v_accvgpr_read_b32 v2, a207
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:1536
		v_accvgpr_read_b32 v1, a208
		v_accvgpr_read_b32 v2, a209
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a210
		v_accvgpr_read_b32 v2, a211
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:2048
		v_accvgpr_read_b32 v1, a212
		v_accvgpr_read_b32 v2, a213
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a214
		v_accvgpr_read_b32 v2, a215
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:2560
		v_accvgpr_read_b32 v1, a216
		v_accvgpr_read_b32 v2, a217
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a218
		v_accvgpr_read_b32 v2, a219
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:3072
		v_accvgpr_read_b32 v1, a220
		v_accvgpr_read_b32 v2, a221
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a222
		v_accvgpr_read_b32 v2, a223
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s3 offen offset:3584
		v_accvgpr_read_b32 v1, a224
		v_accvgpr_read_b32 v2, a225
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a226
		v_accvgpr_read_b32 v2, a227
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x7000
		s_add_i32 s0, s2, s1
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen
		v_accvgpr_read_b32 v1, a228
		v_accvgpr_read_b32 v2, a229
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a230
		v_accvgpr_read_b32 v2, a231
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:512
		v_accvgpr_read_b32 v1, a232
		v_accvgpr_read_b32 v2, a233
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a234
		v_accvgpr_read_b32 v2, a235
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:1024
		v_accvgpr_read_b32 v1, a236
		v_accvgpr_read_b32 v2, a237
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a238
		v_accvgpr_read_b32 v2, a239
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:1536
		v_accvgpr_read_b32 v1, a240
		v_accvgpr_read_b32 v2, a241
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a242
		v_accvgpr_read_b32 v2, a243
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:2048
		v_accvgpr_read_b32 v1, a244
		v_accvgpr_read_b32 v2, a245
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a246
		v_accvgpr_read_b32 v2, a247
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:2560
		v_accvgpr_read_b32 v1, a248
		v_accvgpr_read_b32 v2, a249
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a250
		v_accvgpr_read_b32 v2, a251
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:3072
		v_accvgpr_read_b32 v1, a252
		v_accvgpr_read_b32 v2, a253
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a254
		v_accvgpr_read_b32 v2, a255
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:3584
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 24576
		.amdhsa_private_segment_fixed_size 492
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
		.amdhsa_next_free_sgpr 64
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
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 64
	.set .Lwmma_f16_matmul_tiled.num_named_barrier, 0
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 492
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
    .private_segment_fixed_size: 492
    .sgpr_count:     64
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     512
    .agpr_count:     256
    .vgpr_spill_count: 123
    .wavefront_size: 64
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
