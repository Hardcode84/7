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
		s_mov_b32 s4, s20
		s_mov_b32 s5, s21
		s_mov_b32 s6, s18
		s_mov_b32 s7, s19
		v_lshrrev_b32_e32 v1, 6, v0
		v_and_b32_e32 v2, 63, v0
		v_lshrrev_b32_e32 v3, 5, v2
		v_lshlrev_b32_e32 v4, 4, v3
		v_lshl_add_u32 v1, v1, 13, v4
		v_and_b32_e32 v5, 31, v2
		v_lshl_add_u32 v1, v5, 8, v1
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
		s_mul_i32 s10, 0x410, s3
		s_mov_b32 m0, s10
		v_lshrrev_b32_e32 v6, 3, v2
		v_lshlrev_b32_e32 v6, 11, v6
		v_lshl_add_u32 v6, s3, 8, v6
		v_and_b32_e32 v7, 7, v2
		v_lshl_add_u32 v6, v7, 4, v6
		buffer_load_dwordx4 v6, s[16:19], 0 offen lds
		v_lshrrev_b32_e32 v7, 4, v2
		s_add_i32 m0, m0, 0x2080
		s_mov_b32 s11, 0x80
		buffer_load_dwordx4 v6, s[16:19], s11 offen lds
		v_mov_b32_e32 v40, 0x3e0293ee
		s_add_i32 m0, m0, 0x2080
		s_mov_b32 s12, 0x4000
		buffer_load_dwordx4 v6, s[16:19], s12 offen lds
		v_mov_b32_e32 v42, 0
		s_add_i32 m0, m0, 0x2080
		s_mov_b32 s13, 0x4080
		buffer_load_dwordx4 v6, s[16:19], s13 offen lds
		s_mul_i32 s3, 0x440, s3
		s_add_i32 m0, s3, 0x10400
		s_add_u32 s24, s8, s1
		s_addc_u32 s25, s9, 0
		buffer_load_dwordx4 v6, s[4:7], 0 offen lds
		v_and_b32_e32 v41, 7, v5
		s_add_i32 m0, m0, 0x2200
		v_and_b32_e32 v0, 7, v0
		buffer_load_dwordx4 v6, s[4:7], s11 offen lds
		v_lshrrev_b32_e32 v5, 3, v5
		s_waitcnt vmcnt(0)
		s_barrier
		v_lshl_add_u32 v4, v5, 7, v4
		v_mov_b32_e32 v5, 0x410
		v_mul_lo_u32 v5, v5, v41
		v_add_u32_e32 v5, v4, v5
		ds_read_b128 v[44:47], v5
		v_mov_b32_e32 v41, 0x410
		v_mul_lo_u32 v41, v41, v0
		v_add_u32_e32 v0, v4, v41
		ds_read_b128 v[48:51], v0 offset:512
		ds_read_b128 v[52:55], v5 offset:32
		ds_read_b128 v[56:59], v0 offset:544
		ds_read_b128 v[60:63], v5 offset:64
		ds_read_b128 v[64:67], v0 offset:576
		ds_read_b128 v[68:71], v5 offset:96
		ds_read_b128 v[72:75], v0 offset:608
		ds_read_b128 v[76:79], v5 offset:8320
		ds_read_b128 v[80:83], v0 offset:8832
		ds_read_b128 v[84:87], v5 offset:8352
		ds_read_b128 v[88:91], v0 offset:8864
		ds_read_b128 v[92:95], v5 offset:8384
		ds_read_b128 v[96:99], v0 offset:8896
		ds_read_b128 v[100:103], v5 offset:8416
		ds_read_b128 v[104:107], v0 offset:8928
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
		v_mov_b32_e32 v41, 0x3e0293ee
		s_add_i32 m0, s10, 0x8200
		s_mov_b32 s1, 0x8000
		buffer_load_dwordx4 v6, s[16:19], s1 offen lds
		v_mov_b32_e32 v4, 0x418293ee
		s_add_i32 m0, m0, 0x2080
		s_mov_b32 s1, 0x8080
		buffer_load_dwordx4 v6, s[16:19], s1 offen lds
		v_sub_f32_e32 v44, v42, v4
		v_mov_b32_e32 v45, v44
		v_pk_fma_f32 v[46:47], v[114:115], v[40:41], v[44:45]
		v_pk_fma_f32 v[48:49], v[116:117], v[40:41], v[44:45]
		v_pk_fma_f32 v[50:51], v[118:119], v[40:41], v[44:45]
		v_pk_fma_f32 v[52:53], v[120:121], v[40:41], v[44:45]
		v_pk_fma_f32 v[54:55], v[122:123], v[40:41], v[44:45]
		v_pk_fma_f32 v[56:57], v[124:125], v[40:41], v[44:45]
		v_pk_fma_f32 v[58:59], v[126:127], v[40:41], v[44:45]
		v_exp_f32_e32 v4, v48
		v_exp_f32_e32 v43, v49
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
		v_pk_fma_f32 v[58:59], v[128:129], v[40:41], v[44:45]
		v_pk_fma_f32 v[60:61], v[130:131], v[40:41], v[44:45]
		v_pk_fma_f32 v[62:63], v[132:133], v[40:41], v[44:45]
		v_pk_fma_f32 v[64:65], v[134:135], v[40:41], v[44:45]
		v_pk_fma_f32 v[66:67], v[136:137], v[40:41], v[44:45]
		v_pk_fma_f32 v[68:69], v[138:139], v[40:41], v[44:45]
		v_pk_fma_f32 v[70:71], v[140:141], v[40:41], v[44:45]
		v_pk_fma_f32 v[72:73], v[142:143], v[40:41], v[44:45]
		v_exp_f32_e32 v58, v58
		v_exp_f32_e32 v59, v59
		v_exp_f32_e32 v60, v60
		v_exp_f32_e32 v61, v61
		v_exp_f32_e32 v62, v62
		s_cmp_ge_u32 s0, 0x100
		s_cbranch_scc0 .Lflash_attention_bf16_gfx950.if_end_0
		s_barrier
		s_setprio 3
.Lflash_attention_bf16_gfx950.if_end_0:
		s_add_i32 m0, s3, 0x14800
		v_pk_fma_f32 v[74:75], v[112:113], v[40:41], v[44:45]
		buffer_load_dwordx4 v6, s[4:7], s12 offen lds
		v_exp_f32_e32 v74, v74
		v_exp_f32_e32 v75, v75
		s_add_i32 m0, m0, 0x2200
		v_exp_f32_e32 v47, v47
		buffer_load_dwordx4 v6, s[4:7], s13 offen lds
		v_exp_f32_e32 v46, v46
		s_barrier
		ds_read_b128 v[76:79], v5 offset:16640
		ds_read_b128 v[80:83], v0 offset:17152
		ds_read_b128 v[84:87], v5 offset:16672
		ds_read_b128 v[88:91], v0 offset:17184
		ds_read_b128 v[92:95], v5 offset:16704
		ds_read_b128 v[96:99], v0 offset:17216
		ds_read_b128 v[100:103], v5 offset:16736
		ds_read_b128 v[104:107], v0 offset:17248
		ds_read_b128 v[108:111], v5 offset:24960
		ds_read_b128 v[112:115], v0 offset:25472
		ds_read_b128 v[116:119], v5 offset:24992
		ds_read_b128 v[120:123], v0 offset:25504
		ds_read_b128 v[124:127], v5 offset:25024
		ds_read_b128 v[128:131], v0 offset:25536
		ds_read_b128 v[132:135], v5 offset:25056
		ds_read_b128 v[136:139], v0 offset:25568
		v_exp_f32_e32 v63, v63
		v_exp_f32_e32 v64, v64
		v_exp_f32_e32 v65, v65
		v_exp_f32_e32 v66, v66
		v_exp_f32_e32 v67, v67
		v_exp_f32_e32 v68, v68
		v_exp_f32_e32 v69, v69
		v_exp_f32_e32 v70, v70
		v_exp_f32_e32 v71, v71
		v_exp_f32_e32 v72, v72
		v_exp_f32_e32 v73, v73
		v_add_f32_e32 v140, v74, v75
		v_add_f32_e32 v140, v140, v46
		v_add_f32_e32 v140, v140, v47
		v_add_f32_e32 v140, v140, v4
		v_add_f32_e32 v140, v140, v43
		v_add_f32_e32 v140, v140, v48
		v_add_f32_e32 v140, v140, v49
		v_cvt_pk_bf16_f32 v147, v48, v49
		v_add_f32_e32 v48, v140, v50
		v_add_f32_e32 v48, v48, v51
		v_cvt_pk_bf16_f32 v140, v50, v51
		v_add_f32_e32 v48, v48, v52
		v_add_f32_e32 v48, v48, v53
		v_cvt_pk_bf16_f32 v141, v52, v53
		v_add_f32_e32 v48, v48, v54
		v_add_f32_e32 v48, v48, v55
		v_cvt_pk_bf16_f32 v142, v54, v55
		v_add_f32_e32 v48, v48, v56
		v_add_f32_e32 v48, v48, v57
		v_cvt_pk_bf16_f32 v143, v56, v57
		v_add_f32_e32 v48, v48, v58
		v_add_f32_e32 v48, v48, v59
		v_cvt_pk_bf16_f32 v52, v58, v59
		v_add_f32_e32 v48, v48, v60
		v_add_f32_e32 v48, v48, v61
		v_cvt_pk_bf16_f32 v53, v60, v61
		v_add_f32_e32 v48, v48, v62
		v_add_f32_e32 v48, v48, v63
		v_cvt_pk_bf16_f32 v54, v62, v63
		v_add_f32_e32 v48, v48, v64
		v_add_f32_e32 v48, v48, v65
		v_cvt_pk_bf16_f32 v55, v64, v65
		v_add_f32_e32 v48, v48, v66
		v_add_f32_e32 v48, v48, v67
		v_cvt_pk_bf16_f32 v56, v66, v67
		v_add_f32_e32 v48, v48, v68
		v_add_f32_e32 v48, v48, v69
		v_cvt_pk_bf16_f32 v57, v68, v69
		v_add_f32_e32 v48, v48, v70
		v_add_f32_e32 v48, v48, v71
		v_cvt_pk_bf16_f32 v58, v70, v71
		v_add_f32_e32 v48, v48, v72
		v_add_f32_e32 v50, v48, v73
		v_cvt_pk_bf16_f32 v59, v72, v73
		v_mov_b32_e32 v51, v50
		v_cvt_pk_bf16_f32 v144, v74, v75
		v_cvt_pk_bf16_f32 v145, v46, v47
		v_permlane32_swap_b32_e32 v50, v51
		v_add_f32_e32 v46, v50, v51
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_f32_e32 v47, v42, v46
		s_add_i32 m0, s10, 0xc300
		s_mov_b32 s1, 0xc000
		buffer_load_dwordx4 v6, s[16:19], s1 offen lds
		s_mov_b32 s1, 0xc080
		s_add_i32 m0, m0, 0x2080
		v_cvt_pk_bf16_f32 v146, v4, v43
		buffer_load_dwordx4 v6, s[16:19], s1 offen lds
		v_mfma_f32_32x32x16_bf16 v[160:175], v[76:79], v[8:11], 0
		v_mfma_f32_32x32x16_bf16 v[64:79], v[80:83], v[8:11], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[84:87], v[12:15], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[64:79], v[88:91], v[12:15], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[92:95], v[16:19], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[64:79], v[96:99], v[16:19], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[100:103], v[20:23], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[64:79], v[104:107], v[20:23], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[108:111], v[24:27], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[64:79], v[112:115], v[24:27], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[116:119], v[28:31], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[64:79], v[120:123], v[28:31], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[124:127], v[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[64:79], v[128:131], v[32:35], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[132:135], v[36:39], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[64:79], v[136:139], v[36:39], v[64:79]
		s_waitcnt vmcnt(4)
		s_barrier
		v_mov_b32_e32 v4, 0x1100
		v_mul_lo_u32 v4, v4, v3
		v_add_u32_e32 v3, 0x10000, v4
		v_and_b32_e32 v4, 15, v2
		v_lshrrev_b32_e32 v4, 2, v4
		v_mov_b32_e32 v42, 0x440
		v_mul_lo_u32 v42, v42, v4
		v_add_u32_e32 v3, v3, v42
		v_and_b32_e32 v4, 1, v7
		v_lshl_add_u32 v3, v4, 5, v3
		v_and_b32_e32 v2, 3, v2
		v_lshl_add_u32 v2, v2, 3, v3
		ds_read_b64_tr_b16 v[48:49], v2 offset:1024
		ds_read_b64_tr_b16 v[50:51], v2 offset:1152
		ds_read_b64_tr_b16 v[60:61], v2 offset:1088
		ds_read_b64_tr_b16 v[62:63], v2 offset:1216
		ds_read_b64_tr_b16 v[80:81], v2 offset:9728
		ds_read_b64_tr_b16 v[82:83], v2 offset:9856
		ds_read_b64_tr_b16 v[84:85], v2 offset:9792
		ds_read_b64_tr_b16 v[86:87], v2 offset:9920
		ds_read_b64_tr_b16 v[88:89], v2 offset:1280
		ds_read_b64_tr_b16 v[90:91], v2 offset:1408
		ds_read_b64_tr_b16 v[92:93], v2 offset:1344
		ds_read_b64_tr_b16 v[94:95], v2 offset:1472
		ds_read_b64_tr_b16 v[96:97], v2 offset:9984
		ds_read_b64_tr_b16 v[98:99], v2 offset:10112
		ds_read_b64_tr_b16 v[100:101], v2 offset:10048
		ds_read_b64_tr_b16 v[102:103], v2 offset:10176
		ds_read_b64_tr_b16 v[104:105], v2 offset:1536
		ds_read_b64_tr_b16 v[106:107], v2 offset:1664
		ds_read_b64_tr_b16 v[108:109], v2 offset:1600
		ds_read_b64_tr_b16 v[110:111], v2 offset:1728
		ds_read_b64_tr_b16 v[112:113], v2 offset:10240
		ds_read_b64_tr_b16 v[114:115], v2 offset:10368
		ds_read_b64_tr_b16 v[116:117], v2 offset:10304
		ds_read_b64_tr_b16 v[118:119], v2 offset:10432
		ds_read_b64_tr_b16 v[120:121], v2 offset:1792
		ds_read_b64_tr_b16 v[122:123], v2 offset:1920
		ds_read_b64_tr_b16 v[124:125], v2 offset:1856
		ds_read_b64_tr_b16 v[126:127], v2 offset:1984
		ds_read_b64_tr_b16 v[128:129], v2 offset:10496
		ds_read_b64_tr_b16 v[130:131], v2 offset:10624
		ds_read_b64_tr_b16 v[132:133], v2 offset:10560
		ds_read_b64_tr_b16 v[134:135], v2 offset:10688
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[176:191], v[48:51], v[144:147], 0
		v_mfma_f32_32x32x16_bf16 v[192:207], v[60:63], v[144:147], 0
		v_mfma_f32_32x32x16_bf16 v[208:223], v[80:83], v[144:147], 0
		v_mfma_f32_32x32x16_bf16 v[176:191], v[88:91], v[140:143], v[176:191]
		s_mov_b32 s1, 2
		v_mfma_f32_32x32x16_bf16 v[192:207], v[92:95], v[140:143], v[192:207]
		s_lshr_b32 s8, s0, 8
		v_mfma_f32_32x32x16_bf16 v[208:223], v[96:99], v[140:143], v[208:223]
		s_and_b32 s8, s8, 1
		v_mfma_f32_32x32x16_bf16 v[176:191], v[104:107], v[52:55], v[176:191]
		s_cmp_eq_u32 s8, 0
		v_mfma_f32_32x32x16_bf16 v[192:207], v[108:111], v[52:55], v[192:207]
		v_add_u32_e32 v3, 0x8000, v6
		v_mfma_f32_32x32x16_bf16 v[208:223], v[112:115], v[52:55], v[208:223]
		v_add_u32_e32 v4, 0x8080, v6
		v_mfma_f32_32x32x16_bf16 v[176:191], v[120:123], v[56:59], v[176:191]
		v_add_u32_e32 v7, 0xc000, v6
		v_mfma_f32_32x32x16_bf16 v[192:207], v[124:127], v[56:59], v[192:207]
		v_add_u32_e32 v42, 0xc080, v6
		v_mfma_f32_32x32x16_bf16 v[208:223], v[128:131], v[56:59], v[208:223]
		v_add_u32_e32 v43, 0x10000, v6
		v_mfma_f32_32x32x16_bf16 v[224:239], v[84:87], v[144:147], 0
		v_add_u32_e32 v46, 0x10080, v6
		v_mfma_f32_32x32x16_bf16 v[224:239], v[100:103], v[140:143], v[224:239]
		v_add_u32_e32 v48, 0x14000, v6
		v_mfma_f32_32x32x16_bf16 v[224:239], v[116:119], v[52:55], v[224:239]
		v_add_u32_e32 v49, 0x14080, v6
		v_mfma_f32_32x32x16_bf16 v[224:239], v[132:135], v[56:59], v[224:239]
		v_fma_f32 v50, v160, v40, v44
		v_fma_f32 v51, v161, v40, v44
		v_fma_f32 v52, v162, v40, v44
		v_fma_f32 v53, v163, v40, v44
		v_fma_f32 v54, v164, v40, v44
		v_fma_f32 v55, v165, v40, v44
		v_pk_fma_f32 v[56:57], v[166:167], v[40:41], v[44:45]
		v_pk_fma_f32 v[58:59], v[168:169], v[40:41], v[44:45]
		v_pk_fma_f32 v[60:61], v[170:171], v[40:41], v[44:45]
		v_pk_fma_f32 v[62:63], v[172:173], v[40:41], v[44:45]
		v_pk_fma_f32 v[80:81], v[174:175], v[40:41], v[44:45]
		v_exp_f32_e32 v96, v50
		v_exp_f32_e32 v97, v51
		v_exp_f32_e32 v98, v52
		v_exp_f32_e32 v99, v53
		v_exp_f32_e32 v100, v54
		v_exp_f32_e32 v101, v55
		v_exp_f32_e32 v102, v56
		v_exp_f32_e32 v103, v57
		v_exp_f32_e32 v104, v58
		v_exp_f32_e32 v105, v59
		v_exp_f32_e32 v106, v60
		v_exp_f32_e32 v107, v61
		v_exp_f32_e32 v108, v62
		v_exp_f32_e32 v109, v63
		v_exp_f32_e32 v110, v80
		v_exp_f32_e32 v111, v81
		v_pk_fma_f32 v[50:51], v[64:65], v[40:41], v[44:45]
		v_pk_fma_f32 v[52:53], v[66:67], v[40:41], v[44:45]
		v_pk_fma_f32 v[54:55], v[68:69], v[40:41], v[44:45]
		v_pk_fma_f32 v[86:87], v[70:71], v[40:41], v[44:45]
		v_pk_fma_f32 v[88:89], v[72:73], v[40:41], v[44:45]
		v_pk_fma_f32 v[90:91], v[74:75], v[40:41], v[44:45]
		v_pk_fma_f32 v[92:93], v[76:77], v[40:41], v[44:45]
		v_pk_fma_f32 v[94:95], v[78:79], v[40:41], v[44:45]
		v_exp_f32_e32 v80, v50
		v_exp_f32_e32 v81, v51
		v_exp_f32_e32 v82, v52
		v_exp_f32_e32 v83, v53
		v_exp_f32_e32 v84, v54
		v_mov_b32_e32 v85, v55
		s_cbranch_scc0 .Lflash_attention_bf16_gfx950.if_else_1
		s_mov_b32 s20, s4
		s_mov_b32 s21, s5
		s_mov_b32 s22, s6
		s_mov_b32 s23, s7
.Lflash_attention_bf16_gfx950.loop_head_0:
		s_add_i32 s8, s1, 2
		s_add_i32 s9, s1, 3
		s_add_i32 s11, s1, 5
		s_add_i32 s1, s1, 4
		s_cmp_lt_u32 s8, 0x80
		s_cselect_b32 s8, s8, 0x7f
		s_cmp_lt_u32 s9, 0x80
		s_cselect_b32 s9, s9, 0x7f
		s_cmp_lt_u32 s1, 0x80
		s_cselect_b32 s12, s1, 0x7f
		s_cmp_lt_u32 s11, 0x80
		s_cselect_b32 s11, s11, 0x7f
		s_add_i32 m0, s3, 0x18c00
		s_lshl_b32 s12, s12, 14
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		s_lshl_b32 s9, s9, 14
		s_add_i32 m0, m0, 0x2200
		s_lshl_b32 s8, s8, 14
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		s_waitcnt vmcnt(4)
		s_barrier
		ds_read_b128 v[52:55], v5 offset:33280
		ds_read_b128 v[56:59], v0 offset:33792
		ds_read_b128 v[60:63], v5 offset:33312
		ds_read_b128 v[64:67], v0 offset:33824
		ds_read_b128 v[68:71], v5 offset:33344
		ds_read_b128 v[72:75], v0 offset:33856
		ds_read_b128 v[76:79], v5 offset:33376
		ds_read_b128 v[112:115], v0 offset:33888
		ds_read_b128 v[116:119], v5 offset:41600
		ds_read_b128 v[120:123], v0 offset:42112
		ds_read_b128 v[124:127], v5 offset:41632
		ds_read_b128 v[128:131], v0 offset:42144
		ds_read_b128 v[132:135], v5 offset:41664
		ds_read_b128 v[136:139], v0 offset:42176
		ds_read_b128 v[140:143], v5 offset:41696
		ds_read_b128 v[144:147], v0 offset:42208
		v_exp_f32_e32 v50, v85
		v_exp_f32_e32 v51, v86
		v_exp_f32_e32 v85, v87
		v_exp_f32_e32 v86, v88
		v_exp_f32_e32 v87, v89
		v_exp_f32_e32 v88, v90
		v_exp_f32_e32 v89, v91
		v_exp_f32_e32 v90, v92
		v_exp_f32_e32 v91, v93
		v_exp_f32_e32 v92, v94
		v_exp_f32_e32 v93, v95
		v_add_f32_e32 v94, v96, v97
		v_add_f32_e32 v94, v94, v98
		v_add_f32_e32 v94, v94, v99
		v_add_f32_e32 v94, v94, v100
		v_add_f32_e32 v94, v94, v101
		v_add_f32_e32 v94, v94, v102
		v_add_f32_e32 v94, v94, v103
		v_add_f32_e32 v94, v94, v104
		v_add_f32_e32 v94, v94, v105
		v_cvt_pk_bf16_f32 v148, v104, v105
		v_add_f32_e32 v94, v94, v106
		v_add_f32_e32 v94, v94, v107
		v_cvt_pk_bf16_f32 v149, v106, v107
		v_add_f32_e32 v94, v94, v108
		v_add_f32_e32 v94, v94, v109
		v_cvt_pk_bf16_f32 v150, v108, v109
		v_add_f32_e32 v94, v94, v110
		v_add_f32_e32 v94, v94, v111
		v_cvt_pk_bf16_f32 v151, v110, v111
		v_add_f32_e32 v94, v94, v80
		v_add_f32_e32 v94, v94, v81
		v_cvt_pk_bf16_f32 v104, v80, v81
		v_add_f32_e32 v80, v94, v82
		v_add_f32_e32 v80, v80, v83
		v_cvt_pk_bf16_f32 v105, v82, v83
		v_add_f32_e32 v80, v80, v84
		v_add_f32_e32 v80, v80, v50
		v_cvt_pk_bf16_f32 v106, v84, v50
		v_add_f32_e32 v50, v80, v51
		v_add_f32_e32 v50, v50, v85
		v_cvt_pk_bf16_f32 v107, v51, v85
		v_add_f32_e32 v50, v50, v86
		v_add_f32_e32 v50, v50, v87
		v_cvt_pk_bf16_f32 v80, v86, v87
		v_add_f32_e32 v50, v50, v88
		v_add_f32_e32 v50, v50, v89
		v_cvt_pk_bf16_f32 v81, v88, v89
		v_add_f32_e32 v50, v50, v90
		v_add_f32_e32 v50, v50, v91
		v_cvt_pk_bf16_f32 v82, v90, v91
		v_add_f32_e32 v50, v50, v92
		v_add_f32_e32 v84, v50, v93
		v_cvt_pk_bf16_f32 v83, v92, v93
		v_mov_b32_e32 v85, v84
		v_cvt_pk_bf16_f32 v88, v96, v97
		v_cvt_pk_bf16_f32 v89, v98, v99
		v_permlane32_swap_b32_e32 v84, v85
		v_add_f32_e32 v50, v84, v85
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v51, s8, v6
		s_mov_b32 m0, s10
		v_cvt_pk_bf16_f32 v90, v100, v101
		buffer_load_dwordx4 v51, s[16:19], 0 offen lds
		v_cvt_pk_bf16_f32 v91, v102, v103
		s_add_i32 m0, m0, 0x2080
		s_add_i32 s8, s8, 0x80
		v_add_u32_e32 v51, s8, v6
		buffer_load_dwordx4 v51, s[16:19], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[160:175], v[52:55], v[8:11], 0
		v_mfma_f32_32x32x16_bf16 v[240:255], v[56:59], v[8:11], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[60:63], v[12:15], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[64:67], v[12:15], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[68:71], v[16:19], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[72:75], v[16:19], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[76:79], v[20:23], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[112:115], v[20:23], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[116:119], v[24:27], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[120:123], v[24:27], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[124:127], v[28:31], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[128:131], v[28:31], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[132:135], v[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[136:139], v[32:35], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[140:143], v[36:39], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[144:147], v[36:39], v[240:255]
		s_waitcnt vmcnt(4)
		s_barrier
		ds_read_b64_tr_b16 v[52:53], v2 offset:18432
		ds_read_b64_tr_b16 v[54:55], v2 offset:18560
		ds_read_b64_tr_b16 v[56:57], v2 offset:18496
		ds_read_b64_tr_b16 v[58:59], v2 offset:18624
		ds_read_b64_tr_b16 v[60:61], v2 offset:27136
		ds_read_b64_tr_b16 v[62:63], v2 offset:27264
		ds_read_b64_tr_b16 v[64:65], v2 offset:27200
		ds_read_b64_tr_b16 v[66:67], v2 offset:27328
		ds_read_b64_tr_b16 v[68:69], v2 offset:18688
		ds_read_b64_tr_b16 v[70:71], v2 offset:18816
		ds_read_b64_tr_b16 v[72:73], v2 offset:18752
		ds_read_b64_tr_b16 v[74:75], v2 offset:18880
		ds_read_b64_tr_b16 v[76:77], v2 offset:27392
		ds_read_b64_tr_b16 v[78:79], v2 offset:27520
		ds_read_b64_tr_b16 v[84:85], v2 offset:27456
		ds_read_b64_tr_b16 v[86:87], v2 offset:27584
		ds_read_b64_tr_b16 v[92:93], v2 offset:18944
		ds_read_b64_tr_b16 v[94:95], v2 offset:19072
		ds_read_b64_tr_b16 v[96:97], v2 offset:19008
		ds_read_b64_tr_b16 v[98:99], v2 offset:19136
		ds_read_b64_tr_b16 v[100:101], v2 offset:27648
		ds_read_b64_tr_b16 v[102:103], v2 offset:27776
		ds_read_b64_tr_b16 v[108:109], v2 offset:27712
		ds_read_b64_tr_b16 v[110:111], v2 offset:27840
		ds_read_b64_tr_b16 v[112:113], v2 offset:19200
		ds_read_b64_tr_b16 v[114:115], v2 offset:19328
		ds_read_b64_tr_b16 v[116:117], v2 offset:19264
		ds_read_b64_tr_b16 v[118:119], v2 offset:19392
		ds_read_b64_tr_b16 v[120:121], v2 offset:27904
		ds_read_b64_tr_b16 v[122:123], v2 offset:28032
		ds_read_b64_tr_b16 v[124:125], v2 offset:27968
		ds_read_b64_tr_b16 v[126:127], v2 offset:28096
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[176:191], v[52:55], v[88:91], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[56:59], v[88:91], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[60:63], v[88:91], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[64:67], v[88:91], v[224:239]
		v_fma_f32 v51, v162, v40, v44
		v_fma_f32 v52, v163, v40, v44
		v_fma_f32 v53, v164, v40, v44
		v_fma_f32 v54, v165, v40, v44
		v_pk_fma_f32 v[56:57], v[166:167], v[40:41], v[44:45]
		v_pk_fma_f32 v[58:59], v[168:169], v[40:41], v[44:45]
		v_pk_fma_f32 v[60:61], v[170:171], v[40:41], v[44:45]
		v_pk_fma_f32 v[62:63], v[172:173], v[40:41], v[44:45]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[68:71], v[148:151], v[176:191]
		v_fma_f32 v55, v174, v40, v44
		v_fma_f32 v64, v175, v40, v44
		v_exp_f32_e32 v52, v52
		v_exp_f32_e32 v53, v53
		v_exp_f32_e32 v54, v54
		v_exp_f32_e32 v56, v56
		v_exp_f32_e32 v57, v57
		v_exp_f32_e32 v58, v58
		v_mfma_f32_32x32x16_bf16 v[192:207], v[72:75], v[148:151], v[192:207]
		v_exp_f32_e32 v59, v59
		v_exp_f32_e32 v60, v60
		v_exp_f32_e32 v61, v61
		v_exp_f32_e32 v62, v62
		v_exp_f32_e32 v63, v63
		v_exp_f32_e32 v55, v55
		v_exp_f32_e32 v64, v64
		v_mfma_f32_32x32x16_bf16 v[208:223], v[76:79], v[148:151], v[208:223]
		v_fma_f32 v65, v240, v40, v44
		v_fma_f32 v66, v241, v40, v44
		v_fma_f32 v67, v242, v40, v44
		v_fma_f32 v68, v243, v40, v44
		v_fma_f32 v69, v244, v40, v44
		v_fma_f32 v70, v245, v40, v44
		v_pk_fma_f32 v[72:73], v[246:247], v[40:41], v[44:45]
		v_pk_fma_f32 v[74:75], v[248:249], v[40:41], v[44:45]
		v_pk_fma_f32 v[76:77], v[250:251], v[40:41], v[44:45]
		v_pk_fma_f32 v[78:79], v[252:253], v[40:41], v[44:45]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[84:87], v[148:151], v[224:239]
		v_fma_f32 v71, v254, v40, v44
		v_fma_f32 v84, v255, v40, v44
		v_exp_f32_e32 v65, v65
		v_exp_f32_e32 v66, v66
		v_exp_f32_e32 v67, v67
		v_exp_f32_e32 v68, v68
		v_exp_f32_e32 v69, v69
		v_mfma_f32_32x32x16_bf16 v[176:191], v[92:95], v[104:107], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[96:99], v[104:107], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[100:103], v[104:107], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[108:111], v[104:107], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[112:115], v[80:83], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[116:119], v[80:83], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[120:123], v[80:83], v[208:223]
		s_add_i32 m0, s3, 0x1d000
		v_add_f32_e32 v47, v47, v50
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		v_fma_f32 v50, v160, v40, v44
		s_add_i32 m0, m0, 0x2200
		v_fma_f32 v85, v161, v40, v44
		buffer_load_dwordx4 v42, s[20:23], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], v[124:127], v[80:83], v[224:239]
		v_exp_f32_e32 v50, v50
		v_exp_f32_e32 v80, v85
		v_exp_f32_e32 v51, v51
		s_waitcnt vmcnt(4)
		s_barrier
		ds_read_b128 v[88:91], v5 offset:49920
		ds_read_b128 v[92:95], v0 offset:50432
		ds_read_b128 v[96:99], v5 offset:49952
		ds_read_b128 v[100:103], v0 offset:50464
		ds_read_b128 v[104:107], v5 offset:49984
		ds_read_b128 v[108:111], v0 offset:50496
		ds_read_b128 v[112:115], v5 offset:50016
		ds_read_b128 v[116:119], v0 offset:50528
		ds_read_b128 v[120:123], v5 offset:58240
		ds_read_b128 v[124:127], v0 offset:58752
		ds_read_b128 v[128:131], v5 offset:58272
		ds_read_b128 v[132:135], v0 offset:58784
		ds_read_b128 v[136:139], v5 offset:58304
		ds_read_b128 v[140:143], v0 offset:58816
		ds_read_b128 v[144:147], v5 offset:58336
		ds_read_b128 v[148:151], v0 offset:58848
		v_exp_f32_e32 v70, v70
		v_exp_f32_e32 v72, v72
		v_exp_f32_e32 v73, v73
		v_exp_f32_e32 v74, v74
		v_exp_f32_e32 v75, v75
		v_exp_f32_e32 v76, v76
		v_exp_f32_e32 v77, v77
		v_exp_f32_e32 v78, v78
		v_exp_f32_e32 v79, v79
		v_exp_f32_e32 v71, v71
		v_exp_f32_e32 v81, v84
		v_add_f32_e32 v82, v50, v80
		v_add_f32_e32 v82, v82, v51
		v_add_f32_e32 v82, v82, v52
		v_add_f32_e32 v82, v82, v53
		v_add_f32_e32 v82, v82, v54
		v_add_f32_e32 v82, v82, v56
		v_add_f32_e32 v82, v82, v57
		v_add_f32_e32 v82, v82, v58
		v_add_f32_e32 v82, v82, v59
		v_cvt_pk_bf16_f32 v84, v58, v59
		v_add_f32_e32 v58, v82, v60
		v_add_f32_e32 v58, v58, v61
		v_cvt_pk_bf16_f32 v85, v60, v61
		v_add_f32_e32 v58, v58, v62
		v_add_f32_e32 v58, v58, v63
		v_cvt_pk_bf16_f32 v86, v62, v63
		v_add_f32_e32 v58, v58, v55
		v_add_f32_e32 v58, v58, v64
		v_cvt_pk_bf16_f32 v87, v55, v64
		v_add_f32_e32 v55, v58, v65
		v_add_f32_e32 v55, v55, v66
		v_cvt_pk_bf16_f32 v60, v65, v66
		v_add_f32_e32 v55, v55, v67
		v_add_f32_e32 v55, v55, v68
		v_cvt_pk_bf16_f32 v61, v67, v68
		v_add_f32_e32 v55, v55, v69
		v_add_f32_e32 v55, v55, v70
		v_cvt_pk_bf16_f32 v62, v69, v70
		v_add_f32_e32 v55, v55, v72
		v_add_f32_e32 v55, v55, v73
		v_cvt_pk_bf16_f32 v63, v72, v73
		v_add_f32_e32 v55, v55, v74
		v_add_f32_e32 v55, v55, v75
		v_cvt_pk_bf16_f32 v64, v74, v75
		v_add_f32_e32 v55, v55, v76
		v_add_f32_e32 v55, v55, v77
		v_cvt_pk_bf16_f32 v65, v76, v77
		v_add_f32_e32 v55, v55, v78
		v_add_f32_e32 v55, v55, v79
		v_cvt_pk_bf16_f32 v66, v78, v79
		v_add_f32_e32 v55, v55, v71
		v_add_f32_e32 v58, v55, v81
		v_cvt_pk_bf16_f32 v67, v71, v81
		v_mov_b32_e32 v59, v58
		v_cvt_pk_bf16_f32 v68, v50, v80
		v_cvt_pk_bf16_f32 v69, v51, v52
		v_permlane32_swap_b32_e32 v58, v59
		v_add_f32_e32 v50, v58, v59
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v51, s9, v6
		s_add_i32 m0, s10, 0x4100
		v_cvt_pk_bf16_f32 v70, v53, v54
		buffer_load_dwordx4 v51, s[16:19], 0 offen lds
		v_cvt_pk_bf16_f32 v71, v56, v57
		s_add_i32 m0, m0, 0x2080
		s_add_i32 s8, s9, 0x80
		v_add_u32_e32 v51, s8, v6
		buffer_load_dwordx4 v51, s[16:19], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[160:175], v[88:91], v[8:11], 0
		v_mfma_f32_32x32x16_bf16 v[240:255], v[92:95], v[8:11], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], v[12:15], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[100:103], v[12:15], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[104:107], v[16:19], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[108:111], v[16:19], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[112:115], v[20:23], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[116:119], v[20:23], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[120:123], v[24:27], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[124:127], v[24:27], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[128:131], v[28:31], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[132:135], v[28:31], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[136:139], v[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[140:143], v[32:35], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[144:147], v[36:39], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[148:151], v[36:39], v[240:255]
		s_waitcnt vmcnt(4)
		s_barrier
		ds_read_b64_tr_b16 v[52:53], v2 offset:35840
		ds_read_b64_tr_b16 v[54:55], v2 offset:35968
		ds_read_b64_tr_b16 v[56:57], v2 offset:35904
		ds_read_b64_tr_b16 v[58:59], v2 offset:36032
		ds_read_b64_tr_b16 v[72:73], v2 offset:44544
		ds_read_b64_tr_b16 v[74:75], v2 offset:44672
		ds_read_b64_tr_b16 v[76:77], v2 offset:44608
		ds_read_b64_tr_b16 v[78:79], v2 offset:44736
		ds_read_b64_tr_b16 v[80:81], v2 offset:36096
		ds_read_b64_tr_b16 v[82:83], v2 offset:36224
		ds_read_b64_tr_b16 v[88:89], v2 offset:36160
		ds_read_b64_tr_b16 v[90:91], v2 offset:36288
		ds_read_b64_tr_b16 v[92:93], v2 offset:44800
		ds_read_b64_tr_b16 v[94:95], v2 offset:44928
		ds_read_b64_tr_b16 v[96:97], v2 offset:44864
		ds_read_b64_tr_b16 v[98:99], v2 offset:44992
		ds_read_b64_tr_b16 v[100:101], v2 offset:36352
		ds_read_b64_tr_b16 v[102:103], v2 offset:36480
		ds_read_b64_tr_b16 v[104:105], v2 offset:36416
		ds_read_b64_tr_b16 v[106:107], v2 offset:36544
		ds_read_b64_tr_b16 v[108:109], v2 offset:45056
		ds_read_b64_tr_b16 v[110:111], v2 offset:45184
		ds_read_b64_tr_b16 v[112:113], v2 offset:45120
		ds_read_b64_tr_b16 v[114:115], v2 offset:45248
		ds_read_b64_tr_b16 v[116:117], v2 offset:36608
		ds_read_b64_tr_b16 v[118:119], v2 offset:36736
		ds_read_b64_tr_b16 v[120:121], v2 offset:36672
		ds_read_b64_tr_b16 v[122:123], v2 offset:36800
		ds_read_b64_tr_b16 v[124:125], v2 offset:45312
		ds_read_b64_tr_b16 v[126:127], v2 offset:45440
		ds_read_b64_tr_b16 v[128:129], v2 offset:45376
		ds_read_b64_tr_b16 v[130:131], v2 offset:45504
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[176:191], v[52:55], v[68:71], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[56:59], v[68:71], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[72:75], v[68:71], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[76:79], v[68:71], v[224:239]
		v_fma_f32 v51, v162, v40, v44
		v_fma_f32 v52, v163, v40, v44
		v_fma_f32 v53, v164, v40, v44
		v_fma_f32 v54, v165, v40, v44
		v_pk_fma_f32 v[56:57], v[166:167], v[40:41], v[44:45]
		v_pk_fma_f32 v[58:59], v[168:169], v[40:41], v[44:45]
		v_pk_fma_f32 v[68:69], v[170:171], v[40:41], v[44:45]
		v_pk_fma_f32 v[70:71], v[172:173], v[40:41], v[44:45]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[80:83], v[84:87], v[176:191]
		v_fma_f32 v55, v174, v40, v44
		v_fma_f32 v72, v175, v40, v44
		v_exp_f32_e32 v52, v52
		v_exp_f32_e32 v53, v53
		v_exp_f32_e32 v54, v54
		v_exp_f32_e32 v56, v56
		v_exp_f32_e32 v57, v57
		v_exp_f32_e32 v58, v58
		v_mfma_f32_32x32x16_bf16 v[192:207], v[88:91], v[84:87], v[192:207]
		v_exp_f32_e32 v59, v59
		v_exp_f32_e32 v68, v68
		v_exp_f32_e32 v69, v69
		v_exp_f32_e32 v70, v70
		v_exp_f32_e32 v71, v71
		v_exp_f32_e32 v55, v55
		v_exp_f32_e32 v72, v72
		v_mfma_f32_32x32x16_bf16 v[208:223], v[92:95], v[84:87], v[208:223]
		v_fma_f32 v73, v240, v40, v44
		v_fma_f32 v74, v241, v40, v44
		v_fma_f32 v75, v242, v40, v44
		v_fma_f32 v76, v243, v40, v44
		v_fma_f32 v77, v244, v40, v44
		v_fma_f32 v78, v245, v40, v44
		v_pk_fma_f32 v[80:81], v[246:247], v[40:41], v[44:45]
		v_pk_fma_f32 v[82:83], v[248:249], v[40:41], v[44:45]
		v_pk_fma_f32 v[88:89], v[250:251], v[40:41], v[44:45]
		v_pk_fma_f32 v[90:91], v[252:253], v[40:41], v[44:45]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[96:99], v[84:87], v[224:239]
		v_fma_f32 v79, v254, v40, v44
		v_fma_f32 v84, v255, v40, v44
		v_exp_f32_e32 v73, v73
		v_exp_f32_e32 v74, v74
		v_exp_f32_e32 v75, v75
		v_exp_f32_e32 v76, v76
		v_exp_f32_e32 v77, v77
		v_mfma_f32_32x32x16_bf16 v[176:191], v[100:103], v[60:63], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[104:107], v[60:63], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[108:111], v[60:63], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[112:115], v[60:63], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[116:119], v[64:67], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[120:123], v[64:67], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[124:127], v[64:67], v[208:223]
		s_add_i32 m0, s3, 0x10400
		v_add_f32_e32 v47, v47, v50
		buffer_load_dwordx4 v43, s[20:23], 0 offen lds
		v_fma_f32 v50, v160, v40, v44
		s_add_i32 m0, m0, 0x2200
		v_fma_f32 v60, v161, v40, v44
		buffer_load_dwordx4 v46, s[20:23], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], v[128:131], v[64:67], v[224:239]
		v_exp_f32_e32 v50, v50
		v_exp_f32_e32 v60, v60
		v_exp_f32_e32 v51, v51
		s_waitcnt vmcnt(4)
		s_barrier
		ds_read_b128 v[64:67], v5
		ds_read_b128 v[92:95], v0 offset:512
		ds_read_b128 v[96:99], v5 offset:32
		ds_read_b128 v[100:103], v0 offset:544
		ds_read_b128 v[104:107], v5 offset:64
		ds_read_b128 v[108:111], v0 offset:576
		ds_read_b128 v[112:115], v5 offset:96
		ds_read_b128 v[116:119], v0 offset:608
		ds_read_b128 v[120:123], v5 offset:8320
		ds_read_b128 v[124:127], v0 offset:8832
		ds_read_b128 v[128:131], v5 offset:8352
		ds_read_b128 v[132:135], v0 offset:8864
		ds_read_b128 v[136:139], v5 offset:8384
		ds_read_b128 v[140:143], v0 offset:8896
		ds_read_b128 v[144:147], v5 offset:8416
		ds_read_b128 v[148:151], v0 offset:8928
		v_exp_f32_e32 v61, v78
		v_exp_f32_e32 v62, v80
		v_exp_f32_e32 v63, v81
		v_exp_f32_e32 v78, v82
		v_exp_f32_e32 v80, v83
		v_exp_f32_e32 v81, v88
		v_exp_f32_e32 v82, v89
		v_exp_f32_e32 v83, v90
		v_exp_f32_e32 v85, v91
		v_exp_f32_e32 v79, v79
		v_exp_f32_e32 v84, v84
		v_add_f32_e32 v86, v50, v60
		v_add_f32_e32 v86, v86, v51
		v_add_f32_e32 v86, v86, v52
		v_add_f32_e32 v86, v86, v53
		v_add_f32_e32 v86, v86, v54
		v_add_f32_e32 v86, v86, v56
		v_add_f32_e32 v86, v86, v57
		v_add_f32_e32 v86, v86, v58
		v_add_f32_e32 v86, v86, v59
		v_cvt_pk_bf16_f32 v88, v58, v59
		v_add_f32_e32 v58, v86, v68
		v_add_f32_e32 v58, v58, v69
		v_cvt_pk_bf16_f32 v89, v68, v69
		v_add_f32_e32 v58, v58, v70
		v_add_f32_e32 v58, v58, v71
		v_cvt_pk_bf16_f32 v90, v70, v71
		v_add_f32_e32 v58, v58, v55
		v_add_f32_e32 v58, v58, v72
		v_cvt_pk_bf16_f32 v91, v55, v72
		v_add_f32_e32 v55, v58, v73
		v_add_f32_e32 v55, v55, v74
		v_cvt_pk_bf16_f32 v68, v73, v74
		v_add_f32_e32 v55, v55, v75
		v_add_f32_e32 v55, v55, v76
		v_cvt_pk_bf16_f32 v69, v75, v76
		v_add_f32_e32 v55, v55, v77
		v_add_f32_e32 v55, v55, v61
		v_cvt_pk_bf16_f32 v70, v77, v61
		v_add_f32_e32 v55, v55, v62
		v_add_f32_e32 v55, v55, v63
		v_cvt_pk_bf16_f32 v71, v62, v63
		v_add_f32_e32 v55, v55, v78
		v_add_f32_e32 v55, v55, v80
		v_cvt_pk_bf16_f32 v72, v78, v80
		v_add_f32_e32 v55, v55, v81
		v_add_f32_e32 v55, v55, v82
		v_cvt_pk_bf16_f32 v73, v81, v82
		v_add_f32_e32 v55, v55, v83
		v_add_f32_e32 v55, v55, v85
		v_cvt_pk_bf16_f32 v74, v83, v85
		v_add_f32_e32 v55, v55, v79
		v_add_f32_e32 v58, v55, v84
		v_cvt_pk_bf16_f32 v75, v79, v84
		v_mov_b32_e32 v59, v58
		v_cvt_pk_bf16_f32 v76, v50, v60
		v_cvt_pk_bf16_f32 v77, v51, v52
		v_permlane32_swap_b32_e32 v58, v59
		v_add_f32_e32 v50, v58, v59
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v51, s12, v6
		s_add_i32 m0, s10, 0x8200
		v_cvt_pk_bf16_f32 v78, v53, v54
		buffer_load_dwordx4 v51, s[16:19], 0 offen lds
		v_cvt_pk_bf16_f32 v79, v56, v57
		s_add_i32 m0, m0, 0x2080
		s_add_i32 s8, s12, 0x80
		v_add_u32_e32 v51, s8, v6
		buffer_load_dwordx4 v51, s[16:19], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[160:175], v[64:67], v[8:11], 0
		v_mfma_f32_32x32x16_bf16 v[240:255], v[92:95], v[8:11], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], v[12:15], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[100:103], v[12:15], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[104:107], v[16:19], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[108:111], v[16:19], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[112:115], v[20:23], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[116:119], v[20:23], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[120:123], v[24:27], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[124:127], v[24:27], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[128:131], v[28:31], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[132:135], v[28:31], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[136:139], v[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[140:143], v[32:35], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[144:147], v[36:39], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[148:151], v[36:39], v[240:255]
		s_waitcnt vmcnt(4)
		s_barrier
		ds_read_b64_tr_b16 v[52:53], v2 offset:53248
		ds_read_b64_tr_b16 v[54:55], v2 offset:53376
		ds_read_b64_tr_b16 v[56:57], v2 offset:53312
		ds_read_b64_tr_b16 v[58:59], v2 offset:53440
		ds_read_b64_tr_b16 v[60:61], v2 offset:61952
		ds_read_b64_tr_b16 v[62:63], v2 offset:62080
		ds_read_b64_tr_b16 v[64:65], v2 offset:62016
		ds_read_b64_tr_b16 v[66:67], v2 offset:62144
		ds_read_b64_tr_b16 v[80:81], v2 offset:53504
		ds_read_b64_tr_b16 v[82:83], v2 offset:53632
		ds_read_b64_tr_b16 v[84:85], v2 offset:53568
		ds_read_b64_tr_b16 v[86:87], v2 offset:53696
		ds_read_b64_tr_b16 v[92:93], v2 offset:62208
		ds_read_b64_tr_b16 v[94:95], v2 offset:62336
		ds_read_b64_tr_b16 v[96:97], v2 offset:62272
		ds_read_b64_tr_b16 v[98:99], v2 offset:62400
		ds_read_b64_tr_b16 v[100:101], v2 offset:53760
		ds_read_b64_tr_b16 v[102:103], v2 offset:53888
		ds_read_b64_tr_b16 v[104:105], v2 offset:53824
		ds_read_b64_tr_b16 v[106:107], v2 offset:53952
		ds_read_b64_tr_b16 v[108:109], v2 offset:62464
		ds_read_b64_tr_b16 v[110:111], v2 offset:62592
		ds_read_b64_tr_b16 v[112:113], v2 offset:62528
		ds_read_b64_tr_b16 v[114:115], v2 offset:62656
		ds_read_b64_tr_b16 v[116:117], v2 offset:54016
		ds_read_b64_tr_b16 v[118:119], v2 offset:54144
		ds_read_b64_tr_b16 v[120:121], v2 offset:54080
		ds_read_b64_tr_b16 v[122:123], v2 offset:54208
		ds_read_b64_tr_b16 v[124:125], v2 offset:62720
		ds_read_b64_tr_b16 v[126:127], v2 offset:62848
		ds_read_b64_tr_b16 v[128:129], v2 offset:62784
		ds_read_b64_tr_b16 v[130:131], v2 offset:62912
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[176:191], v[52:55], v[76:79], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[56:59], v[76:79], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[60:63], v[76:79], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[64:67], v[76:79], v[224:239]
		v_fma_f32 v51, v162, v40, v44
		v_fma_f32 v52, v163, v40, v44
		v_fma_f32 v53, v164, v40, v44
		v_fma_f32 v54, v165, v40, v44
		v_pk_fma_f32 v[56:57], v[166:167], v[40:41], v[44:45]
		v_pk_fma_f32 v[58:59], v[168:169], v[40:41], v[44:45]
		v_pk_fma_f32 v[60:61], v[170:171], v[40:41], v[44:45]
		v_pk_fma_f32 v[62:63], v[172:173], v[40:41], v[44:45]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[80:83], v[88:91], v[176:191]
		v_fma_f32 v55, v174, v40, v44
		v_fma_f32 v64, v175, v40, v44
		v_exp_f32_e32 v52, v52
		v_exp_f32_e32 v53, v53
		v_exp_f32_e32 v54, v54
		v_exp_f32_e32 v56, v56
		v_exp_f32_e32 v57, v57
		v_exp_f32_e32 v58, v58
		v_mfma_f32_32x32x16_bf16 v[192:207], v[84:87], v[88:91], v[192:207]
		v_exp_f32_e32 v59, v59
		v_exp_f32_e32 v60, v60
		v_exp_f32_e32 v61, v61
		v_exp_f32_e32 v62, v62
		v_exp_f32_e32 v63, v63
		v_exp_f32_e32 v55, v55
		v_exp_f32_e32 v64, v64
		v_mfma_f32_32x32x16_bf16 v[208:223], v[92:95], v[88:91], v[208:223]
		v_fma_f32 v65, v240, v40, v44
		v_fma_f32 v66, v241, v40, v44
		v_fma_f32 v67, v242, v40, v44
		v_fma_f32 v76, v243, v40, v44
		v_fma_f32 v77, v244, v40, v44
		v_fma_f32 v78, v245, v40, v44
		v_pk_fma_f32 v[80:81], v[246:247], v[40:41], v[44:45]
		v_pk_fma_f32 v[82:83], v[248:249], v[40:41], v[44:45]
		v_pk_fma_f32 v[84:85], v[250:251], v[40:41], v[44:45]
		v_pk_fma_f32 v[86:87], v[252:253], v[40:41], v[44:45]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[96:99], v[88:91], v[224:239]
		v_fma_f32 v79, v254, v40, v44
		v_fma_f32 v88, v255, v40, v44
		v_exp_f32_e32 v65, v65
		v_exp_f32_e32 v66, v66
		v_exp_f32_e32 v67, v67
		v_exp_f32_e32 v76, v76
		v_exp_f32_e32 v77, v77
		v_mfma_f32_32x32x16_bf16 v[176:191], v[100:103], v[68:71], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[104:107], v[68:71], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[108:111], v[68:71], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[112:115], v[68:71], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[116:119], v[72:75], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[120:123], v[72:75], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[124:127], v[72:75], v[208:223]
		s_add_i32 m0, s3, 0x14800
		v_add_f32_e32 v47, v47, v50
		buffer_load_dwordx4 v48, s[20:23], 0 offen lds
		v_fma_f32 v50, v160, v40, v44
		s_add_i32 m0, m0, 0x2200
		v_fma_f32 v68, v161, v40, v44
		buffer_load_dwordx4 v49, s[20:23], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], v[128:131], v[72:75], v[224:239]
		v_exp_f32_e32 v50, v50
		v_exp_f32_e32 v68, v68
		v_exp_f32_e32 v51, v51
		s_waitcnt vmcnt(4)
		s_barrier
		ds_read_b128 v[72:75], v5 offset:16640
		ds_read_b128 v[92:95], v0 offset:17152
		ds_read_b128 v[96:99], v5 offset:16672
		ds_read_b128 v[100:103], v0 offset:17184
		ds_read_b128 v[104:107], v5 offset:16704
		ds_read_b128 v[108:111], v0 offset:17216
		ds_read_b128 v[112:115], v5 offset:16736
		ds_read_b128 v[116:119], v0 offset:17248
		ds_read_b128 v[120:123], v5 offset:24960
		ds_read_b128 v[124:127], v0 offset:25472
		ds_read_b128 v[128:131], v5 offset:24992
		ds_read_b128 v[132:135], v0 offset:25504
		ds_read_b128 v[136:139], v5 offset:25024
		ds_read_b128 v[140:143], v0 offset:25536
		ds_read_b128 v[144:147], v5 offset:25056
		ds_read_b128 v[148:151], v0 offset:25568
		v_exp_f32_e32 v69, v78
		v_exp_f32_e32 v70, v80
		v_exp_f32_e32 v71, v81
		v_exp_f32_e32 v78, v82
		v_exp_f32_e32 v80, v83
		v_exp_f32_e32 v81, v84
		v_exp_f32_e32 v82, v85
		v_exp_f32_e32 v83, v86
		v_exp_f32_e32 v84, v87
		v_exp_f32_e32 v79, v79
		v_exp_f32_e32 v85, v88
		v_add_f32_e32 v86, v50, v68
		v_add_f32_e32 v86, v86, v51
		v_add_f32_e32 v86, v86, v52
		v_add_f32_e32 v86, v86, v53
		v_add_f32_e32 v86, v86, v54
		v_add_f32_e32 v86, v86, v56
		v_add_f32_e32 v86, v86, v57
		v_cvt_pk_bf16_f32 v91, v56, v57
		v_add_f32_e32 v56, v86, v58
		v_add_f32_e32 v56, v56, v59
		v_cvt_pk_bf16_f32 v152, v58, v59
		v_add_f32_e32 v56, v56, v60
		v_add_f32_e32 v56, v56, v61
		v_cvt_pk_bf16_f32 v153, v60, v61
		v_add_f32_e32 v56, v56, v62
		v_add_f32_e32 v56, v56, v63
		v_cvt_pk_bf16_f32 v154, v62, v63
		v_add_f32_e32 v56, v56, v55
		v_add_f32_e32 v56, v56, v64
		v_cvt_pk_bf16_f32 v155, v55, v64
		v_add_f32_e32 v55, v56, v65
		v_add_f32_e32 v55, v55, v66
		v_cvt_pk_bf16_f32 v56, v65, v66
		v_add_f32_e32 v55, v55, v67
		v_add_f32_e32 v55, v55, v76
		v_cvt_pk_bf16_f32 v57, v67, v76
		v_add_f32_e32 v55, v55, v77
		v_add_f32_e32 v55, v55, v69
		v_cvt_pk_bf16_f32 v58, v77, v69
		v_add_f32_e32 v55, v55, v70
		v_add_f32_e32 v55, v55, v71
		v_cvt_pk_bf16_f32 v59, v70, v71
		v_add_f32_e32 v55, v55, v78
		v_add_f32_e32 v55, v55, v80
		v_cvt_pk_bf16_f32 v60, v78, v80
		v_add_f32_e32 v55, v55, v81
		v_add_f32_e32 v55, v55, v82
		v_cvt_pk_bf16_f32 v61, v81, v82
		v_add_f32_e32 v55, v55, v83
		v_add_f32_e32 v55, v55, v84
		v_cvt_pk_bf16_f32 v62, v83, v84
		v_add_f32_e32 v55, v55, v79
		v_add_f32_e32 v64, v55, v85
		v_cvt_pk_bf16_f32 v63, v79, v85
		v_mov_b32_e32 v65, v64
		v_cvt_pk_bf16_f32 v88, v50, v68
		v_cvt_pk_bf16_f32 v89, v51, v52
		v_permlane32_swap_b32_e32 v64, v65
		v_add_f32_e32 v50, v64, v65
		v_add_f32_e32 v47, v47, v50
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 m0, s10, 0xc300
		s_lshl_b32 s8, s11, 14
		v_add_u32_e32 v50, s8, v6
		buffer_load_dwordx4 v50, s[16:19], 0 offen lds
		s_add_i32 s8, s8, 0x80
		v_add_u32_e32 v50, s8, v6
		s_add_i32 m0, m0, 0x2080
		v_cvt_pk_bf16_f32 v90, v53, v54
		buffer_load_dwordx4 v50, s[16:19], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[160:175], v[72:75], v[8:11], 0
		v_mfma_f32_32x32x16_bf16 v[64:79], v[92:95], v[8:11], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], v[12:15], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[64:79], v[100:103], v[12:15], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[104:107], v[16:19], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[64:79], v[108:111], v[16:19], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[112:115], v[20:23], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[64:79], v[116:119], v[20:23], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[120:123], v[24:27], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[64:79], v[124:127], v[24:27], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[128:131], v[28:31], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[64:79], v[132:135], v[28:31], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[136:139], v[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[64:79], v[140:143], v[32:35], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[144:147], v[36:39], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[64:79], v[148:151], v[36:39], v[64:79]
		s_waitcnt vmcnt(4)
		s_barrier
		ds_read_b64_tr_b16 v[52:53], v2 offset:1024
		ds_read_b64_tr_b16 v[54:55], v2 offset:1152
		ds_read_b64_tr_b16 v[80:81], v2 offset:1088
		ds_read_b64_tr_b16 v[82:83], v2 offset:1216
		ds_read_b64_tr_b16 v[84:85], v2 offset:9728
		ds_read_b64_tr_b16 v[86:87], v2 offset:9856
		ds_read_b64_tr_b16 v[92:93], v2 offset:9792
		ds_read_b64_tr_b16 v[94:95], v2 offset:9920
		ds_read_b64_tr_b16 v[96:97], v2 offset:1280
		ds_read_b64_tr_b16 v[98:99], v2 offset:1408
		ds_read_b64_tr_b16 v[104:105], v2 offset:1344
		ds_read_b64_tr_b16 v[106:107], v2 offset:1472
		ds_read_b64_tr_b16 v[112:113], v2 offset:9984
		ds_read_b64_tr_b16 v[114:115], v2 offset:10112
		ds_read_b64_tr_b16 v[116:117], v2 offset:10048
		ds_read_b64_tr_b16 v[118:119], v2 offset:10176
		ds_read_b64_tr_b16 v[120:121], v2 offset:1536
		ds_read_b64_tr_b16 v[122:123], v2 offset:1664
		ds_read_b64_tr_b16 v[124:125], v2 offset:1600
		ds_read_b64_tr_b16 v[126:127], v2 offset:1728
		ds_read_b64_tr_b16 v[128:129], v2 offset:10240
		ds_read_b64_tr_b16 v[130:131], v2 offset:10368
		ds_read_b64_tr_b16 v[132:133], v2 offset:10304
		ds_read_b64_tr_b16 v[134:135], v2 offset:10432
		ds_read_b64_tr_b16 v[136:137], v2 offset:1792
		ds_read_b64_tr_b16 v[138:139], v2 offset:1920
		ds_read_b64_tr_b16 v[140:141], v2 offset:1856
		ds_read_b64_tr_b16 v[142:143], v2 offset:1984
		ds_read_b64_tr_b16 v[144:145], v2 offset:10496
		ds_read_b64_tr_b16 v[146:147], v2 offset:10624
		ds_read_b64_tr_b16 v[148:149], v2 offset:10560
		ds_read_b64_tr_b16 v[150:151], v2 offset:10688
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[176:191], v[52:55], v[88:91], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[80:83], v[88:91], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[84:87], v[88:91], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[92:95], v[88:91], v[224:239]
		v_fma_f32 v50, v160, v40, v44
		v_fma_f32 v51, v161, v40, v44
		v_fma_f32 v52, v162, v40, v44
		v_fma_f32 v53, v163, v40, v44
		v_fma_f32 v54, v164, v40, v44
		v_fma_f32 v55, v165, v40, v44
		v_pk_fma_f32 v[80:81], v[166:167], v[40:41], v[44:45]
		v_pk_fma_f32 v[82:83], v[168:169], v[40:41], v[44:45]
		v_pk_fma_f32 v[84:85], v[170:171], v[40:41], v[44:45]
		v_pk_fma_f32 v[86:87], v[172:173], v[40:41], v[44:45]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[96:99], v[152:155], v[176:191]
		v_fma_f32 v88, v174, v40, v44
		v_fma_f32 v89, v175, v40, v44
		v_exp_f32_e32 v96, v50
		v_exp_f32_e32 v97, v51
		v_exp_f32_e32 v98, v52
		v_exp_f32_e32 v99, v53
		v_exp_f32_e32 v100, v54
		v_exp_f32_e32 v101, v55
		v_mfma_f32_32x32x16_bf16 v[192:207], v[104:107], v[152:155], v[192:207]
		v_exp_f32_e32 v102, v80
		v_exp_f32_e32 v103, v81
		v_exp_f32_e32 v104, v82
		v_exp_f32_e32 v105, v83
		v_exp_f32_e32 v106, v84
		v_exp_f32_e32 v107, v85
		v_exp_f32_e32 v108, v86
		v_mfma_f32_32x32x16_bf16 v[208:223], v[112:115], v[152:155], v[208:223]
		v_exp_f32_e32 v109, v87
		v_exp_f32_e32 v110, v88
		v_exp_f32_e32 v111, v89
		v_pk_fma_f32 v[50:51], v[64:65], v[40:41], v[44:45]
		v_pk_fma_f32 v[52:53], v[66:67], v[40:41], v[44:45]
		v_pk_fma_f32 v[54:55], v[68:69], v[40:41], v[44:45]
		v_pk_fma_f32 v[86:87], v[70:71], v[40:41], v[44:45]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[116:119], v[152:155], v[224:239]
		v_fma_f32 v88, v72, v40, v44
		v_fma_f32 v89, v73, v40, v44
		v_fma_f32 v90, v74, v40, v44
		v_fma_f32 v91, v75, v40, v44
		v_fma_f32 v92, v76, v40, v44
		v_fma_f32 v93, v77, v40, v44
		v_pk_fma_f32 v[94:95], v[78:79], v[40:41], v[44:45]
		v_exp_f32_e32 v80, v50
		v_exp_f32_e32 v81, v51
		v_exp_f32_e32 v82, v52
		v_mfma_f32_32x32x16_bf16 v[176:191], v[120:123], v[56:59], v[176:191]
		v_exp_f32_e32 v83, v53
		v_exp_f32_e32 v84, v54
		s_add_u32 s20, s20, 0x10000
		s_addc_u32 s21, s21, 0
		s_cmp_lt_i32 s1, 0x7e
		v_mfma_f32_32x32x16_bf16 v[192:207], v[124:127], v[56:59], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[128:131], v[56:59], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[132:135], v[56:59], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[136:139], v[60:63], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[140:143], v[60:63], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[144:147], v[60:63], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[148:151], v[60:63], v[224:239]
		v_mov_b32_e32 v85, v55
		s_cbranch_scc1 .Lflash_attention_bf16_gfx950.loop_head_0
.Lflash_attention_bf16_gfx950.loop_exit_0:
		s_branch .Lflash_attention_bf16_gfx950.if_end_1
.Lflash_attention_bf16_gfx950.if_else_1:
		s_mov_b32 s20, s4
		s_mov_b32 s21, s5
		s_mov_b32 s22, s6
		s_mov_b32 s23, s7
.Lflash_attention_bf16_gfx950.loop_head_1:
		s_add_i32 s8, s1, 2
		s_add_i32 s9, s1, 3
		s_add_i32 s11, s1, 5
		s_add_i32 s1, s1, 4
		s_cmp_lt_u32 s8, 0x80
		s_cselect_b32 s8, s8, 0x7f
		s_cmp_lt_u32 s9, 0x80
		s_cselect_b32 s9, s9, 0x7f
		s_cmp_lt_u32 s1, 0x80
		s_cselect_b32 s12, s1, 0x7f
		s_cmp_lt_u32 s11, 0x80
		s_cselect_b32 s11, s11, 0x7f
		s_add_i32 m0, s3, 0x18c00
		s_lshl_b32 s12, s12, 14
		buffer_load_dwordx4 v3, s[20:23], 0 offen lds
		s_lshl_b32 s9, s9, 14
		s_add_i32 m0, m0, 0x2200
		s_lshl_b32 s8, s8, 14
		buffer_load_dwordx4 v4, s[20:23], 0 offen lds
		s_waitcnt vmcnt(4)
		s_barrier
		v_exp_f32_e32 v50, v85
		v_exp_f32_e32 v51, v86
		v_exp_f32_e32 v52, v87
		v_exp_f32_e32 v53, v88
		v_exp_f32_e32 v54, v89
		v_exp_f32_e32 v55, v90
		v_exp_f32_e32 v56, v91
		v_exp_f32_e32 v57, v92
		v_exp_f32_e32 v58, v93
		v_exp_f32_e32 v59, v94
		v_exp_f32_e32 v60, v95
		v_add_f32_e32 v61, v96, v97
		v_add_f32_e32 v61, v61, v98
		v_add_f32_e32 v61, v61, v99
		ds_read_b128 v[64:67], v5 offset:33280
		ds_read_b128 v[68:71], v0 offset:33792
		ds_read_b128 v[72:75], v5 offset:33312
		ds_read_b128 v[76:79], v0 offset:33824
		ds_read_b128 v[88:91], v5 offset:33344
		ds_read_b128 v[92:95], v0 offset:33856
		ds_read_b128 v[112:115], v5 offset:33376
		ds_read_b128 v[116:119], v0 offset:33888
		ds_read_b128 v[120:123], v5 offset:41600
		ds_read_b128 v[124:127], v0 offset:42112
		ds_read_b128 v[128:131], v5 offset:41632
		ds_read_b128 v[132:135], v0 offset:42144
		ds_read_b128 v[136:139], v5 offset:41664
		ds_read_b128 v[140:143], v0 offset:42176
		ds_read_b128 v[144:147], v5 offset:41696
		ds_read_b128 v[148:151], v0 offset:42208
		v_add_f32_e32 v61, v61, v100
		v_add_f32_e32 v61, v61, v101
		v_add_f32_e32 v61, v61, v102
		v_add_f32_e32 v61, v61, v103
		v_cvt_pk_bf16_f32 v155, v102, v103
		v_add_f32_e32 v61, v61, v104
		v_add_f32_e32 v61, v61, v105
		v_cvt_pk_bf16_f32 v156, v104, v105
		v_add_f32_e32 v61, v61, v106
		v_add_f32_e32 v61, v61, v107
		v_cvt_pk_bf16_f32 v157, v106, v107
		v_add_f32_e32 v61, v61, v108
		v_add_f32_e32 v61, v61, v109
		v_cvt_pk_bf16_f32 v158, v108, v109
		v_add_f32_e32 v61, v61, v110
		v_add_f32_e32 v61, v61, v111
		v_cvt_pk_bf16_f32 v159, v110, v111
		v_add_f32_e32 v61, v61, v80
		v_add_f32_e32 v61, v61, v81
		v_cvt_pk_bf16_f32 v104, v80, v81
		v_add_f32_e32 v61, v61, v82
		v_add_f32_e32 v61, v61, v83
		v_cvt_pk_bf16_f32 v105, v82, v83
		v_add_f32_e32 v61, v61, v84
		v_add_f32_e32 v61, v61, v50
		v_cvt_pk_bf16_f32 v106, v84, v50
		v_add_f32_e32 v50, v61, v51
		v_add_f32_e32 v50, v50, v52
		v_cvt_pk_bf16_f32 v107, v51, v52
		v_add_f32_e32 v50, v50, v53
		v_add_f32_e32 v50, v50, v54
		v_add_f32_e32 v50, v50, v55
		v_add_f32_e32 v50, v50, v56
		v_cvt_pk_bf16_f32 v81, v55, v56
		v_add_f32_e32 v50, v50, v57
		v_add_f32_e32 v50, v50, v58
		v_cvt_pk_bf16_f32 v82, v57, v58
		v_add_f32_e32 v50, v50, v59
		v_add_f32_e32 v56, v50, v60
		v_cvt_pk_bf16_f32 v83, v59, v60
		v_mov_b32_e32 v57, v56
		v_cvt_pk_bf16_f32 v152, v96, v97
		v_cvt_pk_bf16_f32 v153, v98, v99
		v_permlane32_swap_b32_e32 v56, v57
		v_add_f32_e32 v50, v56, v57
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v51, s8, v6
		s_mov_b32 m0, s10
		s_add_i32 s8, s8, 0x80
		buffer_load_dwordx4 v51, s[16:19], 0 offen lds
		v_add_u32_e32 v51, s8, v6
		s_add_i32 m0, m0, 0x2080
		v_cvt_pk_bf16_f32 v154, v100, v101
		buffer_load_dwordx4 v51, s[16:19], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[160:175], v[64:67], v[8:11], 0
		v_mfma_f32_32x32x16_bf16 v[240:255], v[68:71], v[8:11], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[72:75], v[12:15], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[76:79], v[12:15], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[88:91], v[16:19], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[92:95], v[16:19], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[112:115], v[20:23], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[116:119], v[20:23], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[120:123], v[24:27], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[124:127], v[24:27], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[128:131], v[28:31], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[132:135], v[28:31], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[136:139], v[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[140:143], v[32:35], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[144:147], v[36:39], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[148:151], v[36:39], v[240:255]
		s_waitcnt vmcnt(4)
		s_barrier
		ds_read_b64_tr_b16 v[56:57], v2 offset:18432
		ds_read_b64_tr_b16 v[58:59], v2 offset:18560
		ds_read_b64_tr_b16 v[60:61], v2 offset:18496
		ds_read_b64_tr_b16 v[62:63], v2 offset:18624
		ds_read_b64_tr_b16 v[64:65], v2 offset:27136
		ds_read_b64_tr_b16 v[66:67], v2 offset:27264
		ds_read_b64_tr_b16 v[68:69], v2 offset:27200
		ds_read_b64_tr_b16 v[70:71], v2 offset:27328
		ds_read_b64_tr_b16 v[72:73], v2 offset:18688
		ds_read_b64_tr_b16 v[74:75], v2 offset:18816
		ds_read_b64_tr_b16 v[76:77], v2 offset:18752
		ds_read_b64_tr_b16 v[78:79], v2 offset:18880
		ds_read_b64_tr_b16 v[84:85], v2 offset:27392
		ds_read_b64_tr_b16 v[86:87], v2 offset:27520
		ds_read_b64_tr_b16 v[88:89], v2 offset:27456
		ds_read_b64_tr_b16 v[90:91], v2 offset:27584
		ds_read_b64_tr_b16 v[92:93], v2 offset:18944
		ds_read_b64_tr_b16 v[94:95], v2 offset:19072
		ds_read_b64_tr_b16 v[96:97], v2 offset:19008
		ds_read_b64_tr_b16 v[98:99], v2 offset:19136
		ds_read_b64_tr_b16 v[100:101], v2 offset:27648
		ds_read_b64_tr_b16 v[102:103], v2 offset:27776
		ds_read_b64_tr_b16 v[108:109], v2 offset:27712
		ds_read_b64_tr_b16 v[110:111], v2 offset:27840
		ds_read_b64_tr_b16 v[112:113], v2 offset:19200
		ds_read_b64_tr_b16 v[114:115], v2 offset:19328
		ds_read_b64_tr_b16 v[116:117], v2 offset:19264
		ds_read_b64_tr_b16 v[118:119], v2 offset:19392
		ds_read_b64_tr_b16 v[120:121], v2 offset:27904
		ds_read_b64_tr_b16 v[122:123], v2 offset:28032
		ds_read_b64_tr_b16 v[124:125], v2 offset:27968
		ds_read_b64_tr_b16 v[126:127], v2 offset:28096
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[176:191], v[56:59], v[152:155], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[60:63], v[152:155], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[64:67], v[152:155], v[208:223]
		s_add_i32 m0, s3, 0x1d000
		v_mfma_f32_32x32x16_bf16 v[224:239], v[68:71], v[152:155], v[224:239]
		buffer_load_dwordx4 v7, s[20:23], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[176:191], v[72:75], v[156:159], v[176:191]
		v_fma_f32 v51, v160, v40, v44
		v_fma_f32 v52, v161, v40, v44
		v_fma_f32 v55, v162, v40, v44
		v_fma_f32 v56, v163, v40, v44
		v_fma_f32 v57, v164, v40, v44
		v_fma_f32 v58, v165, v40, v44
		v_pk_fma_f32 v[60:61], v[166:167], v[40:41], v[44:45]
		v_pk_fma_f32 v[62:63], v[168:169], v[40:41], v[44:45]
		v_pk_fma_f32 v[64:65], v[170:171], v[40:41], v[44:45]
		v_pk_fma_f32 v[66:67], v[172:173], v[40:41], v[44:45]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[76:79], v[156:159], v[192:207]
		v_fma_f32 v59, v174, v40, v44
		v_fma_f32 v68, v175, v40, v44
		v_exp_f32_e32 v56, v56
		v_exp_f32_e32 v57, v57
		v_exp_f32_e32 v58, v58
		v_exp_f32_e32 v60, v60
		v_exp_f32_e32 v61, v61
		v_exp_f32_e32 v62, v62
		v_mfma_f32_32x32x16_bf16 v[208:223], v[84:87], v[156:159], v[208:223]
		v_exp_f32_e32 v63, v63
		v_exp_f32_e32 v64, v64
		v_exp_f32_e32 v65, v65
		v_exp_f32_e32 v66, v66
		v_exp_f32_e32 v67, v67
		v_exp_f32_e32 v59, v59
		v_exp_f32_e32 v68, v68
		v_mfma_f32_32x32x16_bf16 v[224:239], v[88:91], v[156:159], v[224:239]
		v_fma_f32 v69, v240, v40, v44
		v_fma_f32 v70, v241, v40, v44
		v_fma_f32 v71, v242, v40, v44
		v_fma_f32 v72, v243, v40, v44
		v_fma_f32 v73, v244, v40, v44
		v_fma_f32 v74, v245, v40, v44
		v_pk_fma_f32 v[76:77], v[246:247], v[40:41], v[44:45]
		v_pk_fma_f32 v[78:79], v[248:249], v[40:41], v[44:45]
		v_pk_fma_f32 v[84:85], v[250:251], v[40:41], v[44:45]
		v_pk_fma_f32 v[86:87], v[252:253], v[40:41], v[44:45]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[92:95], v[104:107], v[176:191]
		v_fma_f32 v75, v254, v40, v44
		v_fma_f32 v88, v255, v40, v44
		v_exp_f32_e32 v69, v69
		v_exp_f32_e32 v70, v70
		v_exp_f32_e32 v71, v71
		v_exp_f32_e32 v72, v72
		v_exp_f32_e32 v73, v73
		s_add_i32 m0, m0, 0x2200
		v_cvt_pk_bf16_f32 v80, v53, v54
		buffer_load_dwordx4 v42, s[20:23], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[192:207], v[96:99], v[104:107], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[100:103], v[104:107], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[108:111], v[104:107], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[112:115], v[80:83], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[116:119], v[80:83], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[120:123], v[80:83], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[124:127], v[80:83], v[224:239]
		v_exp_f32_e32 v51, v51
		v_exp_f32_e32 v52, v52
		v_exp_f32_e32 v53, v55
		s_waitcnt vmcnt(4)
		s_barrier
		v_exp_f32_e32 v54, v74
		v_exp_f32_e32 v55, v76
		v_exp_f32_e32 v74, v77
		v_exp_f32_e32 v76, v78
		v_exp_f32_e32 v77, v79
		v_exp_f32_e32 v78, v84
		v_exp_f32_e32 v79, v85
		v_exp_f32_e32 v80, v86
		v_exp_f32_e32 v81, v87
		v_exp_f32_e32 v75, v75
		v_exp_f32_e32 v82, v88
		v_add_f32_e32 v83, v51, v52
		v_add_f32_e32 v83, v83, v53
		v_add_f32_e32 v83, v83, v56
		ds_read_b128 v[84:87], v5 offset:49920
		ds_read_b128 v[88:91], v0 offset:50432
		ds_read_b128 v[92:95], v5 offset:49952
		ds_read_b128 v[96:99], v0 offset:50464
		ds_read_b128 v[100:103], v5 offset:49984
		ds_read_b128 v[104:107], v0 offset:50496
		ds_read_b128 v[108:111], v5 offset:50016
		ds_read_b128 v[112:115], v0 offset:50528
		ds_read_b128 v[116:119], v5 offset:58240
		ds_read_b128 v[120:123], v0 offset:58752
		ds_read_b128 v[124:127], v5 offset:58272
		ds_read_b128 v[128:131], v0 offset:58784
		ds_read_b128 v[132:135], v5 offset:58304
		ds_read_b128 v[136:139], v0 offset:58816
		ds_read_b128 v[140:143], v5 offset:58336
		ds_read_b128 v[144:147], v0 offset:58848
		v_add_f32_e32 v83, v83, v57
		v_add_f32_e32 v83, v83, v58
		v_cvt_pk_bf16_f32 v150, v57, v58
		v_add_f32_e32 v57, v83, v60
		v_add_f32_e32 v57, v57, v61
		v_cvt_pk_bf16_f32 v151, v60, v61
		v_add_f32_e32 v57, v57, v62
		v_add_f32_e32 v57, v57, v63
		v_cvt_pk_bf16_f32 v152, v62, v63
		v_add_f32_e32 v57, v57, v64
		v_add_f32_e32 v57, v57, v65
		v_cvt_pk_bf16_f32 v153, v64, v65
		v_add_f32_e32 v57, v57, v66
		v_add_f32_e32 v57, v57, v67
		v_cvt_pk_bf16_f32 v154, v66, v67
		v_add_f32_e32 v57, v57, v59
		v_add_f32_e32 v57, v57, v68
		v_cvt_pk_bf16_f32 v155, v59, v68
		v_add_f32_e32 v57, v57, v69
		v_add_f32_e32 v57, v57, v70
		v_cvt_pk_bf16_f32 v60, v69, v70
		v_add_f32_e32 v57, v57, v71
		v_add_f32_e32 v57, v57, v72
		v_cvt_pk_bf16_f32 v61, v71, v72
		v_add_f32_e32 v57, v57, v73
		v_add_f32_e32 v57, v57, v54
		v_cvt_pk_bf16_f32 v62, v73, v54
		v_add_f32_e32 v54, v57, v55
		v_add_f32_e32 v54, v54, v74
		v_cvt_pk_bf16_f32 v63, v55, v74
		v_add_f32_e32 v54, v54, v76
		v_add_f32_e32 v54, v54, v77
		v_add_f32_e32 v54, v54, v78
		v_add_f32_e32 v54, v54, v79
		v_cvt_pk_bf16_f32 v65, v78, v79
		v_add_f32_e32 v54, v54, v80
		v_add_f32_e32 v54, v54, v81
		v_cvt_pk_bf16_f32 v66, v80, v81
		v_add_f32_e32 v54, v54, v75
		v_add_f32_e32 v58, v54, v82
		v_cvt_pk_bf16_f32 v67, v75, v82
		v_mov_b32_e32 v59, v58
		v_add_f32_e32 v47, v47, v50
		v_cvt_pk_bf16_f32 v148, v51, v52
		v_permlane32_swap_b32_e32 v58, v59
		v_add_f32_e32 v50, v58, v59
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v51, s9, v6
		s_add_i32 m0, s10, 0x4100
		s_add_i32 s8, s9, 0x80
		buffer_load_dwordx4 v51, s[16:19], 0 offen lds
		v_add_u32_e32 v51, s8, v6
		s_add_i32 m0, m0, 0x2080
		v_cvt_pk_bf16_f32 v149, v53, v56
		buffer_load_dwordx4 v51, s[16:19], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[160:175], v[84:87], v[8:11], 0
		v_mfma_f32_32x32x16_bf16 v[240:255], v[88:91], v[8:11], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[92:95], v[12:15], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[96:99], v[12:15], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[100:103], v[16:19], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[104:107], v[16:19], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[108:111], v[20:23], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[112:115], v[20:23], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[116:119], v[24:27], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[120:123], v[24:27], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[124:127], v[28:31], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[128:131], v[28:31], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[132:135], v[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[136:139], v[32:35], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[140:143], v[36:39], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[144:147], v[36:39], v[240:255]
		s_waitcnt vmcnt(4)
		s_barrier
		ds_read_b64_tr_b16 v[52:53], v2 offset:35840
		ds_read_b64_tr_b16 v[54:55], v2 offset:35968
		ds_read_b64_tr_b16 v[56:57], v2 offset:35904
		ds_read_b64_tr_b16 v[58:59], v2 offset:36032
		ds_read_b64_tr_b16 v[68:69], v2 offset:44544
		ds_read_b64_tr_b16 v[70:71], v2 offset:44672
		ds_read_b64_tr_b16 v[72:73], v2 offset:44608
		ds_read_b64_tr_b16 v[74:75], v2 offset:44736
		ds_read_b64_tr_b16 v[80:81], v2 offset:36096
		ds_read_b64_tr_b16 v[82:83], v2 offset:36224
		ds_read_b64_tr_b16 v[84:85], v2 offset:36160
		ds_read_b64_tr_b16 v[86:87], v2 offset:36288
		ds_read_b64_tr_b16 v[88:89], v2 offset:44800
		ds_read_b64_tr_b16 v[90:91], v2 offset:44928
		ds_read_b64_tr_b16 v[92:93], v2 offset:44864
		ds_read_b64_tr_b16 v[94:95], v2 offset:44992
		ds_read_b64_tr_b16 v[96:97], v2 offset:36352
		ds_read_b64_tr_b16 v[98:99], v2 offset:36480
		ds_read_b64_tr_b16 v[100:101], v2 offset:36416
		ds_read_b64_tr_b16 v[102:103], v2 offset:36544
		ds_read_b64_tr_b16 v[104:105], v2 offset:45056
		ds_read_b64_tr_b16 v[106:107], v2 offset:45184
		ds_read_b64_tr_b16 v[108:109], v2 offset:45120
		ds_read_b64_tr_b16 v[110:111], v2 offset:45248
		ds_read_b64_tr_b16 v[112:113], v2 offset:36608
		ds_read_b64_tr_b16 v[114:115], v2 offset:36736
		ds_read_b64_tr_b16 v[116:117], v2 offset:36672
		ds_read_b64_tr_b16 v[118:119], v2 offset:36800
		ds_read_b64_tr_b16 v[120:121], v2 offset:45312
		ds_read_b64_tr_b16 v[122:123], v2 offset:45440
		ds_read_b64_tr_b16 v[124:125], v2 offset:45376
		ds_read_b64_tr_b16 v[126:127], v2 offset:45504
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[176:191], v[52:55], v[148:151], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[56:59], v[148:151], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[68:71], v[148:151], v[208:223]
		s_add_i32 m0, s3, 0x10400
		v_mfma_f32_32x32x16_bf16 v[224:239], v[72:75], v[148:151], v[224:239]
		buffer_load_dwordx4 v43, s[20:23], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[176:191], v[80:83], v[152:155], v[176:191]
		v_fma_f32 v51, v160, v40, v44
		v_fma_f32 v52, v161, v40, v44
		v_fma_f32 v53, v162, v40, v44
		v_fma_f32 v54, v163, v40, v44
		v_fma_f32 v55, v164, v40, v44
		v_fma_f32 v56, v165, v40, v44
		v_pk_fma_f32 v[58:59], v[166:167], v[40:41], v[44:45]
		v_pk_fma_f32 v[68:69], v[168:169], v[40:41], v[44:45]
		v_pk_fma_f32 v[70:71], v[170:171], v[40:41], v[44:45]
		v_pk_fma_f32 v[72:73], v[172:173], v[40:41], v[44:45]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[84:87], v[152:155], v[192:207]
		v_fma_f32 v57, v174, v40, v44
		v_fma_f32 v64, v175, v40, v44
		v_exp_f32_e32 v54, v54
		v_exp_f32_e32 v55, v55
		v_exp_f32_e32 v56, v56
		v_exp_f32_e32 v58, v58
		v_exp_f32_e32 v59, v59
		v_exp_f32_e32 v68, v68
		v_mfma_f32_32x32x16_bf16 v[208:223], v[88:91], v[152:155], v[208:223]
		v_exp_f32_e32 v69, v69
		v_exp_f32_e32 v70, v70
		v_exp_f32_e32 v71, v71
		v_exp_f32_e32 v72, v72
		v_exp_f32_e32 v73, v73
		v_exp_f32_e32 v57, v57
		v_exp_f32_e32 v74, v64
		v_mfma_f32_32x32x16_bf16 v[224:239], v[92:95], v[152:155], v[224:239]
		v_fma_f32 v64, v240, v40, v44
		v_fma_f32 v75, v241, v40, v44
		v_fma_f32 v78, v242, v40, v44
		v_fma_f32 v79, v243, v40, v44
		v_fma_f32 v80, v244, v40, v44
		v_fma_f32 v81, v245, v40, v44
		v_pk_fma_f32 v[82:83], v[246:247], v[40:41], v[44:45]
		v_pk_fma_f32 v[84:85], v[248:249], v[40:41], v[44:45]
		v_pk_fma_f32 v[86:87], v[250:251], v[40:41], v[44:45]
		v_pk_fma_f32 v[88:89], v[252:253], v[40:41], v[44:45]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[96:99], v[60:63], v[176:191]
		v_fma_f32 v90, v254, v40, v44
		v_fma_f32 v91, v255, v40, v44
		v_exp_f32_e32 v92, v64
		v_exp_f32_e32 v75, v75
		v_exp_f32_e32 v78, v78
		v_exp_f32_e32 v79, v79
		v_exp_f32_e32 v80, v80
		s_add_i32 m0, m0, 0x2200
		v_cvt_pk_bf16_f32 v64, v76, v77
		buffer_load_dwordx4 v46, s[20:23], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[192:207], v[100:103], v[60:63], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[104:107], v[60:63], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[108:111], v[60:63], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[112:115], v[64:67], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[116:119], v[64:67], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[120:123], v[64:67], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[124:127], v[64:67], v[224:239]
		v_exp_f32_e32 v51, v51
		v_exp_f32_e32 v52, v52
		v_exp_f32_e32 v53, v53
		s_waitcnt vmcnt(4)
		s_barrier
		v_exp_f32_e32 v60, v81
		v_exp_f32_e32 v61, v82
		v_exp_f32_e32 v62, v83
		v_exp_f32_e32 v63, v84
		v_exp_f32_e32 v64, v85
		v_exp_f32_e32 v65, v86
		v_exp_f32_e32 v66, v87
		v_exp_f32_e32 v67, v88
		v_exp_f32_e32 v76, v89
		v_exp_f32_e32 v77, v90
		v_exp_f32_e32 v81, v91
		v_add_f32_e32 v82, v51, v52
		v_add_f32_e32 v82, v82, v53
		v_add_f32_e32 v82, v82, v54
		ds_read_b128 v[84:87], v5
		ds_read_b128 v[88:91], v0 offset:512
		ds_read_b128 v[96:99], v5 offset:32
		ds_read_b128 v[100:103], v0 offset:544
		ds_read_b128 v[104:107], v5 offset:64
		ds_read_b128 v[108:111], v0 offset:576
		ds_read_b128 v[112:115], v5 offset:96
		ds_read_b128 v[116:119], v0 offset:608
		ds_read_b128 v[120:123], v5 offset:8320
		ds_read_b128 v[124:127], v0 offset:8832
		ds_read_b128 v[128:131], v5 offset:8352
		ds_read_b128 v[132:135], v0 offset:8864
		ds_read_b128 v[136:139], v5 offset:8384
		ds_read_b128 v[140:143], v0 offset:8896
		ds_read_b128 v[144:147], v5 offset:8416
		ds_read_b128 v[148:151], v0 offset:8928
		v_add_f32_e32 v82, v82, v55
		v_add_f32_e32 v82, v82, v56
		v_cvt_pk_bf16_f32 v154, v55, v56
		v_add_f32_e32 v55, v82, v58
		v_add_f32_e32 v55, v55, v59
		v_cvt_pk_bf16_f32 v155, v58, v59
		v_add_f32_e32 v55, v55, v68
		v_add_f32_e32 v55, v55, v69
		v_cvt_pk_bf16_f32 v156, v68, v69
		v_add_f32_e32 v55, v55, v70
		v_add_f32_e32 v55, v55, v71
		v_cvt_pk_bf16_f32 v157, v70, v71
		v_add_f32_e32 v55, v55, v72
		v_add_f32_e32 v55, v55, v73
		v_cvt_pk_bf16_f32 v158, v72, v73
		v_add_f32_e32 v55, v55, v57
		v_add_f32_e32 v55, v55, v74
		v_cvt_pk_bf16_f32 v159, v57, v74
		v_add_f32_e32 v55, v55, v92
		v_add_f32_e32 v55, v55, v75
		v_cvt_pk_bf16_f32 v56, v92, v75
		v_add_f32_e32 v55, v55, v78
		v_add_f32_e32 v55, v55, v79
		v_cvt_pk_bf16_f32 v57, v78, v79
		v_add_f32_e32 v55, v55, v80
		v_add_f32_e32 v55, v55, v60
		v_cvt_pk_bf16_f32 v58, v80, v60
		v_add_f32_e32 v55, v55, v61
		v_add_f32_e32 v55, v55, v62
		v_cvt_pk_bf16_f32 v59, v61, v62
		v_add_f32_e32 v55, v55, v63
		v_add_f32_e32 v55, v55, v64
		v_add_f32_e32 v55, v55, v65
		v_add_f32_e32 v55, v55, v66
		v_cvt_pk_bf16_f32 v69, v65, v66
		v_add_f32_e32 v55, v55, v67
		v_add_f32_e32 v55, v55, v76
		v_cvt_pk_bf16_f32 v70, v67, v76
		v_add_f32_e32 v55, v55, v77
		v_add_f32_e32 v60, v55, v81
		v_cvt_pk_bf16_f32 v71, v77, v81
		v_mov_b32_e32 v61, v60
		v_add_f32_e32 v47, v47, v50
		v_cvt_pk_bf16_f32 v152, v51, v52
		v_permlane32_swap_b32_e32 v60, v61
		v_add_f32_e32 v50, v60, v61
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v51, s12, v6
		s_add_i32 m0, s10, 0x8200
		s_add_i32 s8, s12, 0x80
		buffer_load_dwordx4 v51, s[16:19], 0 offen lds
		v_add_u32_e32 v51, s8, v6
		s_add_i32 m0, m0, 0x2080
		v_cvt_pk_bf16_f32 v153, v53, v54
		buffer_load_dwordx4 v51, s[16:19], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[160:175], v[84:87], v[8:11], 0
		v_mfma_f32_32x32x16_bf16 v[240:255], v[88:91], v[8:11], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], v[12:15], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[100:103], v[12:15], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[104:107], v[16:19], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[108:111], v[16:19], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[112:115], v[20:23], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[116:119], v[20:23], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[120:123], v[24:27], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[124:127], v[24:27], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[128:131], v[28:31], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[132:135], v[28:31], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[136:139], v[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[140:143], v[32:35], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[144:147], v[36:39], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[148:151], v[36:39], v[240:255]
		s_waitcnt vmcnt(4)
		s_barrier
		ds_read_b64_tr_b16 v[52:53], v2 offset:53248
		ds_read_b64_tr_b16 v[54:55], v2 offset:53376
		ds_read_b64_tr_b16 v[72:73], v2 offset:53312
		ds_read_b64_tr_b16 v[74:75], v2 offset:53440
		ds_read_b64_tr_b16 v[76:77], v2 offset:61952
		ds_read_b64_tr_b16 v[78:79], v2 offset:62080
		ds_read_b64_tr_b16 v[80:81], v2 offset:62016
		ds_read_b64_tr_b16 v[82:83], v2 offset:62144
		ds_read_b64_tr_b16 v[84:85], v2 offset:53504
		ds_read_b64_tr_b16 v[86:87], v2 offset:53632
		ds_read_b64_tr_b16 v[88:89], v2 offset:53568
		ds_read_b64_tr_b16 v[90:91], v2 offset:53696
		ds_read_b64_tr_b16 v[92:93], v2 offset:62208
		ds_read_b64_tr_b16 v[94:95], v2 offset:62336
		ds_read_b64_tr_b16 v[96:97], v2 offset:62272
		ds_read_b64_tr_b16 v[98:99], v2 offset:62400
		ds_read_b64_tr_b16 v[100:101], v2 offset:53760
		ds_read_b64_tr_b16 v[102:103], v2 offset:53888
		ds_read_b64_tr_b16 v[104:105], v2 offset:53824
		ds_read_b64_tr_b16 v[106:107], v2 offset:53952
		ds_read_b64_tr_b16 v[108:109], v2 offset:62464
		ds_read_b64_tr_b16 v[110:111], v2 offset:62592
		ds_read_b64_tr_b16 v[112:113], v2 offset:62528
		ds_read_b64_tr_b16 v[114:115], v2 offset:62656
		ds_read_b64_tr_b16 v[116:117], v2 offset:54016
		ds_read_b64_tr_b16 v[118:119], v2 offset:54144
		ds_read_b64_tr_b16 v[120:121], v2 offset:54080
		ds_read_b64_tr_b16 v[122:123], v2 offset:54208
		ds_read_b64_tr_b16 v[124:125], v2 offset:62720
		ds_read_b64_tr_b16 v[126:127], v2 offset:62848
		ds_read_b64_tr_b16 v[128:129], v2 offset:62784
		ds_read_b64_tr_b16 v[130:131], v2 offset:62912
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[176:191], v[52:55], v[152:155], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[72:75], v[152:155], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[76:79], v[152:155], v[208:223]
		s_add_i32 m0, s3, 0x14800
		v_mfma_f32_32x32x16_bf16 v[224:239], v[80:83], v[152:155], v[224:239]
		buffer_load_dwordx4 v48, s[20:23], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[176:191], v[84:87], v[156:159], v[176:191]
		v_fma_f32 v51, v160, v40, v44
		v_fma_f32 v52, v161, v40, v44
		v_fma_f32 v53, v162, v40, v44
		v_fma_f32 v54, v163, v40, v44
		v_fma_f32 v55, v164, v40, v44
		v_fma_f32 v60, v165, v40, v44
		v_pk_fma_f32 v[66:67], v[166:167], v[40:41], v[44:45]
		v_pk_fma_f32 v[72:73], v[168:169], v[40:41], v[44:45]
		v_pk_fma_f32 v[74:75], v[170:171], v[40:41], v[44:45]
		v_pk_fma_f32 v[76:77], v[172:173], v[40:41], v[44:45]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[88:91], v[156:159], v[192:207]
		v_fma_f32 v61, v174, v40, v44
		v_fma_f32 v62, v175, v40, v44
		v_exp_f32_e32 v54, v54
		v_exp_f32_e32 v55, v55
		v_exp_f32_e32 v60, v60
		v_exp_f32_e32 v65, v66
		v_exp_f32_e32 v66, v67
		v_exp_f32_e32 v67, v72
		v_mfma_f32_32x32x16_bf16 v[208:223], v[92:95], v[156:159], v[208:223]
		v_exp_f32_e32 v72, v73
		v_exp_f32_e32 v73, v74
		v_exp_f32_e32 v74, v75
		v_exp_f32_e32 v75, v76
		v_exp_f32_e32 v76, v77
		v_exp_f32_e32 v61, v61
		v_exp_f32_e32 v62, v62
		v_mfma_f32_32x32x16_bf16 v[224:239], v[96:99], v[156:159], v[224:239]
		v_fma_f32 v68, v240, v40, v44
		v_fma_f32 v77, v241, v40, v44
		v_fma_f32 v78, v242, v40, v44
		v_fma_f32 v79, v243, v40, v44
		v_fma_f32 v80, v244, v40, v44
		v_fma_f32 v81, v245, v40, v44
		v_pk_fma_f32 v[82:83], v[246:247], v[40:41], v[44:45]
		v_pk_fma_f32 v[84:85], v[248:249], v[40:41], v[44:45]
		v_pk_fma_f32 v[86:87], v[250:251], v[40:41], v[44:45]
		v_pk_fma_f32 v[88:89], v[252:253], v[40:41], v[44:45]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[100:103], v[56:59], v[176:191]
		v_fma_f32 v90, v254, v40, v44
		v_fma_f32 v91, v255, v40, v44
		v_exp_f32_e32 v92, v68
		v_exp_f32_e32 v77, v77
		v_exp_f32_e32 v78, v78
		v_exp_f32_e32 v79, v79
		v_exp_f32_e32 v80, v80
		s_add_i32 m0, m0, 0x2200
		v_cvt_pk_bf16_f32 v68, v63, v64
		buffer_load_dwordx4 v49, s[20:23], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[192:207], v[104:107], v[56:59], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[108:111], v[56:59], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[112:115], v[56:59], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[116:119], v[68:71], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[120:123], v[68:71], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[124:127], v[68:71], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[128:131], v[68:71], v[224:239]
		v_exp_f32_e32 v51, v51
		v_exp_f32_e32 v52, v52
		v_exp_f32_e32 v53, v53
		s_waitcnt vmcnt(4)
		s_barrier
		v_exp_f32_e32 v56, v81
		v_exp_f32_e32 v57, v82
		v_exp_f32_e32 v58, v83
		v_exp_f32_e32 v59, v84
		v_exp_f32_e32 v63, v85
		v_exp_f32_e32 v64, v86
		v_exp_f32_e32 v68, v87
		v_exp_f32_e32 v69, v88
		v_exp_f32_e32 v70, v89
		v_exp_f32_e32 v71, v90
		v_exp_f32_e32 v81, v91
		v_add_f32_e32 v82, v51, v52
		v_add_f32_e32 v82, v82, v53
		v_add_f32_e32 v82, v82, v54
		ds_read_b128 v[84:87], v5 offset:16640
		ds_read_b128 v[88:91], v0 offset:17152
		ds_read_b128 v[96:99], v5 offset:16672
		ds_read_b128 v[100:103], v0 offset:17184
		ds_read_b128 v[104:107], v5 offset:16704
		ds_read_b128 v[108:111], v0 offset:17216
		ds_read_b128 v[112:115], v5 offset:16736
		ds_read_b128 v[116:119], v0 offset:17248
		ds_read_b128 v[120:123], v5 offset:24960
		ds_read_b128 v[124:127], v0 offset:25472
		ds_read_b128 v[128:131], v5 offset:24992
		ds_read_b128 v[132:135], v0 offset:25504
		ds_read_b128 v[136:139], v5 offset:25024
		ds_read_b128 v[140:143], v0 offset:25536
		ds_read_b128 v[144:147], v5 offset:25056
		ds_read_b128 v[148:151], v0 offset:25568
		v_add_f32_e32 v82, v82, v55
		v_add_f32_e32 v82, v82, v60
		v_cvt_pk_bf16_f32 v154, v55, v60
		v_add_f32_e32 v55, v82, v65
		v_add_f32_e32 v55, v55, v66
		v_cvt_pk_bf16_f32 v155, v65, v66
		v_add_f32_e32 v55, v55, v67
		v_add_f32_e32 v55, v55, v72
		v_cvt_pk_bf16_f32 v156, v67, v72
		v_add_f32_e32 v55, v55, v73
		v_add_f32_e32 v55, v55, v74
		v_cvt_pk_bf16_f32 v157, v73, v74
		v_add_f32_e32 v55, v55, v75
		v_add_f32_e32 v55, v55, v76
		v_cvt_pk_bf16_f32 v158, v75, v76
		v_add_f32_e32 v55, v55, v61
		v_add_f32_e32 v55, v55, v62
		v_cvt_pk_bf16_f32 v159, v61, v62
		v_add_f32_e32 v55, v55, v92
		v_add_f32_e32 v55, v55, v77
		v_cvt_pk_bf16_f32 v72, v92, v77
		v_add_f32_e32 v55, v55, v78
		v_add_f32_e32 v55, v55, v79
		v_cvt_pk_bf16_f32 v73, v78, v79
		v_add_f32_e32 v55, v55, v80
		v_add_f32_e32 v55, v55, v56
		v_cvt_pk_bf16_f32 v74, v80, v56
		v_add_f32_e32 v55, v55, v57
		v_add_f32_e32 v55, v55, v58
		v_cvt_pk_bf16_f32 v75, v57, v58
		v_add_f32_e32 v55, v55, v59
		v_add_f32_e32 v55, v55, v63
		v_cvt_pk_bf16_f32 v76, v59, v63
		v_add_f32_e32 v55, v55, v64
		v_add_f32_e32 v55, v55, v68
		v_cvt_pk_bf16_f32 v77, v64, v68
		v_add_f32_e32 v55, v55, v69
		v_add_f32_e32 v55, v55, v70
		v_cvt_pk_bf16_f32 v78, v69, v70
		v_add_f32_e32 v55, v55, v71
		v_add_f32_e32 v56, v55, v81
		v_cvt_pk_bf16_f32 v79, v71, v81
		v_mov_b32_e32 v57, v56
		v_add_f32_e32 v47, v47, v50
		v_cvt_pk_bf16_f32 v152, v51, v52
		v_permlane32_swap_b32_e32 v56, v57
		v_add_f32_e32 v50, v56, v57
		v_add_f32_e32 v47, v47, v50
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 m0, s10, 0xc300
		s_lshl_b32 s8, s11, 14
		v_add_u32_e32 v50, s8, v6
		s_add_i32 s8, s8, 0x80
		buffer_load_dwordx4 v50, s[16:19], 0 offen lds
		v_add_u32_e32 v50, s8, v6
		s_add_i32 m0, m0, 0x2080
		v_cvt_pk_bf16_f32 v153, v53, v54
		buffer_load_dwordx4 v50, s[16:19], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[160:175], v[84:87], v[8:11], 0
		v_mfma_f32_32x32x16_bf16 v[240:255], v[88:91], v[8:11], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], v[12:15], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[100:103], v[12:15], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[104:107], v[16:19], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[108:111], v[16:19], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[112:115], v[20:23], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[116:119], v[20:23], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[120:123], v[24:27], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[124:127], v[24:27], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[128:131], v[28:31], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[132:135], v[28:31], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[136:139], v[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[140:143], v[32:35], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[144:147], v[36:39], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[148:151], v[36:39], v[240:255]
		s_waitcnt vmcnt(4)
		s_barrier
		ds_read_b64_tr_b16 v[52:53], v2 offset:1024
		ds_read_b64_tr_b16 v[54:55], v2 offset:1152
		ds_read_b64_tr_b16 v[56:57], v2 offset:1088
		ds_read_b64_tr_b16 v[58:59], v2 offset:1216
		ds_read_b64_tr_b16 v[60:61], v2 offset:9728
		ds_read_b64_tr_b16 v[62:63], v2 offset:9856
		ds_read_b64_tr_b16 v[64:65], v2 offset:9792
		ds_read_b64_tr_b16 v[66:67], v2 offset:9920
		ds_read_b64_tr_b16 v[68:69], v2 offset:1280
		ds_read_b64_tr_b16 v[70:71], v2 offset:1408
		ds_read_b64_tr_b16 v[80:81], v2 offset:1344
		ds_read_b64_tr_b16 v[82:83], v2 offset:1472
		ds_read_b64_tr_b16 v[84:85], v2 offset:9984
		ds_read_b64_tr_b16 v[86:87], v2 offset:10112
		ds_read_b64_tr_b16 v[88:89], v2 offset:10048
		ds_read_b64_tr_b16 v[90:91], v2 offset:10176
		ds_read_b64_tr_b16 v[112:113], v2 offset:1536
		ds_read_b64_tr_b16 v[114:115], v2 offset:1664
		ds_read_b64_tr_b16 v[116:117], v2 offset:1600
		ds_read_b64_tr_b16 v[118:119], v2 offset:1728
		ds_read_b64_tr_b16 v[120:121], v2 offset:10240
		ds_read_b64_tr_b16 v[122:123], v2 offset:10368
		ds_read_b64_tr_b16 v[124:125], v2 offset:10304
		ds_read_b64_tr_b16 v[126:127], v2 offset:10432
		ds_read_b64_tr_b16 v[128:129], v2 offset:1792
		ds_read_b64_tr_b16 v[130:131], v2 offset:1920
		ds_read_b64_tr_b16 v[132:133], v2 offset:1856
		ds_read_b64_tr_b16 v[134:135], v2 offset:1984
		ds_read_b64_tr_b16 v[136:137], v2 offset:10496
		ds_read_b64_tr_b16 v[138:139], v2 offset:10624
		ds_read_b64_tr_b16 v[140:141], v2 offset:10560
		ds_read_b64_tr_b16 v[142:143], v2 offset:10688
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[176:191], v[52:55], v[152:155], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[56:59], v[152:155], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[60:63], v[152:155], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[64:67], v[152:155], v[224:239]
		v_fma_f32 v50, v160, v40, v44
		v_fma_f32 v51, v161, v40, v44
		v_fma_f32 v52, v162, v40, v44
		v_fma_f32 v53, v163, v40, v44
		v_fma_f32 v54, v164, v40, v44
		v_fma_f32 v55, v165, v40, v44
		v_pk_fma_f32 v[56:57], v[166:167], v[40:41], v[44:45]
		v_pk_fma_f32 v[58:59], v[168:169], v[40:41], v[44:45]
		v_pk_fma_f32 v[60:61], v[170:171], v[40:41], v[44:45]
		v_pk_fma_f32 v[62:63], v[172:173], v[40:41], v[44:45]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[68:71], v[156:159], v[176:191]
		v_fma_f32 v64, v174, v40, v44
		v_fma_f32 v65, v175, v40, v44
		v_exp_f32_e32 v96, v50
		v_exp_f32_e32 v97, v51
		v_exp_f32_e32 v98, v52
		v_exp_f32_e32 v99, v53
		v_exp_f32_e32 v100, v54
		v_exp_f32_e32 v101, v55
		v_mfma_f32_32x32x16_bf16 v[192:207], v[80:83], v[156:159], v[192:207]
		v_exp_f32_e32 v102, v56
		v_exp_f32_e32 v103, v57
		v_exp_f32_e32 v104, v58
		v_exp_f32_e32 v105, v59
		v_exp_f32_e32 v106, v60
		v_exp_f32_e32 v107, v61
		v_exp_f32_e32 v108, v62
		v_mfma_f32_32x32x16_bf16 v[208:223], v[84:87], v[156:159], v[208:223]
		v_exp_f32_e32 v109, v63
		v_exp_f32_e32 v110, v64
		v_exp_f32_e32 v111, v65
		v_pk_fma_f32 v[50:51], v[240:241], v[40:41], v[44:45]
		v_pk_fma_f32 v[52:53], v[242:243], v[40:41], v[44:45]
		v_pk_fma_f32 v[54:55], v[244:245], v[40:41], v[44:45]
		v_pk_fma_f32 v[86:87], v[246:247], v[40:41], v[44:45]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[88:91], v[156:159], v[224:239]
		v_fma_f32 v88, v248, v40, v44
		v_fma_f32 v89, v249, v40, v44
		v_fma_f32 v90, v250, v40, v44
		v_fma_f32 v91, v251, v40, v44
		v_fma_f32 v92, v252, v40, v44
		v_fma_f32 v93, v253, v40, v44
		v_pk_fma_f32 v[94:95], v[254:255], v[40:41], v[44:45]
		v_exp_f32_e32 v80, v50
		v_exp_f32_e32 v81, v51
		v_exp_f32_e32 v82, v52
		v_mfma_f32_32x32x16_bf16 v[176:191], v[112:115], v[72:75], v[176:191]
		v_exp_f32_e32 v83, v53
		v_exp_f32_e32 v84, v54
		s_add_u32 s20, s20, 0x10000
		s_addc_u32 s21, s21, 0
		s_cmp_lt_i32 s1, 0x7e
		v_mfma_f32_32x32x16_bf16 v[192:207], v[116:119], v[72:75], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[120:123], v[72:75], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[124:127], v[72:75], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[128:131], v[76:79], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[132:135], v[76:79], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[136:139], v[76:79], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[140:143], v[76:79], v[224:239]
		v_mov_b32_e32 v85, v55
		s_cbranch_scc1 .Lflash_attention_bf16_gfx950.loop_head_1
.Lflash_attention_bf16_gfx950.loop_exit_1:
.Lflash_attention_bf16_gfx950.if_end_1:
		s_add_i32 m0, s3, 0x18c00
		s_mov_b32 s1, 0x1f8000
		buffer_load_dwordx4 v6, s[4:7], s1 offen lds
		s_mov_b32 s1, 0x1f8080
		s_add_i32 m0, m0, 0x2200
		s_mov_b32 s26, s18
		buffer_load_dwordx4 v6, s[4:7], s1 offen lds
		s_waitcnt vmcnt(4)
		s_barrier
		ds_read_b128 v[48:51], v5 offset:33280
		ds_read_b128 v[52:55], v0 offset:33792
		ds_read_b128 v[56:59], v5 offset:33312
		ds_read_b128 v[60:63], v0 offset:33824
		ds_read_b128 v[64:67], v5 offset:33344
		ds_read_b128 v[68:71], v0 offset:33856
		ds_read_b128 v[72:75], v5 offset:33376
		ds_read_b128 v[76:79], v0 offset:33888
		ds_read_b128 v[112:115], v5 offset:41600
		ds_read_b128 v[116:119], v0 offset:42112
		ds_read_b128 v[120:123], v5 offset:41632
		ds_read_b128 v[124:127], v0 offset:42144
		ds_read_b128 v[128:131], v5 offset:41664
		ds_read_b128 v[132:135], v0 offset:42176
		ds_read_b128 v[136:139], v5 offset:41696
		ds_read_b128 v[140:143], v0 offset:42208
		v_exp_f32_e32 v3, v85
		v_exp_f32_e32 v4, v86
		v_exp_f32_e32 v7, v87
		v_exp_f32_e32 v42, v88
		v_exp_f32_e32 v43, v89
		v_exp_f32_e32 v46, v90
		v_exp_f32_e32 v85, v91
		v_exp_f32_e32 v86, v92
		v_exp_f32_e32 v87, v93
		v_exp_f32_e32 v88, v94
		v_exp_f32_e32 v89, v95
		v_add_f32_e32 v90, v96, v97
		v_add_f32_e32 v90, v90, v98
		v_add_f32_e32 v90, v90, v99
		v_add_f32_e32 v90, v90, v100
		v_add_f32_e32 v90, v90, v101
		v_cvt_pk_bf16_f32 v94, v100, v101
		v_add_f32_e32 v90, v90, v102
		v_add_f32_e32 v90, v90, v103
		v_cvt_pk_bf16_f32 v95, v102, v103
		v_add_f32_e32 v90, v90, v104
		v_add_f32_e32 v90, v90, v105
		v_cvt_pk_bf16_f32 v100, v104, v105
		v_add_f32_e32 v90, v90, v106
		v_add_f32_e32 v90, v90, v107
		v_cvt_pk_bf16_f32 v101, v106, v107
		v_add_f32_e32 v90, v90, v108
		v_add_f32_e32 v90, v90, v109
		v_cvt_pk_bf16_f32 v102, v108, v109
		v_add_f32_e32 v90, v90, v110
		v_add_f32_e32 v90, v90, v111
		v_cvt_pk_bf16_f32 v103, v110, v111
		v_add_f32_e32 v90, v90, v80
		v_add_f32_e32 v90, v90, v81
		v_cvt_pk_bf16_f32 v104, v80, v81
		v_add_f32_e32 v80, v90, v82
		v_add_f32_e32 v80, v80, v83
		v_cvt_pk_bf16_f32 v105, v82, v83
		v_add_f32_e32 v80, v80, v84
		v_add_f32_e32 v80, v80, v3
		v_cvt_pk_bf16_f32 v106, v84, v3
		v_add_f32_e32 v3, v80, v4
		v_add_f32_e32 v3, v3, v7
		v_cvt_pk_bf16_f32 v107, v4, v7
		v_add_f32_e32 v3, v3, v42
		v_add_f32_e32 v3, v3, v43
		v_cvt_pk_bf16_f32 v80, v42, v43
		v_add_f32_e32 v3, v3, v46
		v_add_f32_e32 v3, v3, v85
		v_cvt_pk_bf16_f32 v81, v46, v85
		v_add_f32_e32 v3, v3, v86
		v_add_f32_e32 v3, v3, v87
		v_cvt_pk_bf16_f32 v82, v86, v87
		v_add_f32_e32 v3, v3, v88
		v_add_f32_e32 v42, v3, v89
		v_cvt_pk_bf16_f32 v83, v88, v89
		v_mov_b32_e32 v43, v42
		v_cvt_pk_bf16_f32 v92, v96, v97
		v_cvt_pk_bf16_f32 v93, v98, v99
		v_permlane32_swap_b32_e32 v42, v43
		v_add_f32_e32 v3, v42, v43
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[144:159], v[48:51], v[8:11], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[52:55], v[8:11], 0
		v_mfma_f32_32x32x16_bf16 v[144:159], v[56:59], v[12:15], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[60:63], v[12:15], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[144:159], v[64:67], v[16:19], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[68:71], v[16:19], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[144:159], v[72:75], v[20:23], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[76:79], v[20:23], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[144:159], v[112:115], v[24:27], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[116:119], v[24:27], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[144:159], v[120:123], v[28:31], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[124:127], v[28:31], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[144:159], v[128:131], v[32:35], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[132:135], v[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[144:159], v[136:139], v[36:39], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[140:143], v[36:39], v[160:175]
		s_waitcnt vmcnt(2)
		s_barrier
		ds_read_b64_tr_b16 v[48:49], v2 offset:18432
		ds_read_b64_tr_b16 v[50:51], v2 offset:18560
		ds_read_b64_tr_b16 v[52:53], v2 offset:18496
		ds_read_b64_tr_b16 v[54:55], v2 offset:18624
		ds_read_b64_tr_b16 v[56:57], v2 offset:27136
		ds_read_b64_tr_b16 v[58:59], v2 offset:27264
		ds_read_b64_tr_b16 v[60:61], v2 offset:27200
		ds_read_b64_tr_b16 v[62:63], v2 offset:27328
		ds_read_b64_tr_b16 v[64:65], v2 offset:18688
		ds_read_b64_tr_b16 v[66:67], v2 offset:18816
		ds_read_b64_tr_b16 v[68:69], v2 offset:18752
		ds_read_b64_tr_b16 v[70:71], v2 offset:18880
		ds_read_b64_tr_b16 v[72:73], v2 offset:27392
		ds_read_b64_tr_b16 v[74:75], v2 offset:27520
		ds_read_b64_tr_b16 v[76:77], v2 offset:27456
		ds_read_b64_tr_b16 v[78:79], v2 offset:27584
		ds_read_b64_tr_b16 v[84:85], v2 offset:18944
		ds_read_b64_tr_b16 v[86:87], v2 offset:19072
		ds_read_b64_tr_b16 v[88:89], v2 offset:19008
		ds_read_b64_tr_b16 v[90:91], v2 offset:19136
		ds_read_b64_tr_b16 v[96:97], v2 offset:27648
		ds_read_b64_tr_b16 v[98:99], v2 offset:27776
		ds_read_b64_tr_b16 v[108:109], v2 offset:27712
		ds_read_b64_tr_b16 v[110:111], v2 offset:27840
		ds_read_b64_tr_b16 v[112:113], v2 offset:19200
		ds_read_b64_tr_b16 v[114:115], v2 offset:19328
		ds_read_b64_tr_b16 v[116:117], v2 offset:19264
		ds_read_b64_tr_b16 v[118:119], v2 offset:19392
		ds_read_b64_tr_b16 v[120:121], v2 offset:27904
		ds_read_b64_tr_b16 v[122:123], v2 offset:28032
		ds_read_b64_tr_b16 v[124:125], v2 offset:27968
		ds_read_b64_tr_b16 v[126:127], v2 offset:28096
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[176:191], v[48:51], v[92:95], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[52:55], v[92:95], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[56:59], v[92:95], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[60:63], v[92:95], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[64:67], v[100:103], v[176:191]
		s_add_i32 m0, m0, 0x2200
		v_mfma_f32_32x32x16_bf16 v[192:207], v[68:71], v[100:103], v[192:207]
		s_mov_b32 s1, 0x1fc000
		v_mfma_f32_32x32x16_bf16 v[208:223], v[72:75], v[100:103], v[208:223]
		buffer_load_dwordx4 v6, s[4:7], s1 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], v[76:79], v[100:103], v[224:239]
		s_add_i32 m0, m0, 0x2200
		v_mfma_f32_32x32x16_bf16 v[176:191], v[84:87], v[104:107], v[176:191]
		s_mov_b32 s1, 0x1fc080
		v_mfma_f32_32x32x16_bf16 v[192:207], v[88:91], v[104:107], v[192:207]
		buffer_load_dwordx4 v6, s[4:7], s1 offen lds
		v_mfma_f32_32x32x16_bf16 v[208:223], v[96:99], v[104:107], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[108:111], v[104:107], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[112:115], v[80:83], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[116:119], v[80:83], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[120:123], v[80:83], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[124:127], v[80:83], v[224:239]
		v_fma_f32 v4, v144, v40, v44
		v_fma_f32 v6, v145, v40, v44
		v_fma_f32 v7, v146, v40, v44
		v_fma_f32 v42, v147, v40, v44
		v_fma_f32 v43, v148, v40, v44
		v_fma_f32 v46, v149, v40, v44
		v_pk_fma_f32 v[48:49], v[150:151], v[40:41], v[44:45]
		v_pk_fma_f32 v[50:51], v[152:153], v[40:41], v[44:45]
		v_pk_fma_f32 v[52:53], v[154:155], v[40:41], v[44:45]
		v_pk_fma_f32 v[54:55], v[156:157], v[40:41], v[44:45]
		v_pk_fma_f32 v[56:57], v[158:159], v[40:41], v[44:45]
		v_exp_f32_e32 v4, v4
		v_exp_f32_e32 v6, v6
		v_exp_f32_e32 v7, v7
		v_exp_f32_e32 v42, v42
		v_exp_f32_e32 v43, v43
		v_exp_f32_e32 v46, v46
		v_exp_f32_e32 v48, v48
		v_exp_f32_e32 v49, v49
		v_exp_f32_e32 v50, v50
		v_exp_f32_e32 v51, v51
		v_exp_f32_e32 v52, v52
		v_exp_f32_e32 v53, v53
		v_exp_f32_e32 v54, v54
		v_exp_f32_e32 v55, v55
		v_exp_f32_e32 v56, v56
		v_exp_f32_e32 v57, v57
		v_pk_fma_f32 v[58:59], v[160:161], v[40:41], v[44:45]
		v_pk_fma_f32 v[60:61], v[162:163], v[40:41], v[44:45]
		v_pk_fma_f32 v[62:63], v[164:165], v[40:41], v[44:45]
		v_pk_fma_f32 v[64:65], v[166:167], v[40:41], v[44:45]
		v_pk_fma_f32 v[66:67], v[168:169], v[40:41], v[44:45]
		v_pk_fma_f32 v[68:69], v[170:171], v[40:41], v[44:45]
		v_pk_fma_f32 v[70:71], v[172:173], v[40:41], v[44:45]
		v_pk_fma_f32 v[72:73], v[174:175], v[40:41], v[44:45]
		v_exp_f32_e32 v58, v58
		v_exp_f32_e32 v59, v59
		v_exp_f32_e32 v60, v60
		v_exp_f32_e32 v61, v61
		v_exp_f32_e32 v62, v62
		s_waitcnt vmcnt(2)
		s_barrier
		ds_read_b128 v[76:79], v5 offset:49920
		ds_read_b128 v[80:83], v0 offset:50432
		ds_read_b128 v[84:87], v5 offset:49952
		ds_read_b128 v[88:91], v0 offset:50464
		ds_read_b128 v[92:95], v5 offset:49984
		ds_read_b128 v[96:99], v0 offset:50496
		ds_read_b128 v[100:103], v5 offset:50016
		ds_read_b128 v[104:107], v0 offset:50528
		ds_read_b128 v[108:111], v5 offset:58240
		ds_read_b128 v[112:115], v0 offset:58752
		ds_read_b128 v[116:119], v5 offset:58272
		ds_read_b128 v[120:123], v0 offset:58784
		ds_read_b128 v[124:127], v5 offset:58304
		ds_read_b128 v[128:131], v0 offset:58816
		ds_read_b128 v[132:135], v5 offset:58336
		ds_read_b128 v[136:139], v0 offset:58848
		v_exp_f32_e32 v0, v63
		v_exp_f32_e32 v5, v64
		v_exp_f32_e32 v63, v65
		v_exp_f32_e32 v64, v66
		v_exp_f32_e32 v65, v67
		v_exp_f32_e32 v66, v68
		v_exp_f32_e32 v67, v69
		v_exp_f32_e32 v68, v70
		v_exp_f32_e32 v69, v71
		v_exp_f32_e32 v70, v72
		v_exp_f32_e32 v71, v73
		v_add_f32_e32 v72, v4, v6
		v_add_f32_e32 v72, v72, v7
		v_add_f32_e32 v72, v72, v42
		v_cvt_pk_bf16_f32 v141, v7, v42
		v_add_f32_e32 v7, v72, v43
		v_add_f32_e32 v7, v7, v46
		v_cvt_pk_bf16_f32 v142, v43, v46
		v_add_f32_e32 v7, v7, v48
		v_add_f32_e32 v7, v7, v49
		v_cvt_pk_bf16_f32 v143, v48, v49
		v_add_f32_e32 v7, v7, v50
		v_add_f32_e32 v7, v7, v51
		v_cvt_pk_bf16_f32 v72, v50, v51
		v_add_f32_e32 v7, v7, v52
		v_add_f32_e32 v7, v7, v53
		v_cvt_pk_bf16_f32 v73, v52, v53
		v_add_f32_e32 v7, v7, v54
		v_add_f32_e32 v7, v7, v55
		v_cvt_pk_bf16_f32 v74, v54, v55
		v_add_f32_e32 v7, v7, v56
		v_add_f32_e32 v7, v7, v57
		v_cvt_pk_bf16_f32 v75, v56, v57
		v_add_f32_e32 v7, v7, v58
		v_add_f32_e32 v7, v7, v59
		v_cvt_pk_bf16_f32 v48, v58, v59
		v_add_f32_e32 v7, v7, v60
		v_add_f32_e32 v7, v7, v61
		v_cvt_pk_bf16_f32 v49, v60, v61
		v_add_f32_e32 v7, v7, v62
		v_add_f32_e32 v7, v7, v0
		v_cvt_pk_bf16_f32 v50, v62, v0
		v_add_f32_e32 v0, v7, v5
		v_add_f32_e32 v0, v0, v63
		v_cvt_pk_bf16_f32 v51, v5, v63
		v_add_f32_e32 v0, v0, v64
		v_add_f32_e32 v0, v0, v65
		v_cvt_pk_bf16_f32 v52, v64, v65
		v_add_f32_e32 v0, v0, v66
		v_add_f32_e32 v0, v0, v67
		v_cvt_pk_bf16_f32 v53, v66, v67
		v_add_f32_e32 v0, v0, v68
		v_add_f32_e32 v0, v0, v69
		v_cvt_pk_bf16_f32 v54, v68, v69
		v_add_f32_e32 v0, v0, v70
		v_add_f32_e32 v42, v0, v71
		v_cvt_pk_bf16_f32 v55, v70, v71
		v_mov_b32_e32 v43, v42
		v_add_f32_e32 v0, v47, v3
		v_cvt_pk_bf16_f32 v140, v4, v6
		v_permlane32_swap_b32_e32 v42, v43
		v_add_f32_e32 v3, v42, v43
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[144:159], v[76:79], v[8:11], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[80:83], v[8:11], 0
		v_mfma_f32_32x32x16_bf16 v[144:159], v[84:87], v[12:15], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[88:91], v[12:15], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[144:159], v[92:95], v[16:19], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], v[16:19], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[144:159], v[100:103], v[20:23], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[104:107], v[20:23], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[144:159], v[108:111], v[24:27], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[112:115], v[24:27], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[144:159], v[116:119], v[28:31], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[120:123], v[28:31], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[144:159], v[124:127], v[32:35], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[128:131], v[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[144:159], v[132:135], v[36:39], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[136:139], v[36:39], v[160:175]
		s_barrier
		ds_read_b64_tr_b16 v[4:5], v2 offset:35840
		ds_read_b64_tr_b16 v[6:7], v2 offset:35968
		ds_read_b64_tr_b16 v[8:9], v2 offset:35904
		ds_read_b64_tr_b16 v[10:11], v2 offset:36032
		ds_read_b64_tr_b16 v[12:13], v2 offset:44544
		ds_read_b64_tr_b16 v[14:15], v2 offset:44672
		ds_read_b64_tr_b16 v[16:17], v2 offset:44608
		ds_read_b64_tr_b16 v[18:19], v2 offset:44736
		ds_read_b64_tr_b16 v[20:21], v2 offset:36096
		ds_read_b64_tr_b16 v[22:23], v2 offset:36224
		ds_read_b64_tr_b16 v[24:25], v2 offset:36160
		ds_read_b64_tr_b16 v[26:27], v2 offset:36288
		ds_read_b64_tr_b16 v[28:29], v2 offset:44800
		ds_read_b64_tr_b16 v[30:31], v2 offset:44928
		ds_read_b64_tr_b16 v[32:33], v2 offset:44864
		ds_read_b64_tr_b16 v[34:35], v2 offset:44992
		ds_read_b64_tr_b16 v[36:37], v2 offset:36352
		ds_read_b64_tr_b16 v[38:39], v2 offset:36480
		ds_read_b64_tr_b16 v[56:57], v2 offset:36416
		ds_read_b64_tr_b16 v[58:59], v2 offset:36544
		ds_read_b64_tr_b16 v[60:61], v2 offset:45056
		ds_read_b64_tr_b16 v[62:63], v2 offset:45184
		ds_read_b64_tr_b16 v[64:65], v2 offset:45120
		ds_read_b64_tr_b16 v[66:67], v2 offset:45248
		ds_read_b64_tr_b16 v[68:69], v2 offset:36608
		ds_read_b64_tr_b16 v[70:71], v2 offset:36736
		ds_read_b64_tr_b16 v[76:77], v2 offset:36672
		ds_read_b64_tr_b16 v[78:79], v2 offset:36800
		ds_read_b64_tr_b16 v[80:81], v2 offset:45312
		ds_read_b64_tr_b16 v[82:83], v2 offset:45440
		ds_read_b64_tr_b16 v[84:85], v2 offset:45376
		ds_read_b64_tr_b16 v[86:87], v2 offset:45504
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[176:191], v[4:7], v[140:143], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[8:11], v[140:143], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[12:15], v[140:143], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[16:19], v[140:143], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[20:23], v[72:75], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[24:27], v[72:75], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[28:31], v[72:75], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[32:35], v[72:75], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[36:39], v[48:51], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[56:59], v[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[60:63], v[48:51], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[64:67], v[48:51], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[68:71], v[52:55], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[76:79], v[52:55], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[80:83], v[52:55], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[84:87], v[52:55], v[224:239]
		v_fma_f32 v4, v144, v40, v44
		v_fma_f32 v5, v145, v40, v44
		v_fma_f32 v6, v146, v40, v44
		v_fma_f32 v7, v147, v40, v44
		v_fma_f32 v8, v148, v40, v44
		v_fma_f32 v9, v149, v40, v44
		v_pk_fma_f32 v[10:11], v[150:151], v[40:41], v[44:45]
		v_pk_fma_f32 v[12:13], v[152:153], v[40:41], v[44:45]
		v_pk_fma_f32 v[14:15], v[154:155], v[40:41], v[44:45]
		v_pk_fma_f32 v[16:17], v[156:157], v[40:41], v[44:45]
		v_pk_fma_f32 v[18:19], v[158:159], v[40:41], v[44:45]
		v_exp_f32_e32 v4, v4
		v_exp_f32_e32 v5, v5
		v_exp_f32_e32 v6, v6
		v_exp_f32_e32 v7, v7
		v_exp_f32_e32 v8, v8
		v_exp_f32_e32 v9, v9
		v_exp_f32_e32 v10, v10
		v_exp_f32_e32 v11, v11
		v_exp_f32_e32 v12, v12
		v_exp_f32_e32 v13, v13
		v_exp_f32_e32 v14, v14
		v_exp_f32_e32 v15, v15
		v_exp_f32_e32 v16, v16
		v_exp_f32_e32 v17, v17
		v_exp_f32_e32 v18, v18
		v_exp_f32_e32 v19, v19
		v_pk_fma_f32 v[20:21], v[160:161], v[40:41], v[44:45]
		v_pk_fma_f32 v[22:23], v[162:163], v[40:41], v[44:45]
		v_pk_fma_f32 v[24:25], v[164:165], v[40:41], v[44:45]
		v_pk_fma_f32 v[26:27], v[166:167], v[40:41], v[44:45]
		v_pk_fma_f32 v[28:29], v[168:169], v[40:41], v[44:45]
		v_pk_fma_f32 v[30:31], v[170:171], v[40:41], v[44:45]
		v_pk_fma_f32 v[32:33], v[172:173], v[40:41], v[44:45]
		v_pk_fma_f32 v[34:35], v[174:175], v[40:41], v[44:45]
		v_exp_f32_e32 v20, v20
		v_exp_f32_e32 v21, v21
		v_exp_f32_e32 v22, v22
		v_exp_f32_e32 v23, v23
		v_exp_f32_e32 v24, v24
		v_exp_f32_e32 v25, v25
		v_exp_f32_e32 v26, v26
		v_exp_f32_e32 v27, v27
		v_exp_f32_e32 v28, v28
		v_exp_f32_e32 v29, v29
		v_exp_f32_e32 v30, v30
		v_exp_f32_e32 v31, v31
		v_exp_f32_e32 v32, v32
		v_exp_f32_e32 v33, v33
		v_exp_f32_e32 v34, v34
		v_exp_f32_e32 v35, v35
		v_add_f32_e32 v36, v4, v5
		v_add_f32_e32 v36, v36, v6
		v_add_f32_e32 v36, v36, v7
		v_cvt_pk_bf16_f32 v41, v6, v7
		v_add_f32_e32 v6, v36, v8
		v_add_f32_e32 v6, v6, v9
		v_cvt_pk_bf16_f32 v42, v8, v9
		v_add_f32_e32 v6, v6, v10
		v_add_f32_e32 v6, v6, v11
		v_cvt_pk_bf16_f32 v43, v10, v11
		v_add_f32_e32 v6, v6, v12
		v_add_f32_e32 v6, v6, v13
		v_cvt_pk_bf16_f32 v8, v12, v13
		v_add_f32_e32 v6, v6, v14
		v_add_f32_e32 v6, v6, v15
		v_cvt_pk_bf16_f32 v9, v14, v15
		v_add_f32_e32 v6, v6, v16
		v_add_f32_e32 v6, v6, v17
		v_cvt_pk_bf16_f32 v10, v16, v17
		v_add_f32_e32 v6, v6, v18
		v_add_f32_e32 v6, v6, v19
		v_cvt_pk_bf16_f32 v11, v18, v19
		v_add_f32_e32 v6, v6, v20
		v_add_f32_e32 v6, v6, v21
		v_cvt_pk_bf16_f32 v12, v20, v21
		v_add_f32_e32 v6, v6, v22
		v_add_f32_e32 v6, v6, v23
		v_cvt_pk_bf16_f32 v13, v22, v23
		v_add_f32_e32 v6, v6, v24
		v_add_f32_e32 v6, v6, v25
		v_cvt_pk_bf16_f32 v14, v24, v25
		v_add_f32_e32 v6, v6, v26
		v_add_f32_e32 v6, v6, v27
		v_cvt_pk_bf16_f32 v15, v26, v27
		v_add_f32_e32 v6, v6, v28
		v_add_f32_e32 v6, v6, v29
		v_cvt_pk_bf16_f32 v16, v28, v29
		v_add_f32_e32 v6, v6, v30
		v_add_f32_e32 v6, v6, v31
		v_cvt_pk_bf16_f32 v17, v30, v31
		v_add_f32_e32 v6, v6, v32
		v_add_f32_e32 v6, v6, v33
		v_cvt_pk_bf16_f32 v18, v32, v33
		v_add_f32_e32 v6, v6, v34
		v_add_f32_e32 v20, v6, v35
		v_cvt_pk_bf16_f32 v19, v34, v35
		v_mov_b32_e32 v21, v20
		v_add_f32_e32 v0, v0, v3
		v_cvt_pk_bf16_f32 v40, v4, v5
		v_permlane32_swap_b32_e32 v20, v21
		v_add_f32_e32 v3, v20, v21
		v_add_f32_e32 v0, v0, v3
		s_waitcnt vmcnt(0)
		s_barrier
		ds_read_b64_tr_b16 v[4:5], v2 offset:53248
		ds_read_b64_tr_b16 v[6:7], v2 offset:53376
		ds_read_b64_tr_b16 v[20:21], v2 offset:53312
		ds_read_b64_tr_b16 v[22:23], v2 offset:53440
		ds_read_b64_tr_b16 v[24:25], v2 offset:61952
		ds_read_b64_tr_b16 v[26:27], v2 offset:62080
		ds_read_b64_tr_b16 v[28:29], v2 offset:62016
		ds_read_b64_tr_b16 v[30:31], v2 offset:62144
		ds_read_b64_tr_b16 v[32:33], v2 offset:53504
		ds_read_b64_tr_b16 v[34:35], v2 offset:53632
		ds_read_b64_tr_b16 v[36:37], v2 offset:53568
		ds_read_b64_tr_b16 v[38:39], v2 offset:53696
		ds_read_b64_tr_b16 v[44:45], v2 offset:62208
		ds_read_b64_tr_b16 v[46:47], v2 offset:62336
		ds_read_b64_tr_b16 v[48:49], v2 offset:62272
		ds_read_b64_tr_b16 v[50:51], v2 offset:62400
		ds_read_b64_tr_b16 v[52:53], v2 offset:53760
		ds_read_b64_tr_b16 v[54:55], v2 offset:53888
		ds_read_b64_tr_b16 v[56:57], v2 offset:53824
		ds_read_b64_tr_b16 v[58:59], v2 offset:53952
		ds_read_b64_tr_b16 v[60:61], v2 offset:62464
		ds_read_b64_tr_b16 v[62:63], v2 offset:62592
		ds_read_b64_tr_b16 v[64:65], v2 offset:62528
		ds_read_b64_tr_b16 v[66:67], v2 offset:62656
		ds_read_b64_tr_b16 v[68:69], v2 offset:54016
		ds_read_b64_tr_b16 v[70:71], v2 offset:54144
		ds_read_b64_tr_b16 v[72:73], v2 offset:54080
		ds_read_b64_tr_b16 v[74:75], v2 offset:54208
		ds_read_b64_tr_b16 v[76:77], v2 offset:62720
		ds_read_b64_tr_b16 v[78:79], v2 offset:62848
		ds_read_b64_tr_b16 v[80:81], v2 offset:62784
		ds_read_b64_tr_b16 v[82:83], v2 offset:62912
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[176:191], v[4:7], v[40:43], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[20:23], v[40:43], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[24:27], v[40:43], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[28:31], v[40:43], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[32:35], v[8:11], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[36:39], v[8:11], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[44:47], v[8:11], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[48:51], v[8:11], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[52:55], v[12:15], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[56:59], v[12:15], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[60:63], v[12:15], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[64:67], v[12:15], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[68:71], v[16:19], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[72:75], v[16:19], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[76:79], v[16:19], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[80:83], v[16:19], v[224:239]
		s_cmp_lt_u32 s0, 0x100
		s_cbranch_scc0 .Lflash_attention_bf16_gfx950.if_end_2
		s_barrier
.Lflash_attention_bf16_gfx950.if_end_2:
		s_setprio 0
		v_rcp_f32_e32 v2, v0
		s_nop 0
		v_mov_b32_e32 v3, v2
		s_nop 2
		v_pk_mul_f32 v[4:5], v[176:177], v[2:3]
		v_cvt_pk_bf16_f32 v8, v4, v5
		v_pk_mul_f32 v[4:5], v[178:179], v[2:3]
		v_cvt_pk_bf16_f32 v9, v4, v5
		v_pk_mul_f32 v[4:5], v[180:181], v[2:3]
		v_cvt_pk_bf16_f32 v10, v4, v5
		v_pk_mul_f32 v[4:5], v[182:183], v[2:3]
		v_cvt_pk_bf16_f32 v11, v4, v5
		v_pk_mul_f32 v[4:5], v[184:185], v[2:3]
		v_cvt_pk_bf16_f32 v12, v4, v5
		v_pk_mul_f32 v[4:5], v[186:187], v[2:3]
		v_cvt_pk_bf16_f32 v13, v4, v5
		v_pk_mul_f32 v[4:5], v[188:189], v[2:3]
		v_cvt_pk_bf16_f32 v14, v4, v5
		v_pk_mul_f32 v[4:5], v[190:191], v[2:3]
		v_cvt_pk_bf16_f32 v15, v4, v5
		v_pk_mul_f32 v[4:5], v[192:193], v[2:3]
		v_cvt_pk_bf16_f32 v16, v4, v5
		v_pk_mul_f32 v[4:5], v[194:195], v[2:3]
		v_cvt_pk_bf16_f32 v17, v4, v5
		v_pk_mul_f32 v[4:5], v[196:197], v[2:3]
		v_cvt_pk_bf16_f32 v18, v4, v5
		v_pk_mul_f32 v[4:5], v[198:199], v[2:3]
		v_cvt_pk_bf16_f32 v19, v4, v5
		v_pk_mul_f32 v[4:5], v[200:201], v[2:3]
		v_cvt_pk_bf16_f32 v20, v4, v5
		v_pk_mul_f32 v[4:5], v[202:203], v[2:3]
		v_cvt_pk_bf16_f32 v21, v4, v5
		v_pk_mul_f32 v[4:5], v[204:205], v[2:3]
		v_cvt_pk_bf16_f32 v22, v4, v5
		v_pk_mul_f32 v[4:5], v[206:207], v[2:3]
		v_cvt_pk_bf16_f32 v23, v4, v5
		v_pk_mul_f32 v[4:5], v[208:209], v[2:3]
		v_cvt_pk_bf16_f32 v24, v4, v5
		v_pk_mul_f32 v[4:5], v[210:211], v[2:3]
		v_cvt_pk_bf16_f32 v25, v4, v5
		v_pk_mul_f32 v[4:5], v[212:213], v[2:3]
		v_cvt_pk_bf16_f32 v26, v4, v5
		v_pk_mul_f32 v[4:5], v[214:215], v[2:3]
		v_cvt_pk_bf16_f32 v27, v4, v5
		v_pk_mul_f32 v[4:5], v[216:217], v[2:3]
		v_cvt_pk_bf16_f32 v28, v4, v5
		v_pk_mul_f32 v[4:5], v[218:219], v[2:3]
		v_cvt_pk_bf16_f32 v29, v4, v5
		v_pk_mul_f32 v[4:5], v[220:221], v[2:3]
		v_cvt_pk_bf16_f32 v30, v4, v5
		v_pk_mul_f32 v[4:5], v[222:223], v[2:3]
		v_cvt_pk_bf16_f32 v31, v4, v5
		v_pk_mul_f32 v[4:5], v[224:225], v[2:3]
		v_cvt_pk_bf16_f32 v32, v4, v5
		v_pk_mul_f32 v[4:5], v[226:227], v[2:3]
		v_cvt_pk_bf16_f32 v33, v4, v5
		v_pk_mul_f32 v[4:5], v[228:229], v[2:3]
		v_cvt_pk_bf16_f32 v34, v4, v5
		v_pk_mul_f32 v[4:5], v[230:231], v[2:3]
		v_cvt_pk_bf16_f32 v35, v4, v5
		v_pk_mul_f32 v[4:5], v[232:233], v[2:3]
		v_cvt_pk_bf16_f32 v36, v4, v5
		v_pk_mul_f32 v[4:5], v[234:235], v[2:3]
		v_cvt_pk_bf16_f32 v37, v4, v5
		v_pk_mul_f32 v[4:5], v[236:237], v[2:3]
		v_pk_mul_f32 v[6:7], v[238:239], v[2:3]
		v_cvt_pk_bf16_f32 v38, v4, v5
		v_cvt_pk_bf16_f32 v39, v6, v7
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
		v_permlane32_swap_b32_e32 v12, v14
		v_permlane32_swap_b32_e32 v13, v15
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v20, v22
		v_permlane32_swap_b32_e32 v21, v23
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_permlane32_swap_b32_e32 v32, v34
		v_permlane32_swap_b32_e32 v33, v35
		v_permlane32_swap_b32_e32 v36, v38
		v_permlane32_swap_b32_e32 v37, v39
		s_mov_b32 s27, s19
		buffer_store_dwordx4 v[8:11], v1, s[24:27], s2 offen
		buffer_store_dwordx4 v[12:15], v1, s[24:27], s2 offen offset:32
		buffer_store_dwordx4 v[16:19], v1, s[24:27], s2 offen offset:64
		buffer_store_dwordx4 v[20:23], v1, s[24:27], s2 offen offset:96
		buffer_store_dwordx4 v[24:27], v1, s[24:27], s2 offen offset:128
		buffer_store_dwordx4 v[28:31], v1, s[24:27], s2 offen offset:160
		buffer_store_dwordx4 v[32:35], v1, s[24:27], s2 offen offset:192
		buffer_store_dwordx4 v[36:39], v1, s[24:27], s2 offen offset:224
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
		.amdhsa_next_free_sgpr 28
		.amdhsa_accum_offset 256
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
	.set .Lflash_attention_bf16_gfx950.num_vgpr, 256
	.set .Lflash_attention_bf16_gfx950.num_agpr, 0
	.set .Lflash_attention_bf16_gfx950.numbered_sgpr, 28
	.set .Lflash_attention_bf16_gfx950.num_named_barrier, 0
	.set .Lflash_attention_bf16_gfx950.private_seg_size, 0
	.set .Lflash_attention_bf16_gfx950.uses_vcc, 0
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
    .sgpr_count:     28
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
