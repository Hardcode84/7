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
		scratch_store_dword off, v4, s8 offset:412
		scratch_store_dword off, v5, s8 offset:416
		scratch_store_dword off, v6, s8 offset:420
		scratch_store_dword off, v7, s8 offset:424
		v_readfirstlane_b32 s8, v0
		s_lshl_b32 s9, s13, 20
		v_lshrrev_b32_e32 v1, 6, v0
		v_accvgpr_write_b32 a0, v1
		v_accvgpr_read_b32 v1, a0
		v_lshlrev_b32_e32 v2, 2, v0
		ds_write_b32 v2, v1 offset:22528
		v_lshlrev_b32_e32 v1, 2, v0
		s_waitcnt lgkmcnt(0)
		ds_read_b32 v2, v1 offset:22528
		s_waitcnt lgkmcnt(0)
		v_lshlrev_b32_e32 v1, 16, v2
		v_add_u32_e32 v2, s9, v1
		v_and_b32_e32 v3, 63, v0
		v_lshrrev_b32_e32 v4, 2, v3
		v_lshlrev_b32_e32 v3, 12, v4
		v_and_b32_e32 v4, 63, v0
		v_lshrrev_b32_e32 v5, 3, v4
		v_and_b32_e32 v4, 3, v5
		v_and_b32_e32 v5, 63, v0
		v_and_b32_e32 v6, 3, v5
		v_xor_b32_e32 v5, v4, v6
		v_lshlrev_b32_e32 v4, 4, v5
		v_add3_u32 v5, v2, v3, v4
		s_add_i32 s10, s9, 0x80000
		v_add_u32_e32 v2, s10, v1
		v_add3_u32 v6, v2, v3, v4
		v_add3_u32 v2, s9, 64, v1
		v_add3_u32 v7, v2, v3, v4
		s_add_i32 s10, s9, 0x80040
		v_add_u32_e32 v2, s10, v1
		v_add3_u32 v8, v2, v3, v4
		s_lshl_b32 s10, s14, 20
		v_add_u32_e32 v2, s10, v1
		v_add3_u32 v9, v2, v3, v4
		s_add_i32 s11, s10, 0x80000
		v_add_u32_e32 v2, s11, v1
		v_add3_u32 v10, v2, v3, v4
		v_add3_u32 v2, s10, 64, v1
		v_add3_u32 v11, v2, v3, v4
		s_add_i32 s11, s10, 0x80040
		v_add_u32_e32 v2, s11, v1
		v_add3_u32 v12, v2, v3, v4
		s_lshr_b32 s11, s8, 6
		s_lshl_b32 s15, s11, 10
		s_mov_b32 m0, s15
		s_nop 0
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		s_add_i32 s28, s15, 0x2000
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v6, s[20:23], 0 offen lds
		s_add_i32 s29, s15, 0x4000
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		s_add_i32 s30, s15, 0x6000
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		s_add_i32 s31, s15, 0x8000
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v9, s[0:3], 0 offen lds
		s_add_i32 s32, s15, 0xa000
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		s_add_i32 s33, s15, 0xc000
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v11, s[0:3], 0 offen lds
		s_add_i32 s34, s15, 0xe000
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v12, s[0:3], 0 offen lds
		s_lshl_b32 s35, s14, 16
		s_add_i32 s36, s9, s35
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v5, 9, v2
		v_and_b32_e32 v6, 63, v0
		v_lshlrev_b32_e32 v7, 2, v6
		v_add3_u32 v6, s36, v5, v7
		s_add_i32 s37, s9, 0x100
		s_add_i32 s38, s37, s35
		v_add3_u32 v8, s38, v5, v7
		v_and_b32_e32 v9, 63, v0
		v_lshlrev_b32_e32 v10, 4, v9
		v_lshlrev_b32_e32 v9, 2, v0
		ds_read_b32 v11, v9 offset:22528
		s_waitcnt lgkmcnt(0)
		v_and_b32_e32 v9, 1, v11
		v_lshlrev_b32_e32 v11, 10, v9
		v_add3_u32 v12, s36, v10, v11
		s_lshr_b32 s36, s8, 7
		s_lshl_b32 s8, s36, 9
		s_add_i32 m0, s8, 0x20000
		s_nop 0
		buffer_load_dword v6, s[4:7], 0 offen lds
		s_add_i32 m0, s8, 0x20100
		s_nop 0
		buffer_load_dword v8, s[4:7], 0 offen lds
		s_and_b32 s36, s11, 1
		s_lshl_b32 s11, s36, 10
		s_add_i32 m0, s11, 0x20800
		s_nop 0
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v6, 12, v2
		v_and_b32_e32 v2, 15, v0
		v_lshlrev_b32_e32 v8, 6, v2
		v_and_b32_e32 v12, 63, v0
		v_lshrrev_b32_e32 v13, 4, v12
		v_lshrrev_b32_e32 v12, 1, v2
		v_and_b32_e32 v2, 3, v12
		v_xor_b32_e32 v12, v13, v2
		v_lshlrev_b32_e32 v2, 4, v12
		v_add3_u32 v12, v6, v8, v2
		ds_read_b128 v[16:19], v12
		ds_read_b128 v[20:23], v12 offset:1024
		ds_read_b128 v[24:27], v12 offset:2048
		ds_read_b128 v[28:31], v12 offset:3072
		v_lshlrev_b32_e32 v12, 13, v9
		v_add3_u32 v9, v8, v12, v2
		ds_read_b128 v[32:35], v9 offset:32768
		ds_read_b128 v[36:39], v9 offset:33792
		ds_read_b128 v[40:43], v9 offset:34816
		ds_read_b128 v[44:47], v9 offset:35840
		ds_read_b128 v[48:51], v9 offset:36864
		ds_read_b128 v[52:55], v9 offset:37888
		ds_read_b128 v[56:59], v9 offset:38912
		ds_read_b128 v[60:63], v9 offset:39936
		v_add_u32_e32 v9, 0x20000, v5
		v_add_u32_e32 v13, v9, v7
		ds_read_b32 v9, v13
		ds_read_b32 v14, v13 offset:256
		v_add_u32_e32 v13, 0x20000, v7
		v_add_u32_e32 v15, v13, v11
		ds_read_b32 v13, v15 offset:2048
		ds_read_b32 v64, v15 offset:2304
		ds_read_b32 v65, v15 offset:2560
		ds_read_b32 v66, v15 offset:2816
		s_waitcnt lgkmcnt(0)
		s_add_i32 s36, s9, 0x80
		v_add_u32_e32 v15, s36, v1
		v_add3_u32 v67, v15, v3, v4
		s_add_i32 s36, s9, 0x80080
		v_add_u32_e32 v15, s36, v1
		v_add3_u32 v68, v15, v3, v4
		s_add_i32 s36, s9, 0xc0
		v_add_u32_e32 v15, s36, v1
		v_add3_u32 v69, v15, v3, v4
		s_add_i32 s36, s9, 0x800c0
		v_add_u32_e32 v15, s36, v1
		v_add3_u32 v70, v15, v3, v4
		s_add_i32 s36, s10, 0x80
		v_add_u32_e32 v15, s36, v1
		v_add3_u32 v71, v15, v3, v4
		s_add_i32 s36, s10, 0x80080
		v_add_u32_e32 v15, s36, v1
		v_add3_u32 v72, v15, v3, v4
		s_add_i32 s36, s10, 0xc0
		v_add_u32_e32 v15, s36, v1
		v_add3_u32 v73, v15, v3, v4
		s_add_i32 s36, s10, 0x800c0
		v_add_u32_e32 v15, s36, v1
		v_add3_u32 v1, v15, v3, v4
		s_add_i32 s10, s15, 0x10000
		s_mov_b32 m0, s10
		s_nop 0
		buffer_load_dwordx4 v67, s[20:23], 0 offen lds
		s_add_i32 s36, s15, 0x12000
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v68, s[20:23], 0 offen lds
		s_add_i32 s37, s15, 0x14000
		s_mov_b32 m0, s37
		s_nop 0
		buffer_load_dwordx4 v69, s[20:23], 0 offen lds
		s_add_i32 s38, s15, 0x16000
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v70, s[20:23], 0 offen lds
		s_add_i32 s39, s15, 0x18000
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v71, s[0:3], 0 offen lds
		s_add_i32 s40, s15, 0x1a000
		s_mov_b32 m0, s40
		s_nop 0
		buffer_load_dwordx4 v72, s[0:3], 0 offen lds
		s_add_i32 s41, s15, 0x1c000
		s_mov_b32 m0, s41
		s_nop 0
		buffer_load_dwordx4 v73, s[0:3], 0 offen lds
		s_add_i32 s42, s15, 0x1e000
		s_mov_b32 m0, s42
		s_nop 0
		buffer_load_dwordx4 v1, s[0:3], 0 offen lds
		s_add_i32 s43, s9, 0x800
		s_add_i32 s44, s43, s35
		v_add3_u32 v1, s44, v5, v7
		s_add_i32 s43, s9, 0x900
		s_add_i32 s9, s43, s35
		v_add3_u32 v3, s9, v5, v7
		v_add3_u32 v4, s44, v10, v11
		s_add_i32 m0, s8, 0x21000
		s_nop 0
		buffer_load_dword v1, s[4:7], 0 offen lds
		s_add_i32 m0, s8, 0x21100
		s_nop 0
		buffer_load_dword v3, s[4:7], 0 offen lds
		s_add_i32 m0, s11, 0x21800
		s_nop 0
		buffer_load_dwordx4 v4, s[24:27], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s9, s12, 1
		v_mov_b32_e32 v1, s9
		s_add_i32 s9, s8, 0x100
		s_add_i32 s35, s11, 0x800
		s_add_i32 s43, s8, 0x1000
		s_add_i32 s44, s8, 0x1100
		s_add_i32 s45, s11, 0x1800
		s_mov_b32 s11, 2
		v_mov_b32_e32 v68, s13
		v_mov_b32_e32 v69, 0
		s_mov_b32 s46, 0x100000
		s_mov_b32 s47, 0
		v_mov_b32_e32 v70, s46
		v_mov_b32_e32 v71, s47
		v_mul_lo_u32 v72, v70, v68
		v_mul_hi_u32 v73, v70, v68
		v_mul_lo_u32 v3, v70, v69
		v_add_u32_e32 v73, v73, v3
		v_mul_lo_u32 v3, v71, v68
		v_add_u32_e32 v73, v73, v3
		s_mov_b32 s46, 1
		s_mov_b32 s47, 0
		v_mov_b32_e32 v74, v0
		v_mov_b32_e32 v75, 0
		v_mov_b32_e32 v76, s46
		v_mov_b32_e32 v77, s47
		v_mul_lo_u32 v78, v76, v74
		v_mul_hi_u32 v79, v76, v74
		v_mul_lo_u32 v3, v76, v75
		v_add_u32_e32 v79, v79, v3
		v_mul_lo_u32 v3, v77, v74
		v_add_u32_e32 v79, v79, v3
		v_lshrrev_b64 v[80:81], 6, v[78:79]
		s_mov_b32 s46, 0x10000
		s_mov_b32 s47, 0
		v_mov_b32_e32 v82, s46
		v_mov_b32_e32 v83, s47
		v_mul_lo_u32 v84, v82, v80
		v_mul_hi_u32 v85, v82, v80
		v_mul_lo_u32 v3, v82, v81
		v_add_u32_e32 v85, v85, v3
		v_mul_lo_u32 v3, v83, v80
		v_add_u32_e32 v85, v85, v3
		v_add_co_u32_e64 v86, vcc, v72, v84
		v_addc_co_u32_e64 v87, vcc, v73, v85, vcc
		v_mov_b32_e32 v3, 63
		v_and_b32_e32 v88, v74, v3
		v_and_b32_e32 v89, v69, v69
		v_mul_lo_u32 v74, v76, v88
		v_mul_hi_u32 v75, v76, v88
		v_mul_lo_u32 v3, v76, v89
		v_add_u32_e32 v75, v75, v3
		v_mul_lo_u32 v3, v77, v88
		v_add_u32_e32 v75, v75, v3
		v_lshrrev_b64 v[76:77], 2, v[74:75]
		s_mov_b32 s46, 0x1000
		s_mov_b32 s47, 0
		v_mov_b32_e32 v90, s46
		v_mov_b32_e32 v91, s47
		v_mul_lo_u32 v92, v90, v76
		v_mul_hi_u32 v93, v90, v76
		v_mul_lo_u32 v3, v90, v77
		v_add_u32_e32 v93, v93, v3
		v_mul_lo_u32 v3, v91, v76
		v_add_u32_e32 v93, v93, v3
		v_add_co_u32_e64 v76, vcc, v86, v92
		v_addc_co_u32_e64 v77, vcc, v87, v93, vcc
		v_lshrrev_b64 v[86:87], 3, v[74:75]
		v_mov_b32_e32 v3, 3
		v_and_b32_e32 v74, v86, v3
		v_and_b32_e32 v75, v87, v69
		v_and_b32_e32 v86, v88, v3
		v_and_b32_e32 v87, v89, v69
		v_xor_b32_e32 v90, v74, v86
		v_xor_b32_e32 v91, v75, v87
		s_mov_b32 s46, 16
		s_mov_b32 s47, 0
		v_mov_b32_e32 v74, s46
		v_mov_b32_e32 v75, s47
		v_mul_lo_u32 v86, v74, v90
		v_mul_hi_u32 v87, v74, v90
		v_mul_lo_u32 v3, v74, v91
		v_add_u32_e32 v87, v87, v3
		v_mul_lo_u32 v3, v75, v90
		v_add_u32_e32 v87, v87, v3
		v_add_co_u32_e64 v90, vcc, v76, v86
		v_addc_co_u32_e64 v91, vcc, v77, v87, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v90, s46
		scratch_store_dword off, v91, s46 offset:4
		s_mov_b32 s46, 0x80
		s_mov_b32 s47, 0
		v_mov_b32_e32 v76, s46
		v_mov_b32_e32 v77, s47
		v_mov_b32_e32 v3, 0x80000
		v_add_co_u32_e64 v90, vcc, v72, v3
		v_addc_co_u32_e64 v91, vcc, v73, 0, vcc
		v_add_co_u32_e64 v94, vcc, v90, v84
		v_addc_co_u32_e64 v95, vcc, v91, v85, vcc
		v_add_co_u32_e64 v90, vcc, v94, v92
		v_addc_co_u32_e64 v91, vcc, v95, v93, vcc
		v_add_co_u32_e64 v94, vcc, v90, v86
		v_addc_co_u32_e64 v95, vcc, v91, v87, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v94, s46 offset:8
		scratch_store_dword off, v95, s46 offset:12
		v_mov_b32_e32 v4, 64
		v_add_co_u32_e64 v90, vcc, v72, v4
		v_addc_co_u32_e64 v91, vcc, v73, 0, vcc
		v_add_co_u32_e64 v94, vcc, v90, v84
		v_addc_co_u32_e64 v95, vcc, v91, v85, vcc
		v_add_co_u32_e64 v90, vcc, v94, v92
		v_addc_co_u32_e64 v91, vcc, v95, v93, vcc
		v_add_co_u32_e64 v94, vcc, v90, v86
		v_addc_co_u32_e64 v95, vcc, v91, v87, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v94, s46 offset:16
		scratch_store_dword off, v95, s46 offset:20
		v_mov_b32_e32 v10, 0x80040
		v_add_co_u32_e64 v90, vcc, v72, v10
		v_addc_co_u32_e64 v91, vcc, v73, 0, vcc
		v_add_co_u32_e64 v94, vcc, v90, v84
		v_addc_co_u32_e64 v95, vcc, v91, v85, vcc
		v_add_co_u32_e64 v90, vcc, v94, v92
		v_addc_co_u32_e64 v91, vcc, v95, v93, vcc
		v_add_co_u32_e64 v94, vcc, v90, v86
		v_addc_co_u32_e64 v95, vcc, v91, v87, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v94, s46 offset:24
		scratch_store_dword off, v95, s46 offset:28
		v_mov_b32_e32 v90, s14
		v_mov_b32_e32 v91, 0
		v_mul_lo_u32 v94, v70, v90
		v_mul_hi_u32 v95, v70, v90
		v_mul_lo_u32 v15, v70, v91
		v_add_u32_e32 v95, v95, v15
		v_mul_lo_u32 v15, v71, v90
		v_add_u32_e32 v95, v95, v15
		v_add_co_u32_e64 v70, vcc, v94, v84
		v_addc_co_u32_e64 v71, vcc, v95, v85, vcc
		v_add_co_u32_e64 v96, vcc, v70, v92
		v_addc_co_u32_e64 v97, vcc, v71, v93, vcc
		v_add_co_u32_e64 v70, vcc, v96, v86
		v_addc_co_u32_e64 v71, vcc, v97, v87, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v70, s46 offset:32
		scratch_store_dword off, v71, s46 offset:36
		v_add_co_u32_e64 v70, vcc, v94, v3
		v_addc_co_u32_e64 v71, vcc, v95, 0, vcc
		v_add_co_u32_e64 v96, vcc, v70, v84
		v_addc_co_u32_e64 v97, vcc, v71, v85, vcc
		v_add_co_u32_e64 v70, vcc, v96, v92
		v_addc_co_u32_e64 v71, vcc, v97, v93, vcc
		v_add_co_u32_e64 v96, vcc, v70, v86
		v_addc_co_u32_e64 v97, vcc, v71, v87, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v96, s46 offset:40
		scratch_store_dword off, v97, s46 offset:44
		v_add_co_u32_e64 v70, vcc, v94, v4
		v_addc_co_u32_e64 v71, vcc, v95, 0, vcc
		v_add_co_u32_e64 v96, vcc, v70, v84
		v_addc_co_u32_e64 v97, vcc, v71, v85, vcc
		v_add_co_u32_e64 v70, vcc, v96, v92
		v_addc_co_u32_e64 v71, vcc, v97, v93, vcc
		v_add_co_u32_e64 v96, vcc, v70, v86
		v_addc_co_u32_e64 v97, vcc, v71, v87, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v96, s46 offset:48
		scratch_store_dword off, v97, s46 offset:52
		v_add_co_u32_e64 v70, vcc, v94, v10
		v_addc_co_u32_e64 v71, vcc, v95, 0, vcc
		v_add_co_u32_e64 v94, vcc, v70, v84
		v_addc_co_u32_e64 v95, vcc, v71, v85, vcc
		v_add_co_u32_e64 v70, vcc, v94, v92
		v_addc_co_u32_e64 v71, vcc, v95, v93, vcc
		v_add_co_u32_e64 v84, vcc, v70, v86
		v_addc_co_u32_e64 v85, vcc, v71, v87, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v84, s46 offset:56
		scratch_store_dword off, v85, s46 offset:60
		v_mul_lo_u32 v70, v82, v90
		v_mul_hi_u32 v71, v82, v90
		v_mul_lo_u32 v3, v82, v91
		v_add_u32_e32 v71, v71, v3
		v_mul_lo_u32 v3, v83, v90
		v_add_u32_e32 v71, v71, v3
		v_add_co_u32_e64 v82, vcc, v72, v70
		v_addc_co_u32_e64 v83, vcc, v73, v71, vcc
		v_lshrrev_b64 v[84:85], 7, v[78:79]
		s_mov_b32 s46, 0x200
		s_mov_b32 s47, 0
		v_mov_b32_e32 v78, s46
		v_mov_b32_e32 v79, s47
		v_mul_lo_u32 v86, v78, v84
		v_mul_hi_u32 v87, v78, v84
		v_mul_lo_u32 v3, v78, v85
		v_add_u32_e32 v87, v87, v3
		v_mul_lo_u32 v3, v79, v84
		v_add_u32_e32 v87, v87, v3
		v_add_co_u32_e64 v78, vcc, v82, v86
		v_addc_co_u32_e64 v79, vcc, v83, v87, vcc
		s_mov_b32 s46, 4
		s_mov_b32 s47, 0
		v_mov_b32_e32 v84, s46
		v_mov_b32_e32 v85, s47
		v_mul_lo_u32 v90, v84, v88
		v_mul_hi_u32 v91, v84, v88
		v_mul_lo_u32 v3, v84, v89
		v_add_u32_e32 v91, v91, v3
		v_mul_lo_u32 v3, v85, v88
		v_add_u32_e32 v91, v91, v3
		v_add_co_u32_e64 v84, vcc, v78, v90
		v_addc_co_u32_e64 v85, vcc, v79, v91, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v84, s46 offset:80
		scratch_store_dword off, v85, s46 offset:84
		s_mov_b32 s46, 0x800
		s_mov_b32 s47, 0
		v_mov_b32_e32 v78, s46
		v_mov_b32_e32 v79, s47
		v_mov_b32_e32 v3, 0x100
		v_add_co_u32_e64 v84, vcc, v72, v3
		v_addc_co_u32_e64 v85, vcc, v73, 0, vcc
		v_add_co_u32_e64 v72, vcc, v84, v70
		v_addc_co_u32_e64 v73, vcc, v85, v71, vcc
		v_add_co_u32_e64 v70, vcc, v72, v86
		v_addc_co_u32_e64 v71, vcc, v73, v87, vcc
		v_add_co_u32_e64 v72, vcc, v70, v90
		v_addc_co_u32_e64 v73, vcc, v71, v91, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v72, s46 offset:88
		scratch_store_dword off, v73, s46 offset:92
		v_mul_lo_u32 v70, v74, v88
		v_mul_hi_u32 v71, v74, v88
		v_mul_lo_u32 v3, v74, v89
		v_add_u32_e32 v71, v71, v3
		v_mul_lo_u32 v3, v75, v88
		v_add_u32_e32 v71, v71, v3
		v_add_co_u32_e64 v72, vcc, v82, v70
		v_addc_co_u32_e64 v73, vcc, v83, v71, vcc
		v_mov_b32_e32 v3, 1
		v_and_b32_e32 v70, v80, v3
		v_and_b32_e32 v71, v81, v69
		s_mov_b32 s46, 0x400
		s_mov_b32 s47, 0
		v_mov_b32_e32 v68, s46
		v_mov_b32_e32 v69, s47
		v_mul_lo_u32 v74, v68, v70
		v_mul_hi_u32 v75, v68, v70
		v_mul_lo_u32 v3, v68, v71
		v_add_u32_e32 v75, v75, v3
		v_mul_lo_u32 v3, v69, v70
		v_add_u32_e32 v75, v75, v3
		v_add_co_u32_e64 v68, vcc, v72, v74
		v_addc_co_u32_e64 v69, vcc, v73, v75, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v68, s46 offset:96
		scratch_store_dword off, v69, s46 offset:100
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		s_mov_b32 s46, 0
		scratch_store_dword off, v68, s46 offset:364
		scratch_store_dword off, v69, s46 offset:368
		scratch_store_dword off, v70, s46 offset:372
		scratch_store_dword off, v71, s46 offset:376
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		s_mov_b32 s46, 0
		scratch_store_dword off, v68, s46 offset:316
		scratch_store_dword off, v69, s46 offset:320
		scratch_store_dword off, v70, s46 offset:324
		scratch_store_dword off, v71, s46 offset:328
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		s_mov_b32 s46, 0
		scratch_store_dword off, v68, s46 offset:284
		scratch_store_dword off, v69, s46 offset:288
		scratch_store_dword off, v70, s46 offset:292
		scratch_store_dword off, v71, s46 offset:296
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		s_mov_b32 s46, 0
		scratch_store_dword off, v68, s46 offset:252
		scratch_store_dword off, v69, s46 offset:256
		scratch_store_dword off, v70, s46 offset:260
		scratch_store_dword off, v71, s46 offset:264
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		s_mov_b32 s46, 0
		scratch_store_dword off, v68, s46 offset:220
		scratch_store_dword off, v69, s46 offset:224
		scratch_store_dword off, v70, s46 offset:228
		scratch_store_dword off, v71, s46 offset:232
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		s_mov_b32 s46, 0
		scratch_store_dword off, v68, s46 offset:144
		scratch_store_dword off, v69, s46 offset:148
		scratch_store_dword off, v70, s46 offset:152
		scratch_store_dword off, v71, s46 offset:156
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		s_mov_b32 s46, 0
		scratch_store_dword off, v68, s46 offset:104
		scratch_store_dword off, v69, s46 offset:108
		scratch_store_dword off, v70, s46 offset:112
		scratch_store_dword off, v71, s46 offset:116
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_accvgpr_write_b32 a0, v68
		v_accvgpr_write_b32 a1, v69
		v_accvgpr_write_b32 a2, v70
		v_accvgpr_write_b32 a3, v71
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_accvgpr_write_b32 a4, v68
		v_accvgpr_write_b32 a5, v69
		v_accvgpr_write_b32 a6, v70
		v_accvgpr_write_b32 a7, v71
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_accvgpr_write_b32 a8, v68
		v_accvgpr_write_b32 a9, v69
		v_accvgpr_write_b32 a10, v70
		v_accvgpr_write_b32 a11, v71
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_accvgpr_write_b32 a12, v68
		v_accvgpr_write_b32 a13, v69
		v_accvgpr_write_b32 a14, v70
		v_accvgpr_write_b32 a15, v71
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_accvgpr_write_b32 a16, v68
		v_accvgpr_write_b32 a17, v69
		v_accvgpr_write_b32 a18, v70
		v_accvgpr_write_b32 a19, v71
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_accvgpr_write_b32 a20, v68
		v_accvgpr_write_b32 a21, v69
		v_accvgpr_write_b32 a22, v70
		v_accvgpr_write_b32 a23, v71
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_accvgpr_write_b32 a24, v68
		v_accvgpr_write_b32 a25, v69
		v_accvgpr_write_b32 a26, v70
		v_accvgpr_write_b32 a27, v71
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_accvgpr_write_b32 a28, v68
		v_accvgpr_write_b32 a29, v69
		v_accvgpr_write_b32 a30, v70
		v_accvgpr_write_b32 a31, v71
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_accvgpr_write_b32 a32, v68
		v_accvgpr_write_b32 a33, v69
		v_accvgpr_write_b32 a34, v70
		v_accvgpr_write_b32 a35, v71
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_accvgpr_write_b32 a36, v68
		v_accvgpr_write_b32 a37, v69
		v_accvgpr_write_b32 a38, v70
		v_accvgpr_write_b32 a39, v71
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_accvgpr_write_b32 a40, v68
		v_accvgpr_write_b32 a41, v69
		v_accvgpr_write_b32 a42, v70
		v_accvgpr_write_b32 a43, v71
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_accvgpr_write_b32 a44, v68
		v_accvgpr_write_b32 a45, v69
		v_accvgpr_write_b32 a46, v70
		v_accvgpr_write_b32 a47, v71
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_accvgpr_write_b32 a48, v68
		v_accvgpr_write_b32 a49, v69
		v_accvgpr_write_b32 a50, v70
		v_accvgpr_write_b32 a51, v71
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_accvgpr_write_b32 a52, v68
		v_accvgpr_write_b32 a53, v69
		v_accvgpr_write_b32 a54, v70
		v_accvgpr_write_b32 a55, v71
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_accvgpr_write_b32 a56, v68
		v_accvgpr_write_b32 a57, v69
		v_accvgpr_write_b32 a58, v70
		v_accvgpr_write_b32 a59, v71
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_accvgpr_write_b32 a60, v68
		v_accvgpr_write_b32 a61, v69
		v_accvgpr_write_b32 a62, v70
		v_accvgpr_write_b32 a63, v71
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_accvgpr_write_b32 a64, v68
		v_accvgpr_write_b32 a65, v69
		v_accvgpr_write_b32 a66, v70
		v_accvgpr_write_b32 a67, v71
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_accvgpr_write_b32 a68, v68
		v_accvgpr_write_b32 a69, v69
		v_accvgpr_write_b32 a70, v70
		v_accvgpr_write_b32 a71, v71
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_accvgpr_write_b32 a72, v68
		v_accvgpr_write_b32 a73, v69
		v_accvgpr_write_b32 a74, v70
		v_accvgpr_write_b32 a75, v71
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_accvgpr_write_b32 a76, v68
		v_accvgpr_write_b32 a77, v69
		v_accvgpr_write_b32 a78, v70
		v_accvgpr_write_b32 a79, v71
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_accvgpr_write_b32 a80, v68
		v_accvgpr_write_b32 a81, v69
		v_accvgpr_write_b32 a82, v70
		v_accvgpr_write_b32 a83, v71
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_accvgpr_write_b32 a84, v68
		v_accvgpr_write_b32 a85, v69
		v_accvgpr_write_b32 a86, v70
		v_accvgpr_write_b32 a87, v71
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_accvgpr_write_b32 a88, v68
		v_accvgpr_write_b32 a89, v69
		v_accvgpr_write_b32 a90, v70
		v_accvgpr_write_b32 a91, v71
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_accvgpr_write_b32 a92, v68
		v_accvgpr_write_b32 a93, v69
		v_accvgpr_write_b32 a94, v70
		v_accvgpr_write_b32 a95, v71
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_add_i32 s46, s11, -2
		s_add_i32 s47, s11, -1
		v_mov_b32_e32 v3, s47
		v_mov_b32_e32 v68, s11
		v_mov_b32_e32 v69, 0
		v_mul_lo_u32 v70, v76, v68
		v_mul_hi_u32 v71, v76, v68
		v_mul_lo_u32 v4, v76, v69
		v_add_u32_e32 v71, v71, v4
		v_mul_lo_u32 v4, v77, v68
		v_add_u32_e32 v71, v71, v4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(48)
		scratch_load_dword v72, off, s47
		scratch_load_dword v73, off, s47 offset:4
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v74, vcc, v72, v70
		v_addc_co_u32_e64 v75, vcc, v73, v71, vcc
		v_lshlrev_b32_e32 v4, 2, v0
		ds_write_b32 v4, v74 offset:20480
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(46)
		scratch_load_dword v72, off, s47 offset:8
		scratch_load_dword v73, off, s47 offset:12
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v74, vcc, v72, v70
		v_addc_co_u32_e64 v75, vcc, v73, v71, vcc
		v_lshlrev_b32_e32 v4, 2, v0
		ds_write_b32 v4, v74 offset:18432
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(44)
		scratch_load_dword v72, off, s47 offset:16
		scratch_load_dword v73, off, s47 offset:20
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v74, vcc, v72, v70
		v_addc_co_u32_e64 v75, vcc, v73, v71, vcc
		v_lshlrev_b32_e32 v4, 2, v0
		ds_write_b32 v4, v74 offset:16384
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(42)
		scratch_load_dword v72, off, s47 offset:24
		scratch_load_dword v73, off, s47 offset:28
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v74, vcc, v72, v70
		v_addc_co_u32_e64 v75, vcc, v73, v71, vcc
		v_lshlrev_b32_e32 v4, 2, v0
		ds_write_b32 v4, v74 offset:14336
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(40)
		scratch_load_dword v72, off, s47 offset:32
		scratch_load_dword v73, off, s47 offset:36
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v74, vcc, v72, v70
		v_addc_co_u32_e64 v75, vcc, v73, v71, vcc
		v_lshlrev_b32_e32 v4, 2, v0
		ds_write_b32 v4, v74 offset:12288
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(38)
		scratch_load_dword v72, off, s47 offset:40
		scratch_load_dword v73, off, s47 offset:44
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v74, vcc, v72, v70
		v_addc_co_u32_e64 v75, vcc, v73, v71, vcc
		v_lshlrev_b32_e32 v4, 2, v0
		ds_write_b32 v4, v74 offset:10240
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(36)
		scratch_load_dword v72, off, s47 offset:48
		scratch_load_dword v73, off, s47 offset:52
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v74, vcc, v72, v70
		v_addc_co_u32_e64 v75, vcc, v73, v71, vcc
		v_lshlrev_b32_e32 v4, 2, v0
		ds_write_b32 v4, v74 offset:8192
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(34)
		scratch_load_dword v72, off, s47 offset:56
		scratch_load_dword v73, off, s47 offset:60
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v74, vcc, v72, v70
		v_addc_co_u32_e64 v75, vcc, v73, v71, vcc
		v_lshlrev_b32_e32 v4, 2, v0
		ds_write_b32 v4, v74 offset:6144
		v_mul_lo_u32 v70, v78, v68
		v_mul_hi_u32 v71, v78, v68
		v_mul_lo_u32 v4, v78, v69
		v_add_u32_e32 v71, v71, v4
		v_mul_lo_u32 v4, v79, v68
		v_add_u32_e32 v71, v71, v4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(32)
		scratch_load_dword v68, off, s47 offset:80
		scratch_load_dword v69, off, s47 offset:84
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v72, vcc, v68, v70
		v_addc_co_u32_e64 v73, vcc, v69, v71, vcc
		v_lshlrev_b32_e32 v4, 2, v0
		ds_write_b32 v4, v72 offset:4096
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(30)
		scratch_load_dword v68, off, s47 offset:88
		scratch_load_dword v69, off, s47 offset:92
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v72, vcc, v68, v70
		v_addc_co_u32_e64 v73, vcc, v69, v71, vcc
		v_lshlrev_b32_e32 v4, 2, v0
		ds_write_b32 v4, v72 offset:2048
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(28)
		scratch_load_dword v68, off, s47 offset:96
		scratch_load_dword v69, off, s47 offset:100
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v72, vcc, v68, v70
		v_addc_co_u32_e64 v73, vcc, v69, v71, vcc
		v_lshlrev_b32_e32 v4, 2, v0
		ds_write_b32 v4, v72
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v68, off, s47 offset:412
		scratch_load_dword v69, off, s47 offset:416
		scratch_load_dword v70, off, s47 offset:420
		scratch_load_dword v71, off, s47 offset:424
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[16:19], v[32:35], v[68:71], v9, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s47, s46, 1
		s_lshl_b32 s46, s47, 16
		v_mov_b32_e32 v4, s46
		s_nop 0
		v_readfirstlane_b32 s46, v4
		s_nop 1
		v_add_u32_e32 v10, s46, v6
		v_add3_u32 v15, v10, v8, v2
		ds_read_b128 v[72:75], v15 offset:16384
		s_mov_b32 s46, 0
		scratch_load_dword v80, off, s46 offset:364
		scratch_load_dword v81, off, s46 offset:368
		scratch_load_dword v82, off, s46 offset:372
		scratch_load_dword v83, off, s46 offset:376
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[16:19], v[36:39], v[80:83], v9, v13 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[84:87], v15 offset:17408
		s_mov_b32 s46, 0
		scratch_load_dword v88, off, s46 offset:316
		scratch_load_dword v89, off, s46 offset:320
		scratch_load_dword v90, off, s46 offset:324
		scratch_load_dword v91, off, s46 offset:328
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[16:19], v[40:43], v[88:91], v9, v64 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v15 offset:18432
		s_mov_b32 s46, 0
		scratch_load_dword v96, off, s46 offset:284
		scratch_load_dword v97, off, s46 offset:288
		scratch_load_dword v98, off, s46 offset:292
		scratch_load_dword v99, off, s46 offset:296
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[16:19], v[44:47], v[96:99], v9, v64 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v15 offset:19456
		s_mov_b32 s46, 0
		scratch_load_dword v104, off, s46 offset:252
		scratch_load_dword v105, off, s46 offset:256
		scratch_load_dword v106, off, s46 offset:260
		scratch_load_dword v107, off, s46 offset:264
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[16:19], v[48:51], v[104:107], v9, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_readfirstlane_b32 s46, v4
		s_nop 1
		v_add_u32_e32 v4, s46, v8
		v_add3_u32 v10, v4, v12, v2
		ds_read_b128 v[108:111], v10 offset:49152
		s_mov_b32 s46, 0
		scratch_load_dword v112, off, s46 offset:220
		scratch_load_dword v113, off, s46 offset:224
		scratch_load_dword v114, off, s46 offset:228
		scratch_load_dword v115, off, s46 offset:232
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[16:19], v[52:55], v[112:115], v9, v65 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[116:119], v10 offset:50176
		s_mov_b32 s46, 0
		scratch_load_dword v120, off, s46 offset:144
		scratch_load_dword v121, off, s46 offset:148
		scratch_load_dword v122, off, s46 offset:152
		scratch_load_dword v123, off, s46 offset:156
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[16:19], v[56:59], v[120:123], v9, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[124:127], v10 offset:51200
		s_mov_b32 s46, 0
		scratch_load_dword v128, off, s46 offset:104
		scratch_load_dword v129, off, s46 offset:108
		scratch_load_dword v130, off, s46 offset:112
		scratch_load_dword v131, off, s46 offset:116
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[60:63], v[128:131], v9, v66 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[132:135], v10 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[20:23], v[32:35], a[0:3], v9, v13 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[136:139], v10 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[20:23], v[36:39], a[4:7], v9, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[140:143], v10 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[20:23], v[40:43], a[8:11], v9, v64 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[144:147], v10 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[20:23], v[44:47], a[12:15], v9, v64 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[148:151], v10 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[20:23], v[48:51], a[16:19], v9, v65 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		v_lshlrev_b32_e32 v4, 2, v0
		s_waitcnt lgkmcnt(6)
		ds_read_b32 v10, v4 offset:20480
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[20:23], v[52:55], a[20:23], v9, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s28
		v_lshlrev_b32_e32 v4, 2, v0
		ds_read_b32 v10, v4 offset:18432
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[20:23], v[56:59], a[24:27], v9, v66 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s29
		v_lshlrev_b32_e32 v4, 2, v0
		ds_read_b32 v10, v4 offset:16384
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[20:23], v[60:63], a[28:31], v9, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s30
		v_lshlrev_b32_e32 v4, 2, v0
		ds_read_b32 v10, v4 offset:14336
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[24:27], v[32:35], a[32:35], v14, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s31
		v_lshlrev_b32_e32 v4, 2, v0
		ds_read_b32 v10, v4 offset:12288
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[24:27], v[36:39], a[36:39], v14, v13 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s32
		v_lshlrev_b32_e32 v4, 2, v0
		ds_read_b32 v10, v4 offset:10240
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[24:27], v[40:43], a[40:43], v14, v64 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s33
		v_lshlrev_b32_e32 v4, 2, v0
		ds_read_b32 v10, v4 offset:8192
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[24:27], v[44:47], a[44:47], v14, v64 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s34
		v_lshlrev_b32_e32 v4, 2, v0
		ds_read_b32 v10, v4 offset:6144
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[24:27], v[48:51], a[48:51], v14, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s8, 0x20000
		v_lshlrev_b32_e32 v4, 2, v0
		ds_read_b32 v10, v4 offset:4096
		s_waitcnt lgkmcnt(0)
		buffer_load_dword v10, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[24:27], v[52:55], a[52:55], v14, v65 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s9, 0x20000
		v_lshlrev_b32_e32 v4, 2, v0
		ds_read_b32 v10, v4 offset:2048
		s_waitcnt lgkmcnt(0)
		buffer_load_dword v10, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[24:27], v[56:59], a[56:59], v14, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s35, 0x20000
		v_lshlrev_b32_e32 v4, 2, v0
		ds_read_b32 v10, v4
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[24:27], v[60:63], a[60:63], v14, v66 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		s_and_b32 s46, s11, 1
		s_lshl_b32 s47, s46, 16
		v_add_u32_e32 v4, s47, v6
		v_add3_u32 v10, v4, v8, v2
		ds_read_b128 v[16:19], v10
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[28:31], v[32:35], a[64:67], v14, v13 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v10 offset:1024
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[28:31], v[36:39], a[68:71], v14, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v10 offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[28:31], v[40:43], a[72:75], v14, v64 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[152:155], v10 offset:3072
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v152, s48 offset:64
		scratch_store_dword off, v153, s48 offset:68
		scratch_store_dword off, v154, s48 offset:72
		scratch_store_dword off, v155, s48 offset:76
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[28:31], v[44:47], a[76:79], v14, v64 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v4, s47, v8
		v_add3_u32 v10, v4, v12, v2
		ds_read_b128 v[32:35], v10 offset:32768
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[28:31], v[48:51], a[80:83], v14, v65 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[36:39], v10 offset:33792
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[28:31], v[52:55], a[84:87], v14, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[40:43], v10 offset:34816
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[28:31], v[56:59], a[88:91], v14, v66 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[44:47], v10 offset:35840
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[28:31], v[60:63], a[92:95], v14, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[48:51], v10 offset:36864
		ds_read_b128 v[52:55], v10 offset:37888
		ds_read_b128 v[56:59], v10 offset:38912
		ds_read_b128 v[60:63], v10 offset:39936
		s_lshl_b32 s47, s46, 12
		s_add_i32 s46, s47, 0x20000
		v_add3_u32 v4, s46, v5, v7
		ds_read_b32 v10, v4
		ds_read_b32 v15, v4 offset:256
		v_add3_u32 v4, s46, v7, v11
		ds_read_b32 v67, v4 offset:2048
		ds_read_b32 v152, v4 offset:2304
		ds_read_b32 v153, v4 offset:2560
		ds_read_b32 v154, v4 offset:2816
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[72:75], v[108:111], v[68:71], v9, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[72:75], v[116:119], v[80:83], v9, v13 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[72:75], v[124:127], v[88:91], v9, v64 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[72:75], v[132:135], v[96:99], v9, v64 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[72:75], v[136:139], v[104:107], v9, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v104, s46 offset:268
		scratch_store_dword off, v105, s46 offset:272
		scratch_store_dword off, v106, s46 offset:276
		scratch_store_dword off, v107, s46 offset:280
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[72:75], v[140:143], v[112:115], v9, v65 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v112, s46 offset:236
		scratch_store_dword off, v113, s46 offset:240
		scratch_store_dword off, v114, s46 offset:244
		scratch_store_dword off, v115, s46 offset:248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[72:75], v[144:147], v[120:123], v9, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v120, s46 offset:160
		scratch_store_dword off, v121, s46 offset:164
		scratch_store_dword off, v122, s46 offset:168
		scratch_store_dword off, v123, s46 offset:172
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[72:75], v[148:151], v[128:131], v9, v66 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v128, s46 offset:120
		scratch_store_dword off, v129, s46 offset:124
		scratch_store_dword off, v130, s46 offset:128
		scratch_store_dword off, v131, s46 offset:132
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[84:87], v[108:111], a[0:3], v9, v13 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[84:87], v[116:119], a[4:7], v9, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[84:87], v[124:127], a[8:11], v9, v64 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[84:87], v[132:135], a[12:15], v9, v64 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[84:87], v[136:139], a[16:19], v9, v65 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[84:87], v[140:143], a[20:23], v9, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[84:87], v[144:147], a[24:27], v9, v66 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[84:87], v[148:151], a[28:31], v9, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[92:95], v[108:111], a[32:35], v14, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[92:95], v[116:119], a[36:39], v14, v13 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[92:95], v[124:127], a[40:43], v14, v64 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[92:95], v[132:135], a[44:47], v14, v64 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[92:95], v[136:139], a[48:51], v14, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[92:95], v[140:143], a[52:55], v14, v65 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[92:95], v[144:147], a[56:59], v14, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[92:95], v[148:151], a[60:63], v14, v66 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[100:103], v[108:111], a[64:67], v14, v13 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[100:103], v[116:119], a[68:71], v14, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[100:103], v[124:127], a[72:75], v14, v64 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[100:103], v[132:135], a[76:79], v14, v64 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[100:103], v[136:139], a[80:83], v14, v65 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[100:103], v[140:143], a[84:87], v14, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[100:103], v[144:147], a[88:91], v14, v66 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[100:103], v[148:151], a[92:95], v14, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s46, v3
		s_and_b32 s47, s46, 1
		s_lshl_b32 s46, s47, 16
		v_add_u32_e32 v3, s46, v6
		v_add3_u32 v4, v3, v8, v2
		ds_read_b128 v[72:75], v4
		ds_read_b128 v[84:87], v4 offset:1024
		ds_read_b128 v[92:95], v4 offset:2048
		ds_read_b128 v[100:103], v4 offset:3072
		v_add_u32_e32 v3, s46, v8
		v_add3_u32 v104, v3, v12, v2
		ds_read_b128 v[108:111], v104 offset:32768
		ds_read_b128 v[112:115], v104 offset:33792
		ds_read_b128 v[116:119], v104 offset:34816
		ds_read_b128 v[120:123], v104 offset:35840
		ds_read_b128 v[124:127], v104 offset:36864
		ds_read_b128 v[128:131], v104 offset:37888
		ds_read_b128 v[132:135], v104 offset:38912
		ds_read_b128 v[136:139], v104 offset:39936
		s_lshl_b32 s46, s47, 12
		s_add_i32 s47, s46, 0x20000
		v_add3_u32 v3, s47, v5, v7
		ds_read_b32 v105, v3
		ds_read_b32 v106, v3 offset:256
		v_add3_u32 v3, s47, v7, v11
		ds_read_b32 v107, v3 offset:2048
		ds_read_b32 v140, v3 offset:2304
		ds_read_b32 v141, v3 offset:2560
		ds_read_b32 v142, v3 offset:2816
		s_waitcnt lgkmcnt(0)
		s_add_i32 s46, s11, 1
		v_mov_b32_e32 v144, s46
		v_mov_b32_e32 v145, 0
		s_mov_b32 s46, 0
		scratch_store_dword off, v144, s46 offset:136
		scratch_store_dword off, v145, s46 offset:140
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v144, off, s46 offset:136
		scratch_load_dword v145, off, s46 offset:140
		s_waitcnt vmcnt(0)
		v_mul_lo_u32 v146, v76, v144
		v_mul_hi_u32 v147, v76, v144
		v_mul_lo_u32 v3, v76, v145
		v_add_u32_e32 v147, v147, v3
		v_mul_lo_u32 v3, v77, v144
		v_add_u32_e32 v147, v147, v3
		s_mov_b32 s46, 0
		scratch_load_dword v144, off, s46
		scratch_load_dword v145, off, s46 offset:4
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v148, vcc, v144, v146
		v_addc_co_u32_e64 v149, vcc, v145, v147, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v148, s46 offset:176
		s_mov_b32 s46, 0
		scratch_load_dword v144, off, s46 offset:8
		scratch_load_dword v145, off, s46 offset:12
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v148, vcc, v144, v146
		v_addc_co_u32_e64 v149, vcc, v145, v147, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v148, s46 offset:180
		s_mov_b32 s46, 0
		scratch_load_dword v144, off, s46 offset:16
		scratch_load_dword v145, off, s46 offset:20
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v148, vcc, v144, v146
		v_addc_co_u32_e64 v149, vcc, v145, v147, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v148, s46 offset:184
		s_mov_b32 s46, 0
		scratch_load_dword v144, off, s46 offset:24
		scratch_load_dword v145, off, s46 offset:28
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v148, vcc, v144, v146
		v_addc_co_u32_e64 v149, vcc, v145, v147, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v148, s46 offset:188
		s_mov_b32 s46, 0
		scratch_load_dword v144, off, s46 offset:32
		scratch_load_dword v145, off, s46 offset:36
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v148, vcc, v144, v146
		v_addc_co_u32_e64 v149, vcc, v145, v147, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v148, s46 offset:192
		s_mov_b32 s46, 0
		scratch_load_dword v144, off, s46 offset:40
		scratch_load_dword v145, off, s46 offset:44
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v148, vcc, v144, v146
		v_addc_co_u32_e64 v149, vcc, v145, v147, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v148, s46 offset:196
		s_mov_b32 s46, 0
		scratch_load_dword v144, off, s46 offset:48
		scratch_load_dword v145, off, s46 offset:52
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v148, vcc, v144, v146
		v_addc_co_u32_e64 v149, vcc, v145, v147, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v148, s46 offset:200
		s_mov_b32 s46, 0
		scratch_load_dword v144, off, s46 offset:56
		scratch_load_dword v145, off, s46 offset:60
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v148, vcc, v144, v146
		v_addc_co_u32_e64 v149, vcc, v145, v147, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v148, s46 offset:204
		s_mov_b32 s46, 0
		scratch_load_dword v144, off, s46 offset:136
		scratch_load_dword v145, off, s46 offset:140
		s_waitcnt vmcnt(0)
		v_mul_lo_u32 v146, v78, v144
		v_mul_hi_u32 v147, v78, v144
		v_mul_lo_u32 v3, v78, v145
		v_add_u32_e32 v147, v147, v3
		v_mul_lo_u32 v3, v79, v144
		v_add_u32_e32 v147, v147, v3
		s_mov_b32 s46, 0
		scratch_load_dword v144, off, s46 offset:80
		scratch_load_dword v145, off, s46 offset:84
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v148, vcc, v144, v146
		v_addc_co_u32_e64 v149, vcc, v145, v147, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v148, s46 offset:208
		s_mov_b32 s46, 0
		scratch_load_dword v144, off, s46 offset:88
		scratch_load_dword v145, off, s46 offset:92
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v148, vcc, v144, v146
		v_addc_co_u32_e64 v149, vcc, v145, v147, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v148, s46 offset:212
		s_mov_b32 s46, 0
		scratch_load_dword v144, off, s46 offset:96
		scratch_load_dword v145, off, s46 offset:100
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v148, vcc, v144, v146
		v_addc_co_u32_e64 v149, vcc, v145, v147, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v148, s46 offset:216
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[72:75], v[108:111], v[68:71], v105, v107 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v68, s46 offset:428
		scratch_store_dword off, v69, s46 offset:432
		scratch_store_dword off, v70, s46 offset:436
		scratch_store_dword off, v71, s46 offset:440
		ds_read_b128 v[68:71], v4 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[72:75], v[112:115], v[80:83], v105, v107 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v80, s46 offset:380
		scratch_store_dword off, v81, s46 offset:384
		scratch_store_dword off, v82, s46 offset:388
		scratch_store_dword off, v83, s46 offset:392
		ds_read_b128 v[80:83], v4 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[72:75], v[116:119], v[88:91], v105, v140 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v88, s46 offset:332
		scratch_store_dword off, v89, s46 offset:336
		scratch_store_dword off, v90, s46 offset:340
		scratch_store_dword off, v91, s46 offset:344
		ds_read_b128 v[88:91], v4 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[72:75], v[120:123], v[96:99], v105, v140 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v96, s46 offset:300
		scratch_store_dword off, v97, s46 offset:304
		scratch_store_dword off, v98, s46 offset:308
		scratch_store_dword off, v99, s46 offset:312
		ds_read_b128 v[96:99], v4 offset:19456
		s_mov_b32 s46, 0
		scratch_load_dword v144, off, s46 offset:268
		scratch_load_dword v145, off, s46 offset:272
		scratch_load_dword v146, off, s46 offset:276
		scratch_load_dword v147, off, s46 offset:280
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[72:75], v[124:127], v[144:147], v105, v141 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v144, s46 offset:348
		scratch_store_dword off, v145, s46 offset:352
		scratch_store_dword off, v146, s46 offset:356
		scratch_store_dword off, v147, s46 offset:360
		ds_read_b128 v[144:147], v104 offset:49152
		s_mov_b32 s46, 0
		scratch_load_dword v148, off, s46 offset:236
		scratch_load_dword v149, off, s46 offset:240
		scratch_load_dword v150, off, s46 offset:244
		scratch_load_dword v151, off, s46 offset:248
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[72:75], v[128:131], v[148:151], v105, v141 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v148, s46 offset:396
		scratch_store_dword off, v149, s46 offset:400
		scratch_store_dword off, v150, s46 offset:404
		scratch_store_dword off, v151, s46 offset:408
		ds_read_b128 v[148:151], v104 offset:50176
		s_mov_b32 s46, 0
		scratch_load_dword v156, off, s46 offset:160
		scratch_load_dword v157, off, s46 offset:164
		scratch_load_dword v158, off, s46 offset:168
		scratch_load_dword v159, off, s46 offset:172
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[72:75], v[132:135], v[156:159], v105, v142 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v156, s46 offset:444
		scratch_store_dword off, v157, s46 offset:448
		scratch_store_dword off, v158, s46 offset:452
		scratch_store_dword off, v159, s46 offset:456
		ds_read_b128 v[156:159], v104 offset:51200
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v156, s46 offset:460
		scratch_store_dword off, v157, s46 offset:464
		scratch_store_dword off, v158, s46 offset:468
		scratch_store_dword off, v159, s46 offset:472
		s_mov_b32 s46, 0
		scratch_load_dword v156, off, s46 offset:120
		scratch_load_dword v157, off, s46 offset:124
		scratch_load_dword v158, off, s46 offset:128
		scratch_load_dword v159, off, s46 offset:132
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[72:75], v[136:139], v[156:159], v105, v142 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v156, s46 offset:476
		scratch_store_dword off, v157, s46 offset:480
		scratch_store_dword off, v158, s46 offset:484
		scratch_store_dword off, v159, s46 offset:488
		ds_read_b128 v[72:75], v104 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[84:87], v[108:111], a[0:3], v105, v107 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[156:159], v104 offset:53248
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v156, s46 offset:492
		scratch_store_dword off, v157, s46 offset:496
		scratch_store_dword off, v158, s46 offset:500
		scratch_store_dword off, v159, s46 offset:504
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[84:87], v[112:115], a[4:7], v105, v107 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[156:159], v104 offset:54272
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v156, s46 offset:508
		scratch_store_dword off, v157, s46 offset:512
		scratch_store_dword off, v158, s46 offset:516
		scratch_store_dword off, v159, s46 offset:520
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[84:87], v[116:119], a[8:11], v105, v140 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[156:159], v104 offset:55296
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v156, s46 offset:524
		scratch_store_dword off, v157, s46 offset:528
		scratch_store_dword off, v158, s46 offset:532
		scratch_store_dword off, v159, s46 offset:536
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[84:87], v[120:123], a[12:15], v105, v140 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[156:159], v104 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[84:87], v[124:127], a[16:19], v105, v141 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s10
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(58)
		scratch_load_dword v3, off, s46 offset:176
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[84:87], v[128:131], a[20:23], v105, v141 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s36
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(57)
		scratch_load_dword v3, off, s46 offset:180
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[84:87], v[132:135], a[24:27], v105, v142 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s37
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(56)
		scratch_load_dword v3, off, s46 offset:184
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[84:87], v[136:139], a[28:31], v105, v142 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s38
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(55)
		scratch_load_dword v3, off, s46 offset:188
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[92:95], v[108:111], a[32:35], v106, v107 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s39
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(54)
		scratch_load_dword v3, off, s46 offset:192
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[92:95], v[112:115], a[36:39], v106, v107 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s40
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(53)
		scratch_load_dword v3, off, s46 offset:196
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[92:95], v[116:119], a[40:43], v106, v140 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s41
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(52)
		scratch_load_dword v3, off, s46 offset:200
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[92:95], v[120:123], a[44:47], v106, v140 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s42
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(51)
		scratch_load_dword v3, off, s46 offset:204
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[92:95], v[124:127], a[48:51], v106, v141 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s43, 0x20000
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(50)
		scratch_load_dword v3, off, s46 offset:208
		s_waitcnt vmcnt(0)
		buffer_load_dword v3, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[92:95], v[128:131], a[52:55], v106, v141 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s44, 0x20000
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(49)
		scratch_load_dword v3, off, s46 offset:212
		s_waitcnt vmcnt(0)
		buffer_load_dword v3, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[92:95], v[132:135], a[56:59], v106, v142 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s45, 0x20000
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(48)
		scratch_load_dword v3, off, s46 offset:216
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v3, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[92:95], v[136:139], a[60:63], v106, v142 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[100:103], v[108:111], a[64:67], v106, v107 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[100:103], v[112:115], a[68:71], v106, v107 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[100:103], v[116:119], a[72:75], v106, v140 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[100:103], v[120:123], a[76:79], v106, v140 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[100:103], v[124:127], a[80:83], v106, v141 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[100:103], v[128:131], a[84:87], v106, v141 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[100:103], v[132:135], a[88:91], v106, v142 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[100:103], v[136:139], a[92:95], v106, v142 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		s_waitcnt lgkmcnt(0)
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(44)
		scratch_load_dword v84, off, s46 offset:428
		scratch_load_dword v85, off, s46 offset:432
		scratch_load_dword v86, off, s46 offset:436
		scratch_load_dword v87, off, s46 offset:440
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[68:71], v[144:147], v[84:87], v105, v107 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(40)
		scratch_load_dword v92, off, s46 offset:380
		scratch_load_dword v93, off, s46 offset:384
		scratch_load_dword v94, off, s46 offset:388
		scratch_load_dword v95, off, s46 offset:392
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[68:71], v[148:151], v[92:95], v105, v107 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(36)
		scratch_load_dword v100, off, s46 offset:332
		scratch_load_dword v101, off, s46 offset:336
		scratch_load_dword v102, off, s46 offset:340
		scratch_load_dword v103, off, s46 offset:344
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v108, off, s46 offset:460
		scratch_load_dword v109, off, s46 offset:464
		scratch_load_dword v110, off, s46 offset:468
		scratch_load_dword v111, off, s46 offset:472
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[68:71], v[108:111], v[100:103], v105, v140 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v108, off, s46 offset:300
		scratch_load_dword v109, off, s46 offset:304
		scratch_load_dword v110, off, s46 offset:308
		scratch_load_dword v111, off, s46 offset:312
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[68:71], v[72:75], v[108:111], v105, v140 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v112, off, s46 offset:348
		scratch_load_dword v113, off, s46 offset:352
		scratch_load_dword v114, off, s46 offset:356
		scratch_load_dword v115, off, s46 offset:360
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v116, off, s46 offset:492
		scratch_load_dword v117, off, s46 offset:496
		scratch_load_dword v118, off, s46 offset:500
		scratch_load_dword v119, off, s46 offset:504
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[68:71], v[116:119], v[112:115], v105, v141 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v116, off, s46 offset:396
		scratch_load_dword v117, off, s46 offset:400
		scratch_load_dword v118, off, s46 offset:404
		scratch_load_dword v119, off, s46 offset:408
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v120, off, s46 offset:508
		scratch_load_dword v121, off, s46 offset:512
		scratch_load_dword v122, off, s46 offset:516
		scratch_load_dword v123, off, s46 offset:520
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[68:71], v[120:123], v[116:119], v105, v141 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v120, off, s46 offset:444
		scratch_load_dword v121, off, s46 offset:448
		scratch_load_dword v122, off, s46 offset:452
		scratch_load_dword v123, off, s46 offset:456
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v124, off, s46 offset:524
		scratch_load_dword v125, off, s46 offset:528
		scratch_load_dword v126, off, s46 offset:532
		scratch_load_dword v127, off, s46 offset:536
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[68:71], v[124:127], v[120:123], v105, v142 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v124, off, s46 offset:476
		scratch_load_dword v125, off, s46 offset:480
		scratch_load_dword v126, off, s46 offset:484
		scratch_load_dword v127, off, s46 offset:488
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[68:71], v[156:159], v[124:127], v105, v142 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[80:83], v[144:147], a[0:3], v105, v107 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[80:83], v[148:151], a[4:7], v105, v107 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v68, off, s46 offset:460
		scratch_load_dword v69, off, s46 offset:464
		scratch_load_dword v70, off, s46 offset:468
		scratch_load_dword v71, off, s46 offset:472
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[80:83], v[68:71], a[8:11], v105, v140 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[80:83], v[72:75], a[12:15], v105, v140 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v68, off, s46 offset:492
		scratch_load_dword v69, off, s46 offset:496
		scratch_load_dword v70, off, s46 offset:500
		scratch_load_dword v71, off, s46 offset:504
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[80:83], v[68:71], a[16:19], v105, v141 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v68, off, s46 offset:508
		scratch_load_dword v69, off, s46 offset:512
		scratch_load_dword v70, off, s46 offset:516
		scratch_load_dword v71, off, s46 offset:520
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[80:83], v[68:71], a[20:23], v105, v141 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v68, off, s46 offset:524
		scratch_load_dword v69, off, s46 offset:528
		scratch_load_dword v70, off, s46 offset:532
		scratch_load_dword v71, off, s46 offset:536
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[80:83], v[68:71], a[24:27], v105, v142 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[80:83], v[156:159], a[28:31], v105, v142 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[88:91], v[144:147], a[32:35], v106, v107 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[88:91], v[148:151], a[36:39], v106, v107 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v68, off, s46 offset:460
		scratch_load_dword v69, off, s46 offset:464
		scratch_load_dword v70, off, s46 offset:468
		scratch_load_dword v71, off, s46 offset:472
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[88:91], v[68:71], a[40:43], v106, v140 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[88:91], v[72:75], a[44:47], v106, v140 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v68, off, s46 offset:492
		scratch_load_dword v69, off, s46 offset:496
		scratch_load_dword v70, off, s46 offset:500
		scratch_load_dword v71, off, s46 offset:504
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[88:91], v[68:71], a[48:51], v106, v141 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v68, off, s46 offset:508
		scratch_load_dword v69, off, s46 offset:512
		scratch_load_dword v70, off, s46 offset:516
		scratch_load_dword v71, off, s46 offset:520
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[88:91], v[68:71], a[52:55], v106, v141 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v68, off, s46 offset:524
		scratch_load_dword v69, off, s46 offset:528
		scratch_load_dword v70, off, s46 offset:532
		scratch_load_dword v71, off, s46 offset:536
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[88:91], v[68:71], a[56:59], v106, v142 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[88:91], v[156:159], a[60:63], v106, v142 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[96:99], v[144:147], a[64:67], v106, v107 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[96:99], v[148:151], a[68:71], v106, v107 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v68, off, s46 offset:460
		scratch_load_dword v69, off, s46 offset:464
		scratch_load_dword v70, off, s46 offset:468
		scratch_load_dword v71, off, s46 offset:472
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[96:99], v[68:71], a[72:75], v106, v140 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[96:99], v[72:75], a[76:79], v106, v140 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v68, off, s46 offset:492
		scratch_load_dword v69, off, s46 offset:496
		scratch_load_dword v70, off, s46 offset:500
		scratch_load_dword v71, off, s46 offset:504
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[96:99], v[68:71], a[80:83], v106, v141 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v68, off, s46 offset:508
		scratch_load_dword v69, off, s46 offset:512
		scratch_load_dword v70, off, s46 offset:516
		scratch_load_dword v71, off, s46 offset:520
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[96:99], v[68:71], a[84:87], v106, v141 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v68, off, s46 offset:524
		scratch_load_dword v69, off, s46 offset:528
		scratch_load_dword v70, off, s46 offset:532
		scratch_load_dword v71, off, s46 offset:536
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[96:99], v[68:71], a[88:91], v106, v142 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[96:99], v[156:159], a[92:95], v106, v142 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s11, s11, 2
		v_readfirstlane_b32 s46, v1
		s_cmp_lt_i32 s11, s46
		s_mov_b32 s46, 0
		s_nop 2
		scratch_load_dword v68, off, s46 offset:64
		scratch_load_dword v69, off, s46 offset:68
		scratch_load_dword v70, off, s46 offset:72
		scratch_load_dword v71, off, s46 offset:76
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v28, v68
		v_mov_b32_e32 v29, v69
		v_mov_b32_e32 v30, v70
		v_mov_b32_e32 v31, v71
		v_mov_b32_e32 v9, v10
		v_mov_b32_e32 v14, v15
		v_mov_b32_e32 v13, v67
		v_mov_b32_e32 v64, v152
		v_mov_b32_e32 v65, v153
		v_mov_b32_e32 v66, v154
		s_mov_b32 s46, 0
		scratch_store_dword off, v124, s46 offset:104
		scratch_store_dword off, v125, s46 offset:108
		scratch_store_dword off, v126, s46 offset:112
		scratch_store_dword off, v127, s46 offset:116
		s_mov_b32 s46, 0
		scratch_store_dword off, v120, s46 offset:144
		scratch_store_dword off, v121, s46 offset:148
		scratch_store_dword off, v122, s46 offset:152
		scratch_store_dword off, v123, s46 offset:156
		s_mov_b32 s46, 0
		scratch_store_dword off, v116, s46 offset:220
		scratch_store_dword off, v117, s46 offset:224
		scratch_store_dword off, v118, s46 offset:228
		scratch_store_dword off, v119, s46 offset:232
		s_mov_b32 s46, 0
		scratch_store_dword off, v112, s46 offset:252
		scratch_store_dword off, v113, s46 offset:256
		scratch_store_dword off, v114, s46 offset:260
		scratch_store_dword off, v115, s46 offset:264
		s_mov_b32 s46, 0
		scratch_store_dword off, v108, s46 offset:284
		scratch_store_dword off, v109, s46 offset:288
		scratch_store_dword off, v110, s46 offset:292
		scratch_store_dword off, v111, s46 offset:296
		s_mov_b32 s46, 0
		scratch_store_dword off, v100, s46 offset:316
		scratch_store_dword off, v101, s46 offset:320
		scratch_store_dword off, v102, s46 offset:324
		scratch_store_dword off, v103, s46 offset:328
		s_mov_b32 s46, 0
		scratch_store_dword off, v92, s46 offset:364
		scratch_store_dword off, v93, s46 offset:368
		scratch_store_dword off, v94, s46 offset:372
		scratch_store_dword off, v95, s46 offset:376
		s_mov_b32 s46, 0
		scratch_store_dword off, v84, s46 offset:412
		scratch_store_dword off, v85, s46 offset:416
		scratch_store_dword off, v86, s46 offset:420
		scratch_store_dword off, v87, s46 offset:424
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v68, off, s0 offset:412
		scratch_load_dword v69, off, s0 offset:416
		scratch_load_dword v70, off, s0 offset:420
		scratch_load_dword v71, off, s0 offset:424
		s_mov_b32 s0, 0
		scratch_load_dword v72, off, s0 offset:364
		scratch_load_dword v73, off, s0 offset:368
		scratch_load_dword v74, off, s0 offset:372
		scratch_load_dword v75, off, s0 offset:376
		s_mov_b32 s0, 0
		scratch_load_dword v76, off, s0 offset:316
		scratch_load_dword v77, off, s0 offset:320
		scratch_load_dword v78, off, s0 offset:324
		scratch_load_dword v79, off, s0 offset:328
		s_mov_b32 s0, 0
		scratch_load_dword v80, off, s0 offset:284
		scratch_load_dword v81, off, s0 offset:288
		scratch_load_dword v82, off, s0 offset:292
		scratch_load_dword v83, off, s0 offset:296
		s_mov_b32 s0, 0
		scratch_load_dword v84, off, s0 offset:252
		scratch_load_dword v85, off, s0 offset:256
		scratch_load_dword v86, off, s0 offset:260
		scratch_load_dword v87, off, s0 offset:264
		s_mov_b32 s0, 0
		scratch_load_dword v88, off, s0 offset:220
		scratch_load_dword v89, off, s0 offset:224
		scratch_load_dword v90, off, s0 offset:228
		scratch_load_dword v91, off, s0 offset:232
		s_mov_b32 s0, 0
		scratch_load_dword v92, off, s0 offset:144
		scratch_load_dword v93, off, s0 offset:148
		scratch_load_dword v94, off, s0 offset:152
		scratch_load_dword v95, off, s0 offset:156
		s_mov_b32 s0, 0
		scratch_load_dword v96, off, s0 offset:104
		scratch_load_dword v97, off, s0 offset:108
		scratch_load_dword v98, off, s0 offset:112
		scratch_load_dword v99, off, s0 offset:116
		s_add_i32 s0, s12, -1
		s_waitcnt vmcnt(28)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[16:19], v[32:35], v[68:71], v9, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s1, s0, 1
		s_lshl_b32 s0, s1, 16
		v_add_u32_e32 v1, s0, v6
		v_add3_u32 v3, v1, v8, v2
		ds_read_b128 v[100:103], v3 offset:16384
		s_waitcnt vmcnt(24)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[16:19], v[36:39], v[72:75], v9, v13 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[104:107], v3 offset:17408
		s_waitcnt vmcnt(20)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[16:19], v[40:43], v[76:79], v9, v64 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[108:111], v3 offset:18432
		s_waitcnt vmcnt(16)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[16:19], v[44:47], v[80:83], v9, v64 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[112:115], v3 offset:19456
		s_waitcnt vmcnt(12)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[16:19], v[48:51], v[84:87], v9, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, s0, v8
		v_add3_u32 v3, v1, v12, v2
		ds_read_b128 v[116:119], v3 offset:49152
		s_waitcnt vmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[16:19], v[52:55], v[88:91], v9, v65 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[120:123], v3 offset:50176
		s_waitcnt vmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[16:19], v[56:59], v[92:95], v9, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[124:127], v3 offset:51200
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[16:19], v[60:63], v[96:99], v9, v66 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[16:19], v3 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[20:23], v[32:35], a[0:3], v9, v13 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[128:131], v3 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[20:23], v[36:39], a[4:7], v9, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[132:135], v3 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[20:23], v[40:43], a[8:11], v9, v64 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[136:139], v3 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[20:23], v[44:47], a[12:15], v9, v64 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[140:143], v3 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[20:23], v[48:51], a[16:19], v9, v65 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[20:23], v[52:55], a[20:23], v9, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[20:23], v[56:59], a[24:27], v9, v66 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[20:23], v[60:63], a[28:31], v9, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[24:27], v[32:35], a[32:35], v14, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[24:27], v[36:39], a[36:39], v14, v13 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[24:27], v[40:43], a[40:43], v14, v64 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[24:27], v[44:47], a[44:47], v14, v64 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[24:27], v[48:51], a[48:51], v14, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[24:27], v[52:55], a[52:55], v14, v65 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[24:27], v[56:59], a[56:59], v14, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[24:27], v[60:63], a[60:63], v14, v66 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[28:31], v[32:35], a[64:67], v14, v13 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[28:31], v[36:39], a[68:71], v14, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[28:31], v[40:43], a[72:75], v14, v64 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[28:31], v[44:47], a[76:79], v14, v64 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[28:31], v[48:51], a[80:83], v14, v65 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[28:31], v[52:55], a[84:87], v14, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[28:31], v[56:59], a[88:91], v14, v66 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[28:31], v[60:63], a[92:95], v14, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[100:103], v[116:119], v[68:71], v9, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[100:103], v[120:123], v[72:75], v9, v13 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[100:103], v[124:127], v[76:79], v9, v64 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[100:103], v[16:19], v[80:83], v9, v64 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[100:103], v[128:131], v[84:87], v9, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[100:103], v[132:135], v[88:91], v9, v65 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[100:103], v[136:139], v[92:95], v9, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[100:103], v[140:143], v[96:99], v9, v66 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[104:107], v[116:119], a[0:3], v9, v13 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[104:107], v[120:123], a[4:7], v9, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[104:107], v[124:127], a[8:11], v9, v64 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[104:107], v[16:19], a[12:15], v9, v64 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[104:107], v[128:131], a[16:19], v9, v65 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[104:107], v[132:135], a[20:23], v9, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[104:107], v[136:139], a[24:27], v9, v66 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[104:107], v[140:143], a[28:31], v9, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[108:111], v[116:119], a[32:35], v14, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[108:111], v[120:123], a[36:39], v14, v13 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[108:111], v[124:127], a[40:43], v14, v64 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[108:111], v[16:19], a[44:47], v14, v64 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[108:111], v[128:131], a[48:51], v14, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[108:111], v[132:135], a[52:55], v14, v65 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[108:111], v[136:139], a[56:59], v14, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[108:111], v[140:143], a[60:63], v14, v66 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[112:115], v[116:119], a[64:67], v14, v13 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[112:115], v[120:123], a[68:71], v14, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[112:115], v[124:127], a[72:75], v14, v64 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[112:115], v[16:19], a[76:79], v14, v64 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[112:115], v[128:131], a[80:83], v14, v65 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[112:115], v[132:135], a[84:87], v14, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[112:115], v[136:139], a[88:91], v14, v66 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[112:115], v[140:143], a[92:95], v14, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s0, s12, 1
		s_lshl_b32 s1, s0, 16
		v_add_u32_e32 v1, s1, v6
		v_add3_u32 v3, v1, v8, v2
		ds_read_b128 v[16:19], v3
		ds_read_b128 v[20:23], v3 offset:1024
		ds_read_b128 v[24:27], v3 offset:2048
		ds_read_b128 v[28:31], v3 offset:3072
		v_add_u32_e32 v1, s1, v8
		v_add3_u32 v4, v1, v12, v2
		ds_read_b128 v[12:15], v4 offset:32768
		ds_read_b128 v[32:35], v4 offset:33792
		ds_read_b128 v[36:39], v4 offset:34816
		ds_read_b128 v[40:43], v4 offset:35840
		ds_read_b128 v[44:47], v4 offset:36864
		ds_read_b128 v[48:51], v4 offset:37888
		ds_read_b128 v[52:55], v4 offset:38912
		ds_read_b128 v[56:59], v4 offset:39936
		s_lshl_b32 s1, s0, 12
		s_add_i32 s0, s1, 0x20000
		v_add3_u32 v1, s0, v5, v7
		ds_read_b32 v2, v1
		ds_read_b32 v5, v1 offset:256
		v_add3_u32 v1, s0, v7, v11
		ds_read_b32 v6, v1 offset:2048
		ds_read_b32 v7, v1 offset:2304
		ds_read_b32 v8, v1 offset:2560
		ds_read_b32 v9, v1 offset:2816
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[16:19], v[12:15], v[68:71], v2, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[60:63], v3 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[16:19], v[32:35], v[72:75], v2, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[64:67], v3 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[16:19], v[36:39], v[76:79], v2, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v3 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[16:19], v[40:43], v[80:83], v2, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[104:107], v3 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[16:19], v[44:47], v[84:87], v2, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[108:111], v4 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[16:19], v[48:51], v[88:91], v2, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[112:115], v4 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[16:19], v[52:55], v[92:95], v2, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[116:119], v4 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[16:19], v[56:59], v[96:99], v2, v9 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[16:19], v4 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[20:23], v[12:15], a[0:3], v2, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[120:123], v4 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[20:23], v[32:35], a[4:7], v2, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[124:127], v4 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[20:23], v[36:39], a[8:11], v2, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[128:131], v4 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[20:23], v[40:43], a[12:15], v2, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[132:135], v4 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[20:23], v[44:47], a[16:19], v2, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[20:23], v[48:51], a[20:23], v2, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[20:23], v[52:55], a[24:27], v2, v9 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[20:23], v[56:59], a[28:31], v2, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[24:27], v[12:15], a[32:35], v5, v6 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[24:27], v[32:35], a[36:39], v5, v6 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[24:27], v[36:39], a[40:43], v5, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[24:27], v[40:43], a[44:47], v5, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[24:27], v[44:47], a[48:51], v5, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[24:27], v[48:51], a[52:55], v5, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[24:27], v[52:55], a[56:59], v5, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[24:27], v[56:59], a[60:63], v5, v9 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[28:31], v[12:15], a[64:67], v5, v6 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[28:31], v[32:35], a[68:71], v5, v6 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[28:31], v[36:39], a[72:75], v5, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[28:31], v[40:43], a[76:79], v5, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[28:31], v[44:47], a[80:83], v5, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[28:31], v[48:51], a[84:87], v5, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[28:31], v[52:55], a[88:91], v5, v9 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[28:31], v[56:59], a[92:95], v5, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[60:63], v[108:111], v[68:71], v2, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[60:63], v[112:115], v[72:75], v2, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[60:63], v[116:119], v[76:79], v2, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[60:63], v[16:19], v[80:83], v2, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[60:63], v[120:123], v[84:87], v2, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[60:63], v[124:127], v[88:91], v2, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[60:63], v[128:131], v[92:95], v2, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[60:63], v[132:135], v[96:99], v2, v9 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[0:3], v[64:67], v[108:111], a[0:3], v2, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[4:7], v[64:67], v[112:115], a[4:7], v2, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[8:11], v[64:67], v[116:119], a[8:11], v2, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[12:15], v[64:67], v[16:19], a[12:15], v2, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[16:19], v[64:67], v[120:123], a[16:19], v2, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[20:23], v[64:67], v[124:127], a[20:23], v2, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[24:27], v[64:67], v[128:131], a[24:27], v2, v9 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[28:31], v[64:67], v[132:135], a[28:31], v2, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[32:35], v[100:103], v[108:111], a[32:35], v5, v6 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[36:39], v[100:103], v[112:115], a[36:39], v5, v6 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[40:43], v[100:103], v[116:119], a[40:43], v5, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[44:47], v[100:103], v[16:19], a[44:47], v5, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[48:51], v[100:103], v[120:123], a[48:51], v5, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[52:55], v[100:103], v[124:127], a[52:55], v5, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[56:59], v[100:103], v[128:131], a[56:59], v5, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[60:63], v[100:103], v[132:135], a[60:63], v5, v9 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[64:67], v[104:107], v[108:111], a[64:67], v5, v6 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[68:71], v[104:107], v[112:115], a[68:71], v5, v6 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[72:75], v[104:107], v[116:119], a[72:75], v5, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[76:79], v[104:107], v[16:19], a[76:79], v5, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[80:83], v[104:107], v[120:123], a[80:83], v5, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[84:87], v[104:107], v[124:127], a[84:87], v5, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[88:91], v[104:107], v[128:131], a[88:91], v5, v9 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 a[92:95], v[104:107], v[132:135], a[92:95], v5, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v68, v69
		v_cvt_pk_f16_f32 v3, v70, v71
		v_and_b32_e32 v1, 63, v0
		v_lshlrev_b32_e32 v4, 3, v1
		v_lshlrev_b32_e32 v1, 2, v0
		ds_read_b32 v0, v1 offset:22528
		s_waitcnt lgkmcnt(0)
		v_lshl_add_u32 v1, v0, 14, v4
		s_lshl_b32 s0, s13, 21
		s_lshl_b32 s1, s14, 17
		s_add_i32 s2, s0, s1
		buffer_store_dwordx2 v[2:3], v1, s[16:19], s2 offen
		v_cvt_pk_f16_f32 v2, v72, v73
		v_cvt_pk_f16_f32 v3, v74, v75
		buffer_store_dwordx2 v[2:3], v1, s[16:19], s2 offen offset:512
		v_cvt_pk_f16_f32 v2, v76, v77
		v_cvt_pk_f16_f32 v3, v78, v79
		buffer_store_dwordx2 v[2:3], v1, s[16:19], s2 offen offset:1024
		v_cvt_pk_f16_f32 v2, v80, v81
		v_cvt_pk_f16_f32 v3, v82, v83
		buffer_store_dwordx2 v[2:3], v1, s[16:19], s2 offen offset:1536
		v_cvt_pk_f16_f32 v2, v84, v85
		v_cvt_pk_f16_f32 v3, v86, v87
		buffer_store_dwordx2 v[2:3], v1, s[16:19], s2 offen offset:2048
		v_cvt_pk_f16_f32 v2, v88, v89
		v_cvt_pk_f16_f32 v3, v90, v91
		buffer_store_dwordx2 v[2:3], v1, s[16:19], s2 offen offset:2560
		v_cvt_pk_f16_f32 v2, v92, v93
		v_cvt_pk_f16_f32 v3, v94, v95
		buffer_store_dwordx2 v[2:3], v1, s[16:19], s2 offen offset:3072
		v_cvt_pk_f16_f32 v2, v96, v97
		v_cvt_pk_f16_f32 v3, v98, v99
		buffer_store_dwordx2 v[2:3], v1, s[16:19], s2 offen offset:3584
		v_accvgpr_read_b32 v0, a0
		v_accvgpr_read_b32 v2, a1
		v_cvt_pk_f16_f32 v4, v0, v2
		v_accvgpr_read_b32 v0, a2
		v_accvgpr_read_b32 v2, a3
		v_cvt_pk_f16_f32 v5, v0, v2
		s_add_i32 s2, s0, 0x1000
		s_add_i32 s3, s2, s1
		buffer_store_dwordx2 v[4:5], v1, s[16:19], s3 offen
		v_accvgpr_read_b32 v0, a4
		v_accvgpr_read_b32 v2, a5
		v_cvt_pk_f16_f32 v4, v0, v2
		v_accvgpr_read_b32 v0, a6
		v_accvgpr_read_b32 v2, a7
		v_cvt_pk_f16_f32 v5, v0, v2
		buffer_store_dwordx2 v[4:5], v1, s[16:19], s3 offen offset:512
		v_accvgpr_read_b32 v0, a8
		v_accvgpr_read_b32 v2, a9
		v_cvt_pk_f16_f32 v4, v0, v2
		v_accvgpr_read_b32 v0, a10
		v_accvgpr_read_b32 v2, a11
		v_cvt_pk_f16_f32 v5, v0, v2
		buffer_store_dwordx2 v[4:5], v1, s[16:19], s3 offen offset:1024
		v_accvgpr_read_b32 v0, a12
		v_accvgpr_read_b32 v2, a13
		v_cvt_pk_f16_f32 v4, v0, v2
		v_accvgpr_read_b32 v0, a14
		v_accvgpr_read_b32 v2, a15
		v_cvt_pk_f16_f32 v5, v0, v2
		buffer_store_dwordx2 v[4:5], v1, s[16:19], s3 offen offset:1536
		v_accvgpr_read_b32 v0, a16
		v_accvgpr_read_b32 v2, a17
		v_cvt_pk_f16_f32 v4, v0, v2
		v_accvgpr_read_b32 v0, a18
		v_accvgpr_read_b32 v2, a19
		v_cvt_pk_f16_f32 v5, v0, v2
		buffer_store_dwordx2 v[4:5], v1, s[16:19], s3 offen offset:2048
		v_accvgpr_read_b32 v0, a20
		v_accvgpr_read_b32 v2, a21
		v_cvt_pk_f16_f32 v4, v0, v2
		v_accvgpr_read_b32 v0, a22
		v_accvgpr_read_b32 v2, a23
		v_cvt_pk_f16_f32 v5, v0, v2
		buffer_store_dwordx2 v[4:5], v1, s[16:19], s3 offen offset:2560
		v_accvgpr_read_b32 v0, a24
		v_accvgpr_read_b32 v2, a25
		v_cvt_pk_f16_f32 v4, v0, v2
		v_accvgpr_read_b32 v0, a26
		v_accvgpr_read_b32 v2, a27
		v_cvt_pk_f16_f32 v5, v0, v2
		buffer_store_dwordx2 v[4:5], v1, s[16:19], s3 offen offset:3072
		v_accvgpr_read_b32 v0, a28
		v_accvgpr_read_b32 v2, a29
		v_cvt_pk_f16_f32 v4, v0, v2
		v_accvgpr_read_b32 v0, a30
		v_accvgpr_read_b32 v2, a31
		v_cvt_pk_f16_f32 v5, v0, v2
		buffer_store_dwordx2 v[4:5], v1, s[16:19], s3 offen offset:3584
		v_accvgpr_read_b32 v0, a32
		v_accvgpr_read_b32 v2, a33
		v_cvt_pk_f16_f32 v4, v0, v2
		v_accvgpr_read_b32 v0, a34
		v_accvgpr_read_b32 v2, a35
		v_cvt_pk_f16_f32 v5, v0, v2
		s_add_i32 s2, s0, 0x2000
		s_add_i32 s3, s2, s1
		buffer_store_dwordx2 v[4:5], v1, s[16:19], s3 offen
		v_accvgpr_read_b32 v0, a36
		v_accvgpr_read_b32 v2, a37
		v_cvt_pk_f16_f32 v4, v0, v2
		v_accvgpr_read_b32 v0, a38
		v_accvgpr_read_b32 v2, a39
		v_cvt_pk_f16_f32 v5, v0, v2
		buffer_store_dwordx2 v[4:5], v1, s[16:19], s3 offen offset:512
		v_accvgpr_read_b32 v0, a40
		v_accvgpr_read_b32 v2, a41
		v_cvt_pk_f16_f32 v4, v0, v2
		v_accvgpr_read_b32 v0, a42
		v_accvgpr_read_b32 v2, a43
		v_cvt_pk_f16_f32 v5, v0, v2
		buffer_store_dwordx2 v[4:5], v1, s[16:19], s3 offen offset:1024
		v_accvgpr_read_b32 v0, a44
		v_accvgpr_read_b32 v2, a45
		v_cvt_pk_f16_f32 v4, v0, v2
		v_accvgpr_read_b32 v0, a46
		v_accvgpr_read_b32 v2, a47
		v_cvt_pk_f16_f32 v5, v0, v2
		buffer_store_dwordx2 v[4:5], v1, s[16:19], s3 offen offset:1536
		v_accvgpr_read_b32 v0, a48
		v_accvgpr_read_b32 v2, a49
		v_cvt_pk_f16_f32 v4, v0, v2
		v_accvgpr_read_b32 v0, a50
		v_accvgpr_read_b32 v2, a51
		v_cvt_pk_f16_f32 v5, v0, v2
		buffer_store_dwordx2 v[4:5], v1, s[16:19], s3 offen offset:2048
		v_accvgpr_read_b32 v0, a52
		v_accvgpr_read_b32 v2, a53
		v_cvt_pk_f16_f32 v4, v0, v2
		v_accvgpr_read_b32 v0, a54
		v_accvgpr_read_b32 v2, a55
		v_cvt_pk_f16_f32 v5, v0, v2
		buffer_store_dwordx2 v[4:5], v1, s[16:19], s3 offen offset:2560
		v_accvgpr_read_b32 v0, a56
		v_accvgpr_read_b32 v2, a57
		v_cvt_pk_f16_f32 v4, v0, v2
		v_accvgpr_read_b32 v0, a58
		v_accvgpr_read_b32 v2, a59
		v_cvt_pk_f16_f32 v5, v0, v2
		buffer_store_dwordx2 v[4:5], v1, s[16:19], s3 offen offset:3072
		v_accvgpr_read_b32 v0, a60
		v_accvgpr_read_b32 v2, a61
		v_cvt_pk_f16_f32 v4, v0, v2
		v_accvgpr_read_b32 v0, a62
		v_accvgpr_read_b32 v2, a63
		v_cvt_pk_f16_f32 v5, v0, v2
		buffer_store_dwordx2 v[4:5], v1, s[16:19], s3 offen offset:3584
		v_accvgpr_read_b32 v0, a64
		v_accvgpr_read_b32 v2, a65
		v_cvt_pk_f16_f32 v4, v0, v2
		v_accvgpr_read_b32 v0, a66
		v_accvgpr_read_b32 v2, a67
		v_cvt_pk_f16_f32 v5, v0, v2
		s_add_i32 s2, s0, 0x3000
		s_add_i32 s0, s2, s1
		buffer_store_dwordx2 v[4:5], v1, s[16:19], s0 offen
		v_accvgpr_read_b32 v0, a68
		v_accvgpr_read_b32 v2, a69
		v_cvt_pk_f16_f32 v4, v0, v2
		v_accvgpr_read_b32 v0, a70
		v_accvgpr_read_b32 v2, a71
		v_cvt_pk_f16_f32 v5, v0, v2
		buffer_store_dwordx2 v[4:5], v1, s[16:19], s0 offen offset:512
		v_accvgpr_read_b32 v0, a72
		v_accvgpr_read_b32 v2, a73
		v_cvt_pk_f16_f32 v4, v0, v2
		v_accvgpr_read_b32 v0, a74
		v_accvgpr_read_b32 v2, a75
		v_cvt_pk_f16_f32 v5, v0, v2
		buffer_store_dwordx2 v[4:5], v1, s[16:19], s0 offen offset:1024
		v_accvgpr_read_b32 v0, a76
		v_accvgpr_read_b32 v2, a77
		v_cvt_pk_f16_f32 v4, v0, v2
		v_accvgpr_read_b32 v0, a78
		v_accvgpr_read_b32 v2, a79
		v_cvt_pk_f16_f32 v5, v0, v2
		buffer_store_dwordx2 v[4:5], v1, s[16:19], s0 offen offset:1536
		v_accvgpr_read_b32 v0, a80
		v_accvgpr_read_b32 v2, a81
		v_cvt_pk_f16_f32 v4, v0, v2
		v_accvgpr_read_b32 v0, a82
		v_accvgpr_read_b32 v2, a83
		v_cvt_pk_f16_f32 v5, v0, v2
		buffer_store_dwordx2 v[4:5], v1, s[16:19], s0 offen offset:2048
		v_accvgpr_read_b32 v0, a84
		v_accvgpr_read_b32 v2, a85
		v_cvt_pk_f16_f32 v4, v0, v2
		v_accvgpr_read_b32 v0, a86
		v_accvgpr_read_b32 v2, a87
		v_cvt_pk_f16_f32 v5, v0, v2
		buffer_store_dwordx2 v[4:5], v1, s[16:19], s0 offen offset:2560
		v_accvgpr_read_b32 v0, a88
		v_accvgpr_read_b32 v2, a89
		v_cvt_pk_f16_f32 v4, v0, v2
		v_accvgpr_read_b32 v0, a90
		v_accvgpr_read_b32 v2, a91
		v_cvt_pk_f16_f32 v5, v0, v2
		buffer_store_dwordx2 v[4:5], v1, s[16:19], s0 offen offset:3072
		v_accvgpr_read_b32 v0, a92
		v_accvgpr_read_b32 v2, a93
		v_cvt_pk_f16_f32 v4, v0, v2
		v_accvgpr_read_b32 v0, a94
		v_accvgpr_read_b32 v2, a95
		v_cvt_pk_f16_f32 v5, v0, v2
		buffer_store_dwordx2 v[4:5], v1, s[16:19], s0 offen offset:3584
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 24576
		.amdhsa_private_segment_fixed_size 540
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
		.amdhsa_next_free_sgpr 49
		.amdhsa_accum_offset 160
		.amdhsa_reserve_vcc 0
		.amdhsa_float_round_mode_32 0
		.amdhsa_float_round_mode_16_64 0
		.amdhsa_float_denorm_mode_32 3
		.amdhsa_float_denorm_mode_16_64 3
		.amdhsa_dx10_clamp 1
		.amdhsa_ieee_mode 1
		.amdhsa_fp16_overflow 0
	.end_amdhsa_kernel
	.text
	.set .Lwmma_f16_matmul_tiled.num_vgpr, 160
	.set .Lwmma_f16_matmul_tiled.num_agpr, 96
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 49
	.set .Lwmma_f16_matmul_tiled.num_named_barrier, 0
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 540
	.set .Lwmma_f16_matmul_tiled.uses_vcc, 0
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
    .max_flat_workgroup_size: 1024
    .name:           wmma_f16_matmul_tiled
    .private_segment_fixed_size: 540
    .sgpr_count:     49
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     256
    .agpr_count:     96
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
