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
		v_mov_b32_e32 v2, 0x3e38aa3b
		s_mov_b32 s25, 0xff800000
		v_mov_b32_e32 v4, s25
		v_mov_b32_e32 v5, s25
		s_mov_b32 s25, 1.0
		v_mov_b32_e32 v8, s25
		v_mov_b32_e32 v9, s25
		s_mov_b32 s25, 0
		v_lshrrev_b32_e32 v11, 4, v15
		v_lshlrev_b32_e32 v11, 9, v11
		v_and_b32_e32 v15, 15, v15
		v_mov_b32_e32 v18, 0x410
		v_mul_lo_u32 v18, v18, v15
		v_add3_u32 v11, v13, v11, v18
		v_accvgpr_write_b32 a62, v11
		v_and_b32_e32 v11, 3, v0
		v_accvgpr_read_b32 v13, a17
		v_mov_b32_e32 v15, 0x2200
		v_mul_lo_u32 v15, v15, v13
		v_lshl_add_u32 v11, v11, 3, v15
		v_lshl_add_u32 v3, v3, 5, v11
		v_mov_b32_e32 v11, 0x880
		v_mul_lo_u32 v11, v11, v1
		v_add3_u32 v1, v3, v11, v16
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
		ds_read_b128 v[24:27], v1
		ds_read_b128 v[28:31], v1 offset:32
		ds_read_b128 v[96:99], v1 offset:64
		ds_read_b128 a[64:67], v1 offset:96
		ds_read_b128 v[100:103], v1 offset:256
		ds_read_b128 v[104:107], v1 offset:288
		ds_read_b128 v[108:111], v1 offset:320
		ds_read_b128 a[68:71], v1 offset:352
		ds_read_b128 v[112:115], v1 offset:128
		ds_read_b128 v[116:119], v1 offset:160
		ds_read_b128 v[120:123], v1 offset:192
		ds_read_b128 a[72:75], v1 offset:224
		ds_read_b128 v[124:127], v1 offset:384
		ds_read_b128 v[128:131], v1 offset:416
		ds_read_b128 a[76:79], v1 offset:448
		ds_read_b128 a[80:83], v1 offset:480
		s_mul_i32 s46, 0x4400, s46
		v_accvgpr_read_b32 v1, a63
		v_add_u32_e32 v1, s46, v1
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
		s_mul_i32 s46, s15, s25
		s_lshl_b32 s46, s46, 1
		s_add_i32 s47, s23, s46
		v_add3_u32 v1, s47, v12, v19
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[144:159], v[24:27], a[20:23], 0
		v_add3_u32 v1, v1, v21, v14
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[24:27], v[144:159]
		s_add_i32 s42, s42, 1
		v_mfma_f32_32x32x16_bf16 v[144:159], v[96:99], a[28:31], v[144:159]
		s_and_b32 s42, s42, 1
		v_mfma_f32_32x32x16_bf16 v[160:175], v[24:27], a[36:39], 0
		s_mul_i32 s47, 0x4100, s42
		v_mfma_f32_32x32x16_bf16 v[160:175], v[28:31], a[40:43], v[160:175]
		s_add_i32 s47, s40, s47
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], a[44:47], v[160:175]
		s_mov_b32 m0, s47
		v_mfma_f32_32x32x16_bf16 v[176:191], v[100:103], a[20:23], 0
		s_add_i32 s47, s43, s46
		v_mfma_f32_32x32x16_bf16 v[176:191], v[104:107], a[24:27], v[176:191]
		v_add3_u32 v3, s47, v12, v19
		v_mfma_f32_32x32x16_bf16 v[176:191], v[108:111], a[28:31], v[176:191]
		v_add3_u32 v3, v3, v21, v14
		v_mfma_f32_32x32x16_bf16 v[192:207], v[100:103], a[36:39], 0
		s_add_i32 s47, s44, s46
		v_mfma_f32_32x32x16_bf16 v[192:207], v[104:107], a[40:43], v[192:207]
		v_add3_u32 v11, s47, v12, v19
		v_mfma_f32_32x32x16_bf16 v[192:207], v[108:111], a[44:47], v[192:207]
		v_add3_u32 v11, v11, v21, v14
		v_mfma_f32_32x32x16_bf16 v[96:111], v[112:115], a[20:23], 0
		s_add_i32 s46, s36, s46
		v_mfma_f32_32x32x16_bf16 v[96:111], v[116:119], a[24:27], v[96:111]
		v_add3_u32 v13, s46, v12, v19
		v_mfma_f32_32x32x16_bf16 v[96:111], v[120:123], a[28:31], v[96:111]
		v_add3_u32 v13, v13, v21, v14
		v_mfma_f32_32x32x16_bf16 v[208:223], v[112:115], a[36:39], 0
		s_mul_i32 s46, s17, s25
		v_mfma_f32_32x32x16_bf16 v[208:223], v[116:119], a[40:43], v[208:223]
		s_add_i32 s25, s25, 0x80
		v_mfma_f32_32x32x16_bf16 v[208:223], v[120:123], a[44:47], v[208:223]
		v_accvgpr_read_b32 v15, a18
		v_add_u32_e32 v15, s25, v15
		v_mfma_f32_32x32x16_bf16 v[224:239], v[124:127], a[20:23], 0
		v_accvgpr_read_b32 v16, a54
		v_add_u32_e32 v16, s25, v16
		v_mfma_f32_32x32x16_bf16 v[224:239], v[128:131], a[24:27], v[224:239]
		v_accvgpr_read_b32 v18, a55
		v_add_u32_e32 v18, s25, v18
		v_mfma_f32_32x32x16_bf16 v[224:239], a[76:79], a[28:31], v[224:239]
		v_accvgpr_read_b32 v20, a56
		v_add_u32_e32 v20, s25, v20
		v_mfma_f32_32x32x16_bf16 v[240:255], v[124:127], a[36:39], 0
		v_cmp_lt_i32_e64 s[48:49], v15, s20
		v_accvgpr_read_b32 v15, a19
		v_add_u32_e32 v15, s25, v15
		v_accvgpr_read_b32 v23, a57
		v_add_u32_e32 v23, s25, v23
		v_accvgpr_read_b32 v24, a58
		v_add_u32_e32 v24, s25, v24
		v_accvgpr_read_b32 v25, a59
		v_add_u32_e32 v25, s25, v25
		v_cmp_lt_i32_e64 vcc, v25, s20
		v_cndmask_b32_e64 v1, v22, v1, s[48:49]
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[48:49], v16, s20
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[50:51], v18, s20
		v_cndmask_b32_e64 v1, v22, v3, s[48:49]
		v_cmp_lt_i32_e64 s[48:49], v20, s20
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[240:255], v[128:131], a[40:43], v[240:255]
		v_cndmask_b32_e64 v1, v22, v11, s[50:51]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[76:79], a[44:47], v[240:255]
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v3, v22, v13, s[48:49]
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[48:49], v15, s20
		v_cmp_lt_i32_e64 s[50:51], v23, s20
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s46, s46, 1
		s_add_i32 s47, s37, s46
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[144:159], a[64:67], a[32:35], v[144:159]
		v_add3_u32 v1, s47, v6, v7
		v_mfma_f32_32x32x16_bf16 v[160:175], a[64:67], a[48:51], v[160:175]
		v_add3_u32 v1, v1, v17, v14
		v_cndmask_b32_e64 v1, v22, v1, s[48:49]
		v_cmp_lt_i32_e64 s[48:49], v24, s20
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
		v_max3_f32 v11, v148, v149, v150
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v1, v22, v1, s[48:49]
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_max3_f32 v1, v152, v153, v154
		s_add_i32 s42, s24, s46
		v_add3_u32 v13, s42, v6, v7
		v_add3_u32 v13, v13, v17, v14
		v_cndmask_b32_e32 v13, v22, v13, vcc
		v_max3_f32 v15, v156, v157, v158
		s_add_i32 m0, m0, 0x1100
		v_max3_f32 v3, v3, v147, v11
		v_max3_f32 v1, v1, v155, v15
		v_max3_f32 v1, v3, v151, v1
		v_max3_f32 v3, v160, v161, v162
		v_max3_f32 v11, v164, v165, v166
		v_max3_f32 v15, v168, v169, v170
		v_max3_f32 v16, v172, v173, v174
		v_max3_f32 v3, v3, v163, v11
		v_max3_f32 v11, v15, v171, v16
		v_max3_f32 v3, v3, v167, v11
		s_cmp_lt_i32 s25, s41
		buffer_load_dwordx4 v13, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[176:191], a[68:71], a[32:35], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[72:75], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[80:83], a[32:35], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[80:83], a[48:51], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[68:71], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[72:75], a[48:51], v[208:223]
		s_nop 6
		v_max3_f32 v11, v176, v177, v178
		v_max3_f32 v13, v180, v181, v182
		v_max3_f32 v15, v184, v185, v186
		v_max3_f32 v16, v188, v189, v190
		v_max3_f32 v18, v96, v97, v98
		v_max3_f32 v20, v100, v101, v102
		v_max3_f32 v23, v104, v105, v106
		v_max3_f32 v24, v108, v109, v110
		v_max3_f32 v25, v224, v225, v226
		v_max3_f32 v26, v228, v229, v230
		v_max3_f32 v27, v232, v233, v234
		v_max3_f32 v28, v236, v237, v238
		v_max3_f32 v11, v11, v179, v13
		v_max3_f32 v13, v15, v187, v16
		v_max3_f32 v15, v18, v99, v20
		v_max3_f32 v16, v23, v107, v24
		v_max3_f32 v18, v25, v227, v26
		v_max3_f32 v20, v27, v235, v28
		v_max3_f32 v11, v11, v183, v13
		v_max3_f32 v13, v15, v103, v16
		v_max3_f32 v15, v18, v231, v20
		v_max3_f32 v1, v1, v159, v11
		v_max3_f32 v11, v13, v111, v15
		v_max3_f32 v1, v1, v191, v11
		v_max_f32_e32 v24, v1, v239
		v_mov_b32_e32 v25, v24
		v_max3_f32 v1, v192, v193, v194
		v_max3_f32 v11, v196, v197, v198
		v_max3_f32 v13, v200, v201, v202
		v_max3_f32 v15, v204, v205, v206
		v_max3_f32 v16, v208, v209, v210
		v_max3_f32 v18, v212, v213, v214
		v_max3_f32 v20, v216, v217, v218
		v_max3_f32 v23, v220, v221, v222
		v_max3_f32 v26, v240, v241, v242
		v_max3_f32 v27, v244, v245, v246
		v_max3_f32 v28, v248, v249, v250
		v_max3_f32 v29, v252, v253, v254
		v_max3_f32 v1, v1, v195, v11
		v_max3_f32 v11, v13, v203, v15
		v_max3_f32 v13, v16, v211, v18
		v_max3_f32 v15, v20, v219, v23
		v_permlane32_swap_b32_e32 v24, v25
		v_max3_f32 v16, v26, v243, v27
		v_max3_f32 v18, v28, v251, v29
		v_max3_f32 v1, v1, v199, v11
		v_max3_f32 v11, v13, v215, v15
		v_max3_f32 v13, v16, v247, v18
		v_max3_f32 v1, v3, v175, v1
		v_max3_f32 v3, v11, v223, v13
		v_max3_f32 v1, v1, v207, v3
		v_max_f32_e32 v26, v1, v255
		v_mov_b32_e32 v27, v26
		v_max_f32_e32 v1, v24, v25
		v_mul_f32_e32 v1, v1, v2
		v_permlane32_swap_b32_e32 v26, v27
		v_max_f32_e32 v3, v26, v27
		v_mul_f32_e32 v3, v3, v2
		v_max_f32_e32 v1, v4, v1
		v_max_f32_e32 v3, v5, v3
		v_xor_b32_e32 v11, 0x80000000, v1
		v_fma_f32 v13, v144, v2, v11
		v_fma_f32 v15, v145, v2, v11
		v_fma_f32 v16, v146, v2, v11
		v_fma_f32 v18, v147, v2, v11
		v_fma_f32 v20, v148, v2, v11
		v_fma_f32 v23, v149, v2, v11
		v_fma_f32 v24, v150, v2, v11
		v_fma_f32 v25, v151, v2, v11
		v_fma_f32 v26, v152, v2, v11
		v_fma_f32 v27, v153, v2, v11
		v_fma_f32 v28, v154, v2, v11
		v_fma_f32 v29, v155, v2, v11
		v_fma_f32 v30, v156, v2, v11
		v_fma_f32 v31, v157, v2, v11
		v_fma_f32 v112, v158, v2, v11
		v_fma_f32 v113, v159, v2, v11
		v_fma_f32 v114, v176, v2, v11
		v_fma_f32 v115, v177, v2, v11
		v_fma_f32 v116, v178, v2, v11
		v_fma_f32 v117, v179, v2, v11
		v_fma_f32 v118, v180, v2, v11
		v_fma_f32 v119, v181, v2, v11
		v_fma_f32 v120, v182, v2, v11
		v_fma_f32 v121, v183, v2, v11
		v_fma_f32 v122, v184, v2, v11
		v_fma_f32 v123, v185, v2, v11
		v_fma_f32 v124, v186, v2, v11
		v_fma_f32 v125, v187, v2, v11
		v_fma_f32 v126, v188, v2, v11
		v_fma_f32 v127, v189, v2, v11
		v_fma_f32 v128, v190, v2, v11
		v_fma_f32 v129, v191, v2, v11
		v_fma_f32 v96, v96, v2, v11
		v_fma_f32 v97, v97, v2, v11
		v_fma_f32 v98, v98, v2, v11
		v_fma_f32 v99, v99, v2, v11
		v_fma_f32 v100, v100, v2, v11
		v_fma_f32 v101, v101, v2, v11
		v_fma_f32 v102, v102, v2, v11
		v_fma_f32 v103, v103, v2, v11
		v_fma_f32 v104, v104, v2, v11
		v_fma_f32 v105, v105, v2, v11
		v_fma_f32 v106, v106, v2, v11
		v_fma_f32 v107, v107, v2, v11
		v_fma_f32 v108, v108, v2, v11
		v_fma_f32 v109, v109, v2, v11
		v_fma_f32 v110, v110, v2, v11
		v_fma_f32 v111, v111, v2, v11
		v_fma_f32 v130, v224, v2, v11
		v_fma_f32 v131, v225, v2, v11
		v_fma_f32 v132, v226, v2, v11
		v_fma_f32 v133, v227, v2, v11
		v_fma_f32 v134, v228, v2, v11
		v_fma_f32 v135, v229, v2, v11
		v_fma_f32 v136, v230, v2, v11
		v_fma_f32 v137, v231, v2, v11
		v_fma_f32 v138, v232, v2, v11
		v_fma_f32 v139, v233, v2, v11
		v_fma_f32 v140, v234, v2, v11
		v_fma_f32 v141, v235, v2, v11
		v_fma_f32 v142, v236, v2, v11
		v_fma_f32 v143, v237, v2, v11
		v_fma_f32 v144, v238, v2, v11
		v_fma_f32 v145, v239, v2, v11
		v_xor_b32_e32 v146, 0x80000000, v3
		v_fma_f32 v147, v160, v2, v146
		v_fma_f32 v148, v161, v2, v146
		v_fma_f32 v149, v162, v2, v146
		v_fma_f32 v150, v163, v2, v146
		v_fma_f32 v151, v164, v2, v146
		v_fma_f32 v152, v165, v2, v146
		v_fma_f32 v153, v166, v2, v146
		v_fma_f32 v154, v167, v2, v146
		v_fma_f32 v155, v168, v2, v146
		v_fma_f32 v156, v169, v2, v146
		v_fma_f32 v157, v170, v2, v146
		v_fma_f32 v158, v171, v2, v146
		v_fma_f32 v159, v172, v2, v146
		v_fma_f32 v160, v173, v2, v146
		v_fma_f32 v161, v174, v2, v146
		v_fma_f32 v162, v175, v2, v146
		v_fma_f32 v163, v192, v2, v146
		v_fma_f32 v164, v193, v2, v146
		v_fma_f32 v165, v194, v2, v146
		v_fma_f32 v166, v195, v2, v146
		v_fma_f32 v167, v196, v2, v146
		v_fma_f32 v168, v197, v2, v146
		v_fma_f32 v169, v198, v2, v146
		v_fma_f32 v170, v199, v2, v146
		v_fma_f32 v171, v200, v2, v146
		v_fma_f32 v172, v201, v2, v146
		v_fma_f32 v173, v202, v2, v146
		v_fma_f32 v174, v203, v2, v146
		v_fma_f32 v175, v204, v2, v146
		v_fma_f32 v176, v205, v2, v146
		v_fma_f32 v177, v206, v2, v146
		v_fma_f32 v178, v207, v2, v146
		v_fma_f32 v179, v208, v2, v146
		v_fma_f32 v180, v209, v2, v146
		v_fma_f32 v181, v210, v2, v146
		v_fma_f32 v182, v211, v2, v146
		v_fma_f32 v183, v212, v2, v146
		v_fma_f32 v184, v213, v2, v146
		v_fma_f32 v185, v214, v2, v146
		v_fma_f32 v186, v215, v2, v146
		v_fma_f32 v187, v216, v2, v146
		v_fma_f32 v188, v217, v2, v146
		v_fma_f32 v189, v218, v2, v146
		v_fma_f32 v190, v219, v2, v146
		v_fma_f32 v191, v220, v2, v146
		v_fma_f32 v192, v221, v2, v146
		v_fma_f32 v193, v222, v2, v146
		v_fma_f32 v194, v223, v2, v146
		v_fma_f32 v195, v240, v2, v146
		v_fma_f32 v196, v241, v2, v146
		v_fma_f32 v197, v242, v2, v146
		v_fma_f32 v198, v243, v2, v146
		v_fma_f32 v199, v244, v2, v146
		v_fma_f32 v200, v245, v2, v146
		v_fma_f32 v201, v246, v2, v146
		v_fma_f32 v202, v247, v2, v146
		v_fma_f32 v203, v248, v2, v146
		v_fma_f32 v204, v249, v2, v146
		v_fma_f32 v205, v250, v2, v146
		v_fma_f32 v206, v251, v2, v146
		v_fma_f32 v207, v252, v2, v146
		v_fma_f32 v208, v253, v2, v146
		v_fma_f32 v209, v254, v2, v146
		v_fma_f32 v210, v255, v2, v146
		v_exp_f32_e32 v13, v13
		v_exp_f32_e32 v15, v15
		v_exp_f32_e32 v16, v16
		v_exp_f32_e32 v18, v18
		v_exp_f32_e32 v20, v20
		v_exp_f32_e32 v23, v23
		v_exp_f32_e32 v24, v24
		v_exp_f32_e32 v25, v25
		v_exp_f32_e32 v26, v26
		v_exp_f32_e32 v27, v27
		v_exp_f32_e32 v28, v28
		v_exp_f32_e32 v29, v29
		v_exp_f32_e32 v30, v30
		v_exp_f32_e32 v31, v31
		v_exp_f32_e32 v112, v112
		v_exp_f32_e32 v113, v113
		v_exp_f32_e32 v114, v114
		v_exp_f32_e32 v115, v115
		v_exp_f32_e32 v116, v116
		v_exp_f32_e32 v117, v117
		v_exp_f32_e32 v118, v118
		v_exp_f32_e32 v119, v119
		v_exp_f32_e32 v120, v120
		v_exp_f32_e32 v121, v121
		v_exp_f32_e32 v122, v122
		v_exp_f32_e32 v123, v123
		v_exp_f32_e32 v124, v124
		v_exp_f32_e32 v125, v125
		v_exp_f32_e32 v126, v126
		v_exp_f32_e32 v127, v127
		v_exp_f32_e32 v128, v128
		v_exp_f32_e32 v129, v129
		v_exp_f32_e32 v96, v96
		v_exp_f32_e32 v97, v97
		v_exp_f32_e32 v98, v98
		v_exp_f32_e32 v99, v99
		v_exp_f32_e32 v100, v100
		v_exp_f32_e32 v101, v101
		v_exp_f32_e32 v102, v102
		v_exp_f32_e32 v103, v103
		v_exp_f32_e32 v104, v104
		v_exp_f32_e32 v105, v105
		v_exp_f32_e32 v106, v106
		v_exp_f32_e32 v107, v107
		v_exp_f32_e32 v108, v108
		v_exp_f32_e32 v109, v109
		v_exp_f32_e32 v110, v110
		v_exp_f32_e32 v111, v111
		v_exp_f32_e32 v130, v130
		v_exp_f32_e32 v131, v131
		v_exp_f32_e32 v132, v132
		v_exp_f32_e32 v133, v133
		v_exp_f32_e32 v134, v134
		v_exp_f32_e32 v135, v135
		v_exp_f32_e32 v136, v136
		v_exp_f32_e32 v137, v137
		v_exp_f32_e32 v138, v138
		v_exp_f32_e32 v139, v139
		v_exp_f32_e32 v140, v140
		v_exp_f32_e32 v141, v141
		v_exp_f32_e32 v142, v142
		v_exp_f32_e32 v143, v143
		v_exp_f32_e32 v144, v144
		v_exp_f32_e32 v145, v145
		v_exp_f32_e32 v149, v149
		v_exp_f32_e32 v150, v150
		v_exp_f32_e32 v151, v151
		v_exp_f32_e32 v152, v152
		v_exp_f32_e32 v153, v153
		v_exp_f32_e32 v154, v154
		v_exp_f32_e32 v155, v155
		v_exp_f32_e32 v156, v156
		v_exp_f32_e32 v157, v157
		v_exp_f32_e32 v158, v158
		v_exp_f32_e32 v159, v159
		v_exp_f32_e32 v160, v160
		v_exp_f32_e32 v161, v161
		v_exp_f32_e32 v162, v162
		v_exp_f32_e32 v163, v163
		v_exp_f32_e32 v164, v164
		v_exp_f32_e32 v165, v165
		v_exp_f32_e32 v166, v166
		v_exp_f32_e32 v167, v167
		v_exp_f32_e32 v168, v168
		v_exp_f32_e32 v169, v169
		v_exp_f32_e32 v170, v170
		v_exp_f32_e32 v171, v171
		v_exp_f32_e32 v172, v172
		v_exp_f32_e32 v173, v173
		v_exp_f32_e32 v174, v174
		v_exp_f32_e32 v175, v175
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
		v_add_f32_e32 v211, v13, v15
		v_add_f32_e32 v212, v96, v97
		v_add_f32_e32 v213, v16, v18
		v_add_f32_e32 v214, v98, v99
		v_add_f32_e32 v215, v20, v23
		v_add_f32_e32 v216, v100, v101
		v_add_f32_e32 v217, v24, v25
		v_add_f32_e32 v218, v102, v103
		v_add_f32_e32 v219, v26, v27
		v_add_f32_e32 v220, v104, v105
		v_add_f32_e32 v221, v28, v29
		v_add_f32_e32 v222, v106, v107
		v_add_f32_e32 v223, v30, v31
		v_add_f32_e32 v224, v108, v109
		v_add_f32_e32 v225, v112, v113
		v_add_f32_e32 v226, v110, v111
		v_add_f32_e32 v227, v114, v115
		v_add_f32_e32 v228, v130, v131
		v_add_f32_e32 v229, v116, v117
		v_add_f32_e32 v230, v132, v133
		v_add_f32_e32 v231, v118, v119
		v_add_f32_e32 v232, v134, v135
		v_add_f32_e32 v233, v120, v121
		v_add_f32_e32 v234, v136, v137
		v_add_f32_e32 v235, v122, v123
		v_add_f32_e32 v236, v138, v139
		v_add_f32_e32 v237, v124, v125
		v_add_f32_e32 v238, v140, v141
		v_add_f32_e32 v239, v126, v127
		v_add_f32_e32 v240, v142, v143
		v_add_f32_e32 v241, v128, v129
		v_add_f32_e32 v242, v144, v145
		v_add_f32_e32 v211, v211, v213
		v_add_f32_e32 v212, v212, v214
		v_add_f32_e32 v213, v215, v217
		v_add_f32_e32 v214, v216, v218
		v_add_f32_e32 v215, v219, v221
		v_add_f32_e32 v216, v220, v222
		v_add_f32_e32 v217, v223, v225
		v_add_f32_e32 v218, v224, v226
		v_add_f32_e32 v219, v227, v229
		v_add_f32_e32 v220, v228, v230
		v_add_f32_e32 v221, v231, v233
		v_add_f32_e32 v222, v232, v234
		v_add_f32_e32 v223, v235, v237
		v_add_f32_e32 v224, v236, v238
		v_add_f32_e32 v225, v239, v241
		v_add_f32_e32 v226, v240, v242
		v_add_f32_e32 v211, v211, v213
		v_add_f32_e32 v212, v212, v214
		v_add_f32_e32 v213, v215, v217
		v_add_f32_e32 v214, v216, v218
		v_add_f32_e32 v215, v219, v221
		v_add_f32_e32 v216, v220, v222
		v_add_f32_e32 v217, v223, v225
		v_add_f32_e32 v218, v224, v226
		v_add_f32_e32 v211, v211, v213
		v_add_f32_e32 v212, v212, v214
		v_add_f32_e32 v213, v215, v217
		v_add_f32_e32 v214, v216, v218
		v_add_f32_e32 v211, v211, v213
		v_add_f32_e32 v212, v212, v214
		v_add_f32_e32 v214, v211, v212
		v_mov_b32_e32 v215, v214
		v_exp_f32_e32 v147, v147
		v_exp_f32_e32 v148, v148
		v_permlane32_swap_b32_e32 v214, v215
		v_add_f32_e32 v211, v147, v148
		v_add_f32_e32 v212, v179, v180
		v_add_f32_e32 v213, v149, v150
		v_add_f32_e32 v216, v181, v182
		v_add_f32_e32 v217, v151, v152
		v_add_f32_e32 v218, v183, v184
		v_add_f32_e32 v219, v153, v154
		v_add_f32_e32 v220, v185, v186
		v_add_f32_e32 v221, v155, v156
		v_add_f32_e32 v222, v187, v188
		v_add_f32_e32 v223, v157, v158
		v_add_f32_e32 v224, v189, v190
		v_add_f32_e32 v225, v159, v160
		v_add_f32_e32 v226, v191, v192
		v_add_f32_e32 v227, v161, v162
		v_add_f32_e32 v228, v193, v194
		v_add_f32_e32 v229, v163, v164
		v_add_f32_e32 v230, v195, v196
		v_add_f32_e32 v231, v165, v166
		v_add_f32_e32 v232, v197, v198
		v_add_f32_e32 v233, v167, v168
		v_add_f32_e32 v234, v199, v200
		v_add_f32_e32 v235, v169, v170
		v_add_f32_e32 v236, v201, v202
		v_add_f32_e32 v237, v171, v172
		v_add_f32_e32 v238, v203, v204
		v_add_f32_e32 v239, v173, v174
		v_add_f32_e32 v240, v205, v206
		v_add_f32_e32 v241, v175, v176
		v_add_f32_e32 v242, v207, v208
		v_add_f32_e32 v243, v177, v178
		v_add_f32_e32 v244, v209, v210
		v_add_f32_e32 v211, v211, v213
		v_add_f32_e32 v212, v212, v216
		v_add_f32_e32 v213, v217, v219
		v_add_f32_e32 v216, v218, v220
		v_add_f32_e32 v217, v221, v223
		v_add_f32_e32 v218, v222, v224
		v_add_f32_e32 v219, v225, v227
		v_add_f32_e32 v220, v226, v228
		v_add_f32_e32 v221, v229, v231
		v_add_f32_e32 v222, v230, v232
		v_add_f32_e32 v223, v233, v235
		v_add_f32_e32 v224, v234, v236
		v_add_f32_e32 v225, v237, v239
		v_add_f32_e32 v226, v238, v240
		v_add_f32_e32 v227, v241, v243
		v_add_f32_e32 v228, v242, v244
		v_add_f32_e32 v211, v211, v213
		v_add_f32_e32 v212, v212, v216
		v_add_f32_e32 v213, v217, v219
		v_add_f32_e32 v216, v218, v220
		v_add_f32_e32 v217, v221, v223
		v_add_f32_e32 v218, v222, v224
		v_add_f32_e32 v219, v225, v227
		v_add_f32_e32 v220, v226, v228
		v_add_f32_e32 v211, v211, v213
		v_add_f32_e32 v212, v212, v216
		v_add_f32_e32 v213, v217, v219
		v_add_f32_e32 v216, v218, v220
		v_add_f32_e32 v211, v211, v213
		v_add_f32_e32 v212, v212, v216
		v_add_f32_e32 v213, v214, v215
		v_add_f32_e32 v214, v211, v212
		v_mov_b32_e32 v215, v214
		v_cvt_pk_bf16_f32 v216, v13, v15
		v_cvt_pk_bf16_f32 v217, v16, v18
		v_permlane32_swap_b32_e32 v214, v215
		v_add_f32_e32 v13, v214, v215
		v_add_f32_e32 v4, v4, v11
		v_add_f32_e32 v5, v5, v146
		v_exp_f32_e32 v4, v4
		v_exp_f32_e32 v5, v5
		v_cvt_pk_bf16_f32 v218, v20, v23
		v_fma_f32 v8, v8, v4, v213
		v_fma_f32 v9, v9, v5, v13
		v_cvt_pk_bf16_f32 v219, v24, v25
		v_cvt_pk_bf16_f32 v212, v26, v27
		v_cvt_pk_bf16_f32 v213, v28, v29
		v_cvt_pk_bf16_f32 v214, v30, v31
		v_cvt_pk_bf16_f32 v215, v112, v113
		v_cvt_pk_bf16_f32 v24, v114, v115
		v_cvt_pk_bf16_f32 v25, v116, v117
		v_cvt_pk_bf16_f32 v26, v118, v119
		v_cvt_pk_bf16_f32 v27, v120, v121
		v_cvt_pk_bf16_f32 v28, v122, v123
		v_cvt_pk_bf16_f32 v29, v124, v125
		v_cvt_pk_bf16_f32 v30, v126, v127
		v_cvt_pk_bf16_f32 v31, v128, v129
		v_cvt_pk_bf16_f32 v112, v96, v97
		v_mul_f32_e32 v32, v32, v4
		v_mul_f32_e32 v33, v33, v4
		v_mul_f32_e32 v34, v34, v4
		v_mul_f32_e32 v35, v35, v4
		v_mul_f32_e32 v36, v36, v4
		v_mul_f32_e32 v37, v37, v4
		v_mul_f32_e32 v38, v38, v4
		v_mul_f32_e32 v39, v39, v4
		v_mul_f32_e32 v40, v40, v4
		v_mul_f32_e32 v41, v41, v4
		v_mul_f32_e32 v42, v42, v4
		v_mul_f32_e32 v43, v43, v4
		v_mul_f32_e32 v44, v44, v4
		v_mul_f32_e32 v45, v45, v4
		v_mul_f32_e32 v46, v46, v4
		v_mul_f32_e32 v47, v47, v4
		v_mul_f32_e32 v48, v48, v4
		v_mul_f32_e32 v49, v49, v4
		v_mul_f32_e32 v50, v50, v4
		v_mul_f32_e32 v51, v51, v4
		v_mul_f32_e32 v52, v52, v4
		v_mul_f32_e32 v53, v53, v4
		v_mul_f32_e32 v54, v54, v4
		v_mul_f32_e32 v55, v55, v4
		v_mul_f32_e32 v56, v56, v4
		v_mul_f32_e32 v57, v57, v4
		v_mul_f32_e32 v58, v58, v4
		v_mul_f32_e32 v59, v59, v4
		v_mul_f32_e32 v60, v60, v4
		v_mul_f32_e32 v61, v61, v4
		v_mul_f32_e32 v62, v62, v4
		v_mul_f32_e32 v63, v63, v4
		v_mul_f32_e32 v64, v64, v5
		v_mul_f32_e32 v65, v65, v5
		v_mul_f32_e32 v66, v66, v5
		v_mul_f32_e32 v67, v67, v5
		v_mul_f32_e32 v68, v68, v5
		v_mul_f32_e32 v69, v69, v5
		v_mul_f32_e32 v70, v70, v5
		v_mul_f32_e32 v71, v71, v5
		v_mul_f32_e32 v72, v72, v5
		v_mul_f32_e32 v73, v73, v5
		v_mul_f32_e32 v74, v74, v5
		v_mul_f32_e32 v75, v75, v5
		v_mul_f32_e32 v76, v76, v5
		v_mul_f32_e32 v77, v77, v5
		v_mul_f32_e32 v78, v78, v5
		v_mul_f32_e32 v79, v79, v5
		v_mul_f32_e32 v80, v80, v5
		v_mul_f32_e32 v81, v81, v5
		v_mul_f32_e32 v82, v82, v5
		v_mul_f32_e32 v83, v83, v5
		v_mul_f32_e32 v84, v84, v5
		v_mul_f32_e32 v85, v85, v5
		v_mul_f32_e32 v86, v86, v5
		v_mul_f32_e32 v87, v87, v5
		v_mul_f32_e32 v88, v88, v5
		v_mul_f32_e32 v89, v89, v5
		v_mul_f32_e32 v90, v90, v5
		v_mul_f32_e32 v91, v91, v5
		v_mul_f32_e32 v92, v92, v5
		v_mul_f32_e32 v93, v93, v5
		v_mul_f32_e32 v94, v94, v5
		v_mul_f32_e32 v95, v95, v5
		v_cvt_pk_bf16_f32 v113, v98, v99
		v_cvt_pk_bf16_f32 v114, v100, v101
		v_cvt_pk_bf16_f32 v115, v102, v103
		v_cvt_pk_bf16_f32 v96, v104, v105
		v_cvt_pk_bf16_f32 v97, v106, v107
		v_cvt_pk_bf16_f32 v98, v108, v109
		v_cvt_pk_bf16_f32 v99, v110, v111
		v_cvt_pk_bf16_f32 v100, v130, v131
		v_cvt_pk_bf16_f32 v101, v132, v133
		v_cvt_pk_bf16_f32 v102, v134, v135
		v_cvt_pk_bf16_f32 v103, v136, v137
		v_cvt_pk_bf16_f32 v104, v138, v139
		v_cvt_pk_bf16_f32 v105, v140, v141
		v_cvt_pk_bf16_f32 v106, v142, v143
		v_cvt_pk_bf16_f32 v107, v144, v145
		v_cvt_pk_bf16_f32 v108, v147, v148
		v_cvt_pk_bf16_f32 v109, v149, v150
		v_cvt_pk_bf16_f32 v110, v151, v152
		v_cvt_pk_bf16_f32 v111, v153, v154
		v_cvt_pk_bf16_f32 v116, v155, v156
		v_cvt_pk_bf16_f32 v117, v157, v158
		v_cvt_pk_bf16_f32 v118, v159, v160
		v_cvt_pk_bf16_f32 v119, v161, v162
		v_cvt_pk_bf16_f32 v120, v163, v164
		v_cvt_pk_bf16_f32 v121, v165, v166
		v_cvt_pk_bf16_f32 v122, v167, v168
		v_cvt_pk_bf16_f32 v123, v169, v170
		v_cvt_pk_bf16_f32 v124, v171, v172
		v_cvt_pk_bf16_f32 v125, v173, v174
		v_cvt_pk_bf16_f32 v126, v175, v176
		v_cvt_pk_bf16_f32 v127, v177, v178
		v_cvt_pk_bf16_f32 v128, v179, v180
		v_cvt_pk_bf16_f32 v129, v181, v182
		v_cvt_pk_bf16_f32 v130, v183, v184
		v_cvt_pk_bf16_f32 v131, v185, v186
		v_cvt_pk_bf16_f32 v132, v187, v188
		v_cvt_pk_bf16_f32 v133, v189, v190
		v_cvt_pk_bf16_f32 v134, v191, v192
		v_cvt_pk_bf16_f32 v135, v193, v194
		v_cvt_pk_bf16_f32 v136, v195, v196
		v_cvt_pk_bf16_f32 v137, v197, v198
		v_cvt_pk_bf16_f32 v138, v199, v200
		v_cvt_pk_bf16_f32 v139, v201, v202
		v_cvt_pk_bf16_f32 v140, v203, v204
		v_cvt_pk_bf16_f32 v141, v205, v206
		v_cvt_pk_bf16_f32 v142, v207, v208
		v_cvt_pk_bf16_f32 v143, v209, v210
		v_permlane32_swap_b32_e32 v216, v218
		v_permlane32_swap_b32_e32 v217, v219
		v_permlane32_swap_b32_e32 v212, v214
		v_permlane32_swap_b32_e32 v213, v215
		v_mfma_f32_32x32x16_bf16 v[32:47], a[84:87], v[216:219], v[32:47]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[48:63], a[116:119], v[216:219], v[48:63]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[32:47], a[88:91], v[212:215], v[32:47]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[48:63], a[120:123], v[212:215], v[48:63]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[32:47], a[92:95], v[24:27], v[32:47]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[48:63], a[124:127], v[24:27], v[48:63]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[32:47], a[96:99], v[28:31], v[32:47]
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_mfma_f32_32x32x16_bf16 v[48:63], a[128:131], v[28:31], v[48:63]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[80:95], a[116:119], v[108:111], v[80:95]
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_mfma_f32_32x32x16_bf16 v[64:79], a[84:87], v[108:111], v[64:79]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[80:95], a[120:123], v[116:119], v[80:95]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[64:79], a[88:91], v[116:119], v[64:79]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[80:95], a[124:127], v[120:123], v[80:95]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[64:79], a[92:95], v[120:123], v[64:79]
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_mfma_f32_32x32x16_bf16 v[80:95], a[128:131], v[124:127], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[96:99], v[124:127], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[100:103], v[112:115], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[132:135], v[112:115], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[132:135], v[128:131], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[100:103], v[128:131], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[104:107], v[96:99], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[136:139], v[96:99], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[136:139], v[132:135], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[104:107], v[132:135], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[108:111], v[100:103], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[140:143], v[100:103], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[140:143], v[136:139], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[108:111], v[136:139], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[112:115], v[104:107], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[144:147], v[104:107], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[140:143], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[112:115], v[140:143], v[64:79]
		v_mov_b32_e32 v4, v1
		v_mov_b32_e32 v5, v3
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
		v_accvgpr_read_b32 v11, a6
		s_nop 0
		v_readfirstlane_b32 s25, v11
		s_nop 1
		v_add_u32_e32 v3, s25, v3
		v_add_u32_e32 v3, s1, v3
		v_xor_b32_e32 v11, 1, v10
		v_accvgpr_write_b32 a14, v11
		v_xor_b32_e32 v11, 2, v10
		v_accvgpr_write_b32 a15, v11
		v_xor_b32_e32 v11, 3, v10
		v_accvgpr_write_b32 a64, v11
		v_xor_b32_e32 v11, 8, v10
		v_accvgpr_write_b32 a65, v11
		v_xor_b32_e32 v11, 9, v10
		v_accvgpr_write_b32 a66, v11
		v_xor_b32_e32 v11, 10, v10
		v_accvgpr_write_b32 a67, v11
		v_xor_b32_e32 v11, 11, v10
		v_accvgpr_write_b32 a68, v11
		v_xor_b32_e32 v11, 16, v10
		v_accvgpr_write_b32 a69, v11
		v_xor_b32_e32 v11, 17, v10
		v_accvgpr_write_b32 a70, v11
		v_xor_b32_e32 v11, 18, v10
		v_accvgpr_write_b32 a71, v11
		v_xor_b32_e32 v11, 19, v10
		v_accvgpr_write_b32 a72, v11
		v_xor_b32_e32 v11, 24, v10
		v_accvgpr_write_b32 a73, v11
		v_xor_b32_e32 v11, 25, v10
		v_accvgpr_write_b32 a74, v11
		v_xor_b32_e32 v11, 26, v10
		v_accvgpr_write_b32 a75, v11
		v_xor_b32_e32 v11, 27, v10
		v_accvgpr_write_b32 a76, v11
		v_xor_b32_e32 v11, 32, v10
		v_accvgpr_write_b32 a77, v11
		v_xor_b32_e32 v11, 33, v10
		v_accvgpr_write_b32 a78, v11
		v_xor_b32_e32 v11, 34, v10
		v_accvgpr_write_b32 a79, v11
		v_xor_b32_e32 v11, 35, v10
		v_accvgpr_write_b32 a80, v11
		v_xor_b32_e32 v11, 40, v10
		v_accvgpr_write_b32 a81, v11
		v_xor_b32_e32 v11, 41, v10
		v_accvgpr_write_b32 a82, v11
		v_xor_b32_e32 v11, 42, v10
		v_accvgpr_write_b32 a83, v11
		v_xor_b32_e32 v11, 43, v10
		v_accvgpr_write_b32 a84, v11
		v_xor_b32_e32 v11, 48, v10
		v_accvgpr_write_b32 a85, v11
		v_xor_b32_e32 v11, 49, v10
		v_accvgpr_write_b32 a86, v11
		v_xor_b32_e32 v11, 50, v10
		v_accvgpr_write_b32 a87, v11
		v_xor_b32_e32 v11, 51, v10
		v_accvgpr_write_b32 a88, v11
		v_xor_b32_e32 v11, 56, v10
		v_accvgpr_write_b32 a89, v11
		v_xor_b32_e32 v11, 57, v10
		v_accvgpr_write_b32 a90, v11
		v_xor_b32_e32 v11, 58, v10
		v_accvgpr_write_b32 a91, v11
		v_xor_b32_e32 v11, 59, v10
		v_accvgpr_write_b32 a92, v11
		v_xor_b32_e32 v11, 64, v10
		v_accvgpr_write_b32 a93, v11
		v_xor_b32_e32 v11, 0x41, v10
		v_accvgpr_write_b32 a94, v11
		v_xor_b32_e32 v11, 0x42, v10
		v_accvgpr_write_b32 a95, v11
		v_xor_b32_e32 v11, 0x43, v10
		v_accvgpr_write_b32 a96, v11
		v_xor_b32_e32 v11, 0x48, v10
		v_accvgpr_write_b32 a97, v11
		v_xor_b32_e32 v11, 0x49, v10
		v_accvgpr_write_b32 a98, v11
		v_xor_b32_e32 v11, 0x4a, v10
		v_accvgpr_write_b32 a99, v11
		v_xor_b32_e32 v11, 0x4b, v10
		v_accvgpr_write_b32 a100, v11
		v_xor_b32_e32 v11, 0x50, v10
		v_accvgpr_write_b32 a101, v11
		v_xor_b32_e32 v11, 0x51, v10
		v_accvgpr_write_b32 a102, v11
		v_xor_b32_e32 v11, 0x52, v10
		v_accvgpr_write_b32 a103, v11
		v_xor_b32_e32 v11, 0x53, v10
		v_accvgpr_write_b32 a104, v11
		v_xor_b32_e32 v11, 0x58, v10
		v_accvgpr_write_b32 a105, v11
		v_xor_b32_e32 v11, 0x59, v10
		v_accvgpr_write_b32 a106, v11
		v_xor_b32_e32 v11, 0x5a, v10
		v_accvgpr_write_b32 a107, v11
		v_xor_b32_e32 v11, 0x5b, v10
		v_accvgpr_write_b32 a108, v11
		v_xor_b32_e32 v11, 0x60, v10
		v_accvgpr_write_b32 a109, v11
		v_xor_b32_e32 v11, 0x61, v10
		v_accvgpr_write_b32 a110, v11
		v_xor_b32_e32 v11, 0x62, v10
		v_accvgpr_write_b32 a111, v11
		v_xor_b32_e32 v11, 0x63, v10
		v_accvgpr_write_b32 a112, v11
		v_xor_b32_e32 v11, 0x68, v10
		v_accvgpr_write_b32 a113, v11
		v_xor_b32_e32 v11, 0x69, v10
		v_accvgpr_write_b32 a114, v11
		v_xor_b32_e32 v11, 0x6a, v10
		v_accvgpr_write_b32 a115, v11
		v_xor_b32_e32 v11, 0x6b, v10
		v_accvgpr_write_b32 a116, v11
		v_xor_b32_e32 v11, 0x70, v10
		v_accvgpr_write_b32 a117, v11
		v_xor_b32_e32 v11, 0x71, v10
		v_accvgpr_write_b32 a118, v11
		v_xor_b32_e32 v11, 0x72, v10
		v_accvgpr_write_b32 a119, v11
		v_xor_b32_e32 v11, 0x73, v10
		v_accvgpr_write_b32 a120, v11
		v_xor_b32_e32 v11, 0x78, v10
		v_accvgpr_write_b32 a121, v11
		v_xor_b32_e32 v11, 0x79, v10
		v_accvgpr_write_b32 a122, v11
		v_xor_b32_e32 v11, 0x7a, v10
		v_accvgpr_write_b32 a123, v11
		v_xor_b32_e32 v11, 0x7b, v10
		v_accvgpr_write_b32 a124, v11
		v_mov_b32_e32 v11, 0xff800000
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
		v_accvgpr_read_b32 v13, a62
		v_add_u32_e32 v13, s25, v13
		ds_read_b128 a[128:131], v13
		ds_read_b128 a[132:135], v13 offset:32
		ds_read_b128 a[136:139], v13 offset:64
		ds_read_b128 a[140:143], v13 offset:96
		ds_read_b128 a[144:147], v13 offset:256
		ds_read_b128 a[148:151], v13 offset:288
		ds_read_b128 a[152:155], v13 offset:320
		ds_read_b128 a[156:159], v13 offset:352
		ds_read_b128 a[160:163], v13 offset:128
		ds_read_b128 a[164:167], v13 offset:160
		ds_read_b128 a[168:171], v13 offset:192
		ds_read_b128 a[172:175], v13 offset:224
		ds_read_b128 v[24:27], v13 offset:384
		ds_read_b128 a[176:179], v13 offset:416
		ds_read_b128 a[180:183], v13 offset:448
		ds_read_b128 a[184:187], v13 offset:480
		s_mul_i32 s25, 0x4400, s38
		v_accvgpr_read_b32 v13, a63
		v_add_u32_e32 v13, s25, v13
		ds_read_b64_tr_b16 a[188:189], v13 offset:33264
		ds_read_b64_tr_b16 a[190:191], v13 offset:37616
		ds_read_b64_tr_b16 a[192:193], v13 offset:33392
		ds_read_b64_tr_b16 a[194:195], v13 offset:37744
		ds_read_b64_tr_b16 a[196:197], v13 offset:33520
		ds_read_b64_tr_b16 a[198:199], v13 offset:37872
		ds_read_b64_tr_b16 a[200:201], v13 offset:33648
		ds_read_b64_tr_b16 a[202:203], v13 offset:38000
		ds_read_b64_tr_b16 a[204:205], v13 offset:33776
		ds_read_b64_tr_b16 a[206:207], v13 offset:38128
		ds_read_b64_tr_b16 a[208:209], v13 offset:33904
		ds_read_b64_tr_b16 a[210:211], v13 offset:38256
		ds_read_b64_tr_b16 a[212:213], v13 offset:34032
		ds_read_b64_tr_b16 a[214:215], v13 offset:38384
		ds_read_b64_tr_b16 a[216:217], v13 offset:34160
		ds_read_b64_tr_b16 a[218:219], v13 offset:38512
		ds_read_b64_tr_b16 a[220:221], v13 offset:33328
		ds_read_b64_tr_b16 a[222:223], v13 offset:37680
		ds_read_b64_tr_b16 a[224:225], v13 offset:33456
		ds_read_b64_tr_b16 a[226:227], v13 offset:37808
		ds_read_b64_tr_b16 a[228:229], v13 offset:33584
		ds_read_b64_tr_b16 a[230:231], v13 offset:37936
		ds_read_b64_tr_b16 a[232:233], v13 offset:33712
		ds_read_b64_tr_b16 a[234:235], v13 offset:38064
		ds_read_b64_tr_b16 a[236:237], v13 offset:33840
		ds_read_b64_tr_b16 a[238:239], v13 offset:38192
		ds_read_b64_tr_b16 a[240:241], v13 offset:33968
		ds_read_b64_tr_b16 a[242:243], v13 offset:38320
		ds_read_b64_tr_b16 a[244:245], v13 offset:34096
		ds_read_b64_tr_b16 a[246:247], v13 offset:38448
		ds_read_b64_tr_b16 a[248:249], v13 offset:34224
		ds_read_b64_tr_b16 a[250:251], v13 offset:38576
		s_cmp_lt_i32 s1, s18
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_2
		v_accvgpr_read_b32 v13, a18
		v_add_u32_e32 v13, s1, v13
		v_cmp_lt_i32_e64 s[48:49], v13, s20
		v_accvgpr_read_b32 v13, a19
		v_add_u32_e32 v13, s1, v13
		v_cmp_lt_i32_e64 s[50:51], v13, s20
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s25, s15, s41
		s_lshl_b32 s25, s25, 1
		s_add_i32 s38, s23, s25
		v_add3_u32 v13, s38, v12, v19
		v_add3_u32 v13, v13, v21, v14
		v_cndmask_b32_e64 v13, v22, v13, s[48:49]
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
		v_accvgpr_read_b32 v15, a54
		v_add_u32_e32 v15, s1, v15
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v15, s20
		s_add_i32 s38, s43, s25
		v_add3_u32 v13, s38, v12, v19
		v_add3_u32 v13, v13, v21, v14
		v_cndmask_b32_e64 v13, v22, v13, s[54:55]
		s_add_u32 s54, s52, 0x1040
		s_addc_u32 s55, s53, 0
		s_add_u32 s56, s54, 0
		s_addc_u32 s57, s55, 0
		s_mov_b32 m0, s56
		v_accvgpr_read_b32 v15, a55
		v_add_u32_e32 v15, s1, v15
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v15, s20
		s_add_i32 s38, s44, s25
		v_add3_u32 v13, s38, v12, v19
		v_add3_u32 v13, v13, v21, v14
		v_cndmask_b32_e64 v13, v22, v13, s[54:55]
		s_add_u32 s54, s52, 0x2080
		s_addc_u32 s55, s53, 0
		s_add_u32 s56, s54, 0
		s_addc_u32 s57, s55, 0
		s_mov_b32 m0, s56
		v_accvgpr_read_b32 v15, a56
		v_add_u32_e32 v15, s1, v15
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v15, s20
		s_add_i32 s25, s36, s25
		v_add3_u32 v13, s25, v12, v19
		v_add3_u32 v13, v13, v21, v14
		v_cndmask_b32_e64 v13, v22, v13, s[54:55]
		s_add_u32 s52, s52, 0x30c0
		s_addc_u32 s53, s53, 0
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		v_accvgpr_read_b32 v15, a57
		v_add_u32_e32 v15, s1, v15
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		s_mul_i32 s25, s17, s41
		s_lshl_b32 s25, s25, 1
		s_add_i32 s38, s37, s25
		v_add3_u32 v13, s38, v6, v7
		v_add3_u32 v13, v13, v17, v14
		v_cndmask_b32_e64 v13, v22, v13, s[50:51]
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
		v_accvgpr_read_b32 v16, a58
		v_add_u32_e32 v16, s1, v16
		buffer_load_dwordx4 v13, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[48:49], v15, s20
		s_add_i32 s38, s39, s25
		v_add3_u32 v13, s38, v6, v7
		v_add3_u32 v13, v13, v17, v14
		v_cndmask_b32_e64 v13, v22, v13, s[48:49]
		s_add_u32 s48, s46, 0x92f0
		s_addc_u32 s49, s47, 0
		s_add_u32 s50, s48, 0
		s_addc_u32 s51, s49, 0
		s_mov_b32 m0, s50
		v_accvgpr_read_b32 v15, a59
		v_add_u32_e32 v15, s1, v15
		buffer_load_dwordx4 v13, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[48:49], v16, s20
		s_add_i32 s38, s45, s25
		v_add3_u32 v13, s38, v6, v7
		v_add3_u32 v13, v13, v17, v14
		s_add_u32 s50, s46, 0xa3f0
		s_addc_u32 s51, s47, 0
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		v_cndmask_b32_e64 v13, v22, v13, s[48:49]
		buffer_load_dwordx4 v13, s[32:35], 0 offen lds
		s_add_i32 s25, s24, s25
		v_add3_u32 v13, s25, v6, v7
		v_cmp_lt_i32_e64 vcc, v15, s20
		v_add3_u32 v13, v13, v17, v14
		s_add_u32 s46, s46, 0xb4f0
		s_addc_u32 s47, s47, 0
		v_cndmask_b32_e32 v13, v22, v13, vcc
		s_add_u32 s48, s46, 0
		s_addc_u32 s49, s47, 0
		s_mov_b32 m0, s48
		s_nop 0
		buffer_load_dwordx4 v13, s[32:35], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_2
.L_attn_fwd_persistent.if_else_2:
.L_attn_fwd_persistent.if_end_2:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[96:111], a[128:131], a[20:23], 0
		s_cmp_lt_i32 s1, s21
		v_mfma_f32_32x32x16_bf16 v[112:127], a[144:147], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[128:143], a[160:163], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[144:159], v[24:27], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[24:27], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[176:191], a[128:131], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[192:207], a[144:147], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[208:223], a[160:163], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[96:111], a[132:135], a[24:27], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[148:151], a[24:27], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[164:167], a[24:27], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[176:179], a[24:27], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[176:179], a[40:43], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[132:135], a[40:43], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[148:151], a[40:43], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[164:167], a[40:43], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[136:139], a[28:31], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[152:155], a[28:31], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[168:171], a[28:31], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[180:183], a[28:31], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[44:47], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[136:139], a[44:47], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[152:155], a[44:47], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[168:171], a[44:47], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[140:143], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[156:159], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[172:175], a[32:35], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[184:187], a[32:35], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[184:187], a[48:51], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[140:143], a[48:51], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[156:159], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[172:175], a[48:51], v[208:223]
		v_add_u32_e32 v13, s41, v10
		v_accvgpr_read_b32 v15, a14
		v_add_u32_e32 v15, s41, v15
		v_accvgpr_read_b32 v16, a15
		v_add_u32_e32 v16, s41, v16
		v_accvgpr_read_b32 v18, a64
		v_add_u32_e32 v18, s41, v18
		v_accvgpr_read_b32 v20, a67
		v_add_u32_e32 v20, s41, v20
		v_accvgpr_read_b32 v23, a68
		v_add_u32_e32 v23, s41, v23
		v_accvgpr_read_b32 v24, a71
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_read_b32 v25, a72
		v_add_u32_e32 v25, s41, v25
		v_accvgpr_read_b32 v26, a75
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_read_b32 v27, a76
		v_add_u32_e32 v27, s41, v27
		v_accvgpr_read_b32 v28, a79
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_read_b32 v29, a80
		v_add_u32_e32 v29, s41, v29
		v_accvgpr_read_b32 v30, a83
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_read_b32 v31, a84
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_read_b32 v224, a87
		v_add_u32_e32 v224, s41, v224
		v_accvgpr_read_b32 v225, a88
		v_add_u32_e32 v225, s41, v225
		v_accvgpr_read_b32 v226, a91
		v_add_u32_e32 v226, s41, v226
		v_accvgpr_read_b32 v227, a92
		v_add_u32_e32 v227, s41, v227
		v_accvgpr_read_b32 v228, a95
		v_add_u32_e32 v228, s41, v228
		v_accvgpr_read_b32 v229, a96
		v_add_u32_e32 v229, s41, v229
		v_accvgpr_read_b32 v230, a99
		v_add_u32_e32 v230, s41, v230
		v_accvgpr_read_b32 v231, a100
		v_add_u32_e32 v231, s41, v231
		v_accvgpr_read_b32 v232, a103
		v_add_u32_e32 v232, s41, v232
		v_accvgpr_read_b32 v233, a104
		v_add_u32_e32 v233, s41, v233
		v_accvgpr_read_b32 v234, a107
		v_add_u32_e32 v234, s41, v234
		v_accvgpr_read_b32 v235, a108
		v_add_u32_e32 v235, s41, v235
		v_accvgpr_read_b32 v236, a111
		v_add_u32_e32 v236, s41, v236
		v_accvgpr_read_b32 v237, a112
		v_add_u32_e32 v237, s41, v237
		v_accvgpr_read_b32 v238, a115
		v_add_u32_e32 v238, s41, v238
		v_accvgpr_read_b32 v239, a116
		v_add_u32_e32 v239, s41, v239
		v_accvgpr_read_b32 v240, a119
		v_add_u32_e32 v240, s41, v240
		v_accvgpr_read_b32 v241, a120
		v_add_u32_e32 v241, s41, v241
		v_accvgpr_read_b32 v242, a123
		v_add_u32_e32 v242, s41, v242
		v_accvgpr_write_b32 a125, v242
		v_accvgpr_read_b32 v242, a124
		v_add_u32_e32 v242, s41, v242
		v_accvgpr_write_b32 a126, v242
		v_cmp_ge_i32_e64 s[46:47], v1, v13
		v_cmp_ge_i32_e64 s[48:49], v1, v15
		v_cmp_ge_i32_e64 s[50:51], v1, v16
		v_cmp_ge_i32_e64 vcc, v1, v18
		v_accvgpr_read_b32 v242, a65
		v_add_u32_e32 v242, s41, v242
		v_accvgpr_read_b32 v243, a66
		v_add_u32_e32 v243, s41, v243
		v_cndmask_b32_e32 v99, v11, v99, vcc
		v_accvgpr_write_b32 a127, v99
		v_cmp_ge_i32_e64 s[52:53], v1, v242
		v_cmp_ge_i32_e64 s[54:55], v1, v243
		v_cmp_ge_i32_e64 s[56:57], v1, v20
		v_cmp_ge_i32_e64 vcc, v1, v23
		v_accvgpr_read_b32 v99, a69
		v_add_u32_e32 v99, s41, v99
		v_accvgpr_read_b32 v244, a70
		v_add_u32_e32 v244, s41, v244
		v_cndmask_b32_e32 v103, v11, v103, vcc
		v_accvgpr_write_b32 a128, v103
		v_cmp_ge_i32_e64 s[58:59], v1, v99
		v_cmp_ge_i32_e64 s[60:61], v1, v244
		v_cmp_ge_i32_e64 s[62:63], v1, v24
		v_cmp_ge_i32_e64 vcc, v1, v25
		v_accvgpr_read_b32 v103, a73
		v_add_u32_e32 v103, s41, v103
		v_accvgpr_read_b32 v245, a74
		v_add_u32_e32 v245, s41, v245
		v_cndmask_b32_e32 v107, v11, v107, vcc
		v_accvgpr_write_b32 a129, v107
		v_cmp_ge_i32_e64 s[64:65], v1, v103
		v_cmp_ge_i32_e64 s[66:67], v1, v245
		v_cmp_ge_i32_e64 s[68:69], v1, v26
		v_cmp_ge_i32_e64 vcc, v1, v27
		v_accvgpr_read_b32 v107, a77
		v_add_u32_e32 v107, s41, v107
		v_accvgpr_read_b32 v246, a78
		v_add_u32_e32 v246, s41, v246
		v_cndmask_b32_e32 v111, v11, v111, vcc
		v_accvgpr_write_b32 a130, v111
		v_cmp_ge_i32_e64 s[70:71], v1, v107
		v_cmp_ge_i32_e64 s[72:73], v1, v246
		v_cmp_ge_i32_e64 s[74:75], v1, v28
		v_cmp_ge_i32_e64 vcc, v1, v29
		v_accvgpr_read_b32 v111, a81
		v_add_u32_e32 v111, s41, v111
		v_accvgpr_read_b32 v247, a82
		v_add_u32_e32 v247, s41, v247
		v_cndmask_b32_e32 v115, v11, v115, vcc
		v_accvgpr_write_b32 a131, v115
		v_cmp_ge_i32_e64 s[76:77], v1, v111
		v_cmp_ge_i32_e64 s[78:79], v1, v247
		v_cmp_ge_i32_e64 s[80:81], v1, v30
		v_cmp_ge_i32_e64 vcc, v1, v31
		v_accvgpr_read_b32 v115, a85
		v_add_u32_e32 v115, s41, v115
		v_accvgpr_read_b32 v248, a86
		v_add_u32_e32 v248, s41, v248
		v_cndmask_b32_e32 v119, v11, v119, vcc
		v_accvgpr_write_b32 a132, v119
		v_cmp_ge_i32_e64 s[82:83], v1, v115
		v_cmp_ge_i32_e64 s[84:85], v1, v248
		v_cmp_ge_i32_e64 vcc, v1, v225
		v_accvgpr_read_b32 v119, a89
		v_add_u32_e32 v119, s41, v119
		v_accvgpr_read_b32 v249, a90
		v_add_u32_e32 v249, s41, v249
		v_cndmask_b32_e32 v123, v11, v123, vcc
		v_accvgpr_write_b32 a133, v123
		v_cmp_ge_i32_e64 vcc, v1, v227
		v_accvgpr_read_b32 v123, a93
		v_add_u32_e32 v123, s41, v123
		v_accvgpr_read_b32 v250, a94
		v_add_u32_e32 v250, s41, v250
		v_cndmask_b32_e32 v127, v11, v127, vcc
		v_accvgpr_write_b32 a134, v127
		v_cmp_ge_i32_e64 vcc, v1, v229
		v_accvgpr_read_b32 v127, a97
		v_add_u32_e32 v127, s41, v127
		v_accvgpr_read_b32 v251, a98
		v_add_u32_e32 v251, s41, v251
		v_cndmask_b32_e32 v131, v11, v131, vcc
		v_accvgpr_write_b32 a135, v131
		v_cmp_ge_i32_e64 vcc, v1, v231
		v_accvgpr_read_b32 v131, a101
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_read_b32 v252, a102
		v_add_u32_e32 v252, s41, v252
		v_cndmask_b32_e32 v135, v11, v135, vcc
		v_accvgpr_write_b32 a136, v135
		v_cmp_ge_i32_e64 vcc, v1, v233
		v_accvgpr_read_b32 v135, a105
		v_add_u32_e32 v135, s41, v135
		v_accvgpr_read_b32 v253, a106
		v_add_u32_e32 v253, s41, v253
		v_cndmask_b32_e32 v139, v11, v139, vcc
		v_accvgpr_write_b32 a137, v139
		v_cmp_ge_i32_e64 vcc, v1, v235
		v_cmp_ge_i32_e64 s[86:87], v1, v224
		v_cndmask_b32_e64 v96, v11, v96, s[46:47]
		v_accvgpr_write_b32 a138, v96
		v_cmp_ge_i32_e64 s[46:47], v1, v119
		v_cmp_ge_i32_e64 s[88:89], v1, v249
		v_cmp_ge_i32_e64 s[90:91], v1, v226
		v_cmp_ge_i32_e64 s[92:93], v1, v123
		s_nop 1
		v_mov_b32_e32 v254, s92
		v_mov_b32_e32 v255, s93
		v_accvgpr_write_b32 a140, v254
		v_accvgpr_write_b32 a141, v255
		v_cmp_ge_i32_e64 s[92:93], v1, v250
		s_nop 1
		v_mov_b32_e32 v254, s92
		v_mov_b32_e32 v255, s93
		v_accvgpr_write_b32 a142, v254
		v_accvgpr_write_b32 a143, v255
		v_cmp_ge_i32_e64 s[92:93], v1, v228
		s_nop 1
		v_mov_b32_e32 v254, s92
		v_mov_b32_e32 v255, s93
		v_accvgpr_write_b32 a144, v254
		v_accvgpr_write_b32 a145, v255
		v_cmp_ge_i32_e64 s[92:93], v1, v127
		s_nop 1
		v_mov_b32_e32 v254, s92
		v_mov_b32_e32 v255, s93
		v_accvgpr_write_b32 a146, v254
		v_accvgpr_write_b32 a147, v255
		v_cmp_ge_i32_e64 s[92:93], v1, v251
		s_nop 1
		v_mov_b32_e32 v254, s92
		v_mov_b32_e32 v255, s93
		v_accvgpr_write_b32 a148, v254
		v_accvgpr_write_b32 a149, v255
		v_cmp_ge_i32_e64 s[92:93], v1, v230
		s_nop 1
		v_mov_b32_e32 v254, s92
		v_mov_b32_e32 v255, s93
		v_accvgpr_write_b32 a150, v254
		v_accvgpr_write_b32 a151, v255
		v_cmp_ge_i32_e64 s[92:93], v1, v131
		s_nop 1
		v_mov_b32_e32 v254, s92
		v_mov_b32_e32 v255, s93
		v_accvgpr_write_b32 a152, v254
		v_accvgpr_write_b32 a153, v255
		v_cmp_ge_i32_e64 s[92:93], v1, v252
		s_nop 1
		v_mov_b32_e32 v254, s92
		v_mov_b32_e32 v255, s93
		v_accvgpr_write_b32 a154, v254
		v_accvgpr_write_b32 a155, v255
		v_cmp_ge_i32_e64 s[92:93], v1, v232
		s_nop 1
		v_mov_b32_e32 v254, s92
		v_mov_b32_e32 v255, s93
		v_accvgpr_write_b32 a156, v254
		v_accvgpr_write_b32 a157, v255
		v_cmp_ge_i32_e64 s[92:93], v1, v135
		v_cmp_ge_i32_e64 s[94:95], v1, v253
		v_cmp_ge_i32_e64 s[96:97], v1, v234
		v_cndmask_b32_e32 v96, v11, v143, vcc
		v_cndmask_b32_e64 v139, v11, v141, s[94:95]
		v_cndmask_b32_e64 v141, v11, v142, s[96:97]
		v_accvgpr_read_b32 v142, a109
		v_add_u32_e32 v142, s41, v142
		v_accvgpr_read_b32 v143, a110
		v_add_u32_e32 v143, s41, v143
		v_cmp_ge_i32_e64 s[94:95], v1, v142
		v_cmp_ge_i32_e64 s[96:97], v1, v143
		v_cmp_ge_i32_e64 s[98:99], v1, v236
		v_cndmask_b32_e64 v144, v11, v144, s[94:95]
		v_cndmask_b32_e64 v145, v11, v145, s[96:97]
		v_cndmask_b32_e64 v146, v11, v146, s[98:99]
		v_cmp_ge_i32_e64 vcc, v1, v237
		v_accvgpr_read_b32 v254, a113
		v_add_u32_e32 v254, s41, v254
		v_accvgpr_read_b32 v255, a114
		v_add_u32_e32 v255, s41, v255
		v_cndmask_b32_e32 v147, v11, v147, vcc
		v_cmp_ge_i32_e64 s[94:95], v1, v254
		v_cmp_ge_i32_e64 s[96:97], v1, v255
		v_cmp_ge_i32_e64 s[98:99], v1, v238
		v_cndmask_b32_e64 v148, v11, v148, s[94:95]
		v_cndmask_b32_e64 v149, v11, v149, s[96:97]
		v_accvgpr_write_b32 a139, v149
		v_cndmask_b32_e64 v149, v11, v150, s[98:99]
		v_accvgpr_write_b32 a158, v149
		v_cmp_ge_i32_e64 vcc, v1, v239
		v_accvgpr_read_b32 v149, a117
		v_add_u32_e32 v149, s41, v149
		v_accvgpr_read_b32 v150, a118
		v_add_u32_e32 v150, s41, v150
		v_cndmask_b32_e32 v151, v11, v151, vcc
		v_cmp_ge_i32_e64 s[94:95], v1, v149
		v_cmp_ge_i32_e64 s[96:97], v1, v150
		v_cmp_ge_i32_e64 s[98:99], v1, v240
		v_cndmask_b32_e64 v152, v11, v152, s[94:95]
		v_cndmask_b32_e64 v153, v11, v153, s[96:97]
		v_accvgpr_write_b32 a159, v153
		v_cndmask_b32_e64 v153, v11, v154, s[98:99]
		v_accvgpr_write_b32 a160, v153
		v_cmp_ge_i32_e64 vcc, v1, v241
		v_accvgpr_read_b32 v153, a121
		v_add_u32_e32 v153, s41, v153
		v_accvgpr_read_b32 v154, a122
		v_add_u32_e32 v154, s41, v154
		v_cndmask_b32_e32 v155, v11, v155, vcc
		v_accvgpr_write_b32 a161, v155
		v_cmp_ge_i32_e64 s[94:95], v1, v153
		v_cmp_ge_i32_e64 s[96:97], v1, v154
		v_accvgpr_read_b32 v155, a125
		v_cmp_ge_i32_e64 s[98:99], v1, v155
		v_cndmask_b32_e64 v155, v11, v156, s[94:95]
		v_cndmask_b32_e64 v156, v11, v157, s[96:97]
		v_cndmask_b32_e64 v157, v11, v158, s[98:99]
		v_accvgpr_write_b32 a162, v157
		v_cndmask_b32_e64 v97, v11, v97, s[48:49]
		v_accvgpr_read_b32 v157, a126
		v_cmp_ge_i32_e64 vcc, v1, v157
		v_max3_f32 v157, v144, v145, v146
		v_accvgpr_write_b32 a163, v157
		v_accvgpr_read_b32 v157, a158
		v_accvgpr_read_b32 v158, a139
		v_max3_f32 v157, v148, v158, v157
		v_cndmask_b32_e32 v158, v11, v159, vcc
		v_cmp_ge_i32_e64 s[48:49], v3, v13
		v_cmp_ge_i32_e64 s[94:95], v3, v15
		v_cmp_ge_i32_e64 s[96:97], v3, v16
		v_accvgpr_read_b32 v13, a160
		v_accvgpr_read_b32 v15, a159
		v_max3_f32 v13, v152, v15, v13
		v_accvgpr_read_b32 v15, a162
		v_max3_f32 v15, v155, v156, v15
		v_cndmask_b32_e64 v16, v11, v178, s[96:97]
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_cndmask_b32_e64 v18, v11, v98, s[50:51]
		v_cndmask_b32_e64 v98, v11, v100, s[52:53]
		v_cndmask_b32_e32 v100, v11, v179, vcc
		v_cmp_ge_i32_e64 s[50:51], v3, v242
		v_cmp_ge_i32_e64 s[52:53], v3, v243
		v_cmp_ge_i32_e64 s[96:97], v3, v20
		v_cndmask_b32_e64 v20, v11, v180, s[50:51]
		v_cndmask_b32_e64 v159, v11, v181, s[52:53]
		v_cndmask_b32_e64 v178, v11, v182, s[96:97]
		v_cmp_ge_i32_e64 vcc, v3, v23
		v_cndmask_b32_e64 v23, v11, v101, s[54:55]
		v_cndmask_b32_e64 v101, v11, v102, s[56:57]
		v_cndmask_b32_e64 v102, v11, v104, s[58:59]
		v_cndmask_b32_e32 v104, v11, v183, vcc
		v_cmp_ge_i32_e64 s[50:51], v3, v99
		v_cmp_ge_i32_e64 s[52:53], v3, v244
		v_cmp_ge_i32_e64 s[54:55], v3, v24
		v_cndmask_b32_e64 v24, v11, v184, s[50:51]
		v_cndmask_b32_e64 v99, v11, v185, s[52:53]
		v_cndmask_b32_e64 v179, v11, v186, s[54:55]
		v_cmp_ge_i32_e64 vcc, v3, v25
		v_cndmask_b32_e64 v25, v11, v105, s[60:61]
		v_accvgpr_read_b32 v105, a138
		v_max3_f32 v105, v105, v97, v18
		v_cndmask_b32_e32 v180, v11, v187, vcc
		v_cmp_ge_i32_e64 s[50:51], v3, v103
		v_cmp_ge_i32_e64 s[52:53], v3, v245
		v_cmp_ge_i32_e64 s[54:55], v3, v26
		v_cndmask_b32_e64 v26, v11, v188, s[50:51]
		v_cndmask_b32_e64 v103, v11, v189, s[52:53]
		v_cndmask_b32_e64 v181, v11, v190, s[54:55]
		v_cmp_ge_i32_e64 vcc, v3, v27
		v_cndmask_b32_e64 v27, v11, v106, s[62:63]
		v_cndmask_b32_e64 v106, v11, v108, s[64:65]
		v_cndmask_b32_e32 v108, v11, v191, vcc
		v_cmp_ge_i32_e64 s[50:51], v3, v107
		v_cmp_ge_i32_e64 s[52:53], v3, v246
		v_cmp_ge_i32_e64 s[54:55], v3, v28
		v_cndmask_b32_e64 v28, v11, v192, s[50:51]
		v_cndmask_b32_e64 v107, v11, v193, s[52:53]
		v_cndmask_b32_e64 v182, v11, v194, s[54:55]
		v_cmp_ge_i32_e64 vcc, v3, v29
		v_cndmask_b32_e64 v29, v11, v109, s[66:67]
		v_cndmask_b32_e64 v109, v11, v110, s[68:69]
		v_cndmask_b32_e64 v110, v11, v112, s[70:71]
		v_cndmask_b32_e32 v112, v11, v195, vcc
		v_cmp_ge_i32_e64 s[50:51], v3, v111
		v_cmp_ge_i32_e64 s[52:53], v3, v247
		v_cmp_ge_i32_e64 s[54:55], v3, v30
		v_cndmask_b32_e64 v30, v11, v196, s[50:51]
		v_cndmask_b32_e64 v111, v11, v197, s[52:53]
		v_cndmask_b32_e64 v183, v11, v198, s[54:55]
		v_cmp_ge_i32_e64 vcc, v3, v31
		v_cndmask_b32_e64 v31, v11, v113, s[72:73]
		v_max3_f32 v113, v98, v23, v101
		v_cndmask_b32_e32 v184, v11, v199, vcc
		v_cmp_ge_i32_e64 s[50:51], v3, v115
		v_cmp_ge_i32_e64 s[52:53], v3, v248
		v_cmp_ge_i32_e64 s[54:55], v3, v224
		v_cndmask_b32_e64 v115, v11, v200, s[50:51]
		v_cndmask_b32_e64 v185, v11, v201, s[52:53]
		v_cndmask_b32_e64 v186, v11, v202, s[54:55]
		v_cmp_ge_i32_e64 vcc, v3, v225
		v_cndmask_b32_e64 v114, v11, v114, s[74:75]
		v_cndmask_b32_e64 v116, v11, v116, s[76:77]
		v_cndmask_b32_e32 v187, v11, v203, vcc
		v_cmp_ge_i32_e64 vcc, v3, v227
		v_cmp_ge_i32_e64 s[50:51], v3, v119
		v_cmp_ge_i32_e64 s[52:53], v3, v249
		v_cmp_ge_i32_e64 s[54:55], v3, v226
		v_cndmask_b32_e64 v119, v11, v204, s[50:51]
		v_cndmask_b32_e64 v188, v11, v205, s[52:53]
		v_cndmask_b32_e64 v189, v11, v206, s[54:55]
		v_cndmask_b32_e64 v117, v11, v117, s[78:79]
		v_cndmask_b32_e64 v118, v11, v118, s[80:81]
		v_cndmask_b32_e32 v190, v11, v207, vcc
		v_cmp_ge_i32_e64 s[50:51], v3, v123
		v_cmp_ge_i32_e64 s[52:53], v3, v250
		v_cmp_ge_i32_e64 vcc, v3, v229
		v_cmp_ge_i32_e64 s[54:55], v3, v228
		v_cndmask_b32_e64 v123, v11, v208, s[50:51]
		v_cndmask_b32_e64 v191, v11, v209, s[52:53]
		v_cndmask_b32_e64 v192, v11, v210, s[54:55]
		v_cndmask_b32_e64 v120, v11, v120, s[82:83]
		v_cndmask_b32_e64 v121, v11, v121, s[84:85]
		v_cndmask_b32_e32 v193, v11, v211, vcc
		v_cmp_ge_i32_e64 s[50:51], v3, v127
		v_cmp_ge_i32_e64 s[52:53], v3, v251
		v_cmp_ge_i32_e64 s[54:55], v3, v230
		v_cndmask_b32_e64 v127, v11, v212, s[50:51]
		v_cndmask_b32_e64 v194, v11, v213, s[52:53]
		v_cndmask_b32_e64 v195, v11, v214, s[54:55]
		v_cmp_ge_i32_e64 vcc, v3, v231
		v_cndmask_b32_e64 v122, v11, v122, s[86:87]
		v_cndmask_b32_e64 v124, v11, v124, s[46:47]
		v_cndmask_b32_e32 v196, v11, v215, vcc
		v_cmp_ge_i32_e64 s[46:47], v3, v131
		v_cmp_ge_i32_e64 s[50:51], v3, v252
		v_cmp_ge_i32_e64 s[52:53], v3, v232
		v_cndmask_b32_e64 v131, v11, v216, s[46:47]
		v_cndmask_b32_e64 v197, v11, v217, s[50:51]
		v_cndmask_b32_e64 v198, v11, v218, s[52:53]
		v_cmp_ge_i32_e64 vcc, v3, v233
		v_cndmask_b32_e64 v125, v11, v125, s[88:89]
		v_cndmask_b32_e64 v126, v11, v126, s[90:91]
		v_cndmask_b32_e32 v199, v11, v219, vcc
		v_cmp_ge_i32_e64 s[46:47], v3, v135
		v_cmp_ge_i32_e64 s[50:51], v3, v253
		v_cmp_ge_i32_e64 s[52:53], v3, v234
		v_cndmask_b32_e64 v135, v11, v220, s[46:47]
		v_cndmask_b32_e64 v200, v11, v221, s[50:51]
		v_cndmask_b32_e64 v201, v11, v222, s[52:53]
		v_cmp_ge_i32_e64 vcc, v3, v235
		v_accvgpr_read_b32 v202, a140
		s_nop 0
		v_readfirstlane_b32 s46, v202
		v_accvgpr_read_b32 v202, a141
		s_nop 0
		v_readfirstlane_b32 s47, v202
		s_nop 1
		v_cndmask_b32_e64 v128, v11, v128, s[46:47]
		v_accvgpr_read_b32 v202, a142
		s_nop 0
		v_readfirstlane_b32 s46, v202
		v_accvgpr_read_b32 v202, a143
		s_nop 0
		v_readfirstlane_b32 s47, v202
		s_nop 1
		v_cndmask_b32_e64 v129, v11, v129, s[46:47]
		v_cndmask_b32_e32 v202, v11, v223, vcc
		v_cmp_ge_i32_e64 s[46:47], v3, v142
		v_cmp_ge_i32_e64 s[50:51], v3, v143
		v_cmp_ge_i32_e64 s[52:53], v3, v236
		v_cndmask_b32_e64 v142, v11, v160, s[46:47]
		v_cndmask_b32_e64 v143, v11, v161, s[50:51]
		v_cndmask_b32_e64 v160, v11, v162, s[52:53]
		v_cmp_ge_i32_e64 vcc, v3, v237
		v_accvgpr_read_b32 v161, a144
		s_nop 0
		v_readfirstlane_b32 s46, v161
		v_accvgpr_read_b32 v161, a145
		s_nop 0
		v_readfirstlane_b32 s47, v161
		s_nop 1
		v_cndmask_b32_e64 v130, v11, v130, s[46:47]
		v_accvgpr_read_b32 v161, a146
		s_nop 0
		v_readfirstlane_b32 s46, v161
		v_accvgpr_read_b32 v161, a147
		s_nop 0
		v_readfirstlane_b32 s47, v161
		s_nop 1
		v_cndmask_b32_e64 v132, v11, v132, s[46:47]
		v_cndmask_b32_e32 v161, v11, v163, vcc
		v_cmp_ge_i32_e64 s[46:47], v3, v254
		v_cmp_ge_i32_e64 s[50:51], v3, v255
		v_cmp_ge_i32_e64 s[52:53], v3, v238
		v_cndmask_b32_e64 v162, v11, v164, s[46:47]
		v_cndmask_b32_e64 v163, v11, v165, s[50:51]
		v_cndmask_b32_e64 v164, v11, v166, s[52:53]
		v_cmp_ge_i32_e64 vcc, v3, v239
		v_accvgpr_read_b32 v165, a148
		s_nop 0
		v_readfirstlane_b32 s46, v165
		v_accvgpr_read_b32 v165, a149
		s_nop 0
		v_readfirstlane_b32 s47, v165
		s_nop 1
		v_cndmask_b32_e64 v133, v11, v133, s[46:47]
		v_accvgpr_read_b32 v165, a150
		s_nop 0
		v_readfirstlane_b32 s46, v165
		v_accvgpr_read_b32 v165, a151
		s_nop 0
		v_readfirstlane_b32 s47, v165
		s_nop 1
		v_cndmask_b32_e64 v134, v11, v134, s[46:47]
		v_cndmask_b32_e32 v165, v11, v167, vcc
		v_cmp_ge_i32_e64 s[46:47], v3, v149
		v_cmp_ge_i32_e64 s[50:51], v3, v150
		v_cmp_ge_i32_e64 s[52:53], v3, v240
		v_cndmask_b32_e64 v149, v11, v168, s[46:47]
		v_cndmask_b32_e64 v150, v11, v169, s[50:51]
		v_cndmask_b32_e64 v166, v11, v170, s[52:53]
		v_cmp_ge_i32_e64 vcc, v3, v241
		v_accvgpr_read_b32 v167, a152
		s_nop 0
		v_readfirstlane_b32 s46, v167
		v_accvgpr_read_b32 v167, a153
		s_nop 0
		v_readfirstlane_b32 s47, v167
		s_nop 1
		v_cndmask_b32_e64 v136, v11, v136, s[46:47]
		v_accvgpr_read_b32 v167, a154
		s_nop 0
		v_readfirstlane_b32 s46, v167
		v_accvgpr_read_b32 v167, a155
		s_nop 0
		v_readfirstlane_b32 s47, v167
		s_nop 1
		v_cndmask_b32_e64 v137, v11, v137, s[46:47]
		v_cndmask_b32_e32 v167, v11, v171, vcc
		v_cmp_ge_i32_e64 s[46:47], v3, v153
		v_cmp_ge_i32_e64 s[50:51], v3, v154
		v_accvgpr_read_b32 v153, a125
		v_cmp_ge_i32_e64 s[52:53], v3, v153
		v_cndmask_b32_e64 v153, v11, v172, s[46:47]
		v_cndmask_b32_e64 v154, v11, v173, s[50:51]
		v_cndmask_b32_e64 v168, v11, v174, s[52:53]
		v_accvgpr_read_b32 v169, a126
		v_cmp_ge_i32_e64 vcc, v3, v169
		v_accvgpr_read_b32 v169, a156
		s_nop 0
		v_readfirstlane_b32 s46, v169
		v_accvgpr_read_b32 v169, a157
		s_nop 0
		v_readfirstlane_b32 s47, v169
		s_nop 1
		v_cndmask_b32_e64 v138, v11, v138, s[46:47]
		v_cndmask_b32_e64 v140, v11, v140, s[92:93]
		v_cndmask_b32_e32 v169, v11, v175, vcc
		v_max3_f32 v170, v102, v25, v27
		v_max3_f32 v171, v106, v29, v109
		v_max3_f32 v172, v110, v31, v114
		v_max3_f32 v173, v116, v117, v118
		v_max3_f32 v174, v120, v121, v122
		v_max3_f32 v175, v124, v125, v126
		v_max3_f32 v203, v128, v129, v130
		v_max3_f32 v204, v132, v133, v134
		v_max3_f32 v205, v136, v137, v138
		v_max3_f32 v206, v140, v139, v141
		v_accvgpr_read_b32 v207, a127
		v_max3_f32 v105, v105, v207, v113
		v_accvgpr_read_b32 v113, a129
		v_max3_f32 v113, v170, v113, v171
		v_accvgpr_read_b32 v170, a131
		v_max3_f32 v170, v172, v170, v173
		v_accvgpr_read_b32 v171, a133
		v_max3_f32 v171, v174, v171, v175
		v_accvgpr_read_b32 v172, a135
		v_max3_f32 v172, v203, v172, v204
		v_accvgpr_read_b32 v173, a137
		v_max3_f32 v173, v205, v173, v206
		v_accvgpr_read_b32 v174, a163
		v_max3_f32 v157, v174, v147, v157
		v_accvgpr_read_b32 v174, a161
		v_max3_f32 v13, v13, v174, v15
		v_accvgpr_read_b32 v15, a128
		v_max3_f32 v15, v105, v15, v113
		v_accvgpr_read_b32 v105, a132
		v_max3_f32 v105, v170, v105, v171
		v_accvgpr_read_b32 v113, a136
		v_max3_f32 v113, v172, v113, v173
		v_max3_f32 v13, v157, v151, v13
		v_accvgpr_read_b32 v157, a130
		v_max3_f32 v15, v15, v157, v105
		v_max3_f32 v13, v113, v96, v13
		v_accvgpr_read_b32 v105, a134
		v_max3_f32 v13, v15, v105, v13
		v_max_f32_e32 v170, v13, v158
		v_mov_b32_e32 v171, v170
		v_cndmask_b32_e64 v13, v11, v176, s[48:49]
		v_cndmask_b32_e64 v15, v11, v177, s[94:95]
		v_permlane32_swap_b32_e32 v170, v171
		v_max3_f32 v105, v13, v15, v16
		v_max3_f32 v113, v20, v159, v178
		v_max3_f32 v157, v24, v99, v179
		v_max3_f32 v172, v26, v103, v181
		v_max3_f32 v173, v28, v107, v182
		v_max3_f32 v174, v30, v111, v183
		v_max3_f32 v175, v115, v185, v186
		v_max3_f32 v176, v119, v188, v189
		v_max3_f32 v177, v123, v191, v192
		v_max3_f32 v203, v127, v194, v195
		v_max3_f32 v204, v131, v197, v198
		v_max3_f32 v205, v135, v200, v201
		v_max3_f32 v206, v142, v143, v160
		v_max3_f32 v207, v162, v163, v164
		v_max3_f32 v208, v149, v150, v166
		v_max3_f32 v209, v153, v154, v168
		v_max3_f32 v105, v105, v100, v113
		v_max3_f32 v113, v157, v180, v172
		v_max3_f32 v157, v173, v112, v174
		v_max3_f32 v172, v175, v187, v176
		v_max3_f32 v173, v177, v193, v203
		v_max3_f32 v174, v204, v199, v205
		v_max3_f32 v175, v206, v161, v207
		v_max3_f32 v176, v208, v167, v209
		v_max3_f32 v105, v105, v104, v113
		v_max3_f32 v113, v157, v184, v172
		v_max3_f32 v157, v173, v196, v174
		v_max3_f32 v172, v175, v165, v176
		v_max3_f32 v105, v105, v108, v113
		v_max3_f32 v113, v157, v202, v172
		v_max3_f32 v105, v105, v190, v113
		v_max_f32_e32 v172, v105, v169
		v_mov_b32_e32 v173, v172
		v_max_f32_e32 v105, v170, v171
		v_mul_f32_e32 v105, v105, v2
		v_permlane32_swap_b32_e32 v172, v173
		v_max_f32_e32 v113, v172, v173
		v_mul_f32_e32 v113, v113, v2
		v_max_f32_e32 v105, v4, v105
		v_max_f32_e32 v113, v5, v113
		v_xor_b32_e32 v157, 0x80000000, v105
		v_accvgpr_read_b32 v170, a138
		v_fma_f32 v170, v170, v2, v157
		v_fma_f32 v97, v97, v2, v157
		v_fma_f32 v18, v18, v2, v157
		v_accvgpr_read_b32 v171, a127
		v_fma_f32 v171, v171, v2, v157
		v_fma_f32 v98, v98, v2, v157
		v_fma_f32 v23, v23, v2, v157
		v_fma_f32 v101, v101, v2, v157
		v_accvgpr_read_b32 v172, a128
		v_fma_f32 v172, v172, v2, v157
		v_fma_f32 v102, v102, v2, v157
		v_fma_f32 v25, v25, v2, v157
		v_fma_f32 v27, v27, v2, v157
		v_accvgpr_read_b32 v173, a129
		v_fma_f32 v173, v173, v2, v157
		v_fma_f32 v106, v106, v2, v157
		v_fma_f32 v29, v29, v2, v157
		v_fma_f32 v109, v109, v2, v157
		v_accvgpr_read_b32 v174, a130
		v_fma_f32 v174, v174, v2, v157
		v_fma_f32 v110, v110, v2, v157
		v_fma_f32 v31, v31, v2, v157
		v_fma_f32 v114, v114, v2, v157
		v_accvgpr_read_b32 v175, a131
		v_fma_f32 v175, v175, v2, v157
		v_fma_f32 v116, v116, v2, v157
		v_fma_f32 v117, v117, v2, v157
		v_fma_f32 v118, v118, v2, v157
		v_accvgpr_read_b32 v176, a132
		v_fma_f32 v176, v176, v2, v157
		v_fma_f32 v120, v120, v2, v157
		v_fma_f32 v121, v121, v2, v157
		v_fma_f32 v122, v122, v2, v157
		v_accvgpr_read_b32 v177, a133
		v_fma_f32 v177, v177, v2, v157
		v_fma_f32 v124, v124, v2, v157
		v_fma_f32 v125, v125, v2, v157
		v_fma_f32 v126, v126, v2, v157
		v_accvgpr_read_b32 v203, a134
		v_fma_f32 v203, v203, v2, v157
		v_fma_f32 v128, v128, v2, v157
		v_fma_f32 v129, v129, v2, v157
		v_fma_f32 v130, v130, v2, v157
		v_accvgpr_read_b32 v204, a135
		v_fma_f32 v204, v204, v2, v157
		v_fma_f32 v132, v132, v2, v157
		v_fma_f32 v133, v133, v2, v157
		v_fma_f32 v134, v134, v2, v157
		v_accvgpr_read_b32 v205, a136
		v_fma_f32 v205, v205, v2, v157
		v_fma_f32 v136, v136, v2, v157
		v_fma_f32 v137, v137, v2, v157
		v_fma_f32 v138, v138, v2, v157
		v_accvgpr_read_b32 v206, a137
		v_fma_f32 v206, v206, v2, v157
		v_fma_f32 v140, v140, v2, v157
		v_fma_f32 v139, v139, v2, v157
		v_fma_f32 v141, v141, v2, v157
		v_fma_f32 v96, v96, v2, v157
		v_fma_f32 v144, v144, v2, v157
		v_fma_f32 v145, v145, v2, v157
		v_fma_f32 v146, v146, v2, v157
		v_fma_f32 v147, v147, v2, v157
		v_fma_f32 v148, v148, v2, v157
		v_accvgpr_read_b32 v207, a139
		v_fma_f32 v207, v207, v2, v157
		v_accvgpr_read_b32 v208, a158
		v_fma_f32 v208, v208, v2, v157
		v_fma_f32 v151, v151, v2, v157
		v_fma_f32 v152, v152, v2, v157
		v_accvgpr_read_b32 v209, a159
		v_fma_f32 v209, v209, v2, v157
		v_accvgpr_read_b32 v210, a160
		v_fma_f32 v210, v210, v2, v157
		v_accvgpr_read_b32 v211, a161
		v_fma_f32 v211, v211, v2, v157
		v_fma_f32 v155, v155, v2, v157
		v_fma_f32 v156, v156, v2, v157
		v_accvgpr_read_b32 v212, a162
		v_fma_f32 v212, v212, v2, v157
		v_fma_f32 v158, v158, v2, v157
		v_xor_b32_e32 v213, 0x80000000, v113
		v_fma_f32 v13, v13, v2, v213
		v_fma_f32 v15, v15, v2, v213
		v_fma_f32 v16, v16, v2, v213
		v_fma_f32 v100, v100, v2, v213
		v_fma_f32 v20, v20, v2, v213
		v_fma_f32 v159, v159, v2, v213
		v_fma_f32 v178, v178, v2, v213
		v_fma_f32 v104, v104, v2, v213
		v_fma_f32 v24, v24, v2, v213
		v_fma_f32 v99, v99, v2, v213
		v_fma_f32 v179, v179, v2, v213
		v_fma_f32 v180, v180, v2, v213
		v_fma_f32 v26, v26, v2, v213
		v_fma_f32 v103, v103, v2, v213
		v_fma_f32 v181, v181, v2, v213
		v_fma_f32 v108, v108, v2, v213
		v_fma_f32 v28, v28, v2, v213
		v_fma_f32 v107, v107, v2, v213
		v_fma_f32 v182, v182, v2, v213
		v_fma_f32 v112, v112, v2, v213
		v_fma_f32 v30, v30, v2, v213
		v_fma_f32 v111, v111, v2, v213
		v_fma_f32 v183, v183, v2, v213
		v_fma_f32 v184, v184, v2, v213
		v_fma_f32 v115, v115, v2, v213
		v_fma_f32 v185, v185, v2, v213
		v_fma_f32 v186, v186, v2, v213
		v_fma_f32 v187, v187, v2, v213
		v_fma_f32 v119, v119, v2, v213
		v_fma_f32 v188, v188, v2, v213
		v_fma_f32 v189, v189, v2, v213
		v_fma_f32 v190, v190, v2, v213
		v_fma_f32 v123, v123, v2, v213
		v_fma_f32 v191, v191, v2, v213
		v_fma_f32 v192, v192, v2, v213
		v_fma_f32 v193, v193, v2, v213
		v_fma_f32 v127, v127, v2, v213
		v_fma_f32 v194, v194, v2, v213
		v_fma_f32 v195, v195, v2, v213
		v_fma_f32 v196, v196, v2, v213
		v_fma_f32 v131, v131, v2, v213
		v_fma_f32 v197, v197, v2, v213
		v_fma_f32 v198, v198, v2, v213
		v_fma_f32 v199, v199, v2, v213
		v_fma_f32 v135, v135, v2, v213
		v_fma_f32 v200, v200, v2, v213
		v_fma_f32 v201, v201, v2, v213
		v_fma_f32 v202, v202, v2, v213
		v_fma_f32 v142, v142, v2, v213
		v_fma_f32 v143, v143, v2, v213
		v_fma_f32 v160, v160, v2, v213
		v_fma_f32 v161, v161, v2, v213
		v_fma_f32 v162, v162, v2, v213
		v_fma_f32 v163, v163, v2, v213
		v_fma_f32 v164, v164, v2, v213
		v_fma_f32 v165, v165, v2, v213
		v_fma_f32 v149, v149, v2, v213
		v_fma_f32 v150, v150, v2, v213
		v_fma_f32 v166, v166, v2, v213
		v_fma_f32 v167, v167, v2, v213
		v_fma_f32 v153, v153, v2, v213
		v_fma_f32 v154, v154, v2, v213
		v_fma_f32 v168, v168, v2, v213
		v_fma_f32 v169, v169, v2, v213
		v_exp_f32_e32 v170, v170
		v_exp_f32_e32 v97, v97
		v_exp_f32_e32 v18, v18
		v_exp_f32_e32 v171, v171
		v_exp_f32_e32 v98, v98
		v_exp_f32_e32 v23, v23
		v_exp_f32_e32 v101, v101
		v_exp_f32_e32 v172, v172
		v_exp_f32_e32 v102, v102
		v_exp_f32_e32 v25, v25
		v_exp_f32_e32 v27, v27
		v_exp_f32_e32 v173, v173
		v_exp_f32_e32 v106, v106
		v_exp_f32_e32 v29, v29
		v_exp_f32_e32 v109, v109
		v_exp_f32_e32 v174, v174
		v_exp_f32_e32 v110, v110
		v_exp_f32_e32 v31, v31
		v_exp_f32_e32 v114, v114
		v_exp_f32_e32 v175, v175
		v_exp_f32_e32 v116, v116
		v_exp_f32_e32 v117, v117
		v_exp_f32_e32 v118, v118
		v_exp_f32_e32 v176, v176
		v_exp_f32_e32 v120, v120
		v_exp_f32_e32 v121, v121
		v_exp_f32_e32 v122, v122
		v_exp_f32_e32 v177, v177
		v_exp_f32_e32 v124, v124
		v_exp_f32_e32 v125, v125
		v_exp_f32_e32 v126, v126
		v_exp_f32_e32 v203, v203
		v_exp_f32_e32 v128, v128
		v_exp_f32_e32 v129, v129
		v_exp_f32_e32 v130, v130
		v_exp_f32_e32 v204, v204
		v_exp_f32_e32 v132, v132
		v_exp_f32_e32 v133, v133
		v_exp_f32_e32 v134, v134
		v_exp_f32_e32 v205, v205
		v_exp_f32_e32 v136, v136
		v_exp_f32_e32 v137, v137
		v_exp_f32_e32 v138, v138
		v_exp_f32_e32 v206, v206
		v_exp_f32_e32 v140, v140
		v_exp_f32_e32 v139, v139
		v_exp_f32_e32 v141, v141
		v_exp_f32_e32 v96, v96
		v_exp_f32_e32 v144, v144
		v_exp_f32_e32 v145, v145
		v_exp_f32_e32 v146, v146
		v_exp_f32_e32 v147, v147
		v_exp_f32_e32 v148, v148
		v_exp_f32_e32 v207, v207
		v_exp_f32_e32 v208, v208
		v_exp_f32_e32 v151, v151
		v_exp_f32_e32 v152, v152
		v_exp_f32_e32 v209, v209
		v_exp_f32_e32 v210, v210
		v_exp_f32_e32 v211, v211
		v_exp_f32_e32 v155, v155
		v_exp_f32_e32 v156, v156
		v_exp_f32_e32 v212, v212
		v_exp_f32_e32 v158, v158
		v_exp_f32_e32 v16, v16
		v_exp_f32_e32 v100, v100
		v_exp_f32_e32 v20, v20
		v_exp_f32_e32 v159, v159
		v_exp_f32_e32 v178, v178
		v_exp_f32_e32 v104, v104
		v_exp_f32_e32 v24, v24
		v_exp_f32_e32 v99, v99
		v_exp_f32_e32 v179, v179
		v_exp_f32_e32 v180, v180
		v_exp_f32_e32 v26, v26
		v_exp_f32_e32 v103, v103
		v_exp_f32_e32 v181, v181
		v_exp_f32_e32 v108, v108
		v_exp_f32_e32 v28, v28
		v_exp_f32_e32 v107, v107
		v_exp_f32_e32 v182, v182
		v_exp_f32_e32 v112, v112
		v_exp_f32_e32 v30, v30
		v_exp_f32_e32 v111, v111
		v_exp_f32_e32 v183, v183
		v_exp_f32_e32 v184, v184
		v_exp_f32_e32 v115, v115
		v_exp_f32_e32 v185, v185
		v_exp_f32_e32 v186, v186
		v_exp_f32_e32 v187, v187
		v_exp_f32_e32 v119, v119
		v_exp_f32_e32 v188, v188
		v_exp_f32_e32 v189, v189
		v_exp_f32_e32 v190, v190
		v_exp_f32_e32 v123, v123
		v_exp_f32_e32 v191, v191
		v_exp_f32_e32 v192, v192
		v_exp_f32_e32 v193, v193
		v_exp_f32_e32 v127, v127
		v_exp_f32_e32 v194, v194
		v_exp_f32_e32 v195, v195
		v_exp_f32_e32 v196, v196
		v_exp_f32_e32 v131, v131
		v_exp_f32_e32 v197, v197
		v_exp_f32_e32 v198, v198
		v_exp_f32_e32 v199, v199
		v_exp_f32_e32 v135, v135
		v_exp_f32_e32 v200, v200
		v_exp_f32_e32 v201, v201
		v_exp_f32_e32 v202, v202
		v_exp_f32_e32 v142, v142
		v_exp_f32_e32 v143, v143
		v_exp_f32_e32 v160, v160
		v_exp_f32_e32 v161, v161
		v_exp_f32_e32 v162, v162
		v_exp_f32_e32 v163, v163
		v_exp_f32_e32 v164, v164
		v_exp_f32_e32 v165, v165
		v_exp_f32_e32 v149, v149
		v_exp_f32_e32 v150, v150
		v_exp_f32_e32 v166, v166
		v_exp_f32_e32 v167, v167
		v_exp_f32_e32 v153, v153
		v_exp_f32_e32 v154, v154
		v_exp_f32_e32 v168, v168
		v_exp_f32_e32 v169, v169
		v_add_f32_e32 v214, v170, v97
		v_add_f32_e32 v215, v128, v129
		v_add_f32_e32 v216, v18, v171
		v_add_f32_e32 v217, v130, v204
		v_add_f32_e32 v218, v98, v23
		v_add_f32_e32 v219, v132, v133
		v_add_f32_e32 v220, v101, v172
		v_add_f32_e32 v221, v134, v205
		v_add_f32_e32 v222, v102, v25
		v_add_f32_e32 v223, v136, v137
		v_add_f32_e32 v224, v27, v173
		v_add_f32_e32 v225, v138, v206
		v_add_f32_e32 v226, v106, v29
		v_add_f32_e32 v227, v140, v139
		v_add_f32_e32 v228, v109, v174
		v_add_f32_e32 v229, v141, v96
		v_add_f32_e32 v230, v110, v31
		v_add_f32_e32 v231, v144, v145
		v_add_f32_e32 v232, v114, v175
		v_add_f32_e32 v233, v146, v147
		v_add_f32_e32 v234, v116, v117
		v_add_f32_e32 v235, v148, v207
		v_add_f32_e32 v236, v118, v176
		v_add_f32_e32 v237, v208, v151
		v_add_f32_e32 v238, v120, v121
		v_add_f32_e32 v239, v152, v209
		v_add_f32_e32 v240, v122, v177
		v_add_f32_e32 v241, v210, v211
		v_add_f32_e32 v242, v124, v125
		v_add_f32_e32 v243, v155, v156
		v_add_f32_e32 v244, v126, v203
		v_add_f32_e32 v245, v212, v158
		v_add_f32_e32 v214, v214, v216
		v_add_f32_e32 v215, v215, v217
		v_add_f32_e32 v216, v218, v220
		v_add_f32_e32 v217, v219, v221
		v_add_f32_e32 v218, v222, v224
		v_add_f32_e32 v219, v223, v225
		v_add_f32_e32 v220, v226, v228
		v_add_f32_e32 v221, v227, v229
		v_add_f32_e32 v222, v230, v232
		v_add_f32_e32 v223, v231, v233
		v_add_f32_e32 v224, v234, v236
		v_add_f32_e32 v225, v235, v237
		v_add_f32_e32 v226, v238, v240
		v_add_f32_e32 v227, v239, v241
		v_add_f32_e32 v228, v242, v244
		v_add_f32_e32 v229, v243, v245
		v_add_f32_e32 v214, v214, v216
		v_add_f32_e32 v215, v215, v217
		v_add_f32_e32 v216, v218, v220
		v_add_f32_e32 v217, v219, v221
		v_add_f32_e32 v218, v222, v224
		v_add_f32_e32 v219, v223, v225
		v_add_f32_e32 v220, v226, v228
		v_add_f32_e32 v221, v227, v229
		v_add_f32_e32 v214, v214, v216
		v_add_f32_e32 v215, v215, v217
		v_add_f32_e32 v216, v218, v220
		v_add_f32_e32 v217, v219, v221
		v_add_f32_e32 v214, v214, v216
		v_add_f32_e32 v215, v215, v217
		v_add_f32_e32 v216, v214, v215
		v_mov_b32_e32 v217, v216
		v_exp_f32_e32 v13, v13
		v_exp_f32_e32 v15, v15
		v_permlane32_swap_b32_e32 v216, v217
		v_add_f32_e32 v214, v13, v15
		v_add_f32_e32 v215, v123, v191
		v_add_f32_e32 v218, v16, v100
		v_add_f32_e32 v219, v192, v193
		v_add_f32_e32 v220, v20, v159
		v_add_f32_e32 v221, v127, v194
		v_add_f32_e32 v222, v178, v104
		v_add_f32_e32 v223, v195, v196
		v_add_f32_e32 v224, v24, v99
		v_add_f32_e32 v225, v131, v197
		v_add_f32_e32 v226, v179, v180
		v_add_f32_e32 v227, v198, v199
		v_add_f32_e32 v228, v26, v103
		v_add_f32_e32 v229, v135, v200
		v_add_f32_e32 v230, v181, v108
		v_add_f32_e32 v231, v201, v202
		v_add_f32_e32 v232, v28, v107
		v_add_f32_e32 v233, v142, v143
		v_add_f32_e32 v234, v182, v112
		v_add_f32_e32 v235, v160, v161
		v_add_f32_e32 v236, v30, v111
		v_add_f32_e32 v237, v162, v163
		v_add_f32_e32 v238, v183, v184
		v_add_f32_e32 v239, v164, v165
		v_add_f32_e32 v240, v115, v185
		v_add_f32_e32 v241, v149, v150
		v_add_f32_e32 v242, v186, v187
		v_add_f32_e32 v243, v166, v167
		v_add_f32_e32 v244, v119, v188
		v_add_f32_e32 v245, v153, v154
		v_add_f32_e32 v246, v189, v190
		v_add_f32_e32 v247, v168, v169
		v_add_f32_e32 v214, v214, v218
		v_add_f32_e32 v215, v215, v219
		v_add_f32_e32 v218, v220, v222
		v_add_f32_e32 v219, v221, v223
		v_add_f32_e32 v220, v224, v226
		v_add_f32_e32 v221, v225, v227
		v_add_f32_e32 v222, v228, v230
		v_add_f32_e32 v223, v229, v231
		v_add_f32_e32 v224, v232, v234
		v_add_f32_e32 v225, v233, v235
		v_add_f32_e32 v226, v236, v238
		v_add_f32_e32 v227, v237, v239
		v_add_f32_e32 v228, v240, v242
		v_add_f32_e32 v229, v241, v243
		v_add_f32_e32 v230, v244, v246
		v_add_f32_e32 v231, v245, v247
		v_add_f32_e32 v214, v214, v218
		v_add_f32_e32 v215, v215, v219
		v_add_f32_e32 v218, v220, v222
		v_add_f32_e32 v219, v221, v223
		v_add_f32_e32 v220, v224, v226
		v_add_f32_e32 v221, v225, v227
		v_add_f32_e32 v222, v228, v230
		v_add_f32_e32 v223, v229, v231
		v_add_f32_e32 v214, v214, v218
		v_add_f32_e32 v215, v215, v219
		v_add_f32_e32 v218, v220, v222
		v_add_f32_e32 v219, v221, v223
		v_add_f32_e32 v214, v214, v218
		v_add_f32_e32 v215, v215, v219
		v_add_f32_e32 v216, v216, v217
		v_add_f32_e32 v218, v214, v215
		v_mov_b32_e32 v219, v218
		v_cvt_pk_bf16_f32 v220, v170, v97
		v_cvt_pk_bf16_f32 v221, v18, v171
		v_permlane32_swap_b32_e32 v218, v219
		v_add_f32_e32 v18, v218, v219
		v_add_f32_e32 v4, v4, v157
		v_add_f32_e32 v5, v5, v213
		v_exp_f32_e32 v4, v4
		v_exp_f32_e32 v5, v5
		v_cvt_pk_bf16_f32 v222, v98, v23
		v_mul_f32_e32 v32, v32, v4
		v_mul_f32_e32 v33, v33, v4
		v_mul_f32_e32 v34, v34, v4
		v_mul_f32_e32 v35, v35, v4
		v_mul_f32_e32 v36, v36, v4
		v_mul_f32_e32 v37, v37, v4
		v_mul_f32_e32 v38, v38, v4
		v_mul_f32_e32 v39, v39, v4
		v_mul_f32_e32 v40, v40, v4
		v_mul_f32_e32 v41, v41, v4
		v_mul_f32_e32 v42, v42, v4
		v_mul_f32_e32 v43, v43, v4
		v_mul_f32_e32 v44, v44, v4
		v_mul_f32_e32 v45, v45, v4
		v_mul_f32_e32 v46, v46, v4
		v_mul_f32_e32 v47, v47, v4
		v_mul_f32_e32 v48, v48, v4
		v_mul_f32_e32 v49, v49, v4
		v_mul_f32_e32 v50, v50, v4
		v_mul_f32_e32 v51, v51, v4
		v_mul_f32_e32 v52, v52, v4
		v_mul_f32_e32 v53, v53, v4
		v_mul_f32_e32 v54, v54, v4
		v_mul_f32_e32 v55, v55, v4
		v_mul_f32_e32 v56, v56, v4
		v_mul_f32_e32 v57, v57, v4
		v_mul_f32_e32 v58, v58, v4
		v_mul_f32_e32 v59, v59, v4
		v_mul_f32_e32 v60, v60, v4
		v_mul_f32_e32 v61, v61, v4
		v_mul_f32_e32 v62, v62, v4
		v_mul_f32_e32 v63, v63, v4
		v_mul_f32_e32 v64, v64, v5
		v_mul_f32_e32 v65, v65, v5
		v_mul_f32_e32 v66, v66, v5
		v_mul_f32_e32 v67, v67, v5
		v_mul_f32_e32 v68, v68, v5
		v_mul_f32_e32 v69, v69, v5
		v_mul_f32_e32 v70, v70, v5
		v_mul_f32_e32 v71, v71, v5
		v_mul_f32_e32 v72, v72, v5
		v_mul_f32_e32 v73, v73, v5
		v_mul_f32_e32 v74, v74, v5
		v_mul_f32_e32 v75, v75, v5
		v_mul_f32_e32 v76, v76, v5
		v_mul_f32_e32 v77, v77, v5
		v_mul_f32_e32 v78, v78, v5
		v_mul_f32_e32 v79, v79, v5
		v_mul_f32_e32 v80, v80, v5
		v_mul_f32_e32 v81, v81, v5
		v_mul_f32_e32 v82, v82, v5
		v_mul_f32_e32 v83, v83, v5
		v_mul_f32_e32 v84, v84, v5
		v_mul_f32_e32 v85, v85, v5
		v_mul_f32_e32 v86, v86, v5
		v_mul_f32_e32 v87, v87, v5
		v_mul_f32_e32 v88, v88, v5
		v_mul_f32_e32 v89, v89, v5
		v_mul_f32_e32 v90, v90, v5
		v_mul_f32_e32 v91, v91, v5
		v_mul_f32_e32 v92, v92, v5
		v_mul_f32_e32 v93, v93, v5
		v_mul_f32_e32 v94, v94, v5
		v_mul_f32_e32 v95, v95, v5
		v_fma_f32 v8, v8, v4, v216
		v_fma_f32 v9, v9, v5, v18
		v_cvt_pk_bf16_f32 v223, v101, v172
		v_cvt_pk_bf16_f32 v216, v102, v25
		v_cvt_pk_bf16_f32 v217, v27, v173
		v_cvt_pk_bf16_f32 v218, v106, v29
		v_cvt_pk_bf16_f32 v219, v109, v174
		v_cvt_pk_bf16_f32 v224, v110, v31
		v_cvt_pk_bf16_f32 v225, v114, v175
		v_cvt_pk_bf16_f32 v226, v116, v117
		v_cvt_pk_bf16_f32 v227, v118, v176
		v_cvt_pk_bf16_f32 v172, v120, v121
		v_cvt_pk_bf16_f32 v173, v122, v177
		v_cvt_pk_bf16_f32 v174, v124, v125
		v_cvt_pk_bf16_f32 v175, v126, v203
		v_cvt_pk_bf16_f32 v228, v128, v129
		v_cvt_pk_bf16_f32 v229, v130, v204
		v_cvt_pk_bf16_f32 v230, v132, v133
		v_cvt_pk_bf16_f32 v231, v134, v205
		v_cvt_pk_bf16_f32 v232, v136, v137
		v_cvt_pk_bf16_f32 v233, v138, v206
		v_cvt_pk_bf16_f32 v234, v140, v139
		v_cvt_pk_bf16_f32 v235, v141, v96
		v_cvt_pk_bf16_f32 v136, v144, v145
		v_cvt_pk_bf16_f32 v137, v146, v147
		v_cvt_pk_bf16_f32 v138, v148, v207
		v_cvt_pk_bf16_f32 v139, v208, v151
		v_cvt_pk_bf16_f32 v144, v152, v209
		v_cvt_pk_bf16_f32 v145, v210, v211
		v_cvt_pk_bf16_f32 v146, v155, v156
		v_cvt_pk_bf16_f32 v147, v212, v158
		v_cvt_pk_bf16_f32 v204, v13, v15
		v_cvt_pk_bf16_f32 v205, v16, v100
		v_cvt_pk_bf16_f32 v206, v20, v159
		v_cvt_pk_bf16_f32 v207, v178, v104
		v_cvt_pk_bf16_f32 v156, v24, v99
		v_cvt_pk_bf16_f32 v157, v179, v180
		v_cvt_pk_bf16_f32 v158, v26, v103
		v_cvt_pk_bf16_f32 v159, v181, v108
		v_cvt_pk_bf16_f32 v24, v28, v107
		v_cvt_pk_bf16_f32 v25, v182, v112
		v_cvt_pk_bf16_f32 v26, v30, v111
		v_cvt_pk_bf16_f32 v27, v183, v184
		v_cvt_pk_bf16_f32 v28, v115, v185
		v_cvt_pk_bf16_f32 v29, v186, v187
		v_cvt_pk_bf16_f32 v30, v119, v188
		v_cvt_pk_bf16_f32 v31, v189, v190
		v_cvt_pk_bf16_f32 v96, v123, v191
		v_cvt_pk_bf16_f32 v97, v192, v193
		v_cvt_pk_bf16_f32 v98, v127, v194
		v_cvt_pk_bf16_f32 v99, v195, v196
		v_cvt_pk_bf16_f32 v100, v131, v197
		v_cvt_pk_bf16_f32 v101, v198, v199
		v_cvt_pk_bf16_f32 v102, v135, v200
		v_cvt_pk_bf16_f32 v103, v201, v202
		v_cvt_pk_bf16_f32 v108, v142, v143
		v_cvt_pk_bf16_f32 v109, v160, v161
		v_cvt_pk_bf16_f32 v110, v162, v163
		v_cvt_pk_bf16_f32 v111, v164, v165
		v_cvt_pk_bf16_f32 v116, v149, v150
		v_cvt_pk_bf16_f32 v117, v166, v167
		v_cvt_pk_bf16_f32 v118, v153, v154
		v_cvt_pk_bf16_f32 v119, v168, v169
		v_permlane32_swap_b32_e32 v220, v222
		v_permlane32_swap_b32_e32 v221, v223
		v_permlane32_swap_b32_e32 v216, v218
		v_permlane32_swap_b32_e32 v217, v219
		v_mfma_f32_32x32x16_bf16 v[32:47], a[188:191], v[220:223], v[32:47]
		v_permlane32_swap_b32_e32 v224, v226
		v_permlane32_swap_b32_e32 v225, v227
		v_mfma_f32_32x32x16_bf16 v[48:63], a[220:223], v[220:223], v[48:63]
		v_permlane32_swap_b32_e32 v172, v174
		v_permlane32_swap_b32_e32 v173, v175
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[216:219], v[32:47]
		v_permlane32_swap_b32_e32 v228, v230
		v_permlane32_swap_b32_e32 v229, v231
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[216:219], v[48:63]
		v_permlane32_swap_b32_e32 v232, v234
		v_permlane32_swap_b32_e32 v233, v235
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[224:227], v[32:47]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[224:227], v[48:63]
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[172:175], v[32:47]
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[172:175], v[48:63]
		v_permlane32_swap_b32_e32 v156, v158
		v_permlane32_swap_b32_e32 v157, v159
		v_mfma_f32_32x32x16_bf16 v[80:95], a[220:223], v[204:207], v[80:95]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[64:79], a[188:191], v[204:207], v[64:79]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[156:159], v[80:95]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[156:159], v[64:79]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[24:27], v[80:95]
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[24:27], v[64:79]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[28:31], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[28:31], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[228:231], v[32:47]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[228:231], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[232:235], v[32:47]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[232:235], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[100:103], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[136:139], v[32:47]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[136:139], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[108:111], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[108:111], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[216:219], v[144:147], v[32:47]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[248:251], v[144:147], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[248:251], v[116:119], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[216:219], v[116:119], v[64:79]
		s_cselect_b32 s1, 1, 0
		s_add_i32 s25, s41, 0x80
		s_cmp_lg_u32 s1, 0
		s_mov_b32 s41, s25
		v_mov_b32_e32 v4, v105
		v_mov_b32_e32 v5, v113
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_2
.L_attn_fwd_persistent.loop_exit_2:
		v_rcp_f32_e32 v1, v8
		v_accvgpr_read_b32 v2, a12
		s_nop 0
		v_readfirstlane_b32 s1, v2
		v_accvgpr_read_b32 v2, a4
		s_nop 0
		v_readfirstlane_b32 s18, v2
		s_mul_i32 s1, s1, s18
		v_mul_f32_e32 v2, v32, v1
		v_mul_f32_e32 v3, v33, v1
		v_mul_f32_e32 v4, v34, v1
		v_mul_f32_e32 v5, v35, v1
		v_mul_f32_e32 v6, v36, v1
		v_mul_f32_e32 v7, v37, v1
		v_mul_f32_e32 v8, v38, v1
		v_mul_f32_e32 v10, v39, v1
		v_mul_f32_e32 v11, v40, v1
		v_mul_f32_e32 v12, v41, v1
		v_mul_f32_e32 v13, v42, v1
		v_mul_f32_e32 v14, v43, v1
		v_mul_f32_e32 v15, v44, v1
		v_mul_f32_e32 v16, v45, v1
		v_mul_f32_e32 v17, v46, v1
		v_mul_f32_e32 v18, v47, v1
		v_mul_f32_e32 v19, v48, v1
		v_mul_f32_e32 v20, v49, v1
		v_mul_f32_e32 v21, v50, v1
		v_mul_f32_e32 v22, v51, v1
		v_mul_f32_e32 v23, v52, v1
		v_mul_f32_e32 v24, v53, v1
		v_mul_f32_e32 v25, v54, v1
		v_mul_f32_e32 v26, v55, v1
		v_mul_f32_e32 v27, v56, v1
		v_mul_f32_e32 v28, v57, v1
		v_mul_f32_e32 v29, v58, v1
		v_mul_f32_e32 v30, v59, v1
		v_mul_f32_e32 v31, v60, v1
		v_mul_f32_e32 v32, v61, v1
		v_mul_f32_e32 v33, v62, v1
		v_mul_f32_e32 v1, v63, v1
		v_rcp_f32_e32 v9, v9
		v_cvt_pk_bf16_f32 v36, v2, v3
		v_mul_f32_e32 v2, v64, v9
		v_mul_f32_e32 v3, v65, v9
		v_mul_f32_e32 v34, v66, v9
		v_mul_f32_e32 v35, v67, v9
		v_mul_f32_e32 v40, v68, v9
		v_mul_f32_e32 v41, v69, v9
		v_mul_f32_e32 v42, v70, v9
		v_mul_f32_e32 v43, v71, v9
		v_mul_f32_e32 v44, v72, v9
		v_mul_f32_e32 v45, v73, v9
		v_mul_f32_e32 v46, v74, v9
		v_mul_f32_e32 v47, v75, v9
		v_mul_f32_e32 v48, v76, v9
		v_mul_f32_e32 v49, v77, v9
		v_mul_f32_e32 v50, v78, v9
		v_mul_f32_e32 v51, v79, v9
		v_mul_f32_e32 v52, v80, v9
		v_mul_f32_e32 v53, v81, v9
		v_mul_f32_e32 v54, v82, v9
		v_mul_f32_e32 v55, v83, v9
		v_mul_f32_e32 v56, v84, v9
		v_mul_f32_e32 v57, v85, v9
		v_mul_f32_e32 v58, v86, v9
		v_mul_f32_e32 v59, v87, v9
		v_mul_f32_e32 v60, v88, v9
		v_mul_f32_e32 v61, v89, v9
		v_mul_f32_e32 v62, v90, v9
		v_mul_f32_e32 v63, v91, v9
		v_mul_f32_e32 v64, v92, v9
		v_mul_f32_e32 v65, v93, v9
		v_mul_f32_e32 v66, v94, v9
		v_mul_f32_e32 v9, v95, v9
		v_cvt_pk_bf16_f32 v37, v4, v5
		v_cvt_pk_bf16_f32 v38, v6, v7
		v_cvt_pk_bf16_f32 v39, v8, v10
		v_cvt_pk_bf16_f32 v4, v11, v12
		v_cvt_pk_bf16_f32 v5, v13, v14
		v_cvt_pk_bf16_f32 v6, v15, v16
		v_cvt_pk_bf16_f32 v7, v17, v18
		v_cvt_pk_bf16_f32 v12, v19, v20
		v_cvt_pk_bf16_f32 v13, v21, v22
		v_cvt_pk_bf16_f32 v14, v23, v24
		v_cvt_pk_bf16_f32 v15, v25, v26
		v_cvt_pk_bf16_f32 v16, v27, v28
		v_cvt_pk_bf16_f32 v17, v29, v30
		v_cvt_pk_bf16_f32 v18, v31, v32
		v_cvt_pk_bf16_f32 v19, v33, v1
		v_cvt_pk_bf16_f32 v20, v2, v3
		v_cvt_pk_bf16_f32 v21, v34, v35
		v_cvt_pk_bf16_f32 v22, v40, v41
		v_cvt_pk_bf16_f32 v23, v42, v43
		v_cvt_pk_bf16_f32 v24, v44, v45
		v_cvt_pk_bf16_f32 v25, v46, v47
		v_cvt_pk_bf16_f32 v26, v48, v49
		v_cvt_pk_bf16_f32 v27, v50, v51
		v_cvt_pk_bf16_f32 v28, v52, v53
		v_cvt_pk_bf16_f32 v29, v54, v55
		v_cvt_pk_bf16_f32 v30, v56, v57
		v_cvt_pk_bf16_f32 v31, v58, v59
		v_cvt_pk_bf16_f32 v32, v60, v61
		v_cvt_pk_bf16_f32 v33, v62, v63
		v_cvt_pk_bf16_f32 v34, v64, v65
		v_cvt_pk_bf16_f32 v35, v66, v9
		v_permlane32_swap_b32_e32 v36, v38
		v_permlane32_swap_b32_e32 v37, v39
		v_permlane32_swap_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v5, v7
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
		v_accvgpr_read_b32 v8, a13
		v_accvgpr_read_b32 v9, a52
		s_nop 0
		v_readfirstlane_b32 s24, v9
		v_accvgpr_read_b32 v9, a53
		s_nop 0
		v_readfirstlane_b32 s25, v9
		s_nop 1
		v_cndmask_b32_e64 v3, v8, v3, s[24:25]
		s_mov_b32 s32, s8
		s_mov_b32 s33, s9
		s_mov_b32 s34, s30
		s_mov_b32 s35, s31
		buffer_store_dwordx4 v[36:39], v3, s[32:35], 0 offen
		s_add_i32 s24, s21, 32
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
		buffer_store_dwordx4 v[4:7], v3, s[32:35], 0 offen
		s_add_i32 s24, s21, 64
		v_add3_u32 v3, s24, v1, v2
		v_accvgpr_read_b32 v4, a13
		v_accvgpr_read_b32 v5, a52
		s_nop 0
		v_readfirstlane_b32 s24, v5
		v_accvgpr_read_b32 v5, a53
		s_nop 0
		v_readfirstlane_b32 s25, v5
		s_nop 1
		v_cndmask_b32_e64 v3, v4, v3, s[24:25]
		buffer_store_dwordx4 v[12:15], v3, s[32:35], 0 offen
		s_add_i32 s21, s21, 0x60
		v_add3_u32 v3, s21, v1, v2
		v_accvgpr_read_b32 v4, a13
		v_accvgpr_read_b32 v5, a52
		s_nop 0
		v_readfirstlane_b32 s24, v5
		v_accvgpr_read_b32 v5, a53
		s_nop 0
		v_readfirstlane_b32 s25, v5
		s_nop 1
		v_cndmask_b32_e64 v3, v4, v3, s[24:25]
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
		v_accvgpr_read_b32 v4, a13
		v_accvgpr_read_b32 v5, a60
		s_nop 0
		v_readfirstlane_b32 s22, v5
		v_accvgpr_read_b32 v5, a61
		s_nop 0
		v_readfirstlane_b32 s23, v5
		s_nop 1
		v_cndmask_b32_e64 v3, v4, v3, s[22:23]
		buffer_store_dwordx4 v[20:23], v3, s[32:35], 0 offen
		s_add_i32 s18, s1, 32
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
		buffer_store_dwordx4 v[28:31], v3, s[32:35], 0 offen
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
		buffer_store_dwordx4 v[32:35], v1, s[32:35], 0 offen
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
		v_mov_b32_e32 v2, 0x3e38aa3b
		s_mov_b32 s25, 0xff800000
		v_mov_b32_e32 v8, s25
		v_mov_b32_e32 v9, s25
		s_mov_b32 s25, 1.0
		v_mov_b32_e32 v11, s25
		v_mov_b32_e32 v18, s25
		s_mov_b32 s25, 0
		v_lshrrev_b32_e32 v20, 4, v15
		v_lshlrev_b32_e32 v20, 9, v20
		v_and_b32_e32 v15, 15, v15
		v_mov_b32_e32 v23, 0x410
		v_mul_lo_u32 v23, v23, v15
		v_add3_u32 v13, v13, v20, v23
		v_accvgpr_write_b32 a62, v13
		v_and_b32_e32 v13, 3, v0
		v_accvgpr_read_b32 v15, a17
		v_mov_b32_e32 v20, 0x2200
		v_mul_lo_u32 v20, v20, v15
		v_lshl_add_u32 v13, v13, 3, v20
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
		ds_read_b128 v[24:27], v1
		ds_read_b128 v[28:31], v1 offset:32
		ds_read_b128 v[96:99], v1 offset:64
		ds_read_b128 a[64:67], v1 offset:96
		ds_read_b128 v[100:103], v1 offset:256
		ds_read_b128 v[104:107], v1 offset:288
		ds_read_b128 v[108:111], v1 offset:320
		ds_read_b128 a[68:71], v1 offset:352
		ds_read_b128 v[112:115], v1 offset:128
		ds_read_b128 v[116:119], v1 offset:160
		ds_read_b128 v[120:123], v1 offset:192
		ds_read_b128 a[72:75], v1 offset:224
		ds_read_b128 v[124:127], v1 offset:384
		ds_read_b128 v[128:131], v1 offset:416
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
		v_mfma_f32_32x32x16_bf16 v[144:159], v[24:27], a[20:23], 0
		v_add3_u32 v1, v1, v21, v14
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[24:27], v[144:159]
		s_add_i32 s37, s37, 1
		v_mfma_f32_32x32x16_bf16 v[144:159], v[96:99], a[28:31], v[144:159]
		s_and_b32 s37, s37, 1
		v_mfma_f32_32x32x16_bf16 v[160:175], v[24:27], a[36:39], 0
		s_mul_i32 s48, 0x4100, s37
		v_mfma_f32_32x32x16_bf16 v[160:175], v[28:31], a[40:43], v[160:175]
		s_add_i32 s48, s40, s48
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], a[44:47], v[160:175]
		s_mov_b32 m0, s48
		v_mfma_f32_32x32x16_bf16 v[176:191], v[100:103], a[20:23], 0
		s_add_i32 s42, s44, s42
		v_mfma_f32_32x32x16_bf16 v[176:191], v[104:107], a[24:27], v[176:191]
		v_add3_u32 v3, s42, v12, v19
		v_mfma_f32_32x32x16_bf16 v[176:191], v[108:111], a[28:31], v[176:191]
		v_add3_u32 v3, v3, v21, v14
		v_mfma_f32_32x32x16_bf16 v[192:207], v[100:103], a[36:39], 0
		s_mul_i32 s42, s17, s25
		v_mfma_f32_32x32x16_bf16 v[192:207], v[104:107], a[40:43], v[192:207]
		s_add_i32 s25, s25, 0x80
		v_mfma_f32_32x32x16_bf16 v[192:207], v[108:111], a[44:47], v[192:207]
		v_accvgpr_read_b32 v13, a18
		v_add_u32_e32 v13, s25, v13
		v_mfma_f32_32x32x16_bf16 v[96:111], v[112:115], a[20:23], 0
		v_accvgpr_read_b32 v15, a54
		v_add_u32_e32 v15, s25, v15
		v_mfma_f32_32x32x16_bf16 v[96:111], v[116:119], a[24:27], v[96:111]
		v_accvgpr_read_b32 v16, a55
		v_add_u32_e32 v16, s25, v16
		v_mfma_f32_32x32x16_bf16 v[96:111], v[120:123], a[28:31], v[96:111]
		v_accvgpr_read_b32 v20, a56
		v_add_u32_e32 v20, s25, v20
		v_mfma_f32_32x32x16_bf16 v[208:223], v[112:115], a[36:39], 0
		v_cmp_lt_i32_e64 s[48:49], v13, s20
		v_mfma_f32_32x32x16_bf16 v[208:223], v[116:119], a[40:43], v[208:223]
		v_accvgpr_read_b32 v13, a19
		v_add_u32_e32 v13, s25, v13
		v_mfma_f32_32x32x16_bf16 v[208:223], v[120:123], a[44:47], v[208:223]
		v_accvgpr_read_b32 v23, a57
		v_add_u32_e32 v23, s25, v23
		v_mfma_f32_32x32x16_bf16 v[224:239], v[124:127], a[20:23], 0
		v_accvgpr_read_b32 v24, a58
		v_add_u32_e32 v24, s25, v24
		v_mfma_f32_32x32x16_bf16 v[224:239], v[128:131], a[24:27], v[224:239]
		v_accvgpr_read_b32 v25, a59
		v_add_u32_e32 v25, s25, v25
		v_mfma_f32_32x32x16_bf16 v[224:239], a[76:79], a[28:31], v[224:239]
		v_cmp_lt_i32_e64 vcc, v25, s20
		v_mfma_f32_32x32x16_bf16 v[240:255], v[124:127], a[36:39], 0
		v_cndmask_b32_e64 v1, v22, v1, s[48:49]
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[48:49], v15, s20
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[50:51], v16, s20
		v_mfma_f32_32x32x16_bf16 v[240:255], v[128:131], a[40:43], v[240:255]
		v_cndmask_b32_e64 v1, v22, v3, s[48:49]
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[240:255], a[76:79], a[44:47], v[240:255]
		v_cndmask_b32_e64 v1, v22, v4, s[50:51]
		v_cmp_lt_i32_e64 s[48:49], v20, s20
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[50:51], v13, s20
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[144:159], a[64:67], a[32:35], v[144:159]
		v_cndmask_b32_e64 v1, v22, v5, s[48:49]
		v_cmp_lt_i32_e64 s[48:49], v23, s20
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s42, s42, 1
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[52:53], v24, s20
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
		v_max3_f32 v20, v172, v173, v174
		v_max3_f32 v13, v13, v163, v15
		v_max3_f32 v15, v16, v171, v20
		v_max3_f32 v13, v13, v167, v15
		v_add_u32_e32 v5, s23, v5
		s_cmp_lt_i32 s25, s41
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[176:191], a[68:71], a[32:35], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[72:75], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[80:83], a[32:35], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[80:83], a[48:51], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[68:71], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[72:75], a[48:51], v[208:223]
		s_nop 6
		v_max3_f32 v3, v176, v177, v178
		v_max3_f32 v15, v180, v181, v182
		v_max3_f32 v16, v184, v185, v186
		v_max3_f32 v20, v188, v189, v190
		v_max3_f32 v23, v96, v97, v98
		v_max3_f32 v24, v100, v101, v102
		v_max3_f32 v25, v104, v105, v106
		v_max3_f32 v26, v108, v109, v110
		v_max3_f32 v27, v224, v225, v226
		v_max3_f32 v28, v228, v229, v230
		v_max3_f32 v29, v232, v233, v234
		v_max3_f32 v30, v236, v237, v238
		v_max3_f32 v3, v3, v179, v15
		v_max3_f32 v15, v16, v187, v20
		v_max3_f32 v16, v23, v99, v24
		v_max3_f32 v20, v25, v107, v26
		v_max3_f32 v23, v27, v227, v28
		v_max3_f32 v24, v29, v235, v30
		v_max3_f32 v3, v3, v183, v15
		v_max3_f32 v15, v16, v103, v20
		v_max3_f32 v16, v23, v231, v24
		v_max3_f32 v1, v1, v159, v3
		v_max3_f32 v3, v15, v111, v16
		v_max3_f32 v1, v1, v191, v3
		v_max_f32_e32 v24, v1, v239
		v_mov_b32_e32 v25, v24
		v_max3_f32 v1, v192, v193, v194
		v_max3_f32 v3, v196, v197, v198
		v_max3_f32 v15, v200, v201, v202
		v_max3_f32 v16, v204, v205, v206
		v_max3_f32 v20, v208, v209, v210
		v_max3_f32 v23, v212, v213, v214
		v_max3_f32 v26, v216, v217, v218
		v_max3_f32 v27, v220, v221, v222
		v_max3_f32 v28, v240, v241, v242
		v_max3_f32 v29, v244, v245, v246
		v_max3_f32 v30, v248, v249, v250
		v_max3_f32 v31, v252, v253, v254
		v_max3_f32 v1, v1, v195, v3
		v_max3_f32 v3, v15, v203, v16
		v_max3_f32 v15, v20, v211, v23
		v_max3_f32 v16, v26, v219, v27
		v_permlane32_swap_b32_e32 v24, v25
		v_max3_f32 v20, v28, v243, v29
		v_max3_f32 v23, v30, v251, v31
		v_max3_f32 v1, v1, v199, v3
		v_max3_f32 v3, v15, v215, v16
		v_max3_f32 v15, v20, v247, v23
		v_max3_f32 v1, v13, v175, v1
		v_max3_f32 v3, v3, v223, v15
		v_max3_f32 v1, v1, v207, v3
		v_max_f32_e32 v26, v1, v255
		v_mov_b32_e32 v27, v26
		v_max_f32_e32 v1, v24, v25
		v_mul_f32_e32 v1, v1, v2
		v_permlane32_swap_b32_e32 v26, v27
		v_max_f32_e32 v3, v26, v27
		v_mul_f32_e32 v3, v3, v2
		v_max_f32_e32 v1, v8, v1
		v_max_f32_e32 v3, v9, v3
		v_xor_b32_e32 v13, 0x80000000, v1
		v_fma_f32 v15, v144, v2, v13
		v_fma_f32 v16, v145, v2, v13
		v_fma_f32 v20, v146, v2, v13
		v_fma_f32 v23, v147, v2, v13
		v_fma_f32 v24, v148, v2, v13
		v_fma_f32 v25, v149, v2, v13
		v_fma_f32 v26, v150, v2, v13
		v_fma_f32 v27, v151, v2, v13
		v_fma_f32 v28, v152, v2, v13
		v_fma_f32 v29, v153, v2, v13
		v_fma_f32 v30, v154, v2, v13
		v_fma_f32 v31, v155, v2, v13
		v_fma_f32 v112, v156, v2, v13
		v_fma_f32 v113, v157, v2, v13
		v_fma_f32 v114, v158, v2, v13
		v_fma_f32 v115, v159, v2, v13
		v_fma_f32 v116, v176, v2, v13
		v_fma_f32 v117, v177, v2, v13
		v_fma_f32 v118, v178, v2, v13
		v_fma_f32 v119, v179, v2, v13
		v_fma_f32 v120, v180, v2, v13
		v_fma_f32 v121, v181, v2, v13
		v_fma_f32 v122, v182, v2, v13
		v_fma_f32 v123, v183, v2, v13
		v_fma_f32 v124, v184, v2, v13
		v_fma_f32 v125, v185, v2, v13
		v_fma_f32 v126, v186, v2, v13
		v_fma_f32 v127, v187, v2, v13
		v_fma_f32 v128, v188, v2, v13
		v_fma_f32 v129, v189, v2, v13
		v_fma_f32 v130, v190, v2, v13
		v_fma_f32 v131, v191, v2, v13
		v_fma_f32 v96, v96, v2, v13
		v_fma_f32 v97, v97, v2, v13
		v_fma_f32 v98, v98, v2, v13
		v_fma_f32 v99, v99, v2, v13
		v_fma_f32 v100, v100, v2, v13
		v_fma_f32 v101, v101, v2, v13
		v_fma_f32 v102, v102, v2, v13
		v_fma_f32 v103, v103, v2, v13
		v_fma_f32 v104, v104, v2, v13
		v_fma_f32 v105, v105, v2, v13
		v_fma_f32 v106, v106, v2, v13
		v_fma_f32 v107, v107, v2, v13
		v_fma_f32 v108, v108, v2, v13
		v_fma_f32 v109, v109, v2, v13
		v_fma_f32 v110, v110, v2, v13
		v_fma_f32 v111, v111, v2, v13
		v_fma_f32 v132, v224, v2, v13
		v_fma_f32 v133, v225, v2, v13
		v_fma_f32 v134, v226, v2, v13
		v_fma_f32 v135, v227, v2, v13
		v_fma_f32 v136, v228, v2, v13
		v_fma_f32 v137, v229, v2, v13
		v_fma_f32 v138, v230, v2, v13
		v_fma_f32 v139, v231, v2, v13
		v_fma_f32 v140, v232, v2, v13
		v_fma_f32 v141, v233, v2, v13
		v_fma_f32 v142, v234, v2, v13
		v_fma_f32 v143, v235, v2, v13
		v_fma_f32 v144, v236, v2, v13
		v_fma_f32 v145, v237, v2, v13
		v_fma_f32 v146, v238, v2, v13
		v_fma_f32 v147, v239, v2, v13
		v_xor_b32_e32 v148, 0x80000000, v3
		v_fma_f32 v149, v160, v2, v148
		v_fma_f32 v150, v161, v2, v148
		v_fma_f32 v151, v162, v2, v148
		v_fma_f32 v152, v163, v2, v148
		v_fma_f32 v153, v164, v2, v148
		v_fma_f32 v154, v165, v2, v148
		v_fma_f32 v155, v166, v2, v148
		v_fma_f32 v156, v167, v2, v148
		v_fma_f32 v157, v168, v2, v148
		v_fma_f32 v158, v169, v2, v148
		v_fma_f32 v159, v170, v2, v148
		v_fma_f32 v160, v171, v2, v148
		v_fma_f32 v161, v172, v2, v148
		v_fma_f32 v162, v173, v2, v148
		v_fma_f32 v163, v174, v2, v148
		v_fma_f32 v164, v175, v2, v148
		v_fma_f32 v165, v192, v2, v148
		v_fma_f32 v166, v193, v2, v148
		v_fma_f32 v167, v194, v2, v148
		v_fma_f32 v168, v195, v2, v148
		v_fma_f32 v169, v196, v2, v148
		v_fma_f32 v170, v197, v2, v148
		v_fma_f32 v171, v198, v2, v148
		v_fma_f32 v172, v199, v2, v148
		v_fma_f32 v173, v200, v2, v148
		v_fma_f32 v174, v201, v2, v148
		v_fma_f32 v175, v202, v2, v148
		v_fma_f32 v176, v203, v2, v148
		v_fma_f32 v177, v204, v2, v148
		v_fma_f32 v178, v205, v2, v148
		v_fma_f32 v179, v206, v2, v148
		v_fma_f32 v180, v207, v2, v148
		v_fma_f32 v181, v208, v2, v148
		v_fma_f32 v182, v209, v2, v148
		v_fma_f32 v183, v210, v2, v148
		v_fma_f32 v184, v211, v2, v148
		v_fma_f32 v185, v212, v2, v148
		v_fma_f32 v186, v213, v2, v148
		v_fma_f32 v187, v214, v2, v148
		v_fma_f32 v188, v215, v2, v148
		v_fma_f32 v189, v216, v2, v148
		v_fma_f32 v190, v217, v2, v148
		v_fma_f32 v191, v218, v2, v148
		v_fma_f32 v192, v219, v2, v148
		v_fma_f32 v193, v220, v2, v148
		v_fma_f32 v194, v221, v2, v148
		v_fma_f32 v195, v222, v2, v148
		v_fma_f32 v196, v223, v2, v148
		v_fma_f32 v197, v240, v2, v148
		v_fma_f32 v198, v241, v2, v148
		v_fma_f32 v199, v242, v2, v148
		v_fma_f32 v200, v243, v2, v148
		v_fma_f32 v201, v244, v2, v148
		v_fma_f32 v202, v245, v2, v148
		v_fma_f32 v203, v246, v2, v148
		v_fma_f32 v204, v247, v2, v148
		v_fma_f32 v205, v248, v2, v148
		v_fma_f32 v206, v249, v2, v148
		v_fma_f32 v207, v250, v2, v148
		v_fma_f32 v208, v251, v2, v148
		v_fma_f32 v209, v252, v2, v148
		v_fma_f32 v210, v253, v2, v148
		v_fma_f32 v211, v254, v2, v148
		v_fma_f32 v212, v255, v2, v148
		v_exp_f32_e32 v15, v15
		v_exp_f32_e32 v16, v16
		v_exp_f32_e32 v20, v20
		v_exp_f32_e32 v23, v23
		v_exp_f32_e32 v24, v24
		v_exp_f32_e32 v25, v25
		v_exp_f32_e32 v26, v26
		v_exp_f32_e32 v27, v27
		v_exp_f32_e32 v28, v28
		v_exp_f32_e32 v29, v29
		v_exp_f32_e32 v30, v30
		v_exp_f32_e32 v31, v31
		v_exp_f32_e32 v112, v112
		v_exp_f32_e32 v113, v113
		v_exp_f32_e32 v114, v114
		v_exp_f32_e32 v115, v115
		v_exp_f32_e32 v116, v116
		v_exp_f32_e32 v117, v117
		v_exp_f32_e32 v118, v118
		v_exp_f32_e32 v119, v119
		v_exp_f32_e32 v120, v120
		v_exp_f32_e32 v121, v121
		v_exp_f32_e32 v122, v122
		v_exp_f32_e32 v123, v123
		v_exp_f32_e32 v124, v124
		v_exp_f32_e32 v125, v125
		v_exp_f32_e32 v126, v126
		v_exp_f32_e32 v127, v127
		v_exp_f32_e32 v128, v128
		v_exp_f32_e32 v129, v129
		v_exp_f32_e32 v130, v130
		v_exp_f32_e32 v131, v131
		v_exp_f32_e32 v96, v96
		v_exp_f32_e32 v97, v97
		v_exp_f32_e32 v98, v98
		v_exp_f32_e32 v99, v99
		v_exp_f32_e32 v100, v100
		v_exp_f32_e32 v101, v101
		v_exp_f32_e32 v102, v102
		v_exp_f32_e32 v103, v103
		v_exp_f32_e32 v104, v104
		v_exp_f32_e32 v105, v105
		v_exp_f32_e32 v106, v106
		v_exp_f32_e32 v107, v107
		v_exp_f32_e32 v108, v108
		v_exp_f32_e32 v109, v109
		v_exp_f32_e32 v110, v110
		v_exp_f32_e32 v111, v111
		v_exp_f32_e32 v132, v132
		v_exp_f32_e32 v133, v133
		v_exp_f32_e32 v134, v134
		v_exp_f32_e32 v135, v135
		v_exp_f32_e32 v136, v136
		v_exp_f32_e32 v137, v137
		v_exp_f32_e32 v138, v138
		v_exp_f32_e32 v139, v139
		v_exp_f32_e32 v140, v140
		v_exp_f32_e32 v141, v141
		v_exp_f32_e32 v142, v142
		v_exp_f32_e32 v143, v143
		v_exp_f32_e32 v144, v144
		v_exp_f32_e32 v145, v145
		v_exp_f32_e32 v146, v146
		v_exp_f32_e32 v147, v147
		v_exp_f32_e32 v151, v151
		v_exp_f32_e32 v152, v152
		v_exp_f32_e32 v153, v153
		v_exp_f32_e32 v154, v154
		v_exp_f32_e32 v155, v155
		v_exp_f32_e32 v156, v156
		v_exp_f32_e32 v157, v157
		v_exp_f32_e32 v158, v158
		v_exp_f32_e32 v159, v159
		v_exp_f32_e32 v160, v160
		v_exp_f32_e32 v161, v161
		v_exp_f32_e32 v162, v162
		v_exp_f32_e32 v163, v163
		v_exp_f32_e32 v164, v164
		v_exp_f32_e32 v165, v165
		v_exp_f32_e32 v166, v166
		v_exp_f32_e32 v167, v167
		v_exp_f32_e32 v168, v168
		v_exp_f32_e32 v169, v169
		v_exp_f32_e32 v170, v170
		v_exp_f32_e32 v171, v171
		v_exp_f32_e32 v172, v172
		v_exp_f32_e32 v173, v173
		v_exp_f32_e32 v174, v174
		v_exp_f32_e32 v175, v175
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
		v_add_f32_e32 v213, v15, v16
		v_add_f32_e32 v214, v96, v97
		v_add_f32_e32 v215, v20, v23
		v_add_f32_e32 v216, v98, v99
		v_add_f32_e32 v217, v24, v25
		v_add_f32_e32 v218, v100, v101
		v_add_f32_e32 v219, v26, v27
		v_add_f32_e32 v220, v102, v103
		v_add_f32_e32 v221, v28, v29
		v_add_f32_e32 v222, v104, v105
		v_add_f32_e32 v223, v30, v31
		v_add_f32_e32 v224, v106, v107
		v_add_f32_e32 v225, v112, v113
		v_add_f32_e32 v226, v108, v109
		v_add_f32_e32 v227, v114, v115
		v_add_f32_e32 v228, v110, v111
		v_add_f32_e32 v229, v116, v117
		v_add_f32_e32 v230, v132, v133
		v_add_f32_e32 v231, v118, v119
		v_add_f32_e32 v232, v134, v135
		v_add_f32_e32 v233, v120, v121
		v_add_f32_e32 v234, v136, v137
		v_add_f32_e32 v235, v122, v123
		v_add_f32_e32 v236, v138, v139
		v_add_f32_e32 v237, v124, v125
		v_add_f32_e32 v238, v140, v141
		v_add_f32_e32 v239, v126, v127
		v_add_f32_e32 v240, v142, v143
		v_add_f32_e32 v241, v128, v129
		v_add_f32_e32 v242, v144, v145
		v_add_f32_e32 v243, v130, v131
		v_add_f32_e32 v244, v146, v147
		v_add_f32_e32 v213, v213, v215
		v_add_f32_e32 v214, v214, v216
		v_add_f32_e32 v215, v217, v219
		v_add_f32_e32 v216, v218, v220
		v_add_f32_e32 v217, v221, v223
		v_add_f32_e32 v218, v222, v224
		v_add_f32_e32 v219, v225, v227
		v_add_f32_e32 v220, v226, v228
		v_add_f32_e32 v221, v229, v231
		v_add_f32_e32 v222, v230, v232
		v_add_f32_e32 v223, v233, v235
		v_add_f32_e32 v224, v234, v236
		v_add_f32_e32 v225, v237, v239
		v_add_f32_e32 v226, v238, v240
		v_add_f32_e32 v227, v241, v243
		v_add_f32_e32 v228, v242, v244
		v_add_f32_e32 v213, v213, v215
		v_add_f32_e32 v214, v214, v216
		v_add_f32_e32 v215, v217, v219
		v_add_f32_e32 v216, v218, v220
		v_add_f32_e32 v217, v221, v223
		v_add_f32_e32 v218, v222, v224
		v_add_f32_e32 v219, v225, v227
		v_add_f32_e32 v220, v226, v228
		v_add_f32_e32 v213, v213, v215
		v_add_f32_e32 v214, v214, v216
		v_add_f32_e32 v215, v217, v219
		v_add_f32_e32 v216, v218, v220
		v_add_f32_e32 v213, v213, v215
		v_add_f32_e32 v214, v214, v216
		v_add_f32_e32 v216, v213, v214
		v_mov_b32_e32 v217, v216
		v_exp_f32_e32 v149, v149
		v_exp_f32_e32 v150, v150
		v_permlane32_swap_b32_e32 v216, v217
		v_add_f32_e32 v213, v149, v150
		v_add_f32_e32 v214, v181, v182
		v_add_f32_e32 v215, v151, v152
		v_add_f32_e32 v218, v183, v184
		v_add_f32_e32 v219, v153, v154
		v_add_f32_e32 v220, v185, v186
		v_add_f32_e32 v221, v155, v156
		v_add_f32_e32 v222, v187, v188
		v_add_f32_e32 v223, v157, v158
		v_add_f32_e32 v224, v189, v190
		v_add_f32_e32 v225, v159, v160
		v_add_f32_e32 v226, v191, v192
		v_add_f32_e32 v227, v161, v162
		v_add_f32_e32 v228, v193, v194
		v_add_f32_e32 v229, v163, v164
		v_add_f32_e32 v230, v195, v196
		v_add_f32_e32 v231, v165, v166
		v_add_f32_e32 v232, v197, v198
		v_add_f32_e32 v233, v167, v168
		v_add_f32_e32 v234, v199, v200
		v_add_f32_e32 v235, v169, v170
		v_add_f32_e32 v236, v201, v202
		v_add_f32_e32 v237, v171, v172
		v_add_f32_e32 v238, v203, v204
		v_add_f32_e32 v239, v173, v174
		v_add_f32_e32 v240, v205, v206
		v_add_f32_e32 v241, v175, v176
		v_add_f32_e32 v242, v207, v208
		v_add_f32_e32 v243, v177, v178
		v_add_f32_e32 v244, v209, v210
		v_accvgpr_write_b32 a64, v244
		v_add_f32_e32 v244, v179, v180
		v_add_f32_e32 v245, v211, v212
		v_add_f32_e32 v213, v213, v215
		v_add_f32_e32 v214, v214, v218
		v_add_f32_e32 v215, v219, v221
		v_add_f32_e32 v218, v220, v222
		v_add_f32_e32 v219, v223, v225
		v_add_f32_e32 v220, v224, v226
		v_add_f32_e32 v221, v227, v229
		v_add_f32_e32 v222, v228, v230
		v_add_f32_e32 v223, v231, v233
		v_add_f32_e32 v224, v232, v234
		v_add_f32_e32 v225, v235, v237
		v_add_f32_e32 v226, v236, v238
		v_add_f32_e32 v227, v239, v241
		v_add_f32_e32 v228, v240, v242
		v_add_f32_e32 v229, v243, v244
		v_accvgpr_read_b32 v230, a64
		v_add_f32_e32 v230, v230, v245
		v_add_f32_e32 v213, v213, v215
		v_add_f32_e32 v214, v214, v218
		v_add_f32_e32 v215, v219, v221
		v_add_f32_e32 v218, v220, v222
		v_add_f32_e32 v219, v223, v225
		v_add_f32_e32 v220, v224, v226
		v_add_f32_e32 v221, v227, v229
		v_add_f32_e32 v222, v228, v230
		v_add_f32_e32 v213, v213, v215
		v_add_f32_e32 v214, v214, v218
		v_add_f32_e32 v215, v219, v221
		v_add_f32_e32 v218, v220, v222
		v_add_f32_e32 v213, v213, v215
		v_add_f32_e32 v214, v214, v218
		v_add_f32_e32 v215, v216, v217
		v_add_f32_e32 v216, v213, v214
		v_mov_b32_e32 v217, v216
		v_cvt_pk_bf16_f32 v220, v15, v16
		v_cvt_pk_bf16_f32 v221, v20, v23
		v_permlane32_swap_b32_e32 v216, v217
		v_add_f32_e32 v15, v216, v217
		v_add_f32_e32 v8, v8, v13
		v_add_f32_e32 v9, v9, v148
		v_exp_f32_e32 v8, v8
		v_exp_f32_e32 v9, v9
		v_cvt_pk_bf16_f32 v222, v24, v25
		v_fma_f32 v11, v11, v8, v215
		v_fma_f32 v18, v18, v9, v15
		v_cvt_pk_bf16_f32 v223, v26, v27
		v_cvt_pk_bf16_f32 v24, v28, v29
		v_cvt_pk_bf16_f32 v25, v30, v31
		v_cvt_pk_bf16_f32 v26, v112, v113
		v_cvt_pk_bf16_f32 v27, v114, v115
		v_cvt_pk_bf16_f32 v28, v116, v117
		v_cvt_pk_bf16_f32 v29, v118, v119
		v_cvt_pk_bf16_f32 v30, v120, v121
		v_cvt_pk_bf16_f32 v31, v122, v123
		v_cvt_pk_bf16_f32 v112, v124, v125
		v_cvt_pk_bf16_f32 v113, v126, v127
		v_cvt_pk_bf16_f32 v114, v128, v129
		v_cvt_pk_bf16_f32 v115, v130, v131
		v_cvt_pk_bf16_f32 v116, v96, v97
		v_mul_f32_e32 v32, v32, v8
		v_mul_f32_e32 v33, v33, v8
		v_mul_f32_e32 v34, v34, v8
		v_mul_f32_e32 v35, v35, v8
		v_mul_f32_e32 v36, v36, v8
		v_mul_f32_e32 v37, v37, v8
		v_mul_f32_e32 v38, v38, v8
		v_mul_f32_e32 v39, v39, v8
		v_mul_f32_e32 v40, v40, v8
		v_mul_f32_e32 v41, v41, v8
		v_mul_f32_e32 v42, v42, v8
		v_mul_f32_e32 v43, v43, v8
		v_mul_f32_e32 v44, v44, v8
		v_mul_f32_e32 v45, v45, v8
		v_mul_f32_e32 v46, v46, v8
		v_mul_f32_e32 v47, v47, v8
		v_mul_f32_e32 v48, v48, v8
		v_mul_f32_e32 v49, v49, v8
		v_mul_f32_e32 v50, v50, v8
		v_mul_f32_e32 v51, v51, v8
		v_mul_f32_e32 v52, v52, v8
		v_mul_f32_e32 v53, v53, v8
		v_mul_f32_e32 v54, v54, v8
		v_mul_f32_e32 v55, v55, v8
		v_mul_f32_e32 v56, v56, v8
		v_mul_f32_e32 v57, v57, v8
		v_mul_f32_e32 v58, v58, v8
		v_mul_f32_e32 v59, v59, v8
		v_mul_f32_e32 v60, v60, v8
		v_mul_f32_e32 v61, v61, v8
		v_mul_f32_e32 v62, v62, v8
		v_mul_f32_e32 v63, v63, v8
		v_mul_f32_e32 v64, v64, v9
		v_mul_f32_e32 v65, v65, v9
		v_mul_f32_e32 v66, v66, v9
		v_mul_f32_e32 v67, v67, v9
		v_mul_f32_e32 v68, v68, v9
		v_mul_f32_e32 v69, v69, v9
		v_mul_f32_e32 v70, v70, v9
		v_mul_f32_e32 v71, v71, v9
		v_mul_f32_e32 v72, v72, v9
		v_mul_f32_e32 v73, v73, v9
		v_mul_f32_e32 v74, v74, v9
		v_mul_f32_e32 v75, v75, v9
		v_mul_f32_e32 v76, v76, v9
		v_mul_f32_e32 v77, v77, v9
		v_mul_f32_e32 v78, v78, v9
		v_mul_f32_e32 v79, v79, v9
		v_mul_f32_e32 v80, v80, v9
		v_mul_f32_e32 v81, v81, v9
		v_mul_f32_e32 v82, v82, v9
		v_mul_f32_e32 v83, v83, v9
		v_mul_f32_e32 v84, v84, v9
		v_mul_f32_e32 v85, v85, v9
		v_mul_f32_e32 v86, v86, v9
		v_mul_f32_e32 v87, v87, v9
		v_mul_f32_e32 v88, v88, v9
		v_mul_f32_e32 v89, v89, v9
		v_mul_f32_e32 v90, v90, v9
		v_mul_f32_e32 v91, v91, v9
		v_mul_f32_e32 v92, v92, v9
		v_mul_f32_e32 v93, v93, v9
		v_mul_f32_e32 v94, v94, v9
		v_mul_f32_e32 v95, v95, v9
		v_cvt_pk_bf16_f32 v117, v98, v99
		v_cvt_pk_bf16_f32 v118, v100, v101
		v_cvt_pk_bf16_f32 v119, v102, v103
		v_cvt_pk_bf16_f32 v96, v104, v105
		v_cvt_pk_bf16_f32 v97, v106, v107
		v_cvt_pk_bf16_f32 v98, v108, v109
		v_cvt_pk_bf16_f32 v99, v110, v111
		v_cvt_pk_bf16_f32 v100, v132, v133
		v_cvt_pk_bf16_f32 v101, v134, v135
		v_cvt_pk_bf16_f32 v102, v136, v137
		v_cvt_pk_bf16_f32 v103, v138, v139
		v_cvt_pk_bf16_f32 v104, v140, v141
		v_cvt_pk_bf16_f32 v105, v142, v143
		v_cvt_pk_bf16_f32 v106, v144, v145
		v_cvt_pk_bf16_f32 v107, v146, v147
		v_cvt_pk_bf16_f32 v108, v149, v150
		v_cvt_pk_bf16_f32 v109, v151, v152
		v_cvt_pk_bf16_f32 v110, v153, v154
		v_cvt_pk_bf16_f32 v111, v155, v156
		v_cvt_pk_bf16_f32 v120, v157, v158
		v_cvt_pk_bf16_f32 v121, v159, v160
		v_cvt_pk_bf16_f32 v122, v161, v162
		v_cvt_pk_bf16_f32 v123, v163, v164
		v_cvt_pk_bf16_f32 v124, v165, v166
		v_cvt_pk_bf16_f32 v125, v167, v168
		v_cvt_pk_bf16_f32 v126, v169, v170
		v_cvt_pk_bf16_f32 v127, v171, v172
		v_cvt_pk_bf16_f32 v128, v173, v174
		v_cvt_pk_bf16_f32 v129, v175, v176
		v_cvt_pk_bf16_f32 v130, v177, v178
		v_cvt_pk_bf16_f32 v131, v179, v180
		v_cvt_pk_bf16_f32 v132, v181, v182
		v_cvt_pk_bf16_f32 v133, v183, v184
		v_cvt_pk_bf16_f32 v134, v185, v186
		v_cvt_pk_bf16_f32 v135, v187, v188
		v_cvt_pk_bf16_f32 v136, v189, v190
		v_cvt_pk_bf16_f32 v137, v191, v192
		v_cvt_pk_bf16_f32 v138, v193, v194
		v_cvt_pk_bf16_f32 v139, v195, v196
		v_cvt_pk_bf16_f32 v140, v197, v198
		v_cvt_pk_bf16_f32 v141, v199, v200
		v_cvt_pk_bf16_f32 v142, v201, v202
		v_cvt_pk_bf16_f32 v143, v203, v204
		v_cvt_pk_bf16_f32 v144, v205, v206
		v_cvt_pk_bf16_f32 v145, v207, v208
		v_cvt_pk_bf16_f32 v146, v209, v210
		v_cvt_pk_bf16_f32 v147, v211, v212
		v_permlane32_swap_b32_e32 v220, v222
		v_permlane32_swap_b32_e32 v221, v223
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[32:47], a[84:87], v[220:223], v[32:47]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[48:63], a[116:119], v[220:223], v[48:63]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[32:47], a[88:91], v[24:27], v[32:47]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[48:63], a[120:123], v[24:27], v[48:63]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[32:47], a[92:95], v[28:31], v[32:47]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[48:63], a[124:127], v[28:31], v[48:63]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[32:47], a[96:99], v[112:115], v[32:47]
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_mfma_f32_32x32x16_bf16 v[48:63], a[128:131], v[112:115], v[48:63]
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_mfma_f32_32x32x16_bf16 v[80:95], a[116:119], v[108:111], v[80:95]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[64:79], a[84:87], v[108:111], v[64:79]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[80:95], a[120:123], v[120:123], v[80:95]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[64:79], a[88:91], v[120:123], v[64:79]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[80:95], a[124:127], v[124:127], v[80:95]
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_mfma_f32_32x32x16_bf16 v[64:79], a[92:95], v[124:127], v[64:79]
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_mfma_f32_32x32x16_bf16 v[80:95], a[128:131], v[128:131], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[96:99], v[128:131], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[100:103], v[116:119], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[132:135], v[116:119], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[132:135], v[132:135], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[100:103], v[132:135], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[104:107], v[96:99], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[136:139], v[96:99], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[136:139], v[136:139], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[104:107], v[136:139], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[108:111], v[100:103], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[140:143], v[100:103], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[140:143], v[140:143], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[108:111], v[140:143], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[112:115], v[104:107], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[144:147], v[104:107], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[144:147], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[112:115], v[144:147], v[64:79]
		v_mov_b32_e32 v8, v1
		v_mov_b32_e32 v9, v3
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
		ds_read_b128 v[24:27], v5
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
		ds_read_b128 v[28:31], v5 offset:384
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
		v_mfma_f32_32x32x16_bf16 v[96:111], v[24:27], a[20:23], 0
		s_cmp_lt_i32 s1, s21
		v_mfma_f32_32x32x16_bf16 v[112:127], a[140:143], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[128:143], a[156:159], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[28:31], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[176:191], v[24:27], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[192:207], a[140:143], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[208:223], a[156:159], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[96:111], a[128:131], a[24:27], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[144:147], a[24:27], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[160:163], a[24:27], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[172:175], a[24:27], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[172:175], a[40:43], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[128:131], a[40:43], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[144:147], a[40:43], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[160:163], a[40:43], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[132:135], a[28:31], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[148:151], a[28:31], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[164:167], a[28:31], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[176:179], a[28:31], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[176:179], a[44:47], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[132:135], a[44:47], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[148:151], a[44:47], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[164:167], a[44:47], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[136:139], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[152:155], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[168:171], a[32:35], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[180:183], a[32:35], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[48:51], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[136:139], a[48:51], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[152:155], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[168:171], a[48:51], v[208:223]
		v_add_u32_e32 v5, s41, v10
		v_accvgpr_read_b32 v13, a14
		v_add_u32_e32 v13, s41, v13
		v_accvgpr_read_b32 v15, a15
		v_add_u32_e32 v15, s41, v15
		v_accvgpr_read_b32 v16, a64
		v_add_u32_e32 v16, s41, v16
		v_accvgpr_read_b32 v20, a67
		v_add_u32_e32 v20, s41, v20
		v_accvgpr_read_b32 v23, a68
		v_add_u32_e32 v23, s41, v23
		v_accvgpr_read_b32 v24, a71
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_read_b32 v25, a72
		v_add_u32_e32 v25, s41, v25
		v_accvgpr_read_b32 v26, a75
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_read_b32 v27, a76
		v_add_u32_e32 v27, s41, v27
		v_accvgpr_read_b32 v28, a79
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_read_b32 v29, a80
		v_add_u32_e32 v29, s41, v29
		v_accvgpr_read_b32 v30, a83
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_read_b32 v31, a84
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_read_b32 v224, a87
		v_add_u32_e32 v224, s41, v224
		v_accvgpr_read_b32 v225, a88
		v_add_u32_e32 v225, s41, v225
		v_accvgpr_read_b32 v226, a91
		v_add_u32_e32 v226, s41, v226
		v_accvgpr_read_b32 v227, a92
		v_add_u32_e32 v227, s41, v227
		v_accvgpr_read_b32 v228, a95
		v_add_u32_e32 v228, s41, v228
		v_accvgpr_read_b32 v229, a96
		v_add_u32_e32 v229, s41, v229
		v_accvgpr_read_b32 v230, a99
		v_add_u32_e32 v230, s41, v230
		v_accvgpr_read_b32 v231, a100
		v_add_u32_e32 v231, s41, v231
		v_accvgpr_read_b32 v232, a103
		v_add_u32_e32 v232, s41, v232
		v_accvgpr_read_b32 v233, a104
		v_add_u32_e32 v233, s41, v233
		v_accvgpr_read_b32 v234, a107
		v_add_u32_e32 v234, s41, v234
		v_accvgpr_read_b32 v235, a108
		v_add_u32_e32 v235, s41, v235
		v_accvgpr_read_b32 v236, a111
		v_add_u32_e32 v236, s41, v236
		v_accvgpr_read_b32 v237, a112
		v_add_u32_e32 v237, s41, v237
		v_accvgpr_read_b32 v238, a115
		v_add_u32_e32 v238, s41, v238
		v_accvgpr_read_b32 v239, a116
		v_add_u32_e32 v239, s41, v239
		v_accvgpr_read_b32 v240, a119
		v_add_u32_e32 v240, s41, v240
		v_accvgpr_read_b32 v241, a120
		v_add_u32_e32 v241, s41, v241
		v_accvgpr_read_b32 v242, a123
		v_add_u32_e32 v242, s41, v242
		v_accvgpr_write_b32 a125, v242
		v_accvgpr_read_b32 v242, a124
		v_add_u32_e32 v242, s41, v242
		v_accvgpr_write_b32 a126, v242
		v_cmp_ge_i32_e64 s[48:49], v1, v5
		v_cmp_ge_i32_e64 s[50:51], v1, v13
		v_cmp_ge_i32_e64 s[52:53], v1, v15
		v_cmp_ge_i32_e64 vcc, v1, v16
		v_accvgpr_read_b32 v242, a65
		v_add_u32_e32 v242, s41, v242
		v_accvgpr_read_b32 v243, a66
		v_add_u32_e32 v243, s41, v243
		v_cndmask_b32_e32 v99, v4, v99, vcc
		v_accvgpr_write_b32 a127, v99
		v_cmp_ge_i32_e64 s[54:55], v1, v242
		v_cmp_ge_i32_e64 s[56:57], v1, v243
		v_cmp_ge_i32_e64 s[58:59], v1, v20
		v_cmp_ge_i32_e64 vcc, v1, v23
		v_accvgpr_read_b32 v99, a69
		v_add_u32_e32 v99, s41, v99
		v_accvgpr_read_b32 v244, a70
		v_add_u32_e32 v244, s41, v244
		v_cndmask_b32_e32 v103, v4, v103, vcc
		v_accvgpr_write_b32 a128, v103
		v_cmp_ge_i32_e64 s[60:61], v1, v99
		v_cmp_ge_i32_e64 s[62:63], v1, v244
		v_cmp_ge_i32_e64 s[64:65], v1, v24
		v_cmp_ge_i32_e64 vcc, v1, v25
		v_accvgpr_read_b32 v103, a73
		v_add_u32_e32 v103, s41, v103
		v_accvgpr_read_b32 v245, a74
		v_add_u32_e32 v245, s41, v245
		v_cndmask_b32_e32 v107, v4, v107, vcc
		v_accvgpr_write_b32 a129, v107
		v_cmp_ge_i32_e64 s[66:67], v1, v103
		v_cmp_ge_i32_e64 s[68:69], v1, v245
		v_cmp_ge_i32_e64 s[70:71], v1, v26
		v_cmp_ge_i32_e64 vcc, v1, v27
		v_accvgpr_read_b32 v107, a77
		v_add_u32_e32 v107, s41, v107
		v_accvgpr_read_b32 v246, a78
		v_add_u32_e32 v246, s41, v246
		v_cndmask_b32_e32 v111, v4, v111, vcc
		v_accvgpr_write_b32 a130, v111
		v_cmp_ge_i32_e64 s[72:73], v1, v107
		v_cmp_ge_i32_e64 s[74:75], v1, v246
		v_cmp_ge_i32_e64 s[76:77], v1, v28
		v_cmp_ge_i32_e64 vcc, v1, v29
		v_accvgpr_read_b32 v111, a81
		v_add_u32_e32 v111, s41, v111
		v_accvgpr_read_b32 v247, a82
		v_add_u32_e32 v247, s41, v247
		v_cndmask_b32_e32 v115, v4, v115, vcc
		v_accvgpr_write_b32 a131, v115
		v_cmp_ge_i32_e64 s[78:79], v1, v111
		v_cmp_ge_i32_e64 s[80:81], v1, v247
		v_cmp_ge_i32_e64 s[82:83], v1, v30
		v_cmp_ge_i32_e64 vcc, v1, v31
		v_accvgpr_read_b32 v115, a85
		v_add_u32_e32 v115, s41, v115
		v_accvgpr_read_b32 v248, a86
		v_add_u32_e32 v248, s41, v248
		v_cndmask_b32_e32 v119, v4, v119, vcc
		v_accvgpr_write_b32 a132, v119
		v_cmp_ge_i32_e64 s[84:85], v1, v115
		v_cmp_ge_i32_e64 s[86:87], v1, v248
		v_cmp_ge_i32_e64 vcc, v1, v225
		v_accvgpr_read_b32 v119, a89
		v_add_u32_e32 v119, s41, v119
		v_accvgpr_read_b32 v249, a90
		v_add_u32_e32 v249, s41, v249
		v_cndmask_b32_e32 v123, v4, v123, vcc
		v_accvgpr_write_b32 a133, v123
		v_cmp_ge_i32_e64 vcc, v1, v227
		v_accvgpr_read_b32 v123, a93
		v_add_u32_e32 v123, s41, v123
		v_accvgpr_read_b32 v250, a94
		v_add_u32_e32 v250, s41, v250
		v_cndmask_b32_e32 v127, v4, v127, vcc
		v_accvgpr_write_b32 a134, v127
		v_cmp_ge_i32_e64 vcc, v1, v229
		v_accvgpr_read_b32 v127, a97
		v_add_u32_e32 v127, s41, v127
		v_accvgpr_read_b32 v251, a98
		v_add_u32_e32 v251, s41, v251
		v_cndmask_b32_e32 v131, v4, v131, vcc
		v_accvgpr_write_b32 a135, v131
		v_cmp_ge_i32_e64 vcc, v1, v231
		v_accvgpr_read_b32 v131, a101
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_read_b32 v252, a102
		v_add_u32_e32 v252, s41, v252
		v_cndmask_b32_e32 v135, v4, v135, vcc
		v_accvgpr_write_b32 a136, v135
		v_cmp_ge_i32_e64 vcc, v1, v233
		v_accvgpr_read_b32 v135, a105
		v_add_u32_e32 v135, s41, v135
		v_accvgpr_read_b32 v253, a106
		v_add_u32_e32 v253, s41, v253
		v_cndmask_b32_e32 v139, v4, v139, vcc
		v_accvgpr_write_b32 a137, v139
		v_cmp_ge_i32_e64 vcc, v1, v235
		v_cmp_ge_i32_e64 s[88:89], v1, v224
		v_cndmask_b32_e64 v96, v4, v96, s[48:49]
		v_accvgpr_write_b32 a138, v96
		v_cmp_ge_i32_e64 s[48:49], v1, v119
		v_cmp_ge_i32_e64 s[90:91], v1, v249
		v_cmp_ge_i32_e64 s[92:93], v1, v226
		s_nop 1
		v_mov_b32_e32 v254, s92
		v_mov_b32_e32 v255, s93
		v_accvgpr_write_b32 a140, v254
		v_accvgpr_write_b32 a141, v255
		v_cmp_ge_i32_e64 s[92:93], v1, v123
		s_nop 1
		v_mov_b32_e32 v254, s92
		v_mov_b32_e32 v255, s93
		v_accvgpr_write_b32 a142, v254
		v_accvgpr_write_b32 a143, v255
		v_cmp_ge_i32_e64 s[92:93], v1, v250
		s_nop 1
		v_mov_b32_e32 v254, s92
		v_mov_b32_e32 v255, s93
		v_accvgpr_write_b32 a144, v254
		v_accvgpr_write_b32 a145, v255
		v_cmp_ge_i32_e64 s[92:93], v1, v228
		s_nop 1
		v_mov_b32_e32 v254, s92
		v_mov_b32_e32 v255, s93
		v_accvgpr_write_b32 a146, v254
		v_accvgpr_write_b32 a147, v255
		v_cmp_ge_i32_e64 s[92:93], v1, v127
		s_nop 1
		v_mov_b32_e32 v254, s92
		v_mov_b32_e32 v255, s93
		v_accvgpr_write_b32 a148, v254
		v_accvgpr_write_b32 a149, v255
		v_cmp_ge_i32_e64 s[92:93], v1, v251
		s_nop 1
		v_mov_b32_e32 v254, s92
		v_mov_b32_e32 v255, s93
		v_accvgpr_write_b32 a150, v254
		v_accvgpr_write_b32 a151, v255
		v_cmp_ge_i32_e64 s[92:93], v1, v230
		s_nop 1
		v_mov_b32_e32 v254, s92
		v_mov_b32_e32 v255, s93
		v_accvgpr_write_b32 a152, v254
		v_accvgpr_write_b32 a153, v255
		v_cmp_ge_i32_e64 s[92:93], v1, v131
		s_nop 1
		v_mov_b32_e32 v254, s92
		v_mov_b32_e32 v255, s93
		v_accvgpr_write_b32 a154, v254
		v_accvgpr_write_b32 a155, v255
		v_cmp_ge_i32_e64 s[92:93], v1, v252
		s_nop 1
		v_mov_b32_e32 v254, s92
		v_mov_b32_e32 v255, s93
		v_accvgpr_write_b32 a156, v254
		v_accvgpr_write_b32 a157, v255
		v_cmp_ge_i32_e64 s[92:93], v1, v232
		v_cmp_ge_i32_e64 s[94:95], v1, v135
		v_cmp_ge_i32_e64 s[96:97], v1, v253
		v_cmp_ge_i32_e64 s[98:99], v1, v234
		v_cndmask_b32_e32 v96, v4, v143, vcc
		v_cndmask_b32_e64 v139, v4, v141, s[96:97]
		v_cndmask_b32_e64 v141, v4, v142, s[98:99]
		v_accvgpr_read_b32 v142, a109
		v_add_u32_e32 v142, s41, v142
		v_accvgpr_read_b32 v143, a110
		v_add_u32_e32 v143, s41, v143
		v_cmp_ge_i32_e64 s[96:97], v1, v142
		v_cmp_ge_i32_e64 s[98:99], v1, v143
		v_cmp_ge_i32_e64 s[100:101], v1, v236
		v_cndmask_b32_e64 v144, v4, v144, s[96:97]
		v_cndmask_b32_e64 v145, v4, v145, s[98:99]
		v_cndmask_b32_e64 v146, v4, v146, s[100:101]
		v_cmp_ge_i32_e64 vcc, v1, v237
		v_accvgpr_read_b32 v254, a113
		v_add_u32_e32 v254, s41, v254
		v_accvgpr_read_b32 v255, a114
		v_add_u32_e32 v255, s41, v255
		v_cndmask_b32_e32 v147, v4, v147, vcc
		v_cmp_ge_i32_e64 s[96:97], v1, v254
		v_cmp_ge_i32_e64 s[98:99], v1, v255
		v_cmp_ge_i32_e64 s[100:101], v1, v238
		v_cndmask_b32_e64 v148, v4, v148, s[96:97]
		v_cndmask_b32_e64 v149, v4, v149, s[98:99]
		v_accvgpr_write_b32 a139, v149
		v_cndmask_b32_e64 v149, v4, v150, s[100:101]
		v_accvgpr_write_b32 a158, v149
		v_cmp_ge_i32_e64 vcc, v1, v239
		v_accvgpr_read_b32 v149, a117
		v_add_u32_e32 v149, s41, v149
		v_accvgpr_read_b32 v150, a118
		v_add_u32_e32 v150, s41, v150
		v_cndmask_b32_e32 v151, v4, v151, vcc
		v_cmp_ge_i32_e64 s[96:97], v1, v149
		v_cmp_ge_i32_e64 s[98:99], v1, v150
		v_cmp_ge_i32_e64 s[100:101], v1, v240
		v_cndmask_b32_e64 v152, v4, v152, s[96:97]
		v_cndmask_b32_e64 v153, v4, v153, s[98:99]
		v_accvgpr_write_b32 a159, v153
		v_cndmask_b32_e64 v153, v4, v154, s[100:101]
		v_accvgpr_write_b32 a160, v153
		v_cmp_ge_i32_e64 vcc, v1, v241
		v_accvgpr_read_b32 v153, a121
		v_add_u32_e32 v153, s41, v153
		v_accvgpr_read_b32 v154, a122
		v_add_u32_e32 v154, s41, v154
		v_cndmask_b32_e32 v155, v4, v155, vcc
		v_accvgpr_write_b32 a161, v155
		v_cmp_ge_i32_e64 s[96:97], v1, v153
		v_cmp_ge_i32_e64 s[98:99], v1, v154
		v_accvgpr_read_b32 v155, a125
		v_cmp_ge_i32_e64 s[100:101], v1, v155
		v_cndmask_b32_e64 v155, v4, v156, s[96:97]
		v_cndmask_b32_e64 v156, v4, v157, s[98:99]
		v_cndmask_b32_e64 v157, v4, v158, s[100:101]
		v_accvgpr_write_b32 a162, v157
		v_cndmask_b32_e64 v97, v4, v97, s[50:51]
		v_accvgpr_read_b32 v157, a126
		v_cmp_ge_i32_e64 vcc, v1, v157
		v_max3_f32 v157, v144, v145, v146
		v_accvgpr_write_b32 a163, v157
		v_accvgpr_read_b32 v157, a158
		v_accvgpr_read_b32 v158, a139
		v_max3_f32 v157, v148, v158, v157
		v_cndmask_b32_e32 v158, v4, v159, vcc
		v_cmp_ge_i32_e64 s[50:51], v3, v5
		v_cmp_ge_i32_e64 s[96:97], v3, v13
		v_cmp_ge_i32_e64 s[98:99], v3, v15
		v_accvgpr_read_b32 v5, a160
		v_accvgpr_read_b32 v13, a159
		v_max3_f32 v5, v152, v13, v5
		v_accvgpr_read_b32 v13, a162
		v_max3_f32 v13, v155, v156, v13
		v_cndmask_b32_e64 v15, v4, v178, s[98:99]
		v_cmp_ge_i32_e64 vcc, v3, v16
		v_cndmask_b32_e64 v16, v4, v98, s[52:53]
		v_cndmask_b32_e64 v98, v4, v100, s[54:55]
		v_cndmask_b32_e32 v100, v4, v179, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v242
		v_cmp_ge_i32_e64 s[54:55], v3, v243
		v_cmp_ge_i32_e64 s[98:99], v3, v20
		v_cndmask_b32_e64 v20, v4, v180, s[52:53]
		v_cndmask_b32_e64 v159, v4, v181, s[54:55]
		v_cndmask_b32_e64 v178, v4, v182, s[98:99]
		v_cmp_ge_i32_e64 vcc, v3, v23
		v_cndmask_b32_e64 v23, v4, v101, s[56:57]
		v_cndmask_b32_e64 v101, v4, v102, s[58:59]
		v_cndmask_b32_e64 v102, v4, v104, s[60:61]
		v_cndmask_b32_e32 v104, v4, v183, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v99
		v_cmp_ge_i32_e64 s[54:55], v3, v244
		v_cmp_ge_i32_e64 s[56:57], v3, v24
		v_cndmask_b32_e64 v24, v4, v184, s[52:53]
		v_cndmask_b32_e64 v99, v4, v185, s[54:55]
		v_cndmask_b32_e64 v179, v4, v186, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v25
		v_cndmask_b32_e64 v25, v4, v105, s[62:63]
		v_accvgpr_read_b32 v105, a138
		v_max3_f32 v105, v105, v97, v16
		v_cndmask_b32_e32 v180, v4, v187, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v103
		v_cmp_ge_i32_e64 s[54:55], v3, v245
		v_cmp_ge_i32_e64 s[56:57], v3, v26
		v_cndmask_b32_e64 v26, v4, v188, s[52:53]
		v_cndmask_b32_e64 v103, v4, v189, s[54:55]
		v_cndmask_b32_e64 v181, v4, v190, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v27
		v_cndmask_b32_e64 v27, v4, v106, s[64:65]
		v_cndmask_b32_e64 v106, v4, v108, s[66:67]
		v_cndmask_b32_e32 v108, v4, v191, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v107
		v_cmp_ge_i32_e64 s[54:55], v3, v246
		v_cmp_ge_i32_e64 s[56:57], v3, v28
		v_cndmask_b32_e64 v28, v4, v192, s[52:53]
		v_cndmask_b32_e64 v107, v4, v193, s[54:55]
		v_cndmask_b32_e64 v182, v4, v194, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v29
		v_cndmask_b32_e64 v29, v4, v109, s[68:69]
		v_cndmask_b32_e64 v109, v4, v110, s[70:71]
		v_cndmask_b32_e64 v110, v4, v112, s[72:73]
		v_cndmask_b32_e32 v112, v4, v195, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v111
		v_cmp_ge_i32_e64 s[54:55], v3, v247
		v_cmp_ge_i32_e64 s[56:57], v3, v30
		v_cndmask_b32_e64 v30, v4, v196, s[52:53]
		v_cndmask_b32_e64 v111, v4, v197, s[54:55]
		v_cndmask_b32_e64 v183, v4, v198, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v31
		v_cndmask_b32_e64 v31, v4, v113, s[74:75]
		v_max3_f32 v113, v98, v23, v101
		v_cndmask_b32_e32 v184, v4, v199, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v115
		v_cmp_ge_i32_e64 s[54:55], v3, v248
		v_cmp_ge_i32_e64 s[56:57], v3, v224
		v_cndmask_b32_e64 v115, v4, v200, s[52:53]
		v_cndmask_b32_e64 v185, v4, v201, s[54:55]
		v_cndmask_b32_e64 v186, v4, v202, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v225
		v_cndmask_b32_e64 v114, v4, v114, s[76:77]
		v_cndmask_b32_e64 v116, v4, v116, s[78:79]
		v_cndmask_b32_e32 v187, v4, v203, vcc
		v_cmp_ge_i32_e64 vcc, v3, v227
		v_cmp_ge_i32_e64 s[52:53], v3, v119
		v_cmp_ge_i32_e64 s[54:55], v3, v249
		v_cmp_ge_i32_e64 s[56:57], v3, v226
		v_cndmask_b32_e64 v119, v4, v204, s[52:53]
		v_cndmask_b32_e64 v188, v4, v205, s[54:55]
		v_cndmask_b32_e64 v189, v4, v206, s[56:57]
		v_cndmask_b32_e64 v117, v4, v117, s[80:81]
		v_cndmask_b32_e64 v118, v4, v118, s[82:83]
		v_cndmask_b32_e32 v190, v4, v207, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v123
		v_cmp_ge_i32_e64 s[54:55], v3, v250
		v_cmp_ge_i32_e64 vcc, v3, v229
		v_cmp_ge_i32_e64 s[56:57], v3, v228
		v_cndmask_b32_e64 v123, v4, v208, s[52:53]
		v_cndmask_b32_e64 v191, v4, v209, s[54:55]
		v_cndmask_b32_e64 v192, v4, v210, s[56:57]
		v_cndmask_b32_e64 v120, v4, v120, s[84:85]
		v_cndmask_b32_e64 v121, v4, v121, s[86:87]
		v_cndmask_b32_e32 v193, v4, v211, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v127
		v_cmp_ge_i32_e64 s[54:55], v3, v251
		v_cmp_ge_i32_e64 s[56:57], v3, v230
		v_cndmask_b32_e64 v127, v4, v212, s[52:53]
		v_cndmask_b32_e64 v194, v4, v213, s[54:55]
		v_cndmask_b32_e64 v195, v4, v214, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v231
		v_cndmask_b32_e64 v122, v4, v122, s[88:89]
		v_cndmask_b32_e64 v124, v4, v124, s[48:49]
		v_cndmask_b32_e32 v196, v4, v215, vcc
		v_cmp_ge_i32_e64 s[48:49], v3, v131
		v_cmp_ge_i32_e64 s[52:53], v3, v252
		v_cmp_ge_i32_e64 s[54:55], v3, v232
		v_cndmask_b32_e64 v131, v4, v216, s[48:49]
		v_cndmask_b32_e64 v197, v4, v217, s[52:53]
		v_cndmask_b32_e64 v198, v4, v218, s[54:55]
		v_cmp_ge_i32_e64 vcc, v3, v233
		v_cndmask_b32_e64 v125, v4, v125, s[90:91]
		v_accvgpr_read_b32 v199, a140
		s_nop 0
		v_readfirstlane_b32 s48, v199
		v_accvgpr_read_b32 v199, a141
		s_nop 0
		v_readfirstlane_b32 s49, v199
		s_nop 1
		v_cndmask_b32_e64 v126, v4, v126, s[48:49]
		v_cndmask_b32_e32 v199, v4, v219, vcc
		v_cmp_ge_i32_e64 s[48:49], v3, v135
		v_cmp_ge_i32_e64 s[52:53], v3, v253
		v_cmp_ge_i32_e64 s[54:55], v3, v234
		v_cndmask_b32_e64 v135, v4, v220, s[48:49]
		v_cndmask_b32_e64 v200, v4, v221, s[52:53]
		v_cndmask_b32_e64 v201, v4, v222, s[54:55]
		v_cmp_ge_i32_e64 vcc, v3, v235
		v_accvgpr_read_b32 v202, a142
		s_nop 0
		v_readfirstlane_b32 s48, v202
		v_accvgpr_read_b32 v202, a143
		s_nop 0
		v_readfirstlane_b32 s49, v202
		s_nop 1
		v_cndmask_b32_e64 v128, v4, v128, s[48:49]
		v_accvgpr_read_b32 v202, a144
		s_nop 0
		v_readfirstlane_b32 s48, v202
		v_accvgpr_read_b32 v202, a145
		s_nop 0
		v_readfirstlane_b32 s49, v202
		s_nop 1
		v_cndmask_b32_e64 v129, v4, v129, s[48:49]
		v_cndmask_b32_e32 v202, v4, v223, vcc
		v_cmp_ge_i32_e64 s[48:49], v3, v142
		v_cmp_ge_i32_e64 s[52:53], v3, v143
		v_cmp_ge_i32_e64 s[54:55], v3, v236
		v_cndmask_b32_e64 v142, v4, v160, s[48:49]
		v_cndmask_b32_e64 v143, v4, v161, s[52:53]
		v_cndmask_b32_e64 v160, v4, v162, s[54:55]
		v_cmp_ge_i32_e64 vcc, v3, v237
		v_accvgpr_read_b32 v161, a146
		s_nop 0
		v_readfirstlane_b32 s48, v161
		v_accvgpr_read_b32 v161, a147
		s_nop 0
		v_readfirstlane_b32 s49, v161
		s_nop 1
		v_cndmask_b32_e64 v130, v4, v130, s[48:49]
		v_accvgpr_read_b32 v161, a148
		s_nop 0
		v_readfirstlane_b32 s48, v161
		v_accvgpr_read_b32 v161, a149
		s_nop 0
		v_readfirstlane_b32 s49, v161
		s_nop 1
		v_cndmask_b32_e64 v132, v4, v132, s[48:49]
		v_cndmask_b32_e32 v161, v4, v163, vcc
		v_cmp_ge_i32_e64 s[48:49], v3, v254
		v_cmp_ge_i32_e64 s[52:53], v3, v255
		v_cmp_ge_i32_e64 s[54:55], v3, v238
		v_cndmask_b32_e64 v162, v4, v164, s[48:49]
		v_cndmask_b32_e64 v163, v4, v165, s[52:53]
		v_cndmask_b32_e64 v164, v4, v166, s[54:55]
		v_cmp_ge_i32_e64 vcc, v3, v239
		v_accvgpr_read_b32 v165, a150
		s_nop 0
		v_readfirstlane_b32 s48, v165
		v_accvgpr_read_b32 v165, a151
		s_nop 0
		v_readfirstlane_b32 s49, v165
		s_nop 1
		v_cndmask_b32_e64 v133, v4, v133, s[48:49]
		v_accvgpr_read_b32 v165, a152
		s_nop 0
		v_readfirstlane_b32 s48, v165
		v_accvgpr_read_b32 v165, a153
		s_nop 0
		v_readfirstlane_b32 s49, v165
		s_nop 1
		v_cndmask_b32_e64 v134, v4, v134, s[48:49]
		v_cndmask_b32_e32 v165, v4, v167, vcc
		v_cmp_ge_i32_e64 s[48:49], v3, v149
		v_cmp_ge_i32_e64 s[52:53], v3, v150
		v_cmp_ge_i32_e64 s[54:55], v3, v240
		v_cndmask_b32_e64 v149, v4, v168, s[48:49]
		v_cndmask_b32_e64 v150, v4, v169, s[52:53]
		v_cndmask_b32_e64 v166, v4, v170, s[54:55]
		v_cmp_ge_i32_e64 vcc, v3, v241
		v_accvgpr_read_b32 v167, a154
		s_nop 0
		v_readfirstlane_b32 s48, v167
		v_accvgpr_read_b32 v167, a155
		s_nop 0
		v_readfirstlane_b32 s49, v167
		s_nop 1
		v_cndmask_b32_e64 v136, v4, v136, s[48:49]
		v_accvgpr_read_b32 v167, a156
		s_nop 0
		v_readfirstlane_b32 s48, v167
		v_accvgpr_read_b32 v167, a157
		s_nop 0
		v_readfirstlane_b32 s49, v167
		s_nop 1
		v_cndmask_b32_e64 v137, v4, v137, s[48:49]
		v_cndmask_b32_e32 v167, v4, v171, vcc
		v_cmp_ge_i32_e64 s[48:49], v3, v153
		v_cmp_ge_i32_e64 s[52:53], v3, v154
		v_accvgpr_read_b32 v153, a125
		v_cmp_ge_i32_e64 s[54:55], v3, v153
		v_cndmask_b32_e64 v153, v4, v172, s[48:49]
		v_cndmask_b32_e64 v154, v4, v173, s[52:53]
		v_cndmask_b32_e64 v168, v4, v174, s[54:55]
		v_accvgpr_read_b32 v169, a126
		v_cmp_ge_i32_e64 vcc, v3, v169
		v_cndmask_b32_e64 v138, v4, v138, s[92:93]
		v_cndmask_b32_e64 v140, v4, v140, s[94:95]
		v_cndmask_b32_e32 v169, v4, v175, vcc
		v_max3_f32 v170, v102, v25, v27
		v_max3_f32 v171, v106, v29, v109
		v_max3_f32 v172, v110, v31, v114
		v_max3_f32 v173, v116, v117, v118
		v_max3_f32 v174, v120, v121, v122
		v_max3_f32 v175, v124, v125, v126
		v_max3_f32 v203, v128, v129, v130
		v_max3_f32 v204, v132, v133, v134
		v_max3_f32 v205, v136, v137, v138
		v_max3_f32 v206, v140, v139, v141
		v_accvgpr_read_b32 v207, a127
		v_max3_f32 v105, v105, v207, v113
		v_accvgpr_read_b32 v113, a129
		v_max3_f32 v113, v170, v113, v171
		v_accvgpr_read_b32 v170, a131
		v_max3_f32 v170, v172, v170, v173
		v_accvgpr_read_b32 v171, a133
		v_max3_f32 v171, v174, v171, v175
		v_accvgpr_read_b32 v172, a135
		v_max3_f32 v172, v203, v172, v204
		v_accvgpr_read_b32 v173, a137
		v_max3_f32 v173, v205, v173, v206
		v_accvgpr_read_b32 v174, a163
		v_max3_f32 v157, v174, v147, v157
		v_accvgpr_read_b32 v174, a161
		v_max3_f32 v5, v5, v174, v13
		v_accvgpr_read_b32 v13, a128
		v_max3_f32 v13, v105, v13, v113
		v_accvgpr_read_b32 v105, a132
		v_max3_f32 v105, v170, v105, v171
		v_accvgpr_read_b32 v113, a136
		v_max3_f32 v113, v172, v113, v173
		v_max3_f32 v5, v157, v151, v5
		v_accvgpr_read_b32 v157, a130
		v_max3_f32 v13, v13, v157, v105
		v_max3_f32 v5, v113, v96, v5
		v_accvgpr_read_b32 v105, a134
		v_max3_f32 v5, v13, v105, v5
		v_max_f32_e32 v170, v5, v158
		v_mov_b32_e32 v171, v170
		v_cndmask_b32_e64 v5, v4, v176, s[50:51]
		v_cndmask_b32_e64 v13, v4, v177, s[96:97]
		v_permlane32_swap_b32_e32 v170, v171
		v_max3_f32 v105, v5, v13, v15
		v_max3_f32 v113, v20, v159, v178
		v_max3_f32 v157, v24, v99, v179
		v_max3_f32 v172, v26, v103, v181
		v_max3_f32 v173, v28, v107, v182
		v_max3_f32 v174, v30, v111, v183
		v_max3_f32 v175, v115, v185, v186
		v_max3_f32 v176, v119, v188, v189
		v_max3_f32 v177, v123, v191, v192
		v_max3_f32 v203, v127, v194, v195
		v_max3_f32 v204, v131, v197, v198
		v_max3_f32 v205, v135, v200, v201
		v_max3_f32 v206, v142, v143, v160
		v_max3_f32 v207, v162, v163, v164
		v_max3_f32 v208, v149, v150, v166
		v_max3_f32 v209, v153, v154, v168
		v_max3_f32 v105, v105, v100, v113
		v_max3_f32 v113, v157, v180, v172
		v_max3_f32 v157, v173, v112, v174
		v_max3_f32 v172, v175, v187, v176
		v_max3_f32 v173, v177, v193, v203
		v_max3_f32 v174, v204, v199, v205
		v_max3_f32 v175, v206, v161, v207
		v_max3_f32 v176, v208, v167, v209
		v_max3_f32 v105, v105, v104, v113
		v_max3_f32 v113, v157, v184, v172
		v_max3_f32 v157, v173, v196, v174
		v_max3_f32 v172, v175, v165, v176
		v_max3_f32 v105, v105, v108, v113
		v_max3_f32 v113, v157, v202, v172
		v_max3_f32 v105, v105, v190, v113
		v_max_f32_e32 v172, v105, v169
		v_mov_b32_e32 v173, v172
		v_max_f32_e32 v105, v170, v171
		v_mul_f32_e32 v105, v105, v2
		v_permlane32_swap_b32_e32 v172, v173
		v_max_f32_e32 v113, v172, v173
		v_mul_f32_e32 v113, v113, v2
		v_max_f32_e32 v105, v8, v105
		v_max_f32_e32 v113, v9, v113
		v_xor_b32_e32 v157, 0x80000000, v105
		v_accvgpr_read_b32 v170, a138
		v_fma_f32 v170, v170, v2, v157
		v_fma_f32 v97, v97, v2, v157
		v_fma_f32 v16, v16, v2, v157
		v_accvgpr_read_b32 v171, a127
		v_fma_f32 v171, v171, v2, v157
		v_fma_f32 v98, v98, v2, v157
		v_fma_f32 v23, v23, v2, v157
		v_fma_f32 v101, v101, v2, v157
		v_accvgpr_read_b32 v172, a128
		v_fma_f32 v172, v172, v2, v157
		v_fma_f32 v102, v102, v2, v157
		v_fma_f32 v25, v25, v2, v157
		v_fma_f32 v27, v27, v2, v157
		v_accvgpr_read_b32 v173, a129
		v_fma_f32 v173, v173, v2, v157
		v_fma_f32 v106, v106, v2, v157
		v_fma_f32 v29, v29, v2, v157
		v_fma_f32 v109, v109, v2, v157
		v_accvgpr_read_b32 v174, a130
		v_fma_f32 v174, v174, v2, v157
		v_fma_f32 v110, v110, v2, v157
		v_fma_f32 v31, v31, v2, v157
		v_fma_f32 v114, v114, v2, v157
		v_accvgpr_read_b32 v175, a131
		v_fma_f32 v175, v175, v2, v157
		v_fma_f32 v116, v116, v2, v157
		v_fma_f32 v117, v117, v2, v157
		v_fma_f32 v118, v118, v2, v157
		v_accvgpr_read_b32 v176, a132
		v_fma_f32 v176, v176, v2, v157
		v_fma_f32 v120, v120, v2, v157
		v_fma_f32 v121, v121, v2, v157
		v_fma_f32 v122, v122, v2, v157
		v_accvgpr_read_b32 v177, a133
		v_fma_f32 v177, v177, v2, v157
		v_fma_f32 v124, v124, v2, v157
		v_fma_f32 v125, v125, v2, v157
		v_fma_f32 v126, v126, v2, v157
		v_accvgpr_read_b32 v203, a134
		v_fma_f32 v203, v203, v2, v157
		v_fma_f32 v128, v128, v2, v157
		v_fma_f32 v129, v129, v2, v157
		v_fma_f32 v130, v130, v2, v157
		v_accvgpr_read_b32 v204, a135
		v_fma_f32 v204, v204, v2, v157
		v_fma_f32 v132, v132, v2, v157
		v_fma_f32 v133, v133, v2, v157
		v_fma_f32 v134, v134, v2, v157
		v_accvgpr_read_b32 v205, a136
		v_fma_f32 v205, v205, v2, v157
		v_fma_f32 v136, v136, v2, v157
		v_fma_f32 v137, v137, v2, v157
		v_fma_f32 v138, v138, v2, v157
		v_accvgpr_read_b32 v206, a137
		v_fma_f32 v206, v206, v2, v157
		v_fma_f32 v140, v140, v2, v157
		v_fma_f32 v139, v139, v2, v157
		v_fma_f32 v141, v141, v2, v157
		v_fma_f32 v96, v96, v2, v157
		v_fma_f32 v144, v144, v2, v157
		v_fma_f32 v145, v145, v2, v157
		v_fma_f32 v146, v146, v2, v157
		v_fma_f32 v147, v147, v2, v157
		v_fma_f32 v148, v148, v2, v157
		v_accvgpr_read_b32 v207, a139
		v_fma_f32 v207, v207, v2, v157
		v_accvgpr_read_b32 v208, a158
		v_fma_f32 v208, v208, v2, v157
		v_fma_f32 v151, v151, v2, v157
		v_fma_f32 v152, v152, v2, v157
		v_accvgpr_read_b32 v209, a159
		v_fma_f32 v209, v209, v2, v157
		v_accvgpr_read_b32 v210, a160
		v_fma_f32 v210, v210, v2, v157
		v_accvgpr_read_b32 v211, a161
		v_fma_f32 v211, v211, v2, v157
		v_fma_f32 v155, v155, v2, v157
		v_fma_f32 v156, v156, v2, v157
		v_accvgpr_read_b32 v212, a162
		v_fma_f32 v212, v212, v2, v157
		v_fma_f32 v158, v158, v2, v157
		v_xor_b32_e32 v213, 0x80000000, v113
		v_fma_f32 v5, v5, v2, v213
		v_fma_f32 v13, v13, v2, v213
		v_fma_f32 v15, v15, v2, v213
		v_fma_f32 v100, v100, v2, v213
		v_fma_f32 v20, v20, v2, v213
		v_fma_f32 v159, v159, v2, v213
		v_fma_f32 v178, v178, v2, v213
		v_fma_f32 v104, v104, v2, v213
		v_fma_f32 v24, v24, v2, v213
		v_fma_f32 v99, v99, v2, v213
		v_fma_f32 v179, v179, v2, v213
		v_fma_f32 v180, v180, v2, v213
		v_fma_f32 v26, v26, v2, v213
		v_fma_f32 v103, v103, v2, v213
		v_fma_f32 v181, v181, v2, v213
		v_fma_f32 v108, v108, v2, v213
		v_fma_f32 v28, v28, v2, v213
		v_fma_f32 v107, v107, v2, v213
		v_fma_f32 v182, v182, v2, v213
		v_fma_f32 v112, v112, v2, v213
		v_fma_f32 v30, v30, v2, v213
		v_fma_f32 v111, v111, v2, v213
		v_fma_f32 v183, v183, v2, v213
		v_fma_f32 v184, v184, v2, v213
		v_fma_f32 v115, v115, v2, v213
		v_fma_f32 v185, v185, v2, v213
		v_fma_f32 v186, v186, v2, v213
		v_fma_f32 v187, v187, v2, v213
		v_fma_f32 v119, v119, v2, v213
		v_fma_f32 v188, v188, v2, v213
		v_fma_f32 v189, v189, v2, v213
		v_fma_f32 v190, v190, v2, v213
		v_fma_f32 v123, v123, v2, v213
		v_fma_f32 v191, v191, v2, v213
		v_fma_f32 v192, v192, v2, v213
		v_fma_f32 v193, v193, v2, v213
		v_fma_f32 v127, v127, v2, v213
		v_fma_f32 v194, v194, v2, v213
		v_fma_f32 v195, v195, v2, v213
		v_fma_f32 v196, v196, v2, v213
		v_fma_f32 v131, v131, v2, v213
		v_fma_f32 v197, v197, v2, v213
		v_fma_f32 v198, v198, v2, v213
		v_fma_f32 v199, v199, v2, v213
		v_fma_f32 v135, v135, v2, v213
		v_fma_f32 v200, v200, v2, v213
		v_fma_f32 v201, v201, v2, v213
		v_fma_f32 v202, v202, v2, v213
		v_fma_f32 v142, v142, v2, v213
		v_fma_f32 v143, v143, v2, v213
		v_fma_f32 v160, v160, v2, v213
		v_fma_f32 v161, v161, v2, v213
		v_fma_f32 v162, v162, v2, v213
		v_fma_f32 v163, v163, v2, v213
		v_fma_f32 v164, v164, v2, v213
		v_fma_f32 v165, v165, v2, v213
		v_fma_f32 v149, v149, v2, v213
		v_fma_f32 v150, v150, v2, v213
		v_fma_f32 v166, v166, v2, v213
		v_fma_f32 v167, v167, v2, v213
		v_fma_f32 v153, v153, v2, v213
		v_fma_f32 v154, v154, v2, v213
		v_fma_f32 v168, v168, v2, v213
		v_fma_f32 v169, v169, v2, v213
		v_exp_f32_e32 v170, v170
		v_exp_f32_e32 v97, v97
		v_exp_f32_e32 v16, v16
		v_exp_f32_e32 v171, v171
		v_exp_f32_e32 v98, v98
		v_exp_f32_e32 v23, v23
		v_exp_f32_e32 v101, v101
		v_exp_f32_e32 v172, v172
		v_exp_f32_e32 v102, v102
		v_exp_f32_e32 v25, v25
		v_exp_f32_e32 v27, v27
		v_exp_f32_e32 v173, v173
		v_exp_f32_e32 v106, v106
		v_exp_f32_e32 v29, v29
		v_exp_f32_e32 v109, v109
		v_exp_f32_e32 v174, v174
		v_exp_f32_e32 v110, v110
		v_exp_f32_e32 v31, v31
		v_exp_f32_e32 v114, v114
		v_exp_f32_e32 v175, v175
		v_exp_f32_e32 v116, v116
		v_exp_f32_e32 v117, v117
		v_exp_f32_e32 v118, v118
		v_exp_f32_e32 v176, v176
		v_exp_f32_e32 v120, v120
		v_exp_f32_e32 v121, v121
		v_exp_f32_e32 v122, v122
		v_exp_f32_e32 v177, v177
		v_exp_f32_e32 v124, v124
		v_exp_f32_e32 v125, v125
		v_exp_f32_e32 v126, v126
		v_exp_f32_e32 v203, v203
		v_exp_f32_e32 v128, v128
		v_exp_f32_e32 v129, v129
		v_exp_f32_e32 v130, v130
		v_exp_f32_e32 v204, v204
		v_exp_f32_e32 v132, v132
		v_exp_f32_e32 v133, v133
		v_exp_f32_e32 v134, v134
		v_exp_f32_e32 v205, v205
		v_exp_f32_e32 v136, v136
		v_exp_f32_e32 v137, v137
		v_exp_f32_e32 v138, v138
		v_exp_f32_e32 v206, v206
		v_exp_f32_e32 v140, v140
		v_exp_f32_e32 v139, v139
		v_exp_f32_e32 v141, v141
		v_exp_f32_e32 v96, v96
		v_exp_f32_e32 v144, v144
		v_exp_f32_e32 v145, v145
		v_exp_f32_e32 v146, v146
		v_exp_f32_e32 v147, v147
		v_exp_f32_e32 v148, v148
		v_exp_f32_e32 v207, v207
		v_exp_f32_e32 v208, v208
		v_exp_f32_e32 v151, v151
		v_exp_f32_e32 v152, v152
		v_exp_f32_e32 v209, v209
		v_exp_f32_e32 v210, v210
		v_exp_f32_e32 v211, v211
		v_exp_f32_e32 v155, v155
		v_exp_f32_e32 v156, v156
		v_exp_f32_e32 v212, v212
		v_exp_f32_e32 v158, v158
		v_exp_f32_e32 v15, v15
		v_exp_f32_e32 v100, v100
		v_exp_f32_e32 v20, v20
		v_exp_f32_e32 v159, v159
		v_exp_f32_e32 v178, v178
		v_exp_f32_e32 v104, v104
		v_exp_f32_e32 v24, v24
		v_exp_f32_e32 v99, v99
		v_exp_f32_e32 v179, v179
		v_exp_f32_e32 v180, v180
		v_exp_f32_e32 v26, v26
		v_exp_f32_e32 v103, v103
		v_exp_f32_e32 v181, v181
		v_exp_f32_e32 v108, v108
		v_exp_f32_e32 v28, v28
		v_exp_f32_e32 v107, v107
		v_exp_f32_e32 v182, v182
		v_exp_f32_e32 v112, v112
		v_exp_f32_e32 v30, v30
		v_exp_f32_e32 v111, v111
		v_exp_f32_e32 v183, v183
		v_exp_f32_e32 v184, v184
		v_exp_f32_e32 v115, v115
		v_exp_f32_e32 v185, v185
		v_exp_f32_e32 v186, v186
		v_exp_f32_e32 v187, v187
		v_exp_f32_e32 v119, v119
		v_exp_f32_e32 v188, v188
		v_exp_f32_e32 v189, v189
		v_exp_f32_e32 v190, v190
		v_exp_f32_e32 v123, v123
		v_exp_f32_e32 v191, v191
		v_exp_f32_e32 v192, v192
		v_exp_f32_e32 v193, v193
		v_exp_f32_e32 v127, v127
		v_exp_f32_e32 v194, v194
		v_exp_f32_e32 v195, v195
		v_exp_f32_e32 v196, v196
		v_exp_f32_e32 v131, v131
		v_exp_f32_e32 v197, v197
		v_exp_f32_e32 v198, v198
		v_exp_f32_e32 v199, v199
		v_exp_f32_e32 v135, v135
		v_exp_f32_e32 v200, v200
		v_exp_f32_e32 v201, v201
		v_exp_f32_e32 v202, v202
		v_exp_f32_e32 v142, v142
		v_exp_f32_e32 v143, v143
		v_exp_f32_e32 v160, v160
		v_exp_f32_e32 v161, v161
		v_exp_f32_e32 v162, v162
		v_exp_f32_e32 v163, v163
		v_exp_f32_e32 v164, v164
		v_exp_f32_e32 v165, v165
		v_exp_f32_e32 v149, v149
		v_exp_f32_e32 v150, v150
		v_exp_f32_e32 v166, v166
		v_exp_f32_e32 v167, v167
		v_exp_f32_e32 v153, v153
		v_exp_f32_e32 v154, v154
		v_exp_f32_e32 v168, v168
		v_exp_f32_e32 v169, v169
		v_add_f32_e32 v214, v170, v97
		v_add_f32_e32 v215, v128, v129
		v_add_f32_e32 v216, v16, v171
		v_add_f32_e32 v217, v130, v204
		v_add_f32_e32 v218, v98, v23
		v_add_f32_e32 v219, v132, v133
		v_add_f32_e32 v220, v101, v172
		v_add_f32_e32 v221, v134, v205
		v_add_f32_e32 v222, v102, v25
		v_add_f32_e32 v223, v136, v137
		v_add_f32_e32 v224, v27, v173
		v_add_f32_e32 v225, v138, v206
		v_add_f32_e32 v226, v106, v29
		v_add_f32_e32 v227, v140, v139
		v_add_f32_e32 v228, v109, v174
		v_add_f32_e32 v229, v141, v96
		v_add_f32_e32 v230, v110, v31
		v_add_f32_e32 v231, v144, v145
		v_add_f32_e32 v232, v114, v175
		v_add_f32_e32 v233, v146, v147
		v_add_f32_e32 v234, v116, v117
		v_add_f32_e32 v235, v148, v207
		v_add_f32_e32 v236, v118, v176
		v_add_f32_e32 v237, v208, v151
		v_add_f32_e32 v238, v120, v121
		v_add_f32_e32 v239, v152, v209
		v_add_f32_e32 v240, v122, v177
		v_add_f32_e32 v241, v210, v211
		v_add_f32_e32 v242, v124, v125
		v_add_f32_e32 v243, v155, v156
		v_add_f32_e32 v244, v126, v203
		v_add_f32_e32 v245, v212, v158
		v_add_f32_e32 v214, v214, v216
		v_add_f32_e32 v215, v215, v217
		v_add_f32_e32 v216, v218, v220
		v_add_f32_e32 v217, v219, v221
		v_add_f32_e32 v218, v222, v224
		v_add_f32_e32 v219, v223, v225
		v_add_f32_e32 v220, v226, v228
		v_add_f32_e32 v221, v227, v229
		v_add_f32_e32 v222, v230, v232
		v_add_f32_e32 v223, v231, v233
		v_add_f32_e32 v224, v234, v236
		v_add_f32_e32 v225, v235, v237
		v_add_f32_e32 v226, v238, v240
		v_add_f32_e32 v227, v239, v241
		v_add_f32_e32 v228, v242, v244
		v_add_f32_e32 v229, v243, v245
		v_add_f32_e32 v214, v214, v216
		v_add_f32_e32 v215, v215, v217
		v_add_f32_e32 v216, v218, v220
		v_add_f32_e32 v217, v219, v221
		v_add_f32_e32 v218, v222, v224
		v_add_f32_e32 v219, v223, v225
		v_add_f32_e32 v220, v226, v228
		v_add_f32_e32 v221, v227, v229
		v_add_f32_e32 v214, v214, v216
		v_add_f32_e32 v215, v215, v217
		v_add_f32_e32 v216, v218, v220
		v_add_f32_e32 v217, v219, v221
		v_add_f32_e32 v214, v214, v216
		v_add_f32_e32 v215, v215, v217
		v_add_f32_e32 v216, v214, v215
		v_mov_b32_e32 v217, v216
		v_exp_f32_e32 v5, v5
		v_exp_f32_e32 v13, v13
		v_permlane32_swap_b32_e32 v216, v217
		v_add_f32_e32 v214, v5, v13
		v_add_f32_e32 v215, v123, v191
		v_add_f32_e32 v218, v15, v100
		v_add_f32_e32 v219, v192, v193
		v_add_f32_e32 v220, v20, v159
		v_add_f32_e32 v221, v127, v194
		v_add_f32_e32 v222, v178, v104
		v_add_f32_e32 v223, v195, v196
		v_add_f32_e32 v224, v24, v99
		v_add_f32_e32 v225, v131, v197
		v_add_f32_e32 v226, v179, v180
		v_add_f32_e32 v227, v198, v199
		v_add_f32_e32 v228, v26, v103
		v_add_f32_e32 v229, v135, v200
		v_add_f32_e32 v230, v181, v108
		v_add_f32_e32 v231, v201, v202
		v_add_f32_e32 v232, v28, v107
		v_add_f32_e32 v233, v142, v143
		v_add_f32_e32 v234, v182, v112
		v_add_f32_e32 v235, v160, v161
		v_add_f32_e32 v236, v30, v111
		v_add_f32_e32 v237, v162, v163
		v_add_f32_e32 v238, v183, v184
		v_add_f32_e32 v239, v164, v165
		v_add_f32_e32 v240, v115, v185
		v_add_f32_e32 v241, v149, v150
		v_add_f32_e32 v242, v186, v187
		v_add_f32_e32 v243, v166, v167
		v_add_f32_e32 v244, v119, v188
		v_add_f32_e32 v245, v153, v154
		v_add_f32_e32 v246, v189, v190
		v_add_f32_e32 v247, v168, v169
		v_add_f32_e32 v214, v214, v218
		v_add_f32_e32 v215, v215, v219
		v_add_f32_e32 v218, v220, v222
		v_add_f32_e32 v219, v221, v223
		v_add_f32_e32 v220, v224, v226
		v_add_f32_e32 v221, v225, v227
		v_add_f32_e32 v222, v228, v230
		v_add_f32_e32 v223, v229, v231
		v_add_f32_e32 v224, v232, v234
		v_add_f32_e32 v225, v233, v235
		v_add_f32_e32 v226, v236, v238
		v_add_f32_e32 v227, v237, v239
		v_add_f32_e32 v228, v240, v242
		v_add_f32_e32 v229, v241, v243
		v_add_f32_e32 v230, v244, v246
		v_add_f32_e32 v231, v245, v247
		v_add_f32_e32 v214, v214, v218
		v_add_f32_e32 v215, v215, v219
		v_add_f32_e32 v218, v220, v222
		v_add_f32_e32 v219, v221, v223
		v_add_f32_e32 v220, v224, v226
		v_add_f32_e32 v221, v225, v227
		v_add_f32_e32 v222, v228, v230
		v_add_f32_e32 v223, v229, v231
		v_add_f32_e32 v214, v214, v218
		v_add_f32_e32 v215, v215, v219
		v_add_f32_e32 v218, v220, v222
		v_add_f32_e32 v219, v221, v223
		v_add_f32_e32 v214, v214, v218
		v_add_f32_e32 v215, v215, v219
		v_add_f32_e32 v216, v216, v217
		v_add_f32_e32 v218, v214, v215
		v_mov_b32_e32 v219, v218
		v_cvt_pk_bf16_f32 v220, v170, v97
		v_cvt_pk_bf16_f32 v221, v16, v171
		v_permlane32_swap_b32_e32 v218, v219
		v_add_f32_e32 v16, v218, v219
		v_add_f32_e32 v8, v8, v157
		v_add_f32_e32 v9, v9, v213
		v_exp_f32_e32 v8, v8
		v_exp_f32_e32 v9, v9
		v_cvt_pk_bf16_f32 v222, v98, v23
		v_mul_f32_e32 v32, v32, v8
		v_mul_f32_e32 v33, v33, v8
		v_mul_f32_e32 v34, v34, v8
		v_mul_f32_e32 v35, v35, v8
		v_mul_f32_e32 v36, v36, v8
		v_mul_f32_e32 v37, v37, v8
		v_mul_f32_e32 v38, v38, v8
		v_mul_f32_e32 v39, v39, v8
		v_mul_f32_e32 v40, v40, v8
		v_mul_f32_e32 v41, v41, v8
		v_mul_f32_e32 v42, v42, v8
		v_mul_f32_e32 v43, v43, v8
		v_mul_f32_e32 v44, v44, v8
		v_mul_f32_e32 v45, v45, v8
		v_mul_f32_e32 v46, v46, v8
		v_mul_f32_e32 v47, v47, v8
		v_mul_f32_e32 v48, v48, v8
		v_mul_f32_e32 v49, v49, v8
		v_mul_f32_e32 v50, v50, v8
		v_mul_f32_e32 v51, v51, v8
		v_mul_f32_e32 v52, v52, v8
		v_mul_f32_e32 v53, v53, v8
		v_mul_f32_e32 v54, v54, v8
		v_mul_f32_e32 v55, v55, v8
		v_mul_f32_e32 v56, v56, v8
		v_mul_f32_e32 v57, v57, v8
		v_mul_f32_e32 v58, v58, v8
		v_mul_f32_e32 v59, v59, v8
		v_mul_f32_e32 v60, v60, v8
		v_mul_f32_e32 v61, v61, v8
		v_mul_f32_e32 v62, v62, v8
		v_mul_f32_e32 v63, v63, v8
		v_mul_f32_e32 v64, v64, v9
		v_mul_f32_e32 v65, v65, v9
		v_mul_f32_e32 v66, v66, v9
		v_mul_f32_e32 v67, v67, v9
		v_mul_f32_e32 v68, v68, v9
		v_mul_f32_e32 v69, v69, v9
		v_mul_f32_e32 v70, v70, v9
		v_mul_f32_e32 v71, v71, v9
		v_mul_f32_e32 v72, v72, v9
		v_mul_f32_e32 v73, v73, v9
		v_mul_f32_e32 v74, v74, v9
		v_mul_f32_e32 v75, v75, v9
		v_mul_f32_e32 v76, v76, v9
		v_mul_f32_e32 v77, v77, v9
		v_mul_f32_e32 v78, v78, v9
		v_mul_f32_e32 v79, v79, v9
		v_mul_f32_e32 v80, v80, v9
		v_mul_f32_e32 v81, v81, v9
		v_mul_f32_e32 v82, v82, v9
		v_mul_f32_e32 v83, v83, v9
		v_mul_f32_e32 v84, v84, v9
		v_mul_f32_e32 v85, v85, v9
		v_mul_f32_e32 v86, v86, v9
		v_mul_f32_e32 v87, v87, v9
		v_mul_f32_e32 v88, v88, v9
		v_mul_f32_e32 v89, v89, v9
		v_mul_f32_e32 v90, v90, v9
		v_mul_f32_e32 v91, v91, v9
		v_mul_f32_e32 v92, v92, v9
		v_mul_f32_e32 v93, v93, v9
		v_mul_f32_e32 v94, v94, v9
		v_mul_f32_e32 v95, v95, v9
		v_fma_f32 v11, v11, v8, v216
		v_fma_f32 v18, v18, v9, v16
		v_cvt_pk_bf16_f32 v223, v101, v172
		v_cvt_pk_bf16_f32 v216, v102, v25
		v_cvt_pk_bf16_f32 v217, v27, v173
		v_cvt_pk_bf16_f32 v218, v106, v29
		v_cvt_pk_bf16_f32 v219, v109, v174
		v_cvt_pk_bf16_f32 v224, v110, v31
		v_cvt_pk_bf16_f32 v225, v114, v175
		v_cvt_pk_bf16_f32 v226, v116, v117
		v_cvt_pk_bf16_f32 v227, v118, v176
		v_cvt_pk_bf16_f32 v172, v120, v121
		v_cvt_pk_bf16_f32 v173, v122, v177
		v_cvt_pk_bf16_f32 v174, v124, v125
		v_cvt_pk_bf16_f32 v175, v126, v203
		v_cvt_pk_bf16_f32 v228, v128, v129
		v_cvt_pk_bf16_f32 v229, v130, v204
		v_cvt_pk_bf16_f32 v230, v132, v133
		v_cvt_pk_bf16_f32 v231, v134, v205
		v_cvt_pk_bf16_f32 v232, v136, v137
		v_cvt_pk_bf16_f32 v233, v138, v206
		v_cvt_pk_bf16_f32 v234, v140, v139
		v_cvt_pk_bf16_f32 v235, v141, v96
		v_cvt_pk_bf16_f32 v136, v144, v145
		v_cvt_pk_bf16_f32 v137, v146, v147
		v_cvt_pk_bf16_f32 v138, v148, v207
		v_cvt_pk_bf16_f32 v139, v208, v151
		v_cvt_pk_bf16_f32 v144, v152, v209
		v_cvt_pk_bf16_f32 v145, v210, v211
		v_cvt_pk_bf16_f32 v146, v155, v156
		v_cvt_pk_bf16_f32 v147, v212, v158
		v_cvt_pk_bf16_f32 v204, v5, v13
		v_cvt_pk_bf16_f32 v205, v15, v100
		v_cvt_pk_bf16_f32 v206, v20, v159
		v_cvt_pk_bf16_f32 v207, v178, v104
		v_cvt_pk_bf16_f32 v156, v24, v99
		v_cvt_pk_bf16_f32 v157, v179, v180
		v_cvt_pk_bf16_f32 v158, v26, v103
		v_cvt_pk_bf16_f32 v159, v181, v108
		v_cvt_pk_bf16_f32 v24, v28, v107
		v_cvt_pk_bf16_f32 v25, v182, v112
		v_cvt_pk_bf16_f32 v26, v30, v111
		v_cvt_pk_bf16_f32 v27, v183, v184
		v_cvt_pk_bf16_f32 v28, v115, v185
		v_cvt_pk_bf16_f32 v29, v186, v187
		v_cvt_pk_bf16_f32 v30, v119, v188
		v_cvt_pk_bf16_f32 v31, v189, v190
		v_cvt_pk_bf16_f32 v96, v123, v191
		v_cvt_pk_bf16_f32 v97, v192, v193
		v_cvt_pk_bf16_f32 v98, v127, v194
		v_cvt_pk_bf16_f32 v99, v195, v196
		v_cvt_pk_bf16_f32 v100, v131, v197
		v_cvt_pk_bf16_f32 v101, v198, v199
		v_cvt_pk_bf16_f32 v102, v135, v200
		v_cvt_pk_bf16_f32 v103, v201, v202
		v_cvt_pk_bf16_f32 v108, v142, v143
		v_cvt_pk_bf16_f32 v109, v160, v161
		v_cvt_pk_bf16_f32 v110, v162, v163
		v_cvt_pk_bf16_f32 v111, v164, v165
		v_cvt_pk_bf16_f32 v116, v149, v150
		v_cvt_pk_bf16_f32 v117, v166, v167
		v_cvt_pk_bf16_f32 v118, v153, v154
		v_cvt_pk_bf16_f32 v119, v168, v169
		v_permlane32_swap_b32_e32 v220, v222
		v_permlane32_swap_b32_e32 v221, v223
		v_permlane32_swap_b32_e32 v216, v218
		v_permlane32_swap_b32_e32 v217, v219
		v_mfma_f32_32x32x16_bf16 v[32:47], a[184:187], v[220:223], v[32:47]
		v_permlane32_swap_b32_e32 v224, v226
		v_permlane32_swap_b32_e32 v225, v227
		v_mfma_f32_32x32x16_bf16 v[48:63], a[216:219], v[220:223], v[48:63]
		v_permlane32_swap_b32_e32 v172, v174
		v_permlane32_swap_b32_e32 v173, v175
		v_mfma_f32_32x32x16_bf16 v[32:47], a[188:191], v[216:219], v[32:47]
		v_permlane32_swap_b32_e32 v228, v230
		v_permlane32_swap_b32_e32 v229, v231
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[220:223], v[216:219], v[48:63]
		v_permlane32_swap_b32_e32 v232, v234
		v_permlane32_swap_b32_e32 v233, v235
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[224:227], v[32:47]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[224:227], v[48:63]
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[172:175], v[32:47]
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[172:175], v[48:63]
		v_permlane32_swap_b32_e32 v156, v158
		v_permlane32_swap_b32_e32 v157, v159
		v_mfma_f32_32x32x16_bf16 v[80:95], a[216:219], v[204:207], v[80:95]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[64:79], a[184:187], v[204:207], v[64:79]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[80:95], a[220:223], v[156:159], v[80:95]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[64:79], a[188:191], v[156:159], v[64:79]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[24:27], v[80:95]
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[24:27], v[64:79]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[28:31], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[28:31], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[228:231], v[32:47]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[228:231], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[232:235], v[32:47]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[232:235], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[100:103], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[136:139], v[32:47]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[136:139], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[108:111], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[108:111], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[144:147], v[32:47]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[144:147], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[116:119], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[116:119], v[64:79]
		s_cselect_b32 s1, 1, 0
		s_add_i32 s23, s41, 0x80
		s_cmp_lg_u32 s1, 0
		s_mov_b32 s41, s23
		v_mov_b32_e32 v8, v105
		v_mov_b32_e32 v9, v113
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_4
.L_attn_fwd_persistent.loop_exit_4:
		v_rcp_f32_e32 v1, v11
		v_accvgpr_read_b32 v2, a4
		s_nop 0
		v_readfirstlane_b32 s1, v2
		v_accvgpr_read_b32 v2, a12
		s_nop 0
		v_readfirstlane_b32 s18, v2
		s_mul_i32 s1, s18, s1
		v_mul_f32_e32 v2, v32, v1
		v_mul_f32_e32 v3, v33, v1
		v_mul_f32_e32 v4, v34, v1
		v_mul_f32_e32 v5, v35, v1
		v_mul_f32_e32 v6, v36, v1
		v_mul_f32_e32 v7, v37, v1
		v_mul_f32_e32 v8, v38, v1
		v_mul_f32_e32 v9, v39, v1
		v_mul_f32_e32 v10, v40, v1
		v_mul_f32_e32 v11, v41, v1
		v_mul_f32_e32 v12, v42, v1
		v_mul_f32_e32 v13, v43, v1
		v_mul_f32_e32 v14, v44, v1
		v_mul_f32_e32 v15, v45, v1
		v_mul_f32_e32 v16, v46, v1
		v_mul_f32_e32 v17, v47, v1
		v_mul_f32_e32 v19, v48, v1
		v_mul_f32_e32 v20, v49, v1
		v_mul_f32_e32 v21, v50, v1
		v_mul_f32_e32 v22, v51, v1
		v_mul_f32_e32 v23, v52, v1
		v_mul_f32_e32 v24, v53, v1
		v_mul_f32_e32 v25, v54, v1
		v_mul_f32_e32 v26, v55, v1
		v_mul_f32_e32 v27, v56, v1
		v_mul_f32_e32 v28, v57, v1
		v_mul_f32_e32 v29, v58, v1
		v_mul_f32_e32 v30, v59, v1
		v_mul_f32_e32 v31, v60, v1
		v_mul_f32_e32 v32, v61, v1
		v_mul_f32_e32 v33, v62, v1
		v_mul_f32_e32 v1, v63, v1
		v_rcp_f32_e32 v18, v18
		v_cvt_pk_bf16_f32 v36, v2, v3
		v_mul_f32_e32 v2, v64, v18
		v_mul_f32_e32 v3, v65, v18
		v_mul_f32_e32 v34, v66, v18
		v_mul_f32_e32 v35, v67, v18
		v_mul_f32_e32 v40, v68, v18
		v_mul_f32_e32 v41, v69, v18
		v_mul_f32_e32 v42, v70, v18
		v_mul_f32_e32 v43, v71, v18
		v_mul_f32_e32 v44, v72, v18
		v_mul_f32_e32 v45, v73, v18
		v_mul_f32_e32 v46, v74, v18
		v_mul_f32_e32 v47, v75, v18
		v_mul_f32_e32 v48, v76, v18
		v_mul_f32_e32 v49, v77, v18
		v_mul_f32_e32 v50, v78, v18
		v_mul_f32_e32 v51, v79, v18
		v_mul_f32_e32 v52, v80, v18
		v_mul_f32_e32 v53, v81, v18
		v_mul_f32_e32 v54, v82, v18
		v_mul_f32_e32 v55, v83, v18
		v_mul_f32_e32 v56, v84, v18
		v_mul_f32_e32 v57, v85, v18
		v_mul_f32_e32 v58, v86, v18
		v_mul_f32_e32 v59, v87, v18
		v_mul_f32_e32 v60, v88, v18
		v_mul_f32_e32 v61, v89, v18
		v_mul_f32_e32 v62, v90, v18
		v_mul_f32_e32 v63, v91, v18
		v_mul_f32_e32 v64, v92, v18
		v_mul_f32_e32 v65, v93, v18
		v_mul_f32_e32 v66, v94, v18
		v_mul_f32_e32 v18, v95, v18
		v_cvt_pk_bf16_f32 v37, v4, v5
		v_cvt_pk_bf16_f32 v38, v6, v7
		v_cvt_pk_bf16_f32 v39, v8, v9
		v_cvt_pk_bf16_f32 v4, v10, v11
		v_cvt_pk_bf16_f32 v5, v12, v13
		v_cvt_pk_bf16_f32 v6, v14, v15
		v_cvt_pk_bf16_f32 v7, v16, v17
		v_cvt_pk_bf16_f32 v8, v19, v20
		v_cvt_pk_bf16_f32 v9, v21, v22
		v_cvt_pk_bf16_f32 v10, v23, v24
		v_cvt_pk_bf16_f32 v11, v25, v26
		v_cvt_pk_bf16_f32 v12, v27, v28
		v_cvt_pk_bf16_f32 v13, v29, v30
		v_cvt_pk_bf16_f32 v14, v31, v32
		v_cvt_pk_bf16_f32 v15, v33, v1
		v_cvt_pk_bf16_f32 v20, v2, v3
		v_cvt_pk_bf16_f32 v21, v34, v35
		v_cvt_pk_bf16_f32 v22, v40, v41
		v_cvt_pk_bf16_f32 v23, v42, v43
		v_cvt_pk_bf16_f32 v24, v44, v45
		v_cvt_pk_bf16_f32 v25, v46, v47
		v_cvt_pk_bf16_f32 v26, v48, v49
		v_cvt_pk_bf16_f32 v27, v50, v51
		v_cvt_pk_bf16_f32 v28, v52, v53
		v_cvt_pk_bf16_f32 v29, v54, v55
		v_cvt_pk_bf16_f32 v30, v56, v57
		v_cvt_pk_bf16_f32 v31, v58, v59
		v_cvt_pk_bf16_f32 v32, v60, v61
		v_cvt_pk_bf16_f32 v33, v62, v63
		v_cvt_pk_bf16_f32 v34, v64, v65
		v_cvt_pk_bf16_f32 v35, v66, v18
		v_permlane32_swap_b32_e32 v36, v38
		v_permlane32_swap_b32_e32 v37, v39
		v_permlane32_swap_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v5, v7
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
		v_permlane32_swap_b32_e32 v12, v14
		v_permlane32_swap_b32_e32 v13, v15
		v_permlane32_swap_b32_e32 v20, v22
		v_permlane32_swap_b32_e32 v21, v23
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_permlane32_swap_b32_e32 v32, v34
		v_permlane32_swap_b32_e32 v33, v35
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
		v_accvgpr_read_b32 v16, a13
		v_accvgpr_read_b32 v17, a52
		s_nop 0
		v_readfirstlane_b32 s24, v17
		v_accvgpr_read_b32 v17, a53
		s_nop 0
		v_readfirstlane_b32 s25, v17
		s_nop 1
		v_cndmask_b32_e64 v3, v16, v3, s[24:25]
		s_mov_b32 s24, s8
		s_mov_b32 s25, s9
		s_mov_b32 s26, s30
		s_mov_b32 s27, s31
		buffer_store_dwordx4 v[36:39], v3, s[24:27], 0 offen
		s_add_i32 s28, s21, 32
		v_add3_u32 v3, s28, v1, v2
		v_accvgpr_read_b32 v16, a13
		v_accvgpr_read_b32 v17, a52
		s_nop 0
		v_readfirstlane_b32 s28, v17
		v_accvgpr_read_b32 v17, a53
		s_nop 0
		v_readfirstlane_b32 s29, v17
		s_nop 1
		v_cndmask_b32_e64 v3, v16, v3, s[28:29]
		buffer_store_dwordx4 v[4:7], v3, s[24:27], 0 offen
		s_add_i32 s28, s21, 64
		v_add3_u32 v3, s28, v1, v2
		v_accvgpr_read_b32 v4, a13
		v_accvgpr_read_b32 v5, a52
		s_nop 0
		v_readfirstlane_b32 s28, v5
		v_accvgpr_read_b32 v5, a53
		s_nop 0
		v_readfirstlane_b32 s29, v5
		s_nop 1
		v_cndmask_b32_e64 v3, v4, v3, s[28:29]
		buffer_store_dwordx4 v[8:11], v3, s[24:27], 0 offen
		s_add_i32 s21, s21, 0x60
		v_add3_u32 v3, s21, v1, v2
		v_accvgpr_read_b32 v4, a13
		v_accvgpr_read_b32 v5, a52
		s_nop 0
		v_readfirstlane_b32 s28, v5
		v_accvgpr_read_b32 v5, a53
		s_nop 0
		v_readfirstlane_b32 s29, v5
		s_nop 1
		v_cndmask_b32_e64 v3, v4, v3, s[28:29]
		buffer_store_dwordx4 v[12:15], v3, s[24:27], 0 offen
		v_accvgpr_read_b32 v3, a4
		s_nop 0
		v_readfirstlane_b32 s21, v3
		s_lshl_b32 s21, s21, 8
		s_add_i32 s1, s21, s1
		s_add_i32 s1, s1, s18
		s_add_i32 s1, s1, s22
		s_add_i32 s1, s1, s23
		v_add3_u32 v3, s1, v1, v2
		v_accvgpr_read_b32 v4, a13
		v_accvgpr_read_b32 v5, a60
		s_nop 0
		v_readfirstlane_b32 s22, v5
		v_accvgpr_read_b32 v5, a61
		s_nop 0
		v_readfirstlane_b32 s23, v5
		s_nop 1
		v_cndmask_b32_e64 v3, v4, v3, s[22:23]
		buffer_store_dwordx4 v[20:23], v3, s[24:27], 0 offen
		s_add_i32 s18, s1, 32
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
		buffer_store_dwordx4 v[28:31], v3, s[24:27], 0 offen
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
		buffer_store_dwordx4 v[32:35], v1, s[24:27], 0 offen
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
		.amdhsa_next_free_vgpr 508
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
	.set .L_attn_fwd_persistent.num_agpr, 252
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
    .vgpr_count:     508
    .agpr_count:     252
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 363
    wave.regalloc.agpr.dwords: 733
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
