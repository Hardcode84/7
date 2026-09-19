	.text
	.amdgcn_target "amdgcn-amd-amdhsa--gfx950"
	.amdhsa_code_object_version 6

	.globl	_attn_fwd_persistent
	.p2align	8
	.type	_attn_fwd_persistent,@function
_attn_fwd_persistent:
		s_load_dwordx2 s[2:3], s[0:1], 0x0
		s_load_dwordx2 s[4:5], s[0:1], 0x8
		s_load_dwordx2 s[6:7], s[0:1], 0x10
		s_load_dwordx2 s[8:9], s[0:1], 0x18
		s_load_dwordx2 s[10:11], s[0:1], 0x20
		s_load_dwordx2 s[12:13], s[0:1], 0x28
		s_load_dwordx2 s[14:15], s[0:1], 0x30
		s_waitcnt lgkmcnt(0)
		s_branch .L_attn_fwd_persistent.kernarg_preload_entry
	.p2align	8
.L_attn_fwd_persistent.kernarg_preload_entry:
	; wave backend: WaveAMDMachine MLIR pipeline finalized
		s_load_dword s17, s[0:1], 0x38
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v1, s17
		v_accvgpr_write_b32 a0, v1
		s_load_dword s17, s[0:1], 0x3c
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v1, s17
		v_accvgpr_write_b32 a1, v1
		s_load_dword s17, s[0:1], 0x40
		s_load_dword s18, s[0:1], 0x44
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v1, s18
		v_accvgpr_write_b32 a2, v1
		s_load_dword s18, s[0:1], 0x48
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v1, s18
		v_accvgpr_write_b32 a3, v1
		s_load_dword s18, s[0:1], 0x4c
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v1, s18
		v_accvgpr_write_b32 a4, v1
		s_load_dword s18, s[0:1], 0x50
		s_load_dword s19, s[0:1], 0x54
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v1, s19
		v_accvgpr_write_b32 a5, v1
		s_load_dword s19, s[0:1], 0x58
		s_load_dword s20, s[0:1], 0x5c
		s_load_dword s21, s[0:1], 0x60
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v1, s21
		v_accvgpr_write_b32 a6, v1
		s_and_b32 s0, s16, 7
		v_mov_b32_e32 v1, s0
		v_accvgpr_write_b32 a7, v1
		s_lshr_b32 s0, s16, 3
		v_accvgpr_read_b32 v1, a5
		s_nop 0
		v_readfirstlane_b32 s1, v1
		s_mul_i32 s1, s18, s1
		s_nop 0
		v_mov_b32_e32 v1, s1
		v_accvgpr_write_b32 a8, v1
		v_accvgpr_read_b32 v1, a8
		s_nop 0
		v_readfirstlane_b32 s1, v1
		s_add_i32 s1, s1, 7
		s_mov_b32 s16, 1
		s_mov_b32 s18, 7
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s18, s18, 0
		s_add_i32 s1, s1, s18
		s_ashr_i32 s1, s1, 3
		s_mul_i32 s1, s1, 16
		v_mov_b32_e32 v1, s1
		v_accvgpr_write_b32 a9, v1
		v_accvgpr_read_b32 v1, a9
		s_nop 0
		v_readfirstlane_b32 s1, v1
		s_cmp_lt_i32 s0, s1
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_0
.L_attn_fwd_persistent.loop_head_0:
		s_lshr_b32 s1, s0, 4
		s_and_b32 s18, s0, 15
		s_mul_i32 s1, s1, 8
		v_accvgpr_read_b32 v1, a7
		s_nop 0
		v_readfirstlane_b32 s21, v1
		s_add_i32 s1, s21, s1
		v_accvgpr_read_b32 v1, a8
		s_nop 0
		v_readfirstlane_b32 s21, v1
		s_cmp_lt_i32 s1, s21
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_0
		s_ashr_i32 s21, s1, 31
		s_xor_b32 s1, s1, s21
		s_sub_i32 s1, s1, s21
		v_accvgpr_read_b32 v1, a5
		s_nop 0
		v_readfirstlane_b32 s22, v1
		s_ashr_i32 s22, s22, 31
		v_accvgpr_read_b32 v1, a5
		s_nop 0
		v_readfirstlane_b32 s23, v1
		s_xor_b32 s23, s23, s22
		s_sub_i32 s23, s23, s22
		s_xor_b32 s22, s21, s22
		v_mov_b32_e32 v1, s23
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		v_mov_b32_e32 v2, 0x4f7ffffe
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_mul_i32 s18, s18, 2
		v_readfirstlane_b32 s24, v1
		s_mov_b32 s27, 0
		s_sub_i32 s25, s27, s23
		s_mul_i32 s25, s25, s24
		s_mul_hi_u32 s25, s24, s25
		s_add_i32 s24, s24, s25
		s_mul_hi_u32 s24, s1, s24
		s_mul_i32 s25, s24, s23
		s_sub_i32 s1, s1, s25
		s_add_i32 s25, s24, 1
		s_sub_i32 s26, s1, s23
		s_cmp_ge_u32 s1, s23
		s_cselect_b32 s24, s25, s24
		s_cselect_b32 s1, s26, s1
		s_add_i32 s25, s24, 1
		s_cmp_ge_u32 s1, s23
		s_cselect_b32 s24, s25, s24
		s_cselect_b32 s25, 1, 0
		s_xor_b32 s24, s24, s22
		s_sub_i32 s22, s24, s22
		v_mov_b32_e32 v1, s22
		v_accvgpr_write_b32 a10, v1
		s_sub_i32 s22, s1, s23
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s1, s22, s1
		s_xor_b32 s1, s1, s21
		s_sub_i32 s1, s1, s21
		v_mov_b32_e32 v1, s1
		v_accvgpr_write_b32 a11, v1
		s_cmp_lt_i32 s18, 32
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_1
		s_lshr_b32 s1, s18, 1
		s_and_b32 s18, s18, 1
		s_mov_b32 s21, 31
		s_sub_i32 s21, s21, s1
		s_cmp_eq_u32 s18, 0
		s_cselect_b32 s1, s1, s21
		v_mov_b32_e32 v1, s1
		v_accvgpr_write_b32 a12, v1
		v_accvgpr_read_b32 v1, a12
		s_nop 0
		v_readfirstlane_b32 s1, v1
		s_mul_i32 s1, s1, 0x100
		v_lshrrev_b32_e32 v1, 3, v0
		v_and_b32_e32 v2, 1, v1
		v_lshrrev_b32_e32 v3, 4, v0
		v_and_b32_e32 v4, 1, v3
		v_lshrrev_b32_e32 v5, 6, v0
		v_and_b32_e32 v5, 1, v5
		v_lshrrev_b32_e32 v6, 7, v0
		v_and_b32_e32 v6, 1, v6
		v_mov_b32_e32 v7, 2
		v_mul_lo_u32 v7, v7, v4
		v_lshrrev_b32_e32 v8, 5, v0
		v_and_b32_e32 v9, 1, v8
		v_mov_b32_e32 v10, 4
		v_mul_lo_u32 v10, v10, v9
		v_bitop3_b32 v11, v2, v7, v10 bitop3:0x96
		v_mov_b32_e32 v12, 8
		v_mul_lo_u32 v12, v12, v5
		v_xor_b32_e32 v11, v11, v12
		v_mov_b32_e32 v13, 16
		v_mul_lo_u32 v13, v13, v6
		v_xad_u32 v11, v11, v13, s1
		v_readfirstlane_b32 s18, v0
		v_cmp_lt_i32_e64 s[22:23], v11, s19
		s_mov_b32 s30, 0x7fffffff
		s_mov_b32 s31, 0x31016000
		s_mov_b32 s28, s4
		s_mov_b32 s29, s5
		s_mov_b32 s32, s6
		s_mov_b32 s33, s7
		s_mov_b32 s34, s30
		s_mov_b32 s35, s31
		v_accvgpr_read_b32 v11, a12
		s_nop 0
		v_readfirstlane_b32 s21, v11
		s_mul_i32 s21, s21, s12
		s_lshl_b32 s21, s21, 9
		v_accvgpr_read_b32 v11, a10
		s_nop 0
		v_readfirstlane_b32 s24, v11
		s_mul_i32 s24, s24, s10
		s_lshl_b32 s24, s24, 1
		s_add_i32 s25, s21, s24
		v_accvgpr_read_b32 v11, a11
		s_nop 0
		v_readfirstlane_b32 s26, v11
		s_mul_i32 s26, s26, s11
		s_lshl_b32 s26, s26, 1
		s_add_i32 s25, s25, s26
		v_mul_lo_u32 v11, s12, v1
		v_lshlrev_b32_e32 v11, 1, v11
		v_and_b32_e32 v14, 7, v0
		v_lshlrev_b32_e32 v14, 4, v14
		v_add3_u32 v15, s25, v11, v14
		v_mov_b32_e32 v16, 0x7fffffff
		v_accvgpr_write_b32 a13, v16
		v_accvgpr_read_b32 v16, a13
		v_cndmask_b32_e64 v15, v16, v15, s[22:23]
		s_mov_b32 s36, s2
		s_mov_b32 s37, s3
		s_mov_b32 s38, s30
		s_mov_b32 s39, s31
		buffer_load_dwordx4 v[16:19], v15, s[36:39], 0 offen
		v_bitop3_b32 v15, 32, v2, v7 bitop3:0x96
		v_bitop3_b32 v15, v15, v10, v12 bitop3:0x96
		v_xad_u32 v15, v15, v13, s1
		v_and_b32_e32 v20, 1, v0
		v_cmp_lt_i32_e64 s[22:23], v15, s19
		s_lshl_b32 s25, s12, 6
		s_add_i32 s25, s25, s21
		s_add_i32 s25, s25, s24
		s_add_i32 s25, s25, s26
		v_add3_u32 v15, s25, v11, v14
		v_accvgpr_read_b32 v21, a13
		v_cndmask_b32_e64 v15, v21, v15, s[22:23]
		buffer_load_dwordx4 v[24:27], v15, s[36:39], 0 offen
		v_bitop3_b32 v15, 64, v2, v7 bitop3:0x96
		v_bitop3_b32 v15, v15, v10, v12 bitop3:0x96
		v_xad_u32 v15, v15, v13, s1
		v_lshrrev_b32_e32 v21, 1, v0
		v_cmp_lt_i32_e64 s[22:23], v15, s19
		s_lshl_b32 s25, s12, 7
		s_add_i32 s25, s25, s21
		s_add_i32 s25, s25, s24
		s_add_i32 s25, s25, s26
		v_add3_u32 v15, s25, v11, v14
		v_accvgpr_read_b32 v22, a13
		v_cndmask_b32_e64 v15, v22, v15, s[22:23]
		buffer_load_dwordx4 v[28:31], v15, s[36:39], 0 offen
		v_xor_b32_e32 v15, 0x60, v2
		v_xor_b32_e32 v15, v15, v7
		v_xor_b32_e32 v15, v15, v10
		v_xor_b32_e32 v15, v15, v12
		v_xad_u32 v15, v15, v13, s1
		v_and_b32_e32 v22, 1, v21
		v_cmp_lt_i32_e64 s[22:23], v15, s19
		s_mul_i32 s25, 0xc0, s12
		s_add_i32 s25, s25, s21
		s_add_i32 s25, s25, s24
		s_add_i32 s25, s25, s26
		v_add3_u32 v15, s25, v11, v14
		v_accvgpr_read_b32 v23, a13
		v_cndmask_b32_e64 v15, v23, v15, s[22:23]
		buffer_load_dwordx4 v[32:35], v15, s[36:39], 0 offen
		v_xor_b32_e32 v15, 0x80, v2
		v_xor_b32_e32 v15, v15, v7
		v_xor_b32_e32 v15, v15, v10
		v_xor_b32_e32 v15, v15, v12
		v_xad_u32 v15, v15, v13, s1
		v_mov_b32_e32 v23, 2
		v_mul_lo_u32 v23, v23, v22
		v_cmp_lt_i32_e64 s[22:23], v15, s19
		s_lshl_b32 s25, s12, 8
		s_add_i32 s25, s25, s21
		s_add_i32 s25, s25, s24
		s_add_i32 s25, s25, s26
		v_add3_u32 v15, s25, v11, v14
		v_accvgpr_read_b32 v22, a13
		v_cndmask_b32_e64 v15, v22, v15, s[22:23]
		buffer_load_dwordx4 v[36:39], v15, s[36:39], 0 offen
		v_xor_b32_e32 v15, 0xa0, v2
		v_xor_b32_e32 v15, v15, v7
		v_xor_b32_e32 v15, v15, v10
		v_xor_b32_e32 v15, v15, v12
		v_xad_u32 v15, v15, v13, s1
		v_lshrrev_b32_e32 v22, 2, v0
		v_cmp_lt_i32_e64 s[22:23], v15, s19
		s_mul_i32 s25, 0x140, s12
		s_add_i32 s25, s25, s21
		s_add_i32 s25, s25, s24
		s_add_i32 s25, s25, s26
		v_add3_u32 v15, s25, v11, v14
		v_accvgpr_read_b32 v40, a13
		v_cndmask_b32_e64 v15, v40, v15, s[22:23]
		buffer_load_dwordx4 v[40:43], v15, s[36:39], 0 offen
		v_xor_b32_e32 v15, 0xc0, v2
		v_xor_b32_e32 v15, v15, v7
		v_xor_b32_e32 v15, v15, v10
		v_xor_b32_e32 v15, v15, v12
		v_xad_u32 v15, v15, v13, s1
		v_and_b32_e32 v44, 1, v22
		v_cmp_lt_i32_e64 s[22:23], v15, s19
		s_mul_i32 s25, 0x180, s12
		s_add_i32 s25, s25, s21
		s_add_i32 s25, s25, s24
		s_add_i32 s25, s25, s26
		v_add3_u32 v15, s25, v11, v14
		v_accvgpr_read_b32 v45, a13
		v_cndmask_b32_e64 v15, v45, v15, s[22:23]
		buffer_load_dwordx4 v[48:51], v15, s[36:39], 0 offen
		v_xor_b32_e32 v15, 0xe0, v2
		v_xor_b32_e32 v7, v15, v7
		v_xor_b32_e32 v7, v7, v10
		v_xor_b32_e32 v7, v7, v12
		v_xad_u32 v7, v7, v13, s1
		s_mul_i32 s22, 0x1c0, s12
		s_add_i32 s21, s22, s21
		s_add_i32 s21, s21, s24
		s_add_i32 s21, s21, s26
		v_add3_u32 v11, s21, v11, v14
		v_cmp_lt_i32_e64 vcc, v7, s19
		v_mov_b32_e32 v7, 4
		v_mul_lo_u32 v7, v7, v44
		v_accvgpr_read_b32 v12, a13
		v_cndmask_b32_e32 v11, v12, v11, vcc
		buffer_load_dwordx4 v[44:47], v11, s[36:39], 0 offen
		v_bitop3_b32 v11, v20, v23, v7 bitop3:0x96
		v_mov_b32_e32 v12, 8
		v_mul_lo_u32 v12, v12, v2
		v_xor_b32_e32 v11, v11, v12
		v_mov_b32_e32 v13, 16
		v_mul_lo_u32 v13, v13, v4
		v_mov_b32_e32 v15, 32
		v_mul_lo_u32 v15, v15, v5
		v_bitop3_b32 v11, v11, v13, v15 bitop3:0x96
		v_mov_b32_e32 v52, 64
		v_mul_lo_u32 v52, v52, v6
		v_xor_b32_e32 v11, v11, v52
		v_accvgpr_write_b32 a14, v11
		v_accvgpr_read_b32 v11, a14
		v_add_u32_e32 v11, s1, v11
		v_xor_b32_e32 v20, 0x80, v20
		v_xor_b32_e32 v20, v20, v23
		v_xor_b32_e32 v7, v20, v7
		v_bitop3_b32 v7, v7, v12, v13 bitop3:0x96
		v_bitop3_b32 v7, v7, v15, v52 bitop3:0x96
		v_accvgpr_write_b32 a15, v7
		s_lshr_b32 s18, s18, 6
		v_mov_b32_e32 v7, s18
		v_accvgpr_write_b32 a16, v7
		s_waitcnt vmcnt(8)
		s_barrier
		v_and_b32_e32 v7, 5, v8
		v_bitop3_b32 v7, 4, v21, v7 bitop3:0x6a
		v_bitop3_b32 v7, 2, v1, v7 bitop3:0x6a
		v_xor_b32_e32 v7, v0, v7
		v_lshlrev_b32_e32 v7, 4, v7
		v_add_u32_e32 v7, 0x10000, v7
		s_waitcnt vmcnt(7)
		ds_write_b128 v7, v[16:19] offset:2480
		s_waitcnt vmcnt(6)
		ds_write_b128 v7, v[24:27] offset:6576
		s_waitcnt vmcnt(5)
		ds_write_b128 v7, v[28:31] offset:10672
		s_waitcnt vmcnt(4)
		ds_write_b128 v7, v[32:35] offset:14768
		v_mov_b32_e32 v12, 32
		v_mul_lo_u32 v12, v12, v4
		v_mov_b32_e32 v4, 2
		v_mul_lo_u32 v4, v4, v6
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v6, a16
		s_nop 0
		v_readfirstlane_b32 s18, v6
		s_lshl_b32 s18, s18, 12
		s_add_i32 s18, s18, 0x10000
		v_and_b32_e32 v6, 63, v0
		v_lshrrev_b32_e32 v13, 5, v6
		v_and_b32_e32 v15, 31, v6
		v_lshlrev_b32_e32 v16, 3, v15
		v_add_u32_e32 v17, v13, v16
		v_lshlrev_b32_e32 v18, 2, v15
		v_and_b32_e32 v19, 7, v6
		v_lshrrev_b32_e32 v19, 2, v19
		v_lshrrev_b32_e32 v6, 3, v6
		v_and_b32_e32 v6, 3, v6
		v_lshl_add_u32 v6, v6, 1, v19
		v_and_b32_e32 v6, 5, v6
		v_bitop3_b32 v19, 4, v18, v6 bitop3:0x6a
		v_xor_b32_e32 v17, v17, v19
		v_lshlrev_b32_e32 v17, 4, v17
		v_and_b32_e32 v19, 2, v15
		v_lshlrev_b32_e32 v20, 4, v19
		v_add3_u32 v17, s18, v17, v20
		ds_read_b128 a[20:23], v17 offset:2480
		v_add3_u32 v21, 2, v13, v16
		v_add_u32_e32 v23, 1, v18
		v_bitop3_b32 v23, 4, v23, v6 bitop3:0x6a
		v_bitop3_b32 v21, v21, v19, v23 bitop3:0x96
		v_lshl_add_u32 v21, v21, 4, s18
		ds_read_b128 a[24:27], v21 offset:2480
		v_add3_u32 v23, 4, v13, v16
		v_add_u32_e32 v24, 2, v18
		v_bitop3_b32 v24, 4, v24, v6 bitop3:0x6a
		v_xor_b32_e32 v23, v23, v24
		v_lshlrev_b32_e32 v23, 4, v23
		v_add3_u32 v20, s18, v23, v20
		ds_read_b128 a[28:31], v20 offset:2480
		v_add3_u32 v16, 6, v13, v16
		v_add_u32_e32 v18, 3, v18
		v_bitop3_b32 v6, 4, v18, v6 bitop3:0x6a
		v_bitop3_b32 v6, v16, v19, v6 bitop3:0x96
		v_lshl_add_u32 v6, v6, 4, s18
		ds_read_b128 a[32:35], v6 offset:2480
		v_and_b32_e32 v8, 1, v8
		v_accvgpr_write_b32 a17, v8
		v_and_b32_e32 v3, 1, v3
		v_and_b32_e32 v1, 1, v1
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(3)
		ds_write_b128 v7, v[36:39] offset:2480
		s_waitcnt vmcnt(2)
		ds_write_b128 v7, v[40:43] offset:6576
		s_waitcnt vmcnt(1)
		ds_write_b128 v7, v[48:51] offset:10672
		s_waitcnt vmcnt(0)
		ds_write_b128 v7, v[44:47] offset:14768
		v_and_b32_e32 v7, 1, v22
		v_accvgpr_read_b32 v8, a12
		s_nop 0
		v_readfirstlane_b32 s18, v8
		s_add_i32 s18, s18, 1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[36:39], v17 offset:2480
		ds_read_b128 a[40:43], v21 offset:2480
		ds_read_b128 a[44:47], v20 offset:2480
		ds_read_b128 a[48:51], v6 offset:2480
		s_mul_i32 s18, s18, 0x100
		v_accvgpr_read_b32 v6, a6
		s_nop 0
		v_readfirstlane_b32 s21, v6
		s_add_i32 s18, s18, s21
		s_cmp_lt_i32 s20, s18
		s_cselect_b32 s18, s20, s18
		s_add_i32 s21, s18, 0x7f
		s_mov_b32 s22, 0x7f
		s_cmp_lt_i32 s21, 0
		s_cselect_b32 s23, s22, 0
		s_add_i32 s21, s21, s23
		s_ashr_i32 s21, s21, 7
		v_accvgpr_read_b32 v6, a6
		s_nop 0
		v_readfirstlane_b32 s23, v6
		s_add_i32 s23, s1, s23
		s_cmp_lt_i32 s23, 0
		s_cselect_b32 s24, s22, 0
		s_add_i32 s23, s23, s24
		s_ashr_i32 s23, s23, 7
		s_cmp_lt_i32 s23, s21
		s_cselect_b32 s23, s23, s21
		s_cmp_gt_i32 s23, 0
		s_cselect_b32 s23, s23, 0
		v_mov_b32_e32 v6, 64
		v_mul_lo_u32 v6, v6, v2
		v_mov_b32_e32 v8, 16
		v_mul_lo_u32 v8, v8, v9
		v_bitop3_b32 v16, v6, v12, v8 bitop3:0x96
		v_bitop3_b32 v16, v16, v5, v4 bitop3:0x96
		v_accvgpr_write_b32 a18, v16
		v_bitop3_b32 v16, 4, v6, v12 bitop3:0x96
		v_xor_b32_e32 v16, v16, v8
		v_bitop3_b32 v17, 8, v6, v12 bitop3:0x96
		v_xor_b32_e32 v17, v17, v8
		v_bitop3_b32 v6, 12, v6, v12 bitop3:0x96
		v_xor_b32_e32 v6, v6, v8
		v_accvgpr_read_b32 v8, a18
		v_cmp_lt_i32_e64 s[24:25], v8, s20
		v_mov_b32_e32 v8, 16
		v_mul_lo_u32 v8, v8, v2
		v_mov_b32_e32 v2, 64
		v_mul_lo_u32 v2, v2, v9
		v_bitop3_b32 v9, v8, v12, v2 bitop3:0x96
		v_bitop3_b32 v9, v9, v5, v4 bitop3:0x96
		v_accvgpr_write_b32 a19, v9
		v_bitop3_b32 v9, 4, v8, v12 bitop3:0x96
		v_bitop3_b32 v18, 8, v8, v12 bitop3:0x96
		v_bitop3_b32 v8, 12, v8, v12 bitop3:0x96
		v_accvgpr_read_b32 v12, a19
		v_cmp_lt_i32_e64 vcc, v12, s20
		v_readfirstlane_b32 s26, v0
		v_accvgpr_read_b32 v12, a10
		s_nop 0
		v_readfirstlane_b32 s36, v12
		s_mul_i32 s36, s36, s13
		s_lshl_b32 s36, s36, 1
		v_accvgpr_read_b32 v12, a11
		s_nop 0
		v_readfirstlane_b32 s37, v12
		s_mul_i32 s37, s37, s14
		s_lshl_b32 s37, s37, 1
		s_add_i32 s38, s36, s37
		v_accvgpr_read_b32 v12, a16
		s_nop 0
		v_readfirstlane_b32 s39, v12
		s_mul_i32 s39, s15, s39
		s_lshl_b32 s39, s39, 1
		s_add_i32 s38, s38, s39
		v_accvgpr_read_b32 v12, a17
		v_mul_lo_u32 v12, s15, v12
		v_lshlrev_b32_e32 v12, 5, v12
		v_mul_lo_u32 v19, s15, v3
		v_lshlrev_b32_e32 v19, 6, v19
		v_add3_u32 v20, s38, v12, v19
		v_mul_lo_u32 v21, s15, v1
		v_lshlrev_b32_e32 v21, 7, v21
		v_add3_u32 v20, v20, v21, v14
		v_mov_b32_e32 v22, 0x80000000
		v_cndmask_b32_e64 v20, v22, v20, s[24:25]
		s_lshr_b32 s38, s26, 6
		s_mul_i32 s40, 0x410, s38
		s_mov_b32 m0, s40
		v_accvgpr_read_b32 v23, a15
		v_add_u32_e32 v23, s1, v23
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		s_lshl_b32 s41, s15, 3
		s_add_i32 s41, s41, s36
		s_add_i32 s41, s41, s37
		s_add_i32 s41, s41, s39
		v_add3_u32 v20, s41, v12, v19
		v_add3_u32 v20, v20, v21, v14
		v_cndmask_b32_e64 v20, v22, v20, s[24:25]
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[42:43], v11, s19
		s_nop 1
		v_mov_b32_e32 v24, s42
		v_mov_b32_e32 v25, s43
		v_accvgpr_write_b32 a52, v24
		v_accvgpr_write_b32 a53, v25
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		v_bitop3_b32 v11, v16, v5, v4 bitop3:0x96
		v_accvgpr_write_b32 a54, v11
		s_lshl_b32 s41, s15, 4
		s_add_i32 s41, s41, s36
		s_add_i32 s41, s41, s37
		s_add_i32 s41, s41, s39
		v_add3_u32 v11, s41, v12, v19
		v_add3_u32 v11, v11, v21, v14
		v_cndmask_b32_e64 v11, v22, v11, s[24:25]
		s_add_i32 m0, m0, 0x1040
		v_lshlrev_b32_e32 v13, 4, v13
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		v_bitop3_b32 v11, v17, v5, v4 bitop3:0x96
		v_accvgpr_write_b32 a55, v11
		s_mul_i32 s41, 24, s15
		s_add_i32 s41, s41, s36
		s_add_i32 s41, s41, s37
		s_add_i32 s41, s41, s39
		v_add3_u32 v11, s41, v12, v19
		v_add3_u32 v11, v11, v21, v14
		v_cndmask_b32_e64 v11, v22, v11, s[24:25]
		s_add_i32 m0, m0, 0x1040
		v_mov_b32_e32 v16, 0x440
		v_mul_lo_u32 v16, v16, v7
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		v_bitop3_b32 v6, v6, v5, v4 bitop3:0x96
		v_accvgpr_write_b32 a56, v6
		v_accvgpr_read_b32 v6, a0
		s_nop 0
		v_readfirstlane_b32 s24, v6
		v_accvgpr_read_b32 v6, a10
		s_nop 0
		v_readfirstlane_b32 s25, v6
		s_mul_i32 s24, s25, s24
		s_lshl_b32 s24, s24, 1
		v_accvgpr_read_b32 v6, a1
		s_nop 0
		v_readfirstlane_b32 s25, v6
		v_accvgpr_read_b32 v6, a11
		s_nop 0
		v_readfirstlane_b32 s41, v6
		s_mul_i32 s25, s41, s25
		s_lshl_b32 s25, s25, 1
		s_add_i32 s41, s24, s25
		v_accvgpr_read_b32 v6, a16
		s_nop 0
		v_readfirstlane_b32 s42, v6
		s_mul_i32 s42, s17, s42
		s_lshl_b32 s42, s42, 1
		s_add_i32 s41, s41, s42
		v_accvgpr_read_b32 v6, a17
		v_mul_lo_u32 v6, s17, v6
		v_lshlrev_b32_e32 v6, 7, v6
		v_mul_lo_u32 v7, s17, v3
		v_lshlrev_b32_e32 v7, 6, v7
		v_add3_u32 v11, s41, v6, v7
		v_mul_lo_u32 v17, s17, v1
		v_lshlrev_b32_e32 v17, 5, v17
		v_add3_u32 v11, v11, v17, v14
		v_cndmask_b32_e32 v11, v22, v11, vcc
		s_mul_i32 s38, 0x440, s38
		s_add_i32 m0, s38, 0x81f0
		v_xor_b32_e32 v9, v9, v2
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		v_bitop3_b32 v9, v9, v5, v4 bitop3:0x96
		v_accvgpr_write_b32 a57, v9
		s_lshl_b32 s41, s17, 3
		s_add_i32 s41, s41, s24
		s_add_i32 s41, s41, s25
		s_add_i32 s41, s41, s42
		v_add3_u32 v9, s41, v6, v7
		v_add3_u32 v9, v9, v17, v14
		v_cndmask_b32_e32 v9, v22, v9, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v11, v18, v2
		buffer_load_dwordx4 v9, s[32:35], 0 offen lds
		v_bitop3_b32 v9, v11, v5, v4 bitop3:0x96
		v_accvgpr_write_b32 a58, v9
		s_lshl_b32 s41, s17, 4
		s_add_i32 s41, s41, s24
		s_add_i32 s41, s41, s25
		s_add_i32 s41, s41, s42
		v_add3_u32 v9, s41, v6, v7
		v_add3_u32 v9, v9, v17, v14
		v_cndmask_b32_e32 v9, v22, v9, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v2, v8, v2
		buffer_load_dwordx4 v9, s[32:35], 0 offen lds
		v_bitop3_b32 v2, v2, v5, v4 bitop3:0x96
		v_accvgpr_write_b32 a59, v2
		s_mul_i32 s41, 24, s17
		s_add_i32 s41, s41, s24
		s_add_i32 s41, s41, s25
		s_add_i32 s41, s41, s42
		v_add3_u32 v2, s41, v6, v7
		v_add3_u32 v2, v2, v17, v14
		v_cndmask_b32_e32 v2, v22, v2, vcc
		s_add_i32 m0, m0, 0x1100
		v_cmp_lt_i32_e64 s[44:45], v23, s19
		s_nop 1
		v_mov_b32_e32 v4, s44
		v_mov_b32_e32 v5, s45
		v_accvgpr_write_b32 a60, v4
		v_accvgpr_write_b32 a61, v5
		buffer_load_dwordx4 v2, s[32:35], 0 offen lds
		s_mul_i32 s41, s23, 0x80
		s_lshl_b32 s23, s15, 8
		s_add_i32 s23, s23, s36
		s_add_i32 s23, s23, s37
		s_add_i32 s23, s23, s39
		s_mul_i32 s43, 0x108, s15
		s_add_i32 s43, s43, s36
		s_add_i32 s43, s43, s37
		s_add_i32 s43, s43, s39
		s_mul_i32 s44, 0x110, s15
		s_add_i32 s44, s44, s36
		s_add_i32 s44, s44, s37
		s_add_i32 s44, s44, s39
		s_mul_i32 s45, 0x118, s15
		s_add_i32 s36, s45, s36
		s_add_i32 s36, s36, s37
		s_add_i32 s36, s36, s39
		s_lshl_b32 s37, s17, 8
		s_add_i32 s37, s37, s24
		s_add_i32 s37, s37, s25
		s_add_i32 s37, s37, s42
		s_mul_i32 s39, 0x108, s17
		s_add_i32 s39, s39, s24
		s_add_i32 s39, s39, s25
		s_add_i32 s39, s39, s42
		s_mul_i32 s45, 0x110, s17
		s_add_i32 s45, s45, s24
		s_add_i32 s45, s45, s25
		s_add_i32 s45, s45, s42
		s_mul_i32 s46, 0x118, s17
		s_add_i32 s24, s46, s24
		s_add_i32 s24, s24, s25
		s_add_i32 s24, s24, s42
		v_mov_b32_e32 v4, 0x3e38aa3b
		v_mov_b32_e32 v5, 0x3e38aa3b
		s_mov_b32 s25, 0xff800000
		v_mov_b32_e32 v2, s25
		v_mov_b32_e32 v8, s25
		s_mov_b32 s25, 1.0
		v_mov_b32_e32 v24, s25
		v_mov_b32_e32 v25, s25
		s_mov_b32 s25, 0
		v_lshrrev_b32_e32 v9, 4, v15
		v_lshlrev_b32_e32 v9, 9, v9
		v_and_b32_e32 v11, 15, v15
		v_mov_b32_e32 v15, 0x410
		v_mul_lo_u32 v15, v15, v11
		v_add3_u32 v9, v13, v9, v15
		v_accvgpr_write_b32 a62, v9
		v_and_b32_e32 v9, 3, v0
		v_accvgpr_read_b32 v11, a17
		v_mov_b32_e32 v13, 0x2200
		v_mul_lo_u32 v13, v13, v11
		v_lshl_add_u32 v9, v9, 3, v13
		v_lshl_add_u32 v3, v3, 5, v9
		v_mov_b32_e32 v9, 0x880
		v_mul_lo_u32 v9, v9, v1
		v_add3_u32 v1, v3, v9, v16
		v_accvgpr_write_b32 a63, v1
		s_cmp_lt_i32 0, s41
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
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_1
.L_attn_fwd_persistent.loop_head_1:
		s_waitcnt vmcnt(0)
		s_barrier
		s_lshr_b32 s42, s25, 7
		s_and_b32 s46, s42, 1
		s_mul_i32 s47, 0x4100, s46
		v_accvgpr_read_b32 v1, a62
		v_add_u32_e32 v1, s47, v1
		ds_read_b128 v[28:31], v1
		ds_read_b128 v[96:99], v1 offset:32
		ds_read_b128 v[100:103], v1 offset:64
		ds_read_b128 a[64:67], v1 offset:96
		ds_read_b128 v[104:107], v1 offset:256
		ds_read_b128 v[108:111], v1 offset:288
		ds_read_b128 v[112:115], v1 offset:320
		ds_read_b128 a[68:71], v1 offset:352
		ds_read_b128 v[116:119], v1 offset:128
		ds_read_b128 v[120:123], v1 offset:160
		ds_read_b128 v[124:127], v1 offset:192
		ds_read_b128 a[72:75], v1 offset:224
		ds_read_b128 v[128:131], v1 offset:384
		ds_read_b128 a[76:79], v1 offset:416
		ds_read_b128 a[80:83], v1 offset:448
		ds_read_b128 a[84:87], v1 offset:480
		s_mul_i32 s46, 0x4400, s46
		v_accvgpr_read_b32 v1, a63
		v_add_u32_e32 v1, s46, v1
		ds_read_b64_tr_b16 a[88:89], v1 offset:33264
		ds_read_b64_tr_b16 a[90:91], v1 offset:37616
		ds_read_b64_tr_b16 a[92:93], v1 offset:33392
		ds_read_b64_tr_b16 a[94:95], v1 offset:37744
		ds_read_b64_tr_b16 a[96:97], v1 offset:33520
		ds_read_b64_tr_b16 a[98:99], v1 offset:37872
		ds_read_b64_tr_b16 a[100:101], v1 offset:33648
		ds_read_b64_tr_b16 a[102:103], v1 offset:38000
		ds_read_b64_tr_b16 a[104:105], v1 offset:33776
		ds_read_b64_tr_b16 a[106:107], v1 offset:38128
		ds_read_b64_tr_b16 a[108:109], v1 offset:33904
		ds_read_b64_tr_b16 a[110:111], v1 offset:38256
		ds_read_b64_tr_b16 a[112:113], v1 offset:34032
		ds_read_b64_tr_b16 a[114:115], v1 offset:38384
		ds_read_b64_tr_b16 a[116:117], v1 offset:34160
		ds_read_b64_tr_b16 a[118:119], v1 offset:38512
		ds_read_b64_tr_b16 a[120:121], v1 offset:33328
		ds_read_b64_tr_b16 a[122:123], v1 offset:37680
		ds_read_b64_tr_b16 a[124:125], v1 offset:33456
		ds_read_b64_tr_b16 a[126:127], v1 offset:37808
		ds_read_b64_tr_b16 a[128:129], v1 offset:33584
		ds_read_b64_tr_b16 a[130:131], v1 offset:37936
		ds_read_b64_tr_b16 a[132:133], v1 offset:33712
		ds_read_b64_tr_b16 a[134:135], v1 offset:38064
		ds_read_b64_tr_b16 a[136:137], v1 offset:33840
		ds_read_b64_tr_b16 a[138:139], v1 offset:38192
		ds_read_b64_tr_b16 a[140:141], v1 offset:33968
		ds_read_b64_tr_b16 a[142:143], v1 offset:38320
		ds_read_b64_tr_b16 a[144:145], v1 offset:34096
		ds_read_b64_tr_b16 a[146:147], v1 offset:38448
		ds_read_b64_tr_b16 a[148:149], v1 offset:34224
		ds_read_b64_tr_b16 a[150:151], v1 offset:38576
		s_mul_i32 s46, s15, s25
		s_lshl_b32 s46, s46, 1
		s_add_i32 s47, s23, s46
		v_add3_u32 v1, s47, v12, v19
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[20:23], 0
		v_add3_u32 v1, v1, v21, v14
		v_mfma_f32_32x32x16_bf16 v[144:159], v[96:99], a[24:27], v[144:159]
		s_add_i32 s42, s42, 1
		v_mfma_f32_32x32x16_bf16 v[144:159], v[100:103], a[28:31], v[144:159]
		s_and_b32 s42, s42, 1
		v_mfma_f32_32x32x16_bf16 v[160:175], v[28:31], a[36:39], 0
		s_mul_i32 s47, 0x4100, s42
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], a[40:43], v[160:175]
		s_add_i32 s47, s40, s47
		v_mfma_f32_32x32x16_bf16 v[160:175], v[100:103], a[44:47], v[160:175]
		s_mov_b32 m0, s47
		v_mfma_f32_32x32x16_bf16 v[176:191], v[104:107], a[20:23], 0
		s_add_i32 s47, s43, s46
		v_mfma_f32_32x32x16_bf16 v[176:191], v[108:111], a[24:27], v[176:191]
		v_add3_u32 v3, s47, v12, v19
		v_mfma_f32_32x32x16_bf16 v[176:191], v[112:115], a[28:31], v[176:191]
		v_add3_u32 v3, v3, v21, v14
		v_mfma_f32_32x32x16_bf16 v[192:207], v[104:107], a[36:39], 0
		s_add_i32 s47, s44, s46
		v_mfma_f32_32x32x16_bf16 v[192:207], v[108:111], a[40:43], v[192:207]
		v_add3_u32 v9, s47, v12, v19
		v_mfma_f32_32x32x16_bf16 v[192:207], v[112:115], a[44:47], v[192:207]
		v_add3_u32 v9, v9, v21, v14
		v_mfma_f32_32x32x16_bf16 v[96:111], v[116:119], a[20:23], 0
		s_add_i32 s46, s36, s46
		v_mfma_f32_32x32x16_bf16 v[96:111], v[120:123], a[24:27], v[96:111]
		v_add3_u32 v11, s46, v12, v19
		v_mfma_f32_32x32x16_bf16 v[96:111], v[124:127], a[28:31], v[96:111]
		v_add3_u32 v11, v11, v21, v14
		v_mfma_f32_32x32x16_bf16 v[208:223], v[116:119], a[36:39], 0
		s_mul_i32 s46, s17, s25
		v_mfma_f32_32x32x16_bf16 v[208:223], v[120:123], a[40:43], v[208:223]
		s_add_i32 s25, s25, 0x80
		v_mfma_f32_32x32x16_bf16 v[208:223], v[124:127], a[44:47], v[208:223]
		v_accvgpr_read_b32 v13, a18
		v_add_u32_e32 v13, s25, v13
		v_mfma_f32_32x32x16_bf16 v[112:127], v[128:131], a[20:23], 0
		v_accvgpr_read_b32 v15, a54
		v_add_u32_e32 v15, s25, v15
		v_mfma_f32_32x32x16_bf16 v[112:127], a[76:79], a[24:27], v[112:127]
		v_accvgpr_read_b32 v16, a55
		v_add_u32_e32 v16, s25, v16
		v_mfma_f32_32x32x16_bf16 v[112:127], a[80:83], a[28:31], v[112:127]
		v_accvgpr_read_b32 v18, a56
		v_add_u32_e32 v18, s25, v18
		v_mfma_f32_32x32x16_bf16 v[224:239], v[128:131], a[36:39], 0
		v_cmp_lt_i32_e64 s[48:49], v13, s20
		v_accvgpr_read_b32 v13, a19
		v_add_u32_e32 v13, s25, v13
		v_accvgpr_read_b32 v20, a57
		v_add_u32_e32 v20, s25, v20
		v_accvgpr_read_b32 v23, a58
		v_add_u32_e32 v23, s25, v23
		v_accvgpr_read_b32 v26, a59
		v_add_u32_e32 v26, s25, v26
		v_cmp_lt_i32_e64 vcc, v26, s20
		v_cndmask_b32_e64 v1, v22, v1, s[48:49]
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[48:49], v15, s20
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[50:51], v16, s20
		v_cndmask_b32_e64 v1, v22, v3, s[48:49]
		v_cmp_lt_i32_e64 s[48:49], v18, s20
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], a[76:79], a[40:43], v[224:239]
		v_cndmask_b32_e64 v1, v22, v9, s[50:51]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[80:83], a[44:47], v[224:239]
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v3, v22, v11, s[48:49]
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[48:49], v13, s20
		v_cmp_lt_i32_e64 s[50:51], v20, s20
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s46, s46, 1
		s_add_i32 s47, s37, s46
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[144:159], a[64:67], a[32:35], v[144:159]
		v_add3_u32 v1, s47, v6, v7
		v_mfma_f32_32x32x16_bf16 v[160:175], a[64:67], a[48:51], v[160:175]
		v_add3_u32 v1, v1, v17, v14
		v_cndmask_b32_e64 v1, v22, v1, s[48:49]
		v_cmp_lt_i32_e64 s[48:49], v23, s20
		s_mul_i32 s42, 0x4400, s42
		s_add_i32 s42, s38, s42
		s_add_i32 m0, s42, 0x81f0
		s_add_i32 s42, s39, s46
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_add3_u32 v1, s42, v6, v7
		v_add3_u32 v1, v1, v17, v14
		v_cndmask_b32_e64 v1, v22, v1, s[50:51]
		v_max3_f32 v3, v144, v145, v146
		s_add_i32 m0, m0, 0x1100
		s_add_i32 s42, s45, s46
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_add3_u32 v1, s42, v6, v7
		v_add3_u32 v1, v1, v17, v14
		v_max3_f32 v9, v148, v149, v150
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v1, v22, v1, s[48:49]
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_max3_f32 v1, v152, v153, v154
		s_add_i32 s42, s24, s46
		v_add3_u32 v11, s42, v6, v7
		v_add3_u32 v11, v11, v17, v14
		v_cndmask_b32_e32 v11, v22, v11, vcc
		v_max3_f32 v13, v156, v157, v158
		s_add_i32 m0, m0, 0x1100
		v_max3_f32 v3, v3, v147, v9
		v_max3_f32 v1, v1, v155, v13
		v_max3_f32 v1, v3, v151, v1
		v_max3_f32 v3, v160, v161, v162
		v_max3_f32 v9, v164, v165, v166
		v_max3_f32 v13, v168, v169, v170
		v_max3_f32 v15, v172, v173, v174
		v_max3_f32 v3, v3, v163, v9
		v_max3_f32 v9, v13, v171, v15
		v_max3_f32 v3, v3, v167, v9
		s_cmp_lt_i32 s25, s41
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[176:191], a[68:71], a[32:35], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[72:75], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[84:87], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[84:87], a[48:51], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[68:71], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[72:75], a[48:51], v[208:223]
		s_nop 6
		v_max3_f32 v9, v176, v177, v178
		v_max3_f32 v11, v180, v181, v182
		v_max3_f32 v13, v184, v185, v186
		v_max3_f32 v15, v188, v189, v190
		v_max3_f32 v16, v96, v97, v98
		v_max3_f32 v18, v100, v101, v102
		v_max3_f32 v20, v104, v105, v106
		v_max3_f32 v23, v108, v109, v110
		v_max3_f32 v26, v112, v113, v114
		v_max3_f32 v27, v116, v117, v118
		v_max3_f32 v28, v120, v121, v122
		v_max3_f32 v29, v124, v125, v126
		v_max3_f32 v9, v9, v179, v11
		v_max3_f32 v11, v13, v187, v15
		v_max3_f32 v13, v16, v99, v18
		v_max3_f32 v15, v20, v107, v23
		v_max3_f32 v16, v26, v115, v27
		v_max3_f32 v18, v28, v123, v29
		v_max3_f32 v9, v9, v183, v11
		v_max3_f32 v11, v13, v103, v15
		v_max3_f32 v13, v16, v119, v18
		v_max3_f32 v1, v1, v159, v9
		v_max3_f32 v9, v11, v111, v13
		v_max3_f32 v1, v1, v191, v9
		v_max_f32_e32 v26, v1, v127
		v_mov_b32_e32 v27, v26
		v_max3_f32 v1, v192, v193, v194
		v_max3_f32 v9, v196, v197, v198
		v_max3_f32 v11, v200, v201, v202
		v_max3_f32 v13, v204, v205, v206
		v_max3_f32 v15, v208, v209, v210
		v_max3_f32 v16, v212, v213, v214
		v_max3_f32 v18, v216, v217, v218
		v_max3_f32 v20, v220, v221, v222
		v_max3_f32 v23, v224, v225, v226
		v_max3_f32 v28, v228, v229, v230
		v_max3_f32 v29, v232, v233, v234
		v_max3_f32 v30, v236, v237, v238
		v_max3_f32 v1, v1, v195, v9
		v_max3_f32 v9, v11, v203, v13
		v_max3_f32 v11, v15, v211, v16
		v_max3_f32 v13, v18, v219, v20
		v_permlane32_swap_b32_e32 v26, v27
		v_max3_f32 v15, v23, v227, v28
		v_max3_f32 v16, v29, v235, v30
		v_max3_f32 v1, v1, v199, v9
		v_max3_f32 v9, v11, v215, v13
		v_max3_f32 v11, v15, v231, v16
		v_max3_f32 v1, v3, v175, v1
		v_max3_f32 v3, v9, v223, v11
		v_max3_f32 v1, v1, v207, v3
		v_max_f32_e32 v28, v1, v239
		v_mov_b32_e32 v29, v28
		v_max_f32_e32 v30, v26, v27
		v_mov_b32_e32 v26, v2
		v_permlane32_swap_b32_e32 v28, v29
		v_max_f32_e32 v31, v28, v29
		v_pk_mul_f32 v[28:29], v[30:31], v[4:5]
		v_max_f32_e32 v30, v2, v28
		v_max_f32_e32 v31, v8, v29
		v_pk_fma_f32 v[2:3], v[144:145], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[146:147], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[148:149], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[150:151], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[152:153], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[154:155], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[156:157], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[158:159], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[176:177], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[178:179], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[180:181], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[182:183], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[184:185], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[186:187], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[188:189], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[190:191], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[96:97], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[98:99], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[108:109], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[110:111], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[112:113], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[114:115], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[116:117], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[118:119], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[120:121], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[122:123], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[124:125], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[126:127], v[4:5], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[160:161], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[162:163], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[164:165], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[166:167], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[168:169], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[170:171], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[172:173], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[174:175], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[192:193], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[194:195], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[196:197], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[198:199], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[200:201], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[202:203], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[204:205], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[206:207], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[208:209], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[210:211], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[212:213], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[214:215], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[216:217], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[218:219], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[220:221], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[222:223], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[224:225], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[226:227], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[228:229], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[230:231], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[232:233], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[234:235], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[236:237], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[218:219], v[238:239], v[4:5], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v220, v2
		v_exp_f32_e32 v222, v3
		v_exp_f32_e32 v2, v28
		v_exp_f32_e32 v224, v29
		v_exp_f32_e32 v28, v128
		v_exp_f32_e32 v226, v129
		v_exp_f32_e32 v128, v130
		v_exp_f32_e32 v228, v131
		v_exp_f32_e32 v130, v132
		v_exp_f32_e32 v230, v133
		v_exp_f32_e32 v132, v134
		v_exp_f32_e32 v232, v135
		v_exp_f32_e32 v134, v136
		v_exp_f32_e32 v234, v137
		v_exp_f32_e32 v136, v138
		v_exp_f32_e32 v236, v139
		v_exp_f32_e32 v138, v140
		v_exp_f32_e32 v238, v141
		v_exp_f32_e32 v140, v142
		v_exp_f32_e32 v240, v143
		v_exp_f32_e32 v142, v144
		v_exp_f32_e32 v242, v145
		v_exp_f32_e32 v144, v146
		v_exp_f32_e32 v244, v147
		v_exp_f32_e32 v146, v148
		v_exp_f32_e32 v246, v149
		v_exp_f32_e32 v148, v150
		v_exp_f32_e32 v248, v151
		v_exp_f32_e32 v150, v152
		v_exp_f32_e32 v250, v153
		v_exp_f32_e32 v152, v154
		v_exp_f32_e32 v252, v155
		v_exp_f32_e32 v221, v156
		v_exp_f32_e32 v223, v157
		v_exp_f32_e32 v3, v96
		v_exp_f32_e32 v225, v97
		v_exp_f32_e32 v29, v98
		v_exp_f32_e32 v227, v99
		v_exp_f32_e32 v129, v100
		v_exp_f32_e32 v229, v101
		v_exp_f32_e32 v131, v102
		v_exp_f32_e32 v231, v103
		v_exp_f32_e32 v133, v104
		v_exp_f32_e32 v233, v105
		v_exp_f32_e32 v135, v106
		v_exp_f32_e32 v235, v107
		v_exp_f32_e32 v137, v108
		v_exp_f32_e32 v237, v109
		v_exp_f32_e32 v139, v110
		v_exp_f32_e32 v239, v111
		v_exp_f32_e32 v141, v112
		v_exp_f32_e32 v241, v113
		v_exp_f32_e32 v143, v114
		v_exp_f32_e32 v243, v115
		v_exp_f32_e32 v145, v116
		v_exp_f32_e32 v245, v117
		v_exp_f32_e32 v147, v118
		v_exp_f32_e32 v247, v119
		v_exp_f32_e32 v149, v120
		v_exp_f32_e32 v249, v121
		v_exp_f32_e32 v151, v122
		v_exp_f32_e32 v251, v123
		v_exp_f32_e32 v153, v124
		v_exp_f32_e32 v253, v125
		v_exp_f32_e32 v96, v158
		v_exp_f32_e32 v98, v159
		v_exp_f32_e32 v100, v160
		v_exp_f32_e32 v102, v161
		v_exp_f32_e32 v104, v162
		v_exp_f32_e32 v106, v163
		v_exp_f32_e32 v108, v164
		v_exp_f32_e32 v110, v165
		v_exp_f32_e32 v112, v166
		v_exp_f32_e32 v114, v167
		v_exp_f32_e32 v116, v168
		v_exp_f32_e32 v118, v169
		v_exp_f32_e32 v120, v170
		v_exp_f32_e32 v122, v171
		v_exp_f32_e32 v124, v172
		v_exp_f32_e32 v154, v173
		v_exp_f32_e32 v156, v174
		v_exp_f32_e32 v158, v175
		v_exp_f32_e32 v160, v176
		v_exp_f32_e32 v162, v177
		v_exp_f32_e32 v164, v178
		v_exp_f32_e32 v166, v179
		v_exp_f32_e32 v168, v180
		v_exp_f32_e32 v170, v181
		v_exp_f32_e32 v172, v182
		v_exp_f32_e32 v174, v183
		v_exp_f32_e32 v176, v184
		v_exp_f32_e32 v178, v185
		v_exp_f32_e32 v180, v186
		v_exp_f32_e32 v182, v187
		v_exp_f32_e32 v185, v188
		v_exp_f32_e32 v187, v189
		v_exp_f32_e32 v97, v190
		v_exp_f32_e32 v99, v191
		v_exp_f32_e32 v101, v192
		v_exp_f32_e32 v103, v193
		v_exp_f32_e32 v105, v194
		v_exp_f32_e32 v107, v195
		v_exp_f32_e32 v109, v196
		v_exp_f32_e32 v111, v197
		v_exp_f32_e32 v113, v198
		v_exp_f32_e32 v115, v199
		v_exp_f32_e32 v117, v200
		v_exp_f32_e32 v119, v201
		v_exp_f32_e32 v121, v202
		v_exp_f32_e32 v123, v203
		v_exp_f32_e32 v125, v204
		v_exp_f32_e32 v155, v205
		v_exp_f32_e32 v157, v206
		v_exp_f32_e32 v159, v207
		v_exp_f32_e32 v161, v208
		v_exp_f32_e32 v163, v209
		v_exp_f32_e32 v165, v210
		v_exp_f32_e32 v167, v211
		v_exp_f32_e32 v169, v212
		v_exp_f32_e32 v171, v213
		v_exp_f32_e32 v173, v214
		v_exp_f32_e32 v175, v215
		v_exp_f32_e32 v177, v216
		v_exp_f32_e32 v179, v217
		v_exp_f32_e32 v181, v218
		v_exp_f32_e32 v183, v219
		v_pk_add_f32 v[188:189], v[220:221], v[222:223]
		v_pk_add_f32 v[190:191], v[2:3], v[224:225]
		v_pk_add_f32 v[192:193], v[28:29], v[226:227]
		v_pk_add_f32 v[194:195], v[128:129], v[228:229]
		v_pk_add_f32 v[196:197], v[130:131], v[230:231]
		v_pk_add_f32 v[198:199], v[132:133], v[232:233]
		v_pk_add_f32 v[200:201], v[134:135], v[234:235]
		v_pk_add_f32 v[202:203], v[136:137], v[236:237]
		v_pk_add_f32 v[204:205], v[138:139], v[238:239]
		v_pk_add_f32 v[206:207], v[140:141], v[240:241]
		v_pk_add_f32 v[208:209], v[142:143], v[242:243]
		v_pk_add_f32 v[210:211], v[144:145], v[244:245]
		v_pk_add_f32 v[212:213], v[146:147], v[246:247]
		v_pk_add_f32 v[214:215], v[148:149], v[248:249]
		v_pk_add_f32 v[216:217], v[150:151], v[250:251]
		v_pk_add_f32 v[218:219], v[152:153], v[252:253]
		v_pk_add_f32 v[188:189], v[188:189], v[190:191]
		v_pk_add_f32 v[190:191], v[192:193], v[194:195]
		v_pk_add_f32 v[192:193], v[196:197], v[198:199]
		v_pk_add_f32 v[194:195], v[200:201], v[202:203]
		v_pk_add_f32 v[196:197], v[204:205], v[206:207]
		v_pk_add_f32 v[198:199], v[208:209], v[210:211]
		v_pk_add_f32 v[200:201], v[212:213], v[214:215]
		v_pk_add_f32 v[202:203], v[216:217], v[218:219]
		v_pk_add_f32 v[188:189], v[188:189], v[190:191]
		v_pk_add_f32 v[190:191], v[192:193], v[194:195]
		v_pk_add_f32 v[192:193], v[196:197], v[198:199]
		v_pk_add_f32 v[194:195], v[200:201], v[202:203]
		v_pk_add_f32 v[188:189], v[188:189], v[190:191]
		v_pk_add_f32 v[190:191], v[192:193], v[194:195]
		v_pk_add_f32 v[192:193], v[188:189], v[190:191]
		v_add_f32_e32 v188, v192, v193
		v_mov_b32_e32 v189, v188
		v_exp_f32_e32 v184, v126
		v_exp_f32_e32 v186, v127
		v_permlane32_swap_b32_e32 v188, v189
		v_pk_add_f32 v[126:127], v[184:185], v[186:187]
		v_pk_add_f32 v[190:191], v[96:97], v[98:99]
		v_pk_add_f32 v[192:193], v[100:101], v[102:103]
		v_pk_add_f32 v[194:195], v[104:105], v[106:107]
		v_pk_add_f32 v[196:197], v[108:109], v[110:111]
		v_pk_add_f32 v[198:199], v[112:113], v[114:115]
		v_pk_add_f32 v[200:201], v[116:117], v[118:119]
		v_pk_add_f32 v[202:203], v[120:121], v[122:123]
		v_pk_add_f32 v[204:205], v[124:125], v[154:155]
		v_pk_add_f32 v[206:207], v[156:157], v[158:159]
		v_pk_add_f32 v[208:209], v[160:161], v[162:163]
		v_pk_add_f32 v[210:211], v[164:165], v[166:167]
		v_pk_add_f32 v[212:213], v[168:169], v[170:171]
		v_pk_add_f32 v[214:215], v[172:173], v[174:175]
		v_pk_add_f32 v[216:217], v[176:177], v[178:179]
		v_pk_add_f32 v[218:219], v[180:181], v[182:183]
		v_pk_add_f32 v[126:127], v[126:127], v[190:191]
		v_pk_add_f32 v[190:191], v[192:193], v[194:195]
		v_pk_add_f32 v[192:193], v[196:197], v[198:199]
		v_pk_add_f32 v[194:195], v[200:201], v[202:203]
		v_pk_add_f32 v[196:197], v[204:205], v[206:207]
		v_pk_add_f32 v[198:199], v[208:209], v[210:211]
		v_pk_add_f32 v[200:201], v[212:213], v[214:215]
		v_pk_add_f32 v[202:203], v[216:217], v[218:219]
		v_pk_add_f32 v[126:127], v[126:127], v[190:191]
		v_pk_add_f32 v[190:191], v[192:193], v[194:195]
		v_pk_add_f32 v[192:193], v[196:197], v[198:199]
		v_pk_add_f32 v[194:195], v[200:201], v[202:203]
		v_pk_add_f32 v[126:127], v[126:127], v[190:191]
		v_pk_add_f32 v[190:191], v[192:193], v[194:195]
		v_pk_add_f32 v[192:193], v[126:127], v[190:191]
		v_mov_b32_e32 v126, v189
		v_mov_b32_e32 v127, v193
		v_mov_b32_e32 v190, v188
		v_mov_b32_e32 v191, v192
		v_pk_add_f32 v[188:189], v[190:191], v[126:127]
		v_mov_b32_e32 v126, v189
		v_mov_b32_e32 v127, v189
		v_cvt_pk_bf16_f32 v192, v220, v222
		v_cvt_pk_bf16_f32 v193, v2, v224
		v_permlane32_swap_b32_e32 v126, v127
		v_add_f32_e32 v191, v126, v127
		v_mov_b32_e32 v27, v8
		v_pk_add_f32 v[8:9], v[26:27], v[30:31] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v26, v8
		v_exp_f32_e32 v27, v9
		v_cvt_pk_bf16_f32 v194, v28, v226
		v_mov_b32_e32 v190, v188
		v_mov_b64_e32 v[8:9], v[24:25]
		v_pk_fma_f32 v[24:25], v[8:9], v[26:27], v[190:191]
		v_cvt_pk_bf16_f32 v195, v128, v228
		v_cvt_pk_bf16_f32 v188, v130, v230
		v_cvt_pk_bf16_f32 v189, v132, v232
		v_cvt_pk_bf16_f32 v190, v134, v234
		v_cvt_pk_bf16_f32 v191, v136, v236
		v_cvt_pk_bf16_f32 v196, v138, v238
		v_cvt_pk_bf16_f32 v197, v140, v240
		v_cvt_pk_bf16_f32 v198, v142, v242
		v_cvt_pk_bf16_f32 v199, v144, v244
		v_cvt_pk_bf16_f32 v200, v146, v246
		v_cvt_pk_bf16_f32 v201, v148, v248
		v_cvt_pk_bf16_f32 v202, v150, v250
		v_cvt_pk_bf16_f32 v203, v152, v252
		v_cvt_pk_bf16_f32 v204, v221, v223
		v_pk_mul_f32 v[32:33], v[32:33], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[34:35], v[34:35], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[36:37], v[36:37], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[38:39], v[38:39], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[40:41], v[40:41], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[42:43], v[42:43], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[44:45], v[44:45], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[46:47], v[46:47], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[48:49], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[50:51], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[52:53], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[54:55], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[56:57], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[58:59], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[60:61], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[62:63], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[64:65], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[66:67], v[66:67], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[68:69], v[68:69], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[70:71], v[70:71], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[72:73], v[72:73], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[74:75], v[74:75], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[76:77], v[76:77], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[78:79], v[78:79], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[80:81], v[80:81], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[82:83], v[82:83], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[84:85], v[84:85], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[86:87], v[86:87], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[88:89], v[88:89], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[90:91], v[90:91], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[92:93], v[92:93], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[94:95], v[94:95], v[26:27] op_sel:[0,1]
		v_cvt_pk_bf16_f32 v205, v3, v225
		v_cvt_pk_bf16_f32 v206, v29, v227
		v_cvt_pk_bf16_f32 v207, v129, v229
		v_cvt_pk_bf16_f32 v208, v131, v231
		v_cvt_pk_bf16_f32 v209, v133, v233
		v_cvt_pk_bf16_f32 v210, v135, v235
		v_cvt_pk_bf16_f32 v211, v137, v237
		v_cvt_pk_bf16_f32 v128, v139, v239
		v_cvt_pk_bf16_f32 v129, v141, v241
		v_cvt_pk_bf16_f32 v130, v143, v243
		v_cvt_pk_bf16_f32 v131, v145, v245
		v_cvt_pk_bf16_f32 v132, v147, v247
		v_cvt_pk_bf16_f32 v133, v149, v249
		v_cvt_pk_bf16_f32 v134, v151, v251
		v_cvt_pk_bf16_f32 v135, v153, v253
		v_cvt_pk_bf16_f32 v136, v184, v186
		v_cvt_pk_bf16_f32 v137, v96, v98
		v_cvt_pk_bf16_f32 v138, v100, v102
		v_cvt_pk_bf16_f32 v139, v104, v106
		v_cvt_pk_bf16_f32 v140, v108, v110
		v_cvt_pk_bf16_f32 v141, v112, v114
		v_cvt_pk_bf16_f32 v142, v116, v118
		v_cvt_pk_bf16_f32 v143, v120, v122
		v_cvt_pk_bf16_f32 v144, v124, v154
		v_cvt_pk_bf16_f32 v145, v156, v158
		v_cvt_pk_bf16_f32 v146, v160, v162
		v_cvt_pk_bf16_f32 v147, v164, v166
		v_cvt_pk_bf16_f32 v148, v168, v170
		v_cvt_pk_bf16_f32 v149, v172, v174
		v_cvt_pk_bf16_f32 v150, v176, v178
		v_cvt_pk_bf16_f32 v151, v180, v182
		v_cvt_pk_bf16_f32 v212, v185, v187
		v_cvt_pk_bf16_f32 v213, v97, v99
		v_cvt_pk_bf16_f32 v214, v101, v103
		v_cvt_pk_bf16_f32 v215, v105, v107
		v_cvt_pk_bf16_f32 v96, v109, v111
		v_cvt_pk_bf16_f32 v97, v113, v115
		v_cvt_pk_bf16_f32 v98, v117, v119
		v_cvt_pk_bf16_f32 v99, v121, v123
		v_cvt_pk_bf16_f32 v100, v125, v155
		v_cvt_pk_bf16_f32 v101, v157, v159
		v_cvt_pk_bf16_f32 v102, v161, v163
		v_cvt_pk_bf16_f32 v103, v165, v167
		v_cvt_pk_bf16_f32 v104, v169, v171
		v_cvt_pk_bf16_f32 v105, v173, v175
		v_cvt_pk_bf16_f32 v106, v177, v179
		v_cvt_pk_bf16_f32 v107, v181, v183
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[32:47], a[88:91], v[192:195], v[32:47]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[48:63], a[120:123], v[192:195], v[48:63]
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_mfma_f32_32x32x16_bf16 v[32:47], a[92:95], v[188:191], v[32:47]
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_mfma_f32_32x32x16_bf16 v[48:63], a[124:127], v[188:191], v[48:63]
		v_permlane32_swap_b32_e32 v208, v210
		v_permlane32_swap_b32_e32 v209, v211
		v_mfma_f32_32x32x16_bf16 v[32:47], a[96:99], v[196:199], v[32:47]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[48:63], a[128:131], v[196:199], v[48:63]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[32:47], a[100:103], v[200:203], v[32:47]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[48:63], a[132:135], v[200:203], v[48:63]
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_mfma_f32_32x32x16_bf16 v[80:95], a[120:123], v[136:139], v[80:95]
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_mfma_f32_32x32x16_bf16 v[64:79], a[88:91], v[136:139], v[64:79]
		v_permlane32_swap_b32_e32 v148, v150
		v_permlane32_swap_b32_e32 v149, v151
		v_mfma_f32_32x32x16_bf16 v[80:95], a[124:127], v[140:143], v[80:95]
		v_permlane32_swap_b32_e32 v212, v214
		v_permlane32_swap_b32_e32 v213, v215
		v_mfma_f32_32x32x16_bf16 v[64:79], a[92:95], v[140:143], v[64:79]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[80:95], a[128:131], v[144:147], v[80:95]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[64:79], a[96:99], v[144:147], v[64:79]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[80:95], a[132:135], v[148:151], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[100:103], v[148:151], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[104:107], v[204:207], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[136:139], v[204:207], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[136:139], v[212:215], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[104:107], v[212:215], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[108:111], v[208:211], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[140:143], v[208:211], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[140:143], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[108:111], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[112:115], v[128:131], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[144:147], v[128:131], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[112:115], v[100:103], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[116:119], v[132:135], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[148:151], v[132:135], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[148:151], v[104:107], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[116:119], v[104:107], v[64:79]
		v_mov_b32_e32 v2, v30
		v_mov_b32_e32 v8, v31
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_1
.L_attn_fwd_persistent.loop_exit_1:
		s_mul_i32 s21, s21, 0x80
		v_accvgpr_read_b32 v1, a14
		v_accvgpr_read_b32 v3, a6
		s_nop 0
		v_readfirstlane_b32 s25, v3
		s_nop 1
		v_add_u32_e32 v1, s25, v1
		v_add_u32_e32 v1, s1, v1
		v_accvgpr_read_b32 v3, a15
		v_accvgpr_read_b32 v9, a6
		s_nop 0
		v_readfirstlane_b32 s25, v9
		s_nop 1
		v_add_u32_e32 v3, s25, v3
		v_add_u32_e32 v3, s1, v3
		v_xor_b32_e32 v9, 1, v10
		v_accvgpr_write_b32 a14, v9
		v_xor_b32_e32 v9, 2, v10
		v_accvgpr_write_b32 a15, v9
		v_xor_b32_e32 v9, 3, v10
		v_accvgpr_write_b32 a64, v9
		v_xor_b32_e32 v9, 8, v10
		v_accvgpr_write_b32 a65, v9
		v_xor_b32_e32 v9, 9, v10
		v_accvgpr_write_b32 a66, v9
		v_xor_b32_e32 v9, 10, v10
		v_accvgpr_write_b32 a67, v9
		v_xor_b32_e32 v9, 11, v10
		v_accvgpr_write_b32 a68, v9
		v_xor_b32_e32 v9, 16, v10
		v_accvgpr_write_b32 a69, v9
		v_xor_b32_e32 v9, 17, v10
		v_accvgpr_write_b32 a70, v9
		v_xor_b32_e32 v9, 18, v10
		v_accvgpr_write_b32 a71, v9
		v_xor_b32_e32 v9, 19, v10
		v_accvgpr_write_b32 a72, v9
		v_xor_b32_e32 v9, 24, v10
		v_accvgpr_write_b32 a73, v9
		v_xor_b32_e32 v9, 25, v10
		v_accvgpr_write_b32 a74, v9
		v_xor_b32_e32 v9, 26, v10
		v_accvgpr_write_b32 a75, v9
		v_xor_b32_e32 v9, 27, v10
		v_accvgpr_write_b32 a76, v9
		v_xor_b32_e32 v9, 32, v10
		v_accvgpr_write_b32 a77, v9
		v_xor_b32_e32 v9, 33, v10
		v_accvgpr_write_b32 a78, v9
		v_xor_b32_e32 v9, 34, v10
		v_accvgpr_write_b32 a79, v9
		v_xor_b32_e32 v9, 35, v10
		v_accvgpr_write_b32 a80, v9
		v_xor_b32_e32 v9, 40, v10
		v_accvgpr_write_b32 a81, v9
		v_xor_b32_e32 v9, 41, v10
		v_accvgpr_write_b32 a82, v9
		v_xor_b32_e32 v9, 42, v10
		v_accvgpr_write_b32 a83, v9
		v_xor_b32_e32 v9, 43, v10
		v_accvgpr_write_b32 a84, v9
		v_xor_b32_e32 v9, 48, v10
		v_accvgpr_write_b32 a85, v9
		v_xor_b32_e32 v9, 49, v10
		v_accvgpr_write_b32 a86, v9
		v_xor_b32_e32 v9, 50, v10
		v_accvgpr_write_b32 a87, v9
		v_xor_b32_e32 v9, 51, v10
		v_accvgpr_write_b32 a88, v9
		v_xor_b32_e32 v9, 56, v10
		v_accvgpr_write_b32 a89, v9
		v_xor_b32_e32 v9, 57, v10
		v_accvgpr_write_b32 a90, v9
		v_xor_b32_e32 v9, 58, v10
		v_accvgpr_write_b32 a91, v9
		v_xor_b32_e32 v9, 59, v10
		v_accvgpr_write_b32 a92, v9
		v_xor_b32_e32 v9, 64, v10
		v_accvgpr_write_b32 a93, v9
		v_xor_b32_e32 v9, 0x41, v10
		v_accvgpr_write_b32 a94, v9
		v_xor_b32_e32 v9, 0x42, v10
		v_accvgpr_write_b32 a95, v9
		v_xor_b32_e32 v9, 0x43, v10
		v_accvgpr_write_b32 a96, v9
		v_xor_b32_e32 v9, 0x48, v10
		v_accvgpr_write_b32 a97, v9
		v_xor_b32_e32 v9, 0x49, v10
		v_accvgpr_write_b32 a98, v9
		v_xor_b32_e32 v9, 0x4a, v10
		v_accvgpr_write_b32 a99, v9
		v_xor_b32_e32 v9, 0x4b, v10
		v_accvgpr_write_b32 a100, v9
		v_xor_b32_e32 v9, 0x50, v10
		v_accvgpr_write_b32 a101, v9
		v_xor_b32_e32 v9, 0x51, v10
		v_accvgpr_write_b32 a102, v9
		v_xor_b32_e32 v9, 0x52, v10
		v_accvgpr_write_b32 a103, v9
		v_xor_b32_e32 v9, 0x53, v10
		v_accvgpr_write_b32 a104, v9
		v_xor_b32_e32 v9, 0x58, v10
		v_accvgpr_write_b32 a105, v9
		v_xor_b32_e32 v9, 0x59, v10
		v_accvgpr_write_b32 a106, v9
		v_xor_b32_e32 v9, 0x5a, v10
		v_accvgpr_write_b32 a107, v9
		v_xor_b32_e32 v9, 0x5b, v10
		v_accvgpr_write_b32 a108, v9
		v_xor_b32_e32 v9, 0x60, v10
		v_accvgpr_write_b32 a109, v9
		v_xor_b32_e32 v9, 0x61, v10
		v_accvgpr_write_b32 a110, v9
		v_xor_b32_e32 v9, 0x62, v10
		v_accvgpr_write_b32 a111, v9
		v_xor_b32_e32 v9, 0x63, v10
		v_accvgpr_write_b32 a112, v9
		v_xor_b32_e32 v9, 0x68, v10
		v_accvgpr_write_b32 a113, v9
		v_xor_b32_e32 v9, 0x69, v10
		v_accvgpr_write_b32 a114, v9
		v_xor_b32_e32 v9, 0x6a, v10
		v_accvgpr_write_b32 a115, v9
		v_xor_b32_e32 v9, 0x6b, v10
		v_accvgpr_write_b32 a116, v9
		v_xor_b32_e32 v9, 0x70, v10
		v_accvgpr_write_b32 a117, v9
		v_xor_b32_e32 v9, 0x71, v10
		v_accvgpr_write_b32 a118, v9
		v_xor_b32_e32 v9, 0x72, v10
		v_accvgpr_write_b32 a119, v9
		v_xor_b32_e32 v9, 0x73, v10
		v_accvgpr_write_b32 a120, v9
		v_xor_b32_e32 v9, 0x78, v10
		v_accvgpr_write_b32 a121, v9
		v_xor_b32_e32 v9, 0x79, v10
		v_accvgpr_write_b32 a122, v9
		v_xor_b32_e32 v9, 0x7a, v10
		v_accvgpr_write_b32 a123, v9
		v_xor_b32_e32 v9, 0x7b, v10
		v_accvgpr_write_b32 a124, v9
		v_mov_b32_e32 v9, 0xff800000
		s_cmp_lt_i32 s41, s21
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_2
.L_attn_fwd_persistent.loop_head_2:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s1, s41, 0x80
		s_cmp_lt_i32 s41, 0
		s_cselect_b32 s25, s22, 0
		s_add_i32 s25, s41, s25
		s_ashr_i32 s25, s25, 7
		s_cmp_lt_i32 s25, 0
		s_cselect_b32 s38, s16, 0
		s_add_i32 s38, s25, s38
		s_ashr_i32 s38, s38, 1
		s_lshl_b32 s38, s38, 1
		s_sub_i32 s38, s25, s38
		s_add_i32 s25, s25, 1
		s_cmp_lt_i32 s25, 0
		s_cselect_b32 s40, s16, 0
		s_add_i32 s40, s25, s40
		s_ashr_i32 s40, s40, 1
		s_lshl_b32 s40, s40, 1
		s_sub_i32 s46, s25, s40
		s_mul_i32 s25, 0x4100, s38
		v_accvgpr_read_b32 v11, a62
		v_add_u32_e32 v11, s25, v11
		ds_read_b128 v[28:31], v11
		ds_read_b128 a[128:131], v11 offset:32
		ds_read_b128 a[132:135], v11 offset:64
		ds_read_b128 a[136:139], v11 offset:96
		ds_read_b128 a[140:143], v11 offset:256
		ds_read_b128 a[144:147], v11 offset:288
		ds_read_b128 a[148:151], v11 offset:320
		ds_read_b128 a[152:155], v11 offset:352
		ds_read_b128 a[156:159], v11 offset:128
		ds_read_b128 a[160:163], v11 offset:160
		ds_read_b128 a[164:167], v11 offset:192
		ds_read_b128 a[168:171], v11 offset:224
		ds_read_b128 v[96:99], v11 offset:384
		ds_read_b128 a[172:175], v11 offset:416
		ds_read_b128 a[176:179], v11 offset:448
		ds_read_b128 a[180:183], v11 offset:480
		s_mul_i32 s25, 0x4400, s38
		v_accvgpr_read_b32 v11, a63
		v_add_u32_e32 v11, s25, v11
		ds_read_b64_tr_b16 a[184:185], v11 offset:33264
		ds_read_b64_tr_b16 a[186:187], v11 offset:37616
		ds_read_b64_tr_b16 a[188:189], v11 offset:33392
		ds_read_b64_tr_b16 a[190:191], v11 offset:37744
		ds_read_b64_tr_b16 a[192:193], v11 offset:33520
		ds_read_b64_tr_b16 a[194:195], v11 offset:37872
		ds_read_b64_tr_b16 a[196:197], v11 offset:33648
		ds_read_b64_tr_b16 a[198:199], v11 offset:38000
		ds_read_b64_tr_b16 a[200:201], v11 offset:33776
		ds_read_b64_tr_b16 a[202:203], v11 offset:38128
		ds_read_b64_tr_b16 a[204:205], v11 offset:33904
		ds_read_b64_tr_b16 a[206:207], v11 offset:38256
		ds_read_b64_tr_b16 a[208:209], v11 offset:34032
		ds_read_b64_tr_b16 a[210:211], v11 offset:38384
		ds_read_b64_tr_b16 a[212:213], v11 offset:34160
		ds_read_b64_tr_b16 a[214:215], v11 offset:38512
		ds_read_b64_tr_b16 a[216:217], v11 offset:33328
		ds_read_b64_tr_b16 a[218:219], v11 offset:37680
		ds_read_b64_tr_b16 a[220:221], v11 offset:33456
		ds_read_b64_tr_b16 a[222:223], v11 offset:37808
		ds_read_b64_tr_b16 a[224:225], v11 offset:33584
		ds_read_b64_tr_b16 a[226:227], v11 offset:37936
		ds_read_b64_tr_b16 a[228:229], v11 offset:33712
		ds_read_b64_tr_b16 a[230:231], v11 offset:38064
		ds_read_b64_tr_b16 a[232:233], v11 offset:33840
		ds_read_b64_tr_b16 a[234:235], v11 offset:38192
		ds_read_b64_tr_b16 a[236:237], v11 offset:33968
		ds_read_b64_tr_b16 a[238:239], v11 offset:38320
		ds_read_b64_tr_b16 a[240:241], v11 offset:34096
		ds_read_b64_tr_b16 a[242:243], v11 offset:38448
		ds_read_b64_tr_b16 a[244:245], v11 offset:34224
		ds_read_b64_tr_b16 a[246:247], v11 offset:38576
		s_cmp_lt_i32 s1, s18
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_2
		v_accvgpr_read_b32 v11, a18
		v_add_u32_e32 v11, s1, v11
		v_cmp_lt_i32_e64 s[48:49], v11, s20
		v_accvgpr_read_b32 v11, a19
		v_add_u32_e32 v11, s1, v11
		v_cmp_lt_i32_e64 s[50:51], v11, s20
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s25, s15, s41
		s_lshl_b32 s25, s25, 1
		s_add_i32 s38, s23, s25
		v_add3_u32 v11, s38, v12, v19
		v_add3_u32 v11, v11, v21, v14
		v_cndmask_b32_e64 v11, v22, v11, s[48:49]
		s_mov_b32 s48, 1
		s_mov_b32 s49, 0
		s_mul_i32 s52, s48, s26
		s_mul_hi_u32 s53, s48, s26
		s_mul_i32 s38, s48, s27
		s_add_i32 s53, s53, s38
		s_mul_i32 s38, s49, s26
		s_add_i32 s53, s53, s38
		s_lshr_b64 s[48:49], s[52:53], 6
		s_mov_b32 s52, 0x410
		s_mov_b32 s53, 0
		s_mul_i32 s54, s52, s48
		s_mul_hi_u32 s55, s52, s48
		s_mul_i32 s38, s52, s49
		s_add_i32 s55, s55, s38
		s_mul_i32 s38, s53, s48
		s_add_i32 s55, s55, s38
		s_cmp_lt_i32 s46, 0
		s_cselect_b32 s47, -1, 0
		s_mov_b32 s52, 0x4100
		s_mov_b32 s53, 0
		s_mul_i32 s56, s52, s46
		s_mul_hi_u32 s57, s52, s46
		s_mul_i32 s38, s52, s47
		s_add_i32 s57, s57, s38
		s_mul_i32 s38, s53, s46
		s_add_i32 s57, s57, s38
		s_add_u32 s52, s54, s56
		s_addc_u32 s53, s55, s57
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		v_accvgpr_read_b32 v13, a54
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v13, s20
		s_add_i32 s38, s43, s25
		v_add3_u32 v11, s38, v12, v19
		v_add3_u32 v11, v11, v21, v14
		v_cndmask_b32_e64 v11, v22, v11, s[54:55]
		s_add_u32 s54, s52, 0x1040
		s_addc_u32 s55, s53, 0
		s_add_u32 s56, s54, 0
		s_addc_u32 s57, s55, 0
		s_mov_b32 m0, s56
		v_accvgpr_read_b32 v13, a55
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v13, s20
		s_add_i32 s38, s44, s25
		v_add3_u32 v11, s38, v12, v19
		v_add3_u32 v11, v11, v21, v14
		v_cndmask_b32_e64 v11, v22, v11, s[54:55]
		s_add_u32 s54, s52, 0x2080
		s_addc_u32 s55, s53, 0
		s_add_u32 s56, s54, 0
		s_addc_u32 s57, s55, 0
		s_mov_b32 m0, s56
		v_accvgpr_read_b32 v13, a56
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v13, s20
		s_add_i32 s25, s36, s25
		v_add3_u32 v11, s25, v12, v19
		v_add3_u32 v11, v11, v21, v14
		v_cndmask_b32_e64 v11, v22, v11, s[54:55]
		s_add_u32 s52, s52, 0x30c0
		s_addc_u32 s53, s53, 0
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		v_accvgpr_read_b32 v13, a57
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		s_mul_i32 s25, s17, s41
		s_lshl_b32 s25, s25, 1
		s_add_i32 s38, s37, s25
		v_add3_u32 v11, s38, v6, v7
		v_add3_u32 v11, v11, v17, v14
		v_cndmask_b32_e64 v11, v22, v11, s[50:51]
		s_mov_b32 s50, 0x440
		s_mov_b32 s51, 0
		s_mul_i32 s52, s50, s48
		s_mul_hi_u32 s53, s50, s48
		s_mul_i32 s38, s50, s49
		s_add_i32 s53, s53, s38
		s_mul_i32 s38, s51, s48
		s_add_i32 s53, s53, s38
		s_mov_b32 s48, 0x4400
		s_mov_b32 s49, 0
		s_mul_i32 s50, s48, s46
		s_mul_hi_u32 s51, s48, s46
		s_mul_i32 s38, s48, s47
		s_add_i32 s51, s51, s38
		s_mul_i32 s38, s49, s46
		s_add_i32 s51, s51, s38
		s_add_u32 s46, s52, s50
		s_addc_u32 s47, s53, s51
		s_add_u32 s48, s46, 0x81f0
		s_addc_u32 s49, s47, 0
		s_add_u32 s50, s48, 0
		s_addc_u32 s51, s49, 0
		s_mov_b32 m0, s50
		v_accvgpr_read_b32 v15, a58
		v_add_u32_e32 v15, s1, v15
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[48:49], v13, s20
		s_add_i32 s38, s39, s25
		v_add3_u32 v11, s38, v6, v7
		v_add3_u32 v11, v11, v17, v14
		v_cndmask_b32_e64 v11, v22, v11, s[48:49]
		s_add_u32 s48, s46, 0x92f0
		s_addc_u32 s49, s47, 0
		s_add_u32 s50, s48, 0
		s_addc_u32 s51, s49, 0
		s_mov_b32 m0, s50
		v_accvgpr_read_b32 v13, a59
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[48:49], v15, s20
		s_add_i32 s38, s45, s25
		v_add3_u32 v11, s38, v6, v7
		v_add3_u32 v11, v11, v17, v14
		s_add_u32 s50, s46, 0xa3f0
		s_addc_u32 s51, s47, 0
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		v_cndmask_b32_e64 v11, v22, v11, s[48:49]
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		s_add_i32 s25, s24, s25
		v_add3_u32 v11, s25, v6, v7
		v_cmp_lt_i32_e64 vcc, v13, s20
		v_add3_u32 v11, v11, v17, v14
		s_add_u32 s46, s46, 0xb4f0
		s_addc_u32 s47, s47, 0
		v_cndmask_b32_e32 v11, v22, v11, vcc
		s_add_u32 s48, s46, 0
		s_addc_u32 s49, s47, 0
		s_mov_b32 m0, s48
		s_nop 0
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_2
.L_attn_fwd_persistent.if_else_2:
.L_attn_fwd_persistent.if_end_2:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[112:127], v[28:31], a[20:23], 0
		s_cmp_lt_i32 s1, s21
		v_mfma_f32_32x32x16_bf16 v[128:143], a[140:143], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[144:159], a[156:159], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[176:191], v[96:99], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[96:111], v[28:31], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[192:207], a[140:143], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[208:223], a[156:159], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[112:127], a[128:131], a[24:27], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[144:147], a[24:27], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[160:163], a[24:27], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[172:175], a[24:27], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[172:175], a[40:43], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[128:131], a[40:43], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[144:147], a[40:43], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[160:163], a[40:43], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[132:135], a[28:31], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[148:151], a[28:31], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[164:167], a[28:31], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[176:179], a[28:31], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[176:179], a[44:47], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[132:135], a[44:47], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[148:151], a[44:47], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[164:167], a[44:47], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[136:139], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[152:155], a[32:35], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[168:171], a[32:35], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[180:183], a[48:51], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[136:139], a[48:51], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[152:155], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[168:171], a[48:51], v[208:223]
		v_add_u32_e32 v11, s41, v10
		v_accvgpr_read_b32 v13, a14
		v_add_u32_e32 v13, s41, v13
		v_accvgpr_read_b32 v15, a15
		v_add_u32_e32 v15, s41, v15
		v_accvgpr_read_b32 v16, a64
		v_add_u32_e32 v16, s41, v16
		v_accvgpr_read_b32 v18, a67
		v_add_u32_e32 v18, s41, v18
		v_accvgpr_read_b32 v20, a68
		v_add_u32_e32 v20, s41, v20
		v_accvgpr_read_b32 v23, a71
		v_add_u32_e32 v23, s41, v23
		v_accvgpr_read_b32 v26, a72
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_read_b32 v27, a75
		v_add_u32_e32 v27, s41, v27
		v_accvgpr_read_b32 v28, a76
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_read_b32 v29, a79
		v_add_u32_e32 v29, s41, v29
		v_accvgpr_read_b32 v30, a80
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_read_b32 v31, a83
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a125, v31
		v_accvgpr_read_b32 v31, a84
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a126, v31
		v_accvgpr_read_b32 v31, a87
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a127, v31
		v_accvgpr_read_b32 v31, a88
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a128, v31
		v_accvgpr_read_b32 v31, a91
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a129, v31
		v_accvgpr_read_b32 v31, a92
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a130, v31
		v_accvgpr_read_b32 v31, a95
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a131, v31
		v_accvgpr_read_b32 v31, a96
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a132, v31
		v_accvgpr_read_b32 v31, a99
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a133, v31
		v_accvgpr_read_b32 v31, a100
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a134, v31
		v_accvgpr_read_b32 v31, a103
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a135, v31
		v_accvgpr_read_b32 v31, a104
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a136, v31
		v_accvgpr_read_b32 v31, a107
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a137, v31
		v_accvgpr_read_b32 v31, a108
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a138, v31
		v_accvgpr_read_b32 v31, a111
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a139, v31
		v_accvgpr_read_b32 v31, a112
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a140, v31
		v_accvgpr_read_b32 v31, a115
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a141, v31
		v_accvgpr_read_b32 v31, a116
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a142, v31
		v_accvgpr_read_b32 v31, a119
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a143, v31
		v_accvgpr_read_b32 v31, a120
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a144, v31
		v_accvgpr_read_b32 v31, a123
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a145, v31
		v_accvgpr_read_b32 v31, a124
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a146, v31
		v_cmp_ge_i32_e64 s[46:47], v1, v11
		v_cmp_ge_i32_e64 s[48:49], v1, v13
		v_cmp_ge_i32_e64 s[50:51], v1, v15
		v_cmp_ge_i32_e64 vcc, v1, v16
		v_accvgpr_read_b32 v31, a65
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_read_b32 v224, a66
		v_add_u32_e32 v224, s41, v224
		v_cndmask_b32_e32 v227, v9, v115, vcc
		v_cmp_ge_i32_e64 s[52:53], v1, v31
		v_cmp_ge_i32_e64 s[54:55], v1, v224
		v_cmp_ge_i32_e64 s[56:57], v1, v18
		v_cmp_ge_i32_e64 vcc, v1, v20
		v_accvgpr_read_b32 v115, a69
		v_add_u32_e32 v115, s41, v115
		v_accvgpr_read_b32 v225, a70
		v_add_u32_e32 v225, s41, v225
		v_cndmask_b32_e32 v229, v9, v119, vcc
		v_cmp_ge_i32_e64 s[58:59], v1, v115
		v_cmp_ge_i32_e64 s[60:61], v1, v225
		v_cmp_ge_i32_e64 s[62:63], v1, v23
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v119, a73
		v_add_u32_e32 v119, s41, v119
		v_accvgpr_read_b32 v226, a74
		v_add_u32_e32 v230, s41, v226
		v_cndmask_b32_e32 v233, v9, v123, vcc
		v_cmp_ge_i32_e64 s[64:65], v1, v119
		v_cmp_ge_i32_e64 s[66:67], v1, v230
		v_cmp_ge_i32_e64 s[68:69], v1, v27
		v_cmp_ge_i32_e64 vcc, v1, v28
		v_accvgpr_read_b32 v123, a77
		v_add_u32_e32 v123, s41, v123
		v_accvgpr_read_b32 v226, a78
		v_add_u32_e32 v231, s41, v226
		v_cndmask_b32_e32 v235, v9, v127, vcc
		v_cmp_ge_i32_e64 s[70:71], v1, v123
		v_cmp_ge_i32_e64 s[72:73], v1, v231
		v_cmp_ge_i32_e64 s[74:75], v1, v29
		v_cmp_ge_i32_e64 vcc, v1, v30
		v_accvgpr_read_b32 v127, a81
		v_add_u32_e32 v127, s41, v127
		v_accvgpr_read_b32 v226, a82
		v_add_u32_e32 v226, s41, v226
		v_accvgpr_write_b32 a147, v226
		v_cndmask_b32_e32 v237, v9, v131, vcc
		v_cmp_ge_i32_e64 s[76:77], v1, v127
		v_accvgpr_read_b32 v131, a147
		v_cmp_ge_i32_e64 s[78:79], v1, v131
		v_accvgpr_read_b32 v131, a125
		v_cmp_ge_i32_e64 s[80:81], v1, v131
		v_accvgpr_read_b32 v131, a126
		v_cmp_ge_i32_e64 vcc, v1, v131
		v_accvgpr_read_b32 v131, a85
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a148, v131
		v_accvgpr_read_b32 v131, a86
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a149, v131
		v_cndmask_b32_e32 v239, v9, v135, vcc
		v_accvgpr_read_b32 v131, a148
		v_cmp_ge_i32_e64 s[82:83], v1, v131
		v_accvgpr_read_b32 v131, a149
		v_cmp_ge_i32_e64 s[84:85], v1, v131
		v_accvgpr_read_b32 v131, a128
		v_cmp_ge_i32_e64 vcc, v1, v131
		v_accvgpr_read_b32 v131, a89
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a150, v131
		v_accvgpr_read_b32 v131, a90
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a151, v131
		v_cndmask_b32_e32 v241, v9, v139, vcc
		v_accvgpr_read_b32 v131, a130
		v_cmp_ge_i32_e64 vcc, v1, v131
		v_accvgpr_read_b32 v131, a93
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a152, v131
		v_accvgpr_read_b32 v131, a94
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a153, v131
		v_cndmask_b32_e32 v243, v9, v143, vcc
		v_accvgpr_read_b32 v131, a132
		v_cmp_ge_i32_e64 vcc, v1, v131
		v_accvgpr_read_b32 v131, a97
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a154, v131
		v_accvgpr_read_b32 v131, a98
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a155, v131
		v_cndmask_b32_e32 v245, v9, v147, vcc
		v_accvgpr_read_b32 v131, a134
		v_cmp_ge_i32_e64 vcc, v1, v131
		v_accvgpr_read_b32 v131, a101
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a156, v131
		v_accvgpr_read_b32 v131, a102
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a157, v131
		v_cndmask_b32_e32 v247, v9, v151, vcc
		v_accvgpr_read_b32 v131, a136
		v_cmp_ge_i32_e64 vcc, v1, v131
		v_accvgpr_read_b32 v131, a105
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a158, v131
		v_accvgpr_read_b32 v131, a106
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a159, v131
		v_cndmask_b32_e32 v249, v9, v155, vcc
		v_accvgpr_read_b32 v131, a138
		v_cmp_ge_i32_e64 vcc, v1, v131
		v_accvgpr_read_b32 v131, a127
		v_cmp_ge_i32_e64 s[86:87], v1, v131
		v_cndmask_b32_e64 v250, v9, v112, s[46:47]
		v_accvgpr_read_b32 v112, a150
		v_cmp_ge_i32_e64 s[46:47], v1, v112
		v_accvgpr_read_b32 v112, a151
		v_cmp_ge_i32_e64 s[88:89], v1, v112
		v_accvgpr_read_b32 v112, a129
		v_cmp_ge_i32_e64 s[90:91], v1, v112
		v_accvgpr_read_b32 v112, a152
		v_cmp_ge_i32_e64 s[92:93], v1, v112
		s_nop 1
		v_mov_b32_e32 v252, s92
		v_mov_b32_e32 v253, s93
		v_accvgpr_write_b32 a160, v252
		v_accvgpr_write_b32 a161, v253
		v_accvgpr_read_b32 v112, a153
		v_cmp_ge_i32_e64 s[92:93], v1, v112
		s_nop 1
		v_mov_b32_e32 v252, s92
		v_mov_b32_e32 v253, s93
		v_accvgpr_write_b32 a162, v252
		v_accvgpr_write_b32 a163, v253
		v_accvgpr_read_b32 v112, a131
		v_cmp_ge_i32_e64 s[92:93], v1, v112
		s_nop 1
		v_mov_b32_e32 v252, s92
		v_mov_b32_e32 v253, s93
		v_accvgpr_write_b32 a164, v252
		v_accvgpr_write_b32 a165, v253
		v_accvgpr_read_b32 v112, a154
		v_cmp_ge_i32_e64 s[92:93], v1, v112
		s_nop 1
		v_mov_b32_e32 v252, s92
		v_mov_b32_e32 v253, s93
		v_accvgpr_write_b32 a166, v252
		v_accvgpr_write_b32 a167, v253
		v_accvgpr_read_b32 v112, a155
		v_cmp_ge_i32_e64 s[92:93], v1, v112
		s_nop 1
		v_mov_b32_e32 v252, s92
		v_mov_b32_e32 v253, s93
		v_accvgpr_write_b32 a168, v252
		v_accvgpr_write_b32 a169, v253
		v_accvgpr_read_b32 v112, a133
		v_cmp_ge_i32_e64 s[92:93], v1, v112
		s_nop 1
		v_mov_b32_e32 v252, s92
		v_mov_b32_e32 v253, s93
		v_accvgpr_write_b32 a170, v252
		v_accvgpr_write_b32 a171, v253
		v_accvgpr_read_b32 v112, a156
		v_cmp_ge_i32_e64 s[92:93], v1, v112
		s_nop 1
		v_mov_b32_e32 v252, s92
		v_mov_b32_e32 v253, s93
		v_accvgpr_write_b32 a172, v252
		v_accvgpr_write_b32 a173, v253
		v_accvgpr_read_b32 v112, a157
		v_cmp_ge_i32_e64 s[92:93], v1, v112
		s_nop 1
		v_mov_b32_e32 v252, s92
		v_mov_b32_e32 v253, s93
		v_accvgpr_write_b32 a174, v252
		v_accvgpr_write_b32 a175, v253
		v_accvgpr_read_b32 v112, a135
		v_cmp_ge_i32_e64 s[92:93], v1, v112
		s_nop 1
		v_mov_b32_e32 v252, s92
		v_mov_b32_e32 v253, s93
		v_accvgpr_write_b32 a176, v252
		v_accvgpr_write_b32 a177, v253
		v_accvgpr_read_b32 v112, a158
		v_cmp_ge_i32_e64 s[92:93], v1, v112
		v_accvgpr_read_b32 v112, a159
		v_cmp_ge_i32_e64 s[94:95], v1, v112
		v_accvgpr_read_b32 v112, a137
		v_cmp_ge_i32_e64 s[96:97], v1, v112
		v_cndmask_b32_e32 v253, v9, v159, vcc
		v_cndmask_b32_e64 v255, v9, v157, s[94:95]
		v_cndmask_b32_e64 v252, v9, v158, s[96:97]
		v_accvgpr_read_b32 v112, a109
		v_add_u32_e32 v112, s41, v112
		v_accvgpr_write_b32 a178, v112
		v_accvgpr_read_b32 v112, a110
		v_add_u32_e32 v112, s41, v112
		v_accvgpr_write_b32 a179, v112
		v_accvgpr_read_b32 v112, a178
		v_cmp_ge_i32_e64 s[94:95], v1, v112
		v_accvgpr_read_b32 v112, a179
		v_cmp_ge_i32_e64 s[96:97], v1, v112
		v_accvgpr_read_b32 v112, a139
		v_cmp_ge_i32_e64 s[98:99], v1, v112
		v_cndmask_b32_e64 v158, v9, v160, s[94:95]
		v_cndmask_b32_e64 v159, v9, v161, s[96:97]
		v_cndmask_b32_e64 v160, v9, v162, s[98:99]
		v_accvgpr_read_b32 v112, a140
		v_cmp_ge_i32_e64 vcc, v1, v112
		v_accvgpr_read_b32 v112, a113
		v_add_u32_e32 v112, s41, v112
		v_accvgpr_write_b32 a180, v112
		v_accvgpr_read_b32 v112, a114
		v_add_u32_e32 v112, s41, v112
		v_accvgpr_write_b32 a181, v112
		v_cndmask_b32_e32 v161, v9, v163, vcc
		v_accvgpr_read_b32 v112, a180
		v_cmp_ge_i32_e64 s[94:95], v1, v112
		v_accvgpr_read_b32 v112, a181
		v_cmp_ge_i32_e64 s[96:97], v1, v112
		v_accvgpr_read_b32 v112, a141
		v_cmp_ge_i32_e64 s[98:99], v1, v112
		v_cndmask_b32_e64 v162, v9, v164, s[94:95]
		v_cndmask_b32_e64 v163, v9, v165, s[96:97]
		v_cndmask_b32_e64 v164, v9, v166, s[98:99]
		v_accvgpr_read_b32 v112, a142
		v_cmp_ge_i32_e64 vcc, v1, v112
		v_accvgpr_read_b32 v112, a117
		v_add_u32_e32 v112, s41, v112
		v_accvgpr_write_b32 a182, v112
		v_accvgpr_read_b32 v112, a118
		v_add_u32_e32 v112, s41, v112
		v_accvgpr_write_b32 a183, v112
		v_cndmask_b32_e32 v165, v9, v167, vcc
		v_accvgpr_read_b32 v112, a182
		v_cmp_ge_i32_e64 s[94:95], v1, v112
		v_accvgpr_read_b32 v112, a183
		v_cmp_ge_i32_e64 s[96:97], v1, v112
		v_accvgpr_read_b32 v112, a143
		v_cmp_ge_i32_e64 s[98:99], v1, v112
		v_cndmask_b32_e64 v166, v9, v168, s[94:95]
		v_cndmask_b32_e64 v167, v9, v169, s[96:97]
		v_cndmask_b32_e64 v168, v9, v170, s[98:99]
		v_accvgpr_read_b32 v112, a144
		v_cmp_ge_i32_e64 vcc, v1, v112
		v_accvgpr_read_b32 v112, a121
		v_add_u32_e32 v112, s41, v112
		v_accvgpr_write_b32 a248, v112
		v_accvgpr_read_b32 v112, a122
		v_add_u32_e32 v112, s41, v112
		v_accvgpr_write_b32 a249, v112
		v_cndmask_b32_e32 v169, v9, v171, vcc
		v_accvgpr_read_b32 v112, a248
		v_cmp_ge_i32_e64 s[94:95], v1, v112
		v_accvgpr_read_b32 v112, a249
		v_cmp_ge_i32_e64 s[96:97], v1, v112
		v_accvgpr_read_b32 v112, a145
		v_cmp_ge_i32_e64 s[98:99], v1, v112
		v_cndmask_b32_e64 v170, v9, v172, s[94:95]
		v_cndmask_b32_e64 v171, v9, v173, s[96:97]
		v_cndmask_b32_e64 v172, v9, v174, s[98:99]
		v_cndmask_b32_e64 v251, v9, v113, s[48:49]
		v_accvgpr_read_b32 v112, a146
		v_cmp_ge_i32_e64 vcc, v1, v112
		v_max3_f32 v112, v158, v159, v160
		v_accvgpr_write_b32 a250, v112
		v_max3_f32 v112, v162, v163, v164
		v_accvgpr_write_b32 a251, v112
		v_cndmask_b32_e32 v173, v9, v175, vcc
		v_cmp_ge_i32_e64 s[48:49], v3, v11
		v_cmp_ge_i32_e64 s[94:95], v3, v13
		v_cmp_ge_i32_e64 s[96:97], v3, v15
		v_max3_f32 v11, v166, v167, v168
		v_accvgpr_write_b32 a252, v11
		v_max3_f32 v11, v170, v171, v172
		v_accvgpr_write_b32 a253, v11
		v_cndmask_b32_e64 v112, v9, v98, s[96:97]
		v_cmp_ge_i32_e64 vcc, v3, v16
		v_cndmask_b32_e64 v226, v9, v114, s[50:51]
		v_cndmask_b32_e64 v174, v9, v116, s[52:53]
		v_cndmask_b32_e32 v113, v9, v99, vcc
		v_cmp_ge_i32_e64 s[50:51], v3, v31
		v_cmp_ge_i32_e64 s[52:53], v3, v224
		v_cmp_ge_i32_e64 s[96:97], v3, v18
		v_cndmask_b32_e64 v98, v9, v100, s[50:51]
		v_cndmask_b32_e64 v99, v9, v101, s[52:53]
		v_cndmask_b32_e64 v100, v9, v102, s[96:97]
		v_cmp_ge_i32_e64 vcc, v3, v20
		v_cndmask_b32_e64 v175, v9, v117, s[54:55]
		v_cndmask_b32_e64 v228, v9, v118, s[56:57]
		v_cndmask_b32_e64 v116, v9, v120, s[58:59]
		v_cndmask_b32_e32 v101, v9, v103, vcc
		v_cmp_ge_i32_e64 s[50:51], v3, v115
		v_cmp_ge_i32_e64 s[52:53], v3, v225
		v_cmp_ge_i32_e64 s[54:55], v3, v23
		v_cndmask_b32_e64 v102, v9, v104, s[50:51]
		v_cndmask_b32_e64 v103, v9, v105, s[52:53]
		v_cndmask_b32_e64 v104, v9, v106, s[54:55]
		v_cmp_ge_i32_e64 vcc, v3, v26
		v_cndmask_b32_e64 v117, v9, v121, s[60:61]
		v_max3_f32 v11, v250, v251, v226
		v_cndmask_b32_e32 v105, v9, v107, vcc
		v_cmp_ge_i32_e64 s[50:51], v3, v119
		v_cmp_ge_i32_e64 s[52:53], v3, v230
		v_cmp_ge_i32_e64 s[54:55], v3, v27
		v_cndmask_b32_e64 v26, v9, v108, s[50:51]
		v_cndmask_b32_e64 v27, v9, v109, s[52:53]
		v_cndmask_b32_e64 v106, v9, v110, s[54:55]
		v_cmp_ge_i32_e64 vcc, v3, v28
		v_cndmask_b32_e64 v232, v9, v122, s[62:63]
		v_cndmask_b32_e64 v108, v9, v124, s[64:65]
		v_cndmask_b32_e32 v107, v9, v111, vcc
		v_cmp_ge_i32_e64 s[50:51], v3, v123
		v_cmp_ge_i32_e64 s[52:53], v3, v231
		v_cmp_ge_i32_e64 s[54:55], v3, v29
		v_cndmask_b32_e64 v28, v9, v192, s[50:51]
		v_cndmask_b32_e64 v29, v9, v193, s[52:53]
		v_cndmask_b32_e64 v110, v9, v194, s[54:55]
		v_cmp_ge_i32_e64 vcc, v3, v30
		v_cndmask_b32_e64 v109, v9, v125, s[66:67]
		v_cndmask_b32_e64 v234, v9, v126, s[68:69]
		v_cndmask_b32_e64 v30, v9, v128, s[70:71]
		v_cndmask_b32_e32 v111, v9, v195, vcc
		v_cmp_ge_i32_e64 s[50:51], v3, v127
		v_accvgpr_read_b32 v13, a147
		v_cmp_ge_i32_e64 s[52:53], v3, v13
		v_accvgpr_read_b32 v13, a125
		v_cmp_ge_i32_e64 s[54:55], v3, v13
		v_cndmask_b32_e64 v114, v9, v196, s[50:51]
		v_cndmask_b32_e64 v115, v9, v197, s[52:53]
		v_cndmask_b32_e64 v118, v9, v198, s[54:55]
		v_accvgpr_read_b32 v13, a126
		v_cmp_ge_i32_e64 vcc, v3, v13
		v_cndmask_b32_e64 v31, v9, v129, s[72:73]
		v_max3_f32 v13, v174, v175, v228
		v_cndmask_b32_e32 v119, v9, v199, vcc
		v_accvgpr_read_b32 v15, a148
		v_cmp_ge_i32_e64 s[50:51], v3, v15
		v_accvgpr_read_b32 v15, a149
		v_cmp_ge_i32_e64 s[52:53], v3, v15
		v_accvgpr_read_b32 v15, a127
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_cndmask_b32_e64 v120, v9, v200, s[50:51]
		v_cndmask_b32_e64 v121, v9, v201, s[52:53]
		v_cndmask_b32_e64 v122, v9, v202, s[54:55]
		v_accvgpr_read_b32 v15, a128
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_cndmask_b32_e64 v236, v9, v130, s[74:75]
		v_cndmask_b32_e64 v124, v9, v132, s[76:77]
		v_cndmask_b32_e32 v123, v9, v203, vcc
		v_accvgpr_read_b32 v15, a130
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_accvgpr_read_b32 v15, a150
		v_cmp_ge_i32_e64 s[50:51], v3, v15
		v_accvgpr_read_b32 v15, a151
		v_cmp_ge_i32_e64 s[52:53], v3, v15
		v_accvgpr_read_b32 v15, a129
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_cndmask_b32_e64 v126, v9, v204, s[50:51]
		v_cndmask_b32_e64 v127, v9, v205, s[52:53]
		v_cndmask_b32_e64 v128, v9, v206, s[54:55]
		v_cndmask_b32_e64 v125, v9, v133, s[78:79]
		v_cndmask_b32_e64 v238, v9, v134, s[80:81]
		v_cndmask_b32_e32 v129, v9, v207, vcc
		v_accvgpr_read_b32 v15, a152
		v_cmp_ge_i32_e64 s[50:51], v3, v15
		v_accvgpr_read_b32 v15, a153
		v_cmp_ge_i32_e64 s[52:53], v3, v15
		v_accvgpr_read_b32 v15, a132
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_accvgpr_read_b32 v15, a131
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_cndmask_b32_e64 v130, v9, v208, s[50:51]
		v_cndmask_b32_e64 v131, v9, v209, s[52:53]
		v_cndmask_b32_e64 v132, v9, v210, s[54:55]
		v_cndmask_b32_e64 v134, v9, v136, s[82:83]
		v_cndmask_b32_e64 v135, v9, v137, s[84:85]
		v_cndmask_b32_e32 v133, v9, v211, vcc
		v_accvgpr_read_b32 v15, a154
		v_cmp_ge_i32_e64 s[50:51], v3, v15
		v_accvgpr_read_b32 v15, a155
		v_cmp_ge_i32_e64 s[52:53], v3, v15
		v_accvgpr_read_b32 v15, a133
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_cndmask_b32_e64 v136, v9, v212, s[50:51]
		v_cndmask_b32_e64 v137, v9, v213, s[52:53]
		v_cndmask_b32_e64 v192, v9, v214, s[54:55]
		v_accvgpr_read_b32 v15, a134
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_cndmask_b32_e64 v240, v9, v138, s[86:87]
		v_cndmask_b32_e64 v138, v9, v140, s[46:47]
		v_cndmask_b32_e32 v193, v9, v215, vcc
		v_accvgpr_read_b32 v15, a156
		v_cmp_ge_i32_e64 s[46:47], v3, v15
		v_accvgpr_read_b32 v15, a157
		v_cmp_ge_i32_e64 s[50:51], v3, v15
		v_accvgpr_read_b32 v15, a135
		v_cmp_ge_i32_e64 s[52:53], v3, v15
		v_cndmask_b32_e64 v194, v9, v216, s[46:47]
		v_cndmask_b32_e64 v195, v9, v217, s[50:51]
		v_cndmask_b32_e64 v196, v9, v218, s[52:53]
		v_accvgpr_read_b32 v15, a136
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_cndmask_b32_e64 v139, v9, v141, s[88:89]
		v_cndmask_b32_e64 v242, v9, v142, s[90:91]
		v_cndmask_b32_e32 v197, v9, v219, vcc
		v_accvgpr_read_b32 v15, a158
		v_cmp_ge_i32_e64 s[46:47], v3, v15
		v_accvgpr_read_b32 v15, a159
		v_cmp_ge_i32_e64 s[50:51], v3, v15
		v_accvgpr_read_b32 v15, a137
		v_cmp_ge_i32_e64 s[52:53], v3, v15
		v_cndmask_b32_e64 v140, v9, v220, s[46:47]
		v_cndmask_b32_e64 v141, v9, v221, s[50:51]
		v_cndmask_b32_e64 v142, v9, v222, s[52:53]
		v_accvgpr_read_b32 v15, a138
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_accvgpr_read_b32 v15, a160
		s_nop 0
		v_readfirstlane_b32 s46, v15
		v_accvgpr_read_b32 v15, a161
		s_nop 0
		v_readfirstlane_b32 s47, v15
		s_nop 1
		v_cndmask_b32_e64 v198, v9, v144, s[46:47]
		v_accvgpr_read_b32 v15, a162
		s_nop 0
		v_readfirstlane_b32 s46, v15
		v_accvgpr_read_b32 v15, a163
		s_nop 0
		v_readfirstlane_b32 s47, v15
		s_nop 1
		v_cndmask_b32_e64 v199, v9, v145, s[46:47]
		v_cndmask_b32_e32 v143, v9, v223, vcc
		v_accvgpr_read_b32 v15, a178
		v_cmp_ge_i32_e64 s[46:47], v3, v15
		v_accvgpr_read_b32 v15, a179
		v_cmp_ge_i32_e64 s[50:51], v3, v15
		v_accvgpr_read_b32 v15, a139
		v_cmp_ge_i32_e64 s[52:53], v3, v15
		v_cndmask_b32_e64 v144, v9, v176, s[46:47]
		v_cndmask_b32_e64 v145, v9, v177, s[50:51]
		v_cndmask_b32_e64 v176, v9, v178, s[52:53]
		v_accvgpr_read_b32 v15, a140
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_accvgpr_read_b32 v15, a164
		s_nop 0
		v_readfirstlane_b32 s46, v15
		v_accvgpr_read_b32 v15, a165
		s_nop 0
		v_readfirstlane_b32 s47, v15
		s_nop 1
		v_cndmask_b32_e64 v244, v9, v146, s[46:47]
		v_accvgpr_read_b32 v15, a166
		s_nop 0
		v_readfirstlane_b32 s46, v15
		v_accvgpr_read_b32 v15, a167
		s_nop 0
		v_readfirstlane_b32 s47, v15
		s_nop 1
		v_cndmask_b32_e64 v146, v9, v148, s[46:47]
		v_cndmask_b32_e32 v177, v9, v179, vcc
		v_accvgpr_read_b32 v15, a180
		v_cmp_ge_i32_e64 s[46:47], v3, v15
		v_accvgpr_read_b32 v15, a181
		v_cmp_ge_i32_e64 s[50:51], v3, v15
		v_accvgpr_read_b32 v15, a141
		v_cmp_ge_i32_e64 s[52:53], v3, v15
		v_cndmask_b32_e64 v178, v9, v180, s[46:47]
		v_cndmask_b32_e64 v179, v9, v181, s[50:51]
		v_cndmask_b32_e64 v180, v9, v182, s[52:53]
		v_accvgpr_read_b32 v15, a142
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_accvgpr_read_b32 v15, a168
		s_nop 0
		v_readfirstlane_b32 s46, v15
		v_accvgpr_read_b32 v15, a169
		s_nop 0
		v_readfirstlane_b32 s47, v15
		s_nop 1
		v_cndmask_b32_e64 v147, v9, v149, s[46:47]
		v_accvgpr_read_b32 v15, a170
		s_nop 0
		v_readfirstlane_b32 s46, v15
		v_accvgpr_read_b32 v15, a171
		s_nop 0
		v_readfirstlane_b32 s47, v15
		s_nop 1
		v_cndmask_b32_e64 v246, v9, v150, s[46:47]
		v_cndmask_b32_e32 v181, v9, v183, vcc
		v_accvgpr_read_b32 v15, a182
		v_cmp_ge_i32_e64 s[46:47], v3, v15
		v_accvgpr_read_b32 v15, a183
		v_cmp_ge_i32_e64 s[50:51], v3, v15
		v_accvgpr_read_b32 v15, a143
		v_cmp_ge_i32_e64 s[52:53], v3, v15
		v_cndmask_b32_e64 v148, v9, v184, s[46:47]
		v_cndmask_b32_e64 v149, v9, v185, s[50:51]
		v_cndmask_b32_e64 v150, v9, v186, s[52:53]
		v_accvgpr_read_b32 v15, a144
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_accvgpr_read_b32 v15, a172
		s_nop 0
		v_readfirstlane_b32 s46, v15
		v_accvgpr_read_b32 v15, a173
		s_nop 0
		v_readfirstlane_b32 s47, v15
		s_nop 1
		v_cndmask_b32_e64 v182, v9, v152, s[46:47]
		v_accvgpr_read_b32 v15, a174
		s_nop 0
		v_readfirstlane_b32 s46, v15
		v_accvgpr_read_b32 v15, a175
		s_nop 0
		v_readfirstlane_b32 s47, v15
		s_nop 1
		v_cndmask_b32_e64 v183, v9, v153, s[46:47]
		v_cndmask_b32_e32 v151, v9, v187, vcc
		v_accvgpr_read_b32 v15, a248
		v_cmp_ge_i32_e64 s[46:47], v3, v15
		v_accvgpr_read_b32 v15, a249
		v_cmp_ge_i32_e64 s[50:51], v3, v15
		v_accvgpr_read_b32 v15, a145
		v_cmp_ge_i32_e64 s[52:53], v3, v15
		v_cndmask_b32_e64 v152, v9, v188, s[46:47]
		v_cndmask_b32_e64 v153, v9, v189, s[50:51]
		v_cndmask_b32_e64 v184, v9, v190, s[52:53]
		v_accvgpr_read_b32 v15, a146
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_accvgpr_read_b32 v15, a176
		s_nop 0
		v_readfirstlane_b32 s46, v15
		v_accvgpr_read_b32 v15, a177
		s_nop 0
		v_readfirstlane_b32 s47, v15
		s_nop 1
		v_cndmask_b32_e64 v248, v9, v154, s[46:47]
		v_cndmask_b32_e64 v254, v9, v156, s[92:93]
		v_cndmask_b32_e32 v185, v9, v191, vcc
		v_max3_f32 v15, v116, v117, v232
		v_max3_f32 v16, v108, v109, v234
		v_max3_f32 v18, v30, v31, v236
		v_max3_f32 v20, v124, v125, v238
		v_max3_f32 v23, v134, v135, v240
		v_max3_f32 v154, v138, v139, v242
		v_max3_f32 v155, v198, v199, v244
		v_max3_f32 v156, v146, v147, v246
		v_max3_f32 v157, v182, v183, v248
		v_max3_f32 v186, v254, v255, v252
		v_max3_f32 v11, v11, v227, v13
		v_max3_f32 v13, v15, v233, v16
		v_max3_f32 v15, v18, v237, v20
		v_max3_f32 v16, v23, v241, v154
		v_max3_f32 v18, v155, v245, v156
		v_max3_f32 v20, v157, v249, v186
		v_accvgpr_read_b32 v23, a250
		v_accvgpr_read_b32 v154, a251
		v_max3_f32 v23, v23, v161, v154
		v_accvgpr_read_b32 v154, a252
		v_accvgpr_read_b32 v155, a253
		v_max3_f32 v154, v154, v169, v155
		v_max3_f32 v11, v11, v229, v13
		v_max3_f32 v13, v15, v239, v16
		v_max3_f32 v15, v18, v247, v20
		v_max3_f32 v16, v23, v165, v154
		v_max3_f32 v11, v11, v235, v13
		v_max3_f32 v13, v15, v253, v16
		v_max3_f32 v11, v11, v243, v13
		v_max_f32_e32 v154, v11, v173
		v_mov_b32_e32 v155, v154
		v_cndmask_b32_e64 v156, v9, v96, s[48:49]
		v_cndmask_b32_e64 v157, v9, v97, s[94:95]
		v_permlane32_swap_b32_e32 v154, v155
		v_max3_f32 v11, v156, v157, v112
		v_max3_f32 v13, v98, v99, v100
		v_max3_f32 v15, v102, v103, v104
		v_max3_f32 v16, v26, v27, v106
		v_max3_f32 v18, v28, v29, v110
		v_max3_f32 v20, v114, v115, v118
		v_max3_f32 v23, v120, v121, v122
		v_max3_f32 v96, v126, v127, v128
		v_max3_f32 v97, v130, v131, v132
		v_max3_f32 v186, v136, v137, v192
		v_max3_f32 v187, v194, v195, v196
		v_max3_f32 v188, v140, v141, v142
		v_max3_f32 v189, v144, v145, v176
		v_max3_f32 v190, v178, v179, v180
		v_max3_f32 v191, v148, v149, v150
		v_max3_f32 v200, v152, v153, v184
		v_max3_f32 v11, v11, v113, v13
		v_max3_f32 v13, v15, v105, v16
		v_max3_f32 v15, v18, v111, v20
		v_max3_f32 v16, v23, v123, v96
		v_max3_f32 v18, v97, v133, v186
		v_max3_f32 v20, v187, v197, v188
		v_max3_f32 v23, v189, v177, v190
		v_max3_f32 v96, v191, v151, v200
		v_max3_f32 v11, v11, v101, v13
		v_max3_f32 v13, v15, v119, v16
		v_max3_f32 v15, v18, v193, v20
		v_max3_f32 v16, v23, v181, v96
		v_max3_f32 v11, v11, v107, v13
		v_max3_f32 v13, v15, v143, v16
		v_max3_f32 v11, v11, v129, v13
		v_max_f32_e32 v96, v11, v185
		v_mov_b32_e32 v97, v96
		v_max_f32_e32 v186, v154, v155
		v_mov_b32_e32 v154, v2
		v_permlane32_swap_b32_e32 v96, v97
		v_max_f32_e32 v187, v96, v97
		v_pk_mul_f32 v[96:97], v[186:187], v[4:5]
		v_max_f32_e32 v186, v2, v96
		v_max_f32_e32 v187, v8, v97
		v_pk_fma_f32 v[96:97], v[250:251], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[226:227], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[174:175], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[228:229], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[116:117], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[232:233], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[108:109], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[234:235], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[30:31], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[236:237], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[124:125], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[238:239], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[134:135], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[240:241], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[138:139], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[242:243], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[198:199], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[244:245], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[146:147], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[246:247], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[182:183], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[248:249], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[218:219], v[254:255], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[220:221], v[252:253], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[222:223], v[158:159], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[160:161], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[162:163], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[164:165], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[166:167], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[168:169], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[170:171], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[172:173], v[4:5], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[156:157], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[112:113], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[98:99], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[26:27], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[106:107], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[28:29], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[110:111], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[114:115], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[118:119], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[120:121], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[122:123], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[126:127], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[128:129], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[130:131], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[132:133], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[136:137], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[192:193], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[194:195], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[196:197], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[140:141], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[142:143], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[144:145], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[176:177], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[178:179], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[180:181], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[148:149], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[150:151], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[184:185], v[4:5], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v184, v96
		v_exp_f32_e32 v224, v97
		v_exp_f32_e32 v96, v188
		v_exp_f32_e32 v226, v189
		v_exp_f32_e32 v188, v190
		v_exp_f32_e32 v228, v191
		v_exp_f32_e32 v190, v174
		v_exp_f32_e32 v230, v175
		v_exp_f32_e32 v174, v200
		v_exp_f32_e32 v232, v201
		v_exp_f32_e32 v200, v116
		v_exp_f32_e32 v234, v117
		v_exp_f32_e32 v116, v202
		v_exp_f32_e32 v236, v203
		v_exp_f32_e32 v202, v108
		v_exp_f32_e32 v238, v109
		v_exp_f32_e32 v108, v204
		v_exp_f32_e32 v240, v205
		v_exp_f32_e32 v204, v30
		v_exp_f32_e32 v242, v31
		v_exp_f32_e32 v30, v206
		v_exp_f32_e32 v244, v207
		v_exp_f32_e32 v206, v124
		v_exp_f32_e32 v246, v125
		v_exp_f32_e32 v124, v208
		v_exp_f32_e32 v248, v209
		v_exp_f32_e32 v208, v134
		v_exp_f32_e32 v250, v135
		v_exp_f32_e32 v134, v210
		v_exp_f32_e32 v252, v211
		v_exp_f32_e32 v210, v138
		v_exp_f32_e32 v254, v139
		v_exp_f32_e32 v185, v212
		v_exp_f32_e32 v225, v213
		v_exp_f32_e32 v97, v198
		v_exp_f32_e32 v227, v199
		v_exp_f32_e32 v189, v214
		v_exp_f32_e32 v229, v215
		v_exp_f32_e32 v191, v146
		v_exp_f32_e32 v231, v147
		v_exp_f32_e32 v175, v216
		v_exp_f32_e32 v233, v217
		v_exp_f32_e32 v201, v182
		v_exp_f32_e32 v235, v183
		v_exp_f32_e32 v117, v218
		v_exp_f32_e32 v237, v219
		v_exp_f32_e32 v203, v220
		v_exp_f32_e32 v239, v221
		v_exp_f32_e32 v109, v222
		v_exp_f32_e32 v241, v223
		v_exp_f32_e32 v205, v158
		v_exp_f32_e32 v243, v159
		v_exp_f32_e32 v31, v160
		v_exp_f32_e32 v245, v161
		v_exp_f32_e32 v207, v162
		v_exp_f32_e32 v247, v163
		v_exp_f32_e32 v125, v164
		v_exp_f32_e32 v249, v165
		v_exp_f32_e32 v209, v166
		v_exp_f32_e32 v251, v167
		v_exp_f32_e32 v135, v168
		v_exp_f32_e32 v253, v169
		v_exp_f32_e32 v211, v170
		v_exp_f32_e32 v255, v171
		v_exp_f32_e32 v138, v156
		v_exp_f32_e32 v146, v157
		v_exp_f32_e32 v156, v112
		v_exp_f32_e32 v158, v113
		v_exp_f32_e32 v112, v98
		v_exp_f32_e32 v160, v99
		v_exp_f32_e32 v98, v100
		v_exp_f32_e32 v162, v101
		v_exp_f32_e32 v100, v102
		v_exp_f32_e32 v164, v103
		v_exp_f32_e32 v102, v104
		v_exp_f32_e32 v166, v105
		v_exp_f32_e32 v104, v26
		v_exp_f32_e32 v168, v27
		v_exp_f32_e32 v26, v106
		v_exp_f32_e32 v170, v107
		v_exp_f32_e32 v106, v28
		v_exp_f32_e32 v182, v29
		v_exp_f32_e32 v28, v110
		v_exp_f32_e32 v198, v111
		v_exp_f32_e32 v110, v114
		v_exp_f32_e32 v212, v115
		v_exp_f32_e32 v114, v118
		v_exp_f32_e32 v214, v119
		v_exp_f32_e32 v118, v120
		v_exp_f32_e32 v216, v121
		v_exp_f32_e32 v120, v122
		v_exp_f32_e32 v218, v123
		v_exp_f32_e32 v122, v126
		v_exp_f32_e32 v220, v127
		v_exp_f32_e32 v127, v128
		v_exp_f32_e32 v223, v129
		v_exp_f32_e32 v139, v130
		v_exp_f32_e32 v147, v131
		v_exp_f32_e32 v157, v132
		v_exp_f32_e32 v159, v133
		v_exp_f32_e32 v113, v136
		v_exp_f32_e32 v161, v137
		v_exp_f32_e32 v99, v192
		v_exp_f32_e32 v163, v193
		v_exp_f32_e32 v101, v194
		v_exp_f32_e32 v165, v195
		v_exp_f32_e32 v103, v196
		v_exp_f32_e32 v167, v197
		v_exp_f32_e32 v105, v140
		v_exp_f32_e32 v169, v141
		v_exp_f32_e32 v27, v142
		v_exp_f32_e32 v171, v143
		v_exp_f32_e32 v107, v144
		v_exp_f32_e32 v183, v145
		v_exp_f32_e32 v29, v176
		v_exp_f32_e32 v199, v177
		v_exp_f32_e32 v111, v178
		v_exp_f32_e32 v213, v179
		v_exp_f32_e32 v115, v180
		v_exp_f32_e32 v215, v181
		v_exp_f32_e32 v119, v148
		v_exp_f32_e32 v217, v149
		v_exp_f32_e32 v121, v150
		v_exp_f32_e32 v219, v151
		v_exp_f32_e32 v123, v152
		v_exp_f32_e32 v221, v153
		v_pk_add_f32 v[128:129], v[184:185], v[224:225]
		v_pk_add_f32 v[130:131], v[96:97], v[226:227]
		v_pk_add_f32 v[132:133], v[188:189], v[228:229]
		v_pk_add_f32 v[136:137], v[190:191], v[230:231]
		v_pk_add_f32 v[140:141], v[174:175], v[232:233]
		v_pk_add_f32 v[142:143], v[200:201], v[234:235]
		v_pk_add_f32 v[144:145], v[116:117], v[236:237]
		v_pk_add_f32 v[148:149], v[202:203], v[238:239]
		v_pk_add_f32 v[150:151], v[108:109], v[240:241]
		v_pk_add_f32 v[152:153], v[204:205], v[242:243]
		v_pk_add_f32 v[176:177], v[30:31], v[244:245]
		v_pk_add_f32 v[178:179], v[206:207], v[246:247]
		v_pk_add_f32 v[180:181], v[124:125], v[248:249]
		v_pk_add_f32 v[192:193], v[208:209], v[250:251]
		v_pk_add_f32 v[194:195], v[134:135], v[252:253]
		v_pk_add_f32 v[196:197], v[210:211], v[254:255]
		v_pk_add_f32 v[128:129], v[128:129], v[130:131]
		v_pk_add_f32 v[130:131], v[132:133], v[136:137]
		v_pk_add_f32 v[132:133], v[140:141], v[142:143]
		v_pk_add_f32 v[136:137], v[144:145], v[148:149]
		v_pk_add_f32 v[140:141], v[150:151], v[152:153]
		v_pk_add_f32 v[142:143], v[176:177], v[178:179]
		v_pk_add_f32 v[144:145], v[180:181], v[192:193]
		v_pk_add_f32 v[148:149], v[194:195], v[196:197]
		v_pk_add_f32 v[128:129], v[128:129], v[130:131]
		v_pk_add_f32 v[130:131], v[132:133], v[136:137]
		v_pk_add_f32 v[132:133], v[140:141], v[142:143]
		v_pk_add_f32 v[136:137], v[144:145], v[148:149]
		v_pk_add_f32 v[128:129], v[128:129], v[130:131]
		v_pk_add_f32 v[130:131], v[132:133], v[136:137]
		v_pk_add_f32 v[132:133], v[128:129], v[130:131]
		v_add_f32_e32 v128, v132, v133
		v_mov_b32_e32 v129, v128
		v_exp_f32_e32 v126, v172
		v_exp_f32_e32 v222, v173
		v_permlane32_swap_b32_e32 v128, v129
		v_pk_add_f32 v[130:131], v[126:127], v[222:223]
		v_pk_add_f32 v[132:133], v[138:139], v[146:147]
		v_pk_add_f32 v[136:137], v[156:157], v[158:159]
		v_pk_add_f32 v[140:141], v[112:113], v[160:161]
		v_pk_add_f32 v[142:143], v[98:99], v[162:163]
		v_pk_add_f32 v[144:145], v[100:101], v[164:165]
		v_pk_add_f32 v[148:149], v[102:103], v[166:167]
		v_pk_add_f32 v[150:151], v[104:105], v[168:169]
		v_pk_add_f32 v[152:153], v[26:27], v[170:171]
		v_pk_add_f32 v[172:173], v[106:107], v[182:183]
		v_pk_add_f32 v[176:177], v[28:29], v[198:199]
		v_pk_add_f32 v[178:179], v[110:111], v[212:213]
		v_pk_add_f32 v[180:181], v[114:115], v[214:215]
		v_pk_add_f32 v[192:193], v[118:119], v[216:217]
		v_pk_add_f32 v[194:195], v[120:121], v[218:219]
		v_pk_add_f32 v[196:197], v[122:123], v[220:221]
		v_pk_add_f32 v[130:131], v[130:131], v[132:133]
		v_pk_add_f32 v[132:133], v[136:137], v[140:141]
		v_pk_add_f32 v[136:137], v[142:143], v[144:145]
		v_pk_add_f32 v[140:141], v[148:149], v[150:151]
		v_pk_add_f32 v[142:143], v[152:153], v[172:173]
		v_pk_add_f32 v[144:145], v[176:177], v[178:179]
		v_pk_add_f32 v[148:149], v[180:181], v[192:193]
		v_pk_add_f32 v[150:151], v[194:195], v[196:197]
		v_pk_add_f32 v[130:131], v[130:131], v[132:133]
		v_pk_add_f32 v[132:133], v[136:137], v[140:141]
		v_pk_add_f32 v[136:137], v[142:143], v[144:145]
		v_pk_add_f32 v[140:141], v[148:149], v[150:151]
		v_pk_add_f32 v[130:131], v[130:131], v[132:133]
		v_pk_add_f32 v[132:133], v[136:137], v[140:141]
		v_pk_add_f32 v[136:137], v[130:131], v[132:133]
		v_mov_b32_e32 v130, v129
		v_mov_b32_e32 v131, v137
		v_mov_b32_e32 v132, v128
		v_mov_b32_e32 v133, v136
		v_pk_add_f32 v[128:129], v[132:133], v[130:131]
		v_mov_b32_e32 v130, v129
		v_mov_b32_e32 v131, v129
		v_cvt_pk_bf16_f32 v140, v184, v224
		v_cvt_pk_bf16_f32 v141, v96, v226
		v_permlane32_swap_b32_e32 v130, v131
		v_add_f32_e32 v133, v130, v131
		v_mov_b32_e32 v155, v8
		v_pk_add_f32 v[130:131], v[154:155], v[186:187] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v136, v130
		v_exp_f32_e32 v137, v131
		v_cvt_pk_bf16_f32 v142, v188, v228
		v_pk_mul_f32 v[32:33], v[32:33], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[34:35], v[34:35], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[36:37], v[36:37], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[38:39], v[38:39], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[40:41], v[40:41], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[42:43], v[42:43], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[44:45], v[44:45], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[46:47], v[46:47], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[48:49], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[50:51], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[52:53], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[54:55], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[56:57], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[58:59], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[60:61], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[62:63], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[64:65], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[66:67], v[66:67], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[68:69], v[68:69], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[70:71], v[70:71], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[72:73], v[72:73], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[74:75], v[74:75], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[76:77], v[76:77], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[78:79], v[78:79], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[80:81], v[80:81], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[82:83], v[82:83], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[84:85], v[84:85], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[86:87], v[86:87], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[88:89], v[88:89], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[90:91], v[90:91], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[92:93], v[92:93], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[94:95], v[94:95], v[136:137] op_sel:[0,1]
		v_mov_b32_e32 v132, v128
		v_mov_b64_e32 v[128:129], v[24:25]
		v_pk_fma_f32 v[24:25], v[128:129], v[136:137], v[132:133]
		v_cvt_pk_bf16_f32 v143, v190, v230
		v_cvt_pk_bf16_f32 v128, v174, v232
		v_cvt_pk_bf16_f32 v129, v200, v234
		v_cvt_pk_bf16_f32 v130, v116, v236
		v_cvt_pk_bf16_f32 v131, v202, v238
		v_cvt_pk_bf16_f32 v148, v108, v240
		v_cvt_pk_bf16_f32 v149, v204, v242
		v_cvt_pk_bf16_f32 v150, v30, v244
		v_cvt_pk_bf16_f32 v151, v206, v246
		v_cvt_pk_bf16_f32 v152, v124, v248
		v_cvt_pk_bf16_f32 v153, v208, v250
		v_cvt_pk_bf16_f32 v154, v134, v252
		v_cvt_pk_bf16_f32 v155, v210, v254
		v_cvt_pk_bf16_f32 v176, v185, v225
		v_cvt_pk_bf16_f32 v177, v97, v227
		v_cvt_pk_bf16_f32 v178, v189, v229
		v_cvt_pk_bf16_f32 v179, v191, v231
		v_cvt_pk_bf16_f32 v188, v175, v233
		v_cvt_pk_bf16_f32 v189, v201, v235
		v_cvt_pk_bf16_f32 v190, v117, v237
		v_cvt_pk_bf16_f32 v191, v203, v239
		v_cvt_pk_bf16_f32 v172, v109, v241
		v_cvt_pk_bf16_f32 v173, v205, v243
		v_cvt_pk_bf16_f32 v174, v31, v245
		v_cvt_pk_bf16_f32 v175, v207, v247
		v_cvt_pk_bf16_f32 v192, v125, v249
		v_cvt_pk_bf16_f32 v193, v209, v251
		v_cvt_pk_bf16_f32 v194, v135, v253
		v_cvt_pk_bf16_f32 v195, v211, v255
		v_cvt_pk_bf16_f32 v132, v126, v222
		v_cvt_pk_bf16_f32 v133, v138, v146
		v_cvt_pk_bf16_f32 v134, v156, v158
		v_cvt_pk_bf16_f32 v135, v112, v160
		v_cvt_pk_bf16_f32 v200, v98, v162
		v_cvt_pk_bf16_f32 v201, v100, v164
		v_cvt_pk_bf16_f32 v202, v102, v166
		v_cvt_pk_bf16_f32 v203, v104, v168
		v_cvt_pk_bf16_f32 v204, v26, v170
		v_cvt_pk_bf16_f32 v205, v106, v182
		v_cvt_pk_bf16_f32 v206, v28, v198
		v_cvt_pk_bf16_f32 v207, v110, v212
		v_cvt_pk_bf16_f32 v208, v114, v214
		v_cvt_pk_bf16_f32 v209, v118, v216
		v_cvt_pk_bf16_f32 v210, v120, v218
		v_cvt_pk_bf16_f32 v211, v122, v220
		v_cvt_pk_bf16_f32 v224, v127, v223
		v_cvt_pk_bf16_f32 v225, v139, v147
		v_cvt_pk_bf16_f32 v226, v157, v159
		v_cvt_pk_bf16_f32 v227, v113, v161
		v_cvt_pk_bf16_f32 v124, v99, v163
		v_cvt_pk_bf16_f32 v125, v101, v165
		v_cvt_pk_bf16_f32 v126, v103, v167
		v_cvt_pk_bf16_f32 v127, v105, v169
		v_cvt_pk_bf16_f32 v96, v27, v171
		v_cvt_pk_bf16_f32 v97, v107, v183
		v_cvt_pk_bf16_f32 v98, v29, v199
		v_cvt_pk_bf16_f32 v99, v111, v213
		v_cvt_pk_bf16_f32 v28, v115, v215
		v_cvt_pk_bf16_f32 v29, v119, v217
		v_cvt_pk_bf16_f32 v30, v121, v219
		v_cvt_pk_bf16_f32 v31, v123, v221
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[32:47], a[184:187], v[140:143], v[32:47]
		v_permlane32_swap_b32_e32 v148, v150
		v_permlane32_swap_b32_e32 v149, v151
		v_mfma_f32_32x32x16_bf16 v[48:63], a[216:219], v[140:143], v[48:63]
		v_permlane32_swap_b32_e32 v152, v154
		v_permlane32_swap_b32_e32 v153, v155
		v_mfma_f32_32x32x16_bf16 v[32:47], a[188:191], v[128:131], v[32:47]
		v_permlane32_swap_b32_e32 v176, v178
		v_permlane32_swap_b32_e32 v177, v179
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[220:223], v[128:131], v[48:63]
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[148:151], v[32:47]
		v_permlane32_swap_b32_e32 v172, v174
		v_permlane32_swap_b32_e32 v173, v175
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[148:151], v[48:63]
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[152:155], v[32:47]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[152:155], v[48:63]
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_mfma_f32_32x32x16_bf16 v[80:95], a[216:219], v[132:135], v[80:95]
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_mfma_f32_32x32x16_bf16 v[64:79], a[184:187], v[132:135], v[64:79]
		v_permlane32_swap_b32_e32 v208, v210
		v_permlane32_swap_b32_e32 v209, v211
		v_mfma_f32_32x32x16_bf16 v[80:95], a[220:223], v[200:203], v[80:95]
		v_permlane32_swap_b32_e32 v224, v226
		v_permlane32_swap_b32_e32 v225, v227
		v_mfma_f32_32x32x16_bf16 v[64:79], a[188:191], v[200:203], v[64:79]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[204:207], v[80:95]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[204:207], v[64:79]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[208:211], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[208:211], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[176:179], v[32:47]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[176:179], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[224:227], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[224:227], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[188:191], v[32:47]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[188:191], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[124:127], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[124:127], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[172:175], v[32:47]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[172:175], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[192:195], v[32:47]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[192:195], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[28:31], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[28:31], v[64:79]
		s_cselect_b32 s1, 1, 0
		s_add_i32 s25, s41, 0x80
		s_cmp_lg_u32 s1, 0
		s_mov_b32 s41, s25
		v_mov_b32_e32 v2, v186
		v_mov_b32_e32 v8, v187
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_2
.L_attn_fwd_persistent.loop_exit_2:
		v_rcp_f32_e32 v2, v24
		v_accvgpr_read_b32 v1, a12
		s_nop 0
		v_readfirstlane_b32 s1, v1
		v_accvgpr_read_b32 v1, a4
		s_nop 0
		v_readfirstlane_b32 s18, v1
		s_mul_i32 s1, s1, s18
		v_mov_b32_e32 v3, v2
		v_pk_mul_f32 v[4:5], v[32:33], v[2:3]
		v_pk_mul_f32 v[6:7], v[34:35], v[2:3]
		v_pk_mul_f32 v[8:9], v[36:37], v[2:3]
		v_pk_mul_f32 v[10:11], v[38:39], v[2:3]
		v_pk_mul_f32 v[12:13], v[40:41], v[2:3]
		v_pk_mul_f32 v[14:15], v[42:43], v[2:3]
		v_pk_mul_f32 v[16:17], v[44:45], v[2:3]
		v_pk_mul_f32 v[18:19], v[46:47], v[2:3]
		v_pk_mul_f32 v[20:21], v[48:49], v[2:3]
		v_pk_mul_f32 v[22:23], v[50:51], v[2:3]
		v_pk_mul_f32 v[26:27], v[52:53], v[2:3]
		v_pk_mul_f32 v[28:29], v[54:55], v[2:3]
		v_pk_mul_f32 v[30:31], v[56:57], v[2:3]
		v_pk_mul_f32 v[32:33], v[58:59], v[2:3]
		v_pk_mul_f32 v[34:35], v[60:61], v[2:3]
		v_pk_mul_f32 v[36:37], v[62:63], v[2:3]
		v_rcp_f32_e32 v2, v25
		v_cvt_pk_bf16_f32 v40, v4, v5
		v_mov_b32_e32 v3, v2
		v_pk_mul_f32 v[4:5], v[64:65], v[2:3]
		v_pk_mul_f32 v[24:25], v[66:67], v[2:3]
		v_pk_mul_f32 v[38:39], v[68:69], v[2:3]
		v_pk_mul_f32 v[44:45], v[70:71], v[2:3]
		v_pk_mul_f32 v[46:47], v[72:73], v[2:3]
		v_pk_mul_f32 v[48:49], v[74:75], v[2:3]
		v_pk_mul_f32 v[50:51], v[76:77], v[2:3]
		v_pk_mul_f32 v[52:53], v[78:79], v[2:3]
		v_pk_mul_f32 v[54:55], v[80:81], v[2:3]
		v_pk_mul_f32 v[56:57], v[82:83], v[2:3]
		v_pk_mul_f32 v[58:59], v[84:85], v[2:3]
		v_pk_mul_f32 v[60:61], v[86:87], v[2:3]
		v_pk_mul_f32 v[62:63], v[88:89], v[2:3]
		v_pk_mul_f32 v[64:65], v[90:91], v[2:3]
		v_pk_mul_f32 v[66:67], v[92:93], v[2:3]
		v_pk_mul_f32 v[68:69], v[94:95], v[2:3]
		v_cvt_pk_bf16_f32 v41, v6, v7
		v_cvt_pk_bf16_f32 v42, v8, v9
		v_cvt_pk_bf16_f32 v43, v10, v11
		v_cvt_pk_bf16_f32 v8, v12, v13
		v_cvt_pk_bf16_f32 v9, v14, v15
		v_cvt_pk_bf16_f32 v10, v16, v17
		v_cvt_pk_bf16_f32 v11, v18, v19
		v_cvt_pk_bf16_f32 v12, v20, v21
		v_cvt_pk_bf16_f32 v13, v22, v23
		v_cvt_pk_bf16_f32 v14, v26, v27
		v_cvt_pk_bf16_f32 v15, v28, v29
		v_cvt_pk_bf16_f32 v16, v30, v31
		v_cvt_pk_bf16_f32 v17, v32, v33
		v_cvt_pk_bf16_f32 v18, v34, v35
		v_cvt_pk_bf16_f32 v19, v36, v37
		v_cvt_pk_bf16_f32 v20, v4, v5
		v_cvt_pk_bf16_f32 v21, v24, v25
		v_cvt_pk_bf16_f32 v22, v38, v39
		v_cvt_pk_bf16_f32 v23, v44, v45
		v_cvt_pk_bf16_f32 v4, v46, v47
		v_cvt_pk_bf16_f32 v5, v48, v49
		v_cvt_pk_bf16_f32 v6, v50, v51
		v_cvt_pk_bf16_f32 v7, v52, v53
		v_cvt_pk_bf16_f32 v24, v54, v55
		v_cvt_pk_bf16_f32 v25, v56, v57
		v_cvt_pk_bf16_f32 v26, v58, v59
		v_cvt_pk_bf16_f32 v27, v60, v61
		v_cvt_pk_bf16_f32 v28, v62, v63
		v_cvt_pk_bf16_f32 v29, v64, v65
		v_cvt_pk_bf16_f32 v30, v66, v67
		v_cvt_pk_bf16_f32 v31, v68, v69
		v_permlane32_swap_b32_e32 v40, v42
		v_permlane32_swap_b32_e32 v41, v43
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
		v_permlane32_swap_b32_e32 v12, v14
		v_permlane32_swap_b32_e32 v13, v15
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v20, v22
		v_permlane32_swap_b32_e32 v21, v23
		v_permlane32_swap_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v5, v7
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		s_lshl_b32 s1, s1, 9
		v_accvgpr_read_b32 v1, a2
		s_nop 0
		v_readfirstlane_b32 s18, v1
		v_accvgpr_read_b32 v1, a10
		s_nop 0
		v_readfirstlane_b32 s21, v1
		s_mul_i32 s18, s21, s18
		s_lshl_b32 s18, s18, 1
		s_add_i32 s21, s1, s18
		v_accvgpr_read_b32 v1, a3
		s_nop 0
		v_readfirstlane_b32 s22, v1
		v_accvgpr_read_b32 v1, a11
		s_nop 0
		v_readfirstlane_b32 s23, v1
		s_mul_i32 s22, s23, s22
		s_lshl_b32 s22, s22, 1
		s_add_i32 s21, s21, s22
		v_accvgpr_read_b32 v1, a16
		s_nop 0
		v_readfirstlane_b32 s23, v1
		v_accvgpr_read_b32 v1, a4
		s_nop 0
		v_readfirstlane_b32 s24, v1
		s_mul_i32 s23, s24, s23
		s_lshl_b32 s23, s23, 6
		s_add_i32 s21, s21, s23
		v_and_b32_e32 v1, 31, v0
		v_accvgpr_read_b32 v2, a4
		s_nop 0
		v_readfirstlane_b32 s24, v2
		s_nop 1
		v_mul_lo_u32 v1, s24, v1
		v_lshlrev_b32_e32 v1, 1, v1
		v_accvgpr_read_b32 v2, a17
		v_lshlrev_b32_e32 v2, 4, v2
		v_add3_u32 v3, s21, v1, v2
		v_accvgpr_read_b32 v32, a13
		v_accvgpr_read_b32 v33, a52
		s_nop 0
		v_readfirstlane_b32 s24, v33
		v_accvgpr_read_b32 v33, a53
		s_nop 0
		v_readfirstlane_b32 s25, v33
		s_nop 1
		v_cndmask_b32_e64 v3, v32, v3, s[24:25]
		s_mov_b32 s32, s8
		s_mov_b32 s33, s9
		s_mov_b32 s34, s30
		s_mov_b32 s35, s31
		buffer_store_dwordx4 v[40:43], v3, s[32:35], 0 offen
		s_add_i32 s24, s21, 32
		v_add3_u32 v3, s24, v1, v2
		v_accvgpr_read_b32 v32, a13
		v_accvgpr_read_b32 v33, a52
		s_nop 0
		v_readfirstlane_b32 s24, v33
		v_accvgpr_read_b32 v33, a53
		s_nop 0
		v_readfirstlane_b32 s25, v33
		s_nop 1
		v_cndmask_b32_e64 v3, v32, v3, s[24:25]
		buffer_store_dwordx4 v[8:11], v3, s[32:35], 0 offen
		s_add_i32 s24, s21, 64
		v_add3_u32 v3, s24, v1, v2
		v_accvgpr_read_b32 v8, a13
		v_accvgpr_read_b32 v9, a52
		s_nop 0
		v_readfirstlane_b32 s24, v9
		v_accvgpr_read_b32 v9, a53
		s_nop 0
		v_readfirstlane_b32 s25, v9
		s_nop 1
		v_cndmask_b32_e64 v3, v8, v3, s[24:25]
		buffer_store_dwordx4 v[12:15], v3, s[32:35], 0 offen
		s_add_i32 s21, s21, 0x60
		v_add3_u32 v3, s21, v1, v2
		v_accvgpr_read_b32 v8, a13
		v_accvgpr_read_b32 v9, a52
		s_nop 0
		v_readfirstlane_b32 s24, v9
		v_accvgpr_read_b32 v9, a53
		s_nop 0
		v_readfirstlane_b32 s25, v9
		s_nop 1
		v_cndmask_b32_e64 v3, v8, v3, s[24:25]
		buffer_store_dwordx4 v[16:19], v3, s[32:35], 0 offen
		v_accvgpr_read_b32 v3, a4
		s_nop 0
		v_readfirstlane_b32 s21, v3
		s_lshl_b32 s21, s21, 8
		s_add_i32 s1, s21, s1
		s_add_i32 s1, s1, s18
		s_add_i32 s1, s1, s22
		s_add_i32 s1, s1, s23
		v_add3_u32 v3, s1, v1, v2
		v_accvgpr_read_b32 v8, a13
		v_accvgpr_read_b32 v9, a60
		s_nop 0
		v_readfirstlane_b32 s22, v9
		v_accvgpr_read_b32 v9, a61
		s_nop 0
		v_readfirstlane_b32 s23, v9
		s_nop 1
		v_cndmask_b32_e64 v3, v8, v3, s[22:23]
		buffer_store_dwordx4 v[20:23], v3, s[32:35], 0 offen
		s_add_i32 s18, s1, 32
		v_add3_u32 v3, s18, v1, v2
		v_accvgpr_read_b32 v8, a13
		v_accvgpr_read_b32 v9, a60
		s_nop 0
		v_readfirstlane_b32 s22, v9
		v_accvgpr_read_b32 v9, a61
		s_nop 0
		v_readfirstlane_b32 s23, v9
		s_nop 1
		v_cndmask_b32_e64 v3, v8, v3, s[22:23]
		buffer_store_dwordx4 v[4:7], v3, s[32:35], 0 offen
		s_add_i32 s18, s1, 64
		v_add3_u32 v3, s18, v1, v2
		v_accvgpr_read_b32 v4, a13
		v_accvgpr_read_b32 v5, a60
		s_nop 0
		v_readfirstlane_b32 s22, v5
		v_accvgpr_read_b32 v5, a61
		s_nop 0
		v_readfirstlane_b32 s23, v5
		s_nop 1
		v_cndmask_b32_e64 v3, v4, v3, s[22:23]
		buffer_store_dwordx4 v[24:27], v3, s[32:35], 0 offen
		s_add_i32 s1, s1, 0x60
		v_add3_u32 v1, s1, v1, v2
		v_accvgpr_read_b32 v2, a13
		v_accvgpr_read_b32 v3, a60
		s_nop 0
		v_readfirstlane_b32 s22, v3
		v_accvgpr_read_b32 v3, a61
		s_nop 0
		v_readfirstlane_b32 s23, v3
		s_nop 1
		v_cndmask_b32_e64 v1, v2, v1, s[22:23]
		buffer_store_dwordx4 v[28:31], v1, s[32:35], 0 offen
		s_branch .L_attn_fwd_persistent.if_end_1
.L_attn_fwd_persistent.if_else_1:
.L_attn_fwd_persistent.if_end_1:
		s_and_b32 s1, s0, 15
		s_mul_i32 s1, s1, 2
		s_add_i32 s1, s1, 1
		s_cmp_lt_i32 s1, 32
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_3
		s_lshr_b32 s18, s1, 1
		s_and_b32 s1, s1, 1
		s_mov_b32 s21, 31
		s_sub_i32 s21, s21, s18
		s_cmp_eq_u32 s1, 0
		s_cselect_b32 s1, s18, s21
		v_mov_b32_e32 v1, s1
		v_accvgpr_write_b32 a12, v1
		v_accvgpr_read_b32 v1, a12
		s_nop 0
		v_readfirstlane_b32 s1, v1
		s_mul_i32 s1, s1, 0x100
		v_lshrrev_b32_e32 v1, 3, v0
		v_and_b32_e32 v2, 1, v1
		v_lshrrev_b32_e32 v3, 4, v0
		v_and_b32_e32 v4, 1, v3
		v_lshrrev_b32_e32 v5, 6, v0
		v_and_b32_e32 v5, 1, v5
		v_lshrrev_b32_e32 v6, 7, v0
		v_and_b32_e32 v6, 1, v6
		v_mov_b32_e32 v7, 2
		v_mul_lo_u32 v7, v7, v4
		v_lshrrev_b32_e32 v8, 5, v0
		v_and_b32_e32 v9, 1, v8
		v_mov_b32_e32 v10, 4
		v_mul_lo_u32 v10, v10, v9
		v_bitop3_b32 v11, v2, v7, v10 bitop3:0x96
		v_mov_b32_e32 v12, 8
		v_mul_lo_u32 v12, v12, v5
		v_xor_b32_e32 v11, v11, v12
		v_mov_b32_e32 v13, 16
		v_mul_lo_u32 v13, v13, v6
		v_xad_u32 v11, v11, v13, s1
		v_readfirstlane_b32 s18, v0
		v_cmp_lt_i32_e64 s[22:23], v11, s19
		s_mov_b32 s30, 0x7fffffff
		s_mov_b32 s31, 0x31016000
		s_mov_b32 s28, s4
		s_mov_b32 s29, s5
		s_mov_b32 s32, s6
		s_mov_b32 s33, s7
		s_mov_b32 s34, s30
		s_mov_b32 s35, s31
		v_accvgpr_read_b32 v11, a12
		s_nop 0
		v_readfirstlane_b32 s21, v11
		s_mul_i32 s21, s21, s12
		s_lshl_b32 s21, s21, 9
		v_accvgpr_read_b32 v11, a10
		s_nop 0
		v_readfirstlane_b32 s24, v11
		s_mul_i32 s24, s24, s10
		s_lshl_b32 s24, s24, 1
		s_add_i32 s25, s21, s24
		v_accvgpr_read_b32 v11, a11
		s_nop 0
		v_readfirstlane_b32 s26, v11
		s_mul_i32 s26, s26, s11
		s_lshl_b32 s26, s26, 1
		s_add_i32 s25, s25, s26
		v_mul_lo_u32 v11, s12, v1
		v_lshlrev_b32_e32 v11, 1, v11
		v_and_b32_e32 v14, 7, v0
		v_lshlrev_b32_e32 v14, 4, v14
		v_add3_u32 v15, s25, v11, v14
		v_mov_b32_e32 v16, 0x7fffffff
		v_accvgpr_write_b32 a13, v16
		v_accvgpr_read_b32 v16, a13
		v_cndmask_b32_e64 v15, v16, v15, s[22:23]
		s_mov_b32 s36, s2
		s_mov_b32 s37, s3
		s_mov_b32 s38, s30
		s_mov_b32 s39, s31
		buffer_load_dwordx4 v[16:19], v15, s[36:39], 0 offen
		v_bitop3_b32 v15, 32, v2, v7 bitop3:0x96
		v_bitop3_b32 v15, v15, v10, v12 bitop3:0x96
		v_xad_u32 v15, v15, v13, s1
		v_and_b32_e32 v20, 1, v0
		v_cmp_lt_i32_e64 s[22:23], v15, s19
		s_lshl_b32 s25, s12, 6
		s_add_i32 s25, s25, s21
		s_add_i32 s25, s25, s24
		s_add_i32 s25, s25, s26
		v_add3_u32 v15, s25, v11, v14
		v_accvgpr_read_b32 v21, a13
		v_cndmask_b32_e64 v15, v21, v15, s[22:23]
		buffer_load_dwordx4 v[24:27], v15, s[36:39], 0 offen
		v_bitop3_b32 v15, 64, v2, v7 bitop3:0x96
		v_bitop3_b32 v15, v15, v10, v12 bitop3:0x96
		v_xad_u32 v15, v15, v13, s1
		v_lshrrev_b32_e32 v21, 1, v0
		v_cmp_lt_i32_e64 s[22:23], v15, s19
		s_lshl_b32 s25, s12, 7
		s_add_i32 s25, s25, s21
		s_add_i32 s25, s25, s24
		s_add_i32 s25, s25, s26
		v_add3_u32 v15, s25, v11, v14
		v_accvgpr_read_b32 v22, a13
		v_cndmask_b32_e64 v15, v22, v15, s[22:23]
		buffer_load_dwordx4 v[28:31], v15, s[36:39], 0 offen
		v_xor_b32_e32 v15, 0x60, v2
		v_xor_b32_e32 v15, v15, v7
		v_xor_b32_e32 v15, v15, v10
		v_xor_b32_e32 v15, v15, v12
		v_xad_u32 v15, v15, v13, s1
		v_and_b32_e32 v22, 1, v21
		v_cmp_lt_i32_e64 s[22:23], v15, s19
		s_mul_i32 s25, 0xc0, s12
		s_add_i32 s25, s25, s21
		s_add_i32 s25, s25, s24
		s_add_i32 s25, s25, s26
		v_add3_u32 v15, s25, v11, v14
		v_accvgpr_read_b32 v23, a13
		v_cndmask_b32_e64 v15, v23, v15, s[22:23]
		buffer_load_dwordx4 v[32:35], v15, s[36:39], 0 offen
		v_xor_b32_e32 v15, 0x80, v2
		v_xor_b32_e32 v15, v15, v7
		v_xor_b32_e32 v15, v15, v10
		v_xor_b32_e32 v15, v15, v12
		v_xad_u32 v15, v15, v13, s1
		v_mov_b32_e32 v23, 2
		v_mul_lo_u32 v23, v23, v22
		v_cmp_lt_i32_e64 s[22:23], v15, s19
		s_lshl_b32 s25, s12, 8
		s_add_i32 s25, s25, s21
		s_add_i32 s25, s25, s24
		s_add_i32 s25, s25, s26
		v_add3_u32 v15, s25, v11, v14
		v_accvgpr_read_b32 v22, a13
		v_cndmask_b32_e64 v15, v22, v15, s[22:23]
		buffer_load_dwordx4 v[36:39], v15, s[36:39], 0 offen
		v_xor_b32_e32 v15, 0xa0, v2
		v_xor_b32_e32 v15, v15, v7
		v_xor_b32_e32 v15, v15, v10
		v_xor_b32_e32 v15, v15, v12
		v_xad_u32 v15, v15, v13, s1
		v_lshrrev_b32_e32 v22, 2, v0
		v_cmp_lt_i32_e64 s[22:23], v15, s19
		s_mul_i32 s25, 0x140, s12
		s_add_i32 s25, s25, s21
		s_add_i32 s25, s25, s24
		s_add_i32 s25, s25, s26
		v_add3_u32 v15, s25, v11, v14
		v_accvgpr_read_b32 v40, a13
		v_cndmask_b32_e64 v15, v40, v15, s[22:23]
		buffer_load_dwordx4 v[40:43], v15, s[36:39], 0 offen
		v_xor_b32_e32 v15, 0xc0, v2
		v_xor_b32_e32 v15, v15, v7
		v_xor_b32_e32 v15, v15, v10
		v_xor_b32_e32 v15, v15, v12
		v_xad_u32 v15, v15, v13, s1
		v_and_b32_e32 v44, 1, v22
		v_cmp_lt_i32_e64 s[22:23], v15, s19
		s_mul_i32 s25, 0x180, s12
		s_add_i32 s25, s25, s21
		s_add_i32 s25, s25, s24
		s_add_i32 s25, s25, s26
		v_add3_u32 v15, s25, v11, v14
		v_accvgpr_read_b32 v45, a13
		v_cndmask_b32_e64 v15, v45, v15, s[22:23]
		buffer_load_dwordx4 v[48:51], v15, s[36:39], 0 offen
		v_xor_b32_e32 v15, 0xe0, v2
		v_xor_b32_e32 v7, v15, v7
		v_xor_b32_e32 v7, v7, v10
		v_xor_b32_e32 v7, v7, v12
		v_xad_u32 v7, v7, v13, s1
		s_mul_i32 s22, 0x1c0, s12
		s_add_i32 s21, s22, s21
		s_add_i32 s21, s21, s24
		s_add_i32 s21, s21, s26
		v_add3_u32 v11, s21, v11, v14
		v_cmp_lt_i32_e64 vcc, v7, s19
		v_mov_b32_e32 v7, 4
		v_mul_lo_u32 v7, v7, v44
		v_accvgpr_read_b32 v12, a13
		v_cndmask_b32_e32 v11, v12, v11, vcc
		buffer_load_dwordx4 v[44:47], v11, s[36:39], 0 offen
		v_bitop3_b32 v11, v20, v23, v7 bitop3:0x96
		v_mov_b32_e32 v12, 8
		v_mul_lo_u32 v12, v12, v2
		v_xor_b32_e32 v11, v11, v12
		v_mov_b32_e32 v13, 16
		v_mul_lo_u32 v13, v13, v4
		v_mov_b32_e32 v15, 32
		v_mul_lo_u32 v15, v15, v5
		v_bitop3_b32 v11, v11, v13, v15 bitop3:0x96
		v_mov_b32_e32 v52, 64
		v_mul_lo_u32 v52, v52, v6
		v_xor_b32_e32 v11, v11, v52
		v_accvgpr_write_b32 a14, v11
		v_accvgpr_read_b32 v11, a14
		v_add_u32_e32 v11, s1, v11
		v_xor_b32_e32 v20, 0x80, v20
		v_xor_b32_e32 v20, v20, v23
		v_xor_b32_e32 v7, v20, v7
		v_bitop3_b32 v7, v7, v12, v13 bitop3:0x96
		v_bitop3_b32 v7, v7, v15, v52 bitop3:0x96
		v_accvgpr_write_b32 a15, v7
		s_lshr_b32 s18, s18, 6
		v_mov_b32_e32 v7, s18
		v_accvgpr_write_b32 a16, v7
		s_waitcnt vmcnt(8)
		s_barrier
		v_and_b32_e32 v7, 5, v8
		v_bitop3_b32 v7, 4, v21, v7 bitop3:0x6a
		v_bitop3_b32 v7, 2, v1, v7 bitop3:0x6a
		v_xor_b32_e32 v7, v0, v7
		v_lshlrev_b32_e32 v7, 4, v7
		v_add_u32_e32 v7, 0x10000, v7
		s_waitcnt vmcnt(7)
		ds_write_b128 v7, v[16:19] offset:18864
		s_waitcnt vmcnt(6)
		ds_write_b128 v7, v[24:27] offset:22960
		s_waitcnt vmcnt(5)
		ds_write_b128 v7, v[28:31] offset:27056
		s_waitcnt vmcnt(4)
		ds_write_b128 v7, v[32:35] offset:31152
		v_mov_b32_e32 v12, 32
		v_mul_lo_u32 v12, v12, v4
		v_mov_b32_e32 v4, 2
		v_mul_lo_u32 v4, v4, v6
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v6, a16
		s_nop 0
		v_readfirstlane_b32 s18, v6
		s_lshl_b32 s18, s18, 12
		s_add_i32 s18, s18, 0x10000
		v_and_b32_e32 v6, 63, v0
		v_lshrrev_b32_e32 v13, 5, v6
		v_and_b32_e32 v15, 31, v6
		v_lshlrev_b32_e32 v16, 3, v15
		v_add_u32_e32 v17, v13, v16
		v_lshlrev_b32_e32 v18, 2, v15
		v_and_b32_e32 v19, 7, v6
		v_lshrrev_b32_e32 v19, 2, v19
		v_lshrrev_b32_e32 v6, 3, v6
		v_and_b32_e32 v6, 3, v6
		v_lshl_add_u32 v6, v6, 1, v19
		v_and_b32_e32 v6, 5, v6
		v_bitop3_b32 v19, 4, v18, v6 bitop3:0x6a
		v_xor_b32_e32 v17, v17, v19
		v_lshlrev_b32_e32 v17, 4, v17
		v_and_b32_e32 v19, 2, v15
		v_lshlrev_b32_e32 v20, 4, v19
		v_add3_u32 v17, s18, v17, v20
		ds_read_b128 a[20:23], v17 offset:18864
		v_add3_u32 v21, 2, v13, v16
		v_add_u32_e32 v23, 1, v18
		v_bitop3_b32 v23, 4, v23, v6 bitop3:0x6a
		v_bitop3_b32 v21, v21, v19, v23 bitop3:0x96
		v_lshl_add_u32 v21, v21, 4, s18
		ds_read_b128 a[24:27], v21 offset:18864
		v_add3_u32 v23, 4, v13, v16
		v_add_u32_e32 v24, 2, v18
		v_bitop3_b32 v24, 4, v24, v6 bitop3:0x6a
		v_xor_b32_e32 v23, v23, v24
		v_lshlrev_b32_e32 v23, 4, v23
		v_add3_u32 v20, s18, v23, v20
		ds_read_b128 a[28:31], v20 offset:18864
		v_add3_u32 v16, 6, v13, v16
		v_add_u32_e32 v18, 3, v18
		v_bitop3_b32 v6, 4, v18, v6 bitop3:0x6a
		v_bitop3_b32 v6, v16, v19, v6 bitop3:0x96
		v_lshl_add_u32 v6, v6, 4, s18
		ds_read_b128 a[32:35], v6 offset:18864
		v_and_b32_e32 v8, 1, v8
		v_accvgpr_write_b32 a17, v8
		v_and_b32_e32 v3, 1, v3
		v_and_b32_e32 v1, 1, v1
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(3)
		ds_write_b128 v7, v[36:39] offset:18864
		s_waitcnt vmcnt(2)
		ds_write_b128 v7, v[40:43] offset:22960
		s_waitcnt vmcnt(1)
		ds_write_b128 v7, v[48:51] offset:27056
		s_waitcnt vmcnt(0)
		ds_write_b128 v7, v[44:47] offset:31152
		v_and_b32_e32 v7, 1, v22
		v_accvgpr_read_b32 v8, a12
		s_nop 0
		v_readfirstlane_b32 s18, v8
		s_add_i32 s18, s18, 1
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[36:39], v17 offset:18864
		ds_read_b128 a[40:43], v21 offset:18864
		ds_read_b128 a[44:47], v20 offset:18864
		ds_read_b128 a[48:51], v6 offset:18864
		s_mul_i32 s18, s18, 0x100
		v_accvgpr_read_b32 v6, a6
		s_nop 0
		v_readfirstlane_b32 s21, v6
		s_add_i32 s18, s18, s21
		s_cmp_lt_i32 s20, s18
		s_cselect_b32 s18, s20, s18
		s_add_i32 s21, s18, 0x7f
		s_mov_b32 s22, 0x7f
		s_cmp_lt_i32 s21, 0
		s_cselect_b32 s23, s22, 0
		s_add_i32 s21, s21, s23
		s_ashr_i32 s21, s21, 7
		v_accvgpr_read_b32 v6, a6
		s_nop 0
		v_readfirstlane_b32 s23, v6
		s_add_i32 s23, s1, s23
		s_cmp_lt_i32 s23, 0
		s_cselect_b32 s24, s22, 0
		s_add_i32 s23, s23, s24
		s_ashr_i32 s23, s23, 7
		s_cmp_lt_i32 s23, s21
		s_cselect_b32 s23, s23, s21
		s_cmp_gt_i32 s23, 0
		s_cselect_b32 s23, s23, 0
		v_mov_b32_e32 v6, 64
		v_mul_lo_u32 v6, v6, v2
		v_mov_b32_e32 v8, 16
		v_mul_lo_u32 v8, v8, v9
		v_bitop3_b32 v16, v6, v12, v8 bitop3:0x96
		v_bitop3_b32 v16, v16, v5, v4 bitop3:0x96
		v_accvgpr_write_b32 a18, v16
		v_bitop3_b32 v16, 4, v6, v12 bitop3:0x96
		v_xor_b32_e32 v16, v16, v8
		v_bitop3_b32 v17, 8, v6, v12 bitop3:0x96
		v_xor_b32_e32 v17, v17, v8
		v_bitop3_b32 v6, 12, v6, v12 bitop3:0x96
		v_xor_b32_e32 v6, v6, v8
		v_accvgpr_read_b32 v8, a18
		v_cmp_lt_i32_e64 s[24:25], v8, s20
		v_mov_b32_e32 v8, 16
		v_mul_lo_u32 v8, v8, v2
		v_mov_b32_e32 v2, 64
		v_mul_lo_u32 v2, v2, v9
		v_bitop3_b32 v9, v8, v12, v2 bitop3:0x96
		v_bitop3_b32 v9, v9, v5, v4 bitop3:0x96
		v_accvgpr_write_b32 a19, v9
		v_bitop3_b32 v9, 4, v8, v12 bitop3:0x96
		v_bitop3_b32 v18, 8, v8, v12 bitop3:0x96
		v_bitop3_b32 v8, 12, v8, v12 bitop3:0x96
		v_accvgpr_read_b32 v12, a19
		v_cmp_lt_i32_e64 vcc, v12, s20
		v_readfirstlane_b32 s36, v0
		v_accvgpr_read_b32 v12, a10
		s_nop 0
		v_readfirstlane_b32 s26, v12
		s_mul_i32 s26, s26, s13
		s_lshl_b32 s26, s26, 1
		v_accvgpr_read_b32 v12, a11
		s_nop 0
		v_readfirstlane_b32 s37, v12
		s_mul_i32 s37, s37, s14
		s_lshl_b32 s37, s37, 1
		s_add_i32 s38, s26, s37
		v_accvgpr_read_b32 v12, a16
		s_nop 0
		v_readfirstlane_b32 s39, v12
		s_mul_i32 s39, s15, s39
		s_lshl_b32 s39, s39, 1
		s_add_i32 s38, s38, s39
		v_accvgpr_read_b32 v12, a17
		v_mul_lo_u32 v12, s15, v12
		v_lshlrev_b32_e32 v12, 5, v12
		v_mul_lo_u32 v19, s15, v3
		v_lshlrev_b32_e32 v19, 6, v19
		v_add3_u32 v20, s38, v12, v19
		v_mul_lo_u32 v21, s15, v1
		v_lshlrev_b32_e32 v21, 7, v21
		v_add3_u32 v20, v20, v21, v14
		v_mov_b32_e32 v22, 0x80000000
		v_cndmask_b32_e64 v20, v22, v20, s[24:25]
		s_lshr_b32 s38, s36, 6
		s_mul_i32 s40, 0x410, s38
		s_mov_b32 m0, s40
		v_accvgpr_read_b32 v23, a15
		v_add_u32_e32 v23, s1, v23
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		s_lshl_b32 s41, s15, 3
		s_add_i32 s41, s41, s26
		s_add_i32 s41, s41, s37
		s_add_i32 s41, s41, s39
		v_add3_u32 v20, s41, v12, v19
		v_add3_u32 v20, v20, v21, v14
		v_cndmask_b32_e64 v20, v22, v20, s[24:25]
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[42:43], v11, s19
		s_nop 1
		v_mov_b32_e32 v24, s42
		v_mov_b32_e32 v25, s43
		v_accvgpr_write_b32 a52, v24
		v_accvgpr_write_b32 a53, v25
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		v_bitop3_b32 v11, v16, v5, v4 bitop3:0x96
		v_accvgpr_write_b32 a54, v11
		s_lshl_b32 s41, s15, 4
		s_add_i32 s41, s41, s26
		s_add_i32 s41, s41, s37
		s_add_i32 s41, s41, s39
		v_add3_u32 v11, s41, v12, v19
		v_add3_u32 v11, v11, v21, v14
		v_cndmask_b32_e64 v11, v22, v11, s[24:25]
		s_add_i32 m0, m0, 0x1040
		v_lshlrev_b32_e32 v13, 4, v13
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		v_bitop3_b32 v11, v17, v5, v4 bitop3:0x96
		v_accvgpr_write_b32 a55, v11
		s_mul_i32 s41, 24, s15
		s_add_i32 s41, s41, s26
		s_add_i32 s41, s41, s37
		s_add_i32 s41, s41, s39
		v_add3_u32 v11, s41, v12, v19
		v_add3_u32 v11, v11, v21, v14
		v_cndmask_b32_e64 v11, v22, v11, s[24:25]
		s_add_i32 m0, m0, 0x1040
		v_mov_b32_e32 v16, 0x440
		v_mul_lo_u32 v16, v16, v7
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		v_bitop3_b32 v6, v6, v5, v4 bitop3:0x96
		v_accvgpr_write_b32 a56, v6
		v_accvgpr_read_b32 v6, a0
		s_nop 0
		v_readfirstlane_b32 s24, v6
		v_accvgpr_read_b32 v6, a10
		s_nop 0
		v_readfirstlane_b32 s25, v6
		s_mul_i32 s24, s25, s24
		s_lshl_b32 s24, s24, 1
		v_accvgpr_read_b32 v6, a1
		s_nop 0
		v_readfirstlane_b32 s25, v6
		v_accvgpr_read_b32 v6, a11
		s_nop 0
		v_readfirstlane_b32 s41, v6
		s_mul_i32 s25, s41, s25
		s_lshl_b32 s25, s25, 1
		s_add_i32 s41, s24, s25
		v_accvgpr_read_b32 v6, a16
		s_nop 0
		v_readfirstlane_b32 s42, v6
		s_mul_i32 s42, s17, s42
		s_lshl_b32 s42, s42, 1
		s_add_i32 s41, s41, s42
		v_accvgpr_read_b32 v6, a17
		v_mul_lo_u32 v6, s17, v6
		v_lshlrev_b32_e32 v6, 7, v6
		v_mul_lo_u32 v7, s17, v3
		v_lshlrev_b32_e32 v7, 6, v7
		v_add3_u32 v11, s41, v6, v7
		v_mul_lo_u32 v17, s17, v1
		v_lshlrev_b32_e32 v17, 5, v17
		v_add3_u32 v11, v11, v17, v14
		v_cndmask_b32_e32 v11, v22, v11, vcc
		s_mul_i32 s38, 0x440, s38
		s_add_i32 m0, s38, 0x81f0
		v_xor_b32_e32 v9, v9, v2
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		v_bitop3_b32 v9, v9, v5, v4 bitop3:0x96
		v_accvgpr_write_b32 a57, v9
		s_lshl_b32 s41, s17, 3
		s_add_i32 s41, s41, s24
		s_add_i32 s41, s41, s25
		s_add_i32 s41, s41, s42
		v_add3_u32 v9, s41, v6, v7
		v_add3_u32 v9, v9, v17, v14
		v_cndmask_b32_e32 v9, v22, v9, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v11, v18, v2
		buffer_load_dwordx4 v9, s[32:35], 0 offen lds
		v_bitop3_b32 v9, v11, v5, v4 bitop3:0x96
		v_accvgpr_write_b32 a58, v9
		s_lshl_b32 s41, s17, 4
		s_add_i32 s41, s41, s24
		s_add_i32 s41, s41, s25
		s_add_i32 s41, s41, s42
		v_add3_u32 v9, s41, v6, v7
		v_add3_u32 v9, v9, v17, v14
		v_cndmask_b32_e32 v9, v22, v9, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v2, v8, v2
		buffer_load_dwordx4 v9, s[32:35], 0 offen lds
		v_bitop3_b32 v2, v2, v5, v4 bitop3:0x96
		v_accvgpr_write_b32 a59, v2
		s_mul_i32 s41, 24, s17
		s_add_i32 s41, s41, s24
		s_add_i32 s41, s41, s25
		s_add_i32 s41, s41, s42
		v_add3_u32 v2, s41, v6, v7
		v_add3_u32 v2, v2, v17, v14
		v_cndmask_b32_e32 v2, v22, v2, vcc
		s_add_i32 m0, m0, 0x1100
		v_cmp_lt_i32_e64 s[44:45], v23, s19
		s_nop 1
		v_mov_b32_e32 v4, s44
		v_mov_b32_e32 v5, s45
		v_accvgpr_write_b32 a60, v4
		v_accvgpr_write_b32 a61, v5
		buffer_load_dwordx4 v2, s[32:35], 0 offen lds
		s_mul_i32 s41, s23, 0x80
		s_lshl_b32 s23, s15, 8
		s_add_i32 s43, s23, s26
		s_add_i32 s43, s43, s37
		s_add_i32 s43, s43, s39
		s_mul_i32 s44, 0x108, s15
		s_add_i32 s44, s44, s26
		s_add_i32 s44, s44, s37
		s_add_i32 s44, s44, s39
		v_add3_u32 v2, v12, v19, v21
		s_mul_i32 s45, 0x110, s15
		s_add_i32 s45, s45, s26
		s_add_i32 s45, s45, s37
		s_add_i32 s45, s45, s39
		v_add3_u32 v4, v14, v2, s45
		s_mul_i32 s46, 0x118, s15
		s_add_i32 s26, s46, s26
		s_add_i32 s26, s26, s37
		s_add_i32 s26, s26, s39
		v_add3_u32 v5, v14, v2, s26
		s_lshl_b32 s37, s17, 8
		s_add_i32 s37, s37, s24
		s_add_i32 s37, s37, s25
		s_add_i32 s39, s37, s42
		s_mul_i32 s37, 0x108, s17
		s_add_i32 s37, s37, s24
		s_add_i32 s37, s37, s25
		s_add_i32 s46, s37, s42
		s_mul_i32 s37, 0x110, s17
		s_add_i32 s37, s37, s24
		s_add_i32 s37, s37, s25
		s_add_i32 s47, s37, s42
		s_mul_i32 s37, 0x118, s17
		s_add_i32 s24, s37, s24
		s_add_i32 s24, s24, s25
		s_add_i32 s24, s24, s42
		v_mov_b32_e32 v8, 0x3e38aa3b
		v_mov_b32_e32 v9, 0x3e38aa3b
		s_mov_b32 s25, 0xff800000
		v_mov_b32_e32 v2, s25
		v_mov_b32_e32 v11, s25
		s_mov_b32 s25, 1.0
		v_mov_b32_e32 v24, s25
		v_mov_b32_e32 v25, s25
		s_mov_b32 s25, 0
		v_lshrrev_b32_e32 v18, 4, v15
		v_lshlrev_b32_e32 v18, 9, v18
		v_and_b32_e32 v15, 15, v15
		v_mov_b32_e32 v20, 0x410
		v_mul_lo_u32 v20, v20, v15
		v_add3_u32 v13, v13, v18, v20
		v_accvgpr_write_b32 a62, v13
		v_and_b32_e32 v13, 3, v0
		v_accvgpr_read_b32 v15, a17
		v_mov_b32_e32 v18, 0x2200
		v_mul_lo_u32 v18, v18, v15
		v_lshl_add_u32 v13, v13, 3, v18
		v_lshl_add_u32 v3, v3, 5, v13
		v_mov_b32_e32 v13, 0x880
		v_mul_lo_u32 v13, v13, v1
		v_add3_u32 v1, v3, v13, v16
		v_accvgpr_write_b32 a63, v1
		s_cmp_lt_i32 0, s41
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
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_3
.L_attn_fwd_persistent.loop_head_3:
		s_waitcnt vmcnt(0)
		s_barrier
		s_lshr_b32 s37, s25, 7
		s_and_b32 s42, s37, 1
		s_mul_i32 s48, 0x4100, s42
		v_accvgpr_read_b32 v1, a62
		v_add_u32_e32 v1, s48, v1
		ds_read_b128 v[28:31], v1
		ds_read_b128 v[96:99], v1 offset:32
		ds_read_b128 v[100:103], v1 offset:64
		ds_read_b128 a[64:67], v1 offset:96
		ds_read_b128 v[104:107], v1 offset:256
		ds_read_b128 v[108:111], v1 offset:288
		ds_read_b128 v[112:115], v1 offset:320
		ds_read_b128 a[68:71], v1 offset:352
		ds_read_b128 v[116:119], v1 offset:128
		ds_read_b128 v[120:123], v1 offset:160
		ds_read_b128 v[124:127], v1 offset:192
		ds_read_b128 a[72:75], v1 offset:224
		ds_read_b128 v[128:131], v1 offset:384
		ds_read_b128 v[132:135], v1 offset:416
		ds_read_b128 a[76:79], v1 offset:448
		ds_read_b128 a[80:83], v1 offset:480
		s_mul_i32 s42, 0x4400, s42
		v_accvgpr_read_b32 v1, a63
		v_add_u32_e32 v1, s42, v1
		ds_read_b64_tr_b16 a[84:85], v1 offset:33264
		ds_read_b64_tr_b16 a[86:87], v1 offset:37616
		ds_read_b64_tr_b16 a[88:89], v1 offset:33392
		ds_read_b64_tr_b16 a[90:91], v1 offset:37744
		ds_read_b64_tr_b16 a[92:93], v1 offset:33520
		ds_read_b64_tr_b16 a[94:95], v1 offset:37872
		ds_read_b64_tr_b16 a[96:97], v1 offset:33648
		ds_read_b64_tr_b16 a[98:99], v1 offset:38000
		ds_read_b64_tr_b16 a[100:101], v1 offset:33776
		ds_read_b64_tr_b16 a[102:103], v1 offset:38128
		ds_read_b64_tr_b16 a[104:105], v1 offset:33904
		ds_read_b64_tr_b16 a[106:107], v1 offset:38256
		ds_read_b64_tr_b16 a[108:109], v1 offset:34032
		ds_read_b64_tr_b16 a[110:111], v1 offset:38384
		ds_read_b64_tr_b16 a[112:113], v1 offset:34160
		ds_read_b64_tr_b16 a[114:115], v1 offset:38512
		ds_read_b64_tr_b16 a[116:117], v1 offset:33328
		ds_read_b64_tr_b16 a[118:119], v1 offset:37680
		ds_read_b64_tr_b16 a[120:121], v1 offset:33456
		ds_read_b64_tr_b16 a[122:123], v1 offset:37808
		ds_read_b64_tr_b16 a[124:125], v1 offset:33584
		ds_read_b64_tr_b16 a[126:127], v1 offset:37936
		ds_read_b64_tr_b16 a[128:129], v1 offset:33712
		ds_read_b64_tr_b16 a[130:131], v1 offset:38064
		ds_read_b64_tr_b16 a[132:133], v1 offset:33840
		ds_read_b64_tr_b16 a[134:135], v1 offset:38192
		ds_read_b64_tr_b16 a[136:137], v1 offset:33968
		ds_read_b64_tr_b16 a[138:139], v1 offset:38320
		ds_read_b64_tr_b16 a[140:141], v1 offset:34096
		ds_read_b64_tr_b16 a[142:143], v1 offset:38448
		ds_read_b64_tr_b16 a[144:145], v1 offset:34224
		ds_read_b64_tr_b16 a[146:147], v1 offset:38576
		s_mul_i32 s42, s15, s25
		s_lshl_b32 s42, s42, 1
		s_add_i32 s48, s43, s42
		v_add3_u32 v1, s48, v12, v19
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[20:23], 0
		v_add3_u32 v1, v1, v21, v14
		v_mfma_f32_32x32x16_bf16 v[144:159], v[96:99], a[24:27], v[144:159]
		s_add_i32 s37, s37, 1
		v_mfma_f32_32x32x16_bf16 v[144:159], v[100:103], a[28:31], v[144:159]
		s_and_b32 s37, s37, 1
		v_mfma_f32_32x32x16_bf16 v[160:175], v[28:31], a[36:39], 0
		s_mul_i32 s48, 0x4100, s37
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], a[40:43], v[160:175]
		s_add_i32 s48, s40, s48
		v_mfma_f32_32x32x16_bf16 v[160:175], v[100:103], a[44:47], v[160:175]
		s_mov_b32 m0, s48
		v_mfma_f32_32x32x16_bf16 v[176:191], v[104:107], a[20:23], 0
		s_add_i32 s42, s44, s42
		v_mfma_f32_32x32x16_bf16 v[176:191], v[108:111], a[24:27], v[176:191]
		v_add3_u32 v3, s42, v12, v19
		v_mfma_f32_32x32x16_bf16 v[176:191], v[112:115], a[28:31], v[176:191]
		v_add3_u32 v3, v3, v21, v14
		v_mfma_f32_32x32x16_bf16 v[192:207], v[104:107], a[36:39], 0
		s_mul_i32 s42, s17, s25
		v_mfma_f32_32x32x16_bf16 v[192:207], v[108:111], a[40:43], v[192:207]
		s_add_i32 s25, s25, 0x80
		v_mfma_f32_32x32x16_bf16 v[192:207], v[112:115], a[44:47], v[192:207]
		v_accvgpr_read_b32 v13, a18
		v_add_u32_e32 v13, s25, v13
		v_mfma_f32_32x32x16_bf16 v[96:111], v[116:119], a[20:23], 0
		v_accvgpr_read_b32 v15, a54
		v_add_u32_e32 v15, s25, v15
		v_mfma_f32_32x32x16_bf16 v[96:111], v[120:123], a[24:27], v[96:111]
		v_accvgpr_read_b32 v16, a55
		v_add_u32_e32 v16, s25, v16
		v_mfma_f32_32x32x16_bf16 v[96:111], v[124:127], a[28:31], v[96:111]
		v_accvgpr_read_b32 v18, a56
		v_add_u32_e32 v18, s25, v18
		v_mfma_f32_32x32x16_bf16 v[208:223], v[116:119], a[36:39], 0
		v_cmp_lt_i32_e64 s[48:49], v13, s20
		v_mfma_f32_32x32x16_bf16 v[208:223], v[120:123], a[40:43], v[208:223]
		v_accvgpr_read_b32 v13, a19
		v_add_u32_e32 v13, s25, v13
		v_mfma_f32_32x32x16_bf16 v[208:223], v[124:127], a[44:47], v[208:223]
		v_accvgpr_read_b32 v20, a57
		v_add_u32_e32 v20, s25, v20
		v_mfma_f32_32x32x16_bf16 v[112:127], v[128:131], a[20:23], 0
		v_accvgpr_read_b32 v23, a58
		v_add_u32_e32 v23, s25, v23
		v_mfma_f32_32x32x16_bf16 v[112:127], v[132:135], a[24:27], v[112:127]
		v_accvgpr_read_b32 v26, a59
		v_add_u32_e32 v26, s25, v26
		v_mfma_f32_32x32x16_bf16 v[112:127], a[76:79], a[28:31], v[112:127]
		v_cmp_lt_i32_e64 vcc, v26, s20
		v_mfma_f32_32x32x16_bf16 v[224:239], v[128:131], a[36:39], 0
		v_cndmask_b32_e64 v1, v22, v1, s[48:49]
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[48:49], v15, s20
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[50:51], v16, s20
		v_mfma_f32_32x32x16_bf16 v[224:239], v[132:135], a[40:43], v[224:239]
		v_cndmask_b32_e64 v1, v22, v3, s[48:49]
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], a[76:79], a[44:47], v[224:239]
		v_cndmask_b32_e64 v1, v22, v4, s[50:51]
		v_cmp_lt_i32_e64 s[48:49], v18, s20
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[50:51], v13, s20
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[144:159], a[64:67], a[32:35], v[144:159]
		v_cndmask_b32_e64 v1, v22, v5, s[48:49]
		v_cmp_lt_i32_e64 s[48:49], v20, s20
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s42, s42, 1
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[52:53], v23, s20
		s_add_i32 s54, s39, s42
		v_mfma_f32_32x32x16_bf16 v[160:175], a[64:67], a[48:51], v[160:175]
		v_add3_u32 v1, s54, v6, v7
		v_add3_u32 v1, v1, v17, v14
		v_cndmask_b32_e64 v1, v22, v1, s[50:51]
		v_add_u32_e32 v4, s23, v4
		s_mul_i32 s37, 0x4400, s37
		v_max3_f32 v3, v144, v145, v146
		s_add_i32 s37, s38, s37
		v_max3_f32 v13, v148, v149, v150
		s_add_i32 m0, s37, 0x81f0
		s_add_i32 s37, s46, s42
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_add3_u32 v1, s37, v6, v7
		v_add3_u32 v1, v1, v17, v14
		v_cndmask_b32_e64 v1, v22, v1, s[48:49]
		v_max3_f32 v15, v152, v153, v154
		s_add_i32 m0, m0, 0x1100
		s_add_i32 s37, s47, s42
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_add3_u32 v1, s37, v6, v7
		v_add3_u32 v1, v1, v17, v14
		v_max3_f32 v16, v156, v157, v158
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v1, v22, v1, s[52:53]
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_max3_f32 v1, v3, v147, v13
		s_add_i32 s37, s24, s42
		v_add3_u32 v3, s37, v6, v7
		v_add3_u32 v3, v3, v17, v14
		v_cndmask_b32_e32 v3, v22, v3, vcc
		v_max3_f32 v13, v15, v155, v16
		s_add_i32 m0, m0, 0x1100
		v_max3_f32 v1, v1, v151, v13
		v_max3_f32 v13, v160, v161, v162
		v_max3_f32 v15, v164, v165, v166
		v_max3_f32 v16, v168, v169, v170
		v_max3_f32 v18, v172, v173, v174
		v_max3_f32 v13, v13, v163, v15
		v_max3_f32 v15, v16, v171, v18
		v_max3_f32 v13, v13, v167, v15
		v_add_u32_e32 v5, s23, v5
		s_cmp_lt_i32 s25, s41
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[176:191], a[68:71], a[32:35], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[72:75], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[80:83], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[80:83], a[48:51], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[68:71], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[72:75], a[48:51], v[208:223]
		s_nop 6
		v_max3_f32 v3, v176, v177, v178
		v_max3_f32 v15, v180, v181, v182
		v_max3_f32 v16, v184, v185, v186
		v_max3_f32 v18, v188, v189, v190
		v_max3_f32 v20, v96, v97, v98
		v_max3_f32 v23, v100, v101, v102
		v_max3_f32 v26, v104, v105, v106
		v_max3_f32 v27, v108, v109, v110
		v_max3_f32 v28, v112, v113, v114
		v_max3_f32 v29, v116, v117, v118
		v_max3_f32 v30, v120, v121, v122
		v_max3_f32 v31, v124, v125, v126
		v_max3_f32 v3, v3, v179, v15
		v_max3_f32 v15, v16, v187, v18
		v_max3_f32 v16, v20, v99, v23
		v_max3_f32 v18, v26, v107, v27
		v_max3_f32 v20, v28, v115, v29
		v_max3_f32 v23, v30, v123, v31
		v_max3_f32 v3, v3, v183, v15
		v_max3_f32 v15, v16, v103, v18
		v_max3_f32 v16, v20, v119, v23
		v_max3_f32 v1, v1, v159, v3
		v_max3_f32 v3, v15, v111, v16
		v_max3_f32 v1, v1, v191, v3
		v_max_f32_e32 v26, v1, v127
		v_mov_b32_e32 v27, v26
		v_max3_f32 v1, v192, v193, v194
		v_max3_f32 v3, v196, v197, v198
		v_max3_f32 v15, v200, v201, v202
		v_max3_f32 v16, v204, v205, v206
		v_max3_f32 v18, v208, v209, v210
		v_max3_f32 v20, v212, v213, v214
		v_max3_f32 v23, v216, v217, v218
		v_max3_f32 v28, v220, v221, v222
		v_max3_f32 v29, v224, v225, v226
		v_max3_f32 v30, v228, v229, v230
		v_max3_f32 v31, v232, v233, v234
		v_max3_f32 v128, v236, v237, v238
		v_max3_f32 v1, v1, v195, v3
		v_max3_f32 v3, v15, v203, v16
		v_max3_f32 v15, v18, v211, v20
		v_max3_f32 v16, v23, v219, v28
		v_permlane32_swap_b32_e32 v26, v27
		v_max3_f32 v18, v29, v227, v30
		v_max3_f32 v20, v31, v235, v128
		v_max3_f32 v1, v1, v199, v3
		v_max3_f32 v3, v15, v215, v16
		v_max3_f32 v15, v18, v231, v20
		v_max3_f32 v1, v13, v175, v1
		v_max3_f32 v3, v3, v223, v15
		v_max3_f32 v1, v1, v207, v3
		v_max_f32_e32 v28, v1, v239
		v_mov_b32_e32 v29, v28
		v_max_f32_e32 v30, v26, v27
		v_mov_b32_e32 v26, v2
		v_permlane32_swap_b32_e32 v28, v29
		v_max_f32_e32 v31, v28, v29
		v_pk_mul_f32 v[28:29], v[30:31], v[8:9]
		v_max_f32_e32 v30, v2, v28
		v_max_f32_e32 v31, v11, v29
		v_pk_fma_f32 v[2:3], v[144:145], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[146:147], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[148:149], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[150:151], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[152:153], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[154:155], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[156:157], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[158:159], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[176:177], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[178:179], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[180:181], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[182:183], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[184:185], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[186:187], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[188:189], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[190:191], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[96:97], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[98:99], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[108:109], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[110:111], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[112:113], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[114:115], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[116:117], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[118:119], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[120:121], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[122:123], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[124:125], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[126:127], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[160:161], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[162:163], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[164:165], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[166:167], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[168:169], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[170:171], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[172:173], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[174:175], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[192:193], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[194:195], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[196:197], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[198:199], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[200:201], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[202:203], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[204:205], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[206:207], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[208:209], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[210:211], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[212:213], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[214:215], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[216:217], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[218:219], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[220:221], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[222:223], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[224:225], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[226:227], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[228:229], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[230:231], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[232:233], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[234:235], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[236:237], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[218:219], v[238:239], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v220, v2
		v_exp_f32_e32 v222, v3
		v_exp_f32_e32 v2, v28
		v_exp_f32_e32 v224, v29
		v_exp_f32_e32 v28, v128
		v_exp_f32_e32 v226, v129
		v_exp_f32_e32 v128, v130
		v_exp_f32_e32 v228, v131
		v_exp_f32_e32 v130, v132
		v_exp_f32_e32 v230, v133
		v_exp_f32_e32 v132, v134
		v_exp_f32_e32 v232, v135
		v_exp_f32_e32 v134, v136
		v_exp_f32_e32 v234, v137
		v_exp_f32_e32 v136, v138
		v_exp_f32_e32 v236, v139
		v_exp_f32_e32 v138, v140
		v_exp_f32_e32 v238, v141
		v_exp_f32_e32 v140, v142
		v_exp_f32_e32 v240, v143
		v_exp_f32_e32 v142, v144
		v_exp_f32_e32 v242, v145
		v_exp_f32_e32 v144, v146
		v_exp_f32_e32 v244, v147
		v_exp_f32_e32 v146, v148
		v_exp_f32_e32 v246, v149
		v_exp_f32_e32 v148, v150
		v_exp_f32_e32 v248, v151
		v_exp_f32_e32 v150, v152
		v_exp_f32_e32 v250, v153
		v_exp_f32_e32 v152, v154
		v_exp_f32_e32 v252, v155
		v_exp_f32_e32 v221, v156
		v_exp_f32_e32 v223, v157
		v_exp_f32_e32 v3, v96
		v_exp_f32_e32 v225, v97
		v_exp_f32_e32 v29, v98
		v_exp_f32_e32 v227, v99
		v_exp_f32_e32 v129, v100
		v_exp_f32_e32 v229, v101
		v_exp_f32_e32 v131, v102
		v_exp_f32_e32 v231, v103
		v_exp_f32_e32 v133, v104
		v_exp_f32_e32 v233, v105
		v_exp_f32_e32 v135, v106
		v_exp_f32_e32 v235, v107
		v_exp_f32_e32 v137, v108
		v_exp_f32_e32 v237, v109
		v_exp_f32_e32 v139, v110
		v_exp_f32_e32 v239, v111
		v_exp_f32_e32 v141, v112
		v_exp_f32_e32 v241, v113
		v_exp_f32_e32 v143, v114
		v_exp_f32_e32 v243, v115
		v_exp_f32_e32 v145, v116
		v_exp_f32_e32 v245, v117
		v_exp_f32_e32 v147, v118
		v_exp_f32_e32 v247, v119
		v_exp_f32_e32 v149, v120
		v_exp_f32_e32 v249, v121
		v_exp_f32_e32 v151, v122
		v_exp_f32_e32 v251, v123
		v_exp_f32_e32 v153, v124
		v_exp_f32_e32 v253, v125
		v_exp_f32_e32 v96, v158
		v_exp_f32_e32 v98, v159
		v_exp_f32_e32 v100, v160
		v_exp_f32_e32 v102, v161
		v_exp_f32_e32 v104, v162
		v_exp_f32_e32 v106, v163
		v_exp_f32_e32 v108, v164
		v_exp_f32_e32 v110, v165
		v_exp_f32_e32 v112, v166
		v_exp_f32_e32 v114, v167
		v_exp_f32_e32 v116, v168
		v_exp_f32_e32 v118, v169
		v_exp_f32_e32 v120, v170
		v_exp_f32_e32 v122, v171
		v_exp_f32_e32 v124, v172
		v_exp_f32_e32 v154, v173
		v_exp_f32_e32 v156, v174
		v_exp_f32_e32 v158, v175
		v_exp_f32_e32 v160, v176
		v_exp_f32_e32 v162, v177
		v_exp_f32_e32 v164, v178
		v_exp_f32_e32 v166, v179
		v_exp_f32_e32 v168, v180
		v_exp_f32_e32 v170, v181
		v_exp_f32_e32 v172, v182
		v_exp_f32_e32 v174, v183
		v_exp_f32_e32 v176, v184
		v_exp_f32_e32 v178, v185
		v_exp_f32_e32 v180, v186
		v_exp_f32_e32 v182, v187
		v_exp_f32_e32 v185, v188
		v_exp_f32_e32 v187, v189
		v_exp_f32_e32 v97, v190
		v_exp_f32_e32 v99, v191
		v_exp_f32_e32 v101, v192
		v_exp_f32_e32 v103, v193
		v_exp_f32_e32 v105, v194
		v_exp_f32_e32 v107, v195
		v_exp_f32_e32 v109, v196
		v_exp_f32_e32 v111, v197
		v_exp_f32_e32 v113, v198
		v_exp_f32_e32 v115, v199
		v_exp_f32_e32 v117, v200
		v_exp_f32_e32 v119, v201
		v_exp_f32_e32 v121, v202
		v_exp_f32_e32 v123, v203
		v_exp_f32_e32 v125, v204
		v_exp_f32_e32 v155, v205
		v_exp_f32_e32 v157, v206
		v_exp_f32_e32 v159, v207
		v_exp_f32_e32 v161, v208
		v_exp_f32_e32 v163, v209
		v_exp_f32_e32 v165, v210
		v_exp_f32_e32 v167, v211
		v_exp_f32_e32 v169, v212
		v_exp_f32_e32 v171, v213
		v_exp_f32_e32 v173, v214
		v_exp_f32_e32 v175, v215
		v_exp_f32_e32 v177, v216
		v_exp_f32_e32 v179, v217
		v_exp_f32_e32 v181, v218
		v_exp_f32_e32 v183, v219
		v_pk_add_f32 v[188:189], v[220:221], v[222:223]
		v_pk_add_f32 v[190:191], v[2:3], v[224:225]
		v_pk_add_f32 v[192:193], v[28:29], v[226:227]
		v_pk_add_f32 v[194:195], v[128:129], v[228:229]
		v_pk_add_f32 v[196:197], v[130:131], v[230:231]
		v_pk_add_f32 v[198:199], v[132:133], v[232:233]
		v_pk_add_f32 v[200:201], v[134:135], v[234:235]
		v_pk_add_f32 v[202:203], v[136:137], v[236:237]
		v_pk_add_f32 v[204:205], v[138:139], v[238:239]
		v_pk_add_f32 v[206:207], v[140:141], v[240:241]
		v_pk_add_f32 v[208:209], v[142:143], v[242:243]
		v_pk_add_f32 v[210:211], v[144:145], v[244:245]
		v_pk_add_f32 v[212:213], v[146:147], v[246:247]
		v_pk_add_f32 v[214:215], v[148:149], v[248:249]
		v_pk_add_f32 v[216:217], v[150:151], v[250:251]
		v_pk_add_f32 v[218:219], v[152:153], v[252:253]
		v_pk_add_f32 v[188:189], v[188:189], v[190:191]
		v_pk_add_f32 v[190:191], v[192:193], v[194:195]
		v_pk_add_f32 v[192:193], v[196:197], v[198:199]
		v_pk_add_f32 v[194:195], v[200:201], v[202:203]
		v_pk_add_f32 v[196:197], v[204:205], v[206:207]
		v_pk_add_f32 v[198:199], v[208:209], v[210:211]
		v_pk_add_f32 v[200:201], v[212:213], v[214:215]
		v_pk_add_f32 v[202:203], v[216:217], v[218:219]
		v_pk_add_f32 v[188:189], v[188:189], v[190:191]
		v_pk_add_f32 v[190:191], v[192:193], v[194:195]
		v_pk_add_f32 v[192:193], v[196:197], v[198:199]
		v_pk_add_f32 v[194:195], v[200:201], v[202:203]
		v_pk_add_f32 v[188:189], v[188:189], v[190:191]
		v_pk_add_f32 v[190:191], v[192:193], v[194:195]
		v_pk_add_f32 v[192:193], v[188:189], v[190:191]
		v_add_f32_e32 v188, v192, v193
		v_mov_b32_e32 v189, v188
		v_exp_f32_e32 v184, v126
		v_exp_f32_e32 v186, v127
		v_permlane32_swap_b32_e32 v188, v189
		v_pk_add_f32 v[126:127], v[184:185], v[186:187]
		v_pk_add_f32 v[190:191], v[96:97], v[98:99]
		v_pk_add_f32 v[192:193], v[100:101], v[102:103]
		v_pk_add_f32 v[194:195], v[104:105], v[106:107]
		v_pk_add_f32 v[196:197], v[108:109], v[110:111]
		v_pk_add_f32 v[198:199], v[112:113], v[114:115]
		v_pk_add_f32 v[200:201], v[116:117], v[118:119]
		v_pk_add_f32 v[202:203], v[120:121], v[122:123]
		v_pk_add_f32 v[204:205], v[124:125], v[154:155]
		v_pk_add_f32 v[206:207], v[156:157], v[158:159]
		v_pk_add_f32 v[208:209], v[160:161], v[162:163]
		v_pk_add_f32 v[210:211], v[164:165], v[166:167]
		v_pk_add_f32 v[212:213], v[168:169], v[170:171]
		v_pk_add_f32 v[214:215], v[172:173], v[174:175]
		v_pk_add_f32 v[216:217], v[176:177], v[178:179]
		v_pk_add_f32 v[218:219], v[180:181], v[182:183]
		v_pk_add_f32 v[126:127], v[126:127], v[190:191]
		v_pk_add_f32 v[190:191], v[192:193], v[194:195]
		v_pk_add_f32 v[192:193], v[196:197], v[198:199]
		v_pk_add_f32 v[194:195], v[200:201], v[202:203]
		v_pk_add_f32 v[196:197], v[204:205], v[206:207]
		v_pk_add_f32 v[198:199], v[208:209], v[210:211]
		v_pk_add_f32 v[200:201], v[212:213], v[214:215]
		v_pk_add_f32 v[202:203], v[216:217], v[218:219]
		v_pk_add_f32 v[126:127], v[126:127], v[190:191]
		v_pk_add_f32 v[190:191], v[192:193], v[194:195]
		v_pk_add_f32 v[192:193], v[196:197], v[198:199]
		v_pk_add_f32 v[194:195], v[200:201], v[202:203]
		v_pk_add_f32 v[126:127], v[126:127], v[190:191]
		v_pk_add_f32 v[190:191], v[192:193], v[194:195]
		v_pk_add_f32 v[192:193], v[126:127], v[190:191]
		v_mov_b32_e32 v126, v189
		v_mov_b32_e32 v127, v193
		v_mov_b32_e32 v190, v188
		v_mov_b32_e32 v191, v192
		v_pk_add_f32 v[188:189], v[190:191], v[126:127]
		v_mov_b32_e32 v126, v189
		v_mov_b32_e32 v127, v189
		v_cvt_pk_bf16_f32 v192, v220, v222
		v_cvt_pk_bf16_f32 v193, v2, v224
		v_permlane32_swap_b32_e32 v126, v127
		v_add_f32_e32 v191, v126, v127
		v_mov_b32_e32 v27, v11
		v_pk_add_f32 v[126:127], v[26:27], v[30:31] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v26, v126
		v_exp_f32_e32 v27, v127
		v_cvt_pk_bf16_f32 v194, v28, v226
		v_mov_b32_e32 v190, v188
		v_mov_b64_e32 v[126:127], v[24:25]
		v_pk_fma_f32 v[24:25], v[126:127], v[26:27], v[190:191]
		v_cvt_pk_bf16_f32 v195, v128, v228
		v_cvt_pk_bf16_f32 v188, v130, v230
		v_cvt_pk_bf16_f32 v189, v132, v232
		v_cvt_pk_bf16_f32 v190, v134, v234
		v_cvt_pk_bf16_f32 v191, v136, v236
		v_cvt_pk_bf16_f32 v196, v138, v238
		v_cvt_pk_bf16_f32 v197, v140, v240
		v_cvt_pk_bf16_f32 v198, v142, v242
		v_cvt_pk_bf16_f32 v199, v144, v244
		v_cvt_pk_bf16_f32 v200, v146, v246
		v_cvt_pk_bf16_f32 v201, v148, v248
		v_cvt_pk_bf16_f32 v202, v150, v250
		v_cvt_pk_bf16_f32 v203, v152, v252
		v_cvt_pk_bf16_f32 v204, v221, v223
		v_pk_mul_f32 v[32:33], v[32:33], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[34:35], v[34:35], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[36:37], v[36:37], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[38:39], v[38:39], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[40:41], v[40:41], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[42:43], v[42:43], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[44:45], v[44:45], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[46:47], v[46:47], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[48:49], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[50:51], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[52:53], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[54:55], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[56:57], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[58:59], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[60:61], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[62:63], v[26:27] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[64:65], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[66:67], v[66:67], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[68:69], v[68:69], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[70:71], v[70:71], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[72:73], v[72:73], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[74:75], v[74:75], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[76:77], v[76:77], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[78:79], v[78:79], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[80:81], v[80:81], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[82:83], v[82:83], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[84:85], v[84:85], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[86:87], v[86:87], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[88:89], v[88:89], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[90:91], v[90:91], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[92:93], v[92:93], v[26:27] op_sel:[0,1]
		v_pk_mul_f32 v[94:95], v[94:95], v[26:27] op_sel:[0,1]
		v_cvt_pk_bf16_f32 v205, v3, v225
		v_cvt_pk_bf16_f32 v206, v29, v227
		v_cvt_pk_bf16_f32 v207, v129, v229
		v_cvt_pk_bf16_f32 v208, v131, v231
		v_cvt_pk_bf16_f32 v209, v133, v233
		v_cvt_pk_bf16_f32 v210, v135, v235
		v_cvt_pk_bf16_f32 v211, v137, v237
		v_cvt_pk_bf16_f32 v128, v139, v239
		v_cvt_pk_bf16_f32 v129, v141, v241
		v_cvt_pk_bf16_f32 v130, v143, v243
		v_cvt_pk_bf16_f32 v131, v145, v245
		v_cvt_pk_bf16_f32 v132, v147, v247
		v_cvt_pk_bf16_f32 v133, v149, v249
		v_cvt_pk_bf16_f32 v134, v151, v251
		v_cvt_pk_bf16_f32 v135, v153, v253
		v_cvt_pk_bf16_f32 v136, v184, v186
		v_cvt_pk_bf16_f32 v137, v96, v98
		v_cvt_pk_bf16_f32 v138, v100, v102
		v_cvt_pk_bf16_f32 v139, v104, v106
		v_cvt_pk_bf16_f32 v140, v108, v110
		v_cvt_pk_bf16_f32 v141, v112, v114
		v_cvt_pk_bf16_f32 v142, v116, v118
		v_cvt_pk_bf16_f32 v143, v120, v122
		v_cvt_pk_bf16_f32 v144, v124, v154
		v_cvt_pk_bf16_f32 v145, v156, v158
		v_cvt_pk_bf16_f32 v146, v160, v162
		v_cvt_pk_bf16_f32 v147, v164, v166
		v_cvt_pk_bf16_f32 v148, v168, v170
		v_cvt_pk_bf16_f32 v149, v172, v174
		v_cvt_pk_bf16_f32 v150, v176, v178
		v_cvt_pk_bf16_f32 v151, v180, v182
		v_cvt_pk_bf16_f32 v212, v185, v187
		v_cvt_pk_bf16_f32 v213, v97, v99
		v_cvt_pk_bf16_f32 v214, v101, v103
		v_cvt_pk_bf16_f32 v215, v105, v107
		v_cvt_pk_bf16_f32 v96, v109, v111
		v_cvt_pk_bf16_f32 v97, v113, v115
		v_cvt_pk_bf16_f32 v98, v117, v119
		v_cvt_pk_bf16_f32 v99, v121, v123
		v_cvt_pk_bf16_f32 v100, v125, v155
		v_cvt_pk_bf16_f32 v101, v157, v159
		v_cvt_pk_bf16_f32 v102, v161, v163
		v_cvt_pk_bf16_f32 v103, v165, v167
		v_cvt_pk_bf16_f32 v104, v169, v171
		v_cvt_pk_bf16_f32 v105, v173, v175
		v_cvt_pk_bf16_f32 v106, v177, v179
		v_cvt_pk_bf16_f32 v107, v181, v183
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[32:47], a[84:87], v[192:195], v[32:47]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[48:63], a[116:119], v[192:195], v[48:63]
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_mfma_f32_32x32x16_bf16 v[32:47], a[88:91], v[188:191], v[32:47]
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_mfma_f32_32x32x16_bf16 v[48:63], a[120:123], v[188:191], v[48:63]
		v_permlane32_swap_b32_e32 v208, v210
		v_permlane32_swap_b32_e32 v209, v211
		v_mfma_f32_32x32x16_bf16 v[32:47], a[92:95], v[196:199], v[32:47]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[48:63], a[124:127], v[196:199], v[48:63]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[32:47], a[96:99], v[200:203], v[32:47]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[48:63], a[128:131], v[200:203], v[48:63]
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_mfma_f32_32x32x16_bf16 v[80:95], a[116:119], v[136:139], v[80:95]
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_mfma_f32_32x32x16_bf16 v[64:79], a[84:87], v[136:139], v[64:79]
		v_permlane32_swap_b32_e32 v148, v150
		v_permlane32_swap_b32_e32 v149, v151
		v_mfma_f32_32x32x16_bf16 v[80:95], a[120:123], v[140:143], v[80:95]
		v_permlane32_swap_b32_e32 v212, v214
		v_permlane32_swap_b32_e32 v213, v215
		v_mfma_f32_32x32x16_bf16 v[64:79], a[88:91], v[140:143], v[64:79]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[80:95], a[124:127], v[144:147], v[80:95]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[64:79], a[92:95], v[144:147], v[64:79]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[80:95], a[128:131], v[148:151], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[96:99], v[148:151], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[100:103], v[204:207], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[132:135], v[204:207], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[132:135], v[212:215], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[100:103], v[212:215], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[104:107], v[208:211], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[136:139], v[208:211], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[136:139], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[104:107], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[108:111], v[128:131], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[140:143], v[128:131], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[140:143], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[108:111], v[100:103], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[112:115], v[132:135], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[144:147], v[132:135], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[104:107], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[112:115], v[104:107], v[64:79]
		v_mov_b32_e32 v2, v30
		v_mov_b32_e32 v11, v31
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_3
.L_attn_fwd_persistent.loop_exit_3:
		s_mul_i32 s21, s21, 0x80
		v_accvgpr_read_b32 v1, a6
		s_nop 0
		v_readfirstlane_b32 s23, v1
		v_accvgpr_read_b32 v1, a14
		s_nop 0
		v_add_u32_e32 v1, s23, v1
		v_add_u32_e32 v1, s1, v1
		v_accvgpr_read_b32 v3, a6
		s_nop 0
		v_readfirstlane_b32 s23, v3
		v_accvgpr_read_b32 v3, a15
		s_nop 0
		v_add_u32_e32 v3, s23, v3
		v_add_u32_e32 v3, s1, v3
		v_xor_b32_e32 v4, 1, v10
		v_accvgpr_write_b32 a14, v4
		v_xor_b32_e32 v4, 2, v10
		v_accvgpr_write_b32 a15, v4
		v_xor_b32_e32 v4, 3, v10
		v_accvgpr_write_b32 a64, v4
		v_xor_b32_e32 v4, 8, v10
		v_accvgpr_write_b32 a65, v4
		v_xor_b32_e32 v4, 9, v10
		v_accvgpr_write_b32 a66, v4
		v_xor_b32_e32 v4, 10, v10
		v_accvgpr_write_b32 a67, v4
		v_xor_b32_e32 v4, 11, v10
		v_accvgpr_write_b32 a68, v4
		v_xor_b32_e32 v4, 16, v10
		v_accvgpr_write_b32 a69, v4
		v_xor_b32_e32 v4, 17, v10
		v_accvgpr_write_b32 a70, v4
		v_xor_b32_e32 v4, 18, v10
		v_accvgpr_write_b32 a71, v4
		v_xor_b32_e32 v4, 19, v10
		v_accvgpr_write_b32 a72, v4
		v_xor_b32_e32 v4, 24, v10
		v_accvgpr_write_b32 a73, v4
		v_xor_b32_e32 v4, 25, v10
		v_accvgpr_write_b32 a74, v4
		v_xor_b32_e32 v4, 26, v10
		v_accvgpr_write_b32 a75, v4
		v_xor_b32_e32 v4, 27, v10
		v_accvgpr_write_b32 a76, v4
		v_xor_b32_e32 v4, 32, v10
		v_accvgpr_write_b32 a77, v4
		v_xor_b32_e32 v4, 33, v10
		v_accvgpr_write_b32 a78, v4
		v_xor_b32_e32 v4, 34, v10
		v_accvgpr_write_b32 a79, v4
		v_xor_b32_e32 v4, 35, v10
		v_accvgpr_write_b32 a80, v4
		v_xor_b32_e32 v4, 40, v10
		v_accvgpr_write_b32 a81, v4
		v_xor_b32_e32 v4, 41, v10
		v_accvgpr_write_b32 a82, v4
		v_xor_b32_e32 v4, 42, v10
		v_accvgpr_write_b32 a83, v4
		v_xor_b32_e32 v4, 43, v10
		v_accvgpr_write_b32 a84, v4
		v_xor_b32_e32 v4, 48, v10
		v_accvgpr_write_b32 a85, v4
		v_xor_b32_e32 v4, 49, v10
		v_accvgpr_write_b32 a86, v4
		v_xor_b32_e32 v4, 50, v10
		v_accvgpr_write_b32 a87, v4
		v_xor_b32_e32 v4, 51, v10
		v_accvgpr_write_b32 a88, v4
		v_xor_b32_e32 v4, 56, v10
		v_accvgpr_write_b32 a89, v4
		v_xor_b32_e32 v4, 57, v10
		v_accvgpr_write_b32 a90, v4
		v_xor_b32_e32 v4, 58, v10
		v_accvgpr_write_b32 a91, v4
		v_xor_b32_e32 v4, 59, v10
		v_accvgpr_write_b32 a92, v4
		v_xor_b32_e32 v4, 64, v10
		v_accvgpr_write_b32 a93, v4
		v_xor_b32_e32 v4, 0x41, v10
		v_accvgpr_write_b32 a94, v4
		v_xor_b32_e32 v4, 0x42, v10
		v_accvgpr_write_b32 a95, v4
		v_xor_b32_e32 v4, 0x43, v10
		v_accvgpr_write_b32 a96, v4
		v_xor_b32_e32 v4, 0x48, v10
		v_accvgpr_write_b32 a97, v4
		v_xor_b32_e32 v4, 0x49, v10
		v_accvgpr_write_b32 a98, v4
		v_xor_b32_e32 v4, 0x4a, v10
		v_accvgpr_write_b32 a99, v4
		v_xor_b32_e32 v4, 0x4b, v10
		v_accvgpr_write_b32 a100, v4
		v_xor_b32_e32 v4, 0x50, v10
		v_accvgpr_write_b32 a101, v4
		v_xor_b32_e32 v4, 0x51, v10
		v_accvgpr_write_b32 a102, v4
		v_xor_b32_e32 v4, 0x52, v10
		v_accvgpr_write_b32 a103, v4
		v_xor_b32_e32 v4, 0x53, v10
		v_accvgpr_write_b32 a104, v4
		v_xor_b32_e32 v4, 0x58, v10
		v_accvgpr_write_b32 a105, v4
		v_xor_b32_e32 v4, 0x59, v10
		v_accvgpr_write_b32 a106, v4
		v_xor_b32_e32 v4, 0x5a, v10
		v_accvgpr_write_b32 a107, v4
		v_xor_b32_e32 v4, 0x5b, v10
		v_accvgpr_write_b32 a108, v4
		v_xor_b32_e32 v4, 0x60, v10
		v_accvgpr_write_b32 a109, v4
		v_xor_b32_e32 v4, 0x61, v10
		v_accvgpr_write_b32 a110, v4
		v_xor_b32_e32 v4, 0x62, v10
		v_accvgpr_write_b32 a111, v4
		v_xor_b32_e32 v4, 0x63, v10
		v_accvgpr_write_b32 a112, v4
		v_xor_b32_e32 v4, 0x68, v10
		v_accvgpr_write_b32 a113, v4
		v_xor_b32_e32 v4, 0x69, v10
		v_accvgpr_write_b32 a114, v4
		v_xor_b32_e32 v4, 0x6a, v10
		v_accvgpr_write_b32 a115, v4
		v_xor_b32_e32 v4, 0x6b, v10
		v_accvgpr_write_b32 a116, v4
		v_xor_b32_e32 v4, 0x70, v10
		v_accvgpr_write_b32 a117, v4
		v_xor_b32_e32 v4, 0x71, v10
		v_accvgpr_write_b32 a118, v4
		v_xor_b32_e32 v4, 0x72, v10
		v_accvgpr_write_b32 a119, v4
		v_xor_b32_e32 v4, 0x73, v10
		v_accvgpr_write_b32 a120, v4
		v_xor_b32_e32 v4, 0x78, v10
		v_accvgpr_write_b32 a121, v4
		v_xor_b32_e32 v4, 0x79, v10
		v_accvgpr_write_b32 a122, v4
		v_xor_b32_e32 v4, 0x7a, v10
		v_accvgpr_write_b32 a123, v4
		v_xor_b32_e32 v4, 0x7b, v10
		v_accvgpr_write_b32 a124, v4
		v_mov_b32_e32 v4, 0xff800000
		s_cmp_lt_i32 s41, s21
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_4
.L_attn_fwd_persistent.loop_head_4:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s1, s41, 0x80
		s_cmp_lt_i32 s41, 0
		s_cselect_b32 s23, s22, 0
		s_add_i32 s23, s41, s23
		s_ashr_i32 s23, s23, 7
		s_cmp_lt_i32 s23, 0
		s_cselect_b32 s25, s16, 0
		s_add_i32 s25, s23, s25
		s_ashr_i32 s25, s25, 1
		s_lshl_b32 s25, s25, 1
		s_sub_i32 s25, s23, s25
		s_add_i32 s23, s23, 1
		s_cmp_lt_i32 s23, 0
		s_cselect_b32 s37, s16, 0
		s_add_i32 s37, s23, s37
		s_ashr_i32 s37, s37, 1
		s_lshl_b32 s37, s37, 1
		s_sub_i32 s48, s23, s37
		s_mul_i32 s23, 0x4100, s25
		v_accvgpr_read_b32 v5, a62
		v_add_u32_e32 v5, s23, v5
		ds_read_b128 v[28:31], v5
		ds_read_b128 a[128:131], v5 offset:32
		ds_read_b128 a[132:135], v5 offset:64
		ds_read_b128 a[136:139], v5 offset:96
		ds_read_b128 a[140:143], v5 offset:256
		ds_read_b128 a[144:147], v5 offset:288
		ds_read_b128 a[148:151], v5 offset:320
		ds_read_b128 a[152:155], v5 offset:352
		ds_read_b128 a[156:159], v5 offset:128
		ds_read_b128 a[160:163], v5 offset:160
		ds_read_b128 a[164:167], v5 offset:192
		ds_read_b128 a[168:171], v5 offset:224
		ds_read_b128 v[96:99], v5 offset:384
		ds_read_b128 a[172:175], v5 offset:416
		ds_read_b128 a[176:179], v5 offset:448
		ds_read_b128 a[180:183], v5 offset:480
		s_mul_i32 s23, 0x4400, s25
		v_accvgpr_read_b32 v5, a63
		v_add_u32_e32 v5, s23, v5
		ds_read_b64_tr_b16 a[184:185], v5 offset:33264
		ds_read_b64_tr_b16 a[186:187], v5 offset:37616
		ds_read_b64_tr_b16 a[188:189], v5 offset:33392
		ds_read_b64_tr_b16 a[190:191], v5 offset:37744
		ds_read_b64_tr_b16 a[192:193], v5 offset:33520
		ds_read_b64_tr_b16 a[194:195], v5 offset:37872
		ds_read_b64_tr_b16 a[196:197], v5 offset:33648
		ds_read_b64_tr_b16 a[198:199], v5 offset:38000
		ds_read_b64_tr_b16 a[200:201], v5 offset:33776
		ds_read_b64_tr_b16 a[202:203], v5 offset:38128
		ds_read_b64_tr_b16 a[204:205], v5 offset:33904
		ds_read_b64_tr_b16 a[206:207], v5 offset:38256
		ds_read_b64_tr_b16 a[208:209], v5 offset:34032
		ds_read_b64_tr_b16 a[210:211], v5 offset:38384
		ds_read_b64_tr_b16 a[212:213], v5 offset:34160
		ds_read_b64_tr_b16 a[214:215], v5 offset:38512
		ds_read_b64_tr_b16 a[216:217], v5 offset:33328
		ds_read_b64_tr_b16 a[218:219], v5 offset:37680
		ds_read_b64_tr_b16 a[220:221], v5 offset:33456
		ds_read_b64_tr_b16 a[222:223], v5 offset:37808
		ds_read_b64_tr_b16 a[224:225], v5 offset:33584
		ds_read_b64_tr_b16 a[226:227], v5 offset:37936
		ds_read_b64_tr_b16 a[228:229], v5 offset:33712
		ds_read_b64_tr_b16 a[230:231], v5 offset:38064
		ds_read_b64_tr_b16 a[232:233], v5 offset:33840
		ds_read_b64_tr_b16 a[234:235], v5 offset:38192
		ds_read_b64_tr_b16 a[236:237], v5 offset:33968
		ds_read_b64_tr_b16 a[238:239], v5 offset:38320
		ds_read_b64_tr_b16 a[240:241], v5 offset:34096
		ds_read_b64_tr_b16 a[242:243], v5 offset:38448
		ds_read_b64_tr_b16 a[244:245], v5 offset:34224
		ds_read_b64_tr_b16 a[246:247], v5 offset:38576
		s_cmp_lt_i32 s1, s18
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_4
		v_accvgpr_read_b32 v5, a18
		v_add_u32_e32 v5, s1, v5
		v_cmp_lt_i32_e64 s[50:51], v5, s20
		v_accvgpr_read_b32 v5, a19
		v_add_u32_e32 v5, s1, v5
		v_cmp_lt_i32_e64 s[52:53], v5, s20
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s23, s15, s41
		s_lshl_b32 s23, s23, 1
		s_add_i32 s25, s43, s23
		v_add3_u32 v5, s25, v12, v19
		v_add3_u32 v5, v5, v21, v14
		v_cndmask_b32_e64 v5, v22, v5, s[50:51]
		s_mov_b32 s50, 1
		s_mov_b32 s51, 0
		s_mov_b32 s37, s27
		s_mul_i32 s54, s50, s36
		s_mul_hi_u32 s55, s50, s36
		s_mul_i32 s25, s50, s37
		s_add_i32 s55, s55, s25
		s_mul_i32 s25, s51, s36
		s_add_i32 s55, s55, s25
		s_lshr_b64 s[50:51], s[54:55], 6
		s_mov_b32 s54, 0x410
		s_mov_b32 s55, 0
		s_mul_i32 s56, s54, s50
		s_mul_hi_u32 s57, s54, s50
		s_mul_i32 s25, s54, s51
		s_add_i32 s57, s57, s25
		s_mul_i32 s25, s55, s50
		s_add_i32 s57, s57, s25
		s_cmp_lt_i32 s48, 0
		s_cselect_b32 s49, -1, 0
		s_mov_b32 s54, 0x4100
		s_mov_b32 s55, 0
		s_mul_i32 s58, s54, s48
		s_mul_hi_u32 s59, s54, s48
		s_mul_i32 s25, s54, s49
		s_add_i32 s59, s59, s25
		s_mul_i32 s25, s55, s48
		s_add_i32 s59, s59, s25
		s_add_u32 s54, s56, s58
		s_addc_u32 s55, s57, s59
		s_add_u32 s56, s54, 0
		s_addc_u32 s57, s55, 0
		s_mov_b32 m0, s56
		v_accvgpr_read_b32 v13, a54
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[56:57], v13, s20
		s_add_i32 s25, s44, s23
		v_add3_u32 v5, s25, v12, v19
		v_add3_u32 v5, v5, v21, v14
		v_cndmask_b32_e64 v5, v22, v5, s[56:57]
		s_add_u32 s56, s54, 0x1040
		s_addc_u32 s57, s55, 0
		s_add_u32 s58, s56, 0
		s_addc_u32 s59, s57, 0
		s_mov_b32 m0, s58
		v_accvgpr_read_b32 v13, a55
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[56:57], v13, s20
		s_add_i32 s25, s45, s23
		v_add3_u32 v5, s25, v12, v19
		v_add3_u32 v5, v5, v21, v14
		v_cndmask_b32_e64 v5, v22, v5, s[56:57]
		s_add_u32 s56, s54, 0x2080
		s_addc_u32 s57, s55, 0
		s_add_u32 s58, s56, 0
		s_addc_u32 s59, s57, 0
		s_mov_b32 m0, s58
		v_accvgpr_read_b32 v13, a56
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[56:57], v13, s20
		s_add_i32 s23, s26, s23
		v_add3_u32 v5, s23, v12, v19
		v_add3_u32 v5, v5, v21, v14
		v_cndmask_b32_e64 v5, v22, v5, s[56:57]
		s_add_u32 s54, s54, 0x30c0
		s_addc_u32 s55, s55, 0
		s_add_u32 s56, s54, 0
		s_addc_u32 s57, s55, 0
		s_mov_b32 m0, s56
		v_accvgpr_read_b32 v13, a57
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		s_mul_i32 s23, s17, s41
		s_lshl_b32 s23, s23, 1
		s_add_i32 s25, s39, s23
		v_add3_u32 v5, s25, v6, v7
		v_add3_u32 v5, v5, v17, v14
		v_cndmask_b32_e64 v5, v22, v5, s[52:53]
		s_mov_b32 s52, 0x440
		s_mov_b32 s53, 0
		s_mul_i32 s54, s52, s50
		s_mul_hi_u32 s55, s52, s50
		s_mul_i32 s25, s52, s51
		s_add_i32 s55, s55, s25
		s_mul_i32 s25, s53, s50
		s_add_i32 s55, s55, s25
		s_mov_b32 s50, 0x4400
		s_mov_b32 s51, 0
		s_mul_i32 s52, s50, s48
		s_mul_hi_u32 s53, s50, s48
		s_mul_i32 s25, s50, s49
		s_add_i32 s53, s53, s25
		s_mul_i32 s25, s51, s48
		s_add_i32 s53, s53, s25
		s_add_u32 s48, s54, s52
		s_addc_u32 s49, s55, s53
		s_add_u32 s50, s48, 0x81f0
		s_addc_u32 s51, s49, 0
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		v_accvgpr_read_b32 v15, a58
		v_add_u32_e32 v15, s1, v15
		buffer_load_dwordx4 v5, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[50:51], v13, s20
		s_add_i32 s25, s46, s23
		v_add3_u32 v5, s25, v6, v7
		v_add3_u32 v5, v5, v17, v14
		v_cndmask_b32_e64 v5, v22, v5, s[50:51]
		s_add_u32 s50, s48, 0x92f0
		s_addc_u32 s51, s49, 0
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		v_accvgpr_read_b32 v13, a59
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v5, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[50:51], v15, s20
		s_add_i32 s25, s47, s23
		v_add3_u32 v5, s25, v6, v7
		v_add3_u32 v5, v5, v17, v14
		s_add_u32 s52, s48, 0xa3f0
		s_addc_u32 s53, s49, 0
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v5, v22, v5, s[50:51]
		buffer_load_dwordx4 v5, s[32:35], 0 offen lds
		s_add_i32 s23, s24, s23
		v_add3_u32 v5, s23, v6, v7
		v_cmp_lt_i32_e64 vcc, v13, s20
		v_add3_u32 v5, v5, v17, v14
		s_add_u32 s48, s48, 0xb4f0
		s_addc_u32 s49, s49, 0
		v_cndmask_b32_e32 v5, v22, v5, vcc
		s_add_u32 s50, s48, 0
		s_addc_u32 s51, s49, 0
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v5, s[32:35], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_4
.L_attn_fwd_persistent.if_else_4:
.L_attn_fwd_persistent.if_end_4:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[112:127], v[28:31], a[20:23], 0
		s_cmp_lt_i32 s1, s21
		v_mfma_f32_32x32x16_bf16 v[128:143], a[140:143], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[144:159], a[156:159], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[176:191], v[96:99], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[96:111], v[28:31], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[192:207], a[140:143], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[208:223], a[156:159], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[112:127], a[128:131], a[24:27], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[144:147], a[24:27], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[160:163], a[24:27], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[172:175], a[24:27], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[172:175], a[40:43], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[128:131], a[40:43], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[144:147], a[40:43], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[160:163], a[40:43], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[132:135], a[28:31], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[148:151], a[28:31], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[164:167], a[28:31], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[176:179], a[28:31], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[176:179], a[44:47], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[132:135], a[44:47], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[148:151], a[44:47], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[164:167], a[44:47], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[136:139], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[152:155], a[32:35], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[168:171], a[32:35], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[180:183], a[48:51], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[136:139], a[48:51], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[152:155], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[168:171], a[48:51], v[208:223]
		v_add_u32_e32 v5, s41, v10
		v_accvgpr_read_b32 v13, a14
		v_add_u32_e32 v13, s41, v13
		v_accvgpr_read_b32 v15, a15
		v_add_u32_e32 v15, s41, v15
		v_accvgpr_read_b32 v16, a64
		v_add_u32_e32 v16, s41, v16
		v_accvgpr_read_b32 v18, a67
		v_add_u32_e32 v18, s41, v18
		v_accvgpr_read_b32 v20, a68
		v_add_u32_e32 v20, s41, v20
		v_accvgpr_read_b32 v23, a71
		v_add_u32_e32 v23, s41, v23
		v_accvgpr_read_b32 v26, a72
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_read_b32 v27, a75
		v_add_u32_e32 v27, s41, v27
		v_accvgpr_read_b32 v28, a76
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_read_b32 v29, a79
		v_add_u32_e32 v29, s41, v29
		v_accvgpr_read_b32 v30, a80
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_read_b32 v31, a83
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a125, v31
		v_accvgpr_read_b32 v31, a84
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a126, v31
		v_accvgpr_read_b32 v31, a87
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a127, v31
		v_accvgpr_read_b32 v31, a88
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a128, v31
		v_accvgpr_read_b32 v31, a91
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a129, v31
		v_accvgpr_read_b32 v31, a92
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a130, v31
		v_accvgpr_read_b32 v31, a95
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a131, v31
		v_accvgpr_read_b32 v31, a96
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a132, v31
		v_accvgpr_read_b32 v31, a99
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a133, v31
		v_accvgpr_read_b32 v31, a100
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a134, v31
		v_accvgpr_read_b32 v31, a103
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a135, v31
		v_accvgpr_read_b32 v31, a104
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a136, v31
		v_accvgpr_read_b32 v31, a107
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a137, v31
		v_accvgpr_read_b32 v31, a108
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a138, v31
		v_accvgpr_read_b32 v31, a111
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a139, v31
		v_accvgpr_read_b32 v31, a112
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a140, v31
		v_accvgpr_read_b32 v31, a115
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a141, v31
		v_accvgpr_read_b32 v31, a116
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a142, v31
		v_accvgpr_read_b32 v31, a119
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a143, v31
		v_accvgpr_read_b32 v31, a120
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a144, v31
		v_accvgpr_read_b32 v31, a123
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a145, v31
		v_accvgpr_read_b32 v31, a124
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a146, v31
		v_cmp_ge_i32_e64 s[48:49], v1, v5
		v_cmp_ge_i32_e64 s[50:51], v1, v13
		v_cmp_ge_i32_e64 s[52:53], v1, v15
		v_cmp_ge_i32_e64 vcc, v1, v16
		v_accvgpr_read_b32 v31, a65
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_read_b32 v224, a66
		v_add_u32_e32 v224, s41, v224
		v_cndmask_b32_e32 v227, v4, v115, vcc
		v_cmp_ge_i32_e64 s[54:55], v1, v31
		v_cmp_ge_i32_e64 s[56:57], v1, v224
		v_cmp_ge_i32_e64 s[58:59], v1, v18
		v_cmp_ge_i32_e64 vcc, v1, v20
		v_accvgpr_read_b32 v115, a69
		v_add_u32_e32 v115, s41, v115
		v_accvgpr_read_b32 v225, a70
		v_add_u32_e32 v225, s41, v225
		v_cndmask_b32_e32 v229, v4, v119, vcc
		v_cmp_ge_i32_e64 s[60:61], v1, v115
		v_cmp_ge_i32_e64 s[62:63], v1, v225
		v_cmp_ge_i32_e64 s[64:65], v1, v23
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v119, a73
		v_add_u32_e32 v119, s41, v119
		v_accvgpr_read_b32 v226, a74
		v_add_u32_e32 v230, s41, v226
		v_cndmask_b32_e32 v233, v4, v123, vcc
		v_cmp_ge_i32_e64 s[66:67], v1, v119
		v_cmp_ge_i32_e64 s[68:69], v1, v230
		v_cmp_ge_i32_e64 s[70:71], v1, v27
		v_cmp_ge_i32_e64 vcc, v1, v28
		v_accvgpr_read_b32 v123, a77
		v_add_u32_e32 v123, s41, v123
		v_accvgpr_read_b32 v226, a78
		v_add_u32_e32 v231, s41, v226
		v_cndmask_b32_e32 v235, v4, v127, vcc
		v_cmp_ge_i32_e64 s[72:73], v1, v123
		v_cmp_ge_i32_e64 s[74:75], v1, v231
		v_cmp_ge_i32_e64 s[76:77], v1, v29
		v_cmp_ge_i32_e64 vcc, v1, v30
		v_accvgpr_read_b32 v127, a81
		v_add_u32_e32 v127, s41, v127
		v_accvgpr_read_b32 v226, a82
		v_add_u32_e32 v226, s41, v226
		v_accvgpr_write_b32 a147, v226
		v_cndmask_b32_e32 v237, v4, v131, vcc
		v_cmp_ge_i32_e64 s[78:79], v1, v127
		v_accvgpr_read_b32 v131, a147
		v_cmp_ge_i32_e64 s[80:81], v1, v131
		v_accvgpr_read_b32 v131, a125
		v_cmp_ge_i32_e64 s[82:83], v1, v131
		v_accvgpr_read_b32 v131, a126
		v_cmp_ge_i32_e64 vcc, v1, v131
		v_accvgpr_read_b32 v131, a85
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a148, v131
		v_accvgpr_read_b32 v131, a86
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a149, v131
		v_cndmask_b32_e32 v239, v4, v135, vcc
		v_accvgpr_read_b32 v131, a148
		v_cmp_ge_i32_e64 s[84:85], v1, v131
		v_accvgpr_read_b32 v131, a149
		v_cmp_ge_i32_e64 s[86:87], v1, v131
		v_accvgpr_read_b32 v131, a128
		v_cmp_ge_i32_e64 vcc, v1, v131
		v_accvgpr_read_b32 v131, a89
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a150, v131
		v_accvgpr_read_b32 v131, a90
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a151, v131
		v_cndmask_b32_e32 v241, v4, v139, vcc
		v_accvgpr_read_b32 v131, a130
		v_cmp_ge_i32_e64 vcc, v1, v131
		v_accvgpr_read_b32 v131, a93
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a152, v131
		v_accvgpr_read_b32 v131, a94
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a153, v131
		v_cndmask_b32_e32 v243, v4, v143, vcc
		v_accvgpr_read_b32 v131, a132
		v_cmp_ge_i32_e64 vcc, v1, v131
		v_accvgpr_read_b32 v131, a97
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a154, v131
		v_accvgpr_read_b32 v131, a98
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a155, v131
		v_cndmask_b32_e32 v245, v4, v147, vcc
		v_accvgpr_read_b32 v131, a134
		v_cmp_ge_i32_e64 vcc, v1, v131
		v_accvgpr_read_b32 v131, a101
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a156, v131
		v_accvgpr_read_b32 v131, a102
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a157, v131
		v_cndmask_b32_e32 v247, v4, v151, vcc
		v_accvgpr_read_b32 v131, a136
		v_cmp_ge_i32_e64 vcc, v1, v131
		v_accvgpr_read_b32 v131, a105
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a158, v131
		v_accvgpr_read_b32 v131, a106
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a159, v131
		v_cndmask_b32_e32 v249, v4, v155, vcc
		v_accvgpr_read_b32 v131, a138
		v_cmp_ge_i32_e64 vcc, v1, v131
		v_accvgpr_read_b32 v131, a127
		v_cmp_ge_i32_e64 s[88:89], v1, v131
		v_cndmask_b32_e64 v250, v4, v112, s[48:49]
		v_accvgpr_read_b32 v112, a150
		v_cmp_ge_i32_e64 s[48:49], v1, v112
		v_accvgpr_read_b32 v112, a151
		v_cmp_ge_i32_e64 s[90:91], v1, v112
		v_accvgpr_read_b32 v112, a129
		v_cmp_ge_i32_e64 s[92:93], v1, v112
		s_nop 1
		v_mov_b32_e32 v252, s92
		v_mov_b32_e32 v253, s93
		v_accvgpr_write_b32 a160, v252
		v_accvgpr_write_b32 a161, v253
		v_accvgpr_read_b32 v112, a152
		v_cmp_ge_i32_e64 s[92:93], v1, v112
		s_nop 1
		v_mov_b32_e32 v252, s92
		v_mov_b32_e32 v253, s93
		v_accvgpr_write_b32 a162, v252
		v_accvgpr_write_b32 a163, v253
		v_accvgpr_read_b32 v112, a153
		v_cmp_ge_i32_e64 s[92:93], v1, v112
		s_nop 1
		v_mov_b32_e32 v252, s92
		v_mov_b32_e32 v253, s93
		v_accvgpr_write_b32 a164, v252
		v_accvgpr_write_b32 a165, v253
		v_accvgpr_read_b32 v112, a131
		v_cmp_ge_i32_e64 s[92:93], v1, v112
		s_nop 1
		v_mov_b32_e32 v252, s92
		v_mov_b32_e32 v253, s93
		v_accvgpr_write_b32 a166, v252
		v_accvgpr_write_b32 a167, v253
		v_accvgpr_read_b32 v112, a154
		v_cmp_ge_i32_e64 s[92:93], v1, v112
		s_nop 1
		v_mov_b32_e32 v252, s92
		v_mov_b32_e32 v253, s93
		v_accvgpr_write_b32 a168, v252
		v_accvgpr_write_b32 a169, v253
		v_accvgpr_read_b32 v112, a155
		v_cmp_ge_i32_e64 s[92:93], v1, v112
		s_nop 1
		v_mov_b32_e32 v252, s92
		v_mov_b32_e32 v253, s93
		v_accvgpr_write_b32 a170, v252
		v_accvgpr_write_b32 a171, v253
		v_accvgpr_read_b32 v112, a133
		v_cmp_ge_i32_e64 s[92:93], v1, v112
		s_nop 1
		v_mov_b32_e32 v252, s92
		v_mov_b32_e32 v253, s93
		v_accvgpr_write_b32 a172, v252
		v_accvgpr_write_b32 a173, v253
		v_accvgpr_read_b32 v112, a156
		v_cmp_ge_i32_e64 s[92:93], v1, v112
		s_nop 1
		v_mov_b32_e32 v252, s92
		v_mov_b32_e32 v253, s93
		v_accvgpr_write_b32 a174, v252
		v_accvgpr_write_b32 a175, v253
		v_accvgpr_read_b32 v112, a157
		v_cmp_ge_i32_e64 s[92:93], v1, v112
		s_nop 1
		v_mov_b32_e32 v252, s92
		v_mov_b32_e32 v253, s93
		v_accvgpr_write_b32 a176, v252
		v_accvgpr_write_b32 a177, v253
		v_accvgpr_read_b32 v112, a135
		v_cmp_ge_i32_e64 s[92:93], v1, v112
		v_accvgpr_read_b32 v112, a158
		v_cmp_ge_i32_e64 s[94:95], v1, v112
		v_accvgpr_read_b32 v112, a159
		v_cmp_ge_i32_e64 s[96:97], v1, v112
		v_accvgpr_read_b32 v112, a137
		v_cmp_ge_i32_e64 s[98:99], v1, v112
		v_cndmask_b32_e32 v253, v4, v159, vcc
		v_cndmask_b32_e64 v255, v4, v157, s[96:97]
		v_cndmask_b32_e64 v252, v4, v158, s[98:99]
		v_accvgpr_read_b32 v112, a109
		v_add_u32_e32 v112, s41, v112
		v_accvgpr_write_b32 a178, v112
		v_accvgpr_read_b32 v112, a110
		v_add_u32_e32 v112, s41, v112
		v_accvgpr_write_b32 a179, v112
		v_accvgpr_read_b32 v112, a178
		v_cmp_ge_i32_e64 s[96:97], v1, v112
		v_accvgpr_read_b32 v112, a179
		v_cmp_ge_i32_e64 s[98:99], v1, v112
		v_accvgpr_read_b32 v112, a139
		v_cmp_ge_i32_e64 s[100:101], v1, v112
		v_cndmask_b32_e64 v158, v4, v160, s[96:97]
		v_cndmask_b32_e64 v159, v4, v161, s[98:99]
		v_cndmask_b32_e64 v160, v4, v162, s[100:101]
		v_accvgpr_read_b32 v112, a140
		v_cmp_ge_i32_e64 vcc, v1, v112
		v_accvgpr_read_b32 v112, a113
		v_add_u32_e32 v112, s41, v112
		v_accvgpr_write_b32 a180, v112
		v_accvgpr_read_b32 v112, a114
		v_add_u32_e32 v112, s41, v112
		v_accvgpr_write_b32 a181, v112
		v_cndmask_b32_e32 v161, v4, v163, vcc
		v_accvgpr_read_b32 v112, a180
		v_cmp_ge_i32_e64 s[96:97], v1, v112
		v_accvgpr_read_b32 v112, a181
		v_cmp_ge_i32_e64 s[98:99], v1, v112
		v_accvgpr_read_b32 v112, a141
		v_cmp_ge_i32_e64 s[100:101], v1, v112
		v_cndmask_b32_e64 v162, v4, v164, s[96:97]
		v_cndmask_b32_e64 v163, v4, v165, s[98:99]
		v_cndmask_b32_e64 v164, v4, v166, s[100:101]
		v_accvgpr_read_b32 v112, a142
		v_cmp_ge_i32_e64 vcc, v1, v112
		v_accvgpr_read_b32 v112, a117
		v_add_u32_e32 v112, s41, v112
		v_accvgpr_write_b32 a182, v112
		v_accvgpr_read_b32 v112, a118
		v_add_u32_e32 v112, s41, v112
		v_accvgpr_write_b32 a183, v112
		v_cndmask_b32_e32 v165, v4, v167, vcc
		v_accvgpr_read_b32 v112, a182
		v_cmp_ge_i32_e64 s[96:97], v1, v112
		v_accvgpr_read_b32 v112, a183
		v_cmp_ge_i32_e64 s[98:99], v1, v112
		v_accvgpr_read_b32 v112, a143
		v_cmp_ge_i32_e64 s[100:101], v1, v112
		v_cndmask_b32_e64 v166, v4, v168, s[96:97]
		v_cndmask_b32_e64 v167, v4, v169, s[98:99]
		v_cndmask_b32_e64 v168, v4, v170, s[100:101]
		v_accvgpr_read_b32 v112, a144
		v_cmp_ge_i32_e64 vcc, v1, v112
		v_accvgpr_read_b32 v112, a121
		v_add_u32_e32 v112, s41, v112
		v_accvgpr_write_b32 a248, v112
		v_accvgpr_read_b32 v112, a122
		v_add_u32_e32 v112, s41, v112
		v_accvgpr_write_b32 a249, v112
		v_cndmask_b32_e32 v169, v4, v171, vcc
		v_accvgpr_read_b32 v112, a248
		v_cmp_ge_i32_e64 s[96:97], v1, v112
		v_accvgpr_read_b32 v112, a249
		v_cmp_ge_i32_e64 s[98:99], v1, v112
		v_accvgpr_read_b32 v112, a145
		v_cmp_ge_i32_e64 s[100:101], v1, v112
		v_cndmask_b32_e64 v170, v4, v172, s[96:97]
		v_cndmask_b32_e64 v171, v4, v173, s[98:99]
		v_cndmask_b32_e64 v172, v4, v174, s[100:101]
		v_cndmask_b32_e64 v251, v4, v113, s[50:51]
		v_accvgpr_read_b32 v112, a146
		v_cmp_ge_i32_e64 vcc, v1, v112
		v_max3_f32 v112, v158, v159, v160
		v_accvgpr_write_b32 a250, v112
		v_max3_f32 v112, v162, v163, v164
		v_accvgpr_write_b32 a251, v112
		v_cndmask_b32_e32 v173, v4, v175, vcc
		v_cmp_ge_i32_e64 s[50:51], v3, v5
		v_cmp_ge_i32_e64 s[96:97], v3, v13
		v_cmp_ge_i32_e64 s[98:99], v3, v15
		v_max3_f32 v5, v166, v167, v168
		v_accvgpr_write_b32 a252, v5
		v_max3_f32 v5, v170, v171, v172
		v_accvgpr_write_b32 a253, v5
		v_cndmask_b32_e64 v112, v4, v98, s[98:99]
		v_cmp_ge_i32_e64 vcc, v3, v16
		v_cndmask_b32_e64 v226, v4, v114, s[52:53]
		v_cndmask_b32_e64 v174, v4, v116, s[54:55]
		v_cndmask_b32_e32 v113, v4, v99, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v31
		v_cmp_ge_i32_e64 s[54:55], v3, v224
		v_cmp_ge_i32_e64 s[98:99], v3, v18
		v_cndmask_b32_e64 v98, v4, v100, s[52:53]
		v_cndmask_b32_e64 v99, v4, v101, s[54:55]
		v_cndmask_b32_e64 v100, v4, v102, s[98:99]
		v_cmp_ge_i32_e64 vcc, v3, v20
		v_cndmask_b32_e64 v175, v4, v117, s[56:57]
		v_cndmask_b32_e64 v228, v4, v118, s[58:59]
		v_cndmask_b32_e64 v116, v4, v120, s[60:61]
		v_cndmask_b32_e32 v101, v4, v103, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v115
		v_cmp_ge_i32_e64 s[54:55], v3, v225
		v_cmp_ge_i32_e64 s[56:57], v3, v23
		v_cndmask_b32_e64 v102, v4, v104, s[52:53]
		v_cndmask_b32_e64 v103, v4, v105, s[54:55]
		v_cndmask_b32_e64 v104, v4, v106, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v26
		v_cndmask_b32_e64 v117, v4, v121, s[62:63]
		v_max3_f32 v5, v250, v251, v226
		v_cndmask_b32_e32 v105, v4, v107, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v119
		v_cmp_ge_i32_e64 s[54:55], v3, v230
		v_cmp_ge_i32_e64 s[56:57], v3, v27
		v_cndmask_b32_e64 v26, v4, v108, s[52:53]
		v_cndmask_b32_e64 v27, v4, v109, s[54:55]
		v_cndmask_b32_e64 v106, v4, v110, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v28
		v_cndmask_b32_e64 v232, v4, v122, s[64:65]
		v_cndmask_b32_e64 v108, v4, v124, s[66:67]
		v_cndmask_b32_e32 v107, v4, v111, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v123
		v_cmp_ge_i32_e64 s[54:55], v3, v231
		v_cmp_ge_i32_e64 s[56:57], v3, v29
		v_cndmask_b32_e64 v28, v4, v192, s[52:53]
		v_cndmask_b32_e64 v29, v4, v193, s[54:55]
		v_cndmask_b32_e64 v110, v4, v194, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v30
		v_cndmask_b32_e64 v109, v4, v125, s[68:69]
		v_cndmask_b32_e64 v234, v4, v126, s[70:71]
		v_cndmask_b32_e64 v30, v4, v128, s[72:73]
		v_cndmask_b32_e32 v111, v4, v195, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v127
		v_accvgpr_read_b32 v13, a147
		v_cmp_ge_i32_e64 s[54:55], v3, v13
		v_accvgpr_read_b32 v13, a125
		v_cmp_ge_i32_e64 s[56:57], v3, v13
		v_cndmask_b32_e64 v114, v4, v196, s[52:53]
		v_cndmask_b32_e64 v115, v4, v197, s[54:55]
		v_cndmask_b32_e64 v118, v4, v198, s[56:57]
		v_accvgpr_read_b32 v13, a126
		v_cmp_ge_i32_e64 vcc, v3, v13
		v_cndmask_b32_e64 v31, v4, v129, s[74:75]
		v_max3_f32 v13, v174, v175, v228
		v_cndmask_b32_e32 v119, v4, v199, vcc
		v_accvgpr_read_b32 v15, a148
		v_cmp_ge_i32_e64 s[52:53], v3, v15
		v_accvgpr_read_b32 v15, a149
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_accvgpr_read_b32 v15, a127
		v_cmp_ge_i32_e64 s[56:57], v3, v15
		v_cndmask_b32_e64 v120, v4, v200, s[52:53]
		v_cndmask_b32_e64 v121, v4, v201, s[54:55]
		v_cndmask_b32_e64 v122, v4, v202, s[56:57]
		v_accvgpr_read_b32 v15, a128
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_cndmask_b32_e64 v236, v4, v130, s[76:77]
		v_cndmask_b32_e64 v124, v4, v132, s[78:79]
		v_cndmask_b32_e32 v123, v4, v203, vcc
		v_accvgpr_read_b32 v15, a130
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_accvgpr_read_b32 v15, a150
		v_cmp_ge_i32_e64 s[52:53], v3, v15
		v_accvgpr_read_b32 v15, a151
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_accvgpr_read_b32 v15, a129
		v_cmp_ge_i32_e64 s[56:57], v3, v15
		v_cndmask_b32_e64 v126, v4, v204, s[52:53]
		v_cndmask_b32_e64 v127, v4, v205, s[54:55]
		v_cndmask_b32_e64 v128, v4, v206, s[56:57]
		v_cndmask_b32_e64 v125, v4, v133, s[80:81]
		v_cndmask_b32_e64 v238, v4, v134, s[82:83]
		v_cndmask_b32_e32 v129, v4, v207, vcc
		v_accvgpr_read_b32 v15, a152
		v_cmp_ge_i32_e64 s[52:53], v3, v15
		v_accvgpr_read_b32 v15, a153
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_accvgpr_read_b32 v15, a132
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_accvgpr_read_b32 v15, a131
		v_cmp_ge_i32_e64 s[56:57], v3, v15
		v_cndmask_b32_e64 v130, v4, v208, s[52:53]
		v_cndmask_b32_e64 v131, v4, v209, s[54:55]
		v_cndmask_b32_e64 v132, v4, v210, s[56:57]
		v_cndmask_b32_e64 v134, v4, v136, s[84:85]
		v_cndmask_b32_e64 v135, v4, v137, s[86:87]
		v_cndmask_b32_e32 v133, v4, v211, vcc
		v_accvgpr_read_b32 v15, a154
		v_cmp_ge_i32_e64 s[52:53], v3, v15
		v_accvgpr_read_b32 v15, a155
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_accvgpr_read_b32 v15, a133
		v_cmp_ge_i32_e64 s[56:57], v3, v15
		v_cndmask_b32_e64 v136, v4, v212, s[52:53]
		v_cndmask_b32_e64 v137, v4, v213, s[54:55]
		v_cndmask_b32_e64 v192, v4, v214, s[56:57]
		v_accvgpr_read_b32 v15, a134
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_cndmask_b32_e64 v240, v4, v138, s[88:89]
		v_cndmask_b32_e64 v138, v4, v140, s[48:49]
		v_cndmask_b32_e32 v193, v4, v215, vcc
		v_accvgpr_read_b32 v15, a156
		v_cmp_ge_i32_e64 s[48:49], v3, v15
		v_accvgpr_read_b32 v15, a157
		v_cmp_ge_i32_e64 s[52:53], v3, v15
		v_accvgpr_read_b32 v15, a135
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_cndmask_b32_e64 v194, v4, v216, s[48:49]
		v_cndmask_b32_e64 v195, v4, v217, s[52:53]
		v_cndmask_b32_e64 v196, v4, v218, s[54:55]
		v_accvgpr_read_b32 v15, a136
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_cndmask_b32_e64 v139, v4, v141, s[90:91]
		v_accvgpr_read_b32 v15, a160
		s_nop 0
		v_readfirstlane_b32 s48, v15
		v_accvgpr_read_b32 v15, a161
		s_nop 0
		v_readfirstlane_b32 s49, v15
		s_nop 1
		v_cndmask_b32_e64 v242, v4, v142, s[48:49]
		v_cndmask_b32_e32 v197, v4, v219, vcc
		v_accvgpr_read_b32 v15, a158
		v_cmp_ge_i32_e64 s[48:49], v3, v15
		v_accvgpr_read_b32 v15, a159
		v_cmp_ge_i32_e64 s[52:53], v3, v15
		v_accvgpr_read_b32 v15, a137
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_cndmask_b32_e64 v140, v4, v220, s[48:49]
		v_cndmask_b32_e64 v141, v4, v221, s[52:53]
		v_cndmask_b32_e64 v142, v4, v222, s[54:55]
		v_accvgpr_read_b32 v15, a138
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_accvgpr_read_b32 v15, a162
		s_nop 0
		v_readfirstlane_b32 s48, v15
		v_accvgpr_read_b32 v15, a163
		s_nop 0
		v_readfirstlane_b32 s49, v15
		s_nop 1
		v_cndmask_b32_e64 v198, v4, v144, s[48:49]
		v_accvgpr_read_b32 v15, a164
		s_nop 0
		v_readfirstlane_b32 s48, v15
		v_accvgpr_read_b32 v15, a165
		s_nop 0
		v_readfirstlane_b32 s49, v15
		s_nop 1
		v_cndmask_b32_e64 v199, v4, v145, s[48:49]
		v_cndmask_b32_e32 v143, v4, v223, vcc
		v_accvgpr_read_b32 v15, a178
		v_cmp_ge_i32_e64 s[48:49], v3, v15
		v_accvgpr_read_b32 v15, a179
		v_cmp_ge_i32_e64 s[52:53], v3, v15
		v_accvgpr_read_b32 v15, a139
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_cndmask_b32_e64 v144, v4, v176, s[48:49]
		v_cndmask_b32_e64 v145, v4, v177, s[52:53]
		v_cndmask_b32_e64 v176, v4, v178, s[54:55]
		v_accvgpr_read_b32 v15, a140
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_accvgpr_read_b32 v15, a166
		s_nop 0
		v_readfirstlane_b32 s48, v15
		v_accvgpr_read_b32 v15, a167
		s_nop 0
		v_readfirstlane_b32 s49, v15
		s_nop 1
		v_cndmask_b32_e64 v244, v4, v146, s[48:49]
		v_accvgpr_read_b32 v15, a168
		s_nop 0
		v_readfirstlane_b32 s48, v15
		v_accvgpr_read_b32 v15, a169
		s_nop 0
		v_readfirstlane_b32 s49, v15
		s_nop 1
		v_cndmask_b32_e64 v146, v4, v148, s[48:49]
		v_cndmask_b32_e32 v177, v4, v179, vcc
		v_accvgpr_read_b32 v15, a180
		v_cmp_ge_i32_e64 s[48:49], v3, v15
		v_accvgpr_read_b32 v15, a181
		v_cmp_ge_i32_e64 s[52:53], v3, v15
		v_accvgpr_read_b32 v15, a141
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_cndmask_b32_e64 v178, v4, v180, s[48:49]
		v_cndmask_b32_e64 v179, v4, v181, s[52:53]
		v_cndmask_b32_e64 v180, v4, v182, s[54:55]
		v_accvgpr_read_b32 v15, a142
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_accvgpr_read_b32 v15, a170
		s_nop 0
		v_readfirstlane_b32 s48, v15
		v_accvgpr_read_b32 v15, a171
		s_nop 0
		v_readfirstlane_b32 s49, v15
		s_nop 1
		v_cndmask_b32_e64 v147, v4, v149, s[48:49]
		v_accvgpr_read_b32 v15, a172
		s_nop 0
		v_readfirstlane_b32 s48, v15
		v_accvgpr_read_b32 v15, a173
		s_nop 0
		v_readfirstlane_b32 s49, v15
		s_nop 1
		v_cndmask_b32_e64 v246, v4, v150, s[48:49]
		v_cndmask_b32_e32 v181, v4, v183, vcc
		v_accvgpr_read_b32 v15, a182
		v_cmp_ge_i32_e64 s[48:49], v3, v15
		v_accvgpr_read_b32 v15, a183
		v_cmp_ge_i32_e64 s[52:53], v3, v15
		v_accvgpr_read_b32 v15, a143
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_cndmask_b32_e64 v148, v4, v184, s[48:49]
		v_cndmask_b32_e64 v149, v4, v185, s[52:53]
		v_cndmask_b32_e64 v150, v4, v186, s[54:55]
		v_accvgpr_read_b32 v15, a144
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_accvgpr_read_b32 v15, a174
		s_nop 0
		v_readfirstlane_b32 s48, v15
		v_accvgpr_read_b32 v15, a175
		s_nop 0
		v_readfirstlane_b32 s49, v15
		s_nop 1
		v_cndmask_b32_e64 v182, v4, v152, s[48:49]
		v_accvgpr_read_b32 v15, a176
		s_nop 0
		v_readfirstlane_b32 s48, v15
		v_accvgpr_read_b32 v15, a177
		s_nop 0
		v_readfirstlane_b32 s49, v15
		s_nop 1
		v_cndmask_b32_e64 v183, v4, v153, s[48:49]
		v_cndmask_b32_e32 v151, v4, v187, vcc
		v_accvgpr_read_b32 v15, a248
		v_cmp_ge_i32_e64 s[48:49], v3, v15
		v_accvgpr_read_b32 v15, a249
		v_cmp_ge_i32_e64 s[52:53], v3, v15
		v_accvgpr_read_b32 v15, a145
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_cndmask_b32_e64 v152, v4, v188, s[48:49]
		v_cndmask_b32_e64 v153, v4, v189, s[52:53]
		v_cndmask_b32_e64 v184, v4, v190, s[54:55]
		v_accvgpr_read_b32 v15, a146
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_cndmask_b32_e64 v248, v4, v154, s[92:93]
		v_cndmask_b32_e64 v254, v4, v156, s[94:95]
		v_cndmask_b32_e32 v185, v4, v191, vcc
		v_max3_f32 v15, v116, v117, v232
		v_max3_f32 v16, v108, v109, v234
		v_max3_f32 v18, v30, v31, v236
		v_max3_f32 v20, v124, v125, v238
		v_max3_f32 v23, v134, v135, v240
		v_max3_f32 v154, v138, v139, v242
		v_max3_f32 v155, v198, v199, v244
		v_max3_f32 v156, v146, v147, v246
		v_max3_f32 v157, v182, v183, v248
		v_max3_f32 v186, v254, v255, v252
		v_max3_f32 v5, v5, v227, v13
		v_max3_f32 v13, v15, v233, v16
		v_max3_f32 v15, v18, v237, v20
		v_max3_f32 v16, v23, v241, v154
		v_max3_f32 v18, v155, v245, v156
		v_max3_f32 v20, v157, v249, v186
		v_accvgpr_read_b32 v23, a250
		v_accvgpr_read_b32 v154, a251
		v_max3_f32 v23, v23, v161, v154
		v_accvgpr_read_b32 v154, a252
		v_accvgpr_read_b32 v155, a253
		v_max3_f32 v154, v154, v169, v155
		v_max3_f32 v5, v5, v229, v13
		v_max3_f32 v13, v15, v239, v16
		v_max3_f32 v15, v18, v247, v20
		v_max3_f32 v16, v23, v165, v154
		v_max3_f32 v5, v5, v235, v13
		v_max3_f32 v13, v15, v253, v16
		v_max3_f32 v5, v5, v243, v13
		v_max_f32_e32 v154, v5, v173
		v_mov_b32_e32 v155, v154
		v_cndmask_b32_e64 v156, v4, v96, s[50:51]
		v_cndmask_b32_e64 v157, v4, v97, s[96:97]
		v_permlane32_swap_b32_e32 v154, v155
		v_max3_f32 v5, v156, v157, v112
		v_max3_f32 v13, v98, v99, v100
		v_max3_f32 v15, v102, v103, v104
		v_max3_f32 v16, v26, v27, v106
		v_max3_f32 v18, v28, v29, v110
		v_max3_f32 v20, v114, v115, v118
		v_max3_f32 v23, v120, v121, v122
		v_max3_f32 v96, v126, v127, v128
		v_max3_f32 v97, v130, v131, v132
		v_max3_f32 v186, v136, v137, v192
		v_max3_f32 v187, v194, v195, v196
		v_max3_f32 v188, v140, v141, v142
		v_max3_f32 v189, v144, v145, v176
		v_max3_f32 v190, v178, v179, v180
		v_max3_f32 v191, v148, v149, v150
		v_max3_f32 v200, v152, v153, v184
		v_max3_f32 v5, v5, v113, v13
		v_max3_f32 v13, v15, v105, v16
		v_max3_f32 v15, v18, v111, v20
		v_max3_f32 v16, v23, v123, v96
		v_max3_f32 v18, v97, v133, v186
		v_max3_f32 v20, v187, v197, v188
		v_max3_f32 v23, v189, v177, v190
		v_max3_f32 v96, v191, v151, v200
		v_max3_f32 v5, v5, v101, v13
		v_max3_f32 v13, v15, v119, v16
		v_max3_f32 v15, v18, v193, v20
		v_max3_f32 v16, v23, v181, v96
		v_max3_f32 v5, v5, v107, v13
		v_max3_f32 v13, v15, v143, v16
		v_max3_f32 v5, v5, v129, v13
		v_max_f32_e32 v96, v5, v185
		v_mov_b32_e32 v97, v96
		v_max_f32_e32 v186, v154, v155
		v_mov_b32_e32 v154, v2
		v_permlane32_swap_b32_e32 v96, v97
		v_max_f32_e32 v187, v96, v97
		v_pk_mul_f32 v[96:97], v[186:187], v[8:9]
		v_max_f32_e32 v186, v2, v96
		v_max_f32_e32 v187, v11, v97
		v_pk_fma_f32 v[96:97], v[250:251], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[226:227], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[174:175], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[228:229], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[116:117], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[232:233], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[108:109], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[234:235], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[30:31], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[236:237], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[124:125], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[238:239], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[134:135], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[240:241], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[138:139], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[242:243], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[198:199], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[244:245], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[146:147], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[246:247], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[182:183], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[248:249], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[218:219], v[254:255], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[220:221], v[252:253], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[222:223], v[158:159], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[160:161], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[162:163], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[164:165], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[166:167], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[168:169], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[170:171], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[172:173], v[8:9], v[186:187] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[156:157], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[112:113], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[98:99], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[26:27], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[106:107], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[28:29], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[110:111], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[114:115], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[118:119], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[120:121], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[122:123], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[126:127], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[128:129], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[130:131], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[132:133], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[136:137], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[192:193], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[194:195], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[196:197], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[140:141], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[142:143], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[144:145], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[176:177], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[178:179], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[180:181], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[148:149], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[150:151], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[184:185], v[8:9], v[186:187] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v184, v96
		v_exp_f32_e32 v224, v97
		v_exp_f32_e32 v96, v188
		v_exp_f32_e32 v226, v189
		v_exp_f32_e32 v188, v190
		v_exp_f32_e32 v228, v191
		v_exp_f32_e32 v190, v174
		v_exp_f32_e32 v230, v175
		v_exp_f32_e32 v174, v200
		v_exp_f32_e32 v232, v201
		v_exp_f32_e32 v200, v116
		v_exp_f32_e32 v234, v117
		v_exp_f32_e32 v116, v202
		v_exp_f32_e32 v236, v203
		v_exp_f32_e32 v202, v108
		v_exp_f32_e32 v238, v109
		v_exp_f32_e32 v108, v204
		v_exp_f32_e32 v240, v205
		v_exp_f32_e32 v204, v30
		v_exp_f32_e32 v242, v31
		v_exp_f32_e32 v30, v206
		v_exp_f32_e32 v244, v207
		v_exp_f32_e32 v206, v124
		v_exp_f32_e32 v246, v125
		v_exp_f32_e32 v124, v208
		v_exp_f32_e32 v248, v209
		v_exp_f32_e32 v208, v134
		v_exp_f32_e32 v250, v135
		v_exp_f32_e32 v134, v210
		v_exp_f32_e32 v252, v211
		v_exp_f32_e32 v210, v138
		v_exp_f32_e32 v254, v139
		v_exp_f32_e32 v185, v212
		v_exp_f32_e32 v225, v213
		v_exp_f32_e32 v97, v198
		v_exp_f32_e32 v227, v199
		v_exp_f32_e32 v189, v214
		v_exp_f32_e32 v229, v215
		v_exp_f32_e32 v191, v146
		v_exp_f32_e32 v231, v147
		v_exp_f32_e32 v175, v216
		v_exp_f32_e32 v233, v217
		v_exp_f32_e32 v201, v182
		v_exp_f32_e32 v235, v183
		v_exp_f32_e32 v117, v218
		v_exp_f32_e32 v237, v219
		v_exp_f32_e32 v203, v220
		v_exp_f32_e32 v239, v221
		v_exp_f32_e32 v109, v222
		v_exp_f32_e32 v241, v223
		v_exp_f32_e32 v205, v158
		v_exp_f32_e32 v243, v159
		v_exp_f32_e32 v31, v160
		v_exp_f32_e32 v245, v161
		v_exp_f32_e32 v207, v162
		v_exp_f32_e32 v247, v163
		v_exp_f32_e32 v125, v164
		v_exp_f32_e32 v249, v165
		v_exp_f32_e32 v209, v166
		v_exp_f32_e32 v251, v167
		v_exp_f32_e32 v135, v168
		v_exp_f32_e32 v253, v169
		v_exp_f32_e32 v211, v170
		v_exp_f32_e32 v255, v171
		v_exp_f32_e32 v138, v156
		v_exp_f32_e32 v146, v157
		v_exp_f32_e32 v156, v112
		v_exp_f32_e32 v158, v113
		v_exp_f32_e32 v112, v98
		v_exp_f32_e32 v160, v99
		v_exp_f32_e32 v98, v100
		v_exp_f32_e32 v162, v101
		v_exp_f32_e32 v100, v102
		v_exp_f32_e32 v164, v103
		v_exp_f32_e32 v102, v104
		v_exp_f32_e32 v166, v105
		v_exp_f32_e32 v104, v26
		v_exp_f32_e32 v168, v27
		v_exp_f32_e32 v26, v106
		v_exp_f32_e32 v170, v107
		v_exp_f32_e32 v106, v28
		v_exp_f32_e32 v182, v29
		v_exp_f32_e32 v28, v110
		v_exp_f32_e32 v198, v111
		v_exp_f32_e32 v110, v114
		v_exp_f32_e32 v212, v115
		v_exp_f32_e32 v114, v118
		v_exp_f32_e32 v214, v119
		v_exp_f32_e32 v118, v120
		v_exp_f32_e32 v216, v121
		v_exp_f32_e32 v120, v122
		v_exp_f32_e32 v218, v123
		v_exp_f32_e32 v122, v126
		v_exp_f32_e32 v220, v127
		v_exp_f32_e32 v127, v128
		v_exp_f32_e32 v223, v129
		v_exp_f32_e32 v139, v130
		v_exp_f32_e32 v147, v131
		v_exp_f32_e32 v157, v132
		v_exp_f32_e32 v159, v133
		v_exp_f32_e32 v113, v136
		v_exp_f32_e32 v161, v137
		v_exp_f32_e32 v99, v192
		v_exp_f32_e32 v163, v193
		v_exp_f32_e32 v101, v194
		v_exp_f32_e32 v165, v195
		v_exp_f32_e32 v103, v196
		v_exp_f32_e32 v167, v197
		v_exp_f32_e32 v105, v140
		v_exp_f32_e32 v169, v141
		v_exp_f32_e32 v27, v142
		v_exp_f32_e32 v171, v143
		v_exp_f32_e32 v107, v144
		v_exp_f32_e32 v183, v145
		v_exp_f32_e32 v29, v176
		v_exp_f32_e32 v199, v177
		v_exp_f32_e32 v111, v178
		v_exp_f32_e32 v213, v179
		v_exp_f32_e32 v115, v180
		v_exp_f32_e32 v215, v181
		v_exp_f32_e32 v119, v148
		v_exp_f32_e32 v217, v149
		v_exp_f32_e32 v121, v150
		v_exp_f32_e32 v219, v151
		v_exp_f32_e32 v123, v152
		v_exp_f32_e32 v221, v153
		v_pk_add_f32 v[128:129], v[184:185], v[224:225]
		v_pk_add_f32 v[130:131], v[96:97], v[226:227]
		v_pk_add_f32 v[132:133], v[188:189], v[228:229]
		v_pk_add_f32 v[136:137], v[190:191], v[230:231]
		v_pk_add_f32 v[140:141], v[174:175], v[232:233]
		v_pk_add_f32 v[142:143], v[200:201], v[234:235]
		v_pk_add_f32 v[144:145], v[116:117], v[236:237]
		v_pk_add_f32 v[148:149], v[202:203], v[238:239]
		v_pk_add_f32 v[150:151], v[108:109], v[240:241]
		v_pk_add_f32 v[152:153], v[204:205], v[242:243]
		v_pk_add_f32 v[176:177], v[30:31], v[244:245]
		v_pk_add_f32 v[178:179], v[206:207], v[246:247]
		v_pk_add_f32 v[180:181], v[124:125], v[248:249]
		v_pk_add_f32 v[192:193], v[208:209], v[250:251]
		v_pk_add_f32 v[194:195], v[134:135], v[252:253]
		v_pk_add_f32 v[196:197], v[210:211], v[254:255]
		v_pk_add_f32 v[128:129], v[128:129], v[130:131]
		v_pk_add_f32 v[130:131], v[132:133], v[136:137]
		v_pk_add_f32 v[132:133], v[140:141], v[142:143]
		v_pk_add_f32 v[136:137], v[144:145], v[148:149]
		v_pk_add_f32 v[140:141], v[150:151], v[152:153]
		v_pk_add_f32 v[142:143], v[176:177], v[178:179]
		v_pk_add_f32 v[144:145], v[180:181], v[192:193]
		v_pk_add_f32 v[148:149], v[194:195], v[196:197]
		v_pk_add_f32 v[128:129], v[128:129], v[130:131]
		v_pk_add_f32 v[130:131], v[132:133], v[136:137]
		v_pk_add_f32 v[132:133], v[140:141], v[142:143]
		v_pk_add_f32 v[136:137], v[144:145], v[148:149]
		v_pk_add_f32 v[128:129], v[128:129], v[130:131]
		v_pk_add_f32 v[130:131], v[132:133], v[136:137]
		v_pk_add_f32 v[132:133], v[128:129], v[130:131]
		v_add_f32_e32 v128, v132, v133
		v_mov_b32_e32 v129, v128
		v_exp_f32_e32 v126, v172
		v_exp_f32_e32 v222, v173
		v_permlane32_swap_b32_e32 v128, v129
		v_pk_add_f32 v[130:131], v[126:127], v[222:223]
		v_pk_add_f32 v[132:133], v[138:139], v[146:147]
		v_pk_add_f32 v[136:137], v[156:157], v[158:159]
		v_pk_add_f32 v[140:141], v[112:113], v[160:161]
		v_pk_add_f32 v[142:143], v[98:99], v[162:163]
		v_pk_add_f32 v[144:145], v[100:101], v[164:165]
		v_pk_add_f32 v[148:149], v[102:103], v[166:167]
		v_pk_add_f32 v[150:151], v[104:105], v[168:169]
		v_pk_add_f32 v[152:153], v[26:27], v[170:171]
		v_pk_add_f32 v[172:173], v[106:107], v[182:183]
		v_pk_add_f32 v[176:177], v[28:29], v[198:199]
		v_pk_add_f32 v[178:179], v[110:111], v[212:213]
		v_pk_add_f32 v[180:181], v[114:115], v[214:215]
		v_pk_add_f32 v[192:193], v[118:119], v[216:217]
		v_pk_add_f32 v[194:195], v[120:121], v[218:219]
		v_pk_add_f32 v[196:197], v[122:123], v[220:221]
		v_pk_add_f32 v[130:131], v[130:131], v[132:133]
		v_pk_add_f32 v[132:133], v[136:137], v[140:141]
		v_pk_add_f32 v[136:137], v[142:143], v[144:145]
		v_pk_add_f32 v[140:141], v[148:149], v[150:151]
		v_pk_add_f32 v[142:143], v[152:153], v[172:173]
		v_pk_add_f32 v[144:145], v[176:177], v[178:179]
		v_pk_add_f32 v[148:149], v[180:181], v[192:193]
		v_pk_add_f32 v[150:151], v[194:195], v[196:197]
		v_pk_add_f32 v[130:131], v[130:131], v[132:133]
		v_pk_add_f32 v[132:133], v[136:137], v[140:141]
		v_pk_add_f32 v[136:137], v[142:143], v[144:145]
		v_pk_add_f32 v[140:141], v[148:149], v[150:151]
		v_pk_add_f32 v[130:131], v[130:131], v[132:133]
		v_pk_add_f32 v[132:133], v[136:137], v[140:141]
		v_pk_add_f32 v[136:137], v[130:131], v[132:133]
		v_mov_b32_e32 v130, v129
		v_mov_b32_e32 v131, v137
		v_mov_b32_e32 v132, v128
		v_mov_b32_e32 v133, v136
		v_pk_add_f32 v[128:129], v[132:133], v[130:131]
		v_mov_b32_e32 v130, v129
		v_mov_b32_e32 v131, v129
		v_cvt_pk_bf16_f32 v140, v184, v224
		v_cvt_pk_bf16_f32 v141, v96, v226
		v_permlane32_swap_b32_e32 v130, v131
		v_add_f32_e32 v133, v130, v131
		v_mov_b32_e32 v155, v11
		v_pk_add_f32 v[130:131], v[154:155], v[186:187] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v136, v130
		v_exp_f32_e32 v137, v131
		v_cvt_pk_bf16_f32 v142, v188, v228
		v_pk_mul_f32 v[32:33], v[32:33], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[34:35], v[34:35], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[36:37], v[36:37], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[38:39], v[38:39], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[40:41], v[40:41], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[42:43], v[42:43], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[44:45], v[44:45], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[46:47], v[46:47], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[48:49], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[50:51], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[52:53], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[54:55], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[56:57], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[58:59], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[60:61], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[62:63], v[136:137] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[64:65], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[66:67], v[66:67], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[68:69], v[68:69], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[70:71], v[70:71], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[72:73], v[72:73], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[74:75], v[74:75], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[76:77], v[76:77], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[78:79], v[78:79], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[80:81], v[80:81], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[82:83], v[82:83], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[84:85], v[84:85], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[86:87], v[86:87], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[88:89], v[88:89], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[90:91], v[90:91], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[92:93], v[92:93], v[136:137] op_sel:[0,1]
		v_pk_mul_f32 v[94:95], v[94:95], v[136:137] op_sel:[0,1]
		v_mov_b32_e32 v132, v128
		v_mov_b64_e32 v[128:129], v[24:25]
		v_pk_fma_f32 v[24:25], v[128:129], v[136:137], v[132:133]
		v_cvt_pk_bf16_f32 v143, v190, v230
		v_cvt_pk_bf16_f32 v128, v174, v232
		v_cvt_pk_bf16_f32 v129, v200, v234
		v_cvt_pk_bf16_f32 v130, v116, v236
		v_cvt_pk_bf16_f32 v131, v202, v238
		v_cvt_pk_bf16_f32 v148, v108, v240
		v_cvt_pk_bf16_f32 v149, v204, v242
		v_cvt_pk_bf16_f32 v150, v30, v244
		v_cvt_pk_bf16_f32 v151, v206, v246
		v_cvt_pk_bf16_f32 v152, v124, v248
		v_cvt_pk_bf16_f32 v153, v208, v250
		v_cvt_pk_bf16_f32 v154, v134, v252
		v_cvt_pk_bf16_f32 v155, v210, v254
		v_cvt_pk_bf16_f32 v176, v185, v225
		v_cvt_pk_bf16_f32 v177, v97, v227
		v_cvt_pk_bf16_f32 v178, v189, v229
		v_cvt_pk_bf16_f32 v179, v191, v231
		v_cvt_pk_bf16_f32 v188, v175, v233
		v_cvt_pk_bf16_f32 v189, v201, v235
		v_cvt_pk_bf16_f32 v190, v117, v237
		v_cvt_pk_bf16_f32 v191, v203, v239
		v_cvt_pk_bf16_f32 v172, v109, v241
		v_cvt_pk_bf16_f32 v173, v205, v243
		v_cvt_pk_bf16_f32 v174, v31, v245
		v_cvt_pk_bf16_f32 v175, v207, v247
		v_cvt_pk_bf16_f32 v192, v125, v249
		v_cvt_pk_bf16_f32 v193, v209, v251
		v_cvt_pk_bf16_f32 v194, v135, v253
		v_cvt_pk_bf16_f32 v195, v211, v255
		v_cvt_pk_bf16_f32 v132, v126, v222
		v_cvt_pk_bf16_f32 v133, v138, v146
		v_cvt_pk_bf16_f32 v134, v156, v158
		v_cvt_pk_bf16_f32 v135, v112, v160
		v_cvt_pk_bf16_f32 v200, v98, v162
		v_cvt_pk_bf16_f32 v201, v100, v164
		v_cvt_pk_bf16_f32 v202, v102, v166
		v_cvt_pk_bf16_f32 v203, v104, v168
		v_cvt_pk_bf16_f32 v204, v26, v170
		v_cvt_pk_bf16_f32 v205, v106, v182
		v_cvt_pk_bf16_f32 v206, v28, v198
		v_cvt_pk_bf16_f32 v207, v110, v212
		v_cvt_pk_bf16_f32 v208, v114, v214
		v_cvt_pk_bf16_f32 v209, v118, v216
		v_cvt_pk_bf16_f32 v210, v120, v218
		v_cvt_pk_bf16_f32 v211, v122, v220
		v_cvt_pk_bf16_f32 v224, v127, v223
		v_cvt_pk_bf16_f32 v225, v139, v147
		v_cvt_pk_bf16_f32 v226, v157, v159
		v_cvt_pk_bf16_f32 v227, v113, v161
		v_cvt_pk_bf16_f32 v124, v99, v163
		v_cvt_pk_bf16_f32 v125, v101, v165
		v_cvt_pk_bf16_f32 v126, v103, v167
		v_cvt_pk_bf16_f32 v127, v105, v169
		v_cvt_pk_bf16_f32 v96, v27, v171
		v_cvt_pk_bf16_f32 v97, v107, v183
		v_cvt_pk_bf16_f32 v98, v29, v199
		v_cvt_pk_bf16_f32 v99, v111, v213
		v_cvt_pk_bf16_f32 v28, v115, v215
		v_cvt_pk_bf16_f32 v29, v119, v217
		v_cvt_pk_bf16_f32 v30, v121, v219
		v_cvt_pk_bf16_f32 v31, v123, v221
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[32:47], a[184:187], v[140:143], v[32:47]
		v_permlane32_swap_b32_e32 v148, v150
		v_permlane32_swap_b32_e32 v149, v151
		v_mfma_f32_32x32x16_bf16 v[48:63], a[216:219], v[140:143], v[48:63]
		v_permlane32_swap_b32_e32 v152, v154
		v_permlane32_swap_b32_e32 v153, v155
		v_mfma_f32_32x32x16_bf16 v[32:47], a[188:191], v[128:131], v[32:47]
		v_permlane32_swap_b32_e32 v176, v178
		v_permlane32_swap_b32_e32 v177, v179
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[220:223], v[128:131], v[48:63]
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[148:151], v[32:47]
		v_permlane32_swap_b32_e32 v172, v174
		v_permlane32_swap_b32_e32 v173, v175
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[148:151], v[48:63]
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[152:155], v[32:47]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[152:155], v[48:63]
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_mfma_f32_32x32x16_bf16 v[80:95], a[216:219], v[132:135], v[80:95]
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_mfma_f32_32x32x16_bf16 v[64:79], a[184:187], v[132:135], v[64:79]
		v_permlane32_swap_b32_e32 v208, v210
		v_permlane32_swap_b32_e32 v209, v211
		v_mfma_f32_32x32x16_bf16 v[80:95], a[220:223], v[200:203], v[80:95]
		v_permlane32_swap_b32_e32 v224, v226
		v_permlane32_swap_b32_e32 v225, v227
		v_mfma_f32_32x32x16_bf16 v[64:79], a[188:191], v[200:203], v[64:79]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[204:207], v[80:95]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[204:207], v[64:79]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[208:211], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[208:211], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[176:179], v[32:47]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[176:179], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[224:227], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[224:227], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[188:191], v[32:47]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[188:191], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[124:127], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[124:127], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[172:175], v[32:47]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[172:175], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[192:195], v[32:47]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[192:195], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[28:31], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[28:31], v[64:79]
		s_cselect_b32 s1, 1, 0
		s_add_i32 s23, s41, 0x80
		s_cmp_lg_u32 s1, 0
		s_mov_b32 s41, s23
		v_mov_b32_e32 v2, v186
		v_mov_b32_e32 v11, v187
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_4
.L_attn_fwd_persistent.loop_exit_4:
		v_rcp_f32_e32 v2, v24
		v_accvgpr_read_b32 v1, a4
		s_nop 0
		v_readfirstlane_b32 s1, v1
		v_accvgpr_read_b32 v1, a12
		s_nop 0
		v_readfirstlane_b32 s18, v1
		s_mul_i32 s1, s18, s1
		v_mov_b32_e32 v3, v2
		v_pk_mul_f32 v[4:5], v[32:33], v[2:3]
		v_pk_mul_f32 v[6:7], v[34:35], v[2:3]
		v_pk_mul_f32 v[8:9], v[36:37], v[2:3]
		v_pk_mul_f32 v[10:11], v[38:39], v[2:3]
		v_pk_mul_f32 v[12:13], v[40:41], v[2:3]
		v_pk_mul_f32 v[14:15], v[42:43], v[2:3]
		v_pk_mul_f32 v[16:17], v[44:45], v[2:3]
		v_pk_mul_f32 v[18:19], v[46:47], v[2:3]
		v_pk_mul_f32 v[20:21], v[48:49], v[2:3]
		v_pk_mul_f32 v[22:23], v[50:51], v[2:3]
		v_pk_mul_f32 v[26:27], v[52:53], v[2:3]
		v_pk_mul_f32 v[28:29], v[54:55], v[2:3]
		v_pk_mul_f32 v[30:31], v[56:57], v[2:3]
		v_pk_mul_f32 v[32:33], v[58:59], v[2:3]
		v_pk_mul_f32 v[34:35], v[60:61], v[2:3]
		v_pk_mul_f32 v[36:37], v[62:63], v[2:3]
		v_rcp_f32_e32 v2, v25
		v_cvt_pk_bf16_f32 v40, v4, v5
		v_mov_b32_e32 v3, v2
		v_pk_mul_f32 v[4:5], v[64:65], v[2:3]
		v_pk_mul_f32 v[24:25], v[66:67], v[2:3]
		v_pk_mul_f32 v[38:39], v[68:69], v[2:3]
		v_pk_mul_f32 v[44:45], v[70:71], v[2:3]
		v_pk_mul_f32 v[46:47], v[72:73], v[2:3]
		v_pk_mul_f32 v[48:49], v[74:75], v[2:3]
		v_pk_mul_f32 v[50:51], v[76:77], v[2:3]
		v_pk_mul_f32 v[52:53], v[78:79], v[2:3]
		v_pk_mul_f32 v[54:55], v[80:81], v[2:3]
		v_pk_mul_f32 v[56:57], v[82:83], v[2:3]
		v_pk_mul_f32 v[58:59], v[84:85], v[2:3]
		v_pk_mul_f32 v[60:61], v[86:87], v[2:3]
		v_pk_mul_f32 v[62:63], v[88:89], v[2:3]
		v_pk_mul_f32 v[64:65], v[90:91], v[2:3]
		v_pk_mul_f32 v[66:67], v[92:93], v[2:3]
		v_pk_mul_f32 v[68:69], v[94:95], v[2:3]
		v_cvt_pk_bf16_f32 v41, v6, v7
		v_cvt_pk_bf16_f32 v42, v8, v9
		v_cvt_pk_bf16_f32 v43, v10, v11
		v_cvt_pk_bf16_f32 v8, v12, v13
		v_cvt_pk_bf16_f32 v9, v14, v15
		v_cvt_pk_bf16_f32 v10, v16, v17
		v_cvt_pk_bf16_f32 v11, v18, v19
		v_cvt_pk_bf16_f32 v12, v20, v21
		v_cvt_pk_bf16_f32 v13, v22, v23
		v_cvt_pk_bf16_f32 v14, v26, v27
		v_cvt_pk_bf16_f32 v15, v28, v29
		v_cvt_pk_bf16_f32 v16, v30, v31
		v_cvt_pk_bf16_f32 v17, v32, v33
		v_cvt_pk_bf16_f32 v18, v34, v35
		v_cvt_pk_bf16_f32 v19, v36, v37
		v_cvt_pk_bf16_f32 v20, v4, v5
		v_cvt_pk_bf16_f32 v21, v24, v25
		v_cvt_pk_bf16_f32 v22, v38, v39
		v_cvt_pk_bf16_f32 v23, v44, v45
		v_cvt_pk_bf16_f32 v4, v46, v47
		v_cvt_pk_bf16_f32 v5, v48, v49
		v_cvt_pk_bf16_f32 v6, v50, v51
		v_cvt_pk_bf16_f32 v7, v52, v53
		v_cvt_pk_bf16_f32 v24, v54, v55
		v_cvt_pk_bf16_f32 v25, v56, v57
		v_cvt_pk_bf16_f32 v26, v58, v59
		v_cvt_pk_bf16_f32 v27, v60, v61
		v_cvt_pk_bf16_f32 v28, v62, v63
		v_cvt_pk_bf16_f32 v29, v64, v65
		v_cvt_pk_bf16_f32 v30, v66, v67
		v_cvt_pk_bf16_f32 v31, v68, v69
		v_permlane32_swap_b32_e32 v40, v42
		v_permlane32_swap_b32_e32 v41, v43
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
		v_permlane32_swap_b32_e32 v12, v14
		v_permlane32_swap_b32_e32 v13, v15
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v20, v22
		v_permlane32_swap_b32_e32 v21, v23
		v_permlane32_swap_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v5, v7
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		s_lshl_b32 s1, s1, 9
		v_accvgpr_read_b32 v1, a2
		s_nop 0
		v_readfirstlane_b32 s18, v1
		v_accvgpr_read_b32 v1, a10
		s_nop 0
		v_readfirstlane_b32 s21, v1
		s_mul_i32 s18, s21, s18
		s_lshl_b32 s18, s18, 1
		s_add_i32 s21, s1, s18
		v_accvgpr_read_b32 v1, a3
		s_nop 0
		v_readfirstlane_b32 s22, v1
		v_accvgpr_read_b32 v1, a11
		s_nop 0
		v_readfirstlane_b32 s23, v1
		s_mul_i32 s22, s23, s22
		s_lshl_b32 s22, s22, 1
		s_add_i32 s21, s21, s22
		v_accvgpr_read_b32 v1, a4
		s_nop 0
		v_readfirstlane_b32 s23, v1
		v_accvgpr_read_b32 v1, a16
		s_nop 0
		v_readfirstlane_b32 s24, v1
		s_mul_i32 s23, s23, s24
		s_lshl_b32 s23, s23, 6
		s_add_i32 s21, s21, s23
		v_and_b32_e32 v1, 31, v0
		v_accvgpr_read_b32 v2, a4
		s_nop 0
		v_readfirstlane_b32 s24, v2
		s_nop 1
		v_mul_lo_u32 v1, s24, v1
		v_lshlrev_b32_e32 v1, 1, v1
		v_accvgpr_read_b32 v2, a17
		v_lshlrev_b32_e32 v2, 4, v2
		v_add3_u32 v3, s21, v1, v2
		v_accvgpr_read_b32 v32, a13
		v_accvgpr_read_b32 v33, a52
		s_nop 0
		v_readfirstlane_b32 s24, v33
		v_accvgpr_read_b32 v33, a53
		s_nop 0
		v_readfirstlane_b32 s25, v33
		s_nop 1
		v_cndmask_b32_e64 v3, v32, v3, s[24:25]
		s_mov_b32 s24, s8
		s_mov_b32 s25, s9
		s_mov_b32 s26, s30
		s_mov_b32 s27, s31
		buffer_store_dwordx4 v[40:43], v3, s[24:27], 0 offen
		s_add_i32 s28, s21, 32
		v_add3_u32 v3, s28, v1, v2
		v_accvgpr_read_b32 v32, a13
		v_accvgpr_read_b32 v33, a52
		s_nop 0
		v_readfirstlane_b32 s28, v33
		v_accvgpr_read_b32 v33, a53
		s_nop 0
		v_readfirstlane_b32 s29, v33
		s_nop 1
		v_cndmask_b32_e64 v3, v32, v3, s[28:29]
		buffer_store_dwordx4 v[8:11], v3, s[24:27], 0 offen
		s_add_i32 s28, s21, 64
		v_add3_u32 v3, s28, v1, v2
		v_accvgpr_read_b32 v8, a13
		v_accvgpr_read_b32 v9, a52
		s_nop 0
		v_readfirstlane_b32 s28, v9
		v_accvgpr_read_b32 v9, a53
		s_nop 0
		v_readfirstlane_b32 s29, v9
		s_nop 1
		v_cndmask_b32_e64 v3, v8, v3, s[28:29]
		buffer_store_dwordx4 v[12:15], v3, s[24:27], 0 offen
		s_add_i32 s21, s21, 0x60
		v_add3_u32 v3, s21, v1, v2
		v_accvgpr_read_b32 v8, a13
		v_accvgpr_read_b32 v9, a52
		s_nop 0
		v_readfirstlane_b32 s28, v9
		v_accvgpr_read_b32 v9, a53
		s_nop 0
		v_readfirstlane_b32 s29, v9
		s_nop 1
		v_cndmask_b32_e64 v3, v8, v3, s[28:29]
		buffer_store_dwordx4 v[16:19], v3, s[24:27], 0 offen
		v_accvgpr_read_b32 v3, a4
		s_nop 0
		v_readfirstlane_b32 s21, v3
		s_lshl_b32 s21, s21, 8
		s_add_i32 s1, s21, s1
		s_add_i32 s1, s1, s18
		s_add_i32 s1, s1, s22
		s_add_i32 s1, s1, s23
		v_add3_u32 v3, s1, v1, v2
		v_accvgpr_read_b32 v8, a13
		v_accvgpr_read_b32 v9, a60
		s_nop 0
		v_readfirstlane_b32 s22, v9
		v_accvgpr_read_b32 v9, a61
		s_nop 0
		v_readfirstlane_b32 s23, v9
		s_nop 1
		v_cndmask_b32_e64 v3, v8, v3, s[22:23]
		buffer_store_dwordx4 v[20:23], v3, s[24:27], 0 offen
		s_add_i32 s18, s1, 32
		v_add3_u32 v3, s18, v1, v2
		v_accvgpr_read_b32 v8, a13
		v_accvgpr_read_b32 v9, a60
		s_nop 0
		v_readfirstlane_b32 s22, v9
		v_accvgpr_read_b32 v9, a61
		s_nop 0
		v_readfirstlane_b32 s23, v9
		s_nop 1
		v_cndmask_b32_e64 v3, v8, v3, s[22:23]
		buffer_store_dwordx4 v[4:7], v3, s[24:27], 0 offen
		s_add_i32 s18, s1, 64
		v_add3_u32 v3, s18, v1, v2
		v_accvgpr_read_b32 v4, a13
		v_accvgpr_read_b32 v5, a60
		s_nop 0
		v_readfirstlane_b32 s22, v5
		v_accvgpr_read_b32 v5, a61
		s_nop 0
		v_readfirstlane_b32 s23, v5
		s_nop 1
		v_cndmask_b32_e64 v3, v4, v3, s[22:23]
		buffer_store_dwordx4 v[24:27], v3, s[24:27], 0 offen
		s_add_i32 s1, s1, 0x60
		v_add3_u32 v1, s1, v1, v2
		v_accvgpr_read_b32 v2, a13
		v_accvgpr_read_b32 v3, a60
		s_nop 0
		v_readfirstlane_b32 s22, v3
		v_accvgpr_read_b32 v3, a61
		s_nop 0
		v_readfirstlane_b32 s23, v3
		s_nop 1
		v_cndmask_b32_e64 v1, v2, v1, s[22:23]
		buffer_store_dwordx4 v[28:31], v1, s[24:27], 0 offen
		s_branch .L_attn_fwd_persistent.if_end_3
.L_attn_fwd_persistent.if_else_3:
.L_attn_fwd_persistent.if_end_3:
		s_branch .L_attn_fwd_persistent.if_end_0
.L_attn_fwd_persistent.if_else_0:
.L_attn_fwd_persistent.if_end_0:
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s0, s0, 32
		v_accvgpr_read_b32 v1, a9
		s_nop 0
		v_readfirstlane_b32 s1, v1
		s_cmp_lt_i32 s0, s1
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_0
.L_attn_fwd_persistent.loop_exit_0:
		s_endpgm
	.size	_attn_fwd_persistent, .-_attn_fwd_persistent
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _attn_fwd_persistent
		.amdhsa_group_segment_fixed_size 100784
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 104
		.amdhsa_user_sgpr_count 16
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_user_sgpr_kernarg_preload_length 14
		.amdhsa_user_sgpr_kernarg_preload_offset 0
		.amdhsa_enable_private_segment 0
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 0
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 510
		.amdhsa_next_free_sgpr 102
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
	.set .L_attn_fwd_persistent.num_vgpr, 256
	.set .L_attn_fwd_persistent.num_agpr, 254
	.set .L_attn_fwd_persistent.numbered_sgpr, 102
	.set .L_attn_fwd_persistent.num_named_barrier, 0
	.set .L_attn_fwd_persistent.private_seg_size, 0
	.set .L_attn_fwd_persistent.uses_vcc, 1
	.set .L_attn_fwd_persistent.uses_flat_scratch, 0
	.set .L_attn_fwd_persistent.has_dyn_sized_stack, 0
	.set .L_attn_fwd_persistent.has_recursion, 0
	.set .L_attn_fwd_persistent.has_indirect_call, 0
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
      - .name:           arg19
        .offset:         92
        .size:           4
        .value_kind:     by_value
      - .name:           arg20
        .offset:         96
        .size:           4
        .value_kind:     by_value
    .group_segment_fixed_size: 100784
    .kernarg_segment_align: 8
    .kernarg_segment_size: 104
    .max_flat_workgroup_size: 256
    .name:           _attn_fwd_persistent
    .private_segment_fixed_size: 0
    .sgpr_count:     102
    .sgpr_spill_count: 0
    .symbol:         _attn_fwd_persistent.kd
    .uses_dynamic_stack: false
    .vgpr_count:     510
    .agpr_count:     254
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 414
    wave.regalloc.agpr.dwords: 784
    wave.regalloc.remat.dwords: 3
    wave.regalloc.sgpr_to_vgpr.dwords: 60
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
