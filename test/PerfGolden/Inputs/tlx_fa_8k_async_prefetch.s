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
		v_mov_b32_e32 v10, 0x3e0293ee
		v_lshlrev_b32_e32 v23, 4, v14
		v_lshrrev_b32_e32 v24, 4, v4
		v_lshlrev_b32_e32 v24, 8, v24
		v_and_b32_e32 v4, 15, v4
		v_mov_b32_e32 v25, 0x410
		v_mul_lo_u32 v25, v25, v4
		v_add3_u32 v4, v23, v24, v25
		v_and_b32_e32 v23, 3, v0
		v_mov_b32_e32 v26, 0x2200
		v_mul_lo_u32 v26, v26, v5
		v_lshl_add_u32 v27, v23, 3, v26
		v_lshl_add_u32 v27, v1, 5, v27
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v28, 0x440
		v_mul_lo_u32 v28, v28, v15
		v_add3_u32 v15, v27, v8, v28
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
		v_add_u32_e32 v27, s30, v4
		ds_read_b128 v[36:39], v27
		ds_read_b128 v[40:43], v27 offset:32
		ds_read_b128 v[44:47], v27 offset:64
		ds_read_b128 v[176:179], v27 offset:96
		ds_read_b128 v[180:183], v27 offset:128
		ds_read_b128 v[184:187], v27 offset:160
		ds_read_b128 v[188:191], v27 offset:192
		ds_read_b128 a[64:67], v27 offset:224
		ds_read_b128 v[192:195], v27 offset:512
		ds_read_b128 v[196:199], v27 offset:544
		ds_read_b128 v[200:203], v27 offset:576
		ds_read_b128 v[204:207], v27 offset:608
		ds_read_b128 a[68:71], v27 offset:640
		ds_read_b128 a[72:75], v27 offset:672
		ds_read_b128 a[76:79], v27 offset:704
		ds_read_b128 a[80:83], v27 offset:736
		s_mul_i32 s18, 0x4400, s18
		v_add_u32_e32 v27, s18, v15
		ds_read_b64_tr_b16 a[84:85], v27 offset:33264
		ds_read_b64_tr_b16 a[86:87], v27 offset:37616
		ds_read_b64_tr_b16 a[88:89], v27 offset:33520
		ds_read_b64_tr_b16 a[90:91], v27 offset:37872
		ds_read_b64_tr_b16 a[92:93], v27 offset:33776
		ds_read_b64_tr_b16 a[94:95], v27 offset:38128
		ds_read_b64_tr_b16 a[96:97], v27 offset:34032
		ds_read_b64_tr_b16 a[98:99], v27 offset:38384
		ds_read_b64_tr_b16 a[100:101], v27 offset:33328
		ds_read_b64_tr_b16 a[102:103], v27 offset:37680
		ds_read_b64_tr_b16 a[104:105], v27 offset:33584
		ds_read_b64_tr_b16 a[106:107], v27 offset:37936
		ds_read_b64_tr_b16 a[108:109], v27 offset:33840
		ds_read_b64_tr_b16 a[110:111], v27 offset:38192
		ds_read_b64_tr_b16 a[112:113], v27 offset:34096
		ds_read_b64_tr_b16 a[114:115], v27 offset:38448
		ds_read_b64_tr_b16 a[116:117], v27 offset:33392
		ds_read_b64_tr_b16 a[118:119], v27 offset:37744
		ds_read_b64_tr_b16 a[120:121], v27 offset:33648
		ds_read_b64_tr_b16 a[122:123], v27 offset:38000
		ds_read_b64_tr_b16 a[124:125], v27 offset:33904
		ds_read_b64_tr_b16 a[126:127], v27 offset:38256
		ds_read_b64_tr_b16 a[128:129], v27 offset:34160
		ds_read_b64_tr_b16 a[130:131], v27 offset:38512
		ds_read_b64_tr_b16 a[132:133], v27 offset:33456
		ds_read_b64_tr_b16 a[134:135], v27 offset:37808
		ds_read_b64_tr_b16 a[136:137], v27 offset:33712
		ds_read_b64_tr_b16 a[138:139], v27 offset:38064
		ds_read_b64_tr_b16 a[140:141], v27 offset:33968
		ds_read_b64_tr_b16 a[142:143], v27 offset:38320
		ds_read_b64_tr_b16 a[144:145], v27 offset:34224
		ds_read_b64_tr_b16 a[146:147], v27 offset:38576
		s_mul_i32 s18, s15, s26
		s_lshl_b32 s18, s18, 1
		s_add_i32 s30, s24, s18
		v_add_u32_e32 v27, s30, v19
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[208:223], v[36:39], a[0:3], 0
		v_add3_u32 v27, v27, v21, v11
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
		v_add_u32_e32 v29, s18, v19
		v_mfma_f32_32x32x16_bf16 v[224:239], v[40:43], a[36:39], v[224:239]
		v_add3_u32 v29, v29, v21, v11
		v_mfma_f32_32x32x16_bf16 v[224:239], v[44:47], a[40:43], v[224:239]
		s_mul_i32 s18, s20, s26
		v_mfma_f32_32x32x16_bf16 v[224:239], v[176:179], a[44:47], v[224:239]
		s_add_i32 s26, s26, 64
		v_mfma_f32_32x32x16_bf16 v[224:239], v[180:183], a[48:51], v[224:239]
		v_add_u32_e32 v34, s26, v16
		v_mfma_f32_32x32x16_bf16 v[224:239], v[184:187], a[52:55], v[224:239]
		v_add_u32_e32 v35, s26, v9
		v_mfma_f32_32x32x16_bf16 v[224:239], v[188:191], a[56:59], v[224:239]
		v_add_u32_e32 v36, s26, v17
		v_mfma_f32_32x32x16_bf16 v[176:191], v[192:195], a[0:3], 0
		v_add_u32_e32 v37, s26, v3
		v_mfma_f32_32x32x16_bf16 v[176:191], v[196:199], a[4:7], v[176:191]
		v_cmp_lt_i32_e64 s[30:31], v34, s25
		v_mfma_f32_32x32x16_bf16 v[176:191], v[200:203], a[8:11], v[176:191]
		v_cmp_lt_i32_e64 vcc, v37, s25
		v_mfma_f32_32x32x16_bf16 v[176:191], v[204:207], a[12:15], v[176:191]
		v_cndmask_b32_e64 v27, v22, v27, s[30:31]
		buffer_load_dwordx4 v27, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[176:191], a[68:71], a[16:19], v[176:191]
		v_cmp_lt_i32_e64 s[40:41], v35, s25
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[42:43], v36, s25
		v_mfma_f32_32x32x16_bf16 v[176:191], a[72:75], a[20:23], v[176:191]
		v_cndmask_b32_e64 v27, v22, v29, s[40:41]
		buffer_load_dwordx4 v27, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[176:191], a[76:79], a[24:27], v[176:191]
		v_cndmask_b32_e64 v27, v22, v12, s[42:43]
		v_add_u32_e32 v12, s19, v12
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e32 v29, v22, v18, vcc
		buffer_load_dwordx4 v27, s[32:35], 0 offen lds
		s_lshl_b32 s18, s18, 1
		v_add_u32_e32 v18, s19, v18
		s_add_i32 m0, m0, 0x1040
		s_add_i32 s44, s3, s18
		v_add_u32_e32 v27, s44, v2
		buffer_load_dwordx4 v29, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[240:255], v[192:195], a[32:35], 0
		v_add3_u32 v27, v27, v20, v11
		v_mfma_f32_32x32x16_bf16 v[240:255], v[196:199], a[36:39], v[240:255]
		s_mul_i32 s11, 0x4400, s11
		v_mfma_f32_32x32x16_bf16 v[240:255], v[200:203], a[40:43], v[240:255]
		s_add_i32 s11, s6, s11
		v_mfma_f32_32x32x16_bf16 v[240:255], v[204:207], a[44:47], v[240:255]
		s_add_i32 m0, s11, 0x81f0
		v_mfma_f32_32x32x16_bf16 v[240:255], a[68:71], a[48:51], v[240:255]
		v_cndmask_b32_e64 v27, v22, v27, s[30:31]
		buffer_load_dwordx4 v27, s[36:39], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[240:255], a[72:75], a[52:55], v[240:255]
		s_add_i32 s11, s4, s18
		v_mfma_f32_32x32x16_bf16 v[240:255], a[76:79], a[56:59], v[240:255]
		v_add_u32_e32 v27, s11, v2
		v_mfma_f32_32x32x16_bf16 v[208:223], a[64:67], a[28:31], v[208:223]
		v_add3_u32 v27, v27, v20, v11
		v_cndmask_b32_e64 v27, v22, v27, s[40:41]
		s_add_i32 m0, m0, 0x1100
		s_add_i32 s11, s7, s18
		buffer_load_dwordx4 v27, s[36:39], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], a[64:67], a[60:63], v[224:239]
		v_add_u32_e32 v27, s11, v2
		v_mfma_f32_32x32x16_bf16 v[176:191], a[80:83], a[28:31], v[176:191]
		v_add3_u32 v27, v27, v20, v11
		v_cndmask_b32_e64 v27, v22, v27, s[42:43]
		s_add_i32 m0, m0, 0x1100
		s_add_i32 s11, s1, s18
		buffer_load_dwordx4 v27, s[36:39], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[240:255], a[80:83], a[60:63], v[240:255]
		v_add_u32_e32 v27, s11, v2
		v_add3_u32 v27, v27, v20, v11
		v_cndmask_b32_e32 v27, v22, v27, vcc
		v_max3_f32 v29, v208, v209, v210
		s_add_i32 m0, m0, 0x1100
		v_max3_f32 v34, v212, v213, v214
		v_max3_f32 v35, v216, v217, v218
		v_max3_f32 v36, v220, v221, v222
		v_max3_f32 v37, v176, v177, v178
		v_max3_f32 v38, v180, v181, v182
		v_max3_f32 v39, v184, v185, v186
		v_max3_f32 v40, v188, v189, v190
		v_max3_f32 v29, v29, v211, v34
		v_max3_f32 v34, v35, v219, v36
		v_max3_f32 v35, v37, v179, v38
		v_max3_f32 v36, v39, v187, v40
		v_max3_f32 v29, v29, v215, v34
		v_max3_f32 v34, v35, v183, v36
		v_max3_f32 v29, v29, v223, v34
		v_max3_f32 v34, v224, v225, v226
		v_max3_f32 v35, v228, v229, v230
		buffer_load_dwordx4 v27, s[36:39], 0 offen lds
		v_max_f32_e32 v36, v29, v191
		v_mov_b32_e32 v37, v36
		v_max3_f32 v27, v232, v233, v234
		v_max3_f32 v29, v236, v237, v238
		v_max3_f32 v38, v240, v241, v242
		v_max3_f32 v39, v244, v245, v246
		v_max3_f32 v40, v248, v249, v250
		v_max3_f32 v41, v252, v253, v254
		v_max3_f32 v34, v34, v227, v35
		v_max3_f32 v27, v27, v235, v29
		v_max3_f32 v29, v38, v243, v39
		v_max3_f32 v35, v40, v251, v41
		v_max3_f32 v27, v34, v231, v27
		v_max3_f32 v29, v29, v247, v35
		v_max3_f32 v27, v27, v239, v29
		v_max_f32_e32 v34, v27, v255
		s_cmp_lt_i32 s26, s14
		v_mov_b32_e32 v35, v34
		v_permlane32_swap_b32_e32 v36, v37
		v_max_f32_e32 v27, v36, v37
		v_permlane32_swap_b32_e32 v34, v35
		v_max_f32_e32 v29, v34, v35
		v_mul_f32_e32 v27, v27, v10
		v_mul_f32_e32 v29, v29, v10
		v_max_f32_e32 v27, v32, v27
		v_max_f32_e32 v29, v33, v29
		v_xor_b32_e32 v34, 0x80000000, v27
		v_fma_f32 v35, v208, v10, v34
		v_fma_f32 v36, v209, v10, v34
		v_fma_f32 v37, v210, v10, v34
		v_fma_f32 v38, v211, v10, v34
		v_fma_f32 v39, v212, v10, v34
		v_fma_f32 v40, v213, v10, v34
		v_fma_f32 v41, v214, v10, v34
		v_fma_f32 v42, v215, v10, v34
		v_fma_f32 v43, v216, v10, v34
		v_fma_f32 v44, v217, v10, v34
		v_fma_f32 v45, v218, v10, v34
		v_fma_f32 v46, v219, v10, v34
		v_fma_f32 v47, v220, v10, v34
		v_fma_f32 v192, v221, v10, v34
		v_fma_f32 v193, v222, v10, v34
		v_fma_f32 v194, v223, v10, v34
		v_fma_f32 v176, v176, v10, v34
		v_fma_f32 v177, v177, v10, v34
		v_fma_f32 v178, v178, v10, v34
		v_fma_f32 v179, v179, v10, v34
		v_fma_f32 v180, v180, v10, v34
		v_fma_f32 v181, v181, v10, v34
		v_fma_f32 v182, v182, v10, v34
		v_fma_f32 v183, v183, v10, v34
		v_fma_f32 v184, v184, v10, v34
		v_fma_f32 v185, v185, v10, v34
		v_fma_f32 v186, v186, v10, v34
		v_fma_f32 v187, v187, v10, v34
		v_fma_f32 v188, v188, v10, v34
		v_fma_f32 v189, v189, v10, v34
		v_fma_f32 v190, v190, v10, v34
		v_fma_f32 v191, v191, v10, v34
		v_xor_b32_e32 v195, 0x80000000, v29
		v_fma_f32 v196, v224, v10, v195
		v_fma_f32 v197, v225, v10, v195
		v_fma_f32 v198, v226, v10, v195
		v_fma_f32 v199, v227, v10, v195
		v_fma_f32 v200, v228, v10, v195
		v_fma_f32 v201, v229, v10, v195
		v_fma_f32 v202, v230, v10, v195
		v_fma_f32 v203, v231, v10, v195
		v_fma_f32 v204, v232, v10, v195
		v_fma_f32 v205, v233, v10, v195
		v_fma_f32 v206, v234, v10, v195
		v_fma_f32 v207, v235, v10, v195
		v_fma_f32 v208, v236, v10, v195
		v_fma_f32 v209, v237, v10, v195
		v_fma_f32 v210, v238, v10, v195
		v_fma_f32 v211, v239, v10, v195
		v_fma_f32 v212, v240, v10, v195
		v_fma_f32 v213, v241, v10, v195
		v_fma_f32 v214, v242, v10, v195
		v_fma_f32 v215, v243, v10, v195
		v_fma_f32 v216, v244, v10, v195
		v_fma_f32 v217, v245, v10, v195
		v_fma_f32 v218, v246, v10, v195
		v_fma_f32 v219, v247, v10, v195
		v_fma_f32 v220, v248, v10, v195
		v_fma_f32 v221, v249, v10, v195
		v_fma_f32 v222, v250, v10, v195
		v_fma_f32 v223, v251, v10, v195
		v_fma_f32 v224, v252, v10, v195
		v_fma_f32 v225, v253, v10, v195
		v_fma_f32 v226, v254, v10, v195
		v_fma_f32 v227, v255, v10, v195
		v_exp_f32_e32 v35, v35
		v_exp_f32_e32 v36, v36
		v_exp_f32_e32 v37, v37
		v_exp_f32_e32 v38, v38
		v_exp_f32_e32 v39, v39
		v_exp_f32_e32 v40, v40
		v_exp_f32_e32 v41, v41
		v_exp_f32_e32 v42, v42
		v_exp_f32_e32 v43, v43
		v_exp_f32_e32 v44, v44
		v_exp_f32_e32 v45, v45
		v_exp_f32_e32 v46, v46
		v_exp_f32_e32 v47, v47
		v_exp_f32_e32 v192, v192
		v_exp_f32_e32 v193, v193
		v_exp_f32_e32 v194, v194
		v_exp_f32_e32 v176, v176
		v_exp_f32_e32 v177, v177
		v_exp_f32_e32 v178, v178
		v_exp_f32_e32 v179, v179
		v_exp_f32_e32 v180, v180
		v_exp_f32_e32 v181, v181
		v_exp_f32_e32 v182, v182
		v_exp_f32_e32 v183, v183
		v_exp_f32_e32 v184, v184
		v_exp_f32_e32 v185, v185
		v_exp_f32_e32 v186, v186
		v_exp_f32_e32 v187, v187
		v_exp_f32_e32 v188, v188
		v_exp_f32_e32 v189, v189
		v_exp_f32_e32 v190, v190
		v_exp_f32_e32 v191, v191
		v_exp_f32_e32 v198, v198
		v_exp_f32_e32 v199, v199
		v_exp_f32_e32 v200, v200
		v_exp_f32_e32 v201, v201
		v_exp_f32_e32 v202, v202
		v_exp_f32_e32 v203, v203
		v_exp_f32_e32 v204, v204
		v_exp_f32_e32 v205, v205
		v_exp_f32_e32 v206, v206
		v_exp_f32_e32 v207, v207
		v_exp_f32_e32 v208, v208
		v_exp_f32_e32 v209, v209
		v_exp_f32_e32 v210, v210
		v_exp_f32_e32 v211, v211
		v_exp_f32_e32 v212, v212
		v_exp_f32_e32 v213, v213
		v_exp_f32_e32 v214, v214
		v_exp_f32_e32 v215, v215
		v_exp_f32_e32 v216, v216
		v_exp_f32_e32 v217, v217
		v_exp_f32_e32 v218, v218
		v_exp_f32_e32 v219, v219
		v_exp_f32_e32 v220, v220
		v_exp_f32_e32 v221, v221
		v_exp_f32_e32 v222, v222
		v_exp_f32_e32 v223, v223
		v_exp_f32_e32 v224, v224
		v_exp_f32_e32 v225, v225
		v_exp_f32_e32 v226, v226
		v_exp_f32_e32 v227, v227
		v_add_f32_e32 v228, v35, v36
		v_add_f32_e32 v229, v176, v177
		v_add_f32_e32 v230, v37, v38
		v_add_f32_e32 v231, v178, v179
		v_add_f32_e32 v232, v39, v40
		v_add_f32_e32 v233, v180, v181
		v_add_f32_e32 v234, v41, v42
		v_add_f32_e32 v235, v182, v183
		v_add_f32_e32 v236, v43, v44
		v_add_f32_e32 v237, v184, v185
		v_add_f32_e32 v238, v45, v46
		v_add_f32_e32 v239, v186, v187
		v_add_f32_e32 v240, v47, v192
		v_add_f32_e32 v241, v188, v189
		v_add_f32_e32 v242, v193, v194
		v_add_f32_e32 v243, v190, v191
		v_add_f32_e32 v228, v228, v230
		v_add_f32_e32 v229, v229, v231
		v_add_f32_e32 v230, v232, v234
		v_add_f32_e32 v231, v233, v235
		v_add_f32_e32 v232, v236, v238
		v_add_f32_e32 v233, v237, v239
		v_add_f32_e32 v234, v240, v242
		v_add_f32_e32 v235, v241, v243
		v_add_f32_e32 v228, v228, v230
		v_add_f32_e32 v229, v229, v231
		v_add_f32_e32 v230, v232, v234
		v_add_f32_e32 v231, v233, v235
		v_add_f32_e32 v228, v228, v230
		v_add_f32_e32 v229, v229, v231
		v_add_f32_e32 v230, v228, v229
		v_mov_b32_e32 v231, v230
		v_exp_f32_e32 v196, v196
		v_exp_f32_e32 v197, v197
		v_permlane32_swap_b32_e32 v230, v231
		v_add_f32_e32 v228, v196, v197
		v_add_f32_e32 v229, v212, v213
		v_add_f32_e32 v232, v198, v199
		v_add_f32_e32 v233, v214, v215
		v_add_f32_e32 v234, v200, v201
		v_add_f32_e32 v235, v216, v217
		v_add_f32_e32 v236, v202, v203
		v_add_f32_e32 v237, v218, v219
		v_add_f32_e32 v238, v204, v205
		v_add_f32_e32 v239, v220, v221
		v_add_f32_e32 v240, v206, v207
		v_add_f32_e32 v241, v222, v223
		v_add_f32_e32 v242, v208, v209
		v_add_f32_e32 v243, v224, v225
		v_add_f32_e32 v244, v210, v211
		v_add_f32_e32 v245, v226, v227
		v_add_f32_e32 v228, v228, v232
		v_add_f32_e32 v229, v229, v233
		v_add_f32_e32 v232, v234, v236
		v_add_f32_e32 v233, v235, v237
		v_add_f32_e32 v234, v238, v240
		v_add_f32_e32 v235, v239, v241
		v_add_f32_e32 v236, v242, v244
		v_add_f32_e32 v237, v243, v245
		v_add_f32_e32 v228, v228, v232
		v_add_f32_e32 v229, v229, v233
		v_add_f32_e32 v232, v234, v236
		v_add_f32_e32 v233, v235, v237
		v_add_f32_e32 v228, v228, v232
		v_add_f32_e32 v229, v229, v233
		v_add_f32_e32 v230, v230, v231
		v_add_f32_e32 v232, v228, v229
		v_mov_b32_e32 v233, v232
		v_add_f32_e32 v32, v32, v34
		v_add_f32_e32 v33, v33, v195
		v_cvt_pk_bf16_f32 v236, v35, v36
		v_permlane32_swap_b32_e32 v232, v233
		v_add_f32_e32 v34, v232, v233
		v_exp_f32_e32 v32, v32
		v_exp_f32_e32 v33, v33
		v_cvt_pk_bf16_f32 v237, v37, v38
		v_fma_f32 v30, v30, v32, v230
		v_fma_f32 v31, v31, v33, v34
		v_cvt_pk_bf16_f32 v238, v39, v40
		v_cvt_pk_bf16_f32 v239, v41, v42
		v_cvt_pk_bf16_f32 v36, v43, v44
		v_cvt_pk_bf16_f32 v37, v45, v46
		v_cvt_pk_bf16_f32 v38, v47, v192
		v_cvt_pk_bf16_f32 v39, v193, v194
		v_cvt_pk_bf16_f32 v40, v176, v177
		v_cvt_pk_bf16_f32 v41, v178, v179
		v_cvt_pk_bf16_f32 v42, v180, v181
		v_cvt_pk_bf16_f32 v43, v182, v183
		v_cvt_pk_bf16_f32 v44, v184, v185
		v_cvt_pk_bf16_f32 v45, v186, v187
		v_cvt_pk_bf16_f32 v46, v188, v189
		v_cvt_pk_bf16_f32 v47, v190, v191
		v_mul_f32_e32 v48, v48, v32
		v_mul_f32_e32 v49, v49, v32
		v_mul_f32_e32 v50, v50, v32
		v_mul_f32_e32 v51, v51, v32
		v_mul_f32_e32 v52, v52, v32
		v_mul_f32_e32 v53, v53, v32
		v_mul_f32_e32 v54, v54, v32
		v_mul_f32_e32 v55, v55, v32
		v_mul_f32_e32 v56, v56, v32
		v_mul_f32_e32 v57, v57, v32
		v_mul_f32_e32 v58, v58, v32
		v_mul_f32_e32 v59, v59, v32
		v_mul_f32_e32 v60, v60, v32
		v_mul_f32_e32 v61, v61, v32
		v_mul_f32_e32 v62, v62, v32
		v_mul_f32_e32 v63, v63, v32
		v_mul_f32_e32 v64, v64, v32
		v_mul_f32_e32 v65, v65, v32
		v_mul_f32_e32 v66, v66, v32
		v_mul_f32_e32 v67, v67, v32
		v_mul_f32_e32 v68, v68, v32
		v_mul_f32_e32 v69, v69, v32
		v_mul_f32_e32 v70, v70, v32
		v_mul_f32_e32 v71, v71, v32
		v_mul_f32_e32 v72, v72, v32
		v_mul_f32_e32 v73, v73, v32
		v_mul_f32_e32 v74, v74, v32
		v_mul_f32_e32 v75, v75, v32
		v_mul_f32_e32 v76, v76, v32
		v_mul_f32_e32 v77, v77, v32
		v_mul_f32_e32 v78, v78, v32
		v_mul_f32_e32 v79, v79, v32
		v_mul_f32_e32 v80, v80, v32
		v_mul_f32_e32 v81, v81, v32
		v_mul_f32_e32 v82, v82, v32
		v_mul_f32_e32 v83, v83, v32
		v_mul_f32_e32 v84, v84, v32
		v_mul_f32_e32 v85, v85, v32
		v_mul_f32_e32 v86, v86, v32
		v_mul_f32_e32 v87, v87, v32
		v_mul_f32_e32 v88, v88, v32
		v_mul_f32_e32 v89, v89, v32
		v_mul_f32_e32 v90, v90, v32
		v_mul_f32_e32 v91, v91, v32
		v_mul_f32_e32 v92, v92, v32
		v_mul_f32_e32 v93, v93, v32
		v_mul_f32_e32 v94, v94, v32
		v_mul_f32_e32 v95, v95, v32
		v_mul_f32_e32 v96, v96, v32
		v_mul_f32_e32 v97, v97, v32
		v_mul_f32_e32 v98, v98, v32
		v_mul_f32_e32 v99, v99, v32
		v_mul_f32_e32 v100, v100, v32
		v_mul_f32_e32 v101, v101, v32
		v_mul_f32_e32 v102, v102, v32
		v_mul_f32_e32 v103, v103, v32
		v_mul_f32_e32 v104, v104, v32
		v_mul_f32_e32 v105, v105, v32
		v_mul_f32_e32 v106, v106, v32
		v_mul_f32_e32 v107, v107, v32
		v_mul_f32_e32 v108, v108, v32
		v_mul_f32_e32 v109, v109, v32
		v_mul_f32_e32 v110, v110, v32
		v_mul_f32_e32 v111, v111, v32
		v_mul_f32_e32 v112, v112, v33
		v_mul_f32_e32 v113, v113, v33
		v_mul_f32_e32 v114, v114, v33
		v_mul_f32_e32 v115, v115, v33
		v_mul_f32_e32 v116, v116, v33
		v_mul_f32_e32 v117, v117, v33
		v_mul_f32_e32 v118, v118, v33
		v_mul_f32_e32 v119, v119, v33
		v_mul_f32_e32 v120, v120, v33
		v_mul_f32_e32 v121, v121, v33
		v_mul_f32_e32 v122, v122, v33
		v_mul_f32_e32 v123, v123, v33
		v_mul_f32_e32 v124, v124, v33
		v_mul_f32_e32 v125, v125, v33
		v_mul_f32_e32 v126, v126, v33
		v_mul_f32_e32 v127, v127, v33
		v_mul_f32_e32 v128, v128, v33
		v_mul_f32_e32 v129, v129, v33
		v_mul_f32_e32 v130, v130, v33
		v_mul_f32_e32 v131, v131, v33
		v_mul_f32_e32 v132, v132, v33
		v_mul_f32_e32 v133, v133, v33
		v_mul_f32_e32 v134, v134, v33
		v_mul_f32_e32 v135, v135, v33
		v_mul_f32_e32 v136, v136, v33
		v_mul_f32_e32 v137, v137, v33
		v_mul_f32_e32 v138, v138, v33
		v_mul_f32_e32 v139, v139, v33
		v_mul_f32_e32 v140, v140, v33
		v_mul_f32_e32 v141, v141, v33
		v_mul_f32_e32 v142, v142, v33
		v_mul_f32_e32 v143, v143, v33
		v_mul_f32_e32 v144, v144, v33
		v_mul_f32_e32 v145, v145, v33
		v_mul_f32_e32 v146, v146, v33
		v_mul_f32_e32 v147, v147, v33
		v_mul_f32_e32 v148, v148, v33
		v_mul_f32_e32 v149, v149, v33
		v_mul_f32_e32 v150, v150, v33
		v_mul_f32_e32 v151, v151, v33
		v_mul_f32_e32 v152, v152, v33
		v_mul_f32_e32 v153, v153, v33
		v_mul_f32_e32 v154, v154, v33
		v_mul_f32_e32 v155, v155, v33
		v_mul_f32_e32 v156, v156, v33
		v_mul_f32_e32 v157, v157, v33
		v_mul_f32_e32 v158, v158, v33
		v_mul_f32_e32 v159, v159, v33
		v_mul_f32_e32 v160, v160, v33
		v_mul_f32_e32 v161, v161, v33
		v_mul_f32_e32 v162, v162, v33
		v_mul_f32_e32 v163, v163, v33
		v_mul_f32_e32 v164, v164, v33
		v_mul_f32_e32 v165, v165, v33
		v_mul_f32_e32 v166, v166, v33
		v_mul_f32_e32 v167, v167, v33
		v_mul_f32_e32 v168, v168, v33
		v_mul_f32_e32 v169, v169, v33
		v_mul_f32_e32 v170, v170, v33
		v_mul_f32_e32 v171, v171, v33
		v_mul_f32_e32 v172, v172, v33
		v_mul_f32_e32 v173, v173, v33
		v_mul_f32_e32 v174, v174, v33
		v_mul_f32_e32 v175, v175, v33
		v_cvt_pk_bf16_f32 v32, v196, v197
		v_cvt_pk_bf16_f32 v33, v198, v199
		v_cvt_pk_bf16_f32 v34, v200, v201
		v_cvt_pk_bf16_f32 v35, v202, v203
		v_cvt_pk_bf16_f32 v176, v204, v205
		v_cvt_pk_bf16_f32 v177, v206, v207
		v_cvt_pk_bf16_f32 v178, v208, v209
		v_cvt_pk_bf16_f32 v179, v210, v211
		v_cvt_pk_bf16_f32 v180, v212, v213
		v_cvt_pk_bf16_f32 v181, v214, v215
		v_cvt_pk_bf16_f32 v182, v216, v217
		v_cvt_pk_bf16_f32 v183, v218, v219
		v_cvt_pk_bf16_f32 v184, v220, v221
		v_cvt_pk_bf16_f32 v185, v222, v223
		v_cvt_pk_bf16_f32 v186, v224, v225
		v_cvt_pk_bf16_f32 v187, v226, v227
		v_permlane32_swap_b32_e32 v236, v238
		v_permlane32_swap_b32_e32 v237, v239
		v_permlane32_swap_b32_e32 v36, v38
		v_permlane32_swap_b32_e32 v37, v39
		v_mfma_f32_32x32x16_bf16 v[48:63], a[84:87], v[236:239], v[48:63]
		v_permlane32_swap_b32_e32 v40, v42
		v_permlane32_swap_b32_e32 v41, v43
		v_mfma_f32_32x32x16_bf16 v[64:79], a[100:103], v[236:239], v[64:79]
		v_permlane32_swap_b32_e32 v44, v46
		v_permlane32_swap_b32_e32 v45, v47
		v_mfma_f32_32x32x16_bf16 v[80:95], a[116:119], v[236:239], v[80:95]
		v_permlane32_swap_b32_e32 v32, v34
		v_permlane32_swap_b32_e32 v33, v35
		v_mfma_f32_32x32x16_bf16 v[96:111], a[132:135], v[236:239], v[96:111]
		v_permlane32_swap_b32_e32 v176, v178
		v_permlane32_swap_b32_e32 v177, v179
		v_mfma_f32_32x32x16_bf16 v[160:175], a[132:135], v[32:35], v[160:175]
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		v_mfma_f32_32x32x16_bf16 v[112:127], a[84:87], v[32:35], v[112:127]
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_mfma_f32_32x32x16_bf16 v[128:143], a[100:103], v[32:35], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[116:119], v[32:35], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[88:91], v[36:39], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[104:107], v[36:39], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[120:123], v[36:39], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[136:139], v[36:39], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[136:139], v[176:179], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[88:91], v[176:179], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[104:107], v[176:179], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[120:123], v[176:179], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[92:95], v[40:43], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[108:111], v[40:43], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[124:127], v[40:43], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[140:143], v[40:43], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[140:143], v[180:183], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[92:95], v[180:183], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[108:111], v[180:183], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[124:127], v[180:183], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[96:99], v[44:47], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[112:115], v[44:47], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[128:131], v[44:47], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[144:147], v[44:47], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[144:147], v[184:187], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[96:99], v[184:187], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[112:115], v[184:187], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[128:131], v[184:187], v[144:159]
		v_mov_b32_e32 v32, v27
		v_mov_b32_e32 v33, v29
		s_cbranch_scc1 .L_attn_fwd_async_prefetch.loop_head_0
.L_attn_fwd_async_prefetch.loop_exit_0:
		s_waitcnt vmcnt(0)
		s_barrier
		s_and_b32 s1, s5, 1
		s_mul_i32 s3, 0x4100, s1
		v_lshl_add_u32 v2, v14, 4, s3
		v_add3_u32 v2, v2, v24, v25
		ds_read_b128 v[16:19], v2
		ds_read_b128 v[36:39], v2 offset:32
		ds_read_b128 v[40:43], v2 offset:64
		ds_read_b128 v[44:47], v2 offset:96
		ds_read_b128 a[64:67], v2 offset:128
		ds_read_b128 a[68:71], v2 offset:160
		ds_read_b128 a[72:75], v2 offset:192
		ds_read_b128 a[76:79], v2 offset:224
		ds_read_b128 v[176:179], v2 offset:512
		ds_read_b128 v[180:183], v2 offset:544
		ds_read_b128 v[184:187], v2 offset:576
		ds_read_b128 v[188:191], v2 offset:608
		ds_read_b128 a[80:83], v2 offset:640
		ds_read_b128 a[84:87], v2 offset:672
		ds_read_b128 a[88:91], v2 offset:704
		ds_read_b128 a[92:95], v2 offset:736
		s_mul_i32 s1, 0x4400, s1
		v_lshlrev_b32_e32 v2, 3, v23
		v_add3_u32 v2, s1, v2, v26
		v_lshl_add_u32 v1, v1, 5, v2
		v_add3_u32 v1, v1, v8, v28
		ds_read_b64_tr_b16 a[96:97], v1 offset:33264
		ds_read_b64_tr_b16 a[98:99], v1 offset:37616
		ds_read_b64_tr_b16 a[100:101], v1 offset:33520
		ds_read_b64_tr_b16 a[102:103], v1 offset:37872
		ds_read_b64_tr_b16 a[104:105], v1 offset:33776
		ds_read_b64_tr_b16 a[106:107], v1 offset:38128
		ds_read_b64_tr_b16 a[108:109], v1 offset:34032
		ds_read_b64_tr_b16 a[110:111], v1 offset:38384
		ds_read_b64_tr_b16 a[112:113], v1 offset:33328
		ds_read_b64_tr_b16 a[114:115], v1 offset:37680
		ds_read_b64_tr_b16 a[116:117], v1 offset:33584
		ds_read_b64_tr_b16 a[118:119], v1 offset:37936
		ds_read_b64_tr_b16 a[120:121], v1 offset:33840
		ds_read_b64_tr_b16 a[122:123], v1 offset:38192
		ds_read_b64_tr_b16 a[124:125], v1 offset:34096
		ds_read_b64_tr_b16 a[126:127], v1 offset:38448
		ds_read_b64_tr_b16 a[128:129], v1 offset:33392
		ds_read_b64_tr_b16 a[130:131], v1 offset:37744
		ds_read_b64_tr_b16 a[132:133], v1 offset:33648
		ds_read_b64_tr_b16 a[134:135], v1 offset:38000
		ds_read_b64_tr_b16 a[136:137], v1 offset:33904
		ds_read_b64_tr_b16 a[138:139], v1 offset:38256
		ds_read_b64_tr_b16 a[140:141], v1 offset:34160
		ds_read_b64_tr_b16 a[142:143], v1 offset:38512
		ds_read_b64_tr_b16 a[144:145], v1 offset:33456
		ds_read_b64_tr_b16 a[146:147], v1 offset:37808
		ds_read_b64_tr_b16 a[148:149], v1 offset:33712
		ds_read_b64_tr_b16 a[150:151], v1 offset:38064
		ds_read_b64_tr_b16 a[152:153], v1 offset:33968
		ds_read_b64_tr_b16 a[154:155], v1 offset:38320
		ds_read_b64_tr_b16 a[156:157], v1 offset:34224
		ds_read_b64_tr_b16 a[158:159], v1 offset:38576
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[192:207], v[16:19], a[0:3], 0
		s_mul_i32 s1, s16, s23
		v_mfma_f32_32x32x16_bf16 v[208:223], v[176:179], a[0:3], 0
		s_lshl_b32 s1, s1, 9
		v_mfma_f32_32x32x16_bf16 v[224:239], v[176:179], a[32:35], 0
		s_mul_i32 s3, s17, s21
		v_mfma_f32_32x32x16_bf16 v[240:255], v[16:19], a[32:35], 0
		s_lshl_b32 s3, s3, 1
		v_mfma_f32_32x32x16_bf16 v[192:207], v[36:39], a[4:7], v[192:207]
		s_add_i32 s4, s1, s3
		v_mfma_f32_32x32x16_bf16 v[208:223], v[180:183], a[4:7], v[208:223]
		s_mul_i32 s0, s0, s22
		v_mfma_f32_32x32x16_bf16 v[224:239], v[180:183], a[36:39], v[224:239]
		s_lshl_b32 s0, s0, 1
		v_mfma_f32_32x32x16_bf16 v[240:255], v[36:39], a[36:39], v[240:255]
		s_add_i32 s4, s4, s0
		v_mfma_f32_32x32x16_bf16 v[192:207], v[40:43], a[8:11], v[192:207]
		s_mul_i32 s2, s23, s2
		v_mfma_f32_32x32x16_bf16 v[208:223], v[184:187], a[8:11], v[208:223]
		s_lshl_b32 s2, s2, 6
		v_mfma_f32_32x32x16_bf16 v[224:239], v[184:187], a[40:43], v[224:239]
		s_add_i32 s4, s4, s2
		v_mfma_f32_32x32x16_bf16 v[240:255], v[40:43], a[40:43], v[240:255]
		v_and_b32_e32 v0, 31, v0
		v_mfma_f32_32x32x16_bf16 v[192:207], v[44:47], a[12:15], v[192:207]
		v_mul_lo_u32 v0, s23, v0
		v_mfma_f32_32x32x16_bf16 v[208:223], v[188:191], a[12:15], v[208:223]
		v_lshlrev_b32_e32 v0, 1, v0
		v_mfma_f32_32x32x16_bf16 v[224:239], v[188:191], a[44:47], v[224:239]
		v_lshlrev_b32_e32 v1, 4, v5
		v_mfma_f32_32x32x16_bf16 v[240:255], v[44:47], a[44:47], v[240:255]
		s_add_i32 s5, s4, 32
		v_mfma_f32_32x32x16_bf16 v[192:207], a[64:67], a[16:19], v[192:207]
		s_add_i32 s6, s4, 64
		v_mfma_f32_32x32x16_bf16 v[208:223], a[80:83], a[16:19], v[208:223]
		s_add_i32 s7, s4, 0x60
		v_mfma_f32_32x32x16_bf16 v[224:239], a[80:83], a[48:51], v[224:239]
		s_add_i32 s10, s4, 0x80
		v_mfma_f32_32x32x16_bf16 v[240:255], a[64:67], a[48:51], v[240:255]
		s_add_i32 s11, s4, 0xa0
		v_mfma_f32_32x32x16_bf16 v[192:207], a[68:71], a[20:23], v[192:207]
		s_add_i32 s15, s4, 0xc0
		v_mfma_f32_32x32x16_bf16 v[208:223], a[84:87], a[20:23], v[208:223]
		s_add_i32 s16, s4, 0xe0
		v_mfma_f32_32x32x16_bf16 v[224:239], a[84:87], a[52:55], v[224:239]
		s_lshl_b32 s17, s23, 8
		v_mfma_f32_32x32x16_bf16 v[240:255], a[68:71], a[52:55], v[240:255]
		s_add_i32 s1, s17, s1
		v_mfma_f32_32x32x16_bf16 v[192:207], a[72:75], a[24:27], v[192:207]
		s_add_i32 s1, s1, s3
		v_mfma_f32_32x32x16_bf16 v[208:223], a[88:91], a[24:27], v[208:223]
		s_add_i32 s0, s1, s0
		v_mfma_f32_32x32x16_bf16 v[224:239], a[88:91], a[56:59], v[224:239]
		s_add_i32 s0, s0, s2
		v_mfma_f32_32x32x16_bf16 v[240:255], a[72:75], a[56:59], v[240:255]
		s_add_i32 s1, s0, 32
		v_mfma_f32_32x32x16_bf16 v[192:207], a[76:79], a[28:31], v[192:207]
		s_add_i32 s2, s0, 64
		v_mfma_f32_32x32x16_bf16 v[208:223], a[92:95], a[28:31], v[208:223]
		s_add_i32 s3, s0, 0x60
		v_mfma_f32_32x32x16_bf16 v[224:239], a[92:95], a[60:63], v[224:239]
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
		v_cndmask_b32_e64 v6, v7, v196, s[18:19]
		v_cndmask_b32_e64 v8, v7, v197, s[18:19]
		v_cndmask_b32_e64 v9, v7, v198, s[18:19]
		v_cndmask_b32_e64 v11, v7, v199, s[18:19]
		v_cndmask_b32_e64 v12, v7, v200, s[20:21]
		v_cndmask_b32_e64 v14, v7, v201, s[20:21]
		v_cndmask_b32_e64 v15, v7, v202, s[20:21]
		v_cndmask_b32_e64 v16, v7, v203, s[20:21]
		v_cndmask_b32_e64 v17, v7, v204, s[20:21]
		v_cndmask_b32_e64 v18, v7, v205, s[20:21]
		v_cndmask_b32_e64 v19, v7, v206, s[20:21]
		v_cndmask_b32_e64 v20, v7, v207, s[20:21]
		v_cndmask_b32_e64 v21, v7, v208, s[22:23]
		v_cndmask_b32_e64 v22, v7, v209, s[22:23]
		v_cndmask_b32_e64 v23, v7, v210, s[22:23]
		v_cndmask_b32_e64 v24, v7, v211, s[22:23]
		v_cndmask_b32_e64 v25, v7, v212, s[22:23]
		v_cndmask_b32_e64 v26, v7, v213, s[22:23]
		v_cndmask_b32_e64 v27, v7, v214, s[22:23]
		v_cndmask_b32_e64 v28, v7, v215, s[22:23]
		v_cndmask_b32_e32 v29, v7, v216, vcc
		v_cndmask_b32_e32 v34, v7, v217, vcc
		v_cndmask_b32_e32 v35, v7, v218, vcc
		v_cndmask_b32_e32 v36, v7, v219, vcc
		v_cndmask_b32_e32 v37, v7, v220, vcc
		v_cndmask_b32_e32 v38, v7, v221, vcc
		v_cndmask_b32_e32 v39, v7, v222, vcc
		v_cndmask_b32_e32 v40, v7, v223, vcc
		v_cndmask_b32_e64 v41, v7, v242, s[18:19]
		v_cndmask_b32_e64 v42, v7, v243, s[18:19]
		v_cndmask_b32_e64 v43, v7, v244, s[18:19]
		v_cndmask_b32_e64 v44, v7, v245, s[18:19]
		v_cndmask_b32_e64 v45, v7, v246, s[18:19]
		v_cndmask_b32_e64 v46, v7, v247, s[18:19]
		v_cndmask_b32_e64 v47, v7, v248, s[20:21]
		v_cndmask_b32_e64 v176, v7, v249, s[20:21]
		v_cndmask_b32_e64 v177, v7, v250, s[20:21]
		v_cndmask_b32_e64 v178, v7, v251, s[20:21]
		v_cndmask_b32_e64 v179, v7, v252, s[20:21]
		v_cndmask_b32_e64 v180, v7, v253, s[20:21]
		v_cndmask_b32_e64 v181, v7, v254, s[20:21]
		v_cndmask_b32_e64 v182, v7, v255, s[20:21]
		v_cndmask_b32_e64 v183, v7, v224, s[22:23]
		v_cndmask_b32_e64 v184, v7, v225, s[22:23]
		v_cndmask_b32_e64 v185, v7, v226, s[22:23]
		v_cndmask_b32_e64 v186, v7, v227, s[22:23]
		v_cndmask_b32_e64 v187, v7, v228, s[22:23]
		v_cndmask_b32_e64 v188, v7, v229, s[22:23]
		v_cndmask_b32_e64 v189, v7, v230, s[22:23]
		v_cndmask_b32_e64 v190, v7, v231, s[22:23]
		v_cndmask_b32_e32 v191, v7, v232, vcc
		v_cndmask_b32_e32 v192, v7, v233, vcc
		v_cndmask_b32_e32 v193, v7, v234, vcc
		v_cndmask_b32_e32 v194, v7, v235, vcc
		v_cndmask_b32_e32 v195, v7, v236, vcc
		v_cndmask_b32_e32 v196, v7, v237, vcc
		v_cndmask_b32_e32 v197, v7, v238, vcc
		v_cndmask_b32_e32 v198, v7, v239, vcc
		v_max3_f32 v199, v2, v3, v4
		v_max3_f32 v200, v6, v8, v9
		v_max3_f32 v201, v12, v14, v15
		v_max3_f32 v202, v17, v18, v19
		v_max3_f32 v203, v21, v22, v23
		v_max3_f32 v204, v25, v26, v27
		v_max3_f32 v205, v29, v34, v35
		v_max3_f32 v206, v37, v38, v39
		v_max3_f32 v199, v199, v5, v200
		v_max3_f32 v200, v201, v16, v202
		v_max3_f32 v201, v203, v24, v204
		v_max3_f32 v202, v205, v36, v206
		v_max3_f32 v199, v199, v11, v200
		v_max3_f32 v200, v201, v28, v202
		v_max3_f32 v199, v199, v20, v200
		v_max_f32_e32 v200, v199, v40
		v_mov_b32_e32 v201, v200
		v_cndmask_b32_e64 v199, v7, v240, s[18:19]
		v_cndmask_b32_e64 v7, v7, v241, s[18:19]
		v_permlane32_swap_b32_e32 v200, v201
		v_max3_f32 v202, v199, v7, v41
		v_max3_f32 v203, v43, v44, v45
		v_max3_f32 v204, v47, v176, v177
		v_max3_f32 v205, v179, v180, v181
		v_max3_f32 v206, v183, v184, v185
		v_max3_f32 v207, v187, v188, v189
		v_max3_f32 v208, v191, v192, v193
		v_max3_f32 v209, v195, v196, v197
		v_max3_f32 v202, v202, v42, v203
		v_max3_f32 v203, v204, v178, v205
		v_max3_f32 v204, v206, v186, v207
		v_max3_f32 v205, v208, v194, v209
		v_max3_f32 v202, v202, v46, v203
		v_max3_f32 v203, v204, v190, v205
		v_max3_f32 v202, v202, v182, v203
		v_max_f32_e32 v204, v202, v198
		v_mov_b32_e32 v205, v204
		v_max_f32_e32 v200, v200, v201
		s_add_i32 s14, s0, 0xa0
		v_permlane32_swap_b32_e32 v204, v205
		v_max_f32_e32 v201, v204, v205
		v_mul_f32_e32 v200, v200, v10
		v_mul_f32_e32 v201, v201, v10
		v_max_f32_e32 v200, v32, v200
		v_max_f32_e32 v201, v33, v201
		v_xor_b32_e32 v200, 0x80000000, v200
		v_fma_f32 v2, v2, v10, v200
		v_fma_f32 v3, v3, v10, v200
		v_fma_f32 v4, v4, v10, v200
		v_fma_f32 v5, v5, v10, v200
		v_fma_f32 v6, v6, v10, v200
		v_fma_f32 v8, v8, v10, v200
		v_fma_f32 v9, v9, v10, v200
		v_fma_f32 v11, v11, v10, v200
		v_fma_f32 v12, v12, v10, v200
		v_fma_f32 v14, v14, v10, v200
		v_fma_f32 v15, v15, v10, v200
		v_fma_f32 v16, v16, v10, v200
		v_fma_f32 v17, v17, v10, v200
		v_fma_f32 v18, v18, v10, v200
		v_fma_f32 v19, v19, v10, v200
		v_fma_f32 v20, v20, v10, v200
		v_fma_f32 v21, v21, v10, v200
		v_fma_f32 v22, v22, v10, v200
		v_fma_f32 v23, v23, v10, v200
		v_fma_f32 v24, v24, v10, v200
		v_fma_f32 v25, v25, v10, v200
		v_fma_f32 v26, v26, v10, v200
		v_fma_f32 v27, v27, v10, v200
		v_fma_f32 v28, v28, v10, v200
		v_fma_f32 v29, v29, v10, v200
		v_fma_f32 v34, v34, v10, v200
		v_fma_f32 v35, v35, v10, v200
		v_fma_f32 v36, v36, v10, v200
		v_fma_f32 v37, v37, v10, v200
		v_fma_f32 v38, v38, v10, v200
		v_fma_f32 v39, v39, v10, v200
		v_fma_f32 v40, v40, v10, v200
		v_xor_b32_e32 v201, 0x80000000, v201
		v_fma_f32 v199, v199, v10, v201
		v_fma_f32 v7, v7, v10, v201
		v_fma_f32 v41, v41, v10, v201
		v_fma_f32 v42, v42, v10, v201
		v_fma_f32 v43, v43, v10, v201
		v_fma_f32 v44, v44, v10, v201
		v_fma_f32 v45, v45, v10, v201
		v_fma_f32 v46, v46, v10, v201
		v_fma_f32 v47, v47, v10, v201
		v_fma_f32 v176, v176, v10, v201
		v_fma_f32 v177, v177, v10, v201
		v_fma_f32 v178, v178, v10, v201
		v_fma_f32 v179, v179, v10, v201
		v_fma_f32 v180, v180, v10, v201
		v_fma_f32 v181, v181, v10, v201
		v_fma_f32 v182, v182, v10, v201
		v_fma_f32 v183, v183, v10, v201
		v_fma_f32 v184, v184, v10, v201
		v_fma_f32 v185, v185, v10, v201
		v_fma_f32 v186, v186, v10, v201
		v_fma_f32 v187, v187, v10, v201
		v_fma_f32 v188, v188, v10, v201
		v_fma_f32 v189, v189, v10, v201
		v_fma_f32 v190, v190, v10, v201
		v_fma_f32 v191, v191, v10, v201
		v_fma_f32 v192, v192, v10, v201
		v_fma_f32 v193, v193, v10, v201
		v_fma_f32 v194, v194, v10, v201
		v_fma_f32 v195, v195, v10, v201
		v_fma_f32 v196, v196, v10, v201
		v_fma_f32 v197, v197, v10, v201
		v_fma_f32 v10, v198, v10, v201
		v_exp_f32_e32 v2, v2
		v_exp_f32_e32 v3, v3
		v_exp_f32_e32 v4, v4
		v_exp_f32_e32 v5, v5
		v_exp_f32_e32 v6, v6
		v_exp_f32_e32 v8, v8
		v_exp_f32_e32 v9, v9
		v_exp_f32_e32 v11, v11
		v_exp_f32_e32 v12, v12
		v_exp_f32_e32 v14, v14
		v_exp_f32_e32 v15, v15
		v_exp_f32_e32 v16, v16
		v_exp_f32_e32 v17, v17
		v_exp_f32_e32 v18, v18
		v_exp_f32_e32 v19, v19
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
		v_exp_f32_e32 v34, v34
		v_exp_f32_e32 v35, v35
		v_exp_f32_e32 v36, v36
		v_exp_f32_e32 v37, v37
		v_exp_f32_e32 v38, v38
		v_exp_f32_e32 v39, v39
		v_exp_f32_e32 v40, v40
		v_exp_f32_e32 v41, v41
		v_exp_f32_e32 v42, v42
		v_exp_f32_e32 v43, v43
		v_exp_f32_e32 v44, v44
		v_exp_f32_e32 v45, v45
		v_exp_f32_e32 v46, v46
		v_exp_f32_e32 v47, v47
		v_exp_f32_e32 v176, v176
		v_exp_f32_e32 v177, v177
		v_exp_f32_e32 v178, v178
		v_exp_f32_e32 v179, v179
		v_exp_f32_e32 v180, v180
		v_exp_f32_e32 v181, v181
		v_exp_f32_e32 v182, v182
		v_exp_f32_e32 v183, v183
		v_exp_f32_e32 v184, v184
		v_exp_f32_e32 v185, v185
		v_exp_f32_e32 v186, v186
		v_exp_f32_e32 v187, v187
		v_exp_f32_e32 v188, v188
		v_exp_f32_e32 v189, v189
		v_exp_f32_e32 v190, v190
		v_exp_f32_e32 v191, v191
		v_exp_f32_e32 v192, v192
		v_exp_f32_e32 v193, v193
		v_exp_f32_e32 v194, v194
		v_exp_f32_e32 v195, v195
		v_exp_f32_e32 v196, v196
		v_exp_f32_e32 v197, v197
		v_exp_f32_e32 v10, v10
		v_add_f32_e32 v198, v2, v3
		v_add_f32_e32 v202, v21, v22
		v_add_f32_e32 v203, v4, v5
		v_add_f32_e32 v204, v23, v24
		v_add_f32_e32 v205, v6, v8
		v_add_f32_e32 v206, v25, v26
		v_add_f32_e32 v207, v9, v11
		v_add_f32_e32 v208, v27, v28
		v_add_f32_e32 v209, v12, v14
		v_add_f32_e32 v210, v29, v34
		v_add_f32_e32 v211, v15, v16
		v_add_f32_e32 v212, v35, v36
		v_add_f32_e32 v213, v17, v18
		v_add_f32_e32 v214, v37, v38
		v_add_f32_e32 v215, v19, v20
		v_add_f32_e32 v216, v39, v40
		v_add_f32_e32 v198, v198, v203
		v_add_f32_e32 v202, v202, v204
		v_add_f32_e32 v203, v205, v207
		v_add_f32_e32 v204, v206, v208
		v_add_f32_e32 v205, v209, v211
		v_add_f32_e32 v206, v210, v212
		v_add_f32_e32 v207, v213, v215
		v_add_f32_e32 v208, v214, v216
		v_add_f32_e32 v198, v198, v203
		v_add_f32_e32 v202, v202, v204
		v_add_f32_e32 v203, v205, v207
		v_add_f32_e32 v204, v206, v208
		v_add_f32_e32 v198, v198, v203
		v_add_f32_e32 v202, v202, v204
		v_add_f32_e32 v204, v198, v202
		v_mov_b32_e32 v205, v204
		v_exp_f32_e32 v198, v199
		v_exp_f32_e32 v7, v7
		v_permlane32_swap_b32_e32 v204, v205
		v_add_f32_e32 v199, v198, v7
		v_add_f32_e32 v202, v183, v184
		v_add_f32_e32 v203, v41, v42
		v_add_f32_e32 v206, v185, v186
		v_add_f32_e32 v207, v43, v44
		v_add_f32_e32 v208, v187, v188
		v_add_f32_e32 v209, v45, v46
		v_add_f32_e32 v210, v189, v190
		v_add_f32_e32 v211, v47, v176
		v_add_f32_e32 v212, v191, v192
		v_add_f32_e32 v213, v177, v178
		v_add_f32_e32 v214, v193, v194
		v_add_f32_e32 v215, v179, v180
		v_add_f32_e32 v216, v195, v196
		v_add_f32_e32 v217, v181, v182
		v_add_f32_e32 v218, v197, v10
		v_add_f32_e32 v199, v199, v203
		v_add_f32_e32 v202, v202, v206
		v_add_f32_e32 v203, v207, v209
		v_add_f32_e32 v206, v208, v210
		v_add_f32_e32 v207, v211, v213
		v_add_f32_e32 v208, v212, v214
		v_add_f32_e32 v209, v215, v217
		v_add_f32_e32 v210, v216, v218
		v_add_f32_e32 v199, v199, v203
		v_add_f32_e32 v202, v202, v206
		v_add_f32_e32 v203, v207, v209
		v_add_f32_e32 v206, v208, v210
		v_add_f32_e32 v199, v199, v203
		v_add_f32_e32 v202, v202, v206
		v_add_f32_e32 v203, v204, v205
		v_add_f32_e32 v204, v199, v202
		v_mov_b32_e32 v205, v204
		v_add_f32_e32 v32, v32, v200
		v_add_f32_e32 v33, v33, v201
		v_cvt_pk_bf16_f32 v208, v2, v3
		v_permlane32_swap_b32_e32 v204, v205
		v_add_f32_e32 v2, v204, v205
		v_exp_f32_e32 v3, v32
		v_exp_f32_e32 v32, v33
		v_cvt_pk_bf16_f32 v209, v4, v5
		v_mul_f32_e32 v224, v48, v3
		v_mul_f32_e32 v225, v49, v3
		v_mul_f32_e32 v226, v50, v3
		v_mul_f32_e32 v227, v51, v3
		v_mul_f32_e32 v228, v52, v3
		v_mul_f32_e32 v229, v53, v3
		v_mul_f32_e32 v230, v54, v3
		v_mul_f32_e32 v231, v55, v3
		v_mul_f32_e32 v232, v56, v3
		v_mul_f32_e32 v233, v57, v3
		v_mul_f32_e32 v234, v58, v3
		v_mul_f32_e32 v235, v59, v3
		v_mul_f32_e32 v236, v60, v3
		v_mul_f32_e32 v237, v61, v3
		v_mul_f32_e32 v238, v62, v3
		v_mul_f32_e32 v239, v63, v3
		v_mul_f32_e32 v48, v64, v3
		v_mul_f32_e32 v49, v65, v3
		v_mul_f32_e32 v50, v66, v3
		v_mul_f32_e32 v51, v67, v3
		v_mul_f32_e32 v52, v68, v3
		v_mul_f32_e32 v53, v69, v3
		v_mul_f32_e32 v54, v70, v3
		v_mul_f32_e32 v55, v71, v3
		v_mul_f32_e32 v56, v72, v3
		v_mul_f32_e32 v57, v73, v3
		v_mul_f32_e32 v58, v74, v3
		v_mul_f32_e32 v59, v75, v3
		v_mul_f32_e32 v60, v76, v3
		v_mul_f32_e32 v61, v77, v3
		v_mul_f32_e32 v62, v78, v3
		v_mul_f32_e32 v63, v79, v3
		v_mul_f32_e32 v64, v80, v3
		v_mul_f32_e32 v65, v81, v3
		v_mul_f32_e32 v66, v82, v3
		v_mul_f32_e32 v67, v83, v3
		v_mul_f32_e32 v68, v84, v3
		v_mul_f32_e32 v69, v85, v3
		v_mul_f32_e32 v70, v86, v3
		v_mul_f32_e32 v71, v87, v3
		v_mul_f32_e32 v72, v88, v3
		v_mul_f32_e32 v73, v89, v3
		v_mul_f32_e32 v74, v90, v3
		v_mul_f32_e32 v75, v91, v3
		v_mul_f32_e32 v76, v92, v3
		v_mul_f32_e32 v77, v93, v3
		v_mul_f32_e32 v78, v94, v3
		v_mul_f32_e32 v79, v95, v3
		v_mul_f32_e32 v80, v96, v3
		v_mul_f32_e32 v81, v97, v3
		v_mul_f32_e32 v82, v98, v3
		v_mul_f32_e32 v83, v99, v3
		v_mul_f32_e32 v84, v100, v3
		v_mul_f32_e32 v85, v101, v3
		v_mul_f32_e32 v86, v102, v3
		v_mul_f32_e32 v87, v103, v3
		v_mul_f32_e32 v88, v104, v3
		v_mul_f32_e32 v89, v105, v3
		v_mul_f32_e32 v90, v106, v3
		v_mul_f32_e32 v91, v107, v3
		v_mul_f32_e32 v92, v108, v3
		v_mul_f32_e32 v93, v109, v3
		v_mul_f32_e32 v94, v110, v3
		v_mul_f32_e32 v95, v111, v3
		v_mul_f32_e32 v96, v112, v32
		v_mul_f32_e32 v97, v113, v32
		v_mul_f32_e32 v98, v114, v32
		v_mul_f32_e32 v99, v115, v32
		v_mul_f32_e32 v100, v116, v32
		v_mul_f32_e32 v101, v117, v32
		v_mul_f32_e32 v102, v118, v32
		v_mul_f32_e32 v103, v119, v32
		v_mul_f32_e32 v104, v120, v32
		v_mul_f32_e32 v105, v121, v32
		v_mul_f32_e32 v106, v122, v32
		v_mul_f32_e32 v107, v123, v32
		v_mul_f32_e32 v108, v124, v32
		v_mul_f32_e32 v109, v125, v32
		v_mul_f32_e32 v110, v126, v32
		v_mul_f32_e32 v111, v127, v32
		v_mul_f32_e32 v112, v128, v32
		v_mul_f32_e32 v113, v129, v32
		v_mul_f32_e32 v114, v130, v32
		v_mul_f32_e32 v115, v131, v32
		v_mul_f32_e32 v116, v132, v32
		v_mul_f32_e32 v117, v133, v32
		v_mul_f32_e32 v118, v134, v32
		v_mul_f32_e32 v119, v135, v32
		v_mul_f32_e32 v120, v136, v32
		v_mul_f32_e32 v121, v137, v32
		v_mul_f32_e32 v122, v138, v32
		v_mul_f32_e32 v123, v139, v32
		v_mul_f32_e32 v124, v140, v32
		v_mul_f32_e32 v125, v141, v32
		v_mul_f32_e32 v126, v142, v32
		v_mul_f32_e32 v127, v143, v32
		v_mul_f32_e32 v128, v144, v32
		v_mul_f32_e32 v129, v145, v32
		v_mul_f32_e32 v130, v146, v32
		v_mul_f32_e32 v131, v147, v32
		v_mul_f32_e32 v132, v148, v32
		v_mul_f32_e32 v133, v149, v32
		v_mul_f32_e32 v134, v150, v32
		v_mul_f32_e32 v135, v151, v32
		v_mul_f32_e32 v136, v152, v32
		v_mul_f32_e32 v137, v153, v32
		v_mul_f32_e32 v138, v154, v32
		v_mul_f32_e32 v139, v155, v32
		v_mul_f32_e32 v140, v156, v32
		v_mul_f32_e32 v141, v157, v32
		v_mul_f32_e32 v142, v158, v32
		v_mul_f32_e32 v143, v159, v32
		v_mul_f32_e32 v144, v160, v32
		v_mul_f32_e32 v145, v161, v32
		v_mul_f32_e32 v146, v162, v32
		v_mul_f32_e32 v147, v163, v32
		v_mul_f32_e32 v148, v164, v32
		v_mul_f32_e32 v149, v165, v32
		v_mul_f32_e32 v150, v166, v32
		v_mul_f32_e32 v151, v167, v32
		v_mul_f32_e32 v152, v168, v32
		v_mul_f32_e32 v153, v169, v32
		v_mul_f32_e32 v154, v170, v32
		v_mul_f32_e32 v155, v171, v32
		v_mul_f32_e32 v156, v172, v32
		v_mul_f32_e32 v157, v173, v32
		v_mul_f32_e32 v158, v174, v32
		v_mul_f32_e32 v159, v175, v32
		v_fma_f32 v3, v30, v3, v203
		v_fma_f32 v2, v31, v32, v2
		v_cvt_pk_bf16_f32 v210, v6, v8
		v_cvt_pk_bf16_f32 v211, v9, v11
		v_cvt_pk_bf16_f32 v160, v12, v14
		v_cvt_pk_bf16_f32 v161, v15, v16
		v_cvt_pk_bf16_f32 v162, v17, v18
		v_cvt_pk_bf16_f32 v163, v19, v20
		v_cvt_pk_bf16_f32 v16, v21, v22
		v_cvt_pk_bf16_f32 v17, v23, v24
		v_cvt_pk_bf16_f32 v18, v25, v26
		v_cvt_pk_bf16_f32 v19, v27, v28
		v_cvt_pk_bf16_f32 v20, v29, v34
		v_cvt_pk_bf16_f32 v21, v35, v36
		v_cvt_pk_bf16_f32 v22, v37, v38
		v_cvt_pk_bf16_f32 v23, v39, v40
		v_cvt_pk_bf16_f32 v24, v198, v7
		v_cvt_pk_bf16_f32 v25, v41, v42
		v_cvt_pk_bf16_f32 v26, v43, v44
		v_cvt_pk_bf16_f32 v27, v45, v46
		v_cvt_pk_bf16_f32 v4, v47, v176
		v_cvt_pk_bf16_f32 v5, v177, v178
		v_cvt_pk_bf16_f32 v6, v179, v180
		v_cvt_pk_bf16_f32 v7, v181, v182
		v_cvt_pk_bf16_f32 v28, v183, v184
		v_cvt_pk_bf16_f32 v29, v185, v186
		v_cvt_pk_bf16_f32 v30, v187, v188
		v_cvt_pk_bf16_f32 v31, v189, v190
		v_cvt_pk_bf16_f32 v32, v191, v192
		v_cvt_pk_bf16_f32 v33, v193, v194
		v_cvt_pk_bf16_f32 v34, v195, v196
		v_cvt_pk_bf16_f32 v35, v197, v10
		v_permlane32_swap_b32_e32 v208, v210
		v_permlane32_swap_b32_e32 v209, v211
		v_permlane32_swap_b32_e32 v160, v162
		v_permlane32_swap_b32_e32 v161, v163
		v_mfma_f32_32x32x16_bf16 v[224:239], a[96:99], v[208:211], v[224:239]
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v20, v22
		v_permlane32_swap_b32_e32 v21, v23
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_permlane32_swap_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v5, v7
		v_mfma_f32_32x32x16_bf16 v[48:63], a[112:115], v[208:211], v[48:63]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_permlane32_swap_b32_e32 v32, v34
		v_permlane32_swap_b32_e32 v33, v35
		v_add3_u32 v8, s4, v0, v1
		v_cndmask_b32_e64 v8, v13, v8, s[12:13]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[128:131], v[208:211], v[64:79]
		s_add_i32 s4, s0, 0xc0
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[208:211], v[80:95]
		s_add_i32 s18, s0, 0xe0
		v_mfma_f32_32x32x16_bf16 v[144:159], a[144:147], v[24:27], v[144:159]
		v_add3_u32 v9, s5, v0, v1
		v_mfma_f32_32x32x16_bf16 v[96:111], a[96:99], v[24:27], v[96:111]
		v_cndmask_b32_e64 v9, v13, v9, s[12:13]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[112:115], v[24:27], v[112:127]
		v_add3_u32 v10, s6, v0, v1
		v_mfma_f32_32x32x16_bf16 v[128:143], a[128:131], v[24:27], v[128:143]
		v_cndmask_b32_e64 v10, v13, v10, s[12:13]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[100:103], v[160:163], v[224:239]
		v_add3_u32 v11, s7, v0, v1
		v_mfma_f32_32x32x16_bf16 v[48:63], a[116:119], v[160:163], v[48:63]
		v_cndmask_b32_e64 v11, v13, v11, s[12:13]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[132:135], v[160:163], v[64:79]
		v_add3_u32 v12, s10, v0, v1
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_32x32x16_bf16 v[80:95], a[148:151], v[160:163], v[80:95]
		v_cndmask_b32_e64 v12, v13, v12, s[12:13]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[148:151], v[4:7], v[144:159]
		v_add3_u32 v14, s11, v0, v1
		v_mfma_f32_32x32x16_bf16 v[96:111], a[100:103], v[4:7], v[96:111]
		v_cndmask_b32_e64 v14, v13, v14, s[12:13]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[116:119], v[4:7], v[112:127]
		v_add3_u32 v15, s15, v0, v1
		v_mfma_f32_32x32x16_bf16 v[128:143], a[132:135], v[4:7], v[128:143]
		v_cndmask_b32_e64 v4, v13, v15, s[12:13]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[104:107], v[16:19], v[224:239]
		v_add3_u32 v5, s16, v0, v1
		v_mfma_f32_32x32x16_bf16 v[48:63], a[120:123], v[16:19], v[48:63]
		v_cndmask_b32_e64 v5, v13, v5, s[12:13]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[136:139], v[16:19], v[64:79]
		v_add3_u32 v6, s0, v0, v1
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], v[16:19], v[80:95]
		v_cndmask_b32_e64 v6, v13, v6, s[28:29]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[152:155], v[28:31], v[144:159]
		v_add3_u32 v7, s1, v0, v1
		v_mfma_f32_32x32x16_bf16 v[96:111], a[104:107], v[28:31], v[96:111]
		v_cndmask_b32_e64 v7, v13, v7, s[28:29]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[120:123], v[28:31], v[112:127]
		v_add3_u32 v15, s2, v0, v1
		v_mfma_f32_32x32x16_bf16 v[128:143], a[136:139], v[28:31], v[128:143]
		v_cndmask_b32_e64 v15, v13, v15, s[28:29]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[108:111], v[20:23], v[224:239]
		v_add3_u32 v16, s3, v0, v1
		v_mfma_f32_32x32x16_bf16 v[48:63], a[124:127], v[20:23], v[48:63]
		v_cndmask_b32_e64 v16, v13, v16, s[28:29]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[140:143], v[20:23], v[64:79]
		v_add3_u32 v17, s17, v0, v1
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], v[20:23], v[80:95]
		v_cndmask_b32_e64 v17, v13, v17, s[28:29]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[156:159], v[32:35], v[144:159]
		v_add3_u32 v18, s14, v0, v1
		v_mfma_f32_32x32x16_bf16 v[96:111], a[108:111], v[32:35], v[96:111]
		v_cndmask_b32_e64 v18, v13, v18, s[28:29]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[124:127], v[32:35], v[112:127]
		v_add3_u32 v19, s4, v0, v1
		v_mfma_f32_32x32x16_bf16 v[128:143], a[140:143], v[32:35], v[128:143]
		v_add3_u32 v0, s18, v0, v1
		v_rcp_f32_e32 v1, v3
		v_cndmask_b32_e64 v3, v13, v19, s[28:29]
		v_mul_f32_e32 v19, v224, v1
		v_mul_f32_e32 v20, v225, v1
		v_mul_f32_e32 v21, v226, v1
		v_mul_f32_e32 v22, v227, v1
		v_mul_f32_e32 v23, v228, v1
		v_mul_f32_e32 v24, v229, v1
		v_mul_f32_e32 v25, v230, v1
		v_mul_f32_e32 v26, v231, v1
		v_mul_f32_e32 v27, v232, v1
		v_mul_f32_e32 v28, v233, v1
		v_mul_f32_e32 v29, v234, v1
		v_mul_f32_e32 v30, v235, v1
		v_mul_f32_e32 v31, v236, v1
		v_mul_f32_e32 v32, v237, v1
		v_mul_f32_e32 v33, v238, v1
		v_mul_f32_e32 v34, v239, v1
		v_mul_f32_e32 v35, v48, v1
		v_mul_f32_e32 v36, v49, v1
		v_mul_f32_e32 v37, v50, v1
		v_mul_f32_e32 v38, v51, v1
		v_mul_f32_e32 v39, v52, v1
		v_mul_f32_e32 v40, v53, v1
		v_mul_f32_e32 v41, v54, v1
		v_mul_f32_e32 v42, v55, v1
		v_mul_f32_e32 v43, v56, v1
		v_mul_f32_e32 v44, v57, v1
		v_mul_f32_e32 v45, v58, v1
		v_mul_f32_e32 v46, v59, v1
		v_mul_f32_e32 v47, v60, v1
		v_mul_f32_e32 v48, v61, v1
		v_mul_f32_e32 v49, v62, v1
		v_mul_f32_e32 v50, v63, v1
		v_mul_f32_e32 v51, v64, v1
		v_mul_f32_e32 v52, v65, v1
		v_mul_f32_e32 v53, v66, v1
		v_mul_f32_e32 v54, v67, v1
		v_mul_f32_e32 v55, v68, v1
		v_mul_f32_e32 v56, v69, v1
		v_mul_f32_e32 v57, v70, v1
		v_mul_f32_e32 v58, v71, v1
		v_mul_f32_e32 v59, v72, v1
		v_mul_f32_e32 v60, v73, v1
		v_mul_f32_e32 v61, v74, v1
		v_mul_f32_e32 v62, v75, v1
		v_mul_f32_e32 v63, v76, v1
		v_mul_f32_e32 v64, v77, v1
		v_mul_f32_e32 v65, v78, v1
		v_mul_f32_e32 v66, v79, v1
		v_mul_f32_e32 v67, v80, v1
		v_mul_f32_e32 v68, v81, v1
		v_mul_f32_e32 v69, v82, v1
		v_mul_f32_e32 v70, v83, v1
		v_mul_f32_e32 v71, v84, v1
		v_mul_f32_e32 v72, v85, v1
		v_mul_f32_e32 v73, v86, v1
		v_mul_f32_e32 v74, v87, v1
		v_mul_f32_e32 v75, v88, v1
		v_mul_f32_e32 v76, v89, v1
		v_mul_f32_e32 v77, v90, v1
		v_mul_f32_e32 v78, v91, v1
		v_mul_f32_e32 v79, v92, v1
		v_mul_f32_e32 v80, v93, v1
		v_mul_f32_e32 v81, v94, v1
		v_mul_f32_e32 v1, v95, v1
		v_rcp_f32_e32 v2, v2
		v_cvt_pk_bf16_f32 v84, v19, v20
		v_mul_f32_e32 v19, v96, v2
		v_mul_f32_e32 v20, v97, v2
		v_mul_f32_e32 v82, v98, v2
		v_mul_f32_e32 v83, v99, v2
		v_mul_f32_e32 v88, v100, v2
		v_mul_f32_e32 v89, v101, v2
		v_mul_f32_e32 v90, v102, v2
		v_mul_f32_e32 v91, v103, v2
		v_mul_f32_e32 v92, v104, v2
		v_mul_f32_e32 v93, v105, v2
		v_mul_f32_e32 v94, v106, v2
		v_mul_f32_e32 v95, v107, v2
		v_mul_f32_e32 v96, v108, v2
		v_mul_f32_e32 v97, v109, v2
		v_mul_f32_e32 v98, v110, v2
		v_mul_f32_e32 v99, v111, v2
		v_mul_f32_e32 v100, v112, v2
		v_mul_f32_e32 v101, v113, v2
		v_mul_f32_e32 v102, v114, v2
		v_mul_f32_e32 v103, v115, v2
		v_mul_f32_e32 v104, v116, v2
		v_mul_f32_e32 v105, v117, v2
		v_mul_f32_e32 v106, v118, v2
		v_mul_f32_e32 v107, v119, v2
		v_mul_f32_e32 v108, v120, v2
		v_mul_f32_e32 v109, v121, v2
		v_mul_f32_e32 v110, v122, v2
		v_mul_f32_e32 v111, v123, v2
		v_mul_f32_e32 v112, v124, v2
		v_mul_f32_e32 v113, v125, v2
		v_mul_f32_e32 v114, v126, v2
		v_mul_f32_e32 v115, v127, v2
		v_mul_f32_e32 v116, v128, v2
		v_mul_f32_e32 v117, v129, v2
		v_mul_f32_e32 v118, v130, v2
		v_mul_f32_e32 v119, v131, v2
		v_mul_f32_e32 v120, v132, v2
		v_mul_f32_e32 v121, v133, v2
		v_mul_f32_e32 v122, v134, v2
		v_mul_f32_e32 v123, v135, v2
		v_mul_f32_e32 v124, v136, v2
		v_mul_f32_e32 v125, v137, v2
		v_mul_f32_e32 v126, v138, v2
		v_mul_f32_e32 v127, v139, v2
		v_mul_f32_e32 v128, v140, v2
		v_mul_f32_e32 v129, v141, v2
		v_mul_f32_e32 v130, v142, v2
		v_mul_f32_e32 v131, v143, v2
		v_mul_f32_e32 v132, v144, v2
		v_mul_f32_e32 v133, v145, v2
		v_mul_f32_e32 v134, v146, v2
		v_mul_f32_e32 v135, v147, v2
		v_mul_f32_e32 v136, v148, v2
		v_mul_f32_e32 v137, v149, v2
		v_mul_f32_e32 v138, v150, v2
		v_mul_f32_e32 v139, v151, v2
		v_mul_f32_e32 v140, v152, v2
		v_mul_f32_e32 v141, v153, v2
		v_mul_f32_e32 v142, v154, v2
		v_mul_f32_e32 v143, v155, v2
		v_mul_f32_e32 v144, v156, v2
		v_mul_f32_e32 v145, v157, v2
		v_mul_f32_e32 v146, v158, v2
		v_mul_f32_e32 v2, v159, v2
		v_cvt_pk_bf16_f32 v85, v21, v22
		v_cvt_pk_bf16_f32 v86, v23, v24
		v_cvt_pk_bf16_f32 v87, v25, v26
		v_cvt_pk_bf16_f32 v148, v27, v28
		v_cvt_pk_bf16_f32 v149, v29, v30
		v_cvt_pk_bf16_f32 v150, v31, v32
		v_cvt_pk_bf16_f32 v151, v33, v34
		v_cvt_pk_bf16_f32 v24, v35, v36
		v_cvt_pk_bf16_f32 v25, v37, v38
		v_cvt_pk_bf16_f32 v26, v39, v40
		v_cvt_pk_bf16_f32 v27, v41, v42
		v_cvt_pk_bf16_f32 v28, v43, v44
		v_cvt_pk_bf16_f32 v29, v45, v46
		v_cvt_pk_bf16_f32 v30, v47, v48
		v_cvt_pk_bf16_f32 v31, v49, v50
		v_cvt_pk_bf16_f32 v32, v51, v52
		v_cvt_pk_bf16_f32 v33, v53, v54
		v_cvt_pk_bf16_f32 v34, v55, v56
		v_cvt_pk_bf16_f32 v35, v57, v58
		v_cvt_pk_bf16_f32 v36, v59, v60
		v_cvt_pk_bf16_f32 v37, v61, v62
		v_cvt_pk_bf16_f32 v38, v63, v64
		v_cvt_pk_bf16_f32 v39, v65, v66
		v_cvt_pk_bf16_f32 v40, v67, v68
		v_cvt_pk_bf16_f32 v41, v69, v70
		v_cvt_pk_bf16_f32 v42, v71, v72
		v_cvt_pk_bf16_f32 v43, v73, v74
		v_cvt_pk_bf16_f32 v44, v75, v76
		v_cvt_pk_bf16_f32 v45, v77, v78
		v_cvt_pk_bf16_f32 v46, v79, v80
		v_cvt_pk_bf16_f32 v47, v81, v1
		v_cvt_pk_bf16_f32 v48, v19, v20
		v_cvt_pk_bf16_f32 v49, v82, v83
		v_cvt_pk_bf16_f32 v50, v88, v89
		v_cvt_pk_bf16_f32 v51, v90, v91
		v_cvt_pk_bf16_f32 v20, v92, v93
		v_cvt_pk_bf16_f32 v21, v94, v95
		v_cvt_pk_bf16_f32 v22, v96, v97
		v_cvt_pk_bf16_f32 v23, v98, v99
		v_cvt_pk_bf16_f32 v52, v100, v101
		v_cvt_pk_bf16_f32 v53, v102, v103
		v_cvt_pk_bf16_f32 v54, v104, v105
		v_cvt_pk_bf16_f32 v55, v106, v107
		v_cvt_pk_bf16_f32 v56, v108, v109
		v_cvt_pk_bf16_f32 v57, v110, v111
		v_cvt_pk_bf16_f32 v58, v112, v113
		v_cvt_pk_bf16_f32 v59, v114, v115
		v_cvt_pk_bf16_f32 v60, v116, v117
		v_cvt_pk_bf16_f32 v61, v118, v119
		v_cvt_pk_bf16_f32 v62, v120, v121
		v_cvt_pk_bf16_f32 v63, v122, v123
		v_cvt_pk_bf16_f32 v64, v124, v125
		v_cvt_pk_bf16_f32 v65, v126, v127
		v_cvt_pk_bf16_f32 v66, v128, v129
		v_cvt_pk_bf16_f32 v67, v130, v131
		v_cvt_pk_bf16_f32 v68, v132, v133
		v_cvt_pk_bf16_f32 v69, v134, v135
		v_cvt_pk_bf16_f32 v70, v136, v137
		v_cvt_pk_bf16_f32 v71, v138, v139
		v_cvt_pk_bf16_f32 v72, v140, v141
		v_cvt_pk_bf16_f32 v73, v142, v143
		v_cvt_pk_bf16_f32 v74, v144, v145
		v_cvt_pk_bf16_f32 v75, v146, v2
		v_permlane32_swap_b32_e32 v84, v86
		v_permlane32_swap_b32_e32 v85, v87
		v_permlane32_swap_b32_e32 v148, v150
		v_permlane32_swap_b32_e32 v149, v151
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
		v_permlane32_swap_b32_e32 v44, v46
		v_permlane32_swap_b32_e32 v45, v47
		v_permlane32_swap_b32_e32 v48, v50
		v_permlane32_swap_b32_e32 v49, v51
		v_permlane32_swap_b32_e32 v20, v22
		v_permlane32_swap_b32_e32 v21, v23
		v_permlane32_swap_b32_e32 v52, v54
		v_permlane32_swap_b32_e32 v53, v55
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
		s_mov_b32 s0, s8
		s_mov_b32 s1, s9
		s_mov_b32 s2, s34
		s_mov_b32 s3, s35
		buffer_store_dwordx4 v[84:87], v8, s[0:3], 0 offen
		buffer_store_dwordx4 v[148:151], v9, s[0:3], 0 offen
		buffer_store_dwordx4 v[24:27], v10, s[0:3], 0 offen
		buffer_store_dwordx4 v[28:31], v11, s[0:3], 0 offen
		buffer_store_dwordx4 v[32:35], v12, s[0:3], 0 offen
		buffer_store_dwordx4 v[36:39], v14, s[0:3], 0 offen
		buffer_store_dwordx4 v[40:43], v4, s[0:3], 0 offen
		buffer_store_dwordx4 v[44:47], v5, s[0:3], 0 offen
		buffer_store_dwordx4 v[48:51], v6, s[0:3], 0 offen
		buffer_store_dwordx4 v[20:23], v7, s[0:3], 0 offen
		buffer_store_dwordx4 v[52:55], v15, s[0:3], 0 offen
		buffer_store_dwordx4 v[56:59], v16, s[0:3], 0 offen
		buffer_store_dwordx4 v[60:63], v17, s[0:3], 0 offen
		buffer_store_dwordx4 v[64:67], v18, s[0:3], 0 offen
		buffer_store_dwordx4 v[68:71], v3, s[0:3], 0 offen
		v_cndmask_b32_e64 v0, v13, v0, s[28:29]
		buffer_store_dwordx4 v[72:75], v0, s[0:3], 0 offen
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
	.set .L_attn_fwd_async_prefetch.num_agpr, 160
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
    .vgpr_count:     416
    .agpr_count:     160
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 62
    wave.regalloc.agpr.dwords: 244
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
