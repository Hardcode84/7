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
		v_readfirstlane_b32 s14, v0
		s_lshl_b32 s15, s14, 2
		s_add_i32 s14, s15, 0x20f40
		s_add_i32 s15, s8, 0xff
		v_mov_b32_e32 v1, 0x4f7ffffe
		s_cmp_lt_i32 s15, 0
		v_readfirstlane_b32 s16, v0
		s_mov_b32 s17, 0xff
		v_lshrrev_b32_e32 v2, 3, v0
		s_cselect_b32 s18, s17, 0
		v_mul_lo_u32 v3, s10, v2
		s_add_i32 s19, s15, s18
		v_lshlrev_b32_e32 v2, 3, v0
		s_ashr_i32 s15, s19, 8
		v_lshrrev_b32_e32 v4, 4, v0
		s_add_i32 s18, s9, 0xff
		v_mul_lo_u32 v5, s11, v4
		s_cmp_lt_i32 s18, 0
		s_mov_b32 s20, s2
		s_mov_b32 s21, s3
		s_mov_b32 s22, 0x7fffffff
		s_mov_b32 s23, 0x31016000
		v_and_b32_e32 v4, 63, v2
		s_cselect_b32 s2, s17, 0
		v_lshlrev_b32_e32 v6, 1, v4
		s_add_i32 s3, s18, s2
		v_lshl_add_u32 v4, v3, 1, v6
		s_mov_b32 m0, s14
		s_nop 0
		ds_write_addtid_b32 v4 offset:2048
		s_ashr_i32 s2, s3, 8
		s_mov_b32 s24, s4
		s_mov_b32 s25, s5
		s_mov_b32 s26, 0x7fffffff
		s_mov_b32 s27, 0x31016000
		v_and_b32_e32 v3, 0x7f, v2
		s_and_b32 s3, s13, 7
		v_lshlrev_b32_e32 v2, 1, v3
		s_lshr_b32 s4, s13, 3
		v_lshl_add_u32 v3, v5, 1, v2
		s_mov_b32 m0, s14
		s_nop 0
		ds_write_addtid_b32 v3 offset:4096
		s_mul_i32 s5, s3, 32
		s_add_i32 s3, s5, s4
		s_mul_i32 s4, s2, 4
		s_cmp_lt_i32 s3, 0
		s_cselect_b32 s2, 1, 0
		s_xor_b32 s5, s3, -1
		s_add_i32 s13, s5, 1
		s_cmp_lg_u32 s2, 0
		s_cselect_b32 s2, s13, s3
		s_cselect_b32 s5, 1, 0
		s_cmp_lt_i32 s4, 0
		s_cselect_b32 s13, 1, 0
		s_xor_b32 s17, s4, -1
		s_add_i32 s18, s17, 1
		s_cmp_lg_u32 s13, 0
		s_cselect_b32 s13, s18, s4
		v_mov_b32_e32 v2, s13
		s_xor_b32 s17, s13, -1
		v_cvt_f32_u32_e32 v5, v2
		s_add_i32 s18, s17, 1
		v_rcp_iflag_f32_e32 v2, v5
		s_mul_i32 s17, 0x180, s10
		v_mul_f32_e32 v5, v1, v2
		s_mul_i32 s19, 0xc0, s11
		v_cvt_u32_f32_e32 v2, v5
		s_nop 0
		v_readfirstlane_b32 s28, v2
		s_mul_i32 s29, s18, s28
		s_mul_hi_u32 s30, s28, s29
		s_add_i32 s29, s28, s30
		s_mul_hi_u32 s28, s2, s29
		s_mul_i32 s29, s28, s13
		s_xor_b32 s30, s29, -1
		s_add_i32 s29, s30, 1
		s_add_i32 s30, s2, s29
		s_cmp_ge_u32 s30, s13
		s_cselect_b32 s2, 1, 0
		s_add_i32 s29, s28, 1
		s_cmp_lg_u32 s2, 0
		s_cselect_b32 s2, s29, s28
		s_cselect_b32 s28, 1, 0
		s_add_i32 s29, s30, s18
		s_cmp_lg_u32 s28, 0
		s_cselect_b32 s28, s29, s30
		s_cmp_ge_u32 s28, s13
		s_cselect_b32 s13, 1, 0
		s_add_i32 s29, s2, 1
		s_cmp_lg_u32 s13, 0
		s_cselect_b32 s13, s29, s2
		s_cselect_b32 s2, 1, 0
		s_xor_b32 s29, s3, s4
		s_cmp_lt_i32 s29, 0
		s_cselect_b32 s3, 1, 0
		s_xor_b32 s4, s13, -1
		s_add_i32 s29, s4, 1
		s_cmp_lg_u32 s3, 0
		s_cselect_b32 s30, s29, s13
		s_mul_i32 s3, s30, 4
		s_xor_b32 s4, s3, -1
		s_add_i32 s3, s4, 1
		s_add_i32 s4, s15, s3
		s_cmp_lt_i32 s4, 4
		s_cselect_b32 s3, s4, 4
		v_mov_b32_e32 v2, s3
		s_add_i32 s4, s28, s18
		v_cvt_f32_u32_e32 v5, v2
		s_cmp_lg_u32 s2, 0
		s_cselect_b32 s2, s4, s28
		v_rcp_iflag_f32_e32 v2, v5
		s_xor_b32 s4, s2, -1
		v_mul_f32_e32 v5, v1, v2
		s_add_i32 s13, s4, 1
		v_cvt_u32_f32_e32 v1, v5
		s_cmp_lg_u32 s5, 0
		s_cselect_b32 s4, s13, s2
		v_readfirstlane_b32 s2, v1
		s_xor_b32 s5, s3, -1
		v_readfirstlane_b32 s13, v1
		s_add_i32 s15, s5, 1
		s_mul_i32 s5, s15, s2
		s_mul_hi_u32 s18, s2, s5
		s_add_i32 s5, s2, s18
		s_mul_hi_u32 s2, s4, s5
		s_mul_i32 s5, s2, s3
		s_xor_b32 s2, s5, -1
		s_add_i32 s5, s2, 1
		s_add_i32 s2, s4, s5
		s_cmp_ge_u32 s2, s3
		s_cselect_b32 s5, 1, 0
		s_add_i32 s18, s2, s15
		s_cmp_lg_u32 s5, 0
		s_cselect_b32 s5, s18, s2
		s_cmp_ge_u32 s5, s3
		s_cselect_b32 s2, 1, 0
		s_add_i32 s18, s5, s15
		s_cmp_lg_u32 s2, 0
		s_cselect_b32 s28, s18, s5
		s_mul_i32 s2, s15, s13
		s_mul_hi_u32 s5, s13, s2
		s_add_i32 s2, s13, s5
		s_mul_hi_u32 s5, s4, s2
		s_mul_i32 s2, s5, s3
		s_xor_b32 s13, s2, -1
		s_add_i32 s2, s13, 1
		s_add_i32 s13, s4, s2
		s_cmp_ge_u32 s13, s3
		s_cselect_b32 s2, 1, 0
		s_add_i32 s4, s5, 1
		s_cmp_lg_u32 s2, 0
		s_cselect_b32 s2, s4, s5
		s_cselect_b32 s4, 1, 0
		s_add_i32 s5, s13, s15
		s_cmp_lg_u32 s4, 0
		s_cselect_b32 s4, s5, s13
		s_cmp_ge_u32 s4, s3
		s_cselect_b32 s3, 1, 0
		s_add_i32 s4, s2, 1
		s_cmp_lg_u32 s3, 0
		s_cselect_b32 s32, s4, s2
		s_lshr_b32 s2, s16, 6
		s_mul_i32 s3, 0x420, s2
		s_mov_b32 m0, s3
		s_mul_i32 s2, s10, s30
		s_lshl_b32 s4, s2, 11
		s_mul_i32 s2, s10, s28
		s_lshl_b32 s5, s2, 9
		s_add_i32 s2, s4, s5
		v_add_u32_e32 v1, s2, v4
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_add_i32 s13, s3, 0x2100
		s_mov_b32 m0, s13
		s_lshl_b32 s15, s10, 7
		s_add_i32 s16, s15, s4
		s_add_i32 s18, s16, s5
		v_add_u32_e32 v1, s18, v4
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_add_i32 s16, s3, 0x4200
		s_mov_b32 m0, s16
		s_lshl_b32 s34, s10, 8
		s_add_i32 s10, s34, s4
		s_add_i32 s35, s10, s5
		v_add_u32_e32 v1, s35, v4
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_add_i32 s10, s3, 0x6300
		s_mov_b32 m0, s10
		s_add_i32 s36, s17, s4
		s_add_i32 s37, s36, s5
		v_add_u32_e32 v1, s37, v4
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_add_i32 s36, s3, 0x107c0
		s_mov_b32 m0, s36
		s_lshl_b32 s38, s32, 9
		v_add_u32_e32 v1, s38, v3
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		s_add_i32 s39, s3, 0x128c0
		s_mov_b32 m0, s39
		s_lshl_b32 s40, s11, 6
		s_add_i32 s41, s40, s38
		v_add_u32_e32 v1, s41, v3
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		s_add_i32 s42, s3, 0x18b80
		s_mov_b32 m0, s42
		s_add_i32 s43, s38, 0x100
		v_add_u32_e32 v1, s43, v3
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		s_add_i32 s44, s3, 0x1ac80
		s_mov_b32 m0, s44
		s_add_i32 s45, s40, 0x100
		s_add_i32 s40, s45, s38
		v_add_u32_e32 v1, s40, v3
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		s_add_i32 s45, s3, 0x83e0
		s_mov_b32 m0, s45
		s_add_i32 s46, s4, 0x80
		s_add_i32 s47, s46, s5
		v_add_u32_e32 v1, s47, v4
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_add_i32 s46, s3, 0xa4e0
		s_mov_b32 m0, s46
		s_add_i32 s48, s15, 0x80
		s_add_i32 s15, s48, s4
		s_add_i32 s48, s15, s5
		v_add_u32_e32 v1, s48, v4
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_add_i32 s15, s3, 0xc5e0
		s_mov_b32 m0, s15
		s_add_i32 s49, s34, 0x80
		s_add_i32 s34, s49, s4
		s_add_i32 s49, s34, s5
		v_add_u32_e32 v1, s49, v4
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_add_i32 s34, s3, 0xe6e0
		s_mov_b32 m0, s34
		s_add_i32 s50, s17, 0x80
		s_add_i32 s17, s50, s4
		s_add_i32 s4, s17, s5
		v_add_u32_e32 v1, s4, v4
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_add_i32 s5, s3, 0x149a0
		s_mov_b32 m0, s5
		s_lshl_b32 s17, s11, 7
		s_add_i32 s50, s17, s38
		v_add_u32_e32 v1, s50, v3
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		s_add_i32 s51, s3, 0x16aa0
		s_add_i32 s52, s19, s38
		v_add_u32_e32 v1, s52, v3
		s_mov_b32 m0, s51
		s_nop 0
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		s_add_i32 s53, s3, 0x1cd60
		s_add_i32 s54, s17, 0x100
		s_add_i32 s17, s54, s38
		v_add_u32_e32 v1, s17, v3
		s_mov_b32 m0, s53
		s_nop 0
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		s_add_i32 s54, s3, 0x1ee60
		s_add_i32 s55, s19, 0x100
		s_add_i32 s19, s55, s38
		v_add_u32_e32 v1, s19, v3
		s_mov_b32 m0, s54
		s_nop 0
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		v_mov_b32_e32 v8, 0
		s_mul_i32 s55, s11, 64
		s_add_i32 s11, s55, s55
		v_mov_b32_e32 v9, 0
		v_mov_b32_e32 v10, 0
		v_mov_b32_e32 v11, 0
		s_waitcnt vmcnt(10)
		s_barrier
		v_and_b32_e32 v1, 63, v0
		v_lshrrev_b32_e32 v2, 7, v0
		v_and_b32_e32 v5, 15, v1
		v_lshl_add_u32 v6, v2, 4, v5
		v_lshrrev_b32_e32 v7, 4, v1
		v_lshrrev_b32_e32 v1, 2, v5
		v_lshl_add_u32 v12, v7, 3, v1
		v_lshrrev_b32_e32 v13, 5, v6
		v_lshrrev_b32_e32 v6, 3, v5
		v_and_b32_e32 v14, 1, v2
		v_lshrrev_b32_e32 v2, 4, v12
		v_mov_b32_e32 v12, 0x1080
		v_mul_lo_u32 v12, v12, v13
		v_lshl_add_u32 v13, v7, 4, v12
		v_mov_b32_e32 v12, 0x420
		v_mul_lo_u32 v12, v12, v6
		v_mov_b32_e32 v6, 0x1080
		v_mul_lo_u32 v6, v6, v2
		v_lshrrev_b32_e32 v2, 6, v0
		v_mov_b32_e32 v15, 0x840
		v_mul_lo_u32 v15, v15, v14
		v_add3_u32 v14, v13, v12, v15
		v_and_b32_e32 v12, 1, v1
		v_lshrrev_b32_e32 v13, 1, v5
		v_and_b32_e32 v15, 1, v2
		v_and_b32_e32 v2, 1, v7
		v_add_u32_e32 v7, 0x10000, v6
		v_lshl_add_u32 v6, v12, 9, v14
		v_and_b32_e32 v12, 1, v13
		v_lshl_add_u32 v13, v1, 8, v7
		v_lshlrev_b32_e32 v1, 5, v15
		v_mov_b32_e32 v7, 0x840
		v_mul_lo_u32 v7, v7, v2
		v_lshl_add_u32 v2, v12, 8, v6
		v_and_b32_e32 v6, 1, v5
		v_add3_u32 v12, v13, v1, v7
		v_and_b32_e32 v1, 3, v5
		v_lshl_add_u32 v5, v6, 7, v2
		v_lshl_add_u32 v2, v1, 3, v12
		ds_read_b128 v[12:15], v5
		ds_read_b128 v[16:19], v5 offset:64
		ds_read_b128 v[20:23], v5 offset:8448
		ds_read_b128 v[24:27], v5 offset:8512
		ds_read_b128 v[28:31], v5 offset:16896
		ds_read_b128 v[32:35], v5 offset:16960
		ds_read_b128 v[36:39], v5 offset:25344
		ds_read_b128 v[40:43], v5 offset:25408
		ds_read_b64_tr_b16 v[44:45], v2 offset:1984
		ds_read_b64_tr_b16 v[46:47], v2 offset:3040
		ds_read_b64_tr_b16 v[48:49], v2 offset:10432
		ds_read_b64_tr_b16 v[50:51], v2 offset:11488
		ds_read_b64_tr_b16 v[52:53], v2 offset:2048
		ds_read_b64_tr_b16 v[54:55], v2 offset:3104
		ds_read_b64_tr_b16 v[56:57], v2 offset:10496
		ds_read_b64_tr_b16 v[58:59], v2 offset:11552
		ds_read_b64_tr_b16 v[60:61], v2 offset:2112
		ds_read_b64_tr_b16 v[62:63], v2 offset:3168
		ds_read_b64_tr_b16 v[64:65], v2 offset:10560
		ds_read_b64_tr_b16 v[66:67], v2 offset:11616
		ds_read_b64_tr_b16 v[68:69], v2 offset:2176
		ds_read_b64_tr_b16 v[70:71], v2 offset:3232
		ds_read_b64_tr_b16 v[72:73], v2 offset:10624
		ds_read_b64_tr_b16 v[74:75], v2 offset:11680
		v_mov_b32_e32 v76, v8
		v_mov_b32_e32 v77, v9
		v_mov_b32_e32 v78, v10
		v_mov_b32_e32 v79, v11
		s_mov_b32 m0, s14
		s_nop 0
		ds_write_addtid_b32 v76 offset:14336
		s_mov_b32 m0, s14
		s_nop 0
		ds_write_addtid_b32 v77 offset:16384
		s_mov_b32 m0, s14
		s_nop 0
		ds_write_addtid_b32 v78 offset:18432
		s_mov_b32 m0, s14
		s_nop 0
		ds_write_addtid_b32 v79 offset:20480
		s_mov_b32 s0, 0x80
		s_mov_b32 s1, 0
		s_cmp_lt_i32 0, 62
		v_mov_b32_e32 v8, 0
		v_mov_b32_e32 v9, 0
		v_mov_b32_e32 v10, 0
		v_mov_b32_e32 v11, 0
		v_mov_b32_e32 v76, 0
		v_mov_b32_e32 v77, 0
		v_mov_b32_e32 v78, 0
		v_mov_b32_e32 v79, 0
		v_mov_b32_e32 v80, 0
		v_mov_b32_e32 v81, 0
		v_mov_b32_e32 v82, 0
		v_mov_b32_e32 v83, 0
		v_mov_b32_e32 v84, 0
		v_mov_b32_e32 v85, 0
		v_mov_b32_e32 v86, 0
		v_mov_b32_e32 v87, 0
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
		s_cbranch_scc0 .Lv9_beyond_hotloop.loop_exit_0
.Lv9_beyond_hotloop.loop_head_0:
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[8:11], v[44:47], v[12:15], v[8:11]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[8:11], v[48:51], v[16:19], v[8:11]
		s_mov_b32 m0, s14
		s_waitcnt lgkmcnt(0)
		s_nop 0
		ds_read_addtid_b32 v196 offset:14336
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v197 offset:16384
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v198 offset:18432
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v199 offset:20480
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[196:199], v[52:55], v[12:15], v[196:199]
		v_mfma_f32_16x16x32_f16 v[196:199], v[56:59], v[16:19], v[196:199]
		s_mov_b32 s56, 0
		s_nop 6
		scratch_store_dword off, v196, s56
		scratch_store_dword off, v197, s56 offset:4
		scratch_store_dword off, v198, s56 offset:8
		scratch_store_dword off, v199, s56 offset:12
		v_mfma_f32_16x16x32_f16 v[76:79], v[60:63], v[12:15], v[76:79]
		v_mfma_f32_16x16x32_f16 v[76:79], v[64:67], v[16:19], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], v[68:71], v[12:15], v[80:83]
		v_mfma_f32_16x16x32_f16 v[80:83], v[72:75], v[16:19], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], v[44:47], v[20:23], v[84:87]
		v_mfma_f32_16x16x32_f16 v[84:87], v[48:51], v[24:27], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], v[52:55], v[20:23], v[88:91]
		v_mfma_f32_16x16x32_f16 v[88:91], v[56:59], v[24:27], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[60:63], v[20:23], v[92:95]
		v_mfma_f32_16x16x32_f16 v[92:95], v[64:67], v[24:27], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[68:71], v[20:23], v[96:99]
		v_mfma_f32_16x16x32_f16 v[96:99], v[72:75], v[24:27], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[44:47], v[28:31], v[100:103]
		v_mfma_f32_16x16x32_f16 v[100:103], v[48:51], v[32:35], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[52:55], v[28:31], v[104:107]
		v_mfma_f32_16x16x32_f16 v[104:107], v[56:59], v[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[60:63], v[28:31], v[108:111]
		v_mfma_f32_16x16x32_f16 v[108:111], v[64:67], v[32:35], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[68:71], v[28:31], v[112:115]
		v_mfma_f32_16x16x32_f16 v[112:115], v[72:75], v[32:35], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[44:47], v[36:39], v[116:119]
		v_mfma_f32_16x16x32_f16 v[116:119], v[48:51], v[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[52:55], v[36:39], v[120:123]
		v_mfma_f32_16x16x32_f16 v[120:123], v[56:59], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[60:63], v[36:39], v[124:127]
		v_mfma_f32_16x16x32_f16 v[124:127], v[64:67], v[40:43], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[68:71], v[36:39], v[128:131]
		v_mfma_f32_16x16x32_f16 v[128:131], v[72:75], v[40:43], v[128:131]
		s_waitcnt vmcnt(8)
		s_barrier
		s_mov_b32 m0, s3
		s_lshl_b32 s56, s0, 1
		s_add_i32 s57, s2, s56
		v_add_u32_e32 v1, s57, v4
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_mov_b32 m0, s13
		s_add_i32 s57, s18, s56
		v_add_u32_e32 v1, s57, v4
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_mov_b32 m0, s16
		s_add_i32 s57, s35, s56
		v_add_u32_e32 v1, s57, v4
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_add_i32 s57, s37, s56
		v_add_u32_e32 v1, s57, v4
		s_mov_b32 m0, s10
		s_nop 0
		buffer_load_dwordx4 v1, s[20:23], 0 offen lds
		s_lshl_b32 s57, s11, 1
		s_add_i32 s58, s38, s57
		v_add_u32_e32 v1, s58, v3
		s_mov_b32 m0, s36
		s_nop 0
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		ds_read_b64_tr_b16 v[196:197], v2 offset:35712
		s_add_i32 s58, s41, s57
		ds_read_b64_tr_b16 v[198:199], v2 offset:36768
		v_add_u32_e32 v1, s58, v3
		ds_read_b64_tr_b16 v[200:201], v2 offset:35776
		s_mov_b32 m0, s39
		s_nop 0
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		ds_read_b64_tr_b16 v[202:203], v2 offset:36832
		ds_read_b64_tr_b16 v[204:205], v2 offset:35840
		ds_read_b64_tr_b16 v[206:207], v2 offset:36896
		ds_read_b64_tr_b16 v[208:209], v2 offset:35904
		ds_read_b64_tr_b16 v[210:211], v2 offset:36960
		ds_read_b64_tr_b16 v[212:213], v2 offset:44160
		ds_read_b64_tr_b16 v[214:215], v2 offset:45216
		ds_read_b64_tr_b16 v[216:217], v2 offset:44224
		ds_read_b64_tr_b16 v[218:219], v2 offset:45280
		ds_read_b64_tr_b16 v[220:221], v2 offset:44288
		ds_read_b64_tr_b16 v[222:223], v2 offset:45344
		ds_read_b64_tr_b16 v[224:225], v2 offset:44352
		ds_read_b64_tr_b16 v[226:227], v2 offset:45408
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[132:135], v[196:199], v[12:15], v[132:135]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[136:139], v[200:203], v[12:15], v[136:139]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[140:143], v[204:207], v[12:15], v[140:143]
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[144:147], v[208:211], v[12:15], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[196:199], v[20:23], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[200:203], v[20:23], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[204:207], v[20:23], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[208:211], v[20:23], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[196:199], v[28:31], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[200:203], v[28:31], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[204:207], v[28:31], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[208:211], v[28:31], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[196:199], v[36:39], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[200:203], v[36:39], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[204:207], v[36:39], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[208:211], v[36:39], v[192:195]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[132:135], v[212:215], v[16:19], v[132:135]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[136:139], v[216:219], v[16:19], v[136:139]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[140:143], v[220:223], v[16:19], v[140:143]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[144:147], v[224:227], v[16:19], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[212:215], v[24:27], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[216:219], v[24:27], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[220:223], v[24:27], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[224:227], v[24:27], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[212:215], v[32:35], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[216:219], v[32:35], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[220:223], v[32:35], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[224:227], v[32:35], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[212:215], v[40:43], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[216:219], v[40:43], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[220:223], v[40:43], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[224:227], v[40:43], v[192:195]
		s_waitcnt vmcnt(8)
		s_barrier
		ds_read_b128 v[196:199], v5 offset:33760
		s_mov_b32 s58, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v196, s58 offset:48
		scratch_store_dword off, v197, s58 offset:52
		scratch_store_dword off, v198, s58 offset:56
		scratch_store_dword off, v199, s58 offset:60
		ds_read_b128 v[200:203], v5 offset:33824
		s_mov_b32 s58, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v200, s58 offset:64
		scratch_store_dword off, v201, s58 offset:68
		scratch_store_dword off, v202, s58 offset:72
		scratch_store_dword off, v203, s58 offset:76
		ds_read_b128 v[204:207], v5 offset:42208
		s_mov_b32 s58, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v204, s58 offset:80
		scratch_store_dword off, v205, s58 offset:84
		scratch_store_dword off, v206, s58 offset:88
		scratch_store_dword off, v207, s58 offset:92
		ds_read_b128 v[208:211], v5 offset:42272
		ds_read_b128 v[212:215], v5 offset:50656
		ds_read_b128 v[216:219], v5 offset:50720
		ds_read_b128 v[220:223], v5 offset:59104
		ds_read_b128 v[224:227], v5 offset:59168
		ds_read_b64_tr_b16 v[228:229], v2 offset:18848
		ds_read_b64_tr_b16 v[230:231], v2 offset:19904
		s_mov_b32 m0, s14
		s_waitcnt lgkmcnt(0)
		s_nop 0
		ds_write_addtid_b32 v228 offset:6144
		s_mov_b32 m0, s14
		s_nop 0
		ds_write_addtid_b32 v229 offset:8192
		s_mov_b32 m0, s14
		s_nop 0
		ds_write_addtid_b32 v230 offset:10240
		s_mov_b32 m0, s14
		s_nop 0
		ds_write_addtid_b32 v231 offset:12288
		ds_read_b64_tr_b16 v[228:229], v2 offset:27296
		ds_read_b64_tr_b16 v[230:231], v2 offset:28352
		s_mov_b32 s58, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s58 offset:16
		scratch_store_dword off, v229, s58 offset:20
		scratch_store_dword off, v230, s58 offset:24
		scratch_store_dword off, v231, s58 offset:28
		ds_read_b64_tr_b16 v[228:229], v2 offset:18912
		ds_read_b64_tr_b16 v[230:231], v2 offset:19968
		s_mov_b32 s58, 0
		s_waitcnt lgkmcnt(0)
		scratch_store_dword off, v228, s58 offset:32
		scratch_store_dword off, v229, s58 offset:36
		scratch_store_dword off, v230, s58 offset:40
		scratch_store_dword off, v231, s58 offset:44
		ds_read_b64_tr_b16 v[232:233], v2 offset:27360
		ds_read_b64_tr_b16 v[234:235], v2 offset:28416
		ds_read_b64_tr_b16 v[236:237], v2 offset:18976
		ds_read_b64_tr_b16 v[238:239], v2 offset:20032
		ds_read_b64_tr_b16 v[240:241], v2 offset:27424
		ds_read_b64_tr_b16 v[242:243], v2 offset:28480
		v_and_b32_e32 v1, 63, v0
		v_and_b32_e32 v6, 15, v1
		v_and_b32_e32 v7, 3, v6
		s_mov_b32 m0, s14
		s_nop 0
		ds_write_addtid_b32 v7
		v_lshrrev_b32_e32 v7, 2, v6
		v_lshrrev_b32_e32 v6, 4, v1
		v_lshl_add_u32 v1, v6, 3, v7
		v_lshrrev_b32_e32 v244, 4, v1
		v_mov_b32_e32 v1, 0x1080
		v_mul_lo_u32 v1, v1, v244
		v_add_u32_e32 v244, 0x10000, v1
		v_lshl_add_u32 v1, v7, 8, v244
		v_lshrrev_b32_e32 v7, 6, v0
		v_and_b32_e32 v244, 1, v7
		v_lshlrev_b32_e32 v7, 5, v244
		v_and_b32_e32 v244, 1, v6
		v_mov_b32_e32 v6, 0x840
		v_mul_lo_u32 v6, v6, v244
		v_add3_u32 v244, v1, v7, v6
		s_mov_b32 m0, s14
		s_waitcnt lgkmcnt(0)
		s_nop 0
		ds_read_addtid_b32 v1
		s_waitcnt lgkmcnt(0)
		v_lshl_add_u32 v6, v1, 3, v244
		s_mov_b32 m0, s14
		s_nop 0
		ds_write_addtid_b32 v6 offset:22528
		ds_read_b64_tr_b16 v[244:245], v6 offset:19040
		ds_read_b64_tr_b16 v[246:247], v6 offset:20096
		ds_read_b64_tr_b16 v[248:249], v6 offset:27488
		ds_read_b64_tr_b16 v[250:251], v6 offset:28544
		s_mov_b32 m0, s42
		s_add_i32 s58, s43, s57
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:4096
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v6, s58, v1
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v252 offset:6144
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v253 offset:8192
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v254 offset:10240
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v255 offset:12288
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[8:11], v[252:255], v[196:199], v[8:11]
		s_mov_b32 s58, 0
		s_waitcnt vmcnt(4)
		scratch_load_dword v252, off, s58 offset:16
		scratch_load_dword v253, off, s58 offset:20
		scratch_load_dword v254, off, s58 offset:24
		scratch_load_dword v255, off, s58 offset:28
		s_waitcnt vmcnt(0)
		v_mfma_f32_16x16x32_f16 v[8:11], v[252:255], v[200:203], v[8:11]
		s_mov_b32 s58, 0
		scratch_load_dword v252, off, s58
		scratch_load_dword v253, off, s58 offset:4
		scratch_load_dword v254, off, s58 offset:8
		scratch_load_dword v255, off, s58 offset:12
		s_waitcnt vmcnt(0)
		v_mfma_f32_16x16x32_f16 v[252:255], v[228:231], v[196:199], v[252:255]
		v_mfma_f32_16x16x32_f16 v[252:255], v[232:235], v[200:203], v[252:255]
		v_mfma_f32_16x16x32_f16 v[76:79], v[236:239], v[196:199], v[76:79]
		v_mfma_f32_16x16x32_f16 v[76:79], v[240:243], v[200:203], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], v[244:247], v[196:199], v[80:83]
		v_mfma_f32_16x16x32_f16 v[80:83], v[248:251], v[200:203], v[80:83]
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v196 offset:6144
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v197 offset:8192
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v198 offset:10240
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v199 offset:12288
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[84:87], v[196:199], v[204:207], v[84:87]
		s_mov_b32 s58, 0
		scratch_load_dword v196, off, s58 offset:16
		scratch_load_dword v197, off, s58 offset:20
		scratch_load_dword v198, off, s58 offset:24
		scratch_load_dword v199, off, s58 offset:28
		s_waitcnt vmcnt(0)
		v_mfma_f32_16x16x32_f16 v[84:87], v[196:199], v[208:211], v[84:87]
		s_mov_b32 s58, 0
		s_waitcnt vmcnt(0)
		scratch_load_dword v196, off, s58 offset:32
		scratch_load_dword v197, off, s58 offset:36
		scratch_load_dword v198, off, s58 offset:40
		scratch_load_dword v199, off, s58 offset:44
		s_waitcnt vmcnt(0)
		v_mfma_f32_16x16x32_f16 v[88:91], v[196:199], v[204:207], v[88:91]
		v_mfma_f32_16x16x32_f16 v[88:91], v[232:235], v[208:211], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[236:239], v[204:207], v[92:95]
		v_mfma_f32_16x16x32_f16 v[92:95], v[240:243], v[208:211], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[244:247], v[204:207], v[96:99]
		s_mov_b32 m0, s44
		s_add_i32 s58, s40, s57
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:4096
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v6, s58, v1
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		s_add_i32 s58, s11, s55
		v_mfma_f32_16x16x32_f16 v[96:99], v[248:251], v[208:211], v[96:99]
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v196 offset:6144
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v197 offset:8192
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v198 offset:10240
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v199 offset:12288
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[100:103], v[196:199], v[212:215], v[100:103]
		s_mov_b32 s11, 0
		scratch_load_dword v196, off, s11 offset:16
		scratch_load_dword v197, off, s11 offset:20
		scratch_load_dword v198, off, s11 offset:24
		scratch_load_dword v199, off, s11 offset:28
		s_waitcnt vmcnt(0)
		v_mfma_f32_16x16x32_f16 v[100:103], v[196:199], v[216:219], v[100:103]
		s_mov_b32 s11, 0
		scratch_load_dword v196, off, s11 offset:32
		scratch_load_dword v197, off, s11 offset:36
		scratch_load_dword v198, off, s11 offset:40
		scratch_load_dword v199, off, s11 offset:44
		s_waitcnt vmcnt(0)
		v_mfma_f32_16x16x32_f16 v[104:107], v[196:199], v[212:215], v[104:107]
		v_mfma_f32_16x16x32_f16 v[104:107], v[232:235], v[216:219], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[236:239], v[212:215], v[108:111]
		v_mfma_f32_16x16x32_f16 v[108:111], v[240:243], v[216:219], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[244:247], v[212:215], v[112:115]
		v_mfma_f32_16x16x32_f16 v[112:115], v[248:251], v[216:219], v[112:115]
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v196 offset:6144
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v197 offset:8192
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v198 offset:10240
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v199 offset:12288
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[116:119], v[196:199], v[220:223], v[116:119]
		s_mov_b32 s11, 0
		scratch_load_dword v196, off, s11 offset:16
		scratch_load_dword v197, off, s11 offset:20
		scratch_load_dword v198, off, s11 offset:24
		scratch_load_dword v199, off, s11 offset:28
		s_waitcnt vmcnt(0)
		v_mfma_f32_16x16x32_f16 v[116:119], v[196:199], v[224:227], v[116:119]
		s_mov_b32 s11, 0
		scratch_load_dword v196, off, s11 offset:32
		scratch_load_dword v197, off, s11 offset:36
		scratch_load_dword v198, off, s11 offset:40
		scratch_load_dword v199, off, s11 offset:44
		s_waitcnt vmcnt(0)
		v_mfma_f32_16x16x32_f16 v[120:123], v[196:199], v[220:223], v[120:123]
		v_mfma_f32_16x16x32_f16 v[120:123], v[232:235], v[224:227], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[236:239], v[220:223], v[124:127]
		v_mfma_f32_16x16x32_f16 v[124:127], v[240:243], v[224:227], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[244:247], v[220:223], v[128:131]
		v_mfma_f32_16x16x32_f16 v[128:131], v[248:251], v[224:227], v[128:131]
		s_barrier
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[196:197], v1 offset:52576
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[198:199], v1 offset:53632
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[200:201], v1 offset:61024
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[202:203], v1 offset:62080
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[204:205], v1 offset:52640
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[206:207], v1 offset:53696
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[228:229], v1 offset:61088
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[230:231], v1 offset:62144
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[232:233], v1 offset:52704
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[234:235], v1 offset:53760
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[236:237], v1 offset:61152
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[238:239], v1 offset:62208
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[240:241], v1 offset:52768
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[242:243], v1 offset:53824
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[244:245], v1 offset:61216
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[246:247], v1 offset:62272
		s_mov_b32 m0, s45
		s_add_i32 s11, s47, s56
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:2048
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v6, s11, v1
		buffer_load_dwordx4 v6, s[20:23], 0 offen lds
		s_mov_b32 m0, s46
		s_add_i32 s11, s48, s56
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:2048
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v6, s11, v1
		buffer_load_dwordx4 v6, s[20:23], 0 offen lds
		s_mov_b32 m0, s15
		s_add_i32 s11, s49, s56
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:2048
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v6, s11, v1
		buffer_load_dwordx4 v6, s[20:23], 0 offen lds
		s_mov_b32 m0, s34
		s_add_i32 s11, s4, s56
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:2048
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v6, s11, v1
		buffer_load_dwordx4 v6, s[20:23], 0 offen lds
		s_mov_b32 m0, s5
		s_add_i32 s11, s50, s57
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:4096
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v6, s11, v1
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		s_mov_b32 s11, 0
		scratch_load_dword v248, off, s11 offset:48
		scratch_load_dword v249, off, s11 offset:52
		scratch_load_dword v250, off, s11 offset:56
		scratch_load_dword v251, off, s11 offset:60
		s_waitcnt vmcnt(0)
		v_mfma_f32_16x16x32_f16 v[132:135], v[196:199], v[248:251], v[132:135]
		s_mov_b32 s11, 0
		scratch_load_dword v248, off, s11 offset:64
		scratch_load_dword v249, off, s11 offset:68
		scratch_load_dword v250, off, s11 offset:72
		scratch_load_dword v251, off, s11 offset:76
		s_waitcnt vmcnt(0)
		v_mfma_f32_16x16x32_f16 v[132:135], v[200:203], v[248:251], v[132:135]
		s_mov_b32 s11, 0
		scratch_load_dword v248, off, s11 offset:48
		scratch_load_dword v249, off, s11 offset:52
		scratch_load_dword v250, off, s11 offset:56
		scratch_load_dword v251, off, s11 offset:60
		s_waitcnt vmcnt(0)
		v_mfma_f32_16x16x32_f16 v[136:139], v[204:207], v[248:251], v[136:139]
		s_mov_b32 s11, 0
		scratch_load_dword v248, off, s11 offset:64
		scratch_load_dword v249, off, s11 offset:68
		scratch_load_dword v250, off, s11 offset:72
		scratch_load_dword v251, off, s11 offset:76
		s_waitcnt vmcnt(0)
		v_mfma_f32_16x16x32_f16 v[136:139], v[228:231], v[248:251], v[136:139]
		s_mov_b32 s11, 0
		scratch_load_dword v248, off, s11 offset:48
		scratch_load_dword v249, off, s11 offset:52
		scratch_load_dword v250, off, s11 offset:56
		scratch_load_dword v251, off, s11 offset:60
		s_waitcnt vmcnt(0)
		v_mfma_f32_16x16x32_f16 v[140:143], v[232:235], v[248:251], v[140:143]
		s_mov_b32 s11, 0
		scratch_load_dword v248, off, s11 offset:64
		scratch_load_dword v249, off, s11 offset:68
		scratch_load_dword v250, off, s11 offset:72
		scratch_load_dword v251, off, s11 offset:76
		s_waitcnt vmcnt(0)
		v_mfma_f32_16x16x32_f16 v[140:143], v[236:239], v[248:251], v[140:143]
		s_mov_b32 s11, 0
		scratch_load_dword v248, off, s11 offset:48
		scratch_load_dword v249, off, s11 offset:52
		scratch_load_dword v250, off, s11 offset:56
		scratch_load_dword v251, off, s11 offset:60
		s_waitcnt vmcnt(0)
		v_mfma_f32_16x16x32_f16 v[144:147], v[240:243], v[248:251], v[144:147]
		s_mov_b32 s11, 0
		scratch_load_dword v248, off, s11 offset:64
		scratch_load_dword v249, off, s11 offset:68
		scratch_load_dword v250, off, s11 offset:72
		scratch_load_dword v251, off, s11 offset:76
		s_waitcnt vmcnt(0)
		v_mfma_f32_16x16x32_f16 v[144:147], v[244:247], v[248:251], v[144:147]
		s_mov_b32 s11, 0
		scratch_load_dword v248, off, s11 offset:80
		scratch_load_dword v249, off, s11 offset:84
		scratch_load_dword v250, off, s11 offset:88
		scratch_load_dword v251, off, s11 offset:92
		s_waitcnt vmcnt(0)
		v_mfma_f32_16x16x32_f16 v[148:151], v[196:199], v[248:251], v[148:151]
		v_mfma_f32_16x16x32_f16 v[148:151], v[200:203], v[208:211], v[148:151]
		s_mov_b32 s11, 0
		scratch_load_dword v248, off, s11 offset:80
		scratch_load_dword v249, off, s11 offset:84
		scratch_load_dword v250, off, s11 offset:88
		scratch_load_dword v251, off, s11 offset:92
		s_waitcnt vmcnt(0)
		v_mfma_f32_16x16x32_f16 v[152:155], v[204:207], v[248:251], v[152:155]
		v_mfma_f32_16x16x32_f16 v[152:155], v[228:231], v[208:211], v[152:155]
		s_mov_b32 s11, 0
		scratch_load_dword v248, off, s11 offset:80
		scratch_load_dword v249, off, s11 offset:84
		scratch_load_dword v250, off, s11 offset:88
		scratch_load_dword v251, off, s11 offset:92
		s_waitcnt vmcnt(0)
		v_mfma_f32_16x16x32_f16 v[156:159], v[232:235], v[248:251], v[156:159]
		v_mfma_f32_16x16x32_f16 v[156:159], v[236:239], v[208:211], v[156:159]
		s_mov_b32 s11, 0
		scratch_load_dword v248, off, s11 offset:80
		scratch_load_dword v249, off, s11 offset:84
		scratch_load_dword v250, off, s11 offset:88
		scratch_load_dword v251, off, s11 offset:92
		s_waitcnt vmcnt(0)
		v_mfma_f32_16x16x32_f16 v[160:163], v[240:243], v[248:251], v[160:163]
		s_mov_b32 m0, s51
		s_add_i32 s11, s52, s57
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:4096
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v6, s11, v1
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		v_mfma_f32_16x16x32_f16 v[160:163], v[244:247], v[208:211], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[196:199], v[212:215], v[164:167]
		v_mfma_f32_16x16x32_f16 v[164:167], v[200:203], v[216:219], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[204:207], v[212:215], v[168:171]
		v_mfma_f32_16x16x32_f16 v[168:171], v[228:231], v[216:219], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[232:235], v[212:215], v[172:175]
		v_mfma_f32_16x16x32_f16 v[172:175], v[236:239], v[216:219], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[240:243], v[212:215], v[176:179]
		v_mfma_f32_16x16x32_f16 v[176:179], v[244:247], v[216:219], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[196:199], v[220:223], v[180:183]
		v_mfma_f32_16x16x32_f16 v[180:183], v[200:203], v[224:227], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[204:207], v[220:223], v[184:187]
		v_mfma_f32_16x16x32_f16 v[184:187], v[228:231], v[224:227], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[232:235], v[220:223], v[188:191]
		v_mfma_f32_16x16x32_f16 v[188:191], v[236:239], v[224:227], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[240:243], v[220:223], v[192:195]
		v_mfma_f32_16x16x32_f16 v[192:195], v[244:247], v[224:227], v[192:195]
		s_barrier
		s_add_i32 s11, s17, s57
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:4096
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v6, s11, v1
		s_mov_b32 m0, s53
		s_nop 0
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		s_add_i32 s11, s19, s57
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:4096
		s_waitcnt lgkmcnt(0)
		v_add_u32_e32 v6, s11, v1
		s_mov_b32 m0, s54
		s_nop 0
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		v_and_b32_e32 v1, 63, v0
		v_and_b32_e32 v6, 15, v1
		v_and_b32_e32 v7, 1, v6
		v_lshrrev_b32_e32 v196, 1, v6
		v_and_b32_e32 v197, 1, v196
		v_lshrrev_b32_e32 v196, 2, v6
		v_and_b32_e32 v198, 1, v196
		v_lshrrev_b32_e32 v196, 4, v1
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshl_add_u32 v199, v1, 4, v6
		v_lshrrev_b32_e32 v200, 5, v199
		v_mov_b32_e32 v199, 0x1080
		v_mul_lo_u32 v199, v199, v200
		v_lshl_add_u32 v200, v196, 4, v199
		v_lshrrev_b32_e32 v196, 3, v6
		v_mov_b32_e32 v6, 0x420
		v_mul_lo_u32 v6, v6, v196
		v_and_b32_e32 v196, 1, v1
		v_mov_b32_e32 v1, 0x840
		v_mul_lo_u32 v1, v1, v196
		v_add3_u32 v196, v200, v6, v1
		v_lshl_add_u32 v1, v198, 9, v196
		v_lshl_add_u32 v6, v197, 8, v1
		v_lshl_add_u32 v1, v7, 7, v6
		ds_read_b128 v[12:15], v1
		ds_read_b128 v[16:19], v1 offset:64
		ds_read_b128 v[20:23], v1 offset:8448
		ds_read_b128 v[24:27], v1 offset:8512
		ds_read_b128 v[28:31], v1 offset:16896
		ds_read_b128 v[32:35], v1 offset:16960
		ds_read_b128 v[36:39], v1 offset:25344
		ds_read_b128 v[40:43], v1 offset:25408
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[44:45], v1 offset:1984
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[46:47], v1 offset:3040
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[48:49], v1 offset:10432
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[50:51], v1 offset:11488
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[52:53], v1 offset:2048
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[54:55], v1 offset:3104
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[56:57], v1 offset:10496
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[58:59], v1 offset:11552
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[60:61], v1 offset:2112
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[62:63], v1 offset:3168
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[64:65], v1 offset:10560
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[66:67], v1 offset:11616
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[68:69], v1 offset:2176
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[70:71], v1 offset:3232
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[72:73], v1 offset:10624
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v1 offset:22528
		s_waitcnt lgkmcnt(0)
		ds_read_b64_tr_b16 v[74:75], v1 offset:11680
		s_add_i32 s0, s0, 0x80
		s_add_i32 s11, s58, s55
		s_add_i32 s1, s1, 2
		s_cmp_lt_i32 s1, 62
		s_mov_b32 m0, s14
		s_nop 0
		ds_write_addtid_b32 v252 offset:14336
		s_mov_b32 m0, s14
		s_nop 0
		ds_write_addtid_b32 v253 offset:16384
		s_mov_b32 m0, s14
		s_nop 0
		ds_write_addtid_b32 v254 offset:18432
		s_mov_b32 m0, s14
		s_nop 0
		ds_write_addtid_b32 v255 offset:20480
		s_cbranch_scc1 .Lv9_beyond_hotloop.loop_head_0
.Lv9_beyond_hotloop.loop_exit_0:
		s_mov_b32 m0, s14
		s_waitcnt lgkmcnt(0)
		s_nop 0
		ds_read_addtid_b32 v4 offset:14336
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v5 offset:16384
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v6 offset:18432
		s_mov_b32 m0, s14
		s_nop 0
		ds_read_addtid_b32 v7 offset:20480
		v_mfma_f32_16x16x32_f16 v[8:11], v[44:47], v[12:15], v[8:11]
		v_mfma_f32_16x16x32_f16 v[8:11], v[48:51], v[16:19], v[8:11]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[4:7], v[52:55], v[12:15], v[4:7]
		v_mfma_f32_16x16x32_f16 v[4:7], v[56:59], v[16:19], v[4:7]
		v_mfma_f32_16x16x32_f16 v[76:79], v[60:63], v[12:15], v[76:79]
		v_mfma_f32_16x16x32_f16 v[76:79], v[64:67], v[16:19], v[76:79]
		v_mfma_f32_16x16x32_f16 v[80:83], v[68:71], v[12:15], v[80:83]
		v_mfma_f32_16x16x32_f16 v[80:83], v[72:75], v[16:19], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], v[44:47], v[20:23], v[84:87]
		v_mfma_f32_16x16x32_f16 v[84:87], v[48:51], v[24:27], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], v[52:55], v[20:23], v[88:91]
		v_mfma_f32_16x16x32_f16 v[88:91], v[56:59], v[24:27], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[60:63], v[20:23], v[92:95]
		v_mfma_f32_16x16x32_f16 v[92:95], v[64:67], v[24:27], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[68:71], v[20:23], v[96:99]
		v_mfma_f32_16x16x32_f16 v[96:99], v[72:75], v[24:27], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[44:47], v[28:31], v[100:103]
		v_mfma_f32_16x16x32_f16 v[100:103], v[48:51], v[32:35], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[52:55], v[28:31], v[104:107]
		v_mfma_f32_16x16x32_f16 v[104:107], v[56:59], v[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[60:63], v[28:31], v[108:111]
		v_mfma_f32_16x16x32_f16 v[108:111], v[64:67], v[32:35], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[68:71], v[28:31], v[112:115]
		v_mfma_f32_16x16x32_f16 v[112:115], v[72:75], v[32:35], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[44:47], v[36:39], v[116:119]
		v_mfma_f32_16x16x32_f16 v[116:119], v[48:51], v[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[52:55], v[36:39], v[120:123]
		v_mfma_f32_16x16x32_f16 v[120:123], v[56:59], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[60:63], v[36:39], v[124:127]
		v_mfma_f32_16x16x32_f16 v[124:127], v[64:67], v[40:43], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[68:71], v[36:39], v[128:131]
		v_mfma_f32_16x16x32_f16 v[128:131], v[72:75], v[40:43], v[128:131]
		s_waitcnt vmcnt(0)
		s_barrier
		v_and_b32_e32 v1, 63, v0
		v_and_b32_e32 v2, 15, v1
		v_and_b32_e32 v3, 3, v2
		v_lshrrev_b32_e32 v44, 2, v2
		v_lshrrev_b32_e32 v2, 4, v1
		v_lshl_add_u32 v1, v2, 3, v44
		v_lshrrev_b32_e32 v45, 4, v1
		v_mov_b32_e32 v1, 0x1080
		v_mul_lo_u32 v1, v1, v45
		v_add_u32_e32 v45, 0x10000, v1
		v_lshl_add_u32 v1, v44, 8, v45
		v_lshrrev_b32_e32 v44, 6, v0
		v_and_b32_e32 v45, 1, v44
		v_lshlrev_b32_e32 v44, 5, v45
		v_and_b32_e32 v45, 1, v2
		v_mov_b32_e32 v2, 0x840
		v_mul_lo_u32 v2, v2, v45
		v_add3_u32 v45, v1, v44, v2
		v_lshl_add_u32 v1, v3, 3, v45
		ds_read_b64_tr_b16 v[44:45], v1 offset:35712
		ds_read_b64_tr_b16 v[46:47], v1 offset:36768
		ds_read_b64_tr_b16 v[48:49], v1 offset:44160
		ds_read_b64_tr_b16 v[50:51], v1 offset:45216
		ds_read_b64_tr_b16 v[52:53], v1 offset:35776
		ds_read_b64_tr_b16 v[54:55], v1 offset:36832
		ds_read_b64_tr_b16 v[56:57], v1 offset:44224
		ds_read_b64_tr_b16 v[58:59], v1 offset:45280
		ds_read_b64_tr_b16 v[60:61], v1 offset:35840
		ds_read_b64_tr_b16 v[62:63], v1 offset:36896
		ds_read_b64_tr_b16 v[64:65], v1 offset:44288
		ds_read_b64_tr_b16 v[66:67], v1 offset:45344
		ds_read_b64_tr_b16 v[68:69], v1 offset:35904
		ds_read_b64_tr_b16 v[70:71], v1 offset:36960
		ds_read_b64_tr_b16 v[72:73], v1 offset:44352
		ds_read_b64_tr_b16 v[74:75], v1 offset:45408
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[132:135], v[44:47], v[12:15], v[132:135]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[132:135], v[48:51], v[16:19], v[132:135]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[136:139], v[52:55], v[12:15], v[136:139]
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[136:139], v[56:59], v[16:19], v[136:139]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[140:143], v[60:63], v[12:15], v[140:143]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[140:143], v[64:67], v[16:19], v[140:143]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[144:147], v[68:71], v[12:15], v[144:147]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[144:147], v[72:75], v[16:19], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[44:47], v[20:23], v[148:151]
		v_mfma_f32_16x16x32_f16 v[148:151], v[48:51], v[24:27], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[52:55], v[20:23], v[152:155]
		v_mfma_f32_16x16x32_f16 v[152:155], v[56:59], v[24:27], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[60:63], v[20:23], v[156:159]
		v_mfma_f32_16x16x32_f16 v[156:159], v[64:67], v[24:27], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[68:71], v[20:23], v[160:163]
		v_mfma_f32_16x16x32_f16 v[160:163], v[72:75], v[24:27], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[44:47], v[28:31], v[164:167]
		v_mfma_f32_16x16x32_f16 v[164:167], v[48:51], v[32:35], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[52:55], v[28:31], v[168:171]
		v_mfma_f32_16x16x32_f16 v[168:171], v[56:59], v[32:35], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[60:63], v[28:31], v[172:175]
		v_mfma_f32_16x16x32_f16 v[172:175], v[64:67], v[32:35], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[68:71], v[28:31], v[176:179]
		v_mfma_f32_16x16x32_f16 v[176:179], v[72:75], v[32:35], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[44:47], v[36:39], v[180:183]
		v_mfma_f32_16x16x32_f16 v[180:183], v[48:51], v[40:43], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[52:55], v[36:39], v[184:187]
		v_mfma_f32_16x16x32_f16 v[184:187], v[56:59], v[40:43], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[60:63], v[36:39], v[188:191]
		v_mfma_f32_16x16x32_f16 v[188:191], v[64:67], v[40:43], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[68:71], v[36:39], v[192:195]
		v_mfma_f32_16x16x32_f16 v[192:195], v[72:75], v[40:43], v[192:195]
		v_and_b32_e32 v2, 63, v0
		v_and_b32_e32 v3, 15, v2
		v_and_b32_e32 v12, 1, v3
		v_lshrrev_b32_e32 v13, 1, v3
		v_and_b32_e32 v14, 1, v13
		v_lshrrev_b32_e32 v13, 2, v3
		v_and_b32_e32 v15, 1, v13
		v_lshrrev_b32_e32 v13, 4, v2
		v_lshrrev_b32_e32 v2, 7, v0
		v_lshl_add_u32 v16, v2, 4, v3
		v_lshrrev_b32_e32 v17, 5, v16
		v_mov_b32_e32 v16, 0x1080
		v_mul_lo_u32 v16, v16, v17
		v_lshl_add_u32 v17, v13, 4, v16
		v_lshrrev_b32_e32 v13, 3, v3
		v_mov_b32_e32 v3, 0x420
		v_mul_lo_u32 v3, v3, v13
		v_and_b32_e32 v13, 1, v2
		v_mov_b32_e32 v2, 0x840
		v_mul_lo_u32 v2, v2, v13
		v_add3_u32 v13, v17, v3, v2
		v_lshl_add_u32 v2, v15, 9, v13
		v_lshl_add_u32 v3, v14, 8, v2
		v_lshl_add_u32 v2, v12, 7, v3
		ds_read_b128 v[12:15], v2 offset:33760
		ds_read_b128 v[16:19], v2 offset:33824
		ds_read_b128 v[20:23], v2 offset:42208
		ds_read_b128 v[24:27], v2 offset:42272
		ds_read_b128 v[28:31], v2 offset:50656
		ds_read_b128 v[32:35], v2 offset:50720
		ds_read_b128 v[36:39], v2 offset:59104
		ds_read_b128 v[40:43], v2 offset:59168
		ds_read_b64_tr_b16 v[44:45], v1 offset:18848
		ds_read_b64_tr_b16 v[46:47], v1 offset:19904
		ds_read_b64_tr_b16 v[48:49], v1 offset:27296
		ds_read_b64_tr_b16 v[50:51], v1 offset:28352
		ds_read_b64_tr_b16 v[52:53], v1 offset:18912
		ds_read_b64_tr_b16 v[54:55], v1 offset:19968
		ds_read_b64_tr_b16 v[56:57], v1 offset:27360
		ds_read_b64_tr_b16 v[58:59], v1 offset:28416
		ds_read_b64_tr_b16 v[60:61], v1 offset:18976
		ds_read_b64_tr_b16 v[62:63], v1 offset:20032
		ds_read_b64_tr_b16 v[64:65], v1 offset:27424
		ds_read_b64_tr_b16 v[66:67], v1 offset:28480
		ds_read_b64_tr_b16 v[68:69], v1 offset:19040
		ds_read_b64_tr_b16 v[70:71], v1 offset:20096
		ds_read_b64_tr_b16 v[72:73], v1 offset:27488
		ds_read_b64_tr_b16 v[74:75], v1 offset:28544
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[8:11], v[44:47], v[12:15], v[8:11]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[8:11], v[48:51], v[16:19], v[8:11]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[4:7], v[52:55], v[12:15], v[4:7]
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[4:7], v[56:59], v[16:19], v[4:7]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[76:79], v[60:63], v[12:15], v[76:79]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[76:79], v[64:67], v[16:19], v[76:79]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[80:83], v[68:71], v[12:15], v[80:83]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[80:83], v[72:75], v[16:19], v[80:83]
		v_mfma_f32_16x16x32_f16 v[84:87], v[44:47], v[20:23], v[84:87]
		v_mfma_f32_16x16x32_f16 v[84:87], v[48:51], v[24:27], v[84:87]
		v_mfma_f32_16x16x32_f16 v[88:91], v[52:55], v[20:23], v[88:91]
		v_mfma_f32_16x16x32_f16 v[88:91], v[56:59], v[24:27], v[88:91]
		v_mfma_f32_16x16x32_f16 v[92:95], v[60:63], v[20:23], v[92:95]
		v_mfma_f32_16x16x32_f16 v[92:95], v[64:67], v[24:27], v[92:95]
		v_mfma_f32_16x16x32_f16 v[96:99], v[68:71], v[20:23], v[96:99]
		v_mfma_f32_16x16x32_f16 v[96:99], v[72:75], v[24:27], v[96:99]
		v_mfma_f32_16x16x32_f16 v[100:103], v[44:47], v[28:31], v[100:103]
		v_mfma_f32_16x16x32_f16 v[100:103], v[48:51], v[32:35], v[100:103]
		v_mfma_f32_16x16x32_f16 v[104:107], v[52:55], v[28:31], v[104:107]
		v_mfma_f32_16x16x32_f16 v[104:107], v[56:59], v[32:35], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[60:63], v[28:31], v[108:111]
		v_mfma_f32_16x16x32_f16 v[108:111], v[64:67], v[32:35], v[108:111]
		v_mfma_f32_16x16x32_f16 v[112:115], v[68:71], v[28:31], v[112:115]
		v_mfma_f32_16x16x32_f16 v[112:115], v[72:75], v[32:35], v[112:115]
		v_mfma_f32_16x16x32_f16 v[116:119], v[44:47], v[36:39], v[116:119]
		v_mfma_f32_16x16x32_f16 v[116:119], v[48:51], v[40:43], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[52:55], v[36:39], v[120:123]
		v_mfma_f32_16x16x32_f16 v[120:123], v[56:59], v[40:43], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[60:63], v[36:39], v[124:127]
		v_mfma_f32_16x16x32_f16 v[124:127], v[64:67], v[40:43], v[124:127]
		v_mfma_f32_16x16x32_f16 v[128:131], v[68:71], v[36:39], v[128:131]
		v_mfma_f32_16x16x32_f16 v[128:131], v[72:75], v[40:43], v[128:131]
		ds_read_b64_tr_b16 v[44:45], v1 offset:52576
		ds_read_b64_tr_b16 v[46:47], v1 offset:53632
		ds_read_b64_tr_b16 v[48:49], v1 offset:61024
		ds_read_b64_tr_b16 v[50:51], v1 offset:62080
		ds_read_b64_tr_b16 v[52:53], v1 offset:52640
		ds_read_b64_tr_b16 v[54:55], v1 offset:53696
		ds_read_b64_tr_b16 v[56:57], v1 offset:61088
		ds_read_b64_tr_b16 v[58:59], v1 offset:62144
		ds_read_b64_tr_b16 v[60:61], v1 offset:52704
		ds_read_b64_tr_b16 v[62:63], v1 offset:53760
		ds_read_b64_tr_b16 v[64:65], v1 offset:61152
		ds_read_b64_tr_b16 v[66:67], v1 offset:62208
		ds_read_b64_tr_b16 v[68:69], v1 offset:52768
		ds_read_b64_tr_b16 v[70:71], v1 offset:53824
		ds_read_b64_tr_b16 v[72:73], v1 offset:61216
		ds_read_b64_tr_b16 v[74:75], v1 offset:62272
		v_cvt_pk_f16_f32 v2, v8, v9
		v_cvt_pk_f16_f32 v3, v10, v11
		v_cvt_pk_f16_f32 v8, v4, v5
		v_cvt_pk_f16_f32 v9, v6, v7
		v_cvt_pk_f16_f32 v4, v76, v77
		v_cvt_pk_f16_f32 v5, v78, v79
		v_cvt_pk_f16_f32 v6, v80, v81
		v_cvt_pk_f16_f32 v7, v82, v83
		v_cvt_pk_f16_f32 v10, v84, v85
		v_cvt_pk_f16_f32 v11, v86, v87
		v_cvt_pk_f16_f32 v76, v88, v89
		v_cvt_pk_f16_f32 v77, v90, v91
		v_cvt_pk_f16_f32 v78, v92, v93
		v_cvt_pk_f16_f32 v79, v94, v95
		v_cvt_pk_f16_f32 v80, v96, v97
		v_cvt_pk_f16_f32 v81, v98, v99
		v_cvt_pk_f16_f32 v82, v100, v101
		v_cvt_pk_f16_f32 v83, v102, v103
		v_cvt_pk_f16_f32 v84, v104, v105
		v_cvt_pk_f16_f32 v85, v106, v107
		v_cvt_pk_f16_f32 v86, v108, v109
		v_cvt_pk_f16_f32 v87, v110, v111
		v_cvt_pk_f16_f32 v88, v112, v113
		v_cvt_pk_f16_f32 v89, v114, v115
		v_cvt_pk_f16_f32 v90, v116, v117
		v_cvt_pk_f16_f32 v91, v118, v119
		v_cvt_pk_f16_f32 v92, v120, v121
		v_cvt_pk_f16_f32 v93, v122, v123
		v_cvt_pk_f16_f32 v94, v124, v125
		v_cvt_pk_f16_f32 v95, v126, v127
		v_cvt_pk_f16_f32 v96, v128, v129
		v_cvt_pk_f16_f32 v97, v130, v131
		s_cmp_lt_i32 s30, 0
		s_cselect_b32 s31, -1, 0
		v_mov_b32_e32 v98, s30
		v_mov_b32_e32 v99, s31
		s_mov_b32 s2, 0x400
		s_mov_b32 s3, 0
		v_mov_b32_e32 v100, s2
		v_mov_b32_e32 v101, s3
		v_mul_lo_u32 v102, v100, v98
		v_mul_hi_u32 v103, v100, v98
		v_mul_lo_u32 v1, v100, v99
		v_add_u32_e32 v103, v103, v1
		v_mul_lo_u32 v1, v101, v98
		v_add_u32_e32 v103, v103, v1
		s_cmp_lt_i32 s28, 0
		s_cselect_b32 s29, -1, 0
		v_mov_b32_e32 v98, s28
		v_mov_b32_e32 v99, s29
		s_mov_b32 s2, 0x100
		s_mov_b32 s3, 0
		v_mov_b32_e32 v100, s2
		v_mov_b32_e32 v101, s3
		v_mul_lo_u32 v104, v100, v98
		v_mul_hi_u32 v105, v100, v98
		v_mul_lo_u32 v1, v100, v99
		v_add_u32_e32 v105, v105, v1
		v_mul_lo_u32 v1, v101, v98
		v_add_u32_e32 v105, v105, v1
		v_add_co_u32_e64 v98, vcc, v102, v104
		v_addc_co_u32_e64 v99, vcc, v103, v105, vcc
		s_mov_b32 s2, 1
		s_mov_b32 s3, 0
		v_mov_b32_e32 v106, v0
		v_mov_b32_e32 v107, 0
		v_mov_b32_e32 v108, s2
		v_mov_b32_e32 v109, s3
		v_mul_lo_u32 v110, v108, v106
		v_mul_hi_u32 v111, v108, v106
		v_mul_lo_u32 v1, v108, v107
		v_add_u32_e32 v111, v111, v1
		v_mul_lo_u32 v1, v109, v106
		v_add_u32_e32 v111, v111, v1
		v_lshrrev_b64 v[108:109], 7, v[110:111]
		s_mov_b32 s2, 16
		s_mov_b32 s3, 0
		v_mov_b32_e32 v112, s2
		v_mov_b32_e32 v113, s3
		v_mul_lo_u32 v114, v112, v108
		v_mul_hi_u32 v115, v112, v108
		v_mul_lo_u32 v1, v112, v109
		v_add_u32_e32 v115, v115, v1
		v_mul_lo_u32 v1, v113, v108
		v_add_u32_e32 v115, v115, v1
		v_add_co_u32_e64 v108, vcc, v98, v114
		v_addc_co_u32_e64 v109, vcc, v99, v115, vcc
		v_mov_b32_e32 v1, 1
		v_and_b32_e32 v98, v106, v1
		v_mov_b32_e32 v106, 0
		v_and_b32_e32 v99, v106, v106
		v_add_co_u32_e64 v112, vcc, v108, v98
		v_addc_co_u32_e64 v113, vcc, v109, v99, vcc
		v_lshrrev_b64 v[108:109], 3, v[110:111]
		v_and_b32_e32 v116, v108, v1
		v_and_b32_e32 v117, v109, v106
		s_mov_b32 s2, 8
		s_mov_b32 s3, 0
		v_mov_b32_e32 v108, s2
		v_mov_b32_e32 v109, s3
		v_mul_lo_u32 v118, v108, v116
		v_mul_hi_u32 v119, v108, v116
		v_mul_lo_u32 v107, v108, v117
		v_add_u32_e32 v119, v119, v107
		v_mul_lo_u32 v107, v109, v116
		v_add_u32_e32 v119, v119, v107
		v_add_co_u32_e64 v108, vcc, v112, v118
		v_addc_co_u32_e64 v109, vcc, v113, v119, vcc
		v_lshrrev_b64 v[112:113], 2, v[110:111]
		v_and_b32_e32 v116, v112, v1
		v_and_b32_e32 v117, v113, v106
		s_mov_b32 s2, 4
		s_mov_b32 s3, 0
		v_mov_b32_e32 v112, s2
		v_mov_b32_e32 v113, s3
		v_mul_lo_u32 v120, v112, v116
		v_mul_hi_u32 v121, v112, v116
		v_mul_lo_u32 v107, v112, v117
		v_add_u32_e32 v121, v121, v107
		v_mul_lo_u32 v107, v113, v116
		v_add_u32_e32 v121, v121, v107
		v_add_co_u32_e64 v116, vcc, v108, v120
		v_addc_co_u32_e64 v117, vcc, v109, v121, vcc
		v_lshrrev_b64 v[108:109], 1, v[110:111]
		v_and_b32_e32 v122, v108, v1
		v_and_b32_e32 v123, v109, v106
		s_mov_b32 s2, 2
		s_mov_b32 s3, 0
		v_mov_b32_e32 v108, s2
		v_mov_b32_e32 v109, s3
		v_mul_lo_u32 v124, v108, v122
		v_mul_hi_u32 v125, v108, v122
		v_mul_lo_u32 v1, v108, v123
		v_add_u32_e32 v125, v125, v1
		v_mul_lo_u32 v1, v109, v122
		v_add_u32_e32 v125, v125, v1
		v_add_co_u32_e64 v108, vcc, v116, v124
		v_addc_co_u32_e64 v109, vcc, v117, v125, vcc
		v_cmp_lt_i32_e64 vcc, v109, s1
		s_mov_b64 s[2:3], vcc
		v_cmp_eq_u32_e64 vcc, v109, s1
		s_mov_b64 s[4:5], vcc
		v_cmp_lt_u32_e64 vcc, v108, s8
		s_mov_b64 s[10:11], vcc
		s_and_b32 s14, s4, s10
		s_and_b32 s15, s5, s11
		s_or_b32 s4, s2, s14
		s_or_b32 s5, s3, s15
		v_mov_b32_e32 v1, 64
		v_add_co_u32_e64 v108, vcc, v102, v1
		v_addc_co_u32_e64 v109, vcc, v103, 0, vcc
		v_add_co_u32_e64 v116, vcc, v108, v104
		v_addc_co_u32_e64 v117, vcc, v109, v105, vcc
		v_add_co_u32_e64 v108, vcc, v116, v114
		v_addc_co_u32_e64 v109, vcc, v117, v115, vcc
		v_add_co_u32_e64 v116, vcc, v108, v98
		v_addc_co_u32_e64 v117, vcc, v109, v99, vcc
		v_add_co_u32_e64 v108, vcc, v116, v118
		v_addc_co_u32_e64 v109, vcc, v117, v119, vcc
		v_add_co_u32_e64 v116, vcc, v108, v120
		v_addc_co_u32_e64 v117, vcc, v109, v121, vcc
		v_add_co_u32_e64 v108, vcc, v116, v124
		v_addc_co_u32_e64 v109, vcc, v117, v125, vcc
		v_cmp_lt_i32_e64 vcc, v109, s1
		s_mov_b64 s[2:3], vcc
		v_cmp_eq_u32_e64 vcc, v109, s1
		s_mov_b64 s[10:11], vcc
		v_cmp_lt_u32_e64 vcc, v108, s8
		s_mov_b64 s[14:15], vcc
		s_and_b32 s16, s10, s14
		s_and_b32 s17, s11, s15
		s_or_b32 s10, s2, s16
		s_or_b32 s11, s3, s17
		v_mov_b32_e32 v107, 0x80
		v_add_co_u32_e64 v108, vcc, v102, v107
		v_addc_co_u32_e64 v109, vcc, v103, 0, vcc
		v_add_co_u32_e64 v116, vcc, v108, v104
		v_addc_co_u32_e64 v117, vcc, v109, v105, vcc
		v_add_co_u32_e64 v108, vcc, v116, v114
		v_addc_co_u32_e64 v109, vcc, v117, v115, vcc
		v_add_co_u32_e64 v116, vcc, v108, v98
		v_addc_co_u32_e64 v117, vcc, v109, v99, vcc
		v_add_co_u32_e64 v108, vcc, v116, v118
		v_addc_co_u32_e64 v109, vcc, v117, v119, vcc
		v_add_co_u32_e64 v116, vcc, v108, v120
		v_addc_co_u32_e64 v117, vcc, v109, v121, vcc
		v_add_co_u32_e64 v108, vcc, v116, v124
		v_addc_co_u32_e64 v109, vcc, v117, v125, vcc
		v_cmp_lt_i32_e64 vcc, v109, s1
		s_mov_b64 s[2:3], vcc
		v_cmp_eq_u32_e64 vcc, v109, s1
		s_mov_b64 s[14:15], vcc
		v_cmp_lt_u32_e64 vcc, v108, s8
		s_mov_b64 s[16:17], vcc
		s_and_b32 s18, s14, s16
		s_and_b32 s19, s15, s17
		s_or_b32 s14, s2, s18
		s_or_b32 s15, s3, s19
		v_mov_b32_e32 v108, 0xc0
		v_add_co_u32_e64 v116, vcc, v102, v108
		v_addc_co_u32_e64 v117, vcc, v103, 0, vcc
		v_add_co_u32_e64 v102, vcc, v116, v104
		v_addc_co_u32_e64 v103, vcc, v117, v105, vcc
		v_add_co_u32_e64 v104, vcc, v102, v114
		v_addc_co_u32_e64 v105, vcc, v103, v115, vcc
		v_add_co_u32_e64 v102, vcc, v104, v98
		v_addc_co_u32_e64 v103, vcc, v105, v99, vcc
		v_add_co_u32_e64 v98, vcc, v102, v118
		v_addc_co_u32_e64 v99, vcc, v103, v119, vcc
		v_add_co_u32_e64 v102, vcc, v98, v120
		v_addc_co_u32_e64 v103, vcc, v99, v121, vcc
		v_add_co_u32_e64 v98, vcc, v102, v124
		v_addc_co_u32_e64 v99, vcc, v103, v125, vcc
		v_cmp_lt_i32_e64 vcc, v99, s1
		s_mov_b64 s[2:3], vcc
		v_cmp_eq_u32_e64 vcc, v99, s1
		s_mov_b64 s[16:17], vcc
		v_cmp_lt_u32_e64 vcc, v98, s8
		s_mov_b64 s[18:19], vcc
		s_and_b32 s20, s16, s18
		s_and_b32 s21, s17, s19
		s_or_b32 s16, s2, s20
		s_or_b32 s17, s3, s21
		s_cmp_lt_i32 s32, 0
		s_cselect_b32 s33, -1, 0
		v_mov_b32_e32 v98, s32
		v_mov_b32_e32 v99, s33
		v_mul_lo_u32 v102, v100, v98
		v_mul_hi_u32 v103, v100, v98
		v_mul_lo_u32 v104, v100, v99
		v_add_u32_e32 v103, v103, v104
		v_mul_lo_u32 v104, v101, v98
		v_add_u32_e32 v103, v103, v104
		v_lshrrev_b64 v[98:99], 4, v[110:111]
		v_mov_b32_e32 v100, 7
		v_and_b32_e32 v104, v98, v100
		v_and_b32_e32 v105, v99, v106
		v_mul_lo_u32 v98, v112, v104
		v_mul_hi_u32 v99, v112, v104
		v_mul_lo_u32 v100, v112, v105
		v_add_u32_e32 v99, v99, v100
		v_mul_lo_u32 v100, v113, v104
		v_add_u32_e32 v99, v99, v100
		v_add_co_u32_e64 v100, vcc, v102, v98
		v_addc_co_u32_e64 v101, vcc, v103, v99, vcc
		v_cmp_lt_i32_e64 vcc, v101, s1
		s_mov_b64 s[2:3], vcc
		v_cmp_eq_u32_e64 vcc, v101, s1
		s_mov_b64 s[18:19], vcc
		v_cmp_lt_u32_e64 vcc, v100, s9
		s_mov_b64 s[20:21], vcc
		s_and_b32 s22, s18, s20
		s_and_b32 s23, s19, s21
		s_or_b32 s18, s2, s22
		s_or_b32 s19, s3, s23
		v_mov_b32_e32 v100, 32
		v_add_co_u32_e64 v104, vcc, v102, v100
		v_addc_co_u32_e64 v105, vcc, v103, 0, vcc
		v_add_co_u32_e64 v100, vcc, v104, v98
		v_addc_co_u32_e64 v101, vcc, v105, v99, vcc
		v_cmp_lt_i32_e64 vcc, v101, s1
		s_mov_b64 s[2:3], vcc
		v_cmp_eq_u32_e64 vcc, v101, s1
		s_mov_b64 s[20:21], vcc
		v_cmp_lt_u32_e64 vcc, v100, s9
		s_mov_b64 s[22:23], vcc
		s_and_b32 s24, s20, s22
		s_and_b32 s25, s21, s23
		s_or_b32 s20, s2, s24
		s_or_b32 s21, s3, s25
		v_add_co_u32_e64 v100, vcc, v102, v1
		v_addc_co_u32_e64 v101, vcc, v103, 0, vcc
		v_add_co_u32_e64 v104, vcc, v100, v98
		v_addc_co_u32_e64 v105, vcc, v101, v99, vcc
		v_cmp_lt_i32_e64 vcc, v105, s1
		s_mov_b64 s[2:3], vcc
		v_cmp_eq_u32_e64 vcc, v105, s1
		s_mov_b64 s[22:23], vcc
		v_cmp_lt_u32_e64 vcc, v104, s9
		s_mov_b64 s[24:25], vcc
		s_and_b32 s26, s22, s24
		s_and_b32 s27, s23, s25
		s_or_b32 s22, s2, s26
		s_or_b32 s23, s3, s27
		v_mov_b32_e32 v1, 0x60
		v_add_co_u32_e64 v100, vcc, v102, v1
		v_addc_co_u32_e64 v101, vcc, v103, 0, vcc
		v_add_co_u32_e64 v104, vcc, v100, v98
		v_addc_co_u32_e64 v105, vcc, v101, v99, vcc
		v_cmp_lt_i32_e64 vcc, v105, s1
		s_mov_b64 s[2:3], vcc
		v_cmp_eq_u32_e64 vcc, v105, s1
		s_mov_b64 s[24:25], vcc
		v_cmp_lt_u32_e64 vcc, v104, s9
		s_mov_b64 s[26:27], vcc
		s_and_b32 s32, s24, s26
		s_and_b32 s33, s25, s27
		s_or_b32 s24, s2, s32
		s_or_b32 s25, s3, s33
		s_mov_b32 s32, s6
		s_mov_b32 s33, s7
		s_mov_b32 s34, 0x7fffffff
		s_mov_b32 s35, 0x31016000
		s_and_b32 s2, s4, s18
		s_and_b32 s3, s5, s19
		s_mul_i32 s0, s30, s12
		s_lshl_b32 s6, s0, 11
		s_add_i32 s0, s38, s6
		s_mul_i32 s7, s28, s12
		s_lshl_b32 s8, s7, 9
		s_add_i32 s7, s0, s8
		v_lshrrev_b32_e32 v1, 8, v0
		v_mul_lo_u32 v100, s12, v1
		v_lshlrev_b32_e32 v101, 6, v100
		v_add_u32_e32 v100, s7, v101
		v_and_b32_e32 v104, 1, v0
		v_mul_lo_u32 v105, s12, v104
		v_lshlrev_b32_e32 v106, 1, v105
		v_lshrrev_b32_e32 v105, 7, v0
		v_and_b32_e32 v109, 1, v105
		v_mul_lo_u32 v105, s12, v109
		v_lshlrev_b32_e32 v110, 5, v105
		v_add3_u32 v105, v100, v106, v110
		v_lshrrev_b32_e32 v100, 3, v0
		v_and_b32_e32 v111, 1, v100
		v_mul_lo_u32 v100, s12, v111
		v_lshlrev_b32_e32 v112, 4, v100
		v_lshrrev_b32_e32 v100, 2, v0
		v_and_b32_e32 v113, 1, v100
		v_mul_lo_u32 v100, s12, v113
		v_lshlrev_b32_e32 v114, 3, v100
		v_add3_u32 v100, v105, v112, v114
		v_lshrrev_b32_e32 v105, 1, v0
		v_and_b32_e32 v115, 1, v105
		v_mul_lo_u32 v105, s12, v115
		v_lshlrev_b32_e32 v116, 2, v105
		v_lshrrev_b32_e32 v105, 6, v0
		v_and_b32_e32 v117, 1, v105
		v_lshlrev_b32_e32 v105, 5, v117
		v_add3_u32 v117, v100, v116, v105
		v_lshrrev_b32_e32 v100, 5, v0
		v_and_b32_e32 v118, 1, v100
		v_lshlrev_b32_e32 v100, 4, v118
		v_lshrrev_b32_e32 v119, 4, v0
		v_and_b32_e32 v120, 1, v119
		v_lshlrev_b32_e32 v119, 3, v120
		v_add3_u32 v121, v117, v100, v119
		v_mov_b32_e32 v117, 0x80000000
		v_cndmask_b32_e64 v122, v117, v121, s[2:3]
		buffer_store_dwordx2 v[2:3], v122, s[32:35], 0 offen
		s_and_b32 s2, s4, s20
		s_and_b32 s3, s5, s21
		v_lshrrev_b32_e32 v2, 7, v0
		v_mul_lo_u32 v3, s12, v2
		v_lshlrev_b32_e32 v2, 5, v3
		v_add_u32_e32 v3, s7, v2
		v_add3_u32 v121, v3, v106, v112
		v_add3_u32 v3, v121, v114, v116
		v_lshrrev_b32_e32 v121, 6, v0
		v_and_b32_e32 v0, 1, v121
		v_lshlrev_b32_e32 v121, 4, v0
		v_lshlrev_b32_e32 v0, 2, v120
		v_add_u32_e32 v120, 32, v0
		v_lshlrev_b32_e32 v122, 3, v118
		v_xor_b32_e32 v118, v120, v122
		v_xor_b32_e32 v120, v121, v118
		v_lshlrev_b32_e32 v118, 1, v120
		v_add_u32_e32 v120, v3, v118
		v_cndmask_b32_e64 v123, v117, v120, s[2:3]
		buffer_store_dwordx2 v[8:9], v123, s[32:35], 0 offen
		s_and_b32 s2, s4, s22
		s_and_b32 s3, s5, s23
		v_add_u32_e32 v8, 64, v0
		v_xor_b32_e32 v9, v8, v122
		v_xor_b32_e32 v8, v121, v9
		v_lshlrev_b32_e32 v9, 1, v8
		v_add_u32_e32 v8, v3, v9
		v_cndmask_b32_e64 v3, v117, v8, s[2:3]
		buffer_store_dwordx2 v[4:5], v3, s[32:35], 0 offen
		s_and_b32 s2, s4, s24
		s_and_b32 s3, s5, s25
		s_mul_i32 s0, s12, s30
		s_lshl_b32 s13, s0, 11
		s_add_i32 s0, s38, s13
		s_mul_i32 s26, s12, s28
		s_lshl_b32 s27, s26, 9
		s_add_i32 s26, s0, s27
		v_add3_u32 v3, s26, v2, v106
		v_add3_u32 v4, v3, v112, v114
		v_add_u32_e32 v3, 0x60, v0
		v_xor_b32_e32 v0, v3, v122
		v_xor_b32_e32 v3, v121, v0
		v_lshlrev_b32_e32 v0, 1, v3
		v_add3_u32 v3, v4, v116, v0
		v_cndmask_b32_e64 v4, v117, v3, s[2:3]
		buffer_store_dwordx2 v[6:7], v4, s[32:35], 0 offen
		s_and_b32 s2, s10, s18
		s_and_b32 s3, s11, s19
		v_lshlrev_b32_e32 v3, 5, v1
		v_lshlrev_b32_e32 v1, 4, v109
		v_lshlrev_b32_e32 v4, 3, v111
		v_lshlrev_b32_e32 v5, 2, v113
		v_add_u32_e32 v6, 64, v104
		v_lshlrev_b32_e32 v7, 1, v115
		v_xor_b32_e32 v8, v6, v7
		v_xor_b32_e32 v6, v5, v8
		v_xor_b32_e32 v8, v4, v6
		v_xor_b32_e32 v6, v1, v8
		v_xor_b32_e32 v8, v3, v6
		v_mul_lo_u32 v6, s12, v8
		v_lshlrev_b32_e32 v8, 1, v6
		v_add_u32_e32 v6, s7, v8
		v_add_u32_e32 v109, v6, v105
		v_add3_u32 v111, v109, v100, v119
		v_cndmask_b32_e64 v109, v117, v111, s[2:3]
		buffer_store_dwordx2 v[10:11], v109, s[32:35], 0 offen
		s_and_b32 s2, s10, s20
		s_and_b32 s3, s11, s21
		v_add_u32_e32 v10, v6, v118
		v_cndmask_b32_e64 v11, v117, v10, s[2:3]
		buffer_store_dwordx2 v[76:77], v11, s[32:35], 0 offen
		s_and_b32 s2, s10, s22
		s_and_b32 s3, s11, s23
		v_add_u32_e32 v10, v6, v9
		v_cndmask_b32_e64 v6, v117, v10, s[2:3]
		buffer_store_dwordx2 v[78:79], v6, s[32:35], 0 offen
		s_and_b32 s2, s10, s24
		s_and_b32 s3, s11, s25
		v_add3_u32 v6, s26, v8, v0
		v_cndmask_b32_e64 v10, v117, v6, s[2:3]
		buffer_store_dwordx2 v[80:81], v10, s[32:35], 0 offen
		s_and_b32 s2, s14, s18
		s_and_b32 s3, s15, s19
		v_add_u32_e32 v6, 0x80, v104
		v_xor_b32_e32 v10, v6, v7
		v_xor_b32_e32 v6, v5, v10
		v_xor_b32_e32 v10, v4, v6
		v_xor_b32_e32 v6, v1, v10
		v_xor_b32_e32 v10, v3, v6
		v_mul_lo_u32 v6, s12, v10
		v_lshlrev_b32_e32 v10, 1, v6
		v_add_u32_e32 v6, s7, v10
		v_add_u32_e32 v11, v6, v105
		v_add3_u32 v76, v11, v100, v119
		v_cndmask_b32_e64 v11, v117, v76, s[2:3]
		buffer_store_dwordx2 v[82:83], v11, s[32:35], 0 offen
		s_and_b32 s2, s14, s20
		s_and_b32 s3, s15, s21
		v_add_u32_e32 v11, v6, v118
		v_cndmask_b32_e64 v76, v117, v11, s[2:3]
		buffer_store_dwordx2 v[84:85], v76, s[32:35], 0 offen
		s_and_b32 s2, s14, s22
		s_and_b32 s3, s15, s23
		v_add_u32_e32 v11, v6, v9
		v_cndmask_b32_e64 v6, v117, v11, s[2:3]
		buffer_store_dwordx2 v[86:87], v6, s[32:35], 0 offen
		s_and_b32 s2, s14, s24
		s_and_b32 s3, s15, s25
		v_add3_u32 v6, s26, v10, v0
		v_cndmask_b32_e64 v11, v117, v6, s[2:3]
		buffer_store_dwordx2 v[88:89], v11, s[32:35], 0 offen
		s_and_b32 s2, s16, s18
		s_and_b32 s3, s17, s19
		v_add_u32_e32 v6, 0xc0, v104
		v_xor_b32_e32 v11, v6, v7
		v_xor_b32_e32 v6, v5, v11
		v_xor_b32_e32 v5, v4, v6
		v_xor_b32_e32 v4, v1, v5
		v_xor_b32_e32 v1, v3, v4
		v_mul_lo_u32 v3, s12, v1
		v_lshlrev_b32_e32 v1, 1, v3
		v_add_u32_e32 v3, s26, v1
		v_add_u32_e32 v4, v3, v105
		v_add3_u32 v5, v4, v100, v119
		v_cndmask_b32_e64 v4, v117, v5, s[2:3]
		buffer_store_dwordx2 v[90:91], v4, s[32:35], 0 offen
		s_and_b32 s2, s16, s20
		s_and_b32 s3, s17, s21
		v_add_u32_e32 v4, v3, v118
		v_cndmask_b32_e64 v5, v117, v4, s[2:3]
		buffer_store_dwordx2 v[92:93], v5, s[32:35], 0 offen
		s_and_b32 s2, s16, s22
		s_and_b32 s3, s17, s23
		v_add_u32_e32 v4, v3, v9
		v_cndmask_b32_e64 v5, v117, v4, s[2:3]
		buffer_store_dwordx2 v[94:95], v5, s[32:35], 0 offen
		s_and_b32 s2, s16, s24
		s_and_b32 s3, s17, s25
		v_add_u32_e32 v4, v3, v0
		v_cndmask_b32_e64 v3, v117, v4, s[2:3]
		buffer_store_dwordx2 v[96:97], v3, s[32:35], 0 offen
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[132:135], v[44:47], v[12:15], v[132:135]
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_16x16x32_f16 v[132:135], v[48:51], v[16:19], v[132:135]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[136:139], v[52:55], v[12:15], v[136:139]
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_16x16x32_f16 v[136:139], v[56:59], v[16:19], v[136:139]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[140:143], v[60:63], v[12:15], v[140:143]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_16x16x32_f16 v[140:143], v[64:67], v[16:19], v[140:143]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[144:147], v[68:71], v[12:15], v[144:147]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[144:147], v[72:75], v[16:19], v[144:147]
		v_mfma_f32_16x16x32_f16 v[148:151], v[44:47], v[20:23], v[148:151]
		v_mfma_f32_16x16x32_f16 v[148:151], v[48:51], v[24:27], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[52:55], v[20:23], v[152:155]
		v_mfma_f32_16x16x32_f16 v[152:155], v[56:59], v[24:27], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[60:63], v[20:23], v[156:159]
		v_mfma_f32_16x16x32_f16 v[156:159], v[64:67], v[24:27], v[156:159]
		v_mfma_f32_16x16x32_f16 v[160:163], v[68:71], v[20:23], v[160:163]
		v_mfma_f32_16x16x32_f16 v[160:163], v[72:75], v[24:27], v[160:163]
		v_mfma_f32_16x16x32_f16 v[164:167], v[44:47], v[28:31], v[164:167]
		v_mfma_f32_16x16x32_f16 v[164:167], v[48:51], v[32:35], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[52:55], v[28:31], v[168:171]
		v_mfma_f32_16x16x32_f16 v[168:171], v[56:59], v[32:35], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[60:63], v[28:31], v[172:175]
		v_mfma_f32_16x16x32_f16 v[172:175], v[64:67], v[32:35], v[172:175]
		v_mfma_f32_16x16x32_f16 v[176:179], v[68:71], v[28:31], v[176:179]
		v_mfma_f32_16x16x32_f16 v[176:179], v[72:75], v[32:35], v[176:179]
		v_mfma_f32_16x16x32_f16 v[180:183], v[44:47], v[36:39], v[180:183]
		v_mfma_f32_16x16x32_f16 v[180:183], v[48:51], v[40:43], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[52:55], v[36:39], v[184:187]
		v_mfma_f32_16x16x32_f16 v[184:187], v[56:59], v[40:43], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[60:63], v[36:39], v[188:191]
		v_mfma_f32_16x16x32_f16 v[188:191], v[64:67], v[40:43], v[188:191]
		v_mfma_f32_16x16x32_f16 v[192:195], v[68:71], v[36:39], v[192:195]
		v_mfma_f32_16x16x32_f16 v[192:195], v[72:75], v[40:43], v[192:195]
		v_cvt_pk_f16_f32 v4, v132, v133
		v_cvt_pk_f16_f32 v5, v134, v135
		v_cvt_pk_f16_f32 v6, v136, v137
		v_cvt_pk_f16_f32 v7, v138, v139
		v_cvt_pk_f16_f32 v12, v140, v141
		v_cvt_pk_f16_f32 v13, v142, v143
		v_cvt_pk_f16_f32 v14, v144, v145
		v_cvt_pk_f16_f32 v15, v146, v147
		v_cvt_pk_f16_f32 v16, v148, v149
		v_cvt_pk_f16_f32 v17, v150, v151
		v_cvt_pk_f16_f32 v18, v152, v153
		v_cvt_pk_f16_f32 v19, v154, v155
		v_cvt_pk_f16_f32 v20, v156, v157
		v_cvt_pk_f16_f32 v21, v158, v159
		v_cvt_pk_f16_f32 v22, v160, v161
		v_cvt_pk_f16_f32 v23, v162, v163
		v_cvt_pk_f16_f32 v24, v164, v165
		v_cvt_pk_f16_f32 v25, v166, v167
		v_cvt_pk_f16_f32 v26, v168, v169
		v_cvt_pk_f16_f32 v27, v170, v171
		v_cvt_pk_f16_f32 v28, v172, v173
		v_cvt_pk_f16_f32 v29, v174, v175
		v_cvt_pk_f16_f32 v30, v176, v177
		v_cvt_pk_f16_f32 v31, v178, v179
		v_cvt_pk_f16_f32 v32, v180, v181
		v_cvt_pk_f16_f32 v33, v182, v183
		v_cvt_pk_f16_f32 v34, v184, v185
		v_cvt_pk_f16_f32 v35, v186, v187
		v_cvt_pk_f16_f32 v36, v188, v189
		v_cvt_pk_f16_f32 v37, v190, v191
		v_cvt_pk_f16_f32 v38, v192, v193
		v_cvt_pk_f16_f32 v39, v194, v195
		v_add_co_u32_e64 v40, vcc, v102, v107
		v_addc_co_u32_e64 v41, vcc, v103, 0, vcc
		v_add_co_u32_e64 v42, vcc, v40, v98
		v_addc_co_u32_e64 v43, vcc, v41, v99, vcc
		v_cmp_lt_i32_e64 vcc, v43, s1
		s_mov_b64 s[2:3], vcc
		v_cmp_eq_u32_e64 vcc, v43, s1
		s_mov_b64 s[18:19], vcc
		v_cmp_lt_u32_e64 vcc, v42, s9
		s_mov_b64 s[20:21], vcc
		s_and_b32 s22, s18, s20
		s_and_b32 s23, s19, s21
		s_or_b32 s18, s2, s22
		s_or_b32 s19, s3, s23
		v_mov_b32_e32 v3, 0xa0
		v_add_co_u32_e64 v40, vcc, v102, v3
		v_addc_co_u32_e64 v41, vcc, v103, 0, vcc
		v_add_co_u32_e64 v42, vcc, v40, v98
		v_addc_co_u32_e64 v43, vcc, v41, v99, vcc
		v_cmp_lt_i32_e64 vcc, v43, s1
		s_mov_b64 s[2:3], vcc
		v_cmp_eq_u32_e64 vcc, v43, s1
		s_mov_b64 s[20:21], vcc
		v_cmp_lt_u32_e64 vcc, v42, s9
		s_mov_b64 s[22:23], vcc
		s_and_b32 s24, s20, s22
		s_and_b32 s25, s21, s23
		s_or_b32 s20, s2, s24
		s_or_b32 s21, s3, s25
		v_add_co_u32_e64 v40, vcc, v102, v108
		v_addc_co_u32_e64 v41, vcc, v103, 0, vcc
		v_add_co_u32_e64 v42, vcc, v40, v98
		v_addc_co_u32_e64 v43, vcc, v41, v99, vcc
		v_cmp_lt_i32_e64 vcc, v43, s1
		s_mov_b64 s[2:3], vcc
		v_cmp_eq_u32_e64 vcc, v43, s1
		s_mov_b64 s[22:23], vcc
		v_cmp_lt_u32_e64 vcc, v42, s9
		s_mov_b64 s[24:25], vcc
		s_and_b32 s28, s22, s24
		s_and_b32 s29, s23, s25
		s_or_b32 s22, s2, s28
		s_or_b32 s23, s3, s29
		v_mov_b32_e32 v3, 0xe0
		v_add_co_u32_e64 v40, vcc, v102, v3
		v_addc_co_u32_e64 v41, vcc, v103, 0, vcc
		v_add_co_u32_e64 v42, vcc, v40, v98
		v_addc_co_u32_e64 v43, vcc, v41, v99, vcc
		v_cmp_lt_i32_e64 vcc, v43, s1
		s_mov_b64 s[2:3], vcc
		v_cmp_eq_u32_e64 vcc, v43, s1
		s_mov_b64 s[24:25], vcc
		v_cmp_lt_u32_e64 vcc, v42, s9
		s_mov_b64 s[0:1], vcc
		s_and_b32 s28, s24, s0
		s_and_b32 s29, s25, s1
		s_or_b32 s0, s2, s28
		s_or_b32 s1, s3, s29
		s_and_b32 s2, s4, s18
		s_and_b32 s3, s5, s19
		s_add_i32 s7, s43, s6
		s_add_i32 s6, s7, s8
		v_add_u32_e32 v3, s6, v101
		v_add3_u32 v11, v3, v106, v110
		v_add3_u32 v3, v11, v112, v114
		v_add3_u32 v11, v3, v116, v105
		v_add3_u32 v3, v11, v100, v119
		v_cndmask_b32_e64 v11, v117, v3, s[2:3]
		buffer_store_dwordx2 v[4:5], v11, s[32:35], 0 offen
		s_and_b32 s2, s4, s20
		s_and_b32 s3, s5, s21
		v_add_u32_e32 v3, s6, v2
		v_add3_u32 v4, v3, v106, v112
		v_add3_u32 v3, v4, v114, v116
		v_add_u32_e32 v4, v3, v118
		v_cndmask_b32_e64 v5, v117, v4, s[2:3]
		buffer_store_dwordx2 v[6:7], v5, s[32:35], 0 offen
		s_and_b32 s2, s4, s22
		s_and_b32 s3, s5, s23
		v_add_u32_e32 v4, v3, v9
		v_cndmask_b32_e64 v3, v117, v4, s[2:3]
		buffer_store_dwordx2 v[12:13], v3, s[32:35], 0 offen
		s_and_b32 s2, s4, s0
		s_and_b32 s3, s5, s1
		s_add_i32 s4, s43, s13
		s_add_i32 s5, s4, s27
		v_add3_u32 v3, s5, v2, v106
		v_add3_u32 v2, v3, v112, v114
		v_add3_u32 v3, v2, v116, v0
		v_cndmask_b32_e64 v2, v117, v3, s[2:3]
		buffer_store_dwordx2 v[14:15], v2, s[32:35], 0 offen
		s_and_b32 s2, s10, s18
		s_and_b32 s3, s11, s19
		v_add_u32_e32 v2, s6, v8
		v_add_u32_e32 v3, v2, v105
		v_add3_u32 v4, v3, v100, v119
		v_cndmask_b32_e64 v3, v117, v4, s[2:3]
		buffer_store_dwordx2 v[16:17], v3, s[32:35], 0 offen
		s_and_b32 s2, s10, s20
		s_and_b32 s3, s11, s21
		v_add_u32_e32 v3, v2, v118
		v_cndmask_b32_e64 v4, v117, v3, s[2:3]
		buffer_store_dwordx2 v[18:19], v4, s[32:35], 0 offen
		s_and_b32 s2, s10, s22
		s_and_b32 s3, s11, s23
		v_add_u32_e32 v3, v2, v9
		v_cndmask_b32_e64 v2, v117, v3, s[2:3]
		buffer_store_dwordx2 v[20:21], v2, s[32:35], 0 offen
		s_and_b32 s2, s10, s0
		s_and_b32 s3, s11, s1
		v_add3_u32 v2, s5, v8, v0
		v_cndmask_b32_e64 v3, v117, v2, s[2:3]
		buffer_store_dwordx2 v[22:23], v3, s[32:35], 0 offen
		s_and_b32 s2, s14, s18
		s_and_b32 s3, s15, s19
		v_add_u32_e32 v2, s6, v10
		v_add_u32_e32 v3, v2, v105
		v_add3_u32 v4, v3, v100, v119
		v_cndmask_b32_e64 v3, v117, v4, s[2:3]
		buffer_store_dwordx2 v[24:25], v3, s[32:35], 0 offen
		s_and_b32 s2, s14, s20
		s_and_b32 s3, s15, s21
		v_add_u32_e32 v3, v2, v118
		v_cndmask_b32_e64 v4, v117, v3, s[2:3]
		buffer_store_dwordx2 v[26:27], v4, s[32:35], 0 offen
		s_and_b32 s2, s14, s22
		s_and_b32 s3, s15, s23
		v_add_u32_e32 v3, v2, v9
		v_cndmask_b32_e64 v2, v117, v3, s[2:3]
		buffer_store_dwordx2 v[28:29], v2, s[32:35], 0 offen
		s_and_b32 s2, s14, s0
		s_and_b32 s3, s15, s1
		v_add3_u32 v2, s5, v10, v0
		v_cndmask_b32_e64 v3, v117, v2, s[2:3]
		buffer_store_dwordx2 v[30:31], v3, s[32:35], 0 offen
		s_and_b32 s2, s16, s18
		s_and_b32 s3, s17, s19
		v_add_u32_e32 v2, s5, v1
		v_add_u32_e32 v1, v2, v105
		v_add3_u32 v3, v1, v100, v119
		v_cndmask_b32_e64 v1, v117, v3, s[2:3]
		buffer_store_dwordx2 v[32:33], v1, s[32:35], 0 offen
		s_and_b32 s2, s16, s20
		s_and_b32 s3, s17, s21
		v_add_u32_e32 v1, v2, v118
		v_cndmask_b32_e64 v3, v117, v1, s[2:3]
		buffer_store_dwordx2 v[34:35], v3, s[32:35], 0 offen
		s_and_b32 s2, s16, s22
		s_and_b32 s3, s17, s23
		v_add_u32_e32 v1, v2, v9
		v_cndmask_b32_e64 v3, v117, v1, s[2:3]
		buffer_store_dwordx2 v[36:37], v3, s[32:35], 0 offen
		s_and_b32 s2, s16, s0
		s_and_b32 s3, s17, s1
		v_add_u32_e32 v1, v2, v0
		v_cndmask_b32_e64 v0, v117, v1, s[2:3]
		buffer_store_dwordx2 v[38:39], v0, s[32:35], 0 offen
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	v9_beyond_hotloop, .-v9_beyond_hotloop
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel v9_beyond_hotloop
		.amdhsa_group_segment_fixed_size 159552
		.amdhsa_private_segment_fixed_size 96
		.amdhsa_kernarg_size 48
		.amdhsa_user_sgpr_count 13
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_user_sgpr_kernarg_preload_length 11
		.amdhsa_user_sgpr_kernarg_preload_offset 0
		.amdhsa_enable_private_segment 1
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 0
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 256
		.amdhsa_next_free_sgpr 59
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
	.set .Lv9_beyond_hotloop.num_vgpr, 256
	.set .Lv9_beyond_hotloop.num_agpr, 0
	.set .Lv9_beyond_hotloop.numbered_sgpr, 59
	.set .Lv9_beyond_hotloop.num_named_barrier, 0
	.set .Lv9_beyond_hotloop.private_seg_size, 96
	.set .Lv9_beyond_hotloop.uses_vcc, 1
	.set .Lv9_beyond_hotloop.uses_flat_scratch, 1
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
    .group_segment_fixed_size: 159552
    .kernarg_segment_align: 8
    .kernarg_segment_size: 48
    .max_flat_workgroup_size: 512
    .name:           v9_beyond_hotloop
    .private_segment_fixed_size: 96
    .sgpr_count:     59
    .sgpr_spill_count: 0
    .symbol:         v9_beyond_hotloop.kd
    .uses_dynamic_stack: false
    .vgpr_count:     256
    .agpr_count:     0
    .vgpr_spill_count: 24
    .wavefront_size: 64
    .workgroup_processor_mode: 1
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
