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
		s_lshr_b32 s8, s4, 6
		v_readfirstlane_b32 s5, v0
		s_lshl_b32 s9, s13, 20
		s_lshl_b32 s10, s8, 16
		s_add_i32 s11, s9, s10
		v_and_b32_e32 v1, 63, v0
		v_lshrrev_b32_e32 v2, 2, v1
		v_lshlrev_b32_e32 v2, 12, v2
		v_lshrrev_b32_e32 v3, 3, v1
		v_bitop3_b32 v3, v3, 3, v1 bitop3:0x48
		v_lshlrev_b32_e32 v3, 4, v3
		v_add3_u32 v4, s11, v2, v3
		s_add_i32 s16, s11, 0x40000
		s_add_i32 s17, s11, 0x80000
		s_add_i32 s19, s11, 0xc0000
		s_add_i32 s32, s11, 64
		s_add_i32 s33, s11, 0x40040
		s_add_i32 s34, s11, 0x80040
		s_add_i32 s35, s11, 0xc0040
		s_lshl_b32 s36, s14, 20
		s_add_i32 s10, s36, s10
		s_add_i32 s36, s10, 0x40000
		s_add_i32 s37, s10, 0x80000
		s_add_i32 s38, s10, 0xc0000
		s_add_i32 s39, s10, 64
		s_add_i32 s40, s10, 0x40040
		s_add_i32 s41, s10, 0x80040
		s_add_i32 s42, s10, 0xc0040
		s_lshr_b32 s43, s5, 6
		s_lshl_b32 s44, s43, 10
		s_and_b32 s45, s8, 1
		s_lshl_b32 s46, s45, 13
		v_and_b32_e32 v5, 15, v0
		v_lshlrev_b32_e32 v6, 6, v5
		v_lshrrev_b32_e32 v7, 4, v1
		v_lshrrev_b32_e32 v5, 1, v5
		v_bitop3_b32 v5, v7, v5, 3 bitop3:0x78
		v_lshlrev_b32_e32 v5, 4, v5
		s_mov_b32 m0, s44
		v_mov_b64_e32 v[8:9], 0
		v_mov_b64_e32 v[10:11], 0
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		v_add3_u32 v4, s16, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v7, s17, v2, v3
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		v_add3_u32 v4, s19, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v12, s32, v2, v3
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		v_add3_u32 v7, s33, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v13, s34, v2, v3
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		v_add3_u32 v4, s35, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v14, s10, v2, v3
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		v_add3_u32 v12, s36, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v15, s37, v2, v3
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		v_add3_u32 v7, s38, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v16, s39, v2, v3
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		v_add3_u32 v13, s40, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v17, s41, v2, v3
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		v_add3_u32 v4, s42, v2, v3
		s_add_i32 m0, m0, 0x9000
		s_nop 0
		buffer_load_dwordx4 v14, s[0:3], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s16, 0x800
		s_mov_b32 s17, 0
		buffer_load_dwordx4 v12, s[0:3], 0 offen lds
		s_mov_b32 s32, 0x400
		s_mov_b32 s33, 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b32_e32 v18, s14
		buffer_load_dwordx4 v15, s[0:3], 0 offen lds
		s_mov_b32 s34, 0x80
		s_mov_b32 s35, 0
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s36, 16
		s_mov_b32 s37, 0
		buffer_load_dwordx4 v7, s[0:3], 0 offen lds
		v_mov_b32_e32 v7, 3
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s38, 0x1000
		s_mov_b32 s39, 0
		buffer_load_dwordx4 v16, s[0:3], 0 offen lds
		v_mov_b32_e32 v12, 63
		s_add_i32 m0, m0, 0x1000
		s_lshl_b32 s19, s45, 10
		buffer_load_dwordx4 v13, s[0:3], 0 offen lds
		s_add_i32 s40, s46, 0x10000
		s_add_i32 m0, m0, 0x1000
		s_and_b32 s41, s43, 1
		buffer_load_dwordx4 v17, s[0:3], 0 offen lds
		s_lshr_b32 s42, s8, 1
		s_add_i32 m0, m0, 0x1000
		s_lshl_b32 s43, s14, 16
		buffer_load_dwordx4 v4, s[0:3], 0 offen lds
		s_add_i32 s43, s9, s43
		s_lshl_b32 s45, s42, 10
		s_add_i32 s47, s43, s45
		s_lshr_b32 s5, s5, 7
		s_lshl_b32 s5, s5, 10
		v_and_b32_e32 v4, 0x7f, v0
		s_lshl_b32 s41, s41, 10
		s_add_i32 m0, s5, 0x20000
		v_lshl_add_u32 v13, v1, 4, s47
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		v_lshl_add_u32 v13, v4, 4, s43
		s_add_i32 m0, s41, 0x21000
		s_lshl_b32 s48, s42, 13
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		v_add3_u32 v13, s48, v6, v5
		ds_read_b128 a[0:3], v13
		ds_read_b128 a[4:7], v13 offset:1024
		ds_read_b128 a[8:11], v13 offset:2048
		ds_read_b128 a[12:15], v13 offset:3072
		ds_read_b128 v[20:23], v13 offset:4096
		ds_read_b128 v[24:27], v13 offset:5120
		ds_read_b128 v[28:31], v13 offset:6144
		ds_read_b128 v[32:35], v13 offset:7168
		v_add3_u32 v13, s40, v6, v5
		ds_read_b128 v[36:39], v13
		ds_read_b128 v[40:43], v13 offset:1024
		ds_read_b128 v[44:47], v13 offset:2048
		ds_read_b128 v[48:51], v13 offset:3072
		ds_read_b128 v[52:55], v13 offset:4096
		ds_read_b128 v[56:59], v13 offset:5120
		ds_read_b128 v[60:63], v13 offset:6144
		ds_read_b128 v[64:67], v13 offset:7168
		s_add_i32 s9, s45, 0x20000
		v_lshl_add_u32 v13, v1, 2, s9
		ds_read_b32 v14, v13
		ds_read_b32 v15, v13 offset:256
		ds_read_b32 v16, v13 offset:512
		ds_read_b32 v17, v13 offset:768
		s_add_i32 s9, s19, 0x20000
		v_lshl_add_u32 v13, v1, 2, s9
		ds_read_b32 v68, v13 offset:4096
		ds_read_b32 v69, v13 offset:4352
		ds_read_b32 v70, v13 offset:4608
		ds_read_b32 v71, v13 offset:4864
		s_add_i32 s9, s11, 0x80
		v_add3_u32 v13, s9, v2, v3
		s_add_i32 s9, s11, 0x40080
		s_add_i32 s40, s11, 0x80080
		s_add_i32 s49, s11, 0xc0080
		s_add_i32 s50, s11, 0xc0
		s_add_i32 s51, s11, 0x400c0
		s_add_i32 s52, s11, 0x800c0
		s_add_i32 s11, s11, 0xc00c0
		s_add_i32 s53, s10, 0x80
		s_add_i32 s54, s10, 0x40080
		s_add_i32 s55, s10, 0x80080
		s_add_i32 s56, s10, 0xc0080
		s_add_i32 s57, s10, 0xc0
		s_add_i32 s58, s10, 0x400c0
		s_add_i32 s59, s10, 0x800c0
		s_add_i32 s10, s10, 0xc00c0
		s_add_i32 m0, s44, 0x8000
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		v_add3_u32 v13, s9, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v19, s40, v2, v3
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		v_add3_u32 v13, s49, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v72, s50, v2, v3
		buffer_load_dwordx4 v19, s[20:23], 0 offen lds
		v_add3_u32 v19, s51, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v73, s52, v2, v3
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		v_add3_u32 v13, s11, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v74, s53, v2, v3
		buffer_load_dwordx4 v72, s[20:23], 0 offen lds
		v_add3_u32 v72, s54, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v75, s55, v2, v3
		buffer_load_dwordx4 v19, s[20:23], 0 offen lds
		v_add3_u32 v19, s56, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v76, s57, v2, v3
		buffer_load_dwordx4 v73, s[20:23], 0 offen lds
		v_add3_u32 v73, s58, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v77, s59, v2, v3
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		v_add3_u32 v2, s10, v2, v3
		s_add_i32 m0, m0, 0x9000
		s_add_i32 s10, s44, 0x8000
		buffer_load_dwordx4 v74, s[0:3], 0 offen lds
		v_mov_b32_e32 v3, v0
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s50, 1
		s_mov_b32 s51, 0
		buffer_load_dwordx4 v72, s[0:3], 0 offen lds
		s_mov_b32 s52, 0x100000
		s_mov_b32 s53, 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b32_e32 v79, 0
		buffer_load_dwordx4 v75, s[0:3], 0 offen lds
		v_mov_b32_e32 v78, s13
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s54, 0x10000
		s_mov_b32 s55, 0
		buffer_load_dwordx4 v19, s[0:3], 0 offen lds
		s_mov_b32 s9, 0
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s11, 2
		buffer_load_dwordx4 v76, s[0:3], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v73, s[0:3], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s40, s46, 0x4000
		buffer_load_dwordx4 v77, s[0:3], 0 offen lds
		s_add_i32 s49, s48, 0x4000
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s56, s12, 1
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_add_i32 s47, s47, 0x800
		s_add_i32 s43, s43, 0x800
		s_add_i32 s57, s41, 0x800
		s_add_i32 m0, s5, 0x20800
		v_lshl_add_u32 v1, v1, 4, s47
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		s_add_i32 s47, s5, 0x800
		s_add_i32 m0, s41, 0x21800
		v_lshl_add_u32 v1, v4, 4, s43
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		v_add3_u32 v1, s49, v6, v5
		v_add3_u32 v2, s40, v6, v5
		s_mul_i32 s58, s54, s8
		s_mul_hi_u32 s59, s54, s8
		s_mul_i32 s40, s54, s9
		s_add_i32 s59, s59, s40
		s_mul_i32 s40, s55, s8
		s_add_i32 s59, s59, s40
		v_mov_b32_e32 v4, s52
		v_mov_b32_e32 v5, s53
		v_mul_lo_u32 v72, v4, v78
		v_mul_hi_u32 v73, v4, v78
		v_mul_lo_u32 v6, v4, v79
		v_add_u32_e32 v73, v73, v6
		v_mul_lo_u32 v6, v5, v78
		v_add_u32_e32 v73, v73, v6
		v_mov_b32_e32 v74, s58
		v_mov_b32_e32 v75, s59
		v_add_co_u32_e64 v76, vcc, v74, v72
		v_addc_co_u32_e64 v77, vcc, v75, v73, vcc
		v_and_b32_e32 v80, v3, v12
		v_and_b32_e32 v81, v79, v79
		v_mov_b32_e32 v12, s50
		v_mov_b32_e32 v13, s51
		v_mul_lo_u32 v82, v12, v80
		v_mul_hi_u32 v83, v12, v80
		v_mul_lo_u32 v6, v12, v81
		v_add_u32_e32 v83, v83, v6
		v_mul_lo_u32 v6, v13, v80
		v_add_u32_e32 v83, v83, v6
		v_lshrrev_b64 v[12:13], 2, v[82:83]
		v_mov_b32_e32 v84, s38
		v_mov_b32_e32 v85, s39
		v_mul_lo_u32 v86, v84, v12
		v_mul_hi_u32 v87, v84, v12
		v_mul_lo_u32 v6, v84, v13
		v_add_u32_e32 v87, v87, v6
		v_mul_lo_u32 v6, v85, v12
		v_add_u32_e32 v87, v87, v6
		v_add_co_u32_e64 v12, vcc, v76, v86
		v_addc_co_u32_e64 v13, vcc, v77, v87, vcc
		v_lshrrev_b64 v[76:77], 3, v[82:83]
		v_and_b32_e32 v82, v76, v7
		v_and_b32_e32 v83, v77, v79
		v_and_b32_e32 v76, v80, v7
		v_and_b32_e32 v77, v81, v79
		v_xor_b32_e32 v6, v82, v76
		v_xor_b32_e32 v7, v83, v77
		v_mov_b32_e32 v76, s36
		v_mov_b32_e32 v77, s37
		v_mul_lo_u32 v78, v76, v6
		v_mul_hi_u32 v79, v76, v6
		v_mul_lo_u32 v19, v76, v7
		v_add_u32_e32 v79, v79, v19
		v_mul_lo_u32 v19, v77, v6
		v_add_u32_e32 v79, v79, v19
		v_add_co_u32_e64 v6, vcc, v12, v78
		v_addc_co_u32_e64 v7, vcc, v13, v79, vcc
		v_mov_b32_e32 v12, s34
		v_mov_b32_e32 v13, s35
		s_add_u32 s34, s58, 0x40000
		s_addc_u32 s35, s59, 0
		v_mov_b32_e32 v82, s34
		v_mov_b32_e32 v83, s35
		v_add_co_u32_e64 v84, vcc, v82, v72
		v_addc_co_u32_e64 v85, vcc, v83, v73, vcc
		v_add_co_u32_e64 v88, vcc, v84, v86
		v_addc_co_u32_e64 v89, vcc, v85, v87, vcc
		v_add_co_u32_e64 v84, vcc, v88, v78
		v_addc_co_u32_e64 v85, vcc, v89, v79, vcc
		s_add_u32 s34, s58, 0x80000
		s_addc_u32 s35, s59, 0
		v_mov_b32_e32 v88, s34
		v_mov_b32_e32 v89, s35
		v_add_co_u32_e64 v90, vcc, v88, v72
		v_addc_co_u32_e64 v91, vcc, v89, v73, vcc
		v_add_co_u32_e64 v92, vcc, v90, v86
		v_addc_co_u32_e64 v93, vcc, v91, v87, vcc
		v_add_co_u32_e64 v90, vcc, v92, v78
		v_addc_co_u32_e64 v91, vcc, v93, v79, vcc
		s_add_u32 s34, s58, 0xc0000
		s_addc_u32 s35, s59, 0
		v_mov_b32_e32 v92, s34
		v_mov_b32_e32 v93, s35
		v_add_co_u32_e64 v94, vcc, v92, v72
		v_addc_co_u32_e64 v95, vcc, v93, v73, vcc
		v_add_co_u32_e64 v96, vcc, v94, v86
		v_addc_co_u32_e64 v97, vcc, v95, v87, vcc
		v_add_co_u32_e64 v94, vcc, v96, v78
		v_addc_co_u32_e64 v95, vcc, v97, v79, vcc
		s_add_u32 s34, s58, 64
		s_addc_u32 s35, s59, 0
		v_mov_b32_e32 v96, s34
		v_mov_b32_e32 v97, s35
		v_add_co_u32_e64 v98, vcc, v96, v72
		v_addc_co_u32_e64 v99, vcc, v97, v73, vcc
		v_add_co_u32_e64 v100, vcc, v98, v86
		v_addc_co_u32_e64 v101, vcc, v99, v87, vcc
		v_add_co_u32_e64 v98, vcc, v100, v78
		v_addc_co_u32_e64 v99, vcc, v101, v79, vcc
		s_add_u32 s34, s58, 0x40040
		s_addc_u32 s35, s59, 0
		v_mov_b32_e32 v100, s34
		v_mov_b32_e32 v101, s35
		v_add_co_u32_e64 v102, vcc, v100, v72
		v_addc_co_u32_e64 v103, vcc, v101, v73, vcc
		v_add_co_u32_e64 v104, vcc, v102, v86
		v_addc_co_u32_e64 v105, vcc, v103, v87, vcc
		v_add_co_u32_e64 v102, vcc, v104, v78
		v_addc_co_u32_e64 v103, vcc, v105, v79, vcc
		s_add_u32 s34, s58, 0x80040
		s_addc_u32 s35, s59, 0
		v_mov_b32_e32 v104, s34
		v_mov_b32_e32 v105, s35
		v_add_co_u32_e64 v106, vcc, v104, v72
		v_addc_co_u32_e64 v107, vcc, v105, v73, vcc
		v_add_co_u32_e64 v108, vcc, v106, v86
		v_addc_co_u32_e64 v109, vcc, v107, v87, vcc
		v_add_co_u32_e64 v106, vcc, v108, v78
		v_addc_co_u32_e64 v107, vcc, v109, v79, vcc
		s_add_u32 s34, s58, 0xc0040
		s_addc_u32 s35, s59, 0
		v_mov_b32_e32 v108, s34
		v_mov_b32_e32 v109, s35
		v_add_co_u32_e64 v110, vcc, v108, v72
		v_addc_co_u32_e64 v111, vcc, v109, v73, vcc
		v_add_co_u32_e64 v112, vcc, v110, v86
		v_addc_co_u32_e64 v113, vcc, v111, v87, vcc
		v_add_co_u32_e64 v110, vcc, v112, v78
		v_addc_co_u32_e64 v111, vcc, v113, v79, vcc
		v_mov_b32_e32 v19, 0
		v_mul_lo_u32 v112, v4, v18
		v_mul_hi_u32 v113, v4, v18
		v_mul_lo_u32 v114, v4, v19
		v_add_u32_e32 v113, v113, v114
		v_mul_lo_u32 v114, v5, v18
		v_add_u32_e32 v113, v113, v114
		v_add_co_u32_e64 v4, vcc, v74, v112
		v_addc_co_u32_e64 v5, vcc, v75, v113, vcc
		v_add_co_u32_e64 v74, vcc, v4, v86
		v_addc_co_u32_e64 v75, vcc, v5, v87, vcc
		v_add_co_u32_e64 v4, vcc, v74, v78
		v_addc_co_u32_e64 v5, vcc, v75, v79, vcc
		v_add_co_u32_e64 v74, vcc, v82, v112
		v_addc_co_u32_e64 v75, vcc, v83, v113, vcc
		v_add_co_u32_e64 v82, vcc, v74, v86
		v_addc_co_u32_e64 v83, vcc, v75, v87, vcc
		v_add_co_u32_e64 v74, vcc, v82, v78
		v_addc_co_u32_e64 v75, vcc, v83, v79, vcc
		v_add_co_u32_e64 v82, vcc, v88, v112
		v_addc_co_u32_e64 v83, vcc, v89, v113, vcc
		v_add_co_u32_e64 v88, vcc, v82, v86
		v_addc_co_u32_e64 v89, vcc, v83, v87, vcc
		v_add_co_u32_e64 v82, vcc, v88, v78
		v_addc_co_u32_e64 v83, vcc, v89, v79, vcc
		v_add_co_u32_e64 v88, vcc, v92, v112
		v_addc_co_u32_e64 v89, vcc, v93, v113, vcc
		v_add_co_u32_e64 v92, vcc, v88, v86
		v_addc_co_u32_e64 v93, vcc, v89, v87, vcc
		v_add_co_u32_e64 v88, vcc, v92, v78
		v_addc_co_u32_e64 v89, vcc, v93, v79, vcc
		v_add_co_u32_e64 v92, vcc, v96, v112
		v_addc_co_u32_e64 v93, vcc, v97, v113, vcc
		v_add_co_u32_e64 v96, vcc, v92, v86
		v_addc_co_u32_e64 v97, vcc, v93, v87, vcc
		v_add_co_u32_e64 v92, vcc, v96, v78
		v_addc_co_u32_e64 v93, vcc, v97, v79, vcc
		v_add_co_u32_e64 v96, vcc, v100, v112
		v_addc_co_u32_e64 v97, vcc, v101, v113, vcc
		v_add_co_u32_e64 v100, vcc, v96, v86
		v_addc_co_u32_e64 v101, vcc, v97, v87, vcc
		v_add_co_u32_e64 v96, vcc, v100, v78
		v_addc_co_u32_e64 v97, vcc, v101, v79, vcc
		v_add_co_u32_e64 v100, vcc, v104, v112
		v_addc_co_u32_e64 v101, vcc, v105, v113, vcc
		v_add_co_u32_e64 v104, vcc, v100, v86
		v_addc_co_u32_e64 v105, vcc, v101, v87, vcc
		v_add_co_u32_e64 v100, vcc, v104, v78
		v_addc_co_u32_e64 v101, vcc, v105, v79, vcc
		v_add_co_u32_e64 v104, vcc, v108, v112
		v_addc_co_u32_e64 v105, vcc, v109, v113, vcc
		v_add_co_u32_e64 v108, vcc, v104, v86
		v_addc_co_u32_e64 v109, vcc, v105, v87, vcc
		v_add_co_u32_e64 v104, vcc, v108, v78
		v_addc_co_u32_e64 v105, vcc, v109, v79, vcc
		s_mov_b32 s43, s9
		s_mul_i32 s34, s32, s42
		s_mul_hi_u32 s35, s32, s42
		s_mul_i32 s9, s32, s43
		s_add_i32 s35, s35, s9
		s_mul_i32 s9, s33, s42
		s_add_i32 s35, s35, s9
		v_mov_b32_e32 v108, s34
		v_mov_b32_e32 v109, s35
		v_add_co_u32_e64 v114, vcc, v108, v72
		v_addc_co_u32_e64 v115, vcc, v109, v73, vcc
		v_mov_b32_e32 v108, s54
		v_mov_b32_e32 v109, s55
		v_mul_lo_u32 v116, v108, v18
		v_mul_hi_u32 v117, v108, v18
		v_mul_lo_u32 v118, v108, v19
		v_add_u32_e32 v117, v117, v118
		v_mul_lo_u32 v118, v109, v18
		v_add_u32_e32 v117, v117, v118
		v_add_co_u32_e64 v18, vcc, v114, v116
		v_addc_co_u32_e64 v19, vcc, v115, v117, vcc
		v_mul_lo_u32 v108, v76, v80
		v_mul_hi_u32 v109, v76, v80
		v_mul_lo_u32 v114, v76, v81
		v_add_u32_e32 v109, v109, v114
		v_mul_lo_u32 v114, v77, v80
		v_add_u32_e32 v109, v109, v114
		v_add_co_u32_e64 v114, vcc, v18, v108
		v_addc_co_u32_e64 v115, vcc, v19, v109, vcc
		v_mov_b32_e32 v18, s16
		v_mov_b32_e32 v19, s17
		v_add_co_u32_e64 v118, vcc, v72, v116
		v_addc_co_u32_e64 v119, vcc, v73, v117, vcc
		v_mov_b32_e32 v80, 0x7f
		v_and_b32_e32 v120, v3, v80
		v_mov_b32_e32 v121, v81
		v_mul_lo_u32 v80, v76, v120
		v_mul_hi_u32 v81, v76, v120
		v_mul_lo_u32 v3, v76, v121
		v_add_u32_e32 v81, v81, v3
		v_mul_lo_u32 v3, v77, v120
		v_add_u32_e32 v81, v81, v3
		v_add_co_u32_e64 v76, vcc, v118, v80
		v_addc_co_u32_e64 v77, vcc, v119, v81, vcc
		v_add_u32_e32 v2, 0x10000, v2
		s_add_u32 s16, s58, 0x80
		s_addc_u32 s17, s59, 0
		v_mov_b32_e32 v118, s16
		v_mov_b32_e32 v119, s17
		v_add_co_u32_e64 v120, vcc, v118, v72
		v_addc_co_u32_e64 v121, vcc, v119, v73, vcc
		v_add_co_u32_e64 v122, vcc, v120, v86
		v_addc_co_u32_e64 v123, vcc, v121, v87, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v120, vcc, v122, v78
		v_addc_co_u32_e64 v121, vcc, v123, v79, vcc
		ds_write_addtid_b32 v120
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v121 offset:1024
		s_add_u32 s16, s58, 0x40080
		s_addc_u32 s17, s59, 0
		v_mov_b32_e32 v120, s16
		v_mov_b32_e32 v121, s17
		v_add_co_u32_e64 v122, vcc, v120, v72
		v_addc_co_u32_e64 v123, vcc, v121, v73, vcc
		v_add_co_u32_e64 v124, vcc, v122, v86
		v_addc_co_u32_e64 v125, vcc, v123, v87, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v122, vcc, v124, v78
		v_addc_co_u32_e64 v123, vcc, v125, v79, vcc
		ds_write_addtid_b32 v122 offset:2048
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v123 offset:3072
		s_add_u32 s16, s58, 0x80080
		s_addc_u32 s17, s59, 0
		v_mov_b32_e32 v122, s16
		v_mov_b32_e32 v123, s17
		v_add_co_u32_e64 v124, vcc, v122, v72
		v_addc_co_u32_e64 v125, vcc, v123, v73, vcc
		v_add_co_u32_e64 v126, vcc, v124, v86
		v_addc_co_u32_e64 v127, vcc, v125, v87, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v124, vcc, v126, v78
		v_addc_co_u32_e64 v125, vcc, v127, v79, vcc
		ds_write_addtid_b32 v124 offset:4096
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v125 offset:5120
		s_add_u32 s16, s58, 0xc0080
		s_addc_u32 s17, s59, 0
		v_mov_b32_e32 v124, s16
		v_mov_b32_e32 v125, s17
		v_add_co_u32_e64 v126, vcc, v124, v72
		v_addc_co_u32_e64 v127, vcc, v125, v73, vcc
		v_add_co_u32_e64 v128, vcc, v126, v86
		v_addc_co_u32_e64 v129, vcc, v127, v87, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v126, vcc, v128, v78
		v_addc_co_u32_e64 v127, vcc, v129, v79, vcc
		ds_write_addtid_b32 v126 offset:6144
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v127 offset:7168
		s_add_u32 s16, s58, 0xc0
		s_addc_u32 s17, s59, 0
		v_mov_b32_e32 v126, s16
		v_mov_b32_e32 v127, s17
		v_add_co_u32_e64 v128, vcc, v126, v72
		v_addc_co_u32_e64 v129, vcc, v127, v73, vcc
		v_add_co_u32_e64 v130, vcc, v128, v86
		v_addc_co_u32_e64 v131, vcc, v129, v87, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v128, vcc, v130, v78
		v_addc_co_u32_e64 v129, vcc, v131, v79, vcc
		ds_write_addtid_b32 v128 offset:8192
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v129 offset:9216
		s_add_u32 s16, s58, 0x400c0
		s_addc_u32 s17, s59, 0
		v_mov_b32_e32 v128, s16
		v_mov_b32_e32 v129, s17
		v_add_co_u32_e64 v130, vcc, v128, v72
		v_addc_co_u32_e64 v131, vcc, v129, v73, vcc
		v_add_co_u32_e64 v132, vcc, v130, v86
		v_addc_co_u32_e64 v133, vcc, v131, v87, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v130, vcc, v132, v78
		v_addc_co_u32_e64 v131, vcc, v133, v79, vcc
		ds_write_addtid_b32 v130 offset:10240
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v131 offset:11264
		s_add_u32 s16, s58, 0x800c0
		s_addc_u32 s17, s59, 0
		v_mov_b32_e32 v130, s16
		v_mov_b32_e32 v131, s17
		v_add_co_u32_e64 v132, vcc, v130, v72
		v_addc_co_u32_e64 v133, vcc, v131, v73, vcc
		v_add_co_u32_e64 v134, vcc, v132, v86
		v_addc_co_u32_e64 v135, vcc, v133, v87, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v132, vcc, v134, v78
		v_addc_co_u32_e64 v133, vcc, v135, v79, vcc
		ds_write_addtid_b32 v132 offset:12288
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v133 offset:13312
		s_add_u32 s16, s58, 0xc00c0
		s_addc_u32 s17, s59, 0
		v_mov_b32_e32 v132, s16
		v_mov_b32_e32 v133, s17
		v_add_co_u32_e64 v134, vcc, v132, v72
		v_addc_co_u32_e64 v135, vcc, v133, v73, vcc
		v_add_co_u32_e64 v136, vcc, v134, v86
		v_addc_co_u32_e64 v137, vcc, v135, v87, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v134, vcc, v136, v78
		v_addc_co_u32_e64 v135, vcc, v137, v79, vcc
		ds_write_addtid_b32 v134 offset:14336
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v135 offset:15360
		v_add_co_u32_e64 v134, vcc, v118, v112
		v_addc_co_u32_e64 v135, vcc, v119, v113, vcc
		v_add_co_u32_e64 v118, vcc, v134, v86
		v_addc_co_u32_e64 v119, vcc, v135, v87, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v134, vcc, v118, v78
		v_addc_co_u32_e64 v135, vcc, v119, v79, vcc
		ds_write_addtid_b32 v134 offset:16384
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v135 offset:17408
		v_add_co_u32_e64 v118, vcc, v120, v112
		v_addc_co_u32_e64 v119, vcc, v121, v113, vcc
		v_add_co_u32_e64 v120, vcc, v118, v86
		v_addc_co_u32_e64 v121, vcc, v119, v87, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v118, vcc, v120, v78
		v_addc_co_u32_e64 v119, vcc, v121, v79, vcc
		ds_write_addtid_b32 v118 offset:18432
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v119 offset:19456
		v_add_co_u32_e64 v118, vcc, v122, v112
		v_addc_co_u32_e64 v119, vcc, v123, v113, vcc
		v_add_co_u32_e64 v120, vcc, v118, v86
		v_addc_co_u32_e64 v121, vcc, v119, v87, vcc
		v_add_co_u32_e64 v118, vcc, v120, v78
		v_addc_co_u32_e64 v119, vcc, v121, v79, vcc
		v_add_co_u32_e64 v120, vcc, v124, v112
		v_addc_co_u32_e64 v121, vcc, v125, v113, vcc
		v_add_co_u32_e64 v122, vcc, v120, v86
		v_addc_co_u32_e64 v123, vcc, v121, v87, vcc
		v_add_co_u32_e64 v120, vcc, v122, v78
		v_addc_co_u32_e64 v121, vcc, v123, v79, vcc
		v_add_co_u32_e64 v122, vcc, v126, v112
		v_addc_co_u32_e64 v123, vcc, v127, v113, vcc
		v_add_co_u32_e64 v124, vcc, v122, v86
		v_addc_co_u32_e64 v125, vcc, v123, v87, vcc
		v_add_co_u32_e64 v122, vcc, v124, v78
		v_addc_co_u32_e64 v123, vcc, v125, v79, vcc
		v_add_co_u32_e64 v124, vcc, v128, v112
		v_addc_co_u32_e64 v125, vcc, v129, v113, vcc
		v_add_co_u32_e64 v126, vcc, v124, v86
		v_addc_co_u32_e64 v127, vcc, v125, v87, vcc
		v_add_co_u32_e64 v124, vcc, v126, v78
		v_addc_co_u32_e64 v125, vcc, v127, v79, vcc
		v_add_co_u32_e64 v126, vcc, v130, v112
		v_addc_co_u32_e64 v127, vcc, v131, v113, vcc
		v_add_co_u32_e64 v128, vcc, v126, v86
		v_addc_co_u32_e64 v129, vcc, v127, v87, vcc
		v_add_co_u32_e64 v126, vcc, v128, v78
		v_addc_co_u32_e64 v127, vcc, v129, v79, vcc
		v_add_co_u32_e64 v128, vcc, v132, v112
		v_addc_co_u32_e64 v129, vcc, v133, v113, vcc
		v_add_co_u32_e64 v112, vcc, v128, v86
		v_addc_co_u32_e64 v113, vcc, v129, v87, vcc
		v_add_co_u32_e64 v86, vcc, v112, v78
		v_addc_co_u32_e64 v87, vcc, v113, v79, vcc
		s_add_u32 s16, s34, 0x800
		s_addc_u32 s17, s35, 0
		v_mov_b32_e32 v78, s16
		v_mov_b32_e32 v79, s17
		v_add_co_u32_e64 v112, vcc, v78, v72
		v_addc_co_u32_e64 v113, vcc, v79, v73, vcc
		v_add_co_u32_e64 v78, vcc, v112, v116
		v_addc_co_u32_e64 v79, vcc, v113, v117, vcc
		v_add_co_u32_e64 v112, vcc, v78, v108
		v_addc_co_u32_e64 v113, vcc, v79, v109, vcc
		v_mov_b32_e32 v3, 0x800
		v_add_co_u32_e64 v78, vcc, v72, v3
		v_addc_co_u32_e64 v79, vcc, v73, 0, vcc
		v_add_co_u32_e64 v72, vcc, v78, v116
		v_addc_co_u32_e64 v73, vcc, v79, v117, vcc
		v_add_co_u32_e64 v78, vcc, v72, v80
		v_addc_co_u32_e64 v79, vcc, v73, v81, vcc
		v_mov_b32_e32 v72, s11
		v_mov_b32_e32 v73, 0
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
		v_accvgpr_write_b32 a16, 0
		v_accvgpr_write_b32 a17, 0
		v_accvgpr_write_b32 a18, 0
		v_accvgpr_write_b32 a19, 0
		v_accvgpr_write_b32 a20, 0
		v_accvgpr_write_b32 a21, 0
		v_accvgpr_write_b32 a22, 0
		v_accvgpr_write_b32 a23, 0
		v_accvgpr_write_b32 a24, 0
		v_accvgpr_write_b32 a25, 0
		v_accvgpr_write_b32 a26, 0
		v_accvgpr_write_b32 a27, 0
		v_accvgpr_write_b32 a28, 0
		v_accvgpr_write_b32 a29, 0
		v_accvgpr_write_b32 a30, 0
		v_accvgpr_write_b32 a31, 0
		v_accvgpr_write_b32 a32, 0
		v_accvgpr_write_b32 a33, 0
		v_accvgpr_write_b32 a34, 0
		v_accvgpr_write_b32 a35, 0
		v_accvgpr_write_b32 a36, 0
		v_accvgpr_write_b32 a37, 0
		v_accvgpr_write_b32 a38, 0
		v_accvgpr_write_b32 a39, 0
		v_accvgpr_write_b32 a40, 0
		v_accvgpr_write_b32 a41, 0
		v_accvgpr_write_b32 a42, 0
		v_accvgpr_write_b32 a43, 0
		v_accvgpr_write_b32 a44, 0
		v_accvgpr_write_b32 a45, 0
		v_accvgpr_write_b32 a46, 0
		v_accvgpr_write_b32 a47, 0
		v_accvgpr_write_b32 a48, 0
		v_accvgpr_write_b32 a49, 0
		v_accvgpr_write_b32 a50, 0
		v_accvgpr_write_b32 a51, 0
		v_accvgpr_write_b32 a52, 0
		v_accvgpr_write_b32 a53, 0
		v_accvgpr_write_b32 a54, 0
		v_accvgpr_write_b32 a55, 0
		v_accvgpr_write_b32 a56, 0
		v_accvgpr_write_b32 a57, 0
		v_accvgpr_write_b32 a58, 0
		v_accvgpr_write_b32 a59, 0
		v_accvgpr_write_b32 a60, 0
		v_accvgpr_write_b32 a61, 0
		v_accvgpr_write_b32 a62, 0
		v_accvgpr_write_b32 a63, 0
		v_accvgpr_write_b32 a64, 0
		v_accvgpr_write_b32 a65, 0
		v_accvgpr_write_b32 a66, 0
		v_accvgpr_write_b32 a67, 0
		v_accvgpr_write_b32 a68, 0
		v_accvgpr_write_b32 a69, 0
		v_accvgpr_write_b32 a70, 0
		v_accvgpr_write_b32 a71, 0
		v_accvgpr_write_b32 a72, 0
		v_accvgpr_write_b32 a73, 0
		v_accvgpr_write_b32 a74, 0
		v_accvgpr_write_b32 a75, 0
		v_accvgpr_write_b32 a76, 0
		v_accvgpr_write_b32 a77, 0
		v_accvgpr_write_b32 a78, 0
		v_accvgpr_write_b32 a79, 0
		v_accvgpr_write_b32 a80, 0
		v_accvgpr_write_b32 a81, 0
		v_accvgpr_write_b32 a82, 0
		v_accvgpr_write_b32 a83, 0
		v_accvgpr_write_b32 a84, 0
		v_accvgpr_write_b32 a85, 0
		v_accvgpr_write_b32 a86, 0
		v_accvgpr_write_b32 a87, 0
		v_accvgpr_write_b32 a88, 0
		v_accvgpr_write_b32 a89, 0
		v_accvgpr_write_b32 a90, 0
		v_accvgpr_write_b32 a91, 0
		v_accvgpr_write_b32 a92, 0
		v_accvgpr_write_b32 a93, 0
		v_accvgpr_write_b32 a94, 0
		v_accvgpr_write_b32 a95, 0
		v_accvgpr_write_b32 a96, 0
		v_accvgpr_write_b32 a97, 0
		v_accvgpr_write_b32 a98, 0
		v_accvgpr_write_b32 a99, 0
		v_accvgpr_write_b32 a100, 0
		v_accvgpr_write_b32 a101, 0
		v_accvgpr_write_b32 a102, 0
		v_accvgpr_write_b32 a103, 0
		v_accvgpr_write_b32 a104, 0
		v_accvgpr_write_b32 a105, 0
		v_accvgpr_write_b32 a106, 0
		v_accvgpr_write_b32 a107, 0
		v_accvgpr_write_b32 a108, 0
		v_accvgpr_write_b32 a109, 0
		v_accvgpr_write_b32 a110, 0
		v_accvgpr_write_b32 a111, 0
		v_accvgpr_write_b32 a112, 0
		v_accvgpr_write_b32 a113, 0
		v_accvgpr_write_b32 a114, 0
		v_accvgpr_write_b32 a115, 0
		v_accvgpr_write_b32 a116, 0
		v_accvgpr_write_b32 a117, 0
		v_accvgpr_write_b32 a118, 0
		v_accvgpr_write_b32 a119, 0
		v_accvgpr_write_b32 a120, 0
		v_accvgpr_write_b32 a121, 0
		v_accvgpr_write_b32 a122, 0
		v_accvgpr_write_b32 a123, 0
		v_accvgpr_write_b32 a124, 0
		v_accvgpr_write_b32 a125, 0
		v_accvgpr_write_b32 a126, 0
		v_accvgpr_write_b32 a127, 0
		v_accvgpr_write_b32 a128, 0
		v_accvgpr_write_b32 a129, 0
		v_accvgpr_write_b32 a130, 0
		v_accvgpr_write_b32 a131, 0
		v_accvgpr_write_b32 a132, 0
		v_accvgpr_write_b32 a133, 0
		v_accvgpr_write_b32 a134, 0
		v_accvgpr_write_b32 a135, 0
		v_accvgpr_write_b32 a136, 0
		v_accvgpr_write_b32 a137, 0
		v_accvgpr_write_b32 a138, 0
		v_accvgpr_write_b32 a139, 0
		v_accvgpr_write_b32 a140, 0
		v_accvgpr_write_b32 a141, 0
		v_accvgpr_write_b32 a142, 0
		v_accvgpr_write_b32 a143, 0
		v_accvgpr_write_b32 a144, 0
		v_accvgpr_write_b32 a145, 0
		v_accvgpr_write_b32 a146, 0
		v_accvgpr_write_b32 a147, 0
		v_accvgpr_write_b32 a148, 0
		v_accvgpr_write_b32 a149, 0
		v_accvgpr_write_b32 a150, 0
		v_accvgpr_write_b32 a151, 0
		v_accvgpr_write_b32 a152, 0
		v_accvgpr_write_b32 a153, 0
		v_accvgpr_write_b32 a154, 0
		v_accvgpr_write_b32 a155, 0
		v_accvgpr_write_b32 a156, 0
		v_accvgpr_write_b32 a157, 0
		v_accvgpr_write_b32 a158, 0
		v_accvgpr_write_b32 a159, 0
		v_accvgpr_write_b32 a160, 0
		v_accvgpr_write_b32 a161, 0
		v_accvgpr_write_b32 a162, 0
		v_accvgpr_write_b32 a163, 0
		v_accvgpr_write_b32 a164, 0
		v_accvgpr_write_b32 a165, 0
		v_accvgpr_write_b32 a166, 0
		v_accvgpr_write_b32 a167, 0
		v_accvgpr_write_b32 a168, 0
		v_accvgpr_write_b32 a169, 0
		v_accvgpr_write_b32 a170, 0
		v_accvgpr_write_b32 a171, 0
		v_accvgpr_write_b32 a172, 0
		v_accvgpr_write_b32 a173, 0
		v_accvgpr_write_b32 a174, 0
		v_accvgpr_write_b32 a175, 0
		v_accvgpr_write_b32 a176, 0
		v_accvgpr_write_b32 a177, 0
		v_accvgpr_write_b32 a178, 0
		v_accvgpr_write_b32 a179, 0
		v_accvgpr_write_b32 a180, 0
		v_accvgpr_write_b32 a181, 0
		v_accvgpr_write_b32 a182, 0
		v_accvgpr_write_b32 a183, 0
		v_accvgpr_write_b32 a184, 0
		v_accvgpr_write_b32 a185, 0
		v_accvgpr_write_b32 a186, 0
		v_accvgpr_write_b32 a187, 0
		v_accvgpr_write_b32 a188, 0
		v_accvgpr_write_b32 a189, 0
		v_accvgpr_write_b32 a190, 0
		v_accvgpr_write_b32 a191, 0
		v_accvgpr_write_b32 a192, 0
		v_accvgpr_write_b32 a193, 0
		v_accvgpr_write_b32 a194, 0
		v_accvgpr_write_b32 a195, 0
		v_accvgpr_write_b32 a196, 0
		v_accvgpr_write_b32 a197, 0
		v_accvgpr_write_b32 a198, 0
		v_accvgpr_write_b32 a199, 0
		v_accvgpr_write_b32 a200, 0
		v_accvgpr_write_b32 a201, 0
		v_accvgpr_write_b32 a202, 0
		v_accvgpr_write_b32 a203, 0
		v_accvgpr_write_b32 a204, 0
		v_accvgpr_write_b32 a205, 0
		v_accvgpr_write_b32 a206, 0
		v_accvgpr_write_b32 a207, 0
.Lwmma_f16_matmul_tiled.loop_head_0:
		v_mov_b32_e32 v72, s11
		v_mul_lo_u32 v80, v12, v72
		v_mul_hi_u32 v81, v12, v72
		v_mul_lo_u32 v3, v12, v73
		v_add_u32_e32 v81, v81, v3
		v_mul_lo_u32 v3, v13, v72
		v_add_u32_e32 v81, v81, v3
		v_add_co_u32_e64 v108, vcc, v6, v80
		v_addc_co_u32_e64 v109, vcc, v7, v81, vcc
		v_add_co_u32_e64 v116, vcc, v84, v80
		v_addc_co_u32_e64 v117, vcc, v85, v81, vcc
		v_add_co_u32_e64 v188, vcc, v90, v80
		v_addc_co_u32_e64 v189, vcc, v91, v81, vcc
		v_add_co_u32_e64 v190, vcc, v94, v80
		v_addc_co_u32_e64 v191, vcc, v95, v81, vcc
		v_add_co_u32_e64 v192, vcc, v98, v80
		v_addc_co_u32_e64 v193, vcc, v99, v81, vcc
		v_add_co_u32_e64 v194, vcc, v102, v80
		v_addc_co_u32_e64 v195, vcc, v103, v81, vcc
		v_add_co_u32_e64 v196, vcc, v106, v80
		v_addc_co_u32_e64 v197, vcc, v107, v81, vcc
		v_add_co_u32_e64 v198, vcc, v110, v80
		v_addc_co_u32_e64 v199, vcc, v111, v81, vcc
		v_add_co_u32_e64 v200, vcc, v4, v80
		v_addc_co_u32_e64 v201, vcc, v5, v81, vcc
		v_add_co_u32_e64 v202, vcc, v74, v80
		v_addc_co_u32_e64 v203, vcc, v75, v81, vcc
		v_add_co_u32_e64 v204, vcc, v82, v80
		v_addc_co_u32_e64 v205, vcc, v83, v81, vcc
		v_add_co_u32_e64 v206, vcc, v88, v80
		v_addc_co_u32_e64 v207, vcc, v89, v81, vcc
		v_add_co_u32_e64 v208, vcc, v92, v80
		v_addc_co_u32_e64 v209, vcc, v93, v81, vcc
		v_add_co_u32_e64 v210, vcc, v96, v80
		v_addc_co_u32_e64 v211, vcc, v97, v81, vcc
		v_add_co_u32_e64 v212, vcc, v100, v80
		v_addc_co_u32_e64 v213, vcc, v101, v81, vcc
		v_add_co_u32_e64 v214, vcc, v104, v80
		v_addc_co_u32_e64 v215, vcc, v105, v81, vcc
		v_mul_lo_u32 v216, v18, v72
		v_mul_hi_u32 v217, v18, v72
		v_mul_lo_u32 v3, v18, v73
		v_add_u32_e32 v217, v217, v3
		v_mul_lo_u32 v3, v19, v72
		v_add_u32_e32 v217, v217, v3
		v_add_co_u32_e64 v218, vcc, v114, v216
		v_addc_co_u32_e64 v219, vcc, v115, v217, vcc
		v_add_co_u32_e64 v220, vcc, v76, v216
		v_addc_co_u32_e64 v221, vcc, v77, v217, vcc
		s_waitcnt vmcnt(20) lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], a[0:3], v[36:39], v[8:11], v14, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[208:211], v1
		s_waitcnt vmcnt(16)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[0:3], v[40:43], v[128:131], v14, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[212:215], v1 offset:1024
		s_waitcnt vmcnt(12)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[0:3], v[44:47], v[132:135], v14, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[216:219], v1 offset:2048
		s_waitcnt vmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[0:3], v[48:51], v[136:139], v14, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[220:223], v1 offset:3072
		s_waitcnt vmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[0:3], v[52:55], v[140:143], v14, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[224:227], v1 offset:4096
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[0:3], v[56:59], v[144:147], v14, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[228:231], v1 offset:5120
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[0:3], v[60:63], v[148:151], v14, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[232:235], v1 offset:6144
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[0:3], v[64:67], v[152:155], v14, v71 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[236:239], v1 offset:7168
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[4:7], v[36:39], v[156:159], v14, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[240:243], v2
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[4:7], v[40:43], v[160:163], v14, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[244:247], v2 offset:1024
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[4:7], v[44:47], v[164:167], v14, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[248:251], v2 offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[4:7], v[48:51], v[168:171], v14, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[252:255], v2 offset:3072
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[4:7], v[52:55], v[172:175], v14, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v2 offset:4096
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[4:7], v[56:59], v[176:179], v14, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v2 offset:5120
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[4:7], v[60:63], v[180:183], v14, v71 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[232:235], v2 offset:6144
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[4:7], v[64:67], v[184:187], v14, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshr_b32 s9, s4, 6
		s_and_b32 s9, s9, 1
		s_lshl_b32 s9, s9, 13
		s_add_i32 s9, s9, 0x4000
		v_and_b32_e32 v3, 15, v0
		v_lshlrev_b32_e32 v222, 6, v3
		v_accvgpr_write_b32 a0, v222
		v_and_b32_e32 v222, 63, v0
		v_lshrrev_b32_e32 v222, 4, v222
		v_lshrrev_b32_e32 v3, 1, v3
		v_bitop3_b32 v3, v222, v3, 3 bitop3:0x78
		v_lshlrev_b32_e32 v3, 4, v3
		v_accvgpr_read_b32 v222, a0
		v_add3_u32 v3, s9, v222, v3
		v_add_u32_e32 v3, 0x10000, v3
		v_accvgpr_write_b32 a0, v3
		v_accvgpr_read_b32 v3, a0
		ds_read_b128 v[236:239], v3 offset:7168
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[8:11], v[36:39], a[16:19], v15, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s44
		s_nop 0
		buffer_load_dwordx4 v108, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[8:11], v[40:43], a[20:23], v15, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v116, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[8:11], v[44:47], a[24:27], v15, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v188, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[8:11], v[48:51], a[28:31], v15, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v190, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[8:11], v[52:55], a[32:35], v15, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v192, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[8:11], v[56:59], a[36:39], v15, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v194, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[8:11], v[60:63], a[40:43], v15, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v196, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[8:11], v[64:67], a[44:47], v15, v71 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v198, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[12:15], v[36:39], a[48:51], v15, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x9000
		s_nop 0
		buffer_load_dwordx4 v200, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[12:15], v[40:43], a[52:55], v15, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v202, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[12:15], v[44:47], a[56:59], v15, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v204, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[12:15], v[48:51], a[60:63], v15, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v206, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[12:15], v[52:55], a[64:67], v15, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v208, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[12:15], v[56:59], a[68:71], v15, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v210, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[12:15], v[60:63], a[72:75], v15, v71 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v212, s[0:3], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[12:15], v[64:67], a[76:79], v15, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v214, s[0:3], 0 offen lds
		s_nop 0
		s_add_i32 m0, s5, 0x20000
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[20:23], v[36:39], a[80:83], v16, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v218, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, s41, 0x21000
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[20:23], v[40:43], a[84:87], v16, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v220, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[20:23], v[44:47], a[88:91], v16, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		s_lshr_b32 s9, s4, 6
		s_lshr_b32 s9, s9, 1
		s_lshl_b32 s9, s9, 13
		v_and_b32_e32 v3, 15, v0
		v_lshlrev_b32_e32 v108, 6, v3
		v_and_b32_e32 v109, 63, v0
		v_lshrrev_b32_e32 v109, 4, v109
		v_lshrrev_b32_e32 v3, 1, v3
		v_bitop3_b32 v3, v109, v3, 3 bitop3:0x78
		v_lshlrev_b32_e32 v3, 4, v3
		v_add3_u32 v3, s9, v108, v3
		ds_read_b128 a[0:3], v3
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[20:23], v[48:51], a[92:95], v16, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[4:7], v3 offset:1024
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[20:23], v[52:55], a[96:99], v16, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[8:11], v3 offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[20:23], v[56:59], a[100:103], v16, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[12:15], v3 offset:3072
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[20:23], v[60:63], a[104:107], v16, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[188:191], v3 offset:4096
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v188, s9
		scratch_store_dword off, v189, s9 offset:4
		scratch_store_dword off, v190, s9 offset:8
		scratch_store_dword off, v191, s9 offset:12
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[20:23], v[64:67], a[108:111], v16, v71 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v3 offset:5120
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s9 offset:16
		scratch_store_dword off, v21, s9 offset:20
		scratch_store_dword off, v22, s9 offset:24
		scratch_store_dword off, v23, s9 offset:28
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[24:27], v[36:39], a[112:115], v16, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v3 offset:6144
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s9 offset:32
		scratch_store_dword off, v21, s9 offset:36
		scratch_store_dword off, v22, s9 offset:40
		scratch_store_dword off, v23, s9 offset:44
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[24:27], v[40:43], a[116:119], v16, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v3 offset:7168
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s9 offset:48
		scratch_store_dword off, v21, s9 offset:52
		scratch_store_dword off, v22, s9 offset:56
		scratch_store_dword off, v23, s9 offset:60
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[24:27], v[44:47], a[120:123], v16, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshr_b32 s9, s4, 6
		s_and_b32 s9, s9, 1
		s_lshl_b32 s9, s9, 13
		v_and_b32_e32 v3, 15, v0
		v_lshlrev_b32_e32 v20, 6, v3
		v_and_b32_e32 v21, 63, v0
		v_lshrrev_b32_e32 v21, 4, v21
		v_lshrrev_b32_e32 v3, 1, v3
		v_bitop3_b32 v3, v21, v3, 3 bitop3:0x78
		v_lshlrev_b32_e32 v3, 4, v3
		v_add3_u32 v3, s9, v20, v3
		v_add_u32_e32 v3, 0x10000, v3
		ds_read_b128 v[20:23], v3
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s9 offset:64
		scratch_store_dword off, v21, s9 offset:68
		scratch_store_dword off, v22, s9 offset:72
		scratch_store_dword off, v23, s9 offset:76
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[24:27], v[48:51], a[124:127], v16, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v3 offset:1024
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s9 offset:80
		scratch_store_dword off, v21, s9 offset:84
		scratch_store_dword off, v22, s9 offset:88
		scratch_store_dword off, v23, s9 offset:92
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[24:27], v[52:55], a[128:131], v16, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v3 offset:2048
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s9 offset:96
		scratch_store_dword off, v21, s9 offset:100
		scratch_store_dword off, v22, s9 offset:104
		scratch_store_dword off, v23, s9 offset:108
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[24:27], v[56:59], a[132:135], v16, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v3 offset:3072
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s9 offset:112
		scratch_store_dword off, v21, s9 offset:116
		scratch_store_dword off, v22, s9 offset:120
		scratch_store_dword off, v23, s9 offset:124
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[24:27], v[60:63], a[136:139], v16, v71 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v3 offset:4096
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s9 offset:128
		scratch_store_dword off, v21, s9 offset:132
		scratch_store_dword off, v22, s9 offset:136
		scratch_store_dword off, v23, s9 offset:140
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[24:27], v[64:67], a[140:143], v16, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v3 offset:5120
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s9 offset:144
		scratch_store_dword off, v21, s9 offset:148
		scratch_store_dword off, v22, s9 offset:152
		scratch_store_dword off, v23, s9 offset:156
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[28:31], v[36:39], a[144:147], v17, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[188:191], v3 offset:6144
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[28:31], v[40:43], a[148:151], v17, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[192:195], v3 offset:7168
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[28:31], v[44:47], a[152:155], v17, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshr_b32 s9, s4, 6
		s_lshr_b32 s9, s9, 1
		s_lshl_b32 s9, s9, 8
		v_and_b32_e32 v3, 63, v0
		v_add_lshl_u32 v3, s9, v3, 2
		v_add_u32_e32 v3, 0x20000, v3
		ds_read_b32 v20, v3
		s_mov_b32 m0, s15
		s_waitcnt lgkmcnt(0)
		s_nop 0
		ds_write_addtid_b32 v20 offset:20480
		ds_read_b32 v20, v3 offset:256
		s_mov_b32 m0, s15
		s_waitcnt lgkmcnt(0)
		s_nop 0
		ds_write_addtid_b32 v20 offset:21504
		ds_read_b32 v20, v3 offset:512
		s_mov_b32 m0, s15
		s_waitcnt lgkmcnt(0)
		s_nop 0
		ds_write_addtid_b32 v20 offset:22528
		ds_read_b32 v20, v3 offset:768
		s_mov_b32 m0, s15
		s_waitcnt lgkmcnt(0)
		s_nop 0
		ds_write_addtid_b32 v20 offset:23552
		s_lshr_b32 s9, s4, 6
		s_and_b32 s9, s9, 1
		s_lshl_b32 s9, s9, 8
		v_and_b32_e32 v3, 63, v0
		v_add_lshl_u32 v3, s9, v3, 2
		v_add_u32_e32 v3, 0x20000, v3
		ds_read_b32 v108, v3 offset:4096
		ds_read_b32 v109, v3 offset:4352
		ds_read_b32 v116, v3 offset:4608
		ds_read_b32 v117, v3 offset:4864
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[28:31], v[48:51], a[156:159], v17, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[32:35], v[48:51], a[188:191], v17, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[32:35], v[44:47], a[184:187], v17, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[32:35], v[36:39], a[176:179], v17, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[32:35], v[40:43], a[180:183], v17, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[32:35], v[52:55], a[192:195], v17, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[28:31], v[52:55], a[160:163], v17, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[28:31], v[56:59], a[164:167], v17, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[32:35], v[56:59], a[196:199], v17, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[32:35], v[60:63], a[200:203], v17, v71 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[28:31], v[60:63], a[168:171], v17, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[28:31], v[64:67], a[172:175], v17, v71 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[32:35], v[64:67], a[204:207], v17, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[232:235], v[232:235], a[168:171], v17, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[232:235], v[236:239], a[172:175], v17, v71 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[236:239], v[236:239], a[204:207], v17, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[236:239], v[232:235], a[200:203], v17, v71 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[208:211], v[232:235], v[148:151], v14, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[208:211], v[236:239], v[152:155], v14, v71 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[212:215], v[236:239], v[184:187], v14, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[212:215], v[232:235], v[180:183], v14, v71 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[212:215], a[240:243], v[156:159], v14, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], a[208:211], a[240:243], v[8:11], v14, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[208:211], a[244:247], v[128:131], v14, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[212:215], a[244:247], v[160:163], v14, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[212:215], a[248:251], v[164:167], v14, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[208:211], a[248:251], v[132:135], v14, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[208:211], a[252:255], v[136:139], v14, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[212:215], a[252:255], v[168:171], v14, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[212:215], v[224:227], v[172:175], v14, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[208:211], v[224:227], v[140:143], v14, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[208:211], v[228:231], v[144:147], v14, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[212:215], v[228:231], v[176:179], v14, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[216:219], v[228:231], a[36:39], v15, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[216:219], v[224:227], a[32:35], v15, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[220:223], v[224:227], a[64:67], v15, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[220:223], v[228:231], a[68:71], v15, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[220:223], a[240:243], a[48:51], v15, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[216:219], a[240:243], a[16:19], v15, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[216:219], a[244:247], a[20:23], v15, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[220:223], a[244:247], a[52:55], v15, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[220:223], a[248:251], a[56:59], v15, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[216:219], a[248:251], a[24:27], v15, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[216:219], a[252:255], a[28:31], v15, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[220:223], a[252:255], a[60:63], v15, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[220:223], v[232:235], a[72:75], v15, v71 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[216:219], v[232:235], a[40:43], v15, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[216:219], v[236:239], a[44:47], v15, v71 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[220:223], v[236:239], a[76:79], v15, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[224:227], v[236:239], a[108:111], v16, v71 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[224:227], v[232:235], a[104:107], v16, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[228:231], v[232:235], a[136:139], v16, v71 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[228:231], v[236:239], a[140:143], v16, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[228:231], a[240:243], a[112:115], v16, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[224:227], a[240:243], a[80:83], v16, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[224:227], a[244:247], a[84:87], v16, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[228:231], a[244:247], a[116:119], v16, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[228:231], a[248:251], a[120:123], v16, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], a[224:227], a[248:251], a[88:91], v16, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], a[224:227], a[252:255], a[92:95], v16, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[228:231], a[252:255], a[124:127], v16, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[228:231], v[224:227], a[128:131], v16, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[224:227], v[224:227], a[96:99], v16, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[224:227], v[228:231], a[100:103], v16, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[228:231], v[228:231], a[132:135], v16, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[232:235], v[228:231], a[164:167], v17, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[232:235], v[224:227], a[160:163], v17, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[236:239], v[224:227], a[192:195], v17, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[236:239], v[228:231], a[196:199], v17, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[236:239], a[240:243], a[176:179], v17, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[232:235], a[240:243], a[144:147], v17, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[232:235], a[244:247], a[148:151], v17, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[236:239], a[244:247], a[180:183], v17, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[236:239], a[248:251], a[184:187], v17, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[232:235], a[248:251], a[152:155], v17, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[232:235], a[252:255], a[156:159], v17, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[236:239], a[252:255], a[188:191], v17, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_lshr_b32 s9, s4, 6
		s_lshr_b32 s9, s9, 1
		s_lshl_b32 s9, s9, 13
		s_add_i32 s9, s9, 0x8000
		v_and_b32_e32 v3, 15, v0
		v_lshlrev_b32_e32 v14, 6, v3
		v_and_b32_e32 v15, 63, v0
		v_lshrrev_b32_e32 v15, 4, v15
		v_lshrrev_b32_e32 v3, 1, v3
		v_bitop3_b32 v3, v15, v3, 3 bitop3:0x78
		v_lshlrev_b32_e32 v3, 4, v3
		v_add3_u32 v3, s9, v14, v3
		ds_read_b128 v[20:23], v3
		ds_read_b128 v[24:27], v3 offset:1024
		ds_read_b128 v[28:31], v3 offset:2048
		ds_read_b128 v[32:35], v3 offset:3072
		ds_read_b128 v[36:39], v3 offset:4096
		ds_read_b128 v[40:43], v3 offset:5120
		ds_read_b128 a[208:211], v3 offset:6144
		ds_read_b128 a[212:215], v3 offset:7168
		s_lshr_b32 s9, s4, 6
		s_and_b32 s9, s9, 1
		s_lshl_b32 s9, s9, 13
		s_add_i32 s9, s9, 0x8000
		v_and_b32_e32 v14, 15, v0
		v_lshlrev_b32_e32 v15, 6, v14
		v_and_b32_e32 v16, 63, v0
		v_lshrrev_b32_e32 v16, 4, v16
		v_lshrrev_b32_e32 v14, 1, v14
		v_bitop3_b32 v14, v16, v14, 3 bitop3:0x78
		v_lshlrev_b32_e32 v14, 4, v14
		v_add3_u32 v14, s9, v15, v14
		v_add_u32_e32 v14, 0x10000, v14
		ds_read_b128 a[216:219], v14
		ds_read_b128 a[220:223], v14 offset:1024
		ds_read_b128 a[224:227], v14 offset:2048
		ds_read_b128 a[228:231], v14 offset:3072
		ds_read_b128 a[232:235], v14 offset:4096
		ds_read_b128 a[236:239], v14 offset:5120
		ds_read_b128 a[240:243], v14 offset:6144
		ds_read_b128 a[244:247], v14 offset:7168
		s_lshr_b32 s9, s4, 6
		s_lshr_b32 s9, s9, 1
		s_lshl_b32 s9, s9, 8
		s_add_i32 s9, s9, 0x200
		v_and_b32_e32 v15, 63, v0
		v_add_lshl_u32 v15, s9, v15, 2
		v_add_u32_e32 v15, 0x20000, v15
		ds_read_b32 v16, v15
		ds_read_b32 v17, v15 offset:256
		ds_read_b32 v44, v15 offset:512
		ds_read_b32 v45, v15 offset:768
		s_lshr_b32 s9, s4, 6
		s_and_b32 s9, s9, 1
		s_lshl_b32 s9, s9, 8
		s_add_i32 s9, s9, 0x200
		v_and_b32_e32 v15, 63, v0
		v_add_lshl_u32 v15, s9, v15, 2
		v_add_u32_e32 v15, 0x20000, v15
		ds_read_b32 v46, v15 offset:4096
		ds_read_b32 v47, v15 offset:4352
		ds_read_b32 v48, v15 offset:4608
		ds_read_b32 v49, v15 offset:4864
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v50
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v51 offset:1024
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v52, vcc, v50, v80
		v_addc_co_u32_e64 v53, vcc, v51, v81, vcc
		ds_read_addtid_b32 v50 offset:2048
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v51 offset:3072
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v54, vcc, v50, v80
		v_addc_co_u32_e64 v55, vcc, v51, v81, vcc
		ds_read_addtid_b32 v50 offset:4096
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v51 offset:5120
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v56, vcc, v50, v80
		v_addc_co_u32_e64 v57, vcc, v51, v81, vcc
		ds_read_addtid_b32 v50 offset:6144
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v51 offset:7168
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v58, vcc, v50, v80
		v_addc_co_u32_e64 v59, vcc, v51, v81, vcc
		ds_read_addtid_b32 v50 offset:8192
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v51 offset:9216
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v60, vcc, v50, v80
		v_addc_co_u32_e64 v61, vcc, v51, v81, vcc
		ds_read_addtid_b32 v50 offset:10240
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v51 offset:11264
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v62, vcc, v50, v80
		v_addc_co_u32_e64 v63, vcc, v51, v81, vcc
		ds_read_addtid_b32 v50 offset:12288
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v51 offset:13312
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v64, vcc, v50, v80
		v_addc_co_u32_e64 v65, vcc, v51, v81, vcc
		ds_read_addtid_b32 v50 offset:14336
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v51 offset:15360
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v66, vcc, v50, v80
		v_addc_co_u32_e64 v67, vcc, v51, v81, vcc
		ds_read_addtid_b32 v50 offset:16384
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v51 offset:17408
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v68, vcc, v50, v80
		v_addc_co_u32_e64 v69, vcc, v51, v81, vcc
		ds_read_addtid_b32 v50 offset:18432
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v51 offset:19456
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v70, vcc, v50, v80
		v_addc_co_u32_e64 v71, vcc, v51, v81, vcc
		v_add_co_u32_e64 v50, vcc, v118, v80
		v_addc_co_u32_e64 v51, vcc, v119, v81, vcc
		v_add_co_u32_e64 v196, vcc, v120, v80
		v_addc_co_u32_e64 v197, vcc, v121, v81, vcc
		v_add_co_u32_e64 v198, vcc, v122, v80
		v_addc_co_u32_e64 v199, vcc, v123, v81, vcc
		v_add_co_u32_e64 v200, vcc, v124, v80
		v_addc_co_u32_e64 v201, vcc, v125, v81, vcc
		v_add_co_u32_e64 v202, vcc, v126, v80
		v_addc_co_u32_e64 v203, vcc, v127, v81, vcc
		v_add_co_u32_e64 v204, vcc, v86, v80
		v_addc_co_u32_e64 v205, vcc, v87, v81, vcc
		v_add_co_u32_e64 v80, vcc, v112, v216
		v_addc_co_u32_e64 v81, vcc, v113, v217, vcc
		v_add_co_u32_e64 v206, vcc, v78, v216
		v_addc_co_u32_e64 v207, vcc, v79, v217, vcc
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[20:23], a[216:219], v[8:11], v16, v46 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[248:251], v3 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[20:23], a[220:223], v[128:131], v16, v46 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[252:255], v3 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[20:23], a[224:227], v[132:135], v16, v47 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[208:211], v3 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[20:23], a[228:231], v[136:139], v16, v47 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[212:215], v3 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[20:23], a[232:235], v[140:143], v16, v48 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v3 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[20:23], a[236:239], v[144:147], v16, v48 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v3 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], a[240:243], v[148:151], v16, v49 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v3 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], a[244:247], v[152:155], v16, v49 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v3 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], a[216:219], v[156:159], v16, v46 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v14 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[24:27], a[220:223], v[160:163], v16, v46 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[232:235], v14 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[24:27], a[224:227], v[164:167], v16, v47 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[236:239], v14 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[24:27], a[228:231], v[168:171], v16, v47 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v14 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[24:27], a[232:235], v[172:175], v16, v48 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[244:247], v14 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[24:27], a[236:239], v[176:179], v16, v48 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v14 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], a[240:243], v[180:183], v16, v49 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[252:255], v14 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], a[244:247], v[184:187], v16, v49 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v14 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[28:31], a[216:219], a[16:19], v17, v46 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s10
		s_nop 0
		buffer_load_dwordx4 v52, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[28:31], a[220:223], a[20:23], v17, v46 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v54, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[28:31], a[224:227], a[24:27], v17, v47 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v56, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[28:31], a[228:231], a[28:31], v17, v47 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v58, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[28:31], a[232:235], a[32:35], v17, v48 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v60, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[28:31], a[236:239], a[36:39], v17, v48 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v62, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[28:31], a[240:243], a[40:43], v17, v49 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v64, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[28:31], a[244:247], a[44:47], v17, v49 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v66, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[32:35], a[216:219], a[48:51], v17, v46 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x9000
		s_nop 0
		buffer_load_dwordx4 v68, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[32:35], a[220:223], a[52:55], v17, v46 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v70, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[32:35], a[224:227], a[56:59], v17, v47 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v50, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[32:35], a[228:231], a[60:63], v17, v47 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v196, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[32:35], a[232:235], a[64:67], v17, v48 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v198, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[32:35], a[236:239], a[68:71], v17, v48 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v200, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[32:35], a[240:243], a[72:75], v17, v49 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v202, s[0:3], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[32:35], a[244:247], a[76:79], v17, v49 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v204, s[0:3], 0 offen lds
		s_nop 0
		s_add_i32 m0, s47, 0x20000
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[36:39], a[216:219], a[80:83], v44, v46 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v80, s[24:27], 0 offen lds
		s_nop 0
		s_add_i32 m0, s57, 0x21000
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[36:39], a[220:223], a[84:87], v44, v46 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v206, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[36:39], a[224:227], a[88:91], v44, v47 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[36:39], a[228:231], a[92:95], v44, v47 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[40:43], a[228:231], a[124:127], v44, v47 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[40:43], a[224:227], a[120:123], v44, v47 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[40:43], a[216:219], a[112:115], v44, v46 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[40:43], a[220:223], a[116:119], v44, v46 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[40:43], a[232:235], a[128:131], v44, v48 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[36:39], a[232:235], a[96:99], v44, v48 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[36:39], a[236:239], a[100:103], v44, v48 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[40:43], a[236:239], a[132:135], v44, v48 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[40:43], a[240:243], a[136:139], v44, v49 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[36:39], a[240:243], a[104:107], v44, v49 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[36:39], a[244:247], a[108:111], v44, v49 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[40:43], a[244:247], a[140:143], v44, v49 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[208:211], a[244:247], a[172:175], v45, v49 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[208:211], a[240:243], a[168:171], v45, v49 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[212:215], a[240:243], a[200:203], v45, v49 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[212:215], a[244:247], a[204:207], v45, v49 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[212:215], a[216:219], a[176:179], v45, v46 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[208:211], a[216:219], a[144:147], v45, v46 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[208:211], a[220:223], a[148:151], v45, v46 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[212:215], a[220:223], a[180:183], v45, v46 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[212:215], a[224:227], a[184:187], v45, v47 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[208:211], a[224:227], a[152:155], v45, v47 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[208:211], a[228:231], a[156:159], v45, v47 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[212:215], a[228:231], a[188:191], v45, v47 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[212:215], a[232:235], a[192:195], v45, v48 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[208:211], a[232:235], a[160:163], v45, v48 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[208:211], a[236:239], a[164:167], v45, v48 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[212:215], a[236:239], a[196:199], v45, v48 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		s_waitcnt lgkmcnt(7)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], a[248:251], v[228:231], v[8:11], v16, v46 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[248:251], v[232:235], v[128:131], v16, v46 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[252:255], v[232:235], v[160:163], v16, v46 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[252:255], v[228:231], v[156:159], v16, v46 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[252:255], v[236:239], v[164:167], v16, v47 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[248:251], v[236:239], v[132:135], v16, v47 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[248:251], v[240:243], v[136:139], v16, v47 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[252:255], v[240:243], v[168:171], v16, v47 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[252:255], v[244:247], v[172:175], v16, v48 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[248:251], v[244:247], v[140:143], v16, v48 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[248:251], v[248:251], v[144:147], v16, v48 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[252:255], v[248:251], v[176:179], v16, v48 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[252:255], v[252:255], v[180:183], v16, v49 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[248:251], v[252:255], v[148:151], v16, v49 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[248:251], v[24:27], v[152:155], v16, v49 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[252:255], v[24:27], v[184:187], v16, v49 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[208:211], v[24:27], a[44:47], v17, v49 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[208:211], v[252:255], a[40:43], v17, v49 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[212:215], v[252:255], a[72:75], v17, v49 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[212:215], v[24:27], a[76:79], v17, v49 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[212:215], v[228:231], a[48:51], v17, v46 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[208:211], v[228:231], a[16:19], v17, v46 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[208:211], v[232:235], a[20:23], v17, v46 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[212:215], v[232:235], a[52:55], v17, v46 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[212:215], v[236:239], a[56:59], v17, v47 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[208:211], v[236:239], a[24:27], v17, v47 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[208:211], v[240:243], a[28:31], v17, v47 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[212:215], v[240:243], a[60:63], v17, v47 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[212:215], v[244:247], a[64:67], v17, v48 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[208:211], v[244:247], a[32:35], v17, v48 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[208:211], v[248:251], a[36:39], v17, v48 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[212:215], v[248:251], a[68:71], v17, v48 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[216:219], v[248:251], a[100:103], v44, v48 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[216:219], v[244:247], a[96:99], v44, v48 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[220:223], v[244:247], a[128:131], v44, v48 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[220:223], v[248:251], a[132:135], v44, v48 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[220:223], v[228:231], a[112:115], v44, v46 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[216:219], v[228:231], a[80:83], v44, v46 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[216:219], v[232:235], a[84:87], v44, v46 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[220:223], v[232:235], a[116:119], v44, v46 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[220:223], v[236:239], a[120:123], v44, v47 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[216:219], v[236:239], a[88:91], v44, v47 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[216:219], v[240:243], a[92:95], v44, v47 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[220:223], v[240:243], a[124:127], v44, v47 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[220:223], v[252:255], a[136:139], v44, v49 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[216:219], v[252:255], a[104:107], v44, v49 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[216:219], v[24:27], a[108:111], v44, v49 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[220:223], v[24:27], a[140:143], v44, v49 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[224:227], v[24:27], a[172:175], v45, v49 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[224:227], v[252:255], a[168:171], v45, v49 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[20:23], v[252:255], a[200:203], v45, v49 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[20:23], v[24:27], a[204:207], v45, v49 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[20:23], v[228:231], a[176:179], v45, v46 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[224:227], v[228:231], a[144:147], v45, v46 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[224:227], v[232:235], a[148:151], v45, v46 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[20:23], v[232:235], a[180:183], v45, v46 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[20:23], v[236:239], a[184:187], v45, v47 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[224:227], v[236:239], a[152:155], v45, v47 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[224:227], v[240:243], a[156:159], v45, v47 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[20:23], v[240:243], a[188:191], v45, v47 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[20:23], v[244:247], a[192:195], v45, v48 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[224:227], v[244:247], a[160:163], v45, v48 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[224:227], v[248:251], a[164:167], v45, v48 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[20:23], v[248:251], a[196:199], v45, v48 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s11, s11, 2
		s_cmp_lt_i32 s11, s56
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(36)
		scratch_load_dword v20, off, s9
		scratch_load_dword v21, off, s9 offset:4
		scratch_load_dword v22, off, s9 offset:8
		scratch_load_dword v23, off, s9 offset:12
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(32)
		scratch_load_dword v24, off, s9 offset:16
		scratch_load_dword v25, off, s9 offset:20
		scratch_load_dword v26, off, s9 offset:24
		scratch_load_dword v27, off, s9 offset:28
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(28)
		scratch_load_dword v28, off, s9 offset:32
		scratch_load_dword v29, off, s9 offset:36
		scratch_load_dword v30, off, s9 offset:40
		scratch_load_dword v31, off, s9 offset:44
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v32, off, s9 offset:48
		scratch_load_dword v33, off, s9 offset:52
		scratch_load_dword v34, off, s9 offset:56
		scratch_load_dword v35, off, s9 offset:60
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(20)
		scratch_load_dword v36, off, s9 offset:64
		scratch_load_dword v37, off, s9 offset:68
		scratch_load_dword v38, off, s9 offset:72
		scratch_load_dword v39, off, s9 offset:76
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v40, off, s9 offset:80
		scratch_load_dword v41, off, s9 offset:84
		scratch_load_dword v42, off, s9 offset:88
		scratch_load_dword v43, off, s9 offset:92
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(12)
		scratch_load_dword v44, off, s9 offset:96
		scratch_load_dword v45, off, s9 offset:100
		scratch_load_dword v46, off, s9 offset:104
		scratch_load_dword v47, off, s9 offset:108
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v48, off, s9 offset:112
		scratch_load_dword v49, off, s9 offset:116
		scratch_load_dword v50, off, s9 offset:120
		scratch_load_dword v51, off, s9 offset:124
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v52, off, s9 offset:128
		scratch_load_dword v53, off, s9 offset:132
		scratch_load_dword v54, off, s9 offset:136
		scratch_load_dword v55, off, s9 offset:140
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v56, off, s9 offset:144
		scratch_load_dword v57, off, s9 offset:148
		scratch_load_dword v58, off, s9 offset:152
		scratch_load_dword v59, off, s9 offset:156
		v_mov_b32_e32 v60, v188
		v_mov_b32_e32 v61, v189
		v_mov_b32_e32 v62, v190
		v_mov_b32_e32 v63, v191
		s_mov_b32 m0, s15
		v_mov_b32_e32 v64, v192
		v_mov_b32_e32 v65, v193
		v_mov_b32_e32 v66, v194
		v_mov_b32_e32 v67, v195
		ds_read_addtid_b32 v3 offset:20480
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mov_b32_e32 v14, v3
		ds_read_addtid_b32 v3 offset:21504
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mov_b32_e32 v15, v3
		ds_read_addtid_b32 v3 offset:22528
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_mov_b32_e32 v16, v3
		ds_read_addtid_b32 v3 offset:23552
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v17, v3
		v_mov_b32_e32 v68, v108
		v_mov_b32_e32 v69, v109
		v_mov_b32_e32 v70, v116
		v_mov_b32_e32 v71, v117
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_sub_i32 s0, s12, 1
		s_waitcnt vmcnt(20)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], a[0:3], v[36:39], v[8:11], v14, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s0, s0, 1
		s_lshl_b32 s0, s0, 15
		s_add_i32 s1, s48, s0
		v_and_b32_e32 v1, 15, v0
		v_lshlrev_b32_e32 v1, 6, v1
		v_and_b32_e32 v2, 63, v0
		v_lshrrev_b32_e32 v2, 4, v2
		v_and_b32_e32 v3, 15, v0
		v_lshrrev_b32_e32 v3, 1, v3
		v_bitop3_b32 v2, v2, v3, 3 bitop3:0x78
		v_lshlrev_b32_e32 v2, 4, v2
		v_add3_u32 v3, s1, v1, v2
		ds_read_b128 v[4:7], v3 offset:16384
		s_waitcnt vmcnt(16)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[0:3], v[40:43], v[128:131], v14, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[72:75], v3 offset:17408
		s_waitcnt vmcnt(12)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[0:3], v[44:47], v[132:135], v14, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[76:79], v3 offset:18432
		s_waitcnt vmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[0:3], v[48:51], v[136:139], v14, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[80:83], v3 offset:19456
		s_waitcnt vmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[0:3], v[52:55], v[140:143], v14, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[84:87], v3 offset:20480
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[0:3], v[56:59], v[144:147], v14, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v3 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[0:3], v[60:63], v[148:151], v14, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v3 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[0:3], v[64:67], v[152:155], v14, v71 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v3 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[4:7], v[36:39], v[156:159], v14, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s0, s0, s46
		s_add_i32 s0, s0, 0x10000
		v_add3_u32 v3, s0, v1, v2
		ds_read_b128 v[100:103], v3 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[4:7], v[40:43], v[160:163], v14, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[104:107], v3 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[4:7], v[44:47], v[164:167], v14, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[108:111], v3 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[4:7], v[48:51], v[168:171], v14, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[112:115], v3 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[4:7], v[52:55], v[172:175], v14, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[116:119], v3 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[4:7], v[56:59], v[176:179], v14, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[120:123], v3 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[4:7], v[60:63], v[180:183], v14, v71 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[124:127], v3 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[4:7], v[64:67], v[184:187], v14, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[188:191], v3 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[8:11], v[36:39], a[16:19], v15, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[8:11], v[40:43], a[20:23], v15, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[12:15], v[40:43], a[52:55], v15, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[12:15], v[36:39], a[48:51], v15, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[12:15], v[44:47], a[56:59], v15, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[8:11], v[44:47], a[24:27], v15, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[8:11], v[48:51], a[28:31], v15, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[12:15], v[48:51], a[60:63], v15, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[12:15], v[52:55], a[64:67], v15, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[8:11], v[52:55], a[32:35], v15, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[8:11], v[56:59], a[36:39], v15, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[12:15], v[56:59], a[68:71], v15, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[12:15], v[60:63], a[72:75], v15, v71 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[8:11], v[60:63], a[40:43], v15, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[8:11], v[64:67], a[44:47], v15, v71 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[12:15], v[64:67], a[76:79], v15, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[20:23], v[64:67], a[108:111], v16, v71 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[20:23], v[60:63], a[104:107], v16, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[24:27], v[60:63], a[136:139], v16, v71 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[24:27], v[64:67], a[140:143], v16, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[24:27], v[36:39], a[112:115], v16, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[20:23], v[36:39], a[80:83], v16, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[20:23], v[40:43], a[84:87], v16, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[24:27], v[40:43], a[116:119], v16, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[24:27], v[44:47], a[120:123], v16, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[20:23], v[44:47], a[88:91], v16, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[20:23], v[48:51], a[92:95], v16, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[24:27], v[48:51], a[124:127], v16, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[24:27], v[52:55], a[128:131], v16, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[20:23], v[52:55], a[96:99], v16, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[20:23], v[56:59], a[100:103], v16, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[24:27], v[56:59], a[132:135], v16, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[28:31], v[56:59], a[164:167], v17, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[28:31], v[52:55], a[160:163], v17, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[32:35], v[52:55], a[192:195], v17, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[32:35], v[56:59], a[196:199], v17, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[32:35], v[36:39], a[176:179], v17, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[28:31], v[36:39], a[144:147], v17, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[28:31], v[40:43], a[148:151], v17, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[32:35], v[40:43], a[180:183], v17, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[32:35], v[44:47], a[184:187], v17, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[28:31], v[44:47], a[152:155], v17, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[28:31], v[48:51], a[156:159], v17, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[32:35], v[48:51], a[188:191], v17, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[32:35], v[60:63], a[200:203], v17, v71 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[28:31], v[60:63], a[168:171], v17, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[28:31], v[64:67], a[172:175], v17, v71 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[32:35], v[64:67], a[204:207], v17, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[92:95], v[124:127], a[168:171], v17, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[92:95], v[188:191], a[172:175], v17, v71 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[96:99], v[188:191], a[204:207], v17, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[96:99], v[124:127], a[200:203], v17, v71 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[4:7], v[124:127], v[148:151], v14, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[4:7], v[188:191], v[152:155], v14, v71 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[72:75], v[188:191], v[184:187], v14, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[72:75], v[124:127], v[180:183], v14, v71 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[72:75], v[100:103], v[156:159], v14, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[4:7], v[100:103], v[8:11], v14, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[4:7], v[104:107], v[128:131], v14, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[72:75], v[104:107], v[160:163], v14, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[72:75], v[108:111], v[164:167], v14, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[4:7], v[108:111], v[132:135], v14, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[4:7], v[112:115], v[136:139], v14, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[72:75], v[112:115], v[168:171], v14, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[72:75], v[116:119], v[172:175], v14, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[4:7], v[116:119], v[140:143], v14, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[4:7], v[120:123], v[144:147], v14, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[72:75], v[120:123], v[176:179], v14, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[76:79], v[120:123], a[36:39], v15, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[76:79], v[116:119], a[32:35], v15, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[80:83], v[116:119], a[64:67], v15, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[80:83], v[120:123], a[68:71], v15, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[80:83], v[100:103], a[48:51], v15, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[76:79], v[100:103], a[16:19], v15, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[76:79], v[104:107], a[20:23], v15, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[80:83], v[104:107], a[52:55], v15, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[80:83], v[108:111], a[56:59], v15, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[76:79], v[108:111], a[24:27], v15, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[76:79], v[112:115], a[28:31], v15, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[80:83], v[112:115], a[60:63], v15, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[80:83], v[124:127], a[72:75], v15, v71 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[76:79], v[124:127], a[40:43], v15, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[76:79], v[188:191], a[44:47], v15, v71 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[80:83], v[188:191], a[76:79], v15, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[84:87], v[188:191], a[108:111], v16, v71 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[84:87], v[124:127], a[104:107], v16, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[88:91], v[124:127], a[136:139], v16, v71 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[88:91], v[188:191], a[140:143], v16, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[88:91], v[100:103], a[112:115], v16, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[84:87], v[100:103], a[80:83], v16, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[84:87], v[104:107], a[84:87], v16, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[88:91], v[104:107], a[116:119], v16, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[88:91], v[108:111], a[120:123], v16, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[84:87], v[108:111], a[88:91], v16, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[84:87], v[112:115], a[92:95], v16, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[88:91], v[112:115], a[124:127], v16, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[88:91], v[116:119], a[128:131], v16, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[84:87], v[116:119], a[96:99], v16, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[84:87], v[120:123], a[100:103], v16, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[88:91], v[120:123], a[132:135], v16, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[92:95], v[120:123], a[164:167], v17, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[92:95], v[116:119], a[160:163], v17, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[96:99], v[116:119], a[192:195], v17, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[96:99], v[120:123], a[196:199], v17, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[96:99], v[100:103], a[176:179], v17, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[92:95], v[100:103], a[144:147], v17, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[92:95], v[104:107], a[148:151], v17, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[96:99], v[104:107], a[180:183], v17, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[96:99], v[108:111], a[184:187], v17, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[92:95], v[108:111], a[152:155], v17, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[92:95], v[112:115], a[156:159], v17, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[96:99], v[112:115], a[188:191], v17, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s0, s12, 1
		s_lshl_b32 s1, s0, 15
		s_add_i32 s2, s48, s1
		v_add3_u32 v3, s2, v1, v2
		ds_read_b128 v[4:7], v3
		ds_read_b128 v[12:15], v3 offset:1024
		ds_read_b128 v[16:19], v3 offset:2048
		ds_read_b128 v[20:23], v3 offset:3072
		ds_read_b128 v[24:27], v3 offset:4096
		ds_read_b128 v[28:31], v3 offset:5120
		ds_read_b128 v[32:35], v3 offset:6144
		ds_read_b128 v[36:39], v3 offset:7168
		s_add_i32 s1, s1, s46
		s_add_i32 s1, s1, 0x10000
		v_add3_u32 v1, s1, v1, v2
		ds_read_b128 v[40:43], v1
		ds_read_b128 v[44:47], v1 offset:1024
		ds_read_b128 v[48:51], v1 offset:2048
		ds_read_b128 v[52:55], v1 offset:3072
		ds_read_b128 v[56:59], v1 offset:4096
		ds_read_b128 v[60:63], v1 offset:5120
		ds_read_b128 v[64:67], v1 offset:6144
		ds_read_b128 v[68:71], v1 offset:7168
		s_lshl_b32 s0, s0, 11
		s_add_i32 s1, s45, s0
		s_add_i32 s1, s1, 0x20000
		v_and_b32_e32 v0, 63, v0
		v_lshl_add_u32 v2, v0, 2, s1
		ds_read_b32 v72, v2
		ds_read_b32 v73, v2 offset:256
		ds_read_b32 v74, v2 offset:512
		ds_read_b32 v75, v2 offset:768
		s_add_i32 s0, s0, s19
		s_add_i32 s0, s0, 0x20000
		v_lshl_add_u32 v2, v0, 2, s0
		ds_read_b32 v76, v2 offset:4096
		ds_read_b32 v77, v2 offset:4352
		ds_read_b32 v78, v2 offset:4608
		ds_read_b32 v79, v2 offset:4864
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[4:7], v[40:43], v[8:11], v72, v76 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[80:83], v3 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[4:7], v[44:47], v[128:131], v72, v76 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[84:87], v3 offset:17408
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[4:7], v[48:51], v[132:135], v72, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v3 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[4:7], v[52:55], v[136:139], v72, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v3 offset:19456
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[4:7], v[56:59], v[140:143], v72, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v3 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[4:7], v[60:63], v[144:147], v72, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v3 offset:21504
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[4:7], v[64:67], v[148:151], v72, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[104:107], v3 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[4:7], v[68:71], v[152:155], v72, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[4:7], v3 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[12:15], v[40:43], v[156:159], v72, v76 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[108:111], v1 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[12:15], v[44:47], v[160:163], v72, v76 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[112:115], v1 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[12:15], v[48:51], v[164:167], v72, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[116:119], v1 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[12:15], v[52:55], v[168:171], v72, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[120:123], v1 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[12:15], v[56:59], v[172:175], v72, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[124:127], v1 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[12:15], v[60:63], v[176:179], v72, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[188:191], v1 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[12:15], v[64:67], v[180:183], v72, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[192:195], v1 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[12:15], v[68:71], v[184:187], v72, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[12:15], v1 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[16:19], v[40:43], a[16:19], v73, v76 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[16:19], v[44:47], a[20:23], v73, v76 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[20:23], v[44:47], a[52:55], v73, v76 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[20:23], v[40:43], a[48:51], v73, v76 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[20:23], v[48:51], a[56:59], v73, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[16:19], v[48:51], a[24:27], v73, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[16:19], v[52:55], a[28:31], v73, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[20:23], v[52:55], a[60:63], v73, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[20:23], v[56:59], a[64:67], v73, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[16:19], v[56:59], a[32:35], v73, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[16:19], v[60:63], a[36:39], v73, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[20:23], v[60:63], a[68:71], v73, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[20:23], v[64:67], a[72:75], v73, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[16:19], v[64:67], a[40:43], v73, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[16:19], v[68:71], a[44:47], v73, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[20:23], v[68:71], a[76:79], v73, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[24:27], v[68:71], a[108:111], v74, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[24:27], v[64:67], a[104:107], v74, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[28:31], v[64:67], a[136:139], v74, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[28:31], v[68:71], a[140:143], v74, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[28:31], v[40:43], a[112:115], v74, v76 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[24:27], v[40:43], a[80:83], v74, v76 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[24:27], v[44:47], a[84:87], v74, v76 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[28:31], v[44:47], a[116:119], v74, v76 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[28:31], v[48:51], a[120:123], v74, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[24:27], v[48:51], a[88:91], v74, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[24:27], v[52:55], a[92:95], v74, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[28:31], v[52:55], a[124:127], v74, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[28:31], v[56:59], a[128:131], v74, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[24:27], v[56:59], a[96:99], v74, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[24:27], v[60:63], a[100:103], v74, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[28:31], v[60:63], a[132:135], v74, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[32:35], v[60:63], a[164:167], v75, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[32:35], v[56:59], a[160:163], v75, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[36:39], v[56:59], a[192:195], v75, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[36:39], v[60:63], a[196:199], v75, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[36:39], v[40:43], a[176:179], v75, v76 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], v[40:43], a[144:147], v75, v76 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[32:35], v[44:47], a[148:151], v75, v76 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[36:39], v[44:47], a[180:183], v75, v76 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[36:39], v[48:51], a[184:187], v75, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[32:35], v[48:51], a[152:155], v75, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[32:35], v[52:55], a[156:159], v75, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[36:39], v[52:55], a[188:191], v75, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[36:39], v[64:67], a[200:203], v75, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[32:35], v[64:67], a[168:171], v75, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[32:35], v[68:71], a[172:175], v75, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[36:39], v[68:71], a[204:207], v75, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[104:107], v[192:195], a[168:171], v75, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[104:107], v[12:15], a[172:175], v75, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[4:7], v[12:15], a[204:207], v75, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[4:7], v[192:195], a[200:203], v75, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[80:83], v[192:195], v[148:151], v72, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[80:83], v[12:15], v[152:155], v72, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[84:87], v[12:15], v[184:187], v72, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[84:87], v[192:195], v[180:183], v72, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[84:87], v[108:111], v[156:159], v72, v76 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[80:83], v[108:111], v[8:11], v72, v76 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[80:83], v[112:115], v[128:131], v72, v76 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[84:87], v[112:115], v[160:163], v72, v76 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[84:87], v[116:119], v[164:167], v72, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[80:83], v[116:119], v[132:135], v72, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[80:83], v[120:123], v[136:139], v72, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[84:87], v[120:123], v[168:171], v72, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[84:87], v[124:127], v[172:175], v72, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[80:83], v[124:127], v[140:143], v72, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[80:83], v[188:191], v[144:147], v72, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[84:87], v[188:191], v[176:179], v72, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[88:91], v[188:191], a[36:39], v73, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[88:91], v[124:127], a[32:35], v73, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[92:95], v[124:127], a[64:67], v73, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[92:95], v[188:191], a[68:71], v73, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[92:95], v[108:111], a[48:51], v73, v76 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[88:91], v[108:111], a[16:19], v73, v76 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[88:91], v[112:115], a[20:23], v73, v76 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[92:95], v[112:115], a[52:55], v73, v76 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[92:95], v[116:119], a[56:59], v73, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[88:91], v[116:119], a[24:27], v73, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[88:91], v[120:123], a[28:31], v73, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[92:95], v[120:123], a[60:63], v73, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[92:95], v[192:195], a[72:75], v73, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[88:91], v[192:195], a[40:43], v73, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[88:91], v[12:15], a[44:47], v73, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[92:95], v[12:15], a[76:79], v73, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[96:99], v[12:15], a[108:111], v74, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[96:99], v[192:195], a[104:107], v74, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[100:103], v[192:195], a[136:139], v74, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[100:103], v[12:15], a[140:143], v74, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[100:103], v[108:111], a[112:115], v74, v76 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[96:99], v[108:111], a[80:83], v74, v76 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[96:99], v[112:115], a[84:87], v74, v76 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[100:103], v[112:115], a[116:119], v74, v76 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[100:103], v[116:119], a[120:123], v74, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[96:99], v[116:119], a[88:91], v74, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[96:99], v[120:123], a[92:95], v74, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[100:103], v[120:123], a[124:127], v74, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[100:103], v[124:127], a[128:131], v74, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[96:99], v[124:127], a[96:99], v74, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[96:99], v[188:191], a[100:103], v74, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[100:103], v[188:191], a[132:135], v74, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[104:107], v[188:191], a[164:167], v75, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[104:107], v[124:127], a[160:163], v75, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[4:7], v[124:127], a[192:195], v75, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[4:7], v[188:191], a[196:199], v75, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[4:7], v[108:111], a[176:179], v75, v76 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[104:107], v[108:111], a[144:147], v75, v76 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[104:107], v[112:115], a[148:151], v75, v76 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[4:7], v[112:115], a[180:183], v75, v76 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[4:7], v[116:119], a[184:187], v75, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[104:107], v[116:119], a[152:155], v75, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[104:107], v[120:123], a[156:159], v75, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[4:7], v[120:123], a[188:191], v75, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v8, v9
		v_cvt_pk_f16_f32 v3, v10, v11
		v_lshlrev_b32_e32 v0, 3, v0
		s_lshl_b32 s0, s13, 21
		s_lshl_b32 s1, s14, 17
		s_add_i32 s0, s0, s1
		s_lshl_b32 s1, s8, 15
		s_add_i32 s0, s0, s1
		s_mov_b32 s16, s6
		s_mov_b32 s17, s7
		s_mov_b32 s19, s23
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen
		v_cvt_pk_f16_f32 v2, v128, v129
		v_cvt_pk_f16_f32 v3, v130, v131
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:512
		v_cvt_pk_f16_f32 v2, v132, v133
		v_cvt_pk_f16_f32 v3, v134, v135
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v136, v137
		v_cvt_pk_f16_f32 v3, v138, v139
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:1536
		v_cvt_pk_f16_f32 v2, v140, v141
		v_cvt_pk_f16_f32 v3, v142, v143
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v144, v145
		v_cvt_pk_f16_f32 v3, v146, v147
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v148, v149
		v_cvt_pk_f16_f32 v3, v150, v151
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v152, v153
		v_cvt_pk_f16_f32 v3, v154, v155
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:3584
		v_cvt_pk_f16_f32 v2, v156, v157
		v_cvt_pk_f16_f32 v3, v158, v159
		s_add_i32 s1, s0, 0x1000
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s1 offen
		v_cvt_pk_f16_f32 v2, v160, v161
		v_cvt_pk_f16_f32 v3, v162, v163
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s1 offen offset:512
		v_cvt_pk_f16_f32 v2, v164, v165
		v_cvt_pk_f16_f32 v3, v166, v167
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s1 offen offset:1024
		v_cvt_pk_f16_f32 v2, v168, v169
		v_cvt_pk_f16_f32 v3, v170, v171
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s1 offen offset:1536
		v_cvt_pk_f16_f32 v2, v172, v173
		v_cvt_pk_f16_f32 v3, v174, v175
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s1 offen offset:2048
		v_cvt_pk_f16_f32 v2, v176, v177
		v_cvt_pk_f16_f32 v3, v178, v179
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s1 offen offset:2560
		v_cvt_pk_f16_f32 v2, v180, v181
		v_cvt_pk_f16_f32 v3, v182, v183
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s1 offen offset:3072
		v_cvt_pk_f16_f32 v2, v184, v185
		v_cvt_pk_f16_f32 v3, v186, v187
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s1 offen offset:3584
		v_accvgpr_read_b32 v1, a16
		v_accvgpr_read_b32 v2, a17
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a18
		v_accvgpr_read_b32 v2, a19
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s1, s0, 0x2000
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen
		v_accvgpr_read_b32 v1, a20
		v_accvgpr_read_b32 v2, a21
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a22
		v_accvgpr_read_b32 v2, a23
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:512
		v_accvgpr_read_b32 v1, a24
		v_accvgpr_read_b32 v2, a25
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a26
		v_accvgpr_read_b32 v2, a27
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:1024
		v_accvgpr_read_b32 v1, a28
		v_accvgpr_read_b32 v2, a29
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a30
		v_accvgpr_read_b32 v2, a31
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:1536
		v_accvgpr_read_b32 v1, a32
		v_accvgpr_read_b32 v2, a33
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a34
		v_accvgpr_read_b32 v2, a35
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:2048
		v_accvgpr_read_b32 v1, a36
		v_accvgpr_read_b32 v2, a37
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a38
		v_accvgpr_read_b32 v2, a39
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:2560
		v_accvgpr_read_b32 v1, a40
		v_accvgpr_read_b32 v2, a41
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a42
		v_accvgpr_read_b32 v2, a43
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:3072
		v_accvgpr_read_b32 v1, a44
		v_accvgpr_read_b32 v2, a45
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a46
		v_accvgpr_read_b32 v2, a47
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:3584
		v_accvgpr_read_b32 v1, a48
		v_accvgpr_read_b32 v2, a49
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a50
		v_accvgpr_read_b32 v2, a51
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s1, s0, 0x3000
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen
		v_accvgpr_read_b32 v1, a52
		v_accvgpr_read_b32 v2, a53
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a54
		v_accvgpr_read_b32 v2, a55
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:512
		v_accvgpr_read_b32 v1, a56
		v_accvgpr_read_b32 v2, a57
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a58
		v_accvgpr_read_b32 v2, a59
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:1024
		v_accvgpr_read_b32 v1, a60
		v_accvgpr_read_b32 v2, a61
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a62
		v_accvgpr_read_b32 v2, a63
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:1536
		v_accvgpr_read_b32 v1, a64
		v_accvgpr_read_b32 v2, a65
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a66
		v_accvgpr_read_b32 v2, a67
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:2048
		v_accvgpr_read_b32 v1, a68
		v_accvgpr_read_b32 v2, a69
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a70
		v_accvgpr_read_b32 v2, a71
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:2560
		v_accvgpr_read_b32 v1, a72
		v_accvgpr_read_b32 v2, a73
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a74
		v_accvgpr_read_b32 v2, a75
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:3072
		v_accvgpr_read_b32 v1, a76
		v_accvgpr_read_b32 v2, a77
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a78
		v_accvgpr_read_b32 v2, a79
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:3584
		v_accvgpr_read_b32 v1, a80
		v_accvgpr_read_b32 v2, a81
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a82
		v_accvgpr_read_b32 v2, a83
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s1, s0, 0x4000
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen
		v_accvgpr_read_b32 v1, a84
		v_accvgpr_read_b32 v2, a85
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a86
		v_accvgpr_read_b32 v2, a87
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:512
		v_accvgpr_read_b32 v1, a88
		v_accvgpr_read_b32 v2, a89
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a90
		v_accvgpr_read_b32 v2, a91
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:1024
		v_accvgpr_read_b32 v1, a92
		v_accvgpr_read_b32 v2, a93
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a94
		v_accvgpr_read_b32 v2, a95
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:1536
		v_accvgpr_read_b32 v1, a96
		v_accvgpr_read_b32 v2, a97
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a98
		v_accvgpr_read_b32 v2, a99
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:2048
		v_accvgpr_read_b32 v1, a100
		v_accvgpr_read_b32 v2, a101
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a102
		v_accvgpr_read_b32 v2, a103
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:2560
		v_accvgpr_read_b32 v1, a104
		v_accvgpr_read_b32 v2, a105
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a106
		v_accvgpr_read_b32 v2, a107
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:3072
		v_accvgpr_read_b32 v1, a108
		v_accvgpr_read_b32 v2, a109
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a110
		v_accvgpr_read_b32 v2, a111
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:3584
		v_accvgpr_read_b32 v1, a112
		v_accvgpr_read_b32 v2, a113
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a114
		v_accvgpr_read_b32 v2, a115
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s1, s0, 0x5000
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen
		v_accvgpr_read_b32 v1, a116
		v_accvgpr_read_b32 v2, a117
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a118
		v_accvgpr_read_b32 v2, a119
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:512
		v_accvgpr_read_b32 v1, a120
		v_accvgpr_read_b32 v2, a121
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a122
		v_accvgpr_read_b32 v2, a123
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:1024
		v_accvgpr_read_b32 v1, a124
		v_accvgpr_read_b32 v2, a125
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a126
		v_accvgpr_read_b32 v2, a127
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:1536
		v_accvgpr_read_b32 v1, a128
		v_accvgpr_read_b32 v2, a129
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a130
		v_accvgpr_read_b32 v2, a131
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:2048
		v_accvgpr_read_b32 v1, a132
		v_accvgpr_read_b32 v2, a133
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a134
		v_accvgpr_read_b32 v2, a135
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:2560
		v_accvgpr_read_b32 v1, a136
		v_accvgpr_read_b32 v2, a137
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a138
		v_accvgpr_read_b32 v2, a139
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:3072
		v_accvgpr_read_b32 v1, a140
		v_accvgpr_read_b32 v2, a141
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a142
		v_accvgpr_read_b32 v2, a143
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:3584
		v_accvgpr_read_b32 v1, a144
		v_accvgpr_read_b32 v2, a145
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a146
		v_accvgpr_read_b32 v2, a147
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s1, s0, 0x6000
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen
		v_accvgpr_read_b32 v1, a148
		v_accvgpr_read_b32 v2, a149
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a150
		v_accvgpr_read_b32 v2, a151
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:512
		v_accvgpr_read_b32 v1, a152
		v_accvgpr_read_b32 v2, a153
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a154
		v_accvgpr_read_b32 v2, a155
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:1024
		v_accvgpr_read_b32 v1, a156
		v_accvgpr_read_b32 v2, a157
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a158
		v_accvgpr_read_b32 v2, a159
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:1536
		v_accvgpr_read_b32 v1, a160
		v_accvgpr_read_b32 v2, a161
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a162
		v_accvgpr_read_b32 v2, a163
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:2048
		v_accvgpr_read_b32 v1, a164
		v_accvgpr_read_b32 v2, a165
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a166
		v_accvgpr_read_b32 v2, a167
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:2560
		v_accvgpr_read_b32 v1, a168
		v_accvgpr_read_b32 v2, a169
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a170
		v_accvgpr_read_b32 v2, a171
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:3072
		v_accvgpr_read_b32 v1, a172
		v_accvgpr_read_b32 v2, a173
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a174
		v_accvgpr_read_b32 v2, a175
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s1 offen offset:3584
		v_accvgpr_read_b32 v1, a176
		v_accvgpr_read_b32 v2, a177
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a178
		v_accvgpr_read_b32 v2, a179
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s0, s0, 0x7000
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen
		v_accvgpr_read_b32 v1, a180
		v_accvgpr_read_b32 v2, a181
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a182
		v_accvgpr_read_b32 v2, a183
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:512
		v_accvgpr_read_b32 v1, a184
		v_accvgpr_read_b32 v2, a185
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a186
		v_accvgpr_read_b32 v2, a187
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:1024
		v_accvgpr_read_b32 v1, a188
		v_accvgpr_read_b32 v2, a189
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a190
		v_accvgpr_read_b32 v2, a191
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:1536
		v_accvgpr_read_b32 v1, a192
		v_accvgpr_read_b32 v2, a193
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a194
		v_accvgpr_read_b32 v2, a195
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:2048
		v_accvgpr_read_b32 v1, a196
		v_accvgpr_read_b32 v2, a197
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a198
		v_accvgpr_read_b32 v2, a199
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:2560
		v_accvgpr_read_b32 v1, a200
		v_accvgpr_read_b32 v2, a201
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a202
		v_accvgpr_read_b32 v2, a203
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:3072
		v_accvgpr_read_b32 v1, a204
		v_accvgpr_read_b32 v2, a205
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a206
		v_accvgpr_read_b32 v2, a207
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s0 offen offset:3584
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 163840
		.amdhsa_private_segment_fixed_size 160
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
		.amdhsa_next_free_sgpr 60
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
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 60
	.set .Lwmma_f16_matmul_tiled.num_named_barrier, 0
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 160
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
    .group_segment_fixed_size: 163840
    .kernarg_segment_align: 8
    .kernarg_segment_size: 48
    .max_flat_workgroup_size: 256
    .name:           wmma_f16_matmul_tiled
    .private_segment_fixed_size: 160
    .sgpr_count:     60
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     512
    .agpr_count:     256
    .vgpr_spill_count: 40
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 114
    wave.regalloc.agpr.dwords: 306
    wave.regalloc.remat.dwords: 12
    wave.regalloc.sgpr_to_vgpr.dwords: 0
    wave.regalloc.lds.dwords: 24
    wave.regalloc.scratch.dwords: 40
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
