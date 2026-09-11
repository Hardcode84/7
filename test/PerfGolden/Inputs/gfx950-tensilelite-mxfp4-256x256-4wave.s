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
		s_mov_b32 s19, 0x31016000
		s_mov_b32 s18, 0x1000000
		s_mov_b32 s16, s2
		s_mov_b32 s17, s3
		s_mov_b32 s0, s4
		s_mov_b32 s1, s5
		s_mov_b32 s2, s18
		s_mov_b32 s3, s19
		s_mov_b32 s20, s8
		s_mov_b32 s21, s9
		s_mov_b32 s22, s18
		s_mov_b32 s23, s19
		s_mov_b32 s24, s10
		s_mov_b32 s25, s11
		s_mov_b32 s26, s18
		s_mov_b32 s27, s19
		v_readfirstlane_b32 s4, v0
		s_lshr_b32 s8, s4, 6
		v_readfirstlane_b32 s5, v0
		s_lshl_b32 s10, s13, 20
		s_lshl_b32 s9, s8, 16
		s_add_i32 s11, s10, s9
		v_and_b32_e32 v1, 63, v0
		v_lshrrev_b32_e32 v2, 2, v1
		v_lshlrev_b32_e32 v2, 12, v2
		v_lshrrev_b32_e32 v3, 3, v1
		v_bitop3_b32 v3, v3, 3, v1 bitop3:0x48
		v_lshlrev_b32_e32 v3, 4, v3
		v_add3_u32 v4, s11, v2, v3
		s_add_i32 s11, s10, 0x40000
		s_add_i32 s11, s11, s9
		s_add_i32 s28, s10, 0x80000
		s_add_i32 s28, s28, s9
		s_add_i32 s29, s10, 0xc0000
		s_add_i32 s29, s29, s9
		s_add_i32 s30, s10, 64
		s_add_i32 s30, s30, s9
		s_add_i32 s31, s10, 0x40040
		s_add_i32 s31, s31, s9
		s_add_i32 s32, s10, 0x80040
		s_add_i32 s32, s32, s9
		s_add_i32 s33, s10, 0xc0040
		s_add_i32 s33, s33, s9
		s_lshl_b32 s34, s14, 20
		s_add_i32 s35, s34, s9
		s_add_i32 s36, s34, 0x40000
		s_add_i32 s36, s36, s9
		s_add_i32 s37, s34, 0x80000
		s_add_i32 s37, s37, s9
		s_add_i32 s38, s34, 0xc0000
		s_add_i32 s38, s38, s9
		s_add_i32 s39, s34, 64
		s_add_i32 s39, s39, s9
		s_add_i32 s40, s34, 0x40040
		s_add_i32 s40, s40, s9
		s_add_i32 s41, s34, 0x80040
		s_add_i32 s41, s41, s9
		s_add_i32 s42, s34, 0xc0040
		s_add_i32 s42, s42, s9
		s_lshr_b32 s43, s5, 6
		s_lshl_b32 s44, s43, 10
		s_add_i32 m0, s44, 0x6000
		v_mov_b64_e32 v[8:9], 0
		v_mov_b64_e32 v[10:11], 0
		buffer_load_dwordx4 v4, s[16:19], 0 offen lds
		v_add3_u32 v4, s11, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v5, s28, v2, v3
		buffer_load_dwordx4 v4, s[16:19], 0 offen lds
		v_add3_u32 v4, s29, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v6, s30, v2, v3
		buffer_load_dwordx4 v5, s[16:19], 0 offen lds
		v_add3_u32 v5, s31, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v7, s32, v2, v3
		buffer_load_dwordx4 v4, s[16:19], 0 offen lds
		v_add3_u32 v4, s33, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v12, s35, v2, v3
		buffer_load_dwordx4 v6, s[16:19], 0 offen lds
		v_add3_u32 v6, s36, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v13, s37, v2, v3
		buffer_load_dwordx4 v5, s[16:19], 0 offen lds
		v_add3_u32 v5, s38, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v14, s39, v2, v3
		buffer_load_dwordx4 v7, s[16:19], 0 offen lds
		v_add3_u32 v7, s40, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v15, s41, v2, v3
		buffer_load_dwordx4 v4, s[16:19], 0 offen lds
		v_add3_u32 v4, s42, v2, v3
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s30, 0x80000000
		buffer_load_dwordx4 v12, s[0:3], 0 offen lds
		v_mov_b32_e32 v17, 0
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v6, s[0:3], 0 offen lds
		s_and_b32 s11, s12, 1
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s28, 0x800
		s_mov_b32 s29, 0
		buffer_load_dwordx4 v13, s[0:3], 0 offen lds
		s_mov_b32 s32, 0x400
		s_mov_b32 s33, 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b32_e32 v16, s14
		buffer_load_dwordx4 v5, s[0:3], 0 offen lds
		s_mov_b32 s36, 0x80
		s_mov_b32 s37, 0
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s38, 16
		s_mov_b32 s39, 0
		buffer_load_dwordx4 v14, s[0:3], 0 offen lds
		v_lshlrev_b32_e32 v5, 2, v1
		s_add_i32 m0, m0, 0x1000
		s_and_b32 s31, s8, 1
		buffer_load_dwordx4 v7, s[0:3], 0 offen lds
		v_lshrrev_b32_e32 v6, 4, v1
		s_add_i32 m0, m0, 0x1000
		s_and_b32 s35, s43, 1
		buffer_load_dwordx4 v15, s[0:3], 0 offen lds
		s_lshr_b32 s40, s8, 1
		s_add_i32 m0, m0, 0x1000
		s_lshl_b32 s41, s14, 16
		buffer_load_dwordx4 v4, s[0:3], 0 offen lds
		s_add_i32 s42, s10, s41
		s_lshl_b32 s43, s40, 10
		s_add_i32 s45, s42, s43
		s_lshr_b32 s5, s5, 7
		s_lshl_b32 s46, s5, 10
		v_and_b32_e32 v4, 0x7f, v0
		s_lshl_b32 s5, s35, 10
		v_lshl_add_u32 v7, v1, 4, s45
		s_add_i32 m0, s46, 0x26000
		s_nop 0
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		v_lshl_add_u32 v7, v4, 4, s42
		s_add_i32 s35, s5, 0x800
		s_add_i32 m0, s5, 0x26800
		s_nop 0
		buffer_load_dwordx4 v7, s[24:27], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		s_lshl_b32 s42, s40, 13
		v_and_b32_e32 v7, 15, v0
		v_lshlrev_b32_e32 v12, 6, v7
		v_lshrrev_b32_e32 v7, 1, v7
		v_bitop3_b32 v6, v6, v7, 3 bitop3:0x78
		v_lshlrev_b32_e32 v6, 4, v6
		v_add3_u32 v7, s42, v12, v6
		v_add_u32_e32 v7, 0x6000, v7
		ds_read_b128 a[0:3], v7
		ds_read_b128 a[4:7], v7 offset:1024
		ds_read_b128 a[8:11], v7 offset:2048
		ds_read_b128 a[12:15], v7 offset:3072
		ds_read_b128 v[20:23], v7 offset:4096
		ds_read_b128 v[24:27], v7 offset:5120
		ds_read_b128 v[28:31], v7 offset:6144
		ds_read_b128 v[32:35], v7 offset:7168
		s_lshl_b32 s45, s31, 13
		v_add3_u32 v7, s45, v12, v6
		v_add_u32_e32 v7, 0x6000, v7
		ds_read_b128 v[36:39], v7 offset:32768
		ds_read_b128 v[40:43], v7 offset:33792
		ds_read_b128 v[44:47], v7 offset:34816
		ds_read_b128 v[48:51], v7 offset:35840
		ds_read_b128 v[52:55], v7 offset:36864
		ds_read_b128 v[56:59], v7 offset:37888
		ds_read_b128 v[60:63], v7 offset:38912
		ds_read_b128 v[64:67], v7 offset:39936
		s_add_i32 s47, s43, 0x20000
		v_add_u32_e32 v7, s47, v5
		v_add_u32_e32 v7, 0x6000, v7
		ds_read_b32 v13, v7
		ds_read_b32 v14, v7 offset:256
		ds_read_b32 v15, v7 offset:512
		ds_read_b32 v18, v7 offset:768
		s_lshl_b32 s31, s31, 10
		s_add_i32 s48, s31, 0x20000
		v_add_u32_e32 v5, s48, v5
		v_add_u32_e32 v5, 0x6000, v5
		ds_read_b32 v7, v5 offset:2048
		ds_read_b32 v19, v5 offset:2304
		ds_read_b32 v68, v5 offset:2560
		ds_read_b32 v69, v5 offset:2816
		s_add_i32 s49, s10, 0x80
		s_add_i32 s49, s49, s9
		s_add_i32 s50, s10, 0x40080
		s_add_i32 s50, s50, s9
		s_add_i32 s51, s10, 0x80080
		s_add_i32 s51, s51, s9
		s_add_i32 s52, s10, 0xc0080
		s_add_i32 s52, s52, s9
		s_add_i32 s53, s10, 0xc0
		s_add_i32 s53, s53, s9
		s_add_i32 s54, s10, 0x400c0
		s_add_i32 s54, s54, s9
		s_add_i32 s55, s10, 0x800c0
		s_add_i32 s55, s55, s9
		s_add_i32 s56, s10, 0xc00c0
		s_add_i32 s56, s56, s9
		s_add_i32 s57, s34, 0x80
		s_add_i32 s57, s57, s9
		s_add_i32 s58, s34, 0x40080
		s_add_i32 s58, s58, s9
		s_add_i32 s59, s34, 0x80080
		s_add_i32 s59, s59, s9
		s_add_i32 s60, s34, 0xc0080
		s_add_i32 s60, s60, s9
		s_add_i32 s61, s34, 0xc0
		s_add_i32 s61, s61, s9
		s_add_i32 s62, s34, 0x400c0
		s_add_i32 s62, s62, s9
		s_add_i32 s63, s34, 0x800c0
		s_add_i32 s63, s63, s9
		s_add_i32 s34, s34, 0xc00c0
		s_add_i32 s9, s34, s9
		s_add_i32 m0, s44, 0x16000
		v_add3_u32 v5, s49, v2, v3
		buffer_load_dwordx4 v5, s[16:19], 0 offen lds
		v_add3_u32 v5, s50, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v70, s51, v2, v3
		buffer_load_dwordx4 v5, s[16:19], 0 offen lds
		v_add3_u32 v5, s52, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v71, s53, v2, v3
		buffer_load_dwordx4 v70, s[16:19], 0 offen lds
		v_add3_u32 v70, s54, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v72, s55, v2, v3
		buffer_load_dwordx4 v5, s[16:19], 0 offen lds
		v_add3_u32 v5, s56, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v73, s57, v2, v3
		buffer_load_dwordx4 v71, s[16:19], 0 offen lds
		v_add3_u32 v71, s58, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v74, s59, v2, v3
		buffer_load_dwordx4 v70, s[16:19], 0 offen lds
		v_add3_u32 v70, s60, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v75, s61, v2, v3
		buffer_load_dwordx4 v72, s[16:19], 0 offen lds
		v_add3_u32 v72, s62, v2, v3
		s_add_i32 m0, m0, 0x1000
		v_add3_u32 v76, s63, v2, v3
		buffer_load_dwordx4 v5, s[16:19], 0 offen lds
		v_add3_u32 v2, s9, v2, v3
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s34, s44, 0x10000
		buffer_load_dwordx4 v73, s[0:3], 0 offen lds
		v_mov_b32_e32 v3, 3
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s50, 0x1000
		s_mov_b32 s51, 0
		buffer_load_dwordx4 v71, s[0:3], 0 offen lds
		v_mov_b32_e32 v5, 63
		s_add_i32 m0, m0, 0x1000
		v_mov_b32_e32 v71, v0
		buffer_load_dwordx4 v74, s[0:3], 0 offen lds
		s_mov_b32 s52, 1
		s_mov_b32 s53, 0
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s54, 0x100000
		s_mov_b32 s55, 0
		buffer_load_dwordx4 v70, s[0:3], 0 offen lds
		v_mov_b32_e32 v79, 0
		s_add_i32 m0, m0, 0x1000
		v_mov_b32_e32 v78, s13
		buffer_load_dwordx4 v75, s[0:3], 0 offen lds
		s_mov_b32 s56, 0x10000
		s_mov_b32 s57, 0
		s_add_i32 m0, m0, 0x1000
		s_mov_b32 s9, 0
		buffer_load_dwordx4 v72, s[0:3], 0 offen lds
		s_mov_b32 s49, 2
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s58, s12, 1
		buffer_load_dwordx4 v76, s[0:3], 0 offen lds
		s_add_i32 s59, s46, 0x1000
		s_add_i32 m0, m0, 0x1000
		s_add_i32 s10, s10, 0x800
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_add_i32 s10, s10, s41
		s_add_i32 s41, s10, s43
		v_lshl_add_u32 v1, v1, 4, s41
		s_add_i32 m0, s46, 0x27000
		s_nop 0
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		v_lshl_add_u32 v1, v4, 4, s10
		s_add_i32 s10, s5, 0x1800
		s_add_i32 m0, s5, 0x27800
		s_nop 0
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		s_mul_i32 s60, s56, s8
		s_mul_hi_u32 s61, s56, s8
		s_mul_i32 s5, s56, s9
		s_add_i32 s61, s61, s5
		s_mul_i32 s5, s57, s8
		s_add_i32 s61, s61, s5
		v_mov_b32_e32 v72, s54
		v_mov_b32_e32 v73, s55
		v_mul_lo_u32 v74, v72, v78
		v_mul_hi_u32 v75, v72, v78
		v_mul_lo_u32 v1, v72, v79
		v_add_u32_e32 v75, v75, v1
		v_mul_lo_u32 v1, v73, v78
		v_add_u32_e32 v75, v75, v1
		v_mov_b32_e32 v76, s60
		v_mov_b32_e32 v77, s61
		v_add_co_u32_e64 v80, vcc, v76, v74
		v_addc_co_u32_e64 v81, vcc, v77, v75, vcc
		v_and_b32_e32 v82, v71, v5
		v_and_b32_e32 v83, v79, v79
		v_mov_b32_e32 v4, s52
		v_mov_b32_e32 v5, s53
		v_mul_lo_u32 v84, v4, v82
		v_mul_hi_u32 v85, v4, v82
		v_mul_lo_u32 v1, v4, v83
		v_add_u32_e32 v85, v85, v1
		v_mul_lo_u32 v1, v5, v82
		v_add_u32_e32 v85, v85, v1
		v_lshrrev_b64 v[4:5], 2, v[84:85]
		v_mov_b32_e32 v86, s50
		v_mov_b32_e32 v87, s51
		v_mul_lo_u32 v88, v86, v4
		v_mul_hi_u32 v89, v86, v4
		v_mul_lo_u32 v1, v86, v5
		v_add_u32_e32 v89, v89, v1
		v_mul_lo_u32 v1, v87, v4
		v_add_u32_e32 v89, v89, v1
		v_add_co_u32_e64 v4, vcc, v80, v88
		v_addc_co_u32_e64 v5, vcc, v81, v89, vcc
		v_lshrrev_b64 v[80:81], 3, v[84:85]
		v_and_b32_e32 v84, v80, v3
		v_and_b32_e32 v85, v81, v79
		v_and_b32_e32 v80, v82, v3
		v_and_b32_e32 v81, v83, v79
		v_xor_b32_e32 v2, v84, v80
		v_xor_b32_e32 v3, v85, v81
		v_mov_b32_e32 v78, s38
		v_mov_b32_e32 v79, s39
		v_mul_lo_u32 v80, v78, v2
		v_mul_hi_u32 v81, v78, v2
		v_mul_lo_u32 v1, v78, v3
		v_add_u32_e32 v81, v81, v1
		v_mul_lo_u32 v1, v79, v2
		v_add_u32_e32 v81, v81, v1
		v_add_co_u32_e64 v2, vcc, v4, v80
		v_addc_co_u32_e64 v3, vcc, v5, v81, vcc
		v_mov_b32_e32 v4, s36
		v_mov_b32_e32 v5, s37
		s_add_u32 s36, s60, 0x40000
		s_addc_u32 s37, s61, 0
		v_mov_b32_e32 v84, s36
		v_mov_b32_e32 v85, s37
		v_add_co_u32_e64 v86, vcc, v84, v74
		v_addc_co_u32_e64 v87, vcc, v85, v75, vcc
		v_add_co_u32_e64 v90, vcc, v86, v88
		v_addc_co_u32_e64 v91, vcc, v87, v89, vcc
		v_add_co_u32_e64 v86, vcc, v90, v80
		v_addc_co_u32_e64 v87, vcc, v91, v81, vcc
		s_add_u32 s36, s60, 0x80000
		s_addc_u32 s37, s61, 0
		v_mov_b32_e32 v90, s36
		v_mov_b32_e32 v91, s37
		v_add_co_u32_e64 v92, vcc, v90, v74
		v_addc_co_u32_e64 v93, vcc, v91, v75, vcc
		v_add_co_u32_e64 v94, vcc, v92, v88
		v_addc_co_u32_e64 v95, vcc, v93, v89, vcc
		v_add_co_u32_e64 v92, vcc, v94, v80
		v_addc_co_u32_e64 v93, vcc, v95, v81, vcc
		s_add_u32 s36, s60, 0xc0000
		s_addc_u32 s37, s61, 0
		v_mov_b32_e32 v94, s36
		v_mov_b32_e32 v95, s37
		v_add_co_u32_e64 v96, vcc, v94, v74
		v_addc_co_u32_e64 v97, vcc, v95, v75, vcc
		v_add_co_u32_e64 v98, vcc, v96, v88
		v_addc_co_u32_e64 v99, vcc, v97, v89, vcc
		v_add_co_u32_e64 v96, vcc, v98, v80
		v_addc_co_u32_e64 v97, vcc, v99, v81, vcc
		s_add_u32 s36, s60, 64
		s_addc_u32 s37, s61, 0
		v_mov_b32_e32 v98, s36
		v_mov_b32_e32 v99, s37
		v_add_co_u32_e64 v100, vcc, v98, v74
		v_addc_co_u32_e64 v101, vcc, v99, v75, vcc
		v_add_co_u32_e64 v102, vcc, v100, v88
		v_addc_co_u32_e64 v103, vcc, v101, v89, vcc
		v_add_co_u32_e64 v100, vcc, v102, v80
		v_addc_co_u32_e64 v101, vcc, v103, v81, vcc
		s_add_u32 s36, s60, 0x40040
		s_addc_u32 s37, s61, 0
		v_mov_b32_e32 v102, s36
		v_mov_b32_e32 v103, s37
		v_add_co_u32_e64 v104, vcc, v102, v74
		v_addc_co_u32_e64 v105, vcc, v103, v75, vcc
		v_add_co_u32_e64 v106, vcc, v104, v88
		v_addc_co_u32_e64 v107, vcc, v105, v89, vcc
		v_add_co_u32_e64 v104, vcc, v106, v80
		v_addc_co_u32_e64 v105, vcc, v107, v81, vcc
		s_add_u32 s36, s60, 0x80040
		s_addc_u32 s37, s61, 0
		v_mov_b32_e32 v106, s36
		v_mov_b32_e32 v107, s37
		v_add_co_u32_e64 v108, vcc, v106, v74
		v_addc_co_u32_e64 v109, vcc, v107, v75, vcc
		v_add_co_u32_e64 v110, vcc, v108, v88
		v_addc_co_u32_e64 v111, vcc, v109, v89, vcc
		v_add_co_u32_e64 v108, vcc, v110, v80
		v_addc_co_u32_e64 v109, vcc, v111, v81, vcc
		s_add_u32 s36, s60, 0xc0040
		s_addc_u32 s37, s61, 0
		v_mov_b32_e32 v110, s36
		v_mov_b32_e32 v111, s37
		v_add_co_u32_e64 v112, vcc, v110, v74
		v_addc_co_u32_e64 v113, vcc, v111, v75, vcc
		v_add_co_u32_e64 v114, vcc, v112, v88
		v_addc_co_u32_e64 v115, vcc, v113, v89, vcc
		v_add_co_u32_e64 v112, vcc, v114, v80
		v_addc_co_u32_e64 v113, vcc, v115, v81, vcc
		v_mul_lo_u32 v114, v72, v16
		v_mul_hi_u32 v115, v72, v16
		v_mul_lo_u32 v1, v72, v17
		v_add_u32_e32 v115, v115, v1
		v_mul_lo_u32 v1, v73, v16
		v_add_u32_e32 v115, v115, v1
		v_add_co_u32_e64 v72, vcc, v76, v114
		v_addc_co_u32_e64 v73, vcc, v77, v115, vcc
		v_add_co_u32_e64 v76, vcc, v72, v88
		v_addc_co_u32_e64 v77, vcc, v73, v89, vcc
		v_add_co_u32_e64 v72, vcc, v76, v80
		v_addc_co_u32_e64 v73, vcc, v77, v81, vcc
		v_add_co_u32_e64 v76, vcc, v84, v114
		v_addc_co_u32_e64 v77, vcc, v85, v115, vcc
		v_add_co_u32_e64 v84, vcc, v76, v88
		v_addc_co_u32_e64 v85, vcc, v77, v89, vcc
		v_add_co_u32_e64 v76, vcc, v84, v80
		v_addc_co_u32_e64 v77, vcc, v85, v81, vcc
		v_add_co_u32_e64 v84, vcc, v90, v114
		v_addc_co_u32_e64 v85, vcc, v91, v115, vcc
		v_add_co_u32_e64 v90, vcc, v84, v88
		v_addc_co_u32_e64 v91, vcc, v85, v89, vcc
		v_add_co_u32_e64 v84, vcc, v90, v80
		v_addc_co_u32_e64 v85, vcc, v91, v81, vcc
		v_add_co_u32_e64 v90, vcc, v94, v114
		v_addc_co_u32_e64 v91, vcc, v95, v115, vcc
		v_add_co_u32_e64 v94, vcc, v90, v88
		v_addc_co_u32_e64 v95, vcc, v91, v89, vcc
		v_add_co_u32_e64 v90, vcc, v94, v80
		v_addc_co_u32_e64 v91, vcc, v95, v81, vcc
		v_add_co_u32_e64 v94, vcc, v98, v114
		v_addc_co_u32_e64 v95, vcc, v99, v115, vcc
		v_add_co_u32_e64 v98, vcc, v94, v88
		v_addc_co_u32_e64 v99, vcc, v95, v89, vcc
		v_add_co_u32_e64 v94, vcc, v98, v80
		v_addc_co_u32_e64 v95, vcc, v99, v81, vcc
		v_add_co_u32_e64 v98, vcc, v102, v114
		v_addc_co_u32_e64 v99, vcc, v103, v115, vcc
		v_add_co_u32_e64 v102, vcc, v98, v88
		v_addc_co_u32_e64 v103, vcc, v99, v89, vcc
		v_add_co_u32_e64 v98, vcc, v102, v80
		v_addc_co_u32_e64 v99, vcc, v103, v81, vcc
		v_add_co_u32_e64 v102, vcc, v106, v114
		v_addc_co_u32_e64 v103, vcc, v107, v115, vcc
		v_add_co_u32_e64 v106, vcc, v102, v88
		v_addc_co_u32_e64 v107, vcc, v103, v89, vcc
		v_add_co_u32_e64 v102, vcc, v106, v80
		v_addc_co_u32_e64 v103, vcc, v107, v81, vcc
		v_add_co_u32_e64 v106, vcc, v110, v114
		v_addc_co_u32_e64 v107, vcc, v111, v115, vcc
		v_add_co_u32_e64 v110, vcc, v106, v88
		v_addc_co_u32_e64 v111, vcc, v107, v89, vcc
		v_add_co_u32_e64 v106, vcc, v110, v80
		v_addc_co_u32_e64 v107, vcc, v111, v81, vcc
		s_mov_b32 s41, s9
		s_mul_i32 s36, s32, s40
		s_mul_hi_u32 s37, s32, s40
		s_mul_i32 s5, s32, s41
		s_add_i32 s37, s37, s5
		s_mul_i32 s5, s33, s40
		s_add_i32 s37, s37, s5
		v_mov_b32_e32 v110, s36
		v_mov_b32_e32 v111, s37
		v_add_co_u32_e64 v116, vcc, v110, v74
		v_addc_co_u32_e64 v117, vcc, v111, v75, vcc
		v_mov_b32_e32 v110, s56
		v_mov_b32_e32 v111, s57
		v_mul_lo_u32 v118, v110, v16
		v_mul_hi_u32 v119, v110, v16
		v_mul_lo_u32 v1, v110, v17
		v_add_u32_e32 v119, v119, v1
		v_mul_lo_u32 v1, v111, v16
		v_add_u32_e32 v119, v119, v1
		v_add_co_u32_e64 v16, vcc, v116, v118
		v_addc_co_u32_e64 v17, vcc, v117, v119, vcc
		v_mul_lo_u32 v110, v78, v82
		v_mul_hi_u32 v111, v78, v82
		v_mul_lo_u32 v1, v78, v83
		v_add_u32_e32 v111, v111, v1
		v_mul_lo_u32 v1, v79, v82
		v_add_u32_e32 v111, v111, v1
		v_add_co_u32_e64 v116, vcc, v16, v110
		v_addc_co_u32_e64 v117, vcc, v17, v111, vcc
		v_mov_b32_e32 v16, s28
		v_mov_b32_e32 v17, s29
		v_add_co_u32_e64 v120, vcc, v74, v118
		v_addc_co_u32_e64 v121, vcc, v75, v119, vcc
		v_mov_b32_e32 v1, 0x7f
		v_and_b32_e32 v122, v71, v1
		v_mov_b32_e32 v123, v83
		v_mul_lo_u32 v70, v78, v122
		v_mul_hi_u32 v71, v78, v122
		v_mul_lo_u32 v1, v78, v123
		v_add_u32_e32 v71, v71, v1
		v_mul_lo_u32 v1, v79, v122
		v_add_u32_e32 v71, v71, v1
		v_add_co_u32_e64 v78, vcc, v120, v70
		v_addc_co_u32_e64 v79, vcc, v121, v71, vcc
		s_add_u32 s28, s60, 0x80
		s_addc_u32 s29, s61, 0
		v_mov_b32_e32 v82, s28
		v_mov_b32_e32 v83, s29
		v_add_co_u32_e64 v120, vcc, v82, v74
		v_addc_co_u32_e64 v121, vcc, v83, v75, vcc
		v_add_co_u32_e64 v122, vcc, v120, v88
		v_addc_co_u32_e64 v123, vcc, v121, v89, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v120, vcc, v122, v80
		v_addc_co_u32_e64 v121, vcc, v123, v81, vcc
		ds_write_addtid_b32 v120
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v121 offset:1024
		s_add_u32 s28, s60, 0x40080
		s_addc_u32 s29, s61, 0
		v_mov_b32_e32 v120, s28
		v_mov_b32_e32 v121, s29
		v_add_co_u32_e64 v122, vcc, v120, v74
		v_addc_co_u32_e64 v123, vcc, v121, v75, vcc
		v_add_co_u32_e64 v124, vcc, v122, v88
		v_addc_co_u32_e64 v125, vcc, v123, v89, vcc
		v_add_co_u32_e64 v122, vcc, v124, v80
		v_addc_co_u32_e64 v123, vcc, v125, v81, vcc
		s_mov_b32 s5, 0
		scratch_store_dword off, v122, s5
		scratch_store_dword off, v123, s5 offset:4
		s_add_u32 s28, s60, 0x80080
		s_addc_u32 s29, s61, 0
		v_mov_b32_e32 v122, s28
		v_mov_b32_e32 v123, s29
		v_add_co_u32_e64 v124, vcc, v122, v74
		v_addc_co_u32_e64 v125, vcc, v123, v75, vcc
		v_add_co_u32_e64 v126, vcc, v124, v88
		v_addc_co_u32_e64 v127, vcc, v125, v89, vcc
		v_add_co_u32_e64 v124, vcc, v126, v80
		v_addc_co_u32_e64 v125, vcc, v127, v81, vcc
		s_mov_b32 s5, 0
		scratch_store_dword off, v124, s5 offset:8
		scratch_store_dword off, v125, s5 offset:12
		s_add_u32 s28, s60, 0xc0080
		s_addc_u32 s29, s61, 0
		v_mov_b32_e32 v124, s28
		v_mov_b32_e32 v125, s29
		v_add_co_u32_e64 v126, vcc, v124, v74
		v_addc_co_u32_e64 v127, vcc, v125, v75, vcc
		v_add_co_u32_e64 v128, vcc, v126, v88
		v_addc_co_u32_e64 v129, vcc, v127, v89, vcc
		v_add_co_u32_e64 v126, vcc, v128, v80
		v_addc_co_u32_e64 v127, vcc, v129, v81, vcc
		s_mov_b32 s5, 0
		scratch_store_dword off, v126, s5 offset:16
		scratch_store_dword off, v127, s5 offset:20
		s_add_u32 s28, s60, 0xc0
		s_addc_u32 s29, s61, 0
		v_mov_b32_e32 v126, s28
		v_mov_b32_e32 v127, s29
		v_add_co_u32_e64 v128, vcc, v126, v74
		v_addc_co_u32_e64 v129, vcc, v127, v75, vcc
		v_add_co_u32_e64 v130, vcc, v128, v88
		v_addc_co_u32_e64 v131, vcc, v129, v89, vcc
		v_add_co_u32_e64 v128, vcc, v130, v80
		v_addc_co_u32_e64 v129, vcc, v131, v81, vcc
		s_mov_b32 s5, 0
		scratch_store_dword off, v128, s5 offset:24
		scratch_store_dword off, v129, s5 offset:28
		s_add_u32 s28, s60, 0x400c0
		s_addc_u32 s29, s61, 0
		v_mov_b32_e32 v128, s28
		v_mov_b32_e32 v129, s29
		v_add_co_u32_e64 v130, vcc, v128, v74
		v_addc_co_u32_e64 v131, vcc, v129, v75, vcc
		v_add_co_u32_e64 v132, vcc, v130, v88
		v_addc_co_u32_e64 v133, vcc, v131, v89, vcc
		v_add_co_u32_e64 v130, vcc, v132, v80
		v_addc_co_u32_e64 v131, vcc, v133, v81, vcc
		s_mov_b32 s5, 0
		scratch_store_dword off, v130, s5 offset:32
		scratch_store_dword off, v131, s5 offset:36
		s_add_u32 s28, s60, 0x800c0
		s_addc_u32 s29, s61, 0
		v_mov_b32_e32 v130, s28
		v_mov_b32_e32 v131, s29
		v_add_co_u32_e64 v132, vcc, v130, v74
		v_addc_co_u32_e64 v133, vcc, v131, v75, vcc
		v_add_co_u32_e64 v134, vcc, v132, v88
		v_addc_co_u32_e64 v135, vcc, v133, v89, vcc
		v_add_co_u32_e64 v132, vcc, v134, v80
		v_addc_co_u32_e64 v133, vcc, v135, v81, vcc
		s_mov_b32 s5, 0
		scratch_store_dword off, v132, s5 offset:40
		scratch_store_dword off, v133, s5 offset:44
		s_add_u32 s28, s60, 0xc00c0
		s_addc_u32 s29, s61, 0
		v_mov_b32_e32 v132, s28
		v_mov_b32_e32 v133, s29
		v_add_co_u32_e64 v134, vcc, v132, v74
		v_addc_co_u32_e64 v135, vcc, v133, v75, vcc
		v_add_co_u32_e64 v136, vcc, v134, v88
		v_addc_co_u32_e64 v137, vcc, v135, v89, vcc
		v_add_co_u32_e64 v134, vcc, v136, v80
		v_addc_co_u32_e64 v135, vcc, v137, v81, vcc
		s_mov_b32 s5, 0
		scratch_store_dword off, v134, s5 offset:48
		scratch_store_dword off, v135, s5 offset:52
		v_add_co_u32_e64 v134, vcc, v82, v114
		v_addc_co_u32_e64 v135, vcc, v83, v115, vcc
		v_add_co_u32_e64 v82, vcc, v134, v88
		v_addc_co_u32_e64 v83, vcc, v135, v89, vcc
		v_add_co_u32_e64 v134, vcc, v82, v80
		v_addc_co_u32_e64 v135, vcc, v83, v81, vcc
		s_mov_b32 s5, 0
		scratch_store_dword off, v134, s5 offset:56
		scratch_store_dword off, v135, s5 offset:60
		v_add_co_u32_e64 v82, vcc, v120, v114
		v_addc_co_u32_e64 v83, vcc, v121, v115, vcc
		v_add_co_u32_e64 v120, vcc, v82, v88
		v_addc_co_u32_e64 v121, vcc, v83, v89, vcc
		v_add_co_u32_e64 v82, vcc, v120, v80
		v_addc_co_u32_e64 v83, vcc, v121, v81, vcc
		s_mov_b32 s5, 0
		scratch_store_dword off, v82, s5 offset:64
		scratch_store_dword off, v83, s5 offset:68
		v_add_co_u32_e64 v82, vcc, v122, v114
		v_addc_co_u32_e64 v83, vcc, v123, v115, vcc
		v_add_co_u32_e64 v120, vcc, v82, v88
		v_addc_co_u32_e64 v121, vcc, v83, v89, vcc
		v_add_co_u32_e64 v82, vcc, v120, v80
		v_addc_co_u32_e64 v83, vcc, v121, v81, vcc
		s_mov_b32 s5, 0
		scratch_store_dword off, v82, s5 offset:72
		scratch_store_dword off, v83, s5 offset:76
		v_add_co_u32_e64 v82, vcc, v124, v114
		v_addc_co_u32_e64 v83, vcc, v125, v115, vcc
		v_add_co_u32_e64 v120, vcc, v82, v88
		v_addc_co_u32_e64 v121, vcc, v83, v89, vcc
		v_add_co_u32_e64 v82, vcc, v120, v80
		v_addc_co_u32_e64 v83, vcc, v121, v81, vcc
		v_add_co_u32_e64 v120, vcc, v126, v114
		v_addc_co_u32_e64 v121, vcc, v127, v115, vcc
		v_add_co_u32_e64 v122, vcc, v120, v88
		v_addc_co_u32_e64 v123, vcc, v121, v89, vcc
		v_add_co_u32_e64 v120, vcc, v122, v80
		v_addc_co_u32_e64 v121, vcc, v123, v81, vcc
		v_add_co_u32_e64 v122, vcc, v128, v114
		v_addc_co_u32_e64 v123, vcc, v129, v115, vcc
		v_add_co_u32_e64 v124, vcc, v122, v88
		v_addc_co_u32_e64 v125, vcc, v123, v89, vcc
		v_add_co_u32_e64 v122, vcc, v124, v80
		v_addc_co_u32_e64 v123, vcc, v125, v81, vcc
		v_add_co_u32_e64 v124, vcc, v130, v114
		v_addc_co_u32_e64 v125, vcc, v131, v115, vcc
		v_add_co_u32_e64 v126, vcc, v124, v88
		v_addc_co_u32_e64 v127, vcc, v125, v89, vcc
		v_add_co_u32_e64 v124, vcc, v126, v80
		v_addc_co_u32_e64 v125, vcc, v127, v81, vcc
		v_add_co_u32_e64 v126, vcc, v132, v114
		v_addc_co_u32_e64 v127, vcc, v133, v115, vcc
		v_add_co_u32_e64 v114, vcc, v126, v88
		v_addc_co_u32_e64 v115, vcc, v127, v89, vcc
		v_add_co_u32_e64 v88, vcc, v114, v80
		v_addc_co_u32_e64 v89, vcc, v115, v81, vcc
		s_add_u32 s28, s36, 0x800
		s_addc_u32 s29, s37, 0
		v_mov_b32_e32 v80, s28
		v_mov_b32_e32 v81, s29
		v_add_co_u32_e64 v114, vcc, v80, v74
		v_addc_co_u32_e64 v115, vcc, v81, v75, vcc
		v_add_co_u32_e64 v80, vcc, v114, v118
		v_addc_co_u32_e64 v81, vcc, v115, v119, vcc
		v_add_co_u32_e64 v114, vcc, v80, v110
		v_addc_co_u32_e64 v115, vcc, v81, v111, vcc
		v_mov_b32_e32 v1, 0x800
		v_add_co_u32_e64 v80, vcc, v74, v1
		v_addc_co_u32_e64 v81, vcc, v75, 0, vcc
		v_add_co_u32_e64 v74, vcc, v80, v118
		v_addc_co_u32_e64 v75, vcc, v81, v119, vcc
		v_add_co_u32_e64 v80, vcc, v74, v70
		v_addc_co_u32_e64 v81, vcc, v75, v71, vcc
		v_mov_b32_e32 v70, s49
		v_mov_b32_e32 v71, 0
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
.Lwmma_f16_matmul_tiled.loop_head_0:
		v_mov_b32_e32 v70, s49
		v_mul_lo_u32 v74, v4, v70
		v_mul_hi_u32 v75, v4, v70
		v_mul_lo_u32 v1, v4, v71
		v_add_u32_e32 v75, v75, v1
		v_mul_lo_u32 v1, v5, v70
		v_add_u32_e32 v75, v75, v1
		v_add_co_u32_e64 v110, vcc, v2, v74
		v_addc_co_u32_e64 v111, vcc, v3, v75, vcc
		v_add_co_u32_e64 v118, vcc, v86, v74
		v_addc_co_u32_e64 v119, vcc, v87, v75, vcc
		v_add_co_u32_e64 v126, vcc, v92, v74
		v_addc_co_u32_e64 v127, vcc, v93, v75, vcc
		v_add_co_u32_e64 v196, vcc, v96, v74
		v_addc_co_u32_e64 v197, vcc, v97, v75, vcc
		v_add_co_u32_e64 v198, vcc, v100, v74
		v_addc_co_u32_e64 v199, vcc, v101, v75, vcc
		v_add_co_u32_e64 v200, vcc, v104, v74
		v_addc_co_u32_e64 v201, vcc, v105, v75, vcc
		v_add_co_u32_e64 v202, vcc, v108, v74
		v_addc_co_u32_e64 v203, vcc, v109, v75, vcc
		v_add_co_u32_e64 v204, vcc, v112, v74
		v_addc_co_u32_e64 v205, vcc, v113, v75, vcc
		v_add_co_u32_e64 v206, vcc, v72, v74
		v_addc_co_u32_e64 v207, vcc, v73, v75, vcc
		v_add_co_u32_e64 v208, vcc, v76, v74
		v_addc_co_u32_e64 v209, vcc, v77, v75, vcc
		v_add_co_u32_e64 v210, vcc, v84, v74
		v_addc_co_u32_e64 v211, vcc, v85, v75, vcc
		v_add_co_u32_e64 v212, vcc, v90, v74
		v_addc_co_u32_e64 v213, vcc, v91, v75, vcc
		v_add_co_u32_e64 v214, vcc, v94, v74
		v_addc_co_u32_e64 v215, vcc, v95, v75, vcc
		v_add_co_u32_e64 v216, vcc, v98, v74
		v_addc_co_u32_e64 v217, vcc, v99, v75, vcc
		v_add_co_u32_e64 v218, vcc, v102, v74
		v_addc_co_u32_e64 v219, vcc, v103, v75, vcc
		v_add_co_u32_e64 v220, vcc, v106, v74
		v_addc_co_u32_e64 v221, vcc, v107, v75, vcc
		v_mul_lo_u32 v222, v16, v70
		v_mul_hi_u32 v223, v16, v70
		v_mul_lo_u32 v1, v16, v71
		v_add_u32_e32 v223, v223, v1
		v_mul_lo_u32 v1, v17, v70
		v_add_u32_e32 v223, v223, v1
		v_add_co_u32_e64 v224, vcc, v116, v222
		v_addc_co_u32_e64 v225, vcc, v117, v223, vcc
		v_add_co_u32_e64 v226, vcc, v78, v222
		v_addc_co_u32_e64 v227, vcc, v79, v223, vcc
		s_waitcnt vmcnt(24) lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], a[0:3], v[36:39], v[8:11], v13, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s5, s49, 1
		s_lshl_b32 s9, s5, 16
		s_add_i32 s28, s42, s9
		v_add3_u32 v1, s28, v12, v6
		v_add_u32_e32 v1, 0x6000, v1
		ds_read_b128 a[200:203], v1 offset:16384
		s_waitcnt vmcnt(20)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[0:3], v[40:43], v[128:131], v13, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[204:207], v1 offset:17408
		s_waitcnt vmcnt(16) lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[0:3], v[44:47], v[132:135], v13, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[208:211], v1 offset:18432
		s_waitcnt vmcnt(12)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[0:3], v[48:51], v[136:139], v13, v19 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[212:215], v1 offset:19456
		s_waitcnt vmcnt(8) lgkmcnt(7)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[0:3], v[52:55], v[140:143], v13, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[216:219], v1 offset:20480
		s_waitcnt vmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[0:3], v[56:59], v[144:147], v13, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[220:223], v1 offset:21504
		s_waitcnt vmcnt(0) lgkmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[0:3], v[60:63], v[148:151], v13, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[224:227], v1 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[0:3], v[64:67], v[152:155], v13, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[228:231], v1 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[4:7], v[36:39], v[156:159], v13, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s9, s45, s9
		v_add3_u32 v1, s9, v12, v6
		v_add_u32_e32 v1, 0x6000, v1
		ds_read_b128 a[232:235], v1 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[4:7], v[40:43], v[160:163], v13, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[236:239], v1 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[4:7], v[44:47], v[164:167], v13, v19 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[240:243], v1 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[4:7], v[48:51], v[168:171], v13, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[244:247], v1 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[4:7], v[52:55], v[172:175], v13, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[248:251], v1 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[4:7], v[56:59], v[176:179], v13, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[252:255], v1 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[4:7], v[60:63], v[180:183], v13, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v1 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[4:7], v[64:67], v[184:187], v13, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshr_b32 s9, s4, 6
		s_and_b32 s9, s9, 1
		s_lshl_b32 s9, s9, 13
		s_and_b32 s28, s49, 1
		s_lshl_b32 s28, s28, 16
		s_add_i32 s9, s9, s28
		v_and_b32_e32 v1, 15, v0
		v_lshlrev_b32_e32 v232, 6, v1
		v_and_b32_e32 v233, 63, v0
		v_lshrrev_b32_e32 v233, 4, v233
		v_lshrrev_b32_e32 v1, 1, v1
		v_bitop3_b32 v1, v233, v1, 3 bitop3:0x78
		v_lshlrev_b32_e32 v1, 4, v1
		s_mov_b32 m0, s15
		v_add3_u32 v1, s9, v232, v1
		ds_write_addtid_b32 v1 offset:23552
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v1 offset:22528
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v1 offset:21504
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v1 offset:20480
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v1 offset:19456
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v1 offset:18432
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v1 offset:17408
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v1 offset:16384
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v1 offset:15360
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v1 offset:14336
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v1 offset:13312
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v1 offset:12288
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v1 offset:11264
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v1 offset:10240
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v1 offset:9216
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v1 offset:8192
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v1 offset:7168
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v1 offset:6144
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v1 offset:5120
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v1 offset:4096
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v1 offset:3072
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v1 offset:2048
		v_add_u32_e32 v232, 0x6000, v1
		ds_read_b128 v[236:239], v232 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[8:11], v[36:39], v[188:191], v14, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s44, 0x6000
		s_nop 0
		buffer_load_dwordx4 v110, s[16:19], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[8:11], v[40:43], v[192:195], v14, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v118, s[16:19], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[8:11], v[44:47], a[16:19], v14, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v126, s[16:19], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[8:11], v[48:51], a[20:23], v14, v19 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v196, s[16:19], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[8:11], v[52:55], a[24:27], v14, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v198, s[16:19], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[8:11], v[56:59], a[28:31], v14, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v200, s[16:19], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[8:11], v[60:63], a[32:35], v14, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v202, s[16:19], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[8:11], v[64:67], a[36:39], v14, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v204, s[16:19], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[12:15], v[36:39], a[40:43], v14, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v206, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[12:15], v[40:43], a[44:47], v14, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v208, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[12:15], v[44:47], a[48:51], v14, v19 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v210, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[12:15], v[48:51], a[52:55], v14, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v212, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[12:15], v[52:55], a[56:59], v14, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v214, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[12:15], v[56:59], a[60:63], v14, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v216, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[12:15], v[60:63], a[64:67], v14, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v218, s[0:3], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[12:15], v[64:67], a[68:71], v14, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v220, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[20:23], v[36:39], a[72:75], v15, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s9, s49, 1
		s_add_i32 m0, s46, 0x26000
		s_nop 0
		buffer_load_dwordx4 v224, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[20:23], v[40:43], a[76:79], v15, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshl_b32 s5, s5, 12
		s_add_i32 m0, s35, 0x26000
		s_nop 0
		buffer_load_dwordx4 v226, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[20:23], v[44:47], a[80:83], v15, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		s_lshr_b32 s28, s4, 6
		s_lshr_b32 s28, s28, 1
		s_lshl_b32 s28, s28, 13
		s_and_b32 s29, s49, 1
		s_lshl_b32 s29, s29, 16
		s_add_i32 s28, s28, s29
		v_and_b32_e32 v110, 15, v0
		v_lshlrev_b32_e32 v111, 6, v110
		v_and_b32_e32 v118, 63, v0
		v_lshrrev_b32_e32 v118, 4, v118
		v_lshrrev_b32_e32 v110, 1, v110
		v_bitop3_b32 v110, v118, v110, 3 bitop3:0x78
		v_lshlrev_b32_e32 v110, 4, v110
		v_add3_u32 v110, s28, v111, v110
		v_add_u32_e32 v110, 0x6000, v110
		ds_read_b128 a[0:3], v110
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[20:23], v[48:51], a[84:87], v15, v19 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[4:7], v110 offset:1024
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[20:23], v[52:55], a[88:91], v15, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[8:11], v110 offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[20:23], v[56:59], a[92:95], v15, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[12:15], v110 offset:3072
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[20:23], v[60:63], a[96:99], v15, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[196:199], v110 offset:4096
		s_mov_b32 s28, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v196, s28 offset:80
		scratch_store_dword off, v197, s28 offset:84
		scratch_store_dword off, v198, s28 offset:88
		scratch_store_dword off, v199, s28 offset:92
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[20:23], v[64:67], a[100:103], v15, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v110 offset:5120
		s_mov_b32 s28, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s28 offset:96
		scratch_store_dword off, v21, s28 offset:100
		scratch_store_dword off, v22, s28 offset:104
		scratch_store_dword off, v23, s28 offset:108
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[24:27], v[36:39], a[104:107], v15, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v110 offset:6144
		s_mov_b32 s28, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s28 offset:112
		scratch_store_dword off, v21, s28 offset:116
		scratch_store_dword off, v22, s28 offset:120
		scratch_store_dword off, v23, s28 offset:124
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[24:27], v[40:43], a[108:111], v15, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v110 offset:7168
		s_mov_b32 s28, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s28 offset:128
		scratch_store_dword off, v21, s28 offset:132
		scratch_store_dword off, v22, s28 offset:136
		scratch_store_dword off, v23, s28 offset:140
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[24:27], v[44:47], a[112:115], v15, v19 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v232 offset:32768
		s_mov_b32 s28, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s28 offset:144
		scratch_store_dword off, v21, s28 offset:148
		scratch_store_dword off, v22, s28 offset:152
		scratch_store_dword off, v23, s28 offset:156
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[24:27], v[48:51], a[116:119], v15, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v232 offset:33792
		s_mov_b32 s28, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s28 offset:160
		scratch_store_dword off, v21, s28 offset:164
		scratch_store_dword off, v22, s28 offset:168
		scratch_store_dword off, v23, s28 offset:172
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[24:27], v[52:55], a[120:123], v15, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v20, 0x6000, v1
		ds_read_b128 v[196:199], v20 offset:34816
		s_mov_b32 s28, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v196, s28 offset:176
		scratch_store_dword off, v197, s28 offset:180
		scratch_store_dword off, v198, s28 offset:184
		scratch_store_dword off, v199, s28 offset:188
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[24:27], v[56:59], a[124:127], v15, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x6000, v1
		ds_read_b128 v[20:23], v1 offset:35840
		s_mov_b32 s28, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s28 offset:192
		scratch_store_dword off, v21, s28 offset:196
		scratch_store_dword off, v22, s28 offset:200
		scratch_store_dword off, v23, s28 offset:204
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[24:27], v[60:63], a[128:131], v15, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v1 offset:36864
		s_mov_b32 s28, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s28 offset:208
		scratch_store_dword off, v21, s28 offset:212
		scratch_store_dword off, v22, s28 offset:216
		scratch_store_dword off, v23, s28 offset:220
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[24:27], v[64:67], a[132:135], v15, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v1 offset:37888
		s_mov_b32 s28, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s28 offset:224
		scratch_store_dword off, v21, s28 offset:228
		scratch_store_dword off, v22, s28 offset:232
		scratch_store_dword off, v23, s28 offset:236
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[28:31], v[36:39], a[136:139], v18, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v1 offset:38912
		s_mov_b32 s28, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s28 offset:240
		scratch_store_dword off, v21, s28 offset:244
		scratch_store_dword off, v22, s28 offset:248
		scratch_store_dword off, v23, s28 offset:252
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[28:31], v[40:43], a[140:143], v18, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[196:199], v1 offset:39936
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[28:31], v[44:47], a[144:147], v18, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s28, s47, s5
		v_and_b32_e32 v1, 63, v0
		v_lshlrev_b32_e32 v1, 2, v1
		v_add_u32_e32 v20, s28, v1
		v_add_u32_e32 v20, 0x6000, v20
		ds_read_b32 v110, v20
		ds_read_b32 v111, v20 offset:256
		ds_read_b32 v118, v20 offset:512
		ds_read_b32 v119, v20 offset:768
		s_add_i32 s5, s48, s5
		v_add_u32_e32 v20, s5, v1
		v_add_u32_e32 v20, 0x6000, v20
		ds_read_b32 v126, v20 offset:2048
		ds_read_b32 v127, v20 offset:2304
		s_lshr_b32 s5, s4, 6
		s_and_b32 s5, s5, 1
		s_lshl_b32 s5, s5, 10
		s_add_i32 s5, s5, 0x20000
		s_and_b32 s28, s49, 1
		s_lshl_b32 s28, s28, 12
		s_add_i32 s5, s5, s28
		v_add_u32_e32 v20, s5, v1
		v_add_u32_e32 v20, 0x6000, v20
		ds_read_b32 v200, v20 offset:2560
		ds_read_b32 v201, v20 offset:2816
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[28:31], v[48:51], a[148:151], v18, v19 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[32:35], v[48:51], a[180:183], v18, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[32:35], v[44:47], a[176:179], v18, v19 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[32:35], v[36:39], a[168:171], v18, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[32:35], v[40:43], a[172:175], v18, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[32:35], v[52:55], a[184:187], v18, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[28:31], v[52:55], a[152:155], v18, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[28:31], v[56:59], a[156:159], v18, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[32:35], v[56:59], a[188:191], v18, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[32:35], v[60:63], a[192:195], v18, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[28:31], v[60:63], a[160:163], v18, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[28:31], v[64:67], a[164:167], v18, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[32:35], v[64:67], a[196:199], v18, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[224:227], v[228:231], a[160:163], v18, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[224:227], v[236:239], a[164:167], v18, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[228:231], v[236:239], a[196:199], v18, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[228:231], v[228:231], a[192:195], v18, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[200:203], v[228:231], v[148:151], v13, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[200:203], v[236:239], v[152:155], v13, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[204:207], v[236:239], v[184:187], v13, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[204:207], v[228:231], v[180:183], v13, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[204:207], a[232:235], v[156:159], v13, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], a[200:203], a[232:235], v[8:11], v13, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[200:203], a[236:239], v[128:131], v13, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[204:207], a[236:239], v[160:163], v13, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[204:207], a[240:243], v[164:167], v13, v19 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[200:203], a[240:243], v[132:135], v13, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[200:203], a[244:247], v[136:139], v13, v19 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[204:207], a[244:247], v[168:171], v13, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[204:207], a[248:251], v[172:175], v13, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[200:203], a[248:251], v[140:143], v13, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[200:203], a[252:255], v[144:147], v13, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[204:207], a[252:255], v[176:179], v13, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[208:211], a[252:255], a[28:31], v14, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[208:211], a[248:251], a[24:27], v14, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[212:215], a[248:251], a[56:59], v14, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[212:215], a[252:255], a[60:63], v14, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[212:215], a[232:235], a[40:43], v14, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[208:211], a[232:235], v[188:191], v14, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[208:211], a[236:239], v[192:195], v14, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[212:215], a[236:239], a[44:47], v14, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[212:215], a[240:243], a[48:51], v14, v19 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[208:211], a[240:243], a[16:19], v14, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[208:211], a[244:247], a[20:23], v14, v19 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[212:215], a[244:247], a[52:55], v14, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[212:215], v[228:231], a[64:67], v14, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[208:211], v[228:231], a[32:35], v14, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[208:211], v[236:239], a[36:39], v14, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[212:215], v[236:239], a[68:71], v14, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[216:219], v[236:239], a[100:103], v15, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[216:219], v[228:231], a[96:99], v15, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[220:223], v[228:231], a[128:131], v15, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[220:223], v[236:239], a[132:135], v15, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[220:223], a[232:235], a[104:107], v15, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[216:219], a[232:235], a[72:75], v15, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[216:219], a[236:239], a[76:79], v15, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[220:223], a[236:239], a[108:111], v15, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[220:223], a[240:243], a[112:115], v15, v19 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[216:219], a[240:243], a[80:83], v15, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[216:219], a[244:247], a[84:87], v15, v19 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[220:223], a[244:247], a[116:119], v15, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[220:223], a[248:251], a[120:123], v15, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], a[216:219], a[248:251], a[88:91], v15, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], a[216:219], a[252:255], a[92:95], v15, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[220:223], a[252:255], a[124:127], v15, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[224:227], a[252:255], a[156:159], v18, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[224:227], a[248:251], a[152:155], v18, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[228:231], a[248:251], a[184:187], v18, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[228:231], a[252:255], a[188:191], v18, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[228:231], a[232:235], a[168:171], v18, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[224:227], a[232:235], a[136:139], v18, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[224:227], a[236:239], a[140:143], v18, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[228:231], a[236:239], a[172:175], v18, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[228:231], a[240:243], a[176:179], v18, v19 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[224:227], a[240:243], a[144:147], v18, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[224:227], a[244:247], a[148:151], v18, v19 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[228:231], a[244:247], a[180:183], v18, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s5, s9, 1
		s_lshl_b32 s9, s5, 16
		s_add_i32 s28, s42, s9
		v_and_b32_e32 v7, 15, v0
		v_lshlrev_b32_e32 v7, 6, v7
		v_and_b32_e32 v13, 63, v0
		v_lshrrev_b32_e32 v13, 4, v13
		v_and_b32_e32 v14, 15, v0
		v_lshrrev_b32_e32 v14, 1, v14
		v_bitop3_b32 v13, v13, v14, 3 bitop3:0x78
		v_lshlrev_b32_e32 v13, 4, v13
		v_add3_u32 v14, s28, v7, v13
		v_add_u32_e32 v14, 0x6000, v14
		ds_read_b128 v[20:23], v14
		ds_read_b128 v[24:27], v14 offset:1024
		ds_read_b128 v[28:31], v14 offset:2048
		ds_read_b128 v[32:35], v14 offset:3072
		ds_read_b128 a[200:203], v14 offset:4096
		ds_read_b128 a[204:207], v14 offset:5120
		ds_read_b128 a[208:211], v14 offset:6144
		ds_read_b128 a[212:215], v14 offset:7168
		s_add_i32 s9, s45, s9
		v_add3_u32 v15, s9, v7, v13
		v_add_u32_e32 v15, 0x6000, v15
		ds_read_b128 a[216:219], v15 offset:32768
		ds_read_b128 a[220:223], v15 offset:33792
		ds_read_b128 a[224:227], v15 offset:34816
		ds_read_b128 a[228:231], v15 offset:35840
		ds_read_b128 a[232:235], v15 offset:36864
		ds_read_b128 a[236:239], v15 offset:37888
		ds_read_b128 a[240:243], v15 offset:38912
		ds_read_b128 a[244:247], v15 offset:39936
		s_lshl_b32 s5, s5, 12
		s_add_i32 s9, s47, s5
		v_add_u32_e32 v15, s9, v1
		v_add_u32_e32 v15, 0x6000, v15
		ds_read_b32 v18, v15
		ds_read_b32 v19, v15 offset:256
		ds_read_b32 v36, v15 offset:512
		ds_read_b32 v37, v15 offset:768
		s_add_i32 s5, s48, s5
		v_add_u32_e32 v1, s5, v1
		v_add_u32_e32 v1, 0x6000, v1
		ds_read_b32 v15, v1 offset:2048
		ds_read_b32 v38, v1 offset:2304
		ds_read_b32 v39, v1 offset:2560
		ds_read_b32 v40, v1 offset:2816
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v42
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v43 offset:1024
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v44, vcc, v42, v74
		v_addc_co_u32_e64 v45, vcc, v43, v75, vcc
		s_mov_b32 s5, 0
		s_waitcnt vmcnt(62)
		scratch_load_dword v42, off, s5
		scratch_load_dword v43, off, s5 offset:4
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v46, vcc, v42, v74
		v_addc_co_u32_e64 v47, vcc, v43, v75, vcc
		s_mov_b32 s5, 0
		s_waitcnt vmcnt(60)
		scratch_load_dword v42, off, s5 offset:8
		scratch_load_dword v43, off, s5 offset:12
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v48, vcc, v42, v74
		v_addc_co_u32_e64 v49, vcc, v43, v75, vcc
		s_mov_b32 s5, 0
		s_waitcnt vmcnt(58)
		scratch_load_dword v42, off, s5 offset:16
		scratch_load_dword v43, off, s5 offset:20
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v50, vcc, v42, v74
		v_addc_co_u32_e64 v51, vcc, v43, v75, vcc
		s_mov_b32 s5, 0
		s_waitcnt vmcnt(56)
		scratch_load_dword v42, off, s5 offset:24
		scratch_load_dword v43, off, s5 offset:28
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v52, vcc, v42, v74
		v_addc_co_u32_e64 v53, vcc, v43, v75, vcc
		s_mov_b32 s5, 0
		s_waitcnt vmcnt(54)
		scratch_load_dword v42, off, s5 offset:32
		scratch_load_dword v43, off, s5 offset:36
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v54, vcc, v42, v74
		v_addc_co_u32_e64 v55, vcc, v43, v75, vcc
		s_mov_b32 s5, 0
		s_waitcnt vmcnt(52)
		scratch_load_dword v42, off, s5 offset:40
		scratch_load_dword v43, off, s5 offset:44
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v56, vcc, v42, v74
		v_addc_co_u32_e64 v57, vcc, v43, v75, vcc
		s_mov_b32 s5, 0
		s_waitcnt vmcnt(50)
		scratch_load_dword v42, off, s5 offset:48
		scratch_load_dword v43, off, s5 offset:52
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v58, vcc, v42, v74
		v_addc_co_u32_e64 v59, vcc, v43, v75, vcc
		s_mov_b32 s5, 0
		s_waitcnt vmcnt(48)
		scratch_load_dword v42, off, s5 offset:56
		scratch_load_dword v43, off, s5 offset:60
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v60, vcc, v42, v74
		v_addc_co_u32_e64 v61, vcc, v43, v75, vcc
		s_mov_b32 s5, 0
		s_waitcnt vmcnt(46)
		scratch_load_dword v42, off, s5 offset:64
		scratch_load_dword v43, off, s5 offset:68
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v62, vcc, v42, v74
		v_addc_co_u32_e64 v63, vcc, v43, v75, vcc
		s_mov_b32 s5, 0
		s_waitcnt vmcnt(44)
		scratch_load_dword v42, off, s5 offset:72
		scratch_load_dword v43, off, s5 offset:76
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v64, vcc, v42, v74
		v_addc_co_u32_e64 v65, vcc, v43, v75, vcc
		v_add_co_u32_e64 v42, vcc, v82, v74
		v_addc_co_u32_e64 v43, vcc, v83, v75, vcc
		v_add_co_u32_e64 v66, vcc, v120, v74
		v_addc_co_u32_e64 v67, vcc, v121, v75, vcc
		v_add_co_u32_e64 v68, vcc, v122, v74
		v_addc_co_u32_e64 v69, vcc, v123, v75, vcc
		v_add_co_u32_e64 v202, vcc, v124, v74
		v_addc_co_u32_e64 v203, vcc, v125, v75, vcc
		v_add_co_u32_e64 v204, vcc, v88, v74
		v_addc_co_u32_e64 v205, vcc, v89, v75, vcc
		v_add_co_u32_e64 v74, vcc, v114, v222
		v_addc_co_u32_e64 v75, vcc, v115, v223, vcc
		v_add_co_u32_e64 v206, vcc, v80, v222
		v_addc_co_u32_e64 v207, vcc, v81, v223, vcc
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[20:23], a[216:219], v[8:11], v18, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[248:251], v14 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[20:23], a[220:223], v[128:131], v18, v15 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[252:255], v14 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[20:23], a[224:227], v[132:135], v18, v38 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[208:211], v14 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[20:23], a[228:231], v[136:139], v18, v38 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshr_b32 s5, s4, 6
		s_lshr_b32 s5, s5, 1
		s_lshl_b32 s5, s5, 13
		s_add_i32 s9, s49, 1
		s_and_b32 s9, s9, 1
		s_lshl_b32 s9, s9, 16
		s_add_i32 s5, s5, s9
		v_add3_u32 v1, s5, v7, v13
		v_add_u32_e32 v1, 0x6000, v1
		ds_read_b128 v[212:215], v1 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[20:23], a[232:235], v[140:143], v18, v39 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v1 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[20:23], a[236:239], v[144:147], v18, v39 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v1 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], a[240:243], v[148:151], v18, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v1 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], a[244:247], v[152:155], v18, v40 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v1 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], a[216:219], v[156:159], v18, v15 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshr_b32 s5, s4, 6
		s_and_b32 s5, s5, 1
		s_lshl_b32 s5, s5, 13
		s_add_i32 s9, s49, 1
		s_and_b32 s9, s9, 1
		s_lshl_b32 s9, s9, 16
		s_add_i32 s5, s5, s9
		v_add3_u32 v1, s5, v7, v13
		v_add_u32_e32 v1, 0x6000, v1
		ds_read_b128 v[228:231], v1 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[24:27], a[220:223], v[160:163], v18, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[232:235], v1 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[24:27], a[224:227], v[164:167], v18, v38 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[236:239], v1 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[24:27], a[228:231], v[168:171], v18, v38 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v1 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[24:27], a[232:235], v[172:175], v18, v39 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[244:247], v1 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[24:27], a[236:239], v[176:179], v18, v39 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v1 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], a[240:243], v[180:183], v18, v40 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[252:255], v1 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], a[244:247], v[184:187], v18, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v1 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], a[216:219], v[188:191], v19, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s34, 0x6000
		s_nop 0
		buffer_load_dwordx4 v44, s[16:19], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[28:31], a[220:223], v[192:195], v19, v15 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v46, s[16:19], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[28:31], a[224:227], a[16:19], v19, v38 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v48, s[16:19], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[28:31], a[228:231], a[20:23], v19, v38 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v50, s[16:19], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[28:31], a[232:235], a[24:27], v19, v39 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v52, s[16:19], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[28:31], a[236:239], a[28:31], v19, v39 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v54, s[16:19], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[28:31], a[240:243], a[32:35], v19, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v56, s[16:19], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[28:31], a[244:247], a[36:39], v19, v40 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v58, s[16:19], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[32:35], a[216:219], a[40:43], v19, v15 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v60, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[32:35], a[220:223], a[44:47], v19, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v62, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[32:35], a[224:227], a[48:51], v19, v38 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v64, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[32:35], a[228:231], a[52:55], v19, v38 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v42, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[32:35], a[232:235], a[56:59], v19, v39 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v66, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[32:35], a[236:239], a[60:63], v19, v39 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v68, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[32:35], a[240:243], a[64:67], v19, v40 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x1000
		s_nop 0
		buffer_load_dwordx4 v202, s[0:3], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x1000
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[32:35], a[244:247], a[68:71], v19, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		buffer_load_dwordx4 v204, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[200:203], a[216:219], a[72:75], v36, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s59, 0x26000
		s_nop 0
		buffer_load_dwordx4 v74, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[200:203], a[220:223], a[76:79], v36, v15 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s10, 0x26000
		s_nop 0
		buffer_load_dwordx4 v206, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[200:203], a[224:227], a[80:83], v36, v38 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[200:203], a[228:231], a[84:87], v36, v38 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[204:207], a[228:231], a[116:119], v36, v38 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[204:207], a[224:227], a[112:115], v36, v38 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[204:207], a[216:219], a[104:107], v36, v15 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[204:207], a[220:223], a[108:111], v36, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[204:207], a[232:235], a[120:123], v36, v39 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], a[200:203], a[232:235], a[88:91], v36, v39 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], a[200:203], a[236:239], a[92:95], v36, v39 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[204:207], a[236:239], a[124:127], v36, v39 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[204:207], a[240:243], a[128:131], v36, v40 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[200:203], a[240:243], a[96:99], v36, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[200:203], a[244:247], a[100:103], v36, v40 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[204:207], a[244:247], a[132:135], v36, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[208:211], a[244:247], a[164:167], v37, v40 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[208:211], a[240:243], a[160:163], v37, v40 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[212:215], a[240:243], a[192:195], v37, v40 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[212:215], a[244:247], a[196:199], v37, v40 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[212:215], a[216:219], a[168:171], v37, v15 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[208:211], a[216:219], a[136:139], v37, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[208:211], a[220:223], a[140:143], v37, v15 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[212:215], a[220:223], a[172:175], v37, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[212:215], a[224:227], a[176:179], v37, v38 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[208:211], a[224:227], a[144:147], v37, v38 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[208:211], a[228:231], a[148:151], v37, v38 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[212:215], a[228:231], a[180:183], v37, v38 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[212:215], a[232:235], a[184:187], v37, v39 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[208:211], a[232:235], a[152:155], v37, v39 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[208:211], a[236:239], a[156:159], v37, v39 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[212:215], a[236:239], a[188:191], v37, v39 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		s_waitcnt lgkmcnt(7)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], a[248:251], v[228:231], v[8:11], v18, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[248:251], v[232:235], v[128:131], v18, v15 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[252:255], v[232:235], v[160:163], v18, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[252:255], v[228:231], v[156:159], v18, v15 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[252:255], v[236:239], v[164:167], v18, v38 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[248:251], v[236:239], v[132:135], v18, v38 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[248:251], v[240:243], v[136:139], v18, v38 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[252:255], v[240:243], v[168:171], v18, v38 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[252:255], v[244:247], v[172:175], v18, v39 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[248:251], v[244:247], v[140:143], v18, v39 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[248:251], v[248:251], v[144:147], v18, v39 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[252:255], v[248:251], v[176:179], v18, v39 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[252:255], v[252:255], v[180:183], v18, v40 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[248:251], v[252:255], v[148:151], v18, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[248:251], v[24:27], v[152:155], v18, v40 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[252:255], v[24:27], v[184:187], v18, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[208:211], v[24:27], a[36:39], v19, v40 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[208:211], v[252:255], a[32:35], v19, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[212:215], v[252:255], a[64:67], v19, v40 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[212:215], v[24:27], a[68:71], v19, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[212:215], v[228:231], a[40:43], v19, v15 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[208:211], v[228:231], v[188:191], v19, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[208:211], v[232:235], v[192:195], v19, v15 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[212:215], v[232:235], a[44:47], v19, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[212:215], v[236:239], a[48:51], v19, v38 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[208:211], v[236:239], a[16:19], v19, v38 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[208:211], v[240:243], a[20:23], v19, v38 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[212:215], v[240:243], a[52:55], v19, v38 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[212:215], v[244:247], a[56:59], v19, v39 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[208:211], v[244:247], a[24:27], v19, v39 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[208:211], v[248:251], a[28:31], v19, v39 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[212:215], v[248:251], a[60:63], v19, v39 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[216:219], v[248:251], a[92:95], v36, v39 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[216:219], v[244:247], a[88:91], v36, v39 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[220:223], v[244:247], a[120:123], v36, v39 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[220:223], v[248:251], a[124:127], v36, v39 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[220:223], v[228:231], a[104:107], v36, v15 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[216:219], v[228:231], a[72:75], v36, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[216:219], v[232:235], a[76:79], v36, v15 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[220:223], v[232:235], a[108:111], v36, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[220:223], v[236:239], a[112:115], v36, v38 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[216:219], v[236:239], a[80:83], v36, v38 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[216:219], v[240:243], a[84:87], v36, v38 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[220:223], v[240:243], a[116:119], v36, v38 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[220:223], v[252:255], a[128:131], v36, v40 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[216:219], v[252:255], a[96:99], v36, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[216:219], v[24:27], a[100:103], v36, v40 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[220:223], v[24:27], a[132:135], v36, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[224:227], v[24:27], a[164:167], v37, v40 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[224:227], v[252:255], a[160:163], v37, v40 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[20:23], v[252:255], a[192:195], v37, v40 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[20:23], v[24:27], a[196:199], v37, v40 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[20:23], v[228:231], a[168:171], v37, v15 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[224:227], v[228:231], a[136:139], v37, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[224:227], v[232:235], a[140:143], v37, v15 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[20:23], v[232:235], a[172:175], v37, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[20:23], v[236:239], a[176:179], v37, v38 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[224:227], v[236:239], a[144:147], v37, v38 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[224:227], v[240:243], a[148:151], v37, v38 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[20:23], v[240:243], a[180:183], v37, v38 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[20:23], v[244:247], a[184:187], v37, v39 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[224:227], v[244:247], a[152:155], v37, v39 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[224:227], v[248:251], a[156:159], v37, v39 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[20:23], v[248:251], a[188:191], v37, v39 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s49, s49, 2
		s_cmp_lt_i32 s49, s58
		s_mov_b32 s5, 0
		s_waitcnt vmcnt(40)
		scratch_load_dword v20, off, s5 offset:80
		scratch_load_dword v21, off, s5 offset:84
		scratch_load_dword v22, off, s5 offset:88
		scratch_load_dword v23, off, s5 offset:92
		s_mov_b32 s5, 0
		s_waitcnt vmcnt(36)
		scratch_load_dword v24, off, s5 offset:96
		scratch_load_dword v25, off, s5 offset:100
		scratch_load_dword v26, off, s5 offset:104
		scratch_load_dword v27, off, s5 offset:108
		s_mov_b32 s5, 0
		s_waitcnt vmcnt(32)
		scratch_load_dword v28, off, s5 offset:112
		scratch_load_dword v29, off, s5 offset:116
		scratch_load_dword v30, off, s5 offset:120
		scratch_load_dword v31, off, s5 offset:124
		s_mov_b32 s5, 0
		s_waitcnt vmcnt(28)
		scratch_load_dword v32, off, s5 offset:128
		scratch_load_dword v33, off, s5 offset:132
		scratch_load_dword v34, off, s5 offset:136
		scratch_load_dword v35, off, s5 offset:140
		s_mov_b32 s5, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v36, off, s5 offset:144
		scratch_load_dword v37, off, s5 offset:148
		scratch_load_dword v38, off, s5 offset:152
		scratch_load_dword v39, off, s5 offset:156
		s_mov_b32 s5, 0
		s_waitcnt vmcnt(20)
		scratch_load_dword v40, off, s5 offset:160
		scratch_load_dword v41, off, s5 offset:164
		scratch_load_dword v42, off, s5 offset:168
		scratch_load_dword v43, off, s5 offset:172
		s_mov_b32 s5, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v44, off, s5 offset:176
		scratch_load_dword v45, off, s5 offset:180
		scratch_load_dword v46, off, s5 offset:184
		scratch_load_dword v47, off, s5 offset:188
		s_mov_b32 s5, 0
		s_waitcnt vmcnt(12)
		scratch_load_dword v48, off, s5 offset:192
		scratch_load_dword v49, off, s5 offset:196
		scratch_load_dword v50, off, s5 offset:200
		scratch_load_dword v51, off, s5 offset:204
		s_mov_b32 s5, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v52, off, s5 offset:208
		scratch_load_dword v53, off, s5 offset:212
		scratch_load_dword v54, off, s5 offset:216
		scratch_load_dword v55, off, s5 offset:220
		s_mov_b32 s5, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v56, off, s5 offset:224
		scratch_load_dword v57, off, s5 offset:228
		scratch_load_dword v58, off, s5 offset:232
		scratch_load_dword v59, off, s5 offset:236
		s_mov_b32 s5, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v60, off, s5 offset:240
		scratch_load_dword v61, off, s5 offset:244
		scratch_load_dword v62, off, s5 offset:248
		scratch_load_dword v63, off, s5 offset:252
		v_mov_b32_e32 v64, v196
		v_mov_b32_e32 v65, v197
		v_mov_b32_e32 v66, v198
		v_mov_b32_e32 v67, v199
		v_mov_b32_e32 v13, v110
		v_mov_b32_e32 v14, v111
		v_mov_b32_e32 v15, v118
		v_mov_b32_e32 v18, v119
		v_mov_b32_e32 v7, v126
		v_mov_b32_e32 v19, v127
		v_mov_b32_e32 v68, v200
		v_mov_b32_e32 v69, v201
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_add_i32 s0, s12, -1
		s_waitcnt vmcnt(24)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], a[0:3], v[36:39], v[8:11], v13, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s0, s0, 1
		s_lshl_b32 s0, s0, 16
		s_add_i32 s1, s42, s0
		v_and_b32_e32 v1, 15, v0
		v_lshlrev_b32_e32 v1, 6, v1
		v_and_b32_e32 v2, 63, v0
		v_lshrrev_b32_e32 v2, 4, v2
		v_and_b32_e32 v3, 15, v0
		v_lshrrev_b32_e32 v3, 1, v3
		v_bitop3_b32 v2, v2, v3, 3 bitop3:0x78
		v_lshlrev_b32_e32 v2, 4, v2
		v_add3_u32 v3, s1, v1, v2
		v_add_u32_e32 v3, 0x6000, v3
		ds_read_b128 v[72:75], v3 offset:16384
		s_waitcnt vmcnt(20)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], a[0:3], v[40:43], v[128:131], v13, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[76:79], v3 offset:17408
		s_waitcnt vmcnt(16)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[0:3], v[44:47], v[132:135], v13, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[80:83], v3 offset:18432
		s_waitcnt vmcnt(12)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[0:3], v[48:51], v[136:139], v13, v19 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[84:87], v3 offset:19456
		s_waitcnt vmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[0:3], v[52:55], v[140:143], v13, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v3 offset:20480
		s_waitcnt vmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[0:3], v[56:59], v[144:147], v13, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v3 offset:21504
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[0:3], v[60:63], v[148:151], v13, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v3 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[0:3], v[64:67], v[152:155], v13, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v3 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[4:7], v[36:39], v[156:159], v13, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s0, s0, s45
		v_add3_u32 v3, s0, v1, v2
		v_add_u32_e32 v3, 0x6000, v3
		ds_read_b128 v[104:107], v3 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[4:7], v[40:43], v[160:163], v13, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[108:111], v3 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[4:7], v[44:47], v[164:167], v13, v19 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[112:115], v3 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[4:7], v[48:51], v[168:171], v13, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[116:119], v3 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[4:7], v[52:55], v[172:175], v13, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[120:123], v3 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[4:7], v[56:59], v[176:179], v13, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[124:127], v3 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[4:7], v[60:63], v[180:183], v13, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[196:199], v3 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], a[4:7], v[64:67], v[184:187], v13, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[200:203], v3 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], a[8:11], v[36:39], v[188:191], v14, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], a[8:11], v[40:43], v[192:195], v14, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[12:15], v[40:43], a[44:47], v14, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[12:15], v[36:39], a[40:43], v14, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[12:15], v[44:47], a[48:51], v14, v19 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[8:11], v[44:47], a[16:19], v14, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[8:11], v[48:51], a[20:23], v14, v19 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[12:15], v[48:51], a[52:55], v14, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[12:15], v[52:55], a[56:59], v14, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[8:11], v[52:55], a[24:27], v14, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[8:11], v[56:59], a[28:31], v14, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[12:15], v[56:59], a[60:63], v14, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[12:15], v[60:63], a[64:67], v14, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[8:11], v[60:63], a[32:35], v14, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[8:11], v[64:67], a[36:39], v14, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[12:15], v[64:67], a[68:71], v14, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[20:23], v[64:67], a[100:103], v15, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[20:23], v[60:63], a[96:99], v15, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[24:27], v[60:63], a[128:131], v15, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[24:27], v[64:67], a[132:135], v15, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[24:27], v[36:39], a[104:107], v15, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[20:23], v[36:39], a[72:75], v15, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[20:23], v[40:43], a[76:79], v15, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[24:27], v[40:43], a[108:111], v15, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[24:27], v[44:47], a[112:115], v15, v19 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[20:23], v[44:47], a[80:83], v15, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[20:23], v[48:51], a[84:87], v15, v19 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[24:27], v[48:51], a[116:119], v15, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[24:27], v[52:55], a[120:123], v15, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[20:23], v[52:55], a[88:91], v15, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[20:23], v[56:59], a[92:95], v15, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[24:27], v[56:59], a[124:127], v15, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[28:31], v[56:59], a[156:159], v18, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[28:31], v[52:55], a[152:155], v18, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[32:35], v[52:55], a[184:187], v18, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[32:35], v[56:59], a[188:191], v18, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[32:35], v[36:39], a[168:171], v18, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[28:31], v[36:39], a[136:139], v18, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[28:31], v[40:43], a[140:143], v18, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[32:35], v[40:43], a[172:175], v18, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[32:35], v[44:47], a[176:179], v18, v19 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[28:31], v[44:47], a[144:147], v18, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[28:31], v[48:51], a[148:151], v18, v19 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[32:35], v[48:51], a[180:183], v18, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[32:35], v[60:63], a[192:195], v18, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[28:31], v[60:63], a[160:163], v18, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[28:31], v[64:67], a[164:167], v18, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[32:35], v[64:67], a[196:199], v18, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[96:99], v[196:199], a[160:163], v18, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[96:99], v[200:203], a[164:167], v18, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[100:103], v[200:203], a[196:199], v18, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[100:103], v[196:199], a[192:195], v18, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[72:75], v[196:199], v[148:151], v13, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[72:75], v[200:203], v[152:155], v13, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[76:79], v[200:203], v[184:187], v13, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[76:79], v[196:199], v[180:183], v13, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[76:79], v[104:107], v[156:159], v13, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[72:75], v[104:107], v[8:11], v13, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[72:75], v[108:111], v[128:131], v13, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[76:79], v[108:111], v[160:163], v13, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[76:79], v[112:115], v[164:167], v13, v19 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[72:75], v[112:115], v[132:135], v13, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[72:75], v[116:119], v[136:139], v13, v19 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[76:79], v[116:119], v[168:171], v13, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[76:79], v[120:123], v[172:175], v13, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[72:75], v[120:123], v[140:143], v13, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[72:75], v[124:127], v[144:147], v13, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[76:79], v[124:127], v[176:179], v13, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[80:83], v[124:127], a[28:31], v14, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[80:83], v[120:123], a[24:27], v14, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[84:87], v[120:123], a[56:59], v14, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[84:87], v[124:127], a[60:63], v14, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[84:87], v[104:107], a[40:43], v14, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[80:83], v[104:107], v[188:191], v14, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[80:83], v[108:111], v[192:195], v14, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[84:87], v[108:111], a[44:47], v14, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[84:87], v[112:115], a[48:51], v14, v19 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[80:83], v[112:115], a[16:19], v14, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[80:83], v[116:119], a[20:23], v14, v19 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[84:87], v[116:119], a[52:55], v14, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[84:87], v[196:199], a[64:67], v14, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[80:83], v[196:199], a[32:35], v14, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[80:83], v[200:203], a[36:39], v14, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[84:87], v[200:203], a[68:71], v14, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[88:91], v[200:203], a[100:103], v15, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[88:91], v[196:199], a[96:99], v15, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[92:95], v[196:199], a[128:131], v15, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[92:95], v[200:203], a[132:135], v15, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[92:95], v[104:107], a[104:107], v15, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[88:91], v[104:107], a[72:75], v15, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[88:91], v[108:111], a[76:79], v15, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[92:95], v[108:111], a[108:111], v15, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[92:95], v[112:115], a[112:115], v15, v19 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[88:91], v[112:115], a[80:83], v15, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[88:91], v[116:119], a[84:87], v15, v19 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[92:95], v[116:119], a[116:119], v15, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[92:95], v[120:123], a[120:123], v15, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[88:91], v[120:123], a[88:91], v15, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[88:91], v[124:127], a[92:95], v15, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[92:95], v[124:127], a[124:127], v15, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[96:99], v[124:127], a[156:159], v18, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[96:99], v[120:123], a[152:155], v18, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[100:103], v[120:123], a[184:187], v18, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[100:103], v[124:127], a[188:191], v18, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[100:103], v[104:107], a[168:171], v18, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[96:99], v[104:107], a[136:139], v18, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[96:99], v[108:111], a[140:143], v18, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[100:103], v[108:111], a[172:175], v18, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[100:103], v[112:115], a[176:179], v18, v19 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[96:99], v[112:115], a[144:147], v18, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[96:99], v[116:119], a[148:151], v18, v19 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[100:103], v[116:119], a[180:183], v18, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_lshl_b32 s0, s11, 16
		s_add_i32 s1, s42, s0
		v_add3_u32 v3, s1, v1, v2
		v_add_u32_e32 v3, 0x6000, v3
		ds_read_b128 v[4:7], v3
		ds_read_b128 v[12:15], v3 offset:1024
		ds_read_b128 v[16:19], v3 offset:2048
		ds_read_b128 v[20:23], v3 offset:3072
		ds_read_b128 v[24:27], v3 offset:4096
		ds_read_b128 v[28:31], v3 offset:5120
		ds_read_b128 v[32:35], v3 offset:6144
		ds_read_b128 v[36:39], v3 offset:7168
		s_add_i32 s0, s0, s45
		v_add3_u32 v1, s0, v1, v2
		v_add_u32_e32 v1, 0x6000, v1
		ds_read_b128 v[40:43], v1 offset:32768
		ds_read_b128 v[44:47], v1 offset:33792
		ds_read_b128 v[48:51], v1 offset:34816
		ds_read_b128 v[52:55], v1 offset:35840
		ds_read_b128 v[56:59], v1 offset:36864
		ds_read_b128 v[60:63], v1 offset:37888
		ds_read_b128 v[64:67], v1 offset:38912
		ds_read_b128 v[68:71], v1 offset:39936
		s_lshl_b32 s0, s11, 12
		s_add_i32 s1, s47, s0
		v_and_b32_e32 v2, 63, v0
		v_lshlrev_b32_e32 v2, 2, v2
		v_add_u32_e32 v72, s1, v2
		v_add_u32_e32 v72, 0x6000, v72
		ds_read_b32 v73, v72
		ds_read_b32 v74, v72 offset:256
		ds_read_b32 v75, v72 offset:512
		ds_read_b32 v76, v72 offset:768
		s_add_i32 s0, s0, 0x20000
		s_add_i32 s0, s0, s31
		v_add_u32_e32 v2, s0, v2
		v_add_u32_e32 v2, 0x6000, v2
		ds_read_b32 v72, v2 offset:2048
		ds_read_b32 v77, v2 offset:2304
		ds_read_b32 v78, v2 offset:2560
		ds_read_b32 v79, v2 offset:2816
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[4:7], v[40:43], v[8:11], v73, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[80:83], v3 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[4:7], v[44:47], v[128:131], v73, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[84:87], v3 offset:17408
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[4:7], v[48:51], v[132:135], v73, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v3 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[4:7], v[52:55], v[136:139], v73, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v3 offset:19456
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[4:7], v[56:59], v[140:143], v73, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v3 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[4:7], v[60:63], v[144:147], v73, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v3 offset:21504
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[4:7], v[64:67], v[148:151], v73, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[104:107], v3 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[4:7], v[68:71], v[152:155], v73, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[4:7], v3 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[12:15], v[40:43], v[156:159], v73, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[108:111], v1 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[12:15], v[44:47], v[160:163], v73, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[112:115], v1 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[12:15], v[48:51], v[164:167], v73, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[116:119], v1 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[12:15], v[52:55], v[168:171], v73, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[120:123], v1 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[12:15], v[56:59], v[172:175], v73, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[124:127], v1 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[12:15], v[60:63], v[176:179], v73, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[196:199], v1 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[12:15], v[64:67], v[180:183], v73, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[200:203], v1 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[12:15], v[68:71], v[184:187], v73, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[12:15], v1 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[16:19], v[40:43], v[188:191], v74, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[16:19], v[44:47], v[192:195], v74, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[20:23], v[44:47], a[44:47], v74, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[20:23], v[40:43], a[40:43], v74, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[20:23], v[48:51], a[48:51], v74, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[16:19], v[48:51], a[16:19], v74, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[16:19], v[52:55], a[20:23], v74, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[20:23], v[52:55], a[52:55], v74, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[20:23], v[56:59], a[56:59], v74, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[16:19], v[56:59], a[24:27], v74, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[16:19], v[60:63], a[28:31], v74, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[20:23], v[60:63], a[60:63], v74, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[20:23], v[64:67], a[64:67], v74, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[16:19], v[64:67], a[32:35], v74, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[16:19], v[68:71], a[36:39], v74, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[20:23], v[68:71], a[68:71], v74, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[24:27], v[68:71], a[100:103], v75, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[24:27], v[64:67], a[96:99], v75, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[28:31], v[64:67], a[128:131], v75, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[28:31], v[68:71], a[132:135], v75, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[28:31], v[40:43], a[104:107], v75, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[24:27], v[40:43], a[72:75], v75, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[24:27], v[44:47], a[76:79], v75, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[28:31], v[44:47], a[108:111], v75, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[28:31], v[48:51], a[112:115], v75, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[24:27], v[48:51], a[80:83], v75, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[24:27], v[52:55], a[84:87], v75, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[28:31], v[52:55], a[116:119], v75, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[28:31], v[56:59], a[120:123], v75, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[24:27], v[56:59], a[88:91], v75, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[24:27], v[60:63], a[92:95], v75, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[28:31], v[60:63], a[124:127], v75, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[32:35], v[60:63], a[156:159], v76, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[32:35], v[56:59], a[152:155], v76, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[36:39], v[56:59], a[184:187], v76, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[36:39], v[60:63], a[188:191], v76, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[36:39], v[40:43], a[168:171], v76, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[32:35], v[40:43], a[136:139], v76, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[32:35], v[44:47], a[140:143], v76, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[36:39], v[44:47], a[172:175], v76, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[36:39], v[48:51], a[176:179], v76, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], v[48:51], a[144:147], v76, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[32:35], v[52:55], a[148:151], v76, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[36:39], v[52:55], a[180:183], v76, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[36:39], v[64:67], a[192:195], v76, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[32:35], v[64:67], a[160:163], v76, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[32:35], v[68:71], a[164:167], v76, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[36:39], v[68:71], a[196:199], v76, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[104:107], v[200:203], a[160:163], v76, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[104:107], v[12:15], a[164:167], v76, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[4:7], v[12:15], a[196:199], v76, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[4:7], v[200:203], a[192:195], v76, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[80:83], v[200:203], v[148:151], v73, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[80:83], v[12:15], v[152:155], v73, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[84:87], v[12:15], v[184:187], v73, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[84:87], v[200:203], v[180:183], v73, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[84:87], v[108:111], v[156:159], v73, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[80:83], v[108:111], v[8:11], v73, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[80:83], v[112:115], v[128:131], v73, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[84:87], v[112:115], v[160:163], v73, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[84:87], v[116:119], v[164:167], v73, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[80:83], v[116:119], v[132:135], v73, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[80:83], v[120:123], v[136:139], v73, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[84:87], v[120:123], v[168:171], v73, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[84:87], v[124:127], v[172:175], v73, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[80:83], v[124:127], v[140:143], v73, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[80:83], v[196:199], v[144:147], v73, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[84:87], v[196:199], v[176:179], v73, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[88:91], v[196:199], a[28:31], v74, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[88:91], v[124:127], a[24:27], v74, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[92:95], v[124:127], a[56:59], v74, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[92:95], v[196:199], a[60:63], v74, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[92:95], v[108:111], a[40:43], v74, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[88:91], v[108:111], v[188:191], v74, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[88:91], v[112:115], v[192:195], v74, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[92:95], v[112:115], a[44:47], v74, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[92:95], v[116:119], a[48:51], v74, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[88:91], v[116:119], a[16:19], v74, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[88:91], v[120:123], a[20:23], v74, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[92:95], v[120:123], a[52:55], v74, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[92:95], v[200:203], a[64:67], v74, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[88:91], v[200:203], a[32:35], v74, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[88:91], v[12:15], a[36:39], v74, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[92:95], v[12:15], a[68:71], v74, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[96:99], v[12:15], a[100:103], v75, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[96:99], v[200:203], a[96:99], v75, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[100:103], v[200:203], a[128:131], v75, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[100:103], v[12:15], a[132:135], v75, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[100:103], v[108:111], a[104:107], v75, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[96:99], v[108:111], a[72:75], v75, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[96:99], v[112:115], a[76:79], v75, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[100:103], v[112:115], a[108:111], v75, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[100:103], v[116:119], a[112:115], v75, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[96:99], v[116:119], a[80:83], v75, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[96:99], v[120:123], a[84:87], v75, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[100:103], v[120:123], a[116:119], v75, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[100:103], v[124:127], a[120:123], v75, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[96:99], v[124:127], a[88:91], v75, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[96:99], v[196:199], a[92:95], v75, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[100:103], v[196:199], a[124:127], v75, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[104:107], v[196:199], a[156:159], v76, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[104:107], v[124:127], a[152:155], v76, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[4:7], v[124:127], a[184:187], v76, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[4:7], v[196:199], a[188:191], v76, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[4:7], v[108:111], a[168:171], v76, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[104:107], v[108:111], a[136:139], v76, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[104:107], v[112:115], a[140:143], v76, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[4:7], v[112:115], a[172:175], v76, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[4:7], v[116:119], a[176:179], v76, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[104:107], v[116:119], a[144:147], v76, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[104:107], v[120:123], a[148:151], v76, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[4:7], v[120:123], a[180:183], v76, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v8, v9
		v_cvt_pk_f16_f32 v3, v10, v11
		s_lshl_b32 s0, s13, 21
		s_lshl_b32 s1, s14, 17
		s_add_i32 s2, s0, s1
		s_lshl_b32 s3, s8, 15
		s_add_i32 s2, s2, s3
		s_mov_b32 s28, s6
		s_mov_b32 s29, s7
		s_mov_b32 s31, s19
		v_and_b32_e32 v0, 63, v0
		v_lshlrev_b32_e32 v0, 3, v0
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen
		v_cvt_pk_f16_f32 v2, v128, v129
		v_cvt_pk_f16_f32 v3, v130, v131
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen offset:512
		v_cvt_pk_f16_f32 v2, v132, v133
		v_cvt_pk_f16_f32 v3, v134, v135
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen offset:1024
		v_cvt_pk_f16_f32 v2, v136, v137
		v_cvt_pk_f16_f32 v3, v138, v139
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen offset:1536
		v_cvt_pk_f16_f32 v2, v140, v141
		v_cvt_pk_f16_f32 v3, v142, v143
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen offset:2048
		v_cvt_pk_f16_f32 v2, v144, v145
		v_cvt_pk_f16_f32 v3, v146, v147
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen offset:2560
		v_cvt_pk_f16_f32 v2, v148, v149
		v_cvt_pk_f16_f32 v3, v150, v151
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen offset:3072
		v_cvt_pk_f16_f32 v2, v152, v153
		v_cvt_pk_f16_f32 v3, v154, v155
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen offset:3584
		v_cvt_pk_f16_f32 v2, v156, v157
		v_cvt_pk_f16_f32 v3, v158, v159
		s_add_i32 s2, s0, 0x1000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen
		v_cvt_pk_f16_f32 v2, v160, v161
		v_cvt_pk_f16_f32 v3, v162, v163
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen offset:512
		v_cvt_pk_f16_f32 v2, v164, v165
		v_cvt_pk_f16_f32 v3, v166, v167
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen offset:1024
		v_cvt_pk_f16_f32 v2, v168, v169
		v_cvt_pk_f16_f32 v3, v170, v171
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen offset:1536
		v_cvt_pk_f16_f32 v2, v172, v173
		v_cvt_pk_f16_f32 v3, v174, v175
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen offset:2048
		v_cvt_pk_f16_f32 v2, v176, v177
		v_cvt_pk_f16_f32 v3, v178, v179
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen offset:2560
		v_cvt_pk_f16_f32 v2, v180, v181
		v_cvt_pk_f16_f32 v3, v182, v183
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen offset:3072
		v_cvt_pk_f16_f32 v2, v184, v185
		v_cvt_pk_f16_f32 v3, v186, v187
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen offset:3584
		v_cvt_pk_f16_f32 v2, v188, v189
		v_cvt_pk_f16_f32 v3, v190, v191
		s_add_i32 s2, s0, 0x2000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen
		v_cvt_pk_f16_f32 v2, v192, v193
		v_cvt_pk_f16_f32 v3, v194, v195
		buffer_store_dwordx2 v[2:3], v0, s[28:31], s2 offen offset:512
		v_accvgpr_read_b32 v1, a16
		v_accvgpr_read_b32 v2, a17
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a18
		v_accvgpr_read_b32 v2, a19
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:1024
		v_accvgpr_read_b32 v1, a20
		v_accvgpr_read_b32 v2, a21
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a22
		v_accvgpr_read_b32 v2, a23
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:1536
		v_accvgpr_read_b32 v1, a24
		v_accvgpr_read_b32 v2, a25
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a26
		v_accvgpr_read_b32 v2, a27
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:2048
		v_accvgpr_read_b32 v1, a28
		v_accvgpr_read_b32 v2, a29
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a30
		v_accvgpr_read_b32 v2, a31
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:2560
		v_accvgpr_read_b32 v1, a32
		v_accvgpr_read_b32 v2, a33
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a34
		v_accvgpr_read_b32 v2, a35
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:3072
		v_accvgpr_read_b32 v1, a36
		v_accvgpr_read_b32 v2, a37
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a38
		v_accvgpr_read_b32 v2, a39
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a40
		v_accvgpr_read_b32 v2, a41
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a42
		v_accvgpr_read_b32 v2, a43
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x3000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen
		v_accvgpr_read_b32 v1, a44
		v_accvgpr_read_b32 v2, a45
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a46
		v_accvgpr_read_b32 v2, a47
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:512
		v_accvgpr_read_b32 v1, a48
		v_accvgpr_read_b32 v2, a49
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a50
		v_accvgpr_read_b32 v2, a51
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:1024
		v_accvgpr_read_b32 v1, a52
		v_accvgpr_read_b32 v2, a53
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a54
		v_accvgpr_read_b32 v2, a55
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:1536
		v_accvgpr_read_b32 v1, a56
		v_accvgpr_read_b32 v2, a57
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a58
		v_accvgpr_read_b32 v2, a59
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:2048
		v_accvgpr_read_b32 v1, a60
		v_accvgpr_read_b32 v2, a61
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a62
		v_accvgpr_read_b32 v2, a63
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:2560
		v_accvgpr_read_b32 v1, a64
		v_accvgpr_read_b32 v2, a65
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a66
		v_accvgpr_read_b32 v2, a67
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:3072
		v_accvgpr_read_b32 v1, a68
		v_accvgpr_read_b32 v2, a69
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a70
		v_accvgpr_read_b32 v2, a71
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a72
		v_accvgpr_read_b32 v2, a73
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a74
		v_accvgpr_read_b32 v2, a75
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x4000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen
		v_accvgpr_read_b32 v1, a76
		v_accvgpr_read_b32 v2, a77
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a78
		v_accvgpr_read_b32 v2, a79
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:512
		v_accvgpr_read_b32 v1, a80
		v_accvgpr_read_b32 v2, a81
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a82
		v_accvgpr_read_b32 v2, a83
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:1024
		v_accvgpr_read_b32 v1, a84
		v_accvgpr_read_b32 v2, a85
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a86
		v_accvgpr_read_b32 v2, a87
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:1536
		v_accvgpr_read_b32 v1, a88
		v_accvgpr_read_b32 v2, a89
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a90
		v_accvgpr_read_b32 v2, a91
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:2048
		v_accvgpr_read_b32 v1, a92
		v_accvgpr_read_b32 v2, a93
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a94
		v_accvgpr_read_b32 v2, a95
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:2560
		v_accvgpr_read_b32 v1, a96
		v_accvgpr_read_b32 v2, a97
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a98
		v_accvgpr_read_b32 v2, a99
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:3072
		v_accvgpr_read_b32 v1, a100
		v_accvgpr_read_b32 v2, a101
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a102
		v_accvgpr_read_b32 v2, a103
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a104
		v_accvgpr_read_b32 v2, a105
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a106
		v_accvgpr_read_b32 v2, a107
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x5000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen
		v_accvgpr_read_b32 v1, a108
		v_accvgpr_read_b32 v2, a109
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a110
		v_accvgpr_read_b32 v2, a111
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:512
		v_accvgpr_read_b32 v1, a112
		v_accvgpr_read_b32 v2, a113
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a114
		v_accvgpr_read_b32 v2, a115
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:1024
		v_accvgpr_read_b32 v1, a116
		v_accvgpr_read_b32 v2, a117
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a118
		v_accvgpr_read_b32 v2, a119
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:1536
		v_accvgpr_read_b32 v1, a120
		v_accvgpr_read_b32 v2, a121
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a122
		v_accvgpr_read_b32 v2, a123
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:2048
		v_accvgpr_read_b32 v1, a124
		v_accvgpr_read_b32 v2, a125
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a126
		v_accvgpr_read_b32 v2, a127
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:2560
		v_accvgpr_read_b32 v1, a128
		v_accvgpr_read_b32 v2, a129
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a130
		v_accvgpr_read_b32 v2, a131
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:3072
		v_accvgpr_read_b32 v1, a132
		v_accvgpr_read_b32 v2, a133
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a134
		v_accvgpr_read_b32 v2, a135
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a136
		v_accvgpr_read_b32 v2, a137
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a138
		v_accvgpr_read_b32 v2, a139
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x6000
		s_add_i32 s2, s2, s1
		s_add_i32 s2, s2, s3
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen
		v_accvgpr_read_b32 v1, a140
		v_accvgpr_read_b32 v2, a141
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a142
		v_accvgpr_read_b32 v2, a143
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:512
		v_accvgpr_read_b32 v1, a144
		v_accvgpr_read_b32 v2, a145
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a146
		v_accvgpr_read_b32 v2, a147
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:1024
		v_accvgpr_read_b32 v1, a148
		v_accvgpr_read_b32 v2, a149
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a150
		v_accvgpr_read_b32 v2, a151
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:1536
		v_accvgpr_read_b32 v1, a152
		v_accvgpr_read_b32 v2, a153
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a154
		v_accvgpr_read_b32 v2, a155
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:2048
		v_accvgpr_read_b32 v1, a156
		v_accvgpr_read_b32 v2, a157
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a158
		v_accvgpr_read_b32 v2, a159
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:2560
		v_accvgpr_read_b32 v1, a160
		v_accvgpr_read_b32 v2, a161
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a162
		v_accvgpr_read_b32 v2, a163
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:3072
		v_accvgpr_read_b32 v1, a164
		v_accvgpr_read_b32 v2, a165
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a166
		v_accvgpr_read_b32 v2, a167
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a168
		v_accvgpr_read_b32 v2, a169
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a170
		v_accvgpr_read_b32 v2, a171
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s0, s0, 0x7000
		s_add_i32 s0, s0, s1
		s_add_i32 s0, s0, s3
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s0 offen
		v_accvgpr_read_b32 v1, a172
		v_accvgpr_read_b32 v2, a173
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a174
		v_accvgpr_read_b32 v2, a175
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s0 offen offset:512
		v_accvgpr_read_b32 v1, a176
		v_accvgpr_read_b32 v2, a177
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a178
		v_accvgpr_read_b32 v2, a179
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s0 offen offset:1024
		v_accvgpr_read_b32 v1, a180
		v_accvgpr_read_b32 v2, a181
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a182
		v_accvgpr_read_b32 v2, a183
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s0 offen offset:1536
		v_accvgpr_read_b32 v1, a184
		v_accvgpr_read_b32 v2, a185
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a186
		v_accvgpr_read_b32 v2, a187
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s0 offen offset:2048
		v_accvgpr_read_b32 v1, a188
		v_accvgpr_read_b32 v2, a189
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a190
		v_accvgpr_read_b32 v2, a191
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s0 offen offset:2560
		v_accvgpr_read_b32 v1, a192
		v_accvgpr_read_b32 v2, a193
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a194
		v_accvgpr_read_b32 v2, a195
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s0 offen offset:3072
		v_accvgpr_read_b32 v1, a196
		v_accvgpr_read_b32 v2, a197
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a198
		v_accvgpr_read_b32 v2, a199
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[28:31], s0 offen offset:3584
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 24576
		.amdhsa_private_segment_fixed_size 256
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
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 256
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
    .private_segment_fixed_size: 256
    .sgpr_count:     64
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     512
    .agpr_count:     256
    .vgpr_spill_count: 64
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 156
    wave.regalloc.agpr.dwords: 312
    wave.regalloc.remat.dwords: 34
    wave.regalloc.sgpr_to_vgpr.dwords: 0
    wave.regalloc.lds.dwords: 24
    wave.regalloc.scratch.dwords: 64
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
