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
		s_mov_b32 s12, s2
		s_mov_b32 s13, s3
		s_mov_b32 s14, 0x4000000
		s_mov_b32 s15, 0x31016000
		v_readfirstlane_b32 s16, v0
		s_lshr_b32 s17, s9, 3
		v_lshrrev_b32_e32 v1, 6, v0
		s_lshl_b32 s18, s10, 1
		v_and_b32_e32 v2, 63, v0
		s_add_i32 s19, s18, s17
		v_lshrrev_b32_e32 v3, 2, v2
		s_and_b32 s17, s9, 7
		v_lshrrev_b32_e32 v4, 3, v2
		s_lshl_b32 s18, s17, 5
		v_and_b32_e32 v5, 3, v4
		s_add_i32 s17, s19, s18
		v_and_b32_e32 v4, 3, v2
		s_lshr_b32 s18, s17, 6
		v_xor_b32_e32 v6, v5, v4
		s_lshl_b32 s19, s18, 23
		v_lshlrev_b32_e32 v4, 18, v1
		s_and_b32 s20, s17, 63
		v_lshlrev_b32_e32 v5, 14, v3
		s_lshr_b32 s17, s20, 2
		v_lshlrev_b32_e32 v3, 4, v6
		s_lshl_b32 s21, s17, 17
		v_add_u32_e32 v6, v4, v5
		s_add_i32 s22, s19, s21
		s_mov_b32 s24, s4
		s_mov_b32 s25, s5
		s_mov_b32 s26, 0x4000000
		s_mov_b32 s27, 0x31016000
		s_and_b32 s19, s20, 3
		s_lshl_b32 s20, s19, 21
		s_add_i32 s21, s22, s20
		s_add_u32 s22, s6, s21
		s_addc_u32 s23, s7, 0
		s_lshr_b32 s20, s16, 6
		s_lshl_b32 s16, s20, 10
		s_mov_b32 m0, s16
		s_lshl_b32 s20, s18, 24
		v_add3_u32 v7, s20, v4, v5
		s_lshl_b32 s18, s19, 22
		v_add3_u32 v8, v7, s18, v3
		buffer_load_dwordx4 v8, s[12:15], 0 offen lds
		s_add_i32 s19, s16, 0x4000
		s_lshl_b32 s21, s17, 22
		v_add3_u32 v7, v6, s21, v3
		s_mov_b32 m0, s19
		s_nop 0
		buffer_load_dwordx4 v7, s[24:27], 0 offen lds
		s_add_i32 s17, s16, 0x8000
		s_mov_b32 m0, s17
		s_add_i32 s17, s20, 64
		v_add3_u32 v7, s17, v4, v5
		v_add3_u32 v8, v7, s18, v3
		buffer_load_dwordx4 v8, s[12:15], 0 offen lds
		v_add3_u32 v7, 64, v4, v5
		v_add3_u32 v4, v7, s21, v3
		s_add_i32 s17, s16, 0xc000
		s_mov_b32 m0, s17
		s_nop 0
		buffer_load_dwordx4 v4, s[24:27], 0 offen lds
		v_mov_b64_e32 v[8:9], 0
		v_mov_b64_e32 v[10:11], 0
		s_mov_b32 s28, s22
		s_mov_b32 s29, s23
		s_mov_b32 s30, 0x20000
		s_mov_b32 s31, 0x31016000
		s_waitcnt vmcnt(2)
		s_barrier
		v_and_b32_e32 v4, 15, v0
		v_lshrrev_b32_e32 v5, 1, v4
		v_lshrrev_b32_e32 v7, 4, v2
		v_and_b32_e32 v12, 3, v5
		v_xor_b32_e32 v5, v7, v12
		v_and_b32_e32 v7, 3, v1
		v_lshrrev_b32_e32 v12, 8, v0
		v_lshlrev_b32_e32 v13, 6, v4
		v_lshlrev_b32_e32 v4, 4, v5
		v_lshlrev_b32_e32 v5, 12, v12
		v_lshlrev_b32_e32 v12, 12, v7
		v_add3_u32 v7, v5, v13, v4
		v_add3_u32 v14, v13, v12, v4
		v_add_u32_e32 v15, v6, v3
		v_mov_b32_e32 v3, 0x80
		ds_read_b128 v[16:19], v7
		ds_read_b128 v[20:23], v7 offset:1024
		ds_read_b128 v[24:27], v7 offset:2048
		ds_read_b128 v[28:31], v7 offset:3072
		ds_read_b128 v[32:35], v14 offset:16384
		ds_read_b128 v[36:39], v14 offset:17408
		ds_read_b128 v[40:43], v14 offset:18432
		ds_read_b128 v[44:47], v14 offset:19456
		s_add_i32 s17, s20, s18
		v_add3_u32 v6, v15, s17, v3
		v_add3_u32 v48, v15, s21, v3
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
		v_mov_b64_e32 v[108:109], 0
		v_mov_b64_e32 v[110:111], 0
		s_mov_b32 s17, 0
		s_cmp_lt_i32 0, 0xfe
		s_cbranch_scc0 .Lwmma_f16_matmul_tiled.loop_exit_0
.Lwmma_f16_matmul_tiled.loop_head_0:
		s_waitcnt lgkmcnt(3)
		s_nop 0
		v_mfma_f32_16x16x32_f16 v[8:11], v[16:19], v[32:35], v[8:11]
		s_waitcnt lgkmcnt(2)
		s_nop 0
		v_mfma_f32_16x16x32_f16 v[52:55], v[16:19], v[36:39], v[52:55]
		s_waitcnt lgkmcnt(1)
		s_nop 0
		v_mfma_f32_16x16x32_f16 v[56:59], v[16:19], v[40:43], v[56:59]
		s_waitcnt lgkmcnt(0)
		s_lshl_b32 s18, s17, 6
		v_mfma_f32_16x16x32_f16 v[60:63], v[16:19], v[44:47], v[60:63]
		v_mfma_f32_16x16x32_f16 v[64:67], v[20:23], v[32:35], v[64:67]
		v_mfma_f32_16x16x32_f16 v[68:71], v[20:23], v[36:39], v[68:71]
		v_mfma_f32_16x16x32_f16 v[72:75], v[20:23], v[40:43], v[72:75]
		v_mfma_f32_16x16x32_f16 v[76:79], v[20:23], v[44:47], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], v[24:27], v[32:35], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], v[24:27], v[36:39], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], v[24:27], v[40:43], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[24:27], v[44:47], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[28:31], v[32:35], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[28:31], v[36:39], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[28:31], v[40:43], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[28:31], v[44:47], v[108:111]
		s_add_i32 s19, s17, 2
		s_add_i32 s17, s17, 1
		s_waitcnt vmcnt(0)
		s_barrier
		s_and_b32 s20, s19, 1
		s_lshl_b32 s19, s20, 15
		s_add_i32 s20, s16, s19
		s_mov_b32 m0, s20
		s_nop 0
		buffer_load_dwordx4 v6, s[12:15], s18 offen lds
		s_add_i32 s19, s20, 0x4000
		s_mov_b32 m0, s19
		s_nop 0
		buffer_load_dwordx4 v48, s[24:27], s18 offen lds
		s_and_b32 s18, s17, 1
		s_lshl_b32 s19, s18, 15
		v_add_u32_e32 v3, s19, v5
		v_add3_u32 v15, v3, v13, v4
		ds_read_b128 v[16:19], v15
		ds_read_b128 v[20:23], v15 offset:1024
		ds_read_b128 v[24:27], v15 offset:2048
		ds_read_b128 v[28:31], v15 offset:3072
		v_add_u32_e32 v3, s19, v13
		v_add3_u32 v15, v3, v12, v4
		ds_read_b128 v[32:35], v15 offset:16384
		ds_read_b128 v[36:39], v15 offset:17408
		ds_read_b128 v[40:43], v15 offset:18432
		ds_read_b128 v[44:47], v15 offset:19456
		s_cmp_lt_i32 s17, 0xfe
		s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_0
.Lwmma_f16_matmul_tiled.loop_exit_0:
		s_waitcnt lgkmcnt(3)
		s_nop 0
		v_mfma_f32_16x16x32_f16 v[8:11], v[16:19], v[32:35], v[8:11]
		s_waitcnt lgkmcnt(2)
		s_nop 0
		v_mfma_f32_16x16x32_f16 v[52:55], v[16:19], v[36:39], v[52:55]
		s_waitcnt lgkmcnt(1)
		s_nop 0
		v_mfma_f32_16x16x32_f16 v[56:59], v[16:19], v[40:43], v[56:59]
		s_waitcnt lgkmcnt(0)
		s_nop 0
		v_mfma_f32_16x16x32_f16 v[60:63], v[16:19], v[44:47], v[60:63]
		v_mfma_f32_16x16x32_f16 v[64:67], v[20:23], v[32:35], v[64:67]
		v_mfma_f32_16x16x32_f16 v[68:71], v[20:23], v[36:39], v[68:71]
		v_mfma_f32_16x16x32_f16 v[72:75], v[20:23], v[40:43], v[72:75]
		v_mfma_f32_16x16x32_f16 v[76:79], v[20:23], v[44:47], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], v[24:27], v[32:35], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], v[24:27], v[36:39], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], v[24:27], v[40:43], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[24:27], v[44:47], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[28:31], v[32:35], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[28:31], v[36:39], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[28:31], v[40:43], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[28:31], v[44:47], v[108:111]
		s_waitcnt vmcnt(0)
		s_barrier
		ds_read_b128 v[16:19], v7 offset:32768
		ds_read_b128 v[20:23], v7 offset:33792
		ds_read_b128 v[24:27], v7 offset:34816
		ds_read_b128 v[28:31], v7 offset:35840
		ds_read_b128 v[4:7], v14 offset:49152
		ds_read_b128 v[32:35], v14 offset:50176
		ds_read_b128 v[36:39], v14 offset:51200
		ds_read_b128 v[40:43], v14 offset:52224
		s_waitcnt lgkmcnt(3)
		s_nop 0
		v_mfma_f32_16x16x32_f16 v[8:11], v[16:19], v[4:7], v[8:11]
		v_lshlrev_b32_e32 v3, 3, v2
		s_waitcnt lgkmcnt(2)
		s_nop 0
		v_mfma_f32_16x16x32_f16 v[52:55], v[16:19], v[32:35], v[52:55]
		s_nop 4
		v_cvt_f16_f32_e64 v2, v9
		v_cvt_f16_f32_e64 v9, v11
		s_waitcnt lgkmcnt(1)
		s_nop 0
		v_mfma_f32_16x16x32_f16 v[56:59], v[16:19], v[36:39], v[56:59]
		v_cvt_f16_f32_e64 v11, v8
		v_cvt_f16_f32_e64 v8, v10
		s_waitcnt lgkmcnt(0)
		s_nop 0
		v_mfma_f32_16x16x32_f16 v[60:63], v[16:19], v[40:43], v[60:63]
		v_cvt_f16_f32_e64 v10, v53
		v_cvt_f16_f32_e64 v12, v55
		v_mfma_f32_16x16x32_f16 v[64:67], v[20:23], v[4:7], v[64:67]
		v_cvt_f16_f32_e64 v13, v52
		v_cvt_f16_f32_e64 v14, v54
		v_mfma_f32_16x16x32_f16 v[68:71], v[20:23], v[32:35], v[68:71]
		v_cvt_f16_f32_e64 v15, v57
		v_cvt_f16_f32_e64 v16, v59
		v_mfma_f32_16x16x32_f16 v[72:75], v[20:23], v[36:39], v[72:75]
		v_cvt_f16_f32_e64 v17, v56
		v_cvt_f16_f32_e64 v18, v58
		v_mfma_f32_16x16x32_f16 v[76:79], v[20:23], v[40:43], v[76:79]
		v_cvt_f16_f32_e64 v19, v61
		v_cvt_f16_f32_e64 v20, v63
		v_mfma_f32_16x16x32_f16 v[80:83], v[24:27], v[4:7], v[80:83]
		v_cvt_f16_f32_e64 v21, v60
		v_cvt_f16_f32_e64 v22, v62
		v_mfma_f32_16x16x32_f16 v[84:87], v[24:27], v[32:35], v[84:87]
		v_cvt_f16_f32_e64 v23, v65
		v_cvt_f16_f32_e64 v44, v67
		v_mfma_f32_16x16x32_f16 v[88:91], v[24:27], v[36:39], v[88:91]
		v_cvt_f16_f32_e64 v45, v64
		v_cvt_f16_f32_e64 v46, v66
		v_mfma_f32_16x16x32_f16 v[92:95], v[24:27], v[40:43], v[92:95]
		v_cvt_f16_f32_e64 v24, v69
		v_cvt_f16_f32_e64 v25, v71
		v_mfma_f32_16x16x32_f16 v[96:99], v[28:31], v[4:7], v[96:99]
		v_cvt_f16_f32_e64 v4, v68
		v_cvt_f16_f32_e64 v5, v70
		v_mfma_f32_16x16x32_f16 v[100:103], v[28:31], v[32:35], v[100:103]
		v_cvt_f16_f32_e64 v6, v73
		v_cvt_f16_f32_e64 v7, v75
		v_mfma_f32_16x16x32_f16 v[104:107], v[28:31], v[36:39], v[104:107]
		v_cvt_f16_f32_e64 v26, v72
		v_cvt_f16_f32_e64 v27, v74
		v_mfma_f32_16x16x32_f16 v[108:111], v[28:31], v[40:43], v[108:111]
		v_cvt_f16_f32_e64 v28, v77
		v_cvt_f16_f32_e64 v29, v79
		s_mov_b32 s12, 0x1000
		v_cvt_f16_f32_e64 v30, v81
		v_cvt_f16_f32_e64 v31, v83
		v_cvt_f16_f32_e64 v32, v85
		v_cvt_f16_f32_e64 v33, v87
		v_cvt_f16_f32_e64 v34, v89
		v_cvt_f16_f32_e64 v35, v91
		v_cvt_f16_f32_e64 v36, v93
		v_cvt_f16_f32_e64 v37, v95
		v_cvt_f16_f32_e64 v38, v97
		v_cvt_f16_f32_e64 v39, v99
		v_cvt_f16_f32_e64 v40, v101
		v_cvt_f16_f32_e64 v41, v103
		v_cvt_f16_f32_e64 v42, v105
		v_cvt_f16_f32_e64 v43, v107
		v_cvt_f16_f32_e64 v47, v109
		v_cvt_f16_f32_e64 v48, v111
		v_and_b32_e32 v49, 0xffff, v2
		v_and_b32_e32 v2, 0xffff, v9
		v_and_b32_e32 v9, 0xffff, v10
		v_and_b32_e32 v10, 0xffff, v12
		v_and_b32_e32 v12, 0xffff, v15
		v_and_b32_e32 v15, 0xffff, v16
		v_and_b32_e32 v16, 0xffff, v19
		v_and_b32_e32 v19, 0xffff, v20
		v_and_b32_e32 v20, 0xffff, v23
		v_and_b32_e32 v23, 0xffff, v44
		v_and_b32_e32 v44, 0xffff, v24
		v_and_b32_e32 v24, 0xffff, v25
		v_and_b32_e32 v25, 0xffff, v6
		v_and_b32_e32 v6, 0xffff, v7
		v_cvt_f16_f32_e64 v7, v76
		v_cvt_f16_f32_e64 v50, v78
		v_and_b32_e32 v51, 0xffff, v28
		v_and_b32_e32 v28, 0xffff, v29
		v_cvt_f16_f32_e64 v29, v80
		v_cvt_f16_f32_e64 v52, v82
		v_and_b32_e32 v53, 0xffff, v30
		v_and_b32_e32 v30, 0xffff, v31
		v_cvt_f16_f32_e64 v31, v84
		v_cvt_f16_f32_e64 v54, v86
		v_and_b32_e32 v55, 0xffff, v32
		v_and_b32_e32 v32, 0xffff, v33
		v_cvt_f16_f32_e64 v33, v88
		v_cvt_f16_f32_e64 v56, v90
		v_and_b32_e32 v57, 0xffff, v34
		v_and_b32_e32 v34, 0xffff, v35
		v_cvt_f16_f32_e64 v35, v92
		v_cvt_f16_f32_e64 v58, v94
		v_and_b32_e32 v59, 0xffff, v36
		v_and_b32_e32 v36, 0xffff, v37
		v_cvt_f16_f32_e64 v37, v96
		v_cvt_f16_f32_e64 v60, v98
		v_and_b32_e32 v61, 0xffff, v38
		v_and_b32_e32 v38, 0xffff, v39
		v_cvt_f16_f32_e64 v39, v100
		v_cvt_f16_f32_e64 v62, v102
		v_and_b32_e32 v63, 0xffff, v40
		v_and_b32_e32 v40, 0xffff, v41
		v_cvt_f16_f32_e64 v41, v104
		v_cvt_f16_f32_e64 v64, v106
		v_and_b32_e32 v65, 0xffff, v42
		v_and_b32_e32 v42, 0xffff, v43
		v_cvt_f16_f32_e64 v43, v108
		v_cvt_f16_f32_e64 v66, v110
		v_and_b32_e32 v67, 0xffff, v47
		v_and_b32_e32 v47, 0xffff, v48
		v_and_b32_e32 v48, 0xffff, v11
		v_lshlrev_b32_e32 v11, 16, v49
		v_and_b32_e32 v49, 0xffff, v8
		v_lshlrev_b32_e32 v8, 16, v2
		v_and_b32_e32 v2, 0xffff, v13
		v_lshlrev_b32_e32 v13, 16, v9
		v_and_b32_e32 v9, 0xffff, v14
		v_lshlrev_b32_e32 v14, 16, v10
		v_and_b32_e32 v10, 0xffff, v17
		v_lshlrev_b32_e32 v17, 16, v12
		v_and_b32_e32 v12, 0xffff, v18
		v_lshlrev_b32_e32 v18, 16, v15
		v_and_b32_e32 v15, 0xffff, v21
		v_lshlrev_b32_e32 v21, 16, v16
		v_and_b32_e32 v16, 0xffff, v22
		v_lshlrev_b32_e32 v22, 16, v19
		v_and_b32_e32 v19, 0xffff, v45
		v_lshlrev_b32_e32 v45, 16, v20
		v_and_b32_e32 v20, 0xffff, v46
		v_lshlrev_b32_e32 v46, 16, v23
		v_and_b32_e32 v23, 0xffff, v4
		v_lshlrev_b32_e32 v4, 16, v44
		v_and_b32_e32 v44, 0xffff, v5
		v_lshlrev_b32_e32 v5, 16, v24
		v_and_b32_e32 v24, 0xffff, v26
		v_lshlrev_b32_e32 v26, 16, v25
		v_and_b32_e32 v25, 0xffff, v27
		v_lshlrev_b32_e32 v27, 16, v6
		v_and_b32_e32 v6, 0xffff, v7
		v_lshlrev_b32_e32 v7, 16, v51
		v_and_b32_e32 v51, 0xffff, v50
		v_lshlrev_b32_e32 v50, 16, v28
		v_and_b32_e32 v28, 0xffff, v29
		v_lshlrev_b32_e32 v29, 16, v53
		v_and_b32_e32 v53, 0xffff, v52
		v_lshlrev_b32_e32 v52, 16, v30
		v_and_b32_e32 v30, 0xffff, v31
		v_lshlrev_b32_e32 v31, 16, v55
		v_and_b32_e32 v55, 0xffff, v54
		v_lshlrev_b32_e32 v54, 16, v32
		v_and_b32_e32 v32, 0xffff, v33
		v_lshlrev_b32_e32 v33, 16, v57
		v_and_b32_e32 v57, 0xffff, v56
		v_lshlrev_b32_e32 v56, 16, v34
		v_and_b32_e32 v34, 0xffff, v35
		v_lshlrev_b32_e32 v35, 16, v59
		v_and_b32_e32 v59, 0xffff, v58
		v_lshlrev_b32_e32 v58, 16, v36
		v_and_b32_e32 v36, 0xffff, v37
		v_lshlrev_b32_e32 v37, 16, v61
		v_and_b32_e32 v61, 0xffff, v60
		v_lshlrev_b32_e32 v60, 16, v38
		v_and_b32_e32 v38, 0xffff, v39
		v_lshlrev_b32_e32 v39, 16, v63
		v_and_b32_e32 v63, 0xffff, v62
		v_lshlrev_b32_e32 v62, 16, v40
		v_and_b32_e32 v40, 0xffff, v41
		v_lshlrev_b32_e32 v41, 16, v65
		v_and_b32_e32 v65, 0xffff, v64
		v_lshlrev_b32_e32 v64, 16, v42
		v_and_b32_e32 v42, 0xffff, v43
		v_lshlrev_b32_e32 v43, 16, v67
		v_and_b32_e32 v67, 0xffff, v66
		v_lshlrev_b32_e32 v66, 16, v47
		v_or_b32_e32 v68, v48, v11
		v_or_b32_e32 v69, v49, v8
		v_lshl_add_u32 v8, v1, 13, v3
		buffer_store_dwordx2 v[68:69], v8, s[28:31], 0 offen
		v_or_b32_e32 v48, v2, v13
		v_or_b32_e32 v49, v9, v14
		buffer_store_dwordx2 v[48:49], v8, s[28:31], 0 offen offset:512
		v_or_b32_e32 v2, v10, v17
		v_or_b32_e32 v3, v12, v18
		buffer_store_dwordx2 v[2:3], v8, s[28:31], 0 offen offset:1024
		v_or_b32_e32 v2, v15, v21
		v_or_b32_e32 v3, v16, v22
		buffer_store_dwordx2 v[2:3], v8, s[28:31], 0 offen offset:1536
		v_or_b32_e32 v2, v19, v45
		v_or_b32_e32 v3, v20, v46
		buffer_store_dwordx2 v[2:3], v8, s[28:31], 0 offen offset:2048
		v_or_b32_e32 v2, v23, v4
		v_or_b32_e32 v3, v44, v5
		buffer_store_dwordx2 v[2:3], v8, s[28:31], 0 offen offset:2560
		v_or_b32_e32 v2, v24, v26
		v_or_b32_e32 v3, v25, v27
		buffer_store_dwordx2 v[2:3], v8, s[28:31], 0 offen offset:3072
		v_or_b32_e32 v2, v6, v7
		v_or_b32_e32 v3, v51, v50
		buffer_store_dwordx2 v[2:3], v8, s[28:31], 0 offen offset:3584
		v_or_b32_e32 v2, v28, v29
		v_or_b32_e32 v3, v53, v52
		buffer_store_dwordx2 v[2:3], v8, s[28:31], s12 offen
		v_or_b32_e32 v2, v30, v31
		v_or_b32_e32 v3, v55, v54
		buffer_store_dwordx2 v[2:3], v8, s[28:31], s12 offen offset:512
		v_or_b32_e32 v2, v32, v33
		v_or_b32_e32 v3, v57, v56
		buffer_store_dwordx2 v[2:3], v8, s[28:31], s12 offen offset:1024
		v_or_b32_e32 v2, v34, v35
		v_or_b32_e32 v3, v59, v58
		buffer_store_dwordx2 v[2:3], v8, s[28:31], s12 offen offset:1536
		v_or_b32_e32 v2, v36, v37
		v_or_b32_e32 v3, v61, v60
		buffer_store_dwordx2 v[2:3], v8, s[28:31], s12 offen offset:2048
		v_or_b32_e32 v2, v38, v39
		v_or_b32_e32 v3, v63, v62
		buffer_store_dwordx2 v[2:3], v8, s[28:31], s12 offen offset:2560
		v_or_b32_e32 v2, v40, v41
		v_or_b32_e32 v3, v65, v64
		buffer_store_dwordx2 v[2:3], v8, s[28:31], s12 offen offset:3072
		v_or_b32_e32 v2, v42, v43
		v_or_b32_e32 v3, v67, v66
		buffer_store_dwordx2 v[2:3], v8, s[28:31], s12 offen offset:3584
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	wmma_f16_matmul_tiled, .-wmma_f16_matmul_tiled
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel wmma_f16_matmul_tiled
		.amdhsa_group_segment_fixed_size 0
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
		.amdhsa_next_free_vgpr 112
		.amdhsa_next_free_sgpr 32
		.amdhsa_accum_offset 112
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
	.set .Lwmma_f16_matmul_tiled.num_vgpr, 112
	.set .Lwmma_f16_matmul_tiled.num_agpr, 0
	.set .Lwmma_f16_matmul_tiled.numbered_sgpr, 32
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
    .group_segment_fixed_size: 0
    .kernarg_segment_align: 8
    .kernarg_segment_size: 32
    .max_flat_workgroup_size: 1024
    .name:           wmma_f16_matmul_tiled
    .private_segment_fixed_size: 0
    .sgpr_count:     32
    .sgpr_spill_count: 0
    .symbol:         wmma_f16_matmul_tiled.kd
    .uses_dynamic_stack: false
    .vgpr_count:     112
    .agpr_count:     0
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
