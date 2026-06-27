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
		scratch_store_dword off, v12, s37 offset:1184
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
		scratch_store_dword off, v14, s38 offset:1204
		s_mov_b32 s38, 0
		scratch_store_dword off, v14, s38 offset:1136
		v_lshrrev_b32_e32 v17, 4, v8
		v_lshrrev_b32_e32 v8, 1, v3
		v_and_b32_e32 v3, 3, v8
		v_xor_b32_e32 v8, v17, v3
		v_lshlrev_b32_e32 v3, 4, v8
		s_mov_b32 s38, 0
		scratch_store_dword off, v3, s38 offset:1208
		s_mov_b32 s38, 0
		scratch_store_dword off, v3, s38 offset:1140
		v_add3_u32 v8, v13, v14, v3
		ds_read_b128 v[20:23], v8
		ds_read_b128 v[24:27], v8 offset:1024
		ds_read_b128 v[28:31], v8 offset:2048
		ds_read_b128 v[32:35], v8 offset:3072
		v_lshlrev_b32_e32 v8, 13, v16
		s_mov_b32 s38, 0
		scratch_store_dword off, v8, s38 offset:1212
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
		s_mov_b32 s47, 0
		scratch_store_dword off, v64, s47 offset:1536
		scratch_store_dword off, v65, s47 offset:1540
		scratch_store_dword off, v66, s47 offset:1544
		scratch_store_dword off, v67, s47 offset:1548
		s_mov_b32 s47, 0
		scratch_store_dword off, v60, s47 offset:1504
		scratch_store_dword off, v61, s47 offset:1508
		scratch_store_dword off, v62, s47 offset:1512
		scratch_store_dword off, v63, s47 offset:1516
		s_mov_b32 s47, 0
		scratch_store_dword off, v56, s47 offset:1472
		scratch_store_dword off, v57, s47 offset:1476
		scratch_store_dword off, v58, s47 offset:1480
		scratch_store_dword off, v59, s47 offset:1484
		s_mov_b32 s47, 0
		scratch_store_dword off, v52, s47 offset:1440
		scratch_store_dword off, v53, s47 offset:1444
		scratch_store_dword off, v54, s47 offset:1448
		scratch_store_dword off, v55, s47 offset:1452
		s_mov_b32 s47, 0
		scratch_store_dword off, v48, s47 offset:1376
		scratch_store_dword off, v49, s47 offset:1380
		scratch_store_dword off, v50, s47 offset:1384
		scratch_store_dword off, v51, s47 offset:1388
		s_mov_b32 s47, 0
		scratch_store_dword off, v44, s47 offset:1328
		scratch_store_dword off, v45, s47 offset:1332
		scratch_store_dword off, v46, s47 offset:1336
		scratch_store_dword off, v47, s47 offset:1340
		s_mov_b32 s47, 0
		scratch_store_dword off, v40, s47 offset:1280
		scratch_store_dword off, v41, s47 offset:1284
		scratch_store_dword off, v42, s47 offset:1288
		scratch_store_dword off, v43, s47 offset:1292
		s_mov_b32 s47, 0
		scratch_store_dword off, v36, s47 offset:1232
		scratch_store_dword off, v37, s47 offset:1236
		scratch_store_dword off, v38, s47 offset:1240
		scratch_store_dword off, v39, s47 offset:1244
		s_mov_b32 s47, 0
		scratch_store_dword off, v20, s47 offset:1144
		scratch_store_dword off, v21, s47 offset:1148
		scratch_store_dword off, v22, s47 offset:1152
		scratch_store_dword off, v23, s47 offset:1156
		s_mov_b32 s47, 0
		scratch_store_dword off, v228, s47 offset:1104
		scratch_store_dword off, v229, s47 offset:1108
		scratch_store_dword off, v230, s47 offset:1112
		scratch_store_dword off, v231, s47 offset:1116
		s_mov_b32 s47, 0
		scratch_store_dword off, v224, s47 offset:1072
		scratch_store_dword off, v225, s47 offset:1076
		scratch_store_dword off, v226, s47 offset:1080
		scratch_store_dword off, v227, s47 offset:1084
		s_mov_b32 s47, 0
		scratch_store_dword off, v220, s47 offset:1040
		scratch_store_dword off, v221, s47 offset:1044
		scratch_store_dword off, v222, s47 offset:1048
		scratch_store_dword off, v223, s47 offset:1052
		s_mov_b32 s47, 0
		scratch_store_dword off, v216, s47 offset:1008
		scratch_store_dword off, v217, s47 offset:1012
		scratch_store_dword off, v218, s47 offset:1016
		scratch_store_dword off, v219, s47 offset:1020
		s_mov_b32 s47, 0
		scratch_store_dword off, v212, s47 offset:976
		scratch_store_dword off, v213, s47 offset:980
		scratch_store_dword off, v214, s47 offset:984
		scratch_store_dword off, v215, s47 offset:988
		s_mov_b32 s47, 0
		scratch_store_dword off, v208, s47 offset:944
		scratch_store_dword off, v209, s47 offset:948
		scratch_store_dword off, v210, s47 offset:952
		scratch_store_dword off, v211, s47 offset:956
		s_mov_b32 s47, 0
		scratch_store_dword off, v204, s47 offset:912
		scratch_store_dword off, v205, s47 offset:916
		scratch_store_dword off, v206, s47 offset:920
		scratch_store_dword off, v207, s47 offset:924
		s_mov_b32 s47, 0
		scratch_store_dword off, v200, s47 offset:880
		scratch_store_dword off, v201, s47 offset:884
		scratch_store_dword off, v202, s47 offset:888
		scratch_store_dword off, v203, s47 offset:892
		s_mov_b32 s47, 0
		scratch_store_dword off, v196, s47 offset:848
		scratch_store_dword off, v197, s47 offset:852
		scratch_store_dword off, v198, s47 offset:856
		scratch_store_dword off, v199, s47 offset:860
		s_mov_b32 s47, 0
		scratch_store_dword off, v192, s47 offset:816
		scratch_store_dword off, v193, s47 offset:820
		scratch_store_dword off, v194, s47 offset:824
		scratch_store_dword off, v195, s47 offset:828
		s_mov_b32 s47, 0
		scratch_store_dword off, v188, s47 offset:784
		scratch_store_dword off, v189, s47 offset:788
		scratch_store_dword off, v190, s47 offset:792
		scratch_store_dword off, v191, s47 offset:796
		s_mov_b32 s47, 0
		scratch_store_dword off, v184, s47 offset:752
		scratch_store_dword off, v185, s47 offset:756
		scratch_store_dword off, v186, s47 offset:760
		scratch_store_dword off, v187, s47 offset:764
		s_mov_b32 s47, 0
		scratch_store_dword off, v180, s47 offset:720
		scratch_store_dword off, v181, s47 offset:724
		scratch_store_dword off, v182, s47 offset:728
		scratch_store_dword off, v183, s47 offset:732
		s_mov_b32 s47, 0
		scratch_store_dword off, v176, s47 offset:688
		scratch_store_dword off, v177, s47 offset:692
		scratch_store_dword off, v178, s47 offset:696
		scratch_store_dword off, v179, s47 offset:700
		s_mov_b32 s47, 0
		scratch_store_dword off, v172, s47 offset:656
		scratch_store_dword off, v173, s47 offset:660
		scratch_store_dword off, v174, s47 offset:664
		scratch_store_dword off, v175, s47 offset:668
		s_mov_b32 s47, 0
		scratch_store_dword off, v168, s47 offset:624
		scratch_store_dword off, v169, s47 offset:628
		scratch_store_dword off, v170, s47 offset:632
		scratch_store_dword off, v171, s47 offset:636
		s_mov_b32 s47, 0
		scratch_store_dword off, v164, s47 offset:592
		scratch_store_dword off, v165, s47 offset:596
		scratch_store_dword off, v166, s47 offset:600
		scratch_store_dword off, v167, s47 offset:604
		s_mov_b32 s47, 0
		scratch_store_dword off, v160, s47 offset:560
		scratch_store_dword off, v161, s47 offset:564
		scratch_store_dword off, v162, s47 offset:568
		scratch_store_dword off, v163, s47 offset:572
		s_mov_b32 s47, 0
		scratch_store_dword off, v156, s47 offset:528
		scratch_store_dword off, v157, s47 offset:532
		scratch_store_dword off, v158, s47 offset:536
		scratch_store_dword off, v159, s47 offset:540
		s_mov_b32 s47, 0
		scratch_store_dword off, v152, s47 offset:496
		scratch_store_dword off, v153, s47 offset:500
		scratch_store_dword off, v154, s47 offset:504
		scratch_store_dword off, v155, s47 offset:508
		s_mov_b32 s47, 0
		scratch_store_dword off, v148, s47 offset:464
		scratch_store_dword off, v149, s47 offset:468
		scratch_store_dword off, v150, s47 offset:472
		scratch_store_dword off, v151, s47 offset:476
		s_mov_b32 s47, 0
		scratch_store_dword off, v144, s47 offset:432
		scratch_store_dword off, v145, s47 offset:436
		scratch_store_dword off, v146, s47 offset:440
		scratch_store_dword off, v147, s47 offset:444
		s_mov_b32 s47, 0
		scratch_store_dword off, v140, s47 offset:400
		scratch_store_dword off, v141, s47 offset:404
		scratch_store_dword off, v142, s47 offset:408
		scratch_store_dword off, v143, s47 offset:412
		s_mov_b32 s47, 0
		scratch_store_dword off, v136, s47 offset:368
		scratch_store_dword off, v137, s47 offset:372
		scratch_store_dword off, v138, s47 offset:376
		scratch_store_dword off, v139, s47 offset:380
		s_mov_b32 s47, 0
		scratch_store_dword off, v132, s47 offset:336
		scratch_store_dword off, v133, s47 offset:340
		scratch_store_dword off, v134, s47 offset:344
		scratch_store_dword off, v135, s47 offset:348
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
		scratch_store_dword off, v82, s47 offset:1176
		scratch_store_dword off, v83, s47 offset:1180
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
		s_mov_b32 s47, 0
		s_nop 6
		scratch_store_dword off, v4, s47 offset:128
		scratch_store_dword off, v5, s47 offset:132
		scratch_store_dword off, v6, s47 offset:136
		scratch_store_dword off, v7, s47 offset:140
		s_and_b32 s47, s46, 1
		s_lshl_b32 s48, s47, 16
		v_add_u32_e32 v1, s48, v13
		v_add3_u32 v2, v1, v14, v3
		ds_read_b128 v[232:235], v2 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[20:23], v[40:43], v[84:87], v16, v17 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		s_nop 6
		scratch_store_dword off, v84, s49 offset:160
		scratch_store_dword off, v85, s49 offset:164
		scratch_store_dword off, v86, s49 offset:168
		scratch_store_dword off, v87, s49 offset:172
		ds_read_b128 v[236:239], v2 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[20:23], v[44:47], v[88:91], v16, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		s_nop 6
		scratch_store_dword off, v88, s49 offset:192
		scratch_store_dword off, v89, s49 offset:196
		scratch_store_dword off, v90, s49 offset:200
		scratch_store_dword off, v91, s49 offset:204
		ds_read_b128 v[240:243], v2 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[20:23], v[48:51], v[104:107], v16, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		s_nop 6
		scratch_store_dword off, v104, s49 offset:224
		scratch_store_dword off, v105, s49 offset:228
		scratch_store_dword off, v106, s49 offset:232
		scratch_store_dword off, v107, s49 offset:236
		ds_read_b128 v[244:247], v2 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[20:23], v[52:55], v[116:119], v16, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		s_nop 6
		scratch_store_dword off, v116, s49 offset:256
		scratch_store_dword off, v117, s49 offset:260
		scratch_store_dword off, v118, s49 offset:264
		scratch_store_dword off, v119, s49 offset:268
		v_add_u32_e32 v1, s48, v14
		v_add3_u32 v2, v1, v8, v3
		ds_read_b128 v[248:251], v2 offset:49152
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s48 offset:1188
		scratch_store_dword off, v249, s48 offset:1192
		scratch_store_dword off, v250, s48 offset:1196
		scratch_store_dword off, v251, s48 offset:1200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], v[56:59], v[124:127], v16, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		s_nop 6
		scratch_store_dword off, v124, s48 offset:288
		scratch_store_dword off, v125, s48 offset:292
		scratch_store_dword off, v126, s48 offset:296
		scratch_store_dword off, v127, s48 offset:300
		ds_read_b128 v[248:251], v2 offset:50176
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s48 offset:1216
		scratch_store_dword off, v249, s48 offset:1220
		scratch_store_dword off, v250, s48 offset:1224
		scratch_store_dword off, v251, s48 offset:1228
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[20:23], v[60:63], v[128:131], v16, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s48, 0
		s_nop 6
		scratch_store_dword off, v128, s48 offset:320
		scratch_store_dword off, v129, s48 offset:324
		scratch_store_dword off, v130, s48 offset:328
		scratch_store_dword off, v131, s48 offset:332
		ds_read_b128 v[248:251], v2 offset:51200
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s48 offset:1264
		scratch_store_dword off, v249, s48 offset:1268
		scratch_store_dword off, v250, s48 offset:1272
		scratch_store_dword off, v251, s48 offset:1276
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(44)
		scratch_load_dword v132, off, s48 offset:336
		scratch_load_dword v133, off, s48 offset:340
		scratch_load_dword v134, off, s48 offset:344
		scratch_load_dword v135, off, s48 offset:348
		s_mov_b32 s48, 0
		scratch_load_dword v248, off, s48 offset:1144
		scratch_load_dword v249, off, s48 offset:1148
		scratch_load_dword v250, off, s48 offset:1152
		scratch_load_dword v251, off, s48 offset:1156
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[248:251], v[64:67], v[132:135], v16, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshl_b32 s48, s47, 16
		s_mov_b32 s49, 0
		scratch_load_dword v1, off, s49 offset:1204
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v2, s48, v1
		s_mov_b32 s48, 0
		scratch_load_dword v1, off, s48 offset:1208
		s_mov_b32 s48, 0
		scratch_load_dword v9, off, s48 offset:1212
		s_waitcnt vmcnt(0)
		v_add3_u32 v12, v2, v9, v1
		ds_read_b128 v[248:251], v12 offset:52224
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s48 offset:1312
		scratch_store_dword off, v249, s48 offset:1316
		scratch_store_dword off, v250, s48 offset:1320
		scratch_store_dword off, v251, s48 offset:1324
		s_mov_b32 s48, 0
		scratch_load_dword v136, off, s48 offset:368
		scratch_load_dword v137, off, s48 offset:372
		scratch_load_dword v138, off, s48 offset:376
		scratch_load_dword v139, off, s48 offset:380
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[24:27], v[36:39], v[136:139], v16, v17 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v12 offset:53248
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s48 offset:1360
		scratch_store_dword off, v249, s48 offset:1364
		scratch_store_dword off, v250, s48 offset:1368
		scratch_store_dword off, v251, s48 offset:1372
		s_mov_b32 s48, 0
		scratch_load_dword v140, off, s48 offset:400
		scratch_load_dword v141, off, s48 offset:404
		scratch_load_dword v142, off, s48 offset:408
		scratch_load_dword v143, off, s48 offset:412
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[24:27], v[40:43], v[140:143], v16, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v12 offset:54272
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s48 offset:1408
		scratch_store_dword off, v249, s48 offset:1412
		scratch_store_dword off, v250, s48 offset:1416
		scratch_store_dword off, v251, s48 offset:1420
		s_mov_b32 s48, 0
		scratch_load_dword v144, off, s48 offset:432
		scratch_load_dword v145, off, s48 offset:436
		scratch_load_dword v146, off, s48 offset:440
		scratch_load_dword v147, off, s48 offset:444
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[44:47], v[144:147], v16, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v12 offset:55296
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s48 offset:1568
		scratch_store_dword off, v249, s48 offset:1572
		scratch_store_dword off, v250, s48 offset:1576
		scratch_store_dword off, v251, s48 offset:1580
		s_mov_b32 s48, 0
		scratch_load_dword v148, off, s48 offset:464
		scratch_load_dword v149, off, s48 offset:468
		scratch_load_dword v150, off, s48 offset:472
		scratch_load_dword v151, off, s48 offset:476
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[48:51], v[148:151], v16, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v12 offset:56320
		s_mov_b32 s48, 0
		scratch_load_dword v152, off, s48 offset:496
		scratch_load_dword v153, off, s48 offset:500
		scratch_load_dword v154, off, s48 offset:504
		scratch_load_dword v155, off, s48 offset:508
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[52:55], v[152:155], v16, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x23000, v1
		ds_read_b32 v1, v2
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v156, off, s48 offset:528
		scratch_load_dword v157, off, s48 offset:532
		scratch_load_dword v158, off, s48 offset:536
		scratch_load_dword v159, off, s48 offset:540
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[56:59], v[156:159], v16, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s28
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x23800, v1
		ds_read_b32 v1, v2
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v160, off, s48 offset:560
		scratch_load_dword v161, off, s48 offset:564
		scratch_load_dword v162, off, s48 offset:568
		scratch_load_dword v163, off, s48 offset:572
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[24:27], v[60:63], v[160:163], v16, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s29
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x24000, v1
		ds_read_b32 v1, v2
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v164, off, s48 offset:592
		scratch_load_dword v165, off, s48 offset:596
		scratch_load_dword v166, off, s48 offset:600
		scratch_load_dword v167, off, s48 offset:604
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[24:27], v[64:67], v[164:167], v16, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s30
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x24800, v1
		ds_read_b32 v1, v2
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v168, off, s48 offset:624
		scratch_load_dword v169, off, s48 offset:628
		scratch_load_dword v170, off, s48 offset:632
		scratch_load_dword v171, off, s48 offset:636
		s_mov_b32 s48, 0
		scratch_load_dword v252, off, s48 offset:1232
		scratch_load_dword v253, off, s48 offset:1236
		scratch_load_dword v254, off, s48 offset:1240
		scratch_load_dword v255, off, s48 offset:1244
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[28:31], v[252:255], v[168:171], v18, v17 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s31
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x25000, v1
		ds_read_b32 v1, v2
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v1, s[0:3], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v172, off, s48 offset:656
		scratch_load_dword v173, off, s48 offset:660
		scratch_load_dword v174, off, s48 offset:664
		scratch_load_dword v175, off, s48 offset:668
		s_mov_b32 s48, 0
		scratch_load_dword v252, off, s48 offset:1280
		scratch_load_dword v253, off, s48 offset:1284
		scratch_load_dword v254, off, s48 offset:1288
		scratch_load_dword v255, off, s48 offset:1292
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[28:31], v[252:255], v[172:175], v18, v17 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s32
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x25800, v1
		ds_read_b32 v1, v2
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v1, s[0:3], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v176, off, s48 offset:688
		scratch_load_dword v177, off, s48 offset:692
		scratch_load_dword v178, off, s48 offset:696
		scratch_load_dword v179, off, s48 offset:700
		s_mov_b32 s48, 0
		scratch_load_dword v252, off, s48 offset:1328
		scratch_load_dword v253, off, s48 offset:1332
		scratch_load_dword v254, off, s48 offset:1336
		scratch_load_dword v255, off, s48 offset:1340
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[252:255], v[176:179], v18, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s33
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x26000, v1
		ds_read_b32 v1, v2
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v1, s[0:3], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v180, off, s48 offset:720
		scratch_load_dword v181, off, s48 offset:724
		scratch_load_dword v182, off, s48 offset:728
		scratch_load_dword v183, off, s48 offset:732
		s_mov_b32 s48, 0
		scratch_load_dword v252, off, s48 offset:1376
		scratch_load_dword v253, off, s48 offset:1380
		scratch_load_dword v254, off, s48 offset:1384
		scratch_load_dword v255, off, s48 offset:1388
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[252:255], v[180:183], v18, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s34
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x27000, v1
		ds_read_b32 v1, v2
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v1, s[0:3], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v184, off, s48 offset:752
		scratch_load_dword v185, off, s48 offset:756
		scratch_load_dword v186, off, s48 offset:760
		scratch_load_dword v187, off, s48 offset:764
		s_mov_b32 s48, 0
		scratch_load_dword v252, off, s48 offset:1440
		scratch_load_dword v253, off, s48 offset:1444
		scratch_load_dword v254, off, s48 offset:1448
		scratch_load_dword v255, off, s48 offset:1452
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[252:255], v[184:187], v18, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s8, 0x20000
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x27800, v1
		ds_read_b32 v1, v2
		s_waitcnt lgkmcnt(0)
		buffer_load_dword v1, s[4:7], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v188, off, s48 offset:784
		scratch_load_dword v189, off, s48 offset:788
		scratch_load_dword v190, off, s48 offset:792
		scratch_load_dword v191, off, s48 offset:796
		s_mov_b32 s48, 0
		scratch_load_dword v252, off, s48 offset:1472
		scratch_load_dword v253, off, s48 offset:1476
		scratch_load_dword v254, off, s48 offset:1480
		scratch_load_dword v255, off, s48 offset:1484
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[252:255], v[188:191], v18, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s37, 0x20000
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(57)
		scratch_load_dword v1, off, s48 offset:96
		s_waitcnt vmcnt(0)
		buffer_load_dword v1, s[4:7], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v192, off, s48 offset:816
		scratch_load_dword v193, off, s48 offset:820
		scratch_load_dword v194, off, s48 offset:824
		scratch_load_dword v195, off, s48 offset:828
		s_mov_b32 s48, 0
		scratch_load_dword v252, off, s48 offset:1504
		scratch_load_dword v253, off, s48 offset:1508
		scratch_load_dword v254, off, s48 offset:1512
		scratch_load_dword v255, off, s48 offset:1516
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[28:31], v[252:255], v[192:195], v18, v70 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s36, 0x20000
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(56)
		scratch_load_dword v1, off, s48 offset:100
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		s_mov_b32 s48, 0
		scratch_load_dword v196, off, s48 offset:848
		scratch_load_dword v197, off, s48 offset:852
		scratch_load_dword v198, off, s48 offset:856
		scratch_load_dword v199, off, s48 offset:860
		s_mov_b32 s48, 0
		scratch_load_dword v252, off, s48 offset:1536
		scratch_load_dword v253, off, s48 offset:1540
		scratch_load_dword v254, off, s48 offset:1544
		scratch_load_dword v255, off, s48 offset:1548
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[28:31], v[252:255], v[196:199], v18, v70 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_lshl_b32 s48, s47, 16
		s_mov_b32 s49, 0
		scratch_load_dword v1, off, s49 offset:72
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v2, s48, v1
		s_mov_b32 s48, 0
		scratch_load_dword v1, off, s48 offset:1136
		s_mov_b32 s48, 0
		scratch_load_dword v9, off, s48 offset:1140
		s_waitcnt vmcnt(0)
		v_add3_u32 v15, v2, v1, v9
		ds_read_b128 v[20:23], v15
		s_mov_b32 s48, 0
		scratch_load_dword v200, off, s48 offset:880
		scratch_load_dword v201, off, s48 offset:884
		scratch_load_dword v202, off, s48 offset:888
		scratch_load_dword v203, off, s48 offset:892
		s_mov_b32 s48, 0
		scratch_load_dword v252, off, s48 offset:1232
		scratch_load_dword v253, off, s48 offset:1236
		scratch_load_dword v254, off, s48 offset:1240
		scratch_load_dword v255, off, s48 offset:1244
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[32:35], v[252:255], v[200:203], v18, v17 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v15 offset:1024
		s_mov_b32 s48, 0
		scratch_load_dword v204, off, s48 offset:912
		scratch_load_dword v205, off, s48 offset:916
		scratch_load_dword v206, off, s48 offset:920
		scratch_load_dword v207, off, s48 offset:924
		s_mov_b32 s48, 0
		scratch_load_dword v252, off, s48 offset:1280
		scratch_load_dword v253, off, s48 offset:1284
		scratch_load_dword v254, off, s48 offset:1288
		scratch_load_dword v255, off, s48 offset:1292
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[32:35], v[252:255], v[204:207], v18, v17 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[28:31], v15 offset:2048
		s_mov_b32 s48, 0
		scratch_load_dword v208, off, s48 offset:944
		scratch_load_dword v209, off, s48 offset:948
		scratch_load_dword v210, off, s48 offset:952
		scratch_load_dword v211, off, s48 offset:956
		s_mov_b32 s48, 0
		scratch_load_dword v252, off, s48 offset:1328
		scratch_load_dword v253, off, s48 offset:1332
		scratch_load_dword v254, off, s48 offset:1336
		scratch_load_dword v255, off, s48 offset:1340
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[252:255], v[208:211], v18, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[252:255], v15 offset:3072
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v252, s48 offset:1584
		scratch_store_dword off, v253, s48 offset:1588
		scratch_store_dword off, v254, s48 offset:1592
		scratch_store_dword off, v255, s48 offset:1596
		s_mov_b32 s48, 0
		scratch_load_dword v212, off, s48 offset:976
		scratch_load_dword v213, off, s48 offset:980
		scratch_load_dword v214, off, s48 offset:984
		scratch_load_dword v215, off, s48 offset:988
		s_mov_b32 s48, 0
		scratch_load_dword v252, off, s48 offset:1376
		scratch_load_dword v253, off, s48 offset:1380
		scratch_load_dword v254, off, s48 offset:1384
		scratch_load_dword v255, off, s48 offset:1388
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[252:255], v[212:215], v18, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[36:39], v12 offset:32768
		s_mov_b32 s48, 0
		scratch_load_dword v216, off, s48 offset:1008
		scratch_load_dword v217, off, s48 offset:1012
		scratch_load_dword v218, off, s48 offset:1016
		scratch_load_dword v219, off, s48 offset:1020
		s_mov_b32 s48, 0
		scratch_load_dword v252, off, s48 offset:1440
		scratch_load_dword v253, off, s48 offset:1444
		scratch_load_dword v254, off, s48 offset:1448
		scratch_load_dword v255, off, s48 offset:1452
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[252:255], v[216:219], v18, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[40:43], v12 offset:33792
		s_mov_b32 s48, 0
		scratch_load_dword v220, off, s48 offset:1040
		scratch_load_dword v221, off, s48 offset:1044
		scratch_load_dword v222, off, s48 offset:1048
		scratch_load_dword v223, off, s48 offset:1052
		s_mov_b32 s48, 0
		scratch_load_dword v252, off, s48 offset:1472
		scratch_load_dword v253, off, s48 offset:1476
		scratch_load_dword v254, off, s48 offset:1480
		scratch_load_dword v255, off, s48 offset:1484
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], v[252:255], v[220:223], v18, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[44:47], v12 offset:34816
		s_mov_b32 s48, 0
		scratch_load_dword v224, off, s48 offset:1072
		scratch_load_dword v225, off, s48 offset:1076
		scratch_load_dword v226, off, s48 offset:1080
		scratch_load_dword v227, off, s48 offset:1084
		s_mov_b32 s48, 0
		scratch_load_dword v252, off, s48 offset:1504
		scratch_load_dword v253, off, s48 offset:1508
		scratch_load_dword v254, off, s48 offset:1512
		scratch_load_dword v255, off, s48 offset:1516
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[32:35], v[252:255], v[224:227], v18, v70 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[48:51], v12 offset:35840
		s_mov_b32 s48, 0
		scratch_load_dword v228, off, s48 offset:1104
		scratch_load_dword v229, off, s48 offset:1108
		scratch_load_dword v230, off, s48 offset:1112
		scratch_load_dword v231, off, s48 offset:1116
		s_mov_b32 s48, 0
		scratch_load_dword v252, off, s48 offset:1536
		scratch_load_dword v253, off, s48 offset:1540
		scratch_load_dword v254, off, s48 offset:1544
		scratch_load_dword v255, off, s48 offset:1548
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[32:35], v[252:255], v[228:231], v18, v70 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[52:55], v12 offset:36864
		ds_read_b128 v[56:59], v12 offset:37888
		ds_read_b128 v[60:63], v12 offset:38912
		ds_read_b128 v[64:67], v12 offset:39936
		s_lshl_b32 s48, s47, 12
		s_add_i32 s47, s48, 0x20000
		s_mov_b32 s48, 0
		scratch_load_dword v1, off, s48 offset:104
		s_mov_b32 s48, 0
		scratch_load_dword v2, off, s48 offset:1184
		s_waitcnt vmcnt(0)
		v_add3_u32 v9, s47, v1, v2
		ds_read_b32 v1, v9
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v1, s48 offset:1616
		ds_read_b32 v1, v9 offset:256
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v1, s48 offset:1620
		s_mov_b32 s48, 0
		scratch_load_dword v1, off, s48 offset:108
		s_mov_b32 s48, 0
		scratch_load_dword v2, off, s48 offset:1184
		s_waitcnt vmcnt(0)
		v_add3_u32 v9, s47, v2, v1
		ds_read_b32 v1, v9 offset:2048
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v1, s47 offset:1624
		ds_read_b32 v1, v9 offset:2304
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v1, s47 offset:1628
		ds_read_b32 v1, v9 offset:2560
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v1, s47 offset:1632
		ds_read_b32 v1, v9 offset:2816
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v1, s47 offset:1636
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(62)
		scratch_load_dword v4, off, s47 offset:128
		scratch_load_dword v5, off, s47 offset:132
		scratch_load_dword v6, off, s47 offset:136
		scratch_load_dword v7, off, s47 offset:140
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(42)
		scratch_load_dword v252, off, s47 offset:1188
		scratch_load_dword v253, off, s47 offset:1192
		scratch_load_dword v254, off, s47 offset:1196
		scratch_load_dword v255, off, s47 offset:1200
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[232:235], v[252:255], v[4:7], v16, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v84, off, s47 offset:160
		scratch_load_dword v85, off, s47 offset:164
		scratch_load_dword v86, off, s47 offset:168
		scratch_load_dword v87, off, s47 offset:172
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(34)
		scratch_load_dword v252, off, s47 offset:1216
		scratch_load_dword v253, off, s47 offset:1220
		scratch_load_dword v254, off, s47 offset:1224
		scratch_load_dword v255, off, s47 offset:1228
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[232:235], v[252:255], v[84:87], v16, v17 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v88, off, s47 offset:192
		scratch_load_dword v89, off, s47 offset:196
		scratch_load_dword v90, off, s47 offset:200
		scratch_load_dword v91, off, s47 offset:204
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(26)
		scratch_load_dword v252, off, s47 offset:1264
		scratch_load_dword v253, off, s47 offset:1268
		scratch_load_dword v254, off, s47 offset:1272
		scratch_load_dword v255, off, s47 offset:1276
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[232:235], v[252:255], v[88:91], v16, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v104, off, s47 offset:224
		scratch_load_dword v105, off, s47 offset:228
		scratch_load_dword v106, off, s47 offset:232
		scratch_load_dword v107, off, s47 offset:236
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(22)
		scratch_load_dword v252, off, s47 offset:1312
		scratch_load_dword v253, off, s47 offset:1316
		scratch_load_dword v254, off, s47 offset:1320
		scratch_load_dword v255, off, s47 offset:1324
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[232:235], v[252:255], v[104:107], v16, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v116, off, s47 offset:256
		scratch_load_dword v117, off, s47 offset:260
		scratch_load_dword v118, off, s47 offset:264
		scratch_load_dword v119, off, s47 offset:268
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(18)
		scratch_load_dword v252, off, s47 offset:1360
		scratch_load_dword v253, off, s47 offset:1364
		scratch_load_dword v254, off, s47 offset:1368
		scratch_load_dword v255, off, s47 offset:1372
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[232:235], v[252:255], v[116:119], v16, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v124, off, s47 offset:288
		scratch_load_dword v125, off, s47 offset:292
		scratch_load_dword v126, off, s47 offset:296
		scratch_load_dword v127, off, s47 offset:300
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(14)
		scratch_load_dword v252, off, s47 offset:1408
		scratch_load_dword v253, off, s47 offset:1412
		scratch_load_dword v254, off, s47 offset:1416
		scratch_load_dword v255, off, s47 offset:1420
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[232:235], v[252:255], v[124:127], v16, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v128, off, s47 offset:320
		scratch_load_dword v129, off, s47 offset:324
		scratch_load_dword v130, off, s47 offset:328
		scratch_load_dword v131, off, s47 offset:332
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(10)
		scratch_load_dword v252, off, s47 offset:1568
		scratch_load_dword v253, off, s47 offset:1572
		scratch_load_dword v254, off, s47 offset:1576
		scratch_load_dword v255, off, s47 offset:1580
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[232:235], v[252:255], v[128:131], v16, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[232:235], v[248:251], v[132:135], v16, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1188
		scratch_load_dword v233, off, s47 offset:1192
		scratch_load_dword v234, off, s47 offset:1196
		scratch_load_dword v235, off, s47 offset:1200
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[236:239], v[232:235], v[136:139], v16, v17 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1216
		scratch_load_dword v233, off, s47 offset:1220
		scratch_load_dword v234, off, s47 offset:1224
		scratch_load_dword v235, off, s47 offset:1228
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[236:239], v[232:235], v[140:143], v16, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1264
		scratch_load_dword v233, off, s47 offset:1268
		scratch_load_dword v234, off, s47 offset:1272
		scratch_load_dword v235, off, s47 offset:1276
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[236:239], v[232:235], v[144:147], v16, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1312
		scratch_load_dword v233, off, s47 offset:1316
		scratch_load_dword v234, off, s47 offset:1320
		scratch_load_dword v235, off, s47 offset:1324
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[236:239], v[232:235], v[148:151], v16, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1360
		scratch_load_dword v233, off, s47 offset:1364
		scratch_load_dword v234, off, s47 offset:1368
		scratch_load_dword v235, off, s47 offset:1372
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[236:239], v[232:235], v[152:155], v16, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1408
		scratch_load_dword v233, off, s47 offset:1412
		scratch_load_dword v234, off, s47 offset:1416
		scratch_load_dword v235, off, s47 offset:1420
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[236:239], v[232:235], v[156:159], v16, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1568
		scratch_load_dword v233, off, s47 offset:1572
		scratch_load_dword v234, off, s47 offset:1576
		scratch_load_dword v235, off, s47 offset:1580
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[236:239], v[232:235], v[160:163], v16, v70 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[236:239], v[248:251], v[164:167], v16, v70 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1188
		scratch_load_dword v233, off, s47 offset:1192
		scratch_load_dword v234, off, s47 offset:1196
		scratch_load_dword v235, off, s47 offset:1200
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[240:243], v[232:235], v[168:171], v18, v17 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1216
		scratch_load_dword v233, off, s47 offset:1220
		scratch_load_dword v234, off, s47 offset:1224
		scratch_load_dword v235, off, s47 offset:1228
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[240:243], v[232:235], v[172:175], v18, v17 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1264
		scratch_load_dword v233, off, s47 offset:1268
		scratch_load_dword v234, off, s47 offset:1272
		scratch_load_dword v235, off, s47 offset:1276
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[240:243], v[232:235], v[176:179], v18, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1312
		scratch_load_dword v233, off, s47 offset:1316
		scratch_load_dword v234, off, s47 offset:1320
		scratch_load_dword v235, off, s47 offset:1324
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[240:243], v[232:235], v[180:183], v18, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1360
		scratch_load_dword v233, off, s47 offset:1364
		scratch_load_dword v234, off, s47 offset:1368
		scratch_load_dword v235, off, s47 offset:1372
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[240:243], v[232:235], v[184:187], v18, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1408
		scratch_load_dword v233, off, s47 offset:1412
		scratch_load_dword v234, off, s47 offset:1416
		scratch_load_dword v235, off, s47 offset:1420
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[240:243], v[232:235], v[188:191], v18, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1568
		scratch_load_dword v233, off, s47 offset:1572
		scratch_load_dword v234, off, s47 offset:1576
		scratch_load_dword v235, off, s47 offset:1580
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[240:243], v[232:235], v[192:195], v18, v70 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[240:243], v[248:251], v[196:199], v18, v70 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1188
		scratch_load_dword v233, off, s47 offset:1192
		scratch_load_dword v234, off, s47 offset:1196
		scratch_load_dword v235, off, s47 offset:1200
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[244:247], v[232:235], v[200:203], v18, v17 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1216
		scratch_load_dword v233, off, s47 offset:1220
		scratch_load_dword v234, off, s47 offset:1224
		scratch_load_dword v235, off, s47 offset:1228
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[244:247], v[232:235], v[204:207], v18, v17 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1264
		scratch_load_dword v233, off, s47 offset:1268
		scratch_load_dword v234, off, s47 offset:1272
		scratch_load_dword v235, off, s47 offset:1276
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[244:247], v[232:235], v[208:211], v18, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1312
		scratch_load_dword v233, off, s47 offset:1316
		scratch_load_dword v234, off, s47 offset:1320
		scratch_load_dword v235, off, s47 offset:1324
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[244:247], v[232:235], v[212:215], v18, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1360
		scratch_load_dword v233, off, s47 offset:1364
		scratch_load_dword v234, off, s47 offset:1368
		scratch_load_dword v235, off, s47 offset:1372
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[244:247], v[232:235], v[216:219], v18, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1408
		scratch_load_dword v233, off, s47 offset:1412
		scratch_load_dword v234, off, s47 offset:1416
		scratch_load_dword v235, off, s47 offset:1420
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[244:247], v[232:235], v[220:223], v18, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1568
		scratch_load_dword v233, off, s47 offset:1572
		scratch_load_dword v234, off, s47 offset:1576
		scratch_load_dword v235, off, s47 offset:1580
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
		scratch_load_dword v1, off, s49 offset:1136
		s_mov_b32 s49, 0
		scratch_load_dword v9, off, s49 offset:1140
		s_waitcnt vmcnt(0)
		v_add3_u32 v12, v2, v1, v9
		s_mov_b32 s49, 0
		scratch_store_dword off, v12, s49 offset:1664
		ds_read_b128 v[232:235], v12
		s_mov_b32 s49, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v232, s49 offset:1840
		scratch_store_dword off, v233, s49 offset:1844
		scratch_store_dword off, v234, s49 offset:1848
		scratch_store_dword off, v235, s49 offset:1852
		ds_read_b128 v[236:239], v12 offset:1024
		s_mov_b32 s49, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s49 offset:1856
		scratch_store_dword off, v237, s49 offset:1860
		scratch_store_dword off, v238, s49 offset:1864
		scratch_store_dword off, v239, s49 offset:1868
		ds_read_b128 v[236:239], v12 offset:2048
		s_mov_b32 s49, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s49 offset:1872
		scratch_store_dword off, v237, s49 offset:1876
		scratch_store_dword off, v238, s49 offset:1880
		scratch_store_dword off, v239, s49 offset:1884
		ds_read_b128 v[236:239], v12 offset:3072
		s_mov_b32 s49, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s49 offset:1888
		scratch_store_dword off, v237, s49 offset:1892
		scratch_store_dword off, v238, s49 offset:1896
		scratch_store_dword off, v239, s49 offset:1900
		s_mov_b32 s49, 0
		scratch_load_dword v1, off, s49 offset:1136
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v2, s47, v1
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:92
		s_mov_b32 s47, 0
		scratch_load_dword v9, off, s47 offset:1140
		s_waitcnt vmcnt(0)
		v_add3_u32 v12, v2, v1, v9
		s_mov_b32 s47, 0
		scratch_store_dword off, v12, s47 offset:1952
		ds_read_b128 v[236:239], v12 offset:32768
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s47 offset:1668
		scratch_store_dword off, v237, s47 offset:1672
		scratch_store_dword off, v238, s47 offset:1676
		scratch_store_dword off, v239, s47 offset:1680
		ds_read_b128 v[236:239], v12 offset:33792
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s47 offset:1684
		scratch_store_dword off, v237, s47 offset:1688
		scratch_store_dword off, v238, s47 offset:1692
		scratch_store_dword off, v239, s47 offset:1696
		ds_read_b128 v[236:239], v12 offset:34816
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s47 offset:1700
		scratch_store_dword off, v237, s47 offset:1704
		scratch_store_dword off, v238, s47 offset:1708
		scratch_store_dword off, v239, s47 offset:1712
		ds_read_b128 v[236:239], v12 offset:35840
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s47 offset:1716
		scratch_store_dword off, v237, s47 offset:1720
		scratch_store_dword off, v238, s47 offset:1724
		scratch_store_dword off, v239, s47 offset:1728
		ds_read_b128 v[236:239], v12 offset:36864
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s47 offset:1732
		scratch_store_dword off, v237, s47 offset:1736
		scratch_store_dword off, v238, s47 offset:1740
		scratch_store_dword off, v239, s47 offset:1744
		ds_read_b128 v[236:239], v12 offset:37888
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s47 offset:1748
		scratch_store_dword off, v237, s47 offset:1752
		scratch_store_dword off, v238, s47 offset:1756
		scratch_store_dword off, v239, s47 offset:1760
		ds_read_b128 v[236:239], v12 offset:38912
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s47 offset:1808
		scratch_store_dword off, v237, s47 offset:1812
		scratch_store_dword off, v238, s47 offset:1816
		scratch_store_dword off, v239, s47 offset:1820
		ds_read_b128 v[236:239], v12 offset:39936
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s47 offset:1824
		scratch_store_dword off, v237, s47 offset:1828
		scratch_store_dword off, v238, s47 offset:1832
		scratch_store_dword off, v239, s47 offset:1836
		s_lshl_b32 s47, s48, 12
		s_add_i32 s48, s47, 0x20000
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:104
		s_mov_b32 s47, 0
		scratch_load_dword v2, off, s47 offset:1184
		s_waitcnt vmcnt(0)
		v_add3_u32 v9, s48, v1, v2
		ds_read_b32 v1, v9
		ds_read_b32 v2, v9 offset:256
		s_mov_b32 s47, 0
		scratch_load_dword v9, off, s47 offset:108
		s_mov_b32 s47, 0
		scratch_load_dword v15, off, s47 offset:1184
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
		scratch_store_dword off, v94, s47 offset:1764
		s_mov_b32 s47, 0
		scratch_load_dword v82, off, s47 offset:8
		scratch_load_dword v83, off, s47 offset:12
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v94, vcc, v82, v76
		v_addc_co_u32_e64 v95, vcc, v83, v77, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v94, s47 offset:1768
		s_mov_b32 s47, 0
		scratch_load_dword v82, off, s47 offset:16
		scratch_load_dword v83, off, s47 offset:20
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v94, vcc, v82, v76
		v_addc_co_u32_e64 v95, vcc, v83, v77, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v94, s47 offset:1772
		s_mov_b32 s47, 0
		scratch_load_dword v82, off, s47 offset:24
		scratch_load_dword v83, off, s47 offset:28
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v94, vcc, v82, v76
		v_addc_co_u32_e64 v95, vcc, v83, v77, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v94, s47 offset:1776
		s_mov_b32 s47, 0
		scratch_load_dword v82, off, s47 offset:32
		scratch_load_dword v83, off, s47 offset:36
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v94, vcc, v82, v76
		v_addc_co_u32_e64 v95, vcc, v83, v77, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v94, s47 offset:1780
		s_mov_b32 s47, 0
		scratch_load_dword v82, off, s47 offset:40
		scratch_load_dword v83, off, s47 offset:44
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v94, vcc, v82, v76
		v_addc_co_u32_e64 v95, vcc, v83, v77, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v94, s47 offset:1784
		s_mov_b32 s47, 0
		scratch_load_dword v82, off, s47 offset:48
		scratch_load_dword v83, off, s47 offset:52
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v94, vcc, v82, v76
		v_addc_co_u32_e64 v95, vcc, v83, v77, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v94, s47 offset:1788
		s_mov_b32 s47, 0
		scratch_load_dword v82, off, s47 offset:56
		scratch_load_dword v83, off, s47 offset:60
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v94, vcc, v82, v76
		v_addc_co_u32_e64 v95, vcc, v83, v77, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v94, s47 offset:1792
		s_mov_b32 s47, 0
		scratch_load_dword v76, off, s47 offset:64
		scratch_load_dword v77, off, s47 offset:68
		s_mov_b32 s47, 0
		scratch_load_dword v82, off, s47 offset:1176
		scratch_load_dword v83, off, s47 offset:1180
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v94, vcc, v76, v82
		v_addc_co_u32_e64 v95, vcc, v77, v83, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v94, s47 offset:1796
		s_mov_b32 s47, 0
		scratch_load_dword v76, off, s47 offset:76
		scratch_load_dword v77, off, s47 offset:80
		s_mov_b32 s47, 0
		scratch_load_dword v82, off, s47 offset:1176
		scratch_load_dword v83, off, s47 offset:1180
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v94, vcc, v76, v82
		v_addc_co_u32_e64 v95, vcc, v77, v83, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v94, s47 offset:1800
		s_mov_b32 s47, 0
		scratch_load_dword v76, off, s47 offset:84
		scratch_load_dword v77, off, s47 offset:88
		s_mov_b32 s47, 0
		scratch_load_dword v82, off, s47 offset:1176
		scratch_load_dword v83, off, s47 offset:1180
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v94, vcc, v76, v82
		v_addc_co_u32_e64 v95, vcc, v77, v83, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v94, s47 offset:1804
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(39)
		scratch_load_dword v236, off, s47 offset:1668
		scratch_load_dword v237, off, s47 offset:1672
		scratch_load_dword v238, off, s47 offset:1676
		scratch_load_dword v239, off, s47 offset:1680
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[232:235], v[236:239], v[4:7], v1, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v19, off, s47 offset:1664
		s_waitcnt vmcnt(0)
		ds_read_b128 v[236:239], v19 offset:16384
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(35)
		scratch_load_dword v240, off, s47 offset:1684
		scratch_load_dword v241, off, s47 offset:1688
		scratch_load_dword v242, off, s47 offset:1692
		scratch_load_dword v243, off, s47 offset:1696
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[232:235], v[240:243], v[84:87], v1, v9 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v19, off, s47 offset:1664
		s_waitcnt vmcnt(0)
		ds_read_b128 v[232:235], v19 offset:17408
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(31)
		scratch_load_dword v240, off, s47 offset:1700
		scratch_load_dword v241, off, s47 offset:1704
		scratch_load_dword v242, off, s47 offset:1708
		scratch_load_dword v243, off, s47 offset:1712
		s_mov_b32 s47, 0
		scratch_load_dword v244, off, s47 offset:1840
		scratch_load_dword v245, off, s47 offset:1844
		scratch_load_dword v246, off, s47 offset:1848
		scratch_load_dword v247, off, s47 offset:1852
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[244:247], v[240:243], v[88:91], v1, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v19, off, s47 offset:1664
		s_waitcnt vmcnt(0)
		ds_read_b128 v[240:243], v19 offset:18432
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(27)
		scratch_load_dword v244, off, s47 offset:1716
		scratch_load_dword v245, off, s47 offset:1720
		scratch_load_dword v246, off, s47 offset:1724
		scratch_load_dword v247, off, s47 offset:1728
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:1840
		scratch_load_dword v249, off, s47 offset:1844
		scratch_load_dword v250, off, s47 offset:1848
		scratch_load_dword v251, off, s47 offset:1852
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[248:251], v[244:247], v[104:107], v1, v15 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v19, off, s47 offset:1664
		s_waitcnt vmcnt(0)
		ds_read_b128 v[244:247], v19 offset:19456
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(23)
		scratch_load_dword v248, off, s47 offset:1732
		scratch_load_dword v249, off, s47 offset:1736
		scratch_load_dword v250, off, s47 offset:1740
		scratch_load_dword v251, off, s47 offset:1744
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:1840
		scratch_load_dword v253, off, s47 offset:1844
		scratch_load_dword v254, off, s47 offset:1848
		scratch_load_dword v255, off, s47 offset:1852
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[252:255], v[248:251], v[116:119], v1, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v12 offset:49152
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s47 offset:1904
		scratch_store_dword off, v249, s47 offset:1908
		scratch_store_dword off, v250, s47 offset:1912
		scratch_store_dword off, v251, s47 offset:1916
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(23)
		scratch_load_dword v248, off, s47 offset:1748
		scratch_load_dword v249, off, s47 offset:1752
		scratch_load_dword v250, off, s47 offset:1756
		scratch_load_dword v251, off, s47 offset:1760
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:1840
		scratch_load_dword v253, off, s47 offset:1844
		scratch_load_dword v254, off, s47 offset:1848
		scratch_load_dword v255, off, s47 offset:1852
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[252:255], v[248:251], v[124:127], v1, v71 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v12 offset:50176
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s47 offset:1920
		scratch_store_dword off, v249, s47 offset:1924
		scratch_store_dword off, v250, s47 offset:1928
		scratch_store_dword off, v251, s47 offset:1932
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(23)
		scratch_load_dword v248, off, s47 offset:1808
		scratch_load_dword v249, off, s47 offset:1812
		scratch_load_dword v250, off, s47 offset:1816
		scratch_load_dword v251, off, s47 offset:1820
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:1840
		scratch_load_dword v253, off, s47 offset:1844
		scratch_load_dword v254, off, s47 offset:1848
		scratch_load_dword v255, off, s47 offset:1852
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[252:255], v[248:251], v[128:131], v1, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v12 offset:51200
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s47 offset:1936
		scratch_store_dword off, v249, s47 offset:1940
		scratch_store_dword off, v250, s47 offset:1944
		scratch_store_dword off, v251, s47 offset:1948
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(23)
		scratch_load_dword v248, off, s47 offset:1824
		scratch_load_dword v249, off, s47 offset:1828
		scratch_load_dword v250, off, s47 offset:1832
		scratch_load_dword v251, off, s47 offset:1836
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:1840
		scratch_load_dword v253, off, s47 offset:1844
		scratch_load_dword v254, off, s47 offset:1848
		scratch_load_dword v255, off, s47 offset:1852
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[252:255], v[248:251], v[132:135], v1, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v12 offset:52224
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s47 offset:1956
		scratch_store_dword off, v249, s47 offset:1960
		scratch_store_dword off, v250, s47 offset:1964
		scratch_store_dword off, v251, s47 offset:1968
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:1668
		scratch_load_dword v249, off, s47 offset:1672
		scratch_load_dword v250, off, s47 offset:1676
		scratch_load_dword v251, off, s47 offset:1680
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:1856
		scratch_load_dword v253, off, s47 offset:1860
		scratch_load_dword v254, off, s47 offset:1864
		scratch_load_dword v255, off, s47 offset:1868
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[252:255], v[248:251], v[136:139], v1, v9 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v12, off, s47 offset:1952
		s_waitcnt vmcnt(0)
		ds_read_b128 v[248:251], v12 offset:53248
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s47 offset:1972
		scratch_store_dword off, v249, s47 offset:1976
		scratch_store_dword off, v250, s47 offset:1980
		scratch_store_dword off, v251, s47 offset:1984
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:1684
		scratch_load_dword v249, off, s47 offset:1688
		scratch_load_dword v250, off, s47 offset:1692
		scratch_load_dword v251, off, s47 offset:1696
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:1856
		scratch_load_dword v253, off, s47 offset:1860
		scratch_load_dword v254, off, s47 offset:1864
		scratch_load_dword v255, off, s47 offset:1868
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[252:255], v[248:251], v[140:143], v1, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v12, off, s47 offset:1952
		s_waitcnt vmcnt(0)
		ds_read_b128 v[248:251], v12 offset:54272
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s47 offset:1988
		scratch_store_dword off, v249, s47 offset:1992
		scratch_store_dword off, v250, s47 offset:1996
		scratch_store_dword off, v251, s47 offset:2000
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:1700
		scratch_load_dword v249, off, s47 offset:1704
		scratch_load_dword v250, off, s47 offset:1708
		scratch_load_dword v251, off, s47 offset:1712
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:1856
		scratch_load_dword v253, off, s47 offset:1860
		scratch_load_dword v254, off, s47 offset:1864
		scratch_load_dword v255, off, s47 offset:1868
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[252:255], v[248:251], v[144:147], v1, v15 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v12, off, s47 offset:1952
		s_waitcnt vmcnt(0)
		ds_read_b128 v[248:251], v12 offset:55296
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s47 offset:2004
		scratch_store_dword off, v249, s47 offset:2008
		scratch_store_dword off, v250, s47 offset:2012
		scratch_store_dword off, v251, s47 offset:2016
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:1716
		scratch_load_dword v249, off, s47 offset:1720
		scratch_load_dword v250, off, s47 offset:1724
		scratch_load_dword v251, off, s47 offset:1728
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:1856
		scratch_load_dword v253, off, s47 offset:1860
		scratch_load_dword v254, off, s47 offset:1864
		scratch_load_dword v255, off, s47 offset:1868
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[252:255], v[248:251], v[148:151], v1, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v12, off, s47 offset:1952
		s_waitcnt vmcnt(0)
		ds_read_b128 v[248:251], v12 offset:56320
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s47 offset:2020
		scratch_store_dword off, v249, s47 offset:2024
		scratch_store_dword off, v250, s47 offset:2028
		scratch_store_dword off, v251, s47 offset:2032
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:1732
		scratch_load_dword v249, off, s47 offset:1736
		scratch_load_dword v250, off, s47 offset:1740
		scratch_load_dword v251, off, s47 offset:1744
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:1856
		scratch_load_dword v253, off, s47 offset:1860
		scratch_load_dword v254, off, s47 offset:1864
		scratch_load_dword v255, off, s47 offset:1868
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[252:255], v[248:251], v[152:155], v1, v71 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s10
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(42)
		scratch_load_dword v12, off, s47 offset:1764
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:1748
		scratch_load_dword v249, off, s47 offset:1752
		scratch_load_dword v250, off, s47 offset:1756
		scratch_load_dword v251, off, s47 offset:1760
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:1856
		scratch_load_dword v253, off, s47 offset:1860
		scratch_load_dword v254, off, s47 offset:1864
		scratch_load_dword v255, off, s47 offset:1868
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[252:255], v[248:251], v[156:159], v1, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s38
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(41)
		scratch_load_dword v12, off, s47 offset:1768
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:1808
		scratch_load_dword v249, off, s47 offset:1812
		scratch_load_dword v250, off, s47 offset:1816
		scratch_load_dword v251, off, s47 offset:1820
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:1856
		scratch_load_dword v253, off, s47 offset:1860
		scratch_load_dword v254, off, s47 offset:1864
		scratch_load_dword v255, off, s47 offset:1868
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[252:255], v[248:251], v[160:163], v1, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s39
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(40)
		scratch_load_dword v12, off, s47 offset:1772
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:1824
		scratch_load_dword v249, off, s47 offset:1828
		scratch_load_dword v250, off, s47 offset:1832
		scratch_load_dword v251, off, s47 offset:1836
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:1856
		scratch_load_dword v253, off, s47 offset:1860
		scratch_load_dword v254, off, s47 offset:1864
		scratch_load_dword v255, off, s47 offset:1868
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[252:255], v[248:251], v[164:167], v1, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s40
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(39)
		scratch_load_dword v12, off, s47 offset:1776
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:1668
		scratch_load_dword v249, off, s47 offset:1672
		scratch_load_dword v250, off, s47 offset:1676
		scratch_load_dword v251, off, s47 offset:1680
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:1872
		scratch_load_dword v253, off, s47 offset:1876
		scratch_load_dword v254, off, s47 offset:1880
		scratch_load_dword v255, off, s47 offset:1884
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[252:255], v[248:251], v[168:171], v2, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s41
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(38)
		scratch_load_dword v12, off, s47 offset:1780
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v12, s[0:3], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:1684
		scratch_load_dword v249, off, s47 offset:1688
		scratch_load_dword v250, off, s47 offset:1692
		scratch_load_dword v251, off, s47 offset:1696
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:1872
		scratch_load_dword v253, off, s47 offset:1876
		scratch_load_dword v254, off, s47 offset:1880
		scratch_load_dword v255, off, s47 offset:1884
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[252:255], v[248:251], v[172:175], v2, v9 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s42
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(37)
		scratch_load_dword v12, off, s47 offset:1784
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v12, s[0:3], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:1700
		scratch_load_dword v249, off, s47 offset:1704
		scratch_load_dword v250, off, s47 offset:1708
		scratch_load_dword v251, off, s47 offset:1712
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:1872
		scratch_load_dword v253, off, s47 offset:1876
		scratch_load_dword v254, off, s47 offset:1880
		scratch_load_dword v255, off, s47 offset:1884
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[252:255], v[248:251], v[176:179], v2, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s43
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(36)
		scratch_load_dword v12, off, s47 offset:1788
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v12, s[0:3], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:1716
		scratch_load_dword v249, off, s47 offset:1720
		scratch_load_dword v250, off, s47 offset:1724
		scratch_load_dword v251, off, s47 offset:1728
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:1872
		scratch_load_dword v253, off, s47 offset:1876
		scratch_load_dword v254, off, s47 offset:1880
		scratch_load_dword v255, off, s47 offset:1884
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[252:255], v[248:251], v[180:183], v2, v15 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s44
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(35)
		scratch_load_dword v12, off, s47 offset:1792
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v12, s[0:3], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:1732
		scratch_load_dword v249, off, s47 offset:1736
		scratch_load_dword v250, off, s47 offset:1740
		scratch_load_dword v251, off, s47 offset:1744
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:1872
		scratch_load_dword v253, off, s47 offset:1876
		scratch_load_dword v254, off, s47 offset:1880
		scratch_load_dword v255, off, s47 offset:1884
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[252:255], v[248:251], v[184:187], v2, v71 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s45, 0x20000
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(34)
		scratch_load_dword v12, off, s47 offset:1796
		s_waitcnt vmcnt(0)
		buffer_load_dword v12, s[4:7], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:1748
		scratch_load_dword v249, off, s47 offset:1752
		scratch_load_dword v250, off, s47 offset:1756
		scratch_load_dword v251, off, s47 offset:1760
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:1872
		scratch_load_dword v253, off, s47 offset:1876
		scratch_load_dword v254, off, s47 offset:1880
		scratch_load_dword v255, off, s47 offset:1884
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[252:255], v[248:251], v[188:191], v2, v71 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s9, 0x20000
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(33)
		scratch_load_dword v12, off, s47 offset:1800
		s_waitcnt vmcnt(0)
		buffer_load_dword v12, s[4:7], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:1808
		scratch_load_dword v249, off, s47 offset:1812
		scratch_load_dword v250, off, s47 offset:1816
		scratch_load_dword v251, off, s47 offset:1820
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:1872
		scratch_load_dword v253, off, s47 offset:1876
		scratch_load_dword v254, off, s47 offset:1880
		scratch_load_dword v255, off, s47 offset:1884
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[252:255], v[248:251], v[192:195], v2, v74 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s35, 0x20000
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(32)
		scratch_load_dword v12, off, s47 offset:1804
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:1824
		scratch_load_dword v249, off, s47 offset:1828
		scratch_load_dword v250, off, s47 offset:1832
		scratch_load_dword v251, off, s47 offset:1836
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:1872
		scratch_load_dword v253, off, s47 offset:1876
		scratch_load_dword v254, off, s47 offset:1880
		scratch_load_dword v255, off, s47 offset:1884
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[252:255], v[248:251], v[196:199], v2, v74 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:1668
		scratch_load_dword v249, off, s47 offset:1672
		scratch_load_dword v250, off, s47 offset:1676
		scratch_load_dword v251, off, s47 offset:1680
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:1888
		scratch_load_dword v253, off, s47 offset:1892
		scratch_load_dword v254, off, s47 offset:1896
		scratch_load_dword v255, off, s47 offset:1900
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[252:255], v[248:251], v[200:203], v2, v9 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:1684
		scratch_load_dword v249, off, s47 offset:1688
		scratch_load_dword v250, off, s47 offset:1692
		scratch_load_dword v251, off, s47 offset:1696
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:1888
		scratch_load_dword v253, off, s47 offset:1892
		scratch_load_dword v254, off, s47 offset:1896
		scratch_load_dword v255, off, s47 offset:1900
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[252:255], v[248:251], v[204:207], v2, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:1700
		scratch_load_dword v249, off, s47 offset:1704
		scratch_load_dword v250, off, s47 offset:1708
		scratch_load_dword v251, off, s47 offset:1712
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:1888
		scratch_load_dword v253, off, s47 offset:1892
		scratch_load_dword v254, off, s47 offset:1896
		scratch_load_dword v255, off, s47 offset:1900
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[252:255], v[248:251], v[208:211], v2, v15 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:1716
		scratch_load_dword v249, off, s47 offset:1720
		scratch_load_dword v250, off, s47 offset:1724
		scratch_load_dword v251, off, s47 offset:1728
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:1888
		scratch_load_dword v253, off, s47 offset:1892
		scratch_load_dword v254, off, s47 offset:1896
		scratch_load_dword v255, off, s47 offset:1900
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[252:255], v[248:251], v[212:215], v2, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:1732
		scratch_load_dword v249, off, s47 offset:1736
		scratch_load_dword v250, off, s47 offset:1740
		scratch_load_dword v251, off, s47 offset:1744
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:1888
		scratch_load_dword v253, off, s47 offset:1892
		scratch_load_dword v254, off, s47 offset:1896
		scratch_load_dword v255, off, s47 offset:1900
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[252:255], v[248:251], v[216:219], v2, v71 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:1748
		scratch_load_dword v249, off, s47 offset:1752
		scratch_load_dword v250, off, s47 offset:1756
		scratch_load_dword v251, off, s47 offset:1760
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:1888
		scratch_load_dword v253, off, s47 offset:1892
		scratch_load_dword v254, off, s47 offset:1896
		scratch_load_dword v255, off, s47 offset:1900
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[252:255], v[248:251], v[220:223], v2, v71 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:1808
		scratch_load_dword v249, off, s47 offset:1812
		scratch_load_dword v250, off, s47 offset:1816
		scratch_load_dword v251, off, s47 offset:1820
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:1888
		scratch_load_dword v253, off, s47 offset:1892
		scratch_load_dword v254, off, s47 offset:1896
		scratch_load_dword v255, off, s47 offset:1900
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[252:255], v[248:251], v[224:227], v2, v74 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v248, off, s47 offset:1824
		scratch_load_dword v249, off, s47 offset:1828
		scratch_load_dword v250, off, s47 offset:1832
		scratch_load_dword v251, off, s47 offset:1836
		s_mov_b32 s47, 0
		scratch_load_dword v252, off, s47 offset:1888
		scratch_load_dword v253, off, s47 offset:1892
		scratch_load_dword v254, off, s47 offset:1896
		scratch_load_dword v255, off, s47 offset:1900
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[252:255], v[248:251], v[228:231], v2, v74 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(28)
		scratch_load_dword v248, off, s47 offset:1904
		scratch_load_dword v249, off, s47 offset:1908
		scratch_load_dword v250, off, s47 offset:1912
		scratch_load_dword v251, off, s47 offset:1916
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[236:239], v[248:251], v[4:7], v1, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v248, off, s47 offset:1920
		scratch_load_dword v249, off, s47 offset:1924
		scratch_load_dword v250, off, s47 offset:1928
		scratch_load_dword v251, off, s47 offset:1932
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[236:239], v[248:251], v[84:87], v1, v9 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(20)
		scratch_load_dword v248, off, s47 offset:1936
		scratch_load_dword v249, off, s47 offset:1940
		scratch_load_dword v250, off, s47 offset:1944
		scratch_load_dword v251, off, s47 offset:1948
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[236:239], v[248:251], v[88:91], v1, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v248, off, s47 offset:1956
		scratch_load_dword v249, off, s47 offset:1960
		scratch_load_dword v250, off, s47 offset:1964
		scratch_load_dword v251, off, s47 offset:1968
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[236:239], v[248:251], v[104:107], v1, v15 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(12)
		scratch_load_dword v248, off, s47 offset:1972
		scratch_load_dword v249, off, s47 offset:1976
		scratch_load_dword v250, off, s47 offset:1980
		scratch_load_dword v251, off, s47 offset:1984
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[236:239], v[248:251], v[116:119], v1, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v248, off, s47 offset:1988
		scratch_load_dword v249, off, s47 offset:1992
		scratch_load_dword v250, off, s47 offset:1996
		scratch_load_dword v251, off, s47 offset:2000
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[236:239], v[248:251], v[124:127], v1, v71 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v248, off, s47 offset:2004
		scratch_load_dword v249, off, s47 offset:2008
		scratch_load_dword v250, off, s47 offset:2012
		scratch_load_dword v251, off, s47 offset:2016
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[236:239], v[248:251], v[128:131], v1, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v248, off, s47 offset:2020
		scratch_load_dword v249, off, s47 offset:2024
		scratch_load_dword v250, off, s47 offset:2028
		scratch_load_dword v251, off, s47 offset:2032
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[236:239], v[248:251], v[132:135], v1, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v236, off, s47 offset:1904
		scratch_load_dword v237, off, s47 offset:1908
		scratch_load_dword v238, off, s47 offset:1912
		scratch_load_dword v239, off, s47 offset:1916
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[232:235], v[236:239], v[136:139], v1, v9 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v236, off, s47 offset:1920
		scratch_load_dword v237, off, s47 offset:1924
		scratch_load_dword v238, off, s47 offset:1928
		scratch_load_dword v239, off, s47 offset:1932
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[232:235], v[236:239], v[140:143], v1, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v236, off, s47 offset:1936
		scratch_load_dword v237, off, s47 offset:1940
		scratch_load_dword v238, off, s47 offset:1944
		scratch_load_dword v239, off, s47 offset:1948
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[232:235], v[236:239], v[144:147], v1, v15 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v236, off, s47 offset:1956
		scratch_load_dword v237, off, s47 offset:1960
		scratch_load_dword v238, off, s47 offset:1964
		scratch_load_dword v239, off, s47 offset:1968
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[232:235], v[236:239], v[148:151], v1, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v236, off, s47 offset:1972
		scratch_load_dword v237, off, s47 offset:1976
		scratch_load_dword v238, off, s47 offset:1980
		scratch_load_dword v239, off, s47 offset:1984
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[232:235], v[236:239], v[152:155], v1, v71 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v236, off, s47 offset:1988
		scratch_load_dword v237, off, s47 offset:1992
		scratch_load_dword v238, off, s47 offset:1996
		scratch_load_dword v239, off, s47 offset:2000
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[232:235], v[236:239], v[156:159], v1, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v236, off, s47 offset:2004
		scratch_load_dword v237, off, s47 offset:2008
		scratch_load_dword v238, off, s47 offset:2012
		scratch_load_dword v239, off, s47 offset:2016
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[232:235], v[236:239], v[160:163], v1, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v236, off, s47 offset:2020
		scratch_load_dword v237, off, s47 offset:2024
		scratch_load_dword v238, off, s47 offset:2028
		scratch_load_dword v239, off, s47 offset:2032
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[232:235], v[236:239], v[164:167], v1, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1904
		scratch_load_dword v233, off, s47 offset:1908
		scratch_load_dword v234, off, s47 offset:1912
		scratch_load_dword v235, off, s47 offset:1916
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[240:243], v[232:235], v[168:171], v2, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1920
		scratch_load_dword v233, off, s47 offset:1924
		scratch_load_dword v234, off, s47 offset:1928
		scratch_load_dword v235, off, s47 offset:1932
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[240:243], v[232:235], v[172:175], v2, v9 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1936
		scratch_load_dword v233, off, s47 offset:1940
		scratch_load_dword v234, off, s47 offset:1944
		scratch_load_dword v235, off, s47 offset:1948
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[240:243], v[232:235], v[176:179], v2, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1956
		scratch_load_dword v233, off, s47 offset:1960
		scratch_load_dword v234, off, s47 offset:1964
		scratch_load_dword v235, off, s47 offset:1968
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[240:243], v[232:235], v[180:183], v2, v15 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1972
		scratch_load_dword v233, off, s47 offset:1976
		scratch_load_dword v234, off, s47 offset:1980
		scratch_load_dword v235, off, s47 offset:1984
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[240:243], v[232:235], v[184:187], v2, v71 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1988
		scratch_load_dword v233, off, s47 offset:1992
		scratch_load_dword v234, off, s47 offset:1996
		scratch_load_dword v235, off, s47 offset:2000
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[240:243], v[232:235], v[188:191], v2, v71 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:2004
		scratch_load_dword v233, off, s47 offset:2008
		scratch_load_dword v234, off, s47 offset:2012
		scratch_load_dword v235, off, s47 offset:2016
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[240:243], v[232:235], v[192:195], v2, v74 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:2020
		scratch_load_dword v233, off, s47 offset:2024
		scratch_load_dword v234, off, s47 offset:2028
		scratch_load_dword v235, off, s47 offset:2032
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[240:243], v[232:235], v[196:199], v2, v74 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1904
		scratch_load_dword v233, off, s47 offset:1908
		scratch_load_dword v234, off, s47 offset:1912
		scratch_load_dword v235, off, s47 offset:1916
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[244:247], v[232:235], v[200:203], v2, v9 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1920
		scratch_load_dword v233, off, s47 offset:1924
		scratch_load_dword v234, off, s47 offset:1928
		scratch_load_dword v235, off, s47 offset:1932
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[244:247], v[232:235], v[204:207], v2, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1936
		scratch_load_dword v233, off, s47 offset:1940
		scratch_load_dword v234, off, s47 offset:1944
		scratch_load_dword v235, off, s47 offset:1948
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[244:247], v[232:235], v[208:211], v2, v15 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1956
		scratch_load_dword v233, off, s47 offset:1960
		scratch_load_dword v234, off, s47 offset:1964
		scratch_load_dword v235, off, s47 offset:1968
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[244:247], v[232:235], v[212:215], v2, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1972
		scratch_load_dword v233, off, s47 offset:1976
		scratch_load_dword v234, off, s47 offset:1980
		scratch_load_dword v235, off, s47 offset:1984
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[244:247], v[232:235], v[216:219], v2, v71 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1988
		scratch_load_dword v233, off, s47 offset:1992
		scratch_load_dword v234, off, s47 offset:1996
		scratch_load_dword v235, off, s47 offset:2000
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[244:247], v[232:235], v[220:223], v2, v71 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:2004
		scratch_load_dword v233, off, s47 offset:2008
		scratch_load_dword v234, off, s47 offset:2012
		scratch_load_dword v235, off, s47 offset:2016
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[244:247], v[232:235], v[224:227], v2, v74 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:2020
		scratch_load_dword v233, off, s47 offset:2024
		scratch_load_dword v234, off, s47 offset:2028
		scratch_load_dword v235, off, s47 offset:2032
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[244:247], v[232:235], v[228:231], v2, v74 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s46, s46, 2
		s_cmp_lt_i32 s46, s11
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:1584
		scratch_load_dword v233, off, s47 offset:1588
		scratch_load_dword v234, off, s47 offset:1592
		scratch_load_dword v235, off, s47 offset:1596
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v32, v232
		v_mov_b32_e32 v33, v233
		v_mov_b32_e32 v34, v234
		v_mov_b32_e32 v35, v235
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:1616
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v16, v1
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:1620
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v18, v1
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:1624
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v17, v1
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:1628
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v68, v1
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:1632
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v69, v1
		s_mov_b32 s47, 0
		scratch_load_dword v1, off, s47 offset:1636
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v70, v1
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_mov_b32 s0, 0
		scratch_store_dword off, v18, s0 offset:1660
		s_mov_b32 s0, 0
		scratch_store_dword off, v16, s0 offset:1656
		s_mov_b32 s0, 0
		scratch_store_dword off, v70, s0 offset:1652
		s_mov_b32 s0, 0
		scratch_store_dword off, v69, s0 offset:1648
		s_mov_b32 s0, 0
		scratch_store_dword off, v68, s0 offset:1644
		s_mov_b32 s0, 0
		scratch_store_dword off, v17, s0 offset:1640
		s_mov_b32 s0, 0
		scratch_store_dword off, v32, s0 offset:1600
		scratch_store_dword off, v33, s0 offset:1604
		scratch_store_dword off, v34, s0 offset:1608
		scratch_store_dword off, v35, s0 offset:1612
		s_mov_b32 s0, 0
		scratch_store_dword off, v64, s0 offset:1552
		scratch_store_dword off, v65, s0 offset:1556
		scratch_store_dword off, v66, s0 offset:1560
		scratch_store_dword off, v67, s0 offset:1564
		s_mov_b32 s0, 0
		scratch_store_dword off, v60, s0 offset:1520
		scratch_store_dword off, v61, s0 offset:1524
		scratch_store_dword off, v62, s0 offset:1528
		scratch_store_dword off, v63, s0 offset:1532
		s_mov_b32 s0, 0
		scratch_store_dword off, v56, s0 offset:1488
		scratch_store_dword off, v57, s0 offset:1492
		scratch_store_dword off, v58, s0 offset:1496
		scratch_store_dword off, v59, s0 offset:1500
		s_mov_b32 s0, 0
		scratch_store_dword off, v52, s0 offset:1456
		scratch_store_dword off, v53, s0 offset:1460
		scratch_store_dword off, v54, s0 offset:1464
		scratch_store_dword off, v55, s0 offset:1468
		s_mov_b32 s0, 0
		scratch_store_dword off, v24, s0 offset:1424
		scratch_store_dword off, v25, s0 offset:1428
		scratch_store_dword off, v26, s0 offset:1432
		scratch_store_dword off, v27, s0 offset:1436
		s_mov_b32 s0, 0
		scratch_store_dword off, v48, s0 offset:1392
		scratch_store_dword off, v49, s0 offset:1396
		scratch_store_dword off, v50, s0 offset:1400
		scratch_store_dword off, v51, s0 offset:1404
		s_mov_b32 s0, 0
		scratch_store_dword off, v44, s0 offset:1344
		scratch_store_dword off, v45, s0 offset:1348
		scratch_store_dword off, v46, s0 offset:1352
		scratch_store_dword off, v47, s0 offset:1356
		s_mov_b32 s0, 0
		scratch_store_dword off, v40, s0 offset:1296
		scratch_store_dword off, v41, s0 offset:1300
		scratch_store_dword off, v42, s0 offset:1304
		scratch_store_dword off, v43, s0 offset:1308
		s_mov_b32 s0, 0
		scratch_store_dword off, v36, s0 offset:1248
		scratch_store_dword off, v37, s0 offset:1252
		scratch_store_dword off, v38, s0 offset:1256
		scratch_store_dword off, v39, s0 offset:1260
		s_mov_b32 s0, 0
		scratch_store_dword off, v20, s0 offset:1160
		scratch_store_dword off, v21, s0 offset:1164
		scratch_store_dword off, v22, s0 offset:1168
		scratch_store_dword off, v23, s0 offset:1172
		s_mov_b32 s0, 0
		scratch_store_dword off, v228, s0 offset:1120
		scratch_store_dword off, v229, s0 offset:1124
		scratch_store_dword off, v230, s0 offset:1128
		scratch_store_dword off, v231, s0 offset:1132
		s_mov_b32 s0, 0
		scratch_store_dword off, v224, s0 offset:1088
		scratch_store_dword off, v225, s0 offset:1092
		scratch_store_dword off, v226, s0 offset:1096
		scratch_store_dword off, v227, s0 offset:1100
		s_mov_b32 s0, 0
		scratch_store_dword off, v220, s0 offset:1056
		scratch_store_dword off, v221, s0 offset:1060
		scratch_store_dword off, v222, s0 offset:1064
		scratch_store_dword off, v223, s0 offset:1068
		s_mov_b32 s0, 0
		scratch_store_dword off, v216, s0 offset:1024
		scratch_store_dword off, v217, s0 offset:1028
		scratch_store_dword off, v218, s0 offset:1032
		scratch_store_dword off, v219, s0 offset:1036
		s_mov_b32 s0, 0
		scratch_store_dword off, v212, s0 offset:992
		scratch_store_dword off, v213, s0 offset:996
		scratch_store_dword off, v214, s0 offset:1000
		scratch_store_dword off, v215, s0 offset:1004
		s_mov_b32 s0, 0
		scratch_store_dword off, v208, s0 offset:960
		scratch_store_dword off, v209, s0 offset:964
		scratch_store_dword off, v210, s0 offset:968
		scratch_store_dword off, v211, s0 offset:972
		s_mov_b32 s0, 0
		scratch_store_dword off, v204, s0 offset:928
		scratch_store_dword off, v205, s0 offset:932
		scratch_store_dword off, v206, s0 offset:936
		scratch_store_dword off, v207, s0 offset:940
		s_mov_b32 s0, 0
		scratch_store_dword off, v200, s0 offset:896
		scratch_store_dword off, v201, s0 offset:900
		scratch_store_dword off, v202, s0 offset:904
		scratch_store_dword off, v203, s0 offset:908
		s_mov_b32 s0, 0
		scratch_store_dword off, v196, s0 offset:864
		scratch_store_dword off, v197, s0 offset:868
		scratch_store_dword off, v198, s0 offset:872
		scratch_store_dword off, v199, s0 offset:876
		s_mov_b32 s0, 0
		scratch_store_dword off, v192, s0 offset:832
		scratch_store_dword off, v193, s0 offset:836
		scratch_store_dword off, v194, s0 offset:840
		scratch_store_dword off, v195, s0 offset:844
		s_mov_b32 s0, 0
		scratch_store_dword off, v188, s0 offset:800
		scratch_store_dword off, v189, s0 offset:804
		scratch_store_dword off, v190, s0 offset:808
		scratch_store_dword off, v191, s0 offset:812
		s_mov_b32 s0, 0
		scratch_store_dword off, v184, s0 offset:768
		scratch_store_dword off, v185, s0 offset:772
		scratch_store_dword off, v186, s0 offset:776
		scratch_store_dword off, v187, s0 offset:780
		s_mov_b32 s0, 0
		scratch_store_dword off, v180, s0 offset:736
		scratch_store_dword off, v181, s0 offset:740
		scratch_store_dword off, v182, s0 offset:744
		scratch_store_dword off, v183, s0 offset:748
		s_mov_b32 s0, 0
		scratch_store_dword off, v176, s0 offset:704
		scratch_store_dword off, v177, s0 offset:708
		scratch_store_dword off, v178, s0 offset:712
		scratch_store_dword off, v179, s0 offset:716
		s_mov_b32 s0, 0
		scratch_store_dword off, v172, s0 offset:672
		scratch_store_dword off, v173, s0 offset:676
		scratch_store_dword off, v174, s0 offset:680
		scratch_store_dword off, v175, s0 offset:684
		s_mov_b32 s0, 0
		scratch_store_dword off, v168, s0 offset:640
		scratch_store_dword off, v169, s0 offset:644
		scratch_store_dword off, v170, s0 offset:648
		scratch_store_dword off, v171, s0 offset:652
		s_mov_b32 s0, 0
		scratch_store_dword off, v164, s0 offset:608
		scratch_store_dword off, v165, s0 offset:612
		scratch_store_dword off, v166, s0 offset:616
		scratch_store_dword off, v167, s0 offset:620
		s_mov_b32 s0, 0
		scratch_store_dword off, v160, s0 offset:576
		scratch_store_dword off, v161, s0 offset:580
		scratch_store_dword off, v162, s0 offset:584
		scratch_store_dword off, v163, s0 offset:588
		s_mov_b32 s0, 0
		scratch_store_dword off, v156, s0 offset:544
		scratch_store_dword off, v157, s0 offset:548
		scratch_store_dword off, v158, s0 offset:552
		scratch_store_dword off, v159, s0 offset:556
		s_mov_b32 s0, 0
		scratch_store_dword off, v152, s0 offset:512
		scratch_store_dword off, v153, s0 offset:516
		scratch_store_dword off, v154, s0 offset:520
		scratch_store_dword off, v155, s0 offset:524
		s_mov_b32 s0, 0
		scratch_store_dword off, v148, s0 offset:480
		scratch_store_dword off, v149, s0 offset:484
		scratch_store_dword off, v150, s0 offset:488
		scratch_store_dword off, v151, s0 offset:492
		s_mov_b32 s0, 0
		scratch_store_dword off, v144, s0 offset:448
		scratch_store_dword off, v145, s0 offset:452
		scratch_store_dword off, v146, s0 offset:456
		scratch_store_dword off, v147, s0 offset:460
		s_mov_b32 s0, 0
		scratch_store_dword off, v140, s0 offset:416
		scratch_store_dword off, v141, s0 offset:420
		scratch_store_dword off, v142, s0 offset:424
		scratch_store_dword off, v143, s0 offset:428
		s_mov_b32 s0, 0
		scratch_store_dword off, v136, s0 offset:384
		scratch_store_dword off, v137, s0 offset:388
		scratch_store_dword off, v138, s0 offset:392
		scratch_store_dword off, v139, s0 offset:396
		s_mov_b32 s0, 0
		scratch_store_dword off, v132, s0 offset:352
		scratch_store_dword off, v133, s0 offset:356
		scratch_store_dword off, v134, s0 offset:360
		scratch_store_dword off, v135, s0 offset:364
		s_mov_b32 s0, 0
		scratch_store_dword off, v128, s0 offset:304
		scratch_store_dword off, v129, s0 offset:308
		scratch_store_dword off, v130, s0 offset:312
		scratch_store_dword off, v131, s0 offset:316
		s_mov_b32 s0, 0
		scratch_store_dword off, v124, s0 offset:272
		scratch_store_dword off, v125, s0 offset:276
		scratch_store_dword off, v126, s0 offset:280
		scratch_store_dword off, v127, s0 offset:284
		s_mov_b32 s0, 0
		scratch_store_dword off, v116, s0 offset:240
		scratch_store_dword off, v117, s0 offset:244
		scratch_store_dword off, v118, s0 offset:248
		scratch_store_dword off, v119, s0 offset:252
		s_mov_b32 s0, 0
		scratch_store_dword off, v104, s0 offset:208
		scratch_store_dword off, v105, s0 offset:212
		scratch_store_dword off, v106, s0 offset:216
		scratch_store_dword off, v107, s0 offset:220
		s_mov_b32 s0, 0
		scratch_store_dword off, v88, s0 offset:176
		scratch_store_dword off, v89, s0 offset:180
		scratch_store_dword off, v90, s0 offset:184
		scratch_store_dword off, v91, s0 offset:188
		s_mov_b32 s0, 0
		scratch_store_dword off, v84, s0 offset:144
		scratch_store_dword off, v85, s0 offset:148
		scratch_store_dword off, v86, s0 offset:152
		scratch_store_dword off, v87, s0 offset:156
		s_mov_b32 s0, 0
		scratch_store_dword off, v4, s0 offset:112
		scratch_store_dword off, v5, s0 offset:116
		scratch_store_dword off, v6, s0 offset:120
		scratch_store_dword off, v7, s0 offset:124
		s_add_i32 s0, s12, -1
		s_mov_b32 s1, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v4, off, s1 offset:112
		scratch_load_dword v5, off, s1 offset:116
		scratch_load_dword v6, off, s1 offset:120
		scratch_load_dword v7, off, s1 offset:124
		s_mov_b32 s1, 0
		scratch_load_dword v8, off, s1 offset:1160
		scratch_load_dword v9, off, s1 offset:1164
		scratch_load_dword v10, off, s1 offset:1168
		scratch_load_dword v11, off, s1 offset:1172
		s_mov_b32 s1, 0
		scratch_load_dword v12, off, s1 offset:1248
		scratch_load_dword v13, off, s1 offset:1252
		scratch_load_dword v14, off, s1 offset:1256
		scratch_load_dword v15, off, s1 offset:1260
		s_mov_b32 s1, 0
		scratch_load_dword v1, off, s1 offset:1640
		s_mov_b32 s1, 0
		scratch_load_dword v2, off, s1 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[8:11], v[12:15], v[4:7], v2, v1 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s1, s0, 1
		s_lshl_b32 s0, s1, 16
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x26800, v1
		ds_read_b32 v1, v2
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v2, s0, v1
		s_mov_b32 s1, 0
		scratch_load_dword v1, off, s1 offset:1136
		s_mov_b32 s1, 0
		scratch_load_dword v3, off, s1 offset:1140
		s_waitcnt vmcnt(0)
		v_add3_u32 v8, v2, v1, v3
		ds_read_b128 v[12:15], v8 offset:16384
		s_mov_b32 s1, 0
		scratch_load_dword v16, off, s1 offset:144
		scratch_load_dword v17, off, s1 offset:148
		scratch_load_dword v18, off, s1 offset:152
		scratch_load_dword v19, off, s1 offset:156
		s_mov_b32 s1, 0
		scratch_load_dword v20, off, s1 offset:1160
		scratch_load_dword v21, off, s1 offset:1164
		scratch_load_dword v22, off, s1 offset:1168
		scratch_load_dword v23, off, s1 offset:1172
		s_mov_b32 s1, 0
		scratch_load_dword v24, off, s1 offset:1296
		scratch_load_dword v25, off, s1 offset:1300
		scratch_load_dword v26, off, s1 offset:1304
		scratch_load_dword v27, off, s1 offset:1308
		s_mov_b32 s1, 0
		scratch_load_dword v1, off, s1 offset:1640
		s_mov_b32 s1, 0
		scratch_load_dword v2, off, s1 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[20:23], v[24:27], v[16:19], v2, v1 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v8 offset:17408
		s_mov_b32 s1, 0
		scratch_load_dword v24, off, s1 offset:176
		scratch_load_dword v25, off, s1 offset:180
		scratch_load_dword v26, off, s1 offset:184
		scratch_load_dword v27, off, s1 offset:188
		s_mov_b32 s1, 0
		scratch_load_dword v32, off, s1 offset:1160
		scratch_load_dword v33, off, s1 offset:1164
		scratch_load_dword v34, off, s1 offset:1168
		scratch_load_dword v35, off, s1 offset:1172
		s_mov_b32 s1, 0
		scratch_load_dword v36, off, s1 offset:1344
		scratch_load_dword v37, off, s1 offset:1348
		scratch_load_dword v38, off, s1 offset:1352
		scratch_load_dword v39, off, s1 offset:1356
		s_mov_b32 s1, 0
		scratch_load_dword v1, off, s1 offset:1644
		s_mov_b32 s1, 0
		scratch_load_dword v2, off, s1 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[24:27], v[32:35], v[36:39], v[24:27], v2, v1 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[32:35], v8 offset:18432
		s_mov_b32 s1, 0
		scratch_load_dword v36, off, s1 offset:208
		scratch_load_dword v37, off, s1 offset:212
		scratch_load_dword v38, off, s1 offset:216
		scratch_load_dword v39, off, s1 offset:220
		s_mov_b32 s1, 0
		scratch_load_dword v40, off, s1 offset:1160
		scratch_load_dword v41, off, s1 offset:1164
		scratch_load_dword v42, off, s1 offset:1168
		scratch_load_dword v43, off, s1 offset:1172
		s_mov_b32 s1, 0
		scratch_load_dword v44, off, s1 offset:1392
		scratch_load_dword v45, off, s1 offset:1396
		scratch_load_dword v46, off, s1 offset:1400
		scratch_load_dword v47, off, s1 offset:1404
		s_mov_b32 s1, 0
		scratch_load_dword v1, off, s1 offset:1644
		s_mov_b32 s1, 0
		scratch_load_dword v2, off, s1 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], v[40:43], v[44:47], v[36:39], v2, v1 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[40:43], v8 offset:19456
		s_mov_b32 s1, 0
		scratch_load_dword v8, off, s1 offset:240
		scratch_load_dword v9, off, s1 offset:244
		scratch_load_dword v10, off, s1 offset:248
		scratch_load_dword v11, off, s1 offset:252
		s_mov_b32 s1, 0
		scratch_load_dword v44, off, s1 offset:1160
		scratch_load_dword v45, off, s1 offset:1164
		scratch_load_dword v46, off, s1 offset:1168
		scratch_load_dword v47, off, s1 offset:1172
		s_mov_b32 s1, 0
		scratch_load_dword v48, off, s1 offset:1456
		scratch_load_dword v49, off, s1 offset:1460
		scratch_load_dword v50, off, s1 offset:1464
		scratch_load_dword v51, off, s1 offset:1468
		s_mov_b32 s1, 0
		scratch_load_dword v1, off, s1 offset:1648
		s_mov_b32 s1, 0
		scratch_load_dword v2, off, s1 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[44:47], v[48:51], v[8:11], v2, v1 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s1, 0
		scratch_load_dword v1, off, s1 offset:1136
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v2, s0, v1
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:92
		s_mov_b32 s0, 0
		scratch_load_dword v3, off, s0 offset:1140
		s_waitcnt vmcnt(0)
		v_add3_u32 v44, v2, v1, v3
		ds_read_b128 v[48:51], v44 offset:49152
		s_mov_b32 s0, 0
		scratch_load_dword v52, off, s0 offset:272
		scratch_load_dword v53, off, s0 offset:276
		scratch_load_dword v54, off, s0 offset:280
		scratch_load_dword v55, off, s0 offset:284
		s_mov_b32 s0, 0
		scratch_load_dword v56, off, s0 offset:1160
		scratch_load_dword v57, off, s0 offset:1164
		scratch_load_dword v58, off, s0 offset:1168
		scratch_load_dword v59, off, s0 offset:1172
		s_mov_b32 s0, 0
		scratch_load_dword v60, off, s0 offset:1488
		scratch_load_dword v61, off, s0 offset:1492
		scratch_load_dword v62, off, s0 offset:1496
		scratch_load_dword v63, off, s0 offset:1500
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1648
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], v[56:59], v[60:63], v[52:55], v2, v1 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[56:59], v44 offset:50176
		s_mov_b32 s0, 0
		scratch_load_dword v60, off, s0 offset:304
		scratch_load_dword v61, off, s0 offset:308
		scratch_load_dword v62, off, s0 offset:312
		scratch_load_dword v63, off, s0 offset:316
		s_mov_b32 s0, 0
		scratch_load_dword v64, off, s0 offset:1160
		scratch_load_dword v65, off, s0 offset:1164
		scratch_load_dword v66, off, s0 offset:1168
		scratch_load_dword v67, off, s0 offset:1172
		s_mov_b32 s0, 0
		scratch_load_dword v68, off, s0 offset:1520
		scratch_load_dword v69, off, s0 offset:1524
		scratch_load_dword v70, off, s0 offset:1528
		scratch_load_dword v71, off, s0 offset:1532
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1652
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[64:67], v[68:71], v[60:63], v2, v1 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[64:67], v44 offset:51200
		s_mov_b32 s0, 0
		scratch_load_dword v68, off, s0 offset:352
		scratch_load_dword v69, off, s0 offset:356
		scratch_load_dword v70, off, s0 offset:360
		scratch_load_dword v71, off, s0 offset:364
		s_mov_b32 s0, 0
		scratch_load_dword v72, off, s0 offset:1160
		scratch_load_dword v73, off, s0 offset:1164
		scratch_load_dword v74, off, s0 offset:1168
		scratch_load_dword v75, off, s0 offset:1172
		s_mov_b32 s0, 0
		scratch_load_dword v76, off, s0 offset:1552
		scratch_load_dword v77, off, s0 offset:1556
		scratch_load_dword v78, off, s0 offset:1560
		scratch_load_dword v79, off, s0 offset:1564
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1652
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[72:75], v[76:79], v[68:71], v2, v1 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[72:75], v44 offset:52224
		s_mov_b32 s0, 0
		scratch_load_dword v76, off, s0 offset:384
		scratch_load_dword v77, off, s0 offset:388
		scratch_load_dword v78, off, s0 offset:392
		scratch_load_dword v79, off, s0 offset:396
		s_mov_b32 s0, 0
		scratch_load_dword v80, off, s0 offset:1248
		scratch_load_dword v81, off, s0 offset:1252
		scratch_load_dword v82, off, s0 offset:1256
		scratch_load_dword v83, off, s0 offset:1260
		s_mov_b32 s0, 0
		scratch_load_dword v84, off, s0 offset:1424
		scratch_load_dword v85, off, s0 offset:1428
		scratch_load_dword v86, off, s0 offset:1432
		scratch_load_dword v87, off, s0 offset:1436
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1640
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[84:87], v[80:83], v[76:79], v2, v1 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[80:83], v44 offset:53248
		s_mov_b32 s0, 0
		scratch_load_dword v84, off, s0 offset:416
		scratch_load_dword v85, off, s0 offset:420
		scratch_load_dword v86, off, s0 offset:424
		scratch_load_dword v87, off, s0 offset:428
		s_mov_b32 s0, 0
		scratch_load_dword v88, off, s0 offset:1296
		scratch_load_dword v89, off, s0 offset:1300
		scratch_load_dword v90, off, s0 offset:1304
		scratch_load_dword v91, off, s0 offset:1308
		s_mov_b32 s0, 0
		scratch_load_dword v92, off, s0 offset:1424
		scratch_load_dword v93, off, s0 offset:1428
		scratch_load_dword v94, off, s0 offset:1432
		scratch_load_dword v95, off, s0 offset:1436
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1640
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[92:95], v[88:91], v[84:87], v2, v1 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v44 offset:54272
		s_mov_b32 s0, 0
		scratch_load_dword v92, off, s0 offset:448
		scratch_load_dword v93, off, s0 offset:452
		scratch_load_dword v94, off, s0 offset:456
		scratch_load_dword v95, off, s0 offset:460
		s_mov_b32 s0, 0
		scratch_load_dword v96, off, s0 offset:1344
		scratch_load_dword v97, off, s0 offset:1348
		scratch_load_dword v98, off, s0 offset:1352
		scratch_load_dword v99, off, s0 offset:1356
		s_mov_b32 s0, 0
		scratch_load_dword v100, off, s0 offset:1424
		scratch_load_dword v101, off, s0 offset:1428
		scratch_load_dword v102, off, s0 offset:1432
		scratch_load_dword v103, off, s0 offset:1436
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1644
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[100:103], v[96:99], v[92:95], v2, v1 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v44 offset:55296
		s_mov_b32 s0, 0
		scratch_load_dword v100, off, s0 offset:480
		scratch_load_dword v101, off, s0 offset:484
		scratch_load_dword v102, off, s0 offset:488
		scratch_load_dword v103, off, s0 offset:492
		s_mov_b32 s0, 0
		scratch_load_dword v104, off, s0 offset:1392
		scratch_load_dword v105, off, s0 offset:1396
		scratch_load_dword v106, off, s0 offset:1400
		scratch_load_dword v107, off, s0 offset:1404
		s_mov_b32 s0, 0
		scratch_load_dword v108, off, s0 offset:1424
		scratch_load_dword v109, off, s0 offset:1428
		scratch_load_dword v110, off, s0 offset:1432
		scratch_load_dword v111, off, s0 offset:1436
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1644
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[108:111], v[104:107], v[100:103], v2, v1 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[104:107], v44 offset:56320
		s_mov_b32 s0, 0
		scratch_load_dword v44, off, s0 offset:512
		scratch_load_dword v45, off, s0 offset:516
		scratch_load_dword v46, off, s0 offset:520
		scratch_load_dword v47, off, s0 offset:524
		s_mov_b32 s0, 0
		scratch_load_dword v108, off, s0 offset:1424
		scratch_load_dword v109, off, s0 offset:1428
		scratch_load_dword v110, off, s0 offset:1432
		scratch_load_dword v111, off, s0 offset:1436
		s_mov_b32 s0, 0
		scratch_load_dword v112, off, s0 offset:1456
		scratch_load_dword v113, off, s0 offset:1460
		scratch_load_dword v114, off, s0 offset:1464
		scratch_load_dword v115, off, s0 offset:1468
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1648
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[108:111], v[112:115], v[44:47], v2, v1 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v108, off, s0 offset:544
		scratch_load_dword v109, off, s0 offset:548
		scratch_load_dword v110, off, s0 offset:552
		scratch_load_dword v111, off, s0 offset:556
		s_mov_b32 s0, 0
		scratch_load_dword v112, off, s0 offset:1424
		scratch_load_dword v113, off, s0 offset:1428
		scratch_load_dword v114, off, s0 offset:1432
		scratch_load_dword v115, off, s0 offset:1436
		s_mov_b32 s0, 0
		scratch_load_dword v116, off, s0 offset:1488
		scratch_load_dword v117, off, s0 offset:1492
		scratch_load_dword v118, off, s0 offset:1496
		scratch_load_dword v119, off, s0 offset:1500
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1648
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[112:115], v[116:119], v[108:111], v2, v1 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v112, off, s0 offset:576
		scratch_load_dword v113, off, s0 offset:580
		scratch_load_dword v114, off, s0 offset:584
		scratch_load_dword v115, off, s0 offset:588
		s_mov_b32 s0, 0
		scratch_load_dword v116, off, s0 offset:1424
		scratch_load_dword v117, off, s0 offset:1428
		scratch_load_dword v118, off, s0 offset:1432
		scratch_load_dword v119, off, s0 offset:1436
		s_mov_b32 s0, 0
		scratch_load_dword v120, off, s0 offset:1520
		scratch_load_dword v121, off, s0 offset:1524
		scratch_load_dword v122, off, s0 offset:1528
		scratch_load_dword v123, off, s0 offset:1532
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1652
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[116:119], v[120:123], v[112:115], v2, v1 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v116, off, s0 offset:608
		scratch_load_dword v117, off, s0 offset:612
		scratch_load_dword v118, off, s0 offset:616
		scratch_load_dword v119, off, s0 offset:620
		s_mov_b32 s0, 0
		scratch_load_dword v120, off, s0 offset:1424
		scratch_load_dword v121, off, s0 offset:1428
		scratch_load_dword v122, off, s0 offset:1432
		scratch_load_dword v123, off, s0 offset:1436
		s_mov_b32 s0, 0
		scratch_load_dword v124, off, s0 offset:1552
		scratch_load_dword v125, off, s0 offset:1556
		scratch_load_dword v126, off, s0 offset:1560
		scratch_load_dword v127, off, s0 offset:1564
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1652
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[120:123], v[124:127], v[116:119], v2, v1 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v120, off, s0 offset:640
		scratch_load_dword v121, off, s0 offset:644
		scratch_load_dword v122, off, s0 offset:648
		scratch_load_dword v123, off, s0 offset:652
		s_mov_b32 s0, 0
		scratch_load_dword v124, off, s0 offset:1248
		scratch_load_dword v125, off, s0 offset:1252
		scratch_load_dword v126, off, s0 offset:1256
		scratch_load_dword v127, off, s0 offset:1260
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1640
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[28:31], v[124:127], v[120:123], v2, v1 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v124, off, s0 offset:672
		scratch_load_dword v125, off, s0 offset:676
		scratch_load_dword v126, off, s0 offset:680
		scratch_load_dword v127, off, s0 offset:684
		s_mov_b32 s0, 0
		scratch_load_dword v128, off, s0 offset:1296
		scratch_load_dword v129, off, s0 offset:1300
		scratch_load_dword v130, off, s0 offset:1304
		scratch_load_dword v131, off, s0 offset:1308
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1640
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[28:31], v[128:131], v[124:127], v2, v1 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v128, off, s0 offset:704
		scratch_load_dword v129, off, s0 offset:708
		scratch_load_dword v130, off, s0 offset:712
		scratch_load_dword v131, off, s0 offset:716
		s_mov_b32 s0, 0
		scratch_load_dword v132, off, s0 offset:1344
		scratch_load_dword v133, off, s0 offset:1348
		scratch_load_dword v134, off, s0 offset:1352
		scratch_load_dword v135, off, s0 offset:1356
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1644
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[28:31], v[132:135], v[128:131], v2, v1 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v132, off, s0 offset:736
		scratch_load_dword v133, off, s0 offset:740
		scratch_load_dword v134, off, s0 offset:744
		scratch_load_dword v135, off, s0 offset:748
		s_mov_b32 s0, 0
		scratch_load_dword v136, off, s0 offset:1392
		scratch_load_dword v137, off, s0 offset:1396
		scratch_load_dword v138, off, s0 offset:1400
		scratch_load_dword v139, off, s0 offset:1404
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1644
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[28:31], v[136:139], v[132:135], v2, v1 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v136, off, s0 offset:768
		scratch_load_dword v137, off, s0 offset:772
		scratch_load_dword v138, off, s0 offset:776
		scratch_load_dword v139, off, s0 offset:780
		s_mov_b32 s0, 0
		scratch_load_dword v140, off, s0 offset:1456
		scratch_load_dword v141, off, s0 offset:1460
		scratch_load_dword v142, off, s0 offset:1464
		scratch_load_dword v143, off, s0 offset:1468
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1648
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[28:31], v[140:143], v[136:139], v2, v1 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v140, off, s0 offset:800
		scratch_load_dword v141, off, s0 offset:804
		scratch_load_dword v142, off, s0 offset:808
		scratch_load_dword v143, off, s0 offset:812
		s_mov_b32 s0, 0
		scratch_load_dword v144, off, s0 offset:1488
		scratch_load_dword v145, off, s0 offset:1492
		scratch_load_dword v146, off, s0 offset:1496
		scratch_load_dword v147, off, s0 offset:1500
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1648
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[28:31], v[144:147], v[140:143], v2, v1 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v144, off, s0 offset:832
		scratch_load_dword v145, off, s0 offset:836
		scratch_load_dword v146, off, s0 offset:840
		scratch_load_dword v147, off, s0 offset:844
		s_mov_b32 s0, 0
		scratch_load_dword v148, off, s0 offset:1520
		scratch_load_dword v149, off, s0 offset:1524
		scratch_load_dword v150, off, s0 offset:1528
		scratch_load_dword v151, off, s0 offset:1532
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1652
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[28:31], v[148:151], v[144:147], v2, v1 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v148, off, s0 offset:864
		scratch_load_dword v149, off, s0 offset:868
		scratch_load_dword v150, off, s0 offset:872
		scratch_load_dword v151, off, s0 offset:876
		s_mov_b32 s0, 0
		scratch_load_dword v152, off, s0 offset:1552
		scratch_load_dword v153, off, s0 offset:1556
		scratch_load_dword v154, off, s0 offset:1560
		scratch_load_dword v155, off, s0 offset:1564
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1652
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[28:31], v[152:155], v[148:151], v2, v1 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v28, off, s0 offset:896
		scratch_load_dword v29, off, s0 offset:900
		scratch_load_dword v30, off, s0 offset:904
		scratch_load_dword v31, off, s0 offset:908
		s_mov_b32 s0, 0
		scratch_load_dword v152, off, s0 offset:1248
		scratch_load_dword v153, off, s0 offset:1252
		scratch_load_dword v154, off, s0 offset:1256
		scratch_load_dword v155, off, s0 offset:1260
		s_mov_b32 s0, 0
		scratch_load_dword v156, off, s0 offset:1600
		scratch_load_dword v157, off, s0 offset:1604
		scratch_load_dword v158, off, s0 offset:1608
		scratch_load_dword v159, off, s0 offset:1612
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1640
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], v[156:159], v[152:155], v[28:31], v2, v1 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v152, off, s0 offset:928
		scratch_load_dword v153, off, s0 offset:932
		scratch_load_dword v154, off, s0 offset:936
		scratch_load_dword v155, off, s0 offset:940
		s_mov_b32 s0, 0
		scratch_load_dword v156, off, s0 offset:1296
		scratch_load_dword v157, off, s0 offset:1300
		scratch_load_dword v158, off, s0 offset:1304
		scratch_load_dword v159, off, s0 offset:1308
		s_mov_b32 s0, 0
		scratch_load_dword v160, off, s0 offset:1600
		scratch_load_dword v161, off, s0 offset:1604
		scratch_load_dword v162, off, s0 offset:1608
		scratch_load_dword v163, off, s0 offset:1612
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1640
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[160:163], v[156:159], v[152:155], v2, v1 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v156, off, s0 offset:960
		scratch_load_dword v157, off, s0 offset:964
		scratch_load_dword v158, off, s0 offset:968
		scratch_load_dword v159, off, s0 offset:972
		s_mov_b32 s0, 0
		scratch_load_dword v160, off, s0 offset:1344
		scratch_load_dword v161, off, s0 offset:1348
		scratch_load_dword v162, off, s0 offset:1352
		scratch_load_dword v163, off, s0 offset:1356
		s_mov_b32 s0, 0
		scratch_load_dword v164, off, s0 offset:1600
		scratch_load_dword v165, off, s0 offset:1604
		scratch_load_dword v166, off, s0 offset:1608
		scratch_load_dword v167, off, s0 offset:1612
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1644
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[164:167], v[160:163], v[156:159], v2, v1 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v160, off, s0 offset:992
		scratch_load_dword v161, off, s0 offset:996
		scratch_load_dword v162, off, s0 offset:1000
		scratch_load_dword v163, off, s0 offset:1004
		s_mov_b32 s0, 0
		scratch_load_dword v164, off, s0 offset:1392
		scratch_load_dword v165, off, s0 offset:1396
		scratch_load_dword v166, off, s0 offset:1400
		scratch_load_dword v167, off, s0 offset:1404
		s_mov_b32 s0, 0
		scratch_load_dword v168, off, s0 offset:1600
		scratch_load_dword v169, off, s0 offset:1604
		scratch_load_dword v170, off, s0 offset:1608
		scratch_load_dword v171, off, s0 offset:1612
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1644
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[168:171], v[164:167], v[160:163], v2, v1 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v164, off, s0 offset:1024
		scratch_load_dword v165, off, s0 offset:1028
		scratch_load_dword v166, off, s0 offset:1032
		scratch_load_dword v167, off, s0 offset:1036
		s_mov_b32 s0, 0
		scratch_load_dword v168, off, s0 offset:1456
		scratch_load_dword v169, off, s0 offset:1460
		scratch_load_dword v170, off, s0 offset:1464
		scratch_load_dword v171, off, s0 offset:1468
		s_mov_b32 s0, 0
		scratch_load_dword v172, off, s0 offset:1600
		scratch_load_dword v173, off, s0 offset:1604
		scratch_load_dword v174, off, s0 offset:1608
		scratch_load_dword v175, off, s0 offset:1612
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1648
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[172:175], v[168:171], v[164:167], v2, v1 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v168, off, s0 offset:1056
		scratch_load_dword v169, off, s0 offset:1060
		scratch_load_dword v170, off, s0 offset:1064
		scratch_load_dword v171, off, s0 offset:1068
		s_mov_b32 s0, 0
		scratch_load_dword v172, off, s0 offset:1488
		scratch_load_dword v173, off, s0 offset:1492
		scratch_load_dword v174, off, s0 offset:1496
		scratch_load_dword v175, off, s0 offset:1500
		s_mov_b32 s0, 0
		scratch_load_dword v176, off, s0 offset:1600
		scratch_load_dword v177, off, s0 offset:1604
		scratch_load_dword v178, off, s0 offset:1608
		scratch_load_dword v179, off, s0 offset:1612
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1648
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[176:179], v[172:175], v[168:171], v2, v1 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v172, off, s0 offset:1088
		scratch_load_dword v173, off, s0 offset:1092
		scratch_load_dword v174, off, s0 offset:1096
		scratch_load_dword v175, off, s0 offset:1100
		s_mov_b32 s0, 0
		scratch_load_dword v176, off, s0 offset:1520
		scratch_load_dword v177, off, s0 offset:1524
		scratch_load_dword v178, off, s0 offset:1528
		scratch_load_dword v179, off, s0 offset:1532
		s_mov_b32 s0, 0
		scratch_load_dword v180, off, s0 offset:1600
		scratch_load_dword v181, off, s0 offset:1604
		scratch_load_dword v182, off, s0 offset:1608
		scratch_load_dword v183, off, s0 offset:1612
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1652
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[180:183], v[176:179], v[172:175], v2, v1 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v176, off, s0 offset:1120
		scratch_load_dword v177, off, s0 offset:1124
		scratch_load_dword v178, off, s0 offset:1128
		scratch_load_dword v179, off, s0 offset:1132
		s_mov_b32 s0, 0
		scratch_load_dword v180, off, s0 offset:1552
		scratch_load_dword v181, off, s0 offset:1556
		scratch_load_dword v182, off, s0 offset:1560
		scratch_load_dword v183, off, s0 offset:1564
		s_mov_b32 s0, 0
		scratch_load_dword v184, off, s0 offset:1600
		scratch_load_dword v185, off, s0 offset:1604
		scratch_load_dword v186, off, s0 offset:1608
		scratch_load_dword v187, off, s0 offset:1612
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1652
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[184:187], v[180:183], v[176:179], v2, v1 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1640
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[12:15], v[48:51], v[4:7], v2, v1 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1640
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[12:15], v[56:59], v[16:19], v2, v1 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1644
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[24:27], v[12:15], v[64:67], v[24:27], v2, v1 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1644
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], v[12:15], v[72:75], v[36:39], v2, v1 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1648
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[12:15], v[80:83], v[8:11], v2, v1 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1648
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], v[12:15], v[88:91], v[52:55], v2, v1 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1652
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[12:15], v[96:99], v[60:63], v2, v1 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1652
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[12:15], v[104:107], v[68:71], v2, v1 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1640
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[20:23], v[48:51], v[76:79], v2, v1 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1640
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[20:23], v[56:59], v[84:87], v2, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1644
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[20:23], v[64:67], v[92:95], v2, v1 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1644
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[20:23], v[72:75], v[100:103], v2, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1648
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[20:23], v[80:83], v[44:47], v2, v1 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1648
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[20:23], v[88:91], v[108:111], v2, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1652
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[20:23], v[96:99], v[112:115], v2, v1 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1652
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1656
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[20:23], v[104:107], v[116:119], v2, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1640
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[32:35], v[48:51], v[120:123], v2, v1 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1640
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[32:35], v[56:59], v[124:127], v2, v1 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1644
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[32:35], v[64:67], v[128:131], v2, v1 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1644
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[32:35], v[72:75], v[132:135], v2, v1 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1648
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[32:35], v[80:83], v[136:139], v2, v1 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1648
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[32:35], v[88:91], v[140:143], v2, v1 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1652
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[32:35], v[96:99], v[144:147], v2, v1 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1652
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[32:35], v[104:107], v[148:151], v2, v1 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1640
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], v[40:43], v[48:51], v[28:31], v2, v1 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1640
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[40:43], v[56:59], v[152:155], v2, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1644
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[40:43], v[64:67], v[156:159], v2, v1 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1644
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[40:43], v[72:75], v[160:163], v2, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1648
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[40:43], v[80:83], v[164:167], v2, v1 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1648
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[40:43], v[88:91], v[168:171], v2, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1652
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[40:43], v[96:99], v[172:175], v2, v1 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:1652
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:1660
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[40:43], v[104:107], v[176:179], v2, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s0, s12, 1
		s_lshl_b32 s1, s0, 16
		v_lshlrev_b32_e32 v1, 2, v0
		v_add_u32_e32 v2, 0x26800, v1
		ds_read_b32 v1, v2
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v2, s1, v1
		s_mov_b32 s2, 0
		scratch_load_dword v1, off, s2 offset:1136
		s_mov_b32 s2, 0
		scratch_load_dword v3, off, s2 offset:1140
		s_waitcnt vmcnt(0)
		v_add3_u32 v12, v2, v1, v3
		ds_read_b128 v[20:23], v12
		ds_read_b128 v[32:35], v12 offset:1024
		ds_read_b128 v[40:43], v12 offset:2048
		ds_read_b128 v[48:51], v12 offset:3072
		s_mov_b32 s2, 0
		scratch_load_dword v1, off, s2 offset:1136
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v2, s1, v1
		s_mov_b32 s1, 0
		scratch_load_dword v1, off, s1 offset:92
		s_mov_b32 s1, 0
		scratch_load_dword v3, off, s1 offset:1140
		s_waitcnt vmcnt(0)
		v_add3_u32 v13, v2, v1, v3
		ds_read_b128 v[56:59], v13 offset:32768
		ds_read_b128 v[64:67], v13 offset:33792
		ds_read_b128 v[72:75], v13 offset:34816
		ds_read_b128 v[80:83], v13 offset:35840
		ds_read_b128 v[88:91], v13 offset:36864
		ds_read_b128 v[96:99], v13 offset:37888
		ds_read_b128 v[104:107], v13 offset:38912
		ds_read_b128 v[180:183], v13 offset:39936
		s_lshl_b32 s1, s0, 12
		s_add_i32 s0, s1, 0x20000
		s_mov_b32 s1, 0
		scratch_load_dword v1, off, s1 offset:104
		s_mov_b32 s1, 0
		scratch_load_dword v2, off, s1 offset:1184
		s_waitcnt vmcnt(0)
		v_add3_u32 v3, s0, v1, v2
		ds_read_b32 v1, v3
		ds_read_b32 v2, v3 offset:256
		s_mov_b32 s1, 0
		scratch_load_dword v3, off, s1 offset:108
		s_mov_b32 s1, 0
		scratch_load_dword v14, off, s1 offset:1184
		s_waitcnt vmcnt(0)
		v_add3_u32 v15, s0, v14, v3
		ds_read_b32 v3, v15 offset:2048
		ds_read_b32 v14, v15 offset:2304
		ds_read_b32 v184, v15 offset:2560
		ds_read_b32 v185, v15 offset:2816
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[20:23], v[56:59], v[4:7], v1, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[188:191], v12 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[20:23], v[64:67], v[16:19], v1, v3 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[192:195], v12 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[24:27], v[20:23], v[72:75], v[24:27], v1, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[196:199], v12 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], v[20:23], v[80:83], v[36:39], v1, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[200:203], v12 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[20:23], v[88:91], v[8:11], v1, v184 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[204:207], v13 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], v[20:23], v[96:99], v[52:55], v1, v184 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[208:211], v13 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[20:23], v[104:107], v[60:63], v1, v185 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[212:215], v13 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[20:23], v[180:183], v[68:71], v1, v185 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v13 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[32:35], v[56:59], v[76:79], v1, v3 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v13 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[32:35], v[64:67], v[84:87], v1, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v13 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[32:35], v[72:75], v[92:95], v1, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v13 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[32:35], v[80:83], v[100:103], v1, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v13 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[32:35], v[88:91], v[44:47], v1, v184 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[32:35], v[96:99], v[108:111], v1, v184 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[32:35], v[104:107], v[112:115], v1, v185 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[32:35], v[180:183], v[116:119], v1, v185 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[40:43], v[56:59], v[120:123], v2, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[40:43], v[64:67], v[124:127], v2, v3 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[40:43], v[72:75], v[128:131], v2, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[40:43], v[80:83], v[132:135], v2, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[40:43], v[88:91], v[136:139], v2, v184 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[40:43], v[96:99], v[140:143], v2, v184 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[40:43], v[104:107], v[144:147], v2, v185 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[40:43], v[180:183], v[148:151], v2, v185 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], v[48:51], v[56:59], v[28:31], v2, v3 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[48:51], v[64:67], v[152:155], v2, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[48:51], v[72:75], v[156:159], v2, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[48:51], v[80:83], v[160:163], v2, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[48:51], v[88:91], v[164:167], v2, v184 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[48:51], v[96:99], v[168:171], v2, v184 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[48:51], v[104:107], v[172:175], v2, v185 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[48:51], v[180:183], v[176:179], v2, v185 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[188:191], v[204:207], v[4:7], v1, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[16:19], v[188:191], v[208:211], v[16:19], v1, v3 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[24:27], v[188:191], v[212:215], v[24:27], v1, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[36:39], v[188:191], v[20:23], v[36:39], v1, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[188:191], v[216:219], v[8:11], v1, v184 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[52:55], v[188:191], v[220:223], v[52:55], v1, v184 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[60:63], v[188:191], v[224:227], v[60:63], v1, v185 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[188:191], v[228:231], v[68:71], v1, v185 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[192:195], v[204:207], v[76:79], v1, v3 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[192:195], v[208:211], v[84:87], v1, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[192:195], v[212:215], v[92:95], v1, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[192:195], v[20:23], v[100:103], v1, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[44:47], v[192:195], v[216:219], v[44:47], v1, v184 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[192:195], v[220:223], v[108:111], v1, v184 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[192:195], v[224:227], v[112:115], v1, v185 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[192:195], v[228:231], v[116:119], v1, v185 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[196:199], v[204:207], v[120:123], v2, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[196:199], v[208:211], v[124:127], v2, v3 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[196:199], v[212:215], v[128:131], v2, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[196:199], v[20:23], v[132:135], v2, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[196:199], v[216:219], v[136:139], v2, v184 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[196:199], v[220:223], v[140:143], v2, v184 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[196:199], v[224:227], v[144:147], v2, v185 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[196:199], v[228:231], v[148:151], v2, v185 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[28:31], v[200:203], v[204:207], v[28:31], v2, v3 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[200:203], v[208:211], v[152:155], v2, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[200:203], v[212:215], v[156:159], v2, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[200:203], v[20:23], v[160:163], v2, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[200:203], v[216:219], v[164:167], v2, v184 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[200:203], v[220:223], v[168:171], v2, v184 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[200:203], v[224:227], v[172:175], v2, v185 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[200:203], v[228:231], v[176:179], v2, v185 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
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
		v_cvt_pk_f16_f32 v2, v16, v17
		v_cvt_pk_f16_f32 v3, v18, v19
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:512
		v_cvt_pk_f16_f32 v2, v24, v25
		v_cvt_pk_f16_f32 v3, v26, v27
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:1024
		v_cvt_pk_f16_f32 v2, v36, v37
		v_cvt_pk_f16_f32 v3, v38, v39
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:1536
		v_cvt_pk_f16_f32 v2, v8, v9
		v_cvt_pk_f16_f32 v3, v10, v11
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:2048
		v_cvt_pk_f16_f32 v2, v52, v53
		v_cvt_pk_f16_f32 v3, v54, v55
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:2560
		v_cvt_pk_f16_f32 v2, v60, v61
		v_cvt_pk_f16_f32 v3, v62, v63
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:3072
		v_cvt_pk_f16_f32 v2, v68, v69
		v_cvt_pk_f16_f32 v3, v70, v71
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:3584
		v_cvt_pk_f16_f32 v2, v76, v77
		v_cvt_pk_f16_f32 v3, v78, v79
		s_add_i32 s2, s0, 0x1000
		s_add_i32 s3, s2, s1
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen
		v_cvt_pk_f16_f32 v2, v84, v85
		v_cvt_pk_f16_f32 v3, v86, v87
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen offset:512
		v_cvt_pk_f16_f32 v2, v92, v93
		v_cvt_pk_f16_f32 v3, v94, v95
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen offset:1024
		v_cvt_pk_f16_f32 v2, v100, v101
		v_cvt_pk_f16_f32 v3, v102, v103
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen offset:1536
		v_cvt_pk_f16_f32 v2, v44, v45
		v_cvt_pk_f16_f32 v3, v46, v47
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen offset:2048
		v_cvt_pk_f16_f32 v2, v108, v109
		v_cvt_pk_f16_f32 v3, v110, v111
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen offset:2560
		v_cvt_pk_f16_f32 v2, v112, v113
		v_cvt_pk_f16_f32 v3, v114, v115
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen offset:3072
		v_cvt_pk_f16_f32 v2, v116, v117
		v_cvt_pk_f16_f32 v3, v118, v119
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen offset:3584
		v_cvt_pk_f16_f32 v2, v120, v121
		v_cvt_pk_f16_f32 v3, v122, v123
		s_add_i32 s2, s0, 0x2000
		s_add_i32 s3, s2, s1
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen
		v_cvt_pk_f16_f32 v2, v124, v125
		v_cvt_pk_f16_f32 v3, v126, v127
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen offset:512
		v_cvt_pk_f16_f32 v2, v128, v129
		v_cvt_pk_f16_f32 v3, v130, v131
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen offset:1024
		v_cvt_pk_f16_f32 v2, v132, v133
		v_cvt_pk_f16_f32 v3, v134, v135
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen offset:1536
		v_cvt_pk_f16_f32 v2, v136, v137
		v_cvt_pk_f16_f32 v3, v138, v139
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen offset:2048
		v_cvt_pk_f16_f32 v2, v140, v141
		v_cvt_pk_f16_f32 v3, v142, v143
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen offset:2560
		v_cvt_pk_f16_f32 v2, v144, v145
		v_cvt_pk_f16_f32 v3, v146, v147
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen offset:3072
		v_cvt_pk_f16_f32 v2, v148, v149
		v_cvt_pk_f16_f32 v3, v150, v151
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s3 offen offset:3584
		v_cvt_pk_f16_f32 v2, v28, v29
		v_cvt_pk_f16_f32 v3, v30, v31
		s_add_i32 s2, s0, 0x3000
		s_add_i32 s0, s2, s1
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen
		v_cvt_pk_f16_f32 v2, v152, v153
		v_cvt_pk_f16_f32 v3, v154, v155
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:512
		v_cvt_pk_f16_f32 v2, v156, v157
		v_cvt_pk_f16_f32 v3, v158, v159
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v160, v161
		v_cvt_pk_f16_f32 v3, v162, v163
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:1536
		v_cvt_pk_f16_f32 v2, v164, v165
		v_cvt_pk_f16_f32 v3, v166, v167
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v168, v169
		v_cvt_pk_f16_f32 v3, v170, v171
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v172, v173
		v_cvt_pk_f16_f32 v3, v174, v175
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v176, v177
		v_cvt_pk_f16_f32 v3, v178, v179
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:3584
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 24576
		.amdhsa_private_segment_fixed_size 2036
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
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 2036
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
    .private_segment_fixed_size: 2036
    .sgpr_count:     50
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     256
    .agpr_count:     0
    .vgpr_spill_count: 509
    .wavefront_size: 64
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
