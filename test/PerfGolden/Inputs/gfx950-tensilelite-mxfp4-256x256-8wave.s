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
		s_lshl_b32 s16, s15, 2
		s_add_i32 s15, s16, 0x22000
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
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v1
		v_lshlrev_b32_e32 v2, 16, v1
		v_add_u32_e32 v3, s9, v2
		v_and_b32_e32 v8, 63, v0
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v8 offset:2048
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
		s_lshl_b32 s28, s11, 10
		s_add_i32 s29, s28, 0x2000
		s_add_i32 s30, s28, 0x4000
		s_add_i32 s31, s28, 0x6000
		s_add_i32 s32, s28, 0x8000
		s_add_i32 s33, s28, 0xa000
		s_add_i32 s34, s28, 0xc000
		s_add_i32 s35, s28, 0xe000
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v11, s[20:23], 0 offen lds
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v13, s[20:23], 0 offen lds
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v14, s[20:23], 0 offen lds
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v15, s[0:3], 0 offen lds
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v16, s[0:3], 0 offen lds
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v17, s[0:3], 0 offen lds
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v18, s[0:3], 0 offen lds
		s_lshl_b32 s36, s14, 16
		s_add_i32 s37, s9, s36
		v_lshrrev_b32_e32 v3, 7, v0
		v_lshlrev_b32_e32 v11, 9, v3
		v_lshlrev_b32_e32 v12, 2, v8
		v_add3_u32 v13, s37, v11, v12
		s_lshr_b32 s38, s8, 7
		s_lshl_b32 s8, s38, 9
		s_add_i32 s38, s9, 0x100
		s_add_i32 s39, s38, s36
		v_add3_u32 v14, s39, v11, v12
		s_add_i32 s38, s8, 0x100
		v_lshlrev_b32_e32 v15, 4, v8
		v_and_b32_e32 v16, 1, v1
		v_lshlrev_b32_e32 v1, 10, v16
		v_add3_u32 v17, s37, v15, v1
		s_and_b32 s37, s11, 1
		s_lshl_b32 s11, s37, 10
		s_add_i32 s37, s11, 0x800
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
		v_and_b32_e32 v3, 15, v0
		v_lshlrev_b32_e32 v14, 6, v3
		v_lshrrev_b32_e32 v17, 4, v8
		v_lshrrev_b32_e32 v8, 1, v3
		v_and_b32_e32 v3, 3, v8
		v_xor_b32_e32 v8, v17, v3
		v_lshlrev_b32_e32 v3, 4, v8
		v_add3_u32 v8, v13, v14, v3
		ds_read_b128 v[20:23], v8
		ds_read_b128 v[24:27], v8 offset:1024
		ds_read_b128 v[28:31], v8 offset:2048
		ds_read_b128 v[32:35], v8 offset:3072
		v_lshlrev_b32_e32 v8, 13, v16
		v_add3_u32 v13, v14, v8, v3
		ds_read_b128 v[16:19], v13 offset:32768
		ds_read_b128 v[36:39], v13 offset:33792
		ds_read_b128 v[40:43], v13 offset:34816
		ds_read_b128 v[44:47], v13 offset:35840
		ds_read_b128 v[48:51], v13 offset:36864
		ds_read_b128 v[52:55], v13 offset:37888
		ds_read_b128 v[56:59], v13 offset:38912
		ds_read_b128 v[60:63], v13 offset:39936
		v_add_u32_e32 v3, 0x20000, v11
		v_add_u32_e32 v8, v3, v12
		ds_read_b32 v3, v8
		ds_read_b32 v13, v8 offset:256
		v_add_u32_e32 v8, 0x20000, v12
		v_add_u32_e32 v14, v8, v1
		ds_read_b32 v8, v14 offset:2048
		ds_read_b32 v64, v14 offset:2304
		ds_read_b32 v65, v14 offset:2560
		ds_read_b32 v66, v14 offset:2816
		s_waitcnt lgkmcnt(0)
		s_add_i32 s39, s9, 0x80
		v_add_u32_e32 v14, s39, v2
		v_add3_u32 v67, v14, v10, v9
		s_add_i32 s39, s9, 0x80080
		v_add_u32_e32 v14, s39, v2
		v_add3_u32 v68, v14, v10, v9
		s_add_i32 s39, s9, 0xc0
		v_add_u32_e32 v14, s39, v2
		v_add3_u32 v69, v14, v10, v9
		s_add_i32 s39, s9, 0x800c0
		v_add_u32_e32 v14, s39, v2
		v_add3_u32 v70, v14, v10, v9
		s_add_i32 s39, s10, 0x80
		v_add_u32_e32 v14, s39, v2
		v_add3_u32 v71, v14, v10, v9
		s_add_i32 s39, s10, 0x80080
		v_add_u32_e32 v14, s39, v2
		v_add3_u32 v72, v14, v10, v9
		s_add_i32 s39, s10, 0xc0
		v_add_u32_e32 v14, s39, v2
		v_add3_u32 v73, v14, v10, v9
		s_add_i32 s39, s10, 0x800c0
		v_add_u32_e32 v14, s39, v2
		v_add3_u32 v2, v14, v10, v9
		s_add_i32 s10, s28, 0x10000
		s_add_i32 s39, s28, 0x12000
		s_add_i32 s40, s28, 0x14000
		s_add_i32 s41, s28, 0x16000
		s_add_i32 s42, s28, 0x18000
		s_add_i32 s43, s28, 0x1a000
		s_add_i32 s44, s28, 0x1c000
		s_add_i32 s45, s28, 0x1e000
		s_mov_b32 m0, s10
		s_nop 0
		buffer_load_dwordx4 v67, s[20:23], 0 offen lds
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v68, s[20:23], 0 offen lds
		s_mov_b32 m0, s40
		s_nop 0
		buffer_load_dwordx4 v69, s[20:23], 0 offen lds
		s_mov_b32 m0, s41
		s_nop 0
		buffer_load_dwordx4 v70, s[20:23], 0 offen lds
		s_mov_b32 m0, s42
		s_nop 0
		buffer_load_dwordx4 v71, s[0:3], 0 offen lds
		s_mov_b32 m0, s43
		s_nop 0
		buffer_load_dwordx4 v72, s[0:3], 0 offen lds
		s_mov_b32 m0, s44
		s_nop 0
		buffer_load_dwordx4 v73, s[0:3], 0 offen lds
		s_mov_b32 m0, s45
		s_nop 0
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_add_i32 s46, s9, 0x800
		s_add_i32 s47, s46, s36
		v_add3_u32 v2, s47, v11, v12
		s_add_i32 s46, s8, 0x1000
		s_add_i32 s48, s9, 0x900
		s_add_i32 s9, s48, s36
		v_add3_u32 v9, s9, v11, v12
		s_add_i32 s9, s8, 0x1100
		v_add3_u32 v10, s47, v15, v1
		s_add_i32 s36, s11, 0x1800
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
		s_mov_b32 s47, 2
		v_mov_b32_e32 v10, s13
		v_mov_b32_e32 v11, 0
		s_mov_b32 s48, 0x100000
		s_mov_b32 s49, 0
		v_mov_b32_e32 v14, s48
		v_mov_b32_e32 v15, s49
		v_mul_lo_u32 v68, v14, v10
		v_mul_hi_u32 v69, v14, v10
		v_mul_lo_u32 v1, v14, v11
		v_add_u32_e32 v69, v69, v1
		v_mul_lo_u32 v1, v15, v10
		v_add_u32_e32 v69, v69, v1
		s_mov_b32 s48, 1
		s_mov_b32 s49, 0
		v_mov_b32_e32 v70, v0
		v_mov_b32_e32 v71, 0
		v_mov_b32_e32 v72, s48
		v_mov_b32_e32 v73, s49
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
		v_and_b32_e32 v85, v11, v11
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
		v_and_b32_e32 v71, v83, v11
		v_and_b32_e32 v82, v84, v1
		v_and_b32_e32 v83, v85, v11
		v_xor_b32_e32 v86, v70, v82
		v_xor_b32_e32 v87, v71, v83
		s_mov_b32 s48, 16
		s_mov_b32 s49, 0
		v_mov_b32_e32 v70, s48
		v_mov_b32_e32 v71, s49
		v_mul_lo_u32 v82, v70, v86
		v_mul_hi_u32 v83, v70, v86
		v_mul_lo_u32 v1, v70, v87
		v_add_u32_e32 v83, v83, v1
		v_mul_lo_u32 v1, v71, v86
		v_add_u32_e32 v83, v83, v1
		v_add_co_u32_e64 v86, vcc, v72, v82
		v_addc_co_u32_e64 v87, vcc, v73, v83, vcc
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
		v_add_co_u32_e64 v92, vcc, v90, v82
		v_addc_co_u32_e64 v93, vcc, v91, v83, vcc
		v_mov_b32_e32 v2, 64
		v_add_co_u32_e64 v90, vcc, v68, v2
		v_addc_co_u32_e64 v91, vcc, v69, 0, vcc
		v_add_co_u32_e64 v94, vcc, v90, v80
		v_addc_co_u32_e64 v95, vcc, v91, v81, vcc
		v_add_co_u32_e64 v90, vcc, v94, v88
		v_addc_co_u32_e64 v91, vcc, v95, v89, vcc
		v_add_co_u32_e64 v94, vcc, v90, v82
		v_addc_co_u32_e64 v95, vcc, v91, v83, vcc
		v_mov_b32_e32 v9, 0x80040
		v_add_co_u32_e64 v90, vcc, v68, v9
		v_addc_co_u32_e64 v91, vcc, v69, 0, vcc
		v_add_co_u32_e64 v96, vcc, v90, v80
		v_addc_co_u32_e64 v97, vcc, v91, v81, vcc
		v_add_co_u32_e64 v90, vcc, v96, v88
		v_addc_co_u32_e64 v91, vcc, v97, v89, vcc
		v_add_co_u32_e64 v96, vcc, v90, v82
		v_addc_co_u32_e64 v97, vcc, v91, v83, vcc
		v_mov_b32_e32 v90, s14
		v_mov_b32_e32 v91, 0
		v_mul_lo_u32 v98, v14, v90
		v_mul_hi_u32 v99, v14, v90
		v_mul_lo_u32 v12, v14, v91
		v_add_u32_e32 v99, v99, v12
		v_mul_lo_u32 v12, v15, v90
		v_add_u32_e32 v99, v99, v12
		v_add_co_u32_e64 v14, vcc, v98, v80
		v_addc_co_u32_e64 v15, vcc, v99, v81, vcc
		v_add_co_u32_e64 v100, vcc, v14, v88
		v_addc_co_u32_e64 v101, vcc, v15, v89, vcc
		v_add_co_u32_e64 v14, vcc, v100, v82
		v_addc_co_u32_e64 v15, vcc, v101, v83, vcc
		v_add_co_u32_e64 v100, vcc, v98, v1
		v_addc_co_u32_e64 v101, vcc, v99, 0, vcc
		v_add_co_u32_e64 v102, vcc, v100, v80
		v_addc_co_u32_e64 v103, vcc, v101, v81, vcc
		v_add_co_u32_e64 v100, vcc, v102, v88
		v_addc_co_u32_e64 v101, vcc, v103, v89, vcc
		v_add_co_u32_e64 v102, vcc, v100, v82
		v_addc_co_u32_e64 v103, vcc, v101, v83, vcc
		v_add_co_u32_e64 v100, vcc, v98, v2
		v_addc_co_u32_e64 v101, vcc, v99, 0, vcc
		v_add_co_u32_e64 v104, vcc, v100, v80
		v_addc_co_u32_e64 v105, vcc, v101, v81, vcc
		v_add_co_u32_e64 v100, vcc, v104, v88
		v_addc_co_u32_e64 v101, vcc, v105, v89, vcc
		v_add_co_u32_e64 v104, vcc, v100, v82
		v_addc_co_u32_e64 v105, vcc, v101, v83, vcc
		v_add_co_u32_e64 v100, vcc, v98, v9
		v_addc_co_u32_e64 v101, vcc, v99, 0, vcc
		v_add_co_u32_e64 v106, vcc, v100, v80
		v_addc_co_u32_e64 v107, vcc, v101, v81, vcc
		v_add_co_u32_e64 v100, vcc, v106, v88
		v_addc_co_u32_e64 v101, vcc, v107, v89, vcc
		v_add_co_u32_e64 v106, vcc, v100, v82
		v_addc_co_u32_e64 v107, vcc, v101, v83, vcc
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
		v_add_co_u32_e64 v90, vcc, v74, v110
		v_addc_co_u32_e64 v91, vcc, v75, v111, vcc
		s_mov_b32 s48, 0x800
		s_mov_b32 s49, 0
		v_mov_b32_e32 v1, 0x100
		v_add_co_u32_e64 v74, vcc, v68, v1
		v_addc_co_u32_e64 v75, vcc, v69, 0, vcc
		v_add_co_u32_e64 v112, vcc, v74, v100
		v_addc_co_u32_e64 v113, vcc, v75, v101, vcc
		v_add_co_u32_e64 v74, vcc, v112, v108
		v_addc_co_u32_e64 v75, vcc, v113, v109, vcc
		v_add_co_u32_e64 v112, vcc, v74, v110
		v_addc_co_u32_e64 v113, vcc, v75, v111, vcc
		v_mul_lo_u32 v74, v70, v84
		v_mul_hi_u32 v75, v70, v84
		v_mul_lo_u32 v1, v70, v85
		v_add_u32_e32 v75, v75, v1
		v_mul_lo_u32 v1, v71, v84
		v_add_u32_e32 v75, v75, v1
		v_add_co_u32_e64 v70, vcc, v78, v74
		v_addc_co_u32_e64 v71, vcc, v79, v75, vcc
		v_mov_b32_e32 v1, 1
		v_and_b32_e32 v78, v76, v1
		v_and_b32_e32 v79, v77, v11
		s_mov_b32 s50, 0x400
		s_mov_b32 s51, 0
		v_mov_b32_e32 v10, s50
		v_mov_b32_e32 v11, s51
		v_mul_lo_u32 v76, v10, v78
		v_mul_hi_u32 v77, v10, v78
		v_mul_lo_u32 v1, v10, v79
		v_add_u32_e32 v77, v77, v1
		v_mul_lo_u32 v1, v11, v78
		v_add_u32_e32 v77, v77, v1
		v_add_co_u32_e64 v10, vcc, v70, v76
		v_addc_co_u32_e64 v11, vcc, v71, v77, vcc
		v_mov_b32_e32 v1, 0x80
		v_add_co_u32_e64 v70, vcc, v68, v1
		v_addc_co_u32_e64 v71, vcc, v69, 0, vcc
		v_add_co_u32_e64 v78, vcc, v70, v80
		v_addc_co_u32_e64 v79, vcc, v71, v81, vcc
		v_add_co_u32_e64 v70, vcc, v78, v88
		v_addc_co_u32_e64 v71, vcc, v79, v89, vcc
		v_add_co_u32_e64 v78, vcc, v70, v82
		v_addc_co_u32_e64 v79, vcc, v71, v83, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v78, s50
		scratch_store_dword off, v79, s50 offset:4
		v_mov_b32_e32 v2, 0x80080
		v_add_co_u32_e64 v70, vcc, v68, v2
		v_addc_co_u32_e64 v71, vcc, v69, 0, vcc
		v_add_co_u32_e64 v78, vcc, v70, v80
		v_addc_co_u32_e64 v79, vcc, v71, v81, vcc
		v_add_co_u32_e64 v70, vcc, v78, v88
		v_addc_co_u32_e64 v71, vcc, v79, v89, vcc
		v_add_co_u32_e64 v78, vcc, v70, v82
		v_addc_co_u32_e64 v79, vcc, v71, v83, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v78, s50 offset:8
		scratch_store_dword off, v79, s50 offset:12
		v_mov_b32_e32 v9, 0xc0
		v_add_co_u32_e64 v70, vcc, v68, v9
		v_addc_co_u32_e64 v71, vcc, v69, 0, vcc
		v_add_co_u32_e64 v78, vcc, v70, v80
		v_addc_co_u32_e64 v79, vcc, v71, v81, vcc
		v_add_co_u32_e64 v70, vcc, v78, v88
		v_addc_co_u32_e64 v71, vcc, v79, v89, vcc
		v_add_co_u32_e64 v78, vcc, v70, v82
		v_addc_co_u32_e64 v79, vcc, v71, v83, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v78, s50 offset:16
		scratch_store_dword off, v79, s50 offset:20
		v_mov_b32_e32 v12, 0x800c0
		v_add_co_u32_e64 v70, vcc, v68, v12
		v_addc_co_u32_e64 v71, vcc, v69, 0, vcc
		v_add_co_u32_e64 v78, vcc, v70, v80
		v_addc_co_u32_e64 v79, vcc, v71, v81, vcc
		v_add_co_u32_e64 v70, vcc, v78, v88
		v_addc_co_u32_e64 v71, vcc, v79, v89, vcc
		v_add_co_u32_e64 v78, vcc, v70, v82
		v_addc_co_u32_e64 v79, vcc, v71, v83, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v78, s50 offset:24
		scratch_store_dword off, v79, s50 offset:28
		v_add_co_u32_e64 v70, vcc, v98, v1
		v_addc_co_u32_e64 v71, vcc, v99, 0, vcc
		v_add_co_u32_e64 v78, vcc, v70, v80
		v_addc_co_u32_e64 v79, vcc, v71, v81, vcc
		v_add_co_u32_e64 v70, vcc, v78, v88
		v_addc_co_u32_e64 v71, vcc, v79, v89, vcc
		v_add_co_u32_e64 v78, vcc, v70, v82
		v_addc_co_u32_e64 v79, vcc, v71, v83, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v78, s50 offset:32
		scratch_store_dword off, v79, s50 offset:36
		v_add_co_u32_e64 v70, vcc, v98, v2
		v_addc_co_u32_e64 v71, vcc, v99, 0, vcc
		v_add_co_u32_e64 v78, vcc, v70, v80
		v_addc_co_u32_e64 v79, vcc, v71, v81, vcc
		v_add_co_u32_e64 v70, vcc, v78, v88
		v_addc_co_u32_e64 v71, vcc, v79, v89, vcc
		v_add_co_u32_e64 v78, vcc, v70, v82
		v_addc_co_u32_e64 v79, vcc, v71, v83, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v78, s50 offset:40
		scratch_store_dword off, v79, s50 offset:44
		v_add_co_u32_e64 v70, vcc, v98, v9
		v_addc_co_u32_e64 v71, vcc, v99, 0, vcc
		v_add_co_u32_e64 v78, vcc, v70, v80
		v_addc_co_u32_e64 v79, vcc, v71, v81, vcc
		v_add_co_u32_e64 v70, vcc, v78, v88
		v_addc_co_u32_e64 v71, vcc, v79, v89, vcc
		v_add_co_u32_e64 v78, vcc, v70, v82
		v_addc_co_u32_e64 v79, vcc, v71, v83, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v78, s50 offset:48
		scratch_store_dword off, v79, s50 offset:52
		v_add_co_u32_e64 v70, vcc, v98, v12
		v_addc_co_u32_e64 v71, vcc, v99, 0, vcc
		v_add_co_u32_e64 v78, vcc, v70, v80
		v_addc_co_u32_e64 v79, vcc, v71, v81, vcc
		v_add_co_u32_e64 v70, vcc, v78, v88
		v_addc_co_u32_e64 v71, vcc, v79, v89, vcc
		v_add_co_u32_e64 v78, vcc, v70, v82
		v_addc_co_u32_e64 v79, vcc, v71, v83, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v78, s50 offset:56
		scratch_store_dword off, v79, s50 offset:60
		v_mov_b32_e32 v1, 0x800
		v_add_co_u32_e64 v70, vcc, v68, v1
		v_addc_co_u32_e64 v71, vcc, v69, 0, vcc
		v_add_co_u32_e64 v78, vcc, v70, v100
		v_addc_co_u32_e64 v79, vcc, v71, v101, vcc
		v_add_co_u32_e64 v70, vcc, v78, v108
		v_addc_co_u32_e64 v71, vcc, v79, v109, vcc
		v_add_co_u32_e64 v80, vcc, v70, v110
		v_addc_co_u32_e64 v81, vcc, v71, v111, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v80, s50 offset:64
		scratch_store_dword off, v81, s50 offset:68
		v_mov_b32_e32 v1, 0x900
		v_add_co_u32_e64 v70, vcc, v68, v1
		v_addc_co_u32_e64 v71, vcc, v69, 0, vcc
		v_add_co_u32_e64 v68, vcc, v70, v100
		v_addc_co_u32_e64 v69, vcc, v71, v101, vcc
		v_add_co_u32_e64 v70, vcc, v68, v108
		v_addc_co_u32_e64 v71, vcc, v69, v109, vcc
		v_add_co_u32_e64 v68, vcc, v70, v110
		v_addc_co_u32_e64 v69, vcc, v71, v111, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v68, s50 offset:72
		scratch_store_dword off, v69, s50 offset:76
		v_add_co_u32_e64 v68, vcc, v78, v74
		v_addc_co_u32_e64 v69, vcc, v79, v75, vcc
		v_add_co_u32_e64 v70, vcc, v68, v76
		v_addc_co_u32_e64 v71, vcc, v69, v77, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v70, s50 offset:80
		scratch_store_dword off, v71, s50 offset:84
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_mov_b64_e32 v[76:77], 0
		v_mov_b64_e32 v[78:79], 0
		v_mov_b64_e32 v[80:81], 0
		v_mov_b64_e32 v[82:83], 0
		v_mov_b64_e32 v[108:109], 0
		v_mov_b64_e32 v[110:111], 0
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
		v_mov_b64_e32 v[216:217], 0
		v_mov_b64_e32 v[218:219], 0
		v_mov_b64_e32 v[220:221], 0
		v_mov_b64_e32 v[222:223], 0
.Lwmma_f16_matmul_tiled.loop_head_0:
		v_mov_b32_e32 v74, s47
		v_mov_b32_e32 v75, 0
		v_mul_lo_u32 v84, v72, v74
		v_mul_hi_u32 v85, v72, v74
		v_mul_lo_u32 v1, v72, v75
		v_add_u32_e32 v85, v85, v1
		v_mul_lo_u32 v1, v73, v74
		v_add_u32_e32 v85, v85, v1
		v_add_co_u32_e64 v74, vcc, v86, v84
		v_addc_co_u32_e64 v75, vcc, v87, v85, vcc
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v74 offset:4096
		v_add_co_u32_e64 v74, vcc, v92, v84
		v_addc_co_u32_e64 v75, vcc, v93, v85, vcc
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v74 offset:6144
		v_add_co_u32_e64 v74, vcc, v94, v84
		v_addc_co_u32_e64 v75, vcc, v95, v85, vcc
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v74 offset:8192
		v_add_co_u32_e64 v74, vcc, v96, v84
		v_addc_co_u32_e64 v75, vcc, v97, v85, vcc
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v74 offset:10240
		v_add_co_u32_e64 v74, vcc, v14, v84
		v_addc_co_u32_e64 v75, vcc, v15, v85, vcc
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v74 offset:12288
		v_add_co_u32_e64 v74, vcc, v102, v84
		v_addc_co_u32_e64 v75, vcc, v103, v85, vcc
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v74 offset:14336
		v_add_co_u32_e64 v74, vcc, v104, v84
		v_addc_co_u32_e64 v75, vcc, v105, v85, vcc
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v74 offset:16384
		v_add_co_u32_e64 v74, vcc, v106, v84
		v_addc_co_u32_e64 v75, vcc, v107, v85, vcc
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v74 offset:18432
		v_mov_b32_e32 v74, s47
		v_mov_b32_e32 v75, 0
		v_mov_b32_e32 v88, s48
		v_mov_b32_e32 v89, s49
		v_mul_lo_u32 v98, v88, v74
		v_mul_hi_u32 v99, v88, v74
		v_mul_lo_u32 v1, v88, v75
		v_add_u32_e32 v99, v99, v1
		v_mul_lo_u32 v1, v89, v74
		v_add_u32_e32 v99, v99, v1
		s_mov_b32 s50, 0
		scratch_store_dword off, v98, s50 offset:104
		scratch_store_dword off, v99, s50 offset:108
		v_add_co_u32_e64 v74, vcc, v90, v98
		v_addc_co_u32_e64 v75, vcc, v91, v99, vcc
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v74 offset:20480
		v_add_co_u32_e64 v74, vcc, v112, v98
		v_addc_co_u32_e64 v75, vcc, v113, v99, vcc
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v74 offset:22528
		v_add_co_u32_e64 v74, vcc, v10, v98
		v_addc_co_u32_e64 v75, vcc, v11, v99, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v74, s50 offset:88
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[20:23], v[16:19], v[4:7], v3, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s50, s47, 1
		s_and_b32 s51, s47, 1
		s_lshl_b32 s52, s51, 16
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v2, 12, v1
		v_add_u32_e32 v1, s52, v2
		v_and_b32_e32 v2, 15, v0
		v_lshlrev_b32_e32 v9, 6, v2
		v_and_b32_e32 v12, 63, v0
		v_lshrrev_b32_e32 v67, 4, v12
		v_lshrrev_b32_e32 v12, 1, v2
		v_and_b32_e32 v2, 3, v12
		v_xor_b32_e32 v12, v67, v2
		v_lshlrev_b32_e32 v2, 4, v12
		v_add3_u32 v12, v1, v9, v2
		s_mov_b32 s51, 0
		scratch_store_dword off, v12, s51 offset:112
		ds_read_b128 v[224:227], v12 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[20:23], v[36:39], v[68:71], v3, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v12 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[20:23], v[40:43], v[76:79], v3, v64 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[232:235], v12 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[20:23], v[44:47], v[80:83], v3, v64 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[236:239], v12 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[20:23], v[48:51], v[108:111], v3, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_and_b32_e32 v1, 15, v0
		v_lshlrev_b32_e32 v2, 6, v1
		s_mov_b32 s51, 0
		scratch_store_dword off, v2, s51 offset:96
		v_lshrrev_b32_e32 v1, 6, v0
		v_and_b32_e32 v9, 1, v1
		v_lshlrev_b32_e32 v1, 13, v9
		s_mov_b32 s51, 0
		scratch_store_dword off, v1, s51 offset:92
		v_and_b32_e32 v9, 63, v0
		v_lshrrev_b32_e32 v12, 4, v9
		v_and_b32_e32 v9, 15, v0
		v_lshrrev_b32_e32 v67, 1, v9
		v_and_b32_e32 v9, 3, v67
		v_xor_b32_e32 v67, v12, v9
		v_lshlrev_b32_e32 v9, 4, v67
		s_mov_b32 s51, 0
		scratch_store_dword off, v9, s51 offset:100
		s_and_b32 s51, s47, 1
		s_lshl_b32 s52, s51, 16
		v_add_u32_e32 v12, s52, v2
		v_add3_u32 v2, v12, v1, v9
		ds_read_b128 v[240:243], v2 offset:49152
		s_mov_b32 s51, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v240, s51 offset:116
		scratch_store_dword off, v241, s51 offset:120
		scratch_store_dword off, v242, s51 offset:124
		scratch_store_dword off, v243, s51 offset:128
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[20:23], v[52:55], v[116:119], v3, v65 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v2 offset:50176
		s_mov_b32 s51, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v240, s51 offset:132
		scratch_store_dword off, v241, s51 offset:136
		scratch_store_dword off, v242, s51 offset:140
		scratch_store_dword off, v243, s51 offset:144
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], v[56:59], v[120:123], v3, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v2 offset:51200
		s_mov_b32 s51, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v240, s51 offset:148
		scratch_store_dword off, v241, s51 offset:152
		scratch_store_dword off, v242, s51 offset:156
		scratch_store_dword off, v243, s51 offset:160
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], v[60:63], v[124:127], v3, v66 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v2 offset:52224
		s_mov_b32 s51, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v240, s51 offset:164
		scratch_store_dword off, v241, s51 offset:168
		scratch_store_dword off, v242, s51 offset:172
		scratch_store_dword off, v243, s51 offset:176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[24:27], v[16:19], v[128:131], v3, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v2 offset:53248
		s_mov_b32 s51, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v240, s51 offset:180
		scratch_store_dword off, v241, s51 offset:184
		scratch_store_dword off, v242, s51 offset:188
		scratch_store_dword off, v243, s51 offset:192
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[24:27], v[36:39], v[132:135], v3, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v2 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[24:27], v[40:43], v[136:139], v3, v64 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[244:247], v2 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[24:27], v[44:47], v[140:143], v3, v64 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v2 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[48:51], v[144:147], v3, v65 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s28
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v1 offset:4096
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[52:55], v[148:151], v3, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s29
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v1 offset:6144
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[56:59], v[152:155], v3, v66 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s30
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v1 offset:8192
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[60:63], v[156:159], v3, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s31
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v1 offset:10240
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[28:31], v[16:19], v[160:163], v13, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s32
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v1 offset:12288
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v1, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[28:31], v[36:39], v[164:167], v13, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s33
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v1 offset:14336
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v1, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[28:31], v[40:43], v[168:171], v13, v64 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s34
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v1 offset:16384
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v1, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[28:31], v[44:47], v[172:175], v13, v64 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s35
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v1 offset:18432
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v1, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[48:51], v[176:179], v13, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s8, 0x20000
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v1 offset:20480
		s_waitcnt lgkmcnt(0)
		buffer_load_dword v1, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[52:55], v[180:183], v13, v65 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s38, 0x20000
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		buffer_load_dword v1, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[56:59], v[184:187], v13, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s37, 0x20000
		s_mov_b32 s51, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v1, off, s51 offset:88
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[60:63], v[188:191], v13, v66 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		s_mov_b32 s51, 0
		s_waitcnt vmcnt(23)
		scratch_load_dword v1, off, s51 offset:112
		s_waitcnt vmcnt(0)
		ds_read_b128 v[20:23], v1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[32:35], v[16:19], v[192:195], v13, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s51, 0
		scratch_load_dword v1, off, s51 offset:112
		s_waitcnt vmcnt(0)
		ds_read_b128 v[24:27], v1 offset:1024
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[32:35], v[36:39], v[196:199], v13, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s51, 0
		scratch_load_dword v1, off, s51 offset:112
		s_waitcnt vmcnt(0)
		ds_read_b128 v[28:31], v1 offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[32:35], v[40:43], v[200:203], v13, v64 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s51, 0
		scratch_load_dword v1, off, s51 offset:112
		s_waitcnt vmcnt(0)
		ds_read_b128 v[252:255], v1 offset:3072
		s_mov_b32 s51, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v252, s51 offset:196
		scratch_store_dword off, v253, s51 offset:200
		scratch_store_dword off, v254, s51 offset:204
		scratch_store_dword off, v255, s51 offset:208
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[32:35], v[44:47], v[204:207], v13, v64 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[16:19], v2 offset:32768
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[48:51], v[208:211], v13, v65 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[36:39], v2 offset:33792
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[52:55], v[212:215], v13, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[40:43], v2 offset:34816
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[56:59], v[216:219], v13, v66 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[44:47], v2 offset:35840
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], v[60:63], v[220:223], v13, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[48:51], v2 offset:36864
		ds_read_b128 v[52:55], v2 offset:37888
		ds_read_b128 v[56:59], v2 offset:38912
		ds_read_b128 v[60:63], v2 offset:39936
		s_lshl_b32 s51, s50, 12
		s_add_i32 s50, s51, 0x20000
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v2, 9, v1
		s_mov_b32 s51, 0
		scratch_store_dword off, v2, s51 offset:212
		v_and_b32_e32 v1, 63, v0
		v_lshlrev_b32_e32 v9, 2, v1
		s_mov_b32 s51, 0
		scratch_store_dword off, v9, s51 offset:244
		v_add3_u32 v1, s50, v2, v9
		ds_read_b32 v2, v1
		s_mov_b32 s51, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s51 offset:216
		ds_read_b32 v2, v1 offset:256
		s_mov_b32 s51, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s51 offset:220
		v_lshrrev_b32_e32 v1, 6, v0
		v_and_b32_e32 v2, 1, v1
		v_lshlrev_b32_e32 v1, 10, v2
		s_mov_b32 s51, 0
		scratch_store_dword off, v1, s51 offset:224
		v_add3_u32 v2, s50, v9, v1
		ds_read_b32 v1, v2 offset:2048
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v1, s50 offset:228
		ds_read_b32 v1, v2 offset:2304
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v1, s50 offset:232
		ds_read_b32 v1, v2 offset:2560
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v1, s50 offset:236
		ds_read_b32 v1, v2 offset:2816
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v1, s50 offset:240
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(29)
		scratch_load_dword v252, off, s50 offset:116
		scratch_load_dword v253, off, s50 offset:120
		scratch_load_dword v254, off, s50 offset:124
		scratch_load_dword v255, off, s50 offset:128
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[224:227], v[252:255], v[4:7], v3, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(25)
		scratch_load_dword v252, off, s50 offset:132
		scratch_load_dword v253, off, s50 offset:136
		scratch_load_dword v254, off, s50 offset:140
		scratch_load_dword v255, off, s50 offset:144
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[224:227], v[252:255], v[68:71], v3, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(21)
		scratch_load_dword v252, off, s50 offset:148
		scratch_load_dword v253, off, s50 offset:152
		scratch_load_dword v254, off, s50 offset:156
		scratch_load_dword v255, off, s50 offset:160
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[224:227], v[252:255], v[76:79], v3, v64 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(17)
		scratch_load_dword v252, off, s50 offset:164
		scratch_load_dword v253, off, s50 offset:168
		scratch_load_dword v254, off, s50 offset:172
		scratch_load_dword v255, off, s50 offset:176
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[224:227], v[252:255], v[80:83], v3, v64 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(13)
		scratch_load_dword v252, off, s50 offset:180
		scratch_load_dword v253, off, s50 offset:184
		scratch_load_dword v254, off, s50 offset:188
		scratch_load_dword v255, off, s50 offset:192
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[224:227], v[252:255], v[108:111], v3, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[224:227], v[240:243], v[116:119], v3, v65 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[224:227], v[244:247], v[120:123], v3, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[224:227], v[248:251], v[124:127], v3, v66 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v224, off, s50 offset:116
		scratch_load_dword v225, off, s50 offset:120
		scratch_load_dword v226, off, s50 offset:124
		scratch_load_dword v227, off, s50 offset:128
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[228:231], v[224:227], v[128:131], v3, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v224, off, s50 offset:132
		scratch_load_dword v225, off, s50 offset:136
		scratch_load_dword v226, off, s50 offset:140
		scratch_load_dword v227, off, s50 offset:144
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[228:231], v[224:227], v[132:135], v3, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v224, off, s50 offset:148
		scratch_load_dword v225, off, s50 offset:152
		scratch_load_dword v226, off, s50 offset:156
		scratch_load_dword v227, off, s50 offset:160
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[228:231], v[224:227], v[136:139], v3, v64 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v224, off, s50 offset:164
		scratch_load_dword v225, off, s50 offset:168
		scratch_load_dword v226, off, s50 offset:172
		scratch_load_dword v227, off, s50 offset:176
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[228:231], v[224:227], v[140:143], v3, v64 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v224, off, s50 offset:180
		scratch_load_dword v225, off, s50 offset:184
		scratch_load_dword v226, off, s50 offset:188
		scratch_load_dword v227, off, s50 offset:192
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[228:231], v[224:227], v[144:147], v3, v65 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[228:231], v[240:243], v[148:151], v3, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[228:231], v[244:247], v[152:155], v3, v66 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[228:231], v[248:251], v[156:159], v3, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v224, off, s50 offset:116
		scratch_load_dword v225, off, s50 offset:120
		scratch_load_dword v226, off, s50 offset:124
		scratch_load_dword v227, off, s50 offset:128
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[232:235], v[224:227], v[160:163], v13, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v224, off, s50 offset:132
		scratch_load_dword v225, off, s50 offset:136
		scratch_load_dword v226, off, s50 offset:140
		scratch_load_dword v227, off, s50 offset:144
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[232:235], v[224:227], v[164:167], v13, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v224, off, s50 offset:148
		scratch_load_dword v225, off, s50 offset:152
		scratch_load_dword v226, off, s50 offset:156
		scratch_load_dword v227, off, s50 offset:160
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[232:235], v[224:227], v[168:171], v13, v64 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v224, off, s50 offset:164
		scratch_load_dword v225, off, s50 offset:168
		scratch_load_dword v226, off, s50 offset:172
		scratch_load_dword v227, off, s50 offset:176
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[232:235], v[224:227], v[172:175], v13, v64 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v224, off, s50 offset:180
		scratch_load_dword v225, off, s50 offset:184
		scratch_load_dword v226, off, s50 offset:188
		scratch_load_dword v227, off, s50 offset:192
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[232:235], v[224:227], v[176:179], v13, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[232:235], v[240:243], v[180:183], v13, v65 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[232:235], v[244:247], v[184:187], v13, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[232:235], v[248:251], v[188:191], v13, v66 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v224, off, s50 offset:116
		scratch_load_dword v225, off, s50 offset:120
		scratch_load_dword v226, off, s50 offset:124
		scratch_load_dword v227, off, s50 offset:128
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[236:239], v[224:227], v[192:195], v13, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v224, off, s50 offset:132
		scratch_load_dword v225, off, s50 offset:136
		scratch_load_dword v226, off, s50 offset:140
		scratch_load_dword v227, off, s50 offset:144
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[236:239], v[224:227], v[196:199], v13, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v224, off, s50 offset:148
		scratch_load_dword v225, off, s50 offset:152
		scratch_load_dword v226, off, s50 offset:156
		scratch_load_dword v227, off, s50 offset:160
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[236:239], v[224:227], v[200:203], v13, v64 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v224, off, s50 offset:164
		scratch_load_dword v225, off, s50 offset:168
		scratch_load_dword v226, off, s50 offset:172
		scratch_load_dword v227, off, s50 offset:176
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[236:239], v[224:227], v[204:207], v13, v64 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v224, off, s50 offset:180
		scratch_load_dword v225, off, s50 offset:184
		scratch_load_dword v226, off, s50 offset:188
		scratch_load_dword v227, off, s50 offset:192
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[236:239], v[224:227], v[208:211], v13, v65 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[236:239], v[240:243], v[212:215], v13, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[236:239], v[244:247], v[216:219], v13, v66 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[236:239], v[248:251], v[220:223], v13, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s50, s47, 1
		s_and_b32 s51, s50, 1
		s_lshl_b32 s50, s51, 16
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v2, 12, v1
		v_add_u32_e32 v1, s50, v2
		s_mov_b32 s52, 0
		scratch_load_dword v2, off, s52 offset:96
		s_mov_b32 s52, 0
		scratch_load_dword v9, off, s52 offset:100
		s_waitcnt vmcnt(0)
		v_add3_u32 v12, v1, v2, v9
		s_mov_b32 s52, 0
		scratch_store_dword off, v12, s52 offset:248
		ds_read_b128 v[224:227], v12
		s_mov_b32 s52, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v224, s52 offset:424
		scratch_store_dword off, v225, s52 offset:428
		scratch_store_dword off, v226, s52 offset:432
		scratch_store_dword off, v227, s52 offset:436
		ds_read_b128 v[228:231], v12 offset:1024
		s_mov_b32 s52, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s52 offset:440
		scratch_store_dword off, v229, s52 offset:444
		scratch_store_dword off, v230, s52 offset:448
		scratch_store_dword off, v231, s52 offset:452
		ds_read_b128 v[228:231], v12 offset:2048
		ds_read_b128 v[232:235], v12 offset:3072
		s_mov_b32 s52, 0
		scratch_load_dword v1, off, s52 offset:96
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v2, s50, v1
		s_mov_b32 s50, 0
		scratch_load_dword v9, off, s50 offset:92
		s_mov_b32 s50, 0
		scratch_load_dword v12, off, s50 offset:100
		s_waitcnt vmcnt(0)
		v_add3_u32 v67, v2, v9, v12
		ds_read_b128 v[236:239], v67 offset:32768
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s50 offset:252
		scratch_store_dword off, v237, s50 offset:256
		scratch_store_dword off, v238, s50 offset:260
		scratch_store_dword off, v239, s50 offset:264
		ds_read_b128 v[236:239], v67 offset:33792
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s50 offset:268
		scratch_store_dword off, v237, s50 offset:272
		scratch_store_dword off, v238, s50 offset:276
		scratch_store_dword off, v239, s50 offset:280
		ds_read_b128 v[236:239], v67 offset:34816
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s50 offset:284
		scratch_store_dword off, v237, s50 offset:288
		scratch_store_dword off, v238, s50 offset:292
		scratch_store_dword off, v239, s50 offset:296
		ds_read_b128 v[236:239], v67 offset:35840
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s50 offset:300
		scratch_store_dword off, v237, s50 offset:304
		scratch_store_dword off, v238, s50 offset:308
		scratch_store_dword off, v239, s50 offset:312
		s_add_i32 s50, s47, 1
		s_and_b32 s52, s50, 1
		s_lshl_b32 s50, s52, 16
		v_add_u32_e32 v2, s50, v1
		v_add3_u32 v1, v2, v9, v12
		s_mov_b32 s50, 0
		scratch_store_dword off, v1, s50 offset:504
		ds_read_b128 v[236:239], v1 offset:36864
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s50 offset:360
		scratch_store_dword off, v237, s50 offset:364
		scratch_store_dword off, v238, s50 offset:368
		scratch_store_dword off, v239, s50 offset:372
		ds_read_b128 v[236:239], v1 offset:37888
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s50 offset:376
		scratch_store_dword off, v237, s50 offset:380
		scratch_store_dword off, v238, s50 offset:384
		scratch_store_dword off, v239, s50 offset:388
		ds_read_b128 v[236:239], v1 offset:38912
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s50 offset:392
		scratch_store_dword off, v237, s50 offset:396
		scratch_store_dword off, v238, s50 offset:400
		scratch_store_dword off, v239, s50 offset:404
		ds_read_b128 v[236:239], v1 offset:39936
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s50 offset:408
		scratch_store_dword off, v237, s50 offset:412
		scratch_store_dword off, v238, s50 offset:416
		scratch_store_dword off, v239, s50 offset:420
		s_lshl_b32 s50, s51, 12
		s_add_i32 s51, s50, 0x20000
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(50)
		scratch_load_dword v2, off, s50 offset:212
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(49)
		scratch_load_dword v9, off, s50 offset:244
		s_waitcnt vmcnt(0)
		v_add3_u32 v12, s51, v2, v9
		ds_read_b32 v2, v12
		ds_read_b32 v9, v12 offset:256
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(46)
		scratch_load_dword v12, off, s50 offset:224
		s_mov_b32 s50, 0
		scratch_load_dword v67, off, s50 offset:244
		s_waitcnt vmcnt(0)
		v_add3_u32 v74, s51, v67, v12
		ds_read_b32 v12, v74 offset:2048
		ds_read_b32 v67, v74 offset:2304
		ds_read_b32 v75, v74 offset:2560
		ds_read_b32 v88, v74 offset:2816
		s_waitcnt lgkmcnt(0)
		s_mov_b32 s50, 0
		scratch_load_dword v98, off, s50
		scratch_load_dword v99, off, s50 offset:4
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v100, vcc, v98, v84
		v_addc_co_u32_e64 v101, vcc, v99, v85, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v100, s50 offset:316
		s_mov_b32 s50, 0
		scratch_load_dword v98, off, s50 offset:8
		scratch_load_dword v99, off, s50 offset:12
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v100, vcc, v98, v84
		v_addc_co_u32_e64 v101, vcc, v99, v85, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v100, s50 offset:320
		s_mov_b32 s50, 0
		scratch_load_dword v98, off, s50 offset:16
		scratch_load_dword v99, off, s50 offset:20
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v100, vcc, v98, v84
		v_addc_co_u32_e64 v101, vcc, v99, v85, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v100, s50 offset:324
		s_mov_b32 s50, 0
		scratch_load_dword v98, off, s50 offset:24
		scratch_load_dword v99, off, s50 offset:28
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v100, vcc, v98, v84
		v_addc_co_u32_e64 v101, vcc, v99, v85, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v100, s50 offset:328
		s_mov_b32 s50, 0
		scratch_load_dword v98, off, s50 offset:32
		scratch_load_dword v99, off, s50 offset:36
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v100, vcc, v98, v84
		v_addc_co_u32_e64 v101, vcc, v99, v85, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v100, s50 offset:332
		s_mov_b32 s50, 0
		scratch_load_dword v98, off, s50 offset:40
		scratch_load_dword v99, off, s50 offset:44
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v100, vcc, v98, v84
		v_addc_co_u32_e64 v101, vcc, v99, v85, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v100, s50 offset:336
		s_mov_b32 s50, 0
		scratch_load_dword v98, off, s50 offset:48
		scratch_load_dword v99, off, s50 offset:52
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v100, vcc, v98, v84
		v_addc_co_u32_e64 v101, vcc, v99, v85, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v100, s50 offset:340
		s_mov_b32 s50, 0
		scratch_load_dword v98, off, s50 offset:56
		scratch_load_dword v99, off, s50 offset:60
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v100, vcc, v98, v84
		v_addc_co_u32_e64 v101, vcc, v99, v85, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v100, s50 offset:344
		s_mov_b32 s50, 0
		scratch_load_dword v84, off, s50 offset:64
		scratch_load_dword v85, off, s50 offset:68
		s_mov_b32 s50, 0
		scratch_load_dword v98, off, s50 offset:104
		scratch_load_dword v99, off, s50 offset:108
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v100, vcc, v84, v98
		v_addc_co_u32_e64 v101, vcc, v85, v99, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v100, s50 offset:348
		s_mov_b32 s50, 0
		scratch_load_dword v84, off, s50 offset:72
		scratch_load_dword v85, off, s50 offset:76
		s_mov_b32 s50, 0
		scratch_load_dword v98, off, s50 offset:104
		scratch_load_dword v99, off, s50 offset:108
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v100, vcc, v84, v98
		v_addc_co_u32_e64 v101, vcc, v85, v99, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v100, s50 offset:352
		s_mov_b32 s50, 0
		scratch_load_dword v84, off, s50 offset:80
		scratch_load_dword v85, off, s50 offset:84
		s_mov_b32 s50, 0
		scratch_load_dword v98, off, s50 offset:104
		scratch_load_dword v99, off, s50 offset:108
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v100, vcc, v84, v98
		v_addc_co_u32_e64 v101, vcc, v85, v99, vcc
		s_mov_b32 s50, 0
		scratch_store_dword off, v100, s50 offset:356
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(40)
		scratch_load_dword v236, off, s50 offset:252
		scratch_load_dword v237, off, s50 offset:256
		scratch_load_dword v238, off, s50 offset:260
		scratch_load_dword v239, off, s50 offset:264
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[224:227], v[236:239], v[4:7], v2, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v74, off, s50 offset:248
		s_waitcnt vmcnt(0)
		ds_read_b128 v[236:239], v74 offset:16384
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(36)
		scratch_load_dword v240, off, s50 offset:268
		scratch_load_dword v241, off, s50 offset:272
		scratch_load_dword v242, off, s50 offset:276
		scratch_load_dword v243, off, s50 offset:280
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[224:227], v[240:243], v[68:71], v2, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v74, off, s50 offset:248
		s_waitcnt vmcnt(0)
		ds_read_b128 v[240:243], v74 offset:17408
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(32)
		scratch_load_dword v244, off, s50 offset:284
		scratch_load_dword v245, off, s50 offset:288
		scratch_load_dword v246, off, s50 offset:292
		scratch_load_dword v247, off, s50 offset:296
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[224:227], v[244:247], v[76:79], v2, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v74, off, s50 offset:248
		s_waitcnt vmcnt(0)
		ds_read_b128 v[244:247], v74 offset:18432
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(28)
		scratch_load_dword v248, off, s50 offset:300
		scratch_load_dword v249, off, s50 offset:304
		scratch_load_dword v250, off, s50 offset:308
		scratch_load_dword v251, off, s50 offset:312
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[224:227], v[248:251], v[80:83], v2, v67 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v74, off, s50 offset:248
		s_waitcnt vmcnt(0)
		ds_read_b128 v[224:227], v74 offset:19456
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(23)
		scratch_load_dword v248, off, s50 offset:360
		scratch_load_dword v249, off, s50 offset:364
		scratch_load_dword v250, off, s50 offset:368
		scratch_load_dword v251, off, s50 offset:372
		s_mov_b32 s50, 0
		scratch_load_dword v252, off, s50 offset:424
		scratch_load_dword v253, off, s50 offset:428
		scratch_load_dword v254, off, s50 offset:432
		scratch_load_dword v255, off, s50 offset:436
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[252:255], v[248:251], v[108:111], v2, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v1 offset:49152
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s50 offset:456
		scratch_store_dword off, v249, s50 offset:460
		scratch_store_dword off, v250, s50 offset:464
		scratch_store_dword off, v251, s50 offset:468
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(23)
		scratch_load_dword v248, off, s50 offset:376
		scratch_load_dword v249, off, s50 offset:380
		scratch_load_dword v250, off, s50 offset:384
		scratch_load_dword v251, off, s50 offset:388
		s_mov_b32 s50, 0
		scratch_load_dword v252, off, s50 offset:424
		scratch_load_dword v253, off, s50 offset:428
		scratch_load_dword v254, off, s50 offset:432
		scratch_load_dword v255, off, s50 offset:436
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[252:255], v[248:251], v[116:119], v2, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v1 offset:50176
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s50 offset:472
		scratch_store_dword off, v249, s50 offset:476
		scratch_store_dword off, v250, s50 offset:480
		scratch_store_dword off, v251, s50 offset:484
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(23)
		scratch_load_dword v248, off, s50 offset:392
		scratch_load_dword v249, off, s50 offset:396
		scratch_load_dword v250, off, s50 offset:400
		scratch_load_dword v251, off, s50 offset:404
		s_mov_b32 s50, 0
		scratch_load_dword v252, off, s50 offset:424
		scratch_load_dword v253, off, s50 offset:428
		scratch_load_dword v254, off, s50 offset:432
		scratch_load_dword v255, off, s50 offset:436
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[252:255], v[248:251], v[120:123], v2, v88 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v1 offset:51200
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s50 offset:488
		scratch_store_dword off, v249, s50 offset:492
		scratch_store_dword off, v250, s50 offset:496
		scratch_store_dword off, v251, s50 offset:500
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(23)
		scratch_load_dword v248, off, s50 offset:408
		scratch_load_dword v249, off, s50 offset:412
		scratch_load_dword v250, off, s50 offset:416
		scratch_load_dword v251, off, s50 offset:420
		s_mov_b32 s50, 0
		scratch_load_dword v252, off, s50 offset:424
		scratch_load_dword v253, off, s50 offset:428
		scratch_load_dword v254, off, s50 offset:432
		scratch_load_dword v255, off, s50 offset:436
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[252:255], v[248:251], v[124:127], v2, v88 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v1 offset:52224
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s50 offset:508
		scratch_store_dword off, v249, s50 offset:512
		scratch_store_dword off, v250, s50 offset:516
		scratch_store_dword off, v251, s50 offset:520
		s_mov_b32 s50, 0
		scratch_load_dword v248, off, s50 offset:252
		scratch_load_dword v249, off, s50 offset:256
		scratch_load_dword v250, off, s50 offset:260
		scratch_load_dword v251, off, s50 offset:264
		s_mov_b32 s50, 0
		scratch_load_dword v252, off, s50 offset:440
		scratch_load_dword v253, off, s50 offset:444
		scratch_load_dword v254, off, s50 offset:448
		scratch_load_dword v255, off, s50 offset:452
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[252:255], v[248:251], v[128:131], v2, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v1, off, s50 offset:504
		s_waitcnt vmcnt(0)
		ds_read_b128 v[248:251], v1 offset:53248
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s50 offset:524
		scratch_store_dword off, v249, s50 offset:528
		scratch_store_dword off, v250, s50 offset:532
		scratch_store_dword off, v251, s50 offset:536
		s_mov_b32 s50, 0
		scratch_load_dword v248, off, s50 offset:268
		scratch_load_dword v249, off, s50 offset:272
		scratch_load_dword v250, off, s50 offset:276
		scratch_load_dword v251, off, s50 offset:280
		s_mov_b32 s50, 0
		scratch_load_dword v252, off, s50 offset:440
		scratch_load_dword v253, off, s50 offset:444
		scratch_load_dword v254, off, s50 offset:448
		scratch_load_dword v255, off, s50 offset:452
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[252:255], v[248:251], v[132:135], v2, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v1, off, s50 offset:504
		s_waitcnt vmcnt(0)
		ds_read_b128 v[248:251], v1 offset:54272
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s50 offset:540
		scratch_store_dword off, v249, s50 offset:544
		scratch_store_dword off, v250, s50 offset:548
		scratch_store_dword off, v251, s50 offset:552
		s_mov_b32 s50, 0
		scratch_load_dword v248, off, s50 offset:284
		scratch_load_dword v249, off, s50 offset:288
		scratch_load_dword v250, off, s50 offset:292
		scratch_load_dword v251, off, s50 offset:296
		s_mov_b32 s50, 0
		scratch_load_dword v252, off, s50 offset:440
		scratch_load_dword v253, off, s50 offset:444
		scratch_load_dword v254, off, s50 offset:448
		scratch_load_dword v255, off, s50 offset:452
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[252:255], v[248:251], v[136:139], v2, v67 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v1, off, s50 offset:504
		s_waitcnt vmcnt(0)
		ds_read_b128 v[248:251], v1 offset:55296
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s50 offset:556
		scratch_store_dword off, v249, s50 offset:560
		scratch_store_dword off, v250, s50 offset:564
		scratch_store_dword off, v251, s50 offset:568
		s_mov_b32 s50, 0
		scratch_load_dword v248, off, s50 offset:300
		scratch_load_dword v249, off, s50 offset:304
		scratch_load_dword v250, off, s50 offset:308
		scratch_load_dword v251, off, s50 offset:312
		s_mov_b32 s50, 0
		scratch_load_dword v252, off, s50 offset:440
		scratch_load_dword v253, off, s50 offset:444
		scratch_load_dword v254, off, s50 offset:448
		scratch_load_dword v255, off, s50 offset:452
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[252:255], v[248:251], v[140:143], v2, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v1, off, s50 offset:504
		s_waitcnt vmcnt(0)
		ds_read_b128 v[248:251], v1 offset:56320
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s50 offset:572
		scratch_store_dword off, v249, s50 offset:576
		scratch_store_dword off, v250, s50 offset:580
		scratch_store_dword off, v251, s50 offset:584
		s_mov_b32 s50, 0
		scratch_load_dword v248, off, s50 offset:360
		scratch_load_dword v249, off, s50 offset:364
		scratch_load_dword v250, off, s50 offset:368
		scratch_load_dword v251, off, s50 offset:372
		s_mov_b32 s50, 0
		scratch_load_dword v252, off, s50 offset:440
		scratch_load_dword v253, off, s50 offset:444
		scratch_load_dword v254, off, s50 offset:448
		scratch_load_dword v255, off, s50 offset:452
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[252:255], v[248:251], v[144:147], v2, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s10
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(42)
		scratch_load_dword v1, off, s50 offset:316
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_mov_b32 s50, 0
		scratch_load_dword v248, off, s50 offset:376
		scratch_load_dword v249, off, s50 offset:380
		scratch_load_dword v250, off, s50 offset:384
		scratch_load_dword v251, off, s50 offset:388
		s_mov_b32 s50, 0
		scratch_load_dword v252, off, s50 offset:440
		scratch_load_dword v253, off, s50 offset:444
		scratch_load_dword v254, off, s50 offset:448
		scratch_load_dword v255, off, s50 offset:452
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[252:255], v[248:251], v[148:151], v2, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s39
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(41)
		scratch_load_dword v1, off, s50 offset:320
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_mov_b32 s50, 0
		scratch_load_dword v248, off, s50 offset:392
		scratch_load_dword v249, off, s50 offset:396
		scratch_load_dword v250, off, s50 offset:400
		scratch_load_dword v251, off, s50 offset:404
		s_mov_b32 s50, 0
		scratch_load_dword v252, off, s50 offset:440
		scratch_load_dword v253, off, s50 offset:444
		scratch_load_dword v254, off, s50 offset:448
		scratch_load_dword v255, off, s50 offset:452
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[252:255], v[248:251], v[152:155], v2, v88 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s40
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(40)
		scratch_load_dword v1, off, s50 offset:324
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_mov_b32 s50, 0
		scratch_load_dword v248, off, s50 offset:408
		scratch_load_dword v249, off, s50 offset:412
		scratch_load_dword v250, off, s50 offset:416
		scratch_load_dword v251, off, s50 offset:420
		s_mov_b32 s50, 0
		scratch_load_dword v252, off, s50 offset:440
		scratch_load_dword v253, off, s50 offset:444
		scratch_load_dword v254, off, s50 offset:448
		scratch_load_dword v255, off, s50 offset:452
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[252:255], v[248:251], v[156:159], v2, v88 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s41
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(39)
		scratch_load_dword v1, off, s50 offset:328
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_mov_b32 s50, 0
		scratch_load_dword v248, off, s50 offset:252
		scratch_load_dword v249, off, s50 offset:256
		scratch_load_dword v250, off, s50 offset:260
		scratch_load_dword v251, off, s50 offset:264
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[228:231], v[248:251], v[160:163], v9, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s42
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(38)
		scratch_load_dword v1, off, s50 offset:332
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v1, s[0:3], 0 offen lds
		s_mov_b32 s50, 0
		scratch_load_dword v248, off, s50 offset:268
		scratch_load_dword v249, off, s50 offset:272
		scratch_load_dword v250, off, s50 offset:276
		scratch_load_dword v251, off, s50 offset:280
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[228:231], v[248:251], v[164:167], v9, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s43
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(37)
		scratch_load_dword v1, off, s50 offset:336
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v1, s[0:3], 0 offen lds
		s_mov_b32 s50, 0
		scratch_load_dword v248, off, s50 offset:284
		scratch_load_dword v249, off, s50 offset:288
		scratch_load_dword v250, off, s50 offset:292
		scratch_load_dword v251, off, s50 offset:296
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[228:231], v[248:251], v[168:171], v9, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s44
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(36)
		scratch_load_dword v1, off, s50 offset:340
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v1, s[0:3], 0 offen lds
		s_mov_b32 s50, 0
		scratch_load_dword v248, off, s50 offset:300
		scratch_load_dword v249, off, s50 offset:304
		scratch_load_dword v250, off, s50 offset:308
		scratch_load_dword v251, off, s50 offset:312
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[228:231], v[248:251], v[172:175], v9, v67 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s45
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(35)
		scratch_load_dword v1, off, s50 offset:344
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v1, s[0:3], 0 offen lds
		s_mov_b32 s50, 0
		scratch_load_dword v248, off, s50 offset:360
		scratch_load_dword v249, off, s50 offset:364
		scratch_load_dword v250, off, s50 offset:368
		scratch_load_dword v251, off, s50 offset:372
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[228:231], v[248:251], v[176:179], v9, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s46, 0x20000
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(34)
		scratch_load_dword v1, off, s50 offset:348
		s_waitcnt vmcnt(0)
		buffer_load_dword v1, s[4:7], 0 offen lds
		s_mov_b32 s50, 0
		scratch_load_dword v248, off, s50 offset:376
		scratch_load_dword v249, off, s50 offset:380
		scratch_load_dword v250, off, s50 offset:384
		scratch_load_dword v251, off, s50 offset:388
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[228:231], v[248:251], v[180:183], v9, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s9, 0x20000
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(33)
		scratch_load_dword v1, off, s50 offset:352
		s_waitcnt vmcnt(0)
		buffer_load_dword v1, s[4:7], 0 offen lds
		s_mov_b32 s50, 0
		scratch_load_dword v248, off, s50 offset:392
		scratch_load_dword v249, off, s50 offset:396
		scratch_load_dword v250, off, s50 offset:400
		scratch_load_dword v251, off, s50 offset:404
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[228:231], v[248:251], v[184:187], v9, v88 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s36, 0x20000
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(32)
		scratch_load_dword v1, off, s50 offset:356
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		s_mov_b32 s50, 0
		scratch_load_dword v248, off, s50 offset:408
		scratch_load_dword v249, off, s50 offset:412
		scratch_load_dword v250, off, s50 offset:416
		scratch_load_dword v251, off, s50 offset:420
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[228:231], v[248:251], v[188:191], v9, v88 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:252
		scratch_load_dword v229, off, s50 offset:256
		scratch_load_dword v230, off, s50 offset:260
		scratch_load_dword v231, off, s50 offset:264
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[232:235], v[228:231], v[192:195], v9, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:268
		scratch_load_dword v229, off, s50 offset:272
		scratch_load_dword v230, off, s50 offset:276
		scratch_load_dword v231, off, s50 offset:280
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[232:235], v[228:231], v[196:199], v9, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:284
		scratch_load_dword v229, off, s50 offset:288
		scratch_load_dword v230, off, s50 offset:292
		scratch_load_dword v231, off, s50 offset:296
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[232:235], v[228:231], v[200:203], v9, v67 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:300
		scratch_load_dword v229, off, s50 offset:304
		scratch_load_dword v230, off, s50 offset:308
		scratch_load_dword v231, off, s50 offset:312
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[232:235], v[228:231], v[204:207], v9, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:360
		scratch_load_dword v229, off, s50 offset:364
		scratch_load_dword v230, off, s50 offset:368
		scratch_load_dword v231, off, s50 offset:372
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[232:235], v[228:231], v[208:211], v9, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:376
		scratch_load_dword v229, off, s50 offset:380
		scratch_load_dword v230, off, s50 offset:384
		scratch_load_dword v231, off, s50 offset:388
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[232:235], v[228:231], v[212:215], v9, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:392
		scratch_load_dword v229, off, s50 offset:396
		scratch_load_dword v230, off, s50 offset:400
		scratch_load_dword v231, off, s50 offset:404
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[232:235], v[228:231], v[216:219], v9, v88 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:408
		scratch_load_dword v229, off, s50 offset:412
		scratch_load_dword v230, off, s50 offset:416
		scratch_load_dword v231, off, s50 offset:420
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[232:235], v[228:231], v[220:223], v9, v88 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(28)
		scratch_load_dword v228, off, s50 offset:456
		scratch_load_dword v229, off, s50 offset:460
		scratch_load_dword v230, off, s50 offset:464
		scratch_load_dword v231, off, s50 offset:468
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[236:239], v[228:231], v[4:7], v2, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v228, off, s50 offset:472
		scratch_load_dword v229, off, s50 offset:476
		scratch_load_dword v230, off, s50 offset:480
		scratch_load_dword v231, off, s50 offset:484
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[236:239], v[228:231], v[68:71], v2, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(20)
		scratch_load_dword v228, off, s50 offset:488
		scratch_load_dword v229, off, s50 offset:492
		scratch_load_dword v230, off, s50 offset:496
		scratch_load_dword v231, off, s50 offset:500
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[236:239], v[228:231], v[76:79], v2, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v228, off, s50 offset:508
		scratch_load_dword v229, off, s50 offset:512
		scratch_load_dword v230, off, s50 offset:516
		scratch_load_dword v231, off, s50 offset:520
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[236:239], v[228:231], v[80:83], v2, v67 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(12)
		scratch_load_dword v228, off, s50 offset:524
		scratch_load_dword v229, off, s50 offset:528
		scratch_load_dword v230, off, s50 offset:532
		scratch_load_dword v231, off, s50 offset:536
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[236:239], v[228:231], v[108:111], v2, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v228, off, s50 offset:540
		scratch_load_dword v229, off, s50 offset:544
		scratch_load_dword v230, off, s50 offset:548
		scratch_load_dword v231, off, s50 offset:552
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[236:239], v[228:231], v[116:119], v2, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v228, off, s50 offset:556
		scratch_load_dword v229, off, s50 offset:560
		scratch_load_dword v230, off, s50 offset:564
		scratch_load_dword v231, off, s50 offset:568
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[236:239], v[228:231], v[120:123], v2, v88 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v228, off, s50 offset:572
		scratch_load_dword v229, off, s50 offset:576
		scratch_load_dword v230, off, s50 offset:580
		scratch_load_dword v231, off, s50 offset:584
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[236:239], v[228:231], v[124:127], v2, v88 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:456
		scratch_load_dword v229, off, s50 offset:460
		scratch_load_dword v230, off, s50 offset:464
		scratch_load_dword v231, off, s50 offset:468
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[240:243], v[228:231], v[128:131], v2, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:472
		scratch_load_dword v229, off, s50 offset:476
		scratch_load_dword v230, off, s50 offset:480
		scratch_load_dword v231, off, s50 offset:484
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[240:243], v[228:231], v[132:135], v2, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:488
		scratch_load_dword v229, off, s50 offset:492
		scratch_load_dword v230, off, s50 offset:496
		scratch_load_dword v231, off, s50 offset:500
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[240:243], v[228:231], v[136:139], v2, v67 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:508
		scratch_load_dword v229, off, s50 offset:512
		scratch_load_dword v230, off, s50 offset:516
		scratch_load_dword v231, off, s50 offset:520
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[240:243], v[228:231], v[140:143], v2, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:524
		scratch_load_dword v229, off, s50 offset:528
		scratch_load_dword v230, off, s50 offset:532
		scratch_load_dword v231, off, s50 offset:536
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[240:243], v[228:231], v[144:147], v2, v75 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:540
		scratch_load_dword v229, off, s50 offset:544
		scratch_load_dword v230, off, s50 offset:548
		scratch_load_dword v231, off, s50 offset:552
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[240:243], v[228:231], v[148:151], v2, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:556
		scratch_load_dword v229, off, s50 offset:560
		scratch_load_dword v230, off, s50 offset:564
		scratch_load_dword v231, off, s50 offset:568
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[240:243], v[228:231], v[152:155], v2, v88 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:572
		scratch_load_dword v229, off, s50 offset:576
		scratch_load_dword v230, off, s50 offset:580
		scratch_load_dword v231, off, s50 offset:584
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[240:243], v[228:231], v[156:159], v2, v88 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:456
		scratch_load_dword v229, off, s50 offset:460
		scratch_load_dword v230, off, s50 offset:464
		scratch_load_dword v231, off, s50 offset:468
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[244:247], v[228:231], v[160:163], v9, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:472
		scratch_load_dword v229, off, s50 offset:476
		scratch_load_dword v230, off, s50 offset:480
		scratch_load_dword v231, off, s50 offset:484
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[244:247], v[228:231], v[164:167], v9, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:488
		scratch_load_dword v229, off, s50 offset:492
		scratch_load_dword v230, off, s50 offset:496
		scratch_load_dword v231, off, s50 offset:500
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[244:247], v[228:231], v[168:171], v9, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:508
		scratch_load_dword v229, off, s50 offset:512
		scratch_load_dword v230, off, s50 offset:516
		scratch_load_dword v231, off, s50 offset:520
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[244:247], v[228:231], v[172:175], v9, v67 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:524
		scratch_load_dword v229, off, s50 offset:528
		scratch_load_dword v230, off, s50 offset:532
		scratch_load_dword v231, off, s50 offset:536
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[244:247], v[228:231], v[176:179], v9, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:540
		scratch_load_dword v229, off, s50 offset:544
		scratch_load_dword v230, off, s50 offset:548
		scratch_load_dword v231, off, s50 offset:552
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[244:247], v[228:231], v[180:183], v9, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:556
		scratch_load_dword v229, off, s50 offset:560
		scratch_load_dword v230, off, s50 offset:564
		scratch_load_dword v231, off, s50 offset:568
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[244:247], v[228:231], v[184:187], v9, v88 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:572
		scratch_load_dword v229, off, s50 offset:576
		scratch_load_dword v230, off, s50 offset:580
		scratch_load_dword v231, off, s50 offset:584
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[244:247], v[228:231], v[188:191], v9, v88 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:456
		scratch_load_dword v229, off, s50 offset:460
		scratch_load_dword v230, off, s50 offset:464
		scratch_load_dword v231, off, s50 offset:468
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[224:227], v[228:231], v[192:195], v9, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:472
		scratch_load_dword v229, off, s50 offset:476
		scratch_load_dword v230, off, s50 offset:480
		scratch_load_dword v231, off, s50 offset:484
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[224:227], v[228:231], v[196:199], v9, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:488
		scratch_load_dword v229, off, s50 offset:492
		scratch_load_dword v230, off, s50 offset:496
		scratch_load_dword v231, off, s50 offset:500
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[224:227], v[228:231], v[200:203], v9, v67 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:508
		scratch_load_dword v229, off, s50 offset:512
		scratch_load_dword v230, off, s50 offset:516
		scratch_load_dword v231, off, s50 offset:520
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[224:227], v[228:231], v[204:207], v9, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:524
		scratch_load_dword v229, off, s50 offset:528
		scratch_load_dword v230, off, s50 offset:532
		scratch_load_dword v231, off, s50 offset:536
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[224:227], v[228:231], v[208:211], v9, v75 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:540
		scratch_load_dword v229, off, s50 offset:544
		scratch_load_dword v230, off, s50 offset:548
		scratch_load_dword v231, off, s50 offset:552
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[224:227], v[228:231], v[212:215], v9, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:556
		scratch_load_dword v229, off, s50 offset:560
		scratch_load_dword v230, off, s50 offset:564
		scratch_load_dword v231, off, s50 offset:568
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[224:227], v[228:231], v[216:219], v9, v88 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		scratch_load_dword v228, off, s50 offset:572
		scratch_load_dword v229, off, s50 offset:576
		scratch_load_dword v230, off, s50 offset:580
		scratch_load_dword v231, off, s50 offset:584
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[224:227], v[228:231], v[220:223], v9, v88 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s47, s47, 2
		s_cmp_lt_i32 s47, s11
		s_mov_b32 s50, 0
		scratch_load_dword v224, off, s50 offset:196
		scratch_load_dword v225, off, s50 offset:200
		scratch_load_dword v226, off, s50 offset:204
		scratch_load_dword v227, off, s50 offset:208
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v32, v224
		v_mov_b32_e32 v33, v225
		v_mov_b32_e32 v34, v226
		v_mov_b32_e32 v35, v227
		s_mov_b32 s50, 0
		scratch_load_dword v1, off, s50 offset:216
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v3, v1
		s_mov_b32 s50, 0
		scratch_load_dword v1, off, s50 offset:220
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v13, v1
		s_mov_b32 s50, 0
		scratch_load_dword v1, off, s50 offset:228
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v8, v1
		s_mov_b32 s50, 0
		scratch_load_dword v1, off, s50 offset:232
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v64, v1
		s_mov_b32 s50, 0
		scratch_load_dword v1, off, s50 offset:236
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v65, v1
		s_mov_b32 s50, 0
		scratch_load_dword v1, off, s50 offset:240
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v66, v1
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_add_i32 s0, s12, -1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[20:23], v[16:19], v[4:7], v3, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s1, s0, 1
		s_lshl_b32 s0, s1, 16
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v2, 12, v1
		v_add_u32_e32 v1, s0, v2
		v_and_b32_e32 v9, 15, v0
		v_lshlrev_b32_e32 v10, 6, v9
		v_and_b32_e32 v9, 63, v0
		v_lshrrev_b32_e32 v11, 4, v9
		v_and_b32_e32 v9, 15, v0
		v_lshrrev_b32_e32 v12, 1, v9
		v_and_b32_e32 v9, 3, v12
		v_xor_b32_e32 v12, v11, v9
		v_lshlrev_b32_e32 v9, 4, v12
		v_add3_u32 v11, v1, v10, v9
		ds_read_b128 v[72:75], v11 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[20:23], v[36:39], v[68:71], v3, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[84:87], v11 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[20:23], v[40:43], v[76:79], v3, v64 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v11 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[20:23], v[44:47], v[80:83], v3, v64 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v11 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[20:23], v[48:51], v[108:111], v3, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, s0, v10
		v_lshrrev_b32_e32 v11, 6, v0
		v_and_b32_e32 v12, 1, v11
		v_lshlrev_b32_e32 v11, 13, v12
		v_add3_u32 v12, v1, v11, v9
		ds_read_b128 v[96:99], v12 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[20:23], v[52:55], v[116:119], v3, v65 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v12 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], v[56:59], v[120:123], v3, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[104:107], v12 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], v[60:63], v[124:127], v3, v66 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v12 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[24:27], v[16:19], v[128:131], v3, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[112:115], v12 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[24:27], v[36:39], v[132:135], v3, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v12 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[24:27], v[40:43], v[136:139], v3, v64 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v12 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[24:27], v[44:47], v[140:143], v3, v64 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[232:235], v12 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[48:51], v[144:147], v3, v65 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[52:55], v[148:151], v3, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[56:59], v[152:155], v3, v66 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[60:63], v[156:159], v3, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[28:31], v[16:19], v[160:163], v13, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[28:31], v[36:39], v[164:167], v13, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[28:31], v[40:43], v[168:171], v13, v64 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[28:31], v[44:47], v[172:175], v13, v64 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[48:51], v[176:179], v13, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[52:55], v[180:183], v13, v65 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[56:59], v[184:187], v13, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[60:63], v[188:191], v13, v66 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[32:35], v[16:19], v[192:195], v13, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[32:35], v[36:39], v[196:199], v13, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[32:35], v[40:43], v[200:203], v13, v64 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[32:35], v[44:47], v[204:207], v13, v64 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[48:51], v[208:211], v13, v65 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[52:55], v[212:215], v13, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[56:59], v[216:219], v13, v66 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[32:35], v[60:63], v[220:223], v13, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[72:75], v[96:99], v[4:7], v3, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[72:75], v[100:103], v[68:71], v3, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[72:75], v[104:107], v[76:79], v3, v64 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[72:75], v[20:23], v[80:83], v3, v64 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[72:75], v[112:115], v[108:111], v3, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[72:75], v[224:227], v[116:119], v3, v65 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[72:75], v[228:231], v[120:123], v3, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[72:75], v[232:235], v[124:127], v3, v66 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[84:87], v[96:99], v[128:131], v3, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[84:87], v[100:103], v[132:135], v3, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[84:87], v[104:107], v[136:139], v3, v64 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[84:87], v[20:23], v[140:143], v3, v64 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[84:87], v[112:115], v[144:147], v3, v65 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[84:87], v[224:227], v[148:151], v3, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[84:87], v[228:231], v[152:155], v3, v66 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[84:87], v[232:235], v[156:159], v3, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[88:91], v[96:99], v[160:163], v13, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[88:91], v[100:103], v[164:167], v13, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[88:91], v[104:107], v[168:171], v13, v64 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[88:91], v[20:23], v[172:175], v13, v64 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[88:91], v[112:115], v[176:179], v13, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[88:91], v[224:227], v[180:183], v13, v65 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[88:91], v[228:231], v[184:187], v13, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[88:91], v[232:235], v[188:191], v13, v66 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[92:95], v[96:99], v[192:195], v13, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[92:95], v[100:103], v[196:199], v13, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[92:95], v[104:107], v[200:203], v13, v64 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[92:95], v[20:23], v[204:207], v13, v64 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[92:95], v[112:115], v[208:211], v13, v65 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[92:95], v[224:227], v[212:215], v13, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[92:95], v[228:231], v[216:219], v13, v66 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[92:95], v[232:235], v[220:223], v13, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s0, s12, 1
		s_lshl_b32 s1, s0, 16
		v_add_u32_e32 v1, s1, v2
		v_add3_u32 v2, v1, v10, v9
		ds_read_b128 v[12:15], v2
		ds_read_b128 v[16:19], v2 offset:1024
		ds_read_b128 v[20:23], v2 offset:2048
		ds_read_b128 v[24:27], v2 offset:3072
		v_add_u32_e32 v1, s1, v10
		v_add3_u32 v3, v1, v11, v9
		ds_read_b128 v[8:11], v3 offset:32768
		ds_read_b128 v[28:31], v3 offset:33792
		ds_read_b128 v[32:35], v3 offset:34816
		ds_read_b128 v[36:39], v3 offset:35840
		ds_read_b128 v[40:43], v3 offset:36864
		ds_read_b128 v[44:47], v3 offset:37888
		ds_read_b128 v[48:51], v3 offset:38912
		ds_read_b128 v[52:55], v3 offset:39936
		s_lshl_b32 s1, s0, 12
		s_add_i32 s0, s1, 0x20000
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v56, 9, v1
		v_and_b32_e32 v1, 63, v0
		v_lshlrev_b32_e32 v57, 2, v1
		v_add3_u32 v1, s0, v56, v57
		ds_read_b32 v56, v1
		ds_read_b32 v58, v1 offset:256
		v_lshrrev_b32_e32 v1, 6, v0
		v_and_b32_e32 v0, 1, v1
		v_lshlrev_b32_e32 v1, 10, v0
		v_add3_u32 v0, s0, v57, v1
		ds_read_b32 v1, v0 offset:2048
		ds_read_b32 v57, v0 offset:2304
		ds_read_b32 v59, v0 offset:2560
		ds_read_b32 v60, v0 offset:2816
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[12:15], v[8:11], v[4:7], v56, v1 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[64:67], v2 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[12:15], v[28:31], v[68:71], v56, v1 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[72:75], v2 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[12:15], v[32:35], v[76:79], v56, v57 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[84:87], v2 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[12:15], v[36:39], v[80:83], v56, v57 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v2 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[12:15], v[40:43], v[108:111], v56, v59 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v3 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[12:15], v[44:47], v[116:119], v56, v59 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v3 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[12:15], v[48:51], v[120:123], v56, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v3 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[12:15], v[52:55], v[124:127], v56, v60 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[12:15], v3 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[8:11], v[128:131], v56, v1 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[104:107], v3 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[16:19], v[28:31], v[132:135], v56, v1 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[112:115], v3 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[32:35], v[136:139], v56, v57 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v3 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[16:19], v[36:39], v[140:143], v56, v57 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v3 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[16:19], v[40:43], v[144:147], v56, v59 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[16:19], v[44:47], v[148:151], v56, v59 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[16:19], v[48:51], v[152:155], v56, v60 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[16:19], v[52:55], v[156:159], v56, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[8:11], v[160:163], v58, v1 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[28:31], v[164:167], v58, v1 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[32:35], v[168:171], v58, v57 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[36:39], v[172:175], v58, v57 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[20:23], v[40:43], v[176:179], v58, v59 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[20:23], v[44:47], v[180:183], v58, v59 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[20:23], v[48:51], v[184:187], v58, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[20:23], v[52:55], v[188:191], v58, v60 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[8:11], v[192:195], v58, v1 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[28:31], v[196:199], v58, v1 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[32:35], v[200:203], v58, v57 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[36:39], v[204:207], v58, v57 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], v[40:43], v[208:211], v58, v59 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[24:27], v[44:47], v[212:215], v58, v59 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[24:27], v[48:51], v[216:219], v58, v60 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[24:27], v[52:55], v[220:223], v58, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[64:67], v[92:95], v[4:7], v56, v1 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[64:67], v[96:99], v[68:71], v56, v1 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[64:67], v[100:103], v[76:79], v56, v57 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[64:67], v[12:15], v[80:83], v56, v57 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[64:67], v[104:107], v[108:111], v56, v59 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[64:67], v[112:115], v[116:119], v56, v59 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[64:67], v[224:227], v[120:123], v56, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[64:67], v[228:231], v[124:127], v56, v60 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[72:75], v[92:95], v[128:131], v56, v1 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[72:75], v[96:99], v[132:135], v56, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[72:75], v[100:103], v[136:139], v56, v57 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[72:75], v[12:15], v[140:143], v56, v57 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[72:75], v[104:107], v[144:147], v56, v59 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[72:75], v[112:115], v[148:151], v56, v59 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[72:75], v[224:227], v[152:155], v56, v60 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[72:75], v[228:231], v[156:159], v56, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[84:87], v[92:95], v[160:163], v58, v1 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[84:87], v[96:99], v[164:167], v58, v1 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[84:87], v[100:103], v[168:171], v58, v57 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[84:87], v[12:15], v[172:175], v58, v57 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[84:87], v[104:107], v[176:179], v58, v59 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[84:87], v[112:115], v[180:183], v58, v59 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[84:87], v[224:227], v[184:187], v58, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[84:87], v[228:231], v[188:191], v58, v60 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[88:91], v[92:95], v[192:195], v58, v1 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[88:91], v[96:99], v[196:199], v58, v1 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[88:91], v[100:103], v[200:203], v58, v57 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[88:91], v[12:15], v[204:207], v58, v57 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[88:91], v[104:107], v[208:211], v58, v59 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[88:91], v[112:115], v[212:215], v58, v59 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[88:91], v[224:227], v[216:219], v58, v60 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[88:91], v[228:231], v[220:223], v58, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v4, v5
		v_cvt_pk_f16_f32 v1, v6, v7
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v2 offset:2048
		s_waitcnt lgkmcnt(0)
		v_lshlrev_b32_e32 v3, 3, v2
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v2
		s_waitcnt lgkmcnt(0)
		v_lshl_add_u32 v4, v2, 14, v3
		s_lshl_b32 s0, s13, 21
		s_lshl_b32 s1, s14, 17
		s_add_i32 s2, s0, s1
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen
		v_cvt_pk_f16_f32 v0, v68, v69
		v_cvt_pk_f16_f32 v1, v70, v71
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:512
		v_cvt_pk_f16_f32 v0, v76, v77
		v_cvt_pk_f16_f32 v1, v78, v79
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:1024
		v_cvt_pk_f16_f32 v0, v80, v81
		v_cvt_pk_f16_f32 v1, v82, v83
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:1536
		v_cvt_pk_f16_f32 v0, v108, v109
		v_cvt_pk_f16_f32 v1, v110, v111
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:2048
		v_cvt_pk_f16_f32 v0, v116, v117
		v_cvt_pk_f16_f32 v1, v118, v119
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:2560
		v_cvt_pk_f16_f32 v0, v120, v121
		v_cvt_pk_f16_f32 v1, v122, v123
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:3072
		v_cvt_pk_f16_f32 v0, v124, v125
		v_cvt_pk_f16_f32 v1, v126, v127
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:3584
		v_cvt_pk_f16_f32 v0, v128, v129
		v_cvt_pk_f16_f32 v1, v130, v131
		s_add_i32 s2, s0, 0x1000
		s_add_i32 s3, s2, s1
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen
		v_cvt_pk_f16_f32 v0, v132, v133
		v_cvt_pk_f16_f32 v1, v134, v135
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:512
		v_cvt_pk_f16_f32 v0, v136, v137
		v_cvt_pk_f16_f32 v1, v138, v139
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:1024
		v_cvt_pk_f16_f32 v0, v140, v141
		v_cvt_pk_f16_f32 v1, v142, v143
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:1536
		v_cvt_pk_f16_f32 v0, v144, v145
		v_cvt_pk_f16_f32 v1, v146, v147
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:2048
		v_cvt_pk_f16_f32 v0, v148, v149
		v_cvt_pk_f16_f32 v1, v150, v151
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:2560
		v_cvt_pk_f16_f32 v0, v152, v153
		v_cvt_pk_f16_f32 v1, v154, v155
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:3072
		v_cvt_pk_f16_f32 v0, v156, v157
		v_cvt_pk_f16_f32 v1, v158, v159
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:3584
		v_cvt_pk_f16_f32 v0, v160, v161
		v_cvt_pk_f16_f32 v1, v162, v163
		s_add_i32 s2, s0, 0x2000
		s_add_i32 s3, s2, s1
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen
		v_cvt_pk_f16_f32 v0, v164, v165
		v_cvt_pk_f16_f32 v1, v166, v167
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:512
		v_cvt_pk_f16_f32 v0, v168, v169
		v_cvt_pk_f16_f32 v1, v170, v171
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:1024
		v_cvt_pk_f16_f32 v0, v172, v173
		v_cvt_pk_f16_f32 v1, v174, v175
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:1536
		v_cvt_pk_f16_f32 v0, v176, v177
		v_cvt_pk_f16_f32 v1, v178, v179
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:2048
		v_cvt_pk_f16_f32 v0, v180, v181
		v_cvt_pk_f16_f32 v1, v182, v183
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:2560
		v_cvt_pk_f16_f32 v0, v184, v185
		v_cvt_pk_f16_f32 v1, v186, v187
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:3072
		v_cvt_pk_f16_f32 v0, v188, v189
		v_cvt_pk_f16_f32 v1, v190, v191
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:3584
		v_cvt_pk_f16_f32 v0, v192, v193
		v_cvt_pk_f16_f32 v1, v194, v195
		s_add_i32 s2, s0, 0x3000
		s_add_i32 s0, s2, s1
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen
		v_cvt_pk_f16_f32 v0, v196, v197
		v_cvt_pk_f16_f32 v1, v198, v199
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:512
		v_cvt_pk_f16_f32 v0, v200, v201
		v_cvt_pk_f16_f32 v1, v202, v203
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:1024
		v_cvt_pk_f16_f32 v0, v204, v205
		v_cvt_pk_f16_f32 v1, v206, v207
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:1536
		v_cvt_pk_f16_f32 v0, v208, v209
		v_cvt_pk_f16_f32 v1, v210, v211
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:2048
		v_cvt_pk_f16_f32 v0, v212, v213
		v_cvt_pk_f16_f32 v1, v214, v215
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:2560
		v_cvt_pk_f16_f32 v0, v216, v217
		v_cvt_pk_f16_f32 v1, v218, v219
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:3072
		v_cvt_pk_f16_f32 v0, v220, v221
		v_cvt_pk_f16_f32 v1, v222, v223
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:3584
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 24576
		.amdhsa_private_segment_fixed_size 588
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
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 588
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
    .private_segment_fixed_size: 588
    .sgpr_count:     53
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     256
    .agpr_count:     0
    .vgpr_spill_count: 147
    .wavefront_size: 64
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
