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
		s_add_i32 m0, s13, 0x1040
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
		v_mov_b32_e32 v38, 1.0
		v_mov_b32_e32 v39, 1.0
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
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a64, v40
		v_accvgpr_write_b32 a65, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a66, v40
		v_accvgpr_write_b32 a67, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a68, v40
		v_accvgpr_write_b32 a69, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a70, v40
		v_accvgpr_write_b32 a71, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a72, v40
		v_accvgpr_write_b32 a73, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a74, v40
		v_accvgpr_write_b32 a75, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a76, v40
		v_accvgpr_write_b32 a77, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a78, v40
		v_accvgpr_write_b32 a79, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a80, v40
		v_accvgpr_write_b32 a81, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a82, v40
		v_accvgpr_write_b32 a83, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a84, v40
		v_accvgpr_write_b32 a85, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a86, v40
		v_accvgpr_write_b32 a87, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a88, v40
		v_accvgpr_write_b32 a89, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a90, v40
		v_accvgpr_write_b32 a91, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a92, v40
		v_accvgpr_write_b32 a93, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a94, v40
		v_accvgpr_write_b32 a95, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a96, v40
		v_accvgpr_write_b32 a97, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a98, v40
		v_accvgpr_write_b32 a99, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a100, v40
		v_accvgpr_write_b32 a101, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a102, v40
		v_accvgpr_write_b32 a103, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a104, v40
		v_accvgpr_write_b32 a105, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a106, v40
		v_accvgpr_write_b32 a107, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a108, v40
		v_accvgpr_write_b32 a109, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a110, v40
		v_accvgpr_write_b32 a111, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a112, v40
		v_accvgpr_write_b32 a113, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a114, v40
		v_accvgpr_write_b32 a115, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a116, v40
		v_accvgpr_write_b32 a117, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a118, v40
		v_accvgpr_write_b32 a119, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a120, v40
		v_accvgpr_write_b32 a121, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a122, v40
		v_accvgpr_write_b32 a123, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a124, v40
		v_accvgpr_write_b32 a125, v41
		v_mov_b64_e32 v[40:41], 0
		v_accvgpr_write_b32 a126, v40
		v_accvgpr_write_b32 a127, v41
		s_cbranch_scc0 .L_attn_fwd_async_prefetch.loop_exit_0
.L_attn_fwd_async_prefetch.loop_head_0:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s3, s4, 64
		v_add_u32_e32 v40, s3, v1
		s_lshr_b32 s18, s4, 6
		s_and_b32 s30, s18, 1
		s_mul_i32 s31, 0x4100, s30
		v_add3_u32 v41, s31, v24, v28
		v_add3_u32 v41, v41, v30, v31
		v_add3_u32 v41, v41, v32, v29
		ds_read_b128 v[44:47], v41
		ds_read_b128 v[112:115], v41 offset:32
		ds_read_b128 v[116:119], v41 offset:64
		ds_read_b128 v[120:123], v41 offset:96
		ds_read_b128 v[124:127], v41 offset:128
		ds_read_b128 v[128:131], v41 offset:160
		ds_read_b128 v[132:135], v41 offset:192
		ds_read_b128 v[136:139], v41 offset:224
		ds_read_b128 v[140:143], v41 offset:512
		ds_read_b128 v[144:147], v41 offset:544
		ds_read_b128 v[148:151], v41 offset:576
		ds_read_b128 v[152:155], v41 offset:608
		ds_read_b128 v[156:159], v41 offset:640
		ds_read_b128 v[160:163], v41 offset:672
		ds_read_b128 v[164:167], v41 offset:704
		ds_read_b128 v[168:171], v41 offset:736
		s_mul_i32 s30, 0x4400, s30
		v_add3_u32 v41, s30, v25, v33
		v_add3_u32 v41, v41, v35, v34
		ds_read_b64_tr_b16 v[172:173], v41 offset:33264
		ds_read_b64_tr_b16 v[174:175], v41 offset:37616
		ds_read_b64_tr_b16 a[128:129], v41 offset:33520
		ds_read_b64_tr_b16 a[130:131], v41 offset:37872
		ds_read_b64_tr_b16 a[132:133], v41 offset:33776
		ds_read_b64_tr_b16 a[134:135], v41 offset:38128
		ds_read_b64_tr_b16 a[136:137], v41 offset:34032
		ds_read_b64_tr_b16 a[138:139], v41 offset:38384
		ds_read_b64_tr_b16 v[176:177], v41 offset:33328
		ds_read_b64_tr_b16 v[178:179], v41 offset:37680
		ds_read_b64_tr_b16 a[140:141], v41 offset:33584
		ds_read_b64_tr_b16 a[142:143], v41 offset:37936
		ds_read_b64_tr_b16 a[144:145], v41 offset:33840
		ds_read_b64_tr_b16 a[146:147], v41 offset:38192
		ds_read_b64_tr_b16 a[148:149], v41 offset:34096
		ds_read_b64_tr_b16 a[150:151], v41 offset:38448
		ds_read_b64_tr_b16 v[180:181], v41 offset:33392
		ds_read_b64_tr_b16 v[182:183], v41 offset:37744
		ds_read_b64_tr_b16 a[152:153], v41 offset:33648
		ds_read_b64_tr_b16 a[154:155], v41 offset:38000
		ds_read_b64_tr_b16 a[156:157], v41 offset:33904
		ds_read_b64_tr_b16 a[158:159], v41 offset:38256
		ds_read_b64_tr_b16 a[160:161], v41 offset:34160
		ds_read_b64_tr_b16 a[162:163], v41 offset:38512
		ds_read_b64_tr_b16 v[184:185], v41 offset:33456
		ds_read_b64_tr_b16 v[186:187], v41 offset:37808
		ds_read_b64_tr_b16 a[164:165], v41 offset:33712
		ds_read_b64_tr_b16 a[166:167], v41 offset:38064
		ds_read_b64_tr_b16 a[168:169], v41 offset:33968
		ds_read_b64_tr_b16 a[170:171], v41 offset:38320
		ds_read_b64_tr_b16 a[172:173], v41 offset:34224
		ds_read_b64_tr_b16 a[174:175], v41 offset:38576
		v_cmp_lt_i32_e64 vcc, v40, s25
		v_add_u32_e32 v40, s3, v6
		v_add_u32_e32 v41, s3, v7
		v_cndmask_b32_e32 v42, v21, v36, vcc
		v_add_u32_e32 v43, s4, v14
		v_add_u32_e32 v42, v42, v43
		v_add_u32_e32 v188, 1, v43
		v_cmp_eq_u32_e64 vcc, v42, v188
		s_mov_b64 s[30:31], vcc
		v_cmp_lt_i32_e64 vcc, v40, s25
		v_add_u32_e32 v40, s3, v8
		s_add_i32 s18, s18, 1
		v_cndmask_b32_e32 v42, v21, v36, vcc
		v_add_u32_e32 v42, v42, v43
		v_cmp_eq_u32_e64 vcc, v42, v188
		s_mov_b64 s[40:41], vcc
		v_cmp_lt_i32_e64 vcc, v41, s25
		s_and_b32 s18, s18, 1
		s_mul_i32 s42, s15, s4
		v_cndmask_b32_e32 v41, v21, v36, vcc
		v_add_u32_e32 v41, v41, v43
		v_cmp_eq_u32_e64 vcc, v41, v188
		s_mov_b64 s[44:45], vcc
		v_cmp_lt_i32_e64 vcc, v40, s25
		s_lshl_b32 s42, s42, 1
		s_add_i32 s43, s5, s42
		v_cndmask_b32_e32 v40, v21, v36, vcc
		v_add_u32_e32 v40, v40, v43
		v_cmp_eq_u32_e64 vcc, v40, v188
		v_add_u32_e32 v40, s43, v0
		s_mul_i32 s43, 0x4100, s18
		s_add_i32 s43, s13, s43
		s_mov_b32 m0, s43
		v_cndmask_b32_e64 v40, v20, v40, s[30:31]
		buffer_load_dwordx4 v40, s[32:35], 0 offen lds
		v_add_u32_e32 v40, s42, v0
		v_add_u32_e32 v41, s6, v40
		s_add_i32 m0, s43, 0x1040
		v_cndmask_b32_e64 v41, v20, v41, s[40:41]
		buffer_load_dwordx4 v41, s[32:35], 0 offen lds
		v_add_u32_e32 v41, s7, v40
		s_add_i32 m0, s43, 0x2080
		v_cndmask_b32_e64 v41, v20, v41, s[44:45]
		buffer_load_dwordx4 v41, s[32:35], 0 offen lds
		v_add_u32_e32 v40, s11, v40
		v_cndmask_b32_e32 v40, v20, v40, vcc
		s_add_i32 m0, s43, 0x30c0
		s_mul_i32 s4, s20, s4
		buffer_load_dwordx4 v40, s[32:35], 0 offen lds
		s_lshl_b32 s4, s4, 1
		s_add_i32 s42, s12, s4
		v_add_u32_e32 v40, s42, v10
		s_mul_i32 s18, 0x4400, s18
		s_add_i32 s18, s10, s18
		s_add_i32 m0, s18, 0x81f0
		v_cndmask_b32_e64 v40, v20, v40, s[30:31]
		buffer_load_dwordx4 v40, s[36:39], 0 offen lds
		v_add_u32_e32 v40, s4, v10
		v_add_u32_e32 v41, s19, v40
		s_add_i32 m0, s18, 0x92f0
		v_cndmask_b32_e64 v41, v20, v41, s[40:41]
		buffer_load_dwordx4 v41, s[36:39], 0 offen lds
		v_add_u32_e32 v41, s24, v40
		s_add_i32 m0, s18, 0xa3f0
		v_cndmask_b32_e64 v41, v20, v41, s[44:45]
		buffer_load_dwordx4 v41, s[36:39], 0 offen lds
		v_add_u32_e32 v40, s14, v40
		v_cndmask_b32_e32 v40, v20, v40, vcc
		s_add_i32 m0, s18, 0xb4f0
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[192:207], v[44:47], a[0:3], 0
		v_mfma_f32_32x32x16_bf16 v[208:223], v[140:143], a[0:3], 0
		v_mfma_f32_32x32x16_bf16 v[224:239], v[140:143], a[32:35], 0
		v_mfma_f32_32x32x16_bf16 v[240:255], v[44:47], a[32:35], 0
		v_mfma_f32_32x32x16_bf16 v[192:207], v[112:115], a[4:7], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[144:147], a[4:7], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[144:147], a[36:39], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[112:115], a[36:39], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[116:119], a[8:11], v[192:207]
		buffer_load_dwordx4 v40, s[36:39], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[208:223], v[148:151], a[8:11], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[148:151], a[40:43], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[116:119], a[40:43], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[120:123], a[12:15], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[152:155], a[12:15], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[152:155], a[44:47], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[120:123], a[44:47], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[124:127], a[16:19], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[156:159], a[16:19], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[156:159], a[48:51], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[124:127], a[48:51], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[128:131], a[20:23], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[160:163], a[20:23], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[160:163], a[52:55], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[128:131], a[52:55], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[132:135], a[24:27], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[164:167], a[24:27], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[164:167], a[56:59], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[132:135], a[56:59], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[136:139], a[28:31], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[168:171], a[28:31], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[168:171], a[60:63], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[136:139], a[60:63], v[240:255]
		s_cmp_lt_i32 s3, s2
		s_nop 7
		v_max_f32_e32 v40, v192, v193
		v_max_f32_e32 v41, v194, v195
		v_max_f32_e32 v42, v196, v197
		v_max_f32_e32 v43, v198, v199
		v_max_f32_e32 v44, v200, v201
		v_max_f32_e32 v45, v202, v203
		v_max_f32_e32 v46, v204, v205
		v_max_f32_e32 v47, v206, v207
		v_max_f32_e32 v112, v208, v209
		v_max_f32_e32 v113, v210, v211
		v_max_f32_e32 v114, v212, v213
		v_max_f32_e32 v115, v214, v215
		v_max_f32_e32 v116, v216, v217
		v_max_f32_e32 v117, v218, v219
		v_max_f32_e32 v118, v220, v221
		v_max_f32_e32 v119, v222, v223
		v_max_f32_e32 v40, v40, v41
		v_max_f32_e32 v41, v42, v43
		v_max_f32_e32 v42, v44, v45
		v_max_f32_e32 v43, v46, v47
		v_max_f32_e32 v44, v112, v113
		v_max_f32_e32 v45, v114, v115
		v_max_f32_e32 v46, v116, v117
		v_max_f32_e32 v47, v118, v119
		v_max_f32_e32 v40, v40, v41
		v_max_f32_e32 v41, v42, v43
		v_max_f32_e32 v42, v44, v45
		v_max_f32_e32 v43, v46, v47
		v_max_f32_e32 v40, v40, v41
		v_max_f32_e32 v41, v42, v43
		v_max_f32_e32 v40, v40, v41
		ds_bpermute_b32 v41, v22, v40
		ds_bpermute_b32 v42, v16, v40
		v_max_f32_e32 v40, v240, v241
		v_max_f32_e32 v43, v242, v243
		v_max_f32_e32 v44, v244, v245
		v_max_f32_e32 v45, v246, v247
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v46, v41, v42
		v_max_f32_e32 v41, v248, v249
		v_max_f32_e32 v42, v250, v251
		v_max_f32_e32 v47, v252, v253
		v_max_f32_e32 v112, v254, v255
		v_max_f32_e32 v113, v224, v225
		v_max_f32_e32 v114, v226, v227
		v_max_f32_e32 v115, v228, v229
		v_max_f32_e32 v116, v230, v231
		v_max_f32_e32 v117, v232, v233
		v_max_f32_e32 v118, v234, v235
		v_max_f32_e32 v119, v236, v237
		v_max_f32_e32 v120, v238, v239
		v_max_f32_e32 v40, v40, v43
		v_max_f32_e32 v43, v44, v45
		v_max_f32_e32 v41, v41, v42
		v_max_f32_e32 v42, v47, v112
		v_max_f32_e32 v44, v113, v114
		v_max_f32_e32 v45, v115, v116
		v_max_f32_e32 v47, v117, v118
		v_max_f32_e32 v112, v119, v120
		v_max_f32_e32 v40, v40, v43
		v_max_f32_e32 v41, v41, v42
		v_max_f32_e32 v42, v44, v45
		v_max_f32_e32 v43, v47, v112
		v_max_f32_e32 v40, v40, v41
		v_max_f32_e32 v41, v42, v43
		v_max_f32_e32 v40, v40, v41
		ds_bpermute_b32 v41, v22, v40
		ds_bpermute_b32 v42, v16, v40
		v_pk_mul_f32 v[44:45], v[192:193], v[18:19]
		v_pk_mul_f32 v[112:113], v[194:195], v[18:19]
		v_pk_mul_f32 v[114:115], v[196:197], v[18:19]
		v_pk_mul_f32 v[116:117], v[198:199], v[18:19]
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v47, v41, v42
		v_pk_mul_f32 v[40:41], v[46:47], v[18:19]
		v_max_f32_e32 v40, v23, v40
		v_max_f32_e32 v41, v37, v41
		v_pk_mul_f32 v[42:43], v[200:201], v[18:19]
		v_pk_mul_f32 v[46:47], v[202:203], v[18:19]
		v_pk_mul_f32 v[118:119], v[204:205], v[18:19]
		v_pk_mul_f32 v[120:121], v[206:207], v[18:19]
		v_pk_mul_f32 v[122:123], v[208:209], v[18:19]
		v_pk_mul_f32 v[124:125], v[210:211], v[18:19]
		v_pk_mul_f32 v[126:127], v[212:213], v[18:19]
		v_pk_mul_f32 v[128:129], v[214:215], v[18:19]
		v_pk_mul_f32 v[130:131], v[216:217], v[18:19]
		v_pk_mul_f32 v[132:133], v[218:219], v[18:19]
		v_pk_mul_f32 v[134:135], v[220:221], v[18:19]
		v_pk_mul_f32 v[136:137], v[222:223], v[18:19]
		v_pk_mul_f32 v[138:139], v[240:241], v[18:19]
		v_pk_mul_f32 v[140:141], v[242:243], v[18:19]
		v_pk_mul_f32 v[142:143], v[244:245], v[18:19]
		v_pk_mul_f32 v[144:145], v[246:247], v[18:19]
		v_pk_mul_f32 v[146:147], v[248:249], v[18:19]
		v_pk_mul_f32 v[148:149], v[250:251], v[18:19]
		v_pk_mul_f32 v[150:151], v[252:253], v[18:19]
		v_pk_mul_f32 v[152:153], v[254:255], v[18:19]
		v_pk_mul_f32 v[154:155], v[224:225], v[18:19]
		v_pk_mul_f32 v[156:157], v[226:227], v[18:19]
		v_pk_mul_f32 v[158:159], v[228:229], v[18:19]
		v_pk_mul_f32 v[160:161], v[230:231], v[18:19]
		v_pk_mul_f32 v[162:163], v[232:233], v[18:19]
		v_pk_mul_f32 v[164:165], v[234:235], v[18:19]
		v_pk_mul_f32 v[166:167], v[236:237], v[18:19]
		v_pk_mul_f32 v[168:169], v[238:239], v[18:19]
		v_sub_f32_e32 v44, v44, v40
		v_sub_f32_e32 v45, v45, v40
		v_sub_f32_e32 v112, v112, v40
		v_sub_f32_e32 v113, v113, v40
		v_sub_f32_e32 v114, v114, v40
		v_sub_f32_e32 v115, v115, v40
		v_sub_f32_e32 v116, v116, v40
		v_sub_f32_e32 v117, v117, v40
		v_sub_f32_e32 v42, v42, v40
		v_sub_f32_e32 v43, v43, v40
		v_sub_f32_e32 v46, v46, v40
		v_sub_f32_e32 v47, v47, v40
		v_sub_f32_e32 v118, v118, v40
		v_sub_f32_e32 v119, v119, v40
		v_sub_f32_e32 v120, v120, v40
		v_sub_f32_e32 v121, v121, v40
		v_sub_f32_e32 v122, v122, v40
		v_sub_f32_e32 v123, v123, v40
		v_sub_f32_e32 v124, v124, v40
		v_sub_f32_e32 v125, v125, v40
		v_sub_f32_e32 v126, v126, v40
		v_sub_f32_e32 v127, v127, v40
		v_sub_f32_e32 v128, v128, v40
		v_sub_f32_e32 v129, v129, v40
		v_sub_f32_e32 v130, v130, v40
		v_sub_f32_e32 v131, v131, v40
		v_sub_f32_e32 v132, v132, v40
		v_sub_f32_e32 v133, v133, v40
		v_sub_f32_e32 v134, v134, v40
		v_sub_f32_e32 v135, v135, v40
		v_sub_f32_e32 v136, v136, v40
		v_sub_f32_e32 v137, v137, v40
		v_sub_f32_e32 v138, v138, v41
		v_sub_f32_e32 v139, v139, v41
		v_sub_f32_e32 v140, v140, v41
		v_sub_f32_e32 v141, v141, v41
		v_sub_f32_e32 v142, v142, v41
		v_sub_f32_e32 v143, v143, v41
		v_sub_f32_e32 v144, v144, v41
		v_sub_f32_e32 v145, v145, v41
		v_sub_f32_e32 v146, v146, v41
		v_sub_f32_e32 v147, v147, v41
		v_sub_f32_e32 v148, v148, v41
		v_sub_f32_e32 v149, v149, v41
		v_sub_f32_e32 v150, v150, v41
		v_sub_f32_e32 v151, v151, v41
		v_sub_f32_e32 v152, v152, v41
		v_sub_f32_e32 v153, v153, v41
		v_sub_f32_e32 v154, v154, v41
		v_sub_f32_e32 v155, v155, v41
		v_sub_f32_e32 v156, v156, v41
		v_sub_f32_e32 v157, v157, v41
		v_sub_f32_e32 v158, v158, v41
		v_sub_f32_e32 v159, v159, v41
		v_sub_f32_e32 v160, v160, v41
		v_sub_f32_e32 v161, v161, v41
		v_sub_f32_e32 v162, v162, v41
		v_sub_f32_e32 v163, v163, v41
		v_sub_f32_e32 v164, v164, v41
		v_sub_f32_e32 v165, v165, v41
		v_sub_f32_e32 v166, v166, v41
		v_sub_f32_e32 v167, v167, v41
		v_sub_f32_e32 v168, v168, v41
		v_sub_f32_e32 v169, v169, v41
		v_exp_f32_e32 v170, v44
		v_exp_f32_e32 v188, v45
		v_exp_f32_e32 v171, v112
		v_exp_f32_e32 v189, v113
		v_exp_f32_e32 v44, v114
		v_exp_f32_e32 v112, v115
		v_exp_f32_e32 v45, v116
		v_exp_f32_e32 v113, v117
		v_exp_f32_e32 v114, v42
		v_exp_f32_e32 v116, v43
		v_exp_f32_e32 v115, v46
		v_exp_f32_e32 v117, v47
		v_exp_f32_e32 v42, v118
		v_exp_f32_e32 v46, v119
		v_exp_f32_e32 v43, v120
		v_exp_f32_e32 v47, v121
		v_exp_f32_e32 v118, v122
		v_exp_f32_e32 v120, v123
		v_exp_f32_e32 v119, v124
		v_exp_f32_e32 v121, v125
		v_exp_f32_e32 v122, v126
		v_exp_f32_e32 v124, v127
		v_exp_f32_e32 v123, v128
		v_exp_f32_e32 v125, v129
		v_exp_f32_e32 v126, v130
		v_exp_f32_e32 v128, v131
		v_exp_f32_e32 v127, v132
		v_exp_f32_e32 v129, v133
		v_exp_f32_e32 v130, v134
		v_exp_f32_e32 v132, v135
		v_exp_f32_e32 v131, v136
		v_exp_f32_e32 v133, v137
		v_exp_f32_e32 v135, v138
		v_exp_f32_e32 v137, v139
		v_exp_f32_e32 v138, v140
		v_exp_f32_e32 v190, v141
		v_exp_f32_e32 v139, v142
		v_exp_f32_e32 v191, v143
		v_exp_f32_e32 v140, v144
		v_exp_f32_e32 v142, v145
		v_exp_f32_e32 v141, v146
		v_exp_f32_e32 v143, v147
		v_exp_f32_e32 v144, v148
		v_exp_f32_e32 v146, v149
		v_exp_f32_e32 v145, v150
		v_exp_f32_e32 v147, v151
		v_exp_f32_e32 v148, v152
		v_exp_f32_e32 v150, v153
		v_exp_f32_e32 v149, v154
		v_exp_f32_e32 v151, v155
		v_exp_f32_e32 v152, v156
		v_exp_f32_e32 v154, v157
		v_exp_f32_e32 v153, v158
		v_exp_f32_e32 v155, v159
		v_exp_f32_e32 v156, v160
		v_exp_f32_e32 v158, v161
		v_exp_f32_e32 v157, v162
		v_exp_f32_e32 v159, v163
		v_exp_f32_e32 v160, v164
		v_exp_f32_e32 v162, v165
		v_exp_f32_e32 v161, v166
		v_exp_f32_e32 v163, v167
		v_exp_f32_e32 v164, v168
		v_exp_f32_e32 v166, v169
		v_pk_add_f32 v[168:169], v[170:171], v[188:189]
		v_pk_add_f32 v[192:193], v[44:45], v[112:113]
		v_pk_add_f32 v[194:195], v[114:115], v[116:117]
		v_pk_add_f32 v[196:197], v[42:43], v[46:47]
		v_pk_add_f32 v[198:199], v[118:119], v[120:121]
		v_pk_add_f32 v[200:201], v[122:123], v[124:125]
		v_pk_add_f32 v[202:203], v[126:127], v[128:129]
		v_pk_add_f32 v[204:205], v[130:131], v[132:133]
		v_mov_b32_e32 v206, v169
		v_mov_b32_e32 v207, v193
		v_mov_b32_e32 v208, v168
		v_mov_b32_e32 v209, v192
		v_pk_add_f32 v[168:169], v[208:209], v[206:207]
		v_mov_b32_e32 v192, v195
		v_mov_b32_e32 v193, v197
		v_mov_b32_e32 v206, v194
		v_mov_b32_e32 v207, v196
		v_pk_add_f32 v[194:195], v[206:207], v[192:193]
		v_mov_b32_e32 v192, v199
		v_mov_b32_e32 v193, v201
		v_mov_b32_e32 v196, v198
		v_mov_b32_e32 v197, v200
		v_pk_add_f32 v[198:199], v[196:197], v[192:193]
		v_mov_b32_e32 v192, v203
		v_mov_b32_e32 v193, v205
		v_mov_b32_e32 v196, v202
		v_mov_b32_e32 v197, v204
		v_pk_add_f32 v[200:201], v[196:197], v[192:193]
		v_mov_b32_e32 v192, v169
		v_mov_b32_e32 v193, v195
		v_mov_b32_e32 v196, v168
		v_mov_b32_e32 v197, v194
		v_pk_add_f32 v[168:169], v[196:197], v[192:193]
		v_mov_b32_e32 v192, v199
		v_mov_b32_e32 v193, v201
		v_mov_b32_e32 v194, v198
		v_mov_b32_e32 v195, v200
		v_pk_add_f32 v[196:197], v[194:195], v[192:193]
		v_mov_b32_e32 v192, v169
		v_mov_b32_e32 v193, v197
		v_mov_b32_e32 v194, v168
		v_mov_b32_e32 v195, v196
		v_pk_add_f32 v[168:169], v[194:195], v[192:193]
		v_add_f32_e32 v165, v168, v169
		ds_bpermute_b32 v134, v22, v165
		ds_bpermute_b32 v136, v16, v165
		v_pk_add_f32 v[168:169], v[138:139], v[190:191]
		v_pk_add_f32 v[192:193], v[140:141], v[142:143]
		v_pk_add_f32 v[194:195], v[144:145], v[146:147]
		v_pk_add_f32 v[196:197], v[148:149], v[150:151]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[198:199], v[134:135], v[136:137]
		v_pk_add_f32 v[200:201], v[152:153], v[154:155]
		v_pk_add_f32 v[202:203], v[156:157], v[158:159]
		v_pk_add_f32 v[204:205], v[160:161], v[162:163]
		v_mov_b32_e32 v165, v199
		v_mov_b32_e32 v167, v168
		v_pk_add_f32 v[206:207], v[164:165], v[166:167]
		v_mov_b32_e32 v208, v169
		v_mov_b32_e32 v209, v194
		v_pk_add_f32 v[168:169], v[208:209], v[192:193]
		v_mov_b32_e32 v192, v195
		v_mov_b32_e32 v193, v200
		v_pk_add_f32 v[192:193], v[192:193], v[196:197]
		v_mov_b32_e32 v194, v201
		v_mov_b32_e32 v195, v204
		v_pk_add_f32 v[196:197], v[194:195], v[202:203]
		v_mov_b32_e32 v194, v205
		v_mov_b32_e32 v195, v168
		v_pk_add_f32 v[194:195], v[194:195], v[206:207]
		v_mov_b32_e32 v200, v169
		v_mov_b32_e32 v201, v196
		v_pk_add_f32 v[168:169], v[200:201], v[192:193]
		v_mov_b32_e32 v192, v197
		v_mov_b32_e32 v193, v168
		v_pk_add_f32 v[196:197], v[192:193], v[194:195]
		v_add_f32_e32 v134, v169, v196
		v_add_f32_e32 v134, v197, v134
		ds_bpermute_b32 v136, v22, v134
		ds_bpermute_b32 v165, v16, v134
		v_sub_f32_e32 v23, v23, v40
		v_sub_f32_e32 v37, v37, v41
		v_exp_f32_e32 v168, v23
		v_exp_f32_e32 v192, v37
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v195, v136, v165
		v_mov_b32_e32 v169, v168
		v_pk_mul_f32 v[48:49], v[48:49], v[168:169]
		v_pk_mul_f32 v[50:51], v[50:51], v[168:169]
		v_pk_mul_f32 v[52:53], v[52:53], v[168:169]
		v_pk_mul_f32 v[54:55], v[54:55], v[168:169]
		v_pk_mul_f32 v[56:57], v[56:57], v[168:169]
		v_pk_mul_f32 v[58:59], v[58:59], v[168:169]
		v_pk_mul_f32 v[60:61], v[60:61], v[168:169]
		v_pk_mul_f32 v[62:63], v[62:63], v[168:169]
		v_pk_mul_f32 v[64:65], v[64:65], v[168:169]
		v_pk_mul_f32 v[66:67], v[66:67], v[168:169]
		v_pk_mul_f32 v[68:69], v[68:69], v[168:169]
		v_pk_mul_f32 v[70:71], v[70:71], v[168:169]
		v_pk_mul_f32 v[72:73], v[72:73], v[168:169]
		v_pk_mul_f32 v[74:75], v[74:75], v[168:169]
		v_pk_mul_f32 v[76:77], v[76:77], v[168:169]
		v_pk_mul_f32 v[78:79], v[78:79], v[168:169]
		v_pk_mul_f32 v[80:81], v[80:81], v[168:169]
		v_pk_mul_f32 v[82:83], v[82:83], v[168:169]
		v_pk_mul_f32 v[84:85], v[84:85], v[168:169]
		v_pk_mul_f32 v[86:87], v[86:87], v[168:169]
		v_pk_mul_f32 v[88:89], v[88:89], v[168:169]
		v_pk_mul_f32 v[90:91], v[90:91], v[168:169]
		v_pk_mul_f32 v[92:93], v[92:93], v[168:169]
		v_pk_mul_f32 v[94:95], v[94:95], v[168:169]
		v_pk_mul_f32 v[96:97], v[96:97], v[168:169]
		v_pk_mul_f32 v[98:99], v[98:99], v[168:169]
		v_pk_mul_f32 v[100:101], v[100:101], v[168:169]
		v_pk_mul_f32 v[102:103], v[102:103], v[168:169]
		v_pk_mul_f32 v[104:105], v[104:105], v[168:169]
		v_pk_mul_f32 v[106:107], v[106:107], v[168:169]
		v_pk_mul_f32 v[108:109], v[108:109], v[168:169]
		v_pk_mul_f32 v[110:111], v[110:111], v[168:169]
		v_mov_b32_e32 v193, v192
		v_accvgpr_read_b32 v196, a64
		v_accvgpr_read_b32 v197, a65
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a64, v196
		v_accvgpr_write_b32 a65, v197
		v_accvgpr_read_b32 v196, a66
		v_accvgpr_read_b32 v197, a67
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a66, v196
		v_accvgpr_write_b32 a67, v197
		v_accvgpr_read_b32 v196, a68
		v_accvgpr_read_b32 v197, a69
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a68, v196
		v_accvgpr_write_b32 a69, v197
		v_accvgpr_read_b32 v196, a70
		v_accvgpr_read_b32 v197, a71
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a70, v196
		v_accvgpr_write_b32 a71, v197
		v_accvgpr_read_b32 v196, a72
		v_accvgpr_read_b32 v197, a73
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a72, v196
		v_accvgpr_write_b32 a73, v197
		v_accvgpr_read_b32 v196, a74
		v_accvgpr_read_b32 v197, a75
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a74, v196
		v_accvgpr_write_b32 a75, v197
		v_accvgpr_read_b32 v196, a76
		v_accvgpr_read_b32 v197, a77
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a76, v196
		v_accvgpr_write_b32 a77, v197
		v_accvgpr_read_b32 v196, a78
		v_accvgpr_read_b32 v197, a79
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a78, v196
		v_accvgpr_write_b32 a79, v197
		v_accvgpr_read_b32 v196, a80
		v_accvgpr_read_b32 v197, a81
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a80, v196
		v_accvgpr_write_b32 a81, v197
		v_accvgpr_read_b32 v196, a82
		v_accvgpr_read_b32 v197, a83
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a82, v196
		v_accvgpr_write_b32 a83, v197
		v_accvgpr_read_b32 v196, a84
		v_accvgpr_read_b32 v197, a85
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a84, v196
		v_accvgpr_write_b32 a85, v197
		v_accvgpr_read_b32 v196, a86
		v_accvgpr_read_b32 v197, a87
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a86, v196
		v_accvgpr_write_b32 a87, v197
		v_accvgpr_read_b32 v196, a88
		v_accvgpr_read_b32 v197, a89
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a88, v196
		v_accvgpr_write_b32 a89, v197
		v_accvgpr_read_b32 v196, a90
		v_accvgpr_read_b32 v197, a91
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a90, v196
		v_accvgpr_write_b32 a91, v197
		v_accvgpr_read_b32 v196, a92
		v_accvgpr_read_b32 v197, a93
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a92, v196
		v_accvgpr_write_b32 a93, v197
		v_accvgpr_read_b32 v196, a94
		v_accvgpr_read_b32 v197, a95
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a94, v196
		v_accvgpr_write_b32 a95, v197
		v_accvgpr_read_b32 v196, a96
		v_accvgpr_read_b32 v197, a97
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a96, v196
		v_accvgpr_write_b32 a97, v197
		v_accvgpr_read_b32 v196, a98
		v_accvgpr_read_b32 v197, a99
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a98, v196
		v_accvgpr_write_b32 a99, v197
		v_accvgpr_read_b32 v196, a100
		v_accvgpr_read_b32 v197, a101
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a100, v196
		v_accvgpr_write_b32 a101, v197
		v_accvgpr_read_b32 v196, a102
		v_accvgpr_read_b32 v197, a103
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a102, v196
		v_accvgpr_write_b32 a103, v197
		v_accvgpr_read_b32 v196, a104
		v_accvgpr_read_b32 v197, a105
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a104, v196
		v_accvgpr_write_b32 a105, v197
		v_accvgpr_read_b32 v196, a106
		v_accvgpr_read_b32 v197, a107
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a106, v196
		v_accvgpr_write_b32 a107, v197
		v_accvgpr_read_b32 v196, a108
		v_accvgpr_read_b32 v197, a109
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a108, v196
		v_accvgpr_write_b32 a109, v197
		v_accvgpr_read_b32 v196, a110
		v_accvgpr_read_b32 v197, a111
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a110, v196
		v_accvgpr_write_b32 a111, v197
		v_accvgpr_read_b32 v196, a112
		v_accvgpr_read_b32 v197, a113
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a112, v196
		v_accvgpr_write_b32 a113, v197
		v_accvgpr_read_b32 v196, a114
		v_accvgpr_read_b32 v197, a115
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a114, v196
		v_accvgpr_write_b32 a115, v197
		v_accvgpr_read_b32 v196, a116
		v_accvgpr_read_b32 v197, a117
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a116, v196
		v_accvgpr_write_b32 a117, v197
		v_accvgpr_read_b32 v196, a118
		v_accvgpr_read_b32 v197, a119
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a118, v196
		v_accvgpr_write_b32 a119, v197
		v_accvgpr_read_b32 v196, a120
		v_accvgpr_read_b32 v197, a121
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a120, v196
		v_accvgpr_write_b32 a121, v197
		v_accvgpr_read_b32 v196, a122
		v_accvgpr_read_b32 v197, a123
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a122, v196
		v_accvgpr_write_b32 a123, v197
		v_accvgpr_read_b32 v196, a124
		v_accvgpr_read_b32 v197, a125
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a124, v196
		v_accvgpr_write_b32 a125, v197
		v_accvgpr_read_b32 v196, a126
		v_accvgpr_read_b32 v197, a127
		v_pk_mul_f32 v[196:197], v[196:197], v[192:193]
		v_accvgpr_write_b32 a126, v196
		v_accvgpr_write_b32 a127, v197
		v_mov_b32_e32 v194, v198
		v_mov_b32_e32 v196, v168
		v_mov_b32_e32 v197, v192
		v_pk_fma_f32 v[38:39], v[38:39], v[196:197], v[194:195]
		v_cvt_pk_bf16_f32 v192, v170, v188
		v_cvt_pk_bf16_f32 v193, v171, v189
		v_cvt_pk_bf16_f32 v194, v44, v112
		v_cvt_pk_bf16_f32 v195, v45, v113
		v_cvt_pk_bf16_f32 v168, v114, v116
		v_cvt_pk_bf16_f32 v169, v115, v117
		v_cvt_pk_bf16_f32 v170, v42, v46
		v_cvt_pk_bf16_f32 v171, v43, v47
		v_cvt_pk_bf16_f32 v44, v118, v120
		v_cvt_pk_bf16_f32 v45, v119, v121
		v_cvt_pk_bf16_f32 v46, v122, v124
		v_cvt_pk_bf16_f32 v47, v123, v125
		v_cvt_pk_bf16_f32 v112, v126, v128
		v_cvt_pk_bf16_f32 v113, v127, v129
		v_cvt_pk_bf16_f32 v114, v130, v132
		v_cvt_pk_bf16_f32 v115, v131, v133
		v_cvt_pk_bf16_f32 v116, v135, v137
		v_cvt_pk_bf16_f32 v117, v138, v190
		v_cvt_pk_bf16_f32 v118, v139, v191
		v_cvt_pk_bf16_f32 v119, v140, v142
		v_cvt_pk_bf16_f32 v120, v141, v143
		v_cvt_pk_bf16_f32 v121, v144, v146
		v_cvt_pk_bf16_f32 v122, v145, v147
		v_cvt_pk_bf16_f32 v123, v148, v150
		v_cvt_pk_bf16_f32 v124, v149, v151
		v_cvt_pk_bf16_f32 v125, v152, v154
		v_cvt_pk_bf16_f32 v126, v153, v155
		v_cvt_pk_bf16_f32 v127, v156, v158
		v_cvt_pk_bf16_f32 v128, v157, v159
		v_cvt_pk_bf16_f32 v129, v160, v162
		v_cvt_pk_bf16_f32 v130, v161, v163
		v_cvt_pk_bf16_f32 v131, v164, v166
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_permlane32_swap_b32_e32 v168, v170
		v_permlane32_swap_b32_e32 v169, v171
		v_permlane32_swap_b32_e32 v44, v46
		v_permlane32_swap_b32_e32 v45, v47
		v_mfma_f32_32x32x16_bf16 v[48:63], v[172:175], v[192:195], v[48:63]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[64:79], v[176:179], v[192:195], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], v[180:183], v[192:195], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], v[184:187], v[192:195], v[96:111]
		v_mfma_f32_32x32x16_bf16 a[112:127], v[184:187], v[116:119], a[112:127]
		v_mfma_f32_32x32x16_bf16 a[64:79], v[172:175], v[116:119], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[80:95], v[176:179], v[116:119], a[80:95]
		v_mfma_f32_32x32x16_bf16 a[96:111], v[180:183], v[116:119], a[96:111]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[128:131], v[168:171], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[140:143], v[168:171], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], v[168:171], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[164:167], v[168:171], v[96:111]
		v_mfma_f32_32x32x16_bf16 a[112:127], a[164:167], v[120:123], a[112:127]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[128:131], v[120:123], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[80:95], a[140:143], v[120:123], a[80:95]
		v_mfma_f32_32x32x16_bf16 a[96:111], a[152:155], v[120:123], a[96:111]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[132:135], v[44:47], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[144:147], v[44:47], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], v[44:47], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[168:171], v[44:47], v[96:111]
		v_mfma_f32_32x32x16_bf16 a[112:127], a[168:171], v[124:127], a[112:127]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[132:135], v[124:127], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[80:95], a[144:147], v[124:127], a[80:95]
		v_mfma_f32_32x32x16_bf16 a[96:111], a[156:159], v[124:127], a[96:111]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[136:139], v[112:115], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[148:151], v[112:115], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[160:163], v[112:115], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[172:175], v[112:115], v[96:111]
		v_mfma_f32_32x32x16_bf16 a[112:127], a[172:175], v[128:131], a[112:127]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[136:139], v[128:131], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[80:95], a[148:151], v[128:131], a[80:95]
		v_mfma_f32_32x32x16_bf16 a[96:111], a[160:163], v[128:131], a[96:111]
		s_mov_b32 s4, s3
		v_mov_b32_e32 v23, v40
		v_mov_b32_e32 v37, v41
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
		ds_read_b128 v[112:115], v0 offset:96
		ds_read_b128 v[116:119], v0 offset:128
		ds_read_b128 v[120:123], v0 offset:160
		ds_read_b128 v[124:127], v0 offset:192
		ds_read_b128 v[128:131], v0 offset:224
		ds_read_b128 v[132:135], v0 offset:512
		ds_read_b128 v[136:139], v0 offset:544
		ds_read_b128 v[140:143], v0 offset:576
		ds_read_b128 v[144:147], v0 offset:608
		ds_read_b128 v[148:151], v0 offset:640
		ds_read_b128 v[152:155], v0 offset:672
		ds_read_b128 v[156:159], v0 offset:704
		ds_read_b128 v[160:163], v0 offset:736
		s_mul_i32 s1, 0x4400, s1
		v_add_u32_e32 v0, s1, v25
		v_add3_u32 v0, v0, v33, v35
		v_lshl_add_u32 v0, v12, 3, v0
		ds_read_b64_tr_b16 v[24:25], v0 offset:33264
		ds_read_b64_tr_b16 v[26:27], v0 offset:37616
		ds_read_b64_tr_b16 v[32:33], v0 offset:33520
		ds_read_b64_tr_b16 v[34:35], v0 offset:37872
		ds_read_b64_tr_b16 v[164:165], v0 offset:33776
		ds_read_b64_tr_b16 v[166:167], v0 offset:38128
		ds_read_b64_tr_b16 a[128:129], v0 offset:34032
		ds_read_b64_tr_b16 a[130:131], v0 offset:38384
		ds_read_b64_tr_b16 v[168:169], v0 offset:33328
		ds_read_b64_tr_b16 v[170:171], v0 offset:37680
		ds_read_b64_tr_b16 v[172:173], v0 offset:33584
		ds_read_b64_tr_b16 v[174:175], v0 offset:37936
		ds_read_b64_tr_b16 v[176:177], v0 offset:33840
		ds_read_b64_tr_b16 v[178:179], v0 offset:38192
		ds_read_b64_tr_b16 a[132:133], v0 offset:34096
		ds_read_b64_tr_b16 a[134:135], v0 offset:38448
		ds_read_b64_tr_b16 v[180:181], v0 offset:33392
		ds_read_b64_tr_b16 v[182:183], v0 offset:37744
		ds_read_b64_tr_b16 v[184:185], v0 offset:33648
		ds_read_b64_tr_b16 v[186:187], v0 offset:38000
		ds_read_b64_tr_b16 v[188:189], v0 offset:33904
		ds_read_b64_tr_b16 v[190:191], v0 offset:38256
		ds_read_b64_tr_b16 a[136:137], v0 offset:34160
		ds_read_b64_tr_b16 a[138:139], v0 offset:38512
		ds_read_b64_tr_b16 v[192:193], v0 offset:33456
		ds_read_b64_tr_b16 v[194:195], v0 offset:37808
		ds_read_b64_tr_b16 v[196:197], v0 offset:33712
		ds_read_b64_tr_b16 v[198:199], v0 offset:38064
		ds_read_b64_tr_b16 v[200:201], v0 offset:33968
		ds_read_b64_tr_b16 v[202:203], v0 offset:38320
		ds_read_b64_tr_b16 v[204:205], v0 offset:34224
		ds_read_b64_tr_b16 v[206:207], v0 offset:38576
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[208:223], v[28:31], a[0:3], 0
		v_add_u32_e32 v0, s2, v17
		v_add3_u32 v1, 1, v17, s2
		v_add3_u32 v6, 2, v17, s2
		v_add3_u32 v7, 3, v17, s2
		v_add3_u32 v8, 8, v17, s2
		v_add3_u32 v10, 9, v17, s2
		v_add3_u32 v12, 10, v17, s2
		v_mfma_f32_32x32x16_bf16 v[224:239], v[132:135], a[0:3], 0
		s_nop 11
		v_accvgpr_write_b32 a144, v224
		v_accvgpr_write_b32 a145, v225
		v_accvgpr_write_b32 a146, v226
		v_accvgpr_write_b32 a147, v227
		v_accvgpr_write_b32 a148, v228
		v_accvgpr_write_b32 a149, v229
		v_accvgpr_write_b32 a150, v230
		v_accvgpr_write_b32 a151, v231
		v_accvgpr_write_b32 a152, v232
		v_accvgpr_write_b32 a153, v233
		v_accvgpr_write_b32 a154, v234
		v_accvgpr_write_b32 a155, v235
		v_accvgpr_write_b32 a156, v236
		v_accvgpr_write_b32 a157, v237
		v_accvgpr_write_b32 a158, v238
		v_accvgpr_write_b32 a159, v239
		v_add3_u32 v14, 11, v17, s2
		v_add3_u32 v21, 16, v17, s2
		v_add3_u32 v36, 17, v17, s2
		v_add3_u32 v224, 18, v17, s2
		v_add3_u32 v225, 19, v17, s2
		v_add3_u32 v226, 24, v17, s2
		v_add3_u32 v227, 25, v17, s2
		v_mfma_f32_32x32x16_bf16 v[240:255], v[132:135], a[32:35], 0
		s_nop 11
		v_accvgpr_write_b32 a160, v240
		v_accvgpr_write_b32 a161, v241
		v_accvgpr_write_b32 a162, v242
		v_accvgpr_write_b32 a163, v243
		v_accvgpr_write_b32 a164, v244
		v_accvgpr_write_b32 a165, v245
		v_accvgpr_write_b32 a166, v246
		v_accvgpr_write_b32 a167, v247
		v_accvgpr_write_b32 a168, v248
		v_accvgpr_write_b32 a169, v249
		v_accvgpr_write_b32 a170, v250
		v_accvgpr_write_b32 a171, v251
		v_accvgpr_write_b32 a172, v252
		v_accvgpr_write_b32 a173, v253
		v_accvgpr_write_b32 a174, v254
		v_accvgpr_write_b32 a175, v255
		v_add3_u32 v132, 26, v17, s2
		v_add3_u32 v133, 27, v17, s2
		v_add3_u32 v134, 32, v17, s2
		v_add3_u32 v135, 33, v17, s2
		v_add3_u32 v228, 34, v17, s2
		v_add3_u32 v229, 35, v17, s2
		v_add3_u32 v230, 40, v17, s2
		v_mfma_f32_32x32x16_bf16 v[240:255], v[28:31], a[32:35], 0
		v_add3_u32 v28, 41, v17, s2
		v_add3_u32 v29, 42, v17, s2
		v_add3_u32 v30, 43, v17, s2
		v_add3_u32 v31, 48, v17, s2
		v_add3_u32 v231, 49, v17, s2
		v_add3_u32 v232, 50, v17, s2
		v_add3_u32 v233, 51, v17, s2
		v_mfma_f32_32x32x16_bf16 v[208:223], v[40:43], a[4:7], v[208:223]
		v_add3_u32 v234, 56, v17, s2
		v_add3_u32 v235, 57, v17, s2
		v_add3_u32 v236, 58, v17, s2
		v_add3_u32 v17, 59, v17, s2
		v_cmp_lt_i32_e64 vcc, v0, s25
		s_mov_b64 s[2:3], vcc
		v_cmp_lt_i32_e64 vcc, v1, s25
		s_mov_b64 s[4:5], vcc
		v_cmp_lt_i32_e64 vcc, v6, s25
		s_mov_b64 s[6:7], vcc
		v_mfma_f32_32x32x16_bf16 a[144:159], v[136:139], a[4:7], a[144:159]
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
		v_cmp_lt_i32_e64 vcc, v36, s25
		s_mov_b64 s[36:37], vcc
		v_mfma_f32_32x32x16_bf16 a[160:175], v[136:139], a[36:39], a[160:175]
		v_cmp_lt_i32_e64 vcc, v224, s25
		s_mov_b64 s[38:39], vcc
		v_cmp_lt_i32_e64 vcc, v225, s25
		s_mov_b64 s[40:41], vcc
		v_cmp_lt_i32_e64 vcc, v226, s25
		s_mov_b64 s[42:43], vcc
		v_cmp_lt_i32_e64 vcc, v227, s25
		s_mov_b64 s[44:45], vcc
		v_cmp_lt_i32_e64 vcc, v132, s25
		s_mov_b64 s[46:47], vcc
		v_cmp_lt_i32_e64 vcc, v133, s25
		s_mov_b64 s[48:49], vcc
		v_cmp_lt_i32_e64 vcc, v134, s25
		s_mov_b64 s[50:51], vcc
		v_mfma_f32_32x32x16_bf16 v[240:255], v[40:43], a[36:39], v[240:255]
		v_cmp_lt_i32_e64 vcc, v135, s25
		s_mov_b64 s[52:53], vcc
		v_cmp_lt_i32_e64 vcc, v228, s25
		s_mov_b64 s[54:55], vcc
		v_cmp_lt_i32_e64 vcc, v229, s25
		s_mov_b64 s[56:57], vcc
		v_cmp_lt_i32_e64 vcc, v230, s25
		s_mov_b64 s[58:59], vcc
		v_cmp_lt_i32_e64 vcc, v28, s25
		s_mov_b64 s[60:61], vcc
		v_cmp_lt_i32_e64 vcc, v29, s25
		s_mov_b64 s[62:63], vcc
		v_cmp_lt_i32_e64 vcc, v30, s25
		s_mov_b64 s[64:65], vcc
		v_mfma_f32_32x32x16_bf16 v[208:223], v[44:47], a[8:11], v[208:223]
		v_cmp_lt_i32_e64 vcc, v31, s25
		s_mov_b64 s[66:67], vcc
		v_cmp_lt_i32_e64 vcc, v231, s25
		s_mov_b64 s[68:69], vcc
		v_cmp_lt_i32_e64 vcc, v232, s25
		s_mov_b64 s[70:71], vcc
		v_cmp_lt_i32_e64 vcc, v233, s25
		s_mov_b64 s[72:73], vcc
		v_cmp_lt_i32_e64 vcc, v234, s25
		s_mov_b64 s[74:75], vcc
		v_cmp_lt_i32_e64 vcc, v235, s25
		s_mov_b64 s[76:77], vcc
		v_cmp_lt_i32_e64 vcc, v236, s25
		s_mov_b64 s[78:79], vcc
		v_mfma_f32_32x32x16_bf16 a[144:159], v[140:143], a[8:11], a[144:159]
		v_cmp_lt_i32_e64 vcc, v17, s25
		v_mov_b32_e32 v0, 0xff800000
		v_mfma_f32_32x32x16_bf16 a[160:175], v[140:143], a[40:43], a[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[44:47], a[40:43], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[112:115], a[12:15], v[208:223]
		v_mfma_f32_32x32x16_bf16 a[144:159], v[144:147], a[12:15], a[144:159]
		v_mfma_f32_32x32x16_bf16 a[160:175], v[144:147], a[44:47], a[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[112:115], a[44:47], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[116:119], a[16:19], v[208:223]
		v_mfma_f32_32x32x16_bf16 a[144:159], v[148:151], a[16:19], a[144:159]
		v_mfma_f32_32x32x16_bf16 a[160:175], v[148:151], a[48:51], a[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[116:119], a[48:51], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[120:123], a[20:23], v[208:223]
		v_mfma_f32_32x32x16_bf16 a[144:159], v[152:155], a[20:23], a[144:159]
		v_mfma_f32_32x32x16_bf16 a[160:175], v[152:155], a[52:55], a[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[120:123], a[52:55], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[124:127], a[24:27], v[208:223]
		v_mfma_f32_32x32x16_bf16 a[144:159], v[156:159], a[24:27], a[144:159]
		v_mfma_f32_32x32x16_bf16 a[160:175], v[156:159], a[56:59], a[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[124:127], a[56:59], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[128:131], a[28:31], v[208:223]
		v_mfma_f32_32x32x16_bf16 a[144:159], v[160:163], a[28:31], a[144:159]
		v_mfma_f32_32x32x16_bf16 a[160:175], v[160:163], a[60:63], a[160:175]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[128:131], a[60:63], v[240:255]
		v_lshlrev_b32_e32 v1, 4, v13
		s_nop 7
		v_cndmask_b32_e64 v6, v0, v208, s[2:3]
		v_cndmask_b32_e64 v7, v0, v209, s[4:5]
		v_cndmask_b32_e64 v12, v0, v210, s[6:7]
		v_cndmask_b32_e64 v13, v0, v211, s[10:11]
		v_cndmask_b32_e64 v28, v0, v212, s[12:13]
		v_cndmask_b32_e64 v29, v0, v213, s[14:15]
		v_cndmask_b32_e64 v30, v0, v214, s[18:19]
		v_cndmask_b32_e64 v31, v0, v215, s[30:31]
		v_cndmask_b32_e64 v40, v0, v216, s[32:33]
		v_cndmask_b32_e64 v41, v0, v217, s[36:37]
		v_cndmask_b32_e64 v42, v0, v218, s[38:39]
		v_cndmask_b32_e64 v43, v0, v219, s[40:41]
		v_cndmask_b32_e64 v44, v0, v220, s[42:43]
		v_cndmask_b32_e64 v45, v0, v221, s[44:45]
		v_cndmask_b32_e64 v46, v0, v222, s[46:47]
		v_cndmask_b32_e64 v47, v0, v223, s[48:49]
		v_accvgpr_read_b32 v8, a144
		v_cndmask_b32_e64 v112, v0, v8, s[50:51]
		v_accvgpr_read_b32 v8, a145
		v_cndmask_b32_e64 v113, v0, v8, s[52:53]
		v_accvgpr_read_b32 v8, a146
		v_cndmask_b32_e64 v114, v0, v8, s[54:55]
		v_accvgpr_read_b32 v8, a147
		v_cndmask_b32_e64 v115, v0, v8, s[56:57]
		v_accvgpr_read_b32 v8, a148
		v_cndmask_b32_e64 v116, v0, v8, s[58:59]
		v_accvgpr_read_b32 v8, a149
		v_cndmask_b32_e64 v117, v0, v8, s[60:61]
		v_accvgpr_read_b32 v8, a150
		v_cndmask_b32_e64 v118, v0, v8, s[62:63]
		v_accvgpr_read_b32 v8, a151
		v_cndmask_b32_e64 v119, v0, v8, s[64:65]
		v_accvgpr_read_b32 v8, a152
		v_cndmask_b32_e64 v120, v0, v8, s[66:67]
		v_accvgpr_read_b32 v8, a153
		v_cndmask_b32_e64 v121, v0, v8, s[68:69]
		v_accvgpr_read_b32 v8, a154
		v_cndmask_b32_e64 v122, v0, v8, s[70:71]
		v_accvgpr_read_b32 v8, a155
		v_cndmask_b32_e64 v123, v0, v8, s[72:73]
		v_accvgpr_read_b32 v8, a156
		v_cndmask_b32_e64 v124, v0, v8, s[74:75]
		v_accvgpr_read_b32 v8, a157
		v_cndmask_b32_e64 v125, v0, v8, s[76:77]
		v_accvgpr_read_b32 v8, a158
		v_cndmask_b32_e64 v126, v0, v8, s[78:79]
		v_accvgpr_read_b32 v8, a159
		v_cndmask_b32_e32 v127, v0, v8, vcc
		v_cndmask_b32_e64 v128, v0, v240, s[2:3]
		v_cndmask_b32_e64 v129, v0, v241, s[4:5]
		v_cndmask_b32_e64 v130, v0, v242, s[6:7]
		v_cndmask_b32_e64 v131, v0, v243, s[10:11]
		v_cndmask_b32_e64 v132, v0, v244, s[12:13]
		v_cndmask_b32_e64 v133, v0, v245, s[14:15]
		v_cndmask_b32_e64 v134, v0, v246, s[18:19]
		v_cndmask_b32_e64 v135, v0, v247, s[30:31]
		v_cndmask_b32_e64 v136, v0, v248, s[32:33]
		v_cndmask_b32_e64 v137, v0, v249, s[36:37]
		v_cndmask_b32_e64 v138, v0, v250, s[38:39]
		v_cndmask_b32_e64 v139, v0, v251, s[40:41]
		v_cndmask_b32_e64 v140, v0, v252, s[42:43]
		v_cndmask_b32_e64 v141, v0, v253, s[44:45]
		v_cndmask_b32_e64 v142, v0, v254, s[46:47]
		v_cndmask_b32_e64 v143, v0, v255, s[48:49]
		v_accvgpr_read_b32 v8, a160
		v_cndmask_b32_e64 v144, v0, v8, s[50:51]
		v_accvgpr_read_b32 v8, a161
		v_cndmask_b32_e64 v145, v0, v8, s[52:53]
		v_accvgpr_read_b32 v8, a162
		v_cndmask_b32_e64 v146, v0, v8, s[54:55]
		v_accvgpr_read_b32 v8, a163
		v_cndmask_b32_e64 v147, v0, v8, s[56:57]
		v_accvgpr_read_b32 v8, a164
		v_cndmask_b32_e64 v148, v0, v8, s[58:59]
		v_accvgpr_read_b32 v8, a165
		v_cndmask_b32_e64 v149, v0, v8, s[60:61]
		v_accvgpr_read_b32 v8, a166
		v_cndmask_b32_e64 v150, v0, v8, s[62:63]
		v_accvgpr_read_b32 v8, a167
		v_cndmask_b32_e64 v151, v0, v8, s[64:65]
		v_accvgpr_read_b32 v8, a168
		v_cndmask_b32_e64 v152, v0, v8, s[66:67]
		v_accvgpr_read_b32 v8, a169
		v_cndmask_b32_e64 v153, v0, v8, s[68:69]
		v_accvgpr_read_b32 v8, a170
		v_cndmask_b32_e64 v154, v0, v8, s[70:71]
		v_accvgpr_read_b32 v8, a171
		v_cndmask_b32_e64 v155, v0, v8, s[72:73]
		v_accvgpr_read_b32 v8, a172
		v_cndmask_b32_e64 v156, v0, v8, s[74:75]
		v_accvgpr_read_b32 v8, a173
		v_cndmask_b32_e64 v157, v0, v8, s[76:77]
		v_accvgpr_read_b32 v8, a174
		v_cndmask_b32_e64 v158, v0, v8, s[78:79]
		v_accvgpr_read_b32 v8, a175
		v_cndmask_b32_e32 v159, v0, v8, vcc
		v_max_f32_e32 v0, v6, v7
		v_max_f32_e32 v8, v12, v13
		v_max_f32_e32 v10, v28, v29
		v_max_f32_e32 v14, v30, v31
		v_max_f32_e32 v17, v40, v41
		v_max_f32_e32 v21, v42, v43
		v_max_f32_e32 v36, v44, v45
		v_max_f32_e32 v160, v46, v47
		v_max_f32_e32 v161, v112, v113
		v_max_f32_e32 v162, v114, v115
		v_max_f32_e32 v163, v116, v117
		v_max_f32_e32 v208, v118, v119
		v_max_f32_e32 v209, v120, v121
		v_max_f32_e32 v210, v122, v123
		v_max_f32_e32 v211, v124, v125
		v_max_f32_e32 v212, v126, v127
		v_max_f32_e32 v0, v0, v8
		v_max_f32_e32 v8, v10, v14
		v_max_f32_e32 v10, v17, v21
		v_max_f32_e32 v14, v36, v160
		v_max_f32_e32 v17, v161, v162
		v_max_f32_e32 v21, v163, v208
		v_max_f32_e32 v36, v209, v210
		v_max_f32_e32 v160, v211, v212
		v_max_f32_e32 v0, v0, v8
		v_max_f32_e32 v8, v10, v14
		v_max_f32_e32 v10, v17, v21
		v_max_f32_e32 v14, v36, v160
		v_max_f32_e32 v0, v0, v8
		v_max_f32_e32 v8, v10, v14
		v_max_f32_e32 v0, v0, v8
		ds_bpermute_b32 v8, v22, v0
		ds_bpermute_b32 v10, v16, v0
		v_max_f32_e32 v0, v128, v129
		v_max_f32_e32 v14, v130, v131
		v_max_f32_e32 v17, v132, v133
		v_max_f32_e32 v21, v134, v135
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v160, v8, v10
		v_max_f32_e32 v8, v136, v137
		v_max_f32_e32 v10, v138, v139
		v_max_f32_e32 v36, v140, v141
		v_max_f32_e32 v161, v142, v143
		v_max_f32_e32 v162, v144, v145
		v_max_f32_e32 v163, v146, v147
		v_max_f32_e32 v208, v148, v149
		v_max_f32_e32 v209, v150, v151
		v_max_f32_e32 v210, v152, v153
		v_max_f32_e32 v211, v154, v155
		v_max_f32_e32 v212, v156, v157
		v_max_f32_e32 v213, v158, v159
		v_max_f32_e32 v0, v0, v14
		v_max_f32_e32 v14, v17, v21
		v_max_f32_e32 v8, v8, v10
		v_max_f32_e32 v10, v36, v161
		v_max_f32_e32 v17, v162, v163
		v_max_f32_e32 v21, v208, v209
		v_max_f32_e32 v36, v210, v211
		v_max_f32_e32 v161, v212, v213
		v_max_f32_e32 v0, v0, v14
		v_max_f32_e32 v8, v8, v10
		v_max_f32_e32 v10, v17, v21
		v_max_f32_e32 v14, v36, v161
		v_max_f32_e32 v0, v0, v8
		v_max_f32_e32 v8, v10, v14
		v_max_f32_e32 v0, v0, v8
		ds_bpermute_b32 v8, v22, v0
		ds_bpermute_b32 v10, v16, v0
		v_pk_mul_f32 v[162:163], v[6:7], v[18:19]
		v_pk_mul_f32 v[6:7], v[12:13], v[18:19]
		v_pk_mul_f32 v[12:13], v[28:29], v[18:19]
		v_pk_mul_f32 v[28:29], v[30:31], v[18:19]
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v161, v8, v10
		v_pk_mul_f32 v[30:31], v[160:161], v[18:19]
		v_max_f32_e32 v0, v23, v30
		v_max_f32_e32 v8, v37, v31
		v_pk_mul_f32 v[30:31], v[40:41], v[18:19]
		v_pk_mul_f32 v[40:41], v[42:43], v[18:19]
		v_pk_mul_f32 v[42:43], v[44:45], v[18:19]
		v_pk_mul_f32 v[44:45], v[46:47], v[18:19]
		v_pk_mul_f32 v[46:47], v[112:113], v[18:19]
		v_pk_mul_f32 v[112:113], v[114:115], v[18:19]
		v_pk_mul_f32 v[114:115], v[116:117], v[18:19]
		v_pk_mul_f32 v[116:117], v[118:119], v[18:19]
		v_pk_mul_f32 v[118:119], v[120:121], v[18:19]
		v_pk_mul_f32 v[120:121], v[122:123], v[18:19]
		v_pk_mul_f32 v[122:123], v[124:125], v[18:19]
		v_pk_mul_f32 v[124:125], v[126:127], v[18:19]
		v_pk_mul_f32 v[126:127], v[128:129], v[18:19]
		v_pk_mul_f32 v[128:129], v[130:131], v[18:19]
		v_pk_mul_f32 v[130:131], v[132:133], v[18:19]
		v_pk_mul_f32 v[132:133], v[134:135], v[18:19]
		v_pk_mul_f32 v[134:135], v[136:137], v[18:19]
		v_pk_mul_f32 v[136:137], v[138:139], v[18:19]
		v_pk_mul_f32 v[138:139], v[140:141], v[18:19]
		v_pk_mul_f32 v[140:141], v[142:143], v[18:19]
		v_pk_mul_f32 v[142:143], v[144:145], v[18:19]
		v_pk_mul_f32 v[144:145], v[146:147], v[18:19]
		v_pk_mul_f32 v[146:147], v[148:149], v[18:19]
		v_pk_mul_f32 v[148:149], v[150:151], v[18:19]
		v_pk_mul_f32 v[150:151], v[152:153], v[18:19]
		v_pk_mul_f32 v[152:153], v[154:155], v[18:19]
		v_pk_mul_f32 v[154:155], v[156:157], v[18:19]
		v_pk_mul_f32 v[156:157], v[158:159], v[18:19]
		v_sub_f32_e32 v10, v162, v0
		v_sub_f32_e32 v14, v163, v0
		v_sub_f32_e32 v6, v6, v0
		v_sub_f32_e32 v7, v7, v0
		v_sub_f32_e32 v12, v12, v0
		v_sub_f32_e32 v13, v13, v0
		v_sub_f32_e32 v17, v28, v0
		v_sub_f32_e32 v18, v29, v0
		v_sub_f32_e32 v19, v30, v0
		v_sub_f32_e32 v21, v31, v0
		v_sub_f32_e32 v28, v40, v0
		v_sub_f32_e32 v29, v41, v0
		v_sub_f32_e32 v30, v42, v0
		v_sub_f32_e32 v31, v43, v0
		v_sub_f32_e32 v36, v44, v0
		v_sub_f32_e32 v40, v45, v0
		v_sub_f32_e32 v41, v46, v0
		v_sub_f32_e32 v42, v47, v0
		v_sub_f32_e32 v43, v112, v0
		v_sub_f32_e32 v44, v113, v0
		v_sub_f32_e32 v45, v114, v0
		v_sub_f32_e32 v46, v115, v0
		v_sub_f32_e32 v47, v116, v0
		v_sub_f32_e32 v112, v117, v0
		v_sub_f32_e32 v113, v118, v0
		v_sub_f32_e32 v114, v119, v0
		v_sub_f32_e32 v115, v120, v0
		v_sub_f32_e32 v116, v121, v0
		v_sub_f32_e32 v117, v122, v0
		v_sub_f32_e32 v118, v123, v0
		v_sub_f32_e32 v119, v124, v0
		v_sub_f32_e32 v120, v125, v0
		v_sub_f32_e32 v121, v126, v8
		v_sub_f32_e32 v122, v127, v8
		v_sub_f32_e32 v123, v128, v8
		v_sub_f32_e32 v124, v129, v8
		v_sub_f32_e32 v125, v130, v8
		v_sub_f32_e32 v126, v131, v8
		v_sub_f32_e32 v127, v132, v8
		v_sub_f32_e32 v128, v133, v8
		v_sub_f32_e32 v129, v134, v8
		v_sub_f32_e32 v130, v135, v8
		v_sub_f32_e32 v131, v136, v8
		v_sub_f32_e32 v132, v137, v8
		v_sub_f32_e32 v133, v138, v8
		v_sub_f32_e32 v134, v139, v8
		v_sub_f32_e32 v135, v140, v8
		v_sub_f32_e32 v136, v141, v8
		v_sub_f32_e32 v137, v142, v8
		v_sub_f32_e32 v138, v143, v8
		v_sub_f32_e32 v139, v144, v8
		v_sub_f32_e32 v140, v145, v8
		v_sub_f32_e32 v141, v146, v8
		v_sub_f32_e32 v142, v147, v8
		v_sub_f32_e32 v143, v148, v8
		v_sub_f32_e32 v144, v149, v8
		v_sub_f32_e32 v145, v150, v8
		v_sub_f32_e32 v146, v151, v8
		v_sub_f32_e32 v147, v152, v8
		v_sub_f32_e32 v148, v153, v8
		v_sub_f32_e32 v149, v154, v8
		v_sub_f32_e32 v150, v155, v8
		v_sub_f32_e32 v151, v156, v8
		v_sub_f32_e32 v152, v157, v8
		v_exp_f32_e32 v154, v10
		v_exp_f32_e32 v156, v14
		v_exp_f32_e32 v155, v6
		v_exp_f32_e32 v157, v7
		v_exp_f32_e32 v6, v12
		v_exp_f32_e32 v158, v13
		v_exp_f32_e32 v7, v17
		v_exp_f32_e32 v159, v18
		v_exp_f32_e32 v12, v19
		v_exp_f32_e32 v18, v21
		v_exp_f32_e32 v13, v28
		v_exp_f32_e32 v19, v29
		v_exp_f32_e32 v28, v30
		v_exp_f32_e32 v160, v31
		v_exp_f32_e32 v29, v36
		v_exp_f32_e32 v161, v40
		v_exp_f32_e32 v30, v41
		v_exp_f32_e32 v40, v42
		v_exp_f32_e32 v31, v43
		v_exp_f32_e32 v41, v44
		v_exp_f32_e32 v42, v45
		v_exp_f32_e32 v44, v46
		v_exp_f32_e32 v43, v47
		v_exp_f32_e32 v45, v112
		v_exp_f32_e32 v46, v113
		v_exp_f32_e32 v112, v114
		v_exp_f32_e32 v47, v115
		v_exp_f32_e32 v113, v116
		v_exp_f32_e32 v114, v117
		v_exp_f32_e32 v116, v118
		v_exp_f32_e32 v115, v119
		v_exp_f32_e32 v117, v120
		v_exp_f32_e32 v119, v121
		v_exp_f32_e32 v121, v122
		v_exp_f32_e32 v162, v123
		v_exp_f32_e32 v122, v124
		v_exp_f32_e32 v163, v125
		v_exp_f32_e32 v123, v126
		v_exp_f32_e32 v124, v127
		v_exp_f32_e32 v126, v128
		v_exp_f32_e32 v125, v129
		v_exp_f32_e32 v127, v130
		v_exp_f32_e32 v128, v131
		v_exp_f32_e32 v130, v132
		v_exp_f32_e32 v129, v133
		v_exp_f32_e32 v131, v134
		v_exp_f32_e32 v132, v135
		v_exp_f32_e32 v134, v136
		v_exp_f32_e32 v133, v137
		v_exp_f32_e32 v135, v138
		v_exp_f32_e32 v136, v139
		v_exp_f32_e32 v138, v140
		v_exp_f32_e32 v137, v141
		v_exp_f32_e32 v139, v142
		v_exp_f32_e32 v140, v143
		v_exp_f32_e32 v142, v144
		v_exp_f32_e32 v141, v145
		v_exp_f32_e32 v143, v146
		v_exp_f32_e32 v144, v147
		v_exp_f32_e32 v146, v148
		v_exp_f32_e32 v145, v149
		v_exp_f32_e32 v147, v150
		v_exp_f32_e32 v148, v151
		v_exp_f32_e32 v150, v152
		v_pk_add_f32 v[152:153], v[154:155], v[156:157]
		v_pk_add_f32 v[208:209], v[6:7], v[158:159]
		v_pk_add_f32 v[210:211], v[12:13], v[18:19]
		v_pk_add_f32 v[212:213], v[28:29], v[160:161]
		v_pk_add_f32 v[214:215], v[30:31], v[40:41]
		v_pk_add_f32 v[216:217], v[42:43], v[44:45]
		v_pk_add_f32 v[218:219], v[46:47], v[112:113]
		v_pk_add_f32 v[220:221], v[114:115], v[116:117]
		v_mov_b32_e32 v222, v153
		v_mov_b32_e32 v223, v209
		v_mov_b32_e32 v224, v152
		v_mov_b32_e32 v225, v208
		v_pk_add_f32 v[152:153], v[224:225], v[222:223]
		v_mov_b32_e32 v208, v211
		v_mov_b32_e32 v209, v213
		v_mov_b32_e32 v222, v210
		v_mov_b32_e32 v223, v212
		v_pk_add_f32 v[210:211], v[222:223], v[208:209]
		v_mov_b32_e32 v208, v215
		v_mov_b32_e32 v209, v217
		v_mov_b32_e32 v212, v214
		v_mov_b32_e32 v213, v216
		v_pk_add_f32 v[214:215], v[212:213], v[208:209]
		v_mov_b32_e32 v208, v219
		v_mov_b32_e32 v209, v221
		v_mov_b32_e32 v212, v218
		v_mov_b32_e32 v213, v220
		v_pk_add_f32 v[216:217], v[212:213], v[208:209]
		v_mov_b32_e32 v208, v153
		v_mov_b32_e32 v209, v211
		v_mov_b32_e32 v212, v152
		v_mov_b32_e32 v213, v210
		v_pk_add_f32 v[152:153], v[212:213], v[208:209]
		v_mov_b32_e32 v208, v215
		v_mov_b32_e32 v209, v217
		v_mov_b32_e32 v210, v214
		v_mov_b32_e32 v211, v216
		v_pk_add_f32 v[212:213], v[210:211], v[208:209]
		v_mov_b32_e32 v208, v153
		v_mov_b32_e32 v209, v213
		v_mov_b32_e32 v210, v152
		v_mov_b32_e32 v211, v212
		v_pk_add_f32 v[152:153], v[210:211], v[208:209]
		v_add_f32_e32 v10, v152, v153
		ds_bpermute_b32 v118, v22, v10
		ds_bpermute_b32 v120, v16, v10
		v_pk_add_f32 v[152:153], v[162:163], v[122:123]
		v_pk_add_f32 v[208:209], v[124:125], v[126:127]
		v_pk_add_f32 v[210:211], v[128:129], v[130:131]
		v_pk_add_f32 v[212:213], v[132:133], v[134:135]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[214:215], v[118:119], v[120:121]
		v_pk_add_f32 v[216:217], v[136:137], v[138:139]
		v_pk_add_f32 v[218:219], v[140:141], v[142:143]
		v_pk_add_f32 v[220:221], v[144:145], v[146:147]
		v_mov_b32_e32 v149, v215
		v_mov_b32_e32 v151, v152
		v_pk_add_f32 v[222:223], v[148:149], v[150:151]
		v_mov_b32_e32 v224, v153
		v_mov_b32_e32 v225, v210
		v_pk_add_f32 v[152:153], v[224:225], v[208:209]
		v_mov_b32_e32 v208, v211
		v_mov_b32_e32 v209, v216
		v_pk_add_f32 v[208:209], v[208:209], v[212:213]
		v_mov_b32_e32 v210, v217
		v_mov_b32_e32 v211, v220
		v_pk_add_f32 v[212:213], v[210:211], v[218:219]
		v_mov_b32_e32 v210, v221
		v_mov_b32_e32 v211, v152
		v_pk_add_f32 v[210:211], v[210:211], v[222:223]
		v_mov_b32_e32 v216, v153
		v_mov_b32_e32 v217, v212
		v_pk_add_f32 v[152:153], v[216:217], v[208:209]
		v_mov_b32_e32 v208, v213
		v_mov_b32_e32 v209, v152
		v_pk_add_f32 v[212:213], v[208:209], v[210:211]
		v_add_f32_e32 v10, v153, v212
		v_add_f32_e32 v10, v213, v10
		ds_bpermute_b32 v14, v22, v10
		ds_bpermute_b32 v17, v16, v10
		v_sub_f32_e32 v0, v23, v0
		v_sub_f32_e32 v8, v37, v8
		v_exp_f32_e32 v22, v0
		v_exp_f32_e32 v36, v8
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v153, v14, v17
		v_mov_b32_e32 v23, v22
		v_pk_mul_f32 v[224:225], v[48:49], v[22:23]
		v_pk_mul_f32 v[226:227], v[50:51], v[22:23]
		v_pk_mul_f32 v[228:229], v[52:53], v[22:23]
		v_pk_mul_f32 v[230:231], v[54:55], v[22:23]
		v_pk_mul_f32 v[232:233], v[56:57], v[22:23]
		v_pk_mul_f32 v[234:235], v[58:59], v[22:23]
		v_pk_mul_f32 v[236:237], v[60:61], v[22:23]
		v_pk_mul_f32 v[238:239], v[62:63], v[22:23]
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
		v_accvgpr_read_b32 v16, a64
		v_accvgpr_read_b32 v17, a65
		v_pk_mul_f32 v[96:97], v[16:17], v[36:37]
		v_accvgpr_read_b32 v16, a66
		v_accvgpr_read_b32 v17, a67
		v_pk_mul_f32 v[98:99], v[16:17], v[36:37]
		v_accvgpr_read_b32 v16, a68
		v_accvgpr_read_b32 v17, a69
		v_pk_mul_f32 v[100:101], v[16:17], v[36:37]
		v_accvgpr_read_b32 v16, a70
		v_accvgpr_read_b32 v17, a71
		v_pk_mul_f32 v[102:103], v[16:17], v[36:37]
		v_accvgpr_read_b32 v16, a72
		v_accvgpr_read_b32 v17, a73
		v_pk_mul_f32 v[104:105], v[16:17], v[36:37]
		v_accvgpr_read_b32 v16, a74
		v_accvgpr_read_b32 v17, a75
		v_pk_mul_f32 v[106:107], v[16:17], v[36:37]
		v_accvgpr_read_b32 v16, a76
		v_accvgpr_read_b32 v17, a77
		v_pk_mul_f32 v[108:109], v[16:17], v[36:37]
		v_accvgpr_read_b32 v16, a78
		v_accvgpr_read_b32 v17, a79
		v_pk_mul_f32 v[110:111], v[16:17], v[36:37]
		v_accvgpr_read_b32 v16, a80
		v_accvgpr_read_b32 v17, a81
		v_pk_mul_f32 v[16:17], v[16:17], v[36:37]
		v_accvgpr_write_b32 a0, v16
		v_accvgpr_write_b32 a1, v17
		v_accvgpr_read_b32 v16, a82
		v_accvgpr_read_b32 v17, a83
		v_pk_mul_f32 v[16:17], v[16:17], v[36:37]
		v_accvgpr_write_b32 a2, v16
		v_accvgpr_write_b32 a3, v17
		v_accvgpr_read_b32 v16, a84
		v_accvgpr_read_b32 v17, a85
		v_pk_mul_f32 v[16:17], v[16:17], v[36:37]
		v_accvgpr_write_b32 a4, v16
		v_accvgpr_write_b32 a5, v17
		v_accvgpr_read_b32 v16, a86
		v_accvgpr_read_b32 v17, a87
		v_pk_mul_f32 v[16:17], v[16:17], v[36:37]
		v_accvgpr_write_b32 a6, v16
		v_accvgpr_write_b32 a7, v17
		v_accvgpr_read_b32 v16, a88
		v_accvgpr_read_b32 v17, a89
		v_pk_mul_f32 v[16:17], v[16:17], v[36:37]
		v_accvgpr_write_b32 a8, v16
		v_accvgpr_write_b32 a9, v17
		v_accvgpr_read_b32 v16, a90
		v_accvgpr_read_b32 v17, a91
		v_pk_mul_f32 v[16:17], v[16:17], v[36:37]
		v_accvgpr_write_b32 a10, v16
		v_accvgpr_write_b32 a11, v17
		v_accvgpr_read_b32 v16, a92
		v_accvgpr_read_b32 v17, a93
		v_pk_mul_f32 v[16:17], v[16:17], v[36:37]
		v_accvgpr_write_b32 a12, v16
		v_accvgpr_write_b32 a13, v17
		v_accvgpr_read_b32 v16, a94
		v_accvgpr_read_b32 v17, a95
		v_pk_mul_f32 v[16:17], v[16:17], v[36:37]
		v_accvgpr_write_b32 a14, v16
		v_accvgpr_write_b32 a15, v17
		v_accvgpr_read_b32 v16, a96
		v_accvgpr_read_b32 v17, a97
		v_pk_mul_f32 v[16:17], v[16:17], v[36:37]
		v_accvgpr_write_b32 a16, v16
		v_accvgpr_write_b32 a17, v17
		v_accvgpr_read_b32 v16, a98
		v_accvgpr_read_b32 v17, a99
		v_pk_mul_f32 v[16:17], v[16:17], v[36:37]
		v_accvgpr_write_b32 a18, v16
		v_accvgpr_write_b32 a19, v17
		v_accvgpr_read_b32 v16, a100
		v_accvgpr_read_b32 v17, a101
		v_pk_mul_f32 v[16:17], v[16:17], v[36:37]
		v_accvgpr_write_b32 a20, v16
		v_accvgpr_write_b32 a21, v17
		v_accvgpr_read_b32 v16, a102
		v_accvgpr_read_b32 v17, a103
		v_pk_mul_f32 v[16:17], v[16:17], v[36:37]
		v_accvgpr_write_b32 a22, v16
		v_accvgpr_write_b32 a23, v17
		v_accvgpr_read_b32 v16, a104
		v_accvgpr_read_b32 v17, a105
		v_pk_mul_f32 v[16:17], v[16:17], v[36:37]
		v_accvgpr_write_b32 a24, v16
		v_accvgpr_write_b32 a25, v17
		v_accvgpr_read_b32 v16, a106
		v_accvgpr_read_b32 v17, a107
		v_pk_mul_f32 v[16:17], v[16:17], v[36:37]
		v_accvgpr_write_b32 a26, v16
		v_accvgpr_write_b32 a27, v17
		v_accvgpr_read_b32 v16, a108
		v_accvgpr_read_b32 v17, a109
		v_pk_mul_f32 v[16:17], v[16:17], v[36:37]
		v_accvgpr_write_b32 a28, v16
		v_accvgpr_write_b32 a29, v17
		v_accvgpr_read_b32 v16, a110
		v_accvgpr_read_b32 v17, a111
		v_pk_mul_f32 v[16:17], v[16:17], v[36:37]
		v_accvgpr_write_b32 a30, v16
		v_accvgpr_write_b32 a31, v17
		v_accvgpr_read_b32 v16, a112
		v_accvgpr_read_b32 v17, a113
		v_pk_mul_f32 v[240:241], v[16:17], v[36:37]
		v_accvgpr_read_b32 v16, a114
		v_accvgpr_read_b32 v17, a115
		v_pk_mul_f32 v[242:243], v[16:17], v[36:37]
		v_accvgpr_read_b32 v16, a116
		v_accvgpr_read_b32 v17, a117
		v_pk_mul_f32 v[244:245], v[16:17], v[36:37]
		v_accvgpr_read_b32 v16, a118
		v_accvgpr_read_b32 v17, a119
		v_pk_mul_f32 v[246:247], v[16:17], v[36:37]
		v_accvgpr_read_b32 v16, a120
		v_accvgpr_read_b32 v17, a121
		v_pk_mul_f32 v[248:249], v[16:17], v[36:37]
		v_accvgpr_read_b32 v16, a122
		v_accvgpr_read_b32 v17, a123
		v_pk_mul_f32 v[250:251], v[16:17], v[36:37]
		v_accvgpr_read_b32 v16, a124
		v_accvgpr_read_b32 v17, a125
		v_pk_mul_f32 v[252:253], v[16:17], v[36:37]
		v_accvgpr_read_b32 v16, a126
		v_accvgpr_read_b32 v17, a127
		v_pk_mul_f32 v[254:255], v[16:17], v[36:37]
		v_mov_b32_e32 v152, v214
		v_mov_b32_e32 v16, v22
		v_mov_b32_e32 v17, v36
		v_pk_fma_f32 v[22:23], v[38:39], v[16:17], v[152:153]
		v_cvt_pk_bf16_f32 v36, v154, v156
		v_cvt_pk_bf16_f32 v37, v155, v157
		v_cvt_pk_bf16_f32 v38, v6, v158
		v_cvt_pk_bf16_f32 v39, v7, v159
		v_cvt_pk_bf16_f32 v152, v12, v18
		v_cvt_pk_bf16_f32 v153, v13, v19
		v_cvt_pk_bf16_f32 v154, v28, v160
		v_cvt_pk_bf16_f32 v155, v29, v161
		v_cvt_pk_bf16_f32 v16, v30, v40
		v_cvt_pk_bf16_f32 v17, v31, v41
		v_cvt_pk_bf16_f32 v18, v42, v44
		v_cvt_pk_bf16_f32 v19, v43, v45
		v_cvt_pk_bf16_f32 v28, v46, v112
		v_cvt_pk_bf16_f32 v29, v47, v113
		v_cvt_pk_bf16_f32 v30, v114, v116
		v_cvt_pk_bf16_f32 v31, v115, v117
		v_cvt_pk_bf16_f32 v40, v119, v121
		v_cvt_pk_bf16_f32 v41, v162, v122
		v_cvt_pk_bf16_f32 v42, v163, v123
		v_cvt_pk_bf16_f32 v43, v124, v126
		v_cvt_pk_bf16_f32 v44, v125, v127
		v_cvt_pk_bf16_f32 v45, v128, v130
		v_cvt_pk_bf16_f32 v46, v129, v131
		v_cvt_pk_bf16_f32 v47, v132, v134
		v_cvt_pk_bf16_f32 v112, v133, v135
		v_cvt_pk_bf16_f32 v113, v136, v138
		v_cvt_pk_bf16_f32 v114, v137, v139
		v_cvt_pk_bf16_f32 v115, v140, v142
		v_cvt_pk_bf16_f32 v116, v141, v143
		v_cvt_pk_bf16_f32 v117, v144, v146
		v_cvt_pk_bf16_f32 v118, v145, v147
		v_cvt_pk_bf16_f32 v119, v148, v150
		v_permlane32_swap_b32_e32 v36, v38
		v_permlane32_swap_b32_e32 v37, v39
		v_permlane32_swap_b32_e32 v152, v154
		v_permlane32_swap_b32_e32 v153, v155
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_mfma_f32_32x32x16_bf16 v[224:239], v[24:27], v[36:39], v[224:239]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_permlane32_swap_b32_e32 v40, v42
		v_permlane32_swap_b32_e32 v41, v43
		v_permlane32_swap_b32_e32 v44, v46
		v_permlane32_swap_b32_e32 v45, v47
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_rcp_f32_e32 v6, v22
		v_rcp_f32_e32 v12, v23
		v_mfma_f32_32x32x16_bf16 v[48:63], v[168:171], v[36:39], v[48:63]
		s_mul_i32 s1, s16, s23
		s_lshl_b32 s1, s1, 9
		s_mul_i32 s2, s17, s21
		s_lshl_b32 s2, s2, 1
		s_add_i32 s3, s1, s2
		s_mul_i32 s0, s0, s22
		s_lshl_b32 s0, s0, 1
		v_mfma_f32_32x32x16_bf16 v[64:79], v[180:183], v[36:39], v[64:79]
		s_add_i32 s3, s3, s0
		v_mul_lo_u32 v0, s23, v9
		v_lshlrev_b32_e32 v0, 7, v0
		v_mul_lo_u32 v7, s23, v15
		v_lshlrev_b32_e32 v8, 1, v7
		v_add3_u32 v7, s3, v0, v8
		v_mul_lo_u32 v9, s23, v11
		v_mfma_f32_32x32x16_bf16 v[80:95], v[192:195], v[36:39], v[80:95]
		v_lshlrev_b32_e32 v9, 6, v9
		v_mul_lo_u32 v5, s23, v5
		v_lshlrev_b32_e32 v5, 5, v5
		v_add3_u32 v7, v7, v9, v5
		v_mul_lo_u32 v4, s23, v4
		v_lshlrev_b32_e32 v4, 4, v4
		v_mul_lo_u32 v3, s23, v3
		v_mfma_f32_32x32x16_bf16 v[240:255], v[192:195], v[40:43], v[240:255]
		v_lshlrev_b32_e32 v3, 3, v3
		v_add3_u32 v7, v7, v4, v3
		v_mul_lo_u32 v2, s23, v2
		v_lshlrev_b32_e32 v2, 2, v2
		v_add3_u32 v7, v7, v2, v1
		v_cndmask_b32_e64 v10, v20, v7, s[26:27]
		v_mfma_f32_32x32x16_bf16 v[96:111], v[24:27], v[40:43], v[96:111]
		v_mfma_f32_32x32x16_bf16 a[0:15], v[168:171], v[40:43], a[0:15]
		v_mfma_f32_32x32x16_bf16 a[16:31], v[180:183], v[40:43], a[16:31]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[32:35], v[152:155], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[48:63], v[172:175], v[152:155], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], v[184:187], v[152:155], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], v[196:199], v[152:155], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[196:199], v[44:47], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[96:111], v[32:35], v[44:47], v[96:111]
		v_mfma_f32_32x32x16_bf16 a[0:15], v[172:175], v[44:47], a[0:15]
		v_mfma_f32_32x32x16_bf16 a[16:31], v[184:187], v[44:47], a[16:31]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[164:167], v[16:19], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[48:63], v[176:179], v[16:19], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], v[188:191], v[16:19], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], v[200:203], v[16:19], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[200:203], v[112:115], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[96:111], v[164:167], v[112:115], v[96:111]
		v_mfma_f32_32x32x16_bf16 a[0:15], v[176:179], v[112:115], a[0:15]
		v_mfma_f32_32x32x16_bf16 a[16:31], v[188:191], v[112:115], a[16:31]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[128:131], v[28:31], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[132:135], v[28:31], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[136:139], v[28:31], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], v[204:207], v[28:31], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[204:207], v[116:119], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[128:131], v[116:119], v[96:111]
		v_mfma_f32_32x32x16_bf16 a[0:15], a[132:135], v[116:119], a[0:15]
		v_mfma_f32_32x32x16_bf16 a[16:31], a[136:139], v[116:119], a[16:31]
		s_add_i32 s3, s1, 32
		s_add_i32 s3, s3, s2
		s_add_i32 s3, s3, s0
		v_add3_u32 v7, s3, v0, v8
		v_add3_u32 v11, v7, v9, v5
		v_mov_b32_e32 v7, v6
		v_pk_mul_f32 v[14:15], v[224:225], v[6:7]
		v_pk_mul_f32 v[16:17], v[226:227], v[6:7]
		v_pk_mul_f32 v[18:19], v[228:229], v[6:7]
		v_pk_mul_f32 v[22:23], v[230:231], v[6:7]
		v_pk_mul_f32 v[24:25], v[232:233], v[6:7]
		v_pk_mul_f32 v[26:27], v[234:235], v[6:7]
		v_pk_mul_f32 v[28:29], v[236:237], v[6:7]
		v_pk_mul_f32 v[30:31], v[238:239], v[6:7]
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
		v_accvgpr_read_b32 v94, a0
		v_accvgpr_read_b32 v95, a1
		v_pk_mul_f32 v[96:97], v[94:95], v[12:13]
		v_accvgpr_read_b32 v94, a2
		v_accvgpr_read_b32 v95, a3
		v_pk_mul_f32 v[98:99], v[94:95], v[12:13]
		v_accvgpr_read_b32 v94, a4
		v_accvgpr_read_b32 v95, a5
		v_pk_mul_f32 v[100:101], v[94:95], v[12:13]
		v_accvgpr_read_b32 v94, a6
		v_accvgpr_read_b32 v95, a7
		v_pk_mul_f32 v[102:103], v[94:95], v[12:13]
		v_accvgpr_read_b32 v94, a8
		v_accvgpr_read_b32 v95, a9
		v_pk_mul_f32 v[104:105], v[94:95], v[12:13]
		v_accvgpr_read_b32 v94, a10
		v_accvgpr_read_b32 v95, a11
		v_pk_mul_f32 v[106:107], v[94:95], v[12:13]
		v_accvgpr_read_b32 v94, a12
		v_accvgpr_read_b32 v95, a13
		v_pk_mul_f32 v[108:109], v[94:95], v[12:13]
		v_accvgpr_read_b32 v94, a14
		v_accvgpr_read_b32 v95, a15
		v_pk_mul_f32 v[110:111], v[94:95], v[12:13]
		v_accvgpr_read_b32 v94, a16
		v_accvgpr_read_b32 v95, a17
		v_pk_mul_f32 v[112:113], v[94:95], v[12:13]
		v_accvgpr_read_b32 v94, a18
		v_accvgpr_read_b32 v95, a19
		v_pk_mul_f32 v[114:115], v[94:95], v[12:13]
		v_accvgpr_read_b32 v94, a20
		v_accvgpr_read_b32 v95, a21
		v_pk_mul_f32 v[116:117], v[94:95], v[12:13]
		v_accvgpr_read_b32 v94, a22
		v_accvgpr_read_b32 v95, a23
		v_pk_mul_f32 v[118:119], v[94:95], v[12:13]
		v_accvgpr_read_b32 v94, a24
		v_accvgpr_read_b32 v95, a25
		v_pk_mul_f32 v[120:121], v[94:95], v[12:13]
		v_accvgpr_read_b32 v94, a26
		v_accvgpr_read_b32 v95, a27
		v_pk_mul_f32 v[122:123], v[94:95], v[12:13]
		v_accvgpr_read_b32 v94, a28
		v_accvgpr_read_b32 v95, a29
		v_pk_mul_f32 v[124:125], v[94:95], v[12:13]
		v_accvgpr_read_b32 v94, a30
		v_accvgpr_read_b32 v95, a31
		v_pk_mul_f32 v[126:127], v[94:95], v[12:13]
		v_pk_mul_f32 v[94:95], v[240:241], v[12:13]
		v_pk_mul_f32 v[128:129], v[242:243], v[12:13]
		v_pk_mul_f32 v[130:131], v[244:245], v[12:13]
		v_pk_mul_f32 v[132:133], v[246:247], v[12:13]
		v_pk_mul_f32 v[134:135], v[248:249], v[12:13]
		v_pk_mul_f32 v[136:137], v[250:251], v[12:13]
		v_pk_mul_f32 v[138:139], v[252:253], v[12:13]
		v_pk_mul_f32 v[140:141], v[254:255], v[12:13]
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
		v_cvt_pk_bf16_f32 v52, v96, v97
		v_cvt_pk_bf16_f32 v53, v98, v99
		v_cvt_pk_bf16_f32 v54, v100, v101
		v_cvt_pk_bf16_f32 v55, v102, v103
		v_cvt_pk_bf16_f32 v56, v104, v105
		v_cvt_pk_bf16_f32 v57, v106, v107
		v_cvt_pk_bf16_f32 v58, v108, v109
		v_cvt_pk_bf16_f32 v59, v110, v111
		v_cvt_pk_bf16_f32 v60, v112, v113
		v_cvt_pk_bf16_f32 v61, v114, v115
		v_cvt_pk_bf16_f32 v62, v116, v117
		v_cvt_pk_bf16_f32 v63, v118, v119
		v_cvt_pk_bf16_f32 v64, v120, v121
		v_cvt_pk_bf16_f32 v65, v122, v123
		v_cvt_pk_bf16_f32 v66, v124, v125
		v_cvt_pk_bf16_f32 v67, v126, v127
		v_cvt_pk_bf16_f32 v68, v94, v95
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
		.amdhsa_next_free_vgpr 432
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
	.set .L_attn_fwd_async_prefetch.num_agpr, 176
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
    .vgpr_count:     432
    .agpr_count:     176
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 40
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
