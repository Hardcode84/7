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
		v_mov_b32_e32 v3, 0
		s_mov_b32 s16, 1
		s_mov_b32 s17, 0
		s_and_saveexec_b64 s[18:19], s[16:17]
		ds_write_b32 v3, v3
		v_mov_b32_e32 v1, 4
		ds_write_b32 v1, v3
		v_mov_b32_e32 v2, 8
		ds_write_b32 v2, v3
		v_mov_b32_e32 v2, 12
		ds_write_b32 v2, v3
		s_mov_b64 exec, s[18:19]
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mov_b32 s22, 0x7fffffff
		s_mov_b32 s23, 0x31016000
		s_mov_b32 s20, s6
		s_mov_b32 s21, s7
		s_mov_b32 s26, 0x1000000
		s_mov_b32 s24, s2
		s_mov_b32 s25, s3
		s_mov_b32 s27, s23
		s_mov_b32 s0, s4
		s_mov_b32 s1, s5
		s_mov_b32 s2, s26
		s_mov_b32 s3, s23
		s_mov_b32 s4, s8
		s_mov_b32 s5, s9
		s_mov_b32 s6, s26
		s_mov_b32 s7, s23
		s_mov_b32 s28, s10
		s_mov_b32 s29, s11
		s_mov_b32 s30, s26
		s_mov_b32 s31, s23
		v_readfirstlane_b32 s8, v0
		s_lshl_b32 s9, s13, 20
		v_lshrrev_b32_e32 v2, 6, v0
		s_mov_b32 s10, 0
		scratch_store_dword off, v2, s10
		v_lshlrev_b32_e32 v4, 16, v2
		v_add_u32_e32 v5, s9, v4
		v_and_b32_e32 v6, 63, v0
		s_mov_b32 s10, 0
		scratch_store_dword off, v6, s10 offset:4
		v_lshrrev_b32_e32 v7, 2, v6
		v_lshlrev_b32_e32 v7, 12, v7
		v_lshrrev_b32_e32 v8, 3, v6
		v_and_b32_e32 v8, 3, v8
		v_and_b32_e32 v9, 3, v6
		v_xor_b32_e32 v8, v8, v9
		v_lshlrev_b32_e32 v8, 4, v8
		v_add3_u32 v5, v5, v7, v8
		s_add_i32 s10, s9, 0x80000
		v_add_u32_e32 v9, s10, v4
		s_add_i32 s10, s9, 64
		v_add_u32_e32 v10, v4, v7
		s_add_i32 s11, s9, 0x80040
		s_lshl_b32 s15, s14, 20
		s_add_i32 s18, s15, 0x80000
		v_add3_u32 v11, v4, v7, v8
		s_add_i32 s19, s15, 0x80040
		s_lshr_b32 s32, s8, 6
		s_lshl_b32 s33, s32, 10
		v_mov_b64_e32 v[12:13], 0
		v_mov_b64_e32 v[14:15], 0
		s_add_i32 m0, s33, 16
		s_nop 0
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		v_add3_u32 v5, v9, v7, v8
		s_add_i32 m0, s33, 0x2010
		s_nop 0
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		v_add3_u32 v5, v8, v10, s10
		s_add_i32 m0, s33, 0x4010
		s_nop 0
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		v_add3_u32 v5, v8, v10, s11
		s_add_i32 m0, s33, 0x6010
		s_nop 0
		buffer_load_dwordx4 v5, s[24:27], 0 offen lds
		v_add3_u32 v5, v8, v10, s15
		s_add_i32 m0, s33, 0x8010
		s_nop 0
		buffer_load_dwordx4 v5, s[0:3], 0 offen lds
		v_add_u32_e32 v5, s18, v11
		s_add_i32 m0, s33, 0xa010
		s_nop 0
		buffer_load_dwordx4 v5, s[0:3], 0 offen lds
		v_add3_u32 v5, v11, s15, 64
		s_add_i32 m0, s33, 0xc010
		s_nop 0
		buffer_load_dwordx4 v5, s[0:3], 0 offen lds
		v_add_u32_e32 v5, s19, v11
		s_add_i32 m0, s33, 0xe010
		s_nop 0
		buffer_load_dwordx4 v5, s[0:3], 0 offen lds
		s_lshl_b32 s10, s14, 16
		s_add_i32 s11, s9, s10
		v_lshrrev_b32_e32 v5, 7, v0
		v_lshlrev_b32_e32 v9, 9, v5
		v_lshlrev_b32_e32 v10, 2, v6
		v_add3_u32 v11, s11, v9, v10
		s_lshr_b32 s8, s8, 7
		s_lshl_b32 s18, s8, 9
		s_add_i32 s8, s9, 0x100
		s_add_i32 s8, s8, s10
		v_add3_u32 v16, s8, v9, v10
		v_lshlrev_b32_e32 v17, 4, v6
		v_and_b32_e32 v2, 1, v2
		v_lshlrev_b32_e32 v18, 10, v2
		v_add3_u32 v19, s11, v17, v18
		s_and_b32 s8, s32, 1
		s_lshl_b32 s8, s8, 10
		s_add_i32 s11, s33, 0x2000
		s_add_i32 m0, s18, 0x20010
		s_nop 0
		buffer_load_dword v11, s[4:7], 0 offen lds
		s_add_i32 s19, s33, 0x4000
		s_add_i32 m0, s18, 0x20110
		s_nop 0
		buffer_load_dword v16, s[4:7], 0 offen lds
		s_add_i32 s32, s33, 0x6000
		s_add_i32 m0, s8, 0x20810
		s_nop 0
		buffer_load_dwordx4 v19, s[28:31], 0 offen lds
		v_mov_b32_e32 v11, 1
		s_and_saveexec_b64 s[34:35], s[16:17]
		s_waitcnt vmcnt(0)
		ds_add_rtn_u32 v16, v3, v11
		s_mov_b64 exec, s[34:35]
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s34, v16
		s_and_b32 s34, s34, -8
		s_add_i32 s34, s34, 8
		s_and_saveexec_b64 s[36:37], s[16:17]
.Lwmma_f16_matmul_tiled.loop_head_0:
		ds_read_b32 v16, v3
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s35, v16
		s_xor_b32 s38, s34, -1
		s_add_i32 s38, s38, 1
		s_add_i32 s35, s35, s38
		s_cmp_ge_u32 s35, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_mov_b64 exec, s[36:37]
		v_lshlrev_b32_e32 v5, 12, v5
		v_and_b32_e32 v16, 15, v0
		v_lshlrev_b32_e32 v19, 6, v16
		v_lshrrev_b32_e32 v6, 4, v6
		v_lshrrev_b32_e32 v16, 1, v16
		v_and_b32_e32 v16, 3, v16
		v_xor_b32_e32 v6, v6, v16
		v_lshlrev_b32_e32 v6, 4, v6
		v_add3_u32 v5, v5, v19, v6
		v_add_u32_e32 v5, 16, v5
		ds_read_b128 v[20:23], v5
		ds_read_b128 v[24:27], v5 offset:1024
		ds_read_b128 v[28:31], v5 offset:2048
		ds_read_b128 v[32:35], v5 offset:3072
		v_lshlrev_b32_e32 v2, 13, v2
		v_add3_u32 v2, v19, v2, v6
		v_add_u32_e32 v2, 16, v2
		ds_read_b128 v[36:39], v2 offset:32768
		ds_read_b128 v[40:43], v2 offset:33792
		ds_read_b128 v[44:47], v2 offset:34816
		ds_read_b128 v[48:51], v2 offset:35840
		ds_read_b128 v[52:55], v2 offset:36864
		ds_read_b128 v[56:59], v2 offset:37888
		ds_read_b128 v[60:63], v2 offset:38912
		ds_read_b128 v[64:67], v2 offset:39936
		v_add_u32_e32 v2, 0x20000, v9
		v_add_u32_e32 v2, v2, v10
		v_add_u32_e32 v2, 16, v2
		ds_read_b32 v5, v2
		ds_read_b32 v6, v2 offset:256
		v_add_u32_e32 v2, 0x20000, v10
		v_add_u32_e32 v2, v2, v18
		v_add_u32_e32 v2, 16, v2
		ds_read_b32 v16, v2 offset:2048
		ds_read_b32 v19, v2 offset:2304
		ds_read_b32 v68, v2 offset:2560
		ds_read_b32 v69, v2 offset:2816
		s_add_i32 s34, s9, 0x80
		v_add_u32_e32 v2, s34, v4
		v_add3_u32 v2, v2, v7, v8
		s_add_i32 s34, s9, 0x80080
		v_add_u32_e32 v70, s34, v4
		v_add3_u32 v70, v70, v7, v8
		s_add_i32 s34, s9, 0xc0
		v_add_u32_e32 v71, v4, v7
		v_add3_u32 v72, v8, v71, s34
		s_add_i32 s34, s9, 0x800c0
		v_add3_u32 v73, v8, v71, s34
		s_add_i32 s34, s15, 0x80
		v_add3_u32 v71, v8, v71, s34
		s_add_i32 s34, s15, 0x80080
		v_add_u32_e32 v4, v4, v7
		v_add3_u32 v7, v8, v4, s34
		s_add_i32 s34, s15, 0xc0
		s_add_i32 s15, s15, 0x800c0
		s_add_i32 s35, s33, 0x16000
		s_add_i32 s36, s33, 0x18000
		s_add_i32 s37, s33, 0x1a000
		s_add_i32 s38, s33, 0x1c000
		s_add_i32 s39, s33, 0x1e000
		s_add_i32 s40, s33, 0x8000
		s_add_i32 m0, s33, 0x10010
		s_nop 0
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		s_add_i32 s41, s33, 0xa000
		s_add_i32 m0, s33, 0x12010
		s_nop 0
		buffer_load_dwordx4 v70, s[24:27], 0 offen lds
		s_add_i32 s42, s33, 0xc000
		s_add_i32 m0, s33, 0x14010
		s_nop 0
		buffer_load_dwordx4 v72, s[24:27], 0 offen lds
		s_add_i32 s43, s33, 0xe000
		s_add_i32 m0, s33, 0x16010
		s_nop 0
		buffer_load_dwordx4 v73, s[24:27], 0 offen lds
		s_add_i32 s44, s18, 0x100
		s_add_i32 m0, s33, 0x18010
		s_nop 0
		buffer_load_dwordx4 v71, s[0:3], 0 offen lds
		s_add_i32 s45, s8, 0x800
		s_add_i32 m0, s33, 0x1a010
		s_nop 0
		buffer_load_dwordx4 v7, s[0:3], 0 offen lds
		v_add3_u32 v2, v8, v4, s34
		s_add_i32 m0, s33, 0x1c010
		s_nop 0
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		v_add3_u32 v2, v8, v4, s15
		s_add_i32 m0, s33, 0x1e010
		s_nop 0
		buffer_load_dwordx4 v2, s[0:3], 0 offen lds
		s_add_i32 s15, s9, 0x800
		s_add_i32 s15, s15, s10
		v_add3_u32 v2, s15, v9, v10
		s_add_i32 s34, s18, 0x1000
		s_add_i32 s9, s9, 0x900
		s_add_i32 s9, s9, s10
		v_add3_u32 v4, s9, v9, v10
		s_add_i32 s9, s18, 0x1100
		v_add3_u32 v7, s15, v17, v18
		s_add_i32 s10, s8, 0x1800
		s_add_i32 s15, s33, 0x10000
		s_add_i32 m0, s18, 0x21010
		s_nop 0
		buffer_load_dword v2, s[4:7], 0 offen lds
		s_add_i32 s46, s33, 0x12000
		s_add_i32 m0, s18, 0x21110
		s_nop 0
		buffer_load_dword v4, s[4:7], 0 offen lds
		s_add_i32 s47, s33, 0x14000
		s_add_i32 m0, s8, 0x21810
		s_nop 0
		buffer_load_dwordx4 v7, s[28:31], 0 offen lds
		s_and_saveexec_b64 s[48:49], s[16:17]
		s_waitcnt vmcnt(0)
		ds_add_rtn_u32 v2, v1, v11
		s_mov_b64 exec, s[48:49]
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s8, v2
		s_and_b32 s8, s8, -8
		s_add_i32 s8, s8, 8
		s_and_saveexec_b64 s[48:49], s[16:17]
.Lwmma_f16_matmul_tiled.loop_head_1:
		ds_read_b32 v2, v1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s50, v2
		s_xor_b32 s51, s8, -1
		s_add_i32 s51, s51, 1
		s_add_i32 s50, s50, s51
		s_cmp_ge_u32 s50, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_1
.Lwmma_f16_matmul_tiled.loop_exit_1:
		s_mov_b64 exec, s[48:49]
		s_add_i32 s8, s12, 1
		s_mov_b32 s48, 2
		v_mov_b32_e32 v2, s13
		s_mov_b32 s50, 0x100000
		s_mov_b32 s51, 0
		v_mov_b32_e32 v8, s50
		v_mov_b32_e32 v9, s51
		v_mul_lo_u32 v70, v8, v2
		v_mul_hi_u32 v71, v8, v2
		v_mul_lo_u32 v1, v8, v3
		v_add_u32_e32 v71, v71, v1
		v_mul_lo_u32 v1, v9, v2
		v_add_u32_e32 v71, v71, v1
		v_mov_b32_e32 v72, v0
		v_mov_b32_e32 v73, 0
		v_mov_b32_e32 v74, s16
		v_mov_b32_e32 v75, s17
		v_mul_lo_u32 v76, v74, v72
		v_mul_hi_u32 v77, v74, v72
		v_mul_lo_u32 v1, v74, v73
		v_add_u32_e32 v77, v77, v1
		v_mul_lo_u32 v1, v75, v72
		v_add_u32_e32 v77, v77, v1
		v_lshrrev_b64 v[78:79], 6, v[76:77]
		s_mov_b32 s50, 0x10000
		s_mov_b32 s51, 0
		v_mov_b32_e32 v80, s50
		v_mov_b32_e32 v81, s51
		v_mul_lo_u32 v82, v80, v78
		v_mul_hi_u32 v83, v80, v78
		v_mul_lo_u32 v1, v80, v79
		v_add_u32_e32 v83, v83, v1
		v_mul_lo_u32 v1, v81, v78
		v_add_u32_e32 v83, v83, v1
		v_add_co_u32_e64 v84, vcc, v70, v82
		v_addc_co_u32_e64 v85, vcc, v71, v83, vcc
		v_mov_b32_e32 v1, 63
		v_and_b32_e32 v86, v72, v1
		v_and_b32_e32 v87, v3, v3
		v_mul_lo_u32 v72, v74, v86
		v_mul_hi_u32 v73, v74, v86
		v_mul_lo_u32 v1, v74, v87
		v_add_u32_e32 v73, v73, v1
		v_mul_lo_u32 v1, v75, v86
		v_add_u32_e32 v73, v73, v1
		v_lshrrev_b64 v[74:75], 2, v[72:73]
		s_mov_b32 s50, 0x1000
		s_mov_b32 s51, 0
		v_mov_b32_e32 v88, s50
		v_mov_b32_e32 v89, s51
		v_mul_lo_u32 v90, v88, v74
		v_mul_hi_u32 v91, v88, v74
		v_mul_lo_u32 v1, v88, v75
		v_add_u32_e32 v91, v91, v1
		v_mul_lo_u32 v1, v89, v74
		v_add_u32_e32 v91, v91, v1
		v_add_co_u32_e64 v74, vcc, v84, v90
		v_addc_co_u32_e64 v75, vcc, v85, v91, vcc
		v_lshrrev_b64 v[84:85], 3, v[72:73]
		v_mov_b32_e32 v1, 3
		v_and_b32_e32 v72, v84, v1
		v_and_b32_e32 v73, v85, v3
		v_and_b32_e32 v84, v86, v1
		v_and_b32_e32 v85, v87, v3
		v_xor_b32_e32 v72, v72, v84
		v_xor_b32_e32 v73, v73, v85
		s_mov_b32 s50, 16
		s_mov_b32 s51, 0
		v_mov_b32_e32 v84, s50
		v_mov_b32_e32 v85, s51
		v_mul_lo_u32 v88, v84, v72
		v_mul_hi_u32 v89, v84, v72
		v_mul_lo_u32 v1, v84, v73
		v_add_u32_e32 v89, v89, v1
		v_mul_lo_u32 v1, v85, v72
		v_add_u32_e32 v89, v89, v1
		v_add_co_u32_e64 v72, vcc, v74, v88
		v_addc_co_u32_e64 v73, vcc, v75, v89, vcc
		s_mov_b32 s50, 0x80
		s_mov_b32 s51, 0
		v_mov_b32_e32 v74, s50
		v_mov_b32_e32 v75, s51
		v_mov_b32_e32 v1, 0x80000
		v_add_co_u32_e64 v92, vcc, v70, v1
		v_addc_co_u32_e64 v93, vcc, v71, 0, vcc
		v_add_co_u32_e64 v94, vcc, v92, v82
		v_addc_co_u32_e64 v95, vcc, v93, v83, vcc
		v_add_co_u32_e64 v92, vcc, v94, v90
		v_addc_co_u32_e64 v93, vcc, v95, v91, vcc
		v_add_co_u32_e64 v94, vcc, v92, v88
		v_addc_co_u32_e64 v95, vcc, v93, v89, vcc
		v_mov_b32_e32 v2, 64
		v_add_co_u32_e64 v92, vcc, v70, v2
		v_addc_co_u32_e64 v93, vcc, v71, 0, vcc
		v_add_co_u32_e64 v96, vcc, v92, v82
		v_addc_co_u32_e64 v97, vcc, v93, v83, vcc
		v_add_co_u32_e64 v92, vcc, v96, v90
		v_addc_co_u32_e64 v93, vcc, v97, v91, vcc
		v_add_co_u32_e64 v96, vcc, v92, v88
		v_addc_co_u32_e64 v97, vcc, v93, v89, vcc
		v_mov_b32_e32 v4, 0x80040
		v_add_co_u32_e64 v92, vcc, v70, v4
		v_addc_co_u32_e64 v93, vcc, v71, 0, vcc
		v_add_co_u32_e64 v98, vcc, v92, v82
		v_addc_co_u32_e64 v99, vcc, v93, v83, vcc
		v_add_co_u32_e64 v92, vcc, v98, v90
		v_addc_co_u32_e64 v93, vcc, v99, v91, vcc
		v_add_co_u32_e64 v98, vcc, v92, v88
		v_addc_co_u32_e64 v99, vcc, v93, v89, vcc
		v_mov_b32_e32 v92, s14
		v_mov_b32_e32 v93, 0
		v_mul_lo_u32 v100, v8, v92
		v_mul_hi_u32 v101, v8, v92
		v_mul_lo_u32 v7, v8, v93
		v_add_u32_e32 v101, v101, v7
		v_mul_lo_u32 v7, v9, v92
		v_add_u32_e32 v101, v101, v7
		v_add_co_u32_e64 v8, vcc, v100, v82
		v_addc_co_u32_e64 v9, vcc, v101, v83, vcc
		v_add_co_u32_e64 v102, vcc, v8, v90
		v_addc_co_u32_e64 v103, vcc, v9, v91, vcc
		v_add_co_u32_e64 v8, vcc, v102, v88
		v_addc_co_u32_e64 v9, vcc, v103, v89, vcc
		v_add_co_u32_e64 v102, vcc, v100, v1
		v_addc_co_u32_e64 v103, vcc, v101, 0, vcc
		v_add_co_u32_e64 v104, vcc, v102, v82
		v_addc_co_u32_e64 v105, vcc, v103, v83, vcc
		v_add_co_u32_e64 v102, vcc, v104, v90
		v_addc_co_u32_e64 v103, vcc, v105, v91, vcc
		v_add_co_u32_e64 v104, vcc, v102, v88
		v_addc_co_u32_e64 v105, vcc, v103, v89, vcc
		v_add_co_u32_e64 v102, vcc, v100, v2
		v_addc_co_u32_e64 v103, vcc, v101, 0, vcc
		v_add_co_u32_e64 v106, vcc, v102, v82
		v_addc_co_u32_e64 v107, vcc, v103, v83, vcc
		v_add_co_u32_e64 v102, vcc, v106, v90
		v_addc_co_u32_e64 v103, vcc, v107, v91, vcc
		v_add_co_u32_e64 v106, vcc, v102, v88
		v_addc_co_u32_e64 v107, vcc, v103, v89, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v106, s49 offset:8
		scratch_store_dword off, v107, s49 offset:12
		v_add_co_u32_e64 v102, vcc, v100, v4
		v_addc_co_u32_e64 v103, vcc, v101, 0, vcc
		v_add_co_u32_e64 v106, vcc, v102, v82
		v_addc_co_u32_e64 v107, vcc, v103, v83, vcc
		v_add_co_u32_e64 v102, vcc, v106, v90
		v_addc_co_u32_e64 v103, vcc, v107, v91, vcc
		v_add_co_u32_e64 v106, vcc, v102, v88
		v_addc_co_u32_e64 v107, vcc, v103, v89, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v106, s49 offset:16
		scratch_store_dword off, v107, s49 offset:20
		v_mul_lo_u32 v102, v80, v92
		v_mul_hi_u32 v103, v80, v92
		v_mul_lo_u32 v1, v80, v93
		v_add_u32_e32 v103, v103, v1
		v_mul_lo_u32 v1, v81, v92
		v_add_u32_e32 v103, v103, v1
		v_add_co_u32_e64 v80, vcc, v70, v102
		v_addc_co_u32_e64 v81, vcc, v71, v103, vcc
		v_lshrrev_b64 v[92:93], 7, v[76:77]
		s_mov_b32 s50, 0x200
		s_mov_b32 s51, 0
		v_mov_b32_e32 v76, s50
		v_mov_b32_e32 v77, s51
		v_mul_lo_u32 v106, v76, v92
		v_mul_hi_u32 v107, v76, v92
		v_mul_lo_u32 v1, v76, v93
		v_add_u32_e32 v107, v107, v1
		v_mul_lo_u32 v1, v77, v92
		v_add_u32_e32 v107, v107, v1
		v_add_co_u32_e64 v76, vcc, v80, v106
		v_addc_co_u32_e64 v77, vcc, v81, v107, vcc
		s_mov_b32 s50, 4
		s_mov_b32 s51, 0
		v_mov_b32_e32 v92, s50
		v_mov_b32_e32 v93, s51
		v_mul_lo_u32 v108, v92, v86
		v_mul_hi_u32 v109, v92, v86
		v_mul_lo_u32 v1, v92, v87
		v_add_u32_e32 v109, v109, v1
		v_mul_lo_u32 v1, v93, v86
		v_add_u32_e32 v109, v109, v1
		v_add_co_u32_e64 v92, vcc, v76, v108
		v_addc_co_u32_e64 v93, vcc, v77, v109, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v92, s49 offset:24
		scratch_store_dword off, v93, s49 offset:28
		s_mov_b32 s50, 0x800
		s_mov_b32 s51, 0
		v_mov_b32_e32 v76, s50
		v_mov_b32_e32 v77, s51
		s_mov_b32 s49, 0
		scratch_store_dword off, v76, s49 offset:32
		scratch_store_dword off, v77, s49 offset:36
		v_mov_b32_e32 v1, 0x100
		v_add_co_u32_e64 v76, vcc, v70, v1
		v_addc_co_u32_e64 v77, vcc, v71, 0, vcc
		v_add_co_u32_e64 v92, vcc, v76, v102
		v_addc_co_u32_e64 v93, vcc, v77, v103, vcc
		v_add_co_u32_e64 v76, vcc, v92, v106
		v_addc_co_u32_e64 v77, vcc, v93, v107, vcc
		v_add_co_u32_e64 v92, vcc, v76, v108
		v_addc_co_u32_e64 v93, vcc, v77, v109, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v92, s49 offset:40
		scratch_store_dword off, v93, s49 offset:44
		v_mul_lo_u32 v76, v84, v86
		v_mul_hi_u32 v77, v84, v86
		v_mul_lo_u32 v1, v84, v87
		v_add_u32_e32 v77, v77, v1
		v_mul_lo_u32 v1, v85, v86
		v_add_u32_e32 v77, v77, v1
		v_add_co_u32_e64 v84, vcc, v80, v76
		v_addc_co_u32_e64 v85, vcc, v81, v77, vcc
		v_and_b32_e32 v80, v78, v11
		v_and_b32_e32 v81, v79, v3
		s_mov_b32 s50, 0x400
		s_mov_b32 s51, 0
		v_mov_b32_e32 v2, s50
		v_mov_b32_e32 v3, s51
		v_mul_lo_u32 v10, v2, v80
		v_mul_hi_u32 v11, v2, v80
		v_mul_lo_u32 v1, v2, v81
		v_add_u32_e32 v11, v11, v1
		v_mul_lo_u32 v1, v3, v80
		v_add_u32_e32 v11, v11, v1
		v_add_co_u32_e64 v2, vcc, v84, v10
		v_addc_co_u32_e64 v3, vcc, v85, v11, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v2, s49 offset:48
		scratch_store_dword off, v3, s49 offset:52
		v_mov_b32_e32 v1, 0x80
		v_add_co_u32_e64 v2, vcc, v70, v1
		v_addc_co_u32_e64 v3, vcc, v71, 0, vcc
		v_add_co_u32_e64 v78, vcc, v2, v82
		v_addc_co_u32_e64 v79, vcc, v3, v83, vcc
		v_add_co_u32_e64 v2, vcc, v78, v90
		v_addc_co_u32_e64 v3, vcc, v79, v91, vcc
		v_add_co_u32_e64 v78, vcc, v2, v88
		v_addc_co_u32_e64 v79, vcc, v3, v89, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v78, s49 offset:56
		scratch_store_dword off, v79, s49 offset:60
		v_mov_b32_e32 v2, 0x80080
		v_add_co_u32_e64 v78, vcc, v70, v2
		v_addc_co_u32_e64 v79, vcc, v71, 0, vcc
		v_add_co_u32_e64 v80, vcc, v78, v82
		v_addc_co_u32_e64 v81, vcc, v79, v83, vcc
		v_add_co_u32_e64 v78, vcc, v80, v90
		v_addc_co_u32_e64 v79, vcc, v81, v91, vcc
		v_add_co_u32_e64 v80, vcc, v78, v88
		v_addc_co_u32_e64 v81, vcc, v79, v89, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v80, s49 offset:64
		scratch_store_dword off, v81, s49 offset:68
		v_mov_b32_e32 v3, 0xc0
		v_add_co_u32_e64 v78, vcc, v70, v3
		v_addc_co_u32_e64 v79, vcc, v71, 0, vcc
		v_add_co_u32_e64 v80, vcc, v78, v82
		v_addc_co_u32_e64 v81, vcc, v79, v83, vcc
		v_add_co_u32_e64 v78, vcc, v80, v90
		v_addc_co_u32_e64 v79, vcc, v81, v91, vcc
		v_add_co_u32_e64 v80, vcc, v78, v88
		v_addc_co_u32_e64 v81, vcc, v79, v89, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v80, s49 offset:72
		scratch_store_dword off, v81, s49 offset:76
		v_mov_b32_e32 v4, 0x800c0
		v_add_co_u32_e64 v78, vcc, v70, v4
		v_addc_co_u32_e64 v79, vcc, v71, 0, vcc
		v_add_co_u32_e64 v80, vcc, v78, v82
		v_addc_co_u32_e64 v81, vcc, v79, v83, vcc
		v_add_co_u32_e64 v78, vcc, v80, v90
		v_addc_co_u32_e64 v79, vcc, v81, v91, vcc
		v_add_co_u32_e64 v80, vcc, v78, v88
		v_addc_co_u32_e64 v81, vcc, v79, v89, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v80, s49 offset:80
		scratch_store_dword off, v81, s49 offset:84
		v_add_co_u32_e64 v78, vcc, v100, v1
		v_addc_co_u32_e64 v79, vcc, v101, 0, vcc
		v_add_co_u32_e64 v80, vcc, v78, v82
		v_addc_co_u32_e64 v81, vcc, v79, v83, vcc
		v_add_co_u32_e64 v78, vcc, v80, v90
		v_addc_co_u32_e64 v79, vcc, v81, v91, vcc
		v_add_co_u32_e64 v80, vcc, v78, v88
		v_addc_co_u32_e64 v81, vcc, v79, v89, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v80, s49 offset:88
		scratch_store_dword off, v81, s49 offset:92
		v_add_co_u32_e64 v78, vcc, v100, v2
		v_addc_co_u32_e64 v79, vcc, v101, 0, vcc
		v_add_co_u32_e64 v80, vcc, v78, v82
		v_addc_co_u32_e64 v81, vcc, v79, v83, vcc
		v_add_co_u32_e64 v78, vcc, v80, v90
		v_addc_co_u32_e64 v79, vcc, v81, v91, vcc
		v_add_co_u32_e64 v80, vcc, v78, v88
		v_addc_co_u32_e64 v81, vcc, v79, v89, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v80, s49 offset:96
		scratch_store_dword off, v81, s49 offset:100
		v_add_co_u32_e64 v78, vcc, v100, v3
		v_addc_co_u32_e64 v79, vcc, v101, 0, vcc
		v_add_co_u32_e64 v2, vcc, v78, v82
		v_addc_co_u32_e64 v3, vcc, v79, v83, vcc
		v_add_co_u32_e64 v78, vcc, v2, v90
		v_addc_co_u32_e64 v79, vcc, v3, v91, vcc
		v_add_co_u32_e64 v2, vcc, v78, v88
		v_addc_co_u32_e64 v3, vcc, v79, v89, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v2, s49 offset:104
		scratch_store_dword off, v3, s49 offset:108
		v_add_co_u32_e64 v2, vcc, v100, v4
		v_addc_co_u32_e64 v3, vcc, v101, 0, vcc
		v_add_co_u32_e64 v78, vcc, v2, v82
		v_addc_co_u32_e64 v79, vcc, v3, v83, vcc
		v_add_co_u32_e64 v2, vcc, v78, v90
		v_addc_co_u32_e64 v3, vcc, v79, v91, vcc
		v_add_co_u32_e64 v78, vcc, v2, v88
		v_addc_co_u32_e64 v79, vcc, v3, v89, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v78, s49 offset:112
		scratch_store_dword off, v79, s49 offset:116
		v_mov_b32_e32 v1, 0x800
		v_add_co_u32_e64 v2, vcc, v70, v1
		v_addc_co_u32_e64 v3, vcc, v71, 0, vcc
		v_add_co_u32_e64 v78, vcc, v2, v102
		v_addc_co_u32_e64 v79, vcc, v3, v103, vcc
		v_add_co_u32_e64 v2, vcc, v78, v106
		v_addc_co_u32_e64 v3, vcc, v79, v107, vcc
		v_add_co_u32_e64 v80, vcc, v2, v108
		v_addc_co_u32_e64 v81, vcc, v3, v109, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v80, s49 offset:120
		scratch_store_dword off, v81, s49 offset:124
		v_mov_b32_e32 v1, 0x900
		v_add_co_u32_e64 v2, vcc, v70, v1
		v_addc_co_u32_e64 v3, vcc, v71, 0, vcc
		v_add_co_u32_e64 v70, vcc, v2, v102
		v_addc_co_u32_e64 v71, vcc, v3, v103, vcc
		v_add_co_u32_e64 v2, vcc, v70, v106
		v_addc_co_u32_e64 v3, vcc, v71, v107, vcc
		v_add_co_u32_e64 v70, vcc, v2, v108
		v_addc_co_u32_e64 v71, vcc, v3, v109, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v70, s49 offset:128
		scratch_store_dword off, v71, s49 offset:132
		v_add_co_u32_e64 v2, vcc, v78, v76
		v_addc_co_u32_e64 v3, vcc, v79, v77, vcc
		v_add_co_u32_e64 v70, vcc, v2, v10
		v_addc_co_u32_e64 v71, vcc, v3, v11, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v70, s49 offset:136
		scratch_store_dword off, v71, s49 offset:140
		v_mov_b32_e32 v2, s48
		v_mov_b32_e32 v3, 0
		v_mov_b64_e32 v[76:77], 0
		v_mov_b64_e32 v[78:79], 0
		v_mov_b64_e32 v[80:81], 0
		v_mov_b64_e32 v[82:83], 0
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_mov_b64_e32 v[100:101], 0
		v_mov_b64_e32 v[102:103], 0
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
.Lwmma_f16_matmul_tiled.loop_head_2:
		v_mov_b32_e32 v2, s48
		v_mul_lo_u32 v10, v74, v2
		v_mul_hi_u32 v11, v74, v2
		v_mul_lo_u32 v1, v74, v3
		v_add_u32_e32 v11, v11, v1
		v_mul_lo_u32 v1, v75, v2
		v_add_u32_e32 v11, v11, v1
		v_add_co_u32_e64 v70, vcc, v72, v10
		v_addc_co_u32_e64 v71, vcc, v73, v11, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v70, s49 offset:144
		v_add_co_u32_e64 v70, vcc, v94, v10
		v_addc_co_u32_e64 v71, vcc, v95, v11, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v70, s49 offset:148
		v_add_co_u32_e64 v70, vcc, v96, v10
		v_addc_co_u32_e64 v71, vcc, v97, v11, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v70, s49 offset:152
		v_add_co_u32_e64 v70, vcc, v98, v10
		v_addc_co_u32_e64 v71, vcc, v99, v11, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v70, s49 offset:156
		v_add_co_u32_e64 v70, vcc, v8, v10
		v_addc_co_u32_e64 v71, vcc, v9, v11, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v70, s49 offset:160
		v_add_co_u32_e64 v70, vcc, v104, v10
		v_addc_co_u32_e64 v71, vcc, v105, v11, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v70, s49 offset:164
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(38)
		scratch_load_dword v70, off, s49 offset:8
		scratch_load_dword v71, off, s49 offset:12
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v92, vcc, v70, v10
		v_addc_co_u32_e64 v93, vcc, v71, v11, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v92, s49 offset:168
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(37)
		scratch_load_dword v70, off, s49 offset:16
		scratch_load_dword v71, off, s49 offset:20
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v92, vcc, v70, v10
		v_addc_co_u32_e64 v93, vcc, v71, v11, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v92, s49 offset:172
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(34)
		scratch_load_dword v70, off, s49 offset:32
		scratch_load_dword v71, off, s49 offset:36
		s_waitcnt vmcnt(0)
		v_mul_lo_u32 v92, v70, v2
		v_mul_hi_u32 v93, v70, v2
		v_mul_lo_u32 v1, v70, v3
		v_add_u32_e32 v93, v93, v1
		v_mul_lo_u32 v1, v71, v2
		v_add_u32_e32 v93, v93, v1
		s_mov_b32 s49, 0
		scratch_store_dword off, v92, s49 offset:200
		scratch_store_dword off, v93, s49 offset:204
		s_mov_b32 s49, 0
		scratch_load_dword v70, off, s49 offset:24
		scratch_load_dword v71, off, s49 offset:28
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v106, vcc, v70, v92
		v_addc_co_u32_e64 v107, vcc, v71, v93, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v106, s49 offset:176
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(35)
		scratch_load_dword v70, off, s49 offset:40
		scratch_load_dword v71, off, s49 offset:44
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v106, vcc, v70, v92
		v_addc_co_u32_e64 v107, vcc, v71, v93, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v106, s49 offset:180
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(34)
		scratch_load_dword v70, off, s49 offset:48
		scratch_load_dword v71, off, s49 offset:52
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v106, vcc, v70, v92
		v_addc_co_u32_e64 v107, vcc, v71, v93, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v106, s49 offset:184
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[20:23], v[36:39], v[12:15], v5, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s49, s48, 1
		s_and_b32 s50, s48, 1
		s_lshl_b32 s50, s50, 16
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v1, 12, v1
		v_add_u32_e32 v1, s50, v1
		v_and_b32_e32 v4, 15, v0
		v_lshlrev_b32_e32 v7, 6, v4
		v_and_b32_e32 v17, 63, v0
		v_lshrrev_b32_e32 v17, 4, v17
		v_lshrrev_b32_e32 v4, 1, v4
		v_and_b32_e32 v4, 3, v4
		v_xor_b32_e32 v4, v17, v4
		v_lshlrev_b32_e32 v4, 4, v4
		v_add3_u32 v1, v1, v7, v4
		v_add_u32_e32 v1, 16, v1
		s_mov_b32 s50, 0
		scratch_store_dword off, v1, s50 offset:208
		ds_read_b128 v[212:215], v1 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[20:23], v[40:43], v[76:79], v5, v16 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v1 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[20:23], v[44:47], v[80:83], v5, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v1 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[20:23], v[48:51], v[84:87], v5, v19 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v1 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[20:23], v[52:55], v[88:91], v5, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_and_b32_e32 v1, 15, v0
		v_lshlrev_b32_e32 v1, 6, v1
		s_mov_b32 s50, 0
		scratch_store_dword off, v1, s50 offset:192
		v_lshrrev_b32_e32 v4, 6, v0
		v_and_b32_e32 v4, 1, v4
		v_lshlrev_b32_e32 v4, 13, v4
		s_mov_b32 s50, 0
		scratch_store_dword off, v4, s50 offset:188
		v_and_b32_e32 v7, 63, v0
		v_lshrrev_b32_e32 v7, 4, v7
		v_and_b32_e32 v17, 15, v0
		v_lshrrev_b32_e32 v17, 1, v17
		v_and_b32_e32 v17, 3, v17
		v_xor_b32_e32 v7, v7, v17
		v_lshlrev_b32_e32 v7, 4, v7
		s_mov_b32 s50, 0
		scratch_store_dword off, v7, s50 offset:196
		s_and_b32 s50, s48, 1
		s_lshl_b32 s50, s50, 16
		v_add_u32_e32 v1, s50, v1
		v_add3_u32 v1, v1, v4, v7
		v_add_u32_e32 v1, 16, v1
		ds_read_b128 v[228:231], v1 offset:49152
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s50 offset:212
		scratch_store_dword off, v229, s50 offset:216
		scratch_store_dword off, v230, s50 offset:220
		scratch_store_dword off, v231, s50 offset:224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[20:23], v[56:59], v[100:103], v5, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v1 offset:50176
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s50 offset:232
		scratch_store_dword off, v229, s50 offset:236
		scratch_store_dword off, v230, s50 offset:240
		scratch_store_dword off, v231, s50 offset:244
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[20:23], v[60:63], v[108:111], v5, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v1 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[20:23], v[64:67], v[112:115], v5, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[232:235], v1 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[24:27], v[36:39], v[116:119], v5, v16 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[236:239], v1 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[24:27], v[40:43], v[120:123], v5, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[240:243], v1 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[24:27], v[44:47], v[124:127], v5, v19 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[244:247], v1 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[24:27], v[48:51], v[128:131], v5, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[248:251], v1 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[24:27], v[52:55], v[132:135], v5, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(24)
		scratch_load_dword v4, off, s50 offset:144
		s_add_i32 m0, s33, 16
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v4, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[24:27], v[56:59], v[136:139], v5, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(23)
		scratch_load_dword v4, off, s50 offset:148
		s_add_i32 m0, s11, 16
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v4, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[24:27], v[60:63], v[140:143], v5, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(22)
		scratch_load_dword v4, off, s50 offset:152
		s_add_i32 m0, s19, 16
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v4, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[64:67], v[144:147], v5, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(21)
		scratch_load_dword v4, off, s50 offset:156
		s_add_i32 m0, s32, 16
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v4, s[24:27], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[28:31], v[36:39], v[148:151], v6, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(20)
		scratch_load_dword v4, off, s50 offset:160
		s_add_i32 m0, s40, 16
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v4, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[28:31], v[40:43], v[152:155], v6, v16 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(19)
		scratch_load_dword v4, off, s50 offset:164
		s_add_i32 m0, s41, 16
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v4, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[28:31], v[44:47], v[156:159], v6, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(18)
		scratch_load_dword v4, off, s50 offset:168
		s_add_i32 m0, s42, 16
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v4, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[28:31], v[48:51], v[160:163], v6, v19 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(17)
		scratch_load_dword v4, off, s50 offset:172
		s_add_i32 m0, s43, 16
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v4, s[0:3], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[28:31], v[52:55], v[164:167], v6, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(14)
		scratch_load_dword v4, off, s50 offset:176
		s_add_i32 m0, s18, 0x20010
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dword v4, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[28:31], v[56:59], v[168:171], v6, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s50, s48, 1
		s_mov_b32 s51, 0
		s_waitcnt vmcnt(13)
		scratch_load_dword v4, off, s51 offset:180
		s_add_i32 m0, s44, 0x20010
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dword v4, s[4:7], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[28:31], v[60:63], v[172:175], v6, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_lshl_b32 s49, s49, 12
		s_mov_b32 s51, 0
		s_waitcnt vmcnt(12)
		scratch_load_dword v4, off, s51 offset:184
		s_add_i32 m0, s45, 0x20010
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v4, s[28:31], 0 offen lds
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[64:67], v[176:179], v6, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_saveexec_b64 s[52:53], s[16:17]
		v_mov_b32_e32 v4, 8
		v_mov_b32_e32 v7, 1
		s_mov_b32 s51, 0
		scratch_store_dword off, v7, s51 offset:228
		s_waitcnt vmcnt(0)
		ds_add_rtn_u32 v17, v4, v7
		s_mov_b64 exec, s[52:53]
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s51, v17
		s_and_b32 s51, s51, -8
		s_add_i32 s51, s51, 8
		s_and_saveexec_b64 s[52:53], s[16:17]
.Lwmma_f16_matmul_tiled.loop_head_3:
		ds_read_b32 v7, v4
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s54, v7
		s_xor_b32 s55, s51, -1
		s_add_i32 s55, s55, 1
		s_add_i32 s54, s54, s55
		s_cmp_ge_u32 s54, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_3
.Lwmma_f16_matmul_tiled.loop_exit_3:
		s_mov_b64 exec, s[52:53]
		s_mov_b32 s51, 0
		s_waitcnt vmcnt(12)
		scratch_load_dword v4, off, s51 offset:208
		s_waitcnt vmcnt(0)
		ds_read_b128 v[20:23], v4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[32:35], v[36:39], v[180:183], v6, v16 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s51, 0
		scratch_load_dword v4, off, s51 offset:208
		s_waitcnt vmcnt(0)
		ds_read_b128 v[24:27], v4 offset:1024
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[32:35], v[40:43], v[184:187], v6, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s51, 0
		scratch_load_dword v4, off, s51 offset:208
		s_waitcnt vmcnt(0)
		ds_read_b128 v[28:31], v4 offset:2048
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[32:35], v[44:47], v[188:191], v6, v19 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s51, 0
		scratch_load_dword v4, off, s51 offset:208
		s_waitcnt vmcnt(0)
		ds_read_b128 v[36:39], v4 offset:3072
		s_mov_b32 s51, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v36, s51 offset:248
		scratch_store_dword off, v37, s51 offset:252
		scratch_store_dword off, v38, s51 offset:256
		scratch_store_dword off, v39, s51 offset:260
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[32:35], v[48:51], v[192:195], v6, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[36:39], v1 offset:32768
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[32:35], v[52:55], v[196:199], v6, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[40:43], v1 offset:33792
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[32:35], v[56:59], v[200:203], v6, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[44:47], v1 offset:34816
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[32:35], v[60:63], v[204:207], v6, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[48:51], v1 offset:35840
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[64:67], v[208:211], v6, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[52:55], v1 offset:36864
		ds_read_b128 v[56:59], v1 offset:37888
		ds_read_b128 v[60:63], v1 offset:38912
		ds_read_b128 v[64:67], v1 offset:39936
		s_add_i32 s49, s49, 0x20000
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v1, 9, v1
		v_and_b32_e32 v4, 63, v0
		v_lshlrev_b32_e32 v4, 2, v4
		v_add3_u32 v7, s49, v1, v4
		v_add_u32_e32 v7, 16, v7
		ds_read_b32 v17, v7
		s_mov_b32 s51, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v17, s51 offset:264
		ds_read_b32 v17, v7 offset:256
		s_mov_b32 s51, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v17, s51 offset:268
		v_lshrrev_b32_e32 v7, 6, v0
		v_and_b32_e32 v7, 1, v7
		v_lshlrev_b32_e32 v7, 10, v7
		v_add3_u32 v17, s49, v4, v7
		v_add_u32_e32 v17, 16, v17
		ds_read_b32 v18, v17 offset:2048
		s_mov_b32 s49, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v18, s49 offset:272
		ds_read_b32 v18, v17 offset:2304
		s_mov_b32 s49, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v18, s49 offset:276
		ds_read_b32 v18, v17 offset:2560
		s_mov_b32 s49, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v18, s49 offset:280
		ds_read_b32 v18, v17 offset:2816
		s_mov_b32 s49, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v18, s49 offset:284
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(15)
		scratch_load_dword v32, off, s49 offset:212
		scratch_load_dword v33, off, s49 offset:216
		scratch_load_dword v34, off, s49 offset:220
		scratch_load_dword v35, off, s49 offset:224
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[212:215], v[32:35], v[12:15], v5, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(11)
		scratch_load_dword v32, off, s49 offset:232
		scratch_load_dword v33, off, s49 offset:236
		scratch_load_dword v34, off, s49 offset:240
		scratch_load_dword v35, off, s49 offset:244
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[212:215], v[32:35], v[76:79], v5, v16 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		scratch_load_dword v32, off, s49 offset:232
		scratch_load_dword v33, off, s49 offset:236
		scratch_load_dword v34, off, s49 offset:240
		scratch_load_dword v35, off, s49 offset:244
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[216:219], v[32:35], v[120:123], v5, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		scratch_load_dword v32, off, s49 offset:212
		scratch_load_dword v33, off, s49 offset:216
		scratch_load_dword v34, off, s49 offset:220
		scratch_load_dword v35, off, s49 offset:224
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[216:219], v[32:35], v[116:119], v5, v16 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[216:219], v[228:231], v[124:127], v5, v19 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[212:215], v[228:231], v[80:83], v5, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[212:215], v[232:235], v[84:87], v5, v19 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[216:219], v[232:235], v[128:131], v5, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[216:219], v[236:239], v[132:135], v5, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[212:215], v[236:239], v[88:91], v5, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[212:215], v[240:243], v[100:103], v5, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[216:219], v[240:243], v[136:139], v5, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[216:219], v[244:247], v[140:143], v5, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[212:215], v[244:247], v[108:111], v5, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[212:215], v[248:251], v[112:115], v5, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[216:219], v[248:251], v[144:147], v5, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[220:223], v[248:251], v[176:179], v6, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[220:223], v[244:247], v[172:175], v6, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[224:227], v[244:247], v[204:207], v6, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[224:227], v[248:251], v[208:211], v6, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		scratch_load_dword v32, off, s49 offset:212
		scratch_load_dword v33, off, s49 offset:216
		scratch_load_dword v34, off, s49 offset:220
		scratch_load_dword v35, off, s49 offset:224
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[224:227], v[32:35], v[180:183], v6, v16 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		scratch_load_dword v32, off, s49 offset:212
		scratch_load_dword v33, off, s49 offset:216
		scratch_load_dword v34, off, s49 offset:220
		scratch_load_dword v35, off, s49 offset:224
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[220:223], v[32:35], v[148:151], v6, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		scratch_load_dword v32, off, s49 offset:232
		scratch_load_dword v33, off, s49 offset:236
		scratch_load_dword v34, off, s49 offset:240
		scratch_load_dword v35, off, s49 offset:244
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[220:223], v[32:35], v[152:155], v6, v16 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		scratch_load_dword v32, off, s49 offset:232
		scratch_load_dword v33, off, s49 offset:236
		scratch_load_dword v34, off, s49 offset:240
		scratch_load_dword v35, off, s49 offset:244
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[224:227], v[32:35], v[184:187], v6, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[224:227], v[228:231], v[188:191], v6, v19 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[220:223], v[228:231], v[156:159], v6, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[220:223], v[232:235], v[160:163], v6, v19 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[224:227], v[232:235], v[192:195], v6, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[224:227], v[236:239], v[196:199], v6, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[220:223], v[236:239], v[164:167], v6, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[220:223], v[240:243], v[168:171], v6, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[224:227], v[240:243], v[200:203], v6, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s49, s50, 1
		s_lshl_b32 s50, s49, 16
		v_lshrrev_b32_e32 v5, 7, v0
		v_lshlrev_b32_e32 v5, 12, v5
		s_mov_b32 s51, 0
		scratch_store_dword off, v5, s51 offset:320
		v_add_u32_e32 v5, s50, v5
		s_mov_b32 s51, 0
		scratch_load_dword v6, off, s51 offset:192
		s_mov_b32 s51, 0
		scratch_load_dword v16, off, s51 offset:196
		s_waitcnt vmcnt(0)
		v_add3_u32 v5, v5, v6, v16
		v_add_u32_e32 v5, 16, v5
		ds_read_b128 v[32:35], v5
		s_mov_b32 s51, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v32, s51 offset:384
		scratch_store_dword off, v33, s51 offset:388
		scratch_store_dword off, v34, s51 offset:392
		scratch_store_dword off, v35, s51 offset:396
		ds_read_b128 v[68:71], v5 offset:1024
		s_mov_b32 s51, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v68, s51 offset:516
		scratch_store_dword off, v69, s51 offset:520
		scratch_store_dword off, v70, s51 offset:524
		scratch_store_dword off, v71, s51 offset:528
		ds_read_b128 v[212:215], v5 offset:2048
		ds_read_b128 v[216:219], v5 offset:3072
		s_mov_b32 s51, 0
		scratch_load_dword v5, off, s51 offset:192
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v17, s50, v5
		s_mov_b32 s50, 0
		scratch_load_dword v18, off, s50 offset:188
		s_mov_b32 s50, 0
		scratch_load_dword v19, off, s50 offset:196
		s_waitcnt vmcnt(0)
		v_add3_u32 v17, v17, v18, v19
		v_add_u32_e32 v17, 16, v17
		ds_read_b128 v[220:223], v17 offset:32768
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v220, s50 offset:336
		scratch_store_dword off, v221, s50 offset:340
		scratch_store_dword off, v222, s50 offset:344
		scratch_store_dword off, v223, s50 offset:348
		ds_read_b128 v[224:227], v17 offset:33792
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v224, s50 offset:352
		scratch_store_dword off, v225, s50 offset:356
		scratch_store_dword off, v226, s50 offset:360
		scratch_store_dword off, v227, s50 offset:364
		ds_read_b128 v[228:231], v17 offset:34816
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s50 offset:368
		scratch_store_dword off, v229, s50 offset:372
		scratch_store_dword off, v230, s50 offset:376
		scratch_store_dword off, v231, s50 offset:380
		ds_read_b128 v[232:235], v17 offset:35840
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v232, s50 offset:400
		scratch_store_dword off, v233, s50 offset:404
		scratch_store_dword off, v234, s50 offset:408
		scratch_store_dword off, v235, s50 offset:412
		ds_read_b128 v[236:239], v17 offset:36864
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v236, s50 offset:416
		scratch_store_dword off, v237, s50 offset:420
		scratch_store_dword off, v238, s50 offset:424
		scratch_store_dword off, v239, s50 offset:428
		ds_read_b128 v[240:243], v17 offset:37888
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v240, s50 offset:432
		scratch_store_dword off, v241, s50 offset:436
		scratch_store_dword off, v242, s50 offset:440
		scratch_store_dword off, v243, s50 offset:444
		ds_read_b128 v[244:247], v17 offset:38912
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v244, s50 offset:448
		scratch_store_dword off, v245, s50 offset:452
		scratch_store_dword off, v246, s50 offset:456
		scratch_store_dword off, v247, s50 offset:460
		s_add_i32 s50, s48, 1
		s_and_b32 s50, s50, 1
		s_lshl_b32 s50, s50, 16
		v_add_u32_e32 v5, s50, v5
		v_add3_u32 v5, v5, v18, v19
		v_add_u32_e32 v5, 16, v5
		s_mov_b32 s50, 0
		scratch_store_dword off, v5, s50 offset:464
		ds_read_b128 v[248:251], v5 offset:39936
		s_mov_b32 s50, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v248, s50 offset:468
		scratch_store_dword off, v249, s50 offset:472
		scratch_store_dword off, v250, s50 offset:476
		scratch_store_dword off, v251, s50 offset:480
		s_lshl_b32 s49, s49, 12
		s_add_i32 s49, s49, 0x20000
		v_add3_u32 v1, s49, v1, v4
		v_add_u32_e32 v1, 16, v1
		ds_read_b32 v17, v1
		ds_read_b32 v18, v1 offset:256
		v_add3_u32 v1, s49, v4, v7
		v_add_u32_e32 v1, 16, v1
		ds_read_b32 v4, v1 offset:2048
		ds_read_b32 v7, v1 offset:2304
		ds_read_b32 v19, v1 offset:2560
		ds_read_b32 v92, v1 offset:2816
		s_mov_b32 s49, 0
		scratch_load_dword v106, off, s49 offset:56
		scratch_load_dword v107, off, s49 offset:60
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v252, vcc, v106, v10
		v_addc_co_u32_e64 v253, vcc, v107, v11, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v252, s49 offset:288
		s_mov_b32 s49, 0
		scratch_load_dword v106, off, s49 offset:64
		scratch_load_dword v107, off, s49 offset:68
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v252, vcc, v106, v10
		v_addc_co_u32_e64 v253, vcc, v107, v11, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v252, s49 offset:292
		s_mov_b32 s49, 0
		scratch_load_dword v106, off, s49 offset:72
		scratch_load_dword v107, off, s49 offset:76
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v252, vcc, v106, v10
		v_addc_co_u32_e64 v253, vcc, v107, v11, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v252, s49 offset:296
		s_mov_b32 s49, 0
		scratch_load_dword v106, off, s49 offset:80
		scratch_load_dword v107, off, s49 offset:84
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v252, vcc, v106, v10
		v_addc_co_u32_e64 v253, vcc, v107, v11, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v252, s49 offset:300
		s_mov_b32 s49, 0
		scratch_load_dword v106, off, s49 offset:88
		scratch_load_dword v107, off, s49 offset:92
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v252, vcc, v106, v10
		v_addc_co_u32_e64 v253, vcc, v107, v11, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v252, s49 offset:304
		s_mov_b32 s49, 0
		scratch_load_dword v106, off, s49 offset:96
		scratch_load_dword v107, off, s49 offset:100
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v252, vcc, v106, v10
		v_addc_co_u32_e64 v253, vcc, v107, v11, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v252, s49 offset:308
		s_mov_b32 s49, 0
		scratch_load_dword v106, off, s49 offset:104
		scratch_load_dword v107, off, s49 offset:108
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v252, vcc, v106, v10
		v_addc_co_u32_e64 v253, vcc, v107, v11, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v252, s49 offset:312
		s_mov_b32 s49, 0
		scratch_load_dword v106, off, s49 offset:112
		scratch_load_dword v107, off, s49 offset:116
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v252, vcc, v106, v10
		v_addc_co_u32_e64 v253, vcc, v107, v11, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v252, s49 offset:316
		s_mov_b32 s49, 0
		scratch_load_dword v10, off, s49 offset:120
		scratch_load_dword v11, off, s49 offset:124
		s_mov_b32 s49, 0
		scratch_load_dword v106, off, s49 offset:200
		scratch_load_dword v107, off, s49 offset:204
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v252, vcc, v10, v106
		v_addc_co_u32_e64 v253, vcc, v11, v107, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v252, s49 offset:324
		s_mov_b32 s49, 0
		scratch_load_dword v10, off, s49 offset:128
		scratch_load_dword v11, off, s49 offset:132
		s_mov_b32 s49, 0
		scratch_load_dword v106, off, s49 offset:200
		scratch_load_dword v107, off, s49 offset:204
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v252, vcc, v10, v106
		v_addc_co_u32_e64 v253, vcc, v11, v107, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v252, s49 offset:328
		s_mov_b32 s49, 0
		scratch_load_dword v10, off, s49 offset:136
		scratch_load_dword v11, off, s49 offset:140
		s_mov_b32 s49, 0
		scratch_load_dword v106, off, s49 offset:200
		scratch_load_dword v107, off, s49 offset:204
		s_waitcnt vmcnt(0)
		v_add_co_u32_e64 v252, vcc, v10, v106
		v_addc_co_u32_e64 v253, vcc, v11, v107, vcc
		s_mov_b32 s49, 0
		scratch_store_dword off, v252, s49 offset:332
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[32:35], v[220:223], v[12:15], v17, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s49, s48, 1
		s_and_b32 s49, s49, 1
		s_lshl_b32 s49, s49, 16
		s_mov_b32 s50, 0
		s_waitcnt vmcnt(52)
		scratch_load_dword v1, off, s50 offset:320
		s_waitcnt vmcnt(0)
		v_add_u32_e32 v1, s49, v1
		v_add3_u32 v1, v1, v6, v16
		v_add_u32_e32 v1, 16, v1
		ds_read_b128 v[220:223], v1 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[32:35], v[224:227], v[76:79], v17, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v1 offset:17408
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[32:35], v[228:231], v[80:83], v17, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v1 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[32:35], v[232:235], v[84:87], v17, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[232:235], v1 offset:19456
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[32:35], v[236:239], v[88:91], v17, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[32:35], v5 offset:49152
		s_mov_b32 s49, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v32, s49 offset:484
		scratch_store_dword off, v33, s49 offset:488
		scratch_store_dword off, v34, s49 offset:492
		scratch_store_dword off, v35, s49 offset:496
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(52)
		scratch_load_dword v32, off, s49 offset:384
		scratch_load_dword v33, off, s49 offset:388
		scratch_load_dword v34, off, s49 offset:392
		scratch_load_dword v35, off, s49 offset:396
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[32:35], v[240:243], v[100:103], v17, v19 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[32:35], v5 offset:50176
		s_mov_b32 s49, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v32, s49 offset:500
		scratch_store_dword off, v33, s49 offset:504
		scratch_store_dword off, v34, s49 offset:508
		scratch_store_dword off, v35, s49 offset:512
		s_mov_b32 s49, 0
		scratch_load_dword v32, off, s49 offset:384
		scratch_load_dword v33, off, s49 offset:388
		scratch_load_dword v34, off, s49 offset:392
		scratch_load_dword v35, off, s49 offset:396
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[32:35], v[244:247], v[108:111], v17, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[32:35], v5 offset:51200
		s_mov_b32 s49, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v32, s49 offset:532
		scratch_store_dword off, v33, s49 offset:536
		scratch_store_dword off, v34, s49 offset:540
		scratch_store_dword off, v35, s49 offset:544
		s_mov_b32 s49, 0
		scratch_load_dword v32, off, s49 offset:384
		scratch_load_dword v33, off, s49 offset:388
		scratch_load_dword v34, off, s49 offset:392
		scratch_load_dword v35, off, s49 offset:396
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[32:35], v[248:251], v[112:115], v17, v92 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[32:35], v5 offset:52224
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(52)
		scratch_load_dword v236, off, s49 offset:336
		scratch_load_dword v237, off, s49 offset:340
		scratch_load_dword v238, off, s49 offset:344
		scratch_load_dword v239, off, s49 offset:348
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[68:71], v[236:239], v[116:119], v17, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[236:239], v5 offset:53248
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(48)
		scratch_load_dword v240, off, s49 offset:352
		scratch_load_dword v241, off, s49 offset:356
		scratch_load_dword v242, off, s49 offset:360
		scratch_load_dword v243, off, s49 offset:364
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[68:71], v[240:243], v[120:123], v17, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(27)
		scratch_load_dword v1, off, s49 offset:464
		s_waitcnt vmcnt(0)
		ds_read_b128 v[240:243], v1 offset:54272
		s_mov_b32 s49, 0
		scratch_load_dword v244, off, s49 offset:368
		scratch_load_dword v245, off, s49 offset:372
		scratch_load_dword v246, off, s49 offset:376
		scratch_load_dword v247, off, s49 offset:380
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[68:71], v[244:247], v[124:127], v17, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		scratch_load_dword v1, off, s49 offset:464
		s_waitcnt vmcnt(0)
		ds_read_b128 v[244:247], v1 offset:55296
		s_mov_b32 s49, 0
		scratch_load_dword v248, off, s49 offset:400
		scratch_load_dword v249, off, s49 offset:404
		scratch_load_dword v250, off, s49 offset:408
		scratch_load_dword v251, off, s49 offset:412
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[68:71], v[248:251], v[128:131], v17, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		scratch_load_dword v1, off, s49 offset:464
		s_waitcnt vmcnt(0)
		ds_read_b128 v[68:71], v1 offset:56320
		s_mov_b32 s49, 0
		scratch_load_dword v248, off, s49 offset:416
		scratch_load_dword v249, off, s49 offset:420
		scratch_load_dword v250, off, s49 offset:424
		scratch_load_dword v251, off, s49 offset:428
		s_mov_b32 s49, 0
		scratch_load_dword v252, off, s49 offset:516
		scratch_load_dword v253, off, s49 offset:520
		scratch_load_dword v254, off, s49 offset:524
		scratch_load_dword v255, off, s49 offset:528
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[252:255], v[248:251], v[132:135], v17, v19 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(22)
		scratch_load_dword v1, off, s49 offset:288
		s_add_i32 m0, s15, 16
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		s_mov_b32 s49, 0
		scratch_load_dword v248, off, s49 offset:432
		scratch_load_dword v249, off, s49 offset:436
		scratch_load_dword v250, off, s49 offset:440
		scratch_load_dword v251, off, s49 offset:444
		s_mov_b32 s49, 0
		scratch_load_dword v252, off, s49 offset:516
		scratch_load_dword v253, off, s49 offset:520
		scratch_load_dword v254, off, s49 offset:524
		scratch_load_dword v255, off, s49 offset:528
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[252:255], v[248:251], v[136:139], v17, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(21)
		scratch_load_dword v1, off, s49 offset:292
		s_add_i32 m0, s46, 16
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		s_mov_b32 s49, 0
		scratch_load_dword v248, off, s49 offset:448
		scratch_load_dword v249, off, s49 offset:452
		scratch_load_dword v250, off, s49 offset:456
		scratch_load_dword v251, off, s49 offset:460
		s_mov_b32 s49, 0
		scratch_load_dword v252, off, s49 offset:516
		scratch_load_dword v253, off, s49 offset:520
		scratch_load_dword v254, off, s49 offset:524
		scratch_load_dword v255, off, s49 offset:528
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[252:255], v[248:251], v[140:143], v17, v92 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(20)
		scratch_load_dword v1, off, s49 offset:296
		s_add_i32 m0, s47, 16
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		s_mov_b32 s49, 0
		scratch_load_dword v248, off, s49 offset:468
		scratch_load_dword v249, off, s49 offset:472
		scratch_load_dword v250, off, s49 offset:476
		scratch_load_dword v251, off, s49 offset:480
		s_mov_b32 s49, 0
		scratch_load_dword v252, off, s49 offset:516
		scratch_load_dword v253, off, s49 offset:520
		scratch_load_dword v254, off, s49 offset:524
		scratch_load_dword v255, off, s49 offset:528
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[252:255], v[248:251], v[144:147], v17, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(19)
		scratch_load_dword v1, off, s49 offset:300
		s_add_i32 m0, s35, 16
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		s_mov_b32 s49, 0
		scratch_load_dword v248, off, s49 offset:336
		scratch_load_dword v249, off, s49 offset:340
		scratch_load_dword v250, off, s49 offset:344
		scratch_load_dword v251, off, s49 offset:348
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[212:215], v[248:251], v[148:151], v18, v4 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(18)
		scratch_load_dword v1, off, s49 offset:304
		s_add_i32 m0, s36, 16
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v1, s[0:3], 0 offen lds
		s_mov_b32 s49, 0
		scratch_load_dword v248, off, s49 offset:352
		scratch_load_dword v249, off, s49 offset:356
		scratch_load_dword v250, off, s49 offset:360
		scratch_load_dword v251, off, s49 offset:364
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[212:215], v[248:251], v[152:155], v18, v4 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(17)
		scratch_load_dword v1, off, s49 offset:308
		s_add_i32 m0, s37, 16
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v1, s[0:3], 0 offen lds
		s_mov_b32 s49, 0
		scratch_load_dword v248, off, s49 offset:368
		scratch_load_dword v249, off, s49 offset:372
		scratch_load_dword v250, off, s49 offset:376
		scratch_load_dword v251, off, s49 offset:380
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[212:215], v[248:251], v[156:159], v18, v7 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(16)
		scratch_load_dword v1, off, s49 offset:312
		s_add_i32 m0, s38, 16
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v1, s[0:3], 0 offen lds
		s_mov_b32 s49, 0
		scratch_load_dword v248, off, s49 offset:400
		scratch_load_dword v249, off, s49 offset:404
		scratch_load_dword v250, off, s49 offset:408
		scratch_load_dword v251, off, s49 offset:412
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[212:215], v[248:251], v[160:163], v18, v7 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(15)
		scratch_load_dword v1, off, s49 offset:316
		s_add_i32 m0, s39, 16
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v1, s[0:3], 0 offen lds
		s_mov_b32 s49, 0
		scratch_load_dword v248, off, s49 offset:416
		scratch_load_dword v249, off, s49 offset:420
		scratch_load_dword v250, off, s49 offset:424
		scratch_load_dword v251, off, s49 offset:428
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[212:215], v[248:251], v[164:167], v18, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(14)
		scratch_load_dword v1, off, s49 offset:324
		s_add_i32 m0, s34, 0x20010
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dword v1, s[4:7], 0 offen lds
		s_mov_b32 s49, 0
		scratch_load_dword v248, off, s49 offset:432
		scratch_load_dword v249, off, s49 offset:436
		scratch_load_dword v250, off, s49 offset:440
		scratch_load_dword v251, off, s49 offset:444
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[212:215], v[248:251], v[168:171], v18, v19 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(13)
		scratch_load_dword v1, off, s49 offset:328
		s_add_i32 m0, s9, 0x20010
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dword v1, s[4:7], 0 offen lds
		s_mov_b32 s49, 0
		scratch_load_dword v248, off, s49 offset:448
		scratch_load_dword v249, off, s49 offset:452
		scratch_load_dword v250, off, s49 offset:456
		scratch_load_dword v251, off, s49 offset:460
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[212:215], v[248:251], v[172:175], v18, v92 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_add_i32 s48, s48, 2
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(12)
		scratch_load_dword v1, off, s49 offset:332
		s_add_i32 m0, s10, 0x20010
		s_waitcnt vmcnt(0)
		s_nop 0
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		s_mov_b32 s49, 0
		scratch_load_dword v248, off, s49 offset:468
		scratch_load_dword v249, off, s49 offset:472
		scratch_load_dword v250, off, s49 offset:476
		scratch_load_dword v251, off, s49 offset:480
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[212:215], v[248:251], v[176:179], v18, v92 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		scratch_load_dword v212, off, s49 offset:468
		scratch_load_dword v213, off, s49 offset:472
		scratch_load_dword v214, off, s49 offset:476
		scratch_load_dword v215, off, s49 offset:480
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[216:219], v[212:215], v[208:211], v18, v92 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		scratch_load_dword v212, off, s49 offset:448
		scratch_load_dword v213, off, s49 offset:452
		scratch_load_dword v214, off, s49 offset:456
		scratch_load_dword v215, off, s49 offset:460
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[216:219], v[212:215], v[204:207], v18, v92 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		scratch_load_dword v212, off, s49 offset:336
		scratch_load_dword v213, off, s49 offset:340
		scratch_load_dword v214, off, s49 offset:344
		scratch_load_dword v215, off, s49 offset:348
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[216:219], v[212:215], v[180:183], v18, v4 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		scratch_load_dword v212, off, s49 offset:352
		scratch_load_dword v213, off, s49 offset:356
		scratch_load_dword v214, off, s49 offset:360
		scratch_load_dword v215, off, s49 offset:364
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[216:219], v[212:215], v[184:187], v18, v4 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		scratch_load_dword v212, off, s49 offset:368
		scratch_load_dword v213, off, s49 offset:372
		scratch_load_dword v214, off, s49 offset:376
		scratch_load_dword v215, off, s49 offset:380
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[216:219], v[212:215], v[188:191], v18, v7 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		scratch_load_dword v212, off, s49 offset:400
		scratch_load_dword v213, off, s49 offset:404
		scratch_load_dword v214, off, s49 offset:408
		scratch_load_dword v215, off, s49 offset:412
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[216:219], v[212:215], v[192:195], v18, v7 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		scratch_load_dword v212, off, s49 offset:416
		scratch_load_dword v213, off, s49 offset:420
		scratch_load_dword v214, off, s49 offset:424
		scratch_load_dword v215, off, s49 offset:428
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[216:219], v[212:215], v[196:199], v18, v19 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		scratch_load_dword v212, off, s49 offset:432
		scratch_load_dword v213, off, s49 offset:436
		scratch_load_dword v214, off, s49 offset:440
		scratch_load_dword v215, off, s49 offset:444
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[216:219], v[212:215], v[200:203], v18, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_saveexec_b64 s[50:51], s[16:17]
		v_mov_b32_e32 v1, 12
		s_mov_b32 s49, 0
		scratch_load_dword v5, off, s49 offset:228
		s_waitcnt vmcnt(0)
		ds_add_rtn_u32 v6, v1, v5
		s_mov_b64 exec, s[50:51]
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s49, v6
		s_and_b32 s49, s49, -8
		s_add_i32 s49, s49, 8
		s_and_saveexec_b64 s[50:51], s[16:17]
.Lwmma_f16_matmul_tiled.loop_head_4:
		ds_read_b32 v5, v1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s52, v5
		s_xor_b32 s53, s49, -1
		s_add_i32 s53, s53, 1
		s_add_i32 s52, s52, s53
		s_cmp_ge_u32 s52, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_4
.Lwmma_f16_matmul_tiled.loop_exit_4:
		s_mov_b64 exec, s[50:51]
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(8)
		scratch_load_dword v212, off, s49 offset:484
		scratch_load_dword v213, off, s49 offset:488
		scratch_load_dword v214, off, s49 offset:492
		scratch_load_dword v215, off, s49 offset:496
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[220:223], v[212:215], v[12:15], v17, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v212, off, s49 offset:500
		scratch_load_dword v213, off, s49 offset:504
		scratch_load_dword v214, off, s49 offset:508
		scratch_load_dword v215, off, s49 offset:512
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[220:223], v[212:215], v[76:79], v17, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		scratch_load_dword v212, off, s49 offset:500
		scratch_load_dword v213, off, s49 offset:504
		scratch_load_dword v214, off, s49 offset:508
		scratch_load_dword v215, off, s49 offset:512
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[224:227], v[212:215], v[120:123], v17, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		scratch_load_dword v212, off, s49 offset:484
		scratch_load_dword v213, off, s49 offset:488
		scratch_load_dword v214, off, s49 offset:492
		scratch_load_dword v215, off, s49 offset:496
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[224:227], v[212:215], v[116:119], v17, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v212, off, s49 offset:532
		scratch_load_dword v213, off, s49 offset:536
		scratch_load_dword v214, off, s49 offset:540
		scratch_load_dword v215, off, s49 offset:544
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[224:227], v[212:215], v[124:127], v17, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		scratch_load_dword v212, off, s49 offset:532
		scratch_load_dword v213, off, s49 offset:536
		scratch_load_dword v214, off, s49 offset:540
		scratch_load_dword v215, off, s49 offset:544
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[220:223], v[212:215], v[80:83], v17, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[220:223], v[32:35], v[84:87], v17, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[224:227], v[32:35], v[128:131], v17, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[224:227], v[236:239], v[132:135], v17, v19 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[220:223], v[236:239], v[88:91], v17, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[220:223], v[240:243], v[100:103], v17, v19 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[224:227], v[240:243], v[136:139], v17, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[224:227], v[244:247], v[140:143], v17, v92 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[220:223], v[244:247], v[108:111], v17, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[220:223], v[68:71], v[112:115], v17, v92 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[224:227], v[68:71], v[144:147], v17, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[228:231], v[68:71], v[176:179], v18, v92 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[228:231], v[244:247], v[172:175], v18, v92 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[232:235], v[244:247], v[204:207], v18, v92 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[232:235], v[68:71], v[208:211], v18, v92 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		scratch_load_dword v68, off, s49 offset:484
		scratch_load_dword v69, off, s49 offset:488
		scratch_load_dword v70, off, s49 offset:492
		scratch_load_dword v71, off, s49 offset:496
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[232:235], v[68:71], v[180:183], v18, v4 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		scratch_load_dword v68, off, s49 offset:484
		scratch_load_dword v69, off, s49 offset:488
		scratch_load_dword v70, off, s49 offset:492
		scratch_load_dword v71, off, s49 offset:496
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[228:231], v[68:71], v[148:151], v18, v4 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		scratch_load_dword v68, off, s49 offset:500
		scratch_load_dword v69, off, s49 offset:504
		scratch_load_dword v70, off, s49 offset:508
		scratch_load_dword v71, off, s49 offset:512
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[228:231], v[68:71], v[152:155], v18, v4 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		scratch_load_dword v68, off, s49 offset:500
		scratch_load_dword v69, off, s49 offset:504
		scratch_load_dword v70, off, s49 offset:508
		scratch_load_dword v71, off, s49 offset:512
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[232:235], v[68:71], v[184:187], v18, v4 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		scratch_load_dword v68, off, s49 offset:532
		scratch_load_dword v69, off, s49 offset:536
		scratch_load_dword v70, off, s49 offset:540
		scratch_load_dword v71, off, s49 offset:544
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[232:235], v[68:71], v[188:191], v18, v7 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		scratch_load_dword v68, off, s49 offset:532
		scratch_load_dword v69, off, s49 offset:536
		scratch_load_dword v70, off, s49 offset:540
		scratch_load_dword v71, off, s49 offset:544
		s_waitcnt vmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[228:231], v[68:71], v[156:159], v18, v7 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[228:231], v[32:35], v[160:163], v18, v7 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[232:235], v[32:35], v[192:195], v18, v7 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[232:235], v[236:239], v[196:199], v18, v19 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[228:231], v[236:239], v[164:167], v18, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[228:231], v[240:243], v[168:171], v18, v19 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[232:235], v[240:243], v[200:203], v18, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_mov_b32 s49, 0
		scratch_load_dword v4, off, s49 offset:248
		scratch_load_dword v5, off, s49 offset:252
		scratch_load_dword v6, off, s49 offset:256
		scratch_load_dword v7, off, s49 offset:260
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v32, v4
		v_mov_b32_e32 v33, v5
		v_mov_b32_e32 v34, v6
		v_mov_b32_e32 v35, v7
		s_mov_b32 s49, 0
		scratch_load_dword v1, off, s49 offset:264
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v5, v1
		s_mov_b32 s49, 0
		scratch_load_dword v1, off, s49 offset:268
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v6, v1
		s_mov_b32 s49, 0
		scratch_load_dword v1, off, s49 offset:272
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v16, v1
		s_mov_b32 s49, 0
		scratch_load_dword v1, off, s49 offset:276
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v19, v1
		s_mov_b32 s49, 0
		scratch_load_dword v1, off, s49 offset:280
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v68, v1
		s_mov_b32 s49, 0
		scratch_load_dword v1, off, s49 offset:284
		s_waitcnt vmcnt(0)
		v_mov_b32_e32 v69, v1
		s_cmp_lt_i32 s48, s8
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_2
.Lwmma_f16_matmul_tiled.loop_exit_2:
		s_add_i32 s0, s12, -1
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[20:23], v[36:39], v[12:15], v5, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_and_b32 s0, s0, 1
		s_lshl_b32 s0, s0, 16
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v1, 12, v1
		v_add_u32_e32 v2, s0, v1
		v_and_b32_e32 v3, 15, v0
		v_lshlrev_b32_e32 v3, 6, v3
		v_and_b32_e32 v4, 63, v0
		v_lshrrev_b32_e32 v4, 4, v4
		v_and_b32_e32 v7, 15, v0
		v_lshrrev_b32_e32 v7, 1, v7
		v_and_b32_e32 v7, 3, v7
		v_xor_b32_e32 v4, v4, v7
		v_lshlrev_b32_e32 v4, 4, v4
		v_add3_u32 v2, v2, v3, v4
		v_add_u32_e32 v2, 16, v2
		ds_read_b128 v[8:11], v2 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[20:23], v[40:43], v[76:79], v5, v16 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[72:75], v2 offset:17408
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[20:23], v[44:47], v[80:83], v5, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v2 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[20:23], v[48:51], v[84:87], v5, v19 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v2 offset:19456
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[20:23], v[52:55], v[88:91], v5, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_add_u32_e32 v2, s0, v3
		v_lshrrev_b32_e32 v7, 6, v0
		v_and_b32_e32 v7, 1, v7
		v_lshlrev_b32_e32 v7, 13, v7
		v_add3_u32 v2, v2, v7, v4
		v_add_u32_e32 v2, 16, v2
		ds_read_b128 v[104:107], v2 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[20:23], v[56:59], v[100:103], v5, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[212:215], v2 offset:50176
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[20:23], v[60:63], v[108:111], v5, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v2 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[20:23], v[64:67], v[112:115], v5, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[20:23], v2 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[24:27], v[36:39], v[116:119], v5, v16 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v2 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[24:27], v[40:43], v[120:123], v5, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v2 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[24:27], v[44:47], v[124:127], v5, v19 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v2 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[24:27], v[48:51], v[128:131], v5, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[232:235], v2 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[24:27], v[52:55], v[132:135], v5, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[24:27], v[56:59], v[136:139], v5, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[24:27], v[60:63], v[140:143], v5, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[24:27], v[64:67], v[144:147], v5, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[28:31], v[64:67], v[176:179], v6, v69 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[28:31], v[60:63], v[172:175], v6, v69 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[32:35], v[60:63], v[204:207], v6, v69 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[32:35], v[64:67], v[208:211], v6, v69 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[32:35], v[36:39], v[180:183], v6, v16 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[28:31], v[36:39], v[148:151], v6, v16 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[28:31], v[40:43], v[152:155], v6, v16 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[32:35], v[40:43], v[184:187], v6, v16 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[32:35], v[44:47], v[188:191], v6, v19 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[28:31], v[44:47], v[156:159], v6, v19 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[28:31], v[48:51], v[160:163], v6, v19 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[32:35], v[48:51], v[192:195], v6, v19 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[32:35], v[52:55], v[196:199], v6, v68 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[28:31], v[52:55], v[164:167], v6, v68 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[28:31], v[56:59], v[168:171], v6, v68 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[32:35], v[56:59], v[200:203], v6, v68 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[92:95], v[220:223], v[164:167], v6, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[92:95], v[224:227], v[168:171], v6, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[96:99], v[224:227], v[200:203], v6, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[96:99], v[220:223], v[196:199], v6, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[8:11], v[220:223], v[88:91], v5, v68 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[8:11], v[224:227], v[100:103], v5, v68 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[72:75], v[224:227], v[136:139], v5, v68 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[72:75], v[220:223], v[132:135], v5, v68 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[72:75], v[104:107], v[116:119], v5, v16 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[8:11], v[104:107], v[12:15], v5, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[8:11], v[212:215], v[76:79], v5, v16 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[72:75], v[212:215], v[120:123], v5, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[72:75], v[216:219], v[124:127], v5, v19 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[8:11], v[216:219], v[80:83], v5, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[8:11], v[20:23], v[84:87], v5, v19 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[72:75], v[20:23], v[128:131], v5, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[72:75], v[228:231], v[140:143], v5, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[8:11], v[228:231], v[108:111], v5, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[8:11], v[232:235], v[112:115], v5, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[72:75], v[232:235], v[144:147], v5, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[92:95], v[232:235], v[176:179], v6, v69 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[92:95], v[228:231], v[172:175], v6, v69 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[96:99], v[228:231], v[204:207], v6, v69 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[96:99], v[232:235], v[208:211], v6, v69 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[96:99], v[104:107], v[180:183], v6, v16 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[92:95], v[104:107], v[148:151], v6, v16 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[92:95], v[212:215], v[152:155], v6, v16 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[96:99], v[212:215], v[184:187], v6, v16 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[96:99], v[216:219], v[188:191], v6, v19 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[92:95], v[216:219], v[156:159], v6, v19 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[92:95], v[20:23], v[160:163], v6, v19 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[96:99], v[20:23], v[192:195], v6, v19 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_and_b32 s0, s12, 1
		s_lshl_b32 s1, s0, 16
		v_add_u32_e32 v1, s1, v1
		v_add3_u32 v1, v1, v3, v4
		v_add_u32_e32 v1, 16, v1
		ds_read_b128 v[8:11], v1
		ds_read_b128 v[16:19], v1 offset:1024
		ds_read_b128 v[20:23], v1 offset:2048
		ds_read_b128 v[24:27], v1 offset:3072
		v_add_u32_e32 v2, s1, v3
		v_add3_u32 v2, v2, v7, v4
		v_add_u32_e32 v2, 16, v2
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
		v_add_u32_e32 v3, 16, v3
		ds_read_b32 v57, v3
		ds_read_b32 v58, v3 offset:256
		v_lshrrev_b32_e32 v0, 6, v0
		v_and_b32_e32 v0, 1, v0
		v_lshlrev_b32_e32 v0, 10, v0
		v_add3_u32 v0, s0, v56, v0
		v_add_u32_e32 v0, 16, v0
		ds_read_b32 v3, v0 offset:2048
		ds_read_b32 v56, v0 offset:2304
		ds_read_b32 v59, v0 offset:2560
		ds_read_b32 v60, v0 offset:2816
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[8:11], v[4:7], v[12:15], v57, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[64:67], v1 offset:16384
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[8:11], v[28:31], v[76:79], v57, v3 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[68:71], v1 offset:17408
		s_waitcnt lgkmcnt(4)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[8:11], v[32:35], v[80:83], v57, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[72:75], v1 offset:18432
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[8:11], v[36:39], v[84:87], v57, v56 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[92:95], v1 offset:19456
		s_waitcnt lgkmcnt(5)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[8:11], v[40:43], v[88:91], v57, v59 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[96:99], v2 offset:49152
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[8:11], v[44:47], v[100:103], v57, v59 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[104:107], v2 offset:50176
		s_waitcnt lgkmcnt(6)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[8:11], v[48:51], v[108:111], v57, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[212:215], v2 offset:51200
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[8:11], v[52:55], v[112:115], v57, v60 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[8:11], v2 offset:52224
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[16:19], v[4:7], v[116:119], v57, v3 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[216:219], v2 offset:53248
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[16:19], v[28:31], v[120:123], v57, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[220:223], v2 offset:54272
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[16:19], v[32:35], v[124:127], v57, v56 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[224:227], v2 offset:55296
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[16:19], v[36:39], v[128:131], v57, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		ds_read_b128 v[228:231], v2 offset:56320
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[16:19], v[40:43], v[132:135], v57, v59 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[16:19], v[44:47], v[136:139], v57, v59 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[16:19], v[48:51], v[140:143], v57, v60 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[16:19], v[52:55], v[144:147], v57, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[20:23], v[52:55], v[176:179], v58, v60 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[20:23], v[48:51], v[172:175], v58, v60 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[24:27], v[48:51], v[204:207], v58, v60 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[24:27], v[52:55], v[208:211], v58, v60 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[24:27], v[4:7], v[180:183], v58, v3 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[20:23], v[4:7], v[148:151], v58, v3 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[20:23], v[28:31], v[152:155], v58, v3 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[24:27], v[28:31], v[184:187], v58, v3 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[24:27], v[32:35], v[188:191], v58, v56 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[20:23], v[32:35], v[156:159], v58, v56 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[20:23], v[36:39], v[160:163], v58, v56 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[24:27], v[36:39], v[192:195], v58, v56 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[24:27], v[40:43], v[196:199], v58, v59 op_sel:[1,0,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[20:23], v[40:43], v[164:167], v58, v59 op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[20:23], v[44:47], v[168:171], v58, v59 op_sel:[0,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[24:27], v[44:47], v[200:203], v58, v59 op_sel:[1,1,0] op_sel_hi:[0,0,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(3)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[164:167], v[72:75], v[216:219], v[164:167], v58, v59 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(2)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[168:171], v[72:75], v[220:223], v[168:171], v58, v59 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[200:203], v[92:95], v[220:223], v[200:203], v58, v59 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[196:199], v[92:95], v[216:219], v[196:199], v58, v59 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[88:91], v[64:67], v[216:219], v[88:91], v57, v59 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[100:103], v[64:67], v[220:223], v[100:103], v57, v59 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[136:139], v[68:71], v[220:223], v[136:139], v57, v59 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[132:135], v[68:71], v[216:219], v[132:135], v57, v59 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[116:119], v[68:71], v[96:99], v[116:119], v57, v3 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[12:15], v[64:67], v[96:99], v[12:15], v57, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[76:79], v[64:67], v[104:107], v[76:79], v57, v3 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[120:123], v[68:71], v[104:107], v[120:123], v57, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[124:127], v[68:71], v[212:215], v[124:127], v57, v56 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[80:83], v[64:67], v[212:215], v[80:83], v57, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[84:87], v[64:67], v[8:11], v[84:87], v57, v56 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[128:131], v[68:71], v[8:11], v[128:131], v57, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(1)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[140:143], v[68:71], v[224:227], v[140:143], v57, v60 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[108:111], v[64:67], v[224:227], v[108:111], v57, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		s_waitcnt lgkmcnt(0)
		v_mfma_scale_f32_16x16x128_f8f6f4 v[112:115], v[64:67], v[228:231], v[112:115], v57, v60 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[144:147], v[68:71], v[228:231], v[144:147], v57, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[176:179], v[72:75], v[228:231], v[176:179], v58, v60 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[172:175], v[72:75], v[224:227], v[172:175], v58, v60 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[204:207], v[92:95], v[224:227], v[204:207], v58, v60 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[208:211], v[92:95], v[228:231], v[208:211], v58, v60 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[180:183], v[92:95], v[96:99], v[180:183], v58, v3 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[148:151], v[72:75], v[96:99], v[148:151], v58, v3 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[152:155], v[72:75], v[104:107], v[152:155], v58, v3 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[184:187], v[92:95], v[104:107], v[184:187], v58, v3 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[188:191], v[92:95], v[212:215], v[188:191], v58, v56 op_sel:[1,0,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[156:159], v[72:75], v[212:215], v[156:159], v58, v56 op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[160:163], v[72:75], v[8:11], v[160:163], v58, v56 op_sel:[0,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_mfma_scale_f32_16x16x128_f8f6f4 v[192:195], v[92:95], v[8:11], v[192:195], v58, v56 op_sel:[1,1,0] op_sel_hi:[1,1,0] cbsz:4 blgp:4
		v_cvt_pk_f16_f32 v0, v12, v13
		v_cvt_pk_f16_f32 v1, v14, v15
		s_mov_b32 s0, 0
		scratch_load_dword v2, off, s0 offset:4
		s_waitcnt vmcnt(0)
		v_lshlrev_b32_e32 v2, 3, v2
		s_mov_b32 s0, 0
		scratch_load_dword v3, off, s0
		s_waitcnt vmcnt(0)
		v_lshl_add_u32 v2, v3, 14, v2
		s_lshl_b32 s0, s13, 21
		s_lshl_b32 s1, s14, 17
		s_add_i32 s2, s0, s1
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s2 offen
		v_cvt_pk_f16_f32 v0, v76, v77
		v_cvt_pk_f16_f32 v1, v78, v79
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s2 offen offset:512
		v_cvt_pk_f16_f32 v0, v80, v81
		v_cvt_pk_f16_f32 v1, v82, v83
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s2 offen offset:1024
		v_cvt_pk_f16_f32 v0, v84, v85
		v_cvt_pk_f16_f32 v1, v86, v87
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s2 offen offset:1536
		v_cvt_pk_f16_f32 v0, v88, v89
		v_cvt_pk_f16_f32 v1, v90, v91
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s2 offen offset:2048
		v_cvt_pk_f16_f32 v0, v100, v101
		v_cvt_pk_f16_f32 v1, v102, v103
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s2 offen offset:2560
		v_cvt_pk_f16_f32 v0, v108, v109
		v_cvt_pk_f16_f32 v1, v110, v111
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s2 offen offset:3072
		v_cvt_pk_f16_f32 v0, v112, v113
		v_cvt_pk_f16_f32 v1, v114, v115
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s2 offen offset:3584
		v_cvt_pk_f16_f32 v0, v116, v117
		v_cvt_pk_f16_f32 v1, v118, v119
		s_add_i32 s2, s0, 0x1000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s2 offen
		v_cvt_pk_f16_f32 v0, v120, v121
		v_cvt_pk_f16_f32 v1, v122, v123
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s2 offen offset:512
		v_cvt_pk_f16_f32 v0, v124, v125
		v_cvt_pk_f16_f32 v1, v126, v127
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s2 offen offset:1024
		v_cvt_pk_f16_f32 v0, v128, v129
		v_cvt_pk_f16_f32 v1, v130, v131
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s2 offen offset:1536
		v_cvt_pk_f16_f32 v0, v132, v133
		v_cvt_pk_f16_f32 v1, v134, v135
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s2 offen offset:2048
		v_cvt_pk_f16_f32 v0, v136, v137
		v_cvt_pk_f16_f32 v1, v138, v139
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s2 offen offset:2560
		v_cvt_pk_f16_f32 v0, v140, v141
		v_cvt_pk_f16_f32 v1, v142, v143
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s2 offen offset:3072
		v_cvt_pk_f16_f32 v0, v144, v145
		v_cvt_pk_f16_f32 v1, v146, v147
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s2 offen offset:3584
		v_cvt_pk_f16_f32 v0, v148, v149
		v_cvt_pk_f16_f32 v1, v150, v151
		s_add_i32 s2, s0, 0x2000
		s_add_i32 s2, s2, s1
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s2 offen
		v_cvt_pk_f16_f32 v0, v152, v153
		v_cvt_pk_f16_f32 v1, v154, v155
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s2 offen offset:512
		v_cvt_pk_f16_f32 v0, v156, v157
		v_cvt_pk_f16_f32 v1, v158, v159
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s2 offen offset:1024
		v_cvt_pk_f16_f32 v0, v160, v161
		v_cvt_pk_f16_f32 v1, v162, v163
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s2 offen offset:1536
		v_cvt_pk_f16_f32 v0, v164, v165
		v_cvt_pk_f16_f32 v1, v166, v167
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s2 offen offset:2048
		v_cvt_pk_f16_f32 v0, v168, v169
		v_cvt_pk_f16_f32 v1, v170, v171
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s2 offen offset:2560
		v_cvt_pk_f16_f32 v0, v172, v173
		v_cvt_pk_f16_f32 v1, v174, v175
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s2 offen offset:3072
		v_cvt_pk_f16_f32 v0, v176, v177
		v_cvt_pk_f16_f32 v1, v178, v179
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s2 offen offset:3584
		v_cvt_pk_f16_f32 v0, v180, v181
		v_cvt_pk_f16_f32 v1, v182, v183
		s_add_i32 s0, s0, 0x3000
		s_add_i32 s0, s0, s1
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s0 offen
		v_cvt_pk_f16_f32 v0, v184, v185
		v_cvt_pk_f16_f32 v1, v186, v187
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s0 offen offset:512
		v_cvt_pk_f16_f32 v0, v188, v189
		v_cvt_pk_f16_f32 v1, v190, v191
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s0 offen offset:1024
		v_cvt_pk_f16_f32 v0, v192, v193
		v_cvt_pk_f16_f32 v1, v194, v195
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s0 offen offset:1536
		v_cvt_pk_f16_f32 v0, v196, v197
		v_cvt_pk_f16_f32 v1, v198, v199
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s0 offen offset:2048
		v_cvt_pk_f16_f32 v0, v200, v201
		v_cvt_pk_f16_f32 v1, v202, v203
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s0 offen offset:2560
		v_cvt_pk_f16_f32 v0, v204, v205
		v_cvt_pk_f16_f32 v1, v206, v207
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s0 offen offset:3072
		v_cvt_pk_f16_f32 v0, v208, v209
		v_cvt_pk_f16_f32 v1, v210, v211
		buffer_store_dwordx2 v[0:1], v2, s[20:23], s0 offen offset:3584
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 16
		.amdhsa_private_segment_fixed_size 548
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
		.amdhsa_next_free_sgpr 56
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
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 56
	.set .Lwmma_f16_matmul_tiled.num_named_barrier, 0
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 548
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
    .group_segment_fixed_size: 16
    .kernarg_segment_align: 8
    .kernarg_segment_size: 48
    .max_flat_workgroup_size: 512
    .name:           wmma_f16_matmul_tiled
    .private_segment_fixed_size: 548
    .sgpr_count:     56
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     256
    .agpr_count:     0
    .vgpr_spill_count: 137
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 86
    wave.regalloc.agpr.dwords: 0
    wave.regalloc.remat.dwords: 21
    wave.regalloc.sgpr_to_vgpr.dwords: 0
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 137
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
