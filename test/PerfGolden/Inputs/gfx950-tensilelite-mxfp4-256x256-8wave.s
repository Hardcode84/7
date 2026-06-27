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
		v_lshlrev_b32_e32 v2, 2, v0
		v_add_u32_e32 v3, 0x22000, v2
		ds_write_b32 v3, v1
		v_lshlrev_b32_e32 v2, 16, v1
		v_add_u32_e32 v3, s9, v2
		v_and_b32_e32 v8, 63, v0
		v_lshlrev_b32_e32 v9, 2, v0
		v_add_u32_e32 v10, 0x22800, v9
		ds_write_b32 v10, v8
		v_lshrrev_b32_e32 v9, 2, v8
		v_lshlrev_b32_e32 v10, 12, v9
		v_lshrrev_b32_e32 v9, 3, v8
		v_and_b32_e32 v11, 3, v9
		v_and_b32_e32 v9, 3, v8
		v_xor_b32_e32 v12, v11, v9
		v_lshlrev_b32_e32 v9, 4, v12
		v_add3_u32 v11, v3, v10, v9
		s_add_i32 s10, s9, 0x80000
		v_add_u32_e32 v3, s10, v2
		v_add3_u32 v12, v3, v10, v9
		v_add3_u32 v3, s9, 64, v2
		v_add3_u32 v13, v3, v10, v9
		s_add_i32 s10, s9, 0x80040
		v_add_u32_e32 v3, s10, v2
		v_add3_u32 v14, v3, v10, v9
		s_lshl_b32 s10, s14, 20
		v_add_u32_e32 v3, s10, v2
		v_add3_u32 v15, v3, v10, v9
		s_add_i32 s11, s10, 0x80000
		v_add_u32_e32 v3, s11, v2
		v_add3_u32 v16, v3, v10, v9
		v_add3_u32 v3, s10, 64, v2
		v_add3_u32 v17, v3, v10, v9
		s_add_i32 s11, s10, 0x80040
		v_add_u32_e32 v3, s11, v2
		v_add3_u32 v18, v3, v10, v9
		s_lshr_b32 s11, s8, 6
		s_lshl_b32 s15, s11, 10
		s_add_i32 s28, s15, 0x2000
		s_add_i32 s29, s15, 0x4000
		s_add_i32 s30, s15, 0x6000
		s_add_i32 s31, s15, 0x8000
		s_add_i32 s32, s15, 0xa000
		s_add_i32 s33, s15, 0xc000
		s_add_i32 s34, s15, 0xe000
		s_mov_b32 m0, s15
		s_nop 0
		buffer_load_dwordx4 v11, s[20:23], 0 offen lds
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v15, s[0:3], 0 offen lds
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v16, s[0:3], 0 offen lds
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v17, s[0:3], 0 offen lds
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v18, s[0:3], 0 offen lds
		s_lshl_b32 s35, s14, 16
		s_add_i32 s36, s9, s35
		v_lshrrev_b32_e32 v3, 7, v0
		v_lshlrev_b32_e32 v11, 9, v3
		s_mov_b32 s37, 0
		scratch_store_dword off, v11, s37 offset:104
		v_lshlrev_b32_e32 v12, 2, v8
		s_mov_b32 s37, 0
		scratch_store_dword off, v12, s37 offset:128
		v_add3_u32 v13, s36, v11, v12
		s_lshr_b32 s37, s8, 7
		s_lshl_b32 s8, s37, 9
		s_add_i32 s37, s9, 0x100
		s_add_i32 s38, s37, s35
		v_add3_u32 v14, s38, v11, v12
		s_add_i32 s37, s8, 0x100
		v_lshlrev_b32_e32 v15, 4, v8
		v_and_b32_e32 v16, 1, v1
		v_lshlrev_b32_e32 v1, 10, v16
		s_mov_b32 s38, 0
		scratch_store_dword off, v1, s38 offset:108
		v_add3_u32 v17, s36, v15, v1
		s_and_b32 s36, s11, 1
		s_lshl_b32 s11, s36, 10
		s_add_i32 s36, s11, 0x800
		s_add_i32 m0, s8, 0x20000
		s_nop 0
		buffer_load_dword v13, s[4:7], 0 offen lds
		s_add_i32 m0, s8, 0x20100
		s_nop 0
		buffer_load_dword v14, s[4:7], 0 offen lds
		s_add_i32 m0, s11, 0x20800
		s_nop 0
		buffer_load_dwordx4 v17, s[24:27], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v13, 12, v3
		s_mov_b32 s38, 0
		scratch_store_dword off, v13, s38 offset:72
		v_lshlrev_b32_e32 v3, 2, v0
		v_add_u32_e32 v14, 0x26800, v3
		ds_write_b32 v14, v13
		v_and_b32_e32 v3, 15, v0
		v_lshlrev_b32_e32 v14, 6, v3
		s_mov_b32 s38, 0
		scratch_store_dword off, v14, s38 offset:228
		s_mov_b32 s38, 0
		scratch_store_dword off, v14, s38 offset:112
		v_lshrrev_b32_e32 v17, 4, v8
		v_lshrrev_b32_e32 v8, 1, v3
		v_and_b32_e32 v3, 3, v8
		v_xor_b32_e32 v8, v17, v3
		v_lshlrev_b32_e32 v3, 4, v8
		s_mov_b32 s38, 0
		scratch_store_dword off, v3, s38 offset:232
		s_mov_b32 s38, 0
		scratch_store_dword off, v3, s38 offset:116
		v_add3_u32 v8, v13, v14, v3
		ds_read_b128 v[20:23], v8
		ds_read_b128 v[24:27], v8 offset:1024
		ds_read_b128 v[28:31], v8 offset:2048
		ds_read_b128 v[32:35], v8 offset:3072
		v_lshlrev_b32_e32 v8, 13, v16
		s_mov_b32 s38, 0
		scratch_store_dword off, v8, s38 offset:236
		s_mov_b32 s38, 0
		scratch_store_dword off, v8, s38 offset:92
		v_add3_u32 v16, v14, v8, v3
		ds_read_b128 v[36:39], v16 offset:32768
		ds_read_b128 v[40:43], v16 offset:33792
		ds_read_b128 v[44:47], v16 offset:34816
		ds_read_b128 v[48:51], v16 offset:35840
		ds_read_b128 v[52:55], v16 offset:36864
		ds_read_b128 v[56:59], v16 offset:37888
		ds_read_b128 v[60:63], v16 offset:38912
		ds_read_b128 v[64:67], v16 offset:39936
		v_add_u32_e32 v16, 0x20000, v11
		v_add_u32_e32 v17, v16, v12
		ds_read_b32 v16, v17
		ds_read_b32 v18, v17 offset:256
		v_add_u32_e32 v17, 0x20000, v12
		v_add_u32_e32 v19, v17, v1
		ds_read_b32 v17, v19 offset:2048
		ds_read_b32 v68, v19 offset:2304
		ds_read_b32 v69, v19 offset:2560
		ds_read_b32 v70, v19 offset:2816
		s_waitcnt lgkmcnt(0)
		s_add_i32 s38, s9, 0x80
		v_add_u32_e32 v19, s38, v2
		v_add3_u32 v71, v19, v10, v9
		s_add_i32 s38, s9, 0x80080
		v_add_u32_e32 v19, s38, v2
		v_add3_u32 v72, v19, v10, v9
		s_add_i32 s38, s9, 0xc0
		v_add_u32_e32 v19, s38, v2
		v_add3_u32 v73, v19, v10, v9
		s_add_i32 s38, s9, 0x800c0
		v_add_u32_e32 v19, s38, v2
		v_add3_u32 v74, v19, v10, v9
		s_add_i32 s38, s10, 0x80
		v_add_u32_e32 v19, s38, v2
		v_add3_u32 v75, v19, v10, v9
		s_add_i32 s38, s10, 0x80080
		v_add_u32_e32 v19, s38, v2
		v_add3_u32 v76, v19, v10, v9
		s_add_i32 s38, s10, 0xc0
		v_add_u32_e32 v19, s38, v2
		v_add3_u32 v77, v19, v10, v9
		s_add_i32 s38, s10, 0x800c0
		v_add_u32_e32 v19, s38, v2
		v_add3_u32 v2, v19, v10, v9
		s_add_i32 s10, s15, 0x10000
		s_add_i32 s38, s15, 0x12000
		s_add_i32 s39, s15, 0x14000
		s_add_i32 s40, s15, 0x16000
		s_add_i32 s41, s15, 0x18000
		s_add_i32 s42, s15, 0x1a000
		s_add_i32 s43, s15, 0x1c000
		s_add_i32 s44, s15, 0x1e000
		s_mov_b32 m0, s10
		s_nop 0
		buffer_load_dwordx4 v71, s[20:23], 0 offen lds
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v72, s[20:23], 0 offen lds
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v73, s[20:23], 0 offen lds
		s_mov_b32 m0, s40
		s_nop 0
		buffer_load_dwordx4 v74, s[20:23], 0 offen lds
		s_mov_b32 m0, s41
		s_nop 0
		buffer_load_dwordx4 v75, s[0:3], 0 offen lds
		s_mov_b32 m0, s42
		s_nop 0
		buffer_load_dwordx4 v76, s[0:3], 0 offen lds
		s_mov_b32 m0, s43
		s_nop 0
		buffer_load_dwordx4 v77, s[0:3], 0 offen lds
		s_mov_b32 m0, s44
		s_nop 0
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_add_i32 s45, s9, 0x800
		s_add_i32 s46, s45, s35
		v_add3_u32 v2, s46, v11, v12
		s_add_i32 s45, s8, 0x1000
		s_add_i32 s47, s9, 0x900
		s_add_i32 s9, s47, s35
		v_add3_u32 v9, s9, v11, v12
		s_add_i32 s9, s8, 0x1100
		v_add3_u32 v10, s46, v15, v1
		s_add_i32 s35, s11, 0x1800
		s_add_i32 m0, s8, 0x21000
		s_nop 0
		buffer_load_dword v2, s[4:7], 0 offen lds
		s_add_i32 m0, s8, 0x21100
		s_nop 0
		buffer_load_dword v9, s[4:7], 0 offen lds
		s_add_i32 m0, s11, 0x21800
		s_nop 0
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s11, s12, 1
		s_mov_b32 s46, 2
		v_mov_b32_e32 v10, s13
		v_mov_b32_e32 v11, 0
		s_mov_b32 s48, 0x100000
		s_mov_b32 s49, 0
		v_mov_b32_e32 v72, s48
		v_mov_b32_e32 v73, s49
		v_mul_lo_u32 v74, v72, v10
		v_mul_hi_u32 v75, v72, v10
		v_mul_lo_u32 v1, v72, v11
		v_add_u32_e32 v75, v75, v1
		v_mul_lo_u32 v1, v73, v10
		v_add_u32_e32 v75, v75, v1
		s_mov_b32 s48, 1
		s_mov_b32 s49, 0
		v_mov_b32_e32 v76, v0
		v_mov_b32_e32 v77, 0
		v_mov_b32_e32 v78, s48
		v_mov_b32_e32 v79, s49
		v_mul_lo_u32 v80, v78, v76
		v_mul_hi_u32 v81, v78, v76
		v_mul_lo_u32 v1, v78, v77
		v_add_u32_e32 v81, v81, v1
		v_mul_lo_u32 v1, v79, v76
		v_add_u32_e32 v81, v81, v1
		v_lshrrev_b64 v[82:83], 6, v[80:81]
		s_mov_b32 s48, 0x10000
		s_mov_b32 s49, 0
		v_mov_b32_e32 v84, s48
		v_mov_b32_e32 v85, s49
		v_mul_lo_u32 v86, v84, v82
		v_mul_hi_u32 v87, v84, v82
		v_mul_lo_u32 v1, v84, v83
		v_add_u32_e32 v87, v87, v1
		v_mul_lo_u32 v1, v85, v82
		v_add_u32_e32 v87, v87, v1
		v_add_co_u32_e64 v88, vcc, v74, v86
		v_addc_co_u32_e64 v89, vcc, v75, v87, vcc
		v_mov_b32_e32 v1, 63
		v_and_b32_e32 v90, v76, v1
		v_and_b32_e32 v91, v11, v11
		v_mul_lo_u32 v76, v78, v90
		v_mul_hi_u32 v77, v78, v90
		v_mul_lo_u32 v1, v78, v91
		v_add_u32_e32 v77, v77, v1
		v_mul_lo_u32 v1, v79, v90
		v_add_u32_e32 v77, v77, v1
		v_lshrrev_b64 v[78:79], 2, v[76:77]
		s_mov_b32 s48, 0x1000
		s_mov_b32 s49, 0
		v_mov_b32_e32 v92, s48
		v_mov_b32_e32 v93, s49
		v_mul_lo_u32 v94, v92, v78
		v_mul_hi_u32 v95, v92, v78
		v_mul_lo_u32 v1, v92, v79
		v_add_u32_e32 v95, v95, v1
		v_mul_lo_u32 v1, v93, v78
		v_add_u32_e32 v95, v95, v1
		v_add_co_u32_e64 v78, vcc, v88, v94
		v_addc_co_u32_e64 v79, vcc, v89, v95, vcc
		v_lshrrev_b64 v[88:89], 3, v[76:77]
		v_mov_b32_e32 v1, 3
		v_and_b32_e32 v76, v88, v1
		v_and_b32_e32 v77, v89, v11
		v_and_b32_e32 v88, v90, v1
		v_and_b32_e32 v89, v91, v11
		v_xor_b32_e32 v92, v76, v88
		v_xor_b32_e32 v93, v77, v89
		s_mov_b32 s48, 16
		s_mov_b32 s49, 0
		v_mov_b32_e32 v76, s48
		v_mov_b32_e32 v77, s49
		v_mul_lo_u32 v88, v76, v92
		v_mul_hi_u32 v89, v76, v92
		v_mul_lo_u32 v1, v76, v93
		v_add_u32_e32 v89, v89, v1
		v_mul_lo_u32 v1, v77, v92
		v_add_u32_e32 v89, v89, v1
		v_add_co_u32_e64 v92, vcc, v78, v88
		v_addc_co_u32_e64 v93, vcc, v79, v89, vcc
		s_mov_b32 s48, 0x80
		s_mov_b32 s49, 0
		v_mov_b32_e32 v78, s48
		v_mov_b32_e32 v79, s49
		v_mov_b32_e32 v1, 0x80000
		v_add_co_u32_e64 v96, vcc, v74, v1
		v_addc_co_u32_e64 v97, vcc, v75, 0, vcc
		v_add_co_u32_e64 v98, vcc, v96, v86
		v_addc_co_u32_e64 v99, vcc, v97, v87, vcc
		v_add_co_u32_e64 v96, vcc, v98, v94
		v_addc_co_u32_e64 v97, vcc, v99, v95, vcc
		v_add_co_u32_e64 v98, vcc, v96, v88
		v_addc_co_u32_e64 v99, vcc, v97, v89, vcc
		v_mov_b32_e32 v2, 64
		v_add_co_u32_e64 v96, vcc, v74, v2
		v_addc_co_u32_e64 v97, vcc, v75, 0, vcc
		v_add_co_u32_e64 v100, vcc, v96, v86
		v_addc_co_u32_e64 v101, vcc, v97, v87, vcc
		v_add_co_u32_e64 v96, vcc, v100, v94
		v_addc_co_u32_e64 v97, vcc, v101, v95, vcc
		v_add_co_u32_e64 v100, vcc, v96, v88
		v_addc_co_u32_e64 v101, vcc, v97, v89, vcc
		v_mov_b32_e32 v9, 0x80040
		v_add_co_u32_e64 v96, vcc, v74, v9
		v_addc_co_u32_e64 v97, vcc, v75, 0, vcc
		v_add_co_u32_e64 v102, vcc, v96, v86
		v_addc_co_u32_e64 v103, vcc, v97, v87, vcc
		v_add_co_u32_e64 v96, vcc, v102, v94
		v_addc_co_u32_e64 v97, vcc, v103, v95, vcc
		v_add_co_u32_e64 v102, vcc, v96, v88
		v_addc_co_u32_e64 v103, vcc, v97, v89, vcc
		v_mov_b32_e32 v96, s14
		v_mov_b32_e32 v97, 0
		v_mul_lo_u32 v104, v72, v96
		v_mul_hi_u32 v105, v72, v96
		v_mul_lo_u32 v12, v72, v97
		v_add_u32_e32 v105, v105, v12
		v_mul_lo_u32 v12, v73, v96
		v_add_u32_e32 v105, v105, v12
		v_add_co_u32_e64 v72, vcc, v104, v86
		v_addc_co_u32_e64 v73, vcc, v105, v87, vcc
		v_add_co_u32_e64 v106, vcc, v72, v94
		v_addc_co_u32_e64 v107, vcc, v73, v95, vcc
		v_add_co_u32_e64 v72, vcc, v106, v88
		v_addc_co_u32_e64 v73, vcc, v107, v89, vcc
		v_add_co_u32_e64 v106, vcc, v104, v1
		v_addc_co_u32_e64 v107, vcc, v105, 0, vcc
		v_add_co_u32_e64 v108, vcc, v106, v86
		v_addc_co_u32_e64 v109, vcc, v107, v87, vcc
		v_add_co_u32_e64 v106, vcc, v108, v94
		v_addc_co_u32_e64 v107, vcc, v109, v95, vcc
		v_add_co_u32_e64 v108, vcc, v106, v88
		v_addc_co_u32_e64 v109, vcc, v107, v89, vcc
		v_add_co_u32_e64 v106, vcc, v104, v2
		v_addc_co_u32_e64 v107, vcc, v105, 0, vcc
		v_add_co_u32_e64 v110, vcc, v106, v86
		v_addc_co_u32_e64 v111, vcc, v107, v87, vcc
		v_add_co_u32_e64 v106, vcc, v110, v94
		v_addc_co_u32_e64 v107, vcc, v111, v95, vcc
		v_add_co_u32_e64 v110, vcc, v106, v88
		v_addc_co_u32_e64 v111, vcc, v107, v89, vcc
		v_add_co_u32_e64 v106, vcc, v104, v9
		v_addc_co_u32_e64 v107, vcc, v105, 0, vcc
		v_add_co_u32_e64 v112, vcc, v106, v86
		v_addc_co_u32_e64 v113, vcc, v107, v87, vcc
		v_add_co_u32_e64 v106, vcc, v112, v94
		v_addc_co_u32_e64 v107, vcc, v113, v95, vcc
		v_add_co_u32_e64 v112, vcc, v106, v88
		v_addc_co_u32_e64 v113, vcc, v107, v89, vcc
		v_mul_lo_u32 v106, v84, v96
		v_mul_hi_u32 v107, v84, v96
		v_mul_lo_u32 v1, v84, v97
		v_add_u32_e32 v107, v107, v1
		v_mul_lo_u32 v1, v85, v96
		v_add_u32_e32 v107, v107, v1
		v_add_co_u32_e64 v84, vcc, v74, v106
		v_addc_co_u32_e64 v85, vcc, v75, v107, vcc
		v_lshrrev_b64 v[96:97], 7, v[80:81]
		s_mov_b32 s48, 0x200
		s_mov_b32 s49, 0
		v_mov_b32_e32 v80, s48
		v_mov_b32_e32 v81, s49
		v_mul_lo_u32 v114, v80, v96
		v_mul_hi_u32 v115, v80, v96
		v_mul_lo_u32 v1, v80, v97
		v_add_u32_e32 v115, v115, v1
		v_mul_lo_u32 v1, v81, v96
		v_add_u32_e32 v115, v115, v1
		v_add_co_u32_e64 v80, vcc, v84, v114
		v_addc_co_u32_e64 v81, vcc, v85, v115, vcc
		s_mov_b32 s48, 4
		s_mov_b32 s49, 0
		v_mov_b32_e32 v96, s48
		v_mov_b32_e32 v97, s49
		v_mul_lo_u32 v116, v96, v90
		v_mul_hi_u32 v117, v96, v90
		v_mul_lo_u32 v1, v96, v91
		v_add_u32_e32 v117, v117, v1
		v_mul_lo_u32 v1, v97, v90
		v_add_u32_e32 v117, v117, v1
		v_add_co_u32_e64 v96, vcc, v80, v116
		v_addc_co_u32_e64 v97, vcc, v81, v117, vcc
		s_mov_b32 s48, 0x800
		s_mov_b32 s49, 0
		v_mov_b32_e32 v80, s48
		v_mov_b32_e32 v81, s49
		v_mov_b32_e32 v1, 0x100
		v_add_co_u32_e64 v118, vcc, v74, v1
		v_addc_co_u32_e64 v119, vcc, v75, 0, vcc
		v_add_co_u32_e64 v120, vcc, v118, v106
		v_addc_co_u32_e64 v121, vcc, v119, v107, vcc
		v_add_co_u32_e64 v118, vcc, v120, v114
		v_addc_co_u32_e64 v119, vcc, v121, v115, vcc
		v_add_co_u32_e64 v120, vcc, v118, v116
		v_addc_co_u32_e64 v121, vcc, v119, v117, vcc
		v_mul_lo_u32 v118, v76, v90
		v_mul_hi_u32 v119, v76, v90
		v_mul_lo_u32 v1, v76, v91
		v_add_u32_e32 v119, v119, v1
		v_mul_lo_u32 v1, v77, v90
		v_add_u32_e32 v119, v119, v1
		v_add_co_u32_e64 v76, vcc, v84, v118
		v_addc_co_u32_e64 v77, vcc, v85, v119, vcc
		v_mov_b32_e32 v1, 1
		v_and_b32_e32 v84, v82, v1
		v_and_b32_e32 v85, v83, v11
		s_mov_b32 s48, 0x400
		s_mov_b32 s49, 0
		v_mov_b32_e32 v10, s48
		v_mov_b32_e32 v11, s49
		v_mul_lo_u32 v82, v10, v84
		v_mul_hi_u32 v83, v10, v84
		v_mul_lo_u32 v1, v10, v85
		v_add_u32_e32 v83, v83, v1
		v_mul_lo_u32 v1, v11, v84
		v_add_u32_e32 v83, v83, v1
		v_add_co_u32_e64 v10, vcc, v76, v82
		v_addc_co_u32_e64 v11, vcc, v77, v83, vcc
		v_mov_b32_e32 v1, 0x80
		v_add_co_u32_e64 v76, vcc, v74, v1
		v_addc_co_u32_e64 v77, vcc, v75, 0, vcc
		v_add_co_u32_e64 v84, vcc, v76, v86
		v_addc_co_u32_e64 v85, vcc, v77, v87, vcc
		v_add_co_u32_e64 v76, vcc, v84, v94
		v_addc_co_u32_e64 v77, vcc, v85, v95, vcc
		v_add_co_u32_e64 v84, vcc, v76, v88
		v_addc_co_u32_e64 v85, vcc, v77, v89, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v84, s47
		scratch_store_dword off, v85, s47 offset:4
		v_mov_b32_e32 v2, 0x80080
		v_add_co_u32_e64 v76, vcc, v74, v2
		v_addc_co_u32_e64 v77, vcc, v75, 0, vcc
		v_add_co_u32_e64 v84, vcc, v76, v86
		v_addc_co_u32_e64 v85, vcc, v77, v87, vcc
		v_add_co_u32_e64 v76, vcc, v84, v94
		v_addc_co_u32_e64 v77, vcc, v85, v95, vcc
		v_add_co_u32_e64 v84, vcc, v76, v88
		v_addc_co_u32_e64 v85, vcc, v77, v89, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v84, s47 offset:8
		scratch_store_dword off, v85, s47 offset:12
		v_mov_b32_e32 v9, 0xc0
		v_add_co_u32_e64 v76, vcc, v74, v9
		v_addc_co_u32_e64 v77, vcc, v75, 0, vcc
		v_add_co_u32_e64 v84, vcc, v76, v86
		v_addc_co_u32_e64 v85, vcc, v77, v87, vcc
		v_add_co_u32_e64 v76, vcc, v84, v94
		v_addc_co_u32_e64 v77, vcc, v85, v95, vcc
		v_add_co_u32_e64 v84, vcc, v76, v88
		v_addc_co_u32_e64 v85, vcc, v77, v89, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v84, s47 offset:16
		scratch_store_dword off, v85, s47 offset:20
		v_mov_b32_e32 v12, 0x800c0
		v_add_co_u32_e64 v76, vcc, v74, v12
		v_addc_co_u32_e64 v77, vcc, v75, 0, vcc
		v_add_co_u32_e64 v84, vcc, v76, v86
		v_addc_co_u32_e64 v85, vcc, v77, v87, vcc
		v_add_co_u32_e64 v76, vcc, v84, v94
		v_addc_co_u32_e64 v77, vcc, v85, v95, vcc
		v_add_co_u32_e64 v84, vcc, v76, v88
		v_addc_co_u32_e64 v85, vcc, v77, v89, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v84, s47 offset:24
		scratch_store_dword off, v85, s47 offset:28
		v_add_co_u32_e64 v76, vcc, v104, v1
		v_addc_co_u32_e64 v77, vcc, v105, 0, vcc
		v_add_co_u32_e64 v84, vcc, v76, v86
		v_addc_co_u32_e64 v85, vcc, v77, v87, vcc
		v_add_co_u32_e64 v76, vcc, v84, v94
		v_addc_co_u32_e64 v77, vcc, v85, v95, vcc
		v_add_co_u32_e64 v84, vcc, v76, v88
		v_addc_co_u32_e64 v85, vcc, v77, v89, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v84, s47 offset:32
		scratch_store_dword off, v85, s47 offset:36
		v_add_co_u32_e64 v76, vcc, v104, v2
		v_addc_co_u32_e64 v77, vcc, v105, 0, vcc
		v_add_co_u32_e64 v84, vcc, v76, v86
		v_addc_co_u32_e64 v85, vcc, v77, v87, vcc
		v_add_co_u32_e64 v76, vcc, v84, v94
		v_addc_co_u32_e64 v77, vcc, v85, v95, vcc
		v_add_co_u32_e64 v84, vcc, v76, v88
		v_addc_co_u32_e64 v85, vcc, v77, v89, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v84, s47 offset:40
		scratch_store_dword off, v85, s47 offset:44
		v_add_co_u32_e64 v76, vcc, v104, v9
		v_addc_co_u32_e64 v77, vcc, v105, 0, vcc
		v_add_co_u32_e64 v84, vcc, v76, v86
		v_addc_co_u32_e64 v85, vcc, v77, v87, vcc
		v_add_co_u32_e64 v76, vcc, v84, v94
		v_addc_co_u32_e64 v77, vcc, v85, v95, vcc
		v_add_co_u32_e64 v84, vcc, v76, v88
		v_addc_co_u32_e64 v85, vcc, v77, v89, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v84, s47 offset:48
		scratch_store_dword off, v85, s47 offset:52
		v_add_co_u32_e64 v76, vcc, v104, v12
		v_addc_co_u32_e64 v77, vcc, v105, 0, vcc
		v_add_co_u32_e64 v84, vcc, v76, v86
		v_addc_co_u32_e64 v85, vcc, v77, v87, vcc
		v_add_co_u32_e64 v76, vcc, v84, v94
		v_addc_co_u32_e64 v77, vcc, v85, v95, vcc
		v_add_co_u32_e64 v84, vcc, v76, v88
		v_addc_co_u32_e64 v85, vcc, v77, v89, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v84, s47 offset:56
		scratch_store_dword off, v85, s47 offset:60
		v_mov_b32_e32 v1, 0x800
		v_add_co_u32_e64 v76, vcc, v74, v1
		v_addc_co_u32_e64 v77, vcc, v75, 0, vcc
		v_add_co_u32_e64 v84, vcc, v76, v106
		v_addc_co_u32_e64 v85, vcc, v77, v107, vcc
		v_add_co_u32_e64 v76, vcc, v84, v114
		v_addc_co_u32_e64 v77, vcc, v85, v115, vcc
		v_add_co_u32_e64 v86, vcc, v76, v116
		v_addc_co_u32_e64 v87, vcc, v77, v117, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v86, s47 offset:64
		scratch_store_dword off, v87, s47 offset:68
		v_mov_b32_e32 v1, 0x900
		v_add_co_u32_e64 v76, vcc, v74, v1
		v_addc_co_u32_e64 v77, vcc, v75, 0, vcc
		v_add_co_u32_e64 v74, vcc, v76, v106
		v_addc_co_u32_e64 v75, vcc, v77, v107, vcc
		v_add_co_u32_e64 v76, vcc, v74, v114
		v_addc_co_u32_e64 v77, vcc, v75, v115, vcc
		v_add_co_u32_e64 v74, vcc, v76, v116
		v_addc_co_u32_e64 v75, vcc, v77, v117, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v74, s47 offset:76
		scratch_store_dword off, v75, s47 offset:80
		v_add_co_u32_e64 v74, vcc, v84, v118
		v_addc_co_u32_e64 v75, vcc, v85, v119, vcc
		v_add_co_u32_e64 v76, vcc, v74, v82
		v_addc_co_u32_e64 v77, vcc, v75, v83, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v76, s47 offset:84
		scratch_store_dword off, v77, s47 offset:88
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_mov_b64_e32 v[104:105], 0
		v_mov_b64_e32 v[106:107], 0
		v_mov_b64_e32 v[116:117], 0
		v_mov_b64_e32 v[118:119], 0
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
		v_mov_b64_e32 v[216:217], 0
		v_mov_b64_e32 v[218:219], 0
		v_mov_b64_e32 v[220:221], 0
		v_mov_b64_e32 v[222:223], 0
		v_mov_b64_e32 v[224:225], 0
		v_mov_b64_e32 v[226:227], 0
		v_mov_b64_e32 v[228:229], 0
		v_mov_b64_e32 v[230:231], 0
.Lwmma_f16_matmul_tiled.loop_head_0:
		v_mov_b32_e32 v74, s46
		v_mov_b32_e32 v75, 0
		v_mul_lo_u32 v76, v78, v74
		v_mul_hi_u32 v77, v78, v74
		v_mul_lo_u32 v1, v78, v75
		v_add_u32_e32 v77, v77, v1
		v_mul_lo_u32 v1, v79, v74
		v_add_u32_e32 v77, v77, v1
		v_add_co_u32_e64 v74, vcc, v92, v76
		v_addc_co_u32_e64 v75, vcc, v93, v77, vcc
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x23000, v1
		ds_write_b32 v2, v74
		v_add_co_u32_e64 v74, vcc, v98, v76
		v_addc_co_u32_e64 v75, vcc, v99, v77, vcc
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x23800, v1
		ds_write_b32 v2, v74
		v_add_co_u32_e64 v74, vcc, v100, v76
		v_addc_co_u32_e64 v75, vcc, v101, v77, vcc
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x24000, v1
		ds_write_b32 v2, v74
		v_add_co_u32_e64 v74, vcc, v102, v76
		v_addc_co_u32_e64 v75, vcc, v103, v77, vcc
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x24800, v1
		ds_write_b32 v2, v74
		v_add_co_u32_e64 v74, vcc, v72, v76
		v_addc_co_u32_e64 v75, vcc, v73, v77, vcc
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x25000, v1
		ds_write_b32 v2, v74
		v_add_co_u32_e64 v74, vcc, v108, v76
		v_addc_co_u32_e64 v75, vcc, v109, v77, vcc
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x25800, v1
		ds_write_b32 v2, v74
		v_add_co_u32_e64 v74, vcc, v110, v76
		v_addc_co_u32_e64 v75, vcc, v111, v77, vcc
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x26000, v1
		ds_write_b32 v2, v74
		v_add_co_u32_e64 v74, vcc, v112, v76
		v_addc_co_u32_e64 v75, vcc, v113, v77, vcc
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x27000, v1
		ds_write_b32 v2, v74
		v_mov_b32_e32 v74, s46
		v_mov_b32_e32 v75, 0
		v_mul_lo_u32 v82, v80, v74
		v_mul_hi_u32 v83, v80, v74
		v_mul_lo_u32 v1, v80, v75
		v_add_u32_e32 v83, v83, v1
		v_mul_lo_u32 v1, v81, v74
		v_add_u32_e32 v83, v83, v1
		s_mov_b32 s47, 0
		scratch_store_dword off, v82, s47 offset:120
		scratch_store_dword off, v83, s47 offset:124
		v_add_co_u32_e64 v74, vcc, v96, v82
		v_addc_co_u32_e64 v75, vcc, v97, v83, vcc
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x27800, v1
		ds_write_b32 v2, v74
		v_add_co_u32_e64 v74, vcc, v120, v82
		v_addc_co_u32_e64 v75, vcc, v121, v83, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v74, s47 offset:96
		v_add_co_u32_e64 v74, vcc, v10, v82
		v_addc_co_u32_e64 v75, vcc, v11, v83, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v74, s47 offset:100
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[20:23], v[36:39], v[4:7], v16, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s47, s46, 1
		s_lshl_b32 s48, s47, 16
		v_add_u32_e32 v1, s48, v13
		v_add3_u32 v2, v1, v14, v3
		ds_read_b128 v[232:235], v2 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[20:23], v[40:43], v[84:87], v16, v17 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[236:239], v2 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[20:23], v[44:47], v[88:91], v16, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v2 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[20:23], v[48:51], v[104:107], v16, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[244:247], v2 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[20:23], v[52:55], v[116:119], v16, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, s48, v14
		v_add3_u32 v2, v1, v8, v3
		ds_read_b128 v[248:251], v2 offset:49152
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s48 offset:132
		scratch_store_dword off, v249, s48 offset:136
		scratch_store_dword off, v250, s48 offset:140
		scratch_store_dword off, v251, s48 offset:144
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], v[56:59], v[124:127], v16, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v2 offset:50176
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s48 offset:148
		scratch_store_dword off, v249, s48 offset:152
		scratch_store_dword off, v250, s48 offset:156
		scratch_store_dword off, v251, s48 offset:160
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[20:23], v[60:63], v[128:131], v16, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v2 offset:51200
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s48 offset:164
		scratch_store_dword off, v249, s48 offset:168
		scratch_store_dword off, v250, s48 offset:172
		scratch_store_dword off, v251, s48 offset:176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[20:23], v[64:67], v[132:135], v16, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v2 offset:52224
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s48 offset:180
		scratch_store_dword off, v249, s48 offset:184
		scratch_store_dword off, v250, s48 offset:188
		scratch_store_dword off, v251, s48 offset:192
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[24:27], v[36:39], v[136:139], v16, v17 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v2 offset:53248
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s48 offset:196
		scratch_store_dword off, v249, s48 offset:200
		scratch_store_dword off, v250, s48 offset:204
		scratch_store_dword off, v251, s48 offset:208
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[24:27], v[40:43], v[140:143], v16, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v2 offset:54272
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s48 offset:212
		scratch_store_dword off, v249, s48 offset:216
		scratch_store_dword off, v250, s48 offset:220
		scratch_store_dword off, v251, s48 offset:224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[44:47], v[144:147], v16, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v2 offset:55296
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s48 offset:240
		scratch_store_dword off, v249, s48 offset:244
		scratch_store_dword off, v250, s48 offset:248
		scratch_store_dword off, v251, s48 offset:252
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[48:51], v[148:151], v16, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v2 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[52:55], v[152:155], v16, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x23000, v1
		ds_read_b32 v1, v2
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[56:59], v[156:159], v16, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s28
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x23800, v1
		ds_read_b32 v1, v2
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[24:27], v[60:63], v[160:163], v16, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s29
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x24000, v1
		ds_read_b32 v1, v2
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[24:27], v[64:67], v[164:167], v16, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s30
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x24800, v1
		ds_read_b32 v1, v2
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[28:31], v[36:39], v[168:171], v18, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s31
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x25000, v1
		ds_read_b32 v1, v2
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v1, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[28:31], v[40:43], v[172:175], v18, v17 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s32
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x25800, v1
		ds_read_b32 v1, v2
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v1, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[44:47], v[176:179], v18, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s33
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x26000, v1
		ds_read_b32 v1, v2
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v1, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[48:51], v[180:183], v18, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s34
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x27000, v1
		ds_read_b32 v1, v2
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v1, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[52:55], v[184:187], v18, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s8, 0x20000
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x27800, v1
		ds_read_b32 v1, v2
		s_waitcnt lgkmcnt(0)
		buffer_load_dword v1, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[56:59], v[188:191], v18, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s37, 0x20000
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(29)
		scratch_load_dword v1, off, s48 offset:96
		s_waitcnt vmcnt(0)
		buffer_load_dword v1, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[28:31], v[60:63], v[192:195], v18, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s36, 0x20000
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(28)
		scratch_load_dword v1, off, s48 offset:100
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], v[64:67], v[196:199], v18, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		s_lshl_b32 s48, s47, 16
		s_mov_b32 s49, 0
		scratch_load_dword v1, off, s49 offset:72
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v2, s48, v1
		s_mov_b32 s48, 0
		scratch_load_dword v1, off, s48 offset:112
		s_mov_b32 s48, 0
		scratch_load_dword v9, off, s48 offset:116
		s_waitcnt vmcnt(0)
		v_add3_u32 v12, v2, v1, v9
		ds_read_b128 v[20:23], v12
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[32:35], v[36:39], v[200:203], v18, v17 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v12 offset:1024
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[32:35], v[40:43], v[204:207], v18, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[28:31], v12 offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[44:47], v[208:211], v18, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[252:255], v12 offset:3072
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v252, s48 offset:256
		scratch_store_dword off, v253, s48 offset:260
		scratch_store_dword off, v254, s48 offset:264
		scratch_store_dword off, v255, s48 offset:268
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[48:51], v[212:215], v18, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshl_b32 s48, s47, 16
		s_mov_b32 s49, 0
		scratch_load_dword v1, off, s49 offset:228
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v2, s48, v1
		s_mov_b32 s48, 0
		scratch_load_dword v1, off, s48 offset:232
		s_mov_b32 s48, 0
		scratch_load_dword v9, off, s48 offset:236
		s_waitcnt vmcnt(0)
		v_add3_u32 v12, v2, v9, v1
		ds_read_b128 v[36:39], v12 offset:32768
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[52:55], v[216:219], v18, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[40:43], v12 offset:33792
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], v[56:59], v[220:223], v18, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[44:47], v12 offset:34816
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[32:35], v[60:63], v[224:227], v18, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[48:51], v12 offset:35840
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], v[64:67], v[228:231], v18, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[52:55], v12 offset:36864
		ds_read_b128 v[56:59], v12 offset:37888
		ds_read_b128 v[60:63], v12 offset:38912
		ds_read_b128 v[64:67], v12 offset:39936
		s_lshl_b32 s48, s47, 12
		s_add_i32 s47, s48, 0x20000
		s_mov_b32 s48, 0
		scratch_load_dword v1, off, s48 offset:104
		s_mov_b32 s48, 0
		scratch_load_dword v2, off, s48 offset:128
		s_waitcnt vmcnt(0)
		v_add3_u32 v9, s47, v1, v2
		ds_read_b32 v1, v9
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v1, s48 offset:272
		ds_read_b32 v1, v9 offset:256
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v1, s48 offset:276
		s_mov_b32 s48, 0
		scratch_load_dword v1, off, s48 offset:108
		s_mov_b32 s48, 0
		scratch_load_dword v2, off, s48 offset:128
		s_waitcnt vmcnt(0)
		v_add3_u32 v9, s47, v2, v1
		ds_read_b32 v1, v9 offset:2048
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v1, s47 offset:280
		ds_read_b32 v1, v9 offset:2304
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v1, s47 offset:284
		ds_read_b32 v1, v9 offset:2560
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v1, s47 offset:288
		ds_read_b32 v1, v9 offset:2816
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v1, s47 offset:292
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(34)
		scratch_load_dword v252, off, s47 offset:132
		scratch_load_dword v253, off, s47 offset:136
		scratch_load_dword v254, off, s47 offset:140
		scratch_load_dword v255, off, s47 offset:144
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[232:235], v[252:255], v[4:7], v16, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(30)
		scratch_load_dword v252, off, s47 offset:148
		scratch_load_dword v253, off, s47 offset:152
		scratch_load_dword v254, off, s47 offset:156
		scratch_load_dword v255, off, s47 offset:160
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[232:235], v[252:255], v[84:87], v16, v17 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(26)
		scratch_load_dword v252, off, s47 offset:164
		scratch_load_dword v253, off, s47 offset:168
		scratch_load_dword v254, off, s47 offset:172
		scratch_load_dword v255, off, s47 offset:176
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[232:235], v[252:255], v[88:91], v16, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(22)
		scratch_load_dword v252, off, s47 offset:180
		scratch_load_dword v253, off, s47 offset:184
		scratch_load_dword v254, off, s47 offset:188
		scratch_load_dword v255, off, s47 offset:192
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[232:235], v[252:255], v[104:107], v16, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(18)
		scratch_load_dword v252, off, s47 offset:196
		scratch_load_dword v253, off, s47 offset:200
		scratch_load_dword v254, off, s47 offset:204
		scratch_load_dword v255, off, s47 offset:208
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[232:235], v[252:255], v[116:119], v16, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(14)
		scratch_load_dword v252, off, s47 offset:212
		scratch_load_dword v253, off, s47 offset:216
		scratch_load_dword v254, off, s47 offset:220
		scratch_load_dword v255, off, s47 offset:224
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[232:235], v[252:255], v[124:127], v16, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(10)
		scratch_load_dword v252, off, s47 offset:240
		scratch_load_dword v253, off, s47 offset:244
		scratch_load_dword v254, off, s47 offset:248
		scratch_load_dword v255, off, s47 offset:252
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[232:235], v[252:255], v[128:131], v16, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[232:235], v[248:251], v[132:135], v16, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:132
		scratch_load_dword v233, off, s47 offset:136
		scratch_load_dword v234, off, s47 offset:140
		scratch_load_dword v235, off, s47 offset:144
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[236:239], v[232:235], v[136:139], v16, v17 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:148
		scratch_load_dword v233, off, s47 offset:152
		scratch_load_dword v234, off, s47 offset:156
		scratch_load_dword v235, off, s47 offset:160
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[236:239], v[232:235], v[140:143], v16, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:164
		scratch_load_dword v233, off, s47 offset:168
		scratch_load_dword v234, off, s47 offset:172
		scratch_load_dword v235, off, s47 offset:176
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[236:239], v[232:235], v[144:147], v16, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:180
		scratch_load_dword v233, off, s47 offset:184
		scratch_load_dword v234, off, s47 offset:188
		scratch_load_dword v235, off, s47 offset:192
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[236:239], v[232:235], v[148:151], v16, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:196
		scratch_load_dword v233, off, s47 offset:200
		scratch_load_dword v234, off, s47 offset:204
		scratch_load_dword v235, off, s47 offset:208
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[236:239], v[232:235], v[152:155], v16, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:212
		scratch_load_dword v233, off, s47 offset:216
		scratch_load_dword v234, off, s47 offset:220
		scratch_load_dword v235, off, s47 offset:224
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[236:239], v[232:235], v[156:159], v16, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:240
		scratch_load_dword v233, off, s47 offset:244
		scratch_load_dword v234, off, s47 offset:248
		scratch_load_dword v235, off, s47 offset:252
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[236:239], v[232:235], v[160:163], v16, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[236:239], v[248:251], v[164:167], v16, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:132
		scratch_load_dword v233, off, s47 offset:136
		scratch_load_dword v234, off, s47 offset:140
		scratch_load_dword v235, off, s47 offset:144
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[240:243], v[232:235], v[168:171], v18, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:148
		scratch_load_dword v233, off, s47 offset:152
		scratch_load_dword v234, off, s47 offset:156
		scratch_load_dword v235, off, s47 offset:160
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[240:243], v[232:235], v[172:175], v18, v17 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:164
		scratch_load_dword v233, off, s47 offset:168
		scratch_load_dword v234, off, s47 offset:172
		scratch_load_dword v235, off, s47 offset:176
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[240:243], v[232:235], v[176:179], v18, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:180
		scratch_load_dword v233, off, s47 offset:184
		scratch_load_dword v234, off, s47 offset:188
		scratch_load_dword v235, off, s47 offset:192
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[240:243], v[232:235], v[180:183], v18, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:196
		scratch_load_dword v233, off, s47 offset:200
		scratch_load_dword v234, off, s47 offset:204
		scratch_load_dword v235, off, s47 offset:208
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[240:243], v[232:235], v[184:187], v18, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:212
		scratch_load_dword v233, off, s47 offset:216
		scratch_load_dword v234, off, s47 offset:220
		scratch_load_dword v235, off, s47 offset:224
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[240:243], v[232:235], v[188:191], v18, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:240
		scratch_load_dword v233, off, s47 offset:244
		scratch_load_dword v234, off, s47 offset:248
		scratch_load_dword v235, off, s47 offset:252
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[240:243], v[232:235], v[192:195], v18, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[240:243], v[248:251], v[196:199], v18, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:132
		scratch_load_dword v233, off, s47 offset:136
		scratch_load_dword v234, off, s47 offset:140
		scratch_load_dword v235, off, s47 offset:144
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[244:247], v[232:235], v[200:203], v18, v17 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:148
		scratch_load_dword v233, off, s47 offset:152
		scratch_load_dword v234, off, s47 offset:156
		scratch_load_dword v235, off, s47 offset:160
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[244:247], v[232:235], v[204:207], v18, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:164
		scratch_load_dword v233, off, s47 offset:168
		scratch_load_dword v234, off, s47 offset:172
		scratch_load_dword v235, off, s47 offset:176
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[244:247], v[232:235], v[208:211], v18, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:180
		scratch_load_dword v233, off, s47 offset:184
		scratch_load_dword v234, off, s47 offset:188
		scratch_load_dword v235, off, s47 offset:192
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[244:247], v[232:235], v[212:215], v18, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:196
		scratch_load_dword v233, off, s47 offset:200
		scratch_load_dword v234, off, s47 offset:204
		scratch_load_dword v235, off, s47 offset:208
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[244:247], v[232:235], v[216:219], v18, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:212
		scratch_load_dword v233, off, s47 offset:216
		scratch_load_dword v234, off, s47 offset:220
		scratch_load_dword v235, off, s47 offset:224
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[244:247], v[232:235], v[220:223], v18, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:240
		scratch_load_dword v233, off, s47 offset:244
		scratch_load_dword v234, off, s47 offset:248
		scratch_load_dword v235, off, s47 offset:252
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[244:247], v[232:235], v[224:227], v18, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[244:247], v[248:251], v[228:231], v18, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s47, s46, 1
		s_and_b32 s48, s47, 1
		s_lshl_b32 s47, s48, 16
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x26800, v1
		ds_read_b32 v1, v2
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v2, s47, v1
		s_mov_b32 s49, 0
		scratch_load_dword v1, off, s49 offset:112
		s_mov_b32 s49, 0
		scratch_load_dword v9, off, s49 offset:116
		s_waitcnt vmcnt(0)
		v_add3_u32 v12, v2, v1, v9
		s_mov_b32 s49, 0
		scratch_store_dword off, v12, s49 offset:296
		ds_read_b128 v[232:235], v12
		s_mov_b32 s49, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v232, s49 offset:472
		scratch_store_dword off, v233, s49 offset:476
		scratch_store_dword off, v234, s49 offset:480
		scratch_store_dword off, v235, s49 offset:484
		ds_read_b128 v[236:239], v12 offset:1024
		s_mov_b32 s49, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s49 offset:488
		scratch_store_dword off, v237, s49 offset:492
		scratch_store_dword off, v238, s49 offset:496
		scratch_store_dword off, v239, s49 offset:500
		ds_read_b128 v[236:239], v12 offset:2048
		s_mov_b32 s49, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s49 offset:504
		scratch_store_dword off, v237, s49 offset:508
		scratch_store_dword off, v238, s49 offset:512
		scratch_store_dword off, v239, s49 offset:516
		ds_read_b128 v[236:239], v12 offset:3072
		s_mov_b32 s49, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s49 offset:520
		scratch_store_dword off, v237, s49 offset:524
		scratch_store_dword off, v238, s49 offset:528
		scratch_store_dword off, v239, s49 offset:532
		s_mov_b32 s49, 0
		scratch_load_dword v1, off, s49 offset:112
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v2, s47, v1
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:92
		s_mov_b32 s47, 0
		scratch_load_dword v9, off, s47 offset:116
		s_waitcnt vmcnt(0)
		v_add3_u32 v12, v2, v1, v9
		s_mov_b32 s47, 0
		scratch_store_dword off, v12, s47 offset:584
		ds_read_b128 v[236:239], v12 offset:32768
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s47 offset:300
		scratch_store_dword off, v237, s47 offset:304
		scratch_store_dword off, v238, s47 offset:308
		scratch_store_dword off, v239, s47 offset:312
		ds_read_b128 v[236:239], v12 offset:33792
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s47 offset:316
		scratch_store_dword off, v237, s47 offset:320
		scratch_store_dword off, v238, s47 offset:324
		scratch_store_dword off, v239, s47 offset:328
		ds_read_b128 v[236:239], v12 offset:34816
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s47 offset:332
		scratch_store_dword off, v237, s47 offset:336
		scratch_store_dword off, v238, s47 offset:340
		scratch_store_dword off, v239, s47 offset:344
		ds_read_b128 v[236:239], v12 offset:35840
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s47 offset:348
		scratch_store_dword off, v237, s47 offset:352
		scratch_store_dword off, v238, s47 offset:356
		scratch_store_dword off, v239, s47 offset:360
		ds_read_b128 v[236:239], v12 offset:36864
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s47 offset:364
		scratch_store_dword off, v237, s47 offset:368
		scratch_store_dword off, v238, s47 offset:372
		scratch_store_dword off, v239, s47 offset:376
		ds_read_b128 v[236:239], v12 offset:37888
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s47 offset:380
		scratch_store_dword off, v237, s47 offset:384
		scratch_store_dword off, v238, s47 offset:388
		scratch_store_dword off, v239, s47 offset:392
		ds_read_b128 v[236:239], v12 offset:38912
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s47 offset:440
		scratch_store_dword off, v237, s47 offset:444
		scratch_store_dword off, v238, s47 offset:448
		scratch_store_dword off, v239, s47 offset:452
		ds_read_b128 v[236:239], v12 offset:39936
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s47 offset:456
		scratch_store_dword off, v237, s47 offset:460
		scratch_store_dword off, v238, s47 offset:464
		scratch_store_dword off, v239, s47 offset:468
		s_lshl_b32 s47, s48, 12
		s_add_i32 s48, s47, 0x20000
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:104
		s_mov_b32 s47, 0
		scratch_load_dword v2, off, s47 offset:128
		s_waitcnt vmcnt(0)
		v_add3_u32 v9, s48, v1, v2
		ds_read_b32 v1, v9
		ds_read_b32 v2, v9 offset:256
		s_mov_b32 s47, 0
		scratch_load_dword v9, off, s47 offset:108
		s_mov_b32 s47, 0
		scratch_load_dword v15, off, s47 offset:128
		s_waitcnt vmcnt(0)
		v_add3_u32 v19, s48, v15, v9
		ds_read_b32 v9, v19 offset:2048
		ds_read_b32 v15, v19 offset:2304
		ds_read_b32 v71, v19 offset:2560
		ds_read_b32 v74, v19 offset:2816
		s_waitcnt lgkmcnt(0)
		s_mov_b32 s47, 0
		scratch_load_dword v82, off, s47
		scratch_load_dword v83, off, s47 offset:4
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v94, vcc, v82, v76
		v_addc_co_u32_e64 v95, vcc, v83, v77, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v94, s47 offset:396
		s_mov_b32 s47, 0
		scratch_load_dword v82, off, s47 offset:8
		scratch_load_dword v83, off, s47 offset:12
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v94, vcc, v82, v76
		v_addc_co_u32_e64 v95, vcc, v83, v77, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v94, s47 offset:400
		s_mov_b32 s47, 0
		scratch_load_dword v82, off, s47 offset:16
		scratch_load_dword v83, off, s47 offset:20
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v94, vcc, v82, v76
		v_addc_co_u32_e64 v95, vcc, v83, v77, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v94, s47 offset:404
		s_mov_b32 s47, 0
		scratch_load_dword v82, off, s47 offset:24
		scratch_load_dword v83, off, s47 offset:28
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v94, vcc, v82, v76
		v_addc_co_u32_e64 v95, vcc, v83, v77, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v94, s47 offset:408
		s_mov_b32 s47, 0
		scratch_load_dword v82, off, s47 offset:32
		scratch_load_dword v83, off, s47 offset:36
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v94, vcc, v82, v76
		v_addc_co_u32_e64 v95, vcc, v83, v77, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v94, s47 offset:412
		s_mov_b32 s47, 0
		scratch_load_dword v82, off, s47 offset:40
		scratch_load_dword v83, off, s47 offset:44
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v94, vcc, v82, v76
		v_addc_co_u32_e64 v95, vcc, v83, v77, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v94, s47 offset:416
		s_mov_b32 s47, 0
		scratch_load_dword v82, off, s47 offset:48
		scratch_load_dword v83, off, s47 offset:52
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v94, vcc, v82, v76
		v_addc_co_u32_e64 v95, vcc, v83, v77, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v94, s47 offset:420
		s_mov_b32 s47, 0
		scratch_load_dword v82, off, s47 offset:56
		scratch_load_dword v83, off, s47 offset:60
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v94, vcc, v82, v76
		v_addc_co_u32_e64 v95, vcc, v83, v77, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v94, s47 offset:424
		s_mov_b32 s47, 0
		scratch_load_dword v76, off, s47 offset:64
		scratch_load_dword v77, off, s47 offset:68
		s_mov_b32 s47, 0
		scratch_load_dword v82, off, s47 offset:120
		scratch_load_dword v83, off, s47 offset:124
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v94, vcc, v76, v82
		v_addc_co_u32_e64 v95, vcc, v77, v83, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v94, s47 offset:428
		s_mov_b32 s47, 0
		scratch_load_dword v76, off, s47 offset:76
		scratch_load_dword v77, off, s47 offset:80
		s_mov_b32 s47, 0
		scratch_load_dword v82, off, s47 offset:120
		scratch_load_dword v83, off, s47 offset:124
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v94, vcc, v76, v82
		v_addc_co_u32_e64 v95, vcc, v77, v83, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v94, s47 offset:432
		s_mov_b32 s47, 0
		scratch_load_dword v76, off, s47 offset:84
		scratch_load_dword v77, off, s47 offset:88
		s_mov_b32 s47, 0
		scratch_load_dword v82, off, s47 offset:120
		scratch_load_dword v83, off, s47 offset:124
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v94, vcc, v76, v82
		v_addc_co_u32_e64 v95, vcc, v77, v83, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v94, s47 offset:436
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(39)
		scratch_load_dword v236, off, s47 offset:300
		scratch_load_dword v237, off, s47 offset:304
		scratch_load_dword v238, off, s47 offset:308
		scratch_load_dword v239, off, s47 offset:312
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[232:235], v[236:239], v[4:7], v1, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v19, off, s47 offset:296
		s_waitcnt vmcnt(0)
		ds_read_b128 v[236:239], v19 offset:16384
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(35)
		scratch_load_dword v240, off, s47 offset:316
		scratch_load_dword v241, off, s47 offset:320
		scratch_load_dword v242, off, s47 offset:324
		scratch_load_dword v243, off, s47 offset:328
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[232:235], v[240:243], v[84:87], v1, v9 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v19, off, s47 offset:296
		s_waitcnt vmcnt(0)
		ds_read_b128 v[232:235], v19 offset:17408
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(31)
		scratch_load_dword v240, off, s47 offset:332
		scratch_load_dword v241, off, s47 offset:336
		scratch_load_dword v242, off, s47 offset:340
		scratch_load_dword v243, off, s47 offset:344
		s_mov_b32 s47, 0
		scratch_load_dword v244, off, s47 offset:472
		scratch_load_dword v245, off, s47 offset:476
		scratch_load_dword v246, off, s47 offset:480
		scratch_load_dword v247, off, s47 offset:484
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[244:247], v[240:243], v[88:91], v1, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v19, off, s47 offset:296
		s_waitcnt vmcnt(0)
		ds_read_b128 v[240:243], v19 offset:18432
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(27)
		scratch_load_dword v244, off, s47 offset:348
		scratch_load_dword v245, off, s47 offset:352
		scratch_load_dword v246, off, s47 offset:356
		scratch_load_dword v247, off, s47 offset:360
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:472
		scratch_load_dword v249, off, s47 offset:476
		scratch_load_dword v250, off, s47 offset:480
		scratch_load_dword v251, off, s47 offset:484
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[248:251], v[244:247], v[104:107], v1, v15 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v19, off, s47 offset:296
		s_waitcnt vmcnt(0)
		ds_read_b128 v[244:247], v19 offset:19456
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(23)
		scratch_load_dword v248, off, s47 offset:364
		scratch_load_dword v249, off, s47 offset:368
		scratch_load_dword v250, off, s47 offset:372
		scratch_load_dword v251, off, s47 offset:376
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:472
		scratch_load_dword v253, off, s47 offset:476
		scratch_load_dword v254, off, s47 offset:480
		scratch_load_dword v255, off, s47 offset:484
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[252:255], v[248:251], v[116:119], v1, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v12 offset:49152
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s47 offset:536
		scratch_store_dword off, v249, s47 offset:540
		scratch_store_dword off, v250, s47 offset:544
		scratch_store_dword off, v251, s47 offset:548
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(23)
		scratch_load_dword v248, off, s47 offset:380
		scratch_load_dword v249, off, s47 offset:384
		scratch_load_dword v250, off, s47 offset:388
		scratch_load_dword v251, off, s47 offset:392
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:472
		scratch_load_dword v253, off, s47 offset:476
		scratch_load_dword v254, off, s47 offset:480
		scratch_load_dword v255, off, s47 offset:484
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[252:255], v[248:251], v[124:127], v1, v71 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v12 offset:50176
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s47 offset:552
		scratch_store_dword off, v249, s47 offset:556
		scratch_store_dword off, v250, s47 offset:560
		scratch_store_dword off, v251, s47 offset:564
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(23)
		scratch_load_dword v248, off, s47 offset:440
		scratch_load_dword v249, off, s47 offset:444
		scratch_load_dword v250, off, s47 offset:448
		scratch_load_dword v251, off, s47 offset:452
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:472
		scratch_load_dword v253, off, s47 offset:476
		scratch_load_dword v254, off, s47 offset:480
		scratch_load_dword v255, off, s47 offset:484
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[252:255], v[248:251], v[128:131], v1, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v12 offset:51200
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s47 offset:568
		scratch_store_dword off, v249, s47 offset:572
		scratch_store_dword off, v250, s47 offset:576
		scratch_store_dword off, v251, s47 offset:580
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(23)
		scratch_load_dword v248, off, s47 offset:456
		scratch_load_dword v249, off, s47 offset:460
		scratch_load_dword v250, off, s47 offset:464
		scratch_load_dword v251, off, s47 offset:468
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:472
		scratch_load_dword v253, off, s47 offset:476
		scratch_load_dword v254, off, s47 offset:480
		scratch_load_dword v255, off, s47 offset:484
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[252:255], v[248:251], v[132:135], v1, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v12 offset:52224
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s47 offset:588
		scratch_store_dword off, v249, s47 offset:592
		scratch_store_dword off, v250, s47 offset:596
		scratch_store_dword off, v251, s47 offset:600
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:300
		scratch_load_dword v249, off, s47 offset:304
		scratch_load_dword v250, off, s47 offset:308
		scratch_load_dword v251, off, s47 offset:312
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:488
		scratch_load_dword v253, off, s47 offset:492
		scratch_load_dword v254, off, s47 offset:496
		scratch_load_dword v255, off, s47 offset:500
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[252:255], v[248:251], v[136:139], v1, v9 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v12, off, s47 offset:584
		s_waitcnt vmcnt(0)
		ds_read_b128 v[248:251], v12 offset:53248
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s47 offset:604
		scratch_store_dword off, v249, s47 offset:608
		scratch_store_dword off, v250, s47 offset:612
		scratch_store_dword off, v251, s47 offset:616
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:316
		scratch_load_dword v249, off, s47 offset:320
		scratch_load_dword v250, off, s47 offset:324
		scratch_load_dword v251, off, s47 offset:328
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:488
		scratch_load_dword v253, off, s47 offset:492
		scratch_load_dword v254, off, s47 offset:496
		scratch_load_dword v255, off, s47 offset:500
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[252:255], v[248:251], v[140:143], v1, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v12, off, s47 offset:584
		s_waitcnt vmcnt(0)
		ds_read_b128 v[248:251], v12 offset:54272
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s47 offset:620
		scratch_store_dword off, v249, s47 offset:624
		scratch_store_dword off, v250, s47 offset:628
		scratch_store_dword off, v251, s47 offset:632
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:332
		scratch_load_dword v249, off, s47 offset:336
		scratch_load_dword v250, off, s47 offset:340
		scratch_load_dword v251, off, s47 offset:344
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:488
		scratch_load_dword v253, off, s47 offset:492
		scratch_load_dword v254, off, s47 offset:496
		scratch_load_dword v255, off, s47 offset:500
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[252:255], v[248:251], v[144:147], v1, v15 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v12, off, s47 offset:584
		s_waitcnt vmcnt(0)
		ds_read_b128 v[248:251], v12 offset:55296
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s47 offset:636
		scratch_store_dword off, v249, s47 offset:640
		scratch_store_dword off, v250, s47 offset:644
		scratch_store_dword off, v251, s47 offset:648
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:348
		scratch_load_dword v249, off, s47 offset:352
		scratch_load_dword v250, off, s47 offset:356
		scratch_load_dword v251, off, s47 offset:360
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:488
		scratch_load_dword v253, off, s47 offset:492
		scratch_load_dword v254, off, s47 offset:496
		scratch_load_dword v255, off, s47 offset:500
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[252:255], v[248:251], v[148:151], v1, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v12, off, s47 offset:584
		s_waitcnt vmcnt(0)
		ds_read_b128 v[248:251], v12 offset:56320
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s47 offset:652
		scratch_store_dword off, v249, s47 offset:656
		scratch_store_dword off, v250, s47 offset:660
		scratch_store_dword off, v251, s47 offset:664
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:364
		scratch_load_dword v249, off, s47 offset:368
		scratch_load_dword v250, off, s47 offset:372
		scratch_load_dword v251, off, s47 offset:376
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:488
		scratch_load_dword v253, off, s47 offset:492
		scratch_load_dword v254, off, s47 offset:496
		scratch_load_dword v255, off, s47 offset:500
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[252:255], v[248:251], v[152:155], v1, v71 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s10
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(42)
		scratch_load_dword v12, off, s47 offset:396
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:380
		scratch_load_dword v249, off, s47 offset:384
		scratch_load_dword v250, off, s47 offset:388
		scratch_load_dword v251, off, s47 offset:392
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:488
		scratch_load_dword v253, off, s47 offset:492
		scratch_load_dword v254, off, s47 offset:496
		scratch_load_dword v255, off, s47 offset:500
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[252:255], v[248:251], v[156:159], v1, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s38
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(41)
		scratch_load_dword v12, off, s47 offset:400
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:440
		scratch_load_dword v249, off, s47 offset:444
		scratch_load_dword v250, off, s47 offset:448
		scratch_load_dword v251, off, s47 offset:452
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:488
		scratch_load_dword v253, off, s47 offset:492
		scratch_load_dword v254, off, s47 offset:496
		scratch_load_dword v255, off, s47 offset:500
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[252:255], v[248:251], v[160:163], v1, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s39
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(40)
		scratch_load_dword v12, off, s47 offset:404
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:456
		scratch_load_dword v249, off, s47 offset:460
		scratch_load_dword v250, off, s47 offset:464
		scratch_load_dword v251, off, s47 offset:468
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:488
		scratch_load_dword v253, off, s47 offset:492
		scratch_load_dword v254, off, s47 offset:496
		scratch_load_dword v255, off, s47 offset:500
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[252:255], v[248:251], v[164:167], v1, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s40
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(39)
		scratch_load_dword v12, off, s47 offset:408
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:300
		scratch_load_dword v249, off, s47 offset:304
		scratch_load_dword v250, off, s47 offset:308
		scratch_load_dword v251, off, s47 offset:312
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:504
		scratch_load_dword v253, off, s47 offset:508
		scratch_load_dword v254, off, s47 offset:512
		scratch_load_dword v255, off, s47 offset:516
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[252:255], v[248:251], v[168:171], v2, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s41
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(38)
		scratch_load_dword v12, off, s47 offset:412
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v12, s[0:3], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:316
		scratch_load_dword v249, off, s47 offset:320
		scratch_load_dword v250, off, s47 offset:324
		scratch_load_dword v251, off, s47 offset:328
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:504
		scratch_load_dword v253, off, s47 offset:508
		scratch_load_dword v254, off, s47 offset:512
		scratch_load_dword v255, off, s47 offset:516
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[252:255], v[248:251], v[172:175], v2, v9 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s42
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(37)
		scratch_load_dword v12, off, s47 offset:416
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v12, s[0:3], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:332
		scratch_load_dword v249, off, s47 offset:336
		scratch_load_dword v250, off, s47 offset:340
		scratch_load_dword v251, off, s47 offset:344
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:504
		scratch_load_dword v253, off, s47 offset:508
		scratch_load_dword v254, off, s47 offset:512
		scratch_load_dword v255, off, s47 offset:516
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[252:255], v[248:251], v[176:179], v2, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s43
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(36)
		scratch_load_dword v12, off, s47 offset:420
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v12, s[0:3], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:348
		scratch_load_dword v249, off, s47 offset:352
		scratch_load_dword v250, off, s47 offset:356
		scratch_load_dword v251, off, s47 offset:360
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:504
		scratch_load_dword v253, off, s47 offset:508
		scratch_load_dword v254, off, s47 offset:512
		scratch_load_dword v255, off, s47 offset:516
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[252:255], v[248:251], v[180:183], v2, v15 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s44
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(35)
		scratch_load_dword v12, off, s47 offset:424
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v12, s[0:3], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:364
		scratch_load_dword v249, off, s47 offset:368
		scratch_load_dword v250, off, s47 offset:372
		scratch_load_dword v251, off, s47 offset:376
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:504
		scratch_load_dword v253, off, s47 offset:508
		scratch_load_dword v254, off, s47 offset:512
		scratch_load_dword v255, off, s47 offset:516
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[252:255], v[248:251], v[184:187], v2, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s45, 0x20000
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(34)
		scratch_load_dword v12, off, s47 offset:428
		s_waitcnt vmcnt(0)
		buffer_load_dword v12, s[4:7], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:380
		scratch_load_dword v249, off, s47 offset:384
		scratch_load_dword v250, off, s47 offset:388
		scratch_load_dword v251, off, s47 offset:392
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:504
		scratch_load_dword v253, off, s47 offset:508
		scratch_load_dword v254, off, s47 offset:512
		scratch_load_dword v255, off, s47 offset:516
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[252:255], v[248:251], v[188:191], v2, v71 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s9, 0x20000
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(33)
		scratch_load_dword v12, off, s47 offset:432
		s_waitcnt vmcnt(0)
		buffer_load_dword v12, s[4:7], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:440
		scratch_load_dword v249, off, s47 offset:444
		scratch_load_dword v250, off, s47 offset:448
		scratch_load_dword v251, off, s47 offset:452
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:504
		scratch_load_dword v253, off, s47 offset:508
		scratch_load_dword v254, off, s47 offset:512
		scratch_load_dword v255, off, s47 offset:516
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[252:255], v[248:251], v[192:195], v2, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s35, 0x20000
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(32)
		scratch_load_dword v12, off, s47 offset:436
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:456
		scratch_load_dword v249, off, s47 offset:460
		scratch_load_dword v250, off, s47 offset:464
		scratch_load_dword v251, off, s47 offset:468
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:504
		scratch_load_dword v253, off, s47 offset:508
		scratch_load_dword v254, off, s47 offset:512
		scratch_load_dword v255, off, s47 offset:516
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[252:255], v[248:251], v[196:199], v2, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:300
		scratch_load_dword v249, off, s47 offset:304
		scratch_load_dword v250, off, s47 offset:308
		scratch_load_dword v251, off, s47 offset:312
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:520
		scratch_load_dword v253, off, s47 offset:524
		scratch_load_dword v254, off, s47 offset:528
		scratch_load_dword v255, off, s47 offset:532
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[252:255], v[248:251], v[200:203], v2, v9 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:316
		scratch_load_dword v249, off, s47 offset:320
		scratch_load_dword v250, off, s47 offset:324
		scratch_load_dword v251, off, s47 offset:328
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:520
		scratch_load_dword v253, off, s47 offset:524
		scratch_load_dword v254, off, s47 offset:528
		scratch_load_dword v255, off, s47 offset:532
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[252:255], v[248:251], v[204:207], v2, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:332
		scratch_load_dword v249, off, s47 offset:336
		scratch_load_dword v250, off, s47 offset:340
		scratch_load_dword v251, off, s47 offset:344
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:520
		scratch_load_dword v253, off, s47 offset:524
		scratch_load_dword v254, off, s47 offset:528
		scratch_load_dword v255, off, s47 offset:532
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[252:255], v[248:251], v[208:211], v2, v15 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:348
		scratch_load_dword v249, off, s47 offset:352
		scratch_load_dword v250, off, s47 offset:356
		scratch_load_dword v251, off, s47 offset:360
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:520
		scratch_load_dword v253, off, s47 offset:524
		scratch_load_dword v254, off, s47 offset:528
		scratch_load_dword v255, off, s47 offset:532
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[252:255], v[248:251], v[212:215], v2, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:364
		scratch_load_dword v249, off, s47 offset:368
		scratch_load_dword v250, off, s47 offset:372
		scratch_load_dword v251, off, s47 offset:376
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:520
		scratch_load_dword v253, off, s47 offset:524
		scratch_load_dword v254, off, s47 offset:528
		scratch_load_dword v255, off, s47 offset:532
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[252:255], v[248:251], v[216:219], v2, v71 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:380
		scratch_load_dword v249, off, s47 offset:384
		scratch_load_dword v250, off, s47 offset:388
		scratch_load_dword v251, off, s47 offset:392
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:520
		scratch_load_dword v253, off, s47 offset:524
		scratch_load_dword v254, off, s47 offset:528
		scratch_load_dword v255, off, s47 offset:532
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[252:255], v[248:251], v[220:223], v2, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:440
		scratch_load_dword v249, off, s47 offset:444
		scratch_load_dword v250, off, s47 offset:448
		scratch_load_dword v251, off, s47 offset:452
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:520
		scratch_load_dword v253, off, s47 offset:524
		scratch_load_dword v254, off, s47 offset:528
		scratch_load_dword v255, off, s47 offset:532
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[252:255], v[248:251], v[224:227], v2, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:456
		scratch_load_dword v249, off, s47 offset:460
		scratch_load_dword v250, off, s47 offset:464
		scratch_load_dword v251, off, s47 offset:468
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:520
		scratch_load_dword v253, off, s47 offset:524
		scratch_load_dword v254, off, s47 offset:528
		scratch_load_dword v255, off, s47 offset:532
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[252:255], v[248:251], v[228:231], v2, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(28)
		scratch_load_dword v248, off, s47 offset:536
		scratch_load_dword v249, off, s47 offset:540
		scratch_load_dword v250, off, s47 offset:544
		scratch_load_dword v251, off, s47 offset:548
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[236:239], v[248:251], v[4:7], v1, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v248, off, s47 offset:552
		scratch_load_dword v249, off, s47 offset:556
		scratch_load_dword v250, off, s47 offset:560
		scratch_load_dword v251, off, s47 offset:564
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[236:239], v[248:251], v[84:87], v1, v9 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(20)
		scratch_load_dword v248, off, s47 offset:568
		scratch_load_dword v249, off, s47 offset:572
		scratch_load_dword v250, off, s47 offset:576
		scratch_load_dword v251, off, s47 offset:580
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[236:239], v[248:251], v[88:91], v1, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v248, off, s47 offset:588
		scratch_load_dword v249, off, s47 offset:592
		scratch_load_dword v250, off, s47 offset:596
		scratch_load_dword v251, off, s47 offset:600
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[236:239], v[248:251], v[104:107], v1, v15 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(12)
		scratch_load_dword v248, off, s47 offset:604
		scratch_load_dword v249, off, s47 offset:608
		scratch_load_dword v250, off, s47 offset:612
		scratch_load_dword v251, off, s47 offset:616
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[236:239], v[248:251], v[116:119], v1, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v248, off, s47 offset:620
		scratch_load_dword v249, off, s47 offset:624
		scratch_load_dword v250, off, s47 offset:628
		scratch_load_dword v251, off, s47 offset:632
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[236:239], v[248:251], v[124:127], v1, v71 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v248, off, s47 offset:636
		scratch_load_dword v249, off, s47 offset:640
		scratch_load_dword v250, off, s47 offset:644
		scratch_load_dword v251, off, s47 offset:648
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[236:239], v[248:251], v[128:131], v1, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v248, off, s47 offset:652
		scratch_load_dword v249, off, s47 offset:656
		scratch_load_dword v250, off, s47 offset:660
		scratch_load_dword v251, off, s47 offset:664
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[236:239], v[248:251], v[132:135], v1, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v236, off, s47 offset:536
		scratch_load_dword v237, off, s47 offset:540
		scratch_load_dword v238, off, s47 offset:544
		scratch_load_dword v239, off, s47 offset:548
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[232:235], v[236:239], v[136:139], v1, v9 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v236, off, s47 offset:552
		scratch_load_dword v237, off, s47 offset:556
		scratch_load_dword v238, off, s47 offset:560
		scratch_load_dword v239, off, s47 offset:564
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[232:235], v[236:239], v[140:143], v1, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v236, off, s47 offset:568
		scratch_load_dword v237, off, s47 offset:572
		scratch_load_dword v238, off, s47 offset:576
		scratch_load_dword v239, off, s47 offset:580
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[232:235], v[236:239], v[144:147], v1, v15 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v236, off, s47 offset:588
		scratch_load_dword v237, off, s47 offset:592
		scratch_load_dword v238, off, s47 offset:596
		scratch_load_dword v239, off, s47 offset:600
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[232:235], v[236:239], v[148:151], v1, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v236, off, s47 offset:604
		scratch_load_dword v237, off, s47 offset:608
		scratch_load_dword v238, off, s47 offset:612
		scratch_load_dword v239, off, s47 offset:616
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[232:235], v[236:239], v[152:155], v1, v71 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v236, off, s47 offset:620
		scratch_load_dword v237, off, s47 offset:624
		scratch_load_dword v238, off, s47 offset:628
		scratch_load_dword v239, off, s47 offset:632
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[232:235], v[236:239], v[156:159], v1, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v236, off, s47 offset:636
		scratch_load_dword v237, off, s47 offset:640
		scratch_load_dword v238, off, s47 offset:644
		scratch_load_dword v239, off, s47 offset:648
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[232:235], v[236:239], v[160:163], v1, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v236, off, s47 offset:652
		scratch_load_dword v237, off, s47 offset:656
		scratch_load_dword v238, off, s47 offset:660
		scratch_load_dword v239, off, s47 offset:664
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[232:235], v[236:239], v[164:167], v1, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:536
		scratch_load_dword v233, off, s47 offset:540
		scratch_load_dword v234, off, s47 offset:544
		scratch_load_dword v235, off, s47 offset:548
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[240:243], v[232:235], v[168:171], v2, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:552
		scratch_load_dword v233, off, s47 offset:556
		scratch_load_dword v234, off, s47 offset:560
		scratch_load_dword v235, off, s47 offset:564
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[240:243], v[232:235], v[172:175], v2, v9 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:568
		scratch_load_dword v233, off, s47 offset:572
		scratch_load_dword v234, off, s47 offset:576
		scratch_load_dword v235, off, s47 offset:580
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[240:243], v[232:235], v[176:179], v2, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:588
		scratch_load_dword v233, off, s47 offset:592
		scratch_load_dword v234, off, s47 offset:596
		scratch_load_dword v235, off, s47 offset:600
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[240:243], v[232:235], v[180:183], v2, v15 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:604
		scratch_load_dword v233, off, s47 offset:608
		scratch_load_dword v234, off, s47 offset:612
		scratch_load_dword v235, off, s47 offset:616
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[240:243], v[232:235], v[184:187], v2, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:620
		scratch_load_dword v233, off, s47 offset:624
		scratch_load_dword v234, off, s47 offset:628
		scratch_load_dword v235, off, s47 offset:632
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[240:243], v[232:235], v[188:191], v2, v71 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:636
		scratch_load_dword v233, off, s47 offset:640
		scratch_load_dword v234, off, s47 offset:644
		scratch_load_dword v235, off, s47 offset:648
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[240:243], v[232:235], v[192:195], v2, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:652
		scratch_load_dword v233, off, s47 offset:656
		scratch_load_dword v234, off, s47 offset:660
		scratch_load_dword v235, off, s47 offset:664
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[240:243], v[232:235], v[196:199], v2, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:536
		scratch_load_dword v233, off, s47 offset:540
		scratch_load_dword v234, off, s47 offset:544
		scratch_load_dword v235, off, s47 offset:548
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[244:247], v[232:235], v[200:203], v2, v9 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:552
		scratch_load_dword v233, off, s47 offset:556
		scratch_load_dword v234, off, s47 offset:560
		scratch_load_dword v235, off, s47 offset:564
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[244:247], v[232:235], v[204:207], v2, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:568
		scratch_load_dword v233, off, s47 offset:572
		scratch_load_dword v234, off, s47 offset:576
		scratch_load_dword v235, off, s47 offset:580
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[244:247], v[232:235], v[208:211], v2, v15 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:588
		scratch_load_dword v233, off, s47 offset:592
		scratch_load_dword v234, off, s47 offset:596
		scratch_load_dword v235, off, s47 offset:600
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[244:247], v[232:235], v[212:215], v2, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:604
		scratch_load_dword v233, off, s47 offset:608
		scratch_load_dword v234, off, s47 offset:612
		scratch_load_dword v235, off, s47 offset:616
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[244:247], v[232:235], v[216:219], v2, v71 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:620
		scratch_load_dword v233, off, s47 offset:624
		scratch_load_dword v234, off, s47 offset:628
		scratch_load_dword v235, off, s47 offset:632
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[244:247], v[232:235], v[220:223], v2, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:636
		scratch_load_dword v233, off, s47 offset:640
		scratch_load_dword v234, off, s47 offset:644
		scratch_load_dword v235, off, s47 offset:648
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[244:247], v[232:235], v[224:227], v2, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:652
		scratch_load_dword v233, off, s47 offset:656
		scratch_load_dword v234, off, s47 offset:660
		scratch_load_dword v235, off, s47 offset:664
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[244:247], v[232:235], v[228:231], v2, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s46, s46, 2
		s_cmp_lt_i32 s46, s11
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:256
		scratch_load_dword v233, off, s47 offset:260
		scratch_load_dword v234, off, s47 offset:264
		scratch_load_dword v235, off, s47 offset:268
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v32, v232
		v_mov_b32_e32 v33, v233
		v_mov_b32_e32 v34, v234
		v_mov_b32_e32 v35, v235
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:272
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v16, v1
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:276
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v18, v1
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:280
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v17, v1
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:284
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v68, v1
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:288
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v69, v1
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:292
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v70, v1
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_add_i32 s0, s12, -1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[20:23], v[36:39], v[4:7], v16, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s1, s0, 1
		s_lshl_b32 s0, s1, 16
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x26800, v1
		ds_read_b32 v1, v2
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v2, s0, v1
		s_mov_b32 s1, 0
		scratch_load_dword v1, off, s1 offset:112
		s_mov_b32 s1, 0
		scratch_load_dword v3, off, s1 offset:116
		s_waitcnt vmcnt(0)
		v_add3_u32 v8, v2, v1, v3
		ds_read_b128 v[12:15], v8 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[20:23], v[40:43], v[84:87], v16, v17 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[72:75], v8 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[20:23], v[44:47], v[88:91], v16, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[76:79], v8 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[20:23], v[48:51], v[104:107], v16, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[80:83], v8 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[20:23], v[52:55], v[116:119], v16, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s1, 0
		scratch_load_dword v1, off, s1 offset:112
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v2, s0, v1
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:92
		s_mov_b32 s0, 0
		scratch_load_dword v3, off, s0 offset:116
		s_waitcnt vmcnt(0)
		v_add3_u32 v8, v2, v1, v3
		ds_read_b128 v[92:95], v8 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], v[56:59], v[124:127], v16, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v8 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[20:23], v[60:63], v[128:131], v16, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v8 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[20:23], v[64:67], v[132:135], v16, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v8 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[24:27], v[36:39], v[136:139], v16, v17 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[108:111], v8 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[24:27], v[40:43], v[140:143], v16, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[112:115], v8 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[44:47], v[144:147], v16, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[120:123], v8 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[48:51], v[148:151], v16, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[232:235], v8 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[52:55], v[152:155], v16, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[56:59], v[156:159], v16, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[24:27], v[60:63], v[160:163], v16, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[24:27], v[64:67], v[164:167], v16, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[28:31], v[36:39], v[168:171], v18, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[28:31], v[40:43], v[172:175], v18, v17 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[44:47], v[176:179], v18, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[48:51], v[180:183], v18, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[52:55], v[184:187], v18, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[56:59], v[188:191], v18, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[28:31], v[60:63], v[192:195], v18, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], v[64:67], v[196:199], v18, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[32:35], v[36:39], v[200:203], v18, v17 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[32:35], v[40:43], v[204:207], v18, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[44:47], v[208:211], v18, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[48:51], v[212:215], v18, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[52:55], v[216:219], v18, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], v[56:59], v[220:223], v18, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[32:35], v[60:63], v[224:227], v18, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], v[64:67], v[228:231], v18, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[12:15], v[92:95], v[4:7], v16, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[12:15], v[96:99], v[84:87], v16, v17 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[12:15], v[100:103], v[88:91], v16, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[12:15], v[20:23], v[104:107], v16, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[12:15], v[108:111], v[116:119], v16, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[12:15], v[112:115], v[124:127], v16, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[12:15], v[120:123], v[128:131], v16, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[12:15], v[232:235], v[132:135], v16, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[72:75], v[92:95], v[136:139], v16, v17 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[72:75], v[96:99], v[140:143], v16, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[72:75], v[100:103], v[144:147], v16, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[72:75], v[20:23], v[148:151], v16, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[72:75], v[108:111], v[152:155], v16, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[72:75], v[112:115], v[156:159], v16, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[72:75], v[120:123], v[160:163], v16, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[72:75], v[232:235], v[164:167], v16, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[76:79], v[92:95], v[168:171], v18, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[76:79], v[96:99], v[172:175], v18, v17 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[76:79], v[100:103], v[176:179], v18, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[76:79], v[20:23], v[180:183], v18, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[76:79], v[108:111], v[184:187], v18, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[76:79], v[112:115], v[188:191], v18, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[76:79], v[120:123], v[192:195], v18, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[76:79], v[232:235], v[196:199], v18, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[80:83], v[92:95], v[200:203], v18, v17 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[80:83], v[96:99], v[204:207], v18, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[80:83], v[100:103], v[208:211], v18, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[80:83], v[20:23], v[212:215], v18, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[80:83], v[108:111], v[216:219], v18, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[80:83], v[112:115], v[220:223], v18, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[80:83], v[120:123], v[224:227], v18, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[80:83], v[232:235], v[228:231], v18, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s0, s12, 1
		s_lshl_b32 s1, s0, 16
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x26800, v1
		ds_read_b32 v1, v2
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v2, s1, v1
		s_mov_b32 s2, 0
		scratch_load_dword v1, off, s2 offset:112
		s_mov_b32 s2, 0
		scratch_load_dword v3, off, s2 offset:116
		s_waitcnt vmcnt(0)
		v_add3_u32 v8, v2, v1, v3
		ds_read_b128 v[12:15], v8
		ds_read_b128 v[16:19], v8 offset:1024
		ds_read_b128 v[20:23], v8 offset:2048
		ds_read_b128 v[24:27], v8 offset:3072
		s_mov_b32 s2, 0
		scratch_load_dword v1, off, s2 offset:112
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v2, s1, v1
		s_mov_b32 s1, 0
		scratch_load_dword v1, off, s1 offset:92
		s_mov_b32 s1, 0
		scratch_load_dword v3, off, s1 offset:116
		s_waitcnt vmcnt(0)
		v_add3_u32 v9, v2, v1, v3
		ds_read_b128 v[28:31], v9 offset:32768
		ds_read_b128 v[32:35], v9 offset:33792
		ds_read_b128 v[36:39], v9 offset:34816
		ds_read_b128 v[40:43], v9 offset:35840
		ds_read_b128 v[44:47], v9 offset:36864
		ds_read_b128 v[48:51], v9 offset:37888
		ds_read_b128 v[52:55], v9 offset:38912
		ds_read_b128 v[56:59], v9 offset:39936
		s_lshl_b32 s1, s0, 12
		s_add_i32 s0, s1, 0x20000
		s_mov_b32 s1, 0
		scratch_load_dword v1, off, s1 offset:104
		s_mov_b32 s1, 0
		scratch_load_dword v2, off, s1 offset:128
		s_waitcnt vmcnt(0)
		v_add3_u32 v3, s0, v1, v2
		ds_read_b32 v1, v3
		ds_read_b32 v2, v3 offset:256
		s_mov_b32 s1, 0
		scratch_load_dword v3, off, s1 offset:108
		s_mov_b32 s1, 0
		scratch_load_dword v10, off, s1 offset:128
		s_waitcnt vmcnt(0)
		v_add3_u32 v11, s0, v10, v3
		ds_read_b32 v3, v11 offset:2048
		ds_read_b32 v10, v11 offset:2304
		ds_read_b32 v60, v11 offset:2560
		ds_read_b32 v61, v11 offset:2816
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[12:15], v[28:31], v[4:7], v1, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[64:67], v8 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[12:15], v[32:35], v[84:87], v1, v3 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[68:71], v8 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[12:15], v[36:39], v[88:91], v1, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[72:75], v8 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[12:15], v[40:43], v[104:107], v1, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[76:79], v8 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[12:15], v[44:47], v[116:119], v1, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[80:83], v9 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[12:15], v[48:51], v[124:127], v1, v60 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v9 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[12:15], v[52:55], v[128:131], v1, v61 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v9 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[12:15], v[56:59], v[132:135], v1, v61 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[12:15], v9 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[28:31], v[136:139], v1, v3 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v9 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[16:19], v[32:35], v[140:143], v1, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[108:111], v9 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[16:19], v[36:39], v[144:147], v1, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[112:115], v9 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[16:19], v[40:43], v[148:151], v1, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[120:123], v9 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[16:19], v[44:47], v[152:155], v1, v60 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[16:19], v[48:51], v[156:159], v1, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[16:19], v[52:55], v[160:163], v1, v61 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[16:19], v[56:59], v[164:167], v1, v61 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[28:31], v[168:171], v2, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[32:35], v[172:175], v2, v3 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[20:23], v[36:39], v[176:179], v2, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[20:23], v[40:43], v[180:183], v2, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[20:23], v[44:47], v[184:187], v2, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[20:23], v[48:51], v[188:191], v2, v60 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[20:23], v[52:55], v[192:195], v2, v61 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[20:23], v[56:59], v[196:199], v2, v61 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[28:31], v[200:203], v2, v3 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[32:35], v[204:207], v2, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], v[36:39], v[208:211], v2, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[24:27], v[40:43], v[212:215], v2, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[24:27], v[44:47], v[216:219], v2, v60 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[24:27], v[48:51], v[220:223], v2, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[24:27], v[52:55], v[224:227], v2, v61 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[24:27], v[56:59], v[228:231], v2, v61 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[64:67], v[80:83], v[4:7], v1, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[64:67], v[92:95], v[84:87], v1, v3 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[64:67], v[96:99], v[88:91], v1, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[64:67], v[12:15], v[104:107], v1, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[64:67], v[100:103], v[116:119], v1, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[64:67], v[108:111], v[124:127], v1, v60 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[64:67], v[112:115], v[128:131], v1, v61 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[64:67], v[120:123], v[132:135], v1, v61 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[68:71], v[80:83], v[136:139], v1, v3 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[68:71], v[92:95], v[140:143], v1, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[68:71], v[96:99], v[144:147], v1, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[68:71], v[12:15], v[148:151], v1, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[68:71], v[100:103], v[152:155], v1, v60 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[68:71], v[108:111], v[156:159], v1, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[68:71], v[112:115], v[160:163], v1, v61 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[68:71], v[120:123], v[164:167], v1, v61 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[72:75], v[80:83], v[168:171], v2, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[72:75], v[92:95], v[172:175], v2, v3 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[72:75], v[96:99], v[176:179], v2, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[72:75], v[12:15], v[180:183], v2, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[72:75], v[100:103], v[184:187], v2, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[72:75], v[108:111], v[188:191], v2, v60 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[72:75], v[112:115], v[192:195], v2, v61 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[72:75], v[120:123], v[196:199], v2, v61 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[76:79], v[80:83], v[200:203], v2, v3 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[76:79], v[92:95], v[204:207], v2, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[76:79], v[96:99], v[208:211], v2, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[76:79], v[12:15], v[212:215], v2, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[76:79], v[100:103], v[216:219], v2, v60 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[76:79], v[108:111], v[220:223], v2, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[76:79], v[112:115], v[224:227], v2, v61 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[76:79], v[120:123], v[228:231], v2, v61 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v4, v5
		v_cvt_pk_f16_f32 v3, v6, v7
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v4, 0x22800, v1
		ds_read_b32 v1, v4
		s_waitcnt lgkmcnt(0)
		v_lshlrev_b32_e32 v4, 3, v1
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v0, 0x22000, v1
		ds_read_b32 v1, v0
		s_waitcnt lgkmcnt(0)
		v_lshl_add_u32 v0, v1, 14, v4
		s_lshl_b32 s0, s13, 21
		s_lshl_b32 s1, s14, 17
		s_add_i32 s2, s0, s1
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen
		v_cvt_pk_f16_f32 v2, v84, v85
		v_cvt_pk_f16_f32 v3, v86, v87
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:512
		v_cvt_pk_f16_f32 v2, v88, v89
		v_cvt_pk_f16_f32 v3, v90, v91
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:1024
		v_cvt_pk_f16_f32 v2, v104, v105
		v_cvt_pk_f16_f32 v3, v106, v107
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:1536
		v_cvt_pk_f16_f32 v2, v116, v117
		v_cvt_pk_f16_f32 v3, v118, v119
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:2048
		v_cvt_pk_f16_f32 v2, v124, v125
		v_cvt_pk_f16_f32 v3, v126, v127
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:2560
		v_cvt_pk_f16_f32 v2, v128, v129
		v_cvt_pk_f16_f32 v3, v130, v131
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:3072
		v_cvt_pk_f16_f32 v2, v132, v133
		v_cvt_pk_f16_f32 v3, v134, v135
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:3584
		v_cvt_pk_f16_f32 v2, v136, v137
		v_cvt_pk_f16_f32 v3, v138, v139
		s_add_i32 s2, s0, 0x1000
		s_add_i32 s3, s2, s1
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen
		v_cvt_pk_f16_f32 v2, v140, v141
		v_cvt_pk_f16_f32 v3, v142, v143
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen offset:512
		v_cvt_pk_f16_f32 v2, v144, v145
		v_cvt_pk_f16_f32 v3, v146, v147
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen offset:1024
		v_cvt_pk_f16_f32 v2, v148, v149
		v_cvt_pk_f16_f32 v3, v150, v151
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen offset:1536
		v_cvt_pk_f16_f32 v2, v152, v153
		v_cvt_pk_f16_f32 v3, v154, v155
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen offset:2048
		v_cvt_pk_f16_f32 v2, v156, v157
		v_cvt_pk_f16_f32 v3, v158, v159
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen offset:2560
		v_cvt_pk_f16_f32 v2, v160, v161
		v_cvt_pk_f16_f32 v3, v162, v163
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen offset:3072
		v_cvt_pk_f16_f32 v2, v164, v165
		v_cvt_pk_f16_f32 v3, v166, v167
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen offset:3584
		v_cvt_pk_f16_f32 v2, v168, v169
		v_cvt_pk_f16_f32 v3, v170, v171
		s_add_i32 s2, s0, 0x2000
		s_add_i32 s3, s2, s1
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen
		v_cvt_pk_f16_f32 v2, v172, v173
		v_cvt_pk_f16_f32 v3, v174, v175
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen offset:512
		v_cvt_pk_f16_f32 v2, v176, v177
		v_cvt_pk_f16_f32 v3, v178, v179
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen offset:1024
		v_cvt_pk_f16_f32 v2, v180, v181
		v_cvt_pk_f16_f32 v3, v182, v183
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen offset:1536
		v_cvt_pk_f16_f32 v2, v184, v185
		v_cvt_pk_f16_f32 v3, v186, v187
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen offset:2048
		v_cvt_pk_f16_f32 v2, v188, v189
		v_cvt_pk_f16_f32 v3, v190, v191
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen offset:2560
		v_cvt_pk_f16_f32 v2, v192, v193
		v_cvt_pk_f16_f32 v3, v194, v195
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen offset:3072
		v_cvt_pk_f16_f32 v2, v196, v197
		v_cvt_pk_f16_f32 v3, v198, v199
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen offset:3584
		v_cvt_pk_f16_f32 v2, v200, v201
		v_cvt_pk_f16_f32 v3, v202, v203
		s_add_i32 s2, s0, 0x3000
		s_add_i32 s0, s2, s1
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen
		v_cvt_pk_f16_f32 v2, v204, v205
		v_cvt_pk_f16_f32 v3, v206, v207
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:512
		v_cvt_pk_f16_f32 v2, v208, v209
		v_cvt_pk_f16_f32 v3, v210, v211
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v212, v213
		v_cvt_pk_f16_f32 v3, v214, v215
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:1536
		v_cvt_pk_f16_f32 v2, v216, v217
		v_cvt_pk_f16_f32 v3, v218, v219
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v220, v221
		v_cvt_pk_f16_f32 v3, v222, v223
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v224, v225
		v_cvt_pk_f16_f32 v3, v226, v227
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v228, v229
		v_cvt_pk_f16_f32 v3, v230, v231
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:3584
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 24576
		.amdhsa_private_segment_fixed_size 668
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
		.amdhsa_next_free_sgpr 50
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
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 50
	.set .Lwmma_f16_matmul_tiled.num_named_barrier, 0
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 668
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
    .private_segment_fixed_size: 668
    .sgpr_count:     50
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     256
    .agpr_count:     0
    .vgpr_spill_count: 167
    .wavefront_size: 64
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
