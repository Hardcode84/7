	.text
	.amdgcn_target "amdgcn-amd-amdhsa--gfx950"
	.amdhsa_code_object_version 6

	.globl	flash_attention_bf16_gfx950
	.p2align	8
	.type	flash_attention_bf16_gfx950,@function
flash_attention_bf16_gfx950:
		s_load_dwordx2 s[2:3], s[0:1], 0x0
		s_load_dwordx2 s[4:5], s[0:1], 0x8
		s_load_dwordx2 s[6:7], s[0:1], 0x10
		s_load_dwordx2 s[8:9], s[0:1], 0x18
		s_waitcnt lgkmcnt(0)
		s_branch .Lflash_attention_bf16_gfx950.kernarg_preload_entry
	.p2align	8
.Lflash_attention_bf16_gfx950.kernarg_preload_entry:
	; wave backend: WaveAMDMachine MLIR pipeline finalized
		v_readfirstlane_b32 s0, v0
		s_lshr_b32 s1, s11, 3
		s_and_b32 s12, s10, 7
		s_lshl_b32 s12, s12, 4
		s_add_i32 s1, s1, s12
		s_lshl_b32 s1, s1, 21
		s_add_u32 s12, s2, s1
		s_addc_u32 s13, s3, 0
		s_mov_b32 s18, 0x200000
		s_mov_b32 s19, 0x31016000
		s_add_u32 s16, s4, s1
		s_addc_u32 s17, s5, 0
		s_add_u32 s20, s6, s1
		s_addc_u32 s21, s7, 0
		s_mov_b32 s20, s20
		s_mov_b32 s21, s21
		s_mov_b32 s22, s18
		s_mov_b32 s23, s19
		v_lshrrev_b32_e32 v1, 6, v0
		v_and_b32_e32 v0, 63, v0
		v_lshrrev_b32_e32 v2, 5, v0
		v_lshlrev_b32_e32 v3, 4, v2
		v_lshl_add_u32 v1, v1, 13, v3
		v_and_b32_e32 v4, 31, v0
		v_lshl_add_u32 v1, v4, 8, v1
		s_lshl_b32 s2, s11, 2
		s_lshr_b32 s3, s10, 3
		s_add_i32 s2, s2, s3
		s_and_b32 s2, s2, 31
		s_lshl_b32 s2, s2, 16
		s_mov_b32 s14, s18
		s_mov_b32 s15, s19
		buffer_load_dwordx4 v[8:11], v1, s[12:15], s2 offen
		buffer_load_dwordx4 v[12:15], v1, s[12:15], s2 offen offset:32
		buffer_load_dwordx4 v[16:19], v1, s[12:15], s2 offen offset:64
		buffer_load_dwordx4 v[20:23], v1, s[12:15], s2 offen offset:96
		buffer_load_dwordx4 v[24:27], v1, s[12:15], s2 offen offset:128
		buffer_load_dwordx4 v[28:31], v1, s[12:15], s2 offen offset:160
		buffer_load_dwordx4 v[32:35], v1, s[12:15], s2 offen offset:192
		buffer_load_dwordx4 v[36:39], v1, s[12:15], s2 offen offset:224
		s_lshr_b32 s3, s0, 6
		s_mul_i32 s4, 0x410, s3
		s_mov_b32 m0, s4
		v_lshrrev_b32_e32 v5, 3, v0
		v_lshlrev_b32_e32 v5, 11, v5
		v_lshl_add_u32 v5, s3, 8, v5
		v_and_b32_e32 v6, 7, v0
		v_lshl_add_u32 v5, v6, 4, v5
		buffer_load_dwordx4 v5, s[16:19], 0 offen lds
		s_mov_b32 s6, -1
		s_mov_b32 s7, -1
		s_add_i32 m0, m0, 0x2080
		s_mov_b32 s5, 0x80
		buffer_load_dwordx4 v5, s[16:19], s5 offen lds
		v_and_b32_e32 v6, 3, v0
		s_add_i32 m0, m0, 0x2080
		s_mov_b32 s10, 0x4000
		buffer_load_dwordx4 v5, s[16:19], s10 offen lds
		v_lshrrev_b32_e32 v7, 4, v0
		s_add_i32 m0, m0, 0x2080
		s_mov_b32 s11, 0x4080
		buffer_load_dwordx4 v5, s[16:19], s11 offen lds
		s_mul_i32 s3, 0x440, s3
		s_add_i32 m0, s3, 0x8200
		s_add_u32 s12, s8, s1
		s_addc_u32 s13, s9, 0
		buffer_load_dwordx4 v5, s[20:23], 0 offen lds
		v_and_b32_e32 v40, 7, v4
		s_add_i32 m0, m0, 0x2200
		v_mov_b32_e32 v41, 0
		buffer_load_dwordx4 v5, s[20:23], s5 offen lds
		v_lshrrev_b32_e32 v4, 3, v4
		s_waitcnt vmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v4, 7, v4
		v_mov_b32_e32 v42, 0x410
		v_mul_lo_u32 v42, v42, v40
		v_add3_u32 v3, v3, v4, v42
		ds_read_b128 v[44:47], v3
		ds_read_b128 v[48:51], v3 offset:512
		ds_read_b128 v[52:55], v3 offset:32
		ds_read_b128 v[56:59], v3 offset:544
		ds_read_b128 v[60:63], v3 offset:64
		ds_read_b128 v[64:67], v3 offset:576
		ds_read_b128 v[68:71], v3 offset:96
		ds_read_b128 v[72:75], v3 offset:608
		ds_read_b128 v[76:79], v3 offset:8320
		ds_read_b128 v[80:83], v3 offset:8832
		ds_read_b128 v[84:87], v3 offset:8352
		ds_read_b128 v[88:91], v3 offset:8864
		ds_read_b128 v[92:95], v3 offset:8384
		ds_read_b128 v[96:99], v3 offset:8896
		ds_read_b128 v[100:103], v3 offset:8416
		ds_read_b128 v[104:107], v3 offset:8928
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[112:127], v[44:47], v[8:11], 0
		v_mfma_f32_32x32x16_bf16 v[128:143], v[48:51], v[8:11], 0
		v_mfma_f32_32x32x16_bf16 v[112:127], v[52:55], v[12:15], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], v[56:59], v[12:15], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[112:127], v[60:63], v[16:19], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], v[64:67], v[16:19], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[112:127], v[68:71], v[20:23], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], v[72:75], v[20:23], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[112:127], v[76:79], v[24:27], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], v[80:83], v[24:27], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[112:127], v[84:87], v[28:31], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], v[88:91], v[28:31], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[112:127], v[92:95], v[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], v[96:99], v[32:35], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[112:127], v[100:103], v[36:39], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], v[104:107], v[36:39], v[128:143]
		s_barrier
		s_mov_b32 m0, s4
		s_mov_b32 s1, 0x8000
		buffer_load_dwordx4 v5, s[16:19], s1 offen lds
		v_mov_b32_e32 v42, 0x3e0293ee
		v_mov_b32_e32 v43, 0x3e0293ee
		s_add_i32 m0, m0, 0x2080
		s_mov_b32 s1, 0x8080
		buffer_load_dwordx4 v5, s[16:19], s1 offen lds
		s_nop 1
		v_max3_f32 v4, v112, v113, v114
		v_max3_f32 v4, v4, v115, v116
		v_max3_f32 v4, v4, v117, v118
		v_max3_f32 v4, v4, v119, v120
		v_max3_f32 v4, v4, v121, v122
		v_max3_f32 v4, v4, v123, v124
		v_max3_f32 v4, v4, v125, v126
		v_max3_f32 v4, v4, v127, v128
		v_max3_f32 v4, v4, v129, v130
		v_max3_f32 v4, v4, v131, v132
		v_max3_f32 v4, v4, v133, v134
		v_max3_f32 v4, v4, v135, v136
		v_max3_f32 v4, v4, v137, v138
		v_max3_f32 v4, v4, v139, v140
		v_max3_f32 v4, v4, v141, v142
		v_max_f32_e32 v4, v4, v143
		v_mov_b32_e32 v44, v4
		v_mov_b32_e32 v45, v4
		s_nop 1
		v_permlane32_swap_b32_e32 v44, v45
		v_max_f32_e32 v4, v44, v45
		v_mul_f32_e32 v4, v4, v42
		v_sub_f32_e32 v44, v41, v4
		v_mov_b32_e32 v45, v44
		v_pk_fma_f32 v[46:47], v[114:115], v[42:43], v[44:45]
		v_pk_fma_f32 v[48:49], v[116:117], v[42:43], v[44:45]
		v_pk_fma_f32 v[50:51], v[118:119], v[42:43], v[44:45]
		v_pk_fma_f32 v[52:53], v[120:121], v[42:43], v[44:45]
		v_pk_fma_f32 v[54:55], v[122:123], v[42:43], v[44:45]
		v_pk_fma_f32 v[56:57], v[124:125], v[42:43], v[44:45]
		v_pk_fma_f32 v[58:59], v[126:127], v[42:43], v[44:45]
		v_exp_f32_e32 v60, v48
		v_exp_f32_e32 v61, v49
		v_exp_f32_e32 v48, v50
		v_exp_f32_e32 v49, v51
		v_exp_f32_e32 v50, v52
		v_exp_f32_e32 v51, v53
		v_exp_f32_e32 v52, v54
		v_exp_f32_e32 v53, v55
		v_exp_f32_e32 v54, v56
		v_exp_f32_e32 v55, v57
		v_exp_f32_e32 v56, v58
		v_exp_f32_e32 v57, v59
		v_pk_fma_f32 v[58:59], v[128:129], v[42:43], v[44:45]
		v_pk_fma_f32 v[62:63], v[130:131], v[42:43], v[44:45]
		v_pk_fma_f32 v[64:65], v[132:133], v[42:43], v[44:45]
		v_pk_fma_f32 v[66:67], v[134:135], v[42:43], v[44:45]
		v_pk_fma_f32 v[68:69], v[136:137], v[42:43], v[44:45]
		v_pk_fma_f32 v[70:71], v[138:139], v[42:43], v[44:45]
		v_pk_fma_f32 v[72:73], v[140:141], v[42:43], v[44:45]
		v_pk_fma_f32 v[74:75], v[142:143], v[42:43], v[44:45]
		s_cmp_ge_u32 s0, 0x100
		s_cbranch_scc0 .Lflash_attention_bf16_gfx950.if_end_0
		s_barrier
		s_setprio 3
.Lflash_attention_bf16_gfx950.if_end_0:
		s_barrier
		s_add_i32 m0, s3, 0xc600
		v_pk_fma_f32 v[76:77], v[112:113], v[42:43], v[44:45]
		buffer_load_dwordx4 v5, s[20:23], s10 offen lds
		v_exp_f32_e32 v44, v76
		v_exp_f32_e32 v45, v77
		s_add_i32 m0, m0, 0x2200
		v_exp_f32_e32 v77, v47
		buffer_load_dwordx4 v5, s[20:23], s11 offen lds
		v_exp_f32_e32 v76, v46
		s_barrier
		ds_read_b128 v[80:83], v3 offset:16640
		ds_read_b128 v[84:87], v3 offset:17152
		ds_read_b128 v[88:91], v3 offset:16672
		ds_read_b128 v[92:95], v3 offset:17184
		ds_read_b128 v[96:99], v3 offset:16704
		ds_read_b128 v[100:103], v3 offset:17216
		ds_read_b128 v[104:107], v3 offset:16736
		ds_read_b128 v[108:111], v3 offset:17248
		ds_read_b128 v[112:115], v3 offset:24960
		ds_read_b128 v[116:119], v3 offset:25472
		ds_read_b128 v[120:123], v3 offset:24992
		ds_read_b128 v[124:127], v3 offset:25504
		ds_read_b128 v[128:131], v3 offset:25024
		ds_read_b128 v[132:135], v3 offset:25536
		ds_read_b128 v[136:139], v3 offset:25056
		ds_read_b128 v[140:143], v3 offset:25568
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[144:159], v[80:83], v[8:11], 0
		v_pk_add_f32 v[46:47], v[44:45], v[76:77]
		v_pk_add_f32 v[78:79], v[60:61], v[48:49]
		v_pk_add_f32 v[80:81], v[50:51], v[52:53]
		v_pk_add_f32 v[82:83], v[54:55], v[56:57]
		v_pk_add_f32 v[46:47], v[46:47], v[78:79]
		v_pk_add_f32 v[78:79], v[80:81], v[82:83]
		v_pk_add_f32 v[46:47], v[46:47], v[78:79]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[84:87], v[8:11], 0
		v_cvt_pk_bf16_f32 v80, v44, v45
		v_cvt_pk_bf16_f32 v81, v76, v77
		v_cvt_pk_bf16_f32 v82, v60, v61
		v_cvt_pk_bf16_f32 v83, v48, v49
		v_cvt_pk_bf16_f32 v76, v50, v51
		v_cvt_pk_bf16_f32 v77, v52, v53
		v_cvt_pk_bf16_f32 v78, v54, v55
		s_waitcnt lgkmcnt(13)
		v_mfma_f32_32x32x16_bf16 v[144:159], v[88:91], v[12:15], v[144:159]
		v_cvt_pk_bf16_f32 v79, v56, v57
		v_exp_f32_e32 v44, v58
		v_exp_f32_e32 v48, v62
		v_exp_f32_e32 v50, v64
		v_exp_f32_e32 v52, v66
		v_exp_f32_e32 v54, v68
		v_exp_f32_e32 v56, v70
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_32x32x16_bf16 v[160:175], v[92:95], v[12:15], v[160:175]
		v_exp_f32_e32 v60, v72
		v_exp_f32_e32 v84, v74
		v_exp_f32_e32 v45, v59
		v_exp_f32_e32 v49, v63
		v_cvt_pk_bf16_f32 v88, v44, v45
		v_pk_add_f32 v[44:45], v[44:45], v[48:49]
		v_cvt_pk_bf16_f32 v89, v48, v49
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_32x32x16_bf16 v[144:159], v[96:99], v[16:19], v[144:159]
		v_exp_f32_e32 v51, v65
		v_exp_f32_e32 v53, v67
		v_cvt_pk_bf16_f32 v90, v50, v51
		v_pk_add_f32 v[48:49], v[50:51], v[52:53]
		v_pk_add_f32 v[44:45], v[44:45], v[48:49]
		v_cvt_pk_bf16_f32 v91, v52, v53
		v_exp_f32_e32 v55, v69
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_32x32x16_bf16 v[160:175], v[100:103], v[16:19], v[160:175]
		v_cvt_pk_bf16_f32 v48, v54, v55
		v_exp_f32_e32 v57, v71
		v_exp_f32_e32 v61, v73
		v_pk_add_f32 v[52:53], v[54:55], v[56:57]
		v_cvt_pk_bf16_f32 v49, v56, v57
		v_cvt_pk_bf16_f32 v50, v60, v61
		v_exp_f32_e32 v85, v75
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_32x32x16_bf16 v[144:159], v[104:107], v[20:23], v[144:159]
		v_pk_add_f32 v[54:55], v[60:61], v[84:85]
		v_pk_add_f32 v[52:53], v[52:53], v[54:55]
		v_pk_add_f32 v[44:45], v[44:45], v[52:53]
		v_pk_add_f32 v[52:53], v[46:47], v[44:45]
		v_add_f32_e32 v40, v52, v53
		v_cvt_pk_bf16_f32 v51, v84, v85
		v_mov_b32_e32 v44, v40
		v_mov_b32_e32 v45, v40
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_32x32x16_bf16 v[160:175], v[108:111], v[20:23], v[160:175]
		s_nop 0
		v_permlane32_swap_b32_e32 v44, v45
		v_add_f32_e32 v40, v44, v45
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_32x32x16_bf16 v[144:159], v[112:115], v[24:27], v[144:159]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_32x32x16_bf16 v[160:175], v[116:119], v[24:27], v[160:175]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_32x32x16_bf16 v[144:159], v[120:123], v[28:31], v[144:159]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_32x32x16_bf16 v[160:175], v[124:127], v[28:31], v[160:175]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_32x32x16_bf16 v[144:159], v[128:131], v[32:35], v[144:159]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_32x32x16_bf16 v[160:175], v[132:135], v[32:35], v[160:175]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_32x32x16_bf16 v[144:159], v[136:139], v[36:39], v[144:159]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_32x32x16_bf16 v[160:175], v[140:143], v[36:39], v[160:175]
		s_barrier
		s_add_i32 m0, s4, 0x4100
		s_mov_b32 s1, 0xc000
		buffer_load_dwordx4 v5, s[16:19], s1 offen lds
		v_add_f32_e32 v40, v41, v40
		s_add_i32 m0, m0, 0x2080
		s_mov_b32 s1, 0xc080
		buffer_load_dwordx4 v5, s[16:19], s1 offen lds
		s_barrier
		v_mov_b32_e32 v44, 0x1100
		v_mul_lo_u32 v44, v44, v2
		v_and_b32_e32 v0, 15, v0
		v_lshrrev_b32_e32 v0, 2, v0
		v_mov_b32_e32 v2, 0x440
		v_mul_lo_u32 v2, v2, v0
		v_add_u32_e32 v0, v44, v2
		v_and_b32_e32 v2, 1, v7
		v_lshl_add_u32 v0, v2, 5, v0
		v_lshl_add_u32 v0, v6, 3, v0
		ds_read_b64_tr_b16 v[44:45], v0 offset:33280
		ds_read_b64_tr_b16 v[46:47], v0 offset:33408
		ds_read_b64_tr_b16 v[52:53], v0 offset:33344
		ds_read_b64_tr_b16 v[54:55], v0 offset:33472
		ds_read_b64_tr_b16 v[56:57], v0 offset:41984
		ds_read_b64_tr_b16 v[58:59], v0 offset:42112
		ds_read_b64_tr_b16 v[60:61], v0 offset:42048
		ds_read_b64_tr_b16 v[62:63], v0 offset:42176
		ds_read_b64_tr_b16 v[64:65], v0 offset:33536
		ds_read_b64_tr_b16 v[66:67], v0 offset:33664
		ds_read_b64_tr_b16 v[68:69], v0 offset:33600
		ds_read_b64_tr_b16 v[70:71], v0 offset:33728
		ds_read_b64_tr_b16 v[72:73], v0 offset:42240
		ds_read_b64_tr_b16 v[74:75], v0 offset:42368
		ds_read_b64_tr_b16 v[84:85], v0 offset:42304
		ds_read_b64_tr_b16 v[86:87], v0 offset:42432
		ds_read_b64_tr_b16 v[92:93], v0 offset:33792
		ds_read_b64_tr_b16 v[94:95], v0 offset:33920
		ds_read_b64_tr_b16 v[96:97], v0 offset:33856
		ds_read_b64_tr_b16 v[98:99], v0 offset:33984
		ds_read_b64_tr_b16 v[100:101], v0 offset:42496
		ds_read_b64_tr_b16 v[102:103], v0 offset:42624
		ds_read_b64_tr_b16 v[104:105], v0 offset:42560
		ds_read_b64_tr_b16 v[106:107], v0 offset:42688
		ds_read_b64_tr_b16 v[108:109], v0 offset:34048
		ds_read_b64_tr_b16 v[110:111], v0 offset:34176
		ds_read_b64_tr_b16 v[112:113], v0 offset:34112
		ds_read_b64_tr_b16 v[114:115], v0 offset:34240
		ds_read_b64_tr_b16 v[116:117], v0 offset:42752
		ds_read_b64_tr_b16 v[118:119], v0 offset:42880
		ds_read_b64_tr_b16 v[120:121], v0 offset:42816
		ds_read_b64_tr_b16 v[122:123], v0 offset:42944
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[128:143], v[44:47], v[80:83], 0
		v_mfma_f32_32x32x16_bf16 v[176:191], v[52:55], v[80:83], 0
		v_mfma_f32_32x32x16_bf16 v[192:207], v[56:59], v[80:83], 0
		v_mfma_f32_32x32x16_bf16 v[208:223], v[60:63], v[80:83], 0
		v_mfma_f32_32x32x16_bf16 v[128:143], v[64:67], v[76:79], v[128:143]
		v_max3_f32 v2, v144, v145, v146
		v_max3_f32 v2, v2, v147, v148
		v_max3_f32 v2, v2, v149, v150
		v_max3_f32 v2, v2, v151, v152
		v_max3_f32 v2, v2, v153, v154
		v_max3_f32 v2, v2, v155, v156
		v_max3_f32 v2, v2, v157, v158
		v_mfma_f32_32x32x16_bf16 v[176:191], v[68:71], v[76:79], v[176:191]
		v_max3_f32 v2, v2, v159, v160
		v_max3_f32 v2, v2, v161, v162
		v_max3_f32 v2, v2, v163, v164
		v_max3_f32 v2, v2, v165, v166
		v_max3_f32 v2, v2, v167, v168
		v_max3_f32 v2, v2, v169, v170
		v_max3_f32 v2, v2, v171, v172
		v_mfma_f32_32x32x16_bf16 v[192:207], v[72:75], v[76:79], v[192:207]
		v_max3_f32 v2, v2, v173, v174
		v_max_f32_e32 v2, v2, v175
		v_mov_b32_e32 v6, v2
		v_mov_b32_e32 v7, v2
		s_nop 1
		v_permlane32_swap_b32_e32 v6, v7
		v_max_f32_e32 v2, v6, v7
		v_mul_f32_e32 v2, v2, v42
		v_mfma_f32_32x32x16_bf16 v[208:223], v[84:87], v[76:79], v[208:223]
		v_max_f32_e32 v2, v4, v2
		s_mov_b32 s1, 0x41000000
		v_sub_f32_e32 v6, v2, v4
		v_cmp_le_f32_e64 vcc, v6, s1
		s_cmp_eq_u64 vcc, s[6:7]
		v_mfma_f32_32x32x16_bf16 v[128:143], v[92:95], v[88:91], v[128:143]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_32x32x16_bf16 v[176:191], v[96:99], v[88:91], v[176:191]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_32x32x16_bf16 v[192:207], v[100:103], v[88:91], v[192:207]
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_32x32x16_bf16 v[208:223], v[104:107], v[88:91], v[208:223]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_32x32x16_bf16 v[128:143], v[108:111], v[48:51], v[128:143]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_32x32x16_bf16 v[176:191], v[112:115], v[48:51], v[176:191]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_32x32x16_bf16 v[192:207], v[116:119], v[48:51], v[192:207]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_32x32x16_bf16 v[208:223], v[120:123], v[48:51], v[208:223]
		s_cbranch_scc0 .Lflash_attention_bf16_gfx950.if_else_1
		v_max_f32_e32 v6, v4, v4
		v_max_f32_e32 v2, v40, v40
		s_branch .Lflash_attention_bf16_gfx950.if_end_1
.Lflash_attention_bf16_gfx950.if_else_1:
		v_sub_f32_e32 v4, v4, v2
		v_exp_f32_e32 v44, v4
		v_max_f32_e32 v6, v2, v2
		v_mov_b32_e32 v45, v44
		s_nop 3
		v_pk_mul_f32 v[128:129], v[128:129], v[44:45]
		v_pk_mul_f32 v[130:131], v[130:131], v[44:45]
		v_pk_mul_f32 v[132:133], v[132:133], v[44:45]
		v_pk_mul_f32 v[134:135], v[134:135], v[44:45]
		v_pk_mul_f32 v[136:137], v[136:137], v[44:45]
		v_pk_mul_f32 v[138:139], v[138:139], v[44:45]
		v_pk_mul_f32 v[140:141], v[140:141], v[44:45]
		v_pk_mul_f32 v[142:143], v[142:143], v[44:45]
		v_pk_mul_f32 v[176:177], v[176:177], v[44:45]
		v_pk_mul_f32 v[178:179], v[178:179], v[44:45]
		v_pk_mul_f32 v[180:181], v[180:181], v[44:45]
		v_pk_mul_f32 v[182:183], v[182:183], v[44:45]
		v_pk_mul_f32 v[184:185], v[184:185], v[44:45]
		v_pk_mul_f32 v[186:187], v[186:187], v[44:45]
		v_pk_mul_f32 v[188:189], v[188:189], v[44:45]
		v_pk_mul_f32 v[190:191], v[190:191], v[44:45]
		v_pk_mul_f32 v[192:193], v[192:193], v[44:45]
		v_pk_mul_f32 v[194:195], v[194:195], v[44:45]
		v_pk_mul_f32 v[196:197], v[196:197], v[44:45]
		v_pk_mul_f32 v[198:199], v[198:199], v[44:45]
		v_pk_mul_f32 v[200:201], v[200:201], v[44:45]
		v_pk_mul_f32 v[202:203], v[202:203], v[44:45]
		v_pk_mul_f32 v[204:205], v[204:205], v[44:45]
		v_pk_mul_f32 v[206:207], v[206:207], v[44:45]
		v_pk_mul_f32 v[208:209], v[208:209], v[44:45]
		v_pk_mul_f32 v[210:211], v[210:211], v[44:45]
		v_pk_mul_f32 v[212:213], v[212:213], v[44:45]
		v_pk_mul_f32 v[214:215], v[214:215], v[44:45]
		v_pk_mul_f32 v[216:217], v[216:217], v[44:45]
		v_pk_mul_f32 v[218:219], v[218:219], v[44:45]
		v_pk_mul_f32 v[220:221], v[220:221], v[44:45]
		v_pk_mul_f32 v[222:223], v[222:223], v[44:45]
		v_mul_f32_e32 v2, v40, v44
.Lflash_attention_bf16_gfx950.if_end_1:
		v_sub_f32_e32 v44, v41, v6
		v_mov_b32_e32 v45, v44
		v_pk_fma_f32 v[46:47], v[144:145], v[42:43], v[44:45]
		v_pk_fma_f32 v[48:49], v[146:147], v[42:43], v[44:45]
		v_pk_fma_f32 v[50:51], v[148:149], v[42:43], v[44:45]
		v_pk_fma_f32 v[52:53], v[150:151], v[42:43], v[44:45]
		v_pk_fma_f32 v[54:55], v[152:153], v[42:43], v[44:45]
		v_pk_fma_f32 v[56:57], v[154:155], v[42:43], v[44:45]
		v_pk_fma_f32 v[58:59], v[156:157], v[42:43], v[44:45]
		v_pk_fma_f32 v[60:61], v[158:159], v[42:43], v[44:45]
		v_exp_f32_e32 v64, v46
		v_exp_f32_e32 v65, v47
		v_exp_f32_e32 v66, v48
		v_exp_f32_e32 v67, v49
		v_exp_f32_e32 v68, v50
		v_exp_f32_e32 v69, v51
		v_exp_f32_e32 v70, v52
		v_exp_f32_e32 v71, v53
		v_exp_f32_e32 v72, v54
		v_exp_f32_e32 v73, v55
		v_exp_f32_e32 v74, v56
		v_exp_f32_e32 v75, v57
		v_exp_f32_e32 v76, v58
		v_exp_f32_e32 v77, v59
		v_exp_f32_e32 v78, v60
		v_exp_f32_e32 v79, v61
		v_pk_fma_f32 v[48:49], v[160:161], v[42:43], v[44:45]
		v_pk_fma_f32 v[50:51], v[162:163], v[42:43], v[44:45]
		v_pk_fma_f32 v[52:53], v[164:165], v[42:43], v[44:45]
		v_pk_fma_f32 v[54:55], v[166:167], v[42:43], v[44:45]
		v_pk_fma_f32 v[56:57], v[168:169], v[42:43], v[44:45]
		v_pk_fma_f32 v[58:59], v[170:171], v[42:43], v[44:45]
		v_pk_fma_f32 v[60:61], v[172:173], v[42:43], v[44:45]
		v_pk_fma_f32 v[62:63], v[174:175], v[42:43], v[44:45]
		v_add_u32_e32 v4, 0x8000, v5
		v_add_u32_e32 v7, 0x8080, v5
		v_add_u32_e32 v40, 0xc000, v5
		v_add_u32_e32 v44, 0xc080, v5
		s_mov_b32 s5, 2
		s_lshr_b32 s8, s0, 8
		s_and_b32 s8, s8, 1
		s_cmp_eq_u32 s8, 0
		s_cbranch_scc0 .Lflash_attention_bf16_gfx950.if_else_2
.Lflash_attention_bf16_gfx950.loop_head_0:
		s_add_i32 s8, s5, 3
		s_add_i32 s5, s5, 2
		s_cmp_lt_u32 s5, 0x80
		s_cselect_b32 s9, s5, 0x7e
		s_cmp_lt_u32 s8, 0x80
		s_cselect_b32 s8, s8, 0x7f
		s_barrier
		s_add_i32 m0, s3, 0x8200
		s_nop 0
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		s_lshl_b32 s8, s8, 14
		s_add_i32 m0, m0, 0x2200
		s_lshl_b32 s9, s9, 14
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		s_waitcnt vmcnt(6)
		s_barrier
		ds_read_b128 v[80:83], v3
		ds_read_b128 v[84:87], v3 offset:512
		ds_read_b128 v[88:91], v3 offset:32
		ds_read_b128 v[92:95], v3 offset:544
		ds_read_b128 v[96:99], v3 offset:64
		ds_read_b128 v[100:103], v3 offset:576
		ds_read_b128 v[104:107], v3 offset:96
		ds_read_b128 v[108:111], v3 offset:608
		ds_read_b128 v[112:115], v3 offset:8320
		ds_read_b128 v[116:119], v3 offset:8832
		ds_read_b128 v[120:123], v3 offset:8352
		ds_read_b128 v[124:127], v3 offset:8864
		ds_read_b128 v[144:147], v3 offset:8384
		ds_read_b128 v[148:151], v3 offset:8896
		ds_read_b128 v[152:155], v3 offset:8416
		ds_read_b128 v[156:159], v3 offset:8928
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[160:175], v[80:83], v[8:11], 0
		v_pk_add_f32 v[46:47], v[64:65], v[66:67]
		v_pk_add_f32 v[80:81], v[68:69], v[70:71]
		v_pk_add_f32 v[82:83], v[72:73], v[74:75]
		v_pk_add_f32 v[224:225], v[76:77], v[78:79]
		v_pk_add_f32 v[46:47], v[46:47], v[80:81]
		v_pk_add_f32 v[80:81], v[82:83], v[224:225]
		v_pk_add_f32 v[46:47], v[46:47], v[80:81]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[84:87], v[8:11], 0
		v_cvt_pk_bf16_f32 v81, v66, v67
		v_cvt_pk_bf16_f32 v82, v68, v69
		v_cvt_pk_bf16_f32 v83, v70, v71
		v_cvt_pk_bf16_f32 v68, v72, v73
		v_cvt_pk_bf16_f32 v69, v74, v75
		v_cvt_pk_bf16_f32 v70, v76, v77
		s_waitcnt lgkmcnt(13)
		v_mfma_f32_32x32x16_bf16 v[160:175], v[88:91], v[12:15], v[160:175]
		v_cvt_pk_bf16_f32 v71, v78, v79
		v_exp_f32_e32 v66, v48
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[92:95], v[12:15], v[224:239]
		v_exp_f32_e32 v72, v50
		v_exp_f32_e32 v74, v52
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], v[16:19], v[160:175]
		v_exp_f32_e32 v76, v54
		v_exp_f32_e32 v78, v56
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[100:103], v[16:19], v[224:239]
		v_exp_f32_e32 v84, v58
		v_exp_f32_e32 v86, v60
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_32x32x16_bf16 v[160:175], v[104:107], v[20:23], v[160:175]
		v_exp_f32_e32 v88, v62
		v_exp_f32_e32 v67, v49
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[108:111], v[20:23], v[224:239]
		v_cvt_pk_bf16_f32 v92, v66, v67
		v_exp_f32_e32 v73, v51
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_32x32x16_bf16 v[160:175], v[112:115], v[24:27], v[160:175]
		v_pk_add_f32 v[48:49], v[66:67], v[72:73]
		v_cvt_pk_bf16_f32 v93, v72, v73
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[116:119], v[24:27], v[224:239]
		v_exp_f32_e32 v75, v53
		s_nop 0
		v_cvt_pk_bf16_f32 v94, v74, v75
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_32x32x16_bf16 v[160:175], v[120:123], v[28:31], v[160:175]
		v_exp_f32_e32 v77, v55
		s_nop 0
		v_pk_add_f32 v[50:51], v[74:75], v[76:77]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[124:127], v[28:31], v[224:239]
		v_pk_add_f32 v[48:49], v[48:49], v[50:51]
		v_cvt_pk_bf16_f32 v95, v76, v77
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_32x32x16_bf16 v[160:175], v[144:147], v[32:35], v[160:175]
		v_exp_f32_e32 v79, v57
		s_nop 0
		v_cvt_pk_bf16_f32 v52, v78, v79
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[148:151], v[32:35], v[224:239]
		v_exp_f32_e32 v85, v59
		s_nop 0
		v_pk_add_f32 v[50:51], v[78:79], v[84:85]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_32x32x16_bf16 v[160:175], v[152:155], v[36:39], v[160:175]
		v_cvt_pk_bf16_f32 v53, v84, v85
		v_exp_f32_e32 v87, v61
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[156:159], v[36:39], v[224:239]
		v_exp_f32_e32 v89, v63
		s_nop 0
		v_pk_add_f32 v[54:55], v[86:87], v[88:89]
		v_pk_add_f32 v[50:51], v[50:51], v[54:55]
		v_pk_add_f32 v[48:49], v[48:49], v[50:51]
		v_pk_add_f32 v[50:51], v[46:47], v[48:49]
		v_add_f32_e32 v45, v50, v51
		v_cvt_pk_bf16_f32 v54, v86, v87
		v_cvt_pk_bf16_f32 v55, v88, v89
		v_mov_b32_e32 v46, v45
		v_mov_b32_e32 v47, v45
		s_nop 1
		v_permlane32_swap_b32_e32 v46, v47
		v_add_f32_e32 v45, v46, v47
		s_barrier
		v_add_f32_e32 v2, v2, v45
		s_mov_b32 m0, s4
		v_add_u32_e32 v45, s9, v5
		buffer_load_dwordx4 v45, s[16:19], 0 offen lds
		v_cvt_pk_bf16_f32 v80, v64, v65
		s_add_i32 m0, m0, 0x2080
		s_add_i32 s9, s9, 0x80
		v_add_u32_e32 v45, s9, v5
		buffer_load_dwordx4 v45, s[16:19], 0 offen lds
		s_waitcnt vmcnt(6)
		s_barrier
		ds_read_b64_tr_b16 v[48:49], v0 offset:50688
		ds_read_b64_tr_b16 v[50:51], v0 offset:50816
		ds_read_b64_tr_b16 v[56:57], v0 offset:50752
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_32x32x16_bf16 v[128:143], v[48:51], v[80:83], v[128:143]
		ds_read_b64_tr_b16 v[58:59], v0 offset:50880
		ds_read_b64_tr_b16 v[48:49], v0 offset:59392
		ds_read_b64_tr_b16 v[50:51], v0 offset:59520
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_32x32x16_bf16 v[176:191], v[56:59], v[80:83], v[176:191]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_32x32x16_bf16 v[192:207], v[48:51], v[80:83], v[192:207]
		ds_read_b64_tr_b16 v[48:49], v0 offset:59456
		ds_read_b64_tr_b16 v[50:51], v0 offset:59584
		ds_read_b64_tr_b16 v[56:57], v0 offset:50944
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_32x32x16_bf16 v[208:223], v[48:51], v[80:83], v[208:223]
		ds_read_b64_tr_b16 v[58:59], v0 offset:51072
		ds_read_b64_tr_b16 v[48:49], v0 offset:51008
		ds_read_b64_tr_b16 v[50:51], v0 offset:51136
		ds_read_b64_tr_b16 v[60:61], v0 offset:59648
		ds_read_b64_tr_b16 v[62:63], v0 offset:59776
		ds_read_b64_tr_b16 v[64:65], v0 offset:59712
		ds_read_b64_tr_b16 v[66:67], v0 offset:59840
		ds_read_b64_tr_b16 v[72:73], v0 offset:51200
		ds_read_b64_tr_b16 v[74:75], v0 offset:51328
		ds_read_b64_tr_b16 v[76:77], v0 offset:51264
		ds_read_b64_tr_b16 v[78:79], v0 offset:51392
		ds_read_b64_tr_b16 v[80:81], v0 offset:59904
		ds_read_b64_tr_b16 v[82:83], v0 offset:60032
		ds_read_b64_tr_b16 v[84:85], v0 offset:59968
		ds_read_b64_tr_b16 v[86:87], v0 offset:60096
		ds_read_b64_tr_b16 v[88:89], v0 offset:51456
		ds_read_b64_tr_b16 v[90:91], v0 offset:51584
		ds_read_b64_tr_b16 v[96:97], v0 offset:51520
		ds_read_b64_tr_b16 v[98:99], v0 offset:51648
		ds_read_b64_tr_b16 v[100:101], v0 offset:60160
		ds_read_b64_tr_b16 v[102:103], v0 offset:60288
		ds_read_b64_tr_b16 v[104:105], v0 offset:60224
		ds_read_b64_tr_b16 v[106:107], v0 offset:60352
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[128:143], v[56:59], v[68:71], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[48:51], v[68:71], v[176:191]
		v_max3_f32 v45, v160, v161, v162
		v_max3_f32 v45, v45, v163, v164
		v_max3_f32 v45, v45, v165, v166
		v_mfma_f32_32x32x16_bf16 v[192:207], v[60:63], v[68:71], v[192:207]
		v_max3_f32 v45, v45, v167, v168
		v_max3_f32 v45, v45, v169, v170
		v_mfma_f32_32x32x16_bf16 v[208:223], v[64:67], v[68:71], v[208:223]
		v_max3_f32 v45, v45, v171, v172
		v_max3_f32 v45, v45, v173, v174
		v_mfma_f32_32x32x16_bf16 v[128:143], v[72:75], v[92:95], v[128:143]
		v_max3_f32 v45, v45, v175, v224
		v_max3_f32 v45, v45, v225, v226
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_32x32x16_bf16 v[176:191], v[76:79], v[92:95], v[176:191]
		v_max3_f32 v45, v45, v227, v228
		v_max3_f32 v45, v45, v229, v230
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_32x32x16_bf16 v[192:207], v[80:83], v[92:95], v[192:207]
		v_max3_f32 v45, v45, v231, v232
		v_max3_f32 v45, v45, v233, v234
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_32x32x16_bf16 v[208:223], v[84:87], v[92:95], v[208:223]
		v_max3_f32 v45, v45, v235, v236
		v_max3_f32 v45, v45, v237, v238
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_32x32x16_bf16 v[128:143], v[88:91], v[52:55], v[128:143]
		v_max_f32_e32 v45, v45, v239
		v_mov_b32_e32 v46, v45
		v_mov_b32_e32 v47, v45
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_32x32x16_bf16 v[176:191], v[96:99], v[52:55], v[176:191]
		s_nop 0
		v_permlane32_swap_b32_e32 v46, v47
		v_max_f32_e32 v45, v46, v47
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_32x32x16_bf16 v[192:207], v[100:103], v[52:55], v[192:207]
		v_mul_f32_e32 v45, v45, v42
		v_max_f32_e32 v45, v6, v45
		v_sub_f32_e32 v46, v45, v6
		v_cmp_le_f32_e64 vcc, v46, s1
		s_cmp_eq_u64 vcc, s[6:7]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_32x32x16_bf16 v[208:223], v[104:107], v[52:55], v[208:223]
		s_cbranch_scc0 .Lflash_attention_bf16_gfx950.if_else_3
		v_max_f32_e32 v46, v6, v6
		v_max_f32_e32 v6, v2, v2
		s_branch .Lflash_attention_bf16_gfx950.if_end_3
.Lflash_attention_bf16_gfx950.if_else_3:
		v_sub_f32_e32 v6, v6, v45
		v_exp_f32_e32 v46, v6
		s_nop 0
		v_mov_b32_e32 v47, v46
		v_pk_mul_f32 v[128:129], v[128:129], v[46:47]
		v_pk_mul_f32 v[130:131], v[130:131], v[46:47]
		v_pk_mul_f32 v[132:133], v[132:133], v[46:47]
		v_pk_mul_f32 v[134:135], v[134:135], v[46:47]
		v_pk_mul_f32 v[136:137], v[136:137], v[46:47]
		v_pk_mul_f32 v[138:139], v[138:139], v[46:47]
		v_pk_mul_f32 v[140:141], v[140:141], v[46:47]
		v_pk_mul_f32 v[142:143], v[142:143], v[46:47]
		v_pk_mul_f32 v[176:177], v[176:177], v[46:47]
		v_pk_mul_f32 v[178:179], v[178:179], v[46:47]
		v_pk_mul_f32 v[180:181], v[180:181], v[46:47]
		v_pk_mul_f32 v[182:183], v[182:183], v[46:47]
		v_pk_mul_f32 v[184:185], v[184:185], v[46:47]
		v_pk_mul_f32 v[186:187], v[186:187], v[46:47]
		v_pk_mul_f32 v[188:189], v[188:189], v[46:47]
		v_pk_mul_f32 v[190:191], v[190:191], v[46:47]
		v_pk_mul_f32 v[192:193], v[192:193], v[46:47]
		v_pk_mul_f32 v[194:195], v[194:195], v[46:47]
		v_pk_mul_f32 v[196:197], v[196:197], v[46:47]
		v_pk_mul_f32 v[198:199], v[198:199], v[46:47]
		v_pk_mul_f32 v[200:201], v[200:201], v[46:47]
		v_pk_mul_f32 v[202:203], v[202:203], v[46:47]
		v_pk_mul_f32 v[204:205], v[204:205], v[46:47]
		v_pk_mul_f32 v[206:207], v[206:207], v[46:47]
		v_pk_mul_f32 v[208:209], v[208:209], v[46:47]
		v_pk_mul_f32 v[210:211], v[210:211], v[46:47]
		v_pk_mul_f32 v[212:213], v[212:213], v[46:47]
		v_pk_mul_f32 v[214:215], v[214:215], v[46:47]
		v_pk_mul_f32 v[216:217], v[216:217], v[46:47]
		v_pk_mul_f32 v[218:219], v[218:219], v[46:47]
		v_pk_mul_f32 v[220:221], v[220:221], v[46:47]
		v_pk_mul_f32 v[222:223], v[222:223], v[46:47]
		v_mul_f32_e32 v6, v2, v46
		v_max_f32_e32 v46, v45, v45
.Lflash_attention_bf16_gfx950.if_end_3:
		v_sub_f32_e32 v48, v41, v46
		v_mov_b32_e32 v49, v48
		v_pk_fma_f32 v[50:51], v[160:161], v[42:43], v[48:49]
		v_pk_fma_f32 v[52:53], v[162:163], v[42:43], v[48:49]
		v_pk_fma_f32 v[54:55], v[164:165], v[42:43], v[48:49]
		v_pk_fma_f32 v[56:57], v[166:167], v[42:43], v[48:49]
		v_pk_fma_f32 v[58:59], v[168:169], v[42:43], v[48:49]
		v_pk_fma_f32 v[60:61], v[170:171], v[42:43], v[48:49]
		v_pk_fma_f32 v[62:63], v[172:173], v[42:43], v[48:49]
		v_pk_fma_f32 v[64:65], v[174:175], v[42:43], v[48:49]
		v_exp_f32_e32 v67, v55
		v_exp_f32_e32 v68, v56
		v_exp_f32_e32 v69, v57
		v_exp_f32_e32 v56, v58
		v_exp_f32_e32 v57, v59
		v_exp_f32_e32 v58, v60
		v_exp_f32_e32 v59, v61
		v_exp_f32_e32 v60, v62
		v_exp_f32_e32 v61, v63
		v_exp_f32_e32 v62, v64
		v_exp_f32_e32 v63, v65
		v_pk_fma_f32 v[64:65], v[224:225], v[42:43], v[48:49]
		v_pk_fma_f32 v[70:71], v[226:227], v[42:43], v[48:49]
		v_pk_fma_f32 v[72:73], v[228:229], v[42:43], v[48:49]
		v_pk_fma_f32 v[74:75], v[230:231], v[42:43], v[48:49]
		v_pk_fma_f32 v[76:77], v[232:233], v[42:43], v[48:49]
		v_pk_fma_f32 v[78:79], v[234:235], v[42:43], v[48:49]
		v_pk_fma_f32 v[80:81], v[236:237], v[42:43], v[48:49]
		v_pk_fma_f32 v[82:83], v[238:239], v[42:43], v[48:49]
		s_barrier
		v_exp_f32_e32 v48, v50
		s_add_i32 m0, s3, 0xc600
		v_exp_f32_e32 v85, v53
		buffer_load_dwordx4 v40, s[20:23], 0 offen lds
		v_exp_f32_e32 v49, v51
		v_exp_f32_e32 v84, v52
		s_add_i32 m0, m0, 0x2200
		v_exp_f32_e32 v66, v54
		buffer_load_dwordx4 v44, s[20:23], 0 offen lds
		s_waitcnt vmcnt(6)
		s_barrier
		ds_read_b128 v[52:55], v3 offset:16640
		ds_read_b128 v[88:91], v3 offset:17152
		ds_read_b128 v[92:95], v3 offset:16672
		ds_read_b128 v[96:99], v3 offset:17184
		ds_read_b128 v[100:103], v3 offset:16704
		ds_read_b128 v[104:107], v3 offset:17216
		ds_read_b128 v[108:111], v3 offset:16736
		ds_read_b128 v[112:115], v3 offset:17248
		ds_read_b128 v[116:119], v3 offset:24960
		ds_read_b128 v[120:123], v3 offset:25472
		ds_read_b128 v[124:127], v3 offset:24992
		ds_read_b128 v[144:147], v3 offset:25504
		ds_read_b128 v[148:151], v3 offset:25024
		ds_read_b128 v[152:155], v3 offset:25536
		ds_read_b128 v[156:159], v3 offset:25056
		ds_read_b128 v[160:163], v3 offset:25568
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[52:55], v[8:11], 0
		v_pk_add_f32 v[50:51], v[48:49], v[84:85]
		v_pk_add_f32 v[52:53], v[66:67], v[68:69]
		v_pk_add_f32 v[54:55], v[56:57], v[58:59]
		v_pk_add_f32 v[86:87], v[60:61], v[62:63]
		v_pk_add_f32 v[50:51], v[50:51], v[52:53]
		v_pk_add_f32 v[52:53], v[54:55], v[86:87]
		v_pk_add_f32 v[50:51], v[50:51], v[52:53]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[88:91], v[8:11], 0
		v_cvt_pk_bf16_f32 v53, v84, v85
		v_cvt_pk_bf16_f32 v54, v66, v67
		v_cvt_pk_bf16_f32 v55, v68, v69
		v_cvt_pk_bf16_f32 v84, v56, v57
		v_cvt_pk_bf16_f32 v85, v58, v59
		v_cvt_pk_bf16_f32 v86, v60, v61
		s_waitcnt lgkmcnt(13)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[92:95], v[12:15], v[224:239]
		v_cvt_pk_bf16_f32 v87, v62, v63
		v_exp_f32_e32 v56, v64
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_32x32x16_bf16 v[240:255], v[96:99], v[12:15], v[240:255]
		v_exp_f32_e32 v58, v70
		v_exp_f32_e32 v60, v72
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[100:103], v[16:19], v[224:239]
		v_exp_f32_e32 v62, v74
		v_exp_f32_e32 v66, v76
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_32x32x16_bf16 v[240:255], v[104:107], v[16:19], v[240:255]
		v_exp_f32_e32 v68, v78
		v_exp_f32_e32 v88, v80
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[108:111], v[20:23], v[224:239]
		v_exp_f32_e32 v90, v82
		v_exp_f32_e32 v57, v65
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_32x32x16_bf16 v[240:255], v[112:115], v[20:23], v[240:255]
		v_cvt_pk_bf16_f32 v92, v56, v57
		v_exp_f32_e32 v59, v71
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[116:119], v[24:27], v[224:239]
		v_pk_add_f32 v[56:57], v[56:57], v[58:59]
		v_cvt_pk_bf16_f32 v93, v58, v59
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_32x32x16_bf16 v[240:255], v[120:123], v[24:27], v[240:255]
		v_exp_f32_e32 v61, v73
		s_nop 0
		v_cvt_pk_bf16_f32 v94, v60, v61
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[124:127], v[28:31], v[224:239]
		v_exp_f32_e32 v63, v75
		s_nop 0
		v_pk_add_f32 v[58:59], v[60:61], v[62:63]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_32x32x16_bf16 v[240:255], v[144:147], v[28:31], v[240:255]
		v_pk_add_f32 v[56:57], v[56:57], v[58:59]
		v_cvt_pk_bf16_f32 v95, v62, v63
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[148:151], v[32:35], v[224:239]
		v_exp_f32_e32 v67, v77
		s_nop 0
		v_cvt_pk_bf16_f32 v60, v66, v67
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_32x32x16_bf16 v[240:255], v[152:155], v[32:35], v[240:255]
		v_exp_f32_e32 v69, v79
		s_nop 0
		v_pk_add_f32 v[58:59], v[66:67], v[68:69]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[156:159], v[36:39], v[224:239]
		v_cvt_pk_bf16_f32 v61, v68, v69
		v_exp_f32_e32 v89, v81
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_32x32x16_bf16 v[240:255], v[160:163], v[36:39], v[240:255]
		v_exp_f32_e32 v91, v83
		s_nop 0
		v_pk_add_f32 v[62:63], v[88:89], v[90:91]
		v_pk_add_f32 v[58:59], v[58:59], v[62:63]
		v_pk_add_f32 v[56:57], v[56:57], v[58:59]
		v_pk_add_f32 v[58:59], v[50:51], v[56:57]
		v_add_f32_e32 v2, v58, v59
		v_cvt_pk_bf16_f32 v62, v88, v89
		v_cvt_pk_bf16_f32 v63, v90, v91
		v_mov_b32_e32 v50, v2
		v_mov_b32_e32 v51, v2
		s_nop 1
		v_permlane32_swap_b32_e32 v50, v51
		v_add_f32_e32 v2, v50, v51
		s_barrier
		v_add_f32_e32 v45, v6, v2
		s_add_i32 m0, s4, 0x4100
		v_add_u32_e32 v2, s8, v5
		buffer_load_dwordx4 v2, s[16:19], 0 offen lds
		v_cvt_pk_bf16_f32 v52, v48, v49
		s_add_i32 m0, m0, 0x2080
		s_add_i32 s8, s8, 0x80
		v_add_u32_e32 v2, s8, v5
		buffer_load_dwordx4 v2, s[16:19], 0 offen lds
		s_waitcnt vmcnt(6)
		s_barrier
		ds_read_b64_tr_b16 v[48:49], v0 offset:33280
		ds_read_b64_tr_b16 v[50:51], v0 offset:33408
		ds_read_b64_tr_b16 v[56:57], v0 offset:33344
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_32x32x16_bf16 v[128:143], v[48:51], v[52:55], v[128:143]
		ds_read_b64_tr_b16 v[58:59], v0 offset:33472
		ds_read_b64_tr_b16 v[48:49], v0 offset:41984
		ds_read_b64_tr_b16 v[50:51], v0 offset:42112
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_32x32x16_bf16 v[176:191], v[56:59], v[52:55], v[176:191]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_32x32x16_bf16 v[192:207], v[48:51], v[52:55], v[192:207]
		ds_read_b64_tr_b16 v[48:49], v0 offset:42048
		ds_read_b64_tr_b16 v[50:51], v0 offset:42176
		ds_read_b64_tr_b16 v[56:57], v0 offset:33536
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_32x32x16_bf16 v[208:223], v[48:51], v[52:55], v[208:223]
		ds_read_b64_tr_b16 v[58:59], v0 offset:33664
		ds_read_b64_tr_b16 v[48:49], v0 offset:33600
		ds_read_b64_tr_b16 v[50:51], v0 offset:33728
		ds_read_b64_tr_b16 v[52:53], v0 offset:42240
		ds_read_b64_tr_b16 v[54:55], v0 offset:42368
		ds_read_b64_tr_b16 v[64:65], v0 offset:42304
		ds_read_b64_tr_b16 v[66:67], v0 offset:42432
		ds_read_b64_tr_b16 v[68:69], v0 offset:33792
		ds_read_b64_tr_b16 v[70:71], v0 offset:33920
		ds_read_b64_tr_b16 v[72:73], v0 offset:33856
		ds_read_b64_tr_b16 v[74:75], v0 offset:33984
		ds_read_b64_tr_b16 v[76:77], v0 offset:42496
		ds_read_b64_tr_b16 v[78:79], v0 offset:42624
		ds_read_b64_tr_b16 v[80:81], v0 offset:42560
		ds_read_b64_tr_b16 v[82:83], v0 offset:42688
		ds_read_b64_tr_b16 v[88:89], v0 offset:34048
		ds_read_b64_tr_b16 v[90:91], v0 offset:34176
		ds_read_b64_tr_b16 v[96:97], v0 offset:34112
		ds_read_b64_tr_b16 v[98:99], v0 offset:34240
		ds_read_b64_tr_b16 v[100:101], v0 offset:42752
		ds_read_b64_tr_b16 v[102:103], v0 offset:42880
		ds_read_b64_tr_b16 v[104:105], v0 offset:42816
		ds_read_b64_tr_b16 v[106:107], v0 offset:42944
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[128:143], v[56:59], v[84:87], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[48:51], v[84:87], v[176:191]
		v_max3_f32 v2, v224, v225, v226
		v_max3_f32 v2, v2, v227, v228
		v_max3_f32 v2, v2, v229, v230
		v_mfma_f32_32x32x16_bf16 v[192:207], v[52:55], v[84:87], v[192:207]
		v_max3_f32 v2, v2, v231, v232
		v_max3_f32 v2, v2, v233, v234
		v_mfma_f32_32x32x16_bf16 v[208:223], v[64:67], v[84:87], v[208:223]
		v_max3_f32 v2, v2, v235, v236
		v_max3_f32 v2, v2, v237, v238
		v_mfma_f32_32x32x16_bf16 v[128:143], v[68:71], v[92:95], v[128:143]
		v_max3_f32 v2, v2, v239, v240
		v_max3_f32 v2, v2, v241, v242
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_32x32x16_bf16 v[176:191], v[72:75], v[92:95], v[176:191]
		v_max3_f32 v2, v2, v243, v244
		v_max3_f32 v2, v2, v245, v246
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_32x32x16_bf16 v[192:207], v[76:79], v[92:95], v[192:207]
		v_max3_f32 v2, v2, v247, v248
		v_max3_f32 v2, v2, v249, v250
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_32x32x16_bf16 v[208:223], v[80:83], v[92:95], v[208:223]
		v_max3_f32 v2, v2, v251, v252
		v_max3_f32 v2, v2, v253, v254
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_32x32x16_bf16 v[128:143], v[88:91], v[60:63], v[128:143]
		v_max_f32_e32 v2, v2, v255
		v_mov_b32_e32 v48, v2
		v_mov_b32_e32 v49, v2
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_32x32x16_bf16 v[176:191], v[96:99], v[60:63], v[176:191]
		s_nop 0
		v_permlane32_swap_b32_e32 v48, v49
		v_max_f32_e32 v2, v48, v49
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_32x32x16_bf16 v[192:207], v[100:103], v[60:63], v[192:207]
		v_mul_f32_e32 v2, v2, v42
		v_max_f32_e32 v6, v46, v2
		v_sub_f32_e32 v2, v6, v46
		v_cmp_le_f32_e64 vcc, v2, s1
		s_cmp_eq_u64 vcc, s[6:7]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_32x32x16_bf16 v[208:223], v[104:107], v[60:63], v[208:223]
		s_cbranch_scc0 .Lflash_attention_bf16_gfx950.if_else_4
		v_max_f32_e32 v6, v46, v46
		v_max_f32_e32 v2, v45, v45
		s_branch .Lflash_attention_bf16_gfx950.if_end_4
.Lflash_attention_bf16_gfx950.if_else_4:
		v_sub_f32_e32 v2, v46, v6
		v_exp_f32_e32 v46, v2
		s_nop 0
		v_mov_b32_e32 v47, v46
		v_pk_mul_f32 v[128:129], v[128:129], v[46:47]
		v_pk_mul_f32 v[130:131], v[130:131], v[46:47]
		v_pk_mul_f32 v[132:133], v[132:133], v[46:47]
		v_pk_mul_f32 v[134:135], v[134:135], v[46:47]
		v_pk_mul_f32 v[136:137], v[136:137], v[46:47]
		v_pk_mul_f32 v[138:139], v[138:139], v[46:47]
		v_pk_mul_f32 v[140:141], v[140:141], v[46:47]
		v_pk_mul_f32 v[142:143], v[142:143], v[46:47]
		v_pk_mul_f32 v[176:177], v[176:177], v[46:47]
		v_pk_mul_f32 v[178:179], v[178:179], v[46:47]
		v_pk_mul_f32 v[180:181], v[180:181], v[46:47]
		v_pk_mul_f32 v[182:183], v[182:183], v[46:47]
		v_pk_mul_f32 v[184:185], v[184:185], v[46:47]
		v_pk_mul_f32 v[186:187], v[186:187], v[46:47]
		v_pk_mul_f32 v[188:189], v[188:189], v[46:47]
		v_pk_mul_f32 v[190:191], v[190:191], v[46:47]
		v_pk_mul_f32 v[192:193], v[192:193], v[46:47]
		v_pk_mul_f32 v[194:195], v[194:195], v[46:47]
		v_pk_mul_f32 v[196:197], v[196:197], v[46:47]
		v_pk_mul_f32 v[198:199], v[198:199], v[46:47]
		v_pk_mul_f32 v[200:201], v[200:201], v[46:47]
		v_pk_mul_f32 v[202:203], v[202:203], v[46:47]
		v_pk_mul_f32 v[204:205], v[204:205], v[46:47]
		v_pk_mul_f32 v[206:207], v[206:207], v[46:47]
		v_pk_mul_f32 v[208:209], v[208:209], v[46:47]
		v_pk_mul_f32 v[210:211], v[210:211], v[46:47]
		v_pk_mul_f32 v[212:213], v[212:213], v[46:47]
		v_pk_mul_f32 v[214:215], v[214:215], v[46:47]
		v_pk_mul_f32 v[216:217], v[216:217], v[46:47]
		v_pk_mul_f32 v[218:219], v[218:219], v[46:47]
		v_pk_mul_f32 v[220:221], v[220:221], v[46:47]
		v_pk_mul_f32 v[222:223], v[222:223], v[46:47]
		v_mul_f32_e32 v2, v45, v46
		v_max_f32_e32 v6, v6, v6
.Lflash_attention_bf16_gfx950.if_end_4:
		v_sub_f32_e32 v46, v41, v6
		v_mov_b32_e32 v47, v46
		v_pk_fma_f32 v[48:49], v[224:225], v[42:43], v[46:47]
		v_pk_fma_f32 v[50:51], v[226:227], v[42:43], v[46:47]
		v_pk_fma_f32 v[52:53], v[228:229], v[42:43], v[46:47]
		v_pk_fma_f32 v[54:55], v[230:231], v[42:43], v[46:47]
		v_pk_fma_f32 v[56:57], v[232:233], v[42:43], v[46:47]
		v_pk_fma_f32 v[58:59], v[234:235], v[42:43], v[46:47]
		v_pk_fma_f32 v[60:61], v[236:237], v[42:43], v[46:47]
		v_pk_fma_f32 v[62:63], v[238:239], v[42:43], v[46:47]
		v_exp_f32_e32 v64, v48
		v_exp_f32_e32 v65, v49
		v_exp_f32_e32 v66, v50
		v_exp_f32_e32 v67, v51
		v_exp_f32_e32 v68, v52
		v_exp_f32_e32 v69, v53
		v_exp_f32_e32 v70, v54
		v_exp_f32_e32 v71, v55
		v_exp_f32_e32 v72, v56
		v_exp_f32_e32 v73, v57
		v_exp_f32_e32 v74, v58
		v_exp_f32_e32 v75, v59
		v_exp_f32_e32 v76, v60
		v_exp_f32_e32 v77, v61
		v_exp_f32_e32 v78, v62
		v_exp_f32_e32 v79, v63
		v_pk_fma_f32 v[48:49], v[240:241], v[42:43], v[46:47]
		v_pk_fma_f32 v[50:51], v[242:243], v[42:43], v[46:47]
		v_pk_fma_f32 v[52:53], v[244:245], v[42:43], v[46:47]
		v_pk_fma_f32 v[54:55], v[246:247], v[42:43], v[46:47]
		v_pk_fma_f32 v[56:57], v[248:249], v[42:43], v[46:47]
		v_pk_fma_f32 v[58:59], v[250:251], v[42:43], v[46:47]
		v_pk_fma_f32 v[60:61], v[252:253], v[42:43], v[46:47]
		v_pk_fma_f32 v[62:63], v[254:255], v[42:43], v[46:47]
		s_add_u32 s20, s20, 0x8000
		s_addc_u32 s21, s21, 0
		s_cmp_lt_i32 s5, 0x80
		s_cbranch_scc1 .Lflash_attention_bf16_gfx950.loop_head_0
.Lflash_attention_bf16_gfx950.loop_exit_0:
		s_branch .Lflash_attention_bf16_gfx950.if_end_2
.Lflash_attention_bf16_gfx950.if_else_2:
.Lflash_attention_bf16_gfx950.loop_head_1:
		s_add_i32 s8, s5, 3
		s_add_i32 s5, s5, 2
		s_cmp_lt_u32 s5, 0x80
		s_cselect_b32 s9, s5, 0x7e
		s_cmp_lt_u32 s8, 0x80
		s_cselect_b32 s8, s8, 0x7f
		s_barrier
		s_add_i32 m0, s3, 0x8200
		s_lshl_b32 s8, s8, 14
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		v_add_u32_e32 v45, s8, v5
		s_add_i32 m0, m0, 0x2200
		s_lshl_b32 s9, s9, 14
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		s_waitcnt vmcnt(6)
		s_barrier
		v_pk_add_f32 v[46:47], v[64:65], v[66:67]
		v_pk_add_f32 v[80:81], v[68:69], v[70:71]
		v_pk_add_f32 v[82:83], v[72:73], v[74:75]
		v_pk_add_f32 v[84:85], v[76:77], v[78:79]
		v_pk_add_f32 v[46:47], v[46:47], v[80:81]
		v_pk_add_f32 v[80:81], v[82:83], v[84:85]
		v_pk_add_f32 v[46:47], v[46:47], v[80:81]
		v_cvt_pk_bf16_f32 v81, v66, v67
		v_cvt_pk_bf16_f32 v82, v68, v69
		v_cvt_pk_bf16_f32 v83, v70, v71
		v_cvt_pk_bf16_f32 v68, v72, v73
		v_cvt_pk_bf16_f32 v69, v74, v75
		v_cvt_pk_bf16_f32 v70, v76, v77
		v_cvt_pk_bf16_f32 v71, v78, v79
		v_exp_f32_e32 v66, v48
		ds_read_b128 v[72:75], v3
		ds_read_b128 v[76:79], v3 offset:512
		ds_read_b128 v[84:87], v3 offset:32
		ds_read_b128 v[88:91], v3 offset:544
		ds_read_b128 v[92:95], v3 offset:64
		ds_read_b128 v[96:99], v3 offset:576
		ds_read_b128 v[100:103], v3 offset:96
		ds_read_b128 v[104:107], v3 offset:608
		ds_read_b128 v[108:111], v3 offset:8320
		ds_read_b128 v[112:115], v3 offset:8832
		ds_read_b128 v[116:119], v3 offset:8352
		ds_read_b128 v[120:123], v3 offset:8864
		ds_read_b128 v[124:127], v3 offset:8384
		ds_read_b128 v[144:147], v3 offset:8896
		ds_read_b128 v[148:151], v3 offset:8416
		ds_read_b128 v[152:155], v3 offset:8928
		v_exp_f32_e32 v156, v50
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[160:175], v[72:75], v[8:11], 0
		v_exp_f32_e32 v72, v52
		v_exp_f32_e32 v74, v54
		v_mfma_f32_32x32x16_bf16 v[224:239], v[76:79], v[8:11], 0
		v_exp_f32_e32 v76, v56
		v_exp_f32_e32 v78, v58
		s_waitcnt lgkmcnt(13)
		v_mfma_f32_32x32x16_bf16 v[160:175], v[84:87], v[12:15], v[160:175]
		v_exp_f32_e32 v84, v60
		v_exp_f32_e32 v86, v62
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[88:91], v[12:15], v[224:239]
		v_exp_f32_e32 v67, v49
		s_nop 0
		v_cvt_pk_bf16_f32 v88, v66, v67
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_32x32x16_bf16 v[160:175], v[92:95], v[16:19], v[160:175]
		v_exp_f32_e32 v157, v51
		s_nop 0
		v_pk_add_f32 v[48:49], v[66:67], v[156:157]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[96:99], v[16:19], v[224:239]
		v_cvt_pk_bf16_f32 v89, v156, v157
		v_exp_f32_e32 v73, v53
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_32x32x16_bf16 v[160:175], v[100:103], v[20:23], v[160:175]
		v_cvt_pk_bf16_f32 v90, v72, v73
		v_exp_f32_e32 v75, v55
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[104:107], v[20:23], v[224:239]
		v_pk_add_f32 v[50:51], v[72:73], v[74:75]
		v_pk_add_f32 v[48:49], v[48:49], v[50:51]
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_32x32x16_bf16 v[160:175], v[108:111], v[24:27], v[160:175]
		v_cvt_pk_bf16_f32 v91, v74, v75
		v_exp_f32_e32 v77, v57
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[112:115], v[24:27], v[224:239]
		v_cvt_pk_bf16_f32 v52, v76, v77
		v_exp_f32_e32 v79, v59
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_32x32x16_bf16 v[160:175], v[116:119], v[28:31], v[160:175]
		v_pk_add_f32 v[50:51], v[76:77], v[78:79]
		v_cvt_pk_bf16_f32 v53, v78, v79
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[120:123], v[28:31], v[224:239]
		v_exp_f32_e32 v85, v61
		s_nop 0
		v_cvt_pk_bf16_f32 v54, v84, v85
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_32x32x16_bf16 v[160:175], v[124:127], v[32:35], v[160:175]
		v_exp_f32_e32 v87, v63
		s_nop 0
		v_pk_add_f32 v[56:57], v[84:85], v[86:87]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[144:147], v[32:35], v[224:239]
		v_pk_add_f32 v[50:51], v[50:51], v[56:57]
		v_pk_add_f32 v[48:49], v[48:49], v[50:51]
		v_pk_add_f32 v[50:51], v[46:47], v[48:49]
		v_add_f32_e32 v46, v50, v51
		v_cvt_pk_bf16_f32 v55, v86, v87
		v_mov_b32_e32 v48, v46
		v_mov_b32_e32 v49, v46
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_32x32x16_bf16 v[160:175], v[148:151], v[36:39], v[160:175]
		s_nop 0
		v_permlane32_swap_b32_e32 v48, v49
		v_add_f32_e32 v46, v48, v49
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[152:155], v[36:39], v[224:239]
		s_barrier
		v_add_f32_e32 v2, v2, v46
		s_mov_b32 m0, s4
		v_add_u32_e32 v46, s9, v5
		s_add_i32 s9, s9, 0x80
		buffer_load_dwordx4 v46, s[16:19], 0 offen lds
		v_add_u32_e32 v46, s9, v5
		s_add_i32 m0, m0, 0x2080
		v_cvt_pk_bf16_f32 v80, v64, v65
		buffer_load_dwordx4 v46, s[16:19], 0 offen lds
		s_waitcnt vmcnt(6)
		s_barrier
		ds_read_b64_tr_b16 v[48:49], v0 offset:50688
		ds_read_b64_tr_b16 v[50:51], v0 offset:50816
		ds_read_b64_tr_b16 v[56:57], v0 offset:50752
		ds_read_b64_tr_b16 v[58:59], v0 offset:50880
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_32x32x16_bf16 v[128:143], v[48:51], v[80:83], v[128:143]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_32x32x16_bf16 v[176:191], v[56:59], v[80:83], v[176:191]
		ds_read_b64_tr_b16 v[48:49], v0 offset:59392
		ds_read_b64_tr_b16 v[50:51], v0 offset:59520
		ds_read_b64_tr_b16 v[56:57], v0 offset:59456
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_32x32x16_bf16 v[192:207], v[48:51], v[80:83], v[192:207]
		ds_read_b64_tr_b16 v[58:59], v0 offset:59584
		ds_read_b64_tr_b16 v[48:49], v0 offset:50944
		ds_read_b64_tr_b16 v[50:51], v0 offset:51072
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_32x32x16_bf16 v[208:223], v[56:59], v[80:83], v[208:223]
		ds_read_b64_tr_b16 v[56:57], v0 offset:51008
		ds_read_b64_tr_b16 v[58:59], v0 offset:51136
		ds_read_b64_tr_b16 v[60:61], v0 offset:59648
		ds_read_b64_tr_b16 v[62:63], v0 offset:59776
		ds_read_b64_tr_b16 v[64:65], v0 offset:59712
		ds_read_b64_tr_b16 v[66:67], v0 offset:59840
		ds_read_b64_tr_b16 v[72:73], v0 offset:51200
		ds_read_b64_tr_b16 v[74:75], v0 offset:51328
		ds_read_b64_tr_b16 v[76:77], v0 offset:51264
		ds_read_b64_tr_b16 v[78:79], v0 offset:51392
		ds_read_b64_tr_b16 v[80:81], v0 offset:59904
		ds_read_b64_tr_b16 v[82:83], v0 offset:60032
		ds_read_b64_tr_b16 v[84:85], v0 offset:59968
		ds_read_b64_tr_b16 v[86:87], v0 offset:60096
		ds_read_b64_tr_b16 v[92:93], v0 offset:51456
		ds_read_b64_tr_b16 v[94:95], v0 offset:51584
		ds_read_b64_tr_b16 v[96:97], v0 offset:51520
		ds_read_b64_tr_b16 v[98:99], v0 offset:51648
		ds_read_b64_tr_b16 v[100:101], v0 offset:60160
		ds_read_b64_tr_b16 v[102:103], v0 offset:60288
		ds_read_b64_tr_b16 v[104:105], v0 offset:60224
		ds_read_b64_tr_b16 v[106:107], v0 offset:60352
		v_max3_f32 v46, v160, v161, v162
		v_max3_f32 v46, v46, v163, v164
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[128:143], v[48:51], v[68:71], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[56:59], v[68:71], v[176:191]
		v_max3_f32 v46, v46, v165, v166
		v_max3_f32 v46, v46, v167, v168
		v_mfma_f32_32x32x16_bf16 v[192:207], v[60:63], v[68:71], v[192:207]
		v_max3_f32 v46, v46, v169, v170
		v_max3_f32 v46, v46, v171, v172
		v_mfma_f32_32x32x16_bf16 v[208:223], v[64:67], v[68:71], v[208:223]
		v_max3_f32 v46, v46, v173, v174
		v_max3_f32 v46, v46, v175, v224
		v_mfma_f32_32x32x16_bf16 v[128:143], v[72:75], v[88:91], v[128:143]
		v_max3_f32 v46, v46, v225, v226
		v_max3_f32 v46, v46, v227, v228
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_32x32x16_bf16 v[176:191], v[76:79], v[88:91], v[176:191]
		v_max3_f32 v46, v46, v229, v230
		v_max3_f32 v46, v46, v231, v232
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_32x32x16_bf16 v[192:207], v[80:83], v[88:91], v[192:207]
		v_max3_f32 v46, v46, v233, v234
		v_max3_f32 v46, v46, v235, v236
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_32x32x16_bf16 v[208:223], v[84:87], v[88:91], v[208:223]
		v_max3_f32 v46, v46, v237, v238
		v_max_f32_e32 v46, v46, v239
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_32x32x16_bf16 v[128:143], v[92:95], v[52:55], v[128:143]
		v_mov_b32_e32 v48, v46
		v_mov_b32_e32 v49, v46
		s_nop 1
		v_permlane32_swap_b32_e32 v48, v49
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_32x32x16_bf16 v[176:191], v[96:99], v[52:55], v[176:191]
		v_max_f32_e32 v46, v48, v49
		v_mul_f32_e32 v46, v46, v42
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_32x32x16_bf16 v[192:207], v[100:103], v[52:55], v[192:207]
		v_max_f32_e32 v46, v6, v46
		v_sub_f32_e32 v47, v46, v6
		v_cmp_le_f32_e64 vcc, v47, s1
		s_cmp_eq_u64 vcc, s[6:7]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_32x32x16_bf16 v[208:223], v[104:107], v[52:55], v[208:223]
		s_cbranch_scc0 .Lflash_attention_bf16_gfx950.if_else_5
		v_max_f32_e32 v47, v6, v6
		v_max_f32_e32 v6, v2, v2
		s_branch .Lflash_attention_bf16_gfx950.if_end_5
.Lflash_attention_bf16_gfx950.if_else_5:
		v_sub_f32_e32 v6, v6, v46
		v_exp_f32_e32 v48, v6
		s_nop 0
		v_mov_b32_e32 v49, v48
		v_pk_mul_f32 v[128:129], v[128:129], v[48:49]
		v_pk_mul_f32 v[130:131], v[130:131], v[48:49]
		v_pk_mul_f32 v[132:133], v[132:133], v[48:49]
		v_pk_mul_f32 v[134:135], v[134:135], v[48:49]
		v_pk_mul_f32 v[136:137], v[136:137], v[48:49]
		v_pk_mul_f32 v[138:139], v[138:139], v[48:49]
		v_pk_mul_f32 v[140:141], v[140:141], v[48:49]
		v_pk_mul_f32 v[142:143], v[142:143], v[48:49]
		v_pk_mul_f32 v[176:177], v[176:177], v[48:49]
		v_pk_mul_f32 v[178:179], v[178:179], v[48:49]
		v_pk_mul_f32 v[180:181], v[180:181], v[48:49]
		v_pk_mul_f32 v[182:183], v[182:183], v[48:49]
		v_pk_mul_f32 v[184:185], v[184:185], v[48:49]
		v_pk_mul_f32 v[186:187], v[186:187], v[48:49]
		v_pk_mul_f32 v[188:189], v[188:189], v[48:49]
		v_pk_mul_f32 v[190:191], v[190:191], v[48:49]
		v_pk_mul_f32 v[192:193], v[192:193], v[48:49]
		v_pk_mul_f32 v[194:195], v[194:195], v[48:49]
		v_pk_mul_f32 v[196:197], v[196:197], v[48:49]
		v_pk_mul_f32 v[198:199], v[198:199], v[48:49]
		v_pk_mul_f32 v[200:201], v[200:201], v[48:49]
		v_pk_mul_f32 v[202:203], v[202:203], v[48:49]
		v_pk_mul_f32 v[204:205], v[204:205], v[48:49]
		v_pk_mul_f32 v[206:207], v[206:207], v[48:49]
		v_pk_mul_f32 v[208:209], v[208:209], v[48:49]
		v_pk_mul_f32 v[210:211], v[210:211], v[48:49]
		v_pk_mul_f32 v[212:213], v[212:213], v[48:49]
		v_pk_mul_f32 v[214:215], v[214:215], v[48:49]
		v_pk_mul_f32 v[216:217], v[216:217], v[48:49]
		v_pk_mul_f32 v[218:219], v[218:219], v[48:49]
		v_pk_mul_f32 v[220:221], v[220:221], v[48:49]
		v_pk_mul_f32 v[222:223], v[222:223], v[48:49]
		v_mul_f32_e32 v6, v2, v48
		v_max_f32_e32 v47, v46, v46
.Lflash_attention_bf16_gfx950.if_end_5:
		v_sub_f32_e32 v48, v41, v47
		v_mov_b32_e32 v49, v48
		v_pk_fma_f32 v[50:51], v[160:161], v[42:43], v[48:49]
		v_pk_fma_f32 v[52:53], v[162:163], v[42:43], v[48:49]
		v_pk_fma_f32 v[54:55], v[164:165], v[42:43], v[48:49]
		v_pk_fma_f32 v[56:57], v[166:167], v[42:43], v[48:49]
		v_pk_fma_f32 v[58:59], v[168:169], v[42:43], v[48:49]
		v_pk_fma_f32 v[60:61], v[170:171], v[42:43], v[48:49]
		v_pk_fma_f32 v[62:63], v[172:173], v[42:43], v[48:49]
		v_pk_fma_f32 v[64:65], v[174:175], v[42:43], v[48:49]
		v_exp_f32_e32 v66, v54
		v_exp_f32_e32 v67, v55
		v_exp_f32_e32 v54, v56
		v_exp_f32_e32 v55, v57
		v_exp_f32_e32 v56, v58
		v_exp_f32_e32 v57, v59
		v_exp_f32_e32 v58, v60
		v_exp_f32_e32 v59, v61
		v_exp_f32_e32 v60, v62
		v_exp_f32_e32 v61, v63
		v_exp_f32_e32 v62, v64
		v_exp_f32_e32 v63, v65
		v_pk_fma_f32 v[64:65], v[224:225], v[42:43], v[48:49]
		v_pk_fma_f32 v[68:69], v[226:227], v[42:43], v[48:49]
		v_pk_fma_f32 v[70:71], v[228:229], v[42:43], v[48:49]
		v_pk_fma_f32 v[72:73], v[230:231], v[42:43], v[48:49]
		v_pk_fma_f32 v[74:75], v[232:233], v[42:43], v[48:49]
		v_pk_fma_f32 v[76:77], v[234:235], v[42:43], v[48:49]
		v_pk_fma_f32 v[78:79], v[236:237], v[42:43], v[48:49]
		v_pk_fma_f32 v[80:81], v[238:239], v[42:43], v[48:49]
		s_barrier
		v_exp_f32_e32 v48, v50
		s_add_i32 m0, s3, 0xc600
		v_exp_f32_e32 v49, v51
		buffer_load_dwordx4 v40, s[20:23], 0 offen lds
		v_exp_f32_e32 v50, v52
		s_add_i32 m0, m0, 0x2200
		v_exp_f32_e32 v51, v53
		buffer_load_dwordx4 v44, s[20:23], 0 offen lds
		s_waitcnt vmcnt(6)
		s_barrier
		v_pk_add_f32 v[52:53], v[48:49], v[50:51]
		v_pk_add_f32 v[82:83], v[66:67], v[54:55]
		v_pk_add_f32 v[84:85], v[56:57], v[58:59]
		v_pk_add_f32 v[86:87], v[60:61], v[62:63]
		v_pk_add_f32 v[52:53], v[52:53], v[82:83]
		v_pk_add_f32 v[82:83], v[84:85], v[86:87]
		v_pk_add_f32 v[52:53], v[52:53], v[82:83]
		v_cvt_pk_bf16_f32 v85, v50, v51
		v_cvt_pk_bf16_f32 v86, v66, v67
		v_cvt_pk_bf16_f32 v87, v54, v55
		v_cvt_pk_bf16_f32 v88, v56, v57
		v_cvt_pk_bf16_f32 v89, v58, v59
		v_cvt_pk_bf16_f32 v90, v60, v61
		v_cvt_pk_bf16_f32 v91, v62, v63
		v_exp_f32_e32 v50, v64
		ds_read_b128 v[56:59], v3 offset:16640
		ds_read_b128 v[60:63], v3 offset:17152
		ds_read_b128 v[92:95], v3 offset:16672
		ds_read_b128 v[96:99], v3 offset:17184
		ds_read_b128 v[100:103], v3 offset:16704
		ds_read_b128 v[104:107], v3 offset:17216
		ds_read_b128 v[108:111], v3 offset:16736
		ds_read_b128 v[112:115], v3 offset:17248
		ds_read_b128 v[116:119], v3 offset:24960
		ds_read_b128 v[120:123], v3 offset:25472
		ds_read_b128 v[124:127], v3 offset:24992
		ds_read_b128 v[144:147], v3 offset:25504
		ds_read_b128 v[148:151], v3 offset:25024
		ds_read_b128 v[152:155], v3 offset:25536
		ds_read_b128 v[156:159], v3 offset:25056
		ds_read_b128 v[160:163], v3 offset:25568
		v_exp_f32_e32 v54, v68
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[56:59], v[8:11], 0
		v_exp_f32_e32 v56, v70
		v_exp_f32_e32 v58, v72
		v_mfma_f32_32x32x16_bf16 v[240:255], v[60:63], v[8:11], 0
		v_exp_f32_e32 v60, v74
		v_exp_f32_e32 v62, v76
		s_waitcnt lgkmcnt(13)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[92:95], v[12:15], v[224:239]
		v_exp_f32_e32 v66, v78
		v_exp_f32_e32 v82, v80
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_32x32x16_bf16 v[240:255], v[96:99], v[12:15], v[240:255]
		v_exp_f32_e32 v51, v65
		s_nop 0
		v_cvt_pk_bf16_f32 v92, v50, v51
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[100:103], v[16:19], v[224:239]
		v_exp_f32_e32 v55, v69
		s_nop 0
		v_pk_add_f32 v[50:51], v[50:51], v[54:55]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_32x32x16_bf16 v[240:255], v[104:107], v[16:19], v[240:255]
		v_cvt_pk_bf16_f32 v93, v54, v55
		v_exp_f32_e32 v57, v71
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[108:111], v[20:23], v[224:239]
		v_cvt_pk_bf16_f32 v94, v56, v57
		v_exp_f32_e32 v59, v73
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_32x32x16_bf16 v[240:255], v[112:115], v[20:23], v[240:255]
		v_pk_add_f32 v[54:55], v[56:57], v[58:59]
		v_pk_add_f32 v[50:51], v[50:51], v[54:55]
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[116:119], v[24:27], v[224:239]
		v_cvt_pk_bf16_f32 v95, v58, v59
		v_exp_f32_e32 v61, v75
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_32x32x16_bf16 v[240:255], v[120:123], v[24:27], v[240:255]
		v_cvt_pk_bf16_f32 v56, v60, v61
		v_exp_f32_e32 v63, v77
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[124:127], v[28:31], v[224:239]
		v_pk_add_f32 v[54:55], v[60:61], v[62:63]
		v_cvt_pk_bf16_f32 v57, v62, v63
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_32x32x16_bf16 v[240:255], v[144:147], v[28:31], v[240:255]
		v_exp_f32_e32 v67, v79
		s_nop 0
		v_cvt_pk_bf16_f32 v58, v66, v67
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[148:151], v[32:35], v[224:239]
		v_exp_f32_e32 v83, v81
		s_nop 0
		v_pk_add_f32 v[60:61], v[66:67], v[82:83]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_32x32x16_bf16 v[240:255], v[152:155], v[32:35], v[240:255]
		v_pk_add_f32 v[54:55], v[54:55], v[60:61]
		v_pk_add_f32 v[50:51], v[50:51], v[54:55]
		v_pk_add_f32 v[54:55], v[52:53], v[50:51]
		v_add_f32_e32 v2, v54, v55
		v_cvt_pk_bf16_f32 v59, v82, v83
		v_mov_b32_e32 v50, v2
		v_mov_b32_e32 v51, v2
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_32x32x16_bf16 v[224:239], v[156:159], v[36:39], v[224:239]
		s_nop 0
		v_permlane32_swap_b32_e32 v50, v51
		v_add_f32_e32 v2, v50, v51
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_32x32x16_bf16 v[240:255], v[160:163], v[36:39], v[240:255]
		s_barrier
		v_add_f32_e32 v46, v6, v2
		s_add_i32 m0, s4, 0x4100
		s_add_i32 s8, s8, 0x80
		buffer_load_dwordx4 v45, s[16:19], 0 offen lds
		v_add_u32_e32 v2, s8, v5
		s_add_i32 m0, m0, 0x2080
		v_cvt_pk_bf16_f32 v84, v48, v49
		buffer_load_dwordx4 v2, s[16:19], 0 offen lds
		s_waitcnt vmcnt(6)
		s_barrier
		ds_read_b64_tr_b16 v[48:49], v0 offset:33280
		ds_read_b64_tr_b16 v[50:51], v0 offset:33408
		ds_read_b64_tr_b16 v[52:53], v0 offset:33344
		ds_read_b64_tr_b16 v[54:55], v0 offset:33472
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_32x32x16_bf16 v[128:143], v[48:51], v[84:87], v[128:143]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_32x32x16_bf16 v[176:191], v[52:55], v[84:87], v[176:191]
		ds_read_b64_tr_b16 v[48:49], v0 offset:41984
		ds_read_b64_tr_b16 v[50:51], v0 offset:42112
		ds_read_b64_tr_b16 v[52:53], v0 offset:42048
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_32x32x16_bf16 v[192:207], v[48:51], v[84:87], v[192:207]
		ds_read_b64_tr_b16 v[54:55], v0 offset:42176
		ds_read_b64_tr_b16 v[48:49], v0 offset:33536
		ds_read_b64_tr_b16 v[50:51], v0 offset:33664
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_32x32x16_bf16 v[208:223], v[52:55], v[84:87], v[208:223]
		ds_read_b64_tr_b16 v[52:53], v0 offset:33600
		ds_read_b64_tr_b16 v[54:55], v0 offset:33728
		ds_read_b64_tr_b16 v[60:61], v0 offset:42240
		ds_read_b64_tr_b16 v[62:63], v0 offset:42368
		ds_read_b64_tr_b16 v[64:65], v0 offset:42304
		ds_read_b64_tr_b16 v[66:67], v0 offset:42432
		ds_read_b64_tr_b16 v[68:69], v0 offset:33792
		ds_read_b64_tr_b16 v[70:71], v0 offset:33920
		ds_read_b64_tr_b16 v[72:73], v0 offset:33856
		ds_read_b64_tr_b16 v[74:75], v0 offset:33984
		ds_read_b64_tr_b16 v[76:77], v0 offset:42496
		ds_read_b64_tr_b16 v[78:79], v0 offset:42624
		ds_read_b64_tr_b16 v[80:81], v0 offset:42560
		ds_read_b64_tr_b16 v[82:83], v0 offset:42688
		ds_read_b64_tr_b16 v[84:85], v0 offset:34048
		ds_read_b64_tr_b16 v[86:87], v0 offset:34176
		ds_read_b64_tr_b16 v[96:97], v0 offset:34112
		ds_read_b64_tr_b16 v[98:99], v0 offset:34240
		ds_read_b64_tr_b16 v[100:101], v0 offset:42752
		ds_read_b64_tr_b16 v[102:103], v0 offset:42880
		ds_read_b64_tr_b16 v[104:105], v0 offset:42816
		ds_read_b64_tr_b16 v[106:107], v0 offset:42944
		v_max3_f32 v2, v224, v225, v226
		v_max3_f32 v2, v2, v227, v228
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[128:143], v[48:51], v[88:91], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[52:55], v[88:91], v[176:191]
		v_max3_f32 v2, v2, v229, v230
		v_max3_f32 v2, v2, v231, v232
		v_mfma_f32_32x32x16_bf16 v[192:207], v[60:63], v[88:91], v[192:207]
		v_max3_f32 v2, v2, v233, v234
		v_max3_f32 v2, v2, v235, v236
		v_mfma_f32_32x32x16_bf16 v[208:223], v[64:67], v[88:91], v[208:223]
		v_max3_f32 v2, v2, v237, v238
		v_max3_f32 v2, v2, v239, v240
		v_mfma_f32_32x32x16_bf16 v[128:143], v[68:71], v[92:95], v[128:143]
		v_max3_f32 v2, v2, v241, v242
		v_max3_f32 v2, v2, v243, v244
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_32x32x16_bf16 v[176:191], v[72:75], v[92:95], v[176:191]
		v_max3_f32 v2, v2, v245, v246
		v_max3_f32 v2, v2, v247, v248
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_32x32x16_bf16 v[192:207], v[76:79], v[92:95], v[192:207]
		v_max3_f32 v2, v2, v249, v250
		v_max3_f32 v2, v2, v251, v252
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_32x32x16_bf16 v[208:223], v[80:83], v[92:95], v[208:223]
		v_max3_f32 v2, v2, v253, v254
		v_max_f32_e32 v2, v2, v255
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_32x32x16_bf16 v[128:143], v[84:87], v[56:59], v[128:143]
		v_mov_b32_e32 v48, v2
		v_mov_b32_e32 v49, v2
		s_nop 1
		v_permlane32_swap_b32_e32 v48, v49
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_32x32x16_bf16 v[176:191], v[96:99], v[56:59], v[176:191]
		v_max_f32_e32 v2, v48, v49
		v_mul_f32_e32 v2, v2, v42
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_32x32x16_bf16 v[192:207], v[100:103], v[56:59], v[192:207]
		v_max_f32_e32 v6, v47, v2
		v_sub_f32_e32 v2, v6, v47
		v_cmp_le_f32_e64 vcc, v2, s1
		s_cmp_eq_u64 vcc, s[6:7]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_32x32x16_bf16 v[208:223], v[104:107], v[56:59], v[208:223]
		s_cbranch_scc0 .Lflash_attention_bf16_gfx950.if_else_6
		v_max_f32_e32 v6, v47, v47
		v_max_f32_e32 v2, v46, v46
		s_branch .Lflash_attention_bf16_gfx950.if_end_6
.Lflash_attention_bf16_gfx950.if_else_6:
		v_sub_f32_e32 v2, v47, v6
		v_exp_f32_e32 v48, v2
		s_nop 0
		v_mov_b32_e32 v49, v48
		v_pk_mul_f32 v[128:129], v[128:129], v[48:49]
		v_pk_mul_f32 v[130:131], v[130:131], v[48:49]
		v_pk_mul_f32 v[132:133], v[132:133], v[48:49]
		v_pk_mul_f32 v[134:135], v[134:135], v[48:49]
		v_pk_mul_f32 v[136:137], v[136:137], v[48:49]
		v_pk_mul_f32 v[138:139], v[138:139], v[48:49]
		v_pk_mul_f32 v[140:141], v[140:141], v[48:49]
		v_pk_mul_f32 v[142:143], v[142:143], v[48:49]
		v_pk_mul_f32 v[176:177], v[176:177], v[48:49]
		v_pk_mul_f32 v[178:179], v[178:179], v[48:49]
		v_pk_mul_f32 v[180:181], v[180:181], v[48:49]
		v_pk_mul_f32 v[182:183], v[182:183], v[48:49]
		v_pk_mul_f32 v[184:185], v[184:185], v[48:49]
		v_pk_mul_f32 v[186:187], v[186:187], v[48:49]
		v_pk_mul_f32 v[188:189], v[188:189], v[48:49]
		v_pk_mul_f32 v[190:191], v[190:191], v[48:49]
		v_pk_mul_f32 v[192:193], v[192:193], v[48:49]
		v_pk_mul_f32 v[194:195], v[194:195], v[48:49]
		v_pk_mul_f32 v[196:197], v[196:197], v[48:49]
		v_pk_mul_f32 v[198:199], v[198:199], v[48:49]
		v_pk_mul_f32 v[200:201], v[200:201], v[48:49]
		v_pk_mul_f32 v[202:203], v[202:203], v[48:49]
		v_pk_mul_f32 v[204:205], v[204:205], v[48:49]
		v_pk_mul_f32 v[206:207], v[206:207], v[48:49]
		v_pk_mul_f32 v[208:209], v[208:209], v[48:49]
		v_pk_mul_f32 v[210:211], v[210:211], v[48:49]
		v_pk_mul_f32 v[212:213], v[212:213], v[48:49]
		v_pk_mul_f32 v[214:215], v[214:215], v[48:49]
		v_pk_mul_f32 v[216:217], v[216:217], v[48:49]
		v_pk_mul_f32 v[218:219], v[218:219], v[48:49]
		v_pk_mul_f32 v[220:221], v[220:221], v[48:49]
		v_pk_mul_f32 v[222:223], v[222:223], v[48:49]
		v_mul_f32_e32 v2, v46, v48
		v_max_f32_e32 v6, v6, v6
.Lflash_attention_bf16_gfx950.if_end_6:
		v_sub_f32_e32 v46, v41, v6
		v_mov_b32_e32 v47, v46
		v_pk_fma_f32 v[48:49], v[224:225], v[42:43], v[46:47]
		v_pk_fma_f32 v[50:51], v[226:227], v[42:43], v[46:47]
		v_pk_fma_f32 v[52:53], v[228:229], v[42:43], v[46:47]
		v_pk_fma_f32 v[54:55], v[230:231], v[42:43], v[46:47]
		v_pk_fma_f32 v[56:57], v[232:233], v[42:43], v[46:47]
		v_pk_fma_f32 v[58:59], v[234:235], v[42:43], v[46:47]
		v_pk_fma_f32 v[60:61], v[236:237], v[42:43], v[46:47]
		v_pk_fma_f32 v[62:63], v[238:239], v[42:43], v[46:47]
		v_exp_f32_e32 v64, v48
		v_exp_f32_e32 v65, v49
		v_exp_f32_e32 v66, v50
		v_exp_f32_e32 v67, v51
		v_exp_f32_e32 v68, v52
		v_exp_f32_e32 v69, v53
		v_exp_f32_e32 v70, v54
		v_exp_f32_e32 v71, v55
		v_exp_f32_e32 v72, v56
		v_exp_f32_e32 v73, v57
		v_exp_f32_e32 v74, v58
		v_exp_f32_e32 v75, v59
		v_exp_f32_e32 v76, v60
		v_exp_f32_e32 v77, v61
		v_exp_f32_e32 v78, v62
		v_exp_f32_e32 v79, v63
		v_pk_fma_f32 v[48:49], v[240:241], v[42:43], v[46:47]
		v_pk_fma_f32 v[50:51], v[242:243], v[42:43], v[46:47]
		v_pk_fma_f32 v[52:53], v[244:245], v[42:43], v[46:47]
		v_pk_fma_f32 v[54:55], v[246:247], v[42:43], v[46:47]
		v_pk_fma_f32 v[56:57], v[248:249], v[42:43], v[46:47]
		v_pk_fma_f32 v[58:59], v[250:251], v[42:43], v[46:47]
		v_pk_fma_f32 v[60:61], v[252:253], v[42:43], v[46:47]
		v_pk_fma_f32 v[62:63], v[254:255], v[42:43], v[46:47]
		s_add_u32 s20, s20, 0x8000
		s_addc_u32 s21, s21, 0
		s_cmp_lt_i32 s5, 0x80
		s_cbranch_scc1 .Lflash_attention_bf16_gfx950.loop_head_1
.Lflash_attention_bf16_gfx950.loop_exit_1:
.Lflash_attention_bf16_gfx950.if_end_2:
		v_exp_f32_e32 v4, v48
		v_exp_f32_e32 v5, v49
		v_exp_f32_e32 v6, v50
		v_exp_f32_e32 v7, v51
		v_exp_f32_e32 v8, v52
		v_exp_f32_e32 v9, v53
		v_exp_f32_e32 v10, v54
		v_exp_f32_e32 v11, v55
		v_exp_f32_e32 v12, v56
		v_exp_f32_e32 v13, v57
		v_exp_f32_e32 v14, v58
		v_exp_f32_e32 v15, v59
		v_exp_f32_e32 v16, v60
		v_exp_f32_e32 v17, v61
		v_exp_f32_e32 v18, v62
		v_exp_f32_e32 v19, v63
		v_pk_add_f32 v[20:21], v[64:65], v[66:67]
		v_pk_add_f32 v[22:23], v[68:69], v[70:71]
		v_pk_add_f32 v[24:25], v[72:73], v[74:75]
		v_pk_add_f32 v[26:27], v[76:77], v[78:79]
		v_pk_add_f32 v[28:29], v[4:5], v[6:7]
		v_pk_add_f32 v[30:31], v[8:9], v[10:11]
		v_pk_add_f32 v[32:33], v[12:13], v[14:15]
		v_pk_add_f32 v[34:35], v[16:17], v[18:19]
		v_pk_add_f32 v[20:21], v[20:21], v[22:23]
		v_pk_add_f32 v[22:23], v[24:25], v[26:27]
		v_pk_add_f32 v[24:25], v[28:29], v[30:31]
		v_pk_add_f32 v[26:27], v[32:33], v[34:35]
		v_pk_add_f32 v[20:21], v[20:21], v[22:23]
		v_pk_add_f32 v[22:23], v[24:25], v[26:27]
		v_pk_add_f32 v[24:25], v[20:21], v[22:23]
		v_add_f32_e32 v3, v24, v25
		v_cvt_pk_bf16_f32 v20, v64, v65
		v_cvt_pk_bf16_f32 v21, v66, v67
		v_cvt_pk_bf16_f32 v22, v68, v69
		v_cvt_pk_bf16_f32 v23, v70, v71
		v_cvt_pk_bf16_f32 v24, v72, v73
		v_cvt_pk_bf16_f32 v25, v74, v75
		v_cvt_pk_bf16_f32 v26, v76, v77
		v_cvt_pk_bf16_f32 v27, v78, v79
		v_cvt_pk_bf16_f32 v28, v4, v5
		v_cvt_pk_bf16_f32 v29, v6, v7
		v_cvt_pk_bf16_f32 v30, v8, v9
		v_cvt_pk_bf16_f32 v31, v10, v11
		v_cvt_pk_bf16_f32 v4, v12, v13
		v_cvt_pk_bf16_f32 v5, v14, v15
		v_cvt_pk_bf16_f32 v6, v16, v17
		v_cvt_pk_bf16_f32 v7, v18, v19
		v_mov_b32_e32 v8, v3
		v_mov_b32_e32 v9, v3
		s_nop 1
		v_permlane32_swap_b32_e32 v8, v9
		v_add_f32_e32 v3, v8, v9
		v_add_f32_e32 v2, v2, v3
		s_waitcnt vmcnt(2)
		s_barrier
		ds_read_b64_tr_b16 v[8:9], v0 offset:50688
		ds_read_b64_tr_b16 v[10:11], v0 offset:50816
		ds_read_b64_tr_b16 v[12:13], v0 offset:50752
		ds_read_b64_tr_b16 v[14:15], v0 offset:50880
		ds_read_b64_tr_b16 v[16:17], v0 offset:59392
		ds_read_b64_tr_b16 v[18:19], v0 offset:59520
		ds_read_b64_tr_b16 v[32:33], v0 offset:59456
		ds_read_b64_tr_b16 v[34:35], v0 offset:59584
		ds_read_b64_tr_b16 v[36:37], v0 offset:50944
		ds_read_b64_tr_b16 v[38:39], v0 offset:51072
		ds_read_b64_tr_b16 v[40:41], v0 offset:51008
		ds_read_b64_tr_b16 v[42:43], v0 offset:51136
		ds_read_b64_tr_b16 v[44:45], v0 offset:59648
		ds_read_b64_tr_b16 v[46:47], v0 offset:59776
		ds_read_b64_tr_b16 v[48:49], v0 offset:59712
		ds_read_b64_tr_b16 v[50:51], v0 offset:59840
		ds_read_b64_tr_b16 v[52:53], v0 offset:51200
		ds_read_b64_tr_b16 v[54:55], v0 offset:51328
		ds_read_b64_tr_b16 v[56:57], v0 offset:51264
		ds_read_b64_tr_b16 v[58:59], v0 offset:51392
		ds_read_b64_tr_b16 v[60:61], v0 offset:59904
		ds_read_b64_tr_b16 v[62:63], v0 offset:60032
		ds_read_b64_tr_b16 v[64:65], v0 offset:59968
		ds_read_b64_tr_b16 v[66:67], v0 offset:60096
		ds_read_b64_tr_b16 v[68:69], v0 offset:51456
		ds_read_b64_tr_b16 v[70:71], v0 offset:51584
		ds_read_b64_tr_b16 v[72:73], v0 offset:51520
		ds_read_b64_tr_b16 v[74:75], v0 offset:51648
		ds_read_b64_tr_b16 v[76:77], v0 offset:60160
		ds_read_b64_tr_b16 v[78:79], v0 offset:60288
		ds_read_b64_tr_b16 v[80:81], v0 offset:60224
		ds_read_b64_tr_b16 v[82:83], v0 offset:60352
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[128:143], v[8:11], v[20:23], v[128:143]
		s_cmp_lt_u32 s0, 0x100
		v_mfma_f32_32x32x16_bf16 v[176:191], v[12:15], v[20:23], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[16:19], v[20:23], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[32:35], v[20:23], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[128:143], v[36:39], v[24:27], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[40:43], v[24:27], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[44:47], v[24:27], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[48:51], v[24:27], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[128:143], v[52:55], v[28:31], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[56:59], v[28:31], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[60:63], v[28:31], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[64:67], v[28:31], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[128:143], v[68:71], v[4:7], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[72:75], v[4:7], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[76:79], v[4:7], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[80:83], v[4:7], v[208:223]
		s_cbranch_scc0 .Lflash_attention_bf16_gfx950.if_end_7
		s_barrier
.Lflash_attention_bf16_gfx950.if_end_7:
		s_setprio 0
		v_rcp_f32_e32 v4, v2
		s_nop 0
		v_mov_b32_e32 v5, v4
		s_nop 3
		v_pk_mul_f32 v[2:3], v[128:129], v[4:5]
		v_pk_mul_f32 v[6:7], v[130:131], v[4:5]
		v_pk_mul_f32 v[8:9], v[132:133], v[4:5]
		v_pk_mul_f32 v[10:11], v[134:135], v[4:5]
		v_pk_mul_f32 v[12:13], v[136:137], v[4:5]
		v_pk_mul_f32 v[14:15], v[138:139], v[4:5]
		v_pk_mul_f32 v[16:17], v[140:141], v[4:5]
		v_pk_mul_f32 v[18:19], v[142:143], v[4:5]
		v_cvt_pk_bf16_f32 v20, v2, v3
		v_cvt_pk_bf16_f32 v21, v6, v7
		v_cvt_pk_bf16_f32 v22, v8, v9
		v_cvt_pk_bf16_f32 v23, v10, v11
		v_cvt_pk_bf16_f32 v8, v12, v13
		v_cvt_pk_bf16_f32 v9, v14, v15
		v_cvt_pk_bf16_f32 v10, v16, v17
		v_cvt_pk_bf16_f32 v11, v18, v19
		v_pk_mul_f32 v[2:3], v[176:177], v[4:5]
		v_pk_mul_f32 v[6:7], v[178:179], v[4:5]
		v_pk_mul_f32 v[12:13], v[180:181], v[4:5]
		v_pk_mul_f32 v[14:15], v[182:183], v[4:5]
		v_pk_mul_f32 v[16:17], v[184:185], v[4:5]
		v_pk_mul_f32 v[18:19], v[186:187], v[4:5]
		v_pk_mul_f32 v[24:25], v[188:189], v[4:5]
		v_pk_mul_f32 v[26:27], v[190:191], v[4:5]
		v_cvt_pk_bf16_f32 v28, v2, v3
		v_cvt_pk_bf16_f32 v29, v6, v7
		v_cvt_pk_bf16_f32 v30, v12, v13
		v_cvt_pk_bf16_f32 v31, v14, v15
		v_cvt_pk_bf16_f32 v12, v16, v17
		v_cvt_pk_bf16_f32 v13, v18, v19
		v_cvt_pk_bf16_f32 v14, v24, v25
		v_cvt_pk_bf16_f32 v15, v26, v27
		v_pk_mul_f32 v[2:3], v[192:193], v[4:5]
		v_pk_mul_f32 v[6:7], v[194:195], v[4:5]
		v_pk_mul_f32 v[16:17], v[196:197], v[4:5]
		v_pk_mul_f32 v[18:19], v[198:199], v[4:5]
		v_pk_mul_f32 v[24:25], v[200:201], v[4:5]
		v_pk_mul_f32 v[26:27], v[202:203], v[4:5]
		v_pk_mul_f32 v[32:33], v[204:205], v[4:5]
		v_pk_mul_f32 v[34:35], v[206:207], v[4:5]
		v_cvt_pk_bf16_f32 v36, v2, v3
		v_cvt_pk_bf16_f32 v37, v6, v7
		v_cvt_pk_bf16_f32 v38, v16, v17
		v_cvt_pk_bf16_f32 v39, v18, v19
		v_cvt_pk_bf16_f32 v16, v24, v25
		v_cvt_pk_bf16_f32 v17, v26, v27
		v_cvt_pk_bf16_f32 v18, v32, v33
		v_cvt_pk_bf16_f32 v19, v34, v35
		v_pk_mul_f32 v[2:3], v[208:209], v[4:5]
		v_pk_mul_f32 v[6:7], v[210:211], v[4:5]
		v_pk_mul_f32 v[24:25], v[212:213], v[4:5]
		v_pk_mul_f32 v[26:27], v[214:215], v[4:5]
		v_pk_mul_f32 v[32:33], v[216:217], v[4:5]
		v_pk_mul_f32 v[34:35], v[218:219], v[4:5]
		v_pk_mul_f32 v[40:41], v[220:221], v[4:5]
		v_pk_mul_f32 v[42:43], v[222:223], v[4:5]
		v_cvt_pk_bf16_f32 v44, v2, v3
		v_cvt_pk_bf16_f32 v45, v6, v7
		v_cvt_pk_bf16_f32 v46, v24, v25
		v_cvt_pk_bf16_f32 v47, v26, v27
		v_cvt_pk_bf16_f32 v4, v32, v33
		v_cvt_pk_bf16_f32 v5, v34, v35
		v_cvt_pk_bf16_f32 v6, v40, v41
		v_cvt_pk_bf16_f32 v7, v42, v43
		v_permlane32_swap_b32_e32 v20, v22
		v_permlane32_swap_b32_e32 v21, v23
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_permlane32_swap_b32_e32 v12, v14
		v_permlane32_swap_b32_e32 v13, v15
		v_permlane32_swap_b32_e32 v36, v38
		v_permlane32_swap_b32_e32 v37, v39
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v44, v46
		v_permlane32_swap_b32_e32 v45, v47
		v_permlane32_swap_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v5, v7
		s_mov_b32 s14, s18
		s_mov_b32 s15, s19
		buffer_store_dwordx4 v[20:23], v1, s[12:15], s2 offen
		buffer_store_dwordx4 v[8:11], v1, s[12:15], s2 offen offset:32
		buffer_store_dwordx4 v[28:31], v1, s[12:15], s2 offen offset:64
		buffer_store_dwordx4 v[12:15], v1, s[12:15], s2 offen offset:96
		buffer_store_dwordx4 v[36:39], v1, s[12:15], s2 offen offset:128
		buffer_store_dwordx4 v[16:19], v1, s[12:15], s2 offen offset:160
		buffer_store_dwordx4 v[44:47], v1, s[12:15], s2 offen offset:192
		buffer_store_dwordx4 v[4:7], v1, s[12:15], s2 offen offset:224
		s_endpgm
	.size	flash_attention_bf16_gfx950, .-flash_attention_bf16_gfx950
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel flash_attention_bf16_gfx950
		.amdhsa_group_segment_fixed_size 0
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 32
		.amdhsa_user_sgpr_count 10
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_user_sgpr_kernarg_preload_length 8
		.amdhsa_user_sgpr_kernarg_preload_offset 0
		.amdhsa_enable_private_segment 0
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 1
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 256
		.amdhsa_next_free_sgpr 24
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
	.set .Lflash_attention_bf16_gfx950.num_vgpr, 256
	.set .Lflash_attention_bf16_gfx950.num_agpr, 0
	.set .Lflash_attention_bf16_gfx950.numbered_sgpr, 24
	.set .Lflash_attention_bf16_gfx950.num_named_barrier, 0
	.set .Lflash_attention_bf16_gfx950.private_seg_size, 0
	.set .Lflash_attention_bf16_gfx950.uses_vcc, 1
	.set .Lflash_attention_bf16_gfx950.uses_flat_scratch, 0
	.set .Lflash_attention_bf16_gfx950.has_dyn_sized_stack, 0
	.set .Lflash_attention_bf16_gfx950.has_recursion, 0
	.set .Lflash_attention_bf16_gfx950.has_indirect_call, 0
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
    .group_segment_fixed_size: 0
    .kernarg_segment_align: 8
    .kernarg_segment_size: 32
    .max_flat_workgroup_size: 512
    .name:           flash_attention_bf16_gfx950
    .private_segment_fixed_size: 0
    .sgpr_count:     24
    .sgpr_spill_count: 0
    .symbol:         flash_attention_bf16_gfx950.kd
    .uses_dynamic_stack: false
    .vgpr_count:     256
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
