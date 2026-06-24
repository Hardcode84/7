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
		s_mov_b32 s10, 0
		scratch_store_dword off, v1, s10 offset:552
		s_mov_b32 s10, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v1, off, s10 offset:552
		s_waitcnt vmcnt(0)
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
		v_and_b32_e32 v1, 63, v0
		v_lshrrev_b32_e32 v9, 7, v0
		v_lshlrev_b32_e32 v10, 9, v9
		v_lshlrev_b32_e32 v9, 2, v1
		v_add3_u32 v11, s36, v10, v9
		s_add_i32 s37, s9, 0x100
		s_add_i32 s38, s37, s35
		v_lshrrev_b32_e32 v9, 7, v0
		v_lshlrev_b32_e32 v10, 9, v9
		v_lshlrev_b32_e32 v9, 2, v1
		v_add3_u32 v12, s38, v10, v9
		v_and_b32_e32 v9, 63, v0
		v_lshlrev_b32_e32 v10, 4, v9
		s_mov_b32 s37, 0
		scratch_load_dword v9, off, s37 offset:552
		s_waitcnt vmcnt(0)
		v_and_b32_e32 v13, 1, v9
		v_lshlrev_b32_e32 v9, 10, v13
		v_add3_u32 v14, s36, v10, v9
		s_lshr_b32 s36, s8, 7
		s_lshl_b32 s8, s36, 9
		s_add_i32 m0, s8, 0x20000
		s_nop 0
		buffer_load_dword v11, s[4:7], 0 offen lds
		s_add_i32 m0, s8, 0x20100
		s_nop 0
		buffer_load_dword v12, s[4:7], 0 offen lds
		s_and_b32 s36, s11, 1
		s_lshl_b32 s11, s36, 10
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
		v_lshlrev_b32_e32 v9, 4, v11
		v_lshrrev_b32_e32 v11, 7, v0
		v_lshlrev_b32_e32 v12, 12, v11
		v_and_b32_e32 v11, 15, v0
		v_lshlrev_b32_e32 v14, 6, v11
		v_add3_u32 v11, v12, v14, v9
		ds_read_b128 v[16:19], v11
		ds_read_b128 v[20:23], v11 offset:1024
		ds_read_b128 v[24:27], v11 offset:2048
		ds_read_b128 v[28:31], v11 offset:3072
		v_lshlrev_b32_e32 v11, 13, v13
		v_and_b32_e32 v12, 15, v0
		v_lshlrev_b32_e32 v14, 6, v12
		v_add3_u32 v12, v14, v11, v9
		ds_read_b128 v[32:35], v12 offset:32768
		ds_read_b128 v[36:39], v12 offset:33792
		ds_read_b128 v[40:43], v12 offset:34816
		ds_read_b128 v[44:47], v12 offset:35840
		ds_read_b128 v[48:51], v12 offset:36864
		ds_read_b128 v[52:55], v12 offset:37888
		ds_read_b128 v[56:59], v12 offset:38912
		ds_read_b128 v[60:63], v12 offset:39936
		v_lshrrev_b32_e32 v11, 7, v0
		v_lshlrev_b32_e32 v12, 9, v11
		v_add_u32_e32 v11, 0x20000, v12
		v_lshlrev_b32_e32 v12, 2, v1
		v_add_u32_e32 v14, v11, v12
		ds_read_b32 v11, v14
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
		s_add_i32 s36, s9, 0x80
		v_add_u32_e32 v64, s36, v2
		v_add3_u32 v67, v64, v3, v8
		s_add_i32 s36, s9, 0x80080
		v_add_u32_e32 v64, s36, v2
		v_add3_u32 v68, v64, v3, v8
		s_add_i32 s36, s9, 0xc0
		v_add_u32_e32 v64, s36, v2
		v_add3_u32 v69, v64, v3, v8
		s_add_i32 s36, s9, 0x800c0
		v_add_u32_e32 v64, s36, v2
		v_add3_u32 v70, v64, v3, v8
		s_add_i32 s36, s10, 0x80
		v_add_u32_e32 v64, s36, v2
		v_add3_u32 v71, v64, v3, v8
		s_add_i32 s36, s10, 0x80080
		v_add_u32_e32 v64, s36, v2
		v_add3_u32 v72, v64, v3, v8
		s_add_i32 s36, s10, 0xc0
		v_add_u32_e32 v64, s36, v2
		v_add3_u32 v73, v64, v3, v8
		s_add_i32 s36, s10, 0x800c0
		v_add_u32_e32 v64, s36, v2
		v_add3_u32 v2, v64, v3, v8
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
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_add_i32 s43, s9, 0x800
		s_add_i32 s44, s43, s35
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 9, v2
		v_lshlrev_b32_e32 v2, 2, v1
		v_add3_u32 v8, s44, v3, v2
		s_add_i32 s43, s9, 0x900
		s_add_i32 s9, s43, s35
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 9, v2
		v_lshlrev_b32_e32 v2, 2, v1
		v_add3_u32 v64, s9, v3, v2
		v_lshlrev_b32_e32 v2, 10, v13
		v_add3_u32 v3, s44, v10, v2
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
		s_add_i32 s9, s12, 1
		v_mov_b32_e32 v2, s9
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
		scratch_store_dword off, v90, s46 offset:44
		scratch_store_dword off, v91, s46 offset:48
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
		scratch_store_dword off, v94, s46 offset:52
		scratch_store_dword off, v95, s46 offset:56
		v_mov_b32_e32 v8, 64
		v_add_co_u32_e64 v90, vcc, v72, v8
		v_addc_co_u32_e64 v91, vcc, v73, 0, vcc
		v_add_co_u32_e64 v94, vcc, v90, v84
		v_addc_co_u32_e64 v95, vcc, v91, v85, vcc
		v_add_co_u32_e64 v90, vcc, v94, v92
		v_addc_co_u32_e64 v91, vcc, v95, v93, vcc
		v_add_co_u32_e64 v94, vcc, v90, v86
		v_addc_co_u32_e64 v95, vcc, v91, v87, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v94, s46 offset:60
		scratch_store_dword off, v95, s46 offset:64
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
		scratch_store_dword off, v94, s46 offset:68
		scratch_store_dword off, v95, s46 offset:72
		v_mov_b32_e32 v90, s14
		v_mov_b32_e32 v91, 0
		v_mul_lo_u32 v94, v70, v90
		v_mul_hi_u32 v95, v70, v90
		v_mul_lo_u32 v64, v70, v91
		v_add_u32_e32 v95, v95, v64
		v_mul_lo_u32 v64, v71, v90
		v_add_u32_e32 v95, v95, v64
		v_add_co_u32_e64 v70, vcc, v94, v84
		v_addc_co_u32_e64 v71, vcc, v95, v85, vcc
		v_add_co_u32_e64 v96, vcc, v70, v92
		v_addc_co_u32_e64 v97, vcc, v71, v93, vcc
		v_add_co_u32_e64 v70, vcc, v96, v86
		v_addc_co_u32_e64 v71, vcc, v97, v87, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v70, s46 offset:76
		scratch_store_dword off, v71, s46 offset:80
		v_add_co_u32_e64 v70, vcc, v94, v3
		v_addc_co_u32_e64 v71, vcc, v95, 0, vcc
		v_add_co_u32_e64 v96, vcc, v70, v84
		v_addc_co_u32_e64 v97, vcc, v71, v85, vcc
		v_add_co_u32_e64 v70, vcc, v96, v92
		v_addc_co_u32_e64 v71, vcc, v97, v93, vcc
		v_add_co_u32_e64 v96, vcc, v70, v86
		v_addc_co_u32_e64 v97, vcc, v71, v87, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v96, s46 offset:84
		scratch_store_dword off, v97, s46 offset:88
		v_add_co_u32_e64 v70, vcc, v94, v8
		v_addc_co_u32_e64 v71, vcc, v95, 0, vcc
		v_add_co_u32_e64 v96, vcc, v70, v84
		v_addc_co_u32_e64 v97, vcc, v71, v85, vcc
		v_add_co_u32_e64 v70, vcc, v96, v92
		v_addc_co_u32_e64 v71, vcc, v97, v93, vcc
		v_add_co_u32_e64 v96, vcc, v70, v86
		v_addc_co_u32_e64 v97, vcc, v71, v87, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v96, s46 offset:92
		scratch_store_dword off, v97, s46 offset:96
		v_add_co_u32_e64 v70, vcc, v94, v10
		v_addc_co_u32_e64 v71, vcc, v95, 0, vcc
		v_add_co_u32_e64 v94, vcc, v70, v84
		v_addc_co_u32_e64 v95, vcc, v71, v85, vcc
		v_add_co_u32_e64 v70, vcc, v94, v92
		v_addc_co_u32_e64 v71, vcc, v95, v93, vcc
		v_add_co_u32_e64 v84, vcc, v70, v86
		v_addc_co_u32_e64 v85, vcc, v71, v87, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v84, s46 offset:100
		scratch_store_dword off, v85, s46 offset:104
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
		scratch_store_dword off, v84, s46 offset:108
		scratch_store_dword off, v85, s46 offset:112
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
		scratch_store_dword off, v72, s46 offset:116
		scratch_store_dword off, v73, s46 offset:120
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
		scratch_store_dword off, v68, s46 offset:140
		scratch_store_dword off, v69, s46 offset:144
		v_mov_b64_e32 v[68:69], 0
		v_mov_b64_e32 v[70:71], 0
		v_mov_b64_e32 v[72:73], 0
		v_mov_b64_e32 v[74:75], 0
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
		s_mov_b32 s46, 0
		scratch_store_dword off, v148, s46 offset:556
		scratch_store_dword off, v149, s46 offset:560
		scratch_store_dword off, v150, s46 offset:564
		scratch_store_dword off, v151, s46 offset:568
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
		scratch_store_dword off, v148, s46 offset:232
		scratch_store_dword off, v149, s46 offset:236
		scratch_store_dword off, v150, s46 offset:240
		scratch_store_dword off, v151, s46 offset:244
		v_mov_b64_e32 v[148:149], 0
		v_mov_b64_e32 v[150:151], 0
		s_mov_b32 s46, 0
		scratch_store_dword off, v148, s46 offset:216
		scratch_store_dword off, v149, s46 offset:220
		scratch_store_dword off, v150, s46 offset:224
		scratch_store_dword off, v151, s46 offset:228
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
		v_mul_lo_u32 v150, v76, v148
		v_mul_hi_u32 v151, v76, v148
		v_mul_lo_u32 v8, v76, v149
		v_add_u32_e32 v151, v151, v8
		v_mul_lo_u32 v8, v77, v148
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
		s_waitcnt vmcnt(63) expcnt(7) lgkmcnt(15)
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
		s_waitcnt vmcnt(62)
		scratch_load_dword v152, off, s47 offset:92
		scratch_load_dword v153, off, s47 offset:96
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v154, vcc, v152, v150
		v_addc_co_u32_e64 v155, vcc, v153, v151, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v154, s47 offset:16
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(61)
		scratch_load_dword v152, off, s47 offset:100
		scratch_load_dword v153, off, s47 offset:104
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v154, vcc, v152, v150
		v_addc_co_u32_e64 v155, vcc, v153, v151, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v154, s47 offset:12
		v_mul_lo_u32 v150, v78, v148
		v_mul_hi_u32 v151, v78, v148
		v_mul_lo_u32 v8, v78, v149
		v_add_u32_e32 v151, v151, v8
		v_mul_lo_u32 v8, v79, v148
		v_add_u32_e32 v151, v151, v8
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(60)
		scratch_load_dword v148, off, s47 offset:108
		scratch_load_dword v149, off, s47 offset:112
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v152, vcc, v148, v150
		v_addc_co_u32_e64 v153, vcc, v149, v151, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v152, s47 offset:8
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(59)
		scratch_load_dword v148, off, s47 offset:116
		scratch_load_dword v149, off, s47 offset:120
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v152, vcc, v148, v150
		v_addc_co_u32_e64 v153, vcc, v149, v151, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v152, s47 offset:4
		s_mov_b32 s47, 0
		s_waitcnt vmcnt(58)
		scratch_load_dword v148, off, s47 offset:140
		scratch_load_dword v149, off, s47 offset:144
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v152, vcc, v148, v150
		v_addc_co_u32_e64 v153, vcc, v149, v151, vcc
		s_mov_b32 s47, 0
		scratch_store_dword off, v152, s47
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[16:19], v[32:35], v[4:7], v11, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s47, s46, 1
		s_lshl_b32 s46, s47, 16
		v_mov_b32_e32 v8, s46
		s_nop 0
		v_readfirstlane_b32 s46, v8
		v_lshrrev_b32_e32 v10, 7, v0
		v_lshlrev_b32_e32 v64, 12, v10
		v_add_u32_e32 v10, s46, v64
		v_and_b32_e32 v64, 15, v0
		v_lshlrev_b32_e32 v67, 6, v64
		v_add3_u32 v64, v10, v67, v9
		ds_read_b128 v[148:151], v64 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[16:19], v[36:39], v[68:71], v11, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[152:155], v64 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[16:19], v[40:43], v[72:75], v11, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[156:159], v64 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[16:19], v[44:47], v[80:83], v11, v15 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[160:163], v64 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[16:19], v[48:51], v[84:87], v11, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_readfirstlane_b32 s46, v8
		v_and_b32_e32 v8, 15, v0
		v_lshlrev_b32_e32 v10, 6, v8
		v_add_u32_e32 v8, s46, v10
		v_lshlrev_b32_e32 v10, 13, v13
		v_add3_u32 v64, v8, v10, v9
		ds_read_b128 v[164:167], v64 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[16:19], v[52:55], v[88:91], v11, v65 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[168:171], v64 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[16:19], v[56:59], v[92:95], v11, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[172:175], v64 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[16:19], v[60:63], v[96:99], v11, v66 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[176:179], v64 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[20:23], v[32:35], v[100:103], v11, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[180:183], v64 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[20:23], v[36:39], v[104:107], v11, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[184:187], v64 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[20:23], v[40:43], v[108:111], v11, v15 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[188:191], v64 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[20:23], v[44:47], v[112:115], v11, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[192:195], v64 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[20:23], v[48:51], v[116:119], v11, v65 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(10)
		scratch_load_dword v8, off, s46 offset:40
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], v[52:55], v[120:123], v11, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s28
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(9)
		scratch_load_dword v8, off, s46 offset:36
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], v[56:59], v[124:127], v11, v66 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s29
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v8, off, s46 offset:32
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[20:23], v[60:63], v[128:131], v11, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s30
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(7)
		scratch_load_dword v8, off, s46 offset:28
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v8, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[24:27], v[32:35], v[132:135], v12, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s31
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(6)
		scratch_load_dword v8, off, s46 offset:24
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v8, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[24:27], v[36:39], v[136:139], v12, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s32
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(5)
		scratch_load_dword v8, off, s46 offset:20
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v8, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[24:27], v[40:43], v[140:143], v12, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s33
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v8, off, s46 offset:16
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v8, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[44:47], v[144:147], v12, v15 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s34
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(3)
		scratch_load_dword v8, off, s46 offset:12
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v8, s[0:3], 0 offen lds
		s_mov_b32 s46, 0
		scratch_load_dword v196, off, s46 offset:556
		scratch_load_dword v197, off, s46 offset:560
		scratch_load_dword v198, off, s46 offset:564
		scratch_load_dword v199, off, s46 offset:568
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[48:51], v[196:199], v12, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s8, 0x20000
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(2)
		scratch_load_dword v8, off, s46 offset:8
		s_waitcnt vmcnt(0)
		buffer_load_dword v8, s[4:7], 0 offen lds
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:360
		scratch_load_dword v201, off, s46 offset:364
		scratch_load_dword v202, off, s46 offset:368
		scratch_load_dword v203, off, s46 offset:372
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[52:55], v[200:203], v12, v65 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s9, 0x20000
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(1)
		scratch_load_dword v8, off, s46 offset:4
		s_waitcnt vmcnt(0)
		buffer_load_dword v8, s[4:7], 0 offen lds
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:344
		scratch_load_dword v205, off, s46 offset:348
		scratch_load_dword v206, off, s46 offset:352
		scratch_load_dword v207, off, s46 offset:356
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[56:59], v[204:207], v12, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s35, 0x20000
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v8, off, s46
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v8, s[24:27], 0 offen lds
		s_mov_b32 s46, 0
		scratch_load_dword v208, off, s46 offset:328
		scratch_load_dword v209, off, s46 offset:332
		scratch_load_dword v210, off, s46 offset:336
		scratch_load_dword v211, off, s46 offset:340
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], v[60:63], v[208:211], v12, v66 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_and_b32 s46, s11, 1
		s_lshl_b32 s47, s46, 16
		v_lshrrev_b32_e32 v8, 7, v0
		v_lshlrev_b32_e32 v10, 12, v8
		v_add_u32_e32 v8, s47, v10
		v_and_b32_e32 v10, 15, v0
		v_lshlrev_b32_e32 v64, 6, v10
		v_add3_u32 v10, v8, v64, v9
		ds_read_b128 v[16:19], v10
		s_mov_b32 s48, 0
		scratch_load_dword v212, off, s48 offset:312
		scratch_load_dword v213, off, s48 offset:316
		scratch_load_dword v214, off, s48 offset:320
		scratch_load_dword v215, off, s48 offset:324
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[28:31], v[32:35], v[212:215], v12, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v10 offset:1024
		s_mov_b32 s48, 0
		scratch_load_dword v216, off, s48 offset:296
		scratch_load_dword v217, off, s48 offset:300
		scratch_load_dword v218, off, s48 offset:304
		scratch_load_dword v219, off, s48 offset:308
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[28:31], v[36:39], v[216:219], v12, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v10 offset:2048
		s_mov_b32 s48, 0
		scratch_load_dword v220, off, s48 offset:280
		scratch_load_dword v221, off, s48 offset:284
		scratch_load_dword v222, off, s48 offset:288
		scratch_load_dword v223, off, s48 offset:292
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[28:31], v[40:43], v[220:223], v12, v15 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v10 offset:3072
		s_mov_b32 s48, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v224, s48 offset:124
		scratch_store_dword off, v225, s48 offset:128
		scratch_store_dword off, v226, s48 offset:132
		scratch_store_dword off, v227, s48 offset:136
		s_mov_b32 s48, 0
		scratch_load_dword v224, off, s48 offset:264
		scratch_load_dword v225, off, s48 offset:268
		scratch_load_dword v226, off, s48 offset:272
		scratch_load_dword v227, off, s48 offset:276
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[28:31], v[44:47], v[224:227], v12, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_and_b32_e32 v8, 15, v0
		v_lshlrev_b32_e32 v10, 6, v8
		v_add_u32_e32 v8, s47, v10
		v_lshlrev_b32_e32 v10, 13, v13
		v_add3_u32 v64, v8, v10, v9
		ds_read_b128 v[32:35], v64 offset:32768
		s_mov_b32 s47, 0
		scratch_load_dword v228, off, s47 offset:248
		scratch_load_dword v229, off, s47 offset:252
		scratch_load_dword v230, off, s47 offset:256
		scratch_load_dword v231, off, s47 offset:260
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[28:31], v[48:51], v[228:231], v12, v65 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[36:39], v64 offset:33792
		s_mov_b32 s47, 0
		scratch_load_dword v232, off, s47 offset:232
		scratch_load_dword v233, off, s47 offset:236
		scratch_load_dword v234, off, s47 offset:240
		scratch_load_dword v235, off, s47 offset:244
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[28:31], v[52:55], v[232:235], v12, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[40:43], v64 offset:34816
		s_mov_b32 s47, 0
		scratch_load_dword v236, off, s47 offset:216
		scratch_load_dword v237, off, s47 offset:220
		scratch_load_dword v238, off, s47 offset:224
		scratch_load_dword v239, off, s47 offset:228
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[28:31], v[56:59], v[236:239], v12, v66 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[44:47], v64 offset:35840
		s_mov_b32 s47, 0
		scratch_load_dword v240, off, s47 offset:148
		scratch_load_dword v241, off, s47 offset:152
		scratch_load_dword v242, off, s47 offset:156
		scratch_load_dword v243, off, s47 offset:160
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[28:31], v[60:63], v[240:243], v12, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[48:51], v64 offset:36864
		ds_read_b128 v[52:55], v64 offset:37888
		ds_read_b128 v[56:59], v64 offset:38912
		ds_read_b128 v[60:63], v64 offset:39936
		s_lshl_b32 s47, s46, 12
		s_add_i32 s46, s47, 0x20000
		v_lshrrev_b32_e32 v8, 7, v0
		v_lshlrev_b32_e32 v10, 9, v8
		v_lshlrev_b32_e32 v8, 2, v1
		v_add3_u32 v64, s46, v10, v8
		ds_read_b32 v8, v64
		ds_read_b32 v10, v64 offset:256
		v_lshlrev_b32_e32 v64, 10, v13
		v_lshlrev_b32_e32 v67, 2, v1
		v_add3_u32 v244, s46, v67, v64
		ds_read_b32 v64, v244 offset:2048
		ds_read_b32 v67, v244 offset:2304
		ds_read_b32 v245, v244 offset:2560
		ds_read_b32 v246, v244 offset:2816
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[148:151], v[164:167], v[4:7], v11, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[148:151], v[168:171], v[68:71], v11, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[148:151], v[172:175], v[72:75], v11, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[148:151], v[176:179], v[80:83], v11, v15 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[148:151], v[180:183], v[84:87], v11, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[148:151], v[184:187], v[88:91], v11, v65 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[148:151], v[188:191], v[92:95], v11, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[148:151], v[192:195], v[96:99], v11, v66 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[152:155], v[164:167], v[100:103], v11, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[152:155], v[168:171], v[104:107], v11, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[152:155], v[172:175], v[108:111], v11, v15 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[152:155], v[176:179], v[112:115], v11, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[152:155], v[180:183], v[116:119], v11, v65 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[152:155], v[184:187], v[120:123], v11, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[152:155], v[188:191], v[124:127], v11, v66 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[152:155], v[192:195], v[128:131], v11, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[156:159], v[164:167], v[132:135], v12, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[156:159], v[168:171], v[136:139], v12, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[156:159], v[172:175], v[140:143], v12, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[156:159], v[176:179], v[144:147], v12, v15 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[156:159], v[180:183], v[196:199], v12, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v196, s46 offset:572
		scratch_store_dword off, v197, s46 offset:576
		scratch_store_dword off, v198, s46 offset:580
		scratch_store_dword off, v199, s46 offset:584
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[156:159], v[184:187], v[200:203], v12, v65 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v200, s46 offset:536
		scratch_store_dword off, v201, s46 offset:540
		scratch_store_dword off, v202, s46 offset:544
		scratch_store_dword off, v203, s46 offset:548
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[156:159], v[188:191], v[204:207], v12, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v204, s46 offset:520
		scratch_store_dword off, v205, s46 offset:524
		scratch_store_dword off, v206, s46 offset:528
		scratch_store_dword off, v207, s46 offset:532
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[156:159], v[192:195], v[208:211], v12, v66 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v208, s46 offset:504
		scratch_store_dword off, v209, s46 offset:508
		scratch_store_dword off, v210, s46 offset:512
		scratch_store_dword off, v211, s46 offset:516
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[160:163], v[164:167], v[212:215], v12, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v212, s46 offset:488
		scratch_store_dword off, v213, s46 offset:492
		scratch_store_dword off, v214, s46 offset:496
		scratch_store_dword off, v215, s46 offset:500
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[160:163], v[168:171], v[216:219], v12, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v216, s46 offset:472
		scratch_store_dword off, v217, s46 offset:476
		scratch_store_dword off, v218, s46 offset:480
		scratch_store_dword off, v219, s46 offset:484
		v_mfma_scale_f32_16x16x128_f8f6f4 v[220:223], v[160:163], v[172:175], v[220:223], v12, v15 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v220, s46 offset:456
		scratch_store_dword off, v221, s46 offset:460
		scratch_store_dword off, v222, s46 offset:464
		scratch_store_dword off, v223, s46 offset:468
		v_mfma_scale_f32_16x16x128_f8f6f4 v[224:227], v[160:163], v[176:179], v[224:227], v12, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v224, s46 offset:440
		scratch_store_dword off, v225, s46 offset:444
		scratch_store_dword off, v226, s46 offset:448
		scratch_store_dword off, v227, s46 offset:452
		v_mfma_scale_f32_16x16x128_f8f6f4 v[228:231], v[160:163], v[180:183], v[228:231], v12, v65 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v228, s46 offset:424
		scratch_store_dword off, v229, s46 offset:428
		scratch_store_dword off, v230, s46 offset:432
		scratch_store_dword off, v231, s46 offset:436
		v_mfma_scale_f32_16x16x128_f8f6f4 v[232:235], v[160:163], v[184:187], v[232:235], v12, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v232, s46 offset:408
		scratch_store_dword off, v233, s46 offset:412
		scratch_store_dword off, v234, s46 offset:416
		scratch_store_dword off, v235, s46 offset:420
		v_mfma_scale_f32_16x16x128_f8f6f4 v[236:239], v[160:163], v[188:191], v[236:239], v12, v66 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v236, s46 offset:392
		scratch_store_dword off, v237, s46 offset:396
		scratch_store_dword off, v238, s46 offset:400
		scratch_store_dword off, v239, s46 offset:404
		v_mfma_scale_f32_16x16x128_f8f6f4 v[240:243], v[160:163], v[192:195], v[240:243], v12, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v240, s46 offset:376
		scratch_store_dword off, v241, s46 offset:380
		scratch_store_dword off, v242, s46 offset:384
		scratch_store_dword off, v243, s46 offset:388
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s46, v3
		s_and_b32 s47, s46, 1
		s_lshl_b32 s46, s47, 16
		v_lshrrev_b32_e32 v3, 7, v0
		v_lshlrev_b32_e32 v148, 12, v3
		v_add_u32_e32 v3, s46, v148
		v_and_b32_e32 v148, 15, v0
		v_lshlrev_b32_e32 v149, 6, v148
		v_add3_u32 v148, v3, v149, v9
		ds_read_b128 v[152:155], v148
		ds_read_b128 v[156:159], v148 offset:1024
		ds_read_b128 v[160:163], v148 offset:2048
		ds_read_b128 v[164:167], v148 offset:3072
		v_and_b32_e32 v3, 15, v0
		v_lshlrev_b32_e32 v149, 6, v3
		v_add_u32_e32 v3, s46, v149
		v_lshlrev_b32_e32 v149, 13, v13
		v_add3_u32 v150, v3, v149, v9
		ds_read_b128 v[168:171], v150 offset:32768
		ds_read_b128 v[172:175], v150 offset:33792
		ds_read_b128 v[176:179], v150 offset:34816
		ds_read_b128 v[180:183], v150 offset:35840
		ds_read_b128 v[184:187], v150 offset:36864
		ds_read_b128 v[188:191], v150 offset:37888
		ds_read_b128 v[192:195], v150 offset:38912
		ds_read_b128 v[196:199], v150 offset:39936
		s_lshl_b32 s46, s47, 12
		s_add_i32 s47, s46, 0x20000
		v_lshrrev_b32_e32 v3, 7, v0
		v_lshlrev_b32_e32 v149, 9, v3
		v_lshlrev_b32_e32 v3, 2, v1
		v_add3_u32 v151, s47, v149, v3
		ds_read_b32 v3, v151
		ds_read_b32 v149, v151 offset:256
		v_lshlrev_b32_e32 v151, 10, v13
		v_lshlrev_b32_e32 v200, 2, v1
		v_add3_u32 v201, s47, v200, v151
		ds_read_b32 v151, v201 offset:2048
		ds_read_b32 v200, v201 offset:2304
		ds_read_b32 v202, v201 offset:2560
		ds_read_b32 v203, v201 offset:2816
		s_waitcnt lgkmcnt(0)
		s_add_i32 s46, s11, 1
		v_mov_b32_e32 v204, s46
		v_mov_b32_e32 v205, 0
		s_mov_b32 s46, 0
		scratch_store_dword off, v204, s46 offset:164
		scratch_store_dword off, v205, s46 offset:168
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v204, off, s46 offset:164
		scratch_load_dword v205, off, s46 offset:168
		s_waitcnt vmcnt(0)
		v_mul_lo_u32 v206, v76, v204
		v_mul_hi_u32 v207, v76, v204
		v_mul_lo_u32 v201, v76, v205
		v_add_u32_e32 v207, v207, v201
		v_mul_lo_u32 v201, v77, v204
		v_add_u32_e32 v207, v207, v201
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:44
		scratch_load_dword v205, off, s46 offset:48
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v208, vcc, v204, v206
		v_addc_co_u32_e64 v209, vcc, v205, v207, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v208, s46 offset:172
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:52
		scratch_load_dword v205, off, s46 offset:56
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v208, vcc, v204, v206
		v_addc_co_u32_e64 v209, vcc, v205, v207, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v208, s46 offset:176
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:60
		scratch_load_dword v205, off, s46 offset:64
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v208, vcc, v204, v206
		v_addc_co_u32_e64 v209, vcc, v205, v207, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v208, s46 offset:180
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:68
		scratch_load_dword v205, off, s46 offset:72
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v208, vcc, v204, v206
		v_addc_co_u32_e64 v209, vcc, v205, v207, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v208, s46 offset:184
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:76
		scratch_load_dword v205, off, s46 offset:80
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v208, vcc, v204, v206
		v_addc_co_u32_e64 v209, vcc, v205, v207, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v208, s46 offset:188
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:84
		scratch_load_dword v205, off, s46 offset:88
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v208, vcc, v204, v206
		v_addc_co_u32_e64 v209, vcc, v205, v207, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v208, s46 offset:192
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:92
		scratch_load_dword v205, off, s46 offset:96
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v208, vcc, v204, v206
		v_addc_co_u32_e64 v209, vcc, v205, v207, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v208, s46 offset:196
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:100
		scratch_load_dword v205, off, s46 offset:104
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v208, vcc, v204, v206
		v_addc_co_u32_e64 v209, vcc, v205, v207, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v208, s46 offset:200
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:164
		scratch_load_dword v205, off, s46 offset:168
		s_waitcnt vmcnt(0)
		v_mul_lo_u32 v206, v78, v204
		v_mul_hi_u32 v207, v78, v204
		v_mul_lo_u32 v201, v78, v205
		v_add_u32_e32 v207, v207, v201
		v_mul_lo_u32 v201, v79, v204
		v_add_u32_e32 v207, v207, v201
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:108
		scratch_load_dword v205, off, s46 offset:112
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v208, vcc, v204, v206
		v_addc_co_u32_e64 v209, vcc, v205, v207, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v208, s46 offset:204
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:116
		scratch_load_dword v205, off, s46 offset:120
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v208, vcc, v204, v206
		v_addc_co_u32_e64 v209, vcc, v205, v207, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v208, s46 offset:208
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:140
		scratch_load_dword v205, off, s46 offset:144
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v208, vcc, v204, v206
		v_addc_co_u32_e64 v209, vcc, v205, v207, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v208, s46 offset:212
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[152:155], v[168:171], v[4:7], v3, v151 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[204:207], v148 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[152:155], v[172:175], v[68:71], v3, v151 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[208:211], v148 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[152:155], v[176:179], v[72:75], v3, v200 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[212:215], v148 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[152:155], v[180:183], v[80:83], v3, v200 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v148 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[152:155], v[184:187], v[84:87], v3, v202 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v150 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[152:155], v[188:191], v[88:91], v3, v202 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v150 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[152:155], v[192:195], v[92:95], v3, v203 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v150 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[152:155], v[196:199], v[96:99], v3, v203 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[152:155], v150 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[156:159], v[168:171], v[100:103], v3, v151 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[232:235], v150 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[156:159], v[172:175], v[104:107], v3, v151 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[236:239], v150 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[156:159], v[176:179], v[108:111], v3, v200 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v150 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[156:159], v[180:183], v[112:115], v3, v200 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v150 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[156:159], v[184:187], v[116:119], v3, v202 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s10
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(10)
		scratch_load_dword v148, off, s46 offset:172
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v148, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[156:159], v[188:191], v[120:123], v3, v202 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s36
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(9)
		scratch_load_dword v148, off, s46 offset:176
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v148, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[156:159], v[192:195], v[124:127], v3, v203 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s37
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v148, off, s46 offset:180
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v148, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[156:159], v[196:199], v[128:131], v3, v203 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s38
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(7)
		scratch_load_dword v148, off, s46 offset:184
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v148, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[160:163], v[168:171], v[132:135], v149, v151 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s39
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(6)
		scratch_load_dword v148, off, s46 offset:188
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v148, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[160:163], v[172:175], v[136:139], v149, v151 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s40
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(5)
		scratch_load_dword v148, off, s46 offset:192
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v148, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[160:163], v[176:179], v[140:143], v149, v200 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s41
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v148, off, s46 offset:196
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v148, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[160:163], v[180:183], v[144:147], v149, v200 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s42
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(3)
		scratch_load_dword v148, off, s46 offset:200
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v148, s[0:3], 0 offen lds
		s_mov_b32 s46, 0
		scratch_load_dword v156, off, s46 offset:572
		scratch_load_dword v157, off, s46 offset:576
		scratch_load_dword v158, off, s46 offset:580
		scratch_load_dword v159, off, s46 offset:584
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[160:163], v[184:187], v[156:159], v149, v202 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v156, s46 offset:620
		scratch_store_dword off, v157, s46 offset:624
		scratch_store_dword off, v158, s46 offset:628
		scratch_store_dword off, v159, s46 offset:632
		s_add_i32 m0, s43, 0x20000
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(6)
		scratch_load_dword v148, off, s46 offset:204
		s_waitcnt vmcnt(0)
		buffer_load_dword v148, s[4:7], 0 offen lds
		s_mov_b32 s46, 0
		scratch_load_dword v156, off, s46 offset:536
		scratch_load_dword v157, off, s46 offset:540
		scratch_load_dword v158, off, s46 offset:544
		scratch_load_dword v159, off, s46 offset:548
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[160:163], v[188:191], v[156:159], v149, v202 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v156, s46 offset:588
		scratch_store_dword off, v157, s46 offset:592
		scratch_store_dword off, v158, s46 offset:596
		scratch_store_dword off, v159, s46 offset:600
		s_add_i32 m0, s44, 0x20000
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(9)
		scratch_load_dword v148, off, s46 offset:208
		s_waitcnt vmcnt(0)
		buffer_load_dword v148, s[4:7], 0 offen lds
		s_mov_b32 s46, 0
		scratch_load_dword v156, off, s46 offset:520
		scratch_load_dword v157, off, s46 offset:524
		scratch_load_dword v158, off, s46 offset:528
		scratch_load_dword v159, off, s46 offset:532
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[160:163], v[192:195], v[156:159], v149, v203 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_nop 6
		scratch_store_dword off, v156, s46 offset:604
		scratch_store_dword off, v157, s46 offset:608
		scratch_store_dword off, v158, s46 offset:612
		scratch_store_dword off, v159, s46 offset:616
		s_add_i32 m0, s45, 0x20000
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(12)
		scratch_load_dword v148, off, s46 offset:212
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v148, s[24:27], 0 offen lds
		s_mov_b32 s46, 0
		scratch_load_dword v156, off, s46 offset:504
		scratch_load_dword v157, off, s46 offset:508
		scratch_load_dword v158, off, s46 offset:512
		scratch_load_dword v159, off, s46 offset:516
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[160:163], v[196:199], v[156:159], v149, v203 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v160, off, s46 offset:488
		scratch_load_dword v161, off, s46 offset:492
		scratch_load_dword v162, off, s46 offset:496
		scratch_load_dword v163, off, s46 offset:500
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[164:167], v[168:171], v[160:163], v149, v151 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v168, off, s46 offset:472
		scratch_load_dword v169, off, s46 offset:476
		scratch_load_dword v170, off, s46 offset:480
		scratch_load_dword v171, off, s46 offset:484
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[164:167], v[172:175], v[168:171], v149, v151 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v172, off, s46 offset:456
		scratch_load_dword v173, off, s46 offset:460
		scratch_load_dword v174, off, s46 offset:464
		scratch_load_dword v175, off, s46 offset:468
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[164:167], v[176:179], v[172:175], v149, v200 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v176, off, s46 offset:440
		scratch_load_dword v177, off, s46 offset:444
		scratch_load_dword v178, off, s46 offset:448
		scratch_load_dword v179, off, s46 offset:452
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[164:167], v[180:183], v[176:179], v149, v200 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v180, off, s46 offset:424
		scratch_load_dword v181, off, s46 offset:428
		scratch_load_dword v182, off, s46 offset:432
		scratch_load_dword v183, off, s46 offset:436
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[164:167], v[184:187], v[180:183], v149, v202 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v184, off, s46 offset:408
		scratch_load_dword v185, off, s46 offset:412
		scratch_load_dword v186, off, s46 offset:416
		scratch_load_dword v187, off, s46 offset:420
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[164:167], v[188:191], v[184:187], v149, v202 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v188, off, s46 offset:392
		scratch_load_dword v189, off, s46 offset:396
		scratch_load_dword v190, off, s46 offset:400
		scratch_load_dword v191, off, s46 offset:404
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[164:167], v[192:195], v[188:191], v149, v203 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v192, off, s46 offset:376
		scratch_load_dword v193, off, s46 offset:380
		scratch_load_dword v194, off, s46 offset:384
		scratch_load_dword v195, off, s46 offset:388
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[164:167], v[196:199], v[192:195], v149, v203 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[204:207], v[220:223], v[4:7], v3, v151 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[204:207], v[224:227], v[68:71], v3, v151 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[204:207], v[228:231], v[72:75], v3, v200 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[204:207], v[152:155], v[80:83], v3, v200 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[204:207], v[232:235], v[84:87], v3, v202 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[204:207], v[236:239], v[88:91], v3, v202 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[204:207], v[240:243], v[92:95], v3, v203 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[204:207], v[248:251], v[96:99], v3, v203 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[208:211], v[220:223], v[100:103], v3, v151 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[208:211], v[224:227], v[104:107], v3, v151 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[208:211], v[228:231], v[108:111], v3, v200 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[208:211], v[152:155], v[112:115], v3, v200 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[208:211], v[232:235], v[116:119], v3, v202 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[208:211], v[236:239], v[120:123], v3, v202 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[208:211], v[240:243], v[124:127], v3, v203 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[208:211], v[248:251], v[128:131], v3, v203 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[212:215], v[220:223], v[132:135], v149, v151 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[212:215], v[224:227], v[136:139], v149, v151 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[212:215], v[228:231], v[140:143], v149, v200 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[212:215], v[152:155], v[144:147], v149, v200 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v164, off, s46 offset:620
		scratch_load_dword v165, off, s46 offset:624
		scratch_load_dword v166, off, s46 offset:628
		scratch_load_dword v167, off, s46 offset:632
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[212:215], v[232:235], v[164:167], v149, v202 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v196, off, s46 offset:588
		scratch_load_dword v197, off, s46 offset:592
		scratch_load_dword v198, off, s46 offset:596
		scratch_load_dword v199, off, s46 offset:600
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[212:215], v[236:239], v[196:199], v149, v202 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v204, off, s46 offset:604
		scratch_load_dword v205, off, s46 offset:608
		scratch_load_dword v206, off, s46 offset:612
		scratch_load_dword v207, off, s46 offset:616
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[212:215], v[240:243], v[204:207], v149, v203 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[212:215], v[248:251], v[156:159], v149, v203 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[216:219], v[220:223], v[160:163], v149, v151 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[216:219], v[224:227], v[168:171], v149, v151 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[216:219], v[228:231], v[172:175], v149, v200 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[216:219], v[152:155], v[176:179], v149, v200 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[216:219], v[232:235], v[180:183], v149, v202 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[216:219], v[236:239], v[184:187], v149, v202 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[216:219], v[240:243], v[188:191], v149, v203 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[216:219], v[248:251], v[192:195], v149, v203 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s11, s11, 2
		v_readfirstlane_b32 s46, v2
		s_cmp_lt_i32 s11, s46
		s_mov_b32 s46, 0
		s_nop 2
		scratch_load_dword v148, off, s46 offset:124
		scratch_load_dword v149, off, s46 offset:128
		scratch_load_dword v150, off, s46 offset:132
		scratch_load_dword v151, off, s46 offset:136
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v28, v148
		v_mov_b32_e32 v29, v149
		v_mov_b32_e32 v30, v150
		v_mov_b32_e32 v31, v151
		v_mov_b32_e32 v11, v8
		v_mov_b32_e32 v12, v10
		v_mov_b32_e32 v14, v64
		v_mov_b32_e32 v15, v67
		v_mov_b32_e32 v65, v245
		v_mov_b32_e32 v66, v246
		s_mov_b32 s46, 0
		scratch_store_dword off, v196, s46 offset:360
		scratch_store_dword off, v197, s46 offset:364
		scratch_store_dword off, v198, s46 offset:368
		scratch_store_dword off, v199, s46 offset:372
		s_mov_b32 s46, 0
		scratch_store_dword off, v204, s46 offset:344
		scratch_store_dword off, v205, s46 offset:348
		scratch_store_dword off, v206, s46 offset:352
		scratch_store_dword off, v207, s46 offset:356
		s_mov_b32 s46, 0
		scratch_store_dword off, v156, s46 offset:328
		scratch_store_dword off, v157, s46 offset:332
		scratch_store_dword off, v158, s46 offset:336
		scratch_store_dword off, v159, s46 offset:340
		s_mov_b32 s46, 0
		scratch_store_dword off, v160, s46 offset:312
		scratch_store_dword off, v161, s46 offset:316
		scratch_store_dword off, v162, s46 offset:320
		scratch_store_dword off, v163, s46 offset:324
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
		scratch_store_dword off, v184, s46 offset:232
		scratch_store_dword off, v185, s46 offset:236
		scratch_store_dword off, v186, s46 offset:240
		scratch_store_dword off, v187, s46 offset:244
		s_mov_b32 s46, 0
		scratch_store_dword off, v188, s46 offset:216
		scratch_store_dword off, v189, s46 offset:220
		scratch_store_dword off, v190, s46 offset:224
		scratch_store_dword off, v191, s46 offset:228
		s_mov_b32 s46, 0
		scratch_store_dword off, v192, s46 offset:148
		scratch_store_dword off, v193, s46 offset:152
		scratch_store_dword off, v194, s46 offset:156
		scratch_store_dword off, v195, s46 offset:160
		s_mov_b32 s46, 0
		scratch_store_dword off, v164, s46 offset:556
		scratch_store_dword off, v165, s46 offset:560
		scratch_store_dword off, v166, s46 offset:564
		scratch_store_dword off, v167, s46 offset:568
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_mov_b32 s0, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v76, off, s0 offset:556
		scratch_load_dword v77, off, s0 offset:560
		scratch_load_dword v78, off, s0 offset:564
		scratch_load_dword v79, off, s0 offset:568
		s_mov_b32 s0, 0
		scratch_load_dword v148, off, s0 offset:360
		scratch_load_dword v149, off, s0 offset:364
		scratch_load_dword v150, off, s0 offset:368
		scratch_load_dword v151, off, s0 offset:372
		s_mov_b32 s0, 0
		scratch_load_dword v152, off, s0 offset:344
		scratch_load_dword v153, off, s0 offset:348
		scratch_load_dword v154, off, s0 offset:352
		scratch_load_dword v155, off, s0 offset:356
		s_mov_b32 s0, 0
		scratch_load_dword v156, off, s0 offset:328
		scratch_load_dword v157, off, s0 offset:332
		scratch_load_dword v158, off, s0 offset:336
		scratch_load_dword v159, off, s0 offset:340
		s_mov_b32 s0, 0
		scratch_load_dword v160, off, s0 offset:312
		scratch_load_dword v161, off, s0 offset:316
		scratch_load_dword v162, off, s0 offset:320
		scratch_load_dword v163, off, s0 offset:324
		s_mov_b32 s0, 0
		scratch_load_dword v164, off, s0 offset:296
		scratch_load_dword v165, off, s0 offset:300
		scratch_load_dword v166, off, s0 offset:304
		scratch_load_dword v167, off, s0 offset:308
		s_mov_b32 s0, 0
		scratch_load_dword v168, off, s0 offset:280
		scratch_load_dword v169, off, s0 offset:284
		scratch_load_dword v170, off, s0 offset:288
		scratch_load_dword v171, off, s0 offset:292
		s_mov_b32 s0, 0
		scratch_load_dword v172, off, s0 offset:264
		scratch_load_dword v173, off, s0 offset:268
		scratch_load_dword v174, off, s0 offset:272
		scratch_load_dword v175, off, s0 offset:276
		s_mov_b32 s0, 0
		scratch_load_dword v176, off, s0 offset:248
		scratch_load_dword v177, off, s0 offset:252
		scratch_load_dword v178, off, s0 offset:256
		scratch_load_dword v179, off, s0 offset:260
		s_mov_b32 s0, 0
		scratch_load_dword v180, off, s0 offset:232
		scratch_load_dword v181, off, s0 offset:236
		scratch_load_dword v182, off, s0 offset:240
		scratch_load_dword v183, off, s0 offset:244
		s_mov_b32 s0, 0
		scratch_load_dword v184, off, s0 offset:216
		scratch_load_dword v185, off, s0 offset:220
		scratch_load_dword v186, off, s0 offset:224
		scratch_load_dword v187, off, s0 offset:228
		s_mov_b32 s0, 0
		scratch_load_dword v188, off, s0 offset:148
		scratch_load_dword v189, off, s0 offset:152
		scratch_load_dword v190, off, s0 offset:156
		scratch_load_dword v191, off, s0 offset:160
		s_add_i32 s0, s12, -1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[16:19], v[32:35], v[4:7], v11, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s1, s0, 1
		s_lshl_b32 s0, s1, 16
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshlrev_b32_e32 v3, 12, v2
		v_add_u32_e32 v2, s0, v3
		v_and_b32_e32 v3, 15, v0
		v_lshlrev_b32_e32 v8, 6, v3
		v_add3_u32 v3, v2, v8, v9
		ds_read_b128 v[192:195], v3 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[16:19], v[36:39], v[68:71], v11, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[196:199], v3 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[16:19], v[40:43], v[72:75], v11, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[200:203], v3 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[16:19], v[44:47], v[80:83], v11, v15 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[204:207], v3 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[16:19], v[48:51], v[84:87], v11, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_and_b32_e32 v2, 15, v0
		v_lshlrev_b32_e32 v3, 6, v2
		v_add_u32_e32 v2, s0, v3
		v_lshlrev_b32_e32 v3, 13, v13
		v_add3_u32 v8, v2, v3, v9
		ds_read_b128 v[208:211], v8 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[16:19], v[52:55], v[88:91], v11, v65 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[212:215], v8 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[16:19], v[56:59], v[92:95], v11, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v8 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[16:19], v[60:63], v[96:99], v11, v66 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[16:19], v8 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[20:23], v[32:35], v[100:103], v11, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v8 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[20:23], v[36:39], v[104:107], v11, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v8 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[20:23], v[40:43], v[108:111], v11, v15 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v8 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[20:23], v[44:47], v[112:115], v11, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[232:235], v8 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[20:23], v[48:51], v[116:119], v11, v65 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], v[52:55], v[120:123], v11, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], v[56:59], v[124:127], v11, v66 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[20:23], v[60:63], v[128:131], v11, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[24:27], v[32:35], v[132:135], v12, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[24:27], v[36:39], v[136:139], v12, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[24:27], v[40:43], v[140:143], v12, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[44:47], v[144:147], v12, v15 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(44)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[24:27], v[48:51], v[76:79], v12, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(40)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[52:55], v[148:151], v12, v65 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(36)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[56:59], v[152:155], v12, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(32)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[60:63], v[156:159], v12, v66 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(28)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[28:31], v[32:35], v[160:163], v12, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(24)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[28:31], v[36:39], v[164:167], v12, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(20)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[28:31], v[40:43], v[168:171], v12, v15 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(16)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[28:31], v[44:47], v[172:175], v12, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(12)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[48:51], v[176:179], v12, v65 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(8)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[52:55], v[180:183], v12, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[56:59], v[184:187], v12, v66 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[60:63], v[188:191], v12, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[192:195], v[208:211], v[4:7], v11, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[192:195], v[212:215], v[68:71], v11, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[192:195], v[216:219], v[72:75], v11, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[192:195], v[16:19], v[80:83], v11, v15 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[192:195], v[220:223], v[84:87], v11, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[192:195], v[224:227], v[88:91], v11, v65 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[192:195], v[228:231], v[92:95], v11, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[192:195], v[232:235], v[96:99], v11, v66 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[196:199], v[208:211], v[100:103], v11, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[196:199], v[212:215], v[104:107], v11, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[196:199], v[216:219], v[108:111], v11, v15 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[196:199], v[16:19], v[112:115], v11, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[196:199], v[220:223], v[116:119], v11, v65 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[196:199], v[224:227], v[120:123], v11, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[196:199], v[228:231], v[124:127], v11, v66 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[196:199], v[232:235], v[128:131], v11, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[200:203], v[208:211], v[132:135], v12, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[200:203], v[212:215], v[136:139], v12, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[200:203], v[216:219], v[140:143], v12, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[200:203], v[16:19], v[144:147], v12, v15 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[200:203], v[220:223], v[76:79], v12, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
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
		v_add3_u32 v3, v2, v8, v9
		ds_read_b128 v[16:19], v3
		ds_read_b128 v[20:23], v3 offset:1024
		ds_read_b128 v[24:27], v3 offset:2048
		ds_read_b128 v[28:31], v3 offset:3072
		v_and_b32_e32 v2, 15, v0
		v_lshlrev_b32_e32 v8, 6, v2
		v_add_u32_e32 v2, s1, v8
		v_lshlrev_b32_e32 v8, 13, v13
		v_add3_u32 v10, v2, v8, v9
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
		v_lshlrev_b32_e32 v8, 9, v2
		v_lshlrev_b32_e32 v2, 2, v1
		v_add3_u32 v9, s0, v8, v2
		ds_read_b32 v2, v9
		ds_read_b32 v8, v9 offset:256
		v_lshlrev_b32_e32 v9, 10, v13
		v_lshlrev_b32_e32 v11, 2, v1
		v_add3_u32 v1, s0, v11, v9
		ds_read_b32 v9, v1 offset:2048
		ds_read_b32 v11, v1 offset:2304
		ds_read_b32 v12, v1 offset:2560
		ds_read_b32 v13, v1 offset:2816
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[16:19], v[32:35], v[4:7], v2, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[64:67], v3 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[16:19], v[36:39], v[68:71], v2, v9 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[192:195], v3 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[16:19], v[40:43], v[72:75], v2, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[196:199], v3 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[16:19], v[44:47], v[80:83], v2, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[200:203], v3 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[16:19], v[48:51], v[84:87], v2, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[204:207], v10 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[16:19], v[52:55], v[88:91], v2, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[208:211], v10 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[16:19], v[56:59], v[92:95], v2, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[212:215], v10 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[16:19], v[60:63], v[96:99], v2, v13 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[16:19], v10 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[20:23], v[32:35], v[100:103], v2, v9 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v10 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[20:23], v[36:39], v[104:107], v2, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v10 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[20:23], v[40:43], v[108:111], v2, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v10 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[20:23], v[44:47], v[112:115], v2, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v10 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[20:23], v[48:51], v[116:119], v2, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], v[52:55], v[120:123], v2, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], v[56:59], v[124:127], v2, v13 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[20:23], v[60:63], v[128:131], v2, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[24:27], v[32:35], v[132:135], v8, v9 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[24:27], v[36:39], v[136:139], v8, v9 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[24:27], v[40:43], v[140:143], v8, v11 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[44:47], v[144:147], v8, v11 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[24:27], v[48:51], v[76:79], v8, v12 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[52:55], v[148:151], v8, v12 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[56:59], v[152:155], v8, v13 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[60:63], v[156:159], v8, v13 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[28:31], v[32:35], v[160:163], v8, v9 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[28:31], v[36:39], v[164:167], v8, v9 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[28:31], v[40:43], v[168:171], v8, v11 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[28:31], v[44:47], v[172:175], v8, v11 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[48:51], v[176:179], v8, v12 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[52:55], v[180:183], v8, v12 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[56:59], v[184:187], v8, v13 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[60:63], v[188:191], v8, v13 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[64:67], v[204:207], v[4:7], v2, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[64:67], v[208:211], v[68:71], v2, v9 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[64:67], v[212:215], v[72:75], v2, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[64:67], v[16:19], v[80:83], v2, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[64:67], v[216:219], v[84:87], v2, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[64:67], v[220:223], v[88:91], v2, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[64:67], v[224:227], v[92:95], v2, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[64:67], v[228:231], v[96:99], v2, v13 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[192:195], v[204:207], v[100:103], v2, v9 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[192:195], v[208:211], v[104:107], v2, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[192:195], v[212:215], v[108:111], v2, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[192:195], v[16:19], v[112:115], v2, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[192:195], v[216:219], v[116:119], v2, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[192:195], v[220:223], v[120:123], v2, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[192:195], v[224:227], v[124:127], v2, v13 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[192:195], v[228:231], v[128:131], v2, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[196:199], v[204:207], v[132:135], v8, v9 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[196:199], v[208:211], v[136:139], v8, v9 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[196:199], v[212:215], v[140:143], v8, v11 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[196:199], v[16:19], v[144:147], v8, v11 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[196:199], v[216:219], v[76:79], v8, v12 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[196:199], v[220:223], v[148:151], v8, v12 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[196:199], v[224:227], v[152:155], v8, v13 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[196:199], v[228:231], v[156:159], v8, v13 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[200:203], v[204:207], v[160:163], v8, v9 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[200:203], v[208:211], v[164:167], v8, v9 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[200:203], v[212:215], v[168:171], v8, v11 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[200:203], v[16:19], v[172:175], v8, v11 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[200:203], v[216:219], v[176:179], v8, v12 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[200:203], v[220:223], v[180:183], v8, v12 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[200:203], v[224:227], v[184:187], v8, v13 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[200:203], v[228:231], v[188:191], v8, v13 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v4, v5
		v_cvt_pk_f16_f32 v3, v6, v7
		v_and_b32_e32 v1, 63, v0
		v_lshlrev_b32_e32 v0, 3, v1
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:552
		s_waitcnt vmcnt(0)
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
		v_cvt_pk_f16_f32 v0, v80, v81
		v_cvt_pk_f16_f32 v1, v82, v83
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:1536
		v_cvt_pk_f16_f32 v0, v84, v85
		v_cvt_pk_f16_f32 v1, v86, v87
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:2048
		v_cvt_pk_f16_f32 v0, v88, v89
		v_cvt_pk_f16_f32 v1, v90, v91
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:2560
		v_cvt_pk_f16_f32 v0, v92, v93
		v_cvt_pk_f16_f32 v1, v94, v95
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:3072
		v_cvt_pk_f16_f32 v0, v96, v97
		v_cvt_pk_f16_f32 v1, v98, v99
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s2 offen offset:3584
		v_cvt_pk_f16_f32 v0, v100, v101
		v_cvt_pk_f16_f32 v1, v102, v103
		s_add_i32 s2, s0, 0x1000
		s_add_i32 s3, s2, s1
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen
		v_cvt_pk_f16_f32 v0, v104, v105
		v_cvt_pk_f16_f32 v1, v106, v107
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:512
		v_cvt_pk_f16_f32 v0, v108, v109
		v_cvt_pk_f16_f32 v1, v110, v111
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:1024
		v_cvt_pk_f16_f32 v0, v112, v113
		v_cvt_pk_f16_f32 v1, v114, v115
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:1536
		v_cvt_pk_f16_f32 v0, v116, v117
		v_cvt_pk_f16_f32 v1, v118, v119
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:2048
		v_cvt_pk_f16_f32 v0, v120, v121
		v_cvt_pk_f16_f32 v1, v122, v123
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:2560
		v_cvt_pk_f16_f32 v0, v124, v125
		v_cvt_pk_f16_f32 v1, v126, v127
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:3072
		v_cvt_pk_f16_f32 v0, v128, v129
		v_cvt_pk_f16_f32 v1, v130, v131
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:3584
		v_cvt_pk_f16_f32 v0, v132, v133
		v_cvt_pk_f16_f32 v1, v134, v135
		s_add_i32 s2, s0, 0x2000
		s_add_i32 s3, s2, s1
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen
		v_cvt_pk_f16_f32 v0, v136, v137
		v_cvt_pk_f16_f32 v1, v138, v139
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:512
		v_cvt_pk_f16_f32 v0, v140, v141
		v_cvt_pk_f16_f32 v1, v142, v143
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:1024
		v_cvt_pk_f16_f32 v0, v144, v145
		v_cvt_pk_f16_f32 v1, v146, v147
		buffer_store_dwordx2 v[0:1], v4, s[16:19], s3 offen offset:1536
		v_cvt_pk_f16_f32 v0, v76, v77
		v_cvt_pk_f16_f32 v1, v78, v79
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
		.amdhsa_group_segment_fixed_size 0
		.amdhsa_private_segment_fixed_size 636
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
	.set .Lwmma_f16_matmul_tiled.num_vgpr, 252
	.set .Lwmma_f16_matmul_tiled.num_agpr, 1
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 49
	.set .Lwmma_f16_matmul_tiled.num_named_barrier, 0
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 636
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
    .private_segment_fixed_size: 636
    .sgpr_count:     49
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     253
    .agpr_count:     1
    .vgpr_spill_count: 207
    .wavefront_size: 64
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
