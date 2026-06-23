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
		v_lshrrev_b32_e32 v8, 2, v3
		v_lshlrev_b32_e32 v3, 12, v8
		v_and_b32_e32 v8, 63, v0
		v_lshrrev_b32_e32 v9, 3, v8
		v_and_b32_e32 v8, 3, v9
		v_and_b32_e32 v9, 63, v0
		v_and_b32_e32 v10, 3, v9
		v_xor_b32_e32 v9, v8, v10
		v_lshlrev_b32_e32 v8, 4, v9
		v_add3_u32 v9, v1, v3, v8
		s_add_i32 s10, s9, 0x80000
		v_add_u32_e32 v1, s10, v2
		v_add3_u32 v10, v1, v3, v8
		v_add3_u32 v1, s9, 64, v2
		v_add3_u32 v11, v1, v3, v8
		s_add_i32 s10, s9, 0x80040
		v_add_u32_e32 v1, s10, v2
		v_add3_u32 v12, v1, v3, v8
		s_lshl_b32 s10, s14, 20
		v_add_u32_e32 v1, s10, v2
		v_add3_u32 v13, v1, v3, v8
		s_add_i32 s11, s10, 0x80000
		v_add_u32_e32 v1, s11, v2
		v_add3_u32 v14, v1, v3, v8
		v_add3_u32 v1, s10, 64, v2
		v_add3_u32 v15, v1, v3, v8
		s_add_i32 s11, s10, 0x80040
		v_add_u32_e32 v1, s11, v2
		v_add3_u32 v16, v1, v3, v8
		s_lshr_b32 s11, s8, 6
		s_lshl_b32 s15, s11, 10
		s_mov_b32 m0, s15
		s_nop 0
		buffer_load_dwordx4 v9, s[20:23], 0 offen lds
		s_add_i32 s28, s15, 0x2000
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		s_add_i32 s29, s15, 0x4000
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v11, s[20:23], 0 offen lds
		s_add_i32 s30, s15, 0x6000
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_add_i32 s31, s15, 0x8000
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v13, s[0:3], 0 offen lds
		s_add_i32 s32, s15, 0xa000
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v14, s[0:3], 0 offen lds
		s_add_i32 s33, s15, 0xc000
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v15, s[0:3], 0 offen lds
		s_add_i32 s34, s15, 0xe000
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v16, s[0:3], 0 offen lds
		s_lshl_b32 s35, s14, 16
		s_add_i32 s36, s9, s35
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v9, 9, v1
		v_and_b32_e32 v10, 63, v0
		v_lshlrev_b32_e32 v11, 2, v10
		v_add3_u32 v10, s36, v9, v11
		s_add_i32 s37, s9, 0x100
		s_add_i32 s38, s37, s35
		v_add3_u32 v12, s38, v9, v11
		v_and_b32_e32 v13, 63, v0
		v_lshlrev_b32_e32 v14, 4, v13
		v_accvgpr_read_b32 v13, a0
		v_and_b32_e32 v15, 1, v13
		v_lshlrev_b32_e32 v13, 10, v15
		v_add3_u32 v16, s36, v14, v13
		s_lshr_b32 s36, s8, 7
		s_lshl_b32 s8, s36, 9
		s_add_i32 m0, s8, 0x20000
		s_nop 0
		buffer_load_dword v10, s[4:7], 0 offen lds
		s_add_i32 m0, s8, 0x20100
		s_nop 0
		buffer_load_dword v12, s[4:7], 0 offen lds
		s_and_b32 s36, s11, 1
		s_lshl_b32 s11, s36, 10
		s_add_i32 m0, s11, 0x20800
		s_nop 0
		buffer_load_dwordx4 v16, s[24:27], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v10, 12, v1
		v_and_b32_e32 v1, 15, v0
		v_lshlrev_b32_e32 v12, 6, v1
		v_and_b32_e32 v16, 63, v0
		v_lshrrev_b32_e32 v17, 4, v16
		v_lshrrev_b32_e32 v16, 1, v1
		v_and_b32_e32 v1, 3, v16
		v_xor_b32_e32 v16, v17, v1
		v_lshlrev_b32_e32 v1, 4, v16
		v_add3_u32 v16, v10, v12, v1
		ds_read_b128 v[20:23], v16
		ds_read_b128 v[24:27], v16 offset:1024
		ds_read_b128 v[28:31], v16 offset:2048
		ds_read_b128 v[32:35], v16 offset:3072
		v_lshlrev_b32_e32 v16, 13, v15
		v_add3_u32 v15, v12, v16, v1
		ds_read_b128 v[36:39], v15 offset:32768
		ds_read_b128 v[40:43], v15 offset:33792
		ds_read_b128 v[44:47], v15 offset:34816
		ds_read_b128 v[48:51], v15 offset:35840
		ds_read_b128 v[52:55], v15 offset:36864
		ds_read_b128 v[56:59], v15 offset:37888
		ds_read_b128 v[60:63], v15 offset:38912
		ds_read_b128 v[64:67], v15 offset:39936
		v_add_u32_e32 v15, 0x20000, v9
		v_add_u32_e32 v17, v15, v11
		ds_read_b32 v15, v17
		ds_read_b32 v18, v17 offset:256
		v_add_u32_e32 v17, 0x20000, v11
		v_add_u32_e32 v19, v17, v13
		ds_read_b32 v17, v19 offset:2048
		ds_read_b32 v68, v19 offset:2304
		ds_read_b32 v69, v19 offset:2560
		ds_read_b32 v70, v19 offset:2816
		s_waitcnt lgkmcnt(0)
		s_add_i32 s36, s9, 0x80
		v_add_u32_e32 v19, s36, v2
		v_add3_u32 v71, v19, v3, v8
		s_add_i32 s36, s9, 0x80080
		v_add_u32_e32 v19, s36, v2
		v_add3_u32 v72, v19, v3, v8
		s_add_i32 s36, s9, 0xc0
		v_add_u32_e32 v19, s36, v2
		v_add3_u32 v73, v19, v3, v8
		s_add_i32 s36, s9, 0x800c0
		v_add_u32_e32 v19, s36, v2
		v_add3_u32 v74, v19, v3, v8
		s_add_i32 s36, s10, 0x80
		v_add_u32_e32 v19, s36, v2
		v_add3_u32 v75, v19, v3, v8
		s_add_i32 s36, s10, 0x80080
		v_add_u32_e32 v19, s36, v2
		v_add3_u32 v76, v19, v3, v8
		s_add_i32 s36, s10, 0xc0
		v_add_u32_e32 v19, s36, v2
		v_add3_u32 v77, v19, v3, v8
		s_add_i32 s36, s10, 0x800c0
		v_add_u32_e32 v19, s36, v2
		v_add3_u32 v2, v19, v3, v8
		s_add_i32 s10, s15, 0x10000
		s_mov_b32 m0, s10
		s_nop 0
		buffer_load_dwordx4 v71, s[20:23], 0 offen lds
		s_add_i32 s36, s15, 0x12000
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v72, s[20:23], 0 offen lds
		s_add_i32 s37, s15, 0x14000
		s_mov_b32 m0, s37
		s_nop 0
		buffer_load_dwordx4 v73, s[20:23], 0 offen lds
		s_add_i32 s38, s15, 0x16000
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v74, s[20:23], 0 offen lds
		s_add_i32 s39, s15, 0x18000
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v75, s[0:3], 0 offen lds
		s_add_i32 s40, s15, 0x1a000
		s_mov_b32 m0, s40
		s_nop 0
		buffer_load_dwordx4 v76, s[0:3], 0 offen lds
		s_add_i32 s41, s15, 0x1c000
		s_mov_b32 m0, s41
		s_nop 0
		buffer_load_dwordx4 v77, s[0:3], 0 offen lds
		s_add_i32 s42, s15, 0x1e000
		s_mov_b32 m0, s42
		s_nop 0
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_add_i32 s43, s9, 0x800
		s_add_i32 s44, s43, s35
		v_add3_u32 v2, s44, v9, v11
		s_add_i32 s43, s9, 0x900
		s_add_i32 s9, s43, s35
		v_add3_u32 v3, s9, v9, v11
		v_add3_u32 v8, s44, v14, v13
		s_add_i32 m0, s8, 0x21000
		s_nop 0
		buffer_load_dword v2, s[4:7], 0 offen lds
		s_add_i32 m0, s8, 0x21100
		s_nop 0
		buffer_load_dword v3, s[4:7], 0 offen lds
		s_add_i32 m0, s11, 0x21800
		s_nop 0
		buffer_load_dwordx4 v8, s[24:27], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s9, s12, 1
		v_mov_b32_e32 v2, s9
		s_add_i32 s9, s8, 0x100
		s_add_i32 s35, s11, 0x800
		s_add_i32 s43, s8, 0x1000
		s_add_i32 s44, s8, 0x1100
		s_add_i32 s45, s11, 0x1800
		s_mov_b32 s11, 2
		v_mov_b32_e32 v72, s13
		v_mov_b32_e32 v73, 0
		s_mov_b32 s46, 0x100000
		s_mov_b32 s47, 0
		v_mov_b32_e32 v74, s46
		v_mov_b32_e32 v75, s47
		v_mul_lo_u32 v76, v74, v72
		v_mul_hi_u32 v77, v74, v72
		v_mul_lo_u32 v3, v74, v73
		v_add_u32_e32 v77, v77, v3
		v_mul_lo_u32 v3, v75, v72
		v_add_u32_e32 v77, v77, v3
		s_mov_b32 s46, 1
		s_mov_b32 s47, 0
		v_mov_b32_e32 v78, v0
		v_mov_b32_e32 v79, 0
		v_mov_b32_e32 v80, s46
		v_mov_b32_e32 v81, s47
		v_mul_lo_u32 v82, v80, v78
		v_mul_hi_u32 v83, v80, v78
		v_mul_lo_u32 v3, v80, v79
		v_add_u32_e32 v83, v83, v3
		v_mul_lo_u32 v3, v81, v78
		v_add_u32_e32 v83, v83, v3
		v_lshrrev_b64 v[84:85], 6, v[82:83]
		s_mov_b32 s46, 0x10000
		s_mov_b32 s47, 0
		v_mov_b32_e32 v86, s46
		v_mov_b32_e32 v87, s47
		v_mul_lo_u32 v88, v86, v84
		v_mul_hi_u32 v89, v86, v84
		v_mul_lo_u32 v3, v86, v85
		v_add_u32_e32 v89, v89, v3
		v_mul_lo_u32 v3, v87, v84
		v_add_u32_e32 v89, v89, v3
		v_add_co_u32_e64 v90, vcc, v76, v88
		v_addc_co_u32_e64 v91, vcc, v77, v89, vcc
		v_mov_b32_e32 v3, 63
		v_and_b32_e32 v92, v78, v3
		v_and_b32_e32 v93, v73, v73
		v_mul_lo_u32 v78, v80, v92
		v_mul_hi_u32 v79, v80, v92
		v_mul_lo_u32 v3, v80, v93
		v_add_u32_e32 v79, v79, v3
		v_mul_lo_u32 v3, v81, v92
		v_add_u32_e32 v79, v79, v3
		v_lshrrev_b64 v[80:81], 2, v[78:79]
		s_mov_b32 s46, 0x1000
		s_mov_b32 s47, 0
		v_mov_b32_e32 v94, s46
		v_mov_b32_e32 v95, s47
		v_mul_lo_u32 v96, v94, v80
		v_mul_hi_u32 v97, v94, v80
		v_mul_lo_u32 v3, v94, v81
		v_add_u32_e32 v97, v97, v3
		v_mul_lo_u32 v3, v95, v80
		v_add_u32_e32 v97, v97, v3
		v_add_co_u32_e64 v80, vcc, v90, v96
		v_addc_co_u32_e64 v81, vcc, v91, v97, vcc
		v_lshrrev_b64 v[90:91], 3, v[78:79]
		v_mov_b32_e32 v3, 3
		v_and_b32_e32 v78, v90, v3
		v_and_b32_e32 v79, v91, v73
		v_and_b32_e32 v90, v92, v3
		v_and_b32_e32 v91, v93, v73
		v_xor_b32_e32 v94, v78, v90
		v_xor_b32_e32 v95, v79, v91
		s_mov_b32 s46, 16
		s_mov_b32 s47, 0
		v_mov_b32_e32 v78, s46
		v_mov_b32_e32 v79, s47
		v_mul_lo_u32 v90, v78, v94
		v_mul_hi_u32 v91, v78, v94
		v_mul_lo_u32 v3, v78, v95
		v_add_u32_e32 v91, v91, v3
		v_mul_lo_u32 v3, v79, v94
		v_add_u32_e32 v91, v91, v3
		v_add_co_u32_e64 v94, vcc, v80, v90
		v_addc_co_u32_e64 v95, vcc, v81, v91, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v94, s46 offset:44
		scratch_store_dword off, v95, s46 offset:48
		s_mov_b32 s46, 0x80
		s_mov_b32 s47, 0
		v_mov_b32_e32 v80, s46
		v_mov_b32_e32 v81, s47
		v_mov_b32_e32 v3, 0x80000
		v_add_co_u32_e64 v94, vcc, v76, v3
		v_addc_co_u32_e64 v95, vcc, v77, 0, vcc
		v_add_co_u32_e64 v98, vcc, v94, v88
		v_addc_co_u32_e64 v99, vcc, v95, v89, vcc
		v_add_co_u32_e64 v94, vcc, v98, v96
		v_addc_co_u32_e64 v95, vcc, v99, v97, vcc
		v_add_co_u32_e64 v98, vcc, v94, v90
		v_addc_co_u32_e64 v99, vcc, v95, v91, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v98, s46 offset:52
		scratch_store_dword off, v99, s46 offset:56
		v_mov_b32_e32 v8, 64
		v_add_co_u32_e64 v94, vcc, v76, v8
		v_addc_co_u32_e64 v95, vcc, v77, 0, vcc
		v_add_co_u32_e64 v98, vcc, v94, v88
		v_addc_co_u32_e64 v99, vcc, v95, v89, vcc
		v_add_co_u32_e64 v94, vcc, v98, v96
		v_addc_co_u32_e64 v95, vcc, v99, v97, vcc
		v_add_co_u32_e64 v98, vcc, v94, v90
		v_addc_co_u32_e64 v99, vcc, v95, v91, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v98, s46 offset:60
		scratch_store_dword off, v99, s46 offset:64
		v_mov_b32_e32 v14, 0x80040
		v_add_co_u32_e64 v94, vcc, v76, v14
		v_addc_co_u32_e64 v95, vcc, v77, 0, vcc
		v_add_co_u32_e64 v98, vcc, v94, v88
		v_addc_co_u32_e64 v99, vcc, v95, v89, vcc
		v_add_co_u32_e64 v94, vcc, v98, v96
		v_addc_co_u32_e64 v95, vcc, v99, v97, vcc
		v_add_co_u32_e64 v98, vcc, v94, v90
		v_addc_co_u32_e64 v99, vcc, v95, v91, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v98, s46 offset:68
		scratch_store_dword off, v99, s46 offset:72
		v_mov_b32_e32 v94, s14
		v_mov_b32_e32 v95, 0
		v_mul_lo_u32 v98, v74, v94
		v_mul_hi_u32 v99, v74, v94
		v_mul_lo_u32 v19, v74, v95
		v_add_u32_e32 v99, v99, v19
		v_mul_lo_u32 v19, v75, v94
		v_add_u32_e32 v99, v99, v19
		v_add_co_u32_e64 v74, vcc, v98, v88
		v_addc_co_u32_e64 v75, vcc, v99, v89, vcc
		v_add_co_u32_e64 v100, vcc, v74, v96
		v_addc_co_u32_e64 v101, vcc, v75, v97, vcc
		v_add_co_u32_e64 v74, vcc, v100, v90
		v_addc_co_u32_e64 v75, vcc, v101, v91, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v74, s46 offset:76
		scratch_store_dword off, v75, s46 offset:80
		v_add_co_u32_e64 v74, vcc, v98, v3
		v_addc_co_u32_e64 v75, vcc, v99, 0, vcc
		v_add_co_u32_e64 v100, vcc, v74, v88
		v_addc_co_u32_e64 v101, vcc, v75, v89, vcc
		v_add_co_u32_e64 v74, vcc, v100, v96
		v_addc_co_u32_e64 v75, vcc, v101, v97, vcc
		v_add_co_u32_e64 v100, vcc, v74, v90
		v_addc_co_u32_e64 v101, vcc, v75, v91, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v100, s46 offset:84
		scratch_store_dword off, v101, s46 offset:88
		v_add_co_u32_e64 v74, vcc, v98, v8
		v_addc_co_u32_e64 v75, vcc, v99, 0, vcc
		v_add_co_u32_e64 v100, vcc, v74, v88
		v_addc_co_u32_e64 v101, vcc, v75, v89, vcc
		v_add_co_u32_e64 v74, vcc, v100, v96
		v_addc_co_u32_e64 v75, vcc, v101, v97, vcc
		v_add_co_u32_e64 v100, vcc, v74, v90
		v_addc_co_u32_e64 v101, vcc, v75, v91, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v100, s46 offset:92
		scratch_store_dword off, v101, s46 offset:96
		v_add_co_u32_e64 v74, vcc, v98, v14
		v_addc_co_u32_e64 v75, vcc, v99, 0, vcc
		v_add_co_u32_e64 v98, vcc, v74, v88
		v_addc_co_u32_e64 v99, vcc, v75, v89, vcc
		v_add_co_u32_e64 v74, vcc, v98, v96
		v_addc_co_u32_e64 v75, vcc, v99, v97, vcc
		v_add_co_u32_e64 v88, vcc, v74, v90
		v_addc_co_u32_e64 v89, vcc, v75, v91, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v88, s46 offset:100
		scratch_store_dword off, v89, s46 offset:104
		v_mul_lo_u32 v74, v86, v94
		v_mul_hi_u32 v75, v86, v94
		v_mul_lo_u32 v3, v86, v95
		v_add_u32_e32 v75, v75, v3
		v_mul_lo_u32 v3, v87, v94
		v_add_u32_e32 v75, v75, v3
		v_add_co_u32_e64 v86, vcc, v76, v74
		v_addc_co_u32_e64 v87, vcc, v77, v75, vcc
		v_lshrrev_b64 v[88:89], 7, v[82:83]
		s_mov_b32 s46, 0x200
		s_mov_b32 s47, 0
		v_mov_b32_e32 v82, s46
		v_mov_b32_e32 v83, s47
		v_mul_lo_u32 v90, v82, v88
		v_mul_hi_u32 v91, v82, v88
		v_mul_lo_u32 v3, v82, v89
		v_add_u32_e32 v91, v91, v3
		v_mul_lo_u32 v3, v83, v88
		v_add_u32_e32 v91, v91, v3
		v_add_co_u32_e64 v82, vcc, v86, v90
		v_addc_co_u32_e64 v83, vcc, v87, v91, vcc
		s_mov_b32 s46, 4
		s_mov_b32 s47, 0
		v_mov_b32_e32 v88, s46
		v_mov_b32_e32 v89, s47
		v_mul_lo_u32 v94, v88, v92
		v_mul_hi_u32 v95, v88, v92
		v_mul_lo_u32 v3, v88, v93
		v_add_u32_e32 v95, v95, v3
		v_mul_lo_u32 v3, v89, v92
		v_add_u32_e32 v95, v95, v3
		v_add_co_u32_e64 v88, vcc, v82, v94
		v_addc_co_u32_e64 v89, vcc, v83, v95, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v88, s46 offset:108
		scratch_store_dword off, v89, s46 offset:112
		s_mov_b32 s46, 0x800
		s_mov_b32 s47, 0
		v_mov_b32_e32 v82, s46
		v_mov_b32_e32 v83, s47
		v_mov_b32_e32 v3, 0x100
		v_add_co_u32_e64 v88, vcc, v76, v3
		v_addc_co_u32_e64 v89, vcc, v77, 0, vcc
		v_add_co_u32_e64 v76, vcc, v88, v74
		v_addc_co_u32_e64 v77, vcc, v89, v75, vcc
		v_add_co_u32_e64 v74, vcc, v76, v90
		v_addc_co_u32_e64 v75, vcc, v77, v91, vcc
		v_add_co_u32_e64 v76, vcc, v74, v94
		v_addc_co_u32_e64 v77, vcc, v75, v95, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v76, s46 offset:116
		scratch_store_dword off, v77, s46 offset:120
		v_mul_lo_u32 v74, v78, v92
		v_mul_hi_u32 v75, v78, v92
		v_mul_lo_u32 v3, v78, v93
		v_add_u32_e32 v75, v75, v3
		v_mul_lo_u32 v3, v79, v92
		v_add_u32_e32 v75, v75, v3
		v_add_co_u32_e64 v76, vcc, v86, v74
		v_addc_co_u32_e64 v77, vcc, v87, v75, vcc
		v_mov_b32_e32 v3, 1
		v_and_b32_e32 v74, v84, v3
		v_and_b32_e32 v75, v85, v73
		s_mov_b32 s46, 0x400
		s_mov_b32 s47, 0
		v_mov_b32_e32 v72, s46
		v_mov_b32_e32 v73, s47
		v_mul_lo_u32 v78, v72, v74
		v_mul_hi_u32 v79, v72, v74
		v_mul_lo_u32 v3, v72, v75
		v_add_u32_e32 v79, v79, v3
		v_mul_lo_u32 v3, v73, v74
		v_add_u32_e32 v79, v79, v3
		v_add_co_u32_e64 v72, vcc, v76, v78
		v_addc_co_u32_e64 v73, vcc, v77, v79, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v72, s46 offset:124
		scratch_store_dword off, v73, s46 offset:128
		v_mov_b64_e32 v[72:73], 0
		v_mov_b64_e32 v[74:75], 0
		v_mov_b64_e32 v[76:77], 0
		v_mov_b64_e32 v[78:79], 0
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_mov_b64_e32 v[96:97], 0
		v_mov_b64_e32 v[98:99], 0
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
		v_mov_b64_e32 v[104:105], 0
		v_mov_b64_e32 v[106:107], 0
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
		s_mov_b32 s46, 0
		scratch_store_dword off, v148, s46 offset:392
		scratch_store_dword off, v149, s46 offset:396
		scratch_store_dword off, v150, s46 offset:400
		scratch_store_dword off, v151, s46 offset:404
		v_mov_b64_e32 v[148:149], 0
		v_mov_b64_e32 v[150:151], 0
		s_mov_b32 s46, 0
		scratch_store_dword off, v148, s46 offset:376
		scratch_store_dword off, v149, s46 offset:380
		scratch_store_dword off, v150, s46 offset:384
		scratch_store_dword off, v151, s46 offset:388
		v_mov_b64_e32 v[148:149], 0
		v_mov_b64_e32 v[150:151], 0
		s_mov_b32 s46, 0
		scratch_store_dword off, v148, s46 offset:360
		scratch_store_dword off, v149, s46 offset:364
		scratch_store_dword off, v150, s46 offset:368
		scratch_store_dword off, v151, s46 offset:372
		v_mov_b64_e32 v[148:149], 0
		v_mov_b64_e32 v[150:151], 0
		s_mov_b32 s46, 0
		scratch_store_dword off, v148, s46 offset:344
		scratch_store_dword off, v149, s46 offset:348
		scratch_store_dword off, v150, s46 offset:352
		scratch_store_dword off, v151, s46 offset:356
		v_mov_b64_e32 v[148:149], 0
		v_mov_b64_e32 v[150:151], 0
		s_mov_b32 s46, 0
		scratch_store_dword off, v148, s46 offset:328
		scratch_store_dword off, v149, s46 offset:332
		scratch_store_dword off, v150, s46 offset:336
		scratch_store_dword off, v151, s46 offset:340
		v_mov_b64_e32 v[148:149], 0
		v_mov_b64_e32 v[150:151], 0
		s_mov_b32 s46, 0
		scratch_store_dword off, v148, s46 offset:312
		scratch_store_dword off, v149, s46 offset:316
		scratch_store_dword off, v150, s46 offset:320
		scratch_store_dword off, v151, s46 offset:324
		v_mov_b64_e32 v[148:149], 0
		v_mov_b64_e32 v[150:151], 0
		s_mov_b32 s46, 0
		scratch_store_dword off, v148, s46 offset:296
		scratch_store_dword off, v149, s46 offset:300
		scratch_store_dword off, v150, s46 offset:304
		scratch_store_dword off, v151, s46 offset:308
		v_mov_b64_e32 v[148:149], 0
		v_mov_b64_e32 v[150:151], 0
		s_mov_b32 s46, 0
		scratch_store_dword off, v148, s46 offset:280
		scratch_store_dword off, v149, s46 offset:284
		scratch_store_dword off, v150, s46 offset:288
		scratch_store_dword off, v151, s46 offset:292
		v_mov_b64_e32 v[148:149], 0
		v_mov_b64_e32 v[150:151], 0
		s_mov_b32 s46, 0
		scratch_store_dword off, v148, s46 offset:264
		scratch_store_dword off, v149, s46 offset:268
		scratch_store_dword off, v150, s46 offset:272
		scratch_store_dword off, v151, s46 offset:276
		v_mov_b64_e32 v[148:149], 0
		v_mov_b64_e32 v[150:151], 0
		s_mov_b32 s46, 0
		scratch_store_dword off, v148, s46 offset:248
		scratch_store_dword off, v149, s46 offset:252
		scratch_store_dword off, v150, s46 offset:256
		scratch_store_dword off, v151, s46 offset:260
		v_mov_b64_e32 v[148:149], 0
		v_mov_b64_e32 v[150:151], 0
		s_mov_b32 s46, 0
		scratch_store_dword off, v148, s46 offset:188
		scratch_store_dword off, v149, s46 offset:192
		scratch_store_dword off, v150, s46 offset:196
		scratch_store_dword off, v151, s46 offset:200
		v_mov_b64_e32 v[148:149], 0
		v_mov_b64_e32 v[150:151], 0
		s_mov_b32 s46, 0
		scratch_store_dword off, v148, s46 offset:164
		scratch_store_dword off, v149, s46 offset:168
		scratch_store_dword off, v150, s46 offset:172
		scratch_store_dword off, v151, s46 offset:176
		v_mov_b64_e32 v[148:149], 0
		v_mov_b64_e32 v[150:151], 0
		s_mov_b32 s46, 0
		scratch_store_dword off, v148, s46 offset:148
		scratch_store_dword off, v149, s46 offset:152
		scratch_store_dword off, v150, s46 offset:156
		scratch_store_dword off, v151, s46 offset:160
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_add_i32 s46, s11, -2
		s_add_i32 s47, s11, -1
		v_mov_b32_e32 v3, s47
		v_mov_b32_e32 v148, s11
		v_mov_b32_e32 v149, 0
		v_mul_lo_u32 v150, v80, v148
		v_mul_hi_u32 v151, v80, v148
		v_mul_lo_u32 v8, v80, v149
		v_add_u32_e32 v151, v151, v8
		v_mul_lo_u32 v8, v81, v148
		v_add_u32_e32 v151, v151, v8
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(63) expcnt(7) lgkmcnt(15)
		scratch_load_dword v152, off, s47 offset:44
		scratch_load_dword v153, off, s47 offset:48
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v154, vcc, v152, v150
		v_addc_co_u32_e64 v155, vcc, v153, v151, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v154, s47 offset:40
		s_mov_b32 s47, 0
		scratch_load_dword v152, off, s47 offset:52
		scratch_load_dword v153, off, s47 offset:56
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v154, vcc, v152, v150
		v_addc_co_u32_e64 v155, vcc, v153, v151, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v154, s47 offset:36
		s_mov_b32 s47, 0
		scratch_load_dword v152, off, s47 offset:60
		scratch_load_dword v153, off, s47 offset:64
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v154, vcc, v152, v150
		v_addc_co_u32_e64 v155, vcc, v153, v151, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v154, s47 offset:32
		s_mov_b32 s47, 0
		scratch_load_dword v152, off, s47 offset:68
		scratch_load_dword v153, off, s47 offset:72
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v154, vcc, v152, v150
		v_addc_co_u32_e64 v155, vcc, v153, v151, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v154, s47 offset:28
		s_mov_b32 s47, 0
		scratch_load_dword v152, off, s47 offset:76
		scratch_load_dword v153, off, s47 offset:80
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v154, vcc, v152, v150
		v_addc_co_u32_e64 v155, vcc, v153, v151, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v154, s47 offset:24
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(63) expcnt(7) lgkmcnt(15)
		scratch_load_dword v152, off, s47 offset:84
		scratch_load_dword v153, off, s47 offset:88
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v154, vcc, v152, v150
		v_addc_co_u32_e64 v155, vcc, v153, v151, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v154, s47 offset:20
		s_mov_b32 s47, 0
		scratch_load_dword v152, off, s47 offset:92
		scratch_load_dword v153, off, s47 offset:96
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v154, vcc, v152, v150
		v_addc_co_u32_e64 v155, vcc, v153, v151, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v154, s47 offset:16
		s_mov_b32 s47, 0
		scratch_load_dword v152, off, s47 offset:100
		scratch_load_dword v153, off, s47 offset:104
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v154, vcc, v152, v150
		v_addc_co_u32_e64 v155, vcc, v153, v151, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v154, s47 offset:12
		v_mul_lo_u32 v150, v82, v148
		v_mul_hi_u32 v151, v82, v148
		v_mul_lo_u32 v8, v82, v149
		v_add_u32_e32 v151, v151, v8
		v_mul_lo_u32 v8, v83, v148
		v_add_u32_e32 v151, v151, v8
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(63) expcnt(7) lgkmcnt(15)
		scratch_load_dword v148, off, s47 offset:108
		scratch_load_dword v149, off, s47 offset:112
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v152, vcc, v148, v150
		v_addc_co_u32_e64 v153, vcc, v149, v151, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v152, s47 offset:8
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(63) expcnt(7) lgkmcnt(15)
		scratch_load_dword v148, off, s47 offset:116
		scratch_load_dword v149, off, s47 offset:120
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v152, vcc, v148, v150
		v_addc_co_u32_e64 v153, vcc, v149, v151, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v152, s47 offset:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(62)
		scratch_load_dword v148, off, s47 offset:124
		scratch_load_dword v149, off, s47 offset:128
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v152, vcc, v148, v150
		v_addc_co_u32_e64 v153, vcc, v149, v151, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v152, s47
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[20:23], v[36:39], v[4:7], v15, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s47, s46, 1
		s_lshl_b32 s46, s47, 16
		v_mov_b32_e32 v8, s46
		s_nop 0
		v_readfirstlane_b32 s46, v8
		s_nop 1
		v_add_u32_e32 v14, s46, v10
		v_add3_u32 v19, v14, v12, v1
		ds_read_b128 v[148:151], v19 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[20:23], v[40:43], v[72:75], v15, v17 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[152:155], v19 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[20:23], v[44:47], v[76:79], v15, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[156:159], v19 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[20:23], v[48:51], v[84:87], v15, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[160:163], v19 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[20:23], v[52:55], v[88:91], v15, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_readfirstlane_b32 s46, v8
		s_nop 1
		v_add_u32_e32 v8, s46, v12
		v_add3_u32 v14, v8, v16, v1
		ds_read_b128 v[164:167], v14 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[20:23], v[56:59], v[92:95], v15, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[168:171], v14 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[20:23], v[60:63], v[96:99], v15, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[172:175], v14 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[20:23], v[64:67], v[100:103], v15, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[176:179], v14 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[24:27], v[36:39], v[104:107], v15, v17 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[180:183], v14 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[24:27], v[40:43], v[108:111], v15, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[184:187], v14 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[24:27], v[44:47], v[112:115], v15, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[188:191], v14 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[24:27], v[48:51], v[116:119], v15, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[192:195], v14 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[24:27], v[52:55], v[120:123], v15, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(10)
		scratch_load_dword v8, off, s46 offset:40
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[24:27], v[56:59], v[124:127], v15, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s28
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(9)
		scratch_load_dword v8, off, s46 offset:36
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[24:27], v[60:63], v[128:131], v15, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s29
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v8, off, s46 offset:32
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[24:27], v[64:67], v[132:135], v15, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s30
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(7)
		scratch_load_dword v8, off, s46 offset:28
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[28:31], v[36:39], v[136:139], v18, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s31
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(6)
		scratch_load_dword v8, off, s46 offset:24
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v8, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[28:31], v[40:43], v[140:143], v18, v17 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s32
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(5)
		scratch_load_dword v8, off, s46 offset:20
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v8, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[28:31], v[44:47], v[144:147], v18, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s33
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v8, off, s46 offset:16
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v8, s[0:3], 0 offen lds
		s_mov_b32 s46, 0
		scratch_load_dword v196, off, s46 offset:392
		scratch_load_dword v197, off, s46 offset:396
		scratch_load_dword v198, off, s46 offset:400
		scratch_load_dword v199, off, s46 offset:404
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], v[48:51], v[196:199], v18, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s34
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(3)
		scratch_load_dword v8, off, s46 offset:12
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v8, s[0:3], 0 offen lds
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:376
		scratch_load_dword v201, off, s46 offset:380
		scratch_load_dword v202, off, s46 offset:384
		scratch_load_dword v203, off, s46 offset:388
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[28:31], v[52:55], v[200:203], v18, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s8, 0x20000
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(2)
		scratch_load_dword v8, off, s46 offset:8
		s_waitcnt vmcnt(0)
		buffer_load_dword v8, s[4:7], 0 offen lds
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:360
		scratch_load_dword v205, off, s46 offset:364
		scratch_load_dword v206, off, s46 offset:368
		scratch_load_dword v207, off, s46 offset:372
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[28:31], v[56:59], v[204:207], v18, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s9, 0x20000
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(1)
		scratch_load_dword v8, off, s46 offset:4
		s_waitcnt vmcnt(0)
		buffer_load_dword v8, s[4:7], 0 offen lds
		s_mov_b32 s46, 0
		scratch_load_dword v208, off, s46 offset:344
		scratch_load_dword v209, off, s46 offset:348
		scratch_load_dword v210, off, s46 offset:352
		scratch_load_dword v211, off, s46 offset:356
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[28:31], v[60:63], v[208:211], v18, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s35, 0x20000
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v8, off, s46
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v8, s[24:27], 0 offen lds
		s_mov_b32 s46, 0
		scratch_load_dword v212, off, s46 offset:328
		scratch_load_dword v213, off, s46 offset:332
		scratch_load_dword v214, off, s46 offset:336
		scratch_load_dword v215, off, s46 offset:340
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[64:67], v[212:215], v18, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_and_b32 s46, s11, 1
		s_lshl_b32 s47, s46, 16
		v_add_u32_e32 v8, s47, v10
		v_add3_u32 v14, v8, v12, v1
		ds_read_b128 v[20:23], v14
		s_mov_b32 s48, 0
		scratch_load_dword v216, off, s48 offset:312
		scratch_load_dword v217, off, s48 offset:316
		scratch_load_dword v218, off, s48 offset:320
		scratch_load_dword v219, off, s48 offset:324
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[36:39], v[216:219], v18, v17 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v14 offset:1024
		s_mov_b32 s48, 0
		scratch_load_dword v220, off, s48 offset:296
		scratch_load_dword v221, off, s48 offset:300
		scratch_load_dword v222, off, s48 offset:304
		scratch_load_dword v223, off, s48 offset:308
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], v[40:43], v[220:223], v18, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[28:31], v14 offset:2048
		s_mov_b32 s48, 0
		scratch_load_dword v224, off, s48 offset:280
		scratch_load_dword v225, off, s48 offset:284
		scratch_load_dword v226, off, s48 offset:288
		scratch_load_dword v227, off, s48 offset:292
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[32:35], v[44:47], v[224:227], v18, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v14 offset:3072
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s48 offset:132
		scratch_store_dword off, v229, s48 offset:136
		scratch_store_dword off, v230, s48 offset:140
		scratch_store_dword off, v231, s48 offset:144
		s_mov_b32 s48, 0
		scratch_load_dword v228, off, s48 offset:264
		scratch_load_dword v229, off, s48 offset:268
		scratch_load_dword v230, off, s48 offset:272
		scratch_load_dword v231, off, s48 offset:276
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], v[48:51], v[228:231], v18, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v8, s47, v12
		v_add3_u32 v14, v8, v16, v1
		ds_read_b128 v[36:39], v14 offset:32768
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:248
		scratch_load_dword v233, off, s47 offset:252
		scratch_load_dword v234, off, s47 offset:256
		scratch_load_dword v235, off, s47 offset:260
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[32:35], v[52:55], v[232:235], v18, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[40:43], v14 offset:33792
		s_mov_b32 s47, 0
		scratch_load_dword v236, off, s47 offset:188
		scratch_load_dword v237, off, s47 offset:192
		scratch_load_dword v238, off, s47 offset:196
		scratch_load_dword v239, off, s47 offset:200
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[32:35], v[56:59], v[236:239], v18, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[44:47], v14 offset:34816
		s_mov_b32 s47, 0
		scratch_load_dword v240, off, s47 offset:164
		scratch_load_dword v241, off, s47 offset:168
		scratch_load_dword v242, off, s47 offset:172
		scratch_load_dword v243, off, s47 offset:176
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[32:35], v[60:63], v[240:243], v18, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[48:51], v14 offset:35840
		s_mov_b32 s47, 0
		scratch_load_dword v244, off, s47 offset:148
		scratch_load_dword v245, off, s47 offset:152
		scratch_load_dword v246, off, s47 offset:156
		scratch_load_dword v247, off, s47 offset:160
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[32:35], v[64:67], v[244:247], v18, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[52:55], v14 offset:36864
		ds_read_b128 v[56:59], v14 offset:37888
		ds_read_b128 v[60:63], v14 offset:38912
		ds_read_b128 v[64:67], v14 offset:39936
		s_lshl_b32 s47, s46, 12
		s_add_i32 s46, s47, 0x20000
		v_add3_u32 v8, s46, v9, v11
		ds_read_b32 v14, v8
		ds_read_b32 v19, v8 offset:256
		v_add3_u32 v8, s46, v11, v13
		ds_read_b32 v71, v8 offset:2048
		ds_read_b32 v248, v8 offset:2304
		ds_read_b32 v249, v8 offset:2560
		ds_read_b32 v250, v8 offset:2816
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[148:151], v[164:167], v[4:7], v15, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[148:151], v[168:171], v[72:75], v15, v17 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[148:151], v[172:175], v[76:79], v15, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[148:151], v[176:179], v[84:87], v15, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[148:151], v[180:183], v[88:91], v15, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[148:151], v[184:187], v[92:95], v15, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[148:151], v[188:191], v[96:99], v15, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[148:151], v[192:195], v[100:103], v15, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[152:155], v[164:167], v[104:107], v15, v17 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[152:155], v[168:171], v[108:111], v15, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[152:155], v[172:175], v[112:115], v15, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[152:155], v[176:179], v[116:119], v15, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[152:155], v[180:183], v[120:123], v15, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[152:155], v[184:187], v[124:127], v15, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[152:155], v[188:191], v[128:131], v15, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[152:155], v[192:195], v[132:135], v15, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[156:159], v[164:167], v[136:139], v18, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[156:159], v[168:171], v[140:143], v18, v17 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[156:159], v[172:175], v[144:147], v18, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[156:159], v[176:179], v[196:199], v18, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v196, s46 offset:600
		scratch_store_dword off, v197, s46 offset:604
		scratch_store_dword off, v198, s46 offset:608
		scratch_store_dword off, v199, s46 offset:612
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[156:159], v[180:183], v[200:203], v18, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v200, s46 offset:584
		scratch_store_dword off, v201, s46 offset:588
		scratch_store_dword off, v202, s46 offset:592
		scratch_store_dword off, v203, s46 offset:596
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[156:159], v[184:187], v[204:207], v18, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v204, s46 offset:568
		scratch_store_dword off, v205, s46 offset:572
		scratch_store_dword off, v206, s46 offset:576
		scratch_store_dword off, v207, s46 offset:580
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[156:159], v[188:191], v[208:211], v18, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v208, s46 offset:552
		scratch_store_dword off, v209, s46 offset:556
		scratch_store_dword off, v210, s46 offset:560
		scratch_store_dword off, v211, s46 offset:564
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[156:159], v[192:195], v[212:215], v18, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v212, s46 offset:536
		scratch_store_dword off, v213, s46 offset:540
		scratch_store_dword off, v214, s46 offset:544
		scratch_store_dword off, v215, s46 offset:548
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[160:163], v[164:167], v[216:219], v18, v17 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v216, s46 offset:520
		scratch_store_dword off, v217, s46 offset:524
		scratch_store_dword off, v218, s46 offset:528
		scratch_store_dword off, v219, s46 offset:532
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[160:163], v[168:171], v[220:223], v18, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v220, s46 offset:504
		scratch_store_dword off, v221, s46 offset:508
		scratch_store_dword off, v222, s46 offset:512
		scratch_store_dword off, v223, s46 offset:516
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[160:163], v[172:175], v[224:227], v18, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v224, s46 offset:488
		scratch_store_dword off, v225, s46 offset:492
		scratch_store_dword off, v226, s46 offset:496
		scratch_store_dword off, v227, s46 offset:500
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[160:163], v[176:179], v[228:231], v18, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v228, s46 offset:472
		scratch_store_dword off, v229, s46 offset:476
		scratch_store_dword off, v230, s46 offset:480
		scratch_store_dword off, v231, s46 offset:484
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[160:163], v[180:183], v[232:235], v18, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v232, s46 offset:456
		scratch_store_dword off, v233, s46 offset:460
		scratch_store_dword off, v234, s46 offset:464
		scratch_store_dword off, v235, s46 offset:468
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[160:163], v[184:187], v[236:239], v18, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v236, s46 offset:440
		scratch_store_dword off, v237, s46 offset:444
		scratch_store_dword off, v238, s46 offset:448
		scratch_store_dword off, v239, s46 offset:452
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[160:163], v[188:191], v[240:243], v18, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v240, s46 offset:424
		scratch_store_dword off, v241, s46 offset:428
		scratch_store_dword off, v242, s46 offset:432
		scratch_store_dword off, v243, s46 offset:436
		v_mfma_scale_f32_16x16x128_f8f6f4 v[244:247], v[160:163], v[192:195], v[244:247], v18, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v244, s46 offset:408
		scratch_store_dword off, v245, s46 offset:412
		scratch_store_dword off, v246, s46 offset:416
		scratch_store_dword off, v247, s46 offset:420
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s46, v3
		s_and_b32 s47, s46, 1
		s_lshl_b32 s46, s47, 16
		v_add_u32_e32 v3, s46, v10
		v_add3_u32 v8, v3, v12, v1
		ds_read_b128 v[148:151], v8
		ds_read_b128 v[152:155], v8 offset:1024
		ds_read_b128 v[156:159], v8 offset:2048
		ds_read_b128 v[160:163], v8 offset:3072
		v_add_u32_e32 v3, s46, v12
		v_add3_u32 v164, v3, v16, v1
		ds_read_b128 v[168:171], v164 offset:32768
		ds_read_b128 v[172:175], v164 offset:33792
		ds_read_b128 v[176:179], v164 offset:34816
		ds_read_b128 v[180:183], v164 offset:35840
		ds_read_b128 v[184:187], v164 offset:36864
		ds_read_b128 v[188:191], v164 offset:37888
		ds_read_b128 v[192:195], v164 offset:38912
		ds_read_b128 v[196:199], v164 offset:39936
		s_lshl_b32 s46, s47, 12
		s_add_i32 s47, s46, 0x20000
		v_add3_u32 v3, s47, v9, v11
		ds_read_b32 v165, v3
		ds_read_b32 v166, v3 offset:256
		v_add3_u32 v3, s47, v11, v13
		ds_read_b32 v167, v3 offset:2048
		ds_read_b32 v200, v3 offset:2304
		ds_read_b32 v201, v3 offset:2560
		ds_read_b32 v202, v3 offset:2816
		s_waitcnt lgkmcnt(0)
		s_add_i32 s46, s11, 1
		v_mov_b32_e32 v204, s46
		v_mov_b32_e32 v205, 0
		s_mov_b32 s46, 0
		scratch_store_dword off, v204, s46 offset:180
		scratch_store_dword off, v205, s46 offset:184
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v204, off, s46 offset:180
		scratch_load_dword v205, off, s46 offset:184
		s_waitcnt vmcnt(0)
		v_mul_lo_u32 v206, v80, v204
		v_mul_hi_u32 v207, v80, v204
		v_mul_lo_u32 v3, v80, v205
		v_add_u32_e32 v207, v207, v3
		v_mul_lo_u32 v3, v81, v204
		v_add_u32_e32 v207, v207, v3
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:44
		scratch_load_dword v205, off, s46 offset:48
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v208, vcc, v204, v206
		v_addc_co_u32_e64 v209, vcc, v205, v207, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v208, s46 offset:244
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:52
		scratch_load_dword v205, off, s46 offset:56
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v208, vcc, v204, v206
		v_addc_co_u32_e64 v209, vcc, v205, v207, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v208, s46 offset:204
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:60
		scratch_load_dword v205, off, s46 offset:64
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v208, vcc, v204, v206
		v_addc_co_u32_e64 v209, vcc, v205, v207, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v208, s46 offset:208
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:68
		scratch_load_dword v205, off, s46 offset:72
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v208, vcc, v204, v206
		v_addc_co_u32_e64 v209, vcc, v205, v207, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v208, s46 offset:212
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:76
		scratch_load_dword v205, off, s46 offset:80
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v208, vcc, v204, v206
		v_addc_co_u32_e64 v209, vcc, v205, v207, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v208, s46 offset:216
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:84
		scratch_load_dword v205, off, s46 offset:88
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v208, vcc, v204, v206
		v_addc_co_u32_e64 v209, vcc, v205, v207, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v208, s46 offset:220
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:92
		scratch_load_dword v205, off, s46 offset:96
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v208, vcc, v204, v206
		v_addc_co_u32_e64 v209, vcc, v205, v207, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v208, s46 offset:224
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:100
		scratch_load_dword v205, off, s46 offset:104
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v208, vcc, v204, v206
		v_addc_co_u32_e64 v209, vcc, v205, v207, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v208, s46 offset:228
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:180
		scratch_load_dword v205, off, s46 offset:184
		s_waitcnt vmcnt(0)
		v_mul_lo_u32 v206, v82, v204
		v_mul_hi_u32 v207, v82, v204
		v_mul_lo_u32 v3, v82, v205
		v_add_u32_e32 v207, v207, v3
		v_mul_lo_u32 v3, v83, v204
		v_add_u32_e32 v207, v207, v3
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:108
		scratch_load_dword v205, off, s46 offset:112
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v208, vcc, v204, v206
		v_addc_co_u32_e64 v209, vcc, v205, v207, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v208, s46 offset:232
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:116
		scratch_load_dword v205, off, s46 offset:120
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v208, vcc, v204, v206
		v_addc_co_u32_e64 v209, vcc, v205, v207, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v208, s46 offset:236
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:124
		scratch_load_dword v205, off, s46 offset:128
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v208, vcc, v204, v206
		v_addc_co_u32_e64 v209, vcc, v205, v207, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v208, s46 offset:240
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[148:151], v[168:171], v[4:7], v165, v167 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[204:207], v8 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[148:151], v[172:175], v[72:75], v165, v167 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[208:211], v8 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[148:151], v[176:179], v[76:79], v165, v200 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[212:215], v8 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[148:151], v[180:183], v[84:87], v165, v200 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v8 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[148:151], v[184:187], v[88:91], v165, v201 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v164 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[148:151], v[188:191], v[92:95], v165, v201 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v164 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[148:151], v[192:195], v[96:99], v165, v202 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v164 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[148:151], v[196:199], v[100:103], v165, v202 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[148:151], v164 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[152:155], v[168:171], v[104:107], v165, v167 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[232:235], v164 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[152:155], v[172:175], v[108:111], v165, v167 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[236:239], v164 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[152:155], v[176:179], v[112:115], v165, v200 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v164 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[152:155], v[180:183], v[116:119], v165, v200 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[244:247], v164 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[152:155], v[184:187], v[120:123], v165, v201 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s10
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(10)
		scratch_load_dword v3, off, s46 offset:244
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[152:155], v[188:191], v[124:127], v165, v201 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s36
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(9)
		scratch_load_dword v3, off, s46 offset:204
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[152:155], v[192:195], v[128:131], v165, v202 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s37
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v3, off, s46 offset:208
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[152:155], v[196:199], v[132:135], v165, v202 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s38
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(7)
		scratch_load_dword v3, off, s46 offset:212
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[156:159], v[168:171], v[136:139], v166, v167 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s39
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(6)
		scratch_load_dword v3, off, s46 offset:216
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[156:159], v[172:175], v[140:143], v166, v167 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s40
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(5)
		scratch_load_dword v3, off, s46 offset:220
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[156:159], v[176:179], v[144:147], v166, v200 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s41
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v3, off, s46 offset:224
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		s_mov_b32 s46, 0
		scratch_load_dword v152, off, s46 offset:600
		scratch_load_dword v153, off, s46 offset:604
		scratch_load_dword v154, off, s46 offset:608
		scratch_load_dword v155, off, s46 offset:612
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[156:159], v[180:183], v[152:155], v166, v200 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v152, s46 offset:616
		scratch_store_dword off, v153, s46 offset:620
		scratch_store_dword off, v154, s46 offset:624
		scratch_store_dword off, v155, s46 offset:628
		s_mov_b32 m0, s42
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(7)
		scratch_load_dword v3, off, s46 offset:228
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		s_mov_b32 s46, 0
		scratch_load_dword v152, off, s46 offset:584
		scratch_load_dword v153, off, s46 offset:588
		scratch_load_dword v154, off, s46 offset:592
		scratch_load_dword v155, off, s46 offset:596
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[156:159], v[184:187], v[152:155], v166, v201 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v152, s46 offset:632
		scratch_store_dword off, v153, s46 offset:636
		scratch_store_dword off, v154, s46 offset:640
		scratch_store_dword off, v155, s46 offset:644
		s_add_i32 m0, s43, 0x20000
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(10)
		scratch_load_dword v3, off, s46 offset:232
		s_waitcnt vmcnt(0)
		buffer_load_dword v3, s[4:7], 0 offen lds
		s_mov_b32 s46, 0
		scratch_load_dword v152, off, s46 offset:568
		scratch_load_dword v153, off, s46 offset:572
		scratch_load_dword v154, off, s46 offset:576
		scratch_load_dword v155, off, s46 offset:580
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[156:159], v[188:191], v[152:155], v166, v201 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v152, s46 offset:648
		scratch_store_dword off, v153, s46 offset:652
		scratch_store_dword off, v154, s46 offset:656
		scratch_store_dword off, v155, s46 offset:660
		s_add_i32 m0, s44, 0x20000
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(13)
		scratch_load_dword v3, off, s46 offset:236
		s_waitcnt vmcnt(0)
		buffer_load_dword v3, s[4:7], 0 offen lds
		s_mov_b32 s46, 0
		scratch_load_dword v152, off, s46 offset:552
		scratch_load_dword v153, off, s46 offset:556
		scratch_load_dword v154, off, s46 offset:560
		scratch_load_dword v155, off, s46 offset:564
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[156:159], v[192:195], v[152:155], v166, v202 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v152, s46 offset:664
		scratch_store_dword off, v153, s46 offset:668
		scratch_store_dword off, v154, s46 offset:672
		scratch_store_dword off, v155, s46 offset:676
		s_add_i32 m0, s45, 0x20000
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v3, off, s46 offset:240
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v3, s[24:27], 0 offen lds
		s_mov_b32 s46, 0
		scratch_load_dword v152, off, s46 offset:536
		scratch_load_dword v153, off, s46 offset:540
		scratch_load_dword v154, off, s46 offset:544
		scratch_load_dword v155, off, s46 offset:548
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[156:159], v[196:199], v[152:155], v166, v202 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v156, off, s46 offset:520
		scratch_load_dword v157, off, s46 offset:524
		scratch_load_dword v158, off, s46 offset:528
		scratch_load_dword v159, off, s46 offset:532
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[160:163], v[168:171], v[156:159], v166, v167 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v168, off, s46 offset:504
		scratch_load_dword v169, off, s46 offset:508
		scratch_load_dword v170, off, s46 offset:512
		scratch_load_dword v171, off, s46 offset:516
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[160:163], v[172:175], v[168:171], v166, v167 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v172, off, s46 offset:488
		scratch_load_dword v173, off, s46 offset:492
		scratch_load_dword v174, off, s46 offset:496
		scratch_load_dword v175, off, s46 offset:500
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[160:163], v[176:179], v[172:175], v166, v200 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v176, off, s46 offset:472
		scratch_load_dword v177, off, s46 offset:476
		scratch_load_dword v178, off, s46 offset:480
		scratch_load_dword v179, off, s46 offset:484
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[160:163], v[180:183], v[176:179], v166, v200 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v180, off, s46 offset:456
		scratch_load_dword v181, off, s46 offset:460
		scratch_load_dword v182, off, s46 offset:464
		scratch_load_dword v183, off, s46 offset:468
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[160:163], v[184:187], v[180:183], v166, v201 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v184, off, s46 offset:440
		scratch_load_dword v185, off, s46 offset:444
		scratch_load_dword v186, off, s46 offset:448
		scratch_load_dword v187, off, s46 offset:452
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[160:163], v[188:191], v[184:187], v166, v201 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v188, off, s46 offset:424
		scratch_load_dword v189, off, s46 offset:428
		scratch_load_dword v190, off, s46 offset:432
		scratch_load_dword v191, off, s46 offset:436
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[160:163], v[192:195], v[188:191], v166, v202 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v192, off, s46 offset:408
		scratch_load_dword v193, off, s46 offset:412
		scratch_load_dword v194, off, s46 offset:416
		scratch_load_dword v195, off, s46 offset:420
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[160:163], v[196:199], v[192:195], v166, v202 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[204:207], v[220:223], v[4:7], v165, v167 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[204:207], v[224:227], v[72:75], v165, v167 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[204:207], v[228:231], v[76:79], v165, v200 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[204:207], v[148:151], v[84:87], v165, v200 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[204:207], v[232:235], v[88:91], v165, v201 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[204:207], v[236:239], v[92:95], v165, v201 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[204:207], v[240:243], v[96:99], v165, v202 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[204:207], v[244:247], v[100:103], v165, v202 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[208:211], v[220:223], v[104:107], v165, v167 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[208:211], v[224:227], v[108:111], v165, v167 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[208:211], v[228:231], v[112:115], v165, v200 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[208:211], v[148:151], v[116:119], v165, v200 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[208:211], v[232:235], v[120:123], v165, v201 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[208:211], v[236:239], v[124:127], v165, v201 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[208:211], v[240:243], v[128:131], v165, v202 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[208:211], v[244:247], v[132:135], v165, v202 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[212:215], v[220:223], v[136:139], v166, v167 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[212:215], v[224:227], v[140:143], v166, v167 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[212:215], v[228:231], v[144:147], v166, v200 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(12)
		scratch_load_dword v160, off, s46 offset:616
		scratch_load_dword v161, off, s46 offset:620
		scratch_load_dword v162, off, s46 offset:624
		scratch_load_dword v163, off, s46 offset:628
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[212:215], v[148:151], v[160:163], v166, v200 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v196, off, s46 offset:632
		scratch_load_dword v197, off, s46 offset:636
		scratch_load_dword v198, off, s46 offset:640
		scratch_load_dword v199, off, s46 offset:644
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[212:215], v[232:235], v[196:199], v166, v201 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v204, off, s46 offset:648
		scratch_load_dword v205, off, s46 offset:652
		scratch_load_dword v206, off, s46 offset:656
		scratch_load_dword v207, off, s46 offset:660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[212:215], v[236:239], v[204:207], v166, v201 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v208, off, s46 offset:664
		scratch_load_dword v209, off, s46 offset:668
		scratch_load_dword v210, off, s46 offset:672
		scratch_load_dword v211, off, s46 offset:676
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[212:215], v[240:243], v[208:211], v166, v202 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[212:215], v[244:247], v[152:155], v166, v202 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[216:219], v[220:223], v[156:159], v166, v167 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[216:219], v[224:227], v[168:171], v166, v167 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[216:219], v[228:231], v[172:175], v166, v200 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[216:219], v[148:151], v[176:179], v166, v200 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[216:219], v[232:235], v[180:183], v166, v201 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[216:219], v[236:239], v[184:187], v166, v201 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[216:219], v[240:243], v[188:191], v166, v202 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[216:219], v[244:247], v[192:195], v166, v202 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s11, s11, 2
		v_readfirstlane_b32 s46, v2
		s_cmp_lt_i32 s11, s46
		s_mov_b32 s46, 0
		s_nop 2
		scratch_load_dword v148, off, s46 offset:132
		scratch_load_dword v149, off, s46 offset:136
		scratch_load_dword v150, off, s46 offset:140
		scratch_load_dword v151, off, s46 offset:144
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v32, v148
		v_mov_b32_e32 v33, v149
		v_mov_b32_e32 v34, v150
		v_mov_b32_e32 v35, v151
		v_mov_b32_e32 v15, v14
		v_mov_b32_e32 v18, v19
		v_mov_b32_e32 v17, v71
		v_mov_b32_e32 v68, v248
		v_mov_b32_e32 v69, v249
		v_mov_b32_e32 v70, v250
		s_mov_b32 s46, 0
		scratch_store_dword off, v160, s46 offset:392
		scratch_store_dword off, v161, s46 offset:396
		scratch_store_dword off, v162, s46 offset:400
		scratch_store_dword off, v163, s46 offset:404
		s_mov_b32 s46, 0
		scratch_store_dword off, v196, s46 offset:376
		scratch_store_dword off, v197, s46 offset:380
		scratch_store_dword off, v198, s46 offset:384
		scratch_store_dword off, v199, s46 offset:388
		s_mov_b32 s46, 0
		scratch_store_dword off, v204, s46 offset:360
		scratch_store_dword off, v205, s46 offset:364
		scratch_store_dword off, v206, s46 offset:368
		scratch_store_dword off, v207, s46 offset:372
		s_mov_b32 s46, 0
		scratch_store_dword off, v208, s46 offset:344
		scratch_store_dword off, v209, s46 offset:348
		scratch_store_dword off, v210, s46 offset:352
		scratch_store_dword off, v211, s46 offset:356
		s_mov_b32 s46, 0
		scratch_store_dword off, v152, s46 offset:328
		scratch_store_dword off, v153, s46 offset:332
		scratch_store_dword off, v154, s46 offset:336
		scratch_store_dword off, v155, s46 offset:340
		s_mov_b32 s46, 0
		scratch_store_dword off, v156, s46 offset:312
		scratch_store_dword off, v157, s46 offset:316
		scratch_store_dword off, v158, s46 offset:320
		scratch_store_dword off, v159, s46 offset:324
		s_mov_b32 s46, 0
		scratch_store_dword off, v168, s46 offset:296
		scratch_store_dword off, v169, s46 offset:300
		scratch_store_dword off, v170, s46 offset:304
		scratch_store_dword off, v171, s46 offset:308
		s_mov_b32 s46, 0
		scratch_store_dword off, v172, s46 offset:280
		scratch_store_dword off, v173, s46 offset:284
		scratch_store_dword off, v174, s46 offset:288
		scratch_store_dword off, v175, s46 offset:292
		s_mov_b32 s46, 0
		scratch_store_dword off, v176, s46 offset:264
		scratch_store_dword off, v177, s46 offset:268
		scratch_store_dword off, v178, s46 offset:272
		scratch_store_dword off, v179, s46 offset:276
		s_mov_b32 s46, 0
		scratch_store_dword off, v180, s46 offset:248
		scratch_store_dword off, v181, s46 offset:252
		scratch_store_dword off, v182, s46 offset:256
		scratch_store_dword off, v183, s46 offset:260
		s_mov_b32 s46, 0
		scratch_store_dword off, v184, s46 offset:188
		scratch_store_dword off, v185, s46 offset:192
		scratch_store_dword off, v186, s46 offset:196
		scratch_store_dword off, v187, s46 offset:200
		s_mov_b32 s46, 0
		scratch_store_dword off, v188, s46 offset:164
		scratch_store_dword off, v189, s46 offset:168
		scratch_store_dword off, v190, s46 offset:172
		scratch_store_dword off, v191, s46 offset:176
		s_mov_b32 s46, 0
		scratch_store_dword off, v192, s46 offset:148
		scratch_store_dword off, v193, s46 offset:152
		scratch_store_dword off, v194, s46 offset:156
		scratch_store_dword off, v195, s46 offset:160
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(48)
		scratch_load_dword v80, off, s0 offset:392
		scratch_load_dword v81, off, s0 offset:396
		scratch_load_dword v82, off, s0 offset:400
		scratch_load_dword v83, off, s0 offset:404
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(44)
		scratch_load_dword v148, off, s0 offset:376
		scratch_load_dword v149, off, s0 offset:380
		scratch_load_dword v150, off, s0 offset:384
		scratch_load_dword v151, off, s0 offset:388
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(40)
		scratch_load_dword v152, off, s0 offset:360
		scratch_load_dword v153, off, s0 offset:364
		scratch_load_dword v154, off, s0 offset:368
		scratch_load_dword v155, off, s0 offset:372
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(36)
		scratch_load_dword v156, off, s0 offset:344
		scratch_load_dword v157, off, s0 offset:348
		scratch_load_dword v158, off, s0 offset:352
		scratch_load_dword v159, off, s0 offset:356
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(32)
		scratch_load_dword v160, off, s0 offset:328
		scratch_load_dword v161, off, s0 offset:332
		scratch_load_dword v162, off, s0 offset:336
		scratch_load_dword v163, off, s0 offset:340
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(28)
		scratch_load_dword v164, off, s0 offset:312
		scratch_load_dword v165, off, s0 offset:316
		scratch_load_dword v166, off, s0 offset:320
		scratch_load_dword v167, off, s0 offset:324
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v168, off, s0 offset:296
		scratch_load_dword v169, off, s0 offset:300
		scratch_load_dword v170, off, s0 offset:304
		scratch_load_dword v171, off, s0 offset:308
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(20)
		scratch_load_dword v172, off, s0 offset:280
		scratch_load_dword v173, off, s0 offset:284
		scratch_load_dword v174, off, s0 offset:288
		scratch_load_dword v175, off, s0 offset:292
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v176, off, s0 offset:264
		scratch_load_dword v177, off, s0 offset:268
		scratch_load_dword v178, off, s0 offset:272
		scratch_load_dword v179, off, s0 offset:276
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(12)
		scratch_load_dword v180, off, s0 offset:248
		scratch_load_dword v181, off, s0 offset:252
		scratch_load_dword v182, off, s0 offset:256
		scratch_load_dword v183, off, s0 offset:260
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v184, off, s0 offset:188
		scratch_load_dword v185, off, s0 offset:192
		scratch_load_dword v186, off, s0 offset:196
		scratch_load_dword v187, off, s0 offset:200
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v188, off, s0 offset:164
		scratch_load_dword v189, off, s0 offset:168
		scratch_load_dword v190, off, s0 offset:172
		scratch_load_dword v191, off, s0 offset:176
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v192, off, s0 offset:148
		scratch_load_dword v193, off, s0 offset:152
		scratch_load_dword v194, off, s0 offset:156
		scratch_load_dword v195, off, s0 offset:160
		s_add_i32 s0, s12, -1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[20:23], v[36:39], v[4:7], v15, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s1, s0, 1
		s_lshl_b32 s0, s1, 16
		v_add_u32_e32 v2, s0, v10
		v_add3_u32 v3, v2, v12, v1
		ds_read_b128 v[196:199], v3 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[20:23], v[40:43], v[72:75], v15, v17 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[200:203], v3 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[20:23], v[44:47], v[76:79], v15, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[204:207], v3 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[20:23], v[48:51], v[84:87], v15, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[208:211], v3 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[20:23], v[52:55], v[88:91], v15, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, s0, v12
		v_add3_u32 v3, v2, v16, v1
		ds_read_b128 v[212:215], v3 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[20:23], v[56:59], v[92:95], v15, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v3 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[20:23], v[60:63], v[96:99], v15, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v3 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[20:23], v[64:67], v[100:103], v15, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v3 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[24:27], v[36:39], v[104:107], v15, v17 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v3 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[24:27], v[40:43], v[108:111], v15, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v3 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[24:27], v[44:47], v[112:115], v15, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[232:235], v3 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[24:27], v[48:51], v[116:119], v15, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[236:239], v3 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[24:27], v[52:55], v[120:123], v15, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[24:27], v[56:59], v[124:127], v15, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[24:27], v[60:63], v[128:131], v15, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[24:27], v[64:67], v[132:135], v15, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[28:31], v[36:39], v[136:139], v18, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[28:31], v[40:43], v[140:143], v18, v17 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[28:31], v[44:47], v[144:147], v18, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(48)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[28:31], v[48:51], v[80:83], v18, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(44)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[28:31], v[52:55], v[148:151], v18, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(40)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[28:31], v[56:59], v[152:155], v18, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(36)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[28:31], v[60:63], v[156:159], v18, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(32)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[28:31], v[64:67], v[160:163], v18, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(28)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[32:35], v[36:39], v[164:167], v18, v17 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(24)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[32:35], v[40:43], v[168:171], v18, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(20)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[32:35], v[44:47], v[172:175], v18, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(16)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[32:35], v[48:51], v[176:179], v18, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(12)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[32:35], v[52:55], v[180:183], v18, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[32:35], v[56:59], v[184:187], v18, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[32:35], v[60:63], v[188:191], v18, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[32:35], v[64:67], v[192:195], v18, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[196:199], v[212:215], v[4:7], v15, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[196:199], v[216:219], v[72:75], v15, v17 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[196:199], v[220:223], v[76:79], v15, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[196:199], v[20:23], v[84:87], v15, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[196:199], v[224:227], v[88:91], v15, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[196:199], v[228:231], v[92:95], v15, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[196:199], v[232:235], v[96:99], v15, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[196:199], v[236:239], v[100:103], v15, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[200:203], v[212:215], v[104:107], v15, v17 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[200:203], v[216:219], v[108:111], v15, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[200:203], v[220:223], v[112:115], v15, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[200:203], v[20:23], v[116:119], v15, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[200:203], v[224:227], v[120:123], v15, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[200:203], v[228:231], v[124:127], v15, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[200:203], v[232:235], v[128:131], v15, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[200:203], v[236:239], v[132:135], v15, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[204:207], v[212:215], v[136:139], v18, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[204:207], v[216:219], v[140:143], v18, v17 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[204:207], v[220:223], v[144:147], v18, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[204:207], v[20:23], v[80:83], v18, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[204:207], v[224:227], v[148:151], v18, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[204:207], v[228:231], v[152:155], v18, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[204:207], v[232:235], v[156:159], v18, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[204:207], v[236:239], v[160:163], v18, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[208:211], v[212:215], v[164:167], v18, v17 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[208:211], v[216:219], v[168:171], v18, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[208:211], v[220:223], v[172:175], v18, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[208:211], v[20:23], v[176:179], v18, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[208:211], v[224:227], v[180:183], v18, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[208:211], v[228:231], v[184:187], v18, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[208:211], v[232:235], v[188:191], v18, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[208:211], v[236:239], v[192:195], v18, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s0, s12, 1
		s_lshl_b32 s1, s0, 16
		v_add_u32_e32 v2, s1, v10
		v_add3_u32 v3, v2, v12, v1
		ds_read_b128 v[20:23], v3
		ds_read_b128 v[24:27], v3 offset:1024
		ds_read_b128 v[28:31], v3 offset:2048
		ds_read_b128 v[32:35], v3 offset:3072
		v_add_u32_e32 v2, s1, v12
		v_add3_u32 v8, v2, v16, v1
		ds_read_b128 v[16:19], v8 offset:32768
		ds_read_b128 v[36:39], v8 offset:33792
		ds_read_b128 v[40:43], v8 offset:34816
		ds_read_b128 v[44:47], v8 offset:35840
		ds_read_b128 v[48:51], v8 offset:36864
		ds_read_b128 v[52:55], v8 offset:37888
		ds_read_b128 v[56:59], v8 offset:38912
		ds_read_b128 v[60:63], v8 offset:39936
		s_lshl_b32 s1, s0, 12
		s_add_i32 s0, s1, 0x20000
		v_add3_u32 v1, s0, v9, v11
		ds_read_b32 v2, v1
		ds_read_b32 v9, v1 offset:256
		v_add3_u32 v1, s0, v11, v13
		ds_read_b32 v10, v1 offset:2048
		ds_read_b32 v11, v1 offset:2304
		ds_read_b32 v12, v1 offset:2560
		ds_read_b32 v13, v1 offset:2816
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[20:23], v[16:19], v[4:7], v2, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[64:67], v3 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[20:23], v[36:39], v[72:75], v2, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[68:71], v3 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[20:23], v[40:43], v[76:79], v2, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[196:199], v3 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[20:23], v[44:47], v[84:87], v2, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[200:203], v3 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[20:23], v[48:51], v[88:91], v2, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[204:207], v8 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[20:23], v[52:55], v[92:95], v2, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[208:211], v8 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[20:23], v[56:59], v[96:99], v2, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[212:215], v8 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[20:23], v[60:63], v[100:103], v2, v13 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v8 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[24:27], v[16:19], v[104:107], v2, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v8 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[24:27], v[36:39], v[108:111], v2, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v8 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[24:27], v[40:43], v[112:115], v2, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v8 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[24:27], v[44:47], v[116:119], v2, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v8 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[24:27], v[48:51], v[120:123], v2, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[24:27], v[52:55], v[124:127], v2, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[24:27], v[56:59], v[128:131], v2, v13 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[24:27], v[60:63], v[132:135], v2, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[28:31], v[16:19], v[136:139], v9, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[28:31], v[36:39], v[140:143], v9, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[28:31], v[40:43], v[144:147], v9, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[28:31], v[44:47], v[80:83], v9, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[28:31], v[48:51], v[148:151], v9, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[28:31], v[52:55], v[152:155], v9, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[28:31], v[56:59], v[156:159], v9, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[28:31], v[60:63], v[160:163], v9, v13 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[32:35], v[16:19], v[164:167], v9, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[32:35], v[36:39], v[168:171], v9, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[32:35], v[40:43], v[172:175], v9, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[32:35], v[44:47], v[176:179], v9, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[32:35], v[48:51], v[180:183], v9, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[32:35], v[52:55], v[184:187], v9, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[32:35], v[56:59], v[188:191], v9, v13 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[32:35], v[60:63], v[192:195], v9, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[64:67], v[204:207], v[4:7], v2, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[64:67], v[208:211], v[72:75], v2, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[64:67], v[212:215], v[76:79], v2, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[64:67], v[20:23], v[84:87], v2, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[64:67], v[216:219], v[88:91], v2, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[64:67], v[220:223], v[92:95], v2, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[64:67], v[224:227], v[96:99], v2, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[64:67], v[228:231], v[100:103], v2, v13 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[68:71], v[204:207], v[104:107], v2, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[68:71], v[208:211], v[108:111], v2, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[68:71], v[212:215], v[112:115], v2, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[68:71], v[20:23], v[116:119], v2, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[68:71], v[216:219], v[120:123], v2, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[68:71], v[220:223], v[124:127], v2, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[68:71], v[224:227], v[128:131], v2, v13 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[68:71], v[228:231], v[132:135], v2, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[196:199], v[204:207], v[136:139], v9, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[196:199], v[208:211], v[140:143], v9, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[196:199], v[212:215], v[144:147], v9, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[196:199], v[20:23], v[80:83], v9, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[196:199], v[216:219], v[148:151], v9, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[196:199], v[220:223], v[152:155], v9, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[196:199], v[224:227], v[156:159], v9, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[196:199], v[228:231], v[160:163], v9, v13 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[200:203], v[204:207], v[164:167], v9, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[200:203], v[208:211], v[168:171], v9, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[200:203], v[212:215], v[172:175], v9, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[200:203], v[20:23], v[176:179], v9, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[200:203], v[216:219], v[180:183], v9, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[200:203], v[220:223], v[184:187], v9, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[200:203], v[224:227], v[188:191], v9, v13 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[200:203], v[228:231], v[192:195], v9, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v4, v5
		v_cvt_pk_f16_f32 v3, v6, v7
		v_and_b32_e32 v1, 63, v0
		v_lshlrev_b32_e32 v0, 3, v1
		v_accvgpr_read_b32 v1, a0
		v_lshl_add_u32 v4, v1, 14, v0
		s_lshl_b32 s0, s13, 21
		s_lshl_b32 s1, s14, 17
		s_add_i32 s2, s0, s1
		buffer_store_dwordx2 v[2:3], v4, s[16:19], s2 offen
		v_cvt_pk_f16_f32 v0, v72, v73
		v_cvt_pk_f16_f32 v1, v74, v75
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:512
		v_cvt_pk_f16_f32 v0, v76, v77
		v_cvt_pk_f16_f32 v1, v78, v79
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:1024
		v_cvt_pk_f16_f32 v0, v84, v85
		v_cvt_pk_f16_f32 v1, v86, v87
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:1536
		v_cvt_pk_f16_f32 v0, v88, v89
		v_cvt_pk_f16_f32 v1, v90, v91
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:2048
		v_cvt_pk_f16_f32 v0, v92, v93
		v_cvt_pk_f16_f32 v1, v94, v95
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:2560
		v_cvt_pk_f16_f32 v0, v96, v97
		v_cvt_pk_f16_f32 v1, v98, v99
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:3072
		v_cvt_pk_f16_f32 v0, v100, v101
		v_cvt_pk_f16_f32 v1, v102, v103
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:3584
		v_cvt_pk_f16_f32 v0, v104, v105
		v_cvt_pk_f16_f32 v1, v106, v107
		s_add_i32 s2, s0, 0x1000
		s_add_i32 s3, s2, s1
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen
		v_cvt_pk_f16_f32 v0, v108, v109
		v_cvt_pk_f16_f32 v1, v110, v111
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:512
		v_cvt_pk_f16_f32 v0, v112, v113
		v_cvt_pk_f16_f32 v1, v114, v115
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:1024
		v_cvt_pk_f16_f32 v0, v116, v117
		v_cvt_pk_f16_f32 v1, v118, v119
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:1536
		v_cvt_pk_f16_f32 v0, v120, v121
		v_cvt_pk_f16_f32 v1, v122, v123
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:2048
		v_cvt_pk_f16_f32 v0, v124, v125
		v_cvt_pk_f16_f32 v1, v126, v127
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:2560
		v_cvt_pk_f16_f32 v0, v128, v129
		v_cvt_pk_f16_f32 v1, v130, v131
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:3072
		v_cvt_pk_f16_f32 v0, v132, v133
		v_cvt_pk_f16_f32 v1, v134, v135
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:3584
		v_cvt_pk_f16_f32 v0, v136, v137
		v_cvt_pk_f16_f32 v1, v138, v139
		s_add_i32 s2, s0, 0x2000
		s_add_i32 s3, s2, s1
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen
		v_cvt_pk_f16_f32 v0, v140, v141
		v_cvt_pk_f16_f32 v1, v142, v143
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:512
		v_cvt_pk_f16_f32 v0, v144, v145
		v_cvt_pk_f16_f32 v1, v146, v147
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:1024
		v_cvt_pk_f16_f32 v0, v80, v81
		v_cvt_pk_f16_f32 v1, v82, v83
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:1536
		v_cvt_pk_f16_f32 v0, v148, v149
		v_cvt_pk_f16_f32 v1, v150, v151
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:2048
		v_cvt_pk_f16_f32 v0, v152, v153
		v_cvt_pk_f16_f32 v1, v154, v155
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:2560
		v_cvt_pk_f16_f32 v0, v156, v157
		v_cvt_pk_f16_f32 v1, v158, v159
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:3072
		v_cvt_pk_f16_f32 v0, v160, v161
		v_cvt_pk_f16_f32 v1, v162, v163
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:3584
		v_cvt_pk_f16_f32 v0, v164, v165
		v_cvt_pk_f16_f32 v1, v166, v167
		s_add_i32 s2, s0, 0x3000
		s_add_i32 s0, s2, s1
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen
		v_cvt_pk_f16_f32 v0, v168, v169
		v_cvt_pk_f16_f32 v1, v170, v171
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:512
		v_cvt_pk_f16_f32 v0, v172, v173
		v_cvt_pk_f16_f32 v1, v174, v175
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:1024
		v_cvt_pk_f16_f32 v0, v176, v177
		v_cvt_pk_f16_f32 v1, v178, v179
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:1536
		v_cvt_pk_f16_f32 v0, v180, v181
		v_cvt_pk_f16_f32 v1, v182, v183
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:2048
		v_cvt_pk_f16_f32 v0, v184, v185
		v_cvt_pk_f16_f32 v1, v186, v187
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:2560
		v_cvt_pk_f16_f32 v0, v188, v189
		v_cvt_pk_f16_f32 v1, v190, v191
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:3072
		v_cvt_pk_f16_f32 v0, v192, v193
		v_cvt_pk_f16_f32 v1, v194, v195
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:3584
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 0
		.amdhsa_private_segment_fixed_size 680
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
		.amdhsa_next_free_vgpr 253
		.amdhsa_next_free_sgpr 49
		.amdhsa_accum_offset 252
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
	.set .Lwmma_f16_matmul_tiled.num_vgpr, 251
	.set .Lwmma_f16_matmul_tiled.num_agpr, 1
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 49
	.set .Lwmma_f16_matmul_tiled.num_named_barrier, 0
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 680
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
    .group_segment_fixed_size: 0
    .kernarg_segment_align: 8
    .kernarg_segment_size: 48
    .max_flat_workgroup_size: 512
    .name:           wmma_f16_matmul_tiled
    .private_segment_fixed_size: 680
    .sgpr_count:     49
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     253
    .agpr_count:     1
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
