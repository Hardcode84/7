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
		s_add_i32 m0, m0, 0x2000
		v_add3_u32 v8, v6, v8, s10
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		v_add_u32_e32 v7, s11, v9
		s_add_i32 m0, m0, 0x2000
		v_add3_u32 v10, v9, s10, 64
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		v_add_u32_e32 v3, s16, v9
		s_add_i32 m0, m0, 0x2000
		v_add_u32_e32 v9, v2, v5
		buffer_load_dwordx4 v8, s[0:3], 0 offen lds
		v_add_u32_e32 v8, v2, v5
		s_add_i32 m0, m0, 0x2000
		v_and_b32_e32 v1, 1, v1
		buffer_load_dwordx4 v7, s[0:3], 0 offen lds
		v_lshrrev_b32_e32 v7, 4, v4
		s_add_i32 m0, m0, 0x2000
		s_and_b32 s8, s17, 1
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		v_lshlrev_b32_e32 v4, 2, v4
		s_add_i32 m0, m0, 0x2000
		s_lshl_b32 s9, s14, 16
		buffer_load_dwordx4 v3, s[0:3], 0 offen lds
		s_add_i32 s11, s5, s9
		v_lshrrev_b32_e32 v3, 7, v0
		v_lshlrev_b32_e32 v10, 9, v3
		s_lshr_b32 s4, s4, 7
		s_lshl_b32 s16, s4, 9
		s_add_i32 s4, s5, 0x100
		s_add_i32 s4, s4, s9
		v_and_b32_e32 v11, 0x7f, v0
		s_lshl_b32 s8, s8, 10
		s_add_i32 m0, s16, 0x26000
		v_add3_u32 v16, s11, v10, v4
		buffer_load_dword v16, s[24:27], 0 offen lds
		v_add3_u32 v16, s4, v10, v4
		s_add_i32 m0, m0, 0x100
		v_lshl_add_u32 v17, v11, 4, s11
		buffer_load_dword v16, s[24:27], 0 offen lds
		s_add_i32 s4, s8, 0x800
		v_lshlrev_b32_e32 v3, 12, v3
		s_add_i32 m0, s8, 0x26800
		s_nop 0
		buffer_load_dwordx4 v17, s[28:31], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		v_and_b32_e32 v16, 15, v0
		v_lshlrev_b32_e32 v17, 6, v16
		v_lshrrev_b32_e32 v16, 1, v16
		v_bitop3_b32 v7, v7, v16, 3 bitop3:0x78
		v_lshlrev_b32_e32 v7, 4, v7
		v_add3_u32 v3, v3, v17, v7
		v_add_u32_e32 v3, 0x6000, v3
		ds_read_b128 v[20:23], v3
		ds_read_b128 v[24:27], v3 offset:1024
		ds_read_b128 v[28:31], v3 offset:2048
		ds_read_b128 v[32:35], v3 offset:3072
		v_lshlrev_b32_e32 v3, 13, v1
		v_add3_u32 v3, v17, v3, v7
		v_add_u32_e32 v3, 0x6000, v3
		ds_read_b128 v[16:19], v3 offset:32768
		ds_read_b128 v[36:39], v3 offset:33792
		ds_read_b128 v[40:43], v3 offset:34816
		ds_read_b128 v[44:47], v3 offset:35840
		ds_read_b128 v[48:51], v3 offset:36864
		ds_read_b128 v[52:55], v3 offset:37888
		ds_read_b128 v[56:59], v3 offset:38912
		ds_read_b128 v[60:63], v3 offset:39936
		v_add_u32_e32 v3, 0x20000, v10
		v_add_u32_e32 v3, v3, v4
		v_add_u32_e32 v3, 0x6000, v3
		ds_read_b32 v7, v3
		ds_read_b32 v64, v3 offset:256
		v_add_u32_e32 v3, 0x20000, v4
		v_lshlrev_b32_e32 v1, 10, v1
		v_add_u32_e32 v1, v3, v1
		v_add_u32_e32 v1, 0x6000, v1
		ds_read_b32 v3, v1 offset:2048
		ds_read_b32 v65, v1 offset:2304
		ds_read_b32 v66, v1 offset:2560
		ds_read_b32 v67, v1 offset:2816
		s_add_i32 s11, s5, 0x80
		v_add_u32_e32 v1, s11, v2
		s_add_i32 s11, s5, 0x80080
		v_add_u32_e32 v2, s11, v2
		s_add_i32 s11, s5, 0xc0
		s_add_i32 s32, s5, 0x800c0
		s_add_i32 s33, s10, 0x80
		s_add_i32 s34, s10, 0x80080
		s_add_i32 s35, s10, 0xc0
		s_add_i32 s10, s10, 0x800c0
		s_add_i32 m0, s19, 0x16000
		v_add3_u32 v1, v1, v5, v6
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		v_add3_u32 v1, v2, v5, v6
		s_add_i32 m0, m0, 0x2000
		v_add3_u32 v2, v6, v8, s11
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		v_add3_u32 v1, v6, v8, s32
		s_add_i32 m0, m0, 0x2000
		v_add3_u32 v5, v6, v8, s33
		buffer_load_dwordx4 v2, s[20:23], 0 offen lds
		v_add3_u32 v2, v6, v9, s34
		s_add_i32 m0, m0, 0x2000
		v_add3_u32 v8, v6, v9, s35
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		v_add3_u32 v1, v6, v9, s10
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s10, s19, 0x10000
		buffer_load_dwordx4 v5, s[0:3], 0 offen lds
		s_mov_b32 s32, 0x100000
		s_mov_b32 s33, 0
		s_add_i32 m0, m0, 0x2000
		v_mov_b32_e32 v69, 0
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		v_mov_b32_e32 v68, s13
		s_add_i32 m0, m0, 0x2000
		s_mov_b32 s11, 2
		buffer_load_dwordx4 v8, s[0:3], 0 offen lds
		s_add_i32 s34, s12, 1
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s35, s5, 0x800
		buffer_load_dwordx4 v1, s[0:3], 0 offen lds
		s_add_i32 s35, s35, s9
		s_add_i32 s5, s5, 0x900
		s_add_i32 s5, s5, s9
		s_add_i32 m0, s16, 0x27000
		v_add3_u32 v1, s35, v10, v4
		buffer_load_dword v1, s[24:27], 0 offen lds
		s_add_i32 s9, s16, 0x1000
		s_add_i32 m0, m0, 0x100
		v_add3_u32 v1, s5, v10, v4
		buffer_load_dword v1, s[24:27], 0 offen lds
		v_lshl_add_u32 v1, v11, 4, s35
		s_add_i32 s5, s8, 0x1800
		s_add_i32 m0, s8, 0x27800
		s_nop 0
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		v_mov_b32_e32 v4, s32
		v_mov_b32_e32 v5, s33
		v_mul_lo_u32 v8, v4, v68
		v_mul_hi_u32 v9, v4, v68
		v_mul_lo_u32 v1, v4, v69
		v_add_u32_e32 v9, v9, v1
		v_mul_lo_u32 v1, v5, v68
		v_add_u32_e32 v9, v9, v1
		s_mov_b32 s32, 1
		s_mov_b32 s33, 0
		v_mov_b32_e32 v10, v0
		v_mov_b32_e32 v70, s32
		v_mov_b32_e32 v71, s33
		v_mov_b32_e32 v11, 0
		v_mul_lo_u32 v72, v70, v10
		v_mul_hi_u32 v73, v70, v10
		v_mul_lo_u32 v1, v70, v11
		v_add_u32_e32 v73, v73, v1
		v_mul_lo_u32 v1, v71, v10
		v_add_u32_e32 v73, v73, v1
		v_lshrrev_b64 v[74:75], 6, v[72:73]
		s_mov_b32 s32, 0x10000
		s_mov_b32 s33, 0
		v_mov_b32_e32 v76, s32
		v_mov_b32_e32 v77, s33
		v_mul_lo_u32 v78, v76, v74
		v_mul_hi_u32 v79, v76, v74
		v_mul_lo_u32 v1, v76, v75
		v_add_u32_e32 v79, v79, v1
		v_mul_lo_u32 v1, v77, v74
		v_add_u32_e32 v79, v79, v1
		v_add_co_u32_e64 v74, vcc, v8, v78
		v_addc_co_u32_e64 v75, vcc, v9, v79, vcc
		v_mov_b32_e32 v1, 63
		v_and_b32_e32 v80, v10, v1
		v_and_b32_e32 v81, v69, v69
		v_mul_lo_u32 v82, v70, v80
		v_mul_hi_u32 v83, v70, v80
		v_mul_lo_u32 v1, v70, v81
		v_add_u32_e32 v83, v83, v1
		v_mul_lo_u32 v1, v71, v80
		v_add_u32_e32 v83, v83, v1
		v_lshrrev_b64 v[70:71], 2, v[82:83]
		s_mov_b32 s32, 0x1000
		s_mov_b32 s33, 0
		v_mov_b32_e32 v84, s32
		v_mov_b32_e32 v85, s33
		v_mul_lo_u32 v86, v84, v70
		v_mul_hi_u32 v87, v84, v70
		v_mul_lo_u32 v1, v84, v71
		v_add_u32_e32 v87, v87, v1
		v_mul_lo_u32 v1, v85, v70
		v_add_u32_e32 v87, v87, v1
		v_add_co_u32_e64 v70, vcc, v74, v86
		v_addc_co_u32_e64 v71, vcc, v75, v87, vcc
		v_lshrrev_b64 v[74:75], 3, v[82:83]
		v_mov_b32_e32 v1, 3
		v_and_b32_e32 v82, v74, v1
		v_and_b32_e32 v83, v75, v69
		v_and_b32_e32 v74, v80, v1
		v_and_b32_e32 v75, v81, v69
		v_xor_b32_e32 v68, v82, v74
		v_xor_b32_e32 v69, v83, v75
		s_mov_b32 s32, 16
		s_mov_b32 s33, 0
		v_mov_b32_e32 v74, s32
		v_mov_b32_e32 v75, s33
		v_mul_lo_u32 v82, v74, v68
		v_mul_hi_u32 v83, v74, v68
		v_mul_lo_u32 v1, v74, v69
		v_add_u32_e32 v83, v83, v1
		v_mul_lo_u32 v1, v75, v68
		v_add_u32_e32 v83, v83, v1
		v_add_co_u32_e64 v68, vcc, v70, v82
		v_addc_co_u32_e64 v69, vcc, v71, v83, vcc
		s_mov_b32 s32, 0x80
		s_mov_b32 s33, 0
		v_mov_b32_e32 v70, s32
		v_mov_b32_e32 v71, s33
		v_mov_b32_e32 v1, 0x80000
		v_add_co_u32_e64 v84, vcc, v8, v1
		v_addc_co_u32_e64 v85, vcc, v9, 0, vcc
		v_add_co_u32_e64 v88, vcc, v84, v78
		v_addc_co_u32_e64 v89, vcc, v85, v79, vcc
		v_add_co_u32_e64 v84, vcc, v88, v86
		v_addc_co_u32_e64 v85, vcc, v89, v87, vcc
		v_add_co_u32_e64 v88, vcc, v84, v82
		v_addc_co_u32_e64 v89, vcc, v85, v83, vcc
		v_mov_b32_e32 v2, 64
		v_add_co_u32_e64 v84, vcc, v8, v2
		v_addc_co_u32_e64 v85, vcc, v9, 0, vcc
		v_add_co_u32_e64 v90, vcc, v84, v78
		v_addc_co_u32_e64 v91, vcc, v85, v79, vcc
		v_add_co_u32_e64 v84, vcc, v90, v86
		v_addc_co_u32_e64 v85, vcc, v91, v87, vcc
		v_add_co_u32_e64 v90, vcc, v84, v82
		v_addc_co_u32_e64 v91, vcc, v85, v83, vcc
		v_mov_b32_e32 v6, 0x80040
		v_add_co_u32_e64 v84, vcc, v8, v6
		v_addc_co_u32_e64 v85, vcc, v9, 0, vcc
		v_add_co_u32_e64 v92, vcc, v84, v78
		v_addc_co_u32_e64 v93, vcc, v85, v79, vcc
		v_add_co_u32_e64 v84, vcc, v92, v86
		v_addc_co_u32_e64 v85, vcc, v93, v87, vcc
		v_add_co_u32_e64 v92, vcc, v84, v82
		v_addc_co_u32_e64 v93, vcc, v85, v83, vcc
		v_mov_b32_e32 v84, s14
		v_mov_b32_e32 v85, 0
		v_mul_lo_u32 v94, v4, v84
		v_mul_hi_u32 v95, v4, v84
		v_mul_lo_u32 v11, v4, v85
		v_add_u32_e32 v95, v95, v11
		v_mul_lo_u32 v11, v5, v84
		v_add_u32_e32 v95, v95, v11
		v_add_co_u32_e64 v4, vcc, v94, v78
		v_addc_co_u32_e64 v5, vcc, v95, v79, vcc
		v_add_co_u32_e64 v96, vcc, v4, v86
		v_addc_co_u32_e64 v97, vcc, v5, v87, vcc
		v_add_co_u32_e64 v4, vcc, v96, v82
		v_addc_co_u32_e64 v5, vcc, v97, v83, vcc
		v_add_co_u32_e64 v96, vcc, v94, v1
		v_addc_co_u32_e64 v97, vcc, v95, 0, vcc
		v_add_co_u32_e64 v98, vcc, v96, v78
		v_addc_co_u32_e64 v99, vcc, v97, v79, vcc
		v_add_co_u32_e64 v96, vcc, v98, v86
		v_addc_co_u32_e64 v97, vcc, v99, v87, vcc
		v_add_co_u32_e64 v98, vcc, v96, v82
		v_addc_co_u32_e64 v99, vcc, v97, v83, vcc
		v_add_co_u32_e64 v96, vcc, v94, v2
		v_addc_co_u32_e64 v97, vcc, v95, 0, vcc
		v_add_co_u32_e64 v100, vcc, v96, v78
		v_addc_co_u32_e64 v101, vcc, v97, v79, vcc
		v_add_co_u32_e64 v96, vcc, v100, v86
		v_addc_co_u32_e64 v97, vcc, v101, v87, vcc
		v_add_co_u32_e64 v100, vcc, v96, v82
		v_addc_co_u32_e64 v101, vcc, v97, v83, vcc
		v_add_co_u32_e64 v96, vcc, v94, v6
		v_addc_co_u32_e64 v97, vcc, v95, 0, vcc
		v_add_co_u32_e64 v102, vcc, v96, v78
		v_addc_co_u32_e64 v103, vcc, v97, v79, vcc
		v_add_co_u32_e64 v96, vcc, v102, v86
		v_addc_co_u32_e64 v97, vcc, v103, v87, vcc
		v_add_co_u32_e64 v102, vcc, v96, v82
		v_addc_co_u32_e64 v103, vcc, v97, v83, vcc
		v_mul_lo_u32 v96, v76, v84
		v_mul_hi_u32 v97, v76, v84
		v_mul_lo_u32 v1, v76, v85
		v_add_u32_e32 v97, v97, v1
		v_mul_lo_u32 v1, v77, v84
		v_add_u32_e32 v97, v97, v1
		v_add_co_u32_e64 v76, vcc, v8, v96
		v_addc_co_u32_e64 v77, vcc, v9, v97, vcc
		v_lshrrev_b64 v[84:85], 7, v[72:73]
		s_mov_b32 s32, 0x200
		s_mov_b32 s33, 0
		v_mov_b32_e32 v72, s32
		v_mov_b32_e32 v73, s33
		v_mul_lo_u32 v104, v72, v84
		v_mul_hi_u32 v105, v72, v84
		v_mul_lo_u32 v1, v72, v85
		v_add_u32_e32 v105, v105, v1
		v_mul_lo_u32 v1, v73, v84
		v_add_u32_e32 v105, v105, v1
		v_add_co_u32_e64 v72, vcc, v76, v104
		v_addc_co_u32_e64 v73, vcc, v77, v105, vcc
		s_mov_b32 s32, 4
		s_mov_b32 s33, 0
		v_mov_b32_e32 v84, s32
		v_mov_b32_e32 v85, s33
		v_mul_lo_u32 v106, v84, v80
		v_mul_hi_u32 v107, v84, v80
		v_mul_lo_u32 v1, v84, v81
		v_add_u32_e32 v107, v107, v1
		v_mul_lo_u32 v1, v85, v80
		v_add_u32_e32 v107, v107, v1
		v_add_co_u32_e64 v84, vcc, v72, v106
		v_addc_co_u32_e64 v85, vcc, v73, v107, vcc
		s_mov_b32 s32, 0x800
		s_mov_b32 s33, 0
		v_mov_b32_e32 v1, 0x100
		v_add_co_u32_e64 v72, vcc, v8, v1
		v_addc_co_u32_e64 v73, vcc, v9, 0, vcc
		v_add_co_u32_e64 v108, vcc, v72, v96
		v_addc_co_u32_e64 v109, vcc, v73, v97, vcc
		v_add_co_u32_e64 v72, vcc, v108, v104
		v_addc_co_u32_e64 v73, vcc, v109, v105, vcc
		v_add_co_u32_e64 v108, vcc, v72, v106
		v_addc_co_u32_e64 v109, vcc, v73, v107, vcc
		v_mov_b32_e32 v1, 0x7f
		v_and_b32_e32 v72, v10, v1
		v_mov_b32_e32 v73, v81
		v_mul_lo_u32 v10, v74, v72
		v_mul_hi_u32 v11, v74, v72
		v_mul_lo_u32 v1, v74, v73
		v_add_u32_e32 v11, v11, v1
		v_mul_lo_u32 v1, v75, v72
		v_add_u32_e32 v11, v11, v1
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v72, vcc, v76, v10
		v_addc_co_u32_e64 v73, vcc, v77, v11, vcc
		ds_write_addtid_b32 v72
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v73 offset:2048
		v_mov_b32_e32 v1, 0x80
		v_add_co_u32_e64 v72, vcc, v8, v1
		v_addc_co_u32_e64 v73, vcc, v9, 0, vcc
		v_add_co_u32_e64 v74, vcc, v72, v78
		v_addc_co_u32_e64 v75, vcc, v73, v79, vcc
		v_add_co_u32_e64 v72, vcc, v74, v86
		v_addc_co_u32_e64 v73, vcc, v75, v87, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v74, vcc, v72, v82
		v_addc_co_u32_e64 v75, vcc, v73, v83, vcc
		ds_write_addtid_b32 v74 offset:4096
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v75 offset:6144
		v_mov_b32_e32 v2, 0x80080
		v_add_co_u32_e64 v72, vcc, v8, v2
		v_addc_co_u32_e64 v73, vcc, v9, 0, vcc
		v_add_co_u32_e64 v74, vcc, v72, v78
		v_addc_co_u32_e64 v75, vcc, v73, v79, vcc
		v_add_co_u32_e64 v72, vcc, v74, v86
		v_addc_co_u32_e64 v73, vcc, v75, v87, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v74, vcc, v72, v82
		v_addc_co_u32_e64 v75, vcc, v73, v83, vcc
		ds_write_addtid_b32 v74 offset:8192
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v75 offset:10240
		v_mov_b32_e32 v6, 0xc0
		v_add_co_u32_e64 v72, vcc, v8, v6
		v_addc_co_u32_e64 v73, vcc, v9, 0, vcc
		v_add_co_u32_e64 v74, vcc, v72, v78
		v_addc_co_u32_e64 v75, vcc, v73, v79, vcc
		v_add_co_u32_e64 v72, vcc, v74, v86
		v_addc_co_u32_e64 v73, vcc, v75, v87, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v74, vcc, v72, v82
		v_addc_co_u32_e64 v75, vcc, v73, v83, vcc
		ds_write_addtid_b32 v74 offset:14336
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v75 offset:16384
		v_mov_b32_e32 v72, 0x800c0
		v_add_co_u32_e64 v74, vcc, v8, v72
		v_addc_co_u32_e64 v75, vcc, v9, 0, vcc
		v_add_co_u32_e64 v76, vcc, v74, v78
		v_addc_co_u32_e64 v77, vcc, v75, v79, vcc
		v_add_co_u32_e64 v74, vcc, v76, v86
		v_addc_co_u32_e64 v75, vcc, v77, v87, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v76, vcc, v74, v82
		v_addc_co_u32_e64 v77, vcc, v75, v83, vcc
		ds_write_addtid_b32 v76 offset:18432
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v77 offset:20480
		v_add_co_u32_e64 v74, vcc, v94, v1
		v_addc_co_u32_e64 v75, vcc, v95, 0, vcc
		v_add_co_u32_e64 v76, vcc, v74, v78
		v_addc_co_u32_e64 v77, vcc, v75, v79, vcc
		v_add_co_u32_e64 v74, vcc, v76, v86
		v_addc_co_u32_e64 v75, vcc, v77, v87, vcc
		v_add_co_u32_e64 v76, vcc, v74, v82
		v_addc_co_u32_e64 v77, vcc, v75, v83, vcc
		s_mov_b32 s8, 0
		scratch_store_dword off, v76, s8
		scratch_store_dword off, v77, s8 offset:4
		v_add_co_u32_e64 v74, vcc, v94, v2
		v_addc_co_u32_e64 v75, vcc, v95, 0, vcc
		v_add_co_u32_e64 v76, vcc, v74, v78
		v_addc_co_u32_e64 v77, vcc, v75, v79, vcc
		v_add_co_u32_e64 v74, vcc, v76, v86
		v_addc_co_u32_e64 v75, vcc, v77, v87, vcc
		v_add_co_u32_e64 v76, vcc, v74, v82
		v_addc_co_u32_e64 v77, vcc, v75, v83, vcc
		s_mov_b32 s8, 0
		scratch_store_dword off, v76, s8 offset:8
		scratch_store_dword off, v77, s8 offset:12
		v_add_co_u32_e64 v74, vcc, v94, v6
		v_addc_co_u32_e64 v75, vcc, v95, 0, vcc
		v_add_co_u32_e64 v76, vcc, v74, v78
		v_addc_co_u32_e64 v77, vcc, v75, v79, vcc
		v_add_co_u32_e64 v74, vcc, v76, v86
		v_addc_co_u32_e64 v75, vcc, v77, v87, vcc
		v_add_co_u32_e64 v76, vcc, v74, v82
		v_addc_co_u32_e64 v77, vcc, v75, v83, vcc
		s_mov_b32 s8, 0
		scratch_store_dword off, v76, s8 offset:16
		scratch_store_dword off, v77, s8 offset:20
		v_add_co_u32_e64 v74, vcc, v94, v72
		v_addc_co_u32_e64 v75, vcc, v95, 0, vcc
		v_add_co_u32_e64 v72, vcc, v74, v78
		v_addc_co_u32_e64 v73, vcc, v75, v79, vcc
		v_add_co_u32_e64 v74, vcc, v72, v86
		v_addc_co_u32_e64 v75, vcc, v73, v87, vcc
		v_add_co_u32_e64 v72, vcc, v74, v82
		v_addc_co_u32_e64 v73, vcc, v75, v83, vcc
		s_mov_b32 s8, 0
		scratch_store_dword off, v72, s8 offset:24
		scratch_store_dword off, v73, s8 offset:28
		v_mov_b32_e32 v1, 0x800
		v_add_co_u32_e64 v72, vcc, v8, v1
		v_addc_co_u32_e64 v73, vcc, v9, 0, vcc
		v_add_co_u32_e64 v74, vcc, v72, v96
		v_addc_co_u32_e64 v75, vcc, v73, v97, vcc
		v_add_co_u32_e64 v72, vcc, v74, v104
		v_addc_co_u32_e64 v73, vcc, v75, v105, vcc
		v_add_co_u32_e64 v76, vcc, v72, v106
		v_addc_co_u32_e64 v77, vcc, v73, v107, vcc
		s_mov_b32 s8, 0
		scratch_store_dword off, v76, s8 offset:32
		scratch_store_dword off, v77, s8 offset:36
		v_mov_b32_e32 v1, 0x900
		v_add_co_u32_e64 v72, vcc, v8, v1
		v_addc_co_u32_e64 v73, vcc, v9, 0, vcc
		v_add_co_u32_e64 v8, vcc, v72, v96
		v_addc_co_u32_e64 v9, vcc, v73, v97, vcc
		v_add_co_u32_e64 v72, vcc, v8, v104
		v_addc_co_u32_e64 v73, vcc, v9, v105, vcc
		v_add_co_u32_e64 v8, vcc, v72, v106
		v_addc_co_u32_e64 v9, vcc, v73, v107, vcc
		s_mov_b32 s8, 0
		scratch_store_dword off, v8, s8 offset:40
		scratch_store_dword off, v9, s8 offset:44
		v_add_co_u32_e64 v8, vcc, v74, v10
		v_addc_co_u32_e64 v9, vcc, v75, v11, vcc
		s_mov_b32 s8, 0
		scratch_store_dword off, v8, s8 offset:48
		scratch_store_dword off, v9, s8 offset:52
		v_mov_b32_e32 v8, s11
		v_mov_b32_e32 v9, 0
		v_mov_b64_e32 v[72:73], 0
		v_mov_b64_e32 v[74:75], 0
		v_mov_b64_e32 v[76:77], 0
		v_mov_b64_e32 v[78:79], 0
		v_mov_b64_e32 v[80:81], 0
		v_mov_b64_e32 v[82:83], 0
		v_mov_b64_e32 v[104:105], 0
		v_mov_b64_e32 v[106:107], 0
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
		v_mov_b64_e32 v[216:217], 0
		v_mov_b64_e32 v[218:219], 0
.Lwmma_f16_matmul_tiled.loop_head_0:
		v_mov_b32_e32 v8, s11
		v_mul_lo_u32 v10, v70, v8
		v_mul_hi_u32 v11, v70, v8
		v_mul_lo_u32 v1, v70, v9
		v_add_u32_e32 v11, v11, v1
		v_mul_lo_u32 v1, v71, v8
		v_add_u32_e32 v11, v11, v1
		v_add_co_u32_e64 v86, vcc, v68, v10
		v_addc_co_u32_e64 v87, vcc, v69, v11, vcc
		s_mov_b32 s8, 0
		scratch_store_dword off, v86, s8 offset:56
		scratch_store_dword off, v87, s8 offset:60
		v_add_co_u32_e64 v86, vcc, v88, v10
		v_addc_co_u32_e64 v87, vcc, v89, v11, vcc
		s_mov_b32 s8, 0
		scratch_store_dword off, v86, s8 offset:64
		scratch_store_dword off, v87, s8 offset:68
		v_add_co_u32_e64 v86, vcc, v90, v10
		v_addc_co_u32_e64 v87, vcc, v91, v11, vcc
		s_mov_b32 s8, 0
		scratch_store_dword off, v86, s8 offset:72
		scratch_store_dword off, v87, s8 offset:76
		v_add_co_u32_e64 v86, vcc, v92, v10
		v_addc_co_u32_e64 v87, vcc, v93, v11, vcc
		s_mov_b32 s8, 0
		scratch_store_dword off, v86, s8 offset:80
		scratch_store_dword off, v87, s8 offset:84
		v_add_co_u32_e64 v86, vcc, v4, v10
		v_addc_co_u32_e64 v87, vcc, v5, v11, vcc
		s_mov_b32 s8, 0
		scratch_store_dword off, v86, s8 offset:88
		scratch_store_dword off, v87, s8 offset:92
		v_add_co_u32_e64 v86, vcc, v98, v10
		v_addc_co_u32_e64 v87, vcc, v99, v11, vcc
		s_mov_b32 s8, 0
		scratch_store_dword off, v86, s8 offset:96
		scratch_store_dword off, v87, s8 offset:100
		v_add_co_u32_e64 v86, vcc, v100, v10
		v_addc_co_u32_e64 v87, vcc, v101, v11, vcc
		s_mov_b32 s8, 0
		scratch_store_dword off, v86, s8 offset:104
		scratch_store_dword off, v87, s8 offset:108
		v_add_co_u32_e64 v86, vcc, v102, v10
		v_addc_co_u32_e64 v87, vcc, v103, v11, vcc
		s_mov_b32 s8, 0
		scratch_store_dword off, v86, s8 offset:112
		scratch_store_dword off, v87, s8 offset:116
		v_mov_b32_e32 v86, s32
		v_mov_b32_e32 v87, s33
		v_mul_lo_u32 v94, v86, v8
		v_mul_hi_u32 v95, v86, v8
		v_mul_lo_u32 v1, v86, v9
		v_add_u32_e32 v95, v95, v1
		v_mul_lo_u32 v1, v87, v8
		v_add_u32_e32 v95, v95, v1
		s_mov_b32 s8, 0
		scratch_store_dword off, v94, s8 offset:152
		scratch_store_dword off, v95, s8 offset:156
		v_add_co_u32_e64 v86, vcc, v84, v94
		v_addc_co_u32_e64 v87, vcc, v85, v95, vcc
		s_mov_b32 s8, 0
		scratch_store_dword off, v86, s8 offset:120
		scratch_store_dword off, v87, s8 offset:124
		v_add_co_u32_e64 v86, vcc, v108, v94
		v_addc_co_u32_e64 v87, vcc, v109, v95, vcc
		s_mov_b32 s8, 0
		scratch_store_dword off, v86, s8 offset:128
		scratch_store_dword off, v87, s8 offset:132
		s_mov_b32 m0, s15
		s_waitcnt lgkmcnt(8)
		s_nop 0
		ds_read_addtid_b32 v86
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v87 offset:2048
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v96, vcc, v86, v94
		v_addc_co_u32_e64 v97, vcc, v87, v95, vcc
		s_mov_b32 s8, 0
		scratch_store_dword off, v96, s8 offset:136
		scratch_store_dword off, v97, s8 offset:140
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[20:23], v[16:19], v[12:15], v7, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s8, s11, 1
		v_lshrrev_b32_e32 v1, 7, v0
		s_mov_b32 m0, s15
		v_lshlrev_b32_e32 v1, 12, v1
		ds_write_addtid_b32 v1 offset:12288
		v_and_b32_e32 v2, 15, v0
		s_mov_b32 m0, s15
		v_lshlrev_b32_e32 v2, 6, v2
		ds_write_addtid_b32 v2 offset:22528
		v_and_b32_e32 v6, 63, v0
		v_lshrrev_b32_e32 v6, 4, v6
		v_and_b32_e32 v86, 15, v0
		v_lshrrev_b32_e32 v86, 1, v86
		v_bitop3_b32 v6, v6, v86, 3 bitop3:0x78
		v_lshlrev_b32_e32 v6, 4, v6
		s_mov_b32 s35, 0
		scratch_store_dword off, v6, s35 offset:148
		s_and_b32 s35, s11, 1
		s_lshl_b32 s35, s35, 16
		v_add_u32_e32 v1, s35, v1
		v_add3_u32 v1, v1, v2, v6
		v_add_u32_e32 v2, 0x6000, v1
		ds_read_b128 v[220:223], v2 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[20:23], v[36:39], v[72:75], v7, v3 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x6000, v1
		s_mov_b32 s35, 0
		scratch_store_dword off, v1, s35 offset:160
		ds_read_b128 v[224:227], v1 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[20:23], v[40:43], v[76:79], v7, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v1 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[20:23], v[44:47], v[80:83], v7, v65 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[232:235], v1 offset:19456
		s_mov_b32 m0, s15
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[20:23], v[48:51], v[104:107], v7, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(4)
		ds_read_addtid_b32 v1 offset:22528
		v_lshrrev_b32_e32 v2, 6, v0
		v_and_b32_e32 v2, 1, v2
		v_lshlrev_b32_e32 v2, 13, v2
		s_mov_b32 s35, 0
		scratch_store_dword off, v2, s35 offset:144
		s_and_b32 s35, s11, 1
		s_lshl_b32 s35, s35, 16
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v1, s35, v1
		v_add3_u32 v1, v1, v2, v6
		v_add_u32_e32 v1, 0x6000, v1
		ds_read_b128 v[236:239], v1 offset:49152
		s_mov_b32 s35, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s35 offset:164
		scratch_store_dword off, v237, s35 offset:168
		scratch_store_dword off, v238, s35 offset:172
		scratch_store_dword off, v239, s35 offset:176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[20:23], v[52:55], v[112:115], v7, v66 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[236:239], v1 offset:50176
		s_mov_b32 s35, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s35 offset:180
		scratch_store_dword off, v237, s35 offset:184
		scratch_store_dword off, v238, s35 offset:188
		scratch_store_dword off, v239, s35 offset:192
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[20:23], v[56:59], v[116:119], v7, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[236:239], v1 offset:51200
		s_mov_b32 s35, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s35 offset:196
		scratch_store_dword off, v237, s35 offset:200
		scratch_store_dword off, v238, s35 offset:204
		scratch_store_dword off, v239, s35 offset:208
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], v[60:63], v[120:123], v7, v67 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v1 offset:52224
		s_mov_b32 s35, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v20, s35 offset:212
		scratch_store_dword off, v21, s35 offset:216
		scratch_store_dword off, v22, s35 offset:220
		scratch_store_dword off, v23, s35 offset:224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[24:27], v[16:19], v[124:127], v7, v3 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[236:239], v1 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[24:27], v[36:39], v[128:131], v7, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v1 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[24:27], v[40:43], v[132:135], v7, v65 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[244:247], v1 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[24:27], v[44:47], v[136:139], v7, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v1 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[24:27], v[48:51], v[140:143], v7, v66 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s19, 0x6000
		s_mov_b32 s35, 0
		s_waitcnt vmcnt(41)
		scratch_load_dword v20, off, s35 offset:56
		scratch_load_dword v21, off, s35 offset:60
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v20, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[52:55], v[144:147], v7, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		s_mov_b32 s35, 0
		s_waitcnt vmcnt(39)
		scratch_load_dword v20, off, s35 offset:64
		scratch_load_dword v21, off, s35 offset:68
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v20, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[56:59], v[148:151], v7, v67 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		s_mov_b32 s35, 0
		s_waitcnt vmcnt(37)
		scratch_load_dword v20, off, s35 offset:72
		scratch_load_dword v21, off, s35 offset:76
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v20, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[60:63], v[152:155], v7, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		s_mov_b32 s35, 0
		s_waitcnt vmcnt(35)
		scratch_load_dword v20, off, s35 offset:80
		scratch_load_dword v21, off, s35 offset:84
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v20, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[28:31], v[16:19], v[156:159], v64, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		s_mov_b32 s35, 0
		s_waitcnt vmcnt(33)
		scratch_load_dword v20, off, s35 offset:88
		scratch_load_dword v21, off, s35 offset:92
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v20, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[28:31], v[36:39], v[160:163], v64, v3 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		s_mov_b32 s35, 0
		s_waitcnt vmcnt(31)
		scratch_load_dword v20, off, s35 offset:96
		scratch_load_dword v21, off, s35 offset:100
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v20, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[28:31], v[40:43], v[164:167], v64, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		s_mov_b32 s35, 0
		s_waitcnt vmcnt(29)
		scratch_load_dword v20, off, s35 offset:104
		scratch_load_dword v21, off, s35 offset:108
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v20, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[28:31], v[44:47], v[168:171], v64, v65 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		s_mov_b32 s35, 0
		s_waitcnt vmcnt(27)
		scratch_load_dword v20, off, s35 offset:112
		scratch_load_dword v21, off, s35 offset:116
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v20, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[28:31], v[48:51], v[172:175], v64, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s16, 0x26000
		s_mov_b32 s35, 0
		s_waitcnt vmcnt(23)
		scratch_load_dword v20, off, s35 offset:120
		scratch_load_dword v21, off, s35 offset:124
		s_waitcnt vmcnt(0)
		buffer_load_dword v20, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[52:55], v[176:179], v64, v66 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x100
		s_add_i32 s35, s11, 1
		s_mov_b32 s36, 0
		s_waitcnt vmcnt(21)
		scratch_load_dword v20, off, s36 offset:128
		scratch_load_dword v21, off, s36 offset:132
		s_waitcnt vmcnt(0)
		buffer_load_dword v20, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[56:59], v[180:183], v64, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshl_b32 s8, s8, 12
		s_mov_b32 s36, 0
		s_waitcnt vmcnt(19)
		scratch_load_dword v20, off, s36 offset:136
		scratch_load_dword v21, off, s36 offset:140
		s_add_i32 m0, s4, 0x26000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[60:63], v[184:187], v64, v67 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		s_mov_b32 s36, 0
		s_waitcnt vmcnt(17)
		scratch_load_dword v2, off, s36 offset:160
		s_waitcnt vmcnt(0)
		ds_read_b128 v[20:23], v2
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[32:35], v[16:19], v[188:191], v64, v3 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s36, 0
		scratch_load_dword v2, off, s36 offset:160
		s_waitcnt vmcnt(0)
		ds_read_b128 v[24:27], v2 offset:1024
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[32:35], v[36:39], v[192:195], v64, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s36, 0
		scratch_load_dword v2, off, s36 offset:160
		s_waitcnt vmcnt(0)
		ds_read_b128 v[28:31], v2 offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[32:35], v[40:43], v[196:199], v64, v65 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s36, 0
		scratch_load_dword v2, off, s36 offset:160
		s_waitcnt vmcnt(0)
		ds_read_b128 v[16:19], v2 offset:3072
		s_mov_b32 s36, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v16, s36 offset:228
		scratch_store_dword off, v17, s36 offset:232
		scratch_store_dword off, v18, s36 offset:236
		scratch_store_dword off, v19, s36 offset:240
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[32:35], v[44:47], v[200:203], v64, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[16:19], v1 offset:32768
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[32:35], v[48:51], v[204:207], v64, v66 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[36:39], v1 offset:33792
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[52:55], v[208:211], v64, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[40:43], v1 offset:34816
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[56:59], v[212:215], v64, v67 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[44:47], v1 offset:35840
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[60:63], v[216:219], v64, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[48:51], v1 offset:36864
		ds_read_b128 v[52:55], v1 offset:37888
		ds_read_b128 v[56:59], v1 offset:38912
		ds_read_b128 v[60:63], v1 offset:39936
		s_add_i32 s8, s8, 0x20000
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v1, 9, v1
		s_mov_b32 s36, 0
		scratch_store_dword off, v1, s36 offset:244
		v_and_b32_e32 v2, 63, v0
		v_lshlrev_b32_e32 v2, 2, v2
		s_mov_b32 s36, 0
		scratch_store_dword off, v2, s36 offset:276
		v_add3_u32 v1, s8, v1, v2
		v_add_u32_e32 v1, 0x6000, v1
		ds_read_b32 v6, v1
		s_mov_b32 s36, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v6, s36 offset:248
		ds_read_b32 v6, v1 offset:256
		s_mov_b32 s36, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v6, s36 offset:252
		v_lshrrev_b32_e32 v1, 6, v0
		v_and_b32_e32 v1, 1, v1
		v_lshlrev_b32_e32 v1, 10, v1
		s_mov_b32 s36, 0
		scratch_store_dword off, v1, s36 offset:256
		v_add3_u32 v1, s8, v2, v1
		v_add_u32_e32 v1, 0x6000, v1
		ds_read_b32 v2, v1 offset:2048
		s_mov_b32 s8, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s8 offset:260
		ds_read_b32 v2, v1 offset:2304
		s_mov_b32 s8, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s8 offset:264
		ds_read_b32 v2, v1 offset:2560
		s_mov_b32 s8, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s8 offset:268
		ds_read_b32 v2, v1 offset:2816
		s_mov_b32 s8, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v2, s8 offset:272
		s_mov_b32 s8, 0
		s_waitcnt vmcnt(25)
		scratch_load_dword v32, off, s8 offset:164
		scratch_load_dword v33, off, s8 offset:168
		scratch_load_dword v34, off, s8 offset:172
		scratch_load_dword v35, off, s8 offset:176
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[220:223], v[32:35], v[12:15], v7, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		s_waitcnt vmcnt(21)
		scratch_load_dword v32, off, s8 offset:180
		scratch_load_dword v33, off, s8 offset:184
		scratch_load_dword v34, off, s8 offset:188
		scratch_load_dword v35, off, s8 offset:192
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[220:223], v[32:35], v[72:75], v7, v3 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v32, off, s8 offset:180
		scratch_load_dword v33, off, s8 offset:184
		scratch_load_dword v34, off, s8 offset:188
		scratch_load_dword v35, off, s8 offset:192
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[224:227], v[32:35], v[128:131], v7, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v32, off, s8 offset:164
		scratch_load_dword v33, off, s8 offset:168
		scratch_load_dword v34, off, s8 offset:172
		scratch_load_dword v35, off, s8 offset:176
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[224:227], v[32:35], v[124:127], v7, v3 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		s_waitcnt vmcnt(17)
		scratch_load_dword v32, off, s8 offset:196
		scratch_load_dword v33, off, s8 offset:200
		scratch_load_dword v34, off, s8 offset:204
		scratch_load_dword v35, off, s8 offset:208
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[224:227], v[32:35], v[132:135], v7, v65 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v32, off, s8 offset:196
		scratch_load_dword v33, off, s8 offset:200
		scratch_load_dword v34, off, s8 offset:204
		scratch_load_dword v35, off, s8 offset:208
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[220:223], v[32:35], v[76:79], v7, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		s_waitcnt vmcnt(13)
		scratch_load_dword v32, off, s8 offset:212
		scratch_load_dword v33, off, s8 offset:216
		scratch_load_dword v34, off, s8 offset:220
		scratch_load_dword v35, off, s8 offset:224
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[220:223], v[32:35], v[80:83], v7, v65 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v32, off, s8 offset:212
		scratch_load_dword v33, off, s8 offset:216
		scratch_load_dword v34, off, s8 offset:220
		scratch_load_dword v35, off, s8 offset:224
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[224:227], v[32:35], v[136:139], v7, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[224:227], v[236:239], v[140:143], v7, v66 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[220:223], v[236:239], v[104:107], v7, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[220:223], v[240:243], v[112:115], v7, v66 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[224:227], v[240:243], v[144:147], v7, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[224:227], v[244:247], v[148:151], v7, v67 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[220:223], v[244:247], v[116:119], v7, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[220:223], v[248:251], v[120:123], v7, v67 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[224:227], v[248:251], v[152:155], v7, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[228:231], v[248:251], v[184:187], v64, v67 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[228:231], v[244:247], v[180:183], v64, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[232:235], v[244:247], v[212:215], v64, v67 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[232:235], v[248:251], v[216:219], v64, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v32, off, s8 offset:164
		scratch_load_dword v33, off, s8 offset:168
		scratch_load_dword v34, off, s8 offset:172
		scratch_load_dword v35, off, s8 offset:176
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[232:235], v[32:35], v[188:191], v64, v3 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v32, off, s8 offset:164
		scratch_load_dword v33, off, s8 offset:168
		scratch_load_dword v34, off, s8 offset:172
		scratch_load_dword v35, off, s8 offset:176
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[228:231], v[32:35], v[156:159], v64, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v32, off, s8 offset:180
		scratch_load_dword v33, off, s8 offset:184
		scratch_load_dword v34, off, s8 offset:188
		scratch_load_dword v35, off, s8 offset:192
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[228:231], v[32:35], v[160:163], v64, v3 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v32, off, s8 offset:180
		scratch_load_dword v33, off, s8 offset:184
		scratch_load_dword v34, off, s8 offset:188
		scratch_load_dword v35, off, s8 offset:192
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[232:235], v[32:35], v[192:195], v64, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v32, off, s8 offset:196
		scratch_load_dword v33, off, s8 offset:200
		scratch_load_dword v34, off, s8 offset:204
		scratch_load_dword v35, off, s8 offset:208
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[232:235], v[32:35], v[196:199], v64, v65 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v32, off, s8 offset:196
		scratch_load_dword v33, off, s8 offset:200
		scratch_load_dword v34, off, s8 offset:204
		scratch_load_dword v35, off, s8 offset:208
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[228:231], v[32:35], v[164:167], v64, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v32, off, s8 offset:212
		scratch_load_dword v33, off, s8 offset:216
		scratch_load_dword v34, off, s8 offset:220
		scratch_load_dword v35, off, s8 offset:224
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[228:231], v[32:35], v[168:171], v64, v65 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v32, off, s8 offset:212
		scratch_load_dword v33, off, s8 offset:216
		scratch_load_dword v34, off, s8 offset:220
		scratch_load_dword v35, off, s8 offset:224
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[232:235], v[32:35], v[200:203], v64, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[232:235], v[236:239], v[204:207], v64, v66 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[228:231], v[236:239], v[172:175], v64, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[228:231], v[240:243], v[176:179], v64, v66 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[232:235], v[240:243], v[208:211], v64, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s8, s35, 1
		s_mov_b32 m0, s15
		s_lshl_b32 s35, s8, 16
		ds_read_addtid_b32 v1 offset:12288
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s15
		v_add_u32_e32 v1, s35, v1
		ds_read_addtid_b32 v2 offset:22528
		s_mov_b32 s36, 0
		scratch_load_dword v3, off, s36 offset:148
		s_waitcnt vmcnt(0) lgkmcnt(0)
		v_add3_u32 v1, v1, v2, v3
		v_add_u32_e32 v1, 0x6000, v1
		s_mov_b32 s36, 0
		scratch_store_dword off, v1, s36 offset:280
		ds_read_b128 v[32:35], v1
		s_mov_b32 s36, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v32, s36 offset:452
		scratch_store_dword off, v33, s36 offset:456
		scratch_store_dword off, v34, s36 offset:460
		scratch_store_dword off, v35, s36 offset:464
		ds_read_b128 v[64:67], v1 offset:1024
		s_mov_b32 s36, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v64, s36 offset:584
		scratch_store_dword off, v65, s36 offset:588
		scratch_store_dword off, v66, s36 offset:592
		scratch_store_dword off, v67, s36 offset:596
		ds_read_b128 v[220:223], v1 offset:2048
		ds_read_b128 v[224:227], v1 offset:3072
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v2, s35, v1
		s_mov_b32 s35, 0
		scratch_load_dword v3, off, s35 offset:144
		s_mov_b32 s35, 0
		scratch_load_dword v6, off, s35 offset:148
		s_waitcnt vmcnt(0)
		v_add3_u32 v2, v2, v3, v6
		v_add_u32_e32 v2, 0x6000, v2
		ds_read_b128 v[228:231], v2 offset:32768
		s_mov_b32 s35, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s35 offset:284
		scratch_store_dword off, v229, s35 offset:288
		scratch_store_dword off, v230, s35 offset:292
		scratch_store_dword off, v231, s35 offset:296
		ds_read_b128 v[228:231], v2 offset:33792
		s_mov_b32 s35, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s35 offset:388
		scratch_store_dword off, v229, s35 offset:392
		scratch_store_dword off, v230, s35 offset:396
		scratch_store_dword off, v231, s35 offset:400
		ds_read_b128 v[228:231], v2 offset:34816
		s_mov_b32 s35, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s35 offset:404
		scratch_store_dword off, v229, s35 offset:408
		scratch_store_dword off, v230, s35 offset:412
		scratch_store_dword off, v231, s35 offset:416
		ds_read_b128 v[228:231], v2 offset:35840
		s_mov_b32 s35, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s35 offset:420
		scratch_store_dword off, v229, s35 offset:424
		scratch_store_dword off, v230, s35 offset:428
		scratch_store_dword off, v231, s35 offset:432
		ds_read_b128 v[228:231], v2 offset:36864
		s_mov_b32 s35, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s35 offset:436
		scratch_store_dword off, v229, s35 offset:440
		scratch_store_dword off, v230, s35 offset:444
		scratch_store_dword off, v231, s35 offset:448
		ds_read_b128 v[228:231], v2 offset:37888
		s_mov_b32 s35, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s35 offset:468
		scratch_store_dword off, v229, s35 offset:472
		scratch_store_dword off, v230, s35 offset:476
		scratch_store_dword off, v231, s35 offset:480
		s_add_i32 s35, s11, 1
		s_and_b32 s35, s35, 1
		s_lshl_b32 s35, s35, 16
		v_add_u32_e32 v1, s35, v1
		v_add3_u32 v1, v1, v3, v6
		v_add_u32_e32 v1, 0x6000, v1
		s_mov_b32 s35, 0
		scratch_store_dword off, v1, s35 offset:532
		ds_read_b128 v[228:231], v1 offset:38912
		s_mov_b32 s35, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s35 offset:484
		scratch_store_dword off, v229, s35 offset:488
		scratch_store_dword off, v230, s35 offset:492
		scratch_store_dword off, v231, s35 offset:496
		ds_read_b128 v[228:231], v1 offset:39936
		s_mov_b32 s35, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s35 offset:500
		scratch_store_dword off, v229, s35 offset:504
		scratch_store_dword off, v230, s35 offset:508
		scratch_store_dword off, v231, s35 offset:512
		s_lshl_b32 s8, s8, 12
		s_add_i32 s8, s8, 0x20000
		s_mov_b32 s35, 0
		s_waitcnt vmcnt(50)
		scratch_load_dword v2, off, s35 offset:244
		s_mov_b32 s35, 0
		s_waitcnt vmcnt(49)
		scratch_load_dword v3, off, s35 offset:276
		s_waitcnt vmcnt(0)
		v_add3_u32 v2, s8, v2, v3
		v_add_u32_e32 v2, 0x6000, v2
		ds_read_b32 v3, v2
		ds_read_b32 v6, v2 offset:256
		s_mov_b32 s35, 0
		s_waitcnt vmcnt(46)
		scratch_load_dword v2, off, s35 offset:256
		s_mov_b32 s35, 0
		scratch_load_dword v7, off, s35 offset:276
		s_waitcnt vmcnt(0)
		v_add3_u32 v2, s8, v7, v2
		v_add_u32_e32 v2, 0x6000, v2
		ds_read_b32 v7, v2 offset:2048
		ds_read_b32 v86, v2 offset:2304
		ds_read_b32 v87, v2 offset:2560
		ds_read_b32 v94, v2 offset:2816
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v96 offset:4096
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v97 offset:6144
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v110, vcc, v96, v10
		v_addc_co_u32_e64 v111, vcc, v97, v11, vcc
		s_mov_b32 s8, 0
		scratch_store_dword off, v110, s8 offset:300
		scratch_store_dword off, v111, s8 offset:304
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v96 offset:8192
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v97 offset:10240
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v110, vcc, v96, v10
		v_addc_co_u32_e64 v111, vcc, v97, v11, vcc
		s_mov_b32 s8, 0
		scratch_store_dword off, v110, s8 offset:308
		scratch_store_dword off, v111, s8 offset:312
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v96 offset:14336
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v97 offset:16384
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v110, vcc, v96, v10
		v_addc_co_u32_e64 v111, vcc, v97, v11, vcc
		s_mov_b32 s8, 0
		scratch_store_dword off, v110, s8 offset:316
		scratch_store_dword off, v111, s8 offset:320
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v96 offset:18432
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v97 offset:20480
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v110, vcc, v96, v10
		v_addc_co_u32_e64 v111, vcc, v97, v11, vcc
		s_mov_b32 s8, 0
		scratch_store_dword off, v110, s8 offset:324
		scratch_store_dword off, v111, s8 offset:328
		s_mov_b32 s8, 0
		scratch_load_dword v96, off, s8
		scratch_load_dword v97, off, s8 offset:4
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v110, vcc, v96, v10
		v_addc_co_u32_e64 v111, vcc, v97, v11, vcc
		s_mov_b32 s8, 0
		scratch_store_dword off, v110, s8 offset:332
		scratch_store_dword off, v111, s8 offset:336
		s_mov_b32 s8, 0
		scratch_load_dword v96, off, s8 offset:8
		scratch_load_dword v97, off, s8 offset:12
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v110, vcc, v96, v10
		v_addc_co_u32_e64 v111, vcc, v97, v11, vcc
		s_mov_b32 s8, 0
		scratch_store_dword off, v110, s8 offset:340
		scratch_store_dword off, v111, s8 offset:344
		s_mov_b32 s8, 0
		scratch_load_dword v96, off, s8 offset:16
		scratch_load_dword v97, off, s8 offset:20
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v110, vcc, v96, v10
		v_addc_co_u32_e64 v111, vcc, v97, v11, vcc
		s_mov_b32 s8, 0
		scratch_store_dword off, v110, s8 offset:348
		scratch_store_dword off, v111, s8 offset:352
		s_mov_b32 s8, 0
		scratch_load_dword v96, off, s8 offset:24
		scratch_load_dword v97, off, s8 offset:28
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v110, vcc, v96, v10
		v_addc_co_u32_e64 v111, vcc, v97, v11, vcc
		s_mov_b32 s8, 0
		scratch_store_dword off, v110, s8 offset:356
		scratch_store_dword off, v111, s8 offset:360
		s_mov_b32 s8, 0
		scratch_load_dword v10, off, s8 offset:32
		scratch_load_dword v11, off, s8 offset:36
		s_mov_b32 s8, 0
		scratch_load_dword v96, off, s8 offset:152
		scratch_load_dword v97, off, s8 offset:156
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v110, vcc, v10, v96
		v_addc_co_u32_e64 v111, vcc, v11, v97, vcc
		s_mov_b32 s8, 0
		scratch_store_dword off, v110, s8 offset:364
		scratch_store_dword off, v111, s8 offset:368
		s_mov_b32 s8, 0
		scratch_load_dword v10, off, s8 offset:40
		scratch_load_dword v11, off, s8 offset:44
		s_mov_b32 s8, 0
		scratch_load_dword v96, off, s8 offset:152
		scratch_load_dword v97, off, s8 offset:156
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v110, vcc, v10, v96
		v_addc_co_u32_e64 v111, vcc, v11, v97, vcc
		s_mov_b32 s8, 0
		scratch_store_dword off, v110, s8 offset:372
		scratch_store_dword off, v111, s8 offset:376
		s_mov_b32 s8, 0
		scratch_load_dword v10, off, s8 offset:48
		scratch_load_dword v11, off, s8 offset:52
		s_mov_b32 s8, 0
		scratch_load_dword v96, off, s8 offset:152
		scratch_load_dword v97, off, s8 offset:156
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v110, vcc, v10, v96
		v_addc_co_u32_e64 v111, vcc, v11, v97, vcc
		s_mov_b32 s8, 0
		scratch_store_dword off, v110, s8 offset:380
		scratch_store_dword off, v111, s8 offset:384
		s_mov_b32 s8, 0
		s_waitcnt vmcnt(51)
		scratch_load_dword v228, off, s8 offset:284
		scratch_load_dword v229, off, s8 offset:288
		scratch_load_dword v230, off, s8 offset:292
		scratch_load_dword v231, off, s8 offset:296
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[32:35], v[228:231], v[12:15], v3, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v2, off, s8 offset:280
		s_waitcnt vmcnt(0)
		ds_read_b128 v[228:231], v2 offset:16384
		s_mov_b32 s8, 0
		s_waitcnt vmcnt(47)
		scratch_load_dword v232, off, s8 offset:388
		scratch_load_dword v233, off, s8 offset:392
		scratch_load_dword v234, off, s8 offset:396
		scratch_load_dword v235, off, s8 offset:400
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[32:35], v[232:235], v[72:75], v3, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v2, off, s8 offset:280
		s_waitcnt vmcnt(0)
		ds_read_b128 v[232:235], v2 offset:17408
		s_mov_b32 s8, 0
		s_waitcnt vmcnt(43)
		scratch_load_dword v236, off, s8 offset:404
		scratch_load_dword v237, off, s8 offset:408
		scratch_load_dword v238, off, s8 offset:412
		scratch_load_dword v239, off, s8 offset:416
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[32:35], v[236:239], v[76:79], v3, v86 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v2, off, s8 offset:280
		s_waitcnt vmcnt(0)
		ds_read_b128 v[236:239], v2 offset:18432
		s_mov_b32 s8, 0
		s_waitcnt vmcnt(39)
		scratch_load_dword v240, off, s8 offset:420
		scratch_load_dword v241, off, s8 offset:424
		scratch_load_dword v242, off, s8 offset:428
		scratch_load_dword v243, off, s8 offset:432
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[32:35], v[240:243], v[80:83], v3, v86 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v2, off, s8 offset:280
		s_waitcnt vmcnt(0)
		ds_read_b128 v[32:35], v2 offset:19456
		s_mov_b32 s8, 0
		s_waitcnt vmcnt(35)
		scratch_load_dword v240, off, s8 offset:436
		scratch_load_dword v241, off, s8 offset:440
		scratch_load_dword v242, off, s8 offset:444
		scratch_load_dword v243, off, s8 offset:448
		s_mov_b32 s8, 0
		scratch_load_dword v244, off, s8 offset:452
		scratch_load_dword v245, off, s8 offset:456
		scratch_load_dword v246, off, s8 offset:460
		scratch_load_dword v247, off, s8 offset:464
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[244:247], v[240:243], v[104:107], v3, v87 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v1 offset:49152
		s_mov_b32 s8, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v240, s8 offset:516
		scratch_store_dword off, v241, s8 offset:520
		scratch_store_dword off, v242, s8 offset:524
		scratch_store_dword off, v243, s8 offset:528
		s_mov_b32 s8, 0
		scratch_load_dword v240, off, s8 offset:452
		scratch_load_dword v241, off, s8 offset:456
		scratch_load_dword v242, off, s8 offset:460
		scratch_load_dword v243, off, s8 offset:464
		s_mov_b32 s8, 0
		s_waitcnt vmcnt(35)
		scratch_load_dword v244, off, s8 offset:468
		scratch_load_dword v245, off, s8 offset:472
		scratch_load_dword v246, off, s8 offset:476
		scratch_load_dword v247, off, s8 offset:480
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[240:243], v[244:247], v[112:115], v3, v87 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v1 offset:50176
		s_mov_b32 s8, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v240, s8 offset:536
		scratch_store_dword off, v241, s8 offset:540
		scratch_store_dword off, v242, s8 offset:544
		scratch_store_dword off, v243, s8 offset:548
		s_mov_b32 s8, 0
		scratch_load_dword v240, off, s8 offset:452
		scratch_load_dword v241, off, s8 offset:456
		scratch_load_dword v242, off, s8 offset:460
		scratch_load_dword v243, off, s8 offset:464
		s_mov_b32 s8, 0
		s_waitcnt vmcnt(34)
		scratch_load_dword v244, off, s8 offset:484
		scratch_load_dword v245, off, s8 offset:488
		scratch_load_dword v246, off, s8 offset:492
		scratch_load_dword v247, off, s8 offset:496
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[240:243], v[244:247], v[116:119], v3, v94 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v1 offset:51200
		s_mov_b32 s8, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v240, s8 offset:552
		scratch_store_dword off, v241, s8 offset:556
		scratch_store_dword off, v242, s8 offset:560
		scratch_store_dword off, v243, s8 offset:564
		s_mov_b32 s8, 0
		scratch_load_dword v240, off, s8 offset:452
		scratch_load_dword v241, off, s8 offset:456
		scratch_load_dword v242, off, s8 offset:460
		scratch_load_dword v243, off, s8 offset:464
		s_mov_b32 s8, 0
		s_waitcnt vmcnt(34)
		scratch_load_dword v244, off, s8 offset:500
		scratch_load_dword v245, off, s8 offset:504
		scratch_load_dword v246, off, s8 offset:508
		scratch_load_dword v247, off, s8 offset:512
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[240:243], v[244:247], v[120:123], v3, v94 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v1 offset:52224
		s_mov_b32 s8, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v240, s8 offset:568
		scratch_store_dword off, v241, s8 offset:572
		scratch_store_dword off, v242, s8 offset:576
		scratch_store_dword off, v243, s8 offset:580
		s_mov_b32 s8, 0
		scratch_load_dword v240, off, s8 offset:284
		scratch_load_dword v241, off, s8 offset:288
		scratch_load_dword v242, off, s8 offset:292
		scratch_load_dword v243, off, s8 offset:296
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[64:67], v[240:243], v[124:127], v3, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v1 offset:53248
		s_mov_b32 s8, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v240, s8 offset:600
		scratch_store_dword off, v241, s8 offset:604
		scratch_store_dword off, v242, s8 offset:608
		scratch_store_dword off, v243, s8 offset:612
		s_mov_b32 s8, 0
		scratch_load_dword v240, off, s8 offset:388
		scratch_load_dword v241, off, s8 offset:392
		scratch_load_dword v242, off, s8 offset:396
		scratch_load_dword v243, off, s8 offset:400
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[64:67], v[240:243], v[128:131], v3, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v1, off, s8 offset:532
		s_waitcnt vmcnt(0)
		ds_read_b128 v[240:243], v1 offset:54272
		s_mov_b32 s8, 0
		scratch_load_dword v244, off, s8 offset:404
		scratch_load_dword v245, off, s8 offset:408
		scratch_load_dword v246, off, s8 offset:412
		scratch_load_dword v247, off, s8 offset:416
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[64:67], v[244:247], v[132:135], v3, v86 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v1, off, s8 offset:532
		s_waitcnt vmcnt(0)
		ds_read_b128 v[244:247], v1 offset:55296
		s_mov_b32 s8, 0
		scratch_load_dword v248, off, s8 offset:420
		scratch_load_dword v249, off, s8 offset:424
		scratch_load_dword v250, off, s8 offset:428
		scratch_load_dword v251, off, s8 offset:432
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[64:67], v[248:251], v[136:139], v3, v86 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v1, off, s8 offset:532
		s_waitcnt vmcnt(0)
		ds_read_b128 v[64:67], v1 offset:56320
		s_mov_b32 s8, 0
		scratch_load_dword v248, off, s8 offset:436
		scratch_load_dword v249, off, s8 offset:440
		scratch_load_dword v250, off, s8 offset:444
		scratch_load_dword v251, off, s8 offset:448
		s_mov_b32 s8, 0
		scratch_load_dword v252, off, s8 offset:584
		scratch_load_dword v253, off, s8 offset:588
		scratch_load_dword v254, off, s8 offset:592
		scratch_load_dword v255, off, s8 offset:596
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[252:255], v[248:251], v[140:143], v3, v87 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s10, 0x6000
		s_mov_b32 s8, 0
		s_waitcnt vmcnt(40)
		scratch_load_dword v10, off, s8 offset:300
		scratch_load_dword v11, off, s8 offset:304
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		s_mov_b32 s8, 0
		scratch_load_dword v248, off, s8 offset:468
		scratch_load_dword v249, off, s8 offset:472
		scratch_load_dword v250, off, s8 offset:476
		scratch_load_dword v251, off, s8 offset:480
		s_mov_b32 s8, 0
		scratch_load_dword v252, off, s8 offset:584
		scratch_load_dword v253, off, s8 offset:588
		scratch_load_dword v254, off, s8 offset:592
		scratch_load_dword v255, off, s8 offset:596
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[252:255], v[248:251], v[144:147], v3, v87 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		s_mov_b32 s8, 0
		s_waitcnt vmcnt(38)
		scratch_load_dword v10, off, s8 offset:308
		scratch_load_dword v11, off, s8 offset:312
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		s_mov_b32 s8, 0
		scratch_load_dword v248, off, s8 offset:484
		scratch_load_dword v249, off, s8 offset:488
		scratch_load_dword v250, off, s8 offset:492
		scratch_load_dword v251, off, s8 offset:496
		s_mov_b32 s8, 0
		scratch_load_dword v252, off, s8 offset:584
		scratch_load_dword v253, off, s8 offset:588
		scratch_load_dword v254, off, s8 offset:592
		scratch_load_dword v255, off, s8 offset:596
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[252:255], v[248:251], v[148:151], v3, v94 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		s_mov_b32 s8, 0
		s_waitcnt vmcnt(36)
		scratch_load_dword v10, off, s8 offset:316
		scratch_load_dword v11, off, s8 offset:320
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		s_mov_b32 s8, 0
		scratch_load_dword v248, off, s8 offset:500
		scratch_load_dword v249, off, s8 offset:504
		scratch_load_dword v250, off, s8 offset:508
		scratch_load_dword v251, off, s8 offset:512
		s_mov_b32 s8, 0
		scratch_load_dword v252, off, s8 offset:584
		scratch_load_dword v253, off, s8 offset:588
		scratch_load_dword v254, off, s8 offset:592
		scratch_load_dword v255, off, s8 offset:596
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[252:255], v[248:251], v[152:155], v3, v94 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		s_mov_b32 s8, 0
		s_waitcnt vmcnt(34)
		scratch_load_dword v10, off, s8 offset:324
		scratch_load_dword v11, off, s8 offset:328
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v10, s[20:23], 0 offen lds
		s_mov_b32 s8, 0
		scratch_load_dword v248, off, s8 offset:284
		scratch_load_dword v249, off, s8 offset:288
		scratch_load_dword v250, off, s8 offset:292
		scratch_load_dword v251, off, s8 offset:296
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[220:223], v[248:251], v[156:159], v6, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		s_mov_b32 s8, 0
		s_waitcnt vmcnt(32)
		scratch_load_dword v10, off, s8 offset:332
		scratch_load_dword v11, off, s8 offset:336
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		s_mov_b32 s8, 0
		scratch_load_dword v248, off, s8 offset:388
		scratch_load_dword v249, off, s8 offset:392
		scratch_load_dword v250, off, s8 offset:396
		scratch_load_dword v251, off, s8 offset:400
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[220:223], v[248:251], v[160:163], v6, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		s_mov_b32 s8, 0
		s_waitcnt vmcnt(30)
		scratch_load_dword v10, off, s8 offset:340
		scratch_load_dword v11, off, s8 offset:344
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		s_mov_b32 s8, 0
		scratch_load_dword v248, off, s8 offset:404
		scratch_load_dword v249, off, s8 offset:408
		scratch_load_dword v250, off, s8 offset:412
		scratch_load_dword v251, off, s8 offset:416
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[220:223], v[248:251], v[164:167], v6, v86 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		s_mov_b32 s8, 0
		s_waitcnt vmcnt(28)
		scratch_load_dword v10, off, s8 offset:348
		scratch_load_dword v11, off, s8 offset:352
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		s_mov_b32 s8, 0
		scratch_load_dword v248, off, s8 offset:420
		scratch_load_dword v249, off, s8 offset:424
		scratch_load_dword v250, off, s8 offset:428
		scratch_load_dword v251, off, s8 offset:432
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[220:223], v[248:251], v[168:171], v6, v86 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		s_mov_b32 s8, 0
		s_waitcnt vmcnt(26)
		scratch_load_dword v10, off, s8 offset:356
		scratch_load_dword v11, off, s8 offset:360
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v10, s[0:3], 0 offen lds
		s_mov_b32 s8, 0
		scratch_load_dword v248, off, s8 offset:436
		scratch_load_dword v249, off, s8 offset:440
		scratch_load_dword v250, off, s8 offset:444
		scratch_load_dword v251, off, s8 offset:448
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[220:223], v[248:251], v[172:175], v6, v87 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s9, 0x26000
		s_mov_b32 s8, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v10, off, s8 offset:364
		scratch_load_dword v11, off, s8 offset:368
		s_waitcnt vmcnt(0)
		buffer_load_dword v10, s[24:27], 0 offen lds
		s_mov_b32 s8, 0
		scratch_load_dword v248, off, s8 offset:468
		scratch_load_dword v249, off, s8 offset:472
		scratch_load_dword v250, off, s8 offset:476
		scratch_load_dword v251, off, s8 offset:480
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[220:223], v[248:251], v[176:179], v6, v87 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x100
		s_mov_b32 s8, 0
		s_waitcnt vmcnt(22)
		scratch_load_dword v10, off, s8 offset:372
		scratch_load_dword v11, off, s8 offset:376
		s_waitcnt vmcnt(0)
		buffer_load_dword v10, s[24:27], 0 offen lds
		s_mov_b32 s8, 0
		scratch_load_dword v248, off, s8 offset:484
		scratch_load_dword v249, off, s8 offset:488
		scratch_load_dword v250, off, s8 offset:492
		scratch_load_dword v251, off, s8 offset:496
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[220:223], v[248:251], v[180:183], v6, v94 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		s_waitcnt vmcnt(20)
		scratch_load_dword v10, off, s8 offset:380
		scratch_load_dword v11, off, s8 offset:384
		s_add_i32 m0, s5, 0x26000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		s_mov_b32 s8, 0
		scratch_load_dword v248, off, s8 offset:500
		scratch_load_dword v249, off, s8 offset:504
		scratch_load_dword v250, off, s8 offset:508
		scratch_load_dword v251, off, s8 offset:512
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[220:223], v[248:251], v[184:187], v6, v94 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v220, off, s8 offset:500
		scratch_load_dword v221, off, s8 offset:504
		scratch_load_dword v222, off, s8 offset:508
		scratch_load_dword v223, off, s8 offset:512
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[224:227], v[220:223], v[216:219], v6, v94 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v220, off, s8 offset:484
		scratch_load_dword v221, off, s8 offset:488
		scratch_load_dword v222, off, s8 offset:492
		scratch_load_dword v223, off, s8 offset:496
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[224:227], v[220:223], v[212:215], v6, v94 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v220, off, s8 offset:284
		scratch_load_dword v221, off, s8 offset:288
		scratch_load_dword v222, off, s8 offset:292
		scratch_load_dword v223, off, s8 offset:296
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[224:227], v[220:223], v[188:191], v6, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v220, off, s8 offset:388
		scratch_load_dword v221, off, s8 offset:392
		scratch_load_dword v222, off, s8 offset:396
		scratch_load_dword v223, off, s8 offset:400
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[224:227], v[220:223], v[192:195], v6, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v220, off, s8 offset:404
		scratch_load_dword v221, off, s8 offset:408
		scratch_load_dword v222, off, s8 offset:412
		scratch_load_dword v223, off, s8 offset:416
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[224:227], v[220:223], v[196:199], v6, v86 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v220, off, s8 offset:420
		scratch_load_dword v221, off, s8 offset:424
		scratch_load_dword v222, off, s8 offset:428
		scratch_load_dword v223, off, s8 offset:432
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[224:227], v[220:223], v[200:203], v6, v86 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v220, off, s8 offset:436
		scratch_load_dword v221, off, s8 offset:440
		scratch_load_dword v222, off, s8 offset:444
		scratch_load_dword v223, off, s8 offset:448
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[224:227], v[220:223], v[204:207], v6, v87 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v220, off, s8 offset:468
		scratch_load_dword v221, off, s8 offset:472
		scratch_load_dword v222, off, s8 offset:476
		scratch_load_dword v223, off, s8 offset:480
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[224:227], v[220:223], v[208:211], v6, v87 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_mov_b32 s8, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v220, off, s8 offset:516
		scratch_load_dword v221, off, s8 offset:520
		scratch_load_dword v222, off, s8 offset:524
		scratch_load_dword v223, off, s8 offset:528
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[228:231], v[220:223], v[12:15], v3, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		s_waitcnt vmcnt(12)
		scratch_load_dword v220, off, s8 offset:536
		scratch_load_dword v221, off, s8 offset:540
		scratch_load_dword v222, off, s8 offset:544
		scratch_load_dword v223, off, s8 offset:548
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[228:231], v[220:223], v[72:75], v3, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v220, off, s8 offset:536
		scratch_load_dword v221, off, s8 offset:540
		scratch_load_dword v222, off, s8 offset:544
		scratch_load_dword v223, off, s8 offset:548
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[232:235], v[220:223], v[128:131], v3, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v220, off, s8 offset:516
		scratch_load_dword v221, off, s8 offset:520
		scratch_load_dword v222, off, s8 offset:524
		scratch_load_dword v223, off, s8 offset:528
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[232:235], v[220:223], v[124:127], v3, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v220, off, s8 offset:552
		scratch_load_dword v221, off, s8 offset:556
		scratch_load_dword v222, off, s8 offset:560
		scratch_load_dword v223, off, s8 offset:564
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[232:235], v[220:223], v[132:135], v3, v86 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v220, off, s8 offset:552
		scratch_load_dword v221, off, s8 offset:556
		scratch_load_dword v222, off, s8 offset:560
		scratch_load_dword v223, off, s8 offset:564
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[228:231], v[220:223], v[76:79], v3, v86 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v220, off, s8 offset:568
		scratch_load_dword v221, off, s8 offset:572
		scratch_load_dword v222, off, s8 offset:576
		scratch_load_dword v223, off, s8 offset:580
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[228:231], v[220:223], v[80:83], v3, v86 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v220, off, s8 offset:568
		scratch_load_dword v221, off, s8 offset:572
		scratch_load_dword v222, off, s8 offset:576
		scratch_load_dword v223, off, s8 offset:580
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[232:235], v[220:223], v[136:139], v3, v86 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v220, off, s8 offset:600
		scratch_load_dword v221, off, s8 offset:604
		scratch_load_dword v222, off, s8 offset:608
		scratch_load_dword v223, off, s8 offset:612
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[232:235], v[220:223], v[140:143], v3, v87 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v220, off, s8 offset:600
		scratch_load_dword v221, off, s8 offset:604
		scratch_load_dword v222, off, s8 offset:608
		scratch_load_dword v223, off, s8 offset:612
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[228:231], v[220:223], v[104:107], v3, v87 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[228:231], v[240:243], v[112:115], v3, v87 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[232:235], v[240:243], v[144:147], v3, v87 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[232:235], v[244:247], v[148:151], v3, v94 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[228:231], v[244:247], v[116:119], v3, v94 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[228:231], v[64:67], v[120:123], v3, v94 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[232:235], v[64:67], v[152:155], v3, v94 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[236:239], v[64:67], v[184:187], v6, v94 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[236:239], v[244:247], v[180:183], v6, v94 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[244:247], v[212:215], v6, v94 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[64:67], v[216:219], v6, v94 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v64, off, s8 offset:516
		scratch_load_dword v65, off, s8 offset:520
		scratch_load_dword v66, off, s8 offset:524
		scratch_load_dword v67, off, s8 offset:528
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[32:35], v[64:67], v[188:191], v6, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v64, off, s8 offset:516
		scratch_load_dword v65, off, s8 offset:520
		scratch_load_dword v66, off, s8 offset:524
		scratch_load_dword v67, off, s8 offset:528
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[236:239], v[64:67], v[156:159], v6, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v64, off, s8 offset:536
		scratch_load_dword v65, off, s8 offset:540
		scratch_load_dword v66, off, s8 offset:544
		scratch_load_dword v67, off, s8 offset:548
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[236:239], v[64:67], v[160:163], v6, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v64, off, s8 offset:536
		scratch_load_dword v65, off, s8 offset:540
		scratch_load_dword v66, off, s8 offset:544
		scratch_load_dword v67, off, s8 offset:548
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[32:35], v[64:67], v[192:195], v6, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v64, off, s8 offset:552
		scratch_load_dword v65, off, s8 offset:556
		scratch_load_dword v66, off, s8 offset:560
		scratch_load_dword v67, off, s8 offset:564
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[32:35], v[64:67], v[196:199], v6, v86 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v64, off, s8 offset:552
		scratch_load_dword v65, off, s8 offset:556
		scratch_load_dword v66, off, s8 offset:560
		scratch_load_dword v67, off, s8 offset:564
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[236:239], v[64:67], v[164:167], v6, v86 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v64, off, s8 offset:568
		scratch_load_dword v65, off, s8 offset:572
		scratch_load_dword v66, off, s8 offset:576
		scratch_load_dword v67, off, s8 offset:580
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[236:239], v[64:67], v[168:171], v6, v86 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v64, off, s8 offset:568
		scratch_load_dword v65, off, s8 offset:572
		scratch_load_dword v66, off, s8 offset:576
		scratch_load_dword v67, off, s8 offset:580
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[32:35], v[64:67], v[200:203], v6, v86 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v64, off, s8 offset:600
		scratch_load_dword v65, off, s8 offset:604
		scratch_load_dword v66, off, s8 offset:608
		scratch_load_dword v67, off, s8 offset:612
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[32:35], v[64:67], v[204:207], v6, v87 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s8, 0
		scratch_load_dword v64, off, s8 offset:600
		scratch_load_dword v65, off, s8 offset:604
		scratch_load_dword v66, off, s8 offset:608
		scratch_load_dword v67, off, s8 offset:612
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[236:239], v[64:67], v[172:175], v6, v87 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[236:239], v[240:243], v[176:179], v6, v87 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[240:243], v[208:211], v6, v87 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s11, s11, 2
		s_cmp_lt_i32 s11, s34
		s_mov_b32 s8, 0
		scratch_load_dword v32, off, s8 offset:228
		scratch_load_dword v33, off, s8 offset:232
		scratch_load_dword v34, off, s8 offset:236
		scratch_load_dword v35, off, s8 offset:240
		s_mov_b32 s8, 0
		scratch_load_dword v1, off, s8 offset:248
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v7, v1
		s_mov_b32 s8, 0
		scratch_load_dword v1, off, s8 offset:252
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v64, v1
		s_mov_b32 s8, 0
		scratch_load_dword v1, off, s8 offset:260
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v3, v1
		s_mov_b32 s8, 0
		scratch_load_dword v1, off, s8 offset:264
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v65, v1
		s_mov_b32 s8, 0
		scratch_load_dword v1, off, s8 offset:268
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v66, v1
		s_mov_b32 s8, 0
		scratch_load_dword v1, off, s8 offset:272
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v67, v1
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_add_i32 s0, s12, -1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[20:23], v[16:19], v[12:15], v7, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s0, s0, 1
		s_lshl_b32 s0, s0, 16
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v1, 12, v1
		v_add_u32_e32 v2, s0, v1
		v_and_b32_e32 v4, 15, v0
		v_lshlrev_b32_e32 v4, 6, v4
		v_and_b32_e32 v5, 63, v0
		v_lshrrev_b32_e32 v5, 4, v5
		v_and_b32_e32 v6, 15, v0
		v_lshrrev_b32_e32 v6, 1, v6
		v_bitop3_b32 v5, v5, v6, 3 bitop3:0x78
		v_lshlrev_b32_e32 v5, 4, v5
		v_add3_u32 v2, v2, v4, v5
		v_add_u32_e32 v2, 0x6000, v2
		ds_read_b128 v[8:11], v2 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[20:23], v[36:39], v[72:75], v7, v3 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[68:71], v2 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[20:23], v[40:43], v[76:79], v7, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[84:87], v2 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[20:23], v[44:47], v[80:83], v7, v65 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v2 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[20:23], v[48:51], v[104:107], v7, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, s0, v4
		v_lshrrev_b32_e32 v6, 6, v0
		v_and_b32_e32 v6, 1, v6
		v_lshlrev_b32_e32 v6, 13, v6
		v_add3_u32 v2, v2, v6, v5
		v_add_u32_e32 v2, 0x6000, v2
		ds_read_b128 v[92:95], v2 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[20:23], v[52:55], v[112:115], v7, v66 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v2 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[20:23], v[56:59], v[116:119], v7, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v2 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[20:23], v[60:63], v[120:123], v7, v67 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v2 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[24:27], v[16:19], v[124:127], v7, v3 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[108:111], v2 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[24:27], v[36:39], v[128:131], v7, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v2 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[24:27], v[40:43], v[132:135], v7, v65 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v2 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[24:27], v[44:47], v[136:139], v7, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v2 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[24:27], v[48:51], v[140:143], v7, v66 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[52:55], v[144:147], v7, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[24:27], v[56:59], v[148:151], v7, v67 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[24:27], v[60:63], v[152:155], v7, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[28:31], v[60:63], v[184:187], v64, v67 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[28:31], v[56:59], v[180:183], v64, v67 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[32:35], v[56:59], v[212:215], v64, v67 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[32:35], v[60:63], v[216:219], v64, v67 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[32:35], v[16:19], v[188:191], v64, v3 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[28:31], v[16:19], v[156:159], v64, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[28:31], v[36:39], v[160:163], v64, v3 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[32:35], v[36:39], v[192:195], v64, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[32:35], v[40:43], v[196:199], v64, v65 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[28:31], v[40:43], v[164:167], v64, v65 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[28:31], v[44:47], v[168:171], v64, v65 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[32:35], v[44:47], v[200:203], v64, v65 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[32:35], v[48:51], v[204:207], v64, v66 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[28:31], v[48:51], v[172:175], v64, v66 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[52:55], v[176:179], v64, v66 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[52:55], v[208:211], v64, v66 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[84:87], v[108:111], v[172:175], v64, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[84:87], v[220:223], v[176:179], v64, v66 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[88:91], v[220:223], v[208:211], v64, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[88:91], v[108:111], v[204:207], v64, v66 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[8:11], v[108:111], v[104:107], v7, v66 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[8:11], v[220:223], v[112:115], v7, v66 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[68:71], v[220:223], v[144:147], v7, v66 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[68:71], v[108:111], v[140:143], v7, v66 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[68:71], v[92:95], v[124:127], v7, v3 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[8:11], v[92:95], v[12:15], v7, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[8:11], v[96:99], v[72:75], v7, v3 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[68:71], v[96:99], v[128:131], v7, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[68:71], v[100:103], v[132:135], v7, v65 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[8:11], v[100:103], v[76:79], v7, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[8:11], v[20:23], v[80:83], v7, v65 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[68:71], v[20:23], v[136:139], v7, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[68:71], v[224:227], v[148:151], v7, v67 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[8:11], v[224:227], v[116:119], v7, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[8:11], v[228:231], v[120:123], v7, v67 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[68:71], v[228:231], v[152:155], v7, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[84:87], v[228:231], v[184:187], v64, v67 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[84:87], v[224:227], v[180:183], v64, v67 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[88:91], v[224:227], v[212:215], v64, v67 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[88:91], v[228:231], v[216:219], v64, v67 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[88:91], v[92:95], v[188:191], v64, v3 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[84:87], v[92:95], v[156:159], v64, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[84:87], v[96:99], v[160:163], v64, v3 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[88:91], v[96:99], v[192:195], v64, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[88:91], v[100:103], v[196:199], v64, v65 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[84:87], v[100:103], v[164:167], v64, v65 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[84:87], v[20:23], v[168:171], v64, v65 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[88:91], v[20:23], v[200:203], v64, v65 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s0, s12, 1
		s_lshl_b32 s1, s0, 16
		v_add_u32_e32 v1, s1, v1
		v_add3_u32 v1, v1, v4, v5
		v_add_u32_e32 v1, 0x6000, v1
		ds_read_b128 v[8:11], v1
		ds_read_b128 v[16:19], v1 offset:1024
		ds_read_b128 v[20:23], v1 offset:2048
		ds_read_b128 v[24:27], v1 offset:3072
		v_add_u32_e32 v2, s1, v4
		v_add3_u32 v2, v2, v6, v5
		v_add_u32_e32 v2, 0x6000, v2
		ds_read_b128 v[4:7], v2 offset:32768
		ds_read_b128 v[28:31], v2 offset:33792
		ds_read_b128 v[32:35], v2 offset:34816
		ds_read_b128 v[36:39], v2 offset:35840
		ds_read_b128 v[40:43], v2 offset:36864
		ds_read_b128 v[44:47], v2 offset:37888
		ds_read_b128 v[48:51], v2 offset:38912
		ds_read_b128 v[52:55], v2 offset:39936
		s_lshl_b32 s0, s0, 12
		s_add_i32 s0, s0, 0x20000
		v_lshrrev_b32_e32 v3, 7, v0
		v_lshlrev_b32_e32 v3, 9, v3
		v_and_b32_e32 v56, 63, v0
		v_lshlrev_b32_e32 v56, 2, v56
		v_add3_u32 v3, s0, v3, v56
		v_add_u32_e32 v3, 0x6000, v3
		ds_read_b32 v57, v3
		ds_read_b32 v58, v3 offset:256
		v_lshrrev_b32_e32 v3, 6, v0
		v_and_b32_e32 v3, 1, v3
		v_lshlrev_b32_e32 v3, 10, v3
		v_add3_u32 v3, s0, v56, v3
		v_add_u32_e32 v3, 0x6000, v3
		ds_read_b32 v56, v3 offset:2048
		ds_read_b32 v59, v3 offset:2304
		ds_read_b32 v60, v3 offset:2560
		ds_read_b32 v61, v3 offset:2816
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[8:11], v[4:7], v[12:15], v57, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[64:67], v1 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[8:11], v[28:31], v[72:75], v57, v56 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[68:71], v1 offset:17408
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[8:11], v[32:35], v[76:79], v57, v59 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[84:87], v1 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[8:11], v[36:39], v[80:83], v57, v59 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v1 offset:19456
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[8:11], v[40:43], v[104:107], v57, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v2 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[8:11], v[44:47], v[112:115], v57, v60 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v2 offset:50176
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[8:11], v[48:51], v[116:119], v57, v61 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[100:103], v2 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[8:11], v[52:55], v[120:123], v57, v61 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[8:11], v2 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[4:7], v[124:127], v57, v56 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[108:111], v2 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[28:31], v[128:131], v57, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v2 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[16:19], v[32:35], v[132:135], v57, v59 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v2 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[36:39], v[136:139], v57, v59 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v2 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[16:19], v[40:43], v[140:143], v57, v60 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[16:19], v[44:47], v[144:147], v57, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[16:19], v[48:51], v[148:151], v57, v61 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[16:19], v[52:55], v[152:155], v57, v61 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[20:23], v[52:55], v[184:187], v58, v61 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[20:23], v[48:51], v[180:183], v58, v61 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[24:27], v[48:51], v[212:215], v58, v61 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[24:27], v[52:55], v[216:219], v58, v61 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[4:7], v[188:191], v58, v56 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[4:7], v[156:159], v58, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[28:31], v[160:163], v58, v56 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[28:31], v[192:195], v58, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[32:35], v[196:199], v58, v59 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[32:35], v[164:167], v58, v59 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[36:39], v[168:171], v58, v59 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[36:39], v[200:203], v58, v59 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[40:43], v[204:207], v58, v60 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[40:43], v[172:175], v58, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[20:23], v[44:47], v[176:179], v58, v60 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], v[44:47], v[208:211], v58, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[84:87], v[108:111], v[172:175], v58, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[84:87], v[220:223], v[176:179], v58, v60 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[88:91], v[220:223], v[208:211], v58, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[88:91], v[108:111], v[204:207], v58, v60 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[64:67], v[108:111], v[104:107], v57, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[64:67], v[220:223], v[112:115], v57, v60 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[68:71], v[220:223], v[144:147], v57, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[68:71], v[108:111], v[140:143], v57, v60 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[68:71], v[92:95], v[124:127], v57, v56 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[64:67], v[92:95], v[12:15], v57, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[72:75], v[64:67], v[96:99], v[72:75], v57, v56 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[68:71], v[96:99], v[128:131], v57, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[68:71], v[100:103], v[132:135], v57, v59 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[64:67], v[100:103], v[76:79], v57, v59 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[64:67], v[8:11], v[80:83], v57, v59 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[68:71], v[8:11], v[136:139], v57, v59 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[68:71], v[224:227], v[148:151], v57, v61 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[64:67], v[224:227], v[116:119], v57, v61 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[64:67], v[228:231], v[120:123], v57, v61 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[68:71], v[228:231], v[152:155], v57, v61 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[84:87], v[228:231], v[184:187], v58, v61 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[84:87], v[224:227], v[180:183], v58, v61 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[88:91], v[224:227], v[212:215], v58, v61 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[88:91], v[228:231], v[216:219], v58, v61 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[88:91], v[92:95], v[188:191], v58, v56 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[84:87], v[92:95], v[156:159], v58, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[84:87], v[96:99], v[160:163], v58, v56 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[88:91], v[96:99], v[192:195], v58, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[88:91], v[100:103], v[196:199], v58, v59 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[84:87], v[100:103], v[164:167], v58, v59 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[84:87], v[8:11], v[168:171], v58, v59 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[88:91], v[8:11], v[200:203], v58, v59 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
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
		v_cvt_pk_f16_f32 v2, v72, v73
		v_cvt_pk_f16_f32 v3, v74, v75
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:512
		v_cvt_pk_f16_f32 v2, v76, v77
		v_cvt_pk_f16_f32 v3, v78, v79
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:1024
		v_cvt_pk_f16_f32 v2, v80, v81
		v_cvt_pk_f16_f32 v3, v82, v83
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:1536
		v_cvt_pk_f16_f32 v2, v104, v105
		v_cvt_pk_f16_f32 v3, v106, v107
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:2048
		v_cvt_pk_f16_f32 v2, v112, v113
		v_cvt_pk_f16_f32 v3, v114, v115
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:2560
		v_cvt_pk_f16_f32 v2, v116, v117
		v_cvt_pk_f16_f32 v3, v118, v119
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:3072
		v_cvt_pk_f16_f32 v2, v120, v121
		v_cvt_pk_f16_f32 v3, v122, v123
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:3584
		v_cvt_pk_f16_f32 v2, v124, v125
		v_cvt_pk_f16_f32 v3, v126, v127
		s_add_i32 s2, s0, 0x1000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen
		v_cvt_pk_f16_f32 v2, v128, v129
		v_cvt_pk_f16_f32 v3, v130, v131
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:512
		v_cvt_pk_f16_f32 v2, v132, v133
		v_cvt_pk_f16_f32 v3, v134, v135
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:1024
		v_cvt_pk_f16_f32 v2, v136, v137
		v_cvt_pk_f16_f32 v3, v138, v139
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:1536
		v_cvt_pk_f16_f32 v2, v140, v141
		v_cvt_pk_f16_f32 v3, v142, v143
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:2048
		v_cvt_pk_f16_f32 v2, v144, v145
		v_cvt_pk_f16_f32 v3, v146, v147
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:2560
		v_cvt_pk_f16_f32 v2, v148, v149
		v_cvt_pk_f16_f32 v3, v150, v151
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:3072
		v_cvt_pk_f16_f32 v2, v152, v153
		v_cvt_pk_f16_f32 v3, v154, v155
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:3584
		v_cvt_pk_f16_f32 v2, v156, v157
		v_cvt_pk_f16_f32 v3, v158, v159
		s_add_i32 s2, s0, 0x2000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen
		v_cvt_pk_f16_f32 v2, v160, v161
		v_cvt_pk_f16_f32 v3, v162, v163
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:512
		v_cvt_pk_f16_f32 v2, v164, v165
		v_cvt_pk_f16_f32 v3, v166, v167
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:1024
		v_cvt_pk_f16_f32 v2, v168, v169
		v_cvt_pk_f16_f32 v3, v170, v171
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:1536
		v_cvt_pk_f16_f32 v2, v172, v173
		v_cvt_pk_f16_f32 v3, v174, v175
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:2048
		v_cvt_pk_f16_f32 v2, v176, v177
		v_cvt_pk_f16_f32 v3, v178, v179
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:2560
		v_cvt_pk_f16_f32 v2, v180, v181
		v_cvt_pk_f16_f32 v3, v182, v183
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:3072
		v_cvt_pk_f16_f32 v2, v184, v185
		v_cvt_pk_f16_f32 v3, v186, v187
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:3584
		v_cvt_pk_f16_f32 v2, v188, v189
		v_cvt_pk_f16_f32 v3, v190, v191
		s_add_i32 s0, s0, 0x3000
		s_add_i32 s0, s0, s1
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen
		v_cvt_pk_f16_f32 v2, v192, v193
		v_cvt_pk_f16_f32 v3, v194, v195
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:512
		v_cvt_pk_f16_f32 v2, v196, v197
		v_cvt_pk_f16_f32 v3, v198, v199
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:1024
		v_cvt_pk_f16_f32 v2, v200, v201
		v_cvt_pk_f16_f32 v3, v202, v203
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:1536
		v_cvt_pk_f16_f32 v2, v204, v205
		v_cvt_pk_f16_f32 v3, v206, v207
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:2048
		v_cvt_pk_f16_f32 v2, v208, v209
		v_cvt_pk_f16_f32 v3, v210, v211
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:2560
		v_cvt_pk_f16_f32 v2, v212, v213
		v_cvt_pk_f16_f32 v3, v214, v215
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:3072
		v_cvt_pk_f16_f32 v2, v216, v217
		v_cvt_pk_f16_f32 v3, v218, v219
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s0 offen offset:3584
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 24576
		.amdhsa_private_segment_fixed_size 616
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
		.amdhsa_next_free_sgpr 37
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
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 37
	.set .Lwmma_f16_matmul_tiled.num_named_barrier, 0
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 616
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
    .private_segment_fixed_size: 616
    .sgpr_count:     37
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     256
    .agpr_count:     0
    .vgpr_spill_count: 154
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 87
    wave.regalloc.agpr.dwords: 0
    wave.regalloc.remat.dwords: 17
    wave.regalloc.sgpr_to_vgpr.dwords: 0
    wave.regalloc.lds.dwords: 12
    wave.regalloc.scratch.dwords: 154
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
