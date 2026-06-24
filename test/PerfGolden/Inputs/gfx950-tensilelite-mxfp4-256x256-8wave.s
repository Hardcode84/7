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
		scratch_store_dword off, v1, s10 offset:808
		s_mov_b32 s10, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v1, off, s10 offset:808
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
		s_mov_b32 s38, 0
		scratch_load_dword v9, off, s38 offset:808
		s_waitcnt vmcnt(0)
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
		v_mov_b32_e32 v2, s11
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
		v_lshlrev_b32_e32 v3, 2, v0
		ds_write_b32 v3, v90
		v_lshlrev_b32_e32 v3, 2, v0
		ds_write_b32 v3, v91 offset:2048
		s_mov_b32 s46, 0x80
		s_mov_b32 s47, 0
		v_mov_b32_e32 v76, s46
		v_mov_b32_e32 v77, s47
		v_lshlrev_b32_e32 v3, 2, v0
		ds_write_b32 v3, v76 offset:4096
		v_lshlrev_b32_e32 v3, 2, v0
		ds_write_b32 v3, v77 offset:6144
		v_mov_b32_e32 v3, 0x80000
		v_add_co_u32_e64 v76, vcc, v72, v3
		v_addc_co_u32_e64 v77, vcc, v73, 0, vcc
		v_add_co_u32_e64 v90, vcc, v76, v84
		v_addc_co_u32_e64 v91, vcc, v77, v85, vcc
		v_add_co_u32_e64 v76, vcc, v90, v92
		v_addc_co_u32_e64 v77, vcc, v91, v93, vcc
		v_add_co_u32_e64 v90, vcc, v76, v86
		v_addc_co_u32_e64 v91, vcc, v77, v87, vcc
		v_lshlrev_b32_e32 v8, 2, v0
		ds_write_b32 v8, v90 offset:8192
		v_lshlrev_b32_e32 v8, 2, v0
		ds_write_b32 v8, v91 offset:10240
		v_mov_b32_e32 v8, 64
		v_add_co_u32_e64 v76, vcc, v72, v8
		v_addc_co_u32_e64 v77, vcc, v73, 0, vcc
		v_add_co_u32_e64 v90, vcc, v76, v84
		v_addc_co_u32_e64 v91, vcc, v77, v85, vcc
		v_add_co_u32_e64 v76, vcc, v90, v92
		v_addc_co_u32_e64 v77, vcc, v91, v93, vcc
		v_add_co_u32_e64 v90, vcc, v76, v86
		v_addc_co_u32_e64 v91, vcc, v77, v87, vcc
		v_lshlrev_b32_e32 v10, 2, v0
		ds_write_b32 v10, v90 offset:12288
		v_lshlrev_b32_e32 v10, 2, v0
		ds_write_b32 v10, v91 offset:14336
		v_mov_b32_e32 v10, 0x80040
		v_add_co_u32_e64 v76, vcc, v72, v10
		v_addc_co_u32_e64 v77, vcc, v73, 0, vcc
		v_add_co_u32_e64 v90, vcc, v76, v84
		v_addc_co_u32_e64 v91, vcc, v77, v85, vcc
		v_add_co_u32_e64 v76, vcc, v90, v92
		v_addc_co_u32_e64 v77, vcc, v91, v93, vcc
		v_add_co_u32_e64 v90, vcc, v76, v86
		v_addc_co_u32_e64 v91, vcc, v77, v87, vcc
		v_lshlrev_b32_e32 v64, 2, v0
		ds_write_b32 v64, v90 offset:16384
		v_lshlrev_b32_e32 v64, 2, v0
		ds_write_b32 v64, v91 offset:18432
		v_mov_b32_e32 v76, s14
		v_mov_b32_e32 v77, 0
		v_mul_lo_u32 v90, v70, v76
		v_mul_hi_u32 v91, v70, v76
		v_mul_lo_u32 v64, v70, v77
		v_add_u32_e32 v91, v91, v64
		v_mul_lo_u32 v64, v71, v76
		v_add_u32_e32 v91, v91, v64
		v_add_co_u32_e64 v70, vcc, v90, v84
		v_addc_co_u32_e64 v71, vcc, v91, v85, vcc
		v_add_co_u32_e64 v94, vcc, v70, v92
		v_addc_co_u32_e64 v95, vcc, v71, v93, vcc
		v_add_co_u32_e64 v70, vcc, v94, v86
		v_addc_co_u32_e64 v71, vcc, v95, v87, vcc
		v_lshlrev_b32_e32 v64, 2, v0
		ds_write_b32 v64, v70 offset:20480
		v_lshlrev_b32_e32 v64, 2, v0
		ds_write_b32 v64, v71 offset:22528
		v_add_co_u32_e64 v70, vcc, v90, v3
		v_addc_co_u32_e64 v71, vcc, v91, 0, vcc
		v_add_co_u32_e64 v94, vcc, v70, v84
		v_addc_co_u32_e64 v95, vcc, v71, v85, vcc
		v_add_co_u32_e64 v70, vcc, v94, v92
		v_addc_co_u32_e64 v71, vcc, v95, v93, vcc
		v_add_co_u32_e64 v94, vcc, v70, v86
		v_addc_co_u32_e64 v95, vcc, v71, v87, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v94, s46
		scratch_store_dword off, v95, s46 offset:4
		v_add_co_u32_e64 v70, vcc, v90, v8
		v_addc_co_u32_e64 v71, vcc, v91, 0, vcc
		v_add_co_u32_e64 v94, vcc, v70, v84
		v_addc_co_u32_e64 v95, vcc, v71, v85, vcc
		v_add_co_u32_e64 v70, vcc, v94, v92
		v_addc_co_u32_e64 v71, vcc, v95, v93, vcc
		v_add_co_u32_e64 v94, vcc, v70, v86
		v_addc_co_u32_e64 v95, vcc, v71, v87, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v94, s46 offset:8
		scratch_store_dword off, v95, s46 offset:12
		v_add_co_u32_e64 v70, vcc, v90, v10
		v_addc_co_u32_e64 v71, vcc, v91, 0, vcc
		v_add_co_u32_e64 v94, vcc, v70, v84
		v_addc_co_u32_e64 v95, vcc, v71, v85, vcc
		v_add_co_u32_e64 v70, vcc, v94, v92
		v_addc_co_u32_e64 v71, vcc, v95, v93, vcc
		v_add_co_u32_e64 v94, vcc, v70, v86
		v_addc_co_u32_e64 v95, vcc, v71, v87, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v94, s46 offset:16
		scratch_store_dword off, v95, s46 offset:20
		v_mul_lo_u32 v70, v82, v76
		v_mul_hi_u32 v71, v82, v76
		v_mul_lo_u32 v3, v82, v77
		v_add_u32_e32 v71, v71, v3
		v_mul_lo_u32 v3, v83, v76
		v_add_u32_e32 v71, v71, v3
		v_add_co_u32_e64 v76, vcc, v72, v70
		v_addc_co_u32_e64 v77, vcc, v73, v71, vcc
		v_lshrrev_b64 v[82:83], 7, v[78:79]
		s_mov_b32 s46, 0x200
		s_mov_b32 s47, 0
		v_mov_b32_e32 v78, s46
		v_mov_b32_e32 v79, s47
		v_mul_lo_u32 v94, v78, v82
		v_mul_hi_u32 v95, v78, v82
		v_mul_lo_u32 v3, v78, v83
		v_add_u32_e32 v95, v95, v3
		v_mul_lo_u32 v3, v79, v82
		v_add_u32_e32 v95, v95, v3
		v_add_co_u32_e64 v78, vcc, v76, v94
		v_addc_co_u32_e64 v79, vcc, v77, v95, vcc
		s_mov_b32 s46, 4
		s_mov_b32 s47, 0
		v_mov_b32_e32 v82, s46
		v_mov_b32_e32 v83, s47
		v_mul_lo_u32 v96, v82, v88
		v_mul_hi_u32 v97, v82, v88
		v_mul_lo_u32 v3, v82, v89
		v_add_u32_e32 v97, v97, v3
		v_mul_lo_u32 v3, v83, v88
		v_add_u32_e32 v97, v97, v3
		v_add_co_u32_e64 v82, vcc, v78, v96
		v_addc_co_u32_e64 v83, vcc, v79, v97, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v82, s46 offset:24
		scratch_store_dword off, v83, s46 offset:28
		s_mov_b32 s46, 0x800
		s_mov_b32 s47, 0
		v_mov_b32_e32 v78, s46
		v_mov_b32_e32 v79, s47
		s_mov_b32 s46, 0
		scratch_store_dword off, v78, s46 offset:32
		scratch_store_dword off, v79, s46 offset:36
		v_mov_b32_e32 v3, 0x100
		v_add_co_u32_e64 v78, vcc, v72, v3
		v_addc_co_u32_e64 v79, vcc, v73, 0, vcc
		v_add_co_u32_e64 v82, vcc, v78, v70
		v_addc_co_u32_e64 v83, vcc, v79, v71, vcc
		v_add_co_u32_e64 v78, vcc, v82, v94
		v_addc_co_u32_e64 v79, vcc, v83, v95, vcc
		v_add_co_u32_e64 v82, vcc, v78, v96
		v_addc_co_u32_e64 v83, vcc, v79, v97, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v82, s46 offset:40
		scratch_store_dword off, v83, s46 offset:44
		v_mul_lo_u32 v78, v74, v88
		v_mul_hi_u32 v79, v74, v88
		v_mul_lo_u32 v3, v74, v89
		v_add_u32_e32 v79, v79, v3
		v_mul_lo_u32 v3, v75, v88
		v_add_u32_e32 v79, v79, v3
		v_add_co_u32_e64 v74, vcc, v76, v78
		v_addc_co_u32_e64 v75, vcc, v77, v79, vcc
		v_mov_b32_e32 v3, 1
		v_and_b32_e32 v76, v80, v3
		v_and_b32_e32 v77, v81, v69
		s_mov_b32 s46, 0x400
		s_mov_b32 s47, 0
		v_mov_b32_e32 v68, s46
		v_mov_b32_e32 v69, s47
		v_mul_lo_u32 v80, v68, v76
		v_mul_hi_u32 v81, v68, v76
		v_mul_lo_u32 v3, v68, v77
		v_add_u32_e32 v81, v81, v3
		v_mul_lo_u32 v3, v69, v76
		v_add_u32_e32 v81, v81, v3
		v_add_co_u32_e64 v68, vcc, v74, v80
		v_addc_co_u32_e64 v69, vcc, v75, v81, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v68, s46 offset:48
		scratch_store_dword off, v69, s46 offset:52
		v_mov_b32_e32 v3, 0x80
		v_add_co_u32_e64 v68, vcc, v72, v3
		v_addc_co_u32_e64 v69, vcc, v73, 0, vcc
		v_add_co_u32_e64 v74, vcc, v68, v84
		v_addc_co_u32_e64 v75, vcc, v69, v85, vcc
		v_add_co_u32_e64 v68, vcc, v74, v92
		v_addc_co_u32_e64 v69, vcc, v75, v93, vcc
		v_add_co_u32_e64 v74, vcc, v68, v86
		v_addc_co_u32_e64 v75, vcc, v69, v87, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v74, s46 offset:56
		scratch_store_dword off, v75, s46 offset:60
		v_mov_b32_e32 v8, 0x80080
		v_add_co_u32_e64 v68, vcc, v72, v8
		v_addc_co_u32_e64 v69, vcc, v73, 0, vcc
		v_add_co_u32_e64 v74, vcc, v68, v84
		v_addc_co_u32_e64 v75, vcc, v69, v85, vcc
		v_add_co_u32_e64 v68, vcc, v74, v92
		v_addc_co_u32_e64 v69, vcc, v75, v93, vcc
		v_add_co_u32_e64 v74, vcc, v68, v86
		v_addc_co_u32_e64 v75, vcc, v69, v87, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v74, s46 offset:64
		scratch_store_dword off, v75, s46 offset:68
		v_mov_b32_e32 v10, 0xc0
		v_add_co_u32_e64 v68, vcc, v72, v10
		v_addc_co_u32_e64 v69, vcc, v73, 0, vcc
		v_add_co_u32_e64 v74, vcc, v68, v84
		v_addc_co_u32_e64 v75, vcc, v69, v85, vcc
		v_add_co_u32_e64 v68, vcc, v74, v92
		v_addc_co_u32_e64 v69, vcc, v75, v93, vcc
		v_add_co_u32_e64 v74, vcc, v68, v86
		v_addc_co_u32_e64 v75, vcc, v69, v87, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v74, s46 offset:72
		scratch_store_dword off, v75, s46 offset:76
		v_mov_b32_e32 v64, 0x800c0
		v_add_co_u32_e64 v68, vcc, v72, v64
		v_addc_co_u32_e64 v69, vcc, v73, 0, vcc
		v_add_co_u32_e64 v74, vcc, v68, v84
		v_addc_co_u32_e64 v75, vcc, v69, v85, vcc
		v_add_co_u32_e64 v68, vcc, v74, v92
		v_addc_co_u32_e64 v69, vcc, v75, v93, vcc
		v_add_co_u32_e64 v74, vcc, v68, v86
		v_addc_co_u32_e64 v75, vcc, v69, v87, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v74, s46 offset:80
		scratch_store_dword off, v75, s46 offset:84
		v_add_co_u32_e64 v68, vcc, v90, v3
		v_addc_co_u32_e64 v69, vcc, v91, 0, vcc
		v_add_co_u32_e64 v74, vcc, v68, v84
		v_addc_co_u32_e64 v75, vcc, v69, v85, vcc
		v_add_co_u32_e64 v68, vcc, v74, v92
		v_addc_co_u32_e64 v69, vcc, v75, v93, vcc
		v_add_co_u32_e64 v74, vcc, v68, v86
		v_addc_co_u32_e64 v75, vcc, v69, v87, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v74, s46 offset:88
		scratch_store_dword off, v75, s46 offset:92
		v_add_co_u32_e64 v68, vcc, v90, v8
		v_addc_co_u32_e64 v69, vcc, v91, 0, vcc
		v_add_co_u32_e64 v74, vcc, v68, v84
		v_addc_co_u32_e64 v75, vcc, v69, v85, vcc
		v_add_co_u32_e64 v68, vcc, v74, v92
		v_addc_co_u32_e64 v69, vcc, v75, v93, vcc
		v_add_co_u32_e64 v74, vcc, v68, v86
		v_addc_co_u32_e64 v75, vcc, v69, v87, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v74, s46 offset:96
		scratch_store_dword off, v75, s46 offset:100
		v_add_co_u32_e64 v68, vcc, v90, v10
		v_addc_co_u32_e64 v69, vcc, v91, 0, vcc
		v_add_co_u32_e64 v74, vcc, v68, v84
		v_addc_co_u32_e64 v75, vcc, v69, v85, vcc
		v_add_co_u32_e64 v68, vcc, v74, v92
		v_addc_co_u32_e64 v69, vcc, v75, v93, vcc
		v_add_co_u32_e64 v74, vcc, v68, v86
		v_addc_co_u32_e64 v75, vcc, v69, v87, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v74, s46 offset:104
		scratch_store_dword off, v75, s46 offset:108
		v_add_co_u32_e64 v68, vcc, v90, v64
		v_addc_co_u32_e64 v69, vcc, v91, 0, vcc
		v_add_co_u32_e64 v74, vcc, v68, v84
		v_addc_co_u32_e64 v75, vcc, v69, v85, vcc
		v_add_co_u32_e64 v68, vcc, v74, v92
		v_addc_co_u32_e64 v69, vcc, v75, v93, vcc
		v_add_co_u32_e64 v74, vcc, v68, v86
		v_addc_co_u32_e64 v75, vcc, v69, v87, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v74, s46 offset:112
		scratch_store_dword off, v75, s46 offset:116
		v_mov_b32_e32 v3, 0x800
		v_add_co_u32_e64 v68, vcc, v72, v3
		v_addc_co_u32_e64 v69, vcc, v73, 0, vcc
		v_add_co_u32_e64 v74, vcc, v68, v70
		v_addc_co_u32_e64 v75, vcc, v69, v71, vcc
		v_add_co_u32_e64 v68, vcc, v74, v94
		v_addc_co_u32_e64 v69, vcc, v75, v95, vcc
		v_add_co_u32_e64 v76, vcc, v68, v96
		v_addc_co_u32_e64 v77, vcc, v69, v97, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v76, s46 offset:120
		scratch_store_dword off, v77, s46 offset:124
		v_mov_b32_e32 v3, 0x900
		v_add_co_u32_e64 v68, vcc, v72, v3
		v_addc_co_u32_e64 v69, vcc, v73, 0, vcc
		v_add_co_u32_e64 v72, vcc, v68, v70
		v_addc_co_u32_e64 v73, vcc, v69, v71, vcc
		v_add_co_u32_e64 v68, vcc, v72, v94
		v_addc_co_u32_e64 v69, vcc, v73, v95, vcc
		v_add_co_u32_e64 v70, vcc, v68, v96
		v_addc_co_u32_e64 v71, vcc, v69, v97, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v70, s46 offset:128
		scratch_store_dword off, v71, s46 offset:132
		v_add_co_u32_e64 v68, vcc, v74, v78
		v_addc_co_u32_e64 v69, vcc, v75, v79, vcc
		v_add_co_u32_e64 v70, vcc, v68, v80
		v_addc_co_u32_e64 v71, vcc, v69, v81, vcc
		s_mov_b32 s46, 0
		scratch_store_dword off, v70, s46 offset:136
		scratch_store_dword off, v71, s46 offset:140
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
		v_mov_b32_e32 v192, s11
		v_mov_b32_e32 v193, 0
		v_lshlrev_b32_e32 v3, 2, v0
		s_waitcnt lgkmcnt(8)
		ds_read_b32 v194, v3 offset:4096
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v195, v3 offset:6144
		s_waitcnt lgkmcnt(0)
		v_mul_lo_u32 v196, v194, v192
		v_mul_hi_u32 v197, v194, v192
		v_mul_lo_u32 v3, v194, v193
		v_add_u32_e32 v197, v197, v3
		v_mul_lo_u32 v3, v195, v192
		v_add_u32_e32 v197, v197, v3
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v194, v3
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v195, v3 offset:2048
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v198, vcc, v194, v196
		v_addc_co_u32_e64 v199, vcc, v195, v197, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v194, v3 offset:8192
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v195, v3 offset:10240
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v200, vcc, v194, v196
		v_addc_co_u32_e64 v201, vcc, v195, v197, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v194, v3 offset:12288
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v195, v3 offset:14336
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v202, vcc, v194, v196
		v_addc_co_u32_e64 v203, vcc, v195, v197, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v194, v3 offset:16384
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v195, v3 offset:18432
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v204, vcc, v194, v196
		v_addc_co_u32_e64 v205, vcc, v195, v197, vcc
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v194, v3 offset:20480
		v_lshlrev_b32_e32 v3, 2, v0
		ds_read_b32 v195, v3 offset:22528
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v206, vcc, v194, v196
		v_addc_co_u32_e64 v207, vcc, v195, v197, vcc
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(34)
		scratch_load_dword v194, off, s46
		scratch_load_dword v195, off, s46 offset:4
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v208, vcc, v194, v196
		v_addc_co_u32_e64 v209, vcc, v195, v197, vcc
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(32)
		scratch_load_dword v194, off, s46 offset:8
		scratch_load_dword v195, off, s46 offset:12
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v210, vcc, v194, v196
		v_addc_co_u32_e64 v211, vcc, v195, v197, vcc
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(30)
		scratch_load_dword v194, off, s46 offset:16
		scratch_load_dword v195, off, s46 offset:20
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v212, vcc, v194, v196
		v_addc_co_u32_e64 v213, vcc, v195, v197, vcc
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(26)
		scratch_load_dword v194, off, s46 offset:32
		scratch_load_dword v195, off, s46 offset:36
		s_waitcnt vmcnt(0)
		v_mul_lo_u32 v214, v194, v192
		v_mul_hi_u32 v215, v194, v192
		v_mul_lo_u32 v3, v194, v193
		v_add_u32_e32 v215, v215, v3
		v_mul_lo_u32 v3, v195, v192
		v_add_u32_e32 v215, v215, v3
		s_mov_b32 s46, 0
		scratch_load_dword v192, off, s46 offset:24
		scratch_load_dword v193, off, s46 offset:28
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v194, vcc, v192, v214
		v_addc_co_u32_e64 v195, vcc, v193, v215, vcc
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v192, off, s46 offset:40
		scratch_load_dword v193, off, s46 offset:44
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v216, vcc, v192, v214
		v_addc_co_u32_e64 v217, vcc, v193, v215, vcc
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(22)
		scratch_load_dword v192, off, s46 offset:48
		scratch_load_dword v193, off, s46 offset:52
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v218, vcc, v192, v214
		v_addc_co_u32_e64 v219, vcc, v193, v215, vcc
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[16:19], v[32:35], v[4:7], v9, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s46, s11, 1
		v_mov_b32_e32 v3, s46
		s_nop 0
		v_readfirstlane_b32 s46, v3
		s_lshl_b32 s47, s46, 16
		v_mov_b32_e32 v8, s47
		s_nop 0
		v_readfirstlane_b32 s46, v8
		v_lshrrev_b32_e32 v10, 7, v0
		v_lshlrev_b32_e32 v64, 12, v10
		v_add_u32_e32 v10, s46, v64
		v_and_b32_e32 v64, 15, v0
		v_lshlrev_b32_e32 v67, 6, v64
		v_lshlrev_b32_e32 v64, 4, v11
		v_add3_u32 v192, v10, v67, v64
		ds_read_b128 v[220:223], v192 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[16:19], v[36:39], v[68:71], v9, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v192 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[16:19], v[40:43], v[72:75], v9, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v192 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[16:19], v[44:47], v[76:79], v9, v15 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[232:235], v192 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[16:19], v[48:51], v[80:83], v9, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_readfirstlane_b32 s46, v8
		v_and_b32_e32 v8, 15, v0
		v_lshlrev_b32_e32 v10, 6, v8
		v_add_u32_e32 v8, s46, v10
		v_lshlrev_b32_e32 v10, 13, v13
		v_lshlrev_b32_e32 v64, 4, v11
		v_add3_u32 v67, v8, v10, v64
		ds_read_b128 v[236:239], v67 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[16:19], v[52:55], v[84:87], v9, v65 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v67 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[16:19], v[56:59], v[88:91], v9, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[244:247], v67 offset:51200
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v244, s46 offset:876
		scratch_store_dword off, v245, s46 offset:880
		scratch_store_dword off, v246, s46 offset:884
		scratch_store_dword off, v247, s46 offset:888
		s_mov_b32 s46, 0
		scratch_store_dword off, v244, s46 offset:892
		scratch_store_dword off, v245, s46 offset:896
		scratch_store_dword off, v246, s46 offset:900
		scratch_store_dword off, v247, s46 offset:904
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[16:19], v[60:63], v[92:95], v9, v66 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[244:247], v67 offset:52224
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v244, s46 offset:208
		scratch_store_dword off, v245, s46 offset:212
		scratch_store_dword off, v246, s46 offset:216
		scratch_store_dword off, v247, s46 offset:220
		s_mov_b32 s46, 0
		scratch_store_dword off, v244, s46 offset:224
		scratch_store_dword off, v245, s46 offset:228
		scratch_store_dword off, v246, s46 offset:232
		scratch_store_dword off, v247, s46 offset:236
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[20:23], v[32:35], v[96:99], v9, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[244:247], v67 offset:53248
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v244, s46 offset:176
		scratch_store_dword off, v245, s46 offset:180
		scratch_store_dword off, v246, s46 offset:184
		scratch_store_dword off, v247, s46 offset:188
		s_mov_b32 s46, 0
		scratch_store_dword off, v244, s46 offset:192
		scratch_store_dword off, v245, s46 offset:196
		scratch_store_dword off, v246, s46 offset:200
		scratch_store_dword off, v247, s46 offset:204
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[20:23], v[36:39], v[100:103], v9, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[244:247], v67 offset:54272
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v244, s46 offset:144
		scratch_store_dword off, v245, s46 offset:148
		scratch_store_dword off, v246, s46 offset:152
		scratch_store_dword off, v247, s46 offset:156
		s_mov_b32 s46, 0
		scratch_store_dword off, v244, s46 offset:160
		scratch_store_dword off, v245, s46 offset:164
		scratch_store_dword off, v246, s46 offset:168
		scratch_store_dword off, v247, s46 offset:172
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[20:23], v[40:43], v[104:107], v9, v15 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[244:247], v67 offset:55296
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v244, s46 offset:844
		scratch_store_dword off, v245, s46 offset:848
		scratch_store_dword off, v246, s46 offset:852
		scratch_store_dword off, v247, s46 offset:856
		s_mov_b32 s46, 0
		scratch_store_dword off, v244, s46 offset:860
		scratch_store_dword off, v245, s46 offset:864
		scratch_store_dword off, v246, s46 offset:868
		scratch_store_dword off, v247, s46 offset:872
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[20:23], v[44:47], v[108:111], v9, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[244:247], v67 offset:56320
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v244, s46 offset:812
		scratch_store_dword off, v245, s46 offset:816
		scratch_store_dword off, v246, s46 offset:820
		scratch_store_dword off, v247, s46 offset:824
		s_mov_b32 s46, 0
		scratch_store_dword off, v244, s46 offset:828
		scratch_store_dword off, v245, s46 offset:832
		scratch_store_dword off, v246, s46 offset:836
		scratch_store_dword off, v247, s46 offset:840
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[20:23], v[48:51], v[112:115], v9, v65 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s15
		s_nop 0
		buffer_load_dwordx4 v198, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[20:23], v[52:55], v[116:119], v9, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s28
		s_nop 0
		buffer_load_dwordx4 v200, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], v[56:59], v[120:123], v9, v66 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v202, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[20:23], v[60:63], v[124:127], v9, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s30
		s_nop 0
		buffer_load_dwordx4 v204, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[24:27], v[32:35], v[128:131], v12, v14 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s31
		s_nop 0
		buffer_load_dwordx4 v206, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[24:27], v[36:39], v[132:135], v12, v14 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s32
		s_nop 0
		buffer_load_dwordx4 v208, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[24:27], v[40:43], v[136:139], v12, v15 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v210, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[24:27], v[44:47], v[140:143], v12, v15 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s34
		s_nop 0
		buffer_load_dwordx4 v212, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[48:51], v[144:147], v12, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s8, 0x20000
		s_nop 0
		buffer_load_dword v194, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[52:55], v[148:151], v12, v65 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s37, 0x20000
		s_nop 0
		buffer_load_dword v216, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[56:59], v[152:155], v12, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s36, 0x20000
		s_nop 0
		buffer_load_dwordx4 v218, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[24:27], v[60:63], v[156:159], v12, v66 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		ds_read_b128 v[16:19], v192
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[28:31], v[32:35], v[160:163], v12, v14 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v192 offset:1024
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[28:31], v[36:39], v[164:167], v12, v14 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[24:27], v192 offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[28:31], v[40:43], v[168:171], v12, v15 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[200:203], v192 offset:3072
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v200, s46 offset:264
		scratch_store_dword off, v201, s46 offset:268
		scratch_store_dword off, v202, s46 offset:272
		scratch_store_dword off, v203, s46 offset:276
		s_mov_b32 s46, 0
		scratch_store_dword off, v200, s46 offset:280
		scratch_store_dword off, v201, s46 offset:284
		scratch_store_dword off, v202, s46 offset:288
		scratch_store_dword off, v203, s46 offset:292
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[28:31], v[44:47], v[172:175], v12, v15 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[32:35], v67 offset:32768
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[48:51], v[176:179], v12, v65 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[36:39], v67 offset:33792
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[52:55], v[180:183], v12, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[40:43], v67 offset:34816
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[56:59], v[184:187], v12, v66 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[44:47], v67 offset:35840
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[28:31], v[60:63], v[188:191], v12, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[48:51], v67 offset:36864
		ds_read_b128 v[52:55], v67 offset:37888
		ds_read_b128 v[56:59], v67 offset:38912
		ds_read_b128 v[60:63], v67 offset:39936
		v_readfirstlane_b32 s46, v3
		s_lshl_b32 s47, s46, 12
		s_add_i32 s46, s47, 0x20000
		v_lshrrev_b32_e32 v3, 7, v0
		v_lshlrev_b32_e32 v8, 9, v3
		v_lshlrev_b32_e32 v3, 2, v1
		v_add3_u32 v10, s46, v8, v3
		ds_read_b32 v3, v10
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v3, s47 offset:260
		ds_read_b32 v3, v10 offset:256
		s_mov_b32 s47, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v3, s47 offset:256
		v_lshlrev_b32_e32 v3, 10, v13
		v_lshlrev_b32_e32 v8, 2, v1
		v_add3_u32 v10, s46, v8, v3
		ds_read_b32 v3, v10 offset:2048
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v3, s46 offset:252
		ds_read_b32 v3, v10 offset:2304
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v3, s46 offset:248
		ds_read_b32 v3, v10 offset:2560
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v3, s46 offset:244
		ds_read_b32 v3, v10 offset:2816
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v3, s46 offset:240
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[220:223], v[236:239], v[4:7], v9, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[220:223], v[240:243], v[68:71], v9, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(54)
		scratch_load_dword v192, off, s46 offset:892
		scratch_load_dword v193, off, s46 offset:896
		scratch_load_dword v194, off, s46 offset:900
		scratch_load_dword v195, off, s46 offset:904
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[220:223], v[192:195], v[72:75], v9, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(46)
		scratch_load_dword v192, off, s46 offset:224
		scratch_load_dword v193, off, s46 offset:228
		scratch_load_dword v194, off, s46 offset:232
		scratch_load_dword v195, off, s46 offset:236
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[220:223], v[192:195], v[76:79], v9, v15 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(38)
		scratch_load_dword v192, off, s46 offset:192
		scratch_load_dword v193, off, s46 offset:196
		scratch_load_dword v194, off, s46 offset:200
		scratch_load_dword v195, off, s46 offset:204
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[220:223], v[192:195], v[80:83], v9, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(30)
		scratch_load_dword v192, off, s46 offset:160
		scratch_load_dword v193, off, s46 offset:164
		scratch_load_dword v194, off, s46 offset:168
		scratch_load_dword v195, off, s46 offset:172
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[220:223], v[192:195], v[84:87], v9, v65 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(22)
		scratch_load_dword v192, off, s46 offset:860
		scratch_load_dword v193, off, s46 offset:864
		scratch_load_dword v194, off, s46 offset:868
		scratch_load_dword v195, off, s46 offset:872
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[220:223], v[192:195], v[88:91], v9, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(14)
		scratch_load_dword v192, off, s46 offset:828
		scratch_load_dword v193, off, s46 offset:832
		scratch_load_dword v194, off, s46 offset:836
		scratch_load_dword v195, off, s46 offset:840
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[220:223], v[192:195], v[92:95], v9, v66 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[224:227], v[236:239], v[96:99], v9, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[224:227], v[240:243], v[100:103], v9, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v192, off, s46 offset:892
		scratch_load_dword v193, off, s46 offset:896
		scratch_load_dword v194, off, s46 offset:900
		scratch_load_dword v195, off, s46 offset:904
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[224:227], v[192:195], v[104:107], v9, v15 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v192, off, s46 offset:224
		scratch_load_dword v193, off, s46 offset:228
		scratch_load_dword v194, off, s46 offset:232
		scratch_load_dword v195, off, s46 offset:236
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[224:227], v[192:195], v[108:111], v9, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v192, off, s46 offset:192
		scratch_load_dword v193, off, s46 offset:196
		scratch_load_dword v194, off, s46 offset:200
		scratch_load_dword v195, off, s46 offset:204
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[224:227], v[192:195], v[112:115], v9, v65 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v192, off, s46 offset:160
		scratch_load_dword v193, off, s46 offset:164
		scratch_load_dword v194, off, s46 offset:168
		scratch_load_dword v195, off, s46 offset:172
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[224:227], v[192:195], v[116:119], v9, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v192, off, s46 offset:860
		scratch_load_dword v193, off, s46 offset:864
		scratch_load_dword v194, off, s46 offset:868
		scratch_load_dword v195, off, s46 offset:872
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[224:227], v[192:195], v[120:123], v9, v66 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v192, off, s46 offset:828
		scratch_load_dword v193, off, s46 offset:832
		scratch_load_dword v194, off, s46 offset:836
		scratch_load_dword v195, off, s46 offset:840
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[224:227], v[192:195], v[124:127], v9, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[228:231], v[236:239], v[128:131], v12, v14 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[228:231], v[240:243], v[132:135], v12, v14 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v192, off, s46 offset:892
		scratch_load_dword v193, off, s46 offset:896
		scratch_load_dword v194, off, s46 offset:900
		scratch_load_dword v195, off, s46 offset:904
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[228:231], v[192:195], v[136:139], v12, v15 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v192, off, s46 offset:224
		scratch_load_dword v193, off, s46 offset:228
		scratch_load_dword v194, off, s46 offset:232
		scratch_load_dword v195, off, s46 offset:236
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[228:231], v[192:195], v[140:143], v12, v15 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v192, off, s46 offset:192
		scratch_load_dword v193, off, s46 offset:196
		scratch_load_dword v194, off, s46 offset:200
		scratch_load_dword v195, off, s46 offset:204
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[228:231], v[192:195], v[144:147], v12, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v192, off, s46 offset:160
		scratch_load_dword v193, off, s46 offset:164
		scratch_load_dword v194, off, s46 offset:168
		scratch_load_dword v195, off, s46 offset:172
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[228:231], v[192:195], v[148:151], v12, v65 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v192, off, s46 offset:860
		scratch_load_dword v193, off, s46 offset:864
		scratch_load_dword v194, off, s46 offset:868
		scratch_load_dword v195, off, s46 offset:872
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[228:231], v[192:195], v[152:155], v12, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v192, off, s46 offset:828
		scratch_load_dword v193, off, s46 offset:832
		scratch_load_dword v194, off, s46 offset:836
		scratch_load_dword v195, off, s46 offset:840
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[228:231], v[192:195], v[156:159], v12, v66 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[232:235], v[236:239], v[160:163], v12, v14 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[232:235], v[240:243], v[164:167], v12, v14 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v192, off, s46 offset:892
		scratch_load_dword v193, off, s46 offset:896
		scratch_load_dword v194, off, s46 offset:900
		scratch_load_dword v195, off, s46 offset:904
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[232:235], v[192:195], v[168:171], v12, v15 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v192, off, s46 offset:224
		scratch_load_dword v193, off, s46 offset:228
		scratch_load_dword v194, off, s46 offset:232
		scratch_load_dword v195, off, s46 offset:236
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[232:235], v[192:195], v[172:175], v12, v15 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v192, off, s46 offset:192
		scratch_load_dword v193, off, s46 offset:196
		scratch_load_dword v194, off, s46 offset:200
		scratch_load_dword v195, off, s46 offset:204
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[232:235], v[192:195], v[176:179], v12, v65 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v192, off, s46 offset:160
		scratch_load_dword v193, off, s46 offset:164
		scratch_load_dword v194, off, s46 offset:168
		scratch_load_dword v195, off, s46 offset:172
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[232:235], v[192:195], v[180:183], v12, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v192, off, s46 offset:860
		scratch_load_dword v193, off, s46 offset:864
		scratch_load_dword v194, off, s46 offset:868
		scratch_load_dword v195, off, s46 offset:872
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[232:235], v[192:195], v[184:187], v12, v66 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v192, off, s46 offset:828
		scratch_load_dword v193, off, s46 offset:832
		scratch_load_dword v194, off, s46 offset:836
		scratch_load_dword v195, off, s46 offset:840
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[232:235], v[192:195], v[188:191], v12, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s46, s11, 1
		s_and_b32 s47, s46, 1
		s_lshl_b32 s46, s47, 16
		v_lshrrev_b32_e32 v3, 7, v0
		v_lshlrev_b32_e32 v8, 12, v3
		v_add_u32_e32 v3, s46, v8
		v_and_b32_e32 v8, 15, v0
		v_lshlrev_b32_e32 v10, 6, v8
		v_lshlrev_b32_e32 v8, 4, v11
		v_add3_u32 v64, v3, v10, v8
		s_mov_b32 s48, 0
		scratch_store_dword off, v64, s48 offset:924
		s_mov_b32 s48, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v3, off, s48 offset:924
		s_waitcnt vmcnt(0)
		ds_read_b128 v[192:195], v3
		s_mov_b32 s48, 0
		scratch_load_dword v3, off, s48 offset:924
		s_waitcnt vmcnt(0)
		ds_read_b128 v[200:203], v3 offset:1024
		s_mov_b32 s48, 0
		scratch_load_dword v3, off, s48 offset:924
		s_waitcnt vmcnt(0)
		ds_read_b128 v[204:207], v3 offset:2048
		s_mov_b32 s48, 0
		scratch_load_dword v3, off, s48 offset:924
		s_waitcnt vmcnt(0)
		ds_read_b128 v[208:211], v3 offset:3072
		v_and_b32_e32 v3, 15, v0
		v_lshlrev_b32_e32 v8, 6, v3
		v_add_u32_e32 v3, s46, v8
		v_lshlrev_b32_e32 v8, 13, v13
		v_lshlrev_b32_e32 v10, 4, v11
		v_add3_u32 v64, v3, v8, v10
		ds_read_b128 v[216:219], v64 offset:32768
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v216, s46 offset:520
		scratch_store_dword off, v217, s46 offset:524
		scratch_store_dword off, v218, s46 offset:528
		scratch_store_dword off, v219, s46 offset:532
		s_mov_b32 s46, 0
		scratch_store_dword off, v216, s46 offset:536
		scratch_store_dword off, v217, s46 offset:540
		scratch_store_dword off, v218, s46 offset:544
		scratch_store_dword off, v219, s46 offset:548
		ds_read_b128 v[216:219], v64 offset:33792
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v216, s46 offset:488
		scratch_store_dword off, v217, s46 offset:492
		scratch_store_dword off, v218, s46 offset:496
		scratch_store_dword off, v219, s46 offset:500
		s_mov_b32 s46, 0
		scratch_store_dword off, v216, s46 offset:504
		scratch_store_dword off, v217, s46 offset:508
		scratch_store_dword off, v218, s46 offset:512
		scratch_store_dword off, v219, s46 offset:516
		ds_read_b128 v[216:219], v64 offset:34816
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v216, s46 offset:456
		scratch_store_dword off, v217, s46 offset:460
		scratch_store_dword off, v218, s46 offset:464
		scratch_store_dword off, v219, s46 offset:468
		s_mov_b32 s46, 0
		scratch_store_dword off, v216, s46 offset:472
		scratch_store_dword off, v217, s46 offset:476
		scratch_store_dword off, v218, s46 offset:480
		scratch_store_dword off, v219, s46 offset:484
		ds_read_b128 v[216:219], v64 offset:35840
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v216, s46 offset:424
		scratch_store_dword off, v217, s46 offset:428
		scratch_store_dword off, v218, s46 offset:432
		scratch_store_dword off, v219, s46 offset:436
		s_mov_b32 s46, 0
		scratch_store_dword off, v216, s46 offset:440
		scratch_store_dword off, v217, s46 offset:444
		scratch_store_dword off, v218, s46 offset:448
		scratch_store_dword off, v219, s46 offset:452
		ds_read_b128 v[216:219], v64 offset:36864
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v216, s46 offset:392
		scratch_store_dword off, v217, s46 offset:396
		scratch_store_dword off, v218, s46 offset:400
		scratch_store_dword off, v219, s46 offset:404
		s_mov_b32 s46, 0
		scratch_store_dword off, v216, s46 offset:408
		scratch_store_dword off, v217, s46 offset:412
		scratch_store_dword off, v218, s46 offset:416
		scratch_store_dword off, v219, s46 offset:420
		ds_read_b128 v[216:219], v64 offset:37888
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v216, s46 offset:360
		scratch_store_dword off, v217, s46 offset:364
		scratch_store_dword off, v218, s46 offset:368
		scratch_store_dword off, v219, s46 offset:372
		s_mov_b32 s46, 0
		scratch_store_dword off, v216, s46 offset:376
		scratch_store_dword off, v217, s46 offset:380
		scratch_store_dword off, v218, s46 offset:384
		scratch_store_dword off, v219, s46 offset:388
		ds_read_b128 v[216:219], v64 offset:38912
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v216, s46 offset:328
		scratch_store_dword off, v217, s46 offset:332
		scratch_store_dword off, v218, s46 offset:336
		scratch_store_dword off, v219, s46 offset:340
		s_mov_b32 s46, 0
		scratch_store_dword off, v216, s46 offset:344
		scratch_store_dword off, v217, s46 offset:348
		scratch_store_dword off, v218, s46 offset:352
		scratch_store_dword off, v219, s46 offset:356
		ds_read_b128 v[216:219], v64 offset:39936
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v216, s46 offset:296
		scratch_store_dword off, v217, s46 offset:300
		scratch_store_dword off, v218, s46 offset:304
		scratch_store_dword off, v219, s46 offset:308
		s_mov_b32 s46, 0
		scratch_store_dword off, v216, s46 offset:312
		scratch_store_dword off, v217, s46 offset:316
		scratch_store_dword off, v218, s46 offset:320
		scratch_store_dword off, v219, s46 offset:324
		s_lshl_b32 s46, s47, 12
		s_add_i32 s47, s46, 0x20000
		v_lshrrev_b32_e32 v3, 7, v0
		v_lshlrev_b32_e32 v8, 9, v3
		v_lshlrev_b32_e32 v3, 2, v1
		v_add3_u32 v10, s47, v8, v3
		ds_read_b32 v3, v10
		ds_read_b32 v8, v10 offset:256
		v_lshlrev_b32_e32 v10, 10, v13
		v_lshlrev_b32_e32 v67, 2, v1
		v_add3_u32 v198, s47, v67, v10
		ds_read_b32 v10, v198 offset:2048
		ds_read_b32 v67, v198 offset:2304
		ds_read_b32 v199, v198 offset:2560
		ds_read_b32 v212, v198 offset:2816
		s_waitcnt lgkmcnt(0)
		s_mov_b32 s46, 0
		scratch_load_dword v216, off, s46 offset:56
		scratch_load_dword v217, off, s46 offset:60
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v218, vcc, v216, v196
		v_addc_co_u32_e64 v219, vcc, v217, v197, vcc
		s_mov_b32 s46, 0
		scratch_load_dword v216, off, s46 offset:64
		scratch_load_dword v217, off, s46 offset:68
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v220, vcc, v216, v196
		v_addc_co_u32_e64 v221, vcc, v217, v197, vcc
		s_mov_b32 s46, 0
		scratch_load_dword v216, off, s46 offset:72
		scratch_load_dword v217, off, s46 offset:76
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v222, vcc, v216, v196
		v_addc_co_u32_e64 v223, vcc, v217, v197, vcc
		s_mov_b32 s46, 0
		scratch_load_dword v216, off, s46 offset:80
		scratch_load_dword v217, off, s46 offset:84
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v224, vcc, v216, v196
		v_addc_co_u32_e64 v225, vcc, v217, v197, vcc
		s_mov_b32 s46, 0
		scratch_load_dword v216, off, s46 offset:88
		scratch_load_dword v217, off, s46 offset:92
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v226, vcc, v216, v196
		v_addc_co_u32_e64 v227, vcc, v217, v197, vcc
		s_mov_b32 s46, 0
		scratch_load_dword v216, off, s46 offset:96
		scratch_load_dword v217, off, s46 offset:100
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v228, vcc, v216, v196
		v_addc_co_u32_e64 v229, vcc, v217, v197, vcc
		s_mov_b32 s46, 0
		scratch_load_dword v216, off, s46 offset:104
		scratch_load_dword v217, off, s46 offset:108
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v230, vcc, v216, v196
		v_addc_co_u32_e64 v231, vcc, v217, v197, vcc
		s_mov_b32 s46, 0
		scratch_load_dword v216, off, s46 offset:112
		scratch_load_dword v217, off, s46 offset:116
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v232, vcc, v216, v196
		v_addc_co_u32_e64 v233, vcc, v217, v197, vcc
		s_mov_b32 s46, 0
		scratch_load_dword v196, off, s46 offset:120
		scratch_load_dword v197, off, s46 offset:124
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v216, vcc, v196, v214
		v_addc_co_u32_e64 v217, vcc, v197, v215, vcc
		s_mov_b32 s46, 0
		scratch_load_dword v196, off, s46 offset:128
		scratch_load_dword v197, off, s46 offset:132
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v234, vcc, v196, v214
		v_addc_co_u32_e64 v235, vcc, v197, v215, vcc
		s_mov_b32 s46, 0
		scratch_load_dword v196, off, s46 offset:136
		scratch_load_dword v197, off, s46 offset:140
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v236, vcc, v196, v214
		v_addc_co_u32_e64 v237, vcc, v197, v215, vcc
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(56)
		scratch_load_dword v240, off, s46 offset:536
		scratch_load_dword v241, off, s46 offset:540
		scratch_load_dword v242, off, s46 offset:544
		scratch_load_dword v243, off, s46 offset:548
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[192:195], v[240:243], v[4:7], v3, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v196, off, s46 offset:924
		s_waitcnt vmcnt(0)
		ds_read_b128 v[240:243], v196 offset:16384
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(48)
		scratch_load_dword v244, off, s46 offset:504
		scratch_load_dword v245, off, s46 offset:508
		scratch_load_dword v246, off, s46 offset:512
		scratch_load_dword v247, off, s46 offset:516
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[192:195], v[244:247], v[68:71], v3, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v196, off, s46 offset:924
		s_waitcnt vmcnt(0)
		ds_read_b128 v[244:247], v196 offset:17408
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v244, s46 offset:960
		scratch_store_dword off, v245, s46 offset:964
		scratch_store_dword off, v246, s46 offset:968
		scratch_store_dword off, v247, s46 offset:972
		s_mov_b32 s46, 0
		scratch_store_dword off, v244, s46 offset:976
		scratch_store_dword off, v245, s46 offset:980
		scratch_store_dword off, v246, s46 offset:984
		scratch_store_dword off, v247, s46 offset:988
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(48)
		scratch_load_dword v244, off, s46 offset:472
		scratch_load_dword v245, off, s46 offset:476
		scratch_load_dword v246, off, s46 offset:480
		scratch_load_dword v247, off, s46 offset:484
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[192:195], v[244:247], v[72:75], v3, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v196, off, s46 offset:924
		s_waitcnt vmcnt(0)
		ds_read_b128 v[244:247], v196 offset:18432
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v244, s46 offset:928
		scratch_store_dword off, v245, s46 offset:932
		scratch_store_dword off, v246, s46 offset:936
		scratch_store_dword off, v247, s46 offset:940
		s_mov_b32 s46, 0
		scratch_store_dword off, v244, s46 offset:944
		scratch_store_dword off, v245, s46 offset:948
		scratch_store_dword off, v246, s46 offset:952
		scratch_store_dword off, v247, s46 offset:956
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(48)
		scratch_load_dword v244, off, s46 offset:440
		scratch_load_dword v245, off, s46 offset:444
		scratch_load_dword v246, off, s46 offset:448
		scratch_load_dword v247, off, s46 offset:452
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(0)
		scratch_store_dword off, v244, s46 offset:908
		scratch_store_dword off, v245, s46 offset:912
		scratch_store_dword off, v246, s46 offset:916
		scratch_store_dword off, v247, s46 offset:920
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v244, off, s46 offset:908
		scratch_load_dword v245, off, s46 offset:912
		scratch_load_dword v246, off, s46 offset:916
		scratch_load_dword v247, off, s46 offset:920
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[192:195], v[244:247], v[76:79], v3, v67 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v196, off, s46 offset:924
		s_waitcnt vmcnt(0)
		ds_read_b128 v[244:247], v196 offset:19456
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v244, s46 offset:584
		scratch_store_dword off, v245, s46 offset:588
		scratch_store_dword off, v246, s46 offset:592
		scratch_store_dword off, v247, s46 offset:596
		s_mov_b32 s46, 0
		scratch_store_dword off, v244, s46 offset:600
		scratch_store_dword off, v245, s46 offset:604
		scratch_store_dword off, v246, s46 offset:608
		scratch_store_dword off, v247, s46 offset:612
		s_mov_b32 s46, 0
		scratch_load_dword v244, off, s46 offset:408
		scratch_load_dword v245, off, s46 offset:412
		scratch_load_dword v246, off, s46 offset:416
		scratch_load_dword v247, off, s46 offset:420
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[192:195], v[244:247], v[80:83], v3, v199 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[244:247], v64 offset:49152
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v244, s46 offset:552
		scratch_store_dword off, v245, s46 offset:556
		scratch_store_dword off, v246, s46 offset:560
		scratch_store_dword off, v247, s46 offset:564
		s_mov_b32 s46, 0
		scratch_store_dword off, v244, s46 offset:568
		scratch_store_dword off, v245, s46 offset:572
		scratch_store_dword off, v246, s46 offset:576
		scratch_store_dword off, v247, s46 offset:580
		s_mov_b32 s46, 0
		scratch_load_dword v244, off, s46 offset:376
		scratch_load_dword v245, off, s46 offset:380
		scratch_load_dword v246, off, s46 offset:384
		scratch_load_dword v247, off, s46 offset:388
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[192:195], v[244:247], v[84:87], v3, v199 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[244:247], v64 offset:50176
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v244, s46 offset:648
		scratch_store_dword off, v245, s46 offset:652
		scratch_store_dword off, v246, s46 offset:656
		scratch_store_dword off, v247, s46 offset:660
		s_mov_b32 s46, 0
		scratch_store_dword off, v244, s46 offset:664
		scratch_store_dword off, v245, s46 offset:668
		scratch_store_dword off, v246, s46 offset:672
		scratch_store_dword off, v247, s46 offset:676
		s_mov_b32 s46, 0
		scratch_load_dword v244, off, s46 offset:344
		scratch_load_dword v245, off, s46 offset:348
		scratch_load_dword v246, off, s46 offset:352
		scratch_load_dword v247, off, s46 offset:356
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[192:195], v[244:247], v[88:91], v3, v212 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[244:247], v64 offset:51200
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v244, s46 offset:616
		scratch_store_dword off, v245, s46 offset:620
		scratch_store_dword off, v246, s46 offset:624
		scratch_store_dword off, v247, s46 offset:628
		s_mov_b32 s46, 0
		scratch_store_dword off, v244, s46 offset:632
		scratch_store_dword off, v245, s46 offset:636
		scratch_store_dword off, v246, s46 offset:640
		scratch_store_dword off, v247, s46 offset:644
		s_mov_b32 s46, 0
		scratch_load_dword v244, off, s46 offset:312
		scratch_load_dword v245, off, s46 offset:316
		scratch_load_dword v246, off, s46 offset:320
		scratch_load_dword v247, off, s46 offset:324
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[192:195], v[244:247], v[92:95], v3, v212 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[192:195], v64 offset:52224
		s_mov_b32 s46, 0
		scratch_load_dword v244, off, s46 offset:536
		scratch_load_dword v245, off, s46 offset:540
		scratch_load_dword v246, off, s46 offset:544
		scratch_load_dword v247, off, s46 offset:548
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[200:203], v[244:247], v[96:99], v3, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[244:247], v64 offset:53248
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v244, s46 offset:712
		scratch_store_dword off, v245, s46 offset:716
		scratch_store_dword off, v246, s46 offset:720
		scratch_store_dword off, v247, s46 offset:724
		s_mov_b32 s46, 0
		scratch_store_dword off, v244, s46 offset:728
		scratch_store_dword off, v245, s46 offset:732
		scratch_store_dword off, v246, s46 offset:736
		scratch_store_dword off, v247, s46 offset:740
		s_mov_b32 s46, 0
		scratch_load_dword v244, off, s46 offset:504
		scratch_load_dword v245, off, s46 offset:508
		scratch_load_dword v246, off, s46 offset:512
		scratch_load_dword v247, off, s46 offset:516
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[200:203], v[244:247], v[100:103], v3, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[244:247], v64 offset:54272
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v244, s46 offset:680
		scratch_store_dword off, v245, s46 offset:684
		scratch_store_dword off, v246, s46 offset:688
		scratch_store_dword off, v247, s46 offset:692
		s_mov_b32 s46, 0
		scratch_store_dword off, v244, s46 offset:696
		scratch_store_dword off, v245, s46 offset:700
		scratch_store_dword off, v246, s46 offset:704
		scratch_store_dword off, v247, s46 offset:708
		s_mov_b32 s46, 0
		scratch_load_dword v244, off, s46 offset:472
		scratch_load_dword v245, off, s46 offset:476
		scratch_load_dword v246, off, s46 offset:480
		scratch_load_dword v247, off, s46 offset:484
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[200:203], v[244:247], v[104:107], v3, v67 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[244:247], v64 offset:55296
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v244, s46 offset:776
		scratch_store_dword off, v245, s46 offset:780
		scratch_store_dword off, v246, s46 offset:784
		scratch_store_dword off, v247, s46 offset:788
		s_mov_b32 s46, 0
		scratch_store_dword off, v244, s46 offset:792
		scratch_store_dword off, v245, s46 offset:796
		scratch_store_dword off, v246, s46 offset:800
		scratch_store_dword off, v247, s46 offset:804
		s_mov_b32 s46, 0
		scratch_load_dword v244, off, s46 offset:440
		scratch_load_dword v245, off, s46 offset:444
		scratch_load_dword v246, off, s46 offset:448
		scratch_load_dword v247, off, s46 offset:452
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[200:203], v[244:247], v[108:111], v3, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[244:247], v64 offset:56320
		s_mov_b32 s46, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v244, s46 offset:744
		scratch_store_dword off, v245, s46 offset:748
		scratch_store_dword off, v246, s46 offset:752
		scratch_store_dword off, v247, s46 offset:756
		s_mov_b32 s46, 0
		scratch_store_dword off, v244, s46 offset:760
		scratch_store_dword off, v245, s46 offset:764
		scratch_store_dword off, v246, s46 offset:768
		scratch_store_dword off, v247, s46 offset:772
		s_mov_b32 s46, 0
		scratch_load_dword v244, off, s46 offset:408
		scratch_load_dword v245, off, s46 offset:412
		scratch_load_dword v246, off, s46 offset:416
		scratch_load_dword v247, off, s46 offset:420
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[200:203], v[244:247], v[112:115], v3, v199 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s10
		s_nop 0
		buffer_load_dwordx4 v218, s[20:23], 0 offen lds
		s_mov_b32 s46, 0
		scratch_load_dword v244, off, s46 offset:376
		scratch_load_dword v245, off, s46 offset:380
		scratch_load_dword v246, off, s46 offset:384
		scratch_load_dword v247, off, s46 offset:388
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[200:203], v[244:247], v[116:119], v3, v199 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v220, s[20:23], 0 offen lds
		s_mov_b32 s46, 0
		scratch_load_dword v244, off, s46 offset:344
		scratch_load_dword v245, off, s46 offset:348
		scratch_load_dword v246, off, s46 offset:352
		scratch_load_dword v247, off, s46 offset:356
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[200:203], v[244:247], v[120:123], v3, v212 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v222, s[20:23], 0 offen lds
		s_mov_b32 s46, 0
		scratch_load_dword v220, off, s46 offset:312
		scratch_load_dword v221, off, s46 offset:316
		scratch_load_dword v222, off, s46 offset:320
		scratch_load_dword v223, off, s46 offset:324
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[200:203], v[220:223], v[124:127], v3, v212 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s40
		s_nop 0
		buffer_load_dwordx4 v224, s[20:23], 0 offen lds
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:536
		scratch_load_dword v201, off, s46 offset:540
		scratch_load_dword v202, off, s46 offset:544
		scratch_load_dword v203, off, s46 offset:548
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[204:207], v[200:203], v[128:131], v8, v10 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s41
		s_nop 0
		buffer_load_dwordx4 v226, s[0:3], 0 offen lds
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:504
		scratch_load_dword v201, off, s46 offset:508
		scratch_load_dword v202, off, s46 offset:512
		scratch_load_dword v203, off, s46 offset:516
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[204:207], v[200:203], v[132:135], v8, v10 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s42
		s_nop 0
		buffer_load_dwordx4 v228, s[0:3], 0 offen lds
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:472
		scratch_load_dword v201, off, s46 offset:476
		scratch_load_dword v202, off, s46 offset:480
		scratch_load_dword v203, off, s46 offset:484
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[204:207], v[200:203], v[136:139], v8, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s43
		s_nop 0
		buffer_load_dwordx4 v230, s[0:3], 0 offen lds
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:440
		scratch_load_dword v201, off, s46 offset:444
		scratch_load_dword v202, off, s46 offset:448
		scratch_load_dword v203, off, s46 offset:452
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[204:207], v[200:203], v[140:143], v8, v67 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 m0, s44
		s_nop 0
		buffer_load_dwordx4 v232, s[0:3], 0 offen lds
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:408
		scratch_load_dword v201, off, s46 offset:412
		scratch_load_dword v202, off, s46 offset:416
		scratch_load_dword v203, off, s46 offset:420
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[204:207], v[200:203], v[144:147], v8, v199 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s45, 0x20000
		s_nop 0
		buffer_load_dword v216, s[4:7], 0 offen lds
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:376
		scratch_load_dword v201, off, s46 offset:380
		scratch_load_dword v202, off, s46 offset:384
		scratch_load_dword v203, off, s46 offset:388
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[204:207], v[200:203], v[148:151], v8, v199 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s9, 0x20000
		s_nop 0
		buffer_load_dword v234, s[4:7], 0 offen lds
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:344
		scratch_load_dword v201, off, s46 offset:348
		scratch_load_dword v202, off, s46 offset:352
		scratch_load_dword v203, off, s46 offset:356
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[204:207], v[200:203], v[152:155], v8, v212 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s35, 0x20000
		s_nop 0
		buffer_load_dwordx4 v236, s[24:27], 0 offen lds
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:312
		scratch_load_dword v201, off, s46 offset:316
		scratch_load_dword v202, off, s46 offset:320
		scratch_load_dword v203, off, s46 offset:324
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[204:207], v[200:203], v[156:159], v8, v212 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:536
		scratch_load_dword v201, off, s46 offset:540
		scratch_load_dword v202, off, s46 offset:544
		scratch_load_dword v203, off, s46 offset:548
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[208:211], v[200:203], v[160:163], v8, v10 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:504
		scratch_load_dword v201, off, s46 offset:508
		scratch_load_dword v202, off, s46 offset:512
		scratch_load_dword v203, off, s46 offset:516
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[208:211], v[200:203], v[164:167], v8, v10 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:472
		scratch_load_dword v201, off, s46 offset:476
		scratch_load_dword v202, off, s46 offset:480
		scratch_load_dword v203, off, s46 offset:484
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[208:211], v[200:203], v[168:171], v8, v67 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:440
		scratch_load_dword v201, off, s46 offset:444
		scratch_load_dword v202, off, s46 offset:448
		scratch_load_dword v203, off, s46 offset:452
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[208:211], v[200:203], v[172:175], v8, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:408
		scratch_load_dword v201, off, s46 offset:412
		scratch_load_dword v202, off, s46 offset:416
		scratch_load_dword v203, off, s46 offset:420
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[208:211], v[200:203], v[176:179], v8, v199 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:376
		scratch_load_dword v201, off, s46 offset:380
		scratch_load_dword v202, off, s46 offset:384
		scratch_load_dword v203, off, s46 offset:388
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[208:211], v[200:203], v[180:183], v8, v199 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:344
		scratch_load_dword v201, off, s46 offset:348
		scratch_load_dword v202, off, s46 offset:352
		scratch_load_dword v203, off, s46 offset:356
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[208:211], v[200:203], v[184:187], v8, v212 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:312
		scratch_load_dword v201, off, s46 offset:316
		scratch_load_dword v202, off, s46 offset:320
		scratch_load_dword v203, off, s46 offset:324
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[208:211], v[200:203], v[188:191], v8, v212 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(48)
		scratch_load_dword v200, off, s46 offset:568
		scratch_load_dword v201, off, s46 offset:572
		scratch_load_dword v202, off, s46 offset:576
		scratch_load_dword v203, off, s46 offset:580
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[4:7], v[240:243], v[200:203], v[4:7], v3, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(40)
		scratch_load_dword v200, off, s46 offset:664
		scratch_load_dword v201, off, s46 offset:668
		scratch_load_dword v202, off, s46 offset:672
		scratch_load_dword v203, off, s46 offset:676
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[68:71], v[240:243], v[200:203], v[68:71], v3, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(32)
		scratch_load_dword v200, off, s46 offset:632
		scratch_load_dword v201, off, s46 offset:636
		scratch_load_dword v202, off, s46 offset:640
		scratch_load_dword v203, off, s46 offset:644
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[240:243], v[200:203], v[72:75], v3, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[240:243], v[192:195], v[76:79], v3, v67 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v200, off, s46 offset:728
		scratch_load_dword v201, off, s46 offset:732
		scratch_load_dword v202, off, s46 offset:736
		scratch_load_dword v203, off, s46 offset:740
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[240:243], v[200:203], v[80:83], v3, v199 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v200, off, s46 offset:696
		scratch_load_dword v201, off, s46 offset:700
		scratch_load_dword v202, off, s46 offset:704
		scratch_load_dword v203, off, s46 offset:708
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[240:243], v[200:203], v[84:87], v3, v199 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v200, off, s46 offset:792
		scratch_load_dword v201, off, s46 offset:796
		scratch_load_dword v202, off, s46 offset:800
		scratch_load_dword v203, off, s46 offset:804
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[240:243], v[200:203], v[88:91], v3, v212 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v200, off, s46 offset:760
		scratch_load_dword v201, off, s46 offset:764
		scratch_load_dword v202, off, s46 offset:768
		scratch_load_dword v203, off, s46 offset:772
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[240:243], v[200:203], v[92:95], v3, v212 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:568
		scratch_load_dword v201, off, s46 offset:572
		scratch_load_dword v202, off, s46 offset:576
		scratch_load_dword v203, off, s46 offset:580
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:976
		scratch_load_dword v205, off, s46 offset:980
		scratch_load_dword v206, off, s46 offset:984
		scratch_load_dword v207, off, s46 offset:988
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[96:99], v[204:207], v[200:203], v[96:99], v3, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:664
		scratch_load_dword v201, off, s46 offset:668
		scratch_load_dword v202, off, s46 offset:672
		scratch_load_dword v203, off, s46 offset:676
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:976
		scratch_load_dword v205, off, s46 offset:980
		scratch_load_dword v206, off, s46 offset:984
		scratch_load_dword v207, off, s46 offset:988
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[204:207], v[200:203], v[100:103], v3, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:632
		scratch_load_dword v201, off, s46 offset:636
		scratch_load_dword v202, off, s46 offset:640
		scratch_load_dword v203, off, s46 offset:644
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:976
		scratch_load_dword v205, off, s46 offset:980
		scratch_load_dword v206, off, s46 offset:984
		scratch_load_dword v207, off, s46 offset:988
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[204:207], v[200:203], v[104:107], v3, v67 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:976
		scratch_load_dword v201, off, s46 offset:980
		scratch_load_dword v202, off, s46 offset:984
		scratch_load_dword v203, off, s46 offset:988
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[200:203], v[192:195], v[108:111], v3, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:728
		scratch_load_dword v201, off, s46 offset:732
		scratch_load_dword v202, off, s46 offset:736
		scratch_load_dword v203, off, s46 offset:740
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:976
		scratch_load_dword v205, off, s46 offset:980
		scratch_load_dword v206, off, s46 offset:984
		scratch_load_dword v207, off, s46 offset:988
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[204:207], v[200:203], v[112:115], v3, v199 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:696
		scratch_load_dword v201, off, s46 offset:700
		scratch_load_dword v202, off, s46 offset:704
		scratch_load_dword v203, off, s46 offset:708
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:976
		scratch_load_dword v205, off, s46 offset:980
		scratch_load_dword v206, off, s46 offset:984
		scratch_load_dword v207, off, s46 offset:988
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[204:207], v[200:203], v[116:119], v3, v199 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:792
		scratch_load_dword v201, off, s46 offset:796
		scratch_load_dword v202, off, s46 offset:800
		scratch_load_dword v203, off, s46 offset:804
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:976
		scratch_load_dword v205, off, s46 offset:980
		scratch_load_dword v206, off, s46 offset:984
		scratch_load_dword v207, off, s46 offset:988
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[204:207], v[200:203], v[120:123], v3, v212 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:760
		scratch_load_dword v201, off, s46 offset:764
		scratch_load_dword v202, off, s46 offset:768
		scratch_load_dword v203, off, s46 offset:772
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:976
		scratch_load_dword v205, off, s46 offset:980
		scratch_load_dword v206, off, s46 offset:984
		scratch_load_dword v207, off, s46 offset:988
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[204:207], v[200:203], v[124:127], v3, v212 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:568
		scratch_load_dword v201, off, s46 offset:572
		scratch_load_dword v202, off, s46 offset:576
		scratch_load_dword v203, off, s46 offset:580
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:944
		scratch_load_dword v205, off, s46 offset:948
		scratch_load_dword v206, off, s46 offset:952
		scratch_load_dword v207, off, s46 offset:956
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[204:207], v[200:203], v[128:131], v8, v10 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:664
		scratch_load_dword v201, off, s46 offset:668
		scratch_load_dword v202, off, s46 offset:672
		scratch_load_dword v203, off, s46 offset:676
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:944
		scratch_load_dword v205, off, s46 offset:948
		scratch_load_dword v206, off, s46 offset:952
		scratch_load_dword v207, off, s46 offset:956
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[204:207], v[200:203], v[132:135], v8, v10 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:632
		scratch_load_dword v201, off, s46 offset:636
		scratch_load_dword v202, off, s46 offset:640
		scratch_load_dword v203, off, s46 offset:644
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:944
		scratch_load_dword v205, off, s46 offset:948
		scratch_load_dword v206, off, s46 offset:952
		scratch_load_dword v207, off, s46 offset:956
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[204:207], v[200:203], v[136:139], v8, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:944
		scratch_load_dword v201, off, s46 offset:948
		scratch_load_dword v202, off, s46 offset:952
		scratch_load_dword v203, off, s46 offset:956
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[200:203], v[192:195], v[140:143], v8, v67 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:728
		scratch_load_dword v201, off, s46 offset:732
		scratch_load_dword v202, off, s46 offset:736
		scratch_load_dword v203, off, s46 offset:740
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:944
		scratch_load_dword v205, off, s46 offset:948
		scratch_load_dword v206, off, s46 offset:952
		scratch_load_dword v207, off, s46 offset:956
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[204:207], v[200:203], v[144:147], v8, v199 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:696
		scratch_load_dword v201, off, s46 offset:700
		scratch_load_dword v202, off, s46 offset:704
		scratch_load_dword v203, off, s46 offset:708
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:944
		scratch_load_dword v205, off, s46 offset:948
		scratch_load_dword v206, off, s46 offset:952
		scratch_load_dword v207, off, s46 offset:956
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[204:207], v[200:203], v[148:151], v8, v199 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:792
		scratch_load_dword v201, off, s46 offset:796
		scratch_load_dword v202, off, s46 offset:800
		scratch_load_dword v203, off, s46 offset:804
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:944
		scratch_load_dword v205, off, s46 offset:948
		scratch_load_dword v206, off, s46 offset:952
		scratch_load_dword v207, off, s46 offset:956
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[204:207], v[200:203], v[152:155], v8, v212 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:760
		scratch_load_dword v201, off, s46 offset:764
		scratch_load_dword v202, off, s46 offset:768
		scratch_load_dword v203, off, s46 offset:772
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:944
		scratch_load_dword v205, off, s46 offset:948
		scratch_load_dword v206, off, s46 offset:952
		scratch_load_dword v207, off, s46 offset:956
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[204:207], v[200:203], v[156:159], v8, v212 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:568
		scratch_load_dword v201, off, s46 offset:572
		scratch_load_dword v202, off, s46 offset:576
		scratch_load_dword v203, off, s46 offset:580
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:600
		scratch_load_dword v205, off, s46 offset:604
		scratch_load_dword v206, off, s46 offset:608
		scratch_load_dword v207, off, s46 offset:612
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[204:207], v[200:203], v[160:163], v8, v10 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:600
		scratch_load_dword v201, off, s46 offset:604
		scratch_load_dword v202, off, s46 offset:608
		scratch_load_dword v203, off, s46 offset:612
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:664
		scratch_load_dword v205, off, s46 offset:668
		scratch_load_dword v206, off, s46 offset:672
		scratch_load_dword v207, off, s46 offset:676
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[200:203], v[204:207], v[164:167], v8, v10 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:600
		scratch_load_dword v201, off, s46 offset:604
		scratch_load_dword v202, off, s46 offset:608
		scratch_load_dword v203, off, s46 offset:612
		s_mov_b32 s46, 0
		scratch_load_dword v204, off, s46 offset:632
		scratch_load_dword v205, off, s46 offset:636
		scratch_load_dword v206, off, s46 offset:640
		scratch_load_dword v207, off, s46 offset:644
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[200:203], v[204:207], v[168:171], v8, v67 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:600
		scratch_load_dword v201, off, s46 offset:604
		scratch_load_dword v202, off, s46 offset:608
		scratch_load_dword v203, off, s46 offset:612
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[200:203], v[192:195], v[172:175], v8, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v192, off, s46 offset:600
		scratch_load_dword v193, off, s46 offset:604
		scratch_load_dword v194, off, s46 offset:608
		scratch_load_dword v195, off, s46 offset:612
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:728
		scratch_load_dword v201, off, s46 offset:732
		scratch_load_dword v202, off, s46 offset:736
		scratch_load_dword v203, off, s46 offset:740
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[192:195], v[200:203], v[176:179], v8, v199 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v192, off, s46 offset:600
		scratch_load_dword v193, off, s46 offset:604
		scratch_load_dword v194, off, s46 offset:608
		scratch_load_dword v195, off, s46 offset:612
		s_mov_b32 s46, 0
		scratch_load_dword v200, off, s46 offset:696
		scratch_load_dword v201, off, s46 offset:700
		scratch_load_dword v202, off, s46 offset:704
		scratch_load_dword v203, off, s46 offset:708
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[192:195], v[200:203], v[180:183], v8, v199 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v192, off, s46 offset:600
		scratch_load_dword v193, off, s46 offset:604
		scratch_load_dword v194, off, s46 offset:608
		scratch_load_dword v195, off, s46 offset:612
		s_mov_b32 s46, 0
		scratch_load_dword v196, off, s46 offset:792
		scratch_load_dword v197, off, s46 offset:796
		scratch_load_dword v198, off, s46 offset:800
		scratch_load_dword v199, off, s46 offset:804
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[192:195], v[196:199], v[184:187], v8, v212 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s46, 0
		scratch_load_dword v192, off, s46 offset:600
		scratch_load_dword v193, off, s46 offset:604
		scratch_load_dword v194, off, s46 offset:608
		scratch_load_dword v195, off, s46 offset:612
		s_mov_b32 s46, 0
		scratch_load_dword v196, off, s46 offset:760
		scratch_load_dword v197, off, s46 offset:764
		scratch_load_dword v198, off, s46 offset:768
		scratch_load_dword v199, off, s46 offset:772
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[192:195], v[196:199], v[188:191], v8, v212 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s11, s11, 2
		v_readfirstlane_b32 s46, v2
		s_cmp_lt_i32 s11, s46
		s_mov_b32 s46, 0
		s_nop 2
		scratch_load_dword v192, off, s46 offset:280
		scratch_load_dword v193, off, s46 offset:284
		scratch_load_dword v194, off, s46 offset:288
		scratch_load_dword v195, off, s46 offset:292
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v28, v192
		v_mov_b32_e32 v29, v193
		v_mov_b32_e32 v30, v194
		v_mov_b32_e32 v31, v195
		s_mov_b32 s46, 0
		scratch_load_dword v3, off, s46 offset:260
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v9, v3
		s_mov_b32 s46, 0
		scratch_load_dword v3, off, s46 offset:256
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v12, v3
		s_mov_b32 s46, 0
		scratch_load_dword v3, off, s46 offset:252
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v14, v3
		s_mov_b32 s46, 0
		scratch_load_dword v3, off, s46 offset:248
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v15, v3
		s_mov_b32 s46, 0
		scratch_load_dword v3, off, s46 offset:244
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v65, v3
		s_mov_b32 s46, 0
		scratch_load_dword v3, off, s46 offset:240
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v66, v3
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
		s_mov_b32 s0, 0
		scratch_load_dword v1, off, s0 offset:808
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
		.amdhsa_private_segment_fixed_size 992
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
		.amdhsa_next_free_vgpr 249
		.amdhsa_next_free_sgpr 49
		.amdhsa_accum_offset 248
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
	.set .Lwmma_f16_matmul_tiled.num_vgpr, 248
	.set .Lwmma_f16_matmul_tiled.num_agpr, 1
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 49
	.set .Lwmma_f16_matmul_tiled.num_named_barrier, 0
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 992
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
    .private_segment_fixed_size: 992
    .sgpr_count:     49
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     249
    .agpr_count:     1
    .vgpr_spill_count: 248
    .wavefront_size: 64
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
