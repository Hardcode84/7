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
		s_add_i32 s28, s15, 0x2000
		s_add_i32 s29, s15, 0x4000
		s_add_i32 s30, s15, 0x6000
		s_add_i32 s31, s15, 0x8000
		s_add_i32 s32, s15, 0xa000
		s_add_i32 s33, s15, 0xc000
		s_add_i32 s34, s15, 0xe000
		s_mov_b32 m0, s15
		s_nop 0
		buffer_load_dwordx4 v9, s[20:23], 0 offen lds
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v11, s[20:23], 0 offen lds
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v13, s[0:3], 0 offen lds
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v14, s[0:3], 0 offen lds
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v15, s[0:3], 0 offen lds
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v16, s[0:3], 0 offen lds
		s_lshl_b32 s35, s14, 16
		s_add_i32 s36, s9, s35
		v_and_b32_e32 v1, 63, v0
		v_lshrrev_b32_e32 v9, 7, v0
		v_lshlrev_b32_e32 v10, 9, v9
		v_lshlrev_b32_e32 v9, 2, v1
		v_add3_u32 v11, s36, v10, v9
		s_lshr_b32 s37, s8, 7
		s_lshl_b32 s8, s37, 9
		s_add_i32 s37, s9, 0x100
		s_add_i32 s38, s37, s35
		v_lshrrev_b32_e32 v9, 7, v0
		v_lshlrev_b32_e32 v10, 9, v9
		v_lshlrev_b32_e32 v9, 2, v1
		v_add3_u32 v12, s38, v10, v9
		s_add_i32 s37, s8, 0x100
		v_and_b32_e32 v9, 63, v0
		v_lshlrev_b32_e32 v10, 4, v9
		v_accvgpr_read_b32 v9, a0
		v_and_b32_e32 v13, 1, v9
		v_lshlrev_b32_e32 v9, 10, v13
		v_add3_u32 v14, s36, v10, v9
		s_and_b32 s36, s11, 1
		s_lshl_b32 s11, s36, 10
		s_add_i32 s36, s11, 0x800
		s_add_i32 m0, s8, 0x20000
		s_nop 0
		buffer_load_dword v11, s[4:7], 0 offen lds
		s_add_i32 m0, s8, 0x20100
		s_nop 0
		buffer_load_dword v12, s[4:7], 0 offen lds
		s_add_i32 m0, s11, 0x20800
		s_nop 0
		buffer_load_dwordx4 v14, s[24:27], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		v_and_b32_e32 v9, 15, v0
		v_and_b32_e32 v11, 63, v0
		v_lshrrev_b32_e32 v12, 4, v11
		v_lshrrev_b32_e32 v11, 1, v9
		v_and_b32_e32 v9, 3, v11
		v_xor_b32_e32 v11, v12, v9
		v_lshrrev_b32_e32 v9, 7, v0
		v_lshlrev_b32_e32 v12, 12, v9
		v_and_b32_e32 v9, 15, v0
		v_lshlrev_b32_e32 v14, 6, v9
		v_lshlrev_b32_e32 v9, 4, v11
		v_add3_u32 v15, v12, v14, v9
		ds_read_b128 v[16:19], v15
		ds_read_b128 v[20:23], v15 offset:1024
		ds_read_b128 v[24:27], v15 offset:2048
		ds_read_b128 v[28:31], v15 offset:3072
		v_lshlrev_b32_e32 v9, 13, v13
		v_and_b32_e32 v12, 15, v0
		v_lshlrev_b32_e32 v14, 6, v12
		v_lshlrev_b32_e32 v12, 4, v11
		v_add3_u32 v15, v14, v9, v12
		ds_read_b128 v[32:35], v15 offset:32768
		ds_read_b128 v[36:39], v15 offset:33792
		ds_read_b128 v[40:43], v15 offset:34816
		ds_read_b128 v[44:47], v15 offset:35840
		ds_read_b128 v[48:51], v15 offset:36864
		ds_read_b128 v[52:55], v15 offset:37888
		ds_read_b128 v[56:59], v15 offset:38912
		ds_read_b128 v[60:63], v15 offset:39936
		v_lshrrev_b32_e32 v9, 7, v0
		v_lshlrev_b32_e32 v12, 9, v9
		v_add_u32_e32 v9, 0x20000, v12
		v_lshlrev_b32_e32 v12, 2, v1
		v_add_u32_e32 v14, v9, v12
		ds_read_b32 v9, v14
		ds_read_b32 v12, v14 offset:256
		v_lshlrev_b32_e32 v14, 2, v1
		v_add_u32_e32 v15, 0x20000, v14
		v_lshlrev_b32_e32 v14, 10, v13
		v_add_u32_e32 v64, v15, v14
		ds_read_b32 v14, v64 offset:2048
		ds_read_b32 v15, v64 offset:2304
		ds_read_b32 v65, v64 offset:2560
		ds_read_b32 v66, v64 offset:2816
		s_waitcnt lgkmcnt(0)
		s_add_i32 s38, s9, 0x80
		v_add_u32_e32 v64, s38, v2
		v_add3_u32 v67, v64, v3, v8
		s_add_i32 s38, s9, 0x80080
		v_add_u32_e32 v64, s38, v2
		v_add3_u32 v68, v64, v3, v8
		s_add_i32 s38, s9, 0xc0
		v_add_u32_e32 v64, s38, v2
		v_add3_u32 v69, v64, v3, v8
		s_add_i32 s38, s9, 0x800c0
		v_add_u32_e32 v64, s38, v2
		v_add3_u32 v70, v64, v3, v8
		s_add_i32 s38, s10, 0x80
		v_add_u32_e32 v64, s38, v2
		v_add3_u32 v71, v64, v3, v8
		s_add_i32 s38, s10, 0x80080
		v_add_u32_e32 v64, s38, v2
		v_add3_u32 v72, v64, v3, v8
		s_add_i32 s38, s10, 0xc0
		v_add_u32_e32 v64, s38, v2
		v_add3_u32 v73, v64, v3, v8
		s_add_i32 s38, s10, 0x800c0
		v_add_u32_e32 v64, s38, v2
		v_add3_u32 v2, v64, v3, v8
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
		buffer_load_dwordx4 v67, s[20:23], 0 offen lds
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v68, s[20:23], 0 offen lds
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v69, s[20:23], 0 offen lds
		s_mov_b32 m0, s40
		s_nop 0
		buffer_load_dwordx4 v70, s[20:23], 0 offen lds
		s_mov_b32 m0, s41
		s_nop 0
		buffer_load_dwordx4 v71, s[0:3], 0 offen lds
		s_mov_b32 m0, s42
		s_nop 0
		buffer_load_dwordx4 v72, s[0:3], 0 offen lds
		s_mov_b32 m0, s43
		s_nop 0
		buffer_load_dwordx4 v73, s[0:3], 0 offen lds
		s_mov_b32 m0, s44
		s_nop 0
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_add_i32 s45, s9, 0x800
		s_add_i32 s46, s45, s35
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 9, v2
		v_lshlrev_b32_e32 v2, 2, v1
		v_add3_u32 v8, s46, v3, v2
		s_add_i32 s45, s8, 0x1000
		s_add_i32 s47, s9, 0x900
		s_add_i32 s9, s47, s35
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 9, v2
		v_lshlrev_b32_e32 v2, 2, v1
		v_add3_u32 v64, s9, v3, v2
		s_add_i32 s9, s8, 0x1100
		v_lshlrev_b32_e32 v2, 10, v13
		v_add3_u32 v3, s46, v10, v2
		s_add_i32 s35, s11, 0x1800
		s_add_i32 m0, s8, 0x21000
		s_nop 0
		buffer_load_dword v8, s[4:7], 0 offen lds
		s_add_i32 m0, s8, 0x21100
		s_nop 0
		buffer_load_dword v64, s[4:7], 0 offen lds
		s_add_i32 m0, s11, 0x21800
		s_nop 0
		buffer_load_dwordx4 v3, s[24:27], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s11, s12, 1
		s_mov_b32 s46, 2
		v_mov_b32_e32 v2, s13
		v_mov_b32_e32 v3, 0
		s_mov_b32 s48, 0x100000
		s_mov_b32 s49, 0
		v_mov_b32_e32 v68, s48
		v_mov_b32_e32 v69, s49
		v_mul_lo_u32 v70, v68, v2
		v_mul_hi_u32 v71, v68, v2
		v_mul_lo_u32 v8, v68, v3
		v_add_u32_e32 v71, v71, v8
		v_mul_lo_u32 v8, v69, v2
		v_add_u32_e32 v71, v71, v8
		s_mov_b32 s48, 1
		s_mov_b32 s49, 0
		v_mov_b32_e32 v72, v0
		v_mov_b32_e32 v73, 0
		v_mov_b32_e32 v74, s48
		v_mov_b32_e32 v75, s49
		v_mul_lo_u32 v76, v74, v72
		v_mul_hi_u32 v77, v74, v72
		v_mul_lo_u32 v2, v74, v73
		v_add_u32_e32 v77, v77, v2
		v_mul_lo_u32 v2, v75, v72
		v_add_u32_e32 v77, v77, v2
		v_lshrrev_b64 v[78:79], 6, v[76:77]
		s_mov_b32 s48, 0x10000
		s_mov_b32 s49, 0
		v_mov_b32_e32 v80, s48
		v_mov_b32_e32 v81, s49
		v_mul_lo_u32 v82, v80, v78
		v_mul_hi_u32 v83, v80, v78
		v_mul_lo_u32 v2, v80, v79
		v_add_u32_e32 v83, v83, v2
		v_mul_lo_u32 v2, v81, v78
		v_add_u32_e32 v83, v83, v2
		v_add_co_u32_e64 v84, vcc, v70, v82
		v_addc_co_u32_e64 v85, vcc, v71, v83, vcc
		v_mov_b32_e32 v2, 63
		v_and_b32_e32 v86, v72, v2
		v_and_b32_e32 v87, v3, v3
		v_mul_lo_u32 v72, v74, v86
		v_mul_hi_u32 v73, v74, v86
		v_mul_lo_u32 v2, v74, v87
		v_add_u32_e32 v73, v73, v2
		v_mul_lo_u32 v2, v75, v86
		v_add_u32_e32 v73, v73, v2
		v_lshrrev_b64 v[74:75], 2, v[72:73]
		s_mov_b32 s48, 0x1000
		s_mov_b32 s49, 0
		v_mov_b32_e32 v88, s48
		v_mov_b32_e32 v89, s49
		v_mul_lo_u32 v90, v88, v74
		v_mul_hi_u32 v91, v88, v74
		v_mul_lo_u32 v2, v88, v75
		v_add_u32_e32 v91, v91, v2
		v_mul_lo_u32 v2, v89, v74
		v_add_u32_e32 v91, v91, v2
		v_add_co_u32_e64 v74, vcc, v84, v90
		v_addc_co_u32_e64 v75, vcc, v85, v91, vcc
		v_lshrrev_b64 v[84:85], 3, v[72:73]
		v_mov_b32_e32 v2, 3
		v_and_b32_e32 v72, v84, v2
		v_and_b32_e32 v73, v85, v3
		v_and_b32_e32 v84, v86, v2
		v_and_b32_e32 v85, v87, v3
		v_xor_b32_e32 v88, v72, v84
		v_xor_b32_e32 v89, v73, v85
		s_mov_b32 s48, 16
		s_mov_b32 s49, 0
		v_mov_b32_e32 v72, s48
		v_mov_b32_e32 v73, s49
		v_mul_lo_u32 v84, v72, v88
		v_mul_hi_u32 v85, v72, v88
		v_mul_lo_u32 v2, v72, v89
		v_add_u32_e32 v85, v85, v2
		v_mul_lo_u32 v2, v73, v88
		v_add_u32_e32 v85, v85, v2
		v_add_co_u32_e64 v88, vcc, v74, v84
		v_addc_co_u32_e64 v89, vcc, v75, v85, vcc
		v_lshlrev_b32_e32 v2, 2, v0
		ds_write_b32 v2, v88
		v_lshlrev_b32_e32 v2, 2, v0
		ds_write_b32 v2, v89 offset:2048
		s_mov_b32 s48, 0x80
		s_mov_b32 s49, 0
		v_mov_b32_e32 v74, s48
		v_mov_b32_e32 v75, s49
		v_lshlrev_b32_e32 v2, 2, v0
		ds_write_b32 v2, v74 offset:4096
		v_lshlrev_b32_e32 v2, 2, v0
		ds_write_b32 v2, v75 offset:6144
		v_mov_b32_e32 v2, 0x80000
		v_add_co_u32_e64 v74, vcc, v70, v2
		v_addc_co_u32_e64 v75, vcc, v71, 0, vcc
		v_add_co_u32_e64 v88, vcc, v74, v82
		v_addc_co_u32_e64 v89, vcc, v75, v83, vcc
		v_add_co_u32_e64 v74, vcc, v88, v90
		v_addc_co_u32_e64 v75, vcc, v89, v91, vcc
		v_add_co_u32_e64 v88, vcc, v74, v84
		v_addc_co_u32_e64 v89, vcc, v75, v85, vcc
		v_lshlrev_b32_e32 v8, 2, v0
		ds_write_b32 v8, v88 offset:8192
		v_lshlrev_b32_e32 v8, 2, v0
		ds_write_b32 v8, v89 offset:10240
		v_mov_b32_e32 v8, 64
		v_add_co_u32_e64 v74, vcc, v70, v8
		v_addc_co_u32_e64 v75, vcc, v71, 0, vcc
		v_add_co_u32_e64 v88, vcc, v74, v82
		v_addc_co_u32_e64 v89, vcc, v75, v83, vcc
		v_add_co_u32_e64 v74, vcc, v88, v90
		v_addc_co_u32_e64 v75, vcc, v89, v91, vcc
		v_add_co_u32_e64 v88, vcc, v74, v84
		v_addc_co_u32_e64 v89, vcc, v75, v85, vcc
		v_lshlrev_b32_e32 v10, 2, v0
		ds_write_b32 v10, v88 offset:12288
		v_lshlrev_b32_e32 v10, 2, v0
		ds_write_b32 v10, v89 offset:14336
		v_mov_b32_e32 v10, 0x80040
		v_add_co_u32_e64 v74, vcc, v70, v10
		v_addc_co_u32_e64 v75, vcc, v71, 0, vcc
		v_add_co_u32_e64 v88, vcc, v74, v82
		v_addc_co_u32_e64 v89, vcc, v75, v83, vcc
		v_add_co_u32_e64 v74, vcc, v88, v90
		v_addc_co_u32_e64 v75, vcc, v89, v91, vcc
		v_add_co_u32_e64 v88, vcc, v74, v84
		v_addc_co_u32_e64 v89, vcc, v75, v85, vcc
		v_lshlrev_b32_e32 v64, 2, v0
		ds_write_b32 v64, v88 offset:16384
		v_lshlrev_b32_e32 v64, 2, v0
		ds_write_b32 v64, v89 offset:18432
		v_mov_b32_e32 v74, s14
		v_mov_b32_e32 v75, 0
		v_mul_lo_u32 v88, v68, v74
		v_mul_hi_u32 v89, v68, v74
		v_mul_lo_u32 v64, v68, v75
		v_add_u32_e32 v89, v89, v64
		v_mul_lo_u32 v64, v69, v74
		v_add_u32_e32 v89, v89, v64
		v_add_co_u32_e64 v68, vcc, v88, v82
		v_addc_co_u32_e64 v69, vcc, v89, v83, vcc
		v_add_co_u32_e64 v92, vcc, v68, v90
		v_addc_co_u32_e64 v93, vcc, v69, v91, vcc
		v_add_co_u32_e64 v68, vcc, v92, v84
		v_addc_co_u32_e64 v69, vcc, v93, v85, vcc
		v_lshlrev_b32_e32 v64, 2, v0
		ds_write_b32 v64, v68 offset:20480
		v_lshlrev_b32_e32 v64, 2, v0
		ds_write_b32 v64, v69 offset:22528
		v_add_co_u32_e64 v68, vcc, v88, v2
		v_addc_co_u32_e64 v69, vcc, v89, 0, vcc
		v_add_co_u32_e64 v92, vcc, v68, v82
		v_addc_co_u32_e64 v93, vcc, v69, v83, vcc
		v_add_co_u32_e64 v68, vcc, v92, v90
		v_addc_co_u32_e64 v69, vcc, v93, v91, vcc
		v_add_co_u32_e64 v92, vcc, v68, v84
		v_addc_co_u32_e64 v93, vcc, v69, v85, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v92, s47
		scratch_store_dword off, v93, s47 offset:4
		v_add_co_u32_e64 v68, vcc, v88, v8
		v_addc_co_u32_e64 v69, vcc, v89, 0, vcc
		v_add_co_u32_e64 v92, vcc, v68, v82
		v_addc_co_u32_e64 v93, vcc, v69, v83, vcc
		v_add_co_u32_e64 v68, vcc, v92, v90
		v_addc_co_u32_e64 v69, vcc, v93, v91, vcc
		v_add_co_u32_e64 v92, vcc, v68, v84
		v_addc_co_u32_e64 v93, vcc, v69, v85, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v92, s47 offset:8
		scratch_store_dword off, v93, s47 offset:12
		v_add_co_u32_e64 v68, vcc, v88, v10
		v_addc_co_u32_e64 v69, vcc, v89, 0, vcc
		v_add_co_u32_e64 v92, vcc, v68, v82
		v_addc_co_u32_e64 v93, vcc, v69, v83, vcc
		v_add_co_u32_e64 v68, vcc, v92, v90
		v_addc_co_u32_e64 v69, vcc, v93, v91, vcc
		v_add_co_u32_e64 v92, vcc, v68, v84
		v_addc_co_u32_e64 v93, vcc, v69, v85, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v92, s47 offset:16
		scratch_store_dword off, v93, s47 offset:20
		v_mul_lo_u32 v68, v80, v74
		v_mul_hi_u32 v69, v80, v74
		v_mul_lo_u32 v2, v80, v75
		v_add_u32_e32 v69, v69, v2
		v_mul_lo_u32 v2, v81, v74
		v_add_u32_e32 v69, v69, v2
		v_add_co_u32_e64 v74, vcc, v70, v68
		v_addc_co_u32_e64 v75, vcc, v71, v69, vcc
		v_lshrrev_b64 v[80:81], 7, v[76:77]
		s_mov_b32 s48, 0x200
		s_mov_b32 s49, 0
		v_mov_b32_e32 v76, s48
		v_mov_b32_e32 v77, s49
		v_mul_lo_u32 v92, v76, v80
		v_mul_hi_u32 v93, v76, v80
		v_mul_lo_u32 v2, v76, v81
		v_add_u32_e32 v93, v93, v2
		v_mul_lo_u32 v2, v77, v80
		v_add_u32_e32 v93, v93, v2
		v_add_co_u32_e64 v76, vcc, v74, v92
		v_addc_co_u32_e64 v77, vcc, v75, v93, vcc
		s_mov_b32 s48, 4
		s_mov_b32 s49, 0
		v_mov_b32_e32 v80, s48
		v_mov_b32_e32 v81, s49
		v_mul_lo_u32 v94, v80, v86
		v_mul_hi_u32 v95, v80, v86
		v_mul_lo_u32 v2, v80, v87
		v_add_u32_e32 v95, v95, v2
		v_mul_lo_u32 v2, v81, v86
		v_add_u32_e32 v95, v95, v2
		v_add_co_u32_e64 v80, vcc, v76, v94
		v_addc_co_u32_e64 v81, vcc, v77, v95, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v80, s47 offset:24
		scratch_store_dword off, v81, s47 offset:28
		s_mov_b32 s48, 0x800
		s_mov_b32 s49, 0
		v_mov_b32_e32 v76, s48
		v_mov_b32_e32 v77, s49
		s_mov_b32 s47, 0
		scratch_store_dword off, v76, s47 offset:32
		scratch_store_dword off, v77, s47 offset:36
		v_mov_b32_e32 v2, 0x100
		v_add_co_u32_e64 v76, vcc, v70, v2
		v_addc_co_u32_e64 v77, vcc, v71, 0, vcc
		v_add_co_u32_e64 v80, vcc, v76, v68
		v_addc_co_u32_e64 v81, vcc, v77, v69, vcc
		v_add_co_u32_e64 v76, vcc, v80, v92
		v_addc_co_u32_e64 v77, vcc, v81, v93, vcc
		v_add_co_u32_e64 v80, vcc, v76, v94
		v_addc_co_u32_e64 v81, vcc, v77, v95, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v80, s47 offset:40
		scratch_store_dword off, v81, s47 offset:44
		v_mul_lo_u32 v76, v72, v86
		v_mul_hi_u32 v77, v72, v86
		v_mul_lo_u32 v2, v72, v87
		v_add_u32_e32 v77, v77, v2
		v_mul_lo_u32 v2, v73, v86
		v_add_u32_e32 v77, v77, v2
		v_add_co_u32_e64 v72, vcc, v74, v76
		v_addc_co_u32_e64 v73, vcc, v75, v77, vcc
		v_mov_b32_e32 v2, 1
		v_and_b32_e32 v74, v78, v2
		v_and_b32_e32 v75, v79, v3
		s_mov_b32 s48, 0x400
		s_mov_b32 s49, 0
		v_mov_b32_e32 v2, s48
		v_mov_b32_e32 v3, s49
		v_mul_lo_u32 v78, v2, v74
		v_mul_hi_u32 v79, v2, v74
		v_mul_lo_u32 v8, v2, v75
		v_add_u32_e32 v79, v79, v8
		v_mul_lo_u32 v8, v3, v74
		v_add_u32_e32 v79, v79, v8
		v_add_co_u32_e64 v2, vcc, v72, v78
		v_addc_co_u32_e64 v3, vcc, v73, v79, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v2, s47 offset:48
		scratch_store_dword off, v3, s47 offset:52
		v_mov_b32_e32 v2, 0x80
		v_add_co_u32_e64 v72, vcc, v70, v2
		v_addc_co_u32_e64 v73, vcc, v71, 0, vcc
		v_add_co_u32_e64 v74, vcc, v72, v82
		v_addc_co_u32_e64 v75, vcc, v73, v83, vcc
		v_add_co_u32_e64 v72, vcc, v74, v90
		v_addc_co_u32_e64 v73, vcc, v75, v91, vcc
		v_add_co_u32_e64 v74, vcc, v72, v84
		v_addc_co_u32_e64 v75, vcc, v73, v85, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v74, s47 offset:56
		scratch_store_dword off, v75, s47 offset:60
		v_mov_b32_e32 v3, 0x80080
		v_add_co_u32_e64 v72, vcc, v70, v3
		v_addc_co_u32_e64 v73, vcc, v71, 0, vcc
		v_add_co_u32_e64 v74, vcc, v72, v82
		v_addc_co_u32_e64 v75, vcc, v73, v83, vcc
		v_add_co_u32_e64 v72, vcc, v74, v90
		v_addc_co_u32_e64 v73, vcc, v75, v91, vcc
		v_add_co_u32_e64 v74, vcc, v72, v84
		v_addc_co_u32_e64 v75, vcc, v73, v85, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v74, s47 offset:64
		scratch_store_dword off, v75, s47 offset:68
		v_mov_b32_e32 v8, 0xc0
		v_add_co_u32_e64 v72, vcc, v70, v8
		v_addc_co_u32_e64 v73, vcc, v71, 0, vcc
		v_add_co_u32_e64 v74, vcc, v72, v82
		v_addc_co_u32_e64 v75, vcc, v73, v83, vcc
		v_add_co_u32_e64 v72, vcc, v74, v90
		v_addc_co_u32_e64 v73, vcc, v75, v91, vcc
		v_add_co_u32_e64 v74, vcc, v72, v84
		v_addc_co_u32_e64 v75, vcc, v73, v85, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v74, s47 offset:72
		scratch_store_dword off, v75, s47 offset:76
		v_mov_b32_e32 v10, 0x800c0
		v_add_co_u32_e64 v72, vcc, v70, v10
		v_addc_co_u32_e64 v73, vcc, v71, 0, vcc
		v_add_co_u32_e64 v74, vcc, v72, v82
		v_addc_co_u32_e64 v75, vcc, v73, v83, vcc
		v_add_co_u32_e64 v72, vcc, v74, v90
		v_addc_co_u32_e64 v73, vcc, v75, v91, vcc
		v_add_co_u32_e64 v74, vcc, v72, v84
		v_addc_co_u32_e64 v75, vcc, v73, v85, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v74, s47 offset:80
		scratch_store_dword off, v75, s47 offset:84
		v_add_co_u32_e64 v72, vcc, v88, v2
		v_addc_co_u32_e64 v73, vcc, v89, 0, vcc
		v_add_co_u32_e64 v74, vcc, v72, v82
		v_addc_co_u32_e64 v75, vcc, v73, v83, vcc
		v_add_co_u32_e64 v72, vcc, v74, v90
		v_addc_co_u32_e64 v73, vcc, v75, v91, vcc
		v_add_co_u32_e64 v74, vcc, v72, v84
		v_addc_co_u32_e64 v75, vcc, v73, v85, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v74, s47 offset:88
		scratch_store_dword off, v75, s47 offset:92
		v_add_co_u32_e64 v72, vcc, v88, v3
		v_addc_co_u32_e64 v73, vcc, v89, 0, vcc
		v_add_co_u32_e64 v2, vcc, v72, v82
		v_addc_co_u32_e64 v3, vcc, v73, v83, vcc
		v_add_co_u32_e64 v72, vcc, v2, v90
		v_addc_co_u32_e64 v73, vcc, v3, v91, vcc
		v_add_co_u32_e64 v2, vcc, v72, v84
		v_addc_co_u32_e64 v3, vcc, v73, v85, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v2, s47 offset:96
		scratch_store_dword off, v3, s47 offset:100
		v_add_co_u32_e64 v2, vcc, v88, v8
		v_addc_co_u32_e64 v3, vcc, v89, 0, vcc
		v_add_co_u32_e64 v72, vcc, v2, v82
		v_addc_co_u32_e64 v73, vcc, v3, v83, vcc
		v_add_co_u32_e64 v2, vcc, v72, v90
		v_addc_co_u32_e64 v3, vcc, v73, v91, vcc
		v_add_co_u32_e64 v72, vcc, v2, v84
		v_addc_co_u32_e64 v73, vcc, v3, v85, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v72, s47 offset:104
		scratch_store_dword off, v73, s47 offset:108
		v_add_co_u32_e64 v2, vcc, v88, v10
		v_addc_co_u32_e64 v3, vcc, v89, 0, vcc
		v_add_co_u32_e64 v72, vcc, v2, v82
		v_addc_co_u32_e64 v73, vcc, v3, v83, vcc
		v_add_co_u32_e64 v2, vcc, v72, v90
		v_addc_co_u32_e64 v3, vcc, v73, v91, vcc
		v_add_co_u32_e64 v72, vcc, v2, v84
		v_addc_co_u32_e64 v73, vcc, v3, v85, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v72, s47 offset:112
		scratch_store_dword off, v73, s47 offset:116
		v_mov_b32_e32 v2, 0x800
		v_add_co_u32_e64 v72, vcc, v70, v2
		v_addc_co_u32_e64 v73, vcc, v71, 0, vcc
		v_add_co_u32_e64 v2, vcc, v72, v68
		v_addc_co_u32_e64 v3, vcc, v73, v69, vcc
		v_add_co_u32_e64 v72, vcc, v2, v92
		v_addc_co_u32_e64 v73, vcc, v3, v93, vcc
		v_add_co_u32_e64 v74, vcc, v72, v94
		v_addc_co_u32_e64 v75, vcc, v73, v95, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v74, s47 offset:120
		scratch_store_dword off, v75, s47 offset:124
		v_mov_b32_e32 v8, 0x900
		v_add_co_u32_e64 v72, vcc, v70, v8
		v_addc_co_u32_e64 v73, vcc, v71, 0, vcc
		v_add_co_u32_e64 v70, vcc, v72, v68
		v_addc_co_u32_e64 v71, vcc, v73, v69, vcc
		v_add_co_u32_e64 v68, vcc, v70, v92
		v_addc_co_u32_e64 v69, vcc, v71, v93, vcc
		v_add_co_u32_e64 v70, vcc, v68, v94
		v_addc_co_u32_e64 v71, vcc, v69, v95, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v70, s47 offset:128
		scratch_store_dword off, v71, s47 offset:132
		v_add_co_u32_e64 v68, vcc, v2, v76
		v_addc_co_u32_e64 v69, vcc, v3, v77, vcc
		v_add_co_u32_e64 v2, vcc, v68, v78
		v_addc_co_u32_e64 v3, vcc, v69, v79, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v2, s47 offset:136
		scratch_store_dword off, v3, s47 offset:140
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_mov_b64_e32 v[72:73], 0
		v_mov_b64_e32 v[74:75], 0
		v_mov_b64_e32 v[76:77], 0
		v_mov_b64_e32 v[78:79], 0
		v_mov_b64_e32 v[80:81], 0
		v_mov_b64_e32 v[82:83], 0
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
.Lwmma_f16_matmul_tiled.loop_head_0:
		v_mov_b32_e32 v2, s46
		v_mov_b32_e32 v3, 0
		v_lshlrev_b32_e32 v8, 2, v0
		s_waitcnt lgkmcnt(8)
		ds_read_b32 v192, v8 offset:4096
		v_lshlrev_b32_e32 v8, 2, v0
		ds_read_b32 v193, v8 offset:6144
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v194, v192, v2
		v_mul_hi_u32 v195, v192, v2
		v_mul_lo_u32 v8, v192, v3
		v_add_u32_e32 v195, v195, v8
		v_mul_lo_u32 v8, v193, v2
		v_add_u32_e32 v195, v195, v8
		v_lshlrev_b32_e32 v8, 2, v0
		ds_read_b32 v192, v8
		v_lshlrev_b32_e32 v8, 2, v0
		ds_read_b32 v193, v8 offset:2048
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v196, vcc, v192, v194
		v_addc_co_u32_e64 v197, vcc, v193, v195, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v196, s47 offset:264
		scratch_store_dword off, v197, s47 offset:268
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v192, off, s47 offset:264
		scratch_load_dword v193, off, s47 offset:268
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v192, s47 offset:272
		v_lshlrev_b32_e32 v8, 2, v0
		ds_read_b32 v192, v8 offset:8192
		v_lshlrev_b32_e32 v8, 2, v0
		ds_read_b32 v193, v8 offset:10240
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v196, vcc, v192, v194
		v_addc_co_u32_e64 v197, vcc, v193, v195, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v196, s47 offset:252
		scratch_store_dword off, v197, s47 offset:256
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v192, off, s47 offset:252
		scratch_load_dword v193, off, s47 offset:256
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v192, s47 offset:260
		v_lshlrev_b32_e32 v8, 2, v0
		ds_read_b32 v192, v8 offset:12288
		v_lshlrev_b32_e32 v8, 2, v0
		ds_read_b32 v193, v8 offset:14336
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v196, vcc, v192, v194
		v_addc_co_u32_e64 v197, vcc, v193, v195, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v196, s47 offset:240
		scratch_store_dword off, v197, s47 offset:244
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v192, off, s47 offset:240
		scratch_load_dword v193, off, s47 offset:244
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v192, s47 offset:248
		v_lshlrev_b32_e32 v8, 2, v0
		ds_read_b32 v192, v8 offset:16384
		v_lshlrev_b32_e32 v8, 2, v0
		ds_read_b32 v193, v8 offset:18432
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v196, vcc, v192, v194
		v_addc_co_u32_e64 v197, vcc, v193, v195, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v196, s47 offset:228
		scratch_store_dword off, v197, s47 offset:232
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v192, off, s47 offset:228
		scratch_load_dword v193, off, s47 offset:232
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v192, s47 offset:236
		v_lshlrev_b32_e32 v8, 2, v0
		ds_read_b32 v192, v8 offset:20480
		v_lshlrev_b32_e32 v8, 2, v0
		ds_read_b32 v193, v8 offset:22528
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v196, vcc, v192, v194
		v_addc_co_u32_e64 v197, vcc, v193, v195, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v196, s47 offset:216
		scratch_store_dword off, v197, s47 offset:220
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v192, off, s47 offset:216
		scratch_load_dword v193, off, s47 offset:220
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v192, s47 offset:224
		s_mov_b32 s47, 0
		scratch_load_dword v192, off, s47
		scratch_load_dword v193, off, s47 offset:4
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v196, vcc, v192, v194
		v_addc_co_u32_e64 v197, vcc, v193, v195, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v196, s47 offset:204
		scratch_store_dword off, v197, s47 offset:208
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v192, off, s47 offset:204
		scratch_load_dword v193, off, s47 offset:208
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v192, s47 offset:212
		s_mov_b32 s47, 0
		scratch_load_dword v192, off, s47 offset:8
		scratch_load_dword v193, off, s47 offset:12
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v196, vcc, v192, v194
		v_addc_co_u32_e64 v197, vcc, v193, v195, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v196, s47 offset:192
		scratch_store_dword off, v197, s47 offset:196
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v192, off, s47 offset:192
		scratch_load_dword v193, off, s47 offset:196
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v192, s47 offset:200
		s_mov_b32 s47, 0
		scratch_load_dword v192, off, s47 offset:16
		scratch_load_dword v193, off, s47 offset:20
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v196, vcc, v192, v194
		v_addc_co_u32_e64 v197, vcc, v193, v195, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v196, s47 offset:180
		scratch_store_dword off, v197, s47 offset:184
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v192, off, s47 offset:180
		scratch_load_dword v193, off, s47 offset:184
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v192, s47 offset:188
		s_mov_b32 s47, 0
		scratch_load_dword v192, off, s47 offset:32
		scratch_load_dword v193, off, s47 offset:36
		s_waitcnt vmcnt(0)
		v_mul_lo_u32 v196, v192, v2
		v_mul_hi_u32 v197, v192, v2
		v_mul_lo_u32 v8, v192, v3
		v_add_u32_e32 v197, v197, v8
		v_mul_lo_u32 v8, v193, v2
		v_add_u32_e32 v197, v197, v8
		s_mov_b32 s47, 0
		scratch_load_dword v2, off, s47 offset:24
		scratch_load_dword v3, off, s47 offset:28
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v192, vcc, v2, v196
		v_addc_co_u32_e64 v193, vcc, v3, v197, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v192, s47 offset:168
		scratch_store_dword off, v193, s47 offset:172
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v2, off, s47 offset:168
		scratch_load_dword v3, off, s47 offset:172
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v2, s47 offset:176
		s_mov_b32 s47, 0
		scratch_load_dword v2, off, s47 offset:40
		scratch_load_dword v3, off, s47 offset:44
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v192, vcc, v2, v196
		v_addc_co_u32_e64 v193, vcc, v3, v197, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v192, s47 offset:156
		scratch_store_dword off, v193, s47 offset:160
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v2, off, s47 offset:156
		scratch_load_dword v3, off, s47 offset:160
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v2, s47 offset:164
		s_mov_b32 s47, 0
		scratch_load_dword v2, off, s47 offset:48
		scratch_load_dword v3, off, s47 offset:52
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v192, vcc, v2, v196
		v_addc_co_u32_e64 v193, vcc, v3, v197, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v192, s47 offset:144
		scratch_store_dword off, v193, s47 offset:148
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v2, off, s47 offset:144
		scratch_load_dword v3, off, s47 offset:148
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v2, s47 offset:152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[16:19], v[32:35], v[4:7], v9, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s47, s46, 1
		s_lshl_b32 s48, s47, 16
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 12, v2
		v_add_u32_e32 v2, s48, v3
		v_and_b32_e32 v3, 15, v0
		v_lshlrev_b32_e32 v8, 6, v3
		v_lshlrev_b32_e32 v3, 4, v11
		v_add3_u32 v10, v2, v8, v3
		ds_read_b128 v[200:203], v10 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[16:19], v[36:39], v[68:71], v9, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[204:207], v10 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[16:19], v[40:43], v[72:75], v9, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[208:211], v10 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[16:19], v[44:47], v[76:79], v9, v15 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[212:215], v10 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[16:19], v[48:51], v[80:83], v9, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_and_b32_e32 v2, 15, v0
		v_lshlrev_b32_e32 v3, 6, v2
		v_add_u32_e32 v2, s48, v3
		v_lshlrev_b32_e32 v3, 13, v13
		v_lshlrev_b32_e32 v8, 4, v11
		v_add3_u32 v64, v2, v3, v8
		ds_read_b128 v[216:219], v64 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[16:19], v[52:55], v[84:87], v9, v65 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v64 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[16:19], v[56:59], v[88:91], v9, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v64 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[16:19], v[60:63], v[92:95], v9, v66 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v64 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[20:23], v[32:35], v[96:99], v9, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[232:235], v64 offset:53248
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v232, s48 offset:340
		scratch_store_dword off, v233, s48 offset:344
		scratch_store_dword off, v234, s48 offset:348
		scratch_store_dword off, v235, s48 offset:352
		s_mov_b32 s48, 0
		scratch_store_dword off, v232, s48 offset:356
		scratch_store_dword off, v233, s48 offset:360
		scratch_store_dword off, v234, s48 offset:364
		scratch_store_dword off, v235, s48 offset:368
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[20:23], v[36:39], v[100:103], v9, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[232:235], v64 offset:54272
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v232, s48 offset:308
		scratch_store_dword off, v233, s48 offset:312
		scratch_store_dword off, v234, s48 offset:316
		scratch_store_dword off, v235, s48 offset:320
		s_mov_b32 s48, 0
		scratch_store_dword off, v232, s48 offset:324
		scratch_store_dword off, v233, s48 offset:328
		scratch_store_dword off, v234, s48 offset:332
		scratch_store_dword off, v235, s48 offset:336
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[20:23], v[40:43], v[104:107], v9, v15 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[232:235], v64 offset:55296
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v232, s48 offset:276
		scratch_store_dword off, v233, s48 offset:280
		scratch_store_dword off, v234, s48 offset:284
		scratch_store_dword off, v235, s48 offset:288
		s_mov_b32 s48, 0
		scratch_store_dword off, v232, s48 offset:292
		scratch_store_dword off, v233, s48 offset:296
		scratch_store_dword off, v234, s48 offset:300
		scratch_store_dword off, v235, s48 offset:304
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[20:23], v[44:47], v[108:111], v9, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[232:235], v64 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[20:23], v[48:51], v[112:115], v9, v65 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_mov_b32 s48, 0
		scratch_load_dword v2, off, s48 offset:272
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[20:23], v[52:55], v[116:119], v9, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s28
		s_mov_b32 s48, 0
		scratch_load_dword v2, off, s48 offset:260
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], v[56:59], v[120:123], v9, v66 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s29
		s_mov_b32 s48, 0
		scratch_load_dword v2, off, s48 offset:248
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], v[60:63], v[124:127], v9, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s30
		s_mov_b32 s48, 0
		scratch_load_dword v2, off, s48 offset:236
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[24:27], v[32:35], v[128:131], v12, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s31
		s_mov_b32 s48, 0
		scratch_load_dword v2, off, s48 offset:224
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[24:27], v[36:39], v[132:135], v12, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s32
		s_mov_b32 s48, 0
		scratch_load_dword v2, off, s48 offset:212
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[24:27], v[40:43], v[136:139], v12, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s33
		s_mov_b32 s48, 0
		scratch_load_dword v2, off, s48 offset:200
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[24:27], v[44:47], v[140:143], v12, v15 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s34
		s_mov_b32 s48, 0
		scratch_load_dword v2, off, s48 offset:188
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[48:51], v[144:147], v12, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s8, 0x20000
		s_mov_b32 s48, 0
		scratch_load_dword v2, off, s48 offset:176
		s_waitcnt vmcnt(0)
		buffer_load_dword v2, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[52:55], v[148:151], v12, v65 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s37, 0x20000
		s_mov_b32 s48, 0
		scratch_load_dword v2, off, s48 offset:164
		s_waitcnt vmcnt(0)
		buffer_load_dword v2, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[56:59], v[152:155], v12, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s36, 0x20000
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v2, off, s48 offset:152
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[60:63], v[156:159], v12, v66 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		ds_read_b128 v[16:19], v10
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[28:31], v[32:35], v[160:163], v12, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v10 offset:1024
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[28:31], v[36:39], v[164:167], v12, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v10 offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[28:31], v[40:43], v[168:171], v12, v15 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[236:239], v10 offset:3072
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s48 offset:396
		scratch_store_dword off, v237, s48 offset:400
		scratch_store_dword off, v238, s48 offset:404
		scratch_store_dword off, v239, s48 offset:408
		s_mov_b32 s48, 0
		scratch_store_dword off, v236, s48 offset:412
		scratch_store_dword off, v237, s48 offset:416
		scratch_store_dword off, v238, s48 offset:420
		scratch_store_dword off, v239, s48 offset:424
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[28:31], v[44:47], v[172:175], v12, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[32:35], v64 offset:32768
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[48:51], v[176:179], v12, v65 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[36:39], v64 offset:33792
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[52:55], v[180:183], v12, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[40:43], v64 offset:34816
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[56:59], v[184:187], v12, v66 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[44:47], v64 offset:35840
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[60:63], v[188:191], v12, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[48:51], v64 offset:36864
		ds_read_b128 v[52:55], v64 offset:37888
		ds_read_b128 v[56:59], v64 offset:38912
		ds_read_b128 v[60:63], v64 offset:39936
		s_lshl_b32 s48, s47, 12
		s_add_i32 s47, s48, 0x20000
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 9, v2
		v_lshlrev_b32_e32 v2, 2, v1
		v_add3_u32 v8, s47, v3, v2
		ds_read_b32 v2, v8
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s48 offset:392
		ds_read_b32 v2, v8 offset:256
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s48 offset:388
		v_lshlrev_b32_e32 v2, 10, v13
		v_lshlrev_b32_e32 v3, 2, v1
		v_add3_u32 v8, s47, v3, v2
		ds_read_b32 v2, v8 offset:2048
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s47 offset:384
		ds_read_b32 v2, v8 offset:2304
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s47 offset:380
		ds_read_b32 v2, v8 offset:2560
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s47 offset:376
		ds_read_b32 v2, v8 offset:2816
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s47 offset:372
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[200:203], v[216:219], v[4:7], v9, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[200:203], v[220:223], v[68:71], v9, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[200:203], v[224:227], v[72:75], v9, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[200:203], v[228:231], v[76:79], v9, v15 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(30)
		scratch_load_dword v236, off, s47 offset:356
		scratch_load_dword v237, off, s47 offset:360
		scratch_load_dword v238, off, s47 offset:364
		scratch_load_dword v239, off, s47 offset:368
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[200:203], v[236:239], v[80:83], v9, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(22)
		scratch_load_dword v236, off, s47 offset:324
		scratch_load_dword v237, off, s47 offset:328
		scratch_load_dword v238, off, s47 offset:332
		scratch_load_dword v239, off, s47 offset:336
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[200:203], v[236:239], v[84:87], v9, v65 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(14)
		scratch_load_dword v236, off, s47 offset:292
		scratch_load_dword v237, off, s47 offset:296
		scratch_load_dword v238, off, s47 offset:300
		scratch_load_dword v239, off, s47 offset:304
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[200:203], v[236:239], v[88:91], v9, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[200:203], v[232:235], v[92:95], v9, v66 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[204:207], v[216:219], v[96:99], v9, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[204:207], v[220:223], v[100:103], v9, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[204:207], v[224:227], v[104:107], v9, v15 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[204:207], v[228:231], v[108:111], v9, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v200, off, s47 offset:356
		scratch_load_dword v201, off, s47 offset:360
		scratch_load_dword v202, off, s47 offset:364
		scratch_load_dword v203, off, s47 offset:368
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[204:207], v[200:203], v[112:115], v9, v65 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v200, off, s47 offset:324
		scratch_load_dword v201, off, s47 offset:328
		scratch_load_dword v202, off, s47 offset:332
		scratch_load_dword v203, off, s47 offset:336
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[204:207], v[200:203], v[116:119], v9, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v200, off, s47 offset:292
		scratch_load_dword v201, off, s47 offset:296
		scratch_load_dword v202, off, s47 offset:300
		scratch_load_dword v203, off, s47 offset:304
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[204:207], v[200:203], v[120:123], v9, v66 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[204:207], v[232:235], v[124:127], v9, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[208:211], v[216:219], v[128:131], v12, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[208:211], v[220:223], v[132:135], v12, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[208:211], v[224:227], v[136:139], v12, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[208:211], v[228:231], v[140:143], v12, v15 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v200, off, s47 offset:356
		scratch_load_dword v201, off, s47 offset:360
		scratch_load_dword v202, off, s47 offset:364
		scratch_load_dword v203, off, s47 offset:368
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[208:211], v[200:203], v[144:147], v12, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v200, off, s47 offset:324
		scratch_load_dword v201, off, s47 offset:328
		scratch_load_dword v202, off, s47 offset:332
		scratch_load_dword v203, off, s47 offset:336
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[208:211], v[200:203], v[148:151], v12, v65 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v200, off, s47 offset:292
		scratch_load_dword v201, off, s47 offset:296
		scratch_load_dword v202, off, s47 offset:300
		scratch_load_dword v203, off, s47 offset:304
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[208:211], v[200:203], v[152:155], v12, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[208:211], v[232:235], v[156:159], v12, v66 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[212:215], v[216:219], v[160:163], v12, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[212:215], v[220:223], v[164:167], v12, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[212:215], v[224:227], v[168:171], v12, v15 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[212:215], v[228:231], v[172:175], v12, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v200, off, s47 offset:356
		scratch_load_dword v201, off, s47 offset:360
		scratch_load_dword v202, off, s47 offset:364
		scratch_load_dword v203, off, s47 offset:368
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[212:215], v[200:203], v[176:179], v12, v65 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v200, off, s47 offset:324
		scratch_load_dword v201, off, s47 offset:328
		scratch_load_dword v202, off, s47 offset:332
		scratch_load_dword v203, off, s47 offset:336
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[212:215], v[200:203], v[180:183], v12, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v200, off, s47 offset:292
		scratch_load_dword v201, off, s47 offset:296
		scratch_load_dword v202, off, s47 offset:300
		scratch_load_dword v203, off, s47 offset:304
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[212:215], v[200:203], v[184:187], v12, v66 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[212:215], v[232:235], v[188:191], v12, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s47, s46, 1
		s_and_b32 s48, s47, 1
		s_lshl_b32 s47, s48, 16
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 12, v2
		v_add_u32_e32 v2, s47, v3
		v_and_b32_e32 v3, 15, v0
		v_lshlrev_b32_e32 v8, 6, v3
		v_lshlrev_b32_e32 v3, 4, v11
		v_add3_u32 v10, v2, v8, v3
		ds_read_b128 v[200:203], v10
		ds_read_b128 v[204:207], v10 offset:1024
		ds_read_b128 v[208:211], v10 offset:2048
		ds_read_b128 v[212:215], v10 offset:3072
		v_and_b32_e32 v2, 15, v0
		v_lshlrev_b32_e32 v3, 6, v2
		v_add_u32_e32 v2, s47, v3
		v_lshlrev_b32_e32 v3, 13, v13
		v_lshlrev_b32_e32 v8, 4, v11
		v_add3_u32 v64, v2, v3, v8
		ds_read_b128 v[216:219], v64 offset:32768
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v216, s47 offset:784
		scratch_store_dword off, v217, s47 offset:788
		scratch_store_dword off, v218, s47 offset:792
		scratch_store_dword off, v219, s47 offset:796
		s_mov_b32 s47, 0
		scratch_store_dword off, v216, s47 offset:800
		scratch_store_dword off, v217, s47 offset:804
		scratch_store_dword off, v218, s47 offset:808
		scratch_store_dword off, v219, s47 offset:812
		ds_read_b128 v[216:219], v64 offset:33792
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v216, s47 offset:752
		scratch_store_dword off, v217, s47 offset:756
		scratch_store_dword off, v218, s47 offset:760
		scratch_store_dword off, v219, s47 offset:764
		s_mov_b32 s47, 0
		scratch_store_dword off, v216, s47 offset:768
		scratch_store_dword off, v217, s47 offset:772
		scratch_store_dword off, v218, s47 offset:776
		scratch_store_dword off, v219, s47 offset:780
		ds_read_b128 v[216:219], v64 offset:34816
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v216, s47 offset:720
		scratch_store_dword off, v217, s47 offset:724
		scratch_store_dword off, v218, s47 offset:728
		scratch_store_dword off, v219, s47 offset:732
		s_mov_b32 s47, 0
		scratch_store_dword off, v216, s47 offset:736
		scratch_store_dword off, v217, s47 offset:740
		scratch_store_dword off, v218, s47 offset:744
		scratch_store_dword off, v219, s47 offset:748
		ds_read_b128 v[216:219], v64 offset:35840
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v216, s47 offset:688
		scratch_store_dword off, v217, s47 offset:692
		scratch_store_dword off, v218, s47 offset:696
		scratch_store_dword off, v219, s47 offset:700
		s_mov_b32 s47, 0
		scratch_store_dword off, v216, s47 offset:704
		scratch_store_dword off, v217, s47 offset:708
		scratch_store_dword off, v218, s47 offset:712
		scratch_store_dword off, v219, s47 offset:716
		ds_read_b128 v[216:219], v64 offset:36864
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v216, s47 offset:656
		scratch_store_dword off, v217, s47 offset:660
		scratch_store_dword off, v218, s47 offset:664
		scratch_store_dword off, v219, s47 offset:668
		s_mov_b32 s47, 0
		scratch_store_dword off, v216, s47 offset:672
		scratch_store_dword off, v217, s47 offset:676
		scratch_store_dword off, v218, s47 offset:680
		scratch_store_dword off, v219, s47 offset:684
		ds_read_b128 v[216:219], v64 offset:37888
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v216, s47 offset:588
		scratch_store_dword off, v217, s47 offset:592
		scratch_store_dword off, v218, s47 offset:596
		scratch_store_dword off, v219, s47 offset:600
		s_mov_b32 s47, 0
		scratch_store_dword off, v216, s47 offset:604
		scratch_store_dword off, v217, s47 offset:608
		scratch_store_dword off, v218, s47 offset:612
		scratch_store_dword off, v219, s47 offset:616
		ds_read_b128 v[216:219], v64 offset:38912
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v216, s47 offset:532
		scratch_store_dword off, v217, s47 offset:536
		scratch_store_dword off, v218, s47 offset:540
		scratch_store_dword off, v219, s47 offset:544
		s_mov_b32 s47, 0
		scratch_store_dword off, v216, s47 offset:548
		scratch_store_dword off, v217, s47 offset:552
		scratch_store_dword off, v218, s47 offset:556
		scratch_store_dword off, v219, s47 offset:560
		ds_read_b128 v[216:219], v64 offset:39936
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v216, s47 offset:476
		scratch_store_dword off, v217, s47 offset:480
		scratch_store_dword off, v218, s47 offset:484
		scratch_store_dword off, v219, s47 offset:488
		s_mov_b32 s47, 0
		scratch_store_dword off, v216, s47 offset:492
		scratch_store_dword off, v217, s47 offset:496
		scratch_store_dword off, v218, s47 offset:500
		scratch_store_dword off, v219, s47 offset:504
		s_lshl_b32 s47, s48, 12
		s_add_i32 s48, s47, 0x20000
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 9, v2
		v_lshlrev_b32_e32 v2, 2, v1
		v_add3_u32 v8, s48, v3, v2
		ds_read_b32 v2, v8
		ds_read_b32 v3, v8 offset:256
		v_lshlrev_b32_e32 v8, 10, v13
		v_lshlrev_b32_e32 v67, 2, v1
		v_add3_u32 v192, s48, v67, v8
		ds_read_b32 v8, v192 offset:2048
		ds_read_b32 v67, v192 offset:2304
		ds_read_b32 v193, v192 offset:2560
		ds_read_b32 v198, v192 offset:2816
		s_waitcnt lgkmcnt(0)
		s_mov_b32 s47, 0
		scratch_load_dword v216, off, s47 offset:56
		scratch_load_dword v217, off, s47 offset:60
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v218, vcc, v216, v194
		v_addc_co_u32_e64 v219, vcc, v217, v195, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v218, s47 offset:464
		scratch_store_dword off, v219, s47 offset:468
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v216, off, s47 offset:464
		scratch_load_dword v217, off, s47 offset:468
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v216, s47 offset:472
		s_mov_b32 s47, 0
		scratch_load_dword v216, off, s47 offset:64
		scratch_load_dword v217, off, s47 offset:68
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v218, vcc, v216, v194
		v_addc_co_u32_e64 v219, vcc, v217, v195, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v218, s47 offset:452
		scratch_store_dword off, v219, s47 offset:456
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v216, off, s47 offset:452
		scratch_load_dword v217, off, s47 offset:456
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v216, s47 offset:460
		s_mov_b32 s47, 0
		scratch_load_dword v216, off, s47 offset:72
		scratch_load_dword v217, off, s47 offset:76
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v218, vcc, v216, v194
		v_addc_co_u32_e64 v219, vcc, v217, v195, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v218, s47 offset:440
		scratch_store_dword off, v219, s47 offset:444
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v216, off, s47 offset:440
		scratch_load_dword v217, off, s47 offset:444
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v216, s47 offset:448
		s_mov_b32 s47, 0
		scratch_load_dword v216, off, s47 offset:80
		scratch_load_dword v217, off, s47 offset:84
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v218, vcc, v216, v194
		v_addc_co_u32_e64 v219, vcc, v217, v195, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v218, s47 offset:428
		scratch_store_dword off, v219, s47 offset:432
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v216, off, s47 offset:428
		scratch_load_dword v217, off, s47 offset:432
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v216, s47 offset:436
		s_mov_b32 s47, 0
		scratch_load_dword v216, off, s47 offset:88
		scratch_load_dword v217, off, s47 offset:92
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v218, vcc, v216, v194
		v_addc_co_u32_e64 v219, vcc, v217, v195, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v218, s47 offset:520
		scratch_store_dword off, v219, s47 offset:524
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v216, off, s47 offset:520
		scratch_load_dword v217, off, s47 offset:524
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v216, s47 offset:528
		s_mov_b32 s47, 0
		scratch_load_dword v216, off, s47 offset:96
		scratch_load_dword v217, off, s47 offset:100
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v218, vcc, v216, v194
		v_addc_co_u32_e64 v219, vcc, v217, v195, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v218, s47 offset:508
		scratch_store_dword off, v219, s47 offset:512
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v216, off, s47 offset:508
		scratch_load_dword v217, off, s47 offset:512
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v216, s47 offset:516
		s_mov_b32 s47, 0
		scratch_load_dword v216, off, s47 offset:104
		scratch_load_dword v217, off, s47 offset:108
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v218, vcc, v216, v194
		v_addc_co_u32_e64 v219, vcc, v217, v195, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v218, s47 offset:576
		scratch_store_dword off, v219, s47 offset:580
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v216, off, s47 offset:576
		scratch_load_dword v217, off, s47 offset:580
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v216, s47 offset:584
		s_mov_b32 s47, 0
		scratch_load_dword v216, off, s47 offset:112
		scratch_load_dword v217, off, s47 offset:116
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v218, vcc, v216, v194
		v_addc_co_u32_e64 v219, vcc, v217, v195, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v218, s47 offset:564
		scratch_store_dword off, v219, s47 offset:568
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v194, off, s47 offset:564
		scratch_load_dword v195, off, s47 offset:568
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v194, s47 offset:572
		s_mov_b32 s47, 0
		scratch_load_dword v194, off, s47 offset:120
		scratch_load_dword v195, off, s47 offset:124
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v216, vcc, v194, v196
		v_addc_co_u32_e64 v217, vcc, v195, v197, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v216, s47 offset:644
		scratch_store_dword off, v217, s47 offset:648
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v194, off, s47 offset:644
		scratch_load_dword v195, off, s47 offset:648
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v194, s47 offset:652
		s_mov_b32 s47, 0
		scratch_load_dword v194, off, s47 offset:128
		scratch_load_dword v195, off, s47 offset:132
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v216, vcc, v194, v196
		v_addc_co_u32_e64 v217, vcc, v195, v197, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v216, s47 offset:632
		scratch_store_dword off, v217, s47 offset:636
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v194, off, s47 offset:632
		scratch_load_dword v195, off, s47 offset:636
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v194, s47 offset:640
		s_mov_b32 s47, 0
		scratch_load_dword v194, off, s47 offset:136
		scratch_load_dword v195, off, s47 offset:140
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v216, vcc, v194, v196
		v_addc_co_u32_e64 v217, vcc, v195, v197, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v216, s47 offset:620
		scratch_store_dword off, v217, s47 offset:624
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v194, off, s47 offset:620
		scratch_load_dword v195, off, s47 offset:624
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v194, s47 offset:628
		s_mov_b32 s47, 0
		scratch_load_dword v216, off, s47 offset:800
		scratch_load_dword v217, off, s47 offset:804
		scratch_load_dword v218, off, s47 offset:808
		scratch_load_dword v219, off, s47 offset:812
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[200:203], v[216:219], v[4:7], v2, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v10 offset:16384
		s_mov_b32 s47, 0
		scratch_load_dword v220, off, s47 offset:768
		scratch_load_dword v221, off, s47 offset:772
		scratch_load_dword v222, off, s47 offset:776
		scratch_load_dword v223, off, s47 offset:780
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[200:203], v[220:223], v[68:71], v2, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v10 offset:17408
		s_mov_b32 s47, 0
		scratch_load_dword v224, off, s47 offset:736
		scratch_load_dword v225, off, s47 offset:740
		scratch_load_dword v226, off, s47 offset:744
		scratch_load_dword v227, off, s47 offset:748
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[200:203], v[224:227], v[72:75], v2, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v10 offset:18432
		s_mov_b32 s47, 0
		scratch_load_dword v228, off, s47 offset:704
		scratch_load_dword v229, off, s47 offset:708
		scratch_load_dword v230, off, s47 offset:712
		scratch_load_dword v231, off, s47 offset:716
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[200:203], v[228:231], v[76:79], v2, v67 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v10 offset:19456
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s47 offset:848
		scratch_store_dword off, v229, s47 offset:852
		scratch_store_dword off, v230, s47 offset:856
		scratch_store_dword off, v231, s47 offset:860
		s_mov_b32 s47, 0
		scratch_store_dword off, v228, s47 offset:864
		scratch_store_dword off, v229, s47 offset:868
		scratch_store_dword off, v230, s47 offset:872
		scratch_store_dword off, v231, s47 offset:876
		s_mov_b32 s47, 0
		scratch_load_dword v228, off, s47 offset:672
		scratch_load_dword v229, off, s47 offset:676
		scratch_load_dword v230, off, s47 offset:680
		scratch_load_dword v231, off, s47 offset:684
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[200:203], v[228:231], v[80:83], v2, v193 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v64 offset:49152
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s47 offset:816
		scratch_store_dword off, v229, s47 offset:820
		scratch_store_dword off, v230, s47 offset:824
		scratch_store_dword off, v231, s47 offset:828
		s_mov_b32 s47, 0
		scratch_store_dword off, v228, s47 offset:832
		scratch_store_dword off, v229, s47 offset:836
		scratch_store_dword off, v230, s47 offset:840
		scratch_store_dword off, v231, s47 offset:844
		s_mov_b32 s47, 0
		scratch_load_dword v228, off, s47 offset:604
		scratch_load_dword v229, off, s47 offset:608
		scratch_load_dword v230, off, s47 offset:612
		scratch_load_dword v231, off, s47 offset:616
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[200:203], v[228:231], v[84:87], v2, v193 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v64 offset:50176
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s47 offset:912
		scratch_store_dword off, v229, s47 offset:916
		scratch_store_dword off, v230, s47 offset:920
		scratch_store_dword off, v231, s47 offset:924
		s_mov_b32 s47, 0
		scratch_store_dword off, v228, s47 offset:928
		scratch_store_dword off, v229, s47 offset:932
		scratch_store_dword off, v230, s47 offset:936
		scratch_store_dword off, v231, s47 offset:940
		s_mov_b32 s47, 0
		scratch_load_dword v228, off, s47 offset:548
		scratch_load_dword v229, off, s47 offset:552
		scratch_load_dword v230, off, s47 offset:556
		scratch_load_dword v231, off, s47 offset:560
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[200:203], v[228:231], v[88:91], v2, v198 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v64 offset:51200
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s47 offset:880
		scratch_store_dword off, v229, s47 offset:884
		scratch_store_dword off, v230, s47 offset:888
		scratch_store_dword off, v231, s47 offset:892
		s_mov_b32 s47, 0
		scratch_store_dword off, v228, s47 offset:896
		scratch_store_dword off, v229, s47 offset:900
		scratch_store_dword off, v230, s47 offset:904
		scratch_store_dword off, v231, s47 offset:908
		s_mov_b32 s47, 0
		scratch_load_dword v228, off, s47 offset:492
		scratch_load_dword v229, off, s47 offset:496
		scratch_load_dword v230, off, s47 offset:500
		scratch_load_dword v231, off, s47 offset:504
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[200:203], v[228:231], v[92:95], v2, v198 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[200:203], v64 offset:52224
		s_mov_b32 s47, 0
		scratch_load_dword v228, off, s47 offset:800
		scratch_load_dword v229, off, s47 offset:804
		scratch_load_dword v230, off, s47 offset:808
		scratch_load_dword v231, off, s47 offset:812
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[204:207], v[228:231], v[96:99], v2, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v64 offset:53248
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s47 offset:976
		scratch_store_dword off, v229, s47 offset:980
		scratch_store_dword off, v230, s47 offset:984
		scratch_store_dword off, v231, s47 offset:988
		s_mov_b32 s47, 0
		scratch_store_dword off, v228, s47 offset:992
		scratch_store_dword off, v229, s47 offset:996
		scratch_store_dword off, v230, s47 offset:1000
		scratch_store_dword off, v231, s47 offset:1004
		s_mov_b32 s47, 0
		scratch_load_dword v228, off, s47 offset:768
		scratch_load_dword v229, off, s47 offset:772
		scratch_load_dword v230, off, s47 offset:776
		scratch_load_dword v231, off, s47 offset:780
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[204:207], v[228:231], v[100:103], v2, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v64 offset:54272
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s47 offset:944
		scratch_store_dword off, v229, s47 offset:948
		scratch_store_dword off, v230, s47 offset:952
		scratch_store_dword off, v231, s47 offset:956
		s_mov_b32 s47, 0
		scratch_store_dword off, v228, s47 offset:960
		scratch_store_dword off, v229, s47 offset:964
		scratch_store_dword off, v230, s47 offset:968
		scratch_store_dword off, v231, s47 offset:972
		s_mov_b32 s47, 0
		scratch_load_dword v228, off, s47 offset:736
		scratch_load_dword v229, off, s47 offset:740
		scratch_load_dword v230, off, s47 offset:744
		scratch_load_dword v231, off, s47 offset:748
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[204:207], v[228:231], v[104:107], v2, v67 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v64 offset:55296
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s47 offset:1040
		scratch_store_dword off, v229, s47 offset:1044
		scratch_store_dword off, v230, s47 offset:1048
		scratch_store_dword off, v231, s47 offset:1052
		s_mov_b32 s47, 0
		scratch_store_dword off, v228, s47 offset:1056
		scratch_store_dword off, v229, s47 offset:1060
		scratch_store_dword off, v230, s47 offset:1064
		scratch_store_dword off, v231, s47 offset:1068
		s_mov_b32 s47, 0
		scratch_load_dword v228, off, s47 offset:704
		scratch_load_dword v229, off, s47 offset:708
		scratch_load_dword v230, off, s47 offset:712
		scratch_load_dword v231, off, s47 offset:716
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[204:207], v[228:231], v[108:111], v2, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v64 offset:56320
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s47 offset:1008
		scratch_store_dword off, v229, s47 offset:1012
		scratch_store_dword off, v230, s47 offset:1016
		scratch_store_dword off, v231, s47 offset:1020
		s_mov_b32 s47, 0
		scratch_store_dword off, v228, s47 offset:1024
		scratch_store_dword off, v229, s47 offset:1028
		scratch_store_dword off, v230, s47 offset:1032
		scratch_store_dword off, v231, s47 offset:1036
		s_mov_b32 s47, 0
		scratch_load_dword v228, off, s47 offset:672
		scratch_load_dword v229, off, s47 offset:676
		scratch_load_dword v230, off, s47 offset:680
		scratch_load_dword v231, off, s47 offset:684
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[204:207], v[228:231], v[112:115], v2, v193 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s10
		s_mov_b32 s47, 0
		scratch_load_dword v10, off, s47 offset:472
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v228, off, s47 offset:604
		scratch_load_dword v229, off, s47 offset:608
		scratch_load_dword v230, off, s47 offset:612
		scratch_load_dword v231, off, s47 offset:616
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[204:207], v[228:231], v[116:119], v2, v193 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s38
		s_mov_b32 s47, 0
		scratch_load_dword v10, off, s47 offset:460
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v228, off, s47 offset:548
		scratch_load_dword v229, off, s47 offset:552
		scratch_load_dword v230, off, s47 offset:556
		scratch_load_dword v231, off, s47 offset:560
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[204:207], v[228:231], v[120:123], v2, v198 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s39
		s_mov_b32 s47, 0
		scratch_load_dword v10, off, s47 offset:448
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v228, off, s47 offset:492
		scratch_load_dword v229, off, s47 offset:496
		scratch_load_dword v230, off, s47 offset:500
		scratch_load_dword v231, off, s47 offset:504
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[204:207], v[228:231], v[124:127], v2, v198 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s40
		s_mov_b32 s47, 0
		scratch_load_dword v10, off, s47 offset:436
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:800
		scratch_load_dword v205, off, s47 offset:804
		scratch_load_dword v206, off, s47 offset:808
		scratch_load_dword v207, off, s47 offset:812
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[208:211], v[204:207], v[128:131], v3, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s41
		s_mov_b32 s47, 0
		scratch_load_dword v10, off, s47 offset:528
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:768
		scratch_load_dword v205, off, s47 offset:772
		scratch_load_dword v206, off, s47 offset:776
		scratch_load_dword v207, off, s47 offset:780
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[208:211], v[204:207], v[132:135], v3, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s42
		s_mov_b32 s47, 0
		scratch_load_dword v10, off, s47 offset:516
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:736
		scratch_load_dword v205, off, s47 offset:740
		scratch_load_dword v206, off, s47 offset:744
		scratch_load_dword v207, off, s47 offset:748
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[208:211], v[204:207], v[136:139], v3, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s43
		s_mov_b32 s47, 0
		scratch_load_dword v10, off, s47 offset:584
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:704
		scratch_load_dword v205, off, s47 offset:708
		scratch_load_dword v206, off, s47 offset:712
		scratch_load_dword v207, off, s47 offset:716
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[208:211], v[204:207], v[140:143], v3, v67 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s44
		s_mov_b32 s47, 0
		scratch_load_dword v10, off, s47 offset:572
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:672
		scratch_load_dword v205, off, s47 offset:676
		scratch_load_dword v206, off, s47 offset:680
		scratch_load_dword v207, off, s47 offset:684
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[208:211], v[204:207], v[144:147], v3, v193 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s45, 0x20000
		s_mov_b32 s47, 0
		scratch_load_dword v10, off, s47 offset:652
		s_waitcnt vmcnt(0)
		buffer_load_dword v10, s[4:7], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:604
		scratch_load_dword v205, off, s47 offset:608
		scratch_load_dword v206, off, s47 offset:612
		scratch_load_dword v207, off, s47 offset:616
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[208:211], v[204:207], v[148:151], v3, v193 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s9, 0x20000
		s_mov_b32 s47, 0
		scratch_load_dword v10, off, s47 offset:640
		s_waitcnt vmcnt(0)
		buffer_load_dword v10, s[4:7], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:548
		scratch_load_dword v205, off, s47 offset:552
		scratch_load_dword v206, off, s47 offset:556
		scratch_load_dword v207, off, s47 offset:560
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[208:211], v[204:207], v[152:155], v3, v198 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s35, 0x20000
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(63) expcnt(7) lgkmcnt(15)
		scratch_load_dword v10, off, s47 offset:628
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:492
		scratch_load_dword v205, off, s47 offset:496
		scratch_load_dword v206, off, s47 offset:500
		scratch_load_dword v207, off, s47 offset:504
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[208:211], v[204:207], v[156:159], v3, v198 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:800
		scratch_load_dword v205, off, s47 offset:804
		scratch_load_dword v206, off, s47 offset:808
		scratch_load_dword v207, off, s47 offset:812
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[212:215], v[204:207], v[160:163], v3, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:768
		scratch_load_dword v205, off, s47 offset:772
		scratch_load_dword v206, off, s47 offset:776
		scratch_load_dword v207, off, s47 offset:780
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[212:215], v[204:207], v[164:167], v3, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:736
		scratch_load_dword v205, off, s47 offset:740
		scratch_load_dword v206, off, s47 offset:744
		scratch_load_dword v207, off, s47 offset:748
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[212:215], v[204:207], v[168:171], v3, v67 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:704
		scratch_load_dword v205, off, s47 offset:708
		scratch_load_dword v206, off, s47 offset:712
		scratch_load_dword v207, off, s47 offset:716
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[212:215], v[204:207], v[172:175], v3, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:672
		scratch_load_dword v205, off, s47 offset:676
		scratch_load_dword v206, off, s47 offset:680
		scratch_load_dword v207, off, s47 offset:684
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[212:215], v[204:207], v[176:179], v3, v193 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:604
		scratch_load_dword v205, off, s47 offset:608
		scratch_load_dword v206, off, s47 offset:612
		scratch_load_dword v207, off, s47 offset:616
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[212:215], v[204:207], v[180:183], v3, v193 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:548
		scratch_load_dword v205, off, s47 offset:552
		scratch_load_dword v206, off, s47 offset:556
		scratch_load_dword v207, off, s47 offset:560
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[212:215], v[204:207], v[184:187], v3, v198 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:492
		scratch_load_dword v205, off, s47 offset:496
		scratch_load_dword v206, off, s47 offset:500
		scratch_load_dword v207, off, s47 offset:504
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[212:215], v[204:207], v[188:191], v3, v198 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(48)
		scratch_load_dword v204, off, s47 offset:832
		scratch_load_dword v205, off, s47 offset:836
		scratch_load_dword v206, off, s47 offset:840
		scratch_load_dword v207, off, s47 offset:844
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[216:219], v[204:207], v[4:7], v2, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(40)
		scratch_load_dword v204, off, s47 offset:928
		scratch_load_dword v205, off, s47 offset:932
		scratch_load_dword v206, off, s47 offset:936
		scratch_load_dword v207, off, s47 offset:940
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[216:219], v[204:207], v[68:71], v2, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(32)
		scratch_load_dword v204, off, s47 offset:896
		scratch_load_dword v205, off, s47 offset:900
		scratch_load_dword v206, off, s47 offset:904
		scratch_load_dword v207, off, s47 offset:908
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[216:219], v[204:207], v[72:75], v2, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[216:219], v[200:203], v[76:79], v2, v67 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v204, off, s47 offset:992
		scratch_load_dword v205, off, s47 offset:996
		scratch_load_dword v206, off, s47 offset:1000
		scratch_load_dword v207, off, s47 offset:1004
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[216:219], v[204:207], v[80:83], v2, v193 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v204, off, s47 offset:960
		scratch_load_dword v205, off, s47 offset:964
		scratch_load_dword v206, off, s47 offset:968
		scratch_load_dword v207, off, s47 offset:972
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[216:219], v[204:207], v[84:87], v2, v193 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v204, off, s47 offset:1056
		scratch_load_dword v205, off, s47 offset:1060
		scratch_load_dword v206, off, s47 offset:1064
		scratch_load_dword v207, off, s47 offset:1068
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[216:219], v[204:207], v[88:91], v2, v198 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v204, off, s47 offset:1024
		scratch_load_dword v205, off, s47 offset:1028
		scratch_load_dword v206, off, s47 offset:1032
		scratch_load_dword v207, off, s47 offset:1036
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[216:219], v[204:207], v[92:95], v2, v198 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:832
		scratch_load_dword v205, off, s47 offset:836
		scratch_load_dword v206, off, s47 offset:840
		scratch_load_dword v207, off, s47 offset:844
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[220:223], v[204:207], v[96:99], v2, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:928
		scratch_load_dword v205, off, s47 offset:932
		scratch_load_dword v206, off, s47 offset:936
		scratch_load_dword v207, off, s47 offset:940
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[220:223], v[204:207], v[100:103], v2, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:896
		scratch_load_dword v205, off, s47 offset:900
		scratch_load_dword v206, off, s47 offset:904
		scratch_load_dword v207, off, s47 offset:908
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[220:223], v[204:207], v[104:107], v2, v67 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[220:223], v[200:203], v[108:111], v2, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:992
		scratch_load_dword v205, off, s47 offset:996
		scratch_load_dword v206, off, s47 offset:1000
		scratch_load_dword v207, off, s47 offset:1004
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[220:223], v[204:207], v[112:115], v2, v193 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:960
		scratch_load_dword v205, off, s47 offset:964
		scratch_load_dword v206, off, s47 offset:968
		scratch_load_dword v207, off, s47 offset:972
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[220:223], v[204:207], v[116:119], v2, v193 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:1056
		scratch_load_dword v205, off, s47 offset:1060
		scratch_load_dword v206, off, s47 offset:1064
		scratch_load_dword v207, off, s47 offset:1068
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[220:223], v[204:207], v[120:123], v2, v198 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:1024
		scratch_load_dword v205, off, s47 offset:1028
		scratch_load_dword v206, off, s47 offset:1032
		scratch_load_dword v207, off, s47 offset:1036
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[220:223], v[204:207], v[124:127], v2, v198 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:832
		scratch_load_dword v205, off, s47 offset:836
		scratch_load_dword v206, off, s47 offset:840
		scratch_load_dword v207, off, s47 offset:844
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[224:227], v[204:207], v[128:131], v3, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:928
		scratch_load_dword v205, off, s47 offset:932
		scratch_load_dword v206, off, s47 offset:936
		scratch_load_dword v207, off, s47 offset:940
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[224:227], v[204:207], v[132:135], v3, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:896
		scratch_load_dword v205, off, s47 offset:900
		scratch_load_dword v206, off, s47 offset:904
		scratch_load_dword v207, off, s47 offset:908
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[224:227], v[204:207], v[136:139], v3, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[224:227], v[200:203], v[140:143], v3, v67 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:992
		scratch_load_dword v205, off, s47 offset:996
		scratch_load_dword v206, off, s47 offset:1000
		scratch_load_dword v207, off, s47 offset:1004
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[224:227], v[204:207], v[144:147], v3, v193 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:960
		scratch_load_dword v205, off, s47 offset:964
		scratch_load_dword v206, off, s47 offset:968
		scratch_load_dword v207, off, s47 offset:972
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[224:227], v[204:207], v[148:151], v3, v193 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:1056
		scratch_load_dword v205, off, s47 offset:1060
		scratch_load_dword v206, off, s47 offset:1064
		scratch_load_dword v207, off, s47 offset:1068
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[224:227], v[204:207], v[152:155], v3, v198 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:1024
		scratch_load_dword v205, off, s47 offset:1028
		scratch_load_dword v206, off, s47 offset:1032
		scratch_load_dword v207, off, s47 offset:1036
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[224:227], v[204:207], v[156:159], v3, v198 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:832
		scratch_load_dword v205, off, s47 offset:836
		scratch_load_dword v206, off, s47 offset:840
		scratch_load_dword v207, off, s47 offset:844
		s_mov_b32 s47, 0
		scratch_load_dword v208, off, s47 offset:864
		scratch_load_dword v209, off, s47 offset:868
		scratch_load_dword v210, off, s47 offset:872
		scratch_load_dword v211, off, s47 offset:876
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[208:211], v[204:207], v[160:163], v3, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:864
		scratch_load_dword v205, off, s47 offset:868
		scratch_load_dword v206, off, s47 offset:872
		scratch_load_dword v207, off, s47 offset:876
		s_mov_b32 s47, 0
		scratch_load_dword v208, off, s47 offset:928
		scratch_load_dword v209, off, s47 offset:932
		scratch_load_dword v210, off, s47 offset:936
		scratch_load_dword v211, off, s47 offset:940
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[204:207], v[208:211], v[164:167], v3, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:864
		scratch_load_dword v205, off, s47 offset:868
		scratch_load_dword v206, off, s47 offset:872
		scratch_load_dword v207, off, s47 offset:876
		s_mov_b32 s47, 0
		scratch_load_dword v208, off, s47 offset:896
		scratch_load_dword v209, off, s47 offset:900
		scratch_load_dword v210, off, s47 offset:904
		scratch_load_dword v211, off, s47 offset:908
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[204:207], v[208:211], v[168:171], v3, v67 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:864
		scratch_load_dword v205, off, s47 offset:868
		scratch_load_dword v206, off, s47 offset:872
		scratch_load_dword v207, off, s47 offset:876
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[204:207], v[200:203], v[172:175], v3, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v200, off, s47 offset:864
		scratch_load_dword v201, off, s47 offset:868
		scratch_load_dword v202, off, s47 offset:872
		scratch_load_dword v203, off, s47 offset:876
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:992
		scratch_load_dword v205, off, s47 offset:996
		scratch_load_dword v206, off, s47 offset:1000
		scratch_load_dword v207, off, s47 offset:1004
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[200:203], v[204:207], v[176:179], v3, v193 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v200, off, s47 offset:864
		scratch_load_dword v201, off, s47 offset:868
		scratch_load_dword v202, off, s47 offset:872
		scratch_load_dword v203, off, s47 offset:876
		s_mov_b32 s47, 0
		scratch_load_dword v204, off, s47 offset:960
		scratch_load_dword v205, off, s47 offset:964
		scratch_load_dword v206, off, s47 offset:968
		scratch_load_dword v207, off, s47 offset:972
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[200:203], v[204:207], v[180:183], v3, v193 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v192, off, s47 offset:864
		scratch_load_dword v193, off, s47 offset:868
		scratch_load_dword v194, off, s47 offset:872
		scratch_load_dword v195, off, s47 offset:876
		s_mov_b32 s47, 0
		scratch_load_dword v200, off, s47 offset:1056
		scratch_load_dword v201, off, s47 offset:1060
		scratch_load_dword v202, off, s47 offset:1064
		scratch_load_dword v203, off, s47 offset:1068
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[192:195], v[200:203], v[184:187], v3, v198 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s47, 0
		scratch_load_dword v192, off, s47 offset:864
		scratch_load_dword v193, off, s47 offset:868
		scratch_load_dword v194, off, s47 offset:872
		scratch_load_dword v195, off, s47 offset:876
		s_mov_b32 s47, 0
		scratch_load_dword v200, off, s47 offset:1024
		scratch_load_dword v201, off, s47 offset:1028
		scratch_load_dword v202, off, s47 offset:1032
		scratch_load_dword v203, off, s47 offset:1036
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[192:195], v[200:203], v[188:191], v3, v198 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s46, s46, 2
		s_cmp_lt_i32 s46, s11
		s_mov_b32 s47, 0
		scratch_load_dword v192, off, s47 offset:412
		scratch_load_dword v193, off, s47 offset:416
		scratch_load_dword v194, off, s47 offset:420
		scratch_load_dword v195, off, s47 offset:424
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v28, v192
		v_mov_b32_e32 v29, v193
		v_mov_b32_e32 v30, v194
		v_mov_b32_e32 v31, v195
		s_mov_b32 s47, 0
		scratch_load_dword v2, off, s47 offset:392
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v9, v2
		s_mov_b32 s47, 0
		scratch_load_dword v2, off, s47 offset:388
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v12, v2
		s_mov_b32 s47, 0
		scratch_load_dword v2, off, s47 offset:384
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v14, v2
		s_mov_b32 s47, 0
		scratch_load_dword v2, off, s47 offset:380
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v15, v2
		s_mov_b32 s47, 0
		scratch_load_dword v2, off, s47 offset:376
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v65, v2
		s_mov_b32 s47, 0
		scratch_load_dword v2, off, s47 offset:372
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v66, v2
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_add_i32 s0, s12, -1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[16:19], v[32:35], v[4:7], v9, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s1, s0, 1
		s_lshl_b32 s0, s1, 16
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 12, v2
		v_add_u32_e32 v2, s0, v3
		v_and_b32_e32 v3, 15, v0
		v_lshlrev_b32_e32 v8, 6, v3
		v_lshlrev_b32_e32 v3, 4, v11
		v_add3_u32 v10, v2, v8, v3
		ds_read_b128 v[192:195], v10 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[16:19], v[36:39], v[68:71], v9, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[196:199], v10 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[16:19], v[40:43], v[72:75], v9, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[200:203], v10 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[16:19], v[44:47], v[76:79], v9, v15 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[204:207], v10 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[16:19], v[48:51], v[80:83], v9, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_and_b32_e32 v2, 15, v0
		v_lshlrev_b32_e32 v3, 6, v2
		v_add_u32_e32 v2, s0, v3
		v_lshlrev_b32_e32 v3, 13, v13
		v_lshlrev_b32_e32 v8, 4, v11
		v_add3_u32 v10, v2, v3, v8
		ds_read_b128 v[208:211], v10 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[16:19], v[52:55], v[84:87], v9, v65 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[212:215], v10 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[16:19], v[56:59], v[88:91], v9, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v10 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[16:19], v[60:63], v[92:95], v9, v66 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[16:19], v10 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[20:23], v[32:35], v[96:99], v9, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v10 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[20:23], v[36:39], v[100:103], v9, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v10 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[20:23], v[40:43], v[104:107], v9, v15 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v10 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[20:23], v[44:47], v[108:111], v9, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[232:235], v10 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[20:23], v[48:51], v[112:115], v9, v65 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[20:23], v[52:55], v[116:119], v9, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], v[56:59], v[120:123], v9, v66 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], v[60:63], v[124:127], v9, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[24:27], v[32:35], v[128:131], v12, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[24:27], v[36:39], v[132:135], v12, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[24:27], v[40:43], v[136:139], v12, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[24:27], v[44:47], v[140:143], v12, v15 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[48:51], v[144:147], v12, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[52:55], v[148:151], v12, v65 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[56:59], v[152:155], v12, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[60:63], v[156:159], v12, v66 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[28:31], v[32:35], v[160:163], v12, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[28:31], v[36:39], v[164:167], v12, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[28:31], v[40:43], v[168:171], v12, v15 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[28:31], v[44:47], v[172:175], v12, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[48:51], v[176:179], v12, v65 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[52:55], v[180:183], v12, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[56:59], v[184:187], v12, v66 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[60:63], v[188:191], v12, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[192:195], v[208:211], v[4:7], v9, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[192:195], v[212:215], v[68:71], v9, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[192:195], v[216:219], v[72:75], v9, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[192:195], v[16:19], v[76:79], v9, v15 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[192:195], v[220:223], v[80:83], v9, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[192:195], v[224:227], v[84:87], v9, v65 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[192:195], v[228:231], v[88:91], v9, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[192:195], v[232:235], v[92:95], v9, v66 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[196:199], v[208:211], v[96:99], v9, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[196:199], v[212:215], v[100:103], v9, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[196:199], v[216:219], v[104:107], v9, v15 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[196:199], v[16:19], v[108:111], v9, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[196:199], v[220:223], v[112:115], v9, v65 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[196:199], v[224:227], v[116:119], v9, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[196:199], v[228:231], v[120:123], v9, v66 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[196:199], v[232:235], v[124:127], v9, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[200:203], v[208:211], v[128:131], v12, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[200:203], v[212:215], v[132:135], v12, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[200:203], v[216:219], v[136:139], v12, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[200:203], v[16:19], v[140:143], v12, v15 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[200:203], v[220:223], v[144:147], v12, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[200:203], v[224:227], v[148:151], v12, v65 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[200:203], v[228:231], v[152:155], v12, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[200:203], v[232:235], v[156:159], v12, v66 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[204:207], v[208:211], v[160:163], v12, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[204:207], v[212:215], v[164:167], v12, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[204:207], v[216:219], v[168:171], v12, v15 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[204:207], v[16:19], v[172:175], v12, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[204:207], v[220:223], v[176:179], v12, v65 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[204:207], v[224:227], v[180:183], v12, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[204:207], v[228:231], v[184:187], v12, v66 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[204:207], v[232:235], v[188:191], v12, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s0, s12, 1
		s_lshl_b32 s1, s0, 16
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 12, v2
		v_add_u32_e32 v2, s1, v3
		v_and_b32_e32 v3, 15, v0
		v_lshlrev_b32_e32 v8, 6, v3
		v_lshlrev_b32_e32 v3, 4, v11
		v_add3_u32 v9, v2, v8, v3
		ds_read_b128 v[16:19], v9
		ds_read_b128 v[20:23], v9 offset:1024
		ds_read_b128 v[24:27], v9 offset:2048
		ds_read_b128 v[28:31], v9 offset:3072
		v_and_b32_e32 v2, 15, v0
		v_lshlrev_b32_e32 v3, 6, v2
		v_add_u32_e32 v2, s1, v3
		v_lshlrev_b32_e32 v3, 13, v13
		v_lshlrev_b32_e32 v8, 4, v11
		v_add3_u32 v10, v2, v3, v8
		ds_read_b128 v[32:35], v10 offset:32768
		ds_read_b128 v[36:39], v10 offset:33792
		ds_read_b128 v[40:43], v10 offset:34816
		ds_read_b128 v[44:47], v10 offset:35840
		ds_read_b128 v[48:51], v10 offset:36864
		ds_read_b128 v[52:55], v10 offset:37888
		ds_read_b128 v[56:59], v10 offset:38912
		ds_read_b128 v[60:63], v10 offset:39936
		s_lshl_b32 s1, s0, 12
		s_add_i32 s0, s1, 0x20000
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 9, v2
		v_lshlrev_b32_e32 v2, 2, v1
		v_add3_u32 v8, s0, v3, v2
		ds_read_b32 v2, v8
		ds_read_b32 v3, v8 offset:256
		v_lshlrev_b32_e32 v8, 10, v13
		v_lshlrev_b32_e32 v11, 2, v1
		v_add3_u32 v1, s0, v11, v8
		ds_read_b32 v8, v1 offset:2048
		ds_read_b32 v11, v1 offset:2304
		ds_read_b32 v12, v1 offset:2560
		ds_read_b32 v13, v1 offset:2816
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[16:19], v[32:35], v[4:7], v2, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[64:67], v9 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[16:19], v[36:39], v[68:71], v2, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[192:195], v9 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[16:19], v[40:43], v[72:75], v2, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[196:199], v9 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[16:19], v[44:47], v[76:79], v2, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[200:203], v9 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[16:19], v[48:51], v[80:83], v2, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[204:207], v10 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[16:19], v[52:55], v[84:87], v2, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[208:211], v10 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[16:19], v[56:59], v[88:91], v2, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[212:215], v10 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[16:19], v[60:63], v[92:95], v2, v13 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[16:19], v10 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[20:23], v[32:35], v[96:99], v2, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v10 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[20:23], v[36:39], v[100:103], v2, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v10 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[20:23], v[40:43], v[104:107], v2, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v10 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[20:23], v[44:47], v[108:111], v2, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v10 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[20:23], v[48:51], v[112:115], v2, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[20:23], v[52:55], v[116:119], v2, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], v[56:59], v[120:123], v2, v13 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], v[60:63], v[124:127], v2, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[24:27], v[32:35], v[128:131], v3, v8 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[24:27], v[36:39], v[132:135], v3, v8 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[24:27], v[40:43], v[136:139], v3, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[24:27], v[44:47], v[140:143], v3, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[48:51], v[144:147], v3, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[52:55], v[148:151], v3, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[56:59], v[152:155], v3, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[60:63], v[156:159], v3, v13 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[28:31], v[32:35], v[160:163], v3, v8 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[28:31], v[36:39], v[164:167], v3, v8 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[28:31], v[40:43], v[168:171], v3, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[28:31], v[44:47], v[172:175], v3, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[48:51], v[176:179], v3, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[52:55], v[180:183], v3, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[56:59], v[184:187], v3, v13 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[60:63], v[188:191], v3, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[64:67], v[204:207], v[4:7], v2, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[64:67], v[208:211], v[68:71], v2, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[64:67], v[212:215], v[72:75], v2, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[64:67], v[16:19], v[76:79], v2, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[64:67], v[216:219], v[80:83], v2, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[64:67], v[220:223], v[84:87], v2, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[64:67], v[224:227], v[88:91], v2, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[64:67], v[228:231], v[92:95], v2, v13 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[192:195], v[204:207], v[96:99], v2, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[192:195], v[208:211], v[100:103], v2, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[192:195], v[212:215], v[104:107], v2, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[192:195], v[16:19], v[108:111], v2, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[192:195], v[216:219], v[112:115], v2, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[192:195], v[220:223], v[116:119], v2, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[192:195], v[224:227], v[120:123], v2, v13 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[192:195], v[228:231], v[124:127], v2, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[196:199], v[204:207], v[128:131], v3, v8 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[196:199], v[208:211], v[132:135], v3, v8 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[196:199], v[212:215], v[136:139], v3, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[196:199], v[16:19], v[140:143], v3, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[196:199], v[216:219], v[144:147], v3, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[196:199], v[220:223], v[148:151], v3, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[196:199], v[224:227], v[152:155], v3, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[196:199], v[228:231], v[156:159], v3, v13 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[200:203], v[204:207], v[160:163], v3, v8 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[200:203], v[208:211], v[164:167], v3, v8 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[200:203], v[212:215], v[168:171], v3, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[200:203], v[16:19], v[172:175], v3, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[200:203], v[216:219], v[176:179], v3, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[200:203], v[220:223], v[180:183], v3, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[200:203], v[224:227], v[184:187], v3, v13 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[200:203], v[228:231], v[188:191], v3, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
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
		v_cvt_pk_f16_f32 v0, v68, v69
		v_cvt_pk_f16_f32 v1, v70, v71
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:512
		v_cvt_pk_f16_f32 v0, v72, v73
		v_cvt_pk_f16_f32 v1, v74, v75
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:1024
		v_cvt_pk_f16_f32 v0, v76, v77
		v_cvt_pk_f16_f32 v1, v78, v79
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:1536
		v_cvt_pk_f16_f32 v0, v80, v81
		v_cvt_pk_f16_f32 v1, v82, v83
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:2048
		v_cvt_pk_f16_f32 v0, v84, v85
		v_cvt_pk_f16_f32 v1, v86, v87
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:2560
		v_cvt_pk_f16_f32 v0, v88, v89
		v_cvt_pk_f16_f32 v1, v90, v91
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:3072
		v_cvt_pk_f16_f32 v0, v92, v93
		v_cvt_pk_f16_f32 v1, v94, v95
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:3584
		v_cvt_pk_f16_f32 v0, v96, v97
		v_cvt_pk_f16_f32 v1, v98, v99
		s_add_i32 s2, s0, 0x1000
		s_add_i32 s3, s2, s1
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen
		v_cvt_pk_f16_f32 v0, v100, v101
		v_cvt_pk_f16_f32 v1, v102, v103
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:512
		v_cvt_pk_f16_f32 v0, v104, v105
		v_cvt_pk_f16_f32 v1, v106, v107
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:1024
		v_cvt_pk_f16_f32 v0, v108, v109
		v_cvt_pk_f16_f32 v1, v110, v111
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:1536
		v_cvt_pk_f16_f32 v0, v112, v113
		v_cvt_pk_f16_f32 v1, v114, v115
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:2048
		v_cvt_pk_f16_f32 v0, v116, v117
		v_cvt_pk_f16_f32 v1, v118, v119
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:2560
		v_cvt_pk_f16_f32 v0, v120, v121
		v_cvt_pk_f16_f32 v1, v122, v123
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:3072
		v_cvt_pk_f16_f32 v0, v124, v125
		v_cvt_pk_f16_f32 v1, v126, v127
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:3584
		v_cvt_pk_f16_f32 v0, v128, v129
		v_cvt_pk_f16_f32 v1, v130, v131
		s_add_i32 s2, s0, 0x2000
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
		s_add_i32 s2, s0, 0x3000
		s_add_i32 s0, s2, s1
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen
		v_cvt_pk_f16_f32 v0, v164, v165
		v_cvt_pk_f16_f32 v1, v166, v167
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:512
		v_cvt_pk_f16_f32 v0, v168, v169
		v_cvt_pk_f16_f32 v1, v170, v171
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:1024
		v_cvt_pk_f16_f32 v0, v172, v173
		v_cvt_pk_f16_f32 v1, v174, v175
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:1536
		v_cvt_pk_f16_f32 v0, v176, v177
		v_cvt_pk_f16_f32 v1, v178, v179
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:2048
		v_cvt_pk_f16_f32 v0, v180, v181
		v_cvt_pk_f16_f32 v1, v182, v183
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:2560
		v_cvt_pk_f16_f32 v0, v184, v185
		v_cvt_pk_f16_f32 v1, v186, v187
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:3072
		v_cvt_pk_f16_f32 v0, v188, v189
		v_cvt_pk_f16_f32 v1, v190, v191
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s0 offen offset:3584
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 24576
		.amdhsa_private_segment_fixed_size 1072
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
		.amdhsa_next_free_vgpr 241
		.amdhsa_next_free_sgpr 50
		.amdhsa_accum_offset 240
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
	.set .Lwmma_f16_matmul_tiled.num_vgpr, 240
	.set .Lwmma_f16_matmul_tiled.num_agpr, 1
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 50
	.set .Lwmma_f16_matmul_tiled.num_named_barrier, 0
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 1072
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
    .private_segment_fixed_size: 1072
    .sgpr_count:     50
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     241
    .agpr_count:     1
    .vgpr_spill_count: 268
    .wavefront_size: 64
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
