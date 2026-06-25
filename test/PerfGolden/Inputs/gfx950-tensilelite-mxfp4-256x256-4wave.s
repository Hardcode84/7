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
		scratch_store_dword off, v4, s8 offset:232
		scratch_store_dword off, v5, s8 offset:236
		scratch_store_dword off, v6, s8 offset:240
		scratch_store_dword off, v7, s8 offset:244
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
		v_accvgpr_read_b32 v1, a1
		v_lshlrev_b32_e32 v5, 4, v1
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v6, 10, v1
		v_add3_u32 v1, s44, v6, v5
		s_lshr_b32 s45, s8, 7
		s_lshl_b32 s8, s45, 10
		v_accvgpr_read_b32 v6, a0
		v_and_b32_e32 v7, 1, v6
		v_lshlrev_b32_e32 v6, 10, v7
		v_add3_u32 v8, s44, v5, v6
		s_and_b32 s44, s11, 1
		s_lshl_b32 s11, s44, 10
		s_add_i32 s44, s11, 0x800
		s_add_i32 m0, s8, 0x20000
		s_nop 0
		buffer_load_dwordx4 v1, s[4:7], 0 offen lds
		s_add_i32 m0, s11, 0x20800
		s_nop 0
		buffer_load_dwordx4 v8, s[24:27], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		v_and_b32_e32 v1, 15, v0
		v_accvgpr_read_b32 v6, a1
		v_lshrrev_b32_e32 v8, 4, v6
		v_lshrrev_b32_e32 v6, 1, v1
		v_and_b32_e32 v1, 3, v6
		v_xor_b32_e32 v6, v8, v1
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v8, 13, v1
		v_and_b32_e32 v1, 15, v0
		v_lshlrev_b32_e32 v9, 6, v1
		v_lshlrev_b32_e32 v1, 4, v6
		v_add3_u32 v10, v8, v9, v1
		ds_read_b128 v[12:15], v10
		ds_read_b128 v[16:19], v10 offset:1024
		ds_read_b128 v[20:23], v10 offset:2048
		ds_read_b128 v[24:27], v10 offset:3072
		ds_read_b128 v[28:31], v10 offset:4096
		ds_read_b128 v[32:35], v10 offset:5120
		ds_read_b128 v[36:39], v10 offset:6144
		ds_read_b128 v[40:43], v10 offset:7168
		v_lshlrev_b32_e32 v1, 13, v7
		v_and_b32_e32 v8, 15, v0
		v_lshlrev_b32_e32 v9, 6, v8
		v_lshlrev_b32_e32 v8, 4, v6
		v_add3_u32 v10, v9, v1, v8
		ds_read_b128 v[44:47], v10 offset:32768
		ds_read_b128 v[48:51], v10 offset:33792
		ds_read_b128 v[52:55], v10 offset:34816
		ds_read_b128 v[56:59], v10 offset:35840
		ds_read_b128 v[60:63], v10 offset:36864
		ds_read_b128 v[64:67], v10 offset:37888
		ds_read_b128 v[68:71], v10 offset:38912
		ds_read_b128 v[72:75], v10 offset:39936
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v8, 10, v1
		v_add_u32_e32 v1, 0x20000, v8
		v_accvgpr_read_b32 v8, a1
		v_lshlrev_b32_e32 v9, 2, v8
		v_add_u32_e32 v10, v1, v9
		ds_read_b32 v1, v10
		ds_read_b32 v9, v10 offset:256
		ds_read_b32 v11, v10 offset:512
		ds_read_b32 v76, v10 offset:768
		v_lshlrev_b32_e32 v10, 2, v8
		v_add_u32_e32 v77, 0x20000, v10
		v_lshlrev_b32_e32 v10, 10, v7
		v_add_u32_e32 v78, v77, v10
		ds_read_b32 v10, v78 offset:2048
		ds_read_b32 v77, v78 offset:2304
		ds_read_b32 v79, v78 offset:2560
		ds_read_b32 v80, v78 offset:2816
		s_waitcnt lgkmcnt(0)
		s_add_i32 s45, s9, 0x80
		v_add_u32_e32 v78, s45, v2
		v_add3_u32 v81, v78, v3, v4
		s_add_i32 s45, s9, 0x40080
		v_add_u32_e32 v78, s45, v2
		v_add3_u32 v82, v78, v3, v4
		s_add_i32 s45, s9, 0x80080
		v_add_u32_e32 v78, s45, v2
		v_add3_u32 v83, v78, v3, v4
		s_add_i32 s45, s9, 0xc0080
		v_add_u32_e32 v78, s45, v2
		v_add3_u32 v84, v78, v3, v4
		s_add_i32 s45, s9, 0xc0
		v_add_u32_e32 v78, s45, v2
		v_add3_u32 v85, v78, v3, v4
		s_add_i32 s45, s9, 0x400c0
		v_add_u32_e32 v78, s45, v2
		v_add3_u32 v86, v78, v3, v4
		s_add_i32 s45, s9, 0x800c0
		v_add_u32_e32 v78, s45, v2
		v_add3_u32 v87, v78, v3, v4
		s_add_i32 s45, s9, 0xc00c0
		v_add_u32_e32 v78, s45, v2
		v_add3_u32 v88, v78, v3, v4
		s_add_i32 s45, s10, 0x80
		v_add_u32_e32 v78, s45, v2
		v_add3_u32 v89, v78, v3, v4
		s_add_i32 s45, s10, 0x40080
		v_add_u32_e32 v78, s45, v2
		v_add3_u32 v90, v78, v3, v4
		s_add_i32 s45, s10, 0x80080
		v_add_u32_e32 v78, s45, v2
		v_add3_u32 v91, v78, v3, v4
		s_add_i32 s45, s10, 0xc0080
		v_add_u32_e32 v78, s45, v2
		v_add3_u32 v92, v78, v3, v4
		s_add_i32 s45, s10, 0xc0
		v_add_u32_e32 v78, s45, v2
		v_add3_u32 v93, v78, v3, v4
		s_add_i32 s45, s10, 0x400c0
		v_add_u32_e32 v78, s45, v2
		v_add3_u32 v94, v78, v3, v4
		s_add_i32 s45, s10, 0x800c0
		v_add_u32_e32 v78, s45, v2
		v_add3_u32 v95, v78, v3, v4
		s_add_i32 s45, s10, 0xc00c0
		v_add_u32_e32 v78, s45, v2
		v_add3_u32 v2, v78, v3, v4
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
		buffer_load_dwordx4 v81, s[20:23], 0 offen lds
		s_mov_b32 m0, s45
		s_nop 0
		buffer_load_dwordx4 v82, s[20:23], 0 offen lds
		s_mov_b32 m0, s46
		s_nop 0
		buffer_load_dwordx4 v83, s[20:23], 0 offen lds
		s_mov_b32 m0, s47
		s_nop 0
		buffer_load_dwordx4 v84, s[20:23], 0 offen lds
		s_mov_b32 m0, s48
		s_nop 0
		buffer_load_dwordx4 v85, s[20:23], 0 offen lds
		s_mov_b32 m0, s49
		s_nop 0
		buffer_load_dwordx4 v86, s[20:23], 0 offen lds
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v87, s[20:23], 0 offen lds
		s_mov_b32 m0, s51
		s_nop 0
		buffer_load_dwordx4 v88, s[20:23], 0 offen lds
		s_mov_b32 m0, s52
		s_nop 0
		buffer_load_dwordx4 v89, s[0:3], 0 offen lds
		s_mov_b32 m0, s53
		s_nop 0
		buffer_load_dwordx4 v90, s[0:3], 0 offen lds
		s_mov_b32 m0, s54
		s_nop 0
		buffer_load_dwordx4 v91, s[0:3], 0 offen lds
		s_mov_b32 m0, s55
		s_nop 0
		buffer_load_dwordx4 v92, s[0:3], 0 offen lds
		s_mov_b32 m0, s56
		s_nop 0
		buffer_load_dwordx4 v93, s[0:3], 0 offen lds
		s_mov_b32 m0, s57
		s_nop 0
		buffer_load_dwordx4 v94, s[0:3], 0 offen lds
		s_mov_b32 m0, s58
		s_nop 0
		buffer_load_dwordx4 v95, s[0:3], 0 offen lds
		s_mov_b32 m0, s59
		s_nop 0
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_add_i32 s60, s9, 0x800
		s_add_i32 s9, s60, s43
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 10, v2
		v_add3_u32 v2, s9, v3, v5
		s_add_i32 s43, s8, 0x1000
		v_lshlrev_b32_e32 v3, 10, v7
		v_add3_u32 v4, s9, v5, v3
		s_add_i32 s9, s11, 0x1800
		s_add_i32 m0, s8, 0x21000
		s_nop 0
		buffer_load_dwordx4 v2, s[4:7], 0 offen lds
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
		v_mov_b32_e32 v4, s62
		v_mov_b32_e32 v5, s63
		v_mul_lo_u32 v82, v4, v2
		v_mul_hi_u32 v83, v4, v2
		v_mul_lo_u32 v78, v4, v3
		v_add_u32_e32 v83, v83, v78
		v_mul_lo_u32 v78, v5, v2
		v_add_u32_e32 v83, v83, v78
		s_mov_b32 s62, 1
		s_mov_b32 s63, 0
		v_mov_b32_e32 v84, v0
		v_mov_b32_e32 v85, 0
		v_mov_b32_e32 v86, s62
		v_mov_b32_e32 v87, s63
		v_mul_lo_u32 v88, v86, v84
		v_mul_hi_u32 v89, v86, v84
		v_mul_lo_u32 v2, v86, v85
		v_add_u32_e32 v89, v89, v2
		v_mul_lo_u32 v2, v87, v84
		v_add_u32_e32 v89, v89, v2
		v_lshrrev_b64 v[90:91], 6, v[88:89]
		s_mov_b32 s62, 0x10000
		s_mov_b32 s63, 0
		v_mov_b32_e32 v92, s62
		v_mov_b32_e32 v93, s63
		v_mul_lo_u32 v94, v92, v90
		v_mul_hi_u32 v95, v92, v90
		v_mul_lo_u32 v2, v92, v91
		v_add_u32_e32 v95, v95, v2
		v_mul_lo_u32 v2, v93, v90
		v_add_u32_e32 v95, v95, v2
		v_add_co_u32_e64 v96, vcc, v82, v94
		v_addc_co_u32_e64 v97, vcc, v83, v95, vcc
		v_mov_b32_e32 v2, 63
		v_and_b32_e32 v98, v84, v2
		v_and_b32_e32 v99, v3, v3
		v_mul_lo_u32 v84, v86, v98
		v_mul_hi_u32 v85, v86, v98
		v_mul_lo_u32 v2, v86, v99
		v_add_u32_e32 v85, v85, v2
		v_mul_lo_u32 v2, v87, v98
		v_add_u32_e32 v85, v85, v2
		v_lshrrev_b64 v[86:87], 2, v[84:85]
		s_mov_b32 s62, 0x1000
		s_mov_b32 s63, 0
		v_mov_b32_e32 v100, s62
		v_mov_b32_e32 v101, s63
		v_mul_lo_u32 v102, v100, v86
		v_mul_hi_u32 v103, v100, v86
		v_mul_lo_u32 v2, v100, v87
		v_add_u32_e32 v103, v103, v2
		v_mul_lo_u32 v2, v101, v86
		v_add_u32_e32 v103, v103, v2
		v_add_co_u32_e64 v86, vcc, v96, v102
		v_addc_co_u32_e64 v87, vcc, v97, v103, vcc
		v_lshrrev_b64 v[96:97], 3, v[84:85]
		v_mov_b32_e32 v2, 3
		v_and_b32_e32 v84, v96, v2
		v_and_b32_e32 v85, v97, v3
		v_and_b32_e32 v96, v98, v2
		v_and_b32_e32 v97, v99, v3
		v_xor_b32_e32 v100, v84, v96
		v_xor_b32_e32 v101, v85, v97
		s_mov_b32 s62, 16
		s_mov_b32 s63, 0
		v_mov_b32_e32 v84, s62
		v_mov_b32_e32 v85, s63
		v_mul_lo_u32 v96, v84, v100
		v_mul_hi_u32 v97, v84, v100
		v_mul_lo_u32 v2, v84, v101
		v_add_u32_e32 v97, v97, v2
		v_mul_lo_u32 v2, v85, v100
		v_add_u32_e32 v97, v97, v2
		v_add_co_u32_e64 v100, vcc, v86, v96
		v_addc_co_u32_e64 v101, vcc, v87, v97, vcc
		v_accvgpr_write_b32 a2, v100
		v_accvgpr_write_b32 a3, v101
		s_mov_b32 s62, 0x80
		s_mov_b32 s63, 0
		v_mov_b32_e32 v86, s62
		v_mov_b32_e32 v87, s63
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v78, 0x22000, v2
		ds_write_b32 v78, v86
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v78, 0x22400, v2
		ds_write_b32 v78, v87
		v_mov_b32_e32 v2, 0x40000
		v_add_co_u32_e64 v86, vcc, v82, v2
		v_addc_co_u32_e64 v87, vcc, v83, 0, vcc
		v_add_co_u32_e64 v100, vcc, v86, v94
		v_addc_co_u32_e64 v101, vcc, v87, v95, vcc
		v_add_co_u32_e64 v86, vcc, v100, v102
		v_addc_co_u32_e64 v87, vcc, v101, v103, vcc
		v_add_co_u32_e64 v100, vcc, v86, v96
		v_addc_co_u32_e64 v101, vcc, v87, v97, vcc
		v_lshlrev_b32_e32 v78, 2, v0
		v_add_u32_e32 v81, 0x22800, v78
		ds_write_b32 v81, v100
		v_lshlrev_b32_e32 v78, 2, v0
		v_add_u32_e32 v81, 0x22c00, v78
		ds_write_b32 v81, v101
		v_mov_b32_e32 v78, 0x80000
		v_add_co_u32_e64 v86, vcc, v82, v78
		v_addc_co_u32_e64 v87, vcc, v83, 0, vcc
		v_add_co_u32_e64 v100, vcc, v86, v94
		v_addc_co_u32_e64 v101, vcc, v87, v95, vcc
		v_add_co_u32_e64 v86, vcc, v100, v102
		v_addc_co_u32_e64 v87, vcc, v101, v103, vcc
		v_add_co_u32_e64 v100, vcc, v86, v96
		v_addc_co_u32_e64 v101, vcc, v87, v97, vcc
		v_lshlrev_b32_e32 v81, 2, v0
		v_add_u32_e32 v86, 0x23000, v81
		ds_write_b32 v86, v100
		v_lshlrev_b32_e32 v81, 2, v0
		v_add_u32_e32 v86, 0x23400, v81
		ds_write_b32 v86, v101
		v_mov_b32_e32 v81, 0xc0000
		v_add_co_u32_e64 v86, vcc, v82, v81
		v_addc_co_u32_e64 v87, vcc, v83, 0, vcc
		v_add_co_u32_e64 v100, vcc, v86, v94
		v_addc_co_u32_e64 v101, vcc, v87, v95, vcc
		v_add_co_u32_e64 v86, vcc, v100, v102
		v_addc_co_u32_e64 v87, vcc, v101, v103, vcc
		v_add_co_u32_e64 v100, vcc, v86, v96
		v_addc_co_u32_e64 v101, vcc, v87, v97, vcc
		v_lshlrev_b32_e32 v86, 2, v0
		v_add_u32_e32 v87, 0x23800, v86
		ds_write_b32 v87, v100
		v_lshlrev_b32_e32 v86, 2, v0
		v_add_u32_e32 v87, 0x23c00, v86
		ds_write_b32 v87, v101
		v_mov_b32_e32 v86, 64
		v_add_co_u32_e64 v100, vcc, v82, v86
		v_addc_co_u32_e64 v101, vcc, v83, 0, vcc
		v_add_co_u32_e64 v104, vcc, v100, v94
		v_addc_co_u32_e64 v105, vcc, v101, v95, vcc
		v_add_co_u32_e64 v100, vcc, v104, v102
		v_addc_co_u32_e64 v101, vcc, v105, v103, vcc
		v_add_co_u32_e64 v104, vcc, v100, v96
		v_addc_co_u32_e64 v105, vcc, v101, v97, vcc
		v_lshlrev_b32_e32 v87, 2, v0
		v_add_u32_e32 v100, 0x24000, v87
		ds_write_b32 v100, v104
		v_lshlrev_b32_e32 v87, 2, v0
		v_add_u32_e32 v100, 0x24400, v87
		ds_write_b32 v100, v105
		v_mov_b32_e32 v87, 0x40040
		v_add_co_u32_e64 v100, vcc, v82, v87
		v_addc_co_u32_e64 v101, vcc, v83, 0, vcc
		v_add_co_u32_e64 v104, vcc, v100, v94
		v_addc_co_u32_e64 v105, vcc, v101, v95, vcc
		v_add_co_u32_e64 v100, vcc, v104, v102
		v_addc_co_u32_e64 v101, vcc, v105, v103, vcc
		v_add_co_u32_e64 v104, vcc, v100, v96
		v_addc_co_u32_e64 v105, vcc, v101, v97, vcc
		v_lshlrev_b32_e32 v100, 2, v0
		v_add_u32_e32 v101, 0x24800, v100
		ds_write_b32 v101, v104
		v_lshlrev_b32_e32 v100, 2, v0
		v_add_u32_e32 v101, 0x24c00, v100
		ds_write_b32 v101, v105
		v_mov_b32_e32 v100, 0x80040
		v_add_co_u32_e64 v104, vcc, v82, v100
		v_addc_co_u32_e64 v105, vcc, v83, 0, vcc
		v_add_co_u32_e64 v106, vcc, v104, v94
		v_addc_co_u32_e64 v107, vcc, v105, v95, vcc
		v_add_co_u32_e64 v104, vcc, v106, v102
		v_addc_co_u32_e64 v105, vcc, v107, v103, vcc
		v_add_co_u32_e64 v106, vcc, v104, v96
		v_addc_co_u32_e64 v107, vcc, v105, v97, vcc
		v_lshlrev_b32_e32 v101, 2, v0
		v_add_u32_e32 v104, 0x25000, v101
		ds_write_b32 v104, v106
		v_lshlrev_b32_e32 v101, 2, v0
		v_add_u32_e32 v104, 0x25400, v101
		ds_write_b32 v104, v107
		v_mov_b32_e32 v101, 0xc0040
		v_add_co_u32_e64 v104, vcc, v82, v101
		v_addc_co_u32_e64 v105, vcc, v83, 0, vcc
		v_add_co_u32_e64 v106, vcc, v104, v94
		v_addc_co_u32_e64 v107, vcc, v105, v95, vcc
		v_add_co_u32_e64 v104, vcc, v106, v102
		v_addc_co_u32_e64 v105, vcc, v107, v103, vcc
		v_add_co_u32_e64 v106, vcc, v104, v96
		v_addc_co_u32_e64 v107, vcc, v105, v97, vcc
		v_lshlrev_b32_e32 v104, 2, v0
		v_add_u32_e32 v105, 0x25800, v104
		ds_write_b32 v105, v106
		v_lshlrev_b32_e32 v104, 2, v0
		v_add_u32_e32 v105, 0x25c00, v104
		ds_write_b32 v105, v107
		v_mov_b32_e32 v104, s14
		v_mov_b32_e32 v105, 0
		v_mul_lo_u32 v106, v4, v104
		v_mul_hi_u32 v107, v4, v104
		v_mul_lo_u32 v108, v4, v105
		v_add_u32_e32 v107, v107, v108
		v_mul_lo_u32 v108, v5, v104
		v_add_u32_e32 v107, v107, v108
		v_add_co_u32_e64 v4, vcc, v106, v94
		v_addc_co_u32_e64 v5, vcc, v107, v95, vcc
		v_add_co_u32_e64 v108, vcc, v4, v102
		v_addc_co_u32_e64 v109, vcc, v5, v103, vcc
		v_add_co_u32_e64 v4, vcc, v108, v96
		v_addc_co_u32_e64 v5, vcc, v109, v97, vcc
		v_lshlrev_b32_e32 v108, 2, v0
		v_add_u32_e32 v109, 0x26000, v108
		ds_write_b32 v109, v4
		v_lshlrev_b32_e32 v4, 2, v0
		v_add_u32_e32 v108, 0x26400, v4
		ds_write_b32 v108, v5
		v_add_co_u32_e64 v4, vcc, v106, v2
		v_addc_co_u32_e64 v5, vcc, v107, 0, vcc
		v_add_co_u32_e64 v108, vcc, v4, v94
		v_addc_co_u32_e64 v109, vcc, v5, v95, vcc
		v_add_co_u32_e64 v4, vcc, v108, v102
		v_addc_co_u32_e64 v5, vcc, v109, v103, vcc
		v_add_co_u32_e64 v108, vcc, v4, v96
		v_addc_co_u32_e64 v109, vcc, v5, v97, vcc
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v4, 0x26800, v2
		ds_write_b32 v4, v108
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v4, 0x26c00, v2
		ds_write_b32 v4, v109
		v_add_co_u32_e64 v4, vcc, v106, v78
		v_addc_co_u32_e64 v5, vcc, v107, 0, vcc
		v_add_co_u32_e64 v108, vcc, v4, v94
		v_addc_co_u32_e64 v109, vcc, v5, v95, vcc
		v_add_co_u32_e64 v4, vcc, v108, v102
		v_addc_co_u32_e64 v5, vcc, v109, v103, vcc
		v_add_co_u32_e64 v108, vcc, v4, v96
		v_addc_co_u32_e64 v109, vcc, v5, v97, vcc
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v4, 0x27000, v2
		ds_write_b32 v4, v108
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v4, 0x27400, v2
		ds_write_b32 v4, v109
		v_add_co_u32_e64 v4, vcc, v106, v81
		v_addc_co_u32_e64 v5, vcc, v107, 0, vcc
		v_add_co_u32_e64 v108, vcc, v4, v94
		v_addc_co_u32_e64 v109, vcc, v5, v95, vcc
		v_add_co_u32_e64 v4, vcc, v108, v102
		v_addc_co_u32_e64 v5, vcc, v109, v103, vcc
		v_add_co_u32_e64 v108, vcc, v4, v96
		v_addc_co_u32_e64 v109, vcc, v5, v97, vcc
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v4, 0x27800, v2
		ds_write_b32 v4, v108
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v4, 0x27c00, v2
		ds_write_b32 v4, v109
		v_add_co_u32_e64 v4, vcc, v106, v86
		v_addc_co_u32_e64 v5, vcc, v107, 0, vcc
		v_add_co_u32_e64 v108, vcc, v4, v94
		v_addc_co_u32_e64 v109, vcc, v5, v95, vcc
		v_add_co_u32_e64 v4, vcc, v108, v102
		v_addc_co_u32_e64 v5, vcc, v109, v103, vcc
		v_add_co_u32_e64 v108, vcc, v4, v96
		v_addc_co_u32_e64 v109, vcc, v5, v97, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v108, s61
		scratch_store_dword off, v109, s61 offset:4
		v_add_co_u32_e64 v4, vcc, v106, v87
		v_addc_co_u32_e64 v5, vcc, v107, 0, vcc
		v_add_co_u32_e64 v86, vcc, v4, v94
		v_addc_co_u32_e64 v87, vcc, v5, v95, vcc
		v_add_co_u32_e64 v4, vcc, v86, v102
		v_addc_co_u32_e64 v5, vcc, v87, v103, vcc
		v_add_co_u32_e64 v86, vcc, v4, v96
		v_addc_co_u32_e64 v87, vcc, v5, v97, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v86, s61 offset:8
		scratch_store_dword off, v87, s61 offset:12
		v_add_co_u32_e64 v4, vcc, v106, v100
		v_addc_co_u32_e64 v5, vcc, v107, 0, vcc
		v_add_co_u32_e64 v86, vcc, v4, v94
		v_addc_co_u32_e64 v87, vcc, v5, v95, vcc
		v_add_co_u32_e64 v4, vcc, v86, v102
		v_addc_co_u32_e64 v5, vcc, v87, v103, vcc
		v_add_co_u32_e64 v86, vcc, v4, v96
		v_addc_co_u32_e64 v87, vcc, v5, v97, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v86, s61 offset:16
		scratch_store_dword off, v87, s61 offset:20
		v_add_co_u32_e64 v4, vcc, v106, v101
		v_addc_co_u32_e64 v5, vcc, v107, 0, vcc
		v_add_co_u32_e64 v86, vcc, v4, v94
		v_addc_co_u32_e64 v87, vcc, v5, v95, vcc
		v_add_co_u32_e64 v4, vcc, v86, v102
		v_addc_co_u32_e64 v5, vcc, v87, v103, vcc
		v_add_co_u32_e64 v86, vcc, v4, v96
		v_addc_co_u32_e64 v87, vcc, v5, v97, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v86, s61 offset:24
		scratch_store_dword off, v87, s61 offset:28
		v_mul_lo_u32 v4, v92, v104
		v_mul_hi_u32 v5, v92, v104
		v_mul_lo_u32 v2, v92, v105
		v_add_u32_e32 v5, v5, v2
		v_mul_lo_u32 v2, v93, v104
		v_add_u32_e32 v5, v5, v2
		v_add_co_u32_e64 v86, vcc, v82, v4
		v_addc_co_u32_e64 v87, vcc, v83, v5, vcc
		v_lshrrev_b64 v[92:93], 7, v[88:89]
		s_mov_b32 s62, 0x400
		s_mov_b32 s63, 0
		v_mov_b32_e32 v88, s62
		v_mov_b32_e32 v89, s63
		v_mul_lo_u32 v100, v88, v92
		v_mul_hi_u32 v101, v88, v92
		v_mul_lo_u32 v2, v88, v93
		v_add_u32_e32 v101, v101, v2
		v_mul_lo_u32 v2, v89, v92
		v_add_u32_e32 v101, v101, v2
		v_add_co_u32_e64 v92, vcc, v86, v100
		v_addc_co_u32_e64 v93, vcc, v87, v101, vcc
		v_mul_lo_u32 v104, v84, v98
		v_mul_hi_u32 v105, v84, v98
		v_mul_lo_u32 v2, v84, v99
		v_add_u32_e32 v105, v105, v2
		v_mul_lo_u32 v2, v85, v98
		v_add_u32_e32 v105, v105, v2
		v_add_co_u32_e64 v84, vcc, v92, v104
		v_addc_co_u32_e64 v85, vcc, v93, v105, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v84, s61 offset:32
		scratch_store_dword off, v85, s61 offset:36
		s_mov_b32 s62, 0x800
		s_mov_b32 s63, 0
		v_mov_b32_e32 v84, s62
		v_mov_b32_e32 v85, s63
		s_mov_b32 s61, 0
		scratch_store_dword off, v84, s61 offset:40
		scratch_store_dword off, v85, s61 offset:44
		v_add_co_u32_e64 v84, vcc, v86, v104
		v_addc_co_u32_e64 v85, vcc, v87, v105, vcc
		v_mov_b32_e32 v2, 1
		v_and_b32_e32 v86, v90, v2
		v_and_b32_e32 v87, v91, v3
		v_mul_lo_u32 v2, v88, v86
		v_mul_hi_u32 v3, v88, v86
		v_mul_lo_u32 v78, v88, v87
		v_add_u32_e32 v3, v3, v78
		v_mul_lo_u32 v78, v89, v86
		v_add_u32_e32 v3, v3, v78
		v_add_co_u32_e64 v86, vcc, v84, v2
		v_addc_co_u32_e64 v87, vcc, v85, v3, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v86, s61 offset:48
		scratch_store_dword off, v87, s61 offset:52
		v_mov_b32_e32 v78, 0x80
		v_add_co_u32_e64 v84, vcc, v82, v78
		v_addc_co_u32_e64 v85, vcc, v83, 0, vcc
		v_add_co_u32_e64 v86, vcc, v84, v94
		v_addc_co_u32_e64 v87, vcc, v85, v95, vcc
		v_add_co_u32_e64 v84, vcc, v86, v102
		v_addc_co_u32_e64 v85, vcc, v87, v103, vcc
		v_add_co_u32_e64 v86, vcc, v84, v96
		v_addc_co_u32_e64 v87, vcc, v85, v97, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v86, s61 offset:56
		scratch_store_dword off, v87, s61 offset:60
		v_mov_b32_e32 v81, 0x40080
		v_add_co_u32_e64 v84, vcc, v82, v81
		v_addc_co_u32_e64 v85, vcc, v83, 0, vcc
		v_add_co_u32_e64 v86, vcc, v84, v94
		v_addc_co_u32_e64 v87, vcc, v85, v95, vcc
		v_add_co_u32_e64 v84, vcc, v86, v102
		v_addc_co_u32_e64 v85, vcc, v87, v103, vcc
		v_add_co_u32_e64 v86, vcc, v84, v96
		v_addc_co_u32_e64 v87, vcc, v85, v97, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v86, s61 offset:64
		scratch_store_dword off, v87, s61 offset:68
		v_mov_b32_e32 v84, 0x80080
		v_add_co_u32_e64 v86, vcc, v82, v84
		v_addc_co_u32_e64 v87, vcc, v83, 0, vcc
		v_add_co_u32_e64 v88, vcc, v86, v94
		v_addc_co_u32_e64 v89, vcc, v87, v95, vcc
		v_add_co_u32_e64 v86, vcc, v88, v102
		v_addc_co_u32_e64 v87, vcc, v89, v103, vcc
		v_add_co_u32_e64 v88, vcc, v86, v96
		v_addc_co_u32_e64 v89, vcc, v87, v97, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v88, s61 offset:72
		scratch_store_dword off, v89, s61 offset:76
		v_mov_b32_e32 v85, 0xc0080
		v_add_co_u32_e64 v86, vcc, v82, v85
		v_addc_co_u32_e64 v87, vcc, v83, 0, vcc
		v_add_co_u32_e64 v88, vcc, v86, v94
		v_addc_co_u32_e64 v89, vcc, v87, v95, vcc
		v_add_co_u32_e64 v86, vcc, v88, v102
		v_addc_co_u32_e64 v87, vcc, v89, v103, vcc
		v_add_co_u32_e64 v88, vcc, v86, v96
		v_addc_co_u32_e64 v89, vcc, v87, v97, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v88, s61 offset:80
		scratch_store_dword off, v89, s61 offset:84
		v_mov_b32_e32 v86, 0xc0
		v_add_co_u32_e64 v88, vcc, v82, v86
		v_addc_co_u32_e64 v89, vcc, v83, 0, vcc
		v_add_co_u32_e64 v90, vcc, v88, v94
		v_addc_co_u32_e64 v91, vcc, v89, v95, vcc
		v_add_co_u32_e64 v88, vcc, v90, v102
		v_addc_co_u32_e64 v89, vcc, v91, v103, vcc
		v_add_co_u32_e64 v90, vcc, v88, v96
		v_addc_co_u32_e64 v91, vcc, v89, v97, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v90, s61 offset:88
		scratch_store_dword off, v91, s61 offset:92
		v_mov_b32_e32 v87, 0x400c0
		v_add_co_u32_e64 v88, vcc, v82, v87
		v_addc_co_u32_e64 v89, vcc, v83, 0, vcc
		v_add_co_u32_e64 v90, vcc, v88, v94
		v_addc_co_u32_e64 v91, vcc, v89, v95, vcc
		v_add_co_u32_e64 v88, vcc, v90, v102
		v_addc_co_u32_e64 v89, vcc, v91, v103, vcc
		v_add_co_u32_e64 v90, vcc, v88, v96
		v_addc_co_u32_e64 v91, vcc, v89, v97, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v90, s61 offset:96
		scratch_store_dword off, v91, s61 offset:100
		v_mov_b32_e32 v88, 0x800c0
		v_add_co_u32_e64 v90, vcc, v82, v88
		v_addc_co_u32_e64 v91, vcc, v83, 0, vcc
		v_add_co_u32_e64 v92, vcc, v90, v94
		v_addc_co_u32_e64 v93, vcc, v91, v95, vcc
		v_add_co_u32_e64 v90, vcc, v92, v102
		v_addc_co_u32_e64 v91, vcc, v93, v103, vcc
		v_add_co_u32_e64 v92, vcc, v90, v96
		v_addc_co_u32_e64 v93, vcc, v91, v97, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v92, s61 offset:104
		scratch_store_dword off, v93, s61 offset:108
		v_mov_b32_e32 v89, 0xc00c0
		v_add_co_u32_e64 v90, vcc, v82, v89
		v_addc_co_u32_e64 v91, vcc, v83, 0, vcc
		v_add_co_u32_e64 v92, vcc, v90, v94
		v_addc_co_u32_e64 v93, vcc, v91, v95, vcc
		v_add_co_u32_e64 v90, vcc, v92, v102
		v_addc_co_u32_e64 v91, vcc, v93, v103, vcc
		v_add_co_u32_e64 v92, vcc, v90, v96
		v_addc_co_u32_e64 v93, vcc, v91, v97, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v92, s61 offset:112
		scratch_store_dword off, v93, s61 offset:116
		v_add_co_u32_e64 v90, vcc, v106, v78
		v_addc_co_u32_e64 v91, vcc, v107, 0, vcc
		v_add_co_u32_e64 v92, vcc, v90, v94
		v_addc_co_u32_e64 v93, vcc, v91, v95, vcc
		v_add_co_u32_e64 v90, vcc, v92, v102
		v_addc_co_u32_e64 v91, vcc, v93, v103, vcc
		v_add_co_u32_e64 v92, vcc, v90, v96
		v_addc_co_u32_e64 v93, vcc, v91, v97, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v92, s61 offset:120
		scratch_store_dword off, v93, s61 offset:124
		v_add_co_u32_e64 v90, vcc, v106, v81
		v_addc_co_u32_e64 v91, vcc, v107, 0, vcc
		v_add_co_u32_e64 v92, vcc, v90, v94
		v_addc_co_u32_e64 v93, vcc, v91, v95, vcc
		v_add_co_u32_e64 v90, vcc, v92, v102
		v_addc_co_u32_e64 v91, vcc, v93, v103, vcc
		v_add_co_u32_e64 v92, vcc, v90, v96
		v_addc_co_u32_e64 v93, vcc, v91, v97, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v92, s61 offset:128
		scratch_store_dword off, v93, s61 offset:132
		v_add_co_u32_e64 v90, vcc, v106, v84
		v_addc_co_u32_e64 v91, vcc, v107, 0, vcc
		v_add_co_u32_e64 v92, vcc, v90, v94
		v_addc_co_u32_e64 v93, vcc, v91, v95, vcc
		v_add_co_u32_e64 v90, vcc, v92, v102
		v_addc_co_u32_e64 v91, vcc, v93, v103, vcc
		v_add_co_u32_e64 v92, vcc, v90, v96
		v_addc_co_u32_e64 v93, vcc, v91, v97, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v92, s61 offset:136
		scratch_store_dword off, v93, s61 offset:140
		v_add_co_u32_e64 v90, vcc, v106, v85
		v_addc_co_u32_e64 v91, vcc, v107, 0, vcc
		v_add_co_u32_e64 v84, vcc, v90, v94
		v_addc_co_u32_e64 v85, vcc, v91, v95, vcc
		v_add_co_u32_e64 v90, vcc, v84, v102
		v_addc_co_u32_e64 v91, vcc, v85, v103, vcc
		v_add_co_u32_e64 v84, vcc, v90, v96
		v_addc_co_u32_e64 v85, vcc, v91, v97, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v84, s61 offset:144
		scratch_store_dword off, v85, s61 offset:148
		v_add_co_u32_e64 v84, vcc, v106, v86
		v_addc_co_u32_e64 v85, vcc, v107, 0, vcc
		v_add_co_u32_e64 v90, vcc, v84, v94
		v_addc_co_u32_e64 v91, vcc, v85, v95, vcc
		v_add_co_u32_e64 v84, vcc, v90, v102
		v_addc_co_u32_e64 v85, vcc, v91, v103, vcc
		v_add_co_u32_e64 v90, vcc, v84, v96
		v_addc_co_u32_e64 v91, vcc, v85, v97, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v90, s61 offset:152
		scratch_store_dword off, v91, s61 offset:156
		v_add_co_u32_e64 v84, vcc, v106, v87
		v_addc_co_u32_e64 v85, vcc, v107, 0, vcc
		v_add_co_u32_e64 v86, vcc, v84, v94
		v_addc_co_u32_e64 v87, vcc, v85, v95, vcc
		v_add_co_u32_e64 v84, vcc, v86, v102
		v_addc_co_u32_e64 v85, vcc, v87, v103, vcc
		v_add_co_u32_e64 v86, vcc, v84, v96
		v_addc_co_u32_e64 v87, vcc, v85, v97, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v86, s61 offset:160
		scratch_store_dword off, v87, s61 offset:164
		v_add_co_u32_e64 v84, vcc, v106, v88
		v_addc_co_u32_e64 v85, vcc, v107, 0, vcc
		v_add_co_u32_e64 v86, vcc, v84, v94
		v_addc_co_u32_e64 v87, vcc, v85, v95, vcc
		v_add_co_u32_e64 v84, vcc, v86, v102
		v_addc_co_u32_e64 v85, vcc, v87, v103, vcc
		v_add_co_u32_e64 v86, vcc, v84, v96
		v_addc_co_u32_e64 v87, vcc, v85, v97, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v86, s61 offset:168
		scratch_store_dword off, v87, s61 offset:172
		v_add_co_u32_e64 v84, vcc, v106, v89
		v_addc_co_u32_e64 v85, vcc, v107, 0, vcc
		v_add_co_u32_e64 v86, vcc, v84, v94
		v_addc_co_u32_e64 v87, vcc, v85, v95, vcc
		v_add_co_u32_e64 v84, vcc, v86, v102
		v_addc_co_u32_e64 v85, vcc, v87, v103, vcc
		v_add_co_u32_e64 v86, vcc, v84, v96
		v_addc_co_u32_e64 v87, vcc, v85, v97, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v86, s61 offset:176
		scratch_store_dword off, v87, s61 offset:180
		v_mov_b32_e32 v78, 0x800
		v_add_co_u32_e64 v84, vcc, v82, v78
		v_addc_co_u32_e64 v85, vcc, v83, 0, vcc
		v_add_co_u32_e64 v82, vcc, v84, v4
		v_addc_co_u32_e64 v83, vcc, v85, v5, vcc
		v_add_co_u32_e64 v4, vcc, v82, v100
		v_addc_co_u32_e64 v5, vcc, v83, v101, vcc
		v_add_co_u32_e64 v84, vcc, v4, v104
		v_addc_co_u32_e64 v85, vcc, v5, v105, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v84, s61 offset:184
		scratch_store_dword off, v85, s61 offset:188
		v_add_co_u32_e64 v4, vcc, v82, v104
		v_addc_co_u32_e64 v5, vcc, v83, v105, vcc
		v_add_co_u32_e64 v82, vcc, v4, v2
		v_addc_co_u32_e64 v83, vcc, v5, v3, vcc
		s_mov_b32 s61, 0
		scratch_store_dword off, v82, s61 offset:192
		scratch_store_dword off, v83, s61 offset:196
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a4, v84
		v_accvgpr_write_b32 a5, v85
		v_accvgpr_write_b32 a6, v86
		v_accvgpr_write_b32 a7, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a8, v84
		v_accvgpr_write_b32 a9, v85
		v_accvgpr_write_b32 a10, v86
		v_accvgpr_write_b32 a11, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a12, v84
		v_accvgpr_write_b32 a13, v85
		v_accvgpr_write_b32 a14, v86
		v_accvgpr_write_b32 a15, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a16, v84
		v_accvgpr_write_b32 a17, v85
		v_accvgpr_write_b32 a18, v86
		v_accvgpr_write_b32 a19, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a20, v84
		v_accvgpr_write_b32 a21, v85
		v_accvgpr_write_b32 a22, v86
		v_accvgpr_write_b32 a23, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a24, v84
		v_accvgpr_write_b32 a25, v85
		v_accvgpr_write_b32 a26, v86
		v_accvgpr_write_b32 a27, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a28, v84
		v_accvgpr_write_b32 a29, v85
		v_accvgpr_write_b32 a30, v86
		v_accvgpr_write_b32 a31, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a32, v84
		v_accvgpr_write_b32 a33, v85
		v_accvgpr_write_b32 a34, v86
		v_accvgpr_write_b32 a35, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a36, v84
		v_accvgpr_write_b32 a37, v85
		v_accvgpr_write_b32 a38, v86
		v_accvgpr_write_b32 a39, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a40, v84
		v_accvgpr_write_b32 a41, v85
		v_accvgpr_write_b32 a42, v86
		v_accvgpr_write_b32 a43, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a44, v84
		v_accvgpr_write_b32 a45, v85
		v_accvgpr_write_b32 a46, v86
		v_accvgpr_write_b32 a47, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a48, v84
		v_accvgpr_write_b32 a49, v85
		v_accvgpr_write_b32 a50, v86
		v_accvgpr_write_b32 a51, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a52, v84
		v_accvgpr_write_b32 a53, v85
		v_accvgpr_write_b32 a54, v86
		v_accvgpr_write_b32 a55, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a56, v84
		v_accvgpr_write_b32 a57, v85
		v_accvgpr_write_b32 a58, v86
		v_accvgpr_write_b32 a59, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a60, v84
		v_accvgpr_write_b32 a61, v85
		v_accvgpr_write_b32 a62, v86
		v_accvgpr_write_b32 a63, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a64, v84
		v_accvgpr_write_b32 a65, v85
		v_accvgpr_write_b32 a66, v86
		v_accvgpr_write_b32 a67, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a68, v84
		v_accvgpr_write_b32 a69, v85
		v_accvgpr_write_b32 a70, v86
		v_accvgpr_write_b32 a71, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a72, v84
		v_accvgpr_write_b32 a73, v85
		v_accvgpr_write_b32 a74, v86
		v_accvgpr_write_b32 a75, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a76, v84
		v_accvgpr_write_b32 a77, v85
		v_accvgpr_write_b32 a78, v86
		v_accvgpr_write_b32 a79, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a80, v84
		v_accvgpr_write_b32 a81, v85
		v_accvgpr_write_b32 a82, v86
		v_accvgpr_write_b32 a83, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a84, v84
		v_accvgpr_write_b32 a85, v85
		v_accvgpr_write_b32 a86, v86
		v_accvgpr_write_b32 a87, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a88, v84
		v_accvgpr_write_b32 a89, v85
		v_accvgpr_write_b32 a90, v86
		v_accvgpr_write_b32 a91, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a92, v84
		v_accvgpr_write_b32 a93, v85
		v_accvgpr_write_b32 a94, v86
		v_accvgpr_write_b32 a95, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a96, v84
		v_accvgpr_write_b32 a97, v85
		v_accvgpr_write_b32 a98, v86
		v_accvgpr_write_b32 a99, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a100, v84
		v_accvgpr_write_b32 a101, v85
		v_accvgpr_write_b32 a102, v86
		v_accvgpr_write_b32 a103, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a104, v84
		v_accvgpr_write_b32 a105, v85
		v_accvgpr_write_b32 a106, v86
		v_accvgpr_write_b32 a107, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a108, v84
		v_accvgpr_write_b32 a109, v85
		v_accvgpr_write_b32 a110, v86
		v_accvgpr_write_b32 a111, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a112, v84
		v_accvgpr_write_b32 a113, v85
		v_accvgpr_write_b32 a114, v86
		v_accvgpr_write_b32 a115, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a116, v84
		v_accvgpr_write_b32 a117, v85
		v_accvgpr_write_b32 a118, v86
		v_accvgpr_write_b32 a119, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a120, v84
		v_accvgpr_write_b32 a121, v85
		v_accvgpr_write_b32 a122, v86
		v_accvgpr_write_b32 a123, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a124, v84
		v_accvgpr_write_b32 a125, v85
		v_accvgpr_write_b32 a126, v86
		v_accvgpr_write_b32 a127, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a128, v84
		v_accvgpr_write_b32 a129, v85
		v_accvgpr_write_b32 a130, v86
		v_accvgpr_write_b32 a131, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a132, v84
		v_accvgpr_write_b32 a133, v85
		v_accvgpr_write_b32 a134, v86
		v_accvgpr_write_b32 a135, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a136, v84
		v_accvgpr_write_b32 a137, v85
		v_accvgpr_write_b32 a138, v86
		v_accvgpr_write_b32 a139, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a140, v84
		v_accvgpr_write_b32 a141, v85
		v_accvgpr_write_b32 a142, v86
		v_accvgpr_write_b32 a143, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a144, v84
		v_accvgpr_write_b32 a145, v85
		v_accvgpr_write_b32 a146, v86
		v_accvgpr_write_b32 a147, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a148, v84
		v_accvgpr_write_b32 a149, v85
		v_accvgpr_write_b32 a150, v86
		v_accvgpr_write_b32 a151, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a152, v84
		v_accvgpr_write_b32 a153, v85
		v_accvgpr_write_b32 a154, v86
		v_accvgpr_write_b32 a155, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a156, v84
		v_accvgpr_write_b32 a157, v85
		v_accvgpr_write_b32 a158, v86
		v_accvgpr_write_b32 a159, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a160, v84
		v_accvgpr_write_b32 a161, v85
		v_accvgpr_write_b32 a162, v86
		v_accvgpr_write_b32 a163, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a164, v84
		v_accvgpr_write_b32 a165, v85
		v_accvgpr_write_b32 a166, v86
		v_accvgpr_write_b32 a167, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a168, v84
		v_accvgpr_write_b32 a169, v85
		v_accvgpr_write_b32 a170, v86
		v_accvgpr_write_b32 a171, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a172, v84
		v_accvgpr_write_b32 a173, v85
		v_accvgpr_write_b32 a174, v86
		v_accvgpr_write_b32 a175, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a176, v84
		v_accvgpr_write_b32 a177, v85
		v_accvgpr_write_b32 a178, v86
		v_accvgpr_write_b32 a179, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a180, v84
		v_accvgpr_write_b32 a181, v85
		v_accvgpr_write_b32 a182, v86
		v_accvgpr_write_b32 a183, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a184, v84
		v_accvgpr_write_b32 a185, v85
		v_accvgpr_write_b32 a186, v86
		v_accvgpr_write_b32 a187, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a188, v84
		v_accvgpr_write_b32 a189, v85
		v_accvgpr_write_b32 a190, v86
		v_accvgpr_write_b32 a191, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a192, v84
		v_accvgpr_write_b32 a193, v85
		v_accvgpr_write_b32 a194, v86
		v_accvgpr_write_b32 a195, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a196, v84
		v_accvgpr_write_b32 a197, v85
		v_accvgpr_write_b32 a198, v86
		v_accvgpr_write_b32 a199, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a200, v84
		v_accvgpr_write_b32 a201, v85
		v_accvgpr_write_b32 a202, v86
		v_accvgpr_write_b32 a203, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a204, v84
		v_accvgpr_write_b32 a205, v85
		v_accvgpr_write_b32 a206, v86
		v_accvgpr_write_b32 a207, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a208, v84
		v_accvgpr_write_b32 a209, v85
		v_accvgpr_write_b32 a210, v86
		v_accvgpr_write_b32 a211, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a212, v84
		v_accvgpr_write_b32 a213, v85
		v_accvgpr_write_b32 a214, v86
		v_accvgpr_write_b32 a215, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a216, v84
		v_accvgpr_write_b32 a217, v85
		v_accvgpr_write_b32 a218, v86
		v_accvgpr_write_b32 a219, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a220, v84
		v_accvgpr_write_b32 a221, v85
		v_accvgpr_write_b32 a222, v86
		v_accvgpr_write_b32 a223, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a224, v84
		v_accvgpr_write_b32 a225, v85
		v_accvgpr_write_b32 a226, v86
		v_accvgpr_write_b32 a227, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a228, v84
		v_accvgpr_write_b32 a229, v85
		v_accvgpr_write_b32 a230, v86
		v_accvgpr_write_b32 a231, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a232, v84
		v_accvgpr_write_b32 a233, v85
		v_accvgpr_write_b32 a234, v86
		v_accvgpr_write_b32 a235, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a236, v84
		v_accvgpr_write_b32 a237, v85
		v_accvgpr_write_b32 a238, v86
		v_accvgpr_write_b32 a239, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a240, v84
		v_accvgpr_write_b32 a241, v85
		v_accvgpr_write_b32 a242, v86
		v_accvgpr_write_b32 a243, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a244, v84
		v_accvgpr_write_b32 a245, v85
		v_accvgpr_write_b32 a246, v86
		v_accvgpr_write_b32 a247, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a248, v84
		v_accvgpr_write_b32 a249, v85
		v_accvgpr_write_b32 a250, v86
		v_accvgpr_write_b32 a251, v87
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_accvgpr_write_b32 a252, v84
		v_accvgpr_write_b32 a253, v85
		v_accvgpr_write_b32 a254, v86
		v_accvgpr_write_b32 a255, v87
.Lwmma_f16_matmul_tiled.loop_head_0:
		v_mov_b32_e32 v2, s60
		v_mov_b32_e32 v3, 0
		v_lshlrev_b32_e32 v4, 2, v0
		v_add_u32_e32 v5, 0x22000, v4
		s_waitcnt lgkmcnt(6)
		ds_read_b32 v4, v5
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v78, 0x22400, v5
		ds_read_b32 v5, v78
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v82, v4, v2
		v_mul_hi_u32 v83, v4, v2
		v_mul_lo_u32 v78, v4, v3
		v_add_u32_e32 v83, v83, v78
		v_mul_lo_u32 v78, v5, v2
		v_add_u32_e32 v83, v83, v78
		v_accvgpr_read_b32 v4, a2
		v_accvgpr_read_b32 v5, a3
		v_add_co_u32_e64 v84, vcc, v4, v82
		v_addc_co_u32_e64 v85, vcc, v5, v83, vcc
		v_lshlrev_b32_e32 v4, 2, v0
		v_add_u32_e32 v5, 0x22800, v4
		ds_read_b32 v4, v5
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v78, 0x22c00, v5
		ds_read_b32 v5, v78
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v86, vcc, v4, v82
		v_addc_co_u32_e64 v87, vcc, v5, v83, vcc
		v_lshlrev_b32_e32 v4, 2, v0
		v_add_u32_e32 v5, 0x23000, v4
		ds_read_b32 v4, v5
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v78, 0x23400, v5
		ds_read_b32 v5, v78
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v88, vcc, v4, v82
		v_addc_co_u32_e64 v89, vcc, v5, v83, vcc
		v_lshlrev_b32_e32 v4, 2, v0
		v_add_u32_e32 v5, 0x23800, v4
		ds_read_b32 v4, v5
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v78, 0x23c00, v5
		ds_read_b32 v5, v78
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v90, vcc, v4, v82
		v_addc_co_u32_e64 v91, vcc, v5, v83, vcc
		v_lshlrev_b32_e32 v4, 2, v0
		v_add_u32_e32 v5, 0x24000, v4
		ds_read_b32 v4, v5
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v78, 0x24400, v5
		ds_read_b32 v5, v78
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v92, vcc, v4, v82
		v_addc_co_u32_e64 v93, vcc, v5, v83, vcc
		v_lshlrev_b32_e32 v4, 2, v0
		v_add_u32_e32 v5, 0x24800, v4
		ds_read_b32 v4, v5
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v78, 0x24c00, v5
		ds_read_b32 v5, v78
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v94, vcc, v4, v82
		v_addc_co_u32_e64 v95, vcc, v5, v83, vcc
		v_lshlrev_b32_e32 v4, 2, v0
		v_add_u32_e32 v5, 0x25000, v4
		ds_read_b32 v4, v5
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v78, 0x25400, v5
		ds_read_b32 v5, v78
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v96, vcc, v4, v82
		v_addc_co_u32_e64 v97, vcc, v5, v83, vcc
		v_lshlrev_b32_e32 v4, 2, v0
		v_add_u32_e32 v5, 0x25800, v4
		ds_read_b32 v4, v5
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v78, 0x25c00, v5
		ds_read_b32 v5, v78
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v98, vcc, v4, v82
		v_addc_co_u32_e64 v99, vcc, v5, v83, vcc
		v_lshlrev_b32_e32 v4, 2, v0
		v_add_u32_e32 v5, 0x26000, v4
		ds_read_b32 v4, v5
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v78, 0x26400, v5
		ds_read_b32 v5, v78
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v100, vcc, v4, v82
		v_addc_co_u32_e64 v101, vcc, v5, v83, vcc
		v_lshlrev_b32_e32 v4, 2, v0
		v_add_u32_e32 v5, 0x26800, v4
		ds_read_b32 v4, v5
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v78, 0x26c00, v5
		ds_read_b32 v5, v78
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v102, vcc, v4, v82
		v_addc_co_u32_e64 v103, vcc, v5, v83, vcc
		v_lshlrev_b32_e32 v4, 2, v0
		v_add_u32_e32 v5, 0x27000, v4
		ds_read_b32 v4, v5
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v78, 0x27400, v5
		ds_read_b32 v5, v78
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v104, vcc, v4, v82
		v_addc_co_u32_e64 v105, vcc, v5, v83, vcc
		v_lshlrev_b32_e32 v4, 2, v0
		v_add_u32_e32 v5, 0x27800, v4
		ds_read_b32 v4, v5
		v_lshlrev_b32_e32 v5, 2, v0
		v_add_u32_e32 v78, 0x27c00, v5
		ds_read_b32 v5, v78
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v106, vcc, v4, v82
		v_addc_co_u32_e64 v107, vcc, v5, v83, vcc
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(48)
		scratch_load_dword v4, off, s61
		scratch_load_dword v5, off, s61 offset:4
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v108, vcc, v4, v82
		v_addc_co_u32_e64 v109, vcc, v5, v83, vcc
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(46)
		scratch_load_dword v4, off, s61 offset:8
		scratch_load_dword v5, off, s61 offset:12
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v110, vcc, v4, v82
		v_addc_co_u32_e64 v111, vcc, v5, v83, vcc
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(44)
		scratch_load_dword v4, off, s61 offset:16
		scratch_load_dword v5, off, s61 offset:20
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v112, vcc, v4, v82
		v_addc_co_u32_e64 v113, vcc, v5, v83, vcc
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(42)
		scratch_load_dword v4, off, s61 offset:24
		scratch_load_dword v5, off, s61 offset:28
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v114, vcc, v4, v82
		v_addc_co_u32_e64 v115, vcc, v5, v83, vcc
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(38)
		scratch_load_dword v4, off, s61 offset:40
		scratch_load_dword v5, off, s61 offset:44
		s_waitcnt vmcnt(0)
		v_mul_lo_u32 v116, v4, v2
		v_mul_hi_u32 v117, v4, v2
		v_mul_lo_u32 v78, v4, v3
		v_add_u32_e32 v117, v117, v78
		v_mul_lo_u32 v78, v5, v2
		v_add_u32_e32 v117, v117, v78
		s_mov_b32 s61, 0
		scratch_load_dword v2, off, s61 offset:32
		scratch_load_dword v3, off, s61 offset:36
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v4, vcc, v2, v116
		v_addc_co_u32_e64 v5, vcc, v3, v117, vcc
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(36)
		scratch_load_dword v2, off, s61 offset:48
		scratch_load_dword v3, off, s61 offset:52
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v118, vcc, v2, v116
		v_addc_co_u32_e64 v119, vcc, v3, v117, vcc
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v120, off, s61 offset:232
		scratch_load_dword v121, off, s61 offset:236
		scratch_load_dword v122, off, s61 offset:240
		scratch_load_dword v123, off, s61 offset:244
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[12:15], v[44:47], v[120:123], v1, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s61, s60, 1
		s_lshl_b32 s62, s61, 16
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 13, v2
		v_add_u32_e32 v2, s62, v3
		v_and_b32_e32 v3, 15, v0
		v_lshlrev_b32_e32 v5, 6, v3
		v_lshlrev_b32_e32 v3, 4, v6
		v_add3_u32 v78, v2, v5, v3
		ds_read_b128 v[124:127], v78 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[12:15], v[48:51], a[4:7], v1, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[128:131], v78 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[12:15], v[52:55], a[8:11], v1, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[132:135], v78 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[12:15], v[56:59], a[12:15], v1, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[136:139], v78 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[12:15], v[60:63], a[16:19], v1, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[140:143], v78 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[12:15], v[64:67], a[20:23], v1, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[144:147], v78 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[12:15], v[68:71], a[24:27], v1, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[148:151], v78 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[12:15], v[72:75], a[28:31], v1, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[152:155], v78 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[16:19], v[44:47], a[32:35], v1, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_and_b32_e32 v2, 15, v0
		v_lshlrev_b32_e32 v3, 6, v2
		v_add_u32_e32 v2, s62, v3
		v_lshlrev_b32_e32 v3, 13, v7
		v_lshlrev_b32_e32 v5, 4, v6
		v_add3_u32 v81, v2, v3, v5
		ds_read_b128 v[156:159], v81 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[16:19], v[48:51], a[36:39], v1, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[160:163], v81 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[16:19], v[52:55], a[40:43], v1, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[164:167], v81 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[16:19], v[56:59], a[44:47], v1, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[168:171], v81 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[16:19], v[60:63], a[48:51], v1, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[172:175], v81 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[16:19], v[64:67], a[52:55], v1, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[176:179], v81 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[16:19], v[68:71], a[56:59], v1, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[180:183], v81 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[16:19], v[72:75], a[60:63], v1, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[184:187], v81 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[20:23], v[44:47], a[64:67], v9, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_nop 0
		buffer_load_dwordx4 v84, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[20:23], v[48:51], a[68:71], v9, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v86, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[20:23], v[52:55], a[72:75], v9, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v88, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[20:23], v[56:59], a[76:79], v9, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v90, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[20:23], v[60:63], a[80:83], v9, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v92, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[20:23], v[64:67], a[84:87], v9, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v94, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[20:23], v[68:71], a[88:91], v9, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v96, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[20:23], v[72:75], a[92:95], v9, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v98, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[24:27], v[44:47], a[96:99], v9, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v100, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[24:27], v[48:51], a[100:103], v9, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v102, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[24:27], v[52:55], a[104:107], v9, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s37
		s_nop 0
		buffer_load_dwordx4 v104, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[24:27], v[56:59], a[108:111], v9, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v106, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[24:27], v[60:63], a[112:115], v9, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v108, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[24:27], v[64:67], a[116:119], v9, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s40
		s_nop 0
		buffer_load_dwordx4 v110, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[24:27], v[68:71], a[120:123], v9, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s41
		s_nop 0
		buffer_load_dwordx4 v112, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[24:27], v[72:75], a[124:127], v9, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s42
		s_nop 0
		buffer_load_dwordx4 v114, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[28:31], v[44:47], a[128:131], v11, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s8, 0x20000
		s_nop 0
		buffer_load_dwordx4 v4, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[28:31], v[48:51], a[132:135], v11, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s44, 0x20000
		s_nop 0
		buffer_load_dwordx4 v118, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[28:31], v[52:55], a[136:139], v11, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		ds_read_b128 v[12:15], v78
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[28:31], v[56:59], a[140:143], v11, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[16:19], v78 offset:1024
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[28:31], v[60:63], a[144:147], v11, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v78 offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[28:31], v[64:67], a[148:151], v11, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v78 offset:3072
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[28:31], v[68:71], a[152:155], v11, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[84:87], v78 offset:4096
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[28:31], v[72:75], a[156:159], v11, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v78 offset:5120
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v88, s62 offset:568
		scratch_store_dword off, v89, s62 offset:572
		scratch_store_dword off, v90, s62 offset:576
		scratch_store_dword off, v91, s62 offset:580
		s_mov_b32 s62, 0
		scratch_store_dword off, v88, s62 offset:584
		scratch_store_dword off, v89, s62 offset:588
		scratch_store_dword off, v90, s62 offset:592
		scratch_store_dword off, v91, s62 offset:596
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[32:35], v[44:47], a[160:163], v11, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v78 offset:6144
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v88, s62 offset:536
		scratch_store_dword off, v89, s62 offset:540
		scratch_store_dword off, v90, s62 offset:544
		scratch_store_dword off, v91, s62 offset:548
		s_mov_b32 s62, 0
		scratch_store_dword off, v88, s62 offset:552
		scratch_store_dword off, v89, s62 offset:556
		scratch_store_dword off, v90, s62 offset:560
		scratch_store_dword off, v91, s62 offset:564
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[32:35], v[48:51], a[164:167], v11, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v78 offset:7168
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v88, s62 offset:504
		scratch_store_dword off, v89, s62 offset:508
		scratch_store_dword off, v90, s62 offset:512
		scratch_store_dword off, v91, s62 offset:516
		s_mov_b32 s62, 0
		scratch_store_dword off, v88, s62 offset:520
		scratch_store_dword off, v89, s62 offset:524
		scratch_store_dword off, v90, s62 offset:528
		scratch_store_dword off, v91, s62 offset:532
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[32:35], v[52:55], a[168:171], v11, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v81 offset:32768
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v88, s62 offset:472
		scratch_store_dword off, v89, s62 offset:476
		scratch_store_dword off, v90, s62 offset:480
		scratch_store_dword off, v91, s62 offset:484
		s_mov_b32 s62, 0
		scratch_store_dword off, v88, s62 offset:488
		scratch_store_dword off, v89, s62 offset:492
		scratch_store_dword off, v90, s62 offset:496
		scratch_store_dword off, v91, s62 offset:500
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[32:35], v[56:59], a[172:175], v11, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v81 offset:33792
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v88, s62 offset:440
		scratch_store_dword off, v89, s62 offset:444
		scratch_store_dword off, v90, s62 offset:448
		scratch_store_dword off, v91, s62 offset:452
		s_mov_b32 s62, 0
		scratch_store_dword off, v88, s62 offset:456
		scratch_store_dword off, v89, s62 offset:460
		scratch_store_dword off, v90, s62 offset:464
		scratch_store_dword off, v91, s62 offset:468
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[32:35], v[60:63], a[176:179], v11, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v81 offset:34816
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v88, s62 offset:408
		scratch_store_dword off, v89, s62 offset:412
		scratch_store_dword off, v90, s62 offset:416
		scratch_store_dword off, v91, s62 offset:420
		s_mov_b32 s62, 0
		scratch_store_dword off, v88, s62 offset:424
		scratch_store_dword off, v89, s62 offset:428
		scratch_store_dword off, v90, s62 offset:432
		scratch_store_dword off, v91, s62 offset:436
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[32:35], v[64:67], a[180:183], v11, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v81 offset:35840
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v88, s62 offset:376
		scratch_store_dword off, v89, s62 offset:380
		scratch_store_dword off, v90, s62 offset:384
		scratch_store_dword off, v91, s62 offset:388
		s_mov_b32 s62, 0
		scratch_store_dword off, v88, s62 offset:392
		scratch_store_dword off, v89, s62 offset:396
		scratch_store_dword off, v90, s62 offset:400
		scratch_store_dword off, v91, s62 offset:404
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[32:35], v[68:71], a[184:187], v11, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v81 offset:36864
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v88, s62 offset:344
		scratch_store_dword off, v89, s62 offset:348
		scratch_store_dword off, v90, s62 offset:352
		scratch_store_dword off, v91, s62 offset:356
		s_mov_b32 s62, 0
		scratch_store_dword off, v88, s62 offset:360
		scratch_store_dword off, v89, s62 offset:364
		scratch_store_dword off, v90, s62 offset:368
		scratch_store_dword off, v91, s62 offset:372
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[32:35], v[72:75], a[188:191], v11, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v81 offset:37888
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v88, s62 offset:312
		scratch_store_dword off, v89, s62 offset:316
		scratch_store_dword off, v90, s62 offset:320
		scratch_store_dword off, v91, s62 offset:324
		s_mov_b32 s62, 0
		scratch_store_dword off, v88, s62 offset:328
		scratch_store_dword off, v89, s62 offset:332
		scratch_store_dword off, v90, s62 offset:336
		scratch_store_dword off, v91, s62 offset:340
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[36:39], v[44:47], a[192:195], v76, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v81 offset:38912
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v88, s62 offset:280
		scratch_store_dword off, v89, s62 offset:284
		scratch_store_dword off, v90, s62 offset:288
		scratch_store_dword off, v91, s62 offset:292
		s_mov_b32 s62, 0
		scratch_store_dword off, v88, s62 offset:296
		scratch_store_dword off, v89, s62 offset:300
		scratch_store_dword off, v90, s62 offset:304
		scratch_store_dword off, v91, s62 offset:308
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[36:39], v[48:51], a[196:199], v76, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v81 offset:39936
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v88, s62 offset:248
		scratch_store_dword off, v89, s62 offset:252
		scratch_store_dword off, v90, s62 offset:256
		scratch_store_dword off, v91, s62 offset:260
		s_mov_b32 s62, 0
		scratch_store_dword off, v88, s62 offset:264
		scratch_store_dword off, v89, s62 offset:268
		scratch_store_dword off, v90, s62 offset:272
		scratch_store_dword off, v91, s62 offset:276
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[36:39], v[52:55], a[200:203], v76, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshl_b32 s62, s61, 12
		s_add_i32 s61, s62, 0x20000
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 10, v2
		v_lshlrev_b32_e32 v2, 2, v8
		v_add3_u32 v4, s61, v3, v2
		ds_read_b32 v2, v4
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s62 offset:228
		ds_read_b32 v2, v4 offset:256
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s62 offset:224
		ds_read_b32 v2, v4 offset:512
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s62 offset:220
		ds_read_b32 v2, v4 offset:768
		s_mov_b32 s62, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s62 offset:216
		v_lshlrev_b32_e32 v2, 10, v7
		v_lshlrev_b32_e32 v3, 2, v8
		v_add3_u32 v4, s61, v3, v2
		ds_read_b32 v2, v4 offset:2048
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s61 offset:212
		ds_read_b32 v2, v4 offset:2304
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s61 offset:208
		ds_read_b32 v2, v4 offset:2560
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s61 offset:204
		ds_read_b32 v2, v4 offset:2816
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s61 offset:200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[36:39], v[56:59], a[204:207], v76, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[36:39], v[60:63], a[208:211], v76, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[36:39], v[64:67], a[212:215], v76, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[36:39], v[68:71], a[216:219], v76, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[36:39], v[72:75], a[220:223], v76, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[40:43], v[44:47], a[224:227], v76, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[40:43], v[48:51], a[228:231], v76, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[40:43], v[52:55], a[232:235], v76, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[40:43], v[56:59], a[236:239], v76, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[40:43], v[60:63], a[240:243], v76, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[40:43], v[64:67], a[244:247], v76, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[40:43], v[68:71], a[248:251], v76, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[40:43], v[72:75], a[252:255], v76, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[124:127], v[156:159], v[120:123], v1, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[124:127], v[160:163], a[4:7], v1, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[124:127], v[164:167], a[8:11], v1, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[124:127], v[168:171], a[12:15], v1, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[124:127], v[172:175], a[16:19], v1, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[124:127], v[176:179], a[20:23], v1, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[124:127], v[180:183], a[24:27], v1, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[124:127], v[184:187], a[28:31], v1, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[128:131], v[156:159], a[32:35], v1, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[128:131], v[160:163], a[36:39], v1, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[128:131], v[164:167], a[40:43], v1, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[128:131], v[168:171], a[44:47], v1, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[128:131], v[172:175], a[48:51], v1, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[128:131], v[176:179], a[52:55], v1, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[128:131], v[180:183], a[56:59], v1, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[128:131], v[184:187], a[60:63], v1, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[132:135], v[156:159], a[64:67], v9, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[132:135], v[160:163], a[68:71], v9, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[132:135], v[164:167], a[72:75], v9, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[132:135], v[168:171], a[76:79], v9, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[132:135], v[172:175], a[80:83], v9, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[132:135], v[176:179], a[84:87], v9, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[132:135], v[180:183], a[88:91], v9, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[132:135], v[184:187], a[92:95], v9, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[136:139], v[156:159], a[96:99], v9, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[136:139], v[160:163], a[100:103], v9, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[136:139], v[164:167], a[104:107], v9, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[136:139], v[168:171], a[108:111], v9, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[136:139], v[172:175], a[112:115], v9, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[136:139], v[176:179], a[116:119], v9, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[136:139], v[180:183], a[120:123], v9, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[136:139], v[184:187], a[124:127], v9, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[140:143], v[156:159], a[128:131], v11, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[140:143], v[160:163], a[132:135], v11, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[140:143], v[164:167], a[136:139], v11, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[140:143], v[168:171], a[140:143], v11, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[140:143], v[172:175], a[144:147], v11, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[140:143], v[176:179], a[148:151], v11, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[140:143], v[180:183], a[152:155], v11, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[140:143], v[184:187], a[156:159], v11, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[144:147], v[156:159], a[160:163], v11, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[144:147], v[160:163], a[164:167], v11, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[144:147], v[164:167], a[168:171], v11, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[144:147], v[168:171], a[172:175], v11, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[144:147], v[172:175], a[176:179], v11, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[144:147], v[176:179], a[180:183], v11, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[144:147], v[180:183], a[184:187], v11, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[144:147], v[184:187], a[188:191], v11, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[148:151], v[156:159], a[192:195], v76, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[148:151], v[160:163], a[196:199], v76, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[148:151], v[164:167], a[200:203], v76, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[148:151], v[168:171], a[204:207], v76, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[148:151], v[172:175], a[208:211], v76, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[148:151], v[176:179], a[212:215], v76, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[148:151], v[180:183], a[216:219], v76, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[148:151], v[184:187], a[220:223], v76, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[152:155], v[156:159], a[224:227], v76, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[152:155], v[160:163], a[228:231], v76, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[152:155], v[164:167], a[232:235], v76, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[152:155], v[168:171], a[236:239], v76, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[152:155], v[172:175], a[240:243], v76, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[152:155], v[176:179], a[244:247], v76, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[152:155], v[180:183], a[248:251], v76, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[152:155], v[184:187], a[252:255], v76, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s61, s60, 1
		s_and_b32 s62, s61, 1
		s_lshl_b32 s61, s62, 16
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 13, v2
		v_add_u32_e32 v2, s61, v3
		v_and_b32_e32 v3, 15, v0
		v_lshlrev_b32_e32 v4, 6, v3
		v_lshlrev_b32_e32 v3, 4, v6
		v_add3_u32 v5, v2, v4, v3
		ds_read_b128 v[88:91], v5
		ds_read_b128 v[92:95], v5 offset:1024
		ds_read_b128 v[96:99], v5 offset:2048
		ds_read_b128 v[100:103], v5 offset:3072
		ds_read_b128 v[104:107], v5 offset:4096
		ds_read_b128 v[108:111], v5 offset:5120
		ds_read_b128 v[112:115], v5 offset:6144
		ds_read_b128 v[124:127], v5 offset:7168
		v_and_b32_e32 v2, 15, v0
		v_lshlrev_b32_e32 v3, 6, v2
		v_add_u32_e32 v2, s61, v3
		v_lshlrev_b32_e32 v3, 13, v7
		v_lshlrev_b32_e32 v4, 4, v6
		v_add3_u32 v78, v2, v3, v4
		ds_read_b128 v[128:131], v78 offset:32768
		ds_read_b128 v[132:135], v78 offset:33792
		ds_read_b128 v[136:139], v78 offset:34816
		ds_read_b128 v[140:143], v78 offset:35840
		ds_read_b128 v[144:147], v78 offset:36864
		ds_read_b128 v[148:151], v78 offset:37888
		ds_read_b128 v[152:155], v78 offset:38912
		ds_read_b128 v[156:159], v78 offset:39936
		s_lshl_b32 s61, s62, 12
		s_add_i32 s62, s61, 0x20000
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 10, v2
		v_lshlrev_b32_e32 v2, 2, v8
		v_add3_u32 v4, s62, v3, v2
		ds_read_b32 v2, v4
		ds_read_b32 v3, v4 offset:256
		ds_read_b32 v81, v4 offset:512
		ds_read_b32 v118, v4 offset:768
		v_lshlrev_b32_e32 v4, 10, v7
		v_lshlrev_b32_e32 v119, 2, v8
		v_add3_u32 v160, s62, v119, v4
		ds_read_b32 v4, v160 offset:2048
		ds_read_b32 v119, v160 offset:2304
		ds_read_b32 v161, v160 offset:2560
		ds_read_b32 v162, v160 offset:2816
		s_waitcnt lgkmcnt(0)
		s_mov_b32 s61, 0
		scratch_load_dword v164, off, s61 offset:56
		scratch_load_dword v165, off, s61 offset:60
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v166, vcc, v164, v82
		v_addc_co_u32_e64 v167, vcc, v165, v83, vcc
		s_mov_b32 s61, 0
		scratch_load_dword v164, off, s61 offset:64
		scratch_load_dword v165, off, s61 offset:68
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v168, vcc, v164, v82
		v_addc_co_u32_e64 v169, vcc, v165, v83, vcc
		s_mov_b32 s61, 0
		scratch_load_dword v164, off, s61 offset:72
		scratch_load_dword v165, off, s61 offset:76
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v170, vcc, v164, v82
		v_addc_co_u32_e64 v171, vcc, v165, v83, vcc
		s_mov_b32 s61, 0
		scratch_load_dword v164, off, s61 offset:80
		scratch_load_dword v165, off, s61 offset:84
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v172, vcc, v164, v82
		v_addc_co_u32_e64 v173, vcc, v165, v83, vcc
		s_mov_b32 s61, 0
		scratch_load_dword v164, off, s61 offset:88
		scratch_load_dword v165, off, s61 offset:92
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v174, vcc, v164, v82
		v_addc_co_u32_e64 v175, vcc, v165, v83, vcc
		s_mov_b32 s61, 0
		scratch_load_dword v164, off, s61 offset:96
		scratch_load_dword v165, off, s61 offset:100
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v176, vcc, v164, v82
		v_addc_co_u32_e64 v177, vcc, v165, v83, vcc
		s_mov_b32 s61, 0
		scratch_load_dword v164, off, s61 offset:104
		scratch_load_dword v165, off, s61 offset:108
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v178, vcc, v164, v82
		v_addc_co_u32_e64 v179, vcc, v165, v83, vcc
		s_mov_b32 s61, 0
		scratch_load_dword v164, off, s61 offset:112
		scratch_load_dword v165, off, s61 offset:116
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v180, vcc, v164, v82
		v_addc_co_u32_e64 v181, vcc, v165, v83, vcc
		s_mov_b32 s61, 0
		scratch_load_dword v164, off, s61 offset:120
		scratch_load_dword v165, off, s61 offset:124
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v182, vcc, v164, v82
		v_addc_co_u32_e64 v183, vcc, v165, v83, vcc
		s_mov_b32 s61, 0
		scratch_load_dword v164, off, s61 offset:128
		scratch_load_dword v165, off, s61 offset:132
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v184, vcc, v164, v82
		v_addc_co_u32_e64 v185, vcc, v165, v83, vcc
		s_mov_b32 s61, 0
		scratch_load_dword v164, off, s61 offset:136
		scratch_load_dword v165, off, s61 offset:140
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v186, vcc, v164, v82
		v_addc_co_u32_e64 v187, vcc, v165, v83, vcc
		s_mov_b32 s61, 0
		scratch_load_dword v164, off, s61 offset:144
		scratch_load_dword v165, off, s61 offset:148
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v188, vcc, v164, v82
		v_addc_co_u32_e64 v189, vcc, v165, v83, vcc
		s_mov_b32 s61, 0
		scratch_load_dword v164, off, s61 offset:152
		scratch_load_dword v165, off, s61 offset:156
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v190, vcc, v164, v82
		v_addc_co_u32_e64 v191, vcc, v165, v83, vcc
		s_mov_b32 s61, 0
		scratch_load_dword v164, off, s61 offset:160
		scratch_load_dword v165, off, s61 offset:164
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v192, vcc, v164, v82
		v_addc_co_u32_e64 v193, vcc, v165, v83, vcc
		s_mov_b32 s61, 0
		scratch_load_dword v164, off, s61 offset:168
		scratch_load_dword v165, off, s61 offset:172
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v194, vcc, v164, v82
		v_addc_co_u32_e64 v195, vcc, v165, v83, vcc
		s_mov_b32 s61, 0
		scratch_load_dword v164, off, s61 offset:176
		scratch_load_dword v165, off, s61 offset:180
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v196, vcc, v164, v82
		v_addc_co_u32_e64 v197, vcc, v165, v83, vcc
		s_mov_b32 s61, 0
		scratch_load_dword v82, off, s61 offset:184
		scratch_load_dword v83, off, s61 offset:188
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v164, vcc, v82, v116
		v_addc_co_u32_e64 v165, vcc, v83, v117, vcc
		s_mov_b32 s61, 0
		scratch_load_dword v82, off, s61 offset:192
		scratch_load_dword v83, off, s61 offset:196
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v198, vcc, v82, v116
		v_addc_co_u32_e64 v199, vcc, v83, v117, vcc
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[88:91], v[128:131], v[120:123], v2, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[200:203], v5 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[88:91], v[132:135], a[4:7], v2, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[204:207], v5 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[88:91], v[136:139], a[8:11], v2, v119 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[208:211], v5 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[88:91], v[140:143], a[12:15], v2, v119 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[212:215], v5 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[88:91], v[144:147], a[16:19], v2, v161 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v5 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[88:91], v[148:151], a[20:23], v2, v161 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v5 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[88:91], v[152:155], a[24:27], v2, v162 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v5 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[88:91], v[156:159], a[28:31], v2, v162 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v5 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[92:95], v[128:131], a[32:35], v2, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v78 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[92:95], v[132:135], a[36:39], v2, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[232:235], v78 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[92:95], v[136:139], a[40:43], v2, v119 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[236:239], v78 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[92:95], v[140:143], a[44:47], v2, v119 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v78 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[92:95], v[144:147], a[48:51], v2, v161 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[244:247], v78 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[92:95], v[148:151], a[52:55], v2, v161 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v78 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[92:95], v[152:155], a[56:59], v2, v162 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[252:255], v78 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[92:95], v[156:159], a[60:63], v2, v162 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v78 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[96:99], v[128:131], a[64:67], v3, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s10
		s_nop 0
		buffer_load_dwordx4 v166, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[96:99], v[132:135], a[68:71], v3, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s45
		s_nop 0
		buffer_load_dwordx4 v168, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[96:99], v[136:139], a[72:75], v3, v119 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s46
		s_nop 0
		buffer_load_dwordx4 v170, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[96:99], v[140:143], a[76:79], v3, v119 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s47
		s_nop 0
		buffer_load_dwordx4 v172, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[96:99], v[144:147], a[80:83], v3, v161 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s48
		s_nop 0
		buffer_load_dwordx4 v174, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[96:99], v[148:151], a[84:87], v3, v161 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s49
		s_nop 0
		buffer_load_dwordx4 v176, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[96:99], v[152:155], a[88:91], v3, v162 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v178, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[96:99], v[156:159], a[92:95], v3, v162 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s51
		s_nop 0
		buffer_load_dwordx4 v180, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[100:103], v[128:131], a[96:99], v3, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s52
		s_nop 0
		buffer_load_dwordx4 v182, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[100:103], v[132:135], a[100:103], v3, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s53
		s_nop 0
		buffer_load_dwordx4 v184, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[100:103], v[136:139], a[104:107], v3, v119 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s54
		s_nop 0
		buffer_load_dwordx4 v186, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[100:103], v[140:143], a[108:111], v3, v119 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s55
		s_nop 0
		buffer_load_dwordx4 v188, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[100:103], v[144:147], a[112:115], v3, v161 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s56
		s_nop 0
		buffer_load_dwordx4 v190, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[100:103], v[148:151], a[116:119], v3, v161 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s57
		s_nop 0
		buffer_load_dwordx4 v192, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[100:103], v[152:155], a[120:123], v3, v162 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s58
		s_nop 0
		buffer_load_dwordx4 v194, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[100:103], v[156:159], a[124:127], v3, v162 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s59
		s_nop 0
		buffer_load_dwordx4 v196, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[104:107], v[128:131], a[128:131], v81, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s43, 0x20000
		s_nop 0
		buffer_load_dwordx4 v164, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[104:107], v[132:135], a[132:135], v81, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s9, 0x20000
		s_nop 0
		buffer_load_dwordx4 v198, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[104:107], v[136:139], a[136:139], v81, v119 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[104:107], v[140:143], a[140:143], v81, v119 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[104:107], v[144:147], a[144:147], v81, v161 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[104:107], v[148:151], a[148:151], v81, v161 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[104:107], v[152:155], a[152:155], v81, v162 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[104:107], v[156:159], a[156:159], v81, v162 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[108:111], v[128:131], a[160:163], v81, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[108:111], v[132:135], a[164:167], v81, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[108:111], v[136:139], a[168:171], v81, v119 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[108:111], v[140:143], a[172:175], v81, v119 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[108:111], v[144:147], a[176:179], v81, v161 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[108:111], v[148:151], a[180:183], v81, v161 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[108:111], v[152:155], a[184:187], v81, v162 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[108:111], v[156:159], a[188:191], v81, v162 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[112:115], v[128:131], a[192:195], v118, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[112:115], v[132:135], a[196:199], v118, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[112:115], v[136:139], a[200:203], v118, v119 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[112:115], v[140:143], a[204:207], v118, v119 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[112:115], v[144:147], a[208:211], v118, v161 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[112:115], v[148:151], a[212:215], v118, v161 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[112:115], v[152:155], a[216:219], v118, v162 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[112:115], v[156:159], a[220:223], v118, v162 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[124:127], v[128:131], a[224:227], v118, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[124:127], v[132:135], a[228:231], v118, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[124:127], v[136:139], a[232:235], v118, v119 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[124:127], v[140:143], a[236:239], v118, v119 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[124:127], v[144:147], a[240:243], v118, v161 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[124:127], v[148:151], a[244:247], v118, v161 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[124:127], v[152:155], a[248:251], v118, v162 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[124:127], v[156:159], a[252:255], v118, v162 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[200:203], v[228:231], v[120:123], v2, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[200:203], v[232:235], a[4:7], v2, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[200:203], v[236:239], a[8:11], v2, v119 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[200:203], v[240:243], a[12:15], v2, v119 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[200:203], v[244:247], a[16:19], v2, v161 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[200:203], v[248:251], a[20:23], v2, v161 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[200:203], v[252:255], a[24:27], v2, v162 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[200:203], v[92:95], a[28:31], v2, v162 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[204:207], v[228:231], a[32:35], v2, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[204:207], v[232:235], a[36:39], v2, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[204:207], v[236:239], a[40:43], v2, v119 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[204:207], v[240:243], a[44:47], v2, v119 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[204:207], v[244:247], a[48:51], v2, v161 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[204:207], v[248:251], a[52:55], v2, v161 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[204:207], v[252:255], a[56:59], v2, v162 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[204:207], v[92:95], a[60:63], v2, v162 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[208:211], v[228:231], a[64:67], v3, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[208:211], v[232:235], a[68:71], v3, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[208:211], v[236:239], a[72:75], v3, v119 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[208:211], v[240:243], a[76:79], v3, v119 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[208:211], v[244:247], a[80:83], v3, v161 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[208:211], v[248:251], a[84:87], v3, v161 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[208:211], v[252:255], a[88:91], v3, v162 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[208:211], v[92:95], a[92:95], v3, v162 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[212:215], v[228:231], a[96:99], v3, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[212:215], v[232:235], a[100:103], v3, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[212:215], v[236:239], a[104:107], v3, v119 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[212:215], v[240:243], a[108:111], v3, v119 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[212:215], v[244:247], a[112:115], v3, v161 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[212:215], v[248:251], a[116:119], v3, v161 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[212:215], v[252:255], a[120:123], v3, v162 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[212:215], v[92:95], a[124:127], v3, v162 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[216:219], v[228:231], a[128:131], v81, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[216:219], v[232:235], a[132:135], v81, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[216:219], v[236:239], a[136:139], v81, v119 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[216:219], v[240:243], a[140:143], v81, v119 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[216:219], v[244:247], a[144:147], v81, v161 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[216:219], v[248:251], a[148:151], v81, v161 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[216:219], v[252:255], a[152:155], v81, v162 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[216:219], v[92:95], a[156:159], v81, v162 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[220:223], v[228:231], a[160:163], v81, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[220:223], v[232:235], a[164:167], v81, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[220:223], v[236:239], a[168:171], v81, v119 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[220:223], v[240:243], a[172:175], v81, v119 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[220:223], v[244:247], a[176:179], v81, v161 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[220:223], v[248:251], a[180:183], v81, v161 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[220:223], v[252:255], a[184:187], v81, v162 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[220:223], v[92:95], a[188:191], v81, v162 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[224:227], v[228:231], a[192:195], v118, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[224:227], v[232:235], a[196:199], v118, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[224:227], v[236:239], a[200:203], v118, v119 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[224:227], v[240:243], a[204:207], v118, v119 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[224:227], v[244:247], a[208:211], v118, v161 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[224:227], v[248:251], a[212:215], v118, v161 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[224:227], v[252:255], a[216:219], v118, v162 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[224:227], v[92:95], a[220:223], v118, v162 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[88:91], v[228:231], a[224:227], v118, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[88:91], v[232:235], a[228:231], v118, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[88:91], v[236:239], a[232:235], v118, v119 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[88:91], v[240:243], a[236:239], v118, v119 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[88:91], v[244:247], a[240:243], v118, v161 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[88:91], v[248:251], a[244:247], v118, v161 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[88:91], v[252:255], a[248:251], v118, v162 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[88:91], v[92:95], a[252:255], v118, v162 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s60, s60, 2
		s_cmp_lt_i32 s60, s11
		v_mov_b32_e32 v28, v84
		v_mov_b32_e32 v29, v85
		v_mov_b32_e32 v30, v86
		v_mov_b32_e32 v31, v87
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(63) expcnt(7) lgkmcnt(15)
		scratch_load_dword v84, off, s61 offset:584
		scratch_load_dword v85, off, s61 offset:588
		scratch_load_dword v86, off, s61 offset:592
		scratch_load_dword v87, off, s61 offset:596
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v32, v84
		v_mov_b32_e32 v33, v85
		v_mov_b32_e32 v34, v86
		v_mov_b32_e32 v35, v87
		s_mov_b32 s61, 0
		scratch_load_dword v84, off, s61 offset:552
		scratch_load_dword v85, off, s61 offset:556
		scratch_load_dword v86, off, s61 offset:560
		scratch_load_dword v87, off, s61 offset:564
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v36, v84
		v_mov_b32_e32 v37, v85
		v_mov_b32_e32 v38, v86
		v_mov_b32_e32 v39, v87
		s_mov_b32 s61, 0
		scratch_load_dword v84, off, s61 offset:520
		scratch_load_dword v85, off, s61 offset:524
		scratch_load_dword v86, off, s61 offset:528
		scratch_load_dword v87, off, s61 offset:532
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v40, v84
		v_mov_b32_e32 v41, v85
		v_mov_b32_e32 v42, v86
		v_mov_b32_e32 v43, v87
		s_mov_b32 s61, 0
		scratch_load_dword v84, off, s61 offset:488
		scratch_load_dword v85, off, s61 offset:492
		scratch_load_dword v86, off, s61 offset:496
		scratch_load_dword v87, off, s61 offset:500
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v44, v84
		v_mov_b32_e32 v45, v85
		v_mov_b32_e32 v46, v86
		v_mov_b32_e32 v47, v87
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(56)
		scratch_load_dword v84, off, s61 offset:456
		scratch_load_dword v85, off, s61 offset:460
		scratch_load_dword v86, off, s61 offset:464
		scratch_load_dword v87, off, s61 offset:468
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v48, v84
		v_mov_b32_e32 v49, v85
		v_mov_b32_e32 v50, v86
		v_mov_b32_e32 v51, v87
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(48)
		scratch_load_dword v84, off, s61 offset:424
		scratch_load_dword v85, off, s61 offset:428
		scratch_load_dword v86, off, s61 offset:432
		scratch_load_dword v87, off, s61 offset:436
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v52, v84
		v_mov_b32_e32 v53, v85
		v_mov_b32_e32 v54, v86
		v_mov_b32_e32 v55, v87
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(40)
		scratch_load_dword v84, off, s61 offset:392
		scratch_load_dword v85, off, s61 offset:396
		scratch_load_dword v86, off, s61 offset:400
		scratch_load_dword v87, off, s61 offset:404
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v56, v84
		v_mov_b32_e32 v57, v85
		v_mov_b32_e32 v58, v86
		v_mov_b32_e32 v59, v87
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(32)
		scratch_load_dword v84, off, s61 offset:360
		scratch_load_dword v85, off, s61 offset:364
		scratch_load_dword v86, off, s61 offset:368
		scratch_load_dword v87, off, s61 offset:372
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v60, v84
		v_mov_b32_e32 v61, v85
		v_mov_b32_e32 v62, v86
		v_mov_b32_e32 v63, v87
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v84, off, s61 offset:328
		scratch_load_dword v85, off, s61 offset:332
		scratch_load_dword v86, off, s61 offset:336
		scratch_load_dword v87, off, s61 offset:340
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v64, v84
		v_mov_b32_e32 v65, v85
		v_mov_b32_e32 v66, v86
		v_mov_b32_e32 v67, v87
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v84, off, s61 offset:296
		scratch_load_dword v85, off, s61 offset:300
		scratch_load_dword v86, off, s61 offset:304
		scratch_load_dword v87, off, s61 offset:308
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v68, v84
		v_mov_b32_e32 v69, v85
		v_mov_b32_e32 v70, v86
		v_mov_b32_e32 v71, v87
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v84, off, s61 offset:264
		scratch_load_dword v85, off, s61 offset:268
		scratch_load_dword v86, off, s61 offset:272
		scratch_load_dword v87, off, s61 offset:276
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v72, v84
		v_mov_b32_e32 v73, v85
		v_mov_b32_e32 v74, v86
		v_mov_b32_e32 v75, v87
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(7)
		scratch_load_dword v2, off, s61 offset:228
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v1, v2
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(6)
		scratch_load_dword v2, off, s61 offset:224
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v9, v2
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(5)
		scratch_load_dword v2, off, s61 offset:220
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v11, v2
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v2, off, s61 offset:216
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v76, v2
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(3)
		scratch_load_dword v2, off, s61 offset:212
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v10, v2
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(2)
		scratch_load_dword v2, off, s61 offset:208
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v77, v2
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(1)
		scratch_load_dword v2, off, s61 offset:204
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v79, v2
		s_mov_b32 s61, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v2, off, s61 offset:200
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v80, v2
		s_mov_b32 s61, 0
		scratch_store_dword off, v120, s61 offset:232
		scratch_store_dword off, v121, s61 offset:236
		scratch_store_dword off, v122, s61 offset:240
		scratch_store_dword off, v123, s61 offset:244
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v84, off, s0 offset:232
		scratch_load_dword v85, off, s0 offset:236
		scratch_load_dword v86, off, s0 offset:240
		scratch_load_dword v87, off, s0 offset:244
		s_add_i32 s0, s12, -1
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[12:15], v[44:47], v[84:87], v1, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s1, s0, 1
		s_lshl_b32 s0, s1, 16
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 13, v2
		v_add_u32_e32 v2, s0, v3
		v_and_b32_e32 v3, 15, v0
		v_lshlrev_b32_e32 v4, 6, v3
		v_lshlrev_b32_e32 v3, 4, v6
		v_add3_u32 v5, v2, v4, v3
		ds_read_b128 v[88:91], v5 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[12:15], v[48:51], a[4:7], v1, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v5 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[12:15], v[52:55], a[8:11], v1, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v5 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[12:15], v[56:59], a[12:15], v1, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v5 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[12:15], v[60:63], a[16:19], v1, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[104:107], v5 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[12:15], v[64:67], a[20:23], v1, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[108:111], v5 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[12:15], v[68:71], a[24:27], v1, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[112:115], v5 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[12:15], v[72:75], a[28:31], v1, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[12:15], v5 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[16:19], v[44:47], a[32:35], v1, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_and_b32_e32 v2, 15, v0
		v_lshlrev_b32_e32 v3, 6, v2
		v_add_u32_e32 v2, s0, v3
		v_lshlrev_b32_e32 v3, 13, v7
		v_lshlrev_b32_e32 v4, 4, v6
		v_add3_u32 v5, v2, v3, v4
		ds_read_b128 v[116:119], v5 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[16:19], v[48:51], a[36:39], v1, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[120:123], v5 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[16:19], v[52:55], a[40:43], v1, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[124:127], v5 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[16:19], v[56:59], a[44:47], v1, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[128:131], v5 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[16:19], v[60:63], a[48:51], v1, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[132:135], v5 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[16:19], v[64:67], a[52:55], v1, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[136:139], v5 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[16:19], v[68:71], a[56:59], v1, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[140:143], v5 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[16:19], v[72:75], a[60:63], v1, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[16:19], v5 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[20:23], v[44:47], a[64:67], v9, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[20:23], v[48:51], a[68:71], v9, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[20:23], v[52:55], a[72:75], v9, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[20:23], v[56:59], a[76:79], v9, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[20:23], v[60:63], a[80:83], v9, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[20:23], v[64:67], a[84:87], v9, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[20:23], v[68:71], a[88:91], v9, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[20:23], v[72:75], a[92:95], v9, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[24:27], v[44:47], a[96:99], v9, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[24:27], v[48:51], a[100:103], v9, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[24:27], v[52:55], a[104:107], v9, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[24:27], v[56:59], a[108:111], v9, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[24:27], v[60:63], a[112:115], v9, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[24:27], v[64:67], a[116:119], v9, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[24:27], v[68:71], a[120:123], v9, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[24:27], v[72:75], a[124:127], v9, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[28:31], v[44:47], a[128:131], v11, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[28:31], v[48:51], a[132:135], v11, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[28:31], v[52:55], a[136:139], v11, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[28:31], v[56:59], a[140:143], v11, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[28:31], v[60:63], a[144:147], v11, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[28:31], v[64:67], a[148:151], v11, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[28:31], v[68:71], a[152:155], v11, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[28:31], v[72:75], a[156:159], v11, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[32:35], v[44:47], a[160:163], v11, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[32:35], v[48:51], a[164:167], v11, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[32:35], v[52:55], a[168:171], v11, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[32:35], v[56:59], a[172:175], v11, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[32:35], v[60:63], a[176:179], v11, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[32:35], v[64:67], a[180:183], v11, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[32:35], v[68:71], a[184:187], v11, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[32:35], v[72:75], a[188:191], v11, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[36:39], v[44:47], a[192:195], v76, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[36:39], v[48:51], a[196:199], v76, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[36:39], v[52:55], a[200:203], v76, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[36:39], v[56:59], a[204:207], v76, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[36:39], v[60:63], a[208:211], v76, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[36:39], v[64:67], a[212:215], v76, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[36:39], v[68:71], a[216:219], v76, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[36:39], v[72:75], a[220:223], v76, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[40:43], v[44:47], a[224:227], v76, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[40:43], v[48:51], a[228:231], v76, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[40:43], v[52:55], a[232:235], v76, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[40:43], v[56:59], a[236:239], v76, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[40:43], v[60:63], a[240:243], v76, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[40:43], v[64:67], a[244:247], v76, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[40:43], v[68:71], a[248:251], v76, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[40:43], v[72:75], a[252:255], v76, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[88:91], v[116:119], v[84:87], v1, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[88:91], v[120:123], a[4:7], v1, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[88:91], v[124:127], a[8:11], v1, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[88:91], v[128:131], a[12:15], v1, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[88:91], v[132:135], a[16:19], v1, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[88:91], v[136:139], a[20:23], v1, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[88:91], v[140:143], a[24:27], v1, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[88:91], v[16:19], a[28:31], v1, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[92:95], v[116:119], a[32:35], v1, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[92:95], v[120:123], a[36:39], v1, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[92:95], v[124:127], a[40:43], v1, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[92:95], v[128:131], a[44:47], v1, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[92:95], v[132:135], a[48:51], v1, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[92:95], v[136:139], a[52:55], v1, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[92:95], v[140:143], a[56:59], v1, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[92:95], v[16:19], a[60:63], v1, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[96:99], v[116:119], a[64:67], v9, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[96:99], v[120:123], a[68:71], v9, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[96:99], v[124:127], a[72:75], v9, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[96:99], v[128:131], a[76:79], v9, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[96:99], v[132:135], a[80:83], v9, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[96:99], v[136:139], a[84:87], v9, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[96:99], v[140:143], a[88:91], v9, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[96:99], v[16:19], a[92:95], v9, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[100:103], v[116:119], a[96:99], v9, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[100:103], v[120:123], a[100:103], v9, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[100:103], v[124:127], a[104:107], v9, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[100:103], v[128:131], a[108:111], v9, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[100:103], v[132:135], a[112:115], v9, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[100:103], v[136:139], a[116:119], v9, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[100:103], v[140:143], a[120:123], v9, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[100:103], v[16:19], a[124:127], v9, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[104:107], v[116:119], a[128:131], v11, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[104:107], v[120:123], a[132:135], v11, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[104:107], v[124:127], a[136:139], v11, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[104:107], v[128:131], a[140:143], v11, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[104:107], v[132:135], a[144:147], v11, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[104:107], v[136:139], a[148:151], v11, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[104:107], v[140:143], a[152:155], v11, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[104:107], v[16:19], a[156:159], v11, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[108:111], v[116:119], a[160:163], v11, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[108:111], v[120:123], a[164:167], v11, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[108:111], v[124:127], a[168:171], v11, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[108:111], v[128:131], a[172:175], v11, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[108:111], v[132:135], a[176:179], v11, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[108:111], v[136:139], a[180:183], v11, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[108:111], v[140:143], a[184:187], v11, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[108:111], v[16:19], a[188:191], v11, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[112:115], v[116:119], a[192:195], v76, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[112:115], v[120:123], a[196:199], v76, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[112:115], v[124:127], a[200:203], v76, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[112:115], v[128:131], a[204:207], v76, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[112:115], v[132:135], a[208:211], v76, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[112:115], v[136:139], a[212:215], v76, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[112:115], v[140:143], a[216:219], v76, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[112:115], v[16:19], a[220:223], v76, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[12:15], v[116:119], a[224:227], v76, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[12:15], v[120:123], a[228:231], v76, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[12:15], v[124:127], a[232:235], v76, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[12:15], v[128:131], a[236:239], v76, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[12:15], v[132:135], a[240:243], v76, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[12:15], v[136:139], a[244:247], v76, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[12:15], v[140:143], a[248:251], v76, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[12:15], v[16:19], a[252:255], v76, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s0, s12, 1
		s_lshl_b32 s1, s0, 16
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v2, 13, v1
		v_add_u32_e32 v1, s1, v2
		v_and_b32_e32 v2, 15, v0
		v_lshlrev_b32_e32 v3, 6, v2
		v_lshlrev_b32_e32 v2, 4, v6
		v_add3_u32 v4, v1, v3, v2
		ds_read_b128 v[12:15], v4
		ds_read_b128 v[16:19], v4 offset:1024
		ds_read_b128 v[20:23], v4 offset:2048
		ds_read_b128 v[24:27], v4 offset:3072
		ds_read_b128 v[28:31], v4 offset:4096
		ds_read_b128 v[32:35], v4 offset:5120
		ds_read_b128 v[36:39], v4 offset:6144
		ds_read_b128 v[40:43], v4 offset:7168
		v_and_b32_e32 v1, 15, v0
		v_lshlrev_b32_e32 v2, 6, v1
		v_add_u32_e32 v1, s1, v2
		v_lshlrev_b32_e32 v2, 13, v7
		v_lshlrev_b32_e32 v3, 4, v6
		v_add3_u32 v5, v1, v2, v3
		ds_read_b128 v[44:47], v5 offset:32768
		ds_read_b128 v[48:51], v5 offset:33792
		ds_read_b128 v[52:55], v5 offset:34816
		ds_read_b128 v[56:59], v5 offset:35840
		ds_read_b128 v[60:63], v5 offset:36864
		ds_read_b128 v[64:67], v5 offset:37888
		ds_read_b128 v[68:71], v5 offset:38912
		ds_read_b128 v[72:75], v5 offset:39936
		s_lshl_b32 s1, s0, 12
		s_add_i32 s0, s1, 0x20000
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v0, 10, v1
		v_lshlrev_b32_e32 v1, 2, v8
		v_add3_u32 v2, s0, v0, v1
		ds_read_b32 v0, v2
		ds_read_b32 v1, v2 offset:256
		ds_read_b32 v3, v2 offset:512
		ds_read_b32 v6, v2 offset:768
		v_lshlrev_b32_e32 v2, 10, v7
		v_lshlrev_b32_e32 v7, 2, v8
		v_add3_u32 v8, s0, v7, v2
		ds_read_b32 v2, v8 offset:2048
		ds_read_b32 v7, v8 offset:2304
		ds_read_b32 v9, v8 offset:2560
		ds_read_b32 v10, v8 offset:2816
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[12:15], v[44:47], v[84:87], v0, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[76:79], v4 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[12:15], v[48:51], a[4:7], v0, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[80:83], v4 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[12:15], v[52:55], a[8:11], v0, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v4 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[12:15], v[56:59], a[12:15], v0, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v4 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[12:15], v[60:63], a[16:19], v0, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v4 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[12:15], v[64:67], a[20:23], v0, v9 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v4 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[12:15], v[68:71], a[24:27], v0, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[104:107], v4 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[12:15], v[72:75], a[28:31], v0, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[12:15], v4 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[16:19], v[44:47], a[32:35], v0, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[108:111], v5 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[16:19], v[48:51], a[36:39], v0, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[112:115], v5 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[16:19], v[52:55], a[40:43], v0, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[116:119], v5 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[16:19], v[56:59], a[44:47], v0, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[120:123], v5 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[16:19], v[60:63], a[48:51], v0, v9 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[124:127], v5 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[16:19], v[64:67], a[52:55], v0, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[128:131], v5 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[16:19], v[68:71], a[56:59], v0, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[132:135], v5 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[16:19], v[72:75], a[60:63], v0, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[16:19], v5 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[20:23], v[44:47], a[64:67], v1, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[20:23], v[48:51], a[68:71], v1, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[20:23], v[52:55], a[72:75], v1, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[20:23], v[56:59], a[76:79], v1, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[20:23], v[60:63], a[80:83], v1, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[20:23], v[64:67], a[84:87], v1, v9 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[20:23], v[68:71], a[88:91], v1, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[20:23], v[72:75], a[92:95], v1, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[24:27], v[44:47], a[96:99], v1, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[24:27], v[48:51], a[100:103], v1, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[24:27], v[52:55], a[104:107], v1, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[24:27], v[56:59], a[108:111], v1, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[24:27], v[60:63], a[112:115], v1, v9 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[24:27], v[64:67], a[116:119], v1, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[24:27], v[68:71], a[120:123], v1, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[24:27], v[72:75], a[124:127], v1, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[28:31], v[44:47], a[128:131], v3, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[28:31], v[48:51], a[132:135], v3, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[28:31], v[52:55], a[136:139], v3, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[28:31], v[56:59], a[140:143], v3, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[28:31], v[60:63], a[144:147], v3, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[28:31], v[64:67], a[148:151], v3, v9 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[28:31], v[68:71], a[152:155], v3, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[28:31], v[72:75], a[156:159], v3, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[32:35], v[44:47], a[160:163], v3, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[32:35], v[48:51], a[164:167], v3, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[32:35], v[52:55], a[168:171], v3, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[32:35], v[56:59], a[172:175], v3, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[32:35], v[60:63], a[176:179], v3, v9 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[32:35], v[64:67], a[180:183], v3, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[32:35], v[68:71], a[184:187], v3, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[32:35], v[72:75], a[188:191], v3, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[36:39], v[44:47], a[192:195], v6, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[36:39], v[48:51], a[196:199], v6, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[36:39], v[52:55], a[200:203], v6, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[36:39], v[56:59], a[204:207], v6, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[36:39], v[60:63], a[208:211], v6, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[36:39], v[64:67], a[212:215], v6, v9 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[36:39], v[68:71], a[216:219], v6, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[36:39], v[72:75], a[220:223], v6, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[40:43], v[44:47], a[224:227], v6, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[40:43], v[48:51], a[228:231], v6, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[40:43], v[52:55], a[232:235], v6, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[40:43], v[56:59], a[236:239], v6, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[40:43], v[60:63], a[240:243], v6, v9 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[40:43], v[64:67], a[244:247], v6, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[40:43], v[68:71], a[248:251], v6, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[40:43], v[72:75], a[252:255], v6, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[76:79], v[108:111], v[84:87], v0, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[76:79], v[112:115], a[4:7], v0, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[76:79], v[116:119], a[8:11], v0, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[76:79], v[120:123], a[12:15], v0, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[76:79], v[124:127], a[16:19], v0, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[76:79], v[128:131], a[20:23], v0, v9 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[76:79], v[132:135], a[24:27], v0, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[76:79], v[16:19], a[28:31], v0, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[80:83], v[108:111], a[32:35], v0, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[80:83], v[112:115], a[36:39], v0, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[80:83], v[116:119], a[40:43], v0, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[80:83], v[120:123], a[44:47], v0, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[80:83], v[124:127], a[48:51], v0, v9 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[80:83], v[128:131], a[52:55], v0, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[80:83], v[132:135], a[56:59], v0, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[80:83], v[16:19], a[60:63], v0, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[88:91], v[108:111], a[64:67], v1, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[88:91], v[112:115], a[68:71], v1, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[88:91], v[116:119], a[72:75], v1, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[88:91], v[120:123], a[76:79], v1, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[88:91], v[124:127], a[80:83], v1, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[88:91], v[128:131], a[84:87], v1, v9 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[88:91], v[132:135], a[88:91], v1, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[88:91], v[16:19], a[92:95], v1, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[92:95], v[108:111], a[96:99], v1, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[92:95], v[112:115], a[100:103], v1, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[92:95], v[116:119], a[104:107], v1, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[92:95], v[120:123], a[108:111], v1, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[92:95], v[124:127], a[112:115], v1, v9 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[92:95], v[128:131], a[116:119], v1, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[92:95], v[132:135], a[120:123], v1, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[92:95], v[16:19], a[124:127], v1, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[96:99], v[108:111], a[128:131], v3, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[96:99], v[112:115], a[132:135], v3, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[96:99], v[116:119], a[136:139], v3, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[96:99], v[120:123], a[140:143], v3, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[96:99], v[124:127], a[144:147], v3, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[96:99], v[128:131], a[148:151], v3, v9 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[96:99], v[132:135], a[152:155], v3, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[96:99], v[16:19], a[156:159], v3, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[100:103], v[108:111], a[160:163], v3, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[100:103], v[112:115], a[164:167], v3, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[100:103], v[116:119], a[168:171], v3, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[100:103], v[120:123], a[172:175], v3, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[100:103], v[124:127], a[176:179], v3, v9 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[100:103], v[128:131], a[180:183], v3, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[100:103], v[132:135], a[184:187], v3, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[100:103], v[16:19], a[188:191], v3, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[104:107], v[108:111], a[192:195], v6, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[104:107], v[112:115], a[196:199], v6, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[104:107], v[116:119], a[200:203], v6, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[104:107], v[120:123], a[204:207], v6, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[104:107], v[124:127], a[208:211], v6, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[104:107], v[128:131], a[212:215], v6, v9 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[104:107], v[132:135], a[216:219], v6, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[104:107], v[16:19], a[220:223], v6, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[12:15], v[108:111], a[224:227], v6, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[12:15], v[112:115], a[228:231], v6, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[12:15], v[116:119], a[232:235], v6, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[12:15], v[120:123], a[236:239], v6, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[12:15], v[124:127], a[240:243], v6, v9 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[12:15], v[128:131], a[244:247], v6, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[12:15], v[132:135], a[248:251], v6, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[12:15], v[16:19], a[252:255], v6, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v84, v85
		v_cvt_pk_f16_f32 v1, v86, v87
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
		.amdhsa_private_segment_fixed_size 600
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
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 600
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
    .private_segment_fixed_size: 600
    .sgpr_count:     64
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     512
    .agpr_count:     256
    .vgpr_spill_count: 154
    .wavefront_size: 64
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
