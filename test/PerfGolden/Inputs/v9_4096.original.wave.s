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
		v_mov_b32_e32 v4, 0
		s_mov_b32 s14, 1
		s_mov_b32 s15, 0
		s_and_saveexec_b64 s[16:17], s[14:15]
		v_mov_b32_e32 v1, 0x20f40
		ds_write_b32 v1, v4
		v_mov_b32_e32 v2, 0x20f44
		ds_write_b32 v2, v4
		v_mov_b32_e32 v3, 0x20f48
		ds_write_b32 v3, v4
		v_mov_b32_e32 v8, 0x20f4c
		ds_write_b32 v8, v4
		v_mov_b32_e32 v9, 0x20f50
		ds_write_b32 v9, v4
		v_mov_b32_e32 v10, 0x20f54
		ds_write_b32 v10, v4
		s_mov_b64 exec, s[16:17]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mov_b32_e32 v5, 0
		v_mov_b64_e32 v[6:7], 0
		s_add_i32 s0, s8, 0xff
		s_mov_b32 s1, 0xff
		s_cmp_lt_i32 s0, 0
		s_cselect_b32 s16, s1, 0
		s_add_i32 s0, s0, s16
		s_ashr_i32 s0, s0, 8
		s_add_i32 s16, s9, 0xff
		s_cmp_lt_i32 s16, 0
		s_cselect_b32 s1, s1, 0
		s_add_i32 s1, s16, s1
		s_ashr_i32 s1, s1, 8
		s_and_b32 s16, s13, 7
		s_lshr_b32 s13, s13, 3
		s_mul_i32 s16, s16, 32
		s_add_i32 s13, s16, s13
		s_mul_i32 s1, s1, 4
		s_cmp_lt_i32 s13, 0
		s_cselect_b32 s16, 1, 0
		s_xor_b32 s17, s13, -1
		s_add_i32 s17, s17, 1
		s_cmp_lg_u32 s16, 0
		s_cselect_b32 s16, s17, s13
		s_cselect_b32 s17, 1, 0
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s18, 1, 0
		s_xor_b32 s19, s1, -1
		s_add_i32 s19, s19, 1
		s_cmp_lg_u32 s18, 0
		s_cselect_b32 s18, s19, s1
		v_mov_b32_e32 v11, s18
		v_cvt_f32_u32_e32 v11, v11
		v_rcp_iflag_f32_e32 v11, v11
		v_mov_b32_e32 v12, 0x4f7ffffe
		v_mul_f32_e32 v11, v12, v11
		v_cvt_u32_f32_e32 v11, v11
		s_nop 0
		v_readfirstlane_b32 s19, v11
		s_xor_b32 s20, s18, -1
		s_add_i32 s20, s20, 1
		s_mul_i32 s21, s20, s19
		s_mul_hi_u32 s21, s19, s21
		s_add_i32 s19, s19, s21
		s_mul_hi_u32 s19, s16, s19
		s_mul_i32 s21, s19, s18
		s_xor_b32 s21, s21, -1
		s_add_i32 s21, s21, 1
		s_add_i32 s16, s16, s21
		s_cmp_ge_u32 s16, s18
		s_cselect_b32 s21, 1, 0
		s_add_i32 s22, s19, 1
		s_cmp_lg_u32 s21, 0
		s_cselect_b32 s19, s22, s19
		s_cselect_b32 s21, 1, 0
		s_add_i32 s22, s16, s20
		s_cmp_lg_u32 s21, 0
		s_cselect_b32 s16, s22, s16
		s_cmp_ge_u32 s16, s18
		s_cselect_b32 s18, 1, 0
		s_add_i32 s21, s19, 1
		s_cmp_lg_u32 s18, 0
		s_cselect_b32 s18, s21, s19
		s_cselect_b32 s19, 1, 0
		s_xor_b32 s1, s13, s1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s1, 1, 0
		s_xor_b32 s13, s18, -1
		s_add_i32 s13, s13, 1
		s_cmp_lg_u32 s1, 0
		s_cselect_b32 s1, s13, s18
		s_mul_i32 s13, s1, 4
		s_xor_b32 s18, s13, -1
		s_add_i32 s18, s18, 1
		s_add_i32 s0, s0, s18
		s_cmp_lt_i32 s0, 4
		s_cselect_b32 s0, s0, 4
		s_add_i32 s18, s16, s20
		s_cmp_lg_u32 s19, 0
		s_cselect_b32 s16, s18, s16
		s_xor_b32 s18, s16, -1
		s_add_i32 s18, s18, 1
		s_cmp_lg_u32 s17, 0
		s_cselect_b32 s16, s18, s16
		v_mov_b32_e32 v11, s0
		v_cvt_f32_u32_e32 v11, v11
		v_rcp_iflag_f32_e32 v11, v11
		s_nop 0
		v_mul_f32_e32 v11, v12, v11
		v_cvt_u32_f32_e32 v11, v11
		s_nop 0
		v_readfirstlane_b32 s17, v11
		s_xor_b32 s18, s0, -1
		s_add_i32 s18, s18, 1
		s_mul_i32 s19, s18, s17
		s_mul_hi_u32 s19, s17, s19
		s_add_i32 s17, s17, s19
		s_mul_hi_u32 s17, s16, s17
		s_mul_i32 s17, s17, s0
		s_xor_b32 s17, s17, -1
		s_add_i32 s17, s17, 1
		s_add_i32 s17, s16, s17
		s_cmp_ge_u32 s17, s0
		s_cselect_b32 s19, 1, 0
		s_add_i32 s20, s17, s18
		s_cmp_lg_u32 s19, 0
		s_cselect_b32 s17, s20, s17
		s_cmp_ge_u32 s17, s0
		s_cselect_b32 s19, 1, 0
		s_add_i32 s20, s17, s18
		s_cmp_lg_u32 s19, 0
		s_cselect_b32 s17, s20, s17
		s_add_i32 s13, s13, s17
		v_readfirstlane_b32 s19, v11
		s_mul_i32 s20, s18, s19
		s_mul_hi_u32 s20, s19, s20
		s_add_i32 s19, s19, s20
		s_mul_hi_u32 s19, s16, s19
		s_mul_i32 s20, s19, s0
		s_xor_b32 s20, s20, -1
		s_add_i32 s20, s20, 1
		s_add_i32 s16, s16, s20
		s_cmp_ge_u32 s16, s0
		s_cselect_b32 s20, 1, 0
		s_add_i32 s21, s19, 1
		s_cmp_lg_u32 s20, 0
		s_cselect_b32 s19, s21, s19
		s_cselect_b32 s20, 1, 0
		s_add_i32 s18, s16, s18
		s_cmp_lg_u32 s20, 0
		s_cselect_b32 s16, s18, s16
		s_cmp_ge_u32 s16, s0
		s_cselect_b32 s0, 1, 0
		s_add_i32 s16, s19, 1
		s_cmp_lg_u32 s0, 0
		s_cselect_b32 s0, s16, s19
		s_mul_i32 s13, s13, 0x100
		v_and_b32_e32 v11, 1, v0
		v_lshrrev_b32_e32 v12, 1, v0
		v_and_b32_e32 v13, 1, v12
		v_mad_u32_u24 v11, v13, 2, v11
		v_lshrrev_b32_e32 v13, 2, v0
		v_and_b32_e32 v14, 1, v13
		v_mad_u32_u24 v11, v14, 4, v11
		v_lshrrev_b32_e32 v14, 3, v0
		v_and_b32_e32 v15, 1, v14
		v_mad_u32_u24 v11, v15, 8, v11
		v_lshrrev_b32_e32 v15, 7, v0
		v_and_b32_e32 v16, 1, v15
		v_mad_u32_u24 v11, v16, 16, v11
		v_lshrrev_b32_e32 v16, 8, v0
		v_and_b32_e32 v17, 1, v16
		v_mad_u32_u24 v11, v17, 32, v11
		v_add_u32_e32 v17, 0x80, v11
		v_add_u32_e32 v18, 0xc0, v11
		v_add_u32_e32 v19, s13, v11
		v_add3_u32 v11, 64, v11, s13
		v_add_u32_e32 v17, s13, v17
		v_add_u32_e32 v18, s13, v18
		s_mul_i32 s13, s0, 0x100
		v_lshrrev_b32_e32 v20, 4, v0
		v_and_b32_e32 v21, 7, v20
		v_mov_b32_e32 v22, 4
		v_mul_lo_u32 v22, v22, v21
		v_add_u32_e32 v21, 32, v22
		v_add_u32_e32 v23, 64, v22
		v_add_u32_e32 v24, 0x60, v22
		v_add_u32_e32 v25, s13, v22
		v_add_u32_e32 v26, s13, v21
		v_add_u32_e32 v27, s13, v23
		v_add_u32_e32 v28, s13, v24
		s_mov_b32 s22, 0x7fffffff
		s_mov_b32 s23, 0x31016000
		s_mov_b32 s20, s2
		s_mov_b32 s21, s3
		s_mov_b32 s24, s4
		s_mov_b32 s25, s5
		s_mov_b32 s26, s22
		s_mov_b32 s27, s23
		v_readfirstlane_b32 s2, v0
		s_lshr_b32 s2, s2, 6
		s_mul_i32 s2, 0x420, s2
		s_mov_b32 m0, s2
		v_mul_lo_u32 v29, s10, v14
		v_lshlrev_b32_e32 v30, 3, v0
		v_and_b32_e32 v31, 63, v30
		v_lshlrev_b32_e32 v31, 1, v31
		v_lshl_add_u32 v29, v29, 1, v31
		s_mul_i32 s3, s10, s1
		s_lshl_b32 s3, s3, 11
		s_mul_i32 s4, s10, s17
		s_lshl_b32 s4, s4, 9
		s_add_i32 s5, s3, s4
		v_add_u32_e32 v31, s5, v29
		buffer_load_dwordx4 v31, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x2100
		s_lshl_b32 s16, s10, 7
		s_add_i32 s18, s16, s3
		s_add_i32 s18, s18, s4
		v_add_u32_e32 v31, s18, v29
		buffer_load_dwordx4 v31, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x4200
		s_lshl_b32 s19, s10, 8
		s_add_i32 s28, s19, s3
		s_add_i32 s28, s28, s4
		v_add_u32_e32 v31, s28, v29
		buffer_load_dwordx4 v31, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x6300
		s_mul_i32 s10, 0x180, s10
		s_add_i32 s29, s10, s3
		s_add_i32 s29, s29, s4
		v_add_u32_e32 v31, s29, v29
		buffer_load_dwordx4 v31, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x107c0
		v_mul_lo_u32 v31, s11, v20
		v_and_b32_e32 v30, 0x7f, v30
		v_lshlrev_b32_e32 v30, 1, v30
		v_lshl_add_u32 v30, v31, 1, v30
		s_lshl_b32 s0, s0, 9
		v_add_u32_e32 v31, s0, v30
		buffer_load_dwordx4 v31, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x128c0
		s_lshl_b32 s30, s11, 6
		s_add_i32 s31, s30, s0
		v_add_u32_e32 v31, s31, v30
		buffer_load_dwordx4 v31, s[24:27], 0 offen lds
		v_mov_b32_e32 v31, 1
		s_and_saveexec_b64 s[32:33], s[14:15]
		s_waitcnt vmcnt(0)
		ds_add_rtn_u32 v32, v1, v31
		s_mov_b64 exec, s[32:33]
		s_add_i32 m0, s2, 0x18b80
		s_add_i32 s32, s0, 0x100
		v_add_u32_e32 v33, s32, v30
		buffer_load_dwordx4 v33, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1ac80
		s_add_i32 s30, s30, 0x100
		s_add_i32 s30, s30, s0
		v_add_u32_e32 v33, s30, v30
		s_mul_i32 s33, s11, 64
		s_mul_i32 s34, 0xc0, s11
		v_and_b32_e32 v34, 63, v0
		v_and_b32_e32 v35, 15, v34
		buffer_load_dwordx4 v33, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x83e0
		s_add_i32 s35, s3, 0x80
		s_add_i32 s35, s35, s4
		v_add_u32_e32 v33, s35, v29
		v_lshl_add_u32 v36, v15, 4, v35
		buffer_load_dwordx4 v33, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0xa4e0
		s_add_i32 s16, s16, 0x80
		s_add_i32 s16, s16, s3
		s_add_i32 s16, s16, s4
		v_add_u32_e32 v33, s16, v29
		buffer_load_dwordx4 v33, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0xc5e0
		s_add_i32 s19, s19, 0x80
		s_add_i32 s19, s19, s3
		s_add_i32 s19, s19, s4
		v_add_u32_e32 v33, s19, v29
		buffer_load_dwordx4 v33, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0xe6e0
		s_add_i32 s10, s10, 0x80
		s_add_i32 s3, s10, s3
		s_add_i32 s3, s3, s4
		v_add_u32_e32 v33, s3, v29
		v_lshrrev_b32_e32 v36, 5, v36
		v_mov_b32_e32 v37, 0x1080
		v_mul_lo_u32 v37, v37, v36
		buffer_load_dwordx4 v33, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x149a0
		s_lshl_b32 s4, s11, 7
		s_add_i32 s10, s4, s0
		v_add_u32_e32 v33, s10, v30
		buffer_load_dwordx4 v33, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x16aa0
		s_add_i32 s11, s34, s0
		v_add_u32_e32 v33, s11, v30
		v_lshrrev_b32_e32 v34, 4, v34
		buffer_load_dwordx4 v33, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1cd60
		s_add_i32 s4, s4, 0x100
		s_add_i32 s4, s4, s0
		v_add_u32_e32 v33, s4, v30
		v_lshl_add_u32 v36, v34, 4, v37
		v_lshrrev_b32_e32 v37, 3, v35
		v_mov_b32_e32 v38, 0x420
		v_mul_lo_u32 v38, v38, v37
		v_and_b32_e32 v37, 1, v15
		buffer_load_dwordx4 v33, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1ee60
		s_add_i32 s34, s34, 0x100
		s_add_i32 s34, s34, s0
		v_add_u32_e32 v33, s34, v30
		s_add_i32 s36, s33, s33
		buffer_load_dwordx4 v33, s[24:27], 0 offen lds
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s37, v32
		s_and_b32 s37, s37, -8
		s_add_i32 s37, s37, 8
		s_and_saveexec_b64 s[38:39], s[14:15]
.Lv9_beyond_hotloop.loop_head_0:
		ds_read_b32 v32, v1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s40, v32
		s_xor_b32 s41, s37, -1
		s_add_i32 s41, s41, 1
		s_add_i32 s40, s40, s41
		s_cmp_ge_u32 s40, 0x80000000
		s_cbranch_scc1 .Lv9_beyond_hotloop.loop_head_0
.Lv9_beyond_hotloop.loop_exit_0:
		s_mov_b64 exec, s[38:39]
		v_mov_b32_e32 v1, 0x840
		v_mul_lo_u32 v1, v1, v37
		v_add3_u32 v1, v36, v38, v1
		v_lshrrev_b32_e32 v32, 2, v35
		v_and_b32_e32 v33, 1, v32
		v_lshl_add_u32 v1, v33, 9, v1
		v_lshrrev_b32_e32 v33, 1, v35
		v_and_b32_e32 v33, 1, v33
		v_lshl_add_u32 v1, v33, 8, v1
		v_and_b32_e32 v33, 1, v35
		v_lshl_add_u32 v1, v33, 7, v1
		ds_read_b128 v[40:43], v1
		ds_read_b128 v[44:47], v1 offset:64
		ds_read_b128 v[48:51], v1 offset:8448
		ds_read_b128 v[52:55], v1 offset:8512
		ds_read_b128 v[56:59], v1 offset:16896
		ds_read_b128 v[60:63], v1 offset:16960
		ds_read_b128 v[64:67], v1 offset:25344
		ds_read_b128 v[68:71], v1 offset:25408
		v_lshl_add_u32 v33, v34, 3, v32
		v_lshrrev_b32_e32 v33, 4, v33
		v_mov_b32_e32 v36, 0x1080
		v_mul_lo_u32 v36, v36, v33
		v_add_u32_e32 v33, 0x10000, v36
		v_lshl_add_u32 v32, v32, 8, v33
		v_lshrrev_b32_e32 v33, 6, v0
		v_and_b32_e32 v33, 1, v33
		v_lshlrev_b32_e32 v36, 5, v33
		v_and_b32_e32 v34, 1, v34
		v_mov_b32_e32 v38, 0x840
		v_mul_lo_u32 v38, v38, v34
		v_add3_u32 v32, v32, v36, v38
		v_and_b32_e32 v34, 3, v35
		v_lshl_add_u32 v32, v34, 3, v32
		ds_read_b64_tr_b16 v[72:73], v32 offset:1984
		ds_read_b64_tr_b16 v[74:75], v32 offset:3040
		ds_read_b64_tr_b16 v[76:77], v32 offset:10432
		ds_read_b64_tr_b16 v[78:79], v32 offset:11488
		ds_read_b64_tr_b16 v[80:81], v32 offset:2048
		ds_read_b64_tr_b16 v[82:83], v32 offset:3104
		ds_read_b64_tr_b16 v[84:85], v32 offset:10496
		ds_read_b64_tr_b16 v[86:87], v32 offset:11552
		ds_read_b64_tr_b16 v[88:89], v32 offset:2112
		ds_read_b64_tr_b16 v[90:91], v32 offset:3168
		ds_read_b64_tr_b16 v[92:93], v32 offset:10560
		ds_read_b64_tr_b16 v[94:95], v32 offset:11616
		ds_read_b64_tr_b16 v[96:97], v32 offset:2176
		ds_read_b64_tr_b16 v[98:99], v32 offset:3232
		ds_read_b64_tr_b16 v[100:101], v32 offset:10624
		ds_read_b64_tr_b16 v[102:103], v32 offset:11680
		s_mov_b32 s37, 0x80
		s_mov_b32 s38, s37
		s_mov_b32 s37, 0
		s_lshl_b32 s39, s38, 1
		s_lshl_b32 s38, s36, 1
		s_lshl_b32 s33, s33, 1
		v_mov_b32_e32 v104, v4
		v_mov_b32_e32 v105, v5
		v_mov_b32_e32 v106, v6
		v_mov_b32_e32 v107, v7
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
		v_mov_b64_e32 v[220:221], 0
		v_mov_b64_e32 v[222:223], 0
		v_mov_b64_e32 v[224:225], 0
		v_mov_b64_e32 v[226:227], 0
.Lv9_beyond_hotloop.loop_head_1:
		s_and_saveexec_b64 s[40:41], s[14:15]
		s_waitcnt vmcnt(8)
		ds_add_rtn_u32 v34, v2, v31
		s_mov_b64 exec, s[40:41]
		s_and_saveexec_b64 s[40:41], s[14:15]
		s_waitcnt vmcnt(2)
		ds_add_rtn_u32 v35, v3, v31
		s_mov_b64 exec, s[40:41]
		s_and_saveexec_b64 s[40:41], s[14:15]
		s_waitcnt vmcnt(0)
		ds_add_rtn_u32 v38, v8, v31
		s_mov_b64 exec, s[40:41]
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[4:7], v[72:75], v[40:43], v[4:7]
		s_waitcnt lgkmcnt(13)
		v_mfma_f32_16x16x32_f16 v[104:107], v[80:83], v[40:43], v[104:107]
		s_waitcnt lgkmcnt(9)
		v_mfma_f32_16x16x32_f16 v[108:111], v[88:91], v[40:43], v[108:111]
		s_waitcnt lgkmcnt(5)
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[40:43], v[112:115]
		v_mfma_f32_16x16x32_f16 v[128:131], v[96:99], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[116:119], v[72:75], v[48:51], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[80:83], v[48:51], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[88:91], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[88:91], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[72:75], v[56:59], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[80:83], v[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[144:147], v[96:99], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[96:99], v[64:67], v[160:163]
		v_mfma_f32_16x16x32_f16 v[148:151], v[72:75], v[64:67], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[80:83], v[64:67], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[88:91], v[64:67], v[156:159]
		v_mfma_f32_16x16x32_f16 v[4:7], v[76:79], v[44:47], v[4:7]
		v_mfma_f32_16x16x32_f16 v[104:107], v[84:87], v[44:47], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[92:95], v[44:47], v[108:111]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[112:115], v[100:103], v[44:47], v[112:115]
		v_mfma_f32_16x16x32_f16 v[128:131], v[100:103], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[116:119], v[76:79], v[52:55], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[84:87], v[52:55], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[92:95], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[92:95], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[76:79], v[60:63], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[84:87], v[60:63], v[136:139]
		v_mfma_f32_16x16x32_f16 v[144:147], v[100:103], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[100:103], v[68:71], v[160:163]
		v_mfma_f32_16x16x32_f16 v[148:151], v[76:79], v[68:71], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[84:87], v[68:71], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[92:95], v[68:71], v[156:159]
		s_waitcnt lgkmcnt(2)
		v_readfirstlane_b32 s36, v34
		s_and_b32 s36, s36, -8
		s_add_i32 s36, s36, 8
		s_and_saveexec_b64 s[40:41], s[14:15]
.Lv9_beyond_hotloop.loop_head_2:
		ds_read_b32 v34, v2
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s42, v34
		s_xor_b32 s43, s36, -1
		s_add_i32 s43, s43, 1
		s_add_i32 s42, s42, s43
		s_cmp_ge_u32 s42, 0x80000000
		s_cbranch_scc1 .Lv9_beyond_hotloop.loop_head_2
.Lv9_beyond_hotloop.loop_exit_2:
		s_mov_b64 exec, s[40:41]
		ds_read_b64_tr_b16 v[72:73], v32 offset:35712
		ds_read_b64_tr_b16 v[74:75], v32 offset:36768
		ds_read_b64_tr_b16 v[76:77], v32 offset:44160
		ds_read_b64_tr_b16 v[78:79], v32 offset:45216
		ds_read_b64_tr_b16 v[80:81], v32 offset:35776
		ds_read_b64_tr_b16 v[82:83], v32 offset:36832
		ds_read_b64_tr_b16 v[84:85], v32 offset:44224
		ds_read_b64_tr_b16 v[86:87], v32 offset:45280
		ds_read_b64_tr_b16 v[88:89], v32 offset:35840
		ds_read_b64_tr_b16 v[90:91], v32 offset:36896
		ds_read_b64_tr_b16 v[92:93], v32 offset:44288
		ds_read_b64_tr_b16 v[94:95], v32 offset:45344
		ds_read_b64_tr_b16 v[96:97], v32 offset:35904
		ds_read_b64_tr_b16 v[98:99], v32 offset:36960
		ds_read_b64_tr_b16 v[100:101], v32 offset:44352
		ds_read_b64_tr_b16 v[102:103], v32 offset:45408
		s_mov_b32 m0, s2
		s_add_i32 s36, s5, s39
		v_add_u32_e32 v34, s36, v29
		buffer_load_dwordx4 v34, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x2100
		v_add_u32_e32 v34, s39, v29
		v_add_u32_e32 v39, s18, v34
		buffer_load_dwordx4 v39, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x4200
		v_add_u32_e32 v39, s28, v34
		buffer_load_dwordx4 v39, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x6300
		v_add_u32_e32 v34, s29, v34
		buffer_load_dwordx4 v34, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x107c0
		s_add_i32 s36, s0, s38
		v_add_u32_e32 v34, s36, v30
		buffer_load_dwordx4 v34, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x128c0
		s_add_i32 s36, s31, s38
		v_add_u32_e32 v34, s36, v30
		buffer_load_dwordx4 v34, s[24:27], 0 offen lds
		s_and_saveexec_b64 s[40:41], s[14:15]
		s_waitcnt vmcnt(0)
		ds_add_rtn_u32 v34, v9, v31
		s_mov_b64 exec, s[40:41]
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[164:167], v[72:75], v[40:43], v[164:167]
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_16x16x32_f16 v[168:171], v[80:83], v[40:43], v[168:171]
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[172:175], v[88:91], v[40:43], v[172:175]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[176:179], v[96:99], v[40:43], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[96:99], v[48:51], v[192:195]
		v_mfma_f32_16x16x32_f16 v[180:183], v[72:75], v[48:51], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[80:83], v[48:51], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[88:91], v[48:51], v[188:191]
		v_mfma_f32_16x16x32_f16 v[204:207], v[88:91], v[56:59], v[204:207]
		v_mfma_f32_16x16x32_f16 v[196:199], v[72:75], v[56:59], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[80:83], v[56:59], v[200:203]
		v_mfma_f32_16x16x32_f16 v[208:211], v[96:99], v[56:59], v[208:211]
		v_mfma_f32_16x16x32_f16 v[224:227], v[96:99], v[64:67], v[224:227]
		v_mfma_f32_16x16x32_f16 v[212:215], v[72:75], v[64:67], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], v[80:83], v[64:67], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], v[88:91], v[64:67], v[220:223]
		v_mfma_f32_16x16x32_f16 v[164:167], v[76:79], v[44:47], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[84:87], v[44:47], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[92:95], v[44:47], v[172:175]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[176:179], v[100:103], v[44:47], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[100:103], v[52:55], v[192:195]
		v_mfma_f32_16x16x32_f16 v[180:183], v[76:79], v[52:55], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[84:87], v[52:55], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[92:95], v[52:55], v[188:191]
		v_mfma_f32_16x16x32_f16 v[204:207], v[92:95], v[60:63], v[204:207]
		v_mfma_f32_16x16x32_f16 v[196:199], v[76:79], v[60:63], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[84:87], v[60:63], v[200:203]
		v_mfma_f32_16x16x32_f16 v[208:211], v[100:103], v[60:63], v[208:211]
		v_mfma_f32_16x16x32_f16 v[224:227], v[100:103], v[68:71], v[224:227]
		v_mfma_f32_16x16x32_f16 v[212:215], v[76:79], v[68:71], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], v[84:87], v[68:71], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], v[92:95], v[68:71], v[220:223]
		v_readfirstlane_b32 s36, v35
		s_and_b32 s36, s36, -8
		s_add_i32 s36, s36, 8
		s_and_saveexec_b64 s[40:41], s[14:15]
.Lv9_beyond_hotloop.loop_head_3:
		ds_read_b32 v35, v3
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s42, v35
		s_xor_b32 s43, s36, -1
		s_add_i32 s43, s43, 1
		s_add_i32 s42, s42, s43
		s_cmp_ge_u32 s42, 0x80000000
		s_cbranch_scc1 .Lv9_beyond_hotloop.loop_head_3
.Lv9_beyond_hotloop.loop_exit_3:
		s_mov_b64 exec, s[40:41]
		ds_read_b128 v[40:43], v1 offset:33760
		ds_read_b128 v[44:47], v1 offset:33824
		ds_read_b128 v[48:51], v1 offset:42208
		ds_read_b128 v[52:55], v1 offset:42272
		ds_read_b128 v[56:59], v1 offset:50656
		ds_read_b128 v[60:63], v1 offset:50720
		ds_read_b128 v[64:67], v1 offset:59104
		ds_read_b128 v[68:71], v1 offset:59168
		ds_read_b64_tr_b16 v[72:73], v32 offset:18848
		ds_read_b64_tr_b16 v[74:75], v32 offset:19904
		ds_read_b64_tr_b16 v[76:77], v32 offset:27296
		ds_read_b64_tr_b16 v[78:79], v32 offset:28352
		ds_read_b64_tr_b16 v[80:81], v32 offset:18912
		ds_read_b64_tr_b16 v[82:83], v32 offset:19968
		ds_read_b64_tr_b16 v[84:85], v32 offset:27360
		ds_read_b64_tr_b16 v[86:87], v32 offset:28416
		ds_read_b64_tr_b16 v[88:89], v32 offset:18976
		ds_read_b64_tr_b16 v[90:91], v32 offset:20032
		ds_read_b64_tr_b16 v[92:93], v32 offset:27424
		ds_read_b64_tr_b16 v[94:95], v32 offset:28480
		ds_read_b64_tr_b16 v[96:97], v32 offset:19040
		ds_read_b64_tr_b16 v[98:99], v32 offset:20096
		ds_read_b64_tr_b16 v[100:101], v32 offset:27488
		ds_read_b64_tr_b16 v[102:103], v32 offset:28544
		s_add_i32 m0, s2, 0x18b80
		s_add_i32 s36, s32, s38
		v_add_u32_e32 v35, s36, v30
		buffer_load_dwordx4 v35, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1ac80
		s_add_i32 s36, s30, s38
		v_add_u32_e32 v35, s36, v30
		buffer_load_dwordx4 v35, s[24:27], 0 offen lds
		s_add_i32 s36, s38, s33
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[4:7], v[72:75], v[40:43], v[4:7]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[104:107], v[80:83], v[40:43], v[104:107]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[108:111], v[88:91], v[40:43], v[108:111]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[40:43], v[112:115]
		v_mfma_f32_16x16x32_f16 v[128:131], v[96:99], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[116:119], v[72:75], v[48:51], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[80:83], v[48:51], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[88:91], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[88:91], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[72:75], v[56:59], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[80:83], v[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[144:147], v[96:99], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[96:99], v[64:67], v[160:163]
		v_mfma_f32_16x16x32_f16 v[148:151], v[72:75], v[64:67], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[80:83], v[64:67], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[88:91], v[64:67], v[156:159]
		v_mfma_f32_16x16x32_f16 v[4:7], v[76:79], v[44:47], v[4:7]
		v_mfma_f32_16x16x32_f16 v[104:107], v[84:87], v[44:47], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[92:95], v[44:47], v[108:111]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[112:115], v[100:103], v[44:47], v[112:115]
		v_mfma_f32_16x16x32_f16 v[128:131], v[100:103], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[116:119], v[76:79], v[52:55], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[84:87], v[52:55], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[92:95], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[92:95], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[76:79], v[60:63], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[84:87], v[60:63], v[136:139]
		v_mfma_f32_16x16x32_f16 v[144:147], v[100:103], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[100:103], v[68:71], v[160:163]
		v_mfma_f32_16x16x32_f16 v[148:151], v[76:79], v[68:71], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[84:87], v[68:71], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[92:95], v[68:71], v[156:159]
		v_readfirstlane_b32 s40, v38
		s_and_b32 s40, s40, -8
		s_add_i32 s40, s40, 8
		s_and_saveexec_b64 s[42:43], s[14:15]
.Lv9_beyond_hotloop.loop_head_4:
		ds_read_b32 v35, v8
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s41, v35
		s_xor_b32 s44, s40, -1
		s_add_i32 s44, s44, 1
		s_add_i32 s41, s41, s44
		s_cmp_ge_u32 s41, 0x80000000
		s_cbranch_scc1 .Lv9_beyond_hotloop.loop_head_4
.Lv9_beyond_hotloop.loop_exit_4:
		s_mov_b64 exec, s[42:43]
		ds_read_b64_tr_b16 v[72:73], v32 offset:52576
		ds_read_b64_tr_b16 v[74:75], v32 offset:53632
		ds_read_b64_tr_b16 v[76:77], v32 offset:61024
		ds_read_b64_tr_b16 v[78:79], v32 offset:62080
		ds_read_b64_tr_b16 v[80:81], v32 offset:52640
		ds_read_b64_tr_b16 v[82:83], v32 offset:53696
		ds_read_b64_tr_b16 v[84:85], v32 offset:61088
		ds_read_b64_tr_b16 v[86:87], v32 offset:62144
		ds_read_b64_tr_b16 v[88:89], v32 offset:52704
		ds_read_b64_tr_b16 v[90:91], v32 offset:53760
		ds_read_b64_tr_b16 v[92:93], v32 offset:61152
		ds_read_b64_tr_b16 v[94:95], v32 offset:62208
		ds_read_b64_tr_b16 v[96:97], v32 offset:52768
		ds_read_b64_tr_b16 v[98:99], v32 offset:53824
		ds_read_b64_tr_b16 v[100:101], v32 offset:61216
		ds_read_b64_tr_b16 v[102:103], v32 offset:62272
		s_add_i32 m0, s2, 0x83e0
		s_add_i32 s40, s35, s39
		v_add_u32_e32 v35, s40, v29
		buffer_load_dwordx4 v35, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0xa4e0
		v_add_u32_e32 v35, s39, v29
		v_add_u32_e32 v38, s16, v35
		buffer_load_dwordx4 v38, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0xc5e0
		v_add_u32_e32 v38, s19, v35
		buffer_load_dwordx4 v38, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0xe6e0
		v_add_u32_e32 v35, s3, v35
		buffer_load_dwordx4 v35, s[20:23], 0 offen lds
		s_add_i32 m0, s2, 0x149a0
		s_add_i32 s40, s10, s38
		v_add_u32_e32 v35, s40, v30
		buffer_load_dwordx4 v35, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x16aa0
		s_add_i32 s40, s11, s38
		v_add_u32_e32 v35, s40, v30
		buffer_load_dwordx4 v35, s[24:27], 0 offen lds
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[164:167], v[72:75], v[40:43], v[164:167]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[168:171], v[80:83], v[40:43], v[168:171]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[172:175], v[88:91], v[40:43], v[172:175]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[176:179], v[96:99], v[40:43], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[96:99], v[48:51], v[192:195]
		v_mfma_f32_16x16x32_f16 v[180:183], v[72:75], v[48:51], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[80:83], v[48:51], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[88:91], v[48:51], v[188:191]
		v_mfma_f32_16x16x32_f16 v[204:207], v[88:91], v[56:59], v[204:207]
		v_mfma_f32_16x16x32_f16 v[196:199], v[72:75], v[56:59], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[80:83], v[56:59], v[200:203]
		v_mfma_f32_16x16x32_f16 v[208:211], v[96:99], v[56:59], v[208:211]
		v_mfma_f32_16x16x32_f16 v[224:227], v[96:99], v[64:67], v[224:227]
		v_mfma_f32_16x16x32_f16 v[212:215], v[72:75], v[64:67], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], v[80:83], v[64:67], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], v[88:91], v[64:67], v[220:223]
		v_mfma_f32_16x16x32_f16 v[164:167], v[76:79], v[44:47], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[84:87], v[44:47], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[92:95], v[44:47], v[172:175]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[176:179], v[100:103], v[44:47], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[100:103], v[52:55], v[192:195]
		v_mfma_f32_16x16x32_f16 v[180:183], v[76:79], v[52:55], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[84:87], v[52:55], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[92:95], v[52:55], v[188:191]
		v_mfma_f32_16x16x32_f16 v[204:207], v[92:95], v[60:63], v[204:207]
		v_mfma_f32_16x16x32_f16 v[196:199], v[76:79], v[60:63], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[84:87], v[60:63], v[200:203]
		v_mfma_f32_16x16x32_f16 v[208:211], v[100:103], v[60:63], v[208:211]
		v_mfma_f32_16x16x32_f16 v[224:227], v[100:103], v[68:71], v[224:227]
		v_mfma_f32_16x16x32_f16 v[212:215], v[76:79], v[68:71], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], v[84:87], v[68:71], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], v[92:95], v[68:71], v[220:223]
		v_readfirstlane_b32 s40, v34
		s_and_b32 s40, s40, -8
		s_add_i32 s40, s40, 8
		s_and_saveexec_b64 s[42:43], s[14:15]
.Lv9_beyond_hotloop.loop_head_5:
		ds_read_b32 v34, v9
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s41, v34
		s_xor_b32 s44, s40, -1
		s_add_i32 s44, s44, 1
		s_add_i32 s41, s41, s44
		s_cmp_ge_u32 s41, 0x80000000
		s_cbranch_scc1 .Lv9_beyond_hotloop.loop_head_5
.Lv9_beyond_hotloop.loop_exit_5:
		s_mov_b64 exec, s[42:43]
		ds_read_b128 v[40:43], v1
		ds_read_b128 v[44:47], v1 offset:64
		ds_read_b128 v[48:51], v1 offset:8448
		ds_read_b128 v[52:55], v1 offset:8512
		ds_read_b128 v[56:59], v1 offset:16896
		ds_read_b128 v[60:63], v1 offset:16960
		ds_read_b128 v[64:67], v1 offset:25344
		ds_read_b128 v[68:71], v1 offset:25408
		ds_read_b64_tr_b16 v[72:73], v32 offset:1984
		ds_read_b64_tr_b16 v[74:75], v32 offset:3040
		ds_read_b64_tr_b16 v[76:77], v32 offset:10432
		ds_read_b64_tr_b16 v[78:79], v32 offset:11488
		ds_read_b64_tr_b16 v[80:81], v32 offset:2048
		ds_read_b64_tr_b16 v[82:83], v32 offset:3104
		ds_read_b64_tr_b16 v[84:85], v32 offset:10496
		ds_read_b64_tr_b16 v[86:87], v32 offset:11552
		ds_read_b64_tr_b16 v[88:89], v32 offset:2112
		ds_read_b64_tr_b16 v[90:91], v32 offset:3168
		ds_read_b64_tr_b16 v[92:93], v32 offset:10560
		ds_read_b64_tr_b16 v[94:95], v32 offset:11616
		ds_read_b64_tr_b16 v[96:97], v32 offset:2176
		ds_read_b64_tr_b16 v[98:99], v32 offset:3232
		ds_read_b64_tr_b16 v[100:101], v32 offset:10624
		ds_read_b64_tr_b16 v[102:103], v32 offset:11680
		s_add_i32 m0, s2, 0x1cd60
		s_add_i32 s40, s4, s38
		v_add_u32_e32 v34, s40, v30
		buffer_load_dwordx4 v34, s[24:27], 0 offen lds
		s_add_i32 m0, s2, 0x1ee60
		s_add_i32 s38, s34, s38
		v_add_u32_e32 v34, s38, v30
		buffer_load_dwordx4 v34, s[24:27], 0 offen lds
		s_add_i32 s39, s39, 0x100
		s_add_i32 s38, s36, s33
		s_add_i32 s37, s37, 2
		s_cmp_lt_i32 s37, 62
		s_cbranch_scc1 .Lv9_beyond_hotloop.loop_head_1
.Lv9_beyond_hotloop.loop_exit_1:
		s_mov_b32 s24, s6
		s_mov_b32 s25, s7
		s_mov_b32 s26, s22
		s_mov_b32 s27, s23
		s_and_saveexec_b64 s[2:3], s[14:15]
		s_waitcnt vmcnt(0)
		ds_add_rtn_u32 v2, v10, v31
		s_mov_b64 exec, s[2:3]
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[4:7], v[72:75], v[40:43], v[4:7]
		s_waitcnt lgkmcnt(11)
		v_mfma_f32_16x16x32_f16 v[104:107], v[80:83], v[40:43], v[104:107]
		s_waitcnt lgkmcnt(7)
		v_mfma_f32_16x16x32_f16 v[108:111], v[88:91], v[40:43], v[108:111]
		s_waitcnt lgkmcnt(3)
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[40:43], v[112:115]
		v_mfma_f32_16x16x32_f16 v[128:131], v[96:99], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[116:119], v[72:75], v[48:51], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[80:83], v[48:51], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[88:91], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[88:91], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[72:75], v[56:59], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[80:83], v[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[144:147], v[96:99], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[96:99], v[64:67], v[160:163]
		v_mfma_f32_16x16x32_f16 v[148:151], v[72:75], v[64:67], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[80:83], v[64:67], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[88:91], v[64:67], v[156:159]
		v_mfma_f32_16x16x32_f16 v[4:7], v[76:79], v[44:47], v[4:7]
		v_mfma_f32_16x16x32_f16 v[104:107], v[84:87], v[44:47], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[92:95], v[44:47], v[108:111]
		s_waitcnt lgkmcnt(1)
		v_mfma_f32_16x16x32_f16 v[112:115], v[100:103], v[44:47], v[112:115]
		v_mfma_f32_16x16x32_f16 v[128:131], v[100:103], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[116:119], v[76:79], v[52:55], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[84:87], v[52:55], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[92:95], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[92:95], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[76:79], v[60:63], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[84:87], v[60:63], v[136:139]
		v_mfma_f32_16x16x32_f16 v[144:147], v[100:103], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[100:103], v[68:71], v[160:163]
		v_mfma_f32_16x16x32_f16 v[148:151], v[76:79], v[68:71], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[84:87], v[68:71], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[92:95], v[68:71], v[156:159]
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s2, v2
		s_and_b32 s2, s2, -8
		s_add_i32 s2, s2, 8
		s_and_saveexec_b64 s[4:5], s[14:15]
.Lv9_beyond_hotloop.loop_head_6:
		ds_read_b32 v2, v10
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s3, v2
		s_xor_b32 s6, s2, -1
		s_add_i32 s6, s6, 1
		s_add_i32 s3, s3, s6
		s_cmp_ge_u32 s3, 0x80000000
		s_cbranch_scc1 .Lv9_beyond_hotloop.loop_head_6
.Lv9_beyond_hotloop.loop_exit_6:
		s_mov_b64 exec, s[4:5]
		ds_read_b64_tr_b16 v[72:73], v32 offset:35712
		ds_read_b64_tr_b16 v[74:75], v32 offset:36768
		ds_read_b64_tr_b16 v[76:77], v32 offset:44160
		ds_read_b64_tr_b16 v[78:79], v32 offset:45216
		ds_read_b64_tr_b16 v[80:81], v32 offset:35776
		ds_read_b64_tr_b16 v[82:83], v32 offset:36832
		ds_read_b64_tr_b16 v[84:85], v32 offset:44224
		ds_read_b64_tr_b16 v[86:87], v32 offset:45280
		ds_read_b64_tr_b16 v[88:89], v32 offset:35840
		ds_read_b64_tr_b16 v[90:91], v32 offset:36896
		ds_read_b64_tr_b16 v[92:93], v32 offset:44288
		ds_read_b64_tr_b16 v[94:95], v32 offset:45344
		ds_read_b64_tr_b16 v[96:97], v32 offset:35904
		ds_read_b64_tr_b16 v[98:99], v32 offset:36960
		ds_read_b64_tr_b16 v[100:101], v32 offset:44352
		ds_read_b64_tr_b16 v[102:103], v32 offset:45408
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[164:167], v[72:75], v[40:43], v[164:167]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[168:171], v[80:83], v[40:43], v[168:171]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[172:175], v[88:91], v[40:43], v[172:175]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[176:179], v[96:99], v[40:43], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[96:99], v[48:51], v[192:195]
		v_mfma_f32_16x16x32_f16 v[180:183], v[72:75], v[48:51], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[80:83], v[48:51], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[88:91], v[48:51], v[188:191]
		v_mfma_f32_16x16x32_f16 v[204:207], v[88:91], v[56:59], v[204:207]
		v_mfma_f32_16x16x32_f16 v[196:199], v[72:75], v[56:59], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[80:83], v[56:59], v[200:203]
		v_mfma_f32_16x16x32_f16 v[208:211], v[96:99], v[56:59], v[208:211]
		v_mfma_f32_16x16x32_f16 v[224:227], v[96:99], v[64:67], v[224:227]
		v_mfma_f32_16x16x32_f16 v[212:215], v[72:75], v[64:67], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], v[80:83], v[64:67], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], v[88:91], v[64:67], v[220:223]
		v_mfma_f32_16x16x32_f16 v[164:167], v[76:79], v[44:47], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[84:87], v[44:47], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[92:95], v[44:47], v[172:175]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[176:179], v[100:103], v[44:47], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[100:103], v[52:55], v[192:195]
		v_mfma_f32_16x16x32_f16 v[180:183], v[76:79], v[52:55], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[84:87], v[52:55], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[92:95], v[52:55], v[188:191]
		v_mfma_f32_16x16x32_f16 v[204:207], v[92:95], v[60:63], v[204:207]
		v_mfma_f32_16x16x32_f16 v[196:199], v[76:79], v[60:63], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[84:87], v[60:63], v[200:203]
		v_mfma_f32_16x16x32_f16 v[208:211], v[100:103], v[60:63], v[208:211]
		v_mfma_f32_16x16x32_f16 v[224:227], v[100:103], v[68:71], v[224:227]
		v_mfma_f32_16x16x32_f16 v[212:215], v[76:79], v[68:71], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], v[84:87], v[68:71], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], v[92:95], v[68:71], v[220:223]
		ds_read_b128 v[40:43], v1 offset:33760
		ds_read_b128 v[44:47], v1 offset:33824
		ds_read_b128 v[48:51], v1 offset:42208
		ds_read_b128 v[52:55], v1 offset:42272
		ds_read_b128 v[56:59], v1 offset:50656
		ds_read_b128 v[60:63], v1 offset:50720
		ds_read_b128 v[64:67], v1 offset:59104
		ds_read_b128 v[68:71], v1 offset:59168
		ds_read_b64_tr_b16 v[72:73], v32 offset:18848
		ds_read_b64_tr_b16 v[74:75], v32 offset:19904
		ds_read_b64_tr_b16 v[76:77], v32 offset:27296
		ds_read_b64_tr_b16 v[78:79], v32 offset:28352
		ds_read_b64_tr_b16 v[80:81], v32 offset:18912
		ds_read_b64_tr_b16 v[82:83], v32 offset:19968
		ds_read_b64_tr_b16 v[84:85], v32 offset:27360
		ds_read_b64_tr_b16 v[86:87], v32 offset:28416
		ds_read_b64_tr_b16 v[88:89], v32 offset:18976
		ds_read_b64_tr_b16 v[90:91], v32 offset:20032
		ds_read_b64_tr_b16 v[92:93], v32 offset:27424
		ds_read_b64_tr_b16 v[94:95], v32 offset:28480
		ds_read_b64_tr_b16 v[96:97], v32 offset:19040
		ds_read_b64_tr_b16 v[98:99], v32 offset:20096
		ds_read_b64_tr_b16 v[100:101], v32 offset:27488
		ds_read_b64_tr_b16 v[102:103], v32 offset:28544
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[4:7], v[72:75], v[40:43], v[4:7]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[104:107], v[80:83], v[40:43], v[104:107]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[108:111], v[88:91], v[40:43], v[108:111]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[112:115], v[96:99], v[40:43], v[112:115]
		v_mfma_f32_16x16x32_f16 v[128:131], v[96:99], v[48:51], v[128:131]
		v_mfma_f32_16x16x32_f16 v[116:119], v[72:75], v[48:51], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[80:83], v[48:51], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[88:91], v[48:51], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[88:91], v[56:59], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[72:75], v[56:59], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[80:83], v[56:59], v[136:139]
		v_mfma_f32_16x16x32_f16 v[144:147], v[96:99], v[56:59], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[96:99], v[64:67], v[160:163]
		v_mfma_f32_16x16x32_f16 v[148:151], v[72:75], v[64:67], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[80:83], v[64:67], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[88:91], v[64:67], v[156:159]
		v_mfma_f32_16x16x32_f16 v[4:7], v[76:79], v[44:47], v[4:7]
		v_mfma_f32_16x16x32_f16 v[104:107], v[84:87], v[44:47], v[104:107]
		v_mfma_f32_16x16x32_f16 v[108:111], v[92:95], v[44:47], v[108:111]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[112:115], v[100:103], v[44:47], v[112:115]
		v_mfma_f32_16x16x32_f16 v[128:131], v[100:103], v[52:55], v[128:131]
		v_mfma_f32_16x16x32_f16 v[116:119], v[76:79], v[52:55], v[116:119]
		v_mfma_f32_16x16x32_f16 v[120:123], v[84:87], v[52:55], v[120:123]
		v_mfma_f32_16x16x32_f16 v[124:127], v[92:95], v[52:55], v[124:127]
		v_mfma_f32_16x16x32_f16 v[140:143], v[92:95], v[60:63], v[140:143]
		v_mfma_f32_16x16x32_f16 v[132:135], v[76:79], v[60:63], v[132:135]
		v_mfma_f32_16x16x32_f16 v[136:139], v[84:87], v[60:63], v[136:139]
		v_mfma_f32_16x16x32_f16 v[144:147], v[100:103], v[60:63], v[144:147]
		v_mfma_f32_16x16x32_f16 v[160:163], v[100:103], v[68:71], v[160:163]
		v_mfma_f32_16x16x32_f16 v[148:151], v[76:79], v[68:71], v[148:151]
		v_mfma_f32_16x16x32_f16 v[152:155], v[84:87], v[68:71], v[152:155]
		v_mfma_f32_16x16x32_f16 v[156:159], v[92:95], v[68:71], v[156:159]
		ds_read_b64_tr_b16 v[72:73], v32 offset:52576
		ds_read_b64_tr_b16 v[74:75], v32 offset:53632
		ds_read_b64_tr_b16 v[76:77], v32 offset:61024
		ds_read_b64_tr_b16 v[78:79], v32 offset:62080
		ds_read_b64_tr_b16 v[80:81], v32 offset:52640
		ds_read_b64_tr_b16 v[82:83], v32 offset:53696
		ds_read_b64_tr_b16 v[84:85], v32 offset:61088
		ds_read_b64_tr_b16 v[86:87], v32 offset:62144
		ds_read_b64_tr_b16 v[88:89], v32 offset:52704
		ds_read_b64_tr_b16 v[90:91], v32 offset:53760
		ds_read_b64_tr_b16 v[92:93], v32 offset:61152
		ds_read_b64_tr_b16 v[94:95], v32 offset:62208
		ds_read_b64_tr_b16 v[96:97], v32 offset:52768
		ds_read_b64_tr_b16 v[98:99], v32 offset:53824
		ds_read_b64_tr_b16 v[100:101], v32 offset:61216
		ds_read_b64_tr_b16 v[102:103], v32 offset:62272
		v_cvt_pk_f16_f32 v2, v4, v5
		v_cvt_pk_f16_f32 v3, v6, v7
		v_cvt_pk_f16_f32 v4, v104, v105
		v_cvt_pk_f16_f32 v5, v106, v107
		v_cvt_pk_f16_f32 v6, v108, v109
		v_cvt_pk_f16_f32 v7, v110, v111
		v_cvt_pk_f16_f32 v8, v112, v113
		v_cvt_pk_f16_f32 v9, v114, v115
		v_cvt_pk_f16_f32 v30, v116, v117
		v_cvt_pk_f16_f32 v31, v118, v119
		v_cvt_pk_f16_f32 v34, v120, v121
		v_cvt_pk_f16_f32 v35, v122, v123
		v_cvt_pk_f16_f32 v38, v124, v125
		v_cvt_pk_f16_f32 v39, v126, v127
		v_cvt_pk_f16_f32 v104, v128, v129
		v_cvt_pk_f16_f32 v105, v130, v131
		v_cvt_pk_f16_f32 v106, v132, v133
		v_cvt_pk_f16_f32 v107, v134, v135
		v_cvt_pk_f16_f32 v108, v136, v137
		v_cvt_pk_f16_f32 v109, v138, v139
		v_cvt_pk_f16_f32 v110, v140, v141
		v_cvt_pk_f16_f32 v111, v142, v143
		v_cvt_pk_f16_f32 v112, v144, v145
		v_cvt_pk_f16_f32 v113, v146, v147
		v_cvt_pk_f16_f32 v114, v148, v149
		v_cvt_pk_f16_f32 v115, v150, v151
		v_cvt_pk_f16_f32 v116, v152, v153
		v_cvt_pk_f16_f32 v117, v154, v155
		v_cvt_pk_f16_f32 v118, v156, v157
		v_cvt_pk_f16_f32 v119, v158, v159
		v_cvt_pk_f16_f32 v120, v160, v161
		v_cvt_pk_f16_f32 v121, v162, v163
		v_cmp_lt_i32_e64 vcc, v19, s8
		s_mov_b64 s[2:3], vcc
		v_cmp_lt_i32_e64 vcc, v11, s8
		s_mov_b64 s[4:5], vcc
		v_cmp_lt_i32_e64 vcc, v17, s8
		s_mov_b64 s[6:7], vcc
		v_cmp_lt_i32_e64 vcc, v18, s8
		s_mov_b64 s[10:11], vcc
		v_cmp_lt_i32_e64 vcc, v25, s9
		s_mov_b64 s[14:15], vcc
		v_cmp_lt_i32_e64 vcc, v26, s9
		s_mov_b64 s[18:19], vcc
		v_cmp_lt_i32_e64 vcc, v27, s9
		s_mov_b64 s[20:21], vcc
		v_cmp_lt_i32_e64 vcc, v28, s9
		s_mov_b64 s[22:23], vcc
		s_and_b32 s28, s2, s14
		s_and_b32 s29, s3, s15
		s_mul_i32 s8, s1, s12
		s_lshl_b32 s8, s8, 11
		s_add_i32 s16, s0, s8
		s_mul_i32 s30, s17, s12
		s_lshl_b32 s30, s30, 9
		s_add_i32 s16, s16, s30
		v_mul_lo_u32 v1, s12, v16
		v_lshl_add_u32 v10, v1, 6, s16
		v_and_b32_e32 v11, 1, v0
		v_mul_lo_u32 v17, s12, v11
		v_lshlrev_b32_e32 v17, 1, v17
		v_mul_lo_u32 v18, s12, v37
		v_lshlrev_b32_e32 v18, 5, v18
		v_add3_u32 v10, v10, v17, v18
		v_and_b32_e32 v14, 1, v14
		v_mul_lo_u32 v19, s12, v14
		v_lshlrev_b32_e32 v19, 4, v19
		v_and_b32_e32 v13, 1, v13
		v_mul_lo_u32 v25, s12, v13
		v_lshlrev_b32_e32 v25, 3, v25
		v_add3_u32 v10, v10, v19, v25
		v_and_b32_e32 v12, 1, v12
		v_mul_lo_u32 v26, s12, v12
		v_lshlrev_b32_e32 v26, 2, v26
		v_add3_u32 v10, v10, v26, v36
		v_lshrrev_b32_e32 v0, 5, v0
		v_and_b32_e32 v0, 1, v0
		v_lshlrev_b32_e32 v27, 4, v0
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v28, 3, v20
		v_add3_u32 v10, v10, v27, v28
		v_mov_b32_e32 v29, 0x80000000
		v_cndmask_b32_e64 v10, v29, v10, s[28:29]
		buffer_store_dwordx2 v[2:3], v10, s[24:27], 0 offen
		s_and_b32 s28, s2, s18
		s_and_b32 s29, s3, s19
		v_mul_lo_u32 v2, s12, v15
		v_lshlrev_b32_e32 v2, 5, v2
		v_add_u32_e32 v3, s16, v2
		v_add3_u32 v3, v3, v17, v19
		v_add3_u32 v3, v3, v25, v26
		v_lshlrev_b32_e32 v10, 4, v33
		v_lshlrev_b32_e32 v15, 2, v20
		v_add_u32_e32 v20, 32, v15
		v_lshlrev_b32_e32 v0, 3, v0
		v_xor_b32_e32 v20, v20, v0
		v_xor_b32_e32 v20, v10, v20
		v_lshl_add_u32 v32, v20, 1, v3
		v_cndmask_b32_e64 v32, v29, v32, s[28:29]
		buffer_store_dwordx2 v[4:5], v32, s[24:27], 0 offen
		s_and_b32 s28, s2, s20
		s_and_b32 s29, s3, s21
		v_add_u32_e32 v4, 64, v15
		v_xor_b32_e32 v4, v4, v0
		v_xor_b32_e32 v4, v10, v4
		v_lshl_add_u32 v3, v4, 1, v3
		v_cndmask_b32_e64 v3, v29, v3, s[28:29]
		buffer_store_dwordx2 v[6:7], v3, s[24:27], 0 offen
		s_and_b32 s28, s2, s22
		s_and_b32 s29, s3, s23
		s_mul_i32 s1, s12, s1
		s_lshl_b32 s1, s1, 11
		s_add_i32 s0, s0, s1
		s_mul_i32 s17, s12, s17
		s_lshl_b32 s17, s17, 9
		s_add_i32 s0, s0, s17
		v_add3_u32 v3, s0, v2, v17
		v_add3_u32 v3, v3, v19, v25
		v_add_u32_e32 v5, 0x60, v15
		v_xor_b32_e32 v0, v5, v0
		v_xor_b32_e32 v0, v10, v0
		v_lshlrev_b32_e32 v0, 1, v0
		v_add3_u32 v3, v3, v26, v0
		v_cndmask_b32_e64 v3, v29, v3, s[28:29]
		buffer_store_dwordx2 v[8:9], v3, s[24:27], 0 offen
		s_and_b32 s28, s4, s14
		s_and_b32 s29, s5, s15
		v_lshlrev_b32_e32 v3, 5, v16
		v_lshlrev_b32_e32 v5, 4, v37
		v_lshlrev_b32_e32 v6, 3, v14
		v_lshlrev_b32_e32 v7, 2, v13
		v_add_u32_e32 v8, 64, v11
		v_lshlrev_b32_e32 v9, 1, v12
		v_xor_b32_e32 v8, v8, v9
		v_xor_b32_e32 v8, v7, v8
		v_xor_b32_e32 v8, v6, v8
		v_xor_b32_e32 v8, v5, v8
		v_xor_b32_e32 v8, v3, v8
		v_mul_lo_u32 v8, s12, v8
		v_lshlrev_b32_e32 v8, 1, v8
		v_add_u32_e32 v10, s16, v8
		v_add_u32_e32 v12, v10, v36
		v_add3_u32 v12, v12, v27, v28
		v_cndmask_b32_e64 v12, v29, v12, s[28:29]
		buffer_store_dwordx2 v[30:31], v12, s[24:27], 0 offen
		s_and_b32 s28, s4, s18
		s_and_b32 s29, s5, s19
		v_lshl_add_u32 v12, v20, 1, v10
		v_cndmask_b32_e64 v12, v29, v12, s[28:29]
		buffer_store_dwordx2 v[34:35], v12, s[24:27], 0 offen
		s_and_b32 s28, s4, s20
		s_and_b32 s29, s5, s21
		v_lshl_add_u32 v10, v4, 1, v10
		v_cndmask_b32_e64 v10, v29, v10, s[28:29]
		buffer_store_dwordx2 v[38:39], v10, s[24:27], 0 offen
		s_and_b32 s28, s4, s22
		s_and_b32 s29, s5, s23
		v_add3_u32 v10, s0, v8, v0
		v_cndmask_b32_e64 v10, v29, v10, s[28:29]
		buffer_store_dwordx2 v[104:105], v10, s[24:27], 0 offen
		s_and_b32 s28, s6, s14
		s_and_b32 s29, s7, s15
		v_add_u32_e32 v10, 0x80, v11
		v_xor_b32_e32 v10, v10, v9
		v_xor_b32_e32 v10, v7, v10
		v_xor_b32_e32 v10, v6, v10
		v_xor_b32_e32 v10, v5, v10
		v_xor_b32_e32 v10, v3, v10
		v_mul_lo_u32 v10, s12, v10
		v_lshlrev_b32_e32 v10, 1, v10
		v_add_u32_e32 v12, s16, v10
		v_add_u32_e32 v13, v12, v36
		v_add3_u32 v13, v13, v27, v28
		v_cndmask_b32_e64 v13, v29, v13, s[28:29]
		buffer_store_dwordx2 v[106:107], v13, s[24:27], 0 offen
		s_and_b32 s28, s6, s18
		s_and_b32 s29, s7, s19
		v_lshl_add_u32 v13, v20, 1, v12
		v_cndmask_b32_e64 v13, v29, v13, s[28:29]
		buffer_store_dwordx2 v[108:109], v13, s[24:27], 0 offen
		s_and_b32 s28, s6, s20
		s_and_b32 s29, s7, s21
		v_lshl_add_u32 v12, v4, 1, v12
		v_cndmask_b32_e64 v12, v29, v12, s[28:29]
		buffer_store_dwordx2 v[110:111], v12, s[24:27], 0 offen
		s_and_b32 s28, s6, s22
		s_and_b32 s29, s7, s23
		v_add3_u32 v12, s0, v10, v0
		v_cndmask_b32_e64 v12, v29, v12, s[28:29]
		buffer_store_dwordx2 v[112:113], v12, s[24:27], 0 offen
		s_and_b32 s28, s10, s14
		s_and_b32 s29, s11, s15
		v_add_u32_e32 v11, 0xc0, v11
		v_xor_b32_e32 v9, v11, v9
		v_xor_b32_e32 v7, v7, v9
		v_xor_b32_e32 v6, v6, v7
		v_xor_b32_e32 v5, v5, v6
		v_xor_b32_e32 v3, v3, v5
		v_mul_lo_u32 v3, s12, v3
		v_lshl_add_u32 v5, v3, 1, s0
		v_add_u32_e32 v6, v5, v36
		v_add3_u32 v6, v6, v27, v28
		v_cndmask_b32_e64 v6, v29, v6, s[28:29]
		buffer_store_dwordx2 v[114:115], v6, s[24:27], 0 offen
		s_and_b32 s14, s10, s18
		s_and_b32 s15, s11, s19
		v_lshl_add_u32 v6, v20, 1, v5
		v_cndmask_b32_e64 v6, v29, v6, s[14:15]
		buffer_store_dwordx2 v[116:117], v6, s[24:27], 0 offen
		s_and_b32 s14, s10, s20
		s_and_b32 s15, s11, s21
		v_lshl_add_u32 v6, v4, 1, v5
		v_cndmask_b32_e64 v6, v29, v6, s[14:15]
		buffer_store_dwordx2 v[118:119], v6, s[24:27], 0 offen
		s_and_b32 s14, s10, s22
		s_and_b32 s15, s11, s23
		v_add_u32_e32 v5, v5, v0
		v_cndmask_b32_e64 v5, v29, v5, s[14:15]
		buffer_store_dwordx2 v[120:121], v5, s[24:27], 0 offen
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_16x16x32_f16 v[164:167], v[72:75], v[40:43], v[164:167]
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_16x16x32_f16 v[168:171], v[80:83], v[40:43], v[168:171]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_16x16x32_f16 v[172:175], v[88:91], v[40:43], v[172:175]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_16x16x32_f16 v[176:179], v[96:99], v[40:43], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[96:99], v[48:51], v[192:195]
		v_mfma_f32_16x16x32_f16 v[180:183], v[72:75], v[48:51], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[80:83], v[48:51], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[88:91], v[48:51], v[188:191]
		v_mfma_f32_16x16x32_f16 v[204:207], v[88:91], v[56:59], v[204:207]
		v_mfma_f32_16x16x32_f16 v[196:199], v[72:75], v[56:59], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[80:83], v[56:59], v[200:203]
		v_mfma_f32_16x16x32_f16 v[208:211], v[96:99], v[56:59], v[208:211]
		v_mfma_f32_16x16x32_f16 v[224:227], v[96:99], v[64:67], v[224:227]
		v_mfma_f32_16x16x32_f16 v[212:215], v[72:75], v[64:67], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], v[80:83], v[64:67], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], v[88:91], v[64:67], v[220:223]
		v_mfma_f32_16x16x32_f16 v[164:167], v[76:79], v[44:47], v[164:167]
		v_mfma_f32_16x16x32_f16 v[168:171], v[84:87], v[44:47], v[168:171]
		v_mfma_f32_16x16x32_f16 v[172:175], v[92:95], v[44:47], v[172:175]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_16x16x32_f16 v[176:179], v[100:103], v[44:47], v[176:179]
		v_mfma_f32_16x16x32_f16 v[192:195], v[100:103], v[52:55], v[192:195]
		v_mfma_f32_16x16x32_f16 v[180:183], v[76:79], v[52:55], v[180:183]
		v_mfma_f32_16x16x32_f16 v[184:187], v[84:87], v[52:55], v[184:187]
		v_mfma_f32_16x16x32_f16 v[188:191], v[92:95], v[52:55], v[188:191]
		v_mfma_f32_16x16x32_f16 v[204:207], v[92:95], v[60:63], v[204:207]
		v_mfma_f32_16x16x32_f16 v[196:199], v[76:79], v[60:63], v[196:199]
		v_mfma_f32_16x16x32_f16 v[200:203], v[84:87], v[60:63], v[200:203]
		v_mfma_f32_16x16x32_f16 v[208:211], v[100:103], v[60:63], v[208:211]
		v_mfma_f32_16x16x32_f16 v[224:227], v[100:103], v[68:71], v[224:227]
		v_mfma_f32_16x16x32_f16 v[212:215], v[76:79], v[68:71], v[212:215]
		v_mfma_f32_16x16x32_f16 v[216:219], v[84:87], v[68:71], v[216:219]
		v_mfma_f32_16x16x32_f16 v[220:223], v[92:95], v[68:71], v[220:223]
		v_cvt_pk_f16_f32 v6, v164, v165
		v_cvt_pk_f16_f32 v7, v166, v167
		v_cvt_pk_f16_f32 v12, v168, v169
		v_cvt_pk_f16_f32 v13, v170, v171
		v_cvt_pk_f16_f32 v14, v172, v173
		v_cvt_pk_f16_f32 v15, v174, v175
		v_cvt_pk_f16_f32 v30, v176, v177
		v_cvt_pk_f16_f32 v31, v178, v179
		v_cvt_pk_f16_f32 v32, v180, v181
		v_cvt_pk_f16_f32 v33, v182, v183
		v_cvt_pk_f16_f32 v34, v184, v185
		v_cvt_pk_f16_f32 v35, v186, v187
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
		v_cvt_pk_f16_f32 v50, v212, v213
		v_cvt_pk_f16_f32 v51, v214, v215
		v_cvt_pk_f16_f32 v52, v216, v217
		v_cvt_pk_f16_f32 v53, v218, v219
		v_cvt_pk_f16_f32 v54, v220, v221
		v_cvt_pk_f16_f32 v55, v222, v223
		v_cvt_pk_f16_f32 v56, v224, v225
		v_cvt_pk_f16_f32 v57, v226, v227
		s_add_i32 s0, s13, 0x80
		v_add_u32_e32 v5, s0, v22
		v_add_u32_e32 v9, s0, v21
		v_add_u32_e32 v11, s0, v23
		v_add_u32_e32 v16, s0, v24
		v_cmp_lt_i32_e64 vcc, v5, s9
		s_mov_b64 s[12:13], vcc
		v_cmp_lt_i32_e64 vcc, v9, s9
		s_mov_b64 s[14:15], vcc
		v_cmp_lt_i32_e64 vcc, v11, s9
		s_mov_b64 s[18:19], vcc
		v_cmp_lt_i32_e64 vcc, v16, s9
		s_mov_b64 s[20:21], vcc
		s_and_b32 s22, s2, s12
		s_and_b32 s23, s3, s13
		s_add_i32 s0, s32, s8
		s_add_i32 s0, s0, s30
		v_lshl_add_u32 v1, v1, 6, s0
		v_add3_u32 v1, v1, v17, v18
		v_add3_u32 v1, v1, v19, v25
		v_add3_u32 v1, v1, v26, v36
		v_add3_u32 v1, v1, v27, v28
		v_cndmask_b32_e64 v1, v29, v1, s[22:23]
		buffer_store_dwordx2 v[6:7], v1, s[24:27], 0 offen
		s_and_b32 s8, s2, s14
		s_and_b32 s9, s3, s15
		v_add_u32_e32 v1, s0, v2
		v_add3_u32 v1, v1, v17, v19
		v_add3_u32 v1, v1, v25, v26
		v_lshl_add_u32 v5, v20, 1, v1
		v_cndmask_b32_e64 v5, v29, v5, s[8:9]
		buffer_store_dwordx2 v[12:13], v5, s[24:27], 0 offen
		s_and_b32 s8, s2, s18
		s_and_b32 s9, s3, s19
		v_lshl_add_u32 v1, v4, 1, v1
		v_cndmask_b32_e64 v1, v29, v1, s[8:9]
		buffer_store_dwordx2 v[14:15], v1, s[24:27], 0 offen
		s_and_b32 s8, s2, s20
		s_and_b32 s9, s3, s21
		s_add_i32 s1, s32, s1
		s_add_i32 s1, s1, s17
		v_add3_u32 v1, s1, v2, v17
		v_add3_u32 v1, v1, v19, v25
		v_add3_u32 v1, v1, v26, v0
		v_cndmask_b32_e64 v1, v29, v1, s[8:9]
		buffer_store_dwordx2 v[30:31], v1, s[24:27], 0 offen
		s_and_b32 s2, s4, s12
		s_and_b32 s3, s5, s13
		v_add_u32_e32 v1, s0, v8
		v_add_u32_e32 v2, v1, v36
		v_add3_u32 v2, v2, v27, v28
		v_cndmask_b32_e64 v2, v29, v2, s[2:3]
		buffer_store_dwordx2 v[32:33], v2, s[24:27], 0 offen
		s_and_b32 s2, s4, s14
		s_and_b32 s3, s5, s15
		v_lshl_add_u32 v2, v20, 1, v1
		v_cndmask_b32_e64 v2, v29, v2, s[2:3]
		buffer_store_dwordx2 v[34:35], v2, s[24:27], 0 offen
		s_and_b32 s2, s4, s18
		s_and_b32 s3, s5, s19
		v_lshl_add_u32 v1, v4, 1, v1
		v_cndmask_b32_e64 v1, v29, v1, s[2:3]
		buffer_store_dwordx2 v[38:39], v1, s[24:27], 0 offen
		s_and_b32 s2, s4, s20
		s_and_b32 s3, s5, s21
		v_add3_u32 v1, s1, v8, v0
		v_cndmask_b32_e64 v1, v29, v1, s[2:3]
		buffer_store_dwordx2 v[40:41], v1, s[24:27], 0 offen
		s_and_b32 s2, s6, s12
		s_and_b32 s3, s7, s13
		v_add_u32_e32 v1, s0, v10
		v_add_u32_e32 v2, v1, v36
		v_add3_u32 v2, v2, v27, v28
		v_cndmask_b32_e64 v2, v29, v2, s[2:3]
		buffer_store_dwordx2 v[42:43], v2, s[24:27], 0 offen
		s_and_b32 s2, s6, s14
		s_and_b32 s3, s7, s15
		v_lshl_add_u32 v2, v20, 1, v1
		v_cndmask_b32_e64 v2, v29, v2, s[2:3]
		buffer_store_dwordx2 v[44:45], v2, s[24:27], 0 offen
		s_and_b32 s2, s6, s18
		s_and_b32 s3, s7, s19
		v_lshl_add_u32 v1, v4, 1, v1
		v_cndmask_b32_e64 v1, v29, v1, s[2:3]
		buffer_store_dwordx2 v[46:47], v1, s[24:27], 0 offen
		s_and_b32 s2, s6, s20
		s_and_b32 s3, s7, s21
		v_add3_u32 v1, s1, v10, v0
		v_cndmask_b32_e64 v1, v29, v1, s[2:3]
		buffer_store_dwordx2 v[48:49], v1, s[24:27], 0 offen
		s_and_b32 s2, s10, s12
		s_and_b32 s3, s11, s13
		v_lshl_add_u32 v1, v3, 1, s1
		v_add_u32_e32 v2, v1, v36
		v_add3_u32 v2, v2, v27, v28
		v_cndmask_b32_e64 v2, v29, v2, s[2:3]
		buffer_store_dwordx2 v[50:51], v2, s[24:27], 0 offen
		s_and_b32 s0, s10, s14
		s_and_b32 s1, s11, s15
		v_lshl_add_u32 v2, v20, 1, v1
		v_cndmask_b32_e64 v2, v29, v2, s[0:1]
		buffer_store_dwordx2 v[52:53], v2, s[24:27], 0 offen
		s_and_b32 s0, s10, s18
		s_and_b32 s1, s11, s19
		v_lshl_add_u32 v2, v4, 1, v1
		v_cndmask_b32_e64 v2, v29, v2, s[0:1]
		buffer_store_dwordx2 v[54:55], v2, s[24:27], 0 offen
		s_and_b32 s0, s10, s20
		s_and_b32 s1, s11, s21
		v_add_u32_e32 v0, v1, v0
		v_cndmask_b32_e64 v0, v29, v0, s[0:1]
		buffer_store_dwordx2 v[56:57], v0, s[24:27], 0 offen
		s_waitcnt vmcnt(0)
		s_endpgm
	.size	v9_beyond_hotloop, .-v9_beyond_hotloop
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel v9_beyond_hotloop
		.amdhsa_group_segment_fixed_size 135008
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
		.amdhsa_next_free_vgpr 228
		.amdhsa_next_free_sgpr 45
		.amdhsa_accum_offset 228
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
	.set .Lv9_beyond_hotloop.num_vgpr, 228
	.set .Lv9_beyond_hotloop.num_agpr, 0
	.set .Lv9_beyond_hotloop.numbered_sgpr, 45
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
    .group_segment_fixed_size: 135008
    .kernarg_segment_align: 8
    .kernarg_segment_size: 48
    .max_flat_workgroup_size: 512
    .name:           v9_beyond_hotloop
    .private_segment_fixed_size: 0
    .sgpr_count:     45
    .sgpr_spill_count: 0
    .symbol:         v9_beyond_hotloop.kd
    .uses_dynamic_stack: false
    .vgpr_count:     228
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
