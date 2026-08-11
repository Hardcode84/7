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
		s_load_dword s8, s[0:1], 0x18
		s_waitcnt lgkmcnt(0)
		s_branch .Lwmma_f16_matmul_tiled.kernarg_preload_entry
	.p2align	8
.Lwmma_f16_matmul_tiled.kernarg_preload_entry:
	; wave backend: WaveAMDMachine MLIR pipeline finalized
		v_mov_b32_e32 v1, 0
		s_mov_b32 s12, 1
		s_mov_b32 s13, 0
		s_and_saveexec_b64 s[14:15], s[12:13]
		ds_write_b32 v1, v1
		s_mov_b64 exec, s[14:15]
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mov_b32 s0, 0x4000000
		s_mov_b32 s19, 0x31016000
		s_mov_b32 s20, s2
		s_mov_b32 s21, s3
		s_mov_b32 s22, s0
		s_mov_b32 s23, s19
		s_mov_b32 s24, s4
		s_mov_b32 s25, s5
		s_mov_b32 s26, s0
		s_mov_b32 s27, s19
		s_mov_b32 s18, 0x2000000
		v_readfirstlane_b32 s0, v0
		s_lshr_b32 s0, s0, 6
		s_lshl_b32 s1, s0, 10
		s_add_i32 m0, s1, 16
		v_and_b32_e32 v2, 63, v0
		v_lshrrev_b32_e32 v3, 2, v2
		v_lshlrev_b32_e32 v3, 14, v3
		v_lshl_add_u32 v3, s0, 18, v3
		v_lshrrev_b32_e32 v4, 3, v2
		v_bitop3_b32 v4, v4, 3, v2 bitop3:0x48
		v_lshl_add_u32 v3, v4, 4, v3
		s_and_b32 s0, s9, 7
		s_lshr_b32 s0, s0, 1
		s_lshl_b32 s8, s0, 24
		s_lshl_b32 s11, s9, 5
		s_lshl_b32 s10, s10, 1
		s_add_i32 s10, s11, s10
		s_lshr_b32 s9, s9, 3
		s_add_i32 s9, s10, s9
		s_and_b32 s9, s9, 63
		s_and_b32 s10, s9, 3
		s_lshl_b32 s11, s10, 22
		s_add_i32 s14, s8, s11
		buffer_load_dwordx4 v3, s[20:23], s14 offen lds
		v_mov_b64_e32 v[4:5], 0
		v_mov_b64_e32 v[6:7], 0
		s_add_i32 m0, m0, 0x4000
		s_lshr_b32 s9, s9, 2
		s_lshl_b32 s15, s9, 22
		buffer_load_dwordx4 v3, s[24:27], s15 offen lds
		v_lshrrev_b32_e32 v8, 6, v0
		s_add_i32 m0, m0, 0x4000
		s_add_i32 s8, s8, 64
		s_add_i32 s8, s8, s11
		buffer_load_dwordx4 v3, s[20:23], s8 offen lds
		v_lshrrev_b32_e32 v9, 4, v2
		s_add_i32 m0, m0, 0x4000
		s_add_i32 s8, s15, 64
		buffer_load_dwordx4 v3, s[24:27], s8 offen lds
		v_and_b32_e32 v8, 3, v8
		s_add_i32 s8, s1, 0x10000
		s_mov_b32 s20, s2
		s_mov_b32 s21, s3
		s_mov_b32 s24, s4
		s_mov_b32 s25, s5
		s_mov_b32 s1, 0
		v_add_u32_e32 v10, s14, v3
		v_add_u32_e32 v3, s15, v3
		v_add_u32_e32 v11, 0x80, v10
		s_waitcnt vmcnt(2)
		s_barrier
		v_lshrrev_b32_e32 v10, 8, v0
		v_lshlrev_b32_e32 v12, 12, v10
		v_and_b32_e32 v0, 15, v0
		v_lshlrev_b32_e32 v13, 6, v0
		v_lshrrev_b32_e32 v0, 1, v0
		v_bitop3_b32 v0, v9, v0, 3 bitop3:0x78
		v_lshlrev_b32_e32 v0, 4, v0
		v_add3_u32 v14, v12, v13, v0
		v_add_u32_e32 v14, 16, v14
		ds_read_b128 v[16:19], v14
		ds_read_b128 v[20:23], v14 offset:1024
		ds_read_b128 v[24:27], v14 offset:2048
		ds_read_b128 v[28:31], v14 offset:3072
		v_lshlrev_b32_e32 v14, 12, v8
		v_add3_u32 v15, v13, v14, v0
		v_add_u32_e32 v15, 16, v15
		ds_read_b128 v[32:35], v15 offset:16384
		ds_read_b128 v[36:39], v15 offset:17408
		ds_read_b128 v[40:43], v15 offset:18432
		ds_read_b128 v[44:47], v15 offset:19456
		v_add_u32_e32 v15, 0x80, v3
		v_mov_b64_e32 v[48:49], 0
		v_mov_b64_e32 v[50:51], 0
		v_mov_b64_e32 v[52:53], 0
		v_mov_b64_e32 v[54:55], 0
		v_mov_b64_e32 v[56:57], 0
		v_mov_b64_e32 v[58:59], 0
		v_mov_b64_e32 v[60:61], 0
		v_mov_b64_e32 v[62:63], 0
		v_mov_b64_e32 v[64:65], 0
		v_mov_b64_e32 v[66:67], 0
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
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[4:7], v[16:19], v[32:35], v[4:7]
		s_add_i32 m0, s8, 16
		s_add_i32 s2, s8, 0x8000
		s_waitcnt lgkmcnt(0)
		buffer_load_dwordx4 v11, s[20:23], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[48:51], v[16:19], v[36:39], v[48:51]
		s_add_i32 m0, m0, 0x4000
		v_mfma_f32_16x16x32_f16 v[52:55], v[16:19], v[40:43], v[52:55]
		v_mfma_f32_16x16x32_f16 v[56:59], v[16:19], v[44:47], v[56:59]
		buffer_load_dwordx4 v15, s[24:27], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[72:75], v[20:23], v[44:47], v[72:75]
		v_mfma_f32_16x16x32_f16 v[60:63], v[20:23], v[32:35], v[60:63]
		v_mfma_f32_16x16x32_f16 v[64:67], v[20:23], v[36:39], v[64:67]
		v_mfma_f32_16x16x32_f16 v[68:71], v[20:23], v[40:43], v[68:71]
		v_mfma_f32_16x16x32_f16 v[84:87], v[24:27], v[40:43], v[84:87]
		v_mfma_f32_16x16x32_f16 v[100:103], v[28:31], v[40:43], v[100:103]
		v_mfma_f32_16x16x32_f16 v[76:79], v[24:27], v[32:35], v[76:79]
		v_mfma_f32_16x16x32_f16 v[92:95], v[28:31], v[32:35], v[92:95]
		v_mfma_f32_16x16x32_f16 v[80:83], v[24:27], v[36:39], v[80:83]
		v_mfma_f32_16x16x32_f16 v[88:91], v[24:27], v[44:47], v[88:91]
		v_mfma_f32_16x16x32_f16 v[104:107], v[28:31], v[44:47], v[104:107]
		v_mfma_f32_16x16x32_f16 v[96:99], v[28:31], v[36:39], v[96:99]
		s_add_i32 s1, s1, 1
		s_and_b32 s3, s1, 3
		s_lshl_b32 s3, s3, 15
		s_and_b32 s8, s2, 0x1ffff
		s_add_u32 s20, s20, 64
		s_addc_u32 s21, s21, 0
		s_add_u32 s24, s24, 64
		s_addc_u32 s25, s25, 0
		s_waitcnt vmcnt(2)
		s_barrier
		v_add_u32_e32 v3, s3, v12
		v_add3_u32 v3, v3, v13, v0
		v_add_u32_e32 v3, 16, v3
		ds_read_b128 v[16:19], v3
		ds_read_b128 v[20:23], v3 offset:1024
		ds_read_b128 v[24:27], v3 offset:2048
		ds_read_b128 v[28:31], v3 offset:3072
		v_add_u32_e32 v3, s3, v13
		v_add3_u32 v3, v3, v14, v0
		v_add_u32_e32 v3, 16, v3
		ds_read_b128 v[32:35], v3 offset:16384
		ds_read_b128 v[36:39], v3 offset:17408
		ds_read_b128 v[40:43], v3 offset:18432
		ds_read_b128 v[44:47], v3 offset:19456
		s_cmp_lt_i32 s1, 0xfe
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		v_mov_b32_e32 v3, 1
		s_and_saveexec_b64 s[2:3], s[12:13]
		s_waitcnt vmcnt(0)
		ds_add_rtn_u32 v11, v1, v3
		s_mov_b64 exec, s[2:3]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[4:7], v[16:19], v[32:35], v[4:7]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[48:51], v[16:19], v[36:39], v[48:51]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[52:55], v[16:19], v[40:43], v[52:55]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[56:59], v[16:19], v[44:47], v[56:59]
		v_mfma_f32_16x16x32_f16 v[72:75], v[20:23], v[44:47], v[72:75]
		v_mfma_f32_16x16x32_f16 v[60:63], v[20:23], v[32:35], v[60:63]
		v_mfma_f32_16x16x32_f16 v[64:67], v[20:23], v[36:39], v[64:67]
		v_mfma_f32_16x16x32_f16 v[68:71], v[20:23], v[40:43], v[68:71]
		v_mfma_f32_16x16x32_f16 v[84:87], v[24:27], v[40:43], v[84:87]
		v_mfma_f32_16x16x32_f16 v[100:103], v[28:31], v[40:43], v[100:103]
		v_mfma_f32_16x16x32_f16 v[76:79], v[24:27], v[32:35], v[76:79]
		v_mfma_f32_16x16x32_f16 v[92:95], v[28:31], v[32:35], v[92:95]
		v_mfma_f32_16x16x32_f16 v[80:83], v[24:27], v[36:39], v[80:83]
		v_mfma_f32_16x16x32_f16 v[88:91], v[24:27], v[44:47], v[88:91]
		v_mfma_f32_16x16x32_f16 v[104:107], v[28:31], v[44:47], v[104:107]
		v_mfma_f32_16x16x32_f16 v[96:99], v[28:31], v[36:39], v[96:99]
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v11
		s_and_b32 s1, s1, -16
		s_add_i32 s1, s1, 16
		s_and_saveexec_b64 s[2:3], s[12:13]
		ds_read_b32 v3, v1
		s_xor_b32 s1, s1, -1
		s_add_i32 s1, s1, 1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v3
		s_add_i32 s4, s4, s1
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc0 .Lwmma_f16_matmul_tiled.if_else_0
.Lwmma_f16_matmul_tiled.loop_head_1:
		s_sleep 1
		ds_read_b32 v3, v1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s4, v3
		s_add_i32 s4, s4, s1
		s_cmp_ge_u32 s4, 0x80000000
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_1
.Lwmma_f16_matmul_tiled.loop_exit_1:
		s_branch .Lwmma_f16_matmul_tiled.if_end_0
.Lwmma_f16_matmul_tiled.if_else_0:
.Lwmma_f16_matmul_tiled.if_end_0:
		s_mov_b64 exec, s[2:3]
		v_add_u32_e32 v1, 0x10000, v12
		v_add3_u32 v1, v1, v13, v0
		v_add_u32_e32 v1, 16, v1
		ds_read_b128 v[16:19], v1 offset:32768
		ds_read_b128 v[20:23], v1 offset:33792
		ds_read_b128 v[24:27], v1 offset:34816
		ds_read_b128 v[28:31], v1 offset:35840
		v_add_u32_e32 v1, 0x10000, v13
		v_add3_u32 v0, v1, v14, v0
		v_add_u32_e32 v0, 16, v0
		ds_read_b128 v[12:15], v0 offset:49152
		ds_read_b128 v[32:35], v0 offset:50176
		ds_read_b128 v[36:39], v0 offset:51200
		ds_read_b128 v[40:43], v0 offset:52224
		v_lshlrev_b32_e32 v0, 3, v9
		v_lshl_add_u32 v0, v10, 7, v0
		v_lshl_add_u32 v0, v8, 19, v0
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[4:7], v[16:19], v[12:15], v[4:7]
		v_and_b32_e32 v1, 15, v2
		v_lshl_add_u32 v0, v1, 13, v0
		s_lshl_b32 s1, s9, 21
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[48:51], v[16:19], v[32:35], v[48:51]
		s_lshl_b32 s0, s0, 11
		s_add_i32 s2, s1, s0
		s_lshl_b32 s3, s10, 9
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[52:55], v[16:19], v[36:39], v[52:55]
		v_cvt_pk_f16_f32 v2, v4, v5
		v_cvt_pk_f16_f32 v3, v6, v7
		s_add_i32 s2, s2, s3
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[56:59], v[16:19], v[40:43], v[56:59]
		v_cvt_pk_f16_f32 v4, v48, v49
		v_cvt_pk_f16_f32 v5, v50, v51
		v_mfma_f32_16x16x32_f16 v[72:75], v[20:23], v[40:43], v[72:75]
		v_mfma_f32_16x16x32_f16 v[60:63], v[20:23], v[12:15], v[60:63]
		v_cvt_pk_f16_f32 v6, v52, v53
		v_cvt_pk_f16_f32 v7, v54, v55
		v_mfma_f32_16x16x32_f16 v[64:67], v[20:23], v[32:35], v[64:67]
		v_mfma_f32_16x16x32_f16 v[68:71], v[20:23], v[36:39], v[68:71]
		v_cvt_pk_f16_f32 v8, v56, v57
		v_cvt_pk_f16_f32 v9, v58, v59
		v_mfma_f32_16x16x32_f16 v[84:87], v[24:27], v[36:39], v[84:87]
		v_mfma_f32_16x16x32_f16 v[100:103], v[28:31], v[36:39], v[100:103]
		v_cvt_pk_f16_f32 v10, v60, v61
		v_cvt_pk_f16_f32 v11, v62, v63
		v_cvt_pk_f16_f32 v16, v72, v73
		v_cvt_pk_f16_f32 v18, v64, v65
		v_cvt_pk_f16_f32 v19, v66, v67
		v_cvt_pk_f16_f32 v20, v68, v69
		v_cvt_pk_f16_f32 v21, v70, v71
		v_cvt_pk_f16_f32 v17, v74, v75
		v_cvt_pk_f16_f32 v22, v84, v85
		v_cvt_pk_f16_f32 v23, v86, v87
		v_cvt_pk_f16_f32 v36, v100, v101
		v_cvt_pk_f16_f32 v37, v102, v103
		v_mfma_f32_16x16x32_f16 v[76:79], v[24:27], v[12:15], v[76:79]
		v_mfma_f32_16x16x32_f16 v[92:95], v[28:31], v[12:15], v[92:95]
		v_mfma_f32_16x16x32_f16 v[80:83], v[24:27], v[32:35], v[80:83]
		v_mfma_f32_16x16x32_f16 v[88:91], v[24:27], v[40:43], v[88:91]
		v_mfma_f32_16x16x32_f16 v[104:107], v[28:31], v[40:43], v[104:107]
		v_mfma_f32_16x16x32_f16 v[96:99], v[28:31], v[32:35], v[96:99]
		s_mov_b32 s16, s6
		s_mov_b32 s17, s7
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen
		s_add_i32 s4, s1, 0x20000
		s_add_i32 s4, s4, s0
		v_cvt_pk_f16_f32 v2, v76, v77
		v_cvt_pk_f16_f32 v3, v78, v79
		v_cvt_pk_f16_f32 v12, v80, v81
		v_cvt_pk_f16_f32 v13, v82, v83
		v_cvt_pk_f16_f32 v14, v88, v89
		v_cvt_pk_f16_f32 v15, v90, v91
		v_cvt_pk_f16_f32 v24, v92, v93
		v_cvt_pk_f16_f32 v25, v94, v95
		v_cvt_pk_f16_f32 v26, v96, v97
		v_cvt_pk_f16_f32 v27, v98, v99
		v_cvt_pk_f16_f32 v28, v104, v105
		v_cvt_pk_f16_f32 v29, v106, v107
		s_add_i32 s4, s4, s3
		buffer_store_dwordx2 v[4:5], v0, s[16:19], s4 offen
		s_add_i32 s5, s1, 0x40000
		s_add_i32 s5, s5, s0
		s_add_i32 s5, s5, s3
		buffer_store_dwordx2 v[6:7], v0, s[16:19], s5 offen
		s_add_i32 s1, s1, 0x60000
		s_add_i32 s0, s1, s0
		s_add_i32 s0, s0, s3
		buffer_store_dwordx2 v[8:9], v0, s[16:19], s0 offen
		buffer_store_dwordx2 v[10:11], v0, s[16:19], s2 offen offset:32
		buffer_store_dwordx2 v[18:19], v0, s[16:19], s4 offen offset:32
		buffer_store_dwordx2 v[20:21], v0, s[16:19], s5 offen offset:32
		buffer_store_dwordx2 v[16:17], v0, s[16:19], s0 offen offset:32
		buffer_store_dwordx2 v[2:3], v0, s[16:19], s2 offen offset:64
		buffer_store_dwordx2 v[12:13], v0, s[16:19], s4 offen offset:64
		buffer_store_dwordx2 v[22:23], v0, s[16:19], s5 offen offset:64
		buffer_store_dwordx2 v[14:15], v0, s[16:19], s0 offen offset:64
		buffer_store_dwordx2 v[24:25], v0, s[16:19], s2 offen offset:96
		buffer_store_dwordx2 v[26:27], v0, s[16:19], s4 offen offset:96
		buffer_store_dwordx2 v[36:37], v0, s[16:19], s5 offen offset:96
		buffer_store_dwordx2 v[28:29], v0, s[16:19], s0 offen offset:96
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 16
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 32
		.amdhsa_user_sgpr_count 9
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_user_sgpr_kernarg_preload_length 7
		.amdhsa_user_sgpr_kernarg_preload_offset 0
		.amdhsa_enable_private_segment 0
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 1
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 108
		.amdhsa_next_free_sgpr 28
		.amdhsa_accum_offset 108
		.amdhsa_reserve_vcc 0
		.amdhsa_float_round_mode_32 0
		.amdhsa_float_round_mode_16_64 0
		.amdhsa_float_denorm_mode_32 3
		.amdhsa_float_denorm_mode_16_64 3
		.amdhsa_dx10_clamp 1
		.amdhsa_ieee_mode 1
		.amdhsa_fp16_overflow 0
	.end_amdhsa_kernel
	.text
	.set .Lwmma_f16_matmul_tiled.num_vgpr, 108
	.set .Lwmma_f16_matmul_tiled.num_agpr, 0
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 28
	.set .Lwmma_f16_matmul_tiled.num_named_barrier, 0
	.set .Lwmma_f16_matmul_tiled.private_seg_size, 0
	.set .Lwmma_f16_matmul_tiled.uses_vcc, 0
	.set .Lwmma_f16_matmul_tiled.uses_flat_scratch, 0
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
      - .name:           arg3
        .offset:         24
        .size:           4
        .value_kind:     by_value
    .group_segment_fixed_size: 16
    .kernarg_segment_align: 8
    .kernarg_segment_size: 32
    .max_flat_workgroup_size: 1024
    .name:           wmma_f16_matmul_tiled
    .private_segment_fixed_size: 0
    .sgpr_count:     28
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     108
    .agpr_count:     0
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 1
    wave.regalloc.agpr.dwords: 0
    wave.regalloc.remat.dwords: 0
    wave.regalloc.sgpr_to_vgpr.dwords: 0
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
