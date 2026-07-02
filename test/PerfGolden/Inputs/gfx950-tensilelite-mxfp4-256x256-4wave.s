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
		s_add_i32 s15, s15, 0x22000
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
		v_accvgpr_write_b32 a0, 0
		v_accvgpr_write_b32 a1, 0
		v_accvgpr_write_b32 a2, 0
		v_accvgpr_write_b32 a3, 0
		v_readfirstlane_b32 s8, v0
		s_lshl_b32 s9, s13, 20
		v_lshrrev_b32_e32 v1, 6, v0
		v_lshlrev_b32_e32 v2, 16, v1
		v_add_u32_e32 v3, s9, v2
		v_and_b32_e32 v4, 63, v0
		v_lshrrev_b32_e32 v5, 2, v4
		v_lshlrev_b32_e32 v5, 12, v5
		v_lshrrev_b32_e32 v6, 3, v4
		v_and_b32_e32 v6, 3, v6
		v_and_b32_e32 v7, 3, v4
		v_xor_b32_e32 v6, v6, v7
		v_lshlrev_b32_e32 v6, 4, v6
		v_add3_u32 v3, v3, v5, v6
		s_add_i32 s10, s9, 0x40000
		v_add_u32_e32 v7, v2, v5
		v_add3_u32 v8, v6, v7, s10
		s_add_i32 s10, s9, 0x80000
		v_add3_u32 v9, v6, v7, s10
		s_add_i32 s10, s9, 0xc0000
		v_add3_u32 v7, v6, v7, s10
		s_add_i32 s10, s9, 64
		v_add_u32_e32 v10, v2, v5
		v_add3_u32 v11, v6, v10, s10
		s_add_i32 s10, s9, 0x40040
		v_add3_u32 v12, v6, v10, s10
		s_add_i32 s10, s9, 0x80040
		v_add3_u32 v10, v6, v10, s10
		s_add_i32 s10, s9, 0xc0040
		v_add_u32_e32 v13, v2, v5
		v_add3_u32 v14, v6, v13, s10
		s_lshl_b32 s10, s14, 20
		v_add3_u32 v15, v6, v13, s10
		s_add_i32 s11, s10, 0x40000
		v_add3_u32 v13, v6, v13, s11
		s_add_i32 s11, s10, 0x80000
		v_add3_u32 v16, v2, v5, v6
		v_add_u32_e32 v17, s11, v16
		s_add_i32 s11, s10, 0xc0000
		v_add_u32_e32 v18, s11, v16
		v_add3_u32 v16, v16, s10, 64
		s_add_i32 s11, s10, 0x40040
		v_add_u32_e32 v19, v2, v5
		v_add3_u32 v20, v6, v19, s11
		s_add_i32 s11, s10, 0x80040
		v_add3_u32 v21, v6, v19, s11
		s_add_i32 s11, s10, 0xc0040
		v_add3_u32 v19, v6, v19, s11
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
		s_mov_b32 m0, s28
		s_add_i32 s43, s28, 0xf000
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v9, s[20:23], 0 offen lds
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v11, s[20:23], 0 offen lds
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v15, s[0:3], 0 offen lds
		s_mov_b32 m0, s37
		s_nop 0
		buffer_load_dwordx4 v13, s[0:3], 0 offen lds
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v17, s[0:3], 0 offen lds
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v18, s[0:3], 0 offen lds
		s_mov_b32 m0, s40
		s_nop 0
		buffer_load_dwordx4 v16, s[0:3], 0 offen lds
		s_mov_b32 m0, s41
		s_nop 0
		buffer_load_dwordx4 v20, s[0:3], 0 offen lds
		s_mov_b32 m0, s42
		s_nop 0
		buffer_load_dwordx4 v21, s[0:3], 0 offen lds
		s_mov_b32 m0, s43
		s_nop 0
		buffer_load_dwordx4 v19, s[0:3], 0 offen lds
		s_lshl_b32 s44, s14, 16
		s_add_i32 s45, s9, s44
		v_lshrrev_b32_e32 v3, 7, v0
		v_lshlrev_b32_e32 v7, 10, v3
		v_lshlrev_b32_e32 v8, 4, v4
		v_add3_u32 v9, s45, v7, v8
		s_lshr_b32 s8, s8, 7
		s_lshl_b32 s46, s8, 10
		v_and_b32_e32 v1, 1, v1
		v_lshlrev_b32_e32 v10, 10, v1
		v_add3_u32 v11, s45, v8, v10
		s_and_b32 s8, s11, 1
		s_lshl_b32 s8, s8, 10
		s_add_i32 s11, s8, 0x800
		s_add_i32 m0, s46, 0x20000
		s_nop 0
		buffer_load_dwordx4 v9, s[4:7], 0 offen lds
		s_add_i32 m0, s8, 0x20800
		s_nop 0
		buffer_load_dwordx4 v11, s[24:27], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v3, 13, v3
		v_and_b32_e32 v9, 15, v0
		v_lshlrev_b32_e32 v11, 6, v9
		v_lshrrev_b32_e32 v12, 4, v4
		v_lshrrev_b32_e32 v9, 1, v9
		v_and_b32_e32 v9, 3, v9
		v_xor_b32_e32 v9, v12, v9
		v_lshlrev_b32_e32 v9, 4, v9
		v_add3_u32 v12, v3, v11, v9
		ds_read_b128 v[16:19], v12
		ds_read_b128 v[20:23], v12 offset:1024
		ds_read_b128 v[24:27], v12 offset:2048
		ds_read_b128 v[28:31], v12 offset:3072
		ds_read_b128 v[32:35], v12 offset:4096
		ds_read_b128 v[36:39], v12 offset:5120
		ds_read_b128 v[40:43], v12 offset:6144
		ds_read_b128 v[44:47], v12 offset:7168
		v_lshlrev_b32_e32 v1, 13, v1
		v_add3_u32 v12, v11, v1, v9
		ds_read_b128 v[48:51], v12 offset:32768
		ds_read_b128 v[52:55], v12 offset:33792
		ds_read_b128 v[56:59], v12 offset:34816
		ds_read_b128 v[60:63], v12 offset:35840
		ds_read_b128 v[64:67], v12 offset:36864
		ds_read_b128 v[68:71], v12 offset:37888
		ds_read_b128 v[72:75], v12 offset:38912
		ds_read_b128 v[76:79], v12 offset:39936
		v_add_u32_e32 v12, 0x20000, v7
		v_lshlrev_b32_e32 v4, 2, v4
		v_add_u32_e32 v12, v12, v4
		ds_read_b32 v13, v12
		ds_read_b32 v14, v12 offset:256
		ds_read_b32 v15, v12 offset:512
		ds_read_b32 v80, v12 offset:768
		v_add_u32_e32 v4, 0x20000, v4
		v_add_u32_e32 v4, v4, v10
		ds_read_b32 v12, v4 offset:2048
		ds_read_b32 v81, v4 offset:2304
		ds_read_b32 v82, v4 offset:2560
		ds_read_b32 v83, v4 offset:2816
		s_waitcnt lgkmcnt(0)
		s_add_i32 s45, s9, 0x80
		v_add_u32_e32 v4, s45, v2
		v_add3_u32 v4, v4, v5, v6
		s_add_i32 s45, s9, 0x40080
		v_add_u32_e32 v84, v2, v5
		v_add3_u32 v85, v6, v84, s45
		s_add_i32 s45, s9, 0x80080
		v_add3_u32 v86, v6, v84, s45
		s_add_i32 s45, s9, 0xc0080
		v_add3_u32 v84, v6, v84, s45
		s_add_i32 s45, s9, 0xc0
		v_add_u32_e32 v87, v2, v5
		v_add3_u32 v88, v6, v87, s45
		s_add_i32 s45, s9, 0x400c0
		v_add3_u32 v89, v6, v87, s45
		s_add_i32 s45, s9, 0x800c0
		v_add3_u32 v87, v6, v87, s45
		s_add_i32 s45, s9, 0xc00c0
		v_add_u32_e32 v90, v2, v5
		v_add3_u32 v91, v6, v90, s45
		s_add_i32 s45, s10, 0x80
		v_add3_u32 v92, v6, v90, s45
		s_add_i32 s45, s10, 0x40080
		v_add3_u32 v90, v6, v90, s45
		s_add_i32 s45, s10, 0x80080
		v_add_u32_e32 v93, v2, v5
		v_add3_u32 v94, v6, v93, s45
		s_add_i32 s45, s10, 0xc0080
		v_add3_u32 v95, v6, v93, s45
		s_add_i32 s45, s10, 0xc0
		v_add3_u32 v93, v6, v93, s45
		s_add_i32 s45, s10, 0x400c0
		v_add_u32_e32 v2, v2, v5
		v_add3_u32 v5, v6, v2, s45
		s_add_i32 s45, s10, 0x800c0
		v_add3_u32 v96, v6, v2, s45
		s_add_i32 s10, s10, 0xc00c0
		v_add3_u32 v2, v6, v2, s10
		s_add_i32 s10, s28, 0x10000
		s_add_i32 s45, s28, 0x11000
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
		s_mov_b32 m0, s10
		s_add_i32 s60, s28, 0x1f000
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		s_mov_b32 m0, s45
		s_nop 0
		buffer_load_dwordx4 v85, s[20:23], 0 offen lds
		s_mov_b32 m0, s47
		s_nop 0
		buffer_load_dwordx4 v86, s[20:23], 0 offen lds
		s_mov_b32 m0, s48
		s_nop 0
		buffer_load_dwordx4 v84, s[20:23], 0 offen lds
		s_mov_b32 m0, s49
		s_nop 0
		buffer_load_dwordx4 v88, s[20:23], 0 offen lds
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v89, s[20:23], 0 offen lds
		s_mov_b32 m0, s51
		s_nop 0
		buffer_load_dwordx4 v87, s[20:23], 0 offen lds
		s_mov_b32 m0, s52
		s_nop 0
		buffer_load_dwordx4 v91, s[20:23], 0 offen lds
		s_mov_b32 m0, s53
		s_nop 0
		buffer_load_dwordx4 v92, s[0:3], 0 offen lds
		s_mov_b32 m0, s54
		s_nop 0
		buffer_load_dwordx4 v90, s[0:3], 0 offen lds
		s_mov_b32 m0, s55
		s_nop 0
		buffer_load_dwordx4 v94, s[0:3], 0 offen lds
		s_mov_b32 m0, s56
		s_nop 0
		buffer_load_dwordx4 v95, s[0:3], 0 offen lds
		s_mov_b32 m0, s57
		s_nop 0
		buffer_load_dwordx4 v93, s[0:3], 0 offen lds
		s_mov_b32 m0, s58
		s_nop 0
		buffer_load_dwordx4 v5, s[0:3], 0 offen lds
		s_mov_b32 m0, s59
		s_nop 0
		buffer_load_dwordx4 v96, s[0:3], 0 offen lds
		s_mov_b32 m0, s60
		s_nop 0
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_add_i32 s9, s9, 0x800
		s_add_i32 s9, s9, s44
		v_add3_u32 v2, s9, v7, v8
		s_add_i32 s44, s46, 0x1000
		v_add3_u32 v4, s9, v8, v10
		s_add_i32 s9, s8, 0x1800
		s_add_i32 m0, s46, 0x21000
		s_nop 0
		buffer_load_dwordx4 v2, s[4:7], 0 offen lds
		s_add_i32 m0, s8, 0x21800
		s_nop 0
		buffer_load_dwordx4 v4, s[24:27], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s8, s12, 1
		s_mov_b32 s61, 2
		v_mov_b32_e32 v4, s13
		v_mov_b32_e32 v5, 0
		s_mov_b32 s62, 0x100000
		s_mov_b32 s63, 0
		v_mov_b32_e32 v6, s62
		v_mov_b32_e32 v7, s63
		v_mul_lo_u32 v84, v6, v4
		v_mul_hi_u32 v85, v6, v4
		v_mul_lo_u32 v2, v6, v5
		v_add_u32_e32 v85, v85, v2
		v_mul_lo_u32 v2, v7, v4
		v_add_u32_e32 v85, v85, v2
		s_mov_b32 s62, 1
		s_mov_b32 s63, 0
		v_mov_b32_e32 v86, v0
		v_mov_b32_e32 v87, 0
		v_mov_b32_e32 v88, s62
		v_mov_b32_e32 v89, s63
		v_mul_lo_u32 v90, v88, v86
		v_mul_hi_u32 v91, v88, v86
		v_mul_lo_u32 v2, v88, v87
		v_add_u32_e32 v91, v91, v2
		v_mul_lo_u32 v2, v89, v86
		v_add_u32_e32 v91, v91, v2
		v_lshrrev_b64 v[92:93], 6, v[90:91]
		s_mov_b32 s62, 0x10000
		s_mov_b32 s63, 0
		v_mov_b32_e32 v94, s62
		v_mov_b32_e32 v95, s63
		v_mul_lo_u32 v96, v94, v92
		v_mul_hi_u32 v97, v94, v92
		v_mul_lo_u32 v2, v94, v93
		v_add_u32_e32 v97, v97, v2
		v_mul_lo_u32 v2, v95, v92
		v_add_u32_e32 v97, v97, v2
		v_add_co_u32_e64 v98, vcc, v84, v96
		v_addc_co_u32_e64 v99, vcc, v85, v97, vcc
		v_mov_b32_e32 v2, 63
		v_and_b32_e32 v100, v86, v2
		v_and_b32_e32 v101, v5, v5
		v_mul_lo_u32 v86, v88, v100
		v_mul_hi_u32 v87, v88, v100
		v_mul_lo_u32 v2, v88, v101
		v_add_u32_e32 v87, v87, v2
		v_mul_lo_u32 v2, v89, v100
		v_add_u32_e32 v87, v87, v2
		v_lshrrev_b64 v[88:89], 2, v[86:87]
		s_mov_b32 s62, 0x1000
		s_mov_b32 s63, 0
		v_mov_b32_e32 v102, s62
		v_mov_b32_e32 v103, s63
		v_mul_lo_u32 v104, v102, v88
		v_mul_hi_u32 v105, v102, v88
		v_mul_lo_u32 v2, v102, v89
		v_add_u32_e32 v105, v105, v2
		v_mul_lo_u32 v2, v103, v88
		v_add_u32_e32 v105, v105, v2
		v_add_co_u32_e64 v88, vcc, v98, v104
		v_addc_co_u32_e64 v89, vcc, v99, v105, vcc
		v_lshrrev_b64 v[98:99], 3, v[86:87]
		v_mov_b32_e32 v2, 3
		v_and_b32_e32 v86, v98, v2
		v_and_b32_e32 v87, v99, v5
		v_and_b32_e32 v98, v100, v2
		v_and_b32_e32 v99, v101, v5
		v_xor_b32_e32 v86, v86, v98
		v_xor_b32_e32 v87, v87, v99
		s_mov_b32 s62, 16
		s_mov_b32 s63, 0
		v_mov_b32_e32 v98, s62
		v_mov_b32_e32 v99, s63
		v_mul_lo_u32 v102, v98, v86
		v_mul_hi_u32 v103, v98, v86
		v_mul_lo_u32 v2, v98, v87
		v_add_u32_e32 v103, v103, v2
		v_mul_lo_u32 v2, v99, v86
		v_add_u32_e32 v103, v103, v2
		v_add_co_u32_e64 v86, vcc, v88, v102
		v_addc_co_u32_e64 v87, vcc, v89, v103, vcc
		s_mov_b32 s62, 0x80
		s_mov_b32 s63, 0
		v_mov_b32_e32 v88, s62
		v_mov_b32_e32 v89, s63
		v_mov_b32_e32 v2, 0x40000
		v_add_co_u32_e64 v106, vcc, v84, v2
		v_addc_co_u32_e64 v107, vcc, v85, 0, vcc
		v_add_co_u32_e64 v108, vcc, v106, v96
		v_addc_co_u32_e64 v109, vcc, v107, v97, vcc
		v_add_co_u32_e64 v106, vcc, v108, v104
		v_addc_co_u32_e64 v107, vcc, v109, v105, vcc
		v_add_co_u32_e64 v108, vcc, v106, v102
		v_addc_co_u32_e64 v109, vcc, v107, v103, vcc
		v_mov_b32_e32 v4, 0x80000
		v_add_co_u32_e64 v106, vcc, v84, v4
		v_addc_co_u32_e64 v107, vcc, v85, 0, vcc
		v_add_co_u32_e64 v110, vcc, v106, v96
		v_addc_co_u32_e64 v111, vcc, v107, v97, vcc
		v_add_co_u32_e64 v106, vcc, v110, v104
		v_addc_co_u32_e64 v107, vcc, v111, v105, vcc
		v_add_co_u32_e64 v110, vcc, v106, v102
		v_addc_co_u32_e64 v111, vcc, v107, v103, vcc
		v_mov_b32_e32 v8, 0xc0000
		v_add_co_u32_e64 v106, vcc, v84, v8
		v_addc_co_u32_e64 v107, vcc, v85, 0, vcc
		v_add_co_u32_e64 v112, vcc, v106, v96
		v_addc_co_u32_e64 v113, vcc, v107, v97, vcc
		v_add_co_u32_e64 v106, vcc, v112, v104
		v_addc_co_u32_e64 v107, vcc, v113, v105, vcc
		v_add_co_u32_e64 v112, vcc, v106, v102
		v_addc_co_u32_e64 v113, vcc, v107, v103, vcc
		v_mov_b32_e32 v10, 64
		v_add_co_u32_e64 v106, vcc, v84, v10
		v_addc_co_u32_e64 v107, vcc, v85, 0, vcc
		v_add_co_u32_e64 v114, vcc, v106, v96
		v_addc_co_u32_e64 v115, vcc, v107, v97, vcc
		v_add_co_u32_e64 v106, vcc, v114, v104
		v_addc_co_u32_e64 v107, vcc, v115, v105, vcc
		v_add_co_u32_e64 v114, vcc, v106, v102
		v_addc_co_u32_e64 v115, vcc, v107, v103, vcc
		v_mov_b32_e32 v106, 0x40040
		v_add_co_u32_e64 v116, vcc, v84, v106
		v_addc_co_u32_e64 v117, vcc, v85, 0, vcc
		v_add_co_u32_e64 v118, vcc, v116, v96
		v_addc_co_u32_e64 v119, vcc, v117, v97, vcc
		v_add_co_u32_e64 v116, vcc, v118, v104
		v_addc_co_u32_e64 v117, vcc, v119, v105, vcc
		v_add_co_u32_e64 v118, vcc, v116, v102
		v_addc_co_u32_e64 v119, vcc, v117, v103, vcc
		v_mov_b32_e32 v107, 0x80040
		v_add_co_u32_e64 v116, vcc, v84, v107
		v_addc_co_u32_e64 v117, vcc, v85, 0, vcc
		v_add_co_u32_e64 v120, vcc, v116, v96
		v_addc_co_u32_e64 v121, vcc, v117, v97, vcc
		v_add_co_u32_e64 v116, vcc, v120, v104
		v_addc_co_u32_e64 v117, vcc, v121, v105, vcc
		v_add_co_u32_e64 v120, vcc, v116, v102
		v_addc_co_u32_e64 v121, vcc, v117, v103, vcc
		v_mov_b32_e32 v116, 0xc0040
		v_add_co_u32_e64 v122, vcc, v84, v116
		v_addc_co_u32_e64 v123, vcc, v85, 0, vcc
		v_add_co_u32_e64 v124, vcc, v122, v96
		v_addc_co_u32_e64 v125, vcc, v123, v97, vcc
		v_add_co_u32_e64 v122, vcc, v124, v104
		v_addc_co_u32_e64 v123, vcc, v125, v105, vcc
		v_add_co_u32_e64 v124, vcc, v122, v102
		v_addc_co_u32_e64 v125, vcc, v123, v103, vcc
		v_mov_b32_e32 v122, s14
		v_mov_b32_e32 v123, 0
		v_mul_lo_u32 v126, v6, v122
		v_mul_hi_u32 v127, v6, v122
		v_mul_lo_u32 v117, v6, v123
		v_add_u32_e32 v127, v127, v117
		v_mul_lo_u32 v117, v7, v122
		v_add_u32_e32 v127, v127, v117
		v_add_co_u32_e64 v6, vcc, v126, v96
		v_addc_co_u32_e64 v7, vcc, v127, v97, vcc
		v_add_co_u32_e64 v128, vcc, v6, v104
		v_addc_co_u32_e64 v129, vcc, v7, v105, vcc
		v_add_co_u32_e64 v6, vcc, v128, v102
		v_addc_co_u32_e64 v7, vcc, v129, v103, vcc
		v_add_co_u32_e64 v128, vcc, v126, v2
		v_addc_co_u32_e64 v129, vcc, v127, 0, vcc
		v_add_co_u32_e64 v130, vcc, v128, v96
		v_addc_co_u32_e64 v131, vcc, v129, v97, vcc
		v_add_co_u32_e64 v128, vcc, v130, v104
		v_addc_co_u32_e64 v129, vcc, v131, v105, vcc
		v_add_co_u32_e64 v130, vcc, v128, v102
		v_addc_co_u32_e64 v131, vcc, v129, v103, vcc
		v_add_co_u32_e64 v128, vcc, v126, v4
		v_addc_co_u32_e64 v129, vcc, v127, 0, vcc
		v_add_co_u32_e64 v132, vcc, v128, v96
		v_addc_co_u32_e64 v133, vcc, v129, v97, vcc
		v_add_co_u32_e64 v128, vcc, v132, v104
		v_addc_co_u32_e64 v129, vcc, v133, v105, vcc
		v_add_co_u32_e64 v132, vcc, v128, v102
		v_addc_co_u32_e64 v133, vcc, v129, v103, vcc
		v_add_co_u32_e64 v128, vcc, v126, v8
		v_addc_co_u32_e64 v129, vcc, v127, 0, vcc
		v_add_co_u32_e64 v134, vcc, v128, v96
		v_addc_co_u32_e64 v135, vcc, v129, v97, vcc
		v_add_co_u32_e64 v128, vcc, v134, v104
		v_addc_co_u32_e64 v129, vcc, v135, v105, vcc
		v_add_co_u32_e64 v134, vcc, v128, v102
		v_addc_co_u32_e64 v135, vcc, v129, v103, vcc
		v_add_co_u32_e64 v128, vcc, v126, v10
		v_addc_co_u32_e64 v129, vcc, v127, 0, vcc
		v_add_co_u32_e64 v136, vcc, v128, v96
		v_addc_co_u32_e64 v137, vcc, v129, v97, vcc
		v_add_co_u32_e64 v128, vcc, v136, v104
		v_addc_co_u32_e64 v129, vcc, v137, v105, vcc
		v_add_co_u32_e64 v136, vcc, v128, v102
		v_addc_co_u32_e64 v137, vcc, v129, v103, vcc
		v_add_co_u32_e64 v128, vcc, v126, v106
		v_addc_co_u32_e64 v129, vcc, v127, 0, vcc
		v_add_co_u32_e64 v138, vcc, v128, v96
		v_addc_co_u32_e64 v139, vcc, v129, v97, vcc
		v_add_co_u32_e64 v128, vcc, v138, v104
		v_addc_co_u32_e64 v129, vcc, v139, v105, vcc
		v_add_co_u32_e64 v138, vcc, v128, v102
		v_addc_co_u32_e64 v139, vcc, v129, v103, vcc
		v_add_co_u32_e64 v128, vcc, v126, v107
		v_addc_co_u32_e64 v129, vcc, v127, 0, vcc
		v_add_co_u32_e64 v106, vcc, v128, v96
		v_addc_co_u32_e64 v107, vcc, v129, v97, vcc
		v_add_co_u32_e64 v128, vcc, v106, v104
		v_addc_co_u32_e64 v129, vcc, v107, v105, vcc
		v_add_co_u32_e64 v106, vcc, v128, v102
		v_addc_co_u32_e64 v107, vcc, v129, v103, vcc
		v_add_co_u32_e64 v128, vcc, v126, v116
		v_addc_co_u32_e64 v129, vcc, v127, 0, vcc
		v_add_co_u32_e64 v116, vcc, v128, v96
		v_addc_co_u32_e64 v117, vcc, v129, v97, vcc
		v_add_co_u32_e64 v128, vcc, v116, v104
		v_addc_co_u32_e64 v129, vcc, v117, v105, vcc
		v_add_co_u32_e64 v116, vcc, v128, v102
		v_addc_co_u32_e64 v117, vcc, v129, v103, vcc
		v_mul_lo_u32 v128, v94, v122
		v_mul_hi_u32 v129, v94, v122
		v_mul_lo_u32 v2, v94, v123
		v_add_u32_e32 v129, v129, v2
		v_mul_lo_u32 v2, v95, v122
		v_add_u32_e32 v129, v129, v2
		v_add_co_u32_e64 v94, vcc, v84, v128
		v_addc_co_u32_e64 v95, vcc, v85, v129, vcc
		v_lshrrev_b64 v[122:123], 7, v[90:91]
		s_mov_b32 s62, 0x400
		s_mov_b32 s63, 0
		v_mov_b32_e32 v90, s62
		v_mov_b32_e32 v91, s63
		v_mul_lo_u32 v140, v90, v122
		v_mul_hi_u32 v141, v90, v122
		v_mul_lo_u32 v2, v90, v123
		v_add_u32_e32 v141, v141, v2
		v_mul_lo_u32 v2, v91, v122
		v_add_u32_e32 v141, v141, v2
		v_add_co_u32_e64 v122, vcc, v94, v140
		v_addc_co_u32_e64 v123, vcc, v95, v141, vcc
		v_mul_lo_u32 v142, v98, v100
		v_mul_hi_u32 v143, v98, v100
		v_mul_lo_u32 v2, v98, v101
		v_add_u32_e32 v143, v143, v2
		v_mul_lo_u32 v2, v99, v100
		v_add_u32_e32 v143, v143, v2
		v_add_co_u32_e64 v98, vcc, v122, v142
		v_addc_co_u32_e64 v99, vcc, v123, v143, vcc
		s_mov_b32 s62, 0x800
		s_mov_b32 s63, 0
		v_mov_b32_e32 v100, s62
		v_mov_b32_e32 v101, s63
		v_add_co_u32_e64 v122, vcc, v94, v142
		v_addc_co_u32_e64 v123, vcc, v95, v143, vcc
		v_mov_b32_e32 v2, 1
		v_and_b32_e32 v94, v92, v2
		v_and_b32_e32 v95, v93, v5
		v_mul_lo_u32 v4, v90, v94
		v_mul_hi_u32 v5, v90, v94
		v_mul_lo_u32 v2, v90, v95
		v_add_u32_e32 v5, v5, v2
		v_mul_lo_u32 v2, v91, v94
		v_add_u32_e32 v5, v5, v2
		v_add_co_u32_e64 v90, vcc, v122, v4
		v_addc_co_u32_e64 v91, vcc, v123, v5, vcc
		v_mov_b32_e32 v2, 0x80
		v_add_co_u32_e64 v92, vcc, v84, v2
		v_addc_co_u32_e64 v93, vcc, v85, 0, vcc
		v_add_co_u32_e64 v94, vcc, v92, v96
		v_addc_co_u32_e64 v95, vcc, v93, v97, vcc
		v_add_co_u32_e64 v92, vcc, v94, v104
		v_addc_co_u32_e64 v93, vcc, v95, v105, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v94, vcc, v92, v102
		v_addc_co_u32_e64 v95, vcc, v93, v103, vcc
		ds_write_addtid_b32 v94 offset:2048
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v95 offset:3072
		v_mov_b32_e32 v8, 0x40080
		v_add_co_u32_e64 v92, vcc, v84, v8
		v_addc_co_u32_e64 v93, vcc, v85, 0, vcc
		v_add_co_u32_e64 v94, vcc, v92, v96
		v_addc_co_u32_e64 v95, vcc, v93, v97, vcc
		v_add_co_u32_e64 v92, vcc, v94, v104
		v_addc_co_u32_e64 v93, vcc, v95, v105, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v94, vcc, v92, v102
		v_addc_co_u32_e64 v95, vcc, v93, v103, vcc
		ds_write_addtid_b32 v94 offset:4096
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v95 offset:5120
		v_mov_b32_e32 v10, 0x80080
		v_add_co_u32_e64 v92, vcc, v84, v10
		v_addc_co_u32_e64 v93, vcc, v85, 0, vcc
		v_add_co_u32_e64 v94, vcc, v92, v96
		v_addc_co_u32_e64 v95, vcc, v93, v97, vcc
		v_add_co_u32_e64 v92, vcc, v94, v104
		v_addc_co_u32_e64 v93, vcc, v95, v105, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v94, vcc, v92, v102
		v_addc_co_u32_e64 v95, vcc, v93, v103, vcc
		ds_write_addtid_b32 v94 offset:6144
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v95 offset:7168
		v_mov_b32_e32 v92, 0xc0080
		v_add_co_u32_e64 v94, vcc, v84, v92
		v_addc_co_u32_e64 v95, vcc, v85, 0, vcc
		v_add_co_u32_e64 v122, vcc, v94, v96
		v_addc_co_u32_e64 v123, vcc, v95, v97, vcc
		v_add_co_u32_e64 v94, vcc, v122, v104
		v_addc_co_u32_e64 v95, vcc, v123, v105, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v122, vcc, v94, v102
		v_addc_co_u32_e64 v123, vcc, v95, v103, vcc
		ds_write_addtid_b32 v122 offset:8192
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v123 offset:9216
		v_mov_b32_e32 v93, 0xc0
		v_add_co_u32_e64 v94, vcc, v84, v93
		v_addc_co_u32_e64 v95, vcc, v85, 0, vcc
		v_add_co_u32_e64 v122, vcc, v94, v96
		v_addc_co_u32_e64 v123, vcc, v95, v97, vcc
		v_add_co_u32_e64 v94, vcc, v122, v104
		v_addc_co_u32_e64 v95, vcc, v123, v105, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v122, vcc, v94, v102
		v_addc_co_u32_e64 v123, vcc, v95, v103, vcc
		ds_write_addtid_b32 v122 offset:10240
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v123 offset:11264
		v_mov_b32_e32 v94, 0x400c0
		v_add_co_u32_e64 v122, vcc, v84, v94
		v_addc_co_u32_e64 v123, vcc, v85, 0, vcc
		v_add_co_u32_e64 v144, vcc, v122, v96
		v_addc_co_u32_e64 v145, vcc, v123, v97, vcc
		v_add_co_u32_e64 v122, vcc, v144, v104
		v_addc_co_u32_e64 v123, vcc, v145, v105, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v144, vcc, v122, v102
		v_addc_co_u32_e64 v145, vcc, v123, v103, vcc
		ds_write_addtid_b32 v144 offset:12288
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v145 offset:13312
		v_mov_b32_e32 v95, 0x800c0
		v_add_co_u32_e64 v122, vcc, v84, v95
		v_addc_co_u32_e64 v123, vcc, v85, 0, vcc
		v_add_co_u32_e64 v144, vcc, v122, v96
		v_addc_co_u32_e64 v145, vcc, v123, v97, vcc
		v_add_co_u32_e64 v122, vcc, v144, v104
		v_addc_co_u32_e64 v123, vcc, v145, v105, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v144, vcc, v122, v102
		v_addc_co_u32_e64 v145, vcc, v123, v103, vcc
		ds_write_addtid_b32 v144 offset:14336
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v145 offset:15360
		v_mov_b32_e32 v122, 0xc00c0
		v_add_co_u32_e64 v144, vcc, v84, v122
		v_addc_co_u32_e64 v145, vcc, v85, 0, vcc
		v_add_co_u32_e64 v146, vcc, v144, v96
		v_addc_co_u32_e64 v147, vcc, v145, v97, vcc
		v_add_co_u32_e64 v144, vcc, v146, v104
		v_addc_co_u32_e64 v145, vcc, v147, v105, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v146, vcc, v144, v102
		v_addc_co_u32_e64 v147, vcc, v145, v103, vcc
		ds_write_addtid_b32 v146 offset:16384
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v147 offset:17408
		v_add_co_u32_e64 v144, vcc, v126, v2
		v_addc_co_u32_e64 v145, vcc, v127, 0, vcc
		v_add_co_u32_e64 v146, vcc, v144, v96
		v_addc_co_u32_e64 v147, vcc, v145, v97, vcc
		v_add_co_u32_e64 v144, vcc, v146, v104
		v_addc_co_u32_e64 v145, vcc, v147, v105, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v146, vcc, v144, v102
		v_addc_co_u32_e64 v147, vcc, v145, v103, vcc
		ds_write_addtid_b32 v146 offset:18432
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v147 offset:19456
		v_add_co_u32_e64 v144, vcc, v126, v8
		v_addc_co_u32_e64 v145, vcc, v127, 0, vcc
		v_add_co_u32_e64 v146, vcc, v144, v96
		v_addc_co_u32_e64 v147, vcc, v145, v97, vcc
		v_add_co_u32_e64 v144, vcc, v146, v104
		v_addc_co_u32_e64 v145, vcc, v147, v105, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v146, vcc, v144, v102
		v_addc_co_u32_e64 v147, vcc, v145, v103, vcc
		ds_write_addtid_b32 v146 offset:20480
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v147 offset:21504
		v_add_co_u32_e64 v144, vcc, v126, v10
		v_addc_co_u32_e64 v145, vcc, v127, 0, vcc
		v_add_co_u32_e64 v146, vcc, v144, v96
		v_addc_co_u32_e64 v147, vcc, v145, v97, vcc
		v_add_co_u32_e64 v144, vcc, v146, v104
		v_addc_co_u32_e64 v145, vcc, v147, v105, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v146, vcc, v144, v102
		v_addc_co_u32_e64 v147, vcc, v145, v103, vcc
		ds_write_addtid_b32 v146 offset:22528
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v147 offset:23552
		v_add_co_u32_e64 v144, vcc, v126, v92
		v_addc_co_u32_e64 v145, vcc, v127, 0, vcc
		v_add_co_u32_e64 v146, vcc, v144, v96
		v_addc_co_u32_e64 v147, vcc, v145, v97, vcc
		v_add_co_u32_e64 v144, vcc, v146, v104
		v_addc_co_u32_e64 v145, vcc, v147, v105, vcc
		v_add_co_u32_e64 v146, vcc, v144, v102
		v_addc_co_u32_e64 v147, vcc, v145, v103, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v146, s62
		scratch_store_dword off, v147, s62 offset:4
		v_add_co_u32_e64 v144, vcc, v126, v93
		v_addc_co_u32_e64 v145, vcc, v127, 0, vcc
		v_add_co_u32_e64 v92, vcc, v144, v96
		v_addc_co_u32_e64 v93, vcc, v145, v97, vcc
		v_add_co_u32_e64 v144, vcc, v92, v104
		v_addc_co_u32_e64 v145, vcc, v93, v105, vcc
		v_add_co_u32_e64 v92, vcc, v144, v102
		v_addc_co_u32_e64 v93, vcc, v145, v103, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v92, s62 offset:8
		scratch_store_dword off, v93, s62 offset:12
		v_add_co_u32_e64 v92, vcc, v126, v94
		v_addc_co_u32_e64 v93, vcc, v127, 0, vcc
		v_add_co_u32_e64 v144, vcc, v92, v96
		v_addc_co_u32_e64 v145, vcc, v93, v97, vcc
		v_add_co_u32_e64 v92, vcc, v144, v104
		v_addc_co_u32_e64 v93, vcc, v145, v105, vcc
		v_add_co_u32_e64 v144, vcc, v92, v102
		v_addc_co_u32_e64 v145, vcc, v93, v103, vcc
		s_mov_b32 s62, 0
		scratch_store_dword off, v144, s62 offset:16
		scratch_store_dword off, v145, s62 offset:20
		v_add_co_u32_e64 v92, vcc, v126, v95
		v_addc_co_u32_e64 v93, vcc, v127, 0, vcc
		v_add_co_u32_e64 v94, vcc, v92, v96
		v_addc_co_u32_e64 v95, vcc, v93, v97, vcc
		v_add_co_u32_e64 v92, vcc, v94, v104
		v_addc_co_u32_e64 v93, vcc, v95, v105, vcc
		v_add_co_u32_e64 v94, vcc, v92, v102
		v_addc_co_u32_e64 v95, vcc, v93, v103, vcc
		v_add_co_u32_e64 v92, vcc, v126, v122
		v_addc_co_u32_e64 v93, vcc, v127, 0, vcc
		v_add_co_u32_e64 v122, vcc, v92, v96
		v_addc_co_u32_e64 v123, vcc, v93, v97, vcc
		v_add_co_u32_e64 v92, vcc, v122, v104
		v_addc_co_u32_e64 v93, vcc, v123, v105, vcc
		v_add_co_u32_e64 v96, vcc, v92, v102
		v_addc_co_u32_e64 v97, vcc, v93, v103, vcc
		v_mov_b32_e32 v2, 0x800
		v_add_co_u32_e64 v92, vcc, v84, v2
		v_addc_co_u32_e64 v93, vcc, v85, 0, vcc
		v_add_co_u32_e64 v84, vcc, v92, v128
		v_addc_co_u32_e64 v85, vcc, v93, v129, vcc
		v_add_co_u32_e64 v92, vcc, v84, v140
		v_addc_co_u32_e64 v93, vcc, v85, v141, vcc
		v_add_co_u32_e64 v102, vcc, v92, v142
		v_addc_co_u32_e64 v103, vcc, v93, v143, vcc
		v_add_co_u32_e64 v92, vcc, v84, v142
		v_addc_co_u32_e64 v93, vcc, v85, v143, vcc
		v_add_co_u32_e64 v84, vcc, v92, v4
		v_addc_co_u32_e64 v85, vcc, v93, v5, vcc
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a4, 0
		v_accvgpr_write_b32 a5, 0
		v_accvgpr_write_b32 a6, 0
		v_accvgpr_write_b32 a7, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a8, 0
		v_accvgpr_write_b32 a9, 0
		v_accvgpr_write_b32 a10, 0
		v_accvgpr_write_b32 a11, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a12, 0
		v_accvgpr_write_b32 a13, 0
		v_accvgpr_write_b32 a14, 0
		v_accvgpr_write_b32 a15, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a16, 0
		v_accvgpr_write_b32 a17, 0
		v_accvgpr_write_b32 a18, 0
		v_accvgpr_write_b32 a19, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a20, 0
		v_accvgpr_write_b32 a21, 0
		v_accvgpr_write_b32 a22, 0
		v_accvgpr_write_b32 a23, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a24, 0
		v_accvgpr_write_b32 a25, 0
		v_accvgpr_write_b32 a26, 0
		v_accvgpr_write_b32 a27, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a28, 0
		v_accvgpr_write_b32 a29, 0
		v_accvgpr_write_b32 a30, 0
		v_accvgpr_write_b32 a31, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a32, 0
		v_accvgpr_write_b32 a33, 0
		v_accvgpr_write_b32 a34, 0
		v_accvgpr_write_b32 a35, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a36, 0
		v_accvgpr_write_b32 a37, 0
		v_accvgpr_write_b32 a38, 0
		v_accvgpr_write_b32 a39, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a40, 0
		v_accvgpr_write_b32 a41, 0
		v_accvgpr_write_b32 a42, 0
		v_accvgpr_write_b32 a43, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a44, 0
		v_accvgpr_write_b32 a45, 0
		v_accvgpr_write_b32 a46, 0
		v_accvgpr_write_b32 a47, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a48, 0
		v_accvgpr_write_b32 a49, 0
		v_accvgpr_write_b32 a50, 0
		v_accvgpr_write_b32 a51, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a52, 0
		v_accvgpr_write_b32 a53, 0
		v_accvgpr_write_b32 a54, 0
		v_accvgpr_write_b32 a55, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a56, 0
		v_accvgpr_write_b32 a57, 0
		v_accvgpr_write_b32 a58, 0
		v_accvgpr_write_b32 a59, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a60, 0
		v_accvgpr_write_b32 a61, 0
		v_accvgpr_write_b32 a62, 0
		v_accvgpr_write_b32 a63, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a64, 0
		v_accvgpr_write_b32 a65, 0
		v_accvgpr_write_b32 a66, 0
		v_accvgpr_write_b32 a67, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a68, 0
		v_accvgpr_write_b32 a69, 0
		v_accvgpr_write_b32 a70, 0
		v_accvgpr_write_b32 a71, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a72, 0
		v_accvgpr_write_b32 a73, 0
		v_accvgpr_write_b32 a74, 0
		v_accvgpr_write_b32 a75, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a76, 0
		v_accvgpr_write_b32 a77, 0
		v_accvgpr_write_b32 a78, 0
		v_accvgpr_write_b32 a79, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a80, 0
		v_accvgpr_write_b32 a81, 0
		v_accvgpr_write_b32 a82, 0
		v_accvgpr_write_b32 a83, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a84, 0
		v_accvgpr_write_b32 a85, 0
		v_accvgpr_write_b32 a86, 0
		v_accvgpr_write_b32 a87, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a88, 0
		v_accvgpr_write_b32 a89, 0
		v_accvgpr_write_b32 a90, 0
		v_accvgpr_write_b32 a91, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a92, 0
		v_accvgpr_write_b32 a93, 0
		v_accvgpr_write_b32 a94, 0
		v_accvgpr_write_b32 a95, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a96, 0
		v_accvgpr_write_b32 a97, 0
		v_accvgpr_write_b32 a98, 0
		v_accvgpr_write_b32 a99, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a100, 0
		v_accvgpr_write_b32 a101, 0
		v_accvgpr_write_b32 a102, 0
		v_accvgpr_write_b32 a103, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a104, 0
		v_accvgpr_write_b32 a105, 0
		v_accvgpr_write_b32 a106, 0
		v_accvgpr_write_b32 a107, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a108, 0
		v_accvgpr_write_b32 a109, 0
		v_accvgpr_write_b32 a110, 0
		v_accvgpr_write_b32 a111, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a112, 0
		v_accvgpr_write_b32 a113, 0
		v_accvgpr_write_b32 a114, 0
		v_accvgpr_write_b32 a115, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a116, 0
		v_accvgpr_write_b32 a117, 0
		v_accvgpr_write_b32 a118, 0
		v_accvgpr_write_b32 a119, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a120, 0
		v_accvgpr_write_b32 a121, 0
		v_accvgpr_write_b32 a122, 0
		v_accvgpr_write_b32 a123, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a124, 0
		v_accvgpr_write_b32 a125, 0
		v_accvgpr_write_b32 a126, 0
		v_accvgpr_write_b32 a127, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a128, 0
		v_accvgpr_write_b32 a129, 0
		v_accvgpr_write_b32 a130, 0
		v_accvgpr_write_b32 a131, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a132, 0
		v_accvgpr_write_b32 a133, 0
		v_accvgpr_write_b32 a134, 0
		v_accvgpr_write_b32 a135, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a136, 0
		v_accvgpr_write_b32 a137, 0
		v_accvgpr_write_b32 a138, 0
		v_accvgpr_write_b32 a139, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a140, 0
		v_accvgpr_write_b32 a141, 0
		v_accvgpr_write_b32 a142, 0
		v_accvgpr_write_b32 a143, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a144, 0
		v_accvgpr_write_b32 a145, 0
		v_accvgpr_write_b32 a146, 0
		v_accvgpr_write_b32 a147, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a148, 0
		v_accvgpr_write_b32 a149, 0
		v_accvgpr_write_b32 a150, 0
		v_accvgpr_write_b32 a151, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a152, 0
		v_accvgpr_write_b32 a153, 0
		v_accvgpr_write_b32 a154, 0
		v_accvgpr_write_b32 a155, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a156, 0
		v_accvgpr_write_b32 a157, 0
		v_accvgpr_write_b32 a158, 0
		v_accvgpr_write_b32 a159, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a160, 0
		v_accvgpr_write_b32 a161, 0
		v_accvgpr_write_b32 a162, 0
		v_accvgpr_write_b32 a163, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a164, 0
		v_accvgpr_write_b32 a165, 0
		v_accvgpr_write_b32 a166, 0
		v_accvgpr_write_b32 a167, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a168, 0
		v_accvgpr_write_b32 a169, 0
		v_accvgpr_write_b32 a170, 0
		v_accvgpr_write_b32 a171, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a172, 0
		v_accvgpr_write_b32 a173, 0
		v_accvgpr_write_b32 a174, 0
		v_accvgpr_write_b32 a175, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a176, 0
		v_accvgpr_write_b32 a177, 0
		v_accvgpr_write_b32 a178, 0
		v_accvgpr_write_b32 a179, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a180, 0
		v_accvgpr_write_b32 a181, 0
		v_accvgpr_write_b32 a182, 0
		v_accvgpr_write_b32 a183, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a184, 0
		v_accvgpr_write_b32 a185, 0
		v_accvgpr_write_b32 a186, 0
		v_accvgpr_write_b32 a187, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a188, 0
		v_accvgpr_write_b32 a189, 0
		v_accvgpr_write_b32 a190, 0
		v_accvgpr_write_b32 a191, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a192, 0
		v_accvgpr_write_b32 a193, 0
		v_accvgpr_write_b32 a194, 0
		v_accvgpr_write_b32 a195, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a196, 0
		v_accvgpr_write_b32 a197, 0
		v_accvgpr_write_b32 a198, 0
		v_accvgpr_write_b32 a199, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a200, 0
		v_accvgpr_write_b32 a201, 0
		v_accvgpr_write_b32 a202, 0
		v_accvgpr_write_b32 a203, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a204, 0
		v_accvgpr_write_b32 a205, 0
		v_accvgpr_write_b32 a206, 0
		v_accvgpr_write_b32 a207, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a208, 0
		v_accvgpr_write_b32 a209, 0
		v_accvgpr_write_b32 a210, 0
		v_accvgpr_write_b32 a211, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a212, 0
		v_accvgpr_write_b32 a213, 0
		v_accvgpr_write_b32 a214, 0
		v_accvgpr_write_b32 a215, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a216, 0
		v_accvgpr_write_b32 a217, 0
		v_accvgpr_write_b32 a218, 0
		v_accvgpr_write_b32 a219, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a220, 0
		v_accvgpr_write_b32 a221, 0
		v_accvgpr_write_b32 a222, 0
		v_accvgpr_write_b32 a223, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a224, 0
		v_accvgpr_write_b32 a225, 0
		v_accvgpr_write_b32 a226, 0
		v_accvgpr_write_b32 a227, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a228, 0
		v_accvgpr_write_b32 a229, 0
		v_accvgpr_write_b32 a230, 0
		v_accvgpr_write_b32 a231, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a232, 0
		v_accvgpr_write_b32 a233, 0
		v_accvgpr_write_b32 a234, 0
		v_accvgpr_write_b32 a235, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a236, 0
		v_accvgpr_write_b32 a237, 0
		v_accvgpr_write_b32 a238, 0
		v_accvgpr_write_b32 a239, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a240, 0
		v_accvgpr_write_b32 a241, 0
		v_accvgpr_write_b32 a242, 0
		v_accvgpr_write_b32 a243, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a244, 0
		v_accvgpr_write_b32 a245, 0
		v_accvgpr_write_b32 a246, 0
		v_accvgpr_write_b32 a247, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a248, 0
		v_accvgpr_write_b32 a249, 0
		v_accvgpr_write_b32 a250, 0
		v_accvgpr_write_b32 a251, 0
		v_mov_b64_e32 v[140:141], 0
		v_mov_b64_e32 v[142:143], 0
		v_accvgpr_write_b32 a252, 0
		v_accvgpr_write_b32 a253, 0
		v_accvgpr_write_b32 a254, 0
		v_accvgpr_write_b32 a255, 0
.Lwmma_f16_matmul_tiled.loop_head_0:
		v_mov_b32_e32 v4, s61
		v_mov_b32_e32 v5, 0
		v_mul_lo_u32 v92, v88, v4
		v_mul_hi_u32 v93, v88, v4
		v_mul_lo_u32 v2, v88, v5
		v_add_u32_e32 v93, v93, v2
		v_mul_lo_u32 v2, v89, v4
		v_add_u32_e32 v93, v93, v2
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v104, vcc, v86, v92
		v_addc_co_u32_e64 v105, vcc, v87, v93, vcc
		ds_write_addtid_b32 v104
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v104, vcc, v108, v92
		v_addc_co_u32_e64 v105, vcc, v109, v93, vcc
		ds_write_addtid_b32 v104 offset:1024
		v_add_co_u32_e64 v104, vcc, v110, v92
		v_addc_co_u32_e64 v105, vcc, v111, v93, vcc
		v_add_co_u32_e64 v122, vcc, v112, v92
		v_addc_co_u32_e64 v123, vcc, v113, v93, vcc
		v_add_co_u32_e64 v126, vcc, v114, v92
		v_addc_co_u32_e64 v127, vcc, v115, v93, vcc
		v_add_co_u32_e64 v128, vcc, v118, v92
		v_addc_co_u32_e64 v129, vcc, v119, v93, vcc
		v_add_co_u32_e64 v140, vcc, v120, v92
		v_addc_co_u32_e64 v141, vcc, v121, v93, vcc
		v_add_co_u32_e64 v142, vcc, v124, v92
		v_addc_co_u32_e64 v143, vcc, v125, v93, vcc
		v_add_co_u32_e64 v144, vcc, v6, v92
		v_addc_co_u32_e64 v145, vcc, v7, v93, vcc
		v_add_co_u32_e64 v146, vcc, v130, v92
		v_addc_co_u32_e64 v147, vcc, v131, v93, vcc
		v_add_co_u32_e64 v148, vcc, v132, v92
		v_addc_co_u32_e64 v149, vcc, v133, v93, vcc
		v_add_co_u32_e64 v150, vcc, v134, v92
		v_addc_co_u32_e64 v151, vcc, v135, v93, vcc
		v_add_co_u32_e64 v152, vcc, v136, v92
		v_addc_co_u32_e64 v153, vcc, v137, v93, vcc
		v_add_co_u32_e64 v154, vcc, v138, v92
		v_addc_co_u32_e64 v155, vcc, v139, v93, vcc
		v_add_co_u32_e64 v156, vcc, v106, v92
		v_addc_co_u32_e64 v157, vcc, v107, v93, vcc
		v_add_co_u32_e64 v158, vcc, v116, v92
		v_addc_co_u32_e64 v159, vcc, v117, v93, vcc
		v_mul_lo_u32 v160, v100, v4
		v_mul_hi_u32 v161, v100, v4
		v_mul_lo_u32 v2, v100, v5
		v_add_u32_e32 v161, v161, v2
		v_mul_lo_u32 v2, v101, v4
		v_add_u32_e32 v161, v161, v2
		v_add_co_u32_e64 v4, vcc, v98, v160
		v_addc_co_u32_e64 v5, vcc, v99, v161, vcc
		v_add_co_u32_e64 v162, vcc, v90, v160
		v_addc_co_u32_e64 v163, vcc, v91, v161, vcc
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[16:19], v[48:51], a[0:3], v13, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s62, s61, 1
		s_lshl_b32 s63, s62, 16
		v_add_u32_e32 v2, s63, v3
		v_add3_u32 v2, v2, v11, v9
		ds_read_b128 v[164:167], v2 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[16:19], v[52:55], a[4:7], v13, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[168:171], v2 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[16:19], v[56:59], a[8:11], v13, v81 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[172:175], v2 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[16:19], v[60:63], a[12:15], v13, v81 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[176:179], v2 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[16:19], v[64:67], a[16:19], v13, v82 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[180:183], v2 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[16:19], v[68:71], a[20:23], v13, v82 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[184:187], v2 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[16:19], v[72:75], a[24:27], v13, v83 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[188:191], v2 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[16:19], v[76:79], a[28:31], v13, v83 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[192:195], v2 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[20:23], v[48:51], a[32:35], v13, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, s63, v11
		v_add3_u32 v2, v2, v1, v9
		ds_read_b128 v[196:199], v2 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[20:23], v[52:55], a[36:39], v13, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[200:203], v2 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[20:23], v[56:59], a[40:43], v13, v81 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[204:207], v2 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[20:23], v[60:63], a[44:47], v13, v81 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[208:211], v2 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[20:23], v[64:67], a[48:51], v13, v82 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[212:215], v2 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[20:23], v[68:71], a[52:55], v13, v82 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s63, s61, 1
		s_lshl_b32 s63, s63, 16
		v_and_b32_e32 v2, 15, v0
		v_lshlrev_b32_e32 v5, 6, v2
		v_add_u32_e32 v5, s63, v5
		v_lshrrev_b32_e32 v8, 6, v0
		v_and_b32_e32 v8, 1, v8
		v_lshlrev_b32_e32 v8, 13, v8
		v_and_b32_e32 v10, 63, v0
		v_lshrrev_b32_e32 v10, 4, v10
		v_lshrrev_b32_e32 v2, 1, v2
		v_and_b32_e32 v2, 3, v2
		v_xor_b32_e32 v2, v10, v2
		v_lshlrev_b32_e32 v2, 4, v2
		v_add3_u32 v2, v5, v8, v2
		ds_read_b128 v[216:219], v2 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[20:23], v[72:75], a[56:59], v13, v83 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v2 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[20:23], v[76:79], a[60:63], v13, v83 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v2 offset:56320
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[24:27], v[48:51], a[64:67], v14, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(14)
		ds_read_addtid_b32 v5
		s_mov_b32 m0, s28
		s_waitcnt lgkmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[24:27], v[52:55], a[68:71], v14, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_addtid_b32 v5 offset:1024
		s_mov_b32 m0, s29
		s_waitcnt lgkmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		s_mov_b32 m0, s30
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[24:27], v[56:59], a[72:75], v14, v81 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v104, s[20:23], 0 offen lds
		s_mov_b32 m0, s31
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[24:27], v[60:63], a[76:79], v14, v81 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v122, s[20:23], 0 offen lds
		s_mov_b32 m0, s32
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[24:27], v[64:67], a[80:83], v14, v82 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v126, s[20:23], 0 offen lds
		s_mov_b32 m0, s33
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[24:27], v[68:71], a[84:87], v14, v82 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v128, s[20:23], 0 offen lds
		s_mov_b32 m0, s34
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[24:27], v[72:75], a[88:91], v14, v83 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v140, s[20:23], 0 offen lds
		s_mov_b32 m0, s35
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[24:27], v[76:79], a[92:95], v14, v83 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v142, s[20:23], 0 offen lds
		s_mov_b32 m0, s36
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[28:31], v[48:51], a[96:99], v14, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v144, s[0:3], 0 offen lds
		s_mov_b32 m0, s37
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[28:31], v[52:55], a[100:103], v14, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v146, s[0:3], 0 offen lds
		s_mov_b32 m0, s38
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[28:31], v[56:59], a[104:107], v14, v81 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v148, s[0:3], 0 offen lds
		s_mov_b32 m0, s39
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[28:31], v[60:63], a[108:111], v14, v81 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v150, s[0:3], 0 offen lds
		s_mov_b32 m0, s40
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[28:31], v[64:67], a[112:115], v14, v82 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v152, s[0:3], 0 offen lds
		s_mov_b32 m0, s41
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[28:31], v[68:71], a[116:119], v14, v82 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v154, s[0:3], 0 offen lds
		s_mov_b32 m0, s42
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[28:31], v[72:75], a[120:123], v14, v83 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v156, s[0:3], 0 offen lds
		s_mov_b32 m0, s43
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[28:31], v[76:79], a[124:127], v14, v83 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v158, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[32:35], v[48:51], a[128:131], v15, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s46, 0x20000
		s_nop 0
		buffer_load_dwordx4 v4, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[32:35], v[52:55], a[132:135], v15, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s11, 0x20000
		s_nop 0
		buffer_load_dwordx4 v162, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[32:35], v[56:59], a[136:139], v15, v81 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		s_and_b32 s63, s61, 1
		s_lshl_b32 s63, s63, 16
		v_lshrrev_b32_e32 v4, 7, v0
		v_lshlrev_b32_e32 v4, 13, v4
		v_add_u32_e32 v4, s63, v4
		v_and_b32_e32 v5, 15, v0
		v_lshlrev_b32_e32 v8, 6, v5
		v_and_b32_e32 v10, 63, v0
		v_lshrrev_b32_e32 v10, 4, v10
		v_lshrrev_b32_e32 v5, 1, v5
		v_and_b32_e32 v5, 3, v5
		v_xor_b32_e32 v5, v10, v5
		v_lshlrev_b32_e32 v5, 4, v5
		v_add3_u32 v4, v4, v8, v5
		ds_read_b128 v[16:19], v4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[32:35], v[60:63], a[140:143], v15, v81 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v4 offset:1024
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], v[64:67], a[144:147], v15, v82 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v4 offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[32:35], v[68:71], a[148:151], v15, v82 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[28:31], v4 offset:3072
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[32:35], v[72:75], a[152:155], v15, v83 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[140:143], v4 offset:4096
		s_mov_b32 s63, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v140, s63 offset:24
		scratch_store_dword off, v141, s63 offset:28
		scratch_store_dword off, v142, s63 offset:32
		scratch_store_dword off, v143, s63 offset:36
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[32:35], v[76:79], a[156:159], v15, v83 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[32:35], v4 offset:5120
		s_mov_b32 s63, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v32, s63 offset:40
		scratch_store_dword off, v33, s63 offset:44
		scratch_store_dword off, v34, s63 offset:48
		scratch_store_dword off, v35, s63 offset:52
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], v[48:51], a[160:163], v15, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[32:35], v4 offset:6144
		s_mov_b32 s63, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v32, s63 offset:56
		scratch_store_dword off, v33, s63 offset:60
		scratch_store_dword off, v34, s63 offset:64
		scratch_store_dword off, v35, s63 offset:68
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[36:39], v[52:55], a[164:167], v15, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[32:35], v4 offset:7168
		s_mov_b32 s63, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v32, s63 offset:72
		scratch_store_dword off, v33, s63 offset:76
		scratch_store_dword off, v34, s63 offset:80
		scratch_store_dword off, v35, s63 offset:84
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[36:39], v[56:59], a[168:171], v15, v81 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[32:35], v2 offset:32768
		s_mov_b32 s63, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v32, s63 offset:88
		scratch_store_dword off, v33, s63 offset:92
		scratch_store_dword off, v34, s63 offset:96
		scratch_store_dword off, v35, s63 offset:100
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[36:39], v[60:63], a[172:175], v15, v81 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[32:35], v2 offset:33792
		s_mov_b32 s63, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v32, s63 offset:104
		scratch_store_dword off, v33, s63 offset:108
		scratch_store_dword off, v34, s63 offset:112
		scratch_store_dword off, v35, s63 offset:116
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[36:39], v[64:67], a[176:179], v15, v82 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[32:35], v2 offset:34816
		s_mov_b32 s63, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v32, s63 offset:120
		scratch_store_dword off, v33, s63 offset:124
		scratch_store_dword off, v34, s63 offset:128
		scratch_store_dword off, v35, s63 offset:132
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[36:39], v[68:71], a[180:183], v15, v82 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[32:35], v2 offset:35840
		s_mov_b32 s63, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v32, s63 offset:136
		scratch_store_dword off, v33, s63 offset:140
		scratch_store_dword off, v34, s63 offset:144
		scratch_store_dword off, v35, s63 offset:148
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[36:39], v[72:75], a[184:187], v15, v83 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[32:35], v2 offset:36864
		s_mov_b32 s63, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v32, s63 offset:152
		scratch_store_dword off, v33, s63 offset:156
		scratch_store_dword off, v34, s63 offset:160
		scratch_store_dword off, v35, s63 offset:164
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[36:39], v[76:79], a[188:191], v15, v83 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[32:35], v2 offset:37888
		s_mov_b32 s63, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v32, s63 offset:168
		scratch_store_dword off, v33, s63 offset:172
		scratch_store_dword off, v34, s63 offset:176
		scratch_store_dword off, v35, s63 offset:180
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[40:43], v[48:51], a[192:195], v80, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[140:143], v2 offset:38912
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[40:43], v[52:55], a[196:199], v80, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[144:147], v2 offset:39936
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[40:43], v[56:59], a[200:203], v80, v81 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshl_b32 s62, s62, 12
		s_add_i32 s62, s62, 0x20000
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v2, 10, v2
		v_and_b32_e32 v4, 63, v0
		v_lshlrev_b32_e32 v4, 2, v4
		v_add3_u32 v5, s62, v2, v4
		ds_read_b32 v8, v5
		ds_read_b32 v10, v5 offset:256
		ds_read_b32 v104, v5 offset:512
		ds_read_b32 v105, v5 offset:768
		v_lshrrev_b32_e32 v5, 6, v0
		v_and_b32_e32 v5, 1, v5
		v_lshlrev_b32_e32 v5, 10, v5
		v_add3_u32 v32, s62, v4, v5
		ds_read_b32 v122, v32 offset:2048
		ds_read_b32 v123, v32 offset:2304
		ds_read_b32 v126, v32 offset:2560
		ds_read_b32 v127, v32 offset:2816
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[40:43], v[60:63], a[204:207], v80, v81 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[40:43], v[64:67], a[208:211], v80, v82 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[40:43], v[68:71], a[212:215], v80, v82 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[40:43], v[72:75], a[216:219], v80, v83 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[40:43], v[76:79], a[220:223], v80, v83 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[44:47], v[48:51], a[224:227], v80, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[44:47], v[52:55], a[228:231], v80, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[44:47], v[56:59], a[232:235], v80, v81 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[44:47], v[60:63], a[236:239], v80, v81 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[44:47], v[64:67], a[240:243], v80, v82 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[44:47], v[68:71], a[244:247], v80, v82 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[44:47], v[72:75], a[248:251], v80, v83 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[44:47], v[76:79], a[252:255], v80, v83 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[164:167], v[196:199], a[0:3], v13, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[164:167], v[200:203], a[4:7], v13, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[164:167], v[204:207], a[8:11], v13, v81 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[164:167], v[208:211], a[12:15], v13, v81 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[164:167], v[212:215], a[16:19], v13, v82 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[164:167], v[216:219], a[20:23], v13, v82 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[164:167], v[220:223], a[24:27], v13, v83 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[164:167], v[224:227], a[28:31], v13, v83 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[168:171], v[196:199], a[32:35], v13, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[168:171], v[200:203], a[36:39], v13, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[168:171], v[204:207], a[40:43], v13, v81 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[168:171], v[208:211], a[44:47], v13, v81 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[168:171], v[212:215], a[48:51], v13, v82 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[168:171], v[216:219], a[52:55], v13, v82 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[168:171], v[220:223], a[56:59], v13, v83 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[168:171], v[224:227], a[60:63], v13, v83 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[172:175], v[196:199], a[64:67], v14, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[172:175], v[200:203], a[68:71], v14, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[172:175], v[204:207], a[72:75], v14, v81 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[172:175], v[208:211], a[76:79], v14, v81 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[172:175], v[212:215], a[80:83], v14, v82 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[172:175], v[216:219], a[84:87], v14, v82 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[172:175], v[220:223], a[88:91], v14, v83 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[172:175], v[224:227], a[92:95], v14, v83 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[176:179], v[196:199], a[96:99], v14, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[176:179], v[200:203], a[100:103], v14, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[176:179], v[204:207], a[104:107], v14, v81 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[176:179], v[208:211], a[108:111], v14, v81 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[176:179], v[212:215], a[112:115], v14, v82 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[176:179], v[216:219], a[116:119], v14, v82 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[176:179], v[220:223], a[120:123], v14, v83 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[176:179], v[224:227], a[124:127], v14, v83 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[180:183], v[196:199], a[128:131], v15, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[180:183], v[200:203], a[132:135], v15, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[180:183], v[204:207], a[136:139], v15, v81 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[180:183], v[208:211], a[140:143], v15, v81 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[180:183], v[212:215], a[144:147], v15, v82 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[180:183], v[216:219], a[148:151], v15, v82 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[180:183], v[220:223], a[152:155], v15, v83 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[180:183], v[224:227], a[156:159], v15, v83 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[184:187], v[196:199], a[160:163], v15, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[184:187], v[200:203], a[164:167], v15, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[184:187], v[204:207], a[168:171], v15, v81 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[184:187], v[208:211], a[172:175], v15, v81 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[184:187], v[212:215], a[176:179], v15, v82 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[184:187], v[216:219], a[180:183], v15, v82 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[184:187], v[220:223], a[184:187], v15, v83 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[184:187], v[224:227], a[188:191], v15, v83 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[188:191], v[196:199], a[192:195], v80, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[188:191], v[200:203], a[196:199], v80, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[188:191], v[204:207], a[200:203], v80, v81 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[188:191], v[208:211], a[204:207], v80, v81 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[188:191], v[212:215], a[208:211], v80, v82 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[188:191], v[216:219], a[212:215], v80, v82 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[188:191], v[220:223], a[216:219], v80, v83 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[188:191], v[224:227], a[220:223], v80, v83 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[192:195], v[196:199], a[224:227], v80, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[192:195], v[200:203], a[228:231], v80, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[192:195], v[204:207], a[232:235], v80, v81 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[192:195], v[208:211], a[236:239], v80, v81 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[192:195], v[212:215], a[240:243], v80, v82 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[192:195], v[216:219], a[244:247], v80, v82 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[192:195], v[220:223], a[248:251], v80, v83 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[192:195], v[224:227], a[252:255], v80, v83 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		s_add_i32 s62, s61, 1
		s_and_b32 s62, s62, 1
		s_lshl_b32 s63, s62, 16
		v_lshrrev_b32_e32 v12, 7, v0
		v_lshlrev_b32_e32 v12, 13, v12
		v_add_u32_e32 v13, s63, v12
		v_and_b32_e32 v14, 15, v0
		v_lshlrev_b32_e32 v14, 6, v14
		v_and_b32_e32 v15, 63, v0
		v_lshrrev_b32_e32 v15, 4, v15
		v_and_b32_e32 v32, 15, v0
		v_lshrrev_b32_e32 v32, 1, v32
		v_and_b32_e32 v32, 3, v32
		v_xor_b32_e32 v15, v15, v32
		v_lshlrev_b32_e32 v15, 4, v15
		v_add3_u32 v13, v13, v14, v15
		ds_read_b128 v[32:35], v13
		ds_read_b128 v[36:39], v13 offset:1024
		ds_read_b128 v[40:43], v13 offset:2048
		ds_read_b128 v[44:47], v13 offset:3072
		ds_read_b128 v[48:51], v13 offset:4096
		ds_read_b128 v[52:55], v13 offset:5120
		ds_read_b128 v[56:59], v13 offset:6144
		ds_read_b128 v[60:63], v13 offset:7168
		v_add_u32_e32 v64, s63, v14
		v_lshrrev_b32_e32 v65, 6, v0
		v_and_b32_e32 v65, 1, v65
		v_lshlrev_b32_e32 v65, 13, v65
		v_add3_u32 v64, v64, v65, v15
		ds_read_b128 v[68:71], v64 offset:32768
		ds_read_b128 v[72:75], v64 offset:33792
		ds_read_b128 v[76:79], v64 offset:34816
		ds_read_b128 v[80:83], v64 offset:35840
		ds_read_b128 v[148:151], v64 offset:36864
		ds_read_b128 v[152:155], v64 offset:37888
		ds_read_b128 v[156:159], v64 offset:38912
		ds_read_b128 v[164:167], v64 offset:39936
		s_lshl_b32 s62, s62, 12
		s_add_i32 s62, s62, 0x20000
		v_add3_u32 v2, s62, v2, v4
		ds_read_b32 v64, v2
		ds_read_b32 v66, v2 offset:256
		ds_read_b32 v67, v2 offset:512
		ds_read_b32 v128, v2 offset:768
		v_add3_u32 v2, s62, v4, v5
		ds_read_b32 v4, v2 offset:2048
		ds_read_b32 v5, v2 offset:2304
		ds_read_b32 v129, v2 offset:2560
		ds_read_b32 v162, v2 offset:2816
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v168 offset:2048
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v169 offset:3072
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v170, vcc, v168, v92
		v_addc_co_u32_e64 v171, vcc, v169, v93, vcc
		ds_read_addtid_b32 v168 offset:4096
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v169 offset:5120
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v172, vcc, v168, v92
		v_addc_co_u32_e64 v173, vcc, v169, v93, vcc
		ds_read_addtid_b32 v168 offset:6144
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v169 offset:7168
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v174, vcc, v168, v92
		v_addc_co_u32_e64 v175, vcc, v169, v93, vcc
		ds_read_addtid_b32 v168 offset:8192
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v169 offset:9216
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v176, vcc, v168, v92
		v_addc_co_u32_e64 v177, vcc, v169, v93, vcc
		ds_read_addtid_b32 v168 offset:10240
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v169 offset:11264
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v178, vcc, v168, v92
		v_addc_co_u32_e64 v179, vcc, v169, v93, vcc
		ds_read_addtid_b32 v168 offset:12288
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v169 offset:13312
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v180, vcc, v168, v92
		v_addc_co_u32_e64 v181, vcc, v169, v93, vcc
		ds_read_addtid_b32 v168 offset:14336
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v169 offset:15360
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v182, vcc, v168, v92
		v_addc_co_u32_e64 v183, vcc, v169, v93, vcc
		ds_read_addtid_b32 v168 offset:16384
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v169 offset:17408
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v184, vcc, v168, v92
		v_addc_co_u32_e64 v185, vcc, v169, v93, vcc
		ds_read_addtid_b32 v168 offset:18432
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v169 offset:19456
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v186, vcc, v168, v92
		v_addc_co_u32_e64 v187, vcc, v169, v93, vcc
		ds_read_addtid_b32 v168 offset:20480
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v169 offset:21504
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v188, vcc, v168, v92
		v_addc_co_u32_e64 v189, vcc, v169, v93, vcc
		ds_read_addtid_b32 v168 offset:22528
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v169 offset:23552
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v190, vcc, v168, v92
		v_addc_co_u32_e64 v191, vcc, v169, v93, vcc
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(44)
		scratch_load_dword v168, off, s62
		scratch_load_dword v169, off, s62 offset:4
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v192, vcc, v168, v92
		v_addc_co_u32_e64 v193, vcc, v169, v93, vcc
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(42)
		scratch_load_dword v168, off, s62 offset:8
		scratch_load_dword v169, off, s62 offset:12
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v194, vcc, v168, v92
		v_addc_co_u32_e64 v195, vcc, v169, v93, vcc
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(40)
		scratch_load_dword v168, off, s62 offset:16
		scratch_load_dword v169, off, s62 offset:20
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v196, vcc, v168, v92
		v_addc_co_u32_e64 v197, vcc, v169, v93, vcc
		v_add_co_u32_e64 v168, vcc, v94, v92
		v_addc_co_u32_e64 v169, vcc, v95, v93, vcc
		v_add_co_u32_e64 v198, vcc, v96, v92
		v_addc_co_u32_e64 v199, vcc, v97, v93, vcc
		v_add_co_u32_e64 v92, vcc, v102, v160
		v_addc_co_u32_e64 v93, vcc, v103, v161, vcc
		v_add_co_u32_e64 v200, vcc, v84, v160
		v_addc_co_u32_e64 v201, vcc, v85, v161, vcc
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[32:35], v[68:71], a[0:3], v64, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[204:207], v13 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[32:35], v[72:75], a[4:7], v64, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[208:211], v13 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[32:35], v[76:79], a[8:11], v64, v5 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[212:215], v13 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[32:35], v[80:83], a[12:15], v64, v5 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v13 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[32:35], v[148:151], a[16:19], v64, v129 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s62, s61, 1
		s_and_b32 s62, s62, 1
		s_lshl_b32 s62, s62, 16
		v_add_u32_e32 v2, s62, v12
		v_add3_u32 v2, v2, v14, v15
		ds_read_b128 v[220:223], v2 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[32:35], v[152:155], a[20:23], v64, v129 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v2 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[32:35], v[156:159], a[24:27], v64, v162 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v2 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[32:35], v[164:167], a[28:31], v64, v162 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[32:35], v2 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[36:39], v[68:71], a[32:35], v64, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s62, s61, 1
		s_and_b32 s62, s62, 1
		s_lshl_b32 s62, s62, 16
		v_add_u32_e32 v2, s62, v14
		v_add3_u32 v2, v2, v65, v15
		ds_read_b128 v[12:15], v2 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[36:39], v[72:75], a[36:39], v64, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[232:235], v2 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[36:39], v[76:79], a[40:43], v64, v5 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[236:239], v2 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[36:39], v[80:83], a[44:47], v64, v5 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v2 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[36:39], v[148:151], a[48:51], v64, v129 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[244:247], v2 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[36:39], v[152:155], a[52:55], v64, v129 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v2 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[36:39], v[156:159], a[56:59], v64, v162 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[252:255], v2 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[36:39], v[164:167], a[60:63], v64, v162 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[36:39], v2 offset:56320
		s_mov_b32 m0, s10
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[40:43], v[68:71], a[64:67], v66, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v170, s[20:23], 0 offen lds
		s_mov_b32 m0, s45
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[40:43], v[72:75], a[68:71], v66, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v172, s[20:23], 0 offen lds
		s_mov_b32 m0, s47
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[40:43], v[76:79], a[72:75], v66, v5 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v174, s[20:23], 0 offen lds
		s_mov_b32 m0, s48
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[40:43], v[80:83], a[76:79], v66, v5 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v176, s[20:23], 0 offen lds
		s_mov_b32 m0, s49
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[40:43], v[148:151], a[80:83], v66, v129 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v178, s[20:23], 0 offen lds
		s_mov_b32 m0, s50
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[40:43], v[152:155], a[84:87], v66, v129 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v180, s[20:23], 0 offen lds
		s_mov_b32 m0, s51
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[40:43], v[156:159], a[88:91], v66, v162 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v182, s[20:23], 0 offen lds
		s_mov_b32 m0, s52
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[40:43], v[164:167], a[92:95], v66, v162 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v184, s[20:23], 0 offen lds
		s_mov_b32 m0, s53
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[44:47], v[68:71], a[96:99], v66, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v186, s[0:3], 0 offen lds
		s_mov_b32 m0, s54
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[44:47], v[72:75], a[100:103], v66, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v188, s[0:3], 0 offen lds
		s_mov_b32 m0, s55
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[44:47], v[76:79], a[104:107], v66, v5 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v190, s[0:3], 0 offen lds
		s_mov_b32 m0, s56
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[44:47], v[80:83], a[108:111], v66, v5 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v192, s[0:3], 0 offen lds
		s_mov_b32 m0, s57
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[44:47], v[148:151], a[112:115], v66, v129 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v194, s[0:3], 0 offen lds
		s_mov_b32 m0, s58
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[44:47], v[152:155], a[116:119], v66, v129 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v196, s[0:3], 0 offen lds
		s_mov_b32 m0, s59
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[44:47], v[156:159], a[120:123], v66, v162 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v168, s[0:3], 0 offen lds
		s_mov_b32 m0, s60
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[44:47], v[164:167], a[124:127], v66, v162 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v198, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[48:51], v[68:71], a[128:131], v67, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s44, 0x20000
		s_nop 0
		buffer_load_dwordx4 v92, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[48:51], v[72:75], a[132:135], v67, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s9, 0x20000
		s_nop 0
		buffer_load_dwordx4 v200, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[48:51], v[76:79], a[136:139], v67, v5 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[48:51], v[80:83], a[140:143], v67, v5 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[48:51], v[148:151], a[144:147], v67, v129 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[48:51], v[152:155], a[148:151], v67, v129 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[48:51], v[156:159], a[152:155], v67, v162 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[48:51], v[164:167], a[156:159], v67, v162 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[52:55], v[68:71], a[160:163], v67, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[52:55], v[72:75], a[164:167], v67, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[52:55], v[76:79], a[168:171], v67, v5 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[52:55], v[80:83], a[172:175], v67, v5 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[52:55], v[148:151], a[176:179], v67, v129 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[52:55], v[152:155], a[180:183], v67, v129 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[52:55], v[156:159], a[184:187], v67, v162 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[52:55], v[164:167], a[188:191], v67, v162 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[56:59], v[68:71], a[192:195], v128, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[56:59], v[72:75], a[196:199], v128, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[56:59], v[76:79], a[200:203], v128, v5 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[56:59], v[80:83], a[204:207], v128, v5 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[56:59], v[148:151], a[208:211], v128, v129 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[56:59], v[152:155], a[212:215], v128, v129 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[56:59], v[156:159], a[216:219], v128, v162 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[56:59], v[164:167], a[220:223], v128, v162 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[60:63], v[68:71], a[224:227], v128, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[60:63], v[72:75], a[228:231], v128, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[60:63], v[76:79], a[232:235], v128, v5 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[60:63], v[80:83], a[236:239], v128, v5 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[60:63], v[148:151], a[240:243], v128, v129 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[60:63], v[152:155], a[244:247], v128, v129 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[60:63], v[156:159], a[248:251], v128, v162 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[60:63], v[164:167], a[252:255], v128, v162 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[204:207], v[12:15], a[0:3], v64, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[204:207], v[232:235], a[4:7], v64, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[204:207], v[236:239], a[8:11], v64, v5 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[204:207], v[240:243], a[12:15], v64, v5 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[204:207], v[244:247], a[16:19], v64, v129 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[204:207], v[248:251], a[20:23], v64, v129 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[204:207], v[252:255], a[24:27], v64, v162 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[204:207], v[36:39], a[28:31], v64, v162 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[208:211], v[12:15], a[32:35], v64, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[208:211], v[232:235], a[36:39], v64, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[208:211], v[236:239], a[40:43], v64, v5 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[208:211], v[240:243], a[44:47], v64, v5 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[208:211], v[244:247], a[48:51], v64, v129 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[208:211], v[248:251], a[52:55], v64, v129 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[208:211], v[252:255], a[56:59], v64, v162 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[208:211], v[36:39], a[60:63], v64, v162 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[212:215], v[12:15], a[64:67], v66, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[212:215], v[232:235], a[68:71], v66, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[212:215], v[236:239], a[72:75], v66, v5 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[212:215], v[240:243], a[76:79], v66, v5 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[212:215], v[244:247], a[80:83], v66, v129 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[212:215], v[248:251], a[84:87], v66, v129 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[212:215], v[252:255], a[88:91], v66, v162 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[212:215], v[36:39], a[92:95], v66, v162 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[216:219], v[12:15], a[96:99], v66, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[216:219], v[232:235], a[100:103], v66, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[216:219], v[236:239], a[104:107], v66, v5 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[216:219], v[240:243], a[108:111], v66, v5 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[216:219], v[244:247], a[112:115], v66, v129 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[216:219], v[248:251], a[116:119], v66, v129 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[216:219], v[252:255], a[120:123], v66, v162 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[216:219], v[36:39], a[124:127], v66, v162 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[220:223], v[12:15], a[128:131], v67, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[220:223], v[232:235], a[132:135], v67, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[220:223], v[236:239], a[136:139], v67, v5 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[220:223], v[240:243], a[140:143], v67, v5 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[220:223], v[244:247], a[144:147], v67, v129 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[220:223], v[248:251], a[148:151], v67, v129 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[220:223], v[252:255], a[152:155], v67, v162 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[220:223], v[36:39], a[156:159], v67, v162 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[224:227], v[12:15], a[160:163], v67, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[224:227], v[232:235], a[164:167], v67, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[224:227], v[236:239], a[168:171], v67, v5 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[224:227], v[240:243], a[172:175], v67, v5 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[224:227], v[244:247], a[176:179], v67, v129 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[224:227], v[248:251], a[180:183], v67, v129 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[224:227], v[252:255], a[184:187], v67, v162 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[224:227], v[36:39], a[188:191], v67, v162 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[228:231], v[12:15], a[192:195], v128, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[228:231], v[232:235], a[196:199], v128, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[228:231], v[236:239], a[200:203], v128, v5 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[228:231], v[240:243], a[204:207], v128, v5 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[228:231], v[244:247], a[208:211], v128, v129 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[228:231], v[248:251], a[212:215], v128, v129 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[228:231], v[252:255], a[216:219], v128, v162 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[228:231], v[36:39], a[220:223], v128, v162 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[32:35], v[12:15], a[224:227], v128, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[32:35], v[232:235], a[228:231], v128, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[32:35], v[236:239], a[232:235], v128, v5 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[32:35], v[240:243], a[236:239], v128, v5 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[32:35], v[244:247], a[240:243], v128, v129 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[32:35], v[248:251], a[244:247], v128, v129 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[32:35], v[252:255], a[248:251], v128, v162 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[32:35], v[36:39], a[252:255], v128, v162 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s61, s61, 2
		s_cmp_lt_i32 s61, s8
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(36)
		scratch_load_dword v12, off, s62 offset:24
		scratch_load_dword v13, off, s62 offset:28
		scratch_load_dword v14, off, s62 offset:32
		scratch_load_dword v15, off, s62 offset:36
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v32, v12
		v_mov_b32_e32 v33, v13
		v_mov_b32_e32 v34, v14
		v_mov_b32_e32 v35, v15
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(32)
		scratch_load_dword v12, off, s62 offset:40
		scratch_load_dword v13, off, s62 offset:44
		scratch_load_dword v14, off, s62 offset:48
		scratch_load_dword v15, off, s62 offset:52
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v36, v12
		v_mov_b32_e32 v37, v13
		v_mov_b32_e32 v38, v14
		v_mov_b32_e32 v39, v15
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(28)
		scratch_load_dword v12, off, s62 offset:56
		scratch_load_dword v13, off, s62 offset:60
		scratch_load_dword v14, off, s62 offset:64
		scratch_load_dword v15, off, s62 offset:68
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v40, v12
		v_mov_b32_e32 v41, v13
		v_mov_b32_e32 v42, v14
		v_mov_b32_e32 v43, v15
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v12, off, s62 offset:72
		scratch_load_dword v13, off, s62 offset:76
		scratch_load_dword v14, off, s62 offset:80
		scratch_load_dword v15, off, s62 offset:84
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v44, v12
		v_mov_b32_e32 v45, v13
		v_mov_b32_e32 v46, v14
		v_mov_b32_e32 v47, v15
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(20)
		scratch_load_dword v12, off, s62 offset:88
		scratch_load_dword v13, off, s62 offset:92
		scratch_load_dword v14, off, s62 offset:96
		scratch_load_dword v15, off, s62 offset:100
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v48, v12
		v_mov_b32_e32 v49, v13
		v_mov_b32_e32 v50, v14
		v_mov_b32_e32 v51, v15
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v12, off, s62 offset:104
		scratch_load_dword v13, off, s62 offset:108
		scratch_load_dword v14, off, s62 offset:112
		scratch_load_dword v15, off, s62 offset:116
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v52, v12
		v_mov_b32_e32 v53, v13
		v_mov_b32_e32 v54, v14
		v_mov_b32_e32 v55, v15
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(12)
		scratch_load_dword v12, off, s62 offset:120
		scratch_load_dword v13, off, s62 offset:124
		scratch_load_dword v14, off, s62 offset:128
		scratch_load_dword v15, off, s62 offset:132
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v56, v12
		v_mov_b32_e32 v57, v13
		v_mov_b32_e32 v58, v14
		v_mov_b32_e32 v59, v15
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v12, off, s62 offset:136
		scratch_load_dword v13, off, s62 offset:140
		scratch_load_dword v14, off, s62 offset:144
		scratch_load_dword v15, off, s62 offset:148
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v60, v12
		v_mov_b32_e32 v61, v13
		v_mov_b32_e32 v62, v14
		v_mov_b32_e32 v63, v15
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v12, off, s62 offset:152
		scratch_load_dword v13, off, s62 offset:156
		scratch_load_dword v14, off, s62 offset:160
		scratch_load_dword v15, off, s62 offset:164
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v64, v12
		v_mov_b32_e32 v65, v13
		v_mov_b32_e32 v66, v14
		v_mov_b32_e32 v67, v15
		s_mov_b32 s62, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v12, off, s62 offset:168
		scratch_load_dword v13, off, s62 offset:172
		scratch_load_dword v14, off, s62 offset:176
		scratch_load_dword v15, off, s62 offset:180
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v68, v12
		v_mov_b32_e32 v69, v13
		v_mov_b32_e32 v70, v14
		v_mov_b32_e32 v71, v15
		v_mov_b32_e32 v72, v140
		v_mov_b32_e32 v73, v141
		v_mov_b32_e32 v74, v142
		v_mov_b32_e32 v75, v143
		v_mov_b32_e32 v76, v144
		v_mov_b32_e32 v77, v145
		v_mov_b32_e32 v78, v146
		v_mov_b32_e32 v79, v147
		v_mov_b32_e32 v13, v8
		v_mov_b32_e32 v14, v10
		v_mov_b32_e32 v15, v104
		v_mov_b32_e32 v80, v105
		v_mov_b32_e32 v12, v122
		v_mov_b32_e32 v81, v123
		v_mov_b32_e32 v82, v126
		v_mov_b32_e32 v83, v127
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_add_i32 s0, s12, -1
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[16:19], v[48:51], a[0:3], v13, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s0, s0, 1
		s_lshl_b32 s0, s0, 16
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v1, 13, v1
		v_add_u32_e32 v2, s0, v1
		v_and_b32_e32 v3, 15, v0
		v_lshlrev_b32_e32 v3, 6, v3
		v_and_b32_e32 v4, 63, v0
		v_lshrrev_b32_e32 v4, 4, v4
		v_and_b32_e32 v5, 15, v0
		v_lshrrev_b32_e32 v5, 1, v5
		v_and_b32_e32 v5, 3, v5
		v_xor_b32_e32 v4, v4, v5
		v_lshlrev_b32_e32 v4, 4, v4
		v_add3_u32 v2, v2, v3, v4
		ds_read_b128 v[8:11], v2 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[16:19], v[52:55], a[4:7], v13, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[84:87], v2 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[16:19], v[56:59], a[8:11], v13, v81 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v2 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[16:19], v[60:63], a[12:15], v13, v81 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v2 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[16:19], v[64:67], a[16:19], v13, v82 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v2 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[16:19], v[68:71], a[20:23], v13, v82 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v2 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[16:19], v[72:75], a[24:27], v13, v83 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[104:107], v2 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[16:19], v[76:79], a[28:31], v13, v83 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[16:19], v2 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[20:23], v[48:51], a[32:35], v13, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, s0, v3
		v_lshrrev_b32_e32 v5, 6, v0
		v_and_b32_e32 v5, 1, v5
		v_lshlrev_b32_e32 v5, 13, v5
		v_add3_u32 v2, v2, v5, v4
		ds_read_b128 v[108:111], v2 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[20:23], v[52:55], a[36:39], v13, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[112:115], v2 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[20:23], v[56:59], a[40:43], v13, v81 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[116:119], v2 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[20:23], v[60:63], a[44:47], v13, v81 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[120:123], v2 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[20:23], v[64:67], a[48:51], v13, v82 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[124:127], v2 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[20:23], v[68:71], a[52:55], v13, v82 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[128:131], v2 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[20:23], v[72:75], a[56:59], v13, v83 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[132:135], v2 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[20:23], v[76:79], a[60:63], v13, v83 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v2 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[24:27], v[48:51], a[64:67], v14, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[24:27], v[52:55], a[68:71], v14, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[24:27], v[56:59], a[72:75], v14, v81 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[24:27], v[60:63], a[76:79], v14, v81 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[24:27], v[64:67], a[80:83], v14, v82 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[24:27], v[68:71], a[84:87], v14, v82 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[24:27], v[72:75], a[88:91], v14, v83 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[24:27], v[76:79], a[92:95], v14, v83 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[28:31], v[48:51], a[96:99], v14, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[28:31], v[52:55], a[100:103], v14, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[28:31], v[56:59], a[104:107], v14, v81 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[28:31], v[60:63], a[108:111], v14, v81 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[28:31], v[64:67], a[112:115], v14, v82 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[28:31], v[68:71], a[116:119], v14, v82 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[28:31], v[72:75], a[120:123], v14, v83 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[28:31], v[76:79], a[124:127], v14, v83 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[32:35], v[48:51], a[128:131], v15, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[32:35], v[52:55], a[132:135], v15, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[32:35], v[56:59], a[136:139], v15, v81 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[32:35], v[60:63], a[140:143], v15, v81 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], v[64:67], a[144:147], v15, v82 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[32:35], v[68:71], a[148:151], v15, v82 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[32:35], v[72:75], a[152:155], v15, v83 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[32:35], v[76:79], a[156:159], v15, v83 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], v[48:51], a[160:163], v15, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[36:39], v[52:55], a[164:167], v15, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[36:39], v[56:59], a[168:171], v15, v81 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[36:39], v[60:63], a[172:175], v15, v81 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[36:39], v[64:67], a[176:179], v15, v82 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[36:39], v[68:71], a[180:183], v15, v82 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[36:39], v[72:75], a[184:187], v15, v83 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[36:39], v[76:79], a[188:191], v15, v83 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[40:43], v[48:51], a[192:195], v80, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[40:43], v[52:55], a[196:199], v80, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[40:43], v[56:59], a[200:203], v80, v81 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[40:43], v[60:63], a[204:207], v80, v81 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[40:43], v[64:67], a[208:211], v80, v82 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[40:43], v[68:71], a[212:215], v80, v82 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[40:43], v[72:75], a[216:219], v80, v83 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[40:43], v[76:79], a[220:223], v80, v83 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[44:47], v[48:51], a[224:227], v80, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[44:47], v[52:55], a[228:231], v80, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[44:47], v[56:59], a[232:235], v80, v81 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[44:47], v[60:63], a[236:239], v80, v81 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[44:47], v[64:67], a[240:243], v80, v82 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[44:47], v[68:71], a[244:247], v80, v82 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[44:47], v[72:75], a[248:251], v80, v83 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[44:47], v[76:79], a[252:255], v80, v83 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[8:11], v[108:111], a[0:3], v13, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[8:11], v[112:115], a[4:7], v13, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[8:11], v[116:119], a[8:11], v13, v81 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[8:11], v[120:123], a[12:15], v13, v81 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[8:11], v[124:127], a[16:19], v13, v82 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[8:11], v[128:131], a[20:23], v13, v82 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[8:11], v[132:135], a[24:27], v13, v83 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[8:11], v[20:23], a[28:31], v13, v83 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[84:87], v[108:111], a[32:35], v13, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[84:87], v[112:115], a[36:39], v13, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[84:87], v[116:119], a[40:43], v13, v81 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[84:87], v[120:123], a[44:47], v13, v81 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[84:87], v[124:127], a[48:51], v13, v82 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[84:87], v[128:131], a[52:55], v13, v82 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[84:87], v[132:135], a[56:59], v13, v83 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[84:87], v[20:23], a[60:63], v13, v83 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[88:91], v[108:111], a[64:67], v14, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[88:91], v[112:115], a[68:71], v14, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[88:91], v[116:119], a[72:75], v14, v81 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[88:91], v[120:123], a[76:79], v14, v81 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[88:91], v[124:127], a[80:83], v14, v82 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[88:91], v[128:131], a[84:87], v14, v82 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[88:91], v[132:135], a[88:91], v14, v83 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[88:91], v[20:23], a[92:95], v14, v83 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[92:95], v[108:111], a[96:99], v14, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[92:95], v[112:115], a[100:103], v14, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[92:95], v[116:119], a[104:107], v14, v81 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[92:95], v[120:123], a[108:111], v14, v81 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[92:95], v[124:127], a[112:115], v14, v82 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[92:95], v[128:131], a[116:119], v14, v82 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[92:95], v[132:135], a[120:123], v14, v83 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[92:95], v[20:23], a[124:127], v14, v83 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[96:99], v[108:111], a[128:131], v15, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[96:99], v[112:115], a[132:135], v15, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[96:99], v[116:119], a[136:139], v15, v81 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[96:99], v[120:123], a[140:143], v15, v81 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[96:99], v[124:127], a[144:147], v15, v82 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[96:99], v[128:131], a[148:151], v15, v82 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[96:99], v[132:135], a[152:155], v15, v83 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[96:99], v[20:23], a[156:159], v15, v83 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[100:103], v[108:111], a[160:163], v15, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[100:103], v[112:115], a[164:167], v15, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[100:103], v[116:119], a[168:171], v15, v81 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[100:103], v[120:123], a[172:175], v15, v81 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[100:103], v[124:127], a[176:179], v15, v82 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[100:103], v[128:131], a[180:183], v15, v82 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[100:103], v[132:135], a[184:187], v15, v83 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[100:103], v[20:23], a[188:191], v15, v83 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[104:107], v[108:111], a[192:195], v80, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[104:107], v[112:115], a[196:199], v80, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[104:107], v[116:119], a[200:203], v80, v81 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[104:107], v[120:123], a[204:207], v80, v81 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[104:107], v[124:127], a[208:211], v80, v82 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[104:107], v[128:131], a[212:215], v80, v82 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[104:107], v[132:135], a[216:219], v80, v83 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[104:107], v[20:23], a[220:223], v80, v83 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[16:19], v[108:111], a[224:227], v80, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[16:19], v[112:115], a[228:231], v80, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[16:19], v[116:119], a[232:235], v80, v81 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[16:19], v[120:123], a[236:239], v80, v81 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[16:19], v[124:127], a[240:243], v80, v82 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[16:19], v[128:131], a[244:247], v80, v82 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[16:19], v[132:135], a[248:251], v80, v83 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[16:19], v[20:23], a[252:255], v80, v83 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s0, s12, 1
		s_lshl_b32 s1, s0, 16
		v_add_u32_e32 v1, s1, v1
		v_add3_u32 v1, v1, v3, v4
		ds_read_b128 v[8:11], v1
		ds_read_b128 v[12:15], v1 offset:1024
		ds_read_b128 v[16:19], v1 offset:2048
		ds_read_b128 v[20:23], v1 offset:3072
		ds_read_b128 v[24:27], v1 offset:4096
		ds_read_b128 v[28:31], v1 offset:5120
		ds_read_b128 v[32:35], v1 offset:6144
		ds_read_b128 v[36:39], v1 offset:7168
		v_add_u32_e32 v2, s1, v3
		v_add3_u32 v2, v2, v5, v4
		ds_read_b128 v[4:7], v2 offset:32768
		ds_read_b128 v[40:43], v2 offset:33792
		ds_read_b128 v[44:47], v2 offset:34816
		ds_read_b128 v[48:51], v2 offset:35840
		ds_read_b128 v[52:55], v2 offset:36864
		ds_read_b128 v[56:59], v2 offset:37888
		ds_read_b128 v[60:63], v2 offset:38912
		ds_read_b128 v[64:67], v2 offset:39936
		s_lshl_b32 s0, s0, 12
		s_add_i32 s0, s0, 0x20000
		v_lshrrev_b32_e32 v3, 7, v0
		v_lshlrev_b32_e32 v3, 10, v3
		v_and_b32_e32 v68, 63, v0
		v_lshlrev_b32_e32 v68, 2, v68
		v_add3_u32 v3, s0, v3, v68
		ds_read_b32 v69, v3
		ds_read_b32 v70, v3 offset:256
		ds_read_b32 v71, v3 offset:512
		ds_read_b32 v72, v3 offset:768
		v_lshrrev_b32_e32 v3, 6, v0
		v_and_b32_e32 v3, 1, v3
		v_lshlrev_b32_e32 v3, 10, v3
		v_add3_u32 v3, s0, v68, v3
		ds_read_b32 v68, v3 offset:2048
		ds_read_b32 v73, v3 offset:2304
		ds_read_b32 v74, v3 offset:2560
		ds_read_b32 v75, v3 offset:2816
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[8:11], v[4:7], a[0:3], v69, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[76:79], v1 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[8:11], v[40:43], a[4:7], v69, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[80:83], v1 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[8:11], v[44:47], a[8:11], v69, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[84:87], v1 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[8:11], v[48:51], a[12:15], v69, v73 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v1 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[8:11], v[52:55], a[16:19], v69, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v1 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[8:11], v[56:59], a[20:23], v69, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v1 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[8:11], v[60:63], a[24:27], v69, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v1 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[8:11], v[64:67], a[28:31], v69, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[8:11], v1 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[12:15], v[4:7], a[32:35], v69, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[104:107], v2 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[12:15], v[40:43], a[36:39], v69, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[108:111], v2 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[12:15], v[44:47], a[40:43], v69, v73 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[112:115], v2 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[12:15], v[48:51], a[44:47], v69, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[116:119], v2 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[12:15], v[52:55], a[48:51], v69, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[120:123], v2 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[12:15], v[56:59], a[52:55], v69, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[124:127], v2 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[12:15], v[60:63], a[56:59], v69, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[128:131], v2 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[12:15], v[64:67], a[60:63], v69, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[12:15], v2 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[16:19], v[4:7], a[64:67], v70, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[16:19], v[40:43], a[68:71], v70, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[16:19], v[44:47], a[72:75], v70, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[16:19], v[48:51], a[76:79], v70, v73 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[16:19], v[52:55], a[80:83], v70, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[16:19], v[56:59], a[84:87], v70, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[16:19], v[60:63], a[88:91], v70, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[16:19], v[64:67], a[92:95], v70, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[20:23], v[4:7], a[96:99], v70, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[20:23], v[40:43], a[100:103], v70, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[20:23], v[44:47], a[104:107], v70, v73 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[20:23], v[48:51], a[108:111], v70, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[20:23], v[52:55], a[112:115], v70, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[20:23], v[56:59], a[116:119], v70, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[20:23], v[60:63], a[120:123], v70, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[20:23], v[64:67], a[124:127], v70, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[24:27], v[4:7], a[128:131], v71, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[24:27], v[40:43], a[132:135], v71, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[24:27], v[44:47], a[136:139], v71, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[24:27], v[48:51], a[140:143], v71, v73 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[24:27], v[52:55], a[144:147], v71, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[24:27], v[56:59], a[148:151], v71, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[24:27], v[60:63], a[152:155], v71, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[24:27], v[64:67], a[156:159], v71, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[28:31], v[4:7], a[160:163], v71, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[28:31], v[40:43], a[164:167], v71, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[28:31], v[44:47], a[168:171], v71, v73 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[28:31], v[48:51], a[172:175], v71, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[28:31], v[52:55], a[176:179], v71, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[28:31], v[56:59], a[180:183], v71, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[28:31], v[60:63], a[184:187], v71, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[28:31], v[64:67], a[188:191], v71, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[32:35], v[4:7], a[192:195], v72, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[32:35], v[40:43], a[196:199], v72, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[32:35], v[44:47], a[200:203], v72, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[32:35], v[48:51], a[204:207], v72, v73 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[32:35], v[52:55], a[208:211], v72, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[32:35], v[56:59], a[212:215], v72, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[32:35], v[60:63], a[216:219], v72, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[32:35], v[64:67], a[220:223], v72, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[36:39], v[4:7], a[224:227], v72, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[36:39], v[40:43], a[228:231], v72, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[36:39], v[44:47], a[232:235], v72, v73 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[36:39], v[48:51], a[236:239], v72, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[240:243], v[36:39], v[52:55], a[240:243], v72, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[244:247], v[36:39], v[56:59], a[244:247], v72, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[248:251], v[36:39], v[60:63], a[248:251], v72, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[252:255], v[36:39], v[64:67], a[252:255], v72, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[76:79], v[104:107], a[0:3], v69, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[76:79], v[108:111], a[4:7], v69, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[76:79], v[112:115], a[8:11], v69, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[76:79], v[116:119], a[12:15], v69, v73 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[76:79], v[120:123], a[16:19], v69, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[76:79], v[124:127], a[20:23], v69, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[76:79], v[128:131], a[24:27], v69, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[76:79], v[12:15], a[28:31], v69, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[80:83], v[104:107], a[32:35], v69, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[80:83], v[108:111], a[36:39], v69, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[80:83], v[112:115], a[40:43], v69, v73 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[80:83], v[116:119], a[44:47], v69, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[80:83], v[120:123], a[48:51], v69, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[80:83], v[124:127], a[52:55], v69, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[80:83], v[128:131], a[56:59], v69, v75 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[80:83], v[12:15], a[60:63], v69, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[84:87], v[104:107], a[64:67], v70, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[84:87], v[108:111], a[68:71], v70, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[84:87], v[112:115], a[72:75], v70, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[84:87], v[116:119], a[76:79], v70, v73 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[84:87], v[120:123], a[80:83], v70, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[84:87], v[124:127], a[84:87], v70, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[84:87], v[128:131], a[88:91], v70, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[84:87], v[12:15], a[92:95], v70, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[88:91], v[104:107], a[96:99], v70, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[88:91], v[108:111], a[100:103], v70, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[88:91], v[112:115], a[104:107], v70, v73 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[88:91], v[116:119], a[108:111], v70, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[88:91], v[120:123], a[112:115], v70, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[88:91], v[124:127], a[116:119], v70, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[88:91], v[128:131], a[120:123], v70, v75 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[88:91], v[12:15], a[124:127], v70, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[92:95], v[104:107], a[128:131], v71, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[92:95], v[108:111], a[132:135], v71, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[92:95], v[112:115], a[136:139], v71, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[92:95], v[116:119], a[140:143], v71, v73 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[92:95], v[120:123], a[144:147], v71, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[92:95], v[124:127], a[148:151], v71, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[92:95], v[128:131], a[152:155], v71, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[92:95], v[12:15], a[156:159], v71, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[96:99], v[104:107], a[160:163], v71, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[96:99], v[108:111], a[164:167], v71, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[96:99], v[112:115], a[168:171], v71, v73 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[96:99], v[116:119], a[172:175], v71, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[96:99], v[120:123], a[176:179], v71, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[96:99], v[124:127], a[180:183], v71, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[96:99], v[128:131], a[184:187], v71, v75 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[96:99], v[12:15], a[188:191], v71, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[100:103], v[104:107], a[192:195], v72, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[100:103], v[108:111], a[196:199], v72, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[100:103], v[112:115], a[200:203], v72, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[100:103], v[116:119], a[204:207], v72, v73 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[100:103], v[120:123], a[208:211], v72, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[212:215], v[100:103], v[124:127], a[212:215], v72, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[216:219], v[100:103], v[128:131], a[216:219], v72, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[220:223], v[100:103], v[12:15], a[220:223], v72, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[224:227], v[8:11], v[104:107], a[224:227], v72, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[228:231], v[8:11], v[108:111], a[228:231], v72, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[232:235], v[8:11], v[112:115], a[232:235], v72, v73 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[236:239], v[8:11], v[116:119], a[236:239], v72, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
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
		v_lshlrev_b32_e32 v1, 3, v1
		v_lshrrev_b32_e32 v0, 6, v0
		v_lshl_add_u32 v0, v0, 15, v1
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
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen
		v_accvgpr_read_b32 v1, a36
		v_accvgpr_read_b32 v2, a37
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a38
		v_accvgpr_read_b32 v2, a39
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:512
		v_accvgpr_read_b32 v1, a40
		v_accvgpr_read_b32 v2, a41
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a42
		v_accvgpr_read_b32 v2, a43
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1024
		v_accvgpr_read_b32 v1, a44
		v_accvgpr_read_b32 v2, a45
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a46
		v_accvgpr_read_b32 v2, a47
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1536
		v_accvgpr_read_b32 v1, a48
		v_accvgpr_read_b32 v2, a49
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a50
		v_accvgpr_read_b32 v2, a51
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2048
		v_accvgpr_read_b32 v1, a52
		v_accvgpr_read_b32 v2, a53
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a54
		v_accvgpr_read_b32 v2, a55
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2560
		v_accvgpr_read_b32 v1, a56
		v_accvgpr_read_b32 v2, a57
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a58
		v_accvgpr_read_b32 v2, a59
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3072
		v_accvgpr_read_b32 v1, a60
		v_accvgpr_read_b32 v2, a61
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a62
		v_accvgpr_read_b32 v2, a63
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a64
		v_accvgpr_read_b32 v2, a65
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a66
		v_accvgpr_read_b32 v2, a67
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x2000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen
		v_accvgpr_read_b32 v1, a68
		v_accvgpr_read_b32 v2, a69
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a70
		v_accvgpr_read_b32 v2, a71
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:512
		v_accvgpr_read_b32 v1, a72
		v_accvgpr_read_b32 v2, a73
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a74
		v_accvgpr_read_b32 v2, a75
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1024
		v_accvgpr_read_b32 v1, a76
		v_accvgpr_read_b32 v2, a77
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a78
		v_accvgpr_read_b32 v2, a79
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1536
		v_accvgpr_read_b32 v1, a80
		v_accvgpr_read_b32 v2, a81
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a82
		v_accvgpr_read_b32 v2, a83
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2048
		v_accvgpr_read_b32 v1, a84
		v_accvgpr_read_b32 v2, a85
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a86
		v_accvgpr_read_b32 v2, a87
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2560
		v_accvgpr_read_b32 v1, a88
		v_accvgpr_read_b32 v2, a89
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a90
		v_accvgpr_read_b32 v2, a91
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3072
		v_accvgpr_read_b32 v1, a92
		v_accvgpr_read_b32 v2, a93
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a94
		v_accvgpr_read_b32 v2, a95
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a96
		v_accvgpr_read_b32 v2, a97
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a98
		v_accvgpr_read_b32 v2, a99
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x3000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen
		v_accvgpr_read_b32 v1, a100
		v_accvgpr_read_b32 v2, a101
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a102
		v_accvgpr_read_b32 v2, a103
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:512
		v_accvgpr_read_b32 v1, a104
		v_accvgpr_read_b32 v2, a105
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a106
		v_accvgpr_read_b32 v2, a107
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1024
		v_accvgpr_read_b32 v1, a108
		v_accvgpr_read_b32 v2, a109
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a110
		v_accvgpr_read_b32 v2, a111
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1536
		v_accvgpr_read_b32 v1, a112
		v_accvgpr_read_b32 v2, a113
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a114
		v_accvgpr_read_b32 v2, a115
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2048
		v_accvgpr_read_b32 v1, a116
		v_accvgpr_read_b32 v2, a117
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a118
		v_accvgpr_read_b32 v2, a119
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2560
		v_accvgpr_read_b32 v1, a120
		v_accvgpr_read_b32 v2, a121
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a122
		v_accvgpr_read_b32 v2, a123
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3072
		v_accvgpr_read_b32 v1, a124
		v_accvgpr_read_b32 v2, a125
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a126
		v_accvgpr_read_b32 v2, a127
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a128
		v_accvgpr_read_b32 v2, a129
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a130
		v_accvgpr_read_b32 v2, a131
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x4000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen
		v_accvgpr_read_b32 v1, a132
		v_accvgpr_read_b32 v2, a133
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a134
		v_accvgpr_read_b32 v2, a135
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:512
		v_accvgpr_read_b32 v1, a136
		v_accvgpr_read_b32 v2, a137
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a138
		v_accvgpr_read_b32 v2, a139
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1024
		v_accvgpr_read_b32 v1, a140
		v_accvgpr_read_b32 v2, a141
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a142
		v_accvgpr_read_b32 v2, a143
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1536
		v_accvgpr_read_b32 v1, a144
		v_accvgpr_read_b32 v2, a145
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a146
		v_accvgpr_read_b32 v2, a147
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2048
		v_accvgpr_read_b32 v1, a148
		v_accvgpr_read_b32 v2, a149
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a150
		v_accvgpr_read_b32 v2, a151
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2560
		v_accvgpr_read_b32 v1, a152
		v_accvgpr_read_b32 v2, a153
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a154
		v_accvgpr_read_b32 v2, a155
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3072
		v_accvgpr_read_b32 v1, a156
		v_accvgpr_read_b32 v2, a157
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a158
		v_accvgpr_read_b32 v2, a159
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a160
		v_accvgpr_read_b32 v2, a161
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a162
		v_accvgpr_read_b32 v2, a163
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x5000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen
		v_accvgpr_read_b32 v1, a164
		v_accvgpr_read_b32 v2, a165
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a166
		v_accvgpr_read_b32 v2, a167
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:512
		v_accvgpr_read_b32 v1, a168
		v_accvgpr_read_b32 v2, a169
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a170
		v_accvgpr_read_b32 v2, a171
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1024
		v_accvgpr_read_b32 v1, a172
		v_accvgpr_read_b32 v2, a173
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a174
		v_accvgpr_read_b32 v2, a175
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1536
		v_accvgpr_read_b32 v1, a176
		v_accvgpr_read_b32 v2, a177
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a178
		v_accvgpr_read_b32 v2, a179
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2048
		v_accvgpr_read_b32 v1, a180
		v_accvgpr_read_b32 v2, a181
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a182
		v_accvgpr_read_b32 v2, a183
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2560
		v_accvgpr_read_b32 v1, a184
		v_accvgpr_read_b32 v2, a185
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a186
		v_accvgpr_read_b32 v2, a187
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3072
		v_accvgpr_read_b32 v1, a188
		v_accvgpr_read_b32 v2, a189
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a190
		v_accvgpr_read_b32 v2, a191
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a192
		v_accvgpr_read_b32 v2, a193
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a194
		v_accvgpr_read_b32 v2, a195
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x6000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen
		v_accvgpr_read_b32 v1, a196
		v_accvgpr_read_b32 v2, a197
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a198
		v_accvgpr_read_b32 v2, a199
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:512
		v_accvgpr_read_b32 v1, a200
		v_accvgpr_read_b32 v2, a201
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a202
		v_accvgpr_read_b32 v2, a203
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1024
		v_accvgpr_read_b32 v1, a204
		v_accvgpr_read_b32 v2, a205
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a206
		v_accvgpr_read_b32 v2, a207
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:1536
		v_accvgpr_read_b32 v1, a208
		v_accvgpr_read_b32 v2, a209
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a210
		v_accvgpr_read_b32 v2, a211
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2048
		v_accvgpr_read_b32 v1, a212
		v_accvgpr_read_b32 v2, a213
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a214
		v_accvgpr_read_b32 v2, a215
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:2560
		v_accvgpr_read_b32 v1, a216
		v_accvgpr_read_b32 v2, a217
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a218
		v_accvgpr_read_b32 v2, a219
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3072
		v_accvgpr_read_b32 v1, a220
		v_accvgpr_read_b32 v2, a221
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a222
		v_accvgpr_read_b32 v2, a223
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a224
		v_accvgpr_read_b32 v2, a225
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a226
		v_accvgpr_read_b32 v2, a227
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s0, s0, 0x7000
		s_add_i32 s0, s0, s1
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
		.amdhsa_private_segment_fixed_size 184
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
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 184
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
    .private_segment_fixed_size: 184
    .sgpr_count:     64
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     512
    .agpr_count:     256
    .vgpr_spill_count: 46
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 104
    wave.regalloc.agpr.dwords: 256
    wave.regalloc.remat.dwords: 20
    wave.regalloc.lds.dwords: 24
    wave.regalloc.scratch.dwords: 46
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
