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
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v9, 10, v1
		v_accvgpr_read_b32 v10, a1
		v_lshlrev_b32_e32 v11, 4, v10
		v_add3_u32 v10, s44, v9, v11
		s_lshr_b32 s45, s8, 7
		s_lshl_b32 s8, s45, 10
		v_accvgpr_read_b32 v12, a0
		v_and_b32_e32 v13, 1, v12
		v_lshlrev_b32_e32 v12, 10, v13
		v_add3_u32 v14, s44, v11, v12
		s_and_b32 s44, s11, 1
		s_lshl_b32 s11, s44, 10
		s_add_i32 s44, s11, 0x800
		s_add_i32 m0, s8, 0x20000
		s_nop 0
		buffer_load_dwordx4 v10, s[4:7], 0 offen lds
		s_add_i32 m0, s11, 0x20800
		s_nop 0
		buffer_load_dwordx4 v14, s[24:27], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v10, 13, v1
		v_and_b32_e32 v1, 15, v0
		v_lshlrev_b32_e32 v14, 6, v1
		v_accvgpr_read_b32 v15, a1
		v_lshrrev_b32_e32 v16, 4, v15
		v_lshrrev_b32_e32 v15, 1, v1
		v_and_b32_e32 v1, 3, v15
		v_xor_b32_e32 v15, v16, v1
		v_lshlrev_b32_e32 v1, 4, v15
		v_add3_u32 v15, v10, v14, v1
		ds_read_b128 v[16:19], v15
		ds_read_b128 v[20:23], v15 offset:1024
		ds_read_b128 v[24:27], v15 offset:2048
		ds_read_b128 v[28:31], v15 offset:3072
		ds_read_b128 v[32:35], v15 offset:4096
		ds_read_b128 v[36:39], v15 offset:5120
		ds_read_b128 v[40:43], v15 offset:6144
		ds_read_b128 v[44:47], v15 offset:7168
		v_lshlrev_b32_e32 v15, 13, v13
		v_add3_u32 v13, v14, v15, v1
		ds_read_b128 v[48:51], v13 offset:32768
		ds_read_b128 v[52:55], v13 offset:33792
		ds_read_b128 v[56:59], v13 offset:34816
		ds_read_b128 v[60:63], v13 offset:35840
		ds_read_b128 v[64:67], v13 offset:36864
		ds_read_b128 v[68:71], v13 offset:37888
		ds_read_b128 v[72:75], v13 offset:38912
		ds_read_b128 v[76:79], v13 offset:39936
		v_add_u32_e32 v13, 0x20000, v9
		v_accvgpr_read_b32 v80, a1
		v_lshlrev_b32_e32 v81, 2, v80
		v_add_u32_e32 v80, v13, v81
		ds_read_b32 v13, v80
		ds_read_b32 v82, v80 offset:256
		ds_read_b32 v83, v80 offset:512
		ds_read_b32 v84, v80 offset:768
		v_add_u32_e32 v80, 0x20000, v81
		v_add_u32_e32 v85, v80, v12
		ds_read_b32 v80, v85 offset:2048
		ds_read_b32 v86, v85 offset:2304
		ds_read_b32 v87, v85 offset:2560
		ds_read_b32 v88, v85 offset:2816
		s_waitcnt lgkmcnt(0)
		s_add_i32 s45, s9, 0x80
		v_add_u32_e32 v85, s45, v2
		v_add3_u32 v89, v85, v3, v8
		s_add_i32 s45, s9, 0x40080
		v_add_u32_e32 v85, s45, v2
		v_add3_u32 v90, v85, v3, v8
		s_add_i32 s45, s9, 0x80080
		v_add_u32_e32 v85, s45, v2
		v_add3_u32 v91, v85, v3, v8
		s_add_i32 s45, s9, 0xc0080
		v_add_u32_e32 v85, s45, v2
		v_add3_u32 v92, v85, v3, v8
		s_add_i32 s45, s9, 0xc0
		v_add_u32_e32 v85, s45, v2
		v_add3_u32 v93, v85, v3, v8
		s_add_i32 s45, s9, 0x400c0
		v_add_u32_e32 v85, s45, v2
		v_add3_u32 v94, v85, v3, v8
		s_add_i32 s45, s9, 0x800c0
		v_add_u32_e32 v85, s45, v2
		v_add3_u32 v95, v85, v3, v8
		s_add_i32 s45, s9, 0xc00c0
		v_add_u32_e32 v85, s45, v2
		v_add3_u32 v96, v85, v3, v8
		s_add_i32 s45, s10, 0x80
		v_add_u32_e32 v85, s45, v2
		v_add3_u32 v97, v85, v3, v8
		s_add_i32 s45, s10, 0x40080
		v_add_u32_e32 v85, s45, v2
		v_add3_u32 v98, v85, v3, v8
		s_add_i32 s45, s10, 0x80080
		v_add_u32_e32 v85, s45, v2
		v_add3_u32 v99, v85, v3, v8
		s_add_i32 s45, s10, 0xc0080
		v_add_u32_e32 v85, s45, v2
		v_add3_u32 v100, v85, v3, v8
		s_add_i32 s45, s10, 0xc0
		v_add_u32_e32 v85, s45, v2
		v_add3_u32 v101, v85, v3, v8
		s_add_i32 s45, s10, 0x400c0
		v_add_u32_e32 v85, s45, v2
		v_add3_u32 v102, v85, v3, v8
		s_add_i32 s45, s10, 0x800c0
		v_add_u32_e32 v85, s45, v2
		v_add3_u32 v103, v85, v3, v8
		s_add_i32 s45, s10, 0xc00c0
		v_add_u32_e32 v85, s45, v2
		v_add3_u32 v2, v85, v3, v8
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
		buffer_load_dwordx4 v89, s[20:23], 0 offen lds
		s_mov_b32 m0, s45
		s_nop 0
		buffer_load_dwordx4 v90, s[20:23], 0 offen lds
		s_mov_b32 m0, s46
		s_nop 0
		buffer_load_dwordx4 v91, s[20:23], 0 offen lds
		s_mov_b32 m0, s47
		s_nop 0
		buffer_load_dwordx4 v92, s[20:23], 0 offen lds
		s_mov_b32 m0, s48
		s_nop 0
		buffer_load_dwordx4 v93, s[20:23], 0 offen lds
		s_mov_b32 m0, s49
		s_nop 0
		buffer_load_dwordx4 v94, s[20:23], 0 offen lds
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v95, s[20:23], 0 offen lds
		s_mov_b32 m0, s51
		s_nop 0
		buffer_load_dwordx4 v96, s[20:23], 0 offen lds
		s_mov_b32 m0, s52
		s_nop 0
		buffer_load_dwordx4 v97, s[0:3], 0 offen lds
		s_mov_b32 m0, s53
		s_nop 0
		buffer_load_dwordx4 v98, s[0:3], 0 offen lds
		s_mov_b32 m0, s54
		s_nop 0
		buffer_load_dwordx4 v99, s[0:3], 0 offen lds
		s_mov_b32 m0, s55
		s_nop 0
		buffer_load_dwordx4 v100, s[0:3], 0 offen lds
		s_mov_b32 m0, s56
		s_nop 0
		buffer_load_dwordx4 v101, s[0:3], 0 offen lds
		s_mov_b32 m0, s57
		s_nop 0
		buffer_load_dwordx4 v102, s[0:3], 0 offen lds
		s_mov_b32 m0, s58
		s_nop 0
		buffer_load_dwordx4 v103, s[0:3], 0 offen lds
		s_mov_b32 m0, s59
		s_nop 0
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_add_i32 s60, s9, 0x800
		s_add_i32 s9, s60, s43
		v_add3_u32 v2, s9, v9, v11
		s_add_i32 s43, s8, 0x1000
		v_add3_u32 v3, s9, v11, v12
		s_add_i32 s9, s11, 0x1800
		s_add_i32 m0, s8, 0x21000
		s_nop 0
		buffer_load_dwordx4 v2, s[4:7], 0 offen lds
		s_add_i32 m0, s11, 0x21800
		s_nop 0
		buffer_load_dwordx4 v3, s[24:27], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s11, s12, 1
		v_mov_b32_e32 v2, s11
		s_mov_b32 s11, 2
		v_mov_b32_e32 v90, s13
		v_mov_b32_e32 v91, 0
		s_mov_b32 s60, 0x100000
		s_mov_b32 s61, 0
		v_mov_b32_e32 v92, s60
		v_mov_b32_e32 v93, s61
		v_mul_lo_u32 v94, v92, v90
		v_mul_hi_u32 v95, v92, v90
		v_mul_lo_u32 v3, v92, v91
		v_add_u32_e32 v95, v95, v3
		v_mul_lo_u32 v3, v93, v90
		v_add_u32_e32 v95, v95, v3
		s_mov_b32 s60, 1
		s_mov_b32 s61, 0
		v_mov_b32_e32 v96, v0
		v_mov_b32_e32 v97, 0
		v_mov_b32_e32 v98, s60
		v_mov_b32_e32 v99, s61
		v_mul_lo_u32 v100, v98, v96
		v_mul_hi_u32 v101, v98, v96
		v_mul_lo_u32 v3, v98, v97
		v_add_u32_e32 v101, v101, v3
		v_mul_lo_u32 v3, v99, v96
		v_add_u32_e32 v101, v101, v3
		v_lshrrev_b64 v[102:103], 6, v[100:101]
		s_mov_b32 s60, 0x10000
		s_mov_b32 s61, 0
		v_mov_b32_e32 v104, s60
		v_mov_b32_e32 v105, s61
		v_mul_lo_u32 v106, v104, v102
		v_mul_hi_u32 v107, v104, v102
		v_mul_lo_u32 v3, v104, v103
		v_add_u32_e32 v107, v107, v3
		v_mul_lo_u32 v3, v105, v102
		v_add_u32_e32 v107, v107, v3
		v_add_co_u32_e64 v108, vcc, v94, v106
		v_addc_co_u32_e64 v109, vcc, v95, v107, vcc
		v_mov_b32_e32 v3, 63
		v_and_b32_e32 v110, v96, v3
		v_and_b32_e32 v111, v91, v91
		v_mul_lo_u32 v96, v98, v110
		v_mul_hi_u32 v97, v98, v110
		v_mul_lo_u32 v3, v98, v111
		v_add_u32_e32 v97, v97, v3
		v_mul_lo_u32 v3, v99, v110
		v_add_u32_e32 v97, v97, v3
		v_lshrrev_b64 v[98:99], 2, v[96:97]
		s_mov_b32 s60, 0x1000
		s_mov_b32 s61, 0
		v_mov_b32_e32 v112, s60
		v_mov_b32_e32 v113, s61
		v_mul_lo_u32 v114, v112, v98
		v_mul_hi_u32 v115, v112, v98
		v_mul_lo_u32 v3, v112, v99
		v_add_u32_e32 v115, v115, v3
		v_mul_lo_u32 v3, v113, v98
		v_add_u32_e32 v115, v115, v3
		v_add_co_u32_e64 v98, vcc, v108, v114
		v_addc_co_u32_e64 v99, vcc, v109, v115, vcc
		v_lshrrev_b64 v[108:109], 3, v[96:97]
		v_mov_b32_e32 v3, 3
		v_and_b32_e32 v96, v108, v3
		v_and_b32_e32 v97, v109, v91
		v_and_b32_e32 v108, v110, v3
		v_and_b32_e32 v109, v111, v91
		v_xor_b32_e32 v112, v96, v108
		v_xor_b32_e32 v113, v97, v109
		s_mov_b32 s60, 16
		s_mov_b32 s61, 0
		v_mov_b32_e32 v96, s60
		v_mov_b32_e32 v97, s61
		v_mul_lo_u32 v108, v96, v112
		v_mul_hi_u32 v109, v96, v112
		v_mul_lo_u32 v3, v96, v113
		v_add_u32_e32 v109, v109, v3
		v_mul_lo_u32 v3, v97, v112
		v_add_u32_e32 v109, v109, v3
		v_add_co_u32_e64 v112, vcc, v98, v108
		v_addc_co_u32_e64 v113, vcc, v99, v109, vcc
		v_accvgpr_write_b32 a2, v112
		v_accvgpr_write_b32 a3, v113
		s_mov_b32 s60, 0x80
		s_mov_b32 s61, 0
		v_mov_b32_e32 v98, s60
		v_mov_b32_e32 v99, s61
		v_lshlrev_b32_e32 v3, 2, v0
		ds_write_b32 v3, v98
		v_lshlrev_b32_e32 v3, 2, v0
		ds_write_b32 v3, v99 offset:1024
		v_mov_b32_e32 v3, 0x40000
		v_add_co_u32_e64 v98, vcc, v94, v3
		v_addc_co_u32_e64 v99, vcc, v95, 0, vcc
		v_add_co_u32_e64 v112, vcc, v98, v106
		v_addc_co_u32_e64 v113, vcc, v99, v107, vcc
		v_add_co_u32_e64 v98, vcc, v112, v114
		v_addc_co_u32_e64 v99, vcc, v113, v115, vcc
		v_add_co_u32_e64 v112, vcc, v98, v108
		v_addc_co_u32_e64 v113, vcc, v99, v109, vcc
		v_lshlrev_b32_e32 v8, 2, v0
		ds_write_b32 v8, v112 offset:2048
		v_lshlrev_b32_e32 v8, 2, v0
		ds_write_b32 v8, v113 offset:3072
		v_mov_b32_e32 v8, 0x80000
		v_add_co_u32_e64 v98, vcc, v94, v8
		v_addc_co_u32_e64 v99, vcc, v95, 0, vcc
		v_add_co_u32_e64 v112, vcc, v98, v106
		v_addc_co_u32_e64 v113, vcc, v99, v107, vcc
		v_add_co_u32_e64 v98, vcc, v112, v114
		v_addc_co_u32_e64 v99, vcc, v113, v115, vcc
		v_add_co_u32_e64 v112, vcc, v98, v108
		v_addc_co_u32_e64 v113, vcc, v99, v109, vcc
		v_lshlrev_b32_e32 v11, 2, v0
		ds_write_b32 v11, v112 offset:4096
		v_lshlrev_b32_e32 v11, 2, v0
		ds_write_b32 v11, v113 offset:5120
		v_mov_b32_e32 v11, 0xc0000
		v_add_co_u32_e64 v98, vcc, v94, v11
		v_addc_co_u32_e64 v99, vcc, v95, 0, vcc
		v_add_co_u32_e64 v112, vcc, v98, v106
		v_addc_co_u32_e64 v113, vcc, v99, v107, vcc
		v_add_co_u32_e64 v98, vcc, v112, v114
		v_addc_co_u32_e64 v99, vcc, v113, v115, vcc
		v_add_co_u32_e64 v112, vcc, v98, v108
		v_addc_co_u32_e64 v113, vcc, v99, v109, vcc
		v_lshlrev_b32_e32 v85, 2, v0
		ds_write_b32 v85, v112 offset:6144
		v_lshlrev_b32_e32 v85, 2, v0
		ds_write_b32 v85, v113 offset:7168
		v_mov_b32_e32 v85, 64
		v_add_co_u32_e64 v98, vcc, v94, v85
		v_addc_co_u32_e64 v99, vcc, v95, 0, vcc
		v_add_co_u32_e64 v112, vcc, v98, v106
		v_addc_co_u32_e64 v113, vcc, v99, v107, vcc
		v_add_co_u32_e64 v98, vcc, v112, v114
		v_addc_co_u32_e64 v99, vcc, v113, v115, vcc
		v_add_co_u32_e64 v112, vcc, v98, v108
		v_addc_co_u32_e64 v113, vcc, v99, v109, vcc
		v_lshlrev_b32_e32 v89, 2, v0
		ds_write_b32 v89, v112 offset:8192
		v_lshlrev_b32_e32 v89, 2, v0
		ds_write_b32 v89, v113 offset:9216
		v_mov_b32_e32 v89, 0x40040
		v_add_co_u32_e64 v98, vcc, v94, v89
		v_addc_co_u32_e64 v99, vcc, v95, 0, vcc
		v_add_co_u32_e64 v112, vcc, v98, v106
		v_addc_co_u32_e64 v113, vcc, v99, v107, vcc
		v_add_co_u32_e64 v98, vcc, v112, v114
		v_addc_co_u32_e64 v99, vcc, v113, v115, vcc
		v_add_co_u32_e64 v112, vcc, v98, v108
		v_addc_co_u32_e64 v113, vcc, v99, v109, vcc
		v_lshlrev_b32_e32 v90, 2, v0
		ds_write_b32 v90, v112 offset:10240
		v_lshlrev_b32_e32 v90, 2, v0
		ds_write_b32 v90, v113 offset:11264
		v_mov_b32_e32 v90, 0x80040
		v_add_co_u32_e64 v98, vcc, v94, v90
		v_addc_co_u32_e64 v99, vcc, v95, 0, vcc
		v_add_co_u32_e64 v112, vcc, v98, v106
		v_addc_co_u32_e64 v113, vcc, v99, v107, vcc
		v_add_co_u32_e64 v98, vcc, v112, v114
		v_addc_co_u32_e64 v99, vcc, v113, v115, vcc
		v_add_co_u32_e64 v112, vcc, v98, v108
		v_addc_co_u32_e64 v113, vcc, v99, v109, vcc
		v_lshlrev_b32_e32 v98, 2, v0
		ds_write_b32 v98, v112 offset:12288
		v_lshlrev_b32_e32 v98, 2, v0
		ds_write_b32 v98, v113 offset:13312
		v_mov_b32_e32 v98, 0xc0040
		v_add_co_u32_e64 v112, vcc, v94, v98
		v_addc_co_u32_e64 v113, vcc, v95, 0, vcc
		v_add_co_u32_e64 v116, vcc, v112, v106
		v_addc_co_u32_e64 v117, vcc, v113, v107, vcc
		v_add_co_u32_e64 v112, vcc, v116, v114
		v_addc_co_u32_e64 v113, vcc, v117, v115, vcc
		v_add_co_u32_e64 v116, vcc, v112, v108
		v_addc_co_u32_e64 v117, vcc, v113, v109, vcc
		v_lshlrev_b32_e32 v99, 2, v0
		ds_write_b32 v99, v116 offset:14336
		v_lshlrev_b32_e32 v99, 2, v0
		ds_write_b32 v99, v117 offset:15360
		v_mov_b32_e32 v112, s14
		v_mov_b32_e32 v113, 0
		v_mul_lo_u32 v116, v92, v112
		v_mul_hi_u32 v117, v92, v112
		v_mul_lo_u32 v99, v92, v113
		v_add_u32_e32 v117, v117, v99
		v_mul_lo_u32 v99, v93, v112
		v_add_u32_e32 v117, v117, v99
		v_add_co_u32_e64 v92, vcc, v116, v106
		v_addc_co_u32_e64 v93, vcc, v117, v107, vcc
		v_add_co_u32_e64 v118, vcc, v92, v114
		v_addc_co_u32_e64 v119, vcc, v93, v115, vcc
		v_add_co_u32_e64 v92, vcc, v118, v108
		v_addc_co_u32_e64 v93, vcc, v119, v109, vcc
		v_lshlrev_b32_e32 v99, 2, v0
		ds_write_b32 v99, v92 offset:16384
		v_lshlrev_b32_e32 v92, 2, v0
		ds_write_b32 v92, v93 offset:17408
		v_add_co_u32_e64 v92, vcc, v116, v3
		v_addc_co_u32_e64 v93, vcc, v117, 0, vcc
		v_add_co_u32_e64 v118, vcc, v92, v106
		v_addc_co_u32_e64 v119, vcc, v93, v107, vcc
		v_add_co_u32_e64 v92, vcc, v118, v114
		v_addc_co_u32_e64 v93, vcc, v119, v115, vcc
		v_add_co_u32_e64 v118, vcc, v92, v108
		v_addc_co_u32_e64 v119, vcc, v93, v109, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_write_b32 v3, v118 offset:18432
		v_lshlrev_b32_e32 v3, 2, v0
		ds_write_b32 v3, v119 offset:19456
		v_add_co_u32_e64 v92, vcc, v116, v8
		v_addc_co_u32_e64 v93, vcc, v117, 0, vcc
		v_add_co_u32_e64 v118, vcc, v92, v106
		v_addc_co_u32_e64 v119, vcc, v93, v107, vcc
		v_add_co_u32_e64 v92, vcc, v118, v114
		v_addc_co_u32_e64 v93, vcc, v119, v115, vcc
		v_add_co_u32_e64 v118, vcc, v92, v108
		v_addc_co_u32_e64 v119, vcc, v93, v109, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_write_b32 v3, v118 offset:20480
		v_lshlrev_b32_e32 v3, 2, v0
		ds_write_b32 v3, v119 offset:21504
		v_add_co_u32_e64 v92, vcc, v116, v11
		v_addc_co_u32_e64 v93, vcc, v117, 0, vcc
		v_add_co_u32_e64 v118, vcc, v92, v106
		v_addc_co_u32_e64 v119, vcc, v93, v107, vcc
		v_add_co_u32_e64 v92, vcc, v118, v114
		v_addc_co_u32_e64 v93, vcc, v119, v115, vcc
		v_add_co_u32_e64 v118, vcc, v92, v108
		v_addc_co_u32_e64 v119, vcc, v93, v109, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_write_b32 v3, v118 offset:22528
		v_lshlrev_b32_e32 v3, 2, v0
		ds_write_b32 v3, v119 offset:23552
		v_add_co_u32_e64 v92, vcc, v116, v85
		v_addc_co_u32_e64 v93, vcc, v117, 0, vcc
		v_add_co_u32_e64 v118, vcc, v92, v106
		v_addc_co_u32_e64 v119, vcc, v93, v107, vcc
		v_add_co_u32_e64 v92, vcc, v118, v114
		v_addc_co_u32_e64 v93, vcc, v119, v115, vcc
		v_add_co_u32_e64 v118, vcc, v92, v108
		v_addc_co_u32_e64 v119, vcc, v93, v109, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v118, s60
		scratch_store_dword off, v119, s60 offset:4
		v_add_co_u32_e64 v92, vcc, v116, v89
		v_addc_co_u32_e64 v93, vcc, v117, 0, vcc
		v_add_co_u32_e64 v118, vcc, v92, v106
		v_addc_co_u32_e64 v119, vcc, v93, v107, vcc
		v_add_co_u32_e64 v92, vcc, v118, v114
		v_addc_co_u32_e64 v93, vcc, v119, v115, vcc
		v_add_co_u32_e64 v118, vcc, v92, v108
		v_addc_co_u32_e64 v119, vcc, v93, v109, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v118, s60 offset:8
		scratch_store_dword off, v119, s60 offset:12
		v_add_co_u32_e64 v92, vcc, v116, v90
		v_addc_co_u32_e64 v93, vcc, v117, 0, vcc
		v_add_co_u32_e64 v118, vcc, v92, v106
		v_addc_co_u32_e64 v119, vcc, v93, v107, vcc
		v_add_co_u32_e64 v92, vcc, v118, v114
		v_addc_co_u32_e64 v93, vcc, v119, v115, vcc
		v_add_co_u32_e64 v118, vcc, v92, v108
		v_addc_co_u32_e64 v119, vcc, v93, v109, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v118, s60 offset:16
		scratch_store_dword off, v119, s60 offset:20
		v_add_co_u32_e64 v92, vcc, v116, v98
		v_addc_co_u32_e64 v93, vcc, v117, 0, vcc
		v_add_co_u32_e64 v98, vcc, v92, v106
		v_addc_co_u32_e64 v99, vcc, v93, v107, vcc
		v_add_co_u32_e64 v92, vcc, v98, v114
		v_addc_co_u32_e64 v93, vcc, v99, v115, vcc
		v_add_co_u32_e64 v98, vcc, v92, v108
		v_addc_co_u32_e64 v99, vcc, v93, v109, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v98, s60 offset:24
		scratch_store_dword off, v99, s60 offset:28
		v_mul_lo_u32 v92, v104, v112
		v_mul_hi_u32 v93, v104, v112
		v_mul_lo_u32 v3, v104, v113
		v_add_u32_e32 v93, v93, v3
		v_mul_lo_u32 v3, v105, v112
		v_add_u32_e32 v93, v93, v3
		v_add_co_u32_e64 v98, vcc, v94, v92
		v_addc_co_u32_e64 v99, vcc, v95, v93, vcc
		v_lshrrev_b64 v[104:105], 7, v[100:101]
		s_mov_b32 s60, 0x400
		s_mov_b32 s61, 0
		v_mov_b32_e32 v100, s60
		v_mov_b32_e32 v101, s61
		v_mul_lo_u32 v112, v100, v104
		v_mul_hi_u32 v113, v100, v104
		v_mul_lo_u32 v3, v100, v105
		v_add_u32_e32 v113, v113, v3
		v_mul_lo_u32 v3, v101, v104
		v_add_u32_e32 v113, v113, v3
		v_add_co_u32_e64 v104, vcc, v98, v112
		v_addc_co_u32_e64 v105, vcc, v99, v113, vcc
		v_mul_lo_u32 v118, v96, v110
		v_mul_hi_u32 v119, v96, v110
		v_mul_lo_u32 v3, v96, v111
		v_add_u32_e32 v119, v119, v3
		v_mul_lo_u32 v3, v97, v110
		v_add_u32_e32 v119, v119, v3
		v_add_co_u32_e64 v96, vcc, v104, v118
		v_addc_co_u32_e64 v97, vcc, v105, v119, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v96, s60 offset:32
		scratch_store_dword off, v97, s60 offset:36
		s_mov_b32 s60, 0x800
		s_mov_b32 s61, 0
		v_mov_b32_e32 v96, s60
		v_mov_b32_e32 v97, s61
		s_mov_b32 s60, 0
		scratch_store_dword off, v96, s60 offset:40
		scratch_store_dword off, v97, s60 offset:44
		v_add_co_u32_e64 v96, vcc, v98, v118
		v_addc_co_u32_e64 v97, vcc, v99, v119, vcc
		v_mov_b32_e32 v3, 1
		v_and_b32_e32 v98, v102, v3
		v_and_b32_e32 v99, v103, v91
		v_mul_lo_u32 v90, v100, v98
		v_mul_hi_u32 v91, v100, v98
		v_mul_lo_u32 v3, v100, v99
		v_add_u32_e32 v91, v91, v3
		v_mul_lo_u32 v3, v101, v98
		v_add_u32_e32 v91, v91, v3
		v_add_co_u32_e64 v98, vcc, v96, v90
		v_addc_co_u32_e64 v99, vcc, v97, v91, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v98, s60 offset:48
		scratch_store_dword off, v99, s60 offset:52
		v_mov_b32_e32 v3, 0x80
		v_add_co_u32_e64 v96, vcc, v94, v3
		v_addc_co_u32_e64 v97, vcc, v95, 0, vcc
		v_add_co_u32_e64 v98, vcc, v96, v106
		v_addc_co_u32_e64 v99, vcc, v97, v107, vcc
		v_add_co_u32_e64 v96, vcc, v98, v114
		v_addc_co_u32_e64 v97, vcc, v99, v115, vcc
		v_add_co_u32_e64 v98, vcc, v96, v108
		v_addc_co_u32_e64 v99, vcc, v97, v109, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v98, s60 offset:56
		scratch_store_dword off, v99, s60 offset:60
		v_mov_b32_e32 v8, 0x40080
		v_add_co_u32_e64 v96, vcc, v94, v8
		v_addc_co_u32_e64 v97, vcc, v95, 0, vcc
		v_add_co_u32_e64 v98, vcc, v96, v106
		v_addc_co_u32_e64 v99, vcc, v97, v107, vcc
		v_add_co_u32_e64 v96, vcc, v98, v114
		v_addc_co_u32_e64 v97, vcc, v99, v115, vcc
		v_add_co_u32_e64 v98, vcc, v96, v108
		v_addc_co_u32_e64 v99, vcc, v97, v109, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v98, s60 offset:64
		scratch_store_dword off, v99, s60 offset:68
		v_mov_b32_e32 v11, 0x80080
		v_add_co_u32_e64 v96, vcc, v94, v11
		v_addc_co_u32_e64 v97, vcc, v95, 0, vcc
		v_add_co_u32_e64 v98, vcc, v96, v106
		v_addc_co_u32_e64 v99, vcc, v97, v107, vcc
		v_add_co_u32_e64 v96, vcc, v98, v114
		v_addc_co_u32_e64 v97, vcc, v99, v115, vcc
		v_add_co_u32_e64 v98, vcc, v96, v108
		v_addc_co_u32_e64 v99, vcc, v97, v109, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v98, s60 offset:72
		scratch_store_dword off, v99, s60 offset:76
		v_mov_b32_e32 v85, 0xc0080
		v_add_co_u32_e64 v96, vcc, v94, v85
		v_addc_co_u32_e64 v97, vcc, v95, 0, vcc
		v_add_co_u32_e64 v98, vcc, v96, v106
		v_addc_co_u32_e64 v99, vcc, v97, v107, vcc
		v_add_co_u32_e64 v96, vcc, v98, v114
		v_addc_co_u32_e64 v97, vcc, v99, v115, vcc
		v_add_co_u32_e64 v98, vcc, v96, v108
		v_addc_co_u32_e64 v99, vcc, v97, v109, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v98, s60 offset:80
		scratch_store_dword off, v99, s60 offset:84
		v_mov_b32_e32 v89, 0xc0
		v_add_co_u32_e64 v96, vcc, v94, v89
		v_addc_co_u32_e64 v97, vcc, v95, 0, vcc
		v_add_co_u32_e64 v98, vcc, v96, v106
		v_addc_co_u32_e64 v99, vcc, v97, v107, vcc
		v_add_co_u32_e64 v96, vcc, v98, v114
		v_addc_co_u32_e64 v97, vcc, v99, v115, vcc
		v_add_co_u32_e64 v98, vcc, v96, v108
		v_addc_co_u32_e64 v99, vcc, v97, v109, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v98, s60 offset:88
		scratch_store_dword off, v99, s60 offset:92
		v_mov_b32_e32 v96, 0x400c0
		v_add_co_u32_e64 v98, vcc, v94, v96
		v_addc_co_u32_e64 v99, vcc, v95, 0, vcc
		v_add_co_u32_e64 v100, vcc, v98, v106
		v_addc_co_u32_e64 v101, vcc, v99, v107, vcc
		v_add_co_u32_e64 v98, vcc, v100, v114
		v_addc_co_u32_e64 v99, vcc, v101, v115, vcc
		v_add_co_u32_e64 v100, vcc, v98, v108
		v_addc_co_u32_e64 v101, vcc, v99, v109, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v100, s60 offset:96
		scratch_store_dword off, v101, s60 offset:100
		v_mov_b32_e32 v97, 0x800c0
		v_add_co_u32_e64 v98, vcc, v94, v97
		v_addc_co_u32_e64 v99, vcc, v95, 0, vcc
		v_add_co_u32_e64 v100, vcc, v98, v106
		v_addc_co_u32_e64 v101, vcc, v99, v107, vcc
		v_add_co_u32_e64 v98, vcc, v100, v114
		v_addc_co_u32_e64 v99, vcc, v101, v115, vcc
		v_add_co_u32_e64 v100, vcc, v98, v108
		v_addc_co_u32_e64 v101, vcc, v99, v109, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v100, s60 offset:104
		scratch_store_dword off, v101, s60 offset:108
		v_mov_b32_e32 v98, 0xc00c0
		v_add_co_u32_e64 v100, vcc, v94, v98
		v_addc_co_u32_e64 v101, vcc, v95, 0, vcc
		v_add_co_u32_e64 v102, vcc, v100, v106
		v_addc_co_u32_e64 v103, vcc, v101, v107, vcc
		v_add_co_u32_e64 v100, vcc, v102, v114
		v_addc_co_u32_e64 v101, vcc, v103, v115, vcc
		v_add_co_u32_e64 v102, vcc, v100, v108
		v_addc_co_u32_e64 v103, vcc, v101, v109, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v102, s60 offset:112
		scratch_store_dword off, v103, s60 offset:116
		v_add_co_u32_e64 v100, vcc, v116, v3
		v_addc_co_u32_e64 v101, vcc, v117, 0, vcc
		v_add_co_u32_e64 v102, vcc, v100, v106
		v_addc_co_u32_e64 v103, vcc, v101, v107, vcc
		v_add_co_u32_e64 v100, vcc, v102, v114
		v_addc_co_u32_e64 v101, vcc, v103, v115, vcc
		v_add_co_u32_e64 v102, vcc, v100, v108
		v_addc_co_u32_e64 v103, vcc, v101, v109, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v102, s60 offset:120
		scratch_store_dword off, v103, s60 offset:124
		v_add_co_u32_e64 v100, vcc, v116, v8
		v_addc_co_u32_e64 v101, vcc, v117, 0, vcc
		v_add_co_u32_e64 v102, vcc, v100, v106
		v_addc_co_u32_e64 v103, vcc, v101, v107, vcc
		v_add_co_u32_e64 v100, vcc, v102, v114
		v_addc_co_u32_e64 v101, vcc, v103, v115, vcc
		v_add_co_u32_e64 v102, vcc, v100, v108
		v_addc_co_u32_e64 v103, vcc, v101, v109, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v102, s60 offset:128
		scratch_store_dword off, v103, s60 offset:132
		v_add_co_u32_e64 v100, vcc, v116, v11
		v_addc_co_u32_e64 v101, vcc, v117, 0, vcc
		v_add_co_u32_e64 v102, vcc, v100, v106
		v_addc_co_u32_e64 v103, vcc, v101, v107, vcc
		v_add_co_u32_e64 v100, vcc, v102, v114
		v_addc_co_u32_e64 v101, vcc, v103, v115, vcc
		v_add_co_u32_e64 v102, vcc, v100, v108
		v_addc_co_u32_e64 v103, vcc, v101, v109, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v102, s60 offset:136
		scratch_store_dword off, v103, s60 offset:140
		v_add_co_u32_e64 v100, vcc, v116, v85
		v_addc_co_u32_e64 v101, vcc, v117, 0, vcc
		v_add_co_u32_e64 v102, vcc, v100, v106
		v_addc_co_u32_e64 v103, vcc, v101, v107, vcc
		v_add_co_u32_e64 v100, vcc, v102, v114
		v_addc_co_u32_e64 v101, vcc, v103, v115, vcc
		v_add_co_u32_e64 v102, vcc, v100, v108
		v_addc_co_u32_e64 v103, vcc, v101, v109, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v102, s60 offset:144
		scratch_store_dword off, v103, s60 offset:148
		v_add_co_u32_e64 v100, vcc, v116, v89
		v_addc_co_u32_e64 v101, vcc, v117, 0, vcc
		v_add_co_u32_e64 v102, vcc, v100, v106
		v_addc_co_u32_e64 v103, vcc, v101, v107, vcc
		v_add_co_u32_e64 v100, vcc, v102, v114
		v_addc_co_u32_e64 v101, vcc, v103, v115, vcc
		v_add_co_u32_e64 v102, vcc, v100, v108
		v_addc_co_u32_e64 v103, vcc, v101, v109, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v102, s60 offset:152
		scratch_store_dword off, v103, s60 offset:156
		v_add_co_u32_e64 v100, vcc, v116, v96
		v_addc_co_u32_e64 v101, vcc, v117, 0, vcc
		v_add_co_u32_e64 v102, vcc, v100, v106
		v_addc_co_u32_e64 v103, vcc, v101, v107, vcc
		v_add_co_u32_e64 v100, vcc, v102, v114
		v_addc_co_u32_e64 v101, vcc, v103, v115, vcc
		v_add_co_u32_e64 v102, vcc, v100, v108
		v_addc_co_u32_e64 v103, vcc, v101, v109, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v102, s60 offset:160
		scratch_store_dword off, v103, s60 offset:164
		v_add_co_u32_e64 v100, vcc, v116, v97
		v_addc_co_u32_e64 v101, vcc, v117, 0, vcc
		v_add_co_u32_e64 v96, vcc, v100, v106
		v_addc_co_u32_e64 v97, vcc, v101, v107, vcc
		v_add_co_u32_e64 v100, vcc, v96, v114
		v_addc_co_u32_e64 v101, vcc, v97, v115, vcc
		v_add_co_u32_e64 v96, vcc, v100, v108
		v_addc_co_u32_e64 v97, vcc, v101, v109, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v96, s60 offset:168
		scratch_store_dword off, v97, s60 offset:172
		v_add_co_u32_e64 v96, vcc, v116, v98
		v_addc_co_u32_e64 v97, vcc, v117, 0, vcc
		v_add_co_u32_e64 v98, vcc, v96, v106
		v_addc_co_u32_e64 v99, vcc, v97, v107, vcc
		v_add_co_u32_e64 v96, vcc, v98, v114
		v_addc_co_u32_e64 v97, vcc, v99, v115, vcc
		v_add_co_u32_e64 v98, vcc, v96, v108
		v_addc_co_u32_e64 v99, vcc, v97, v109, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v98, s60 offset:176
		scratch_store_dword off, v99, s60 offset:180
		v_mov_b32_e32 v3, 0x800
		v_add_co_u32_e64 v96, vcc, v94, v3
		v_addc_co_u32_e64 v97, vcc, v95, 0, vcc
		v_add_co_u32_e64 v94, vcc, v96, v92
		v_addc_co_u32_e64 v95, vcc, v97, v93, vcc
		v_add_co_u32_e64 v92, vcc, v94, v112
		v_addc_co_u32_e64 v93, vcc, v95, v113, vcc
		v_add_co_u32_e64 v96, vcc, v92, v118
		v_addc_co_u32_e64 v97, vcc, v93, v119, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v96, s60 offset:184
		scratch_store_dword off, v97, s60 offset:188
		v_add_co_u32_e64 v92, vcc, v94, v118
		v_addc_co_u32_e64 v93, vcc, v95, v119, vcc
		v_add_co_u32_e64 v94, vcc, v92, v90
		v_addc_co_u32_e64 v95, vcc, v93, v91, vcc
		s_mov_b32 s60, 0
		scratch_store_dword off, v94, s60 offset:192
		scratch_store_dword off, v95, s60 offset:196
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a4, v92
		v_accvgpr_write_b32 a5, v93
		v_accvgpr_write_b32 a6, v94
		v_accvgpr_write_b32 a7, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a8, v92
		v_accvgpr_write_b32 a9, v93
		v_accvgpr_write_b32 a10, v94
		v_accvgpr_write_b32 a11, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a12, v92
		v_accvgpr_write_b32 a13, v93
		v_accvgpr_write_b32 a14, v94
		v_accvgpr_write_b32 a15, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a16, v92
		v_accvgpr_write_b32 a17, v93
		v_accvgpr_write_b32 a18, v94
		v_accvgpr_write_b32 a19, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a20, v92
		v_accvgpr_write_b32 a21, v93
		v_accvgpr_write_b32 a22, v94
		v_accvgpr_write_b32 a23, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a24, v92
		v_accvgpr_write_b32 a25, v93
		v_accvgpr_write_b32 a26, v94
		v_accvgpr_write_b32 a27, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a28, v92
		v_accvgpr_write_b32 a29, v93
		v_accvgpr_write_b32 a30, v94
		v_accvgpr_write_b32 a31, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a32, v92
		v_accvgpr_write_b32 a33, v93
		v_accvgpr_write_b32 a34, v94
		v_accvgpr_write_b32 a35, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a36, v92
		v_accvgpr_write_b32 a37, v93
		v_accvgpr_write_b32 a38, v94
		v_accvgpr_write_b32 a39, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a40, v92
		v_accvgpr_write_b32 a41, v93
		v_accvgpr_write_b32 a42, v94
		v_accvgpr_write_b32 a43, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a44, v92
		v_accvgpr_write_b32 a45, v93
		v_accvgpr_write_b32 a46, v94
		v_accvgpr_write_b32 a47, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a48, v92
		v_accvgpr_write_b32 a49, v93
		v_accvgpr_write_b32 a50, v94
		v_accvgpr_write_b32 a51, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a52, v92
		v_accvgpr_write_b32 a53, v93
		v_accvgpr_write_b32 a54, v94
		v_accvgpr_write_b32 a55, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a56, v92
		v_accvgpr_write_b32 a57, v93
		v_accvgpr_write_b32 a58, v94
		v_accvgpr_write_b32 a59, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a60, v92
		v_accvgpr_write_b32 a61, v93
		v_accvgpr_write_b32 a62, v94
		v_accvgpr_write_b32 a63, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a64, v92
		v_accvgpr_write_b32 a65, v93
		v_accvgpr_write_b32 a66, v94
		v_accvgpr_write_b32 a67, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a68, v92
		v_accvgpr_write_b32 a69, v93
		v_accvgpr_write_b32 a70, v94
		v_accvgpr_write_b32 a71, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a72, v92
		v_accvgpr_write_b32 a73, v93
		v_accvgpr_write_b32 a74, v94
		v_accvgpr_write_b32 a75, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a76, v92
		v_accvgpr_write_b32 a77, v93
		v_accvgpr_write_b32 a78, v94
		v_accvgpr_write_b32 a79, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a80, v92
		v_accvgpr_write_b32 a81, v93
		v_accvgpr_write_b32 a82, v94
		v_accvgpr_write_b32 a83, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a84, v92
		v_accvgpr_write_b32 a85, v93
		v_accvgpr_write_b32 a86, v94
		v_accvgpr_write_b32 a87, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a88, v92
		v_accvgpr_write_b32 a89, v93
		v_accvgpr_write_b32 a90, v94
		v_accvgpr_write_b32 a91, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a92, v92
		v_accvgpr_write_b32 a93, v93
		v_accvgpr_write_b32 a94, v94
		v_accvgpr_write_b32 a95, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a96, v92
		v_accvgpr_write_b32 a97, v93
		v_accvgpr_write_b32 a98, v94
		v_accvgpr_write_b32 a99, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a100, v92
		v_accvgpr_write_b32 a101, v93
		v_accvgpr_write_b32 a102, v94
		v_accvgpr_write_b32 a103, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a104, v92
		v_accvgpr_write_b32 a105, v93
		v_accvgpr_write_b32 a106, v94
		v_accvgpr_write_b32 a107, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a108, v92
		v_accvgpr_write_b32 a109, v93
		v_accvgpr_write_b32 a110, v94
		v_accvgpr_write_b32 a111, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a112, v92
		v_accvgpr_write_b32 a113, v93
		v_accvgpr_write_b32 a114, v94
		v_accvgpr_write_b32 a115, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a116, v92
		v_accvgpr_write_b32 a117, v93
		v_accvgpr_write_b32 a118, v94
		v_accvgpr_write_b32 a119, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a120, v92
		v_accvgpr_write_b32 a121, v93
		v_accvgpr_write_b32 a122, v94
		v_accvgpr_write_b32 a123, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a124, v92
		v_accvgpr_write_b32 a125, v93
		v_accvgpr_write_b32 a126, v94
		v_accvgpr_write_b32 a127, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a128, v92
		v_accvgpr_write_b32 a129, v93
		v_accvgpr_write_b32 a130, v94
		v_accvgpr_write_b32 a131, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a132, v92
		v_accvgpr_write_b32 a133, v93
		v_accvgpr_write_b32 a134, v94
		v_accvgpr_write_b32 a135, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a136, v92
		v_accvgpr_write_b32 a137, v93
		v_accvgpr_write_b32 a138, v94
		v_accvgpr_write_b32 a139, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a140, v92
		v_accvgpr_write_b32 a141, v93
		v_accvgpr_write_b32 a142, v94
		v_accvgpr_write_b32 a143, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a144, v92
		v_accvgpr_write_b32 a145, v93
		v_accvgpr_write_b32 a146, v94
		v_accvgpr_write_b32 a147, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a148, v92
		v_accvgpr_write_b32 a149, v93
		v_accvgpr_write_b32 a150, v94
		v_accvgpr_write_b32 a151, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a152, v92
		v_accvgpr_write_b32 a153, v93
		v_accvgpr_write_b32 a154, v94
		v_accvgpr_write_b32 a155, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a156, v92
		v_accvgpr_write_b32 a157, v93
		v_accvgpr_write_b32 a158, v94
		v_accvgpr_write_b32 a159, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a160, v92
		v_accvgpr_write_b32 a161, v93
		v_accvgpr_write_b32 a162, v94
		v_accvgpr_write_b32 a163, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a164, v92
		v_accvgpr_write_b32 a165, v93
		v_accvgpr_write_b32 a166, v94
		v_accvgpr_write_b32 a167, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a168, v92
		v_accvgpr_write_b32 a169, v93
		v_accvgpr_write_b32 a170, v94
		v_accvgpr_write_b32 a171, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a172, v92
		v_accvgpr_write_b32 a173, v93
		v_accvgpr_write_b32 a174, v94
		v_accvgpr_write_b32 a175, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a176, v92
		v_accvgpr_write_b32 a177, v93
		v_accvgpr_write_b32 a178, v94
		v_accvgpr_write_b32 a179, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a180, v92
		v_accvgpr_write_b32 a181, v93
		v_accvgpr_write_b32 a182, v94
		v_accvgpr_write_b32 a183, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a184, v92
		v_accvgpr_write_b32 a185, v93
		v_accvgpr_write_b32 a186, v94
		v_accvgpr_write_b32 a187, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a188, v92
		v_accvgpr_write_b32 a189, v93
		v_accvgpr_write_b32 a190, v94
		v_accvgpr_write_b32 a191, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a192, v92
		v_accvgpr_write_b32 a193, v93
		v_accvgpr_write_b32 a194, v94
		v_accvgpr_write_b32 a195, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a196, v92
		v_accvgpr_write_b32 a197, v93
		v_accvgpr_write_b32 a198, v94
		v_accvgpr_write_b32 a199, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a200, v92
		v_accvgpr_write_b32 a201, v93
		v_accvgpr_write_b32 a202, v94
		v_accvgpr_write_b32 a203, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a204, v92
		v_accvgpr_write_b32 a205, v93
		v_accvgpr_write_b32 a206, v94
		v_accvgpr_write_b32 a207, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a208, v92
		v_accvgpr_write_b32 a209, v93
		v_accvgpr_write_b32 a210, v94
		v_accvgpr_write_b32 a211, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a212, v92
		v_accvgpr_write_b32 a213, v93
		v_accvgpr_write_b32 a214, v94
		v_accvgpr_write_b32 a215, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a216, v92
		v_accvgpr_write_b32 a217, v93
		v_accvgpr_write_b32 a218, v94
		v_accvgpr_write_b32 a219, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a220, v92
		v_accvgpr_write_b32 a221, v93
		v_accvgpr_write_b32 a222, v94
		v_accvgpr_write_b32 a223, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a224, v92
		v_accvgpr_write_b32 a225, v93
		v_accvgpr_write_b32 a226, v94
		v_accvgpr_write_b32 a227, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a228, v92
		v_accvgpr_write_b32 a229, v93
		v_accvgpr_write_b32 a230, v94
		v_accvgpr_write_b32 a231, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a232, v92
		v_accvgpr_write_b32 a233, v93
		v_accvgpr_write_b32 a234, v94
		v_accvgpr_write_b32 a235, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a236, v92
		v_accvgpr_write_b32 a237, v93
		v_accvgpr_write_b32 a238, v94
		v_accvgpr_write_b32 a239, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a240, v92
		v_accvgpr_write_b32 a241, v93
		v_accvgpr_write_b32 a242, v94
		v_accvgpr_write_b32 a243, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a244, v92
		v_accvgpr_write_b32 a245, v93
		v_accvgpr_write_b32 a246, v94
		v_accvgpr_write_b32 a247, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a248, v92
		v_accvgpr_write_b32 a249, v93
		v_accvgpr_write_b32 a250, v94
		v_accvgpr_write_b32 a251, v95
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_accvgpr_write_b32 a252, v92
		v_accvgpr_write_b32 a253, v93
		v_accvgpr_write_b32 a254, v94
		v_accvgpr_write_b32 a255, v95
.Lwmma_f16_matmul_tiled.loop_head_0:
		v_mov_b32_e32 v90, s11
		v_mov_b32_e32 v91, 0
		v_lshlrev_b32_e32 v3, 2, v0
		s_waitcnt lgkmcnt(6)
		ds_read_b32 v92, v3
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v93, v3 offset:1024
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v94, v92, v90
		v_mul_hi_u32 v95, v92, v90
		v_mul_lo_u32 v3, v92, v91
		v_add_u32_e32 v95, v95, v3
		v_mul_lo_u32 v3, v93, v90
		v_add_u32_e32 v95, v95, v3
		v_accvgpr_read_b32 v92, a2
		v_accvgpr_read_b32 v93, a3
		v_add_co_u32_e64 v96, vcc, v92, v94
		v_addc_co_u32_e64 v97, vcc, v93, v95, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v92, v3 offset:2048
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v93, v3 offset:3072
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v98, vcc, v92, v94
		v_addc_co_u32_e64 v99, vcc, v93, v95, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v92, v3 offset:4096
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v93, v3 offset:5120
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v100, vcc, v92, v94
		v_addc_co_u32_e64 v101, vcc, v93, v95, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v92, v3 offset:6144
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v93, v3 offset:7168
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v102, vcc, v92, v94
		v_addc_co_u32_e64 v103, vcc, v93, v95, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v92, v3 offset:8192
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v93, v3 offset:9216
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v104, vcc, v92, v94
		v_addc_co_u32_e64 v105, vcc, v93, v95, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v92, v3 offset:10240
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v93, v3 offset:11264
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v106, vcc, v92, v94
		v_addc_co_u32_e64 v107, vcc, v93, v95, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v92, v3 offset:12288
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v93, v3 offset:13312
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v108, vcc, v92, v94
		v_addc_co_u32_e64 v109, vcc, v93, v95, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v92, v3 offset:14336
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v93, v3 offset:15360
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v110, vcc, v92, v94
		v_addc_co_u32_e64 v111, vcc, v93, v95, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v92, v3 offset:16384
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v93, v3 offset:17408
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v112, vcc, v92, v94
		v_addc_co_u32_e64 v113, vcc, v93, v95, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v92, v3 offset:18432
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v93, v3 offset:19456
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v114, vcc, v92, v94
		v_addc_co_u32_e64 v115, vcc, v93, v95, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v92, v3 offset:20480
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v93, v3 offset:21504
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v116, vcc, v92, v94
		v_addc_co_u32_e64 v117, vcc, v93, v95, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v92, v3 offset:22528
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v93, v3 offset:23552
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v118, vcc, v92, v94
		v_addc_co_u32_e64 v119, vcc, v93, v95, vcc
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(48)
		scratch_load_dword v92, off, s60
		scratch_load_dword v93, off, s60 offset:4
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v120, vcc, v92, v94
		v_addc_co_u32_e64 v121, vcc, v93, v95, vcc
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(46)
		scratch_load_dword v92, off, s60 offset:8
		scratch_load_dword v93, off, s60 offset:12
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v122, vcc, v92, v94
		v_addc_co_u32_e64 v123, vcc, v93, v95, vcc
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(44)
		scratch_load_dword v92, off, s60 offset:16
		scratch_load_dword v93, off, s60 offset:20
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v124, vcc, v92, v94
		v_addc_co_u32_e64 v125, vcc, v93, v95, vcc
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(42)
		scratch_load_dword v92, off, s60 offset:24
		scratch_load_dword v93, off, s60 offset:28
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v126, vcc, v92, v94
		v_addc_co_u32_e64 v127, vcc, v93, v95, vcc
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(38)
		scratch_load_dword v92, off, s60 offset:40
		scratch_load_dword v93, off, s60 offset:44
		s_waitcnt vmcnt(0)
		v_mul_lo_u32 v128, v92, v90
		v_mul_hi_u32 v129, v92, v90
		v_mul_lo_u32 v3, v92, v91
		v_add_u32_e32 v129, v129, v3
		v_mul_lo_u32 v3, v93, v90
		v_add_u32_e32 v129, v129, v3
		s_mov_b32 s60, 0
		scratch_load_dword v90, off, s60 offset:32
		scratch_load_dword v91, off, s60 offset:36
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v92, vcc, v90, v128
		v_addc_co_u32_e64 v93, vcc, v91, v129, vcc
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(36)
		scratch_load_dword v90, off, s60 offset:48
		scratch_load_dword v91, off, s60 offset:52
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v130, vcc, v90, v128
		v_addc_co_u32_e64 v131, vcc, v91, v129, vcc
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[16:19], v[48:51], v[4:7], v13, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s60, s11, 1
		v_mov_b32_e32 v3, s60
		s_nop 0
		v_readfirstlane_b32 s60, v3
		s_lshl_b32 s61, s60, 16
		v_mov_b32_e32 v8, s61
		s_nop 0
		v_readfirstlane_b32 s60, v8
		s_nop 1
		v_add_u32_e32 v11, s60, v10
		v_add3_u32 v85, v11, v14, v1
		ds_read_b128 v[132:135], v85 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[16:19], v[52:55], a[4:7], v13, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[136:139], v85 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[16:19], v[56:59], a[8:11], v13, v86 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[140:143], v85 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[16:19], v[60:63], a[12:15], v13, v86 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[144:147], v85 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[16:19], v[64:67], a[16:19], v13, v87 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[148:151], v85 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[16:19], v[68:71], a[20:23], v13, v87 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[152:155], v85 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[16:19], v[72:75], a[24:27], v13, v88 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[156:159], v85 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[16:19], v[76:79], a[28:31], v13, v88 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[160:163], v85 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[20:23], v[48:51], a[32:35], v13, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_readfirstlane_b32 s60, v8
		s_nop 1
		v_add_u32_e32 v8, s60, v14
		v_add3_u32 v11, v8, v15, v1
		ds_read_b128 v[164:167], v11 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[20:23], v[52:55], a[36:39], v13, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[168:171], v11 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[20:23], v[56:59], a[40:43], v13, v86 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[172:175], v11 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[20:23], v[60:63], a[44:47], v13, v86 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[176:179], v11 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[20:23], v[64:67], a[48:51], v13, v87 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[180:183], v11 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[20:23], v[68:71], a[52:55], v13, v87 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[184:187], v11 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[20:23], v[72:75], a[56:59], v13, v88 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[188:191], v11 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[20:23], v[76:79], a[60:63], v13, v88 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[192:195], v11 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[24:27], v[48:51], a[64:67], v82, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_nop 0
		buffer_load_dwordx4 v96, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[24:27], v[52:55], a[68:71], v82, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v98, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[24:27], v[56:59], a[72:75], v82, v86 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v100, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[24:27], v[60:63], a[76:79], v82, v86 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v102, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[24:27], v[64:67], a[80:83], v82, v87 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v104, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[24:27], v[68:71], a[84:87], v82, v87 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v106, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[24:27], v[72:75], a[88:91], v82, v88 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v108, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[24:27], v[76:79], a[92:95], v82, v88 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v110, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[28:31], v[48:51], a[96:99], v82, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v112, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[28:31], v[52:55], a[100:103], v82, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v114, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[28:31], v[56:59], a[104:107], v82, v86 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s37
		s_nop 0
		buffer_load_dwordx4 v116, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[28:31], v[60:63], a[108:111], v82, v86 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v118, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[28:31], v[64:67], a[112:115], v82, v87 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v120, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[28:31], v[68:71], a[116:119], v82, v87 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s40
		s_nop 0
		buffer_load_dwordx4 v122, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[28:31], v[72:75], a[120:123], v82, v88 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s41
		s_nop 0
		buffer_load_dwordx4 v124, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[28:31], v[76:79], a[124:127], v82, v88 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s42
		s_nop 0
		buffer_load_dwordx4 v126, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[32:35], v[48:51], a[128:131], v83, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s8, 0x20000
		s_nop 0
		buffer_load_dwordx4 v92, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[32:35], v[52:55], a[132:135], v83, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s44, 0x20000
		s_nop 0
		buffer_load_dwordx4 v130, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[32:35], v[56:59], a[136:139], v83, v86 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		ds_read_b128 v[16:19], v85
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[32:35], v[60:63], a[140:143], v83, v86 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v85 offset:1024
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], v[64:67], a[144:147], v83, v87 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v85 offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[32:35], v[68:71], a[148:151], v83, v87 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[28:31], v85 offset:3072
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[32:35], v[72:75], a[152:155], v83, v88 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v85 offset:4096
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v96, s60 offset:584
		scratch_store_dword off, v97, s60 offset:588
		scratch_store_dword off, v98, s60 offset:592
		scratch_store_dword off, v99, s60 offset:596
		s_mov_b32 s60, 0
		scratch_store_dword off, v96, s60 offset:600
		scratch_store_dword off, v97, s60 offset:604
		scratch_store_dword off, v98, s60 offset:608
		scratch_store_dword off, v99, s60 offset:612
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[32:35], v[76:79], a[156:159], v83, v88 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v85 offset:5120
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v96, s60 offset:552
		scratch_store_dword off, v97, s60 offset:556
		scratch_store_dword off, v98, s60 offset:560
		scratch_store_dword off, v99, s60 offset:564
		s_mov_b32 s60, 0
		scratch_store_dword off, v96, s60 offset:568
		scratch_store_dword off, v97, s60 offset:572
		scratch_store_dword off, v98, s60 offset:576
		scratch_store_dword off, v99, s60 offset:580
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], v[48:51], a[160:163], v83, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v85 offset:6144
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
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[36:39], v[52:55], a[164:167], v83, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v85 offset:7168
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
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[36:39], v[56:59], a[168:171], v83, v86 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v11 offset:32768
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
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[36:39], v[60:63], a[172:175], v83, v86 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v11 offset:33792
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
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[36:39], v[64:67], a[176:179], v83, v87 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v11 offset:34816
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
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[36:39], v[68:71], a[180:183], v83, v87 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v11 offset:35840
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
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[36:39], v[72:75], a[184:187], v83, v88 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v11 offset:36864
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
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[36:39], v[76:79], a[188:191], v83, v88 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v11 offset:37888
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
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[40:43], v[48:51], a[192:195], v84, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v11 offset:38912
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
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[40:43], v[52:55], a[196:199], v84, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v11 offset:39936
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
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[40:43], v[56:59], a[200:203], v84, v86 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_readfirstlane_b32 s60, v3
		s_lshl_b32 s61, s60, 12
		s_add_i32 s60, s61, 0x20000
		v_add3_u32 v3, s60, v9, v81
		ds_read_b32 v8, v3
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v8, s61 offset:228
		ds_read_b32 v8, v3 offset:256
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v8, s61 offset:224
		ds_read_b32 v8, v3 offset:512
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v8, s61 offset:220
		ds_read_b32 v8, v3 offset:768
		s_mov_b32 s61, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v8, s61 offset:216
		v_add3_u32 v3, s60, v81, v12
		ds_read_b32 v8, v3 offset:2048
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v8, s60 offset:212
		ds_read_b32 v8, v3 offset:2304
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v8, s60 offset:208
		ds_read_b32 v8, v3 offset:2560
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v8, s60 offset:204
		ds_read_b32 v8, v3 offset:2816
		s_mov_b32 s60, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v8, s60 offset:200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[40:43], v[60:63], a[204:207], v84, v86 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[40:43], v[64:67], a[208:211], v84, v87 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[40:43], v[68:71], a[212:215], v84, v87 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[40:43], v[72:75], a[216:219], v84, v88 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[40:43], v[76:79], a[220:223], v84, v88 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[44:47], v[48:51], a[224:227], v84, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[44:47], v[52:55], a[228:231], v84, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[44:47], v[56:59], a[232:235], v84, v86 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[44:47], v[60:63], a[236:239], v84, v86 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[44:47], v[64:67], a[240:243], v84, v87 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[44:47], v[68:71], a[244:247], v84, v87 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[44:47], v[72:75], a[248:251], v84, v88 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[44:47], v[76:79], a[252:255], v84, v88 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[132:135], v[164:167], v[4:7], v13, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[132:135], v[168:171], a[4:7], v13, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[132:135], v[172:175], a[8:11], v13, v86 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[132:135], v[176:179], a[12:15], v13, v86 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[132:135], v[180:183], a[16:19], v13, v87 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[132:135], v[184:187], a[20:23], v13, v87 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[132:135], v[188:191], a[24:27], v13, v88 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[132:135], v[192:195], a[28:31], v13, v88 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[136:139], v[164:167], a[32:35], v13, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[136:139], v[168:171], a[36:39], v13, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[136:139], v[172:175], a[40:43], v13, v86 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[136:139], v[176:179], a[44:47], v13, v86 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[136:139], v[180:183], a[48:51], v13, v87 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[136:139], v[184:187], a[52:55], v13, v87 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[136:139], v[188:191], a[56:59], v13, v88 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[136:139], v[192:195], a[60:63], v13, v88 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[140:143], v[164:167], a[64:67], v82, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[140:143], v[168:171], a[68:71], v82, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[140:143], v[172:175], a[72:75], v82, v86 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[140:143], v[176:179], a[76:79], v82, v86 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[140:143], v[180:183], a[80:83], v82, v87 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[140:143], v[184:187], a[84:87], v82, v87 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[140:143], v[188:191], a[88:91], v82, v88 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[140:143], v[192:195], a[92:95], v82, v88 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[144:147], v[164:167], a[96:99], v82, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[144:147], v[168:171], a[100:103], v82, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[144:147], v[172:175], a[104:107], v82, v86 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[144:147], v[176:179], a[108:111], v82, v86 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[144:147], v[180:183], a[112:115], v82, v87 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[144:147], v[184:187], a[116:119], v82, v87 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[144:147], v[188:191], a[120:123], v82, v88 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[144:147], v[192:195], a[124:127], v82, v88 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[148:151], v[164:167], a[128:131], v83, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[148:151], v[168:171], a[132:135], v83, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[148:151], v[172:175], a[136:139], v83, v86 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[148:151], v[176:179], a[140:143], v83, v86 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[148:151], v[180:183], a[144:147], v83, v87 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[148:151], v[184:187], a[148:151], v83, v87 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[148:151], v[188:191], a[152:155], v83, v88 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[148:151], v[192:195], a[156:159], v83, v88 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[152:155], v[164:167], a[160:163], v83, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[152:155], v[168:171], a[164:167], v83, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[152:155], v[172:175], a[168:171], v83, v86 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[152:155], v[176:179], a[172:175], v83, v86 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[152:155], v[180:183], a[176:179], v83, v87 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[152:155], v[184:187], a[180:183], v83, v87 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[152:155], v[188:191], a[184:187], v83, v88 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[152:155], v[192:195], a[188:191], v83, v88 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[156:159], v[164:167], a[192:195], v84, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[156:159], v[168:171], a[196:199], v84, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[156:159], v[172:175], a[200:203], v84, v86 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[156:159], v[176:179], a[204:207], v84, v86 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[156:159], v[180:183], a[208:211], v84, v87 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[156:159], v[184:187], a[212:215], v84, v87 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[156:159], v[188:191], a[216:219], v84, v88 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[156:159], v[192:195], a[220:223], v84, v88 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[160:163], v[164:167], a[224:227], v84, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[160:163], v[168:171], a[228:231], v84, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[160:163], v[172:175], a[232:235], v84, v86 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[160:163], v[176:179], a[236:239], v84, v86 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[160:163], v[180:183], a[240:243], v84, v87 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[160:163], v[184:187], a[244:247], v84, v87 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[160:163], v[188:191], a[248:251], v84, v88 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[160:163], v[192:195], a[252:255], v84, v88 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s60, s11, 1
		s_and_b32 s61, s60, 1
		s_lshl_b32 s60, s61, 16
		v_add_u32_e32 v3, s60, v10
		v_add3_u32 v8, v3, v14, v1
		ds_read_b128 v[96:99], v8
		ds_read_b128 v[100:103], v8 offset:1024
		ds_read_b128 v[104:107], v8 offset:2048
		ds_read_b128 v[108:111], v8 offset:3072
		ds_read_b128 v[112:115], v8 offset:4096
		ds_read_b128 v[116:119], v8 offset:5120
		ds_read_b128 v[120:123], v8 offset:6144
		ds_read_b128 v[124:127], v8 offset:7168
		v_add_u32_e32 v3, s60, v14
		v_add3_u32 v11, v3, v15, v1
		ds_read_b128 v[132:135], v11 offset:32768
		ds_read_b128 v[136:139], v11 offset:33792
		ds_read_b128 v[140:143], v11 offset:34816
		ds_read_b128 v[144:147], v11 offset:35840
		ds_read_b128 v[148:151], v11 offset:36864
		ds_read_b128 v[152:155], v11 offset:37888
		ds_read_b128 v[156:159], v11 offset:38912
		ds_read_b128 v[160:163], v11 offset:39936
		s_lshl_b32 s60, s61, 12
		s_add_i32 s61, s60, 0x20000
		v_add3_u32 v3, s61, v9, v81
		ds_read_b32 v85, v3
		ds_read_b32 v89, v3 offset:256
		ds_read_b32 v90, v3 offset:512
		ds_read_b32 v91, v3 offset:768
		v_add3_u32 v3, s61, v81, v12
		ds_read_b32 v92, v3 offset:2048
		ds_read_b32 v93, v3 offset:2304
		ds_read_b32 v130, v3 offset:2560
		ds_read_b32 v131, v3 offset:2816
		s_waitcnt lgkmcnt(0)
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(63) expcnt(7) lgkmcnt(15)
		scratch_load_dword v164, off, s60 offset:56
		scratch_load_dword v165, off, s60 offset:60
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v166, vcc, v164, v94
		v_addc_co_u32_e64 v167, vcc, v165, v95, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:64
		scratch_load_dword v165, off, s60 offset:68
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v168, vcc, v164, v94
		v_addc_co_u32_e64 v169, vcc, v165, v95, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:72
		scratch_load_dword v165, off, s60 offset:76
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v170, vcc, v164, v94
		v_addc_co_u32_e64 v171, vcc, v165, v95, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:80
		scratch_load_dword v165, off, s60 offset:84
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v172, vcc, v164, v94
		v_addc_co_u32_e64 v173, vcc, v165, v95, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:88
		scratch_load_dword v165, off, s60 offset:92
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v174, vcc, v164, v94
		v_addc_co_u32_e64 v175, vcc, v165, v95, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:96
		scratch_load_dword v165, off, s60 offset:100
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v176, vcc, v164, v94
		v_addc_co_u32_e64 v177, vcc, v165, v95, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:104
		scratch_load_dword v165, off, s60 offset:108
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v178, vcc, v164, v94
		v_addc_co_u32_e64 v179, vcc, v165, v95, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:112
		scratch_load_dword v165, off, s60 offset:116
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v180, vcc, v164, v94
		v_addc_co_u32_e64 v181, vcc, v165, v95, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:120
		scratch_load_dword v165, off, s60 offset:124
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v182, vcc, v164, v94
		v_addc_co_u32_e64 v183, vcc, v165, v95, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:128
		scratch_load_dword v165, off, s60 offset:132
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v184, vcc, v164, v94
		v_addc_co_u32_e64 v185, vcc, v165, v95, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:136
		scratch_load_dword v165, off, s60 offset:140
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v186, vcc, v164, v94
		v_addc_co_u32_e64 v187, vcc, v165, v95, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:144
		scratch_load_dword v165, off, s60 offset:148
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v188, vcc, v164, v94
		v_addc_co_u32_e64 v189, vcc, v165, v95, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:152
		scratch_load_dword v165, off, s60 offset:156
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v190, vcc, v164, v94
		v_addc_co_u32_e64 v191, vcc, v165, v95, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:160
		scratch_load_dword v165, off, s60 offset:164
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v192, vcc, v164, v94
		v_addc_co_u32_e64 v193, vcc, v165, v95, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:168
		scratch_load_dword v165, off, s60 offset:172
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v194, vcc, v164, v94
		v_addc_co_u32_e64 v195, vcc, v165, v95, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v164, off, s60 offset:176
		scratch_load_dword v165, off, s60 offset:180
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v196, vcc, v164, v94
		v_addc_co_u32_e64 v197, vcc, v165, v95, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v94, off, s60 offset:184
		scratch_load_dword v95, off, s60 offset:188
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v164, vcc, v94, v128
		v_addc_co_u32_e64 v165, vcc, v95, v129, vcc
		s_mov_b32 s60, 0
		scratch_load_dword v94, off, s60 offset:192
		scratch_load_dword v95, off, s60 offset:196
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v198, vcc, v94, v128
		v_addc_co_u32_e64 v199, vcc, v95, v129, vcc
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[96:99], v[132:135], v[4:7], v85, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[200:203], v8 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[96:99], v[136:139], a[4:7], v85, v92 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[204:207], v8 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[96:99], v[140:143], a[8:11], v85, v93 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[208:211], v8 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[96:99], v[144:147], a[12:15], v85, v93 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[212:215], v8 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[96:99], v[148:151], a[16:19], v85, v130 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v8 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[96:99], v[152:155], a[20:23], v85, v130 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v8 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[96:99], v[156:159], a[24:27], v85, v131 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v8 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[96:99], v[160:163], a[28:31], v85, v131 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v8 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[100:103], v[132:135], a[32:35], v85, v92 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v11 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[100:103], v[136:139], a[36:39], v85, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[232:235], v11 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[100:103], v[140:143], a[40:43], v85, v93 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[236:239], v11 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[100:103], v[144:147], a[44:47], v85, v93 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v11 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[100:103], v[148:151], a[48:51], v85, v130 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[244:247], v11 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[100:103], v[152:155], a[52:55], v85, v130 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v11 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[100:103], v[156:159], a[56:59], v85, v131 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[252:255], v11 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[100:103], v[160:163], a[60:63], v85, v131 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v11 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[104:107], v[132:135], a[64:67], v89, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s10
		s_nop 0
		buffer_load_dwordx4 v166, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[104:107], v[136:139], a[68:71], v89, v92 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s45
		s_nop 0
		buffer_load_dwordx4 v168, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[104:107], v[140:143], a[72:75], v89, v93 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s46
		s_nop 0
		buffer_load_dwordx4 v170, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[104:107], v[144:147], a[76:79], v89, v93 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s47
		s_nop 0
		buffer_load_dwordx4 v172, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[104:107], v[148:151], a[80:83], v89, v130 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s48
		s_nop 0
		buffer_load_dwordx4 v174, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[104:107], v[152:155], a[84:87], v89, v130 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s49
		s_nop 0
		buffer_load_dwordx4 v176, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[104:107], v[156:159], a[88:91], v89, v131 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v178, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[104:107], v[160:163], a[92:95], v89, v131 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s51
		s_nop 0
		buffer_load_dwordx4 v180, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[108:111], v[132:135], a[96:99], v89, v92 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s52
		s_nop 0
		buffer_load_dwordx4 v182, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[108:111], v[136:139], a[100:103], v89, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s53
		s_nop 0
		buffer_load_dwordx4 v184, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[108:111], v[140:143], a[104:107], v89, v93 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s54
		s_nop 0
		buffer_load_dwordx4 v186, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[108:111], v[144:147], a[108:111], v89, v93 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s55
		s_nop 0
		buffer_load_dwordx4 v188, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[108:111], v[148:151], a[112:115], v89, v130 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s56
		s_nop 0
		buffer_load_dwordx4 v190, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[108:111], v[152:155], a[116:119], v89, v130 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s57
		s_nop 0
		buffer_load_dwordx4 v192, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[108:111], v[156:159], a[120:123], v89, v131 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s58
		s_nop 0
		buffer_load_dwordx4 v194, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[108:111], v[160:163], a[124:127], v89, v131 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s59
		s_nop 0
		buffer_load_dwordx4 v196, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[112:115], v[132:135], a[128:131], v90, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s43, 0x20000
		s_nop 0
		buffer_load_dwordx4 v164, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[112:115], v[136:139], a[132:135], v90, v92 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s9, 0x20000
		s_nop 0
		buffer_load_dwordx4 v198, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[112:115], v[140:143], a[136:139], v90, v93 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[112:115], v[144:147], a[140:143], v90, v93 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[112:115], v[148:151], a[144:147], v90, v130 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[112:115], v[152:155], a[148:151], v90, v130 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[112:115], v[156:159], a[152:155], v90, v131 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[112:115], v[160:163], a[156:159], v90, v131 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[116:119], v[132:135], a[160:163], v90, v92 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[116:119], v[136:139], a[164:167], v90, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[116:119], v[140:143], a[168:171], v90, v93 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[116:119], v[144:147], a[172:175], v90, v93 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[116:119], v[148:151], a[176:179], v90, v130 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[116:119], v[152:155], a[180:183], v90, v130 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[116:119], v[156:159], a[184:187], v90, v131 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[116:119], v[160:163], a[188:191], v90, v131 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[120:123], v[132:135], a[192:195], v91, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[120:123], v[136:139], a[196:199], v91, v92 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[120:123], v[140:143], a[200:203], v91, v93 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[120:123], v[144:147], a[204:207], v91, v93 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[120:123], v[148:151], a[208:211], v91, v130 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[120:123], v[152:155], a[212:215], v91, v130 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[120:123], v[156:159], a[216:219], v91, v131 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[120:123], v[160:163], a[220:223], v91, v131 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[124:127], v[132:135], a[224:227], v91, v92 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[124:127], v[136:139], a[228:231], v91, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[124:127], v[140:143], a[232:235], v91, v93 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[124:127], v[144:147], a[236:239], v91, v93 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[124:127], v[148:151], a[240:243], v91, v130 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[124:127], v[152:155], a[244:247], v91, v130 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[124:127], v[156:159], a[248:251], v91, v131 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[124:127], v[160:163], a[252:255], v91, v131 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[200:203], v[228:231], v[4:7], v85, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[200:203], v[232:235], a[4:7], v85, v92 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[200:203], v[236:239], a[8:11], v85, v93 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[200:203], v[240:243], a[12:15], v85, v93 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[200:203], v[244:247], a[16:19], v85, v130 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[200:203], v[248:251], a[20:23], v85, v130 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[200:203], v[252:255], a[24:27], v85, v131 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[200:203], v[100:103], a[28:31], v85, v131 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[204:207], v[228:231], a[32:35], v85, v92 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[204:207], v[232:235], a[36:39], v85, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[204:207], v[236:239], a[40:43], v85, v93 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[204:207], v[240:243], a[44:47], v85, v93 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[204:207], v[244:247], a[48:51], v85, v130 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[204:207], v[248:251], a[52:55], v85, v130 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[204:207], v[252:255], a[56:59], v85, v131 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[204:207], v[100:103], a[60:63], v85, v131 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[208:211], v[228:231], a[64:67], v89, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[208:211], v[232:235], a[68:71], v89, v92 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[208:211], v[236:239], a[72:75], v89, v93 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[208:211], v[240:243], a[76:79], v89, v93 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[208:211], v[244:247], a[80:83], v89, v130 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[208:211], v[248:251], a[84:87], v89, v130 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[208:211], v[252:255], a[88:91], v89, v131 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[208:211], v[100:103], a[92:95], v89, v131 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[212:215], v[228:231], a[96:99], v89, v92 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[212:215], v[232:235], a[100:103], v89, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[212:215], v[236:239], a[104:107], v89, v93 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[212:215], v[240:243], a[108:111], v89, v93 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[212:215], v[244:247], a[112:115], v89, v130 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[212:215], v[248:251], a[116:119], v89, v130 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[212:215], v[252:255], a[120:123], v89, v131 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[212:215], v[100:103], a[124:127], v89, v131 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[216:219], v[228:231], a[128:131], v90, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[216:219], v[232:235], a[132:135], v90, v92 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[216:219], v[236:239], a[136:139], v90, v93 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[216:219], v[240:243], a[140:143], v90, v93 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[216:219], v[244:247], a[144:147], v90, v130 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[216:219], v[248:251], a[148:151], v90, v130 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[216:219], v[252:255], a[152:155], v90, v131 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[216:219], v[100:103], a[156:159], v90, v131 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[220:223], v[228:231], a[160:163], v90, v92 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[220:223], v[232:235], a[164:167], v90, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[220:223], v[236:239], a[168:171], v90, v93 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[220:223], v[240:243], a[172:175], v90, v93 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[220:223], v[244:247], a[176:179], v90, v130 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[220:223], v[248:251], a[180:183], v90, v130 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[220:223], v[252:255], a[184:187], v90, v131 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[220:223], v[100:103], a[188:191], v90, v131 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[224:227], v[228:231], a[192:195], v91, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[224:227], v[232:235], a[196:199], v91, v92 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[224:227], v[236:239], a[200:203], v91, v93 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[224:227], v[240:243], a[204:207], v91, v93 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[224:227], v[244:247], a[208:211], v91, v130 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[224:227], v[248:251], a[212:215], v91, v130 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[224:227], v[252:255], a[216:219], v91, v131 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[224:227], v[100:103], a[220:223], v91, v131 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[96:99], v[228:231], a[224:227], v91, v92 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[96:99], v[232:235], a[228:231], v91, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[96:99], v[236:239], a[232:235], v91, v93 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[96:99], v[240:243], a[236:239], v91, v93 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[96:99], v[244:247], a[240:243], v91, v130 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[96:99], v[248:251], a[244:247], v91, v130 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[96:99], v[252:255], a[248:251], v91, v131 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[96:99], v[100:103], a[252:255], v91, v131 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s11, s11, 2
		v_readfirstlane_b32 s60, v2
		s_cmp_lt_i32 s11, s60
		s_mov_b32 s60, 0
		s_nop 2
		scratch_load_dword v92, off, s60 offset:600
		scratch_load_dword v93, off, s60 offset:604
		scratch_load_dword v94, off, s60 offset:608
		scratch_load_dword v95, off, s60 offset:612
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v32, v92
		v_mov_b32_e32 v33, v93
		v_mov_b32_e32 v34, v94
		v_mov_b32_e32 v35, v95
		s_mov_b32 s60, 0
		scratch_load_dword v92, off, s60 offset:568
		scratch_load_dword v93, off, s60 offset:572
		scratch_load_dword v94, off, s60 offset:576
		scratch_load_dword v95, off, s60 offset:580
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v36, v92
		v_mov_b32_e32 v37, v93
		v_mov_b32_e32 v38, v94
		v_mov_b32_e32 v39, v95
		s_mov_b32 s60, 0
		scratch_load_dword v92, off, s60 offset:536
		scratch_load_dword v93, off, s60 offset:540
		scratch_load_dword v94, off, s60 offset:544
		scratch_load_dword v95, off, s60 offset:548
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v40, v92
		v_mov_b32_e32 v41, v93
		v_mov_b32_e32 v42, v94
		v_mov_b32_e32 v43, v95
		s_mov_b32 s60, 0
		scratch_load_dword v92, off, s60 offset:504
		scratch_load_dword v93, off, s60 offset:508
		scratch_load_dword v94, off, s60 offset:512
		scratch_load_dword v95, off, s60 offset:516
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v44, v92
		v_mov_b32_e32 v45, v93
		v_mov_b32_e32 v46, v94
		v_mov_b32_e32 v47, v95
		s_mov_b32 s60, 0
		scratch_load_dword v92, off, s60 offset:472
		scratch_load_dword v93, off, s60 offset:476
		scratch_load_dword v94, off, s60 offset:480
		scratch_load_dword v95, off, s60 offset:484
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v48, v92
		v_mov_b32_e32 v49, v93
		v_mov_b32_e32 v50, v94
		v_mov_b32_e32 v51, v95
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(56)
		scratch_load_dword v92, off, s60 offset:440
		scratch_load_dword v93, off, s60 offset:444
		scratch_load_dword v94, off, s60 offset:448
		scratch_load_dword v95, off, s60 offset:452
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v52, v92
		v_mov_b32_e32 v53, v93
		v_mov_b32_e32 v54, v94
		v_mov_b32_e32 v55, v95
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(48)
		scratch_load_dword v92, off, s60 offset:408
		scratch_load_dword v93, off, s60 offset:412
		scratch_load_dword v94, off, s60 offset:416
		scratch_load_dword v95, off, s60 offset:420
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v56, v92
		v_mov_b32_e32 v57, v93
		v_mov_b32_e32 v58, v94
		v_mov_b32_e32 v59, v95
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(40)
		scratch_load_dword v92, off, s60 offset:376
		scratch_load_dword v93, off, s60 offset:380
		scratch_load_dword v94, off, s60 offset:384
		scratch_load_dword v95, off, s60 offset:388
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v60, v92
		v_mov_b32_e32 v61, v93
		v_mov_b32_e32 v62, v94
		v_mov_b32_e32 v63, v95
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(32)
		scratch_load_dword v92, off, s60 offset:344
		scratch_load_dword v93, off, s60 offset:348
		scratch_load_dword v94, off, s60 offset:352
		scratch_load_dword v95, off, s60 offset:356
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v64, v92
		v_mov_b32_e32 v65, v93
		v_mov_b32_e32 v66, v94
		v_mov_b32_e32 v67, v95
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v92, off, s60 offset:312
		scratch_load_dword v93, off, s60 offset:316
		scratch_load_dword v94, off, s60 offset:320
		scratch_load_dword v95, off, s60 offset:324
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v68, v92
		v_mov_b32_e32 v69, v93
		v_mov_b32_e32 v70, v94
		v_mov_b32_e32 v71, v95
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v92, off, s60 offset:280
		scratch_load_dword v93, off, s60 offset:284
		scratch_load_dword v94, off, s60 offset:288
		scratch_load_dword v95, off, s60 offset:292
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v72, v92
		v_mov_b32_e32 v73, v93
		v_mov_b32_e32 v74, v94
		v_mov_b32_e32 v75, v95
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v92, off, s60 offset:248
		scratch_load_dword v93, off, s60 offset:252
		scratch_load_dword v94, off, s60 offset:256
		scratch_load_dword v95, off, s60 offset:260
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v76, v92
		v_mov_b32_e32 v77, v93
		v_mov_b32_e32 v78, v94
		v_mov_b32_e32 v79, v95
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(7)
		scratch_load_dword v3, off, s60 offset:228
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v13, v3
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(6)
		scratch_load_dword v3, off, s60 offset:224
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v82, v3
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(5)
		scratch_load_dword v3, off, s60 offset:220
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v83, v3
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v3, off, s60 offset:216
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v84, v3
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(3)
		scratch_load_dword v3, off, s60 offset:212
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v80, v3
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(2)
		scratch_load_dword v3, off, s60 offset:208
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v86, v3
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(1)
		scratch_load_dword v3, off, s60 offset:204
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v87, v3
		s_mov_b32 s60, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v3, off, s60 offset:200
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v88, v3
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_add_i32 s0, s12, -1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[16:19], v[48:51], v[4:7], v13, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s1, s0, 1
		s_lshl_b32 s0, s1, 16
		v_add_u32_e32 v0, s0, v10
		v_add3_u32 v2, v0, v14, v1
		ds_read_b128 v[92:95], v2 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[16:19], v[52:55], a[4:7], v13, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v2 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[16:19], v[56:59], a[8:11], v13, v86 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v2 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[16:19], v[60:63], a[12:15], v13, v86 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[104:107], v2 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[16:19], v[64:67], a[16:19], v13, v87 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[108:111], v2 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[16:19], v[68:71], a[20:23], v13, v87 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[112:115], v2 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[16:19], v[72:75], a[24:27], v13, v88 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[116:119], v2 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[16:19], v[76:79], a[28:31], v13, v88 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[16:19], v2 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[20:23], v[48:51], a[32:35], v13, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v0, s0, v14
		v_add3_u32 v2, v0, v15, v1
		ds_read_b128 v[120:123], v2 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[20:23], v[52:55], a[36:39], v13, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[124:127], v2 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[20:23], v[56:59], a[40:43], v13, v86 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[128:131], v2 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[20:23], v[60:63], a[44:47], v13, v86 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[132:135], v2 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[20:23], v[64:67], a[48:51], v13, v87 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[136:139], v2 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[20:23], v[68:71], a[52:55], v13, v87 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[140:143], v2 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[20:23], v[72:75], a[56:59], v13, v88 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[144:147], v2 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[20:23], v[76:79], a[60:63], v13, v88 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v2 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[24:27], v[48:51], a[64:67], v82, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[24:27], v[52:55], a[68:71], v82, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[24:27], v[56:59], a[72:75], v82, v86 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[24:27], v[60:63], a[76:79], v82, v86 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[24:27], v[64:67], a[80:83], v82, v87 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[24:27], v[68:71], a[84:87], v82, v87 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[24:27], v[72:75], a[88:91], v82, v88 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[24:27], v[76:79], a[92:95], v82, v88 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[28:31], v[48:51], a[96:99], v82, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[28:31], v[52:55], a[100:103], v82, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[28:31], v[56:59], a[104:107], v82, v86 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[28:31], v[60:63], a[108:111], v82, v86 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[28:31], v[64:67], a[112:115], v82, v87 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[28:31], v[68:71], a[116:119], v82, v87 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[28:31], v[72:75], a[120:123], v82, v88 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[28:31], v[76:79], a[124:127], v82, v88 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[32:35], v[48:51], a[128:131], v83, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[32:35], v[52:55], a[132:135], v83, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[32:35], v[56:59], a[136:139], v83, v86 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[32:35], v[60:63], a[140:143], v83, v86 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], v[64:67], a[144:147], v83, v87 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[32:35], v[68:71], a[148:151], v83, v87 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[32:35], v[72:75], a[152:155], v83, v88 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[32:35], v[76:79], a[156:159], v83, v88 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], v[48:51], a[160:163], v83, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[36:39], v[52:55], a[164:167], v83, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[36:39], v[56:59], a[168:171], v83, v86 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[36:39], v[60:63], a[172:175], v83, v86 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[36:39], v[64:67], a[176:179], v83, v87 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[36:39], v[68:71], a[180:183], v83, v87 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[36:39], v[72:75], a[184:187], v83, v88 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[36:39], v[76:79], a[188:191], v83, v88 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[40:43], v[48:51], a[192:195], v84, v80 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[40:43], v[52:55], a[196:199], v84, v80 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[40:43], v[56:59], a[200:203], v84, v86 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[40:43], v[60:63], a[204:207], v84, v86 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[40:43], v[64:67], a[208:211], v84, v87 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[40:43], v[68:71], a[212:215], v84, v87 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[40:43], v[72:75], a[216:219], v84, v88 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[40:43], v[76:79], a[220:223], v84, v88 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[44:47], v[48:51], a[224:227], v84, v80 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[44:47], v[52:55], a[228:231], v84, v80 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[44:47], v[56:59], a[232:235], v84, v86 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[44:47], v[60:63], a[236:239], v84, v86 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[44:47], v[64:67], a[240:243], v84, v87 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[44:47], v[68:71], a[244:247], v84, v87 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[44:47], v[72:75], a[248:251], v84, v88 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[44:47], v[76:79], a[252:255], v84, v88 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[92:95], v[120:123], v[4:7], v13, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[92:95], v[124:127], a[4:7], v13, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[92:95], v[128:131], a[8:11], v13, v86 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[92:95], v[132:135], a[12:15], v13, v86 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[92:95], v[136:139], a[16:19], v13, v87 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[92:95], v[140:143], a[20:23], v13, v87 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[92:95], v[144:147], a[24:27], v13, v88 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[92:95], v[20:23], a[28:31], v13, v88 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[96:99], v[120:123], a[32:35], v13, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[96:99], v[124:127], a[36:39], v13, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[96:99], v[128:131], a[40:43], v13, v86 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[96:99], v[132:135], a[44:47], v13, v86 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[96:99], v[136:139], a[48:51], v13, v87 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[96:99], v[140:143], a[52:55], v13, v87 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[96:99], v[144:147], a[56:59], v13, v88 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[96:99], v[20:23], a[60:63], v13, v88 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[100:103], v[120:123], a[64:67], v82, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[100:103], v[124:127], a[68:71], v82, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[100:103], v[128:131], a[72:75], v82, v86 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[100:103], v[132:135], a[76:79], v82, v86 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[100:103], v[136:139], a[80:83], v82, v87 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[100:103], v[140:143], a[84:87], v82, v87 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[100:103], v[144:147], a[88:91], v82, v88 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[100:103], v[20:23], a[92:95], v82, v88 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[104:107], v[120:123], a[96:99], v82, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[104:107], v[124:127], a[100:103], v82, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[104:107], v[128:131], a[104:107], v82, v86 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[104:107], v[132:135], a[108:111], v82, v86 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[104:107], v[136:139], a[112:115], v82, v87 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[104:107], v[140:143], a[116:119], v82, v87 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[104:107], v[144:147], a[120:123], v82, v88 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[104:107], v[20:23], a[124:127], v82, v88 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[108:111], v[120:123], a[128:131], v83, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[108:111], v[124:127], a[132:135], v83, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[108:111], v[128:131], a[136:139], v83, v86 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[108:111], v[132:135], a[140:143], v83, v86 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[108:111], v[136:139], a[144:147], v83, v87 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[108:111], v[140:143], a[148:151], v83, v87 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[108:111], v[144:147], a[152:155], v83, v88 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[108:111], v[20:23], a[156:159], v83, v88 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[112:115], v[120:123], a[160:163], v83, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[112:115], v[124:127], a[164:167], v83, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[112:115], v[128:131], a[168:171], v83, v86 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[112:115], v[132:135], a[172:175], v83, v86 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[112:115], v[136:139], a[176:179], v83, v87 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[112:115], v[140:143], a[180:183], v83, v87 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[112:115], v[144:147], a[184:187], v83, v88 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[112:115], v[20:23], a[188:191], v83, v88 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[116:119], v[120:123], a[192:195], v84, v80 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[116:119], v[124:127], a[196:199], v84, v80 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[116:119], v[128:131], a[200:203], v84, v86 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[116:119], v[132:135], a[204:207], v84, v86 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[116:119], v[136:139], a[208:211], v84, v87 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[116:119], v[140:143], a[212:215], v84, v87 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[116:119], v[144:147], a[216:219], v84, v88 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[116:119], v[20:23], a[220:223], v84, v88 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[16:19], v[120:123], a[224:227], v84, v80 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[16:19], v[124:127], a[228:231], v84, v80 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[16:19], v[128:131], a[232:235], v84, v86 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[16:19], v[132:135], a[236:239], v84, v86 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[16:19], v[136:139], a[240:243], v84, v87 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[16:19], v[140:143], a[244:247], v84, v87 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[16:19], v[144:147], a[248:251], v84, v88 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[16:19], v[20:23], a[252:255], v84, v88 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s0, s12, 1
		s_lshl_b32 s1, s0, 16
		v_add_u32_e32 v0, s1, v10
		v_add3_u32 v2, v0, v14, v1
		ds_read_b128 v[16:19], v2
		ds_read_b128 v[20:23], v2 offset:1024
		ds_read_b128 v[24:27], v2 offset:2048
		ds_read_b128 v[28:31], v2 offset:3072
		ds_read_b128 v[32:35], v2 offset:4096
		ds_read_b128 v[36:39], v2 offset:5120
		ds_read_b128 v[40:43], v2 offset:6144
		ds_read_b128 v[44:47], v2 offset:7168
		v_add_u32_e32 v0, s1, v14
		v_add3_u32 v3, v0, v15, v1
		ds_read_b128 v[48:51], v3 offset:32768
		ds_read_b128 v[52:55], v3 offset:33792
		ds_read_b128 v[56:59], v3 offset:34816
		ds_read_b128 v[60:63], v3 offset:35840
		ds_read_b128 v[64:67], v3 offset:36864
		ds_read_b128 v[68:71], v3 offset:37888
		ds_read_b128 v[72:75], v3 offset:38912
		ds_read_b128 v[76:79], v3 offset:39936
		s_lshl_b32 s1, s0, 12
		s_add_i32 s0, s1, 0x20000
		v_add3_u32 v0, s0, v9, v81
		ds_read_b32 v1, v0
		ds_read_b32 v8, v0 offset:256
		ds_read_b32 v9, v0 offset:512
		ds_read_b32 v10, v0 offset:768
		v_add3_u32 v0, s0, v81, v12
		ds_read_b32 v11, v0 offset:2048
		ds_read_b32 v12, v0 offset:2304
		ds_read_b32 v13, v0 offset:2560
		ds_read_b32 v14, v0 offset:2816
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[16:19], v[48:51], v[4:7], v1, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[80:83], v2 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[16:19], v[52:55], a[4:7], v1, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[84:87], v2 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[16:19], v[56:59], a[8:11], v1, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v2 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[16:19], v[60:63], a[12:15], v1, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v2 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[16:19], v[64:67], a[16:19], v1, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v2 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[16:19], v[68:71], a[20:23], v1, v13 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v2 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[16:19], v[72:75], a[24:27], v1, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[104:107], v2 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[16:19], v[76:79], a[28:31], v1, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[16:19], v2 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[20:23], v[48:51], a[32:35], v1, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[108:111], v3 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[20:23], v[52:55], a[36:39], v1, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[112:115], v3 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[20:23], v[56:59], a[40:43], v1, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[116:119], v3 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[20:23], v[60:63], a[44:47], v1, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[120:123], v3 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[20:23], v[64:67], a[48:51], v1, v13 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[124:127], v3 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[20:23], v[68:71], a[52:55], v1, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[128:131], v3 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[20:23], v[72:75], a[56:59], v1, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[132:135], v3 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[20:23], v[76:79], a[60:63], v1, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v3 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[24:27], v[48:51], a[64:67], v8, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[24:27], v[52:55], a[68:71], v8, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[24:27], v[56:59], a[72:75], v8, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[24:27], v[60:63], a[76:79], v8, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[24:27], v[64:67], a[80:83], v8, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[24:27], v[68:71], a[84:87], v8, v13 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[24:27], v[72:75], a[88:91], v8, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[24:27], v[76:79], a[92:95], v8, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[28:31], v[48:51], a[96:99], v8, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[28:31], v[52:55], a[100:103], v8, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[28:31], v[56:59], a[104:107], v8, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[28:31], v[60:63], a[108:111], v8, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[28:31], v[64:67], a[112:115], v8, v13 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[28:31], v[68:71], a[116:119], v8, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[28:31], v[72:75], a[120:123], v8, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[28:31], v[76:79], a[124:127], v8, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[32:35], v[48:51], a[128:131], v9, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[32:35], v[52:55], a[132:135], v9, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[32:35], v[56:59], a[136:139], v9, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[32:35], v[60:63], a[140:143], v9, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], v[64:67], a[144:147], v9, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[32:35], v[68:71], a[148:151], v9, v13 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[32:35], v[72:75], a[152:155], v9, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[32:35], v[76:79], a[156:159], v9, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], v[48:51], a[160:163], v9, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[36:39], v[52:55], a[164:167], v9, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[36:39], v[56:59], a[168:171], v9, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[36:39], v[60:63], a[172:175], v9, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[36:39], v[64:67], a[176:179], v9, v13 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[36:39], v[68:71], a[180:183], v9, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[36:39], v[72:75], a[184:187], v9, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[36:39], v[76:79], a[188:191], v9, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[40:43], v[48:51], a[192:195], v10, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[40:43], v[52:55], a[196:199], v10, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[40:43], v[56:59], a[200:203], v10, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[40:43], v[60:63], a[204:207], v10, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[40:43], v[64:67], a[208:211], v10, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[40:43], v[68:71], a[212:215], v10, v13 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[40:43], v[72:75], a[216:219], v10, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[40:43], v[76:79], a[220:223], v10, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[44:47], v[48:51], a[224:227], v10, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[44:47], v[52:55], a[228:231], v10, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[44:47], v[56:59], a[232:235], v10, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[44:47], v[60:63], a[236:239], v10, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[44:47], v[64:67], a[240:243], v10, v13 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[44:47], v[68:71], a[244:247], v10, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[44:47], v[72:75], a[248:251], v10, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[44:47], v[76:79], a[252:255], v10, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[80:83], v[108:111], v[4:7], v1, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[80:83], v[112:115], a[4:7], v1, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[80:83], v[116:119], a[8:11], v1, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[80:83], v[120:123], a[12:15], v1, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[80:83], v[124:127], a[16:19], v1, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[80:83], v[128:131], a[20:23], v1, v13 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[80:83], v[132:135], a[24:27], v1, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[80:83], v[20:23], a[28:31], v1, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[84:87], v[108:111], a[32:35], v1, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[84:87], v[112:115], a[36:39], v1, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[84:87], v[116:119], a[40:43], v1, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[84:87], v[120:123], a[44:47], v1, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[84:87], v[124:127], a[48:51], v1, v13 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[84:87], v[128:131], a[52:55], v1, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[84:87], v[132:135], a[56:59], v1, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[84:87], v[20:23], a[60:63], v1, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[88:91], v[108:111], a[64:67], v8, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[88:91], v[112:115], a[68:71], v8, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[88:91], v[116:119], a[72:75], v8, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[88:91], v[120:123], a[76:79], v8, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[88:91], v[124:127], a[80:83], v8, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[88:91], v[128:131], a[84:87], v8, v13 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[88:91], v[132:135], a[88:91], v8, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[88:91], v[20:23], a[92:95], v8, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[92:95], v[108:111], a[96:99], v8, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[92:95], v[112:115], a[100:103], v8, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[92:95], v[116:119], a[104:107], v8, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[92:95], v[120:123], a[108:111], v8, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[92:95], v[124:127], a[112:115], v8, v13 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[92:95], v[128:131], a[116:119], v8, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[92:95], v[132:135], a[120:123], v8, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[92:95], v[20:23], a[124:127], v8, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[96:99], v[108:111], a[128:131], v9, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[96:99], v[112:115], a[132:135], v9, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[96:99], v[116:119], a[136:139], v9, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[96:99], v[120:123], a[140:143], v9, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[96:99], v[124:127], a[144:147], v9, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[96:99], v[128:131], a[148:151], v9, v13 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[96:99], v[132:135], a[152:155], v9, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[96:99], v[20:23], a[156:159], v9, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[100:103], v[108:111], a[160:163], v9, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[100:103], v[112:115], a[164:167], v9, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[100:103], v[116:119], a[168:171], v9, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[100:103], v[120:123], a[172:175], v9, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[100:103], v[124:127], a[176:179], v9, v13 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[100:103], v[128:131], a[180:183], v9, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[100:103], v[132:135], a[184:187], v9, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[100:103], v[20:23], a[188:191], v9, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[104:107], v[108:111], a[192:195], v10, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[104:107], v[112:115], a[196:199], v10, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[104:107], v[116:119], a[200:203], v10, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[104:107], v[120:123], a[204:207], v10, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[104:107], v[124:127], a[208:211], v10, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[104:107], v[128:131], a[212:215], v10, v13 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[104:107], v[132:135], a[216:219], v10, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[104:107], v[20:23], a[220:223], v10, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[16:19], v[108:111], a[224:227], v10, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[16:19], v[112:115], a[228:231], v10, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[16:19], v[116:119], a[232:235], v10, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[16:19], v[120:123], a[236:239], v10, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
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
		.amdhsa_private_segment_fixed_size 616
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
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 616
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
    .private_segment_fixed_size: 616
    .sgpr_count:     62
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
