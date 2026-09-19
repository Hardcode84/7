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
		s_add_i32 s24, s19, s3
		s_add_i32 s24, s24, s4
		s_add_i32 s24, s24, s7
		s_mul_i32 s27, 0x88, s15
		s_add_i32 s27, s27, s3
		s_add_i32 s27, s27, s4
		s_add_i32 s27, s27, s7
		v_add_u32_e32 v10, v19, v21
		s_mul_i32 s30, 0x90, s15
		s_add_i32 s30, s30, s3
		s_add_i32 s30, s30, s4
		s_add_i32 s30, s30, s7
		v_add3_u32 v12, v11, v10, s30
		s_mul_i32 s30, 0x98, s15
		s_add_i32 s3, s30, s3
		s_add_i32 s3, s3, s4
		s_add_i32 s3, s3, s7
		v_add3_u32 v18, v11, v10, s3
		s_lshl_b32 s3, s20, 7
		s_add_i32 s3, s3, s1
		s_add_i32 s3, s3, s11
		s_add_i32 s3, s3, s18
		s_mul_i32 s4, 0x88, s20
		s_add_i32 s4, s4, s1
		s_add_i32 s4, s4, s11
		s_add_i32 s4, s4, s18
		s_mul_i32 s7, 0x90, s20
		s_add_i32 s7, s7, s1
		s_add_i32 s7, s7, s11
		s_add_i32 s7, s7, s18
		s_mul_i32 s30, 0x98, s20
		s_add_i32 s1, s30, s1
		s_add_i32 s1, s1, s11
		s_add_i32 s1, s1, s18
		v_mov_b32_e32 v24, 0x3e0293ee
		v_mov_b32_e32 v25, 0x3e0293ee
		v_lshlrev_b32_e32 v10, 4, v14
		v_lshrrev_b32_e32 v23, 4, v4
		v_lshlrev_b32_e32 v23, 8, v23
		v_and_b32_e32 v4, 15, v4
		v_mov_b32_e32 v26, 0x410
		v_mul_lo_u32 v26, v26, v4
		v_add3_u32 v4, v10, v23, v26
		v_and_b32_e32 v10, 3, v0
		v_mov_b32_e32 v27, 0x2200
		v_mul_lo_u32 v27, v27, v5
		v_lshl_add_u32 v28, v10, 3, v27
		v_lshl_add_u32 v28, v1, 5, v28
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v29, 0x440
		v_mul_lo_u32 v29, v29, v15
		v_add3_u32 v15, v28, v8, v29
		s_cmp_lt_i32 0, s14
		v_mov_b32_e32 v30, 1.0
		v_mov_b32_e32 v31, 1.0
		v_mov_b32_e32 v32, 0xff800000
		v_mov_b32_e32 v33, 0xff800000
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
		v_mov_b64_e32 v[160:161], 0
		v_mov_b64_e32 v[162:163], 0
		v_mov_b64_e32 v[164:165], 0
		v_mov_b64_e32 v[166:167], 0
		v_mov_b64_e32 v[168:169], 0
		v_mov_b64_e32 v[170:171], 0
		v_mov_b64_e32 v[172:173], 0
		v_mov_b64_e32 v[174:175], 0
		s_cbranch_scc0 .L_attn_fwd_async_prefetch.loop_exit_0
.L_attn_fwd_async_prefetch.loop_head_0:
		s_waitcnt vmcnt(0)
		s_barrier
		s_lshr_b32 s11, s26, 6
		s_and_b32 s18, s11, 1
		s_mul_i32 s30, 0x4100, s18
		v_add_u32_e32 v28, s30, v4
		ds_read_b128 v[36:39], v28
		ds_read_b128 v[40:43], v28 offset:32
		ds_read_b128 v[44:47], v28 offset:64
		ds_read_b128 v[176:179], v28 offset:96
		ds_read_b128 v[180:183], v28 offset:128
		ds_read_b128 v[184:187], v28 offset:160
		ds_read_b128 v[188:191], v28 offset:192
		ds_read_b128 a[64:67], v28 offset:224
		ds_read_b128 v[192:195], v28 offset:512
		ds_read_b128 v[196:199], v28 offset:544
		ds_read_b128 v[200:203], v28 offset:576
		ds_read_b128 v[204:207], v28 offset:608
		ds_read_b128 a[68:71], v28 offset:640
		ds_read_b128 a[72:75], v28 offset:672
		ds_read_b128 a[76:79], v28 offset:704
		ds_read_b128 a[80:83], v28 offset:736
		s_mul_i32 s18, 0x4400, s18
		v_add_u32_e32 v28, s18, v15
		ds_read_b64_tr_b16 a[84:85], v28 offset:33264
		ds_read_b64_tr_b16 a[86:87], v28 offset:37616
		ds_read_b64_tr_b16 a[88:89], v28 offset:33520
		ds_read_b64_tr_b16 a[90:91], v28 offset:37872
		ds_read_b64_tr_b16 a[92:93], v28 offset:33776
		ds_read_b64_tr_b16 a[94:95], v28 offset:38128
		ds_read_b64_tr_b16 a[96:97], v28 offset:34032
		ds_read_b64_tr_b16 a[98:99], v28 offset:38384
		ds_read_b64_tr_b16 a[100:101], v28 offset:33328
		ds_read_b64_tr_b16 a[102:103], v28 offset:37680
		ds_read_b64_tr_b16 a[104:105], v28 offset:33584
		ds_read_b64_tr_b16 a[106:107], v28 offset:37936
		ds_read_b64_tr_b16 a[108:109], v28 offset:33840
		ds_read_b64_tr_b16 a[110:111], v28 offset:38192
		ds_read_b64_tr_b16 a[112:113], v28 offset:34096
		ds_read_b64_tr_b16 a[114:115], v28 offset:38448
		ds_read_b64_tr_b16 a[116:117], v28 offset:33392
		ds_read_b64_tr_b16 a[118:119], v28 offset:37744
		ds_read_b64_tr_b16 a[120:121], v28 offset:33648
		ds_read_b64_tr_b16 a[122:123], v28 offset:38000
		ds_read_b64_tr_b16 a[124:125], v28 offset:33904
		ds_read_b64_tr_b16 a[126:127], v28 offset:38256
		ds_read_b64_tr_b16 a[128:129], v28 offset:34160
		ds_read_b64_tr_b16 a[130:131], v28 offset:38512
		ds_read_b64_tr_b16 a[132:133], v28 offset:33456
		ds_read_b64_tr_b16 a[134:135], v28 offset:37808
		ds_read_b64_tr_b16 a[136:137], v28 offset:33712
		ds_read_b64_tr_b16 a[138:139], v28 offset:38064
		ds_read_b64_tr_b16 a[140:141], v28 offset:33968
		ds_read_b64_tr_b16 a[142:143], v28 offset:38320
		ds_read_b64_tr_b16 a[144:145], v28 offset:34224
		ds_read_b64_tr_b16 a[146:147], v28 offset:38576
		s_mul_i32 s18, s15, s26
		s_lshl_b32 s18, s18, 1
		s_add_i32 s30, s24, s18
		v_add_u32_e32 v28, s30, v19
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[208:223], v[36:39], a[0:3], 0
		v_add3_u32 v28, v28, v21, v11
		v_mfma_f32_32x32x16_bf16 v[208:223], v[40:43], a[4:7], v[208:223]
		s_add_i32 s11, s11, 1
		v_mfma_f32_32x32x16_bf16 v[208:223], v[44:47], a[8:11], v[208:223]
		s_and_b32 s11, s11, 1
		v_mfma_f32_32x32x16_bf16 v[208:223], v[176:179], a[12:15], v[208:223]
		s_mul_i32 s30, 0x4100, s11
		v_mfma_f32_32x32x16_bf16 v[208:223], v[180:183], a[16:19], v[208:223]
		s_add_i32 s30, s10, s30
		v_mfma_f32_32x32x16_bf16 v[208:223], v[184:187], a[20:23], v[208:223]
		s_mov_b32 m0, s30
		v_mfma_f32_32x32x16_bf16 v[208:223], v[188:191], a[24:27], v[208:223]
		s_add_i32 s18, s27, s18
		v_mfma_f32_32x32x16_bf16 v[224:239], v[36:39], a[32:35], 0
		v_add_u32_e32 v34, s18, v19
		v_mfma_f32_32x32x16_bf16 v[224:239], v[40:43], a[36:39], v[224:239]
		v_add3_u32 v34, v34, v21, v11
		v_mfma_f32_32x32x16_bf16 v[224:239], v[44:47], a[40:43], v[224:239]
		s_mul_i32 s18, s20, s26
		v_mfma_f32_32x32x16_bf16 v[224:239], v[176:179], a[44:47], v[224:239]
		s_add_i32 s26, s26, 64
		v_mfma_f32_32x32x16_bf16 v[224:239], v[180:183], a[48:51], v[224:239]
		v_add_u32_e32 v35, s26, v16
		v_mfma_f32_32x32x16_bf16 v[224:239], v[184:187], a[52:55], v[224:239]
		v_add_u32_e32 v36, s26, v9
		v_mfma_f32_32x32x16_bf16 v[224:239], v[188:191], a[56:59], v[224:239]
		v_add_u32_e32 v37, s26, v17
		v_mfma_f32_32x32x16_bf16 v[176:191], v[192:195], a[0:3], 0
		v_add_u32_e32 v38, s26, v3
		v_mfma_f32_32x32x16_bf16 v[176:191], v[196:199], a[4:7], v[176:191]
		v_cmp_lt_i32_e64 s[30:31], v35, s25
		v_mfma_f32_32x32x16_bf16 v[176:191], v[200:203], a[8:11], v[176:191]
		v_cmp_lt_i32_e64 vcc, v38, s25
		v_mfma_f32_32x32x16_bf16 v[176:191], v[204:207], a[12:15], v[176:191]
		v_cndmask_b32_e64 v28, v22, v28, s[30:31]
		buffer_load_dwordx4 v28, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[176:191], a[68:71], a[16:19], v[176:191]
		v_cmp_lt_i32_e64 s[40:41], v36, s25
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[42:43], v37, s25
		v_mfma_f32_32x32x16_bf16 v[176:191], a[72:75], a[20:23], v[176:191]
		v_cndmask_b32_e64 v28, v22, v34, s[40:41]
		buffer_load_dwordx4 v28, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[176:191], a[76:79], a[24:27], v[176:191]
		v_cndmask_b32_e64 v28, v22, v12, s[42:43]
		v_add_u32_e32 v12, s19, v12
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e32 v34, v22, v18, vcc
		buffer_load_dwordx4 v28, s[32:35], 0 offen lds
		s_lshl_b32 s18, s18, 1
		v_add_u32_e32 v18, s19, v18
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s44, s3, s18
		v_add_u32_e32 v28, s44, v2
		buffer_load_dwordx4 v34, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[240:255], v[192:195], a[32:35], 0
		v_add3_u32 v28, v28, v20, v11
		v_mfma_f32_32x32x16_bf16 v[240:255], v[196:199], a[36:39], v[240:255]
		s_mul_i32 s11, 0x4400, s11
		v_mfma_f32_32x32x16_bf16 v[240:255], v[200:203], a[40:43], v[240:255]
		s_add_i32 s11, s6, s11
		v_mfma_f32_32x32x16_bf16 v[240:255], v[204:207], a[44:47], v[240:255]
		s_add_i32 m0, s11, 0x81f0
		v_mfma_f32_32x32x16_bf16 v[240:255], a[68:71], a[48:51], v[240:255]
		v_cndmask_b32_e64 v28, v22, v28, s[30:31]
		buffer_load_dwordx4 v28, s[36:39], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[240:255], a[72:75], a[52:55], v[240:255]
		s_add_i32 s11, s4, s18
		v_mfma_f32_32x32x16_bf16 v[240:255], a[76:79], a[56:59], v[240:255]
		v_add_u32_e32 v28, s11, v2
		v_mfma_f32_32x32x16_bf16 v[208:223], a[64:67], a[28:31], v[208:223]
		v_add3_u32 v28, v28, v20, v11
		v_cndmask_b32_e64 v28, v22, v28, s[40:41]
		s_add_i32 m0, m0, 0x1100
		s_add_i32 s11, s7, s18
		buffer_load_dwordx4 v28, s[36:39], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], a[64:67], a[60:63], v[224:239]
		v_add_u32_e32 v28, s11, v2
		v_mfma_f32_32x32x16_bf16 v[176:191], a[80:83], a[28:31], v[176:191]
		v_add3_u32 v28, v28, v20, v11
		v_cndmask_b32_e64 v28, v22, v28, s[42:43]
		s_add_i32 m0, m0, 0x1100
		s_add_i32 s11, s1, s18
		buffer_load_dwordx4 v28, s[36:39], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[240:255], a[80:83], a[60:63], v[240:255]
		v_add_u32_e32 v28, s11, v2
		v_add3_u32 v28, v28, v20, v11
		v_cndmask_b32_e32 v28, v22, v28, vcc
		v_max3_f32 v34, v208, v209, v210
		s_add_i32 m0, m0, 0x1100
		v_max3_f32 v35, v212, v213, v214
		v_max3_f32 v36, v216, v217, v218
		v_max3_f32 v37, v220, v221, v222
		v_max3_f32 v38, v176, v177, v178
		v_max3_f32 v39, v180, v181, v182
		v_max3_f32 v40, v184, v185, v186
		v_max3_f32 v41, v188, v189, v190
		v_max3_f32 v34, v34, v211, v35
		v_max3_f32 v35, v36, v219, v37
		v_max3_f32 v36, v38, v179, v39
		v_max3_f32 v37, v40, v187, v41
		v_max3_f32 v34, v34, v215, v35
		v_max3_f32 v35, v36, v183, v37
		v_max3_f32 v34, v34, v223, v35
		v_max3_f32 v35, v224, v225, v226
		v_max3_f32 v36, v228, v229, v230
		buffer_load_dwordx4 v28, s[36:39], 0 offen lds
		v_max_f32_e32 v38, v34, v191
		v_mov_b32_e32 v39, v38
		v_max3_f32 v28, v232, v233, v234
		v_max3_f32 v34, v236, v237, v238
		v_max3_f32 v37, v240, v241, v242
		v_max3_f32 v40, v244, v245, v246
		v_max3_f32 v41, v248, v249, v250
		v_max3_f32 v42, v252, v253, v254
		v_max3_f32 v35, v35, v227, v36
		v_max3_f32 v28, v28, v235, v34
		v_max3_f32 v34, v37, v243, v40
		v_max3_f32 v36, v41, v251, v42
		v_max3_f32 v28, v35, v231, v28
		v_max3_f32 v34, v34, v247, v36
		v_max3_f32 v28, v28, v239, v34
		v_max_f32_e32 v34, v28, v255
		s_cmp_lt_i32 s26, s14
		v_mov_b32_e32 v35, v34
		v_permlane32_swap_b32_e32 v38, v39
		v_max_f32_e32 v36, v38, v39
		v_permlane32_swap_b32_e32 v34, v35
		v_max_f32_e32 v37, v34, v35
		v_pk_mul_f32 v[34:35], v[36:37], v[24:25]
		v_max_f32_e32 v36, v32, v34
		v_max_f32_e32 v37, v33, v35
		v_pk_fma_f32 v[34:35], v[208:209], v[24:25], v[36:37] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[38:39], v[210:211], v[24:25], v[36:37] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[40:41], v[212:213], v[24:25], v[36:37] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[42:43], v[214:215], v[24:25], v[36:37] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[44:45], v[216:217], v[24:25], v[36:37] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[46:47], v[218:219], v[24:25], v[36:37] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[220:221], v[24:25], v[36:37] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[222:223], v[24:25], v[36:37] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[176:177], v[24:25], v[36:37] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[178:179], v[24:25], v[36:37] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[180:181], v[24:25], v[36:37] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[182:183], v[24:25], v[36:37] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[184:185], v[24:25], v[36:37] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[186:187], v[24:25], v[36:37] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[188:189], v[24:25], v[36:37] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[190:191], v[24:25], v[36:37] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[224:225], v[24:25], v[36:37] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[226:227], v[24:25], v[36:37] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[228:229], v[24:25], v[36:37] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[230:231], v[24:25], v[36:37] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[232:233], v[24:25], v[36:37] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[234:235], v[24:25], v[36:37] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[236:237], v[24:25], v[36:37] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[238:239], v[24:25], v[36:37] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[240:241], v[24:25], v[36:37] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[242:243], v[24:25], v[36:37] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[244:245], v[24:25], v[36:37] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[218:219], v[246:247], v[24:25], v[36:37] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[220:221], v[248:249], v[24:25], v[36:37] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[222:223], v[250:251], v[24:25], v[36:37] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[224:225], v[252:253], v[24:25], v[36:37] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[226:227], v[254:255], v[24:25], v[36:37] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v228, v34
		v_exp_f32_e32 v230, v35
		v_exp_f32_e32 v34, v38
		v_exp_f32_e32 v232, v39
		v_exp_f32_e32 v38, v40
		v_exp_f32_e32 v234, v41
		v_exp_f32_e32 v40, v42
		v_exp_f32_e32 v236, v43
		v_exp_f32_e32 v42, v44
		v_exp_f32_e32 v238, v45
		v_exp_f32_e32 v44, v46
		v_exp_f32_e32 v240, v47
		v_exp_f32_e32 v46, v192
		v_exp_f32_e32 v242, v193
		v_exp_f32_e32 v192, v194
		v_exp_f32_e32 v244, v195
		v_exp_f32_e32 v229, v196
		v_exp_f32_e32 v231, v197
		v_exp_f32_e32 v35, v176
		v_exp_f32_e32 v233, v177
		v_exp_f32_e32 v39, v178
		v_exp_f32_e32 v235, v179
		v_exp_f32_e32 v41, v180
		v_exp_f32_e32 v237, v181
		v_exp_f32_e32 v43, v182
		v_exp_f32_e32 v239, v183
		v_exp_f32_e32 v45, v184
		v_exp_f32_e32 v241, v185
		v_exp_f32_e32 v47, v186
		v_exp_f32_e32 v243, v187
		v_exp_f32_e32 v193, v188
		v_exp_f32_e32 v245, v189
		v_exp_f32_e32 v176, v198
		v_exp_f32_e32 v178, v199
		v_exp_f32_e32 v180, v200
		v_exp_f32_e32 v182, v201
		v_exp_f32_e32 v184, v202
		v_exp_f32_e32 v186, v203
		v_exp_f32_e32 v188, v204
		v_exp_f32_e32 v194, v205
		v_exp_f32_e32 v196, v206
		v_exp_f32_e32 v198, v207
		v_exp_f32_e32 v200, v208
		v_exp_f32_e32 v202, v209
		v_exp_f32_e32 v204, v210
		v_exp_f32_e32 v206, v211
		v_exp_f32_e32 v209, v212
		v_exp_f32_e32 v211, v213
		v_exp_f32_e32 v177, v214
		v_exp_f32_e32 v179, v215
		v_exp_f32_e32 v181, v216
		v_exp_f32_e32 v183, v217
		v_exp_f32_e32 v185, v218
		v_exp_f32_e32 v187, v219
		v_exp_f32_e32 v189, v220
		v_exp_f32_e32 v195, v221
		v_exp_f32_e32 v197, v222
		v_exp_f32_e32 v199, v223
		v_exp_f32_e32 v201, v224
		v_exp_f32_e32 v203, v225
		v_exp_f32_e32 v205, v226
		v_exp_f32_e32 v207, v227
		v_pk_add_f32 v[212:213], v[228:229], v[230:231]
		v_pk_add_f32 v[214:215], v[34:35], v[232:233]
		v_pk_add_f32 v[216:217], v[38:39], v[234:235]
		v_pk_add_f32 v[218:219], v[40:41], v[236:237]
		v_pk_add_f32 v[220:221], v[42:43], v[238:239]
		v_pk_add_f32 v[222:223], v[44:45], v[240:241]
		v_pk_add_f32 v[224:225], v[46:47], v[242:243]
		v_pk_add_f32 v[226:227], v[192:193], v[244:245]
		v_pk_add_f32 v[212:213], v[212:213], v[214:215]
		v_pk_add_f32 v[214:215], v[216:217], v[218:219]
		v_pk_add_f32 v[216:217], v[220:221], v[222:223]
		v_pk_add_f32 v[218:219], v[224:225], v[226:227]
		v_pk_add_f32 v[212:213], v[212:213], v[214:215]
		v_pk_add_f32 v[214:215], v[216:217], v[218:219]
		v_pk_add_f32 v[216:217], v[212:213], v[214:215]
		v_add_f32_e32 v212, v216, v217
		v_mov_b32_e32 v213, v212
		v_exp_f32_e32 v208, v190
		v_exp_f32_e32 v210, v191
		v_permlane32_swap_b32_e32 v212, v213
		v_pk_add_f32 v[190:191], v[208:209], v[210:211]
		v_pk_add_f32 v[214:215], v[176:177], v[178:179]
		v_pk_add_f32 v[216:217], v[180:181], v[182:183]
		v_pk_add_f32 v[218:219], v[184:185], v[186:187]
		v_pk_add_f32 v[220:221], v[188:189], v[194:195]
		v_pk_add_f32 v[222:223], v[196:197], v[198:199]
		v_pk_add_f32 v[224:225], v[200:201], v[202:203]
		v_pk_add_f32 v[226:227], v[204:205], v[206:207]
		v_pk_add_f32 v[190:191], v[190:191], v[214:215]
		v_pk_add_f32 v[214:215], v[216:217], v[218:219]
		v_pk_add_f32 v[216:217], v[220:221], v[222:223]
		v_pk_add_f32 v[218:219], v[224:225], v[226:227]
		v_pk_add_f32 v[190:191], v[190:191], v[214:215]
		v_pk_add_f32 v[214:215], v[216:217], v[218:219]
		v_pk_add_f32 v[216:217], v[190:191], v[214:215]
		v_mov_b32_e32 v190, v213
		v_mov_b32_e32 v191, v217
		v_mov_b32_e32 v214, v212
		v_mov_b32_e32 v215, v216
		v_pk_add_f32 v[212:213], v[214:215], v[190:191]
		v_mov_b32_e32 v190, v213
		v_mov_b32_e32 v191, v213
		v_pk_add_f32 v[214:215], v[32:33], v[36:37] neg_lo:[0,1] neg_hi:[0,1]
		v_cvt_pk_bf16_f32 v216, v228, v230
		v_permlane32_swap_b32_e32 v190, v191
		v_add_f32_e32 v33, v190, v191
		v_exp_f32_e32 v190, v214
		v_exp_f32_e32 v191, v215
		v_cvt_pk_bf16_f32 v217, v34, v232
		v_mov_b32_e32 v32, v212
		v_pk_fma_f32 v[30:31], v[30:31], v[190:191], v[32:33]
		v_cvt_pk_bf16_f32 v218, v38, v234
		v_cvt_pk_bf16_f32 v219, v40, v236
		v_cvt_pk_bf16_f32 v212, v42, v238
		v_cvt_pk_bf16_f32 v213, v44, v240
		v_cvt_pk_bf16_f32 v214, v46, v242
		v_cvt_pk_bf16_f32 v215, v192, v244
		v_cvt_pk_bf16_f32 v220, v229, v231
		v_cvt_pk_bf16_f32 v221, v35, v233
		v_cvt_pk_bf16_f32 v222, v39, v235
		v_cvt_pk_bf16_f32 v223, v41, v237
		v_cvt_pk_bf16_f32 v32, v43, v239
		v_cvt_pk_bf16_f32 v33, v45, v241
		v_cvt_pk_bf16_f32 v34, v47, v243
		v_cvt_pk_bf16_f32 v35, v193, v245
		v_pk_mul_f32 v[48:49], v[48:49], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[50:51], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[52:53], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[54:55], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[56:57], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[58:59], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[60:61], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[62:63], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[64:65], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[66:67], v[66:67], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[68:69], v[68:69], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[70:71], v[70:71], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[72:73], v[72:73], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[74:75], v[74:75], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[76:77], v[76:77], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[78:79], v[78:79], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[80:81], v[80:81], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[82:83], v[82:83], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[84:85], v[84:85], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[86:87], v[86:87], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[88:89], v[88:89], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[90:91], v[90:91], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[92:93], v[92:93], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[94:95], v[94:95], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[96:97], v[96:97], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[98:99], v[98:99], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[100:101], v[100:101], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[102:103], v[102:103], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[104:105], v[104:105], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[106:107], v[106:107], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[108:109], v[108:109], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[110:111], v[110:111], v[190:191] op_sel_hi:[1,0]
		v_pk_mul_f32 v[112:113], v[112:113], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[114:115], v[114:115], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[116:117], v[116:117], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[118:119], v[118:119], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[120:121], v[120:121], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[122:123], v[122:123], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[124:125], v[124:125], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[126:127], v[126:127], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[128:129], v[128:129], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[130:131], v[130:131], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[132:133], v[132:133], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[134:135], v[134:135], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[136:137], v[136:137], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[138:139], v[138:139], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[140:141], v[140:141], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[142:143], v[142:143], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[144:145], v[144:145], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[146:147], v[146:147], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[148:149], v[148:149], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[150:151], v[150:151], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[152:153], v[152:153], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[154:155], v[154:155], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[156:157], v[156:157], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[158:159], v[158:159], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[160:161], v[160:161], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[162:163], v[162:163], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[164:165], v[164:165], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[166:167], v[166:167], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[168:169], v[168:169], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[170:171], v[170:171], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[172:173], v[172:173], v[190:191] op_sel:[0,1]
		v_pk_mul_f32 v[174:175], v[174:175], v[190:191] op_sel:[0,1]
		v_cvt_pk_bf16_f32 v40, v208, v210
		v_cvt_pk_bf16_f32 v41, v176, v178
		v_cvt_pk_bf16_f32 v42, v180, v182
		v_cvt_pk_bf16_f32 v43, v184, v186
		v_cvt_pk_bf16_f32 v44, v188, v194
		v_cvt_pk_bf16_f32 v45, v196, v198
		v_cvt_pk_bf16_f32 v46, v200, v202
		v_cvt_pk_bf16_f32 v47, v204, v206
		v_cvt_pk_bf16_f32 v224, v209, v211
		v_cvt_pk_bf16_f32 v225, v177, v179
		v_cvt_pk_bf16_f32 v226, v181, v183
		v_cvt_pk_bf16_f32 v227, v185, v187
		v_cvt_pk_bf16_f32 v176, v189, v195
		v_cvt_pk_bf16_f32 v177, v197, v199
		v_cvt_pk_bf16_f32 v178, v201, v203
		v_cvt_pk_bf16_f32 v179, v205, v207
		v_permlane32_swap_b32_e32 v216, v218
		v_permlane32_swap_b32_e32 v217, v219
		v_permlane32_swap_b32_e32 v212, v214
		v_permlane32_swap_b32_e32 v213, v215
		v_mfma_f32_32x32x16_bf16 v[48:63], a[84:87], v[216:219], v[48:63]
		v_permlane32_swap_b32_e32 v220, v222
		v_permlane32_swap_b32_e32 v221, v223
		v_mfma_f32_32x32x16_bf16 v[64:79], a[100:103], v[216:219], v[64:79]
		v_permlane32_swap_b32_e32 v32, v34
		v_permlane32_swap_b32_e32 v33, v35
		v_mfma_f32_32x32x16_bf16 v[80:95], a[116:119], v[216:219], v[80:95]
		v_permlane32_swap_b32_e32 v40, v42
		v_permlane32_swap_b32_e32 v41, v43
		v_mfma_f32_32x32x16_bf16 v[96:111], a[132:135], v[216:219], v[96:111]
		v_permlane32_swap_b32_e32 v44, v46
		v_permlane32_swap_b32_e32 v45, v47
		v_mfma_f32_32x32x16_bf16 v[160:175], a[132:135], v[40:43], v[160:175]
		v_permlane32_swap_b32_e32 v224, v226
		v_permlane32_swap_b32_e32 v225, v227
		v_mfma_f32_32x32x16_bf16 v[112:127], a[84:87], v[40:43], v[112:127]
		v_permlane32_swap_b32_e32 v176, v178
		v_permlane32_swap_b32_e32 v177, v179
		v_mfma_f32_32x32x16_bf16 v[128:143], a[100:103], v[40:43], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[116:119], v[40:43], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[88:91], v[212:215], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[104:107], v[212:215], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[120:123], v[212:215], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[136:139], v[212:215], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[136:139], v[44:47], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[88:91], v[44:47], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[104:107], v[44:47], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[120:123], v[44:47], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[92:95], v[220:223], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[108:111], v[220:223], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[124:127], v[220:223], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[140:143], v[220:223], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[140:143], v[224:227], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[92:95], v[224:227], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[108:111], v[224:227], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[124:127], v[224:227], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[96:99], v[32:35], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[112:115], v[32:35], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[128:131], v[32:35], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[144:147], v[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[144:147], v[176:179], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[96:99], v[176:179], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[112:115], v[176:179], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[128:131], v[176:179], v[144:159]
		v_mov_b32_e32 v32, v36
		v_mov_b32_e32 v33, v37
		s_cbranch_scc1 .L_attn_fwd_async_prefetch.loop_head_0
.L_attn_fwd_async_prefetch.loop_exit_0:
		s_waitcnt vmcnt(0)
		s_barrier
		s_and_b32 s1, s5, 1
		s_mul_i32 s3, 0x4100, s1
		v_lshl_add_u32 v2, v14, 4, s3
		v_add3_u32 v2, v2, v23, v26
		ds_read_b128 v[16:19], v2
		ds_read_b128 v[20:23], v2 offset:32
		ds_read_b128 v[36:39], v2 offset:64
		ds_read_b128 v[40:43], v2 offset:96
		ds_read_b128 a[64:67], v2 offset:128
		ds_read_b128 a[68:71], v2 offset:160
		ds_read_b128 a[72:75], v2 offset:192
		ds_read_b128 a[76:79], v2 offset:224
		ds_read_b128 v[44:47], v2 offset:512
		ds_read_b128 v[176:179], v2 offset:544
		ds_read_b128 v[180:183], v2 offset:576
		ds_read_b128 v[184:187], v2 offset:608
		ds_read_b128 v[188:191], v2 offset:640
		ds_read_b128 a[80:83], v2 offset:672
		ds_read_b128 a[84:87], v2 offset:704
		ds_read_b128 a[88:91], v2 offset:736
		s_mul_i32 s1, 0x4400, s1
		v_lshlrev_b32_e32 v2, 3, v10
		v_add3_u32 v2, s1, v2, v27
		v_lshl_add_u32 v1, v1, 5, v2
		v_add3_u32 v1, v1, v8, v29
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
		v_mfma_f32_32x32x16_bf16 v[208:223], v[44:47], a[0:3], 0
		s_lshl_b32 s1, s1, 9
		v_mfma_f32_32x32x16_bf16 v[224:239], v[44:47], a[32:35], 0
		s_mul_i32 s3, s17, s21
		v_mfma_f32_32x32x16_bf16 v[240:255], v[16:19], a[32:35], 0
		s_lshl_b32 s3, s3, 1
		v_mfma_f32_32x32x16_bf16 v[192:207], v[20:23], a[4:7], v[192:207]
		s_add_i32 s4, s1, s3
		v_mfma_f32_32x32x16_bf16 v[208:223], v[176:179], a[4:7], v[208:223]
		s_mul_i32 s0, s0, s22
		v_mfma_f32_32x32x16_bf16 v[224:239], v[176:179], a[36:39], v[224:239]
		s_lshl_b32 s0, s0, 1
		v_mfma_f32_32x32x16_bf16 v[240:255], v[20:23], a[36:39], v[240:255]
		s_add_i32 s4, s4, s0
		v_mfma_f32_32x32x16_bf16 v[192:207], v[36:39], a[8:11], v[192:207]
		s_mul_i32 s2, s23, s2
		v_mfma_f32_32x32x16_bf16 v[208:223], v[180:183], a[8:11], v[208:223]
		s_lshl_b32 s2, s2, 6
		v_mfma_f32_32x32x16_bf16 v[224:239], v[180:183], a[40:43], v[224:239]
		s_add_i32 s4, s4, s2
		v_mfma_f32_32x32x16_bf16 v[240:255], v[36:39], a[40:43], v[240:255]
		v_and_b32_e32 v0, 31, v0
		v_mfma_f32_32x32x16_bf16 v[192:207], v[40:43], a[12:15], v[192:207]
		v_mul_lo_u32 v0, s23, v0
		v_mfma_f32_32x32x16_bf16 v[208:223], v[184:187], a[12:15], v[208:223]
		v_lshlrev_b32_e32 v0, 1, v0
		v_mfma_f32_32x32x16_bf16 v[224:239], v[184:187], a[44:47], v[224:239]
		v_lshlrev_b32_e32 v1, 4, v5
		v_mfma_f32_32x32x16_bf16 v[240:255], v[40:43], a[44:47], v[240:255]
		s_add_i32 s5, s4, 32
		v_mfma_f32_32x32x16_bf16 v[192:207], a[64:67], a[16:19], v[192:207]
		s_add_i32 s6, s4, 64
		v_mfma_f32_32x32x16_bf16 v[208:223], v[188:191], a[16:19], v[208:223]
		s_add_i32 s7, s4, 0x60
		v_mfma_f32_32x32x16_bf16 v[224:239], v[188:191], a[48:51], v[224:239]
		s_add_i32 s10, s4, 0x80
		v_mfma_f32_32x32x16_bf16 v[240:255], a[64:67], a[48:51], v[240:255]
		s_add_i32 s11, s4, 0xa0
		v_mfma_f32_32x32x16_bf16 v[192:207], a[68:71], a[20:23], v[192:207]
		s_add_i32 s15, s4, 0xc0
		v_mfma_f32_32x32x16_bf16 v[208:223], a[80:83], a[20:23], v[208:223]
		s_add_i32 s16, s4, 0xe0
		v_mfma_f32_32x32x16_bf16 v[224:239], a[80:83], a[52:55], v[224:239]
		s_lshl_b32 s17, s23, 8
		v_mfma_f32_32x32x16_bf16 v[240:255], a[68:71], a[52:55], v[240:255]
		s_add_i32 s1, s17, s1
		v_mfma_f32_32x32x16_bf16 v[192:207], a[72:75], a[24:27], v[192:207]
		s_add_i32 s1, s1, s3
		v_mfma_f32_32x32x16_bf16 v[208:223], a[84:87], a[24:27], v[208:223]
		s_add_i32 s0, s1, s0
		v_mfma_f32_32x32x16_bf16 v[224:239], a[84:87], a[56:59], v[224:239]
		s_add_i32 s0, s0, s2
		v_mfma_f32_32x32x16_bf16 v[240:255], a[72:75], a[56:59], v[240:255]
		s_add_i32 s1, s0, 32
		v_mfma_f32_32x32x16_bf16 v[192:207], a[76:79], a[28:31], v[192:207]
		s_add_i32 s2, s0, 64
		v_mfma_f32_32x32x16_bf16 v[208:223], a[88:91], a[28:31], v[208:223]
		s_add_i32 s3, s0, 0x60
		v_mfma_f32_32x32x16_bf16 v[224:239], a[88:91], a[60:63], v[224:239]
		s_add_i32 s17, s0, 0x80
		v_mfma_f32_32x32x16_bf16 v[240:255], a[76:79], a[60:63], v[240:255]
		v_mov_b32_e32 v2, 4
		v_mul_lo_u32 v2, v2, v6
		v_add_u32_e32 v3, s14, v2
		v_xad_u32 v4, 16, v2, s14
		v_xad_u32 v5, 32, v2, s14
		v_xad_u32 v2, 48, v2, s14
		v_cmp_lt_i32_e64 s[18:19], v3, s25
		v_cmp_lt_i32_e64 s[20:21], v4, s25
		v_cmp_lt_i32_e64 s[22:23], v5, s25
		v_cmp_lt_i32_e64 vcc, v2, s25
		v_cndmask_b32_e64 v2, v7, v192, s[18:19]
		v_cndmask_b32_e64 v3, v7, v193, s[18:19]
		v_cndmask_b32_e64 v4, v7, v194, s[18:19]
		v_cndmask_b32_e64 v5, v7, v195, s[18:19]
		v_cndmask_b32_e64 v8, v7, v196, s[18:19]
		v_cndmask_b32_e64 v9, v7, v197, s[18:19]
		v_cndmask_b32_e64 v10, v7, v198, s[18:19]
		v_cndmask_b32_e64 v11, v7, v199, s[18:19]
		v_cndmask_b32_e64 v14, v7, v200, s[20:21]
		v_cndmask_b32_e64 v15, v7, v201, s[20:21]
		v_cndmask_b32_e64 v16, v7, v202, s[20:21]
		v_cndmask_b32_e64 v17, v7, v203, s[20:21]
		v_cndmask_b32_e64 v18, v7, v204, s[20:21]
		v_cndmask_b32_e64 v19, v7, v205, s[20:21]
		v_cndmask_b32_e64 v20, v7, v206, s[20:21]
		v_cndmask_b32_e64 v21, v7, v207, s[20:21]
		v_cndmask_b32_e64 v22, v7, v208, s[22:23]
		v_cndmask_b32_e64 v23, v7, v209, s[22:23]
		v_cndmask_b32_e64 v26, v7, v210, s[22:23]
		v_cndmask_b32_e64 v27, v7, v211, s[22:23]
		v_cndmask_b32_e64 v28, v7, v212, s[22:23]
		v_cndmask_b32_e64 v29, v7, v213, s[22:23]
		v_cndmask_b32_e64 v34, v7, v214, s[22:23]
		v_cndmask_b32_e64 v35, v7, v215, s[22:23]
		v_cndmask_b32_e32 v36, v7, v216, vcc
		v_cndmask_b32_e32 v37, v7, v217, vcc
		v_cndmask_b32_e32 v38, v7, v218, vcc
		v_cndmask_b32_e32 v39, v7, v219, vcc
		v_cndmask_b32_e32 v40, v7, v220, vcc
		v_cndmask_b32_e32 v41, v7, v221, vcc
		v_cndmask_b32_e32 v42, v7, v222, vcc
		v_cndmask_b32_e32 v43, v7, v223, vcc
		v_cndmask_b32_e64 v44, v7, v242, s[18:19]
		v_cndmask_b32_e64 v45, v7, v243, s[18:19]
		v_cndmask_b32_e64 v46, v7, v244, s[18:19]
		v_cndmask_b32_e64 v47, v7, v245, s[18:19]
		v_cndmask_b32_e64 v176, v7, v246, s[18:19]
		v_cndmask_b32_e64 v177, v7, v247, s[18:19]
		v_cndmask_b32_e64 v178, v7, v248, s[20:21]
		v_cndmask_b32_e64 v179, v7, v249, s[20:21]
		v_cndmask_b32_e64 v180, v7, v250, s[20:21]
		v_cndmask_b32_e64 v181, v7, v251, s[20:21]
		v_cndmask_b32_e64 v182, v7, v252, s[20:21]
		v_cndmask_b32_e64 v183, v7, v253, s[20:21]
		v_cndmask_b32_e64 v184, v7, v254, s[20:21]
		v_cndmask_b32_e64 v185, v7, v255, s[20:21]
		v_cndmask_b32_e64 v186, v7, v224, s[22:23]
		v_cndmask_b32_e64 v187, v7, v225, s[22:23]
		v_cndmask_b32_e64 v188, v7, v226, s[22:23]
		v_cndmask_b32_e64 v189, v7, v227, s[22:23]
		v_cndmask_b32_e64 v190, v7, v228, s[22:23]
		v_cndmask_b32_e64 v191, v7, v229, s[22:23]
		v_cndmask_b32_e64 v192, v7, v230, s[22:23]
		v_cndmask_b32_e64 v193, v7, v231, s[22:23]
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
		v_max3_f32 v205, v28, v29, v34
		v_max3_f32 v206, v36, v37, v38
		v_max3_f32 v207, v40, v41, v42
		v_max3_f32 v6, v6, v5, v12
		v_max3_f32 v12, v202, v17, v203
		v_max3_f32 v202, v204, v27, v205
		v_max3_f32 v203, v206, v39, v207
		v_max3_f32 v6, v6, v11, v12
		v_max3_f32 v12, v202, v35, v203
		v_max3_f32 v6, v6, v21, v12
		v_max_f32_e32 v202, v6, v43
		v_mov_b32_e32 v203, v202
		v_cndmask_b32_e64 v204, v7, v240, s[18:19]
		v_cndmask_b32_e64 v205, v7, v241, s[18:19]
		v_permlane32_swap_b32_e32 v202, v203
		v_max3_f32 v6, v204, v205, v44
		v_max3_f32 v7, v46, v47, v176
		v_max3_f32 v12, v178, v179, v180
		v_max3_f32 v206, v182, v183, v184
		v_max3_f32 v207, v186, v187, v188
		v_max3_f32 v208, v190, v191, v192
		v_max3_f32 v209, v194, v195, v196
		v_max3_f32 v210, v198, v199, v200
		v_max3_f32 v6, v6, v45, v7
		v_max3_f32 v7, v12, v181, v206
		v_max3_f32 v12, v207, v189, v208
		v_max3_f32 v206, v209, v197, v210
		v_max3_f32 v6, v6, v177, v7
		v_max3_f32 v7, v12, v193, v206
		v_max3_f32 v6, v6, v185, v7
		v_max_f32_e32 v206, v6, v201
		v_mov_b32_e32 v207, v206
		v_max_f32_e32 v6, v202, v203
		s_add_i32 s14, s0, 0xa0
		v_permlane32_swap_b32_e32 v206, v207
		v_max_f32_e32 v7, v206, v207
		v_pk_mul_f32 v[202:203], v[6:7], v[24:25]
		v_max_f32_e32 v6, v32, v202
		v_max_f32_e32 v7, v33, v203
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
		v_pk_fma_f32 v[26:27], v[28:29], v[24:25], v[6:7] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[34:35], v[24:25], v[6:7] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[34:35], v[36:37], v[24:25], v[6:7] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[36:37], v[38:39], v[24:25], v[6:7] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[38:39], v[40:41], v[24:25], v[6:7] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[40:41], v[42:43], v[24:25], v[6:7] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[42:43], v[204:205], v[24:25], v[6:7] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[44:45], v[24:25], v[6:7] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[44:45], v[46:47], v[24:25], v[6:7] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[46:47], v[176:177], v[24:25], v[6:7] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
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
		v_exp_f32_e32 v5, v28
		v_exp_f32_e32 v211, v29
		v_exp_f32_e32 v9, v34
		v_exp_f32_e32 v213, v35
		v_exp_f32_e32 v11, v36
		v_exp_f32_e32 v215, v37
		v_exp_f32_e32 v15, v38
		v_exp_f32_e32 v217, v39
		v_exp_f32_e32 v17, v40
		v_exp_f32_e32 v219, v41
		v_exp_f32_e32 v18, v204
		v_exp_f32_e32 v20, v205
		v_exp_f32_e32 v22, v44
		v_exp_f32_e32 v26, v45
		v_exp_f32_e32 v28, v46
		v_exp_f32_e32 v34, v47
		v_exp_f32_e32 v36, v176
		v_exp_f32_e32 v38, v177
		v_exp_f32_e32 v40, v178
		v_exp_f32_e32 v44, v179
		v_exp_f32_e32 v46, v180
		v_exp_f32_e32 v176, v181
		v_exp_f32_e32 v178, v182
		v_exp_f32_e32 v180, v183
		v_exp_f32_e32 v183, v184
		v_exp_f32_e32 v205, v185
		v_exp_f32_e32 v19, v186
		v_exp_f32_e32 v21, v187
		v_exp_f32_e32 v23, v188
		v_exp_f32_e32 v27, v189
		v_exp_f32_e32 v29, v190
		v_exp_f32_e32 v35, v191
		v_exp_f32_e32 v37, v192
		v_exp_f32_e32 v39, v193
		v_exp_f32_e32 v41, v194
		v_exp_f32_e32 v45, v195
		v_exp_f32_e32 v47, v196
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
		v_exp_f32_e32 v182, v42
		v_exp_f32_e32 v204, v43
		v_permlane32_swap_b32_e32 v184, v185
		v_pk_add_f32 v[42:43], v[182:183], v[204:205]
		v_pk_add_f32 v[186:187], v[18:19], v[20:21]
		v_pk_add_f32 v[188:189], v[22:23], v[26:27]
		v_pk_add_f32 v[190:191], v[28:29], v[34:35]
		v_pk_add_f32 v[192:193], v[36:37], v[38:39]
		v_pk_add_f32 v[194:195], v[40:41], v[44:45]
		v_pk_add_f32 v[196:197], v[46:47], v[176:177]
		v_pk_add_f32 v[198:199], v[178:179], v[180:181]
		v_pk_add_f32 v[42:43], v[42:43], v[186:187]
		v_pk_add_f32 v[186:187], v[188:189], v[190:191]
		v_pk_add_f32 v[188:189], v[192:193], v[194:195]
		v_pk_add_f32 v[190:191], v[196:197], v[198:199]
		v_pk_add_f32 v[42:43], v[42:43], v[186:187]
		v_pk_add_f32 v[186:187], v[188:189], v[190:191]
		v_pk_add_f32 v[188:189], v[42:43], v[186:187]
		v_mov_b32_e32 v42, v185
		v_mov_b32_e32 v43, v189
		v_mov_b32_e32 v186, v184
		v_mov_b32_e32 v187, v188
		v_pk_add_f32 v[184:185], v[186:187], v[42:43]
		v_mov_b32_e32 v42, v185
		v_mov_b32_e32 v43, v185
		v_pk_add_f32 v[186:187], v[32:33], v[6:7] neg_lo:[0,1] neg_hi:[0,1]
		v_cvt_pk_bf16_f32 v188, v24, v200
		v_permlane32_swap_b32_e32 v42, v43
		v_add_f32_e32 v7, v42, v43
		v_exp_f32_e32 v32, v186
		v_exp_f32_e32 v33, v187
		v_cvt_pk_bf16_f32 v189, v202, v206
		v_pk_mul_f32 v[224:225], v[48:49], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[226:227], v[50:51], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[228:229], v[52:53], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[230:231], v[54:55], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[232:233], v[56:57], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[234:235], v[58:59], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[236:237], v[60:61], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[238:239], v[62:63], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[64:65], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[66:67], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[68:69], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[70:71], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[72:73], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[74:75], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[76:77], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[78:79], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[80:81], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[66:67], v[82:83], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[68:69], v[84:85], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[70:71], v[86:87], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[72:73], v[88:89], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[74:75], v[90:91], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[76:77], v[92:93], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[78:79], v[94:95], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[80:81], v[96:97], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[82:83], v[98:99], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[84:85], v[100:101], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[86:87], v[102:103], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[88:89], v[104:105], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[90:91], v[106:107], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[92:93], v[108:109], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[94:95], v[110:111], v[32:33] op_sel_hi:[1,0]
		v_pk_mul_f32 v[96:97], v[112:113], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[98:99], v[114:115], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[100:101], v[116:117], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[102:103], v[118:119], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[104:105], v[120:121], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[106:107], v[122:123], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[108:109], v[124:125], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[110:111], v[126:127], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[112:113], v[128:129], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[114:115], v[130:131], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[116:117], v[132:133], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[118:119], v[134:135], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[120:121], v[136:137], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[122:123], v[138:139], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[124:125], v[140:141], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[126:127], v[142:143], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[128:129], v[144:145], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[130:131], v[146:147], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[132:133], v[148:149], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[134:135], v[150:151], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[136:137], v[152:153], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[138:139], v[154:155], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[140:141], v[156:157], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[142:143], v[158:159], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[144:145], v[160:161], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[146:147], v[162:163], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[148:149], v[164:165], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[150:151], v[166:167], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[152:153], v[168:169], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[154:155], v[170:171], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[156:157], v[172:173], v[32:33] op_sel:[0,1]
		v_pk_mul_f32 v[158:159], v[174:175], v[32:33] op_sel:[0,1]
		v_mov_b32_e32 v6, v184
		v_pk_fma_f32 v[42:43], v[30:31], v[32:33], v[6:7]
		v_cvt_pk_bf16_f32 v190, v2, v208
		v_cvt_pk_bf16_f32 v191, v4, v210
		v_cvt_pk_bf16_f32 v160, v8, v212
		v_cvt_pk_bf16_f32 v161, v10, v214
		v_cvt_pk_bf16_f32 v162, v14, v216
		v_cvt_pk_bf16_f32 v163, v16, v218
		v_cvt_pk_bf16_f32 v164, v25, v201
		v_cvt_pk_bf16_f32 v165, v203, v207
		v_cvt_pk_bf16_f32 v166, v3, v209
		v_cvt_pk_bf16_f32 v167, v5, v211
		v_cvt_pk_bf16_f32 v4, v9, v213
		v_cvt_pk_bf16_f32 v5, v11, v215
		v_cvt_pk_bf16_f32 v6, v15, v217
		v_cvt_pk_bf16_f32 v7, v17, v219
		v_cvt_pk_bf16_f32 v8, v182, v204
		v_cvt_pk_bf16_f32 v9, v18, v20
		v_cvt_pk_bf16_f32 v10, v22, v26
		v_cvt_pk_bf16_f32 v11, v28, v34
		v_cvt_pk_bf16_f32 v168, v36, v38
		v_cvt_pk_bf16_f32 v169, v40, v44
		v_cvt_pk_bf16_f32 v170, v46, v176
		v_cvt_pk_bf16_f32 v171, v178, v180
		v_cvt_pk_bf16_f32 v172, v183, v205
		v_cvt_pk_bf16_f32 v173, v19, v21
		v_cvt_pk_bf16_f32 v174, v23, v27
		v_cvt_pk_bf16_f32 v175, v29, v35
		v_cvt_pk_bf16_f32 v16, v37, v39
		v_cvt_pk_bf16_f32 v17, v41, v45
		v_cvt_pk_bf16_f32 v18, v47, v177
		v_cvt_pk_bf16_f32 v19, v179, v181
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_permlane32_swap_b32_e32 v160, v162
		v_permlane32_swap_b32_e32 v161, v163
		v_mfma_f32_32x32x16_bf16 v[224:239], a[92:95], v[188:191], v[224:239]
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		v_permlane32_swap_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v5, v7
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
		v_permlane32_swap_b32_e32 v168, v170
		v_permlane32_swap_b32_e32 v169, v171
		v_mfma_f32_32x32x16_bf16 v[48:63], a[108:111], v[188:191], v[48:63]
		v_permlane32_swap_b32_e32 v172, v174
		v_permlane32_swap_b32_e32 v173, v175
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_add3_u32 v2, s4, v0, v1
		v_cndmask_b32_e64 v2, v13, v2, s[12:13]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[124:127], v[188:191], v[64:79]
		s_add_i32 s4, s0, 0xc0
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_32x32x16_bf16 v[80:95], a[140:143], v[188:191], v[80:95]
		s_add_i32 s18, s0, 0xe0
		v_mfma_f32_32x32x16_bf16 v[144:159], a[140:143], v[8:11], v[144:159]
		v_add3_u32 v3, s5, v0, v1
		v_mfma_f32_32x32x16_bf16 v[96:111], a[92:95], v[8:11], v[96:111]
		v_cndmask_b32_e64 v3, v13, v3, s[12:13]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[108:111], v[8:11], v[112:127]
		v_add3_u32 v12, s6, v0, v1
		v_mfma_f32_32x32x16_bf16 v[128:143], a[124:127], v[8:11], v[128:143]
		v_cndmask_b32_e64 v8, v13, v12, s[12:13]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[96:99], v[160:163], v[224:239]
		v_add3_u32 v9, s7, v0, v1
		v_mfma_f32_32x32x16_bf16 v[48:63], a[112:115], v[160:163], v[48:63]
		v_cndmask_b32_e64 v9, v13, v9, s[12:13]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[128:131], v[160:163], v[64:79]
		v_add3_u32 v10, s10, v0, v1
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[160:163], v[80:95]
		v_cndmask_b32_e64 v10, v13, v10, s[12:13]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[144:147], v[168:171], v[144:159]
		v_add3_u32 v11, s11, v0, v1
		v_mfma_f32_32x32x16_bf16 v[96:111], a[96:99], v[168:171], v[96:111]
		v_cndmask_b32_e64 v11, v13, v11, s[12:13]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[112:115], v[168:171], v[112:127]
		v_add3_u32 v12, s15, v0, v1
		v_mfma_f32_32x32x16_bf16 v[128:143], a[128:131], v[168:171], v[128:143]
		v_cndmask_b32_e64 v12, v13, v12, s[12:13]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[100:103], v[164:167], v[224:239]
		v_add3_u32 v14, s16, v0, v1
		v_mfma_f32_32x32x16_bf16 v[48:63], a[116:119], v[164:167], v[48:63]
		v_cndmask_b32_e64 v14, v13, v14, s[12:13]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[132:135], v[164:167], v[64:79]
		v_add3_u32 v15, s0, v0, v1
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_32x32x16_bf16 v[80:95], a[148:151], v[164:167], v[80:95]
		v_cndmask_b32_e64 v15, v13, v15, s[28:29]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[148:151], v[172:175], v[144:159]
		v_add3_u32 v20, s1, v0, v1
		v_mfma_f32_32x32x16_bf16 v[96:111], a[100:103], v[172:175], v[96:111]
		v_cndmask_b32_e64 v20, v13, v20, s[28:29]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[116:119], v[172:175], v[112:127]
		v_add3_u32 v21, s2, v0, v1
		v_mfma_f32_32x32x16_bf16 v[128:143], a[132:135], v[172:175], v[128:143]
		v_cndmask_b32_e64 v21, v13, v21, s[28:29]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[104:107], v[4:7], v[224:239]
		v_add3_u32 v22, s3, v0, v1
		v_mfma_f32_32x32x16_bf16 v[48:63], a[120:123], v[4:7], v[48:63]
		v_cndmask_b32_e64 v22, v13, v22, s[28:29]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[136:139], v[4:7], v[64:79]
		v_add3_u32 v23, s17, v0, v1
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], v[4:7], v[80:95]
		v_cndmask_b32_e64 v4, v13, v23, s[28:29]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[152:155], v[16:19], v[144:159]
		v_add3_u32 v5, s14, v0, v1
		v_mfma_f32_32x32x16_bf16 v[96:111], a[104:107], v[16:19], v[96:111]
		v_cndmask_b32_e64 v5, v13, v5, s[28:29]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[120:123], v[16:19], v[112:127]
		v_add3_u32 v6, s4, v0, v1
		v_mfma_f32_32x32x16_bf16 v[128:143], a[136:139], v[16:19], v[128:143]
		v_add3_u32 v0, s18, v0, v1
		v_rcp_f32_e32 v16, v42
		v_cndmask_b32_e64 v1, v13, v6, s[28:29]
		v_mov_b32_e32 v17, v16
		v_pk_mul_f32 v[6:7], v[224:225], v[16:17]
		v_pk_mul_f32 v[18:19], v[226:227], v[16:17]
		v_pk_mul_f32 v[24:25], v[228:229], v[16:17]
		v_pk_mul_f32 v[26:27], v[230:231], v[16:17]
		v_pk_mul_f32 v[28:29], v[232:233], v[16:17]
		v_pk_mul_f32 v[30:31], v[234:235], v[16:17]
		v_pk_mul_f32 v[32:33], v[236:237], v[16:17]
		v_pk_mul_f32 v[34:35], v[238:239], v[16:17]
		v_pk_mul_f32 v[36:37], v[48:49], v[16:17]
		v_pk_mul_f32 v[38:39], v[50:51], v[16:17]
		v_pk_mul_f32 v[40:41], v[52:53], v[16:17]
		v_pk_mul_f32 v[44:45], v[54:55], v[16:17]
		v_pk_mul_f32 v[46:47], v[56:57], v[16:17]
		v_pk_mul_f32 v[48:49], v[58:59], v[16:17]
		v_pk_mul_f32 v[50:51], v[60:61], v[16:17]
		v_pk_mul_f32 v[52:53], v[62:63], v[16:17]
		v_pk_mul_f32 v[54:55], v[64:65], v[16:17]
		v_pk_mul_f32 v[56:57], v[66:67], v[16:17]
		v_pk_mul_f32 v[58:59], v[68:69], v[16:17]
		v_pk_mul_f32 v[60:61], v[70:71], v[16:17]
		v_pk_mul_f32 v[62:63], v[72:73], v[16:17]
		v_pk_mul_f32 v[64:65], v[74:75], v[16:17]
		v_pk_mul_f32 v[66:67], v[76:77], v[16:17]
		v_pk_mul_f32 v[68:69], v[78:79], v[16:17]
		v_pk_mul_f32 v[70:71], v[80:81], v[16:17]
		v_pk_mul_f32 v[72:73], v[82:83], v[16:17]
		v_pk_mul_f32 v[74:75], v[84:85], v[16:17]
		v_pk_mul_f32 v[76:77], v[86:87], v[16:17]
		v_pk_mul_f32 v[78:79], v[88:89], v[16:17]
		v_pk_mul_f32 v[80:81], v[90:91], v[16:17]
		v_pk_mul_f32 v[82:83], v[92:93], v[16:17]
		v_pk_mul_f32 v[84:85], v[94:95], v[16:17]
		v_rcp_f32_e32 v16, v43
		v_cvt_pk_bf16_f32 v88, v6, v7
		v_mov_b32_e32 v17, v16
		v_pk_mul_f32 v[6:7], v[96:97], v[16:17]
		v_pk_mul_f32 v[42:43], v[98:99], v[16:17]
		v_pk_mul_f32 v[86:87], v[100:101], v[16:17]
		v_pk_mul_f32 v[92:93], v[102:103], v[16:17]
		v_pk_mul_f32 v[94:95], v[104:105], v[16:17]
		v_pk_mul_f32 v[96:97], v[106:107], v[16:17]
		v_pk_mul_f32 v[98:99], v[108:109], v[16:17]
		v_pk_mul_f32 v[100:101], v[110:111], v[16:17]
		v_pk_mul_f32 v[102:103], v[112:113], v[16:17]
		v_pk_mul_f32 v[104:105], v[114:115], v[16:17]
		v_pk_mul_f32 v[106:107], v[116:117], v[16:17]
		v_pk_mul_f32 v[108:109], v[118:119], v[16:17]
		v_pk_mul_f32 v[110:111], v[120:121], v[16:17]
		v_pk_mul_f32 v[112:113], v[122:123], v[16:17]
		v_pk_mul_f32 v[114:115], v[124:125], v[16:17]
		v_pk_mul_f32 v[116:117], v[126:127], v[16:17]
		v_pk_mul_f32 v[118:119], v[128:129], v[16:17]
		v_pk_mul_f32 v[120:121], v[130:131], v[16:17]
		v_pk_mul_f32 v[122:123], v[132:133], v[16:17]
		v_pk_mul_f32 v[124:125], v[134:135], v[16:17]
		v_pk_mul_f32 v[126:127], v[136:137], v[16:17]
		v_pk_mul_f32 v[128:129], v[138:139], v[16:17]
		v_pk_mul_f32 v[130:131], v[140:141], v[16:17]
		v_pk_mul_f32 v[132:133], v[142:143], v[16:17]
		v_pk_mul_f32 v[134:135], v[144:145], v[16:17]
		v_pk_mul_f32 v[136:137], v[146:147], v[16:17]
		v_pk_mul_f32 v[138:139], v[148:149], v[16:17]
		v_pk_mul_f32 v[140:141], v[150:151], v[16:17]
		v_pk_mul_f32 v[142:143], v[152:153], v[16:17]
		v_pk_mul_f32 v[144:145], v[154:155], v[16:17]
		v_pk_mul_f32 v[146:147], v[156:157], v[16:17]
		v_pk_mul_f32 v[148:149], v[158:159], v[16:17]
		v_cvt_pk_bf16_f32 v89, v18, v19
		v_cvt_pk_bf16_f32 v90, v24, v25
		v_cvt_pk_bf16_f32 v91, v26, v27
		v_cvt_pk_bf16_f32 v16, v28, v29
		v_cvt_pk_bf16_f32 v17, v30, v31
		v_cvt_pk_bf16_f32 v18, v32, v33
		v_cvt_pk_bf16_f32 v19, v34, v35
		v_cvt_pk_bf16_f32 v24, v36, v37
		v_cvt_pk_bf16_f32 v25, v38, v39
		v_cvt_pk_bf16_f32 v26, v40, v41
		v_cvt_pk_bf16_f32 v27, v44, v45
		v_cvt_pk_bf16_f32 v28, v46, v47
		v_cvt_pk_bf16_f32 v29, v48, v49
		v_cvt_pk_bf16_f32 v30, v50, v51
		v_cvt_pk_bf16_f32 v31, v52, v53
		v_cvt_pk_bf16_f32 v32, v54, v55
		v_cvt_pk_bf16_f32 v33, v56, v57
		v_cvt_pk_bf16_f32 v34, v58, v59
		v_cvt_pk_bf16_f32 v35, v60, v61
		v_cvt_pk_bf16_f32 v36, v62, v63
		v_cvt_pk_bf16_f32 v37, v64, v65
		v_cvt_pk_bf16_f32 v38, v66, v67
		v_cvt_pk_bf16_f32 v39, v68, v69
		v_cvt_pk_bf16_f32 v44, v70, v71
		v_cvt_pk_bf16_f32 v45, v72, v73
		v_cvt_pk_bf16_f32 v46, v74, v75
		v_cvt_pk_bf16_f32 v47, v76, v77
		v_cvt_pk_bf16_f32 v48, v78, v79
		v_cvt_pk_bf16_f32 v49, v80, v81
		v_cvt_pk_bf16_f32 v50, v82, v83
		v_cvt_pk_bf16_f32 v51, v84, v85
		v_cvt_pk_bf16_f32 v52, v6, v7
		v_cvt_pk_bf16_f32 v53, v42, v43
		v_cvt_pk_bf16_f32 v54, v86, v87
		v_cvt_pk_bf16_f32 v55, v92, v93
		v_cvt_pk_bf16_f32 v40, v94, v95
		v_cvt_pk_bf16_f32 v41, v96, v97
		v_cvt_pk_bf16_f32 v42, v98, v99
		v_cvt_pk_bf16_f32 v43, v100, v101
		v_cvt_pk_bf16_f32 v56, v102, v103
		v_cvt_pk_bf16_f32 v57, v104, v105
		v_cvt_pk_bf16_f32 v58, v106, v107
		v_cvt_pk_bf16_f32 v59, v108, v109
		v_cvt_pk_bf16_f32 v60, v110, v111
		v_cvt_pk_bf16_f32 v61, v112, v113
		v_cvt_pk_bf16_f32 v62, v114, v115
		v_cvt_pk_bf16_f32 v63, v116, v117
		v_cvt_pk_bf16_f32 v64, v118, v119
		v_cvt_pk_bf16_f32 v65, v120, v121
		v_cvt_pk_bf16_f32 v66, v122, v123
		v_cvt_pk_bf16_f32 v67, v124, v125
		v_cvt_pk_bf16_f32 v68, v126, v127
		v_cvt_pk_bf16_f32 v69, v128, v129
		v_cvt_pk_bf16_f32 v70, v130, v131
		v_cvt_pk_bf16_f32 v71, v132, v133
		v_cvt_pk_bf16_f32 v72, v134, v135
		v_cvt_pk_bf16_f32 v73, v136, v137
		v_cvt_pk_bf16_f32 v74, v138, v139
		v_cvt_pk_bf16_f32 v75, v140, v141
		v_cvt_pk_bf16_f32 v76, v142, v143
		v_cvt_pk_bf16_f32 v77, v144, v145
		v_cvt_pk_bf16_f32 v78, v146, v147
		v_cvt_pk_bf16_f32 v79, v148, v149
		v_permlane32_swap_b32_e32 v88, v90
		v_permlane32_swap_b32_e32 v89, v91
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_permlane32_swap_b32_e32 v32, v34
		v_permlane32_swap_b32_e32 v33, v35
		v_permlane32_swap_b32_e32 v36, v38
		v_permlane32_swap_b32_e32 v37, v39
		v_permlane32_swap_b32_e32 v44, v46
		v_permlane32_swap_b32_e32 v45, v47
		v_permlane32_swap_b32_e32 v48, v50
		v_permlane32_swap_b32_e32 v49, v51
		v_permlane32_swap_b32_e32 v52, v54
		v_permlane32_swap_b32_e32 v53, v55
		v_permlane32_swap_b32_e32 v40, v42
		v_permlane32_swap_b32_e32 v41, v43
		v_permlane32_swap_b32_e32 v56, v58
		v_permlane32_swap_b32_e32 v57, v59
		v_permlane32_swap_b32_e32 v60, v62
		v_permlane32_swap_b32_e32 v61, v63
		v_permlane32_swap_b32_e32 v64, v66
		v_permlane32_swap_b32_e32 v65, v67
		v_permlane32_swap_b32_e32 v68, v70
		v_permlane32_swap_b32_e32 v69, v71
		v_permlane32_swap_b32_e32 v72, v74
		v_permlane32_swap_b32_e32 v73, v75
		v_permlane32_swap_b32_e32 v76, v78
		v_permlane32_swap_b32_e32 v77, v79
		s_mov_b32 s0, s8
		s_mov_b32 s1, s9
		s_mov_b32 s2, s34
		s_mov_b32 s3, s35
		buffer_store_dwordx4 v[88:91], v2, s[0:3], 0 offen
		buffer_store_dwordx4 v[16:19], v3, s[0:3], 0 offen
		buffer_store_dwordx4 v[24:27], v8, s[0:3], 0 offen
		buffer_store_dwordx4 v[28:31], v9, s[0:3], 0 offen
		buffer_store_dwordx4 v[32:35], v10, s[0:3], 0 offen
		buffer_store_dwordx4 v[36:39], v11, s[0:3], 0 offen
		buffer_store_dwordx4 v[44:47], v12, s[0:3], 0 offen
		buffer_store_dwordx4 v[48:51], v14, s[0:3], 0 offen
		buffer_store_dwordx4 v[52:55], v15, s[0:3], 0 offen
		buffer_store_dwordx4 v[40:43], v20, s[0:3], 0 offen
		buffer_store_dwordx4 v[56:59], v21, s[0:3], 0 offen
		buffer_store_dwordx4 v[60:63], v22, s[0:3], 0 offen
		buffer_store_dwordx4 v[64:67], v4, s[0:3], 0 offen
		buffer_store_dwordx4 v[68:71], v5, s[0:3], 0 offen
		buffer_store_dwordx4 v[72:75], v1, s[0:3], 0 offen
		v_cndmask_b32_e64 v0, v13, v0, s[28:29]
		buffer_store_dwordx4 v[76:79], v0, s[0:3], 0 offen
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
		.amdhsa_next_free_vgpr 412
		.amdhsa_next_free_sgpr 45
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
	.set .L_attn_fwd_async_prefetch.num_agpr, 156
	.set .L_attn_fwd_async_prefetch.numbered_sgpr, 45
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
    .sgpr_count:     45
    .sgpr_spill_count: 0
    .symbol:         _attn_fwd_async_prefetch.kd
    .uses_dynamic_stack: false
    .vgpr_count:     412
    .agpr_count:     156
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 61
    wave.regalloc.agpr.dwords: 240
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
