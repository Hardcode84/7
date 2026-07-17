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
		s_cmp_lt_i32 s17, 0
		s_cselect_b32 s0, 1, 0
		s_xor_b32 s1, s17, -1
		s_add_i32 s1, s1, 1
		s_cmp_lg_u32 s0, 0
		s_cselect_b32 s0, s1, s17
		s_cselect_b32 s1, 1, 0
		s_waitcnt lgkmcnt(0)
		s_xor_b32 s26, s24, -1
		s_add_i32 s26, s26, 1
		s_cmp_lt_i32 s24, 0
		s_cselect_b32 s26, s26, s24
		v_mov_b32_e32 v1, s26
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		v_mov_b32_e32 v2, 0x4f7ffffe
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_xor_b32 s27, s26, -1
		v_readfirstlane_b32 s28, v1
		s_add_i32 s27, s27, 1
		s_mul_i32 s29, s27, s28
		s_mul_hi_u32 s29, s28, s29
		s_add_i32 s28, s28, s29
		s_mul_hi_u32 s28, s0, s28
		s_mul_i32 s29, s28, s26
		s_xor_b32 s29, s29, -1
		s_add_i32 s29, s29, 1
		s_add_i32 s0, s0, s29
		s_cmp_ge_u32 s0, s26
		s_cselect_b32 s29, 1, 0
		s_add_i32 s30, s28, 1
		s_cmp_lg_u32 s29, 0
		s_cselect_b32 s28, s30, s28
		s_cselect_b32 s29, 1, 0
		s_add_i32 s30, s0, s27
		s_cmp_lg_u32 s29, 0
		s_cselect_b32 s0, s30, s0
		s_cmp_ge_u32 s0, s26
		s_cselect_b32 s26, 1, 0
		s_add_i32 s29, s28, 1
		s_cmp_lg_u32 s26, 0
		s_cselect_b32 s26, s29, s28
		s_cselect_b32 s28, 1, 0
		s_xor_b32 s17, s17, s24
		s_xor_b32 s24, s26, -1
		s_add_i32 s24, s24, 1
		s_cmp_lt_i32 s17, 0
		s_cselect_b32 s17, s24, s26
		s_add_i32 s24, s0, s27
		s_cmp_lg_u32 s28, 0
		s_cselect_b32 s0, s24, s0
		s_xor_b32 s24, s0, -1
		s_add_i32 s24, s24, 1
		s_cmp_lg_u32 s1, 0
		s_cselect_b32 s0, s24, s0
		s_mul_i32 s1, s16, 0x100
		v_and_b32_e32 v1, 1, v0
		v_lshrrev_b32_e32 v2, 1, v0
		v_and_b32_e32 v3, 1, v2
		v_mad_u32_u24 v1, v3, 2, v1
		v_lshrrev_b32_e32 v3, 2, v0
		v_and_b32_e32 v4, 1, v3
		v_mad_u32_u24 v1, v4, 4, v1
		v_lshrrev_b32_e32 v4, 3, v0
		v_and_b32_e32 v5, 1, v4
		v_mov_b32_e32 v6, 8
		v_mul_lo_u32 v6, v6, v5
		v_lshrrev_b32_e32 v5, 4, v0
		v_and_b32_e32 v7, 1, v5
		v_mov_b32_e32 v8, 16
		v_mul_lo_u32 v8, v8, v7
		v_add3_u32 v1, v1, v6, v8
		v_lshrrev_b32_e32 v6, 6, v0
		v_and_b32_e32 v7, 1, v6
		v_mad_u32_u24 v1, v7, 32, v1
		v_lshrrev_b32_e32 v9, 7, v0
		v_and_b32_e32 v10, 1, v9
		v_mad_u32_u24 v1, v10, 64, v1
		v_add_u32_e32 v11, 0x80, v1
		v_and_b32_e32 v12, 15, v5
		v_add_u32_e32 v1, s1, v1
		v_add_u32_e32 v11, s1, v11
		v_add_u32_e32 v13, s1, v12
		v_lshrrev_b32_e32 v14, 5, v0
		v_cmp_lt_i32_e64 vcc, v1, s25
		s_mov_b64 s[26:27], vcc
		v_cmp_lt_i32_e64 vcc, v11, s25
		s_mov_b64 s[28:29], vcc
		v_cmp_lt_i32_e64 vcc, v13, s25
		s_mov_b64 s[30:31], vcc
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
		s_add_i32 s4, s4, s5
		s_mul_i32 s5, s0, s11
		s_lshl_b32 s5, s5, 1
		s_add_i32 s4, s4, s5
		v_mul_lo_u32 v1, s12, v9
		v_lshl_add_u32 v1, v1, 4, s4
		v_and_b32_e32 v11, 1, v6
		v_mul_lo_u32 v13, s12, v11
		v_lshl_add_u32 v1, v13, 3, v1
		v_and_b32_e32 v13, 1, v14
		v_mul_lo_u32 v15, s12, v13
		v_lshl_add_u32 v1, v15, 2, v1
		v_and_b32_e32 v5, 1, v5
		v_mul_lo_u32 v15, s12, v5
		v_lshl_add_u32 v1, v15, 1, v1
		v_and_b32_e32 v15, 1, v0
		v_lshlrev_b32_e32 v16, 4, v15
		v_and_b32_e32 v4, 1, v4
		v_lshlrev_b32_e32 v17, 7, v4
		v_add3_u32 v1, v1, v16, v17
		v_and_b32_e32 v3, 1, v3
		v_lshlrev_b32_e32 v18, 6, v3
		v_and_b32_e32 v2, 1, v2
		v_lshlrev_b32_e32 v19, 5, v2
		v_add3_u32 v1, v1, v18, v19
		v_mov_b32_e32 v20, 0x80000000
		v_cndmask_b32_e64 v1, v20, v1, s[30:31]
		s_mov_b32 s40, s2
		s_mov_b32 s41, s3
		s_mov_b32 s42, s34
		s_mov_b32 s43, s35
		buffer_load_dwordx4 v[24:27], v1, s[40:43], 0 offen
		v_add3_u32 v1, 16, v12, s1
		v_cmp_lt_i32_e64 vcc, v1, s25
		s_mov_b64 s[2:3], vcc
		v_lshlrev_b32_e32 v1, 3, v9
		v_lshlrev_b32_e32 v21, 2, v11
		v_add_u32_e32 v22, 16, v5
		v_lshlrev_b32_e32 v23, 1, v13
		v_xor_b32_e32 v22, v22, v23
		v_bitop3_b32 v22, v1, v21, v22 bitop3:0x96
		v_mul_lo_u32 v22, s12, v22
		v_lshl_add_u32 v22, v22, 1, s4
		v_add3_u32 v22, v22, v16, v17
		v_add3_u32 v22, v22, v18, v19
		v_cndmask_b32_e64 v22, v20, v22, s[2:3]
		buffer_load_dwordx4 v[28:31], v22, s[40:43], 0 offen
		v_add3_u32 v22, 32, v12, s1
		v_cmp_lt_i32_e64 vcc, v22, s25
		s_mov_b64 s[2:3], vcc
		v_add_u32_e32 v22, 32, v5
		v_xor_b32_e32 v22, v22, v23
		v_bitop3_b32 v22, v1, v21, v22 bitop3:0x96
		v_mul_lo_u32 v22, s12, v22
		v_lshl_add_u32 v22, v22, 1, s4
		v_add3_u32 v22, v22, v16, v17
		v_add3_u32 v22, v22, v18, v19
		v_cndmask_b32_e64 v22, v20, v22, s[2:3]
		buffer_load_dwordx4 v[32:35], v22, s[40:43], 0 offen
		v_add3_u32 v22, 48, v12, s1
		v_cmp_lt_i32_e64 vcc, v22, s25
		s_mov_b64 s[2:3], vcc
		v_add_u32_e32 v22, 48, v5
		v_xor_b32_e32 v22, v22, v23
		v_bitop3_b32 v22, v1, v21, v22 bitop3:0x96
		v_mul_lo_u32 v22, s12, v22
		v_lshl_add_u32 v22, v22, 1, s4
		v_add3_u32 v22, v22, v16, v17
		v_add3_u32 v22, v22, v18, v19
		v_cndmask_b32_e64 v22, v20, v22, s[2:3]
		buffer_load_dwordx4 v[36:39], v22, s[40:43], 0 offen
		v_add3_u32 v22, 64, v12, s1
		v_cmp_lt_i32_e64 vcc, v22, s25
		s_mov_b64 s[2:3], vcc
		v_add_u32_e32 v22, 64, v5
		v_xor_b32_e32 v22, v22, v23
		v_bitop3_b32 v22, v1, v21, v22 bitop3:0x96
		v_mul_lo_u32 v22, s12, v22
		v_lshl_add_u32 v22, v22, 1, s4
		v_add3_u32 v22, v22, v16, v17
		v_add3_u32 v22, v22, v18, v19
		v_cndmask_b32_e64 v22, v20, v22, s[2:3]
		buffer_load_dwordx4 v[40:43], v22, s[40:43], 0 offen
		v_add_u32_e32 v22, 0x50, v12
		v_add_u32_e32 v22, s1, v22
		v_cmp_lt_i32_e64 vcc, v22, s25
		s_mov_b64 s[2:3], vcc
		v_add_u32_e32 v22, 0x50, v5
		v_xor_b32_e32 v22, v22, v23
		v_bitop3_b32 v22, v1, v21, v22 bitop3:0x96
		v_mul_lo_u32 v22, s12, v22
		v_lshl_add_u32 v22, v22, 1, s4
		v_add3_u32 v22, v22, v16, v17
		v_add3_u32 v22, v22, v18, v19
		v_cndmask_b32_e64 v22, v20, v22, s[2:3]
		buffer_load_dwordx4 v[44:47], v22, s[40:43], 0 offen
		v_add_u32_e32 v22, 0x60, v12
		v_add_u32_e32 v22, s1, v22
		v_cmp_lt_i32_e64 vcc, v22, s25
		s_mov_b64 s[2:3], vcc
		v_add_u32_e32 v22, 0x60, v5
		v_xor_b32_e32 v22, v22, v23
		v_bitop3_b32 v22, v1, v21, v22 bitop3:0x96
		v_mul_lo_u32 v22, s12, v22
		v_lshl_add_u32 v22, v22, 1, s4
		v_add3_u32 v22, v22, v16, v17
		v_add3_u32 v22, v22, v18, v19
		v_cndmask_b32_e64 v22, v20, v22, s[2:3]
		buffer_load_dwordx4 v[48:51], v22, s[40:43], 0 offen
		v_add_u32_e32 v22, 0x70, v12
		v_add_u32_e32 v22, s1, v22
		v_cmp_lt_i32_e64 vcc, v22, s25
		s_mov_b64 s[2:3], vcc
		v_add_u32_e32 v22, 0x70, v5
		v_xor_b32_e32 v22, v22, v23
		v_bitop3_b32 v22, v1, v21, v22 bitop3:0x96
		v_mul_lo_u32 v22, s12, v22
		v_lshl_add_u32 v22, v22, 1, s4
		v_add3_u32 v22, v22, v16, v17
		v_add3_u32 v22, v22, v18, v19
		v_cndmask_b32_e64 v22, v20, v22, s[2:3]
		buffer_load_dwordx4 v[52:55], v22, s[40:43], 0 offen
		v_add_u32_e32 v22, 0x80, v12
		v_add_u32_e32 v22, s1, v22
		v_cmp_lt_i32_e64 vcc, v22, s25
		s_mov_b64 s[2:3], vcc
		v_add_u32_e32 v22, 0x80, v5
		v_xor_b32_e32 v22, v22, v23
		v_bitop3_b32 v22, v1, v21, v22 bitop3:0x96
		v_mul_lo_u32 v22, s12, v22
		v_lshl_add_u32 v22, v22, 1, s4
		v_add3_u32 v22, v22, v16, v17
		v_add3_u32 v22, v22, v18, v19
		v_cndmask_b32_e64 v22, v20, v22, s[2:3]
		buffer_load_dwordx4 v[56:59], v22, s[40:43], 0 offen
		v_add_u32_e32 v22, 0x90, v12
		v_add_u32_e32 v22, s1, v22
		v_cmp_lt_i32_e64 vcc, v22, s25
		s_mov_b64 s[2:3], vcc
		v_add_u32_e32 v22, 0x90, v5
		v_xor_b32_e32 v22, v22, v23
		v_bitop3_b32 v22, v1, v21, v22 bitop3:0x96
		v_mul_lo_u32 v22, s12, v22
		v_lshl_add_u32 v22, v22, 1, s4
		v_add3_u32 v22, v22, v16, v17
		v_add3_u32 v22, v22, v18, v19
		v_cndmask_b32_e64 v22, v20, v22, s[2:3]
		buffer_load_dwordx4 v[60:63], v22, s[40:43], 0 offen
		v_add_u32_e32 v22, 0xa0, v12
		v_add_u32_e32 v22, s1, v22
		v_cmp_lt_i32_e64 vcc, v22, s25
		s_mov_b64 s[2:3], vcc
		v_add_u32_e32 v22, 0xa0, v5
		v_xor_b32_e32 v22, v22, v23
		v_bitop3_b32 v22, v1, v21, v22 bitop3:0x96
		v_mul_lo_u32 v22, s12, v22
		v_lshl_add_u32 v22, v22, 1, s4
		v_add3_u32 v22, v22, v16, v17
		v_add3_u32 v22, v22, v18, v19
		v_cndmask_b32_e64 v22, v20, v22, s[2:3]
		buffer_load_dwordx4 v[64:67], v22, s[40:43], 0 offen
		v_add_u32_e32 v22, 0xb0, v12
		v_add_u32_e32 v22, s1, v22
		v_cmp_lt_i32_e64 vcc, v22, s25
		s_mov_b64 s[2:3], vcc
		v_add_u32_e32 v22, 0xb0, v5
		v_xor_b32_e32 v22, v22, v23
		v_bitop3_b32 v22, v1, v21, v22 bitop3:0x96
		v_mul_lo_u32 v22, s12, v22
		v_lshl_add_u32 v22, v22, 1, s4
		v_add3_u32 v22, v22, v16, v17
		v_add3_u32 v22, v22, v18, v19
		v_cndmask_b32_e64 v22, v20, v22, s[2:3]
		buffer_load_dwordx4 v[68:71], v22, s[40:43], 0 offen
		v_add_u32_e32 v22, 0xc0, v12
		v_add_u32_e32 v22, s1, v22
		v_cmp_lt_i32_e64 vcc, v22, s25
		s_mov_b64 s[2:3], vcc
		v_add_u32_e32 v22, 0xc0, v5
		v_xor_b32_e32 v22, v22, v23
		v_bitop3_b32 v22, v1, v21, v22 bitop3:0x96
		v_mul_lo_u32 v22, s12, v22
		v_lshl_add_u32 v22, v22, 1, s4
		v_add3_u32 v22, v22, v16, v17
		v_add3_u32 v22, v22, v18, v19
		v_cndmask_b32_e64 v22, v20, v22, s[2:3]
		buffer_load_dwordx4 v[72:75], v22, s[40:43], 0 offen
		v_add_u32_e32 v22, 0xd0, v12
		v_add_u32_e32 v22, s1, v22
		v_cmp_lt_i32_e64 vcc, v22, s25
		s_mov_b64 s[2:3], vcc
		v_add_u32_e32 v22, 0xd0, v5
		v_xor_b32_e32 v22, v22, v23
		v_bitop3_b32 v22, v1, v21, v22 bitop3:0x96
		v_mul_lo_u32 v22, s12, v22
		v_lshl_add_u32 v22, v22, 1, s4
		v_add3_u32 v22, v22, v16, v17
		v_add3_u32 v22, v22, v18, v19
		v_cndmask_b32_e64 v22, v20, v22, s[2:3]
		buffer_load_dwordx4 v[76:79], v22, s[40:43], 0 offen
		v_add_u32_e32 v22, 0xe0, v12
		v_add_u32_e32 v22, s1, v22
		v_cmp_lt_i32_e64 vcc, v22, s25
		s_mov_b64 s[2:3], vcc
		v_add_u32_e32 v22, 0xe0, v5
		v_xor_b32_e32 v22, v22, v23
		v_bitop3_b32 v22, v1, v21, v22 bitop3:0x96
		v_mul_lo_u32 v22, s12, v22
		v_lshl_add_u32 v22, v22, 1, s4
		v_add3_u32 v22, v22, v16, v17
		v_add3_u32 v22, v22, v18, v19
		v_cndmask_b32_e64 v22, v20, v22, s[2:3]
		buffer_load_dwordx4 v[80:83], v22, s[40:43], 0 offen
		v_add_u32_e32 v12, 0xf0, v12
		v_add_u32_e32 v12, s1, v12
		v_add_u32_e32 v22, 0xf0, v5
		v_xor_b32_e32 v22, v22, v23
		v_bitop3_b32 v22, v1, v21, v22 bitop3:0x96
		v_mul_lo_u32 v22, s12, v22
		v_lshl_add_u32 v22, v22, 1, s4
		v_add3_u32 v22, v22, v16, v17
		v_cmp_lt_i32_e64 vcc, v12, s25
		v_add3_u32 v12, v22, v18, v19
		v_and_b32_e32 v14, 1, v14
		v_cndmask_b32_e32 v12, v20, v12, vcc
		buffer_load_dwordx4 v[84:87], v12, s[40:43], 0 offen
		v_bitop3_b32 v12, v23, v0, v5 bitop3:0x96
		v_bitop3_b32 v1, v1, v21, v12 bitop3:0x96
		v_lshlrev_b32_e32 v1, 4, v1
		v_add_u32_e32 v1, 0x10000, v1
		s_waitcnt vmcnt(15)
		ds_write_b128 v1, v[24:27] offset:2480
		s_waitcnt vmcnt(14)
		ds_write_b128 v1, v[28:31] offset:6576
		s_waitcnt vmcnt(13)
		ds_write_b128 v1, v[32:35] offset:10672
		s_waitcnt vmcnt(12)
		ds_write_b128 v1, v[36:39] offset:14768
		s_waitcnt vmcnt(11)
		ds_write_b128 v1, v[40:43] offset:18864
		s_waitcnt vmcnt(10)
		ds_write_b128 v1, v[44:47] offset:22960
		s_waitcnt vmcnt(9)
		ds_write_b128 v1, v[48:51] offset:27056
		s_waitcnt vmcnt(8)
		ds_write_b128 v1, v[52:55] offset:31152
		v_lshlrev_b32_e32 v6, 13, v6
		v_add_u32_e32 v6, 0x10000, v6
		v_and_b32_e32 v12, 63, v0
		v_lshrrev_b32_e32 v21, 4, v12
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v21, 1, v21
		v_lshl_add_u32 v6, v21, 12, v6
		v_lshrrev_b32_e32 v22, 2, v12
		v_and_b32_e32 v22, 1, v22
		v_lshrrev_b32_e32 v23, 1, v12
		v_and_b32_e32 v23, 1, v23
		v_lshlrev_b32_e32 v23, 5, v23
		v_and_b32_e32 v24, 1, v12
		v_lshlrev_b32_e32 v24, 4, v24
		v_add_u32_e32 v25, v23, v24
		v_lshrrev_b32_e32 v26, 5, v12
		v_xor_b32_e32 v25, v25, v26
		v_lshlrev_b32_e32 v27, 6, v22
		v_add_u32_e32 v28, v27, v25
		v_lshrrev_b32_e32 v28, 7, v28
		v_lshrrev_b32_e32 v29, 3, v12
		v_and_b32_e32 v29, 1, v29
		v_add_u32_e32 v28, v28, v29
		v_and_b32_e32 v28, 1, v28
		v_lshlrev_b32_e32 v28, 3, v28
		v_lshrrev_b32_e32 v30, 6, v25
		v_add_u32_e32 v30, v30, v22
		v_and_b32_e32 v30, 1, v30
		v_lshlrev_b32_e32 v30, 2, v30
		v_lshrrev_b32_e32 v31, 5, v25
		v_and_b32_e32 v31, 1, v31
		v_lshlrev_b32_e32 v31, 1, v31
		v_lshl_add_u32 v32, v29, 7, v27
		v_add_u32_e32 v33, v32, v25
		v_lshrrev_b32_e32 v25, 4, v25
		v_and_b32_e32 v25, 1, v25
		v_bitop3_b32 v25, v31, v33, v25 bitop3:0x96
		v_bitop3_b32 v25, v28, v30, v25 bitop3:0x96
		v_lshl_add_u32 v28, v25, 4, v6
		ds_read_b128 a[0:3], v28 offset:2480
		v_add3_u32 v28, 2, v23, v24
		v_xor_b32_e32 v28, v28, v26
		v_add_u32_e32 v30, v27, v28
		v_lshrrev_b32_e32 v30, 7, v30
		v_add_u32_e32 v30, v30, v29
		v_and_b32_e32 v30, 1, v30
		v_lshlrev_b32_e32 v30, 3, v30
		v_lshrrev_b32_e32 v31, 6, v28
		v_add_u32_e32 v31, v31, v22
		v_and_b32_e32 v31, 1, v31
		v_lshlrev_b32_e32 v31, 2, v31
		v_lshrrev_b32_e32 v33, 5, v28
		v_and_b32_e32 v33, 1, v33
		v_lshlrev_b32_e32 v33, 1, v33
		v_add_u32_e32 v34, v32, v28
		v_lshrrev_b32_e32 v28, 4, v28
		v_and_b32_e32 v28, 1, v28
		v_bitop3_b32 v28, v33, v34, v28 bitop3:0x96
		v_bitop3_b32 v28, v30, v31, v28 bitop3:0x96
		v_lshl_add_u32 v30, v28, 4, v6
		ds_read_b128 a[4:7], v30 offset:2480
		v_add3_u32 v30, 4, v23, v24
		v_xor_b32_e32 v30, v30, v26
		v_add_u32_e32 v31, v27, v30
		v_lshrrev_b32_e32 v31, 7, v31
		v_add_u32_e32 v31, v31, v29
		v_and_b32_e32 v31, 1, v31
		v_lshlrev_b32_e32 v31, 3, v31
		v_lshrrev_b32_e32 v33, 6, v30
		v_add_u32_e32 v33, v33, v22
		v_and_b32_e32 v33, 1, v33
		v_lshlrev_b32_e32 v33, 2, v33
		v_lshrrev_b32_e32 v34, 5, v30
		v_and_b32_e32 v34, 1, v34
		v_lshlrev_b32_e32 v34, 1, v34
		v_add_u32_e32 v35, v32, v30
		v_lshrrev_b32_e32 v30, 4, v30
		v_and_b32_e32 v30, 1, v30
		v_bitop3_b32 v30, v34, v35, v30 bitop3:0x96
		v_bitop3_b32 v30, v31, v33, v30 bitop3:0x96
		v_lshl_add_u32 v31, v30, 4, v6
		ds_read_b128 a[8:11], v31 offset:2480
		v_add3_u32 v31, 6, v23, v24
		v_xor_b32_e32 v31, v31, v26
		v_add_u32_e32 v33, v27, v31
		v_lshrrev_b32_e32 v33, 7, v33
		v_add_u32_e32 v33, v33, v29
		v_and_b32_e32 v33, 1, v33
		v_lshlrev_b32_e32 v33, 3, v33
		v_lshrrev_b32_e32 v34, 6, v31
		v_add_u32_e32 v34, v34, v22
		v_and_b32_e32 v34, 1, v34
		v_lshlrev_b32_e32 v34, 2, v34
		v_lshrrev_b32_e32 v35, 5, v31
		v_and_b32_e32 v35, 1, v35
		v_lshlrev_b32_e32 v35, 1, v35
		v_add_u32_e32 v36, v32, v31
		v_lshrrev_b32_e32 v31, 4, v31
		v_and_b32_e32 v31, 1, v31
		v_bitop3_b32 v31, v35, v36, v31 bitop3:0x96
		v_bitop3_b32 v31, v33, v34, v31 bitop3:0x96
		v_lshl_add_u32 v33, v31, 4, v6
		ds_read_b128 a[12:15], v33 offset:2480
		v_add3_u32 v33, 8, v23, v24
		v_xor_b32_e32 v33, v33, v26
		v_add_u32_e32 v34, v27, v33
		v_lshrrev_b32_e32 v34, 7, v34
		v_add_u32_e32 v34, v34, v29
		v_and_b32_e32 v34, 1, v34
		v_lshlrev_b32_e32 v34, 3, v34
		v_lshrrev_b32_e32 v35, 6, v33
		v_add_u32_e32 v35, v35, v22
		v_and_b32_e32 v35, 1, v35
		v_lshlrev_b32_e32 v35, 2, v35
		v_lshrrev_b32_e32 v36, 5, v33
		v_and_b32_e32 v36, 1, v36
		v_lshlrev_b32_e32 v36, 1, v36
		v_add_u32_e32 v37, v32, v33
		v_lshrrev_b32_e32 v33, 4, v33
		v_and_b32_e32 v33, 1, v33
		v_bitop3_b32 v33, v36, v37, v33 bitop3:0x96
		v_bitop3_b32 v33, v34, v35, v33 bitop3:0x96
		v_lshl_add_u32 v34, v33, 4, v6
		ds_read_b128 a[16:19], v34 offset:2480
		v_add3_u32 v34, 10, v23, v24
		v_xor_b32_e32 v34, v34, v26
		v_add_u32_e32 v35, v27, v34
		v_lshrrev_b32_e32 v35, 7, v35
		v_add_u32_e32 v35, v35, v29
		v_and_b32_e32 v35, 1, v35
		v_lshlrev_b32_e32 v35, 3, v35
		v_lshrrev_b32_e32 v36, 6, v34
		v_add_u32_e32 v36, v36, v22
		v_and_b32_e32 v36, 1, v36
		v_lshlrev_b32_e32 v36, 2, v36
		v_lshrrev_b32_e32 v37, 5, v34
		v_and_b32_e32 v37, 1, v37
		v_lshlrev_b32_e32 v37, 1, v37
		v_add_u32_e32 v38, v32, v34
		v_lshrrev_b32_e32 v34, 4, v34
		v_and_b32_e32 v34, 1, v34
		v_bitop3_b32 v34, v37, v38, v34 bitop3:0x96
		v_bitop3_b32 v34, v35, v36, v34 bitop3:0x96
		v_lshl_add_u32 v35, v34, 4, v6
		ds_read_b128 a[20:23], v35 offset:2480
		v_add3_u32 v35, 12, v23, v24
		v_xor_b32_e32 v35, v35, v26
		v_add_u32_e32 v36, v27, v35
		v_lshrrev_b32_e32 v36, 7, v36
		v_add_u32_e32 v36, v36, v29
		v_and_b32_e32 v36, 1, v36
		v_lshlrev_b32_e32 v36, 3, v36
		v_lshrrev_b32_e32 v37, 6, v35
		v_add_u32_e32 v37, v37, v22
		v_and_b32_e32 v37, 1, v37
		v_lshlrev_b32_e32 v37, 2, v37
		v_lshrrev_b32_e32 v38, 5, v35
		v_and_b32_e32 v38, 1, v38
		v_lshlrev_b32_e32 v38, 1, v38
		v_add_u32_e32 v39, v32, v35
		v_lshrrev_b32_e32 v35, 4, v35
		v_and_b32_e32 v35, 1, v35
		v_bitop3_b32 v35, v38, v39, v35 bitop3:0x96
		v_bitop3_b32 v35, v36, v37, v35 bitop3:0x96
		v_lshl_add_u32 v36, v35, 4, v6
		ds_read_b128 a[24:27], v36 offset:2480
		v_add3_u32 v23, 14, v23, v24
		v_xor_b32_e32 v23, v23, v26
		v_add_u32_e32 v24, v27, v23
		v_lshrrev_b32_e32 v24, 7, v24
		v_add_u32_e32 v24, v24, v29
		v_and_b32_e32 v24, 1, v24
		v_lshlrev_b32_e32 v24, 3, v24
		v_lshrrev_b32_e32 v27, 6, v23
		v_add_u32_e32 v22, v27, v22
		v_and_b32_e32 v22, 1, v22
		v_lshlrev_b32_e32 v22, 2, v22
		v_lshrrev_b32_e32 v27, 5, v23
		v_and_b32_e32 v27, 1, v27
		v_lshlrev_b32_e32 v27, 1, v27
		v_add_u32_e32 v29, v32, v23
		v_lshrrev_b32_e32 v23, 4, v23
		v_and_b32_e32 v23, 1, v23
		v_bitop3_b32 v23, v27, v29, v23 bitop3:0x96
		v_bitop3_b32 v22, v24, v22, v23 bitop3:0x96
		v_lshl_add_u32 v6, v22, 4, v6
		ds_read_b128 a[28:31], v6 offset:2480
		v_lshlrev_b32_e32 v6, 5, v9
		v_lshl_add_u32 v21, v21, 3, 64
		v_lshlrev_b32_e32 v23, 4, v11
		v_bitop3_b32 v6, v6, v21, v23 bitop3:0x96
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(7)
		ds_write_b128 v1, v[56:59] offset:2480
		s_waitcnt vmcnt(6)
		ds_write_b128 v1, v[60:63] offset:6576
		s_waitcnt vmcnt(5)
		ds_write_b128 v1, v[64:67] offset:10672
		s_waitcnt vmcnt(4)
		ds_write_b128 v1, v[68:71] offset:14768
		s_waitcnt vmcnt(3)
		ds_write_b128 v1, v[72:75] offset:18864
		s_waitcnt vmcnt(2)
		ds_write_b128 v1, v[76:79] offset:22960
		s_waitcnt vmcnt(1)
		ds_write_b128 v1, v[80:83] offset:27056
		s_waitcnt vmcnt(0)
		ds_write_b128 v1, v[84:87] offset:31152
		v_lshrrev_b32_e32 v1, 6, v6
		v_and_b32_e32 v1, 1, v1
		v_lshrrev_b32_e32 v21, 5, v6
		v_and_b32_e32 v21, 1, v21
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshlrev_b32_e32 v21, 14, v21
		v_lshl_add_u32 v1, v1, 15, v21
		v_lshrrev_b32_e32 v21, 4, v6
		v_and_b32_e32 v21, 1, v21
		v_lshl_add_u32 v1, v21, 13, v1
		v_lshrrev_b32_e32 v6, 3, v6
		v_and_b32_e32 v6, 1, v6
		v_lshl_add_u32 v1, v6, 12, v1
		v_lshl_add_u32 v6, v25, 4, v1
		ds_read_b128 a[32:35], v6 offset:35248
		v_lshl_add_u32 v6, v28, 4, v1
		ds_read_b128 a[36:39], v6 offset:35248
		v_lshl_add_u32 v6, v30, 4, v1
		ds_read_b128 a[40:43], v6 offset:35248
		v_lshl_add_u32 v6, v31, 4, v1
		ds_read_b128 a[44:47], v6 offset:35248
		v_lshl_add_u32 v6, v33, 4, v1
		ds_read_b128 a[48:51], v6 offset:35248
		v_lshl_add_u32 v6, v34, 4, v1
		ds_read_b128 a[52:55], v6 offset:35248
		v_lshl_add_u32 v6, v35, 4, v1
		ds_read_b128 a[56:59], v6 offset:35248
		v_lshl_add_u32 v1, v22, 4, v1
		ds_read_b128 a[60:63], v1 offset:35248
		v_mov_b32_e32 v1, 32
		v_mul_lo_u32 v1, v1, v14
		v_add3_u32 v1, v8, v1, v7
		v_mad_u32_u24 v1, v10, 2, v1
		v_add_u32_e32 v6, 4, v1
		v_add_u32_e32 v7, 8, v1
		v_add_u32_e32 v8, 12, v1
		s_add_i32 s1, s25, 63
		s_mov_b32 s2, 63
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s2, s2, 0
		s_add_i32 s1, s1, s2
		s_ashr_i32 s1, s1, 6
		s_add_i32 s1, s1, -1
		s_cmp_gt_i32 s1, 0
		s_cselect_b32 s1, s1, 0
		v_cmp_lt_i32_e64 vcc, v1, s25
		s_mov_b64 s[2:3], vcc
		v_cmp_lt_i32_e64 vcc, v6, s25
		s_mov_b64 s[4:5], vcc
		v_cmp_lt_i32_e64 vcc, v7, s25
		s_mov_b64 s[6:7], vcc
		v_cmp_lt_i32_e64 vcc, v8, s25
		v_readfirstlane_b32 s10, v0
		v_mul_lo_u32 v0, s15, v9
		v_mul_lo_u32 v10, s15, v11
		v_lshlrev_b32_e32 v10, 1, v10
		v_lshl_add_u32 v0, v0, 2, v10
		v_mul_lo_u32 v10, s15, v13
		v_lshl_add_u32 v0, v10, 6, v0
		v_mul_lo_u32 v10, s15, v5
		v_lshl_add_u32 v0, v10, 5, v0
		v_add3_u32 v0, v0, v16, v17
		v_add3_u32 v0, v0, v18, v19
		s_mul_i32 s11, s17, s13
		s_lshl_b32 s11, s11, 1
		s_mul_i32 s12, s0, s14
		s_lshl_b32 s12, s12, 1
		s_add_i32 s13, s11, s12
		v_add_u32_e32 v10, s13, v0
		s_lshr_b32 s10, s10, 6
		s_mul_i32 s13, 0x410, s10
		s_mov_b32 m0, s13
		v_cndmask_b32_e64 v10, v20, v10, s[2:3]
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		s_lshl_b32 s14, s15, 3
		s_add_i32 s14, s14, s11
		s_add_i32 s14, s14, s12
		v_add_u32_e32 v10, s14, v0
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v10, v20, v10, s[4:5]
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		s_lshl_b32 s14, s15, 4
		s_add_i32 s14, s14, s11
		s_add_i32 s14, s14, s12
		v_add_u32_e32 v10, s14, v0
		s_add_i32 m0, s13, 0x2080
		v_cndmask_b32_e64 v10, v20, v10, s[6:7]
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		s_mul_i32 s14, 24, s15
		s_add_i32 s14, s14, s11
		s_add_i32 s14, s14, s12
		v_add_u32_e32 v10, s14, v0
		v_cndmask_b32_e32 v10, v20, v10, vcc
		s_add_i32 m0, s13, 0x30c0
		v_mov_b32_e32 v21, 0
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		v_mul_lo_u32 v10, s20, v9
		v_mul_lo_u32 v22, s20, v11
		v_lshlrev_b32_e32 v22, 1, v22
		v_lshl_add_u32 v10, v10, 2, v22
		v_mul_lo_u32 v22, s20, v13
		v_lshl_add_u32 v10, v22, 6, v10
		v_mul_lo_u32 v22, s20, v5
		v_lshl_add_u32 v10, v22, 5, v10
		v_add3_u32 v10, v10, v16, v17
		v_add3_u32 v10, v10, v18, v19
		s_mul_i32 s14, s17, s18
		s_lshl_b32 s14, s14, 1
		s_mul_i32 s18, s0, s19
		s_lshl_b32 s18, s18, 1
		s_add_i32 s19, s14, s18
		v_add_u32_e32 v16, s19, v10
		s_mul_i32 s10, 0x440, s10
		s_add_i32 m0, s10, 0x81f0
		v_cndmask_b32_e64 v16, v20, v16, s[2:3]
		buffer_load_dwordx4 v16, s[36:39], 0 offen lds
		s_lshl_b32 s2, s20, 3
		s_add_i32 s2, s2, s14
		s_add_i32 s2, s2, s18
		v_add_u32_e32 v16, s2, v10
		s_add_i32 m0, s10, 0x92f0
		v_cndmask_b32_e64 v16, v20, v16, s[4:5]
		buffer_load_dwordx4 v16, s[36:39], 0 offen lds
		s_lshl_b32 s2, s20, 4
		s_add_i32 s2, s2, s14
		s_add_i32 s2, s2, s18
		v_add_u32_e32 v16, s2, v10
		s_add_i32 m0, s10, 0xa3f0
		v_cndmask_b32_e64 v16, v20, v16, s[6:7]
		buffer_load_dwordx4 v16, s[36:39], 0 offen lds
		s_mul_i32 s2, 24, s20
		s_add_i32 s2, s2, s14
		s_add_i32 s2, s2, s18
		v_add_u32_e32 v16, s2, v10
		v_cndmask_b32_e32 v16, v20, v16, vcc
		s_add_i32 m0, s10, 0xb4f0
		v_mov_b32_e32 v17, 4
		v_mul_lo_u32 v17, v17, v14
		buffer_load_dwordx4 v16, s[36:39], 0 offen lds
		s_mul_i32 s2, s1, 64
		v_mbcnt_lo_u32_b32 v14, -1, 0
		v_mbcnt_hi_u32_b32 v14, -1, v14
		v_and_b32_e32 v16, 1, v14
		v_lshrrev_b32_e32 v18, 4, v14
		v_and_b32_e32 v18, 1, v18
		v_lshlrev_b32_e32 v18, 4, v18
		v_lshrrev_b32_e32 v19, 3, v14
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 3, v19
		v_add3_u32 v22, v16, v18, v19
		v_lshrrev_b32_e32 v23, 2, v14
		v_and_b32_e32 v23, 1, v23
		v_lshlrev_b32_e32 v23, 2, v23
		v_lshrrev_b32_e32 v24, 1, v14
		v_and_b32_e32 v24, 1, v24
		v_lshlrev_b32_e32 v24, 1, v24
		v_add3_u32 v22, v22, v23, v24
		v_add_u32_e32 v16, 32, v16
		v_bitop3_b32 v16, v23, v16, v24 bitop3:0x96
		v_bitop3_b32 v16, v18, v19, v16 bitop3:0x96
		v_mov_b32_e32 v18, 0x3e0293ee
		v_mov_b32_e32 v19, 0x3e0293ee
		s_mov_b32 s3, 0xff800000
		v_mov_b32_e32 v23, s3
		s_mov_b32 s4, 0
		v_lshlrev_b32_e32 v24, 4, v26
		v_and_b32_e32 v25, 31, v12
		v_lshrrev_b32_e32 v27, 4, v25
		v_lshlrev_b32_e32 v28, 8, v27
		v_lshrrev_b32_e32 v29, 3, v25
		v_and_b32_e32 v29, 1, v29
		v_mov_b32_e32 v30, 0x2080
		v_mul_lo_u32 v30, v30, v29
		v_lshrrev_b32_e32 v29, 2, v25
		v_and_b32_e32 v29, 1, v29
		v_mov_b32_e32 v31, 0x1040
		v_mul_lo_u32 v31, v31, v29
		v_lshrrev_b32_e32 v29, 1, v25
		v_and_b32_e32 v29, 1, v29
		v_mov_b32_e32 v32, 0x820
		v_mul_lo_u32 v32, v32, v29
		v_and_b32_e32 v25, 1, v25
		v_mov_b32_e32 v29, 0x410
		v_mul_lo_u32 v29, v29, v25
		v_mov_b32_e32 v25, 0x2200
		v_mul_lo_u32 v25, v25, v26
		v_lshlrev_b32_e32 v33, 5, v27
		v_and_b32_e32 v12, 15, v12
		v_lshrrev_b32_e32 v34, 2, v12
		v_mov_b32_e32 v35, 0x440
		v_mul_lo_u32 v35, v35, v34
		v_and_b32_e32 v12, 3, v12
		v_lshlrev_b32_e32 v34, 3, v12
		v_mov_b32_e32 v36, 1
		s_lshl_b32 s5, s15, 7
		s_add_i32 s5, s5, s11
		s_add_i32 s5, s5, s12
		s_mul_i32 s6, 0x88, s15
		s_add_i32 s6, s6, s11
		s_add_i32 s6, s6, s12
		s_mul_i32 s7, 0x90, s15
		s_add_i32 s7, s7, s11
		s_add_i32 s7, s7, s12
		s_mul_i32 s19, 0x98, s15
		s_add_i32 s11, s19, s11
		s_add_i32 s11, s11, s12
		s_lshl_b32 s12, s20, 7
		s_add_i32 s12, s12, s14
		s_add_i32 s12, s12, s18
		s_mul_i32 s19, 0x88, s20
		s_add_i32 s19, s19, s14
		s_add_i32 s19, s19, s18
		s_mul_i32 s24, 0x90, s20
		s_add_i32 s24, s24, s14
		s_add_i32 s24, s24, s18
		s_mul_i32 s30, 0x98, s20
		s_add_i32 s14, s30, s14
		s_add_i32 s14, s14, s18
		v_lshlrev_b32_e32 v22, 2, v22
		v_lshlrev_b32_e32 v16, 2, v16
		s_cmp_lt_i32 0, s2
		v_accvgpr_write_b32 a64, 1.0
		v_accvgpr_write_b32 a65, 1.0
		v_mov_b64_e32 v[48:49], 0
		v_mov_b64_e32 v[50:51], 0
		v_mov_b64_e32 v[52:53], 0
		v_mov_b64_e32 v[54:55], 0
		v_mov_b64_e32 v[56:57], 0
		v_mov_b64_e32 v[58:59], 0
		v_mov_b64_e32 v[60:61], 0
		v_mov_b64_e32 v[62:63], 0
		v_mov_b32_e32 v37, s3
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
		s_add_i32 s3, s4, 64
		v_add_u32_e32 v38, s3, v1
		s_lshr_b32 s18, s4, 6
		s_and_b32 s30, s18, 1
		s_mul_i32 s31, 0x4100, s30
		v_add3_u32 v39, s31, v24, v28
		v_add3_u32 v39, v39, v30, v31
		v_add3_u32 v39, v39, v32, v29
		ds_read_b128 v[40:43], v39
		ds_read_b128 v[44:47], v39 offset:32
		ds_read_b128 a[68:71], v39 offset:64
		ds_read_b128 a[72:75], v39 offset:96
		ds_read_b128 a[76:79], v39 offset:128
		ds_read_b128 a[80:83], v39 offset:160
		ds_read_b128 a[84:87], v39 offset:192
		ds_read_b128 a[88:91], v39 offset:224
		ds_read_b128 v[176:179], v39 offset:512
		ds_read_b128 v[180:183], v39 offset:544
		ds_read_b128 a[92:95], v39 offset:576
		ds_read_b128 a[96:99], v39 offset:608
		ds_read_b128 a[100:103], v39 offset:640
		ds_read_b128 a[104:107], v39 offset:672
		ds_read_b128 a[108:111], v39 offset:704
		ds_read_b128 a[112:115], v39 offset:736
		s_mul_i32 s30, 0x4400, s30
		v_add3_u32 v39, s30, v25, v33
		v_add3_u32 v39, v39, v35, v34
		ds_read_b64_tr_b16 a[116:117], v39 offset:33264
		ds_read_b64_tr_b16 a[118:119], v39 offset:37616
		ds_read_b64_tr_b16 a[120:121], v39 offset:33520
		ds_read_b64_tr_b16 a[122:123], v39 offset:37872
		ds_read_b64_tr_b16 a[124:125], v39 offset:33776
		ds_read_b64_tr_b16 a[126:127], v39 offset:38128
		ds_read_b64_tr_b16 a[128:129], v39 offset:34032
		ds_read_b64_tr_b16 a[130:131], v39 offset:38384
		ds_read_b64_tr_b16 a[132:133], v39 offset:33328
		ds_read_b64_tr_b16 a[134:135], v39 offset:37680
		ds_read_b64_tr_b16 a[136:137], v39 offset:33584
		ds_read_b64_tr_b16 a[138:139], v39 offset:37936
		ds_read_b64_tr_b16 a[140:141], v39 offset:33840
		ds_read_b64_tr_b16 a[142:143], v39 offset:38192
		ds_read_b64_tr_b16 a[144:145], v39 offset:34096
		ds_read_b64_tr_b16 a[146:147], v39 offset:38448
		ds_read_b64_tr_b16 a[148:149], v39 offset:33392
		ds_read_b64_tr_b16 a[150:151], v39 offset:37744
		ds_read_b64_tr_b16 a[152:153], v39 offset:33648
		ds_read_b64_tr_b16 a[154:155], v39 offset:38000
		ds_read_b64_tr_b16 a[156:157], v39 offset:33904
		ds_read_b64_tr_b16 a[158:159], v39 offset:38256
		ds_read_b64_tr_b16 a[160:161], v39 offset:34160
		ds_read_b64_tr_b16 a[162:163], v39 offset:38512
		ds_read_b64_tr_b16 a[164:165], v39 offset:33456
		ds_read_b64_tr_b16 a[166:167], v39 offset:37808
		ds_read_b64_tr_b16 a[168:169], v39 offset:33712
		ds_read_b64_tr_b16 a[170:171], v39 offset:38064
		ds_read_b64_tr_b16 a[172:173], v39 offset:33968
		ds_read_b64_tr_b16 a[174:175], v39 offset:38320
		ds_read_b64_tr_b16 a[176:177], v39 offset:34224
		ds_read_b64_tr_b16 a[178:179], v39 offset:38576
		v_cmp_lt_i32_e64 vcc, v38, s25
		v_add_u32_e32 v38, s3, v6
		v_add_u32_e32 v39, s3, v7
		v_cndmask_b32_e32 v184, v21, v36, vcc
		v_add_u32_e32 v185, s4, v14
		v_add_u32_e32 v184, v184, v185
		v_add_u32_e32 v186, 1, v185
		v_cmp_eq_u32_e64 vcc, v184, v186
		s_mov_b64 s[30:31], vcc
		v_cmp_lt_i32_e64 vcc, v38, s25
		v_add_u32_e32 v38, s3, v8
		s_add_i32 s18, s18, 1
		s_and_b32 s18, s18, 1
		s_mul_i32 s40, s15, s4
		s_lshl_b32 s40, s40, 1
		s_add_i32 s41, s5, s40
		v_add_u32_e32 v184, s41, v0
		s_mul_i32 s41, 0x4100, s18
		s_add_i32 s41, s13, s41
		v_cndmask_b32_e64 v184, v20, v184, s[30:31]
		v_add_u32_e32 v187, s40, v0
		v_add_u32_e32 v188, s6, v187
		v_add_u32_e32 v189, s7, v187
		v_add_u32_e32 v187, s11, v187
		s_mul_i32 s4, s20, s4
		s_mul_i32 s18, 0x4400, s18
		v_cndmask_b32_e32 v190, v21, v36, vcc
		v_add_u32_e32 v190, v190, v185
		v_cmp_eq_u32_e64 vcc, v190, v186
		s_mov_b64 s[42:43], vcc
		v_cmp_lt_i32_e64 vcc, v39, s25
		v_cndmask_b32_e64 v39, v20, v188, s[42:43]
		s_mov_b32 m0, s41
		v_cndmask_b32_e32 v188, v21, v36, vcc
		buffer_load_dwordx4 v184, s[32:35], 0 offen lds
		v_add_u32_e32 v184, v188, v185
		v_cmp_eq_u32_e64 vcc, v184, v186
		s_mov_b64 s[44:45], vcc
		v_cmp_lt_i32_e64 vcc, v38, s25
		v_cndmask_b32_e64 v38, v20, v189, s[44:45]
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e32 v184, v21, v36, vcc
		buffer_load_dwordx4 v39, s[32:35], 0 offen lds
		v_add_u32_e32 v39, v184, v185
		v_cmp_eq_u32_e64 vcc, v39, v186
		s_add_i32 m0, s41, 0x2080
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[192:207], v[40:43], a[0:3], 0
		buffer_load_dwordx4 v38, s[32:35], 0 offen lds
		v_cndmask_b32_e32 v38, v20, v187, vcc
		s_add_i32 m0, s41, 0x30c0
		s_lshl_b32 s4, s4, 1
		s_add_i32 s40, s12, s4
		v_add_u32_e32 v39, s40, v10
		s_add_i32 s18, s10, s18
		v_cndmask_b32_e64 v39, v20, v39, s[30:31]
		v_add_u32_e32 v184, s4, v10
		v_add_u32_e32 v185, s19, v184
		v_cndmask_b32_e64 v185, v20, v185, s[42:43]
		v_add_u32_e32 v186, s24, v184
		v_cndmask_b32_e64 v186, v20, v186, s[44:45]
		v_add_u32_e32 v184, s14, v184
		v_cndmask_b32_e32 v184, v20, v184, vcc
		buffer_load_dwordx4 v38, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[208:223], v[176:179], a[0:3], 0
		s_add_i32 m0, s18, 0x81f0
		v_mfma_f32_32x32x16_bf16 v[224:239], v[176:179], a[32:35], 0
		buffer_load_dwordx4 v39, s[36:39], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[240:255], v[40:43], a[32:35], 0
		s_add_i32 m0, s18, 0x92f0
		v_mfma_f32_32x32x16_bf16 v[192:207], v[44:47], a[4:7], v[192:207]
		buffer_load_dwordx4 v185, s[36:39], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[208:223], v[180:183], a[4:7], v[208:223]
		s_add_i32 m0, s18, 0xa3f0
		v_mfma_f32_32x32x16_bf16 v[224:239], v[180:183], a[36:39], v[224:239]
		buffer_load_dwordx4 v186, s[36:39], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[240:255], v[44:47], a[36:39], v[240:255]
		s_add_i32 m0, s18, 0xb4f0
		s_cmp_lt_i32 s3, s2
		v_mfma_f32_32x32x16_bf16 v[192:207], a[68:71], a[8:11], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[92:95], a[8:11], v[208:223]
		buffer_load_dwordx4 v184, s[36:39], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], a[92:95], a[40:43], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[68:71], a[40:43], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[72:75], a[12:15], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[96:99], a[12:15], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[96:99], a[44:47], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[72:75], a[44:47], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[76:79], a[16:19], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[100:103], a[16:19], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[100:103], a[48:51], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[76:79], a[48:51], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[80:83], a[20:23], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[104:107], a[20:23], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[104:107], a[52:55], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[80:83], a[52:55], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[84:87], a[24:27], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[108:111], a[24:27], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[108:111], a[56:59], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[84:87], a[56:59], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[88:91], a[28:31], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[112:115], a[28:31], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[112:115], a[60:63], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[88:91], a[60:63], v[240:255]
		s_nop 8
		v_max_f32_e32 v38, v192, v193
		v_max_f32_e32 v39, v194, v195
		v_max_f32_e32 v40, v196, v197
		v_max_f32_e32 v41, v198, v199
		v_max_f32_e32 v42, v200, v201
		v_max_f32_e32 v43, v202, v203
		v_max_f32_e32 v44, v204, v205
		v_max_f32_e32 v45, v206, v207
		v_max_f32_e32 v46, v208, v209
		v_max_f32_e32 v47, v210, v211
		v_max_f32_e32 v176, v212, v213
		v_max_f32_e32 v177, v214, v215
		v_max_f32_e32 v178, v216, v217
		v_max_f32_e32 v179, v218, v219
		v_max_f32_e32 v180, v220, v221
		v_max_f32_e32 v181, v222, v223
		v_max_f32_e32 v38, v38, v39
		v_max_f32_e32 v39, v40, v41
		v_max_f32_e32 v40, v42, v43
		v_max_f32_e32 v41, v44, v45
		v_max_f32_e32 v42, v46, v47
		v_max_f32_e32 v43, v176, v177
		v_max_f32_e32 v44, v178, v179
		v_max_f32_e32 v45, v180, v181
		v_max_f32_e32 v38, v38, v39
		v_max_f32_e32 v39, v40, v41
		v_max_f32_e32 v40, v42, v43
		v_max_f32_e32 v41, v44, v45
		v_max_f32_e32 v38, v38, v39
		v_max_f32_e32 v39, v40, v41
		v_max_f32_e32 v38, v38, v39
		ds_bpermute_b32 v39, v22, v38
		ds_bpermute_b32 v40, v16, v38
		v_max_f32_e32 v38, v240, v241
		v_max_f32_e32 v41, v242, v243
		v_max_f32_e32 v42, v244, v245
		v_max_f32_e32 v43, v246, v247
		v_max_f32_e32 v44, v248, v249
		v_max_f32_e32 v45, v250, v251
		v_max_f32_e32 v46, v252, v253
		v_max_f32_e32 v47, v254, v255
		v_max_f32_e32 v176, v224, v225
		v_max_f32_e32 v177, v226, v227
		v_max_f32_e32 v178, v228, v229
		v_max_f32_e32 v179, v230, v231
		v_max_f32_e32 v180, v232, v233
		v_max_f32_e32 v181, v234, v235
		v_max_f32_e32 v182, v236, v237
		v_max_f32_e32 v183, v238, v239
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v184, v39, v40
		v_max_f32_e32 v38, v38, v41
		v_max_f32_e32 v39, v42, v43
		v_max_f32_e32 v40, v44, v45
		v_max_f32_e32 v41, v46, v47
		v_max_f32_e32 v42, v176, v177
		v_max_f32_e32 v43, v178, v179
		v_max_f32_e32 v44, v180, v181
		v_max_f32_e32 v45, v182, v183
		v_max_f32_e32 v38, v38, v39
		v_max_f32_e32 v39, v40, v41
		v_max_f32_e32 v40, v42, v43
		v_max_f32_e32 v41, v44, v45
		v_max_f32_e32 v38, v38, v39
		v_max_f32_e32 v39, v40, v41
		v_max_f32_e32 v38, v38, v39
		ds_bpermute_b32 v39, v22, v38
		ds_bpermute_b32 v40, v16, v38
		v_pk_mul_f32 v[42:43], v[192:193], v[18:19]
		v_pk_mul_f32 v[44:45], v[194:195], v[18:19]
		v_pk_mul_f32 v[46:47], v[196:197], v[18:19]
		v_pk_mul_f32 v[176:177], v[198:199], v[18:19]
		v_pk_mul_f32 v[178:179], v[200:201], v[18:19]
		v_pk_mul_f32 v[180:181], v[202:203], v[18:19]
		v_pk_mul_f32 v[182:183], v[204:205], v[18:19]
		v_pk_mul_f32 v[186:187], v[206:207], v[18:19]
		v_pk_mul_f32 v[188:189], v[208:209], v[18:19]
		v_pk_mul_f32 v[190:191], v[210:211], v[18:19]
		v_pk_mul_f32 v[192:193], v[212:213], v[18:19]
		v_pk_mul_f32 v[194:195], v[214:215], v[18:19]
		v_pk_mul_f32 v[196:197], v[216:217], v[18:19]
		v_pk_mul_f32 v[198:199], v[218:219], v[18:19]
		v_pk_mul_f32 v[200:201], v[220:221], v[18:19]
		v_pk_mul_f32 v[202:203], v[222:223], v[18:19]
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v185, v39, v40
		v_pk_mul_f32 v[38:39], v[184:185], v[18:19]
		v_max_f32_e32 v38, v23, v38
		v_max_f32_e32 v39, v37, v39
		v_pk_mul_f32 v[40:41], v[240:241], v[18:19]
		v_pk_mul_f32 v[184:185], v[242:243], v[18:19]
		v_pk_mul_f32 v[204:205], v[244:245], v[18:19]
		v_pk_mul_f32 v[206:207], v[246:247], v[18:19]
		v_pk_mul_f32 v[208:209], v[248:249], v[18:19]
		v_pk_mul_f32 v[210:211], v[250:251], v[18:19]
		v_pk_mul_f32 v[212:213], v[252:253], v[18:19]
		v_pk_mul_f32 v[214:215], v[254:255], v[18:19]
		v_pk_mul_f32 v[216:217], v[224:225], v[18:19]
		v_pk_mul_f32 v[218:219], v[226:227], v[18:19]
		v_pk_mul_f32 v[220:221], v[228:229], v[18:19]
		v_pk_mul_f32 v[222:223], v[230:231], v[18:19]
		v_pk_mul_f32 v[224:225], v[232:233], v[18:19]
		v_pk_mul_f32 v[226:227], v[234:235], v[18:19]
		v_pk_mul_f32 v[228:229], v[236:237], v[18:19]
		v_pk_mul_f32 v[230:231], v[238:239], v[18:19]
		v_sub_f32_e32 v42, v42, v38
		v_sub_f32_e32 v43, v43, v38
		v_sub_f32_e32 v44, v44, v38
		v_sub_f32_e32 v45, v45, v38
		v_sub_f32_e32 v46, v46, v38
		v_sub_f32_e32 v47, v47, v38
		v_sub_f32_e32 v176, v176, v38
		v_sub_f32_e32 v177, v177, v38
		v_sub_f32_e32 v178, v178, v38
		v_sub_f32_e32 v179, v179, v38
		v_sub_f32_e32 v180, v180, v38
		v_sub_f32_e32 v181, v181, v38
		v_sub_f32_e32 v182, v182, v38
		v_sub_f32_e32 v183, v183, v38
		v_sub_f32_e32 v186, v186, v38
		v_sub_f32_e32 v187, v187, v38
		v_sub_f32_e32 v188, v188, v38
		v_sub_f32_e32 v189, v189, v38
		v_sub_f32_e32 v190, v190, v38
		v_sub_f32_e32 v191, v191, v38
		v_sub_f32_e32 v192, v192, v38
		v_sub_f32_e32 v193, v193, v38
		v_sub_f32_e32 v194, v194, v38
		v_sub_f32_e32 v195, v195, v38
		v_sub_f32_e32 v196, v196, v38
		v_sub_f32_e32 v197, v197, v38
		v_sub_f32_e32 v198, v198, v38
		v_sub_f32_e32 v199, v199, v38
		v_sub_f32_e32 v200, v200, v38
		v_sub_f32_e32 v201, v201, v38
		v_sub_f32_e32 v202, v202, v38
		v_sub_f32_e32 v203, v203, v38
		v_sub_f32_e32 v40, v40, v39
		v_sub_f32_e32 v41, v41, v39
		v_sub_f32_e32 v184, v184, v39
		v_sub_f32_e32 v185, v185, v39
		v_sub_f32_e32 v204, v204, v39
		v_sub_f32_e32 v205, v205, v39
		v_sub_f32_e32 v206, v206, v39
		v_sub_f32_e32 v207, v207, v39
		v_sub_f32_e32 v208, v208, v39
		v_sub_f32_e32 v209, v209, v39
		v_sub_f32_e32 v210, v210, v39
		v_sub_f32_e32 v211, v211, v39
		v_sub_f32_e32 v212, v212, v39
		v_sub_f32_e32 v213, v213, v39
		v_sub_f32_e32 v214, v214, v39
		v_sub_f32_e32 v215, v215, v39
		v_sub_f32_e32 v216, v216, v39
		v_sub_f32_e32 v217, v217, v39
		v_sub_f32_e32 v218, v218, v39
		v_sub_f32_e32 v219, v219, v39
		v_sub_f32_e32 v220, v220, v39
		v_sub_f32_e32 v221, v221, v39
		v_sub_f32_e32 v222, v222, v39
		v_sub_f32_e32 v223, v223, v39
		v_sub_f32_e32 v224, v224, v39
		v_sub_f32_e32 v225, v225, v39
		v_sub_f32_e32 v226, v226, v39
		v_sub_f32_e32 v227, v227, v39
		v_sub_f32_e32 v228, v228, v39
		v_sub_f32_e32 v229, v229, v39
		v_sub_f32_e32 v230, v230, v39
		v_sub_f32_e32 v231, v231, v39
		v_exp_f32_e32 v232, v42
		v_exp_f32_e32 v234, v43
		v_exp_f32_e32 v233, v44
		v_exp_f32_e32 v235, v45
		v_exp_f32_e32 v42, v46
		v_exp_f32_e32 v44, v47
		v_exp_f32_e32 v43, v176
		v_exp_f32_e32 v45, v177
		v_exp_f32_e32 v46, v178
		v_exp_f32_e32 v176, v179
		v_exp_f32_e32 v47, v180
		v_exp_f32_e32 v177, v181
		v_exp_f32_e32 v178, v182
		v_exp_f32_e32 v180, v183
		v_exp_f32_e32 v179, v186
		v_exp_f32_e32 v181, v187
		v_exp_f32_e32 v182, v188
		v_exp_f32_e32 v186, v189
		v_exp_f32_e32 v183, v190
		v_exp_f32_e32 v187, v191
		v_exp_f32_e32 v188, v192
		v_exp_f32_e32 v190, v193
		v_exp_f32_e32 v189, v194
		v_exp_f32_e32 v191, v195
		v_exp_f32_e32 v192, v196
		v_exp_f32_e32 v194, v197
		v_exp_f32_e32 v193, v198
		v_exp_f32_e32 v195, v199
		v_exp_f32_e32 v196, v200
		v_exp_f32_e32 v198, v201
		v_exp_f32_e32 v197, v202
		v_exp_f32_e32 v199, v203
		v_exp_f32_e32 v201, v40
		v_exp_f32_e32 v203, v41
		v_exp_f32_e32 v40, v184
		v_exp_f32_e32 v236, v185
		v_exp_f32_e32 v41, v204
		v_exp_f32_e32 v237, v205
		v_exp_f32_e32 v184, v206
		v_exp_f32_e32 v204, v207
		v_exp_f32_e32 v185, v208
		v_exp_f32_e32 v205, v209
		v_exp_f32_e32 v206, v210
		v_exp_f32_e32 v208, v211
		v_exp_f32_e32 v207, v212
		v_exp_f32_e32 v209, v213
		v_exp_f32_e32 v210, v214
		v_exp_f32_e32 v212, v215
		v_exp_f32_e32 v211, v216
		v_exp_f32_e32 v213, v217
		v_exp_f32_e32 v214, v218
		v_exp_f32_e32 v216, v219
		v_exp_f32_e32 v215, v220
		v_exp_f32_e32 v217, v221
		v_exp_f32_e32 v218, v222
		v_exp_f32_e32 v220, v223
		v_exp_f32_e32 v219, v224
		v_exp_f32_e32 v221, v225
		v_exp_f32_e32 v222, v226
		v_exp_f32_e32 v224, v227
		v_exp_f32_e32 v223, v228
		v_exp_f32_e32 v225, v229
		v_exp_f32_e32 v226, v230
		v_exp_f32_e32 v228, v231
		v_pk_add_f32 v[230:231], v[232:233], v[234:235]
		v_pk_add_f32 v[238:239], v[42:43], v[44:45]
		v_pk_add_f32 v[240:241], v[46:47], v[176:177]
		v_pk_add_f32 v[242:243], v[178:179], v[180:181]
		v_pk_add_f32 v[244:245], v[182:183], v[186:187]
		v_pk_add_f32 v[246:247], v[188:189], v[190:191]
		v_pk_add_f32 v[248:249], v[192:193], v[194:195]
		v_pk_add_f32 v[250:251], v[196:197], v[198:199]
		v_mov_b32_e32 v252, v231
		v_mov_b32_e32 v253, v239
		v_mov_b32_e32 v254, v230
		v_mov_b32_e32 v255, v238
		v_pk_add_f32 v[230:231], v[254:255], v[252:253]
		v_mov_b32_e32 v238, v241
		v_mov_b32_e32 v239, v243
		v_mov_b32_e32 v252, v240
		v_mov_b32_e32 v253, v242
		v_pk_add_f32 v[240:241], v[252:253], v[238:239]
		v_mov_b32_e32 v238, v245
		v_mov_b32_e32 v239, v247
		v_mov_b32_e32 v242, v244
		v_mov_b32_e32 v243, v246
		v_pk_add_f32 v[244:245], v[242:243], v[238:239]
		v_mov_b32_e32 v238, v249
		v_mov_b32_e32 v239, v251
		v_mov_b32_e32 v242, v248
		v_mov_b32_e32 v243, v250
		v_pk_add_f32 v[246:247], v[242:243], v[238:239]
		v_mov_b32_e32 v238, v231
		v_mov_b32_e32 v239, v241
		v_mov_b32_e32 v242, v230
		v_mov_b32_e32 v243, v240
		v_pk_add_f32 v[230:231], v[242:243], v[238:239]
		v_mov_b32_e32 v238, v245
		v_mov_b32_e32 v239, v247
		v_mov_b32_e32 v240, v244
		v_mov_b32_e32 v241, v246
		v_pk_add_f32 v[242:243], v[240:241], v[238:239]
		v_mov_b32_e32 v238, v231
		v_mov_b32_e32 v239, v243
		v_mov_b32_e32 v240, v230
		v_mov_b32_e32 v241, v242
		v_pk_add_f32 v[230:231], v[240:241], v[238:239]
		v_add_f32_e32 v227, v230, v231
		ds_bpermute_b32 v200, v22, v227
		ds_bpermute_b32 v202, v16, v227
		v_pk_add_f32 v[230:231], v[40:41], v[236:237]
		v_pk_add_f32 v[238:239], v[184:185], v[204:205]
		v_pk_add_f32 v[240:241], v[206:207], v[208:209]
		v_pk_add_f32 v[242:243], v[210:211], v[212:213]
		v_pk_add_f32 v[244:245], v[214:215], v[216:217]
		v_pk_add_f32 v[246:247], v[218:219], v[220:221]
		v_pk_add_f32 v[248:249], v[222:223], v[224:225]
		v_mov_b32_e32 v250, v231
		v_mov_b32_e32 v251, v240
		v_pk_add_f32 v[252:253], v[250:251], v[238:239]
		v_mov_b32_e32 v238, v241
		v_mov_b32_e32 v239, v244
		v_pk_add_f32 v[238:239], v[238:239], v[242:243]
		v_mov_b32_e32 v240, v245
		v_mov_b32_e32 v241, v248
		v_pk_add_f32 v[242:243], v[240:241], v[246:247]
		v_mov_b32_e32 v240, v253
		v_mov_b32_e32 v241, v242
		v_pk_add_f32 v[244:245], v[240:241], v[238:239]
		v_sub_f32_e32 v23, v23, v38
		v_sub_f32_e32 v37, v37, v39
		v_exp_f32_e32 v238, v23
		v_exp_f32_e32 v240, v37
		v_mov_b32_e32 v239, v238
		v_pk_mul_f32 v[48:49], v[48:49], v[238:239]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[246:247], v[200:201], v[202:203]
		v_mov_b32_e32 v227, v247
		v_mov_b32_e32 v229, v230
		v_pk_add_f32 v[230:231], v[226:227], v[228:229]
		v_mov_b32_e32 v250, v249
		v_mov_b32_e32 v251, v252
		v_pk_add_f32 v[230:231], v[250:251], v[230:231]
		v_mov_b32_e32 v248, v243
		v_mov_b32_e32 v249, v244
		v_pk_add_f32 v[242:243], v[248:249], v[230:231]
		v_add_f32_e32 v23, v245, v242
		v_add_f32_e32 v23, v243, v23
		ds_bpermute_b32 v37, v22, v23
		ds_bpermute_b32 v200, v16, v23
		v_pk_mul_f32 v[50:51], v[50:51], v[238:239]
		v_pk_mul_f32 v[52:53], v[52:53], v[238:239]
		v_pk_mul_f32 v[54:55], v[54:55], v[238:239]
		v_pk_mul_f32 v[56:57], v[56:57], v[238:239]
		v_pk_mul_f32 v[58:59], v[58:59], v[238:239]
		v_pk_mul_f32 v[60:61], v[60:61], v[238:239]
		v_pk_mul_f32 v[62:63], v[62:63], v[238:239]
		v_pk_mul_f32 v[64:65], v[64:65], v[238:239]
		v_pk_mul_f32 v[66:67], v[66:67], v[238:239]
		v_pk_mul_f32 v[68:69], v[68:69], v[238:239]
		v_pk_mul_f32 v[70:71], v[70:71], v[238:239]
		v_pk_mul_f32 v[72:73], v[72:73], v[238:239]
		v_pk_mul_f32 v[74:75], v[74:75], v[238:239]
		v_pk_mul_f32 v[76:77], v[76:77], v[238:239]
		v_pk_mul_f32 v[78:79], v[78:79], v[238:239]
		v_pk_mul_f32 v[80:81], v[80:81], v[238:239]
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v231, v37, v200
		v_pk_mul_f32 v[82:83], v[82:83], v[238:239]
		v_pk_mul_f32 v[84:85], v[84:85], v[238:239]
		v_pk_mul_f32 v[86:87], v[86:87], v[238:239]
		v_pk_mul_f32 v[88:89], v[88:89], v[238:239]
		v_pk_mul_f32 v[90:91], v[90:91], v[238:239]
		v_pk_mul_f32 v[92:93], v[92:93], v[238:239]
		v_pk_mul_f32 v[94:95], v[94:95], v[238:239]
		v_pk_mul_f32 v[96:97], v[96:97], v[238:239]
		v_pk_mul_f32 v[98:99], v[98:99], v[238:239]
		v_pk_mul_f32 v[100:101], v[100:101], v[238:239]
		v_pk_mul_f32 v[102:103], v[102:103], v[238:239]
		v_pk_mul_f32 v[104:105], v[104:105], v[238:239]
		v_pk_mul_f32 v[106:107], v[106:107], v[238:239]
		v_pk_mul_f32 v[108:109], v[108:109], v[238:239]
		v_pk_mul_f32 v[110:111], v[110:111], v[238:239]
		v_mov_b32_e32 v241, v240
		v_pk_mul_f32 v[112:113], v[112:113], v[240:241]
		v_pk_mul_f32 v[114:115], v[114:115], v[240:241]
		v_pk_mul_f32 v[116:117], v[116:117], v[240:241]
		v_pk_mul_f32 v[118:119], v[118:119], v[240:241]
		v_pk_mul_f32 v[120:121], v[120:121], v[240:241]
		v_pk_mul_f32 v[122:123], v[122:123], v[240:241]
		v_pk_mul_f32 v[124:125], v[124:125], v[240:241]
		v_pk_mul_f32 v[126:127], v[126:127], v[240:241]
		v_pk_mul_f32 v[128:129], v[128:129], v[240:241]
		v_pk_mul_f32 v[130:131], v[130:131], v[240:241]
		v_pk_mul_f32 v[132:133], v[132:133], v[240:241]
		v_pk_mul_f32 v[134:135], v[134:135], v[240:241]
		v_pk_mul_f32 v[136:137], v[136:137], v[240:241]
		v_pk_mul_f32 v[138:139], v[138:139], v[240:241]
		v_pk_mul_f32 v[140:141], v[140:141], v[240:241]
		v_pk_mul_f32 v[142:143], v[142:143], v[240:241]
		v_pk_mul_f32 v[144:145], v[144:145], v[240:241]
		v_pk_mul_f32 v[146:147], v[146:147], v[240:241]
		v_pk_mul_f32 v[148:149], v[148:149], v[240:241]
		v_pk_mul_f32 v[150:151], v[150:151], v[240:241]
		v_pk_mul_f32 v[152:153], v[152:153], v[240:241]
		v_pk_mul_f32 v[154:155], v[154:155], v[240:241]
		v_pk_mul_f32 v[156:157], v[156:157], v[240:241]
		v_pk_mul_f32 v[158:159], v[158:159], v[240:241]
		v_pk_mul_f32 v[160:161], v[160:161], v[240:241]
		v_pk_mul_f32 v[162:163], v[162:163], v[240:241]
		v_pk_mul_f32 v[164:165], v[164:165], v[240:241]
		v_pk_mul_f32 v[166:167], v[166:167], v[240:241]
		v_pk_mul_f32 v[168:169], v[168:169], v[240:241]
		v_pk_mul_f32 v[170:171], v[170:171], v[240:241]
		v_pk_mul_f32 v[172:173], v[172:173], v[240:241]
		v_pk_mul_f32 v[174:175], v[174:175], v[240:241]
		v_mov_b32_e32 v230, v246
		v_mov_b32_e32 v242, v238
		v_mov_b32_e32 v243, v240
		v_accvgpr_read_b32 v238, a64
		v_accvgpr_read_b32 v239, a65
		v_pk_fma_f32 v[230:231], v[238:239], v[242:243], v[230:231]
		v_accvgpr_write_b32 a64, v230
		v_accvgpr_write_b32 a65, v231
		v_cvt_pk_bf16_f32 v240, v232, v234
		v_cvt_pk_bf16_f32 v241, v233, v235
		v_cvt_pk_bf16_f32 v242, v42, v44
		v_cvt_pk_bf16_f32 v243, v43, v45
		v_cvt_pk_bf16_f32 v232, v46, v176
		v_cvt_pk_bf16_f32 v233, v47, v177
		v_cvt_pk_bf16_f32 v234, v178, v180
		v_cvt_pk_bf16_f32 v235, v179, v181
		v_cvt_pk_bf16_f32 v44, v182, v186
		v_cvt_pk_bf16_f32 v45, v183, v187
		v_cvt_pk_bf16_f32 v46, v188, v190
		v_cvt_pk_bf16_f32 v47, v189, v191
		v_cvt_pk_bf16_f32 v176, v192, v194
		v_cvt_pk_bf16_f32 v177, v193, v195
		v_cvt_pk_bf16_f32 v178, v196, v198
		v_cvt_pk_bf16_f32 v179, v197, v199
		v_cvt_pk_bf16_f32 v180, v201, v203
		v_cvt_pk_bf16_f32 v181, v40, v236
		v_cvt_pk_bf16_f32 v182, v41, v237
		v_cvt_pk_bf16_f32 v183, v184, v204
		v_cvt_pk_bf16_f32 v40, v185, v205
		v_cvt_pk_bf16_f32 v41, v206, v208
		v_cvt_pk_bf16_f32 v42, v207, v209
		v_cvt_pk_bf16_f32 v43, v210, v212
		v_cvt_pk_bf16_f32 v184, v211, v213
		v_cvt_pk_bf16_f32 v185, v214, v216
		v_cvt_pk_bf16_f32 v186, v215, v217
		v_cvt_pk_bf16_f32 v187, v218, v220
		v_cvt_pk_bf16_f32 v188, v219, v221
		v_cvt_pk_bf16_f32 v189, v222, v224
		v_cvt_pk_bf16_f32 v190, v223, v225
		v_cvt_pk_bf16_f32 v191, v226, v228
		v_permlane32_swap_b32_e32 v240, v242
		v_permlane32_swap_b32_e32 v241, v243
		v_permlane32_swap_b32_e32 v232, v234
		v_permlane32_swap_b32_e32 v233, v235
		v_permlane32_swap_b32_e32 v44, v46
		v_permlane32_swap_b32_e32 v45, v47
		v_mfma_f32_32x32x16_bf16 v[48:63], a[116:119], v[240:243], v[48:63]
		v_permlane32_swap_b32_e32 v176, v178
		v_permlane32_swap_b32_e32 v177, v179
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		v_permlane32_swap_b32_e32 v40, v42
		v_permlane32_swap_b32_e32 v41, v43
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[64:79], a[132:135], v[240:243], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[148:151], v[240:243], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[164:167], v[240:243], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[164:167], v[180:183], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[116:119], v[180:183], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[132:135], v[180:183], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[148:151], v[180:183], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[120:123], v[232:235], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[136:139], v[232:235], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], v[232:235], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[168:171], v[232:235], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[168:171], v[40:43], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[120:123], v[40:43], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[136:139], v[40:43], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[152:155], v[40:43], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[124:127], v[44:47], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[140:143], v[44:47], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], v[44:47], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[172:175], v[44:47], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[172:175], v[184:187], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[124:127], v[184:187], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[140:143], v[184:187], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[156:159], v[184:187], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[128:131], v[176:179], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[144:147], v[176:179], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[160:163], v[176:179], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[176:179], v[176:179], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[176:179], v[188:191], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[128:131], v[188:191], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[144:147], v[188:191], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[160:163], v[188:191], v[144:159]
		s_mov_b32 s4, s3
		v_mov_b32_e32 v23, v38
		v_mov_b32_e32 v37, v39
		s_cbranch_scc1 .L_attn_fwd_async_prefetch.loop_head_0
.L_attn_fwd_async_prefetch.loop_exit_0:
		s_waitcnt vmcnt(0)
		s_barrier
		s_and_b32 s1, s1, 1
		s_mul_i32 s3, 0x4100, s1
		v_lshl_add_u32 v0, v26, 4, s3
		v_lshl_add_u32 v0, v27, 8, v0
		v_add3_u32 v0, v0, v30, v31
		v_add3_u32 v0, v0, v32, v29
		ds_read_b128 v[28:31], v0
		ds_read_b128 v[40:43], v0 offset:32
		ds_read_b128 v[44:47], v0 offset:64
		ds_read_b128 a[68:71], v0 offset:96
		ds_read_b128 a[72:75], v0 offset:128
		ds_read_b128 a[76:79], v0 offset:160
		ds_read_b128 a[80:83], v0 offset:192
		ds_read_b128 a[84:87], v0 offset:224
		ds_read_b128 v[176:179], v0 offset:512
		ds_read_b128 v[180:183], v0 offset:544
		ds_read_b128 v[184:187], v0 offset:576
		ds_read_b128 a[88:91], v0 offset:608
		ds_read_b128 a[92:95], v0 offset:640
		ds_read_b128 a[96:99], v0 offset:672
		ds_read_b128 a[100:103], v0 offset:704
		ds_read_b128 a[104:107], v0 offset:736
		s_mul_i32 s1, 0x4400, s1
		v_add_u32_e32 v0, s1, v25
		v_add3_u32 v0, v0, v33, v35
		v_lshl_add_u32 v0, v12, 3, v0
		ds_read_b64_tr_b16 a[108:109], v0 offset:33264
		ds_read_b64_tr_b16 a[110:111], v0 offset:37616
		ds_read_b64_tr_b16 a[112:113], v0 offset:33520
		ds_read_b64_tr_b16 a[114:115], v0 offset:37872
		ds_read_b64_tr_b16 a[116:117], v0 offset:33776
		ds_read_b64_tr_b16 a[118:119], v0 offset:38128
		ds_read_b64_tr_b16 a[120:121], v0 offset:34032
		ds_read_b64_tr_b16 a[122:123], v0 offset:38384
		ds_read_b64_tr_b16 a[124:125], v0 offset:33328
		ds_read_b64_tr_b16 a[126:127], v0 offset:37680
		ds_read_b64_tr_b16 a[128:129], v0 offset:33584
		ds_read_b64_tr_b16 a[130:131], v0 offset:37936
		ds_read_b64_tr_b16 a[132:133], v0 offset:33840
		ds_read_b64_tr_b16 a[134:135], v0 offset:38192
		ds_read_b64_tr_b16 a[136:137], v0 offset:34096
		ds_read_b64_tr_b16 a[138:139], v0 offset:38448
		ds_read_b64_tr_b16 a[140:141], v0 offset:33392
		ds_read_b64_tr_b16 a[142:143], v0 offset:37744
		ds_read_b64_tr_b16 a[144:145], v0 offset:33648
		ds_read_b64_tr_b16 a[146:147], v0 offset:38000
		ds_read_b64_tr_b16 a[148:149], v0 offset:33904
		ds_read_b64_tr_b16 a[150:151], v0 offset:38256
		ds_read_b64_tr_b16 a[152:153], v0 offset:34160
		ds_read_b64_tr_b16 a[154:155], v0 offset:38512
		ds_read_b64_tr_b16 a[156:157], v0 offset:33456
		ds_read_b64_tr_b16 a[158:159], v0 offset:37808
		ds_read_b64_tr_b16 a[160:161], v0 offset:33712
		ds_read_b64_tr_b16 a[162:163], v0 offset:38064
		ds_read_b64_tr_b16 a[164:165], v0 offset:33968
		ds_read_b64_tr_b16 a[166:167], v0 offset:38320
		ds_read_b64_tr_b16 a[168:169], v0 offset:34224
		ds_read_b64_tr_b16 a[170:171], v0 offset:38576
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[192:207], v[28:31], a[0:3], 0
		v_add_u32_e32 v0, s2, v17
		v_add3_u32 v1, 1, v17, s2
		v_add3_u32 v6, 2, v17, s2
		v_add3_u32 v7, 3, v17, s2
		v_add3_u32 v8, 8, v17, s2
		v_add3_u32 v10, 9, v17, s2
		v_add3_u32 v12, 10, v17, s2
		v_mfma_f32_32x32x16_bf16 v[208:223], v[176:179], a[0:3], 0
		v_add3_u32 v14, 11, v17, s2
		v_add3_u32 v21, 16, v17, s2
		v_add3_u32 v24, 17, v17, s2
		v_add3_u32 v25, 18, v17, s2
		v_add3_u32 v26, 19, v17, s2
		v_add3_u32 v27, 24, v17, s2
		v_add3_u32 v32, 25, v17, s2
		v_mfma_f32_32x32x16_bf16 v[224:239], v[176:179], a[32:35], 0
		v_add3_u32 v33, 26, v17, s2
		v_add3_u32 v34, 27, v17, s2
		v_add3_u32 v35, 32, v17, s2
		v_add3_u32 v36, 33, v17, s2
		v_add3_u32 v38, 34, v17, s2
		v_add3_u32 v39, 35, v17, s2
		v_add3_u32 v176, 40, v17, s2
		v_mfma_f32_32x32x16_bf16 v[240:255], v[28:31], a[32:35], 0
		v_add3_u32 v28, 41, v17, s2
		v_add3_u32 v29, 42, v17, s2
		v_add3_u32 v30, 43, v17, s2
		v_add3_u32 v31, 48, v17, s2
		v_add3_u32 v177, 49, v17, s2
		v_add3_u32 v178, 50, v17, s2
		v_add3_u32 v179, 51, v17, s2
		v_mfma_f32_32x32x16_bf16 v[192:207], v[40:43], a[4:7], v[192:207]
		v_add3_u32 v188, 56, v17, s2
		v_add3_u32 v189, 57, v17, s2
		v_add3_u32 v190, 58, v17, s2
		v_add3_u32 v17, 59, v17, s2
		v_cmp_lt_i32_e64 vcc, v0, s25
		s_mov_b64 s[2:3], vcc
		v_cmp_lt_i32_e64 vcc, v1, s25
		s_mov_b64 s[4:5], vcc
		v_cmp_lt_i32_e64 vcc, v6, s25
		s_mov_b64 s[6:7], vcc
		v_mfma_f32_32x32x16_bf16 v[208:223], v[180:183], a[4:7], v[208:223]
		v_cmp_lt_i32_e64 vcc, v7, s25
		s_mov_b64 s[10:11], vcc
		v_cmp_lt_i32_e64 vcc, v8, s25
		s_mov_b64 s[12:13], vcc
		v_cmp_lt_i32_e64 vcc, v10, s25
		s_mov_b64 s[14:15], vcc
		v_cmp_lt_i32_e64 vcc, v12, s25
		s_mov_b64 s[18:19], vcc
		v_cmp_lt_i32_e64 vcc, v14, s25
		s_mov_b64 s[30:31], vcc
		v_cmp_lt_i32_e64 vcc, v21, s25
		s_mov_b64 s[32:33], vcc
		v_cmp_lt_i32_e64 vcc, v24, s25
		s_mov_b64 s[36:37], vcc
		v_mfma_f32_32x32x16_bf16 v[224:239], v[180:183], a[36:39], v[224:239]
		v_cmp_lt_i32_e64 vcc, v25, s25
		s_mov_b64 s[38:39], vcc
		v_cmp_lt_i32_e64 vcc, v26, s25
		s_mov_b64 s[40:41], vcc
		v_cmp_lt_i32_e64 vcc, v27, s25
		s_mov_b64 s[42:43], vcc
		v_cmp_lt_i32_e64 vcc, v32, s25
		s_mov_b64 s[44:45], vcc
		v_cmp_lt_i32_e64 vcc, v33, s25
		s_mov_b64 s[46:47], vcc
		v_cmp_lt_i32_e64 vcc, v34, s25
		s_mov_b64 s[48:49], vcc
		v_cmp_lt_i32_e64 vcc, v35, s25
		s_mov_b64 s[50:51], vcc
		v_mfma_f32_32x32x16_bf16 v[240:255], v[40:43], a[36:39], v[240:255]
		v_cmp_lt_i32_e64 vcc, v36, s25
		s_mov_b64 s[52:53], vcc
		v_cmp_lt_i32_e64 vcc, v38, s25
		s_mov_b64 s[54:55], vcc
		v_cmp_lt_i32_e64 vcc, v39, s25
		s_mov_b64 s[56:57], vcc
		v_cmp_lt_i32_e64 vcc, v176, s25
		s_mov_b64 s[58:59], vcc
		v_cmp_lt_i32_e64 vcc, v28, s25
		s_mov_b64 s[60:61], vcc
		v_cmp_lt_i32_e64 vcc, v29, s25
		s_mov_b64 s[62:63], vcc
		v_cmp_lt_i32_e64 vcc, v30, s25
		s_mov_b64 s[64:65], vcc
		v_mfma_f32_32x32x16_bf16 v[192:207], v[44:47], a[8:11], v[192:207]
		v_cmp_lt_i32_e64 vcc, v31, s25
		s_mov_b64 s[66:67], vcc
		v_cmp_lt_i32_e64 vcc, v177, s25
		s_mov_b64 s[68:69], vcc
		v_cmp_lt_i32_e64 vcc, v178, s25
		s_mov_b64 s[70:71], vcc
		v_cmp_lt_i32_e64 vcc, v179, s25
		s_mov_b64 s[72:73], vcc
		v_cmp_lt_i32_e64 vcc, v188, s25
		s_mov_b64 s[74:75], vcc
		v_cmp_lt_i32_e64 vcc, v189, s25
		s_mov_b64 s[76:77], vcc
		v_cmp_lt_i32_e64 vcc, v190, s25
		s_mov_b64 s[78:79], vcc
		v_mfma_f32_32x32x16_bf16 v[208:223], v[184:187], a[8:11], v[208:223]
		v_cmp_lt_i32_e64 vcc, v17, s25
		v_mov_b32_e32 v0, 0xff800000
		v_mfma_f32_32x32x16_bf16 v[224:239], v[184:187], a[40:43], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[44:47], a[40:43], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[68:71], a[12:15], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[88:91], a[12:15], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[88:91], a[44:47], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[68:71], a[44:47], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[72:75], a[16:19], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[92:95], a[16:19], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[92:95], a[48:51], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[72:75], a[48:51], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[76:79], a[20:23], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[96:99], a[20:23], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[96:99], a[52:55], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[76:79], a[52:55], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[80:83], a[24:27], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[100:103], a[24:27], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[100:103], a[56:59], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[80:83], a[56:59], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[84:87], a[28:31], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[104:107], a[28:31], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[104:107], a[60:63], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[84:87], a[60:63], v[240:255]
		v_lshlrev_b32_e32 v1, 4, v13
		s_nop 7
		v_cndmask_b32_e64 v6, v0, v192, s[2:3]
		v_cndmask_b32_e64 v7, v0, v193, s[4:5]
		v_cndmask_b32_e64 v12, v0, v194, s[6:7]
		v_cndmask_b32_e64 v13, v0, v195, s[10:11]
		v_cndmask_b32_e64 v24, v0, v196, s[12:13]
		v_cndmask_b32_e64 v25, v0, v197, s[14:15]
		v_cndmask_b32_e64 v26, v0, v198, s[18:19]
		v_cndmask_b32_e64 v27, v0, v199, s[30:31]
		v_cndmask_b32_e64 v28, v0, v200, s[32:33]
		v_cndmask_b32_e64 v29, v0, v201, s[36:37]
		v_cndmask_b32_e64 v30, v0, v202, s[38:39]
		v_cndmask_b32_e64 v31, v0, v203, s[40:41]
		v_cndmask_b32_e64 v32, v0, v204, s[42:43]
		v_cndmask_b32_e64 v33, v0, v205, s[44:45]
		v_cndmask_b32_e64 v34, v0, v206, s[46:47]
		v_cndmask_b32_e64 v35, v0, v207, s[48:49]
		v_cndmask_b32_e64 v38, v0, v208, s[50:51]
		v_cndmask_b32_e64 v39, v0, v209, s[52:53]
		v_cndmask_b32_e64 v40, v0, v210, s[54:55]
		v_cndmask_b32_e64 v41, v0, v211, s[56:57]
		v_cndmask_b32_e64 v42, v0, v212, s[58:59]
		v_cndmask_b32_e64 v43, v0, v213, s[60:61]
		v_cndmask_b32_e64 v44, v0, v214, s[62:63]
		v_cndmask_b32_e64 v45, v0, v215, s[64:65]
		v_cndmask_b32_e64 v46, v0, v216, s[66:67]
		v_cndmask_b32_e64 v47, v0, v217, s[68:69]
		v_cndmask_b32_e64 v176, v0, v218, s[70:71]
		v_cndmask_b32_e64 v177, v0, v219, s[72:73]
		v_cndmask_b32_e64 v178, v0, v220, s[74:75]
		v_cndmask_b32_e64 v179, v0, v221, s[76:77]
		v_cndmask_b32_e64 v180, v0, v222, s[78:79]
		v_cndmask_b32_e32 v181, v0, v223, vcc
		v_cndmask_b32_e64 v182, v0, v240, s[2:3]
		v_cndmask_b32_e64 v183, v0, v241, s[4:5]
		v_cndmask_b32_e64 v184, v0, v242, s[6:7]
		v_cndmask_b32_e64 v185, v0, v243, s[10:11]
		v_cndmask_b32_e64 v186, v0, v244, s[12:13]
		v_cndmask_b32_e64 v187, v0, v245, s[14:15]
		v_cndmask_b32_e64 v188, v0, v246, s[18:19]
		v_cndmask_b32_e64 v189, v0, v247, s[30:31]
		v_cndmask_b32_e64 v190, v0, v248, s[32:33]
		v_cndmask_b32_e64 v191, v0, v249, s[36:37]
		v_cndmask_b32_e64 v192, v0, v250, s[38:39]
		v_cndmask_b32_e64 v193, v0, v251, s[40:41]
		v_cndmask_b32_e64 v194, v0, v252, s[42:43]
		v_cndmask_b32_e64 v195, v0, v253, s[44:45]
		v_cndmask_b32_e64 v196, v0, v254, s[46:47]
		v_cndmask_b32_e64 v197, v0, v255, s[48:49]
		v_cndmask_b32_e64 v198, v0, v224, s[50:51]
		v_cndmask_b32_e64 v199, v0, v225, s[52:53]
		v_cndmask_b32_e64 v200, v0, v226, s[54:55]
		v_cndmask_b32_e64 v201, v0, v227, s[56:57]
		v_cndmask_b32_e64 v202, v0, v228, s[58:59]
		v_cndmask_b32_e64 v203, v0, v229, s[60:61]
		v_cndmask_b32_e64 v204, v0, v230, s[62:63]
		v_cndmask_b32_e64 v205, v0, v231, s[64:65]
		v_cndmask_b32_e64 v206, v0, v232, s[66:67]
		v_cndmask_b32_e64 v207, v0, v233, s[68:69]
		v_cndmask_b32_e64 v208, v0, v234, s[70:71]
		v_cndmask_b32_e64 v209, v0, v235, s[72:73]
		v_cndmask_b32_e64 v210, v0, v236, s[74:75]
		v_cndmask_b32_e64 v211, v0, v237, s[76:77]
		v_cndmask_b32_e64 v212, v0, v238, s[78:79]
		v_cndmask_b32_e32 v213, v0, v239, vcc
		v_max_f32_e32 v0, v6, v7
		v_max_f32_e32 v8, v12, v13
		v_max_f32_e32 v10, v24, v25
		v_max_f32_e32 v14, v26, v27
		v_max_f32_e32 v17, v28, v29
		v_max_f32_e32 v21, v30, v31
		v_max_f32_e32 v36, v32, v33
		v_max_f32_e32 v214, v34, v35
		v_max_f32_e32 v215, v38, v39
		v_max_f32_e32 v216, v40, v41
		v_max_f32_e32 v217, v42, v43
		v_max_f32_e32 v218, v44, v45
		v_max_f32_e32 v219, v46, v47
		v_max_f32_e32 v220, v176, v177
		v_max_f32_e32 v221, v178, v179
		v_max_f32_e32 v222, v180, v181
		v_max_f32_e32 v0, v0, v8
		v_max_f32_e32 v8, v10, v14
		v_max_f32_e32 v10, v17, v21
		v_max_f32_e32 v14, v36, v214
		v_max_f32_e32 v17, v215, v216
		v_max_f32_e32 v21, v217, v218
		v_max_f32_e32 v36, v219, v220
		v_max_f32_e32 v214, v221, v222
		v_max_f32_e32 v0, v0, v8
		v_max_f32_e32 v8, v10, v14
		v_max_f32_e32 v10, v17, v21
		v_max_f32_e32 v14, v36, v214
		v_max_f32_e32 v0, v0, v8
		v_max_f32_e32 v8, v10, v14
		v_max_f32_e32 v0, v0, v8
		ds_bpermute_b32 v8, v22, v0
		ds_bpermute_b32 v10, v16, v0
		v_max_f32_e32 v0, v182, v183
		v_max_f32_e32 v14, v184, v185
		v_max_f32_e32 v17, v186, v187
		v_max_f32_e32 v21, v188, v189
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v214, v8, v10
		v_max_f32_e32 v8, v190, v191
		v_max_f32_e32 v10, v192, v193
		v_max_f32_e32 v36, v194, v195
		v_max_f32_e32 v215, v196, v197
		v_max_f32_e32 v216, v198, v199
		v_max_f32_e32 v217, v200, v201
		v_max_f32_e32 v218, v202, v203
		v_max_f32_e32 v219, v204, v205
		v_max_f32_e32 v220, v206, v207
		v_max_f32_e32 v221, v208, v209
		v_max_f32_e32 v222, v210, v211
		v_max_f32_e32 v223, v212, v213
		v_max_f32_e32 v0, v0, v14
		v_max_f32_e32 v14, v17, v21
		v_max_f32_e32 v8, v8, v10
		v_max_f32_e32 v10, v36, v215
		v_max_f32_e32 v17, v216, v217
		v_max_f32_e32 v21, v218, v219
		v_max_f32_e32 v36, v220, v221
		v_max_f32_e32 v215, v222, v223
		v_max_f32_e32 v0, v0, v14
		v_max_f32_e32 v8, v8, v10
		v_max_f32_e32 v10, v17, v21
		v_max_f32_e32 v14, v36, v215
		v_max_f32_e32 v0, v0, v8
		v_max_f32_e32 v8, v10, v14
		v_max_f32_e32 v0, v0, v8
		ds_bpermute_b32 v8, v22, v0
		ds_bpermute_b32 v10, v16, v0
		v_pk_mul_f32 v[216:217], v[6:7], v[18:19]
		v_pk_mul_f32 v[6:7], v[12:13], v[18:19]
		v_pk_mul_f32 v[12:13], v[24:25], v[18:19]
		v_pk_mul_f32 v[24:25], v[26:27], v[18:19]
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v215, v8, v10
		v_pk_mul_f32 v[26:27], v[214:215], v[18:19]
		v_max_f32_e32 v0, v23, v26
		v_max_f32_e32 v8, v37, v27
		v_pk_mul_f32 v[26:27], v[28:29], v[18:19]
		v_pk_mul_f32 v[28:29], v[30:31], v[18:19]
		v_pk_mul_f32 v[30:31], v[32:33], v[18:19]
		v_pk_mul_f32 v[32:33], v[34:35], v[18:19]
		v_pk_mul_f32 v[34:35], v[38:39], v[18:19]
		v_pk_mul_f32 v[38:39], v[40:41], v[18:19]
		v_pk_mul_f32 v[40:41], v[42:43], v[18:19]
		v_pk_mul_f32 v[42:43], v[44:45], v[18:19]
		v_pk_mul_f32 v[44:45], v[46:47], v[18:19]
		v_pk_mul_f32 v[46:47], v[176:177], v[18:19]
		v_pk_mul_f32 v[176:177], v[178:179], v[18:19]
		v_pk_mul_f32 v[178:179], v[180:181], v[18:19]
		v_pk_mul_f32 v[180:181], v[182:183], v[18:19]
		v_pk_mul_f32 v[182:183], v[184:185], v[18:19]
		v_pk_mul_f32 v[184:185], v[186:187], v[18:19]
		v_pk_mul_f32 v[186:187], v[188:189], v[18:19]
		v_pk_mul_f32 v[188:189], v[190:191], v[18:19]
		v_pk_mul_f32 v[190:191], v[192:193], v[18:19]
		v_pk_mul_f32 v[192:193], v[194:195], v[18:19]
		v_pk_mul_f32 v[194:195], v[196:197], v[18:19]
		v_pk_mul_f32 v[196:197], v[198:199], v[18:19]
		v_pk_mul_f32 v[198:199], v[200:201], v[18:19]
		v_pk_mul_f32 v[200:201], v[202:203], v[18:19]
		v_pk_mul_f32 v[202:203], v[204:205], v[18:19]
		v_pk_mul_f32 v[204:205], v[206:207], v[18:19]
		v_pk_mul_f32 v[206:207], v[208:209], v[18:19]
		v_pk_mul_f32 v[208:209], v[210:211], v[18:19]
		v_pk_mul_f32 v[210:211], v[212:213], v[18:19]
		v_sub_f32_e32 v10, v216, v0
		v_sub_f32_e32 v14, v217, v0
		v_sub_f32_e32 v6, v6, v0
		v_sub_f32_e32 v7, v7, v0
		v_sub_f32_e32 v12, v12, v0
		v_sub_f32_e32 v13, v13, v0
		v_sub_f32_e32 v17, v24, v0
		v_sub_f32_e32 v18, v25, v0
		v_sub_f32_e32 v19, v26, v0
		v_sub_f32_e32 v21, v27, v0
		v_sub_f32_e32 v24, v28, v0
		v_sub_f32_e32 v25, v29, v0
		v_sub_f32_e32 v26, v30, v0
		v_sub_f32_e32 v27, v31, v0
		v_sub_f32_e32 v28, v32, v0
		v_sub_f32_e32 v29, v33, v0
		v_sub_f32_e32 v30, v34, v0
		v_sub_f32_e32 v31, v35, v0
		v_sub_f32_e32 v32, v38, v0
		v_sub_f32_e32 v33, v39, v0
		v_sub_f32_e32 v34, v40, v0
		v_sub_f32_e32 v35, v41, v0
		v_sub_f32_e32 v36, v42, v0
		v_sub_f32_e32 v38, v43, v0
		v_sub_f32_e32 v39, v44, v0
		v_sub_f32_e32 v40, v45, v0
		v_sub_f32_e32 v41, v46, v0
		v_sub_f32_e32 v42, v47, v0
		v_sub_f32_e32 v43, v176, v0
		v_sub_f32_e32 v44, v177, v0
		v_sub_f32_e32 v45, v178, v0
		v_sub_f32_e32 v46, v179, v0
		v_sub_f32_e32 v47, v180, v8
		v_sub_f32_e32 v176, v181, v8
		v_sub_f32_e32 v177, v182, v8
		v_sub_f32_e32 v178, v183, v8
		v_sub_f32_e32 v179, v184, v8
		v_sub_f32_e32 v180, v185, v8
		v_sub_f32_e32 v181, v186, v8
		v_sub_f32_e32 v182, v187, v8
		v_sub_f32_e32 v183, v188, v8
		v_sub_f32_e32 v184, v189, v8
		v_sub_f32_e32 v185, v190, v8
		v_sub_f32_e32 v186, v191, v8
		v_sub_f32_e32 v187, v192, v8
		v_sub_f32_e32 v188, v193, v8
		v_sub_f32_e32 v189, v194, v8
		v_sub_f32_e32 v190, v195, v8
		v_sub_f32_e32 v191, v196, v8
		v_sub_f32_e32 v192, v197, v8
		v_sub_f32_e32 v193, v198, v8
		v_sub_f32_e32 v194, v199, v8
		v_sub_f32_e32 v195, v200, v8
		v_sub_f32_e32 v196, v201, v8
		v_sub_f32_e32 v197, v202, v8
		v_sub_f32_e32 v198, v203, v8
		v_sub_f32_e32 v199, v204, v8
		v_sub_f32_e32 v200, v205, v8
		v_sub_f32_e32 v201, v206, v8
		v_sub_f32_e32 v202, v207, v8
		v_sub_f32_e32 v203, v208, v8
		v_sub_f32_e32 v204, v209, v8
		v_sub_f32_e32 v205, v210, v8
		v_sub_f32_e32 v206, v211, v8
		v_exp_f32_e32 v208, v10
		v_exp_f32_e32 v210, v14
		v_exp_f32_e32 v209, v6
		v_exp_f32_e32 v211, v7
		v_exp_f32_e32 v6, v12
		v_exp_f32_e32 v212, v13
		v_exp_f32_e32 v7, v17
		v_exp_f32_e32 v213, v18
		v_exp_f32_e32 v12, v19
		v_exp_f32_e32 v18, v21
		v_exp_f32_e32 v13, v24
		v_exp_f32_e32 v19, v25
		v_exp_f32_e32 v24, v26
		v_exp_f32_e32 v214, v27
		v_exp_f32_e32 v25, v28
		v_exp_f32_e32 v215, v29
		v_exp_f32_e32 v26, v30
		v_exp_f32_e32 v28, v31
		v_exp_f32_e32 v27, v32
		v_exp_f32_e32 v29, v33
		v_exp_f32_e32 v30, v34
		v_exp_f32_e32 v32, v35
		v_exp_f32_e32 v31, v36
		v_exp_f32_e32 v33, v38
		v_exp_f32_e32 v34, v39
		v_exp_f32_e32 v38, v40
		v_exp_f32_e32 v35, v41
		v_exp_f32_e32 v39, v42
		v_exp_f32_e32 v40, v43
		v_exp_f32_e32 v42, v44
		v_exp_f32_e32 v41, v45
		v_exp_f32_e32 v43, v46
		v_exp_f32_e32 v45, v47
		v_exp_f32_e32 v47, v176
		v_exp_f32_e32 v216, v177
		v_exp_f32_e32 v176, v178
		v_exp_f32_e32 v217, v179
		v_exp_f32_e32 v177, v180
		v_exp_f32_e32 v178, v181
		v_exp_f32_e32 v180, v182
		v_exp_f32_e32 v179, v183
		v_exp_f32_e32 v181, v184
		v_exp_f32_e32 v182, v185
		v_exp_f32_e32 v184, v186
		v_exp_f32_e32 v183, v187
		v_exp_f32_e32 v185, v188
		v_exp_f32_e32 v186, v189
		v_exp_f32_e32 v188, v190
		v_exp_f32_e32 v187, v191
		v_exp_f32_e32 v189, v192
		v_exp_f32_e32 v190, v193
		v_exp_f32_e32 v192, v194
		v_exp_f32_e32 v191, v195
		v_exp_f32_e32 v193, v196
		v_exp_f32_e32 v194, v197
		v_exp_f32_e32 v196, v198
		v_exp_f32_e32 v195, v199
		v_exp_f32_e32 v197, v200
		v_exp_f32_e32 v198, v201
		v_exp_f32_e32 v200, v202
		v_exp_f32_e32 v199, v203
		v_exp_f32_e32 v201, v204
		v_exp_f32_e32 v202, v205
		v_exp_f32_e32 v204, v206
		v_pk_add_f32 v[206:207], v[208:209], v[210:211]
		v_pk_add_f32 v[218:219], v[6:7], v[212:213]
		v_pk_add_f32 v[220:221], v[12:13], v[18:19]
		v_pk_add_f32 v[222:223], v[24:25], v[214:215]
		v_pk_add_f32 v[224:225], v[26:27], v[28:29]
		v_pk_add_f32 v[226:227], v[30:31], v[32:33]
		v_pk_add_f32 v[228:229], v[34:35], v[38:39]
		v_pk_add_f32 v[230:231], v[40:41], v[42:43]
		v_mov_b32_e32 v232, v207
		v_mov_b32_e32 v233, v219
		v_mov_b32_e32 v234, v206
		v_mov_b32_e32 v235, v218
		v_pk_add_f32 v[206:207], v[234:235], v[232:233]
		v_mov_b32_e32 v218, v221
		v_mov_b32_e32 v219, v223
		v_mov_b32_e32 v232, v220
		v_mov_b32_e32 v233, v222
		v_pk_add_f32 v[220:221], v[232:233], v[218:219]
		v_mov_b32_e32 v218, v225
		v_mov_b32_e32 v219, v227
		v_mov_b32_e32 v222, v224
		v_mov_b32_e32 v223, v226
		v_pk_add_f32 v[224:225], v[222:223], v[218:219]
		v_mov_b32_e32 v218, v229
		v_mov_b32_e32 v219, v231
		v_mov_b32_e32 v222, v228
		v_mov_b32_e32 v223, v230
		v_pk_add_f32 v[226:227], v[222:223], v[218:219]
		v_mov_b32_e32 v218, v207
		v_mov_b32_e32 v219, v221
		v_mov_b32_e32 v222, v206
		v_mov_b32_e32 v223, v220
		v_pk_add_f32 v[206:207], v[222:223], v[218:219]
		v_mov_b32_e32 v218, v225
		v_mov_b32_e32 v219, v227
		v_mov_b32_e32 v220, v224
		v_mov_b32_e32 v221, v226
		v_pk_add_f32 v[222:223], v[220:221], v[218:219]
		v_mov_b32_e32 v218, v207
		v_mov_b32_e32 v219, v223
		v_mov_b32_e32 v220, v206
		v_mov_b32_e32 v221, v222
		v_pk_add_f32 v[206:207], v[220:221], v[218:219]
		v_add_f32_e32 v10, v206, v207
		ds_bpermute_b32 v44, v22, v10
		ds_bpermute_b32 v46, v16, v10
		v_pk_add_f32 v[206:207], v[216:217], v[176:177]
		v_pk_add_f32 v[218:219], v[178:179], v[180:181]
		v_pk_add_f32 v[220:221], v[182:183], v[184:185]
		v_pk_add_f32 v[222:223], v[186:187], v[188:189]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[224:225], v[44:45], v[46:47]
		v_pk_add_f32 v[226:227], v[190:191], v[192:193]
		v_pk_add_f32 v[228:229], v[194:195], v[196:197]
		v_pk_add_f32 v[230:231], v[198:199], v[200:201]
		v_mov_b32_e32 v203, v225
		v_mov_b32_e32 v205, v206
		v_pk_add_f32 v[232:233], v[202:203], v[204:205]
		v_mov_b32_e32 v234, v207
		v_mov_b32_e32 v235, v220
		v_pk_add_f32 v[206:207], v[234:235], v[218:219]
		v_mov_b32_e32 v218, v221
		v_mov_b32_e32 v219, v226
		v_pk_add_f32 v[218:219], v[218:219], v[222:223]
		v_mov_b32_e32 v220, v227
		v_mov_b32_e32 v221, v230
		v_pk_add_f32 v[222:223], v[220:221], v[228:229]
		v_mov_b32_e32 v220, v231
		v_mov_b32_e32 v221, v206
		v_pk_add_f32 v[220:221], v[220:221], v[232:233]
		v_mov_b32_e32 v226, v207
		v_mov_b32_e32 v227, v222
		v_pk_add_f32 v[206:207], v[226:227], v[218:219]
		v_mov_b32_e32 v218, v223
		v_mov_b32_e32 v219, v206
		v_pk_add_f32 v[222:223], v[218:219], v[220:221]
		v_add_f32_e32 v10, v207, v222
		v_add_f32_e32 v10, v223, v10
		ds_bpermute_b32 v14, v22, v10
		ds_bpermute_b32 v17, v16, v10
		v_sub_f32_e32 v0, v23, v0
		v_sub_f32_e32 v8, v37, v8
		v_exp_f32_e32 v22, v0
		v_exp_f32_e32 v36, v8
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v207, v14, v17
		v_mov_b32_e32 v23, v22
		v_pk_mul_f32 v[240:241], v[48:49], v[22:23]
		v_pk_mul_f32 v[242:243], v[50:51], v[22:23]
		v_pk_mul_f32 v[244:245], v[52:53], v[22:23]
		v_pk_mul_f32 v[246:247], v[54:55], v[22:23]
		v_pk_mul_f32 v[248:249], v[56:57], v[22:23]
		v_pk_mul_f32 v[250:251], v[58:59], v[22:23]
		v_pk_mul_f32 v[252:253], v[60:61], v[22:23]
		v_pk_mul_f32 v[254:255], v[62:63], v[22:23]
		v_pk_mul_f32 v[48:49], v[64:65], v[22:23]
		v_pk_mul_f32 v[50:51], v[66:67], v[22:23]
		v_pk_mul_f32 v[52:53], v[68:69], v[22:23]
		v_pk_mul_f32 v[54:55], v[70:71], v[22:23]
		v_pk_mul_f32 v[56:57], v[72:73], v[22:23]
		v_pk_mul_f32 v[58:59], v[74:75], v[22:23]
		v_pk_mul_f32 v[60:61], v[76:77], v[22:23]
		v_pk_mul_f32 v[62:63], v[78:79], v[22:23]
		v_pk_mul_f32 v[64:65], v[80:81], v[22:23]
		v_pk_mul_f32 v[66:67], v[82:83], v[22:23]
		v_pk_mul_f32 v[68:69], v[84:85], v[22:23]
		v_pk_mul_f32 v[70:71], v[86:87], v[22:23]
		v_pk_mul_f32 v[72:73], v[88:89], v[22:23]
		v_pk_mul_f32 v[74:75], v[90:91], v[22:23]
		v_pk_mul_f32 v[76:77], v[92:93], v[22:23]
		v_pk_mul_f32 v[78:79], v[94:95], v[22:23]
		v_pk_mul_f32 v[80:81], v[96:97], v[22:23]
		v_pk_mul_f32 v[82:83], v[98:99], v[22:23]
		v_pk_mul_f32 v[84:85], v[100:101], v[22:23]
		v_pk_mul_f32 v[86:87], v[102:103], v[22:23]
		v_pk_mul_f32 v[88:89], v[104:105], v[22:23]
		v_pk_mul_f32 v[90:91], v[106:107], v[22:23]
		v_pk_mul_f32 v[92:93], v[108:109], v[22:23]
		v_pk_mul_f32 v[94:95], v[110:111], v[22:23]
		v_mov_b32_e32 v37, v36
		v_pk_mul_f32 v[96:97], v[112:113], v[36:37]
		v_pk_mul_f32 v[98:99], v[114:115], v[36:37]
		v_pk_mul_f32 v[100:101], v[116:117], v[36:37]
		v_pk_mul_f32 v[102:103], v[118:119], v[36:37]
		v_pk_mul_f32 v[104:105], v[120:121], v[36:37]
		v_pk_mul_f32 v[106:107], v[122:123], v[36:37]
		v_pk_mul_f32 v[108:109], v[124:125], v[36:37]
		v_pk_mul_f32 v[110:111], v[126:127], v[36:37]
		v_pk_mul_f32 v[112:113], v[128:129], v[36:37]
		v_pk_mul_f32 v[114:115], v[130:131], v[36:37]
		v_pk_mul_f32 v[116:117], v[132:133], v[36:37]
		v_pk_mul_f32 v[118:119], v[134:135], v[36:37]
		v_pk_mul_f32 v[120:121], v[136:137], v[36:37]
		v_pk_mul_f32 v[122:123], v[138:139], v[36:37]
		v_pk_mul_f32 v[124:125], v[140:141], v[36:37]
		v_pk_mul_f32 v[126:127], v[142:143], v[36:37]
		v_pk_mul_f32 v[128:129], v[144:145], v[36:37]
		v_pk_mul_f32 v[130:131], v[146:147], v[36:37]
		v_pk_mul_f32 v[132:133], v[148:149], v[36:37]
		v_pk_mul_f32 v[134:135], v[150:151], v[36:37]
		v_pk_mul_f32 v[136:137], v[152:153], v[36:37]
		v_pk_mul_f32 v[138:139], v[154:155], v[36:37]
		v_pk_mul_f32 v[140:141], v[156:157], v[36:37]
		v_pk_mul_f32 v[142:143], v[158:159], v[36:37]
		v_pk_mul_f32 v[144:145], v[160:161], v[36:37]
		v_pk_mul_f32 v[146:147], v[162:163], v[36:37]
		v_pk_mul_f32 v[148:149], v[164:165], v[36:37]
		v_pk_mul_f32 v[150:151], v[166:167], v[36:37]
		v_pk_mul_f32 v[152:153], v[168:169], v[36:37]
		v_pk_mul_f32 v[154:155], v[170:171], v[36:37]
		v_pk_mul_f32 v[156:157], v[172:173], v[36:37]
		v_pk_mul_f32 v[158:159], v[174:175], v[36:37]
		v_mov_b32_e32 v206, v224
		v_mov_b32_e32 v16, v22
		v_mov_b32_e32 v17, v36
		v_accvgpr_read_b32 v22, a64
		v_accvgpr_read_b32 v23, a65
		v_pk_fma_f32 v[36:37], v[22:23], v[16:17], v[206:207]
		v_cvt_pk_bf16_f32 v160, v208, v210
		v_cvt_pk_bf16_f32 v161, v209, v211
		v_cvt_pk_bf16_f32 v162, v6, v212
		v_cvt_pk_bf16_f32 v163, v7, v213
		v_cvt_pk_bf16_f32 v164, v12, v18
		v_cvt_pk_bf16_f32 v165, v13, v19
		v_cvt_pk_bf16_f32 v166, v24, v214
		v_cvt_pk_bf16_f32 v167, v25, v215
		v_cvt_pk_bf16_f32 v16, v26, v28
		v_cvt_pk_bf16_f32 v17, v27, v29
		v_cvt_pk_bf16_f32 v18, v30, v32
		v_cvt_pk_bf16_f32 v19, v31, v33
		v_cvt_pk_bf16_f32 v24, v34, v38
		v_cvt_pk_bf16_f32 v25, v35, v39
		v_cvt_pk_bf16_f32 v26, v40, v42
		v_cvt_pk_bf16_f32 v27, v41, v43
		v_cvt_pk_bf16_f32 v28, v45, v47
		v_cvt_pk_bf16_f32 v29, v216, v176
		v_cvt_pk_bf16_f32 v30, v217, v177
		v_cvt_pk_bf16_f32 v31, v178, v180
		v_cvt_pk_bf16_f32 v32, v179, v181
		v_cvt_pk_bf16_f32 v33, v182, v184
		v_cvt_pk_bf16_f32 v34, v183, v185
		v_cvt_pk_bf16_f32 v35, v186, v188
		v_cvt_pk_bf16_f32 v40, v187, v189
		v_cvt_pk_bf16_f32 v41, v190, v192
		v_cvt_pk_bf16_f32 v42, v191, v193
		v_cvt_pk_bf16_f32 v43, v194, v196
		v_cvt_pk_bf16_f32 v44, v195, v197
		v_cvt_pk_bf16_f32 v45, v198, v200
		v_cvt_pk_bf16_f32 v46, v199, v201
		v_cvt_pk_bf16_f32 v47, v202, v204
		v_permlane32_swap_b32_e32 v160, v162
		v_permlane32_swap_b32_e32 v161, v163
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_mfma_f32_32x32x16_bf16 v[240:255], a[108:111], v[160:163], v[240:255]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_permlane32_swap_b32_e32 v32, v34
		v_permlane32_swap_b32_e32 v33, v35
		v_permlane32_swap_b32_e32 v40, v42
		v_permlane32_swap_b32_e32 v41, v43
		v_permlane32_swap_b32_e32 v44, v46
		v_permlane32_swap_b32_e32 v45, v47
		v_rcp_f32_e32 v6, v36
		v_rcp_f32_e32 v12, v37
		v_mfma_f32_32x32x16_bf16 v[48:63], a[124:127], v[160:163], v[48:63]
		s_mul_i32 s1, s16, s23
		s_lshl_b32 s1, s1, 9
		s_mul_i32 s2, s17, s21
		s_lshl_b32 s2, s2, 1
		s_add_i32 s3, s1, s2
		s_mul_i32 s0, s0, s22
		s_lshl_b32 s0, s0, 1
		v_mfma_f32_32x32x16_bf16 v[64:79], a[140:143], v[160:163], v[64:79]
		s_add_i32 s3, s3, s0
		v_mul_lo_u32 v0, s23, v9
		v_lshlrev_b32_e32 v0, 7, v0
		v_mul_lo_u32 v7, s23, v15
		v_lshlrev_b32_e32 v8, 1, v7
		v_add3_u32 v7, s3, v0, v8
		v_mul_lo_u32 v9, s23, v11
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], v[160:163], v[80:95]
		v_lshlrev_b32_e32 v9, 6, v9
		v_mul_lo_u32 v5, s23, v5
		v_lshlrev_b32_e32 v5, 5, v5
		v_add3_u32 v7, v7, v9, v5
		v_mul_lo_u32 v4, s23, v4
		v_lshlrev_b32_e32 v4, 4, v4
		v_mul_lo_u32 v3, s23, v3
		v_mfma_f32_32x32x16_bf16 v[144:159], a[156:159], v[28:31], v[144:159]
		v_lshlrev_b32_e32 v3, 3, v3
		v_add3_u32 v7, v7, v4, v3
		v_mul_lo_u32 v2, s23, v2
		v_lshlrev_b32_e32 v2, 2, v2
		v_add3_u32 v7, v7, v2, v1
		v_cndmask_b32_e64 v10, v20, v7, s[26:27]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[108:111], v[28:31], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[124:127], v[28:31], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[140:143], v[28:31], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[112:115], v[164:167], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[128:131], v[164:167], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[144:147], v[164:167], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[160:163], v[164:167], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[160:163], v[32:35], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[112:115], v[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[128:131], v[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[144:147], v[32:35], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[116:119], v[16:19], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[132:135], v[16:19], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[148:151], v[16:19], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[164:167], v[16:19], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[164:167], v[40:43], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[116:119], v[40:43], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[132:135], v[40:43], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[148:151], v[40:43], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[120:123], v[24:27], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[136:139], v[24:27], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[152:155], v[24:27], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[168:171], v[24:27], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[168:171], v[44:47], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[120:123], v[44:47], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[136:139], v[44:47], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[152:155], v[44:47], v[128:143]
		s_add_i32 s3, s1, 32
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_add3_u32 v7, s3, v0, v8
		v_add3_u32 v11, v7, v9, v5
		v_mov_b32_e32 v7, v6
		v_pk_mul_f32 v[14:15], v[240:241], v[6:7]
		v_pk_mul_f32 v[16:17], v[242:243], v[6:7]
		v_pk_mul_f32 v[18:19], v[244:245], v[6:7]
		v_pk_mul_f32 v[22:23], v[246:247], v[6:7]
		v_pk_mul_f32 v[24:25], v[248:249], v[6:7]
		v_pk_mul_f32 v[26:27], v[250:251], v[6:7]
		v_pk_mul_f32 v[28:29], v[252:253], v[6:7]
		v_pk_mul_f32 v[30:31], v[254:255], v[6:7]
		v_pk_mul_f32 v[32:33], v[48:49], v[6:7]
		v_pk_mul_f32 v[34:35], v[50:51], v[6:7]
		v_pk_mul_f32 v[36:37], v[52:53], v[6:7]
		v_pk_mul_f32 v[38:39], v[54:55], v[6:7]
		v_pk_mul_f32 v[40:41], v[56:57], v[6:7]
		v_pk_mul_f32 v[42:43], v[58:59], v[6:7]
		v_pk_mul_f32 v[44:45], v[60:61], v[6:7]
		v_pk_mul_f32 v[46:47], v[62:63], v[6:7]
		v_pk_mul_f32 v[48:49], v[64:65], v[6:7]
		v_pk_mul_f32 v[50:51], v[66:67], v[6:7]
		v_pk_mul_f32 v[52:53], v[68:69], v[6:7]
		v_pk_mul_f32 v[54:55], v[70:71], v[6:7]
		v_pk_mul_f32 v[56:57], v[72:73], v[6:7]
		v_pk_mul_f32 v[58:59], v[74:75], v[6:7]
		v_pk_mul_f32 v[60:61], v[76:77], v[6:7]
		v_pk_mul_f32 v[62:63], v[78:79], v[6:7]
		v_pk_mul_f32 v[64:65], v[80:81], v[6:7]
		v_pk_mul_f32 v[66:67], v[82:83], v[6:7]
		v_pk_mul_f32 v[68:69], v[84:85], v[6:7]
		v_pk_mul_f32 v[70:71], v[86:87], v[6:7]
		v_pk_mul_f32 v[72:73], v[88:89], v[6:7]
		v_pk_mul_f32 v[74:75], v[90:91], v[6:7]
		v_pk_mul_f32 v[76:77], v[92:93], v[6:7]
		v_pk_mul_f32 v[78:79], v[94:95], v[6:7]
		v_mov_b32_e32 v13, v12
		v_pk_mul_f32 v[6:7], v[96:97], v[12:13]
		v_pk_mul_f32 v[80:81], v[98:99], v[12:13]
		v_pk_mul_f32 v[82:83], v[100:101], v[12:13]
		v_pk_mul_f32 v[84:85], v[102:103], v[12:13]
		v_pk_mul_f32 v[86:87], v[104:105], v[12:13]
		v_pk_mul_f32 v[88:89], v[106:107], v[12:13]
		v_pk_mul_f32 v[90:91], v[108:109], v[12:13]
		v_pk_mul_f32 v[92:93], v[110:111], v[12:13]
		v_pk_mul_f32 v[94:95], v[112:113], v[12:13]
		v_pk_mul_f32 v[96:97], v[114:115], v[12:13]
		v_pk_mul_f32 v[98:99], v[116:117], v[12:13]
		v_pk_mul_f32 v[100:101], v[118:119], v[12:13]
		v_pk_mul_f32 v[102:103], v[120:121], v[12:13]
		v_pk_mul_f32 v[104:105], v[122:123], v[12:13]
		v_pk_mul_f32 v[106:107], v[124:125], v[12:13]
		v_pk_mul_f32 v[108:109], v[126:127], v[12:13]
		v_pk_mul_f32 v[110:111], v[128:129], v[12:13]
		v_pk_mul_f32 v[112:113], v[130:131], v[12:13]
		v_pk_mul_f32 v[114:115], v[132:133], v[12:13]
		v_pk_mul_f32 v[116:117], v[134:135], v[12:13]
		v_pk_mul_f32 v[118:119], v[136:137], v[12:13]
		v_pk_mul_f32 v[120:121], v[138:139], v[12:13]
		v_pk_mul_f32 v[122:123], v[140:141], v[12:13]
		v_pk_mul_f32 v[124:125], v[142:143], v[12:13]
		v_pk_mul_f32 v[126:127], v[144:145], v[12:13]
		v_pk_mul_f32 v[128:129], v[146:147], v[12:13]
		v_pk_mul_f32 v[130:131], v[148:149], v[12:13]
		v_pk_mul_f32 v[132:133], v[150:151], v[12:13]
		v_pk_mul_f32 v[134:135], v[152:153], v[12:13]
		v_pk_mul_f32 v[136:137], v[154:155], v[12:13]
		v_pk_mul_f32 v[138:139], v[156:157], v[12:13]
		v_pk_mul_f32 v[140:141], v[158:159], v[12:13]
		v_cvt_pk_bf16_f32 v144, v14, v15
		v_cvt_pk_bf16_f32 v145, v16, v17
		v_cvt_pk_bf16_f32 v146, v18, v19
		v_cvt_pk_bf16_f32 v147, v22, v23
		v_cvt_pk_bf16_f32 v12, v24, v25
		v_cvt_pk_bf16_f32 v13, v26, v27
		v_cvt_pk_bf16_f32 v14, v28, v29
		v_cvt_pk_bf16_f32 v15, v30, v31
		v_cvt_pk_bf16_f32 v16, v32, v33
		v_cvt_pk_bf16_f32 v17, v34, v35
		v_cvt_pk_bf16_f32 v18, v36, v37
		v_cvt_pk_bf16_f32 v19, v38, v39
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
		v_cvt_pk_bf16_f32 v40, v72, v73
		v_cvt_pk_bf16_f32 v41, v74, v75
		v_cvt_pk_bf16_f32 v42, v76, v77
		v_cvt_pk_bf16_f32 v43, v78, v79
		v_cvt_pk_bf16_f32 v44, v6, v7
		v_cvt_pk_bf16_f32 v45, v80, v81
		v_cvt_pk_bf16_f32 v46, v82, v83
		v_cvt_pk_bf16_f32 v47, v84, v85
		v_cvt_pk_bf16_f32 v48, v86, v87
		v_cvt_pk_bf16_f32 v49, v88, v89
		v_cvt_pk_bf16_f32 v50, v90, v91
		v_cvt_pk_bf16_f32 v51, v92, v93
		v_cvt_pk_bf16_f32 v52, v94, v95
		v_cvt_pk_bf16_f32 v53, v96, v97
		v_cvt_pk_bf16_f32 v54, v98, v99
		v_cvt_pk_bf16_f32 v55, v100, v101
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
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_permlane32_swap_b32_e32 v12, v14
		v_permlane32_swap_b32_e32 v13, v15
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
		v_permlane32_swap_b32_e32 v40, v42
		v_permlane32_swap_b32_e32 v41, v43
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
		v_permlane32_swap_b32_e32 v68, v70
		v_permlane32_swap_b32_e32 v69, v71
		v_permlane32_swap_b32_e32 v72, v74
		v_permlane32_swap_b32_e32 v73, v75
		s_mov_b32 s4, s8
		s_mov_b32 s5, s9
		s_mov_b32 s6, s34
		s_mov_b32 s7, s35
		buffer_store_dwordx4 v[144:147], v10, s[4:7], 0 offen
		v_add3_u32 v6, v11, v4, v3
		v_add3_u32 v6, v6, v2, v1
		v_cndmask_b32_e64 v6, v20, v6, s[26:27]
		buffer_store_dwordx4 v[12:15], v6, s[4:7], 0 offen
		s_add_i32 s3, s1, 64
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_add3_u32 v6, s3, v0, v8
		v_add3_u32 v6, v6, v9, v5
		v_add3_u32 v6, v6, v4, v3
		v_add3_u32 v6, v6, v2, v1
		v_cndmask_b32_e64 v6, v20, v6, s[26:27]
		buffer_store_dwordx4 v[16:19], v6, s[4:7], 0 offen
		s_add_i32 s3, s1, 0x60
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_add3_u32 v6, s3, v0, v8
		v_add3_u32 v6, v6, v9, v5
		v_add3_u32 v6, v6, v4, v3
		v_add3_u32 v6, v6, v2, v1
		v_cndmask_b32_e64 v6, v20, v6, s[26:27]
		buffer_store_dwordx4 v[24:27], v6, s[4:7], 0 offen
		s_add_i32 s3, s1, 0x80
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_add3_u32 v6, s3, v0, v8
		v_add3_u32 v6, v6, v9, v5
		v_add3_u32 v6, v6, v4, v3
		v_add3_u32 v6, v6, v2, v1
		v_cndmask_b32_e64 v6, v20, v6, s[26:27]
		buffer_store_dwordx4 v[28:31], v6, s[4:7], 0 offen
		s_add_i32 s3, s1, 0xa0
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_add3_u32 v6, s3, v0, v8
		v_add3_u32 v6, v6, v9, v5
		v_add3_u32 v6, v6, v4, v3
		v_add3_u32 v6, v6, v2, v1
		v_cndmask_b32_e64 v6, v20, v6, s[26:27]
		buffer_store_dwordx4 v[32:35], v6, s[4:7], 0 offen
		s_add_i32 s3, s1, 0xc0
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_add3_u32 v6, s3, v0, v8
		v_add3_u32 v6, v6, v9, v5
		v_add3_u32 v6, v6, v4, v3
		v_add3_u32 v6, v6, v2, v1
		v_cndmask_b32_e64 v6, v20, v6, s[26:27]
		buffer_store_dwordx4 v[36:39], v6, s[4:7], 0 offen
		s_add_i32 s3, s1, 0xe0
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_add3_u32 v6, s3, v0, v8
		v_add3_u32 v6, v6, v9, v5
		v_add3_u32 v6, v6, v4, v3
		v_add3_u32 v6, v6, v2, v1
		v_cndmask_b32_e64 v6, v20, v6, s[26:27]
		buffer_store_dwordx4 v[40:43], v6, s[4:7], 0 offen
		s_lshl_b32 s3, s23, 8
		s_add_i32 s8, s3, s1
		s_add_i32 s8, s8, s2
		s_add_i32 s8, s8, s0
		v_add3_u32 v6, s8, v0, v8
		v_add3_u32 v6, v6, v9, v5
		v_add3_u32 v6, v6, v4, v3
		v_add3_u32 v6, v6, v2, v1
		v_cndmask_b32_e64 v6, v20, v6, s[28:29]
		buffer_store_dwordx4 v[44:47], v6, s[4:7], 0 offen
		s_add_i32 s8, s3, 32
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s2
		s_add_i32 s8, s8, s0
		v_add3_u32 v6, s8, v0, v8
		v_add3_u32 v6, v6, v9, v5
		v_add3_u32 v6, v6, v4, v3
		v_add3_u32 v6, v6, v2, v1
		v_cndmask_b32_e64 v6, v20, v6, s[28:29]
		buffer_store_dwordx4 v[48:51], v6, s[4:7], 0 offen
		s_add_i32 s8, s3, 64
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s2
		s_add_i32 s8, s8, s0
		v_add3_u32 v6, s8, v0, v8
		v_add3_u32 v6, v6, v9, v5
		v_add3_u32 v6, v6, v4, v3
		v_add3_u32 v6, v6, v2, v1
		v_cndmask_b32_e64 v6, v20, v6, s[28:29]
		buffer_store_dwordx4 v[52:55], v6, s[4:7], 0 offen
		s_add_i32 s8, s3, 0x60
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s2
		s_add_i32 s8, s8, s0
		v_add3_u32 v6, s8, v0, v8
		v_add3_u32 v6, v6, v9, v5
		v_add3_u32 v6, v6, v4, v3
		v_add3_u32 v6, v6, v2, v1
		v_cndmask_b32_e64 v6, v20, v6, s[28:29]
		buffer_store_dwordx4 v[56:59], v6, s[4:7], 0 offen
		s_add_i32 s8, s3, 0x80
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s2
		s_add_i32 s8, s8, s0
		v_add3_u32 v6, s8, v0, v8
		v_add3_u32 v6, v6, v9, v5
		v_add3_u32 v6, v6, v4, v3
		v_add3_u32 v6, v6, v2, v1
		v_cndmask_b32_e64 v6, v20, v6, s[28:29]
		buffer_store_dwordx4 v[60:63], v6, s[4:7], 0 offen
		s_add_i32 s8, s3, 0xa0
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s2
		s_add_i32 s8, s8, s0
		v_add3_u32 v6, s8, v0, v8
		v_add3_u32 v6, v6, v9, v5
		v_add3_u32 v6, v6, v4, v3
		v_add3_u32 v6, v6, v2, v1
		v_cndmask_b32_e64 v6, v20, v6, s[28:29]
		buffer_store_dwordx4 v[64:67], v6, s[4:7], 0 offen
		s_add_i32 s8, s3, 0xc0
		s_add_i32 s8, s8, s1
		s_add_i32 s8, s8, s2
		s_add_i32 s8, s8, s0
		v_add3_u32 v6, s8, v0, v8
		v_add3_u32 v6, v6, v9, v5
		v_add3_u32 v6, v6, v4, v3
		v_add3_u32 v6, v6, v2, v1
		v_cndmask_b32_e64 v6, v20, v6, s[28:29]
		buffer_store_dwordx4 v[68:71], v6, s[4:7], 0 offen
		s_add_i32 s3, s3, 0xe0
		s_add_i32 s1, s3, s1
		s_add_i32 s1, s1, s2
		s_add_i32 s0, s1, s0
		v_add3_u32 v0, s0, v0, v8
		v_add3_u32 v0, v0, v9, v5
		v_add3_u32 v0, v0, v4, v3
		v_add3_u32 v0, v0, v2, v1
		v_cndmask_b32_e64 v0, v20, v0, s[28:29]
		buffer_store_dwordx4 v[72:75], v0, s[4:7], 0 offen
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
		.amdhsa_next_free_vgpr 436
		.amdhsa_next_free_sgpr 82
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
	.set .L_attn_fwd_async_prefetch.num_agpr, 180
	.set .L_attn_fwd_async_prefetch.numbered_sgpr, 82
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
    .sgpr_count:     82
    .sgpr_spill_count: 0
    .symbol:         _attn_fwd_async_prefetch.kd
    .uses_dynamic_stack: false
    .vgpr_count:     436
    .agpr_count:     180
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 72
    wave.regalloc.agpr.dwords: 282
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
