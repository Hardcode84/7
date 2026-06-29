	.text
	.amdgcn_target "amdgcn-amd-amdhsa--gfx950"
	.amdhsa_code_object_version 6

	.globl	v9_beyond_hotloop
	.p2align	8
	.type	v9_beyond_hotloop,@function
v9_beyond_hotloop:
		s_load_dwordx2 s[2:3], s[0:1], 0x0
		s_load_dwordx2 s[4:5], s[0:1], 0x8
		s_load_dwordx2 s[6:7], s[0:1], 0x10
		s_load_dwordx2 s[8:9], s[0:1], 0x18
		s_load_dwordx2 s[10:11], s[0:1], 0x20
		s_load_dword s12, s[0:1], 0x28
		s_waitcnt lgkmcnt(0)
		s_branch .Lv9_beyond_hotloop.kernarg_preload_entry
	.p2align	8
.Lv9_beyond_hotloop.kernarg_preload_entry:
	; wave backend: WaveAMDMachine MLIR pipeline finalized
		s_add_i32 s14, s8, 0xff
		v_mov_b32_e32 v1, 0x4f7ffffe
		s_cmp_lt_i32 s14, 0
		v_readfirstlane_b32 s15, v0
		s_mov_b32 s16, 0xff
		v_lshrrev_b32_e32 v2, 3, v0
		s_cselect_b32 s17, s16, 0
		v_mul_lo_u32 v3, s10, v2
		s_add_i32 s14, s14, s17
		v_lshlrev_b32_e32 v4, 3, v0
		s_ashr_i32 s14, s14, 8
		v_lshrrev_b32_e32 v5, 4, v0
		s_add_i32 s17, s9, 0xff
		v_mul_lo_u32 v6, s11, v5
		s_cmp_lt_i32 s17, 0
		s_mov_b32 s20, s2
		s_mov_b32 s21, s3
		s_mov_b32 s22, 0x7fffffff
		s_mov_b32 s23, 0x31016000
		v_and_b32_e32 v7, 63, v4
		s_cselect_b32 s2, s16, 0
		v_lshlrev_b32_e32 v7, 1, v7
		s_add_i32 s2, s17, s2
		v_lshl_add_u32 v3, v3, 1, v7
		s_ashr_i32 s2, s2, 8
		s_mov_b32 s16, s4
		s_mov_b32 s17, s5
		s_mov_b32 s18, 0x7fffffff
		s_mov_b32 s19, 0x31016000
		v_and_b32_e32 v4, 0x7f, v4
		s_and_b32 s3, s13, 7
		v_lshlrev_b32_e32 v4, 1, v4
		s_lshr_b32 s4, s13, 3
		v_lshl_add_u32 v4, v6, 1, v4
		s_mul_i32 s3, s3, 32
		s_add_i32 s3, s3, s4
		s_mul_i32 s2, s2, 4
		s_cmp_lt_i32 s3, 0
		s_cselect_b32 s4, 1, 0
		s_xor_b32 s5, s3, -1
		s_add_i32 s5, s5, 1
		s_cmp_lg_u32 s4, 0
		s_cselect_b32 s4, s5, s3
		s_cselect_b32 s5, 1, 0
		s_cmp_lt_i32 s2, 0
		s_cselect_b32 s13, 1, 0
		s_xor_b32 s24, s2, -1
		s_add_i32 s24, s24, 1
		s_cmp_lg_u32 s13, 0
		s_cselect_b32 s13, s24, s2
		v_mov_b32_e32 v6, s13
		s_xor_b32 s24, s13, -1
		v_cvt_f32_u32_e32 v6, v6
		s_add_i32 s24, s24, 1
		v_rcp_iflag_f32_e32 v6, v6
		s_mul_i32 s25, 0x180, s10
		v_mul_f32_e32 v6, v1, v6
		s_mul_i32 s26, 0xc0, s11
		v_cvt_u32_f32_e32 v6, v6
		s_nop 0
		v_readfirstlane_b32 s27, v6
		s_mul_i32 s28, s24, s27
		s_mul_hi_u32 s28, s27, s28
		s_add_i32 s27, s27, s28
		s_mul_hi_u32 s27, s4, s27
		s_mul_i32 s28, s27, s13
		s_xor_b32 s28, s28, -1
		s_add_i32 s28, s28, 1
		s_add_i32 s4, s4, s28
		s_cmp_ge_u32 s4, s13
		s_cselect_b32 s28, 1, 0
		s_add_i32 s29, s27, 1
		s_cmp_lg_u32 s28, 0
		s_cselect_b32 s27, s29, s27
		s_cselect_b32 s28, 1, 0
		s_add_i32 s29, s4, s24
		s_cmp_lg_u32 s28, 0
		s_cselect_b32 s4, s29, s4
		s_cmp_ge_u32 s4, s13
		s_cselect_b32 s13, 1, 0
		s_add_i32 s28, s27, 1
		s_cmp_lg_u32 s13, 0
		s_cselect_b32 s13, s28, s27
		s_cselect_b32 s27, 1, 0
		s_xor_b32 s2, s3, s2
		s_cmp_lt_i32 s2, 0
		s_cselect_b32 s2, 1, 0
		s_xor_b32 s3, s13, -1
		s_add_i32 s3, s3, 1
		s_cmp_lg_u32 s2, 0
		s_cselect_b32 s28, s3, s13
		s_mul_i32 s2, s28, 4
		s_xor_b32 s2, s2, -1
		s_add_i32 s2, s2, 1
		s_add_i32 s2, s14, s2
		s_cmp_lt_i32 s2, 4
		s_cselect_b32 s2, s2, 4
		v_mov_b32_e32 v6, s2
		s_add_i32 s3, s4, s24
		v_cvt_f32_u32_e32 v6, v6
		s_cmp_lg_u32 s27, 0
		s_cselect_b32 s3, s3, s4
		v_rcp_iflag_f32_e32 v6, v6
		s_xor_b32 s4, s3, -1
		v_mul_f32_e32 v1, v1, v6
		s_add_i32 s4, s4, 1
		v_cvt_u32_f32_e32 v1, v1
		s_cmp_lg_u32 s5, 0
		s_cselect_b32 s3, s4, s3
		v_readfirstlane_b32 s4, v1
		s_xor_b32 s5, s2, -1
		v_readfirstlane_b32 s13, v1
		s_add_i32 s5, s5, 1
		s_mul_i32 s14, s5, s4
		s_mul_hi_u32 s14, s4, s14
		s_add_i32 s4, s4, s14
		s_mul_hi_u32 s4, s3, s4
		s_mul_i32 s4, s4, s2
		s_xor_b32 s4, s4, -1
		s_add_i32 s4, s4, 1
		s_add_i32 s4, s3, s4
		s_cmp_ge_u32 s4, s2
		s_cselect_b32 s14, 1, 0
		s_add_i32 s24, s4, s5
		s_cmp_lg_u32 s14, 0
		s_cselect_b32 s4, s24, s4
		s_cmp_ge_u32 s4, s2
		s_cselect_b32 s14, 1, 0
		s_add_i32 s24, s4, s5
		s_cmp_lg_u32 s14, 0
		s_cselect_b32 s30, s24, s4
		s_mul_i32 s4, s5, s13
		s_mul_hi_u32 s4, s13, s4
		s_add_i32 s4, s13, s4
		s_mul_hi_u32 s4, s3, s4
		s_mul_i32 s13, s4, s2
		s_xor_b32 s13, s13, -1
		s_add_i32 s13, s13, 1
		s_add_i32 s3, s3, s13
		s_cmp_ge_u32 s3, s2
		s_cselect_b32 s13, 1, 0
		s_add_i32 s14, s4, 1
		s_cmp_lg_u32 s13, 0
		s_cselect_b32 s4, s14, s4
		s_cselect_b32 s13, 1, 0
		s_add_i32 s5, s3, s5
		s_cmp_lg_u32 s13, 0
		s_cselect_b32 s3, s5, s3
		s_cmp_ge_u32 s3, s2
		s_cselect_b32 s2, 1, 0
		s_add_i32 s3, s4, 1
		s_cmp_lg_u32 s2, 0
		s_cselect_b32 s32, s3, s4
		s_lshr_b32 s2, s15, 6
		s_mul_i32 s2, 0x420, s2
		s_mov_b32 m0, s2
		s_mul_i32 s3, s10, s28
		s_lshl_b32 s3, s3, 11
		s_mul_i32 s4, s10, s30
		s_lshl_b32 s4, s4, 9
		s_add_i32 s5, s3, s4
		v_add_u32_e32 v1, s5, v3
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_add_i32 s13, s2, 0x2100
		s_mov_b32 m0, s13
		s_lshl_b32 s14, s10, 7
		s_add_i32 s15, s14, s3
		s_add_i32 s15, s15, s4
		v_add_u32_e32 v1, s15, v3
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_add_i32 s24, s2, 0x4200
		s_mov_b32 m0, s24
		s_lshl_b32 s10, s10, 8
		s_add_i32 s27, s10, s3
		s_add_i32 s27, s27, s4
		v_add_u32_e32 v1, s27, v3
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_add_i32 s29, s2, 0x6300
		s_mov_b32 m0, s29
		s_add_i32 s31, s25, s3
		s_add_i32 s31, s31, s4
		v_add_u32_e32 v1, s31, v3
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_add_i32 s33, s2, 0x107c0
		s_mov_b32 m0, s33
		s_lshl_b32 s34, s32, 9
		v_add_u32_e32 v1, s34, v4
		buffer_load_dwordx4 v1, s[16:19], 0 offen lds
		s_add_i32 s35, s2, 0x128c0
		s_mov_b32 m0, s35
		s_lshl_b32 s36, s11, 6
		s_add_i32 s37, s36, s34
		v_add_u32_e32 v1, s37, v4
		buffer_load_dwordx4 v1, s[16:19], 0 offen lds
		s_add_i32 s38, s2, 0x18b80
		s_mov_b32 m0, s38
		s_add_i32 s39, s34, 0x100
		v_add_u32_e32 v1, s39, v4
		buffer_load_dwordx4 v1, s[16:19], 0 offen lds
		s_add_i32 s40, s2, 0x1ac80
		s_mov_b32 m0, s40
		s_add_i32 s36, s36, 0x100
		s_add_i32 s36, s36, s34
		v_add_u32_e32 v1, s36, v4
		buffer_load_dwordx4 v1, s[16:19], 0 offen lds
		s_add_i32 s41, s2, 0x83e0
		s_mov_b32 m0, s41
		s_add_i32 s42, s3, 0x80
		s_add_i32 s42, s42, s4
		v_add_u32_e32 v1, s42, v3
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_add_i32 s43, s2, 0xa4e0
		s_mov_b32 m0, s43
		s_add_i32 s14, s14, 0x80
		s_add_i32 s14, s14, s3
		s_add_i32 s14, s14, s4
		v_add_u32_e32 v1, s14, v3
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_add_i32 s44, s2, 0xc5e0
		s_mov_b32 m0, s44
		s_add_i32 s10, s10, 0x80
		s_add_i32 s10, s10, s3
		s_add_i32 s10, s10, s4
		v_add_u32_e32 v1, s10, v3
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_add_i32 s45, s2, 0xe6e0
		s_mov_b32 m0, s45
		s_add_i32 s25, s25, 0x80
		s_add_i32 s3, s25, s3
		s_add_i32 s3, s3, s4
		v_add_u32_e32 v1, s3, v3
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_add_i32 s4, s2, 0x149a0
		s_mov_b32 m0, s4
		s_lshl_b32 s25, s11, 7
		s_add_i32 s46, s25, s34
		v_add_u32_e32 v1, s46, v4
		buffer_load_dwordx4 v1, s[16:19], 0 offen lds
		s_add_i32 s47, s2, 0x16aa0
		s_add_i32 s48, s26, s34
		v_add_u32_e32 v1, s48, v4
		s_mov_b32 m0, s47
		s_nop 0
		buffer_load_dwordx4 v1, s[16:19], 0 offen lds
		s_add_i32 s49, s2, 0x1cd60
		s_add_i32 s25, s25, 0x100
		s_add_i32 s25, s25, s34
		v_add_u32_e32 v1, s25, v4
		s_mov_b32 m0, s49
		s_nop 0
		buffer_load_dwordx4 v1, s[16:19], 0 offen lds
		s_add_i32 s50, s2, 0x1ee60
		s_add_i32 s26, s26, 0x100
		s_add_i32 s26, s26, s34
		v_add_u32_e32 v1, s26, v4
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v1, s[16:19], 0 offen lds
		v_mov_b32_e32 v8, 0
		s_mul_i32 s11, s11, 64
		s_add_i32 s51, s11, s11
		v_mov_b32_e32 v9, 0
		v_mov_b32_e32 v10, 0
		v_mov_b32_e32 v11, 0
		s_waitcnt vmcnt(10)
		s_barrier
		v_and_b32_e32 v1, 63, v0
		v_lshrrev_b32_e32 v6, 7, v0
		v_and_b32_e32 v7, 15, v1
		v_lshl_add_u32 v12, v6, 4, v7
		v_lshrrev_b32_e32 v1, 4, v1
		v_lshrrev_b32_e32 v13, 2, v7
		v_lshl_add_u32 v14, v1, 3, v13
		v_lshrrev_b32_e32 v12, 5, v12
		v_lshrrev_b32_e32 v15, 3, v7
		v_and_b32_e32 v16, 1, v6
		v_lshrrev_b32_e32 v14, 4, v14
		v_mov_b32_e32 v17, 0x1080
		v_mul_lo_u32 v17, v17, v12
		v_lshl_add_u32 v12, v1, 4, v17
		v_mov_b32_e32 v17, 0x420
		v_mul_lo_u32 v17, v17, v15
		v_mov_b32_e32 v15, 0x1080
		v_mul_lo_u32 v15, v15, v14
		v_lshrrev_b32_e32 v14, 6, v0
		v_mov_b32_e32 v18, 0x840
		v_mul_lo_u32 v18, v18, v16
		v_add3_u32 v12, v12, v17, v18
		v_and_b32_e32 v17, 1, v13
		v_lshrrev_b32_e32 v18, 1, v7
		v_and_b32_e32 v14, 1, v14
		v_and_b32_e32 v1, 1, v1
		v_add_u32_e32 v15, 0x10000, v15
		v_lshl_add_u32 v12, v17, 9, v12
		v_and_b32_e32 v17, 1, v18
		v_lshl_add_u32 v13, v13, 8, v15
		v_lshlrev_b32_e32 v15, 5, v14
		v_mov_b32_e32 v18, 0x840
		v_mul_lo_u32 v18, v18, v1
		v_lshl_add_u32 v1, v17, 8, v12
		v_and_b32_e32 v12, 1, v7
		v_add3_u32 v13, v13, v15, v18
		v_and_b32_e32 v7, 3, v7
		v_lshl_add_u32 v1, v12, 7, v1
		v_lshl_add_u32 v7, v7, 3, v13
		ds_read_b128 v[20:23], v1
		ds_read_b128 v[24:27], v1 offset:64
		ds_read_b128 v[28:31], v1 offset:8448
		ds_read_b128 v[32:35], v1 offset:8512
		ds_read_b128 v[36:39], v1 offset:16896
		ds_read_b128 v[40:43], v1 offset:16960
		ds_read_b128 v[44:47], v1 offset:25344
		ds_read_b128 v[48:51], v1 offset:25408
		ds_read_b64_tr_b16 v[52:53], v7 offset:1984
		ds_read_b64_tr_b16 v[54:55], v7 offset:3040
		ds_read_b64_tr_b16 v[56:57], v7 offset:10432
		ds_read_b64_tr_b16 v[58:59], v7 offset:11488
		ds_read_b64_tr_b16 v[60:61], v7 offset:2048
		ds_read_b64_tr_b16 v[62:63], v7 offset:3104
		ds_read_b64_tr_b16 v[64:65], v7 offset:10496
		ds_read_b64_tr_b16 v[66:67], v7 offset:11552
		ds_read_b64_tr_b16 v[68:69], v7 offset:2112
		ds_read_b64_tr_b16 v[70:71], v7 offset:3168
		ds_read_b64_tr_b16 v[72:73], v7 offset:10560
		ds_read_b64_tr_b16 v[74:75], v7 offset:11616
		ds_read_b64_tr_b16 v[76:77], v7 offset:2176
		ds_read_b64_tr_b16 v[78:79], v7 offset:3232
		ds_read_b64_tr_b16 v[80:81], v7 offset:10624
		ds_read_b64_tr_b16 v[82:83], v7 offset:11680
		v_mov_b32_e32 v84, v8
		v_mov_b32_e32 v85, v9
		v_mov_b32_e32 v86, v10
		v_mov_b32_e32 v87, v11
		s_mov_b32 s0, 0x80
		s_mov_b32 s1, 0
		s_cmp_lt_i32 0, 62
		v_mov_b32_e32 v88, 0
		v_mov_b32_e32 v89, 0
		v_mov_b32_e32 v90, 0
		v_mov_b32_e32 v91, 0
		v_mov_b32_e32 v92, 0
		v_mov_b32_e32 v93, 0
		v_mov_b32_e32 v94, 0
		v_mov_b32_e32 v95, 0
		v_mov_b32_e32 v96, 0
		v_mov_b32_e32 v97, 0
		v_mov_b32_e32 v98, 0
		v_mov_b32_e32 v99, 0
		v_mov_b32_e32 v100, 0
		v_mov_b32_e32 v101, 0
		v_mov_b32_e32 v102, 0
		v_mov_b32_e32 v103, 0
		v_mov_b32_e32 v104, 0
		v_mov_b32_e32 v105, 0
		v_mov_b32_e32 v106, 0
		v_mov_b32_e32 v107, 0
		v_mov_b32_e32 v108, 0
		v_mov_b32_e32 v109, 0
		v_mov_b32_e32 v110, 0
		v_mov_b32_e32 v111, 0
		v_mov_b32_e32 v112, 0
		v_mov_b32_e32 v113, 0
		v_mov_b32_e32 v114, 0
		v_mov_b32_e32 v115, 0
		v_mov_b32_e32 v116, 0
		v_mov_b32_e32 v117, 0
		v_mov_b32_e32 v118, 0
		v_mov_b32_e32 v119, 0
		v_mov_b32_e32 v120, 0
		v_mov_b32_e32 v121, 0
		v_mov_b32_e32 v122, 0
		v_mov_b32_e32 v123, 0
		v_mov_b32_e32 v124, 0
		v_mov_b32_e32 v125, 0
		v_mov_b32_e32 v126, 0
		v_mov_b32_e32 v127, 0
		v_mov_b32_e32 v128, 0
		v_mov_b32_e32 v129, 0
		v_mov_b32_e32 v130, 0
		v_mov_b32_e32 v131, 0
		v_mov_b32_e32 v132, 0
		v_mov_b32_e32 v133, 0
		v_mov_b32_e32 v134, 0
		v_mov_b32_e32 v135, 0
		v_mov_b32_e32 v136, 0
		v_mov_b32_e32 v137, 0
		v_mov_b32_e32 v138, 0
		v_mov_b32_e32 v139, 0
		v_mov_b32_e32 v140, 0
		v_mov_b32_e32 v141, 0
		v_mov_b32_e32 v142, 0
		v_mov_b32_e32 v143, 0
		v_mov_b32_e32 v144, 0
		v_mov_b32_e32 v145, 0
		v_mov_b32_e32 v146, 0
		v_mov_b32_e32 v147, 0
		v_mov_b32_e32 v148, 0
		v_mov_b32_e32 v149, 0
		v_mov_b32_e32 v150, 0
		v_mov_b32_e32 v151, 0
		v_mov_b32_e32 v152, 0
		v_mov_b32_e32 v153, 0
		v_mov_b32_e32 v154, 0
		v_mov_b32_e32 v155, 0
		v_mov_b32_e32 v156, 0
		v_mov_b32_e32 v157, 0
		v_mov_b32_e32 v158, 0
		v_mov_b32_e32 v159, 0
		v_mov_b32_e32 v160, 0
		v_mov_b32_e32 v161, 0
		v_mov_b32_e32 v162, 0
		v_mov_b32_e32 v163, 0
		v_mov_b32_e32 v164, 0
		v_mov_b32_e32 v165, 0
		v_mov_b32_e32 v166, 0
		v_mov_b32_e32 v167, 0
		v_mov_b32_e32 v168, 0
		v_mov_b32_e32 v169, 0
		v_mov_b32_e32 v170, 0
		v_mov_b32_e32 v171, 0
		v_mov_b32_e32 v172, 0
		v_mov_b32_e32 v173, 0
		v_mov_b32_e32 v174, 0
		v_mov_b32_e32 v175, 0
		v_mov_b32_e32 v176, 0
		v_mov_b32_e32 v177, 0
		v_mov_b32_e32 v178, 0
		v_mov_b32_e32 v179, 0
		v_mov_b32_e32 v180, 0
		v_mov_b32_e32 v181, 0
		v_mov_b32_e32 v182, 0
		v_mov_b32_e32 v183, 0
		v_mov_b32_e32 v184, 0
		v_mov_b32_e32 v185, 0
		v_mov_b32_e32 v186, 0
		v_mov_b32_e32 v187, 0
		v_mov_b32_e32 v188, 0
		v_mov_b32_e32 v189, 0
		v_mov_b32_e32 v190, 0
		v_mov_b32_e32 v191, 0
		v_mov_b32_e32 v192, 0
		v_mov_b32_e32 v193, 0
		v_mov_b32_e32 v194, 0
		v_mov_b32_e32 v195, 0
		v_mov_b32_e32 v196, 0
		v_mov_b32_e32 v197, 0
		v_mov_b32_e32 v198, 0
		v_mov_b32_e32 v199, 0
		v_mov_b32_e32 v200, 0
		v_mov_b32_e32 v201, 0
		v_mov_b32_e32 v202, 0
		v_mov_b32_e32 v203, 0
		v_mov_b32_e32 v204, 0
		v_mov_b32_e32 v205, 0
		v_mov_b32_e32 v206, 0
		v_mov_b32_e32 v207, 0
		v_mov_b32_e32 v208, 0
		v_mov_b32_e32 v209, 0
		v_mov_b32_e32 v210, 0
		v_mov_b32_e32 v211, 0
		s_cbranch_scc0 .Lv9_beyond_hotloop.loop_exit_0
.Lv9_beyond_hotloop.loop_head_0:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[88:91], v[52:55], v[20:23], v[88:91]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[88:91], v[56:59], v[24:27], v[88:91]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[84:87], v[60:63], v[20:23], v[84:87]
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[84:87], v[64:67], v[24:27], v[84:87]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[92:95], v[68:71], v[20:23], v[92:95]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[92:95], v[72:75], v[24:27], v[92:95]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[96:99], v[76:79], v[20:23], v[96:99]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[96:99], v[80:83], v[24:27], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[52:55], v[28:31], v[100:103]
		v_mfma_f32_16x16x32_f16 v[100:103], v[56:59], v[32:35], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[60:63], v[28:31], v[104:107]
		v_mfma_f32_16x16x32_f16 v[104:107], v[64:67], v[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[68:71], v[28:31], v[108:111]
		v_mfma_f32_16x16x32_f16 v[108:111], v[72:75], v[32:35], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[76:79], v[28:31], v[112:115]
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[32:35], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[52:55], v[36:39], v[116:119]
		v_mfma_f32_16x16x32_f16 v[116:119], v[56:59], v[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[60:63], v[36:39], v[120:123]
		v_mfma_f32_16x16x32_f16 v[120:123], v[64:67], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[68:71], v[36:39], v[124:127]
		v_mfma_f32_16x16x32_f16 v[124:127], v[72:75], v[40:43], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[76:79], v[36:39], v[128:131]
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[40:43], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[52:55], v[44:47], v[132:135]
		v_mfma_f32_16x16x32_f16 v[132:135], v[56:59], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[60:63], v[44:47], v[136:139]
		v_mfma_f32_16x16x32_f16 v[136:139], v[64:67], v[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[68:71], v[44:47], v[140:143]
		v_mfma_f32_16x16x32_f16 v[140:143], v[72:75], v[48:51], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[76:79], v[44:47], v[144:147]
		v_mfma_f32_16x16x32_f16 v[144:147], v[80:83], v[48:51], v[144:147]
		s_waitcnt vmcnt(8)
		s_barrier
		s_mov_b32 m0, s2
		s_lshl_b32 s52, s0, 1
		s_add_i32 s53, s5, s52
		v_add_u32_e32 v9, s53, v3
		buffer_load_dwordx4 v9, s[20:23], 0 offen lds
		s_mov_b32 m0, s13
		s_add_i32 s53, s15, s52
		v_add_u32_e32 v9, s53, v3
		buffer_load_dwordx4 v9, s[20:23], 0 offen lds
		s_mov_b32 m0, s24
		s_add_i32 s53, s27, s52
		v_add_u32_e32 v9, s53, v3
		buffer_load_dwordx4 v9, s[20:23], 0 offen lds
		s_add_i32 s53, s31, s52
		v_add_u32_e32 v9, s53, v3
		s_mov_b32 m0, s29
		s_nop 0
		buffer_load_dwordx4 v9, s[20:23], 0 offen lds
		s_lshl_b32 s53, s51, 1
		s_add_i32 s54, s34, s53
		v_add_u32_e32 v9, s54, v4
		s_mov_b32 m0, s33
		s_nop 0
		buffer_load_dwordx4 v9, s[16:19], 0 offen lds
		ds_read_b64_tr_b16 v[52:53], v7 offset:35712
		s_add_i32 s54, s37, s53
		ds_read_b64_tr_b16 v[54:55], v7 offset:36768
		v_add_u32_e32 v9, s54, v4
		ds_read_b64_tr_b16 v[56:57], v7 offset:35776
		s_mov_b32 m0, s35
		s_nop 0
		buffer_load_dwordx4 v9, s[16:19], 0 offen lds
		ds_read_b64_tr_b16 v[58:59], v7 offset:36832
		ds_read_b64_tr_b16 v[60:61], v7 offset:35840
		ds_read_b64_tr_b16 v[62:63], v7 offset:36896
		ds_read_b64_tr_b16 v[64:65], v7 offset:35904
		ds_read_b64_tr_b16 v[66:67], v7 offset:36960
		ds_read_b64_tr_b16 v[68:69], v7 offset:44160
		ds_read_b64_tr_b16 v[70:71], v7 offset:45216
		ds_read_b64_tr_b16 v[72:73], v7 offset:44224
		ds_read_b64_tr_b16 v[74:75], v7 offset:45280
		ds_read_b64_tr_b16 v[76:77], v7 offset:44288
		ds_read_b64_tr_b16 v[78:79], v7 offset:45344
		ds_read_b64_tr_b16 v[80:81], v7 offset:44352
		ds_read_b64_tr_b16 v[82:83], v7 offset:45408
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[148:151], v[52:55], v[20:23], v[148:151]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[152:155], v[56:59], v[20:23], v[152:155]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[156:159], v[60:63], v[20:23], v[156:159]
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[160:163], v[64:67], v[20:23], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[52:55], v[28:31], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[56:59], v[28:31], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[60:63], v[28:31], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[64:67], v[28:31], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[52:55], v[36:39], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[56:59], v[36:39], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[60:63], v[36:39], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[64:67], v[36:39], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[52:55], v[44:47], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[56:59], v[44:47], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[60:63], v[44:47], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[64:67], v[44:47], v[208:211]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[148:151], v[68:71], v[24:27], v[148:151]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[152:155], v[72:75], v[24:27], v[152:155]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[156:159], v[76:79], v[24:27], v[156:159]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[160:163], v[80:83], v[24:27], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[68:71], v[32:35], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[72:75], v[32:35], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[76:79], v[32:35], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[80:83], v[32:35], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[68:71], v[40:43], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[72:75], v[40:43], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[76:79], v[40:43], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[80:83], v[40:43], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[68:71], v[48:51], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[72:75], v[48:51], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[76:79], v[48:51], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[80:83], v[48:51], v[208:211]
		s_waitcnt vmcnt(8)
		s_barrier
		s_add_i32 s54, s39, s53
		v_add_u32_e32 v9, s54, v4
		s_mov_b32 m0, s38
		s_nop 0
		buffer_load_dwordx4 v9, s[16:19], 0 offen lds
		ds_read_b128 v[20:23], v1 offset:33760
		s_add_i32 s54, s36, s53
		ds_read_b128 v[24:27], v1 offset:42208
		v_add_u32_e32 v9, s54, v4
		ds_read_b128 v[28:31], v1 offset:50656
		s_mov_b32 m0, s40
		s_nop 0
		buffer_load_dwordx4 v9, s[16:19], 0 offen lds
		ds_read_b128 v[32:35], v1 offset:59104
		ds_read_b64_tr_b16 v[36:37], v7 offset:18848
		ds_read_b64_tr_b16 v[38:39], v7 offset:19904
		ds_read_b64_tr_b16 v[40:41], v7 offset:18912
		ds_read_b64_tr_b16 v[42:43], v7 offset:19968
		ds_read_b64_tr_b16 v[44:45], v7 offset:18976
		ds_read_b64_tr_b16 v[46:47], v7 offset:20032
		ds_read_b64_tr_b16 v[48:49], v7 offset:19040
		ds_read_b64_tr_b16 v[50:51], v7 offset:20096
		ds_read_b128 v[52:55], v1 offset:33824
		ds_read_b128 v[56:59], v1 offset:42272
		ds_read_b128 v[60:63], v1 offset:50720
		ds_read_b128 v[64:67], v1 offset:59168
		ds_read_b64_tr_b16 v[68:69], v7 offset:27296
		ds_read_b64_tr_b16 v[70:71], v7 offset:28352
		ds_read_b64_tr_b16 v[72:73], v7 offset:27360
		ds_read_b64_tr_b16 v[74:75], v7 offset:28416
		ds_read_b64_tr_b16 v[76:77], v7 offset:27424
		ds_read_b64_tr_b16 v[78:79], v7 offset:28480
		ds_read_b64_tr_b16 v[80:81], v7 offset:27488
		ds_read_b64_tr_b16 v[82:83], v7 offset:28544
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[88:91], v[36:39], v[20:23], v[88:91]
		s_add_i32 s51, s51, s11
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[84:87], v[40:43], v[20:23], v[84:87]
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[92:95], v[44:47], v[20:23], v[92:95]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[96:99], v[48:51], v[20:23], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[36:39], v[24:27], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[40:43], v[24:27], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[44:47], v[24:27], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[48:51], v[24:27], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[36:39], v[28:31], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[40:43], v[28:31], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[44:47], v[28:31], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[48:51], v[28:31], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[36:39], v[32:35], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[40:43], v[32:35], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[44:47], v[32:35], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[48:51], v[32:35], v[144:147]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[88:91], v[68:71], v[52:55], v[88:91]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[84:87], v[72:75], v[52:55], v[84:87]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[92:95], v[76:79], v[52:55], v[92:95]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[96:99], v[80:83], v[52:55], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[68:71], v[56:59], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[72:75], v[56:59], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[76:79], v[56:59], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[56:59], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[68:71], v[60:63], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[72:75], v[60:63], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[76:79], v[60:63], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[60:63], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[68:71], v[64:67], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[72:75], v[64:67], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[76:79], v[64:67], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[80:83], v[64:67], v[144:147]
		s_waitcnt vmcnt(8)
		s_barrier
		s_mov_b32 m0, s41
		s_add_i32 s54, s42, s52
		v_add_u32_e32 v9, s54, v3
		buffer_load_dwordx4 v9, s[20:23], 0 offen lds
		s_mov_b32 m0, s43
		s_add_i32 s54, s14, s52
		v_add_u32_e32 v9, s54, v3
		buffer_load_dwordx4 v9, s[20:23], 0 offen lds
		s_mov_b32 m0, s44
		s_add_i32 s54, s10, s52
		v_add_u32_e32 v9, s54, v3
		buffer_load_dwordx4 v9, s[20:23], 0 offen lds
		s_add_i32 s52, s3, s52
		v_add_u32_e32 v9, s52, v3
		s_mov_b32 m0, s45
		s_nop 0
		buffer_load_dwordx4 v9, s[20:23], 0 offen lds
		s_add_i32 s52, s46, s53
		v_add_u32_e32 v9, s52, v4
		s_mov_b32 m0, s4
		s_nop 0
		buffer_load_dwordx4 v9, s[16:19], 0 offen lds
		ds_read_b64_tr_b16 v[36:37], v7 offset:52576
		s_add_i32 s52, s48, s53
		ds_read_b64_tr_b16 v[38:39], v7 offset:53632
		v_add_u32_e32 v9, s52, v4
		ds_read_b64_tr_b16 v[40:41], v7 offset:52640
		s_mov_b32 m0, s47
		s_nop 0
		buffer_load_dwordx4 v9, s[16:19], 0 offen lds
		ds_read_b64_tr_b16 v[42:43], v7 offset:53696
		ds_read_b64_tr_b16 v[44:45], v7 offset:52704
		ds_read_b64_tr_b16 v[46:47], v7 offset:53760
		ds_read_b64_tr_b16 v[48:49], v7 offset:52768
		ds_read_b64_tr_b16 v[50:51], v7 offset:53824
		ds_read_b64_tr_b16 v[68:69], v7 offset:61024
		ds_read_b64_tr_b16 v[70:71], v7 offset:62080
		ds_read_b64_tr_b16 v[72:73], v7 offset:61088
		ds_read_b64_tr_b16 v[74:75], v7 offset:62144
		ds_read_b64_tr_b16 v[76:77], v7 offset:61152
		ds_read_b64_tr_b16 v[78:79], v7 offset:62208
		ds_read_b64_tr_b16 v[80:81], v7 offset:61216
		ds_read_b64_tr_b16 v[82:83], v7 offset:62272
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[148:151], v[36:39], v[20:23], v[148:151]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[152:155], v[40:43], v[20:23], v[152:155]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[156:159], v[44:47], v[20:23], v[156:159]
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[160:163], v[48:51], v[20:23], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[36:39], v[24:27], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[40:43], v[24:27], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[44:47], v[24:27], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[48:51], v[24:27], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[36:39], v[28:31], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[40:43], v[28:31], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[44:47], v[28:31], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[48:51], v[28:31], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[36:39], v[32:35], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[40:43], v[32:35], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[44:47], v[32:35], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[48:51], v[32:35], v[208:211]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[148:151], v[68:71], v[52:55], v[148:151]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[152:155], v[72:75], v[52:55], v[152:155]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[156:159], v[76:79], v[52:55], v[156:159]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[160:163], v[80:83], v[52:55], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[68:71], v[56:59], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[72:75], v[56:59], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[76:79], v[56:59], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[80:83], v[56:59], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[68:71], v[60:63], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[72:75], v[60:63], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[76:79], v[60:63], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[80:83], v[60:63], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[68:71], v[64:67], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[72:75], v[64:67], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[76:79], v[64:67], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[80:83], v[64:67], v[208:211]
		s_waitcnt vmcnt(8)
		s_barrier
		s_add_i32 s52, s25, s53
		v_add_u32_e32 v9, s52, v4
		s_mov_b32 m0, s49
		s_nop 0
		buffer_load_dwordx4 v9, s[16:19], 0 offen lds
		s_add_i32 s52, s26, s53
		v_add_u32_e32 v9, s52, v4
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v9, s[16:19], 0 offen lds
		ds_read_b128 v[20:23], v1
		ds_read_b128 v[24:27], v1 offset:64
		ds_read_b128 v[28:31], v1 offset:8448
		ds_read_b128 v[32:35], v1 offset:8512
		ds_read_b128 v[36:39], v1 offset:16896
		ds_read_b128 v[40:43], v1 offset:16960
		ds_read_b128 v[44:47], v1 offset:25344
		ds_read_b128 v[48:51], v1 offset:25408
		ds_read_b64_tr_b16 v[52:53], v7 offset:1984
		ds_read_b64_tr_b16 v[54:55], v7 offset:3040
		ds_read_b64_tr_b16 v[56:57], v7 offset:10432
		ds_read_b64_tr_b16 v[58:59], v7 offset:11488
		ds_read_b64_tr_b16 v[60:61], v7 offset:2048
		ds_read_b64_tr_b16 v[62:63], v7 offset:3104
		ds_read_b64_tr_b16 v[64:65], v7 offset:10496
		ds_read_b64_tr_b16 v[66:67], v7 offset:11552
		ds_read_b64_tr_b16 v[68:69], v7 offset:2112
		ds_read_b64_tr_b16 v[70:71], v7 offset:3168
		ds_read_b64_tr_b16 v[72:73], v7 offset:10560
		ds_read_b64_tr_b16 v[74:75], v7 offset:11616
		ds_read_b64_tr_b16 v[76:77], v7 offset:2176
		ds_read_b64_tr_b16 v[78:79], v7 offset:3232
		ds_read_b64_tr_b16 v[80:81], v7 offset:10624
		ds_read_b64_tr_b16 v[82:83], v7 offset:11680
		s_add_i32 s0, s0, 0x80
		s_add_i32 s51, s51, s11
		s_add_i32 s1, s1, 2
		s_cmp_lt_i32 s1, 62
		s_cbranch_scc1 .Lv9_beyond_hotloop.loop_head_0
.Lv9_beyond_hotloop.loop_exit_0:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[88:91], v[52:55], v[20:23], v[88:91]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[88:91], v[56:59], v[24:27], v[88:91]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[84:87], v[60:63], v[20:23], v[84:87]
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[84:87], v[64:67], v[24:27], v[84:87]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[92:95], v[68:71], v[20:23], v[92:95]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[92:95], v[72:75], v[24:27], v[92:95]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[96:99], v[76:79], v[20:23], v[96:99]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[96:99], v[80:83], v[24:27], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[52:55], v[28:31], v[100:103]
		v_mfma_f32_16x16x32_f16 v[100:103], v[56:59], v[32:35], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[60:63], v[28:31], v[104:107]
		v_mfma_f32_16x16x32_f16 v[104:107], v[64:67], v[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[68:71], v[28:31], v[108:111]
		v_mfma_f32_16x16x32_f16 v[108:111], v[72:75], v[32:35], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[76:79], v[28:31], v[112:115]
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[32:35], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[52:55], v[36:39], v[116:119]
		v_mfma_f32_16x16x32_f16 v[116:119], v[56:59], v[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[60:63], v[36:39], v[120:123]
		v_mfma_f32_16x16x32_f16 v[120:123], v[64:67], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[68:71], v[36:39], v[124:127]
		v_mfma_f32_16x16x32_f16 v[124:127], v[72:75], v[40:43], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[76:79], v[36:39], v[128:131]
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[40:43], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[52:55], v[44:47], v[132:135]
		v_mfma_f32_16x16x32_f16 v[132:135], v[56:59], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[60:63], v[44:47], v[136:139]
		v_mfma_f32_16x16x32_f16 v[136:139], v[64:67], v[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[68:71], v[44:47], v[140:143]
		v_mfma_f32_16x16x32_f16 v[140:143], v[72:75], v[48:51], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[76:79], v[44:47], v[144:147]
		v_mfma_f32_16x16x32_f16 v[144:147], v[80:83], v[48:51], v[144:147]
		s_waitcnt vmcnt(0)
		s_barrier
		ds_read_b64_tr_b16 v[52:53], v7 offset:35712
		ds_read_b64_tr_b16 v[54:55], v7 offset:36768
		ds_read_b64_tr_b16 v[56:57], v7 offset:44160
		ds_read_b64_tr_b16 v[58:59], v7 offset:45216
		ds_read_b64_tr_b16 v[60:61], v7 offset:35776
		ds_read_b64_tr_b16 v[62:63], v7 offset:36832
		ds_read_b64_tr_b16 v[64:65], v7 offset:44224
		ds_read_b64_tr_b16 v[66:67], v7 offset:45280
		ds_read_b64_tr_b16 v[68:69], v7 offset:35840
		ds_read_b64_tr_b16 v[70:71], v7 offset:36896
		ds_read_b64_tr_b16 v[72:73], v7 offset:44288
		ds_read_b64_tr_b16 v[74:75], v7 offset:45344
		ds_read_b64_tr_b16 v[76:77], v7 offset:35904
		ds_read_b64_tr_b16 v[78:79], v7 offset:36960
		ds_read_b64_tr_b16 v[80:81], v7 offset:44352
		ds_read_b64_tr_b16 v[82:83], v7 offset:45408
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[148:151], v[52:55], v[20:23], v[148:151]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[148:151], v[56:59], v[24:27], v[148:151]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[152:155], v[60:63], v[20:23], v[152:155]
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[152:155], v[64:67], v[24:27], v[152:155]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[156:159], v[68:71], v[20:23], v[156:159]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[156:159], v[72:75], v[24:27], v[156:159]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[160:163], v[76:79], v[20:23], v[160:163]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[160:163], v[80:83], v[24:27], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[52:55], v[28:31], v[164:167]
		v_mfma_f32_16x16x32_f16 v[164:167], v[56:59], v[32:35], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[60:63], v[28:31], v[168:171]
		v_mfma_f32_16x16x32_f16 v[168:171], v[64:67], v[32:35], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[68:71], v[28:31], v[172:175]
		v_mfma_f32_16x16x32_f16 v[172:175], v[72:75], v[32:35], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[76:79], v[28:31], v[176:179]
		v_mfma_f32_16x16x32_f16 v[176:179], v[80:83], v[32:35], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[52:55], v[36:39], v[180:183]
		v_mfma_f32_16x16x32_f16 v[180:183], v[56:59], v[40:43], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[60:63], v[36:39], v[184:187]
		v_mfma_f32_16x16x32_f16 v[184:187], v[64:67], v[40:43], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[68:71], v[36:39], v[188:191]
		v_mfma_f32_16x16x32_f16 v[188:191], v[72:75], v[40:43], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[76:79], v[36:39], v[192:195]
		v_mfma_f32_16x16x32_f16 v[192:195], v[80:83], v[40:43], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[52:55], v[44:47], v[196:199]
		v_mfma_f32_16x16x32_f16 v[196:199], v[56:59], v[48:51], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[60:63], v[44:47], v[200:203]
		v_mfma_f32_16x16x32_f16 v[200:203], v[64:67], v[48:51], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[68:71], v[44:47], v[204:207]
		v_mfma_f32_16x16x32_f16 v[204:207], v[72:75], v[48:51], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[76:79], v[44:47], v[208:211]
		v_mfma_f32_16x16x32_f16 v[208:211], v[80:83], v[48:51], v[208:211]
		ds_read_b128 v[20:23], v1 offset:33760
		ds_read_b128 v[24:27], v1 offset:33824
		ds_read_b128 v[28:31], v1 offset:42208
		ds_read_b128 v[32:35], v1 offset:42272
		ds_read_b128 v[36:39], v1 offset:50656
		ds_read_b128 v[40:43], v1 offset:50720
		ds_read_b128 v[44:47], v1 offset:59104
		ds_read_b128 v[48:51], v1 offset:59168
		ds_read_b64_tr_b16 v[52:53], v7 offset:18848
		ds_read_b64_tr_b16 v[54:55], v7 offset:19904
		ds_read_b64_tr_b16 v[56:57], v7 offset:27296
		ds_read_b64_tr_b16 v[58:59], v7 offset:28352
		ds_read_b64_tr_b16 v[60:61], v7 offset:18912
		ds_read_b64_tr_b16 v[62:63], v7 offset:19968
		ds_read_b64_tr_b16 v[64:65], v7 offset:27360
		ds_read_b64_tr_b16 v[66:67], v7 offset:28416
		ds_read_b64_tr_b16 v[68:69], v7 offset:18976
		ds_read_b64_tr_b16 v[70:71], v7 offset:20032
		ds_read_b64_tr_b16 v[72:73], v7 offset:27424
		ds_read_b64_tr_b16 v[74:75], v7 offset:28480
		ds_read_b64_tr_b16 v[76:77], v7 offset:19040
		ds_read_b64_tr_b16 v[78:79], v7 offset:20096
		ds_read_b64_tr_b16 v[80:81], v7 offset:27488
		ds_read_b64_tr_b16 v[82:83], v7 offset:28544
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[88:91], v[52:55], v[20:23], v[88:91]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[88:91], v[56:59], v[24:27], v[88:91]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[84:87], v[60:63], v[20:23], v[84:87]
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[84:87], v[64:67], v[24:27], v[84:87]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[92:95], v[68:71], v[20:23], v[92:95]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[92:95], v[72:75], v[24:27], v[92:95]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[96:99], v[76:79], v[20:23], v[96:99]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[96:99], v[80:83], v[24:27], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[52:55], v[28:31], v[100:103]
		v_mfma_f32_16x16x32_f16 v[100:103], v[56:59], v[32:35], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[60:63], v[28:31], v[104:107]
		v_mfma_f32_16x16x32_f16 v[104:107], v[64:67], v[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[68:71], v[28:31], v[108:111]
		v_mfma_f32_16x16x32_f16 v[108:111], v[72:75], v[32:35], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[76:79], v[28:31], v[112:115]
		v_mfma_f32_16x16x32_f16 v[112:115], v[80:83], v[32:35], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[52:55], v[36:39], v[116:119]
		v_mfma_f32_16x16x32_f16 v[116:119], v[56:59], v[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[60:63], v[36:39], v[120:123]
		v_mfma_f32_16x16x32_f16 v[120:123], v[64:67], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[68:71], v[36:39], v[124:127]
		v_mfma_f32_16x16x32_f16 v[124:127], v[72:75], v[40:43], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[76:79], v[36:39], v[128:131]
		v_mfma_f32_16x16x32_f16 v[128:131], v[80:83], v[40:43], v[128:131]
		v_mfma_f32_16x16x32_f16 v[132:135], v[52:55], v[44:47], v[132:135]
		v_mfma_f32_16x16x32_f16 v[132:135], v[56:59], v[48:51], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[60:63], v[44:47], v[136:139]
		v_mfma_f32_16x16x32_f16 v[136:139], v[64:67], v[48:51], v[136:139]
		v_mfma_f32_16x16x32_f16 v[140:143], v[68:71], v[44:47], v[140:143]
		v_mfma_f32_16x16x32_f16 v[140:143], v[72:75], v[48:51], v[140:143]
		v_mfma_f32_16x16x32_f16 v[144:147], v[76:79], v[44:47], v[144:147]
		v_mfma_f32_16x16x32_f16 v[144:147], v[80:83], v[48:51], v[144:147]
		ds_read_b64_tr_b16 v[52:53], v7 offset:52576
		ds_read_b64_tr_b16 v[54:55], v7 offset:53632
		ds_read_b64_tr_b16 v[56:57], v7 offset:61024
		ds_read_b64_tr_b16 v[58:59], v7 offset:62080
		ds_read_b64_tr_b16 v[60:61], v7 offset:52640
		ds_read_b64_tr_b16 v[62:63], v7 offset:53696
		ds_read_b64_tr_b16 v[64:65], v7 offset:61088
		ds_read_b64_tr_b16 v[66:67], v7 offset:62144
		ds_read_b64_tr_b16 v[68:69], v7 offset:52704
		ds_read_b64_tr_b16 v[70:71], v7 offset:53760
		ds_read_b64_tr_b16 v[72:73], v7 offset:61152
		ds_read_b64_tr_b16 v[74:75], v7 offset:62208
		ds_read_b64_tr_b16 v[76:77], v7 offset:52768
		ds_read_b64_tr_b16 v[78:79], v7 offset:53824
		ds_read_b64_tr_b16 v[80:81], v7 offset:61216
		ds_read_b64_tr_b16 v[82:83], v7 offset:62272
		v_cvt_pk_f16_f32 v10, v88, v89
		v_cvt_pk_f16_f32 v11, v90, v91
		v_cvt_pk_f16_f32 v12, v84, v85
		v_cvt_pk_f16_f32 v13, v86, v87
		v_cvt_pk_f16_f32 v18, v92, v93
		v_cvt_pk_f16_f32 v19, v94, v95
		v_cvt_pk_f16_f32 v84, v96, v97
		v_cvt_pk_f16_f32 v85, v98, v99
		v_cvt_pk_f16_f32 v86, v100, v101
		v_cvt_pk_f16_f32 v87, v102, v103
		v_cvt_pk_f16_f32 v88, v104, v105
		v_cvt_pk_f16_f32 v89, v106, v107
		v_cvt_pk_f16_f32 v90, v108, v109
		v_cvt_pk_f16_f32 v91, v110, v111
		v_cvt_pk_f16_f32 v92, v112, v113
		v_cvt_pk_f16_f32 v93, v114, v115
		v_cvt_pk_f16_f32 v94, v116, v117
		v_cvt_pk_f16_f32 v95, v118, v119
		v_cvt_pk_f16_f32 v96, v120, v121
		v_cvt_pk_f16_f32 v97, v122, v123
		v_cvt_pk_f16_f32 v98, v124, v125
		v_cvt_pk_f16_f32 v99, v126, v127
		v_cvt_pk_f16_f32 v100, v128, v129
		v_cvt_pk_f16_f32 v101, v130, v131
		v_cvt_pk_f16_f32 v102, v132, v133
		v_cvt_pk_f16_f32 v103, v134, v135
		v_cvt_pk_f16_f32 v104, v136, v137
		v_cvt_pk_f16_f32 v105, v138, v139
		v_cvt_pk_f16_f32 v106, v140, v141
		v_cvt_pk_f16_f32 v107, v142, v143
		v_cvt_pk_f16_f32 v108, v144, v145
		v_cvt_pk_f16_f32 v109, v146, v147
		s_cmp_lt_i32 s28, 0
		s_cselect_b32 s29, -1, 0
		v_mov_b32_e32 v110, s28
		v_mov_b32_e32 v111, s29
		s_mov_b32 s2, 0x400
		s_mov_b32 s3, 0
		v_mov_b32_e32 v112, s2
		v_mov_b32_e32 v113, s3
		v_mul_lo_u32 v114, v112, v110
		v_mul_hi_u32 v115, v112, v110
		v_mul_lo_u32 v1, v112, v111
		v_add_u32_e32 v115, v115, v1
		v_mul_lo_u32 v1, v113, v110
		v_add_u32_e32 v115, v115, v1
		s_cmp_lt_i32 s30, 0
		s_cselect_b32 s31, -1, 0
		v_mov_b32_e32 v110, s30
		v_mov_b32_e32 v111, s31
		s_mov_b32 s2, 0x100
		s_mov_b32 s3, 0
		v_mov_b32_e32 v112, s2
		v_mov_b32_e32 v113, s3
		v_mul_lo_u32 v116, v112, v110
		v_mul_hi_u32 v117, v112, v110
		v_mul_lo_u32 v1, v112, v111
		v_add_u32_e32 v117, v117, v1
		v_mul_lo_u32 v1, v113, v110
		v_add_u32_e32 v117, v117, v1
		v_add_co_u32_e64 v110, vcc, v114, v116
		v_addc_co_u32_e64 v111, vcc, v115, v117, vcc
		s_mov_b32 s2, 1
		s_mov_b32 s3, 0
		v_mov_b32_e32 v118, v0
		v_mov_b32_e32 v119, 0
		v_mov_b32_e32 v120, s2
		v_mov_b32_e32 v121, s3
		v_mul_lo_u32 v122, v120, v118
		v_mul_hi_u32 v123, v120, v118
		v_mul_lo_u32 v1, v120, v119
		v_add_u32_e32 v123, v123, v1
		v_mul_lo_u32 v1, v121, v118
		v_add_u32_e32 v123, v123, v1
		v_lshrrev_b64 v[120:121], 7, v[122:123]
		s_mov_b32 s2, 16
		s_mov_b32 s3, 0
		v_mov_b32_e32 v124, s2
		v_mov_b32_e32 v125, s3
		v_mul_lo_u32 v126, v124, v120
		v_mul_hi_u32 v127, v124, v120
		v_mul_lo_u32 v1, v124, v121
		v_add_u32_e32 v127, v127, v1
		v_mul_lo_u32 v1, v125, v120
		v_add_u32_e32 v127, v127, v1
		v_add_co_u32_e64 v120, vcc, v110, v126
		v_addc_co_u32_e64 v121, vcc, v111, v127, vcc
		v_mov_b32_e32 v1, 1
		v_and_b32_e32 v110, v118, v1
		v_and_b32_e32 v111, v8, v8
		v_add_co_u32_e64 v118, vcc, v120, v110
		v_addc_co_u32_e64 v119, vcc, v121, v111, vcc
		v_lshrrev_b64 v[120:121], 3, v[122:123]
		v_and_b32_e32 v124, v120, v1
		v_and_b32_e32 v125, v121, v8
		s_mov_b32 s2, 8
		s_mov_b32 s3, 0
		v_mov_b32_e32 v120, s2
		v_mov_b32_e32 v121, s3
		v_mul_lo_u32 v128, v120, v124
		v_mul_hi_u32 v129, v120, v124
		v_mul_lo_u32 v3, v120, v125
		v_add_u32_e32 v129, v129, v3
		v_mul_lo_u32 v3, v121, v124
		v_add_u32_e32 v129, v129, v3
		v_add_co_u32_e64 v120, vcc, v118, v128
		v_addc_co_u32_e64 v121, vcc, v119, v129, vcc
		v_lshrrev_b64 v[118:119], 2, v[122:123]
		v_and_b32_e32 v124, v118, v1
		v_and_b32_e32 v125, v119, v8
		s_mov_b32 s2, 4
		s_mov_b32 s3, 0
		v_mov_b32_e32 v118, s2
		v_mov_b32_e32 v119, s3
		v_mul_lo_u32 v130, v118, v124
		v_mul_hi_u32 v131, v118, v124
		v_mul_lo_u32 v3, v118, v125
		v_add_u32_e32 v131, v131, v3
		v_mul_lo_u32 v3, v119, v124
		v_add_u32_e32 v131, v131, v3
		v_add_co_u32_e64 v124, vcc, v120, v130
		v_addc_co_u32_e64 v125, vcc, v121, v131, vcc
		v_lshrrev_b64 v[120:121], 1, v[122:123]
		v_and_b32_e32 v132, v120, v1
		v_and_b32_e32 v133, v121, v8
		s_mov_b32 s2, 2
		s_mov_b32 s3, 0
		v_mov_b32_e32 v120, s2
		v_mov_b32_e32 v121, s3
		v_mul_lo_u32 v134, v120, v132
		v_mul_hi_u32 v135, v120, v132
		v_mul_lo_u32 v1, v120, v133
		v_add_u32_e32 v135, v135, v1
		v_mul_lo_u32 v1, v121, v132
		v_add_u32_e32 v135, v135, v1
		v_add_co_u32_e64 v120, vcc, v124, v134
		v_addc_co_u32_e64 v121, vcc, v125, v135, vcc
		v_cmp_lt_i32_e64 vcc, v121, s1
		s_mov_b64 s[2:3], vcc
		v_cmp_eq_u32_e64 vcc, v121, s1
		s_mov_b64 s[4:5], vcc
		v_cmp_lt_u32_e64 vcc, v120, s8
		s_mov_b64 s[10:11], vcc
		s_and_b32 s14, s4, s10
		s_and_b32 s15, s5, s11
		s_or_b32 s4, s2, s14
		s_or_b32 s5, s3, s15
		v_mov_b32_e32 v1, 64
		v_add_co_u32_e64 v120, vcc, v114, v1
		v_addc_co_u32_e64 v121, vcc, v115, 0, vcc
		v_add_co_u32_e64 v124, vcc, v120, v116
		v_addc_co_u32_e64 v125, vcc, v121, v117, vcc
		v_add_co_u32_e64 v120, vcc, v124, v126
		v_addc_co_u32_e64 v121, vcc, v125, v127, vcc
		v_add_co_u32_e64 v124, vcc, v120, v110
		v_addc_co_u32_e64 v125, vcc, v121, v111, vcc
		v_add_co_u32_e64 v120, vcc, v124, v128
		v_addc_co_u32_e64 v121, vcc, v125, v129, vcc
		v_add_co_u32_e64 v124, vcc, v120, v130
		v_addc_co_u32_e64 v125, vcc, v121, v131, vcc
		v_add_co_u32_e64 v120, vcc, v124, v134
		v_addc_co_u32_e64 v121, vcc, v125, v135, vcc
		v_cmp_lt_i32_e64 vcc, v121, s1
		s_mov_b64 s[2:3], vcc
		v_cmp_eq_u32_e64 vcc, v121, s1
		s_mov_b64 s[10:11], vcc
		v_cmp_lt_u32_e64 vcc, v120, s8
		s_mov_b64 s[14:15], vcc
		s_and_b32 s16, s10, s14
		s_and_b32 s17, s11, s15
		s_or_b32 s10, s2, s16
		s_or_b32 s11, s3, s17
		v_mov_b32_e32 v3, 0x80
		v_add_co_u32_e64 v120, vcc, v114, v3
		v_addc_co_u32_e64 v121, vcc, v115, 0, vcc
		v_add_co_u32_e64 v124, vcc, v120, v116
		v_addc_co_u32_e64 v125, vcc, v121, v117, vcc
		v_add_co_u32_e64 v120, vcc, v124, v126
		v_addc_co_u32_e64 v121, vcc, v125, v127, vcc
		v_add_co_u32_e64 v124, vcc, v120, v110
		v_addc_co_u32_e64 v125, vcc, v121, v111, vcc
		v_add_co_u32_e64 v120, vcc, v124, v128
		v_addc_co_u32_e64 v121, vcc, v125, v129, vcc
		v_add_co_u32_e64 v124, vcc, v120, v130
		v_addc_co_u32_e64 v125, vcc, v121, v131, vcc
		v_add_co_u32_e64 v120, vcc, v124, v134
		v_addc_co_u32_e64 v121, vcc, v125, v135, vcc
		v_cmp_lt_i32_e64 vcc, v121, s1
		s_mov_b64 s[2:3], vcc
		v_cmp_eq_u32_e64 vcc, v121, s1
		s_mov_b64 s[14:15], vcc
		v_cmp_lt_u32_e64 vcc, v120, s8
		s_mov_b64 s[16:17], vcc
		s_and_b32 s18, s14, s16
		s_and_b32 s19, s15, s17
		s_or_b32 s14, s2, s18
		s_or_b32 s15, s3, s19
		v_mov_b32_e32 v4, 0xc0
		v_add_co_u32_e64 v120, vcc, v114, v4
		v_addc_co_u32_e64 v121, vcc, v115, 0, vcc
		v_add_co_u32_e64 v114, vcc, v120, v116
		v_addc_co_u32_e64 v115, vcc, v121, v117, vcc
		v_add_co_u32_e64 v116, vcc, v114, v126
		v_addc_co_u32_e64 v117, vcc, v115, v127, vcc
		v_add_co_u32_e64 v114, vcc, v116, v110
		v_addc_co_u32_e64 v115, vcc, v117, v111, vcc
		v_add_co_u32_e64 v110, vcc, v114, v128
		v_addc_co_u32_e64 v111, vcc, v115, v129, vcc
		v_add_co_u32_e64 v114, vcc, v110, v130
		v_addc_co_u32_e64 v115, vcc, v111, v131, vcc
		v_add_co_u32_e64 v110, vcc, v114, v134
		v_addc_co_u32_e64 v111, vcc, v115, v135, vcc
		v_cmp_lt_i32_e64 vcc, v111, s1
		s_mov_b64 s[2:3], vcc
		v_cmp_eq_u32_e64 vcc, v111, s1
		s_mov_b64 s[16:17], vcc
		v_cmp_lt_u32_e64 vcc, v110, s8
		s_mov_b64 s[18:19], vcc
		s_and_b32 s20, s16, s18
		s_and_b32 s21, s17, s19
		s_or_b32 s16, s2, s20
		s_or_b32 s17, s3, s21
		s_cmp_lt_i32 s32, 0
		s_cselect_b32 s33, -1, 0
		v_mov_b32_e32 v110, s32
		v_mov_b32_e32 v111, s33
		v_mul_lo_u32 v114, v112, v110
		v_mul_hi_u32 v115, v112, v110
		v_mul_lo_u32 v7, v112, v111
		v_add_u32_e32 v115, v115, v7
		v_mul_lo_u32 v7, v113, v110
		v_add_u32_e32 v115, v115, v7
		v_lshrrev_b64 v[110:111], 4, v[122:123]
		v_mov_b32_e32 v7, 7
		v_and_b32_e32 v112, v110, v7
		v_and_b32_e32 v113, v111, v8
		v_mul_lo_u32 v8, v118, v112
		v_mul_hi_u32 v9, v118, v112
		v_mul_lo_u32 v7, v118, v113
		v_add_u32_e32 v9, v9, v7
		v_mul_lo_u32 v7, v119, v112
		v_add_u32_e32 v9, v9, v7
		v_add_co_u32_e64 v110, vcc, v114, v8
		v_addc_co_u32_e64 v111, vcc, v115, v9, vcc
		v_cmp_lt_i32_e64 vcc, v111, s1
		s_mov_b64 s[2:3], vcc
		v_cmp_eq_u32_e64 vcc, v111, s1
		s_mov_b64 s[18:19], vcc
		v_cmp_lt_u32_e64 vcc, v110, s9
		s_mov_b64 s[20:21], vcc
		s_and_b32 s22, s18, s20
		s_and_b32 s23, s19, s21
		s_or_b32 s18, s2, s22
		s_or_b32 s19, s3, s23
		v_mov_b32_e32 v7, 32
		v_add_co_u32_e64 v110, vcc, v114, v7
		v_addc_co_u32_e64 v111, vcc, v115, 0, vcc
		v_add_co_u32_e64 v112, vcc, v110, v8
		v_addc_co_u32_e64 v113, vcc, v111, v9, vcc
		v_cmp_lt_i32_e64 vcc, v113, s1
		s_mov_b64 s[2:3], vcc
		v_cmp_eq_u32_e64 vcc, v113, s1
		s_mov_b64 s[20:21], vcc
		v_cmp_lt_u32_e64 vcc, v112, s9
		s_mov_b64 s[22:23], vcc
		s_and_b32 s24, s20, s22
		s_and_b32 s25, s21, s23
		s_or_b32 s20, s2, s24
		s_or_b32 s21, s3, s25
		v_add_co_u32_e64 v110, vcc, v114, v1
		v_addc_co_u32_e64 v111, vcc, v115, 0, vcc
		v_add_co_u32_e64 v112, vcc, v110, v8
		v_addc_co_u32_e64 v113, vcc, v111, v9, vcc
		v_cmp_lt_i32_e64 vcc, v113, s1
		s_mov_b64 s[2:3], vcc
		v_cmp_eq_u32_e64 vcc, v113, s1
		s_mov_b64 s[22:23], vcc
		v_cmp_lt_u32_e64 vcc, v112, s9
		s_mov_b64 s[24:25], vcc
		s_and_b32 s26, s22, s24
		s_and_b32 s27, s23, s25
		s_or_b32 s22, s2, s26
		s_or_b32 s23, s3, s27
		v_mov_b32_e32 v1, 0x60
		v_add_co_u32_e64 v110, vcc, v114, v1
		v_addc_co_u32_e64 v111, vcc, v115, 0, vcc
		v_add_co_u32_e64 v112, vcc, v110, v8
		v_addc_co_u32_e64 v113, vcc, v111, v9, vcc
		v_cmp_lt_i32_e64 vcc, v113, s1
		s_mov_b64 s[2:3], vcc
		v_cmp_eq_u32_e64 vcc, v113, s1
		s_mov_b64 s[24:25], vcc
		v_cmp_lt_u32_e64 vcc, v112, s9
		s_mov_b64 s[26:27], vcc
		s_and_b32 s32, s24, s26
		s_and_b32 s33, s25, s27
		s_or_b32 s24, s2, s32
		s_or_b32 s25, s3, s33
		s_mov_b32 s40, s6
		s_mov_b32 s41, s7
		s_mov_b32 s42, 0x7fffffff
		s_mov_b32 s43, 0x31016000
		s_and_b32 s2, s4, s18
		s_and_b32 s3, s5, s19
		s_mul_i32 s0, s28, s12
		s_lshl_b32 s0, s0, 11
		s_add_i32 s6, s34, s0
		s_mul_i32 s7, s30, s12
		s_lshl_b32 s7, s7, 9
		s_add_i32 s6, s6, s7
		v_lshrrev_b32_e32 v1, 8, v0
		v_mul_lo_u32 v7, s12, v1
		v_lshlrev_b32_e32 v7, 6, v7
		v_add_u32_e32 v17, s6, v7
		v_and_b32_e32 v110, 1, v0
		v_mul_lo_u32 v111, s12, v110
		v_lshlrev_b32_e32 v111, 1, v111
		v_mul_lo_u32 v112, s12, v16
		v_lshlrev_b32_e32 v112, 5, v112
		v_add3_u32 v17, v17, v111, v112
		v_and_b32_e32 v2, 1, v2
		v_mul_lo_u32 v113, s12, v2
		v_lshlrev_b32_e32 v113, 4, v113
		v_lshrrev_b32_e32 v116, 2, v0
		v_and_b32_e32 v116, 1, v116
		v_mul_lo_u32 v117, s12, v116
		v_lshlrev_b32_e32 v117, 3, v117
		v_add3_u32 v17, v17, v113, v117
		v_lshrrev_b32_e32 v118, 1, v0
		v_and_b32_e32 v118, 1, v118
		v_mul_lo_u32 v119, s12, v118
		v_lshlrev_b32_e32 v119, 2, v119
		v_add3_u32 v17, v17, v119, v15
		v_lshrrev_b32_e32 v0, 5, v0
		v_and_b32_e32 v0, 1, v0
		v_lshlrev_b32_e32 v120, 4, v0
		v_and_b32_e32 v5, 1, v5
		v_lshlrev_b32_e32 v121, 3, v5
		v_add3_u32 v17, v17, v120, v121
		v_mov_b32_e32 v122, 0x80000000
		v_cndmask_b32_e64 v17, v122, v17, s[2:3]
		buffer_store_dwordx2 v[10:11], v17, s[40:43], 0 offen
		s_and_b32 s2, s4, s20
		s_and_b32 s3, s5, s21
		v_mul_lo_u32 v6, s12, v6
		v_lshlrev_b32_e32 v6, 5, v6
		v_add_u32_e32 v10, s6, v6
		v_add3_u32 v10, v10, v111, v113
		v_add3_u32 v10, v10, v117, v119
		v_lshlrev_b32_e32 v11, 4, v14
		v_lshlrev_b32_e32 v5, 2, v5
		v_add_u32_e32 v14, 32, v5
		v_lshlrev_b32_e32 v0, 3, v0
		v_xor_b32_e32 v14, v14, v0
		v_xor_b32_e32 v14, v11, v14
		v_lshlrev_b32_e32 v14, 1, v14
		v_add_u32_e32 v17, v10, v14
		v_cndmask_b32_e64 v17, v122, v17, s[2:3]
		buffer_store_dwordx2 v[12:13], v17, s[40:43], 0 offen
		s_and_b32 s2, s4, s22
		s_and_b32 s3, s5, s23
		v_add_u32_e32 v12, 64, v5
		v_xor_b32_e32 v12, v12, v0
		v_xor_b32_e32 v12, v11, v12
		v_lshlrev_b32_e32 v12, 1, v12
		v_add_u32_e32 v10, v10, v12
		v_cndmask_b32_e64 v10, v122, v10, s[2:3]
		buffer_store_dwordx2 v[18:19], v10, s[40:43], 0 offen
		s_and_b32 s2, s4, s24
		s_and_b32 s3, s5, s25
		s_mul_i32 s8, s12, s28
		s_lshl_b32 s8, s8, 11
		s_add_i32 s13, s34, s8
		s_mul_i32 s26, s12, s30
		s_lshl_b32 s26, s26, 9
		s_add_i32 s13, s13, s26
		v_add3_u32 v10, s13, v6, v111
		v_add3_u32 v10, v10, v113, v117
		v_add_u32_e32 v5, 0x60, v5
		v_xor_b32_e32 v0, v5, v0
		v_xor_b32_e32 v0, v11, v0
		v_lshlrev_b32_e32 v0, 1, v0
		v_add3_u32 v5, v10, v119, v0
		v_cndmask_b32_e64 v5, v122, v5, s[2:3]
		buffer_store_dwordx2 v[84:85], v5, s[40:43], 0 offen
		s_and_b32 s2, s10, s18
		s_and_b32 s3, s11, s19
		v_lshlrev_b32_e32 v1, 5, v1
		v_lshlrev_b32_e32 v5, 4, v16
		v_lshlrev_b32_e32 v2, 3, v2
		v_lshlrev_b32_e32 v10, 2, v116
		v_add_u32_e32 v11, 64, v110
		v_lshlrev_b32_e32 v13, 1, v118
		v_xor_b32_e32 v11, v11, v13
		v_xor_b32_e32 v11, v10, v11
		v_xor_b32_e32 v11, v2, v11
		v_xor_b32_e32 v11, v5, v11
		v_xor_b32_e32 v11, v1, v11
		v_mul_lo_u32 v11, s12, v11
		v_lshlrev_b32_e32 v11, 1, v11
		v_add_u32_e32 v16, s6, v11
		v_add_u32_e32 v17, v16, v15
		v_add3_u32 v17, v17, v120, v121
		v_cndmask_b32_e64 v17, v122, v17, s[2:3]
		buffer_store_dwordx2 v[86:87], v17, s[40:43], 0 offen
		s_and_b32 s2, s10, s20
		s_and_b32 s3, s11, s21
		v_add_u32_e32 v17, v16, v14
		v_cndmask_b32_e64 v17, v122, v17, s[2:3]
		buffer_store_dwordx2 v[88:89], v17, s[40:43], 0 offen
		s_and_b32 s2, s10, s22
		s_and_b32 s3, s11, s23
		v_add_u32_e32 v16, v16, v12
		v_cndmask_b32_e64 v16, v122, v16, s[2:3]
		buffer_store_dwordx2 v[90:91], v16, s[40:43], 0 offen
		s_and_b32 s2, s10, s24
		s_and_b32 s3, s11, s25
		v_add3_u32 v16, s13, v11, v0
		v_cndmask_b32_e64 v16, v122, v16, s[2:3]
		buffer_store_dwordx2 v[92:93], v16, s[40:43], 0 offen
		s_and_b32 s2, s14, s18
		s_and_b32 s3, s15, s19
		v_add_u32_e32 v16, 0x80, v110
		v_xor_b32_e32 v16, v16, v13
		v_xor_b32_e32 v16, v10, v16
		v_xor_b32_e32 v16, v2, v16
		v_xor_b32_e32 v16, v5, v16
		v_xor_b32_e32 v16, v1, v16
		v_mul_lo_u32 v16, s12, v16
		v_lshlrev_b32_e32 v16, 1, v16
		v_add_u32_e32 v17, s6, v16
		v_add_u32_e32 v18, v17, v15
		v_add3_u32 v18, v18, v120, v121
		v_cndmask_b32_e64 v18, v122, v18, s[2:3]
		buffer_store_dwordx2 v[94:95], v18, s[40:43], 0 offen
		s_and_b32 s2, s14, s20
		s_and_b32 s3, s15, s21
		v_add_u32_e32 v18, v17, v14
		v_cndmask_b32_e64 v18, v122, v18, s[2:3]
		buffer_store_dwordx2 v[96:97], v18, s[40:43], 0 offen
		s_and_b32 s2, s14, s22
		s_and_b32 s3, s15, s23
		v_add_u32_e32 v17, v17, v12
		v_cndmask_b32_e64 v17, v122, v17, s[2:3]
		buffer_store_dwordx2 v[98:99], v17, s[40:43], 0 offen
		s_and_b32 s2, s14, s24
		s_and_b32 s3, s15, s25
		v_add3_u32 v17, s13, v16, v0
		v_cndmask_b32_e64 v17, v122, v17, s[2:3]
		buffer_store_dwordx2 v[100:101], v17, s[40:43], 0 offen
		s_and_b32 s2, s16, s18
		s_and_b32 s3, s17, s19
		v_add_u32_e32 v17, 0xc0, v110
		v_xor_b32_e32 v13, v17, v13
		v_xor_b32_e32 v10, v10, v13
		v_xor_b32_e32 v2, v2, v10
		v_xor_b32_e32 v2, v5, v2
		v_xor_b32_e32 v1, v1, v2
		v_mul_lo_u32 v1, s12, v1
		v_lshlrev_b32_e32 v1, 1, v1
		v_add_u32_e32 v2, s13, v1
		v_add_u32_e32 v5, v2, v15
		v_add3_u32 v5, v5, v120, v121
		v_cndmask_b32_e64 v5, v122, v5, s[2:3]
		buffer_store_dwordx2 v[102:103], v5, s[40:43], 0 offen
		s_and_b32 s2, s16, s20
		s_and_b32 s3, s17, s21
		v_add_u32_e32 v5, v2, v14
		v_cndmask_b32_e64 v5, v122, v5, s[2:3]
		buffer_store_dwordx2 v[104:105], v5, s[40:43], 0 offen
		s_and_b32 s2, s16, s22
		s_and_b32 s3, s17, s23
		v_add_u32_e32 v5, v2, v12
		v_cndmask_b32_e64 v5, v122, v5, s[2:3]
		buffer_store_dwordx2 v[106:107], v5, s[40:43], 0 offen
		s_and_b32 s2, s16, s24
		s_and_b32 s3, s17, s25
		v_add_u32_e32 v2, v2, v0
		v_cndmask_b32_e64 v2, v122, v2, s[2:3]
		buffer_store_dwordx2 v[108:109], v2, s[40:43], 0 offen
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[148:151], v[52:55], v[20:23], v[148:151]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[148:151], v[56:59], v[24:27], v[148:151]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[152:155], v[60:63], v[20:23], v[152:155]
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[152:155], v[64:67], v[24:27], v[152:155]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[156:159], v[68:71], v[20:23], v[156:159]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[156:159], v[72:75], v[24:27], v[156:159]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[160:163], v[76:79], v[20:23], v[160:163]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[160:163], v[80:83], v[24:27], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[52:55], v[28:31], v[164:167]
		v_mfma_f32_16x16x32_f16 v[164:167], v[56:59], v[32:35], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[60:63], v[28:31], v[168:171]
		v_mfma_f32_16x16x32_f16 v[168:171], v[64:67], v[32:35], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[68:71], v[28:31], v[172:175]
		v_mfma_f32_16x16x32_f16 v[172:175], v[72:75], v[32:35], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[76:79], v[28:31], v[176:179]
		v_mfma_f32_16x16x32_f16 v[176:179], v[80:83], v[32:35], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[52:55], v[36:39], v[180:183]
		v_mfma_f32_16x16x32_f16 v[180:183], v[56:59], v[40:43], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[60:63], v[36:39], v[184:187]
		v_mfma_f32_16x16x32_f16 v[184:187], v[64:67], v[40:43], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[68:71], v[36:39], v[188:191]
		v_mfma_f32_16x16x32_f16 v[188:191], v[72:75], v[40:43], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[76:79], v[36:39], v[192:195]
		v_mfma_f32_16x16x32_f16 v[192:195], v[80:83], v[40:43], v[192:195]
		v_mfma_f32_16x16x32_f16 v[196:199], v[52:55], v[44:47], v[196:199]
		v_mfma_f32_16x16x32_f16 v[196:199], v[56:59], v[48:51], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[60:63], v[44:47], v[200:203]
		v_mfma_f32_16x16x32_f16 v[200:203], v[64:67], v[48:51], v[200:203]
		v_mfma_f32_16x16x32_f16 v[204:207], v[68:71], v[44:47], v[204:207]
		v_mfma_f32_16x16x32_f16 v[204:207], v[72:75], v[48:51], v[204:207]
		v_mfma_f32_16x16x32_f16 v[208:211], v[76:79], v[44:47], v[208:211]
		v_mfma_f32_16x16x32_f16 v[208:211], v[80:83], v[48:51], v[208:211]
		v_cvt_pk_f16_f32 v18, v148, v149
		v_cvt_pk_f16_f32 v19, v150, v151
		v_cvt_pk_f16_f32 v20, v152, v153
		v_cvt_pk_f16_f32 v21, v154, v155
		v_cvt_pk_f16_f32 v22, v156, v157
		v_cvt_pk_f16_f32 v23, v158, v159
		v_cvt_pk_f16_f32 v24, v160, v161
		v_cvt_pk_f16_f32 v25, v162, v163
		v_cvt_pk_f16_f32 v26, v164, v165
		v_cvt_pk_f16_f32 v27, v166, v167
		v_cvt_pk_f16_f32 v28, v168, v169
		v_cvt_pk_f16_f32 v29, v170, v171
		v_cvt_pk_f16_f32 v30, v172, v173
		v_cvt_pk_f16_f32 v31, v174, v175
		v_cvt_pk_f16_f32 v32, v176, v177
		v_cvt_pk_f16_f32 v33, v178, v179
		v_cvt_pk_f16_f32 v34, v180, v181
		v_cvt_pk_f16_f32 v35, v182, v183
		v_cvt_pk_f16_f32 v36, v184, v185
		v_cvt_pk_f16_f32 v37, v186, v187
		v_cvt_pk_f16_f32 v38, v188, v189
		v_cvt_pk_f16_f32 v39, v190, v191
		v_cvt_pk_f16_f32 v40, v192, v193
		v_cvt_pk_f16_f32 v41, v194, v195
		v_cvt_pk_f16_f32 v42, v196, v197
		v_cvt_pk_f16_f32 v43, v198, v199
		v_cvt_pk_f16_f32 v44, v200, v201
		v_cvt_pk_f16_f32 v45, v202, v203
		v_cvt_pk_f16_f32 v46, v204, v205
		v_cvt_pk_f16_f32 v47, v206, v207
		v_cvt_pk_f16_f32 v48, v208, v209
		v_cvt_pk_f16_f32 v49, v210, v211
		v_add_co_u32_e64 v50, vcc, v114, v3
		v_addc_co_u32_e64 v51, vcc, v115, 0, vcc
		v_add_co_u32_e64 v2, vcc, v50, v8
		v_addc_co_u32_e64 v3, vcc, v51, v9, vcc
		v_cmp_lt_i32_e64 vcc, v3, s1
		s_mov_b64 s[2:3], vcc
		v_cmp_eq_u32_e64 vcc, v3, s1
		s_mov_b64 s[12:13], vcc
		v_cmp_lt_u32_e64 vcc, v2, s9
		s_mov_b64 s[18:19], vcc
		s_and_b32 s20, s12, s18
		s_and_b32 s21, s13, s19
		s_or_b32 s12, s2, s20
		s_or_b32 s13, s3, s21
		v_mov_b32_e32 v2, 0xa0
		v_add_co_u32_e64 v50, vcc, v114, v2
		v_addc_co_u32_e64 v51, vcc, v115, 0, vcc
		v_add_co_u32_e64 v2, vcc, v50, v8
		v_addc_co_u32_e64 v3, vcc, v51, v9, vcc
		v_cmp_lt_i32_e64 vcc, v3, s1
		s_mov_b64 s[2:3], vcc
		v_cmp_eq_u32_e64 vcc, v3, s1
		s_mov_b64 s[18:19], vcc
		v_cmp_lt_u32_e64 vcc, v2, s9
		s_mov_b64 s[20:21], vcc
		s_and_b32 s22, s18, s20
		s_and_b32 s23, s19, s21
		s_or_b32 s18, s2, s22
		s_or_b32 s19, s3, s23
		v_add_co_u32_e64 v2, vcc, v114, v4
		v_addc_co_u32_e64 v3, vcc, v115, 0, vcc
		v_add_co_u32_e64 v4, vcc, v2, v8
		v_addc_co_u32_e64 v5, vcc, v3, v9, vcc
		v_cmp_lt_i32_e64 vcc, v5, s1
		s_mov_b64 s[2:3], vcc
		v_cmp_eq_u32_e64 vcc, v5, s1
		s_mov_b64 s[20:21], vcc
		v_cmp_lt_u32_e64 vcc, v4, s9
		s_mov_b64 s[22:23], vcc
		s_and_b32 s24, s20, s22
		s_and_b32 s25, s21, s23
		s_or_b32 s20, s2, s24
		s_or_b32 s21, s3, s25
		v_mov_b32_e32 v2, 0xe0
		v_add_co_u32_e64 v4, vcc, v114, v2
		v_addc_co_u32_e64 v5, vcc, v115, 0, vcc
		v_add_co_u32_e64 v2, vcc, v4, v8
		v_addc_co_u32_e64 v3, vcc, v5, v9, vcc
		v_cmp_lt_i32_e64 vcc, v3, s1
		s_mov_b64 s[2:3], vcc
		v_cmp_eq_u32_e64 vcc, v3, s1
		s_mov_b64 s[22:23], vcc
		v_cmp_lt_u32_e64 vcc, v2, s9
		s_mov_b64 s[24:25], vcc
		s_and_b32 s28, s22, s24
		s_and_b32 s29, s23, s25
		s_or_b32 s22, s2, s28
		s_or_b32 s23, s3, s29
		s_and_b32 s2, s4, s12
		s_and_b32 s3, s5, s13
		s_add_i32 s0, s39, s0
		s_add_i32 s0, s0, s7
		v_add_u32_e32 v2, s0, v7
		v_add3_u32 v2, v2, v111, v112
		v_add3_u32 v2, v2, v113, v117
		v_add3_u32 v2, v2, v119, v15
		v_add3_u32 v2, v2, v120, v121
		v_cndmask_b32_e64 v2, v122, v2, s[2:3]
		buffer_store_dwordx2 v[18:19], v2, s[40:43], 0 offen
		s_and_b32 s2, s4, s18
		s_and_b32 s3, s5, s19
		v_add_u32_e32 v2, s0, v6
		v_add3_u32 v2, v2, v111, v113
		v_add3_u32 v2, v2, v117, v119
		v_add_u32_e32 v3, v2, v14
		v_cndmask_b32_e64 v3, v122, v3, s[2:3]
		buffer_store_dwordx2 v[20:21], v3, s[40:43], 0 offen
		s_and_b32 s2, s4, s20
		s_and_b32 s3, s5, s21
		v_add_u32_e32 v2, v2, v12
		v_cndmask_b32_e64 v2, v122, v2, s[2:3]
		buffer_store_dwordx2 v[22:23], v2, s[40:43], 0 offen
		s_and_b32 s2, s4, s22
		s_and_b32 s3, s5, s23
		s_add_i32 s1, s39, s8
		s_add_i32 s1, s1, s26
		v_add3_u32 v2, s1, v6, v111
		v_add3_u32 v2, v2, v113, v117
		v_add3_u32 v2, v2, v119, v0
		v_cndmask_b32_e64 v2, v122, v2, s[2:3]
		buffer_store_dwordx2 v[24:25], v2, s[40:43], 0 offen
		s_and_b32 s2, s10, s12
		s_and_b32 s3, s11, s13
		v_add_u32_e32 v2, s0, v11
		v_add_u32_e32 v3, v2, v15
		v_add3_u32 v3, v3, v120, v121
		v_cndmask_b32_e64 v3, v122, v3, s[2:3]
		buffer_store_dwordx2 v[26:27], v3, s[40:43], 0 offen
		s_and_b32 s2, s10, s18
		s_and_b32 s3, s11, s19
		v_add_u32_e32 v3, v2, v14
		v_cndmask_b32_e64 v3, v122, v3, s[2:3]
		buffer_store_dwordx2 v[28:29], v3, s[40:43], 0 offen
		s_and_b32 s2, s10, s20
		s_and_b32 s3, s11, s21
		v_add_u32_e32 v2, v2, v12
		v_cndmask_b32_e64 v2, v122, v2, s[2:3]
		buffer_store_dwordx2 v[30:31], v2, s[40:43], 0 offen
		s_and_b32 s2, s10, s22
		s_and_b32 s3, s11, s23
		v_add3_u32 v2, s1, v11, v0
		v_cndmask_b32_e64 v2, v122, v2, s[2:3]
		buffer_store_dwordx2 v[32:33], v2, s[40:43], 0 offen
		s_and_b32 s2, s14, s12
		s_and_b32 s3, s15, s13
		v_add_u32_e32 v2, s0, v16
		v_add_u32_e32 v3, v2, v15
		v_add3_u32 v3, v3, v120, v121
		v_cndmask_b32_e64 v3, v122, v3, s[2:3]
		buffer_store_dwordx2 v[34:35], v3, s[40:43], 0 offen
		s_and_b32 s2, s14, s18
		s_and_b32 s3, s15, s19
		v_add_u32_e32 v3, v2, v14
		v_cndmask_b32_e64 v3, v122, v3, s[2:3]
		buffer_store_dwordx2 v[36:37], v3, s[40:43], 0 offen
		s_and_b32 s2, s14, s20
		s_and_b32 s3, s15, s21
		v_add_u32_e32 v2, v2, v12
		v_cndmask_b32_e64 v2, v122, v2, s[2:3]
		buffer_store_dwordx2 v[38:39], v2, s[40:43], 0 offen
		s_and_b32 s2, s14, s22
		s_and_b32 s3, s15, s23
		v_add3_u32 v2, s1, v16, v0
		v_cndmask_b32_e64 v2, v122, v2, s[2:3]
		buffer_store_dwordx2 v[40:41], v2, s[40:43], 0 offen
		s_and_b32 s2, s16, s12
		s_and_b32 s3, s17, s13
		v_add_u32_e32 v1, s1, v1
		v_add_u32_e32 v2, v1, v15
		v_add3_u32 v2, v2, v120, v121
		v_cndmask_b32_e64 v2, v122, v2, s[2:3]
		buffer_store_dwordx2 v[42:43], v2, s[40:43], 0 offen
		s_and_b32 s0, s16, s18
		s_and_b32 s1, s17, s19
		v_add_u32_e32 v2, v1, v14
		v_cndmask_b32_e64 v2, v122, v2, s[0:1]
		buffer_store_dwordx2 v[44:45], v2, s[40:43], 0 offen
		s_and_b32 s0, s16, s20
		s_and_b32 s1, s17, s21
		v_add_u32_e32 v2, v1, v12
		v_cndmask_b32_e64 v2, v122, v2, s[0:1]
		buffer_store_dwordx2 v[46:47], v2, s[40:43], 0 offen
		s_and_b32 s0, s16, s22
		s_and_b32 s1, s17, s23
		v_add_u32_e32 v0, v1, v0
		v_cndmask_b32_e64 v0, v122, v0, s[0:1]
		buffer_store_dwordx2 v[48:49], v0, s[40:43], 0 offen
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	v9_beyond_hotloop, .-v9_beyond_hotloop
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel v9_beyond_hotloop
		.amdhsa_group_segment_fixed_size 134976
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 48
		.amdhsa_user_sgpr_count 13
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_user_sgpr_kernarg_preload_length 11
		.amdhsa_user_sgpr_kernarg_preload_offset 0
		.amdhsa_enable_private_segment 0
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 0
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 212
		.amdhsa_next_free_sgpr 55
		.amdhsa_accum_offset 212
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
	.set .Lv9_beyond_hotloop.num_vgpr, 212
	.set .Lv9_beyond_hotloop.num_agpr, 0
	.set .Lv9_beyond_hotloop.numbered_sgpr, 55
	.set .Lv9_beyond_hotloop.num_named_barrier, 0
	.set .Lv9_beyond_hotloop.private_seg_size, 0
	.set .Lv9_beyond_hotloop.uses_vcc, 1
	.set .Lv9_beyond_hotloop.uses_flat_scratch, 0
	.set .Lv9_beyond_hotloop.has_dyn_sized_stack, 0
	.set .Lv9_beyond_hotloop.has_recursion, 0
	.set .Lv9_beyond_hotloop.has_indirect_call, 0
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
      - .name:           arg4
        .offset:         28
        .size:           4
        .value_kind:     by_value
      - .name:           arg5
        .offset:         32
        .size:           4
        .value_kind:     by_value
      - .name:           arg6
        .offset:         36
        .size:           4
        .value_kind:     by_value
      - .name:           arg7
        .offset:         40
        .size:           4
        .value_kind:     by_value
    .group_segment_fixed_size: 134976
    .kernarg_segment_align: 8
    .kernarg_segment_size: 48
    .max_flat_workgroup_size: 512
    .name:           v9_beyond_hotloop
    .private_segment_fixed_size: 0
    .sgpr_count:     55
    .sgpr_spill_count: 0
    .symbol:         v9_beyond_hotloop.kd
    .uses_dynamic_stack: false
    .vgpr_count:     212
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
