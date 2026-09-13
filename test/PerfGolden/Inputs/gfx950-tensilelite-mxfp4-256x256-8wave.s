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
		s_lshr_b32 s8, s4, 6
		v_readfirstlane_b32 s5, v0
		s_lshl_b32 s9, s13, 20
		s_lshl_b32 s10, s8, 16
		s_add_i32 s11, s9, s10
		v_and_b32_e32 v1, 63, v0
		v_lshrrev_b32_e32 v2, 2, v1
		v_lshlrev_b32_e32 v2, 12, v2
		v_lshrrev_b32_e32 v3, 3, v1
		v_bitop3_b32 v3, v3, 3, v1 bitop3:0x48
		v_lshlrev_b32_e32 v3, 4, v3
		v_add3_u32 v4, s11, v2, v3
		s_add_i32 s11, s9, 0x80000
		s_add_i32 s11, s11, s10
		s_add_i32 s16, s9, 64
		s_add_i32 s16, s16, s10
		s_add_i32 s17, s9, 0x80040
		s_add_i32 s17, s17, s10
		s_lshl_b32 s19, s14, 20
		s_add_i32 s32, s19, s10
		s_add_i32 s33, s19, 0x80000
		s_add_i32 s33, s33, s10
		s_add_i32 s34, s19, 64
		s_add_i32 s34, s34, s10
		s_add_i32 s35, s19, 0x80040
		s_add_i32 s35, s35, s10
		s_lshr_b32 s36, s5, 6
		s_lshl_b32 s37, s36, 10
		s_and_b32 s38, s8, 1
		s_lshl_b32 s39, s38, 13
		v_and_b32_e32 v5, 15, v0
		v_lshlrev_b32_e32 v6, 6, v5
		v_lshrrev_b32_e32 v7, 4, v1
		v_lshrrev_b32_e32 v5, 1, v5
		v_bitop3_b32 v5, v7, v5, 3 bitop3:0x78
		v_lshlrev_b32_e32 v5, 4, v5
		s_add_i32 m0, s37, 0x6000
		v_mov_b64_e32 v[8:9], 0
		v_mov_b64_e32 v[10:11], 0
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		v_add3_u32 v4, s11, v2, v3
		s_add_i32 m0, m0, 0x2000
		v_add3_u32 v7, s16, v2, v3
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		v_add3_u32 v4, s17, v2, v3
		s_add_i32 m0, m0, 0x2000
		v_add3_u32 v12, s32, v2, v3
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		v_add3_u32 v7, s33, v2, v3
		s_add_i32 m0, m0, 0x2000
		v_add3_u32 v13, s34, v2, v3
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		v_add3_u32 v4, s35, v2, v3
		s_add_i32 m0, m0, 0x2000
		s_nop 0
		buffer_load_dwordx4 v12, s[0:3], 0 offen lds
		s_mov_b32 s11, 2
		s_add_i32 m0, m0, 0x2000
		s_lshl_b32 s16, s38, 10
		buffer_load_dwordx4 v7, s[0:3], 0 offen lds
		v_add3_u32 v7, s39, v6, v5
		s_add_i32 m0, m0, 0x2000
		s_and_b32 s17, s36, 1
		buffer_load_dwordx4 v13, s[0:3], 0 offen lds
		s_lshr_b32 s32, s8, 1
		s_add_i32 m0, m0, 0x2000
		s_lshl_b32 s33, s14, 16
		buffer_load_dwordx4 v4, s[0:3], 0 offen lds
		s_add_i32 s34, s9, s33
		s_lshl_b32 s35, s32, 9
		s_add_i32 s36, s34, s35
		s_lshr_b32 s5, s5, 7
		s_lshl_b32 s5, s5, 9
		s_add_i32 s38, s9, 0x100
		s_add_i32 s38, s38, s33
		s_add_i32 s38, s38, s35
		v_and_b32_e32 v4, 0x7f, v0
		s_lshl_b32 s17, s17, 10
		s_add_i32 m0, s5, 0x26000
		v_lshl_add_u32 v12, v1, 2, s36
		buffer_load_dword v12, s[24:27], 0 offen lds
		v_lshl_add_u32 v12, v1, 2, s38
		s_add_i32 m0, m0, 0x100
		v_lshl_add_u32 v13, v4, 4, s34
		buffer_load_dword v12, s[24:27], 0 offen lds
		s_add_i32 s34, s17, 0x800
		s_lshl_b32 s36, s32, 12
		s_add_i32 m0, s17, 0x26800
		s_nop 0
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		v_add3_u32 v5, s36, v6, v5
		v_add_u32_e32 v5, 0x6000, v5
		ds_read_b128 v[12:15], v5
		ds_read_b128 v[16:19], v5 offset:1024
		ds_read_b128 v[20:23], v5 offset:2048
		ds_read_b128 v[24:27], v5 offset:3072
		v_add_u32_e32 v5, 0x6000, v7
		ds_read_b128 v[28:31], v5 offset:32768
		ds_read_b128 v[32:35], v5 offset:33792
		ds_read_b128 v[36:39], v5 offset:34816
		ds_read_b128 v[40:43], v5 offset:35840
		ds_read_b128 v[44:47], v5 offset:36864
		ds_read_b128 v[48:51], v5 offset:37888
		ds_read_b128 v[52:55], v5 offset:38912
		ds_read_b128 v[56:59], v5 offset:39936
		s_add_i32 s38, s35, 0x20000
		v_lshl_add_u32 v5, v1, 2, s38
		v_add_u32_e32 v5, 0x6000, v5
		ds_read_b32 v6, v5
		ds_read_b32 v7, v5 offset:256
		s_add_i32 s40, s16, 0x20000
		v_lshl_add_u32 v5, v1, 2, s40
		v_add_u32_e32 v5, 0x6000, v5
		ds_read_b32 v60, v5 offset:2048
		ds_read_b32 v61, v5 offset:2304
		ds_read_b32 v62, v5 offset:2560
		ds_read_b32 v63, v5 offset:2816
		s_add_i32 s40, s9, 0x80
		s_add_i32 s40, s40, s10
		v_add3_u32 v5, s40, v2, v3
		s_add_i32 s40, s9, 0x80080
		s_add_i32 s40, s40, s10
		s_add_i32 s41, s9, 0xc0
		s_add_i32 s41, s41, s10
		s_add_i32 s42, s9, 0x800c0
		s_add_i32 s42, s42, s10
		s_add_i32 s43, s19, 0x80
		s_add_i32 s43, s43, s10
		s_add_i32 s44, s19, 0x80080
		s_add_i32 s44, s44, s10
		s_add_i32 s45, s19, 0xc0
		s_add_i32 s45, s45, s10
		s_add_i32 s19, s19, 0x800c0
		s_add_i32 s10, s19, s10
		s_add_i32 m0, s37, 0x16000
		s_nop 0
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		v_add3_u32 v5, s40, v2, v3
		s_add_i32 m0, m0, 0x2000
		v_add3_u32 v64, s41, v2, v3
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		v_add3_u32 v5, s42, v2, v3
		s_add_i32 m0, m0, 0x2000
		v_add3_u32 v65, s43, v2, v3
		buffer_load_dwordx4 v64, s[20:23], 0 offen lds
		v_add3_u32 v64, s44, v2, v3
		s_add_i32 m0, m0, 0x2000
		v_add3_u32 v66, s45, v2, v3
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		v_add3_u32 v2, s10, v2, v3
		s_add_i32 m0, m0, 0x2000
		s_nop 0
		buffer_load_dwordx4 v65, s[0:3], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2000
		s_nop 0
		buffer_load_dwordx4 v64, s[0:3], 0 offen lds
		s_nop 0
		s_add_i32 m0, m0, 0x2000
		s_nop 0
		buffer_load_dwordx4 v66, s[0:3], 0 offen lds
		s_add_i32 s10, s12, 1
		s_add_i32 m0, m0, 0x2000
		s_add_i32 s19, s9, 0x800
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_add_i32 s19, s19, s33
		s_add_i32 s40, s19, s35
		s_add_i32 s9, s9, 0x900
		s_add_i32 s9, s9, s33
		s_add_i32 s9, s9, s35
		s_add_i32 m0, s5, 0x27000
		v_lshl_add_u32 v2, v1, 2, s40
		buffer_load_dword v2, s[24:27], 0 offen lds
		s_add_i32 s35, s5, 0x1000
		s_add_i32 m0, m0, 0x100
		v_lshl_add_u32 v1, v1, 2, s9
		buffer_load_dword v1, s[24:27], 0 offen lds
		v_lshl_add_u32 v1, v4, 4, s19
		s_add_i32 s19, s17, 0x1800
		s_add_i32 m0, s17, 0x27800
		s_nop 0
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		s_waitcnt vmcnt(0)
		s_barrier
		s_mov_b32 s9, 0
		s_mov_b32 s40, 0x10000
		s_mov_b32 s41, 0
		s_mul_i32 s42, s40, s8
		s_mul_hi_u32 s43, s40, s8
		s_mul_i32 s17, s40, s9
		s_add_i32 s43, s43, s17
		s_mul_i32 s17, s41, s8
		s_add_i32 s43, s43, s17
		v_mov_b32_e32 v2, s13
		v_mov_b32_e32 v3, 0
		s_mov_b32 s44, 0x100000
		s_mov_b32 s45, 0
		v_mov_b32_e32 v4, s44
		v_mov_b32_e32 v5, s45
		v_mul_lo_u32 v64, v4, v2
		v_mul_hi_u32 v65, v4, v2
		v_mul_lo_u32 v1, v4, v3
		v_add_u32_e32 v65, v65, v1
		v_mul_lo_u32 v1, v5, v2
		v_add_u32_e32 v65, v65, v1
		v_mov_b32_e32 v66, s42
		v_mov_b32_e32 v67, s43
		v_add_co_u32_e64 v68, vcc, v66, v64
		v_addc_co_u32_e64 v69, vcc, v67, v65, vcc
		s_mov_b32 s44, 1
		s_mov_b32 s45, 0
		v_mov_b32_e32 v1, v0
		v_mov_b32_e32 v2, 63
		v_and_b32_e32 v70, v1, v2
		v_and_b32_e32 v71, v3, v3
		v_mov_b32_e32 v72, s44
		v_mov_b32_e32 v73, s45
		v_mul_lo_u32 v74, v72, v70
		v_mul_hi_u32 v75, v72, v70
		v_mul_lo_u32 v2, v72, v71
		v_add_u32_e32 v75, v75, v2
		v_mul_lo_u32 v2, v73, v70
		v_add_u32_e32 v75, v75, v2
		v_lshrrev_b64 v[72:73], 2, v[74:75]
		s_mov_b32 s44, 0x1000
		s_mov_b32 s45, 0
		v_mov_b32_e32 v76, s44
		v_mov_b32_e32 v77, s45
		v_mul_lo_u32 v78, v76, v72
		v_mul_hi_u32 v79, v76, v72
		v_mul_lo_u32 v2, v76, v73
		v_add_u32_e32 v79, v79, v2
		v_mul_lo_u32 v2, v77, v72
		v_add_u32_e32 v79, v79, v2
		v_add_co_u32_e64 v72, vcc, v68, v78
		v_addc_co_u32_e64 v73, vcc, v69, v79, vcc
		v_lshrrev_b64 v[68:69], 3, v[74:75]
		v_mov_b32_e32 v2, 3
		v_and_b32_e32 v74, v68, v2
		v_and_b32_e32 v75, v69, v3
		v_and_b32_e32 v68, v70, v2
		v_and_b32_e32 v69, v71, v3
		v_xor_b32_e32 v2, v74, v68
		v_xor_b32_e32 v3, v75, v69
		s_mov_b32 s44, 16
		s_mov_b32 s45, 0
		v_mov_b32_e32 v68, s44
		v_mov_b32_e32 v69, s45
		v_mul_lo_u32 v74, v68, v2
		v_mul_hi_u32 v75, v68, v2
		v_mul_lo_u32 v76, v68, v3
		v_add_u32_e32 v75, v75, v76
		v_mul_lo_u32 v76, v69, v2
		v_add_u32_e32 v75, v75, v76
		v_add_co_u32_e64 v2, vcc, v72, v74
		v_addc_co_u32_e64 v3, vcc, v73, v75, vcc
		s_mov_b32 s44, 0x80
		s_mov_b32 s45, 0
		v_mov_b32_e32 v72, s44
		v_mov_b32_e32 v73, s45
		s_add_u32 s44, s42, 0x80000
		s_addc_u32 s45, s43, 0
		v_mov_b32_e32 v76, s44
		v_mov_b32_e32 v77, s45
		v_add_co_u32_e64 v80, vcc, v76, v64
		v_addc_co_u32_e64 v81, vcc, v77, v65, vcc
		v_add_co_u32_e64 v82, vcc, v80, v78
		v_addc_co_u32_e64 v83, vcc, v81, v79, vcc
		v_add_co_u32_e64 v80, vcc, v82, v74
		v_addc_co_u32_e64 v81, vcc, v83, v75, vcc
		s_add_u32 s44, s42, 64
		s_addc_u32 s45, s43, 0
		v_mov_b32_e32 v82, s44
		v_mov_b32_e32 v83, s45
		v_add_co_u32_e64 v84, vcc, v82, v64
		v_addc_co_u32_e64 v85, vcc, v83, v65, vcc
		v_add_co_u32_e64 v86, vcc, v84, v78
		v_addc_co_u32_e64 v87, vcc, v85, v79, vcc
		v_add_co_u32_e64 v84, vcc, v86, v74
		v_addc_co_u32_e64 v85, vcc, v87, v75, vcc
		s_add_u32 s44, s42, 0x80040
		s_addc_u32 s45, s43, 0
		v_mov_b32_e32 v86, s44
		v_mov_b32_e32 v87, s45
		v_add_co_u32_e64 v88, vcc, v86, v64
		v_addc_co_u32_e64 v89, vcc, v87, v65, vcc
		v_add_co_u32_e64 v90, vcc, v88, v78
		v_addc_co_u32_e64 v91, vcc, v89, v79, vcc
		v_add_co_u32_e64 v88, vcc, v90, v74
		v_addc_co_u32_e64 v89, vcc, v91, v75, vcc
		v_mov_b32_e32 v90, s14
		v_mov_b32_e32 v91, 0
		v_mul_lo_u32 v92, v4, v90
		v_mul_hi_u32 v93, v4, v90
		v_mul_lo_u32 v94, v4, v91
		v_add_u32_e32 v93, v93, v94
		v_mul_lo_u32 v94, v5, v90
		v_add_u32_e32 v93, v93, v94
		v_add_co_u32_e64 v4, vcc, v66, v92
		v_addc_co_u32_e64 v5, vcc, v67, v93, vcc
		v_add_co_u32_e64 v66, vcc, v4, v78
		v_addc_co_u32_e64 v67, vcc, v5, v79, vcc
		v_add_co_u32_e64 v4, vcc, v66, v74
		v_addc_co_u32_e64 v5, vcc, v67, v75, vcc
		v_add_co_u32_e64 v66, vcc, v76, v92
		v_addc_co_u32_e64 v67, vcc, v77, v93, vcc
		v_add_co_u32_e64 v76, vcc, v66, v78
		v_addc_co_u32_e64 v77, vcc, v67, v79, vcc
		v_add_co_u32_e64 v66, vcc, v76, v74
		v_addc_co_u32_e64 v67, vcc, v77, v75, vcc
		v_add_co_u32_e64 v76, vcc, v82, v92
		v_addc_co_u32_e64 v77, vcc, v83, v93, vcc
		v_add_co_u32_e64 v82, vcc, v76, v78
		v_addc_co_u32_e64 v83, vcc, v77, v79, vcc
		v_add_co_u32_e64 v76, vcc, v82, v74
		v_addc_co_u32_e64 v77, vcc, v83, v75, vcc
		v_add_co_u32_e64 v82, vcc, v86, v92
		v_addc_co_u32_e64 v83, vcc, v87, v93, vcc
		v_add_co_u32_e64 v86, vcc, v82, v78
		v_addc_co_u32_e64 v87, vcc, v83, v79, vcc
		v_add_co_u32_e64 v82, vcc, v86, v74
		v_addc_co_u32_e64 v83, vcc, v87, v75, vcc
		s_mov_b32 s44, 0x200
		s_mov_b32 s45, 0
		s_mov_b32 s33, s9
		s_mul_i32 s46, s44, s32
		s_mul_hi_u32 s47, s44, s32
		s_mul_i32 s9, s44, s33
		s_add_i32 s47, s47, s9
		s_mul_i32 s9, s45, s32
		s_add_i32 s47, s47, s9
		v_mov_b32_e32 v86, s46
		v_mov_b32_e32 v87, s47
		v_add_co_u32_e64 v94, vcc, v86, v64
		v_addc_co_u32_e64 v95, vcc, v87, v65, vcc
		v_mov_b32_e32 v86, s40
		v_mov_b32_e32 v87, s41
		v_mul_lo_u32 v96, v86, v90
		v_mul_hi_u32 v97, v86, v90
		v_mul_lo_u32 v98, v86, v91
		v_add_u32_e32 v97, v97, v98
		v_mul_lo_u32 v98, v87, v90
		v_add_u32_e32 v97, v97, v98
		v_add_co_u32_e64 v86, vcc, v94, v96
		v_addc_co_u32_e64 v87, vcc, v95, v97, vcc
		s_mov_b32 s32, 4
		s_mov_b32 s33, 0
		v_mov_b32_e32 v90, s32
		v_mov_b32_e32 v91, s33
		v_mul_lo_u32 v94, v90, v70
		v_mul_hi_u32 v95, v90, v70
		v_mul_lo_u32 v98, v90, v71
		v_add_u32_e32 v95, v95, v98
		v_mul_lo_u32 v98, v91, v70
		v_add_u32_e32 v95, v95, v98
		v_add_co_u32_e64 v90, vcc, v86, v94
		v_addc_co_u32_e64 v91, vcc, v87, v95, vcc
		s_mov_b32 s32, 0x800
		s_mov_b32 s33, 0
		s_add_u32 s40, s46, 0x100
		s_addc_u32 s41, s47, 0
		v_mov_b32_e32 v86, s40
		v_mov_b32_e32 v87, s41
		v_add_co_u32_e64 v98, vcc, v86, v64
		v_addc_co_u32_e64 v99, vcc, v87, v65, vcc
		v_add_co_u32_e64 v86, vcc, v98, v96
		v_addc_co_u32_e64 v87, vcc, v99, v97, vcc
		v_add_co_u32_e64 v98, vcc, v86, v94
		v_addc_co_u32_e64 v99, vcc, v87, v95, vcc
		v_add_co_u32_e64 v86, vcc, v64, v96
		v_addc_co_u32_e64 v87, vcc, v65, v97, vcc
		v_mov_b32_e32 v70, 0x7f
		v_and_b32_e32 v100, v1, v70
		v_mov_b32_e32 v101, v71
		v_mul_lo_u32 v70, v68, v100
		v_mul_hi_u32 v71, v68, v100
		v_mul_lo_u32 v1, v68, v101
		v_add_u32_e32 v71, v71, v1
		v_mul_lo_u32 v1, v69, v100
		v_add_u32_e32 v71, v71, v1
		v_add_co_u32_e64 v68, vcc, v86, v70
		v_addc_co_u32_e64 v69, vcc, v87, v71, vcc
		s_add_u32 s40, s42, 0x80
		s_addc_u32 s41, s43, 0
		v_mov_b32_e32 v86, s40
		v_mov_b32_e32 v87, s41
		v_add_co_u32_e64 v100, vcc, v86, v64
		v_addc_co_u32_e64 v101, vcc, v87, v65, vcc
		v_add_co_u32_e64 v102, vcc, v100, v78
		v_addc_co_u32_e64 v103, vcc, v101, v79, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v100, vcc, v102, v74
		v_addc_co_u32_e64 v101, vcc, v103, v75, vcc
		ds_write_addtid_b32 v100
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v101 offset:2048
		s_add_u32 s40, s42, 0x80080
		s_addc_u32 s41, s43, 0
		v_mov_b32_e32 v100, s40
		v_mov_b32_e32 v101, s41
		v_add_co_u32_e64 v102, vcc, v100, v64
		v_addc_co_u32_e64 v103, vcc, v101, v65, vcc
		v_add_co_u32_e64 v104, vcc, v102, v78
		v_addc_co_u32_e64 v105, vcc, v103, v79, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v102, vcc, v104, v74
		v_addc_co_u32_e64 v103, vcc, v105, v75, vcc
		ds_write_addtid_b32 v102 offset:4096
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v103 offset:6144
		s_add_u32 s40, s42, 0xc0
		s_addc_u32 s41, s43, 0
		v_mov_b32_e32 v102, s40
		v_mov_b32_e32 v103, s41
		v_add_co_u32_e64 v104, vcc, v102, v64
		v_addc_co_u32_e64 v105, vcc, v103, v65, vcc
		v_add_co_u32_e64 v106, vcc, v104, v78
		v_addc_co_u32_e64 v107, vcc, v105, v79, vcc
		s_mov_b32 m0, s15
		v_add_co_u32_e64 v104, vcc, v106, v74
		v_addc_co_u32_e64 v105, vcc, v107, v75, vcc
		ds_write_addtid_b32 v104 offset:8192
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v105 offset:10240
		s_add_u32 s40, s42, 0x800c0
		s_addc_u32 s41, s43, 0
		v_mov_b32_e32 v104, s40
		v_mov_b32_e32 v105, s41
		v_add_co_u32_e64 v106, vcc, v104, v64
		v_addc_co_u32_e64 v107, vcc, v105, v65, vcc
		v_add_co_u32_e64 v108, vcc, v106, v78
		v_addc_co_u32_e64 v109, vcc, v107, v79, vcc
		v_add_co_u32_e64 v106, vcc, v108, v74
		v_addc_co_u32_e64 v107, vcc, v109, v75, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v106, s9
		scratch_store_dword off, v107, s9 offset:4
		v_add_co_u32_e64 v106, vcc, v86, v92
		v_addc_co_u32_e64 v107, vcc, v87, v93, vcc
		v_add_co_u32_e64 v86, vcc, v106, v78
		v_addc_co_u32_e64 v87, vcc, v107, v79, vcc
		v_add_co_u32_e64 v106, vcc, v86, v74
		v_addc_co_u32_e64 v107, vcc, v87, v75, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v106, s9 offset:8
		scratch_store_dword off, v107, s9 offset:12
		v_add_co_u32_e64 v86, vcc, v100, v92
		v_addc_co_u32_e64 v87, vcc, v101, v93, vcc
		v_add_co_u32_e64 v100, vcc, v86, v78
		v_addc_co_u32_e64 v101, vcc, v87, v79, vcc
		v_add_co_u32_e64 v86, vcc, v100, v74
		v_addc_co_u32_e64 v87, vcc, v101, v75, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v86, s9 offset:16
		scratch_store_dword off, v87, s9 offset:20
		v_add_co_u32_e64 v86, vcc, v102, v92
		v_addc_co_u32_e64 v87, vcc, v103, v93, vcc
		v_add_co_u32_e64 v100, vcc, v86, v78
		v_addc_co_u32_e64 v101, vcc, v87, v79, vcc
		v_add_co_u32_e64 v86, vcc, v100, v74
		v_addc_co_u32_e64 v87, vcc, v101, v75, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v86, s9 offset:24
		scratch_store_dword off, v87, s9 offset:28
		v_add_co_u32_e64 v86, vcc, v104, v92
		v_addc_co_u32_e64 v87, vcc, v105, v93, vcc
		v_add_co_u32_e64 v92, vcc, v86, v78
		v_addc_co_u32_e64 v93, vcc, v87, v79, vcc
		v_add_co_u32_e64 v78, vcc, v92, v74
		v_addc_co_u32_e64 v79, vcc, v93, v75, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v78, s9 offset:32
		scratch_store_dword off, v79, s9 offset:36
		s_add_u32 s40, s46, 0x800
		s_addc_u32 s41, s47, 0
		v_mov_b32_e32 v74, s40
		v_mov_b32_e32 v75, s41
		v_add_co_u32_e64 v78, vcc, v74, v64
		v_addc_co_u32_e64 v79, vcc, v75, v65, vcc
		v_add_co_u32_e64 v74, vcc, v78, v96
		v_addc_co_u32_e64 v75, vcc, v79, v97, vcc
		v_add_co_u32_e64 v78, vcc, v74, v94
		v_addc_co_u32_e64 v79, vcc, v75, v95, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v78, s9 offset:40
		scratch_store_dword off, v79, s9 offset:44
		s_add_u32 s40, s46, 0x900
		s_addc_u32 s41, s47, 0
		v_mov_b32_e32 v74, s40
		v_mov_b32_e32 v75, s41
		v_add_co_u32_e64 v78, vcc, v74, v64
		v_addc_co_u32_e64 v79, vcc, v75, v65, vcc
		v_add_co_u32_e64 v74, vcc, v78, v96
		v_addc_co_u32_e64 v75, vcc, v79, v97, vcc
		v_add_co_u32_e64 v78, vcc, v74, v94
		v_addc_co_u32_e64 v79, vcc, v75, v95, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v78, s9 offset:48
		scratch_store_dword off, v79, s9 offset:52
		v_mov_b32_e32 v1, 0x800
		v_add_co_u32_e64 v74, vcc, v64, v1
		v_addc_co_u32_e64 v75, vcc, v65, 0, vcc
		v_add_co_u32_e64 v64, vcc, v74, v96
		v_addc_co_u32_e64 v65, vcc, v75, v97, vcc
		v_add_co_u32_e64 v74, vcc, v64, v70
		v_addc_co_u32_e64 v75, vcc, v65, v71, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v74, s9 offset:56
		scratch_store_dword off, v75, s9 offset:60
		v_mov_b32_e32 v64, s11
		v_mov_b32_e32 v65, 0
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
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
		v_mov_b32_e32 v64, s11
		v_mul_lo_u32 v70, v72, v64
		v_mul_hi_u32 v71, v72, v64
		v_mul_lo_u32 v1, v72, v65
		v_add_u32_e32 v71, v71, v1
		v_mul_lo_u32 v1, v73, v64
		v_add_u32_e32 v71, v71, v1
		v_add_co_u32_e64 v74, vcc, v2, v70
		v_addc_co_u32_e64 v75, vcc, v3, v71, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v74, s9 offset:64
		scratch_store_dword off, v75, s9 offset:68
		v_add_co_u32_e64 v74, vcc, v80, v70
		v_addc_co_u32_e64 v75, vcc, v81, v71, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v74, s9 offset:72
		scratch_store_dword off, v75, s9 offset:76
		v_add_co_u32_e64 v74, vcc, v84, v70
		v_addc_co_u32_e64 v75, vcc, v85, v71, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v74, s9 offset:80
		scratch_store_dword off, v75, s9 offset:84
		v_add_co_u32_e64 v74, vcc, v88, v70
		v_addc_co_u32_e64 v75, vcc, v89, v71, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v74, s9 offset:88
		scratch_store_dword off, v75, s9 offset:92
		v_add_co_u32_e64 v74, vcc, v4, v70
		v_addc_co_u32_e64 v75, vcc, v5, v71, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v74, s9 offset:96
		scratch_store_dword off, v75, s9 offset:100
		v_add_co_u32_e64 v74, vcc, v66, v70
		v_addc_co_u32_e64 v75, vcc, v67, v71, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v74, s9 offset:104
		scratch_store_dword off, v75, s9 offset:108
		v_add_co_u32_e64 v74, vcc, v76, v70
		v_addc_co_u32_e64 v75, vcc, v77, v71, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v74, s9 offset:112
		scratch_store_dword off, v75, s9 offset:116
		v_add_co_u32_e64 v74, vcc, v82, v70
		v_addc_co_u32_e64 v75, vcc, v83, v71, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v74, s9 offset:120
		scratch_store_dword off, v75, s9 offset:124
		v_mov_b32_e32 v74, s32
		v_mov_b32_e32 v75, s33
		v_mul_lo_u32 v78, v74, v64
		v_mul_hi_u32 v79, v74, v64
		v_mul_lo_u32 v1, v74, v65
		v_add_u32_e32 v79, v79, v1
		v_mul_lo_u32 v1, v75, v64
		v_add_u32_e32 v79, v79, v1
		s_mov_b32 s9, 0
		scratch_store_dword off, v78, s9 offset:152
		scratch_store_dword off, v79, s9 offset:156
		v_add_co_u32_e64 v74, vcc, v90, v78
		v_addc_co_u32_e64 v75, vcc, v91, v79, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v74, s9 offset:128
		scratch_store_dword off, v75, s9 offset:132
		v_add_co_u32_e64 v74, vcc, v98, v78
		v_addc_co_u32_e64 v75, vcc, v99, v79, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v74, s9 offset:136
		scratch_store_dword off, v75, s9 offset:140
		v_add_co_u32_e64 v74, vcc, v68, v78
		v_addc_co_u32_e64 v75, vcc, v69, v79, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v74, s9 offset:144
		scratch_store_dword off, v75, s9 offset:148
		s_waitcnt lgkmcnt(9)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[12:15], v[28:31], v[8:11], v6, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshr_b32 s9, s4, 6
		s_lshr_b32 s9, s9, 1
		s_lshl_b32 s9, s9, 12
		s_add_i32 s9, s9, 0x4000
		v_and_b32_e32 v1, 15, v0
		v_lshlrev_b32_e32 v74, 6, v1
		v_and_b32_e32 v75, 63, v0
		v_lshrrev_b32_e32 v75, 4, v75
		v_lshrrev_b32_e32 v1, 1, v1
		v_bitop3_b32 v1, v75, v1, 3 bitop3:0x78
		v_lshlrev_b32_e32 v1, 4, v1
		s_mov_b32 m0, s15
		v_add3_u32 v1, s9, v74, v1
		ds_write_addtid_b32 v1 offset:22528
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v1 offset:20480
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v1 offset:18432
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v1 offset:16384
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v1 offset:14336
		s_mov_b32 m0, s15
		s_nop 0
		ds_write_addtid_b32 v1 offset:12288
		v_add_u32_e32 v74, 0x6000, v1
		ds_read_b128 v[220:223], v74
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[12:15], v[32:35], v[92:95], v6, v60 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v1, 0x6000, v1
		ds_read_b128 v[224:227], v1 offset:1024
		s_waitcnt lgkmcnt(14)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[12:15], v[36:39], v[100:103], v6, v61 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v1 offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[12:15], v[40:43], v[104:107], v6, v61 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[232:235], v1 offset:3072
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[12:15], v[44:47], v[108:111], v6, v62 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshr_b32 s9, s4, 6
		s_and_b32 s9, s9, 1
		s_lshl_b32 s9, s9, 13
		s_add_i32 s9, s9, 0xc000
		v_and_b32_e32 v1, 15, v0
		v_lshlrev_b32_e32 v74, 6, v1
		v_and_b32_e32 v75, 63, v0
		v_lshrrev_b32_e32 v75, 4, v75
		v_lshrrev_b32_e32 v1, 1, v1
		v_bitop3_b32 v1, v75, v1, 3 bitop3:0x78
		v_lshlrev_b32_e32 v1, 4, v1
		v_add3_u32 v1, s9, v74, v1
		v_add_u32_e32 v1, 0x6000, v1
		ds_read_b128 v[236:239], v1
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s9 offset:160
		scratch_store_dword off, v237, s9 offset:164
		scratch_store_dword off, v238, s9 offset:168
		scratch_store_dword off, v239, s9 offset:172
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[12:15], v[48:51], v[112:115], v6, v62 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[236:239], v1 offset:1024
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s9 offset:176
		scratch_store_dword off, v237, s9 offset:180
		scratch_store_dword off, v238, s9 offset:184
		scratch_store_dword off, v239, s9 offset:188
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[12:15], v[52:55], v[116:119], v6, v63 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[236:239], v1 offset:2048
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s9 offset:192
		scratch_store_dword off, v237, s9 offset:196
		scratch_store_dword off, v238, s9 offset:200
		scratch_store_dword off, v239, s9 offset:204
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[12:15], v[56:59], v[120:123], v6, v63 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[12:15], v1 offset:3072
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v12, s9 offset:208
		scratch_store_dword off, v13, s9 offset:212
		scratch_store_dword off, v14, s9 offset:216
		scratch_store_dword off, v15, s9 offset:220
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[28:31], v[124:127], v6, v60 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[236:239], v1 offset:4096
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[32:35], v[128:131], v6, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v1 offset:5120
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[16:19], v[36:39], v[132:135], v6, v61 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[244:247], v1 offset:6144
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[40:43], v[136:139], v6, v61 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v1 offset:7168
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[16:19], v[44:47], v[140:143], v6, v62 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s37, 0x6000
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(38)
		scratch_load_dword v12, off, s9 offset:64
		scratch_load_dword v13, off, s9 offset:68
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[16:19], v[48:51], v[144:147], v6, v62 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(36)
		scratch_load_dword v12, off, s9 offset:72
		scratch_load_dword v13, off, s9 offset:76
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[16:19], v[52:55], v[148:151], v6, v63 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(34)
		scratch_load_dword v12, off, s9 offset:80
		scratch_load_dword v13, off, s9 offset:84
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[16:19], v[56:59], v[152:155], v6, v63 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(32)
		scratch_load_dword v12, off, s9 offset:88
		scratch_load_dword v13, off, s9 offset:92
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v12, s[20:23], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[28:31], v[156:159], v7, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(30)
		scratch_load_dword v12, off, s9 offset:96
		scratch_load_dword v13, off, s9 offset:100
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v12, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[32:35], v[160:163], v7, v60 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(28)
		scratch_load_dword v12, off, s9 offset:104
		scratch_load_dword v13, off, s9 offset:108
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v12, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[36:39], v[164:167], v7, v61 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(26)
		scratch_load_dword v12, off, s9 offset:112
		scratch_load_dword v13, off, s9 offset:116
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v12, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[40:43], v[168:171], v7, v61 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v12, off, s9 offset:120
		scratch_load_dword v13, off, s9 offset:124
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v12, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[44:47], v[172:175], v7, v62 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s5, 0x26000
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(20)
		scratch_load_dword v12, off, s9 offset:128
		scratch_load_dword v13, off, s9 offset:132
		s_waitcnt vmcnt(0)
		buffer_load_dword v12, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[20:23], v[48:51], v[176:179], v7, v62 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x100
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(18)
		scratch_load_dword v12, off, s9 offset:136
		scratch_load_dword v13, off, s9 offset:140
		s_waitcnt vmcnt(0)
		buffer_load_dword v12, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[20:23], v[52:55], v[180:183], v7, v63 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v12, off, s9 offset:144
		scratch_load_dword v13, off, s9 offset:148
		s_add_i32 m0, s34, 0x26000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[20:23], v[56:59], v[184:187], v7, v63 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt vmcnt(0)
		s_barrier
		s_lshr_b32 s9, s4, 6
		s_lshr_b32 s9, s9, 1
		s_lshl_b32 s9, s9, 12
		v_and_b32_e32 v1, 15, v0
		v_lshlrev_b32_e32 v12, 6, v1
		v_and_b32_e32 v13, 63, v0
		v_lshrrev_b32_e32 v13, 4, v13
		v_lshrrev_b32_e32 v1, 1, v1
		v_bitop3_b32 v1, v13, v1, 3 bitop3:0x78
		v_lshlrev_b32_e32 v1, 4, v1
		v_add3_u32 v1, s9, v12, v1
		v_add_u32_e32 v1, 0x6000, v1
		ds_read_b128 v[12:15], v1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[28:31], v[188:191], v7, v60 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[16:19], v1 offset:1024
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[32:35], v[192:195], v7, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v1 offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[36:39], v[196:199], v7, v61 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[28:31], v1 offset:3072
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v28, s9 offset:224
		scratch_store_dword off, v29, s9 offset:228
		scratch_store_dword off, v30, s9 offset:232
		scratch_store_dword off, v31, s9 offset:236
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[40:43], v[200:203], v7, v61 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshr_b32 s9, s4, 6
		s_and_b32 s9, s9, 1
		s_lshl_b32 s9, s9, 13
		s_add_i32 s9, s9, 0x8000
		v_and_b32_e32 v1, 15, v0
		v_lshlrev_b32_e32 v28, 6, v1
		v_and_b32_e32 v29, 63, v0
		v_lshrrev_b32_e32 v29, 4, v29
		v_lshrrev_b32_e32 v1, 1, v1
		v_bitop3_b32 v1, v29, v1, 3 bitop3:0x78
		v_lshlrev_b32_e32 v1, 4, v1
		v_add3_u32 v1, s9, v28, v1
		v_add_u32_e32 v1, 0x6000, v1
		ds_read_b128 v[28:31], v1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[44:47], v[204:207], v7, v62 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[32:35], v1 offset:1024
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], v[48:51], v[208:211], v7, v62 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[36:39], v1 offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[24:27], v[52:55], v[212:215], v7, v63 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[40:43], v1 offset:3072
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[24:27], v[56:59], v[216:219], v7, v63 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[44:47], v1 offset:4096
		ds_read_b128 v[48:51], v1 offset:5120
		ds_read_b128 v[52:55], v1 offset:6144
		ds_read_b128 v[56:59], v1 offset:7168
		s_lshr_b32 s9, s4, 6
		s_lshr_b32 s9, s9, 1
		s_lshl_b32 s9, s9, 7
		v_and_b32_e32 v1, 63, v0
		v_add_lshl_u32 v1, s9, v1, 2
		v_add_u32_e32 v1, 0x20000, v1
		v_add_u32_e32 v1, 0x6000, v1
		ds_read_b32 v24, v1
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v24, s9 offset:240
		ds_read_b32 v24, v1 offset:256
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v24, s9 offset:244
		s_lshr_b32 s9, s4, 6
		s_and_b32 s9, s9, 1
		s_lshl_b32 s9, s9, 8
		s_add_i32 s9, s9, 0x200
		v_and_b32_e32 v1, 63, v0
		v_add_lshl_u32 v1, s9, v1, 2
		v_add_u32_e32 v1, 0x20000, v1
		v_add_u32_e32 v1, 0x6000, v1
		ds_read_b32 v24, v1
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v24, s9 offset:248
		ds_read_b32 v24, v1 offset:256
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v24, s9 offset:252
		ds_read_b32 v24, v1 offset:512
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v24, s9 offset:256
		ds_read_b32 v24, v1 offset:768
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v24, s9 offset:260
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(22)
		scratch_load_dword v24, off, s9 offset:160
		scratch_load_dword v25, off, s9 offset:164
		scratch_load_dword v26, off, s9 offset:168
		scratch_load_dword v27, off, s9 offset:172
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[220:223], v[24:27], v[8:11], v6, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(18)
		scratch_load_dword v24, off, s9 offset:176
		scratch_load_dword v25, off, s9 offset:180
		scratch_load_dword v26, off, s9 offset:184
		scratch_load_dword v27, off, s9 offset:188
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[220:223], v[24:27], v[92:95], v6, v60 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v24, off, s9 offset:176
		scratch_load_dword v25, off, s9 offset:180
		scratch_load_dword v26, off, s9 offset:184
		scratch_load_dword v27, off, s9 offset:188
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[224:227], v[24:27], v[128:131], v6, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v24, off, s9 offset:160
		scratch_load_dword v25, off, s9 offset:164
		scratch_load_dword v26, off, s9 offset:168
		scratch_load_dword v27, off, s9 offset:172
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[224:227], v[24:27], v[124:127], v6, v60 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(14)
		scratch_load_dword v24, off, s9 offset:192
		scratch_load_dword v25, off, s9 offset:196
		scratch_load_dword v26, off, s9 offset:200
		scratch_load_dword v27, off, s9 offset:204
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[224:227], v[24:27], v[132:135], v6, v61 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v24, off, s9 offset:192
		scratch_load_dword v25, off, s9 offset:196
		scratch_load_dword v26, off, s9 offset:200
		scratch_load_dword v27, off, s9 offset:204
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[220:223], v[24:27], v[100:103], v6, v61 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(10)
		scratch_load_dword v24, off, s9 offset:208
		scratch_load_dword v25, off, s9 offset:212
		scratch_load_dword v26, off, s9 offset:216
		scratch_load_dword v27, off, s9 offset:220
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[220:223], v[24:27], v[104:107], v6, v61 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v24, off, s9 offset:208
		scratch_load_dword v25, off, s9 offset:212
		scratch_load_dword v26, off, s9 offset:216
		scratch_load_dword v27, off, s9 offset:220
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[224:227], v[24:27], v[136:139], v6, v61 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[224:227], v[236:239], v[140:143], v6, v62 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[220:223], v[236:239], v[108:111], v6, v62 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[220:223], v[240:243], v[112:115], v6, v62 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[224:227], v[240:243], v[144:147], v6, v62 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[224:227], v[244:247], v[148:151], v6, v63 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[220:223], v[244:247], v[116:119], v6, v63 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[220:223], v[248:251], v[120:123], v6, v63 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[224:227], v[248:251], v[152:155], v6, v63 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[228:231], v[248:251], v[184:187], v7, v63 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[228:231], v[244:247], v[180:183], v7, v63 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[232:235], v[244:247], v[212:215], v7, v63 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[232:235], v[248:251], v[216:219], v7, v63 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v24, off, s9 offset:160
		scratch_load_dword v25, off, s9 offset:164
		scratch_load_dword v26, off, s9 offset:168
		scratch_load_dword v27, off, s9 offset:172
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[232:235], v[24:27], v[188:191], v7, v60 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v24, off, s9 offset:160
		scratch_load_dword v25, off, s9 offset:164
		scratch_load_dword v26, off, s9 offset:168
		scratch_load_dword v27, off, s9 offset:172
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[228:231], v[24:27], v[156:159], v7, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v24, off, s9 offset:176
		scratch_load_dword v25, off, s9 offset:180
		scratch_load_dword v26, off, s9 offset:184
		scratch_load_dword v27, off, s9 offset:188
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[228:231], v[24:27], v[160:163], v7, v60 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v24, off, s9 offset:176
		scratch_load_dword v25, off, s9 offset:180
		scratch_load_dword v26, off, s9 offset:184
		scratch_load_dword v27, off, s9 offset:188
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[232:235], v[24:27], v[192:195], v7, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v24, off, s9 offset:192
		scratch_load_dword v25, off, s9 offset:196
		scratch_load_dword v26, off, s9 offset:200
		scratch_load_dword v27, off, s9 offset:204
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[232:235], v[24:27], v[196:199], v7, v61 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v24, off, s9 offset:192
		scratch_load_dword v25, off, s9 offset:196
		scratch_load_dword v26, off, s9 offset:200
		scratch_load_dword v27, off, s9 offset:204
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[228:231], v[24:27], v[164:167], v7, v61 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v24, off, s9 offset:208
		scratch_load_dword v25, off, s9 offset:212
		scratch_load_dword v26, off, s9 offset:216
		scratch_load_dword v27, off, s9 offset:220
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[228:231], v[24:27], v[168:171], v7, v61 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v24, off, s9 offset:208
		scratch_load_dword v25, off, s9 offset:212
		scratch_load_dword v26, off, s9 offset:216
		scratch_load_dword v27, off, s9 offset:220
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[232:235], v[24:27], v[200:203], v7, v61 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[232:235], v[236:239], v[204:207], v7, v62 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[228:231], v[236:239], v[172:175], v7, v62 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[228:231], v[240:243], v[176:179], v7, v62 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[232:235], v[240:243], v[208:211], v7, v62 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_lshr_b32 s9, s4, 6
		s_lshr_b32 s9, s9, 1
		s_lshl_b32 s9, s9, 12
		s_add_i32 s9, s9, 0x10000
		v_and_b32_e32 v1, 15, v0
		v_lshlrev_b32_e32 v6, 6, v1
		v_and_b32_e32 v7, 63, v0
		v_lshrrev_b32_e32 v7, 4, v7
		v_lshrrev_b32_e32 v1, 1, v1
		v_bitop3_b32 v1, v7, v1, 3 bitop3:0x78
		v_lshlrev_b32_e32 v1, 4, v1
		v_add3_u32 v1, s9, v6, v1
		v_add_u32_e32 v1, 0x6000, v1
		s_mov_b32 s9, 0
		scratch_store_dword off, v1, s9 offset:264
		ds_read_b128 v[24:27], v1
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v24, s9 offset:436
		scratch_store_dword off, v25, s9 offset:440
		scratch_store_dword off, v26, s9 offset:444
		scratch_store_dword off, v27, s9 offset:448
		ds_read_b128 v[60:63], v1 offset:1024
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v60, s9 offset:568
		scratch_store_dword off, v61, s9 offset:572
		scratch_store_dword off, v62, s9 offset:576
		scratch_store_dword off, v63, s9 offset:580
		ds_read_b128 v[220:223], v1 offset:2048
		ds_read_b128 v[224:227], v1 offset:3072
		s_lshr_b32 s9, s4, 6
		s_and_b32 s9, s9, 1
		s_lshl_b32 s9, s9, 13
		s_add_i32 s9, s9, 0x18000
		v_and_b32_e32 v1, 15, v0
		v_lshlrev_b32_e32 v6, 6, v1
		v_and_b32_e32 v7, 63, v0
		v_lshrrev_b32_e32 v7, 4, v7
		v_lshrrev_b32_e32 v1, 1, v1
		v_bitop3_b32 v1, v7, v1, 3 bitop3:0x78
		v_lshlrev_b32_e32 v1, 4, v1
		v_add3_u32 v1, s9, v6, v1
		v_add_u32_e32 v6, 0x6000, v1
		ds_read_b128 v[228:231], v6
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s9 offset:268
		scratch_store_dword off, v229, s9 offset:272
		scratch_store_dword off, v230, s9 offset:276
		scratch_store_dword off, v231, s9 offset:280
		ds_read_b128 v[228:231], v6 offset:1024
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s9 offset:284
		scratch_store_dword off, v229, s9 offset:288
		scratch_store_dword off, v230, s9 offset:292
		scratch_store_dword off, v231, s9 offset:296
		ds_read_b128 v[228:231], v6 offset:2048
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s9 offset:388
		scratch_store_dword off, v229, s9 offset:392
		scratch_store_dword off, v230, s9 offset:396
		scratch_store_dword off, v231, s9 offset:400
		ds_read_b128 v[228:231], v6 offset:3072
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s9 offset:404
		scratch_store_dword off, v229, s9 offset:408
		scratch_store_dword off, v230, s9 offset:412
		scratch_store_dword off, v231, s9 offset:416
		ds_read_b128 v[228:231], v6 offset:4096
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s9 offset:420
		scratch_store_dword off, v229, s9 offset:424
		scratch_store_dword off, v230, s9 offset:428
		scratch_store_dword off, v231, s9 offset:432
		ds_read_b128 v[228:231], v6 offset:5120
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s9 offset:452
		scratch_store_dword off, v229, s9 offset:456
		scratch_store_dword off, v230, s9 offset:460
		scratch_store_dword off, v231, s9 offset:464
		v_add_u32_e32 v1, 0x6000, v1
		s_mov_b32 s9, 0
		scratch_store_dword off, v1, s9 offset:516
		ds_read_b128 v[228:231], v1 offset:6144
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s9 offset:468
		scratch_store_dword off, v229, s9 offset:472
		scratch_store_dword off, v230, s9 offset:476
		scratch_store_dword off, v231, s9 offset:480
		ds_read_b128 v[228:231], v1 offset:7168
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s9 offset:484
		scratch_store_dword off, v229, s9 offset:488
		scratch_store_dword off, v230, s9 offset:492
		scratch_store_dword off, v231, s9 offset:496
		s_lshr_b32 s9, s4, 6
		s_lshr_b32 s9, s9, 1
		s_lshl_b32 s9, s9, 7
		s_add_i32 s9, s9, 0x400
		v_and_b32_e32 v6, 63, v0
		v_add_lshl_u32 v6, s9, v6, 2
		v_add_u32_e32 v6, 0x20000, v6
		v_add_u32_e32 v6, 0x6000, v6
		ds_read_b32 v7, v6
		ds_read_b32 v74, v6 offset:256
		s_lshr_b32 s9, s4, 6
		s_and_b32 s9, s9, 1
		s_lshl_b32 s9, s9, 8
		s_add_i32 s9, s9, 0x600
		v_and_b32_e32 v6, 63, v0
		v_add_lshl_u32 v6, s9, v6, 2
		v_add_u32_e32 v6, 0x20000, v6
		v_add_u32_e32 v6, 0x6000, v6
		ds_read_b32 v75, v6
		ds_read_b32 v78, v6 offset:256
		ds_read_b32 v79, v6 offset:512
		ds_read_b32 v86, v6 offset:768
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v96
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v97 offset:2048
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v228, vcc, v96, v70
		v_addc_co_u32_e64 v229, vcc, v97, v71, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v228, s9 offset:300
		scratch_store_dword off, v229, s9 offset:304
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v96 offset:4096
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v97 offset:6144
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v228, vcc, v96, v70
		v_addc_co_u32_e64 v229, vcc, v97, v71, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v228, s9 offset:308
		scratch_store_dword off, v229, s9 offset:312
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v96 offset:8192
		s_mov_b32 m0, s15
		s_nop 0
		ds_read_addtid_b32 v97 offset:10240
		s_waitcnt lgkmcnt(0)
		v_add_co_u32_e64 v228, vcc, v96, v70
		v_addc_co_u32_e64 v229, vcc, v97, v71, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v228, s9 offset:316
		scratch_store_dword off, v229, s9 offset:320
		s_mov_b32 s9, 0
		scratch_load_dword v96, off, s9
		scratch_load_dword v97, off, s9 offset:4
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v228, vcc, v96, v70
		v_addc_co_u32_e64 v229, vcc, v97, v71, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v228, s9 offset:324
		scratch_store_dword off, v229, s9 offset:328
		s_mov_b32 s9, 0
		scratch_load_dword v96, off, s9 offset:8
		scratch_load_dword v97, off, s9 offset:12
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v228, vcc, v96, v70
		v_addc_co_u32_e64 v229, vcc, v97, v71, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v228, s9 offset:332
		scratch_store_dword off, v229, s9 offset:336
		s_mov_b32 s9, 0
		scratch_load_dword v96, off, s9 offset:16
		scratch_load_dword v97, off, s9 offset:20
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v228, vcc, v96, v70
		v_addc_co_u32_e64 v229, vcc, v97, v71, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v228, s9 offset:340
		scratch_store_dword off, v229, s9 offset:344
		s_mov_b32 s9, 0
		scratch_load_dword v96, off, s9 offset:24
		scratch_load_dword v97, off, s9 offset:28
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v228, vcc, v96, v70
		v_addc_co_u32_e64 v229, vcc, v97, v71, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v228, s9 offset:348
		scratch_store_dword off, v229, s9 offset:352
		s_mov_b32 s9, 0
		scratch_load_dword v96, off, s9 offset:32
		scratch_load_dword v97, off, s9 offset:36
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v228, vcc, v96, v70
		v_addc_co_u32_e64 v229, vcc, v97, v71, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v228, s9 offset:356
		scratch_store_dword off, v229, s9 offset:360
		s_mov_b32 s9, 0
		scratch_load_dword v70, off, s9 offset:40
		scratch_load_dword v71, off, s9 offset:44
		s_mov_b32 s9, 0
		scratch_load_dword v96, off, s9 offset:152
		scratch_load_dword v97, off, s9 offset:156
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v228, vcc, v70, v96
		v_addc_co_u32_e64 v229, vcc, v71, v97, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v228, s9 offset:364
		scratch_store_dword off, v229, s9 offset:368
		s_mov_b32 s9, 0
		scratch_load_dword v70, off, s9 offset:48
		scratch_load_dword v71, off, s9 offset:52
		s_mov_b32 s9, 0
		scratch_load_dword v96, off, s9 offset:152
		scratch_load_dword v97, off, s9 offset:156
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v228, vcc, v70, v96
		v_addc_co_u32_e64 v229, vcc, v71, v97, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v228, s9 offset:372
		scratch_store_dword off, v229, s9 offset:376
		s_mov_b32 s9, 0
		scratch_load_dword v70, off, s9 offset:56
		scratch_load_dword v71, off, s9 offset:60
		s_mov_b32 s9, 0
		scratch_load_dword v96, off, s9 offset:152
		scratch_load_dword v97, off, s9 offset:156
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v228, vcc, v70, v96
		v_addc_co_u32_e64 v229, vcc, v71, v97, vcc
		s_mov_b32 s9, 0
		scratch_store_dword off, v228, s9 offset:380
		scratch_store_dword off, v229, s9 offset:384
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(51)
		scratch_load_dword v228, off, s9 offset:268
		scratch_load_dword v229, off, s9 offset:272
		scratch_load_dword v230, off, s9 offset:276
		scratch_load_dword v231, off, s9 offset:280
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[24:27], v[228:231], v[8:11], v7, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v6, off, s9 offset:264
		s_waitcnt vmcnt(0)
		ds_read_b128 v[228:231], v6 offset:16384
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(47)
		scratch_load_dword v232, off, s9 offset:284
		scratch_load_dword v233, off, s9 offset:288
		scratch_load_dword v234, off, s9 offset:292
		scratch_load_dword v235, off, s9 offset:296
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[24:27], v[232:235], v[92:95], v7, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v6, off, s9 offset:264
		s_waitcnt vmcnt(0)
		ds_read_b128 v[232:235], v6 offset:17408
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(43)
		scratch_load_dword v236, off, s9 offset:388
		scratch_load_dword v237, off, s9 offset:392
		scratch_load_dword v238, off, s9 offset:396
		scratch_load_dword v239, off, s9 offset:400
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[24:27], v[236:239], v[100:103], v7, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v6, off, s9 offset:264
		s_waitcnt vmcnt(0)
		ds_read_b128 v[236:239], v6 offset:18432
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(39)
		scratch_load_dword v240, off, s9 offset:404
		scratch_load_dword v241, off, s9 offset:408
		scratch_load_dword v242, off, s9 offset:412
		scratch_load_dword v243, off, s9 offset:416
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[24:27], v[240:243], v[104:107], v7, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v6, off, s9 offset:264
		s_waitcnt vmcnt(0)
		ds_read_b128 v[24:27], v6 offset:19456
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(35)
		scratch_load_dword v240, off, s9 offset:420
		scratch_load_dword v241, off, s9 offset:424
		scratch_load_dword v242, off, s9 offset:428
		scratch_load_dword v243, off, s9 offset:432
		s_mov_b32 s9, 0
		scratch_load_dword v244, off, s9 offset:436
		scratch_load_dword v245, off, s9 offset:440
		scratch_load_dword v246, off, s9 offset:444
		scratch_load_dword v247, off, s9 offset:448
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[244:247], v[240:243], v[108:111], v7, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v1 offset:16384
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v240, s9 offset:500
		scratch_store_dword off, v241, s9 offset:504
		scratch_store_dword off, v242, s9 offset:508
		scratch_store_dword off, v243, s9 offset:512
		s_mov_b32 s9, 0
		scratch_load_dword v240, off, s9 offset:436
		scratch_load_dword v241, off, s9 offset:440
		scratch_load_dword v242, off, s9 offset:444
		scratch_load_dword v243, off, s9 offset:448
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(35)
		scratch_load_dword v244, off, s9 offset:452
		scratch_load_dword v245, off, s9 offset:456
		scratch_load_dword v246, off, s9 offset:460
		scratch_load_dword v247, off, s9 offset:464
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[240:243], v[244:247], v[112:115], v7, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v1 offset:17408
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v240, s9 offset:520
		scratch_store_dword off, v241, s9 offset:524
		scratch_store_dword off, v242, s9 offset:528
		scratch_store_dword off, v243, s9 offset:532
		s_mov_b32 s9, 0
		scratch_load_dword v240, off, s9 offset:436
		scratch_load_dword v241, off, s9 offset:440
		scratch_load_dword v242, off, s9 offset:444
		scratch_load_dword v243, off, s9 offset:448
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(34)
		scratch_load_dword v244, off, s9 offset:468
		scratch_load_dword v245, off, s9 offset:472
		scratch_load_dword v246, off, s9 offset:476
		scratch_load_dword v247, off, s9 offset:480
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[240:243], v[244:247], v[116:119], v7, v86 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v1 offset:18432
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v240, s9 offset:536
		scratch_store_dword off, v241, s9 offset:540
		scratch_store_dword off, v242, s9 offset:544
		scratch_store_dword off, v243, s9 offset:548
		s_mov_b32 s9, 0
		scratch_load_dword v240, off, s9 offset:436
		scratch_load_dword v241, off, s9 offset:440
		scratch_load_dword v242, off, s9 offset:444
		scratch_load_dword v243, off, s9 offset:448
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(34)
		scratch_load_dword v244, off, s9 offset:484
		scratch_load_dword v245, off, s9 offset:488
		scratch_load_dword v246, off, s9 offset:492
		scratch_load_dword v247, off, s9 offset:496
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[240:243], v[244:247], v[120:123], v7, v86 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v1 offset:19456
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v240, s9 offset:552
		scratch_store_dword off, v241, s9 offset:556
		scratch_store_dword off, v242, s9 offset:560
		scratch_store_dword off, v243, s9 offset:564
		s_mov_b32 s9, 0
		scratch_load_dword v240, off, s9 offset:268
		scratch_load_dword v241, off, s9 offset:272
		scratch_load_dword v242, off, s9 offset:276
		scratch_load_dword v243, off, s9 offset:280
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[60:63], v[240:243], v[124:127], v7, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v1 offset:20480
		s_mov_b32 s9, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v240, s9 offset:584
		scratch_store_dword off, v241, s9 offset:588
		scratch_store_dword off, v242, s9 offset:592
		scratch_store_dword off, v243, s9 offset:596
		s_mov_b32 s9, 0
		scratch_load_dword v240, off, s9 offset:284
		scratch_load_dword v241, off, s9 offset:288
		scratch_load_dword v242, off, s9 offset:292
		scratch_load_dword v243, off, s9 offset:296
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[60:63], v[240:243], v[128:131], v7, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v1, off, s9 offset:516
		s_waitcnt vmcnt(0)
		ds_read_b128 v[240:243], v1 offset:21504
		s_mov_b32 s9, 0
		scratch_load_dword v244, off, s9 offset:388
		scratch_load_dword v245, off, s9 offset:392
		scratch_load_dword v246, off, s9 offset:396
		scratch_load_dword v247, off, s9 offset:400
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[60:63], v[244:247], v[132:135], v7, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v1, off, s9 offset:516
		s_waitcnt vmcnt(0)
		ds_read_b128 v[244:247], v1 offset:22528
		s_mov_b32 s9, 0
		scratch_load_dword v248, off, s9 offset:404
		scratch_load_dword v249, off, s9 offset:408
		scratch_load_dword v250, off, s9 offset:412
		scratch_load_dword v251, off, s9 offset:416
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[60:63], v[248:251], v[136:139], v7, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v1, off, s9 offset:516
		s_waitcnt vmcnt(0)
		ds_read_b128 v[60:63], v1 offset:23552
		s_mov_b32 s9, 0
		scratch_load_dword v248, off, s9 offset:420
		scratch_load_dword v249, off, s9 offset:424
		scratch_load_dword v250, off, s9 offset:428
		scratch_load_dword v251, off, s9 offset:432
		s_mov_b32 s9, 0
		scratch_load_dword v252, off, s9 offset:568
		scratch_load_dword v253, off, s9 offset:572
		scratch_load_dword v254, off, s9 offset:576
		scratch_load_dword v255, off, s9 offset:580
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[252:255], v[248:251], v[140:143], v7, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s37, 0x16000
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(40)
		scratch_load_dword v70, off, s9 offset:300
		scratch_load_dword v71, off, s9 offset:304
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v70, s[20:23], 0 offen lds
		s_mov_b32 s9, 0
		scratch_load_dword v248, off, s9 offset:452
		scratch_load_dword v249, off, s9 offset:456
		scratch_load_dword v250, off, s9 offset:460
		scratch_load_dword v251, off, s9 offset:464
		s_mov_b32 s9, 0
		scratch_load_dword v252, off, s9 offset:568
		scratch_load_dword v253, off, s9 offset:572
		scratch_load_dword v254, off, s9 offset:576
		scratch_load_dword v255, off, s9 offset:580
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[252:255], v[248:251], v[144:147], v7, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(38)
		scratch_load_dword v70, off, s9 offset:308
		scratch_load_dword v71, off, s9 offset:312
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v70, s[20:23], 0 offen lds
		s_mov_b32 s9, 0
		scratch_load_dword v248, off, s9 offset:468
		scratch_load_dword v249, off, s9 offset:472
		scratch_load_dword v250, off, s9 offset:476
		scratch_load_dword v251, off, s9 offset:480
		s_mov_b32 s9, 0
		scratch_load_dword v252, off, s9 offset:568
		scratch_load_dword v253, off, s9 offset:572
		scratch_load_dword v254, off, s9 offset:576
		scratch_load_dword v255, off, s9 offset:580
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[252:255], v[248:251], v[148:151], v7, v86 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(36)
		scratch_load_dword v70, off, s9 offset:316
		scratch_load_dword v71, off, s9 offset:320
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v70, s[20:23], 0 offen lds
		s_mov_b32 s9, 0
		scratch_load_dword v248, off, s9 offset:484
		scratch_load_dword v249, off, s9 offset:488
		scratch_load_dword v250, off, s9 offset:492
		scratch_load_dword v251, off, s9 offset:496
		s_mov_b32 s9, 0
		scratch_load_dword v252, off, s9 offset:568
		scratch_load_dword v253, off, s9 offset:572
		scratch_load_dword v254, off, s9 offset:576
		scratch_load_dword v255, off, s9 offset:580
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[252:255], v[248:251], v[152:155], v7, v86 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(34)
		scratch_load_dword v70, off, s9 offset:324
		scratch_load_dword v71, off, s9 offset:328
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v70, s[20:23], 0 offen lds
		s_mov_b32 s9, 0
		scratch_load_dword v248, off, s9 offset:268
		scratch_load_dword v249, off, s9 offset:272
		scratch_load_dword v250, off, s9 offset:276
		scratch_load_dword v251, off, s9 offset:280
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[220:223], v[248:251], v[156:159], v74, v75 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(32)
		scratch_load_dword v70, off, s9 offset:332
		scratch_load_dword v71, off, s9 offset:336
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v70, s[0:3], 0 offen lds
		s_mov_b32 s9, 0
		scratch_load_dword v248, off, s9 offset:284
		scratch_load_dword v249, off, s9 offset:288
		scratch_load_dword v250, off, s9 offset:292
		scratch_load_dword v251, off, s9 offset:296
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[220:223], v[248:251], v[160:163], v74, v75 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(30)
		scratch_load_dword v70, off, s9 offset:340
		scratch_load_dword v71, off, s9 offset:344
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v70, s[0:3], 0 offen lds
		s_mov_b32 s9, 0
		scratch_load_dword v248, off, s9 offset:388
		scratch_load_dword v249, off, s9 offset:392
		scratch_load_dword v250, off, s9 offset:396
		scratch_load_dword v251, off, s9 offset:400
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[220:223], v[248:251], v[164:167], v74, v78 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(28)
		scratch_load_dword v70, off, s9 offset:348
		scratch_load_dword v71, off, s9 offset:352
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v70, s[0:3], 0 offen lds
		s_mov_b32 s9, 0
		scratch_load_dword v248, off, s9 offset:404
		scratch_load_dword v249, off, s9 offset:408
		scratch_load_dword v250, off, s9 offset:412
		scratch_load_dword v251, off, s9 offset:416
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[220:223], v[248:251], v[168:171], v74, v78 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x2000
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(26)
		scratch_load_dword v70, off, s9 offset:356
		scratch_load_dword v71, off, s9 offset:360
		s_waitcnt vmcnt(0)
		buffer_load_dwordx4 v70, s[0:3], 0 offen lds
		s_mov_b32 s9, 0
		scratch_load_dword v248, off, s9 offset:420
		scratch_load_dword v249, off, s9 offset:424
		scratch_load_dword v250, off, s9 offset:428
		scratch_load_dword v251, off, s9 offset:432
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[220:223], v[248:251], v[172:175], v74, v79 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, s35, 0x26000
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v70, off, s9 offset:364
		scratch_load_dword v71, off, s9 offset:368
		s_waitcnt vmcnt(0)
		buffer_load_dword v70, s[24:27], 0 offen lds
		s_mov_b32 s9, 0
		scratch_load_dword v248, off, s9 offset:452
		scratch_load_dword v249, off, s9 offset:456
		scratch_load_dword v250, off, s9 offset:460
		scratch_load_dword v251, off, s9 offset:464
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[220:223], v[248:251], v[176:179], v74, v79 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 m0, m0, 0x100
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(22)
		scratch_load_dword v70, off, s9 offset:372
		scratch_load_dword v71, off, s9 offset:376
		s_waitcnt vmcnt(0)
		buffer_load_dword v70, s[24:27], 0 offen lds
		s_mov_b32 s9, 0
		scratch_load_dword v248, off, s9 offset:468
		scratch_load_dword v249, off, s9 offset:472
		scratch_load_dword v250, off, s9 offset:476
		scratch_load_dword v251, off, s9 offset:480
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[220:223], v[248:251], v[180:183], v74, v86 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(20)
		scratch_load_dword v70, off, s9 offset:380
		scratch_load_dword v71, off, s9 offset:384
		s_add_i32 m0, s19, 0x26000
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v70, s[28:31], 0 offen lds
		s_mov_b32 s9, 0
		scratch_load_dword v248, off, s9 offset:484
		scratch_load_dword v249, off, s9 offset:488
		scratch_load_dword v250, off, s9 offset:492
		scratch_load_dword v251, off, s9 offset:496
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[220:223], v[248:251], v[184:187], v74, v86 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v220, off, s9 offset:484
		scratch_load_dword v221, off, s9 offset:488
		scratch_load_dword v222, off, s9 offset:492
		scratch_load_dword v223, off, s9 offset:496
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[224:227], v[220:223], v[216:219], v74, v86 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v220, off, s9 offset:468
		scratch_load_dword v221, off, s9 offset:472
		scratch_load_dword v222, off, s9 offset:476
		scratch_load_dword v223, off, s9 offset:480
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[224:227], v[220:223], v[212:215], v74, v86 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v220, off, s9 offset:268
		scratch_load_dword v221, off, s9 offset:272
		scratch_load_dword v222, off, s9 offset:276
		scratch_load_dword v223, off, s9 offset:280
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[224:227], v[220:223], v[188:191], v74, v75 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v220, off, s9 offset:284
		scratch_load_dword v221, off, s9 offset:288
		scratch_load_dword v222, off, s9 offset:292
		scratch_load_dword v223, off, s9 offset:296
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[224:227], v[220:223], v[192:195], v74, v75 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v220, off, s9 offset:388
		scratch_load_dword v221, off, s9 offset:392
		scratch_load_dword v222, off, s9 offset:396
		scratch_load_dword v223, off, s9 offset:400
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[224:227], v[220:223], v[196:199], v74, v78 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v220, off, s9 offset:404
		scratch_load_dword v221, off, s9 offset:408
		scratch_load_dword v222, off, s9 offset:412
		scratch_load_dword v223, off, s9 offset:416
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[224:227], v[220:223], v[200:203], v74, v78 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v220, off, s9 offset:420
		scratch_load_dword v221, off, s9 offset:424
		scratch_load_dword v222, off, s9 offset:428
		scratch_load_dword v223, off, s9 offset:432
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[224:227], v[220:223], v[204:207], v74, v79 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v220, off, s9 offset:452
		scratch_load_dword v221, off, s9 offset:456
		scratch_load_dword v222, off, s9 offset:460
		scratch_load_dword v223, off, s9 offset:464
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[224:227], v[220:223], v[208:211], v74, v79 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_barrier
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v220, off, s9 offset:500
		scratch_load_dword v221, off, s9 offset:504
		scratch_load_dword v222, off, s9 offset:508
		scratch_load_dword v223, off, s9 offset:512
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[228:231], v[220:223], v[8:11], v7, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(12)
		scratch_load_dword v220, off, s9 offset:520
		scratch_load_dword v221, off, s9 offset:524
		scratch_load_dword v222, off, s9 offset:528
		scratch_load_dword v223, off, s9 offset:532
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[228:231], v[220:223], v[92:95], v7, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v220, off, s9 offset:520
		scratch_load_dword v221, off, s9 offset:524
		scratch_load_dword v222, off, s9 offset:528
		scratch_load_dword v223, off, s9 offset:532
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[232:235], v[220:223], v[128:131], v7, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v220, off, s9 offset:500
		scratch_load_dword v221, off, s9 offset:504
		scratch_load_dword v222, off, s9 offset:508
		scratch_load_dword v223, off, s9 offset:512
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[232:235], v[220:223], v[124:127], v7, v75 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v220, off, s9 offset:536
		scratch_load_dword v221, off, s9 offset:540
		scratch_load_dword v222, off, s9 offset:544
		scratch_load_dword v223, off, s9 offset:548
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[232:235], v[220:223], v[132:135], v7, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v220, off, s9 offset:536
		scratch_load_dword v221, off, s9 offset:540
		scratch_load_dword v222, off, s9 offset:544
		scratch_load_dword v223, off, s9 offset:548
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[228:231], v[220:223], v[100:103], v7, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v220, off, s9 offset:552
		scratch_load_dword v221, off, s9 offset:556
		scratch_load_dword v222, off, s9 offset:560
		scratch_load_dword v223, off, s9 offset:564
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[228:231], v[220:223], v[104:107], v7, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v220, off, s9 offset:552
		scratch_load_dword v221, off, s9 offset:556
		scratch_load_dword v222, off, s9 offset:560
		scratch_load_dword v223, off, s9 offset:564
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[232:235], v[220:223], v[136:139], v7, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v220, off, s9 offset:584
		scratch_load_dword v221, off, s9 offset:588
		scratch_load_dword v222, off, s9 offset:592
		scratch_load_dword v223, off, s9 offset:596
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[232:235], v[220:223], v[140:143], v7, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v220, off, s9 offset:584
		scratch_load_dword v221, off, s9 offset:588
		scratch_load_dword v222, off, s9 offset:592
		scratch_load_dword v223, off, s9 offset:596
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[228:231], v[220:223], v[108:111], v7, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[228:231], v[240:243], v[112:115], v7, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[232:235], v[240:243], v[144:147], v7, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[232:235], v[244:247], v[148:151], v7, v86 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[228:231], v[244:247], v[116:119], v7, v86 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[228:231], v[60:63], v[120:123], v7, v86 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[232:235], v[60:63], v[152:155], v7, v86 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[236:239], v[60:63], v[184:187], v74, v86 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[236:239], v[244:247], v[180:183], v74, v86 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[24:27], v[244:247], v[212:215], v74, v86 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[24:27], v[60:63], v[216:219], v74, v86 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v60, off, s9 offset:500
		scratch_load_dword v61, off, s9 offset:504
		scratch_load_dword v62, off, s9 offset:508
		scratch_load_dword v63, off, s9 offset:512
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[60:63], v[188:191], v74, v75 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v60, off, s9 offset:500
		scratch_load_dword v61, off, s9 offset:504
		scratch_load_dword v62, off, s9 offset:508
		scratch_load_dword v63, off, s9 offset:512
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[236:239], v[60:63], v[156:159], v74, v75 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v60, off, s9 offset:520
		scratch_load_dword v61, off, s9 offset:524
		scratch_load_dword v62, off, s9 offset:528
		scratch_load_dword v63, off, s9 offset:532
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[236:239], v[60:63], v[160:163], v74, v75 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v60, off, s9 offset:520
		scratch_load_dword v61, off, s9 offset:524
		scratch_load_dword v62, off, s9 offset:528
		scratch_load_dword v63, off, s9 offset:532
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[60:63], v[192:195], v74, v75 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v60, off, s9 offset:536
		scratch_load_dword v61, off, s9 offset:540
		scratch_load_dword v62, off, s9 offset:544
		scratch_load_dword v63, off, s9 offset:548
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[60:63], v[196:199], v74, v78 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v60, off, s9 offset:536
		scratch_load_dword v61, off, s9 offset:540
		scratch_load_dword v62, off, s9 offset:544
		scratch_load_dword v63, off, s9 offset:548
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[236:239], v[60:63], v[164:167], v74, v78 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v60, off, s9 offset:552
		scratch_load_dword v61, off, s9 offset:556
		scratch_load_dword v62, off, s9 offset:560
		scratch_load_dword v63, off, s9 offset:564
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[236:239], v[60:63], v[168:171], v74, v78 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v60, off, s9 offset:552
		scratch_load_dword v61, off, s9 offset:556
		scratch_load_dword v62, off, s9 offset:560
		scratch_load_dword v63, off, s9 offset:564
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[60:63], v[200:203], v74, v78 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v60, off, s9 offset:584
		scratch_load_dword v61, off, s9 offset:588
		scratch_load_dword v62, off, s9 offset:592
		scratch_load_dword v63, off, s9 offset:596
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[60:63], v[204:207], v74, v79 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s9, 0
		scratch_load_dword v60, off, s9 offset:584
		scratch_load_dword v61, off, s9 offset:588
		scratch_load_dword v62, off, s9 offset:592
		scratch_load_dword v63, off, s9 offset:596
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[236:239], v[60:63], v[172:175], v74, v79 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[236:239], v[240:243], v[176:179], v74, v79 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], v[240:243], v[208:211], v74, v79 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_add_i32 s11, s11, 2
		s_cmp_lt_i32 s11, s10
		s_mov_b32 s9, 0
		scratch_load_dword v24, off, s9 offset:224
		scratch_load_dword v25, off, s9 offset:228
		scratch_load_dword v26, off, s9 offset:232
		scratch_load_dword v27, off, s9 offset:236
		s_mov_b32 s9, 0
		scratch_load_dword v1, off, s9 offset:240
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v6, v1
		s_mov_b32 s9, 0
		scratch_load_dword v1, off, s9 offset:244
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v7, v1
		s_mov_b32 s9, 0
		scratch_load_dword v1, off, s9 offset:248
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v60, v1
		s_mov_b32 s9, 0
		scratch_load_dword v1, off, s9 offset:252
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v61, v1
		s_mov_b32 s9, 0
		scratch_load_dword v1, off, s9 offset:256
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v62, v1
		s_mov_b32 s9, 0
		scratch_load_dword v1, off, s9 offset:260
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v63, v1
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_sub_i32 s0, s12, 1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[12:15], v[28:31], v[8:11], v6, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s0, s0, 1
		s_lshl_b32 s0, s0, 16
		s_add_i32 s1, s36, s0
		v_and_b32_e32 v1, 15, v0
		v_lshlrev_b32_e32 v1, 6, v1
		v_and_b32_e32 v2, 63, v0
		v_lshrrev_b32_e32 v2, 4, v2
		v_and_b32_e32 v3, 15, v0
		v_lshrrev_b32_e32 v3, 1, v3
		v_bitop3_b32 v2, v2, v3, 3 bitop3:0x78
		v_lshlrev_b32_e32 v2, 4, v2
		v_add3_u32 v3, s1, v1, v2
		v_add_u32_e32 v3, 0x6000, v3
		ds_read_b128 v[64:67], v3 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[12:15], v[32:35], v[92:95], v6, v60 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[68:71], v3 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[12:15], v[36:39], v[100:103], v6, v61 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[72:75], v3 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[12:15], v[40:43], v[104:107], v6, v61 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[76:79], v3 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[12:15], v[44:47], v[108:111], v6, v62 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s0, s0, s39
		v_add3_u32 v3, s0, v1, v2
		v_add_u32_e32 v3, 0x6000, v3
		ds_read_b128 v[80:83], v3 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[12:15], v[48:51], v[112:115], v6, v62 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[84:87], v3 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[12:15], v[52:55], v[116:119], v6, v63 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v3 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[12:15], v[56:59], v[120:123], v6, v63 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[12:15], v3 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[28:31], v[124:127], v6, v60 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v3 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[32:35], v[128:131], v6, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v3 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[16:19], v[36:39], v[132:135], v6, v61 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v3 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[40:43], v[136:139], v6, v61 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v3 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[16:19], v[44:47], v[140:143], v6, v62 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[16:19], v[48:51], v[144:147], v6, v62 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[16:19], v[52:55], v[148:151], v6, v63 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[16:19], v[56:59], v[152:155], v6, v63 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[20:23], v[56:59], v[184:187], v7, v63 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[20:23], v[52:55], v[180:183], v7, v63 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[24:27], v[52:55], v[212:215], v7, v63 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[24:27], v[56:59], v[216:219], v7, v63 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[28:31], v[188:191], v7, v60 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[28:31], v[156:159], v7, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[32:35], v[160:163], v7, v60 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[32:35], v[192:195], v7, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[36:39], v[196:199], v7, v61 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[36:39], v[164:167], v7, v61 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[40:43], v[168:171], v7, v61 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[40:43], v[200:203], v7, v61 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[44:47], v[204:207], v7, v62 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[44:47], v[172:175], v7, v62 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[20:23], v[48:51], v[176:179], v7, v62 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], v[48:51], v[208:211], v7, v62 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[72:75], v[96:99], v[172:175], v7, v62 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[72:75], v[220:223], v[176:179], v7, v62 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[76:79], v[220:223], v[208:211], v7, v62 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[76:79], v[96:99], v[204:207], v7, v62 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[64:67], v[96:99], v[108:111], v6, v62 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[64:67], v[220:223], v[112:115], v6, v62 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[68:71], v[220:223], v[144:147], v6, v62 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[68:71], v[96:99], v[140:143], v6, v62 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[68:71], v[80:83], v[124:127], v6, v60 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[64:67], v[80:83], v[8:11], v6, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[64:67], v[84:87], v[92:95], v6, v60 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[68:71], v[84:87], v[128:131], v6, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[68:71], v[88:91], v[132:135], v6, v61 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[64:67], v[88:91], v[100:103], v6, v61 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[64:67], v[12:15], v[104:107], v6, v61 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[68:71], v[12:15], v[136:139], v6, v61 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[68:71], v[224:227], v[148:151], v6, v63 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[64:67], v[224:227], v[116:119], v6, v63 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[64:67], v[228:231], v[120:123], v6, v63 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[68:71], v[228:231], v[152:155], v6, v63 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[72:75], v[228:231], v[184:187], v7, v63 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[72:75], v[224:227], v[180:183], v7, v63 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[76:79], v[224:227], v[212:215], v7, v63 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[76:79], v[228:231], v[216:219], v7, v63 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[76:79], v[80:83], v[188:191], v7, v60 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[72:75], v[80:83], v[156:159], v7, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[72:75], v[84:87], v[160:163], v7, v60 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[76:79], v[84:87], v[192:195], v7, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[76:79], v[88:91], v[196:199], v7, v61 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[72:75], v[88:91], v[164:167], v7, v61 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[72:75], v[12:15], v[168:171], v7, v61 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[76:79], v[12:15], v[200:203], v7, v61 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s0, s12, 1
		s_lshl_b32 s1, s0, 16
		s_add_i32 s2, s36, s1
		v_add3_u32 v3, s2, v1, v2
		v_add_u32_e32 v3, 0x6000, v3
		ds_read_b128 v[4:7], v3
		ds_read_b128 v[12:15], v3 offset:1024
		ds_read_b128 v[16:19], v3 offset:2048
		ds_read_b128 v[20:23], v3 offset:3072
		s_add_i32 s1, s1, s39
		v_add3_u32 v1, s1, v1, v2
		v_add_u32_e32 v1, 0x6000, v1
		ds_read_b128 v[24:27], v1 offset:32768
		ds_read_b128 v[28:31], v1 offset:33792
		ds_read_b128 v[32:35], v1 offset:34816
		ds_read_b128 v[36:39], v1 offset:35840
		ds_read_b128 v[40:43], v1 offset:36864
		ds_read_b128 v[44:47], v1 offset:37888
		ds_read_b128 v[48:51], v1 offset:38912
		ds_read_b128 v[52:55], v1 offset:39936
		s_lshl_b32 s0, s0, 12
		s_add_i32 s1, s38, s0
		v_and_b32_e32 v0, 63, v0
		v_lshl_add_u32 v2, v0, 2, s1
		v_add_u32_e32 v2, 0x6000, v2
		ds_read_b32 v56, v2
		ds_read_b32 v57, v2 offset:256
		s_add_i32 s0, s0, 0x20000
		s_add_i32 s0, s0, s16
		v_lshl_add_u32 v2, v0, 2, s0
		v_add_u32_e32 v2, 0x6000, v2
		ds_read_b32 v58, v2 offset:2048
		ds_read_b32 v59, v2 offset:2304
		ds_read_b32 v60, v2 offset:2560
		ds_read_b32 v61, v2 offset:2816
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[4:7], v[24:27], v[8:11], v56, v58 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[64:67], v3 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[4:7], v[28:31], v[92:95], v56, v58 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[68:71], v3 offset:17408
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[4:7], v[32:35], v[100:103], v56, v59 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[72:75], v3 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[4:7], v[36:39], v[104:107], v56, v59 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[76:79], v3 offset:19456
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[4:7], v[40:43], v[108:111], v56, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[80:83], v1 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[4:7], v[44:47], v[112:115], v56, v60 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[84:87], v1 offset:50176
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[4:7], v[48:51], v[116:119], v56, v61 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[88:91], v1 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[4:7], v[52:55], v[120:123], v56, v61 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[4:7], v1 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[12:15], v[24:27], v[124:127], v56, v58 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v1 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[12:15], v[28:31], v[128:131], v56, v58 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v1 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[12:15], v[32:35], v[132:135], v56, v59 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v1 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[12:15], v[36:39], v[136:139], v56, v59 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v1 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[12:15], v[40:43], v[140:143], v56, v60 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[12:15], v[44:47], v[144:147], v56, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[12:15], v[48:51], v[148:151], v56, v61 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[12:15], v[52:55], v[152:155], v56, v61 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[16:19], v[52:55], v[184:187], v57, v61 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[16:19], v[48:51], v[180:183], v57, v61 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[20:23], v[48:51], v[212:215], v57, v61 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[20:23], v[52:55], v[216:219], v57, v61 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[20:23], v[24:27], v[188:191], v57, v58 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[16:19], v[24:27], v[156:159], v57, v58 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[16:19], v[28:31], v[160:163], v57, v58 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[20:23], v[28:31], v[192:195], v57, v58 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[20:23], v[32:35], v[196:199], v57, v59 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[16:19], v[32:35], v[164:167], v57, v59 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[16:19], v[36:39], v[168:171], v57, v59 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[20:23], v[36:39], v[200:203], v57, v59 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[20:23], v[40:43], v[204:207], v57, v60 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[16:19], v[40:43], v[172:175], v57, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[16:19], v[44:47], v[176:179], v57, v60 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[20:23], v[44:47], v[208:211], v57, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[72:75], v[96:99], v[172:175], v57, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[72:75], v[220:223], v[176:179], v57, v60 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[76:79], v[220:223], v[208:211], v57, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[76:79], v[96:99], v[204:207], v57, v60 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[64:67], v[96:99], v[108:111], v56, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[64:67], v[220:223], v[112:115], v56, v60 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[68:71], v[220:223], v[144:147], v56, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[68:71], v[96:99], v[140:143], v56, v60 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[68:71], v[80:83], v[124:127], v56, v58 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[8:11], v[64:67], v[80:83], v[8:11], v56, v58 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[92:95], v[64:67], v[84:87], v[92:95], v56, v58 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[68:71], v[84:87], v[128:131], v56, v58 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[68:71], v[88:91], v[132:135], v56, v59 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[64:67], v[88:91], v[100:103], v56, v59 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[104:107], v[64:67], v[4:7], v[104:107], v56, v59 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[68:71], v[4:7], v[136:139], v56, v59 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[68:71], v[224:227], v[148:151], v56, v61 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[64:67], v[224:227], v[116:119], v56, v61 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[64:67], v[228:231], v[120:123], v56, v61 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[68:71], v[228:231], v[152:155], v56, v61 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[72:75], v[228:231], v[184:187], v57, v61 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[72:75], v[224:227], v[180:183], v57, v61 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[212:215], v[76:79], v[224:227], v[212:215], v57, v61 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[216:219], v[76:79], v[228:231], v[216:219], v57, v61 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[76:79], v[80:83], v[188:191], v57, v58 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[72:75], v[80:83], v[156:159], v57, v58 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[72:75], v[84:87], v[160:163], v57, v58 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[76:79], v[84:87], v[192:195], v57, v58 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[76:79], v[88:91], v[196:199], v57, v59 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[72:75], v[88:91], v[164:167], v57, v59 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[72:75], v[4:7], v[168:171], v57, v59 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[76:79], v[4:7], v[200:203], v57, v59 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v2, v8, v9
		v_cvt_pk_f16_f32 v3, v10, v11
		v_lshlrev_b32_e32 v0, 3, v0
		s_lshl_b32 s0, s13, 21
		s_lshl_b32 s1, s14, 17
		s_add_i32 s2, s0, s1
		s_lshl_b32 s3, s8, 14
		s_add_i32 s2, s2, s3
		s_mov_b32 s16, s6
		s_mov_b32 s17, s7
		s_mov_b32 s19, s23
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen
		v_cvt_pk_f16_f32 v2, v92, v93
		v_cvt_pk_f16_f32 v3, v94, v95
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:512
		v_cvt_pk_f16_f32 v2, v100, v101
		v_cvt_pk_f16_f32 v3, v102, v103
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:1024
		v_cvt_pk_f16_f32 v2, v104, v105
		v_cvt_pk_f16_f32 v3, v106, v107
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:1536
		v_cvt_pk_f16_f32 v2, v108, v109
		v_cvt_pk_f16_f32 v3, v110, v111
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
		s_add_i32 s2, s2, s3
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
		s_add_i32 s2, s2, s3
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
		s_add_i32 s0, s0, s3
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
		.amdhsa_private_segment_fixed_size 600
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
		.amdhsa_next_free_sgpr 48
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
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 48
	.set .Lwmma_f16_matmul_tiled.num_named_barrier, 0
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 600
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
    .private_segment_fixed_size: 600
    .sgpr_count:     48
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     256
    .agpr_count:     0
    .vgpr_spill_count: 150
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 87
    wave.regalloc.agpr.dwords: 0
    wave.regalloc.remat.dwords: 20
    wave.regalloc.sgpr_to_vgpr.dwords: 0
    wave.regalloc.lds.dwords: 12
    wave.regalloc.scratch.dwords: 150
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
