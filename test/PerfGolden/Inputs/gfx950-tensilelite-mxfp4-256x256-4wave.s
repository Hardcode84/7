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
		v_mov_b32_e32 v3, 0
		s_mov_b32 s16, 1
		s_mov_b32 s17, 0
		s_and_saveexec_b64 s[18:19], s[16:17]
		ds_write_b32 v3, v3
		v_mov_b32_e32 v1, 4
		ds_write_b32 v1, v3
		v_mov_b32_e32 v2, 8
		ds_write_b32 v2, v3
		v_mov_b32_e32 v2, 12
		ds_write_b32 v2, v3
		s_mov_b64 exec, s[18:19]
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mov_b32 s22, 0x7fffffff
		s_mov_b32 s23, 0x31016000
		s_mov_b32 s20, s6
		s_mov_b32 s21, s7
		s_mov_b32 s26, 0x1000000
		s_mov_b32 s24, s2
		s_mov_b32 s25, s3
		s_mov_b32 s27, s23
		s_mov_b32 s0, s4
		s_mov_b32 s1, s5
		s_mov_b32 s2, s26
		s_mov_b32 s3, s23
		s_mov_b32 s4, s8
		s_mov_b32 s5, s9
		s_mov_b32 s6, s26
		s_mov_b32 s7, s23
		s_mov_b32 s28, s10
		s_mov_b32 s29, s11
		s_mov_b32 s30, s26
		s_mov_b32 s31, s23
		v_readfirstlane_b32 s8, v0
		s_lshl_b32 s9, s13, 20
		v_lshrrev_b32_e32 v2, 6, v0
		v_lshlrev_b32_e32 v4, 16, v2
		v_add_u32_e32 v5, s9, v4
		v_and_b32_e32 v6, 63, v0
		s_mov_b32 s10, 0
		scratch_store_dword off, v6, s10
		v_lshrrev_b32_e32 v7, 2, v6
		v_lshlrev_b32_e32 v7, 12, v7
		v_lshrrev_b32_e32 v8, 3, v6
		v_and_b32_e32 v8, 3, v8
		v_and_b32_e32 v9, 3, v6
		v_xor_b32_e32 v8, v8, v9
		v_lshlrev_b32_e32 v8, 4, v8
		v_add3_u32 v5, v5, v7, v8
		s_add_i32 s10, s9, 0x40000
		v_add_u32_e32 v9, v4, v7
		s_add_i32 s11, s9, 0x80000
		s_add_i32 s15, s9, 0xc0000
		s_add_i32 s18, s9, 64
		v_add_u32_e32 v10, v4, v7
		s_add_i32 s19, s9, 0x40040
		s_add_i32 s32, s9, 0x80040
		s_add_i32 s33, s9, 0xc0040
		v_add_u32_e32 v11, v4, v7
		s_lshl_b32 s34, s14, 20
		s_add_i32 s35, s34, 0x40000
		s_add_i32 s36, s34, 0x80000
		v_add3_u32 v12, v4, v7, v8
		s_add_i32 s37, s34, 0xc0000
		s_add_i32 s38, s34, 0x40040
		v_add_u32_e32 v13, v4, v7
		s_add_i32 s39, s34, 0x80040
		s_add_i32 s40, s34, 0xc0040
		s_lshr_b32 s41, s8, 6
		s_lshl_b32 s42, s41, 10
		v_mov_b64_e32 v[16:17], 0
		v_mov_b64_e32 v[18:19], 0
		s_add_i32 m0, s42, 16
		s_nop 0
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		v_add3_u32 v5, v8, v9, s10
		s_add_i32 m0, s42, 0x1010
		s_nop 0
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		v_add3_u32 v5, v8, v9, s11
		s_add_i32 m0, s42, 0x2010
		s_nop 0
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		v_add3_u32 v5, v8, v9, s15
		s_add_i32 m0, s42, 0x3010
		s_nop 0
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		v_add3_u32 v5, v8, v10, s18
		s_add_i32 m0, s42, 0x4010
		s_nop 0
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		v_add3_u32 v5, v8, v10, s19
		s_add_i32 m0, s42, 0x5010
		s_nop 0
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		v_add3_u32 v5, v8, v10, s32
		s_add_i32 m0, s42, 0x6010
		s_nop 0
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		v_add3_u32 v5, v8, v11, s33
		s_add_i32 m0, s42, 0x7010
		s_nop 0
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		v_add3_u32 v5, v8, v11, s34
		s_add_i32 m0, s42, 0x8010
		s_nop 0
		buffer_load_dwordx4 v5, s[0:3], 0 offen lds
		v_add3_u32 v5, v8, v11, s35
		s_add_i32 m0, s42, 0x9010
		s_nop 0
		buffer_load_dwordx4 v5, s[0:3], 0 offen lds
		v_add_u32_e32 v5, s36, v12
		s_add_i32 m0, s42, 0xa010
		s_nop 0
		buffer_load_dwordx4 v5, s[0:3], 0 offen lds
		v_add_u32_e32 v5, s37, v12
		s_add_i32 m0, s42, 0xb010
		s_nop 0
		buffer_load_dwordx4 v5, s[0:3], 0 offen lds
		v_add3_u32 v5, v12, s34, 64
		s_add_i32 m0, s42, 0xc010
		s_nop 0
		buffer_load_dwordx4 v5, s[0:3], 0 offen lds
		v_add3_u32 v5, v8, v13, s38
		s_add_i32 m0, s42, 0xd010
		s_nop 0
		buffer_load_dwordx4 v5, s[0:3], 0 offen lds
		v_add3_u32 v5, v8, v13, s39
		s_add_i32 m0, s42, 0xe010
		s_nop 0
		buffer_load_dwordx4 v5, s[0:3], 0 offen lds
		v_add3_u32 v5, v8, v13, s40
		s_add_i32 m0, s42, 0xf010
		s_nop 0
		buffer_load_dwordx4 v5, s[0:3], 0 offen lds
		s_lshl_b32 s10, s14, 16
		s_add_i32 s11, s9, s10
		v_lshrrev_b32_e32 v5, 7, v0
		v_lshlrev_b32_e32 v9, 10, v5
		v_lshlrev_b32_e32 v10, 4, v6
		v_add3_u32 v11, s11, v9, v10
		s_lshr_b32 s8, s8, 7
		s_lshl_b32 s15, s8, 10
		v_and_b32_e32 v2, 1, v2
		v_lshlrev_b32_e32 v12, 10, v2
		v_add3_u32 v13, s11, v10, v12
		s_and_b32 s8, s41, 1
		s_lshl_b32 s8, s8, 10
		s_add_i32 s11, s42, 0x1000
		s_add_i32 m0, s15, 0x20010
		s_nop 0
		buffer_load_dwordx4 v11, s[4:7], 0 offen lds
		s_add_i32 s18, s42, 0x2000
		s_add_i32 m0, s8, 0x20810
		s_nop 0
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		v_mov_b32_e32 v11, 1
		s_and_saveexec_b64 s[32:33], s[16:17]
		s_waitcnt vmcnt(0)
		ds_add_rtn_u32 v13, v3, v11
		s_mov_b64 exec, s[32:33]
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s19, v13
		s_and_b32 s19, s19, -4
		s_add_i32 s19, s19, 4
		s_and_saveexec_b64 s[32:33], s[16:17]
.Lwmma_f16_matmul_tiled.loop_head_0:
		ds_read_b32 v13, v3
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s35, v13
		s_xor_b32 s36, s19, -1
		s_add_i32 s36, s36, 1
		s_add_i32 s35, s35, s36
		s_cmp_ge_u32 s35, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_mov_b64 exec, s[32:33]
		v_lshlrev_b32_e32 v5, 13, v5
		v_and_b32_e32 v13, 15, v0
		v_lshlrev_b32_e32 v14, 6, v13
		v_lshrrev_b32_e32 v15, 4, v6
		v_lshrrev_b32_e32 v13, 1, v13
		v_and_b32_e32 v13, 3, v13
		v_xor_b32_e32 v13, v15, v13
		v_lshlrev_b32_e32 v13, 4, v13
		v_add3_u32 v15, v5, v14, v13
		v_add_u32_e32 v15, 16, v15
		ds_read_b128 a[0:3], v15
		ds_read_b128 a[4:7], v15 offset:1024
		ds_read_b128 a[8:11], v15 offset:2048
		ds_read_b128 a[12:15], v15 offset:3072
		ds_read_b128 v[20:23], v15 offset:4096
		ds_read_b128 v[24:27], v15 offset:5120
		ds_read_b128 v[28:31], v15 offset:6144
		ds_read_b128 v[32:35], v15 offset:7168
		v_lshlrev_b32_e32 v15, 13, v2
		v_add3_u32 v2, v14, v15, v13
		v_add_u32_e32 v2, 16, v2
		ds_read_b128 v[36:39], v2 offset:32768
		ds_read_b128 v[40:43], v2 offset:33792
		ds_read_b128 v[44:47], v2 offset:34816
		ds_read_b128 v[48:51], v2 offset:35840
		ds_read_b128 v[52:55], v2 offset:36864
		ds_read_b128 v[56:59], v2 offset:37888
		ds_read_b128 v[60:63], v2 offset:38912
		ds_read_b128 v[64:67], v2 offset:39936
		v_add_u32_e32 v2, 0x20000, v9
		v_lshlrev_b32_e32 v6, 2, v6
		v_add_u32_e32 v2, v2, v6
		v_add_u32_e32 v2, 16, v2
		ds_read_b32 v68, v2
		ds_read_b32 v69, v2 offset:256
		ds_read_b32 v70, v2 offset:512
		ds_read_b32 v71, v2 offset:768
		v_add_u32_e32 v2, 0x20000, v6
		v_add_u32_e32 v2, v2, v12
		v_add_u32_e32 v2, 16, v2
		ds_read_b32 v6, v2 offset:2048
		ds_read_b32 v72, v2 offset:2304
		ds_read_b32 v73, v2 offset:2560
		ds_read_b32 v74, v2 offset:2816
		s_add_i32 s19, s9, 0x80
		v_add_u32_e32 v2, s19, v4
		v_add3_u32 v2, v2, v7, v8
		s_add_i32 s19, s9, 0x40080
		v_add_u32_e32 v75, v4, v7
		v_add3_u32 v76, v8, v75, s19
		s_add_i32 s19, s9, 0x80080
		v_add3_u32 v77, v8, v75, s19
		s_add_i32 s19, s9, 0xc0080
		v_add3_u32 v75, v8, v75, s19
		s_add_i32 s19, s9, 0xc0
		v_add_u32_e32 v78, v4, v7
		v_add3_u32 v79, v8, v78, s19
		s_add_i32 s19, s9, 0x400c0
		v_add3_u32 v80, v8, v78, s19
		s_add_i32 s19, s9, 0x800c0
		v_add3_u32 v78, v8, v78, s19
		s_add_i32 s19, s9, 0xc00c0
		v_add_u32_e32 v81, v4, v7
		v_add3_u32 v82, v8, v81, s19
		s_add_i32 s19, s34, 0x80
		v_add3_u32 v83, v8, v81, s19
		s_add_i32 s19, s34, 0x40080
		v_add3_u32 v81, v8, v81, s19
		s_add_i32 s19, s34, 0x80080
		v_add_u32_e32 v84, v4, v7
		v_add3_u32 v85, v8, v84, s19
		s_add_i32 s19, s34, 0xc0080
		v_add3_u32 v86, v8, v84, s19
		s_add_i32 s19, s34, 0xc0
		v_add3_u32 v84, v8, v84, s19
		s_add_i32 s19, s34, 0x400c0
		v_add_u32_e32 v4, v4, v7
		v_add3_u32 v7, v8, v4, s19
		s_add_i32 s19, s34, 0x800c0
		s_add_i32 s32, s34, 0xc00c0
		s_add_i32 s33, s42, 0x12000
		s_add_i32 s34, s42, 0x13000
		s_add_i32 s35, s42, 0x14000
		s_add_i32 s36, s42, 0x15000
		s_add_i32 s37, s42, 0x16000
		s_add_i32 s38, s42, 0x17000
		s_add_i32 s39, s42, 0x18000
		s_add_i32 s40, s42, 0x19000
		s_add_i32 s41, s42, 0x1a000
		s_add_i32 s43, s42, 0x1b000
		s_add_i32 s44, s42, 0x1c000
		s_add_i32 s45, s42, 0x1d000
		s_add_i32 s46, s42, 0x1e000
		s_add_i32 s47, s42, 0x1f000
		s_add_i32 s48, s42, 0x3000
		s_add_i32 m0, s42, 0x10010
		s_nop 0
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		s_add_i32 s49, s42, 0x4000
		s_add_i32 m0, s42, 0x11010
		s_nop 0
		buffer_load_dwordx4 v76, s[24:27], 0 offen lds
		s_add_i32 s50, s42, 0x5000
		s_add_i32 m0, s42, 0x12010
		s_nop 0
		buffer_load_dwordx4 v77, s[24:27], 0 offen lds
		s_add_i32 s51, s42, 0x6000
		s_add_i32 m0, s42, 0x13010
		s_nop 0
		buffer_load_dwordx4 v75, s[24:27], 0 offen lds
		s_add_i32 s52, s42, 0x7000
		s_add_i32 m0, s42, 0x14010
		s_nop 0
		buffer_load_dwordx4 v79, s[24:27], 0 offen lds
		s_add_i32 s53, s42, 0x8000
		s_add_i32 m0, s42, 0x15010
		s_nop 0
		buffer_load_dwordx4 v80, s[24:27], 0 offen lds
		s_add_i32 s54, s42, 0x9000
		s_add_i32 m0, s42, 0x16010
		s_nop 0
		buffer_load_dwordx4 v78, s[24:27], 0 offen lds
		s_add_i32 s55, s42, 0xa000
		s_add_i32 m0, s42, 0x17010
		s_nop 0
		buffer_load_dwordx4 v82, s[24:27], 0 offen lds
		s_add_i32 s56, s42, 0xb000
		s_add_i32 m0, s42, 0x18010
		s_nop 0
		buffer_load_dwordx4 v83, s[0:3], 0 offen lds
		s_add_i32 s57, s42, 0xc000
		s_add_i32 m0, s42, 0x19010
		s_nop 0
		buffer_load_dwordx4 v81, s[0:3], 0 offen lds
		s_add_i32 s58, s42, 0xd000
		s_add_i32 m0, s42, 0x1a010
		s_nop 0
		buffer_load_dwordx4 v85, s[0:3], 0 offen lds
		s_add_i32 s59, s42, 0xe000
		s_add_i32 m0, s42, 0x1b010
		s_nop 0
		buffer_load_dwordx4 v86, s[0:3], 0 offen lds
		s_add_i32 s60, s42, 0xf000
		s_add_i32 m0, s42, 0x1c010
		s_nop 0
		buffer_load_dwordx4 v84, s[0:3], 0 offen lds
		s_add_i32 s61, s8, 0x800
		s_add_i32 m0, s42, 0x1d010
		s_nop 0
		buffer_load_dwordx4 v7, s[0:3], 0 offen lds
		v_add3_u32 v2, v8, v4, s19
		s_add_i32 m0, s42, 0x1e010
		s_nop 0
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		v_add3_u32 v2, v8, v4, s32
		s_add_i32 m0, s42, 0x1f010
		s_nop 0
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_add_i32 s9, s9, 0x800
		s_add_i32 s9, s9, s10
		v_add3_u32 v2, s9, v9, v10
		s_add_i32 s10, s15, 0x1000
		v_add3_u32 v4, s9, v10, v12
		s_add_i32 s9, s8, 0x1800
		s_add_i32 s19, s42, 0x10000
		s_add_i32 m0, s15, 0x21010
		s_nop 0
		buffer_load_dwordx4 v2, s[4:7], 0 offen lds
		s_add_i32 s32, s42, 0x11000
		s_add_i32 m0, s8, 0x21810
		s_nop 0
		buffer_load_dwordx4 v4, s[28:31], 0 offen lds
		s_and_saveexec_b64 s[62:63], s[16:17]
		s_waitcnt vmcnt(0)
		ds_add_rtn_u32 v2, v1, v11
		s_mov_b64 exec, s[62:63]
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s8, v2
		s_and_b32 s8, s8, -4
		s_add_i32 s8, s8, 4
		s_and_saveexec_b64 s[62:63], s[16:17]
.Lwmma_f16_matmul_tiled.loop_head_1:
		ds_read_b32 v2, v1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s64, v2
		s_xor_b32 s65, s8, -1
		s_add_i32 s65, s65, 1
		s_add_i32 s64, s64, s65
		s_cmp_ge_u32 s64, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_1
.Lwmma_f16_matmul_tiled.loop_exit_1:
		s_mov_b64 exec, s[62:63]
		s_add_i32 s8, s12, 1
		s_mov_b32 s62, 2
		v_mov_b32_e32 v2, s13
		s_mov_b32 s64, 0x100000
		s_mov_b32 s65, 0
		v_mov_b32_e32 v8, s64
		v_mov_b32_e32 v9, s65
		v_mul_lo_u32 v76, v8, v2
		v_mul_hi_u32 v77, v8, v2
		v_mul_lo_u32 v1, v8, v3
		v_add_u32_e32 v77, v77, v1
		v_mul_lo_u32 v1, v9, v2
		v_add_u32_e32 v77, v77, v1
		v_mov_b32_e32 v78, v0
		v_mov_b32_e32 v79, 0
		v_mov_b32_e32 v80, s16
		v_mov_b32_e32 v81, s17
		v_mul_lo_u32 v82, v80, v78
		v_mul_hi_u32 v83, v80, v78
		v_mul_lo_u32 v1, v80, v79
		v_add_u32_e32 v83, v83, v1
		v_mul_lo_u32 v1, v81, v78
		v_add_u32_e32 v83, v83, v1
		v_lshrrev_b64 v[84:85], 6, v[82:83]
		s_mov_b32 s64, 0x10000
		s_mov_b32 s65, 0
		v_mov_b32_e32 v86, s64
		v_mov_b32_e32 v87, s65
		v_mul_lo_u32 v88, v86, v84
		v_mul_hi_u32 v89, v86, v84
		v_mul_lo_u32 v1, v86, v85
		v_add_u32_e32 v89, v89, v1
		v_mul_lo_u32 v1, v87, v84
		v_add_u32_e32 v89, v89, v1
		v_add_co_u32_e64 v90, vcc, v76, v88
		v_addc_co_u32_e64 v91, vcc, v77, v89, vcc
		v_mov_b32_e32 v1, 63
		v_and_b32_e32 v92, v78, v1
		v_and_b32_e32 v93, v3, v3
		v_mul_lo_u32 v78, v80, v92
		v_mul_hi_u32 v79, v80, v92
		v_mul_lo_u32 v1, v80, v93
		v_add_u32_e32 v79, v79, v1
		v_mul_lo_u32 v1, v81, v92
		v_add_u32_e32 v79, v79, v1
		v_lshrrev_b64 v[80:81], 2, v[78:79]
		s_mov_b32 s64, 0x1000
		s_mov_b32 s65, 0
		v_mov_b32_e32 v94, s64
		v_mov_b32_e32 v95, s65
		v_mul_lo_u32 v96, v94, v80
		v_mul_hi_u32 v97, v94, v80
		v_mul_lo_u32 v1, v94, v81
		v_add_u32_e32 v97, v97, v1
		v_mul_lo_u32 v1, v95, v80
		v_add_u32_e32 v97, v97, v1
		v_add_co_u32_e64 v80, vcc, v90, v96
		v_addc_co_u32_e64 v81, vcc, v91, v97, vcc
		v_lshrrev_b64 v[90:91], 3, v[78:79]
		v_mov_b32_e32 v1, 3
		v_and_b32_e32 v78, v90, v1
		v_and_b32_e32 v79, v91, v3
		v_and_b32_e32 v90, v92, v1
		v_and_b32_e32 v91, v93, v3
		v_xor_b32_e32 v78, v78, v90
		v_xor_b32_e32 v79, v79, v91
		s_mov_b32 s64, 16
		s_mov_b32 s65, 0
		v_mov_b32_e32 v90, s64
		v_mov_b32_e32 v91, s65
		v_mul_lo_u32 v94, v90, v78
		v_mul_hi_u32 v95, v90, v78
		v_mul_lo_u32 v1, v90, v79
		v_add_u32_e32 v95, v95, v1
		v_mul_lo_u32 v1, v91, v78
		v_add_u32_e32 v95, v95, v1
		v_add_co_u32_e64 v78, vcc, v80, v94
		v_addc_co_u32_e64 v79, vcc, v81, v95, vcc
		s_mov_b32 s64, 0x80
		s_mov_b32 s65, 0
		v_mov_b32_e32 v80, s64
		v_mov_b32_e32 v81, s65
		v_mov_b32_e32 v1, 0x40000
		v_add_co_u32_e64 v98, vcc, v76, v1
		v_addc_co_u32_e64 v99, vcc, v77, 0, vcc
		v_add_co_u32_e64 v100, vcc, v98, v88
		v_addc_co_u32_e64 v101, vcc, v99, v89, vcc
		v_add_co_u32_e64 v98, vcc, v100, v96
		v_addc_co_u32_e64 v99, vcc, v101, v97, vcc
		v_add_co_u32_e64 v100, vcc, v98, v94
		v_addc_co_u32_e64 v101, vcc, v99, v95, vcc
		v_mov_b32_e32 v2, 0x80000
		v_add_co_u32_e64 v98, vcc, v76, v2
		v_addc_co_u32_e64 v99, vcc, v77, 0, vcc
		v_add_co_u32_e64 v102, vcc, v98, v88
		v_addc_co_u32_e64 v103, vcc, v99, v89, vcc
		v_add_co_u32_e64 v98, vcc, v102, v96
		v_addc_co_u32_e64 v99, vcc, v103, v97, vcc
		v_add_co_u32_e64 v102, vcc, v98, v94
		v_addc_co_u32_e64 v103, vcc, v99, v95, vcc
		v_mov_b32_e32 v4, 0xc0000
		v_add_co_u32_e64 v98, vcc, v76, v4
		v_addc_co_u32_e64 v99, vcc, v77, 0, vcc
		v_add_co_u32_e64 v104, vcc, v98, v88
		v_addc_co_u32_e64 v105, vcc, v99, v89, vcc
		v_add_co_u32_e64 v98, vcc, v104, v96
		v_addc_co_u32_e64 v99, vcc, v105, v97, vcc
		v_add_co_u32_e64 v104, vcc, v98, v94
		v_addc_co_u32_e64 v105, vcc, v99, v95, vcc
		v_mov_b32_e32 v7, 64
		v_add_co_u32_e64 v98, vcc, v76, v7
		v_addc_co_u32_e64 v99, vcc, v77, 0, vcc
		v_add_co_u32_e64 v106, vcc, v98, v88
		v_addc_co_u32_e64 v107, vcc, v99, v89, vcc
		v_add_co_u32_e64 v98, vcc, v106, v96
		v_addc_co_u32_e64 v99, vcc, v107, v97, vcc
		v_add_co_u32_e64 v106, vcc, v98, v94
		v_addc_co_u32_e64 v107, vcc, v99, v95, vcc
		v_mov_b32_e32 v10, 0x40040
		v_add_co_u32_e64 v98, vcc, v76, v10
		v_addc_co_u32_e64 v99, vcc, v77, 0, vcc
		v_add_co_u32_e64 v108, vcc, v98, v88
		v_addc_co_u32_e64 v109, vcc, v99, v89, vcc
		v_add_co_u32_e64 v98, vcc, v108, v96
		v_addc_co_u32_e64 v99, vcc, v109, v97, vcc
		v_add_co_u32_e64 v108, vcc, v98, v94
		v_addc_co_u32_e64 v109, vcc, v99, v95, vcc
		v_mov_b32_e32 v12, 0x80040
		v_add_co_u32_e64 v98, vcc, v76, v12
		v_addc_co_u32_e64 v99, vcc, v77, 0, vcc
		v_add_co_u32_e64 v110, vcc, v98, v88
		v_addc_co_u32_e64 v111, vcc, v99, v89, vcc
		v_add_co_u32_e64 v98, vcc, v110, v96
		v_addc_co_u32_e64 v99, vcc, v111, v97, vcc
		v_add_co_u32_e64 v110, vcc, v98, v94
		v_addc_co_u32_e64 v111, vcc, v99, v95, vcc
		v_mov_b32_e32 v75, 0xc0040
		v_add_co_u32_e64 v98, vcc, v76, v75
		v_addc_co_u32_e64 v99, vcc, v77, 0, vcc
		v_add_co_u32_e64 v112, vcc, v98, v88
		v_addc_co_u32_e64 v113, vcc, v99, v89, vcc
		v_add_co_u32_e64 v98, vcc, v112, v96
		v_addc_co_u32_e64 v99, vcc, v113, v97, vcc
		v_add_co_u32_e64 v112, vcc, v98, v94
		v_addc_co_u32_e64 v113, vcc, v99, v95, vcc
		v_mov_b32_e32 v98, s14
		v_mov_b32_e32 v99, 0
		v_mul_lo_u32 v114, v8, v98
		v_mul_hi_u32 v115, v8, v98
		v_mul_lo_u32 v116, v8, v99
		v_add_u32_e32 v115, v115, v116
		v_mul_lo_u32 v116, v9, v98
		v_add_u32_e32 v115, v115, v116
		v_add_co_u32_e64 v8, vcc, v114, v88
		v_addc_co_u32_e64 v9, vcc, v115, v89, vcc
		v_add_co_u32_e64 v116, vcc, v8, v96
		v_addc_co_u32_e64 v117, vcc, v9, v97, vcc
		v_add_co_u32_e64 v8, vcc, v116, v94
		v_addc_co_u32_e64 v9, vcc, v117, v95, vcc
		v_add_co_u32_e64 v116, vcc, v114, v1
		v_addc_co_u32_e64 v117, vcc, v115, 0, vcc
		v_add_co_u32_e64 v118, vcc, v116, v88
		v_addc_co_u32_e64 v119, vcc, v117, v89, vcc
		v_add_co_u32_e64 v116, vcc, v118, v96
		v_addc_co_u32_e64 v117, vcc, v119, v97, vcc
		v_add_co_u32_e64 v118, vcc, v116, v94
		v_addc_co_u32_e64 v119, vcc, v117, v95, vcc
		v_add_co_u32_e64 v116, vcc, v114, v2
		v_addc_co_u32_e64 v117, vcc, v115, 0, vcc
		v_add_co_u32_e64 v120, vcc, v116, v88
		v_addc_co_u32_e64 v121, vcc, v117, v89, vcc
		v_add_co_u32_e64 v116, vcc, v120, v96
		v_addc_co_u32_e64 v117, vcc, v121, v97, vcc
		v_add_co_u32_e64 v120, vcc, v116, v94
		v_addc_co_u32_e64 v121, vcc, v117, v95, vcc
		v_add_co_u32_e64 v116, vcc, v114, v4
		v_addc_co_u32_e64 v117, vcc, v115, 0, vcc
		v_add_co_u32_e64 v122, vcc, v116, v88
		v_addc_co_u32_e64 v123, vcc, v117, v89, vcc
		v_add_co_u32_e64 v116, vcc, v122, v96
		v_addc_co_u32_e64 v117, vcc, v123, v97, vcc
		v_add_co_u32_e64 v122, vcc, v116, v94
		v_addc_co_u32_e64 v123, vcc, v117, v95, vcc
		v_add_co_u32_e64 v116, vcc, v114, v7
		v_addc_co_u32_e64 v117, vcc, v115, 0, vcc
		v_add_co_u32_e64 v124, vcc, v116, v88
		v_addc_co_u32_e64 v125, vcc, v117, v89, vcc
		v_add_co_u32_e64 v116, vcc, v124, v96
		v_addc_co_u32_e64 v117, vcc, v125, v97, vcc
		v_add_co_u32_e64 v124, vcc, v116, v94
		v_addc_co_u32_e64 v125, vcc, v117, v95, vcc
		v_add_co_u32_e64 v116, vcc, v114, v10
		v_addc_co_u32_e64 v117, vcc, v115, 0, vcc
		v_add_co_u32_e64 v126, vcc, v116, v88
		v_addc_co_u32_e64 v127, vcc, v117, v89, vcc
		v_add_co_u32_e64 v116, vcc, v126, v96
		v_addc_co_u32_e64 v117, vcc, v127, v97, vcc
		v_add_co_u32_e64 v126, vcc, v116, v94
		v_addc_co_u32_e64 v127, vcc, v117, v95, vcc
		v_add_co_u32_e64 v116, vcc, v114, v12
		v_addc_co_u32_e64 v117, vcc, v115, 0, vcc
		v_add_co_u32_e64 v128, vcc, v116, v88
		v_addc_co_u32_e64 v129, vcc, v117, v89, vcc
		v_add_co_u32_e64 v116, vcc, v128, v96
		v_addc_co_u32_e64 v117, vcc, v129, v97, vcc
		v_add_co_u32_e64 v128, vcc, v116, v94
		v_addc_co_u32_e64 v129, vcc, v117, v95, vcc
		v_add_co_u32_e64 v116, vcc, v114, v75
		v_addc_co_u32_e64 v117, vcc, v115, 0, vcc
		v_add_co_u32_e64 v130, vcc, v116, v88
		v_addc_co_u32_e64 v131, vcc, v117, v89, vcc
		v_add_co_u32_e64 v116, vcc, v130, v96
		v_addc_co_u32_e64 v117, vcc, v131, v97, vcc
		v_add_co_u32_e64 v130, vcc, v116, v94
		v_addc_co_u32_e64 v131, vcc, v117, v95, vcc
		v_mul_lo_u32 v116, v86, v98
		v_mul_hi_u32 v117, v86, v98
		v_mul_lo_u32 v1, v86, v99
		v_add_u32_e32 v117, v117, v1
		v_mul_lo_u32 v1, v87, v98
		v_add_u32_e32 v117, v117, v1
		v_add_co_u32_e64 v86, vcc, v76, v116
		v_addc_co_u32_e64 v87, vcc, v77, v117, vcc
		v_lshrrev_b64 v[98:99], 7, v[82:83]
		s_mov_b32 s64, 0x400
		s_mov_b32 s65, 0
		v_mov_b32_e32 v82, s64
		v_mov_b32_e32 v83, s65
		v_mul_lo_u32 v132, v82, v98
		v_mul_hi_u32 v133, v82, v98
		v_mul_lo_u32 v1, v82, v99
		v_add_u32_e32 v133, v133, v1
		v_mul_lo_u32 v1, v83, v98
		v_add_u32_e32 v133, v133, v1
		v_add_co_u32_e64 v98, vcc, v86, v132
		v_addc_co_u32_e64 v99, vcc, v87, v133, vcc
		v_mul_lo_u32 v134, v90, v92
		v_mul_hi_u32 v135, v90, v92
		v_mul_lo_u32 v1, v90, v93
		v_add_u32_e32 v135, v135, v1
		v_mul_lo_u32 v1, v91, v92
		v_add_u32_e32 v135, v135, v1
		v_add_co_u32_e64 v90, vcc, v98, v134
		v_addc_co_u32_e64 v91, vcc, v99, v135, vcc
		s_mov_b32 s64, 0x800
		s_mov_b32 s65, 0
		v_mov_b32_e32 v92, s64
		v_mov_b32_e32 v93, s65
		v_add_co_u32_e64 v98, vcc, v86, v134
		v_addc_co_u32_e64 v99, vcc, v87, v135, vcc
		v_and_b32_e32 v86, v84, v11
		v_and_b32_e32 v87, v85, v3
		v_mul_lo_u32 v2, v82, v86
		v_mul_hi_u32 v3, v82, v86
		v_mul_lo_u32 v1, v82, v87
		v_add_u32_e32 v3, v3, v1
		v_mul_lo_u32 v1, v83, v86
		v_add_u32_e32 v3, v3, v1
		v_add_co_u32_e64 v10, vcc, v98, v2
		v_addc_co_u32_e64 v11, vcc, v99, v3, vcc
		v_mov_b32_e32 v1, 0x80
		v_add_co_u32_e64 v82, vcc, v76, v1
		v_addc_co_u32_e64 v83, vcc, v77, 0, vcc
		v_add_co_u32_e64 v84, vcc, v82, v88
		v_addc_co_u32_e64 v85, vcc, v83, v89, vcc
		v_add_co_u32_e64 v82, vcc, v84, v96
		v_addc_co_u32_e64 v83, vcc, v85, v97, vcc
		v_add_co_u32_e64 v84, vcc, v82, v94
		v_addc_co_u32_e64 v85, vcc, v83, v95, vcc
		s_mov_b32 s63, 0
		scratch_store_dword off, v84, s63 offset:4
		scratch_store_dword off, v85, s63 offset:8
		v_mov_b32_e32 v4, 0x40080
		v_add_co_u32_e64 v82, vcc, v76, v4
		v_addc_co_u32_e64 v83, vcc, v77, 0, vcc
		v_add_co_u32_e64 v84, vcc, v82, v88
		v_addc_co_u32_e64 v85, vcc, v83, v89, vcc
		v_add_co_u32_e64 v82, vcc, v84, v96
		v_addc_co_u32_e64 v83, vcc, v85, v97, vcc
		v_add_co_u32_e64 v84, vcc, v82, v94
		v_addc_co_u32_e64 v85, vcc, v83, v95, vcc
		s_mov_b32 s63, 0
		scratch_store_dword off, v84, s63 offset:12
		scratch_store_dword off, v85, s63 offset:16
		v_mov_b32_e32 v7, 0x80080
		v_add_co_u32_e64 v82, vcc, v76, v7
		v_addc_co_u32_e64 v83, vcc, v77, 0, vcc
		v_add_co_u32_e64 v84, vcc, v82, v88
		v_addc_co_u32_e64 v85, vcc, v83, v89, vcc
		v_add_co_u32_e64 v82, vcc, v84, v96
		v_addc_co_u32_e64 v83, vcc, v85, v97, vcc
		v_add_co_u32_e64 v84, vcc, v82, v94
		v_addc_co_u32_e64 v85, vcc, v83, v95, vcc
		s_mov_b32 s63, 0
		scratch_store_dword off, v84, s63 offset:20
		scratch_store_dword off, v85, s63 offset:24
		v_mov_b32_e32 v12, 0xc0080
		v_add_co_u32_e64 v82, vcc, v76, v12
		v_addc_co_u32_e64 v83, vcc, v77, 0, vcc
		v_add_co_u32_e64 v84, vcc, v82, v88
		v_addc_co_u32_e64 v85, vcc, v83, v89, vcc
		v_add_co_u32_e64 v82, vcc, v84, v96
		v_addc_co_u32_e64 v83, vcc, v85, v97, vcc
		v_add_co_u32_e64 v84, vcc, v82, v94
		v_addc_co_u32_e64 v85, vcc, v83, v95, vcc
		s_mov_b32 s63, 0
		scratch_store_dword off, v84, s63 offset:28
		scratch_store_dword off, v85, s63 offset:32
		v_mov_b32_e32 v75, 0xc0
		v_add_co_u32_e64 v82, vcc, v76, v75
		v_addc_co_u32_e64 v83, vcc, v77, 0, vcc
		v_add_co_u32_e64 v84, vcc, v82, v88
		v_addc_co_u32_e64 v85, vcc, v83, v89, vcc
		v_add_co_u32_e64 v82, vcc, v84, v96
		v_addc_co_u32_e64 v83, vcc, v85, v97, vcc
		v_add_co_u32_e64 v84, vcc, v82, v94
		v_addc_co_u32_e64 v85, vcc, v83, v95, vcc
		s_mov_b32 s63, 0
		scratch_store_dword off, v84, s63 offset:36
		scratch_store_dword off, v85, s63 offset:40
		v_mov_b32_e32 v82, 0x400c0
		v_add_co_u32_e64 v84, vcc, v76, v82
		v_addc_co_u32_e64 v85, vcc, v77, 0, vcc
		v_add_co_u32_e64 v86, vcc, v84, v88
		v_addc_co_u32_e64 v87, vcc, v85, v89, vcc
		v_add_co_u32_e64 v84, vcc, v86, v96
		v_addc_co_u32_e64 v85, vcc, v87, v97, vcc
		v_add_co_u32_e64 v86, vcc, v84, v94
		v_addc_co_u32_e64 v87, vcc, v85, v95, vcc
		s_mov_b32 s63, 0
		scratch_store_dword off, v86, s63 offset:44
		scratch_store_dword off, v87, s63 offset:48
		v_mov_b32_e32 v83, 0x800c0
		v_add_co_u32_e64 v84, vcc, v76, v83
		v_addc_co_u32_e64 v85, vcc, v77, 0, vcc
		v_add_co_u32_e64 v86, vcc, v84, v88
		v_addc_co_u32_e64 v87, vcc, v85, v89, vcc
		v_add_co_u32_e64 v84, vcc, v86, v96
		v_addc_co_u32_e64 v85, vcc, v87, v97, vcc
		v_add_co_u32_e64 v86, vcc, v84, v94
		v_addc_co_u32_e64 v87, vcc, v85, v95, vcc
		s_mov_b32 s63, 0
		scratch_store_dword off, v86, s63 offset:52
		scratch_store_dword off, v87, s63 offset:56
		v_mov_b32_e32 v84, 0xc00c0
		v_add_co_u32_e64 v86, vcc, v76, v84
		v_addc_co_u32_e64 v87, vcc, v77, 0, vcc
		v_add_co_u32_e64 v98, vcc, v86, v88
		v_addc_co_u32_e64 v99, vcc, v87, v89, vcc
		v_add_co_u32_e64 v86, vcc, v98, v96
		v_addc_co_u32_e64 v87, vcc, v99, v97, vcc
		v_add_co_u32_e64 v98, vcc, v86, v94
		v_addc_co_u32_e64 v99, vcc, v87, v95, vcc
		s_mov_b32 s63, 0
		scratch_store_dword off, v98, s63 offset:60
		scratch_store_dword off, v99, s63 offset:64
		v_add_co_u32_e64 v86, vcc, v114, v1
		v_addc_co_u32_e64 v87, vcc, v115, 0, vcc
		v_add_co_u32_e64 v98, vcc, v86, v88
		v_addc_co_u32_e64 v99, vcc, v87, v89, vcc
		v_add_co_u32_e64 v86, vcc, v98, v96
		v_addc_co_u32_e64 v87, vcc, v99, v97, vcc
		v_add_co_u32_e64 v98, vcc, v86, v94
		v_addc_co_u32_e64 v99, vcc, v87, v95, vcc
		s_mov_b32 s63, 0
		scratch_store_dword off, v98, s63 offset:68
		scratch_store_dword off, v99, s63 offset:72
		v_add_co_u32_e64 v86, vcc, v114, v4
		v_addc_co_u32_e64 v87, vcc, v115, 0, vcc
		v_add_co_u32_e64 v98, vcc, v86, v88
		v_addc_co_u32_e64 v99, vcc, v87, v89, vcc
		v_add_co_u32_e64 v86, vcc, v98, v96
		v_addc_co_u32_e64 v87, vcc, v99, v97, vcc
		v_add_co_u32_e64 v98, vcc, v86, v94
		v_addc_co_u32_e64 v99, vcc, v87, v95, vcc
		s_mov_b32 s63, 0
		scratch_store_dword off, v98, s63 offset:76
		scratch_store_dword off, v99, s63 offset:80
		v_add_co_u32_e64 v86, vcc, v114, v7
		v_addc_co_u32_e64 v87, vcc, v115, 0, vcc
		v_add_co_u32_e64 v98, vcc, v86, v88
		v_addc_co_u32_e64 v99, vcc, v87, v89, vcc
		v_add_co_u32_e64 v86, vcc, v98, v96
		v_addc_co_u32_e64 v87, vcc, v99, v97, vcc
		v_add_co_u32_e64 v98, vcc, v86, v94
		v_addc_co_u32_e64 v99, vcc, v87, v95, vcc
		s_mov_b32 s63, 0
		scratch_store_dword off, v98, s63 offset:84
		scratch_store_dword off, v99, s63 offset:88
		v_add_co_u32_e64 v86, vcc, v114, v12
		v_addc_co_u32_e64 v87, vcc, v115, 0, vcc
		v_add_co_u32_e64 v98, vcc, v86, v88
		v_addc_co_u32_e64 v99, vcc, v87, v89, vcc
		v_add_co_u32_e64 v86, vcc, v98, v96
		v_addc_co_u32_e64 v87, vcc, v99, v97, vcc
		v_add_co_u32_e64 v98, vcc, v86, v94
		v_addc_co_u32_e64 v99, vcc, v87, v95, vcc
		s_mov_b32 s63, 0
		scratch_store_dword off, v98, s63 offset:92
		scratch_store_dword off, v99, s63 offset:96
		v_add_co_u32_e64 v86, vcc, v114, v75
		v_addc_co_u32_e64 v87, vcc, v115, 0, vcc
		v_add_co_u32_e64 v98, vcc, v86, v88
		v_addc_co_u32_e64 v99, vcc, v87, v89, vcc
		v_add_co_u32_e64 v86, vcc, v98, v96
		v_addc_co_u32_e64 v87, vcc, v99, v97, vcc
		v_add_co_u32_e64 v98, vcc, v86, v94
		v_addc_co_u32_e64 v99, vcc, v87, v95, vcc
		s_mov_b32 s63, 0
		scratch_store_dword off, v98, s63 offset:100
		scratch_store_dword off, v99, s63 offset:104
		v_add_co_u32_e64 v86, vcc, v114, v82
		v_addc_co_u32_e64 v87, vcc, v115, 0, vcc
		v_add_co_u32_e64 v98, vcc, v86, v88
		v_addc_co_u32_e64 v99, vcc, v87, v89, vcc
		v_add_co_u32_e64 v86, vcc, v98, v96
		v_addc_co_u32_e64 v87, vcc, v99, v97, vcc
		v_add_co_u32_e64 v98, vcc, v86, v94
		v_addc_co_u32_e64 v99, vcc, v87, v95, vcc
		s_mov_b32 s63, 0
		scratch_store_dword off, v98, s63 offset:108
		scratch_store_dword off, v99, s63 offset:112
		v_add_co_u32_e64 v86, vcc, v114, v83
		v_addc_co_u32_e64 v87, vcc, v115, 0, vcc
		v_add_co_u32_e64 v82, vcc, v86, v88
		v_addc_co_u32_e64 v83, vcc, v87, v89, vcc
		v_add_co_u32_e64 v86, vcc, v82, v96
		v_addc_co_u32_e64 v87, vcc, v83, v97, vcc
		v_add_co_u32_e64 v82, vcc, v86, v94
		v_addc_co_u32_e64 v83, vcc, v87, v95, vcc
		v_add_co_u32_e64 v86, vcc, v114, v84
		v_addc_co_u32_e64 v87, vcc, v115, 0, vcc
		v_add_co_u32_e64 v84, vcc, v86, v88
		v_addc_co_u32_e64 v85, vcc, v87, v89, vcc
		v_add_co_u32_e64 v86, vcc, v84, v96
		v_addc_co_u32_e64 v87, vcc, v85, v97, vcc
		v_add_co_u32_e64 v84, vcc, v86, v94
		v_addc_co_u32_e64 v85, vcc, v87, v95, vcc
		v_mov_b32_e32 v1, 0x800
		v_add_co_u32_e64 v86, vcc, v76, v1
		v_addc_co_u32_e64 v87, vcc, v77, 0, vcc
		v_add_co_u32_e64 v76, vcc, v86, v116
		v_addc_co_u32_e64 v77, vcc, v87, v117, vcc
		v_add_co_u32_e64 v86, vcc, v76, v132
		v_addc_co_u32_e64 v87, vcc, v77, v133, vcc
		v_add_co_u32_e64 v88, vcc, v86, v134
		v_addc_co_u32_e64 v89, vcc, v87, v135, vcc
		v_add_co_u32_e64 v86, vcc, v76, v134
		v_addc_co_u32_e64 v87, vcc, v77, v135, vcc
		v_add_co_u32_e64 v76, vcc, v86, v2
		v_addc_co_u32_e64 v77, vcc, v87, v3, vcc
		v_mov_b32_e32 v2, s62
		v_mov_b32_e32 v3, 0
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
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
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a20, 0
		v_accvgpr_write_b32 a21, 0
		v_accvgpr_write_b32 a22, 0
		v_accvgpr_write_b32 a23, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a24, 0
		v_accvgpr_write_b32 a25, 0
		v_accvgpr_write_b32 a26, 0
		v_accvgpr_write_b32 a27, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a28, 0
		v_accvgpr_write_b32 a29, 0
		v_accvgpr_write_b32 a30, 0
		v_accvgpr_write_b32 a31, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a32, 0
		v_accvgpr_write_b32 a33, 0
		v_accvgpr_write_b32 a34, 0
		v_accvgpr_write_b32 a35, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a36, 0
		v_accvgpr_write_b32 a37, 0
		v_accvgpr_write_b32 a38, 0
		v_accvgpr_write_b32 a39, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a40, 0
		v_accvgpr_write_b32 a41, 0
		v_accvgpr_write_b32 a42, 0
		v_accvgpr_write_b32 a43, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a44, 0
		v_accvgpr_write_b32 a45, 0
		v_accvgpr_write_b32 a46, 0
		v_accvgpr_write_b32 a47, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a48, 0
		v_accvgpr_write_b32 a49, 0
		v_accvgpr_write_b32 a50, 0
		v_accvgpr_write_b32 a51, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a52, 0
		v_accvgpr_write_b32 a53, 0
		v_accvgpr_write_b32 a54, 0
		v_accvgpr_write_b32 a55, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a56, 0
		v_accvgpr_write_b32 a57, 0
		v_accvgpr_write_b32 a58, 0
		v_accvgpr_write_b32 a59, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a60, 0
		v_accvgpr_write_b32 a61, 0
		v_accvgpr_write_b32 a62, 0
		v_accvgpr_write_b32 a63, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a64, 0
		v_accvgpr_write_b32 a65, 0
		v_accvgpr_write_b32 a66, 0
		v_accvgpr_write_b32 a67, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a68, 0
		v_accvgpr_write_b32 a69, 0
		v_accvgpr_write_b32 a70, 0
		v_accvgpr_write_b32 a71, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a72, 0
		v_accvgpr_write_b32 a73, 0
		v_accvgpr_write_b32 a74, 0
		v_accvgpr_write_b32 a75, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a76, 0
		v_accvgpr_write_b32 a77, 0
		v_accvgpr_write_b32 a78, 0
		v_accvgpr_write_b32 a79, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a80, 0
		v_accvgpr_write_b32 a81, 0
		v_accvgpr_write_b32 a82, 0
		v_accvgpr_write_b32 a83, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a84, 0
		v_accvgpr_write_b32 a85, 0
		v_accvgpr_write_b32 a86, 0
		v_accvgpr_write_b32 a87, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a88, 0
		v_accvgpr_write_b32 a89, 0
		v_accvgpr_write_b32 a90, 0
		v_accvgpr_write_b32 a91, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a92, 0
		v_accvgpr_write_b32 a93, 0
		v_accvgpr_write_b32 a94, 0
		v_accvgpr_write_b32 a95, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a96, 0
		v_accvgpr_write_b32 a97, 0
		v_accvgpr_write_b32 a98, 0
		v_accvgpr_write_b32 a99, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a100, 0
		v_accvgpr_write_b32 a101, 0
		v_accvgpr_write_b32 a102, 0
		v_accvgpr_write_b32 a103, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a104, 0
		v_accvgpr_write_b32 a105, 0
		v_accvgpr_write_b32 a106, 0
		v_accvgpr_write_b32 a107, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a108, 0
		v_accvgpr_write_b32 a109, 0
		v_accvgpr_write_b32 a110, 0
		v_accvgpr_write_b32 a111, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a112, 0
		v_accvgpr_write_b32 a113, 0
		v_accvgpr_write_b32 a114, 0
		v_accvgpr_write_b32 a115, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a116, 0
		v_accvgpr_write_b32 a117, 0
		v_accvgpr_write_b32 a118, 0
		v_accvgpr_write_b32 a119, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a120, 0
		v_accvgpr_write_b32 a121, 0
		v_accvgpr_write_b32 a122, 0
		v_accvgpr_write_b32 a123, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a124, 0
		v_accvgpr_write_b32 a125, 0
		v_accvgpr_write_b32 a126, 0
		v_accvgpr_write_b32 a127, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a128, 0
		v_accvgpr_write_b32 a129, 0
		v_accvgpr_write_b32 a130, 0
		v_accvgpr_write_b32 a131, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a132, 0
		v_accvgpr_write_b32 a133, 0
		v_accvgpr_write_b32 a134, 0
		v_accvgpr_write_b32 a135, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a136, 0
		v_accvgpr_write_b32 a137, 0
		v_accvgpr_write_b32 a138, 0
		v_accvgpr_write_b32 a139, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a140, 0
		v_accvgpr_write_b32 a141, 0
		v_accvgpr_write_b32 a142, 0
		v_accvgpr_write_b32 a143, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a144, 0
		v_accvgpr_write_b32 a145, 0
		v_accvgpr_write_b32 a146, 0
		v_accvgpr_write_b32 a147, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a148, 0
		v_accvgpr_write_b32 a149, 0
		v_accvgpr_write_b32 a150, 0
		v_accvgpr_write_b32 a151, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a152, 0
		v_accvgpr_write_b32 a153, 0
		v_accvgpr_write_b32 a154, 0
		v_accvgpr_write_b32 a155, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a156, 0
		v_accvgpr_write_b32 a157, 0
		v_accvgpr_write_b32 a158, 0
		v_accvgpr_write_b32 a159, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a160, 0
		v_accvgpr_write_b32 a161, 0
		v_accvgpr_write_b32 a162, 0
		v_accvgpr_write_b32 a163, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a164, 0
		v_accvgpr_write_b32 a165, 0
		v_accvgpr_write_b32 a166, 0
		v_accvgpr_write_b32 a167, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a168, 0
		v_accvgpr_write_b32 a169, 0
		v_accvgpr_write_b32 a170, 0
		v_accvgpr_write_b32 a171, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a172, 0
		v_accvgpr_write_b32 a173, 0
		v_accvgpr_write_b32 a174, 0
		v_accvgpr_write_b32 a175, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a176, 0
		v_accvgpr_write_b32 a177, 0
		v_accvgpr_write_b32 a178, 0
		v_accvgpr_write_b32 a179, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a180, 0
		v_accvgpr_write_b32 a181, 0
		v_accvgpr_write_b32 a182, 0
		v_accvgpr_write_b32 a183, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a184, 0
		v_accvgpr_write_b32 a185, 0
		v_accvgpr_write_b32 a186, 0
		v_accvgpr_write_b32 a187, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a188, 0
		v_accvgpr_write_b32 a189, 0
		v_accvgpr_write_b32 a190, 0
		v_accvgpr_write_b32 a191, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a192, 0
		v_accvgpr_write_b32 a193, 0
		v_accvgpr_write_b32 a194, 0
		v_accvgpr_write_b32 a195, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a196, 0
		v_accvgpr_write_b32 a197, 0
		v_accvgpr_write_b32 a198, 0
		v_accvgpr_write_b32 a199, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a200, 0
		v_accvgpr_write_b32 a201, 0
		v_accvgpr_write_b32 a202, 0
		v_accvgpr_write_b32 a203, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a204, 0
		v_accvgpr_write_b32 a205, 0
		v_accvgpr_write_b32 a206, 0
		v_accvgpr_write_b32 a207, 0
		v_mov_b64_e32 v[184:185], 0
		v_mov_b64_e32 v[186:187], 0
		v_accvgpr_write_b32 a208, 0
		v_accvgpr_write_b32 a209, 0
		v_accvgpr_write_b32 a210, 0
		v_accvgpr_write_b32 a211, 0
.Lwmma_f16_matmul_tiled.loop_head_2:
		v_mov_b32_e32 v2, s62
		v_mul_lo_u32 v86, v80, v2
		v_mul_hi_u32 v87, v80, v2
		v_mul_lo_u32 v1, v80, v3
		v_add_u32_e32 v87, v87, v1
		v_mul_lo_u32 v1, v81, v2
		v_add_u32_e32 v87, v87, v1
		v_add_co_u32_e64 v94, vcc, v78, v86
		v_addc_co_u32_e64 v95, vcc, v79, v87, vcc
		v_add_co_u32_e64 v114, vcc, v100, v86
		v_addc_co_u32_e64 v115, vcc, v101, v87, vcc
		v_add_co_u32_e64 v116, vcc, v102, v86
		v_addc_co_u32_e64 v117, vcc, v103, v87, vcc
		v_add_co_u32_e64 v184, vcc, v104, v86
		v_addc_co_u32_e64 v185, vcc, v105, v87, vcc
		v_add_co_u32_e64 v186, vcc, v106, v86
		v_addc_co_u32_e64 v187, vcc, v107, v87, vcc
		v_add_co_u32_e64 v188, vcc, v108, v86
		v_addc_co_u32_e64 v189, vcc, v109, v87, vcc
		v_add_co_u32_e64 v190, vcc, v110, v86
		v_addc_co_u32_e64 v191, vcc, v111, v87, vcc
		v_add_co_u32_e64 v192, vcc, v112, v86
		v_addc_co_u32_e64 v193, vcc, v113, v87, vcc
		v_add_co_u32_e64 v194, vcc, v8, v86
		v_addc_co_u32_e64 v195, vcc, v9, v87, vcc
		v_add_co_u32_e64 v196, vcc, v118, v86
		v_addc_co_u32_e64 v197, vcc, v119, v87, vcc
		v_add_co_u32_e64 v198, vcc, v120, v86
		v_addc_co_u32_e64 v199, vcc, v121, v87, vcc
		v_add_co_u32_e64 v200, vcc, v122, v86
		v_addc_co_u32_e64 v201, vcc, v123, v87, vcc
		v_add_co_u32_e64 v202, vcc, v124, v86
		v_addc_co_u32_e64 v203, vcc, v125, v87, vcc
		v_add_co_u32_e64 v204, vcc, v126, v86
		v_addc_co_u32_e64 v205, vcc, v127, v87, vcc
		v_add_co_u32_e64 v206, vcc, v128, v86
		v_addc_co_u32_e64 v207, vcc, v129, v87, vcc
		v_add_co_u32_e64 v208, vcc, v130, v86
		v_addc_co_u32_e64 v209, vcc, v131, v87, vcc
		v_mul_lo_u32 v210, v92, v2
		v_mul_hi_u32 v211, v92, v2
		v_mul_lo_u32 v1, v92, v3
		v_add_u32_e32 v211, v211, v1
		v_mul_lo_u32 v1, v93, v2
		v_add_u32_e32 v211, v211, v1
		v_add_co_u32_e64 v212, vcc, v90, v210
		v_addc_co_u32_e64 v213, vcc, v91, v211, vcc
		v_add_co_u32_e64 v214, vcc, v10, v210
		v_addc_co_u32_e64 v215, vcc, v11, v211, vcc
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], a[0:3], v[36:39], v[16:19], v68, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s63, s62, 1
		s_lshl_b32 s64, s63, 16
		v_add_u32_e32 v1, s64, v5
		v_add3_u32 v1, v1, v14, v13
		v_add_u32_e32 v1, 16, v1
		ds_read_b128 a[212:215], v1 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[0:3], v[40:43], v[96:99], v68, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[216:219], v1 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[0:3], v[44:47], v[132:135], v68, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[220:223], v1 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[0:3], v[48:51], v[136:139], v68, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[224:227], v1 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[0:3], v[52:55], v[140:143], v68, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[228:231], v1 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[0:3], v[56:59], v[144:147], v68, v73 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[232:235], v1 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[0:3], v[60:63], v[148:151], v68, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[236:239], v1 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[0:3], v[64:67], v[152:155], v68, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[240:243], v1 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[4:7], v[36:39], v[156:159], v68, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, s64, v14
		v_add3_u32 v1, v1, v15, v13
		v_add_u32_e32 v1, 16, v1
		ds_read_b128 a[244:247], v1 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[4:7], v[40:43], v[160:163], v68, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[248:251], v1 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[4:7], v[44:47], v[164:167], v68, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[252:255], v1 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[4:7], v[48:51], v[168:171], v68, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v1 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[4:7], v[52:55], v[172:175], v68, v73 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v1 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[4:7], v[56:59], v[176:179], v68, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s64, s62, 1
		s_lshl_b32 s64, s64, 16
		v_and_b32_e32 v1, 15, v0
		v_lshlrev_b32_e32 v4, 6, v1
		v_add_u32_e32 v4, s64, v4
		v_lshrrev_b32_e32 v7, 6, v0
		v_and_b32_e32 v7, 1, v7
		v_lshlrev_b32_e32 v7, 13, v7
		v_and_b32_e32 v12, 63, v0
		v_lshrrev_b32_e32 v12, 4, v12
		v_lshrrev_b32_e32 v1, 1, v1
		v_and_b32_e32 v1, 3, v1
		v_xor_b32_e32 v1, v12, v1
		v_lshlrev_b32_e32 v1, 4, v1
		v_add3_u32 v1, v4, v7, v1
		v_add_u32_e32 v1, 16, v1
		ds_read_b128 v[224:227], v1 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[4:7], v[60:63], v[180:183], v68, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v1 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[4:7], v[64:67], a[16:19], v68, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[232:235], v1 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[8:11], v[36:39], a[20:23], v69, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s42, 16
		s_nop 0
		buffer_load_dwordx4 v94, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[8:11], v[40:43], a[24:27], v69, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s11, 16
		s_nop 0
		buffer_load_dwordx4 v114, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[8:11], v[44:47], a[28:31], v69, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s18, 16
		s_nop 0
		buffer_load_dwordx4 v116, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[8:11], v[48:51], a[32:35], v69, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s48, 16
		s_nop 0
		buffer_load_dwordx4 v184, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[8:11], v[52:55], a[36:39], v69, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s49, 16
		s_nop 0
		buffer_load_dwordx4 v186, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[8:11], v[56:59], a[40:43], v69, v73 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s50, 16
		s_nop 0
		buffer_load_dwordx4 v188, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[8:11], v[60:63], a[44:47], v69, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s51, 16
		s_nop 0
		buffer_load_dwordx4 v190, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[8:11], v[64:67], a[48:51], v69, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s52, 16
		s_nop 0
		buffer_load_dwordx4 v192, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[12:15], v[36:39], a[52:55], v69, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s53, 16
		s_nop 0
		buffer_load_dwordx4 v194, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[12:15], v[40:43], a[56:59], v69, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s54, 16
		s_nop 0
		buffer_load_dwordx4 v196, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[12:15], v[44:47], a[60:63], v69, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s55, 16
		s_nop 0
		buffer_load_dwordx4 v198, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[12:15], v[48:51], a[64:67], v69, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s56, 16
		s_nop 0
		buffer_load_dwordx4 v200, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[12:15], v[52:55], a[68:71], v69, v73 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s57, 16
		s_nop 0
		buffer_load_dwordx4 v202, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[12:15], v[56:59], a[72:75], v69, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s58, 16
		s_nop 0
		buffer_load_dwordx4 v204, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[12:15], v[60:63], a[76:79], v69, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s59, 16
		s_nop 0
		buffer_load_dwordx4 v206, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[12:15], v[64:67], a[80:83], v69, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s60, 16
		s_nop 0
		buffer_load_dwordx4 v208, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[20:23], v[36:39], a[84:87], v70, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s64, s62, 1
		s_add_i32 m0, s15, 0x20010
		s_nop 0
		buffer_load_dwordx4 v212, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[20:23], v[40:43], a[88:91], v70, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshl_b32 s63, s63, 12
		s_add_i32 m0, s61, 0x20010
		s_nop 0
		buffer_load_dwordx4 v214, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[20:23], v[44:47], a[92:95], v70, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_saveexec_b64 s[66:67], s[16:17]
		v_mov_b32_e32 v4, 8
		v_mov_b32_e32 v7, 1
		s_mov_b32 s65, 0
		scratch_store_dword off, v7, s65 offset:116
		s_waitcnt vmcnt(0)
		ds_add_rtn_u32 v12, v4, v7
		s_mov_b64 exec, s[66:67]
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s65, v12
		s_and_b32 s65, s65, -4
		s_add_i32 s65, s65, 4
		s_and_saveexec_b64 s[66:67], s[16:17]
.Lwmma_f16_matmul_tiled.loop_head_3:
		ds_read_b32 v7, v4
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s68, v7
		s_xor_b32 s69, s65, -1
		s_add_i32 s69, s69, 1
		s_add_i32 s68, s68, s69
		s_cmp_ge_u32 s68, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_3
.Lwmma_f16_matmul_tiled.loop_exit_3:
		s_mov_b64 exec, s[66:67]
		s_and_b32 s65, s62, 1
		s_lshl_b32 s65, s65, 16
		v_lshrrev_b32_e32 v4, 7, v0
		v_lshlrev_b32_e32 v4, 13, v4
		v_add_u32_e32 v4, s65, v4
		v_and_b32_e32 v7, 15, v0
		v_lshlrev_b32_e32 v12, 6, v7
		v_and_b32_e32 v75, 63, v0
		v_lshrrev_b32_e32 v75, 4, v75
		v_lshrrev_b32_e32 v7, 1, v7
		v_and_b32_e32 v7, 3, v7
		v_xor_b32_e32 v7, v75, v7
		v_lshlrev_b32_e32 v7, 4, v7
		v_add3_u32 v4, v4, v12, v7
		v_add_u32_e32 v4, 16, v4
		ds_read_b128 a[0:3], v4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[20:23], v[48:51], a[96:99], v70, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[4:7], v4 offset:1024
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[20:23], v[52:55], a[100:103], v70, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[8:11], v4 offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[20:23], v[56:59], a[104:107], v70, v73 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[12:15], v4 offset:3072
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[20:23], v[60:63], a[108:111], v70, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[184:187], v4 offset:4096
		s_mov_b32 s65, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v184, s65 offset:120
		scratch_store_dword off, v185, s65 offset:124
		scratch_store_dword off, v186, s65 offset:128
		scratch_store_dword off, v187, s65 offset:132
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[20:23], v[64:67], a[112:115], v70, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v4 offset:5120
		s_mov_b32 s65, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s65 offset:136
		scratch_store_dword off, v21, s65 offset:140
		scratch_store_dword off, v22, s65 offset:144
		scratch_store_dword off, v23, s65 offset:148
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[24:27], v[36:39], a[116:119], v70, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v4 offset:6144
		s_mov_b32 s65, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s65 offset:152
		scratch_store_dword off, v21, s65 offset:156
		scratch_store_dword off, v22, s65 offset:160
		scratch_store_dword off, v23, s65 offset:164
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[24:27], v[40:43], a[120:123], v70, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v4 offset:7168
		s_mov_b32 s65, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s65 offset:168
		scratch_store_dword off, v21, s65 offset:172
		scratch_store_dword off, v22, s65 offset:176
		scratch_store_dword off, v23, s65 offset:180
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[24:27], v[44:47], a[124:127], v70, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v1 offset:32768
		s_mov_b32 s65, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s65 offset:184
		scratch_store_dword off, v21, s65 offset:188
		scratch_store_dword off, v22, s65 offset:192
		scratch_store_dword off, v23, s65 offset:196
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[24:27], v[48:51], a[128:131], v70, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v1 offset:33792
		s_mov_b32 s65, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s65 offset:200
		scratch_store_dword off, v21, s65 offset:204
		scratch_store_dword off, v22, s65 offset:208
		scratch_store_dword off, v23, s65 offset:212
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[24:27], v[52:55], a[132:135], v70, v73 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v1 offset:34816
		s_mov_b32 s65, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s65 offset:216
		scratch_store_dword off, v21, s65 offset:220
		scratch_store_dword off, v22, s65 offset:224
		scratch_store_dword off, v23, s65 offset:228
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[24:27], v[56:59], a[136:139], v70, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v1 offset:35840
		s_mov_b32 s65, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s65 offset:232
		scratch_store_dword off, v21, s65 offset:236
		scratch_store_dword off, v22, s65 offset:240
		scratch_store_dword off, v23, s65 offset:244
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[24:27], v[60:63], a[140:143], v70, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v1 offset:36864
		s_mov_b32 s65, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s65 offset:248
		scratch_store_dword off, v21, s65 offset:252
		scratch_store_dword off, v22, s65 offset:256
		scratch_store_dword off, v23, s65 offset:260
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[24:27], v[64:67], a[144:147], v70, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v1 offset:37888
		s_mov_b32 s65, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s65 offset:264
		scratch_store_dword off, v21, s65 offset:268
		scratch_store_dword off, v22, s65 offset:272
		scratch_store_dword off, v23, s65 offset:276
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[28:31], v[36:39], a[148:151], v71, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v1 offset:38912
		s_mov_b32 s65, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s65 offset:280
		scratch_store_dword off, v21, s65 offset:284
		scratch_store_dword off, v22, s65 offset:288
		scratch_store_dword off, v23, s65 offset:292
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[28:31], v[40:43], a[152:155], v71, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[184:187], v1 offset:39936
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[28:31], v[44:47], a[156:159], v71, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s63, s63, 0x20000
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v1, 10, v1
		v_and_b32_e32 v4, 63, v0
		v_lshlrev_b32_e32 v4, 2, v4
		v_add3_u32 v7, s63, v1, v4
		v_add_u32_e32 v7, 16, v7
		ds_read_b32 v12, v7
		ds_read_b32 v75, v7 offset:256
		ds_read_b32 v94, v7 offset:512
		ds_read_b32 v95, v7 offset:768
		v_lshrrev_b32_e32 v7, 6, v0
		v_and_b32_e32 v7, 1, v7
		v_lshlrev_b32_e32 v7, 10, v7
		v_add3_u32 v20, s63, v4, v7
		v_add_u32_e32 v20, 16, v20
		ds_read_b32 v114, v20 offset:2048
		ds_read_b32 v115, v20 offset:2304
		ds_read_b32 v116, v20 offset:2560
		ds_read_b32 v117, v20 offset:2816
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[28:31], v[48:51], a[160:163], v71, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[32:35], v[48:51], a[192:195], v71, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[32:35], v[44:47], a[188:191], v71, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[32:35], v[36:39], a[180:183], v71, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[32:35], v[40:43], a[184:187], v71, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[32:35], v[52:55], a[196:199], v71, v73 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[28:31], v[52:55], a[164:167], v71, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[28:31], v[56:59], a[168:171], v71, v73 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[32:35], v[56:59], a[200:203], v71, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[32:35], v[60:63], a[204:207], v71, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[28:31], v[60:63], a[172:175], v71, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[28:31], v[64:67], a[176:179], v71, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[32:35], v[64:67], a[208:211], v71, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[236:239], v[228:231], a[172:175], v71, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[236:239], v[232:235], a[176:179], v71, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[240:243], v[232:235], a[208:211], v71, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[240:243], v[228:231], a[204:207], v71, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[212:215], v[228:231], v[148:151], v68, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[212:215], v[232:235], v[152:155], v68, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[216:219], v[232:235], a[16:19], v68, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[216:219], v[228:231], v[180:183], v68, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[216:219], a[244:247], v[156:159], v68, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], a[212:215], a[244:247], v[16:19], v68, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[212:215], a[248:251], v[96:99], v68, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[216:219], a[248:251], v[160:163], v68, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[216:219], a[252:255], v[164:167], v68, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[212:215], a[252:255], v[132:135], v68, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[212:215], v[216:219], v[136:139], v68, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[216:219], v[216:219], v[168:171], v68, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[216:219], v[220:223], v[172:175], v68, v73 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[212:215], v[220:223], v[140:143], v68, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[212:215], v[224:227], v[144:147], v68, v73 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[216:219], v[224:227], v[176:179], v68, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[220:223], v[224:227], a[40:43], v69, v73 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[220:223], v[220:223], a[36:39], v69, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[224:227], v[220:223], a[68:71], v69, v73 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[224:227], v[224:227], a[72:75], v69, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[224:227], a[244:247], a[52:55], v69, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[220:223], a[244:247], a[20:23], v69, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[220:223], a[248:251], a[24:27], v69, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[224:227], a[248:251], a[56:59], v69, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[224:227], a[252:255], a[60:63], v69, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[220:223], a[252:255], a[28:31], v69, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[220:223], v[216:219], a[32:35], v69, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[224:227], v[216:219], a[64:67], v69, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[224:227], v[228:231], a[76:79], v69, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[220:223], v[228:231], a[44:47], v69, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[220:223], v[232:235], a[48:51], v69, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[224:227], v[232:235], a[80:83], v69, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], a[228:231], v[232:235], a[112:115], v70, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], a[228:231], v[228:231], a[108:111], v70, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], a[232:235], v[228:231], a[140:143], v70, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], a[232:235], v[232:235], a[144:147], v70, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], a[232:235], a[244:247], a[116:119], v70, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], a[228:231], a[244:247], a[84:87], v70, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], a[228:231], a[248:251], a[88:91], v70, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], a[232:235], a[248:251], a[120:123], v70, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], a[232:235], a[252:255], a[124:127], v70, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], a[228:231], a[252:255], a[92:95], v70, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], a[228:231], v[216:219], a[96:99], v70, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], a[232:235], v[216:219], a[128:131], v70, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], a[232:235], v[220:223], a[132:135], v70, v73 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], a[228:231], v[220:223], a[100:103], v70, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], a[228:231], v[224:227], a[104:107], v70, v73 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], a[232:235], v[224:227], a[136:139], v70, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[236:239], v[224:227], a[168:171], v71, v73 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[236:239], v[220:223], a[164:167], v71, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[240:243], v[220:223], a[196:199], v71, v73 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[240:243], v[224:227], a[200:203], v71, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[240:243], a[244:247], a[180:183], v71, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[236:239], a[244:247], a[148:151], v71, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[236:239], a[248:251], a[152:155], v71, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[240:243], a[248:251], a[184:187], v71, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[240:243], a[252:255], a[188:191], v71, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[236:239], a[252:255], a[156:159], v71, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[236:239], v[216:219], a[160:163], v71, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[240:243], v[216:219], a[192:195], v71, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s63, s64, 1
		s_lshl_b32 s64, s63, 16
		v_lshrrev_b32_e32 v6, 7, v0
		v_lshlrev_b32_e32 v6, 13, v6
		v_add_u32_e32 v20, s64, v6
		v_and_b32_e32 v21, 15, v0
		v_lshlrev_b32_e32 v21, 6, v21
		v_and_b32_e32 v22, 63, v0
		v_lshrrev_b32_e32 v22, 4, v22
		v_and_b32_e32 v23, 15, v0
		v_lshrrev_b32_e32 v23, 1, v23
		v_and_b32_e32 v23, 3, v23
		v_xor_b32_e32 v22, v22, v23
		v_lshlrev_b32_e32 v22, 4, v22
		v_add3_u32 v20, v20, v21, v22
		v_add_u32_e32 v20, 16, v20
		ds_read_b128 v[24:27], v20
		ds_read_b128 v[28:31], v20 offset:1024
		ds_read_b128 v[32:35], v20 offset:2048
		ds_read_b128 v[36:39], v20 offset:3072
		ds_read_b128 v[40:43], v20 offset:4096
		ds_read_b128 v[44:47], v20 offset:5120
		ds_read_b128 a[212:215], v20 offset:6144
		ds_read_b128 a[216:219], v20 offset:7168
		v_add_u32_e32 v23, s64, v21
		v_lshrrev_b32_e32 v48, 6, v0
		v_and_b32_e32 v48, 1, v48
		v_lshlrev_b32_e32 v48, 13, v48
		v_add3_u32 v23, v23, v48, v22
		v_add_u32_e32 v23, 16, v23
		ds_read_b128 a[220:223], v23 offset:32768
		ds_read_b128 a[224:227], v23 offset:33792
		ds_read_b128 a[228:231], v23 offset:34816
		ds_read_b128 a[232:235], v23 offset:35840
		ds_read_b128 a[236:239], v23 offset:36864
		ds_read_b128 a[240:243], v23 offset:37888
		ds_read_b128 v[52:55], v23 offset:38912
		ds_read_b128 a[244:247], v23 offset:39936
		s_lshl_b32 s63, s63, 12
		s_add_i32 s63, s63, 0x20000
		v_add3_u32 v1, s63, v1, v4
		v_add_u32_e32 v1, 16, v1
		ds_read_b32 v23, v1
		ds_read_b32 v49, v1 offset:256
		ds_read_b32 v50, v1 offset:512
		ds_read_b32 v51, v1 offset:768
		v_add3_u32 v1, s63, v4, v7
		v_add_u32_e32 v1, 16, v1
		ds_read_b32 v4, v1 offset:2048
		ds_read_b32 v7, v1 offset:2304
		ds_read_b32 v56, v1 offset:2560
		ds_read_b32 v57, v1 offset:2816
		s_mov_b32 s63, 0
		s_waitcnt vmcnt(63) expcnt(7) lgkmcnt(15)
		scratch_load_dword v58, off, s63 offset:4
		scratch_load_dword v59, off, s63 offset:8
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v60, vcc, v58, v86
		v_addc_co_u32_e64 v61, vcc, v59, v87, vcc
		s_mov_b32 s63, 0
		scratch_load_dword v58, off, s63 offset:12
		scratch_load_dword v59, off, s63 offset:16
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v62, vcc, v58, v86
		v_addc_co_u32_e64 v63, vcc, v59, v87, vcc
		s_mov_b32 s63, 0
		scratch_load_dword v58, off, s63 offset:20
		scratch_load_dword v59, off, s63 offset:24
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v64, vcc, v58, v86
		v_addc_co_u32_e64 v65, vcc, v59, v87, vcc
		s_mov_b32 s63, 0
		scratch_load_dword v58, off, s63 offset:28
		scratch_load_dword v59, off, s63 offset:32
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v66, vcc, v58, v86
		v_addc_co_u32_e64 v67, vcc, v59, v87, vcc
		s_mov_b32 s63, 0
		scratch_load_dword v58, off, s63 offset:36
		scratch_load_dword v59, off, s63 offset:40
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v68, vcc, v58, v86
		v_addc_co_u32_e64 v69, vcc, v59, v87, vcc
		s_mov_b32 s63, 0
		s_waitcnt vmcnt(61)
		scratch_load_dword v58, off, s63 offset:44
		scratch_load_dword v59, off, s63 offset:48
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v70, vcc, v58, v86
		v_addc_co_u32_e64 v71, vcc, v59, v87, vcc
		s_mov_b32 s63, 0
		s_waitcnt vmcnt(59)
		scratch_load_dword v58, off, s63 offset:52
		scratch_load_dword v59, off, s63 offset:56
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v72, vcc, v58, v86
		v_addc_co_u32_e64 v73, vcc, v59, v87, vcc
		s_mov_b32 s63, 0
		s_waitcnt vmcnt(57)
		scratch_load_dword v58, off, s63 offset:60
		scratch_load_dword v59, off, s63 offset:64
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v188, vcc, v58, v86
		v_addc_co_u32_e64 v189, vcc, v59, v87, vcc
		s_mov_b32 s63, 0
		s_waitcnt vmcnt(55)
		scratch_load_dword v58, off, s63 offset:68
		scratch_load_dword v59, off, s63 offset:72
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v190, vcc, v58, v86
		v_addc_co_u32_e64 v191, vcc, v59, v87, vcc
		s_mov_b32 s63, 0
		s_waitcnt vmcnt(53)
		scratch_load_dword v58, off, s63 offset:76
		scratch_load_dword v59, off, s63 offset:80
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v192, vcc, v58, v86
		v_addc_co_u32_e64 v193, vcc, v59, v87, vcc
		s_mov_b32 s63, 0
		s_waitcnt vmcnt(51)
		scratch_load_dword v58, off, s63 offset:84
		scratch_load_dword v59, off, s63 offset:88
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v194, vcc, v58, v86
		v_addc_co_u32_e64 v195, vcc, v59, v87, vcc
		s_mov_b32 s63, 0
		s_waitcnt vmcnt(49)
		scratch_load_dword v58, off, s63 offset:92
		scratch_load_dword v59, off, s63 offset:96
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v196, vcc, v58, v86
		v_addc_co_u32_e64 v197, vcc, v59, v87, vcc
		s_mov_b32 s63, 0
		s_waitcnt vmcnt(47)
		scratch_load_dword v58, off, s63 offset:100
		scratch_load_dword v59, off, s63 offset:104
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v198, vcc, v58, v86
		v_addc_co_u32_e64 v199, vcc, v59, v87, vcc
		s_mov_b32 s63, 0
		s_waitcnt vmcnt(45)
		scratch_load_dword v58, off, s63 offset:108
		scratch_load_dword v59, off, s63 offset:112
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v200, vcc, v58, v86
		v_addc_co_u32_e64 v201, vcc, v59, v87, vcc
		v_add_co_u32_e64 v58, vcc, v82, v86
		v_addc_co_u32_e64 v59, vcc, v83, v87, vcc
		v_add_co_u32_e64 v202, vcc, v84, v86
		v_addc_co_u32_e64 v203, vcc, v85, v87, vcc
		v_add_co_u32_e64 v86, vcc, v88, v210
		v_addc_co_u32_e64 v87, vcc, v89, v211, vcc
		v_add_co_u32_e64 v204, vcc, v76, v210
		v_addc_co_u32_e64 v205, vcc, v77, v211, vcc
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[24:27], a[220:223], v[16:19], v23, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[248:251], v20 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[24:27], a[224:227], v[96:99], v23, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 a[252:255], v20 offset:17408
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[24:27], a[228:231], v[132:135], v23, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[208:211], v20 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[24:27], a[232:235], v[136:139], v23, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s63, s62, 1
		s_and_b32 s63, s63, 1
		s_lshl_b32 s63, s63, 16
		v_add_u32_e32 v1, s63, v6
		v_add3_u32 v1, v1, v21, v22
		v_add_u32_e32 v1, 16, v1
		ds_read_b128 v[212:215], v1 offset:19456
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[24:27], a[236:239], v[140:143], v23, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v1 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], a[240:243], v[144:147], v23, v56 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v1 offset:21504
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[52:55], v[148:151], v23, v57 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v1 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], a[244:247], v[152:155], v23, v57 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v1 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[28:31], a[220:223], v[156:159], v23, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s63, s62, 1
		s_and_b32 s63, s63, 1
		s_lshl_b32 s63, s63, 16
		v_add_u32_e32 v1, s63, v21
		v_add3_u32 v1, v1, v48, v22
		v_add_u32_e32 v1, 16, v1
		ds_read_b128 v[228:231], v1 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[28:31], a[224:227], v[160:163], v23, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[232:235], v1 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[28:31], a[228:231], v[164:167], v23, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[236:239], v1 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[28:31], a[232:235], v[168:171], v23, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v1 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[28:31], a[236:239], v[172:175], v23, v56 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[244:247], v1 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], a[240:243], v[176:179], v23, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v1 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[52:55], v[180:183], v23, v57 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[252:255], v1 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[28:31], a[244:247], a[16:19], v23, v57 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[28:31], v1 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[32:35], a[220:223], a[20:23], v49, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s19, 16
		s_nop 0
		buffer_load_dwordx4 v60, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[32:35], a[224:227], a[24:27], v49, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s32, 16
		s_nop 0
		buffer_load_dwordx4 v62, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[32:35], a[228:231], a[28:31], v49, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s33, 16
		s_nop 0
		buffer_load_dwordx4 v64, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[32:35], a[232:235], a[32:35], v49, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s34, 16
		s_nop 0
		buffer_load_dwordx4 v66, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[32:35], a[236:239], a[36:39], v49, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s35, 16
		s_nop 0
		buffer_load_dwordx4 v68, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[32:35], a[240:243], a[40:43], v49, v56 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s36, 16
		s_nop 0
		buffer_load_dwordx4 v70, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[32:35], v[52:55], a[44:47], v49, v57 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s37, 16
		s_nop 0
		buffer_load_dwordx4 v72, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[32:35], a[244:247], a[48:51], v49, v57 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s38, 16
		s_nop 0
		buffer_load_dwordx4 v188, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[36:39], a[220:223], a[52:55], v49, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s39, 16
		s_nop 0
		buffer_load_dwordx4 v190, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[36:39], a[224:227], a[56:59], v49, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s40, 16
		s_nop 0
		buffer_load_dwordx4 v192, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[36:39], a[228:231], a[60:63], v49, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s41, 16
		s_nop 0
		buffer_load_dwordx4 v194, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[36:39], a[232:235], a[64:67], v49, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s43, 16
		s_nop 0
		buffer_load_dwordx4 v196, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[36:39], a[236:239], a[68:71], v49, v56 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s44, 16
		s_nop 0
		buffer_load_dwordx4 v198, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[36:39], a[240:243], a[72:75], v49, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s45, 16
		s_nop 0
		buffer_load_dwordx4 v200, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[36:39], v[52:55], a[76:79], v49, v57 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s46, 16
		s_nop 0
		buffer_load_dwordx4 v58, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[36:39], a[244:247], a[80:83], v49, v57 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s47, 16
		s_nop 0
		buffer_load_dwordx4 v202, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[40:43], a[220:223], a[84:87], v50, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s10, 0x20010
		s_nop 0
		buffer_load_dwordx4 v86, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[40:43], a[224:227], a[88:91], v50, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s62, s62, 2
		s_add_i32 m0, s9, 0x20010
		s_nop 0
		buffer_load_dwordx4 v204, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[40:43], a[228:231], a[92:95], v50, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[40:43], a[232:235], a[96:99], v50, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[44:47], a[232:235], a[128:131], v50, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[44:47], a[228:231], a[124:127], v50, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[44:47], a[220:223], a[116:119], v50, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[44:47], a[224:227], a[120:123], v50, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[44:47], a[236:239], a[132:135], v50, v56 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[40:43], a[236:239], a[100:103], v50, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[40:43], a[240:243], a[104:107], v50, v56 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[44:47], a[240:243], a[136:139], v50, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[44:47], v[52:55], a[140:143], v50, v57 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[40:43], v[52:55], a[108:111], v50, v57 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[40:43], a[244:247], a[112:115], v50, v57 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[44:47], a[244:247], a[144:147], v50, v57 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], a[212:215], a[244:247], a[176:179], v51, v57 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], a[212:215], v[52:55], a[172:175], v51, v57 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], a[216:219], v[52:55], a[204:207], v51, v57 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], a[216:219], a[244:247], a[208:211], v51, v57 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], a[216:219], a[220:223], a[180:183], v51, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], a[212:215], a[220:223], a[148:151], v51, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], a[212:215], a[224:227], a[152:155], v51, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], a[216:219], a[224:227], a[184:187], v51, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], a[216:219], a[228:231], a[188:191], v51, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], a[212:215], a[228:231], a[156:159], v51, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], a[212:215], a[232:235], a[160:163], v51, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], a[216:219], a[232:235], a[192:195], v51, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], a[216:219], a[236:239], a[196:199], v51, v56 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], a[212:215], a[236:239], a[164:167], v51, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], a[212:215], a[240:243], a[168:171], v51, v56 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], a[216:219], a[240:243], a[200:203], v51, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_saveexec_b64 s[64:65], s[16:17]
		v_mov_b32_e32 v1, 12
		s_mov_b32 s63, 0
		s_waitcnt vmcnt(44)
		scratch_load_dword v6, off, s63 offset:116
		s_waitcnt vmcnt(0)
		ds_add_rtn_u32 v20, v1, v6
		s_mov_b64 exec, s[64:65]
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s63, v20
		s_and_b32 s63, s63, -4
		s_add_i32 s63, s63, 4
		s_and_saveexec_b64 s[64:65], s[16:17]
.Lwmma_f16_matmul_tiled.loop_head_4:
		ds_read_b32 v6, v1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s66, v6
		s_xor_b32 s67, s63, -1
		s_add_i32 s67, s67, 1
		s_add_i32 s66, s66, s67
		s_cmp_ge_u32 s66, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_4
.Lwmma_f16_matmul_tiled.loop_exit_4:
		s_mov_b64 exec, s[64:65]
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], a[248:251], v[228:231], v[16:19], v23, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[248:251], v[232:235], v[96:99], v23, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[252:255], v[232:235], v[160:163], v23, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[252:255], v[228:231], v[156:159], v23, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[252:255], v[236:239], v[164:167], v23, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[248:251], v[236:239], v[132:135], v23, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[248:251], v[240:243], v[136:139], v23, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[252:255], v[240:243], v[168:171], v23, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[252:255], v[244:247], v[172:175], v23, v56 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[248:251], v[244:247], v[140:143], v23, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[248:251], v[248:251], v[144:147], v23, v56 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[252:255], v[248:251], v[176:179], v23, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[252:255], v[252:255], v[180:183], v23, v57 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[248:251], v[252:255], v[148:151], v23, v57 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[248:251], v[28:31], v[152:155], v23, v57 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[252:255], v[28:31], a[16:19], v23, v57 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[208:211], v[28:31], a[48:51], v49, v57 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[208:211], v[252:255], a[44:47], v49, v57 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[212:215], v[252:255], a[76:79], v49, v57 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[212:215], v[28:31], a[80:83], v49, v57 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[212:215], v[228:231], a[52:55], v49, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[208:211], v[228:231], a[20:23], v49, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[208:211], v[232:235], a[24:27], v49, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[212:215], v[232:235], a[56:59], v49, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[212:215], v[236:239], a[60:63], v49, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[208:211], v[236:239], a[28:31], v49, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[208:211], v[240:243], a[32:35], v49, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[212:215], v[240:243], a[64:67], v49, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[212:215], v[244:247], a[68:71], v49, v56 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[208:211], v[244:247], a[36:39], v49, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[208:211], v[248:251], a[40:43], v49, v56 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[212:215], v[248:251], a[72:75], v49, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[216:219], v[248:251], a[104:107], v50, v56 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[216:219], v[244:247], a[100:103], v50, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[220:223], v[244:247], a[132:135], v50, v56 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[220:223], v[248:251], a[136:139], v50, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[220:223], v[228:231], a[116:119], v50, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[216:219], v[228:231], a[84:87], v50, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[216:219], v[232:235], a[88:91], v50, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[220:223], v[232:235], a[120:123], v50, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[220:223], v[236:239], a[124:127], v50, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[216:219], v[236:239], a[92:95], v50, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[216:219], v[240:243], a[96:99], v50, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[220:223], v[240:243], a[128:131], v50, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[220:223], v[252:255], a[140:143], v50, v57 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[216:219], v[252:255], a[108:111], v50, v57 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[216:219], v[28:31], a[112:115], v50, v57 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[220:223], v[28:31], a[144:147], v50, v57 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[224:227], v[28:31], a[176:179], v51, v57 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[224:227], v[252:255], a[172:175], v51, v57 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[24:27], v[252:255], a[204:207], v51, v57 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[24:27], v[28:31], a[208:211], v51, v57 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[24:27], v[228:231], a[180:183], v51, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[224:227], v[228:231], a[148:151], v51, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[224:227], v[232:235], a[152:155], v51, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[24:27], v[232:235], a[184:187], v51, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[24:27], v[236:239], a[188:191], v51, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[224:227], v[236:239], a[156:159], v51, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[224:227], v[240:243], a[160:163], v51, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[24:27], v[240:243], a[192:195], v51, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[24:27], v[244:247], a[196:199], v51, v56 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[224:227], v[244:247], a[164:167], v51, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[224:227], v[248:251], a[168:171], v51, v56 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[24:27], v[248:251], a[200:203], v51, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s63, 0
		s_waitcnt vmcnt(40)
		scratch_load_dword v24, off, s63 offset:120
		scratch_load_dword v25, off, s63 offset:124
		scratch_load_dword v26, off, s63 offset:128
		scratch_load_dword v27, off, s63 offset:132
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v20, v24
		v_mov_b32_e32 v21, v25
		v_mov_b32_e32 v22, v26
		v_mov_b32_e32 v23, v27
		s_mov_b32 s63, 0
		s_waitcnt vmcnt(36)
		scratch_load_dword v28, off, s63 offset:136
		scratch_load_dword v29, off, s63 offset:140
		scratch_load_dword v30, off, s63 offset:144
		scratch_load_dword v31, off, s63 offset:148
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v24, v28
		v_mov_b32_e32 v25, v29
		v_mov_b32_e32 v26, v30
		v_mov_b32_e32 v27, v31
		s_mov_b32 s63, 0
		s_waitcnt vmcnt(32)
		scratch_load_dword v32, off, s63 offset:152
		scratch_load_dword v33, off, s63 offset:156
		scratch_load_dword v34, off, s63 offset:160
		scratch_load_dword v35, off, s63 offset:164
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v28, v32
		v_mov_b32_e32 v29, v33
		v_mov_b32_e32 v30, v34
		v_mov_b32_e32 v31, v35
		s_mov_b32 s63, 0
		s_waitcnt vmcnt(28)
		scratch_load_dword v36, off, s63 offset:168
		scratch_load_dword v37, off, s63 offset:172
		scratch_load_dword v38, off, s63 offset:176
		scratch_load_dword v39, off, s63 offset:180
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v32, v36
		v_mov_b32_e32 v33, v37
		v_mov_b32_e32 v34, v38
		v_mov_b32_e32 v35, v39
		s_mov_b32 s63, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v40, off, s63 offset:184
		scratch_load_dword v41, off, s63 offset:188
		scratch_load_dword v42, off, s63 offset:192
		scratch_load_dword v43, off, s63 offset:196
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v36, v40
		v_mov_b32_e32 v37, v41
		v_mov_b32_e32 v38, v42
		v_mov_b32_e32 v39, v43
		s_mov_b32 s63, 0
		s_waitcnt vmcnt(20)
		scratch_load_dword v44, off, s63 offset:200
		scratch_load_dword v45, off, s63 offset:204
		scratch_load_dword v46, off, s63 offset:208
		scratch_load_dword v47, off, s63 offset:212
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v40, v44
		v_mov_b32_e32 v41, v45
		v_mov_b32_e32 v42, v46
		v_mov_b32_e32 v43, v47
		s_mov_b32 s63, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v48, off, s63 offset:216
		scratch_load_dword v49, off, s63 offset:220
		scratch_load_dword v50, off, s63 offset:224
		scratch_load_dword v51, off, s63 offset:228
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v44, v48
		v_mov_b32_e32 v45, v49
		v_mov_b32_e32 v46, v50
		v_mov_b32_e32 v47, v51
		s_mov_b32 s63, 0
		s_waitcnt vmcnt(12)
		scratch_load_dword v52, off, s63 offset:232
		scratch_load_dword v53, off, s63 offset:236
		scratch_load_dword v54, off, s63 offset:240
		scratch_load_dword v55, off, s63 offset:244
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v48, v52
		v_mov_b32_e32 v49, v53
		v_mov_b32_e32 v50, v54
		v_mov_b32_e32 v51, v55
		s_mov_b32 s63, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v56, off, s63 offset:248
		scratch_load_dword v57, off, s63 offset:252
		scratch_load_dword v58, off, s63 offset:256
		scratch_load_dword v59, off, s63 offset:260
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v52, v56
		v_mov_b32_e32 v53, v57
		v_mov_b32_e32 v54, v58
		v_mov_b32_e32 v55, v59
		s_mov_b32 s63, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v60, off, s63 offset:264
		scratch_load_dword v61, off, s63 offset:268
		scratch_load_dword v62, off, s63 offset:272
		scratch_load_dword v63, off, s63 offset:276
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v56, v60
		v_mov_b32_e32 v57, v61
		v_mov_b32_e32 v58, v62
		v_mov_b32_e32 v59, v63
		s_mov_b32 s63, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v64, off, s63 offset:280
		scratch_load_dword v65, off, s63 offset:284
		scratch_load_dword v66, off, s63 offset:288
		scratch_load_dword v67, off, s63 offset:292
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v60, v64
		v_mov_b32_e32 v61, v65
		v_mov_b32_e32 v62, v66
		v_mov_b32_e32 v63, v67
		v_mov_b32_e32 v64, v184
		v_mov_b32_e32 v65, v185
		v_mov_b32_e32 v66, v186
		v_mov_b32_e32 v67, v187
		v_mov_b32_e32 v68, v12
		v_mov_b32_e32 v69, v75
		v_mov_b32_e32 v70, v94
		v_mov_b32_e32 v71, v95
		v_mov_b32_e32 v6, v114
		v_mov_b32_e32 v72, v115
		v_mov_b32_e32 v73, v116
		v_mov_b32_e32 v74, v117
		s_cmp_lt_i32 s62, s8
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_2
.Lwmma_f16_matmul_tiled.loop_exit_2:
		s_add_i32 s0, s12, -1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], a[0:3], v[36:39], v[16:19], v68, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
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
		v_add_u32_e32 v2, 16, v2
		ds_read_b128 v[8:11], v2 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], a[0:3], v[40:43], v[96:99], v68, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[12:15], v2 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], a[0:3], v[44:47], v[132:135], v68, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[76:79], v2 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], a[0:3], v[48:51], v[136:139], v68, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[80:83], v2 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], a[0:3], v[52:55], v[140:143], v68, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[84:87], v2 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], a[0:3], v[56:59], v[144:147], v68, v73 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v2 offset:21504
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], a[0:3], v[60:63], v[148:151], v68, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v2 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], a[0:3], v[64:67], v[152:155], v68, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v2 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], a[4:7], v[36:39], v[156:159], v68, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, s0, v3
		v_lshrrev_b32_e32 v5, 6, v0
		v_and_b32_e32 v5, 1, v5
		v_lshlrev_b32_e32 v5, 13, v5
		v_add3_u32 v2, v2, v5, v4
		v_add_u32_e32 v2, 16, v2
		ds_read_b128 v[104:107], v2 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], a[4:7], v[40:43], v[160:163], v68, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[108:111], v2 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], a[4:7], v[44:47], v[164:167], v68, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[112:115], v2 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], a[4:7], v[48:51], v[168:171], v68, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[116:119], v2 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], a[4:7], v[52:55], v[172:175], v68, v73 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[120:123], v2 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], a[4:7], v[56:59], v[176:179], v68, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[124:127], v2 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], a[4:7], v[60:63], v[180:183], v68, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[128:131], v2 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], a[4:7], v[64:67], a[16:19], v68, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[184:187], v2 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], a[8:11], v[36:39], a[20:23], v69, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], a[8:11], v[40:43], a[24:27], v69, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], a[12:15], v[40:43], a[56:59], v69, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], a[12:15], v[36:39], a[52:55], v69, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], a[12:15], v[44:47], a[60:63], v69, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], a[8:11], v[44:47], a[28:31], v69, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], a[8:11], v[48:51], a[32:35], v69, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], a[12:15], v[48:51], a[64:67], v69, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], a[12:15], v[52:55], a[68:71], v69, v73 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], a[8:11], v[52:55], a[36:39], v69, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], a[8:11], v[56:59], a[40:43], v69, v73 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], a[12:15], v[56:59], a[72:75], v69, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], a[12:15], v[60:63], a[76:79], v69, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], a[8:11], v[60:63], a[44:47], v69, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], a[8:11], v[64:67], a[48:51], v69, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], a[12:15], v[64:67], a[80:83], v69, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[20:23], v[64:67], a[112:115], v70, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[20:23], v[60:63], a[108:111], v70, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[24:27], v[60:63], a[140:143], v70, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[24:27], v[64:67], a[144:147], v70, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[24:27], v[36:39], a[116:119], v70, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[20:23], v[36:39], a[84:87], v70, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[20:23], v[40:43], a[88:91], v70, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[24:27], v[40:43], a[120:123], v70, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[24:27], v[44:47], a[124:127], v70, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[20:23], v[44:47], a[92:95], v70, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[20:23], v[48:51], a[96:99], v70, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[24:27], v[48:51], a[128:131], v70, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[24:27], v[52:55], a[132:135], v70, v73 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[20:23], v[52:55], a[100:103], v70, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[20:23], v[56:59], a[104:107], v70, v73 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[24:27], v[56:59], a[136:139], v70, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[28:31], v[56:59], a[168:171], v71, v73 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[28:31], v[52:55], a[164:167], v71, v73 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[32:35], v[52:55], a[196:199], v71, v73 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[32:35], v[56:59], a[200:203], v71, v73 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[32:35], v[36:39], a[180:183], v71, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[28:31], v[36:39], a[148:151], v71, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[28:31], v[40:43], a[152:155], v71, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[32:35], v[40:43], a[184:187], v71, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[32:35], v[44:47], a[188:191], v71, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[28:31], v[44:47], a[156:159], v71, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[28:31], v[48:51], a[160:163], v71, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[32:35], v[48:51], a[192:195], v71, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[32:35], v[60:63], a[204:207], v71, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[28:31], v[60:63], a[172:175], v71, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[28:31], v[64:67], a[176:179], v71, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[32:35], v[64:67], a[208:211], v71, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[92:95], v[128:131], a[172:175], v71, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[92:95], v[184:187], a[176:179], v71, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[100:103], v[184:187], a[208:211], v71, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[100:103], v[128:131], a[204:207], v71, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[8:11], v[128:131], v[148:151], v68, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[8:11], v[184:187], v[152:155], v68, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[12:15], v[184:187], a[16:19], v68, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[12:15], v[128:131], v[180:183], v68, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[12:15], v[104:107], v[156:159], v68, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[8:11], v[104:107], v[16:19], v68, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[8:11], v[108:111], v[96:99], v68, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[12:15], v[108:111], v[160:163], v68, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[12:15], v[112:115], v[164:167], v68, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[8:11], v[112:115], v[132:135], v68, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[8:11], v[116:119], v[136:139], v68, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[12:15], v[116:119], v[168:171], v68, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[12:15], v[120:123], v[172:175], v68, v73 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[8:11], v[120:123], v[140:143], v68, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[8:11], v[124:127], v[144:147], v68, v73 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[12:15], v[124:127], v[176:179], v68, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[76:79], v[124:127], a[40:43], v69, v73 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[76:79], v[120:123], a[36:39], v69, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[80:83], v[120:123], a[68:71], v69, v73 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[80:83], v[124:127], a[72:75], v69, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[80:83], v[104:107], a[52:55], v69, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[76:79], v[104:107], a[20:23], v69, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[76:79], v[108:111], a[24:27], v69, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[80:83], v[108:111], a[56:59], v69, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[80:83], v[112:115], a[60:63], v69, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[76:79], v[112:115], a[28:31], v69, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[76:79], v[116:119], a[32:35], v69, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[80:83], v[116:119], a[64:67], v69, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[80:83], v[128:131], a[76:79], v69, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[76:79], v[128:131], a[44:47], v69, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[76:79], v[184:187], a[48:51], v69, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[80:83], v[184:187], a[80:83], v69, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[84:87], v[184:187], a[112:115], v70, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[84:87], v[128:131], a[108:111], v70, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[88:91], v[128:131], a[140:143], v70, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[88:91], v[184:187], a[144:147], v70, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[88:91], v[104:107], a[116:119], v70, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[84:87], v[104:107], a[84:87], v70, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[84:87], v[108:111], a[88:91], v70, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[88:91], v[108:111], a[120:123], v70, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[88:91], v[112:115], a[124:127], v70, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[84:87], v[112:115], a[92:95], v70, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[84:87], v[116:119], a[96:99], v70, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[88:91], v[116:119], a[128:131], v70, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[88:91], v[120:123], a[132:135], v70, v73 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[84:87], v[120:123], a[100:103], v70, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[84:87], v[124:127], a[104:107], v70, v73 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[88:91], v[124:127], a[136:139], v70, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[92:95], v[124:127], a[168:171], v71, v73 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[92:95], v[120:123], a[164:167], v71, v73 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[100:103], v[120:123], a[196:199], v71, v73 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[100:103], v[124:127], a[200:203], v71, v73 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[100:103], v[104:107], a[180:183], v71, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[92:95], v[104:107], a[148:151], v71, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[92:95], v[108:111], a[152:155], v71, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[100:103], v[108:111], a[184:187], v71, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[100:103], v[112:115], a[188:191], v71, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[92:95], v[112:115], a[156:159], v71, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[92:95], v[116:119], a[160:163], v71, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[100:103], v[116:119], a[192:195], v71, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s0, s12, 1
		s_lshl_b32 s1, s0, 16
		v_add_u32_e32 v1, s1, v1
		v_add3_u32 v1, v1, v3, v4
		v_add_u32_e32 v1, 16, v1
		ds_read_b128 v[8:11], v1
		ds_read_b128 v[12:15], v1 offset:1024
		ds_read_b128 v[20:23], v1 offset:2048
		ds_read_b128 v[24:27], v1 offset:3072
		ds_read_b128 v[28:31], v1 offset:4096
		ds_read_b128 v[32:35], v1 offset:5120
		ds_read_b128 v[36:39], v1 offset:6144
		ds_read_b128 v[40:43], v1 offset:7168
		v_add_u32_e32 v2, s1, v3
		v_add3_u32 v2, v2, v5, v4
		v_add_u32_e32 v2, 16, v2
		ds_read_b128 v[4:7], v2 offset:32768
		ds_read_b128 v[44:47], v2 offset:33792
		ds_read_b128 v[48:51], v2 offset:34816
		ds_read_b128 v[52:55], v2 offset:35840
		ds_read_b128 v[56:59], v2 offset:36864
		ds_read_b128 v[60:63], v2 offset:37888
		ds_read_b128 v[64:67], v2 offset:38912
		ds_read_b128 v[68:71], v2 offset:39936
		s_lshl_b32 s0, s0, 12
		s_add_i32 s0, s0, 0x20000
		v_lshrrev_b32_e32 v3, 7, v0
		v_lshlrev_b32_e32 v3, 10, v3
		v_and_b32_e32 v72, 63, v0
		v_lshlrev_b32_e32 v72, 2, v72
		v_add3_u32 v3, s0, v3, v72
		v_add_u32_e32 v3, 16, v3
		ds_read_b32 v73, v3
		ds_read_b32 v74, v3 offset:256
		ds_read_b32 v75, v3 offset:512
		ds_read_b32 v76, v3 offset:768
		v_lshrrev_b32_e32 v3, 6, v0
		v_and_b32_e32 v3, 1, v3
		v_lshlrev_b32_e32 v3, 10, v3
		v_add3_u32 v3, s0, v72, v3
		v_add_u32_e32 v3, 16, v3
		ds_read_b32 v72, v3 offset:2048
		ds_read_b32 v77, v3 offset:2304
		ds_read_b32 v78, v3 offset:2560
		ds_read_b32 v79, v3 offset:2816
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[8:11], v[4:7], v[16:19], v73, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[80:83], v1 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[8:11], v[44:47], v[96:99], v73, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[84:87], v1 offset:17408
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[8:11], v[48:51], v[132:135], v73, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v1 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[8:11], v[52:55], v[136:139], v73, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v1 offset:19456
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[8:11], v[56:59], v[140:143], v73, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v1 offset:20480
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[8:11], v[60:63], v[144:147], v73, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[104:107], v1 offset:21504
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[8:11], v[64:67], v[148:151], v73, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[108:111], v1 offset:22528
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[8:11], v[68:71], v[152:155], v73, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[8:11], v1 offset:23552
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[12:15], v[4:7], v[156:159], v73, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[112:115], v2 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[12:15], v[44:47], v[160:163], v73, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[116:119], v2 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[12:15], v[48:51], v[164:167], v73, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[120:123], v2 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[12:15], v[52:55], v[168:171], v73, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[124:127], v2 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[12:15], v[56:59], v[172:175], v73, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[128:131], v2 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[12:15], v[60:63], v[176:179], v73, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[184:187], v2 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[12:15], v[64:67], v[180:183], v73, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[188:191], v2 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[12:15], v[68:71], a[16:19], v73, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[12:15], v2 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[20:23], v[4:7], a[20:23], v74, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[20:23], v[44:47], a[24:27], v74, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[24:27], v[44:47], a[56:59], v74, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[24:27], v[4:7], a[52:55], v74, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[24:27], v[48:51], a[60:63], v74, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[20:23], v[48:51], a[28:31], v74, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[20:23], v[52:55], a[32:35], v74, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[24:27], v[52:55], a[64:67], v74, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[24:27], v[56:59], a[68:71], v74, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[20:23], v[56:59], a[36:39], v74, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[20:23], v[60:63], a[40:43], v74, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[24:27], v[60:63], a[72:75], v74, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[24:27], v[64:67], a[76:79], v74, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[20:23], v[64:67], a[44:47], v74, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[20:23], v[68:71], a[48:51], v74, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[24:27], v[68:71], a[80:83], v74, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[28:31], v[68:71], a[112:115], v75, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[28:31], v[64:67], a[108:111], v75, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[32:35], v[64:67], a[140:143], v75, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[32:35], v[68:71], a[144:147], v75, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[32:35], v[4:7], a[116:119], v75, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[28:31], v[4:7], a[84:87], v75, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[28:31], v[44:47], a[88:91], v75, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[32:35], v[44:47], a[120:123], v75, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[32:35], v[48:51], a[124:127], v75, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[28:31], v[48:51], a[92:95], v75, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[28:31], v[52:55], a[96:99], v75, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[32:35], v[52:55], a[128:131], v75, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[32:35], v[56:59], a[132:135], v75, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[28:31], v[56:59], a[100:103], v75, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[28:31], v[60:63], a[104:107], v75, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[32:35], v[60:63], a[136:139], v75, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[36:39], v[60:63], a[168:171], v76, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[36:39], v[56:59], a[164:167], v76, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[40:43], v[56:59], a[196:199], v76, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[40:43], v[60:63], a[200:203], v76, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[40:43], v[4:7], a[180:183], v76, v72 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[36:39], v[4:7], a[148:151], v76, v72 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[36:39], v[44:47], a[152:155], v76, v72 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[40:43], v[44:47], a[184:187], v76, v72 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[40:43], v[48:51], a[188:191], v76, v77 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[36:39], v[48:51], a[156:159], v76, v77 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[36:39], v[52:55], a[160:163], v76, v77 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[40:43], v[52:55], a[192:195], v76, v77 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[40:43], v[64:67], a[204:207], v76, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[36:39], v[64:67], a[172:175], v76, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[36:39], v[68:71], a[176:179], v76, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[40:43], v[68:71], a[208:211], v76, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[172:175], v[108:111], v[188:191], a[172:175], v76, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[176:179], v[108:111], v[12:15], a[176:179], v76, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[208:211], v[8:11], v[12:15], a[208:211], v76, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[204:207], v[8:11], v[188:191], a[204:207], v76, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[80:83], v[188:191], v[148:151], v73, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[80:83], v[12:15], v[152:155], v73, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[84:87], v[12:15], a[16:19], v73, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[84:87], v[188:191], v[180:183], v73, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[84:87], v[112:115], v[156:159], v73, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[80:83], v[112:115], v[16:19], v73, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[80:83], v[116:119], v[96:99], v73, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[84:87], v[116:119], v[160:163], v73, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[84:87], v[120:123], v[164:167], v73, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[80:83], v[120:123], v[132:135], v73, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[80:83], v[124:127], v[136:139], v73, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[84:87], v[124:127], v[168:171], v73, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[84:87], v[128:131], v[172:175], v73, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[80:83], v[128:131], v[140:143], v73, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[80:83], v[184:187], v[144:147], v73, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[84:87], v[184:187], v[176:179], v73, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[88:91], v[184:187], a[40:43], v74, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[88:91], v[128:131], a[36:39], v74, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[92:95], v[128:131], a[68:71], v74, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[92:95], v[184:187], a[72:75], v74, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[92:95], v[112:115], a[52:55], v74, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[88:91], v[112:115], a[20:23], v74, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[88:91], v[116:119], a[24:27], v74, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[92:95], v[116:119], a[56:59], v74, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[92:95], v[120:123], a[60:63], v74, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[88:91], v[120:123], a[28:31], v74, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[88:91], v[124:127], a[32:35], v74, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[92:95], v[124:127], a[64:67], v74, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[92:95], v[188:191], a[76:79], v74, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[88:91], v[188:191], a[44:47], v74, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[88:91], v[12:15], a[48:51], v74, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[92:95], v[12:15], a[80:83], v74, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[112:115], v[100:103], v[12:15], a[112:115], v75, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[108:111], v[100:103], v[188:191], a[108:111], v75, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[140:143], v[104:107], v[188:191], a[140:143], v75, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[144:147], v[104:107], v[12:15], a[144:147], v75, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[116:119], v[104:107], v[112:115], a[116:119], v75, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[100:103], v[112:115], a[84:87], v75, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[100:103], v[116:119], a[88:91], v75, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[120:123], v[104:107], v[116:119], a[120:123], v75, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[124:127], v[104:107], v[120:123], a[124:127], v75, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[100:103], v[120:123], a[92:95], v75, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[96:99], v[100:103], v[124:127], a[96:99], v75, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[128:131], v[104:107], v[124:127], a[128:131], v75, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[132:135], v[104:107], v[128:131], a[132:135], v75, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[100:103], v[100:103], v[128:131], a[100:103], v75, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[104:107], v[100:103], v[184:187], a[104:107], v75, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[136:139], v[104:107], v[184:187], a[136:139], v75, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[168:171], v[108:111], v[184:187], a[168:171], v76, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[164:167], v[108:111], v[128:131], a[164:167], v76, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[196:199], v[8:11], v[128:131], a[196:199], v76, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[200:203], v[8:11], v[184:187], a[200:203], v76, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[180:183], v[8:11], v[112:115], a[180:183], v76, v72 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[148:151], v[108:111], v[112:115], a[148:151], v76, v72 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[152:155], v[108:111], v[116:119], a[152:155], v76, v72 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[184:187], v[8:11], v[116:119], a[184:187], v76, v72 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[188:191], v[8:11], v[120:123], a[188:191], v76, v77 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[156:159], v[108:111], v[120:123], a[156:159], v76, v77 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[160:163], v[108:111], v[124:127], a[160:163], v76, v77 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[192:195], v[8:11], v[124:127], a[192:195], v76, v77 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v16, v17
		v_cvt_pk_f16_f32 v3, v18, v19
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0
		s_waitcnt vmcnt(0)
		v_lshlrev_b32_e32 v1, 3, v1
		v_lshrrev_b32_e32 v0, 6, v0
		v_lshl_add_u32 v0, v0, 15, v1
		s_lshl_b32 s0, s13, 21
		s_lshl_b32 s1, s14, 17
		s_add_i32 s2, s0, s1
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s2 offen
		v_cvt_pk_f16_f32 v2, v96, v97
		v_cvt_pk_f16_f32 v3, v98, v99
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s2 offen offset:512
		v_cvt_pk_f16_f32 v2, v132, v133
		v_cvt_pk_f16_f32 v3, v134, v135
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s2 offen offset:1024
		v_cvt_pk_f16_f32 v2, v136, v137
		v_cvt_pk_f16_f32 v3, v138, v139
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s2 offen offset:1536
		v_cvt_pk_f16_f32 v2, v140, v141
		v_cvt_pk_f16_f32 v3, v142, v143
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s2 offen offset:2048
		v_cvt_pk_f16_f32 v2, v144, v145
		v_cvt_pk_f16_f32 v3, v146, v147
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s2 offen offset:2560
		v_cvt_pk_f16_f32 v2, v148, v149
		v_cvt_pk_f16_f32 v3, v150, v151
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s2 offen offset:3072
		v_cvt_pk_f16_f32 v2, v152, v153
		v_cvt_pk_f16_f32 v3, v154, v155
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s2 offen offset:3584
		v_cvt_pk_f16_f32 v2, v156, v157
		v_cvt_pk_f16_f32 v3, v158, v159
		s_add_i32 s2, s0, 0x1000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s2 offen
		v_cvt_pk_f16_f32 v2, v160, v161
		v_cvt_pk_f16_f32 v3, v162, v163
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s2 offen offset:512
		v_cvt_pk_f16_f32 v2, v164, v165
		v_cvt_pk_f16_f32 v3, v166, v167
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s2 offen offset:1024
		v_cvt_pk_f16_f32 v2, v168, v169
		v_cvt_pk_f16_f32 v3, v170, v171
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s2 offen offset:1536
		v_cvt_pk_f16_f32 v2, v172, v173
		v_cvt_pk_f16_f32 v3, v174, v175
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s2 offen offset:2048
		v_cvt_pk_f16_f32 v2, v176, v177
		v_cvt_pk_f16_f32 v3, v178, v179
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s2 offen offset:2560
		v_cvt_pk_f16_f32 v2, v180, v181
		v_cvt_pk_f16_f32 v3, v182, v183
		buffer_store_dwordx2 v[2:3], v0, s[20:23], s2 offen offset:3072
		v_accvgpr_read_b32 v1, a16
		v_accvgpr_read_b32 v2, a17
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a18
		v_accvgpr_read_b32 v2, a19
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a20
		v_accvgpr_read_b32 v2, a21
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a22
		v_accvgpr_read_b32 v2, a23
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x2000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen
		v_accvgpr_read_b32 v1, a24
		v_accvgpr_read_b32 v2, a25
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a26
		v_accvgpr_read_b32 v2, a27
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:512
		v_accvgpr_read_b32 v1, a28
		v_accvgpr_read_b32 v2, a29
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a30
		v_accvgpr_read_b32 v2, a31
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:1024
		v_accvgpr_read_b32 v1, a32
		v_accvgpr_read_b32 v2, a33
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a34
		v_accvgpr_read_b32 v2, a35
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:1536
		v_accvgpr_read_b32 v1, a36
		v_accvgpr_read_b32 v2, a37
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a38
		v_accvgpr_read_b32 v2, a39
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:2048
		v_accvgpr_read_b32 v1, a40
		v_accvgpr_read_b32 v2, a41
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a42
		v_accvgpr_read_b32 v2, a43
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:2560
		v_accvgpr_read_b32 v1, a44
		v_accvgpr_read_b32 v2, a45
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a46
		v_accvgpr_read_b32 v2, a47
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:3072
		v_accvgpr_read_b32 v1, a48
		v_accvgpr_read_b32 v2, a49
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a50
		v_accvgpr_read_b32 v2, a51
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a52
		v_accvgpr_read_b32 v2, a53
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a54
		v_accvgpr_read_b32 v2, a55
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x3000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen
		v_accvgpr_read_b32 v1, a56
		v_accvgpr_read_b32 v2, a57
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a58
		v_accvgpr_read_b32 v2, a59
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:512
		v_accvgpr_read_b32 v1, a60
		v_accvgpr_read_b32 v2, a61
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a62
		v_accvgpr_read_b32 v2, a63
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:1024
		v_accvgpr_read_b32 v1, a64
		v_accvgpr_read_b32 v2, a65
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a66
		v_accvgpr_read_b32 v2, a67
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:1536
		v_accvgpr_read_b32 v1, a68
		v_accvgpr_read_b32 v2, a69
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a70
		v_accvgpr_read_b32 v2, a71
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:2048
		v_accvgpr_read_b32 v1, a72
		v_accvgpr_read_b32 v2, a73
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a74
		v_accvgpr_read_b32 v2, a75
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:2560
		v_accvgpr_read_b32 v1, a76
		v_accvgpr_read_b32 v2, a77
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a78
		v_accvgpr_read_b32 v2, a79
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:3072
		v_accvgpr_read_b32 v1, a80
		v_accvgpr_read_b32 v2, a81
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a82
		v_accvgpr_read_b32 v2, a83
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a84
		v_accvgpr_read_b32 v2, a85
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a86
		v_accvgpr_read_b32 v2, a87
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x4000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen
		v_accvgpr_read_b32 v1, a88
		v_accvgpr_read_b32 v2, a89
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a90
		v_accvgpr_read_b32 v2, a91
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:512
		v_accvgpr_read_b32 v1, a92
		v_accvgpr_read_b32 v2, a93
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a94
		v_accvgpr_read_b32 v2, a95
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:1024
		v_accvgpr_read_b32 v1, a96
		v_accvgpr_read_b32 v2, a97
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a98
		v_accvgpr_read_b32 v2, a99
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:1536
		v_accvgpr_read_b32 v1, a100
		v_accvgpr_read_b32 v2, a101
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a102
		v_accvgpr_read_b32 v2, a103
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:2048
		v_accvgpr_read_b32 v1, a104
		v_accvgpr_read_b32 v2, a105
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a106
		v_accvgpr_read_b32 v2, a107
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:2560
		v_accvgpr_read_b32 v1, a108
		v_accvgpr_read_b32 v2, a109
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a110
		v_accvgpr_read_b32 v2, a111
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:3072
		v_accvgpr_read_b32 v1, a112
		v_accvgpr_read_b32 v2, a113
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a114
		v_accvgpr_read_b32 v2, a115
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a116
		v_accvgpr_read_b32 v2, a117
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a118
		v_accvgpr_read_b32 v2, a119
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x5000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen
		v_accvgpr_read_b32 v1, a120
		v_accvgpr_read_b32 v2, a121
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a122
		v_accvgpr_read_b32 v2, a123
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:512
		v_accvgpr_read_b32 v1, a124
		v_accvgpr_read_b32 v2, a125
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a126
		v_accvgpr_read_b32 v2, a127
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:1024
		v_accvgpr_read_b32 v1, a128
		v_accvgpr_read_b32 v2, a129
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a130
		v_accvgpr_read_b32 v2, a131
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:1536
		v_accvgpr_read_b32 v1, a132
		v_accvgpr_read_b32 v2, a133
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a134
		v_accvgpr_read_b32 v2, a135
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:2048
		v_accvgpr_read_b32 v1, a136
		v_accvgpr_read_b32 v2, a137
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a138
		v_accvgpr_read_b32 v2, a139
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:2560
		v_accvgpr_read_b32 v1, a140
		v_accvgpr_read_b32 v2, a141
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a142
		v_accvgpr_read_b32 v2, a143
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:3072
		v_accvgpr_read_b32 v1, a144
		v_accvgpr_read_b32 v2, a145
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a146
		v_accvgpr_read_b32 v2, a147
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a148
		v_accvgpr_read_b32 v2, a149
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a150
		v_accvgpr_read_b32 v2, a151
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s2, s0, 0x6000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen
		v_accvgpr_read_b32 v1, a152
		v_accvgpr_read_b32 v2, a153
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a154
		v_accvgpr_read_b32 v2, a155
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:512
		v_accvgpr_read_b32 v1, a156
		v_accvgpr_read_b32 v2, a157
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a158
		v_accvgpr_read_b32 v2, a159
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:1024
		v_accvgpr_read_b32 v1, a160
		v_accvgpr_read_b32 v2, a161
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a162
		v_accvgpr_read_b32 v2, a163
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:1536
		v_accvgpr_read_b32 v1, a164
		v_accvgpr_read_b32 v2, a165
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a166
		v_accvgpr_read_b32 v2, a167
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:2048
		v_accvgpr_read_b32 v1, a168
		v_accvgpr_read_b32 v2, a169
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a170
		v_accvgpr_read_b32 v2, a171
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:2560
		v_accvgpr_read_b32 v1, a172
		v_accvgpr_read_b32 v2, a173
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a174
		v_accvgpr_read_b32 v2, a175
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:3072
		v_accvgpr_read_b32 v1, a176
		v_accvgpr_read_b32 v2, a177
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a178
		v_accvgpr_read_b32 v2, a179
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s2 offen offset:3584
		v_accvgpr_read_b32 v1, a180
		v_accvgpr_read_b32 v2, a181
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a182
		v_accvgpr_read_b32 v2, a183
		v_cvt_pk_f16_f32 v5, v1, v2
		s_add_i32 s0, s0, 0x7000
		s_add_i32 s0, s0, s1
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s0 offen
		v_accvgpr_read_b32 v1, a184
		v_accvgpr_read_b32 v2, a185
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a186
		v_accvgpr_read_b32 v2, a187
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s0 offen offset:512
		v_accvgpr_read_b32 v1, a188
		v_accvgpr_read_b32 v2, a189
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a190
		v_accvgpr_read_b32 v2, a191
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s0 offen offset:1024
		v_accvgpr_read_b32 v1, a192
		v_accvgpr_read_b32 v2, a193
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a194
		v_accvgpr_read_b32 v2, a195
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s0 offen offset:1536
		v_accvgpr_read_b32 v1, a196
		v_accvgpr_read_b32 v2, a197
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a198
		v_accvgpr_read_b32 v2, a199
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s0 offen offset:2048
		v_accvgpr_read_b32 v1, a200
		v_accvgpr_read_b32 v2, a201
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a202
		v_accvgpr_read_b32 v2, a203
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s0 offen offset:2560
		v_accvgpr_read_b32 v1, a204
		v_accvgpr_read_b32 v2, a205
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a206
		v_accvgpr_read_b32 v2, a207
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s0 offen offset:3072
		v_accvgpr_read_b32 v1, a208
		v_accvgpr_read_b32 v2, a209
		v_cvt_pk_f16_f32 v4, v1, v2
		v_accvgpr_read_b32 v1, a210
		v_accvgpr_read_b32 v2, a211
		v_cvt_pk_f16_f32 v5, v1, v2
		buffer_store_dwordx2 v[4:5], v0, s[20:23], s0 offen offset:3584
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 16
		.amdhsa_private_segment_fixed_size 296
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
		.amdhsa_next_free_sgpr 70
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
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 70
	.set .Lwmma_f16_matmul_tiled.num_named_barrier, 0
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 296
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
    .group_segment_fixed_size: 16
    .kernarg_segment_align: 8
    .kernarg_segment_size: 48
    .max_flat_workgroup_size: 256
    .name:           wmma_f16_matmul_tiled
    .private_segment_fixed_size: 296
    .sgpr_count:     70
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     512
    .agpr_count:     256
    .vgpr_spill_count: 74
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 118
    wave.regalloc.agpr.dwords: 300
    wave.regalloc.remat.dwords: 22
    wave.regalloc.sgpr_to_vgpr.dwords: 0
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 74
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
