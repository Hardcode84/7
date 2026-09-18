	.text
	.amdgcn_target "amdgcn-amd-amdhsa--gfx950"
	.amdhsa_code_object_version 6

	.globl	_attn_fwd_async_prefetch
	.p2align	8
	.type	_attn_fwd_async_prefetch,@function
_attn_fwd_async_prefetch:
		s_load_dwordx2 s[2:3], s[0:1], 0x0
		s_load_dwordx2 s[4:5], s[0:1], 0x8
		s_load_dwordx2 s[6:7], s[0:1], 0x10
		s_load_dwordx2 s[8:9], s[0:1], 0x18
		s_load_dwordx2 s[10:11], s[0:1], 0x20
		s_load_dwordx2 s[12:13], s[0:1], 0x28
		s_load_dwordx2 s[14:15], s[0:1], 0x30
		s_waitcnt lgkmcnt(0)
		s_branch .L_attn_fwd_async_prefetch.kernarg_preload_entry
	.p2align	8
.L_attn_fwd_async_prefetch.kernarg_preload_entry:
	; wave backend: WaveAMDMachine MLIR pipeline finalized
		s_load_dword s18, s[0:1], 0x38
		s_load_dword s19, s[0:1], 0x3c
		s_load_dword s20, s[0:1], 0x40
		s_load_dword s21, s[0:1], 0x44
		s_load_dword s22, s[0:1], 0x48
		s_load_dword s23, s[0:1], 0x4c
		s_load_dword s24, s[0:1], 0x54
		s_load_dword s25, s[0:1], 0x58
		s_ashr_i32 s0, s17, 31
		s_xor_b32 s1, s17, s0
		s_sub_i32 s1, s1, s0
		s_waitcnt lgkmcnt(0)
		s_ashr_i32 s17, s24, 31
		s_xor_b32 s24, s24, s17
		s_sub_i32 s24, s24, s17
		s_xor_b32 s17, s0, s17
		v_mov_b32_e32 v1, s24
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		v_mov_b32_e32 v2, 0x4f7ffffe
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_mov_b32 s26, 0
		v_readfirstlane_b32 s27, v1
		s_sub_i32 s28, s26, s24
		s_mul_i32 s28, s28, s27
		s_mul_hi_u32 s28, s27, s28
		s_add_i32 s27, s27, s28
		s_mul_hi_u32 s27, s1, s27
		s_mul_i32 s28, s27, s24
		s_sub_i32 s1, s1, s28
		s_add_i32 s28, s27, 1
		s_sub_i32 s29, s1, s24
		s_cmp_ge_u32 s1, s24
		s_cselect_b32 s27, s28, s27
		s_cselect_b32 s1, s29, s1
		s_add_i32 s28, s27, 1
		s_cmp_ge_u32 s1, s24
		s_cselect_b32 s27, s28, s27
		s_cselect_b32 s28, 1, 0
		s_xor_b32 s27, s27, s17
		s_sub_i32 s17, s27, s17
		s_sub_i32 s24, s1, s24
		s_cmp_lg_u32 s28, 0
		s_cselect_b32 s1, s24, s1
		s_xor_b32 s1, s1, s0
		s_sub_i32 s0, s1, s0
		s_mul_i32 s1, s16, 0x100
		v_lshrrev_b32_e32 v1, 4, v0
		v_and_b32_e32 v2, 1, v1
		v_lshrrev_b32_e32 v3, 6, v0
		v_and_b32_e32 v3, 1, v3
		v_lshrrev_b32_e32 v4, 7, v0
		v_and_b32_e32 v4, 1, v4
		v_lshrrev_b32_e32 v5, 5, v0
		v_and_b32_e32 v6, 1, v5
		v_mov_b32_e32 v7, 2
		v_mul_lo_u32 v7, v7, v6
		v_mov_b32_e32 v8, 4
		v_mul_lo_u32 v8, v8, v3
		v_bitop3_b32 v9, v2, v7, v8 bitop3:0x96
		v_mov_b32_e32 v10, 8
		v_mul_lo_u32 v10, v10, v4
		v_xad_u32 v9, v9, v10, s1
		v_readfirstlane_b32 s24, v0
		v_cmp_lt_i32_e64 s[28:29], v9, s25
		s_mov_b32 s34, 0x7fffffff
		s_mov_b32 s35, 0x31016000
		s_mov_b32 s32, s4
		s_mov_b32 s33, s5
		s_mov_b32 s36, s6
		s_mov_b32 s37, s7
		s_mov_b32 s38, s34
		s_mov_b32 s39, s35
		s_mul_i32 s4, s16, s12
		s_lshl_b32 s4, s4, 9
		s_mul_i32 s5, s17, s10
		s_lshl_b32 s5, s5, 1
		s_add_i32 s6, s4, s5
		s_mul_i32 s7, s0, s11
		s_lshl_b32 s7, s7, 1
		s_add_i32 s6, s6, s7
		v_mul_lo_u32 v9, s12, v1
		v_lshlrev_b32_e32 v9, 1, v9
		v_and_b32_e32 v11, 15, v0
		v_lshlrev_b32_e32 v11, 4, v11
		v_add3_u32 v12, s6, v9, v11
		v_mov_b32_e32 v13, 0x7fffffff
		v_cndmask_b32_e64 v12, v13, v12, s[28:29]
		s_mov_b32 s28, s2
		s_mov_b32 s29, s3
		s_mov_b32 s30, s34
		s_mov_b32 s31, s35
		buffer_load_dwordx4 v[16:19], v12, s[28:31], 0 offen
		v_bitop3_b32 v12, 16, v2, v7 bitop3:0x96
		v_xor_b32_e32 v12, v12, v8
		v_xad_u32 v12, v12, v10, s1
		v_and_b32_e32 v14, 1, v0
		v_cmp_lt_i32_e64 s[2:3], v12, s25
		s_lshl_b32 s6, s12, 5
		s_add_i32 s6, s6, s4
		s_add_i32 s6, s6, s5
		s_add_i32 s6, s6, s7
		v_add3_u32 v12, s6, v9, v11
		v_cndmask_b32_e64 v12, v13, v12, s[2:3]
		buffer_load_dwordx4 v[20:23], v12, s[28:31], 0 offen
		v_bitop3_b32 v12, 32, v2, v7 bitop3:0x96
		v_xor_b32_e32 v12, v12, v8
		v_xad_u32 v12, v12, v10, s1
		v_lshrrev_b32_e32 v15, 1, v0
		v_cmp_lt_i32_e64 s[2:3], v12, s25
		s_lshl_b32 s6, s12, 6
		s_add_i32 s6, s6, s4
		s_add_i32 s6, s6, s5
		s_add_i32 s6, s6, s7
		v_add3_u32 v12, s6, v9, v11
		v_cndmask_b32_e64 v12, v13, v12, s[2:3]
		buffer_load_dwordx4 v[24:27], v12, s[28:31], 0 offen
		v_bitop3_b32 v12, 48, v2, v7 bitop3:0x96
		v_xor_b32_e32 v12, v12, v8
		v_xad_u32 v12, v12, v10, s1
		v_and_b32_e32 v15, 1, v15
		v_cmp_lt_i32_e64 s[2:3], v12, s25
		s_mul_i32 s6, 0x60, s12
		s_add_i32 s6, s6, s4
		s_add_i32 s6, s6, s5
		s_add_i32 s6, s6, s7
		v_add3_u32 v12, s6, v9, v11
		v_cndmask_b32_e64 v12, v13, v12, s[2:3]
		buffer_load_dwordx4 v[28:31], v12, s[28:31], 0 offen
		v_bitop3_b32 v12, 64, v2, v7 bitop3:0x96
		v_xor_b32_e32 v12, v12, v8
		v_xad_u32 v12, v12, v10, s1
		v_mov_b32_e32 v32, 2
		v_mul_lo_u32 v32, v32, v15
		v_cmp_lt_i32_e64 s[2:3], v12, s25
		s_lshl_b32 s6, s12, 7
		s_add_i32 s6, s6, s4
		s_add_i32 s6, s6, s5
		s_add_i32 s6, s6, s7
		v_add3_u32 v12, s6, v9, v11
		v_cndmask_b32_e64 v12, v13, v12, s[2:3]
		buffer_load_dwordx4 v[36:39], v12, s[28:31], 0 offen
		v_xor_b32_e32 v12, 0x50, v2
		v_xor_b32_e32 v12, v12, v7
		v_xor_b32_e32 v12, v12, v8
		v_xad_u32 v12, v12, v10, s1
		v_lshrrev_b32_e32 v15, 2, v0
		v_cmp_lt_i32_e64 s[2:3], v12, s25
		s_mul_i32 s6, 0xa0, s12
		s_add_i32 s6, s6, s4
		s_add_i32 s6, s6, s5
		s_add_i32 s6, s6, s7
		v_add3_u32 v12, s6, v9, v11
		v_cndmask_b32_e64 v12, v13, v12, s[2:3]
		buffer_load_dwordx4 v[40:43], v12, s[28:31], 0 offen
		v_xor_b32_e32 v12, 0x60, v2
		v_xor_b32_e32 v12, v12, v7
		v_xor_b32_e32 v12, v12, v8
		v_xad_u32 v12, v12, v10, s1
		v_and_b32_e32 v33, 1, v15
		v_cmp_lt_i32_e64 s[2:3], v12, s25
		s_mul_i32 s6, 0xc0, s12
		s_add_i32 s6, s6, s4
		s_add_i32 s6, s6, s5
		s_add_i32 s6, s6, s7
		v_add3_u32 v12, s6, v9, v11
		v_cndmask_b32_e64 v12, v13, v12, s[2:3]
		buffer_load_dwordx4 v[44:47], v12, s[28:31], 0 offen
		v_xor_b32_e32 v12, 0x70, v2
		v_xor_b32_e32 v12, v12, v7
		v_xor_b32_e32 v12, v12, v8
		v_xad_u32 v12, v12, v10, s1
		v_mov_b32_e32 v34, 4
		v_mul_lo_u32 v34, v34, v33
		v_cmp_lt_i32_e64 s[2:3], v12, s25
		s_mul_i32 s6, 0xe0, s12
		s_add_i32 s6, s6, s4
		s_add_i32 s6, s6, s5
		s_add_i32 s6, s6, s7
		v_add3_u32 v12, s6, v9, v11
		v_cndmask_b32_e64 v12, v13, v12, s[2:3]
		buffer_load_dwordx4 v[48:51], v12, s[28:31], 0 offen
		v_xor_b32_e32 v12, 0x80, v2
		v_xor_b32_e32 v12, v12, v7
		v_xor_b32_e32 v12, v12, v8
		v_xad_u32 v12, v12, v10, s1
		v_bitop3_b32 v33, v14, v32, v34 bitop3:0x96
		v_cmp_lt_i32_e64 s[2:3], v12, s25
		s_lshl_b32 s6, s12, 8
		s_add_i32 s6, s6, s4
		s_add_i32 s6, s6, s5
		s_add_i32 s6, s6, s7
		v_add3_u32 v12, s6, v9, v11
		v_cndmask_b32_e64 v12, v13, v12, s[2:3]
		buffer_load_dwordx4 v[52:55], v12, s[28:31], 0 offen
		v_xor_b32_e32 v12, 0x90, v2
		v_xor_b32_e32 v12, v12, v7
		v_xor_b32_e32 v12, v12, v8
		v_xad_u32 v12, v12, v10, s1
		v_lshrrev_b32_e32 v35, 3, v0
		v_cmp_lt_i32_e64 s[2:3], v12, s25
		s_mul_i32 s6, 0x120, s12
		s_add_i32 s6, s6, s4
		s_add_i32 s6, s6, s5
		s_add_i32 s6, s6, s7
		v_add3_u32 v12, s6, v9, v11
		v_cndmask_b32_e64 v12, v13, v12, s[2:3]
		buffer_load_dwordx4 v[56:59], v12, s[28:31], 0 offen
		v_xor_b32_e32 v12, 0xa0, v2
		v_xor_b32_e32 v12, v12, v7
		v_xor_b32_e32 v12, v12, v8
		v_xad_u32 v12, v12, v10, s1
		v_and_b32_e32 v60, 1, v35
		v_cmp_lt_i32_e64 s[2:3], v12, s25
		s_mul_i32 s6, 0x140, s12
		s_add_i32 s6, s6, s4
		s_add_i32 s6, s6, s5
		s_add_i32 s6, s6, s7
		v_add3_u32 v12, s6, v9, v11
		v_cndmask_b32_e64 v12, v13, v12, s[2:3]
		buffer_load_dwordx4 v[64:67], v12, s[28:31], 0 offen
		v_xor_b32_e32 v12, 0xb0, v2
		v_xor_b32_e32 v12, v12, v7
		v_xor_b32_e32 v12, v12, v8
		v_xad_u32 v12, v12, v10, s1
		v_mov_b32_e32 v61, 8
		v_mul_lo_u32 v61, v61, v60
		v_cmp_lt_i32_e64 s[2:3], v12, s25
		s_mul_i32 s6, 0x160, s12
		s_add_i32 s6, s6, s4
		s_add_i32 s6, s6, s5
		s_add_i32 s6, s6, s7
		v_add3_u32 v12, s6, v9, v11
		v_cndmask_b32_e64 v12, v13, v12, s[2:3]
		buffer_load_dwordx4 v[68:71], v12, s[28:31], 0 offen
		v_xor_b32_e32 v12, 0xc0, v2
		v_xor_b32_e32 v12, v12, v7
		v_xor_b32_e32 v12, v12, v8
		v_xad_u32 v12, v12, v10, s1
		v_xor_b32_e32 v33, v33, v61
		v_cmp_lt_i32_e64 s[2:3], v12, s25
		s_mul_i32 s6, 0x180, s12
		s_add_i32 s6, s6, s4
		s_add_i32 s6, s6, s5
		s_add_i32 s6, s6, s7
		v_add3_u32 v12, s6, v9, v11
		v_cndmask_b32_e64 v12, v13, v12, s[2:3]
		buffer_load_dwordx4 v[72:75], v12, s[28:31], 0 offen
		v_xor_b32_e32 v12, 0xd0, v2
		v_xor_b32_e32 v12, v12, v7
		v_xor_b32_e32 v12, v12, v8
		v_xad_u32 v12, v12, v10, s1
		v_mov_b32_e32 v60, 16
		v_mul_lo_u32 v60, v60, v2
		v_cmp_lt_i32_e64 s[2:3], v12, s25
		s_mul_i32 s6, 0x1a0, s12
		s_add_i32 s6, s6, s4
		s_add_i32 s6, s6, s5
		s_add_i32 s6, s6, s7
		v_add3_u32 v12, s6, v9, v11
		v_cndmask_b32_e64 v12, v13, v12, s[2:3]
		buffer_load_dwordx4 v[76:79], v12, s[28:31], 0 offen
		v_xor_b32_e32 v12, 0xe0, v2
		v_xor_b32_e32 v12, v12, v7
		v_xor_b32_e32 v12, v12, v8
		v_xad_u32 v12, v12, v10, s1
		v_mov_b32_e32 v62, 32
		v_mul_lo_u32 v62, v62, v3
		v_cmp_lt_i32_e64 s[2:3], v12, s25
		s_mul_i32 s6, 0x1c0, s12
		s_add_i32 s6, s6, s4
		s_add_i32 s6, s6, s5
		s_add_i32 s6, s6, s7
		v_add3_u32 v12, s6, v9, v11
		v_cndmask_b32_e64 v12, v13, v12, s[2:3]
		buffer_load_dwordx4 v[80:83], v12, s[28:31], 0 offen
		v_xor_b32_e32 v2, 0xf0, v2
		v_xor_b32_e32 v2, v2, v7
		v_xor_b32_e32 v2, v2, v8
		v_xad_u32 v2, v2, v10, s1
		s_mul_i32 s2, 0x1e0, s12
		s_add_i32 s2, s2, s4
		s_add_i32 s2, s2, s5
		s_add_i32 s2, s2, s7
		v_add3_u32 v7, s2, v9, v11
		v_cmp_lt_i32_e64 vcc, v2, s25
		v_bitop3_b32 v2, v33, v60, v62 bitop3:0x96
		v_mov_b32_e32 v8, 64
		v_mul_lo_u32 v8, v8, v4
		v_cndmask_b32_e32 v7, v13, v7, vcc
		buffer_load_dwordx4 v[84:87], v7, s[28:31], 0 offen
		v_xad_u32 v2, v2, v8, s1
		v_xor_b32_e32 v7, 0x80, v14
		v_xor_b32_e32 v7, v7, v32
		v_xor_b32_e32 v7, v7, v34
		v_bitop3_b32 v7, v7, v61, v60 bitop3:0x96
		v_xor_b32_e32 v7, v7, v62
		s_lshr_b32 s2, s24, 6
		s_and_b32 s3, 1, s2
		v_and_b32_e32 v9, 10, v1
		v_bitop3_b32 v9, 4, v15, v9 bitop3:0x6a
		v_bitop3_b32 v9, v0, s3, v9 bitop3:0x96
		v_lshlrev_b32_e32 v9, 4, v9
		v_add_u32_e32 v9, 0x10000, v9
		s_waitcnt vmcnt(15)
		ds_write_b128 v9, v[16:19] offset:2480
		s_waitcnt vmcnt(14)
		ds_write_b128 v9, v[20:23] offset:6576
		s_waitcnt vmcnt(13)
		ds_write_b128 v9, v[24:27] offset:10672
		s_waitcnt vmcnt(12)
		ds_write_b128 v9, v[28:31] offset:14768
		s_waitcnt vmcnt(11)
		ds_write_b128 v9, v[36:39] offset:18864
		s_waitcnt vmcnt(10)
		ds_write_b128 v9, v[40:43] offset:22960
		s_waitcnt vmcnt(9)
		ds_write_b128 v9, v[44:47] offset:27056
		s_waitcnt vmcnt(8)
		ds_write_b128 v9, v[48:51] offset:31152
		v_mov_b32_e32 v10, 2
		v_mul_lo_u32 v10, v10, v4
		s_mul_i32 s3, s17, s13
		s_mul_i32 s4, s0, s14
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_lshl_b32 s5, s2, 13
		s_add_i32 s5, s5, 0x10000
		v_and_b32_e32 v4, 63, v0
		v_lshrrev_b32_e32 v12, 4, v4
		v_and_b32_e32 v12, 1, v12
		v_lshl_add_u32 v12, v12, 12, s5
		v_lshrrev_b32_e32 v14, 5, v4
		v_and_b32_e32 v16, 15, v4
		v_lshlrev_b32_e32 v17, 4, v16
		v_add_u32_e32 v18, v14, v17
		v_lshrrev_b32_e32 v19, 2, v4
		v_bitop3_b32 v19, 1, v19, 3 bitop3:0x80
		v_xor_b32_e32 v18, v18, v19
		v_lshl_add_u32 v18, v18, 4, v12
		v_lshlrev_b32_e32 v20, 2, v16
		v_and_b32_e32 v21, 4, v20
		v_lshlrev_b32_e32 v21, 4, v21
		v_and_b32_e32 v16, 10, v16
		v_lshlrev_b32_e32 v22, 4, v16
		v_add3_u32 v18, v18, v21, v22
		ds_read_b128 a[0:3], v18 offset:2480
		v_add3_u32 v23, 2, v14, v17
		v_xor_b32_e32 v24, v19, v16
		v_xor_b32_e32 v23, v23, v24
		v_lshlrev_b32_e32 v23, 4, v23
		v_add3_u32 v21, v12, v23, v21
		ds_read_b128 a[4:7], v21 offset:2480
		v_add3_u32 v23, 4, v14, v17
		v_add_u32_e32 v25, 1, v20
		v_and_b32_e32 v25, 4, v25
		v_bitop3_b32 v23, v23, v19, v25 bitop3:0x96
		v_lshlrev_b32_e32 v23, 4, v23
		v_add3_u32 v22, v12, v23, v22
		ds_read_b128 a[8:11], v22 offset:2480
		v_add3_u32 v23, 6, v14, v17
		v_xor_b32_e32 v25, v25, v16
		v_bitop3_b32 v23, v23, v19, v25 bitop3:0x96
		v_lshl_add_u32 v23, v23, 4, v12
		ds_read_b128 a[12:15], v23 offset:2480
		v_add3_u32 v25, 8, v14, v17
		v_xor_b32_e32 v25, v25, v24
		v_lshlrev_b32_e32 v25, 4, v25
		v_add_u32_e32 v26, 2, v20
		v_and_b32_e32 v26, 4, v26
		v_lshlrev_b32_e32 v26, 4, v26
		v_add3_u32 v25, v12, v25, v26
		ds_read_b128 a[16:19], v25 offset:2480
		v_add3_u32 v27, 10, v14, v17
		v_xor_b32_e32 v24, v27, v24
		v_lshlrev_b32_e32 v24, 4, v24
		v_add3_u32 v24, v12, v24, v26
		ds_read_b128 a[20:23], v24 offset:2480
		v_add3_u32 v26, 12, v14, v17
		v_add_u32_e32 v20, 3, v20
		v_bitop3_b32 v16, 4, v20, v16 bitop3:0x6a
		v_xor_b32_e32 v16, v19, v16
		v_xor_b32_e32 v19, v26, v16
		v_lshl_add_u32 v19, v19, 4, v12
		ds_read_b128 a[24:27], v19 offset:2480
		v_add3_u32 v17, 14, v14, v17
		v_xor_b32_e32 v16, v17, v16
		v_lshl_add_u32 v12, v16, 4, v12
		ds_read_b128 a[28:31], v12 offset:2480
		s_mov_b32 s5, 63
		v_readfirstlane_b32 s6, v0
		s_mul_i32 s7, s15, s2
		v_and_b32_e32 v5, 1, v5
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(7)
		ds_write_b128 v9, v[52:55] offset:2480
		s_waitcnt vmcnt(6)
		ds_write_b128 v9, v[56:59] offset:6576
		s_waitcnt vmcnt(5)
		ds_write_b128 v9, v[64:67] offset:10672
		s_waitcnt vmcnt(4)
		ds_write_b128 v9, v[68:71] offset:14768
		s_waitcnt vmcnt(3)
		ds_write_b128 v9, v[72:75] offset:18864
		s_waitcnt vmcnt(2)
		ds_write_b128 v9, v[76:79] offset:22960
		s_waitcnt vmcnt(1)
		ds_write_b128 v9, v[80:83] offset:27056
		s_waitcnt vmcnt(0)
		ds_write_b128 v9, v[84:87] offset:31152
		v_and_b32_e32 v1, 1, v1
		v_and_b32_e32 v9, 1, v35
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[32:35], v18 offset:2480
		ds_read_b128 a[36:39], v21 offset:2480
		ds_read_b128 a[40:43], v22 offset:2480
		ds_read_b128 a[44:47], v23 offset:2480
		ds_read_b128 a[48:51], v25 offset:2480
		ds_read_b128 a[52:55], v24 offset:2480
		ds_read_b128 a[56:59], v19 offset:2480
		ds_read_b128 a[60:63], v12 offset:2480
		s_add_i32 s10, s25, 63
		s_cmp_lt_i32 s10, 0
		s_cselect_b32 s5, s5, 0
		s_add_i32 s5, s10, s5
		s_ashr_i32 s5, s5, 6
		s_sub_i32 s5, s5, 1
		s_cmp_gt_i32 s5, 0
		s_cselect_b32 s5, s5, 0
		v_mov_b32_e32 v12, 32
		v_mul_lo_u32 v12, v12, v6
		v_bitop3_b32 v16, v60, v12, v3 bitop3:0x96
		v_xor_b32_e32 v16, v16, v10
		v_bitop3_b32 v17, 4, v60, v12 bitop3:0x96
		v_bitop3_b32 v18, 8, v60, v12 bitop3:0x96
		v_bitop3_b32 v12, 12, v60, v12 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v16, s25
		s_lshl_b32 s3, s3, 1
		s_lshl_b32 s4, s4, 1
		s_add_i32 s10, s3, s4
		s_lshl_b32 s7, s7, 1
		s_add_i32 s10, s10, s7
		v_mul_lo_u32 v19, s15, v5
		v_lshlrev_b32_e32 v19, 6, v19
		v_add_u32_e32 v20, s10, v19
		v_mul_lo_u32 v21, s15, v1
		v_lshlrev_b32_e32 v21, 5, v21
		v_add3_u32 v20, v20, v21, v11
		v_mov_b32_e32 v22, 0x80000000
		v_cndmask_b32_e32 v20, v22, v20, vcc
		s_lshr_b32 s6, s6, 6
		s_mul_i32 s10, 0x410, s6
		s_mov_b32 m0, s10
		v_xad_u32 v7, v7, v8, s1
		buffer_load_dwordx4 v20, s[32:35], 0 offen lds
		s_lshl_b32 s1, s15, 3
		s_add_i32 s1, s1, s3
		s_add_i32 s1, s1, s4
		s_add_i32 s1, s1, s7
		v_add_u32_e32 v8, s1, v19
		v_add3_u32 v8, v8, v21, v11
		v_cndmask_b32_e32 v8, v22, v8, vcc
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[12:13], v2, s25
		buffer_load_dwordx4 v8, s[32:35], 0 offen lds
		s_lshl_b32 s1, s15, 4
		s_add_i32 s1, s1, s3
		s_add_i32 s1, s1, s4
		s_add_i32 s1, s1, s7
		v_add_u32_e32 v2, s1, v19
		v_add3_u32 v2, v2, v21, v11
		v_cndmask_b32_e32 v2, v22, v2, vcc
		s_add_i32 m0, m0, 0x1040
		v_and_b32_e32 v4, 31, v4
		buffer_load_dwordx4 v2, s[32:35], 0 offen lds
		s_mul_i32 s1, 24, s15
		s_add_i32 s1, s1, s3
		s_add_i32 s1, s1, s4
		s_add_i32 s1, s1, s7
		v_add_u32_e32 v2, s1, v19
		v_add3_u32 v2, v2, v21, v11
		v_cndmask_b32_e32 v2, v22, v2, vcc
		s_add_i32 m0, m0, 0x1040
		v_mov_b32_e32 v8, 0x880
		v_mul_lo_u32 v8, v8, v9
		buffer_load_dwordx4 v2, s[32:35], 0 offen lds
		s_mul_i32 s1, s17, s18
		s_lshl_b32 s1, s1, 1
		s_mul_i32 s11, s0, s19
		s_lshl_b32 s11, s11, 1
		s_add_i32 s14, s1, s11
		s_mul_i32 s18, s20, s2
		s_lshl_b32 s18, s18, 1
		s_add_i32 s14, s14, s18
		v_mul_lo_u32 v2, s20, v5
		v_lshlrev_b32_e32 v2, 6, v2
		v_add_u32_e32 v9, s14, v2
		v_mul_lo_u32 v20, s20, v1
		v_lshlrev_b32_e32 v20, 5, v20
		v_add3_u32 v9, v9, v20, v11
		v_cndmask_b32_e32 v9, v22, v9, vcc
		s_mul_i32 s6, 0x440, s6
		s_add_i32 m0, s6, 0x81f0
		v_cmp_lt_i32_e64 s[28:29], v7, s25
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		s_lshl_b32 s14, s20, 3
		s_add_i32 s14, s14, s1
		s_add_i32 s14, s14, s11
		s_add_i32 s14, s14, s18
		v_add_u32_e32 v7, s14, v2
		v_add3_u32 v7, v7, v20, v11
		v_cndmask_b32_e32 v7, v22, v7, vcc
		s_add_i32 m0, m0, 0x1100
		v_bitop3_b32 v9, v17, v3, v10 bitop3:0x96
		buffer_load_dwordx4 v7, s[36:39], 0 offen lds
		s_lshl_b32 s14, s20, 4
		s_add_i32 s14, s14, s1
		s_add_i32 s14, s14, s11
		s_add_i32 s14, s14, s18
		v_add_u32_e32 v7, s14, v2
		v_add3_u32 v7, v7, v20, v11
		v_cndmask_b32_e32 v7, v22, v7, vcc
		s_add_i32 m0, m0, 0x1100
		v_bitop3_b32 v17, v18, v3, v10 bitop3:0x96
		buffer_load_dwordx4 v7, s[36:39], 0 offen lds
		s_mul_i32 s14, 24, s20
		s_add_i32 s14, s14, s1
		s_add_i32 s14, s14, s11
		s_add_i32 s14, s14, s18
		v_add_u32_e32 v7, s14, v2
		v_add3_u32 v7, v7, v20, v11
		v_cndmask_b32_e32 v7, v22, v7, vcc
		s_add_i32 m0, m0, 0x1100
		v_bitop3_b32 v3, v12, v3, v10 bitop3:0x96
		buffer_load_dwordx4 v7, s[36:39], 0 offen lds
		s_mul_i32 s14, s5, 64
		v_mov_b32_e32 v7, 0xff800000
		s_lshl_b32 s19, s15, 7
		s_add_i32 s19, s19, s3
		s_add_i32 s19, s19, s4
		s_add_i32 s19, s19, s7
		s_mul_i32 s24, 0x88, s15
		s_add_i32 s24, s24, s3
		s_add_i32 s24, s24, s4
		s_add_i32 s24, s24, s7
		s_mul_i32 s27, 0x90, s15
		s_add_i32 s27, s27, s3
		s_add_i32 s27, s27, s4
		s_add_i32 s27, s27, s7
		s_mul_i32 s30, 0x98, s15
		s_add_i32 s3, s30, s3
		s_add_i32 s3, s3, s4
		s_add_i32 s3, s3, s7
		s_lshl_b32 s4, s20, 7
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s11
		s_add_i32 s4, s4, s18
		s_mul_i32 s7, 0x88, s20
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s11
		s_add_i32 s7, s7, s18
		s_mul_i32 s30, 0x90, s20
		s_add_i32 s30, s30, s1
		s_add_i32 s30, s30, s11
		s_add_i32 s30, s30, s18
		s_mul_i32 s31, 0x98, s20
		s_add_i32 s1, s31, s1
		s_add_i32 s1, s1, s11
		s_add_i32 s1, s1, s18
		v_mov_b32_e32 v24, 0x3e0293ee
		v_mov_b32_e32 v25, 0x3e0293ee
		v_lshlrev_b32_e32 v10, 4, v14
		v_lshrrev_b32_e32 v12, 4, v4
		v_lshlrev_b32_e32 v12, 8, v12
		v_and_b32_e32 v4, 15, v4
		v_mov_b32_e32 v18, 0x410
		v_mul_lo_u32 v18, v18, v4
		v_add3_u32 v4, v10, v12, v18
		v_and_b32_e32 v10, 3, v0
		v_mov_b32_e32 v23, 0x2200
		v_mul_lo_u32 v23, v23, v5
		v_lshl_add_u32 v26, v10, 3, v23
		v_lshl_add_u32 v26, v1, 5, v26
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v27, 0x440
		v_mul_lo_u32 v27, v27, v15
		v_add3_u32 v15, v26, v8, v27
		s_cmp_lt_i32 0, s14
		v_mov_b32_e32 v28, 1.0
		v_mov_b32_e32 v29, 1.0
		v_mov_b32_e32 v30, 0xff800000
		v_mov_b32_e32 v31, 0xff800000
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		v_mov_b64_e32 v[36:37], 0
		v_mov_b64_e32 v[38:39], 0
		v_mov_b64_e32 v[40:41], 0
		v_mov_b64_e32 v[42:43], 0
		v_mov_b64_e32 v[44:45], 0
		v_mov_b64_e32 v[46:47], 0
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
		s_cbranch_scc0 .L_attn_fwd_async_prefetch.loop_exit_0
.L_attn_fwd_async_prefetch.loop_head_0:
		s_waitcnt vmcnt(0)
		s_barrier
		s_lshr_b32 s11, s26, 6
		s_and_b32 s18, s11, 1
		s_mul_i32 s31, 0x4100, s18
		v_add_u32_e32 v26, s31, v4
		ds_read_b128 v[160:163], v26
		ds_read_b128 v[164:167], v26 offset:32
		ds_read_b128 v[168:171], v26 offset:64
		ds_read_b128 v[172:175], v26 offset:96
		ds_read_b128 v[176:179], v26 offset:128
		ds_read_b128 v[180:183], v26 offset:160
		ds_read_b128 v[184:187], v26 offset:192
		ds_read_b128 a[64:67], v26 offset:224
		ds_read_b128 v[188:191], v26 offset:512
		ds_read_b128 a[68:71], v26 offset:544
		ds_read_b128 a[72:75], v26 offset:576
		ds_read_b128 a[76:79], v26 offset:608
		ds_read_b128 a[80:83], v26 offset:640
		ds_read_b128 a[84:87], v26 offset:672
		ds_read_b128 a[88:91], v26 offset:704
		ds_read_b128 a[92:95], v26 offset:736
		s_mul_i32 s18, 0x4400, s18
		v_add_u32_e32 v26, s18, v15
		ds_read_b64_tr_b16 a[96:97], v26 offset:33264
		ds_read_b64_tr_b16 a[98:99], v26 offset:37616
		ds_read_b64_tr_b16 a[100:101], v26 offset:33520
		ds_read_b64_tr_b16 a[102:103], v26 offset:37872
		ds_read_b64_tr_b16 a[104:105], v26 offset:33776
		ds_read_b64_tr_b16 a[106:107], v26 offset:38128
		ds_read_b64_tr_b16 a[108:109], v26 offset:34032
		ds_read_b64_tr_b16 a[110:111], v26 offset:38384
		ds_read_b64_tr_b16 a[112:113], v26 offset:33328
		ds_read_b64_tr_b16 a[114:115], v26 offset:37680
		ds_read_b64_tr_b16 a[116:117], v26 offset:33584
		ds_read_b64_tr_b16 a[118:119], v26 offset:37936
		ds_read_b64_tr_b16 a[120:121], v26 offset:33840
		ds_read_b64_tr_b16 a[122:123], v26 offset:38192
		ds_read_b64_tr_b16 a[124:125], v26 offset:34096
		ds_read_b64_tr_b16 a[126:127], v26 offset:38448
		ds_read_b64_tr_b16 a[128:129], v26 offset:33392
		ds_read_b64_tr_b16 a[130:131], v26 offset:37744
		ds_read_b64_tr_b16 a[132:133], v26 offset:33648
		ds_read_b64_tr_b16 a[134:135], v26 offset:38000
		ds_read_b64_tr_b16 a[136:137], v26 offset:33904
		ds_read_b64_tr_b16 a[138:139], v26 offset:38256
		ds_read_b64_tr_b16 a[140:141], v26 offset:34160
		ds_read_b64_tr_b16 a[142:143], v26 offset:38512
		ds_read_b64_tr_b16 a[144:145], v26 offset:33456
		ds_read_b64_tr_b16 a[146:147], v26 offset:37808
		ds_read_b64_tr_b16 a[148:149], v26 offset:33712
		ds_read_b64_tr_b16 a[150:151], v26 offset:38064
		ds_read_b64_tr_b16 a[152:153], v26 offset:33968
		ds_read_b64_tr_b16 a[154:155], v26 offset:38320
		ds_read_b64_tr_b16 a[156:157], v26 offset:34224
		ds_read_b64_tr_b16 a[158:159], v26 offset:38576
		s_mul_i32 s18, s15, s26
		s_lshl_b32 s18, s18, 1
		s_add_i32 s31, s19, s18
		v_add_u32_e32 v26, s31, v19
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[192:207], v[160:163], a[0:3], 0
		v_add3_u32 v26, v26, v21, v11
		v_mfma_f32_32x32x16_bf16 v[192:207], v[164:167], a[4:7], v[192:207]
		s_add_i32 s11, s11, 1
		v_mfma_f32_32x32x16_bf16 v[192:207], v[168:171], a[8:11], v[192:207]
		s_and_b32 s11, s11, 1
		v_mfma_f32_32x32x16_bf16 v[192:207], v[172:175], a[12:15], v[192:207]
		s_mul_i32 s31, 0x4100, s11
		v_mfma_f32_32x32x16_bf16 v[192:207], v[176:179], a[16:19], v[192:207]
		s_add_i32 s31, s10, s31
		v_mfma_f32_32x32x16_bf16 v[192:207], v[180:183], a[20:23], v[192:207]
		s_mov_b32 m0, s31
		v_mfma_f32_32x32x16_bf16 v[192:207], v[184:187], a[24:27], v[192:207]
		s_add_i32 s31, s24, s18
		v_mfma_f32_32x32x16_bf16 v[208:223], v[160:163], a[32:35], 0
		v_add_u32_e32 v160, s31, v19
		v_mfma_f32_32x32x16_bf16 v[208:223], v[164:167], a[36:39], v[208:223]
		v_add3_u32 v160, v160, v21, v11
		v_mfma_f32_32x32x16_bf16 v[208:223], v[168:171], a[40:43], v[208:223]
		s_add_i32 s31, s27, s18
		v_mfma_f32_32x32x16_bf16 v[208:223], v[172:175], a[44:47], v[208:223]
		v_add_u32_e32 v161, s31, v19
		v_mfma_f32_32x32x16_bf16 v[208:223], v[176:179], a[48:51], v[208:223]
		v_add3_u32 v161, v161, v21, v11
		v_mfma_f32_32x32x16_bf16 v[208:223], v[180:183], a[52:55], v[208:223]
		s_add_i32 s18, s3, s18
		v_mfma_f32_32x32x16_bf16 v[208:223], v[184:187], a[56:59], v[208:223]
		v_add_u32_e32 v162, s18, v19
		v_mfma_f32_32x32x16_bf16 v[224:239], v[188:191], a[0:3], 0
		v_add3_u32 v162, v162, v21, v11
		v_mfma_f32_32x32x16_bf16 v[224:239], a[68:71], a[4:7], v[224:239]
		s_mul_i32 s18, s20, s26
		v_mfma_f32_32x32x16_bf16 v[224:239], a[72:75], a[8:11], v[224:239]
		s_add_i32 s26, s26, 64
		v_mfma_f32_32x32x16_bf16 v[224:239], a[76:79], a[12:15], v[224:239]
		v_add_u32_e32 v163, s26, v16
		v_mfma_f32_32x32x16_bf16 v[224:239], a[80:83], a[16:19], v[224:239]
		v_add_u32_e32 v164, s26, v9
		v_mfma_f32_32x32x16_bf16 v[224:239], a[84:87], a[20:23], v[224:239]
		v_add_u32_e32 v165, s26, v17
		v_mfma_f32_32x32x16_bf16 v[224:239], a[88:91], a[24:27], v[224:239]
		v_add_u32_e32 v166, s26, v3
		v_mfma_f32_32x32x16_bf16 v[240:255], v[188:191], a[32:35], 0
		v_cmp_lt_i32_e64 s[40:41], v163, s25
		v_mfma_f32_32x32x16_bf16 v[240:255], a[68:71], a[36:39], v[240:255]
		v_cmp_lt_i32_e64 vcc, v166, s25
		v_mfma_f32_32x32x16_bf16 v[240:255], a[72:75], a[40:43], v[240:255]
		v_cndmask_b32_e64 v26, v22, v26, s[40:41]
		buffer_load_dwordx4 v26, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[240:255], a[76:79], a[44:47], v[240:255]
		v_cmp_lt_i32_e64 s[42:43], v164, s25
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[44:45], v165, s25
		v_mfma_f32_32x32x16_bf16 v[240:255], a[80:83], a[48:51], v[240:255]
		v_cndmask_b32_e64 v26, v22, v160, s[42:43]
		buffer_load_dwordx4 v26, s[32:35], 0 offen lds
		v_cndmask_b32_e64 v26, v22, v161, s[44:45]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[84:87], a[52:55], v[240:255]
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e32 v160, v22, v162, vcc
		s_lshl_b32 s18, s18, 1
		buffer_load_dwordx4 v26, s[32:35], 0 offen lds
		s_add_i32 s31, s4, s18
		v_mfma_f32_32x32x16_bf16 v[240:255], a[88:91], a[56:59], v[240:255]
		s_add_i32 m0, m0, 0x1040
		v_add_u32_e32 v26, s31, v2
		v_add3_u32 v26, v26, v20, v11
		buffer_load_dwordx4 v160, s[32:35], 0 offen lds
		v_cndmask_b32_e64 v26, v22, v26, s[40:41]
		s_mul_i32 s11, 0x4400, s11
		v_mfma_f32_32x32x16_bf16 v[192:207], a[64:67], a[28:31], v[192:207]
		s_add_i32 s11, s6, s11
		v_mfma_f32_32x32x16_bf16 v[208:223], a[64:67], a[60:63], v[208:223]
		s_add_i32 m0, s11, 0x81f0
		s_add_i32 s11, s7, s18
		buffer_load_dwordx4 v26, s[36:39], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], a[92:95], a[28:31], v[224:239]
		v_add_u32_e32 v26, s11, v2
		v_mfma_f32_32x32x16_bf16 v[240:255], a[92:95], a[60:63], v[240:255]
		v_add3_u32 v26, v26, v20, v11
		v_cndmask_b32_e64 v26, v22, v26, s[42:43]
		s_add_i32 m0, m0, 0x1100
		s_add_i32 s11, s30, s18
		buffer_load_dwordx4 v26, s[36:39], 0 offen lds
		v_add_u32_e32 v26, s11, v2
		v_add3_u32 v26, v26, v20, v11
		v_max3_f32 v160, v192, v193, v194
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v26, v22, v26, s[44:45]
		buffer_load_dwordx4 v26, s[36:39], 0 offen lds
		v_max3_f32 v26, v196, v197, v198
		s_add_i32 s11, s1, s18
		v_add_u32_e32 v161, s11, v2
		v_add3_u32 v161, v161, v20, v11
		v_cndmask_b32_e32 v161, v22, v161, vcc
		v_max3_f32 v162, v200, v201, v202
		s_add_i32 m0, m0, 0x1100
		v_max3_f32 v163, v204, v205, v206
		v_max3_f32 v164, v224, v225, v226
		v_max3_f32 v165, v228, v229, v230
		v_max3_f32 v166, v232, v233, v234
		v_max3_f32 v167, v236, v237, v238
		v_max3_f32 v26, v160, v195, v26
		v_max3_f32 v160, v162, v203, v163
		v_max3_f32 v162, v164, v227, v165
		v_max3_f32 v163, v166, v235, v167
		v_max3_f32 v26, v26, v199, v160
		v_max3_f32 v160, v162, v231, v163
		v_max3_f32 v26, v26, v207, v160
		v_max3_f32 v160, v208, v209, v210
		v_max3_f32 v162, v212, v213, v214
		v_max3_f32 v163, v216, v217, v218
		v_max3_f32 v164, v220, v221, v222
		buffer_load_dwordx4 v161, s[36:39], 0 offen lds
		v_max_f32_e32 v166, v26, v239
		v_mov_b32_e32 v167, v166
		v_max3_f32 v26, v240, v241, v242
		v_max3_f32 v161, v244, v245, v246
		v_max3_f32 v165, v248, v249, v250
		v_max3_f32 v168, v252, v253, v254
		v_max3_f32 v160, v160, v211, v162
		v_max3_f32 v162, v163, v219, v164
		v_max3_f32 v26, v26, v243, v161
		v_max3_f32 v161, v165, v251, v168
		v_max3_f32 v160, v160, v215, v162
		v_max3_f32 v26, v26, v247, v161
		v_max3_f32 v26, v160, v223, v26
		v_max_f32_e32 v160, v26, v255
		s_cmp_lt_i32 s26, s14
		v_mov_b32_e32 v161, v160
		v_permlane32_swap_b32_e32 v166, v167
		v_max_f32_e32 v162, v166, v167
		v_permlane32_swap_b32_e32 v160, v161
		v_max_f32_e32 v163, v160, v161
		v_pk_mul_f32 v[160:161], v[162:163], v[24:25]
		v_max_f32_e32 v162, v30, v160
		v_max_f32_e32 v163, v31, v161
		v_pk_fma_f32 v[160:161], v[192:193], v[24:25], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[194:195], v[24:25], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[196:197], v[24:25], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[198:199], v[24:25], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[200:201], v[24:25], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[202:203], v[24:25], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[204:205], v[24:25], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[206:207], v[24:25], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[224:225], v[24:25], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[226:227], v[24:25], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[228:229], v[24:25], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[230:231], v[24:25], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[232:233], v[24:25], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[234:235], v[24:25], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[236:237], v[24:25], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[238:239], v[24:25], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[208:209], v[24:25], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[210:211], v[24:25], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[212:213], v[24:25], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[214:215], v[24:25], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[216:217], v[24:25], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[218:219], v[24:25], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[220:221], v[24:25], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[222:223], v[24:25], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[240:241], v[24:25], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[242:243], v[24:25], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[244:245], v[24:25], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[246:247], v[24:25], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[218:219], v[248:249], v[24:25], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[220:221], v[250:251], v[24:25], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[222:223], v[252:253], v[24:25], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[224:225], v[254:255], v[24:25], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v226, v160
		v_exp_f32_e32 v228, v161
		v_exp_f32_e32 v160, v164
		v_exp_f32_e32 v230, v165
		v_exp_f32_e32 v164, v166
		v_exp_f32_e32 v232, v167
		v_exp_f32_e32 v166, v168
		v_exp_f32_e32 v234, v169
		v_exp_f32_e32 v168, v170
		v_exp_f32_e32 v236, v171
		v_exp_f32_e32 v170, v172
		v_exp_f32_e32 v238, v173
		v_exp_f32_e32 v172, v174
		v_exp_f32_e32 v240, v175
		v_exp_f32_e32 v174, v176
		v_exp_f32_e32 v242, v177
		v_exp_f32_e32 v227, v178
		v_exp_f32_e32 v229, v179
		v_exp_f32_e32 v161, v180
		v_exp_f32_e32 v231, v181
		v_exp_f32_e32 v165, v182
		v_exp_f32_e32 v233, v183
		v_exp_f32_e32 v167, v184
		v_exp_f32_e32 v235, v185
		v_exp_f32_e32 v169, v186
		v_exp_f32_e32 v237, v187
		v_exp_f32_e32 v171, v188
		v_exp_f32_e32 v239, v189
		v_exp_f32_e32 v173, v190
		v_exp_f32_e32 v241, v191
		v_exp_f32_e32 v175, v192
		v_exp_f32_e32 v243, v193
		v_exp_f32_e32 v176, v196
		v_exp_f32_e32 v178, v197
		v_exp_f32_e32 v180, v198
		v_exp_f32_e32 v182, v199
		v_exp_f32_e32 v184, v200
		v_exp_f32_e32 v186, v201
		v_exp_f32_e32 v188, v202
		v_exp_f32_e32 v190, v203
		v_exp_f32_e32 v192, v204
		v_exp_f32_e32 v196, v205
		v_exp_f32_e32 v198, v206
		v_exp_f32_e32 v200, v207
		v_exp_f32_e32 v202, v208
		v_exp_f32_e32 v204, v209
		v_exp_f32_e32 v207, v210
		v_exp_f32_e32 v209, v211
		v_exp_f32_e32 v177, v212
		v_exp_f32_e32 v179, v213
		v_exp_f32_e32 v181, v214
		v_exp_f32_e32 v183, v215
		v_exp_f32_e32 v185, v216
		v_exp_f32_e32 v187, v217
		v_exp_f32_e32 v189, v218
		v_exp_f32_e32 v191, v219
		v_exp_f32_e32 v193, v220
		v_exp_f32_e32 v197, v221
		v_exp_f32_e32 v199, v222
		v_exp_f32_e32 v201, v223
		v_exp_f32_e32 v203, v224
		v_exp_f32_e32 v205, v225
		v_pk_add_f32 v[210:211], v[226:227], v[228:229]
		v_pk_add_f32 v[212:213], v[160:161], v[230:231]
		v_pk_add_f32 v[214:215], v[164:165], v[232:233]
		v_pk_add_f32 v[216:217], v[166:167], v[234:235]
		v_pk_add_f32 v[218:219], v[168:169], v[236:237]
		v_pk_add_f32 v[220:221], v[170:171], v[238:239]
		v_pk_add_f32 v[222:223], v[172:173], v[240:241]
		v_pk_add_f32 v[224:225], v[174:175], v[242:243]
		v_pk_add_f32 v[210:211], v[210:211], v[212:213]
		v_pk_add_f32 v[212:213], v[214:215], v[216:217]
		v_pk_add_f32 v[214:215], v[218:219], v[220:221]
		v_pk_add_f32 v[216:217], v[222:223], v[224:225]
		v_pk_add_f32 v[210:211], v[210:211], v[212:213]
		v_pk_add_f32 v[212:213], v[214:215], v[216:217]
		v_pk_add_f32 v[214:215], v[210:211], v[212:213]
		v_add_f32_e32 v210, v214, v215
		v_mov_b32_e32 v211, v210
		v_exp_f32_e32 v206, v194
		v_exp_f32_e32 v208, v195
		v_permlane32_swap_b32_e32 v210, v211
		v_pk_add_f32 v[194:195], v[206:207], v[208:209]
		v_pk_add_f32 v[212:213], v[176:177], v[178:179]
		v_pk_add_f32 v[214:215], v[180:181], v[182:183]
		v_pk_add_f32 v[216:217], v[184:185], v[186:187]
		v_pk_add_f32 v[218:219], v[188:189], v[190:191]
		v_pk_add_f32 v[220:221], v[192:193], v[196:197]
		v_pk_add_f32 v[222:223], v[198:199], v[200:201]
		v_pk_add_f32 v[224:225], v[202:203], v[204:205]
		v_pk_add_f32 v[194:195], v[194:195], v[212:213]
		v_pk_add_f32 v[212:213], v[214:215], v[216:217]
		v_pk_add_f32 v[214:215], v[218:219], v[220:221]
		v_pk_add_f32 v[216:217], v[222:223], v[224:225]
		v_pk_add_f32 v[194:195], v[194:195], v[212:213]
		v_pk_add_f32 v[212:213], v[214:215], v[216:217]
		v_pk_add_f32 v[214:215], v[194:195], v[212:213]
		v_mov_b32_e32 v194, v211
		v_mov_b32_e32 v195, v215
		v_mov_b32_e32 v212, v210
		v_mov_b32_e32 v213, v214
		v_pk_add_f32 v[210:211], v[212:213], v[194:195]
		v_mov_b32_e32 v194, v211
		v_mov_b32_e32 v195, v211
		v_pk_add_f32 v[212:213], v[30:31], v[162:163] neg_lo:[0,1] neg_hi:[0,1]
		v_cvt_pk_bf16_f32 v216, v226, v228
		v_permlane32_swap_b32_e32 v194, v195
		v_add_f32_e32 v31, v194, v195
		v_exp_f32_e32 v194, v212
		v_exp_f32_e32 v195, v213
		v_cvt_pk_bf16_f32 v217, v160, v230
		v_mov_b32_e32 v30, v210
		v_pk_fma_f32 v[28:29], v[28:29], v[194:195], v[30:31]
		v_cvt_pk_bf16_f32 v218, v164, v232
		v_cvt_pk_bf16_f32 v219, v166, v234
		v_cvt_pk_bf16_f32 v212, v168, v236
		v_cvt_pk_bf16_f32 v213, v170, v238
		v_cvt_pk_bf16_f32 v214, v172, v240
		v_cvt_pk_bf16_f32 v215, v174, v242
		v_cvt_pk_bf16_f32 v220, v227, v229
		v_cvt_pk_bf16_f32 v221, v161, v231
		v_cvt_pk_bf16_f32 v222, v165, v233
		v_cvt_pk_bf16_f32 v223, v167, v235
		v_cvt_pk_bf16_f32 v164, v169, v237
		v_cvt_pk_bf16_f32 v165, v171, v239
		v_cvt_pk_bf16_f32 v166, v173, v241
		v_cvt_pk_bf16_f32 v167, v175, v243
		v_pk_mul_f32 v[32:33], v[32:33], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[34:35], v[34:35], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[36:37], v[36:37], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[38:39], v[38:39], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[40:41], v[40:41], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[42:43], v[42:43], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[44:45], v[44:45], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[46:47], v[46:47], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[48:49], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[50:51], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[52:53], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[54:55], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[56:57], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[58:59], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[60:61], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[62:63], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[64:65], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[66:67], v[66:67], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[68:69], v[68:69], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[70:71], v[70:71], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[72:73], v[72:73], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[74:75], v[74:75], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[76:77], v[76:77], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[78:79], v[78:79], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[80:81], v[80:81], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[82:83], v[82:83], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[84:85], v[84:85], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[86:87], v[86:87], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[88:89], v[88:89], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[90:91], v[90:91], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[92:93], v[92:93], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[94:95], v[94:95], v[194:195] op_sel_hi:[1,0]
		v_pk_mul_f32 v[96:97], v[96:97], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[98:99], v[98:99], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[100:101], v[100:101], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[102:103], v[102:103], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[104:105], v[104:105], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[106:107], v[106:107], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[108:109], v[108:109], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[110:111], v[110:111], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[112:113], v[112:113], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[114:115], v[114:115], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[116:117], v[116:117], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[118:119], v[118:119], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[120:121], v[120:121], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[122:123], v[122:123], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[124:125], v[124:125], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[126:127], v[126:127], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[128:129], v[128:129], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[130:131], v[130:131], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[132:133], v[132:133], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[134:135], v[134:135], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[136:137], v[136:137], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[138:139], v[138:139], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[140:141], v[140:141], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[142:143], v[142:143], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[144:145], v[144:145], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[146:147], v[146:147], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[148:149], v[148:149], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[150:151], v[150:151], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[152:153], v[152:153], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[154:155], v[154:155], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[156:157], v[156:157], v[194:195] op_sel:[0,1]
		v_pk_mul_f32 v[158:159], v[158:159], v[194:195] op_sel:[0,1]
		v_cvt_pk_bf16_f32 v168, v206, v208
		v_cvt_pk_bf16_f32 v169, v176, v178
		v_cvt_pk_bf16_f32 v170, v180, v182
		v_cvt_pk_bf16_f32 v171, v184, v186
		v_cvt_pk_bf16_f32 v172, v188, v190
		v_cvt_pk_bf16_f32 v173, v192, v196
		v_cvt_pk_bf16_f32 v174, v198, v200
		v_cvt_pk_bf16_f32 v175, v202, v204
		v_cvt_pk_bf16_f32 v224, v207, v209
		v_cvt_pk_bf16_f32 v225, v177, v179
		v_cvt_pk_bf16_f32 v226, v181, v183
		v_cvt_pk_bf16_f32 v227, v185, v187
		v_cvt_pk_bf16_f32 v176, v189, v191
		v_cvt_pk_bf16_f32 v177, v193, v197
		v_cvt_pk_bf16_f32 v178, v199, v201
		v_cvt_pk_bf16_f32 v179, v203, v205
		v_permlane32_swap_b32_e32 v216, v218
		v_permlane32_swap_b32_e32 v217, v219
		v_permlane32_swap_b32_e32 v212, v214
		v_permlane32_swap_b32_e32 v213, v215
		v_mfma_f32_32x32x16_bf16 v[32:47], a[96:99], v[216:219], v[32:47]
		v_permlane32_swap_b32_e32 v220, v222
		v_permlane32_swap_b32_e32 v221, v223
		v_mfma_f32_32x32x16_bf16 v[48:63], a[112:115], v[216:219], v[48:63]
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		v_mfma_f32_32x32x16_bf16 v[64:79], a[128:131], v[216:219], v[64:79]
		v_permlane32_swap_b32_e32 v168, v170
		v_permlane32_swap_b32_e32 v169, v171
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[216:219], v[80:95]
		v_permlane32_swap_b32_e32 v172, v174
		v_permlane32_swap_b32_e32 v173, v175
		v_mfma_f32_32x32x16_bf16 v[144:159], a[144:147], v[168:171], v[144:159]
		v_permlane32_swap_b32_e32 v224, v226
		v_permlane32_swap_b32_e32 v225, v227
		v_mfma_f32_32x32x16_bf16 v[96:111], a[96:99], v[168:171], v[96:111]
		v_permlane32_swap_b32_e32 v176, v178
		v_permlane32_swap_b32_e32 v177, v179
		v_mfma_f32_32x32x16_bf16 v[112:127], a[112:115], v[168:171], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[128:131], v[168:171], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[100:103], v[212:215], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[116:119], v[212:215], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[132:135], v[212:215], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[148:151], v[212:215], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[148:151], v[172:175], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[100:103], v[172:175], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[116:119], v[172:175], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[132:135], v[172:175], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[104:107], v[220:223], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[120:123], v[220:223], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[136:139], v[220:223], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], v[220:223], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[152:155], v[224:227], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[104:107], v[224:227], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[120:123], v[224:227], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[136:139], v[224:227], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[108:111], v[164:167], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[124:127], v[164:167], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[140:143], v[164:167], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], v[164:167], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[156:159], v[176:179], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[108:111], v[176:179], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[124:127], v[176:179], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[140:143], v[176:179], v[128:143]
		v_mov_b32_e32 v30, v162
		v_mov_b32_e32 v31, v163
		s_cbranch_scc1 .L_attn_fwd_async_prefetch.loop_head_0
.L_attn_fwd_async_prefetch.loop_exit_0:
		s_waitcnt vmcnt(0)
		s_barrier
		s_and_b32 s1, s5, 1
		s_mul_i32 s3, 0x4100, s1
		v_lshl_add_u32 v2, v14, 4, s3
		v_add3_u32 v2, v2, v12, v18
		ds_read_b128 v[16:19], v2
		ds_read_b128 v[160:163], v2 offset:32
		ds_read_b128 v[164:167], v2 offset:64
		ds_read_b128 v[168:171], v2 offset:96
		ds_read_b128 a[64:67], v2 offset:128
		ds_read_b128 a[68:71], v2 offset:160
		ds_read_b128 a[72:75], v2 offset:192
		ds_read_b128 a[76:79], v2 offset:224
		ds_read_b128 v[172:175], v2 offset:512
		ds_read_b128 v[176:179], v2 offset:544
		ds_read_b128 v[180:183], v2 offset:576
		ds_read_b128 v[184:187], v2 offset:608
		ds_read_b128 v[188:191], v2 offset:640
		ds_read_b128 a[80:83], v2 offset:672
		ds_read_b128 a[84:87], v2 offset:704
		ds_read_b128 a[88:91], v2 offset:736
		s_mul_i32 s1, 0x4400, s1
		v_lshlrev_b32_e32 v2, 3, v10
		v_add3_u32 v2, s1, v2, v23
		v_lshl_add_u32 v1, v1, 5, v2
		v_add3_u32 v1, v1, v8, v27
		ds_read_b64_tr_b16 a[92:93], v1 offset:33264
		ds_read_b64_tr_b16 a[94:95], v1 offset:37616
		ds_read_b64_tr_b16 a[96:97], v1 offset:33520
		ds_read_b64_tr_b16 a[98:99], v1 offset:37872
		ds_read_b64_tr_b16 a[100:101], v1 offset:33776
		ds_read_b64_tr_b16 a[102:103], v1 offset:38128
		ds_read_b64_tr_b16 a[104:105], v1 offset:34032
		ds_read_b64_tr_b16 a[106:107], v1 offset:38384
		ds_read_b64_tr_b16 a[108:109], v1 offset:33328
		ds_read_b64_tr_b16 a[110:111], v1 offset:37680
		ds_read_b64_tr_b16 a[112:113], v1 offset:33584
		ds_read_b64_tr_b16 a[114:115], v1 offset:37936
		ds_read_b64_tr_b16 a[116:117], v1 offset:33840
		ds_read_b64_tr_b16 a[118:119], v1 offset:38192
		ds_read_b64_tr_b16 a[120:121], v1 offset:34096
		ds_read_b64_tr_b16 a[122:123], v1 offset:38448
		ds_read_b64_tr_b16 a[124:125], v1 offset:33392
		ds_read_b64_tr_b16 a[126:127], v1 offset:37744
		ds_read_b64_tr_b16 a[128:129], v1 offset:33648
		ds_read_b64_tr_b16 a[130:131], v1 offset:38000
		ds_read_b64_tr_b16 a[132:133], v1 offset:33904
		ds_read_b64_tr_b16 a[134:135], v1 offset:38256
		ds_read_b64_tr_b16 a[136:137], v1 offset:34160
		ds_read_b64_tr_b16 a[138:139], v1 offset:38512
		ds_read_b64_tr_b16 a[140:141], v1 offset:33456
		ds_read_b64_tr_b16 a[142:143], v1 offset:37808
		ds_read_b64_tr_b16 a[144:145], v1 offset:33712
		ds_read_b64_tr_b16 a[146:147], v1 offset:38064
		ds_read_b64_tr_b16 a[148:149], v1 offset:33968
		ds_read_b64_tr_b16 a[150:151], v1 offset:38320
		ds_read_b64_tr_b16 a[152:153], v1 offset:34224
		ds_read_b64_tr_b16 a[154:155], v1 offset:38576
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[192:207], v[16:19], a[0:3], 0
		s_mul_i32 s1, s16, s23
		v_mfma_f32_32x32x16_bf16 v[208:223], v[172:175], a[0:3], 0
		s_lshl_b32 s1, s1, 9
		v_mfma_f32_32x32x16_bf16 v[224:239], v[172:175], a[32:35], 0
		s_mul_i32 s3, s17, s21
		v_mfma_f32_32x32x16_bf16 v[240:255], v[16:19], a[32:35], 0
		s_lshl_b32 s3, s3, 1
		v_mfma_f32_32x32x16_bf16 v[192:207], v[160:163], a[4:7], v[192:207]
		s_add_i32 s4, s1, s3
		v_mfma_f32_32x32x16_bf16 v[208:223], v[176:179], a[4:7], v[208:223]
		s_mul_i32 s0, s0, s22
		v_mfma_f32_32x32x16_bf16 v[224:239], v[176:179], a[36:39], v[224:239]
		s_lshl_b32 s0, s0, 1
		v_mfma_f32_32x32x16_bf16 v[240:255], v[160:163], a[36:39], v[240:255]
		s_add_i32 s4, s4, s0
		v_mfma_f32_32x32x16_bf16 v[192:207], v[164:167], a[8:11], v[192:207]
		s_mul_i32 s2, s23, s2
		v_mfma_f32_32x32x16_bf16 v[208:223], v[180:183], a[8:11], v[208:223]
		s_lshl_b32 s2, s2, 6
		v_mfma_f32_32x32x16_bf16 v[224:239], v[180:183], a[40:43], v[224:239]
		s_add_i32 s4, s4, s2
		v_mfma_f32_32x32x16_bf16 v[240:255], v[164:167], a[40:43], v[240:255]
		v_and_b32_e32 v0, 31, v0
		v_mfma_f32_32x32x16_bf16 v[192:207], v[168:171], a[12:15], v[192:207]
		v_mul_lo_u32 v0, s23, v0
		v_mfma_f32_32x32x16_bf16 v[208:223], v[184:187], a[12:15], v[208:223]
		v_lshlrev_b32_e32 v0, 1, v0
		v_mfma_f32_32x32x16_bf16 v[224:239], v[184:187], a[44:47], v[224:239]
		v_lshlrev_b32_e32 v1, 4, v5
		v_mfma_f32_32x32x16_bf16 v[240:255], v[168:171], a[44:47], v[240:255]
		s_add_i32 s5, s1, 32
		v_mfma_f32_32x32x16_bf16 v[192:207], a[64:67], a[16:19], v[192:207]
		s_add_i32 s5, s5, s3
		v_mfma_f32_32x32x16_bf16 v[208:223], v[188:191], a[16:19], v[208:223]
		s_add_i32 s5, s5, s0
		v_mfma_f32_32x32x16_bf16 v[224:239], v[188:191], a[48:51], v[224:239]
		s_add_i32 s5, s5, s2
		v_mfma_f32_32x32x16_bf16 v[240:255], a[64:67], a[48:51], v[240:255]
		s_add_i32 s6, s1, 64
		v_mfma_f32_32x32x16_bf16 v[192:207], a[68:71], a[20:23], v[192:207]
		s_add_i32 s6, s6, s3
		v_mfma_f32_32x32x16_bf16 v[208:223], a[80:83], a[20:23], v[208:223]
		s_add_i32 s6, s6, s0
		v_mfma_f32_32x32x16_bf16 v[224:239], a[80:83], a[52:55], v[224:239]
		s_add_i32 s6, s6, s2
		v_mfma_f32_32x32x16_bf16 v[240:255], a[68:71], a[52:55], v[240:255]
		s_add_i32 s7, s1, 0x60
		v_mfma_f32_32x32x16_bf16 v[192:207], a[72:75], a[24:27], v[192:207]
		s_add_i32 s7, s7, s3
		v_mfma_f32_32x32x16_bf16 v[208:223], a[84:87], a[24:27], v[208:223]
		s_add_i32 s7, s7, s0
		v_mfma_f32_32x32x16_bf16 v[224:239], a[84:87], a[56:59], v[224:239]
		s_add_i32 s7, s7, s2
		v_mfma_f32_32x32x16_bf16 v[240:255], a[72:75], a[56:59], v[240:255]
		s_add_i32 s10, s1, 0x80
		v_mfma_f32_32x32x16_bf16 v[192:207], a[76:79], a[28:31], v[192:207]
		s_add_i32 s10, s10, s3
		v_mfma_f32_32x32x16_bf16 v[208:223], a[88:91], a[28:31], v[208:223]
		s_add_i32 s10, s10, s0
		v_mfma_f32_32x32x16_bf16 v[224:239], a[88:91], a[60:63], v[224:239]
		s_add_i32 s10, s10, s2
		v_mfma_f32_32x32x16_bf16 v[240:255], a[76:79], a[60:63], v[240:255]
		v_mov_b32_e32 v2, 4
		v_mul_lo_u32 v2, v2, v6
		v_add_u32_e32 v3, s14, v2
		v_xad_u32 v4, 16, v2, s14
		v_xad_u32 v5, 32, v2, s14
		v_xad_u32 v2, 48, v2, s14
		v_cmp_lt_i32_e64 s[14:15], v3, s25
		v_cmp_lt_i32_e64 s[16:17], v4, s25
		v_cmp_lt_i32_e64 s[18:19], v5, s25
		v_cmp_lt_i32_e64 vcc, v2, s25
		v_cndmask_b32_e64 v2, v7, v192, s[14:15]
		v_cndmask_b32_e64 v3, v7, v193, s[14:15]
		v_cndmask_b32_e64 v4, v7, v194, s[14:15]
		v_cndmask_b32_e64 v5, v7, v195, s[14:15]
		v_cndmask_b32_e64 v8, v7, v196, s[14:15]
		v_cndmask_b32_e64 v9, v7, v197, s[14:15]
		v_cndmask_b32_e64 v10, v7, v198, s[14:15]
		v_cndmask_b32_e64 v11, v7, v199, s[14:15]
		v_cndmask_b32_e64 v14, v7, v200, s[16:17]
		v_cndmask_b32_e64 v15, v7, v201, s[16:17]
		v_cndmask_b32_e64 v16, v7, v202, s[16:17]
		v_cndmask_b32_e64 v17, v7, v203, s[16:17]
		v_cndmask_b32_e64 v18, v7, v204, s[16:17]
		v_cndmask_b32_e64 v19, v7, v205, s[16:17]
		v_cndmask_b32_e64 v20, v7, v206, s[16:17]
		v_cndmask_b32_e64 v21, v7, v207, s[16:17]
		v_cndmask_b32_e64 v22, v7, v208, s[18:19]
		v_cndmask_b32_e64 v23, v7, v209, s[18:19]
		v_cndmask_b32_e64 v26, v7, v210, s[18:19]
		v_cndmask_b32_e64 v27, v7, v211, s[18:19]
		v_cndmask_b32_e64 v160, v7, v212, s[18:19]
		v_cndmask_b32_e64 v161, v7, v213, s[18:19]
		v_cndmask_b32_e64 v162, v7, v214, s[18:19]
		v_cndmask_b32_e64 v163, v7, v215, s[18:19]
		v_cndmask_b32_e32 v164, v7, v216, vcc
		v_cndmask_b32_e32 v165, v7, v217, vcc
		v_cndmask_b32_e32 v166, v7, v218, vcc
		v_cndmask_b32_e32 v167, v7, v219, vcc
		v_cndmask_b32_e32 v168, v7, v220, vcc
		v_cndmask_b32_e32 v169, v7, v221, vcc
		v_cndmask_b32_e32 v170, v7, v222, vcc
		v_cndmask_b32_e32 v171, v7, v223, vcc
		v_cndmask_b32_e64 v172, v7, v242, s[14:15]
		v_cndmask_b32_e64 v173, v7, v243, s[14:15]
		v_cndmask_b32_e64 v174, v7, v244, s[14:15]
		v_cndmask_b32_e64 v175, v7, v245, s[14:15]
		v_cndmask_b32_e64 v176, v7, v246, s[14:15]
		v_cndmask_b32_e64 v177, v7, v247, s[14:15]
		v_cndmask_b32_e64 v178, v7, v248, s[16:17]
		v_cndmask_b32_e64 v179, v7, v249, s[16:17]
		v_cndmask_b32_e64 v180, v7, v250, s[16:17]
		v_cndmask_b32_e64 v181, v7, v251, s[16:17]
		v_cndmask_b32_e64 v182, v7, v252, s[16:17]
		v_cndmask_b32_e64 v183, v7, v253, s[16:17]
		v_cndmask_b32_e64 v184, v7, v254, s[16:17]
		v_cndmask_b32_e64 v185, v7, v255, s[16:17]
		v_cndmask_b32_e64 v186, v7, v224, s[18:19]
		v_cndmask_b32_e64 v187, v7, v225, s[18:19]
		v_cndmask_b32_e64 v188, v7, v226, s[18:19]
		v_cndmask_b32_e64 v189, v7, v227, s[18:19]
		v_cndmask_b32_e64 v190, v7, v228, s[18:19]
		v_cndmask_b32_e64 v191, v7, v229, s[18:19]
		v_cndmask_b32_e64 v192, v7, v230, s[18:19]
		v_cndmask_b32_e64 v193, v7, v231, s[18:19]
		v_cndmask_b32_e32 v194, v7, v232, vcc
		v_cndmask_b32_e32 v195, v7, v233, vcc
		v_cndmask_b32_e32 v196, v7, v234, vcc
		v_cndmask_b32_e32 v197, v7, v235, vcc
		v_cndmask_b32_e32 v198, v7, v236, vcc
		v_cndmask_b32_e32 v199, v7, v237, vcc
		v_cndmask_b32_e32 v200, v7, v238, vcc
		v_cndmask_b32_e32 v201, v7, v239, vcc
		v_max3_f32 v6, v2, v3, v4
		v_max3_f32 v12, v8, v9, v10
		v_max3_f32 v202, v14, v15, v16
		v_max3_f32 v203, v18, v19, v20
		v_max3_f32 v204, v22, v23, v26
		v_max3_f32 v205, v160, v161, v162
		v_max3_f32 v206, v164, v165, v166
		v_max3_f32 v207, v168, v169, v170
		v_max3_f32 v6, v6, v5, v12
		v_max3_f32 v12, v202, v17, v203
		v_max3_f32 v202, v204, v27, v205
		v_max3_f32 v203, v206, v167, v207
		v_max3_f32 v6, v6, v11, v12
		v_max3_f32 v12, v202, v163, v203
		v_max3_f32 v6, v6, v21, v12
		v_max_f32_e32 v202, v6, v171
		v_mov_b32_e32 v203, v202
		v_cndmask_b32_e64 v204, v7, v240, s[14:15]
		v_cndmask_b32_e64 v205, v7, v241, s[14:15]
		v_permlane32_swap_b32_e32 v202, v203
		v_max3_f32 v6, v204, v205, v172
		v_max3_f32 v7, v174, v175, v176
		v_max3_f32 v12, v178, v179, v180
		v_max3_f32 v206, v182, v183, v184
		v_max3_f32 v207, v186, v187, v188
		v_max3_f32 v208, v190, v191, v192
		v_max3_f32 v209, v194, v195, v196
		v_max3_f32 v210, v198, v199, v200
		v_max3_f32 v6, v6, v173, v7
		v_max3_f32 v7, v12, v181, v206
		v_max3_f32 v12, v207, v189, v208
		v_max3_f32 v206, v209, v197, v210
		v_max3_f32 v6, v6, v177, v7
		v_max3_f32 v7, v12, v193, v206
		v_max3_f32 v6, v6, v185, v7
		v_max_f32_e32 v206, v6, v201
		v_mov_b32_e32 v207, v206
		v_max_f32_e32 v6, v202, v203
		s_add_i32 s11, s1, 0xa0
		v_permlane32_swap_b32_e32 v206, v207
		v_max_f32_e32 v7, v206, v207
		v_pk_mul_f32 v[202:203], v[6:7], v[24:25]
		v_max_f32_e32 v6, v30, v202
		v_max_f32_e32 v7, v31, v203
		v_pk_fma_f32 v[202:203], v[2:3], v[24:25], v[6:7] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[2:3], v[4:5], v[24:25], v[6:7] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[4:5], v[8:9], v[24:25], v[6:7] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[8:9], v[10:11], v[24:25], v[6:7] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[10:11], v[14:15], v[24:25], v[6:7] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[14:15], v[16:17], v[24:25], v[6:7] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[16:17], v[18:19], v[24:25], v[6:7] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[18:19], v[20:21], v[24:25], v[6:7] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[20:21], v[22:23], v[24:25], v[6:7] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[22:23], v[26:27], v[24:25], v[6:7] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[160:161], v[24:25], v[6:7] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[162:163], v[24:25], v[6:7] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[164:165], v[24:25], v[6:7] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[166:167], v[24:25], v[6:7] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[168:169], v[24:25], v[6:7] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[170:171], v[24:25], v[6:7] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[204:205], v[24:25], v[6:7] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[172:173], v[24:25], v[6:7] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[174:175], v[24:25], v[6:7] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[176:177], v[24:25], v[6:7] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[178:179], v[24:25], v[6:7] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[180:181], v[24:25], v[6:7] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[182:183], v[24:25], v[6:7] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[184:185], v[24:25], v[6:7] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[186:187], v[24:25], v[6:7] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[188:189], v[24:25], v[6:7] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[190:191], v[24:25], v[6:7] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[192:193], v[24:25], v[6:7] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[194:195], v[24:25], v[6:7] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[196:197], v[24:25], v[6:7] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[198:199], v[24:25], v[6:7] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[200:201], v[24:25], v[6:7] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v24, v202
		v_exp_f32_e32 v200, v203
		v_exp_f32_e32 v202, v2
		v_exp_f32_e32 v206, v3
		v_exp_f32_e32 v2, v4
		v_exp_f32_e32 v208, v5
		v_exp_f32_e32 v4, v8
		v_exp_f32_e32 v210, v9
		v_exp_f32_e32 v8, v10
		v_exp_f32_e32 v212, v11
		v_exp_f32_e32 v10, v14
		v_exp_f32_e32 v214, v15
		v_exp_f32_e32 v14, v16
		v_exp_f32_e32 v216, v17
		v_exp_f32_e32 v16, v18
		v_exp_f32_e32 v218, v19
		v_exp_f32_e32 v25, v20
		v_exp_f32_e32 v201, v21
		v_exp_f32_e32 v203, v22
		v_exp_f32_e32 v207, v23
		v_exp_f32_e32 v3, v26
		v_exp_f32_e32 v209, v27
		v_exp_f32_e32 v5, v160
		v_exp_f32_e32 v211, v161
		v_exp_f32_e32 v9, v162
		v_exp_f32_e32 v213, v163
		v_exp_f32_e32 v11, v164
		v_exp_f32_e32 v215, v165
		v_exp_f32_e32 v15, v166
		v_exp_f32_e32 v217, v167
		v_exp_f32_e32 v17, v168
		v_exp_f32_e32 v219, v169
		v_exp_f32_e32 v18, v204
		v_exp_f32_e32 v20, v205
		v_exp_f32_e32 v22, v172
		v_exp_f32_e32 v26, v173
		v_exp_f32_e32 v160, v174
		v_exp_f32_e32 v162, v175
		v_exp_f32_e32 v164, v176
		v_exp_f32_e32 v166, v177
		v_exp_f32_e32 v168, v178
		v_exp_f32_e32 v172, v179
		v_exp_f32_e32 v174, v180
		v_exp_f32_e32 v176, v181
		v_exp_f32_e32 v178, v182
		v_exp_f32_e32 v180, v183
		v_exp_f32_e32 v183, v184
		v_exp_f32_e32 v205, v185
		v_exp_f32_e32 v19, v186
		v_exp_f32_e32 v21, v187
		v_exp_f32_e32 v23, v188
		v_exp_f32_e32 v27, v189
		v_exp_f32_e32 v161, v190
		v_exp_f32_e32 v163, v191
		v_exp_f32_e32 v165, v192
		v_exp_f32_e32 v167, v193
		v_exp_f32_e32 v169, v194
		v_exp_f32_e32 v173, v195
		v_exp_f32_e32 v175, v196
		v_exp_f32_e32 v177, v197
		v_exp_f32_e32 v179, v198
		v_exp_f32_e32 v181, v199
		v_pk_add_f32 v[184:185], v[24:25], v[200:201]
		v_pk_add_f32 v[186:187], v[202:203], v[206:207]
		v_pk_add_f32 v[188:189], v[2:3], v[208:209]
		v_pk_add_f32 v[190:191], v[4:5], v[210:211]
		v_pk_add_f32 v[192:193], v[8:9], v[212:213]
		v_pk_add_f32 v[194:195], v[10:11], v[214:215]
		v_pk_add_f32 v[196:197], v[14:15], v[216:217]
		v_pk_add_f32 v[198:199], v[16:17], v[218:219]
		v_pk_add_f32 v[184:185], v[184:185], v[186:187]
		v_pk_add_f32 v[186:187], v[188:189], v[190:191]
		v_pk_add_f32 v[188:189], v[192:193], v[194:195]
		v_pk_add_f32 v[190:191], v[196:197], v[198:199]
		v_pk_add_f32 v[184:185], v[184:185], v[186:187]
		v_pk_add_f32 v[186:187], v[188:189], v[190:191]
		v_pk_add_f32 v[188:189], v[184:185], v[186:187]
		v_add_f32_e32 v184, v188, v189
		v_mov_b32_e32 v185, v184
		v_exp_f32_e32 v182, v170
		v_exp_f32_e32 v204, v171
		v_permlane32_swap_b32_e32 v184, v185
		v_pk_add_f32 v[170:171], v[182:183], v[204:205]
		v_pk_add_f32 v[186:187], v[18:19], v[20:21]
		v_pk_add_f32 v[188:189], v[22:23], v[26:27]
		v_pk_add_f32 v[190:191], v[160:161], v[162:163]
		v_pk_add_f32 v[192:193], v[164:165], v[166:167]
		v_pk_add_f32 v[194:195], v[168:169], v[172:173]
		v_pk_add_f32 v[196:197], v[174:175], v[176:177]
		v_pk_add_f32 v[198:199], v[178:179], v[180:181]
		v_pk_add_f32 v[170:171], v[170:171], v[186:187]
		v_pk_add_f32 v[186:187], v[188:189], v[190:191]
		v_pk_add_f32 v[188:189], v[192:193], v[194:195]
		v_pk_add_f32 v[190:191], v[196:197], v[198:199]
		v_pk_add_f32 v[170:171], v[170:171], v[186:187]
		v_pk_add_f32 v[186:187], v[188:189], v[190:191]
		v_pk_add_f32 v[188:189], v[170:171], v[186:187]
		v_mov_b32_e32 v170, v185
		v_mov_b32_e32 v171, v189
		v_mov_b32_e32 v186, v184
		v_mov_b32_e32 v187, v188
		v_pk_add_f32 v[184:185], v[186:187], v[170:171]
		v_mov_b32_e32 v170, v185
		v_mov_b32_e32 v171, v185
		v_pk_add_f32 v[186:187], v[30:31], v[6:7] neg_lo:[0,1] neg_hi:[0,1]
		v_cvt_pk_bf16_f32 v188, v24, v200
		v_permlane32_swap_b32_e32 v170, v171
		v_add_f32_e32 v7, v170, v171
		v_exp_f32_e32 v30, v186
		v_exp_f32_e32 v31, v187
		v_cvt_pk_bf16_f32 v189, v202, v206
		v_pk_mul_f32 v[224:225], v[32:33], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[226:227], v[34:35], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[228:229], v[36:37], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[230:231], v[38:39], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[232:233], v[40:41], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[234:235], v[42:43], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[236:237], v[44:45], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[238:239], v[46:47], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[32:33], v[48:49], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[34:35], v[50:51], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[36:37], v[52:53], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[38:39], v[54:55], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[40:41], v[56:57], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[42:43], v[58:59], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[44:45], v[60:61], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[46:47], v[62:63], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[64:65], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[66:67], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[68:69], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[70:71], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[72:73], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[74:75], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[76:77], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[78:79], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[80:81], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[66:67], v[82:83], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[68:69], v[84:85], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[70:71], v[86:87], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[72:73], v[88:89], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[74:75], v[90:91], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[76:77], v[92:93], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[78:79], v[94:95], v[30:31] op_sel_hi:[1,0]
		v_pk_mul_f32 v[80:81], v[96:97], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[82:83], v[98:99], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[84:85], v[100:101], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[86:87], v[102:103], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[88:89], v[104:105], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[90:91], v[106:107], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[92:93], v[108:109], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[94:95], v[110:111], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[96:97], v[112:113], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[98:99], v[114:115], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[100:101], v[116:117], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[102:103], v[118:119], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[104:105], v[120:121], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[106:107], v[122:123], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[108:109], v[124:125], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[110:111], v[126:127], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[112:113], v[128:129], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[114:115], v[130:131], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[116:117], v[132:133], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[118:119], v[134:135], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[120:121], v[136:137], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[122:123], v[138:139], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[124:125], v[140:141], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[126:127], v[142:143], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[128:129], v[144:145], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[130:131], v[146:147], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[132:133], v[148:149], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[134:135], v[150:151], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[136:137], v[152:153], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[138:139], v[154:155], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[140:141], v[156:157], v[30:31] op_sel:[0,1]
		v_pk_mul_f32 v[142:143], v[158:159], v[30:31] op_sel:[0,1]
		v_mov_b32_e32 v6, v184
		v_pk_fma_f32 v[144:145], v[28:29], v[30:31], v[6:7]
		v_cvt_pk_bf16_f32 v190, v2, v208
		v_cvt_pk_bf16_f32 v191, v4, v210
		v_cvt_pk_bf16_f32 v28, v8, v212
		v_cvt_pk_bf16_f32 v29, v10, v214
		v_cvt_pk_bf16_f32 v30, v14, v216
		v_cvt_pk_bf16_f32 v31, v16, v218
		v_cvt_pk_bf16_f32 v148, v25, v201
		v_cvt_pk_bf16_f32 v149, v203, v207
		v_cvt_pk_bf16_f32 v150, v3, v209
		v_cvt_pk_bf16_f32 v151, v5, v211
		v_cvt_pk_bf16_f32 v4, v9, v213
		v_cvt_pk_bf16_f32 v5, v11, v215
		v_cvt_pk_bf16_f32 v6, v15, v217
		v_cvt_pk_bf16_f32 v7, v17, v219
		v_cvt_pk_bf16_f32 v8, v182, v204
		v_cvt_pk_bf16_f32 v9, v18, v20
		v_cvt_pk_bf16_f32 v10, v22, v26
		v_cvt_pk_bf16_f32 v11, v160, v162
		v_cvt_pk_bf16_f32 v152, v164, v166
		v_cvt_pk_bf16_f32 v153, v168, v172
		v_cvt_pk_bf16_f32 v154, v174, v176
		v_cvt_pk_bf16_f32 v155, v178, v180
		v_cvt_pk_bf16_f32 v156, v183, v205
		v_cvt_pk_bf16_f32 v157, v19, v21
		v_cvt_pk_bf16_f32 v158, v23, v27
		v_cvt_pk_bf16_f32 v159, v161, v163
		v_cvt_pk_bf16_f32 v16, v165, v167
		v_cvt_pk_bf16_f32 v17, v169, v173
		v_cvt_pk_bf16_f32 v18, v175, v177
		v_cvt_pk_bf16_f32 v19, v179, v181
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[224:239], a[92:95], v[188:191], v[224:239]
		v_permlane32_swap_b32_e32 v148, v150
		v_permlane32_swap_b32_e32 v149, v151
		v_permlane32_swap_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v5, v7
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
		v_permlane32_swap_b32_e32 v152, v154
		v_permlane32_swap_b32_e32 v153, v155
		v_mfma_f32_32x32x16_bf16 v[32:47], a[108:111], v[188:191], v[32:47]
		v_permlane32_swap_b32_e32 v156, v158
		v_permlane32_swap_b32_e32 v157, v159
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_add3_u32 v2, s4, v0, v1
		v_cndmask_b32_e64 v2, v13, v2, s[12:13]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[124:127], v[188:191], v[48:63]
		s_add_i32 s4, s11, s3
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_32x32x16_bf16 v[64:79], a[140:143], v[188:191], v[64:79]
		s_add_i32 s4, s4, s0
		v_mfma_f32_32x32x16_bf16 v[128:143], a[140:143], v[8:11], v[128:143]
		s_add_i32 s4, s4, s2
		v_mfma_f32_32x32x16_bf16 v[80:95], a[92:95], v[8:11], v[80:95]
		s_add_i32 s11, s1, 0xc0
		v_mfma_f32_32x32x16_bf16 v[96:111], a[108:111], v[8:11], v[96:111]
		s_add_i32 s11, s11, s3
		v_mfma_f32_32x32x16_bf16 v[112:127], a[124:127], v[8:11], v[112:127]
		s_add_i32 s11, s11, s0
		v_mfma_f32_32x32x16_bf16 v[224:239], a[96:99], v[28:31], v[224:239]
		s_add_i32 s11, s11, s2
		v_mfma_f32_32x32x16_bf16 v[32:47], a[112:115], v[28:31], v[32:47]
		s_add_i32 s14, s1, 0xe0
		v_mfma_f32_32x32x16_bf16 v[48:63], a[128:131], v[28:31], v[48:63]
		s_add_i32 s14, s14, s3
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_32x32x16_bf16 v[64:79], a[144:147], v[28:31], v[64:79]
		s_add_i32 s14, s14, s0
		v_mfma_f32_32x32x16_bf16 v[128:143], a[144:147], v[152:155], v[128:143]
		s_add_i32 s14, s14, s2
		v_mfma_f32_32x32x16_bf16 v[80:95], a[96:99], v[152:155], v[80:95]
		s_lshl_b32 s15, s23, 8
		v_mfma_f32_32x32x16_bf16 v[96:111], a[112:115], v[152:155], v[96:111]
		s_add_i32 s16, s15, s1
		v_mfma_f32_32x32x16_bf16 v[112:127], a[128:131], v[152:155], v[112:127]
		s_add_i32 s16, s16, s3
		v_mfma_f32_32x32x16_bf16 v[224:239], a[100:103], v[148:151], v[224:239]
		s_add_i32 s16, s16, s0
		v_mfma_f32_32x32x16_bf16 v[32:47], a[116:119], v[148:151], v[32:47]
		s_add_i32 s16, s16, s2
		v_mfma_f32_32x32x16_bf16 v[48:63], a[132:135], v[148:151], v[48:63]
		s_add_i32 s17, s15, 32
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_32x32x16_bf16 v[64:79], a[148:151], v[148:151], v[64:79]
		s_add_i32 s17, s17, s1
		v_mfma_f32_32x32x16_bf16 v[128:143], a[148:151], v[156:159], v[128:143]
		s_add_i32 s17, s17, s3
		v_mfma_f32_32x32x16_bf16 v[80:95], a[100:103], v[156:159], v[80:95]
		s_add_i32 s17, s17, s0
		v_mfma_f32_32x32x16_bf16 v[96:111], a[116:119], v[156:159], v[96:111]
		s_add_i32 s17, s17, s2
		v_mfma_f32_32x32x16_bf16 v[112:127], a[132:135], v[156:159], v[112:127]
		s_add_i32 s18, s15, 64
		v_mfma_f32_32x32x16_bf16 v[224:239], a[104:107], v[4:7], v[224:239]
		s_add_i32 s18, s18, s1
		v_mfma_f32_32x32x16_bf16 v[32:47], a[120:123], v[4:7], v[32:47]
		s_add_i32 s18, s18, s3
		v_mfma_f32_32x32x16_bf16 v[48:63], a[136:139], v[4:7], v[48:63]
		s_add_i32 s18, s18, s0
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_32x32x16_bf16 v[64:79], a[152:155], v[4:7], v[64:79]
		s_add_i32 s18, s18, s2
		v_mfma_f32_32x32x16_bf16 v[128:143], a[152:155], v[16:19], v[128:143]
		s_add_i32 s19, s15, 0x60
		v_mfma_f32_32x32x16_bf16 v[80:95], a[104:107], v[16:19], v[80:95]
		s_add_i32 s19, s19, s1
		v_mfma_f32_32x32x16_bf16 v[96:111], a[120:123], v[16:19], v[96:111]
		s_add_i32 s19, s19, s3
		v_mfma_f32_32x32x16_bf16 v[112:127], a[136:139], v[16:19], v[112:127]
		s_add_i32 s19, s19, s0
		v_rcp_f32_e32 v4, v144
		s_add_i32 s19, s19, s2
		v_mov_b32_e32 v5, v4
		v_pk_mul_f32 v[6:7], v[224:225], v[4:5]
		v_pk_mul_f32 v[8:9], v[226:227], v[4:5]
		v_pk_mul_f32 v[10:11], v[228:229], v[4:5]
		v_pk_mul_f32 v[14:15], v[230:231], v[4:5]
		v_pk_mul_f32 v[16:17], v[232:233], v[4:5]
		v_pk_mul_f32 v[18:19], v[234:235], v[4:5]
		v_pk_mul_f32 v[20:21], v[236:237], v[4:5]
		v_pk_mul_f32 v[22:23], v[238:239], v[4:5]
		v_pk_mul_f32 v[24:25], v[32:33], v[4:5]
		v_pk_mul_f32 v[26:27], v[34:35], v[4:5]
		v_pk_mul_f32 v[28:29], v[36:37], v[4:5]
		v_pk_mul_f32 v[30:31], v[38:39], v[4:5]
		v_pk_mul_f32 v[32:33], v[40:41], v[4:5]
		v_pk_mul_f32 v[34:35], v[42:43], v[4:5]
		v_pk_mul_f32 v[36:37], v[44:45], v[4:5]
		v_pk_mul_f32 v[38:39], v[46:47], v[4:5]
		v_pk_mul_f32 v[40:41], v[48:49], v[4:5]
		v_pk_mul_f32 v[42:43], v[50:51], v[4:5]
		v_pk_mul_f32 v[44:45], v[52:53], v[4:5]
		v_pk_mul_f32 v[46:47], v[54:55], v[4:5]
		v_pk_mul_f32 v[48:49], v[56:57], v[4:5]
		v_pk_mul_f32 v[50:51], v[58:59], v[4:5]
		v_pk_mul_f32 v[52:53], v[60:61], v[4:5]
		v_pk_mul_f32 v[54:55], v[62:63], v[4:5]
		v_pk_mul_f32 v[56:57], v[64:65], v[4:5]
		v_pk_mul_f32 v[58:59], v[66:67], v[4:5]
		v_pk_mul_f32 v[60:61], v[68:69], v[4:5]
		v_pk_mul_f32 v[62:63], v[70:71], v[4:5]
		v_pk_mul_f32 v[64:65], v[72:73], v[4:5]
		v_pk_mul_f32 v[66:67], v[74:75], v[4:5]
		v_pk_mul_f32 v[68:69], v[76:77], v[4:5]
		v_pk_mul_f32 v[70:71], v[78:79], v[4:5]
		v_rcp_f32_e32 v4, v145
		v_cvt_pk_bf16_f32 v72, v6, v7
		v_mov_b32_e32 v5, v4
		v_pk_mul_f32 v[6:7], v[80:81], v[4:5]
		v_pk_mul_f32 v[76:77], v[82:83], v[4:5]
		v_pk_mul_f32 v[78:79], v[84:85], v[4:5]
		v_pk_mul_f32 v[80:81], v[86:87], v[4:5]
		v_pk_mul_f32 v[82:83], v[88:89], v[4:5]
		v_pk_mul_f32 v[84:85], v[90:91], v[4:5]
		v_pk_mul_f32 v[86:87], v[92:93], v[4:5]
		v_pk_mul_f32 v[88:89], v[94:95], v[4:5]
		v_pk_mul_f32 v[90:91], v[96:97], v[4:5]
		v_pk_mul_f32 v[92:93], v[98:99], v[4:5]
		v_pk_mul_f32 v[94:95], v[100:101], v[4:5]
		v_pk_mul_f32 v[96:97], v[102:103], v[4:5]
		v_pk_mul_f32 v[98:99], v[104:105], v[4:5]
		v_pk_mul_f32 v[100:101], v[106:107], v[4:5]
		v_pk_mul_f32 v[102:103], v[108:109], v[4:5]
		v_pk_mul_f32 v[104:105], v[110:111], v[4:5]
		v_pk_mul_f32 v[106:107], v[112:113], v[4:5]
		v_pk_mul_f32 v[108:109], v[114:115], v[4:5]
		v_pk_mul_f32 v[110:111], v[116:117], v[4:5]
		v_pk_mul_f32 v[112:113], v[118:119], v[4:5]
		v_pk_mul_f32 v[114:115], v[120:121], v[4:5]
		v_pk_mul_f32 v[116:117], v[122:123], v[4:5]
		v_pk_mul_f32 v[118:119], v[124:125], v[4:5]
		v_pk_mul_f32 v[120:121], v[126:127], v[4:5]
		v_pk_mul_f32 v[122:123], v[128:129], v[4:5]
		v_pk_mul_f32 v[124:125], v[130:131], v[4:5]
		v_pk_mul_f32 v[126:127], v[132:133], v[4:5]
		v_pk_mul_f32 v[128:129], v[134:135], v[4:5]
		v_pk_mul_f32 v[130:131], v[136:137], v[4:5]
		v_pk_mul_f32 v[132:133], v[138:139], v[4:5]
		v_pk_mul_f32 v[134:135], v[140:141], v[4:5]
		v_pk_mul_f32 v[136:137], v[142:143], v[4:5]
		v_cvt_pk_bf16_f32 v73, v8, v9
		v_cvt_pk_bf16_f32 v74, v10, v11
		v_cvt_pk_bf16_f32 v75, v14, v15
		v_cvt_pk_bf16_f32 v8, v16, v17
		v_cvt_pk_bf16_f32 v9, v18, v19
		v_cvt_pk_bf16_f32 v10, v20, v21
		v_cvt_pk_bf16_f32 v11, v22, v23
		v_cvt_pk_bf16_f32 v16, v24, v25
		v_cvt_pk_bf16_f32 v17, v26, v27
		v_cvt_pk_bf16_f32 v18, v28, v29
		v_cvt_pk_bf16_f32 v19, v30, v31
		v_cvt_pk_bf16_f32 v20, v32, v33
		v_cvt_pk_bf16_f32 v21, v34, v35
		v_cvt_pk_bf16_f32 v22, v36, v37
		v_cvt_pk_bf16_f32 v23, v38, v39
		v_cvt_pk_bf16_f32 v24, v40, v41
		v_cvt_pk_bf16_f32 v25, v42, v43
		v_cvt_pk_bf16_f32 v26, v44, v45
		v_cvt_pk_bf16_f32 v27, v46, v47
		v_cvt_pk_bf16_f32 v28, v48, v49
		v_cvt_pk_bf16_f32 v29, v50, v51
		v_cvt_pk_bf16_f32 v30, v52, v53
		v_cvt_pk_bf16_f32 v31, v54, v55
		v_cvt_pk_bf16_f32 v32, v56, v57
		v_cvt_pk_bf16_f32 v33, v58, v59
		v_cvt_pk_bf16_f32 v34, v60, v61
		v_cvt_pk_bf16_f32 v35, v62, v63
		v_cvt_pk_bf16_f32 v36, v64, v65
		v_cvt_pk_bf16_f32 v37, v66, v67
		v_cvt_pk_bf16_f32 v38, v68, v69
		v_cvt_pk_bf16_f32 v39, v70, v71
		v_cvt_pk_bf16_f32 v40, v6, v7
		v_cvt_pk_bf16_f32 v41, v76, v77
		v_cvt_pk_bf16_f32 v42, v78, v79
		v_cvt_pk_bf16_f32 v43, v80, v81
		v_cvt_pk_bf16_f32 v4, v82, v83
		v_cvt_pk_bf16_f32 v5, v84, v85
		v_cvt_pk_bf16_f32 v6, v86, v87
		v_cvt_pk_bf16_f32 v7, v88, v89
		v_cvt_pk_bf16_f32 v44, v90, v91
		v_cvt_pk_bf16_f32 v45, v92, v93
		v_cvt_pk_bf16_f32 v46, v94, v95
		v_cvt_pk_bf16_f32 v47, v96, v97
		v_cvt_pk_bf16_f32 v48, v98, v99
		v_cvt_pk_bf16_f32 v49, v100, v101
		v_cvt_pk_bf16_f32 v50, v102, v103
		v_cvt_pk_bf16_f32 v51, v104, v105
		v_cvt_pk_bf16_f32 v52, v106, v107
		v_cvt_pk_bf16_f32 v53, v108, v109
		v_cvt_pk_bf16_f32 v54, v110, v111
		v_cvt_pk_bf16_f32 v55, v112, v113
		v_cvt_pk_bf16_f32 v56, v114, v115
		v_cvt_pk_bf16_f32 v57, v116, v117
		v_cvt_pk_bf16_f32 v58, v118, v119
		v_cvt_pk_bf16_f32 v59, v120, v121
		v_cvt_pk_bf16_f32 v60, v122, v123
		v_cvt_pk_bf16_f32 v61, v124, v125
		v_cvt_pk_bf16_f32 v62, v126, v127
		v_cvt_pk_bf16_f32 v63, v128, v129
		v_cvt_pk_bf16_f32 v64, v130, v131
		v_cvt_pk_bf16_f32 v65, v132, v133
		v_cvt_pk_bf16_f32 v66, v134, v135
		v_cvt_pk_bf16_f32 v67, v136, v137
		v_permlane32_swap_b32_e32 v72, v74
		v_permlane32_swap_b32_e32 v73, v75
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
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
		v_permlane32_swap_b32_e32 v40, v42
		v_permlane32_swap_b32_e32 v41, v43
		v_permlane32_swap_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v5, v7
		v_permlane32_swap_b32_e32 v44, v46
		v_permlane32_swap_b32_e32 v45, v47
		v_permlane32_swap_b32_e32 v48, v50
		v_permlane32_swap_b32_e32 v49, v51
		v_permlane32_swap_b32_e32 v52, v54
		v_permlane32_swap_b32_e32 v53, v55
		v_permlane32_swap_b32_e32 v56, v58
		v_permlane32_swap_b32_e32 v57, v59
		v_permlane32_swap_b32_e32 v60, v62
		v_permlane32_swap_b32_e32 v61, v63
		v_permlane32_swap_b32_e32 v64, v66
		v_permlane32_swap_b32_e32 v65, v67
		s_mov_b32 s20, s8
		s_mov_b32 s21, s9
		s_mov_b32 s22, s34
		s_mov_b32 s23, s35
		buffer_store_dwordx4 v[72:75], v2, s[20:23], 0 offen
		v_add3_u32 v2, s5, v0, v1
		v_cndmask_b32_e64 v2, v13, v2, s[12:13]
		buffer_store_dwordx4 v[8:11], v2, s[20:23], 0 offen
		v_add3_u32 v2, s6, v0, v1
		v_cndmask_b32_e64 v2, v13, v2, s[12:13]
		buffer_store_dwordx4 v[16:19], v2, s[20:23], 0 offen
		v_add3_u32 v2, s7, v0, v1
		v_cndmask_b32_e64 v2, v13, v2, s[12:13]
		buffer_store_dwordx4 v[20:23], v2, s[20:23], 0 offen
		v_add3_u32 v2, s10, v0, v1
		v_cndmask_b32_e64 v2, v13, v2, s[12:13]
		buffer_store_dwordx4 v[24:27], v2, s[20:23], 0 offen
		v_add3_u32 v2, s4, v0, v1
		v_cndmask_b32_e64 v2, v13, v2, s[12:13]
		buffer_store_dwordx4 v[28:31], v2, s[20:23], 0 offen
		v_add3_u32 v2, s11, v0, v1
		v_cndmask_b32_e64 v2, v13, v2, s[12:13]
		buffer_store_dwordx4 v[32:35], v2, s[20:23], 0 offen
		v_add3_u32 v2, s14, v0, v1
		v_cndmask_b32_e64 v2, v13, v2, s[12:13]
		buffer_store_dwordx4 v[36:39], v2, s[20:23], 0 offen
		v_add3_u32 v2, s16, v0, v1
		v_cndmask_b32_e64 v2, v13, v2, s[28:29]
		buffer_store_dwordx4 v[40:43], v2, s[20:23], 0 offen
		v_add3_u32 v2, s17, v0, v1
		v_cndmask_b32_e64 v2, v13, v2, s[28:29]
		buffer_store_dwordx4 v[4:7], v2, s[20:23], 0 offen
		v_add3_u32 v2, s18, v0, v1
		v_cndmask_b32_e64 v2, v13, v2, s[28:29]
		buffer_store_dwordx4 v[44:47], v2, s[20:23], 0 offen
		v_add3_u32 v2, s19, v0, v1
		v_cndmask_b32_e64 v2, v13, v2, s[28:29]
		buffer_store_dwordx4 v[48:51], v2, s[20:23], 0 offen
		s_add_i32 s4, s15, 0x80
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s3
		s_add_i32 s4, s4, s0
		s_add_i32 s4, s4, s2
		v_add3_u32 v2, s4, v0, v1
		v_cndmask_b32_e64 v2, v13, v2, s[28:29]
		buffer_store_dwordx4 v[52:55], v2, s[20:23], 0 offen
		s_add_i32 s4, s15, 0xa0
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s3
		s_add_i32 s4, s4, s0
		s_add_i32 s4, s4, s2
		v_add3_u32 v2, s4, v0, v1
		v_cndmask_b32_e64 v2, v13, v2, s[28:29]
		buffer_store_dwordx4 v[56:59], v2, s[20:23], 0 offen
		s_add_i32 s4, s15, 0xc0
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s3
		s_add_i32 s4, s4, s0
		s_add_i32 s4, s4, s2
		v_add3_u32 v2, s4, v0, v1
		v_cndmask_b32_e64 v2, v13, v2, s[28:29]
		buffer_store_dwordx4 v[60:63], v2, s[20:23], 0 offen
		s_add_i32 s4, s15, 0xe0
		s_add_i32 s1, s4, s1
		s_add_i32 s1, s1, s3
		s_add_i32 s0, s1, s0
		s_add_i32 s0, s0, s2
		v_add3_u32 v0, s0, v0, v1
		v_cndmask_b32_e64 v0, v13, v0, s[28:29]
		buffer_store_dwordx4 v[64:67], v0, s[20:23], 0 offen
		s_endpgm
	.size	_attn_fwd_async_prefetch, .-_attn_fwd_async_prefetch
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _attn_fwd_async_prefetch
		.amdhsa_group_segment_fixed_size 100784
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 96
		.amdhsa_user_sgpr_count 16
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_user_sgpr_kernarg_preload_length 14
		.amdhsa_user_sgpr_kernarg_preload_offset 0
		.amdhsa_enable_private_segment 0
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 1
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 416
		.amdhsa_next_free_sgpr 46
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
	.set .L_attn_fwd_async_prefetch.num_vgpr, 256
	.set .L_attn_fwd_async_prefetch.num_agpr, 160
	.set .L_attn_fwd_async_prefetch.numbered_sgpr, 46
	.set .L_attn_fwd_async_prefetch.num_named_barrier, 0
	.set .L_attn_fwd_async_prefetch.private_seg_size, 0
	.set .L_attn_fwd_async_prefetch.uses_vcc, 1
	.set .L_attn_fwd_async_prefetch.uses_flat_scratch, 0
	.set .L_attn_fwd_async_prefetch.has_dyn_sized_stack, 0
	.set .L_attn_fwd_async_prefetch.has_recursion, 0
	.set .L_attn_fwd_async_prefetch.has_indirect_call, 0
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
      - .name:           arg4
        .offset:         32
        .size:           4
        .value_kind:     by_value
      - .name:           arg5
        .offset:         36
        .size:           4
        .value_kind:     by_value
      - .name:           arg6
        .offset:         40
        .size:           4
        .value_kind:     by_value
      - .name:           arg7
        .offset:         44
        .size:           4
        .value_kind:     by_value
      - .name:           arg8
        .offset:         48
        .size:           4
        .value_kind:     by_value
      - .name:           arg9
        .offset:         52
        .size:           4
        .value_kind:     by_value
      - .name:           arg10
        .offset:         56
        .size:           4
        .value_kind:     by_value
      - .name:           arg11
        .offset:         60
        .size:           4
        .value_kind:     by_value
      - .name:           arg12
        .offset:         64
        .size:           4
        .value_kind:     by_value
      - .name:           arg13
        .offset:         68
        .size:           4
        .value_kind:     by_value
      - .name:           arg14
        .offset:         72
        .size:           4
        .value_kind:     by_value
      - .name:           arg15
        .offset:         76
        .size:           4
        .value_kind:     by_value
      - .name:           arg16
        .offset:         80
        .size:           4
        .value_kind:     by_value
      - .name:           arg17
        .offset:         84
        .size:           4
        .value_kind:     by_value
      - .name:           arg18
        .offset:         88
        .size:           4
        .value_kind:     by_value
    .group_segment_fixed_size: 100784
    .kernarg_segment_align: 8
    .kernarg_segment_size: 96
    .max_flat_workgroup_size: 256
    .name:           _attn_fwd_async_prefetch
    .private_segment_fixed_size: 0
    .sgpr_count:     46
    .sgpr_spill_count: 0
    .symbol:         _attn_fwd_async_prefetch.kd
    .uses_dynamic_stack: false
    .vgpr_count:     416
    .agpr_count:     160
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 64
    wave.regalloc.agpr.dwords: 252
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
