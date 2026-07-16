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
		s_lshl_b32 s5, s13, 20
		v_lshrrev_b32_e32 v1, 6, v0
		v_lshlrev_b32_e32 v2, 16, v1
		v_add_u32_e32 v3, s5, v2
		v_and_b32_e32 v4, 63, v0
		v_lshrrev_b32_e32 v5, 2, v4
		v_lshlrev_b32_e32 v5, 12, v5
		v_lshrrev_b32_e32 v6, 3, v4
		v_bitop3_b32 v6, v6, 3, v4 bitop3:0x48
		v_lshlrev_b32_e32 v6, 4, v6
		v_add3_u32 v3, v3, v5, v6
		s_add_i32 s8, s5, 0x80000
		v_add_u32_e32 v7, s8, v2
		s_add_i32 s8, s5, 64
		v_add_u32_e32 v8, v2, v5
		s_add_i32 s9, s5, 0x80040
		s_lshl_b32 s10, s14, 20
		s_add_i32 s11, s10, 0x80000
		v_add3_u32 v9, v2, v5, v6
		s_add_i32 s16, s10, 0x80040
		s_lshr_b32 s17, s4, 6
		s_lshl_b32 s19, s17, 10
		s_add_i32 m0, s19, 0x6000
		v_mov_b64_e32 v[12:13], 0
		v_mov_b64_e32 v[14:15], 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add3_u32 v3, v7, v5, v6
		s_add_i32 m0, m0, 0x2000
		v_add3_u32 v7, v6, v8, s8
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add3_u32 v3, v6, v8, s9
		v_add3_u32 v8, v6, v8, s10
		s_add_i32 m0, s19, 0xa000
		s_nop 0
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		v_add_u32_e32 v7, s11, v9
		v_add3_u32 v10, v9, s10, 64
		s_add_i32 m0, s19, 0xc000
		s_nop 0
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add_u32_e32 v3, s16, v9
		s_add_i32 s8, s19, 0x2000
		s_add_i32 m0, s19, 0xe000
		s_nop 0
		buffer_load_dwordx4 v8, s[0:3], 0 offen lds
		s_add_i32 s9, s19, 0x4000
		s_add_i32 s11, s19, 0x6000
		s_add_i32 m0, s19, 0x10000
		s_nop 0
		buffer_load_dwordx4 v7, s[0:3], 0 offen lds
		s_add_i32 s16, s19, 0x8000
		s_add_i32 s32, s19, 0xa000
		s_add_i32 m0, s19, 0x12000
		s_nop 0
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		s_add_i32 s33, s19, 0xc000
		s_add_i32 s34, s19, 0xe000
		s_add_i32 m0, s19, 0x14000
		s_nop 0
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		s_lshl_b32 s35, s14, 16
		s_add_i32 s36, s5, s35
		v_lshrrev_b32_e32 v3, 7, v0
		v_lshlrev_b32_e32 v7, 9, v3
		v_lshlrev_b32_e32 v8, 2, v4
		s_lshr_b32 s4, s4, 7
		s_lshl_b32 s37, s4, 9
		s_add_i32 s4, s5, 0x100
		s_add_i32 s4, s4, s35
		v_lshlrev_b32_e32 v9, 4, v4
		v_and_b32_e32 v1, 1, v1
		v_lshlrev_b32_e32 v10, 10, v1
		s_and_b32 s38, s17, 1
		s_lshl_b32 s38, s38, 10
		v_add3_u32 v11, s36, v7, v8
		s_add_i32 m0, s37, 0x26000
		s_nop 0
		buffer_load_dword v11, s[24:27], 0 offen lds
		v_add3_u32 v11, s4, v7, v8
		s_add_i32 s4, s37, 0x100
		s_add_i32 m0, s37, 0x26100
		s_nop 0
		buffer_load_dword v11, s[24:27], 0 offen lds
		v_add3_u32 v11, s36, v9, v10
		s_add_i32 s36, s38, 0x800
		s_add_i32 m0, s38, 0x26800
		s_nop 0
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v3, 12, v3
		v_and_b32_e32 v11, 15, v0
		v_lshlrev_b32_e32 v16, 6, v11
		v_lshrrev_b32_e32 v4, 4, v4
		v_lshrrev_b32_e32 v11, 1, v11
		v_bitop3_b32 v4, v4, v11, 3 bitop3:0x78
		v_lshlrev_b32_e32 v4, 4, v4
		v_add3_u32 v3, v3, v16, v4
		v_add_u32_e32 v11, 0x1000, v3
		v_add_u32_e32 v11, 0x1000, v11
		v_add_u32_e32 v11, 0x1000, v11
		v_add_u32_e32 v11, 0x1000, v11
		v_add_u32_e32 v11, 0x1000, v11
		v_add_u32_e32 v11, 0x1000, v11
		ds_read_b128 v[20:23], v11
		v_add_u32_e32 v11, 0x1000, v3
		v_add_u32_e32 v11, 0x1000, v11
		v_add_u32_e32 v11, 0x1000, v11
		v_add_u32_e32 v11, 0x1000, v11
		v_add_u32_e32 v11, 0x1000, v11
		v_add_u32_e32 v11, 0x1000, v11
		ds_read_b128 v[24:27], v11 offset:1024
		v_add_u32_e32 v11, 0x1000, v3
		v_add_u32_e32 v11, 0x1000, v11
		v_add_u32_e32 v11, 0x1000, v11
		v_add_u32_e32 v11, 0x1000, v11
		v_add_u32_e32 v11, 0x1000, v11
		v_add_u32_e32 v11, 0x1000, v11
		ds_read_b128 v[28:31], v11 offset:2048
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[32:35], v3 offset:3072
		v_lshlrev_b32_e32 v1, 13, v1
		v_add3_u32 v1, v16, v1, v4
		v_add_u32_e32 v3, 0x1000, v1
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[16:19], v3 offset:32768
		v_add_u32_e32 v3, 0x1000, v1
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[36:39], v3 offset:33792
		v_add_u32_e32 v3, 0x1000, v1
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[40:43], v3 offset:34816
		v_add_u32_e32 v3, 0x1000, v1
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[44:47], v3 offset:35840
		v_add_u32_e32 v3, 0x1000, v1
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[48:51], v3 offset:36864
		v_add_u32_e32 v3, 0x1000, v1
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[52:55], v3 offset:37888
		v_add_u32_e32 v3, 0x1000, v1
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[56:59], v3 offset:38912
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		ds_read_b128 v[60:63], v1 offset:39936
		v_add_u32_e32 v1, 0x20000, v7
		v_add_u32_e32 v1, v1, v8
		v_add_u32_e32 v3, 0x1000, v1
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b32 v4, v3
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		ds_read_b32 v3, v1 offset:256
		v_add_u32_e32 v1, 0x20000, v8
		v_add_u32_e32 v1, v1, v10
		v_add_u32_e32 v11, 0x1000, v1
		v_add_u32_e32 v11, 0x1000, v11
		v_add_u32_e32 v11, 0x1000, v11
		v_add_u32_e32 v11, 0x1000, v11
		v_add_u32_e32 v11, 0x1000, v11
		v_add_u32_e32 v11, 0x1000, v11
		ds_read_b32 v64, v11 offset:2048
		v_add_u32_e32 v11, 0x1000, v1
		v_add_u32_e32 v11, 0x1000, v11
		v_add_u32_e32 v11, 0x1000, v11
		v_add_u32_e32 v11, 0x1000, v11
		v_add_u32_e32 v11, 0x1000, v11
		v_add_u32_e32 v11, 0x1000, v11
		ds_read_b32 v65, v11 offset:2304
		v_add_u32_e32 v11, 0x1000, v1
		v_add_u32_e32 v11, 0x1000, v11
		v_add_u32_e32 v11, 0x1000, v11
		v_add_u32_e32 v11, 0x1000, v11
		v_add_u32_e32 v11, 0x1000, v11
		v_add_u32_e32 v11, 0x1000, v11
		ds_read_b32 v66, v11 offset:2560
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		ds_read_b32 v11, v1 offset:2816
		s_add_i32 s39, s5, 0x80
		v_add_u32_e32 v1, s39, v2
		s_add_i32 s39, s5, 0x80080
		v_add_u32_e32 v67, s39, v2
		s_add_i32 s39, s5, 0xc0
		v_add_u32_e32 v68, v2, v5
		s_add_i32 s40, s5, 0x800c0
		s_add_i32 s41, s10, 0x80
		s_add_i32 s42, s10, 0x80080
		v_add_u32_e32 v2, v2, v5
		s_add_i32 s43, s10, 0xc0
		s_add_i32 s10, s10, 0x800c0
		v_add3_u32 v1, v1, v5, v6
		s_add_i32 m0, s19, 0x16000
		s_nop 0
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		v_add3_u32 v1, v67, v5, v6
		v_add3_u32 v5, v6, v68, s39
		s_add_i32 m0, s19, 0x18000
		s_nop 0
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		v_add3_u32 v1, v6, v68, s40
		v_add3_u32 v67, v6, v68, s41
		s_add_i32 m0, s19, 0x1a000
		s_nop 0
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		v_add3_u32 v5, v6, v2, s42
		v_add3_u32 v68, v6, v2, s43
		s_add_i32 m0, s19, 0x1c000
		s_nop 0
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		v_add3_u32 v1, v6, v2, s10
		s_add_i32 s10, s19, 0x10000
		s_add_i32 m0, s19, 0x1e000
		s_nop 0
		buffer_load_dwordx4 v67, s[0:3], 0 offen lds
		s_add_i32 s39, s19, 0x12000
		s_add_i32 s40, s19, 0x14000
		s_add_i32 m0, s19, 0x20000
		s_nop 0
		buffer_load_dwordx4 v5, s[0:3], 0 offen lds
		s_add_i32 s41, s19, 0x16000
		s_add_i32 s42, s19, 0x18000
		s_add_i32 m0, s19, 0x22000
		s_nop 0
		buffer_load_dwordx4 v68, s[0:3], 0 offen lds
		s_add_i32 s43, s19, 0x1a000
		s_add_i32 s44, s19, 0x1c000
		s_add_i32 m0, s19, 0x24000
		s_nop 0
		buffer_load_dwordx4 v1, s[0:3], 0 offen lds
		s_add_i32 s45, s5, 0x800
		s_add_i32 s45, s45, s35
		v_add3_u32 v1, s45, v7, v8
		s_add_i32 s5, s5, 0x900
		s_add_i32 s5, s5, s35
		s_add_i32 s35, s38, 0x1800
		s_add_i32 s46, s19, 0x1e000
		s_add_i32 m0, s37, 0x27000
		s_nop 0
		buffer_load_dword v1, s[24:27], 0 offen lds
		s_add_i32 s47, s37, 0x1000
		v_add3_u32 v1, s5, v7, v8
		s_add_i32 m0, s37, 0x27100
		s_nop 0
		buffer_load_dword v1, s[24:27], 0 offen lds
		s_add_i32 s5, s37, 0x1100
		v_add3_u32 v1, s45, v9, v10
		s_add_i32 m0, s38, 0x27800
		s_nop 0
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s38, s12, 1
		s_mov_b32 s45, 2
		v_mov_b32_e32 v6, s13
		v_mov_b32_e32 v7, 0
		s_mov_b32 s48, 0x100000
		s_mov_b32 s49, 0
		v_mov_b32_e32 v8, s48
		v_mov_b32_e32 v9, s49
		v_mul_lo_u32 v68, v8, v6
		v_mul_hi_u32 v69, v8, v6
		v_mul_lo_u32 v1, v8, v7
		v_add_u32_e32 v69, v69, v1
		v_mul_lo_u32 v1, v9, v6
		v_add_u32_e32 v69, v69, v1
		s_mov_b32 s48, 1
		s_mov_b32 s49, 0
		v_mov_b32_e32 v70, v0
		v_mov_b32_e32 v72, s48
		v_mov_b32_e32 v73, s49
		v_mov_b32_e32 v71, 0
		v_mul_lo_u32 v74, v72, v70
		v_mul_hi_u32 v75, v72, v70
		v_mul_lo_u32 v1, v72, v71
		v_add_u32_e32 v75, v75, v1
		v_mul_lo_u32 v1, v73, v70
		v_add_u32_e32 v75, v75, v1
		v_lshrrev_b64 v[76:77], 6, v[74:75]
		s_mov_b32 s48, 0x10000
		s_mov_b32 s49, 0
		v_mov_b32_e32 v78, s48
		v_mov_b32_e32 v79, s49
		v_mul_lo_u32 v80, v78, v76
		v_mul_hi_u32 v81, v78, v76
		v_mul_lo_u32 v1, v78, v77
		v_add_u32_e32 v81, v81, v1
		v_mul_lo_u32 v1, v79, v76
		v_add_u32_e32 v81, v81, v1
		v_add_co_u32_e64 v82, vcc, v68, v80
		v_addc_co_u32_e64 v83, vcc, v69, v81, vcc
		v_mov_b32_e32 v1, 63
		v_and_b32_e32 v84, v70, v1
		v_and_b32_e32 v85, v7, v7
		v_mul_lo_u32 v70, v72, v84
		v_mul_hi_u32 v71, v72, v84
		v_mul_lo_u32 v1, v72, v85
		v_add_u32_e32 v71, v71, v1
		v_mul_lo_u32 v1, v73, v84
		v_add_u32_e32 v71, v71, v1
		v_lshrrev_b64 v[72:73], 2, v[70:71]
		s_mov_b32 s48, 0x1000
		s_mov_b32 s49, 0
		v_mov_b32_e32 v86, s48
		v_mov_b32_e32 v87, s49
		v_mul_lo_u32 v88, v86, v72
		v_mul_hi_u32 v89, v86, v72
		v_mul_lo_u32 v1, v86, v73
		v_add_u32_e32 v89, v89, v1
		v_mul_lo_u32 v1, v87, v72
		v_add_u32_e32 v89, v89, v1
		v_add_co_u32_e64 v72, vcc, v82, v88
		v_addc_co_u32_e64 v73, vcc, v83, v89, vcc
		v_lshrrev_b64 v[82:83], 3, v[70:71]
		v_mov_b32_e32 v1, 3
		v_and_b32_e32 v70, v82, v1
		v_and_b32_e32 v71, v83, v7
		v_and_b32_e32 v82, v84, v1
		v_and_b32_e32 v83, v85, v7
		v_xor_b32_e32 v70, v70, v82
		v_xor_b32_e32 v71, v71, v83
		s_mov_b32 s48, 16
		s_mov_b32 s49, 0
		v_mov_b32_e32 v82, s48
		v_mov_b32_e32 v83, s49
		v_mul_lo_u32 v86, v82, v70
		v_mul_hi_u32 v87, v82, v70
		v_mul_lo_u32 v1, v82, v71
		v_add_u32_e32 v87, v87, v1
		v_mul_lo_u32 v1, v83, v70
		v_add_u32_e32 v87, v87, v1
		v_add_co_u32_e64 v70, vcc, v72, v86
		v_addc_co_u32_e64 v71, vcc, v73, v87, vcc
		s_mov_b32 s48, 0x80
		s_mov_b32 s49, 0
		v_mov_b32_e32 v72, s48
		v_mov_b32_e32 v73, s49
		v_mov_b32_e32 v1, 0x80000
		v_add_co_u32_e64 v90, vcc, v68, v1
		v_addc_co_u32_e64 v91, vcc, v69, 0, vcc
		v_add_co_u32_e64 v92, vcc, v90, v80
		v_addc_co_u32_e64 v93, vcc, v91, v81, vcc
		v_add_co_u32_e64 v90, vcc, v92, v88
		v_addc_co_u32_e64 v91, vcc, v93, v89, vcc
		v_add_co_u32_e64 v92, vcc, v90, v86
		v_addc_co_u32_e64 v93, vcc, v91, v87, vcc
		v_mov_b32_e32 v2, 64
		v_add_co_u32_e64 v90, vcc, v68, v2
		v_addc_co_u32_e64 v91, vcc, v69, 0, vcc
		v_add_co_u32_e64 v94, vcc, v90, v80
		v_addc_co_u32_e64 v95, vcc, v91, v81, vcc
		v_add_co_u32_e64 v90, vcc, v94, v88
		v_addc_co_u32_e64 v91, vcc, v95, v89, vcc
		v_add_co_u32_e64 v94, vcc, v90, v86
		v_addc_co_u32_e64 v95, vcc, v91, v87, vcc
		v_mov_b32_e32 v5, 0x80040
		v_add_co_u32_e64 v90, vcc, v68, v5
		v_addc_co_u32_e64 v91, vcc, v69, 0, vcc
		v_add_co_u32_e64 v96, vcc, v90, v80
		v_addc_co_u32_e64 v97, vcc, v91, v81, vcc
		v_add_co_u32_e64 v90, vcc, v96, v88
		v_addc_co_u32_e64 v91, vcc, v97, v89, vcc
		v_add_co_u32_e64 v96, vcc, v90, v86
		v_addc_co_u32_e64 v97, vcc, v91, v87, vcc
		v_mov_b32_e32 v90, s14
		v_mov_b32_e32 v91, 0
		v_mul_lo_u32 v98, v8, v90
		v_mul_hi_u32 v99, v8, v90
		v_mul_lo_u32 v6, v8, v91
		v_add_u32_e32 v99, v99, v6
		v_mul_lo_u32 v6, v9, v90
		v_add_u32_e32 v99, v99, v6
		v_add_co_u32_e64 v8, vcc, v98, v80
		v_addc_co_u32_e64 v9, vcc, v99, v81, vcc
		v_add_co_u32_e64 v100, vcc, v8, v88
		v_addc_co_u32_e64 v101, vcc, v9, v89, vcc
		v_add_co_u32_e64 v8, vcc, v100, v86
		v_addc_co_u32_e64 v9, vcc, v101, v87, vcc
		v_add_co_u32_e64 v100, vcc, v98, v1
		v_addc_co_u32_e64 v101, vcc, v99, 0, vcc
		v_add_co_u32_e64 v102, vcc, v100, v80
		v_addc_co_u32_e64 v103, vcc, v101, v81, vcc
		v_add_co_u32_e64 v100, vcc, v102, v88
		v_addc_co_u32_e64 v101, vcc, v103, v89, vcc
		v_add_co_u32_e64 v102, vcc, v100, v86
		v_addc_co_u32_e64 v103, vcc, v101, v87, vcc
		v_add_co_u32_e64 v100, vcc, v98, v2
		v_addc_co_u32_e64 v101, vcc, v99, 0, vcc
		v_add_co_u32_e64 v104, vcc, v100, v80
		v_addc_co_u32_e64 v105, vcc, v101, v81, vcc
		v_add_co_u32_e64 v100, vcc, v104, v88
		v_addc_co_u32_e64 v101, vcc, v105, v89, vcc
		v_add_co_u32_e64 v104, vcc, v100, v86
		v_addc_co_u32_e64 v105, vcc, v101, v87, vcc
		v_add_co_u32_e64 v100, vcc, v98, v5
		v_addc_co_u32_e64 v101, vcc, v99, 0, vcc
		v_add_co_u32_e64 v106, vcc, v100, v80
		v_addc_co_u32_e64 v107, vcc, v101, v81, vcc
		v_add_co_u32_e64 v100, vcc, v106, v88
		v_addc_co_u32_e64 v101, vcc, v107, v89, vcc
		v_add_co_u32_e64 v106, vcc, v100, v86
		v_addc_co_u32_e64 v107, vcc, v101, v87, vcc
		v_mul_lo_u32 v100, v78, v90
		v_mul_hi_u32 v101, v78, v90
		v_mul_lo_u32 v1, v78, v91
		v_add_u32_e32 v101, v101, v1
		v_mul_lo_u32 v1, v79, v90
		v_add_u32_e32 v101, v101, v1
		v_add_co_u32_e64 v78, vcc, v68, v100
		v_addc_co_u32_e64 v79, vcc, v69, v101, vcc
		v_lshrrev_b64 v[90:91], 7, v[74:75]
		s_mov_b32 s48, 0x200
		s_mov_b32 s49, 0
		v_mov_b32_e32 v74, s48
		v_mov_b32_e32 v75, s49
		v_mul_lo_u32 v108, v74, v90
		v_mul_hi_u32 v109, v74, v90
		v_mul_lo_u32 v1, v74, v91
		v_add_u32_e32 v109, v109, v1
		v_mul_lo_u32 v1, v75, v90
		v_add_u32_e32 v109, v109, v1
		v_add_co_u32_e64 v74, vcc, v78, v108
		v_addc_co_u32_e64 v75, vcc, v79, v109, vcc
		s_mov_b32 s48, 4
		s_mov_b32 s49, 0
		v_mov_b32_e32 v90, s48
		v_mov_b32_e32 v91, s49
		v_mul_lo_u32 v110, v90, v84
		v_mul_hi_u32 v111, v90, v84
		v_mul_lo_u32 v1, v90, v85
		v_add_u32_e32 v111, v111, v1
		v_mul_lo_u32 v1, v91, v84
		v_add_u32_e32 v111, v111, v1
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v90, vcc, v74, v110
		v_addc_co_u32_e64 v91, vcc, v75, v111, vcc
		ds_write_addtid_b32 v90
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v91 offset:2048
		s_mov_b32 s48, 0x800
		s_mov_b32 s49, 0
		v_mov_b32_e32 v1, 0x100
		v_add_co_u32_e64 v74, vcc, v68, v1
		v_addc_co_u32_e64 v75, vcc, v69, 0, vcc
		v_add_co_u32_e64 v90, vcc, v74, v100
		v_addc_co_u32_e64 v91, vcc, v75, v101, vcc
		v_add_co_u32_e64 v74, vcc, v90, v108
		v_addc_co_u32_e64 v75, vcc, v91, v109, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v90, vcc, v74, v110
		v_addc_co_u32_e64 v91, vcc, v75, v111, vcc
		ds_write_addtid_b32 v90 offset:4096
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v91 offset:6144
		v_mul_lo_u32 v74, v82, v84
		v_mul_hi_u32 v75, v82, v84
		v_mul_lo_u32 v1, v82, v85
		v_add_u32_e32 v75, v75, v1
		v_mul_lo_u32 v1, v83, v84
		v_add_u32_e32 v75, v75, v1
		v_add_co_u32_e64 v82, vcc, v78, v74
		v_addc_co_u32_e64 v83, vcc, v79, v75, vcc
		v_mov_b32_e32 v1, 1
		v_and_b32_e32 v78, v76, v1
		v_and_b32_e32 v79, v77, v7
		s_mov_b32 s50, 0x400
		s_mov_b32 s51, 0
		v_mov_b32_e32 v6, s50
		v_mov_b32_e32 v7, s51
		v_mul_lo_u32 v76, v6, v78
		v_mul_hi_u32 v77, v6, v78
		v_mul_lo_u32 v1, v6, v79
		v_add_u32_e32 v77, v77, v1
		v_mul_lo_u32 v1, v7, v78
		v_add_u32_e32 v77, v77, v1
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v6, vcc, v82, v76
		v_addc_co_u32_e64 v7, vcc, v83, v77, vcc
		ds_write_addtid_b32 v6 offset:8192
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v7 offset:10240
		v_mov_b32_e32 v1, 0x80
		v_add_co_u32_e64 v6, vcc, v68, v1
		v_addc_co_u32_e64 v7, vcc, v69, 0, vcc
		v_add_co_u32_e64 v78, vcc, v6, v80
		v_addc_co_u32_e64 v79, vcc, v7, v81, vcc
		v_add_co_u32_e64 v6, vcc, v78, v88
		v_addc_co_u32_e64 v7, vcc, v79, v89, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v78, vcc, v6, v86
		v_addc_co_u32_e64 v79, vcc, v7, v87, vcc
		ds_write_addtid_b32 v78 offset:12288
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v79 offset:14336
		v_mov_b32_e32 v2, 0x80080
		v_add_co_u32_e64 v6, vcc, v68, v2
		v_addc_co_u32_e64 v7, vcc, v69, 0, vcc
		v_add_co_u32_e64 v78, vcc, v6, v80
		v_addc_co_u32_e64 v79, vcc, v7, v81, vcc
		v_add_co_u32_e64 v6, vcc, v78, v88
		v_addc_co_u32_e64 v7, vcc, v79, v89, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v78, vcc, v6, v86
		v_addc_co_u32_e64 v79, vcc, v7, v87, vcc
		ds_write_addtid_b32 v78 offset:16384
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v79 offset:18432
		v_mov_b32_e32 v5, 0xc0
		v_add_co_u32_e64 v6, vcc, v68, v5
		v_addc_co_u32_e64 v7, vcc, v69, 0, vcc
		v_add_co_u32_e64 v78, vcc, v6, v80
		v_addc_co_u32_e64 v79, vcc, v7, v81, vcc
		v_add_co_u32_e64 v6, vcc, v78, v88
		v_addc_co_u32_e64 v7, vcc, v79, v89, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v78, vcc, v6, v86
		v_addc_co_u32_e64 v79, vcc, v7, v87, vcc
		ds_write_addtid_b32 v78 offset:20480
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v79 offset:22528
		v_mov_b32_e32 v6, 0x800c0
		v_add_co_u32_e64 v78, vcc, v68, v6
		v_addc_co_u32_e64 v79, vcc, v69, 0, vcc
		v_add_co_u32_e64 v82, vcc, v78, v80
		v_addc_co_u32_e64 v83, vcc, v79, v81, vcc
		v_add_co_u32_e64 v78, vcc, v82, v88
		v_addc_co_u32_e64 v79, vcc, v83, v89, vcc
		v_add_co_u32_e64 v82, vcc, v78, v86
		v_addc_co_u32_e64 v83, vcc, v79, v87, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v82, s50
		scratch_store_dword off, v83, s50 offset:4
		v_add_co_u32_e64 v78, vcc, v98, v1
		v_addc_co_u32_e64 v79, vcc, v99, 0, vcc
		v_add_co_u32_e64 v82, vcc, v78, v80
		v_addc_co_u32_e64 v83, vcc, v79, v81, vcc
		v_add_co_u32_e64 v78, vcc, v82, v88
		v_addc_co_u32_e64 v79, vcc, v83, v89, vcc
		v_add_co_u32_e64 v82, vcc, v78, v86
		v_addc_co_u32_e64 v83, vcc, v79, v87, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v82, s50 offset:8
		scratch_store_dword off, v83, s50 offset:12
		v_add_co_u32_e64 v78, vcc, v98, v2
		v_addc_co_u32_e64 v79, vcc, v99, 0, vcc
		v_add_co_u32_e64 v82, vcc, v78, v80
		v_addc_co_u32_e64 v83, vcc, v79, v81, vcc
		v_add_co_u32_e64 v78, vcc, v82, v88
		v_addc_co_u32_e64 v79, vcc, v83, v89, vcc
		v_add_co_u32_e64 v82, vcc, v78, v86
		v_addc_co_u32_e64 v83, vcc, v79, v87, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v82, s50 offset:16
		scratch_store_dword off, v83, s50 offset:20
		v_add_co_u32_e64 v78, vcc, v98, v5
		v_addc_co_u32_e64 v79, vcc, v99, 0, vcc
		v_add_co_u32_e64 v82, vcc, v78, v80
		v_addc_co_u32_e64 v83, vcc, v79, v81, vcc
		v_add_co_u32_e64 v78, vcc, v82, v88
		v_addc_co_u32_e64 v79, vcc, v83, v89, vcc
		v_add_co_u32_e64 v82, vcc, v78, v86
		v_addc_co_u32_e64 v83, vcc, v79, v87, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v82, s50 offset:24
		scratch_store_dword off, v83, s50 offset:28
		v_add_co_u32_e64 v78, vcc, v98, v6
		v_addc_co_u32_e64 v79, vcc, v99, 0, vcc
		v_add_co_u32_e64 v6, vcc, v78, v80
		v_addc_co_u32_e64 v7, vcc, v79, v81, vcc
		v_add_co_u32_e64 v78, vcc, v6, v88
		v_addc_co_u32_e64 v79, vcc, v7, v89, vcc
		v_add_co_u32_e64 v6, vcc, v78, v86
		v_addc_co_u32_e64 v7, vcc, v79, v87, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v6, s50 offset:32
		scratch_store_dword off, v7, s50 offset:36
		v_mov_b32_e32 v1, 0x800
		v_add_co_u32_e64 v6, vcc, v68, v1
		v_addc_co_u32_e64 v7, vcc, v69, 0, vcc
		v_add_co_u32_e64 v78, vcc, v6, v100
		v_addc_co_u32_e64 v79, vcc, v7, v101, vcc
		v_add_co_u32_e64 v6, vcc, v78, v108
		v_addc_co_u32_e64 v7, vcc, v79, v109, vcc
		v_add_co_u32_e64 v80, vcc, v6, v110
		v_addc_co_u32_e64 v81, vcc, v7, v111, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v80, s50 offset:40
		scratch_store_dword off, v81, s50 offset:44
		v_mov_b32_e32 v1, 0x900
		v_add_co_u32_e64 v6, vcc, v68, v1
		v_addc_co_u32_e64 v7, vcc, v69, 0, vcc
		v_add_co_u32_e64 v68, vcc, v6, v100
		v_addc_co_u32_e64 v69, vcc, v7, v101, vcc
		v_add_co_u32_e64 v6, vcc, v68, v108
		v_addc_co_u32_e64 v7, vcc, v69, v109, vcc
		v_add_co_u32_e64 v68, vcc, v6, v110
		v_addc_co_u32_e64 v69, vcc, v7, v111, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v68, s50 offset:48
		scratch_store_dword off, v69, s50 offset:52
		v_add_co_u32_e64 v6, vcc, v78, v74
		v_addc_co_u32_e64 v7, vcc, v79, v75, vcc
		v_add_co_u32_e64 v68, vcc, v6, v76
		v_addc_co_u32_e64 v69, vcc, v7, v77, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v68, s50 offset:56
		scratch_store_dword off, v69, s50 offset:60
		v_mov_b32_e32 v6, s45
		v_mov_b32_e32 v7, 0
		v_mov_b64_e32 v[76:77], 0
		v_mov_b64_e32 v[78:79], 0
		v_mov_b64_e32 v[80:81], 0
		v_mov_b64_e32 v[82:83], 0
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_mov_b64_e32 v[108:109], 0
		v_mov_b64_e32 v[110:111], 0
		v_mov_b64_e32 v[112:113], 0
		v_mov_b64_e32 v[114:115], 0
		v_mov_b64_e32 v[116:117], 0
		v_mov_b64_e32 v[118:119], 0
		v_mov_b64_e32 v[120:121], 0
		v_mov_b64_e32 v[122:123], 0
		v_mov_b64_e32 v[124:125], 0
		v_mov_b64_e32 v[126:127], 0
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
		v_mov_b64_e32 v[196:197], 0
		v_mov_b64_e32 v[198:199], 0
		v_mov_b64_e32 v[200:201], 0
		v_mov_b64_e32 v[202:203], 0
		v_mov_b64_e32 v[204:205], 0
		v_mov_b64_e32 v[206:207], 0
		v_mov_b64_e32 v[208:209], 0
		v_mov_b64_e32 v[210:211], 0
		v_mov_b64_e32 v[212:213], 0
		v_mov_b64_e32 v[214:215], 0
.Lwmma_f16_matmul_tiled.loop_head_0:
		v_mov_b32_e32 v6, s45
		v_mul_lo_u32 v68, v72, v6
		v_mul_hi_u32 v69, v72, v6
		v_mul_lo_u32 v1, v72, v7
		v_add_u32_e32 v69, v69, v1
		v_mul_lo_u32 v1, v73, v6
		v_add_u32_e32 v69, v69, v1
		v_add_co_u32_e64 v74, vcc, v70, v68
		v_addc_co_u32_e64 v75, vcc, v71, v69, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v74, s50 offset:64
		scratch_store_dword off, v75, s50 offset:68
		v_add_co_u32_e64 v74, vcc, v92, v68
		v_addc_co_u32_e64 v75, vcc, v93, v69, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v74, s50 offset:72
		scratch_store_dword off, v75, s50 offset:76
		v_add_co_u32_e64 v74, vcc, v94, v68
		v_addc_co_u32_e64 v75, vcc, v95, v69, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v74, s50 offset:80
		scratch_store_dword off, v75, s50 offset:84
		v_add_co_u32_e64 v74, vcc, v96, v68
		v_addc_co_u32_e64 v75, vcc, v97, v69, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v74, s50 offset:88
		scratch_store_dword off, v75, s50 offset:92
		v_add_co_u32_e64 v74, vcc, v8, v68
		v_addc_co_u32_e64 v75, vcc, v9, v69, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v74, s50 offset:96
		scratch_store_dword off, v75, s50 offset:100
		v_add_co_u32_e64 v74, vcc, v102, v68
		v_addc_co_u32_e64 v75, vcc, v103, v69, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v74, s50 offset:104
		scratch_store_dword off, v75, s50 offset:108
		v_add_co_u32_e64 v74, vcc, v104, v68
		v_addc_co_u32_e64 v75, vcc, v105, v69, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v74, s50 offset:112
		scratch_store_dword off, v75, s50 offset:116
		v_add_co_u32_e64 v74, vcc, v106, v68
		v_addc_co_u32_e64 v75, vcc, v107, v69, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v74, s50 offset:120
		scratch_store_dword off, v75, s50 offset:124
		v_mov_b32_e32 v74, s48
		v_mov_b32_e32 v75, s49
		v_mul_lo_u32 v98, v74, v6
		v_mul_hi_u32 v99, v74, v6
		v_mul_lo_u32 v1, v74, v7
		v_add_u32_e32 v99, v99, v1
		v_mul_lo_u32 v1, v75, v6
		v_add_u32_e32 v99, v99, v1
		s_mov_b32 s50, 0
		scratch_store_dword off, v98, s50 offset:168
		scratch_store_dword off, v99, s50 offset:172
		s_mov_b32 m0, s15
		s_waitcnt lgkmcnt(10)
		s_nop 0
		ds_read_addtid_b32 v74
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v75 offset:2048
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v100, vcc, v74, v98
		v_addc_co_u32_e64 v101, vcc, v75, v99, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v100, s50 offset:128
		scratch_store_dword off, v101, s50 offset:132
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v74 offset:4096
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v75 offset:6144
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v100, vcc, v74, v98
		v_addc_co_u32_e64 v101, vcc, v75, v99, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v100, s50 offset:136
		scratch_store_dword off, v101, s50 offset:140
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v74 offset:8192
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v75 offset:10240
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v100, vcc, v74, v98
		v_addc_co_u32_e64 v101, vcc, v75, v99, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v100, s50 offset:144
		scratch_store_dword off, v101, s50 offset:148
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[20:23], v[16:19], v[12:15], v4, v64 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s50, s45, 1
		s_lshl_b32 s51, s50, 16
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v1, 12, v1
		s_mov_b32 s52, 0
		scratch_store_dword off, v1, s52 offset:152
		v_add_u32_e32 v2, s51, v1
		v_and_b32_e32 v5, 15, v0
		v_lshlrev_b32_e32 v5, 6, v5
		s_mov_b32 s52, 0
		scratch_store_dword off, v5, s52 offset:160
		v_and_b32_e32 v10, 63, v0
		v_lshrrev_b32_e32 v10, 4, v10
		v_and_b32_e32 v67, 15, v0
		v_lshrrev_b32_e32 v67, 1, v67
		v_bitop3_b32 v10, v10, v67, 3 bitop3:0x78
		v_lshlrev_b32_e32 v10, 4, v10
		s_mov_b32 s52, 0
		scratch_store_dword off, v10, s52 offset:164
		v_add3_u32 v2, v2, v5, v10
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[216:219], v2 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[20:23], v[36:39], v[76:79], v4, v64 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s52, s45, 1
		s_lshl_b32 s52, s52, 16
		v_add_u32_e32 v1, s52, v1
		v_add3_u32 v1, v1, v5, v10
		s_mov_b32 s52, 0
		scratch_store_dword off, v1, s52 offset:176
		v_add_u32_e32 v2, 0x1000, v1
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[220:223], v2 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[20:23], v[40:43], v[80:83], v4, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x1000, v1
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[224:227], v2 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[20:23], v[44:47], v[84:87], v4, v65 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		ds_read_b128 v[228:231], v1 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[20:23], v[48:51], v[88:91], v4, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, s51, v5
		v_lshrrev_b32_e32 v2, 6, v0
		v_and_b32_e32 v2, 1, v2
		v_lshlrev_b32_e32 v2, 13, v2
		s_mov_b32 s51, 0
		scratch_store_dword off, v2, s51 offset:156
		v_add3_u32 v1, v1, v2, v10
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		ds_read_b128 v[232:235], v1 offset:49152
		s_mov_b32 s51, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v232, s51 offset:180
		scratch_store_dword off, v233, s51 offset:184
		scratch_store_dword off, v234, s51 offset:188
		scratch_store_dword off, v235, s51 offset:192
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[20:23], v[52:55], v[108:111], v4, v66 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s51, s45, 1
		s_lshl_b32 s51, s51, 16
		v_add_u32_e32 v1, s51, v5
		v_add3_u32 v1, v1, v2, v10
		v_add_u32_e32 v2, 0x1000, v1
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[232:235], v2 offset:50176
		s_mov_b32 s51, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v232, s51 offset:196
		scratch_store_dword off, v233, s51 offset:200
		scratch_store_dword off, v234, s51 offset:204
		scratch_store_dword off, v235, s51 offset:208
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[20:23], v[56:59], v[112:115], v4, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x1000, v1
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[232:235], v2 offset:51200
		s_mov_b32 s51, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v232, s51 offset:212
		scratch_store_dword off, v233, s51 offset:216
		scratch_store_dword off, v234, s51 offset:220
		scratch_store_dword off, v235, s51 offset:224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[20:23], v[60:63], v[116:119], v4, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x1000, v1
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[232:235], v2 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[24:27], v[16:19], v[120:123], v4, v64 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x1000, v1
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[236:239], v2 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[24:27], v[36:39], v[124:127], v4, v64 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x1000, v1
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[240:243], v2 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[24:27], v[40:43], v[128:131], v4, v65 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x1000, v1
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[244:247], v2 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[24:27], v[44:47], v[132:135], v4, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x1000, v1
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[248:251], v2 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[24:27], v[48:51], v[136:139], v4, v66 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s51, 0
		s_waitcnt vmcnt(39)
		scratch_load_dword v20, off, s51 offset:64
		scratch_load_dword v21, off, s51 offset:68
		s_add_i32 m0, s19, 0x6000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v20, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[24:27], v[52:55], v[140:143], v4, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s51, 0
		s_waitcnt vmcnt(37)
		scratch_load_dword v20, off, s51 offset:72
		scratch_load_dword v21, off, s51 offset:76
		s_add_i32 m0, s8, 0x6000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v20, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[56:59], v[144:147], v4, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s51, 0
		s_waitcnt vmcnt(35)
		scratch_load_dword v20, off, s51 offset:80
		scratch_load_dword v21, off, s51 offset:84
		s_add_i32 m0, s9, 0x6000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v20, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[60:63], v[148:151], v4, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s51, 0
		s_waitcnt vmcnt(33)
		scratch_load_dword v20, off, s51 offset:88
		scratch_load_dword v21, off, s51 offset:92
		s_add_i32 m0, s11, 0x6000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v20, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[28:31], v[16:19], v[152:155], v3, v64 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s51, 0
		s_waitcnt vmcnt(31)
		scratch_load_dword v20, off, s51 offset:96
		scratch_load_dword v21, off, s51 offset:100
		s_add_i32 m0, s16, 0x6000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v20, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[28:31], v[36:39], v[156:159], v3, v64 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s51, 0
		s_waitcnt vmcnt(29)
		scratch_load_dword v20, off, s51 offset:104
		scratch_load_dword v21, off, s51 offset:108
		s_add_i32 m0, s32, 0x6000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v20, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[28:31], v[40:43], v[160:163], v3, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s51, 0
		s_waitcnt vmcnt(27)
		scratch_load_dword v20, off, s51 offset:112
		scratch_load_dword v21, off, s51 offset:116
		s_add_i32 m0, s33, 0x6000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v20, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[28:31], v[44:47], v[164:167], v3, v65 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s51, 0
		s_waitcnt vmcnt(25)
		scratch_load_dword v20, off, s51 offset:120
		scratch_load_dword v21, off, s51 offset:124
		s_add_i32 m0, s34, 0x6000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v20, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[28:31], v[48:51], v[168:171], v3, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s51, 0
		s_waitcnt vmcnt(21)
		scratch_load_dword v20, off, s51 offset:128
		scratch_load_dword v21, off, s51 offset:132
		s_add_i32 m0, s37, 0x26000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dword v20, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[28:31], v[52:55], v[172:175], v3, v66 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s51, s45, 1
		s_mov_b32 s52, 0
		s_waitcnt vmcnt(19)
		scratch_load_dword v20, off, s52 offset:136
		scratch_load_dword v21, off, s52 offset:140
		s_add_i32 m0, s4, 0x26000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dword v20, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[56:59], v[176:179], v3, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshl_b32 s50, s50, 12
		s_mov_b32 s52, 0
		s_waitcnt vmcnt(17)
		scratch_load_dword v20, off, s52 offset:144
		scratch_load_dword v21, off, s52 offset:148
		s_add_i32 m0, s36, 0x26000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[60:63], v[180:183], v3, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		s_mov_b32 s52, 0
		s_waitcnt vmcnt(13)
		scratch_load_dword v2, off, s52 offset:176
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[20:23], v2
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[32:35], v[16:19], v[184:187], v3, v64 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s52, 0
		scratch_load_dword v2, off, s52 offset:176
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[24:27], v2 offset:1024
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[32:35], v[36:39], v[188:191], v3, v64 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s52, 0
		scratch_load_dword v2, off, s52 offset:176
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[28:31], v2 offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[32:35], v[40:43], v[192:195], v3, v65 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s52, 0
		scratch_load_dword v2, off, s52 offset:176
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[16:19], v2 offset:3072
		s_mov_b32 s52, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v16, s52 offset:228
		scratch_store_dword off, v17, s52 offset:232
		scratch_store_dword off, v18, s52 offset:236
		scratch_store_dword off, v19, s52 offset:240
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[32:35], v[44:47], v[196:199], v3, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x1000, v1
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[16:19], v2 offset:32768
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[32:35], v[48:51], v[200:203], v3, v66 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x1000, v1
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[36:39], v2 offset:33792
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[32:35], v[52:55], v[204:207], v3, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x1000, v1
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[40:43], v2 offset:34816
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[56:59], v[208:211], v3, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x1000, v1
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[44:47], v2 offset:35840
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[60:63], v[212:215], v3, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x1000, v1
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[48:51], v2 offset:36864
		v_add_u32_e32 v2, 0x1000, v1
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[52:55], v2 offset:37888
		v_add_u32_e32 v2, 0x1000, v1
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[56:59], v2 offset:38912
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		ds_read_b128 v[60:63], v1 offset:39936
		s_add_i32 s50, s50, 0x20000
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v1, 9, v1
		s_mov_b32 s52, 0
		scratch_store_dword off, v1, s52 offset:244
		v_and_b32_e32 v2, 63, v0
		v_lshlrev_b32_e32 v2, 2, v2
		v_add3_u32 v1, s50, v1, v2
		v_add_u32_e32 v5, 0x1000, v1
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		ds_read_b32 v10, v5
		s_mov_b32 s52, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v10, s52 offset:248
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		ds_read_b32 v5, v1 offset:256
		s_mov_b32 s52, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v5, s52 offset:252
		v_lshrrev_b32_e32 v1, 6, v0
		v_and_b32_e32 v1, 1, v1
		v_lshlrev_b32_e32 v1, 10, v1
		s_mov_b32 s52, 0
		scratch_store_dword off, v1, s52 offset:256
		v_add3_u32 v1, s50, v2, v1
		v_add_u32_e32 v5, 0x1000, v1
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		ds_read_b32 v10, v5 offset:2048
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v10, s50 offset:260
		v_add_u32_e32 v5, 0x1000, v1
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		ds_read_b32 v10, v5 offset:2304
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v10, s50 offset:264
		v_add_u32_e32 v5, 0x1000, v1
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		v_add_u32_e32 v5, 0x1000, v5
		ds_read_b32 v10, v5 offset:2560
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v10, s50 offset:268
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		ds_read_b32 v5, v1 offset:2816
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v5, s50 offset:272
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(20)
		scratch_load_dword v32, off, s50 offset:180
		scratch_load_dword v33, off, s50 offset:184
		scratch_load_dword v34, off, s50 offset:188
		scratch_load_dword v35, off, s50 offset:192
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[216:219], v[32:35], v[12:15], v4, v64 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v32, off, s50 offset:196
		scratch_load_dword v33, off, s50 offset:200
		scratch_load_dword v34, off, s50 offset:204
		scratch_load_dword v35, off, s50 offset:208
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[216:219], v[32:35], v[76:79], v4, v64 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v32, off, s50 offset:196
		scratch_load_dword v33, off, s50 offset:200
		scratch_load_dword v34, off, s50 offset:204
		scratch_load_dword v35, off, s50 offset:208
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[220:223], v[32:35], v[124:127], v4, v64 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v32, off, s50 offset:180
		scratch_load_dword v33, off, s50 offset:184
		scratch_load_dword v34, off, s50 offset:188
		scratch_load_dword v35, off, s50 offset:192
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[220:223], v[32:35], v[120:123], v4, v64 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(12)
		scratch_load_dword v32, off, s50 offset:212
		scratch_load_dword v33, off, s50 offset:216
		scratch_load_dword v34, off, s50 offset:220
		scratch_load_dword v35, off, s50 offset:224
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[220:223], v[32:35], v[128:131], v4, v65 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v32, off, s50 offset:212
		scratch_load_dword v33, off, s50 offset:216
		scratch_load_dword v34, off, s50 offset:220
		scratch_load_dword v35, off, s50 offset:224
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[216:219], v[32:35], v[80:83], v4, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[216:219], v[232:235], v[84:87], v4, v65 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[220:223], v[232:235], v[132:135], v4, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[220:223], v[236:239], v[136:139], v4, v66 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[216:219], v[236:239], v[88:91], v4, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[216:219], v[240:243], v[108:111], v4, v66 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[220:223], v[240:243], v[140:143], v4, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[220:223], v[244:247], v[144:147], v4, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[216:219], v[244:247], v[112:115], v4, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[216:219], v[248:251], v[116:119], v4, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[220:223], v[248:251], v[148:151], v4, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[224:227], v[248:251], v[180:183], v3, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[224:227], v[244:247], v[176:179], v3, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[228:231], v[244:247], v[208:211], v3, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[228:231], v[248:251], v[212:215], v3, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v32, off, s50 offset:180
		scratch_load_dword v33, off, s50 offset:184
		scratch_load_dword v34, off, s50 offset:188
		scratch_load_dword v35, off, s50 offset:192
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[228:231], v[32:35], v[184:187], v3, v64 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v32, off, s50 offset:180
		scratch_load_dword v33, off, s50 offset:184
		scratch_load_dword v34, off, s50 offset:188
		scratch_load_dword v35, off, s50 offset:192
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[224:227], v[32:35], v[152:155], v3, v64 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v32, off, s50 offset:196
		scratch_load_dword v33, off, s50 offset:200
		scratch_load_dword v34, off, s50 offset:204
		scratch_load_dword v35, off, s50 offset:208
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[224:227], v[32:35], v[156:159], v3, v64 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v32, off, s50 offset:196
		scratch_load_dword v33, off, s50 offset:200
		scratch_load_dword v34, off, s50 offset:204
		scratch_load_dword v35, off, s50 offset:208
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[228:231], v[32:35], v[188:191], v3, v64 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v32, off, s50 offset:212
		scratch_load_dword v33, off, s50 offset:216
		scratch_load_dword v34, off, s50 offset:220
		scratch_load_dword v35, off, s50 offset:224
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[228:231], v[32:35], v[192:195], v3, v65 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v32, off, s50 offset:212
		scratch_load_dword v33, off, s50 offset:216
		scratch_load_dword v34, off, s50 offset:220
		scratch_load_dword v35, off, s50 offset:224
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[224:227], v[32:35], v[160:163], v3, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[224:227], v[232:235], v[164:167], v3, v65 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[228:231], v[232:235], v[196:199], v3, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[228:231], v[236:239], v[200:203], v3, v66 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[224:227], v[236:239], v[168:171], v3, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[224:227], v[240:243], v[172:175], v3, v66 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[228:231], v[240:243], v[204:207], v3, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s50, s51, 1
		s_lshl_b32 s51, s50, 16
		s_mov_b32 s52, 0
		scratch_load_dword v1, off, s52 offset:152
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v1, s51, v1
		s_mov_b32 s52, 0
		scratch_load_dword v3, off, s52 offset:160
		s_mov_b32 s52, 0
		scratch_load_dword v4, off, s52 offset:164
		s_waitcnt vmcnt(0)
		v_add3_u32 v1, v1, v3, v4
		s_mov_b32 s52, 0
		scratch_store_dword off, v1, s52 offset:276
		v_add_u32_e32 v3, 0x1000, v1
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[32:35], v3
		s_mov_b32 s52, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v32, s52 offset:432
		scratch_store_dword off, v33, s52 offset:436
		scratch_store_dword off, v34, s52 offset:440
		scratch_store_dword off, v35, s52 offset:444
		v_add_u32_e32 v3, 0x1000, v1
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[64:67], v3 offset:1024
		s_mov_b32 s52, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v64, s52 offset:564
		scratch_store_dword off, v65, s52 offset:568
		scratch_store_dword off, v66, s52 offset:572
		scratch_store_dword off, v67, s52 offset:576
		v_add_u32_e32 v3, 0x1000, v1
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[216:219], v3 offset:2048
		s_mov_b32 s52, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v216, s52 offset:596
		scratch_store_dword off, v217, s52 offset:600
		scratch_store_dword off, v218, s52 offset:604
		scratch_store_dword off, v219, s52 offset:608
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		ds_read_b128 v[220:223], v1 offset:3072
		s_mov_b32 s52, 0
		scratch_load_dword v1, off, s52 offset:160
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v1, s51, v1
		s_mov_b32 s51, 0
		scratch_load_dword v3, off, s51 offset:156
		s_mov_b32 s51, 0
		scratch_load_dword v4, off, s51 offset:164
		s_waitcnt vmcnt(0)
		v_add3_u32 v1, v1, v3, v4
		s_mov_b32 s51, 0
		scratch_store_dword off, v1, s51 offset:512
		v_add_u32_e32 v3, 0x1000, v1
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[224:227], v3 offset:32768
		s_mov_b32 s51, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v224, s51 offset:368
		scratch_store_dword off, v225, s51 offset:372
		scratch_store_dword off, v226, s51 offset:376
		scratch_store_dword off, v227, s51 offset:380
		v_add_u32_e32 v3, 0x1000, v1
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[228:231], v3 offset:33792
		s_mov_b32 s51, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s51 offset:384
		scratch_store_dword off, v229, s51 offset:388
		scratch_store_dword off, v230, s51 offset:392
		scratch_store_dword off, v231, s51 offset:396
		v_add_u32_e32 v3, 0x1000, v1
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[232:235], v3 offset:34816
		s_mov_b32 s51, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v232, s51 offset:400
		scratch_store_dword off, v233, s51 offset:404
		scratch_store_dword off, v234, s51 offset:408
		scratch_store_dword off, v235, s51 offset:412
		v_add_u32_e32 v3, 0x1000, v1
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[236:239], v3 offset:35840
		s_mov_b32 s51, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s51 offset:416
		scratch_store_dword off, v237, s51 offset:420
		scratch_store_dword off, v238, s51 offset:424
		scratch_store_dword off, v239, s51 offset:428
		v_add_u32_e32 v3, 0x1000, v1
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[240:243], v3 offset:36864
		s_mov_b32 s51, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v240, s51 offset:448
		scratch_store_dword off, v241, s51 offset:452
		scratch_store_dword off, v242, s51 offset:456
		scratch_store_dword off, v243, s51 offset:460
		v_add_u32_e32 v3, 0x1000, v1
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[244:247], v3 offset:37888
		s_mov_b32 s51, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v244, s51 offset:464
		scratch_store_dword off, v245, s51 offset:468
		scratch_store_dword off, v246, s51 offset:472
		scratch_store_dword off, v247, s51 offset:476
		v_add_u32_e32 v3, 0x1000, v1
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[248:251], v3 offset:38912
		s_mov_b32 s51, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s51 offset:480
		scratch_store_dword off, v249, s51 offset:484
		scratch_store_dword off, v250, s51 offset:488
		scratch_store_dword off, v251, s51 offset:492
		v_add_u32_e32 v3, 0x1000, v1
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[252:255], v3 offset:39936
		s_mov_b32 s51, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v252, s51 offset:496
		scratch_store_dword off, v253, s51 offset:500
		scratch_store_dword off, v254, s51 offset:504
		scratch_store_dword off, v255, s51 offset:508
		s_lshl_b32 s50, s50, 12
		s_add_i32 s50, s50, 0x20000
		s_mov_b32 s51, 0
		s_waitcnt vmcnt(53)
		scratch_load_dword v3, off, s51 offset:244
		s_waitcnt vmcnt(0)
		v_add3_u32 v3, s50, v3, v2
		v_add_u32_e32 v4, 0x1000, v3
		v_add_u32_e32 v4, 0x1000, v4
		v_add_u32_e32 v4, 0x1000, v4
		v_add_u32_e32 v4, 0x1000, v4
		v_add_u32_e32 v4, 0x1000, v4
		v_add_u32_e32 v4, 0x1000, v4
		ds_read_b32 v5, v4
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b32 v10, v3 offset:256
		s_mov_b32 s51, 0
		s_waitcnt vmcnt(50)
		scratch_load_dword v3, off, s51 offset:256
		s_waitcnt vmcnt(0)
		v_add3_u32 v2, s50, v2, v3
		v_add_u32_e32 v3, 0x1000, v2
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b32 v74, v3 offset:2048
		v_add_u32_e32 v3, 0x1000, v2
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b32 v75, v3 offset:2304
		v_add_u32_e32 v3, 0x1000, v2
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b32 v98, v3 offset:2560
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b32 v99, v2 offset:2816
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v2 offset:12288
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v3 offset:14336
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v100, vcc, v2, v68
		v_addc_co_u32_e64 v101, vcc, v3, v69, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v100, s50 offset:280
		scratch_store_dword off, v101, s50 offset:284
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v2 offset:16384
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v3 offset:18432
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v100, vcc, v2, v68
		v_addc_co_u32_e64 v101, vcc, v3, v69, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v100, s50 offset:288
		scratch_store_dword off, v101, s50 offset:292
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v2 offset:20480
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v3 offset:22528
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v100, vcc, v2, v68
		v_addc_co_u32_e64 v101, vcc, v3, v69, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v100, s50 offset:296
		scratch_store_dword off, v101, s50 offset:300
		s_mov_b32 s50, 0
		scratch_load_dword v2, off, s50
		scratch_load_dword v3, off, s50 offset:4
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v100, vcc, v2, v68
		v_addc_co_u32_e64 v101, vcc, v3, v69, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v100, s50 offset:304
		scratch_store_dword off, v101, s50 offset:308
		s_mov_b32 s50, 0
		scratch_load_dword v2, off, s50 offset:8
		scratch_load_dword v3, off, s50 offset:12
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v100, vcc, v2, v68
		v_addc_co_u32_e64 v101, vcc, v3, v69, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v100, s50 offset:312
		scratch_store_dword off, v101, s50 offset:316
		s_mov_b32 s50, 0
		scratch_load_dword v2, off, s50 offset:16
		scratch_load_dword v3, off, s50 offset:20
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v100, vcc, v2, v68
		v_addc_co_u32_e64 v101, vcc, v3, v69, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v100, s50 offset:320
		scratch_store_dword off, v101, s50 offset:324
		s_mov_b32 s50, 0
		scratch_load_dword v2, off, s50 offset:24
		scratch_load_dword v3, off, s50 offset:28
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v100, vcc, v2, v68
		v_addc_co_u32_e64 v101, vcc, v3, v69, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v100, s50 offset:328
		scratch_store_dword off, v101, s50 offset:332
		s_mov_b32 s50, 0
		scratch_load_dword v2, off, s50 offset:32
		scratch_load_dword v3, off, s50 offset:36
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v100, vcc, v2, v68
		v_addc_co_u32_e64 v101, vcc, v3, v69, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v100, s50 offset:336
		scratch_store_dword off, v101, s50 offset:340
		s_mov_b32 s50, 0
		scratch_load_dword v2, off, s50 offset:40
		scratch_load_dword v3, off, s50 offset:44
		s_mov_b32 s50, 0
		scratch_load_dword v68, off, s50 offset:168
		scratch_load_dword v69, off, s50 offset:172
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v100, vcc, v2, v68
		v_addc_co_u32_e64 v101, vcc, v3, v69, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v100, s50 offset:344
		scratch_store_dword off, v101, s50 offset:348
		s_mov_b32 s50, 0
		scratch_load_dword v2, off, s50 offset:48
		scratch_load_dword v3, off, s50 offset:52
		s_mov_b32 s50, 0
		scratch_load_dword v68, off, s50 offset:168
		scratch_load_dword v69, off, s50 offset:172
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v100, vcc, v2, v68
		v_addc_co_u32_e64 v101, vcc, v3, v69, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v100, s50 offset:352
		scratch_store_dword off, v101, s50 offset:356
		s_mov_b32 s50, 0
		scratch_load_dword v2, off, s50 offset:56
		scratch_load_dword v3, off, s50 offset:60
		s_mov_b32 s50, 0
		scratch_load_dword v68, off, s50 offset:168
		scratch_load_dword v69, off, s50 offset:172
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v100, vcc, v2, v68
		v_addc_co_u32_e64 v101, vcc, v3, v69, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v100, s50 offset:360
		scratch_store_dword off, v101, s50 offset:364
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[32:35], v[224:227], v[12:15], v5, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(63) expcnt(7) lgkmcnt(15)
		scratch_load_dword v2, off, s50 offset:276
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[224:227], v2 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[32:35], v[228:231], v[76:79], v5, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v2, off, s50 offset:276
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[228:231], v2 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[32:35], v[232:235], v[80:83], v5, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v2, off, s50 offset:276
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[232:235], v2 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[32:35], v[236:239], v[84:87], v5, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v2, off, s50 offset:276
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[236:239], v2 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[32:35], v[240:243], v[88:91], v5, v98 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x1000, v1
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[32:35], v2 offset:49152
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v32, s50 offset:516
		scratch_store_dword off, v33, s50 offset:520
		scratch_store_dword off, v34, s50 offset:524
		scratch_store_dword off, v35, s50 offset:528
		s_mov_b32 s50, 0
		scratch_load_dword v32, off, s50 offset:432
		scratch_load_dword v33, off, s50 offset:436
		scratch_load_dword v34, off, s50 offset:440
		scratch_load_dword v35, off, s50 offset:444
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[32:35], v[244:247], v[108:111], v5, v98 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x1000, v1
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[32:35], v2 offset:50176
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v32, s50 offset:532
		scratch_store_dword off, v33, s50 offset:536
		scratch_store_dword off, v34, s50 offset:540
		scratch_store_dword off, v35, s50 offset:544
		s_mov_b32 s50, 0
		scratch_load_dword v32, off, s50 offset:432
		scratch_load_dword v33, off, s50 offset:436
		scratch_load_dword v34, off, s50 offset:440
		scratch_load_dword v35, off, s50 offset:444
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[32:35], v[248:251], v[112:115], v5, v99 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x1000, v1
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[32:35], v2 offset:51200
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v32, s50 offset:548
		scratch_store_dword off, v33, s50 offset:552
		scratch_store_dword off, v34, s50 offset:556
		scratch_store_dword off, v35, s50 offset:560
		s_mov_b32 s50, 0
		scratch_load_dword v32, off, s50 offset:432
		scratch_load_dword v33, off, s50 offset:436
		scratch_load_dword v34, off, s50 offset:440
		scratch_load_dword v35, off, s50 offset:444
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[32:35], v[252:255], v[116:119], v5, v99 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x1000, v1
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[32:35], v2 offset:52224
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v32, s50 offset:580
		scratch_store_dword off, v33, s50 offset:584
		scratch_store_dword off, v34, s50 offset:588
		scratch_store_dword off, v35, s50 offset:592
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(63) expcnt(7) lgkmcnt(15)
		scratch_load_dword v32, off, s50 offset:368
		scratch_load_dword v33, off, s50 offset:372
		scratch_load_dword v34, off, s50 offset:376
		scratch_load_dword v35, off, s50 offset:380
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[64:67], v[32:35], v[120:123], v5, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		ds_read_b128 v[32:35], v1 offset:53248
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v32, s50 offset:612
		scratch_store_dword off, v33, s50 offset:616
		scratch_store_dword off, v34, s50 offset:620
		scratch_store_dword off, v35, s50 offset:624
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(63) expcnt(7) lgkmcnt(15)
		scratch_load_dword v32, off, s50 offset:384
		scratch_load_dword v33, off, s50 offset:388
		scratch_load_dword v34, off, s50 offset:392
		scratch_load_dword v35, off, s50 offset:396
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[64:67], v[32:35], v[124:127], v5, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v1, off, s50 offset:512
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		ds_read_b128 v[240:243], v1 offset:54272
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(62)
		scratch_load_dword v32, off, s50 offset:400
		scratch_load_dword v33, off, s50 offset:404
		scratch_load_dword v34, off, s50 offset:408
		scratch_load_dword v35, off, s50 offset:412
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[64:67], v[32:35], v[128:131], v5, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v1, off, s50 offset:512
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		ds_read_b128 v[244:247], v1 offset:55296
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(58)
		scratch_load_dword v32, off, s50 offset:416
		scratch_load_dword v33, off, s50 offset:420
		scratch_load_dword v34, off, s50 offset:424
		scratch_load_dword v35, off, s50 offset:428
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[64:67], v[32:35], v[132:135], v5, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v1, off, s50 offset:512
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		ds_read_b128 v[248:251], v1 offset:56320
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(54)
		scratch_load_dword v32, off, s50 offset:448
		scratch_load_dword v33, off, s50 offset:452
		scratch_load_dword v34, off, s50 offset:456
		scratch_load_dword v35, off, s50 offset:460
		s_mov_b32 s50, 0
		scratch_load_dword v64, off, s50 offset:564
		scratch_load_dword v65, off, s50 offset:568
		scratch_load_dword v66, off, s50 offset:572
		scratch_load_dword v67, off, s50 offset:576
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[64:67], v[32:35], v[136:139], v5, v98 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(40)
		scratch_load_dword v2, off, s50 offset:280
		scratch_load_dword v3, off, s50 offset:284
		s_add_i32 m0, s10, 0x6000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		s_mov_b32 s50, 0
		scratch_load_dword v32, off, s50 offset:464
		scratch_load_dword v33, off, s50 offset:468
		scratch_load_dword v34, off, s50 offset:472
		scratch_load_dword v35, off, s50 offset:476
		s_mov_b32 s50, 0
		scratch_load_dword v64, off, s50 offset:564
		scratch_load_dword v65, off, s50 offset:568
		scratch_load_dword v66, off, s50 offset:572
		scratch_load_dword v67, off, s50 offset:576
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[64:67], v[32:35], v[140:143], v5, v98 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(38)
		scratch_load_dword v2, off, s50 offset:288
		scratch_load_dword v3, off, s50 offset:292
		s_add_i32 m0, s39, 0x6000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		s_mov_b32 s50, 0
		scratch_load_dword v32, off, s50 offset:480
		scratch_load_dword v33, off, s50 offset:484
		scratch_load_dword v34, off, s50 offset:488
		scratch_load_dword v35, off, s50 offset:492
		s_mov_b32 s50, 0
		scratch_load_dword v64, off, s50 offset:564
		scratch_load_dword v65, off, s50 offset:568
		scratch_load_dword v66, off, s50 offset:572
		scratch_load_dword v67, off, s50 offset:576
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[64:67], v[32:35], v[144:147], v5, v99 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(36)
		scratch_load_dword v2, off, s50 offset:296
		scratch_load_dword v3, off, s50 offset:300
		s_add_i32 m0, s40, 0x6000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		s_mov_b32 s50, 0
		scratch_load_dword v32, off, s50 offset:496
		scratch_load_dword v33, off, s50 offset:500
		scratch_load_dword v34, off, s50 offset:504
		scratch_load_dword v35, off, s50 offset:508
		s_mov_b32 s50, 0
		scratch_load_dword v64, off, s50 offset:564
		scratch_load_dword v65, off, s50 offset:568
		scratch_load_dword v66, off, s50 offset:572
		scratch_load_dword v67, off, s50 offset:576
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[64:67], v[32:35], v[148:151], v5, v99 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(34)
		scratch_load_dword v2, off, s50 offset:304
		scratch_load_dword v3, off, s50 offset:308
		s_mov_b32 s50, 0
		scratch_load_dword v1, off, s50 offset:272
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v11, v1
		s_add_i32 m0, s41, 0x6000
		s_nop 0
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		s_mov_b32 s50, 0
		scratch_load_dword v32, off, s50 offset:368
		scratch_load_dword v33, off, s50 offset:372
		scratch_load_dword v34, off, s50 offset:376
		scratch_load_dword v35, off, s50 offset:380
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[216:219], v[32:35], v[152:155], v10, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(32)
		scratch_load_dword v2, off, s50 offset:312
		scratch_load_dword v3, off, s50 offset:316
		s_mov_b32 s50, 0
		scratch_load_dword v1, off, s50 offset:268
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v66, v1
		s_add_i32 m0, s42, 0x6000
		s_nop 0
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_mov_b32 s50, 0
		scratch_load_dword v32, off, s50 offset:384
		scratch_load_dword v33, off, s50 offset:388
		scratch_load_dword v34, off, s50 offset:392
		scratch_load_dword v35, off, s50 offset:396
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[216:219], v[32:35], v[156:159], v10, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(30)
		scratch_load_dword v2, off, s50 offset:320
		scratch_load_dword v3, off, s50 offset:324
		s_mov_b32 s50, 0
		scratch_load_dword v1, off, s50 offset:264
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v65, v1
		s_add_i32 m0, s43, 0x6000
		s_nop 0
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_mov_b32 s50, 0
		scratch_load_dword v32, off, s50 offset:400
		scratch_load_dword v33, off, s50 offset:404
		scratch_load_dword v34, off, s50 offset:408
		scratch_load_dword v35, off, s50 offset:412
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[216:219], v[32:35], v[160:163], v10, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(28)
		scratch_load_dword v2, off, s50 offset:328
		scratch_load_dword v3, off, s50 offset:332
		s_mov_b32 s50, 0
		scratch_load_dword v1, off, s50 offset:260
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v64, v1
		s_add_i32 m0, s44, 0x6000
		s_nop 0
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_mov_b32 s50, 0
		scratch_load_dword v32, off, s50 offset:416
		scratch_load_dword v33, off, s50 offset:420
		scratch_load_dword v34, off, s50 offset:424
		scratch_load_dword v35, off, s50 offset:428
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[216:219], v[32:35], v[164:167], v10, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(26)
		scratch_load_dword v32, off, s50 offset:336
		scratch_load_dword v33, off, s50 offset:340
		s_mov_b32 s50, 0
		scratch_load_dword v1, off, s50 offset:252
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v3, v1
		s_add_i32 m0, s46, 0x6000
		s_nop 0
		buffer_load_dwordx4 v32, s[0:3], 0 offen lds
		s_mov_b32 s50, 0
		scratch_load_dword v32, off, s50 offset:448
		scratch_load_dword v33, off, s50 offset:452
		scratch_load_dword v34, off, s50 offset:456
		scratch_load_dword v35, off, s50 offset:460
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[216:219], v[32:35], v[168:171], v10, v98 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v32, off, s50 offset:344
		scratch_load_dword v33, off, s50 offset:348
		s_mov_b32 s50, 0
		scratch_load_dword v1, off, s50 offset:248
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v4, v1
		s_add_i32 m0, s47, 0x26000
		s_nop 0
		buffer_load_dword v32, s[24:27], 0 offen lds
		s_mov_b32 s50, 0
		scratch_load_dword v32, off, s50 offset:464
		scratch_load_dword v33, off, s50 offset:468
		scratch_load_dword v34, off, s50 offset:472
		scratch_load_dword v35, off, s50 offset:476
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[216:219], v[32:35], v[172:175], v10, v98 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(22)
		scratch_load_dword v68, off, s50 offset:352
		scratch_load_dword v69, off, s50 offset:356
		s_mov_b32 s50, 0
		scratch_load_dword v32, off, s50 offset:228
		scratch_load_dword v33, off, s50 offset:232
		scratch_load_dword v34, off, s50 offset:236
		scratch_load_dword v35, off, s50 offset:240
		s_add_i32 m0, s5, 0x26000
		s_waitcnt vmcnt(4)
		s_nop 0
		buffer_load_dword v68, s[24:27], 0 offen lds
		s_mov_b32 s50, 0
		scratch_load_dword v216, off, s50 offset:480
		scratch_load_dword v217, off, s50 offset:484
		scratch_load_dword v218, off, s50 offset:488
		scratch_load_dword v219, off, s50 offset:492
		s_mov_b32 s50, 0
		scratch_load_dword v252, off, s50 offset:596
		scratch_load_dword v253, off, s50 offset:600
		scratch_load_dword v254, off, s50 offset:604
		scratch_load_dword v255, off, s50 offset:608
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[252:255], v[216:219], v[176:179], v10, v99 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s45, s45, 2
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(20)
		scratch_load_dword v68, off, s50 offset:360
		scratch_load_dword v69, off, s50 offset:364
		s_add_i32 m0, s35, 0x26000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v68, s[28:31], 0 offen lds
		s_mov_b32 s50, 0
		scratch_load_dword v216, off, s50 offset:496
		scratch_load_dword v217, off, s50 offset:500
		scratch_load_dword v218, off, s50 offset:504
		scratch_load_dword v219, off, s50 offset:508
		s_mov_b32 s50, 0
		scratch_load_dword v252, off, s50 offset:596
		scratch_load_dword v253, off, s50 offset:600
		scratch_load_dword v254, off, s50 offset:604
		scratch_load_dword v255, off, s50 offset:608
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[252:255], v[216:219], v[180:183], v10, v99 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v216, off, s50 offset:496
		scratch_load_dword v217, off, s50 offset:500
		scratch_load_dword v218, off, s50 offset:504
		scratch_load_dword v219, off, s50 offset:508
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[220:223], v[216:219], v[212:215], v10, v99 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v216, off, s50 offset:480
		scratch_load_dword v217, off, s50 offset:484
		scratch_load_dword v218, off, s50 offset:488
		scratch_load_dword v219, off, s50 offset:492
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[220:223], v[216:219], v[208:211], v10, v99 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v216, off, s50 offset:368
		scratch_load_dword v217, off, s50 offset:372
		scratch_load_dword v218, off, s50 offset:376
		scratch_load_dword v219, off, s50 offset:380
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[220:223], v[216:219], v[184:187], v10, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v216, off, s50 offset:384
		scratch_load_dword v217, off, s50 offset:388
		scratch_load_dword v218, off, s50 offset:392
		scratch_load_dword v219, off, s50 offset:396
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[220:223], v[216:219], v[188:191], v10, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v216, off, s50 offset:400
		scratch_load_dword v217, off, s50 offset:404
		scratch_load_dword v218, off, s50 offset:408
		scratch_load_dword v219, off, s50 offset:412
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[220:223], v[216:219], v[192:195], v10, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v216, off, s50 offset:416
		scratch_load_dword v217, off, s50 offset:420
		scratch_load_dword v218, off, s50 offset:424
		scratch_load_dword v219, off, s50 offset:428
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[220:223], v[216:219], v[196:199], v10, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v216, off, s50 offset:448
		scratch_load_dword v217, off, s50 offset:452
		scratch_load_dword v218, off, s50 offset:456
		scratch_load_dword v219, off, s50 offset:460
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[220:223], v[216:219], v[200:203], v10, v98 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v216, off, s50 offset:464
		scratch_load_dword v217, off, s50 offset:468
		scratch_load_dword v218, off, s50 offset:472
		scratch_load_dword v219, off, s50 offset:476
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[220:223], v[216:219], v[204:207], v10, v98 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v216, off, s50 offset:516
		scratch_load_dword v217, off, s50 offset:520
		scratch_load_dword v218, off, s50 offset:524
		scratch_load_dword v219, off, s50 offset:528
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[224:227], v[216:219], v[12:15], v5, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(12)
		scratch_load_dword v216, off, s50 offset:532
		scratch_load_dword v217, off, s50 offset:536
		scratch_load_dword v218, off, s50 offset:540
		scratch_load_dword v219, off, s50 offset:544
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[224:227], v[216:219], v[76:79], v5, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v216, off, s50 offset:532
		scratch_load_dword v217, off, s50 offset:536
		scratch_load_dword v218, off, s50 offset:540
		scratch_load_dword v219, off, s50 offset:544
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[228:231], v[216:219], v[124:127], v5, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v216, off, s50 offset:516
		scratch_load_dword v217, off, s50 offset:520
		scratch_load_dword v218, off, s50 offset:524
		scratch_load_dword v219, off, s50 offset:528
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[228:231], v[216:219], v[120:123], v5, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v216, off, s50 offset:548
		scratch_load_dword v217, off, s50 offset:552
		scratch_load_dword v218, off, s50 offset:556
		scratch_load_dword v219, off, s50 offset:560
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[228:231], v[216:219], v[128:131], v5, v75 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v216, off, s50 offset:548
		scratch_load_dword v217, off, s50 offset:552
		scratch_load_dword v218, off, s50 offset:556
		scratch_load_dword v219, off, s50 offset:560
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[224:227], v[216:219], v[80:83], v5, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v216, off, s50 offset:580
		scratch_load_dword v217, off, s50 offset:584
		scratch_load_dword v218, off, s50 offset:588
		scratch_load_dword v219, off, s50 offset:592
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[224:227], v[216:219], v[84:87], v5, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v216, off, s50 offset:580
		scratch_load_dword v217, off, s50 offset:584
		scratch_load_dword v218, off, s50 offset:588
		scratch_load_dword v219, off, s50 offset:592
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[228:231], v[216:219], v[132:135], v5, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v216, off, s50 offset:612
		scratch_load_dword v217, off, s50 offset:616
		scratch_load_dword v218, off, s50 offset:620
		scratch_load_dword v219, off, s50 offset:624
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[228:231], v[216:219], v[136:139], v5, v98 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v216, off, s50 offset:612
		scratch_load_dword v217, off, s50 offset:616
		scratch_load_dword v218, off, s50 offset:620
		scratch_load_dword v219, off, s50 offset:624
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[224:227], v[216:219], v[88:91], v5, v98 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[224:227], v[240:243], v[108:111], v5, v98 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[228:231], v[240:243], v[140:143], v5, v98 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[228:231], v[244:247], v[144:147], v5, v99 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[224:227], v[244:247], v[112:115], v5, v99 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[224:227], v[248:251], v[116:119], v5, v99 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[228:231], v[248:251], v[148:151], v5, v99 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[232:235], v[248:251], v[180:183], v10, v99 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[232:235], v[244:247], v[176:179], v10, v99 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[236:239], v[244:247], v[208:211], v10, v99 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[236:239], v[248:251], v[212:215], v10, v99 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v216, off, s50 offset:516
		scratch_load_dword v217, off, s50 offset:520
		scratch_load_dword v218, off, s50 offset:524
		scratch_load_dword v219, off, s50 offset:528
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[236:239], v[216:219], v[184:187], v10, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v216, off, s50 offset:516
		scratch_load_dword v217, off, s50 offset:520
		scratch_load_dword v218, off, s50 offset:524
		scratch_load_dword v219, off, s50 offset:528
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[232:235], v[216:219], v[152:155], v10, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v216, off, s50 offset:532
		scratch_load_dword v217, off, s50 offset:536
		scratch_load_dword v218, off, s50 offset:540
		scratch_load_dword v219, off, s50 offset:544
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[232:235], v[216:219], v[156:159], v10, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v216, off, s50 offset:532
		scratch_load_dword v217, off, s50 offset:536
		scratch_load_dword v218, off, s50 offset:540
		scratch_load_dword v219, off, s50 offset:544
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[236:239], v[216:219], v[188:191], v10, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v216, off, s50 offset:548
		scratch_load_dword v217, off, s50 offset:552
		scratch_load_dword v218, off, s50 offset:556
		scratch_load_dword v219, off, s50 offset:560
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[236:239], v[216:219], v[192:195], v10, v75 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v216, off, s50 offset:548
		scratch_load_dword v217, off, s50 offset:552
		scratch_load_dword v218, off, s50 offset:556
		scratch_load_dword v219, off, s50 offset:560
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[232:235], v[216:219], v[160:163], v10, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v216, off, s50 offset:580
		scratch_load_dword v217, off, s50 offset:584
		scratch_load_dword v218, off, s50 offset:588
		scratch_load_dword v219, off, s50 offset:592
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[232:235], v[216:219], v[164:167], v10, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v216, off, s50 offset:580
		scratch_load_dword v217, off, s50 offset:584
		scratch_load_dword v218, off, s50 offset:588
		scratch_load_dword v219, off, s50 offset:592
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[236:239], v[216:219], v[196:199], v10, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v216, off, s50 offset:612
		scratch_load_dword v217, off, s50 offset:616
		scratch_load_dword v218, off, s50 offset:620
		scratch_load_dword v219, off, s50 offset:624
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[236:239], v[216:219], v[200:203], v10, v98 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v216, off, s50 offset:612
		scratch_load_dword v217, off, s50 offset:616
		scratch_load_dword v218, off, s50 offset:620
		scratch_load_dword v219, off, s50 offset:624
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[232:235], v[216:219], v[168:171], v10, v98 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[232:235], v[240:243], v[172:175], v10, v98 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[236:239], v[240:243], v[204:207], v10, v98 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_cmp_lt_i32 s45, s38
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_add_i32 s0, s12, -1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[20:23], v[16:19], v[12:15], v4, v64 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s0, s0, 1
		s_lshl_b32 s0, s0, 16
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v1, 12, v1
		v_add_u32_e32 v2, s0, v1
		v_and_b32_e32 v5, 15, v0
		v_lshlrev_b32_e32 v5, 6, v5
		v_and_b32_e32 v6, 63, v0
		v_lshrrev_b32_e32 v6, 4, v6
		v_and_b32_e32 v7, 15, v0
		v_lshrrev_b32_e32 v7, 1, v7
		v_bitop3_b32 v6, v6, v7, 3 bitop3:0x78
		v_lshlrev_b32_e32 v6, 4, v6
		v_add3_u32 v2, v2, v5, v6
		v_add_u32_e32 v7, 0x1000, v2
		v_add_u32_e32 v7, 0x1000, v7
		v_add_u32_e32 v7, 0x1000, v7
		v_add_u32_e32 v7, 0x1000, v7
		v_add_u32_e32 v7, 0x1000, v7
		v_add_u32_e32 v7, 0x1000, v7
		ds_read_b128 v[68:71], v7 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[20:23], v[36:39], v[76:79], v4, v64 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v7, 0x1000, v2
		v_add_u32_e32 v7, 0x1000, v7
		v_add_u32_e32 v7, 0x1000, v7
		v_add_u32_e32 v7, 0x1000, v7
		v_add_u32_e32 v7, 0x1000, v7
		v_add_u32_e32 v7, 0x1000, v7
		ds_read_b128 v[72:75], v7 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[20:23], v[40:43], v[80:83], v4, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v7, 0x1000, v2
		v_add_u32_e32 v7, 0x1000, v7
		v_add_u32_e32 v7, 0x1000, v7
		v_add_u32_e32 v7, 0x1000, v7
		v_add_u32_e32 v7, 0x1000, v7
		v_add_u32_e32 v7, 0x1000, v7
		ds_read_b128 v[92:95], v7 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[20:23], v[44:47], v[84:87], v4, v65 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[96:99], v2 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[20:23], v[48:51], v[88:91], v4, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, s0, v5
		v_lshrrev_b32_e32 v7, 6, v0
		v_and_b32_e32 v7, 1, v7
		v_lshlrev_b32_e32 v7, 13, v7
		v_add3_u32 v2, v2, v7, v6
		v_add_u32_e32 v8, 0x1000, v2
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		ds_read_b128 v[100:103], v8 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[20:23], v[52:55], v[108:111], v4, v66 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v8, 0x1000, v2
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		ds_read_b128 v[104:107], v8 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[20:23], v[56:59], v[112:115], v4, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v8, 0x1000, v2
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		ds_read_b128 v[216:219], v8 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[20:23], v[60:63], v[116:119], v4, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v8, 0x1000, v2
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		ds_read_b128 v[20:23], v8 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[24:27], v[16:19], v[120:123], v4, v64 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v8, 0x1000, v2
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		ds_read_b128 v[220:223], v8 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[24:27], v[36:39], v[124:127], v4, v64 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v8, 0x1000, v2
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		ds_read_b128 v[224:227], v8 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[24:27], v[40:43], v[128:131], v4, v65 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v8, 0x1000, v2
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		v_add_u32_e32 v8, 0x1000, v8
		ds_read_b128 v[228:231], v8 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[24:27], v[44:47], v[132:135], v4, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[232:235], v2 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[24:27], v[48:51], v[136:139], v4, v66 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[24:27], v[52:55], v[140:143], v4, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[56:59], v[144:147], v4, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[60:63], v[148:151], v4, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[60:63], v[180:183], v3, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[56:59], v[176:179], v3, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[56:59], v[208:211], v3, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[60:63], v[212:215], v3, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[32:35], v[16:19], v[184:187], v3, v64 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[28:31], v[16:19], v[152:155], v3, v64 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[28:31], v[36:39], v[156:159], v3, v64 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[32:35], v[36:39], v[188:191], v3, v64 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[32:35], v[40:43], v[192:195], v3, v65 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[28:31], v[40:43], v[160:163], v3, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[28:31], v[44:47], v[164:167], v3, v65 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[32:35], v[44:47], v[196:199], v3, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[32:35], v[48:51], v[200:203], v3, v66 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[28:31], v[48:51], v[168:171], v3, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[28:31], v[52:55], v[172:175], v3, v66 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[32:35], v[52:55], v[204:207], v3, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[92:95], v[220:223], v[168:171], v3, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[92:95], v[224:227], v[172:175], v3, v66 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[96:99], v[224:227], v[204:207], v3, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[96:99], v[220:223], v[200:203], v3, v66 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[68:71], v[220:223], v[88:91], v4, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[68:71], v[224:227], v[108:111], v4, v66 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[72:75], v[224:227], v[140:143], v4, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[72:75], v[220:223], v[136:139], v4, v66 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[72:75], v[100:103], v[120:123], v4, v64 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[68:71], v[100:103], v[12:15], v4, v64 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[68:71], v[104:107], v[76:79], v4, v64 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[72:75], v[104:107], v[124:127], v4, v64 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[72:75], v[216:219], v[128:131], v4, v65 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[68:71], v[216:219], v[80:83], v4, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[68:71], v[20:23], v[84:87], v4, v65 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[72:75], v[20:23], v[132:135], v4, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[72:75], v[228:231], v[144:147], v4, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[68:71], v[228:231], v[112:115], v4, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[68:71], v[232:235], v[116:119], v4, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[72:75], v[232:235], v[148:151], v4, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[92:95], v[232:235], v[180:183], v3, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[92:95], v[228:231], v[176:179], v3, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[96:99], v[228:231], v[208:211], v3, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[96:99], v[232:235], v[212:215], v3, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[96:99], v[100:103], v[184:187], v3, v64 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[92:95], v[100:103], v[152:155], v3, v64 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[92:95], v[104:107], v[156:159], v3, v64 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[96:99], v[104:107], v[188:191], v3, v64 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[96:99], v[216:219], v[192:195], v3, v65 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[92:95], v[216:219], v[160:163], v3, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[92:95], v[20:23], v[164:167], v3, v65 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[96:99], v[20:23], v[196:199], v3, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s0, s12, 1
		s_lshl_b32 s1, s0, 16
		v_add_u32_e32 v1, s1, v1
		v_add3_u32 v1, v1, v5, v6
		v_add_u32_e32 v2, 0x1000, v1
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[8:11], v2
		v_add_u32_e32 v2, 0x1000, v1
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[16:19], v2 offset:1024
		v_add_u32_e32 v2, 0x1000, v1
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[20:23], v2 offset:2048
		v_add_u32_e32 v2, 0x1000, v1
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		v_add_u32_e32 v2, 0x1000, v2
		ds_read_b128 v[24:27], v2 offset:3072
		v_add_u32_e32 v2, s1, v5
		v_add3_u32 v2, v2, v7, v6
		v_add_u32_e32 v3, 0x1000, v2
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[4:7], v3 offset:32768
		v_add_u32_e32 v3, 0x1000, v2
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[28:31], v3 offset:33792
		v_add_u32_e32 v3, 0x1000, v2
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[32:35], v3 offset:34816
		v_add_u32_e32 v3, 0x1000, v2
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[36:39], v3 offset:35840
		v_add_u32_e32 v3, 0x1000, v2
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[40:43], v3 offset:36864
		v_add_u32_e32 v3, 0x1000, v2
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[44:47], v3 offset:37888
		v_add_u32_e32 v3, 0x1000, v2
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[48:51], v3 offset:38912
		v_add_u32_e32 v3, 0x1000, v2
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[52:55], v3 offset:39936
		s_lshl_b32 s0, s0, 12
		s_add_i32 s0, s0, 0x20000
		v_lshrrev_b32_e32 v3, 7, v0
		v_lshlrev_b32_e32 v3, 9, v3
		v_and_b32_e32 v56, 63, v0
		v_lshlrev_b32_e32 v56, 2, v56
		v_add3_u32 v3, s0, v3, v56
		v_add_u32_e32 v57, 0x1000, v3
		v_add_u32_e32 v57, 0x1000, v57
		v_add_u32_e32 v57, 0x1000, v57
		v_add_u32_e32 v57, 0x1000, v57
		v_add_u32_e32 v57, 0x1000, v57
		v_add_u32_e32 v57, 0x1000, v57
		ds_read_b32 v58, v57
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b32 v57, v3 offset:256
		v_lshrrev_b32_e32 v3, 6, v0
		v_and_b32_e32 v3, 1, v3
		v_lshlrev_b32_e32 v3, 10, v3
		v_add3_u32 v3, s0, v56, v3
		v_add_u32_e32 v56, 0x1000, v3
		v_add_u32_e32 v56, 0x1000, v56
		v_add_u32_e32 v56, 0x1000, v56
		v_add_u32_e32 v56, 0x1000, v56
		v_add_u32_e32 v56, 0x1000, v56
		v_add_u32_e32 v56, 0x1000, v56
		ds_read_b32 v59, v56 offset:2048
		v_add_u32_e32 v56, 0x1000, v3
		v_add_u32_e32 v56, 0x1000, v56
		v_add_u32_e32 v56, 0x1000, v56
		v_add_u32_e32 v56, 0x1000, v56
		v_add_u32_e32 v56, 0x1000, v56
		v_add_u32_e32 v56, 0x1000, v56
		ds_read_b32 v60, v56 offset:2304
		v_add_u32_e32 v56, 0x1000, v3
		v_add_u32_e32 v56, 0x1000, v56
		v_add_u32_e32 v56, 0x1000, v56
		v_add_u32_e32 v56, 0x1000, v56
		v_add_u32_e32 v56, 0x1000, v56
		v_add_u32_e32 v56, 0x1000, v56
		ds_read_b32 v61, v56 offset:2560
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b32 v56, v3 offset:2816
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[8:11], v[4:7], v[12:15], v58, v59 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x1000, v1
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[64:67], v3 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[8:11], v[28:31], v[76:79], v58, v59 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x1000, v1
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[68:71], v3 offset:17408
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[8:11], v[32:35], v[80:83], v58, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v3, 0x1000, v1
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		v_add_u32_e32 v3, 0x1000, v3
		ds_read_b128 v[72:75], v3 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[8:11], v[36:39], v[84:87], v58, v60 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		ds_read_b128 v[92:95], v1 offset:19456
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[8:11], v[40:43], v[88:91], v58, v61 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x1000, v2
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		ds_read_b128 v[96:99], v1 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[8:11], v[44:47], v[108:111], v58, v61 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x1000, v2
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		ds_read_b128 v[100:103], v1 offset:50176
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[8:11], v[48:51], v[112:115], v58, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x1000, v2
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		ds_read_b128 v[104:107], v1 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[8:11], v[52:55], v[116:119], v58, v56 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x1000, v2
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		ds_read_b128 v[8:11], v1 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[16:19], v[4:7], v[120:123], v58, v59 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x1000, v2
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		ds_read_b128 v[216:219], v1 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[28:31], v[124:127], v58, v59 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x1000, v2
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		ds_read_b128 v[220:223], v1 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[32:35], v[128:131], v58, v60 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x1000, v2
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		ds_read_b128 v[224:227], v1 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[16:19], v[36:39], v[132:135], v58, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x1000, v2
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		v_add_u32_e32 v1, 0x1000, v1
		ds_read_b128 v[228:231], v1 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[40:43], v[136:139], v58, v61 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[16:19], v[44:47], v[140:143], v58, v61 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[16:19], v[48:51], v[144:147], v58, v56 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[16:19], v[52:55], v[148:151], v58, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[20:23], v[52:55], v[180:183], v57, v56 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[20:23], v[48:51], v[176:179], v57, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], v[48:51], v[208:211], v57, v56 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[24:27], v[52:55], v[212:215], v57, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[4:7], v[184:187], v57, v59 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[4:7], v[152:155], v57, v59 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[28:31], v[156:159], v57, v59 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[28:31], v[188:191], v57, v59 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[32:35], v[192:195], v57, v60 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[32:35], v[160:163], v57, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[36:39], v[164:167], v57, v60 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[36:39], v[196:199], v57, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[40:43], v[200:203], v57, v61 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[40:43], v[168:171], v57, v61 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[44:47], v[172:175], v57, v61 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[44:47], v[204:207], v57, v61 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[72:75], v[216:219], v[168:171], v57, v61 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[72:75], v[220:223], v[172:175], v57, v61 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[92:95], v[220:223], v[204:207], v57, v61 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[92:95], v[216:219], v[200:203], v57, v61 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[64:67], v[216:219], v[88:91], v58, v61 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[64:67], v[220:223], v[108:111], v58, v61 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[68:71], v[220:223], v[140:143], v58, v61 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[68:71], v[216:219], v[136:139], v58, v61 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[68:71], v[96:99], v[120:123], v58, v59 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[64:67], v[96:99], v[12:15], v58, v59 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[64:67], v[100:103], v[76:79], v58, v59 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[68:71], v[100:103], v[124:127], v58, v59 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[68:71], v[104:107], v[128:131], v58, v60 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[64:67], v[104:107], v[80:83], v58, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[64:67], v[8:11], v[84:87], v58, v60 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[68:71], v[8:11], v[132:135], v58, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[68:71], v[224:227], v[144:147], v58, v56 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[64:67], v[224:227], v[112:115], v58, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[64:67], v[228:231], v[116:119], v58, v56 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[68:71], v[228:231], v[148:151], v58, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[72:75], v[228:231], v[180:183], v57, v56 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[72:75], v[224:227], v[176:179], v57, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[92:95], v[224:227], v[208:211], v57, v56 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[92:95], v[228:231], v[212:215], v57, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[92:95], v[96:99], v[184:187], v57, v59 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[72:75], v[96:99], v[152:155], v57, v59 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[72:75], v[100:103], v[156:159], v57, v59 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[92:95], v[100:103], v[188:191], v57, v59 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[92:95], v[104:107], v[192:195], v57, v60 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[72:75], v[104:107], v[160:163], v57, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[72:75], v[8:11], v[164:167], v57, v60 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[92:95], v[8:11], v[196:199], v57, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v12, v13
		v_cvt_pk_f16_f32 v3, v14, v15
		v_and_b32_e32 v0, 63, v0
		v_lshlrev_b32_e32 v0, 3, v0
		v_lshl_add_u32 v0, s17, 14, v0
		s_lshl_b32 s0, s13, 21
		s_lshl_b32 s1, s14, 17
		s_add_i32 s2, s0, s1
		s_mov_b32 s16, s6
		s_mov_b32 s17, s7
		s_mov_b32 s19, s23
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen
		v_cvt_pk_f16_f32 v2, v76, v77
		v_cvt_pk_f16_f32 v3, v78, v79
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:512
		v_cvt_pk_f16_f32 v2, v80, v81
		v_cvt_pk_f16_f32 v3, v82, v83
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:1024
		v_cvt_pk_f16_f32 v2, v84, v85
		v_cvt_pk_f16_f32 v3, v86, v87
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:1536
		v_cvt_pk_f16_f32 v2, v88, v89
		v_cvt_pk_f16_f32 v3, v90, v91
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:2048
		v_cvt_pk_f16_f32 v2, v108, v109
		v_cvt_pk_f16_f32 v3, v110, v111
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:2560
		v_cvt_pk_f16_f32 v2, v112, v113
		v_cvt_pk_f16_f32 v3, v114, v115
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:3072
		v_cvt_pk_f16_f32 v2, v116, v117
		v_cvt_pk_f16_f32 v3, v118, v119
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:3584
		v_cvt_pk_f16_f32 v2, v120, v121
		v_cvt_pk_f16_f32 v3, v122, v123
		s_add_i32 s2, s0, 0x1000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen
		v_cvt_pk_f16_f32 v2, v124, v125
		v_cvt_pk_f16_f32 v3, v126, v127
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:512
		v_cvt_pk_f16_f32 v2, v128, v129
		v_cvt_pk_f16_f32 v3, v130, v131
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:1024
		v_cvt_pk_f16_f32 v2, v132, v133
		v_cvt_pk_f16_f32 v3, v134, v135
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:1536
		v_cvt_pk_f16_f32 v2, v136, v137
		v_cvt_pk_f16_f32 v3, v138, v139
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:2048
		v_cvt_pk_f16_f32 v2, v140, v141
		v_cvt_pk_f16_f32 v3, v142, v143
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:2560
		v_cvt_pk_f16_f32 v2, v144, v145
		v_cvt_pk_f16_f32 v3, v146, v147
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:3072
		v_cvt_pk_f16_f32 v2, v148, v149
		v_cvt_pk_f16_f32 v3, v150, v151
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:3584
		v_cvt_pk_f16_f32 v2, v152, v153
		v_cvt_pk_f16_f32 v3, v154, v155
		s_add_i32 s2, s0, 0x2000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen
		v_cvt_pk_f16_f32 v2, v156, v157
		v_cvt_pk_f16_f32 v3, v158, v159
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:512
		v_cvt_pk_f16_f32 v2, v160, v161
		v_cvt_pk_f16_f32 v3, v162, v163
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:1024
		v_cvt_pk_f16_f32 v2, v164, v165
		v_cvt_pk_f16_f32 v3, v166, v167
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:1536
		v_cvt_pk_f16_f32 v2, v168, v169
		v_cvt_pk_f16_f32 v3, v170, v171
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:2048
		v_cvt_pk_f16_f32 v2, v172, v173
		v_cvt_pk_f16_f32 v3, v174, v175
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:2560
		v_cvt_pk_f16_f32 v2, v176, v177
		v_cvt_pk_f16_f32 v3, v178, v179
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:3072
		v_cvt_pk_f16_f32 v2, v180, v181
		v_cvt_pk_f16_f32 v3, v182, v183
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:3584
		v_cvt_pk_f16_f32 v2, v184, v185
		v_cvt_pk_f16_f32 v3, v186, v187
		s_add_i32 s0, s0, 0x3000
		s_add_i32 s0, s0, s1
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen
		v_cvt_pk_f16_f32 v2, v188, v189
		v_cvt_pk_f16_f32 v3, v190, v191
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:512
		v_cvt_pk_f16_f32 v2, v192, v193
		v_cvt_pk_f16_f32 v3, v194, v195
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v196, v197
		v_cvt_pk_f16_f32 v3, v198, v199
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:1536
		v_cvt_pk_f16_f32 v2, v200, v201
		v_cvt_pk_f16_f32 v3, v202, v203
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v204, v205
		v_cvt_pk_f16_f32 v3, v206, v207
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v208, v209
		v_cvt_pk_f16_f32 v3, v210, v211
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v212, v213
		v_cvt_pk_f16_f32 v3, v214, v215
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:3584
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 24576
		.amdhsa_private_segment_fixed_size 628
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
		.amdhsa_next_free_vgpr 256
		.amdhsa_next_free_sgpr 53
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
	.set .Lwmma_f16_matmul_tiled.num_agpr, 0
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 53
	.set .Lwmma_f16_matmul_tiled.num_named_barrier, 0
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 628
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
    .max_flat_workgroup_size: 512
    .name:           wmma_f16_matmul_tiled
    .private_segment_fixed_size: 628
    .sgpr_count:     53
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     256
    .agpr_count:     0
    .vgpr_spill_count: 157
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 83
    wave.regalloc.agpr.dwords: 0
    wave.regalloc.remat.dwords: 12
    wave.regalloc.sgpr_to_vgpr.dwords: 0
    wave.regalloc.lds.dwords: 12
    wave.regalloc.scratch.dwords: 157
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
