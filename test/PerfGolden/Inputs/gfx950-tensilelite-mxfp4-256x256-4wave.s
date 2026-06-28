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
		s_lshl_b32 s16, s15, 2
		s_add_i32 s15, s16, 0x22000
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
		v_lshlrev_b32_e32 v2, 16, v1
		v_add_u32_e32 v3, s9, v2
		v_and_b32_e32 v4, 63, v0
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
		s_lshl_b32 s28, s11, 10
		s_add_i32 s29, s28, 0x1000
		s_add_i32 s30, s28, 0x2000
		s_add_i32 s31, s28, 0x3000
		s_add_i32 s32, s28, 0x4000
		s_add_i32 s33, s28, 0x5000
		s_add_i32 s34, s28, 0x6000
		s_add_i32 s35, s28, 0x7000
		s_add_i32 s36, s28, 0x8000
		s_add_i32 s37, s28, 0x9000
		s_add_i32 s38, s28, 0xa000
		s_add_i32 s39, s28, 0xb000
		s_add_i32 s40, s28, 0xc000
		s_add_i32 s41, s28, 0xd000
		s_add_i32 s42, s28, 0xe000
		s_add_i32 s43, s28, 0xf000
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v9, s[20:23], 0 offen lds
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v11, s[20:23], 0 offen lds
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v15, s[0:3], 0 offen lds
		s_mov_b32 m0, s37
		s_nop 0
		buffer_load_dwordx4 v16, s[0:3], 0 offen lds
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v17, s[0:3], 0 offen lds
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v18, s[0:3], 0 offen lds
		s_mov_b32 m0, s40
		s_nop 0
		buffer_load_dwordx4 v19, s[0:3], 0 offen lds
		s_mov_b32 m0, s41
		s_nop 0
		buffer_load_dwordx4 v20, s[0:3], 0 offen lds
		s_mov_b32 m0, s42
		s_nop 0
		buffer_load_dwordx4 v21, s[0:3], 0 offen lds
		s_mov_b32 m0, s43
		s_nop 0
		buffer_load_dwordx4 v22, s[0:3], 0 offen lds
		s_lshl_b32 s44, s14, 16
		s_add_i32 s45, s9, s44
		v_lshrrev_b32_e32 v3, 7, v0
		v_lshlrev_b32_e32 v7, 10, v3
		v_lshlrev_b32_e32 v8, 4, v4
		v_add3_u32 v9, s45, v7, v8
		s_lshr_b32 s46, s8, 7
		s_lshl_b32 s8, s46, 10
		v_and_b32_e32 v10, 1, v1
		v_lshlrev_b32_e32 v1, 10, v10
		v_add3_u32 v11, s45, v8, v1
		s_and_b32 s45, s11, 1
		s_lshl_b32 s11, s45, 10
		s_add_i32 s45, s11, 0x800
		s_add_i32 m0, s8, 0x20000
		s_nop 0
		buffer_load_dwordx4 v9, s[4:7], 0 offen lds
		s_add_i32 m0, s11, 0x20800
		s_nop 0
		buffer_load_dwordx4 v11, s[24:27], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v9, 13, v3
		v_and_b32_e32 v3, 15, v0
		v_lshlrev_b32_e32 v11, 6, v3
		v_lshrrev_b32_e32 v12, 4, v4
		v_lshrrev_b32_e32 v13, 1, v3
		v_and_b32_e32 v3, 3, v13
		v_xor_b32_e32 v13, v12, v3
		v_lshlrev_b32_e32 v3, 4, v13
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
		v_add_u32_e32 v4, v10, v13
		ds_read_b32 v10, v4
		s_mov_b32 m0, s15
		s_waitcnt lgkmcnt(0)
		s_nop 0
		ds_write_addtid_b32 v10 offset:23552
		ds_read_b32 v10, v4 offset:256
		ds_read_b32 v14, v4 offset:512
		ds_read_b32 v15, v4 offset:768
		v_add_u32_e32 v4, 0x20000, v13
		v_add_u32_e32 v13, v4, v1
		ds_read_b32 v4, v13 offset:2048
		ds_read_b32 v80, v13 offset:2304
		ds_read_b32 v81, v13 offset:2560
		ds_read_b32 v82, v13 offset:2816
		s_waitcnt lgkmcnt(0)
		s_add_i32 s46, s9, 0x80
		v_add_u32_e32 v13, s46, v2
		v_add3_u32 v83, v13, v6, v5
		s_add_i32 s46, s9, 0x40080
		v_add_u32_e32 v13, s46, v2
		v_add3_u32 v84, v13, v6, v5
		s_add_i32 s46, s9, 0x80080
		v_add_u32_e32 v13, s46, v2
		v_add3_u32 v85, v13, v6, v5
		s_add_i32 s46, s9, 0xc0080
		v_add_u32_e32 v13, s46, v2
		v_add3_u32 v86, v13, v6, v5
		s_add_i32 s46, s9, 0xc0
		v_add_u32_e32 v13, s46, v2
		v_add3_u32 v87, v13, v6, v5
		s_add_i32 s46, s9, 0x400c0
		v_add_u32_e32 v13, s46, v2
		v_add3_u32 v88, v13, v6, v5
		s_add_i32 s46, s9, 0x800c0
		v_add_u32_e32 v13, s46, v2
		v_add3_u32 v89, v13, v6, v5
		s_add_i32 s46, s9, 0xc00c0
		v_add_u32_e32 v13, s46, v2
		v_add3_u32 v90, v13, v6, v5
		s_add_i32 s46, s10, 0x80
		v_add_u32_e32 v13, s46, v2
		v_add3_u32 v91, v13, v6, v5
		s_add_i32 s46, s10, 0x40080
		v_add_u32_e32 v13, s46, v2
		v_add3_u32 v92, v13, v6, v5
		s_add_i32 s46, s10, 0x80080
		v_add_u32_e32 v13, s46, v2
		v_add3_u32 v93, v13, v6, v5
		s_add_i32 s46, s10, 0xc0080
		v_add_u32_e32 v13, s46, v2
		v_add3_u32 v94, v13, v6, v5
		s_add_i32 s46, s10, 0xc0
		v_add_u32_e32 v13, s46, v2
		v_add3_u32 v95, v13, v6, v5
		s_add_i32 s46, s10, 0x400c0
		v_add_u32_e32 v13, s46, v2
		v_add3_u32 v96, v13, v6, v5
		s_add_i32 s46, s10, 0x800c0
		v_add_u32_e32 v13, s46, v2
		v_add3_u32 v97, v13, v6, v5
		s_add_i32 s46, s10, 0xc00c0
		v_add_u32_e32 v13, s46, v2
		v_add3_u32 v2, v13, v6, v5
		s_add_i32 s10, s28, 0x10000
		s_add_i32 s46, s28, 0x11000
		s_add_i32 s47, s28, 0x12000
		s_add_i32 s48, s28, 0x13000
		s_add_i32 s49, s28, 0x14000
		s_add_i32 s50, s28, 0x15000
		s_add_i32 s51, s28, 0x16000
		s_add_i32 s52, s28, 0x17000
		s_add_i32 s53, s28, 0x18000
		s_add_i32 s54, s28, 0x19000
		s_add_i32 s55, s28, 0x1a000
		s_add_i32 s56, s28, 0x1b000
		s_add_i32 s57, s28, 0x1c000
		s_add_i32 s58, s28, 0x1d000
		s_add_i32 s59, s28, 0x1e000
		s_add_i32 s60, s28, 0x1f000
		s_mov_b32 m0, s10
		s_nop 0
		buffer_load_dwordx4 v83, s[20:23], 0 offen lds
		s_mov_b32 m0, s46
		s_nop 0
		buffer_load_dwordx4 v84, s[20:23], 0 offen lds
		s_mov_b32 m0, s47
		s_nop 0
		buffer_load_dwordx4 v85, s[20:23], 0 offen lds
		s_mov_b32 m0, s48
		s_nop 0
		buffer_load_dwordx4 v86, s[20:23], 0 offen lds
		s_mov_b32 m0, s49
		s_nop 0
		buffer_load_dwordx4 v87, s[20:23], 0 offen lds
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v88, s[20:23], 0 offen lds
		s_mov_b32 m0, s51
		s_nop 0
		buffer_load_dwordx4 v89, s[20:23], 0 offen lds
		s_mov_b32 m0, s52
		s_nop 0
		buffer_load_dwordx4 v90, s[20:23], 0 offen lds
		s_mov_b32 m0, s53
		s_nop 0
		buffer_load_dwordx4 v91, s[0:3], 0 offen lds
		s_mov_b32 m0, s54
		s_nop 0
		buffer_load_dwordx4 v92, s[0:3], 0 offen lds
		s_mov_b32 m0, s55
		s_nop 0
		buffer_load_dwordx4 v93, s[0:3], 0 offen lds
		s_mov_b32 m0, s56
		s_nop 0
		buffer_load_dwordx4 v94, s[0:3], 0 offen lds
		s_mov_b32 m0, s57
		s_nop 0
		buffer_load_dwordx4 v95, s[0:3], 0 offen lds
		s_mov_b32 m0, s58
		s_nop 0
		buffer_load_dwordx4 v96, s[0:3], 0 offen lds
		s_mov_b32 m0, s59
		s_nop 0
		buffer_load_dwordx4 v97, s[0:3], 0 offen lds
		s_mov_b32 m0, s60
		s_nop 0
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_add_i32 s61, s9, 0x800
		s_add_i32 s9, s61, s44
		v_add3_u32 v2, s9, v7, v8
		s_add_i32 s44, s8, 0x1000
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
		s_mov_b32 s61, 2
		v_mov_b32_e32 v6, s13
		v_mov_b32_e32 v7, 0
		s_mov_b32 s62, 0x100000
		s_mov_b32 s63, 0
		v_mov_b32_e32 v84, s62
		v_mov_b32_e32 v85, s63
		v_mul_lo_u32 v86, v84, v6
		v_mul_hi_u32 v87, v84, v6
		v_mul_lo_u32 v1, v84, v7
		v_add_u32_e32 v87, v87, v1
		v_mul_lo_u32 v1, v85, v6
		v_add_u32_e32 v87, v87, v1
		s_mov_b32 s62, 1
		s_mov_b32 s63, 0
		v_mov_b32_e32 v88, v0
		v_mov_b32_e32 v89, 0
		v_mov_b32_e32 v90, s62
		v_mov_b32_e32 v91, s63
		v_mul_lo_u32 v92, v90, v88
		v_mul_hi_u32 v93, v90, v88
		v_mul_lo_u32 v1, v90, v89
		v_add_u32_e32 v93, v93, v1
		v_mul_lo_u32 v1, v91, v88
		v_add_u32_e32 v93, v93, v1
		v_lshrrev_b64 v[94:95], 6, v[92:93]
		s_mov_b32 s62, 0x10000
		s_mov_b32 s63, 0
		v_mov_b32_e32 v96, s62
		v_mov_b32_e32 v97, s63
		v_mul_lo_u32 v98, v96, v94
		v_mul_hi_u32 v99, v96, v94
		v_mul_lo_u32 v1, v96, v95
		v_add_u32_e32 v99, v99, v1
		v_mul_lo_u32 v1, v97, v94
		v_add_u32_e32 v99, v99, v1
		v_add_co_u32_e64 v100, vcc, v86, v98
		v_addc_co_u32_e64 v101, vcc, v87, v99, vcc
		v_mov_b32_e32 v1, 63
		v_and_b32_e32 v102, v88, v1
		v_and_b32_e32 v103, v7, v7
		v_mul_lo_u32 v88, v90, v102
		v_mul_hi_u32 v89, v90, v102
		v_mul_lo_u32 v1, v90, v103
		v_add_u32_e32 v89, v89, v1
		v_mul_lo_u32 v1, v91, v102
		v_add_u32_e32 v89, v89, v1
		v_lshrrev_b64 v[90:91], 2, v[88:89]
		s_mov_b32 s62, 0x1000
		s_mov_b32 s63, 0
		v_mov_b32_e32 v104, s62
		v_mov_b32_e32 v105, s63
		v_mul_lo_u32 v106, v104, v90
		v_mul_hi_u32 v107, v104, v90
		v_mul_lo_u32 v1, v104, v91
		v_add_u32_e32 v107, v107, v1
		v_mul_lo_u32 v1, v105, v90
		v_add_u32_e32 v107, v107, v1
		v_add_co_u32_e64 v90, vcc, v100, v106
		v_addc_co_u32_e64 v91, vcc, v101, v107, vcc
		v_lshrrev_b64 v[100:101], 3, v[88:89]
		v_mov_b32_e32 v1, 3
		v_and_b32_e32 v88, v100, v1
		v_and_b32_e32 v89, v101, v7
		v_and_b32_e32 v100, v102, v1
		v_and_b32_e32 v101, v103, v7
		v_xor_b32_e32 v104, v88, v100
		v_xor_b32_e32 v105, v89, v101
		s_mov_b32 s62, 16
		s_mov_b32 s63, 0
		v_mov_b32_e32 v88, s62
		v_mov_b32_e32 v89, s63
		v_mul_lo_u32 v100, v88, v104
		v_mul_hi_u32 v101, v88, v104
		v_mul_lo_u32 v1, v88, v105
		v_add_u32_e32 v101, v101, v1
		v_mul_lo_u32 v1, v89, v104
		v_add_u32_e32 v101, v101, v1
		v_add_co_u32_e64 v104, vcc, v90, v100
		v_addc_co_u32_e64 v105, vcc, v91, v101, vcc
		s_mov_b32 s62, 0x80
		s_mov_b32 s63, 0
		v_mov_b32_e32 v90, s62
		v_mov_b32_e32 v91, s63
		v_mov_b32_e32 v1, 0x40000
		v_add_co_u32_e64 v108, vcc, v86, v1
		v_addc_co_u32_e64 v109, vcc, v87, 0, vcc
		v_add_co_u32_e64 v110, vcc, v108, v98
		v_addc_co_u32_e64 v111, vcc, v109, v99, vcc
		v_add_co_u32_e64 v108, vcc, v110, v106
		v_addc_co_u32_e64 v109, vcc, v111, v107, vcc
		v_add_co_u32_e64 v110, vcc, v108, v100
		v_addc_co_u32_e64 v111, vcc, v109, v101, vcc
		v_mov_b32_e32 v2, 0x80000
		v_add_co_u32_e64 v108, vcc, v86, v2
		v_addc_co_u32_e64 v109, vcc, v87, 0, vcc
		v_add_co_u32_e64 v112, vcc, v108, v98
		v_addc_co_u32_e64 v113, vcc, v109, v99, vcc
		v_add_co_u32_e64 v108, vcc, v112, v106
		v_addc_co_u32_e64 v109, vcc, v113, v107, vcc
		v_add_co_u32_e64 v112, vcc, v108, v100
		v_addc_co_u32_e64 v113, vcc, v109, v101, vcc
		v_mov_b32_e32 v5, 0xc0000
		v_add_co_u32_e64 v108, vcc, v86, v5
		v_addc_co_u32_e64 v109, vcc, v87, 0, vcc
		v_add_co_u32_e64 v114, vcc, v108, v98
		v_addc_co_u32_e64 v115, vcc, v109, v99, vcc
		v_add_co_u32_e64 v108, vcc, v114, v106
		v_addc_co_u32_e64 v109, vcc, v115, v107, vcc
		v_add_co_u32_e64 v114, vcc, v108, v100
		v_addc_co_u32_e64 v115, vcc, v109, v101, vcc
		v_mov_b32_e32 v8, 64
		v_add_co_u32_e64 v108, vcc, v86, v8
		v_addc_co_u32_e64 v109, vcc, v87, 0, vcc
		v_add_co_u32_e64 v116, vcc, v108, v98
		v_addc_co_u32_e64 v117, vcc, v109, v99, vcc
		v_add_co_u32_e64 v108, vcc, v116, v106
		v_addc_co_u32_e64 v109, vcc, v117, v107, vcc
		v_add_co_u32_e64 v116, vcc, v108, v100
		v_addc_co_u32_e64 v117, vcc, v109, v101, vcc
		v_mov_b32_e32 v13, 0x40040
		v_add_co_u32_e64 v108, vcc, v86, v13
		v_addc_co_u32_e64 v109, vcc, v87, 0, vcc
		v_add_co_u32_e64 v118, vcc, v108, v98
		v_addc_co_u32_e64 v119, vcc, v109, v99, vcc
		v_add_co_u32_e64 v108, vcc, v118, v106
		v_addc_co_u32_e64 v109, vcc, v119, v107, vcc
		v_add_co_u32_e64 v118, vcc, v108, v100
		v_addc_co_u32_e64 v119, vcc, v109, v101, vcc
		v_mov_b32_e32 v83, 0x80040
		v_add_co_u32_e64 v108, vcc, v86, v83
		v_addc_co_u32_e64 v109, vcc, v87, 0, vcc
		v_add_co_u32_e64 v120, vcc, v108, v98
		v_addc_co_u32_e64 v121, vcc, v109, v99, vcc
		v_add_co_u32_e64 v108, vcc, v120, v106
		v_addc_co_u32_e64 v109, vcc, v121, v107, vcc
		v_add_co_u32_e64 v120, vcc, v108, v100
		v_addc_co_u32_e64 v121, vcc, v109, v101, vcc
		v_mov_b32_e32 v108, 0xc0040
		v_add_co_u32_e64 v122, vcc, v86, v108
		v_addc_co_u32_e64 v123, vcc, v87, 0, vcc
		v_add_co_u32_e64 v124, vcc, v122, v98
		v_addc_co_u32_e64 v125, vcc, v123, v99, vcc
		v_add_co_u32_e64 v122, vcc, v124, v106
		v_addc_co_u32_e64 v123, vcc, v125, v107, vcc
		v_add_co_u32_e64 v124, vcc, v122, v100
		v_addc_co_u32_e64 v125, vcc, v123, v101, vcc
		v_mov_b32_e32 v122, s14
		v_mov_b32_e32 v123, 0
		v_mul_lo_u32 v126, v84, v122
		v_mul_hi_u32 v127, v84, v122
		v_mul_lo_u32 v109, v84, v123
		v_add_u32_e32 v127, v127, v109
		v_mul_lo_u32 v109, v85, v122
		v_add_u32_e32 v127, v127, v109
		v_add_co_u32_e64 v84, vcc, v126, v98
		v_addc_co_u32_e64 v85, vcc, v127, v99, vcc
		v_add_co_u32_e64 v128, vcc, v84, v106
		v_addc_co_u32_e64 v129, vcc, v85, v107, vcc
		v_add_co_u32_e64 v84, vcc, v128, v100
		v_addc_co_u32_e64 v85, vcc, v129, v101, vcc
		v_add_co_u32_e64 v128, vcc, v126, v1
		v_addc_co_u32_e64 v129, vcc, v127, 0, vcc
		v_add_co_u32_e64 v130, vcc, v128, v98
		v_addc_co_u32_e64 v131, vcc, v129, v99, vcc
		v_add_co_u32_e64 v128, vcc, v130, v106
		v_addc_co_u32_e64 v129, vcc, v131, v107, vcc
		v_add_co_u32_e64 v130, vcc, v128, v100
		v_addc_co_u32_e64 v131, vcc, v129, v101, vcc
		v_add_co_u32_e64 v128, vcc, v126, v2
		v_addc_co_u32_e64 v129, vcc, v127, 0, vcc
		v_add_co_u32_e64 v132, vcc, v128, v98
		v_addc_co_u32_e64 v133, vcc, v129, v99, vcc
		v_add_co_u32_e64 v128, vcc, v132, v106
		v_addc_co_u32_e64 v129, vcc, v133, v107, vcc
		v_add_co_u32_e64 v132, vcc, v128, v100
		v_addc_co_u32_e64 v133, vcc, v129, v101, vcc
		v_add_co_u32_e64 v128, vcc, v126, v5
		v_addc_co_u32_e64 v129, vcc, v127, 0, vcc
		v_add_co_u32_e64 v134, vcc, v128, v98
		v_addc_co_u32_e64 v135, vcc, v129, v99, vcc
		v_add_co_u32_e64 v128, vcc, v134, v106
		v_addc_co_u32_e64 v129, vcc, v135, v107, vcc
		v_add_co_u32_e64 v134, vcc, v128, v100
		v_addc_co_u32_e64 v135, vcc, v129, v101, vcc
		v_add_co_u32_e64 v128, vcc, v126, v8
		v_addc_co_u32_e64 v129, vcc, v127, 0, vcc
		v_add_co_u32_e64 v136, vcc, v128, v98
		v_addc_co_u32_e64 v137, vcc, v129, v99, vcc
		v_add_co_u32_e64 v128, vcc, v136, v106
		v_addc_co_u32_e64 v129, vcc, v137, v107, vcc
		v_add_co_u32_e64 v136, vcc, v128, v100
		v_addc_co_u32_e64 v137, vcc, v129, v101, vcc
		v_add_co_u32_e64 v128, vcc, v126, v13
		v_addc_co_u32_e64 v129, vcc, v127, 0, vcc
		v_add_co_u32_e64 v138, vcc, v128, v98
		v_addc_co_u32_e64 v139, vcc, v129, v99, vcc
		v_add_co_u32_e64 v128, vcc, v138, v106
		v_addc_co_u32_e64 v129, vcc, v139, v107, vcc
		v_add_co_u32_e64 v138, vcc, v128, v100
		v_addc_co_u32_e64 v139, vcc, v129, v101, vcc
		v_add_co_u32_e64 v128, vcc, v126, v83
		v_addc_co_u32_e64 v129, vcc, v127, 0, vcc
		v_add_co_u32_e64 v140, vcc, v128, v98
		v_addc_co_u32_e64 v141, vcc, v129, v99, vcc
		v_add_co_u32_e64 v128, vcc, v140, v106
		v_addc_co_u32_e64 v129, vcc, v141, v107, vcc
		v_add_co_u32_e64 v140, vcc, v128, v100
		v_addc_co_u32_e64 v141, vcc, v129, v101, vcc
		v_add_co_u32_e64 v128, vcc, v126, v108
		v_addc_co_u32_e64 v129, vcc, v127, 0, vcc
		v_add_co_u32_e64 v108, vcc, v128, v98
		v_addc_co_u32_e64 v109, vcc, v129, v99, vcc
		v_add_co_u32_e64 v128, vcc, v108, v106
		v_addc_co_u32_e64 v129, vcc, v109, v107, vcc
		v_add_co_u32_e64 v108, vcc, v128, v100
		v_addc_co_u32_e64 v109, vcc, v129, v101, vcc
		v_mul_lo_u32 v128, v96, v122
		v_mul_hi_u32 v129, v96, v122
		v_mul_lo_u32 v1, v96, v123
		v_add_u32_e32 v129, v129, v1
		v_mul_lo_u32 v1, v97, v122
		v_add_u32_e32 v129, v129, v1
		v_add_co_u32_e64 v96, vcc, v86, v128
		v_addc_co_u32_e64 v97, vcc, v87, v129, vcc
		v_lshrrev_b64 v[122:123], 7, v[92:93]
		s_mov_b32 s62, 0x400
		s_mov_b32 s63, 0
		v_mov_b32_e32 v92, s62
		v_mov_b32_e32 v93, s63
		v_mul_lo_u32 v142, v92, v122
		v_mul_hi_u32 v143, v92, v122
		v_mul_lo_u32 v1, v92, v123
		v_add_u32_e32 v143, v143, v1
		v_mul_lo_u32 v1, v93, v122
		v_add_u32_e32 v143, v143, v1
		v_add_co_u32_e64 v122, vcc, v96, v142
		v_addc_co_u32_e64 v123, vcc, v97, v143, vcc
		v_mul_lo_u32 v144, v88, v102
		v_mul_hi_u32 v145, v88, v102
		v_mul_lo_u32 v1, v88, v103
		v_add_u32_e32 v145, v145, v1
		v_mul_lo_u32 v1, v89, v102
		v_add_u32_e32 v145, v145, v1
		v_add_co_u32_e64 v88, vcc, v122, v144
		v_addc_co_u32_e64 v89, vcc, v123, v145, vcc
		s_mov_b32 s62, 0x800
		s_mov_b32 s63, 0
		v_mov_b32_e32 v102, s62
		v_mov_b32_e32 v103, s63
		v_add_co_u32_e64 v122, vcc, v96, v144
		v_addc_co_u32_e64 v123, vcc, v97, v145, vcc
		v_mov_b32_e32 v1, 1
		v_and_b32_e32 v96, v94, v1
		v_and_b32_e32 v97, v95, v7
		v_mul_lo_u32 v6, v92, v96
		v_mul_hi_u32 v7, v92, v96
		v_mul_lo_u32 v1, v92, v97
		v_add_u32_e32 v7, v7, v1
		v_mul_lo_u32 v1, v93, v96
		v_add_u32_e32 v7, v7, v1
		v_add_co_u32_e64 v92, vcc, v122, v6
		v_addc_co_u32_e64 v93, vcc, v123, v7, vcc
		v_mov_b32_e32 v1, 0x80
		v_add_co_u32_e64 v94, vcc, v86, v1
		v_addc_co_u32_e64 v95, vcc, v87, 0, vcc
		v_add_co_u32_e64 v96, vcc, v94, v98
		v_addc_co_u32_e64 v97, vcc, v95, v99, vcc
		v_add_co_u32_e64 v94, vcc, v96, v106
		v_addc_co_u32_e64 v95, vcc, v97, v107, vcc
		v_add_co_u32_e64 v96, vcc, v94, v100
		v_addc_co_u32_e64 v97, vcc, v95, v101, vcc
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v96 offset:3072
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v97 offset:4096
		v_mov_b32_e32 v2, 0x40080
		v_add_co_u32_e64 v94, vcc, v86, v2
		v_addc_co_u32_e64 v95, vcc, v87, 0, vcc
		v_add_co_u32_e64 v96, vcc, v94, v98
		v_addc_co_u32_e64 v97, vcc, v95, v99, vcc
		v_add_co_u32_e64 v94, vcc, v96, v106
		v_addc_co_u32_e64 v95, vcc, v97, v107, vcc
		v_add_co_u32_e64 v96, vcc, v94, v100
		v_addc_co_u32_e64 v97, vcc, v95, v101, vcc
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v96 offset:5120
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v97 offset:6144
		v_mov_b32_e32 v5, 0x80080
		v_add_co_u32_e64 v94, vcc, v86, v5
		v_addc_co_u32_e64 v95, vcc, v87, 0, vcc
		v_add_co_u32_e64 v96, vcc, v94, v98
		v_addc_co_u32_e64 v97, vcc, v95, v99, vcc
		v_add_co_u32_e64 v94, vcc, v96, v106
		v_addc_co_u32_e64 v95, vcc, v97, v107, vcc
		v_add_co_u32_e64 v96, vcc, v94, v100
		v_addc_co_u32_e64 v97, vcc, v95, v101, vcc
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v96 offset:7168
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v97 offset:8192
		v_mov_b32_e32 v8, 0xc0080
		v_add_co_u32_e64 v94, vcc, v86, v8
		v_addc_co_u32_e64 v95, vcc, v87, 0, vcc
		v_add_co_u32_e64 v96, vcc, v94, v98
		v_addc_co_u32_e64 v97, vcc, v95, v99, vcc
		v_add_co_u32_e64 v94, vcc, v96, v106
		v_addc_co_u32_e64 v95, vcc, v97, v107, vcc
		v_add_co_u32_e64 v96, vcc, v94, v100
		v_addc_co_u32_e64 v97, vcc, v95, v101, vcc
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v96 offset:9216
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v97 offset:10240
		v_mov_b32_e32 v13, 0xc0
		v_add_co_u32_e64 v94, vcc, v86, v13
		v_addc_co_u32_e64 v95, vcc, v87, 0, vcc
		v_add_co_u32_e64 v96, vcc, v94, v98
		v_addc_co_u32_e64 v97, vcc, v95, v99, vcc
		v_add_co_u32_e64 v94, vcc, v96, v106
		v_addc_co_u32_e64 v95, vcc, v97, v107, vcc
		v_add_co_u32_e64 v96, vcc, v94, v100
		v_addc_co_u32_e64 v97, vcc, v95, v101, vcc
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v96 offset:11264
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v97 offset:12288
		v_mov_b32_e32 v83, 0x400c0
		v_add_co_u32_e64 v94, vcc, v86, v83
		v_addc_co_u32_e64 v95, vcc, v87, 0, vcc
		v_add_co_u32_e64 v96, vcc, v94, v98
		v_addc_co_u32_e64 v97, vcc, v95, v99, vcc
		v_add_co_u32_e64 v94, vcc, v96, v106
		v_addc_co_u32_e64 v95, vcc, v97, v107, vcc
		v_add_co_u32_e64 v96, vcc, v94, v100
		v_addc_co_u32_e64 v97, vcc, v95, v101, vcc
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v96 offset:13312
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v97 offset:14336
		v_mov_b32_e32 v94, 0x800c0
		v_add_co_u32_e64 v96, vcc, v86, v94
		v_addc_co_u32_e64 v97, vcc, v87, 0, vcc
		v_add_co_u32_e64 v122, vcc, v96, v98
		v_addc_co_u32_e64 v123, vcc, v97, v99, vcc
		v_add_co_u32_e64 v96, vcc, v122, v106
		v_addc_co_u32_e64 v97, vcc, v123, v107, vcc
		v_add_co_u32_e64 v122, vcc, v96, v100
		v_addc_co_u32_e64 v123, vcc, v97, v101, vcc
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v122 offset:15360
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v123 offset:16384
		v_mov_b32_e32 v95, 0xc00c0
		v_add_co_u32_e64 v96, vcc, v86, v95
		v_addc_co_u32_e64 v97, vcc, v87, 0, vcc
		v_add_co_u32_e64 v122, vcc, v96, v98
		v_addc_co_u32_e64 v123, vcc, v97, v99, vcc
		v_add_co_u32_e64 v96, vcc, v122, v106
		v_addc_co_u32_e64 v97, vcc, v123, v107, vcc
		v_add_co_u32_e64 v122, vcc, v96, v100
		v_addc_co_u32_e64 v123, vcc, v97, v101, vcc
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v122 offset:17408
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v123 offset:18432
		v_add_co_u32_e64 v96, vcc, v126, v1
		v_addc_co_u32_e64 v97, vcc, v127, 0, vcc
		v_add_co_u32_e64 v122, vcc, v96, v98
		v_addc_co_u32_e64 v123, vcc, v97, v99, vcc
		v_add_co_u32_e64 v96, vcc, v122, v106
		v_addc_co_u32_e64 v97, vcc, v123, v107, vcc
		v_add_co_u32_e64 v122, vcc, v96, v100
		v_addc_co_u32_e64 v123, vcc, v97, v101, vcc
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v122 offset:19456
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v123 offset:20480
		v_add_co_u32_e64 v96, vcc, v126, v2
		v_addc_co_u32_e64 v97, vcc, v127, 0, vcc
		v_add_co_u32_e64 v122, vcc, v96, v98
		v_addc_co_u32_e64 v123, vcc, v97, v99, vcc
		v_add_co_u32_e64 v96, vcc, v122, v106
		v_addc_co_u32_e64 v97, vcc, v123, v107, vcc
		v_add_co_u32_e64 v122, vcc, v96, v100
		v_addc_co_u32_e64 v123, vcc, v97, v101, vcc
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v122 offset:21504
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v123 offset:22528
		v_add_co_u32_e64 v96, vcc, v126, v5
		v_addc_co_u32_e64 v97, vcc, v127, 0, vcc
		v_add_co_u32_e64 v122, vcc, v96, v98
		v_addc_co_u32_e64 v123, vcc, v97, v99, vcc
		v_add_co_u32_e64 v96, vcc, v122, v106
		v_addc_co_u32_e64 v97, vcc, v123, v107, vcc
		v_add_co_u32_e64 v122, vcc, v96, v100
		v_addc_co_u32_e64 v123, vcc, v97, v101, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v122, s62
		scratch_store_dword off, v123, s62 offset:4
		v_add_co_u32_e64 v96, vcc, v126, v8
		v_addc_co_u32_e64 v97, vcc, v127, 0, vcc
		v_add_co_u32_e64 v122, vcc, v96, v98
		v_addc_co_u32_e64 v123, vcc, v97, v99, vcc
		v_add_co_u32_e64 v96, vcc, v122, v106
		v_addc_co_u32_e64 v97, vcc, v123, v107, vcc
		v_add_co_u32_e64 v122, vcc, v96, v100
		v_addc_co_u32_e64 v123, vcc, v97, v101, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v122, s62 offset:8
		scratch_store_dword off, v123, s62 offset:12
		v_add_co_u32_e64 v96, vcc, v126, v13
		v_addc_co_u32_e64 v97, vcc, v127, 0, vcc
		v_add_co_u32_e64 v122, vcc, v96, v98
		v_addc_co_u32_e64 v123, vcc, v97, v99, vcc
		v_add_co_u32_e64 v96, vcc, v122, v106
		v_addc_co_u32_e64 v97, vcc, v123, v107, vcc
		v_add_co_u32_e64 v122, vcc, v96, v100
		v_addc_co_u32_e64 v123, vcc, v97, v101, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v122, s62 offset:16
		scratch_store_dword off, v123, s62 offset:20
		v_add_co_u32_e64 v96, vcc, v126, v83
		v_addc_co_u32_e64 v97, vcc, v127, 0, vcc
		v_add_co_u32_e64 v122, vcc, v96, v98
		v_addc_co_u32_e64 v123, vcc, v97, v99, vcc
		v_add_co_u32_e64 v96, vcc, v122, v106
		v_addc_co_u32_e64 v97, vcc, v123, v107, vcc
		v_add_co_u32_e64 v122, vcc, v96, v100
		v_addc_co_u32_e64 v123, vcc, v97, v101, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v122, s62 offset:24
		scratch_store_dword off, v123, s62 offset:28
		v_add_co_u32_e64 v96, vcc, v126, v94
		v_addc_co_u32_e64 v97, vcc, v127, 0, vcc
		v_add_co_u32_e64 v122, vcc, v96, v98
		v_addc_co_u32_e64 v123, vcc, v97, v99, vcc
		v_add_co_u32_e64 v96, vcc, v122, v106
		v_addc_co_u32_e64 v97, vcc, v123, v107, vcc
		v_add_co_u32_e64 v122, vcc, v96, v100
		v_addc_co_u32_e64 v123, vcc, v97, v101, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v122, s62 offset:32
		scratch_store_dword off, v123, s62 offset:36
		v_add_co_u32_e64 v96, vcc, v126, v95
		v_addc_co_u32_e64 v97, vcc, v127, 0, vcc
		v_add_co_u32_e64 v94, vcc, v96, v98
		v_addc_co_u32_e64 v95, vcc, v97, v99, vcc
		v_add_co_u32_e64 v96, vcc, v94, v106
		v_addc_co_u32_e64 v97, vcc, v95, v107, vcc
		v_add_co_u32_e64 v94, vcc, v96, v100
		v_addc_co_u32_e64 v95, vcc, v97, v101, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v94, s62 offset:40
		scratch_store_dword off, v95, s62 offset:44
		v_mov_b32_e32 v1, 0x800
		v_add_co_u32_e64 v94, vcc, v86, v1
		v_addc_co_u32_e64 v95, vcc, v87, 0, vcc
		v_add_co_u32_e64 v86, vcc, v94, v128
		v_addc_co_u32_e64 v87, vcc, v95, v129, vcc
		v_add_co_u32_e64 v94, vcc, v86, v142
		v_addc_co_u32_e64 v95, vcc, v87, v143, vcc
		v_add_co_u32_e64 v96, vcc, v94, v144
		v_addc_co_u32_e64 v97, vcc, v95, v145, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v96, s62 offset:48
		scratch_store_dword off, v97, s62 offset:52
		v_add_co_u32_e64 v94, vcc, v86, v144
		v_addc_co_u32_e64 v95, vcc, v87, v145, vcc
		v_add_co_u32_e64 v86, vcc, v94, v6
		v_addc_co_u32_e64 v87, vcc, v95, v7, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v86, s62 offset:56
		scratch_store_dword off, v87, s62 offset:60
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a4, v96
		v_accvgpr_write_b32 a5, v97
		v_accvgpr_write_b32 a6, v98
		v_accvgpr_write_b32 a7, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a8, v96
		v_accvgpr_write_b32 a9, v97
		v_accvgpr_write_b32 a10, v98
		v_accvgpr_write_b32 a11, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a12, v96
		v_accvgpr_write_b32 a13, v97
		v_accvgpr_write_b32 a14, v98
		v_accvgpr_write_b32 a15, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a16, v96
		v_accvgpr_write_b32 a17, v97
		v_accvgpr_write_b32 a18, v98
		v_accvgpr_write_b32 a19, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a20, v96
		v_accvgpr_write_b32 a21, v97
		v_accvgpr_write_b32 a22, v98
		v_accvgpr_write_b32 a23, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a24, v96
		v_accvgpr_write_b32 a25, v97
		v_accvgpr_write_b32 a26, v98
		v_accvgpr_write_b32 a27, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a28, v96
		v_accvgpr_write_b32 a29, v97
		v_accvgpr_write_b32 a30, v98
		v_accvgpr_write_b32 a31, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a32, v96
		v_accvgpr_write_b32 a33, v97
		v_accvgpr_write_b32 a34, v98
		v_accvgpr_write_b32 a35, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a36, v96
		v_accvgpr_write_b32 a37, v97
		v_accvgpr_write_b32 a38, v98
		v_accvgpr_write_b32 a39, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a40, v96
		v_accvgpr_write_b32 a41, v97
		v_accvgpr_write_b32 a42, v98
		v_accvgpr_write_b32 a43, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a44, v96
		v_accvgpr_write_b32 a45, v97
		v_accvgpr_write_b32 a46, v98
		v_accvgpr_write_b32 a47, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a48, v96
		v_accvgpr_write_b32 a49, v97
		v_accvgpr_write_b32 a50, v98
		v_accvgpr_write_b32 a51, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a52, v96
		v_accvgpr_write_b32 a53, v97
		v_accvgpr_write_b32 a54, v98
		v_accvgpr_write_b32 a55, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a56, v96
		v_accvgpr_write_b32 a57, v97
		v_accvgpr_write_b32 a58, v98
		v_accvgpr_write_b32 a59, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a60, v96
		v_accvgpr_write_b32 a61, v97
		v_accvgpr_write_b32 a62, v98
		v_accvgpr_write_b32 a63, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a64, v96
		v_accvgpr_write_b32 a65, v97
		v_accvgpr_write_b32 a66, v98
		v_accvgpr_write_b32 a67, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a68, v96
		v_accvgpr_write_b32 a69, v97
		v_accvgpr_write_b32 a70, v98
		v_accvgpr_write_b32 a71, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a72, v96
		v_accvgpr_write_b32 a73, v97
		v_accvgpr_write_b32 a74, v98
		v_accvgpr_write_b32 a75, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a76, v96
		v_accvgpr_write_b32 a77, v97
		v_accvgpr_write_b32 a78, v98
		v_accvgpr_write_b32 a79, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a80, v96
		v_accvgpr_write_b32 a81, v97
		v_accvgpr_write_b32 a82, v98
		v_accvgpr_write_b32 a83, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a84, v96
		v_accvgpr_write_b32 a85, v97
		v_accvgpr_write_b32 a86, v98
		v_accvgpr_write_b32 a87, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a88, v96
		v_accvgpr_write_b32 a89, v97
		v_accvgpr_write_b32 a90, v98
		v_accvgpr_write_b32 a91, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a92, v96
		v_accvgpr_write_b32 a93, v97
		v_accvgpr_write_b32 a94, v98
		v_accvgpr_write_b32 a95, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a96, v96
		v_accvgpr_write_b32 a97, v97
		v_accvgpr_write_b32 a98, v98
		v_accvgpr_write_b32 a99, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a100, v96
		v_accvgpr_write_b32 a101, v97
		v_accvgpr_write_b32 a102, v98
		v_accvgpr_write_b32 a103, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a104, v96
		v_accvgpr_write_b32 a105, v97
		v_accvgpr_write_b32 a106, v98
		v_accvgpr_write_b32 a107, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a108, v96
		v_accvgpr_write_b32 a109, v97
		v_accvgpr_write_b32 a110, v98
		v_accvgpr_write_b32 a111, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a112, v96
		v_accvgpr_write_b32 a113, v97
		v_accvgpr_write_b32 a114, v98
		v_accvgpr_write_b32 a115, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a116, v96
		v_accvgpr_write_b32 a117, v97
		v_accvgpr_write_b32 a118, v98
		v_accvgpr_write_b32 a119, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a120, v96
		v_accvgpr_write_b32 a121, v97
		v_accvgpr_write_b32 a122, v98
		v_accvgpr_write_b32 a123, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a124, v96
		v_accvgpr_write_b32 a125, v97
		v_accvgpr_write_b32 a126, v98
		v_accvgpr_write_b32 a127, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a128, v96
		v_accvgpr_write_b32 a129, v97
		v_accvgpr_write_b32 a130, v98
		v_accvgpr_write_b32 a131, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a132, v96
		v_accvgpr_write_b32 a133, v97
		v_accvgpr_write_b32 a134, v98
		v_accvgpr_write_b32 a135, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a136, v96
		v_accvgpr_write_b32 a137, v97
		v_accvgpr_write_b32 a138, v98
		v_accvgpr_write_b32 a139, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a140, v96
		v_accvgpr_write_b32 a141, v97
		v_accvgpr_write_b32 a142, v98
		v_accvgpr_write_b32 a143, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a144, v96
		v_accvgpr_write_b32 a145, v97
		v_accvgpr_write_b32 a146, v98
		v_accvgpr_write_b32 a147, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a148, v96
		v_accvgpr_write_b32 a149, v97
		v_accvgpr_write_b32 a150, v98
		v_accvgpr_write_b32 a151, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a152, v96
		v_accvgpr_write_b32 a153, v97
		v_accvgpr_write_b32 a154, v98
		v_accvgpr_write_b32 a155, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a156, v96
		v_accvgpr_write_b32 a157, v97
		v_accvgpr_write_b32 a158, v98
		v_accvgpr_write_b32 a159, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a160, v96
		v_accvgpr_write_b32 a161, v97
		v_accvgpr_write_b32 a162, v98
		v_accvgpr_write_b32 a163, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a164, v96
		v_accvgpr_write_b32 a165, v97
		v_accvgpr_write_b32 a166, v98
		v_accvgpr_write_b32 a167, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a168, v96
		v_accvgpr_write_b32 a169, v97
		v_accvgpr_write_b32 a170, v98
		v_accvgpr_write_b32 a171, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a172, v96
		v_accvgpr_write_b32 a173, v97
		v_accvgpr_write_b32 a174, v98
		v_accvgpr_write_b32 a175, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a176, v96
		v_accvgpr_write_b32 a177, v97
		v_accvgpr_write_b32 a178, v98
		v_accvgpr_write_b32 a179, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a180, v96
		v_accvgpr_write_b32 a181, v97
		v_accvgpr_write_b32 a182, v98
		v_accvgpr_write_b32 a183, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a184, v96
		v_accvgpr_write_b32 a185, v97
		v_accvgpr_write_b32 a186, v98
		v_accvgpr_write_b32 a187, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a188, v96
		v_accvgpr_write_b32 a189, v97
		v_accvgpr_write_b32 a190, v98
		v_accvgpr_write_b32 a191, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a192, v96
		v_accvgpr_write_b32 a193, v97
		v_accvgpr_write_b32 a194, v98
		v_accvgpr_write_b32 a195, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a196, v96
		v_accvgpr_write_b32 a197, v97
		v_accvgpr_write_b32 a198, v98
		v_accvgpr_write_b32 a199, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a200, v96
		v_accvgpr_write_b32 a201, v97
		v_accvgpr_write_b32 a202, v98
		v_accvgpr_write_b32 a203, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a204, v96
		v_accvgpr_write_b32 a205, v97
		v_accvgpr_write_b32 a206, v98
		v_accvgpr_write_b32 a207, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a208, v96
		v_accvgpr_write_b32 a209, v97
		v_accvgpr_write_b32 a210, v98
		v_accvgpr_write_b32 a211, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a212, v96
		v_accvgpr_write_b32 a213, v97
		v_accvgpr_write_b32 a214, v98
		v_accvgpr_write_b32 a215, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a216, v96
		v_accvgpr_write_b32 a217, v97
		v_accvgpr_write_b32 a218, v98
		v_accvgpr_write_b32 a219, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a220, v96
		v_accvgpr_write_b32 a221, v97
		v_accvgpr_write_b32 a222, v98
		v_accvgpr_write_b32 a223, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a224, v96
		v_accvgpr_write_b32 a225, v97
		v_accvgpr_write_b32 a226, v98
		v_accvgpr_write_b32 a227, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a228, v96
		v_accvgpr_write_b32 a229, v97
		v_accvgpr_write_b32 a230, v98
		v_accvgpr_write_b32 a231, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a232, v96
		v_accvgpr_write_b32 a233, v97
		v_accvgpr_write_b32 a234, v98
		v_accvgpr_write_b32 a235, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a236, v96
		v_accvgpr_write_b32 a237, v97
		v_accvgpr_write_b32 a238, v98
		v_accvgpr_write_b32 a239, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a240, v96
		v_accvgpr_write_b32 a241, v97
		v_accvgpr_write_b32 a242, v98
		v_accvgpr_write_b32 a243, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a244, v96
		v_accvgpr_write_b32 a245, v97
		v_accvgpr_write_b32 a246, v98
		v_accvgpr_write_b32 a247, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a248, v96
		v_accvgpr_write_b32 a249, v97
		v_accvgpr_write_b32 a250, v98
		v_accvgpr_write_b32 a251, v99
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_accvgpr_write_b32 a252, v96
		v_accvgpr_write_b32 a253, v97
		v_accvgpr_write_b32 a254, v98
		v_accvgpr_write_b32 a255, v99
.Lwmma_f16_matmul_tiled.loop_head_0:
		v_mov_b32_e32 v6, s61
		v_mov_b32_e32 v7, 0
		v_mul_lo_u32 v86, v90, v6
		v_mul_hi_u32 v87, v90, v6
		v_mul_lo_u32 v1, v90, v7
		v_add_u32_e32 v87, v87, v1
		v_mul_lo_u32 v1, v91, v6
		v_add_u32_e32 v87, v87, v1
		v_add_co_u32_e64 v94, vcc, v104, v86
		v_addc_co_u32_e64 v95, vcc, v105, v87, vcc
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v94
		v_add_co_u32_e64 v94, vcc, v110, v86
		v_addc_co_u32_e64 v95, vcc, v111, v87, vcc
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v94 offset:1024
		v_add_co_u32_e64 v94, vcc, v112, v86
		v_addc_co_u32_e64 v95, vcc, v113, v87, vcc
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v94 offset:2048
		v_add_co_u32_e64 v94, vcc, v114, v86
		v_addc_co_u32_e64 v95, vcc, v115, v87, vcc
		v_add_co_u32_e64 v96, vcc, v116, v86
		v_addc_co_u32_e64 v97, vcc, v117, v87, vcc
		v_add_co_u32_e64 v98, vcc, v118, v86
		v_addc_co_u32_e64 v99, vcc, v119, v87, vcc
		v_add_co_u32_e64 v100, vcc, v120, v86
		v_addc_co_u32_e64 v101, vcc, v121, v87, vcc
		v_add_co_u32_e64 v106, vcc, v124, v86
		v_addc_co_u32_e64 v107, vcc, v125, v87, vcc
		v_add_co_u32_e64 v122, vcc, v84, v86
		v_addc_co_u32_e64 v123, vcc, v85, v87, vcc
		v_add_co_u32_e64 v126, vcc, v130, v86
		v_addc_co_u32_e64 v127, vcc, v131, v87, vcc
		v_add_co_u32_e64 v128, vcc, v132, v86
		v_addc_co_u32_e64 v129, vcc, v133, v87, vcc
		v_add_co_u32_e64 v142, vcc, v134, v86
		v_addc_co_u32_e64 v143, vcc, v135, v87, vcc
		v_add_co_u32_e64 v144, vcc, v136, v86
		v_addc_co_u32_e64 v145, vcc, v137, v87, vcc
		v_add_co_u32_e64 v146, vcc, v138, v86
		v_addc_co_u32_e64 v147, vcc, v139, v87, vcc
		v_add_co_u32_e64 v148, vcc, v140, v86
		v_addc_co_u32_e64 v149, vcc, v141, v87, vcc
		v_add_co_u32_e64 v150, vcc, v108, v86
		v_addc_co_u32_e64 v151, vcc, v109, v87, vcc
		v_mul_lo_u32 v152, v102, v6
		v_mul_hi_u32 v153, v102, v6
		v_mul_lo_u32 v1, v102, v7
		v_add_u32_e32 v153, v153, v1
		v_mul_lo_u32 v1, v103, v6
		v_add_u32_e32 v153, v153, v1
		v_add_co_u32_e64 v6, vcc, v88, v152
		v_addc_co_u32_e64 v7, vcc, v89, v153, vcc
		v_add_co_u32_e64 v154, vcc, v92, v152
		v_addc_co_u32_e64 v155, vcc, v93, v153, vcc
		s_mov_b32 m0, s15
		s_waitcnt lgkmcnt(3)
		s_nop 0
		ds_read_addtid_b32 v1 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[16:19], v[48:51], a[0:3], v1, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s62, s61, 1
		s_lshl_b32 s63, s62, 16
		v_add_u32_e32 v1, s63, v9
		v_add3_u32 v2, v1, v11, v3
		ds_read_b128 v[156:159], v2 offset:16384
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v1 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[16:19], v[52:55], a[4:7], v1, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[160:163], v2 offset:17408
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v1 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[16:19], v[56:59], a[8:11], v1, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[164:167], v2 offset:18432
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v1 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[16:19], v[60:63], a[12:15], v1, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[168:171], v2 offset:19456
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v1 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[16:19], v[64:67], a[16:19], v1, v81 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[172:175], v2 offset:20480
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v1 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[16:19], v[68:71], a[20:23], v1, v81 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[176:179], v2 offset:21504
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v1 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[16:19], v[72:75], a[24:27], v1, v82 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[180:183], v2 offset:22528
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v1 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[16:19], v[76:79], a[28:31], v1, v82 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[184:187], v2 offset:23552
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v1 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[20:23], v[48:51], a[32:35], v1, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, s63, v11
		v_add3_u32 v2, v1, v12, v3
		ds_read_b128 v[188:191], v2 offset:49152
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v1 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[20:23], v[52:55], a[36:39], v1, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[192:195], v2 offset:50176
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v1 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[20:23], v[56:59], a[40:43], v1, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[196:199], v2 offset:51200
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v1 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[20:23], v[60:63], a[44:47], v1, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[200:203], v2 offset:52224
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v1 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[20:23], v[64:67], a[48:51], v1, v81 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[204:207], v2 offset:53248
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v1 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[20:23], v[68:71], a[52:55], v1, v81 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s63, s61, 1
		s_lshl_b32 s64, s63, 16
		v_and_b32_e32 v1, 15, v0
		v_lshlrev_b32_e32 v2, 6, v1
		v_add_u32_e32 v5, s64, v2
		v_lshrrev_b32_e32 v2, 6, v0
		v_and_b32_e32 v8, 1, v2
		v_lshlrev_b32_e32 v2, 13, v8
		v_and_b32_e32 v8, 63, v0
		v_lshrrev_b32_e32 v13, 4, v8
		v_lshrrev_b32_e32 v8, 1, v1
		v_and_b32_e32 v1, 3, v8
		v_xor_b32_e32 v8, v13, v1
		v_lshlrev_b32_e32 v1, 4, v8
		v_add3_u32 v8, v5, v2, v1
		ds_read_b128 v[208:211], v8 offset:54272
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v1 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[20:23], v[72:75], a[56:59], v1, v82 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[212:215], v8 offset:55296
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v1 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[20:23], v[76:79], a[60:63], v1, v82 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v8 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[24:27], v[48:51], a[64:67], v10, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v1
		s_mov_b32 m0, s28
		s_waitcnt lgkmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[24:27], v[52:55], a[68:71], v10, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v1 offset:1024
		s_mov_b32 m0, s29
		s_waitcnt lgkmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[24:27], v[56:59], a[72:75], v10, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v1 offset:2048
		s_mov_b32 m0, s30
		s_waitcnt lgkmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[24:27], v[60:63], a[76:79], v10, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v94, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[24:27], v[64:67], a[80:83], v10, v81 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v96, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[24:27], v[68:71], a[84:87], v10, v81 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v98, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[24:27], v[72:75], a[88:91], v10, v82 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v100, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[24:27], v[76:79], a[92:95], v10, v82 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v106, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[28:31], v[48:51], a[96:99], v10, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v122, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[28:31], v[52:55], a[100:103], v10, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s37
		s_nop 0
		buffer_load_dwordx4 v126, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[28:31], v[56:59], a[104:107], v10, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v128, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[28:31], v[60:63], a[108:111], v10, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v142, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[28:31], v[64:67], a[112:115], v10, v81 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s40
		s_nop 0
		buffer_load_dwordx4 v144, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[28:31], v[68:71], a[116:119], v10, v81 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s41
		s_nop 0
		buffer_load_dwordx4 v146, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[28:31], v[72:75], a[120:123], v10, v82 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s42
		s_nop 0
		buffer_load_dwordx4 v148, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[28:31], v[76:79], a[124:127], v10, v82 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s43
		s_nop 0
		buffer_load_dwordx4 v150, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[32:35], v[48:51], a[128:131], v14, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s8, 0x20000
		s_nop 0
		buffer_load_dwordx4 v6, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[32:35], v[52:55], a[132:135], v14, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s45, 0x20000
		s_nop 0
		buffer_load_dwordx4 v154, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[32:35], v[56:59], a[136:139], v14, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		s_and_b32 s63, s61, 1
		s_lshl_b32 s64, s63, 16
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v2, 13, v1
		v_add_u32_e32 v1, s64, v2
		v_and_b32_e32 v2, 15, v0
		v_lshlrev_b32_e32 v5, 6, v2
		v_and_b32_e32 v6, 63, v0
		v_lshrrev_b32_e32 v7, 4, v6
		v_lshrrev_b32_e32 v6, 1, v2
		v_and_b32_e32 v2, 3, v6
		v_xor_b32_e32 v6, v7, v2
		v_lshlrev_b32_e32 v2, 4, v6
		v_add3_u32 v6, v1, v5, v2
		ds_read_b128 v[16:19], v6
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[32:35], v[60:63], a[140:143], v14, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v6 offset:1024
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], v[64:67], a[144:147], v14, v81 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v6 offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[32:35], v[68:71], a[148:151], v14, v81 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[28:31], v6 offset:3072
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[32:35], v[72:75], a[152:155], v14, v82 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v6 offset:4096
		s_mov_b32 s63, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v96, s63 offset:64
		scratch_store_dword off, v97, s63 offset:68
		scratch_store_dword off, v98, s63 offset:72
		scratch_store_dword off, v99, s63 offset:76
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[32:35], v[76:79], a[156:159], v14, v82 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v6 offset:5120
		s_mov_b32 s63, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v96, s63 offset:80
		scratch_store_dword off, v97, s63 offset:84
		scratch_store_dword off, v98, s63 offset:88
		scratch_store_dword off, v99, s63 offset:92
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], v[48:51], a[160:163], v14, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v6 offset:6144
		s_mov_b32 s63, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v96, s63 offset:96
		scratch_store_dword off, v97, s63 offset:100
		scratch_store_dword off, v98, s63 offset:104
		scratch_store_dword off, v99, s63 offset:108
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[36:39], v[52:55], a[164:167], v14, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v6 offset:7168
		s_mov_b32 s63, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v96, s63 offset:112
		scratch_store_dword off, v97, s63 offset:116
		scratch_store_dword off, v98, s63 offset:120
		scratch_store_dword off, v99, s63 offset:124
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[36:39], v[56:59], a[168:171], v14, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v8 offset:32768
		s_mov_b32 s63, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v96, s63 offset:128
		scratch_store_dword off, v97, s63 offset:132
		scratch_store_dword off, v98, s63 offset:136
		scratch_store_dword off, v99, s63 offset:140
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[36:39], v[60:63], a[172:175], v14, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v8 offset:33792
		s_mov_b32 s63, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v96, s63 offset:144
		scratch_store_dword off, v97, s63 offset:148
		scratch_store_dword off, v98, s63 offset:152
		scratch_store_dword off, v99, s63 offset:156
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[36:39], v[64:67], a[176:179], v14, v81 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v8 offset:34816
		s_mov_b32 s63, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v96, s63 offset:160
		scratch_store_dword off, v97, s63 offset:164
		scratch_store_dword off, v98, s63 offset:168
		scratch_store_dword off, v99, s63 offset:172
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[36:39], v[68:71], a[180:183], v14, v81 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v8 offset:35840
		s_mov_b32 s63, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v96, s63 offset:176
		scratch_store_dword off, v97, s63 offset:180
		scratch_store_dword off, v98, s63 offset:184
		scratch_store_dword off, v99, s63 offset:188
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[36:39], v[72:75], a[184:187], v14, v82 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v8 offset:36864
		s_mov_b32 s63, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v96, s63 offset:192
		scratch_store_dword off, v97, s63 offset:196
		scratch_store_dword off, v98, s63 offset:200
		scratch_store_dword off, v99, s63 offset:204
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[36:39], v[76:79], a[188:191], v14, v82 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v8 offset:37888
		s_mov_b32 s63, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v96, s63 offset:208
		scratch_store_dword off, v97, s63 offset:212
		scratch_store_dword off, v98, s63 offset:216
		scratch_store_dword off, v99, s63 offset:220
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[40:43], v[48:51], a[192:195], v15, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v8 offset:38912
		s_mov_b32 s63, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v96, s63 offset:224
		scratch_store_dword off, v97, s63 offset:228
		scratch_store_dword off, v98, s63 offset:232
		scratch_store_dword off, v99, s63 offset:236
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[40:43], v[52:55], a[196:199], v15, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v8 offset:39936
		s_mov_b32 s63, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v96, s63 offset:240
		scratch_store_dword off, v97, s63 offset:244
		scratch_store_dword off, v98, s63 offset:248
		scratch_store_dword off, v99, s63 offset:252
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[40:43], v[56:59], a[200:203], v15, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshl_b32 s63, s62, 12
		s_add_i32 s62, s63, 0x20000
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v2, 10, v1
		v_and_b32_e32 v1, 63, v0
		v_lshlrev_b32_e32 v5, 2, v1
		v_add3_u32 v1, s62, v2, v5
		ds_read_b32 v6, v1
		s_mov_b32 s63, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v6, s63 offset:256
		ds_read_b32 v6, v1 offset:256
		s_mov_b32 s63, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v6, s63 offset:260
		ds_read_b32 v6, v1 offset:512
		s_mov_b32 s63, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v6, s63 offset:264
		ds_read_b32 v6, v1 offset:768
		s_mov_b32 s63, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v6, s63 offset:268
		v_lshrrev_b32_e32 v1, 6, v0
		v_and_b32_e32 v6, 1, v1
		v_lshlrev_b32_e32 v1, 10, v6
		v_add3_u32 v6, s62, v5, v1
		ds_read_b32 v7, v6 offset:2048
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v7, s62 offset:272
		ds_read_b32 v7, v6 offset:2304
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v7, s62 offset:276
		ds_read_b32 v7, v6 offset:2560
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v7, s62 offset:280
		ds_read_b32 v7, v6 offset:2816
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v7, s62 offset:284
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[40:43], v[60:63], a[204:207], v15, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[40:43], v[64:67], a[208:211], v15, v81 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[40:43], v[68:71], a[212:215], v15, v81 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[40:43], v[72:75], a[216:219], v15, v82 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[40:43], v[76:79], a[220:223], v15, v82 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[44:47], v[48:51], a[224:227], v15, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[44:47], v[52:55], a[228:231], v15, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[44:47], v[56:59], a[232:235], v15, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[44:47], v[60:63], a[236:239], v15, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[44:47], v[64:67], a[240:243], v15, v81 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[44:47], v[68:71], a[244:247], v15, v81 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[44:47], v[72:75], a[248:251], v15, v82 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[44:47], v[76:79], a[252:255], v15, v82 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v6 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[156:159], v[188:191], a[0:3], v6, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v6 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[156:159], v[192:195], a[4:7], v6, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v6 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[156:159], v[196:199], a[8:11], v6, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v6 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[156:159], v[200:203], a[12:15], v6, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v6 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[156:159], v[204:207], a[16:19], v6, v81 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v6 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[156:159], v[208:211], a[20:23], v6, v81 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v6 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[156:159], v[212:215], a[24:27], v6, v82 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v6 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[156:159], v[216:219], a[28:31], v6, v82 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v6 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[160:163], v[188:191], a[32:35], v6, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v6 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[160:163], v[192:195], a[36:39], v6, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v6 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[160:163], v[196:199], a[40:43], v6, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v6 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[160:163], v[200:203], a[44:47], v6, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v6 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[160:163], v[204:207], a[48:51], v6, v81 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v6 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[160:163], v[208:211], a[52:55], v6, v81 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v6 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[160:163], v[212:215], a[56:59], v6, v82 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v6 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[160:163], v[216:219], a[60:63], v6, v82 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[164:167], v[188:191], a[64:67], v10, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[164:167], v[192:195], a[68:71], v10, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[164:167], v[196:199], a[72:75], v10, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[164:167], v[200:203], a[76:79], v10, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[164:167], v[204:207], a[80:83], v10, v81 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[164:167], v[208:211], a[84:87], v10, v81 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[164:167], v[212:215], a[88:91], v10, v82 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[164:167], v[216:219], a[92:95], v10, v82 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[168:171], v[188:191], a[96:99], v10, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[168:171], v[192:195], a[100:103], v10, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[168:171], v[196:199], a[104:107], v10, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[168:171], v[200:203], a[108:111], v10, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[168:171], v[204:207], a[112:115], v10, v81 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[168:171], v[208:211], a[116:119], v10, v81 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[168:171], v[212:215], a[120:123], v10, v82 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[168:171], v[216:219], a[124:127], v10, v82 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[172:175], v[188:191], a[128:131], v14, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[172:175], v[192:195], a[132:135], v14, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[172:175], v[196:199], a[136:139], v14, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[172:175], v[200:203], a[140:143], v14, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[172:175], v[204:207], a[144:147], v14, v81 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[172:175], v[208:211], a[148:151], v14, v81 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[172:175], v[212:215], a[152:155], v14, v82 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[172:175], v[216:219], a[156:159], v14, v82 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[176:179], v[188:191], a[160:163], v14, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[176:179], v[192:195], a[164:167], v14, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[176:179], v[196:199], a[168:171], v14, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[176:179], v[200:203], a[172:175], v14, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[176:179], v[204:207], a[176:179], v14, v81 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[176:179], v[208:211], a[180:183], v14, v81 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[176:179], v[212:215], a[184:187], v14, v82 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[176:179], v[216:219], a[188:191], v14, v82 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[180:183], v[188:191], a[192:195], v15, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[180:183], v[192:195], a[196:199], v15, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[180:183], v[196:199], a[200:203], v15, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[180:183], v[200:203], a[204:207], v15, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[180:183], v[204:207], a[208:211], v15, v81 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[180:183], v[208:211], a[212:215], v15, v81 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[180:183], v[212:215], a[216:219], v15, v82 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[180:183], v[216:219], a[220:223], v15, v82 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[184:187], v[188:191], a[224:227], v15, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[184:187], v[192:195], a[228:231], v15, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[184:187], v[196:199], a[232:235], v15, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[184:187], v[200:203], a[236:239], v15, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[184:187], v[204:207], a[240:243], v15, v81 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[184:187], v[208:211], a[244:247], v15, v81 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[184:187], v[212:215], a[248:251], v15, v82 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[184:187], v[216:219], a[252:255], v15, v82 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s62, s61, 1
		s_and_b32 s63, s62, 1
		s_lshl_b32 s62, s63, 16
		v_lshrrev_b32_e32 v6, 7, v0
		v_lshlrev_b32_e32 v7, 13, v6
		v_add_u32_e32 v6, s62, v7
		v_and_b32_e32 v8, 15, v0
		v_lshlrev_b32_e32 v13, 6, v8
		v_and_b32_e32 v8, 63, v0
		v_lshrrev_b32_e32 v83, 4, v8
		v_and_b32_e32 v8, 15, v0
		v_lshrrev_b32_e32 v94, 1, v8
		v_and_b32_e32 v8, 3, v94
		v_xor_b32_e32 v94, v83, v8
		v_lshlrev_b32_e32 v8, 4, v94
		v_add3_u32 v83, v6, v13, v8
		ds_read_b128 v[96:99], v83
		s_mov_b32 s64, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v96, s64 offset:292
		scratch_store_dword off, v97, s64 offset:296
		scratch_store_dword off, v98, s64 offset:300
		scratch_store_dword off, v99, s64 offset:304
		ds_read_b128 v[144:147], v83 offset:1024
		s_mov_b32 s64, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v144, s64 offset:360
		scratch_store_dword off, v145, s64 offset:364
		scratch_store_dword off, v146, s64 offset:368
		scratch_store_dword off, v147, s64 offset:372
		ds_read_b128 v[148:151], v83 offset:2048
		ds_read_b128 v[156:159], v83 offset:3072
		ds_read_b128 v[160:163], v83 offset:4096
		ds_read_b128 v[164:167], v83 offset:5120
		ds_read_b128 v[168:171], v83 offset:6144
		ds_read_b128 v[172:175], v83 offset:7168
		v_add_u32_e32 v6, s62, v13
		v_lshrrev_b32_e32 v83, 6, v0
		v_and_b32_e32 v94, 1, v83
		v_lshlrev_b32_e32 v83, 13, v94
		v_add3_u32 v94, v6, v83, v8
		ds_read_b128 v[176:179], v94 offset:32768
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v176, s62 offset:396
		scratch_store_dword off, v177, s62 offset:400
		scratch_store_dword off, v178, s62 offset:404
		scratch_store_dword off, v179, s62 offset:408
		ds_read_b128 v[180:183], v94 offset:33792
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v180, s62 offset:412
		scratch_store_dword off, v181, s62 offset:416
		scratch_store_dword off, v182, s62 offset:420
		scratch_store_dword off, v183, s62 offset:424
		ds_read_b128 v[184:187], v94 offset:34816
		ds_read_b128 v[188:191], v94 offset:35840
		ds_read_b128 v[192:195], v94 offset:36864
		ds_read_b128 v[196:199], v94 offset:37888
		ds_read_b128 v[200:203], v94 offset:38912
		ds_read_b128 v[204:207], v94 offset:39936
		s_lshl_b32 s62, s63, 12
		s_add_i32 s63, s62, 0x20000
		v_add3_u32 v6, s63, v2, v5
		ds_read_b32 v2, v6
		ds_read_b32 v94, v6 offset:256
		ds_read_b32 v95, v6 offset:512
		ds_read_b32 v100, v6 offset:768
		v_add3_u32 v6, s63, v5, v1
		ds_read_b32 v1, v6 offset:2048
		ds_read_b32 v5, v6 offset:2304
		ds_read_b32 v101, v6 offset:2560
		ds_read_b32 v106, v6 offset:2816
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v122 offset:3072
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v123 offset:4096
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v126, vcc, v122, v86
		v_addc_co_u32_e64 v127, vcc, v123, v87, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v126, s62 offset:288
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v122 offset:5120
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v123 offset:6144
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v126, vcc, v122, v86
		v_addc_co_u32_e64 v127, vcc, v123, v87, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v126, s62 offset:308
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v122 offset:7168
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v123 offset:8192
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v126, vcc, v122, v86
		v_addc_co_u32_e64 v127, vcc, v123, v87, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v126, s62 offset:312
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v122 offset:9216
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v123 offset:10240
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v126, vcc, v122, v86
		v_addc_co_u32_e64 v127, vcc, v123, v87, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v126, s62 offset:316
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v122 offset:11264
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v123 offset:12288
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v126, vcc, v122, v86
		v_addc_co_u32_e64 v127, vcc, v123, v87, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v126, s62 offset:320
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v122 offset:13312
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v123 offset:14336
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v126, vcc, v122, v86
		v_addc_co_u32_e64 v127, vcc, v123, v87, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v126, s62 offset:324
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v122 offset:15360
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v123 offset:16384
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v126, vcc, v122, v86
		v_addc_co_u32_e64 v127, vcc, v123, v87, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v126, s62 offset:328
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v122 offset:17408
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v123 offset:18432
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v126, vcc, v122, v86
		v_addc_co_u32_e64 v127, vcc, v123, v87, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v126, s62 offset:332
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v122 offset:19456
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v123 offset:20480
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v126, vcc, v122, v86
		v_addc_co_u32_e64 v127, vcc, v123, v87, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v126, s62 offset:336
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v122 offset:21504
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v123 offset:22528
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v126, vcc, v122, v86
		v_addc_co_u32_e64 v127, vcc, v123, v87, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v126, s62 offset:340
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(63) expcnt(7) lgkmcnt(15)
		scratch_load_dword v122, off, s62
		scratch_load_dword v123, off, s62 offset:4
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v126, vcc, v122, v86
		v_addc_co_u32_e64 v127, vcc, v123, v87, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v126, s62 offset:344
		s_mov_b32 s62, 0
		scratch_load_dword v122, off, s62 offset:8
		scratch_load_dword v123, off, s62 offset:12
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v126, vcc, v122, v86
		v_addc_co_u32_e64 v127, vcc, v123, v87, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v126, s62 offset:348
		s_mov_b32 s62, 0
		scratch_load_dword v122, off, s62 offset:16
		scratch_load_dword v123, off, s62 offset:20
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v126, vcc, v122, v86
		v_addc_co_u32_e64 v127, vcc, v123, v87, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v126, s62 offset:352
		s_mov_b32 s62, 0
		scratch_load_dword v122, off, s62 offset:24
		scratch_load_dword v123, off, s62 offset:28
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v126, vcc, v122, v86
		v_addc_co_u32_e64 v127, vcc, v123, v87, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v126, s62 offset:356
		s_mov_b32 s62, 0
		scratch_load_dword v122, off, s62 offset:32
		scratch_load_dword v123, off, s62 offset:36
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v126, vcc, v122, v86
		v_addc_co_u32_e64 v127, vcc, v123, v87, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v126, s62 offset:376
		s_mov_b32 s62, 0
		scratch_load_dword v122, off, s62 offset:40
		scratch_load_dword v123, off, s62 offset:44
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v126, vcc, v122, v86
		v_addc_co_u32_e64 v127, vcc, v123, v87, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v126, s62 offset:380
		s_mov_b32 s62, 0
		scratch_load_dword v86, off, s62 offset:48
		scratch_load_dword v87, off, s62 offset:52
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v122, vcc, v86, v152
		v_addc_co_u32_e64 v123, vcc, v87, v153, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v122, s62 offset:384
		s_mov_b32 s62, 0
		scratch_load_dword v86, off, s62 offset:56
		scratch_load_dword v87, off, s62 offset:60
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v122, vcc, v86, v152
		v_addc_co_u32_e64 v123, vcc, v87, v153, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v122, s62 offset:388
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[96:99], v[176:179], a[0:3], v2, v1 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s62, s61, 1
		s_and_b32 s63, s62, 1
		s_lshl_b32 s62, s63, 16
		v_add_u32_e32 v6, s62, v7
		v_add3_u32 v7, v6, v13, v8
		ds_read_b128 v[152:155], v7 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[96:99], v[180:183], a[4:7], v2, v1 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[208:211], v7 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[96:99], v[184:187], a[8:11], v2, v5 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[212:215], v7 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[96:99], v[188:191], a[12:15], v2, v5 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v7 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[96:99], v[192:195], a[16:19], v2, v101 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v7 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[96:99], v[196:199], a[20:23], v2, v101 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v7 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[96:99], v[200:203], a[24:27], v2, v106 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v7 offset:22528
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(30)
		scratch_load_dword v228, off, s62 offset:292
		scratch_load_dword v229, off, s62 offset:296
		scratch_load_dword v230, off, s62 offset:300
		scratch_load_dword v231, off, s62 offset:304
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[228:231], v[204:207], a[28:31], v2, v106 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v7 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[144:147], v[176:179], a[32:35], v2, v1 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s62, s61, 1
		s_and_b32 s63, s62, 1
		s_lshl_b32 s62, s63, 16
		v_add_u32_e32 v6, s62, v13
		v_add3_u32 v7, v6, v83, v8
		s_mov_b32 s62, 0
		scratch_store_dword off, v7, s62 offset:392
		ds_read_b128 v[176:179], v7 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[144:147], v[180:183], a[36:39], v2, v1 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[180:183], v7 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[144:147], v[184:187], a[40:43], v2, v5 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[232:235], v7 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[144:147], v[188:191], a[44:47], v2, v5 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[236:239], v7 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[144:147], v[192:195], a[48:51], v2, v101 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v7 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[144:147], v[196:199], a[52:55], v2, v101 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[244:247], v7 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[144:147], v[200:203], a[56:59], v2, v106 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[144:147], v7 offset:55296
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(27)
		scratch_load_dword v248, off, s62 offset:360
		scratch_load_dword v249, off, s62 offset:364
		scratch_load_dword v250, off, s62 offset:368
		scratch_load_dword v251, off, s62 offset:372
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[248:251], v[204:207], a[60:63], v2, v106 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v6, off, s62 offset:392
		s_waitcnt vmcnt(0)
		ds_read_b128 v[248:251], v6 offset:56320
		s_mov_b32 s62, 0
		scratch_load_dword v252, off, s62 offset:396
		scratch_load_dword v253, off, s62 offset:400
		scratch_load_dword v254, off, s62 offset:404
		scratch_load_dword v255, off, s62 offset:408
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[148:151], v[252:255], a[64:67], v94, v1 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s62, 0
		scratch_load_dword v6, off, s62 offset:288
		s_mov_b32 m0, s10
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v6, s[20:23], 0 offen lds
		s_mov_b32 s62, 0
		scratch_load_dword v252, off, s62 offset:412
		scratch_load_dword v253, off, s62 offset:416
		scratch_load_dword v254, off, s62 offset:420
		scratch_load_dword v255, off, s62 offset:424
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[148:151], v[252:255], a[68:71], v94, v1 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s62, 0
		scratch_load_dword v6, off, s62 offset:308
		s_mov_b32 m0, s46
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v6, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[148:151], v[184:187], a[72:75], v94, v5 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s62, 0
		scratch_load_dword v6, off, s62 offset:312
		s_mov_b32 m0, s47
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v6, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[148:151], v[188:191], a[76:79], v94, v5 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s62, 0
		scratch_load_dword v6, off, s62 offset:316
		s_mov_b32 m0, s48
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v6, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[148:151], v[192:195], a[80:83], v94, v101 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s62, 0
		scratch_load_dword v6, off, s62 offset:320
		s_mov_b32 m0, s49
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v6, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[148:151], v[196:199], a[84:87], v94, v101 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s62, 0
		scratch_load_dword v6, off, s62 offset:324
		s_mov_b32 m0, s50
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v6, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[148:151], v[200:203], a[88:91], v94, v106 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s62, 0
		scratch_load_dword v6, off, s62 offset:328
		s_mov_b32 m0, s51
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v6, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[148:151], v[204:207], a[92:95], v94, v106 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s62, 0
		scratch_load_dword v6, off, s62 offset:332
		s_mov_b32 m0, s52
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v6, s[20:23], 0 offen lds
		s_mov_b32 s62, 0
		scratch_load_dword v148, off, s62 offset:396
		scratch_load_dword v149, off, s62 offset:400
		scratch_load_dword v150, off, s62 offset:404
		scratch_load_dword v151, off, s62 offset:408
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[156:159], v[148:151], a[96:99], v94, v1 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s62, 0
		scratch_load_dword v6, off, s62 offset:336
		s_mov_b32 m0, s53
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v6, s[0:3], 0 offen lds
		s_mov_b32 s62, 0
		scratch_load_dword v148, off, s62 offset:412
		scratch_load_dword v149, off, s62 offset:416
		scratch_load_dword v150, off, s62 offset:420
		scratch_load_dword v151, off, s62 offset:424
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[156:159], v[148:151], a[100:103], v94, v1 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s62, 0
		scratch_load_dword v6, off, s62 offset:340
		s_mov_b32 m0, s54
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v6, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[156:159], v[184:187], a[104:107], v94, v5 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s62, 0
		scratch_load_dword v6, off, s62 offset:344
		s_mov_b32 m0, s55
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v6, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[156:159], v[188:191], a[108:111], v94, v5 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s62, 0
		scratch_load_dword v6, off, s62 offset:348
		s_mov_b32 m0, s56
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v6, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[156:159], v[192:195], a[112:115], v94, v101 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s62, 0
		scratch_load_dword v6, off, s62 offset:352
		s_mov_b32 m0, s57
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v6, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[156:159], v[196:199], a[116:119], v94, v101 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s62, 0
		scratch_load_dword v6, off, s62 offset:356
		s_mov_b32 m0, s58
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v6, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[156:159], v[200:203], a[120:123], v94, v106 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s62, 0
		scratch_load_dword v6, off, s62 offset:376
		s_mov_b32 m0, s59
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v6, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[156:159], v[204:207], a[124:127], v94, v106 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s62, 0
		scratch_load_dword v6, off, s62 offset:380
		s_mov_b32 m0, s60
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v6, s[0:3], 0 offen lds
		s_mov_b32 s62, 0
		scratch_load_dword v148, off, s62 offset:396
		scratch_load_dword v149, off, s62 offset:400
		scratch_load_dword v150, off, s62 offset:404
		scratch_load_dword v151, off, s62 offset:408
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[160:163], v[148:151], a[128:131], v95, v1 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s62, 0
		scratch_load_dword v6, off, s62 offset:384
		s_add_i32 m0, s44, 0x20000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v6, s[4:7], 0 offen lds
		s_mov_b32 s62, 0
		scratch_load_dword v148, off, s62 offset:412
		scratch_load_dword v149, off, s62 offset:416
		scratch_load_dword v150, off, s62 offset:420
		scratch_load_dword v151, off, s62 offset:424
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[160:163], v[148:151], a[132:135], v95, v1 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s62, 0
		scratch_load_dword v6, off, s62 offset:388
		s_add_i32 m0, s9, 0x20000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[160:163], v[184:187], a[136:139], v95, v5 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[160:163], v[188:191], a[140:143], v95, v5 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[160:163], v[192:195], a[144:147], v95, v101 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[160:163], v[196:199], a[148:151], v95, v101 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[160:163], v[200:203], a[152:155], v95, v106 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[160:163], v[204:207], a[156:159], v95, v106 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s62, 0
		scratch_load_dword v148, off, s62 offset:396
		scratch_load_dword v149, off, s62 offset:400
		scratch_load_dword v150, off, s62 offset:404
		scratch_load_dword v151, off, s62 offset:408
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[164:167], v[148:151], a[160:163], v95, v1 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s62, 0
		scratch_load_dword v148, off, s62 offset:412
		scratch_load_dword v149, off, s62 offset:416
		scratch_load_dword v150, off, s62 offset:420
		scratch_load_dword v151, off, s62 offset:424
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[164:167], v[148:151], a[164:167], v95, v1 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[164:167], v[184:187], a[168:171], v95, v5 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[164:167], v[188:191], a[172:175], v95, v5 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[164:167], v[192:195], a[176:179], v95, v101 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[164:167], v[196:199], a[180:183], v95, v101 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[164:167], v[200:203], a[184:187], v95, v106 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[164:167], v[204:207], a[188:191], v95, v106 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s62, 0
		scratch_load_dword v148, off, s62 offset:396
		scratch_load_dword v149, off, s62 offset:400
		scratch_load_dword v150, off, s62 offset:404
		scratch_load_dword v151, off, s62 offset:408
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[168:171], v[148:151], a[192:195], v100, v1 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s62, 0
		scratch_load_dword v148, off, s62 offset:412
		scratch_load_dword v149, off, s62 offset:416
		scratch_load_dword v150, off, s62 offset:420
		scratch_load_dword v151, off, s62 offset:424
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[168:171], v[148:151], a[196:199], v100, v1 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[168:171], v[184:187], a[200:203], v100, v5 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[168:171], v[188:191], a[204:207], v100, v5 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[168:171], v[192:195], a[208:211], v100, v101 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[168:171], v[196:199], a[212:215], v100, v101 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[168:171], v[200:203], a[216:219], v100, v106 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[168:171], v[204:207], a[220:223], v100, v106 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s62, 0
		scratch_load_dword v148, off, s62 offset:396
		scratch_load_dword v149, off, s62 offset:400
		scratch_load_dword v150, off, s62 offset:404
		scratch_load_dword v151, off, s62 offset:408
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[172:175], v[148:151], a[224:227], v100, v1 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s62, 0
		scratch_load_dword v148, off, s62 offset:412
		scratch_load_dword v149, off, s62 offset:416
		scratch_load_dword v150, off, s62 offset:420
		scratch_load_dword v151, off, s62 offset:424
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[172:175], v[148:151], a[228:231], v100, v1 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[172:175], v[184:187], a[232:235], v100, v5 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[172:175], v[188:191], a[236:239], v100, v5 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[172:175], v[192:195], a[240:243], v100, v101 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[172:175], v[196:199], a[244:247], v100, v101 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[172:175], v[200:203], a[248:251], v100, v106 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[172:175], v[204:207], a[252:255], v100, v106 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[152:155], v[176:179], a[0:3], v2, v1 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[152:155], v[180:183], a[4:7], v2, v1 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[152:155], v[232:235], a[8:11], v2, v5 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[152:155], v[236:239], a[12:15], v2, v5 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[152:155], v[240:243], a[16:19], v2, v101 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[152:155], v[244:247], a[20:23], v2, v101 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[152:155], v[144:147], a[24:27], v2, v106 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[152:155], v[248:251], a[28:31], v2, v106 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[208:211], v[176:179], a[32:35], v2, v1 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[208:211], v[180:183], a[36:39], v2, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[208:211], v[232:235], a[40:43], v2, v5 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[208:211], v[236:239], a[44:47], v2, v5 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[208:211], v[240:243], a[48:51], v2, v101 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[208:211], v[244:247], a[52:55], v2, v101 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[208:211], v[144:147], a[56:59], v2, v106 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[208:211], v[248:251], a[60:63], v2, v106 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[212:215], v[176:179], a[64:67], v94, v1 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[212:215], v[180:183], a[68:71], v94, v1 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[212:215], v[232:235], a[72:75], v94, v5 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[212:215], v[236:239], a[76:79], v94, v5 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[212:215], v[240:243], a[80:83], v94, v101 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[212:215], v[244:247], a[84:87], v94, v101 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[212:215], v[144:147], a[88:91], v94, v106 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[212:215], v[248:251], a[92:95], v94, v106 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[216:219], v[176:179], a[96:99], v94, v1 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[216:219], v[180:183], a[100:103], v94, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[216:219], v[232:235], a[104:107], v94, v5 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[216:219], v[236:239], a[108:111], v94, v5 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[216:219], v[240:243], a[112:115], v94, v101 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[216:219], v[244:247], a[116:119], v94, v101 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[216:219], v[144:147], a[120:123], v94, v106 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[216:219], v[248:251], a[124:127], v94, v106 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[220:223], v[176:179], a[128:131], v95, v1 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[220:223], v[180:183], a[132:135], v95, v1 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[220:223], v[232:235], a[136:139], v95, v5 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[220:223], v[236:239], a[140:143], v95, v5 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[220:223], v[240:243], a[144:147], v95, v101 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[220:223], v[244:247], a[148:151], v95, v101 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[220:223], v[144:147], a[152:155], v95, v106 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[220:223], v[248:251], a[156:159], v95, v106 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[224:227], v[176:179], a[160:163], v95, v1 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[224:227], v[180:183], a[164:167], v95, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[224:227], v[232:235], a[168:171], v95, v5 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[224:227], v[236:239], a[172:175], v95, v5 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[224:227], v[240:243], a[176:179], v95, v101 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[224:227], v[244:247], a[180:183], v95, v101 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[224:227], v[144:147], a[184:187], v95, v106 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[224:227], v[248:251], a[188:191], v95, v106 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[96:99], v[176:179], a[192:195], v100, v1 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[96:99], v[180:183], a[196:199], v100, v1 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[96:99], v[232:235], a[200:203], v100, v5 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[96:99], v[236:239], a[204:207], v100, v5 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[96:99], v[240:243], a[208:211], v100, v101 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[96:99], v[244:247], a[212:215], v100, v101 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[96:99], v[144:147], a[216:219], v100, v106 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[96:99], v[248:251], a[220:223], v100, v106 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[228:231], v[176:179], a[224:227], v100, v1 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[228:231], v[180:183], a[228:231], v100, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[228:231], v[232:235], a[232:235], v100, v5 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[228:231], v[236:239], a[236:239], v100, v5 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[228:231], v[240:243], a[240:243], v100, v101 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[228:231], v[244:247], a[244:247], v100, v101 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[228:231], v[144:147], a[248:251], v100, v106 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[228:231], v[248:251], a[252:255], v100, v106 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s61, s61, 2
		s_cmp_lt_i32 s61, s11
		s_mov_b32 s62, 0
		scratch_load_dword v96, off, s62 offset:64
		scratch_load_dword v97, off, s62 offset:68
		scratch_load_dword v98, off, s62 offset:72
		scratch_load_dword v99, off, s62 offset:76
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v32, v96
		v_mov_b32_e32 v33, v97
		v_mov_b32_e32 v34, v98
		v_mov_b32_e32 v35, v99
		s_mov_b32 s62, 0
		scratch_load_dword v96, off, s62 offset:80
		scratch_load_dword v97, off, s62 offset:84
		scratch_load_dword v98, off, s62 offset:88
		scratch_load_dword v99, off, s62 offset:92
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v36, v96
		v_mov_b32_e32 v37, v97
		v_mov_b32_e32 v38, v98
		v_mov_b32_e32 v39, v99
		s_mov_b32 s62, 0
		scratch_load_dword v96, off, s62 offset:96
		scratch_load_dword v97, off, s62 offset:100
		scratch_load_dword v98, off, s62 offset:104
		scratch_load_dword v99, off, s62 offset:108
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v40, v96
		v_mov_b32_e32 v41, v97
		v_mov_b32_e32 v42, v98
		v_mov_b32_e32 v43, v99
		s_mov_b32 s62, 0
		scratch_load_dword v96, off, s62 offset:112
		scratch_load_dword v97, off, s62 offset:116
		scratch_load_dword v98, off, s62 offset:120
		scratch_load_dword v99, off, s62 offset:124
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v44, v96
		v_mov_b32_e32 v45, v97
		v_mov_b32_e32 v46, v98
		v_mov_b32_e32 v47, v99
		s_mov_b32 s62, 0
		scratch_load_dword v96, off, s62 offset:128
		scratch_load_dword v97, off, s62 offset:132
		scratch_load_dword v98, off, s62 offset:136
		scratch_load_dword v99, off, s62 offset:140
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v48, v96
		v_mov_b32_e32 v49, v97
		v_mov_b32_e32 v50, v98
		v_mov_b32_e32 v51, v99
		s_mov_b32 s62, 0
		scratch_load_dword v96, off, s62 offset:144
		scratch_load_dword v97, off, s62 offset:148
		scratch_load_dword v98, off, s62 offset:152
		scratch_load_dword v99, off, s62 offset:156
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v52, v96
		v_mov_b32_e32 v53, v97
		v_mov_b32_e32 v54, v98
		v_mov_b32_e32 v55, v99
		s_mov_b32 s62, 0
		scratch_load_dword v96, off, s62 offset:160
		scratch_load_dword v97, off, s62 offset:164
		scratch_load_dword v98, off, s62 offset:168
		scratch_load_dword v99, off, s62 offset:172
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v56, v96
		v_mov_b32_e32 v57, v97
		v_mov_b32_e32 v58, v98
		v_mov_b32_e32 v59, v99
		s_mov_b32 s62, 0
		scratch_load_dword v96, off, s62 offset:176
		scratch_load_dword v97, off, s62 offset:180
		scratch_load_dword v98, off, s62 offset:184
		scratch_load_dword v99, off, s62 offset:188
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v60, v96
		v_mov_b32_e32 v61, v97
		v_mov_b32_e32 v62, v98
		v_mov_b32_e32 v63, v99
		s_mov_b32 s62, 0
		scratch_load_dword v96, off, s62 offset:192
		scratch_load_dword v97, off, s62 offset:196
		scratch_load_dword v98, off, s62 offset:200
		scratch_load_dword v99, off, s62 offset:204
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v64, v96
		v_mov_b32_e32 v65, v97
		v_mov_b32_e32 v66, v98
		v_mov_b32_e32 v67, v99
		s_mov_b32 s62, 0
		scratch_load_dword v96, off, s62 offset:208
		scratch_load_dword v97, off, s62 offset:212
		scratch_load_dword v98, off, s62 offset:216
		scratch_load_dword v99, off, s62 offset:220
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v68, v96
		v_mov_b32_e32 v69, v97
		v_mov_b32_e32 v70, v98
		v_mov_b32_e32 v71, v99
		s_mov_b32 s62, 0
		scratch_load_dword v96, off, s62 offset:224
		scratch_load_dword v97, off, s62 offset:228
		scratch_load_dword v98, off, s62 offset:232
		scratch_load_dword v99, off, s62 offset:236
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v72, v96
		v_mov_b32_e32 v73, v97
		v_mov_b32_e32 v74, v98
		v_mov_b32_e32 v75, v99
		s_mov_b32 s62, 0
		scratch_load_dword v96, off, s62 offset:240
		scratch_load_dword v97, off, s62 offset:244
		scratch_load_dword v98, off, s62 offset:248
		scratch_load_dword v99, off, s62 offset:252
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v76, v96
		v_mov_b32_e32 v77, v97
		v_mov_b32_e32 v78, v98
		v_mov_b32_e32 v79, v99
		s_mov_b32 s62, 0
		scratch_load_dword v1, off, s62 offset:256
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v2, v1
		s_mov_b32 s62, 0
		scratch_load_dword v1, off, s62 offset:260
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v10, v1
		s_mov_b32 s62, 0
		scratch_load_dword v1, off, s62 offset:264
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v14, v1
		s_mov_b32 s62, 0
		scratch_load_dword v1, off, s62 offset:268
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v15, v1
		s_mov_b32 s62, 0
		scratch_load_dword v1, off, s62 offset:272
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v4, v1
		s_mov_b32 s62, 0
		scratch_load_dword v1, off, s62 offset:276
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v80, v1
		s_mov_b32 s62, 0
		scratch_load_dword v1, off, s62 offset:280
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v81, v1
		s_mov_b32 s62, 0
		scratch_load_dword v1, off, s62 offset:284
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v82, v1
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v2 offset:23552
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_mov_b32 m0, s15
		s_waitcnt lgkmcnt(0)
		s_nop 0
		ds_read_addtid_b32 v1 offset:23552
		s_add_i32 s0, s12, -1
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[16:19], v[48:51], a[0:3], v1, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s1, s0, 1
		s_lshl_b32 s0, s1, 16
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 13, v2
		v_add_u32_e32 v2, s0, v3
		v_and_b32_e32 v5, 15, v0
		v_lshlrev_b32_e32 v6, 6, v5
		v_and_b32_e32 v5, 63, v0
		v_lshrrev_b32_e32 v7, 4, v5
		v_and_b32_e32 v5, 15, v0
		v_lshrrev_b32_e32 v8, 1, v5
		v_and_b32_e32 v5, 3, v8
		v_xor_b32_e32 v8, v7, v5
		v_lshlrev_b32_e32 v5, 4, v8
		v_add3_u32 v7, v2, v6, v5
		ds_read_b128 v[84:87], v7 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[16:19], v[52:55], a[4:7], v1, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v7 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[16:19], v[56:59], a[8:11], v1, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v7 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[16:19], v[60:63], a[12:15], v1, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v7 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[16:19], v[64:67], a[16:19], v1, v81 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v7 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[16:19], v[68:71], a[20:23], v1, v81 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[104:107], v7 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[16:19], v[72:75], a[24:27], v1, v82 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[108:111], v7 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[16:19], v[76:79], a[28:31], v1, v82 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[16:19], v7 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[20:23], v[48:51], a[32:35], v1, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, s0, v6
		v_lshrrev_b32_e32 v7, 6, v0
		v_and_b32_e32 v8, 1, v7
		v_lshlrev_b32_e32 v7, 13, v8
		v_add3_u32 v8, v2, v7, v5
		ds_read_b128 v[112:115], v8 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[20:23], v[52:55], a[36:39], v1, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[116:119], v8 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[20:23], v[56:59], a[40:43], v1, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[120:123], v8 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[20:23], v[60:63], a[44:47], v1, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[124:127], v8 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[20:23], v[64:67], a[48:51], v1, v81 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[128:131], v8 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[20:23], v[68:71], a[52:55], v1, v81 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[132:135], v8 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[20:23], v[72:75], a[56:59], v1, v82 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[136:139], v8 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[20:23], v[76:79], a[60:63], v1, v82 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v8 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[24:27], v[48:51], a[64:67], v10, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[24:27], v[52:55], a[68:71], v10, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[24:27], v[56:59], a[72:75], v10, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[24:27], v[60:63], a[76:79], v10, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[24:27], v[64:67], a[80:83], v10, v81 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[24:27], v[68:71], a[84:87], v10, v81 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[24:27], v[72:75], a[88:91], v10, v82 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[24:27], v[76:79], a[92:95], v10, v82 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[28:31], v[48:51], a[96:99], v10, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[28:31], v[52:55], a[100:103], v10, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[28:31], v[56:59], a[104:107], v10, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[28:31], v[60:63], a[108:111], v10, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[28:31], v[64:67], a[112:115], v10, v81 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[28:31], v[68:71], a[116:119], v10, v81 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[28:31], v[72:75], a[120:123], v10, v82 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[28:31], v[76:79], a[124:127], v10, v82 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[32:35], v[48:51], a[128:131], v14, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[32:35], v[52:55], a[132:135], v14, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[32:35], v[56:59], a[136:139], v14, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[32:35], v[60:63], a[140:143], v14, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], v[64:67], a[144:147], v14, v81 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[32:35], v[68:71], a[148:151], v14, v81 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[32:35], v[72:75], a[152:155], v14, v82 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[32:35], v[76:79], a[156:159], v14, v82 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], v[48:51], a[160:163], v14, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[36:39], v[52:55], a[164:167], v14, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[36:39], v[56:59], a[168:171], v14, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[36:39], v[60:63], a[172:175], v14, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[36:39], v[64:67], a[176:179], v14, v81 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[36:39], v[68:71], a[180:183], v14, v81 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[36:39], v[72:75], a[184:187], v14, v82 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[36:39], v[76:79], a[188:191], v14, v82 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[40:43], v[48:51], a[192:195], v15, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[40:43], v[52:55], a[196:199], v15, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[40:43], v[56:59], a[200:203], v15, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[40:43], v[60:63], a[204:207], v15, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[40:43], v[64:67], a[208:211], v15, v81 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[40:43], v[68:71], a[212:215], v15, v81 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[40:43], v[72:75], a[216:219], v15, v82 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[40:43], v[76:79], a[220:223], v15, v82 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[44:47], v[48:51], a[224:227], v15, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[44:47], v[52:55], a[228:231], v15, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[44:47], v[56:59], a[232:235], v15, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[44:47], v[60:63], a[236:239], v15, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[44:47], v[64:67], a[240:243], v15, v81 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[44:47], v[68:71], a[244:247], v15, v81 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[44:47], v[72:75], a[248:251], v15, v82 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[44:47], v[76:79], a[252:255], v15, v82 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[84:87], v[112:115], a[0:3], v1, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[84:87], v[116:119], a[4:7], v1, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[84:87], v[120:123], a[8:11], v1, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[84:87], v[124:127], a[12:15], v1, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[84:87], v[128:131], a[16:19], v1, v81 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[84:87], v[132:135], a[20:23], v1, v81 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[84:87], v[136:139], a[24:27], v1, v82 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[84:87], v[20:23], a[28:31], v1, v82 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[88:91], v[112:115], a[32:35], v1, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[88:91], v[116:119], a[36:39], v1, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[88:91], v[120:123], a[40:43], v1, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[88:91], v[124:127], a[44:47], v1, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[88:91], v[128:131], a[48:51], v1, v81 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[88:91], v[132:135], a[52:55], v1, v81 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[88:91], v[136:139], a[56:59], v1, v82 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[88:91], v[20:23], a[60:63], v1, v82 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[92:95], v[112:115], a[64:67], v10, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[92:95], v[116:119], a[68:71], v10, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[92:95], v[120:123], a[72:75], v10, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[92:95], v[124:127], a[76:79], v10, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[92:95], v[128:131], a[80:83], v10, v81 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[92:95], v[132:135], a[84:87], v10, v81 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[92:95], v[136:139], a[88:91], v10, v82 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[92:95], v[20:23], a[92:95], v10, v82 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[96:99], v[112:115], a[96:99], v10, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[96:99], v[116:119], a[100:103], v10, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[96:99], v[120:123], a[104:107], v10, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[96:99], v[124:127], a[108:111], v10, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[96:99], v[128:131], a[112:115], v10, v81 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[96:99], v[132:135], a[116:119], v10, v81 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[96:99], v[136:139], a[120:123], v10, v82 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[96:99], v[20:23], a[124:127], v10, v82 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[100:103], v[112:115], a[128:131], v14, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[100:103], v[116:119], a[132:135], v14, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[100:103], v[120:123], a[136:139], v14, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[100:103], v[124:127], a[140:143], v14, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[100:103], v[128:131], a[144:147], v14, v81 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[100:103], v[132:135], a[148:151], v14, v81 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[100:103], v[136:139], a[152:155], v14, v82 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[100:103], v[20:23], a[156:159], v14, v82 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[104:107], v[112:115], a[160:163], v14, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[104:107], v[116:119], a[164:167], v14, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[104:107], v[120:123], a[168:171], v14, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[104:107], v[124:127], a[172:175], v14, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[104:107], v[128:131], a[176:179], v14, v81 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[104:107], v[132:135], a[180:183], v14, v81 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[104:107], v[136:139], a[184:187], v14, v82 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[104:107], v[20:23], a[188:191], v14, v82 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[108:111], v[112:115], a[192:195], v15, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[108:111], v[116:119], a[196:199], v15, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[108:111], v[120:123], a[200:203], v15, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[108:111], v[124:127], a[204:207], v15, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[108:111], v[128:131], a[208:211], v15, v81 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[108:111], v[132:135], a[212:215], v15, v81 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[108:111], v[136:139], a[216:219], v15, v82 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[108:111], v[20:23], a[220:223], v15, v82 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[16:19], v[112:115], a[224:227], v15, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[16:19], v[116:119], a[228:231], v15, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[16:19], v[120:123], a[232:235], v15, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[16:19], v[124:127], a[236:239], v15, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[16:19], v[128:131], a[240:243], v15, v81 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[16:19], v[132:135], a[244:247], v15, v81 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[16:19], v[136:139], a[248:251], v15, v82 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[16:19], v[20:23], a[252:255], v15, v82 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s0, s12, 1
		s_lshl_b32 s1, s0, 16
		v_add_u32_e32 v1, s1, v3
		v_add3_u32 v2, v1, v6, v5
		ds_read_b128 v[8:11], v2
		ds_read_b128 v[12:15], v2 offset:1024
		ds_read_b128 v[16:19], v2 offset:2048
		ds_read_b128 v[20:23], v2 offset:3072
		ds_read_b128 v[24:27], v2 offset:4096
		ds_read_b128 v[28:31], v2 offset:5120
		ds_read_b128 v[32:35], v2 offset:6144
		ds_read_b128 v[36:39], v2 offset:7168
		v_add_u32_e32 v1, s1, v6
		v_add3_u32 v3, v1, v7, v5
		ds_read_b128 v[4:7], v3 offset:32768
		ds_read_b128 v[40:43], v3 offset:33792
		ds_read_b128 v[44:47], v3 offset:34816
		ds_read_b128 v[48:51], v3 offset:35840
		ds_read_b128 v[52:55], v3 offset:36864
		ds_read_b128 v[56:59], v3 offset:37888
		ds_read_b128 v[60:63], v3 offset:38912
		ds_read_b128 v[64:67], v3 offset:39936
		s_lshl_b32 s1, s0, 12
		s_add_i32 s0, s1, 0x20000
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v68, 10, v1
		v_and_b32_e32 v1, 63, v0
		v_lshlrev_b32_e32 v69, 2, v1
		v_add3_u32 v1, s0, v68, v69
		ds_read_b32 v68, v1
		ds_read_b32 v70, v1 offset:256
		ds_read_b32 v71, v1 offset:512
		ds_read_b32 v72, v1 offset:768
		v_lshrrev_b32_e32 v1, 6, v0
		v_and_b32_e32 v73, 1, v1
		v_lshlrev_b32_e32 v1, 10, v73
		v_add3_u32 v73, s0, v69, v1
		ds_read_b32 v1, v73 offset:2048
		ds_read_b32 v69, v73 offset:2304
		ds_read_b32 v74, v73 offset:2560
		ds_read_b32 v75, v73 offset:2816
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[8:11], v[4:7], a[0:3], v68, v1 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[76:79], v2 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[8:11], v[40:43], a[4:7], v68, v1 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[80:83], v2 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[8:11], v[44:47], a[8:11], v68, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[84:87], v2 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[8:11], v[48:51], a[12:15], v68, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v2 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[8:11], v[52:55], a[16:19], v68, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v2 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[8:11], v[56:59], a[20:23], v68, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v2 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[8:11], v[60:63], a[24:27], v68, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v2 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[8:11], v[64:67], a[28:31], v68, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[8:11], v2 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[12:15], v[4:7], a[32:35], v68, v1 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[104:107], v3 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[12:15], v[40:43], a[36:39], v68, v1 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[108:111], v3 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[12:15], v[44:47], a[40:43], v68, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[112:115], v3 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[12:15], v[48:51], a[44:47], v68, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[116:119], v3 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[12:15], v[52:55], a[48:51], v68, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[120:123], v3 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[12:15], v[56:59], a[52:55], v68, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[124:127], v3 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[12:15], v[60:63], a[56:59], v68, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[128:131], v3 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[12:15], v[64:67], a[60:63], v68, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[12:15], v3 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[16:19], v[4:7], a[64:67], v70, v1 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[16:19], v[40:43], a[68:71], v70, v1 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[16:19], v[44:47], a[72:75], v70, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[16:19], v[48:51], a[76:79], v70, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[16:19], v[52:55], a[80:83], v70, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[16:19], v[56:59], a[84:87], v70, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[16:19], v[60:63], a[88:91], v70, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[16:19], v[64:67], a[92:95], v70, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[20:23], v[4:7], a[96:99], v70, v1 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[20:23], v[40:43], a[100:103], v70, v1 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[20:23], v[44:47], a[104:107], v70, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[20:23], v[48:51], a[108:111], v70, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[20:23], v[52:55], a[112:115], v70, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[20:23], v[56:59], a[116:119], v70, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[20:23], v[60:63], a[120:123], v70, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[20:23], v[64:67], a[124:127], v70, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[24:27], v[4:7], a[128:131], v71, v1 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[24:27], v[40:43], a[132:135], v71, v1 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[24:27], v[44:47], a[136:139], v71, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[24:27], v[48:51], a[140:143], v71, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[24:27], v[52:55], a[144:147], v71, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[24:27], v[56:59], a[148:151], v71, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[24:27], v[60:63], a[152:155], v71, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[24:27], v[64:67], a[156:159], v71, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[28:31], v[4:7], a[160:163], v71, v1 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[28:31], v[40:43], a[164:167], v71, v1 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[28:31], v[44:47], a[168:171], v71, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[28:31], v[48:51], a[172:175], v71, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[28:31], v[52:55], a[176:179], v71, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[28:31], v[56:59], a[180:183], v71, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[28:31], v[60:63], a[184:187], v71, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[28:31], v[64:67], a[188:191], v71, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[32:35], v[4:7], a[192:195], v72, v1 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[32:35], v[40:43], a[196:199], v72, v1 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[32:35], v[44:47], a[200:203], v72, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[32:35], v[48:51], a[204:207], v72, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[32:35], v[52:55], a[208:211], v72, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[32:35], v[56:59], a[212:215], v72, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[32:35], v[60:63], a[216:219], v72, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[32:35], v[64:67], a[220:223], v72, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[36:39], v[4:7], a[224:227], v72, v1 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[36:39], v[40:43], a[228:231], v72, v1 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[36:39], v[44:47], a[232:235], v72, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[36:39], v[48:51], a[236:239], v72, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[36:39], v[52:55], a[240:243], v72, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[36:39], v[56:59], a[244:247], v72, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[36:39], v[60:63], a[248:251], v72, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[36:39], v[64:67], a[252:255], v72, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[76:79], v[104:107], a[0:3], v68, v1 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[76:79], v[108:111], a[4:7], v68, v1 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[76:79], v[112:115], a[8:11], v68, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[76:79], v[116:119], a[12:15], v68, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[76:79], v[120:123], a[16:19], v68, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[76:79], v[124:127], a[20:23], v68, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[76:79], v[128:131], a[24:27], v68, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[76:79], v[12:15], a[28:31], v68, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[80:83], v[104:107], a[32:35], v68, v1 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[80:83], v[108:111], a[36:39], v68, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[80:83], v[112:115], a[40:43], v68, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[80:83], v[116:119], a[44:47], v68, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[80:83], v[120:123], a[48:51], v68, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[80:83], v[124:127], a[52:55], v68, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[80:83], v[128:131], a[56:59], v68, v75 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[80:83], v[12:15], a[60:63], v68, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[84:87], v[104:107], a[64:67], v70, v1 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[84:87], v[108:111], a[68:71], v70, v1 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[84:87], v[112:115], a[72:75], v70, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[84:87], v[116:119], a[76:79], v70, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[84:87], v[120:123], a[80:83], v70, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[84:87], v[124:127], a[84:87], v70, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[84:87], v[128:131], a[88:91], v70, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[84:87], v[12:15], a[92:95], v70, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[88:91], v[104:107], a[96:99], v70, v1 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[88:91], v[108:111], a[100:103], v70, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[88:91], v[112:115], a[104:107], v70, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[88:91], v[116:119], a[108:111], v70, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[88:91], v[120:123], a[112:115], v70, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[88:91], v[124:127], a[116:119], v70, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[88:91], v[128:131], a[120:123], v70, v75 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[88:91], v[12:15], a[124:127], v70, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[92:95], v[104:107], a[128:131], v71, v1 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[92:95], v[108:111], a[132:135], v71, v1 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[92:95], v[112:115], a[136:139], v71, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[92:95], v[116:119], a[140:143], v71, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[92:95], v[120:123], a[144:147], v71, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[92:95], v[124:127], a[148:151], v71, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[92:95], v[128:131], a[152:155], v71, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[92:95], v[12:15], a[156:159], v71, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[96:99], v[104:107], a[160:163], v71, v1 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[96:99], v[108:111], a[164:167], v71, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[96:99], v[112:115], a[168:171], v71, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[96:99], v[116:119], a[172:175], v71, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[96:99], v[120:123], a[176:179], v71, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[96:99], v[124:127], a[180:183], v71, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[96:99], v[128:131], a[184:187], v71, v75 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[96:99], v[12:15], a[188:191], v71, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[100:103], v[104:107], a[192:195], v72, v1 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[100:103], v[108:111], a[196:199], v72, v1 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[100:103], v[112:115], a[200:203], v72, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[100:103], v[116:119], a[204:207], v72, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[100:103], v[120:123], a[208:211], v72, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[100:103], v[124:127], a[212:215], v72, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[100:103], v[128:131], a[216:219], v72, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[100:103], v[12:15], a[220:223], v72, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[8:11], v[104:107], a[224:227], v72, v1 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[8:11], v[108:111], a[228:231], v72, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[8:11], v[112:115], a[232:235], v72, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[8:11], v[116:119], a[236:239], v72, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[8:11], v[120:123], a[240:243], v72, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[8:11], v[124:127], a[244:247], v72, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[8:11], v[128:131], a[248:251], v72, v75 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[8:11], v[12:15], a[252:255], v72, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_accvgpr_read_b32 v1, a0
		v_accvgpr_read_b32 v2, a1
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a2
		v_accvgpr_read_b32 v2, a3
		v_cvt_pk_f16_f32 v5, v1, v2
		v_and_b32_e32 v1, 63, v0
		v_lshlrev_b32_e32 v2, 3, v1
		v_lshrrev_b32_e32 v1, 6, v0
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
		.amdhsa_private_segment_fixed_size 428
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
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 428
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
    .private_segment_fixed_size: 428
    .sgpr_count:     65
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     512
    .agpr_count:     256
    .vgpr_spill_count: 107
    .wavefront_size: 64
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
