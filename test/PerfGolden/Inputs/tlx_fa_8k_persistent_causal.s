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
		v_readfirstlane_b32 s17, v0
		s_lshl_b32 s17, s17, 2
		s_add_i32 s17, s17, 0x189b0
		s_load_dword s18, s[0:1], 0x38
		s_load_dword s19, s[0:1], 0x3c
		s_load_dword s20, s[0:1], 0x40
		s_load_dword s21, s[0:1], 0x44
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s17
		v_mov_b32_e32 v1, s21
		ds_write_addtid_b32 v1
		s_load_dword s21, s[0:1], 0x48
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s17
		v_mov_b32_e32 v1, s21
		ds_write_addtid_b32 v1 offset:1024
		s_load_dword s21, s[0:1], 0x4c
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v1, s21
		s_load_dword s21, s[0:1], 0x50
		s_load_dword s22, s[0:1], 0x54
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v2, s22
		s_load_dword s22, s[0:1], 0x58
		s_load_dword s23, s[0:1], 0x5c
		s_load_dword s24, s[0:1], 0x60
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v3, s24
		s_and_b32 s0, s16, 7
		v_mov_b32_e32 v4, s0
		s_lshr_b32 s0, s16, 3
		v_readfirstlane_b32 s1, v2
		s_mul_i32 s1, s21, s1
		s_nop 0
		v_mov_b32_e32 v5, s1
		s_nop 0
		v_readfirstlane_b32 s1, v5
		s_add_i32 s1, s1, 7
		s_mov_b32 s16, 1
		s_mov_b32 s21, 7
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s21, s21, 0
		s_add_i32 s1, s1, s21
		s_ashr_i32 s1, s1, 3
		v_mov_b32_e32 v6, s1
		s_nop 0
		v_readfirstlane_b32 s1, v6
		s_mul_i32 s1, s1, 16
		s_nop 0
		v_mov_b32_e32 v7, s1
		s_nop 0
		v_readfirstlane_b32 s1, v7
		s_cmp_lt_i32 s0, s1
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_0
.L_attn_fwd_persistent.loop_head_0:
		s_lshr_b32 s1, s0, 4
		s_and_b32 s21, s0, 15
		s_mul_i32 s1, s1, 8
		v_readfirstlane_b32 s24, v4
		s_add_i32 s1, s24, s1
		v_readfirstlane_b32 s24, v5
		s_cmp_lt_i32 s1, s24
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_0
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s24, 1, 0
		s_xor_b32 s25, s1, -1
		s_add_i32 s25, s25, 1
		s_cmp_lg_u32 s24, 0
		s_cselect_b32 s24, s25, s1
		s_cselect_b32 s25, 1, 0
		v_readfirstlane_b32 s26, v2
		s_xor_b32 s26, s26, -1
		s_add_i32 s26, s26, 1
		v_readfirstlane_b32 s27, v2
		s_cmp_lt_i32 s27, 0
		v_readfirstlane_b32 s27, v2
		s_cselect_b32 s26, s26, s27
		v_mov_b32_e32 v7, s26
		v_cvt_f32_u32_e32 v7, v7
		v_rcp_iflag_f32_e32 v7, v7
		v_mov_b32_e32 v8, 0x4f7ffffe
		v_mul_f32_e32 v7, v8, v7
		v_cvt_u32_f32_e32 v7, v7
		s_xor_b32 s27, s26, -1
		v_readfirstlane_b32 s28, v7
		s_add_i32 s27, s27, 1
		s_mul_i32 s29, s27, s28
		s_mul_hi_u32 s29, s28, s29
		s_add_i32 s28, s28, s29
		s_mul_hi_u32 s28, s24, s28
		s_mul_i32 s29, s28, s26
		s_xor_b32 s29, s29, -1
		s_add_i32 s29, s29, 1
		s_add_i32 s24, s24, s29
		s_cmp_ge_u32 s24, s26
		s_cselect_b32 s29, 1, 0
		s_add_i32 s30, s28, 1
		s_cmp_lg_u32 s29, 0
		s_cselect_b32 s28, s30, s28
		s_cselect_b32 s29, 1, 0
		s_add_i32 s30, s24, s27
		s_cmp_lg_u32 s29, 0
		s_cselect_b32 s24, s30, s24
		s_cmp_ge_u32 s24, s26
		s_cselect_b32 s26, 1, 0
		s_add_i32 s29, s28, 1
		s_cmp_lg_u32 s26, 0
		s_cselect_b32 s26, s29, s28
		s_cselect_b32 s28, 1, 0
		v_readfirstlane_b32 s29, v2
		s_xor_b32 s1, s1, s29
		s_xor_b32 s29, s26, -1
		s_add_i32 s29, s29, 1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s1, s29, s26
		s_add_i32 s26, s24, s27
		s_cmp_lg_u32 s28, 0
		s_cselect_b32 s24, s26, s24
		s_xor_b32 s26, s24, -1
		s_add_i32 s26, s26, 1
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s24, s26, s24
		s_mul_i32 s21, s21, 2
		s_lshr_b32 s25, s21, 1
		s_and_b32 s21, s21, 1
		s_xor_b32 s26, s25, -1
		s_add_i32 s26, s26, 1
		s_add_i32 s26, s26, 31
		s_cmp_eq_u32 s21, 0
		s_cselect_b32 s21, s25, s26
		v_mov_b32_e32 v7, s21
		s_nop 0
		v_readfirstlane_b32 s21, v7
		s_mul_i32 s21, s21, 0x100
		v_and_b32_e32 v8, 1, v0
		v_lshrrev_b32_e32 v9, 1, v0
		v_and_b32_e32 v10, 1, v9
		v_mov_b32_e32 v11, 2
		v_mul_lo_u32 v11, v11, v10
		v_lshrrev_b32_e32 v10, 2, v0
		v_and_b32_e32 v12, 1, v10
		v_mov_b32_e32 v13, 4
		v_mul_lo_u32 v13, v13, v12
		v_bitop3_b32 v12, v8, v11, v13 bitop3:0x96
		v_lshrrev_b32_e32 v14, 3, v0
		v_and_b32_e32 v15, 1, v14
		v_mov_b32_e32 v16, 8
		v_mul_lo_u32 v16, v16, v15
		v_xor_b32_e32 v12, v12, v16
		v_lshrrev_b32_e32 v17, 4, v0
		v_and_b32_e32 v18, 1, v17
		v_mov_b32_e32 v19, 16
		v_mul_lo_u32 v19, v19, v18
		v_lshrrev_b32_e32 v20, 6, v0
		v_and_b32_e32 v21, 1, v20
		v_mov_b32_e32 v22, 32
		v_mul_lo_u32 v22, v22, v21
		v_bitop3_b32 v12, v12, v19, v22 bitop3:0x96
		v_lshrrev_b32_e32 v23, 7, v0
		v_and_b32_e32 v24, 1, v23
		v_mov_b32_e32 v25, 64
		v_mul_lo_u32 v25, v25, v24
		v_xor_b32_e32 v12, v12, v25
		v_add_u32_e32 v26, s21, v12
		v_xor_b32_e32 v8, 0x80, v8
		v_xor_b32_e32 v8, v8, v11
		v_xor_b32_e32 v8, v8, v13
		v_bitop3_b32 v8, v8, v16, v19 bitop3:0x96
		v_bitop3_b32 v8, v8, v22, v25 bitop3:0x96
		v_add_u32_e32 v11, s21, v8
		v_cmp_lt_i32_e64 vcc, v26, s22
		s_mov_b64 s[26:27], vcc
		v_mov_b32_e32 v26, s26
		v_mov_b32_e32 v27, s27
		v_cmp_lt_i32_e64 vcc, v11, s22
		s_mov_b64 s[26:27], vcc
		v_mov_b32_e32 v28, s26
		v_mov_b32_e32 v29, s27
		v_accvgpr_write_b32 a0, v28
		v_accvgpr_write_b32 a1, v29
		v_mov_b32_e32 v11, 2
		v_mul_lo_u32 v11, v11, v18
		v_lshrrev_b32_e32 v13, 5, v0
		v_and_b32_e32 v16, 1, v13
		v_mov_b32_e32 v19, 4
		v_mul_lo_u32 v19, v19, v16
		v_bitop3_b32 v22, v15, v11, v19 bitop3:0x96
		v_mov_b32_e32 v25, 8
		v_mul_lo_u32 v25, v25, v21
		v_mov_b32_e32 v28, 16
		v_mul_lo_u32 v28, v28, v24
		v_bitop3_b32 v22, v22, v25, v28 bitop3:0x96
		v_add_u32_e32 v22, s21, v22
		v_cmp_lt_i32_e64 vcc, v22, s22
		s_mov_b64 s[26:27], vcc
		s_mov_b32 s30, 0x7fffffff
		s_mov_b32 s31, 0x31016000
		s_mov_b32 s28, s4
		s_mov_b32 s29, s5
		s_mov_b32 s32, s6
		s_mov_b32 s33, s7
		s_mov_b32 s34, s30
		s_mov_b32 s35, s31
		v_readfirstlane_b32 s25, v7
		s_mul_i32 s25, s25, s12
		s_lshl_b32 s25, s25, 9
		s_mul_i32 s36, s1, s10
		s_lshl_b32 s36, s36, 1
		s_add_i32 s25, s25, s36
		s_mul_i32 s36, s24, s11
		s_lshl_b32 s36, s36, 1
		s_add_i32 s25, s25, s36
		v_mul_lo_u32 v22, s12, v23
		v_lshlrev_b32_e32 v22, 5, v22
		v_and_b32_e32 v29, 1, v20
		v_mul_lo_u32 v30, s12, v29
		v_lshlrev_b32_e32 v30, 4, v30
		v_add3_u32 v22, s25, v22, v30
		v_and_b32_e32 v13, 1, v13
		v_mul_lo_u32 v30, s12, v13
		v_lshlrev_b32_e32 v30, 3, v30
		v_and_b32_e32 v17, 1, v17
		v_mul_lo_u32 v31, s12, v17
		v_lshlrev_b32_e32 v31, 2, v31
		v_add3_u32 v22, v22, v30, v31
		v_and_b32_e32 v14, 1, v14
		v_mul_lo_u32 v30, s12, v14
		v_lshlrev_b32_e32 v30, 1, v30
		v_and_b32_e32 v31, 1, v0
		v_lshlrev_b32_e32 v31, 4, v31
		v_add3_u32 v22, v22, v30, v31
		v_and_b32_e32 v10, 1, v10
		v_lshlrev_b32_e32 v10, 6, v10
		v_and_b32_e32 v9, 1, v9
		v_lshlrev_b32_e32 v9, 5, v9
		v_add3_u32 v22, v22, v10, v9
		v_mov_b32_e32 v30, 0x80000000
		v_cndmask_b32_e64 v22, v30, v22, s[26:27]
		s_mov_b32 s36, s2
		s_mov_b32 s37, s3
		s_mov_b32 s38, s30
		s_mov_b32 s39, s31
		buffer_load_dwordx4 v[32:35], v22, s[36:39], 0 offen
		v_bitop3_b32 v22, 32, v15, v11 bitop3:0x96
		v_xor_b32_e32 v22, v22, v19
		v_bitop3_b32 v22, v22, v25, v28 bitop3:0x96
		v_add_u32_e32 v22, s21, v22
		v_cmp_lt_i32_e64 vcc, v22, s22
		s_mov_b64 s[26:27], vcc
		v_lshlrev_b32_e32 v22, 4, v23
		v_lshlrev_b32_e32 v36, 3, v29
		v_lshlrev_b32_e32 v37, 2, v13
		v_add_u32_e32 v38, 32, v14
		v_lshlrev_b32_e32 v39, 1, v17
		v_bitop3_b32 v38, v37, v38, v39 bitop3:0x96
		v_bitop3_b32 v38, v22, v36, v38 bitop3:0x96
		v_mul_lo_u32 v38, s12, v38
		v_lshlrev_b32_e32 v38, 1, v38
		v_add3_u32 v38, s25, v38, v31
		v_add3_u32 v38, v38, v10, v9
		v_cndmask_b32_e64 v38, v30, v38, s[26:27]
		buffer_load_dwordx4 v[40:43], v38, s[36:39], 0 offen
		v_bitop3_b32 v38, 64, v15, v11 bitop3:0x96
		v_xor_b32_e32 v38, v38, v19
		v_bitop3_b32 v38, v38, v25, v28 bitop3:0x96
		v_add_u32_e32 v38, s21, v38
		v_cmp_lt_i32_e64 vcc, v38, s22
		s_mov_b64 s[26:27], vcc
		v_add_u32_e32 v38, 64, v14
		v_bitop3_b32 v38, v37, v38, v39 bitop3:0x96
		v_bitop3_b32 v38, v22, v36, v38 bitop3:0x96
		v_mul_lo_u32 v38, s12, v38
		v_lshlrev_b32_e32 v38, 1, v38
		v_add3_u32 v38, s25, v38, v31
		v_add3_u32 v38, v38, v10, v9
		v_cndmask_b32_e64 v38, v30, v38, s[26:27]
		buffer_load_dwordx4 v[44:47], v38, s[36:39], 0 offen
		v_xor_b32_e32 v38, 0x60, v15
		v_xor_b32_e32 v38, v38, v11
		v_xor_b32_e32 v38, v38, v19
		v_bitop3_b32 v38, v38, v25, v28 bitop3:0x96
		v_add_u32_e32 v38, s21, v38
		v_cmp_lt_i32_e64 vcc, v38, s22
		s_mov_b64 s[26:27], vcc
		v_add_u32_e32 v38, 0x60, v14
		v_bitop3_b32 v38, v37, v38, v39 bitop3:0x96
		v_bitop3_b32 v38, v22, v36, v38 bitop3:0x96
		v_mul_lo_u32 v38, s12, v38
		v_lshlrev_b32_e32 v38, 1, v38
		v_add3_u32 v38, s25, v38, v31
		v_add3_u32 v38, v38, v10, v9
		v_cndmask_b32_e64 v38, v30, v38, s[26:27]
		buffer_load_dwordx4 v[48:51], v38, s[36:39], 0 offen
		v_xor_b32_e32 v38, 0x80, v15
		v_xor_b32_e32 v38, v38, v11
		v_xor_b32_e32 v38, v38, v19
		v_bitop3_b32 v38, v38, v25, v28 bitop3:0x96
		v_add_u32_e32 v38, s21, v38
		v_cmp_lt_i32_e64 vcc, v38, s22
		s_mov_b64 s[26:27], vcc
		v_add_u32_e32 v38, 0x80, v14
		v_bitop3_b32 v38, v37, v38, v39 bitop3:0x96
		v_bitop3_b32 v38, v22, v36, v38 bitop3:0x96
		v_mul_lo_u32 v38, s12, v38
		v_lshlrev_b32_e32 v38, 1, v38
		v_add3_u32 v38, s25, v38, v31
		v_add3_u32 v38, v38, v10, v9
		v_cndmask_b32_e64 v38, v30, v38, s[26:27]
		buffer_load_dwordx4 v[52:55], v38, s[36:39], 0 offen
		v_xor_b32_e32 v38, 0xa0, v15
		v_xor_b32_e32 v38, v38, v11
		v_xor_b32_e32 v38, v38, v19
		v_bitop3_b32 v38, v38, v25, v28 bitop3:0x96
		v_add_u32_e32 v38, s21, v38
		v_cmp_lt_i32_e64 vcc, v38, s22
		s_mov_b64 s[26:27], vcc
		v_add_u32_e32 v38, 0xa0, v14
		v_bitop3_b32 v38, v37, v38, v39 bitop3:0x96
		v_bitop3_b32 v38, v22, v36, v38 bitop3:0x96
		v_mul_lo_u32 v38, s12, v38
		v_lshlrev_b32_e32 v38, 1, v38
		v_add3_u32 v38, s25, v38, v31
		v_add3_u32 v38, v38, v10, v9
		v_cndmask_b32_e64 v38, v30, v38, s[26:27]
		buffer_load_dwordx4 v[56:59], v38, s[36:39], 0 offen
		v_xor_b32_e32 v38, 0xc0, v15
		v_xor_b32_e32 v38, v38, v11
		v_xor_b32_e32 v38, v38, v19
		v_bitop3_b32 v38, v38, v25, v28 bitop3:0x96
		v_add_u32_e32 v38, s21, v38
		v_cmp_lt_i32_e64 vcc, v38, s22
		s_mov_b64 s[26:27], vcc
		v_add_u32_e32 v38, 0xc0, v14
		v_bitop3_b32 v38, v37, v38, v39 bitop3:0x96
		v_bitop3_b32 v38, v22, v36, v38 bitop3:0x96
		v_mul_lo_u32 v38, s12, v38
		v_lshlrev_b32_e32 v38, 1, v38
		v_add3_u32 v38, s25, v38, v31
		v_add3_u32 v38, v38, v10, v9
		v_cndmask_b32_e64 v38, v30, v38, s[26:27]
		buffer_load_dwordx4 v[60:63], v38, s[36:39], 0 offen
		v_xor_b32_e32 v38, 0xe0, v15
		v_xor_b32_e32 v11, v38, v11
		v_xor_b32_e32 v11, v11, v19
		v_bitop3_b32 v11, v11, v25, v28 bitop3:0x96
		v_add_u32_e32 v11, s21, v11
		v_add_u32_e32 v25, 0xe0, v14
		v_bitop3_b32 v25, v37, v25, v39 bitop3:0x96
		v_bitop3_b32 v25, v22, v36, v25 bitop3:0x96
		v_mul_lo_u32 v25, s12, v25
		v_lshlrev_b32_e32 v25, 1, v25
		v_add3_u32 v25, s25, v25, v31
		v_cmp_lt_i32_e64 vcc, v11, s22
		v_add3_u32 v11, v25, v10, v9
		s_nop 0
		v_cndmask_b32_e32 v11, v30, v11, vcc
		buffer_load_dwordx4 v[64:67], v11, s[36:39], 0 offen
		s_waitcnt vmcnt(8)
		s_barrier
		v_lshlrev_b32_e32 v11, 2, v29
		v_lshlrev_b32_e32 v25, 1, v13
		v_xor_b32_e32 v28, v0, v17
		v_bitop3_b32 v11, v11, v25, v28 bitop3:0x96
		v_lshlrev_b32_e32 v11, 4, v11
		v_add_u32_e32 v11, 0x10000, v11
		s_waitcnt vmcnt(7)
		ds_write_b128 v11, v[32:35] offset:2480
		s_waitcnt vmcnt(6)
		ds_write_b128 v11, v[40:43] offset:6576
		s_waitcnt vmcnt(5)
		ds_write_b128 v11, v[44:47] offset:10672
		s_waitcnt vmcnt(4)
		ds_write_b128 v11, v[48:51] offset:14768
		v_lshlrev_b32_e32 v20, 12, v20
		v_add_u32_e32 v20, 0x10000, v20
		v_and_b32_e32 v25, 63, v0
		v_lshrrev_b32_e32 v28, 2, v25
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v28, 1, v28
		v_lshlrev_b32_e32 v28, 5, v28
		v_lshrrev_b32_e32 v32, 1, v25
		v_and_b32_e32 v32, 1, v32
		v_lshlrev_b32_e32 v32, 4, v32
		v_and_b32_e32 v33, 1, v25
		v_lshlrev_b32_e32 v33, 3, v33
		v_add3_u32 v34, v28, v32, v33
		v_lshrrev_b32_e32 v35, 5, v25
		v_xor_b32_e32 v34, v34, v35
		v_lshrrev_b32_e32 v37, 6, v34
		v_lshrrev_b32_e32 v38, 3, v25
		v_and_b32_e32 v38, 1, v38
		v_add_u32_e32 v37, v37, v38
		v_and_b32_e32 v37, 1, v37
		v_lshlrev_b32_e32 v37, 2, v37
		v_lshrrev_b32_e32 v39, 5, v34
		v_and_b32_e32 v39, 1, v39
		v_lshlrev_b32_e32 v39, 1, v39
		v_lshrrev_b32_e32 v40, 4, v25
		v_and_b32_e32 v40, 1, v40
		v_lshlrev_b32_e32 v41, 6, v38
		v_lshl_add_u32 v40, v40, 7, v41
		v_add_u32_e32 v41, v40, v34
		v_lshrrev_b32_e32 v34, 4, v34
		v_bitop3_b32 v34, v41, v34, 1 bitop3:0x78
		v_bitop3_b32 v34, v37, v39, v34 bitop3:0x96
		v_lshl_add_u32 v37, v34, 4, v20
		ds_read_b128 a[4:7], v37 offset:2480
		v_add_u32_e32 v37, 2, v28
		v_add3_u32 v37, v37, v32, v33
		v_xor_b32_e32 v37, v37, v35
		v_lshrrev_b32_e32 v39, 6, v37
		v_add_u32_e32 v39, v39, v38
		v_and_b32_e32 v39, 1, v39
		v_lshlrev_b32_e32 v39, 2, v39
		v_lshrrev_b32_e32 v41, 5, v37
		v_and_b32_e32 v41, 1, v41
		v_lshlrev_b32_e32 v41, 1, v41
		v_add_u32_e32 v42, v40, v37
		v_lshrrev_b32_e32 v37, 4, v37
		v_bitop3_b32 v37, v42, v37, 1 bitop3:0x78
		v_bitop3_b32 v37, v39, v41, v37 bitop3:0x96
		v_lshl_add_u32 v39, v37, 4, v20
		ds_read_b128 a[8:11], v39 offset:2480
		v_add_u32_e32 v39, 4, v28
		v_add3_u32 v39, v39, v32, v33
		v_xor_b32_e32 v39, v39, v35
		v_lshrrev_b32_e32 v41, 6, v39
		v_add_u32_e32 v41, v41, v38
		v_and_b32_e32 v41, 1, v41
		v_lshlrev_b32_e32 v41, 2, v41
		v_lshrrev_b32_e32 v42, 5, v39
		v_and_b32_e32 v42, 1, v42
		v_lshlrev_b32_e32 v42, 1, v42
		v_add_u32_e32 v43, v40, v39
		v_lshrrev_b32_e32 v39, 4, v39
		v_bitop3_b32 v39, v43, v39, 1 bitop3:0x78
		v_bitop3_b32 v39, v41, v42, v39 bitop3:0x96
		v_lshl_add_u32 v41, v39, 4, v20
		ds_read_b128 a[12:15], v41 offset:2480
		v_add_u32_e32 v28, 6, v28
		v_add3_u32 v28, v28, v32, v33
		v_xor_b32_e32 v28, v28, v35
		v_lshrrev_b32_e32 v32, 6, v28
		v_add_u32_e32 v32, v32, v38
		v_and_b32_e32 v32, 1, v32
		v_lshlrev_b32_e32 v32, 2, v32
		v_lshrrev_b32_e32 v33, 5, v28
		v_and_b32_e32 v33, 1, v33
		v_lshlrev_b32_e32 v33, 1, v33
		v_add_u32_e32 v38, v40, v28
		v_lshrrev_b32_e32 v28, 4, v28
		v_bitop3_b32 v28, v38, v28, 1 bitop3:0x78
		v_bitop3_b32 v28, v32, v33, v28 bitop3:0x96
		v_lshl_add_u32 v20, v28, 4, v20
		ds_read_b128 a[16:19], v20 offset:2480
		v_add_u32_e32 v20, 32, v36
		v_xor_b32_e32 v20, v20, v22
		v_lshrrev_b32_e32 v22, 5, v20
		v_and_b32_e32 v22, 1, v22
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(3)
		ds_write_b128 v11, v[52:55] offset:2480
		s_waitcnt vmcnt(2)
		ds_write_b128 v11, v[56:59] offset:6576
		s_waitcnt vmcnt(1)
		ds_write_b128 v11, v[60:63] offset:10672
		s_waitcnt vmcnt(0)
		ds_write_b128 v11, v[64:67] offset:14768
		v_lshlrev_b32_e32 v11, 14, v22
		v_lshrrev_b32_e32 v22, 4, v20
		v_and_b32_e32 v22, 1, v22
		v_lshlrev_b32_e32 v22, 13, v22
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshrrev_b32_e32 v20, 3, v20
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v20, 12, v20
		v_add3_u32 v11, v11, v22, v20
		v_lshl_add_u32 v20, v34, 4, v11
		ds_read_b128 a[20:23], v20 offset:51632
		v_lshl_add_u32 v20, v37, 4, v11
		ds_read_b128 a[24:27], v20 offset:51632
		v_lshl_add_u32 v20, v39, 4, v11
		ds_read_b128 a[28:31], v20 offset:51632
		v_lshl_add_u32 v11, v28, 4, v11
		ds_read_b128 a[32:35], v11 offset:51632
		v_readfirstlane_b32 s25, v7
		s_add_i32 s25, s25, 1
		s_mul_i32 s25, s25, 0x100
		v_readfirstlane_b32 s26, v3
		s_add_i32 s25, s25, s26
		s_cmp_lt_i32 s23, s25
		s_cselect_b32 s25, s23, s25
		s_add_i32 s26, s25, 0x7f
		s_mov_b32 s27, 0x7f
		s_cmp_lt_i32 s26, 0
		s_cselect_b32 s40, s27, 0
		s_add_i32 s26, s26, s40
		s_ashr_i32 s26, s26, 7
		v_readfirstlane_b32 s40, v3
		s_add_i32 s40, s21, s40
		s_cmp_lt_i32 s40, 0
		s_cselect_b32 s41, s27, 0
		s_add_i32 s40, s40, s41
		s_ashr_i32 s40, s40, 7
		s_cmp_lt_i32 s40, s26
		s_cselect_b32 s40, s40, s26
		s_cmp_gt_i32 s40, 0
		s_cselect_b32 s40, s40, 0
		v_mov_b32_e32 v11, 64
		v_mul_lo_u32 v11, v11, v15
		v_mov_b32_e32 v20, 32
		v_mul_lo_u32 v20, v20, v18
		v_mov_b32_e32 v18, 16
		v_mul_lo_u32 v18, v18, v16
		v_bitop3_b32 v22, v11, v20, v18 bitop3:0x96
		v_mov_b32_e32 v28, 2
		v_mul_lo_u32 v28, v28, v24
		v_bitop3_b32 v22, v22, v21, v28 bitop3:0x96
		v_bitop3_b32 v24, 4, v11, v20 bitop3:0x96
		v_xor_b32_e32 v24, v24, v18
		v_bitop3_b32 v24, v24, v21, v28 bitop3:0x96
		v_bitop3_b32 v32, 8, v11, v20 bitop3:0x96
		v_xor_b32_e32 v32, v32, v18
		v_bitop3_b32 v32, v32, v21, v28 bitop3:0x96
		v_bitop3_b32 v11, 12, v11, v20 bitop3:0x96
		v_xor_b32_e32 v11, v11, v18
		v_bitop3_b32 v11, v11, v21, v28 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v22, s23
		s_mov_b64 s[42:43], vcc
		v_cmp_lt_i32_e64 vcc, v24, s23
		s_mov_b64 s[44:45], vcc
		v_cmp_lt_i32_e64 vcc, v32, s23
		s_mov_b64 s[46:47], vcc
		v_cmp_lt_i32_e64 vcc, v11, s23
		s_mov_b64 s[48:49], vcc
		v_mov_b32_e32 v18, 16
		v_mul_lo_u32 v18, v18, v15
		v_mov_b32_e32 v15, 64
		v_mul_lo_u32 v15, v15, v16
		v_bitop3_b32 v16, v18, v20, v15 bitop3:0x96
		v_bitop3_b32 v16, v16, v21, v28 bitop3:0x96
		v_bitop3_b32 v33, 4, v18, v20 bitop3:0x96
		v_xor_b32_e32 v33, v33, v15
		v_bitop3_b32 v33, v33, v21, v28 bitop3:0x96
		v_bitop3_b32 v34, 8, v18, v20 bitop3:0x96
		v_xor_b32_e32 v34, v34, v15
		v_bitop3_b32 v34, v34, v21, v28 bitop3:0x96
		v_bitop3_b32 v18, 12, v18, v20 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v16, s23
		s_mov_b64 s[50:51], vcc
		v_cmp_lt_i32_e64 vcc, v33, s23
		s_mov_b64 s[52:53], vcc
		v_cmp_lt_i32_e64 vcc, v34, s23
		s_mov_b64 s[54:55], vcc
		v_readfirstlane_b32 s56, v0
		v_mul_lo_u32 v20, s15, v23
		v_mul_lo_u32 v36, s15, v29
		v_lshlrev_b32_e32 v36, 1, v36
		v_lshl_add_u32 v20, v20, 2, v36
		v_mul_lo_u32 v36, s15, v13
		v_lshl_add_u32 v20, v36, 5, v20
		v_mul_lo_u32 v36, s15, v17
		v_lshl_add_u32 v20, v36, 6, v20
		v_mul_lo_u32 v36, s15, v14
		v_lshlrev_b32_e32 v36, 7, v36
		v_add3_u32 v20, v20, v36, v31
		v_add3_u32 v20, v20, v10, v9
		s_mul_i32 s41, s1, s13
		s_lshl_b32 s41, s41, 1
		s_mul_i32 s57, s24, s14
		s_lshl_b32 s57, s57, 1
		s_add_i32 s58, s41, s57
		v_add_u32_e32 v36, s58, v20
		v_cndmask_b32_e64 v36, v30, v36, s[42:43]
		v_accvgpr_write_b32 a2, v36
		s_lshr_b32 s42, s56, 6
		s_mul_i32 s43, 0x410, s42
		s_mov_b32 m0, s43
		v_xor_b32_e32 v15, v18, v15
		v_accvgpr_read_b32 v18, a2
		buffer_load_dwordx4 v18, s[28:31], 0 offen lds
		v_bitop3_b32 v15, v15, v21, v28 bitop3:0x96
		s_lshl_b32 s58, s15, 3
		s_add_i32 s58, s58, s41
		s_add_i32 s58, s58, s57
		v_add_u32_e32 v18, s58, v20
		s_add_i32 m0, s43, 0x1040
		v_cndmask_b32_e64 v18, v30, v18, s[44:45]
		v_accvgpr_write_b32 a3, v18
		v_accvgpr_read_b32 v18, a3
		buffer_load_dwordx4 v18, s[28:31], 0 offen lds
		s_lshl_b32 s44, s15, 4
		s_add_i32 s44, s44, s41
		s_add_i32 s44, s44, s57
		v_add_u32_e32 v18, s44, v20
		s_add_i32 m0, s43, 0x2080
		v_cndmask_b32_e64 v18, v30, v18, s[46:47]
		v_accvgpr_write_b32 a36, v18
		v_accvgpr_read_b32 v18, a36
		buffer_load_dwordx4 v18, s[28:31], 0 offen lds
		s_mul_i32 s44, 24, s15
		s_add_i32 s44, s44, s41
		s_add_i32 s44, s44, s57
		v_add_u32_e32 v18, s44, v20
		s_add_i32 m0, s43, 0x30c0
		v_cndmask_b32_e64 v18, v30, v18, s[48:49]
		v_accvgpr_write_b32 a37, v18
		v_accvgpr_read_b32 v18, a37
		buffer_load_dwordx4 v18, s[28:31], 0 offen lds
		v_mul_lo_u32 v18, s20, v23
		v_mul_lo_u32 v21, s20, v29
		v_lshlrev_b32_e32 v21, 1, v21
		v_lshl_add_u32 v18, v18, 2, v21
		v_mul_lo_u32 v13, s20, v13
		v_lshl_add_u32 v13, v13, 7, v18
		v_mul_lo_u32 v17, s20, v17
		v_lshl_add_u32 v13, v17, 6, v13
		v_mul_lo_u32 v14, s20, v14
		v_lshlrev_b32_e32 v14, 5, v14
		v_add3_u32 v13, v13, v14, v31
		v_add3_u32 v9, v13, v10, v9
		s_mul_i32 s44, s1, s18
		s_lshl_b32 s44, s44, 1
		s_mul_i32 s45, s24, s19
		s_lshl_b32 s45, s45, 1
		s_add_i32 s46, s44, s45
		v_add_u32_e32 v10, s46, v9
		s_mul_i32 s42, 0x440, s42
		s_add_i32 m0, s42, 0x81f0
		v_cndmask_b32_e64 v10, v30, v10, s[50:51]
		v_accvgpr_write_b32 a38, v10
		v_accvgpr_read_b32 v10, a38
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		s_lshl_b32 s46, s20, 3
		s_add_i32 s46, s46, s44
		s_add_i32 s46, s46, s45
		v_add_u32_e32 v10, s46, v9
		s_add_i32 m0, s42, 0x92f0
		v_cndmask_b32_e64 v10, v30, v10, s[52:53]
		v_accvgpr_write_b32 a39, v10
		v_accvgpr_read_b32 v10, a39
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		s_lshl_b32 s46, s20, 4
		s_add_i32 s46, s46, s44
		s_add_i32 s46, s46, s45
		v_add_u32_e32 v10, s46, v9
		s_add_i32 m0, s42, 0xa3f0
		v_cndmask_b32_e64 v10, v30, v10, s[54:55]
		v_accvgpr_write_b32 a40, v10
		v_accvgpr_read_b32 v10, a40
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		s_mul_i32 s46, 24, s20
		s_add_i32 s46, s46, s44
		s_add_i32 s46, s46, s45
		v_cmp_lt_i32_e64 vcc, v15, s23
		v_add_u32_e32 v10, s46, v9
		v_mbcnt_lo_u32_b32 v13, -1, 0
		v_cndmask_b32_e32 v10, v30, v10, vcc
		v_accvgpr_write_b32 a41, v10
		s_add_i32 m0, s42, 0xb4f0
		s_mul_i32 s46, s40, 0x80
		v_accvgpr_read_b32 v10, a41
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		v_mbcnt_hi_u32_b32 v10, -1, v13
		v_and_b32_e32 v13, 1, v10
		v_lshrrev_b32_e32 v14, 4, v10
		v_and_b32_e32 v14, 1, v14
		v_lshlrev_b32_e32 v14, 4, v14
		v_lshrrev_b32_e32 v17, 3, v10
		v_and_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v17, 3, v17
		v_add3_u32 v18, v13, v14, v17
		v_lshrrev_b32_e32 v21, 2, v10
		v_and_b32_e32 v21, 1, v21
		v_lshlrev_b32_e32 v21, 2, v21
		v_lshrrev_b32_e32 v23, 1, v10
		v_and_b32_e32 v23, 1, v23
		v_lshlrev_b32_e32 v23, 1, v23
		v_add3_u32 v18, v18, v21, v23
		v_add_u32_e32 v13, 32, v13
		v_bitop3_b32 v13, v21, v13, v23 bitop3:0x96
		v_bitop3_b32 v13, v14, v17, v13 bitop3:0x96
		v_mov_b32_e32 v28, 0x3e38aa3b
		v_mov_b32_e32 v29, 0x3e38aa3b
		s_mov_b32 s40, 0xff800000
		v_mov_b32_e32 v14, s40
		s_nop 0
		v_readfirstlane_b32 s40, v14
		s_nop 1
		v_mov_b32_e32 v17, s40
		v_readfirstlane_b32 s40, v14
		s_nop 1
		v_mov_b32_e32 v21, s40
		s_mov_b32 s40, 1.0
		v_mov_b32_e32 v23, s40
		s_nop 0
		v_readfirstlane_b32 s40, v23
		s_nop 1
		v_mov_b32_e32 v31, s40
		v_accvgpr_write_b32 a42, v31
		v_readfirstlane_b32 s40, v23
		s_nop 1
		v_mov_b32_e32 v31, s40
		v_accvgpr_write_b32 a43, v31
		s_mov_b32 s40, 0
		v_lshlrev_b32_e32 v31, 4, v35
		v_and_b32_e32 v36, 31, v25
		v_lshrrev_b32_e32 v37, 4, v36
		v_lshlrev_b32_e32 v38, 9, v37
		v_lshrrev_b32_e32 v39, 3, v36
		v_and_b32_e32 v39, 1, v39
		v_mov_b32_e32 v40, 0x2080
		v_mul_lo_u32 v40, v40, v39
		v_lshrrev_b32_e32 v39, 2, v36
		v_and_b32_e32 v39, 1, v39
		v_mov_b32_e32 v41, 0x1040
		v_mul_lo_u32 v41, v41, v39
		v_lshrrev_b32_e32 v39, 1, v36
		v_and_b32_e32 v39, 1, v39
		v_mov_b32_e32 v42, 0x820
		v_mul_lo_u32 v42, v42, v39
		v_and_b32_e32 v36, 1, v36
		v_mov_b32_e32 v39, 0x410
		v_mul_lo_u32 v39, v39, v36
		v_mov_b32_e32 v36, 0x2200
		v_mul_lo_u32 v36, v36, v35
		v_lshlrev_b32_e32 v37, 5, v37
		v_and_b32_e32 v25, 15, v25
		v_lshrrev_b32_e32 v43, 2, v25
		v_mov_b32_e32 v44, 0x440
		v_mul_lo_u32 v44, v44, v43
		v_and_b32_e32 v25, 3, v25
		v_lshlrev_b32_e32 v43, 3, v25
		s_lshl_b32 s47, s15, 8
		s_add_i32 s47, s47, s41
		s_add_i32 s47, s47, s57
		s_mul_i32 s48, 0x108, s15
		s_add_i32 s48, s48, s41
		s_add_i32 s48, s48, s57
		s_mul_i32 s49, 0x110, s15
		s_add_i32 s49, s49, s41
		s_add_i32 s49, s49, s57
		s_mul_i32 s50, 0x118, s15
		s_add_i32 s41, s50, s41
		s_add_i32 s41, s41, s57
		s_lshl_b32 s50, s20, 8
		s_add_i32 s50, s50, s44
		s_add_i32 s50, s50, s45
		s_mul_i32 s51, 0x108, s20
		s_add_i32 s51, s51, s44
		s_add_i32 s51, s51, s45
		s_mul_i32 s52, 0x110, s20
		s_add_i32 s52, s52, s44
		s_add_i32 s52, s52, s45
		s_mul_i32 s53, 0x118, s20
		s_add_i32 s44, s53, s44
		s_add_i32 s44, s44, s45
		v_lshlrev_b32_e32 v18, 2, v18
		v_lshlrev_b32_e32 v13, 2, v13
		s_cmp_lt_i32 0, s46
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
		v_mov_b64_e32 v[46:47], 0
		v_accvgpr_write_b32 a48, v46
		v_accvgpr_write_b32 a49, v47
		v_mov_b64_e32 v[46:47], 0
		v_accvgpr_write_b32 a50, v46
		v_accvgpr_write_b32 a51, v47
		v_mov_b64_e32 v[46:47], 0
		v_accvgpr_write_b32 a52, v46
		v_accvgpr_write_b32 a53, v47
		v_mov_b64_e32 v[46:47], 0
		v_accvgpr_write_b32 a54, v46
		v_accvgpr_write_b32 a55, v47
		v_mov_b64_e32 v[46:47], 0
		v_accvgpr_write_b32 a56, v46
		v_accvgpr_write_b32 a57, v47
		v_mov_b64_e32 v[46:47], 0
		v_accvgpr_write_b32 a58, v46
		v_accvgpr_write_b32 a59, v47
		v_mov_b64_e32 v[46:47], 0
		v_accvgpr_write_b32 a60, v46
		v_accvgpr_write_b32 a61, v47
		v_mov_b64_e32 v[46:47], 0
		v_accvgpr_write_b32 a62, v46
		v_accvgpr_write_b32 a63, v47
		v_mov_b64_e32 v[46:47], 0
		v_accvgpr_write_b32 a64, v46
		v_accvgpr_write_b32 a65, v47
		v_mov_b64_e32 v[46:47], 0
		v_accvgpr_write_b32 a66, v46
		v_accvgpr_write_b32 a67, v47
		v_mov_b64_e32 v[46:47], 0
		v_accvgpr_write_b32 a68, v46
		v_accvgpr_write_b32 a69, v47
		v_mov_b64_e32 v[46:47], 0
		v_accvgpr_write_b32 a70, v46
		v_accvgpr_write_b32 a71, v47
		v_mov_b64_e32 v[46:47], 0
		v_accvgpr_write_b32 a72, v46
		v_accvgpr_write_b32 a73, v47
		v_mov_b64_e32 v[46:47], 0
		v_accvgpr_write_b32 a74, v46
		v_accvgpr_write_b32 a75, v47
		v_mov_b64_e32 v[46:47], 0
		v_accvgpr_write_b32 a76, v46
		v_accvgpr_write_b32 a77, v47
		v_mov_b64_e32 v[46:47], 0
		v_accvgpr_write_b32 a78, v46
		v_accvgpr_write_b32 a79, v47
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_1
.L_attn_fwd_persistent.loop_head_1:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s45, s40, 0x80
		s_lshr_b32 s53, s40, 7
		s_and_b32 s54, s53, 1
		s_mul_i32 s55, 0x4100, s54
		v_add3_u32 v45, s55, v31, v38
		v_add3_u32 v45, v45, v40, v41
		v_add3_u32 v45, v45, v42, v39
		ds_read_b128 v[80:83], v45
		ds_read_b128 v[84:87], v45 offset:32
		ds_read_b128 v[88:91], v45 offset:64
		ds_read_b128 v[92:95], v45 offset:96
		ds_read_b128 v[96:99], v45 offset:256
		ds_read_b128 v[100:103], v45 offset:288
		ds_read_b128 v[104:107], v45 offset:320
		ds_read_b128 v[108:111], v45 offset:352
		ds_read_b128 v[112:115], v45 offset:128
		ds_read_b128 v[116:119], v45 offset:160
		ds_read_b128 v[120:123], v45 offset:192
		ds_read_b128 v[124:127], v45 offset:224
		ds_read_b128 v[128:131], v45 offset:384
		ds_read_b128 v[132:135], v45 offset:416
		ds_read_b128 v[136:139], v45 offset:448
		ds_read_b128 v[140:143], v45 offset:480
		s_mul_i32 s54, 0x4400, s54
		v_add3_u32 v45, s54, v36, v37
		v_add3_u32 v45, v45, v44, v43
		ds_read_b64_tr_b16 a[44:45], v45 offset:33264
		ds_read_b64_tr_b16 a[46:47], v45 offset:37616
		ds_read_b64_tr_b16 a[80:81], v45 offset:33392
		ds_read_b64_tr_b16 a[82:83], v45 offset:37744
		ds_read_b64_tr_b16 a[84:85], v45 offset:33520
		ds_read_b64_tr_b16 a[86:87], v45 offset:37872
		ds_read_b64_tr_b16 a[88:89], v45 offset:33648
		ds_read_b64_tr_b16 a[90:91], v45 offset:38000
		ds_read_b64_tr_b16 a[92:93], v45 offset:33776
		ds_read_b64_tr_b16 a[94:95], v45 offset:38128
		ds_read_b64_tr_b16 a[96:97], v45 offset:33904
		ds_read_b64_tr_b16 a[98:99], v45 offset:38256
		ds_read_b64_tr_b16 a[100:101], v45 offset:34032
		ds_read_b64_tr_b16 a[102:103], v45 offset:38384
		ds_read_b64_tr_b16 a[104:105], v45 offset:34160
		ds_read_b64_tr_b16 a[106:107], v45 offset:38512
		ds_read_b64_tr_b16 a[108:109], v45 offset:33328
		ds_read_b64_tr_b16 a[110:111], v45 offset:37680
		ds_read_b64_tr_b16 a[112:113], v45 offset:33456
		ds_read_b64_tr_b16 a[114:115], v45 offset:37808
		ds_read_b64_tr_b16 a[116:117], v45 offset:33584
		ds_read_b64_tr_b16 a[118:119], v45 offset:37936
		ds_read_b64_tr_b16 a[120:121], v45 offset:33712
		ds_read_b64_tr_b16 a[122:123], v45 offset:38064
		ds_read_b64_tr_b16 a[124:125], v45 offset:33840
		ds_read_b64_tr_b16 a[126:127], v45 offset:38192
		ds_read_b64_tr_b16 a[128:129], v45 offset:33968
		ds_read_b64_tr_b16 a[130:131], v45 offset:38320
		ds_read_b64_tr_b16 a[132:133], v45 offset:34096
		ds_read_b64_tr_b16 a[134:135], v45 offset:38448
		ds_read_b64_tr_b16 a[136:137], v45 offset:34224
		ds_read_b64_tr_b16 a[138:139], v45 offset:38576
		s_barrier
		v_add_u32_e32 v45, s45, v22
		v_add_u32_e32 v46, s45, v24
		v_add_u32_e32 v47, s45, v32
		v_add_u32_e32 v144, s45, v11
		v_cmp_lt_i32_e64 vcc, v45, s23
		s_mov_b64 s[54:55], vcc
		v_cmp_lt_i32_e64 vcc, v46, s23
		s_mov_b64 s[58:59], vcc
		v_cmp_lt_i32_e64 vcc, v47, s23
		s_mov_b64 s[60:61], vcc
		v_cmp_lt_i32_e64 vcc, v144, s23
		s_mov_b64 s[62:63], vcc
		v_add_u32_e32 v45, s45, v16
		v_add_u32_e32 v46, s45, v33
		v_add_u32_e32 v47, s45, v34
		v_cmp_lt_i32_e64 vcc, v45, s23
		s_mov_b64 s[64:65], vcc
		v_cmp_lt_i32_e64 vcc, v46, s23
		s_mov_b64 s[66:67], vcc
		v_cmp_lt_i32_e64 vcc, v47, s23
		s_mov_b64 s[68:69], vcc
		s_mul_i32 s57, s15, s40
		s_lshl_b32 s57, s57, 1
		s_add_i32 s70, s47, s57
		v_add_u32_e32 v45, s70, v20
		s_add_i32 s53, s53, 1
		s_and_b32 s53, s53, 1
		s_mul_i32 s70, 0x4100, s53
		s_add_i32 s70, s43, s70
		s_mov_b32 m0, s70
		v_cndmask_b32_e64 v45, v30, v45, s[54:55]
		buffer_load_dwordx4 v45, s[28:31], 0 offen lds
		v_add_u32_e32 v45, s45, v15
		v_add_u32_e32 v46, s57, v20
		v_add_u32_e32 v47, s48, v46
		s_add_i32 m0, s70, 0x1040
		v_cndmask_b32_e64 v47, v30, v47, s[58:59]
		buffer_load_dwordx4 v47, s[28:31], 0 offen lds
		v_add_u32_e32 v47, s49, v46
		s_add_i32 m0, s70, 0x2080
		v_cndmask_b32_e64 v47, v30, v47, s[60:61]
		buffer_load_dwordx4 v47, s[28:31], 0 offen lds
		v_add_u32_e32 v46, s41, v46
		s_add_i32 m0, s70, 0x30c0
		v_cndmask_b32_e64 v46, v30, v46, s[62:63]
		buffer_load_dwordx4 v46, s[28:31], 0 offen lds
		s_barrier
		s_mul_i32 s40, s20, s40
		s_lshl_b32 s40, s40, 1
		s_add_i32 s54, s50, s40
		v_add_u32_e32 v46, s54, v9
		s_mul_i32 s53, 0x4400, s53
		s_add_i32 s53, s42, s53
		s_add_i32 m0, s53, 0x81f0
		v_cndmask_b32_e64 v46, v30, v46, s[64:65]
		buffer_load_dwordx4 v46, s[32:35], 0 offen lds
		v_add_u32_e32 v46, s40, v9
		v_add_u32_e32 v47, s51, v46
		s_add_i32 m0, s53, 0x92f0
		v_cndmask_b32_e64 v47, v30, v47, s[66:67]
		buffer_load_dwordx4 v47, s[32:35], 0 offen lds
		v_add_u32_e32 v47, s52, v46
		s_add_i32 m0, s53, 0xa3f0
		v_cndmask_b32_e64 v47, v30, v47, s[68:69]
		buffer_load_dwordx4 v47, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v45, s23
		v_add_u32_e32 v45, s44, v46
		s_add_i32 m0, s53, 0xb4f0
		v_cndmask_b32_e32 v45, v30, v45, vcc
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[144:159], v[80:83], a[4:7], 0
		s_nop 11
		v_accvgpr_write_b32 a144, v144
		v_accvgpr_write_b32 a145, v145
		v_accvgpr_write_b32 a146, v146
		v_accvgpr_write_b32 a147, v147
		v_accvgpr_write_b32 a148, v148
		v_accvgpr_write_b32 a149, v149
		v_accvgpr_write_b32 a150, v150
		v_accvgpr_write_b32 a151, v151
		v_accvgpr_write_b32 a152, v152
		v_accvgpr_write_b32 a153, v153
		v_accvgpr_write_b32 a154, v154
		v_accvgpr_write_b32 a155, v155
		v_accvgpr_write_b32 a156, v156
		v_accvgpr_write_b32 a157, v157
		v_accvgpr_write_b32 a158, v158
		v_accvgpr_write_b32 a159, v159
		v_mfma_f32_32x32x16_bf16 v[144:159], v[96:99], a[4:7], 0
		s_nop 11
		v_accvgpr_write_b32 a160, v144
		v_accvgpr_write_b32 a161, v145
		v_accvgpr_write_b32 a162, v146
		v_accvgpr_write_b32 a163, v147
		v_accvgpr_write_b32 a164, v148
		v_accvgpr_write_b32 a165, v149
		v_accvgpr_write_b32 a166, v150
		v_accvgpr_write_b32 a167, v151
		v_accvgpr_write_b32 a168, v152
		v_accvgpr_write_b32 a169, v153
		v_accvgpr_write_b32 a170, v154
		v_accvgpr_write_b32 a171, v155
		v_accvgpr_write_b32 a172, v156
		v_accvgpr_write_b32 a173, v157
		v_accvgpr_write_b32 a174, v158
		v_accvgpr_write_b32 a175, v159
		v_mfma_f32_32x32x16_bf16 v[144:159], v[112:115], a[4:7], 0
		s_nop 11
		v_accvgpr_write_b32 a176, v144
		v_accvgpr_write_b32 a177, v145
		v_accvgpr_write_b32 a178, v146
		v_accvgpr_write_b32 a179, v147
		v_accvgpr_write_b32 a180, v148
		v_accvgpr_write_b32 a181, v149
		v_accvgpr_write_b32 a182, v150
		v_accvgpr_write_b32 a183, v151
		v_accvgpr_write_b32 a184, v152
		v_accvgpr_write_b32 a185, v153
		v_accvgpr_write_b32 a186, v154
		v_accvgpr_write_b32 a187, v155
		v_accvgpr_write_b32 a188, v156
		v_accvgpr_write_b32 a189, v157
		v_accvgpr_write_b32 a190, v158
		v_accvgpr_write_b32 a191, v159
		v_mfma_f32_32x32x16_bf16 v[144:159], v[128:131], a[4:7], 0
		s_nop 11
		v_accvgpr_write_b32 a192, v144
		v_accvgpr_write_b32 a193, v145
		v_accvgpr_write_b32 a194, v146
		v_accvgpr_write_b32 a195, v147
		v_accvgpr_write_b32 a196, v148
		v_accvgpr_write_b32 a197, v149
		v_accvgpr_write_b32 a198, v150
		v_accvgpr_write_b32 a199, v151
		v_accvgpr_write_b32 a200, v152
		v_accvgpr_write_b32 a201, v153
		v_accvgpr_write_b32 a202, v154
		v_accvgpr_write_b32 a203, v155
		v_accvgpr_write_b32 a204, v156
		v_accvgpr_write_b32 a205, v157
		v_accvgpr_write_b32 a206, v158
		v_accvgpr_write_b32 a207, v159
		v_mfma_f32_32x32x16_bf16 v[144:159], v[128:131], a[20:23], 0
		s_nop 11
		v_accvgpr_write_b32 a208, v144
		v_accvgpr_write_b32 a209, v145
		v_accvgpr_write_b32 a210, v146
		v_accvgpr_write_b32 a211, v147
		v_accvgpr_write_b32 a212, v148
		v_accvgpr_write_b32 a213, v149
		v_accvgpr_write_b32 a214, v150
		v_accvgpr_write_b32 a215, v151
		v_accvgpr_write_b32 a216, v152
		v_accvgpr_write_b32 a217, v153
		v_accvgpr_write_b32 a218, v154
		v_accvgpr_write_b32 a219, v155
		v_accvgpr_write_b32 a220, v156
		v_accvgpr_write_b32 a221, v157
		v_accvgpr_write_b32 a222, v158
		v_accvgpr_write_b32 a223, v159
		v_mfma_f32_32x32x16_bf16 v[144:159], v[80:83], a[20:23], 0
		s_nop 11
		v_accvgpr_write_b32 a224, v144
		v_accvgpr_write_b32 a225, v145
		v_accvgpr_write_b32 a226, v146
		v_accvgpr_write_b32 a227, v147
		v_accvgpr_write_b32 a228, v148
		v_accvgpr_write_b32 a229, v149
		v_accvgpr_write_b32 a230, v150
		v_accvgpr_write_b32 a231, v151
		v_accvgpr_write_b32 a232, v152
		v_accvgpr_write_b32 a233, v153
		v_accvgpr_write_b32 a234, v154
		v_accvgpr_write_b32 a235, v155
		v_accvgpr_write_b32 a236, v156
		v_accvgpr_write_b32 a237, v157
		v_accvgpr_write_b32 a238, v158
		v_accvgpr_write_b32 a239, v159
		v_mfma_f32_32x32x16_bf16 v[144:159], v[96:99], a[20:23], 0
		s_nop 11
		v_accvgpr_write_b32 a240, v144
		v_accvgpr_write_b32 a241, v145
		v_accvgpr_write_b32 a242, v146
		v_accvgpr_write_b32 a243, v147
		v_accvgpr_write_b32 a244, v148
		v_accvgpr_write_b32 a245, v149
		v_accvgpr_write_b32 a246, v150
		v_accvgpr_write_b32 a247, v151
		v_accvgpr_write_b32 a248, v152
		v_accvgpr_write_b32 a249, v153
		v_accvgpr_write_b32 a250, v154
		v_accvgpr_write_b32 a251, v155
		v_accvgpr_write_b32 a252, v156
		v_accvgpr_write_b32 a253, v157
		v_accvgpr_write_b32 a254, v158
		v_accvgpr_write_b32 a255, v159
		buffer_load_dwordx4 v45, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[144:159], v[112:115], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 a[144:159], v[84:87], a[8:11], a[144:159]
		v_mfma_f32_32x32x16_bf16 a[160:175], v[100:103], a[8:11], a[160:175]
		v_mfma_f32_32x32x16_bf16 a[176:191], v[116:119], a[8:11], a[176:191]
		v_mfma_f32_32x32x16_bf16 a[192:207], v[132:135], a[8:11], a[192:207]
		v_mfma_f32_32x32x16_bf16 a[208:223], v[132:135], a[24:27], a[208:223]
		v_mfma_f32_32x32x16_bf16 a[224:239], v[84:87], a[24:27], a[224:239]
		v_mfma_f32_32x32x16_bf16 a[240:255], v[100:103], a[24:27], a[240:255]
		v_mfma_f32_32x32x16_bf16 v[144:159], v[116:119], a[24:27], v[144:159]
		v_mfma_f32_32x32x16_bf16 a[144:159], v[88:91], a[12:15], a[144:159]
		v_mfma_f32_32x32x16_bf16 a[160:175], v[104:107], a[12:15], a[160:175]
		v_mfma_f32_32x32x16_bf16 a[176:191], v[120:123], a[12:15], a[176:191]
		v_mfma_f32_32x32x16_bf16 a[192:207], v[136:139], a[12:15], a[192:207]
		v_mfma_f32_32x32x16_bf16 a[208:223], v[136:139], a[28:31], a[208:223]
		v_mfma_f32_32x32x16_bf16 a[224:239], v[88:91], a[28:31], a[224:239]
		v_mfma_f32_32x32x16_bf16 a[240:255], v[104:107], a[28:31], a[240:255]
		v_mfma_f32_32x32x16_bf16 v[144:159], v[120:123], a[28:31], v[144:159]
		v_mfma_f32_32x32x16_bf16 a[144:159], v[92:95], a[16:19], a[144:159]
		v_mfma_f32_32x32x16_bf16 a[160:175], v[108:111], a[16:19], a[160:175]
		v_mfma_f32_32x32x16_bf16 a[176:191], v[124:127], a[16:19], a[176:191]
		v_mfma_f32_32x32x16_bf16 a[192:207], v[140:143], a[16:19], a[192:207]
		v_mfma_f32_32x32x16_bf16 a[208:223], v[140:143], a[32:35], a[208:223]
		v_mfma_f32_32x32x16_bf16 a[224:239], v[92:95], a[32:35], a[224:239]
		v_mfma_f32_32x32x16_bf16 a[240:255], v[108:111], a[32:35], a[240:255]
		v_mfma_f32_32x32x16_bf16 v[144:159], v[124:127], a[32:35], v[144:159]
		s_cmp_lt_i32 s45, s46
		s_nop 3
		v_accvgpr_read_b32 v45, a144
		v_accvgpr_read_b32 v46, a145
		v_max_f32_e32 v45, v45, v46
		v_accvgpr_read_b32 v46, a146
		v_accvgpr_read_b32 v47, a147
		v_max_f32_e32 v46, v46, v47
		v_accvgpr_read_b32 v47, a148
		v_accvgpr_read_b32 v80, a149
		v_max_f32_e32 v47, v47, v80
		v_accvgpr_read_b32 v80, a150
		v_accvgpr_read_b32 v81, a151
		v_max_f32_e32 v80, v80, v81
		v_accvgpr_read_b32 v81, a152
		v_accvgpr_read_b32 v82, a153
		v_max_f32_e32 v81, v81, v82
		v_accvgpr_read_b32 v82, a154
		v_accvgpr_read_b32 v83, a155
		v_max_f32_e32 v82, v82, v83
		v_accvgpr_read_b32 v83, a156
		v_accvgpr_read_b32 v84, a157
		v_max_f32_e32 v83, v83, v84
		v_accvgpr_read_b32 v84, a158
		v_accvgpr_read_b32 v85, a159
		v_max_f32_e32 v84, v84, v85
		v_accvgpr_read_b32 v85, a160
		v_accvgpr_read_b32 v86, a161
		v_max_f32_e32 v85, v85, v86
		v_accvgpr_read_b32 v86, a162
		v_accvgpr_read_b32 v87, a163
		v_max_f32_e32 v86, v86, v87
		v_accvgpr_read_b32 v87, a164
		v_accvgpr_read_b32 v88, a165
		v_max_f32_e32 v87, v87, v88
		v_accvgpr_read_b32 v88, a166
		v_accvgpr_read_b32 v89, a167
		v_max_f32_e32 v88, v88, v89
		v_accvgpr_read_b32 v89, a168
		v_accvgpr_read_b32 v90, a169
		v_max_f32_e32 v89, v89, v90
		v_accvgpr_read_b32 v90, a170
		v_accvgpr_read_b32 v91, a171
		v_max_f32_e32 v90, v90, v91
		v_accvgpr_read_b32 v91, a172
		v_accvgpr_read_b32 v92, a173
		v_max_f32_e32 v91, v91, v92
		v_accvgpr_read_b32 v92, a174
		v_accvgpr_read_b32 v93, a175
		v_max_f32_e32 v92, v92, v93
		v_accvgpr_read_b32 v93, a176
		v_accvgpr_read_b32 v94, a177
		v_max_f32_e32 v93, v93, v94
		v_accvgpr_read_b32 v94, a178
		v_accvgpr_read_b32 v95, a179
		v_max_f32_e32 v94, v94, v95
		v_accvgpr_read_b32 v95, a180
		v_accvgpr_read_b32 v96, a181
		v_max_f32_e32 v95, v95, v96
		v_accvgpr_read_b32 v96, a182
		v_accvgpr_read_b32 v97, a183
		v_max_f32_e32 v96, v96, v97
		v_accvgpr_read_b32 v97, a184
		v_accvgpr_read_b32 v98, a185
		v_max_f32_e32 v97, v97, v98
		v_accvgpr_read_b32 v98, a186
		v_accvgpr_read_b32 v99, a187
		v_max_f32_e32 v98, v98, v99
		v_accvgpr_read_b32 v99, a188
		v_accvgpr_read_b32 v100, a189
		v_max_f32_e32 v99, v99, v100
		v_accvgpr_read_b32 v100, a190
		v_accvgpr_read_b32 v101, a191
		v_max_f32_e32 v100, v100, v101
		v_accvgpr_read_b32 v101, a192
		v_accvgpr_read_b32 v102, a193
		v_max_f32_e32 v101, v101, v102
		v_accvgpr_read_b32 v102, a194
		v_accvgpr_read_b32 v103, a195
		v_max_f32_e32 v102, v102, v103
		v_accvgpr_read_b32 v103, a196
		v_accvgpr_read_b32 v104, a197
		v_max_f32_e32 v103, v103, v104
		v_accvgpr_read_b32 v104, a198
		v_accvgpr_read_b32 v105, a199
		v_max_f32_e32 v104, v104, v105
		v_accvgpr_read_b32 v105, a200
		v_accvgpr_read_b32 v106, a201
		v_max_f32_e32 v105, v105, v106
		v_accvgpr_read_b32 v106, a202
		v_accvgpr_read_b32 v107, a203
		v_max_f32_e32 v106, v106, v107
		v_accvgpr_read_b32 v107, a204
		v_accvgpr_read_b32 v108, a205
		v_max_f32_e32 v107, v107, v108
		v_accvgpr_read_b32 v108, a206
		v_accvgpr_read_b32 v109, a207
		v_max_f32_e32 v108, v108, v109
		v_max_f32_e32 v45, v45, v46
		v_max_f32_e32 v46, v47, v80
		v_max_f32_e32 v47, v81, v82
		v_max_f32_e32 v80, v83, v84
		v_max_f32_e32 v81, v85, v86
		v_max_f32_e32 v82, v87, v88
		v_max_f32_e32 v83, v89, v90
		v_max_f32_e32 v84, v91, v92
		v_max_f32_e32 v85, v93, v94
		v_max_f32_e32 v86, v95, v96
		v_max_f32_e32 v87, v97, v98
		v_max_f32_e32 v88, v99, v100
		v_max_f32_e32 v89, v101, v102
		v_max_f32_e32 v90, v103, v104
		v_max_f32_e32 v91, v105, v106
		v_max_f32_e32 v92, v107, v108
		v_max_f32_e32 v45, v45, v46
		v_max_f32_e32 v46, v47, v80
		v_max_f32_e32 v47, v81, v82
		v_max_f32_e32 v80, v83, v84
		v_max_f32_e32 v81, v85, v86
		v_max_f32_e32 v82, v87, v88
		v_max_f32_e32 v83, v89, v90
		v_max_f32_e32 v84, v91, v92
		v_max_f32_e32 v45, v45, v46
		v_max_f32_e32 v46, v47, v80
		v_max_f32_e32 v47, v81, v82
		v_max_f32_e32 v80, v83, v84
		v_max_f32_e32 v45, v45, v46
		v_max_f32_e32 v46, v47, v80
		v_max_f32_e32 v45, v45, v46
		ds_bpermute_b32 v46, v18, v45
		ds_bpermute_b32 v47, v13, v45
		v_accvgpr_read_b32 v45, a224
		v_accvgpr_read_b32 v80, a225
		v_max_f32_e32 v45, v45, v80
		v_accvgpr_read_b32 v80, a226
		v_accvgpr_read_b32 v81, a227
		v_max_f32_e32 v80, v80, v81
		v_accvgpr_read_b32 v81, a228
		v_accvgpr_read_b32 v82, a229
		v_max_f32_e32 v81, v81, v82
		v_accvgpr_read_b32 v82, a230
		v_accvgpr_read_b32 v83, a231
		v_max_f32_e32 v82, v82, v83
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v84, v46, v47
		v_accvgpr_read_b32 v46, a232
		v_accvgpr_read_b32 v47, a233
		v_max_f32_e32 v46, v46, v47
		v_accvgpr_read_b32 v47, a234
		v_accvgpr_read_b32 v83, a235
		v_max_f32_e32 v47, v47, v83
		v_accvgpr_read_b32 v83, a236
		v_accvgpr_read_b32 v85, a237
		v_max_f32_e32 v83, v83, v85
		v_accvgpr_read_b32 v85, a238
		v_accvgpr_read_b32 v86, a239
		v_max_f32_e32 v85, v85, v86
		v_accvgpr_read_b32 v86, a240
		v_accvgpr_read_b32 v87, a241
		v_max_f32_e32 v86, v86, v87
		v_accvgpr_read_b32 v87, a242
		v_accvgpr_read_b32 v88, a243
		v_max_f32_e32 v87, v87, v88
		v_accvgpr_read_b32 v88, a244
		v_accvgpr_read_b32 v89, a245
		v_max_f32_e32 v88, v88, v89
		v_accvgpr_read_b32 v89, a246
		v_accvgpr_read_b32 v90, a247
		v_max_f32_e32 v89, v89, v90
		v_accvgpr_read_b32 v90, a248
		v_accvgpr_read_b32 v91, a249
		v_max_f32_e32 v90, v90, v91
		v_accvgpr_read_b32 v91, a250
		v_accvgpr_read_b32 v92, a251
		v_max_f32_e32 v91, v91, v92
		v_accvgpr_read_b32 v92, a252
		v_accvgpr_read_b32 v93, a253
		v_max_f32_e32 v92, v92, v93
		v_accvgpr_read_b32 v93, a254
		v_accvgpr_read_b32 v94, a255
		v_max_f32_e32 v93, v93, v94
		v_max_f32_e32 v94, v144, v145
		v_max_f32_e32 v95, v146, v147
		v_max_f32_e32 v96, v148, v149
		v_max_f32_e32 v97, v150, v151
		v_max_f32_e32 v98, v152, v153
		v_max_f32_e32 v99, v154, v155
		v_max_f32_e32 v100, v156, v157
		v_max_f32_e32 v101, v158, v159
		v_accvgpr_read_b32 v102, a208
		v_accvgpr_read_b32 v103, a209
		v_max_f32_e32 v102, v102, v103
		v_accvgpr_read_b32 v103, a210
		v_accvgpr_read_b32 v104, a211
		v_max_f32_e32 v103, v103, v104
		v_accvgpr_read_b32 v104, a212
		v_accvgpr_read_b32 v105, a213
		v_max_f32_e32 v104, v104, v105
		v_accvgpr_read_b32 v105, a214
		v_accvgpr_read_b32 v106, a215
		v_max_f32_e32 v105, v105, v106
		v_accvgpr_read_b32 v106, a216
		v_accvgpr_read_b32 v107, a217
		v_max_f32_e32 v106, v106, v107
		v_accvgpr_read_b32 v107, a218
		v_accvgpr_read_b32 v108, a219
		v_max_f32_e32 v107, v107, v108
		v_accvgpr_read_b32 v108, a220
		v_accvgpr_read_b32 v109, a221
		v_max_f32_e32 v108, v108, v109
		v_accvgpr_read_b32 v109, a222
		v_accvgpr_read_b32 v110, a223
		v_max_f32_e32 v109, v109, v110
		v_max_f32_e32 v45, v45, v80
		v_max_f32_e32 v80, v81, v82
		v_max_f32_e32 v46, v46, v47
		v_max_f32_e32 v47, v83, v85
		v_max_f32_e32 v81, v86, v87
		v_max_f32_e32 v82, v88, v89
		v_max_f32_e32 v83, v90, v91
		v_max_f32_e32 v85, v92, v93
		v_max_f32_e32 v86, v94, v95
		v_max_f32_e32 v87, v96, v97
		v_max_f32_e32 v88, v98, v99
		v_max_f32_e32 v89, v100, v101
		v_max_f32_e32 v90, v102, v103
		v_max_f32_e32 v91, v104, v105
		v_max_f32_e32 v92, v106, v107
		v_max_f32_e32 v93, v108, v109
		v_max_f32_e32 v45, v45, v80
		v_max_f32_e32 v46, v46, v47
		v_max_f32_e32 v47, v81, v82
		v_max_f32_e32 v80, v83, v85
		v_max_f32_e32 v81, v86, v87
		v_max_f32_e32 v82, v88, v89
		v_max_f32_e32 v83, v90, v91
		v_max_f32_e32 v85, v92, v93
		v_max_f32_e32 v45, v45, v46
		v_max_f32_e32 v46, v47, v80
		v_max_f32_e32 v47, v81, v82
		v_max_f32_e32 v80, v83, v85
		v_max_f32_e32 v45, v45, v46
		v_max_f32_e32 v46, v47, v80
		v_max_f32_e32 v45, v45, v46
		ds_bpermute_b32 v46, v18, v45
		ds_bpermute_b32 v47, v13, v45
		v_accvgpr_read_b32 v80, a144
		v_accvgpr_read_b32 v81, a145
		v_pk_mul_f32 v[82:83], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a146
		v_accvgpr_read_b32 v81, a147
		v_pk_mul_f32 v[86:87], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a148
		v_accvgpr_read_b32 v81, a149
		v_pk_mul_f32 v[88:89], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a150
		v_accvgpr_read_b32 v81, a151
		v_pk_mul_f32 v[90:91], v[80:81], v[28:29]
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v85, v46, v47
		v_pk_mul_f32 v[46:47], v[84:85], v[28:29]
		v_max_f32_e32 v45, v17, v46
		v_max_f32_e32 v46, v21, v47
		v_accvgpr_read_b32 v80, a152
		v_accvgpr_read_b32 v81, a153
		v_pk_mul_f32 v[84:85], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a154
		v_accvgpr_read_b32 v81, a155
		v_pk_mul_f32 v[92:93], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a156
		v_accvgpr_read_b32 v81, a157
		v_pk_mul_f32 v[94:95], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a158
		v_accvgpr_read_b32 v81, a159
		v_pk_mul_f32 v[96:97], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a160
		v_accvgpr_read_b32 v81, a161
		v_pk_mul_f32 v[98:99], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a162
		v_accvgpr_read_b32 v81, a163
		v_pk_mul_f32 v[100:101], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a164
		v_accvgpr_read_b32 v81, a165
		v_pk_mul_f32 v[102:103], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a166
		v_accvgpr_read_b32 v81, a167
		v_pk_mul_f32 v[104:105], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a168
		v_accvgpr_read_b32 v81, a169
		v_pk_mul_f32 v[106:107], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a170
		v_accvgpr_read_b32 v81, a171
		v_pk_mul_f32 v[108:109], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a172
		v_accvgpr_read_b32 v81, a173
		v_pk_mul_f32 v[110:111], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a174
		v_accvgpr_read_b32 v81, a175
		v_pk_mul_f32 v[112:113], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a176
		v_accvgpr_read_b32 v81, a177
		v_pk_mul_f32 v[114:115], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a178
		v_accvgpr_read_b32 v81, a179
		v_pk_mul_f32 v[116:117], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a180
		v_accvgpr_read_b32 v81, a181
		v_pk_mul_f32 v[118:119], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a182
		v_accvgpr_read_b32 v81, a183
		v_pk_mul_f32 v[120:121], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a184
		v_accvgpr_read_b32 v81, a185
		v_pk_mul_f32 v[122:123], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a186
		v_accvgpr_read_b32 v81, a187
		v_pk_mul_f32 v[124:125], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a188
		v_accvgpr_read_b32 v81, a189
		v_pk_mul_f32 v[126:127], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a190
		v_accvgpr_read_b32 v81, a191
		v_pk_mul_f32 v[128:129], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a192
		v_accvgpr_read_b32 v81, a193
		v_pk_mul_f32 v[130:131], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a194
		v_accvgpr_read_b32 v81, a195
		v_pk_mul_f32 v[132:133], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a196
		v_accvgpr_read_b32 v81, a197
		v_pk_mul_f32 v[134:135], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a198
		v_accvgpr_read_b32 v81, a199
		v_pk_mul_f32 v[136:137], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a200
		v_accvgpr_read_b32 v81, a201
		v_pk_mul_f32 v[138:139], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a202
		v_accvgpr_read_b32 v81, a203
		v_pk_mul_f32 v[140:141], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a204
		v_accvgpr_read_b32 v81, a205
		v_pk_mul_f32 v[142:143], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a206
		v_accvgpr_read_b32 v81, a207
		v_pk_mul_f32 v[160:161], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a224
		v_accvgpr_read_b32 v81, a225
		v_pk_mul_f32 v[162:163], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a226
		v_accvgpr_read_b32 v81, a227
		v_pk_mul_f32 v[164:165], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a228
		v_accvgpr_read_b32 v81, a229
		v_pk_mul_f32 v[166:167], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a230
		v_accvgpr_read_b32 v81, a231
		v_pk_mul_f32 v[168:169], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a232
		v_accvgpr_read_b32 v81, a233
		v_pk_mul_f32 v[170:171], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a234
		v_accvgpr_read_b32 v81, a235
		v_pk_mul_f32 v[172:173], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a236
		v_accvgpr_read_b32 v81, a237
		v_pk_mul_f32 v[174:175], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a238
		v_accvgpr_read_b32 v81, a239
		v_pk_mul_f32 v[176:177], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a240
		v_accvgpr_read_b32 v81, a241
		v_pk_mul_f32 v[178:179], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a242
		v_accvgpr_read_b32 v81, a243
		v_pk_mul_f32 v[180:181], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a244
		v_accvgpr_read_b32 v81, a245
		v_pk_mul_f32 v[182:183], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a246
		v_accvgpr_read_b32 v81, a247
		v_pk_mul_f32 v[184:185], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a248
		v_accvgpr_read_b32 v81, a249
		v_pk_mul_f32 v[186:187], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a250
		v_accvgpr_read_b32 v81, a251
		v_pk_mul_f32 v[188:189], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a252
		v_accvgpr_read_b32 v81, a253
		v_pk_mul_f32 v[190:191], v[80:81], v[28:29]
		v_accvgpr_read_b32 v80, a254
		v_accvgpr_read_b32 v81, a255
		v_pk_mul_f32 v[192:193], v[80:81], v[28:29]
		v_pk_mul_f32 v[80:81], v[144:145], v[28:29]
		v_pk_mul_f32 v[144:145], v[146:147], v[28:29]
		v_pk_mul_f32 v[146:147], v[148:149], v[28:29]
		v_pk_mul_f32 v[148:149], v[150:151], v[28:29]
		v_pk_mul_f32 v[150:151], v[152:153], v[28:29]
		v_pk_mul_f32 v[152:153], v[154:155], v[28:29]
		v_pk_mul_f32 v[154:155], v[156:157], v[28:29]
		v_pk_mul_f32 v[156:157], v[158:159], v[28:29]
		v_accvgpr_read_b32 v158, a208
		v_accvgpr_read_b32 v159, a209
		v_pk_mul_f32 v[194:195], v[158:159], v[28:29]
		v_accvgpr_read_b32 v158, a210
		v_accvgpr_read_b32 v159, a211
		v_pk_mul_f32 v[196:197], v[158:159], v[28:29]
		v_accvgpr_read_b32 v158, a212
		v_accvgpr_read_b32 v159, a213
		v_pk_mul_f32 v[158:159], v[158:159], v[28:29]
		v_accvgpr_write_b32 a140, v158
		v_accvgpr_write_b32 a141, v159
		v_accvgpr_read_b32 v158, a214
		v_accvgpr_read_b32 v159, a215
		v_pk_mul_f32 v[158:159], v[158:159], v[28:29]
		v_accvgpr_write_b32 a142, v158
		v_accvgpr_write_b32 a143, v159
		v_accvgpr_read_b32 v158, a216
		v_accvgpr_read_b32 v159, a217
		v_pk_mul_f32 v[158:159], v[158:159], v[28:29]
		v_accvgpr_write_b32 a144, v158
		v_accvgpr_write_b32 a145, v159
		v_accvgpr_read_b32 v158, a218
		v_accvgpr_read_b32 v159, a219
		v_pk_mul_f32 v[158:159], v[158:159], v[28:29]
		v_accvgpr_write_b32 a146, v158
		v_accvgpr_write_b32 a147, v159
		v_accvgpr_read_b32 v158, a220
		v_accvgpr_read_b32 v159, a221
		v_pk_mul_f32 v[158:159], v[158:159], v[28:29]
		v_accvgpr_write_b32 a148, v158
		v_accvgpr_write_b32 a149, v159
		v_accvgpr_read_b32 v158, a222
		v_accvgpr_read_b32 v159, a223
		v_pk_mul_f32 v[198:199], v[158:159], v[28:29]
		v_sub_f32_e32 v47, v82, v45
		v_sub_f32_e32 v82, v83, v45
		v_sub_f32_e32 v83, v86, v45
		v_sub_f32_e32 v86, v87, v45
		v_sub_f32_e32 v87, v88, v45
		v_sub_f32_e32 v88, v89, v45
		v_sub_f32_e32 v89, v90, v45
		v_sub_f32_e32 v90, v91, v45
		v_sub_f32_e32 v84, v84, v45
		v_sub_f32_e32 v85, v85, v45
		v_sub_f32_e32 v91, v92, v45
		v_sub_f32_e32 v92, v93, v45
		v_sub_f32_e32 v93, v94, v45
		v_sub_f32_e32 v94, v95, v45
		v_sub_f32_e32 v95, v96, v45
		v_sub_f32_e32 v96, v97, v45
		v_sub_f32_e32 v97, v98, v45
		v_sub_f32_e32 v98, v99, v45
		v_sub_f32_e32 v99, v100, v45
		v_sub_f32_e32 v100, v101, v45
		v_sub_f32_e32 v101, v102, v45
		v_sub_f32_e32 v102, v103, v45
		v_sub_f32_e32 v103, v104, v45
		v_sub_f32_e32 v104, v105, v45
		v_sub_f32_e32 v105, v106, v45
		v_sub_f32_e32 v106, v107, v45
		v_sub_f32_e32 v107, v108, v45
		v_sub_f32_e32 v108, v109, v45
		v_sub_f32_e32 v109, v110, v45
		v_sub_f32_e32 v110, v111, v45
		v_sub_f32_e32 v111, v112, v45
		v_sub_f32_e32 v112, v113, v45
		v_sub_f32_e32 v113, v114, v45
		v_sub_f32_e32 v114, v115, v45
		v_sub_f32_e32 v115, v116, v45
		v_sub_f32_e32 v116, v117, v45
		v_sub_f32_e32 v117, v118, v45
		v_sub_f32_e32 v118, v119, v45
		v_sub_f32_e32 v119, v120, v45
		v_sub_f32_e32 v120, v121, v45
		v_sub_f32_e32 v121, v122, v45
		v_sub_f32_e32 v122, v123, v45
		v_sub_f32_e32 v123, v124, v45
		v_sub_f32_e32 v124, v125, v45
		v_sub_f32_e32 v125, v126, v45
		v_sub_f32_e32 v126, v127, v45
		v_sub_f32_e32 v127, v128, v45
		v_sub_f32_e32 v128, v129, v45
		v_sub_f32_e32 v129, v130, v45
		v_sub_f32_e32 v130, v131, v45
		v_sub_f32_e32 v131, v132, v45
		v_sub_f32_e32 v132, v133, v45
		v_sub_f32_e32 v133, v134, v45
		v_sub_f32_e32 v134, v135, v45
		v_sub_f32_e32 v135, v136, v45
		v_sub_f32_e32 v136, v137, v45
		v_sub_f32_e32 v137, v138, v45
		v_sub_f32_e32 v138, v139, v45
		v_sub_f32_e32 v139, v140, v45
		v_sub_f32_e32 v140, v141, v45
		v_sub_f32_e32 v141, v142, v45
		v_sub_f32_e32 v142, v143, v45
		v_sub_f32_e32 v143, v160, v45
		v_sub_f32_e32 v158, v161, v45
		v_sub_f32_e32 v159, v162, v46
		v_sub_f32_e32 v160, v163, v46
		v_sub_f32_e32 v161, v164, v46
		v_sub_f32_e32 v162, v165, v46
		v_sub_f32_e32 v163, v166, v46
		v_sub_f32_e32 v164, v167, v46
		v_sub_f32_e32 v165, v168, v46
		v_sub_f32_e32 v166, v169, v46
		v_sub_f32_e32 v167, v170, v46
		v_sub_f32_e32 v168, v171, v46
		v_sub_f32_e32 v169, v172, v46
		v_sub_f32_e32 v170, v173, v46
		v_sub_f32_e32 v171, v174, v46
		v_sub_f32_e32 v172, v175, v46
		v_sub_f32_e32 v173, v176, v46
		v_sub_f32_e32 v174, v177, v46
		v_sub_f32_e32 v175, v178, v46
		v_sub_f32_e32 v176, v179, v46
		v_sub_f32_e32 v177, v180, v46
		v_sub_f32_e32 v178, v181, v46
		v_sub_f32_e32 v179, v182, v46
		v_sub_f32_e32 v180, v183, v46
		v_sub_f32_e32 v181, v184, v46
		v_sub_f32_e32 v182, v185, v46
		v_sub_f32_e32 v183, v186, v46
		v_sub_f32_e32 v184, v187, v46
		v_sub_f32_e32 v185, v188, v46
		v_sub_f32_e32 v186, v189, v46
		v_sub_f32_e32 v187, v190, v46
		v_sub_f32_e32 v188, v191, v46
		v_sub_f32_e32 v189, v192, v46
		v_sub_f32_e32 v190, v193, v46
		v_sub_f32_e32 v80, v80, v46
		v_sub_f32_e32 v81, v81, v46
		v_sub_f32_e32 v144, v144, v46
		v_sub_f32_e32 v145, v145, v46
		v_sub_f32_e32 v146, v146, v46
		v_sub_f32_e32 v147, v147, v46
		v_sub_f32_e32 v148, v148, v46
		v_sub_f32_e32 v149, v149, v46
		v_sub_f32_e32 v150, v150, v46
		v_sub_f32_e32 v151, v151, v46
		v_sub_f32_e32 v152, v152, v46
		v_sub_f32_e32 v153, v153, v46
		v_sub_f32_e32 v154, v154, v46
		v_sub_f32_e32 v155, v155, v46
		v_sub_f32_e32 v156, v156, v46
		v_sub_f32_e32 v157, v157, v46
		v_sub_f32_e32 v191, v194, v46
		v_sub_f32_e32 v192, v195, v46
		v_sub_f32_e32 v193, v196, v46
		v_sub_f32_e32 v194, v197, v46
		v_accvgpr_read_b32 v195, a140
		v_sub_f32_e32 v195, v195, v46
		v_accvgpr_read_b32 v196, a141
		v_sub_f32_e32 v196, v196, v46
		v_accvgpr_read_b32 v197, a142
		v_sub_f32_e32 v197, v197, v46
		v_accvgpr_read_b32 v200, a143
		v_sub_f32_e32 v200, v200, v46
		v_accvgpr_read_b32 v201, a144
		v_sub_f32_e32 v201, v201, v46
		v_accvgpr_read_b32 v202, a145
		v_sub_f32_e32 v202, v202, v46
		v_accvgpr_read_b32 v203, a146
		v_sub_f32_e32 v203, v203, v46
		v_accvgpr_read_b32 v204, a147
		v_sub_f32_e32 v204, v204, v46
		v_accvgpr_read_b32 v205, a148
		v_sub_f32_e32 v205, v205, v46
		v_accvgpr_read_b32 v206, a149
		v_sub_f32_e32 v206, v206, v46
		v_sub_f32_e32 v198, v198, v46
		v_sub_f32_e32 v199, v199, v46
		v_exp_f32_e32 v47, v47
		s_nop 0
		v_accvgpr_write_b32 a140, v47
		v_exp_f32_e32 v208, v82
		v_exp_f32_e32 v47, v83
		s_nop 0
		v_accvgpr_write_b32 a141, v47
		v_exp_f32_e32 v209, v86
		v_exp_f32_e32 v82, v87
		v_exp_f32_e32 v86, v88
		v_exp_f32_e32 v83, v89
		v_exp_f32_e32 v87, v90
		v_exp_f32_e32 v88, v84
		v_exp_f32_e32 v210, v85
		v_exp_f32_e32 v89, v91
		v_exp_f32_e32 v211, v92
		v_exp_f32_e32 v84, v93
		v_exp_f32_e32 v90, v94
		v_exp_f32_e32 v85, v95
		v_exp_f32_e32 v91, v96
		v_exp_f32_e32 v92, v97
		v_exp_f32_e32 v94, v98
		v_exp_f32_e32 v93, v99
		v_exp_f32_e32 v95, v100
		v_exp_f32_e32 v96, v101
		v_exp_f32_e32 v98, v102
		v_exp_f32_e32 v97, v103
		v_exp_f32_e32 v99, v104
		v_exp_f32_e32 v100, v105
		v_exp_f32_e32 v102, v106
		v_exp_f32_e32 v101, v107
		v_exp_f32_e32 v103, v108
		v_exp_f32_e32 v104, v109
		v_exp_f32_e32 v106, v110
		v_exp_f32_e32 v105, v111
		v_exp_f32_e32 v107, v112
		v_exp_f32_e32 v108, v113
		v_exp_f32_e32 v110, v114
		v_exp_f32_e32 v109, v115
		v_exp_f32_e32 v111, v116
		v_exp_f32_e32 v112, v117
		v_exp_f32_e32 v114, v118
		v_exp_f32_e32 v113, v119
		v_exp_f32_e32 v115, v120
		v_exp_f32_e32 v116, v121
		v_exp_f32_e32 v118, v122
		v_exp_f32_e32 v117, v123
		v_exp_f32_e32 v119, v124
		v_exp_f32_e32 v120, v125
		v_exp_f32_e32 v122, v126
		v_exp_f32_e32 v121, v127
		v_exp_f32_e32 v123, v128
		v_exp_f32_e32 v124, v129
		v_exp_f32_e32 v126, v130
		v_exp_f32_e32 v125, v131
		v_exp_f32_e32 v127, v132
		v_exp_f32_e32 v128, v133
		v_exp_f32_e32 v130, v134
		v_exp_f32_e32 v129, v135
		v_exp_f32_e32 v131, v136
		v_exp_f32_e32 v132, v137
		v_exp_f32_e32 v134, v138
		v_exp_f32_e32 v133, v139
		v_exp_f32_e32 v135, v140
		v_exp_f32_e32 v136, v141
		v_exp_f32_e32 v138, v142
		v_exp_f32_e32 v137, v143
		v_exp_f32_e32 v139, v158
		v_exp_f32_e32 v47, v159
		s_nop 0
		v_accvgpr_write_b32 a143, v47
		v_exp_f32_e32 v47, v160
		s_nop 0
		v_accvgpr_write_b32 a145, v47
		v_exp_f32_e32 v140, v161
		v_exp_f32_e32 v142, v162
		v_exp_f32_e32 v141, v163
		v_exp_f32_e32 v143, v164
		v_exp_f32_e32 v158, v165
		v_exp_f32_e32 v160, v166
		v_exp_f32_e32 v159, v167
		v_exp_f32_e32 v161, v168
		v_exp_f32_e32 v162, v169
		v_exp_f32_e32 v164, v170
		v_exp_f32_e32 v163, v171
		v_exp_f32_e32 v165, v172
		v_exp_f32_e32 v166, v173
		v_exp_f32_e32 v168, v174
		v_exp_f32_e32 v167, v175
		v_exp_f32_e32 v169, v176
		v_exp_f32_e32 v170, v177
		v_exp_f32_e32 v172, v178
		v_exp_f32_e32 v171, v179
		v_exp_f32_e32 v173, v180
		v_exp_f32_e32 v174, v181
		v_exp_f32_e32 v176, v182
		v_exp_f32_e32 v175, v183
		v_exp_f32_e32 v177, v184
		v_exp_f32_e32 v178, v185
		v_exp_f32_e32 v180, v186
		v_exp_f32_e32 v179, v187
		v_exp_f32_e32 v181, v188
		v_exp_f32_e32 v182, v189
		v_exp_f32_e32 v184, v190
		v_exp_f32_e32 v183, v80
		v_exp_f32_e32 v185, v81
		v_exp_f32_e32 v80, v144
		v_exp_f32_e32 v186, v145
		v_exp_f32_e32 v81, v146
		v_exp_f32_e32 v187, v147
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
		v_exp_f32_e32 v153, v191
		v_exp_f32_e32 v155, v192
		v_exp_f32_e32 v156, v193
		v_exp_f32_e32 v188, v194
		v_exp_f32_e32 v157, v195
		v_exp_f32_e32 v189, v196
		v_exp_f32_e32 v190, v197
		v_exp_f32_e32 v192, v200
		v_exp_f32_e32 v191, v201
		v_exp_f32_e32 v193, v202
		v_exp_f32_e32 v47, v203
		s_nop 0
		v_accvgpr_write_b32 a146, v47
		v_exp_f32_e32 v194, v204
		v_exp_f32_e32 v47, v205
		s_nop 0
		v_accvgpr_write_b32 a147, v47
		v_exp_f32_e32 v195, v206
		v_exp_f32_e32 v47, v198
		s_nop 0
		v_accvgpr_write_b32 a148, v47
		v_exp_f32_e32 v47, v199
		s_nop 0
		v_accvgpr_write_b32 a150, v47
		v_accvgpr_read_b32 v196, a140
		v_accvgpr_read_b32 v197, a141
		v_pk_add_f32 v[198:199], v[196:197], v[208:209]
		v_pk_add_f32 v[196:197], v[82:83], v[86:87]
		v_accvgpr_write_b32 a152, v196
		v_accvgpr_write_b32 a153, v197
		v_pk_add_f32 v[196:197], v[88:89], v[210:211]
		v_accvgpr_write_b32 a154, v196
		v_accvgpr_write_b32 a155, v197
		v_pk_add_f32 v[196:197], v[84:85], v[90:91]
		v_accvgpr_write_b32 a156, v196
		v_accvgpr_write_b32 a157, v197
		v_pk_add_f32 v[196:197], v[92:93], v[94:95]
		v_accvgpr_write_b32 a158, v196
		v_accvgpr_write_b32 a159, v197
		v_pk_add_f32 v[196:197], v[96:97], v[98:99]
		v_accvgpr_write_b32 a160, v196
		v_accvgpr_write_b32 a161, v197
		v_pk_add_f32 v[196:197], v[100:101], v[102:103]
		v_accvgpr_write_b32 a162, v196
		v_accvgpr_write_b32 a163, v197
		v_pk_add_f32 v[196:197], v[104:105], v[106:107]
		v_accvgpr_write_b32 a164, v196
		v_accvgpr_write_b32 a165, v197
		v_pk_add_f32 v[196:197], v[108:109], v[110:111]
		v_accvgpr_write_b32 a166, v196
		v_accvgpr_write_b32 a167, v197
		v_pk_add_f32 v[196:197], v[112:113], v[114:115]
		v_accvgpr_write_b32 a168, v196
		v_accvgpr_write_b32 a169, v197
		v_pk_add_f32 v[196:197], v[116:117], v[118:119]
		v_accvgpr_write_b32 a170, v196
		v_accvgpr_write_b32 a171, v197
		v_pk_add_f32 v[196:197], v[120:121], v[122:123]
		v_accvgpr_write_b32 a172, v196
		v_accvgpr_write_b32 a173, v197
		v_pk_add_f32 v[196:197], v[124:125], v[126:127]
		v_accvgpr_write_b32 a174, v196
		v_accvgpr_write_b32 a175, v197
		v_pk_add_f32 v[196:197], v[128:129], v[130:131]
		v_accvgpr_write_b32 a176, v196
		v_accvgpr_write_b32 a177, v197
		v_pk_add_f32 v[196:197], v[132:133], v[134:135]
		v_accvgpr_write_b32 a178, v196
		v_accvgpr_write_b32 a179, v197
		v_pk_add_f32 v[196:197], v[136:137], v[138:139]
		v_accvgpr_write_b32 a180, v196
		v_accvgpr_write_b32 a181, v197
		v_mov_b32_e32 v47, v199
		v_accvgpr_write_b32 a182, v47
		v_accvgpr_read_b32 v47, a153
		v_accvgpr_write_b32 a183, v47
		v_mov_b32_e32 v47, v198
		v_accvgpr_write_b32 a184, v47
		v_accvgpr_read_b32 v47, a152
		v_accvgpr_write_b32 a185, v47
		v_accvgpr_read_b32 v196, a182
		v_accvgpr_read_b32 v197, a183
		v_accvgpr_read_b32 v198, a184
		v_accvgpr_read_b32 v199, a185
		v_pk_add_f32 v[196:197], v[198:199], v[196:197]
		v_accvgpr_write_b32 a152, v196
		v_accvgpr_write_b32 a153, v197
		v_accvgpr_read_b32 v47, a155
		v_mov_b32_e32 v196, v47
		v_accvgpr_read_b32 v47, a157
		v_mov_b32_e32 v197, v47
		v_accvgpr_read_b32 v47, a154
		v_mov_b32_e32 v198, v47
		v_accvgpr_read_b32 v47, a156
		v_mov_b32_e32 v199, v47
		v_pk_add_f32 v[196:197], v[198:199], v[196:197]
		v_accvgpr_write_b32 a154, v196
		v_accvgpr_write_b32 a155, v197
		v_accvgpr_read_b32 v47, a159
		v_mov_b32_e32 v196, v47
		v_accvgpr_read_b32 v47, a161
		v_mov_b32_e32 v197, v47
		v_accvgpr_read_b32 v47, a158
		v_mov_b32_e32 v198, v47
		v_accvgpr_read_b32 v47, a160
		v_mov_b32_e32 v199, v47
		v_pk_add_f32 v[196:197], v[198:199], v[196:197]
		v_accvgpr_write_b32 a156, v196
		v_accvgpr_write_b32 a157, v197
		v_accvgpr_read_b32 v47, a163
		v_mov_b32_e32 v196, v47
		v_accvgpr_read_b32 v47, a165
		v_mov_b32_e32 v197, v47
		v_accvgpr_read_b32 v47, a162
		v_mov_b32_e32 v198, v47
		v_accvgpr_read_b32 v47, a164
		v_mov_b32_e32 v199, v47
		v_pk_add_f32 v[196:197], v[198:199], v[196:197]
		v_accvgpr_write_b32 a158, v196
		v_accvgpr_write_b32 a159, v197
		v_accvgpr_read_b32 v47, a167
		v_mov_b32_e32 v196, v47
		v_accvgpr_read_b32 v47, a169
		v_mov_b32_e32 v197, v47
		v_accvgpr_read_b32 v47, a166
		v_mov_b32_e32 v198, v47
		v_accvgpr_read_b32 v47, a168
		v_mov_b32_e32 v199, v47
		v_pk_add_f32 v[196:197], v[198:199], v[196:197]
		v_accvgpr_write_b32 a160, v196
		v_accvgpr_write_b32 a161, v197
		v_accvgpr_read_b32 v47, a171
		v_mov_b32_e32 v196, v47
		v_accvgpr_read_b32 v47, a173
		v_mov_b32_e32 v197, v47
		v_accvgpr_read_b32 v47, a170
		v_mov_b32_e32 v198, v47
		v_accvgpr_read_b32 v47, a172
		v_mov_b32_e32 v199, v47
		v_pk_add_f32 v[196:197], v[198:199], v[196:197]
		v_accvgpr_write_b32 a162, v196
		v_accvgpr_write_b32 a163, v197
		v_accvgpr_read_b32 v47, a175
		v_mov_b32_e32 v196, v47
		v_accvgpr_read_b32 v47, a177
		v_mov_b32_e32 v197, v47
		v_accvgpr_read_b32 v47, a174
		v_mov_b32_e32 v198, v47
		v_accvgpr_read_b32 v47, a176
		v_mov_b32_e32 v199, v47
		v_pk_add_f32 v[196:197], v[198:199], v[196:197]
		v_accvgpr_write_b32 a164, v196
		v_accvgpr_write_b32 a165, v197
		v_accvgpr_read_b32 v47, a179
		v_mov_b32_e32 v196, v47
		v_accvgpr_read_b32 v47, a181
		v_mov_b32_e32 v197, v47
		v_accvgpr_read_b32 v47, a178
		v_mov_b32_e32 v198, v47
		v_accvgpr_read_b32 v47, a180
		v_mov_b32_e32 v199, v47
		v_pk_add_f32 v[196:197], v[198:199], v[196:197]
		v_accvgpr_write_b32 a166, v196
		v_accvgpr_write_b32 a167, v197
		v_accvgpr_read_b32 v47, a153
		v_mov_b32_e32 v196, v47
		v_accvgpr_read_b32 v47, a155
		v_mov_b32_e32 v197, v47
		v_accvgpr_read_b32 v47, a152
		v_mov_b32_e32 v198, v47
		v_accvgpr_read_b32 v47, a154
		v_mov_b32_e32 v199, v47
		v_pk_add_f32 v[196:197], v[198:199], v[196:197]
		v_accvgpr_write_b32 a152, v196
		v_accvgpr_write_b32 a153, v197
		v_accvgpr_read_b32 v47, a157
		v_mov_b32_e32 v196, v47
		v_accvgpr_read_b32 v47, a159
		v_mov_b32_e32 v197, v47
		v_accvgpr_read_b32 v47, a156
		v_mov_b32_e32 v198, v47
		v_accvgpr_read_b32 v47, a158
		v_mov_b32_e32 v199, v47
		v_pk_add_f32 v[196:197], v[198:199], v[196:197]
		v_accvgpr_write_b32 a154, v196
		v_accvgpr_write_b32 a155, v197
		v_accvgpr_read_b32 v47, a161
		v_mov_b32_e32 v196, v47
		v_accvgpr_read_b32 v47, a163
		v_mov_b32_e32 v197, v47
		v_accvgpr_read_b32 v47, a160
		v_mov_b32_e32 v198, v47
		v_accvgpr_read_b32 v47, a162
		v_mov_b32_e32 v199, v47
		v_pk_add_f32 v[196:197], v[198:199], v[196:197]
		v_accvgpr_write_b32 a156, v196
		v_accvgpr_write_b32 a157, v197
		v_accvgpr_read_b32 v47, a165
		v_mov_b32_e32 v196, v47
		v_accvgpr_read_b32 v47, a167
		v_mov_b32_e32 v197, v47
		v_accvgpr_read_b32 v47, a164
		v_mov_b32_e32 v198, v47
		v_accvgpr_read_b32 v47, a166
		v_mov_b32_e32 v199, v47
		v_pk_add_f32 v[196:197], v[198:199], v[196:197]
		v_accvgpr_write_b32 a158, v196
		v_accvgpr_write_b32 a159, v197
		v_accvgpr_read_b32 v47, a153
		v_mov_b32_e32 v196, v47
		v_accvgpr_read_b32 v47, a155
		v_mov_b32_e32 v197, v47
		v_accvgpr_read_b32 v47, a152
		v_mov_b32_e32 v198, v47
		v_accvgpr_read_b32 v47, a154
		v_mov_b32_e32 v199, v47
		v_pk_add_f32 v[196:197], v[198:199], v[196:197]
		v_accvgpr_write_b32 a152, v196
		v_accvgpr_write_b32 a153, v197
		v_accvgpr_read_b32 v47, a157
		v_mov_b32_e32 v196, v47
		v_accvgpr_read_b32 v47, a159
		v_mov_b32_e32 v197, v47
		v_accvgpr_read_b32 v47, a156
		v_mov_b32_e32 v198, v47
		v_accvgpr_read_b32 v47, a158
		v_mov_b32_e32 v199, v47
		v_pk_add_f32 v[200:201], v[198:199], v[196:197]
		v_accvgpr_read_b32 v47, a153
		v_mov_b32_e32 v196, v47
		v_mov_b32_e32 v197, v201
		v_accvgpr_read_b32 v47, a152
		v_mov_b32_e32 v198, v47
		v_mov_b32_e32 v199, v200
		v_pk_add_f32 v[200:201], v[198:199], v[196:197]
		v_add_f32_e32 v47, v200, v201
		ds_bpermute_b32 v196, v18, v47
		s_waitcnt lgkmcnt(0)
		v_accvgpr_write_b32 a142, v196
		ds_bpermute_b32 v196, v13, v47
		s_waitcnt lgkmcnt(0)
		v_accvgpr_write_b32 a144, v196
		v_pk_add_f32 v[196:197], v[140:141], v[142:143]
		v_pk_add_f32 v[198:199], v[158:159], v[160:161]
		v_accvgpr_write_b32 a152, v198
		v_accvgpr_write_b32 a153, v199
		v_pk_add_f32 v[198:199], v[162:163], v[164:165]
		v_accvgpr_write_b32 a154, v198
		v_accvgpr_write_b32 a155, v199
		v_pk_add_f32 v[198:199], v[166:167], v[168:169]
		v_accvgpr_write_b32 a156, v198
		v_accvgpr_write_b32 a157, v199
		v_accvgpr_read_b32 v198, a142
		v_accvgpr_read_b32 v199, a143
		v_accvgpr_read_b32 v200, a144
		v_accvgpr_read_b32 v201, a145
		v_pk_add_f32 v[198:199], v[198:199], v[200:201]
		v_accvgpr_write_b32 a158, v198
		v_accvgpr_write_b32 a159, v199
		v_pk_add_f32 v[198:199], v[170:171], v[172:173]
		v_accvgpr_write_b32 a160, v198
		v_accvgpr_write_b32 a161, v199
		v_pk_add_f32 v[198:199], v[174:175], v[176:177]
		v_accvgpr_write_b32 a162, v198
		v_accvgpr_write_b32 a163, v199
		v_pk_add_f32 v[198:199], v[178:179], v[180:181]
		v_accvgpr_write_b32 a164, v198
		v_accvgpr_write_b32 a165, v199
		v_pk_add_f32 v[198:199], v[182:183], v[184:185]
		v_accvgpr_write_b32 a166, v198
		v_accvgpr_write_b32 a167, v199
		v_pk_add_f32 v[198:199], v[80:81], v[186:187]
		v_accvgpr_write_b32 a168, v198
		v_accvgpr_write_b32 a169, v199
		v_pk_add_f32 v[198:199], v[144:145], v[146:147]
		v_accvgpr_write_b32 a170, v198
		v_accvgpr_write_b32 a171, v199
		v_pk_add_f32 v[198:199], v[148:149], v[150:151]
		v_accvgpr_write_b32 a172, v198
		v_accvgpr_write_b32 a173, v199
		v_pk_add_f32 v[198:199], v[152:153], v[154:155]
		v_accvgpr_write_b32 a174, v198
		v_accvgpr_write_b32 a175, v199
		v_pk_add_f32 v[198:199], v[156:157], v[188:189]
		v_accvgpr_write_b32 a176, v198
		v_accvgpr_write_b32 a177, v199
		v_pk_add_f32 v[198:199], v[190:191], v[192:193]
		v_accvgpr_write_b32 a178, v198
		v_accvgpr_write_b32 a179, v199
		v_accvgpr_read_b32 v198, a146
		v_accvgpr_read_b32 v199, a147
		v_pk_add_f32 v[198:199], v[198:199], v[194:195]
		v_accvgpr_write_b32 a180, v198
		v_accvgpr_write_b32 a181, v199
		v_accvgpr_read_b32 v47, a159
		v_accvgpr_write_b32 a149, v47
		v_mov_b32_e32 v47, v196
		v_accvgpr_write_b32 a151, v47
		v_accvgpr_read_b32 v198, a148
		v_accvgpr_read_b32 v199, a149
		v_accvgpr_read_b32 v200, a150
		v_accvgpr_read_b32 v201, a151
		v_pk_add_f32 v[198:199], v[198:199], v[200:201]
		v_accvgpr_write_b32 a182, v198
		v_accvgpr_write_b32 a183, v199
		v_mov_b32_e32 v198, v197
		v_accvgpr_read_b32 v47, a154
		v_mov_b32_e32 v199, v47
		v_accvgpr_read_b32 v196, a152
		v_accvgpr_read_b32 v197, a153
		v_pk_add_f32 v[196:197], v[198:199], v[196:197]
		v_accvgpr_write_b32 a152, v196
		v_accvgpr_write_b32 a153, v197
		v_accvgpr_read_b32 v47, a155
		v_mov_b32_e32 v196, v47
		v_accvgpr_read_b32 v47, a160
		v_mov_b32_e32 v197, v47
		v_accvgpr_read_b32 v198, a156
		v_accvgpr_read_b32 v199, a157
		v_pk_add_f32 v[196:197], v[196:197], v[198:199]
		v_accvgpr_write_b32 a154, v196
		v_accvgpr_write_b32 a155, v197
		v_accvgpr_read_b32 v47, a161
		v_mov_b32_e32 v196, v47
		v_accvgpr_read_b32 v47, a164
		v_mov_b32_e32 v197, v47
		v_accvgpr_read_b32 v198, a162
		v_accvgpr_read_b32 v199, a163
		v_pk_add_f32 v[196:197], v[196:197], v[198:199]
		v_accvgpr_write_b32 a156, v196
		v_accvgpr_write_b32 a157, v197
		v_accvgpr_read_b32 v47, a165
		v_mov_b32_e32 v196, v47
		v_accvgpr_read_b32 v47, a168
		v_mov_b32_e32 v197, v47
		v_accvgpr_read_b32 v198, a166
		v_accvgpr_read_b32 v199, a167
		v_pk_add_f32 v[196:197], v[196:197], v[198:199]
		v_accvgpr_write_b32 a160, v196
		v_accvgpr_write_b32 a161, v197
		v_accvgpr_read_b32 v47, a169
		v_mov_b32_e32 v196, v47
		v_accvgpr_read_b32 v47, a172
		v_mov_b32_e32 v197, v47
		v_accvgpr_read_b32 v198, a170
		v_accvgpr_read_b32 v199, a171
		v_pk_add_f32 v[196:197], v[196:197], v[198:199]
		v_accvgpr_write_b32 a162, v196
		v_accvgpr_write_b32 a163, v197
		v_accvgpr_read_b32 v47, a173
		v_mov_b32_e32 v196, v47
		v_accvgpr_read_b32 v47, a176
		v_mov_b32_e32 v197, v47
		v_accvgpr_read_b32 v198, a174
		v_accvgpr_read_b32 v199, a175
		v_pk_add_f32 v[196:197], v[196:197], v[198:199]
		v_accvgpr_write_b32 a164, v196
		v_accvgpr_write_b32 a165, v197
		v_accvgpr_read_b32 v47, a177
		v_mov_b32_e32 v196, v47
		v_accvgpr_read_b32 v47, a180
		v_mov_b32_e32 v197, v47
		v_accvgpr_read_b32 v198, a178
		v_accvgpr_read_b32 v199, a179
		v_pk_add_f32 v[196:197], v[196:197], v[198:199]
		v_accvgpr_write_b32 a166, v196
		v_accvgpr_write_b32 a167, v197
		v_accvgpr_read_b32 v47, a181
		v_mov_b32_e32 v196, v47
		v_accvgpr_read_b32 v47, a152
		v_mov_b32_e32 v197, v47
		v_accvgpr_read_b32 v198, a182
		v_accvgpr_read_b32 v199, a183
		v_pk_add_f32 v[196:197], v[196:197], v[198:199]
		v_accvgpr_write_b32 a168, v196
		v_accvgpr_write_b32 a169, v197
		v_accvgpr_read_b32 v47, a153
		v_mov_b32_e32 v196, v47
		v_accvgpr_read_b32 v47, a156
		v_mov_b32_e32 v197, v47
		v_accvgpr_read_b32 v198, a154
		v_accvgpr_read_b32 v199, a155
		v_pk_add_f32 v[196:197], v[196:197], v[198:199]
		v_accvgpr_write_b32 a152, v196
		v_accvgpr_write_b32 a153, v197
		v_accvgpr_read_b32 v47, a157
		v_mov_b32_e32 v196, v47
		v_accvgpr_read_b32 v47, a162
		v_mov_b32_e32 v197, v47
		v_accvgpr_read_b32 v198, a160
		v_accvgpr_read_b32 v199, a161
		v_pk_add_f32 v[196:197], v[196:197], v[198:199]
		v_accvgpr_write_b32 a154, v196
		v_accvgpr_write_b32 a155, v197
		v_accvgpr_read_b32 v47, a163
		v_mov_b32_e32 v196, v47
		v_accvgpr_read_b32 v47, a166
		v_mov_b32_e32 v197, v47
		v_accvgpr_read_b32 v198, a164
		v_accvgpr_read_b32 v199, a165
		v_pk_add_f32 v[196:197], v[196:197], v[198:199]
		v_accvgpr_write_b32 a156, v196
		v_accvgpr_write_b32 a157, v197
		v_accvgpr_read_b32 v47, a167
		v_mov_b32_e32 v196, v47
		v_accvgpr_read_b32 v47, a152
		v_mov_b32_e32 v197, v47
		v_accvgpr_read_b32 v198, a168
		v_accvgpr_read_b32 v199, a169
		v_pk_add_f32 v[196:197], v[196:197], v[198:199]
		v_accvgpr_write_b32 a160, v196
		v_accvgpr_write_b32 a161, v197
		v_accvgpr_read_b32 v47, a153
		v_accvgpr_write_b32 a152, v47
		v_accvgpr_read_b32 v47, a156
		v_accvgpr_write_b32 a153, v47
		v_accvgpr_read_b32 v196, a154
		v_accvgpr_read_b32 v197, a155
		v_accvgpr_read_b32 v198, a152
		v_accvgpr_read_b32 v199, a153
		v_pk_add_f32 v[196:197], v[198:199], v[196:197]
		v_accvgpr_write_b32 a152, v196
		v_accvgpr_write_b32 a153, v197
		v_accvgpr_read_b32 v47, a157
		v_accvgpr_write_b32 a154, v47
		v_accvgpr_read_b32 v47, a152
		v_accvgpr_write_b32 a155, v47
		v_accvgpr_read_b32 v196, a160
		v_accvgpr_read_b32 v197, a161
		v_accvgpr_read_b32 v198, a154
		v_accvgpr_read_b32 v199, a155
		v_pk_add_f32 v[200:201], v[198:199], v[196:197]
		v_accvgpr_read_b32 v47, a153
		v_add_f32_e32 v47, v47, v200
		v_add_f32_e32 v47, v201, v47
		ds_bpermute_b32 v196, v18, v47
		ds_bpermute_b32 v197, v13, v47
		v_sub_f32_e32 v17, v17, v45
		v_sub_f32_e32 v21, v21, v46
		v_exp_f32_e32 v198, v17
		v_exp_f32_e32 v200, v21
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v203, v196, v197
		v_mov_b32_e32 v199, v198
		v_pk_mul_f32 v[48:49], v[48:49], v[198:199]
		v_pk_mul_f32 v[50:51], v[50:51], v[198:199]
		v_pk_mul_f32 v[52:53], v[52:53], v[198:199]
		v_pk_mul_f32 v[54:55], v[54:55], v[198:199]
		v_pk_mul_f32 v[56:57], v[56:57], v[198:199]
		v_pk_mul_f32 v[58:59], v[58:59], v[198:199]
		v_pk_mul_f32 v[60:61], v[60:61], v[198:199]
		v_pk_mul_f32 v[62:63], v[62:63], v[198:199]
		v_pk_mul_f32 v[64:65], v[64:65], v[198:199]
		v_pk_mul_f32 v[66:67], v[66:67], v[198:199]
		v_pk_mul_f32 v[68:69], v[68:69], v[198:199]
		v_pk_mul_f32 v[70:71], v[70:71], v[198:199]
		v_pk_mul_f32 v[72:73], v[72:73], v[198:199]
		v_pk_mul_f32 v[74:75], v[74:75], v[198:199]
		v_pk_mul_f32 v[76:77], v[76:77], v[198:199]
		v_pk_mul_f32 v[78:79], v[78:79], v[198:199]
		v_mov_b32_e32 v201, v200
		v_accvgpr_read_b32 v196, a48
		v_accvgpr_read_b32 v197, a49
		v_pk_mul_f32 v[196:197], v[196:197], v[200:201]
		v_accvgpr_write_b32 a48, v196
		v_accvgpr_write_b32 a49, v197
		v_accvgpr_read_b32 v196, a50
		v_accvgpr_read_b32 v197, a51
		v_pk_mul_f32 v[196:197], v[196:197], v[200:201]
		v_accvgpr_write_b32 a50, v196
		v_accvgpr_write_b32 a51, v197
		v_accvgpr_read_b32 v196, a52
		v_accvgpr_read_b32 v197, a53
		v_pk_mul_f32 v[196:197], v[196:197], v[200:201]
		v_accvgpr_write_b32 a52, v196
		v_accvgpr_write_b32 a53, v197
		v_accvgpr_read_b32 v196, a54
		v_accvgpr_read_b32 v197, a55
		v_pk_mul_f32 v[196:197], v[196:197], v[200:201]
		v_accvgpr_write_b32 a54, v196
		v_accvgpr_write_b32 a55, v197
		v_accvgpr_read_b32 v196, a56
		v_accvgpr_read_b32 v197, a57
		v_pk_mul_f32 v[196:197], v[196:197], v[200:201]
		v_accvgpr_write_b32 a56, v196
		v_accvgpr_write_b32 a57, v197
		v_accvgpr_read_b32 v196, a58
		v_accvgpr_read_b32 v197, a59
		v_pk_mul_f32 v[196:197], v[196:197], v[200:201]
		v_accvgpr_write_b32 a58, v196
		v_accvgpr_write_b32 a59, v197
		v_accvgpr_read_b32 v196, a60
		v_accvgpr_read_b32 v197, a61
		v_pk_mul_f32 v[196:197], v[196:197], v[200:201]
		v_accvgpr_write_b32 a60, v196
		v_accvgpr_write_b32 a61, v197
		v_accvgpr_read_b32 v196, a62
		v_accvgpr_read_b32 v197, a63
		v_pk_mul_f32 v[196:197], v[196:197], v[200:201]
		v_accvgpr_write_b32 a62, v196
		v_accvgpr_write_b32 a63, v197
		v_accvgpr_read_b32 v196, a64
		v_accvgpr_read_b32 v197, a65
		v_pk_mul_f32 v[196:197], v[196:197], v[200:201]
		v_accvgpr_write_b32 a64, v196
		v_accvgpr_write_b32 a65, v197
		v_accvgpr_read_b32 v196, a66
		v_accvgpr_read_b32 v197, a67
		v_pk_mul_f32 v[196:197], v[196:197], v[200:201]
		v_accvgpr_write_b32 a66, v196
		v_accvgpr_write_b32 a67, v197
		v_accvgpr_read_b32 v196, a68
		v_accvgpr_read_b32 v197, a69
		v_pk_mul_f32 v[196:197], v[196:197], v[200:201]
		v_accvgpr_write_b32 a68, v196
		v_accvgpr_write_b32 a69, v197
		v_accvgpr_read_b32 v196, a70
		v_accvgpr_read_b32 v197, a71
		v_pk_mul_f32 v[196:197], v[196:197], v[200:201]
		v_accvgpr_write_b32 a70, v196
		v_accvgpr_write_b32 a71, v197
		v_accvgpr_read_b32 v196, a72
		v_accvgpr_read_b32 v197, a73
		v_pk_mul_f32 v[196:197], v[196:197], v[200:201]
		v_accvgpr_write_b32 a72, v196
		v_accvgpr_write_b32 a73, v197
		v_accvgpr_read_b32 v196, a74
		v_accvgpr_read_b32 v197, a75
		v_pk_mul_f32 v[196:197], v[196:197], v[200:201]
		v_accvgpr_write_b32 a74, v196
		v_accvgpr_write_b32 a75, v197
		v_accvgpr_read_b32 v196, a76
		v_accvgpr_read_b32 v197, a77
		v_pk_mul_f32 v[196:197], v[196:197], v[200:201]
		v_accvgpr_write_b32 a76, v196
		v_accvgpr_write_b32 a77, v197
		v_accvgpr_read_b32 v196, a78
		v_accvgpr_read_b32 v197, a79
		v_pk_mul_f32 v[196:197], v[196:197], v[200:201]
		v_accvgpr_write_b32 a78, v196
		v_accvgpr_write_b32 a79, v197
		v_accvgpr_read_b32 v17, a158
		v_mov_b32_e32 v202, v17
		v_mov_b32_e32 v196, v198
		v_mov_b32_e32 v197, v200
		v_accvgpr_read_b32 v17, a42
		v_mov_b32_e32 v198, v17
		v_accvgpr_read_b32 v17, a43
		v_mov_b32_e32 v199, v17
		v_pk_fma_f32 v[196:197], v[198:199], v[196:197], v[202:203]
		v_accvgpr_write_b32 a42, v196
		v_accvgpr_write_b32 a43, v197
		v_accvgpr_read_b32 v17, a140
		v_cvt_pk_bf16_f32 v196, v17, v208
		v_accvgpr_read_b32 v17, a141
		v_cvt_pk_bf16_f32 v197, v17, v209
		v_cvt_pk_bf16_f32 v198, v82, v86
		v_cvt_pk_bf16_f32 v199, v83, v87
		v_cvt_pk_bf16_f32 v200, v88, v210
		v_cvt_pk_bf16_f32 v201, v89, v211
		v_cvt_pk_bf16_f32 v202, v84, v90
		v_cvt_pk_bf16_f32 v203, v85, v91
		v_cvt_pk_bf16_f32 v84, v92, v94
		v_cvt_pk_bf16_f32 v85, v93, v95
		v_cvt_pk_bf16_f32 v86, v96, v98
		v_cvt_pk_bf16_f32 v87, v97, v99
		v_cvt_pk_bf16_f32 v88, v100, v102
		v_cvt_pk_bf16_f32 v89, v101, v103
		v_cvt_pk_bf16_f32 v90, v104, v106
		v_cvt_pk_bf16_f32 v91, v105, v107
		v_cvt_pk_bf16_f32 v92, v108, v110
		v_cvt_pk_bf16_f32 v93, v109, v111
		v_cvt_pk_bf16_f32 v94, v112, v114
		v_cvt_pk_bf16_f32 v95, v113, v115
		v_cvt_pk_bf16_f32 v96, v116, v118
		v_cvt_pk_bf16_f32 v97, v117, v119
		v_cvt_pk_bf16_f32 v98, v120, v122
		v_cvt_pk_bf16_f32 v99, v121, v123
		v_cvt_pk_bf16_f32 v100, v124, v126
		v_cvt_pk_bf16_f32 v101, v125, v127
		v_cvt_pk_bf16_f32 v102, v128, v130
		v_cvt_pk_bf16_f32 v103, v129, v131
		v_cvt_pk_bf16_f32 v104, v132, v134
		v_cvt_pk_bf16_f32 v105, v133, v135
		v_cvt_pk_bf16_f32 v106, v136, v138
		v_cvt_pk_bf16_f32 v107, v137, v139
		v_accvgpr_read_b32 v17, a143
		v_accvgpr_read_b32 v21, a145
		v_cvt_pk_bf16_f32 v108, v17, v21
		v_cvt_pk_bf16_f32 v109, v140, v142
		v_cvt_pk_bf16_f32 v110, v141, v143
		v_cvt_pk_bf16_f32 v111, v158, v160
		v_cvt_pk_bf16_f32 v112, v159, v161
		v_cvt_pk_bf16_f32 v113, v162, v164
		v_cvt_pk_bf16_f32 v114, v163, v165
		v_cvt_pk_bf16_f32 v115, v166, v168
		v_cvt_pk_bf16_f32 v116, v167, v169
		v_cvt_pk_bf16_f32 v117, v170, v172
		v_cvt_pk_bf16_f32 v118, v171, v173
		v_cvt_pk_bf16_f32 v119, v174, v176
		v_cvt_pk_bf16_f32 v120, v175, v177
		v_cvt_pk_bf16_f32 v121, v178, v180
		v_cvt_pk_bf16_f32 v122, v179, v181
		v_cvt_pk_bf16_f32 v123, v182, v184
		v_cvt_pk_bf16_f32 v124, v183, v185
		v_cvt_pk_bf16_f32 v125, v80, v186
		v_cvt_pk_bf16_f32 v126, v81, v187
		v_cvt_pk_bf16_f32 v127, v144, v146
		v_cvt_pk_bf16_f32 v80, v145, v147
		v_cvt_pk_bf16_f32 v81, v148, v150
		v_cvt_pk_bf16_f32 v82, v149, v151
		v_cvt_pk_bf16_f32 v83, v152, v154
		v_cvt_pk_bf16_f32 v128, v153, v155
		v_cvt_pk_bf16_f32 v129, v156, v188
		v_cvt_pk_bf16_f32 v130, v157, v189
		v_cvt_pk_bf16_f32 v131, v190, v192
		v_cvt_pk_bf16_f32 v132, v191, v193
		v_accvgpr_read_b32 v17, a146
		v_cvt_pk_bf16_f32 v133, v17, v194
		v_accvgpr_read_b32 v17, a147
		v_cvt_pk_bf16_f32 v134, v17, v195
		v_accvgpr_read_b32 v17, a148
		v_accvgpr_read_b32 v21, a150
		v_cvt_pk_bf16_f32 v135, v17, v21
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_permlane32_swap_b32_e32 v84, v86
		v_permlane32_swap_b32_e32 v85, v87
		v_permlane32_swap_b32_e32 v88, v90
		v_permlane32_swap_b32_e32 v89, v91
		v_permlane32_swap_b32_e32 v92, v94
		v_permlane32_swap_b32_e32 v93, v95
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_permlane32_swap_b32_e32 v80, v82
		v_permlane32_swap_b32_e32 v81, v83
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[48:63], a[44:47], v[196:199], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[108:111], v[196:199], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[108:111], v[108:111], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[44:47], v[108:111], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[80:83], v[200:203], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[112:115], v[200:203], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[112:115], v[112:115], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[80:83], v[112:115], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[84:87], v[84:87], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[116:119], v[84:87], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[116:119], v[116:119], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[84:87], v[116:119], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[88:91], v[88:91], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[120:123], v[88:91], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[120:123], v[120:123], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[88:91], v[120:123], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[92:95], v[92:95], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[124:127], v[92:95], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[124:127], v[124:127], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[92:95], v[124:127], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[96:99], v[96:99], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[128:131], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[128:131], v[80:83], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[96:99], v[80:83], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[100:103], v[100:103], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[132:135], v[100:103], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[132:135], v[128:131], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[100:103], v[128:131], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[104:107], v[104:107], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[136:139], v[104:107], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[136:139], v[132:135], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[104:107], v[132:135], a[48:63]
		s_mov_b32 s40, s45
		v_mov_b32_e32 v17, v45
		v_mov_b32_e32 v21, v46
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_1
.L_attn_fwd_persistent.loop_exit_1:
		s_mul_i32 s26, s26, 0x80
		v_readfirstlane_b32 s40, v3
		s_nop 1
		v_mov_b32_e32 v31, s40
		s_nop 0
		v_readfirstlane_b32 s42, v31
		s_nop 1
		v_add_u32_e32 v12, s42, v12
		v_add_u32_e32 v12, s21, v12
		v_readfirstlane_b32 s42, v3
		s_nop 1
		v_mov_b32_e32 v31, s42
		s_nop 0
		v_readfirstlane_b32 s43, v31
		s_nop 1
		v_add_u32_e32 v8, s43, v8
		v_add_u32_e32 v8, s21, v8
		v_xor_b32_e32 v31, 1, v19
		v_xor_b32_e32 v43, 2, v19
		v_xor_b32_e32 v45, 3, v19
		v_xor_b32_e32 v46, 8, v19
		v_xor_b32_e32 v47, 9, v19
		v_xor_b32_e32 v80, 10, v19
		v_xor_b32_e32 v81, 11, v19
		v_xor_b32_e32 v82, 16, v19
		v_xor_b32_e32 v83, 17, v19
		v_xor_b32_e32 v84, 18, v19
		v_xor_b32_e32 v85, 19, v19
		v_xor_b32_e32 v86, 24, v19
		v_xor_b32_e32 v87, 25, v19
		v_xor_b32_e32 v88, 26, v19
		v_xor_b32_e32 v89, 27, v19
		v_xor_b32_e32 v90, 32, v19
		v_xor_b32_e32 v91, 33, v19
		v_xor_b32_e32 v92, 34, v19
		v_xor_b32_e32 v93, 35, v19
		v_xor_b32_e32 v94, 40, v19
		v_xor_b32_e32 v95, 41, v19
		v_xor_b32_e32 v96, 42, v19
		v_xor_b32_e32 v97, 43, v19
		v_xor_b32_e32 v98, 48, v19
		v_xor_b32_e32 v99, 49, v19
		v_xor_b32_e32 v100, 50, v19
		v_xor_b32_e32 v101, 51, v19
		v_xor_b32_e32 v102, 56, v19
		v_xor_b32_e32 v103, 57, v19
		v_xor_b32_e32 v104, 58, v19
		v_xor_b32_e32 v105, 59, v19
		v_xor_b32_e32 v106, 64, v19
		v_xor_b32_e32 v107, 0x41, v19
		v_xor_b32_e32 v108, 0x42, v19
		v_xor_b32_e32 v109, 0x43, v19
		v_xor_b32_e32 v110, 0x48, v19
		v_xor_b32_e32 v111, 0x49, v19
		v_xor_b32_e32 v112, 0x4a, v19
		v_xor_b32_e32 v113, 0x4b, v19
		v_xor_b32_e32 v114, 0x50, v19
		v_xor_b32_e32 v115, 0x51, v19
		v_xor_b32_e32 v116, 0x52, v19
		v_xor_b32_e32 v117, 0x53, v19
		v_xor_b32_e32 v118, 0x58, v19
		v_xor_b32_e32 v119, 0x59, v19
		v_xor_b32_e32 v120, 0x5a, v19
		v_xor_b32_e32 v121, 0x5b, v19
		v_xor_b32_e32 v122, 0x60, v19
		v_xor_b32_e32 v123, 0x61, v19
		v_xor_b32_e32 v124, 0x62, v19
		v_xor_b32_e32 v125, 0x63, v19
		v_xor_b32_e32 v126, 0x68, v19
		v_xor_b32_e32 v127, 0x69, v19
		v_xor_b32_e32 v128, 0x6a, v19
		v_xor_b32_e32 v129, 0x6b, v19
		v_xor_b32_e32 v130, 0x70, v19
		v_xor_b32_e32 v131, 0x71, v19
		v_xor_b32_e32 v132, 0x72, v19
		v_xor_b32_e32 v133, 0x73, v19
		v_xor_b32_e32 v134, 0x78, v19
		v_xor_b32_e32 v135, 0x79, v19
		v_xor_b32_e32 v136, 0x7a, v19
		v_xor_b32_e32 v137, 0x7b, v19
		v_lshl_add_u32 v35, v35, 4, v38
		v_add3_u32 v35, v35, v40, v41
		v_add3_u32 v35, v35, v42, v39
		v_add3_u32 v36, v36, v37, v44
		v_lshl_add_u32 v25, v25, 3, v36
		v_mov_b32_e32 v36, 0xff800000
		s_cmp_lt_i32 s46, s26
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_2
.L_attn_fwd_persistent.loop_head_2:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s21, s46, 0x80
		s_cmp_lt_i32 s46, 0
		s_cselect_b32 s43, s27, 0
		s_add_i32 s43, s46, s43
		s_ashr_i32 s43, s43, 7
		s_cmp_lt_i32 s43, 0
		s_cselect_b32 s45, s16, 0
		s_add_i32 s45, s43, s45
		s_ashr_i32 s45, s45, 1
		s_lshl_b32 s45, s45, 1
		s_xor_b32 s45, s45, -1
		s_add_i32 s45, s45, 1
		s_add_i32 s45, s43, s45
		s_add_i32 s43, s43, 1
		s_cmp_lt_i32 s43, 0
		s_cselect_b32 s53, s16, 0
		s_add_i32 s53, s43, s53
		s_ashr_i32 s53, s53, 1
		s_lshl_b32 s53, s53, 1
		s_xor_b32 s53, s53, -1
		s_add_i32 s53, s53, 1
		s_add_i32 s54, s43, s53
		s_mul_i32 s43, 0x4100, s45
		v_add_u32_e32 v37, s43, v35
		ds_read_b128 v[140:143], v37
		ds_read_b128 v[144:147], v37 offset:32
		ds_read_b128 v[148:151], v37 offset:64
		ds_read_b128 v[152:155], v37 offset:96
		ds_read_b128 v[156:159], v37 offset:256
		ds_read_b128 v[160:163], v37 offset:288
		ds_read_b128 v[164:167], v37 offset:320
		ds_read_b128 a[44:47], v37 offset:352
		ds_read_b128 v[168:171], v37 offset:128
		ds_read_b128 v[172:175], v37 offset:160
		ds_read_b128 v[176:179], v37 offset:192
		ds_read_b128 a[80:83], v37 offset:224
		ds_read_b128 v[180:183], v37 offset:384
		ds_read_b128 v[184:187], v37 offset:416
		ds_read_b128 v[188:191], v37 offset:448
		ds_read_b128 v[192:195], v37 offset:480
		s_mul_i32 s43, 0x4400, s45
		v_add_u32_e32 v37, s43, v25
		ds_read_b64_tr_b16 a[84:85], v37 offset:33264
		ds_read_b64_tr_b16 a[86:87], v37 offset:37616
		ds_read_b64_tr_b16 a[88:89], v37 offset:33392
		ds_read_b64_tr_b16 a[90:91], v37 offset:37744
		ds_read_b64_tr_b16 a[92:93], v37 offset:33520
		ds_read_b64_tr_b16 a[94:95], v37 offset:37872
		ds_read_b64_tr_b16 a[96:97], v37 offset:33648
		ds_read_b64_tr_b16 a[98:99], v37 offset:38000
		ds_read_b64_tr_b16 a[100:101], v37 offset:33776
		ds_read_b64_tr_b16 a[102:103], v37 offset:38128
		ds_read_b64_tr_b16 a[104:105], v37 offset:33904
		ds_read_b64_tr_b16 a[106:107], v37 offset:38256
		ds_read_b64_tr_b16 a[108:109], v37 offset:34032
		ds_read_b64_tr_b16 a[110:111], v37 offset:38384
		ds_read_b64_tr_b16 a[112:113], v37 offset:34160
		ds_read_b64_tr_b16 a[114:115], v37 offset:38512
		ds_read_b64_tr_b16 a[116:117], v37 offset:33328
		ds_read_b64_tr_b16 a[118:119], v37 offset:37680
		ds_read_b64_tr_b16 a[120:121], v37 offset:33456
		ds_read_b64_tr_b16 a[122:123], v37 offset:37808
		ds_read_b64_tr_b16 a[124:125], v37 offset:33584
		ds_read_b64_tr_b16 a[126:127], v37 offset:37936
		ds_read_b64_tr_b16 a[128:129], v37 offset:33712
		ds_read_b64_tr_b16 a[130:131], v37 offset:38064
		ds_read_b64_tr_b16 a[132:133], v37 offset:33840
		ds_read_b64_tr_b16 a[134:135], v37 offset:38192
		ds_read_b64_tr_b16 a[136:137], v37 offset:33968
		ds_read_b64_tr_b16 a[138:139], v37 offset:38320
		ds_read_b64_tr_b16 a[140:141], v37 offset:34096
		ds_read_b64_tr_b16 a[142:143], v37 offset:38448
		ds_read_b64_tr_b16 v[196:197], v37 offset:34224
		ds_read_b64_tr_b16 v[198:199], v37 offset:38576
		s_cmp_lt_i32 s21, s25
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_1
		s_waitcnt lgkmcnt(14)
		s_barrier
		v_add_u32_e32 v37, s21, v22
		v_add_u32_e32 v38, s21, v24
		v_add_u32_e32 v39, s21, v32
		v_add_u32_e32 v40, s21, v11
		v_cmp_lt_i32_e64 vcc, v37, s23
		s_mov_b64 s[58:59], vcc
		v_cmp_lt_i32_e64 vcc, v38, s23
		s_mov_b64 s[60:61], vcc
		v_cmp_lt_i32_e64 vcc, v39, s23
		s_mov_b64 s[62:63], vcc
		v_cmp_lt_i32_e64 vcc, v40, s23
		s_mov_b64 s[64:65], vcc
		v_add_u32_e32 v37, s21, v16
		v_add_u32_e32 v38, s21, v33
		v_add_u32_e32 v39, s21, v34
		v_cmp_lt_i32_e64 vcc, v37, s23
		s_mov_b64 s[66:67], vcc
		v_cmp_lt_i32_e64 vcc, v38, s23
		s_mov_b64 s[68:69], vcc
		v_cmp_lt_i32_e64 vcc, v39, s23
		s_mov_b64 s[70:71], vcc
		s_mul_i32 s43, s15, s46
		s_lshl_b32 s43, s43, 1
		s_add_i32 s45, s47, s43
		v_add_u32_e32 v37, s45, v20
		s_mov_b32 s72, 1
		s_mov_b32 s73, 0
		s_mov_b32 s57, 0
		s_mul_i32 s74, s72, s56
		s_mul_hi_u32 s75, s72, s56
		s_mul_i32 s45, s72, s57
		s_add_i32 s75, s75, s45
		s_mul_i32 s45, s73, s56
		s_add_i32 s75, s75, s45
		s_lshr_b64 s[72:73], s[74:75], 6
		s_mov_b32 s74, 0x410
		s_mov_b32 s75, 0
		s_mul_i32 s76, s74, s72
		s_mul_hi_u32 s77, s74, s72
		s_mul_i32 s45, s74, s73
		s_add_i32 s77, s77, s45
		s_mul_i32 s45, s75, s72
		s_add_i32 s77, s77, s45
		s_cmp_lt_i32 s54, 0
		s_cselect_b32 s55, -1, 0
		s_mov_b32 s74, 0x4100
		s_mov_b32 s75, 0
		s_mul_i32 s78, s74, s54
		s_mul_hi_u32 s79, s74, s54
		s_mul_i32 s45, s74, s55
		s_add_i32 s79, s79, s45
		s_mul_i32 s45, s75, s54
		s_add_i32 s79, s79, s45
		s_add_u32 s74, s76, s78
		s_addc_u32 s75, s77, s79
		s_add_u32 s80, s74, 0
		s_addc_u32 s81, s75, 0
		s_mov_b32 m0, s80
		v_cndmask_b32_e64 v37, v30, v37, s[58:59]
		buffer_load_dwordx4 v37, s[28:31], 0 offen lds
		v_add_u32_e32 v37, s21, v15
		s_add_i32 s21, s48, s43
		v_add_u32_e32 v38, s21, v20
		s_add_u32 s58, s76, 0x1040
		s_addc_u32 s59, s77, 0
		s_add_u32 s58, s58, s78
		s_addc_u32 s59, s59, s79
		s_add_u32 s74, s58, 0
		s_addc_u32 s75, s59, 0
		s_mov_b32 m0, s74
		v_cndmask_b32_e64 v38, v30, v38, s[60:61]
		buffer_load_dwordx4 v38, s[28:31], 0 offen lds
		s_add_i32 s21, s49, s43
		v_add_u32_e32 v38, s21, v20
		s_add_u32 s58, s76, 0x2080
		s_addc_u32 s59, s77, 0
		s_add_u32 s58, s58, s78
		s_addc_u32 s59, s59, s79
		s_add_u32 s60, s58, 0
		s_addc_u32 s61, s59, 0
		s_mov_b32 m0, s60
		v_cndmask_b32_e64 v38, v30, v38, s[62:63]
		buffer_load_dwordx4 v38, s[28:31], 0 offen lds
		s_add_i32 s21, s41, s43
		v_add_u32_e32 v38, s21, v20
		s_add_u32 s58, s76, 0x30c0
		s_addc_u32 s59, s77, 0
		s_add_u32 s58, s58, s78
		s_addc_u32 s59, s59, s79
		s_add_u32 s60, s58, 0
		s_addc_u32 s61, s59, 0
		s_mov_b32 m0, s60
		v_cndmask_b32_e64 v38, v30, v38, s[64:65]
		buffer_load_dwordx4 v38, s[28:31], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s21, s20, s46
		s_lshl_b32 s21, s21, 1
		s_add_i32 s43, s50, s21
		v_add_u32_e32 v38, s43, v9
		s_mov_b32 s58, 0x440
		s_mov_b32 s59, 0
		s_mul_i32 s60, s58, s72
		s_mul_hi_u32 s61, s58, s72
		s_mul_i32 s43, s58, s73
		s_add_i32 s61, s61, s43
		s_mul_i32 s43, s59, s72
		s_add_i32 s61, s61, s43
		s_add_u32 s58, s60, 0x81f0
		s_addc_u32 s59, s61, 0
		s_mov_b32 s62, 0x4400
		s_mov_b32 s63, 0
		s_mul_i32 s64, s62, s54
		s_mul_hi_u32 s65, s62, s54
		s_mul_i32 s43, s62, s55
		s_add_i32 s65, s65, s43
		s_mul_i32 s43, s63, s54
		s_add_i32 s65, s65, s43
		s_add_u32 s54, s58, s64
		s_addc_u32 s55, s59, s65
		s_add_u32 s58, s54, 0
		s_addc_u32 s59, s55, 0
		s_mov_b32 m0, s58
		v_cndmask_b32_e64 v38, v30, v38, s[66:67]
		buffer_load_dwordx4 v38, s[32:35], 0 offen lds
		s_add_i32 s43, s51, s21
		v_add_u32_e32 v38, s43, v9
		s_add_u32 s54, s60, 0x92f0
		s_addc_u32 s55, s61, 0
		s_add_u32 s54, s54, s64
		s_addc_u32 s55, s55, s65
		s_add_u32 s58, s54, 0
		s_addc_u32 s59, s55, 0
		s_mov_b32 m0, s58
		v_cndmask_b32_e64 v38, v30, v38, s[68:69]
		buffer_load_dwordx4 v38, s[32:35], 0 offen lds
		s_add_i32 s43, s52, s21
		v_add_u32_e32 v38, s43, v9
		s_add_u32 s54, s60, 0xa3f0
		s_addc_u32 s55, s61, 0
		s_add_u32 s54, s54, s64
		s_addc_u32 s55, s55, s65
		s_add_u32 s58, s54, 0
		s_addc_u32 s59, s55, 0
		s_mov_b32 m0, s58
		v_cndmask_b32_e64 v38, v30, v38, s[70:71]
		buffer_load_dwordx4 v38, s[32:35], 0 offen lds
		s_add_i32 s21, s44, s21
		v_cmp_lt_i32_e64 vcc, v37, s23
		v_add_u32_e32 v37, s21, v9
		s_add_u32 s54, s60, 0xb4f0
		s_addc_u32 s55, s61, 0
		v_cndmask_b32_e32 v37, v30, v37, vcc
		s_add_u32 s54, s54, s64
		s_addc_u32 s55, s55, s65
		s_add_u32 s58, s54, 0
		s_addc_u32 s59, s55, 0
		s_mov_b32 m0, s58
		s_nop 0
		buffer_load_dwordx4 v37, s[32:35], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_1
.L_attn_fwd_persistent.if_else_1:
.L_attn_fwd_persistent.if_end_1:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[208:223], v[140:143], a[4:7], 0
		s_nop 11
		v_accvgpr_write_b32 a144, v208
		v_accvgpr_write_b32 a145, v209
		v_accvgpr_write_b32 a146, v210
		v_accvgpr_write_b32 a147, v211
		v_accvgpr_write_b32 a148, v212
		v_accvgpr_write_b32 a149, v213
		v_accvgpr_write_b32 a150, v214
		v_accvgpr_write_b32 a151, v215
		v_accvgpr_write_b32 a152, v216
		v_accvgpr_write_b32 a153, v217
		v_accvgpr_write_b32 a154, v218
		v_accvgpr_write_b32 a155, v219
		v_accvgpr_write_b32 a156, v220
		v_accvgpr_write_b32 a157, v221
		v_accvgpr_write_b32 a158, v222
		v_accvgpr_write_b32 a159, v223
		v_mfma_f32_32x32x16_bf16 v[208:223], v[156:159], a[4:7], 0
		s_nop 11
		v_accvgpr_write_b32 a160, v208
		v_accvgpr_write_b32 a161, v209
		v_accvgpr_write_b32 a162, v210
		v_accvgpr_write_b32 a163, v211
		v_accvgpr_write_b32 a164, v212
		v_accvgpr_write_b32 a165, v213
		v_accvgpr_write_b32 a166, v214
		v_accvgpr_write_b32 a167, v215
		v_accvgpr_write_b32 a168, v216
		v_accvgpr_write_b32 a169, v217
		v_accvgpr_write_b32 a170, v218
		v_accvgpr_write_b32 a171, v219
		v_accvgpr_write_b32 a172, v220
		v_accvgpr_write_b32 a173, v221
		v_accvgpr_write_b32 a174, v222
		v_accvgpr_write_b32 a175, v223
		v_mfma_f32_32x32x16_bf16 v[208:223], v[168:171], a[4:7], 0
		s_nop 11
		v_accvgpr_write_b32 a176, v208
		v_accvgpr_write_b32 a177, v209
		v_accvgpr_write_b32 a178, v210
		v_accvgpr_write_b32 a179, v211
		v_accvgpr_write_b32 a180, v212
		v_accvgpr_write_b32 a181, v213
		v_accvgpr_write_b32 a182, v214
		v_accvgpr_write_b32 a183, v215
		v_accvgpr_write_b32 a184, v216
		v_accvgpr_write_b32 a185, v217
		v_accvgpr_write_b32 a186, v218
		v_accvgpr_write_b32 a187, v219
		v_accvgpr_write_b32 a188, v220
		v_accvgpr_write_b32 a189, v221
		v_accvgpr_write_b32 a190, v222
		v_accvgpr_write_b32 a191, v223
		v_mfma_f32_32x32x16_bf16 v[208:223], v[180:183], a[4:7], 0
		s_nop 11
		v_accvgpr_write_b32 a192, v208
		v_accvgpr_write_b32 a193, v209
		v_accvgpr_write_b32 a194, v210
		v_accvgpr_write_b32 a195, v211
		v_accvgpr_write_b32 a196, v212
		v_accvgpr_write_b32 a197, v213
		v_accvgpr_write_b32 a198, v214
		v_accvgpr_write_b32 a199, v215
		v_accvgpr_write_b32 a200, v216
		v_accvgpr_write_b32 a201, v217
		v_accvgpr_write_b32 a202, v218
		v_accvgpr_write_b32 a203, v219
		v_accvgpr_write_b32 a204, v220
		v_accvgpr_write_b32 a205, v221
		v_accvgpr_write_b32 a206, v222
		v_accvgpr_write_b32 a207, v223
		v_mfma_f32_32x32x16_bf16 v[208:223], v[180:183], a[20:23], 0
		s_nop 11
		v_accvgpr_write_b32 a208, v208
		v_accvgpr_write_b32 a209, v209
		v_accvgpr_write_b32 a210, v210
		v_accvgpr_write_b32 a211, v211
		v_accvgpr_write_b32 a212, v212
		v_accvgpr_write_b32 a213, v213
		v_accvgpr_write_b32 a214, v214
		v_accvgpr_write_b32 a215, v215
		v_accvgpr_write_b32 a216, v216
		v_accvgpr_write_b32 a217, v217
		v_accvgpr_write_b32 a218, v218
		v_accvgpr_write_b32 a219, v219
		v_accvgpr_write_b32 a220, v220
		v_accvgpr_write_b32 a221, v221
		v_accvgpr_write_b32 a222, v222
		v_accvgpr_write_b32 a223, v223
		v_mfma_f32_32x32x16_bf16 v[208:223], v[140:143], a[20:23], 0
		s_nop 11
		v_accvgpr_write_b32 a224, v208
		v_accvgpr_write_b32 a225, v209
		v_accvgpr_write_b32 a226, v210
		v_accvgpr_write_b32 a227, v211
		v_accvgpr_write_b32 a228, v212
		v_accvgpr_write_b32 a229, v213
		v_accvgpr_write_b32 a230, v214
		v_accvgpr_write_b32 a231, v215
		v_accvgpr_write_b32 a232, v216
		v_accvgpr_write_b32 a233, v217
		v_accvgpr_write_b32 a234, v218
		v_accvgpr_write_b32 a235, v219
		v_accvgpr_write_b32 a236, v220
		v_accvgpr_write_b32 a237, v221
		v_accvgpr_write_b32 a238, v222
		v_accvgpr_write_b32 a239, v223
		v_mfma_f32_32x32x16_bf16 v[208:223], v[156:159], a[20:23], 0
		s_nop 11
		v_accvgpr_write_b32 a240, v208
		v_accvgpr_write_b32 a241, v209
		v_accvgpr_write_b32 a242, v210
		v_accvgpr_write_b32 a243, v211
		v_accvgpr_write_b32 a244, v212
		v_accvgpr_write_b32 a245, v213
		v_accvgpr_write_b32 a246, v214
		v_accvgpr_write_b32 a247, v215
		v_accvgpr_write_b32 a248, v216
		v_accvgpr_write_b32 a249, v217
		v_accvgpr_write_b32 a250, v218
		v_accvgpr_write_b32 a251, v219
		v_accvgpr_write_b32 a252, v220
		v_accvgpr_write_b32 a253, v221
		v_accvgpr_write_b32 a254, v222
		v_accvgpr_write_b32 a255, v223
		v_mfma_f32_32x32x16_bf16 v[208:223], v[168:171], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 a[144:159], v[144:147], a[8:11], a[144:159]
		v_mfma_f32_32x32x16_bf16 a[160:175], v[160:163], a[8:11], a[160:175]
		v_mfma_f32_32x32x16_bf16 a[176:191], v[172:175], a[8:11], a[176:191]
		v_mfma_f32_32x32x16_bf16 a[192:207], v[184:187], a[8:11], a[192:207]
		v_mfma_f32_32x32x16_bf16 a[208:223], v[184:187], a[24:27], a[208:223]
		v_mfma_f32_32x32x16_bf16 a[224:239], v[144:147], a[24:27], a[224:239]
		v_mfma_f32_32x32x16_bf16 a[240:255], v[160:163], a[24:27], a[240:255]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[172:175], a[24:27], v[208:223]
		v_mfma_f32_32x32x16_bf16 a[144:159], v[148:151], a[12:15], a[144:159]
		v_mfma_f32_32x32x16_bf16 a[160:175], v[164:167], a[12:15], a[160:175]
		v_mfma_f32_32x32x16_bf16 a[176:191], v[176:179], a[12:15], a[176:191]
		v_mfma_f32_32x32x16_bf16 a[192:207], v[188:191], a[12:15], a[192:207]
		v_mfma_f32_32x32x16_bf16 a[208:223], v[188:191], a[28:31], a[208:223]
		v_mfma_f32_32x32x16_bf16 a[224:239], v[148:151], a[28:31], a[224:239]
		v_mfma_f32_32x32x16_bf16 a[240:255], v[164:167], a[28:31], a[240:255]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[176:179], a[28:31], v[208:223]
		v_mfma_f32_32x32x16_bf16 a[144:159], v[152:155], a[16:19], a[144:159]
		v_mfma_f32_32x32x16_bf16 a[160:175], a[44:47], a[16:19], a[160:175]
		v_mfma_f32_32x32x16_bf16 a[176:191], a[80:83], a[16:19], a[176:191]
		v_mfma_f32_32x32x16_bf16 a[192:207], v[192:195], a[16:19], a[192:207]
		v_mfma_f32_32x32x16_bf16 a[208:223], v[192:195], a[32:35], a[208:223]
		v_mfma_f32_32x32x16_bf16 a[224:239], v[152:155], a[32:35], a[224:239]
		v_mfma_f32_32x32x16_bf16 a[240:255], a[44:47], a[32:35], a[240:255]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[80:83], a[32:35], v[208:223]
		v_add_u32_e32 v37, s46, v19
		v_add_u32_e32 v38, s46, v31
		v_add_u32_e32 v39, s46, v43
		v_add_u32_e32 v40, s46, v45
		v_add_u32_e32 v41, s46, v80
		v_add_u32_e32 v42, s46, v81
		v_add_u32_e32 v44, s46, v84
		v_add_u32_e32 v138, s46, v85
		v_add_u32_e32 v139, s46, v88
		v_add_u32_e32 v140, s46, v89
		v_add_u32_e32 v141, s46, v92
		v_add_u32_e32 v142, s46, v93
		v_add_u32_e32 v143, s46, v96
		v_add_u32_e32 v144, s46, v97
		v_add_u32_e32 v145, s46, v100
		v_add_u32_e32 v146, s46, v101
		v_add_u32_e32 v147, s46, v104
		v_add_u32_e32 v148, s46, v105
		v_add_u32_e32 v149, s46, v108
		v_add_u32_e32 v150, s46, v109
		v_add_u32_e32 v151, s46, v112
		v_add_u32_e32 v152, s46, v113
		v_add_u32_e32 v153, s46, v116
		v_add_u32_e32 v154, s46, v117
		v_add_u32_e32 v155, s46, v120
		v_add_u32_e32 v156, s46, v121
		v_add_u32_e32 v157, s46, v124
		v_add_u32_e32 v158, s46, v125
		v_add_u32_e32 v159, s46, v128
		v_add_u32_e32 v160, s46, v129
		v_add_u32_e32 v161, s46, v132
		v_add_u32_e32 v162, s46, v133
		v_add_u32_e32 v163, s46, v136
		v_add_u32_e32 v164, s46, v137
		v_cmp_ge_i32_e64 vcc, v12, v37
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v12, v38
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v12, v39
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v12, v40
		v_add_u32_e32 v37, s46, v46
		v_add_u32_e32 v38, s46, v47
		v_accvgpr_read_b32 v39, a147
		v_cndmask_b32_e32 v167, v36, v39, vcc
		v_cmp_ge_i32_e64 vcc, v12, v37
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v12, v38
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v12, v41
		s_mov_b64 s[66:67], vcc
		v_cmp_ge_i32_e64 vcc, v12, v42
		v_add_u32_e32 v39, s46, v82
		v_add_u32_e32 v40, s46, v83
		v_accvgpr_read_b32 v41, a151
		v_cndmask_b32_e32 v169, v36, v41, vcc
		v_cmp_ge_i32_e64 vcc, v12, v39
		s_mov_b64 s[68:69], vcc
		v_cmp_ge_i32_e64 vcc, v12, v40
		s_mov_b64 s[70:71], vcc
		v_cmp_ge_i32_e64 vcc, v12, v44
		s_mov_b64 s[72:73], vcc
		v_cmp_ge_i32_e64 vcc, v12, v138
		v_add_u32_e32 v41, s46, v86
		v_add_u32_e32 v42, s46, v87
		v_accvgpr_read_b32 v44, a155
		v_cndmask_b32_e32 v171, v36, v44, vcc
		v_cmp_ge_i32_e64 vcc, v12, v41
		s_mov_b64 s[74:75], vcc
		v_cmp_ge_i32_e64 vcc, v12, v42
		s_mov_b64 s[76:77], vcc
		v_cmp_ge_i32_e64 vcc, v12, v139
		s_mov_b64 s[78:79], vcc
		v_cmp_ge_i32_e64 vcc, v12, v140
		v_add_u32_e32 v44, s46, v90
		v_add_u32_e32 v138, s46, v91
		v_accvgpr_read_b32 v139, a159
		v_cndmask_b32_e32 v139, v36, v139, vcc
		v_accvgpr_write_b32 a45, v139
		v_cmp_ge_i32_e64 vcc, v12, v44
		s_mov_b64 s[80:81], vcc
		v_cmp_ge_i32_e64 vcc, v12, v138
		s_mov_b64 s[82:83], vcc
		v_cmp_ge_i32_e64 vcc, v12, v141
		s_mov_b64 s[84:85], vcc
		v_cmp_ge_i32_e64 vcc, v12, v142
		v_add_u32_e32 v139, s46, v94
		v_add_u32_e32 v140, s46, v95
		v_accvgpr_read_b32 v141, a163
		v_cndmask_b32_e32 v141, v36, v141, vcc
		v_accvgpr_write_b32 a47, v141
		v_cmp_ge_i32_e64 vcc, v12, v139
		s_mov_b64 s[86:87], vcc
		v_cmp_ge_i32_e64 vcc, v12, v140
		s_mov_b64 s[88:89], vcc
		v_cmp_ge_i32_e64 vcc, v12, v143
		s_mov_b64 s[90:91], vcc
		v_cmp_ge_i32_e64 vcc, v12, v144
		v_add_u32_e32 v141, s46, v98
		v_add_u32_e32 v142, s46, v99
		v_accvgpr_read_b32 v143, a167
		v_cndmask_b32_e32 v143, v36, v143, vcc
		v_accvgpr_write_b32 a81, v143
		v_cmp_ge_i32_e64 vcc, v12, v141
		s_mov_b64 s[92:93], vcc
		v_cmp_ge_i32_e64 vcc, v12, v142
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v172, s94
		v_mov_b32_e32 v173, s95
		v_accvgpr_write_b32 a82, v172
		v_accvgpr_write_b32 a83, v173
		v_cmp_ge_i32_e64 vcc, v12, v145
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v144, s94
		v_mov_b32_e32 v145, s95
		v_cmp_ge_i32_e64 vcc, v12, v146
		v_add_u32_e32 v143, s46, v102
		v_add_u32_e32 v146, s46, v103
		v_accvgpr_read_b32 v165, a171
		v_cndmask_b32_e32 v173, v36, v165, vcc
		v_cmp_ge_i32_e64 vcc, v12, v143
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v174, s94
		v_mov_b32_e32 v175, s95
		v_cmp_ge_i32_e64 vcc, v12, v146
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v176, s94
		v_mov_b32_e32 v177, s95
		v_cmp_ge_i32_e64 vcc, v12, v147
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v178, s94
		v_mov_b32_e32 v179, s95
		v_cmp_ge_i32_e64 vcc, v12, v148
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v180, s94
		v_mov_b32_e32 v181, s95
		v_add_u32_e32 v147, s46, v106
		v_add_u32_e32 v148, s46, v107
		v_accvgpr_read_b32 v165, a175
		v_cndmask_b32_e32 v181, v36, v165, vcc
		v_cmp_ge_i32_e64 vcc, v12, v147
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v182, s94
		v_mov_b32_e32 v183, s95
		v_cmp_ge_i32_e64 vcc, v12, v148
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v184, s94
		v_mov_b32_e32 v185, s95
		v_cmp_ge_i32_e64 vcc, v12, v149
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v186, s94
		v_mov_b32_e32 v187, s95
		v_cmp_ge_i32_e64 vcc, v12, v150
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v188, s94
		v_mov_b32_e32 v189, s95
		v_add_u32_e32 v149, s46, v110
		v_add_u32_e32 v150, s46, v111
		v_accvgpr_read_b32 v165, a179
		v_cndmask_b32_e32 v189, v36, v165, vcc
		v_cmp_ge_i32_e64 vcc, v12, v149
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v190, s94
		v_mov_b32_e32 v191, s95
		v_cmp_ge_i32_e64 vcc, v12, v150
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v192, s94
		v_mov_b32_e32 v193, s95
		v_cmp_ge_i32_e64 vcc, v12, v151
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v194, s94
		v_mov_b32_e32 v195, s95
		v_cmp_ge_i32_e64 vcc, v12, v152
		v_add_u32_e32 v151, s46, v114
		v_add_u32_e32 v152, s46, v115
		v_accvgpr_read_b32 v165, a183
		v_cndmask_b32_e32 v201, v36, v165, vcc
		v_cmp_ge_i32_e64 vcc, v12, v151
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v202, s94
		v_mov_b32_e32 v203, s95
		v_cmp_ge_i32_e64 vcc, v12, v152
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v204, s94
		v_mov_b32_e32 v205, s95
		v_cmp_ge_i32_e64 vcc, v12, v153
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v206, s94
		v_mov_b32_e32 v207, s95
		v_cmp_ge_i32_e64 vcc, v12, v154
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v224, s94
		v_mov_b32_e32 v225, s95
		v_add_u32_e32 v153, s46, v118
		v_add_u32_e32 v154, s46, v119
		v_accvgpr_read_b32 v165, a187
		v_cndmask_b32_e32 v225, v36, v165, vcc
		v_cmp_ge_i32_e64 vcc, v12, v153
		s_mov_b64 s[94:95], vcc
		v_cmp_ge_i32_e64 vcc, v12, v154
		s_mov_b64 s[96:97], vcc
		v_cmp_ge_i32_e64 vcc, v12, v155
		s_mov_b64 s[98:99], vcc
		v_accvgpr_read_b32 v155, a189
		v_mov_b32_e32 v165, 0xff800000
		v_cndmask_b32_e64 v227, v165, v155, s[96:97]
		v_accvgpr_read_b32 v155, a190
		v_cndmask_b32_e64 v228, v165, v155, s[98:99]
		v_cmp_ge_i32_e64 vcc, v12, v156
		v_add_u32_e32 v155, s46, v122
		v_add_u32_e32 v188, s46, v123
		v_accvgpr_read_b32 v166, a191
		v_cndmask_b32_e32 v229, v165, v166, vcc
		v_cmp_ge_i32_e64 vcc, v12, v155
		s_mov_b64 s[96:97], vcc
		v_cmp_ge_i32_e64 vcc, v12, v188
		s_mov_b64 s[98:99], vcc
		v_cmp_ge_i32_e64 vcc, v12, v157
		s_mov_b64 s[100:101], vcc
		v_accvgpr_read_b32 v166, a192
		v_cndmask_b32_e64 v230, v165, v166, s[96:97]
		v_accvgpr_read_b32 v166, a193
		v_cndmask_b32_e64 v231, v165, v166, s[98:99]
		v_accvgpr_read_b32 v166, a194
		v_cndmask_b32_e64 v232, v165, v166, s[100:101]
		v_cmp_ge_i32_e64 vcc, v12, v158
		v_add_u32_e32 v200, s46, v126
		v_add_u32_e32 v224, s46, v127
		v_accvgpr_read_b32 v166, a195
		v_cndmask_b32_e32 v233, v165, v166, vcc
		v_cmp_ge_i32_e64 vcc, v12, v200
		s_mov_b64 s[96:97], vcc
		v_cmp_ge_i32_e64 vcc, v12, v224
		s_mov_b64 s[98:99], vcc
		v_cmp_ge_i32_e64 vcc, v12, v159
		s_mov_b64 s[100:101], vcc
		v_accvgpr_read_b32 v166, a196
		v_cndmask_b32_e64 v234, v165, v166, s[96:97]
		v_accvgpr_read_b32 v166, a197
		v_cndmask_b32_e64 v235, v165, v166, s[98:99]
		v_accvgpr_read_b32 v166, a198
		v_cndmask_b32_e64 v236, v165, v166, s[100:101]
		v_cmp_ge_i32_e64 vcc, v12, v160
		v_add_u32_e32 v226, s46, v130
		v_add_u32_e32 v238, s46, v131
		v_accvgpr_read_b32 v166, a199
		v_cndmask_b32_e32 v237, v165, v166, vcc
		v_cmp_ge_i32_e64 vcc, v12, v226
		s_mov_b64 s[96:97], vcc
		v_cmp_ge_i32_e64 vcc, v12, v238
		s_mov_b64 s[98:99], vcc
		v_cmp_ge_i32_e64 vcc, v12, v161
		s_mov_b64 s[100:101], vcc
		v_accvgpr_read_b32 v166, a200
		v_cndmask_b32_e64 v240, v165, v166, s[96:97]
		v_accvgpr_read_b32 v166, a201
		v_cndmask_b32_e64 v241, v165, v166, s[98:99]
		v_accvgpr_read_b32 v166, a202
		v_cndmask_b32_e64 v242, v165, v166, s[100:101]
		v_cmp_ge_i32_e64 vcc, v12, v162
		v_add_u32_e32 v239, s46, v134
		v_add_u32_e32 v244, s46, v135
		v_accvgpr_read_b32 v166, a203
		v_cndmask_b32_e32 v243, v165, v166, vcc
		v_cmp_ge_i32_e64 vcc, v12, v239
		s_mov_b64 s[96:97], vcc
		v_cmp_ge_i32_e64 vcc, v12, v244
		s_mov_b64 s[98:99], vcc
		v_cmp_ge_i32_e64 vcc, v12, v163
		s_mov_b64 s[100:101], vcc
		v_accvgpr_read_b32 v166, a204
		v_cndmask_b32_e64 v246, v165, v166, s[96:97]
		v_accvgpr_read_b32 v166, a205
		v_cndmask_b32_e64 v247, v165, v166, s[98:99]
		v_accvgpr_read_b32 v166, a206
		v_cndmask_b32_e64 v248, v165, v166, s[100:101]
		v_cmp_ge_i32_e64 vcc, v12, v164
		v_accvgpr_read_b32 v166, a144
		v_cndmask_b32_e64 v250, v165, v166, s[54:55]
		v_accvgpr_read_b32 v166, a145
		v_cndmask_b32_e64 v251, v165, v166, s[58:59]
		v_accvgpr_read_b32 v166, a207
		v_cndmask_b32_e32 v249, v165, v166, vcc
		v_lshrrev_b32_e32 v166, 5, v0
		v_and_b32_e32 v166, 1, v166
		v_mov_b32_e32 v168, 4
		v_mul_lo_u32 v168, v168, v166
		v_add_u32_e32 v166, s46, v168
		v_cmp_ge_i32_e64 vcc, v8, v166
		s_mov_b64 s[54:55], vcc
		v_lshrrev_b32_e32 v166, 5, v0
		v_and_b32_e32 v166, 1, v166
		v_mov_b32_e32 v168, 4
		v_mul_lo_u32 v168, v168, v166
		v_xor_b32_e32 v166, 1, v168
		v_add_u32_e32 v166, s46, v166
		v_cmp_ge_i32_e64 vcc, v8, v166
		s_mov_b64 s[58:59], vcc
		v_lshrrev_b32_e32 v166, 5, v0
		v_and_b32_e32 v166, 1, v166
		v_mov_b32_e32 v168, 4
		v_mul_lo_u32 v168, v168, v166
		v_xor_b32_e32 v166, 2, v168
		v_add_u32_e32 v166, s46, v166
		v_cmp_ge_i32_e64 vcc, v8, v166
		s_mov_b64 s[96:97], vcc
		v_accvgpr_read_b32 v166, a224
		v_cndmask_b32_e64 v166, v165, v166, s[54:55]
		v_accvgpr_write_b32 a144, v166
		v_accvgpr_read_b32 v166, a225
		v_cndmask_b32_e64 v166, v165, v166, s[58:59]
		v_accvgpr_write_b32 a145, v166
		v_accvgpr_read_b32 v166, a226
		v_cndmask_b32_e64 v166, v165, v166, s[96:97]
		v_accvgpr_write_b32 a190, v166
		v_lshrrev_b32_e32 v166, 5, v0
		v_and_b32_e32 v166, 1, v166
		v_mov_b32_e32 v168, 4
		v_mul_lo_u32 v168, v168, v166
		v_xor_b32_e32 v166, 3, v168
		v_add_u32_e32 v166, s46, v166
		v_cmp_ge_i32_e64 vcc, v8, v166
		v_accvgpr_read_b32 v166, a146
		v_cndmask_b32_e64 v166, v165, v166, s[60:61]
		v_accvgpr_read_b32 v168, a148
		v_cndmask_b32_e64 v168, v165, v168, s[62:63]
		v_accvgpr_write_b32 a146, v168
		v_accvgpr_read_b32 v168, a227
		v_cndmask_b32_e32 v168, v165, v168, vcc
		v_accvgpr_write_b32 a191, v168
		v_cmp_ge_i32_e64 vcc, v8, v37
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v8, v38
		s_mov_b64 s[58:59], vcc
		v_lshrrev_b32_e32 v37, 5, v0
		v_and_b32_e32 v37, 1, v37
		v_mov_b32_e32 v38, 4
		v_mul_lo_u32 v38, v38, v37
		v_xor_b32_e32 v37, 10, v38
		v_add_u32_e32 v37, s46, v37
		v_cmp_ge_i32_e64 vcc, v8, v37
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v37, a228
		v_cndmask_b32_e64 v37, v165, v37, s[54:55]
		v_accvgpr_write_b32 a192, v37
		v_accvgpr_read_b32 v37, a229
		v_cndmask_b32_e64 v37, v165, v37, s[58:59]
		v_accvgpr_write_b32 a193, v37
		v_accvgpr_read_b32 v37, a230
		v_cndmask_b32_e64 v37, v165, v37, s[60:61]
		v_accvgpr_write_b32 a194, v37
		v_lshrrev_b32_e32 v37, 5, v0
		v_and_b32_e32 v37, 1, v37
		v_mov_b32_e32 v38, 4
		v_mul_lo_u32 v38, v38, v37
		v_xor_b32_e32 v37, 11, v38
		v_add_u32_e32 v37, s46, v37
		v_cmp_ge_i32_e64 vcc, v8, v37
		v_accvgpr_read_b32 v37, a149
		v_cndmask_b32_e64 v37, v165, v37, s[64:65]
		v_accvgpr_write_b32 a147, v37
		v_accvgpr_read_b32 v37, a150
		v_cndmask_b32_e64 v168, v165, v37, s[66:67]
		v_accvgpr_read_b32 v37, a231
		v_cndmask_b32_e32 v37, v165, v37, vcc
		v_accvgpr_write_b32 a195, v37
		v_cmp_ge_i32_e64 vcc, v8, v39
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v8, v40
		s_mov_b64 s[58:59], vcc
		v_lshrrev_b32_e32 v37, 5, v0
		v_and_b32_e32 v37, 1, v37
		v_mov_b32_e32 v38, 4
		v_mul_lo_u32 v38, v38, v37
		v_xor_b32_e32 v37, 18, v38
		v_add_u32_e32 v37, s46, v37
		v_cmp_ge_i32_e64 vcc, v8, v37
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v37, a232
		v_cndmask_b32_e64 v37, v165, v37, s[54:55]
		v_accvgpr_write_b32 a148, v37
		v_accvgpr_read_b32 v37, a233
		v_cndmask_b32_e64 v37, v165, v37, s[58:59]
		v_accvgpr_write_b32 a149, v37
		v_accvgpr_read_b32 v37, a234
		v_cndmask_b32_e64 v37, v165, v37, s[60:61]
		v_accvgpr_write_b32 a150, v37
		v_lshrrev_b32_e32 v37, 5, v0
		v_and_b32_e32 v37, 1, v37
		v_mov_b32_e32 v38, 4
		v_mul_lo_u32 v38, v38, v37
		v_xor_b32_e32 v37, 19, v38
		v_add_u32_e32 v37, s46, v37
		v_cmp_ge_i32_e64 vcc, v8, v37
		v_accvgpr_read_b32 v37, a152
		v_cndmask_b32_e64 v38, v165, v37, s[68:69]
		v_accvgpr_read_b32 v37, a153
		v_cndmask_b32_e64 v39, v165, v37, s[70:71]
		v_accvgpr_read_b32 v37, a235
		v_cndmask_b32_e32 v37, v165, v37, vcc
		v_accvgpr_write_b32 a151, v37
		v_cmp_ge_i32_e64 vcc, v8, v41
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v8, v42
		s_mov_b64 s[58:59], vcc
		v_lshrrev_b32_e32 v37, 5, v0
		v_and_b32_e32 v37, 1, v37
		v_mov_b32_e32 v40, 4
		v_mul_lo_u32 v40, v40, v37
		v_xor_b32_e32 v37, 26, v40
		v_add_u32_e32 v37, s46, v37
		v_cmp_ge_i32_e64 vcc, v8, v37
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v37, a236
		v_cndmask_b32_e64 v37, v165, v37, s[54:55]
		v_accvgpr_write_b32 a152, v37
		v_accvgpr_read_b32 v37, a237
		v_cndmask_b32_e64 v37, v165, v37, s[58:59]
		v_accvgpr_write_b32 a153, v37
		v_accvgpr_read_b32 v37, a238
		v_cndmask_b32_e64 v40, v165, v37, s[60:61]
		v_lshrrev_b32_e32 v37, 5, v0
		v_and_b32_e32 v37, 1, v37
		v_mov_b32_e32 v41, 4
		v_mul_lo_u32 v41, v41, v37
		v_xor_b32_e32 v37, 27, v41
		v_add_u32_e32 v37, s46, v37
		v_cmp_ge_i32_e64 vcc, v8, v37
		v_accvgpr_read_b32 v37, a154
		v_cndmask_b32_e64 v170, v165, v37, s[72:73]
		v_accvgpr_read_b32 v37, a156
		v_cndmask_b32_e64 v252, v165, v37, s[74:75]
		v_accvgpr_read_b32 v37, a239
		v_cndmask_b32_e32 v41, v165, v37, vcc
		v_cmp_ge_i32_e64 vcc, v8, v44
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v8, v138
		s_mov_b64 s[58:59], vcc
		v_lshrrev_b32_e32 v37, 5, v0
		v_and_b32_e32 v37, 1, v37
		v_mov_b32_e32 v42, 4
		v_mul_lo_u32 v42, v42, v37
		v_xor_b32_e32 v37, 34, v42
		v_add_u32_e32 v37, s46, v37
		v_cmp_ge_i32_e64 vcc, v8, v37
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v37, a240
		v_cndmask_b32_e64 v37, v165, v37, s[54:55]
		v_accvgpr_write_b32 a154, v37
		v_accvgpr_read_b32 v37, a241
		v_cndmask_b32_e64 v37, v165, v37, s[58:59]
		v_accvgpr_write_b32 a155, v37
		v_accvgpr_read_b32 v37, a242
		v_cndmask_b32_e64 v37, v165, v37, s[60:61]
		v_accvgpr_write_b32 a196, v37
		v_lshrrev_b32_e32 v37, 5, v0
		v_and_b32_e32 v37, 1, v37
		v_mov_b32_e32 v42, 4
		v_mul_lo_u32 v42, v42, v37
		v_xor_b32_e32 v37, 35, v42
		v_add_u32_e32 v37, s46, v37
		v_cmp_ge_i32_e64 vcc, v8, v37
		v_accvgpr_read_b32 v37, a157
		v_cndmask_b32_e64 v253, v165, v37, s[76:77]
		v_accvgpr_read_b32 v37, a158
		v_cndmask_b32_e64 v37, v165, v37, s[78:79]
		v_accvgpr_write_b32 a44, v37
		v_accvgpr_read_b32 v37, a243
		v_cndmask_b32_e32 v37, v165, v37, vcc
		v_accvgpr_write_b32 a197, v37
		v_cmp_ge_i32_e64 vcc, v8, v139
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v8, v140
		s_mov_b64 s[58:59], vcc
		v_lshrrev_b32_e32 v37, 5, v0
		v_and_b32_e32 v37, 1, v37
		v_mov_b32_e32 v42, 4
		v_mul_lo_u32 v42, v42, v37
		v_xor_b32_e32 v37, 42, v42
		v_add_u32_e32 v37, s46, v37
		v_cmp_ge_i32_e64 vcc, v8, v37
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v37, a244
		v_cndmask_b32_e64 v37, v165, v37, s[54:55]
		v_accvgpr_write_b32 a156, v37
		v_accvgpr_read_b32 v37, a245
		v_cndmask_b32_e64 v37, v165, v37, s[58:59]
		v_accvgpr_write_b32 a157, v37
		v_accvgpr_read_b32 v37, a246
		v_cndmask_b32_e64 v37, v165, v37, s[60:61]
		v_accvgpr_write_b32 a158, v37
		v_lshrrev_b32_e32 v37, 5, v0
		v_and_b32_e32 v37, 1, v37
		v_mov_b32_e32 v42, 4
		v_mul_lo_u32 v42, v42, v37
		v_xor_b32_e32 v37, 43, v42
		v_add_u32_e32 v37, s46, v37
		v_cmp_ge_i32_e64 vcc, v8, v37
		v_accvgpr_read_b32 v37, a160
		v_cndmask_b32_e64 v37, v165, v37, s[80:81]
		v_accvgpr_write_b32 a198, v37
		v_accvgpr_read_b32 v37, a161
		v_cndmask_b32_e64 v37, v165, v37, s[82:83]
		v_accvgpr_write_b32 a199, v37
		v_accvgpr_read_b32 v37, a247
		v_cndmask_b32_e32 v37, v165, v37, vcc
		v_accvgpr_write_b32 a159, v37
		v_cmp_ge_i32_e64 vcc, v8, v141
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v8, v142
		s_mov_b64 s[58:59], vcc
		v_lshrrev_b32_e32 v37, 5, v0
		v_and_b32_e32 v37, 1, v37
		v_mov_b32_e32 v42, 4
		v_mul_lo_u32 v42, v42, v37
		v_xor_b32_e32 v37, 50, v42
		v_add_u32_e32 v37, s46, v37
		v_cmp_ge_i32_e64 vcc, v8, v37
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v37, a248
		v_cndmask_b32_e64 v37, v165, v37, s[54:55]
		v_accvgpr_write_b32 a160, v37
		v_accvgpr_read_b32 v37, a249
		v_cndmask_b32_e64 v37, v165, v37, s[58:59]
		v_accvgpr_write_b32 a161, v37
		v_accvgpr_read_b32 v37, a250
		v_cndmask_b32_e64 v138, v165, v37, s[60:61]
		v_lshrrev_b32_e32 v37, 5, v0
		v_and_b32_e32 v37, 1, v37
		v_mov_b32_e32 v42, 4
		v_mul_lo_u32 v42, v42, v37
		v_xor_b32_e32 v37, 51, v42
		v_add_u32_e32 v37, s46, v37
		v_cmp_ge_i32_e64 vcc, v8, v37
		v_accvgpr_read_b32 v37, a162
		v_cndmask_b32_e64 v37, v165, v37, s[84:85]
		v_accvgpr_write_b32 a46, v37
		v_accvgpr_read_b32 v37, a164
		v_cndmask_b32_e64 v140, v165, v37, s[86:87]
		v_accvgpr_read_b32 v37, a251
		v_cndmask_b32_e32 v139, v165, v37, vcc
		v_cmp_ge_i32_e64 vcc, v8, v143
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v8, v146
		s_mov_b64 s[58:59], vcc
		v_lshrrev_b32_e32 v37, 5, v0
		v_and_b32_e32 v37, 1, v37
		v_mov_b32_e32 v42, 4
		v_mul_lo_u32 v42, v42, v37
		v_xor_b32_e32 v37, 58, v42
		v_add_u32_e32 v37, s46, v37
		v_cmp_ge_i32_e64 vcc, v8, v37
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v37, a252
		v_cndmask_b32_e64 v37, v165, v37, s[54:55]
		v_accvgpr_write_b32 a162, v37
		v_accvgpr_read_b32 v37, a253
		v_cndmask_b32_e64 v37, v165, v37, s[58:59]
		v_accvgpr_write_b32 a163, v37
		v_accvgpr_read_b32 v37, a254
		v_cndmask_b32_e64 v142, v165, v37, s[60:61]
		v_lshrrev_b32_e32 v37, 5, v0
		v_and_b32_e32 v37, 1, v37
		v_mov_b32_e32 v42, 4
		v_mul_lo_u32 v42, v42, v37
		v_xor_b32_e32 v37, 59, v42
		v_add_u32_e32 v37, s46, v37
		v_cmp_ge_i32_e64 vcc, v8, v37
		v_accvgpr_read_b32 v37, a165
		v_cndmask_b32_e64 v141, v165, v37, s[88:89]
		v_accvgpr_read_b32 v37, a166
		v_cndmask_b32_e64 v37, v165, v37, s[90:91]
		v_accvgpr_write_b32 a80, v37
		v_accvgpr_read_b32 v37, a255
		v_cndmask_b32_e32 v143, v165, v37, vcc
		v_cmp_ge_i32_e64 vcc, v8, v147
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v8, v148
		s_mov_b64 s[58:59], vcc
		v_lshrrev_b32_e32 v37, 5, v0
		v_and_b32_e32 v37, 1, v37
		v_mov_b32_e32 v42, 4
		v_mul_lo_u32 v42, v42, v37
		v_xor_b32_e32 v37, 0x42, v42
		v_add_u32_e32 v37, s46, v37
		v_cmp_ge_i32_e64 vcc, v8, v37
		s_mov_b64 s[60:61], vcc
		v_cndmask_b32_e64 v37, v165, v208, s[54:55]
		v_accvgpr_write_b32 a164, v37
		v_cndmask_b32_e64 v37, v165, v209, s[58:59]
		v_accvgpr_write_b32 a165, v37
		v_cndmask_b32_e64 v146, v165, v210, s[60:61]
		v_lshrrev_b32_e32 v37, 5, v0
		v_and_b32_e32 v37, 1, v37
		v_mov_b32_e32 v42, 4
		v_mul_lo_u32 v42, v42, v37
		v_xor_b32_e32 v37, 0x43, v42
		v_add_u32_e32 v37, s46, v37
		v_cmp_ge_i32_e64 vcc, v8, v37
		v_accvgpr_read_b32 v37, a168
		v_mov_b32_e32 v208, s92
		v_mov_b32_e32 v209, s93
		s_nop 0
		v_readfirstlane_b32 s54, v208
		v_readfirstlane_b32 s55, v209
		s_nop 1
		v_cndmask_b32_e64 v208, v165, v37, s[54:55]
		v_accvgpr_read_b32 v37, a169
		v_accvgpr_read_b32 v42, a82
		s_nop 0
		v_readfirstlane_b32 s54, v42
		v_accvgpr_read_b32 v42, a83
		s_nop 0
		v_readfirstlane_b32 s55, v42
		s_nop 1
		v_cndmask_b32_e64 v209, v165, v37, s[54:55]
		v_cndmask_b32_e32 v147, v165, v211, vcc
		v_cmp_ge_i32_e64 vcc, v8, v149
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v8, v150
		s_mov_b64 s[58:59], vcc
		v_lshrrev_b32_e32 v37, 5, v0
		v_and_b32_e32 v37, 1, v37
		v_mov_b32_e32 v42, 4
		v_mul_lo_u32 v42, v42, v37
		v_xor_b32_e32 v37, 0x4a, v42
		v_add_u32_e32 v37, s46, v37
		v_cmp_ge_i32_e64 vcc, v8, v37
		s_mov_b64 s[60:61], vcc
		v_cndmask_b32_e64 v148, v165, v212, s[54:55]
		v_cndmask_b32_e64 v149, v165, v213, s[58:59]
		v_cndmask_b32_e64 v210, v165, v214, s[60:61]
		v_lshrrev_b32_e32 v37, 5, v0
		v_and_b32_e32 v37, 1, v37
		v_mov_b32_e32 v42, 4
		v_mul_lo_u32 v42, v42, v37
		v_xor_b32_e32 v37, 0x4b, v42
		v_add_u32_e32 v37, s46, v37
		v_cmp_ge_i32_e64 vcc, v8, v37
		v_accvgpr_read_b32 v37, a170
		v_readfirstlane_b32 s54, v144
		v_readfirstlane_b32 s55, v145
		s_nop 1
		v_cndmask_b32_e64 v172, v165, v37, s[54:55]
		v_accvgpr_read_b32 v37, a172
		v_readfirstlane_b32 s54, v174
		v_readfirstlane_b32 s55, v175
		s_nop 1
		v_cndmask_b32_e64 v144, v165, v37, s[54:55]
		v_cndmask_b32_e32 v211, v165, v215, vcc
		v_cmp_ge_i32_e64 vcc, v8, v151
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v8, v152
		s_mov_b64 s[58:59], vcc
		v_lshrrev_b32_e32 v37, 5, v0
		v_and_b32_e32 v37, 1, v37
		v_mov_b32_e32 v42, 4
		v_mul_lo_u32 v42, v42, v37
		v_xor_b32_e32 v37, 0x52, v42
		v_add_u32_e32 v37, s46, v37
		v_cmp_ge_i32_e64 vcc, v8, v37
		s_mov_b64 s[60:61], vcc
		v_cndmask_b32_e64 v150, v165, v216, s[54:55]
		v_cndmask_b32_e64 v151, v165, v217, s[58:59]
		v_cndmask_b32_e64 v174, v165, v218, s[60:61]
		v_lshrrev_b32_e32 v37, 5, v0
		v_and_b32_e32 v37, 1, v37
		v_mov_b32_e32 v42, 4
		v_mul_lo_u32 v42, v42, v37
		v_xor_b32_e32 v37, 0x53, v42
		v_add_u32_e32 v37, s46, v37
		v_cmp_ge_i32_e64 vcc, v8, v37
		v_accvgpr_read_b32 v37, a173
		v_readfirstlane_b32 s54, v176
		v_readfirstlane_b32 s55, v177
		s_nop 1
		v_cndmask_b32_e64 v145, v165, v37, s[54:55]
		v_accvgpr_read_b32 v37, a174
		v_readfirstlane_b32 s54, v178
		v_readfirstlane_b32 s55, v179
		s_nop 1
		v_cndmask_b32_e64 v180, v165, v37, s[54:55]
		v_cndmask_b32_e32 v175, v165, v219, vcc
		v_cmp_ge_i32_e64 vcc, v8, v153
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v8, v154
		s_mov_b64 s[58:59], vcc
		v_lshrrev_b32_e32 v37, 5, v0
		v_and_b32_e32 v37, 1, v37
		v_mov_b32_e32 v42, 4
		v_mul_lo_u32 v42, v42, v37
		v_xor_b32_e32 v37, 0x5a, v42
		v_add_u32_e32 v37, s46, v37
		v_cmp_ge_i32_e64 vcc, v8, v37
		s_mov_b64 s[60:61], vcc
		v_cndmask_b32_e64 v152, v165, v220, s[54:55]
		v_cndmask_b32_e64 v153, v165, v221, s[58:59]
		v_cndmask_b32_e64 v176, v165, v222, s[60:61]
		v_cmp_ge_i32_e64 vcc, v8, v156
		v_accvgpr_read_b32 v37, a176
		v_readfirstlane_b32 s54, v182
		v_readfirstlane_b32 s55, v183
		s_nop 1
		v_cndmask_b32_e64 v178, v165, v37, s[54:55]
		v_accvgpr_read_b32 v37, a177
		v_readfirstlane_b32 s54, v184
		v_readfirstlane_b32 s55, v185
		s_nop 1
		v_cndmask_b32_e64 v179, v165, v37, s[54:55]
		v_cndmask_b32_e32 v177, v165, v223, vcc
		v_cmp_ge_i32_e64 vcc, v8, v155
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v8, v188
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v8, v157
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v37, a208
		v_cndmask_b32_e64 v154, v165, v37, s[54:55]
		v_accvgpr_read_b32 v37, a209
		v_cndmask_b32_e64 v155, v165, v37, s[58:59]
		v_accvgpr_read_b32 v37, a210
		v_cndmask_b32_e64 v156, v165, v37, s[60:61]
		v_cmp_ge_i32_e64 vcc, v8, v158
		v_accvgpr_read_b32 v37, a178
		v_readfirstlane_b32 s54, v186
		v_readfirstlane_b32 s55, v187
		s_nop 1
		v_cndmask_b32_e64 v188, v165, v37, s[54:55]
		v_accvgpr_read_b32 v37, a180
		v_readfirstlane_b32 s54, v190
		v_readfirstlane_b32 s55, v191
		s_nop 1
		v_cndmask_b32_e64 v182, v165, v37, s[54:55]
		v_accvgpr_read_b32 v37, a211
		v_cndmask_b32_e32 v157, v165, v37, vcc
		v_cmp_ge_i32_e64 vcc, v8, v200
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v8, v224
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v8, v159
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v37, a212
		v_cndmask_b32_e64 v158, v165, v37, s[54:55]
		v_accvgpr_read_b32 v37, a213
		v_cndmask_b32_e64 v159, v165, v37, s[58:59]
		v_accvgpr_read_b32 v37, a214
		v_cndmask_b32_e64 v184, v165, v37, s[60:61]
		v_cmp_ge_i32_e64 vcc, v8, v160
		v_accvgpr_read_b32 v37, a181
		v_readfirstlane_b32 s54, v192
		v_readfirstlane_b32 s55, v193
		s_nop 1
		v_cndmask_b32_e64 v183, v165, v37, s[54:55]
		v_accvgpr_read_b32 v37, a182
		v_readfirstlane_b32 s54, v194
		v_readfirstlane_b32 s55, v195
		s_nop 1
		v_cndmask_b32_e64 v200, v165, v37, s[54:55]
		v_accvgpr_read_b32 v37, a215
		v_cndmask_b32_e32 v185, v165, v37, vcc
		v_cmp_ge_i32_e64 vcc, v8, v226
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v8, v238
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v8, v161
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v37, a216
		v_cndmask_b32_e64 v160, v165, v37, s[54:55]
		v_accvgpr_read_b32 v37, a217
		v_cndmask_b32_e64 v161, v165, v37, s[58:59]
		v_accvgpr_read_b32 v37, a218
		v_cndmask_b32_e64 v186, v165, v37, s[60:61]
		v_cmp_ge_i32_e64 vcc, v8, v162
		v_accvgpr_read_b32 v37, a184
		v_readfirstlane_b32 s54, v202
		v_readfirstlane_b32 s55, v203
		s_nop 1
		v_cndmask_b32_e64 v190, v165, v37, s[54:55]
		v_accvgpr_read_b32 v37, a185
		v_readfirstlane_b32 s54, v204
		v_readfirstlane_b32 s55, v205
		s_nop 1
		v_cndmask_b32_e64 v191, v165, v37, s[54:55]
		v_accvgpr_read_b32 v37, a219
		v_cndmask_b32_e32 v187, v165, v37, vcc
		v_cmp_ge_i32_e64 vcc, v8, v239
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v8, v244
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v8, v163
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v37, a220
		v_cndmask_b32_e64 v162, v165, v37, s[54:55]
		v_accvgpr_read_b32 v37, a221
		v_cndmask_b32_e64 v163, v165, v37, s[58:59]
		v_accvgpr_read_b32 v37, a222
		v_cndmask_b32_e64 v192, v165, v37, s[60:61]
		v_cmp_ge_i32_e64 vcc, v8, v164
		v_accvgpr_read_b32 v37, a186
		v_readfirstlane_b32 s54, v206
		v_readfirstlane_b32 s55, v207
		s_nop 1
		v_cndmask_b32_e64 v224, v165, v37, s[54:55]
		v_accvgpr_read_b32 v37, a188
		v_mov_b32_e32 v194, s94
		v_mov_b32_e32 v195, s95
		s_nop 0
		v_readfirstlane_b32 s54, v194
		v_readfirstlane_b32 s55, v195
		s_nop 1
		v_cndmask_b32_e64 v226, v165, v37, s[54:55]
		v_accvgpr_read_b32 v37, a223
		v_cndmask_b32_e32 v193, v165, v37, vcc
		v_max_f32_e32 v37, v250, v251
		v_max_f32_e32 v42, v166, v167
		v_accvgpr_read_b32 v44, a146
		v_accvgpr_read_b32 v164, a147
		v_max_f32_e32 v44, v44, v164
		v_max_f32_e32 v164, v168, v169
		v_max_f32_e32 v165, v38, v39
		v_max_f32_e32 v194, v170, v171
		v_max_f32_e32 v195, v252, v253
		v_accvgpr_read_b32 v202, a45
		v_accvgpr_read_b32 v203, a44
		v_max_f32_e32 v202, v203, v202
		v_accvgpr_read_b32 v203, a198
		v_accvgpr_read_b32 v204, a199
		v_max_f32_e32 v203, v203, v204
		v_accvgpr_read_b32 v204, a47
		v_accvgpr_read_b32 v205, a46
		v_max_f32_e32 v204, v205, v204
		v_max_f32_e32 v205, v140, v141
		v_accvgpr_read_b32 v206, a81
		v_accvgpr_read_b32 v207, a80
		v_max_f32_e32 v206, v207, v206
		v_max_f32_e32 v207, v208, v209
		v_max_f32_e32 v212, v172, v173
		v_max_f32_e32 v213, v144, v145
		v_max_f32_e32 v214, v180, v181
		v_max_f32_e32 v215, v178, v179
		v_max_f32_e32 v216, v188, v189
		v_max_f32_e32 v217, v182, v183
		v_max_f32_e32 v218, v200, v201
		v_max_f32_e32 v219, v190, v191
		v_max_f32_e32 v220, v224, v225
		v_max_f32_e32 v221, v226, v227
		v_max_f32_e32 v222, v228, v229
		v_max_f32_e32 v223, v230, v231
		v_max_f32_e32 v238, v232, v233
		v_max_f32_e32 v239, v234, v235
		v_accvgpr_write_b32 a82, v239
		v_max_f32_e32 v239, v236, v237
		v_max_f32_e32 v244, v240, v241
		v_accvgpr_write_b32 a83, v244
		v_max_f32_e32 v244, v242, v243
		v_accvgpr_write_b32 a166, v244
		v_max_f32_e32 v244, v246, v247
		v_accvgpr_write_b32 a167, v244
		v_max_f32_e32 v244, v248, v249
		v_max_f32_e32 v37, v37, v42
		v_max_f32_e32 v42, v44, v164
		v_max_f32_e32 v44, v165, v194
		v_max_f32_e32 v164, v195, v202
		v_max_f32_e32 v165, v203, v204
		v_max_f32_e32 v194, v205, v206
		v_max_f32_e32 v195, v207, v212
		v_max_f32_e32 v202, v213, v214
		v_max_f32_e32 v203, v215, v216
		v_max_f32_e32 v204, v217, v218
		v_max_f32_e32 v205, v219, v220
		v_max_f32_e32 v206, v221, v222
		v_max_f32_e32 v207, v223, v238
		v_accvgpr_read_b32 v212, a82
		v_max_f32_e32 v212, v212, v239
		v_accvgpr_read_b32 v213, a83
		v_accvgpr_read_b32 v214, a166
		v_max_f32_e32 v213, v213, v214
		v_accvgpr_read_b32 v214, a167
		v_max_f32_e32 v214, v214, v244
		v_max_f32_e32 v37, v37, v42
		v_max_f32_e32 v42, v44, v164
		v_max_f32_e32 v44, v165, v194
		v_max_f32_e32 v164, v195, v202
		v_max_f32_e32 v165, v203, v204
		v_max_f32_e32 v194, v205, v206
		v_max_f32_e32 v195, v207, v212
		v_max_f32_e32 v202, v213, v214
		v_max_f32_e32 v37, v37, v42
		v_max_f32_e32 v42, v44, v164
		v_max_f32_e32 v44, v165, v194
		v_max_f32_e32 v164, v195, v202
		v_max_f32_e32 v37, v37, v42
		v_max_f32_e32 v42, v44, v164
		v_max_f32_e32 v37, v37, v42
		ds_bpermute_b32 v42, v18, v37
		ds_bpermute_b32 v44, v13, v37
		v_accvgpr_read_b32 v37, a144
		v_accvgpr_read_b32 v164, a145
		v_max_f32_e32 v37, v37, v164
		v_accvgpr_read_b32 v164, a190
		v_accvgpr_read_b32 v165, a191
		v_max_f32_e32 v164, v164, v165
		v_accvgpr_read_b32 v165, a192
		v_accvgpr_read_b32 v194, a193
		v_max_f32_e32 v165, v165, v194
		v_accvgpr_read_b32 v194, a194
		v_accvgpr_read_b32 v195, a195
		v_max_f32_e32 v194, v194, v195
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v202, v42, v44
		v_accvgpr_read_b32 v42, a148
		v_accvgpr_read_b32 v44, a149
		v_max_f32_e32 v42, v42, v44
		v_accvgpr_read_b32 v44, a150
		v_accvgpr_read_b32 v195, a151
		v_max_f32_e32 v44, v44, v195
		v_accvgpr_read_b32 v195, a152
		v_accvgpr_read_b32 v203, a153
		v_max_f32_e32 v195, v195, v203
		v_max_f32_e32 v203, v40, v41
		v_accvgpr_read_b32 v204, a154
		v_accvgpr_read_b32 v205, a155
		v_max_f32_e32 v204, v204, v205
		v_accvgpr_read_b32 v205, a196
		v_accvgpr_read_b32 v206, a197
		v_max_f32_e32 v205, v205, v206
		v_accvgpr_read_b32 v206, a156
		v_accvgpr_read_b32 v207, a157
		v_max_f32_e32 v206, v206, v207
		v_accvgpr_read_b32 v207, a158
		v_accvgpr_read_b32 v212, a159
		v_max_f32_e32 v207, v207, v212
		v_accvgpr_read_b32 v212, a160
		v_accvgpr_read_b32 v213, a161
		v_max_f32_e32 v212, v212, v213
		v_max_f32_e32 v213, v138, v139
		v_accvgpr_read_b32 v214, a162
		v_accvgpr_read_b32 v215, a163
		v_max_f32_e32 v214, v214, v215
		v_max_f32_e32 v215, v142, v143
		v_accvgpr_read_b32 v216, a164
		v_accvgpr_read_b32 v217, a165
		v_max_f32_e32 v216, v216, v217
		v_max_f32_e32 v217, v146, v147
		v_max_f32_e32 v218, v148, v149
		v_max_f32_e32 v219, v210, v211
		v_max_f32_e32 v220, v150, v151
		v_max_f32_e32 v221, v174, v175
		v_max_f32_e32 v222, v152, v153
		v_max_f32_e32 v223, v176, v177
		v_max_f32_e32 v238, v154, v155
		v_max_f32_e32 v239, v156, v157
		v_max_f32_e32 v244, v158, v159
		v_accvgpr_write_b32 a82, v244
		v_max_f32_e32 v244, v184, v185
		v_accvgpr_write_b32 a83, v244
		v_max_f32_e32 v244, v160, v161
		v_accvgpr_write_b32 a166, v244
		v_max_f32_e32 v244, v186, v187
		v_accvgpr_write_b32 a167, v244
		v_max_f32_e32 v244, v162, v163
		v_accvgpr_write_b32 a168, v244
		v_max_f32_e32 v244, v192, v193
		v_max_f32_e32 v37, v37, v164
		v_max_f32_e32 v164, v165, v194
		v_max_f32_e32 v42, v42, v44
		v_max_f32_e32 v44, v195, v203
		v_max_f32_e32 v165, v204, v205
		v_max_f32_e32 v194, v206, v207
		v_max_f32_e32 v195, v212, v213
		v_max_f32_e32 v203, v214, v215
		v_max_f32_e32 v204, v216, v217
		v_max_f32_e32 v205, v218, v219
		v_max_f32_e32 v206, v220, v221
		v_max_f32_e32 v207, v222, v223
		v_max_f32_e32 v212, v238, v239
		v_accvgpr_read_b32 v213, a82
		v_accvgpr_read_b32 v214, a83
		v_max_f32_e32 v213, v213, v214
		v_accvgpr_read_b32 v214, a166
		v_accvgpr_read_b32 v215, a167
		v_max_f32_e32 v214, v214, v215
		v_accvgpr_read_b32 v215, a168
		v_max_f32_e32 v215, v215, v244
		v_max_f32_e32 v37, v37, v164
		v_max_f32_e32 v42, v42, v44
		v_max_f32_e32 v44, v165, v194
		v_max_f32_e32 v164, v195, v203
		v_max_f32_e32 v165, v204, v205
		v_max_f32_e32 v194, v206, v207
		v_max_f32_e32 v195, v212, v213
		v_max_f32_e32 v203, v214, v215
		v_max_f32_e32 v37, v37, v42
		v_max_f32_e32 v42, v44, v164
		v_max_f32_e32 v44, v165, v194
		v_max_f32_e32 v164, v195, v203
		v_max_f32_e32 v37, v37, v42
		v_max_f32_e32 v42, v44, v164
		v_max_f32_e32 v37, v37, v42
		ds_bpermute_b32 v42, v18, v37
		ds_bpermute_b32 v44, v13, v37
		v_pk_mul_f32 v[164:165], v[250:251], v[28:29]
		v_pk_mul_f32 v[194:195], v[166:167], v[28:29]
		v_accvgpr_read_b32 v166, a146
		v_accvgpr_read_b32 v167, a147
		v_pk_mul_f32 v[204:205], v[166:167], v[28:29]
		v_pk_mul_f32 v[166:167], v[168:169], v[28:29]
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v203, v42, v44
		v_pk_mul_f32 v[168:169], v[202:203], v[28:29]
		v_max_f32_e32 v37, v17, v168
		v_max_f32_e32 v42, v21, v169
		v_pk_mul_f32 v[168:169], v[38:39], v[28:29]
		v_pk_mul_f32 v[38:39], v[170:171], v[28:29]
		v_pk_mul_f32 v[170:171], v[252:253], v[28:29]
		v_accvgpr_read_b32 v202, a44
		v_accvgpr_read_b32 v203, a45
		v_pk_mul_f32 v[206:207], v[202:203], v[28:29]
		v_accvgpr_read_b32 v202, a198
		v_accvgpr_read_b32 v203, a199
		v_pk_mul_f32 v[212:213], v[202:203], v[28:29]
		v_accvgpr_read_b32 v202, a46
		v_accvgpr_read_b32 v203, a47
		v_pk_mul_f32 v[214:215], v[202:203], v[28:29]
		v_pk_mul_f32 v[202:203], v[140:141], v[28:29]
		v_accvgpr_read_b32 v140, a80
		v_accvgpr_read_b32 v141, a81
		v_pk_mul_f32 v[216:217], v[140:141], v[28:29]
		v_pk_mul_f32 v[140:141], v[208:209], v[28:29]
		v_pk_mul_f32 v[208:209], v[172:173], v[28:29]
		v_pk_mul_f32 v[172:173], v[144:145], v[28:29]
		v_pk_mul_f32 v[144:145], v[180:181], v[28:29]
		v_pk_mul_f32 v[180:181], v[178:179], v[28:29]
		v_pk_mul_f32 v[178:179], v[188:189], v[28:29]
		v_pk_mul_f32 v[188:189], v[182:183], v[28:29]
		v_pk_mul_f32 v[182:183], v[200:201], v[28:29]
		v_pk_mul_f32 v[200:201], v[190:191], v[28:29]
		v_pk_mul_f32 v[190:191], v[224:225], v[28:29]
		v_pk_mul_f32 v[218:219], v[226:227], v[28:29]
		v_pk_mul_f32 v[220:221], v[228:229], v[28:29]
		v_pk_mul_f32 v[222:223], v[230:231], v[28:29]
		v_pk_mul_f32 v[224:225], v[232:233], v[28:29]
		v_pk_mul_f32 v[226:227], v[234:235], v[28:29]
		v_pk_mul_f32 v[228:229], v[236:237], v[28:29]
		v_pk_mul_f32 v[230:231], v[240:241], v[28:29]
		v_pk_mul_f32 v[232:233], v[242:243], v[28:29]
		v_pk_mul_f32 v[234:235], v[246:247], v[28:29]
		v_pk_mul_f32 v[236:237], v[248:249], v[28:29]
		v_accvgpr_read_b32 v238, a144
		v_accvgpr_read_b32 v239, a145
		v_pk_mul_f32 v[240:241], v[238:239], v[28:29]
		v_accvgpr_read_b32 v238, a190
		v_accvgpr_read_b32 v239, a191
		v_pk_mul_f32 v[242:243], v[238:239], v[28:29]
		v_accvgpr_read_b32 v238, a192
		v_accvgpr_read_b32 v239, a193
		v_pk_mul_f32 v[244:245], v[238:239], v[28:29]
		v_accvgpr_read_b32 v238, a194
		v_accvgpr_read_b32 v239, a195
		v_pk_mul_f32 v[246:247], v[238:239], v[28:29]
		v_accvgpr_read_b32 v238, a148
		v_accvgpr_read_b32 v239, a149
		v_pk_mul_f32 v[248:249], v[238:239], v[28:29]
		v_accvgpr_read_b32 v238, a150
		v_accvgpr_read_b32 v239, a151
		v_pk_mul_f32 v[250:251], v[238:239], v[28:29]
		v_accvgpr_read_b32 v238, a152
		v_accvgpr_read_b32 v239, a153
		v_pk_mul_f32 v[252:253], v[238:239], v[28:29]
		v_pk_mul_f32 v[40:41], v[40:41], v[28:29]
		v_accvgpr_write_b32 a44, v40
		v_accvgpr_write_b32 a45, v41
		v_accvgpr_read_b32 v40, a154
		v_accvgpr_read_b32 v41, a155
		v_pk_mul_f32 v[40:41], v[40:41], v[28:29]
		v_accvgpr_write_b32 a46, v40
		v_accvgpr_write_b32 a47, v41
		v_accvgpr_read_b32 v40, a196
		v_accvgpr_read_b32 v41, a197
		v_pk_mul_f32 v[40:41], v[40:41], v[28:29]
		v_accvgpr_write_b32 a80, v40
		v_accvgpr_write_b32 a81, v41
		v_accvgpr_read_b32 v40, a156
		v_accvgpr_read_b32 v41, a157
		v_pk_mul_f32 v[40:41], v[40:41], v[28:29]
		v_accvgpr_write_b32 a82, v40
		v_accvgpr_write_b32 a83, v41
		v_accvgpr_read_b32 v40, a158
		v_accvgpr_read_b32 v41, a159
		v_pk_mul_f32 v[40:41], v[40:41], v[28:29]
		v_accvgpr_write_b32 a144, v40
		v_accvgpr_write_b32 a145, v41
		v_accvgpr_read_b32 v40, a160
		v_accvgpr_read_b32 v41, a161
		v_pk_mul_f32 v[238:239], v[40:41], v[28:29]
		v_pk_mul_f32 v[40:41], v[138:139], v[28:29]
		v_accvgpr_write_b32 a146, v40
		v_accvgpr_write_b32 a147, v41
		v_accvgpr_read_b32 v40, a162
		v_accvgpr_read_b32 v41, a163
		v_pk_mul_f32 v[138:139], v[40:41], v[28:29]
		v_pk_mul_f32 v[40:41], v[142:143], v[28:29]
		v_accvgpr_write_b32 a148, v40
		v_accvgpr_write_b32 a149, v41
		v_accvgpr_read_b32 v40, a164
		v_accvgpr_read_b32 v41, a165
		v_pk_mul_f32 v[142:143], v[40:41], v[28:29]
		v_pk_mul_f32 v[40:41], v[146:147], v[28:29]
		v_pk_mul_f32 v[146:147], v[148:149], v[28:29]
		v_pk_mul_f32 v[148:149], v[210:211], v[28:29]
		v_pk_mul_f32 v[210:211], v[150:151], v[28:29]
		v_pk_mul_f32 v[150:151], v[174:175], v[28:29]
		v_pk_mul_f32 v[174:175], v[152:153], v[28:29]
		v_pk_mul_f32 v[152:153], v[176:177], v[28:29]
		v_pk_mul_f32 v[176:177], v[154:155], v[28:29]
		v_pk_mul_f32 v[154:155], v[156:157], v[28:29]
		v_pk_mul_f32 v[156:157], v[158:159], v[28:29]
		v_pk_mul_f32 v[158:159], v[184:185], v[28:29]
		v_pk_mul_f32 v[184:185], v[160:161], v[28:29]
		v_pk_mul_f32 v[160:161], v[186:187], v[28:29]
		v_pk_mul_f32 v[186:187], v[162:163], v[28:29]
		v_pk_mul_f32 v[162:163], v[192:193], v[28:29]
		v_sub_f32_e32 v44, v164, v37
		v_sub_f32_e32 v164, v165, v37
		v_sub_f32_e32 v165, v194, v37
		v_sub_f32_e32 v192, v195, v37
		v_sub_f32_e32 v193, v204, v37
		v_sub_f32_e32 v194, v205, v37
		v_sub_f32_e32 v166, v166, v37
		v_sub_f32_e32 v167, v167, v37
		v_sub_f32_e32 v168, v168, v37
		v_sub_f32_e32 v169, v169, v37
		v_sub_f32_e32 v38, v38, v37
		v_sub_f32_e32 v39, v39, v37
		v_sub_f32_e32 v170, v170, v37
		v_sub_f32_e32 v171, v171, v37
		v_sub_f32_e32 v195, v206, v37
		v_sub_f32_e32 v204, v207, v37
		v_sub_f32_e32 v205, v212, v37
		v_sub_f32_e32 v206, v213, v37
		v_sub_f32_e32 v207, v214, v37
		v_sub_f32_e32 v212, v215, v37
		v_sub_f32_e32 v202, v202, v37
		v_sub_f32_e32 v203, v203, v37
		v_sub_f32_e32 v213, v216, v37
		v_sub_f32_e32 v214, v217, v37
		v_sub_f32_e32 v140, v140, v37
		v_sub_f32_e32 v141, v141, v37
		v_sub_f32_e32 v208, v208, v37
		v_sub_f32_e32 v209, v209, v37
		v_sub_f32_e32 v172, v172, v37
		v_sub_f32_e32 v173, v173, v37
		v_sub_f32_e32 v144, v144, v37
		v_sub_f32_e32 v145, v145, v37
		v_sub_f32_e32 v180, v180, v37
		v_sub_f32_e32 v181, v181, v37
		v_sub_f32_e32 v178, v178, v37
		v_sub_f32_e32 v179, v179, v37
		v_sub_f32_e32 v188, v188, v37
		v_sub_f32_e32 v189, v189, v37
		v_sub_f32_e32 v182, v182, v37
		v_sub_f32_e32 v183, v183, v37
		v_sub_f32_e32 v200, v200, v37
		v_sub_f32_e32 v201, v201, v37
		v_sub_f32_e32 v190, v190, v37
		v_sub_f32_e32 v191, v191, v37
		v_sub_f32_e32 v215, v218, v37
		v_sub_f32_e32 v216, v219, v37
		v_sub_f32_e32 v217, v220, v37
		v_sub_f32_e32 v218, v221, v37
		v_sub_f32_e32 v219, v222, v37
		v_sub_f32_e32 v220, v223, v37
		v_sub_f32_e32 v221, v224, v37
		v_sub_f32_e32 v222, v225, v37
		v_sub_f32_e32 v223, v226, v37
		v_sub_f32_e32 v224, v227, v37
		v_sub_f32_e32 v225, v228, v37
		v_sub_f32_e32 v226, v229, v37
		v_sub_f32_e32 v227, v230, v37
		v_sub_f32_e32 v228, v231, v37
		v_sub_f32_e32 v229, v232, v37
		v_sub_f32_e32 v230, v233, v37
		v_sub_f32_e32 v231, v234, v37
		v_sub_f32_e32 v232, v235, v37
		v_sub_f32_e32 v233, v236, v37
		v_sub_f32_e32 v234, v237, v37
		v_sub_f32_e32 v235, v240, v42
		v_sub_f32_e32 v236, v241, v42
		v_sub_f32_e32 v237, v242, v42
		v_sub_f32_e32 v240, v243, v42
		v_sub_f32_e32 v241, v244, v42
		v_sub_f32_e32 v242, v245, v42
		v_sub_f32_e32 v243, v246, v42
		v_sub_f32_e32 v244, v247, v42
		v_sub_f32_e32 v245, v248, v42
		v_sub_f32_e32 v246, v249, v42
		v_sub_f32_e32 v247, v250, v42
		v_sub_f32_e32 v248, v251, v42
		v_sub_f32_e32 v249, v252, v42
		v_sub_f32_e32 v250, v253, v42
		v_accvgpr_read_b32 v251, a44
		v_sub_f32_e32 v251, v251, v42
		v_accvgpr_read_b32 v252, a45
		v_sub_f32_e32 v252, v252, v42
		v_accvgpr_read_b32 v253, a46
		v_sub_f32_e32 v253, v253, v42
		v_accvgpr_write_b32 a44, v253
		v_accvgpr_read_b32 v253, a47
		v_sub_f32_e32 v253, v253, v42
		v_accvgpr_write_b32 a45, v253
		v_accvgpr_read_b32 v253, a80
		v_sub_f32_e32 v253, v253, v42
		v_accvgpr_write_b32 a46, v253
		v_accvgpr_read_b32 v253, a81
		v_sub_f32_e32 v253, v253, v42
		v_accvgpr_write_b32 a47, v253
		v_accvgpr_read_b32 v253, a82
		v_sub_f32_e32 v253, v253, v42
		v_accvgpr_write_b32 a80, v253
		v_accvgpr_read_b32 v253, a83
		v_sub_f32_e32 v253, v253, v42
		v_accvgpr_write_b32 a81, v253
		v_accvgpr_read_b32 v253, a144
		v_sub_f32_e32 v253, v253, v42
		v_accvgpr_write_b32 a82, v253
		v_accvgpr_read_b32 v253, a145
		v_sub_f32_e32 v253, v253, v42
		v_sub_f32_e32 v238, v238, v42
		v_sub_f32_e32 v239, v239, v42
		v_accvgpr_write_b32 a83, v239
		v_accvgpr_read_b32 v239, a146
		v_sub_f32_e32 v239, v239, v42
		v_accvgpr_write_b32 a144, v239
		v_accvgpr_read_b32 v239, a147
		v_sub_f32_e32 v239, v239, v42
		v_sub_f32_e32 v138, v138, v42
		v_sub_f32_e32 v139, v139, v42
		v_accvgpr_write_b32 a145, v139
		v_accvgpr_read_b32 v139, a148
		v_sub_f32_e32 v139, v139, v42
		v_accvgpr_write_b32 a146, v139
		v_accvgpr_read_b32 v139, a149
		v_sub_f32_e32 v139, v139, v42
		v_sub_f32_e32 v142, v142, v42
		v_sub_f32_e32 v143, v143, v42
		v_sub_f32_e32 v40, v40, v42
		v_sub_f32_e32 v41, v41, v42
		v_sub_f32_e32 v146, v146, v42
		v_sub_f32_e32 v147, v147, v42
		v_sub_f32_e32 v148, v148, v42
		v_sub_f32_e32 v149, v149, v42
		v_sub_f32_e32 v210, v210, v42
		v_sub_f32_e32 v211, v211, v42
		v_sub_f32_e32 v150, v150, v42
		v_sub_f32_e32 v151, v151, v42
		v_sub_f32_e32 v174, v174, v42
		v_sub_f32_e32 v175, v175, v42
		v_sub_f32_e32 v152, v152, v42
		v_sub_f32_e32 v153, v153, v42
		v_sub_f32_e32 v176, v176, v42
		v_sub_f32_e32 v177, v177, v42
		v_sub_f32_e32 v154, v154, v42
		v_sub_f32_e32 v155, v155, v42
		v_sub_f32_e32 v156, v156, v42
		v_sub_f32_e32 v157, v157, v42
		v_sub_f32_e32 v158, v158, v42
		v_sub_f32_e32 v159, v159, v42
		v_sub_f32_e32 v184, v184, v42
		v_sub_f32_e32 v185, v185, v42
		v_sub_f32_e32 v160, v160, v42
		v_sub_f32_e32 v161, v161, v42
		v_sub_f32_e32 v186, v186, v42
		v_sub_f32_e32 v187, v187, v42
		v_sub_f32_e32 v162, v162, v42
		v_sub_f32_e32 v163, v163, v42
		v_exp_f32_e32 v44, v44
		s_nop 0
		v_accvgpr_write_b32 a148, v44
		v_exp_f32_e32 v254, v164
		v_exp_f32_e32 v44, v165
		s_nop 0
		v_accvgpr_write_b32 a149, v44
		v_exp_f32_e32 v255, v192
		v_exp_f32_e32 v44, v193
		s_nop 0
		v_accvgpr_write_b32 a150, v44
		v_exp_f32_e32 v164, v194
		v_exp_f32_e32 v44, v166
		s_nop 0
		v_accvgpr_write_b32 a151, v44
		v_exp_f32_e32 v165, v167
		v_exp_f32_e32 v166, v168
		v_exp_f32_e32 v192, v169
		v_exp_f32_e32 v167, v38
		v_exp_f32_e32 v193, v39
		v_exp_f32_e32 v38, v170
		v_exp_f32_e32 v168, v171
		v_exp_f32_e32 v39, v195
		v_exp_f32_e32 v169, v204
		v_exp_f32_e32 v170, v205
		v_exp_f32_e32 v194, v206
		v_exp_f32_e32 v171, v207
		v_exp_f32_e32 v195, v212
		v_exp_f32_e32 v204, v202
		v_exp_f32_e32 v206, v203
		v_exp_f32_e32 v205, v213
		v_exp_f32_e32 v207, v214
		v_exp_f32_e32 v202, v140
		v_exp_f32_e32 v212, v141
		v_exp_f32_e32 v203, v208
		v_exp_f32_e32 v213, v209
		v_exp_f32_e32 v140, v172
		v_exp_f32_e32 v208, v173
		v_exp_f32_e32 v141, v144
		v_exp_f32_e32 v209, v145
		v_exp_f32_e32 v144, v180
		v_exp_f32_e32 v172, v181
		v_exp_f32_e32 v145, v178
		v_exp_f32_e32 v173, v179
		v_exp_f32_e32 v178, v188
		v_exp_f32_e32 v180, v189
		v_exp_f32_e32 v179, v182
		v_exp_f32_e32 v181, v183
		v_exp_f32_e32 v182, v200
		v_exp_f32_e32 v188, v201
		v_exp_f32_e32 v183, v190
		v_exp_f32_e32 v189, v191
		v_exp_f32_e32 v190, v215
		v_exp_f32_e32 v200, v216
		v_exp_f32_e32 v191, v217
		v_exp_f32_e32 v201, v218
		v_exp_f32_e32 v214, v219
		v_exp_f32_e32 v216, v220
		v_exp_f32_e32 v215, v221
		v_exp_f32_e32 v217, v222
		v_exp_f32_e32 v218, v223
		v_exp_f32_e32 v220, v224
		v_exp_f32_e32 v219, v225
		v_exp_f32_e32 v221, v226
		v_exp_f32_e32 v222, v227
		v_exp_f32_e32 v224, v228
		v_exp_f32_e32 v223, v229
		v_exp_f32_e32 v225, v230
		v_exp_f32_e32 v226, v231
		v_exp_f32_e32 v228, v232
		v_exp_f32_e32 v227, v233
		v_exp_f32_e32 v229, v234
		v_exp_f32_e32 v44, v235
		s_nop 0
		v_accvgpr_write_b32 a153, v44
		v_exp_f32_e32 v44, v236
		s_nop 0
		v_accvgpr_write_b32 a155, v44
		v_exp_f32_e32 v230, v237
		v_exp_f32_e32 v232, v240
		v_exp_f32_e32 v231, v241
		v_exp_f32_e32 v233, v242
		v_exp_f32_e32 v234, v243
		v_exp_f32_e32 v236, v244
		v_exp_f32_e32 v235, v245
		v_exp_f32_e32 v237, v246
		v_exp_f32_e32 v240, v247
		v_exp_f32_e32 v242, v248
		v_exp_f32_e32 v241, v249
		v_exp_f32_e32 v243, v250
		v_exp_f32_e32 v244, v251
		v_exp_f32_e32 v246, v252
		v_accvgpr_read_b32 v44, a44
		v_exp_f32_e32 v245, v44
		v_accvgpr_read_b32 v44, a45
		v_exp_f32_e32 v247, v44
		v_accvgpr_read_b32 v44, a46
		v_exp_f32_e32 v44, v44
		s_nop 0
		v_accvgpr_write_b32 a44, v44
		v_accvgpr_read_b32 v44, a47
		v_exp_f32_e32 v44, v44
		s_nop 0
		v_accvgpr_write_b32 a46, v44
		v_accvgpr_read_b32 v44, a80
		v_exp_f32_e32 v44, v44
		s_nop 0
		v_accvgpr_write_b32 a45, v44
		v_accvgpr_read_b32 v44, a81
		v_exp_f32_e32 v44, v44
		s_nop 0
		v_accvgpr_write_b32 a47, v44
		v_accvgpr_read_b32 v44, a82
		v_exp_f32_e32 v44, v44
		s_nop 0
		v_accvgpr_write_b32 a80, v44
		v_exp_f32_e32 v248, v253
		v_exp_f32_e32 v44, v238
		s_nop 0
		v_accvgpr_write_b32 a81, v44
		v_accvgpr_read_b32 v44, a83
		v_exp_f32_e32 v249, v44
		v_accvgpr_read_b32 v44, a144
		v_exp_f32_e32 v44, v44
		s_nop 0
		v_accvgpr_write_b32 a82, v44
		v_exp_f32_e32 v250, v239
		v_exp_f32_e32 v44, v138
		s_nop 0
		v_accvgpr_write_b32 a83, v44
		v_accvgpr_read_b32 v44, a145
		v_exp_f32_e32 v251, v44
		v_accvgpr_read_b32 v44, a146
		v_exp_f32_e32 v238, v44
		v_exp_f32_e32 v252, v139
		v_exp_f32_e32 v239, v142
		v_exp_f32_e32 v253, v143
		v_exp_f32_e32 v138, v40
		v_exp_f32_e32 v142, v41
		v_exp_f32_e32 v139, v146
		v_exp_f32_e32 v143, v147
		v_exp_f32_e32 v40, v148
		v_exp_f32_e32 v146, v149
		v_exp_f32_e32 v41, v210
		v_exp_f32_e32 v147, v211
		v_exp_f32_e32 v148, v150
		v_exp_f32_e32 v210, v151
		v_exp_f32_e32 v149, v174
		v_exp_f32_e32 v211, v175
		v_exp_f32_e32 v150, v152
		v_exp_f32_e32 v174, v153
		v_exp_f32_e32 v151, v176
		v_exp_f32_e32 v175, v177
		v_exp_f32_e32 v152, v154
		v_exp_f32_e32 v176, v155
		v_exp_f32_e32 v153, v156
		v_exp_f32_e32 v177, v157
		v_exp_f32_e32 v154, v158
		v_exp_f32_e32 v156, v159
		v_exp_f32_e32 v155, v184
		v_exp_f32_e32 v157, v185
		v_exp_f32_e32 v44, v160
		s_nop 0
		v_accvgpr_write_b32 a144, v44
		v_exp_f32_e32 v44, v161
		s_nop 0
		v_accvgpr_write_b32 a146, v44
		v_exp_f32_e32 v44, v186
		s_nop 0
		v_accvgpr_write_b32 a145, v44
		v_exp_f32_e32 v44, v187
		s_nop 0
		v_accvgpr_write_b32 a147, v44
		v_exp_f32_e32 v44, v162
		s_nop 0
		v_accvgpr_write_b32 a156, v44
		v_exp_f32_e32 v44, v163
		s_nop 0
		v_accvgpr_write_b32 a158, v44
		v_accvgpr_read_b32 v158, a148
		v_accvgpr_read_b32 v159, a149
		v_pk_add_f32 v[158:159], v[158:159], v[254:255]
		v_accvgpr_write_b32 a160, v158
		v_accvgpr_write_b32 a161, v159
		v_accvgpr_read_b32 v158, a150
		v_accvgpr_read_b32 v159, a151
		v_pk_add_f32 v[160:161], v[158:159], v[164:165]
		v_pk_add_f32 v[158:159], v[166:167], v[192:193]
		v_accvgpr_write_b32 a162, v158
		v_accvgpr_write_b32 a163, v159
		v_pk_add_f32 v[158:159], v[38:39], v[168:169]
		v_accvgpr_write_b32 a164, v158
		v_accvgpr_write_b32 a165, v159
		v_pk_add_f32 v[158:159], v[170:171], v[194:195]
		v_accvgpr_write_b32 a166, v158
		v_accvgpr_write_b32 a167, v159
		v_pk_add_f32 v[158:159], v[204:205], v[206:207]
		v_accvgpr_write_b32 a168, v158
		v_accvgpr_write_b32 a169, v159
		v_pk_add_f32 v[158:159], v[202:203], v[212:213]
		v_accvgpr_write_b32 a170, v158
		v_accvgpr_write_b32 a171, v159
		v_pk_add_f32 v[158:159], v[140:141], v[208:209]
		v_accvgpr_write_b32 a172, v158
		v_accvgpr_write_b32 a173, v159
		v_pk_add_f32 v[158:159], v[144:145], v[172:173]
		v_accvgpr_write_b32 a174, v158
		v_accvgpr_write_b32 a175, v159
		v_pk_add_f32 v[158:159], v[178:179], v[180:181]
		v_accvgpr_write_b32 a176, v158
		v_accvgpr_write_b32 a177, v159
		v_pk_add_f32 v[158:159], v[182:183], v[188:189]
		v_accvgpr_write_b32 a178, v158
		v_accvgpr_write_b32 a179, v159
		v_pk_add_f32 v[158:159], v[190:191], v[200:201]
		v_accvgpr_write_b32 a180, v158
		v_accvgpr_write_b32 a181, v159
		v_pk_add_f32 v[158:159], v[214:215], v[216:217]
		v_accvgpr_write_b32 a182, v158
		v_accvgpr_write_b32 a183, v159
		v_pk_add_f32 v[158:159], v[218:219], v[220:221]
		v_accvgpr_write_b32 a184, v158
		v_accvgpr_write_b32 a185, v159
		v_pk_add_f32 v[158:159], v[222:223], v[224:225]
		v_accvgpr_write_b32 a186, v158
		v_accvgpr_write_b32 a187, v159
		v_pk_add_f32 v[158:159], v[226:227], v[228:229]
		v_accvgpr_write_b32 a188, v158
		v_accvgpr_write_b32 a189, v159
		v_accvgpr_read_b32 v44, a161
		v_accvgpr_write_b32 a190, v44
		v_mov_b32_e32 v44, v161
		v_accvgpr_write_b32 a191, v44
		v_accvgpr_read_b32 v44, a160
		v_accvgpr_write_b32 a160, v44
		v_mov_b32_e32 v44, v160
		v_accvgpr_write_b32 a161, v44
		v_accvgpr_read_b32 v158, a190
		v_accvgpr_read_b32 v159, a191
		v_accvgpr_read_b32 v160, a160
		v_accvgpr_read_b32 v161, a161
		v_pk_add_f32 v[158:159], v[160:161], v[158:159]
		v_accvgpr_write_b32 a160, v158
		v_accvgpr_write_b32 a161, v159
		v_accvgpr_read_b32 v44, a163
		v_mov_b32_e32 v158, v44
		v_accvgpr_read_b32 v44, a165
		v_mov_b32_e32 v159, v44
		v_accvgpr_read_b32 v44, a162
		v_mov_b32_e32 v160, v44
		v_accvgpr_read_b32 v44, a164
		v_mov_b32_e32 v161, v44
		v_pk_add_f32 v[158:159], v[160:161], v[158:159]
		v_accvgpr_write_b32 a162, v158
		v_accvgpr_write_b32 a163, v159
		v_accvgpr_read_b32 v44, a167
		v_mov_b32_e32 v158, v44
		v_accvgpr_read_b32 v44, a169
		v_mov_b32_e32 v159, v44
		v_accvgpr_read_b32 v44, a166
		v_mov_b32_e32 v160, v44
		v_accvgpr_read_b32 v44, a168
		v_mov_b32_e32 v161, v44
		v_pk_add_f32 v[158:159], v[160:161], v[158:159]
		v_accvgpr_write_b32 a164, v158
		v_accvgpr_write_b32 a165, v159
		v_accvgpr_read_b32 v44, a171
		v_mov_b32_e32 v158, v44
		v_accvgpr_read_b32 v44, a173
		v_mov_b32_e32 v159, v44
		v_accvgpr_read_b32 v44, a170
		v_mov_b32_e32 v160, v44
		v_accvgpr_read_b32 v44, a172
		v_mov_b32_e32 v161, v44
		v_pk_add_f32 v[158:159], v[160:161], v[158:159]
		v_accvgpr_write_b32 a166, v158
		v_accvgpr_write_b32 a167, v159
		v_accvgpr_read_b32 v44, a175
		v_mov_b32_e32 v158, v44
		v_accvgpr_read_b32 v44, a177
		v_mov_b32_e32 v159, v44
		v_accvgpr_read_b32 v44, a174
		v_mov_b32_e32 v160, v44
		v_accvgpr_read_b32 v44, a176
		v_mov_b32_e32 v161, v44
		v_pk_add_f32 v[158:159], v[160:161], v[158:159]
		v_accvgpr_write_b32 a168, v158
		v_accvgpr_write_b32 a169, v159
		v_accvgpr_read_b32 v44, a179
		v_mov_b32_e32 v158, v44
		v_accvgpr_read_b32 v44, a181
		v_mov_b32_e32 v159, v44
		v_accvgpr_read_b32 v44, a178
		v_mov_b32_e32 v160, v44
		v_accvgpr_read_b32 v44, a180
		v_mov_b32_e32 v161, v44
		v_pk_add_f32 v[158:159], v[160:161], v[158:159]
		v_accvgpr_write_b32 a170, v158
		v_accvgpr_write_b32 a171, v159
		v_accvgpr_read_b32 v44, a183
		v_mov_b32_e32 v158, v44
		v_accvgpr_read_b32 v44, a185
		v_mov_b32_e32 v159, v44
		v_accvgpr_read_b32 v44, a182
		v_mov_b32_e32 v160, v44
		v_accvgpr_read_b32 v44, a184
		v_mov_b32_e32 v161, v44
		v_pk_add_f32 v[158:159], v[160:161], v[158:159]
		v_accvgpr_write_b32 a172, v158
		v_accvgpr_write_b32 a173, v159
		v_accvgpr_read_b32 v44, a187
		v_mov_b32_e32 v158, v44
		v_accvgpr_read_b32 v44, a189
		v_mov_b32_e32 v159, v44
		v_accvgpr_read_b32 v44, a186
		v_mov_b32_e32 v160, v44
		v_accvgpr_read_b32 v44, a188
		v_mov_b32_e32 v161, v44
		v_pk_add_f32 v[158:159], v[160:161], v[158:159]
		v_accvgpr_write_b32 a174, v158
		v_accvgpr_write_b32 a175, v159
		v_accvgpr_read_b32 v44, a161
		v_mov_b32_e32 v158, v44
		v_accvgpr_read_b32 v44, a163
		v_mov_b32_e32 v159, v44
		v_accvgpr_read_b32 v44, a160
		v_mov_b32_e32 v160, v44
		v_accvgpr_read_b32 v44, a162
		v_mov_b32_e32 v161, v44
		v_pk_add_f32 v[158:159], v[160:161], v[158:159]
		v_accvgpr_write_b32 a160, v158
		v_accvgpr_write_b32 a161, v159
		v_accvgpr_read_b32 v44, a165
		v_mov_b32_e32 v158, v44
		v_accvgpr_read_b32 v44, a167
		v_mov_b32_e32 v159, v44
		v_accvgpr_read_b32 v44, a164
		v_mov_b32_e32 v160, v44
		v_accvgpr_read_b32 v44, a166
		v_mov_b32_e32 v161, v44
		v_pk_add_f32 v[158:159], v[160:161], v[158:159]
		v_accvgpr_write_b32 a162, v158
		v_accvgpr_write_b32 a163, v159
		v_accvgpr_read_b32 v44, a169
		v_mov_b32_e32 v158, v44
		v_accvgpr_read_b32 v44, a171
		v_mov_b32_e32 v159, v44
		v_accvgpr_read_b32 v44, a168
		v_mov_b32_e32 v160, v44
		v_accvgpr_read_b32 v44, a170
		v_mov_b32_e32 v161, v44
		v_pk_add_f32 v[158:159], v[160:161], v[158:159]
		v_accvgpr_write_b32 a164, v158
		v_accvgpr_write_b32 a165, v159
		v_accvgpr_read_b32 v44, a173
		v_mov_b32_e32 v158, v44
		v_accvgpr_read_b32 v44, a175
		v_mov_b32_e32 v159, v44
		v_accvgpr_read_b32 v44, a172
		v_mov_b32_e32 v160, v44
		v_accvgpr_read_b32 v44, a174
		v_mov_b32_e32 v161, v44
		v_pk_add_f32 v[158:159], v[160:161], v[158:159]
		v_accvgpr_write_b32 a166, v158
		v_accvgpr_write_b32 a167, v159
		v_accvgpr_read_b32 v44, a161
		v_mov_b32_e32 v158, v44
		v_accvgpr_read_b32 v44, a163
		v_mov_b32_e32 v159, v44
		v_accvgpr_read_b32 v44, a160
		v_mov_b32_e32 v160, v44
		v_accvgpr_read_b32 v44, a162
		v_mov_b32_e32 v161, v44
		v_pk_add_f32 v[158:159], v[160:161], v[158:159]
		v_accvgpr_write_b32 a160, v158
		v_accvgpr_write_b32 a161, v159
		v_accvgpr_read_b32 v44, a165
		v_mov_b32_e32 v158, v44
		v_accvgpr_read_b32 v44, a167
		v_mov_b32_e32 v159, v44
		v_accvgpr_read_b32 v44, a164
		v_mov_b32_e32 v160, v44
		v_accvgpr_read_b32 v44, a166
		v_mov_b32_e32 v161, v44
		v_pk_add_f32 v[162:163], v[160:161], v[158:159]
		v_accvgpr_read_b32 v44, a161
		v_mov_b32_e32 v158, v44
		v_mov_b32_e32 v159, v163
		v_accvgpr_read_b32 v44, a160
		v_mov_b32_e32 v160, v44
		v_mov_b32_e32 v161, v162
		v_pk_add_f32 v[162:163], v[160:161], v[158:159]
		v_add_f32_e32 v44, v162, v163
		v_and_b32_e32 v158, 1, v10
		v_lshrrev_b32_e32 v159, 4, v10
		v_and_b32_e32 v159, 1, v159
		v_lshlrev_b32_e32 v159, 4, v159
		v_lshrrev_b32_e32 v160, 3, v10
		v_and_b32_e32 v160, 1, v160
		v_lshlrev_b32_e32 v160, 3, v160
		v_add3_u32 v158, v158, v159, v160
		v_lshrrev_b32_e32 v159, 2, v10
		v_and_b32_e32 v159, 1, v159
		v_lshlrev_b32_e32 v159, 2, v159
		v_lshrrev_b32_e32 v160, 1, v10
		v_and_b32_e32 v160, 1, v160
		v_lshlrev_b32_e32 v160, 1, v160
		v_add3_u32 v158, v158, v159, v160
		v_lshlrev_b32_e32 v158, 2, v158
		ds_bpermute_b32 v159, v158, v44
		s_waitcnt lgkmcnt(0)
		v_accvgpr_write_b32 a152, v159
		v_lshrrev_b32_e32 v159, 4, v10
		v_and_b32_e32 v159, 1, v159
		v_lshlrev_b32_e32 v159, 4, v159
		v_lshrrev_b32_e32 v160, 3, v10
		v_and_b32_e32 v160, 1, v160
		v_lshlrev_b32_e32 v160, 3, v160
		v_lshrrev_b32_e32 v161, 2, v10
		v_and_b32_e32 v161, 1, v161
		v_lshlrev_b32_e32 v161, 2, v161
		v_and_b32_e32 v162, 1, v10
		v_add_u32_e32 v162, 32, v162
		v_lshrrev_b32_e32 v163, 1, v10
		v_and_b32_e32 v163, 1, v163
		v_lshlrev_b32_e32 v163, 1, v163
		v_bitop3_b32 v161, v161, v162, v163 bitop3:0x96
		v_bitop3_b32 v159, v159, v160, v161 bitop3:0x96
		v_lshlrev_b32_e32 v159, 2, v159
		ds_bpermute_b32 v160, v159, v44
		s_waitcnt lgkmcnt(0)
		v_accvgpr_write_b32 a154, v160
		v_pk_add_f32 v[160:161], v[230:231], v[232:233]
		v_accvgpr_write_b32 a160, v160
		v_accvgpr_write_b32 a161, v161
		v_pk_add_f32 v[160:161], v[234:235], v[236:237]
		v_accvgpr_write_b32 a162, v160
		v_accvgpr_write_b32 a163, v161
		v_pk_add_f32 v[160:161], v[240:241], v[242:243]
		v_accvgpr_write_b32 a164, v160
		v_accvgpr_write_b32 a165, v161
		v_pk_add_f32 v[160:161], v[244:245], v[246:247]
		v_accvgpr_write_b32 a166, v160
		v_accvgpr_write_b32 a167, v161
		v_accvgpr_read_b32 v160, a152
		v_accvgpr_read_b32 v161, a153
		v_accvgpr_read_b32 v162, a154
		v_accvgpr_read_b32 v163, a155
		v_pk_add_f32 v[160:161], v[160:161], v[162:163]
		v_accvgpr_write_b32 a168, v160
		v_accvgpr_write_b32 a169, v161
		v_accvgpr_read_b32 v160, a44
		v_accvgpr_read_b32 v161, a45
		v_accvgpr_read_b32 v162, a46
		v_accvgpr_read_b32 v163, a47
		v_pk_add_f32 v[160:161], v[160:161], v[162:163]
		v_accvgpr_write_b32 a170, v160
		v_accvgpr_write_b32 a171, v161
		v_accvgpr_read_b32 v160, a80
		v_accvgpr_read_b32 v161, a81
		v_pk_add_f32 v[160:161], v[160:161], v[248:249]
		v_accvgpr_write_b32 a172, v160
		v_accvgpr_write_b32 a173, v161
		v_accvgpr_read_b32 v160, a82
		v_accvgpr_read_b32 v161, a83
		v_pk_add_f32 v[160:161], v[160:161], v[250:251]
		v_accvgpr_write_b32 a174, v160
		v_accvgpr_write_b32 a175, v161
		v_pk_add_f32 v[160:161], v[238:239], v[252:253]
		v_accvgpr_write_b32 a176, v160
		v_accvgpr_write_b32 a177, v161
		v_pk_add_f32 v[160:161], v[138:139], v[142:143]
		v_accvgpr_write_b32 a178, v160
		v_accvgpr_write_b32 a179, v161
		v_pk_add_f32 v[160:161], v[40:41], v[146:147]
		v_accvgpr_write_b32 a180, v160
		v_accvgpr_write_b32 a181, v161
		v_pk_add_f32 v[160:161], v[148:149], v[210:211]
		v_accvgpr_write_b32 a182, v160
		v_accvgpr_write_b32 a183, v161
		v_pk_add_f32 v[160:161], v[150:151], v[174:175]
		v_accvgpr_write_b32 a184, v160
		v_accvgpr_write_b32 a185, v161
		v_pk_add_f32 v[160:161], v[152:153], v[176:177]
		v_accvgpr_write_b32 a186, v160
		v_accvgpr_write_b32 a187, v161
		v_pk_add_f32 v[160:161], v[154:155], v[156:157]
		v_accvgpr_write_b32 a188, v160
		v_accvgpr_write_b32 a189, v161
		v_accvgpr_read_b32 v160, a144
		v_accvgpr_read_b32 v161, a145
		v_accvgpr_read_b32 v162, a146
		v_accvgpr_read_b32 v163, a147
		v_pk_add_f32 v[160:161], v[160:161], v[162:163]
		v_accvgpr_write_b32 a190, v160
		v_accvgpr_write_b32 a191, v161
		v_accvgpr_read_b32 v44, a169
		v_accvgpr_write_b32 a157, v44
		v_accvgpr_read_b32 v44, a160
		v_accvgpr_write_b32 a159, v44
		v_accvgpr_read_b32 v160, a156
		v_accvgpr_read_b32 v161, a157
		v_accvgpr_read_b32 v162, a158
		v_accvgpr_read_b32 v163, a159
		v_pk_add_f32 v[160:161], v[160:161], v[162:163]
		v_accvgpr_write_b32 a192, v160
		v_accvgpr_write_b32 a193, v161
		v_accvgpr_read_b32 v44, a161
		v_mov_b32_e32 v160, v44
		v_accvgpr_read_b32 v44, a164
		v_mov_b32_e32 v161, v44
		v_accvgpr_read_b32 v162, a162
		v_accvgpr_read_b32 v163, a163
		v_pk_add_f32 v[160:161], v[160:161], v[162:163]
		v_accvgpr_write_b32 a160, v160
		v_accvgpr_write_b32 a161, v161
		v_accvgpr_read_b32 v44, a165
		v_mov_b32_e32 v160, v44
		v_accvgpr_read_b32 v44, a170
		v_mov_b32_e32 v161, v44
		v_accvgpr_read_b32 v162, a166
		v_accvgpr_read_b32 v163, a167
		v_pk_add_f32 v[160:161], v[160:161], v[162:163]
		v_accvgpr_write_b32 a162, v160
		v_accvgpr_write_b32 a163, v161
		v_accvgpr_read_b32 v44, a171
		v_mov_b32_e32 v160, v44
		v_accvgpr_read_b32 v44, a174
		v_mov_b32_e32 v161, v44
		v_accvgpr_read_b32 v162, a172
		v_accvgpr_read_b32 v163, a173
		v_pk_add_f32 v[160:161], v[160:161], v[162:163]
		v_accvgpr_write_b32 a164, v160
		v_accvgpr_write_b32 a165, v161
		v_accvgpr_read_b32 v44, a175
		v_mov_b32_e32 v160, v44
		v_accvgpr_read_b32 v44, a178
		v_mov_b32_e32 v161, v44
		v_accvgpr_read_b32 v162, a176
		v_accvgpr_read_b32 v163, a177
		v_pk_add_f32 v[160:161], v[160:161], v[162:163]
		v_accvgpr_write_b32 a166, v160
		v_accvgpr_write_b32 a167, v161
		v_accvgpr_read_b32 v44, a179
		v_mov_b32_e32 v160, v44
		v_accvgpr_read_b32 v44, a182
		v_mov_b32_e32 v161, v44
		v_accvgpr_read_b32 v162, a180
		v_accvgpr_read_b32 v163, a181
		v_pk_add_f32 v[160:161], v[160:161], v[162:163]
		v_accvgpr_write_b32 a170, v160
		v_accvgpr_write_b32 a171, v161
		v_accvgpr_read_b32 v44, a183
		v_mov_b32_e32 v160, v44
		v_accvgpr_read_b32 v44, a186
		v_mov_b32_e32 v161, v44
		v_accvgpr_read_b32 v162, a184
		v_accvgpr_read_b32 v163, a185
		v_pk_add_f32 v[160:161], v[160:161], v[162:163]
		v_accvgpr_write_b32 a172, v160
		v_accvgpr_write_b32 a173, v161
		v_accvgpr_read_b32 v44, a187
		v_mov_b32_e32 v160, v44
		v_accvgpr_read_b32 v44, a190
		v_mov_b32_e32 v161, v44
		v_accvgpr_read_b32 v162, a188
		v_accvgpr_read_b32 v163, a189
		v_pk_add_f32 v[160:161], v[160:161], v[162:163]
		v_accvgpr_write_b32 a174, v160
		v_accvgpr_write_b32 a175, v161
		v_accvgpr_read_b32 v44, a191
		v_mov_b32_e32 v160, v44
		v_accvgpr_read_b32 v44, a160
		v_mov_b32_e32 v161, v44
		v_accvgpr_read_b32 v162, a192
		v_accvgpr_read_b32 v163, a193
		v_pk_add_f32 v[160:161], v[160:161], v[162:163]
		v_accvgpr_write_b32 a176, v160
		v_accvgpr_write_b32 a177, v161
		v_accvgpr_read_b32 v44, a161
		v_mov_b32_e32 v160, v44
		v_accvgpr_read_b32 v44, a164
		v_mov_b32_e32 v161, v44
		v_accvgpr_read_b32 v162, a162
		v_accvgpr_read_b32 v163, a163
		v_pk_add_f32 v[160:161], v[160:161], v[162:163]
		v_accvgpr_write_b32 a160, v160
		v_accvgpr_write_b32 a161, v161
		v_accvgpr_read_b32 v44, a165
		v_mov_b32_e32 v160, v44
		v_accvgpr_read_b32 v44, a170
		v_mov_b32_e32 v161, v44
		v_accvgpr_read_b32 v162, a166
		v_accvgpr_read_b32 v163, a167
		v_pk_add_f32 v[160:161], v[160:161], v[162:163]
		v_accvgpr_write_b32 a162, v160
		v_accvgpr_write_b32 a163, v161
		v_accvgpr_read_b32 v44, a171
		v_mov_b32_e32 v160, v44
		v_accvgpr_read_b32 v44, a174
		v_mov_b32_e32 v161, v44
		v_accvgpr_read_b32 v162, a172
		v_accvgpr_read_b32 v163, a173
		v_pk_add_f32 v[160:161], v[160:161], v[162:163]
		v_accvgpr_write_b32 a164, v160
		v_accvgpr_write_b32 a165, v161
		v_accvgpr_read_b32 v44, a175
		v_mov_b32_e32 v160, v44
		v_accvgpr_read_b32 v44, a160
		v_mov_b32_e32 v161, v44
		v_accvgpr_read_b32 v162, a176
		v_accvgpr_read_b32 v163, a177
		v_pk_add_f32 v[160:161], v[160:161], v[162:163]
		v_accvgpr_write_b32 a166, v160
		v_accvgpr_write_b32 a167, v161
		v_accvgpr_read_b32 v44, a161
		v_accvgpr_write_b32 a160, v44
		v_accvgpr_read_b32 v44, a164
		v_accvgpr_write_b32 a161, v44
		v_accvgpr_read_b32 v160, a162
		v_accvgpr_read_b32 v161, a163
		v_accvgpr_read_b32 v162, a160
		v_accvgpr_read_b32 v163, a161
		v_pk_add_f32 v[160:161], v[162:163], v[160:161]
		v_accvgpr_write_b32 a160, v160
		v_accvgpr_write_b32 a161, v161
		v_accvgpr_read_b32 v44, a165
		v_accvgpr_write_b32 a162, v44
		v_accvgpr_read_b32 v44, a160
		v_accvgpr_write_b32 a163, v44
		v_accvgpr_read_b32 v160, a166
		v_accvgpr_read_b32 v161, a167
		v_accvgpr_read_b32 v162, a162
		v_accvgpr_read_b32 v163, a163
		v_pk_add_f32 v[184:185], v[162:163], v[160:161]
		v_accvgpr_read_b32 v44, a161
		v_add_f32_e32 v44, v44, v184
		v_add_f32_e32 v44, v185, v44
		ds_bpermute_b32 v160, v158, v44
		ds_bpermute_b32 v158, v159, v44
		v_sub_f32_e32 v17, v17, v37
		v_sub_f32_e32 v21, v21, v42
		v_exp_f32_e32 v162, v17
		v_exp_f32_e32 v184, v21
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v187, v160, v158
		v_mov_b32_e32 v163, v162
		v_pk_mul_f32 v[48:49], v[48:49], v[162:163]
		v_pk_mul_f32 v[50:51], v[50:51], v[162:163]
		v_pk_mul_f32 v[52:53], v[52:53], v[162:163]
		v_pk_mul_f32 v[54:55], v[54:55], v[162:163]
		v_pk_mul_f32 v[56:57], v[56:57], v[162:163]
		v_pk_mul_f32 v[58:59], v[58:59], v[162:163]
		v_pk_mul_f32 v[60:61], v[60:61], v[162:163]
		v_pk_mul_f32 v[62:63], v[62:63], v[162:163]
		v_pk_mul_f32 v[64:65], v[64:65], v[162:163]
		v_pk_mul_f32 v[66:67], v[66:67], v[162:163]
		v_pk_mul_f32 v[68:69], v[68:69], v[162:163]
		v_pk_mul_f32 v[70:71], v[70:71], v[162:163]
		v_pk_mul_f32 v[72:73], v[72:73], v[162:163]
		v_pk_mul_f32 v[74:75], v[74:75], v[162:163]
		v_pk_mul_f32 v[76:77], v[76:77], v[162:163]
		v_pk_mul_f32 v[78:79], v[78:79], v[162:163]
		v_mov_b32_e32 v185, v184
		v_accvgpr_read_b32 v158, a48
		v_accvgpr_read_b32 v159, a49
		v_pk_mul_f32 v[158:159], v[158:159], v[184:185]
		v_accvgpr_write_b32 a48, v158
		v_accvgpr_write_b32 a49, v159
		v_accvgpr_read_b32 v158, a50
		v_accvgpr_read_b32 v159, a51
		v_pk_mul_f32 v[158:159], v[158:159], v[184:185]
		v_accvgpr_write_b32 a50, v158
		v_accvgpr_write_b32 a51, v159
		v_accvgpr_read_b32 v158, a52
		v_accvgpr_read_b32 v159, a53
		v_pk_mul_f32 v[158:159], v[158:159], v[184:185]
		v_accvgpr_write_b32 a52, v158
		v_accvgpr_write_b32 a53, v159
		v_accvgpr_read_b32 v158, a54
		v_accvgpr_read_b32 v159, a55
		v_pk_mul_f32 v[158:159], v[158:159], v[184:185]
		v_accvgpr_write_b32 a54, v158
		v_accvgpr_write_b32 a55, v159
		v_accvgpr_read_b32 v158, a56
		v_accvgpr_read_b32 v159, a57
		v_pk_mul_f32 v[158:159], v[158:159], v[184:185]
		v_accvgpr_write_b32 a56, v158
		v_accvgpr_write_b32 a57, v159
		v_accvgpr_read_b32 v158, a58
		v_accvgpr_read_b32 v159, a59
		v_pk_mul_f32 v[158:159], v[158:159], v[184:185]
		v_accvgpr_write_b32 a58, v158
		v_accvgpr_write_b32 a59, v159
		v_accvgpr_read_b32 v158, a60
		v_accvgpr_read_b32 v159, a61
		v_pk_mul_f32 v[158:159], v[158:159], v[184:185]
		v_accvgpr_write_b32 a60, v158
		v_accvgpr_write_b32 a61, v159
		v_accvgpr_read_b32 v158, a62
		v_accvgpr_read_b32 v159, a63
		v_pk_mul_f32 v[158:159], v[158:159], v[184:185]
		v_accvgpr_write_b32 a62, v158
		v_accvgpr_write_b32 a63, v159
		v_accvgpr_read_b32 v158, a64
		v_accvgpr_read_b32 v159, a65
		v_pk_mul_f32 v[158:159], v[158:159], v[184:185]
		v_accvgpr_write_b32 a64, v158
		v_accvgpr_write_b32 a65, v159
		v_accvgpr_read_b32 v158, a66
		v_accvgpr_read_b32 v159, a67
		v_pk_mul_f32 v[158:159], v[158:159], v[184:185]
		v_accvgpr_write_b32 a66, v158
		v_accvgpr_write_b32 a67, v159
		v_accvgpr_read_b32 v158, a68
		v_accvgpr_read_b32 v159, a69
		v_pk_mul_f32 v[158:159], v[158:159], v[184:185]
		v_accvgpr_write_b32 a68, v158
		v_accvgpr_write_b32 a69, v159
		v_accvgpr_read_b32 v158, a70
		v_accvgpr_read_b32 v159, a71
		v_pk_mul_f32 v[158:159], v[158:159], v[184:185]
		v_accvgpr_write_b32 a70, v158
		v_accvgpr_write_b32 a71, v159
		v_accvgpr_read_b32 v158, a72
		v_accvgpr_read_b32 v159, a73
		v_pk_mul_f32 v[158:159], v[158:159], v[184:185]
		v_accvgpr_write_b32 a72, v158
		v_accvgpr_write_b32 a73, v159
		v_accvgpr_read_b32 v158, a74
		v_accvgpr_read_b32 v159, a75
		v_pk_mul_f32 v[158:159], v[158:159], v[184:185]
		v_accvgpr_write_b32 a74, v158
		v_accvgpr_write_b32 a75, v159
		v_accvgpr_read_b32 v158, a76
		v_accvgpr_read_b32 v159, a77
		v_pk_mul_f32 v[158:159], v[158:159], v[184:185]
		v_accvgpr_write_b32 a76, v158
		v_accvgpr_write_b32 a77, v159
		v_accvgpr_read_b32 v158, a78
		v_accvgpr_read_b32 v159, a79
		v_pk_mul_f32 v[158:159], v[158:159], v[184:185]
		v_accvgpr_write_b32 a78, v158
		v_accvgpr_write_b32 a79, v159
		v_accvgpr_read_b32 v17, a168
		v_mov_b32_e32 v186, v17
		v_mov_b32_e32 v158, v162
		v_mov_b32_e32 v159, v184
		v_accvgpr_read_b32 v17, a42
		v_mov_b32_e32 v160, v17
		v_accvgpr_read_b32 v17, a43
		v_mov_b32_e32 v161, v17
		v_pk_fma_f32 v[158:159], v[160:161], v[158:159], v[186:187]
		v_accvgpr_write_b32 a42, v158
		v_accvgpr_write_b32 a43, v159
		v_accvgpr_read_b32 v17, a148
		v_cvt_pk_bf16_f32 v160, v17, v254
		v_accvgpr_read_b32 v17, a149
		v_cvt_pk_bf16_f32 v161, v17, v255
		v_accvgpr_read_b32 v17, a150
		v_cvt_pk_bf16_f32 v162, v17, v164
		v_accvgpr_read_b32 v17, a151
		v_cvt_pk_bf16_f32 v163, v17, v165
		v_cvt_pk_bf16_f32 v184, v166, v192
		v_cvt_pk_bf16_f32 v185, v167, v193
		v_cvt_pk_bf16_f32 v186, v38, v168
		v_cvt_pk_bf16_f32 v187, v39, v169
		v_cvt_pk_bf16_f32 v164, v170, v194
		v_cvt_pk_bf16_f32 v165, v171, v195
		v_cvt_pk_bf16_f32 v166, v204, v206
		v_cvt_pk_bf16_f32 v167, v205, v207
		v_cvt_pk_bf16_f32 v168, v202, v212
		v_cvt_pk_bf16_f32 v169, v203, v213
		v_cvt_pk_bf16_f32 v170, v140, v208
		v_cvt_pk_bf16_f32 v171, v141, v209
		v_cvt_pk_bf16_f32 v192, v144, v172
		v_cvt_pk_bf16_f32 v193, v145, v173
		v_cvt_pk_bf16_f32 v194, v178, v180
		v_cvt_pk_bf16_f32 v195, v179, v181
		v_cvt_pk_bf16_f32 v204, v182, v188
		v_cvt_pk_bf16_f32 v205, v183, v189
		v_cvt_pk_bf16_f32 v206, v190, v200
		v_cvt_pk_bf16_f32 v207, v191, v201
		v_cvt_pk_bf16_f32 v180, v214, v216
		v_cvt_pk_bf16_f32 v181, v215, v217
		v_cvt_pk_bf16_f32 v182, v218, v220
		v_cvt_pk_bf16_f32 v183, v219, v221
		v_cvt_pk_bf16_f32 v188, v222, v224
		v_cvt_pk_bf16_f32 v189, v223, v225
		v_cvt_pk_bf16_f32 v190, v226, v228
		v_cvt_pk_bf16_f32 v191, v227, v229
		v_accvgpr_read_b32 v17, a153
		v_accvgpr_read_b32 v21, a155
		v_cvt_pk_bf16_f32 v200, v17, v21
		v_cvt_pk_bf16_f32 v201, v230, v232
		v_cvt_pk_bf16_f32 v202, v231, v233
		v_cvt_pk_bf16_f32 v203, v234, v236
		v_cvt_pk_bf16_f32 v212, v235, v237
		v_cvt_pk_bf16_f32 v213, v240, v242
		v_cvt_pk_bf16_f32 v214, v241, v243
		v_cvt_pk_bf16_f32 v215, v244, v246
		v_cvt_pk_bf16_f32 v216, v245, v247
		v_accvgpr_read_b32 v17, a44
		v_accvgpr_read_b32 v21, a46
		v_cvt_pk_bf16_f32 v217, v17, v21
		v_accvgpr_read_b32 v17, a45
		v_accvgpr_read_b32 v21, a47
		v_cvt_pk_bf16_f32 v218, v17, v21
		v_accvgpr_read_b32 v17, a80
		v_cvt_pk_bf16_f32 v219, v17, v248
		v_accvgpr_read_b32 v17, a81
		v_cvt_pk_bf16_f32 v220, v17, v249
		v_accvgpr_read_b32 v17, a82
		v_cvt_pk_bf16_f32 v221, v17, v250
		v_accvgpr_read_b32 v17, a83
		v_cvt_pk_bf16_f32 v222, v17, v251
		v_cvt_pk_bf16_f32 v223, v238, v252
		v_cvt_pk_bf16_f32 v224, v239, v253
		v_cvt_pk_bf16_f32 v225, v138, v142
		v_cvt_pk_bf16_f32 v226, v139, v143
		v_cvt_pk_bf16_f32 v227, v40, v146
		v_cvt_pk_bf16_f32 v140, v41, v147
		v_cvt_pk_bf16_f32 v141, v148, v210
		v_cvt_pk_bf16_f32 v142, v149, v211
		v_cvt_pk_bf16_f32 v143, v150, v174
		v_cvt_pk_bf16_f32 v144, v151, v175
		v_cvt_pk_bf16_f32 v145, v152, v176
		v_cvt_pk_bf16_f32 v146, v153, v177
		v_cvt_pk_bf16_f32 v147, v154, v156
		v_cvt_pk_bf16_f32 v148, v155, v157
		v_accvgpr_read_b32 v17, a144
		v_accvgpr_read_b32 v21, a146
		v_cvt_pk_bf16_f32 v149, v17, v21
		v_accvgpr_read_b32 v17, a145
		v_accvgpr_read_b32 v21, a147
		v_cvt_pk_bf16_f32 v150, v17, v21
		v_accvgpr_read_b32 v17, a156
		v_accvgpr_read_b32 v21, a158
		v_cvt_pk_bf16_f32 v151, v17, v21
		v_permlane32_swap_b32_e32 v160, v162
		v_permlane32_swap_b32_e32 v161, v163
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		v_permlane32_swap_b32_e32 v168, v170
		v_permlane32_swap_b32_e32 v169, v171
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_permlane32_swap_b32_e32 v212, v214
		v_permlane32_swap_b32_e32 v213, v215
		v_permlane32_swap_b32_e32 v216, v218
		v_permlane32_swap_b32_e32 v217, v219
		v_permlane32_swap_b32_e32 v220, v222
		v_permlane32_swap_b32_e32 v221, v223
		v_permlane32_swap_b32_e32 v224, v226
		v_permlane32_swap_b32_e32 v225, v227
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_permlane32_swap_b32_e32 v148, v150
		v_permlane32_swap_b32_e32 v149, v151
		v_mfma_f32_32x32x16_bf16 v[48:63], a[84:87], v[160:163], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[116:119], v[160:163], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[116:119], v[200:203], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[84:87], v[200:203], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[88:91], v[184:187], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[120:123], v[184:187], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[120:123], v[212:215], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[88:91], v[212:215], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[92:95], v[164:167], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[124:127], v[164:167], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[124:127], v[216:219], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[92:95], v[216:219], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[96:99], v[168:171], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[128:131], v[168:171], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[128:131], v[220:223], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[96:99], v[220:223], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[100:103], v[192:195], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[132:135], v[192:195], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[132:135], v[224:227], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[100:103], v[224:227], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[104:107], v[204:207], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[136:139], v[204:207], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[136:139], v[140:143], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[104:107], v[140:143], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[108:111], v[180:183], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[140:143], v[180:183], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[140:143], v[144:147], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[108:111], v[144:147], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[112:115], v[188:191], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], v[196:199], v[188:191], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], v[196:199], v[148:151], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[112:115], v[148:151], a[48:63]
		s_add_i32 s21, s46, 0x80
		s_cmp_lt_i32 s21, s26
		s_mov_b32 s46, s21
		v_mov_b32_e32 v17, v37
		v_mov_b32_e32 v21, v42
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_2
.L_attn_fwd_persistent.loop_exit_2:
		v_readfirstlane_b32 s21, v7
		v_readfirstlane_b32 s25, v1
		s_mul_i32 s21, s21, s25
		s_mov_b32 m0, s17
		s_lshl_b32 s21, s21, 9
		ds_read_addtid_b32 v7
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s25, v7
		s_mul_i32 s25, s1, s25
		s_lshl_b32 s25, s25, 1
		s_mov_b32 m0, s17
		s_add_i32 s26, s21, s25
		ds_read_addtid_b32 v7 offset:1024
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s41, v7
		s_mul_i32 s41, s24, s41
		s_lshl_b32 s41, s41, 1
		s_add_i32 s26, s26, s41
		s_add_i32 s43, s21, 32
		s_add_i32 s43, s43, s25
		s_add_i32 s43, s43, s41
		s_add_i32 s44, s21, 64
		s_add_i32 s44, s44, s25
		s_add_i32 s44, s44, s41
		s_add_i32 s21, s21, 0x60
		s_add_i32 s21, s21, s25
		s_add_i32 s21, s21, s41
		s_and_b32 s45, s0, 15
		s_mul_i32 s45, s45, 2
		s_add_i32 s45, s45, 1
		s_lshr_b32 s46, s45, 1
		s_and_b32 s45, s45, 1
		s_xor_b32 s47, s46, -1
		s_add_i32 s47, s47, 1
		s_add_i32 s47, s47, 31
		s_cmp_eq_u32 s45, 0
		s_cselect_b32 s45, s46, s47
		s_mul_i32 s46, s45, 0x100
		v_and_b32_e32 v7, 1, v0
		v_lshrrev_b32_e32 v8, 1, v0
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v9, 2
		v_mul_lo_u32 v9, v9, v8
		v_lshrrev_b32_e32 v8, 2, v0
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v11, 4
		v_mul_lo_u32 v11, v11, v8
		v_bitop3_b32 v7, v7, v9, v11 bitop3:0x96
		v_lshrrev_b32_e32 v8, 3, v0
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v9, 8
		v_mul_lo_u32 v9, v9, v8
		v_xor_b32_e32 v7, v7, v9
		v_lshrrev_b32_e32 v8, 4, v0
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v9, 16
		v_mul_lo_u32 v9, v9, v8
		v_lshrrev_b32_e32 v8, 6, v0
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v11, 32
		v_mul_lo_u32 v11, v11, v8
		v_bitop3_b32 v7, v7, v9, v11 bitop3:0x96
		v_lshrrev_b32_e32 v8, 7, v0
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v9, 64
		v_mul_lo_u32 v9, v9, v8
		v_xor_b32_e32 v7, v7, v9
		v_add_u32_e32 v7, s46, v7
		v_and_b32_e32 v8, 1, v0
		v_xor_b32_e32 v8, 0x80, v8
		v_lshrrev_b32_e32 v9, 1, v0
		v_and_b32_e32 v9, 1, v9
		v_mov_b32_e32 v11, 2
		v_mul_lo_u32 v11, v11, v9
		v_xor_b32_e32 v8, v8, v11
		v_lshrrev_b32_e32 v9, 2, v0
		v_and_b32_e32 v9, 1, v9
		v_mov_b32_e32 v11, 4
		v_mul_lo_u32 v11, v11, v9
		v_xor_b32_e32 v8, v8, v11
		v_lshrrev_b32_e32 v9, 3, v0
		v_and_b32_e32 v9, 1, v9
		v_mov_b32_e32 v11, 8
		v_mul_lo_u32 v11, v11, v9
		v_lshrrev_b32_e32 v9, 4, v0
		v_and_b32_e32 v9, 1, v9
		v_mov_b32_e32 v12, 16
		v_mul_lo_u32 v12, v12, v9
		v_bitop3_b32 v8, v8, v11, v12 bitop3:0x96
		v_lshrrev_b32_e32 v9, 6, v0
		v_and_b32_e32 v9, 1, v9
		v_mov_b32_e32 v11, 32
		v_mul_lo_u32 v11, v11, v9
		v_lshrrev_b32_e32 v9, 7, v0
		v_and_b32_e32 v9, 1, v9
		v_mov_b32_e32 v12, 64
		v_mul_lo_u32 v12, v12, v9
		v_bitop3_b32 v8, v8, v11, v12 bitop3:0x96
		v_add_u32_e32 v8, s46, v8
		v_cmp_lt_i32_e64 vcc, v7, s22
		s_mov_b64 s[48:49], vcc
		v_cmp_lt_i32_e64 vcc, v8, s22
		s_mov_b64 s[50:51], vcc
		v_lshrrev_b32_e32 v7, 3, v0
		v_and_b32_e32 v7, 1, v7
		v_lshrrev_b32_e32 v8, 4, v0
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v9, 2
		v_mul_lo_u32 v9, v9, v8
		v_lshrrev_b32_e32 v8, 5, v0
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v11, 4
		v_mul_lo_u32 v11, v11, v8
		v_bitop3_b32 v7, v7, v9, v11 bitop3:0x96
		v_lshrrev_b32_e32 v8, 6, v0
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v9, 8
		v_mul_lo_u32 v9, v9, v8
		v_lshrrev_b32_e32 v8, 7, v0
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v11, 16
		v_mul_lo_u32 v11, v11, v8
		v_bitop3_b32 v7, v7, v9, v11 bitop3:0x96
		v_add_u32_e32 v7, s46, v7
		v_cmp_lt_i32_e64 vcc, v7, s22
		s_mov_b64 s[52:53], vcc
		s_mul_i32 s47, s45, s12
		s_lshl_b32 s47, s47, 9
		s_mul_i32 s54, s1, s10
		s_lshl_b32 s54, s54, 1
		s_add_i32 s47, s47, s54
		s_mul_i32 s54, s24, s11
		s_lshl_b32 s54, s54, 1
		s_add_i32 s47, s47, s54
		v_lshrrev_b32_e32 v7, 7, v0
		v_mul_lo_u32 v7, s12, v7
		v_lshlrev_b32_e32 v7, 5, v7
		v_lshrrev_b32_e32 v8, 6, v0
		v_and_b32_e32 v8, 1, v8
		v_mul_lo_u32 v8, s12, v8
		v_lshlrev_b32_e32 v8, 4, v8
		v_add3_u32 v7, s47, v7, v8
		v_lshrrev_b32_e32 v8, 5, v0
		v_and_b32_e32 v8, 1, v8
		v_mul_lo_u32 v8, s12, v8
		v_lshlrev_b32_e32 v8, 3, v8
		v_lshrrev_b32_e32 v9, 4, v0
		v_and_b32_e32 v9, 1, v9
		v_mul_lo_u32 v9, s12, v9
		v_lshlrev_b32_e32 v9, 2, v9
		v_add3_u32 v7, v7, v8, v9
		v_and_b32_e32 v8, 1, v0
		v_lshlrev_b32_e32 v8, 4, v8
		v_lshrrev_b32_e32 v9, 3, v0
		v_and_b32_e32 v9, 1, v9
		v_mul_lo_u32 v9, s12, v9
		v_lshlrev_b32_e32 v9, 1, v9
		v_add3_u32 v7, v7, v9, v8
		v_lshrrev_b32_e32 v9, 2, v0
		v_and_b32_e32 v9, 1, v9
		v_lshlrev_b32_e32 v9, 6, v9
		v_lshrrev_b32_e32 v11, 1, v0
		v_and_b32_e32 v11, 1, v11
		v_lshlrev_b32_e32 v11, 5, v11
		v_add3_u32 v7, v7, v9, v11
		v_mov_b32_e32 v12, 0x80000000
		v_cndmask_b32_e64 v7, v12, v7, s[52:53]
		buffer_load_dwordx4 v[16:19], v7, s[36:39], 0 offen
		v_lshrrev_b32_e32 v7, 3, v0
		v_and_b32_e32 v7, 1, v7
		v_lshrrev_b32_e32 v13, 4, v0
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v15, 2
		v_mul_lo_u32 v15, v15, v13
		v_bitop3_b32 v7, 32, v7, v15 bitop3:0x96
		v_lshrrev_b32_e32 v13, 5, v0
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v15, 4
		v_mul_lo_u32 v15, v15, v13
		v_xor_b32_e32 v7, v7, v15
		v_lshrrev_b32_e32 v13, 6, v0
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v15, 8
		v_mul_lo_u32 v15, v15, v13
		v_lshrrev_b32_e32 v13, 7, v0
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v20, 16
		v_mul_lo_u32 v20, v20, v13
		v_bitop3_b32 v7, v7, v15, v20 bitop3:0x96
		v_add_u32_e32 v7, s46, v7
		v_cmp_lt_i32_e64 vcc, v7, s22
		s_mov_b64 s[52:53], vcc
		v_lshrrev_b32_e32 v7, 7, v0
		v_lshlrev_b32_e32 v7, 4, v7
		v_lshrrev_b32_e32 v13, 6, v0
		v_and_b32_e32 v13, 1, v13
		v_lshlrev_b32_e32 v13, 3, v13
		v_lshrrev_b32_e32 v15, 5, v0
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 2, v15
		v_lshrrev_b32_e32 v20, 3, v0
		v_and_b32_e32 v20, 1, v20
		v_add_u32_e32 v20, 32, v20
		v_lshrrev_b32_e32 v21, 4, v0
		v_and_b32_e32 v21, 1, v21
		v_lshlrev_b32_e32 v21, 1, v21
		v_bitop3_b32 v15, v15, v20, v21 bitop3:0x96
		v_bitop3_b32 v7, v7, v13, v15 bitop3:0x96
		v_mul_lo_u32 v7, s12, v7
		v_lshlrev_b32_e32 v7, 1, v7
		v_add3_u32 v7, s47, v7, v8
		v_add3_u32 v7, v7, v9, v11
		v_cndmask_b32_e64 v7, v12, v7, s[52:53]
		buffer_load_dwordx4 v[28:31], v7, s[36:39], 0 offen
		v_lshrrev_b32_e32 v7, 3, v0
		v_and_b32_e32 v7, 1, v7
		v_lshrrev_b32_e32 v13, 4, v0
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v15, 2
		v_mul_lo_u32 v15, v15, v13
		v_bitop3_b32 v7, 64, v7, v15 bitop3:0x96
		v_lshrrev_b32_e32 v13, 5, v0
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v15, 4
		v_mul_lo_u32 v15, v15, v13
		v_xor_b32_e32 v7, v7, v15
		v_lshrrev_b32_e32 v13, 6, v0
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v15, 8
		v_mul_lo_u32 v15, v15, v13
		v_lshrrev_b32_e32 v13, 7, v0
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v20, 16
		v_mul_lo_u32 v20, v20, v13
		v_bitop3_b32 v7, v7, v15, v20 bitop3:0x96
		v_add_u32_e32 v7, s46, v7
		v_cmp_lt_i32_e64 vcc, v7, s22
		s_mov_b64 s[52:53], vcc
		v_add3_u32 v7, v8, v9, v11
		v_lshrrev_b32_e32 v13, 7, v0
		v_lshlrev_b32_e32 v13, 4, v13
		v_lshrrev_b32_e32 v15, 6, v0
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 3, v15
		v_lshrrev_b32_e32 v20, 5, v0
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v20, 2, v20
		v_lshrrev_b32_e32 v21, 3, v0
		v_and_b32_e32 v21, 1, v21
		v_add_u32_e32 v21, 64, v21
		v_lshrrev_b32_e32 v22, 4, v0
		v_and_b32_e32 v22, 1, v22
		v_lshlrev_b32_e32 v22, 1, v22
		v_bitop3_b32 v20, v20, v21, v22 bitop3:0x96
		v_bitop3_b32 v13, v13, v15, v20 bitop3:0x96
		v_mul_lo_u32 v13, s12, v13
		v_lshlrev_b32_e32 v13, 1, v13
		v_add3_u32 v13, v13, v7, s47
		v_cndmask_b32_e64 v13, v12, v13, s[52:53]
		buffer_load_dwordx4 v[32:35], v13, s[36:39], 0 offen
		v_lshrrev_b32_e32 v13, 3, v0
		v_and_b32_e32 v13, 1, v13
		v_xor_b32_e32 v13, 0x60, v13
		v_lshrrev_b32_e32 v15, 4, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v20, 2
		v_mul_lo_u32 v20, v20, v15
		v_xor_b32_e32 v13, v13, v20
		v_lshrrev_b32_e32 v15, 5, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v20, 4
		v_mul_lo_u32 v20, v20, v15
		v_xor_b32_e32 v13, v13, v20
		v_lshrrev_b32_e32 v15, 6, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v20, 8
		v_mul_lo_u32 v20, v20, v15
		v_lshrrev_b32_e32 v15, 7, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v21, 16
		v_mul_lo_u32 v21, v21, v15
		v_bitop3_b32 v13, v13, v20, v21 bitop3:0x96
		v_add_u32_e32 v13, s46, v13
		v_cmp_lt_i32_e64 vcc, v13, s22
		s_mov_b64 s[52:53], vcc
		v_lshrrev_b32_e32 v13, 7, v0
		v_lshlrev_b32_e32 v13, 4, v13
		v_lshrrev_b32_e32 v15, 6, v0
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 3, v15
		v_lshrrev_b32_e32 v20, 5, v0
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v20, 2, v20
		v_lshrrev_b32_e32 v21, 3, v0
		v_and_b32_e32 v21, 1, v21
		v_add_u32_e32 v21, 0x60, v21
		v_lshrrev_b32_e32 v22, 4, v0
		v_and_b32_e32 v22, 1, v22
		v_lshlrev_b32_e32 v22, 1, v22
		v_bitop3_b32 v20, v20, v21, v22 bitop3:0x96
		v_bitop3_b32 v13, v13, v15, v20 bitop3:0x96
		v_mul_lo_u32 v13, s12, v13
		v_lshlrev_b32_e32 v13, 1, v13
		v_add3_u32 v13, v13, v7, s47
		v_cndmask_b32_e64 v13, v12, v13, s[52:53]
		buffer_load_dwordx4 v[36:39], v13, s[36:39], 0 offen
		v_lshrrev_b32_e32 v13, 3, v0
		v_and_b32_e32 v13, 1, v13
		v_xor_b32_e32 v13, 0x80, v13
		v_lshrrev_b32_e32 v15, 4, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v20, 2
		v_mul_lo_u32 v20, v20, v15
		v_xor_b32_e32 v13, v13, v20
		v_lshrrev_b32_e32 v15, 5, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v20, 4
		v_mul_lo_u32 v20, v20, v15
		v_xor_b32_e32 v13, v13, v20
		v_lshrrev_b32_e32 v15, 6, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v20, 8
		v_mul_lo_u32 v20, v20, v15
		v_lshrrev_b32_e32 v15, 7, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v21, 16
		v_mul_lo_u32 v21, v21, v15
		v_bitop3_b32 v13, v13, v20, v21 bitop3:0x96
		v_add_u32_e32 v13, s46, v13
		v_cmp_lt_i32_e64 vcc, v13, s22
		s_mov_b64 s[52:53], vcc
		v_lshrrev_b32_e32 v13, 7, v0
		v_lshlrev_b32_e32 v13, 4, v13
		v_lshrrev_b32_e32 v15, 6, v0
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 3, v15
		v_lshrrev_b32_e32 v20, 5, v0
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v20, 2, v20
		v_lshrrev_b32_e32 v21, 3, v0
		v_and_b32_e32 v21, 1, v21
		v_add_u32_e32 v21, 0x80, v21
		v_lshrrev_b32_e32 v22, 4, v0
		v_and_b32_e32 v22, 1, v22
		v_lshlrev_b32_e32 v22, 1, v22
		v_bitop3_b32 v20, v20, v21, v22 bitop3:0x96
		v_bitop3_b32 v13, v13, v15, v20 bitop3:0x96
		v_mul_lo_u32 v13, s12, v13
		v_lshlrev_b32_e32 v13, 1, v13
		v_add3_u32 v7, v13, v7, s47
		v_cndmask_b32_e64 v7, v12, v7, s[52:53]
		buffer_load_dwordx4 v[40:43], v7, s[36:39], 0 offen
		v_lshrrev_b32_e32 v7, 3, v0
		v_and_b32_e32 v7, 1, v7
		v_xor_b32_e32 v7, 0xa0, v7
		v_lshrrev_b32_e32 v13, 4, v0
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v15, 2
		v_mul_lo_u32 v15, v15, v13
		v_xor_b32_e32 v7, v7, v15
		v_lshrrev_b32_e32 v13, 5, v0
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v15, 4
		v_mul_lo_u32 v15, v15, v13
		v_xor_b32_e32 v7, v7, v15
		v_lshrrev_b32_e32 v13, 6, v0
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v15, 8
		v_mul_lo_u32 v15, v15, v13
		v_lshrrev_b32_e32 v13, 7, v0
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v20, 16
		v_mul_lo_u32 v20, v20, v13
		v_bitop3_b32 v7, v7, v15, v20 bitop3:0x96
		v_add_u32_e32 v7, s46, v7
		v_cmp_lt_i32_e64 vcc, v7, s22
		s_mov_b64 s[52:53], vcc
		v_add3_u32 v7, v8, v9, v11
		v_lshrrev_b32_e32 v8, 7, v0
		v_lshlrev_b32_e32 v8, 4, v8
		v_lshrrev_b32_e32 v9, 6, v0
		v_and_b32_e32 v9, 1, v9
		v_lshlrev_b32_e32 v9, 3, v9
		v_lshrrev_b32_e32 v11, 5, v0
		v_and_b32_e32 v11, 1, v11
		v_lshlrev_b32_e32 v11, 2, v11
		v_lshrrev_b32_e32 v13, 3, v0
		v_and_b32_e32 v13, 1, v13
		v_add_u32_e32 v13, 0xa0, v13
		v_lshrrev_b32_e32 v15, 4, v0
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 1, v15
		v_bitop3_b32 v11, v11, v13, v15 bitop3:0x96
		v_bitop3_b32 v8, v8, v9, v11 bitop3:0x96
		v_mul_lo_u32 v8, s12, v8
		v_lshlrev_b32_e32 v8, 1, v8
		v_add3_u32 v8, v8, v7, s47
		v_cndmask_b32_e64 v8, v12, v8, s[52:53]
		buffer_load_dwordx4 v[44:47], v8, s[36:39], 0 offen
		v_lshrrev_b32_e32 v8, 3, v0
		v_and_b32_e32 v8, 1, v8
		v_xor_b32_e32 v8, 0xc0, v8
		v_lshrrev_b32_e32 v9, 4, v0
		v_and_b32_e32 v9, 1, v9
		v_mov_b32_e32 v11, 2
		v_mul_lo_u32 v11, v11, v9
		v_xor_b32_e32 v8, v8, v11
		v_lshrrev_b32_e32 v9, 5, v0
		v_and_b32_e32 v9, 1, v9
		v_mov_b32_e32 v11, 4
		v_mul_lo_u32 v11, v11, v9
		v_xor_b32_e32 v8, v8, v11
		v_lshrrev_b32_e32 v9, 6, v0
		v_and_b32_e32 v9, 1, v9
		v_mov_b32_e32 v11, 8
		v_mul_lo_u32 v11, v11, v9
		v_lshrrev_b32_e32 v9, 7, v0
		v_and_b32_e32 v9, 1, v9
		v_mov_b32_e32 v13, 16
		v_mul_lo_u32 v13, v13, v9
		v_bitop3_b32 v8, v8, v11, v13 bitop3:0x96
		v_add_u32_e32 v8, s46, v8
		v_cmp_lt_i32_e64 vcc, v8, s22
		s_mov_b64 s[52:53], vcc
		v_lshrrev_b32_e32 v8, 7, v0
		v_lshlrev_b32_e32 v8, 4, v8
		v_lshrrev_b32_e32 v9, 6, v0
		v_and_b32_e32 v9, 1, v9
		v_lshlrev_b32_e32 v9, 3, v9
		v_lshrrev_b32_e32 v11, 5, v0
		v_and_b32_e32 v11, 1, v11
		v_lshlrev_b32_e32 v11, 2, v11
		v_lshrrev_b32_e32 v13, 3, v0
		v_and_b32_e32 v13, 1, v13
		v_add_u32_e32 v13, 0xc0, v13
		v_lshrrev_b32_e32 v15, 4, v0
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 1, v15
		v_bitop3_b32 v11, v11, v13, v15 bitop3:0x96
		v_bitop3_b32 v8, v8, v9, v11 bitop3:0x96
		v_mul_lo_u32 v8, s12, v8
		v_lshlrev_b32_e32 v8, 1, v8
		v_add3_u32 v8, v8, v7, s47
		v_cndmask_b32_e64 v8, v12, v8, s[52:53]
		buffer_load_dwordx4 v[80:83], v8, s[36:39], 0 offen
		v_lshrrev_b32_e32 v8, 3, v0
		v_and_b32_e32 v8, 1, v8
		v_xor_b32_e32 v8, 0xe0, v8
		v_lshrrev_b32_e32 v9, 4, v0
		v_and_b32_e32 v9, 1, v9
		v_mov_b32_e32 v11, 2
		v_mul_lo_u32 v11, v11, v9
		v_xor_b32_e32 v8, v8, v11
		v_lshrrev_b32_e32 v9, 5, v0
		v_and_b32_e32 v9, 1, v9
		v_mov_b32_e32 v11, 4
		v_mul_lo_u32 v11, v11, v9
		v_xor_b32_e32 v8, v8, v11
		v_lshrrev_b32_e32 v9, 6, v0
		v_and_b32_e32 v9, 1, v9
		v_mov_b32_e32 v11, 8
		v_mul_lo_u32 v11, v11, v9
		v_lshrrev_b32_e32 v9, 7, v0
		v_and_b32_e32 v9, 1, v9
		v_mov_b32_e32 v13, 16
		v_mul_lo_u32 v13, v13, v9
		v_bitop3_b32 v8, v8, v11, v13 bitop3:0x96
		v_add_u32_e32 v8, s46, v8
		v_cmp_lt_i32_e64 vcc, v8, s22
		v_lshrrev_b32_e32 v8, 7, v0
		v_lshlrev_b32_e32 v8, 4, v8
		v_lshrrev_b32_e32 v9, 6, v0
		v_and_b32_e32 v9, 1, v9
		v_lshlrev_b32_e32 v9, 3, v9
		v_lshrrev_b32_e32 v11, 5, v0
		v_and_b32_e32 v11, 1, v11
		v_lshlrev_b32_e32 v11, 2, v11
		v_lshrrev_b32_e32 v13, 3, v0
		v_and_b32_e32 v13, 1, v13
		v_add_u32_e32 v13, 0xe0, v13
		v_lshrrev_b32_e32 v15, 4, v0
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 1, v15
		v_bitop3_b32 v11, v11, v13, v15 bitop3:0x96
		v_bitop3_b32 v8, v8, v9, v11 bitop3:0x96
		v_mul_lo_u32 v8, s12, v8
		v_lshlrev_b32_e32 v8, 1, v8
		v_add3_u32 v7, v8, v7, s47
		v_accvgpr_read_b32 v8, a42
		v_rcp_f32_e32 v20, v8
		v_cndmask_b32_e32 v7, v12, v7, vcc
		buffer_load_dwordx4 v[84:87], v7, s[36:39], 0 offen
		s_waitcnt vmcnt(8)
		s_barrier
		v_lshrrev_b32_e32 v7, 6, v0
		v_and_b32_e32 v7, 1, v7
		v_lshlrev_b32_e32 v7, 2, v7
		v_lshrrev_b32_e32 v8, 5, v0
		v_and_b32_e32 v8, 1, v8
		v_lshlrev_b32_e32 v8, 1, v8
		v_lshrrev_b32_e32 v9, 4, v0
		v_and_b32_e32 v9, 1, v9
		v_xor_b32_e32 v9, v0, v9
		v_bitop3_b32 v7, v7, v8, v9 bitop3:0x96
		v_lshlrev_b32_e32 v7, 4, v7
		v_add_u32_e32 v7, 0x10000, v7
		s_waitcnt vmcnt(7)
		ds_write_b128 v7, v[16:19] offset:18864
		s_waitcnt vmcnt(6)
		ds_write_b128 v7, v[28:31] offset:22960
		s_waitcnt vmcnt(5)
		ds_write_b128 v7, v[32:35] offset:27056
		s_waitcnt vmcnt(4)
		ds_write_b128 v7, v[36:39] offset:31152
		v_mov_b32_e32 v21, v20
		v_pk_mul_f32 v[8:9], v[48:49], v[20:21]
		v_pk_mul_f32 v[16:17], v[50:51], v[20:21]
		v_pk_mul_f32 v[18:19], v[52:53], v[20:21]
		v_pk_mul_f32 v[24:25], v[54:55], v[20:21]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_pk_mul_f32 v[28:29], v[56:57], v[20:21]
		v_pk_mul_f32 v[30:31], v[58:59], v[20:21]
		v_pk_mul_f32 v[32:33], v[60:61], v[20:21]
		v_pk_mul_f32 v[34:35], v[62:63], v[20:21]
		v_pk_mul_f32 v[36:37], v[64:65], v[20:21]
		v_pk_mul_f32 v[38:39], v[66:67], v[20:21]
		v_pk_mul_f32 v[48:49], v[68:69], v[20:21]
		v_pk_mul_f32 v[50:51], v[70:71], v[20:21]
		v_pk_mul_f32 v[52:53], v[72:73], v[20:21]
		v_pk_mul_f32 v[54:55], v[74:75], v[20:21]
		v_pk_mul_f32 v[56:57], v[76:77], v[20:21]
		v_pk_mul_f32 v[58:59], v[78:79], v[20:21]
		v_accvgpr_read_b32 v11, a43
		v_rcp_f32_e32 v20, v11
		v_cvt_pk_bf16_f32 v60, v8, v9
		v_mov_b32_e32 v21, v20
		v_accvgpr_read_b32 v8, a48
		v_accvgpr_read_b32 v9, a49
		v_pk_mul_f32 v[64:65], v[8:9], v[20:21]
		v_accvgpr_read_b32 v8, a50
		v_accvgpr_read_b32 v9, a51
		v_pk_mul_f32 v[66:67], v[8:9], v[20:21]
		v_accvgpr_read_b32 v8, a52
		v_accvgpr_read_b32 v9, a53
		v_pk_mul_f32 v[68:69], v[8:9], v[20:21]
		v_accvgpr_read_b32 v8, a54
		v_accvgpr_read_b32 v9, a55
		v_pk_mul_f32 v[70:71], v[8:9], v[20:21]
		v_accvgpr_read_b32 v8, a56
		v_accvgpr_read_b32 v9, a57
		v_pk_mul_f32 v[72:73], v[8:9], v[20:21]
		v_accvgpr_read_b32 v8, a58
		v_accvgpr_read_b32 v9, a59
		v_pk_mul_f32 v[74:75], v[8:9], v[20:21]
		v_accvgpr_read_b32 v8, a60
		v_accvgpr_read_b32 v9, a61
		v_pk_mul_f32 v[76:77], v[8:9], v[20:21]
		v_accvgpr_read_b32 v8, a62
		v_accvgpr_read_b32 v9, a63
		v_pk_mul_f32 v[78:79], v[8:9], v[20:21]
		v_accvgpr_read_b32 v8, a64
		v_accvgpr_read_b32 v9, a65
		v_pk_mul_f32 v[88:89], v[8:9], v[20:21]
		v_accvgpr_read_b32 v8, a66
		v_accvgpr_read_b32 v9, a67
		v_pk_mul_f32 v[90:91], v[8:9], v[20:21]
		v_accvgpr_read_b32 v8, a68
		v_accvgpr_read_b32 v9, a69
		v_pk_mul_f32 v[92:93], v[8:9], v[20:21]
		v_accvgpr_read_b32 v8, a70
		v_accvgpr_read_b32 v9, a71
		v_pk_mul_f32 v[94:95], v[8:9], v[20:21]
		v_accvgpr_read_b32 v8, a72
		v_accvgpr_read_b32 v9, a73
		v_pk_mul_f32 v[96:97], v[8:9], v[20:21]
		v_accvgpr_read_b32 v8, a74
		v_accvgpr_read_b32 v9, a75
		v_pk_mul_f32 v[98:99], v[8:9], v[20:21]
		v_accvgpr_read_b32 v8, a76
		v_accvgpr_read_b32 v9, a77
		v_pk_mul_f32 v[100:101], v[8:9], v[20:21]
		v_accvgpr_read_b32 v8, a78
		v_accvgpr_read_b32 v9, a79
		v_pk_mul_f32 v[102:103], v[8:9], v[20:21]
		v_cvt_pk_bf16_f32 v61, v16, v17
		v_cvt_pk_bf16_f32 v62, v18, v19
		v_cvt_pk_bf16_f32 v63, v24, v25
		v_cvt_pk_bf16_f32 v16, v28, v29
		v_cvt_pk_bf16_f32 v17, v30, v31
		v_cvt_pk_bf16_f32 v18, v32, v33
		v_cvt_pk_bf16_f32 v19, v34, v35
		v_cvt_pk_bf16_f32 v28, v36, v37
		v_cvt_pk_bf16_f32 v29, v38, v39
		v_cvt_pk_bf16_f32 v30, v48, v49
		v_cvt_pk_bf16_f32 v31, v50, v51
		v_cvt_pk_bf16_f32 v32, v52, v53
		v_cvt_pk_bf16_f32 v33, v54, v55
		v_cvt_pk_bf16_f32 v34, v56, v57
		v_cvt_pk_bf16_f32 v35, v58, v59
		v_cvt_pk_bf16_f32 v36, v64, v65
		v_cvt_pk_bf16_f32 v37, v66, v67
		v_cvt_pk_bf16_f32 v38, v68, v69
		v_cvt_pk_bf16_f32 v39, v70, v71
		v_cvt_pk_bf16_f32 v48, v72, v73
		v_cvt_pk_bf16_f32 v49, v74, v75
		v_cvt_pk_bf16_f32 v50, v76, v77
		v_cvt_pk_bf16_f32 v51, v78, v79
		v_cvt_pk_bf16_f32 v52, v88, v89
		v_cvt_pk_bf16_f32 v53, v90, v91
		v_cvt_pk_bf16_f32 v54, v92, v93
		v_cvt_pk_bf16_f32 v55, v94, v95
		v_cvt_pk_bf16_f32 v56, v96, v97
		v_cvt_pk_bf16_f32 v57, v98, v99
		v_cvt_pk_bf16_f32 v58, v100, v101
		v_cvt_pk_bf16_f32 v59, v102, v103
		v_permlane32_swap_b32_e32 v60, v62
		v_permlane32_swap_b32_e32 v61, v63
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_permlane32_swap_b32_e32 v32, v34
		v_permlane32_swap_b32_e32 v33, v35
		v_permlane32_swap_b32_e32 v36, v38
		v_permlane32_swap_b32_e32 v37, v39
		v_permlane32_swap_b32_e32 v48, v50
		v_permlane32_swap_b32_e32 v49, v51
		v_permlane32_swap_b32_e32 v52, v54
		v_permlane32_swap_b32_e32 v53, v55
		v_permlane32_swap_b32_e32 v56, v58
		v_permlane32_swap_b32_e32 v57, v59
		v_readfirstlane_b32 s36, v1
		v_lshrrev_b32_e32 v8, 7, v0
		s_nop 0
		v_mul_lo_u32 v9, s36, v8
		v_lshlrev_b32_e32 v9, 7, v9
		v_readfirstlane_b32 s36, v1
		v_and_b32_e32 v11, 1, v0
		s_nop 0
		v_mul_lo_u32 v13, s36, v11
		v_lshlrev_b32_e32 v13, 1, v13
		v_add3_u32 v15, s26, v9, v13
		v_readfirstlane_b32 s36, v1
		v_lshrrev_b32_e32 v20, 6, v0
		v_and_b32_e32 v20, 1, v20
		v_mul_lo_u32 v21, s36, v20
		v_lshlrev_b32_e32 v21, 6, v21
		v_readfirstlane_b32 s36, v1
		v_lshrrev_b32_e32 v22, 4, v0
		v_and_b32_e32 v22, 1, v22
		v_mul_lo_u32 v24, s36, v22
		v_lshlrev_b32_e32 v24, 5, v24
		v_add3_u32 v15, v15, v21, v24
		v_readfirstlane_b32 s36, v1
		v_lshrrev_b32_e32 v25, 3, v0
		v_and_b32_e32 v25, 1, v25
		v_mul_lo_u32 v64, s36, v25
		v_lshlrev_b32_e32 v64, 4, v64
		v_readfirstlane_b32 s36, v1
		v_lshrrev_b32_e32 v65, 2, v0
		v_and_b32_e32 v65, 1, v65
		v_mul_lo_u32 v66, s36, v65
		v_lshlrev_b32_e32 v66, 3, v66
		v_add3_u32 v15, v15, v64, v66
		v_readfirstlane_b32 s36, v1
		v_lshrrev_b32_e32 v67, 1, v0
		v_and_b32_e32 v67, 1, v67
		v_mul_lo_u32 v68, s36, v67
		v_lshlrev_b32_e32 v68, 2, v68
		v_lshrrev_b32_e32 v69, 5, v0
		v_and_b32_e32 v69, 1, v69
		v_lshlrev_b32_e32 v69, 4, v69
		v_add3_u32 v15, v15, v68, v69
		v_readfirstlane_b32 s36, v26
		v_readfirstlane_b32 s37, v27
		s_nop 1
		v_cndmask_b32_e64 v15, v12, v15, s[36:37]
		s_mov_b32 s36, s8
		s_mov_b32 s37, s9
		s_mov_b32 s38, s30
		s_mov_b32 s39, s31
		buffer_store_dwordx4 v[60:63], v15, s[36:39], 0 offen
		v_add3_u32 v15, s43, v9, v13
		v_add3_u32 v15, v15, v21, v24
		v_add3_u32 v15, v15, v64, v66
		v_add3_u32 v15, v15, v68, v69
		v_readfirstlane_b32 s52, v26
		v_readfirstlane_b32 s53, v27
		s_nop 1
		v_cndmask_b32_e64 v15, v12, v15, s[52:53]
		buffer_store_dwordx4 v[16:19], v15, s[36:39], 0 offen
		v_add3_u32 v15, s44, v9, v13
		v_add3_u32 v15, v15, v21, v24
		v_add3_u32 v15, v15, v64, v66
		v_add3_u32 v15, v15, v68, v69
		v_readfirstlane_b32 s52, v26
		v_readfirstlane_b32 s53, v27
		s_nop 1
		v_cndmask_b32_e64 v15, v12, v15, s[52:53]
		buffer_store_dwordx4 v[28:31], v15, s[36:39], 0 offen
		v_add3_u32 v15, s21, v9, v13
		v_add3_u32 v15, v15, v21, v24
		v_add3_u32 v15, v15, v64, v66
		v_add3_u32 v15, v15, v68, v69
		v_readfirstlane_b32 s52, v26
		v_readfirstlane_b32 s53, v27
		s_nop 1
		v_cndmask_b32_e64 v15, v12, v15, s[52:53]
		buffer_store_dwordx4 v[32:35], v15, s[36:39], 0 offen
		v_lshlrev_b32_e32 v8, 6, v8
		v_lshlrev_b32_e32 v15, 5, v20
		v_lshlrev_b32_e32 v16, 4, v22
		v_lshlrev_b32_e32 v17, 3, v25
		v_lshlrev_b32_e32 v18, 2, v65
		v_add_u32_e32 v11, 0x80, v11
		v_lshlrev_b32_e32 v19, 1, v67
		v_bitop3_b32 v11, v18, v11, v19 bitop3:0x96
		v_bitop3_b32 v11, v16, v17, v11 bitop3:0x96
		v_bitop3_b32 v8, v8, v15, v11 bitop3:0x96
		v_readfirstlane_b32 s47, v1
		s_nop 1
		v_mul_lo_u32 v8, s47, v8
		v_lshlrev_b32_e32 v8, 1, v8
		v_add3_u32 v11, s26, v8, v69
		v_accvgpr_read_b32 v15, a0
		s_nop 0
		v_readfirstlane_b32 s52, v15
		v_accvgpr_read_b32 v15, a1
		s_nop 0
		v_readfirstlane_b32 s53, v15
		s_nop 1
		v_cndmask_b32_e64 v11, v12, v11, s[52:53]
		buffer_store_dwordx4 v[36:39], v11, s[36:39], 0 offen
		v_add3_u32 v11, s43, v8, v69
		v_accvgpr_read_b32 v15, a0
		s_nop 0
		v_readfirstlane_b32 s52, v15
		v_accvgpr_read_b32 v15, a1
		s_nop 0
		v_readfirstlane_b32 s53, v15
		s_nop 1
		v_cndmask_b32_e64 v11, v12, v11, s[52:53]
		buffer_store_dwordx4 v[48:51], v11, s[36:39], 0 offen
		v_add3_u32 v11, s44, v8, v69
		v_accvgpr_read_b32 v15, a0
		s_nop 0
		v_readfirstlane_b32 s52, v15
		v_accvgpr_read_b32 v15, a1
		s_nop 0
		v_readfirstlane_b32 s53, v15
		s_nop 1
		v_cndmask_b32_e64 v11, v12, v11, s[52:53]
		buffer_store_dwordx4 v[52:55], v11, s[36:39], 0 offen
		v_add3_u32 v11, s21, v8, v69
		v_accvgpr_read_b32 v15, a0
		s_nop 0
		v_readfirstlane_b32 s52, v15
		v_accvgpr_read_b32 v15, a1
		s_nop 0
		v_readfirstlane_b32 s53, v15
		s_nop 1
		v_cndmask_b32_e64 v11, v12, v11, s[52:53]
		buffer_store_dwordx4 v[56:59], v11, s[36:39], 0 offen
		v_lshrrev_b32_e32 v11, 6, v0
		v_and_b32_e32 v11, 1, v11
		v_lshlrev_b32_e32 v11, 3, v11
		v_add_u32_e32 v11, 32, v11
		v_lshrrev_b32_e32 v15, 7, v0
		v_lshlrev_b32_e32 v15, 4, v15
		v_xor_b32_e32 v11, v11, v15
		v_lshrrev_b32_e32 v11, 5, v11
		v_and_b32_e32 v11, 1, v11
		v_lshlrev_b32_e32 v11, 14, v11
		v_add_u32_e32 v11, 0x10000, v11
		v_and_b32_e32 v15, 63, v0
		v_lshrrev_b32_e32 v16, 2, v15
		v_and_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v16, 5, v16
		v_lshrrev_b32_e32 v17, 1, v15
		v_and_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v17, 4, v17
		v_and_b32_e32 v18, 1, v15
		v_lshlrev_b32_e32 v18, 3, v18
		v_add3_u32 v16, v16, v17, v18
		v_lshrrev_b32_e32 v17, 5, v15
		v_xor_b32_e32 v16, v16, v17
		v_lshrrev_b32_e32 v17, 6, v16
		v_lshrrev_b32_e32 v18, 3, v15
		v_and_b32_e32 v18, 1, v18
		v_add_u32_e32 v17, v17, v18
		v_and_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v17, 2, v17
		v_lshrrev_b32_e32 v19, 5, v16
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 1, v19
		v_lshrrev_b32_e32 v15, 4, v15
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v18, 6, v18
		v_lshl_add_u32 v15, v15, 7, v18
		v_add_u32_e32 v15, v15, v16
		v_lshrrev_b32_e32 v16, 4, v16
		v_bitop3_b32 v15, v15, v16, 1 bitop3:0x78
		v_bitop3_b32 v15, v17, v19, v15 bitop3:0x96
		v_lshrrev_b32_e32 v16, 6, v0
		v_lshlrev_b32_e32 v16, 12, v16
		v_add_u32_e32 v16, 0x10000, v16
		v_lshl_add_u32 v15, v15, 4, v16
		ds_read_b128 a[4:7], v15 offset:18864
		v_and_b32_e32 v15, 63, v0
		v_lshrrev_b32_e32 v16, 2, v15
		v_and_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v16, 5, v16
		v_add_u32_e32 v16, 2, v16
		v_lshrrev_b32_e32 v17, 1, v15
		v_and_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v17, 4, v17
		v_and_b32_e32 v18, 1, v15
		v_lshlrev_b32_e32 v18, 3, v18
		v_add3_u32 v16, v16, v17, v18
		v_lshrrev_b32_e32 v17, 5, v15
		v_xor_b32_e32 v16, v16, v17
		v_lshrrev_b32_e32 v17, 6, v16
		v_lshrrev_b32_e32 v18, 3, v15
		v_and_b32_e32 v18, 1, v18
		v_add_u32_e32 v17, v17, v18
		v_and_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v17, 2, v17
		v_lshrrev_b32_e32 v19, 5, v16
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 1, v19
		v_lshrrev_b32_e32 v15, 4, v15
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v18, 6, v18
		v_lshl_add_u32 v15, v15, 7, v18
		v_add_u32_e32 v15, v15, v16
		v_lshrrev_b32_e32 v16, 4, v16
		v_bitop3_b32 v15, v15, v16, 1 bitop3:0x78
		v_bitop3_b32 v15, v17, v19, v15 bitop3:0x96
		v_lshrrev_b32_e32 v16, 6, v0
		v_lshlrev_b32_e32 v16, 12, v16
		v_add_u32_e32 v16, 0x10000, v16
		v_lshl_add_u32 v15, v15, 4, v16
		ds_read_b128 a[8:11], v15 offset:18864
		v_and_b32_e32 v15, 63, v0
		v_lshrrev_b32_e32 v16, 2, v15
		v_and_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v16, 5, v16
		v_add_u32_e32 v16, 4, v16
		v_lshrrev_b32_e32 v17, 1, v15
		v_and_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v17, 4, v17
		v_and_b32_e32 v18, 1, v15
		v_lshlrev_b32_e32 v18, 3, v18
		v_add3_u32 v16, v16, v17, v18
		v_lshrrev_b32_e32 v17, 5, v15
		v_xor_b32_e32 v16, v16, v17
		v_lshrrev_b32_e32 v17, 6, v16
		v_lshrrev_b32_e32 v18, 3, v15
		v_and_b32_e32 v18, 1, v18
		v_add_u32_e32 v17, v17, v18
		v_and_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v17, 2, v17
		v_lshrrev_b32_e32 v19, 5, v16
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 1, v19
		v_lshrrev_b32_e32 v15, 4, v15
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v18, 6, v18
		v_lshl_add_u32 v15, v15, 7, v18
		v_add_u32_e32 v15, v15, v16
		v_lshrrev_b32_e32 v16, 4, v16
		v_bitop3_b32 v15, v15, v16, 1 bitop3:0x78
		v_bitop3_b32 v15, v17, v19, v15 bitop3:0x96
		v_lshrrev_b32_e32 v16, 6, v0
		v_lshlrev_b32_e32 v16, 12, v16
		v_add_u32_e32 v16, 0x10000, v16
		v_lshl_add_u32 v15, v15, 4, v16
		ds_read_b128 a[12:15], v15 offset:18864
		v_and_b32_e32 v15, 63, v0
		v_lshrrev_b32_e32 v16, 2, v15
		v_and_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v16, 5, v16
		v_add_u32_e32 v16, 6, v16
		v_lshrrev_b32_e32 v17, 1, v15
		v_and_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v17, 4, v17
		v_and_b32_e32 v18, 1, v15
		v_lshlrev_b32_e32 v18, 3, v18
		v_add3_u32 v16, v16, v17, v18
		v_lshrrev_b32_e32 v17, 5, v15
		v_xor_b32_e32 v16, v16, v17
		v_lshrrev_b32_e32 v17, 6, v16
		v_lshrrev_b32_e32 v18, 3, v15
		v_and_b32_e32 v18, 1, v18
		v_add_u32_e32 v17, v17, v18
		v_and_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v17, 2, v17
		v_lshrrev_b32_e32 v19, 5, v16
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 1, v19
		v_lshrrev_b32_e32 v15, 4, v15
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v18, 6, v18
		v_lshl_add_u32 v15, v15, 7, v18
		v_add_u32_e32 v15, v15, v16
		v_lshrrev_b32_e32 v16, 4, v16
		v_bitop3_b32 v15, v15, v16, 1 bitop3:0x78
		v_bitop3_b32 v15, v17, v19, v15 bitop3:0x96
		v_lshrrev_b32_e32 v16, 6, v0
		v_lshlrev_b32_e32 v16, 12, v16
		v_add_u32_e32 v16, 0x10000, v16
		v_lshl_add_u32 v15, v15, 4, v16
		ds_read_b128 a[16:19], v15 offset:18864
		v_lshrrev_b32_e32 v15, 6, v0
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 3, v15
		v_add_u32_e32 v15, 32, v15
		v_lshrrev_b32_e32 v16, 7, v0
		v_lshlrev_b32_e32 v16, 4, v16
		v_xor_b32_e32 v15, v15, v16
		v_lshrrev_b32_e32 v15, 4, v15
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 13, v15
		v_lshrrev_b32_e32 v16, 6, v0
		v_and_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v16, 3, v16
		v_add_u32_e32 v16, 32, v16
		v_lshrrev_b32_e32 v17, 7, v0
		v_lshlrev_b32_e32 v17, 4, v17
		v_xor_b32_e32 v16, v16, v17
		v_lshrrev_b32_e32 v16, 3, v16
		v_and_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v16, 12, v16
		v_add3_u32 v11, v11, v15, v16
		v_and_b32_e32 v15, 63, v0
		v_lshrrev_b32_e32 v16, 2, v15
		v_and_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v16, 5, v16
		v_lshrrev_b32_e32 v17, 1, v15
		v_and_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v17, 4, v17
		v_and_b32_e32 v18, 1, v15
		v_lshlrev_b32_e32 v18, 3, v18
		v_add3_u32 v16, v16, v17, v18
		v_lshrrev_b32_e32 v17, 5, v15
		v_xor_b32_e32 v16, v16, v17
		v_lshrrev_b32_e32 v17, 6, v16
		v_lshrrev_b32_e32 v18, 3, v15
		v_and_b32_e32 v18, 1, v18
		v_add_u32_e32 v17, v17, v18
		v_and_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v17, 2, v17
		v_lshrrev_b32_e32 v19, 5, v16
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 1, v19
		v_lshrrev_b32_e32 v15, 4, v15
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v18, 6, v18
		v_lshl_add_u32 v15, v15, 7, v18
		v_add_u32_e32 v15, v15, v16
		v_lshrrev_b32_e32 v16, 4, v16
		v_bitop3_b32 v15, v15, v16, 1 bitop3:0x78
		v_bitop3_b32 v15, v17, v19, v15 bitop3:0x96
		v_lshl_add_u32 v15, v15, 4, v11
		v_and_b32_e32 v16, 63, v0
		v_lshrrev_b32_e32 v17, 2, v16
		v_and_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v17, 5, v17
		v_add_u32_e32 v17, 2, v17
		v_lshrrev_b32_e32 v18, 1, v16
		v_and_b32_e32 v18, 1, v18
		v_lshlrev_b32_e32 v18, 4, v18
		v_and_b32_e32 v19, 1, v16
		v_lshlrev_b32_e32 v19, 3, v19
		v_add3_u32 v17, v17, v18, v19
		v_lshrrev_b32_e32 v18, 5, v16
		v_xor_b32_e32 v17, v17, v18
		v_lshrrev_b32_e32 v18, 6, v17
		v_lshrrev_b32_e32 v19, 3, v16
		v_and_b32_e32 v19, 1, v19
		v_add_u32_e32 v18, v18, v19
		v_and_b32_e32 v18, 1, v18
		v_lshlrev_b32_e32 v18, 2, v18
		v_lshrrev_b32_e32 v20, 5, v17
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v20, 1, v20
		v_lshrrev_b32_e32 v16, 4, v16
		v_and_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v19, 6, v19
		v_lshl_add_u32 v16, v16, 7, v19
		v_add_u32_e32 v16, v16, v17
		v_lshrrev_b32_e32 v17, 4, v17
		v_bitop3_b32 v16, v16, v17, 1 bitop3:0x78
		v_bitop3_b32 v16, v18, v20, v16 bitop3:0x96
		v_lshl_add_u32 v16, v16, 4, v11
		v_and_b32_e32 v17, 63, v0
		v_lshrrev_b32_e32 v18, 2, v17
		v_and_b32_e32 v18, 1, v18
		v_lshlrev_b32_e32 v18, 5, v18
		v_add_u32_e32 v18, 4, v18
		v_lshrrev_b32_e32 v19, 1, v17
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 4, v19
		v_and_b32_e32 v20, 1, v17
		v_lshlrev_b32_e32 v20, 3, v20
		v_add3_u32 v18, v18, v19, v20
		v_lshrrev_b32_e32 v19, 5, v17
		v_xor_b32_e32 v18, v18, v19
		v_lshrrev_b32_e32 v19, 6, v18
		v_lshrrev_b32_e32 v20, 3, v17
		v_and_b32_e32 v20, 1, v20
		v_add_u32_e32 v19, v19, v20
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 2, v19
		v_lshrrev_b32_e32 v22, 5, v18
		v_and_b32_e32 v22, 1, v22
		v_lshlrev_b32_e32 v22, 1, v22
		v_lshrrev_b32_e32 v17, 4, v17
		v_and_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v20, 6, v20
		v_lshl_add_u32 v17, v17, 7, v20
		v_add_u32_e32 v17, v17, v18
		v_lshrrev_b32_e32 v18, 4, v18
		v_bitop3_b32 v17, v17, v18, 1 bitop3:0x78
		v_bitop3_b32 v17, v19, v22, v17 bitop3:0x96
		v_lshl_add_u32 v17, v17, 4, v11
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(3)
		ds_write_b128 v7, v[40:43] offset:18864
		s_waitcnt vmcnt(2)
		ds_write_b128 v7, v[44:47] offset:22960
		s_waitcnt vmcnt(1)
		ds_write_b128 v7, v[80:83] offset:27056
		s_waitcnt vmcnt(0)
		ds_write_b128 v7, v[84:87] offset:31152
		v_and_b32_e32 v7, 63, v0
		v_lshrrev_b32_e32 v18, 2, v7
		v_and_b32_e32 v18, 1, v18
		v_lshlrev_b32_e32 v18, 5, v18
		v_add_u32_e32 v18, 6, v18
		v_lshrrev_b32_e32 v19, 1, v7
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 4, v19
		v_and_b32_e32 v20, 1, v7
		v_lshlrev_b32_e32 v20, 3, v20
		v_add3_u32 v18, v18, v19, v20
		v_lshrrev_b32_e32 v19, 5, v7
		v_xor_b32_e32 v18, v18, v19
		v_lshrrev_b32_e32 v19, 6, v18
		v_lshrrev_b32_e32 v20, 3, v7
		v_and_b32_e32 v20, 1, v20
		v_add_u32_e32 v19, v19, v20
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 2, v19
		v_lshrrev_b32_e32 v22, 5, v18
		v_and_b32_e32 v22, 1, v22
		v_lshlrev_b32_e32 v22, 1, v22
		v_lshrrev_b32_e32 v7, 4, v7
		v_and_b32_e32 v7, 1, v7
		v_lshlrev_b32_e32 v20, 6, v20
		v_lshl_add_u32 v7, v7, 7, v20
		v_add_u32_e32 v7, v7, v18
		v_lshrrev_b32_e32 v18, 4, v18
		v_bitop3_b32 v7, v7, v18, 1 bitop3:0x78
		v_bitop3_b32 v7, v19, v22, v7 bitop3:0x96
		v_lshl_add_u32 v7, v7, 4, v11
		s_add_i32 s21, s45, 1
		s_mul_i32 s21, s21, 0x100
		s_lshr_b32 s26, s56, 6
		s_mul_i32 s26, 0x410, s26
		s_mov_b32 m0, s26
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v11, a2
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		ds_read_b128 a[20:23], v15 offset:2480
		ds_read_b128 a[24:27], v16 offset:2480
		ds_read_b128 a[28:31], v17 offset:2480
		ds_read_b128 a[32:35], v7 offset:2480
		v_readfirstlane_b32 s43, v3
		s_add_i32 s21, s21, s43
		s_cmp_lt_i32 s23, s21
		s_cselect_b32 s21, s23, s21
		s_add_i32 s43, s21, 0x7f
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_cmp_lt_i32 s43, 0
		s_cselect_b32 s44, s27, 0
		s_add_i32 s43, s43, s44
		s_ashr_i32 s43, s43, 7
		v_readfirstlane_b32 s44, v3
		s_add_i32 s44, s46, s44
		s_cmp_lt_i32 s44, 0
		s_cselect_b32 s47, s27, 0
		s_add_i32 s44, s44, s47
		s_ashr_i32 s44, s44, 7
		s_cmp_lt_i32 s44, s43
		s_cselect_b32 s44, s44, s43
		s_cmp_gt_i32 s44, 0
		s_cselect_b32 s44, s44, 0
		s_add_i32 m0, s26, 0x1040
		v_readfirstlane_b32 s47, v1
		s_mul_i32 s45, s45, s47
		v_accvgpr_read_b32 v7, a3
		buffer_load_dwordx4 v7, s[28:31], 0 offen lds
		s_add_i32 m0, s26, 0x2080
		v_and_b32_e32 v7, 1, v0
		v_xor_b32_e32 v7, 0x80, v7
		v_lshrrev_b32_e32 v11, 1, v0
		v_and_b32_e32 v11, 1, v11
		v_mov_b32_e32 v15, 2
		v_mul_lo_u32 v15, v15, v11
		v_xor_b32_e32 v7, v7, v15
		v_lshrrev_b32_e32 v11, 2, v0
		v_and_b32_e32 v11, 1, v11
		v_mov_b32_e32 v15, 4
		v_mul_lo_u32 v15, v15, v11
		v_xor_b32_e32 v7, v7, v15
		v_lshrrev_b32_e32 v11, 3, v0
		v_and_b32_e32 v11, 1, v11
		v_mov_b32_e32 v15, 8
		v_mul_lo_u32 v15, v15, v11
		v_lshrrev_b32_e32 v11, 4, v0
		v_and_b32_e32 v11, 1, v11
		v_mov_b32_e32 v16, 16
		v_mul_lo_u32 v16, v16, v11
		v_bitop3_b32 v7, v7, v15, v16 bitop3:0x96
		v_lshrrev_b32_e32 v11, 6, v0
		v_and_b32_e32 v11, 1, v11
		v_mov_b32_e32 v15, 32
		v_mul_lo_u32 v15, v15, v11
		v_lshrrev_b32_e32 v11, 7, v0
		v_and_b32_e32 v11, 1, v11
		v_mov_b32_e32 v16, 64
		v_mul_lo_u32 v16, v16, v11
		v_bitop3_b32 v7, v7, v15, v16 bitop3:0x96
		v_mov_b32_e32 v11, s42
		s_nop 0
		v_readfirstlane_b32 s42, v11
		s_nop 1
		v_add_u32_e32 v7, s42, v7
		v_add_u32_e32 v7, s46, v7
		v_accvgpr_read_b32 v11, a36
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		s_add_i32 m0, s26, 0x30c0
		v_and_b32_e32 v11, 1, v0
		v_lshrrev_b32_e32 v15, 1, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v16, 2
		v_mul_lo_u32 v16, v16, v15
		v_lshrrev_b32_e32 v15, 2, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v17, 4
		v_mul_lo_u32 v17, v17, v15
		v_bitop3_b32 v11, v11, v16, v17 bitop3:0x96
		v_lshrrev_b32_e32 v15, 3, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v16, 8
		v_mul_lo_u32 v16, v16, v15
		v_xor_b32_e32 v11, v11, v16
		v_lshrrev_b32_e32 v15, 4, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v16, 16
		v_mul_lo_u32 v16, v16, v15
		v_lshrrev_b32_e32 v15, 6, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v17, 32
		v_mul_lo_u32 v17, v17, v15
		v_bitop3_b32 v11, v11, v16, v17 bitop3:0x96
		v_lshrrev_b32_e32 v15, 7, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v16, 64
		v_mul_lo_u32 v16, v16, v15
		v_xor_b32_e32 v11, v11, v16
		v_mov_b32_e32 v15, s40
		s_nop 0
		v_readfirstlane_b32 s40, v15
		s_nop 1
		v_add_u32_e32 v11, s40, v11
		v_add_u32_e32 v11, s46, v11
		v_accvgpr_read_b32 v15, a37
		buffer_load_dwordx4 v15, s[28:31], 0 offen lds
		s_lshr_b32 s40, s56, 6
		s_mul_i32 s40, 0x440, s40
		s_add_i32 m0, s40, 0x81f0
		s_mul_i32 s42, s43, 0x80
		v_accvgpr_read_b32 v15, a38
		buffer_load_dwordx4 v15, s[32:35], 0 offen lds
		s_add_i32 m0, s40, 0x92f0
		s_mul_i32 s43, s44, 0x80
		v_accvgpr_read_b32 v15, a39
		buffer_load_dwordx4 v15, s[32:35], 0 offen lds
		s_add_i32 m0, s40, 0xa3f0
		v_readfirstlane_b32 s44, v14
		s_nop 1
		v_mov_b32_e32 v15, s44
		v_accvgpr_read_b32 v16, a40
		buffer_load_dwordx4 v16, s[32:35], 0 offen lds
		s_add_i32 m0, s40, 0xb4f0
		v_readfirstlane_b32 s44, v14
		s_nop 1
		v_mov_b32_e32 v14, s44
		v_readfirstlane_b32 s44, v23
		s_nop 1
		v_mov_b32_e32 v16, s44
		v_readfirstlane_b32 s44, v23
		s_nop 1
		v_mov_b32_e32 v17, s44
		v_accvgpr_read_b32 v18, a41
		buffer_load_dwordx4 v18, s[32:35], 0 offen lds
		s_mov_b32 s44, 0
		s_cmp_lt_i32 0, s43
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
		v_mov_b64_e32 v[80:81], 0
		v_mov_b64_e32 v[82:83], 0
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
		v_mov_b64_e32 v[18:19], 0
		v_accvgpr_write_b32 a48, v18
		v_accvgpr_write_b32 a49, v19
		v_mov_b64_e32 v[18:19], 0
		v_accvgpr_write_b32 a50, v18
		v_accvgpr_write_b32 a51, v19
		v_mov_b64_e32 v[18:19], 0
		v_accvgpr_write_b32 a52, v18
		v_accvgpr_write_b32 a53, v19
		v_mov_b64_e32 v[18:19], 0
		v_accvgpr_write_b32 a54, v18
		v_accvgpr_write_b32 a55, v19
		v_mov_b64_e32 v[18:19], 0
		v_accvgpr_write_b32 a56, v18
		v_accvgpr_write_b32 a57, v19
		v_mov_b64_e32 v[18:19], 0
		v_accvgpr_write_b32 a58, v18
		v_accvgpr_write_b32 a59, v19
		v_mov_b64_e32 v[18:19], 0
		v_accvgpr_write_b32 a60, v18
		v_accvgpr_write_b32 a61, v19
		v_mov_b64_e32 v[18:19], 0
		v_accvgpr_write_b32 a62, v18
		v_accvgpr_write_b32 a63, v19
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_3
.L_attn_fwd_persistent.loop_head_3:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s46, s44, 0x80
		s_lshr_b32 s47, s44, 7
		s_and_b32 s52, s47, 1
		s_mul_i32 s53, 0x4100, s52
		v_and_b32_e32 v18, 63, v0
		v_lshrrev_b32_e32 v18, 5, v18
		v_lshlrev_b32_e32 v18, 4, v18
		v_and_b32_e32 v19, 63, v0
		v_and_b32_e32 v19, 31, v19
		v_lshrrev_b32_e32 v19, 4, v19
		v_lshlrev_b32_e32 v19, 9, v19
		v_add3_u32 v18, s53, v18, v19
		v_and_b32_e32 v19, 63, v0
		v_and_b32_e32 v19, 31, v19
		v_lshrrev_b32_e32 v19, 3, v19
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 0x2080
		v_mul_lo_u32 v20, v20, v19
		v_and_b32_e32 v19, 63, v0
		v_and_b32_e32 v19, 31, v19
		v_lshrrev_b32_e32 v19, 2, v19
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v22, 0x1040
		v_mul_lo_u32 v22, v22, v19
		v_add3_u32 v18, v18, v20, v22
		v_and_b32_e32 v19, 63, v0
		v_and_b32_e32 v19, 31, v19
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 0x410
		v_mul_lo_u32 v20, v20, v19
		v_and_b32_e32 v19, 63, v0
		v_and_b32_e32 v19, 31, v19
		v_lshrrev_b32_e32 v19, 1, v19
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v22, 0x820
		v_mul_lo_u32 v22, v22, v19
		v_add3_u32 v18, v18, v22, v20
		ds_read_b128 v[28:31], v18
		ds_read_b128 v[72:75], v18 offset:32
		ds_read_b128 v[76:79], v18 offset:64
		ds_read_b128 v[96:99], v18 offset:96
		ds_read_b128 v[100:103], v18 offset:256
		ds_read_b128 v[104:107], v18 offset:288
		ds_read_b128 v[108:111], v18 offset:320
		ds_read_b128 v[112:115], v18 offset:352
		ds_read_b128 v[116:119], v18 offset:128
		ds_read_b128 v[120:123], v18 offset:160
		ds_read_b128 v[124:127], v18 offset:192
		ds_read_b128 v[128:131], v18 offset:224
		ds_read_b128 v[132:135], v18 offset:384
		ds_read_b128 v[136:139], v18 offset:416
		ds_read_b128 v[140:143], v18 offset:448
		ds_read_b128 v[144:147], v18 offset:480
		s_mul_i32 s52, 0x4400, s52
		v_and_b32_e32 v18, 63, v0
		v_lshrrev_b32_e32 v18, 5, v18
		v_mov_b32_e32 v19, 0x2200
		v_mul_lo_u32 v19, v19, v18
		v_and_b32_e32 v18, 63, v0
		v_and_b32_e32 v18, 31, v18
		v_lshrrev_b32_e32 v18, 4, v18
		v_lshlrev_b32_e32 v18, 5, v18
		v_add3_u32 v18, s52, v19, v18
		v_and_b32_e32 v19, 63, v0
		v_and_b32_e32 v19, 15, v19
		v_lshrrev_b32_e32 v19, 2, v19
		v_mov_b32_e32 v20, 0x440
		v_mul_lo_u32 v20, v20, v19
		v_and_b32_e32 v19, 63, v0
		v_and_b32_e32 v19, 15, v19
		v_and_b32_e32 v19, 3, v19
		v_lshlrev_b32_e32 v19, 3, v19
		v_add3_u32 v18, v18, v20, v19
		ds_read_b64_tr_b16 v[148:149], v18 offset:33264
		ds_read_b64_tr_b16 v[150:151], v18 offset:37616
		ds_read_b64_tr_b16 a[0:1], v18 offset:33392
		ds_read_b64_tr_b16 a[2:3], v18 offset:37744
		ds_read_b64_tr_b16 a[36:37], v18 offset:33520
		ds_read_b64_tr_b16 a[38:39], v18 offset:37872
		ds_read_b64_tr_b16 a[40:41], v18 offset:33648
		ds_read_b64_tr_b16 a[42:43], v18 offset:38000
		ds_read_b64_tr_b16 a[44:45], v18 offset:33776
		ds_read_b64_tr_b16 a[46:47], v18 offset:38128
		ds_read_b64_tr_b16 a[64:65], v18 offset:33904
		ds_read_b64_tr_b16 a[66:67], v18 offset:38256
		ds_read_b64_tr_b16 a[68:69], v18 offset:34032
		ds_read_b64_tr_b16 a[70:71], v18 offset:38384
		ds_read_b64_tr_b16 a[72:73], v18 offset:34160
		ds_read_b64_tr_b16 a[74:75], v18 offset:38512
		ds_read_b64_tr_b16 v[152:153], v18 offset:33328
		ds_read_b64_tr_b16 v[154:155], v18 offset:37680
		ds_read_b64_tr_b16 a[76:77], v18 offset:33456
		ds_read_b64_tr_b16 a[78:79], v18 offset:37808
		ds_read_b64_tr_b16 a[80:81], v18 offset:33584
		ds_read_b64_tr_b16 a[82:83], v18 offset:37936
		ds_read_b64_tr_b16 a[84:85], v18 offset:33712
		ds_read_b64_tr_b16 a[86:87], v18 offset:38064
		ds_read_b64_tr_b16 a[88:89], v18 offset:33840
		ds_read_b64_tr_b16 a[90:91], v18 offset:38192
		ds_read_b64_tr_b16 a[92:93], v18 offset:33968
		ds_read_b64_tr_b16 a[94:95], v18 offset:38320
		ds_read_b64_tr_b16 a[96:97], v18 offset:34096
		ds_read_b64_tr_b16 a[98:99], v18 offset:38448
		ds_read_b64_tr_b16 a[100:101], v18 offset:34224
		ds_read_b64_tr_b16 a[102:103], v18 offset:38576
		s_barrier
		v_lshrrev_b32_e32 v18, 3, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v19, 64
		v_mul_lo_u32 v19, v19, v18
		v_lshrrev_b32_e32 v18, 4, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v20, 32
		v_mul_lo_u32 v20, v20, v18
		v_lshrrev_b32_e32 v18, 5, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v22, 16
		v_mul_lo_u32 v22, v22, v18
		v_bitop3_b32 v18, v19, v20, v22 bitop3:0x96
		v_lshrrev_b32_e32 v19, 6, v0
		v_and_b32_e32 v19, 1, v19
		v_lshrrev_b32_e32 v20, 7, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v22, 2
		v_mul_lo_u32 v22, v22, v20
		v_bitop3_b32 v18, v18, v19, v22 bitop3:0x96
		v_add_u32_e32 v18, s46, v18
		v_lshrrev_b32_e32 v19, 3, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 64
		v_mul_lo_u32 v20, v20, v19
		v_lshrrev_b32_e32 v19, 4, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v22, 32
		v_mul_lo_u32 v22, v22, v19
		v_bitop3_b32 v19, 4, v20, v22 bitop3:0x96
		v_lshrrev_b32_e32 v20, 5, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v22, 16
		v_mul_lo_u32 v22, v22, v20
		v_xor_b32_e32 v19, v19, v22
		v_lshrrev_b32_e32 v20, 6, v0
		v_and_b32_e32 v20, 1, v20
		v_lshrrev_b32_e32 v22, 7, v0
		v_and_b32_e32 v22, 1, v22
		v_mov_b32_e32 v23, 2
		v_mul_lo_u32 v23, v23, v22
		v_bitop3_b32 v19, v19, v20, v23 bitop3:0x96
		v_add_u32_e32 v19, s46, v19
		v_lshrrev_b32_e32 v20, 3, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v22, 64
		v_mul_lo_u32 v22, v22, v20
		v_lshrrev_b32_e32 v20, 4, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v23, 32
		v_mul_lo_u32 v23, v23, v20
		v_bitop3_b32 v20, 8, v22, v23 bitop3:0x96
		v_lshrrev_b32_e32 v22, 5, v0
		v_and_b32_e32 v22, 1, v22
		v_mov_b32_e32 v23, 16
		v_mul_lo_u32 v23, v23, v22
		v_xor_b32_e32 v20, v20, v23
		v_lshrrev_b32_e32 v22, 6, v0
		v_and_b32_e32 v22, 1, v22
		v_lshrrev_b32_e32 v23, 7, v0
		v_and_b32_e32 v23, 1, v23
		v_mov_b32_e32 v25, 2
		v_mul_lo_u32 v25, v25, v23
		v_bitop3_b32 v20, v20, v22, v25 bitop3:0x96
		v_add_u32_e32 v20, s46, v20
		v_lshrrev_b32_e32 v22, 3, v0
		v_and_b32_e32 v22, 1, v22
		v_mov_b32_e32 v23, 64
		v_mul_lo_u32 v23, v23, v22
		v_lshrrev_b32_e32 v22, 4, v0
		v_and_b32_e32 v22, 1, v22
		v_mov_b32_e32 v25, 32
		v_mul_lo_u32 v25, v25, v22
		v_bitop3_b32 v22, 12, v23, v25 bitop3:0x96
		v_lshrrev_b32_e32 v23, 5, v0
		v_and_b32_e32 v23, 1, v23
		v_mov_b32_e32 v25, 16
		v_mul_lo_u32 v25, v25, v23
		v_xor_b32_e32 v22, v22, v25
		v_lshrrev_b32_e32 v23, 6, v0
		v_and_b32_e32 v23, 1, v23
		v_lshrrev_b32_e32 v25, 7, v0
		v_and_b32_e32 v25, 1, v25
		v_mov_b32_e32 v26, 2
		v_mul_lo_u32 v26, v26, v25
		v_bitop3_b32 v22, v22, v23, v26 bitop3:0x96
		v_add_u32_e32 v22, s46, v22
		v_cmp_lt_i32_e64 vcc, v18, s23
		s_mov_b64 s[52:53], vcc
		v_cmp_lt_i32_e64 vcc, v19, s23
		s_mov_b64 s[54:55], vcc
		v_cmp_lt_i32_e64 vcc, v20, s23
		s_mov_b64 s[58:59], vcc
		v_cmp_lt_i32_e64 vcc, v22, s23
		s_mov_b64 s[60:61], vcc
		v_lshrrev_b32_e32 v18, 3, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v19, 16
		v_mul_lo_u32 v19, v19, v18
		v_lshrrev_b32_e32 v18, 4, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v20, 32
		v_mul_lo_u32 v20, v20, v18
		v_lshrrev_b32_e32 v18, 5, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v22, 64
		v_mul_lo_u32 v22, v22, v18
		v_bitop3_b32 v18, v19, v20, v22 bitop3:0x96
		v_lshrrev_b32_e32 v19, 6, v0
		v_and_b32_e32 v19, 1, v19
		v_lshrrev_b32_e32 v20, 7, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v22, 2
		v_mul_lo_u32 v22, v22, v20
		v_bitop3_b32 v18, v18, v19, v22 bitop3:0x96
		v_add_u32_e32 v18, s46, v18
		v_lshrrev_b32_e32 v19, 3, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 16
		v_mul_lo_u32 v20, v20, v19
		v_lshrrev_b32_e32 v19, 4, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v22, 32
		v_mul_lo_u32 v22, v22, v19
		v_bitop3_b32 v19, 4, v20, v22 bitop3:0x96
		v_lshrrev_b32_e32 v20, 5, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v22, 64
		v_mul_lo_u32 v22, v22, v20
		v_xor_b32_e32 v19, v19, v22
		v_lshrrev_b32_e32 v20, 6, v0
		v_and_b32_e32 v20, 1, v20
		v_lshrrev_b32_e32 v22, 7, v0
		v_and_b32_e32 v22, 1, v22
		v_mov_b32_e32 v23, 2
		v_mul_lo_u32 v23, v23, v22
		v_bitop3_b32 v19, v19, v20, v23 bitop3:0x96
		v_add_u32_e32 v19, s46, v19
		v_lshrrev_b32_e32 v20, 3, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v22, 16
		v_mul_lo_u32 v22, v22, v20
		v_lshrrev_b32_e32 v20, 4, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v23, 32
		v_mul_lo_u32 v23, v23, v20
		v_bitop3_b32 v20, 8, v22, v23 bitop3:0x96
		v_lshrrev_b32_e32 v22, 5, v0
		v_and_b32_e32 v22, 1, v22
		v_mov_b32_e32 v23, 64
		v_mul_lo_u32 v23, v23, v22
		v_xor_b32_e32 v20, v20, v23
		v_lshrrev_b32_e32 v22, 6, v0
		v_and_b32_e32 v22, 1, v22
		v_lshrrev_b32_e32 v23, 7, v0
		v_and_b32_e32 v23, 1, v23
		v_mov_b32_e32 v25, 2
		v_mul_lo_u32 v25, v25, v23
		v_bitop3_b32 v20, v20, v22, v25 bitop3:0x96
		v_add_u32_e32 v20, s46, v20
		v_cmp_lt_i32_e64 vcc, v18, s23
		s_mov_b64 s[62:63], vcc
		v_cmp_lt_i32_e64 vcc, v19, s23
		s_mov_b64 s[64:65], vcc
		v_cmp_lt_i32_e64 vcc, v20, s23
		s_mov_b64 s[66:67], vcc
		s_mul_i32 s57, s15, s44
		s_lshl_b32 s57, s57, 1
		s_lshl_b32 s68, s15, 8
		s_mul_i32 s69, s1, s13
		s_lshl_b32 s69, s69, 1
		s_add_i32 s68, s68, s69
		s_mul_i32 s69, s24, s14
		s_lshl_b32 s69, s69, 1
		s_add_i32 s68, s68, s69
		s_add_i32 s68, s68, s57
		v_lshrrev_b32_e32 v18, 4, v0
		v_and_b32_e32 v18, 1, v18
		v_mul_lo_u32 v18, s15, v18
		v_lshrrev_b32_e32 v19, 5, v0
		v_and_b32_e32 v19, 1, v19
		v_mul_lo_u32 v19, s15, v19
		v_lshrrev_b32_e32 v20, 7, v0
		v_mul_lo_u32 v20, s15, v20
		v_lshrrev_b32_e32 v22, 6, v0
		v_and_b32_e32 v22, 1, v22
		v_mul_lo_u32 v22, s15, v22
		v_lshlrev_b32_e32 v22, 1, v22
		v_lshl_add_u32 v20, v20, 2, v22
		v_lshl_add_u32 v19, v19, 5, v20
		v_lshl_add_u32 v18, v18, 6, v19
		v_lshrrev_b32_e32 v19, 3, v0
		v_and_b32_e32 v19, 1, v19
		v_mul_lo_u32 v19, s15, v19
		v_lshlrev_b32_e32 v19, 7, v19
		v_and_b32_e32 v20, 1, v0
		v_lshlrev_b32_e32 v20, 4, v20
		v_add3_u32 v18, v18, v19, v20
		v_lshrrev_b32_e32 v19, 2, v0
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 6, v19
		v_lshrrev_b32_e32 v20, 1, v0
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v20, 5, v20
		v_add3_u32 v18, v18, v19, v20
		v_add_u32_e32 v19, s68, v18
		s_add_i32 s47, s47, 1
		s_and_b32 s47, s47, 1
		s_mul_i32 s68, 0x4100, s47
		s_add_i32 s68, s26, s68
		s_mov_b32 m0, s68
		v_cndmask_b32_e64 v19, v12, v19, s[52:53]
		buffer_load_dwordx4 v19, s[28:31], 0 offen lds
		v_lshrrev_b32_e32 v19, 3, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 16
		v_mul_lo_u32 v20, v20, v19
		v_lshrrev_b32_e32 v19, 4, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v22, 32
		v_mul_lo_u32 v22, v22, v19
		v_bitop3_b32 v19, 12, v20, v22 bitop3:0x96
		v_lshrrev_b32_e32 v20, 5, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v22, 64
		v_mul_lo_u32 v22, v22, v20
		v_xor_b32_e32 v19, v19, v22
		v_lshrrev_b32_e32 v20, 6, v0
		v_and_b32_e32 v20, 1, v20
		v_lshrrev_b32_e32 v22, 7, v0
		v_and_b32_e32 v22, 1, v22
		v_mov_b32_e32 v23, 2
		v_mul_lo_u32 v23, v23, v22
		v_bitop3_b32 v19, v19, v20, v23 bitop3:0x96
		v_add_u32_e32 v19, s46, v19
		v_add_u32_e32 v18, s57, v18
		s_mul_i32 s52, 0x108, s15
		s_mul_i32 s53, s1, s13
		s_lshl_b32 s53, s53, 1
		s_add_i32 s52, s52, s53
		s_mul_i32 s53, s24, s14
		s_lshl_b32 s53, s53, 1
		s_add_i32 s52, s52, s53
		v_add_u32_e32 v20, s52, v18
		s_add_i32 m0, s68, 0x1040
		v_cndmask_b32_e64 v20, v12, v20, s[54:55]
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		s_mul_i32 s52, 0x110, s15
		s_mul_i32 s53, s1, s13
		s_lshl_b32 s53, s53, 1
		s_add_i32 s52, s52, s53
		s_mul_i32 s53, s24, s14
		s_lshl_b32 s53, s53, 1
		s_add_i32 s52, s52, s53
		v_add_u32_e32 v20, s52, v18
		s_add_i32 m0, s68, 0x2080
		v_cndmask_b32_e64 v20, v12, v20, s[58:59]
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		s_mul_i32 s52, 0x118, s15
		s_mul_i32 s53, s1, s13
		s_lshl_b32 s53, s53, 1
		s_add_i32 s52, s52, s53
		s_mul_i32 s53, s24, s14
		s_lshl_b32 s53, s53, 1
		s_add_i32 s52, s52, s53
		v_add_u32_e32 v18, s52, v18
		s_add_i32 m0, s68, 0x30c0
		v_cndmask_b32_e64 v18, v12, v18, s[60:61]
		buffer_load_dwordx4 v18, s[28:31], 0 offen lds
		s_barrier
		s_mul_i32 s44, s20, s44
		s_lshl_b32 s44, s44, 1
		s_lshl_b32 s52, s20, 8
		s_mul_i32 s53, s1, s18
		s_lshl_b32 s53, s53, 1
		s_add_i32 s52, s52, s53
		s_mul_i32 s53, s24, s19
		s_lshl_b32 s53, s53, 1
		s_add_i32 s52, s52, s53
		s_add_i32 s52, s52, s44
		v_lshrrev_b32_e32 v18, 4, v0
		v_and_b32_e32 v18, 1, v18
		v_mul_lo_u32 v18, s20, v18
		v_lshrrev_b32_e32 v20, 5, v0
		v_and_b32_e32 v20, 1, v20
		v_mul_lo_u32 v20, s20, v20
		v_lshrrev_b32_e32 v22, 7, v0
		v_mul_lo_u32 v22, s20, v22
		v_lshrrev_b32_e32 v23, 6, v0
		v_and_b32_e32 v23, 1, v23
		v_mul_lo_u32 v23, s20, v23
		v_lshlrev_b32_e32 v23, 1, v23
		v_lshl_add_u32 v22, v22, 2, v23
		v_lshl_add_u32 v20, v20, 7, v22
		v_lshl_add_u32 v18, v18, 6, v20
		v_lshrrev_b32_e32 v20, 3, v0
		v_and_b32_e32 v20, 1, v20
		v_mul_lo_u32 v20, s20, v20
		v_lshlrev_b32_e32 v20, 5, v20
		v_and_b32_e32 v22, 1, v0
		v_lshlrev_b32_e32 v22, 4, v22
		v_add3_u32 v18, v18, v20, v22
		v_lshrrev_b32_e32 v20, 2, v0
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v20, 6, v20
		v_lshrrev_b32_e32 v22, 1, v0
		v_and_b32_e32 v22, 1, v22
		v_lshlrev_b32_e32 v22, 5, v22
		v_add3_u32 v18, v18, v20, v22
		v_add_u32_e32 v20, s52, v18
		s_mul_i32 s47, 0x4400, s47
		s_add_i32 s47, s40, s47
		s_add_i32 m0, s47, 0x81f0
		v_cndmask_b32_e64 v20, v12, v20, s[62:63]
		buffer_load_dwordx4 v20, s[32:35], 0 offen lds
		v_add_u32_e32 v18, s44, v18
		s_mul_i32 s44, 0x108, s20
		s_mul_i32 s52, s1, s18
		s_lshl_b32 s52, s52, 1
		s_add_i32 s44, s44, s52
		s_mul_i32 s52, s24, s19
		s_lshl_b32 s52, s52, 1
		s_add_i32 s44, s44, s52
		v_add_u32_e32 v20, s44, v18
		s_add_i32 m0, s47, 0x92f0
		v_cndmask_b32_e64 v20, v12, v20, s[64:65]
		buffer_load_dwordx4 v20, s[32:35], 0 offen lds
		s_mul_i32 s44, 0x110, s20
		s_mul_i32 s52, s1, s18
		s_lshl_b32 s52, s52, 1
		s_add_i32 s44, s44, s52
		s_mul_i32 s52, s24, s19
		s_lshl_b32 s52, s52, 1
		s_add_i32 s44, s44, s52
		v_add_u32_e32 v20, s44, v18
		s_add_i32 m0, s47, 0xa3f0
		v_cndmask_b32_e64 v20, v12, v20, s[66:67]
		buffer_load_dwordx4 v20, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v19, s23
		s_mul_i32 s44, 0x118, s20
		s_mul_i32 s52, s1, s18
		s_lshl_b32 s52, s52, 1
		s_add_i32 s44, s44, s52
		s_mul_i32 s52, s24, s19
		s_lshl_b32 s52, s52, 1
		s_add_i32 s44, s44, s52
		v_add_u32_e32 v18, s44, v18
		s_add_i32 m0, s47, 0xb4f0
		v_cndmask_b32_e32 v18, v12, v18, vcc
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[160:175], v[28:31], a[4:7], 0
		s_nop 11
		v_accvgpr_write_b32 a112, v160
		v_accvgpr_write_b32 a113, v161
		v_accvgpr_write_b32 a114, v162
		v_accvgpr_write_b32 a115, v163
		v_accvgpr_write_b32 a116, v164
		v_accvgpr_write_b32 a117, v165
		v_accvgpr_write_b32 a118, v166
		v_accvgpr_write_b32 a119, v167
		v_accvgpr_write_b32 a120, v168
		v_accvgpr_write_b32 a121, v169
		v_accvgpr_write_b32 a122, v170
		v_accvgpr_write_b32 a123, v171
		v_accvgpr_write_b32 a124, v172
		v_accvgpr_write_b32 a125, v173
		v_accvgpr_write_b32 a126, v174
		v_accvgpr_write_b32 a127, v175
		v_mfma_f32_32x32x16_bf16 v[160:175], v[100:103], a[4:7], 0
		s_nop 11
		v_accvgpr_write_b32 a128, v160
		v_accvgpr_write_b32 a129, v161
		v_accvgpr_write_b32 a130, v162
		v_accvgpr_write_b32 a131, v163
		v_accvgpr_write_b32 a132, v164
		v_accvgpr_write_b32 a133, v165
		v_accvgpr_write_b32 a134, v166
		v_accvgpr_write_b32 a135, v167
		v_accvgpr_write_b32 a136, v168
		v_accvgpr_write_b32 a137, v169
		v_accvgpr_write_b32 a138, v170
		v_accvgpr_write_b32 a139, v171
		v_accvgpr_write_b32 a140, v172
		v_accvgpr_write_b32 a141, v173
		v_accvgpr_write_b32 a142, v174
		v_accvgpr_write_b32 a143, v175
		v_mfma_f32_32x32x16_bf16 v[160:175], v[116:119], a[4:7], 0
		s_nop 11
		v_accvgpr_write_b32 a144, v160
		v_accvgpr_write_b32 a145, v161
		v_accvgpr_write_b32 a146, v162
		v_accvgpr_write_b32 a147, v163
		v_accvgpr_write_b32 a148, v164
		v_accvgpr_write_b32 a149, v165
		v_accvgpr_write_b32 a150, v166
		v_accvgpr_write_b32 a151, v167
		v_accvgpr_write_b32 a152, v168
		v_accvgpr_write_b32 a153, v169
		v_accvgpr_write_b32 a154, v170
		v_accvgpr_write_b32 a155, v171
		v_accvgpr_write_b32 a156, v172
		v_accvgpr_write_b32 a157, v173
		v_accvgpr_write_b32 a158, v174
		v_accvgpr_write_b32 a159, v175
		v_mfma_f32_32x32x16_bf16 v[160:175], v[132:135], a[4:7], 0
		s_nop 11
		v_accvgpr_write_b32 a160, v160
		v_accvgpr_write_b32 a161, v161
		v_accvgpr_write_b32 a162, v162
		v_accvgpr_write_b32 a163, v163
		v_accvgpr_write_b32 a164, v164
		v_accvgpr_write_b32 a165, v165
		v_accvgpr_write_b32 a166, v166
		v_accvgpr_write_b32 a167, v167
		v_accvgpr_write_b32 a168, v168
		v_accvgpr_write_b32 a169, v169
		v_accvgpr_write_b32 a170, v170
		v_accvgpr_write_b32 a171, v171
		v_accvgpr_write_b32 a172, v172
		v_accvgpr_write_b32 a173, v173
		v_accvgpr_write_b32 a174, v174
		v_accvgpr_write_b32 a175, v175
		v_mfma_f32_32x32x16_bf16 v[160:175], v[132:135], a[20:23], 0
		s_nop 11
		v_accvgpr_write_b32 a176, v160
		v_accvgpr_write_b32 a177, v161
		v_accvgpr_write_b32 a178, v162
		v_accvgpr_write_b32 a179, v163
		v_accvgpr_write_b32 a180, v164
		v_accvgpr_write_b32 a181, v165
		v_accvgpr_write_b32 a182, v166
		v_accvgpr_write_b32 a183, v167
		v_accvgpr_write_b32 a184, v168
		v_accvgpr_write_b32 a185, v169
		v_accvgpr_write_b32 a186, v170
		v_accvgpr_write_b32 a187, v171
		v_accvgpr_write_b32 a188, v172
		v_accvgpr_write_b32 a189, v173
		v_accvgpr_write_b32 a190, v174
		v_accvgpr_write_b32 a191, v175
		v_mfma_f32_32x32x16_bf16 v[160:175], v[28:31], a[20:23], 0
		s_nop 11
		v_accvgpr_write_b32 a192, v160
		v_accvgpr_write_b32 a193, v161
		v_accvgpr_write_b32 a194, v162
		v_accvgpr_write_b32 a195, v163
		v_accvgpr_write_b32 a196, v164
		v_accvgpr_write_b32 a197, v165
		v_accvgpr_write_b32 a198, v166
		v_accvgpr_write_b32 a199, v167
		v_accvgpr_write_b32 a200, v168
		v_accvgpr_write_b32 a201, v169
		v_accvgpr_write_b32 a202, v170
		v_accvgpr_write_b32 a203, v171
		v_accvgpr_write_b32 a204, v172
		v_accvgpr_write_b32 a205, v173
		v_accvgpr_write_b32 a206, v174
		v_accvgpr_write_b32 a207, v175
		v_mfma_f32_32x32x16_bf16 v[160:175], v[100:103], a[20:23], 0
		s_nop 11
		v_accvgpr_write_b32 a208, v160
		v_accvgpr_write_b32 a209, v161
		v_accvgpr_write_b32 a210, v162
		v_accvgpr_write_b32 a211, v163
		v_accvgpr_write_b32 a212, v164
		v_accvgpr_write_b32 a213, v165
		v_accvgpr_write_b32 a214, v166
		v_accvgpr_write_b32 a215, v167
		v_accvgpr_write_b32 a216, v168
		v_accvgpr_write_b32 a217, v169
		v_accvgpr_write_b32 a218, v170
		v_accvgpr_write_b32 a219, v171
		v_accvgpr_write_b32 a220, v172
		v_accvgpr_write_b32 a221, v173
		v_accvgpr_write_b32 a222, v174
		v_accvgpr_write_b32 a223, v175
		buffer_load_dwordx4 v18, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[160:175], v[116:119], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 a[112:127], v[72:75], a[8:11], a[112:127]
		v_mfma_f32_32x32x16_bf16 a[128:143], v[104:107], a[8:11], a[128:143]
		v_mfma_f32_32x32x16_bf16 a[144:159], v[120:123], a[8:11], a[144:159]
		v_mfma_f32_32x32x16_bf16 a[160:175], v[136:139], a[8:11], a[160:175]
		v_mfma_f32_32x32x16_bf16 a[176:191], v[136:139], a[24:27], a[176:191]
		v_mfma_f32_32x32x16_bf16 a[192:207], v[72:75], a[24:27], a[192:207]
		v_mfma_f32_32x32x16_bf16 a[208:223], v[104:107], a[24:27], a[208:223]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[120:123], a[24:27], v[160:175]
		v_mfma_f32_32x32x16_bf16 a[112:127], v[76:79], a[12:15], a[112:127]
		v_mfma_f32_32x32x16_bf16 a[128:143], v[108:111], a[12:15], a[128:143]
		v_mfma_f32_32x32x16_bf16 a[144:159], v[124:127], a[12:15], a[144:159]
		v_mfma_f32_32x32x16_bf16 a[160:175], v[140:143], a[12:15], a[160:175]
		v_mfma_f32_32x32x16_bf16 a[176:191], v[140:143], a[28:31], a[176:191]
		v_mfma_f32_32x32x16_bf16 a[192:207], v[76:79], a[28:31], a[192:207]
		v_mfma_f32_32x32x16_bf16 a[208:223], v[108:111], a[28:31], a[208:223]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[124:127], a[28:31], v[160:175]
		v_mfma_f32_32x32x16_bf16 a[112:127], v[96:99], a[16:19], a[112:127]
		v_mfma_f32_32x32x16_bf16 a[128:143], v[112:115], a[16:19], a[128:143]
		v_mfma_f32_32x32x16_bf16 a[144:159], v[128:131], a[16:19], a[144:159]
		v_mfma_f32_32x32x16_bf16 a[160:175], v[144:147], a[16:19], a[160:175]
		v_mfma_f32_32x32x16_bf16 a[176:191], v[144:147], a[32:35], a[176:191]
		v_mfma_f32_32x32x16_bf16 a[192:207], v[96:99], a[32:35], a[192:207]
		v_mfma_f32_32x32x16_bf16 a[208:223], v[112:115], a[32:35], a[208:223]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[128:131], a[32:35], v[160:175]
		s_cmp_lt_i32 s46, s43
		s_nop 3
		v_accvgpr_read_b32 v18, a112
		v_accvgpr_read_b32 v19, a113
		v_max_f32_e32 v18, v18, v19
		v_accvgpr_read_b32 v19, a114
		v_accvgpr_read_b32 v20, a115
		v_max_f32_e32 v19, v19, v20
		v_accvgpr_read_b32 v20, a116
		v_accvgpr_read_b32 v22, a117
		v_max_f32_e32 v20, v20, v22
		v_accvgpr_read_b32 v22, a118
		v_accvgpr_read_b32 v23, a119
		v_max_f32_e32 v22, v22, v23
		v_accvgpr_read_b32 v23, a120
		v_accvgpr_read_b32 v25, a121
		v_max_f32_e32 v23, v23, v25
		v_accvgpr_read_b32 v25, a122
		v_accvgpr_read_b32 v26, a123
		v_max_f32_e32 v25, v25, v26
		v_accvgpr_read_b32 v26, a124
		v_accvgpr_read_b32 v27, a125
		v_max_f32_e32 v26, v26, v27
		v_accvgpr_read_b32 v27, a126
		v_accvgpr_read_b32 v28, a127
		v_max_f32_e32 v27, v27, v28
		v_accvgpr_read_b32 v28, a128
		v_accvgpr_read_b32 v29, a129
		v_max_f32_e32 v28, v28, v29
		v_accvgpr_read_b32 v29, a130
		v_accvgpr_read_b32 v30, a131
		v_max_f32_e32 v29, v29, v30
		v_accvgpr_read_b32 v30, a132
		v_accvgpr_read_b32 v31, a133
		v_max_f32_e32 v30, v30, v31
		v_accvgpr_read_b32 v31, a134
		v_accvgpr_read_b32 v65, a135
		v_max_f32_e32 v31, v31, v65
		v_accvgpr_read_b32 v65, a136
		v_accvgpr_read_b32 v67, a137
		v_max_f32_e32 v65, v65, v67
		v_accvgpr_read_b32 v67, a138
		v_accvgpr_read_b32 v70, a139
		v_max_f32_e32 v67, v67, v70
		v_accvgpr_read_b32 v70, a140
		v_accvgpr_read_b32 v71, a141
		v_max_f32_e32 v70, v70, v71
		v_accvgpr_read_b32 v71, a142
		v_accvgpr_read_b32 v72, a143
		v_max_f32_e32 v71, v71, v72
		v_accvgpr_read_b32 v72, a144
		v_accvgpr_read_b32 v73, a145
		v_max_f32_e32 v72, v72, v73
		v_accvgpr_read_b32 v73, a146
		v_accvgpr_read_b32 v74, a147
		v_max_f32_e32 v73, v73, v74
		v_accvgpr_read_b32 v74, a148
		v_accvgpr_read_b32 v75, a149
		v_max_f32_e32 v74, v74, v75
		v_accvgpr_read_b32 v75, a150
		v_accvgpr_read_b32 v76, a151
		v_max_f32_e32 v75, v75, v76
		v_accvgpr_read_b32 v76, a152
		v_accvgpr_read_b32 v77, a153
		v_max_f32_e32 v76, v76, v77
		v_accvgpr_read_b32 v77, a154
		v_accvgpr_read_b32 v78, a155
		v_max_f32_e32 v77, v77, v78
		v_accvgpr_read_b32 v78, a156
		v_accvgpr_read_b32 v79, a157
		v_max_f32_e32 v78, v78, v79
		v_accvgpr_read_b32 v79, a158
		v_accvgpr_read_b32 v96, a159
		v_max_f32_e32 v79, v79, v96
		v_accvgpr_read_b32 v96, a160
		v_accvgpr_read_b32 v97, a161
		v_max_f32_e32 v96, v96, v97
		v_accvgpr_read_b32 v97, a162
		v_accvgpr_read_b32 v98, a163
		v_max_f32_e32 v97, v97, v98
		v_accvgpr_read_b32 v98, a164
		v_accvgpr_read_b32 v99, a165
		v_max_f32_e32 v98, v98, v99
		v_accvgpr_read_b32 v99, a166
		v_accvgpr_read_b32 v100, a167
		v_max_f32_e32 v99, v99, v100
		v_accvgpr_read_b32 v100, a168
		v_accvgpr_read_b32 v101, a169
		v_max_f32_e32 v100, v100, v101
		v_accvgpr_read_b32 v101, a170
		v_accvgpr_read_b32 v102, a171
		v_max_f32_e32 v101, v101, v102
		v_accvgpr_read_b32 v102, a172
		v_accvgpr_read_b32 v103, a173
		v_max_f32_e32 v102, v102, v103
		v_accvgpr_read_b32 v103, a174
		v_accvgpr_read_b32 v104, a175
		v_max_f32_e32 v103, v103, v104
		v_max_f32_e32 v18, v18, v19
		v_max_f32_e32 v19, v20, v22
		v_max_f32_e32 v20, v23, v25
		v_max_f32_e32 v22, v26, v27
		v_max_f32_e32 v23, v28, v29
		v_max_f32_e32 v25, v30, v31
		v_max_f32_e32 v26, v65, v67
		v_max_f32_e32 v27, v70, v71
		v_max_f32_e32 v28, v72, v73
		v_max_f32_e32 v29, v74, v75
		v_max_f32_e32 v30, v76, v77
		v_max_f32_e32 v31, v78, v79
		v_max_f32_e32 v65, v96, v97
		v_max_f32_e32 v67, v98, v99
		v_max_f32_e32 v70, v100, v101
		v_max_f32_e32 v71, v102, v103
		v_max_f32_e32 v18, v18, v19
		v_max_f32_e32 v19, v20, v22
		v_max_f32_e32 v20, v23, v25
		v_max_f32_e32 v22, v26, v27
		v_max_f32_e32 v23, v28, v29
		v_max_f32_e32 v25, v30, v31
		v_max_f32_e32 v26, v65, v67
		v_max_f32_e32 v27, v70, v71
		v_max_f32_e32 v18, v18, v19
		v_max_f32_e32 v19, v20, v22
		v_max_f32_e32 v20, v23, v25
		v_max_f32_e32 v22, v26, v27
		v_max_f32_e32 v18, v18, v19
		v_max_f32_e32 v19, v20, v22
		v_max_f32_e32 v18, v18, v19
		v_and_b32_e32 v19, 1, v10
		v_lshrrev_b32_e32 v20, 4, v10
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v20, 4, v20
		v_lshrrev_b32_e32 v22, 3, v10
		v_and_b32_e32 v22, 1, v22
		v_lshlrev_b32_e32 v22, 3, v22
		v_add3_u32 v19, v19, v20, v22
		v_lshrrev_b32_e32 v20, 2, v10
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v20, 2, v20
		v_lshrrev_b32_e32 v22, 1, v10
		v_and_b32_e32 v22, 1, v22
		v_lshlrev_b32_e32 v22, 1, v22
		v_add3_u32 v19, v19, v20, v22
		v_lshlrev_b32_e32 v19, 2, v19
		ds_bpermute_b32 v20, v19, v18
		v_lshrrev_b32_e32 v22, 4, v10
		v_and_b32_e32 v22, 1, v22
		v_lshlrev_b32_e32 v22, 4, v22
		v_lshrrev_b32_e32 v23, 3, v10
		v_and_b32_e32 v23, 1, v23
		v_lshlrev_b32_e32 v23, 3, v23
		v_lshrrev_b32_e32 v25, 2, v10
		v_and_b32_e32 v25, 1, v25
		v_lshlrev_b32_e32 v25, 2, v25
		v_and_b32_e32 v26, 1, v10
		v_add_u32_e32 v26, 32, v26
		v_lshrrev_b32_e32 v27, 1, v10
		v_and_b32_e32 v27, 1, v27
		v_lshlrev_b32_e32 v27, 1, v27
		v_bitop3_b32 v25, v25, v26, v27 bitop3:0x96
		v_bitop3_b32 v22, v22, v23, v25 bitop3:0x96
		v_lshlrev_b32_e32 v22, 2, v22
		ds_bpermute_b32 v23, v22, v18
		v_accvgpr_read_b32 v18, a192
		v_accvgpr_read_b32 v25, a193
		v_max_f32_e32 v18, v18, v25
		v_accvgpr_read_b32 v25, a194
		v_accvgpr_read_b32 v26, a195
		v_max_f32_e32 v25, v25, v26
		v_accvgpr_read_b32 v26, a196
		v_accvgpr_read_b32 v27, a197
		v_max_f32_e32 v26, v26, v27
		v_accvgpr_read_b32 v27, a198
		v_accvgpr_read_b32 v28, a199
		v_max_f32_e32 v27, v27, v28
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v28, v20, v23
		v_accvgpr_read_b32 v20, a200
		v_accvgpr_read_b32 v23, a201
		v_max_f32_e32 v20, v20, v23
		v_accvgpr_read_b32 v23, a202
		v_accvgpr_read_b32 v29, a203
		v_max_f32_e32 v23, v23, v29
		v_accvgpr_read_b32 v29, a204
		v_accvgpr_read_b32 v30, a205
		v_max_f32_e32 v29, v29, v30
		v_accvgpr_read_b32 v30, a206
		v_accvgpr_read_b32 v31, a207
		v_max_f32_e32 v30, v30, v31
		v_accvgpr_read_b32 v31, a208
		v_accvgpr_read_b32 v65, a209
		v_max_f32_e32 v31, v31, v65
		v_accvgpr_read_b32 v65, a210
		v_accvgpr_read_b32 v67, a211
		v_max_f32_e32 v65, v65, v67
		v_accvgpr_read_b32 v67, a212
		v_accvgpr_read_b32 v70, a213
		v_max_f32_e32 v67, v67, v70
		v_accvgpr_read_b32 v70, a214
		v_accvgpr_read_b32 v71, a215
		v_max_f32_e32 v70, v70, v71
		v_accvgpr_read_b32 v71, a216
		v_accvgpr_read_b32 v72, a217
		v_max_f32_e32 v71, v71, v72
		v_accvgpr_read_b32 v72, a218
		v_accvgpr_read_b32 v73, a219
		v_max_f32_e32 v72, v72, v73
		v_accvgpr_read_b32 v73, a220
		v_accvgpr_read_b32 v74, a221
		v_max_f32_e32 v73, v73, v74
		v_accvgpr_read_b32 v74, a222
		v_accvgpr_read_b32 v75, a223
		v_max_f32_e32 v74, v74, v75
		v_max_f32_e32 v75, v160, v161
		v_max_f32_e32 v76, v162, v163
		v_max_f32_e32 v77, v164, v165
		v_max_f32_e32 v78, v166, v167
		v_max_f32_e32 v79, v168, v169
		v_max_f32_e32 v96, v170, v171
		v_max_f32_e32 v97, v172, v173
		v_max_f32_e32 v98, v174, v175
		v_accvgpr_read_b32 v99, a176
		v_accvgpr_read_b32 v100, a177
		v_max_f32_e32 v99, v99, v100
		v_accvgpr_read_b32 v100, a178
		v_accvgpr_read_b32 v101, a179
		v_max_f32_e32 v100, v100, v101
		v_accvgpr_read_b32 v101, a180
		v_accvgpr_read_b32 v102, a181
		v_max_f32_e32 v101, v101, v102
		v_accvgpr_read_b32 v102, a182
		v_accvgpr_read_b32 v103, a183
		v_max_f32_e32 v102, v102, v103
		v_accvgpr_read_b32 v103, a184
		v_accvgpr_read_b32 v104, a185
		v_max_f32_e32 v103, v103, v104
		v_accvgpr_read_b32 v104, a186
		v_accvgpr_read_b32 v105, a187
		v_max_f32_e32 v104, v104, v105
		v_accvgpr_read_b32 v105, a188
		v_accvgpr_read_b32 v106, a189
		v_max_f32_e32 v105, v105, v106
		v_accvgpr_read_b32 v106, a190
		v_accvgpr_read_b32 v107, a191
		v_max_f32_e32 v106, v106, v107
		v_max_f32_e32 v18, v18, v25
		v_max_f32_e32 v25, v26, v27
		v_max_f32_e32 v20, v20, v23
		v_max_f32_e32 v23, v29, v30
		v_max_f32_e32 v26, v31, v65
		v_max_f32_e32 v27, v67, v70
		v_max_f32_e32 v29, v71, v72
		v_max_f32_e32 v30, v73, v74
		v_max_f32_e32 v31, v75, v76
		v_max_f32_e32 v65, v77, v78
		v_max_f32_e32 v67, v79, v96
		v_max_f32_e32 v70, v97, v98
		v_max_f32_e32 v71, v99, v100
		v_max_f32_e32 v72, v101, v102
		v_max_f32_e32 v73, v103, v104
		v_max_f32_e32 v74, v105, v106
		v_max_f32_e32 v18, v18, v25
		v_max_f32_e32 v20, v20, v23
		v_max_f32_e32 v23, v26, v27
		v_max_f32_e32 v25, v29, v30
		v_max_f32_e32 v26, v31, v65
		v_max_f32_e32 v27, v67, v70
		v_max_f32_e32 v29, v71, v72
		v_max_f32_e32 v30, v73, v74
		v_max_f32_e32 v18, v18, v20
		v_max_f32_e32 v20, v23, v25
		v_max_f32_e32 v23, v26, v27
		v_max_f32_e32 v25, v29, v30
		v_max_f32_e32 v18, v18, v20
		v_max_f32_e32 v20, v23, v25
		v_max_f32_e32 v18, v18, v20
		ds_bpermute_b32 v20, v19, v18
		ds_bpermute_b32 v23, v22, v18
		v_mov_b32_e32 v26, 0x3e38aa3b
		v_mov_b32_e32 v27, 0x3e38aa3b
		v_accvgpr_read_b32 v30, a112
		v_accvgpr_read_b32 v31, a113
		v_pk_mul_f32 v[70:71], v[30:31], v[26:27]
		v_accvgpr_read_b32 v30, a114
		v_accvgpr_read_b32 v31, a115
		v_pk_mul_f32 v[72:73], v[30:31], v[26:27]
		v_accvgpr_read_b32 v30, a116
		v_accvgpr_read_b32 v31, a117
		v_pk_mul_f32 v[74:75], v[30:31], v[26:27]
		v_accvgpr_read_b32 v30, a118
		v_accvgpr_read_b32 v31, a119
		v_pk_mul_f32 v[76:77], v[30:31], v[26:27]
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v29, v20, v23
		v_pk_mul_f32 v[30:31], v[28:29], v[26:27]
		v_max_f32_e32 v18, v15, v30
		v_max_f32_e32 v20, v14, v31
		v_accvgpr_read_b32 v28, a120
		v_accvgpr_read_b32 v29, a121
		v_pk_mul_f32 v[30:31], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a122
		v_accvgpr_read_b32 v29, a123
		v_pk_mul_f32 v[78:79], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a124
		v_accvgpr_read_b32 v29, a125
		v_pk_mul_f32 v[96:97], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a126
		v_accvgpr_read_b32 v29, a127
		v_pk_mul_f32 v[98:99], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a128
		v_accvgpr_read_b32 v29, a129
		v_pk_mul_f32 v[100:101], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a130
		v_accvgpr_read_b32 v29, a131
		v_pk_mul_f32 v[102:103], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a132
		v_accvgpr_read_b32 v29, a133
		v_pk_mul_f32 v[104:105], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a134
		v_accvgpr_read_b32 v29, a135
		v_pk_mul_f32 v[106:107], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a136
		v_accvgpr_read_b32 v29, a137
		v_pk_mul_f32 v[108:109], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a138
		v_accvgpr_read_b32 v29, a139
		v_pk_mul_f32 v[110:111], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a140
		v_accvgpr_read_b32 v29, a141
		v_pk_mul_f32 v[112:113], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a142
		v_accvgpr_read_b32 v29, a143
		v_pk_mul_f32 v[114:115], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a144
		v_accvgpr_read_b32 v29, a145
		v_pk_mul_f32 v[116:117], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a146
		v_accvgpr_read_b32 v29, a147
		v_pk_mul_f32 v[118:119], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a148
		v_accvgpr_read_b32 v29, a149
		v_pk_mul_f32 v[120:121], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a150
		v_accvgpr_read_b32 v29, a151
		v_pk_mul_f32 v[122:123], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a152
		v_accvgpr_read_b32 v29, a153
		v_pk_mul_f32 v[124:125], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a154
		v_accvgpr_read_b32 v29, a155
		v_pk_mul_f32 v[126:127], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a156
		v_accvgpr_read_b32 v29, a157
		v_pk_mul_f32 v[128:129], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a158
		v_accvgpr_read_b32 v29, a159
		v_pk_mul_f32 v[130:131], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a160
		v_accvgpr_read_b32 v29, a161
		v_pk_mul_f32 v[132:133], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a162
		v_accvgpr_read_b32 v29, a163
		v_pk_mul_f32 v[134:135], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a164
		v_accvgpr_read_b32 v29, a165
		v_pk_mul_f32 v[136:137], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a166
		v_accvgpr_read_b32 v29, a167
		v_pk_mul_f32 v[138:139], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a168
		v_accvgpr_read_b32 v29, a169
		v_pk_mul_f32 v[140:141], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a170
		v_accvgpr_read_b32 v29, a171
		v_pk_mul_f32 v[142:143], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a172
		v_accvgpr_read_b32 v29, a173
		v_pk_mul_f32 v[144:145], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a174
		v_accvgpr_read_b32 v29, a175
		v_pk_mul_f32 v[146:147], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a192
		v_accvgpr_read_b32 v29, a193
		v_pk_mul_f32 v[156:157], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a194
		v_accvgpr_read_b32 v29, a195
		v_pk_mul_f32 v[158:159], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a196
		v_accvgpr_read_b32 v29, a197
		v_pk_mul_f32 v[176:177], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a198
		v_accvgpr_read_b32 v29, a199
		v_pk_mul_f32 v[178:179], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a200
		v_accvgpr_read_b32 v29, a201
		v_pk_mul_f32 v[180:181], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a202
		v_accvgpr_read_b32 v29, a203
		v_pk_mul_f32 v[182:183], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a204
		v_accvgpr_read_b32 v29, a205
		v_pk_mul_f32 v[184:185], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a206
		v_accvgpr_read_b32 v29, a207
		v_pk_mul_f32 v[186:187], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a208
		v_accvgpr_read_b32 v29, a209
		v_pk_mul_f32 v[188:189], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a210
		v_accvgpr_read_b32 v29, a211
		v_pk_mul_f32 v[190:191], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a212
		v_accvgpr_read_b32 v29, a213
		v_pk_mul_f32 v[192:193], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a214
		v_accvgpr_read_b32 v29, a215
		v_pk_mul_f32 v[194:195], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a216
		v_accvgpr_read_b32 v29, a217
		v_pk_mul_f32 v[196:197], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a218
		v_accvgpr_read_b32 v29, a219
		v_pk_mul_f32 v[198:199], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a220
		v_accvgpr_read_b32 v29, a221
		v_pk_mul_f32 v[200:201], v[28:29], v[26:27]
		v_accvgpr_read_b32 v28, a222
		v_accvgpr_read_b32 v29, a223
		v_pk_mul_f32 v[202:203], v[28:29], v[26:27]
		v_pk_mul_f32 v[28:29], v[160:161], v[26:27]
		v_pk_mul_f32 v[160:161], v[162:163], v[26:27]
		v_pk_mul_f32 v[162:163], v[164:165], v[26:27]
		v_pk_mul_f32 v[164:165], v[166:167], v[26:27]
		v_pk_mul_f32 v[166:167], v[168:169], v[26:27]
		v_pk_mul_f32 v[168:169], v[170:171], v[26:27]
		v_pk_mul_f32 v[170:171], v[172:173], v[26:27]
		v_pk_mul_f32 v[172:173], v[174:175], v[26:27]
		v_accvgpr_read_b32 v174, a176
		v_accvgpr_read_b32 v175, a177
		v_pk_mul_f32 v[204:205], v[174:175], v[26:27]
		v_accvgpr_read_b32 v174, a178
		v_accvgpr_read_b32 v175, a179
		v_pk_mul_f32 v[206:207], v[174:175], v[26:27]
		v_accvgpr_read_b32 v174, a180
		v_accvgpr_read_b32 v175, a181
		v_pk_mul_f32 v[208:209], v[174:175], v[26:27]
		v_accvgpr_read_b32 v174, a182
		v_accvgpr_read_b32 v175, a183
		v_pk_mul_f32 v[210:211], v[174:175], v[26:27]
		v_accvgpr_read_b32 v174, a184
		v_accvgpr_read_b32 v175, a185
		v_pk_mul_f32 v[212:213], v[174:175], v[26:27]
		v_accvgpr_read_b32 v174, a186
		v_accvgpr_read_b32 v175, a187
		v_pk_mul_f32 v[214:215], v[174:175], v[26:27]
		v_accvgpr_read_b32 v174, a188
		v_accvgpr_read_b32 v175, a189
		v_pk_mul_f32 v[216:217], v[174:175], v[26:27]
		v_accvgpr_read_b32 v174, a190
		v_accvgpr_read_b32 v175, a191
		v_pk_mul_f32 v[218:219], v[174:175], v[26:27]
		v_sub_f32_e32 v23, v70, v18
		v_sub_f32_e32 v25, v71, v18
		v_sub_f32_e32 v26, v72, v18
		v_sub_f32_e32 v27, v73, v18
		v_sub_f32_e32 v65, v74, v18
		v_sub_f32_e32 v67, v75, v18
		v_sub_f32_e32 v70, v76, v18
		v_sub_f32_e32 v71, v77, v18
		v_sub_f32_e32 v30, v30, v18
		v_sub_f32_e32 v31, v31, v18
		v_sub_f32_e32 v72, v78, v18
		v_sub_f32_e32 v73, v79, v18
		v_sub_f32_e32 v74, v96, v18
		v_sub_f32_e32 v75, v97, v18
		v_sub_f32_e32 v76, v98, v18
		v_sub_f32_e32 v77, v99, v18
		v_sub_f32_e32 v78, v100, v18
		v_sub_f32_e32 v79, v101, v18
		v_sub_f32_e32 v96, v102, v18
		v_sub_f32_e32 v97, v103, v18
		v_sub_f32_e32 v98, v104, v18
		v_sub_f32_e32 v99, v105, v18
		v_sub_f32_e32 v100, v106, v18
		v_sub_f32_e32 v101, v107, v18
		v_sub_f32_e32 v102, v108, v18
		v_sub_f32_e32 v103, v109, v18
		v_sub_f32_e32 v104, v110, v18
		v_sub_f32_e32 v105, v111, v18
		v_sub_f32_e32 v106, v112, v18
		v_sub_f32_e32 v107, v113, v18
		v_sub_f32_e32 v108, v114, v18
		v_sub_f32_e32 v109, v115, v18
		v_sub_f32_e32 v110, v116, v18
		v_sub_f32_e32 v111, v117, v18
		v_sub_f32_e32 v112, v118, v18
		v_sub_f32_e32 v113, v119, v18
		v_sub_f32_e32 v114, v120, v18
		v_sub_f32_e32 v115, v121, v18
		v_sub_f32_e32 v116, v122, v18
		v_sub_f32_e32 v117, v123, v18
		v_sub_f32_e32 v118, v124, v18
		v_sub_f32_e32 v119, v125, v18
		v_sub_f32_e32 v120, v126, v18
		v_sub_f32_e32 v121, v127, v18
		v_sub_f32_e32 v122, v128, v18
		v_sub_f32_e32 v123, v129, v18
		v_sub_f32_e32 v124, v130, v18
		v_sub_f32_e32 v125, v131, v18
		v_sub_f32_e32 v126, v132, v18
		v_sub_f32_e32 v127, v133, v18
		v_sub_f32_e32 v128, v134, v18
		v_sub_f32_e32 v129, v135, v18
		v_sub_f32_e32 v130, v136, v18
		v_sub_f32_e32 v131, v137, v18
		v_sub_f32_e32 v132, v138, v18
		v_sub_f32_e32 v133, v139, v18
		v_sub_f32_e32 v134, v140, v18
		v_sub_f32_e32 v135, v141, v18
		v_sub_f32_e32 v136, v142, v18
		v_sub_f32_e32 v137, v143, v18
		v_sub_f32_e32 v138, v144, v18
		v_sub_f32_e32 v139, v145, v18
		v_sub_f32_e32 v140, v146, v18
		v_sub_f32_e32 v141, v147, v18
		v_sub_f32_e32 v142, v156, v20
		v_sub_f32_e32 v143, v157, v20
		v_sub_f32_e32 v144, v158, v20
		v_sub_f32_e32 v145, v159, v20
		v_sub_f32_e32 v146, v176, v20
		v_sub_f32_e32 v147, v177, v20
		v_sub_f32_e32 v156, v178, v20
		v_sub_f32_e32 v157, v179, v20
		v_sub_f32_e32 v158, v180, v20
		v_sub_f32_e32 v159, v181, v20
		v_sub_f32_e32 v174, v182, v20
		v_sub_f32_e32 v175, v183, v20
		v_sub_f32_e32 v176, v184, v20
		v_sub_f32_e32 v177, v185, v20
		v_sub_f32_e32 v178, v186, v20
		v_sub_f32_e32 v179, v187, v20
		v_sub_f32_e32 v180, v188, v20
		v_sub_f32_e32 v181, v189, v20
		v_sub_f32_e32 v182, v190, v20
		v_sub_f32_e32 v183, v191, v20
		v_sub_f32_e32 v184, v192, v20
		v_sub_f32_e32 v185, v193, v20
		v_sub_f32_e32 v186, v194, v20
		v_sub_f32_e32 v187, v195, v20
		v_sub_f32_e32 v188, v196, v20
		v_sub_f32_e32 v189, v197, v20
		v_sub_f32_e32 v190, v198, v20
		v_sub_f32_e32 v191, v199, v20
		v_sub_f32_e32 v192, v200, v20
		v_sub_f32_e32 v193, v201, v20
		v_sub_f32_e32 v194, v202, v20
		v_sub_f32_e32 v195, v203, v20
		v_sub_f32_e32 v28, v28, v20
		v_sub_f32_e32 v29, v29, v20
		v_sub_f32_e32 v160, v160, v20
		v_sub_f32_e32 v161, v161, v20
		v_sub_f32_e32 v162, v162, v20
		v_sub_f32_e32 v163, v163, v20
		v_sub_f32_e32 v164, v164, v20
		v_sub_f32_e32 v165, v165, v20
		v_sub_f32_e32 v166, v166, v20
		v_sub_f32_e32 v167, v167, v20
		v_sub_f32_e32 v168, v168, v20
		v_sub_f32_e32 v169, v169, v20
		v_sub_f32_e32 v170, v170, v20
		v_sub_f32_e32 v171, v171, v20
		v_sub_f32_e32 v172, v172, v20
		v_sub_f32_e32 v173, v173, v20
		v_sub_f32_e32 v196, v204, v20
		v_sub_f32_e32 v197, v205, v20
		v_sub_f32_e32 v198, v206, v20
		v_sub_f32_e32 v199, v207, v20
		v_sub_f32_e32 v200, v208, v20
		v_sub_f32_e32 v201, v209, v20
		v_sub_f32_e32 v202, v210, v20
		v_sub_f32_e32 v203, v211, v20
		v_sub_f32_e32 v204, v212, v20
		v_sub_f32_e32 v205, v213, v20
		v_sub_f32_e32 v206, v214, v20
		v_sub_f32_e32 v207, v215, v20
		v_sub_f32_e32 v208, v216, v20
		v_sub_f32_e32 v209, v217, v20
		v_sub_f32_e32 v210, v218, v20
		v_sub_f32_e32 v211, v219, v20
		v_exp_f32_e32 v212, v23
		v_exp_f32_e32 v214, v25
		v_exp_f32_e32 v213, v26
		v_exp_f32_e32 v215, v27
		v_exp_f32_e32 v26, v65
		v_exp_f32_e32 v216, v67
		v_exp_f32_e32 v27, v70
		v_exp_f32_e32 v217, v71
		v_exp_f32_e32 v70, v30
		v_exp_f32_e32 v218, v31
		v_exp_f32_e32 v71, v72
		v_exp_f32_e32 v219, v73
		v_exp_f32_e32 v30, v74
		v_exp_f32_e32 v72, v75
		v_exp_f32_e32 v31, v76
		v_exp_f32_e32 v73, v77
		v_exp_f32_e32 v74, v78
		v_exp_f32_e32 v76, v79
		v_exp_f32_e32 v75, v96
		v_exp_f32_e32 v77, v97
		v_exp_f32_e32 v78, v98
		v_exp_f32_e32 v96, v99
		v_exp_f32_e32 v79, v100
		v_exp_f32_e32 v97, v101
		v_exp_f32_e32 v98, v102
		v_exp_f32_e32 v100, v103
		v_exp_f32_e32 v99, v104
		v_exp_f32_e32 v101, v105
		v_exp_f32_e32 v102, v106
		v_exp_f32_e32 v104, v107
		v_exp_f32_e32 v103, v108
		v_exp_f32_e32 v105, v109
		v_exp_f32_e32 v106, v110
		v_exp_f32_e32 v108, v111
		v_exp_f32_e32 v107, v112
		v_exp_f32_e32 v109, v113
		v_exp_f32_e32 v110, v114
		v_exp_f32_e32 v112, v115
		v_exp_f32_e32 v111, v116
		v_exp_f32_e32 v113, v117
		v_exp_f32_e32 v114, v118
		v_exp_f32_e32 v116, v119
		v_exp_f32_e32 v115, v120
		v_exp_f32_e32 v117, v121
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
		v_exp_f32_e32 v134, v138
		v_exp_f32_e32 v136, v139
		v_exp_f32_e32 v135, v140
		v_exp_f32_e32 v137, v141
		v_exp_f32_e32 v139, v142
		v_exp_f32_e32 v141, v143
		v_exp_f32_e32 v142, v144
		v_exp_f32_e32 v220, v145
		v_exp_f32_e32 v143, v146
		v_exp_f32_e32 v221, v147
		v_exp_f32_e32 v144, v156
		v_exp_f32_e32 v146, v157
		v_exp_f32_e32 v145, v158
		v_exp_f32_e32 v147, v159
		v_exp_f32_e32 v156, v174
		v_exp_f32_e32 v158, v175
		v_exp_f32_e32 v157, v176
		v_exp_f32_e32 v159, v177
		v_exp_f32_e32 v174, v178
		v_exp_f32_e32 v176, v179
		v_exp_f32_e32 v175, v180
		v_exp_f32_e32 v177, v181
		v_exp_f32_e32 v178, v182
		v_exp_f32_e32 v180, v183
		v_exp_f32_e32 v179, v184
		v_exp_f32_e32 v181, v185
		v_exp_f32_e32 v182, v186
		v_exp_f32_e32 v184, v187
		v_exp_f32_e32 v183, v188
		v_exp_f32_e32 v185, v189
		v_exp_f32_e32 v186, v190
		v_exp_f32_e32 v188, v191
		v_exp_f32_e32 v187, v192
		v_exp_f32_e32 v189, v193
		v_exp_f32_e32 v190, v194
		v_exp_f32_e32 v192, v195
		v_exp_f32_e32 v191, v28
		v_exp_f32_e32 v193, v29
		v_exp_f32_e32 v28, v160
		v_exp_f32_e32 v194, v161
		v_exp_f32_e32 v29, v162
		v_exp_f32_e32 v195, v163
		v_exp_f32_e32 v160, v164
		v_exp_f32_e32 v162, v165
		v_exp_f32_e32 v161, v166
		v_exp_f32_e32 v163, v167
		v_exp_f32_e32 v164, v168
		v_exp_f32_e32 v166, v169
		v_exp_f32_e32 v165, v170
		v_exp_f32_e32 v167, v171
		v_exp_f32_e32 v168, v172
		v_exp_f32_e32 v170, v173
		v_exp_f32_e32 v169, v196
		v_exp_f32_e32 v171, v197
		v_exp_f32_e32 v172, v198
		v_exp_f32_e32 v196, v199
		v_exp_f32_e32 v173, v200
		v_exp_f32_e32 v197, v201
		v_exp_f32_e32 v198, v202
		v_exp_f32_e32 v200, v203
		v_exp_f32_e32 v199, v204
		v_exp_f32_e32 v201, v205
		v_exp_f32_e32 v202, v206
		v_exp_f32_e32 v204, v207
		v_exp_f32_e32 v203, v208
		v_exp_f32_e32 v205, v209
		v_exp_f32_e32 v206, v210
		v_exp_f32_e32 v208, v211
		v_pk_add_f32 v[210:211], v[212:213], v[214:215]
		v_pk_add_f32 v[222:223], v[26:27], v[216:217]
		v_pk_add_f32 v[224:225], v[70:71], v[218:219]
		v_pk_add_f32 v[226:227], v[30:31], v[72:73]
		v_pk_add_f32 v[228:229], v[74:75], v[76:77]
		v_pk_add_f32 v[230:231], v[78:79], v[96:97]
		v_pk_add_f32 v[232:233], v[98:99], v[100:101]
		v_pk_add_f32 v[234:235], v[102:103], v[104:105]
		v_pk_add_f32 v[236:237], v[106:107], v[108:109]
		v_pk_add_f32 v[238:239], v[110:111], v[112:113]
		v_pk_add_f32 v[240:241], v[114:115], v[116:117]
		v_pk_add_f32 v[242:243], v[118:119], v[120:121]
		v_pk_add_f32 v[244:245], v[122:123], v[124:125]
		v_pk_add_f32 v[246:247], v[126:127], v[128:129]
		v_pk_add_f32 v[248:249], v[130:131], v[132:133]
		v_pk_add_f32 v[250:251], v[134:135], v[136:137]
		v_mov_b32_e32 v252, v211
		v_mov_b32_e32 v253, v223
		v_mov_b32_e32 v254, v210
		v_mov_b32_e32 v255, v222
		v_pk_add_f32 v[210:211], v[254:255], v[252:253]
		v_mov_b32_e32 v222, v225
		v_mov_b32_e32 v223, v227
		v_mov_b32_e32 v252, v224
		v_mov_b32_e32 v253, v226
		v_pk_add_f32 v[224:225], v[252:253], v[222:223]
		v_mov_b32_e32 v222, v229
		v_mov_b32_e32 v223, v231
		v_mov_b32_e32 v226, v228
		v_mov_b32_e32 v227, v230
		v_pk_add_f32 v[228:229], v[226:227], v[222:223]
		v_mov_b32_e32 v222, v233
		v_mov_b32_e32 v223, v235
		v_mov_b32_e32 v226, v232
		v_mov_b32_e32 v227, v234
		v_pk_add_f32 v[230:231], v[226:227], v[222:223]
		v_mov_b32_e32 v222, v237
		v_mov_b32_e32 v223, v239
		v_mov_b32_e32 v226, v236
		v_mov_b32_e32 v227, v238
		v_pk_add_f32 v[232:233], v[226:227], v[222:223]
		v_mov_b32_e32 v222, v241
		v_mov_b32_e32 v223, v243
		v_mov_b32_e32 v226, v240
		v_mov_b32_e32 v227, v242
		v_pk_add_f32 v[234:235], v[226:227], v[222:223]
		v_mov_b32_e32 v222, v245
		v_mov_b32_e32 v223, v247
		v_mov_b32_e32 v226, v244
		v_mov_b32_e32 v227, v246
		v_pk_add_f32 v[236:237], v[226:227], v[222:223]
		v_mov_b32_e32 v222, v249
		v_mov_b32_e32 v223, v251
		v_mov_b32_e32 v226, v248
		v_mov_b32_e32 v227, v250
		v_pk_add_f32 v[238:239], v[226:227], v[222:223]
		v_mov_b32_e32 v222, v211
		v_mov_b32_e32 v223, v225
		v_mov_b32_e32 v226, v210
		v_mov_b32_e32 v227, v224
		v_pk_add_f32 v[210:211], v[226:227], v[222:223]
		v_mov_b32_e32 v222, v229
		v_mov_b32_e32 v223, v231
		v_mov_b32_e32 v224, v228
		v_mov_b32_e32 v225, v230
		v_pk_add_f32 v[226:227], v[224:225], v[222:223]
		v_mov_b32_e32 v222, v233
		v_mov_b32_e32 v223, v235
		v_mov_b32_e32 v224, v232
		v_mov_b32_e32 v225, v234
		v_pk_add_f32 v[228:229], v[224:225], v[222:223]
		v_mov_b32_e32 v222, v237
		v_mov_b32_e32 v223, v239
		v_mov_b32_e32 v224, v236
		v_mov_b32_e32 v225, v238
		v_pk_add_f32 v[230:231], v[224:225], v[222:223]
		v_mov_b32_e32 v222, v211
		v_mov_b32_e32 v223, v227
		v_mov_b32_e32 v224, v210
		v_mov_b32_e32 v225, v226
		v_pk_add_f32 v[210:211], v[224:225], v[222:223]
		v_mov_b32_e32 v222, v229
		v_mov_b32_e32 v223, v231
		v_mov_b32_e32 v224, v228
		v_mov_b32_e32 v225, v230
		v_pk_add_f32 v[226:227], v[224:225], v[222:223]
		v_mov_b32_e32 v222, v211
		v_mov_b32_e32 v223, v227
		v_mov_b32_e32 v224, v210
		v_mov_b32_e32 v225, v226
		v_pk_add_f32 v[210:211], v[224:225], v[222:223]
		v_add_f32_e32 v23, v210, v211
		ds_bpermute_b32 v138, v19, v23
		ds_bpermute_b32 v140, v22, v23
		v_pk_add_f32 v[210:211], v[142:143], v[220:221]
		v_pk_add_f32 v[222:223], v[144:145], v[146:147]
		v_pk_add_f32 v[224:225], v[156:157], v[158:159]
		v_pk_add_f32 v[226:227], v[174:175], v[176:177]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[228:229], v[138:139], v[140:141]
		v_pk_add_f32 v[230:231], v[178:179], v[180:181]
		v_pk_add_f32 v[232:233], v[182:183], v[184:185]
		v_pk_add_f32 v[234:235], v[186:187], v[188:189]
		v_pk_add_f32 v[236:237], v[190:191], v[192:193]
		v_pk_add_f32 v[238:239], v[28:29], v[194:195]
		v_pk_add_f32 v[240:241], v[160:161], v[162:163]
		v_pk_add_f32 v[242:243], v[164:165], v[166:167]
		v_pk_add_f32 v[244:245], v[168:169], v[170:171]
		v_pk_add_f32 v[246:247], v[172:173], v[196:197]
		v_pk_add_f32 v[248:249], v[198:199], v[200:201]
		v_pk_add_f32 v[250:251], v[202:203], v[204:205]
		v_mov_b32_e32 v207, v229
		v_mov_b32_e32 v209, v210
		v_pk_add_f32 v[252:253], v[206:207], v[208:209]
		v_mov_b32_e32 v254, v211
		v_mov_b32_e32 v255, v224
		v_pk_add_f32 v[210:211], v[254:255], v[222:223]
		v_mov_b32_e32 v222, v225
		v_mov_b32_e32 v223, v230
		v_pk_add_f32 v[222:223], v[222:223], v[226:227]
		v_mov_b32_e32 v224, v231
		v_mov_b32_e32 v225, v234
		v_pk_add_f32 v[226:227], v[224:225], v[232:233]
		v_mov_b32_e32 v224, v235
		v_mov_b32_e32 v225, v238
		v_pk_add_f32 v[224:225], v[224:225], v[236:237]
		v_mov_b32_e32 v230, v239
		v_mov_b32_e32 v231, v242
		v_pk_add_f32 v[232:233], v[230:231], v[240:241]
		v_mov_b32_e32 v230, v243
		v_mov_b32_e32 v231, v246
		v_pk_add_f32 v[230:231], v[230:231], v[244:245]
		v_mov_b32_e32 v234, v247
		v_mov_b32_e32 v235, v250
		v_pk_add_f32 v[236:237], v[234:235], v[248:249]
		v_mov_b32_e32 v234, v251
		v_mov_b32_e32 v235, v210
		v_pk_add_f32 v[234:235], v[234:235], v[252:253]
		v_mov_b32_e32 v238, v211
		v_mov_b32_e32 v239, v226
		v_pk_add_f32 v[210:211], v[238:239], v[222:223]
		v_mov_b32_e32 v222, v227
		v_mov_b32_e32 v223, v232
		v_pk_add_f32 v[222:223], v[222:223], v[224:225]
		v_mov_b32_e32 v224, v233
		v_mov_b32_e32 v225, v236
		v_pk_add_f32 v[226:227], v[224:225], v[230:231]
		v_mov_b32_e32 v224, v237
		v_mov_b32_e32 v225, v210
		v_pk_add_f32 v[224:225], v[224:225], v[234:235]
		v_mov_b32_e32 v230, v211
		v_mov_b32_e32 v231, v226
		v_pk_add_f32 v[210:211], v[230:231], v[222:223]
		v_mov_b32_e32 v222, v227
		v_mov_b32_e32 v223, v210
		v_pk_add_f32 v[226:227], v[222:223], v[224:225]
		v_add_f32_e32 v23, v211, v226
		v_add_f32_e32 v23, v227, v23
		ds_bpermute_b32 v25, v19, v23
		ds_bpermute_b32 v19, v22, v23
		v_sub_f32_e32 v15, v15, v18
		v_sub_f32_e32 v14, v14, v20
		v_exp_f32_e32 v22, v15
		v_exp_f32_e32 v210, v14
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v15, v25, v19
		v_mov_b32_e32 v23, v22
		v_pk_mul_f32 v[32:33], v[32:33], v[22:23]
		v_pk_mul_f32 v[34:35], v[34:35], v[22:23]
		v_pk_mul_f32 v[36:37], v[36:37], v[22:23]
		v_pk_mul_f32 v[38:39], v[38:39], v[22:23]
		v_pk_mul_f32 v[40:41], v[40:41], v[22:23]
		v_pk_mul_f32 v[42:43], v[42:43], v[22:23]
		v_pk_mul_f32 v[44:45], v[44:45], v[22:23]
		v_pk_mul_f32 v[46:47], v[46:47], v[22:23]
		v_pk_mul_f32 v[48:49], v[48:49], v[22:23]
		v_pk_mul_f32 v[50:51], v[50:51], v[22:23]
		v_pk_mul_f32 v[52:53], v[52:53], v[22:23]
		v_pk_mul_f32 v[54:55], v[54:55], v[22:23]
		v_pk_mul_f32 v[56:57], v[56:57], v[22:23]
		v_pk_mul_f32 v[58:59], v[58:59], v[22:23]
		v_pk_mul_f32 v[60:61], v[60:61], v[22:23]
		v_pk_mul_f32 v[62:63], v[62:63], v[22:23]
		v_mov_b32_e32 v211, v210
		v_pk_mul_f32 v[80:81], v[80:81], v[210:211]
		v_pk_mul_f32 v[82:83], v[82:83], v[210:211]
		v_pk_mul_f32 v[84:85], v[84:85], v[210:211]
		v_pk_mul_f32 v[86:87], v[86:87], v[210:211]
		v_pk_mul_f32 v[88:89], v[88:89], v[210:211]
		v_pk_mul_f32 v[90:91], v[90:91], v[210:211]
		v_pk_mul_f32 v[92:93], v[92:93], v[210:211]
		v_pk_mul_f32 v[94:95], v[94:95], v[210:211]
		v_accvgpr_read_b32 v222, a48
		v_accvgpr_read_b32 v223, a49
		v_pk_mul_f32 v[222:223], v[222:223], v[210:211]
		v_accvgpr_write_b32 a48, v222
		v_accvgpr_write_b32 a49, v223
		v_accvgpr_read_b32 v222, a50
		v_accvgpr_read_b32 v223, a51
		v_pk_mul_f32 v[222:223], v[222:223], v[210:211]
		v_accvgpr_write_b32 a50, v222
		v_accvgpr_write_b32 a51, v223
		v_accvgpr_read_b32 v222, a52
		v_accvgpr_read_b32 v223, a53
		v_pk_mul_f32 v[222:223], v[222:223], v[210:211]
		v_accvgpr_write_b32 a52, v222
		v_accvgpr_write_b32 a53, v223
		v_accvgpr_read_b32 v222, a54
		v_accvgpr_read_b32 v223, a55
		v_pk_mul_f32 v[222:223], v[222:223], v[210:211]
		v_accvgpr_write_b32 a54, v222
		v_accvgpr_write_b32 a55, v223
		v_accvgpr_read_b32 v222, a56
		v_accvgpr_read_b32 v223, a57
		v_pk_mul_f32 v[222:223], v[222:223], v[210:211]
		v_accvgpr_write_b32 a56, v222
		v_accvgpr_write_b32 a57, v223
		v_accvgpr_read_b32 v222, a58
		v_accvgpr_read_b32 v223, a59
		v_pk_mul_f32 v[222:223], v[222:223], v[210:211]
		v_accvgpr_write_b32 a58, v222
		v_accvgpr_write_b32 a59, v223
		v_accvgpr_read_b32 v222, a60
		v_accvgpr_read_b32 v223, a61
		v_pk_mul_f32 v[222:223], v[222:223], v[210:211]
		v_accvgpr_write_b32 a60, v222
		v_accvgpr_write_b32 a61, v223
		v_accvgpr_read_b32 v222, a62
		v_accvgpr_read_b32 v223, a63
		v_pk_mul_f32 v[222:223], v[222:223], v[210:211]
		v_accvgpr_write_b32 a62, v222
		v_accvgpr_write_b32 a63, v223
		v_mov_b32_e32 v14, v228
		v_mov_b32_e32 v222, v22
		v_mov_b32_e32 v223, v210
		v_mov_b64_e32 v[22:23], v[16:17]
		v_pk_fma_f32 v[16:17], v[22:23], v[222:223], v[14:15]
		v_cvt_pk_bf16_f32 v224, v212, v214
		v_cvt_pk_bf16_f32 v225, v213, v215
		v_cvt_pk_bf16_f32 v226, v26, v216
		v_cvt_pk_bf16_f32 v227, v27, v217
		v_cvt_pk_bf16_f32 v212, v70, v218
		v_cvt_pk_bf16_f32 v213, v71, v219
		v_cvt_pk_bf16_f32 v214, v30, v72
		v_cvt_pk_bf16_f32 v215, v31, v73
		v_cvt_pk_bf16_f32 v216, v74, v76
		v_cvt_pk_bf16_f32 v217, v75, v77
		v_cvt_pk_bf16_f32 v218, v78, v96
		v_cvt_pk_bf16_f32 v219, v79, v97
		v_cvt_pk_bf16_f32 v72, v98, v100
		v_cvt_pk_bf16_f32 v73, v99, v101
		v_cvt_pk_bf16_f32 v74, v102, v104
		v_cvt_pk_bf16_f32 v75, v103, v105
		v_cvt_pk_bf16_f32 v76, v106, v108
		v_cvt_pk_bf16_f32 v77, v107, v109
		v_cvt_pk_bf16_f32 v78, v110, v112
		v_cvt_pk_bf16_f32 v79, v111, v113
		v_cvt_pk_bf16_f32 v96, v114, v116
		v_cvt_pk_bf16_f32 v97, v115, v117
		v_cvt_pk_bf16_f32 v98, v118, v120
		v_cvt_pk_bf16_f32 v99, v119, v121
		v_cvt_pk_bf16_f32 v100, v122, v124
		v_cvt_pk_bf16_f32 v101, v123, v125
		v_cvt_pk_bf16_f32 v102, v126, v128
		v_cvt_pk_bf16_f32 v103, v127, v129
		v_cvt_pk_bf16_f32 v104, v130, v132
		v_cvt_pk_bf16_f32 v105, v131, v133
		v_cvt_pk_bf16_f32 v106, v134, v136
		v_cvt_pk_bf16_f32 v107, v135, v137
		v_cvt_pk_bf16_f32 v108, v139, v141
		v_cvt_pk_bf16_f32 v109, v142, v220
		v_cvt_pk_bf16_f32 v110, v143, v221
		v_cvt_pk_bf16_f32 v111, v144, v146
		v_cvt_pk_bf16_f32 v112, v145, v147
		v_cvt_pk_bf16_f32 v113, v156, v158
		v_cvt_pk_bf16_f32 v114, v157, v159
		v_cvt_pk_bf16_f32 v115, v174, v176
		v_cvt_pk_bf16_f32 v116, v175, v177
		v_cvt_pk_bf16_f32 v117, v178, v180
		v_cvt_pk_bf16_f32 v118, v179, v181
		v_cvt_pk_bf16_f32 v119, v182, v184
		v_cvt_pk_bf16_f32 v120, v183, v185
		v_cvt_pk_bf16_f32 v121, v186, v188
		v_cvt_pk_bf16_f32 v122, v187, v189
		v_cvt_pk_bf16_f32 v123, v190, v192
		v_cvt_pk_bf16_f32 v124, v191, v193
		v_cvt_pk_bf16_f32 v125, v28, v194
		v_cvt_pk_bf16_f32 v126, v29, v195
		v_cvt_pk_bf16_f32 v127, v160, v162
		v_cvt_pk_bf16_f32 v28, v161, v163
		v_cvt_pk_bf16_f32 v29, v164, v166
		v_cvt_pk_bf16_f32 v30, v165, v167
		v_cvt_pk_bf16_f32 v31, v168, v170
		v_cvt_pk_bf16_f32 v128, v169, v171
		v_cvt_pk_bf16_f32 v129, v172, v196
		v_cvt_pk_bf16_f32 v130, v173, v197
		v_cvt_pk_bf16_f32 v131, v198, v200
		v_cvt_pk_bf16_f32 v132, v199, v201
		v_cvt_pk_bf16_f32 v133, v202, v204
		v_cvt_pk_bf16_f32 v134, v203, v205
		v_cvt_pk_bf16_f32 v135, v206, v208
		v_permlane32_swap_b32_e32 v224, v226
		v_permlane32_swap_b32_e32 v225, v227
		v_permlane32_swap_b32_e32 v212, v214
		v_permlane32_swap_b32_e32 v213, v215
		v_permlane32_swap_b32_e32 v216, v218
		v_permlane32_swap_b32_e32 v217, v219
		v_mfma_f32_32x32x16_bf16 v[32:47], v[148:151], v[224:227], v[32:47]
		v_permlane32_swap_b32_e32 v72, v74
		v_permlane32_swap_b32_e32 v73, v75
		v_permlane32_swap_b32_e32 v76, v78
		v_permlane32_swap_b32_e32 v77, v79
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[48:63], v[152:155], v[224:227], v[48:63]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 a[48:63], v[152:155], v[108:111], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], v[148:151], v[108:111], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[0:3], v[212:215], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[76:79], v[212:215], v[48:63]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[76:79], v[112:115], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[0:3], v[112:115], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[36:39], v[216:219], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[80:83], v[216:219], v[48:63]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[80:83], v[116:119], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[36:39], v[116:119], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[40:43], v[72:75], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[84:87], v[72:75], v[48:63]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[84:87], v[120:123], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[40:43], v[120:123], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[44:47], v[76:79], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[88:91], v[76:79], v[48:63]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[88:91], v[124:127], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[44:47], v[124:127], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[64:67], v[96:99], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[92:95], v[96:99], v[48:63]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[92:95], v[28:31], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[64:67], v[28:31], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[68:71], v[100:103], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[96:99], v[100:103], v[48:63]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[96:99], v[128:131], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[68:71], v[128:131], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[72:75], v[104:107], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[100:103], v[104:107], v[48:63]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[100:103], v[132:135], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[72:75], v[132:135], v[80:95]
		s_mov_b32 s44, s46
		v_mov_b32_e32 v15, v18
		v_mov_b32_e32 v14, v20
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_3
.L_attn_fwd_persistent.loop_exit_3:
		s_cmp_lt_i32 s43, s42
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_4
.L_attn_fwd_persistent.loop_head_4:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s26, s43, 0x80
		s_cmp_lt_i32 s43, 0
		s_cselect_b32 s40, s27, 0
		s_add_i32 s40, s43, s40
		s_ashr_i32 s40, s40, 7
		s_cmp_lt_i32 s40, 0
		s_cselect_b32 s44, s16, 0
		s_add_i32 s44, s40, s44
		s_ashr_i32 s44, s44, 1
		s_lshl_b32 s44, s44, 1
		s_xor_b32 s44, s44, -1
		s_add_i32 s44, s44, 1
		s_add_i32 s44, s40, s44
		s_add_i32 s40, s40, 1
		s_cmp_lt_i32 s40, 0
		s_cselect_b32 s46, s16, 0
		s_add_i32 s46, s40, s46
		s_ashr_i32 s46, s46, 1
		s_lshl_b32 s46, s46, 1
		s_xor_b32 s46, s46, -1
		s_add_i32 s46, s46, 1
		s_add_i32 s52, s40, s46
		s_mul_i32 s40, 0x4100, s44
		v_and_b32_e32 v18, 63, v0
		v_lshrrev_b32_e32 v19, 5, v18
		v_and_b32_e32 v18, 31, v18
		v_lshrrev_b32_e32 v20, 4, v18
		v_lshlrev_b32_e32 v20, 9, v20
		v_lshl_add_u32 v19, v19, 4, v20
		v_lshrrev_b32_e32 v20, 3, v18
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v22, 0x2080
		v_mul_lo_u32 v22, v22, v20
		v_lshrrev_b32_e32 v20, 2, v18
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v23, 0x1040
		v_mul_lo_u32 v23, v23, v20
		v_add3_u32 v19, v19, v22, v23
		v_lshrrev_b32_e32 v20, 1, v18
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v22, 0x820
		v_mul_lo_u32 v22, v22, v20
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v20, 0x410
		v_mul_lo_u32 v20, v20, v18
		v_add3_u32 v18, v19, v22, v20
		v_add_u32_e32 v18, s40, v18
		ds_read_b128 v[28:31], v18
		ds_read_b128 v[72:75], v18 offset:32
		ds_read_b128 v[76:79], v18 offset:64
		ds_read_b128 v[96:99], v18 offset:96
		ds_read_b128 v[100:103], v18 offset:256
		ds_read_b128 v[104:107], v18 offset:288
		ds_read_b128 v[108:111], v18 offset:320
		ds_read_b128 v[112:115], v18 offset:352
		ds_read_b128 v[116:119], v18 offset:128
		ds_read_b128 v[120:123], v18 offset:160
		ds_read_b128 v[124:127], v18 offset:192
		ds_read_b128 v[128:131], v18 offset:224
		ds_read_b128 v[132:135], v18 offset:384
		ds_read_b128 v[136:139], v18 offset:416
		ds_read_b128 v[140:143], v18 offset:448
		ds_read_b128 v[144:147], v18 offset:480
		s_mul_i32 s40, 0x4400, s44
		v_and_b32_e32 v18, 63, v0
		v_and_b32_e32 v19, 15, v18
		v_and_b32_e32 v20, 3, v19
		v_lshrrev_b32_e32 v22, 5, v18
		v_mov_b32_e32 v23, 0x2200
		v_mul_lo_u32 v23, v23, v22
		v_and_b32_e32 v18, 31, v18
		v_lshrrev_b32_e32 v18, 4, v18
		v_lshlrev_b32_e32 v18, 5, v18
		v_lshrrev_b32_e32 v19, 2, v19
		v_mov_b32_e32 v22, 0x440
		v_mul_lo_u32 v22, v22, v19
		v_add3_u32 v18, v23, v18, v22
		v_lshl_add_u32 v18, v20, 3, v18
		v_add_u32_e32 v18, s40, v18
		ds_read_b64_tr_b16 v[148:149], v18 offset:33264
		ds_read_b64_tr_b16 v[150:151], v18 offset:37616
		ds_read_b64_tr_b16 a[0:1], v18 offset:33392
		ds_read_b64_tr_b16 a[2:3], v18 offset:37744
		ds_read_b64_tr_b16 a[36:37], v18 offset:33520
		ds_read_b64_tr_b16 a[38:39], v18 offset:37872
		ds_read_b64_tr_b16 a[40:41], v18 offset:33648
		ds_read_b64_tr_b16 a[42:43], v18 offset:38000
		ds_read_b64_tr_b16 a[44:45], v18 offset:33776
		ds_read_b64_tr_b16 a[46:47], v18 offset:38128
		ds_read_b64_tr_b16 a[64:65], v18 offset:33904
		ds_read_b64_tr_b16 a[66:67], v18 offset:38256
		ds_read_b64_tr_b16 a[68:69], v18 offset:34032
		ds_read_b64_tr_b16 a[70:71], v18 offset:38384
		ds_read_b64_tr_b16 a[72:73], v18 offset:34160
		ds_read_b64_tr_b16 a[74:75], v18 offset:38512
		ds_read_b64_tr_b16 v[152:153], v18 offset:33328
		ds_read_b64_tr_b16 v[154:155], v18 offset:37680
		ds_read_b64_tr_b16 a[76:77], v18 offset:33456
		ds_read_b64_tr_b16 a[78:79], v18 offset:37808
		ds_read_b64_tr_b16 a[80:81], v18 offset:33584
		ds_read_b64_tr_b16 a[82:83], v18 offset:37936
		ds_read_b64_tr_b16 a[84:85], v18 offset:33712
		ds_read_b64_tr_b16 a[86:87], v18 offset:38064
		ds_read_b64_tr_b16 a[88:89], v18 offset:33840
		ds_read_b64_tr_b16 a[90:91], v18 offset:38192
		ds_read_b64_tr_b16 a[92:93], v18 offset:33968
		ds_read_b64_tr_b16 a[94:95], v18 offset:38320
		ds_read_b64_tr_b16 a[96:97], v18 offset:34096
		ds_read_b64_tr_b16 a[98:99], v18 offset:38448
		ds_read_b64_tr_b16 a[100:101], v18 offset:34224
		ds_read_b64_tr_b16 a[102:103], v18 offset:38576
		s_cmp_lt_i32 s26, s21
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_2
		s_waitcnt vmcnt(0) lgkmcnt(14)
		s_barrier
		v_lshrrev_b32_e32 v18, 3, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v19, 64
		v_mul_lo_u32 v19, v19, v18
		v_lshrrev_b32_e32 v18, 4, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v20, 32
		v_mul_lo_u32 v20, v20, v18
		v_lshrrev_b32_e32 v18, 5, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v22, 16
		v_mul_lo_u32 v22, v22, v18
		v_bitop3_b32 v18, v19, v20, v22 bitop3:0x96
		v_lshrrev_b32_e32 v19, 6, v0
		v_and_b32_e32 v19, 1, v19
		v_lshrrev_b32_e32 v20, 7, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v22, 2
		v_mul_lo_u32 v22, v22, v20
		v_bitop3_b32 v18, v18, v19, v22 bitop3:0x96
		v_add_u32_e32 v18, s26, v18
		v_lshrrev_b32_e32 v19, 3, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 64
		v_mul_lo_u32 v20, v20, v19
		v_lshrrev_b32_e32 v19, 4, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v22, 32
		v_mul_lo_u32 v22, v22, v19
		v_bitop3_b32 v19, 4, v20, v22 bitop3:0x96
		v_lshrrev_b32_e32 v20, 5, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v22, 16
		v_mul_lo_u32 v22, v22, v20
		v_xor_b32_e32 v19, v19, v22
		v_lshrrev_b32_e32 v20, 6, v0
		v_and_b32_e32 v20, 1, v20
		v_lshrrev_b32_e32 v22, 7, v0
		v_and_b32_e32 v22, 1, v22
		v_mov_b32_e32 v23, 2
		v_mul_lo_u32 v23, v23, v22
		v_bitop3_b32 v19, v19, v20, v23 bitop3:0x96
		v_add_u32_e32 v19, s26, v19
		v_lshrrev_b32_e32 v20, 3, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v22, 64
		v_mul_lo_u32 v22, v22, v20
		v_lshrrev_b32_e32 v20, 4, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v23, 32
		v_mul_lo_u32 v23, v23, v20
		v_bitop3_b32 v20, 8, v22, v23 bitop3:0x96
		v_lshrrev_b32_e32 v22, 5, v0
		v_and_b32_e32 v22, 1, v22
		v_mov_b32_e32 v23, 16
		v_mul_lo_u32 v23, v23, v22
		v_xor_b32_e32 v20, v20, v23
		v_lshrrev_b32_e32 v22, 6, v0
		v_and_b32_e32 v22, 1, v22
		v_lshrrev_b32_e32 v23, 7, v0
		v_and_b32_e32 v23, 1, v23
		v_mov_b32_e32 v25, 2
		v_mul_lo_u32 v25, v25, v23
		v_bitop3_b32 v20, v20, v22, v25 bitop3:0x96
		v_add_u32_e32 v20, s26, v20
		v_lshrrev_b32_e32 v22, 3, v0
		v_and_b32_e32 v22, 1, v22
		v_mov_b32_e32 v23, 64
		v_mul_lo_u32 v23, v23, v22
		v_lshrrev_b32_e32 v22, 4, v0
		v_and_b32_e32 v22, 1, v22
		v_mov_b32_e32 v25, 32
		v_mul_lo_u32 v25, v25, v22
		v_bitop3_b32 v22, 12, v23, v25 bitop3:0x96
		v_lshrrev_b32_e32 v23, 5, v0
		v_and_b32_e32 v23, 1, v23
		v_mov_b32_e32 v25, 16
		v_mul_lo_u32 v25, v25, v23
		v_xor_b32_e32 v22, v22, v25
		v_lshrrev_b32_e32 v23, 6, v0
		v_and_b32_e32 v23, 1, v23
		v_lshrrev_b32_e32 v25, 7, v0
		v_and_b32_e32 v25, 1, v25
		v_mov_b32_e32 v26, 2
		v_mul_lo_u32 v26, v26, v25
		v_bitop3_b32 v22, v22, v23, v26 bitop3:0x96
		v_add_u32_e32 v22, s26, v22
		v_cmp_lt_i32_e64 vcc, v18, s23
		s_mov_b64 s[46:47], vcc
		v_cmp_lt_i32_e64 vcc, v19, s23
		s_mov_b64 s[54:55], vcc
		v_cmp_lt_i32_e64 vcc, v20, s23
		s_mov_b64 s[58:59], vcc
		v_cmp_lt_i32_e64 vcc, v22, s23
		s_mov_b64 s[60:61], vcc
		v_lshrrev_b32_e32 v18, 3, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v19, 16
		v_mul_lo_u32 v19, v19, v18
		v_lshrrev_b32_e32 v18, 4, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v20, 32
		v_mul_lo_u32 v20, v20, v18
		v_lshrrev_b32_e32 v18, 5, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v22, 64
		v_mul_lo_u32 v22, v22, v18
		v_bitop3_b32 v18, v19, v20, v22 bitop3:0x96
		v_lshrrev_b32_e32 v19, 6, v0
		v_and_b32_e32 v19, 1, v19
		v_lshrrev_b32_e32 v20, 7, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v22, 2
		v_mul_lo_u32 v22, v22, v20
		v_bitop3_b32 v18, v18, v19, v22 bitop3:0x96
		v_add_u32_e32 v18, s26, v18
		v_lshrrev_b32_e32 v19, 3, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 16
		v_mul_lo_u32 v20, v20, v19
		v_lshrrev_b32_e32 v19, 4, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v22, 32
		v_mul_lo_u32 v22, v22, v19
		v_bitop3_b32 v19, 4, v20, v22 bitop3:0x96
		v_lshrrev_b32_e32 v20, 5, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v22, 64
		v_mul_lo_u32 v22, v22, v20
		v_xor_b32_e32 v19, v19, v22
		v_lshrrev_b32_e32 v20, 6, v0
		v_and_b32_e32 v20, 1, v20
		v_lshrrev_b32_e32 v22, 7, v0
		v_and_b32_e32 v22, 1, v22
		v_mov_b32_e32 v23, 2
		v_mul_lo_u32 v23, v23, v22
		v_bitop3_b32 v19, v19, v20, v23 bitop3:0x96
		v_add_u32_e32 v19, s26, v19
		v_lshrrev_b32_e32 v20, 3, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v22, 16
		v_mul_lo_u32 v22, v22, v20
		v_lshrrev_b32_e32 v20, 4, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v23, 32
		v_mul_lo_u32 v23, v23, v20
		v_bitop3_b32 v20, 8, v22, v23 bitop3:0x96
		v_lshrrev_b32_e32 v22, 5, v0
		v_and_b32_e32 v22, 1, v22
		v_mov_b32_e32 v23, 64
		v_mul_lo_u32 v23, v23, v22
		v_xor_b32_e32 v20, v20, v23
		v_lshrrev_b32_e32 v22, 6, v0
		v_and_b32_e32 v22, 1, v22
		v_lshrrev_b32_e32 v23, 7, v0
		v_and_b32_e32 v23, 1, v23
		v_mov_b32_e32 v25, 2
		v_mul_lo_u32 v25, v25, v23
		v_bitop3_b32 v20, v20, v22, v25 bitop3:0x96
		v_add_u32_e32 v20, s26, v20
		v_cmp_lt_i32_e64 vcc, v18, s23
		s_mov_b64 s[62:63], vcc
		v_cmp_lt_i32_e64 vcc, v19, s23
		s_mov_b64 s[64:65], vcc
		v_cmp_lt_i32_e64 vcc, v20, s23
		s_mov_b64 s[66:67], vcc
		s_mul_i32 s40, s15, s43
		s_lshl_b32 s40, s40, 1
		s_lshl_b32 s44, s15, 8
		s_mul_i32 s53, s1, s13
		s_lshl_b32 s53, s53, 1
		s_add_i32 s44, s44, s53
		s_mul_i32 s53, s24, s14
		s_lshl_b32 s53, s53, 1
		s_add_i32 s44, s44, s53
		s_add_i32 s44, s44, s40
		v_lshrrev_b32_e32 v18, 4, v0
		v_and_b32_e32 v18, 1, v18
		v_mul_lo_u32 v18, s15, v18
		v_lshrrev_b32_e32 v19, 5, v0
		v_and_b32_e32 v19, 1, v19
		v_mul_lo_u32 v19, s15, v19
		v_lshrrev_b32_e32 v20, 7, v0
		v_mul_lo_u32 v20, s15, v20
		v_lshrrev_b32_e32 v22, 6, v0
		v_and_b32_e32 v22, 1, v22
		v_mul_lo_u32 v22, s15, v22
		v_lshlrev_b32_e32 v22, 1, v22
		v_lshl_add_u32 v20, v20, 2, v22
		v_lshl_add_u32 v19, v19, 5, v20
		v_lshl_add_u32 v18, v18, 6, v19
		v_lshrrev_b32_e32 v19, 3, v0
		v_and_b32_e32 v19, 1, v19
		v_mul_lo_u32 v19, s15, v19
		v_lshlrev_b32_e32 v19, 7, v19
		v_and_b32_e32 v20, 1, v0
		v_lshlrev_b32_e32 v20, 4, v20
		v_add3_u32 v18, v18, v19, v20
		v_lshrrev_b32_e32 v19, 2, v0
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 6, v19
		v_lshrrev_b32_e32 v20, 1, v0
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v20, 5, v20
		v_add3_u32 v18, v18, v19, v20
		v_add_u32_e32 v19, s44, v18
		s_mov_b32 s68, 1
		s_mov_b32 s69, 0
		s_mov_b32 s71, 0
		s_mov_b32 s70, s56
		s_mul_i32 s72, s68, s70
		s_mul_hi_u32 s73, s68, s70
		s_mul_i32 s44, s68, s71
		s_add_i32 s73, s73, s44
		s_mul_i32 s44, s69, s70
		s_add_i32 s73, s73, s44
		s_lshr_b64 s[68:69], s[72:73], 6
		s_mov_b32 s70, 0x410
		s_mov_b32 s71, 0
		s_mul_i32 s72, s70, s68
		s_mul_hi_u32 s73, s70, s68
		s_mul_i32 s44, s70, s69
		s_add_i32 s73, s73, s44
		s_mul_i32 s44, s71, s68
		s_add_i32 s73, s73, s44
		s_cmp_lt_i32 s52, 0
		s_cselect_b32 s53, -1, 0
		s_mov_b32 s70, 0x4100
		s_mov_b32 s71, 0
		s_mul_i32 s74, s70, s52
		s_mul_hi_u32 s75, s70, s52
		s_mul_i32 s44, s70, s53
		s_add_i32 s75, s75, s44
		s_mul_i32 s44, s71, s52
		s_add_i32 s75, s75, s44
		s_add_u32 s70, s72, s74
		s_addc_u32 s71, s73, s75
		s_add_u32 s76, s70, 0
		s_addc_u32 s77, s71, 0
		s_mov_b32 m0, s76
		v_cndmask_b32_e64 v19, v12, v19, s[46:47]
		buffer_load_dwordx4 v19, s[28:31], 0 offen lds
		v_lshrrev_b32_e32 v19, 3, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 16
		v_mul_lo_u32 v20, v20, v19
		v_lshrrev_b32_e32 v19, 4, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v22, 32
		v_mul_lo_u32 v22, v22, v19
		v_bitop3_b32 v19, 12, v20, v22 bitop3:0x96
		v_lshrrev_b32_e32 v20, 5, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v22, 64
		v_mul_lo_u32 v22, v22, v20
		v_xor_b32_e32 v19, v19, v22
		v_lshrrev_b32_e32 v20, 6, v0
		v_and_b32_e32 v20, 1, v20
		v_lshrrev_b32_e32 v22, 7, v0
		v_and_b32_e32 v22, 1, v22
		v_mov_b32_e32 v23, 2
		v_mul_lo_u32 v23, v23, v22
		v_bitop3_b32 v19, v19, v20, v23 bitop3:0x96
		v_add_u32_e32 v19, s26, v19
		s_mul_i32 s44, 0x108, s15
		s_mul_i32 s46, s1, s13
		s_lshl_b32 s46, s46, 1
		s_add_i32 s44, s44, s46
		s_mul_i32 s46, s24, s14
		s_lshl_b32 s46, s46, 1
		s_add_i32 s44, s44, s46
		s_add_i32 s44, s44, s40
		v_add_u32_e32 v20, s44, v18
		s_add_u32 s46, s72, 0x1040
		s_addc_u32 s47, s73, 0
		s_add_u32 s46, s46, s74
		s_addc_u32 s47, s47, s75
		s_add_u32 s70, s46, 0
		s_addc_u32 s71, s47, 0
		s_mov_b32 m0, s70
		v_cndmask_b32_e64 v20, v12, v20, s[54:55]
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		s_mul_i32 s44, 0x110, s15
		s_mul_i32 s46, s1, s13
		s_lshl_b32 s46, s46, 1
		s_add_i32 s44, s44, s46
		s_mul_i32 s46, s24, s14
		s_lshl_b32 s46, s46, 1
		s_add_i32 s44, s44, s46
		s_add_i32 s44, s44, s40
		v_add_u32_e32 v20, s44, v18
		s_add_u32 s46, s72, 0x2080
		s_addc_u32 s47, s73, 0
		s_add_u32 s46, s46, s74
		s_addc_u32 s47, s47, s75
		s_add_u32 s54, s46, 0
		s_addc_u32 s55, s47, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v20, v12, v20, s[58:59]
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		s_mul_i32 s44, 0x118, s15
		s_mul_i32 s46, s1, s13
		s_lshl_b32 s46, s46, 1
		s_add_i32 s44, s44, s46
		s_mul_i32 s46, s24, s14
		s_lshl_b32 s46, s46, 1
		s_add_i32 s44, s44, s46
		s_add_i32 s40, s44, s40
		v_add_u32_e32 v18, s40, v18
		s_add_u32 s46, s72, 0x30c0
		s_addc_u32 s47, s73, 0
		s_add_u32 s46, s46, s74
		s_addc_u32 s47, s47, s75
		s_add_u32 s54, s46, 0
		s_addc_u32 s55, s47, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v18, v12, v18, s[60:61]
		buffer_load_dwordx4 v18, s[28:31], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s40, s20, s43
		s_lshl_b32 s40, s40, 1
		s_lshl_b32 s44, s20, 8
		s_mul_i32 s46, s1, s18
		s_lshl_b32 s46, s46, 1
		s_add_i32 s44, s44, s46
		s_mul_i32 s46, s24, s19
		s_lshl_b32 s46, s46, 1
		s_add_i32 s44, s44, s46
		s_add_i32 s44, s44, s40
		v_lshrrev_b32_e32 v18, 4, v0
		v_and_b32_e32 v18, 1, v18
		v_mul_lo_u32 v18, s20, v18
		v_lshrrev_b32_e32 v20, 5, v0
		v_and_b32_e32 v20, 1, v20
		v_mul_lo_u32 v20, s20, v20
		v_lshrrev_b32_e32 v22, 7, v0
		v_mul_lo_u32 v22, s20, v22
		v_lshrrev_b32_e32 v23, 6, v0
		v_and_b32_e32 v23, 1, v23
		v_mul_lo_u32 v23, s20, v23
		v_lshlrev_b32_e32 v23, 1, v23
		v_lshl_add_u32 v22, v22, 2, v23
		v_lshl_add_u32 v20, v20, 7, v22
		v_lshl_add_u32 v18, v18, 6, v20
		v_lshrrev_b32_e32 v20, 3, v0
		v_and_b32_e32 v20, 1, v20
		v_mul_lo_u32 v20, s20, v20
		v_lshlrev_b32_e32 v20, 5, v20
		v_and_b32_e32 v22, 1, v0
		v_lshlrev_b32_e32 v22, 4, v22
		v_add3_u32 v18, v18, v20, v22
		v_lshrrev_b32_e32 v20, 2, v0
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v20, 6, v20
		v_lshrrev_b32_e32 v22, 1, v0
		v_and_b32_e32 v22, 1, v22
		v_lshlrev_b32_e32 v22, 5, v22
		v_add3_u32 v18, v18, v20, v22
		v_add_u32_e32 v20, s44, v18
		s_mov_b32 s46, 0x440
		s_mov_b32 s47, 0
		s_mul_i32 s54, s46, s68
		s_mul_hi_u32 s55, s46, s68
		s_mul_i32 s44, s46, s69
		s_add_i32 s55, s55, s44
		s_mul_i32 s44, s47, s68
		s_add_i32 s55, s55, s44
		s_add_u32 s46, s54, 0x81f0
		s_addc_u32 s47, s55, 0
		s_mov_b32 s58, 0x4400
		s_mov_b32 s59, 0
		s_mul_i32 s60, s58, s52
		s_mul_hi_u32 s61, s58, s52
		s_mul_i32 s44, s58, s53
		s_add_i32 s61, s61, s44
		s_mul_i32 s44, s59, s52
		s_add_i32 s61, s61, s44
		s_add_u32 s46, s46, s60
		s_addc_u32 s47, s47, s61
		s_add_u32 s52, s46, 0
		s_addc_u32 s53, s47, 0
		s_mov_b32 m0, s52
		v_cndmask_b32_e64 v20, v12, v20, s[62:63]
		buffer_load_dwordx4 v20, s[32:35], 0 offen lds
		s_mul_i32 s44, 0x108, s20
		s_mul_i32 s46, s1, s18
		s_lshl_b32 s46, s46, 1
		s_add_i32 s44, s44, s46
		s_mul_i32 s46, s24, s19
		s_lshl_b32 s46, s46, 1
		s_add_i32 s44, s44, s46
		s_add_i32 s44, s44, s40
		v_add_u32_e32 v20, s44, v18
		s_add_u32 s46, s54, 0x92f0
		s_addc_u32 s47, s55, 0
		s_add_u32 s46, s46, s60
		s_addc_u32 s47, s47, s61
		s_add_u32 s52, s46, 0
		s_addc_u32 s53, s47, 0
		s_mov_b32 m0, s52
		v_cndmask_b32_e64 v20, v12, v20, s[64:65]
		buffer_load_dwordx4 v20, s[32:35], 0 offen lds
		s_mul_i32 s44, 0x110, s20
		s_mul_i32 s46, s1, s18
		s_lshl_b32 s46, s46, 1
		s_add_i32 s44, s44, s46
		s_mul_i32 s46, s24, s19
		s_lshl_b32 s46, s46, 1
		s_add_i32 s44, s44, s46
		s_add_i32 s44, s44, s40
		v_add_u32_e32 v20, s44, v18
		s_add_u32 s46, s54, 0xa3f0
		s_addc_u32 s47, s55, 0
		s_add_u32 s46, s46, s60
		s_addc_u32 s47, s47, s61
		s_add_u32 s52, s46, 0
		s_addc_u32 s53, s47, 0
		s_mov_b32 m0, s52
		v_cndmask_b32_e64 v20, v12, v20, s[66:67]
		buffer_load_dwordx4 v20, s[32:35], 0 offen lds
		s_mul_i32 s44, 0x118, s20
		s_mul_i32 s46, s1, s18
		s_lshl_b32 s46, s46, 1
		s_add_i32 s44, s44, s46
		s_mul_i32 s46, s24, s19
		s_lshl_b32 s46, s46, 1
		s_add_i32 s44, s44, s46
		s_add_i32 s40, s44, s40
		v_cmp_lt_i32_e64 vcc, v19, s23
		v_add_u32_e32 v18, s40, v18
		s_add_u32 s46, s54, 0xb4f0
		s_addc_u32 s47, s55, 0
		v_cndmask_b32_e32 v18, v12, v18, vcc
		s_add_u32 s46, s46, s60
		s_addc_u32 s47, s47, s61
		s_add_u32 s52, s46, 0
		s_addc_u32 s53, s47, 0
		s_mov_b32 m0, s52
		s_nop 0
		buffer_load_dwordx4 v18, s[32:35], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_2
.L_attn_fwd_persistent.if_else_2:
.L_attn_fwd_persistent.if_end_2:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[160:175], v[28:31], a[4:7], 0
		v_lshrrev_b32_e32 v18, 5, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v19, 4
		v_mul_lo_u32 v19, v19, v18
		v_add_u32_e32 v18, s43, v19
		v_lshrrev_b32_e32 v19, 5, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 4
		v_mul_lo_u32 v20, v20, v19
		v_xor_b32_e32 v19, 1, v20
		v_add_u32_e32 v19, s43, v19
		v_lshrrev_b32_e32 v20, 5, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v22, 4
		v_mul_lo_u32 v22, v22, v20
		v_xor_b32_e32 v20, 2, v22
		v_add_u32_e32 v20, s43, v20
		v_lshrrev_b32_e32 v22, 5, v0
		v_and_b32_e32 v22, 1, v22
		v_mov_b32_e32 v23, 4
		v_mul_lo_u32 v23, v23, v22
		v_xor_b32_e32 v22, 3, v23
		v_add_u32_e32 v22, s43, v22
		v_lshrrev_b32_e32 v23, 5, v0
		v_and_b32_e32 v23, 1, v23
		v_mov_b32_e32 v25, 4
		v_mul_lo_u32 v25, v25, v23
		v_xor_b32_e32 v23, 10, v25
		v_add_u32_e32 v23, s43, v23
		v_lshrrev_b32_e32 v25, 5, v0
		v_and_b32_e32 v25, 1, v25
		v_mov_b32_e32 v26, 4
		v_mul_lo_u32 v26, v26, v25
		v_xor_b32_e32 v25, 11, v26
		v_add_u32_e32 v25, s43, v25
		v_lshrrev_b32_e32 v26, 5, v0
		v_and_b32_e32 v26, 1, v26
		v_mov_b32_e32 v27, 4
		v_mul_lo_u32 v27, v27, v26
		v_xor_b32_e32 v26, 18, v27
		v_add_u32_e32 v26, s43, v26
		v_mfma_f32_32x32x16_bf16 v[176:191], v[100:103], a[4:7], 0
		s_nop 11
		v_accvgpr_write_b32 a112, v176
		v_accvgpr_write_b32 a113, v177
		v_accvgpr_write_b32 a114, v178
		v_accvgpr_write_b32 a115, v179
		v_accvgpr_write_b32 a116, v180
		v_accvgpr_write_b32 a117, v181
		v_accvgpr_write_b32 a118, v182
		v_accvgpr_write_b32 a119, v183
		v_accvgpr_write_b32 a120, v184
		v_accvgpr_write_b32 a121, v185
		v_accvgpr_write_b32 a122, v186
		v_accvgpr_write_b32 a123, v187
		v_accvgpr_write_b32 a124, v188
		v_accvgpr_write_b32 a125, v189
		v_accvgpr_write_b32 a126, v190
		v_accvgpr_write_b32 a127, v191
		v_lshrrev_b32_e32 v27, 5, v0
		v_and_b32_e32 v27, 1, v27
		v_mov_b32_e32 v65, 4
		v_mul_lo_u32 v65, v65, v27
		v_xor_b32_e32 v27, 19, v65
		v_add_u32_e32 v27, s43, v27
		v_lshrrev_b32_e32 v65, 5, v0
		v_and_b32_e32 v65, 1, v65
		v_mov_b32_e32 v67, 4
		v_mul_lo_u32 v67, v67, v65
		v_xor_b32_e32 v65, 26, v67
		v_add_u32_e32 v65, s43, v65
		v_lshrrev_b32_e32 v67, 5, v0
		v_and_b32_e32 v67, 1, v67
		v_mov_b32_e32 v70, 4
		v_mul_lo_u32 v70, v70, v67
		v_xor_b32_e32 v67, 27, v70
		v_add_u32_e32 v67, s43, v67
		v_lshrrev_b32_e32 v70, 5, v0
		v_and_b32_e32 v70, 1, v70
		v_mov_b32_e32 v71, 4
		v_mul_lo_u32 v71, v71, v70
		v_xor_b32_e32 v70, 34, v71
		v_add_u32_e32 v70, s43, v70
		v_lshrrev_b32_e32 v71, 5, v0
		v_and_b32_e32 v71, 1, v71
		v_mov_b32_e32 v156, 4
		v_mul_lo_u32 v156, v156, v71
		v_xor_b32_e32 v71, 35, v156
		v_add_u32_e32 v71, s43, v71
		v_lshrrev_b32_e32 v156, 5, v0
		v_and_b32_e32 v156, 1, v156
		v_mov_b32_e32 v157, 4
		v_mul_lo_u32 v157, v157, v156
		v_xor_b32_e32 v156, 42, v157
		v_add_u32_e32 v156, s43, v156
		v_lshrrev_b32_e32 v157, 5, v0
		v_and_b32_e32 v157, 1, v157
		v_mov_b32_e32 v158, 4
		v_mul_lo_u32 v158, v158, v157
		v_xor_b32_e32 v157, 43, v158
		v_add_u32_e32 v157, s43, v157
		v_mfma_f32_32x32x16_bf16 v[176:191], v[116:119], a[4:7], 0
		s_nop 11
		v_accvgpr_write_b32 a128, v176
		v_accvgpr_write_b32 a129, v177
		v_accvgpr_write_b32 a130, v178
		v_accvgpr_write_b32 a131, v179
		v_accvgpr_write_b32 a132, v180
		v_accvgpr_write_b32 a133, v181
		v_accvgpr_write_b32 a134, v182
		v_accvgpr_write_b32 a135, v183
		v_accvgpr_write_b32 a136, v184
		v_accvgpr_write_b32 a137, v185
		v_accvgpr_write_b32 a138, v186
		v_accvgpr_write_b32 a139, v187
		v_accvgpr_write_b32 a140, v188
		v_accvgpr_write_b32 a141, v189
		v_accvgpr_write_b32 a142, v190
		v_accvgpr_write_b32 a143, v191
		v_lshrrev_b32_e32 v158, 5, v0
		v_and_b32_e32 v158, 1, v158
		v_mov_b32_e32 v159, 4
		v_mul_lo_u32 v159, v159, v158
		v_xor_b32_e32 v158, 50, v159
		v_add_u32_e32 v158, s43, v158
		v_lshrrev_b32_e32 v159, 5, v0
		v_and_b32_e32 v159, 1, v159
		v_mov_b32_e32 v176, 4
		v_mul_lo_u32 v176, v176, v159
		v_xor_b32_e32 v159, 51, v176
		v_add_u32_e32 v159, s43, v159
		v_lshrrev_b32_e32 v176, 5, v0
		v_and_b32_e32 v176, 1, v176
		v_mov_b32_e32 v177, 4
		v_mul_lo_u32 v177, v177, v176
		v_xor_b32_e32 v176, 58, v177
		v_add_u32_e32 v176, s43, v176
		v_lshrrev_b32_e32 v177, 5, v0
		v_and_b32_e32 v177, 1, v177
		v_mov_b32_e32 v178, 4
		v_mul_lo_u32 v178, v178, v177
		v_xor_b32_e32 v177, 59, v178
		v_add_u32_e32 v177, s43, v177
		v_lshrrev_b32_e32 v178, 5, v0
		v_and_b32_e32 v178, 1, v178
		v_mov_b32_e32 v179, 4
		v_mul_lo_u32 v179, v179, v178
		v_xor_b32_e32 v178, 0x42, v179
		v_add_u32_e32 v178, s43, v178
		v_lshrrev_b32_e32 v179, 5, v0
		v_and_b32_e32 v179, 1, v179
		v_mov_b32_e32 v180, 4
		v_mul_lo_u32 v180, v180, v179
		v_xor_b32_e32 v179, 0x43, v180
		v_add_u32_e32 v179, s43, v179
		v_lshrrev_b32_e32 v180, 5, v0
		v_and_b32_e32 v180, 1, v180
		v_mov_b32_e32 v181, 4
		v_mul_lo_u32 v181, v181, v180
		v_xor_b32_e32 v180, 0x4a, v181
		v_add_u32_e32 v180, s43, v180
		v_mfma_f32_32x32x16_bf16 v[192:207], v[132:135], a[4:7], 0
		s_nop 11
		v_accvgpr_write_b32 a144, v192
		v_accvgpr_write_b32 a145, v193
		v_accvgpr_write_b32 a146, v194
		v_accvgpr_write_b32 a147, v195
		v_accvgpr_write_b32 a148, v196
		v_accvgpr_write_b32 a149, v197
		v_accvgpr_write_b32 a150, v198
		v_accvgpr_write_b32 a151, v199
		v_accvgpr_write_b32 a152, v200
		v_accvgpr_write_b32 a153, v201
		v_accvgpr_write_b32 a154, v202
		v_accvgpr_write_b32 a155, v203
		v_accvgpr_write_b32 a156, v204
		v_accvgpr_write_b32 a157, v205
		v_accvgpr_write_b32 a158, v206
		v_accvgpr_write_b32 a159, v207
		v_lshrrev_b32_e32 v181, 5, v0
		v_and_b32_e32 v181, 1, v181
		v_mov_b32_e32 v182, 4
		v_mul_lo_u32 v182, v182, v181
		v_xor_b32_e32 v181, 0x4b, v182
		v_add_u32_e32 v181, s43, v181
		v_lshrrev_b32_e32 v182, 5, v0
		v_and_b32_e32 v182, 1, v182
		v_mov_b32_e32 v183, 4
		v_mul_lo_u32 v183, v183, v182
		v_xor_b32_e32 v182, 0x52, v183
		v_add_u32_e32 v182, s43, v182
		v_lshrrev_b32_e32 v183, 5, v0
		v_and_b32_e32 v183, 1, v183
		v_mov_b32_e32 v184, 4
		v_mul_lo_u32 v184, v184, v183
		v_xor_b32_e32 v183, 0x53, v184
		v_add_u32_e32 v183, s43, v183
		v_lshrrev_b32_e32 v184, 5, v0
		v_and_b32_e32 v184, 1, v184
		v_mov_b32_e32 v185, 4
		v_mul_lo_u32 v185, v185, v184
		v_xor_b32_e32 v184, 0x5a, v185
		v_add_u32_e32 v184, s43, v184
		v_lshrrev_b32_e32 v185, 5, v0
		v_and_b32_e32 v185, 1, v185
		v_mov_b32_e32 v186, 4
		v_mul_lo_u32 v186, v186, v185
		v_xor_b32_e32 v185, 0x5b, v186
		v_add_u32_e32 v185, s43, v185
		v_lshrrev_b32_e32 v186, 5, v0
		v_and_b32_e32 v186, 1, v186
		v_mov_b32_e32 v187, 4
		v_mul_lo_u32 v187, v187, v186
		v_xor_b32_e32 v186, 0x62, v187
		v_add_u32_e32 v186, s43, v186
		v_lshrrev_b32_e32 v187, 5, v0
		v_and_b32_e32 v187, 1, v187
		v_mov_b32_e32 v188, 4
		v_mul_lo_u32 v188, v188, v187
		v_xor_b32_e32 v187, 0x63, v188
		v_add_u32_e32 v187, s43, v187
		v_mfma_f32_32x32x16_bf16 v[192:207], v[132:135], a[20:23], 0
		s_nop 11
		v_accvgpr_write_b32 a160, v192
		v_accvgpr_write_b32 a161, v193
		v_accvgpr_write_b32 a162, v194
		v_accvgpr_write_b32 a163, v195
		v_accvgpr_write_b32 a164, v196
		v_accvgpr_write_b32 a165, v197
		v_accvgpr_write_b32 a166, v198
		v_accvgpr_write_b32 a167, v199
		v_accvgpr_write_b32 a168, v200
		v_accvgpr_write_b32 a169, v201
		v_accvgpr_write_b32 a170, v202
		v_accvgpr_write_b32 a171, v203
		v_accvgpr_write_b32 a172, v204
		v_accvgpr_write_b32 a173, v205
		v_accvgpr_write_b32 a174, v206
		v_accvgpr_write_b32 a175, v207
		v_lshrrev_b32_e32 v132, 5, v0
		v_and_b32_e32 v132, 1, v132
		v_mov_b32_e32 v133, 4
		v_mul_lo_u32 v133, v133, v132
		v_xor_b32_e32 v132, 0x6a, v133
		v_add_u32_e32 v132, s43, v132
		v_lshrrev_b32_e32 v133, 5, v0
		v_and_b32_e32 v133, 1, v133
		v_mov_b32_e32 v134, 4
		v_mul_lo_u32 v134, v134, v133
		v_xor_b32_e32 v133, 0x6b, v134
		v_add_u32_e32 v133, s43, v133
		v_lshrrev_b32_e32 v134, 5, v0
		v_and_b32_e32 v134, 1, v134
		v_mov_b32_e32 v135, 4
		v_mul_lo_u32 v135, v135, v134
		v_xor_b32_e32 v134, 0x72, v135
		v_add_u32_e32 v134, s43, v134
		v_lshrrev_b32_e32 v135, 5, v0
		v_and_b32_e32 v135, 1, v135
		v_mov_b32_e32 v188, 4
		v_mul_lo_u32 v188, v188, v135
		v_xor_b32_e32 v135, 0x73, v188
		v_add_u32_e32 v135, s43, v135
		v_lshrrev_b32_e32 v188, 5, v0
		v_and_b32_e32 v188, 1, v188
		v_mov_b32_e32 v189, 4
		v_mul_lo_u32 v189, v189, v188
		v_xor_b32_e32 v188, 0x7a, v189
		v_add_u32_e32 v188, s43, v188
		v_lshrrev_b32_e32 v189, 5, v0
		v_and_b32_e32 v189, 1, v189
		v_mov_b32_e32 v190, 4
		v_mul_lo_u32 v190, v190, v189
		v_xor_b32_e32 v189, 0x7b, v190
		v_add_u32_e32 v189, s43, v189
		v_cmp_ge_i32_e64 vcc, v11, v18
		s_mov_b64 s[46:47], vcc
		v_mfma_f32_32x32x16_bf16 v[192:207], v[28:31], a[20:23], 0
		s_nop 11
		v_accvgpr_write_b32 a176, v192
		v_accvgpr_write_b32 a177, v193
		v_accvgpr_write_b32 a178, v194
		v_accvgpr_write_b32 a179, v195
		v_accvgpr_write_b32 a180, v196
		v_accvgpr_write_b32 a181, v197
		v_accvgpr_write_b32 a182, v198
		v_accvgpr_write_b32 a183, v199
		v_accvgpr_write_b32 a184, v200
		v_accvgpr_write_b32 a185, v201
		v_accvgpr_write_b32 a186, v202
		v_accvgpr_write_b32 a187, v203
		v_accvgpr_write_b32 a188, v204
		v_accvgpr_write_b32 a189, v205
		v_accvgpr_write_b32 a190, v206
		v_accvgpr_write_b32 a191, v207
		v_cmp_ge_i32_e64 vcc, v11, v19
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v11, v20
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v11, v22
		v_lshrrev_b32_e32 v28, 5, v0
		v_and_b32_e32 v28, 1, v28
		v_mov_b32_e32 v29, 4
		v_mul_lo_u32 v29, v29, v28
		v_xor_b32_e32 v28, 8, v29
		v_add_u32_e32 v28, s43, v28
		v_lshrrev_b32_e32 v29, 5, v0
		v_and_b32_e32 v29, 1, v29
		v_mov_b32_e32 v30, 4
		v_mul_lo_u32 v30, v30, v29
		v_xor_b32_e32 v29, 9, v30
		v_add_u32_e32 v29, s43, v29
		v_lshrrev_b32_e32 v30, 5, v0
		v_and_b32_e32 v30, 1, v30
		v_mov_b32_e32 v31, 4
		v_mul_lo_u32 v31, v31, v30
		v_xor_b32_e32 v30, 16, v31
		v_add_u32_e32 v30, s43, v30
		v_lshrrev_b32_e32 v31, 5, v0
		v_and_b32_e32 v31, 1, v31
		v_mov_b32_e32 v190, 4
		v_mul_lo_u32 v190, v190, v31
		v_xor_b32_e32 v31, 17, v190
		v_add_u32_e32 v31, s43, v31
		v_mfma_f32_32x32x16_bf16 v[192:207], v[100:103], a[20:23], 0
		s_nop 11
		v_accvgpr_write_b32 a192, v192
		v_accvgpr_write_b32 a193, v193
		v_accvgpr_write_b32 a194, v194
		v_accvgpr_write_b32 a195, v195
		v_accvgpr_write_b32 a196, v196
		v_accvgpr_write_b32 a197, v197
		v_accvgpr_write_b32 a198, v198
		v_accvgpr_write_b32 a199, v199
		v_accvgpr_write_b32 a200, v200
		v_accvgpr_write_b32 a201, v201
		v_accvgpr_write_b32 a202, v202
		v_accvgpr_write_b32 a203, v203
		v_accvgpr_write_b32 a204, v204
		v_accvgpr_write_b32 a205, v205
		v_accvgpr_write_b32 a206, v206
		v_accvgpr_write_b32 a207, v207
		v_lshrrev_b32_e32 v100, 5, v0
		v_and_b32_e32 v100, 1, v100
		v_mov_b32_e32 v101, 4
		v_mul_lo_u32 v101, v101, v100
		v_xor_b32_e32 v100, 24, v101
		v_add_u32_e32 v100, s43, v100
		v_lshrrev_b32_e32 v101, 5, v0
		v_and_b32_e32 v101, 1, v101
		v_mov_b32_e32 v102, 4
		v_mul_lo_u32 v102, v102, v101
		v_xor_b32_e32 v101, 25, v102
		v_add_u32_e32 v101, s43, v101
		v_lshrrev_b32_e32 v102, 5, v0
		v_and_b32_e32 v102, 1, v102
		v_mov_b32_e32 v103, 4
		v_mul_lo_u32 v103, v103, v102
		v_xor_b32_e32 v102, 32, v103
		v_add_u32_e32 v102, s43, v102
		v_lshrrev_b32_e32 v103, 5, v0
		v_and_b32_e32 v103, 1, v103
		v_mov_b32_e32 v190, 4
		v_mul_lo_u32 v190, v190, v103
		v_xor_b32_e32 v103, 33, v190
		v_add_u32_e32 v103, s43, v103
		v_lshrrev_b32_e32 v190, 5, v0
		v_and_b32_e32 v190, 1, v190
		v_mov_b32_e32 v191, 4
		v_mul_lo_u32 v191, v191, v190
		v_xor_b32_e32 v190, 40, v191
		v_add_u32_e32 v190, s43, v190
		v_lshrrev_b32_e32 v191, 5, v0
		v_and_b32_e32 v191, 1, v191
		v_mov_b32_e32 v192, 4
		v_mul_lo_u32 v192, v192, v191
		v_xor_b32_e32 v191, 41, v192
		v_add_u32_e32 v191, s43, v191
		v_lshrrev_b32_e32 v192, 5, v0
		v_and_b32_e32 v192, 1, v192
		v_mov_b32_e32 v193, 4
		v_mul_lo_u32 v193, v193, v192
		v_xor_b32_e32 v192, 48, v193
		v_add_u32_e32 v192, s43, v192
		v_mfma_f32_32x32x16_bf16 v[208:223], v[116:119], a[20:23], 0
		v_lshrrev_b32_e32 v116, 5, v0
		v_and_b32_e32 v116, 1, v116
		v_mov_b32_e32 v117, 4
		v_mul_lo_u32 v117, v117, v116
		v_xor_b32_e32 v116, 49, v117
		v_add_u32_e32 v116, s43, v116
		v_lshrrev_b32_e32 v117, 5, v0
		v_and_b32_e32 v117, 1, v117
		v_mov_b32_e32 v118, 4
		v_mul_lo_u32 v118, v118, v117
		v_xor_b32_e32 v117, 56, v118
		v_add_u32_e32 v117, s43, v117
		v_lshrrev_b32_e32 v118, 5, v0
		v_and_b32_e32 v118, 1, v118
		v_mov_b32_e32 v119, 4
		v_mul_lo_u32 v119, v119, v118
		v_xor_b32_e32 v118, 57, v119
		v_add_u32_e32 v118, s43, v118
		v_lshrrev_b32_e32 v119, 5, v0
		v_and_b32_e32 v119, 1, v119
		v_mov_b32_e32 v193, 4
		v_mul_lo_u32 v193, v193, v119
		v_xor_b32_e32 v119, 64, v193
		v_add_u32_e32 v119, s43, v119
		v_lshrrev_b32_e32 v193, 5, v0
		v_and_b32_e32 v193, 1, v193
		v_mov_b32_e32 v194, 4
		v_mul_lo_u32 v194, v194, v193
		v_xor_b32_e32 v193, 0x41, v194
		v_add_u32_e32 v193, s43, v193
		v_lshrrev_b32_e32 v194, 5, v0
		v_and_b32_e32 v194, 1, v194
		v_mov_b32_e32 v195, 4
		v_mul_lo_u32 v195, v195, v194
		v_xor_b32_e32 v194, 0x48, v195
		v_add_u32_e32 v194, s43, v194
		v_lshrrev_b32_e32 v195, 5, v0
		v_and_b32_e32 v195, 1, v195
		v_mov_b32_e32 v196, 4
		v_mul_lo_u32 v196, v196, v195
		v_xor_b32_e32 v195, 0x49, v196
		v_add_u32_e32 v195, s43, v195
		v_mfma_f32_32x32x16_bf16 v[160:175], v[72:75], a[8:11], v[160:175]
		v_lshrrev_b32_e32 v196, 5, v0
		v_and_b32_e32 v196, 1, v196
		v_mov_b32_e32 v197, 4
		v_mul_lo_u32 v197, v197, v196
		v_xor_b32_e32 v196, 0x50, v197
		v_add_u32_e32 v196, s43, v196
		v_lshrrev_b32_e32 v197, 5, v0
		v_and_b32_e32 v197, 1, v197
		v_mov_b32_e32 v198, 4
		v_mul_lo_u32 v198, v198, v197
		v_xor_b32_e32 v197, 0x51, v198
		v_add_u32_e32 v197, s43, v197
		v_lshrrev_b32_e32 v198, 5, v0
		v_and_b32_e32 v198, 1, v198
		v_mov_b32_e32 v199, 4
		v_mul_lo_u32 v199, v199, v198
		v_xor_b32_e32 v198, 0x58, v199
		v_add_u32_e32 v198, s43, v198
		v_lshrrev_b32_e32 v199, 5, v0
		v_and_b32_e32 v199, 1, v199
		v_mov_b32_e32 v200, 4
		v_mul_lo_u32 v200, v200, v199
		v_xor_b32_e32 v199, 0x59, v200
		v_add_u32_e32 v199, s43, v199
		v_lshrrev_b32_e32 v200, 5, v0
		v_and_b32_e32 v200, 1, v200
		v_mov_b32_e32 v201, 4
		v_mul_lo_u32 v201, v201, v200
		v_xor_b32_e32 v200, 0x60, v201
		v_add_u32_e32 v200, s43, v200
		v_lshrrev_b32_e32 v201, 5, v0
		v_and_b32_e32 v201, 1, v201
		v_mov_b32_e32 v202, 4
		v_mul_lo_u32 v202, v202, v201
		v_xor_b32_e32 v201, 0x61, v202
		v_add_u32_e32 v201, s43, v201
		v_lshrrev_b32_e32 v202, 5, v0
		v_and_b32_e32 v202, 1, v202
		v_mov_b32_e32 v203, 4
		v_mul_lo_u32 v203, v203, v202
		v_xor_b32_e32 v202, 0x68, v203
		v_add_u32_e32 v202, s43, v202
		v_mfma_f32_32x32x16_bf16 a[112:127], v[104:107], a[8:11], a[112:127]
		v_lshrrev_b32_e32 v203, 5, v0
		v_and_b32_e32 v203, 1, v203
		v_mov_b32_e32 v204, 4
		v_mul_lo_u32 v204, v204, v203
		v_xor_b32_e32 v203, 0x69, v204
		v_add_u32_e32 v203, s43, v203
		v_lshrrev_b32_e32 v204, 5, v0
		v_and_b32_e32 v204, 1, v204
		v_mov_b32_e32 v205, 4
		v_mul_lo_u32 v205, v205, v204
		v_xor_b32_e32 v204, 0x70, v205
		v_add_u32_e32 v204, s43, v204
		v_lshrrev_b32_e32 v205, 5, v0
		v_and_b32_e32 v205, 1, v205
		v_mov_b32_e32 v206, 4
		v_mul_lo_u32 v206, v206, v205
		v_xor_b32_e32 v205, 0x71, v206
		v_add_u32_e32 v205, s43, v205
		v_lshrrev_b32_e32 v206, 5, v0
		v_and_b32_e32 v206, 1, v206
		v_mov_b32_e32 v207, 4
		v_mul_lo_u32 v207, v207, v206
		v_xor_b32_e32 v206, 0x78, v207
		v_add_u32_e32 v206, s43, v206
		v_lshrrev_b32_e32 v207, 5, v0
		v_and_b32_e32 v207, 1, v207
		v_mov_b32_e32 v224, 4
		v_mul_lo_u32 v224, v224, v207
		v_xor_b32_e32 v207, 0x79, v224
		v_add_u32_e32 v207, s43, v207
		v_mfma_f32_32x32x16_bf16 a[128:143], v[120:123], a[8:11], a[128:143]
		v_mfma_f32_32x32x16_bf16 a[144:159], v[136:139], a[8:11], a[144:159]
		v_mfma_f32_32x32x16_bf16 a[160:175], v[136:139], a[24:27], a[160:175]
		v_mfma_f32_32x32x16_bf16 a[176:191], v[72:75], a[24:27], a[176:191]
		v_mfma_f32_32x32x16_bf16 a[192:207], v[104:107], a[24:27], a[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[120:123], a[24:27], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[76:79], a[12:15], v[160:175]
		v_mfma_f32_32x32x16_bf16 a[112:127], v[108:111], a[12:15], a[112:127]
		v_mfma_f32_32x32x16_bf16 a[128:143], v[124:127], a[12:15], a[128:143]
		v_mfma_f32_32x32x16_bf16 a[144:159], v[140:143], a[12:15], a[144:159]
		v_mfma_f32_32x32x16_bf16 a[160:175], v[140:143], a[28:31], a[160:175]
		v_mfma_f32_32x32x16_bf16 a[176:191], v[76:79], a[28:31], a[176:191]
		v_mfma_f32_32x32x16_bf16 a[192:207], v[108:111], a[28:31], a[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[124:127], a[28:31], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], a[16:19], v[160:175]
		v_mfma_f32_32x32x16_bf16 a[112:127], v[112:115], a[16:19], a[112:127]
		v_mfma_f32_32x32x16_bf16 a[128:143], v[128:131], a[16:19], a[128:143]
		v_mfma_f32_32x32x16_bf16 a[144:159], v[144:147], a[16:19], a[144:159]
		v_mfma_f32_32x32x16_bf16 a[160:175], v[144:147], a[32:35], a[160:175]
		v_mfma_f32_32x32x16_bf16 a[176:191], v[96:99], a[32:35], a[176:191]
		v_mfma_f32_32x32x16_bf16 a[192:207], v[112:115], a[32:35], a[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[128:131], a[32:35], v[208:223]
		s_cmp_lt_i32 s26, s42
		v_mov_b32_e32 v72, 0xff800000
		s_nop 2
		v_cndmask_b32_e32 v75, v72, v163, vcc
		v_cmp_ge_i32_e64 vcc, v11, v28
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v11, v29
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v11, v23
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v11, v25
		v_cndmask_b32_e64 v76, v72, v160, s[46:47]
		v_cndmask_b32_e64 v77, v72, v161, s[52:53]
		v_cndmask_b32_e32 v79, v72, v167, vcc
		v_cmp_ge_i32_e64 vcc, v11, v30
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v11, v31
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v11, v26
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v11, v27
		v_cndmask_b32_e64 v74, v72, v162, s[54:55]
		v_cndmask_b32_e64 v96, v72, v164, s[58:59]
		v_cndmask_b32_e32 v99, v72, v171, vcc
		v_cmp_ge_i32_e64 vcc, v11, v100
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v11, v101
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v11, v65
		s_mov_b64 s[66:67], vcc
		v_cmp_ge_i32_e64 vcc, v11, v67
		v_cndmask_b32_e64 v97, v72, v165, s[60:61]
		v_cndmask_b32_e64 v78, v72, v166, s[62:63]
		v_cndmask_b32_e32 v105, v72, v175, vcc
		v_cmp_ge_i32_e64 vcc, v11, v102
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v11, v103
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v11, v70
		s_mov_b64 s[68:69], vcc
		v_cmp_ge_i32_e64 vcc, v11, v71
		v_cndmask_b32_e64 v106, v72, v168, s[46:47]
		v_cndmask_b32_e64 v107, v72, v169, s[52:53]
		v_accvgpr_read_b32 v73, a115
		v_cndmask_b32_e32 v109, v72, v73, vcc
		v_cmp_ge_i32_e64 vcc, v11, v190
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v11, v191
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v11, v156
		s_mov_b64 s[70:71], vcc
		v_cmp_ge_i32_e64 vcc, v11, v157
		v_cndmask_b32_e64 v98, v72, v170, s[64:65]
		v_cndmask_b32_e64 v110, v72, v172, s[54:55]
		v_accvgpr_read_b32 v73, a119
		v_cndmask_b32_e32 v113, v72, v73, vcc
		v_cmp_ge_i32_e64 vcc, v11, v192
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v11, v116
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v11, v158
		s_mov_b64 s[72:73], vcc
		v_cmp_ge_i32_e64 vcc, v11, v159
		v_cndmask_b32_e64 v111, v72, v173, s[58:59]
		v_cndmask_b32_e64 v104, v72, v174, s[66:67]
		v_accvgpr_read_b32 v73, a123
		v_cndmask_b32_e32 v115, v72, v73, vcc
		v_cmp_ge_i32_e64 vcc, v11, v117
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v11, v118
		s_mov_b64 s[66:67], vcc
		v_cmp_ge_i32_e64 vcc, v11, v176
		s_mov_b64 s[74:75], vcc
		v_cmp_ge_i32_e64 vcc, v11, v177
		v_accvgpr_read_b32 v73, a112
		v_cndmask_b32_e64 v120, v72, v73, s[60:61]
		v_accvgpr_read_b32 v73, a113
		v_cndmask_b32_e64 v121, v72, v73, s[62:63]
		v_accvgpr_read_b32 v73, a127
		v_cndmask_b32_e32 v123, v72, v73, vcc
		v_cmp_ge_i32_e64 vcc, v11, v119
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v11, v193
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v11, v178
		s_mov_b64 s[76:77], vcc
		v_cmp_ge_i32_e64 vcc, v11, v179
		v_accvgpr_read_b32 v73, a114
		v_cndmask_b32_e64 v108, v72, v73, s[68:69]
		v_accvgpr_read_b32 v73, a116
		v_cndmask_b32_e64 v124, v72, v73, s[46:47]
		v_accvgpr_read_b32 v73, a131
		v_cndmask_b32_e32 v127, v72, v73, vcc
		v_cmp_ge_i32_e64 vcc, v11, v194
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v11, v195
		s_mov_b64 s[68:69], vcc
		v_cmp_ge_i32_e64 vcc, v11, v180
		s_mov_b64 s[78:79], vcc
		v_cmp_ge_i32_e64 vcc, v11, v181
		v_accvgpr_read_b32 v73, a117
		v_cndmask_b32_e64 v125, v72, v73, s[52:53]
		v_accvgpr_read_b32 v73, a118
		v_cndmask_b32_e64 v112, v72, v73, s[70:71]
		v_accvgpr_read_b32 v73, a135
		v_cndmask_b32_e32 v129, v72, v73, vcc
		v_cmp_ge_i32_e64 vcc, v11, v196
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v11, v197
		s_mov_b64 s[70:71], vcc
		v_cmp_ge_i32_e64 vcc, v11, v182
		s_mov_b64 s[80:81], vcc
		v_cmp_ge_i32_e64 vcc, v11, v183
		v_accvgpr_read_b32 v73, a120
		v_cndmask_b32_e64 v130, v72, v73, s[54:55]
		v_accvgpr_read_b32 v73, a121
		v_cndmask_b32_e64 v131, v72, v73, s[64:65]
		v_accvgpr_read_b32 v73, a139
		v_cndmask_b32_e32 v137, v72, v73, vcc
		v_cmp_ge_i32_e64 vcc, v11, v198
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v11, v199
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v11, v184
		s_mov_b64 s[82:83], vcc
		v_accvgpr_read_b32 v73, a141
		v_cndmask_b32_e64 v139, v72, v73, s[64:65]
		v_accvgpr_read_b32 v73, a142
		v_cndmask_b32_e64 v140, v72, v73, s[82:83]
		v_cmp_ge_i32_e64 vcc, v11, v185
		v_accvgpr_read_b32 v73, a122
		v_cndmask_b32_e64 v114, v72, v73, s[72:73]
		v_accvgpr_read_b32 v73, a124
		v_cndmask_b32_e64 v142, v72, v73, s[58:59]
		v_accvgpr_read_b32 v73, a143
		v_cndmask_b32_e32 v141, v72, v73, vcc
		v_cmp_ge_i32_e64 vcc, v11, v200
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v11, v201
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v11, v186
		s_mov_b64 s[72:73], vcc
		v_accvgpr_read_b32 v73, a144
		v_cndmask_b32_e64 v144, v72, v73, s[58:59]
		v_accvgpr_read_b32 v73, a145
		v_cndmask_b32_e64 v145, v72, v73, s[64:65]
		v_accvgpr_read_b32 v73, a146
		v_cndmask_b32_e64 v146, v72, v73, s[72:73]
		v_cmp_ge_i32_e64 vcc, v11, v187
		v_accvgpr_read_b32 v73, a125
		v_cndmask_b32_e64 v143, v72, v73, s[66:67]
		v_accvgpr_read_b32 v73, a126
		v_cndmask_b32_e64 v122, v72, v73, s[74:75]
		v_accvgpr_read_b32 v73, a147
		v_cndmask_b32_e32 v147, v72, v73, vcc
		v_cmp_ge_i32_e64 vcc, v11, v202
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v11, v203
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v11, v132
		s_mov_b64 s[66:67], vcc
		v_accvgpr_read_b32 v73, a148
		v_cndmask_b32_e64 v160, v72, v73, s[58:59]
		v_accvgpr_read_b32 v73, a149
		v_cndmask_b32_e64 v161, v72, v73, s[64:65]
		v_accvgpr_read_b32 v73, a150
		v_cndmask_b32_e64 v162, v72, v73, s[66:67]
		v_cmp_ge_i32_e64 vcc, v11, v133
		v_accvgpr_read_b32 v73, a128
		v_cndmask_b32_e64 v164, v72, v73, s[60:61]
		v_accvgpr_read_b32 v73, a129
		v_cndmask_b32_e64 v165, v72, v73, s[62:63]
		v_accvgpr_read_b32 v73, a151
		v_cndmask_b32_e32 v163, v72, v73, vcc
		v_cmp_ge_i32_e64 vcc, v11, v204
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v11, v205
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v11, v134
		s_mov_b64 s[62:63], vcc
		v_accvgpr_read_b32 v73, a152
		v_cndmask_b32_e64 v166, v72, v73, s[58:59]
		v_accvgpr_read_b32 v73, a153
		v_cndmask_b32_e64 v167, v72, v73, s[60:61]
		v_accvgpr_read_b32 v73, a154
		v_cndmask_b32_e64 v168, v72, v73, s[62:63]
		v_cmp_ge_i32_e64 vcc, v11, v135
		v_accvgpr_read_b32 v73, a130
		v_cndmask_b32_e64 v126, v72, v73, s[76:77]
		v_accvgpr_read_b32 v73, a132
		v_cndmask_b32_e64 v170, v72, v73, s[46:47]
		v_accvgpr_read_b32 v73, a155
		v_cndmask_b32_e32 v169, v72, v73, vcc
		v_cmp_ge_i32_e64 vcc, v11, v206
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v11, v207
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v11, v188
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v73, a156
		v_cndmask_b32_e64 v172, v72, v73, s[46:47]
		v_accvgpr_read_b32 v73, a157
		v_cndmask_b32_e64 v173, v72, v73, s[58:59]
		v_accvgpr_read_b32 v73, a158
		v_cndmask_b32_e64 v174, v72, v73, s[60:61]
		v_cmp_ge_i32_e64 vcc, v11, v189
		v_accvgpr_read_b32 v73, a133
		v_cndmask_b32_e64 v171, v72, v73, s[68:69]
		v_accvgpr_read_b32 v73, a134
		v_cndmask_b32_e64 v128, v72, v73, s[78:79]
		v_accvgpr_read_b32 v73, a159
		v_cndmask_b32_e32 v175, v72, v73, vcc
		v_cmp_ge_i32_e64 vcc, v7, v18
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v7, v19
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v7, v20
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v18, a176
		v_cndmask_b32_e64 v224, v72, v18, s[46:47]
		v_accvgpr_read_b32 v18, a177
		v_cndmask_b32_e64 v225, v72, v18, s[58:59]
		v_accvgpr_read_b32 v18, a178
		v_cndmask_b32_e64 v226, v72, v18, s[60:61]
		v_cmp_ge_i32_e64 vcc, v7, v22
		v_accvgpr_read_b32 v18, a136
		v_cndmask_b32_e64 v228, v72, v18, s[52:53]
		v_accvgpr_read_b32 v18, a137
		v_cndmask_b32_e64 v229, v72, v18, s[70:71]
		v_accvgpr_read_b32 v18, a179
		v_cndmask_b32_e32 v227, v72, v18, vcc
		v_cmp_ge_i32_e64 vcc, v7, v28
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v7, v29
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v7, v23
		s_mov_b64 s[58:59], vcc
		v_accvgpr_read_b32 v18, a180
		v_cndmask_b32_e64 v22, v72, v18, s[46:47]
		v_accvgpr_read_b32 v18, a181
		v_cndmask_b32_e64 v23, v72, v18, s[52:53]
		v_accvgpr_read_b32 v18, a182
		v_cndmask_b32_e64 v28, v72, v18, s[58:59]
		v_cmp_ge_i32_e64 vcc, v7, v25
		v_accvgpr_read_b32 v18, a138
		v_cndmask_b32_e64 v136, v72, v18, s[80:81]
		v_accvgpr_read_b32 v18, a140
		v_cndmask_b32_e64 v138, v72, v18, s[54:55]
		v_accvgpr_read_b32 v18, a183
		v_cndmask_b32_e32 v29, v72, v18, vcc
		v_cmp_ge_i32_e64 vcc, v7, v30
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v7, v31
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v7, v26
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v18, a184
		v_cndmask_b32_e64 v30, v72, v18, s[46:47]
		v_accvgpr_read_b32 v18, a185
		v_cndmask_b32_e64 v31, v72, v18, s[52:53]
		v_accvgpr_read_b32 v18, a186
		v_cndmask_b32_e64 v230, v72, v18, s[54:55]
		v_cmp_ge_i32_e64 vcc, v7, v27
		v_max_f32_e32 v18, v76, v77
		v_max_f32_e32 v19, v74, v75
		v_accvgpr_read_b32 v20, a187
		v_cndmask_b32_e32 v231, v72, v20, vcc
		v_cmp_ge_i32_e64 vcc, v7, v100
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v7, v101
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v7, v65
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v20, a188
		v_cndmask_b32_e64 v26, v72, v20, s[46:47]
		v_accvgpr_read_b32 v20, a189
		v_cndmask_b32_e64 v27, v72, v20, s[52:53]
		v_accvgpr_read_b32 v20, a190
		v_cndmask_b32_e64 v100, v72, v20, s[54:55]
		v_cmp_ge_i32_e64 vcc, v7, v67
		v_max_f32_e32 v20, v96, v97
		v_max_f32_e32 v25, v78, v79
		v_accvgpr_read_b32 v65, a191
		v_cndmask_b32_e32 v101, v72, v65, vcc
		v_cmp_ge_i32_e64 vcc, v7, v102
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v7, v103
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v7, v70
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v65, a192
		v_cndmask_b32_e64 v102, v72, v65, s[46:47]
		v_accvgpr_read_b32 v65, a193
		v_cndmask_b32_e64 v103, v72, v65, s[52:53]
		v_accvgpr_read_b32 v65, a194
		v_cndmask_b32_e64 v232, v72, v65, s[54:55]
		v_cmp_ge_i32_e64 vcc, v7, v71
		v_max_f32_e32 v65, v106, v107
		v_max_f32_e32 v67, v98, v99
		v_accvgpr_read_b32 v70, a195
		v_cndmask_b32_e32 v233, v72, v70, vcc
		v_cmp_ge_i32_e64 vcc, v7, v190
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v7, v191
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v7, v156
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v70, a196
		v_cndmask_b32_e64 v190, v72, v70, s[46:47]
		v_accvgpr_read_b32 v70, a197
		v_cndmask_b32_e64 v191, v72, v70, s[52:53]
		v_accvgpr_read_b32 v70, a198
		v_cndmask_b32_e64 v234, v72, v70, s[54:55]
		v_cmp_ge_i32_e64 vcc, v7, v157
		v_max_f32_e32 v70, v110, v111
		v_max_f32_e32 v71, v104, v105
		v_accvgpr_read_b32 v73, a199
		v_cndmask_b32_e32 v235, v72, v73, vcc
		v_cmp_ge_i32_e64 vcc, v7, v192
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v7, v116
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v7, v158
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v73, a200
		v_cndmask_b32_e64 v156, v72, v73, s[46:47]
		v_accvgpr_read_b32 v73, a201
		v_cndmask_b32_e64 v157, v72, v73, s[52:53]
		v_accvgpr_read_b32 v73, a202
		v_cndmask_b32_e64 v236, v72, v73, s[54:55]
		v_cmp_ge_i32_e64 vcc, v7, v159
		v_max_f32_e32 v73, v120, v121
		v_max_f32_e32 v116, v108, v109
		v_accvgpr_read_b32 v158, a203
		v_cndmask_b32_e32 v237, v72, v158, vcc
		v_cmp_ge_i32_e64 vcc, v7, v117
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v7, v118
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v7, v176
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v117, a204
		v_cndmask_b32_e64 v158, v72, v117, s[46:47]
		v_accvgpr_read_b32 v117, a205
		v_cndmask_b32_e64 v159, v72, v117, s[52:53]
		v_accvgpr_read_b32 v117, a206
		v_cndmask_b32_e64 v238, v72, v117, s[54:55]
		v_cmp_ge_i32_e64 vcc, v7, v177
		v_max_f32_e32 v117, v124, v125
		v_max_f32_e32 v118, v112, v113
		v_accvgpr_read_b32 v176, a207
		v_cndmask_b32_e32 v239, v72, v176, vcc
		v_cmp_ge_i32_e64 vcc, v7, v119
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v7, v193
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v7, v178
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v176, v72, v208, s[46:47]
		v_cndmask_b32_e64 v177, v72, v209, s[52:53]
		v_cndmask_b32_e64 v192, v72, v210, s[54:55]
		v_cmp_ge_i32_e64 vcc, v7, v179
		v_max_f32_e32 v119, v130, v131
		v_max_f32_e32 v178, v114, v115
		v_cndmask_b32_e32 v193, v72, v211, vcc
		v_cmp_ge_i32_e64 vcc, v7, v194
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v7, v195
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v7, v180
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v194, v72, v212, s[46:47]
		v_cndmask_b32_e64 v195, v72, v213, s[52:53]
		v_cndmask_b32_e64 v208, v72, v214, s[54:55]
		v_cmp_ge_i32_e64 vcc, v7, v181
		v_max_f32_e32 v179, v142, v143
		v_max_f32_e32 v180, v122, v123
		v_cndmask_b32_e32 v209, v72, v215, vcc
		v_cmp_ge_i32_e64 vcc, v7, v196
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v7, v197
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v7, v182
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v196, v72, v216, s[46:47]
		v_cndmask_b32_e64 v197, v72, v217, s[52:53]
		v_cndmask_b32_e64 v210, v72, v218, s[54:55]
		v_cmp_ge_i32_e64 vcc, v7, v183
		v_max_f32_e32 v181, v164, v165
		v_max_f32_e32 v182, v126, v127
		v_cndmask_b32_e32 v211, v72, v219, vcc
		v_cmp_ge_i32_e64 vcc, v7, v198
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v7, v199
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v7, v184
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v198, v72, v220, s[46:47]
		v_cndmask_b32_e64 v199, v72, v221, s[52:53]
		v_cndmask_b32_e64 v212, v72, v222, s[54:55]
		v_cmp_ge_i32_e64 vcc, v7, v185
		v_max_f32_e32 v183, v170, v171
		v_max_f32_e32 v184, v128, v129
		v_cndmask_b32_e32 v213, v72, v223, vcc
		v_cmp_ge_i32_e64 vcc, v7, v200
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v7, v201
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v7, v186
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v185, a160
		v_cndmask_b32_e64 v200, v72, v185, s[46:47]
		v_accvgpr_read_b32 v185, a161
		v_cndmask_b32_e64 v201, v72, v185, s[52:53]
		v_accvgpr_read_b32 v185, a162
		v_cndmask_b32_e64 v214, v72, v185, s[54:55]
		v_cmp_ge_i32_e64 vcc, v7, v187
		v_max_f32_e32 v185, v228, v229
		v_max_f32_e32 v186, v136, v137
		v_accvgpr_read_b32 v187, a163
		v_cndmask_b32_e32 v215, v72, v187, vcc
		v_cmp_ge_i32_e64 vcc, v7, v202
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v7, v203
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v7, v132
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v132, a164
		v_cndmask_b32_e64 v202, v72, v132, s[46:47]
		v_accvgpr_read_b32 v132, a165
		v_cndmask_b32_e64 v203, v72, v132, s[52:53]
		v_accvgpr_read_b32 v132, a166
		v_cndmask_b32_e64 v216, v72, v132, s[54:55]
		v_cmp_ge_i32_e64 vcc, v7, v133
		v_max_f32_e32 v132, v138, v139
		v_max_f32_e32 v133, v140, v141
		v_accvgpr_read_b32 v187, a167
		v_cndmask_b32_e32 v217, v72, v187, vcc
		v_cmp_ge_i32_e64 vcc, v7, v204
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v7, v205
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v7, v134
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v134, a168
		v_cndmask_b32_e64 v204, v72, v134, s[46:47]
		v_accvgpr_read_b32 v134, a169
		v_cndmask_b32_e64 v205, v72, v134, s[52:53]
		v_accvgpr_read_b32 v134, a170
		v_cndmask_b32_e64 v218, v72, v134, s[54:55]
		v_cmp_ge_i32_e64 vcc, v7, v135
		v_max_f32_e32 v134, v144, v145
		v_max_f32_e32 v135, v146, v147
		v_accvgpr_read_b32 v187, a171
		v_cndmask_b32_e32 v219, v72, v187, vcc
		v_cmp_ge_i32_e64 vcc, v7, v206
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v7, v207
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v7, v188
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v187, a172
		v_cndmask_b32_e64 v206, v72, v187, s[46:47]
		v_accvgpr_read_b32 v187, a173
		v_cndmask_b32_e64 v207, v72, v187, s[52:53]
		v_accvgpr_read_b32 v187, a174
		v_cndmask_b32_e64 v220, v72, v187, s[54:55]
		v_cmp_ge_i32_e64 vcc, v7, v189
		v_max_f32_e32 v187, v160, v161
		v_max_f32_e32 v188, v162, v163
		v_accvgpr_read_b32 v189, a175
		v_cndmask_b32_e32 v221, v72, v189, vcc
		v_max_f32_e32 v72, v166, v167
		v_max_f32_e32 v189, v168, v169
		v_max_f32_e32 v222, v172, v173
		v_max_f32_e32 v223, v174, v175
		v_max_f32_e32 v18, v18, v19
		v_max_f32_e32 v19, v20, v25
		v_max_f32_e32 v20, v65, v67
		v_max_f32_e32 v25, v70, v71
		v_max_f32_e32 v65, v73, v116
		v_max_f32_e32 v67, v117, v118
		v_max_f32_e32 v70, v119, v178
		v_max_f32_e32 v71, v179, v180
		v_max_f32_e32 v73, v181, v182
		v_max_f32_e32 v116, v183, v184
		v_max_f32_e32 v117, v185, v186
		v_max_f32_e32 v118, v132, v133
		v_max_f32_e32 v119, v134, v135
		v_max_f32_e32 v132, v187, v188
		v_max_f32_e32 v72, v72, v189
		v_max_f32_e32 v133, v222, v223
		v_max_f32_e32 v18, v18, v19
		v_max_f32_e32 v19, v20, v25
		v_max_f32_e32 v20, v65, v67
		v_max_f32_e32 v25, v70, v71
		v_max_f32_e32 v65, v73, v116
		v_max_f32_e32 v67, v117, v118
		v_max_f32_e32 v70, v119, v132
		v_max_f32_e32 v71, v72, v133
		v_max_f32_e32 v18, v18, v19
		v_max_f32_e32 v19, v20, v25
		v_max_f32_e32 v20, v65, v67
		v_max_f32_e32 v25, v70, v71
		v_max_f32_e32 v18, v18, v19
		v_max_f32_e32 v19, v20, v25
		v_max_f32_e32 v18, v18, v19
		v_and_b32_e32 v19, 1, v10
		v_lshrrev_b32_e32 v20, 4, v10
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v20, 4, v20
		v_lshrrev_b32_e32 v25, 3, v10
		v_and_b32_e32 v25, 1, v25
		v_lshlrev_b32_e32 v25, 3, v25
		v_add3_u32 v19, v19, v20, v25
		v_lshrrev_b32_e32 v20, 2, v10
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v20, 2, v20
		v_lshrrev_b32_e32 v25, 1, v10
		v_and_b32_e32 v25, 1, v25
		v_lshlrev_b32_e32 v25, 1, v25
		v_add3_u32 v19, v19, v20, v25
		v_lshlrev_b32_e32 v19, 2, v19
		ds_bpermute_b32 v20, v19, v18
		v_lshrrev_b32_e32 v25, 4, v10
		v_and_b32_e32 v25, 1, v25
		v_lshlrev_b32_e32 v25, 4, v25
		v_lshrrev_b32_e32 v65, 3, v10
		v_and_b32_e32 v65, 1, v65
		v_lshlrev_b32_e32 v65, 3, v65
		v_lshrrev_b32_e32 v67, 2, v10
		v_and_b32_e32 v67, 1, v67
		v_lshlrev_b32_e32 v67, 2, v67
		v_and_b32_e32 v70, 1, v10
		v_add_u32_e32 v70, 32, v70
		v_lshrrev_b32_e32 v71, 1, v10
		v_and_b32_e32 v71, 1, v71
		v_lshlrev_b32_e32 v71, 1, v71
		v_bitop3_b32 v67, v67, v70, v71 bitop3:0x96
		v_bitop3_b32 v25, v25, v65, v67 bitop3:0x96
		v_lshlrev_b32_e32 v25, 2, v25
		ds_bpermute_b32 v65, v25, v18
		v_max_f32_e32 v18, v224, v225
		v_max_f32_e32 v67, v226, v227
		v_max_f32_e32 v70, v22, v23
		v_max_f32_e32 v71, v28, v29
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v72, v20, v65
		v_max_f32_e32 v20, v30, v31
		v_max_f32_e32 v65, v230, v231
		v_max_f32_e32 v73, v26, v27
		v_max_f32_e32 v116, v100, v101
		v_max_f32_e32 v117, v102, v103
		v_max_f32_e32 v118, v232, v233
		v_max_f32_e32 v119, v190, v191
		v_max_f32_e32 v132, v234, v235
		v_max_f32_e32 v133, v156, v157
		v_max_f32_e32 v134, v236, v237
		v_max_f32_e32 v135, v158, v159
		v_max_f32_e32 v178, v238, v239
		v_max_f32_e32 v179, v176, v177
		v_max_f32_e32 v180, v192, v193
		v_max_f32_e32 v181, v194, v195
		v_max_f32_e32 v182, v208, v209
		v_max_f32_e32 v183, v196, v197
		v_max_f32_e32 v184, v210, v211
		v_max_f32_e32 v185, v198, v199
		v_max_f32_e32 v186, v212, v213
		v_max_f32_e32 v187, v200, v201
		v_max_f32_e32 v188, v214, v215
		v_max_f32_e32 v189, v202, v203
		v_max_f32_e32 v222, v216, v217
		v_max_f32_e32 v223, v204, v205
		v_max_f32_e32 v240, v218, v219
		v_max_f32_e32 v241, v206, v207
		v_max_f32_e32 v242, v220, v221
		v_max_f32_e32 v18, v18, v67
		v_max_f32_e32 v67, v70, v71
		v_max_f32_e32 v20, v20, v65
		v_max_f32_e32 v65, v73, v116
		v_max_f32_e32 v70, v117, v118
		v_max_f32_e32 v71, v119, v132
		v_max_f32_e32 v73, v133, v134
		v_max_f32_e32 v116, v135, v178
		v_max_f32_e32 v117, v179, v180
		v_max_f32_e32 v118, v181, v182
		v_max_f32_e32 v119, v183, v184
		v_max_f32_e32 v132, v185, v186
		v_max_f32_e32 v133, v187, v188
		v_max_f32_e32 v134, v189, v222
		v_max_f32_e32 v135, v223, v240
		v_max_f32_e32 v178, v241, v242
		v_max_f32_e32 v18, v18, v67
		v_max_f32_e32 v20, v20, v65
		v_max_f32_e32 v65, v70, v71
		v_max_f32_e32 v67, v73, v116
		v_max_f32_e32 v70, v117, v118
		v_max_f32_e32 v71, v119, v132
		v_max_f32_e32 v73, v133, v134
		v_max_f32_e32 v116, v135, v178
		v_max_f32_e32 v18, v18, v20
		v_max_f32_e32 v20, v65, v67
		v_max_f32_e32 v65, v70, v71
		v_max_f32_e32 v67, v73, v116
		v_max_f32_e32 v18, v18, v20
		v_max_f32_e32 v20, v65, v67
		v_max_f32_e32 v18, v18, v20
		ds_bpermute_b32 v20, v19, v18
		ds_bpermute_b32 v65, v25, v18
		v_mov_b32_e32 v70, 0x3e38aa3b
		v_mov_b32_e32 v71, 0x3e38aa3b
		v_pk_mul_f32 v[116:117], v[76:77], v[70:71]
		v_pk_mul_f32 v[76:77], v[74:75], v[70:71]
		v_pk_mul_f32 v[74:75], v[96:97], v[70:71]
		v_pk_mul_f32 v[96:97], v[78:79], v[70:71]
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v73, v20, v65
		v_pk_mul_f32 v[78:79], v[72:73], v[70:71]
		v_max_f32_e32 v18, v15, v78
		v_max_f32_e32 v20, v14, v79
		v_pk_mul_f32 v[72:73], v[106:107], v[70:71]
		v_pk_mul_f32 v[78:79], v[98:99], v[70:71]
		v_pk_mul_f32 v[98:99], v[110:111], v[70:71]
		v_pk_mul_f32 v[106:107], v[104:105], v[70:71]
		v_pk_mul_f32 v[104:105], v[120:121], v[70:71]
		v_pk_mul_f32 v[110:111], v[108:109], v[70:71]
		v_pk_mul_f32 v[108:109], v[124:125], v[70:71]
		v_pk_mul_f32 v[118:119], v[112:113], v[70:71]
		v_pk_mul_f32 v[112:113], v[130:131], v[70:71]
		v_pk_mul_f32 v[120:121], v[114:115], v[70:71]
		v_pk_mul_f32 v[114:115], v[142:143], v[70:71]
		v_pk_mul_f32 v[124:125], v[122:123], v[70:71]
		v_pk_mul_f32 v[122:123], v[164:165], v[70:71]
		v_pk_mul_f32 v[130:131], v[126:127], v[70:71]
		v_pk_mul_f32 v[126:127], v[170:171], v[70:71]
		v_pk_mul_f32 v[132:133], v[128:129], v[70:71]
		v_pk_mul_f32 v[128:129], v[228:229], v[70:71]
		v_pk_mul_f32 v[134:135], v[136:137], v[70:71]
		v_pk_mul_f32 v[136:137], v[138:139], v[70:71]
		v_pk_mul_f32 v[138:139], v[140:141], v[70:71]
		v_pk_mul_f32 v[140:141], v[144:145], v[70:71]
		v_pk_mul_f32 v[142:143], v[146:147], v[70:71]
		v_pk_mul_f32 v[144:145], v[160:161], v[70:71]
		v_pk_mul_f32 v[146:147], v[162:163], v[70:71]
		v_pk_mul_f32 v[160:161], v[166:167], v[70:71]
		v_pk_mul_f32 v[162:163], v[168:169], v[70:71]
		v_pk_mul_f32 v[164:165], v[172:173], v[70:71]
		v_pk_mul_f32 v[166:167], v[174:175], v[70:71]
		v_pk_mul_f32 v[168:169], v[224:225], v[70:71]
		v_pk_mul_f32 v[170:171], v[226:227], v[70:71]
		v_pk_mul_f32 v[172:173], v[22:23], v[70:71]
		v_pk_mul_f32 v[22:23], v[28:29], v[70:71]
		v_pk_mul_f32 v[28:29], v[30:31], v[70:71]
		v_pk_mul_f32 v[30:31], v[230:231], v[70:71]
		v_pk_mul_f32 v[174:175], v[26:27], v[70:71]
		v_pk_mul_f32 v[26:27], v[100:101], v[70:71]
		v_pk_mul_f32 v[100:101], v[102:103], v[70:71]
		v_pk_mul_f32 v[102:103], v[232:233], v[70:71]
		v_pk_mul_f32 v[178:179], v[190:191], v[70:71]
		v_pk_mul_f32 v[180:181], v[234:235], v[70:71]
		v_pk_mul_f32 v[182:183], v[156:157], v[70:71]
		v_pk_mul_f32 v[156:157], v[236:237], v[70:71]
		v_pk_mul_f32 v[184:185], v[158:159], v[70:71]
		v_pk_mul_f32 v[158:159], v[238:239], v[70:71]
		v_pk_mul_f32 v[186:187], v[176:177], v[70:71]
		v_pk_mul_f32 v[176:177], v[192:193], v[70:71]
		v_pk_mul_f32 v[188:189], v[194:195], v[70:71]
		v_pk_mul_f32 v[190:191], v[208:209], v[70:71]
		v_pk_mul_f32 v[192:193], v[196:197], v[70:71]
		v_pk_mul_f32 v[194:195], v[210:211], v[70:71]
		v_pk_mul_f32 v[196:197], v[198:199], v[70:71]
		v_pk_mul_f32 v[198:199], v[212:213], v[70:71]
		v_pk_mul_f32 v[208:209], v[200:201], v[70:71]
		v_pk_mul_f32 v[200:201], v[214:215], v[70:71]
		v_pk_mul_f32 v[210:211], v[202:203], v[70:71]
		v_pk_mul_f32 v[202:203], v[216:217], v[70:71]
		v_pk_mul_f32 v[212:213], v[204:205], v[70:71]
		v_pk_mul_f32 v[204:205], v[218:219], v[70:71]
		v_pk_mul_f32 v[214:215], v[206:207], v[70:71]
		v_pk_mul_f32 v[206:207], v[220:221], v[70:71]
		v_sub_f32_e32 v65, v116, v18
		v_sub_f32_e32 v67, v117, v18
		v_sub_f32_e32 v70, v76, v18
		v_sub_f32_e32 v71, v77, v18
		v_sub_f32_e32 v74, v74, v18
		v_sub_f32_e32 v75, v75, v18
		v_sub_f32_e32 v76, v96, v18
		v_sub_f32_e32 v77, v97, v18
		v_sub_f32_e32 v72, v72, v18
		v_sub_f32_e32 v73, v73, v18
		v_sub_f32_e32 v78, v78, v18
		v_sub_f32_e32 v79, v79, v18
		v_sub_f32_e32 v96, v98, v18
		v_sub_f32_e32 v97, v99, v18
		v_sub_f32_e32 v98, v106, v18
		v_sub_f32_e32 v99, v107, v18
		v_sub_f32_e32 v104, v104, v18
		v_sub_f32_e32 v105, v105, v18
		v_sub_f32_e32 v106, v110, v18
		v_sub_f32_e32 v107, v111, v18
		v_sub_f32_e32 v108, v108, v18
		v_sub_f32_e32 v109, v109, v18
		v_sub_f32_e32 v110, v118, v18
		v_sub_f32_e32 v111, v119, v18
		v_sub_f32_e32 v112, v112, v18
		v_sub_f32_e32 v113, v113, v18
		v_sub_f32_e32 v116, v120, v18
		v_sub_f32_e32 v117, v121, v18
		v_sub_f32_e32 v114, v114, v18
		v_sub_f32_e32 v115, v115, v18
		v_sub_f32_e32 v118, v124, v18
		v_sub_f32_e32 v119, v125, v18
		v_sub_f32_e32 v120, v122, v18
		v_sub_f32_e32 v121, v123, v18
		v_sub_f32_e32 v122, v130, v18
		v_sub_f32_e32 v123, v131, v18
		v_sub_f32_e32 v124, v126, v18
		v_sub_f32_e32 v125, v127, v18
		v_sub_f32_e32 v126, v132, v18
		v_sub_f32_e32 v127, v133, v18
		v_sub_f32_e32 v128, v128, v18
		v_sub_f32_e32 v129, v129, v18
		v_sub_f32_e32 v130, v134, v18
		v_sub_f32_e32 v131, v135, v18
		v_sub_f32_e32 v132, v136, v18
		v_sub_f32_e32 v133, v137, v18
		v_sub_f32_e32 v134, v138, v18
		v_sub_f32_e32 v135, v139, v18
		v_sub_f32_e32 v136, v140, v18
		v_sub_f32_e32 v137, v141, v18
		v_sub_f32_e32 v138, v142, v18
		v_sub_f32_e32 v139, v143, v18
		v_sub_f32_e32 v140, v144, v18
		v_sub_f32_e32 v141, v145, v18
		v_sub_f32_e32 v142, v146, v18
		v_sub_f32_e32 v143, v147, v18
		v_sub_f32_e32 v144, v160, v18
		v_sub_f32_e32 v145, v161, v18
		v_sub_f32_e32 v146, v162, v18
		v_sub_f32_e32 v147, v163, v18
		v_sub_f32_e32 v160, v164, v18
		v_sub_f32_e32 v161, v165, v18
		v_sub_f32_e32 v162, v166, v18
		v_sub_f32_e32 v163, v167, v18
		v_sub_f32_e32 v164, v168, v20
		v_sub_f32_e32 v165, v169, v20
		v_sub_f32_e32 v166, v170, v20
		v_sub_f32_e32 v167, v171, v20
		v_sub_f32_e32 v168, v172, v20
		v_sub_f32_e32 v169, v173, v20
		v_sub_f32_e32 v22, v22, v20
		v_sub_f32_e32 v23, v23, v20
		v_sub_f32_e32 v28, v28, v20
		v_sub_f32_e32 v29, v29, v20
		v_sub_f32_e32 v30, v30, v20
		v_sub_f32_e32 v31, v31, v20
		v_sub_f32_e32 v170, v174, v20
		v_sub_f32_e32 v171, v175, v20
		v_sub_f32_e32 v26, v26, v20
		v_sub_f32_e32 v27, v27, v20
		v_sub_f32_e32 v100, v100, v20
		v_sub_f32_e32 v101, v101, v20
		v_sub_f32_e32 v102, v102, v20
		v_sub_f32_e32 v103, v103, v20
		v_sub_f32_e32 v172, v178, v20
		v_sub_f32_e32 v173, v179, v20
		v_sub_f32_e32 v174, v180, v20
		v_sub_f32_e32 v175, v181, v20
		v_sub_f32_e32 v178, v182, v20
		v_sub_f32_e32 v179, v183, v20
		v_sub_f32_e32 v156, v156, v20
		v_sub_f32_e32 v157, v157, v20
		v_sub_f32_e32 v180, v184, v20
		v_sub_f32_e32 v181, v185, v20
		v_sub_f32_e32 v158, v158, v20
		v_sub_f32_e32 v159, v159, v20
		v_sub_f32_e32 v182, v186, v20
		v_sub_f32_e32 v183, v187, v20
		v_sub_f32_e32 v176, v176, v20
		v_sub_f32_e32 v177, v177, v20
		v_sub_f32_e32 v184, v188, v20
		v_sub_f32_e32 v185, v189, v20
		v_sub_f32_e32 v186, v190, v20
		v_sub_f32_e32 v187, v191, v20
		v_sub_f32_e32 v188, v192, v20
		v_sub_f32_e32 v189, v193, v20
		v_sub_f32_e32 v190, v194, v20
		v_sub_f32_e32 v191, v195, v20
		v_sub_f32_e32 v192, v196, v20
		v_sub_f32_e32 v193, v197, v20
		v_sub_f32_e32 v194, v198, v20
		v_sub_f32_e32 v195, v199, v20
		v_sub_f32_e32 v196, v208, v20
		v_sub_f32_e32 v197, v209, v20
		v_sub_f32_e32 v198, v200, v20
		v_sub_f32_e32 v199, v201, v20
		v_sub_f32_e32 v200, v210, v20
		v_sub_f32_e32 v201, v211, v20
		v_sub_f32_e32 v202, v202, v20
		v_sub_f32_e32 v203, v203, v20
		v_sub_f32_e32 v208, v212, v20
		v_sub_f32_e32 v209, v213, v20
		v_sub_f32_e32 v204, v204, v20
		v_sub_f32_e32 v205, v205, v20
		v_sub_f32_e32 v210, v214, v20
		v_sub_f32_e32 v211, v215, v20
		v_sub_f32_e32 v206, v206, v20
		v_sub_f32_e32 v207, v207, v20
		v_exp_f32_e32 v212, v65
		v_exp_f32_e32 v214, v67
		v_exp_f32_e32 v213, v70
		v_exp_f32_e32 v215, v71
		v_exp_f32_e32 v70, v74
		v_exp_f32_e32 v216, v75
		v_exp_f32_e32 v71, v76
		v_exp_f32_e32 v217, v77
		v_exp_f32_e32 v74, v72
		v_exp_f32_e32 v76, v73
		v_exp_f32_e32 v75, v78
		v_exp_f32_e32 v77, v79
		v_exp_f32_e32 v72, v96
		v_exp_f32_e32 v78, v97
		v_exp_f32_e32 v73, v98
		v_exp_f32_e32 v79, v99
		v_exp_f32_e32 v96, v104
		v_exp_f32_e32 v98, v105
		v_exp_f32_e32 v97, v106
		v_exp_f32_e32 v99, v107
		v_exp_f32_e32 v104, v108
		v_exp_f32_e32 v106, v109
		v_exp_f32_e32 v105, v110
		v_exp_f32_e32 v107, v111
		v_exp_f32_e32 v108, v112
		v_exp_f32_e32 v110, v113
		v_exp_f32_e32 v109, v116
		v_exp_f32_e32 v111, v117
		v_exp_f32_e32 v112, v114
		v_exp_f32_e32 v116, v115
		v_exp_f32_e32 v113, v118
		v_exp_f32_e32 v117, v119
		v_exp_f32_e32 v114, v120
		v_exp_f32_e32 v118, v121
		v_exp_f32_e32 v115, v122
		v_exp_f32_e32 v119, v123
		v_exp_f32_e32 v120, v124
		v_exp_f32_e32 v122, v125
		v_exp_f32_e32 v121, v126
		v_exp_f32_e32 v123, v127
		v_exp_f32_e32 v124, v128
		v_exp_f32_e32 v126, v129
		v_exp_f32_e32 v125, v130
		v_exp_f32_e32 v127, v131
		v_exp_f32_e32 v128, v132
		v_exp_f32_e32 v130, v133
		v_exp_f32_e32 v129, v134
		v_exp_f32_e32 v131, v135
		v_exp_f32_e32 v132, v136
		v_exp_f32_e32 v134, v137
		v_exp_f32_e32 v133, v138
		v_exp_f32_e32 v135, v139
		v_exp_f32_e32 v136, v140
		v_exp_f32_e32 v138, v141
		v_exp_f32_e32 v137, v142
		v_exp_f32_e32 v139, v143
		v_exp_f32_e32 v140, v144
		v_exp_f32_e32 v142, v145
		v_exp_f32_e32 v141, v146
		v_exp_f32_e32 v143, v147
		v_exp_f32_e32 v144, v160
		v_exp_f32_e32 v146, v161
		v_exp_f32_e32 v145, v162
		v_exp_f32_e32 v147, v163
		v_exp_f32_e32 v161, v164
		v_exp_f32_e32 v163, v165
		v_exp_f32_e32 v164, v166
		v_exp_f32_e32 v218, v167
		v_exp_f32_e32 v165, v168
		v_exp_f32_e32 v219, v169
		v_exp_f32_e32 v166, v22
		v_exp_f32_e32 v168, v23
		v_exp_f32_e32 v167, v28
		v_exp_f32_e32 v169, v29
		v_exp_f32_e32 v22, v30
		v_exp_f32_e32 v28, v31
		v_exp_f32_e32 v23, v170
		v_exp_f32_e32 v29, v171
		v_exp_f32_e32 v30, v26
		v_exp_f32_e32 v170, v27
		v_exp_f32_e32 v31, v100
		v_exp_f32_e32 v171, v101
		v_exp_f32_e32 v26, v102
		v_exp_f32_e32 v100, v103
		v_exp_f32_e32 v27, v172
		v_exp_f32_e32 v101, v173
		v_exp_f32_e32 v102, v174
		v_exp_f32_e32 v172, v175
		v_exp_f32_e32 v103, v178
		v_exp_f32_e32 v173, v179
		v_exp_f32_e32 v174, v156
		v_exp_f32_e32 v178, v157
		v_exp_f32_e32 v175, v180
		v_exp_f32_e32 v179, v181
		v_exp_f32_e32 v156, v158
		v_exp_f32_e32 v180, v159
		v_exp_f32_e32 v157, v182
		v_exp_f32_e32 v181, v183
		v_exp_f32_e32 v158, v176
		v_exp_f32_e32 v182, v177
		v_exp_f32_e32 v159, v184
		v_exp_f32_e32 v183, v185
		v_exp_f32_e32 v176, v186
		v_exp_f32_e32 v184, v187
		v_exp_f32_e32 v177, v188
		v_exp_f32_e32 v185, v189
		v_exp_f32_e32 v186, v190
		v_exp_f32_e32 v188, v191
		v_exp_f32_e32 v187, v192
		v_exp_f32_e32 v189, v193
		v_exp_f32_e32 v190, v194
		v_exp_f32_e32 v192, v195
		v_exp_f32_e32 v191, v196
		v_exp_f32_e32 v193, v197
		v_exp_f32_e32 v194, v198
		v_exp_f32_e32 v196, v199
		v_exp_f32_e32 v195, v200
		v_exp_f32_e32 v197, v201
		v_exp_f32_e32 v198, v202
		v_exp_f32_e32 v200, v203
		v_exp_f32_e32 v199, v208
		v_exp_f32_e32 v201, v209
		v_exp_f32_e32 v202, v204
		v_exp_f32_e32 v208, v205
		v_exp_f32_e32 v203, v210
		v_exp_f32_e32 v209, v211
		v_exp_f32_e32 v204, v206
		v_exp_f32_e32 v210, v207
		v_pk_add_f32 v[206:207], v[212:213], v[214:215]
		v_pk_add_f32 v[220:221], v[70:71], v[216:217]
		v_pk_add_f32 v[222:223], v[74:75], v[76:77]
		v_pk_add_f32 v[224:225], v[72:73], v[78:79]
		v_pk_add_f32 v[226:227], v[96:97], v[98:99]
		v_pk_add_f32 v[228:229], v[104:105], v[106:107]
		v_pk_add_f32 v[230:231], v[108:109], v[110:111]
		v_pk_add_f32 v[232:233], v[112:113], v[116:117]
		v_pk_add_f32 v[234:235], v[114:115], v[118:119]
		v_pk_add_f32 v[236:237], v[120:121], v[122:123]
		v_pk_add_f32 v[238:239], v[124:125], v[126:127]
		v_pk_add_f32 v[240:241], v[128:129], v[130:131]
		v_pk_add_f32 v[242:243], v[132:133], v[134:135]
		v_pk_add_f32 v[244:245], v[136:137], v[138:139]
		v_pk_add_f32 v[246:247], v[140:141], v[142:143]
		v_pk_add_f32 v[248:249], v[144:145], v[146:147]
		v_mov_b32_e32 v250, v207
		v_mov_b32_e32 v251, v221
		v_mov_b32_e32 v252, v206
		v_mov_b32_e32 v253, v220
		v_pk_add_f32 v[206:207], v[252:253], v[250:251]
		v_mov_b32_e32 v220, v223
		v_mov_b32_e32 v221, v225
		v_mov_b32_e32 v250, v222
		v_mov_b32_e32 v251, v224
		v_pk_add_f32 v[222:223], v[250:251], v[220:221]
		v_mov_b32_e32 v220, v227
		v_mov_b32_e32 v221, v229
		v_mov_b32_e32 v224, v226
		v_mov_b32_e32 v225, v228
		v_pk_add_f32 v[226:227], v[224:225], v[220:221]
		v_mov_b32_e32 v220, v231
		v_mov_b32_e32 v221, v233
		v_mov_b32_e32 v224, v230
		v_mov_b32_e32 v225, v232
		v_pk_add_f32 v[228:229], v[224:225], v[220:221]
		v_mov_b32_e32 v220, v235
		v_mov_b32_e32 v221, v237
		v_mov_b32_e32 v224, v234
		v_mov_b32_e32 v225, v236
		v_pk_add_f32 v[230:231], v[224:225], v[220:221]
		v_mov_b32_e32 v220, v239
		v_mov_b32_e32 v221, v241
		v_mov_b32_e32 v224, v238
		v_mov_b32_e32 v225, v240
		v_pk_add_f32 v[232:233], v[224:225], v[220:221]
		v_mov_b32_e32 v220, v243
		v_mov_b32_e32 v221, v245
		v_mov_b32_e32 v224, v242
		v_mov_b32_e32 v225, v244
		v_pk_add_f32 v[234:235], v[224:225], v[220:221]
		v_mov_b32_e32 v220, v247
		v_mov_b32_e32 v221, v249
		v_mov_b32_e32 v224, v246
		v_mov_b32_e32 v225, v248
		v_pk_add_f32 v[236:237], v[224:225], v[220:221]
		v_mov_b32_e32 v220, v207
		v_mov_b32_e32 v221, v223
		v_mov_b32_e32 v224, v206
		v_mov_b32_e32 v225, v222
		v_pk_add_f32 v[206:207], v[224:225], v[220:221]
		v_mov_b32_e32 v220, v227
		v_mov_b32_e32 v221, v229
		v_mov_b32_e32 v222, v226
		v_mov_b32_e32 v223, v228
		v_pk_add_f32 v[224:225], v[222:223], v[220:221]
		v_mov_b32_e32 v220, v231
		v_mov_b32_e32 v221, v233
		v_mov_b32_e32 v222, v230
		v_mov_b32_e32 v223, v232
		v_pk_add_f32 v[226:227], v[222:223], v[220:221]
		v_mov_b32_e32 v220, v235
		v_mov_b32_e32 v221, v237
		v_mov_b32_e32 v222, v234
		v_mov_b32_e32 v223, v236
		v_pk_add_f32 v[228:229], v[222:223], v[220:221]
		v_mov_b32_e32 v220, v207
		v_mov_b32_e32 v221, v225
		v_mov_b32_e32 v222, v206
		v_mov_b32_e32 v223, v224
		v_pk_add_f32 v[206:207], v[222:223], v[220:221]
		v_mov_b32_e32 v220, v227
		v_mov_b32_e32 v221, v229
		v_mov_b32_e32 v222, v226
		v_mov_b32_e32 v223, v228
		v_pk_add_f32 v[224:225], v[222:223], v[220:221]
		v_mov_b32_e32 v220, v207
		v_mov_b32_e32 v221, v225
		v_mov_b32_e32 v222, v206
		v_mov_b32_e32 v223, v224
		v_pk_add_f32 v[206:207], v[222:223], v[220:221]
		v_add_f32_e32 v65, v206, v207
		ds_bpermute_b32 v160, v19, v65
		ds_bpermute_b32 v162, v25, v65
		v_pk_add_f32 v[206:207], v[164:165], v[218:219]
		v_pk_add_f32 v[220:221], v[166:167], v[168:169]
		v_pk_add_f32 v[222:223], v[22:23], v[28:29]
		v_pk_add_f32 v[224:225], v[30:31], v[170:171]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[226:227], v[160:161], v[162:163]
		v_pk_add_f32 v[228:229], v[26:27], v[100:101]
		v_pk_add_f32 v[230:231], v[102:103], v[172:173]
		v_pk_add_f32 v[232:233], v[174:175], v[178:179]
		v_pk_add_f32 v[234:235], v[156:157], v[180:181]
		v_pk_add_f32 v[236:237], v[158:159], v[182:183]
		v_pk_add_f32 v[238:239], v[176:177], v[184:185]
		v_pk_add_f32 v[240:241], v[186:187], v[188:189]
		v_pk_add_f32 v[242:243], v[190:191], v[192:193]
		v_pk_add_f32 v[244:245], v[194:195], v[196:197]
		v_pk_add_f32 v[246:247], v[198:199], v[200:201]
		v_pk_add_f32 v[248:249], v[202:203], v[208:209]
		v_mov_b32_e32 v205, v227
		v_mov_b32_e32 v211, v206
		v_pk_add_f32 v[250:251], v[204:205], v[210:211]
		v_mov_b32_e32 v252, v207
		v_mov_b32_e32 v253, v222
		v_pk_add_f32 v[206:207], v[252:253], v[220:221]
		v_mov_b32_e32 v220, v223
		v_mov_b32_e32 v221, v228
		v_pk_add_f32 v[220:221], v[220:221], v[224:225]
		v_mov_b32_e32 v222, v229
		v_mov_b32_e32 v223, v232
		v_pk_add_f32 v[224:225], v[222:223], v[230:231]
		v_mov_b32_e32 v222, v233
		v_mov_b32_e32 v223, v236
		v_pk_add_f32 v[222:223], v[222:223], v[234:235]
		v_mov_b32_e32 v228, v237
		v_mov_b32_e32 v229, v240
		v_pk_add_f32 v[230:231], v[228:229], v[238:239]
		v_mov_b32_e32 v228, v241
		v_mov_b32_e32 v229, v244
		v_pk_add_f32 v[228:229], v[228:229], v[242:243]
		v_mov_b32_e32 v232, v245
		v_mov_b32_e32 v233, v248
		v_pk_add_f32 v[234:235], v[232:233], v[246:247]
		v_mov_b32_e32 v232, v249
		v_mov_b32_e32 v233, v206
		v_pk_add_f32 v[232:233], v[232:233], v[250:251]
		v_mov_b32_e32 v236, v207
		v_mov_b32_e32 v237, v224
		v_pk_add_f32 v[206:207], v[236:237], v[220:221]
		v_mov_b32_e32 v220, v225
		v_mov_b32_e32 v221, v230
		v_pk_add_f32 v[220:221], v[220:221], v[222:223]
		v_mov_b32_e32 v222, v231
		v_mov_b32_e32 v223, v234
		v_pk_add_f32 v[224:225], v[222:223], v[228:229]
		v_mov_b32_e32 v222, v235
		v_mov_b32_e32 v223, v206
		v_pk_add_f32 v[222:223], v[222:223], v[232:233]
		v_mov_b32_e32 v228, v207
		v_mov_b32_e32 v229, v224
		v_pk_add_f32 v[206:207], v[228:229], v[220:221]
		v_mov_b32_e32 v220, v225
		v_mov_b32_e32 v221, v206
		v_pk_add_f32 v[224:225], v[220:221], v[222:223]
		v_add_f32_e32 v65, v207, v224
		v_add_f32_e32 v65, v225, v65
		ds_bpermute_b32 v67, v19, v65
		ds_bpermute_b32 v19, v25, v65
		v_sub_f32_e32 v15, v15, v18
		v_sub_f32_e32 v14, v14, v20
		v_exp_f32_e32 v206, v15
		v_exp_f32_e32 v220, v14
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v15, v67, v19
		v_mov_b32_e32 v207, v206
		v_pk_mul_f32 v[32:33], v[32:33], v[206:207]
		v_pk_mul_f32 v[34:35], v[34:35], v[206:207]
		v_pk_mul_f32 v[36:37], v[36:37], v[206:207]
		v_pk_mul_f32 v[38:39], v[38:39], v[206:207]
		v_pk_mul_f32 v[40:41], v[40:41], v[206:207]
		v_pk_mul_f32 v[42:43], v[42:43], v[206:207]
		v_pk_mul_f32 v[44:45], v[44:45], v[206:207]
		v_pk_mul_f32 v[46:47], v[46:47], v[206:207]
		v_pk_mul_f32 v[48:49], v[48:49], v[206:207]
		v_pk_mul_f32 v[50:51], v[50:51], v[206:207]
		v_pk_mul_f32 v[52:53], v[52:53], v[206:207]
		v_pk_mul_f32 v[54:55], v[54:55], v[206:207]
		v_pk_mul_f32 v[56:57], v[56:57], v[206:207]
		v_pk_mul_f32 v[58:59], v[58:59], v[206:207]
		v_pk_mul_f32 v[60:61], v[60:61], v[206:207]
		v_pk_mul_f32 v[62:63], v[62:63], v[206:207]
		v_mov_b32_e32 v221, v220
		v_pk_mul_f32 v[80:81], v[80:81], v[220:221]
		v_pk_mul_f32 v[82:83], v[82:83], v[220:221]
		v_pk_mul_f32 v[84:85], v[84:85], v[220:221]
		v_pk_mul_f32 v[86:87], v[86:87], v[220:221]
		v_pk_mul_f32 v[88:89], v[88:89], v[220:221]
		v_pk_mul_f32 v[90:91], v[90:91], v[220:221]
		v_pk_mul_f32 v[92:93], v[92:93], v[220:221]
		v_pk_mul_f32 v[94:95], v[94:95], v[220:221]
		v_accvgpr_read_b32 v222, a48
		v_accvgpr_read_b32 v223, a49
		v_pk_mul_f32 v[222:223], v[222:223], v[220:221]
		v_accvgpr_write_b32 a48, v222
		v_accvgpr_write_b32 a49, v223
		v_accvgpr_read_b32 v222, a50
		v_accvgpr_read_b32 v223, a51
		v_pk_mul_f32 v[222:223], v[222:223], v[220:221]
		v_accvgpr_write_b32 a50, v222
		v_accvgpr_write_b32 a51, v223
		v_accvgpr_read_b32 v222, a52
		v_accvgpr_read_b32 v223, a53
		v_pk_mul_f32 v[222:223], v[222:223], v[220:221]
		v_accvgpr_write_b32 a52, v222
		v_accvgpr_write_b32 a53, v223
		v_accvgpr_read_b32 v222, a54
		v_accvgpr_read_b32 v223, a55
		v_pk_mul_f32 v[222:223], v[222:223], v[220:221]
		v_accvgpr_write_b32 a54, v222
		v_accvgpr_write_b32 a55, v223
		v_accvgpr_read_b32 v222, a56
		v_accvgpr_read_b32 v223, a57
		v_pk_mul_f32 v[222:223], v[222:223], v[220:221]
		v_accvgpr_write_b32 a56, v222
		v_accvgpr_write_b32 a57, v223
		v_accvgpr_read_b32 v222, a58
		v_accvgpr_read_b32 v223, a59
		v_pk_mul_f32 v[222:223], v[222:223], v[220:221]
		v_accvgpr_write_b32 a58, v222
		v_accvgpr_write_b32 a59, v223
		v_accvgpr_read_b32 v222, a60
		v_accvgpr_read_b32 v223, a61
		v_pk_mul_f32 v[222:223], v[222:223], v[220:221]
		v_accvgpr_write_b32 a60, v222
		v_accvgpr_write_b32 a61, v223
		v_accvgpr_read_b32 v222, a62
		v_accvgpr_read_b32 v223, a63
		v_pk_mul_f32 v[222:223], v[222:223], v[220:221]
		v_accvgpr_write_b32 a62, v222
		v_accvgpr_write_b32 a63, v223
		v_mov_b32_e32 v14, v226
		v_mov_b32_e32 v222, v206
		v_mov_b32_e32 v223, v220
		v_mov_b64_e32 v[206:207], v[16:17]
		v_pk_fma_f32 v[16:17], v[206:207], v[222:223], v[14:15]
		v_cvt_pk_bf16_f32 v220, v212, v214
		v_cvt_pk_bf16_f32 v221, v213, v215
		v_cvt_pk_bf16_f32 v222, v70, v216
		v_cvt_pk_bf16_f32 v223, v71, v217
		v_cvt_pk_bf16_f32 v212, v74, v76
		v_cvt_pk_bf16_f32 v213, v75, v77
		v_cvt_pk_bf16_f32 v214, v72, v78
		v_cvt_pk_bf16_f32 v215, v73, v79
		v_cvt_pk_bf16_f32 v72, v96, v98
		v_cvt_pk_bf16_f32 v73, v97, v99
		v_cvt_pk_bf16_f32 v74, v104, v106
		v_cvt_pk_bf16_f32 v75, v105, v107
		v_cvt_pk_bf16_f32 v76, v108, v110
		v_cvt_pk_bf16_f32 v77, v109, v111
		v_cvt_pk_bf16_f32 v78, v112, v116
		v_cvt_pk_bf16_f32 v79, v113, v117
		v_cvt_pk_bf16_f32 v96, v114, v118
		v_cvt_pk_bf16_f32 v97, v115, v119
		v_cvt_pk_bf16_f32 v98, v120, v122
		v_cvt_pk_bf16_f32 v99, v121, v123
		v_cvt_pk_bf16_f32 v104, v124, v126
		v_cvt_pk_bf16_f32 v105, v125, v127
		v_cvt_pk_bf16_f32 v106, v128, v130
		v_cvt_pk_bf16_f32 v107, v129, v131
		v_cvt_pk_bf16_f32 v108, v132, v134
		v_cvt_pk_bf16_f32 v109, v133, v135
		v_cvt_pk_bf16_f32 v110, v136, v138
		v_cvt_pk_bf16_f32 v111, v137, v139
		v_cvt_pk_bf16_f32 v112, v140, v142
		v_cvt_pk_bf16_f32 v113, v141, v143
		v_cvt_pk_bf16_f32 v114, v144, v146
		v_cvt_pk_bf16_f32 v115, v145, v147
		v_cvt_pk_bf16_f32 v116, v161, v163
		v_cvt_pk_bf16_f32 v117, v164, v218
		v_cvt_pk_bf16_f32 v118, v165, v219
		v_cvt_pk_bf16_f32 v119, v166, v168
		v_cvt_pk_bf16_f32 v120, v167, v169
		v_cvt_pk_bf16_f32 v121, v22, v28
		v_cvt_pk_bf16_f32 v122, v23, v29
		v_cvt_pk_bf16_f32 v123, v30, v170
		v_cvt_pk_bf16_f32 v124, v31, v171
		v_cvt_pk_bf16_f32 v125, v26, v100
		v_cvt_pk_bf16_f32 v126, v27, v101
		v_cvt_pk_bf16_f32 v127, v102, v172
		v_cvt_pk_bf16_f32 v28, v103, v173
		v_cvt_pk_bf16_f32 v29, v174, v178
		v_cvt_pk_bf16_f32 v30, v175, v179
		v_cvt_pk_bf16_f32 v31, v156, v180
		v_cvt_pk_bf16_f32 v100, v157, v181
		v_cvt_pk_bf16_f32 v101, v158, v182
		v_cvt_pk_bf16_f32 v102, v159, v183
		v_cvt_pk_bf16_f32 v103, v176, v184
		v_cvt_pk_bf16_f32 v128, v177, v185
		v_cvt_pk_bf16_f32 v129, v186, v188
		v_cvt_pk_bf16_f32 v130, v187, v189
		v_cvt_pk_bf16_f32 v131, v190, v192
		v_cvt_pk_bf16_f32 v132, v191, v193
		v_cvt_pk_bf16_f32 v133, v194, v196
		v_cvt_pk_bf16_f32 v134, v195, v197
		v_cvt_pk_bf16_f32 v135, v198, v200
		v_cvt_pk_bf16_f32 v136, v199, v201
		v_cvt_pk_bf16_f32 v137, v202, v208
		v_cvt_pk_bf16_f32 v138, v203, v209
		v_cvt_pk_bf16_f32 v139, v204, v210
		v_permlane32_swap_b32_e32 v220, v222
		v_permlane32_swap_b32_e32 v221, v223
		v_permlane32_swap_b32_e32 v212, v214
		v_permlane32_swap_b32_e32 v213, v215
		v_permlane32_swap_b32_e32 v72, v74
		v_permlane32_swap_b32_e32 v73, v75
		v_mfma_f32_32x32x16_bf16 v[32:47], v[148:151], v[220:223], v[32:47]
		v_permlane32_swap_b32_e32 v76, v78
		v_permlane32_swap_b32_e32 v77, v79
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_mfma_f32_32x32x16_bf16 v[48:63], v[152:155], v[220:223], v[48:63]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 a[48:63], v[152:155], v[116:119], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], v[148:151], v[116:119], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[0:3], v[212:215], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[76:79], v[212:215], v[48:63]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[76:79], v[120:123], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[0:3], v[120:123], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[36:39], v[72:75], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[80:83], v[72:75], v[48:63]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[80:83], v[124:127], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[36:39], v[124:127], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[40:43], v[76:79], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[84:87], v[76:79], v[48:63]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[84:87], v[28:31], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[40:43], v[28:31], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[44:47], v[96:99], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[88:91], v[96:99], v[48:63]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[88:91], v[100:103], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[44:47], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[64:67], v[104:107], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[92:95], v[104:107], v[48:63]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[92:95], v[128:131], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[64:67], v[128:131], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[68:71], v[108:111], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[96:99], v[108:111], v[48:63]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[96:99], v[132:135], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[68:71], v[132:135], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[72:75], v[112:115], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[100:103], v[112:115], v[48:63]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[100:103], v[136:139], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[72:75], v[136:139], v[80:95]
		s_mov_b32 s43, s26
		v_mov_b32_e32 v15, v18
		v_mov_b32_e32 v14, v20
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_4
.L_attn_fwd_persistent.loop_exit_4:
		v_rcp_f32_e32 v10, v16
		v_rcp_f32_e32 v14, v17
		v_mov_b32_e32 v11, v10
		s_nop 1
		v_pk_mul_f32 v[16:17], v[32:33], v[10:11]
		v_pk_mul_f32 v[18:19], v[34:35], v[10:11]
		v_pk_mul_f32 v[22:23], v[36:37], v[10:11]
		v_pk_mul_f32 v[26:27], v[38:39], v[10:11]
		v_pk_mul_f32 v[28:29], v[40:41], v[10:11]
		v_pk_mul_f32 v[30:31], v[42:43], v[10:11]
		v_pk_mul_f32 v[32:33], v[44:45], v[10:11]
		v_pk_mul_f32 v[34:35], v[46:47], v[10:11]
		v_pk_mul_f32 v[36:37], v[48:49], v[10:11]
		v_pk_mul_f32 v[38:39], v[50:51], v[10:11]
		v_pk_mul_f32 v[40:41], v[52:53], v[10:11]
		v_pk_mul_f32 v[42:43], v[54:55], v[10:11]
		v_pk_mul_f32 v[44:45], v[56:57], v[10:11]
		v_pk_mul_f32 v[46:47], v[58:59], v[10:11]
		v_pk_mul_f32 v[48:49], v[60:61], v[10:11]
		v_pk_mul_f32 v[50:51], v[62:63], v[10:11]
		v_mov_b32_e32 v15, v14
		v_pk_mul_f32 v[10:11], v[80:81], v[14:15]
		v_pk_mul_f32 v[52:53], v[82:83], v[14:15]
		v_pk_mul_f32 v[54:55], v[84:85], v[14:15]
		v_pk_mul_f32 v[56:57], v[86:87], v[14:15]
		v_pk_mul_f32 v[58:59], v[88:89], v[14:15]
		v_pk_mul_f32 v[60:61], v[90:91], v[14:15]
		v_pk_mul_f32 v[62:63], v[92:93], v[14:15]
		v_pk_mul_f32 v[70:71], v[94:95], v[14:15]
		v_accvgpr_read_b32 v72, a48
		v_accvgpr_read_b32 v73, a49
		v_pk_mul_f32 v[74:75], v[72:73], v[14:15]
		v_accvgpr_read_b32 v72, a50
		v_accvgpr_read_b32 v73, a51
		v_pk_mul_f32 v[76:77], v[72:73], v[14:15]
		v_accvgpr_read_b32 v72, a52
		v_accvgpr_read_b32 v73, a53
		v_pk_mul_f32 v[78:79], v[72:73], v[14:15]
		v_accvgpr_read_b32 v72, a54
		v_accvgpr_read_b32 v73, a55
		v_pk_mul_f32 v[80:81], v[72:73], v[14:15]
		v_accvgpr_read_b32 v72, a56
		v_accvgpr_read_b32 v73, a57
		v_pk_mul_f32 v[82:83], v[72:73], v[14:15]
		v_accvgpr_read_b32 v72, a58
		v_accvgpr_read_b32 v73, a59
		v_pk_mul_f32 v[84:85], v[72:73], v[14:15]
		v_accvgpr_read_b32 v72, a60
		v_accvgpr_read_b32 v73, a61
		v_pk_mul_f32 v[86:87], v[72:73], v[14:15]
		v_accvgpr_read_b32 v72, a62
		v_accvgpr_read_b32 v73, a63
		v_pk_mul_f32 v[88:89], v[72:73], v[14:15]
		v_cvt_pk_bf16_f32 v92, v16, v17
		v_cvt_pk_bf16_f32 v93, v18, v19
		v_cvt_pk_bf16_f32 v94, v22, v23
		v_cvt_pk_bf16_f32 v95, v26, v27
		v_cvt_pk_bf16_f32 v16, v28, v29
		v_cvt_pk_bf16_f32 v17, v30, v31
		v_cvt_pk_bf16_f32 v18, v32, v33
		v_cvt_pk_bf16_f32 v19, v34, v35
		v_cvt_pk_bf16_f32 v28, v36, v37
		v_cvt_pk_bf16_f32 v29, v38, v39
		v_cvt_pk_bf16_f32 v30, v40, v41
		v_cvt_pk_bf16_f32 v31, v42, v43
		v_cvt_pk_bf16_f32 v32, v44, v45
		v_cvt_pk_bf16_f32 v33, v46, v47
		v_cvt_pk_bf16_f32 v34, v48, v49
		v_cvt_pk_bf16_f32 v35, v50, v51
		v_cvt_pk_bf16_f32 v36, v10, v11
		v_cvt_pk_bf16_f32 v37, v52, v53
		v_cvt_pk_bf16_f32 v38, v54, v55
		v_cvt_pk_bf16_f32 v39, v56, v57
		v_cvt_pk_bf16_f32 v40, v58, v59
		v_cvt_pk_bf16_f32 v41, v60, v61
		v_cvt_pk_bf16_f32 v42, v62, v63
		v_cvt_pk_bf16_f32 v43, v70, v71
		v_cvt_pk_bf16_f32 v44, v74, v75
		v_cvt_pk_bf16_f32 v45, v76, v77
		v_cvt_pk_bf16_f32 v46, v78, v79
		v_cvt_pk_bf16_f32 v47, v80, v81
		v_cvt_pk_bf16_f32 v48, v82, v83
		v_cvt_pk_bf16_f32 v49, v84, v85
		v_cvt_pk_bf16_f32 v50, v86, v87
		v_cvt_pk_bf16_f32 v51, v88, v89
		v_permlane32_swap_b32_e32 v92, v94
		v_permlane32_swap_b32_e32 v93, v95
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
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
		s_lshl_b32 s1, s45, 9
		s_add_i32 s21, s1, s25
		s_add_i32 s21, s21, s41
		v_add3_u32 v7, s21, v9, v13
		v_add3_u32 v7, v7, v21, v24
		v_add3_u32 v7, v7, v64, v66
		v_add3_u32 v7, v7, v68, v69
		v_cndmask_b32_e64 v7, v12, v7, s[48:49]
		buffer_store_dwordx4 v[92:95], v7, s[36:39], 0 offen
		s_add_i32 s24, s1, 32
		s_add_i32 s24, s24, s25
		s_add_i32 s24, s24, s41
		v_add3_u32 v7, s24, v9, v13
		v_add3_u32 v7, v7, v21, v24
		v_add3_u32 v7, v7, v64, v66
		v_add3_u32 v7, v7, v68, v69
		v_cndmask_b32_e64 v7, v12, v7, s[48:49]
		buffer_store_dwordx4 v[16:19], v7, s[36:39], 0 offen
		s_add_i32 s26, s1, 64
		s_add_i32 s26, s26, s25
		s_add_i32 s26, s26, s41
		v_add3_u32 v7, s26, v9, v13
		v_add3_u32 v7, v7, v21, v24
		v_add3_u32 v7, v7, v64, v66
		v_add3_u32 v7, v7, v68, v69
		v_cndmask_b32_e64 v7, v12, v7, s[48:49]
		buffer_store_dwordx4 v[28:31], v7, s[36:39], 0 offen
		s_add_i32 s1, s1, 0x60
		s_add_i32 s1, s1, s25
		s_add_i32 s1, s1, s41
		v_add3_u32 v7, s1, v9, v13
		v_add3_u32 v7, v7, v21, v24
		v_add3_u32 v7, v7, v64, v66
		v_add3_u32 v7, v7, v68, v69
		v_cndmask_b32_e64 v7, v12, v7, s[48:49]
		buffer_store_dwordx4 v[32:35], v7, s[36:39], 0 offen
		v_add3_u32 v7, s21, v8, v69
		v_cndmask_b32_e64 v7, v12, v7, s[50:51]
		buffer_store_dwordx4 v[36:39], v7, s[36:39], 0 offen
		v_add3_u32 v7, s24, v8, v69
		v_cndmask_b32_e64 v7, v12, v7, s[50:51]
		buffer_store_dwordx4 v[40:43], v7, s[36:39], 0 offen
		v_add3_u32 v7, s26, v8, v69
		v_cndmask_b32_e64 v7, v12, v7, s[50:51]
		buffer_store_dwordx4 v[44:47], v7, s[36:39], 0 offen
		v_add3_u32 v7, s1, v8, v69
		v_cndmask_b32_e64 v7, v12, v7, s[50:51]
		buffer_store_dwordx4 v[48:51], v7, s[36:39], 0 offen
		s_branch .L_attn_fwd_persistent.if_end_0
.L_attn_fwd_persistent.if_else_0:
.L_attn_fwd_persistent.if_end_0:
		s_add_i32 s0, s0, 32
		v_readfirstlane_b32 s1, v6
		s_mul_i32 s1, s1, 16
		s_nop 0
		v_mov_b32_e32 v7, s1
		s_nop 0
		v_readfirstlane_b32 s1, v7
		s_cmp_lt_i32 s0, s1
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_0
.L_attn_fwd_persistent.loop_exit_0:
		s_endpgm
	.size	_attn_fwd_persistent, .-_attn_fwd_persistent
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _attn_fwd_persistent
		.amdhsa_group_segment_fixed_size 102832
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
		.amdhsa_next_free_vgpr 512
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
	.set .L_attn_fwd_persistent.num_agpr, 256
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
    .group_segment_fixed_size: 102832
    .kernarg_segment_align: 8
    .kernarg_segment_size: 104
    .max_flat_workgroup_size: 256
    .name:           _attn_fwd_persistent
    .private_segment_fixed_size: 0
    .sgpr_count:     102
    .sgpr_spill_count: 0
    .symbol:         _attn_fwd_persistent.kd
    .uses_dynamic_stack: false
    .vgpr_count:     512
    .agpr_count:     256
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 523
    wave.regalloc.agpr.dwords: 1166
    wave.regalloc.remat.dwords: 223
    wave.regalloc.sgpr_to_vgpr.dwords: 94
    wave.regalloc.lds.dwords: 2
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
