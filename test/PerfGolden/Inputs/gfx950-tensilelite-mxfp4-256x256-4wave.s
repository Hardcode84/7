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
		v_lshrrev_b32_e32 v8, 2, v3
		v_lshlrev_b32_e32 v3, 12, v8
		v_accvgpr_read_b32 v8, a1
		v_lshrrev_b32_e32 v9, 3, v8
		v_and_b32_e32 v8, 3, v9
		v_accvgpr_read_b32 v9, a1
		v_and_b32_e32 v10, 3, v9
		v_xor_b32_e32 v9, v8, v10
		v_lshlrev_b32_e32 v8, 4, v9
		v_add3_u32 v9, v1, v3, v8
		s_add_i32 s10, s9, 0x40000
		v_add_u32_e32 v1, s10, v2
		v_add3_u32 v10, v1, v3, v8
		s_add_i32 s10, s9, 0x80000
		v_add_u32_e32 v1, s10, v2
		v_add3_u32 v11, v1, v3, v8
		s_add_i32 s10, s9, 0xc0000
		v_add_u32_e32 v1, s10, v2
		v_add3_u32 v12, v1, v3, v8
		v_add3_u32 v1, s9, 64, v2
		v_add3_u32 v13, v1, v3, v8
		s_add_i32 s10, s9, 0x40040
		v_add_u32_e32 v1, s10, v2
		v_add3_u32 v14, v1, v3, v8
		s_add_i32 s10, s9, 0x80040
		v_add_u32_e32 v1, s10, v2
		v_add3_u32 v15, v1, v3, v8
		s_add_i32 s10, s9, 0xc0040
		v_add_u32_e32 v1, s10, v2
		v_add3_u32 v16, v1, v3, v8
		s_lshl_b32 s10, s14, 20
		v_add_u32_e32 v1, s10, v2
		v_add3_u32 v17, v1, v3, v8
		s_add_i32 s11, s10, 0x40000
		v_add_u32_e32 v1, s11, v2
		v_add3_u32 v18, v1, v3, v8
		s_add_i32 s11, s10, 0x80000
		v_add_u32_e32 v1, s11, v2
		v_add3_u32 v19, v1, v3, v8
		s_add_i32 s11, s10, 0xc0000
		v_add_u32_e32 v1, s11, v2
		v_add3_u32 v20, v1, v3, v8
		v_add3_u32 v1, s10, 64, v2
		v_add3_u32 v21, v1, v3, v8
		s_add_i32 s11, s10, 0x40040
		v_add_u32_e32 v1, s11, v2
		v_add3_u32 v22, v1, v3, v8
		s_add_i32 s11, s10, 0x80040
		v_add_u32_e32 v1, s11, v2
		v_add3_u32 v23, v1, v3, v8
		s_add_i32 s11, s10, 0xc0040
		v_add_u32_e32 v1, s11, v2
		v_add3_u32 v24, v1, v3, v8
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
		buffer_load_dwordx4 v9, s[20:23], 0 offen lds
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v11, s[20:23], 0 offen lds
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v15, s[20:23], 0 offen lds
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v16, s[20:23], 0 offen lds
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v17, s[0:3], 0 offen lds
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v18, s[0:3], 0 offen lds
		s_mov_b32 m0, s37
		s_nop 0
		buffer_load_dwordx4 v19, s[0:3], 0 offen lds
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v20, s[0:3], 0 offen lds
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v21, s[0:3], 0 offen lds
		s_mov_b32 m0, s40
		s_nop 0
		buffer_load_dwordx4 v22, s[0:3], 0 offen lds
		s_mov_b32 m0, s41
		s_nop 0
		buffer_load_dwordx4 v23, s[0:3], 0 offen lds
		s_mov_b32 m0, s42
		s_nop 0
		buffer_load_dwordx4 v24, s[0:3], 0 offen lds
		s_lshl_b32 s43, s14, 16
		s_add_i32 s44, s9, s43
		v_accvgpr_read_b32 v1, a1
		v_lshlrev_b32_e32 v9, 4, v1
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v10, 10, v1
		v_add3_u32 v1, s44, v10, v9
		s_lshr_b32 s45, s8, 7
		s_lshl_b32 s8, s45, 10
		v_accvgpr_read_b32 v10, a0
		v_and_b32_e32 v11, 1, v10
		v_lshlrev_b32_e32 v10, 10, v11
		v_add3_u32 v12, s44, v9, v10
		s_and_b32 s44, s11, 1
		s_lshl_b32 s11, s44, 10
		s_add_i32 s44, s11, 0x800
		s_add_i32 m0, s8, 0x20000
		s_nop 0
		buffer_load_dwordx4 v1, s[4:7], 0 offen lds
		s_add_i32 m0, s11, 0x20800
		s_nop 0
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		v_and_b32_e32 v1, 15, v0
		v_accvgpr_read_b32 v10, a1
		v_lshrrev_b32_e32 v12, 4, v10
		v_lshrrev_b32_e32 v10, 1, v1
		v_and_b32_e32 v1, 3, v10
		v_xor_b32_e32 v10, v12, v1
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v12, 13, v1
		v_and_b32_e32 v1, 15, v0
		v_lshlrev_b32_e32 v13, 6, v1
		v_lshlrev_b32_e32 v1, 4, v10
		v_add3_u32 v14, v12, v13, v1
		ds_read_b128 v[16:19], v14
		ds_read_b128 v[20:23], v14 offset:1024
		ds_read_b128 v[24:27], v14 offset:2048
		ds_read_b128 v[28:31], v14 offset:3072
		ds_read_b128 v[32:35], v14 offset:4096
		ds_read_b128 v[36:39], v14 offset:5120
		ds_read_b128 v[40:43], v14 offset:6144
		ds_read_b128 v[44:47], v14 offset:7168
		v_lshlrev_b32_e32 v1, 13, v11
		v_and_b32_e32 v12, 15, v0
		v_lshlrev_b32_e32 v13, 6, v12
		v_lshlrev_b32_e32 v12, 4, v10
		v_add3_u32 v14, v13, v1, v12
		ds_read_b128 v[48:51], v14 offset:32768
		ds_read_b128 v[52:55], v14 offset:33792
		ds_read_b128 v[56:59], v14 offset:34816
		ds_read_b128 v[60:63], v14 offset:35840
		ds_read_b128 v[64:67], v14 offset:36864
		ds_read_b128 v[68:71], v14 offset:37888
		ds_read_b128 v[72:75], v14 offset:38912
		ds_read_b128 v[76:79], v14 offset:39936
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v12, 10, v1
		v_add_u32_e32 v1, 0x20000, v12
		v_accvgpr_read_b32 v12, a1
		v_lshlrev_b32_e32 v13, 2, v12
		v_add_u32_e32 v14, v1, v13
		ds_read_b32 v1, v14
		ds_read_b32 v13, v14 offset:256
		ds_read_b32 v15, v14 offset:512
		ds_read_b32 v80, v14 offset:768
		v_lshlrev_b32_e32 v14, 2, v12
		v_add_u32_e32 v81, 0x20000, v14
		v_lshlrev_b32_e32 v14, 10, v11
		v_add_u32_e32 v82, v81, v14
		ds_read_b32 v14, v82 offset:2048
		ds_read_b32 v81, v82 offset:2304
		ds_read_b32 v83, v82 offset:2560
		ds_read_b32 v84, v82 offset:2816
		s_waitcnt lgkmcnt(0)
		s_add_i32 s45, s9, 0x80
		v_add_u32_e32 v82, s45, v2
		v_add3_u32 v85, v82, v3, v8
		s_add_i32 s45, s9, 0x40080
		v_add_u32_e32 v82, s45, v2
		v_add3_u32 v86, v82, v3, v8
		s_add_i32 s45, s9, 0x80080
		v_add_u32_e32 v82, s45, v2
		v_add3_u32 v87, v82, v3, v8
		s_add_i32 s45, s9, 0xc0080
		v_add_u32_e32 v82, s45, v2
		v_add3_u32 v88, v82, v3, v8
		s_add_i32 s45, s9, 0xc0
		v_add_u32_e32 v82, s45, v2
		v_add3_u32 v89, v82, v3, v8
		s_add_i32 s45, s9, 0x400c0
		v_add_u32_e32 v82, s45, v2
		v_add3_u32 v90, v82, v3, v8
		s_add_i32 s45, s9, 0x800c0
		v_add_u32_e32 v82, s45, v2
		v_add3_u32 v91, v82, v3, v8
		s_add_i32 s45, s9, 0xc00c0
		v_add_u32_e32 v82, s45, v2
		v_add3_u32 v92, v82, v3, v8
		s_add_i32 s45, s10, 0x80
		v_add_u32_e32 v82, s45, v2
		v_add3_u32 v93, v82, v3, v8
		s_add_i32 s45, s10, 0x40080
		v_add_u32_e32 v82, s45, v2
		v_add3_u32 v94, v82, v3, v8
		s_add_i32 s45, s10, 0x80080
		v_add_u32_e32 v82, s45, v2
		v_add3_u32 v95, v82, v3, v8
		s_add_i32 s45, s10, 0xc0080
		v_add_u32_e32 v82, s45, v2
		v_add3_u32 v96, v82, v3, v8
		s_add_i32 s45, s10, 0xc0
		v_add_u32_e32 v82, s45, v2
		v_add3_u32 v97, v82, v3, v8
		s_add_i32 s45, s10, 0x400c0
		v_add_u32_e32 v82, s45, v2
		v_add3_u32 v98, v82, v3, v8
		s_add_i32 s45, s10, 0x800c0
		v_add_u32_e32 v82, s45, v2
		v_add3_u32 v99, v82, v3, v8
		s_add_i32 s45, s10, 0xc00c0
		v_add_u32_e32 v82, s45, v2
		v_add3_u32 v2, v82, v3, v8
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
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 10, v2
		v_add3_u32 v2, s9, v3, v9
		s_add_i32 s43, s8, 0x1000
		v_lshlrev_b32_e32 v3, 10, v11
		v_add3_u32 v8, s9, v9, v3
		s_add_i32 s9, s11, 0x1800
		s_add_i32 m0, s8, 0x21000
		s_nop 0
		buffer_load_dwordx4 v2, s[4:7], 0 offen lds
		s_add_i32 m0, s11, 0x21800
		s_nop 0
		buffer_load_dwordx4 v8, s[24:27], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s11, s12, 1
		v_mov_b32_e32 v2, s11
		s_mov_b32 s11, 2
		v_mov_b32_e32 v8, s13
		v_mov_b32_e32 v9, 0
		s_mov_b32 s60, 0x100000
		s_mov_b32 s61, 0
		v_mov_b32_e32 v86, s60
		v_mov_b32_e32 v87, s61
		v_mul_lo_u32 v88, v86, v8
		v_mul_hi_u32 v89, v86, v8
		v_mul_lo_u32 v3, v86, v9
		v_add_u32_e32 v89, v89, v3
		v_mul_lo_u32 v3, v87, v8
		v_add_u32_e32 v89, v89, v3
		s_mov_b32 s60, 1
		s_mov_b32 s61, 0
		v_mov_b32_e32 v90, v0
		v_mov_b32_e32 v91, 0
		v_mov_b32_e32 v92, s60
		v_mov_b32_e32 v93, s61
		v_mul_lo_u32 v94, v92, v90
		v_mul_hi_u32 v95, v92, v90
		v_mul_lo_u32 v3, v92, v91
		v_add_u32_e32 v95, v95, v3
		v_mul_lo_u32 v3, v93, v90
		v_add_u32_e32 v95, v95, v3
		v_lshrrev_b64 v[96:97], 6, v[94:95]
		s_mov_b32 s60, 0x10000
		s_mov_b32 s61, 0
		v_mov_b32_e32 v98, s60
		v_mov_b32_e32 v99, s61
		v_mul_lo_u32 v100, v98, v96
		v_mul_hi_u32 v101, v98, v96
		v_mul_lo_u32 v3, v98, v97
		v_add_u32_e32 v101, v101, v3
		v_mul_lo_u32 v3, v99, v96
		v_add_u32_e32 v101, v101, v3
		v_add_co_u32_e64 v102, vcc, v88, v100
		v_addc_co_u32_e64 v103, vcc, v89, v101, vcc
		v_mov_b32_e32 v3, 63
		v_and_b32_e32 v104, v90, v3
		v_and_b32_e32 v105, v9, v9
		v_mul_lo_u32 v90, v92, v104
		v_mul_hi_u32 v91, v92, v104
		v_mul_lo_u32 v3, v92, v105
		v_add_u32_e32 v91, v91, v3
		v_mul_lo_u32 v3, v93, v104
		v_add_u32_e32 v91, v91, v3
		v_lshrrev_b64 v[92:93], 2, v[90:91]
		s_mov_b32 s60, 0x1000
		s_mov_b32 s61, 0
		v_mov_b32_e32 v106, s60
		v_mov_b32_e32 v107, s61
		v_mul_lo_u32 v108, v106, v92
		v_mul_hi_u32 v109, v106, v92
		v_mul_lo_u32 v3, v106, v93
		v_add_u32_e32 v109, v109, v3
		v_mul_lo_u32 v3, v107, v92
		v_add_u32_e32 v109, v109, v3
		v_add_co_u32_e64 v92, vcc, v102, v108
		v_addc_co_u32_e64 v93, vcc, v103, v109, vcc
		v_lshrrev_b64 v[102:103], 3, v[90:91]
		v_mov_b32_e32 v3, 3
		v_and_b32_e32 v90, v102, v3
		v_and_b32_e32 v91, v103, v9
		v_and_b32_e32 v102, v104, v3
		v_and_b32_e32 v103, v105, v9
		v_xor_b32_e32 v106, v90, v102
		v_xor_b32_e32 v107, v91, v103
		s_mov_b32 s60, 16
		s_mov_b32 s61, 0
		v_mov_b32_e32 v90, s60
		v_mov_b32_e32 v91, s61
		v_mul_lo_u32 v102, v90, v106
		v_mul_hi_u32 v103, v90, v106
		v_mul_lo_u32 v3, v90, v107
		v_add_u32_e32 v103, v103, v3
		v_mul_lo_u32 v3, v91, v106
		v_add_u32_e32 v103, v103, v3
		v_add_co_u32_e64 v106, vcc, v92, v102
		v_addc_co_u32_e64 v107, vcc, v93, v103, vcc
		v_accvgpr_write_b32 a2, v106
		v_accvgpr_write_b32 a3, v107
		v_accvgpr_read_b32 v92, a2
		v_accvgpr_read_b32 v93, a3
		s_mov_b32 s60, 0
		scratch_store_dword off, v92, s60 offset:552
		scratch_store_dword off, v93, s60 offset:556
		s_mov_b32 s60, 0x80
		s_mov_b32 s61, 0
		v_mov_b32_e32 v92, s60
		v_mov_b32_e32 v93, s61
		v_lshlrev_b32_e32 v3, 2, v0
		ds_write_b32 v3, v92
		v_lshlrev_b32_e32 v3, 2, v0
		ds_write_b32 v3, v93 offset:1024
		v_mov_b32_e32 v3, 0x40000
		v_add_co_u32_e64 v92, vcc, v88, v3
		v_addc_co_u32_e64 v93, vcc, v89, 0, vcc
		v_add_co_u32_e64 v106, vcc, v92, v100
		v_addc_co_u32_e64 v107, vcc, v93, v101, vcc
		v_add_co_u32_e64 v92, vcc, v106, v108
		v_addc_co_u32_e64 v93, vcc, v107, v109, vcc
		v_add_co_u32_e64 v106, vcc, v92, v102
		v_addc_co_u32_e64 v107, vcc, v93, v103, vcc
		v_lshlrev_b32_e32 v8, 2, v0
		ds_write_b32 v8, v106 offset:2048
		v_lshlrev_b32_e32 v8, 2, v0
		ds_write_b32 v8, v107 offset:3072
		v_mov_b32_e32 v8, 0x80000
		v_add_co_u32_e64 v92, vcc, v88, v8
		v_addc_co_u32_e64 v93, vcc, v89, 0, vcc
		v_add_co_u32_e64 v106, vcc, v92, v100
		v_addc_co_u32_e64 v107, vcc, v93, v101, vcc
		v_add_co_u32_e64 v92, vcc, v106, v108
		v_addc_co_u32_e64 v93, vcc, v107, v109, vcc
		v_add_co_u32_e64 v106, vcc, v92, v102
		v_addc_co_u32_e64 v107, vcc, v93, v103, vcc
		v_lshlrev_b32_e32 v82, 2, v0
		ds_write_b32 v82, v106 offset:4096
		v_lshlrev_b32_e32 v82, 2, v0
		ds_write_b32 v82, v107 offset:5120
		v_mov_b32_e32 v82, 0xc0000
		v_add_co_u32_e64 v92, vcc, v88, v82
		v_addc_co_u32_e64 v93, vcc, v89, 0, vcc
		v_add_co_u32_e64 v106, vcc, v92, v100
		v_addc_co_u32_e64 v107, vcc, v93, v101, vcc
		v_add_co_u32_e64 v92, vcc, v106, v108
		v_addc_co_u32_e64 v93, vcc, v107, v109, vcc
		v_add_co_u32_e64 v106, vcc, v92, v102
		v_addc_co_u32_e64 v107, vcc, v93, v103, vcc
		v_lshlrev_b32_e32 v85, 2, v0
		ds_write_b32 v85, v106 offset:6144
		v_lshlrev_b32_e32 v85, 2, v0
		ds_write_b32 v85, v107 offset:7168
		v_mov_b32_e32 v85, 64
		v_add_co_u32_e64 v92, vcc, v88, v85
		v_addc_co_u32_e64 v93, vcc, v89, 0, vcc
		v_add_co_u32_e64 v106, vcc, v92, v100
		v_addc_co_u32_e64 v107, vcc, v93, v101, vcc
		v_add_co_u32_e64 v92, vcc, v106, v108
		v_addc_co_u32_e64 v93, vcc, v107, v109, vcc
		v_add_co_u32_e64 v106, vcc, v92, v102
		v_addc_co_u32_e64 v107, vcc, v93, v103, vcc
		v_lshlrev_b32_e32 v92, 2, v0
		ds_write_b32 v92, v106 offset:8192
		v_lshlrev_b32_e32 v92, 2, v0
		ds_write_b32 v92, v107 offset:9216
		v_mov_b32_e32 v92, 0x40040
		v_add_co_u32_e64 v106, vcc, v88, v92
		v_addc_co_u32_e64 v107, vcc, v89, 0, vcc
		v_add_co_u32_e64 v110, vcc, v106, v100
		v_addc_co_u32_e64 v111, vcc, v107, v101, vcc
		v_add_co_u32_e64 v106, vcc, v110, v108
		v_addc_co_u32_e64 v107, vcc, v111, v109, vcc
		v_add_co_u32_e64 v110, vcc, v106, v102
		v_addc_co_u32_e64 v111, vcc, v107, v103, vcc
		v_lshlrev_b32_e32 v93, 2, v0
		ds_write_b32 v93, v110 offset:10240
		v_lshlrev_b32_e32 v93, 2, v0
		ds_write_b32 v93, v111 offset:11264
		v_mov_b32_e32 v93, 0x80040
		v_add_co_u32_e64 v106, vcc, v88, v93
		v_addc_co_u32_e64 v107, vcc, v89, 0, vcc
		v_add_co_u32_e64 v110, vcc, v106, v100
		v_addc_co_u32_e64 v111, vcc, v107, v101, vcc
		v_add_co_u32_e64 v106, vcc, v110, v108
		v_addc_co_u32_e64 v107, vcc, v111, v109, vcc
		v_add_co_u32_e64 v110, vcc, v106, v102
		v_addc_co_u32_e64 v111, vcc, v107, v103, vcc
		v_lshlrev_b32_e32 v106, 2, v0
		ds_write_b32 v106, v110 offset:12288
		v_lshlrev_b32_e32 v106, 2, v0
		ds_write_b32 v106, v111 offset:13312
		v_mov_b32_e32 v106, 0xc0040
		v_add_co_u32_e64 v110, vcc, v88, v106
		v_addc_co_u32_e64 v111, vcc, v89, 0, vcc
		v_add_co_u32_e64 v112, vcc, v110, v100
		v_addc_co_u32_e64 v113, vcc, v111, v101, vcc
		v_add_co_u32_e64 v110, vcc, v112, v108
		v_addc_co_u32_e64 v111, vcc, v113, v109, vcc
		v_add_co_u32_e64 v112, vcc, v110, v102
		v_addc_co_u32_e64 v113, vcc, v111, v103, vcc
		v_lshlrev_b32_e32 v107, 2, v0
		ds_write_b32 v107, v112 offset:14336
		v_lshlrev_b32_e32 v107, 2, v0
		ds_write_b32 v107, v113 offset:15360
		v_mov_b32_e32 v110, s14
		v_mov_b32_e32 v111, 0
		v_mul_lo_u32 v112, v86, v110
		v_mul_hi_u32 v113, v86, v110
		v_mul_lo_u32 v107, v86, v111
		v_add_u32_e32 v113, v113, v107
		v_mul_lo_u32 v107, v87, v110
		v_add_u32_e32 v113, v113, v107
		v_add_co_u32_e64 v86, vcc, v112, v100
		v_addc_co_u32_e64 v87, vcc, v113, v101, vcc
		v_add_co_u32_e64 v114, vcc, v86, v108
		v_addc_co_u32_e64 v115, vcc, v87, v109, vcc
		v_add_co_u32_e64 v86, vcc, v114, v102
		v_addc_co_u32_e64 v87, vcc, v115, v103, vcc
		v_lshlrev_b32_e32 v107, 2, v0
		ds_write_b32 v107, v86 offset:16384
		v_lshlrev_b32_e32 v86, 2, v0
		ds_write_b32 v86, v87 offset:17408
		v_add_co_u32_e64 v86, vcc, v112, v3
		v_addc_co_u32_e64 v87, vcc, v113, 0, vcc
		v_add_co_u32_e64 v114, vcc, v86, v100
		v_addc_co_u32_e64 v115, vcc, v87, v101, vcc
		v_add_co_u32_e64 v86, vcc, v114, v108
		v_addc_co_u32_e64 v87, vcc, v115, v109, vcc
		v_add_co_u32_e64 v114, vcc, v86, v102
		v_addc_co_u32_e64 v115, vcc, v87, v103, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_write_b32 v3, v114 offset:18432
		v_lshlrev_b32_e32 v3, 2, v0
		ds_write_b32 v3, v115 offset:19456
		v_add_co_u32_e64 v86, vcc, v112, v8
		v_addc_co_u32_e64 v87, vcc, v113, 0, vcc
		v_add_co_u32_e64 v114, vcc, v86, v100
		v_addc_co_u32_e64 v115, vcc, v87, v101, vcc
		v_add_co_u32_e64 v86, vcc, v114, v108
		v_addc_co_u32_e64 v87, vcc, v115, v109, vcc
		v_add_co_u32_e64 v114, vcc, v86, v102
		v_addc_co_u32_e64 v115, vcc, v87, v103, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_write_b32 v3, v114 offset:20480
		v_lshlrev_b32_e32 v3, 2, v0
		ds_write_b32 v3, v115 offset:21504
		v_add_co_u32_e64 v86, vcc, v112, v82
		v_addc_co_u32_e64 v87, vcc, v113, 0, vcc
		v_add_co_u32_e64 v114, vcc, v86, v100
		v_addc_co_u32_e64 v115, vcc, v87, v101, vcc
		v_add_co_u32_e64 v86, vcc, v114, v108
		v_addc_co_u32_e64 v87, vcc, v115, v109, vcc
		v_add_co_u32_e64 v114, vcc, v86, v102
		v_addc_co_u32_e64 v115, vcc, v87, v103, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_write_b32 v3, v114 offset:22528
		v_lshlrev_b32_e32 v3, 2, v0
		ds_write_b32 v3, v115 offset:23552
		v_add_co_u32_e64 v86, vcc, v112, v85
		v_addc_co_u32_e64 v87, vcc, v113, 0, vcc
		v_add_co_u32_e64 v114, vcc, v86, v100
		v_addc_co_u32_e64 v115, vcc, v87, v101, vcc
		v_add_co_u32_e64 v86, vcc, v114, v108
		v_addc_co_u32_e64 v87, vcc, v115, v109, vcc
		v_add_co_u32_e64 v114, vcc, v86, v102
		v_addc_co_u32_e64 v115, vcc, v87, v103, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v114, s60
		scratch_store_dword off, v115, s60 offset:4
		v_add_co_u32_e64 v86, vcc, v112, v92
		v_addc_co_u32_e64 v87, vcc, v113, 0, vcc
		v_add_co_u32_e64 v114, vcc, v86, v100
		v_addc_co_u32_e64 v115, vcc, v87, v101, vcc
		v_add_co_u32_e64 v86, vcc, v114, v108
		v_addc_co_u32_e64 v87, vcc, v115, v109, vcc
		v_add_co_u32_e64 v114, vcc, v86, v102
		v_addc_co_u32_e64 v115, vcc, v87, v103, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v114, s60 offset:8
		scratch_store_dword off, v115, s60 offset:12
		v_add_co_u32_e64 v86, vcc, v112, v93
		v_addc_co_u32_e64 v87, vcc, v113, 0, vcc
		v_add_co_u32_e64 v92, vcc, v86, v100
		v_addc_co_u32_e64 v93, vcc, v87, v101, vcc
		v_add_co_u32_e64 v86, vcc, v92, v108
		v_addc_co_u32_e64 v87, vcc, v93, v109, vcc
		v_add_co_u32_e64 v92, vcc, v86, v102
		v_addc_co_u32_e64 v93, vcc, v87, v103, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v92, s60 offset:16
		scratch_store_dword off, v93, s60 offset:20
		v_add_co_u32_e64 v86, vcc, v112, v106
		v_addc_co_u32_e64 v87, vcc, v113, 0, vcc
		v_add_co_u32_e64 v92, vcc, v86, v100
		v_addc_co_u32_e64 v93, vcc, v87, v101, vcc
		v_add_co_u32_e64 v86, vcc, v92, v108
		v_addc_co_u32_e64 v87, vcc, v93, v109, vcc
		v_add_co_u32_e64 v92, vcc, v86, v102
		v_addc_co_u32_e64 v93, vcc, v87, v103, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v92, s60 offset:24
		scratch_store_dword off, v93, s60 offset:28
		v_mul_lo_u32 v86, v98, v110
		v_mul_hi_u32 v87, v98, v110
		v_mul_lo_u32 v3, v98, v111
		v_add_u32_e32 v87, v87, v3
		v_mul_lo_u32 v3, v99, v110
		v_add_u32_e32 v87, v87, v3
		v_add_co_u32_e64 v92, vcc, v88, v86
		v_addc_co_u32_e64 v93, vcc, v89, v87, vcc
		v_lshrrev_b64 v[98:99], 7, v[94:95]
		s_mov_b32 s60, 0x400
		s_mov_b32 s61, 0
		v_mov_b32_e32 v94, s60
		v_mov_b32_e32 v95, s61
		v_mul_lo_u32 v106, v94, v98
		v_mul_hi_u32 v107, v94, v98
		v_mul_lo_u32 v3, v94, v99
		v_add_u32_e32 v107, v107, v3
		v_mul_lo_u32 v3, v95, v98
		v_add_u32_e32 v107, v107, v3
		v_add_co_u32_e64 v98, vcc, v92, v106
		v_addc_co_u32_e64 v99, vcc, v93, v107, vcc
		v_mul_lo_u32 v110, v90, v104
		v_mul_hi_u32 v111, v90, v104
		v_mul_lo_u32 v3, v90, v105
		v_add_u32_e32 v111, v111, v3
		v_mul_lo_u32 v3, v91, v104
		v_add_u32_e32 v111, v111, v3
		v_add_co_u32_e64 v90, vcc, v98, v110
		v_addc_co_u32_e64 v91, vcc, v99, v111, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v90, s60 offset:32
		scratch_store_dword off, v91, s60 offset:36
		s_mov_b32 s60, 0x800
		s_mov_b32 s61, 0
		v_mov_b32_e32 v90, s60
		v_mov_b32_e32 v91, s61
		s_mov_b32 s60, 0
		scratch_store_dword off, v90, s60 offset:40
		scratch_store_dword off, v91, s60 offset:44
		v_add_co_u32_e64 v90, vcc, v92, v110
		v_addc_co_u32_e64 v91, vcc, v93, v111, vcc
		v_mov_b32_e32 v3, 1
		v_and_b32_e32 v92, v96, v3
		v_and_b32_e32 v93, v97, v9
		v_mul_lo_u32 v8, v94, v92
		v_mul_hi_u32 v9, v94, v92
		v_mul_lo_u32 v3, v94, v93
		v_add_u32_e32 v9, v9, v3
		v_mul_lo_u32 v3, v95, v92
		v_add_u32_e32 v9, v9, v3
		v_add_co_u32_e64 v92, vcc, v90, v8
		v_addc_co_u32_e64 v93, vcc, v91, v9, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v92, s60 offset:48
		scratch_store_dword off, v93, s60 offset:52
		v_mov_b32_e32 v3, 0x80
		v_add_co_u32_e64 v90, vcc, v88, v3
		v_addc_co_u32_e64 v91, vcc, v89, 0, vcc
		v_add_co_u32_e64 v92, vcc, v90, v100
		v_addc_co_u32_e64 v93, vcc, v91, v101, vcc
		v_add_co_u32_e64 v90, vcc, v92, v108
		v_addc_co_u32_e64 v91, vcc, v93, v109, vcc
		v_add_co_u32_e64 v92, vcc, v90, v102
		v_addc_co_u32_e64 v93, vcc, v91, v103, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v92, s60 offset:56
		scratch_store_dword off, v93, s60 offset:60
		v_mov_b32_e32 v82, 0x40080
		v_add_co_u32_e64 v90, vcc, v88, v82
		v_addc_co_u32_e64 v91, vcc, v89, 0, vcc
		v_add_co_u32_e64 v92, vcc, v90, v100
		v_addc_co_u32_e64 v93, vcc, v91, v101, vcc
		v_add_co_u32_e64 v90, vcc, v92, v108
		v_addc_co_u32_e64 v91, vcc, v93, v109, vcc
		v_add_co_u32_e64 v92, vcc, v90, v102
		v_addc_co_u32_e64 v93, vcc, v91, v103, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v92, s60 offset:64
		scratch_store_dword off, v93, s60 offset:68
		v_mov_b32_e32 v85, 0x80080
		v_add_co_u32_e64 v90, vcc, v88, v85
		v_addc_co_u32_e64 v91, vcc, v89, 0, vcc
		v_add_co_u32_e64 v92, vcc, v90, v100
		v_addc_co_u32_e64 v93, vcc, v91, v101, vcc
		v_add_co_u32_e64 v90, vcc, v92, v108
		v_addc_co_u32_e64 v91, vcc, v93, v109, vcc
		v_add_co_u32_e64 v92, vcc, v90, v102
		v_addc_co_u32_e64 v93, vcc, v91, v103, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v92, s60 offset:72
		scratch_store_dword off, v93, s60 offset:76
		v_mov_b32_e32 v90, 0xc0080
		v_add_co_u32_e64 v92, vcc, v88, v90
		v_addc_co_u32_e64 v93, vcc, v89, 0, vcc
		v_add_co_u32_e64 v94, vcc, v92, v100
		v_addc_co_u32_e64 v95, vcc, v93, v101, vcc
		v_add_co_u32_e64 v92, vcc, v94, v108
		v_addc_co_u32_e64 v93, vcc, v95, v109, vcc
		v_add_co_u32_e64 v94, vcc, v92, v102
		v_addc_co_u32_e64 v95, vcc, v93, v103, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v94, s60 offset:80
		scratch_store_dword off, v95, s60 offset:84
		v_mov_b32_e32 v91, 0xc0
		v_add_co_u32_e64 v92, vcc, v88, v91
		v_addc_co_u32_e64 v93, vcc, v89, 0, vcc
		v_add_co_u32_e64 v94, vcc, v92, v100
		v_addc_co_u32_e64 v95, vcc, v93, v101, vcc
		v_add_co_u32_e64 v92, vcc, v94, v108
		v_addc_co_u32_e64 v93, vcc, v95, v109, vcc
		v_add_co_u32_e64 v94, vcc, v92, v102
		v_addc_co_u32_e64 v95, vcc, v93, v103, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v94, s60 offset:88
		scratch_store_dword off, v95, s60 offset:92
		v_mov_b32_e32 v92, 0x400c0
		v_add_co_u32_e64 v94, vcc, v88, v92
		v_addc_co_u32_e64 v95, vcc, v89, 0, vcc
		v_add_co_u32_e64 v96, vcc, v94, v100
		v_addc_co_u32_e64 v97, vcc, v95, v101, vcc
		v_add_co_u32_e64 v94, vcc, v96, v108
		v_addc_co_u32_e64 v95, vcc, v97, v109, vcc
		v_add_co_u32_e64 v96, vcc, v94, v102
		v_addc_co_u32_e64 v97, vcc, v95, v103, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v96, s60 offset:96
		scratch_store_dword off, v97, s60 offset:100
		v_mov_b32_e32 v93, 0x800c0
		v_add_co_u32_e64 v94, vcc, v88, v93
		v_addc_co_u32_e64 v95, vcc, v89, 0, vcc
		v_add_co_u32_e64 v96, vcc, v94, v100
		v_addc_co_u32_e64 v97, vcc, v95, v101, vcc
		v_add_co_u32_e64 v94, vcc, v96, v108
		v_addc_co_u32_e64 v95, vcc, v97, v109, vcc
		v_add_co_u32_e64 v96, vcc, v94, v102
		v_addc_co_u32_e64 v97, vcc, v95, v103, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v96, s60 offset:104
		scratch_store_dword off, v97, s60 offset:108
		v_mov_b32_e32 v94, 0xc00c0
		v_add_co_u32_e64 v96, vcc, v88, v94
		v_addc_co_u32_e64 v97, vcc, v89, 0, vcc
		v_add_co_u32_e64 v98, vcc, v96, v100
		v_addc_co_u32_e64 v99, vcc, v97, v101, vcc
		v_add_co_u32_e64 v96, vcc, v98, v108
		v_addc_co_u32_e64 v97, vcc, v99, v109, vcc
		v_add_co_u32_e64 v98, vcc, v96, v102
		v_addc_co_u32_e64 v99, vcc, v97, v103, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v98, s60 offset:112
		scratch_store_dword off, v99, s60 offset:116
		v_add_co_u32_e64 v96, vcc, v112, v3
		v_addc_co_u32_e64 v97, vcc, v113, 0, vcc
		v_add_co_u32_e64 v98, vcc, v96, v100
		v_addc_co_u32_e64 v99, vcc, v97, v101, vcc
		v_add_co_u32_e64 v96, vcc, v98, v108
		v_addc_co_u32_e64 v97, vcc, v99, v109, vcc
		v_add_co_u32_e64 v98, vcc, v96, v102
		v_addc_co_u32_e64 v99, vcc, v97, v103, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v98, s60 offset:120
		scratch_store_dword off, v99, s60 offset:124
		v_add_co_u32_e64 v96, vcc, v112, v82
		v_addc_co_u32_e64 v97, vcc, v113, 0, vcc
		v_add_co_u32_e64 v98, vcc, v96, v100
		v_addc_co_u32_e64 v99, vcc, v97, v101, vcc
		v_add_co_u32_e64 v96, vcc, v98, v108
		v_addc_co_u32_e64 v97, vcc, v99, v109, vcc
		v_add_co_u32_e64 v98, vcc, v96, v102
		v_addc_co_u32_e64 v99, vcc, v97, v103, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v98, s60 offset:128
		scratch_store_dword off, v99, s60 offset:132
		v_add_co_u32_e64 v96, vcc, v112, v85
		v_addc_co_u32_e64 v97, vcc, v113, 0, vcc
		v_add_co_u32_e64 v98, vcc, v96, v100
		v_addc_co_u32_e64 v99, vcc, v97, v101, vcc
		v_add_co_u32_e64 v96, vcc, v98, v108
		v_addc_co_u32_e64 v97, vcc, v99, v109, vcc
		v_add_co_u32_e64 v98, vcc, v96, v102
		v_addc_co_u32_e64 v99, vcc, v97, v103, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v98, s60 offset:136
		scratch_store_dword off, v99, s60 offset:140
		v_add_co_u32_e64 v96, vcc, v112, v90
		v_addc_co_u32_e64 v97, vcc, v113, 0, vcc
		v_add_co_u32_e64 v98, vcc, v96, v100
		v_addc_co_u32_e64 v99, vcc, v97, v101, vcc
		v_add_co_u32_e64 v96, vcc, v98, v108
		v_addc_co_u32_e64 v97, vcc, v99, v109, vcc
		v_add_co_u32_e64 v98, vcc, v96, v102
		v_addc_co_u32_e64 v99, vcc, v97, v103, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v98, s60 offset:144
		scratch_store_dword off, v99, s60 offset:148
		v_add_co_u32_e64 v96, vcc, v112, v91
		v_addc_co_u32_e64 v97, vcc, v113, 0, vcc
		v_add_co_u32_e64 v90, vcc, v96, v100
		v_addc_co_u32_e64 v91, vcc, v97, v101, vcc
		v_add_co_u32_e64 v96, vcc, v90, v108
		v_addc_co_u32_e64 v97, vcc, v91, v109, vcc
		v_add_co_u32_e64 v90, vcc, v96, v102
		v_addc_co_u32_e64 v91, vcc, v97, v103, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v90, s60 offset:152
		scratch_store_dword off, v91, s60 offset:156
		v_add_co_u32_e64 v90, vcc, v112, v92
		v_addc_co_u32_e64 v91, vcc, v113, 0, vcc
		v_add_co_u32_e64 v96, vcc, v90, v100
		v_addc_co_u32_e64 v97, vcc, v91, v101, vcc
		v_add_co_u32_e64 v90, vcc, v96, v108
		v_addc_co_u32_e64 v91, vcc, v97, v109, vcc
		v_add_co_u32_e64 v96, vcc, v90, v102
		v_addc_co_u32_e64 v97, vcc, v91, v103, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v96, s60 offset:160
		scratch_store_dword off, v97, s60 offset:164
		v_add_co_u32_e64 v90, vcc, v112, v93
		v_addc_co_u32_e64 v91, vcc, v113, 0, vcc
		v_add_co_u32_e64 v92, vcc, v90, v100
		v_addc_co_u32_e64 v93, vcc, v91, v101, vcc
		v_add_co_u32_e64 v90, vcc, v92, v108
		v_addc_co_u32_e64 v91, vcc, v93, v109, vcc
		v_add_co_u32_e64 v92, vcc, v90, v102
		v_addc_co_u32_e64 v93, vcc, v91, v103, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v92, s60 offset:168
		scratch_store_dword off, v93, s60 offset:172
		v_add_co_u32_e64 v90, vcc, v112, v94
		v_addc_co_u32_e64 v91, vcc, v113, 0, vcc
		v_add_co_u32_e64 v92, vcc, v90, v100
		v_addc_co_u32_e64 v93, vcc, v91, v101, vcc
		v_add_co_u32_e64 v90, vcc, v92, v108
		v_addc_co_u32_e64 v91, vcc, v93, v109, vcc
		v_add_co_u32_e64 v92, vcc, v90, v102
		v_addc_co_u32_e64 v93, vcc, v91, v103, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v92, s60 offset:176
		scratch_store_dword off, v93, s60 offset:180
		v_mov_b32_e32 v3, 0x800
		v_add_co_u32_e64 v90, vcc, v88, v3
		v_addc_co_u32_e64 v91, vcc, v89, 0, vcc
		v_add_co_u32_e64 v88, vcc, v90, v86
		v_addc_co_u32_e64 v89, vcc, v91, v87, vcc
		v_add_co_u32_e64 v86, vcc, v88, v106
		v_addc_co_u32_e64 v87, vcc, v89, v107, vcc
		v_add_co_u32_e64 v90, vcc, v86, v110
		v_addc_co_u32_e64 v91, vcc, v87, v111, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v90, s60 offset:184
		scratch_store_dword off, v91, s60 offset:188
		v_add_co_u32_e64 v86, vcc, v88, v110
		v_addc_co_u32_e64 v87, vcc, v89, v111, vcc
		v_add_co_u32_e64 v88, vcc, v86, v8
		v_addc_co_u32_e64 v89, vcc, v87, v9, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v88, s60 offset:192
		scratch_store_dword off, v89, s60 offset:196
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
		v_mov_b32_e32 v8, s11
		v_mov_b32_e32 v9, 0
		v_lshlrev_b32_e32 v3, 2, v0
		s_waitcnt lgkmcnt(6)
		ds_read_b32 v86, v3
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v87, v3 offset:1024
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v88, v86, v8
		v_mul_hi_u32 v89, v86, v8
		v_mul_lo_u32 v3, v86, v9
		v_add_u32_e32 v89, v89, v3
		v_mul_lo_u32 v3, v87, v8
		v_add_u32_e32 v89, v89, v3
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(50)
		scratch_load_dword v86, off, s60 offset:552
		scratch_load_dword v87, off, s60 offset:556
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v90, vcc, v86, v88
		v_addc_co_u32_e64 v91, vcc, v87, v89, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v86, v3 offset:2048
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v87, v3 offset:3072
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v92, vcc, v86, v88
		v_addc_co_u32_e64 v93, vcc, v87, v89, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v86, v3 offset:4096
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v87, v3 offset:5120
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v94, vcc, v86, v88
		v_addc_co_u32_e64 v95, vcc, v87, v89, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v86, v3 offset:6144
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v87, v3 offset:7168
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v96, vcc, v86, v88
		v_addc_co_u32_e64 v97, vcc, v87, v89, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v86, v3 offset:8192
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v87, v3 offset:9216
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v98, vcc, v86, v88
		v_addc_co_u32_e64 v99, vcc, v87, v89, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v86, v3 offset:10240
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v87, v3 offset:11264
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v100, vcc, v86, v88
		v_addc_co_u32_e64 v101, vcc, v87, v89, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v86, v3 offset:12288
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v87, v3 offset:13312
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v102, vcc, v86, v88
		v_addc_co_u32_e64 v103, vcc, v87, v89, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v86, v3 offset:14336
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v87, v3 offset:15360
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v104, vcc, v86, v88
		v_addc_co_u32_e64 v105, vcc, v87, v89, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v86, v3 offset:16384
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v87, v3 offset:17408
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v106, vcc, v86, v88
		v_addc_co_u32_e64 v107, vcc, v87, v89, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v86, v3 offset:18432
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v87, v3 offset:19456
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v108, vcc, v86, v88
		v_addc_co_u32_e64 v109, vcc, v87, v89, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v86, v3 offset:20480
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v87, v3 offset:21504
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v110, vcc, v86, v88
		v_addc_co_u32_e64 v111, vcc, v87, v89, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v86, v3 offset:22528
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v87, v3 offset:23552
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v112, vcc, v86, v88
		v_addc_co_u32_e64 v113, vcc, v87, v89, vcc
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(48)
		scratch_load_dword v86, off, s60
		scratch_load_dword v87, off, s60 offset:4
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v114, vcc, v86, v88
		v_addc_co_u32_e64 v115, vcc, v87, v89, vcc
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(46)
		scratch_load_dword v86, off, s60 offset:8
		scratch_load_dword v87, off, s60 offset:12
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v116, vcc, v86, v88
		v_addc_co_u32_e64 v117, vcc, v87, v89, vcc
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(44)
		scratch_load_dword v86, off, s60 offset:16
		scratch_load_dword v87, off, s60 offset:20
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v118, vcc, v86, v88
		v_addc_co_u32_e64 v119, vcc, v87, v89, vcc
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(42)
		scratch_load_dword v86, off, s60 offset:24
		scratch_load_dword v87, off, s60 offset:28
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v120, vcc, v86, v88
		v_addc_co_u32_e64 v121, vcc, v87, v89, vcc
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(38)
		scratch_load_dword v86, off, s60 offset:40
		scratch_load_dword v87, off, s60 offset:44
		s_waitcnt vmcnt(0)
		v_mul_lo_u32 v122, v86, v8
		v_mul_hi_u32 v123, v86, v8
		v_mul_lo_u32 v3, v86, v9
		v_add_u32_e32 v123, v123, v3
		v_mul_lo_u32 v3, v87, v8
		v_add_u32_e32 v123, v123, v3
		s_mov_b32 s60, 0
		scratch_load_dword v8, off, s60 offset:32
		scratch_load_dword v9, off, s60 offset:36
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v86, vcc, v8, v122
		v_addc_co_u32_e64 v87, vcc, v9, v123, vcc
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(36)
		scratch_load_dword v8, off, s60 offset:48
		scratch_load_dword v9, off, s60 offset:52
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v124, vcc, v8, v122
		v_addc_co_u32_e64 v125, vcc, v9, v123, vcc
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[16:19], v[48:51], v[4:7], v1, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s60, s11, 1
		v_mov_b32_e32 v3, s60
		s_nop 0
		v_readfirstlane_b32 s60, v3
		s_lshl_b32 s61, s60, 16
		v_mov_b32_e32 v8, s61
		s_nop 0
		v_readfirstlane_b32 s60, v8
		v_lshrrev_b32_e32 v9, 7, v0
		v_lshlrev_b32_e32 v82, 13, v9
		v_add_u32_e32 v9, s60, v82
		v_and_b32_e32 v82, 15, v0
		v_lshlrev_b32_e32 v85, 6, v82
		v_lshlrev_b32_e32 v82, 4, v10
		v_add3_u32 v87, v9, v85, v82
		ds_read_b128 v[128:131], v87 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[16:19], v[52:55], a[4:7], v1, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[132:135], v87 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[16:19], v[56:59], a[8:11], v1, v81 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[136:139], v87 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[16:19], v[60:63], a[12:15], v1, v81 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[140:143], v87 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[16:19], v[64:67], a[16:19], v1, v83 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[144:147], v87 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[16:19], v[68:71], a[20:23], v1, v83 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[148:151], v87 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[16:19], v[72:75], a[24:27], v1, v84 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[152:155], v87 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[16:19], v[76:79], a[28:31], v1, v84 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[156:159], v87 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[20:23], v[48:51], a[32:35], v1, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_readfirstlane_b32 s60, v8
		v_and_b32_e32 v8, 15, v0
		v_lshlrev_b32_e32 v9, 6, v8
		v_add_u32_e32 v8, s60, v9
		v_lshlrev_b32_e32 v9, 13, v11
		v_lshlrev_b32_e32 v82, 4, v10
		v_add3_u32 v85, v8, v9, v82
		ds_read_b128 v[160:163], v85 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[20:23], v[52:55], a[36:39], v1, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[164:167], v85 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[20:23], v[56:59], a[40:43], v1, v81 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[168:171], v85 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[20:23], v[60:63], a[44:47], v1, v81 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[172:175], v85 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[20:23], v[64:67], a[48:51], v1, v83 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[176:179], v85 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[20:23], v[68:71], a[52:55], v1, v83 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[180:183], v85 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[20:23], v[72:75], a[56:59], v1, v84 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[184:187], v85 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[20:23], v[76:79], a[60:63], v1, v84 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[188:191], v85 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[24:27], v[48:51], a[64:67], v13, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_nop 0
		buffer_load_dwordx4 v90, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[24:27], v[52:55], a[68:71], v13, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v92, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[24:27], v[56:59], a[72:75], v13, v81 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v94, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[24:27], v[60:63], a[76:79], v13, v81 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v96, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[24:27], v[64:67], a[80:83], v13, v83 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v98, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[24:27], v[68:71], a[84:87], v13, v83 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v100, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[24:27], v[72:75], a[88:91], v13, v84 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v102, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[24:27], v[76:79], a[92:95], v13, v84 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v104, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[28:31], v[48:51], a[96:99], v13, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v106, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[28:31], v[52:55], a[100:103], v13, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v108, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[28:31], v[56:59], a[104:107], v13, v81 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s37
		s_nop 0
		buffer_load_dwordx4 v110, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[28:31], v[60:63], a[108:111], v13, v81 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v112, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[28:31], v[64:67], a[112:115], v13, v83 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v114, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[28:31], v[68:71], a[116:119], v13, v83 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s40
		s_nop 0
		buffer_load_dwordx4 v116, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[28:31], v[72:75], a[120:123], v13, v84 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s41
		s_nop 0
		buffer_load_dwordx4 v118, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[28:31], v[76:79], a[124:127], v13, v84 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s42
		s_nop 0
		buffer_load_dwordx4 v120, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[32:35], v[48:51], a[128:131], v15, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s8, 0x20000
		s_nop 0
		buffer_load_dwordx4 v86, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[32:35], v[52:55], a[132:135], v15, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s44, 0x20000
		s_nop 0
		buffer_load_dwordx4 v124, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[32:35], v[56:59], a[136:139], v15, v81 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		ds_read_b128 v[16:19], v87
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[32:35], v[60:63], a[140:143], v15, v81 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v87 offset:1024
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], v[64:67], a[144:147], v15, v83 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v87 offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[32:35], v[68:71], a[148:151], v15, v83 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[28:31], v87 offset:3072
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[32:35], v[72:75], a[152:155], v15, v84 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v87 offset:4096
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[32:35], v[76:79], a[156:159], v15, v84 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v87 offset:5120
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v96, s60 offset:560
		scratch_store_dword off, v97, s60 offset:564
		scratch_store_dword off, v98, s60 offset:568
		scratch_store_dword off, v99, s60 offset:572
		s_mov_b32 s60, 0
		scratch_store_dword off, v96, s60 offset:576
		scratch_store_dword off, v97, s60 offset:580
		scratch_store_dword off, v98, s60 offset:584
		scratch_store_dword off, v99, s60 offset:588
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], v[48:51], a[160:163], v15, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v87 offset:6144
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v96, s60 offset:520
		scratch_store_dword off, v97, s60 offset:524
		scratch_store_dword off, v98, s60 offset:528
		scratch_store_dword off, v99, s60 offset:532
		s_mov_b32 s60, 0
		scratch_store_dword off, v96, s60 offset:536
		scratch_store_dword off, v97, s60 offset:540
		scratch_store_dword off, v98, s60 offset:544
		scratch_store_dword off, v99, s60 offset:548
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[36:39], v[52:55], a[164:167], v15, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v87 offset:7168
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v96, s60 offset:488
		scratch_store_dword off, v97, s60 offset:492
		scratch_store_dword off, v98, s60 offset:496
		scratch_store_dword off, v99, s60 offset:500
		s_mov_b32 s60, 0
		scratch_store_dword off, v96, s60 offset:504
		scratch_store_dword off, v97, s60 offset:508
		scratch_store_dword off, v98, s60 offset:512
		scratch_store_dword off, v99, s60 offset:516
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[36:39], v[56:59], a[168:171], v15, v81 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v85 offset:32768
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v96, s60 offset:456
		scratch_store_dword off, v97, s60 offset:460
		scratch_store_dword off, v98, s60 offset:464
		scratch_store_dword off, v99, s60 offset:468
		s_mov_b32 s60, 0
		scratch_store_dword off, v96, s60 offset:472
		scratch_store_dword off, v97, s60 offset:476
		scratch_store_dword off, v98, s60 offset:480
		scratch_store_dword off, v99, s60 offset:484
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[36:39], v[60:63], a[172:175], v15, v81 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v85 offset:33792
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v96, s60 offset:424
		scratch_store_dword off, v97, s60 offset:428
		scratch_store_dword off, v98, s60 offset:432
		scratch_store_dword off, v99, s60 offset:436
		s_mov_b32 s60, 0
		scratch_store_dword off, v96, s60 offset:440
		scratch_store_dword off, v97, s60 offset:444
		scratch_store_dword off, v98, s60 offset:448
		scratch_store_dword off, v99, s60 offset:452
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[36:39], v[64:67], a[176:179], v15, v83 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v85 offset:34816
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v96, s60 offset:392
		scratch_store_dword off, v97, s60 offset:396
		scratch_store_dword off, v98, s60 offset:400
		scratch_store_dword off, v99, s60 offset:404
		s_mov_b32 s60, 0
		scratch_store_dword off, v96, s60 offset:408
		scratch_store_dword off, v97, s60 offset:412
		scratch_store_dword off, v98, s60 offset:416
		scratch_store_dword off, v99, s60 offset:420
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[36:39], v[68:71], a[180:183], v15, v83 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v85 offset:35840
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v96, s60 offset:360
		scratch_store_dword off, v97, s60 offset:364
		scratch_store_dword off, v98, s60 offset:368
		scratch_store_dword off, v99, s60 offset:372
		s_mov_b32 s60, 0
		scratch_store_dword off, v96, s60 offset:376
		scratch_store_dword off, v97, s60 offset:380
		scratch_store_dword off, v98, s60 offset:384
		scratch_store_dword off, v99, s60 offset:388
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[36:39], v[72:75], a[184:187], v15, v84 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v85 offset:36864
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v96, s60 offset:328
		scratch_store_dword off, v97, s60 offset:332
		scratch_store_dword off, v98, s60 offset:336
		scratch_store_dword off, v99, s60 offset:340
		s_mov_b32 s60, 0
		scratch_store_dword off, v96, s60 offset:344
		scratch_store_dword off, v97, s60 offset:348
		scratch_store_dword off, v98, s60 offset:352
		scratch_store_dword off, v99, s60 offset:356
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[36:39], v[76:79], a[188:191], v15, v84 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v85 offset:37888
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v96, s60 offset:296
		scratch_store_dword off, v97, s60 offset:300
		scratch_store_dword off, v98, s60 offset:304
		scratch_store_dword off, v99, s60 offset:308
		s_mov_b32 s60, 0
		scratch_store_dword off, v96, s60 offset:312
		scratch_store_dword off, v97, s60 offset:316
		scratch_store_dword off, v98, s60 offset:320
		scratch_store_dword off, v99, s60 offset:324
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[40:43], v[48:51], a[192:195], v80, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v85 offset:38912
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v96, s60 offset:264
		scratch_store_dword off, v97, s60 offset:268
		scratch_store_dword off, v98, s60 offset:272
		scratch_store_dword off, v99, s60 offset:276
		s_mov_b32 s60, 0
		scratch_store_dword off, v96, s60 offset:280
		scratch_store_dword off, v97, s60 offset:284
		scratch_store_dword off, v98, s60 offset:288
		scratch_store_dword off, v99, s60 offset:292
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[40:43], v[52:55], a[196:199], v80, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v85 offset:39936
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v96, s60 offset:232
		scratch_store_dword off, v97, s60 offset:236
		scratch_store_dword off, v98, s60 offset:240
		scratch_store_dword off, v99, s60 offset:244
		s_mov_b32 s60, 0
		scratch_store_dword off, v96, s60 offset:248
		scratch_store_dword off, v97, s60 offset:252
		scratch_store_dword off, v98, s60 offset:256
		scratch_store_dword off, v99, s60 offset:260
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[40:43], v[56:59], a[200:203], v80, v81 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_readfirstlane_b32 s60, v3
		s_lshl_b32 s61, s60, 12
		s_add_i32 s60, s61, 0x20000
		v_lshrrev_b32_e32 v3, 7, v0
		v_lshlrev_b32_e32 v8, 10, v3
		v_lshlrev_b32_e32 v3, 2, v12
		v_add3_u32 v9, s60, v8, v3
		ds_read_b32 v3, v9
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v3, s61 offset:228
		ds_read_b32 v3, v9 offset:256
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v3, s61 offset:224
		ds_read_b32 v3, v9 offset:512
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v3, s61 offset:220
		ds_read_b32 v3, v9 offset:768
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v3, s61 offset:216
		v_lshlrev_b32_e32 v3, 10, v11
		v_lshlrev_b32_e32 v8, 2, v12
		v_add3_u32 v9, s60, v8, v3
		ds_read_b32 v3, v9 offset:2048
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v3, s60 offset:212
		ds_read_b32 v3, v9 offset:2304
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v3, s60 offset:208
		ds_read_b32 v3, v9 offset:2560
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v3, s60 offset:204
		ds_read_b32 v3, v9 offset:2816
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v3, s60 offset:200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[40:43], v[60:63], a[204:207], v80, v81 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[40:43], v[64:67], a[208:211], v80, v83 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[40:43], v[68:71], a[212:215], v80, v83 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[40:43], v[72:75], a[216:219], v80, v84 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[40:43], v[76:79], a[220:223], v80, v84 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[44:47], v[48:51], a[224:227], v80, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[44:47], v[52:55], a[228:231], v80, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[44:47], v[56:59], a[232:235], v80, v81 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[44:47], v[60:63], a[236:239], v80, v81 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[44:47], v[64:67], a[240:243], v80, v83 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[44:47], v[68:71], a[244:247], v80, v83 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[44:47], v[72:75], a[248:251], v80, v84 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[44:47], v[76:79], a[252:255], v80, v84 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[128:131], v[160:163], v[4:7], v1, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[128:131], v[164:167], a[4:7], v1, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[128:131], v[168:171], a[8:11], v1, v81 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[128:131], v[172:175], a[12:15], v1, v81 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[128:131], v[176:179], a[16:19], v1, v83 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[128:131], v[180:183], a[20:23], v1, v83 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[128:131], v[184:187], a[24:27], v1, v84 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[128:131], v[188:191], a[28:31], v1, v84 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[132:135], v[160:163], a[32:35], v1, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[132:135], v[164:167], a[36:39], v1, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[132:135], v[168:171], a[40:43], v1, v81 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[132:135], v[172:175], a[44:47], v1, v81 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[132:135], v[176:179], a[48:51], v1, v83 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[132:135], v[180:183], a[52:55], v1, v83 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[132:135], v[184:187], a[56:59], v1, v84 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[132:135], v[188:191], a[60:63], v1, v84 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[136:139], v[160:163], a[64:67], v13, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[136:139], v[164:167], a[68:71], v13, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[136:139], v[168:171], a[72:75], v13, v81 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[136:139], v[172:175], a[76:79], v13, v81 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[136:139], v[176:179], a[80:83], v13, v83 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[136:139], v[180:183], a[84:87], v13, v83 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[136:139], v[184:187], a[88:91], v13, v84 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[136:139], v[188:191], a[92:95], v13, v84 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[140:143], v[160:163], a[96:99], v13, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[140:143], v[164:167], a[100:103], v13, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[140:143], v[168:171], a[104:107], v13, v81 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[140:143], v[172:175], a[108:111], v13, v81 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[140:143], v[176:179], a[112:115], v13, v83 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[140:143], v[180:183], a[116:119], v13, v83 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[140:143], v[184:187], a[120:123], v13, v84 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[140:143], v[188:191], a[124:127], v13, v84 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[144:147], v[160:163], a[128:131], v15, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[144:147], v[164:167], a[132:135], v15, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[144:147], v[168:171], a[136:139], v15, v81 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[144:147], v[172:175], a[140:143], v15, v81 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[144:147], v[176:179], a[144:147], v15, v83 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[144:147], v[180:183], a[148:151], v15, v83 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[144:147], v[184:187], a[152:155], v15, v84 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[144:147], v[188:191], a[156:159], v15, v84 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[148:151], v[160:163], a[160:163], v15, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[148:151], v[164:167], a[164:167], v15, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[148:151], v[168:171], a[168:171], v15, v81 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[148:151], v[172:175], a[172:175], v15, v81 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[148:151], v[176:179], a[176:179], v15, v83 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[148:151], v[180:183], a[180:183], v15, v83 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[148:151], v[184:187], a[184:187], v15, v84 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[148:151], v[188:191], a[188:191], v15, v84 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[152:155], v[160:163], a[192:195], v80, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[152:155], v[164:167], a[196:199], v80, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[152:155], v[168:171], a[200:203], v80, v81 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[152:155], v[172:175], a[204:207], v80, v81 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[152:155], v[176:179], a[208:211], v80, v83 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[152:155], v[180:183], a[212:215], v80, v83 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[152:155], v[184:187], a[216:219], v80, v84 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[152:155], v[188:191], a[220:223], v80, v84 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[156:159], v[160:163], a[224:227], v80, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[156:159], v[164:167], a[228:231], v80, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[156:159], v[168:171], a[232:235], v80, v81 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[156:159], v[172:175], a[236:239], v80, v81 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[156:159], v[176:179], a[240:243], v80, v83 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[156:159], v[180:183], a[244:247], v80, v83 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[156:159], v[184:187], a[248:251], v80, v84 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[156:159], v[188:191], a[252:255], v80, v84 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s60, s11, 1
		s_and_b32 s61, s60, 1
		s_lshl_b32 s60, s61, 16
		v_lshrrev_b32_e32 v3, 7, v0
		v_lshlrev_b32_e32 v8, 13, v3
		v_add_u32_e32 v3, s60, v8
		v_and_b32_e32 v8, 15, v0
		v_lshlrev_b32_e32 v9, 6, v8
		v_lshlrev_b32_e32 v8, 4, v10
		v_add3_u32 v82, v3, v9, v8
		ds_read_b128 v[96:99], v82
		ds_read_b128 v[100:103], v82 offset:1024
		ds_read_b128 v[104:107], v82 offset:2048
		ds_read_b128 v[108:111], v82 offset:3072
		ds_read_b128 v[112:115], v82 offset:4096
		ds_read_b128 v[116:119], v82 offset:5120
		ds_read_b128 v[124:127], v82 offset:6144
		ds_read_b128 v[128:131], v82 offset:7168
		v_and_b32_e32 v3, 15, v0
		v_lshlrev_b32_e32 v8, 6, v3
		v_add_u32_e32 v3, s60, v8
		v_lshlrev_b32_e32 v8, 13, v11
		v_lshlrev_b32_e32 v9, 4, v10
		v_add3_u32 v85, v3, v8, v9
		ds_read_b128 v[132:135], v85 offset:32768
		ds_read_b128 v[136:139], v85 offset:33792
		ds_read_b128 v[140:143], v85 offset:34816
		ds_read_b128 v[144:147], v85 offset:35840
		ds_read_b128 v[148:151], v85 offset:36864
		ds_read_b128 v[152:155], v85 offset:37888
		ds_read_b128 v[156:159], v85 offset:38912
		ds_read_b128 v[160:163], v85 offset:39936
		s_lshl_b32 s60, s61, 12
		s_add_i32 s61, s60, 0x20000
		v_lshrrev_b32_e32 v3, 7, v0
		v_lshlrev_b32_e32 v8, 10, v3
		v_lshlrev_b32_e32 v3, 2, v12
		v_add3_u32 v9, s61, v8, v3
		ds_read_b32 v3, v9
		ds_read_b32 v8, v9 offset:256
		ds_read_b32 v86, v9 offset:512
		ds_read_b32 v87, v9 offset:768
		v_lshlrev_b32_e32 v9, 10, v11
		v_lshlrev_b32_e32 v90, 2, v12
		v_add3_u32 v91, s61, v90, v9
		ds_read_b32 v9, v91 offset:2048
		ds_read_b32 v90, v91 offset:2304
		ds_read_b32 v120, v91 offset:2560
		ds_read_b32 v121, v91 offset:2816
		s_waitcnt lgkmcnt(0)
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(63) expcnt(7) lgkmcnt(15)
		scratch_load_dword v164, off, s60 offset:56
		scratch_load_dword v165, off, s60 offset:60
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v166, vcc, v164, v88
		v_addc_co_u32_e64 v167, vcc, v165, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:64
		scratch_load_dword v165, off, s60 offset:68
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v168, vcc, v164, v88
		v_addc_co_u32_e64 v169, vcc, v165, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:72
		scratch_load_dword v165, off, s60 offset:76
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v170, vcc, v164, v88
		v_addc_co_u32_e64 v171, vcc, v165, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:80
		scratch_load_dword v165, off, s60 offset:84
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v172, vcc, v164, v88
		v_addc_co_u32_e64 v173, vcc, v165, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:88
		scratch_load_dword v165, off, s60 offset:92
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v174, vcc, v164, v88
		v_addc_co_u32_e64 v175, vcc, v165, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:96
		scratch_load_dword v165, off, s60 offset:100
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v176, vcc, v164, v88
		v_addc_co_u32_e64 v177, vcc, v165, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:104
		scratch_load_dword v165, off, s60 offset:108
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v178, vcc, v164, v88
		v_addc_co_u32_e64 v179, vcc, v165, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:112
		scratch_load_dword v165, off, s60 offset:116
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v180, vcc, v164, v88
		v_addc_co_u32_e64 v181, vcc, v165, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:120
		scratch_load_dword v165, off, s60 offset:124
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v182, vcc, v164, v88
		v_addc_co_u32_e64 v183, vcc, v165, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:128
		scratch_load_dword v165, off, s60 offset:132
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v184, vcc, v164, v88
		v_addc_co_u32_e64 v185, vcc, v165, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:136
		scratch_load_dword v165, off, s60 offset:140
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v186, vcc, v164, v88
		v_addc_co_u32_e64 v187, vcc, v165, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:144
		scratch_load_dword v165, off, s60 offset:148
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v188, vcc, v164, v88
		v_addc_co_u32_e64 v189, vcc, v165, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:152
		scratch_load_dword v165, off, s60 offset:156
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v190, vcc, v164, v88
		v_addc_co_u32_e64 v191, vcc, v165, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:160
		scratch_load_dword v165, off, s60 offset:164
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v192, vcc, v164, v88
		v_addc_co_u32_e64 v193, vcc, v165, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:168
		scratch_load_dword v165, off, s60 offset:172
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v194, vcc, v164, v88
		v_addc_co_u32_e64 v195, vcc, v165, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:176
		scratch_load_dword v165, off, s60 offset:180
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v196, vcc, v164, v88
		v_addc_co_u32_e64 v197, vcc, v165, v89, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v88, off, s60 offset:184
		scratch_load_dword v89, off, s60 offset:188
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v164, vcc, v88, v122
		v_addc_co_u32_e64 v165, vcc, v89, v123, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v88, off, s60 offset:192
		scratch_load_dword v89, off, s60 offset:196
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v198, vcc, v88, v122
		v_addc_co_u32_e64 v199, vcc, v89, v123, vcc
		v_accvgpr_write_b32 a2, v198
		v_accvgpr_write_b32 a3, v199
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[96:99], v[132:135], v[4:7], v3, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[200:203], v82 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[96:99], v[136:139], a[4:7], v3, v9 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[204:207], v82 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[96:99], v[140:143], a[8:11], v3, v90 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[208:211], v82 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[96:99], v[144:147], a[12:15], v3, v90 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[212:215], v82 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[96:99], v[148:151], a[16:19], v3, v120 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v82 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[96:99], v[152:155], a[20:23], v3, v120 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v82 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[96:99], v[156:159], a[24:27], v3, v121 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v82 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[96:99], v[160:163], a[28:31], v3, v121 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v82 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[100:103], v[132:135], a[32:35], v3, v9 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v85 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[100:103], v[136:139], a[36:39], v3, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[232:235], v85 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[100:103], v[140:143], a[40:43], v3, v90 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[236:239], v85 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[100:103], v[144:147], a[44:47], v3, v90 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v85 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[100:103], v[148:151], a[48:51], v3, v120 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[244:247], v85 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[100:103], v[152:155], a[52:55], v3, v120 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v85 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[100:103], v[156:159], a[56:59], v3, v121 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[252:255], v85 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[100:103], v[160:163], a[60:63], v3, v121 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v85 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[104:107], v[132:135], a[64:67], v8, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s10
		s_nop 0
		buffer_load_dwordx4 v166, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[104:107], v[136:139], a[68:71], v8, v9 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s45
		s_nop 0
		buffer_load_dwordx4 v168, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[104:107], v[140:143], a[72:75], v8, v90 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s46
		s_nop 0
		buffer_load_dwordx4 v170, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[104:107], v[144:147], a[76:79], v8, v90 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s47
		s_nop 0
		buffer_load_dwordx4 v172, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[104:107], v[148:151], a[80:83], v8, v120 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s48
		s_nop 0
		buffer_load_dwordx4 v174, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[104:107], v[152:155], a[84:87], v8, v120 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s49
		s_nop 0
		buffer_load_dwordx4 v176, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[104:107], v[156:159], a[88:91], v8, v121 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v178, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[104:107], v[160:163], a[92:95], v8, v121 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s51
		s_nop 0
		buffer_load_dwordx4 v180, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[108:111], v[132:135], a[96:99], v8, v9 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s52
		s_nop 0
		buffer_load_dwordx4 v182, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[108:111], v[136:139], a[100:103], v8, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s53
		s_nop 0
		buffer_load_dwordx4 v184, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[108:111], v[140:143], a[104:107], v8, v90 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s54
		s_nop 0
		buffer_load_dwordx4 v186, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[108:111], v[144:147], a[108:111], v8, v90 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s55
		s_nop 0
		buffer_load_dwordx4 v188, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[108:111], v[148:151], a[112:115], v8, v120 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s56
		s_nop 0
		buffer_load_dwordx4 v190, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[108:111], v[152:155], a[116:119], v8, v120 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s57
		s_nop 0
		buffer_load_dwordx4 v192, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[108:111], v[156:159], a[120:123], v8, v121 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s58
		s_nop 0
		buffer_load_dwordx4 v194, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[108:111], v[160:163], a[124:127], v8, v121 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s59
		s_nop 0
		buffer_load_dwordx4 v196, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[112:115], v[132:135], a[128:131], v86, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s43, 0x20000
		s_nop 0
		buffer_load_dwordx4 v164, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[112:115], v[136:139], a[132:135], v86, v9 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s9, 0x20000
		v_accvgpr_read_b32 v82, a2
		buffer_load_dwordx4 v82, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[112:115], v[140:143], a[136:139], v86, v90 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[112:115], v[144:147], a[140:143], v86, v90 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[112:115], v[148:151], a[144:147], v86, v120 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[112:115], v[152:155], a[148:151], v86, v120 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[112:115], v[156:159], a[152:155], v86, v121 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[112:115], v[160:163], a[156:159], v86, v121 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[116:119], v[132:135], a[160:163], v86, v9 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[116:119], v[136:139], a[164:167], v86, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[116:119], v[140:143], a[168:171], v86, v90 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[116:119], v[144:147], a[172:175], v86, v90 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[116:119], v[148:151], a[176:179], v86, v120 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[116:119], v[152:155], a[180:183], v86, v120 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[116:119], v[156:159], a[184:187], v86, v121 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[116:119], v[160:163], a[188:191], v86, v121 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[124:127], v[132:135], a[192:195], v87, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[124:127], v[136:139], a[196:199], v87, v9 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[124:127], v[140:143], a[200:203], v87, v90 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[124:127], v[144:147], a[204:207], v87, v90 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[124:127], v[148:151], a[208:211], v87, v120 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[124:127], v[152:155], a[212:215], v87, v120 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[124:127], v[156:159], a[216:219], v87, v121 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[124:127], v[160:163], a[220:223], v87, v121 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[128:131], v[132:135], a[224:227], v87, v9 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[128:131], v[136:139], a[228:231], v87, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[128:131], v[140:143], a[232:235], v87, v90 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[128:131], v[144:147], a[236:239], v87, v90 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[128:131], v[148:151], a[240:243], v87, v120 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[128:131], v[152:155], a[244:247], v87, v120 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[128:131], v[156:159], a[248:251], v87, v121 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[128:131], v[160:163], a[252:255], v87, v121 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[200:203], v[228:231], v[4:7], v3, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[200:203], v[232:235], a[4:7], v3, v9 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[200:203], v[236:239], a[8:11], v3, v90 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[200:203], v[240:243], a[12:15], v3, v90 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[200:203], v[244:247], a[16:19], v3, v120 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[200:203], v[248:251], a[20:23], v3, v120 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[200:203], v[252:255], a[24:27], v3, v121 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[200:203], v[100:103], a[28:31], v3, v121 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[204:207], v[228:231], a[32:35], v3, v9 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[204:207], v[232:235], a[36:39], v3, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[204:207], v[236:239], a[40:43], v3, v90 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[204:207], v[240:243], a[44:47], v3, v90 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[204:207], v[244:247], a[48:51], v3, v120 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[204:207], v[248:251], a[52:55], v3, v120 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[204:207], v[252:255], a[56:59], v3, v121 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[204:207], v[100:103], a[60:63], v3, v121 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[208:211], v[228:231], a[64:67], v8, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[208:211], v[232:235], a[68:71], v8, v9 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[208:211], v[236:239], a[72:75], v8, v90 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[208:211], v[240:243], a[76:79], v8, v90 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[208:211], v[244:247], a[80:83], v8, v120 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[208:211], v[248:251], a[84:87], v8, v120 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[208:211], v[252:255], a[88:91], v8, v121 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[208:211], v[100:103], a[92:95], v8, v121 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[212:215], v[228:231], a[96:99], v8, v9 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[212:215], v[232:235], a[100:103], v8, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[212:215], v[236:239], a[104:107], v8, v90 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[212:215], v[240:243], a[108:111], v8, v90 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[212:215], v[244:247], a[112:115], v8, v120 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[212:215], v[248:251], a[116:119], v8, v120 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[212:215], v[252:255], a[120:123], v8, v121 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[212:215], v[100:103], a[124:127], v8, v121 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[216:219], v[228:231], a[128:131], v86, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[216:219], v[232:235], a[132:135], v86, v9 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[216:219], v[236:239], a[136:139], v86, v90 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[216:219], v[240:243], a[140:143], v86, v90 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[216:219], v[244:247], a[144:147], v86, v120 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[216:219], v[248:251], a[148:151], v86, v120 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[216:219], v[252:255], a[152:155], v86, v121 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[216:219], v[100:103], a[156:159], v86, v121 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[220:223], v[228:231], a[160:163], v86, v9 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[220:223], v[232:235], a[164:167], v86, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[220:223], v[236:239], a[168:171], v86, v90 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[220:223], v[240:243], a[172:175], v86, v90 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[220:223], v[244:247], a[176:179], v86, v120 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[220:223], v[248:251], a[180:183], v86, v120 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[220:223], v[252:255], a[184:187], v86, v121 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[220:223], v[100:103], a[188:191], v86, v121 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[224:227], v[228:231], a[192:195], v87, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[224:227], v[232:235], a[196:199], v87, v9 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[224:227], v[236:239], a[200:203], v87, v90 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[224:227], v[240:243], a[204:207], v87, v90 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[224:227], v[244:247], a[208:211], v87, v120 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[224:227], v[248:251], a[212:215], v87, v120 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[224:227], v[252:255], a[216:219], v87, v121 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[224:227], v[100:103], a[220:223], v87, v121 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[96:99], v[228:231], a[224:227], v87, v9 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[96:99], v[232:235], a[228:231], v87, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[96:99], v[236:239], a[232:235], v87, v90 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[96:99], v[240:243], a[236:239], v87, v90 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[96:99], v[244:247], a[240:243], v87, v120 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[96:99], v[248:251], a[244:247], v87, v120 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[96:99], v[252:255], a[248:251], v87, v121 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[96:99], v[100:103], a[252:255], v87, v121 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s11, s11, 2
		v_readfirstlane_b32 s60, v2
		s_cmp_lt_i32 s11, s60
		v_mov_b32_e32 v32, v92
		v_mov_b32_e32 v33, v93
		v_mov_b32_e32 v34, v94
		v_mov_b32_e32 v35, v95
		s_mov_b32 s60, 0
		s_nop 1
		scratch_load_dword v88, off, s60 offset:576
		scratch_load_dword v89, off, s60 offset:580
		scratch_load_dword v90, off, s60 offset:584
		scratch_load_dword v91, off, s60 offset:588
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v36, v88
		v_mov_b32_e32 v37, v89
		v_mov_b32_e32 v38, v90
		v_mov_b32_e32 v39, v91
		s_mov_b32 s60, 0
		scratch_load_dword v88, off, s60 offset:536
		scratch_load_dword v89, off, s60 offset:540
		scratch_load_dword v90, off, s60 offset:544
		scratch_load_dword v91, off, s60 offset:548
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v40, v88
		v_mov_b32_e32 v41, v89
		v_mov_b32_e32 v42, v90
		v_mov_b32_e32 v43, v91
		s_mov_b32 s60, 0
		scratch_load_dword v88, off, s60 offset:504
		scratch_load_dword v89, off, s60 offset:508
		scratch_load_dword v90, off, s60 offset:512
		scratch_load_dword v91, off, s60 offset:516
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v44, v88
		v_mov_b32_e32 v45, v89
		v_mov_b32_e32 v46, v90
		v_mov_b32_e32 v47, v91
		s_mov_b32 s60, 0
		scratch_load_dword v88, off, s60 offset:472
		scratch_load_dword v89, off, s60 offset:476
		scratch_load_dword v90, off, s60 offset:480
		scratch_load_dword v91, off, s60 offset:484
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v48, v88
		v_mov_b32_e32 v49, v89
		v_mov_b32_e32 v50, v90
		v_mov_b32_e32 v51, v91
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(56)
		scratch_load_dword v88, off, s60 offset:440
		scratch_load_dword v89, off, s60 offset:444
		scratch_load_dword v90, off, s60 offset:448
		scratch_load_dword v91, off, s60 offset:452
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v52, v88
		v_mov_b32_e32 v53, v89
		v_mov_b32_e32 v54, v90
		v_mov_b32_e32 v55, v91
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(48)
		scratch_load_dword v88, off, s60 offset:408
		scratch_load_dword v89, off, s60 offset:412
		scratch_load_dword v90, off, s60 offset:416
		scratch_load_dword v91, off, s60 offset:420
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v56, v88
		v_mov_b32_e32 v57, v89
		v_mov_b32_e32 v58, v90
		v_mov_b32_e32 v59, v91
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(40)
		scratch_load_dword v88, off, s60 offset:376
		scratch_load_dword v89, off, s60 offset:380
		scratch_load_dword v90, off, s60 offset:384
		scratch_load_dword v91, off, s60 offset:388
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v60, v88
		v_mov_b32_e32 v61, v89
		v_mov_b32_e32 v62, v90
		v_mov_b32_e32 v63, v91
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(32)
		scratch_load_dword v88, off, s60 offset:344
		scratch_load_dword v89, off, s60 offset:348
		scratch_load_dword v90, off, s60 offset:352
		scratch_load_dword v91, off, s60 offset:356
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v64, v88
		v_mov_b32_e32 v65, v89
		v_mov_b32_e32 v66, v90
		v_mov_b32_e32 v67, v91
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v88, off, s60 offset:312
		scratch_load_dword v89, off, s60 offset:316
		scratch_load_dword v90, off, s60 offset:320
		scratch_load_dword v91, off, s60 offset:324
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v68, v88
		v_mov_b32_e32 v69, v89
		v_mov_b32_e32 v70, v90
		v_mov_b32_e32 v71, v91
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v88, off, s60 offset:280
		scratch_load_dword v89, off, s60 offset:284
		scratch_load_dword v90, off, s60 offset:288
		scratch_load_dword v91, off, s60 offset:292
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v72, v88
		v_mov_b32_e32 v73, v89
		v_mov_b32_e32 v74, v90
		v_mov_b32_e32 v75, v91
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v88, off, s60 offset:248
		scratch_load_dword v89, off, s60 offset:252
		scratch_load_dword v90, off, s60 offset:256
		scratch_load_dword v91, off, s60 offset:260
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v76, v88
		v_mov_b32_e32 v77, v89
		v_mov_b32_e32 v78, v90
		v_mov_b32_e32 v79, v91
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(7)
		scratch_load_dword v3, off, s60 offset:228
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v1, v3
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(6)
		scratch_load_dword v3, off, s60 offset:224
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v13, v3
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(5)
		scratch_load_dword v3, off, s60 offset:220
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v15, v3
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v3, off, s60 offset:216
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v80, v3
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(3)
		scratch_load_dword v3, off, s60 offset:212
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v14, v3
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(2)
		scratch_load_dword v3, off, s60 offset:208
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v81, v3
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(1)
		scratch_load_dword v3, off, s60 offset:204
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v83, v3
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v3, off, s60 offset:200
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v84, v3
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_add_i32 s0, s12, -1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[16:19], v[48:51], v[4:7], v1, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s1, s0, 1
		s_lshl_b32 s0, s1, 16
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 13, v2
		v_add_u32_e32 v2, s0, v3
		v_and_b32_e32 v3, 15, v0
		v_lshlrev_b32_e32 v8, 6, v3
		v_lshlrev_b32_e32 v3, 4, v10
		v_add3_u32 v9, v2, v8, v3
		ds_read_b128 v[88:91], v9 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[16:19], v[52:55], a[4:7], v1, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v9 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[16:19], v[56:59], a[8:11], v1, v81 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v9 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[16:19], v[60:63], a[12:15], v1, v81 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v9 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[16:19], v[64:67], a[16:19], v1, v83 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[104:107], v9 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[16:19], v[68:71], a[20:23], v1, v83 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[108:111], v9 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[16:19], v[72:75], a[24:27], v1, v84 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[112:115], v9 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[16:19], v[76:79], a[28:31], v1, v84 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[16:19], v9 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[20:23], v[48:51], a[32:35], v1, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_and_b32_e32 v2, 15, v0
		v_lshlrev_b32_e32 v3, 6, v2
		v_add_u32_e32 v2, s0, v3
		v_lshlrev_b32_e32 v3, 13, v11
		v_lshlrev_b32_e32 v8, 4, v10
		v_add3_u32 v9, v2, v3, v8
		ds_read_b128 v[116:119], v9 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[20:23], v[52:55], a[36:39], v1, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[120:123], v9 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[20:23], v[56:59], a[40:43], v1, v81 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[124:127], v9 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[20:23], v[60:63], a[44:47], v1, v81 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[128:131], v9 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[20:23], v[64:67], a[48:51], v1, v83 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[132:135], v9 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[20:23], v[68:71], a[52:55], v1, v83 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[136:139], v9 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[20:23], v[72:75], a[56:59], v1, v84 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[140:143], v9 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[20:23], v[76:79], a[60:63], v1, v84 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v9 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[24:27], v[48:51], a[64:67], v13, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[24:27], v[52:55], a[68:71], v13, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[24:27], v[56:59], a[72:75], v13, v81 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[24:27], v[60:63], a[76:79], v13, v81 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[24:27], v[64:67], a[80:83], v13, v83 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[24:27], v[68:71], a[84:87], v13, v83 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[24:27], v[72:75], a[88:91], v13, v84 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[24:27], v[76:79], a[92:95], v13, v84 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[28:31], v[48:51], a[96:99], v13, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[28:31], v[52:55], a[100:103], v13, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[28:31], v[56:59], a[104:107], v13, v81 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[28:31], v[60:63], a[108:111], v13, v81 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[28:31], v[64:67], a[112:115], v13, v83 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[28:31], v[68:71], a[116:119], v13, v83 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[28:31], v[72:75], a[120:123], v13, v84 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[28:31], v[76:79], a[124:127], v13, v84 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[32:35], v[48:51], a[128:131], v15, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[32:35], v[52:55], a[132:135], v15, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[32:35], v[56:59], a[136:139], v15, v81 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[32:35], v[60:63], a[140:143], v15, v81 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], v[64:67], a[144:147], v15, v83 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[32:35], v[68:71], a[148:151], v15, v83 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[32:35], v[72:75], a[152:155], v15, v84 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[32:35], v[76:79], a[156:159], v15, v84 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], v[48:51], a[160:163], v15, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[36:39], v[52:55], a[164:167], v15, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[36:39], v[56:59], a[168:171], v15, v81 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[36:39], v[60:63], a[172:175], v15, v81 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[36:39], v[64:67], a[176:179], v15, v83 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[36:39], v[68:71], a[180:183], v15, v83 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[36:39], v[72:75], a[184:187], v15, v84 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[36:39], v[76:79], a[188:191], v15, v84 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[40:43], v[48:51], a[192:195], v80, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[40:43], v[52:55], a[196:199], v80, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[40:43], v[56:59], a[200:203], v80, v81 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[40:43], v[60:63], a[204:207], v80, v81 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[40:43], v[64:67], a[208:211], v80, v83 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[40:43], v[68:71], a[212:215], v80, v83 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[40:43], v[72:75], a[216:219], v80, v84 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[40:43], v[76:79], a[220:223], v80, v84 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[44:47], v[48:51], a[224:227], v80, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[44:47], v[52:55], a[228:231], v80, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[44:47], v[56:59], a[232:235], v80, v81 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[44:47], v[60:63], a[236:239], v80, v81 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[44:47], v[64:67], a[240:243], v80, v83 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[44:47], v[68:71], a[244:247], v80, v83 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[44:47], v[72:75], a[248:251], v80, v84 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[44:47], v[76:79], a[252:255], v80, v84 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[88:91], v[116:119], v[4:7], v1, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[88:91], v[120:123], a[4:7], v1, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[88:91], v[124:127], a[8:11], v1, v81 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[88:91], v[128:131], a[12:15], v1, v81 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[88:91], v[132:135], a[16:19], v1, v83 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[88:91], v[136:139], a[20:23], v1, v83 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[88:91], v[140:143], a[24:27], v1, v84 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[88:91], v[20:23], a[28:31], v1, v84 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[92:95], v[116:119], a[32:35], v1, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[92:95], v[120:123], a[36:39], v1, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[92:95], v[124:127], a[40:43], v1, v81 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[92:95], v[128:131], a[44:47], v1, v81 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[92:95], v[132:135], a[48:51], v1, v83 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[92:95], v[136:139], a[52:55], v1, v83 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[92:95], v[140:143], a[56:59], v1, v84 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[92:95], v[20:23], a[60:63], v1, v84 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[96:99], v[116:119], a[64:67], v13, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[96:99], v[120:123], a[68:71], v13, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[96:99], v[124:127], a[72:75], v13, v81 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[96:99], v[128:131], a[76:79], v13, v81 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[96:99], v[132:135], a[80:83], v13, v83 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[96:99], v[136:139], a[84:87], v13, v83 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[96:99], v[140:143], a[88:91], v13, v84 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[96:99], v[20:23], a[92:95], v13, v84 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[100:103], v[116:119], a[96:99], v13, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[100:103], v[120:123], a[100:103], v13, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[100:103], v[124:127], a[104:107], v13, v81 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[100:103], v[128:131], a[108:111], v13, v81 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[100:103], v[132:135], a[112:115], v13, v83 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[100:103], v[136:139], a[116:119], v13, v83 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[100:103], v[140:143], a[120:123], v13, v84 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[100:103], v[20:23], a[124:127], v13, v84 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[104:107], v[116:119], a[128:131], v15, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[104:107], v[120:123], a[132:135], v15, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[104:107], v[124:127], a[136:139], v15, v81 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[104:107], v[128:131], a[140:143], v15, v81 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[104:107], v[132:135], a[144:147], v15, v83 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[104:107], v[136:139], a[148:151], v15, v83 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[104:107], v[140:143], a[152:155], v15, v84 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[104:107], v[20:23], a[156:159], v15, v84 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[108:111], v[116:119], a[160:163], v15, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[108:111], v[120:123], a[164:167], v15, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[108:111], v[124:127], a[168:171], v15, v81 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[108:111], v[128:131], a[172:175], v15, v81 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[108:111], v[132:135], a[176:179], v15, v83 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[108:111], v[136:139], a[180:183], v15, v83 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[108:111], v[140:143], a[184:187], v15, v84 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[108:111], v[20:23], a[188:191], v15, v84 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[112:115], v[116:119], a[192:195], v80, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[112:115], v[120:123], a[196:199], v80, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[112:115], v[124:127], a[200:203], v80, v81 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[112:115], v[128:131], a[204:207], v80, v81 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[112:115], v[132:135], a[208:211], v80, v83 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[112:115], v[136:139], a[212:215], v80, v83 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[112:115], v[140:143], a[216:219], v80, v84 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[112:115], v[20:23], a[220:223], v80, v84 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[16:19], v[116:119], a[224:227], v80, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[16:19], v[120:123], a[228:231], v80, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[16:19], v[124:127], a[232:235], v80, v81 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[16:19], v[128:131], a[236:239], v80, v81 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[16:19], v[132:135], a[240:243], v80, v83 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[16:19], v[136:139], a[244:247], v80, v83 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[16:19], v[140:143], a[248:251], v80, v84 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[16:19], v[20:23], a[252:255], v80, v84 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s0, s12, 1
		s_lshl_b32 s1, s0, 16
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v2, 13, v1
		v_add_u32_e32 v1, s1, v2
		v_and_b32_e32 v2, 15, v0
		v_lshlrev_b32_e32 v3, 6, v2
		v_lshlrev_b32_e32 v2, 4, v10
		v_add3_u32 v8, v1, v3, v2
		ds_read_b128 v[16:19], v8
		ds_read_b128 v[20:23], v8 offset:1024
		ds_read_b128 v[24:27], v8 offset:2048
		ds_read_b128 v[28:31], v8 offset:3072
		ds_read_b128 v[32:35], v8 offset:4096
		ds_read_b128 v[36:39], v8 offset:5120
		ds_read_b128 v[40:43], v8 offset:6144
		ds_read_b128 v[44:47], v8 offset:7168
		v_and_b32_e32 v1, 15, v0
		v_lshlrev_b32_e32 v2, 6, v1
		v_add_u32_e32 v1, s1, v2
		v_lshlrev_b32_e32 v2, 13, v11
		v_lshlrev_b32_e32 v3, 4, v10
		v_add3_u32 v9, v1, v2, v3
		ds_read_b128 v[48:51], v9 offset:32768
		ds_read_b128 v[52:55], v9 offset:33792
		ds_read_b128 v[56:59], v9 offset:34816
		ds_read_b128 v[60:63], v9 offset:35840
		ds_read_b128 v[64:67], v9 offset:36864
		ds_read_b128 v[68:71], v9 offset:37888
		ds_read_b128 v[72:75], v9 offset:38912
		ds_read_b128 v[76:79], v9 offset:39936
		s_lshl_b32 s1, s0, 12
		s_add_i32 s0, s1, 0x20000
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v0, 10, v1
		v_lshlrev_b32_e32 v1, 2, v12
		v_add3_u32 v2, s0, v0, v1
		ds_read_b32 v0, v2
		ds_read_b32 v1, v2 offset:256
		ds_read_b32 v3, v2 offset:512
		ds_read_b32 v10, v2 offset:768
		v_lshlrev_b32_e32 v2, 10, v11
		v_lshlrev_b32_e32 v11, 2, v12
		v_add3_u32 v12, s0, v11, v2
		ds_read_b32 v2, v12 offset:2048
		ds_read_b32 v11, v12 offset:2304
		ds_read_b32 v13, v12 offset:2560
		ds_read_b32 v14, v12 offset:2816
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[16:19], v[48:51], v[4:7], v0, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[80:83], v8 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[16:19], v[52:55], a[4:7], v0, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[84:87], v8 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[16:19], v[56:59], a[8:11], v0, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v8 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[16:19], v[60:63], a[12:15], v0, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v8 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[16:19], v[64:67], a[16:19], v0, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v8 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[16:19], v[68:71], a[20:23], v0, v13 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v8 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[16:19], v[72:75], a[24:27], v0, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[104:107], v8 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[16:19], v[76:79], a[28:31], v0, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[16:19], v8 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[20:23], v[48:51], a[32:35], v0, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[108:111], v9 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[20:23], v[52:55], a[36:39], v0, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[112:115], v9 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[20:23], v[56:59], a[40:43], v0, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[116:119], v9 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[20:23], v[60:63], a[44:47], v0, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[120:123], v9 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[20:23], v[64:67], a[48:51], v0, v13 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[124:127], v9 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[20:23], v[68:71], a[52:55], v0, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[128:131], v9 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[20:23], v[72:75], a[56:59], v0, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[132:135], v9 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[20:23], v[76:79], a[60:63], v0, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v9 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[24:27], v[48:51], a[64:67], v1, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[24:27], v[52:55], a[68:71], v1, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[24:27], v[56:59], a[72:75], v1, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[24:27], v[60:63], a[76:79], v1, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[24:27], v[64:67], a[80:83], v1, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[24:27], v[68:71], a[84:87], v1, v13 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[24:27], v[72:75], a[88:91], v1, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[24:27], v[76:79], a[92:95], v1, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[28:31], v[48:51], a[96:99], v1, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[28:31], v[52:55], a[100:103], v1, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[28:31], v[56:59], a[104:107], v1, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[28:31], v[60:63], a[108:111], v1, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[28:31], v[64:67], a[112:115], v1, v13 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[28:31], v[68:71], a[116:119], v1, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[28:31], v[72:75], a[120:123], v1, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[28:31], v[76:79], a[124:127], v1, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[32:35], v[48:51], a[128:131], v3, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[32:35], v[52:55], a[132:135], v3, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[32:35], v[56:59], a[136:139], v3, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[32:35], v[60:63], a[140:143], v3, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], v[64:67], a[144:147], v3, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[32:35], v[68:71], a[148:151], v3, v13 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[32:35], v[72:75], a[152:155], v3, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[32:35], v[76:79], a[156:159], v3, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], v[48:51], a[160:163], v3, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[36:39], v[52:55], a[164:167], v3, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[36:39], v[56:59], a[168:171], v3, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[36:39], v[60:63], a[172:175], v3, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[36:39], v[64:67], a[176:179], v3, v13 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[36:39], v[68:71], a[180:183], v3, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[36:39], v[72:75], a[184:187], v3, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[36:39], v[76:79], a[188:191], v3, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[40:43], v[48:51], a[192:195], v10, v2 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[40:43], v[52:55], a[196:199], v10, v2 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[40:43], v[56:59], a[200:203], v10, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[40:43], v[60:63], a[204:207], v10, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[40:43], v[64:67], a[208:211], v10, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[40:43], v[68:71], a[212:215], v10, v13 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[40:43], v[72:75], a[216:219], v10, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[40:43], v[76:79], a[220:223], v10, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[44:47], v[48:51], a[224:227], v10, v2 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[44:47], v[52:55], a[228:231], v10, v2 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[44:47], v[56:59], a[232:235], v10, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[44:47], v[60:63], a[236:239], v10, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[44:47], v[64:67], a[240:243], v10, v13 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[44:47], v[68:71], a[244:247], v10, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[44:47], v[72:75], a[248:251], v10, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[44:47], v[76:79], a[252:255], v10, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[80:83], v[108:111], v[4:7], v0, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[80:83], v[112:115], a[4:7], v0, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[80:83], v[116:119], a[8:11], v0, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[80:83], v[120:123], a[12:15], v0, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[80:83], v[124:127], a[16:19], v0, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[80:83], v[128:131], a[20:23], v0, v13 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[80:83], v[132:135], a[24:27], v0, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[80:83], v[20:23], a[28:31], v0, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[84:87], v[108:111], a[32:35], v0, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[84:87], v[112:115], a[36:39], v0, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[84:87], v[116:119], a[40:43], v0, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[84:87], v[120:123], a[44:47], v0, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[84:87], v[124:127], a[48:51], v0, v13 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[84:87], v[128:131], a[52:55], v0, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[84:87], v[132:135], a[56:59], v0, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[84:87], v[20:23], a[60:63], v0, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[88:91], v[108:111], a[64:67], v1, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[88:91], v[112:115], a[68:71], v1, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[88:91], v[116:119], a[72:75], v1, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[88:91], v[120:123], a[76:79], v1, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[88:91], v[124:127], a[80:83], v1, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[88:91], v[128:131], a[84:87], v1, v13 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[88:91], v[132:135], a[88:91], v1, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[88:91], v[20:23], a[92:95], v1, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[92:95], v[108:111], a[96:99], v1, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[92:95], v[112:115], a[100:103], v1, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[92:95], v[116:119], a[104:107], v1, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[92:95], v[120:123], a[108:111], v1, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[92:95], v[124:127], a[112:115], v1, v13 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[92:95], v[128:131], a[116:119], v1, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[92:95], v[132:135], a[120:123], v1, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[92:95], v[20:23], a[124:127], v1, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[96:99], v[108:111], a[128:131], v3, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[96:99], v[112:115], a[132:135], v3, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[96:99], v[116:119], a[136:139], v3, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[96:99], v[120:123], a[140:143], v3, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[96:99], v[124:127], a[144:147], v3, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[96:99], v[128:131], a[148:151], v3, v13 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[96:99], v[132:135], a[152:155], v3, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[96:99], v[20:23], a[156:159], v3, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[100:103], v[108:111], a[160:163], v3, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[100:103], v[112:115], a[164:167], v3, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[100:103], v[116:119], a[168:171], v3, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[100:103], v[120:123], a[172:175], v3, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[100:103], v[124:127], a[176:179], v3, v13 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[100:103], v[128:131], a[180:183], v3, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[100:103], v[132:135], a[184:187], v3, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[100:103], v[20:23], a[188:191], v3, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[104:107], v[108:111], a[192:195], v10, v2 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[104:107], v[112:115], a[196:199], v10, v2 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[104:107], v[116:119], a[200:203], v10, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[104:107], v[120:123], a[204:207], v10, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[104:107], v[124:127], a[208:211], v10, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[104:107], v[128:131], a[212:215], v10, v13 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[104:107], v[132:135], a[216:219], v10, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[104:107], v[20:23], a[220:223], v10, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[16:19], v[108:111], a[224:227], v10, v2 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[16:19], v[112:115], a[228:231], v10, v2 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[16:19], v[116:119], a[232:235], v10, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[16:19], v[120:123], a[236:239], v10, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[16:19], v[124:127], a[240:243], v10, v13 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[16:19], v[128:131], a[244:247], v10, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[16:19], v[132:135], a[248:251], v10, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[16:19], v[20:23], a[252:255], v10, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v4, v5
		v_cvt_pk_f16_f32 v1, v6, v7
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
		.amdhsa_private_segment_fixed_size 592
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
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 592
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
    .private_segment_fixed_size: 592
    .sgpr_count:     62
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     512
    .agpr_count:     256
    .vgpr_spill_count: 148
    .wavefront_size: 64
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
