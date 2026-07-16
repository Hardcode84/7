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
		s_lshl_b32 s18, s17, 2
		s_add_i32 s18, s18, 0x189b0
		v_mov_b32_e32 v1, s18
		s_load_dword s19, s[0:1], 0x38
		s_load_dword s20, s[0:1], 0x3c
		s_load_dword s21, s[0:1], 0x40
		s_load_dword s22, s[0:1], 0x44
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v2, s22
		v_accvgpr_write_b32 a0, v2
		s_load_dword s22, s[0:1], 0x48
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v2, s22
		v_accvgpr_write_b32 a1, v2
		s_load_dword s22, s[0:1], 0x4c
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v2, s22
		s_load_dword s22, s[0:1], 0x50
		s_load_dword s23, s[0:1], 0x54
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v3, s23
		s_load_dword s23, s[0:1], 0x58
		s_load_dword s24, s[0:1], 0x5c
		s_load_dword s25, s[0:1], 0x60
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v4, s25
		s_and_b32 s0, s16, 7
		v_mov_b32_e32 v5, s0
		s_lshr_b32 s0, s16, 3
		v_readfirstlane_b32 s1, v3
		s_mul_i32 s1, s22, s1
		s_nop 0
		v_mov_b32_e32 v6, s1
		s_nop 0
		v_readfirstlane_b32 s1, v6
		s_add_i32 s1, s1, 7
		s_mov_b32 s16, 1
		s_mov_b32 s22, 7
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s22, s22, 0
		s_add_i32 s1, s1, s22
		s_ashr_i32 s1, s1, 3
		v_mov_b32_e32 v7, s1
		v_readfirstlane_b32 s1, v1
		s_mov_b32 m0, s1
		s_nop 0
		ds_write_addtid_b32 v7
		v_readfirstlane_b32 s1, v7
		s_mul_i32 s1, s1, 16
		s_nop 0
		v_mov_b32_e32 v1, s1
		s_nop 0
		v_readfirstlane_b32 s1, v1
		s_cmp_lt_i32 s0, s1
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_0
.L_attn_fwd_persistent.loop_head_0:
		s_lshr_b32 s1, s0, 4
		s_and_b32 s22, s0, 15
		s_mul_i32 s1, s1, 8
		v_readfirstlane_b32 s25, v5
		s_add_i32 s1, s25, s1
		v_readfirstlane_b32 s25, v6
		s_cmp_lt_i32 s1, s25
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_0
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s25, 1, 0
		s_xor_b32 s26, s1, -1
		s_add_i32 s26, s26, 1
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s25, s26, s1
		s_cselect_b32 s26, 1, 0
		v_readfirstlane_b32 s27, v3
		s_xor_b32 s27, s27, -1
		s_add_i32 s27, s27, 1
		v_readfirstlane_b32 s28, v3
		s_cmp_lt_i32 s28, 0
		v_readfirstlane_b32 s28, v3
		s_cselect_b32 s27, s27, s28
		v_mov_b32_e32 v1, s27
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		v_mov_b32_e32 v7, 0x4f7ffffe
		v_mul_f32_e32 v1, v7, v1
		v_cvt_u32_f32_e32 v1, v1
		s_xor_b32 s28, s27, -1
		v_readfirstlane_b32 s29, v1
		s_add_i32 s28, s28, 1
		s_mul_i32 s30, s28, s29
		s_mul_hi_u32 s30, s29, s30
		s_add_i32 s29, s29, s30
		s_mul_hi_u32 s29, s25, s29
		s_mul_i32 s30, s29, s27
		s_xor_b32 s30, s30, -1
		s_add_i32 s30, s30, 1
		s_add_i32 s25, s25, s30
		s_cmp_ge_u32 s25, s27
		s_cselect_b32 s30, 1, 0
		s_add_i32 s31, s29, 1
		s_cmp_lg_u32 s30, 0
		s_cselect_b32 s29, s31, s29
		s_cselect_b32 s30, 1, 0
		s_add_i32 s31, s25, s28
		s_cmp_lg_u32 s30, 0
		s_cselect_b32 s25, s31, s25
		s_cmp_ge_u32 s25, s27
		s_cselect_b32 s27, 1, 0
		s_add_i32 s30, s29, 1
		s_cmp_lg_u32 s27, 0
		s_cselect_b32 s27, s30, s29
		s_cselect_b32 s29, 1, 0
		v_readfirstlane_b32 s30, v3
		s_xor_b32 s1, s1, s30
		s_xor_b32 s30, s27, -1
		s_add_i32 s30, s30, 1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s1, s30, s27
		s_add_i32 s27, s25, s28
		s_cmp_lg_u32 s29, 0
		s_cselect_b32 s25, s27, s25
		s_xor_b32 s27, s25, -1
		s_add_i32 s27, s27, 1
		s_cmp_lg_u32 s26, 0
		s_cselect_b32 s25, s27, s25
		s_mul_i32 s22, s22, 2
		s_lshr_b32 s26, s22, 1
		s_and_b32 s22, s22, 1
		s_xor_b32 s27, s26, -1
		s_add_i32 s27, s27, 1
		s_add_i32 s27, s27, 31
		s_cmp_eq_u32 s22, 0
		s_cselect_b32 s22, s26, s27
		s_mov_b32 m0, s18
		v_mov_b32_e32 v1, s22
		ds_write_addtid_b32 v1 offset:1024
		v_readfirstlane_b32 s22, v1
		s_mul_i32 s22, s22, 0x100
		v_and_b32_e32 v7, 1, v0
		v_lshrrev_b32_e32 v8, 1, v0
		v_and_b32_e32 v9, 1, v8
		v_mov_b32_e32 v10, 2
		v_mul_lo_u32 v10, v10, v9
		v_lshrrev_b32_e32 v9, 2, v0
		v_and_b32_e32 v11, 1, v9
		v_mov_b32_e32 v12, 4
		v_mul_lo_u32 v12, v12, v11
		v_bitop3_b32 v11, v7, v10, v12 bitop3:0x96
		v_lshrrev_b32_e32 v13, 3, v0
		v_and_b32_e32 v14, 1, v13
		v_mov_b32_e32 v15, 8
		v_mul_lo_u32 v15, v15, v14
		v_xor_b32_e32 v11, v11, v15
		v_lshrrev_b32_e32 v16, 4, v0
		v_and_b32_e32 v17, 1, v16
		v_mov_b32_e32 v18, 16
		v_mul_lo_u32 v18, v18, v17
		v_lshrrev_b32_e32 v19, 6, v0
		v_and_b32_e32 v20, 1, v19
		v_mov_b32_e32 v21, 32
		v_mul_lo_u32 v21, v21, v20
		v_bitop3_b32 v11, v11, v18, v21 bitop3:0x96
		v_lshrrev_b32_e32 v22, 7, v0
		v_and_b32_e32 v23, 1, v22
		v_mov_b32_e32 v24, 64
		v_mul_lo_u32 v24, v24, v23
		v_xor_b32_e32 v11, v11, v24
		v_add_u32_e32 v25, s22, v11
		v_xor_b32_e32 v7, 0x80, v7
		v_xor_b32_e32 v7, v7, v10
		v_xor_b32_e32 v7, v7, v12
		v_bitop3_b32 v7, v7, v15, v18 bitop3:0x96
		v_bitop3_b32 v7, v7, v21, v24 bitop3:0x96
		v_add_u32_e32 v10, s22, v7
		v_cmp_lt_i32_e64 vcc, v25, s23
		s_mov_b64 s[26:27], vcc
		v_mov_b32_e32 v24, s26
		v_mov_b32_e32 v25, s27
		v_accvgpr_write_b32 a2, v24
		v_accvgpr_write_b32 a3, v25
		v_cmp_lt_i32_e64 vcc, v10, s23
		s_mov_b64 s[26:27], vcc
		v_mov_b32_e32 v24, s26
		v_mov_b32_e32 v25, s27
		v_accvgpr_write_b32 a4, v24
		v_accvgpr_write_b32 a5, v25
		v_mov_b32_e32 v10, 2
		v_mul_lo_u32 v10, v10, v17
		v_lshrrev_b32_e32 v12, 5, v0
		v_and_b32_e32 v15, 1, v12
		v_mov_b32_e32 v18, 4
		v_mul_lo_u32 v18, v18, v15
		v_bitop3_b32 v21, v14, v10, v18 bitop3:0x96
		v_mov_b32_e32 v24, 8
		v_mul_lo_u32 v24, v24, v20
		v_mov_b32_e32 v25, 16
		v_mul_lo_u32 v25, v25, v23
		v_bitop3_b32 v21, v21, v24, v25 bitop3:0x96
		v_add_u32_e32 v21, s22, v21
		v_cmp_lt_i32_e64 vcc, v21, s23
		s_mov_b64 s[26:27], vcc
		s_mov_b32 s30, 0x7fffffff
		s_mov_b32 s31, 0x31016000
		s_mov_b32 s28, s4
		s_mov_b32 s29, s5
		s_mov_b32 s32, s6
		s_mov_b32 s33, s7
		s_mov_b32 s34, s30
		s_mov_b32 s35, s31
		v_readfirstlane_b32 s36, v1
		s_mul_i32 s36, s36, s12
		s_lshl_b32 s36, s36, 9
		s_mul_i32 s37, s1, s10
		s_lshl_b32 s37, s37, 1
		s_add_i32 s36, s36, s37
		s_mul_i32 s37, s25, s11
		s_lshl_b32 s37, s37, 1
		s_add_i32 s36, s36, s37
		v_mul_lo_u32 v21, s12, v22
		v_lshlrev_b32_e32 v21, 5, v21
		v_and_b32_e32 v26, 1, v19
		v_mul_lo_u32 v27, s12, v26
		v_lshlrev_b32_e32 v27, 4, v27
		v_add3_u32 v21, s36, v21, v27
		v_and_b32_e32 v12, 1, v12
		v_mul_lo_u32 v27, s12, v12
		v_lshlrev_b32_e32 v27, 3, v27
		v_and_b32_e32 v16, 1, v16
		v_mul_lo_u32 v28, s12, v16
		v_lshlrev_b32_e32 v28, 2, v28
		v_add3_u32 v21, v21, v27, v28
		v_and_b32_e32 v13, 1, v13
		v_mul_lo_u32 v27, s12, v13
		v_lshlrev_b32_e32 v27, 1, v27
		v_and_b32_e32 v28, 1, v0
		v_lshlrev_b32_e32 v28, 4, v28
		v_add3_u32 v21, v21, v27, v28
		v_and_b32_e32 v9, 1, v9
		v_lshlrev_b32_e32 v9, 6, v9
		v_and_b32_e32 v8, 1, v8
		v_lshlrev_b32_e32 v8, 5, v8
		v_add3_u32 v21, v21, v9, v8
		v_mov_b32_e32 v27, 0x80000000
		v_cndmask_b32_e64 v21, v27, v21, s[26:27]
		s_mov_b32 s40, s2
		s_mov_b32 s41, s3
		s_mov_b32 s42, s30
		s_mov_b32 s43, s31
		buffer_load_dwordx4 v[32:35], v21, s[40:43], 0 offen
		v_bitop3_b32 v21, 32, v14, v10 bitop3:0x96
		v_xor_b32_e32 v21, v21, v18
		v_bitop3_b32 v21, v21, v24, v25 bitop3:0x96
		v_add_u32_e32 v21, s22, v21
		v_cmp_lt_i32_e64 vcc, v21, s23
		s_mov_b64 s[26:27], vcc
		v_lshlrev_b32_e32 v21, 4, v22
		v_lshlrev_b32_e32 v29, 3, v26
		v_lshlrev_b32_e32 v30, 2, v12
		v_add_u32_e32 v31, 32, v13
		v_lshlrev_b32_e32 v36, 1, v16
		v_bitop3_b32 v31, v30, v31, v36 bitop3:0x96
		v_bitop3_b32 v31, v21, v29, v31 bitop3:0x96
		v_mul_lo_u32 v31, s12, v31
		v_lshlrev_b32_e32 v31, 1, v31
		v_add3_u32 v31, s36, v31, v28
		v_add3_u32 v31, v31, v9, v8
		v_cndmask_b32_e64 v31, v27, v31, s[26:27]
		buffer_load_dwordx4 v[40:43], v31, s[40:43], 0 offen
		v_bitop3_b32 v31, 64, v14, v10 bitop3:0x96
		v_xor_b32_e32 v31, v31, v18
		v_bitop3_b32 v31, v31, v24, v25 bitop3:0x96
		v_add_u32_e32 v31, s22, v31
		v_cmp_lt_i32_e64 vcc, v31, s23
		s_mov_b64 s[26:27], vcc
		v_add_u32_e32 v31, 64, v13
		v_bitop3_b32 v31, v30, v31, v36 bitop3:0x96
		v_bitop3_b32 v31, v21, v29, v31 bitop3:0x96
		v_mul_lo_u32 v31, s12, v31
		v_lshlrev_b32_e32 v31, 1, v31
		v_add3_u32 v31, s36, v31, v28
		v_add3_u32 v31, v31, v9, v8
		v_cndmask_b32_e64 v31, v27, v31, s[26:27]
		buffer_load_dwordx4 v[44:47], v31, s[40:43], 0 offen
		v_xor_b32_e32 v31, 0x60, v14
		v_xor_b32_e32 v31, v31, v10
		v_xor_b32_e32 v31, v31, v18
		v_bitop3_b32 v31, v31, v24, v25 bitop3:0x96
		v_add_u32_e32 v31, s22, v31
		v_cmp_lt_i32_e64 vcc, v31, s23
		s_mov_b64 s[26:27], vcc
		v_add_u32_e32 v31, 0x60, v13
		v_bitop3_b32 v31, v30, v31, v36 bitop3:0x96
		v_bitop3_b32 v31, v21, v29, v31 bitop3:0x96
		v_mul_lo_u32 v31, s12, v31
		v_lshlrev_b32_e32 v31, 1, v31
		v_add3_u32 v31, s36, v31, v28
		v_add3_u32 v31, v31, v9, v8
		v_cndmask_b32_e64 v31, v27, v31, s[26:27]
		buffer_load_dwordx4 v[48:51], v31, s[40:43], 0 offen
		v_xor_b32_e32 v31, 0x80, v14
		v_xor_b32_e32 v31, v31, v10
		v_xor_b32_e32 v31, v31, v18
		v_bitop3_b32 v31, v31, v24, v25 bitop3:0x96
		v_add_u32_e32 v31, s22, v31
		v_cmp_lt_i32_e64 vcc, v31, s23
		s_mov_b64 s[26:27], vcc
		v_add_u32_e32 v31, 0x80, v13
		v_bitop3_b32 v31, v30, v31, v36 bitop3:0x96
		v_bitop3_b32 v31, v21, v29, v31 bitop3:0x96
		v_mul_lo_u32 v31, s12, v31
		v_lshlrev_b32_e32 v31, 1, v31
		v_add3_u32 v31, s36, v31, v28
		v_add3_u32 v31, v31, v9, v8
		v_cndmask_b32_e64 v31, v27, v31, s[26:27]
		buffer_load_dwordx4 v[52:55], v31, s[40:43], 0 offen
		v_xor_b32_e32 v31, 0xa0, v14
		v_xor_b32_e32 v31, v31, v10
		v_xor_b32_e32 v31, v31, v18
		v_bitop3_b32 v31, v31, v24, v25 bitop3:0x96
		v_add_u32_e32 v31, s22, v31
		v_cmp_lt_i32_e64 vcc, v31, s23
		s_mov_b64 s[26:27], vcc
		v_add_u32_e32 v31, 0xa0, v13
		v_bitop3_b32 v31, v30, v31, v36 bitop3:0x96
		v_bitop3_b32 v31, v21, v29, v31 bitop3:0x96
		v_mul_lo_u32 v31, s12, v31
		v_lshlrev_b32_e32 v31, 1, v31
		v_add3_u32 v31, s36, v31, v28
		v_add3_u32 v31, v31, v9, v8
		v_cndmask_b32_e64 v31, v27, v31, s[26:27]
		buffer_load_dwordx4 v[56:59], v31, s[40:43], 0 offen
		v_xor_b32_e32 v31, 0xc0, v14
		v_xor_b32_e32 v31, v31, v10
		v_xor_b32_e32 v31, v31, v18
		v_bitop3_b32 v31, v31, v24, v25 bitop3:0x96
		v_add_u32_e32 v31, s22, v31
		v_cmp_lt_i32_e64 vcc, v31, s23
		s_mov_b64 s[26:27], vcc
		v_add_u32_e32 v31, 0xc0, v13
		v_bitop3_b32 v31, v30, v31, v36 bitop3:0x96
		v_bitop3_b32 v31, v21, v29, v31 bitop3:0x96
		v_mul_lo_u32 v31, s12, v31
		v_lshlrev_b32_e32 v31, 1, v31
		v_add3_u32 v31, s36, v31, v28
		v_add3_u32 v31, v31, v9, v8
		v_cndmask_b32_e64 v31, v27, v31, s[26:27]
		buffer_load_dwordx4 v[60:63], v31, s[40:43], 0 offen
		v_xor_b32_e32 v31, 0xe0, v14
		v_xor_b32_e32 v10, v31, v10
		v_xor_b32_e32 v10, v10, v18
		v_bitop3_b32 v10, v10, v24, v25 bitop3:0x96
		v_add_u32_e32 v10, s22, v10
		v_add_u32_e32 v24, 0xe0, v13
		v_bitop3_b32 v24, v30, v24, v36 bitop3:0x96
		v_bitop3_b32 v24, v21, v29, v24 bitop3:0x96
		v_mul_lo_u32 v24, s12, v24
		v_lshlrev_b32_e32 v24, 1, v24
		v_add3_u32 v24, s36, v24, v28
		v_cmp_lt_i32_e64 vcc, v10, s23
		v_add3_u32 v10, v24, v9, v8
		s_nop 0
		v_cndmask_b32_e32 v10, v27, v10, vcc
		buffer_load_dwordx4 v[36:39], v10, s[40:43], 0 offen
		s_waitcnt vmcnt(8)
		s_barrier
		v_lshlrev_b32_e32 v10, 2, v26
		v_lshlrev_b32_e32 v24, 1, v12
		v_xor_b32_e32 v25, v0, v16
		v_bitop3_b32 v10, v10, v24, v25 bitop3:0x96
		v_lshlrev_b32_e32 v10, 4, v10
		v_add_u32_e32 v10, 0x10000, v10
		s_waitcnt vmcnt(7)
		ds_write_b128 v10, v[32:35] offset:2480
		s_waitcnt vmcnt(6)
		ds_write_b128 v10, v[40:43] offset:6576
		s_waitcnt vmcnt(5)
		ds_write_b128 v10, v[44:47] offset:10672
		s_waitcnt vmcnt(4)
		ds_write_b128 v10, v[48:51] offset:14768
		v_lshlrev_b32_e32 v19, 12, v19
		v_add_u32_e32 v19, 0x10000, v19
		v_and_b32_e32 v24, 63, v0
		v_lshrrev_b32_e32 v25, 2, v24
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v25, 1, v25
		v_lshlrev_b32_e32 v25, 5, v25
		v_lshrrev_b32_e32 v30, 1, v24
		v_and_b32_e32 v30, 1, v30
		v_lshlrev_b32_e32 v30, 4, v30
		v_and_b32_e32 v31, 1, v24
		v_lshlrev_b32_e32 v31, 3, v31
		v_add3_u32 v32, v25, v30, v31
		v_lshrrev_b32_e32 v33, 5, v24
		v_xor_b32_e32 v32, v32, v33
		v_lshrrev_b32_e32 v34, 6, v32
		v_lshrrev_b32_e32 v35, 3, v24
		v_and_b32_e32 v35, 1, v35
		v_add_u32_e32 v34, v34, v35
		v_and_b32_e32 v34, 1, v34
		v_lshlrev_b32_e32 v34, 2, v34
		v_lshrrev_b32_e32 v40, 5, v32
		v_and_b32_e32 v40, 1, v40
		v_lshlrev_b32_e32 v40, 1, v40
		v_lshrrev_b32_e32 v41, 4, v24
		v_and_b32_e32 v41, 1, v41
		v_lshlrev_b32_e32 v42, 6, v35
		v_lshl_add_u32 v41, v41, 7, v42
		v_add_u32_e32 v42, v41, v32
		v_lshrrev_b32_e32 v32, 4, v32
		v_bitop3_b32 v32, v42, v32, 1 bitop3:0x78
		v_bitop3_b32 v32, v34, v40, v32 bitop3:0x96
		v_lshl_add_u32 v34, v32, 4, v19
		ds_read_b128 a[8:11], v34 offset:2480
		v_add_u32_e32 v34, 2, v25
		v_add3_u32 v34, v34, v30, v31
		v_xor_b32_e32 v34, v34, v33
		v_lshrrev_b32_e32 v40, 6, v34
		v_add_u32_e32 v40, v40, v35
		v_and_b32_e32 v40, 1, v40
		v_lshlrev_b32_e32 v40, 2, v40
		v_lshrrev_b32_e32 v42, 5, v34
		v_and_b32_e32 v42, 1, v42
		v_lshlrev_b32_e32 v42, 1, v42
		v_add_u32_e32 v43, v41, v34
		v_lshrrev_b32_e32 v34, 4, v34
		v_bitop3_b32 v34, v43, v34, 1 bitop3:0x78
		v_bitop3_b32 v34, v40, v42, v34 bitop3:0x96
		v_lshl_add_u32 v40, v34, 4, v19
		ds_read_b128 a[12:15], v40 offset:2480
		v_add_u32_e32 v40, 4, v25
		v_add3_u32 v40, v40, v30, v31
		v_xor_b32_e32 v40, v40, v33
		v_lshrrev_b32_e32 v42, 6, v40
		v_add_u32_e32 v42, v42, v35
		v_and_b32_e32 v42, 1, v42
		v_lshlrev_b32_e32 v42, 2, v42
		v_lshrrev_b32_e32 v43, 5, v40
		v_and_b32_e32 v43, 1, v43
		v_lshlrev_b32_e32 v43, 1, v43
		v_add_u32_e32 v44, v41, v40
		v_lshrrev_b32_e32 v40, 4, v40
		v_bitop3_b32 v40, v44, v40, 1 bitop3:0x78
		v_bitop3_b32 v40, v42, v43, v40 bitop3:0x96
		v_lshl_add_u32 v42, v40, 4, v19
		ds_read_b128 a[16:19], v42 offset:2480
		v_add_u32_e32 v25, 6, v25
		v_add3_u32 v25, v25, v30, v31
		v_xor_b32_e32 v25, v25, v33
		v_lshrrev_b32_e32 v30, 6, v25
		v_add_u32_e32 v30, v30, v35
		v_and_b32_e32 v30, 1, v30
		v_lshlrev_b32_e32 v30, 2, v30
		v_lshrrev_b32_e32 v31, 5, v25
		v_and_b32_e32 v31, 1, v31
		v_lshlrev_b32_e32 v31, 1, v31
		v_add_u32_e32 v35, v41, v25
		v_lshrrev_b32_e32 v25, 4, v25
		v_bitop3_b32 v25, v35, v25, 1 bitop3:0x78
		v_bitop3_b32 v25, v30, v31, v25 bitop3:0x96
		v_lshl_add_u32 v19, v25, 4, v19
		ds_read_b128 a[20:23], v19 offset:2480
		v_add_u32_e32 v19, 32, v29
		v_xor_b32_e32 v19, v19, v21
		v_lshrrev_b32_e32 v21, 5, v19
		v_and_b32_e32 v21, 1, v21
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(3)
		ds_write_b128 v10, v[52:55] offset:2480
		s_waitcnt vmcnt(2)
		ds_write_b128 v10, v[56:59] offset:6576
		s_waitcnt vmcnt(1)
		ds_write_b128 v10, v[60:63] offset:10672
		s_waitcnt vmcnt(0)
		ds_write_b128 v10, v[36:39] offset:14768
		v_lshlrev_b32_e32 v10, 14, v21
		v_lshrrev_b32_e32 v21, 4, v19
		v_and_b32_e32 v21, 1, v21
		v_lshlrev_b32_e32 v21, 13, v21
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshrrev_b32_e32 v19, 3, v19
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 12, v19
		v_add3_u32 v10, v10, v21, v19
		v_lshl_add_u32 v19, v32, 4, v10
		ds_read_b128 a[24:27], v19 offset:51632
		v_lshl_add_u32 v19, v34, 4, v10
		ds_read_b128 a[28:31], v19 offset:51632
		v_lshl_add_u32 v19, v40, 4, v10
		ds_read_b128 a[32:35], v19 offset:51632
		v_lshl_add_u32 v10, v25, 4, v10
		ds_read_b128 a[36:39], v10 offset:51632
		v_readfirstlane_b32 s26, v1
		s_add_i32 s26, s26, 1
		s_mul_i32 s26, s26, 0x100
		v_readfirstlane_b32 s27, v4
		s_add_i32 s26, s26, s27
		s_cmp_lt_i32 s24, s26
		s_cselect_b32 s26, s24, s26
		s_add_i32 s27, s26, 0x7f
		s_mov_b32 s36, 0x7f
		s_cmp_lt_i32 s27, 0
		s_cselect_b32 s37, s36, 0
		s_add_i32 s27, s27, s37
		s_ashr_i32 s27, s27, 7
		v_readfirstlane_b32 s37, v4
		s_add_i32 s37, s22, s37
		s_cmp_lt_i32 s37, 0
		s_cselect_b32 s38, s36, 0
		s_add_i32 s37, s37, s38
		s_ashr_i32 s37, s37, 7
		s_cmp_lt_i32 s37, s27
		s_cselect_b32 s37, s37, s27
		s_cmp_gt_i32 s37, 0
		s_cselect_b32 s37, s37, 0
		v_mov_b32_e32 v1, 64
		v_mul_lo_u32 v1, v1, v14
		v_mov_b32_e32 v10, 32
		v_mul_lo_u32 v10, v10, v17
		v_mov_b32_e32 v17, 16
		v_mul_lo_u32 v17, v17, v15
		v_bitop3_b32 v19, v1, v10, v17 bitop3:0x96
		v_mov_b32_e32 v21, 2
		v_mul_lo_u32 v21, v21, v23
		v_bitop3_b32 v19, v19, v20, v21 bitop3:0x96
		v_bitop3_b32 v23, 4, v1, v10 bitop3:0x96
		v_xor_b32_e32 v23, v23, v17
		v_bitop3_b32 v23, v23, v20, v21 bitop3:0x96
		v_bitop3_b32 v25, 8, v1, v10 bitop3:0x96
		v_xor_b32_e32 v25, v25, v17
		v_bitop3_b32 v25, v25, v20, v21 bitop3:0x96
		v_bitop3_b32 v1, 12, v1, v10 bitop3:0x96
		v_xor_b32_e32 v1, v1, v17
		v_bitop3_b32 v1, v1, v20, v21 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v19, s24
		s_mov_b64 s[38:39], vcc
		v_cmp_lt_i32_e64 vcc, v23, s24
		s_mov_b64 s[44:45], vcc
		v_cmp_lt_i32_e64 vcc, v25, s24
		s_mov_b64 s[46:47], vcc
		v_cmp_lt_i32_e64 vcc, v1, s24
		s_mov_b64 s[48:49], vcc
		v_mov_b32_e32 v17, 16
		v_mul_lo_u32 v17, v17, v14
		v_mov_b32_e32 v14, 64
		v_mul_lo_u32 v14, v14, v15
		v_bitop3_b32 v15, v17, v10, v14 bitop3:0x96
		v_bitop3_b32 v15, v15, v20, v21 bitop3:0x96
		v_bitop3_b32 v29, 4, v17, v10 bitop3:0x96
		v_xor_b32_e32 v29, v29, v14
		v_bitop3_b32 v29, v29, v20, v21 bitop3:0x96
		v_bitop3_b32 v30, 8, v17, v10 bitop3:0x96
		v_xor_b32_e32 v30, v30, v14
		v_bitop3_b32 v30, v30, v20, v21 bitop3:0x96
		v_bitop3_b32 v10, 12, v17, v10 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v15, s24
		s_mov_b64 s[50:51], vcc
		v_cmp_lt_i32_e64 vcc, v29, s24
		s_mov_b64 s[52:53], vcc
		v_cmp_lt_i32_e64 vcc, v30, s24
		s_mov_b64 s[54:55], vcc
		v_readfirstlane_b32 s56, v0
		v_mul_lo_u32 v17, s15, v22
		v_mul_lo_u32 v31, s15, v26
		v_lshlrev_b32_e32 v31, 1, v31
		v_lshl_add_u32 v17, v17, 2, v31
		v_mul_lo_u32 v31, s15, v12
		v_lshl_add_u32 v17, v31, 5, v17
		v_mul_lo_u32 v31, s15, v16
		v_lshl_add_u32 v17, v31, 6, v17
		v_mul_lo_u32 v31, s15, v13
		v_lshlrev_b32_e32 v31, 7, v31
		v_add3_u32 v17, v17, v31, v28
		v_add3_u32 v17, v17, v9, v8
		s_mul_i32 s57, s1, s13
		s_lshl_b32 s57, s57, 1
		s_mul_i32 s58, s25, s14
		s_lshl_b32 s58, s58, 1
		s_add_i32 s59, s57, s58
		v_add_u32_e32 v31, s59, v17
		v_cndmask_b32_e64 v31, v27, v31, s[38:39]
		s_lshr_b32 s38, s56, 6
		s_mul_i32 s39, 0x410, s38
		s_mov_b32 m0, s39
		v_xor_b32_e32 v10, v10, v14
		buffer_load_dwordx4 v31, s[28:31], 0 offen lds
		v_bitop3_b32 v10, v10, v20, v21 bitop3:0x96
		s_lshl_b32 s59, s15, 3
		s_add_i32 s59, s59, s57
		s_add_i32 s59, s59, s58
		v_add_u32_e32 v14, s59, v17
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v14, v27, v14, s[44:45]
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		s_lshl_b32 s44, s15, 4
		s_add_i32 s44, s44, s57
		s_add_i32 s44, s44, s58
		v_add_u32_e32 v20, s44, v17
		s_add_i32 m0, s39, 0x2080
		v_cndmask_b32_e64 v20, v27, v20, s[46:47]
		v_accvgpr_write_b32 a6, v20
		v_accvgpr_read_b32 v20, a6
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		s_mul_i32 s44, 24, s15
		s_add_i32 s44, s44, s57
		s_add_i32 s44, s44, s58
		v_add_u32_e32 v20, s44, v17
		s_add_i32 m0, s39, 0x30c0
		v_cndmask_b32_e64 v20, v27, v20, s[48:49]
		v_accvgpr_write_b32 a7, v20
		v_accvgpr_read_b32 v20, a7
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		v_mul_lo_u32 v20, s21, v22
		v_mul_lo_u32 v21, s21, v26
		v_lshlrev_b32_e32 v21, 1, v21
		v_lshl_add_u32 v20, v20, 2, v21
		v_mul_lo_u32 v12, s21, v12
		v_lshl_add_u32 v12, v12, 7, v20
		v_mul_lo_u32 v16, s21, v16
		v_lshl_add_u32 v12, v16, 6, v12
		v_mul_lo_u32 v13, s21, v13
		v_lshlrev_b32_e32 v13, 5, v13
		v_add3_u32 v12, v12, v13, v28
		v_add3_u32 v8, v12, v9, v8
		s_mul_i32 s44, s1, s19
		s_lshl_b32 s44, s44, 1
		s_mul_i32 s45, s25, s20
		s_lshl_b32 s45, s45, 1
		s_add_i32 s46, s44, s45
		v_add_u32_e32 v9, s46, v8
		s_mul_i32 s38, 0x440, s38
		s_add_i32 m0, s38, 0x81f0
		v_cndmask_b32_e64 v9, v27, v9, s[50:51]
		v_accvgpr_write_b32 a40, v9
		v_accvgpr_read_b32 v9, a40
		buffer_load_dwordx4 v9, s[32:35], 0 offen lds
		s_lshl_b32 s46, s21, 3
		s_add_i32 s46, s46, s44
		s_add_i32 s46, s46, s45
		v_add_u32_e32 v9, s46, v8
		s_add_i32 m0, s38, 0x92f0
		v_cndmask_b32_e64 v9, v27, v9, s[52:53]
		v_accvgpr_write_b32 a41, v9
		v_accvgpr_read_b32 v9, a41
		buffer_load_dwordx4 v9, s[32:35], 0 offen lds
		s_lshl_b32 s46, s21, 4
		s_add_i32 s46, s46, s44
		s_add_i32 s46, s46, s45
		v_add_u32_e32 v9, s46, v8
		s_add_i32 m0, s38, 0xa3f0
		v_cndmask_b32_e64 v9, v27, v9, s[54:55]
		v_accvgpr_write_b32 a42, v9
		v_accvgpr_read_b32 v9, a42
		buffer_load_dwordx4 v9, s[32:35], 0 offen lds
		s_mul_i32 s46, 24, s21
		s_add_i32 s46, s46, s44
		s_add_i32 s46, s46, s45
		v_cmp_lt_i32_e64 vcc, v10, s24
		v_add_u32_e32 v9, s46, v8
		v_mbcnt_lo_u32_b32 v12, -1, 0
		v_cndmask_b32_e32 v9, v27, v9, vcc
		v_accvgpr_write_b32 a43, v9
		s_add_i32 m0, s38, 0xb4f0
		s_mul_i32 s46, s37, 0x80
		v_accvgpr_read_b32 v9, a43
		buffer_load_dwordx4 v9, s[32:35], 0 offen lds
		v_mbcnt_hi_u32_b32 v9, -1, v12
		v_and_b32_e32 v12, 1, v9
		v_lshrrev_b32_e32 v13, 4, v9
		v_and_b32_e32 v13, 1, v13
		v_lshlrev_b32_e32 v13, 4, v13
		v_lshrrev_b32_e32 v16, 3, v9
		v_and_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v16, 3, v16
		v_add3_u32 v20, v12, v13, v16
		v_lshrrev_b32_e32 v21, 2, v9
		v_and_b32_e32 v21, 1, v21
		v_lshlrev_b32_e32 v21, 2, v21
		v_lshrrev_b32_e32 v22, 1, v9
		v_and_b32_e32 v22, 1, v22
		v_lshlrev_b32_e32 v22, 1, v22
		v_add3_u32 v20, v20, v21, v22
		v_add_u32_e32 v12, 32, v12
		v_bitop3_b32 v12, v21, v12, v22 bitop3:0x96
		v_bitop3_b32 v12, v13, v16, v12 bitop3:0x96
		v_mov_b32_e32 v34, 0x3e38aa3b
		v_mov_b32_e32 v35, 0x3e38aa3b
		s_mov_b32 s37, 0xff800000
		v_mov_b32_e32 v13, s37
		s_nop 0
		v_readfirstlane_b32 s37, v13
		s_nop 1
		v_mov_b32_e32 v16, s37
		v_readfirstlane_b32 s37, v13
		s_nop 1
		v_mov_b32_e32 v21, s37
		s_mov_b32 s37, 1.0
		v_mov_b32_e32 v22, s37
		s_nop 0
		v_readfirstlane_b32 s37, v22
		s_nop 1
		v_mov_b32_e32 v36, s37
		v_readfirstlane_b32 s37, v22
		s_nop 1
		v_mov_b32_e32 v37, s37
		s_mov_b32 s37, 0
		v_lshlrev_b32_e32 v26, 4, v33
		v_and_b32_e32 v28, 31, v24
		v_lshrrev_b32_e32 v32, 4, v28
		v_lshlrev_b32_e32 v38, 9, v32
		v_lshrrev_b32_e32 v39, 3, v28
		v_and_b32_e32 v39, 1, v39
		v_mov_b32_e32 v40, 0x2080
		v_mul_lo_u32 v40, v40, v39
		v_lshrrev_b32_e32 v39, 2, v28
		v_and_b32_e32 v39, 1, v39
		v_mov_b32_e32 v41, 0x1040
		v_mul_lo_u32 v41, v41, v39
		v_lshrrev_b32_e32 v39, 1, v28
		v_and_b32_e32 v39, 1, v39
		v_mov_b32_e32 v42, 0x820
		v_mul_lo_u32 v42, v42, v39
		v_and_b32_e32 v28, 1, v28
		v_mov_b32_e32 v39, 0x410
		v_mul_lo_u32 v39, v39, v28
		v_mov_b32_e32 v28, 0x2200
		v_mul_lo_u32 v28, v28, v33
		v_lshlrev_b32_e32 v32, 5, v32
		v_and_b32_e32 v24, 15, v24
		v_lshrrev_b32_e32 v43, 2, v24
		v_mov_b32_e32 v44, 0x440
		v_mul_lo_u32 v44, v44, v43
		v_and_b32_e32 v24, 3, v24
		v_lshlrev_b32_e32 v43, 3, v24
		s_lshl_b32 s47, s15, 8
		s_add_i32 s47, s47, s57
		s_add_i32 s47, s47, s58
		s_mul_i32 s48, 0x108, s15
		s_add_i32 s48, s48, s57
		s_add_i32 s48, s48, s58
		s_mul_i32 s49, 0x110, s15
		s_add_i32 s49, s49, s57
		s_add_i32 s49, s49, s58
		s_mul_i32 s50, 0x118, s15
		s_add_i32 s50, s50, s57
		s_add_i32 s50, s50, s58
		s_lshl_b32 s51, s21, 8
		s_add_i32 s51, s51, s44
		s_add_i32 s51, s51, s45
		s_mul_i32 s52, 0x108, s21
		s_add_i32 s52, s52, s44
		s_add_i32 s52, s52, s45
		s_mul_i32 s53, 0x110, s21
		s_add_i32 s53, s53, s44
		s_add_i32 s53, s53, s45
		s_mul_i32 s54, 0x118, s21
		s_add_i32 s44, s54, s44
		s_add_i32 s44, s44, s45
		v_lshlrev_b32_e32 v20, 2, v20
		v_lshlrev_b32_e32 v12, 2, v12
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
		s_add_i32 s45, s37, 0x80
		s_lshr_b32 s54, s37, 7
		s_and_b32 s55, s54, 1
		s_mul_i32 s57, 0x4100, s55
		v_add3_u32 v45, s57, v26, v38
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
		s_mul_i32 s55, 0x4400, s55
		v_add3_u32 v45, s55, v28, v32
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
		v_add_u32_e32 v45, s45, v19
		v_add_u32_e32 v46, s45, v23
		v_add_u32_e32 v47, s45, v25
		v_add_u32_e32 v144, s45, v1
		v_cmp_lt_i32_e64 vcc, v45, s24
		s_mov_b64 s[58:59], vcc
		v_cmp_lt_i32_e64 vcc, v46, s24
		s_mov_b64 s[60:61], vcc
		v_cmp_lt_i32_e64 vcc, v47, s24
		s_mov_b64 s[62:63], vcc
		v_cmp_lt_i32_e64 vcc, v144, s24
		s_mov_b64 s[64:65], vcc
		v_add_u32_e32 v45, s45, v15
		v_add_u32_e32 v46, s45, v29
		v_add_u32_e32 v47, s45, v30
		v_cmp_lt_i32_e64 vcc, v45, s24
		s_mov_b64 s[66:67], vcc
		v_cmp_lt_i32_e64 vcc, v46, s24
		s_mov_b64 s[68:69], vcc
		v_cmp_lt_i32_e64 vcc, v47, s24
		s_mov_b64 s[70:71], vcc
		s_barrier
		s_mul_i32 s55, s15, s37
		s_lshl_b32 s55, s55, 1
		s_add_i32 s57, s47, s55
		v_add_u32_e32 v45, s57, v17
		v_cndmask_b32_e64 v45, v27, v45, s[58:59]
		s_add_i32 s54, s54, 1
		s_and_b32 s54, s54, 1
		s_mul_i32 s57, 0x4100, s54
		s_add_i32 s57, s39, s57
		s_mov_b32 m0, s57
		v_add_u32_e32 v46, s45, v10
		buffer_load_dwordx4 v45, s[28:31], 0 offen lds
		v_add_u32_e32 v45, s55, v17
		v_add_u32_e32 v47, s48, v45
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v47, v27, v47, s[60:61]
		buffer_load_dwordx4 v47, s[28:31], 0 offen lds
		v_add_u32_e32 v47, s49, v45
		s_add_i32 m0, s57, 0x2080
		v_cndmask_b32_e64 v47, v27, v47, s[62:63]
		buffer_load_dwordx4 v47, s[28:31], 0 offen lds
		v_add_u32_e32 v45, s50, v45
		s_add_i32 m0, s57, 0x30c0
		v_cndmask_b32_e64 v45, v27, v45, s[64:65]
		buffer_load_dwordx4 v45, s[28:31], 0 offen lds
		s_barrier
		s_mul_i32 s37, s21, s37
		s_lshl_b32 s37, s37, 1
		s_add_i32 s55, s51, s37
		v_add_u32_e32 v45, s55, v8
		s_mul_i32 s54, 0x4400, s54
		s_add_i32 s54, s38, s54
		s_add_i32 m0, s54, 0x81f0
		v_cndmask_b32_e64 v45, v27, v45, s[66:67]
		buffer_load_dwordx4 v45, s[32:35], 0 offen lds
		v_add_u32_e32 v45, s37, v8
		v_add_u32_e32 v47, s52, v45
		s_add_i32 m0, s54, 0x92f0
		v_cndmask_b32_e64 v47, v27, v47, s[68:69]
		buffer_load_dwordx4 v47, s[32:35], 0 offen lds
		v_add_u32_e32 v47, s53, v45
		s_add_i32 m0, s54, 0xa3f0
		v_cndmask_b32_e64 v47, v27, v47, s[70:71]
		buffer_load_dwordx4 v47, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v46, s24
		v_add_u32_e32 v45, s44, v45
		v_accvgpr_write_b32 a141, v37
		v_cndmask_b32_e32 v37, v27, v45, vcc
		s_add_i32 m0, s54, 0xb4f0
		v_accvgpr_write_b32 a140, v36
		buffer_load_dwordx4 v37, s[32:35], 0 offen lds
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[144:159], v[80:83], a[8:11], 0
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
		v_mfma_f32_32x32x16_bf16 v[144:159], v[96:99], a[8:11], 0
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
		v_mfma_f32_32x32x16_bf16 v[144:159], v[112:115], a[8:11], 0
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
		v_mfma_f32_32x32x16_bf16 v[144:159], v[128:131], a[8:11], 0
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
		v_mfma_f32_32x32x16_bf16 v[144:159], v[128:131], a[24:27], 0
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
		v_mfma_f32_32x32x16_bf16 v[144:159], v[80:83], a[24:27], 0
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
		v_mfma_f32_32x32x16_bf16 v[144:159], v[96:99], a[24:27], 0
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
		v_mfma_f32_32x32x16_bf16 v[144:159], v[112:115], a[24:27], 0
		v_mfma_f32_32x32x16_bf16 a[144:159], v[84:87], a[12:15], a[144:159]
		v_mfma_f32_32x32x16_bf16 a[160:175], v[100:103], a[12:15], a[160:175]
		v_mfma_f32_32x32x16_bf16 a[176:191], v[116:119], a[12:15], a[176:191]
		v_mfma_f32_32x32x16_bf16 a[192:207], v[132:135], a[12:15], a[192:207]
		v_mfma_f32_32x32x16_bf16 a[208:223], v[132:135], a[28:31], a[208:223]
		v_mfma_f32_32x32x16_bf16 a[224:239], v[84:87], a[28:31], a[224:239]
		v_mfma_f32_32x32x16_bf16 a[240:255], v[100:103], a[28:31], a[240:255]
		v_mfma_f32_32x32x16_bf16 v[144:159], v[116:119], a[28:31], v[144:159]
		v_mfma_f32_32x32x16_bf16 a[144:159], v[88:91], a[16:19], a[144:159]
		v_mfma_f32_32x32x16_bf16 a[160:175], v[104:107], a[16:19], a[160:175]
		v_mfma_f32_32x32x16_bf16 a[176:191], v[120:123], a[16:19], a[176:191]
		v_mfma_f32_32x32x16_bf16 a[192:207], v[136:139], a[16:19], a[192:207]
		v_mfma_f32_32x32x16_bf16 a[208:223], v[136:139], a[32:35], a[208:223]
		v_mfma_f32_32x32x16_bf16 a[224:239], v[88:91], a[32:35], a[224:239]
		v_mfma_f32_32x32x16_bf16 a[240:255], v[104:107], a[32:35], a[240:255]
		v_mfma_f32_32x32x16_bf16 v[144:159], v[120:123], a[32:35], v[144:159]
		v_mfma_f32_32x32x16_bf16 a[144:159], v[92:95], a[20:23], a[144:159]
		v_mfma_f32_32x32x16_bf16 a[160:175], v[108:111], a[20:23], a[160:175]
		v_mfma_f32_32x32x16_bf16 a[176:191], v[124:127], a[20:23], a[176:191]
		v_mfma_f32_32x32x16_bf16 a[192:207], v[140:143], a[20:23], a[192:207]
		v_mfma_f32_32x32x16_bf16 a[208:223], v[140:143], a[36:39], a[208:223]
		v_mfma_f32_32x32x16_bf16 a[224:239], v[92:95], a[36:39], a[224:239]
		v_mfma_f32_32x32x16_bf16 a[240:255], v[108:111], a[36:39], a[240:255]
		v_mfma_f32_32x32x16_bf16 v[144:159], v[124:127], a[36:39], v[144:159]
		s_nop 4
		v_accvgpr_read_b32 v36, a144
		v_accvgpr_read_b32 v37, a145
		v_max_f32_e32 v36, v36, v37
		v_accvgpr_read_b32 v37, a146
		v_accvgpr_read_b32 v45, a147
		v_max_f32_e32 v37, v37, v45
		v_accvgpr_read_b32 v45, a148
		v_accvgpr_read_b32 v46, a149
		v_max_f32_e32 v45, v45, v46
		v_accvgpr_read_b32 v46, a150
		v_accvgpr_read_b32 v47, a151
		v_max_f32_e32 v46, v46, v47
		v_accvgpr_read_b32 v47, a152
		v_accvgpr_read_b32 v80, a153
		v_max_f32_e32 v47, v47, v80
		v_accvgpr_read_b32 v80, a154
		v_accvgpr_read_b32 v81, a155
		v_max_f32_e32 v80, v80, v81
		v_accvgpr_read_b32 v81, a156
		v_accvgpr_read_b32 v82, a157
		v_max_f32_e32 v81, v81, v82
		v_accvgpr_read_b32 v82, a158
		v_accvgpr_read_b32 v83, a159
		v_max_f32_e32 v82, v82, v83
		v_accvgpr_read_b32 v83, a160
		v_accvgpr_read_b32 v84, a161
		v_max_f32_e32 v83, v83, v84
		v_accvgpr_read_b32 v84, a162
		v_accvgpr_read_b32 v85, a163
		v_max_f32_e32 v84, v84, v85
		v_accvgpr_read_b32 v85, a164
		v_accvgpr_read_b32 v86, a165
		v_max_f32_e32 v85, v85, v86
		v_accvgpr_read_b32 v86, a166
		v_accvgpr_read_b32 v87, a167
		v_max_f32_e32 v86, v86, v87
		v_accvgpr_read_b32 v87, a168
		v_accvgpr_read_b32 v88, a169
		v_max_f32_e32 v87, v87, v88
		v_accvgpr_read_b32 v88, a170
		v_accvgpr_read_b32 v89, a171
		v_max_f32_e32 v88, v88, v89
		v_accvgpr_read_b32 v89, a172
		v_accvgpr_read_b32 v90, a173
		v_max_f32_e32 v89, v89, v90
		v_accvgpr_read_b32 v90, a174
		v_accvgpr_read_b32 v91, a175
		v_max_f32_e32 v90, v90, v91
		v_accvgpr_read_b32 v91, a176
		v_accvgpr_read_b32 v92, a177
		v_max_f32_e32 v91, v91, v92
		v_accvgpr_read_b32 v92, a178
		v_accvgpr_read_b32 v93, a179
		v_max_f32_e32 v92, v92, v93
		v_accvgpr_read_b32 v93, a180
		v_accvgpr_read_b32 v94, a181
		v_max_f32_e32 v93, v93, v94
		v_accvgpr_read_b32 v94, a182
		v_accvgpr_read_b32 v95, a183
		v_max_f32_e32 v94, v94, v95
		v_accvgpr_read_b32 v95, a184
		v_accvgpr_read_b32 v96, a185
		v_max_f32_e32 v95, v95, v96
		v_accvgpr_read_b32 v96, a186
		v_accvgpr_read_b32 v97, a187
		v_max_f32_e32 v96, v96, v97
		v_accvgpr_read_b32 v97, a188
		v_accvgpr_read_b32 v98, a189
		v_max_f32_e32 v97, v97, v98
		v_accvgpr_read_b32 v98, a190
		v_accvgpr_read_b32 v99, a191
		v_max_f32_e32 v98, v98, v99
		v_accvgpr_read_b32 v99, a192
		v_accvgpr_read_b32 v100, a193
		v_max_f32_e32 v99, v99, v100
		v_accvgpr_read_b32 v100, a194
		v_accvgpr_read_b32 v101, a195
		v_max_f32_e32 v100, v100, v101
		v_accvgpr_read_b32 v101, a196
		v_accvgpr_read_b32 v102, a197
		v_max_f32_e32 v101, v101, v102
		v_accvgpr_read_b32 v102, a198
		v_accvgpr_read_b32 v103, a199
		v_max_f32_e32 v102, v102, v103
		v_accvgpr_read_b32 v103, a200
		v_accvgpr_read_b32 v104, a201
		v_max_f32_e32 v103, v103, v104
		v_accvgpr_read_b32 v104, a202
		v_accvgpr_read_b32 v105, a203
		v_max_f32_e32 v104, v104, v105
		v_accvgpr_read_b32 v105, a204
		v_accvgpr_read_b32 v106, a205
		v_max_f32_e32 v105, v105, v106
		v_accvgpr_read_b32 v106, a206
		v_accvgpr_read_b32 v107, a207
		v_max_f32_e32 v106, v106, v107
		v_max_f32_e32 v36, v36, v37
		v_max_f32_e32 v37, v45, v46
		v_max_f32_e32 v45, v47, v80
		v_max_f32_e32 v46, v81, v82
		v_max_f32_e32 v47, v83, v84
		v_max_f32_e32 v80, v85, v86
		v_max_f32_e32 v81, v87, v88
		v_max_f32_e32 v82, v89, v90
		v_max_f32_e32 v83, v91, v92
		v_max_f32_e32 v84, v93, v94
		v_max_f32_e32 v85, v95, v96
		v_max_f32_e32 v86, v97, v98
		v_max_f32_e32 v87, v99, v100
		v_max_f32_e32 v88, v101, v102
		v_max_f32_e32 v89, v103, v104
		v_max_f32_e32 v90, v105, v106
		v_max_f32_e32 v36, v36, v37
		v_max_f32_e32 v37, v45, v46
		v_max_f32_e32 v45, v47, v80
		v_max_f32_e32 v46, v81, v82
		v_max_f32_e32 v47, v83, v84
		v_max_f32_e32 v80, v85, v86
		v_max_f32_e32 v81, v87, v88
		v_max_f32_e32 v82, v89, v90
		v_max_f32_e32 v36, v36, v37
		v_max_f32_e32 v37, v45, v46
		v_max_f32_e32 v45, v47, v80
		v_max_f32_e32 v46, v81, v82
		v_max_f32_e32 v36, v36, v37
		v_max_f32_e32 v37, v45, v46
		v_max_f32_e32 v36, v36, v37
		ds_bpermute_b32 v37, v20, v36
		ds_bpermute_b32 v45, v12, v36
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v46, v37, v45
		v_accvgpr_read_b32 v36, a224
		v_accvgpr_read_b32 v37, a225
		v_max_f32_e32 v36, v36, v37
		v_accvgpr_read_b32 v37, a226
		v_accvgpr_read_b32 v45, a227
		v_max_f32_e32 v37, v37, v45
		v_accvgpr_read_b32 v45, a228
		v_accvgpr_read_b32 v47, a229
		v_max_f32_e32 v45, v45, v47
		v_accvgpr_read_b32 v47, a230
		v_accvgpr_read_b32 v80, a231
		v_max_f32_e32 v47, v47, v80
		v_accvgpr_read_b32 v80, a232
		v_accvgpr_read_b32 v81, a233
		v_max_f32_e32 v80, v80, v81
		v_accvgpr_read_b32 v81, a234
		v_accvgpr_read_b32 v82, a235
		v_max_f32_e32 v81, v81, v82
		v_accvgpr_read_b32 v82, a236
		v_accvgpr_read_b32 v83, a237
		v_max_f32_e32 v82, v82, v83
		v_accvgpr_read_b32 v83, a238
		v_accvgpr_read_b32 v84, a239
		v_max_f32_e32 v83, v83, v84
		v_accvgpr_read_b32 v84, a240
		v_accvgpr_read_b32 v85, a241
		v_max_f32_e32 v84, v84, v85
		v_accvgpr_read_b32 v85, a242
		v_accvgpr_read_b32 v86, a243
		v_max_f32_e32 v85, v85, v86
		v_accvgpr_read_b32 v86, a244
		v_accvgpr_read_b32 v87, a245
		v_max_f32_e32 v86, v86, v87
		v_accvgpr_read_b32 v87, a246
		v_accvgpr_read_b32 v88, a247
		v_max_f32_e32 v87, v87, v88
		v_accvgpr_read_b32 v88, a248
		v_accvgpr_read_b32 v89, a249
		v_max_f32_e32 v88, v88, v89
		v_accvgpr_read_b32 v89, a250
		v_accvgpr_read_b32 v90, a251
		v_max_f32_e32 v89, v89, v90
		v_accvgpr_read_b32 v90, a252
		v_accvgpr_read_b32 v91, a253
		v_max_f32_e32 v90, v90, v91
		v_accvgpr_read_b32 v91, a254
		v_accvgpr_read_b32 v92, a255
		v_max_f32_e32 v91, v91, v92
		v_max_f32_e32 v92, v144, v145
		v_max_f32_e32 v93, v146, v147
		v_max_f32_e32 v94, v148, v149
		v_max_f32_e32 v95, v150, v151
		v_max_f32_e32 v96, v152, v153
		v_max_f32_e32 v97, v154, v155
		v_max_f32_e32 v98, v156, v157
		v_max_f32_e32 v99, v158, v159
		v_accvgpr_read_b32 v100, a208
		v_accvgpr_read_b32 v101, a209
		v_max_f32_e32 v100, v100, v101
		v_accvgpr_read_b32 v101, a210
		v_accvgpr_read_b32 v102, a211
		v_max_f32_e32 v101, v101, v102
		v_accvgpr_read_b32 v102, a212
		v_accvgpr_read_b32 v103, a213
		v_max_f32_e32 v102, v102, v103
		v_accvgpr_read_b32 v103, a214
		v_accvgpr_read_b32 v104, a215
		v_max_f32_e32 v103, v103, v104
		v_accvgpr_read_b32 v104, a216
		v_accvgpr_read_b32 v105, a217
		v_max_f32_e32 v104, v104, v105
		v_accvgpr_read_b32 v105, a218
		v_accvgpr_read_b32 v106, a219
		v_max_f32_e32 v105, v105, v106
		v_accvgpr_read_b32 v106, a220
		v_accvgpr_read_b32 v107, a221
		v_max_f32_e32 v106, v106, v107
		v_accvgpr_read_b32 v107, a222
		v_accvgpr_read_b32 v108, a223
		v_max_f32_e32 v107, v107, v108
		v_max_f32_e32 v36, v36, v37
		v_max_f32_e32 v37, v45, v47
		v_max_f32_e32 v45, v80, v81
		v_max_f32_e32 v47, v82, v83
		v_max_f32_e32 v80, v84, v85
		v_max_f32_e32 v81, v86, v87
		v_max_f32_e32 v82, v88, v89
		v_max_f32_e32 v83, v90, v91
		v_max_f32_e32 v84, v92, v93
		v_max_f32_e32 v85, v94, v95
		v_max_f32_e32 v86, v96, v97
		v_max_f32_e32 v87, v98, v99
		v_max_f32_e32 v88, v100, v101
		v_max_f32_e32 v89, v102, v103
		v_max_f32_e32 v90, v104, v105
		v_max_f32_e32 v91, v106, v107
		v_max_f32_e32 v36, v36, v37
		v_max_f32_e32 v37, v45, v47
		v_max_f32_e32 v45, v80, v81
		v_max_f32_e32 v47, v82, v83
		v_max_f32_e32 v80, v84, v85
		v_max_f32_e32 v81, v86, v87
		v_max_f32_e32 v82, v88, v89
		v_max_f32_e32 v83, v90, v91
		v_max_f32_e32 v36, v36, v37
		v_max_f32_e32 v37, v45, v47
		v_max_f32_e32 v45, v80, v81
		v_max_f32_e32 v47, v82, v83
		v_max_f32_e32 v36, v36, v37
		v_max_f32_e32 v37, v45, v47
		v_max_f32_e32 v36, v36, v37
		ds_bpermute_b32 v37, v20, v36
		ds_bpermute_b32 v45, v12, v36
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v47, v37, v45
		v_pk_mul_f32 v[36:37], v[46:47], v[34:35]
		v_max_f32_e32 v45, v16, v36
		v_max_f32_e32 v46, v21, v37
		v_accvgpr_read_b32 v36, a144
		v_accvgpr_read_b32 v37, a145
		v_pk_mul_f32 v[80:81], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a146
		v_accvgpr_read_b32 v37, a147
		v_pk_mul_f32 v[82:83], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a148
		v_accvgpr_read_b32 v37, a149
		v_pk_mul_f32 v[84:85], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a150
		v_accvgpr_read_b32 v37, a151
		v_pk_mul_f32 v[86:87], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a152
		v_accvgpr_read_b32 v37, a153
		v_pk_mul_f32 v[88:89], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a154
		v_accvgpr_read_b32 v37, a155
		v_pk_mul_f32 v[90:91], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a156
		v_accvgpr_read_b32 v37, a157
		v_pk_mul_f32 v[92:93], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a158
		v_accvgpr_read_b32 v37, a159
		v_pk_mul_f32 v[94:95], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a160
		v_accvgpr_read_b32 v37, a161
		v_pk_mul_f32 v[96:97], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a162
		v_accvgpr_read_b32 v37, a163
		v_pk_mul_f32 v[98:99], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a164
		v_accvgpr_read_b32 v37, a165
		v_pk_mul_f32 v[100:101], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a166
		v_accvgpr_read_b32 v37, a167
		v_pk_mul_f32 v[102:103], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a168
		v_accvgpr_read_b32 v37, a169
		v_pk_mul_f32 v[104:105], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a170
		v_accvgpr_read_b32 v37, a171
		v_pk_mul_f32 v[106:107], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a172
		v_accvgpr_read_b32 v37, a173
		v_pk_mul_f32 v[108:109], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a174
		v_accvgpr_read_b32 v37, a175
		v_pk_mul_f32 v[110:111], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a176
		v_accvgpr_read_b32 v37, a177
		v_pk_mul_f32 v[112:113], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a178
		v_accvgpr_read_b32 v37, a179
		v_pk_mul_f32 v[114:115], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a180
		v_accvgpr_read_b32 v37, a181
		v_pk_mul_f32 v[116:117], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a182
		v_accvgpr_read_b32 v37, a183
		v_pk_mul_f32 v[118:119], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a184
		v_accvgpr_read_b32 v37, a185
		v_pk_mul_f32 v[120:121], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a186
		v_accvgpr_read_b32 v37, a187
		v_pk_mul_f32 v[122:123], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a188
		v_accvgpr_read_b32 v37, a189
		v_pk_mul_f32 v[124:125], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a190
		v_accvgpr_read_b32 v37, a191
		v_pk_mul_f32 v[126:127], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a192
		v_accvgpr_read_b32 v37, a193
		v_pk_mul_f32 v[128:129], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a194
		v_accvgpr_read_b32 v37, a195
		v_pk_mul_f32 v[130:131], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a196
		v_accvgpr_read_b32 v37, a197
		v_pk_mul_f32 v[132:133], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a198
		v_accvgpr_read_b32 v37, a199
		v_pk_mul_f32 v[134:135], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a200
		v_accvgpr_read_b32 v37, a201
		v_pk_mul_f32 v[136:137], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a202
		v_accvgpr_read_b32 v37, a203
		v_pk_mul_f32 v[138:139], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a204
		v_accvgpr_read_b32 v37, a205
		v_pk_mul_f32 v[140:141], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a206
		v_accvgpr_read_b32 v37, a207
		v_pk_mul_f32 v[142:143], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a224
		v_accvgpr_read_b32 v37, a225
		v_pk_mul_f32 v[160:161], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a226
		v_accvgpr_read_b32 v37, a227
		v_pk_mul_f32 v[162:163], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a228
		v_accvgpr_read_b32 v37, a229
		v_pk_mul_f32 v[164:165], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a230
		v_accvgpr_read_b32 v37, a231
		v_pk_mul_f32 v[166:167], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a232
		v_accvgpr_read_b32 v37, a233
		v_pk_mul_f32 v[168:169], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a234
		v_accvgpr_read_b32 v37, a235
		v_pk_mul_f32 v[170:171], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a236
		v_accvgpr_read_b32 v37, a237
		v_pk_mul_f32 v[172:173], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a238
		v_accvgpr_read_b32 v37, a239
		v_pk_mul_f32 v[174:175], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a240
		v_accvgpr_read_b32 v37, a241
		v_pk_mul_f32 v[176:177], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a242
		v_accvgpr_read_b32 v37, a243
		v_pk_mul_f32 v[178:179], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a244
		v_accvgpr_read_b32 v37, a245
		v_pk_mul_f32 v[180:181], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a246
		v_accvgpr_read_b32 v37, a247
		v_pk_mul_f32 v[182:183], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a248
		v_accvgpr_read_b32 v37, a249
		v_pk_mul_f32 v[184:185], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a250
		v_accvgpr_read_b32 v37, a251
		v_pk_mul_f32 v[186:187], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a252
		v_accvgpr_read_b32 v37, a253
		v_pk_mul_f32 v[188:189], v[36:37], v[34:35]
		v_accvgpr_read_b32 v36, a254
		v_accvgpr_read_b32 v37, a255
		v_pk_mul_f32 v[190:191], v[36:37], v[34:35]
		v_pk_mul_f32 v[36:37], v[144:145], v[34:35]
		v_pk_mul_f32 v[144:145], v[146:147], v[34:35]
		v_pk_mul_f32 v[146:147], v[148:149], v[34:35]
		v_pk_mul_f32 v[148:149], v[150:151], v[34:35]
		v_pk_mul_f32 v[150:151], v[152:153], v[34:35]
		v_pk_mul_f32 v[152:153], v[154:155], v[34:35]
		v_pk_mul_f32 v[154:155], v[156:157], v[34:35]
		v_pk_mul_f32 v[156:157], v[158:159], v[34:35]
		v_accvgpr_read_b32 v158, a208
		v_accvgpr_read_b32 v159, a209
		v_pk_mul_f32 v[192:193], v[158:159], v[34:35]
		v_accvgpr_read_b32 v158, a210
		v_accvgpr_read_b32 v159, a211
		v_pk_mul_f32 v[194:195], v[158:159], v[34:35]
		v_accvgpr_read_b32 v158, a212
		v_accvgpr_read_b32 v159, a213
		v_pk_mul_f32 v[196:197], v[158:159], v[34:35]
		v_accvgpr_read_b32 v158, a214
		v_accvgpr_read_b32 v159, a215
		v_pk_mul_f32 v[158:159], v[158:159], v[34:35]
		v_accvgpr_write_b32 a142, v158
		v_accvgpr_write_b32 a143, v159
		v_accvgpr_read_b32 v158, a216
		v_accvgpr_read_b32 v159, a217
		v_pk_mul_f32 v[158:159], v[158:159], v[34:35]
		v_accvgpr_write_b32 a144, v158
		v_accvgpr_write_b32 a145, v159
		v_accvgpr_read_b32 v158, a218
		v_accvgpr_read_b32 v159, a219
		v_pk_mul_f32 v[158:159], v[158:159], v[34:35]
		v_accvgpr_write_b32 a146, v158
		v_accvgpr_write_b32 a147, v159
		v_accvgpr_read_b32 v158, a220
		v_accvgpr_read_b32 v159, a221
		v_pk_mul_f32 v[158:159], v[158:159], v[34:35]
		v_accvgpr_write_b32 a148, v158
		v_accvgpr_write_b32 a149, v159
		v_accvgpr_read_b32 v158, a222
		v_accvgpr_read_b32 v159, a223
		v_pk_mul_f32 v[198:199], v[158:159], v[34:35]
		v_sub_f32_e32 v47, v80, v45
		v_sub_f32_e32 v80, v81, v45
		v_sub_f32_e32 v81, v82, v45
		v_sub_f32_e32 v82, v83, v45
		v_sub_f32_e32 v83, v84, v45
		v_sub_f32_e32 v84, v85, v45
		v_sub_f32_e32 v85, v86, v45
		v_sub_f32_e32 v86, v87, v45
		v_sub_f32_e32 v87, v88, v45
		v_sub_f32_e32 v88, v89, v45
		v_sub_f32_e32 v89, v90, v45
		v_sub_f32_e32 v90, v91, v45
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
		v_sub_f32_e32 v143, v160, v46
		v_sub_f32_e32 v158, v161, v46
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
		v_sub_f32_e32 v36, v36, v46
		v_sub_f32_e32 v37, v37, v46
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
		v_sub_f32_e32 v189, v192, v46
		v_sub_f32_e32 v190, v193, v46
		v_sub_f32_e32 v191, v194, v46
		v_sub_f32_e32 v192, v195, v46
		v_sub_f32_e32 v193, v196, v46
		v_sub_f32_e32 v194, v197, v46
		v_accvgpr_read_b32 v195, a142
		v_sub_f32_e32 v195, v195, v46
		v_accvgpr_read_b32 v196, a143
		v_sub_f32_e32 v196, v196, v46
		v_accvgpr_read_b32 v197, a144
		v_sub_f32_e32 v197, v197, v46
		v_accvgpr_read_b32 v200, a145
		v_sub_f32_e32 v200, v200, v46
		v_accvgpr_read_b32 v201, a146
		v_sub_f32_e32 v201, v201, v46
		v_accvgpr_read_b32 v202, a147
		v_sub_f32_e32 v202, v202, v46
		v_accvgpr_read_b32 v203, a148
		v_sub_f32_e32 v203, v203, v46
		v_accvgpr_read_b32 v204, a149
		v_sub_f32_e32 v204, v204, v46
		v_sub_f32_e32 v198, v198, v46
		v_sub_f32_e32 v199, v199, v46
		v_exp_f32_e32 v206, v47
		v_exp_f32_e32 v208, v80
		v_exp_f32_e32 v207, v81
		v_exp_f32_e32 v209, v82
		v_exp_f32_e32 v80, v83
		v_exp_f32_e32 v82, v84
		v_exp_f32_e32 v81, v85
		v_exp_f32_e32 v83, v86
		v_exp_f32_e32 v84, v87
		v_exp_f32_e32 v86, v88
		v_exp_f32_e32 v85, v89
		v_exp_f32_e32 v87, v90
		v_exp_f32_e32 v88, v91
		v_exp_f32_e32 v90, v92
		v_exp_f32_e32 v89, v93
		v_exp_f32_e32 v91, v94
		v_exp_f32_e32 v92, v95
		v_exp_f32_e32 v94, v96
		v_exp_f32_e32 v93, v97
		v_exp_f32_e32 v95, v98
		v_exp_f32_e32 v96, v99
		v_exp_f32_e32 v98, v100
		v_exp_f32_e32 v97, v101
		v_exp_f32_e32 v99, v102
		v_exp_f32_e32 v100, v103
		v_exp_f32_e32 v102, v104
		v_exp_f32_e32 v101, v105
		v_exp_f32_e32 v103, v106
		v_exp_f32_e32 v104, v107
		v_exp_f32_e32 v106, v108
		v_exp_f32_e32 v105, v109
		v_exp_f32_e32 v107, v110
		v_exp_f32_e32 v108, v111
		v_exp_f32_e32 v110, v112
		v_exp_f32_e32 v109, v113
		v_exp_f32_e32 v111, v114
		v_exp_f32_e32 v112, v115
		v_exp_f32_e32 v114, v116
		v_exp_f32_e32 v113, v117
		v_exp_f32_e32 v115, v118
		v_exp_f32_e32 v116, v119
		v_exp_f32_e32 v118, v120
		v_exp_f32_e32 v117, v121
		v_exp_f32_e32 v119, v122
		v_exp_f32_e32 v120, v123
		v_exp_f32_e32 v122, v124
		v_exp_f32_e32 v121, v125
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
		v_exp_f32_e32 v141, v143
		v_exp_f32_e32 v143, v158
		v_exp_f32_e32 v210, v159
		v_exp_f32_e32 v158, v160
		v_exp_f32_e32 v211, v161
		v_exp_f32_e32 v159, v162
		v_exp_f32_e32 v160, v163
		v_exp_f32_e32 v162, v164
		v_exp_f32_e32 v161, v165
		v_exp_f32_e32 v163, v166
		v_exp_f32_e32 v164, v167
		v_exp_f32_e32 v166, v168
		v_exp_f32_e32 v165, v169
		v_exp_f32_e32 v167, v170
		v_exp_f32_e32 v168, v171
		v_exp_f32_e32 v170, v172
		v_exp_f32_e32 v169, v173
		v_exp_f32_e32 v171, v174
		v_exp_f32_e32 v172, v175
		v_exp_f32_e32 v174, v176
		v_exp_f32_e32 v173, v177
		v_exp_f32_e32 v175, v178
		v_exp_f32_e32 v176, v179
		v_exp_f32_e32 v178, v180
		v_exp_f32_e32 v177, v181
		v_exp_f32_e32 v179, v182
		v_exp_f32_e32 v180, v183
		v_exp_f32_e32 v182, v184
		v_exp_f32_e32 v181, v185
		v_exp_f32_e32 v183, v186
		v_exp_f32_e32 v184, v187
		v_exp_f32_e32 v186, v188
		v_exp_f32_e32 v185, v36
		v_exp_f32_e32 v187, v37
		v_exp_f32_e32 v212, v144
		v_exp_f32_e32 v214, v145
		v_exp_f32_e32 v213, v146
		v_exp_f32_e32 v215, v147
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
		v_exp_f32_e32 v153, v189
		v_exp_f32_e32 v155, v190
		v_exp_f32_e32 v156, v191
		v_exp_f32_e32 v188, v192
		v_exp_f32_e32 v157, v193
		v_exp_f32_e32 v189, v194
		v_exp_f32_e32 v190, v195
		v_exp_f32_e32 v192, v196
		v_exp_f32_e32 v191, v197
		v_exp_f32_e32 v193, v200
		v_exp_f32_e32 v194, v201
		v_exp_f32_e32 v196, v202
		v_exp_f32_e32 v195, v203
		v_exp_f32_e32 v197, v204
		v_exp_f32_e32 v200, v198
		v_exp_f32_e32 v202, v199
		v_pk_add_f32 v[36:37], v[206:207], v[208:209]
		v_pk_add_f32 v[198:199], v[80:81], v[82:83]
		v_pk_add_f32 v[204:205], v[84:85], v[86:87]
		v_pk_add_f32 v[216:217], v[88:89], v[90:91]
		v_pk_add_f32 v[218:219], v[92:93], v[94:95]
		v_accvgpr_write_b32 a142, v218
		v_accvgpr_write_b32 a143, v219
		v_pk_add_f32 v[218:219], v[96:97], v[98:99]
		v_accvgpr_write_b32 a144, v218
		v_accvgpr_write_b32 a145, v219
		v_pk_add_f32 v[218:219], v[100:101], v[102:103]
		v_accvgpr_write_b32 a146, v218
		v_accvgpr_write_b32 a147, v219
		v_pk_add_f32 v[218:219], v[104:105], v[106:107]
		v_accvgpr_write_b32 a148, v218
		v_accvgpr_write_b32 a149, v219
		v_pk_add_f32 v[218:219], v[108:109], v[110:111]
		v_accvgpr_write_b32 a150, v218
		v_accvgpr_write_b32 a151, v219
		v_pk_add_f32 v[218:219], v[112:113], v[114:115]
		v_accvgpr_write_b32 a152, v218
		v_accvgpr_write_b32 a153, v219
		v_pk_add_f32 v[218:219], v[116:117], v[118:119]
		v_accvgpr_write_b32 a154, v218
		v_accvgpr_write_b32 a155, v219
		v_pk_add_f32 v[218:219], v[120:121], v[122:123]
		v_accvgpr_write_b32 a156, v218
		v_accvgpr_write_b32 a157, v219
		v_pk_add_f32 v[218:219], v[124:125], v[126:127]
		v_accvgpr_write_b32 a158, v218
		v_accvgpr_write_b32 a159, v219
		v_pk_add_f32 v[218:219], v[128:129], v[130:131]
		v_accvgpr_write_b32 a160, v218
		v_accvgpr_write_b32 a161, v219
		v_pk_add_f32 v[218:219], v[132:133], v[134:135]
		v_accvgpr_write_b32 a162, v218
		v_accvgpr_write_b32 a163, v219
		v_pk_add_f32 v[218:219], v[136:137], v[138:139]
		v_accvgpr_write_b32 a164, v218
		v_accvgpr_write_b32 a165, v219
		v_mov_b32_e32 v218, v37
		v_mov_b32_e32 v219, v199
		v_mov_b32_e32 v220, v36
		v_mov_b32_e32 v221, v198
		v_pk_add_f32 v[36:37], v[220:221], v[218:219]
		v_mov_b32_e32 v198, v205
		v_mov_b32_e32 v199, v217
		v_mov_b32_e32 v218, v204
		v_mov_b32_e32 v219, v216
		v_pk_add_f32 v[204:205], v[218:219], v[198:199]
		v_accvgpr_read_b32 v47, a143
		v_mov_b32_e32 v198, v47
		v_accvgpr_read_b32 v47, a145
		v_mov_b32_e32 v199, v47
		v_accvgpr_read_b32 v47, a142
		v_mov_b32_e32 v216, v47
		v_accvgpr_read_b32 v47, a144
		v_mov_b32_e32 v217, v47
		v_pk_add_f32 v[218:219], v[216:217], v[198:199]
		v_accvgpr_read_b32 v47, a147
		v_mov_b32_e32 v198, v47
		v_accvgpr_read_b32 v47, a149
		v_mov_b32_e32 v199, v47
		v_accvgpr_read_b32 v47, a146
		v_mov_b32_e32 v216, v47
		v_accvgpr_read_b32 v47, a148
		v_mov_b32_e32 v217, v47
		v_pk_add_f32 v[198:199], v[216:217], v[198:199]
		v_accvgpr_write_b32 a142, v198
		v_accvgpr_write_b32 a143, v199
		v_accvgpr_read_b32 v47, a151
		v_mov_b32_e32 v198, v47
		v_accvgpr_read_b32 v47, a153
		v_mov_b32_e32 v199, v47
		v_accvgpr_read_b32 v47, a150
		v_mov_b32_e32 v216, v47
		v_accvgpr_read_b32 v47, a152
		v_mov_b32_e32 v217, v47
		v_pk_add_f32 v[198:199], v[216:217], v[198:199]
		v_accvgpr_write_b32 a144, v198
		v_accvgpr_write_b32 a145, v199
		v_accvgpr_read_b32 v47, a155
		v_mov_b32_e32 v198, v47
		v_accvgpr_read_b32 v47, a157
		v_mov_b32_e32 v199, v47
		v_accvgpr_read_b32 v47, a154
		v_mov_b32_e32 v216, v47
		v_accvgpr_read_b32 v47, a156
		v_mov_b32_e32 v217, v47
		v_pk_add_f32 v[198:199], v[216:217], v[198:199]
		v_accvgpr_write_b32 a146, v198
		v_accvgpr_write_b32 a147, v199
		v_accvgpr_read_b32 v47, a159
		v_mov_b32_e32 v198, v47
		v_accvgpr_read_b32 v47, a161
		v_mov_b32_e32 v199, v47
		v_accvgpr_read_b32 v47, a158
		v_mov_b32_e32 v216, v47
		v_accvgpr_read_b32 v47, a160
		v_mov_b32_e32 v217, v47
		v_pk_add_f32 v[198:199], v[216:217], v[198:199]
		v_accvgpr_write_b32 a148, v198
		v_accvgpr_write_b32 a149, v199
		v_accvgpr_read_b32 v47, a163
		v_mov_b32_e32 v198, v47
		v_accvgpr_read_b32 v47, a165
		v_mov_b32_e32 v199, v47
		v_accvgpr_read_b32 v47, a162
		v_mov_b32_e32 v216, v47
		v_accvgpr_read_b32 v47, a164
		v_mov_b32_e32 v217, v47
		v_pk_add_f32 v[220:221], v[216:217], v[198:199]
		v_mov_b32_e32 v198, v37
		v_mov_b32_e32 v199, v205
		v_mov_b32_e32 v216, v36
		v_mov_b32_e32 v217, v204
		v_pk_add_f32 v[36:37], v[216:217], v[198:199]
		v_mov_b32_e32 v198, v219
		v_accvgpr_read_b32 v47, a143
		v_mov_b32_e32 v199, v47
		v_mov_b32_e32 v204, v218
		v_accvgpr_read_b32 v47, a142
		v_mov_b32_e32 v205, v47
		v_pk_add_f32 v[216:217], v[204:205], v[198:199]
		v_accvgpr_read_b32 v47, a145
		v_mov_b32_e32 v198, v47
		v_accvgpr_read_b32 v47, a147
		v_mov_b32_e32 v199, v47
		v_accvgpr_read_b32 v47, a144
		v_mov_b32_e32 v204, v47
		v_accvgpr_read_b32 v47, a146
		v_mov_b32_e32 v205, v47
		v_pk_add_f32 v[218:219], v[204:205], v[198:199]
		v_accvgpr_read_b32 v47, a149
		v_mov_b32_e32 v198, v47
		v_mov_b32_e32 v199, v221
		v_accvgpr_read_b32 v47, a148
		v_mov_b32_e32 v204, v47
		v_mov_b32_e32 v205, v220
		v_pk_add_f32 v[220:221], v[204:205], v[198:199]
		v_mov_b32_e32 v198, v37
		v_mov_b32_e32 v199, v217
		v_mov_b32_e32 v204, v36
		v_mov_b32_e32 v205, v216
		v_pk_add_f32 v[36:37], v[204:205], v[198:199]
		v_mov_b32_e32 v198, v219
		v_mov_b32_e32 v199, v221
		v_mov_b32_e32 v204, v218
		v_mov_b32_e32 v205, v220
		v_pk_add_f32 v[216:217], v[204:205], v[198:199]
		v_mov_b32_e32 v198, v37
		v_mov_b32_e32 v199, v217
		v_mov_b32_e32 v204, v36
		v_mov_b32_e32 v205, v216
		v_pk_add_f32 v[36:37], v[204:205], v[198:199]
		v_add_f32_e32 v36, v36, v37
		ds_bpermute_b32 v140, v20, v36
		ds_bpermute_b32 v142, v12, v36
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[36:37], v[140:141], v[142:143]
		v_accvgpr_write_b32 a142, v36
		v_accvgpr_write_b32 a143, v37
		v_pk_add_f32 v[36:37], v[210:211], v[158:159]
		v_pk_add_f32 v[198:199], v[160:161], v[162:163]
		v_accvgpr_write_b32 a144, v198
		v_accvgpr_write_b32 a145, v199
		v_pk_add_f32 v[198:199], v[164:165], v[166:167]
		v_pk_add_f32 v[204:205], v[168:169], v[170:171]
		v_accvgpr_write_b32 a146, v204
		v_accvgpr_write_b32 a147, v205
		v_pk_add_f32 v[204:205], v[172:173], v[174:175]
		v_pk_add_f32 v[216:217], v[176:177], v[178:179]
		v_accvgpr_write_b32 a148, v216
		v_accvgpr_write_b32 a149, v217
		v_pk_add_f32 v[216:217], v[180:181], v[182:183]
		v_pk_add_f32 v[218:219], v[184:185], v[186:187]
		v_accvgpr_write_b32 a150, v218
		v_accvgpr_write_b32 a151, v219
		v_pk_add_f32 v[218:219], v[212:213], v[214:215]
		v_accvgpr_write_b32 a152, v218
		v_accvgpr_write_b32 a153, v219
		v_pk_add_f32 v[218:219], v[144:145], v[146:147]
		v_accvgpr_write_b32 a154, v218
		v_accvgpr_write_b32 a155, v219
		v_pk_add_f32 v[218:219], v[148:149], v[150:151]
		v_accvgpr_write_b32 a156, v218
		v_accvgpr_write_b32 a157, v219
		v_pk_add_f32 v[218:219], v[152:153], v[154:155]
		v_accvgpr_write_b32 a158, v218
		v_accvgpr_write_b32 a159, v219
		v_pk_add_f32 v[218:219], v[156:157], v[188:189]
		v_accvgpr_write_b32 a160, v218
		v_accvgpr_write_b32 a161, v219
		v_pk_add_f32 v[218:219], v[190:191], v[192:193]
		v_accvgpr_write_b32 a162, v218
		v_accvgpr_write_b32 a163, v219
		v_pk_add_f32 v[218:219], v[194:195], v[196:197]
		v_accvgpr_write_b32 a164, v218
		v_accvgpr_write_b32 a165, v219
		v_mov_b32_e32 v203, v36
		v_accvgpr_read_b32 v36, a143
		v_mov_b32_e32 v201, v36
		v_pk_add_f32 v[218:219], v[200:201], v[202:203]
		v_accvgpr_write_b32 a166, v218
		v_accvgpr_write_b32 a167, v219
		v_mov_b32_e32 v218, v37
		v_mov_b32_e32 v219, v198
		v_accvgpr_read_b32 v36, a144
		v_accvgpr_read_b32 v37, a145
		v_pk_add_f32 v[220:221], v[218:219], v[36:37]
		v_mov_b32_e32 v36, v199
		v_mov_b32_e32 v37, v204
		v_accvgpr_read_b32 v198, a146
		v_accvgpr_read_b32 v199, a147
		v_pk_add_f32 v[36:37], v[36:37], v[198:199]
		v_accvgpr_write_b32 a144, v36
		v_accvgpr_write_b32 a145, v37
		v_mov_b32_e32 v36, v205
		v_mov_b32_e32 v37, v216
		v_accvgpr_read_b32 v198, a148
		v_accvgpr_read_b32 v199, a149
		v_pk_add_f32 v[204:205], v[36:37], v[198:199]
		v_mov_b32_e32 v36, v217
		v_accvgpr_read_b32 v37, a152
		v_accvgpr_read_b32 v198, a150
		v_accvgpr_read_b32 v199, a151
		v_pk_add_f32 v[36:37], v[36:37], v[198:199]
		v_accvgpr_write_b32 a146, v36
		v_accvgpr_write_b32 a147, v37
		v_accvgpr_read_b32 v36, a153
		v_mov_b32_e32 v198, v36
		v_accvgpr_read_b32 v36, a156
		v_mov_b32_e32 v199, v36
		v_accvgpr_read_b32 v36, a154
		v_accvgpr_read_b32 v37, a155
		v_pk_add_f32 v[216:217], v[198:199], v[36:37]
		v_accvgpr_read_b32 v36, a157
		v_mov_b32_e32 v198, v36
		v_accvgpr_read_b32 v36, a160
		v_mov_b32_e32 v199, v36
		v_accvgpr_read_b32 v36, a158
		v_accvgpr_read_b32 v37, a159
		v_pk_add_f32 v[36:37], v[198:199], v[36:37]
		v_accvgpr_write_b32 a148, v36
		v_accvgpr_write_b32 a149, v37
		v_accvgpr_read_b32 v36, a161
		v_mov_b32_e32 v198, v36
		v_accvgpr_read_b32 v36, a164
		v_mov_b32_e32 v199, v36
		v_accvgpr_read_b32 v36, a162
		v_accvgpr_read_b32 v37, a163
		v_pk_add_f32 v[218:219], v[198:199], v[36:37]
		v_accvgpr_read_b32 v36, a165
		v_mov_b32_e32 v198, v36
		v_mov_b32_e32 v199, v220
		v_accvgpr_read_b32 v36, a166
		v_accvgpr_read_b32 v37, a167
		v_pk_add_f32 v[36:37], v[198:199], v[36:37]
		v_accvgpr_write_b32 a150, v36
		v_accvgpr_write_b32 a151, v37
		v_mov_b32_e32 v36, v221
		v_mov_b32_e32 v37, v204
		v_accvgpr_read_b32 v198, a144
		v_accvgpr_read_b32 v199, a145
		v_pk_add_f32 v[220:221], v[36:37], v[198:199]
		v_mov_b32_e32 v36, v205
		v_mov_b32_e32 v37, v216
		v_accvgpr_read_b32 v198, a146
		v_accvgpr_read_b32 v199, a147
		v_pk_add_f32 v[36:37], v[36:37], v[198:199]
		v_mov_b32_e32 v198, v217
		v_mov_b32_e32 v199, v218
		v_accvgpr_read_b32 v204, a148
		v_accvgpr_read_b32 v205, a149
		v_pk_add_f32 v[216:217], v[198:199], v[204:205]
		v_mov_b32_e32 v198, v219
		v_mov_b32_e32 v199, v220
		v_accvgpr_read_b32 v204, a150
		v_accvgpr_read_b32 v205, a151
		v_pk_add_f32 v[198:199], v[198:199], v[204:205]
		v_mov_b32_e32 v204, v221
		v_mov_b32_e32 v205, v216
		v_pk_add_f32 v[218:219], v[204:205], v[36:37]
		v_mov_b32_e32 v36, v217
		v_mov_b32_e32 v37, v218
		v_pk_add_f32 v[204:205], v[36:37], v[198:199]
		v_add_f32_e32 v36, v219, v204
		v_add_f32_e32 v36, v205, v36
		ds_bpermute_b32 v37, v20, v36
		ds_bpermute_b32 v47, v12, v36
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v199, v37, v47
		v_sub_f32_e32 v16, v16, v45
		v_sub_f32_e32 v21, v21, v46
		v_exp_f32_e32 v36, v16
		v_exp_f32_e32 v204, v21
		v_mov_b32_e32 v37, v36
		v_pk_mul_f32 v[48:49], v[48:49], v[36:37]
		v_pk_mul_f32 v[50:51], v[50:51], v[36:37]
		v_pk_mul_f32 v[52:53], v[52:53], v[36:37]
		v_pk_mul_f32 v[54:55], v[54:55], v[36:37]
		v_pk_mul_f32 v[56:57], v[56:57], v[36:37]
		v_pk_mul_f32 v[58:59], v[58:59], v[36:37]
		v_pk_mul_f32 v[60:61], v[60:61], v[36:37]
		v_pk_mul_f32 v[62:63], v[62:63], v[36:37]
		v_pk_mul_f32 v[64:65], v[64:65], v[36:37]
		v_pk_mul_f32 v[66:67], v[66:67], v[36:37]
		v_pk_mul_f32 v[68:69], v[68:69], v[36:37]
		v_pk_mul_f32 v[70:71], v[70:71], v[36:37]
		v_pk_mul_f32 v[72:73], v[72:73], v[36:37]
		v_pk_mul_f32 v[74:75], v[74:75], v[36:37]
		v_pk_mul_f32 v[76:77], v[76:77], v[36:37]
		v_pk_mul_f32 v[78:79], v[78:79], v[36:37]
		v_mov_b32_e32 v205, v204
		v_accvgpr_read_b32 v216, a48
		v_accvgpr_read_b32 v217, a49
		v_pk_mul_f32 v[216:217], v[216:217], v[204:205]
		v_accvgpr_write_b32 a48, v216
		v_accvgpr_write_b32 a49, v217
		v_accvgpr_read_b32 v216, a50
		v_accvgpr_read_b32 v217, a51
		v_pk_mul_f32 v[216:217], v[216:217], v[204:205]
		v_accvgpr_write_b32 a50, v216
		v_accvgpr_write_b32 a51, v217
		v_accvgpr_read_b32 v216, a52
		v_accvgpr_read_b32 v217, a53
		v_pk_mul_f32 v[216:217], v[216:217], v[204:205]
		v_accvgpr_write_b32 a52, v216
		v_accvgpr_write_b32 a53, v217
		v_accvgpr_read_b32 v216, a54
		v_accvgpr_read_b32 v217, a55
		v_pk_mul_f32 v[216:217], v[216:217], v[204:205]
		v_accvgpr_write_b32 a54, v216
		v_accvgpr_write_b32 a55, v217
		v_accvgpr_read_b32 v216, a56
		v_accvgpr_read_b32 v217, a57
		v_pk_mul_f32 v[216:217], v[216:217], v[204:205]
		v_accvgpr_write_b32 a56, v216
		v_accvgpr_write_b32 a57, v217
		v_accvgpr_read_b32 v216, a58
		v_accvgpr_read_b32 v217, a59
		v_pk_mul_f32 v[216:217], v[216:217], v[204:205]
		v_accvgpr_write_b32 a58, v216
		v_accvgpr_write_b32 a59, v217
		v_accvgpr_read_b32 v216, a60
		v_accvgpr_read_b32 v217, a61
		v_pk_mul_f32 v[216:217], v[216:217], v[204:205]
		v_accvgpr_write_b32 a60, v216
		v_accvgpr_write_b32 a61, v217
		v_accvgpr_read_b32 v216, a62
		v_accvgpr_read_b32 v217, a63
		v_pk_mul_f32 v[216:217], v[216:217], v[204:205]
		v_accvgpr_write_b32 a62, v216
		v_accvgpr_write_b32 a63, v217
		v_accvgpr_read_b32 v216, a64
		v_accvgpr_read_b32 v217, a65
		v_pk_mul_f32 v[216:217], v[216:217], v[204:205]
		v_accvgpr_write_b32 a64, v216
		v_accvgpr_write_b32 a65, v217
		v_accvgpr_read_b32 v216, a66
		v_accvgpr_read_b32 v217, a67
		v_pk_mul_f32 v[216:217], v[216:217], v[204:205]
		v_accvgpr_write_b32 a66, v216
		v_accvgpr_write_b32 a67, v217
		v_accvgpr_read_b32 v216, a68
		v_accvgpr_read_b32 v217, a69
		v_pk_mul_f32 v[216:217], v[216:217], v[204:205]
		v_accvgpr_write_b32 a68, v216
		v_accvgpr_write_b32 a69, v217
		v_accvgpr_read_b32 v216, a70
		v_accvgpr_read_b32 v217, a71
		v_pk_mul_f32 v[216:217], v[216:217], v[204:205]
		v_accvgpr_write_b32 a70, v216
		v_accvgpr_write_b32 a71, v217
		v_accvgpr_read_b32 v216, a72
		v_accvgpr_read_b32 v217, a73
		v_pk_mul_f32 v[216:217], v[216:217], v[204:205]
		v_accvgpr_write_b32 a72, v216
		v_accvgpr_write_b32 a73, v217
		v_accvgpr_read_b32 v216, a74
		v_accvgpr_read_b32 v217, a75
		v_pk_mul_f32 v[216:217], v[216:217], v[204:205]
		v_accvgpr_write_b32 a74, v216
		v_accvgpr_write_b32 a75, v217
		v_accvgpr_read_b32 v216, a76
		v_accvgpr_read_b32 v217, a77
		v_pk_mul_f32 v[216:217], v[216:217], v[204:205]
		v_accvgpr_write_b32 a76, v216
		v_accvgpr_write_b32 a77, v217
		v_accvgpr_read_b32 v216, a78
		v_accvgpr_read_b32 v217, a79
		v_pk_mul_f32 v[216:217], v[216:217], v[204:205]
		v_accvgpr_write_b32 a78, v216
		v_accvgpr_write_b32 a79, v217
		v_accvgpr_read_b32 v16, a142
		v_mov_b32_e32 v198, v16
		v_mov_b32_e32 v216, v36
		v_mov_b32_e32 v217, v204
		v_accvgpr_read_b32 v36, a140
		v_accvgpr_read_b32 v37, a141
		v_pk_fma_f32 v[36:37], v[36:37], v[216:217], v[198:199]
		v_cvt_pk_bf16_f32 v216, v206, v208
		v_cvt_pk_bf16_f32 v217, v207, v209
		v_cvt_pk_bf16_f32 v218, v80, v82
		v_cvt_pk_bf16_f32 v219, v81, v83
		v_cvt_pk_bf16_f32 v80, v84, v86
		v_cvt_pk_bf16_f32 v81, v85, v87
		v_cvt_pk_bf16_f32 v82, v88, v90
		v_cvt_pk_bf16_f32 v83, v89, v91
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
		v_cvt_pk_bf16_f32 v108, v141, v143
		v_cvt_pk_bf16_f32 v109, v210, v158
		v_cvt_pk_bf16_f32 v110, v211, v159
		v_cvt_pk_bf16_f32 v111, v160, v162
		v_cvt_pk_bf16_f32 v112, v161, v163
		v_cvt_pk_bf16_f32 v113, v164, v166
		v_cvt_pk_bf16_f32 v114, v165, v167
		v_cvt_pk_bf16_f32 v115, v168, v170
		v_cvt_pk_bf16_f32 v116, v169, v171
		v_cvt_pk_bf16_f32 v117, v172, v174
		v_cvt_pk_bf16_f32 v118, v173, v175
		v_cvt_pk_bf16_f32 v119, v176, v178
		v_cvt_pk_bf16_f32 v120, v177, v179
		v_cvt_pk_bf16_f32 v121, v180, v182
		v_cvt_pk_bf16_f32 v122, v181, v183
		v_cvt_pk_bf16_f32 v123, v184, v186
		v_cvt_pk_bf16_f32 v124, v185, v187
		v_cvt_pk_bf16_f32 v125, v212, v214
		v_cvt_pk_bf16_f32 v126, v213, v215
		v_cvt_pk_bf16_f32 v127, v144, v146
		v_cvt_pk_bf16_f32 v128, v145, v147
		v_cvt_pk_bf16_f32 v129, v148, v150
		v_cvt_pk_bf16_f32 v130, v149, v151
		v_cvt_pk_bf16_f32 v131, v152, v154
		v_cvt_pk_bf16_f32 v132, v153, v155
		v_cvt_pk_bf16_f32 v133, v156, v188
		v_cvt_pk_bf16_f32 v134, v157, v189
		v_cvt_pk_bf16_f32 v135, v190, v192
		v_cvt_pk_bf16_f32 v136, v191, v193
		v_cvt_pk_bf16_f32 v137, v194, v196
		v_cvt_pk_bf16_f32 v138, v195, v197
		v_cvt_pk_bf16_f32 v139, v200, v202
		v_permlane32_swap_b32_e32 v216, v218
		v_permlane32_swap_b32_e32 v217, v219
		v_permlane32_swap_b32_e32 v80, v82
		v_permlane32_swap_b32_e32 v81, v83
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
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[48:63], a[44:47], v[216:219], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[108:111], v[216:219], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[108:111], v[108:111], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[44:47], v[108:111], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[80:83], v[80:83], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[112:115], v[80:83], v[64:79]
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
		v_mfma_f32_32x32x16_bf16 a[64:79], a[128:131], v[128:131], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[96:99], v[128:131], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[100:103], v[100:103], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[132:135], v[100:103], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[132:135], v[132:135], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[100:103], v[132:135], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[104:107], v[104:107], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[136:139], v[104:107], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[136:139], v[136:139], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[104:107], v[136:139], a[48:63]
		s_cmp_lt_i32 s45, s46
		s_mov_b32 s37, s45
		v_mov_b32_e32 v16, v45
		v_mov_b32_e32 v21, v46
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_1
.L_attn_fwd_persistent.loop_exit_1:
		s_mul_i32 s27, s27, 0x80
		v_readfirstlane_b32 s37, v4
		s_nop 1
		v_mov_b32_e32 v26, s37
		s_nop 0
		v_readfirstlane_b32 s38, v26
		s_nop 1
		v_add_u32_e32 v11, s38, v11
		v_add_u32_e32 v11, s22, v11
		v_readfirstlane_b32 s38, v4
		s_nop 1
		v_mov_b32_e32 v26, s38
		s_nop 0
		v_readfirstlane_b32 s39, v26
		s_nop 1
		v_add_u32_e32 v7, s39, v7
		v_add_u32_e32 v7, s22, v7
		v_xor_b32_e32 v26, 1, v18
		v_xor_b32_e32 v43, 2, v18
		v_xor_b32_e32 v45, 3, v18
		v_xor_b32_e32 v46, 8, v18
		v_xor_b32_e32 v47, 9, v18
		v_xor_b32_e32 v80, 10, v18
		v_xor_b32_e32 v81, 11, v18
		v_xor_b32_e32 v82, 16, v18
		v_xor_b32_e32 v83, 17, v18
		v_xor_b32_e32 v84, 18, v18
		v_xor_b32_e32 v85, 19, v18
		v_xor_b32_e32 v86, 24, v18
		v_xor_b32_e32 v87, 25, v18
		v_xor_b32_e32 v88, 26, v18
		v_xor_b32_e32 v89, 27, v18
		v_xor_b32_e32 v90, 32, v18
		v_xor_b32_e32 v91, 33, v18
		v_xor_b32_e32 v92, 34, v18
		v_xor_b32_e32 v93, 35, v18
		v_xor_b32_e32 v94, 40, v18
		v_xor_b32_e32 v95, 41, v18
		v_xor_b32_e32 v96, 42, v18
		v_xor_b32_e32 v97, 43, v18
		v_xor_b32_e32 v98, 48, v18
		v_xor_b32_e32 v99, 49, v18
		v_xor_b32_e32 v100, 50, v18
		v_xor_b32_e32 v101, 51, v18
		v_xor_b32_e32 v102, 56, v18
		v_xor_b32_e32 v103, 57, v18
		v_xor_b32_e32 v104, 58, v18
		v_xor_b32_e32 v105, 59, v18
		v_xor_b32_e32 v106, 64, v18
		v_xor_b32_e32 v107, 0x41, v18
		v_xor_b32_e32 v108, 0x42, v18
		v_xor_b32_e32 v109, 0x43, v18
		v_xor_b32_e32 v110, 0x48, v18
		v_xor_b32_e32 v111, 0x49, v18
		v_xor_b32_e32 v112, 0x4a, v18
		v_xor_b32_e32 v113, 0x4b, v18
		v_xor_b32_e32 v114, 0x50, v18
		v_xor_b32_e32 v115, 0x51, v18
		v_xor_b32_e32 v116, 0x52, v18
		v_xor_b32_e32 v117, 0x53, v18
		v_xor_b32_e32 v118, 0x58, v18
		v_xor_b32_e32 v119, 0x59, v18
		v_xor_b32_e32 v120, 0x5a, v18
		v_xor_b32_e32 v121, 0x5b, v18
		v_xor_b32_e32 v122, 0x60, v18
		v_xor_b32_e32 v123, 0x61, v18
		v_xor_b32_e32 v124, 0x62, v18
		v_xor_b32_e32 v125, 0x63, v18
		v_xor_b32_e32 v126, 0x68, v18
		v_xor_b32_e32 v127, 0x69, v18
		v_xor_b32_e32 v128, 0x6a, v18
		v_xor_b32_e32 v129, 0x6b, v18
		v_xor_b32_e32 v130, 0x70, v18
		v_xor_b32_e32 v131, 0x71, v18
		v_xor_b32_e32 v132, 0x72, v18
		v_xor_b32_e32 v133, 0x73, v18
		v_xor_b32_e32 v134, 0x78, v18
		v_xor_b32_e32 v135, 0x79, v18
		v_xor_b32_e32 v136, 0x7a, v18
		v_xor_b32_e32 v137, 0x7b, v18
		v_lshl_add_u32 v33, v33, 4, v38
		v_add3_u32 v33, v33, v40, v41
		v_add3_u32 v33, v33, v42, v39
		v_add3_u32 v28, v28, v32, v44
		v_lshl_add_u32 v24, v24, 3, v28
		v_mov_b32_e32 v28, 0xff800000
		s_cmp_lt_i32 s46, s27
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_2
.L_attn_fwd_persistent.loop_head_2:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s22, s46, 0x80
		s_cmp_lt_i32 s46, 0
		s_cselect_b32 s39, s36, 0
		s_add_i32 s39, s46, s39
		s_ashr_i32 s39, s39, 7
		s_cmp_lt_i32 s39, 0
		s_cselect_b32 s45, s16, 0
		s_add_i32 s45, s39, s45
		s_ashr_i32 s45, s45, 1
		s_lshl_b32 s45, s45, 1
		s_xor_b32 s45, s45, -1
		s_add_i32 s45, s45, 1
		s_add_i32 s45, s39, s45
		s_add_i32 s39, s39, 1
		s_cmp_lt_i32 s39, 0
		s_cselect_b32 s54, s16, 0
		s_add_i32 s54, s39, s54
		s_ashr_i32 s54, s54, 1
		s_lshl_b32 s54, s54, 1
		s_xor_b32 s54, s54, -1
		s_add_i32 s54, s54, 1
		s_add_i32 s58, s39, s54
		s_mul_i32 s39, 0x4100, s45
		v_add_u32_e32 v32, s39, v33
		ds_read_b128 v[140:143], v32
		ds_read_b128 v[144:147], v32 offset:32
		ds_read_b128 v[148:151], v32 offset:64
		ds_read_b128 v[152:155], v32 offset:96
		ds_read_b128 v[156:159], v32 offset:256
		ds_read_b128 v[160:163], v32 offset:288
		ds_read_b128 v[164:167], v32 offset:320
		ds_read_b128 v[168:171], v32 offset:352
		ds_read_b128 v[172:175], v32 offset:128
		ds_read_b128 v[176:179], v32 offset:160
		ds_read_b128 v[180:183], v32 offset:192
		ds_read_b128 v[184:187], v32 offset:224
		ds_read_b128 v[188:191], v32 offset:384
		ds_read_b128 v[192:195], v32 offset:416
		ds_read_b128 v[196:199], v32 offset:448
		ds_read_b128 v[200:203], v32 offset:480
		s_mul_i32 s39, 0x4400, s45
		v_add_u32_e32 v32, s39, v24
		ds_read_b64_tr_b16 a[44:45], v32 offset:33264
		ds_read_b64_tr_b16 a[46:47], v32 offset:37616
		ds_read_b64_tr_b16 a[80:81], v32 offset:33392
		ds_read_b64_tr_b16 a[82:83], v32 offset:37744
		ds_read_b64_tr_b16 a[84:85], v32 offset:33520
		ds_read_b64_tr_b16 a[86:87], v32 offset:37872
		ds_read_b64_tr_b16 a[88:89], v32 offset:33648
		ds_read_b64_tr_b16 a[90:91], v32 offset:38000
		ds_read_b64_tr_b16 a[92:93], v32 offset:33776
		ds_read_b64_tr_b16 a[94:95], v32 offset:38128
		ds_read_b64_tr_b16 a[96:97], v32 offset:33904
		ds_read_b64_tr_b16 a[98:99], v32 offset:38256
		ds_read_b64_tr_b16 a[100:101], v32 offset:34032
		ds_read_b64_tr_b16 a[102:103], v32 offset:38384
		ds_read_b64_tr_b16 a[104:105], v32 offset:34160
		ds_read_b64_tr_b16 a[106:107], v32 offset:38512
		ds_read_b64_tr_b16 a[108:109], v32 offset:33328
		ds_read_b64_tr_b16 a[110:111], v32 offset:37680
		ds_read_b64_tr_b16 a[112:113], v32 offset:33456
		ds_read_b64_tr_b16 a[114:115], v32 offset:37808
		ds_read_b64_tr_b16 a[116:117], v32 offset:33584
		ds_read_b64_tr_b16 a[118:119], v32 offset:37936
		ds_read_b64_tr_b16 a[120:121], v32 offset:33712
		ds_read_b64_tr_b16 a[122:123], v32 offset:38064
		ds_read_b64_tr_b16 a[124:125], v32 offset:33840
		ds_read_b64_tr_b16 a[126:127], v32 offset:38192
		ds_read_b64_tr_b16 a[128:129], v32 offset:33968
		ds_read_b64_tr_b16 a[130:131], v32 offset:38320
		ds_read_b64_tr_b16 a[132:133], v32 offset:34096
		ds_read_b64_tr_b16 a[134:135], v32 offset:38448
		ds_read_b64_tr_b16 a[136:137], v32 offset:34224
		ds_read_b64_tr_b16 a[138:139], v32 offset:38576
		s_cmp_lt_i32 s22, s26
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_1
		s_waitcnt lgkmcnt(14)
		s_barrier
		v_add_u32_e32 v32, s22, v19
		v_add_u32_e32 v38, s22, v23
		v_add_u32_e32 v39, s22, v25
		v_add_u32_e32 v40, s22, v1
		v_cmp_lt_i32_e64 vcc, v32, s24
		s_mov_b64 s[54:55], vcc
		v_cmp_lt_i32_e64 vcc, v38, s24
		s_mov_b64 s[60:61], vcc
		v_cmp_lt_i32_e64 vcc, v39, s24
		s_mov_b64 s[62:63], vcc
		v_cmp_lt_i32_e64 vcc, v40, s24
		s_mov_b64 s[64:65], vcc
		v_add_u32_e32 v32, s22, v15
		v_add_u32_e32 v38, s22, v29
		v_add_u32_e32 v39, s22, v30
		v_cmp_lt_i32_e64 vcc, v32, s24
		s_mov_b64 s[66:67], vcc
		v_cmp_lt_i32_e64 vcc, v38, s24
		s_mov_b64 s[68:69], vcc
		v_cmp_lt_i32_e64 vcc, v39, s24
		s_mov_b64 s[70:71], vcc
		s_mul_i32 s39, s15, s46
		s_lshl_b32 s39, s39, 1
		s_add_i32 s45, s47, s39
		v_add_u32_e32 v32, s45, v17
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
		s_cmp_lt_i32 s58, 0
		s_cselect_b32 s59, -1, 0
		s_mov_b32 s74, 0x4100
		s_mov_b32 s75, 0
		s_mul_i32 s78, s74, s58
		s_mul_hi_u32 s79, s74, s58
		s_mul_i32 s45, s74, s59
		s_add_i32 s79, s79, s45
		s_mul_i32 s45, s75, s58
		s_add_i32 s79, s79, s45
		s_add_u32 s74, s76, s78
		s_addc_u32 s75, s77, s79
		s_add_u32 s80, s74, 0
		s_addc_u32 s81, s75, 0
		s_mov_b32 m0, s80
		v_cndmask_b32_e64 v32, v27, v32, s[54:55]
		buffer_load_dwordx4 v32, s[28:31], 0 offen lds
		v_add_u32_e32 v32, s22, v10
		s_add_i32 s22, s48, s39
		v_add_u32_e32 v38, s22, v17
		s_add_u32 s54, s76, 0x1040
		s_addc_u32 s55, s77, 0
		s_add_u32 s54, s54, s78
		s_addc_u32 s55, s55, s79
		s_add_u32 s74, s54, 0
		s_addc_u32 s75, s55, 0
		s_mov_b32 m0, s74
		v_cndmask_b32_e64 v38, v27, v38, s[60:61]
		buffer_load_dwordx4 v38, s[28:31], 0 offen lds
		s_add_i32 s22, s49, s39
		v_add_u32_e32 v38, s22, v17
		s_add_u32 s54, s76, 0x2080
		s_addc_u32 s55, s77, 0
		s_add_u32 s54, s54, s78
		s_addc_u32 s55, s55, s79
		s_add_u32 s60, s54, 0
		s_addc_u32 s61, s55, 0
		s_mov_b32 m0, s60
		v_cndmask_b32_e64 v38, v27, v38, s[62:63]
		buffer_load_dwordx4 v38, s[28:31], 0 offen lds
		s_add_i32 s22, s50, s39
		v_add_u32_e32 v38, s22, v17
		s_add_u32 s54, s76, 0x30c0
		s_addc_u32 s55, s77, 0
		s_add_u32 s54, s54, s78
		s_addc_u32 s55, s55, s79
		s_add_u32 s60, s54, 0
		s_addc_u32 s61, s55, 0
		s_mov_b32 m0, s60
		v_cndmask_b32_e64 v38, v27, v38, s[64:65]
		buffer_load_dwordx4 v38, s[28:31], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s22, s21, s46
		s_lshl_b32 s22, s22, 1
		s_add_i32 s39, s51, s22
		v_add_u32_e32 v38, s39, v8
		s_mov_b32 s54, 0x440
		s_mov_b32 s55, 0
		s_mul_i32 s60, s54, s72
		s_mul_hi_u32 s61, s54, s72
		s_mul_i32 s39, s54, s73
		s_add_i32 s61, s61, s39
		s_mul_i32 s39, s55, s72
		s_add_i32 s61, s61, s39
		s_add_u32 s54, s60, 0x81f0
		s_addc_u32 s55, s61, 0
		s_mov_b32 s62, 0x4400
		s_mov_b32 s63, 0
		s_mul_i32 s64, s62, s58
		s_mul_hi_u32 s65, s62, s58
		s_mul_i32 s39, s62, s59
		s_add_i32 s65, s65, s39
		s_mul_i32 s39, s63, s58
		s_add_i32 s65, s65, s39
		s_add_u32 s54, s54, s64
		s_addc_u32 s55, s55, s65
		s_add_u32 s58, s54, 0
		s_addc_u32 s59, s55, 0
		s_mov_b32 m0, s58
		v_cndmask_b32_e64 v38, v27, v38, s[66:67]
		buffer_load_dwordx4 v38, s[32:35], 0 offen lds
		s_add_i32 s39, s52, s22
		v_add_u32_e32 v38, s39, v8
		s_add_u32 s54, s60, 0x92f0
		s_addc_u32 s55, s61, 0
		s_add_u32 s54, s54, s64
		s_addc_u32 s55, s55, s65
		s_add_u32 s58, s54, 0
		s_addc_u32 s59, s55, 0
		s_mov_b32 m0, s58
		v_cndmask_b32_e64 v38, v27, v38, s[68:69]
		buffer_load_dwordx4 v38, s[32:35], 0 offen lds
		s_add_i32 s39, s53, s22
		v_add_u32_e32 v38, s39, v8
		s_add_u32 s54, s60, 0xa3f0
		s_addc_u32 s55, s61, 0
		s_add_u32 s54, s54, s64
		s_addc_u32 s55, s55, s65
		s_add_u32 s58, s54, 0
		s_addc_u32 s59, s55, 0
		s_mov_b32 m0, s58
		v_cndmask_b32_e64 v38, v27, v38, s[70:71]
		buffer_load_dwordx4 v38, s[32:35], 0 offen lds
		s_add_i32 s22, s44, s22
		v_cmp_lt_i32_e64 vcc, v32, s24
		v_add_u32_e32 v32, s22, v8
		s_add_u32 s54, s60, 0xb4f0
		s_addc_u32 s55, s61, 0
		v_cndmask_b32_e32 v32, v27, v32, vcc
		s_add_u32 s54, s54, s64
		s_addc_u32 s55, s55, s65
		s_add_u32 s58, s54, 0
		s_addc_u32 s59, s55, 0
		s_mov_b32 m0, s58
		s_nop 0
		buffer_load_dwordx4 v32, s[32:35], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_1
.L_attn_fwd_persistent.if_else_1:
.L_attn_fwd_persistent.if_end_1:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[208:223], v[140:143], a[8:11], 0
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
		v_mfma_f32_32x32x16_bf16 v[208:223], v[156:159], a[8:11], 0
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
		v_mfma_f32_32x32x16_bf16 v[208:223], v[172:175], a[8:11], 0
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
		v_mfma_f32_32x32x16_bf16 v[208:223], v[188:191], a[8:11], 0
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
		v_mfma_f32_32x32x16_bf16 v[208:223], v[188:191], a[24:27], 0
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
		v_mfma_f32_32x32x16_bf16 v[208:223], v[140:143], a[24:27], 0
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
		v_mfma_f32_32x32x16_bf16 v[208:223], v[156:159], a[24:27], 0
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
		v_mfma_f32_32x32x16_bf16 v[208:223], v[172:175], a[24:27], 0
		v_mfma_f32_32x32x16_bf16 a[144:159], v[144:147], a[12:15], a[144:159]
		v_mfma_f32_32x32x16_bf16 a[160:175], v[160:163], a[12:15], a[160:175]
		v_mfma_f32_32x32x16_bf16 a[176:191], v[176:179], a[12:15], a[176:191]
		v_mfma_f32_32x32x16_bf16 a[192:207], v[192:195], a[12:15], a[192:207]
		v_mfma_f32_32x32x16_bf16 a[208:223], v[192:195], a[28:31], a[208:223]
		v_mfma_f32_32x32x16_bf16 a[224:239], v[144:147], a[28:31], a[224:239]
		v_mfma_f32_32x32x16_bf16 a[240:255], v[160:163], a[28:31], a[240:255]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[176:179], a[28:31], v[208:223]
		v_mfma_f32_32x32x16_bf16 a[144:159], v[148:151], a[16:19], a[144:159]
		v_mfma_f32_32x32x16_bf16 a[160:175], v[164:167], a[16:19], a[160:175]
		v_mfma_f32_32x32x16_bf16 a[176:191], v[180:183], a[16:19], a[176:191]
		v_mfma_f32_32x32x16_bf16 a[192:207], v[196:199], a[16:19], a[192:207]
		v_mfma_f32_32x32x16_bf16 a[208:223], v[196:199], a[32:35], a[208:223]
		v_mfma_f32_32x32x16_bf16 a[224:239], v[148:151], a[32:35], a[224:239]
		v_mfma_f32_32x32x16_bf16 a[240:255], v[164:167], a[32:35], a[240:255]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[180:183], a[32:35], v[208:223]
		v_mfma_f32_32x32x16_bf16 a[144:159], v[152:155], a[20:23], a[144:159]
		v_mfma_f32_32x32x16_bf16 a[160:175], v[168:171], a[20:23], a[160:175]
		v_mfma_f32_32x32x16_bf16 a[176:191], v[184:187], a[20:23], a[176:191]
		v_mfma_f32_32x32x16_bf16 a[192:207], v[200:203], a[20:23], a[192:207]
		v_mfma_f32_32x32x16_bf16 a[208:223], v[200:203], a[36:39], a[208:223]
		v_mfma_f32_32x32x16_bf16 a[224:239], v[152:155], a[36:39], a[224:239]
		v_mfma_f32_32x32x16_bf16 a[240:255], v[168:171], a[36:39], a[240:255]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[184:187], a[36:39], v[208:223]
		v_add_u32_e32 v32, s46, v18
		v_add_u32_e32 v38, s46, v26
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
		v_cmp_ge_i32_e64 vcc, v11, v32
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v11, v38
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v11, v39
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v11, v40
		v_add_u32_e32 v32, s46, v46
		v_add_u32_e32 v38, s46, v47
		v_accvgpr_read_b32 v39, a147
		v_cndmask_b32_e32 v167, v28, v39, vcc
		v_cmp_ge_i32_e64 vcc, v11, v32
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v11, v38
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v11, v41
		s_mov_b64 s[66:67], vcc
		v_cmp_ge_i32_e64 vcc, v11, v42
		v_add_u32_e32 v39, s46, v82
		v_add_u32_e32 v40, s46, v83
		v_accvgpr_read_b32 v41, a151
		v_cndmask_b32_e32 v169, v28, v41, vcc
		v_cmp_ge_i32_e64 vcc, v11, v39
		s_mov_b64 s[68:69], vcc
		v_cmp_ge_i32_e64 vcc, v11, v40
		s_mov_b64 s[70:71], vcc
		v_cmp_ge_i32_e64 vcc, v11, v44
		s_mov_b64 s[72:73], vcc
		v_cmp_ge_i32_e64 vcc, v11, v138
		v_add_u32_e32 v41, s46, v86
		v_add_u32_e32 v42, s46, v87
		v_accvgpr_read_b32 v44, a155
		v_cndmask_b32_e32 v171, v28, v44, vcc
		v_cmp_ge_i32_e64 vcc, v11, v41
		s_mov_b64 s[74:75], vcc
		v_cmp_ge_i32_e64 vcc, v11, v42
		s_mov_b64 s[76:77], vcc
		v_cmp_ge_i32_e64 vcc, v11, v139
		s_mov_b64 s[78:79], vcc
		v_cmp_ge_i32_e64 vcc, v11, v140
		v_add_u32_e32 v44, s46, v90
		v_add_u32_e32 v138, s46, v91
		v_accvgpr_read_b32 v139, a159
		v_cndmask_b32_e32 v173, v28, v139, vcc
		v_cmp_ge_i32_e64 vcc, v11, v44
		s_mov_b64 s[80:81], vcc
		v_cmp_ge_i32_e64 vcc, v11, v138
		s_mov_b64 s[82:83], vcc
		v_cmp_ge_i32_e64 vcc, v11, v141
		s_mov_b64 s[84:85], vcc
		v_cmp_ge_i32_e64 vcc, v11, v142
		v_add_u32_e32 v139, s46, v94
		v_add_u32_e32 v140, s46, v95
		v_accvgpr_read_b32 v141, a163
		v_cndmask_b32_e32 v175, v28, v141, vcc
		v_cmp_ge_i32_e64 vcc, v11, v139
		s_mov_b64 s[86:87], vcc
		v_cmp_ge_i32_e64 vcc, v11, v140
		s_mov_b64 s[88:89], vcc
		v_cmp_ge_i32_e64 vcc, v11, v143
		s_mov_b64 s[90:91], vcc
		v_cmp_ge_i32_e64 vcc, v11, v144
		s_mov_b64 s[92:93], vcc
		v_mov_b32_e32 v142, s92
		v_mov_b32_e32 v143, s93
		v_add_u32_e32 v141, s46, v98
		v_add_u32_e32 v142, s46, v99
		v_accvgpr_read_b32 v143, a167
		v_cndmask_b32_e32 v177, v28, v143, vcc
		v_cmp_ge_i32_e64 vcc, v11, v141
		s_mov_b64 s[92:93], vcc
		v_cmp_ge_i32_e64 vcc, v11, v142
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v178, s94
		v_mov_b32_e32 v179, s95
		v_cmp_ge_i32_e64 vcc, v11, v145
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v144, s94
		v_mov_b32_e32 v145, s95
		v_cmp_ge_i32_e64 vcc, v11, v146
		v_add_u32_e32 v143, s46, v102
		v_add_u32_e32 v146, s46, v103
		v_accvgpr_read_b32 v165, a171
		v_cndmask_b32_e32 v181, v28, v165, vcc
		v_cmp_ge_i32_e64 vcc, v11, v143
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v182, s94
		v_mov_b32_e32 v183, s95
		v_cmp_ge_i32_e64 vcc, v11, v146
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v184, s94
		v_mov_b32_e32 v185, s95
		v_cmp_ge_i32_e64 vcc, v11, v147
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v186, s94
		v_mov_b32_e32 v187, s95
		v_cmp_ge_i32_e64 vcc, v11, v148
		v_add_u32_e32 v147, s46, v106
		v_add_u32_e32 v148, s46, v107
		v_accvgpr_read_b32 v165, a175
		v_cndmask_b32_e32 v189, v28, v165, vcc
		v_cmp_ge_i32_e64 vcc, v11, v147
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v190, s94
		v_mov_b32_e32 v191, s95
		v_cmp_ge_i32_e64 vcc, v11, v148
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v192, s94
		v_mov_b32_e32 v193, s95
		v_accvgpr_write_b32 a140, v192
		v_accvgpr_write_b32 a141, v193
		v_cmp_ge_i32_e64 vcc, v11, v149
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v192, s94
		v_mov_b32_e32 v193, s95
		v_accvgpr_write_b32 a142, v192
		v_accvgpr_write_b32 a143, v193
		v_cmp_ge_i32_e64 vcc, v11, v150
		v_add_u32_e32 v149, s46, v110
		v_add_u32_e32 v150, s46, v111
		v_accvgpr_read_b32 v165, a179
		v_cndmask_b32_e32 v193, v28, v165, vcc
		v_cmp_ge_i32_e64 vcc, v11, v149
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v194, s94
		v_mov_b32_e32 v195, s95
		v_cmp_ge_i32_e64 vcc, v11, v150
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v196, s94
		v_mov_b32_e32 v197, s95
		v_cmp_ge_i32_e64 vcc, v11, v151
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v198, s94
		v_mov_b32_e32 v199, s95
		v_cmp_ge_i32_e64 vcc, v11, v152
		v_add_u32_e32 v151, s46, v114
		v_add_u32_e32 v152, s46, v115
		v_accvgpr_read_b32 v165, a183
		v_cndmask_b32_e32 v201, v28, v165, vcc
		v_cmp_ge_i32_e64 vcc, v11, v151
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v202, s94
		v_mov_b32_e32 v203, s95
		v_cmp_ge_i32_e64 vcc, v11, v152
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v204, s94
		v_mov_b32_e32 v205, s95
		v_cmp_ge_i32_e64 vcc, v11, v153
		s_mov_b64 s[94:95], vcc
		v_mov_b32_e32 v206, s94
		v_mov_b32_e32 v207, s95
		v_cmp_ge_i32_e64 vcc, v11, v154
		v_add_u32_e32 v153, s46, v118
		v_add_u32_e32 v165, s46, v119
		v_accvgpr_read_b32 v166, a187
		v_cndmask_b32_e32 v225, v28, v166, vcc
		v_cmp_ge_i32_e64 vcc, v11, v153
		s_mov_b64 s[94:95], vcc
		v_cmp_ge_i32_e64 vcc, v11, v165
		s_mov_b64 s[96:97], vcc
		v_cmp_ge_i32_e64 vcc, v11, v155
		s_mov_b64 s[98:99], vcc
		v_accvgpr_read_b32 v166, a189
		v_cndmask_b32_e64 v227, v28, v166, s[96:97]
		v_accvgpr_read_b32 v166, a190
		v_cndmask_b32_e64 v228, v28, v166, s[98:99]
		v_cmp_ge_i32_e64 vcc, v11, v156
		v_add_u32_e32 v192, s46, v122
		v_add_u32_e32 v200, s46, v123
		v_accvgpr_read_b32 v166, a191
		v_cndmask_b32_e32 v229, v28, v166, vcc
		v_cmp_ge_i32_e64 vcc, v11, v192
		s_mov_b64 s[96:97], vcc
		v_cmp_ge_i32_e64 vcc, v11, v200
		s_mov_b64 s[98:99], vcc
		v_cmp_ge_i32_e64 vcc, v11, v157
		s_mov_b64 s[100:101], vcc
		v_accvgpr_read_b32 v166, a192
		v_mov_b32_e32 v230, 0xff800000
		v_cndmask_b32_e64 v232, v230, v166, s[96:97]
		v_accvgpr_read_b32 v166, a193
		v_cndmask_b32_e64 v233, v230, v166, s[98:99]
		v_accvgpr_read_b32 v166, a194
		v_cndmask_b32_e64 v234, v230, v166, s[100:101]
		v_cmp_ge_i32_e64 vcc, v11, v158
		v_add_u32_e32 v224, s46, v126
		v_add_u32_e32 v226, s46, v127
		v_accvgpr_read_b32 v166, a195
		v_cndmask_b32_e32 v235, v230, v166, vcc
		v_cmp_ge_i32_e64 vcc, v11, v224
		s_mov_b64 s[96:97], vcc
		v_cmp_ge_i32_e64 vcc, v11, v226
		s_mov_b64 s[98:99], vcc
		v_cmp_ge_i32_e64 vcc, v11, v159
		s_mov_b64 s[100:101], vcc
		v_accvgpr_read_b32 v166, a196
		v_cndmask_b32_e64 v236, v230, v166, s[96:97]
		v_accvgpr_read_b32 v166, a197
		v_cndmask_b32_e64 v237, v230, v166, s[98:99]
		v_accvgpr_read_b32 v166, a198
		v_cndmask_b32_e64 v238, v230, v166, s[100:101]
		v_cmp_ge_i32_e64 vcc, v11, v160
		v_add_u32_e32 v231, s46, v130
		v_add_u32_e32 v240, s46, v131
		v_accvgpr_read_b32 v166, a199
		v_cndmask_b32_e32 v239, v230, v166, vcc
		v_cmp_ge_i32_e64 vcc, v11, v231
		s_mov_b64 s[96:97], vcc
		v_cmp_ge_i32_e64 vcc, v11, v240
		s_mov_b64 s[98:99], vcc
		v_cmp_ge_i32_e64 vcc, v11, v161
		s_mov_b64 s[100:101], vcc
		v_accvgpr_read_b32 v166, a200
		v_cndmask_b32_e64 v242, v230, v166, s[96:97]
		v_accvgpr_read_b32 v166, a201
		v_cndmask_b32_e64 v243, v230, v166, s[98:99]
		v_accvgpr_read_b32 v166, a202
		v_cndmask_b32_e64 v244, v230, v166, s[100:101]
		v_cmp_ge_i32_e64 vcc, v11, v162
		v_add_u32_e32 v241, s46, v134
		v_add_u32_e32 v246, s46, v135
		v_accvgpr_read_b32 v166, a203
		v_cndmask_b32_e32 v245, v230, v166, vcc
		v_cmp_ge_i32_e64 vcc, v11, v241
		s_mov_b64 s[96:97], vcc
		v_cmp_ge_i32_e64 vcc, v11, v246
		s_mov_b64 s[98:99], vcc
		v_cmp_ge_i32_e64 vcc, v11, v163
		s_mov_b64 s[100:101], vcc
		v_accvgpr_read_b32 v166, a204
		v_cndmask_b32_e64 v248, v230, v166, s[96:97]
		v_accvgpr_read_b32 v166, a205
		v_cndmask_b32_e64 v249, v230, v166, s[98:99]
		v_accvgpr_read_b32 v166, a206
		v_cndmask_b32_e64 v250, v230, v166, s[100:101]
		v_cmp_ge_i32_e64 vcc, v11, v164
		v_accvgpr_read_b32 v166, a144
		v_cndmask_b32_e64 v252, v230, v166, s[54:55]
		v_accvgpr_read_b32 v166, a145
		v_cndmask_b32_e64 v253, v230, v166, s[58:59]
		v_accvgpr_read_b32 v166, a207
		v_cndmask_b32_e32 v251, v230, v166, vcc
		v_lshrrev_b32_e32 v166, 5, v0
		v_and_b32_e32 v166, 1, v166
		v_mov_b32_e32 v168, 4
		v_mul_lo_u32 v168, v168, v166
		v_add_u32_e32 v166, s46, v168
		v_cmp_ge_i32_e64 vcc, v7, v166
		s_mov_b64 s[54:55], vcc
		v_lshrrev_b32_e32 v166, 5, v0
		v_and_b32_e32 v166, 1, v166
		v_mov_b32_e32 v168, 4
		v_mul_lo_u32 v168, v168, v166
		v_xor_b32_e32 v166, 1, v168
		v_add_u32_e32 v166, s46, v166
		v_cmp_ge_i32_e64 vcc, v7, v166
		s_mov_b64 s[58:59], vcc
		v_lshrrev_b32_e32 v166, 5, v0
		v_and_b32_e32 v166, 1, v166
		v_mov_b32_e32 v168, 4
		v_mul_lo_u32 v168, v168, v166
		v_xor_b32_e32 v166, 2, v168
		v_add_u32_e32 v166, s46, v166
		v_cmp_ge_i32_e64 vcc, v7, v166
		s_mov_b64 s[96:97], vcc
		v_accvgpr_read_b32 v166, a224
		v_cndmask_b32_e64 v166, v230, v166, s[54:55]
		v_accvgpr_write_b32 a144, v166
		v_accvgpr_read_b32 v166, a225
		v_cndmask_b32_e64 v166, v230, v166, s[58:59]
		v_accvgpr_write_b32 a145, v166
		v_accvgpr_read_b32 v166, a226
		v_cndmask_b32_e64 v166, v230, v166, s[96:97]
		v_accvgpr_write_b32 a190, v166
		v_lshrrev_b32_e32 v166, 5, v0
		v_and_b32_e32 v166, 1, v166
		v_mov_b32_e32 v168, 4
		v_mul_lo_u32 v168, v168, v166
		v_xor_b32_e32 v166, 3, v168
		v_add_u32_e32 v166, s46, v166
		v_cmp_ge_i32_e64 vcc, v7, v166
		v_accvgpr_read_b32 v166, a146
		v_cndmask_b32_e64 v166, v230, v166, s[60:61]
		v_accvgpr_read_b32 v168, a148
		v_cndmask_b32_e64 v168, v230, v168, s[62:63]
		v_accvgpr_write_b32 a146, v168
		v_accvgpr_read_b32 v168, a227
		v_cndmask_b32_e32 v168, v230, v168, vcc
		v_accvgpr_write_b32 a191, v168
		v_cmp_ge_i32_e64 vcc, v7, v32
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v7, v38
		s_mov_b64 s[58:59], vcc
		v_lshrrev_b32_e32 v32, 5, v0
		v_and_b32_e32 v32, 1, v32
		v_mov_b32_e32 v38, 4
		v_mul_lo_u32 v38, v38, v32
		v_xor_b32_e32 v32, 10, v38
		v_add_u32_e32 v32, s46, v32
		v_cmp_ge_i32_e64 vcc, v7, v32
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v32, a228
		v_cndmask_b32_e64 v32, v230, v32, s[54:55]
		v_accvgpr_write_b32 a192, v32
		v_accvgpr_read_b32 v32, a229
		v_cndmask_b32_e64 v32, v230, v32, s[58:59]
		v_accvgpr_write_b32 a193, v32
		v_accvgpr_read_b32 v32, a230
		v_cndmask_b32_e64 v32, v230, v32, s[60:61]
		v_accvgpr_write_b32 a194, v32
		v_lshrrev_b32_e32 v32, 5, v0
		v_and_b32_e32 v32, 1, v32
		v_mov_b32_e32 v38, 4
		v_mul_lo_u32 v38, v38, v32
		v_xor_b32_e32 v32, 11, v38
		v_add_u32_e32 v32, s46, v32
		v_cmp_ge_i32_e64 vcc, v7, v32
		v_accvgpr_read_b32 v32, a149
		v_cndmask_b32_e64 v32, v230, v32, s[64:65]
		v_accvgpr_write_b32 a147, v32
		v_accvgpr_read_b32 v32, a150
		v_cndmask_b32_e64 v168, v230, v32, s[66:67]
		v_accvgpr_read_b32 v32, a231
		v_cndmask_b32_e32 v32, v230, v32, vcc
		v_accvgpr_write_b32 a195, v32
		v_cmp_ge_i32_e64 vcc, v7, v39
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v7, v40
		s_mov_b64 s[58:59], vcc
		v_lshrrev_b32_e32 v32, 5, v0
		v_and_b32_e32 v32, 1, v32
		v_mov_b32_e32 v38, 4
		v_mul_lo_u32 v38, v38, v32
		v_xor_b32_e32 v32, 18, v38
		v_add_u32_e32 v32, s46, v32
		v_cmp_ge_i32_e64 vcc, v7, v32
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v32, a232
		v_cndmask_b32_e64 v32, v230, v32, s[54:55]
		v_accvgpr_write_b32 a148, v32
		v_accvgpr_read_b32 v32, a233
		v_cndmask_b32_e64 v32, v230, v32, s[58:59]
		v_accvgpr_write_b32 a149, v32
		v_accvgpr_read_b32 v32, a234
		v_cndmask_b32_e64 v32, v230, v32, s[60:61]
		v_accvgpr_write_b32 a150, v32
		v_lshrrev_b32_e32 v32, 5, v0
		v_and_b32_e32 v32, 1, v32
		v_mov_b32_e32 v38, 4
		v_mul_lo_u32 v38, v38, v32
		v_xor_b32_e32 v32, 19, v38
		v_add_u32_e32 v32, s46, v32
		v_cmp_ge_i32_e64 vcc, v7, v32
		v_accvgpr_read_b32 v32, a152
		v_cndmask_b32_e64 v38, v230, v32, s[68:69]
		v_accvgpr_read_b32 v32, a153
		v_cndmask_b32_e64 v39, v230, v32, s[70:71]
		v_accvgpr_read_b32 v32, a235
		v_cndmask_b32_e32 v32, v230, v32, vcc
		v_accvgpr_write_b32 a151, v32
		v_cmp_ge_i32_e64 vcc, v7, v41
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v7, v42
		s_mov_b64 s[58:59], vcc
		v_lshrrev_b32_e32 v32, 5, v0
		v_and_b32_e32 v32, 1, v32
		v_mov_b32_e32 v40, 4
		v_mul_lo_u32 v40, v40, v32
		v_xor_b32_e32 v32, 26, v40
		v_add_u32_e32 v32, s46, v32
		v_cmp_ge_i32_e64 vcc, v7, v32
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v32, a236
		v_cndmask_b32_e64 v32, v230, v32, s[54:55]
		v_accvgpr_write_b32 a152, v32
		v_accvgpr_read_b32 v32, a237
		v_cndmask_b32_e64 v32, v230, v32, s[58:59]
		v_accvgpr_write_b32 a153, v32
		v_accvgpr_read_b32 v32, a238
		v_cndmask_b32_e64 v40, v230, v32, s[60:61]
		v_lshrrev_b32_e32 v32, 5, v0
		v_and_b32_e32 v32, 1, v32
		v_mov_b32_e32 v41, 4
		v_mul_lo_u32 v41, v41, v32
		v_xor_b32_e32 v32, 27, v41
		v_add_u32_e32 v32, s46, v32
		v_cmp_ge_i32_e64 vcc, v7, v32
		v_accvgpr_read_b32 v32, a154
		v_cndmask_b32_e64 v170, v230, v32, s[72:73]
		v_accvgpr_read_b32 v32, a156
		v_cndmask_b32_e64 v254, v230, v32, s[74:75]
		v_accvgpr_read_b32 v32, a239
		v_cndmask_b32_e32 v41, v230, v32, vcc
		v_cmp_ge_i32_e64 vcc, v7, v44
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v7, v138
		s_mov_b64 s[58:59], vcc
		v_lshrrev_b32_e32 v32, 5, v0
		v_and_b32_e32 v32, 1, v32
		v_mov_b32_e32 v42, 4
		v_mul_lo_u32 v42, v42, v32
		v_xor_b32_e32 v32, 34, v42
		v_add_u32_e32 v32, s46, v32
		v_cmp_ge_i32_e64 vcc, v7, v32
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v32, a240
		v_cndmask_b32_e64 v32, v230, v32, s[54:55]
		v_accvgpr_write_b32 a154, v32
		v_accvgpr_read_b32 v32, a241
		v_cndmask_b32_e64 v32, v230, v32, s[58:59]
		v_accvgpr_write_b32 a155, v32
		v_accvgpr_read_b32 v32, a242
		v_cndmask_b32_e64 v32, v230, v32, s[60:61]
		v_accvgpr_write_b32 a196, v32
		v_lshrrev_b32_e32 v32, 5, v0
		v_and_b32_e32 v32, 1, v32
		v_mov_b32_e32 v42, 4
		v_mul_lo_u32 v42, v42, v32
		v_xor_b32_e32 v32, 35, v42
		v_add_u32_e32 v32, s46, v32
		v_cmp_ge_i32_e64 vcc, v7, v32
		v_accvgpr_read_b32 v32, a157
		v_cndmask_b32_e64 v255, v230, v32, s[76:77]
		v_accvgpr_read_b32 v32, a158
		v_cndmask_b32_e64 v172, v230, v32, s[78:79]
		v_accvgpr_read_b32 v32, a243
		v_cndmask_b32_e32 v32, v230, v32, vcc
		v_accvgpr_write_b32 a197, v32
		v_cmp_ge_i32_e64 vcc, v7, v139
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v7, v140
		s_mov_b64 s[58:59], vcc
		v_lshrrev_b32_e32 v32, 5, v0
		v_and_b32_e32 v32, 1, v32
		v_mov_b32_e32 v42, 4
		v_mul_lo_u32 v42, v42, v32
		v_xor_b32_e32 v32, 42, v42
		v_add_u32_e32 v32, s46, v32
		v_cmp_ge_i32_e64 vcc, v7, v32
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v32, a244
		v_cndmask_b32_e64 v32, v230, v32, s[54:55]
		v_accvgpr_write_b32 a156, v32
		v_accvgpr_read_b32 v32, a245
		v_cndmask_b32_e64 v32, v230, v32, s[58:59]
		v_accvgpr_write_b32 a157, v32
		v_accvgpr_read_b32 v32, a246
		v_cndmask_b32_e64 v32, v230, v32, s[60:61]
		v_accvgpr_write_b32 a158, v32
		v_lshrrev_b32_e32 v32, 5, v0
		v_and_b32_e32 v32, 1, v32
		v_mov_b32_e32 v42, 4
		v_mul_lo_u32 v42, v42, v32
		v_xor_b32_e32 v32, 43, v42
		v_add_u32_e32 v32, s46, v32
		v_cmp_ge_i32_e64 vcc, v7, v32
		v_accvgpr_read_b32 v32, a160
		v_cndmask_b32_e64 v32, v230, v32, s[80:81]
		v_accvgpr_write_b32 a198, v32
		v_accvgpr_read_b32 v32, a161
		v_cndmask_b32_e64 v32, v230, v32, s[82:83]
		v_accvgpr_write_b32 a199, v32
		v_accvgpr_read_b32 v32, a247
		v_cndmask_b32_e32 v32, v230, v32, vcc
		v_accvgpr_write_b32 a159, v32
		v_cmp_ge_i32_e64 vcc, v7, v141
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v7, v142
		s_mov_b64 s[58:59], vcc
		v_lshrrev_b32_e32 v32, 5, v0
		v_and_b32_e32 v32, 1, v32
		v_mov_b32_e32 v42, 4
		v_mul_lo_u32 v42, v42, v32
		v_xor_b32_e32 v32, 50, v42
		v_add_u32_e32 v32, s46, v32
		v_cmp_ge_i32_e64 vcc, v7, v32
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v32, a248
		v_cndmask_b32_e64 v32, v230, v32, s[54:55]
		v_accvgpr_write_b32 a160, v32
		v_accvgpr_read_b32 v32, a249
		v_cndmask_b32_e64 v32, v230, v32, s[58:59]
		v_accvgpr_write_b32 a161, v32
		v_accvgpr_read_b32 v32, a250
		v_cndmask_b32_e64 v32, v230, v32, s[60:61]
		v_accvgpr_write_b32 a200, v32
		v_lshrrev_b32_e32 v32, 5, v0
		v_and_b32_e32 v32, 1, v32
		v_mov_b32_e32 v42, 4
		v_mul_lo_u32 v42, v42, v32
		v_xor_b32_e32 v32, 51, v42
		v_add_u32_e32 v32, s46, v32
		v_cmp_ge_i32_e64 vcc, v7, v32
		v_accvgpr_read_b32 v32, a162
		v_cndmask_b32_e64 v174, v230, v32, s[84:85]
		v_accvgpr_read_b32 v32, a164
		v_cndmask_b32_e64 v138, v230, v32, s[86:87]
		v_accvgpr_read_b32 v32, a251
		v_cndmask_b32_e32 v32, v230, v32, vcc
		v_accvgpr_write_b32 a201, v32
		v_cmp_ge_i32_e64 vcc, v7, v143
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v7, v146
		s_mov_b64 s[58:59], vcc
		v_lshrrev_b32_e32 v32, 5, v0
		v_and_b32_e32 v32, 1, v32
		v_mov_b32_e32 v42, 4
		v_mul_lo_u32 v42, v42, v32
		v_xor_b32_e32 v32, 58, v42
		v_add_u32_e32 v32, s46, v32
		v_cmp_ge_i32_e64 vcc, v7, v32
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v32, a252
		v_cndmask_b32_e64 v32, v230, v32, s[54:55]
		v_accvgpr_write_b32 a162, v32
		v_accvgpr_read_b32 v32, a253
		v_cndmask_b32_e64 v32, v230, v32, s[58:59]
		v_accvgpr_write_b32 a163, v32
		v_accvgpr_read_b32 v32, a254
		v_cndmask_b32_e64 v140, v230, v32, s[60:61]
		v_lshrrev_b32_e32 v32, 5, v0
		v_and_b32_e32 v32, 1, v32
		v_mov_b32_e32 v42, 4
		v_mul_lo_u32 v42, v42, v32
		v_xor_b32_e32 v32, 59, v42
		v_add_u32_e32 v32, s46, v32
		v_cmp_ge_i32_e64 vcc, v7, v32
		v_accvgpr_read_b32 v32, a165
		v_mov_b32_e32 v142, s88
		v_mov_b32_e32 v143, s89
		s_nop 0
		v_readfirstlane_b32 s54, v142
		v_readfirstlane_b32 s55, v143
		s_nop 1
		v_cndmask_b32_e64 v139, v230, v32, s[54:55]
		v_accvgpr_read_b32 v32, a166
		v_mov_b32_e32 v142, s90
		v_mov_b32_e32 v143, s91
		s_nop 0
		v_readfirstlane_b32 s54, v142
		v_readfirstlane_b32 s55, v143
		s_nop 1
		v_cndmask_b32_e64 v176, v230, v32, s[54:55]
		v_accvgpr_read_b32 v32, a255
		v_cndmask_b32_e32 v141, v230, v32, vcc
		v_cmp_ge_i32_e64 vcc, v7, v147
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v7, v148
		s_mov_b64 s[58:59], vcc
		v_lshrrev_b32_e32 v32, 5, v0
		v_and_b32_e32 v32, 1, v32
		v_mov_b32_e32 v42, 4
		v_mul_lo_u32 v42, v42, v32
		v_xor_b32_e32 v32, 0x42, v42
		v_add_u32_e32 v32, s46, v32
		v_cmp_ge_i32_e64 vcc, v7, v32
		s_mov_b64 s[60:61], vcc
		v_cndmask_b32_e64 v32, v230, v208, s[54:55]
		v_accvgpr_write_b32 a164, v32
		v_cndmask_b32_e64 v32, v230, v209, s[58:59]
		v_accvgpr_write_b32 a165, v32
		v_cndmask_b32_e64 v142, v230, v210, s[60:61]
		v_lshrrev_b32_e32 v32, 5, v0
		v_and_b32_e32 v32, 1, v32
		v_mov_b32_e32 v42, 4
		v_mul_lo_u32 v42, v42, v32
		v_xor_b32_e32 v32, 0x43, v42
		v_add_u32_e32 v32, s46, v32
		v_cmp_ge_i32_e64 vcc, v7, v32
		v_accvgpr_read_b32 v32, a168
		v_mov_b32_e32 v146, s92
		v_mov_b32_e32 v147, s93
		s_nop 0
		v_readfirstlane_b32 s54, v146
		v_readfirstlane_b32 s55, v147
		s_nop 1
		v_cndmask_b32_e64 v146, v230, v32, s[54:55]
		v_accvgpr_read_b32 v32, a169
		v_readfirstlane_b32 s54, v178
		v_readfirstlane_b32 s55, v179
		s_nop 1
		v_cndmask_b32_e64 v147, v230, v32, s[54:55]
		v_cndmask_b32_e32 v143, v230, v211, vcc
		v_cmp_ge_i32_e64 vcc, v7, v149
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v7, v150
		s_mov_b64 s[58:59], vcc
		v_lshrrev_b32_e32 v32, 5, v0
		v_and_b32_e32 v32, 1, v32
		v_mov_b32_e32 v42, 4
		v_mul_lo_u32 v42, v42, v32
		v_xor_b32_e32 v32, 0x4a, v42
		v_add_u32_e32 v32, s46, v32
		v_cmp_ge_i32_e64 vcc, v7, v32
		s_mov_b64 s[60:61], vcc
		v_cndmask_b32_e64 v148, v230, v212, s[54:55]
		v_cndmask_b32_e64 v149, v230, v213, s[58:59]
		v_cndmask_b32_e64 v178, v230, v214, s[60:61]
		v_lshrrev_b32_e32 v32, 5, v0
		v_and_b32_e32 v32, 1, v32
		v_mov_b32_e32 v42, 4
		v_mul_lo_u32 v42, v42, v32
		v_xor_b32_e32 v32, 0x4b, v42
		v_add_u32_e32 v32, s46, v32
		v_cmp_ge_i32_e64 vcc, v7, v32
		v_accvgpr_read_b32 v32, a170
		v_readfirstlane_b32 s54, v144
		v_readfirstlane_b32 s55, v145
		s_nop 1
		v_cndmask_b32_e64 v180, v230, v32, s[54:55]
		v_accvgpr_read_b32 v32, a172
		v_readfirstlane_b32 s54, v182
		v_readfirstlane_b32 s55, v183
		s_nop 1
		v_cndmask_b32_e64 v144, v230, v32, s[54:55]
		v_cndmask_b32_e32 v179, v230, v215, vcc
		v_cmp_ge_i32_e64 vcc, v7, v151
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v7, v152
		s_mov_b64 s[58:59], vcc
		v_lshrrev_b32_e32 v32, 5, v0
		v_and_b32_e32 v32, 1, v32
		v_mov_b32_e32 v42, 4
		v_mul_lo_u32 v42, v42, v32
		v_xor_b32_e32 v32, 0x52, v42
		v_add_u32_e32 v32, s46, v32
		v_cmp_ge_i32_e64 vcc, v7, v32
		s_mov_b64 s[60:61], vcc
		v_cndmask_b32_e64 v150, v230, v216, s[54:55]
		v_cndmask_b32_e64 v151, v230, v217, s[58:59]
		v_cndmask_b32_e64 v182, v230, v218, s[60:61]
		v_cmp_ge_i32_e64 vcc, v7, v154
		v_accvgpr_read_b32 v32, a173
		v_readfirstlane_b32 s54, v184
		v_readfirstlane_b32 s55, v185
		s_nop 1
		v_cndmask_b32_e64 v145, v230, v32, s[54:55]
		v_accvgpr_read_b32 v32, a174
		v_readfirstlane_b32 s54, v186
		v_readfirstlane_b32 s55, v187
		s_nop 1
		v_cndmask_b32_e64 v188, v230, v32, s[54:55]
		v_cndmask_b32_e32 v183, v230, v219, vcc
		v_cmp_ge_i32_e64 vcc, v7, v153
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v7, v165
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v7, v155
		s_mov_b64 s[60:61], vcc
		v_cndmask_b32_e64 v152, v230, v220, s[54:55]
		v_cndmask_b32_e64 v153, v230, v221, s[58:59]
		v_cndmask_b32_e64 v154, v230, v222, s[60:61]
		v_cmp_ge_i32_e64 vcc, v7, v156
		v_accvgpr_read_b32 v32, a176
		v_readfirstlane_b32 s54, v190
		v_readfirstlane_b32 s55, v191
		s_nop 1
		v_cndmask_b32_e64 v184, v230, v32, s[54:55]
		v_accvgpr_read_b32 v32, a177
		v_accvgpr_read_b32 v42, a140
		s_nop 0
		v_readfirstlane_b32 s54, v42
		v_accvgpr_read_b32 v42, a141
		s_nop 0
		v_readfirstlane_b32 s55, v42
		s_nop 1
		v_cndmask_b32_e64 v185, v230, v32, s[54:55]
		v_cndmask_b32_e32 v155, v230, v223, vcc
		v_cmp_ge_i32_e64 vcc, v7, v192
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v7, v200
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v7, v157
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v32, a208
		v_cndmask_b32_e64 v156, v230, v32, s[54:55]
		v_accvgpr_read_b32 v32, a209
		v_cndmask_b32_e64 v157, v230, v32, s[58:59]
		v_accvgpr_read_b32 v32, a210
		v_cndmask_b32_e64 v186, v230, v32, s[60:61]
		v_cmp_ge_i32_e64 vcc, v7, v158
		v_accvgpr_read_b32 v32, a178
		v_accvgpr_read_b32 v42, a142
		s_nop 0
		v_readfirstlane_b32 s54, v42
		v_accvgpr_read_b32 v42, a143
		s_nop 0
		v_readfirstlane_b32 s55, v42
		s_nop 1
		v_cndmask_b32_e64 v192, v230, v32, s[54:55]
		v_accvgpr_read_b32 v32, a180
		v_readfirstlane_b32 s54, v194
		v_readfirstlane_b32 s55, v195
		s_nop 1
		v_cndmask_b32_e64 v190, v230, v32, s[54:55]
		v_accvgpr_read_b32 v32, a211
		v_cndmask_b32_e32 v187, v230, v32, vcc
		v_cmp_ge_i32_e64 vcc, v7, v224
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v7, v226
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v7, v159
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v32, a212
		v_cndmask_b32_e64 v158, v230, v32, s[54:55]
		v_accvgpr_read_b32 v32, a213
		v_cndmask_b32_e64 v159, v230, v32, s[58:59]
		v_accvgpr_read_b32 v32, a214
		v_cndmask_b32_e64 v194, v230, v32, s[60:61]
		v_cmp_ge_i32_e64 vcc, v7, v160
		v_accvgpr_read_b32 v32, a181
		v_readfirstlane_b32 s54, v196
		v_readfirstlane_b32 s55, v197
		s_nop 1
		v_cndmask_b32_e64 v191, v230, v32, s[54:55]
		v_accvgpr_read_b32 v32, a182
		v_readfirstlane_b32 s54, v198
		v_readfirstlane_b32 s55, v199
		s_nop 1
		v_cndmask_b32_e64 v200, v230, v32, s[54:55]
		v_accvgpr_read_b32 v32, a215
		v_cndmask_b32_e32 v195, v230, v32, vcc
		v_cmp_ge_i32_e64 vcc, v7, v231
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v7, v240
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v7, v161
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v32, a216
		v_cndmask_b32_e64 v160, v230, v32, s[54:55]
		v_accvgpr_read_b32 v32, a217
		v_cndmask_b32_e64 v161, v230, v32, s[58:59]
		v_accvgpr_read_b32 v32, a218
		v_cndmask_b32_e64 v196, v230, v32, s[60:61]
		v_cmp_ge_i32_e64 vcc, v7, v162
		v_accvgpr_read_b32 v32, a184
		v_readfirstlane_b32 s54, v202
		v_readfirstlane_b32 s55, v203
		s_nop 1
		v_cndmask_b32_e64 v198, v230, v32, s[54:55]
		v_accvgpr_read_b32 v32, a185
		v_readfirstlane_b32 s54, v204
		v_readfirstlane_b32 s55, v205
		s_nop 1
		v_cndmask_b32_e64 v199, v230, v32, s[54:55]
		v_accvgpr_read_b32 v32, a219
		v_cndmask_b32_e32 v197, v230, v32, vcc
		v_cmp_ge_i32_e64 vcc, v7, v241
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v7, v246
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v7, v163
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v32, a220
		v_cndmask_b32_e64 v162, v230, v32, s[54:55]
		v_accvgpr_read_b32 v32, a221
		v_cndmask_b32_e64 v163, v230, v32, s[58:59]
		v_accvgpr_read_b32 v32, a222
		v_cndmask_b32_e64 v202, v230, v32, s[60:61]
		v_cmp_ge_i32_e64 vcc, v7, v164
		v_accvgpr_read_b32 v32, a186
		v_readfirstlane_b32 s54, v206
		v_readfirstlane_b32 s55, v207
		s_nop 1
		v_cndmask_b32_e64 v224, v230, v32, s[54:55]
		v_accvgpr_read_b32 v32, a188
		v_mov_b32_e32 v164, s94
		v_mov_b32_e32 v165, s95
		s_nop 0
		v_readfirstlane_b32 s54, v164
		v_readfirstlane_b32 s55, v165
		s_nop 1
		v_cndmask_b32_e64 v226, v230, v32, s[54:55]
		v_accvgpr_read_b32 v32, a223
		v_cndmask_b32_e32 v203, v230, v32, vcc
		v_max_f32_e32 v32, v252, v253
		v_max_f32_e32 v42, v166, v167
		v_accvgpr_read_b32 v44, a146
		v_accvgpr_read_b32 v164, a147
		v_max_f32_e32 v44, v44, v164
		v_max_f32_e32 v164, v168, v169
		v_max_f32_e32 v165, v38, v39
		v_max_f32_e32 v204, v170, v171
		v_max_f32_e32 v205, v254, v255
		v_max_f32_e32 v206, v172, v173
		v_accvgpr_read_b32 v207, a198
		v_accvgpr_read_b32 v208, a199
		v_max_f32_e32 v207, v207, v208
		v_max_f32_e32 v208, v174, v175
		v_max_f32_e32 v209, v138, v139
		v_max_f32_e32 v210, v176, v177
		v_max_f32_e32 v211, v146, v147
		v_max_f32_e32 v212, v180, v181
		v_max_f32_e32 v213, v144, v145
		v_max_f32_e32 v214, v188, v189
		v_max_f32_e32 v215, v184, v185
		v_max_f32_e32 v216, v192, v193
		v_max_f32_e32 v217, v190, v191
		v_max_f32_e32 v218, v200, v201
		v_max_f32_e32 v219, v198, v199
		v_max_f32_e32 v220, v224, v225
		v_max_f32_e32 v221, v226, v227
		v_accvgpr_write_b32 a140, v221
		v_max_f32_e32 v221, v228, v229
		v_max_f32_e32 v222, v232, v233
		v_accvgpr_write_b32 a141, v222
		v_max_f32_e32 v222, v234, v235
		v_accvgpr_write_b32 a142, v222
		v_max_f32_e32 v222, v236, v237
		v_accvgpr_write_b32 a143, v222
		v_max_f32_e32 v222, v238, v239
		v_accvgpr_write_b32 a166, v222
		v_max_f32_e32 v222, v242, v243
		v_accvgpr_write_b32 a167, v222
		v_max_f32_e32 v222, v244, v245
		v_accvgpr_write_b32 a168, v222
		v_max_f32_e32 v222, v248, v249
		v_accvgpr_write_b32 a169, v222
		v_max_f32_e32 v222, v250, v251
		v_max_f32_e32 v32, v32, v42
		v_max_f32_e32 v42, v44, v164
		v_max_f32_e32 v44, v165, v204
		v_max_f32_e32 v164, v205, v206
		v_max_f32_e32 v165, v207, v208
		v_max_f32_e32 v204, v209, v210
		v_max_f32_e32 v205, v211, v212
		v_max_f32_e32 v206, v213, v214
		v_max_f32_e32 v207, v215, v216
		v_max_f32_e32 v208, v217, v218
		v_max_f32_e32 v209, v219, v220
		v_accvgpr_read_b32 v210, a140
		v_max_f32_e32 v210, v210, v221
		v_accvgpr_read_b32 v211, a141
		v_accvgpr_read_b32 v212, a142
		v_max_f32_e32 v211, v211, v212
		v_accvgpr_read_b32 v212, a143
		v_accvgpr_read_b32 v213, a166
		v_max_f32_e32 v212, v212, v213
		v_accvgpr_read_b32 v213, a167
		v_accvgpr_read_b32 v214, a168
		v_max_f32_e32 v213, v213, v214
		v_accvgpr_read_b32 v214, a169
		v_max_f32_e32 v214, v214, v222
		v_max_f32_e32 v32, v32, v42
		v_max_f32_e32 v42, v44, v164
		v_max_f32_e32 v44, v165, v204
		v_max_f32_e32 v164, v205, v206
		v_max_f32_e32 v165, v207, v208
		v_max_f32_e32 v204, v209, v210
		v_max_f32_e32 v205, v211, v212
		v_max_f32_e32 v206, v213, v214
		v_max_f32_e32 v32, v32, v42
		v_max_f32_e32 v42, v44, v164
		v_max_f32_e32 v44, v165, v204
		v_max_f32_e32 v164, v205, v206
		v_max_f32_e32 v32, v32, v42
		v_max_f32_e32 v42, v44, v164
		v_max_f32_e32 v32, v32, v42
		ds_bpermute_b32 v42, v20, v32
		ds_bpermute_b32 v44, v12, v32
		v_accvgpr_read_b32 v32, a144
		v_accvgpr_read_b32 v164, a145
		v_max_f32_e32 v32, v32, v164
		v_accvgpr_read_b32 v164, a190
		v_accvgpr_read_b32 v165, a191
		v_max_f32_e32 v164, v164, v165
		v_accvgpr_read_b32 v165, a192
		v_accvgpr_read_b32 v204, a193
		v_max_f32_e32 v165, v165, v204
		v_accvgpr_read_b32 v204, a194
		v_accvgpr_read_b32 v205, a195
		v_max_f32_e32 v204, v204, v205
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v206, v42, v44
		v_accvgpr_read_b32 v42, a148
		v_accvgpr_read_b32 v44, a149
		v_max_f32_e32 v42, v42, v44
		v_accvgpr_read_b32 v44, a150
		v_accvgpr_read_b32 v205, a151
		v_max_f32_e32 v44, v44, v205
		v_accvgpr_read_b32 v205, a152
		v_accvgpr_read_b32 v207, a153
		v_max_f32_e32 v205, v205, v207
		v_max_f32_e32 v207, v40, v41
		v_accvgpr_read_b32 v208, a154
		v_accvgpr_read_b32 v209, a155
		v_max_f32_e32 v208, v208, v209
		v_accvgpr_read_b32 v209, a196
		v_accvgpr_read_b32 v210, a197
		v_max_f32_e32 v209, v209, v210
		v_accvgpr_read_b32 v210, a156
		v_accvgpr_read_b32 v211, a157
		v_max_f32_e32 v210, v210, v211
		v_accvgpr_read_b32 v211, a158
		v_accvgpr_read_b32 v212, a159
		v_max_f32_e32 v211, v211, v212
		v_accvgpr_read_b32 v212, a160
		v_accvgpr_read_b32 v213, a161
		v_max_f32_e32 v212, v212, v213
		v_accvgpr_read_b32 v213, a200
		v_accvgpr_read_b32 v214, a201
		v_max_f32_e32 v213, v213, v214
		v_accvgpr_read_b32 v214, a162
		v_accvgpr_read_b32 v215, a163
		v_max_f32_e32 v214, v214, v215
		v_max_f32_e32 v215, v140, v141
		v_accvgpr_read_b32 v216, a164
		v_accvgpr_read_b32 v217, a165
		v_max_f32_e32 v216, v216, v217
		v_max_f32_e32 v217, v142, v143
		v_max_f32_e32 v218, v148, v149
		v_max_f32_e32 v219, v178, v179
		v_max_f32_e32 v220, v150, v151
		v_max_f32_e32 v221, v182, v183
		v_max_f32_e32 v222, v152, v153
		v_accvgpr_write_b32 a140, v222
		v_max_f32_e32 v222, v154, v155
		v_accvgpr_write_b32 a141, v222
		v_max_f32_e32 v222, v156, v157
		v_accvgpr_write_b32 a142, v222
		v_max_f32_e32 v222, v186, v187
		v_accvgpr_write_b32 a143, v222
		v_max_f32_e32 v222, v158, v159
		v_accvgpr_write_b32 a166, v222
		v_max_f32_e32 v222, v194, v195
		v_accvgpr_write_b32 a167, v222
		v_max_f32_e32 v222, v160, v161
		v_accvgpr_write_b32 a168, v222
		v_max_f32_e32 v222, v196, v197
		v_accvgpr_write_b32 a169, v222
		v_max_f32_e32 v222, v162, v163
		v_accvgpr_write_b32 a170, v222
		v_max_f32_e32 v222, v202, v203
		v_max_f32_e32 v32, v32, v164
		v_max_f32_e32 v164, v165, v204
		v_max_f32_e32 v42, v42, v44
		v_max_f32_e32 v44, v205, v207
		v_max_f32_e32 v165, v208, v209
		v_max_f32_e32 v204, v210, v211
		v_max_f32_e32 v205, v212, v213
		v_max_f32_e32 v207, v214, v215
		v_max_f32_e32 v208, v216, v217
		v_max_f32_e32 v209, v218, v219
		v_max_f32_e32 v210, v220, v221
		v_accvgpr_read_b32 v211, a140
		v_accvgpr_read_b32 v212, a141
		v_max_f32_e32 v211, v211, v212
		v_accvgpr_read_b32 v212, a142
		v_accvgpr_read_b32 v213, a143
		v_max_f32_e32 v212, v212, v213
		v_accvgpr_read_b32 v213, a166
		v_accvgpr_read_b32 v214, a167
		v_max_f32_e32 v213, v213, v214
		v_accvgpr_read_b32 v214, a168
		v_accvgpr_read_b32 v215, a169
		v_max_f32_e32 v214, v214, v215
		v_accvgpr_read_b32 v215, a170
		v_max_f32_e32 v215, v215, v222
		v_max_f32_e32 v32, v32, v164
		v_max_f32_e32 v42, v42, v44
		v_max_f32_e32 v44, v165, v204
		v_max_f32_e32 v164, v205, v207
		v_max_f32_e32 v165, v208, v209
		v_max_f32_e32 v204, v210, v211
		v_max_f32_e32 v205, v212, v213
		v_max_f32_e32 v207, v214, v215
		v_max_f32_e32 v32, v32, v42
		v_max_f32_e32 v42, v44, v164
		v_max_f32_e32 v44, v165, v204
		v_max_f32_e32 v164, v205, v207
		v_max_f32_e32 v32, v32, v42
		v_max_f32_e32 v42, v44, v164
		v_max_f32_e32 v32, v32, v42
		ds_bpermute_b32 v42, v20, v32
		ds_bpermute_b32 v44, v12, v32
		v_pk_mul_f32 v[164:165], v[252:253], v[34:35]
		v_pk_mul_f32 v[204:205], v[166:167], v[34:35]
		v_accvgpr_read_b32 v166, a146
		v_accvgpr_read_b32 v167, a147
		v_pk_mul_f32 v[208:209], v[166:167], v[34:35]
		v_pk_mul_f32 v[166:167], v[168:169], v[34:35]
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v207, v42, v44
		v_pk_mul_f32 v[168:169], v[206:207], v[34:35]
		v_max_f32_e32 v32, v16, v168
		v_max_f32_e32 v42, v21, v169
		v_pk_mul_f32 v[168:169], v[38:39], v[34:35]
		v_pk_mul_f32 v[38:39], v[170:171], v[34:35]
		v_pk_mul_f32 v[170:171], v[254:255], v[34:35]
		v_pk_mul_f32 v[206:207], v[172:173], v[34:35]
		v_accvgpr_read_b32 v172, a198
		v_accvgpr_read_b32 v173, a199
		v_pk_mul_f32 v[210:211], v[172:173], v[34:35]
		v_pk_mul_f32 v[172:173], v[174:175], v[34:35]
		v_pk_mul_f32 v[174:175], v[138:139], v[34:35]
		v_pk_mul_f32 v[138:139], v[176:177], v[34:35]
		v_pk_mul_f32 v[176:177], v[146:147], v[34:35]
		v_pk_mul_f32 v[146:147], v[180:181], v[34:35]
		v_pk_mul_f32 v[180:181], v[144:145], v[34:35]
		v_pk_mul_f32 v[144:145], v[188:189], v[34:35]
		v_pk_mul_f32 v[188:189], v[184:185], v[34:35]
		v_pk_mul_f32 v[184:185], v[192:193], v[34:35]
		v_pk_mul_f32 v[192:193], v[190:191], v[34:35]
		v_pk_mul_f32 v[190:191], v[200:201], v[34:35]
		v_pk_mul_f32 v[200:201], v[198:199], v[34:35]
		v_pk_mul_f32 v[198:199], v[224:225], v[34:35]
		v_pk_mul_f32 v[212:213], v[226:227], v[34:35]
		v_pk_mul_f32 v[214:215], v[228:229], v[34:35]
		v_pk_mul_f32 v[216:217], v[232:233], v[34:35]
		v_pk_mul_f32 v[218:219], v[234:235], v[34:35]
		v_pk_mul_f32 v[220:221], v[236:237], v[34:35]
		v_pk_mul_f32 v[222:223], v[238:239], v[34:35]
		v_pk_mul_f32 v[224:225], v[242:243], v[34:35]
		v_pk_mul_f32 v[226:227], v[244:245], v[34:35]
		v_pk_mul_f32 v[228:229], v[248:249], v[34:35]
		v_pk_mul_f32 v[230:231], v[250:251], v[34:35]
		v_accvgpr_read_b32 v232, a144
		v_accvgpr_read_b32 v233, a145
		v_pk_mul_f32 v[234:235], v[232:233], v[34:35]
		v_accvgpr_read_b32 v232, a190
		v_accvgpr_read_b32 v233, a191
		v_pk_mul_f32 v[236:237], v[232:233], v[34:35]
		v_accvgpr_read_b32 v232, a192
		v_accvgpr_read_b32 v233, a193
		v_pk_mul_f32 v[238:239], v[232:233], v[34:35]
		v_accvgpr_read_b32 v232, a194
		v_accvgpr_read_b32 v233, a195
		v_pk_mul_f32 v[240:241], v[232:233], v[34:35]
		v_accvgpr_read_b32 v232, a148
		v_accvgpr_read_b32 v233, a149
		v_pk_mul_f32 v[242:243], v[232:233], v[34:35]
		v_accvgpr_read_b32 v232, a150
		v_accvgpr_read_b32 v233, a151
		v_pk_mul_f32 v[244:245], v[232:233], v[34:35]
		v_accvgpr_read_b32 v232, a152
		v_accvgpr_read_b32 v233, a153
		v_pk_mul_f32 v[246:247], v[232:233], v[34:35]
		v_pk_mul_f32 v[232:233], v[40:41], v[34:35]
		v_accvgpr_read_b32 v40, a154
		v_accvgpr_read_b32 v41, a155
		v_pk_mul_f32 v[248:249], v[40:41], v[34:35]
		v_accvgpr_read_b32 v40, a196
		v_accvgpr_read_b32 v41, a197
		v_pk_mul_f32 v[40:41], v[40:41], v[34:35]
		v_accvgpr_write_b32 a140, v40
		v_accvgpr_write_b32 a141, v41
		v_accvgpr_read_b32 v40, a156
		v_accvgpr_read_b32 v41, a157
		v_pk_mul_f32 v[40:41], v[40:41], v[34:35]
		v_accvgpr_write_b32 a142, v40
		v_accvgpr_write_b32 a143, v41
		v_accvgpr_read_b32 v40, a158
		v_accvgpr_read_b32 v41, a159
		v_pk_mul_f32 v[40:41], v[40:41], v[34:35]
		v_accvgpr_write_b32 a144, v40
		v_accvgpr_write_b32 a145, v41
		v_accvgpr_read_b32 v40, a160
		v_accvgpr_read_b32 v41, a161
		v_pk_mul_f32 v[250:251], v[40:41], v[34:35]
		v_accvgpr_read_b32 v40, a200
		v_accvgpr_read_b32 v41, a201
		v_pk_mul_f32 v[40:41], v[40:41], v[34:35]
		v_accvgpr_write_b32 a146, v40
		v_accvgpr_write_b32 a147, v41
		v_accvgpr_read_b32 v40, a162
		v_accvgpr_read_b32 v41, a163
		v_pk_mul_f32 v[252:253], v[40:41], v[34:35]
		v_pk_mul_f32 v[40:41], v[140:141], v[34:35]
		v_accvgpr_write_b32 a148, v40
		v_accvgpr_write_b32 a149, v41
		v_accvgpr_read_b32 v40, a164
		v_accvgpr_read_b32 v41, a165
		v_pk_mul_f32 v[140:141], v[40:41], v[34:35]
		v_pk_mul_f32 v[40:41], v[142:143], v[34:35]
		v_pk_mul_f32 v[142:143], v[148:149], v[34:35]
		v_pk_mul_f32 v[148:149], v[178:179], v[34:35]
		v_pk_mul_f32 v[178:179], v[150:151], v[34:35]
		v_pk_mul_f32 v[150:151], v[182:183], v[34:35]
		v_pk_mul_f32 v[182:183], v[152:153], v[34:35]
		v_pk_mul_f32 v[152:153], v[154:155], v[34:35]
		v_pk_mul_f32 v[154:155], v[156:157], v[34:35]
		v_pk_mul_f32 v[156:157], v[186:187], v[34:35]
		v_pk_mul_f32 v[186:187], v[158:159], v[34:35]
		v_pk_mul_f32 v[158:159], v[194:195], v[34:35]
		v_pk_mul_f32 v[194:195], v[160:161], v[34:35]
		v_pk_mul_f32 v[160:161], v[196:197], v[34:35]
		v_pk_mul_f32 v[196:197], v[162:163], v[34:35]
		v_pk_mul_f32 v[162:163], v[202:203], v[34:35]
		v_sub_f32_e32 v44, v164, v32
		v_sub_f32_e32 v164, v165, v32
		v_sub_f32_e32 v165, v204, v32
		v_sub_f32_e32 v202, v205, v32
		v_sub_f32_e32 v203, v208, v32
		v_sub_f32_e32 v204, v209, v32
		v_sub_f32_e32 v166, v166, v32
		v_sub_f32_e32 v167, v167, v32
		v_sub_f32_e32 v168, v168, v32
		v_sub_f32_e32 v169, v169, v32
		v_sub_f32_e32 v38, v38, v32
		v_sub_f32_e32 v39, v39, v32
		v_sub_f32_e32 v170, v170, v32
		v_sub_f32_e32 v171, v171, v32
		v_sub_f32_e32 v205, v206, v32
		v_sub_f32_e32 v206, v207, v32
		v_sub_f32_e32 v207, v210, v32
		v_sub_f32_e32 v208, v211, v32
		v_sub_f32_e32 v172, v172, v32
		v_sub_f32_e32 v173, v173, v32
		v_sub_f32_e32 v174, v174, v32
		v_sub_f32_e32 v175, v175, v32
		v_sub_f32_e32 v138, v138, v32
		v_sub_f32_e32 v139, v139, v32
		v_sub_f32_e32 v176, v176, v32
		v_sub_f32_e32 v177, v177, v32
		v_sub_f32_e32 v146, v146, v32
		v_sub_f32_e32 v147, v147, v32
		v_sub_f32_e32 v180, v180, v32
		v_sub_f32_e32 v181, v181, v32
		v_sub_f32_e32 v144, v144, v32
		v_sub_f32_e32 v145, v145, v32
		v_sub_f32_e32 v188, v188, v32
		v_sub_f32_e32 v189, v189, v32
		v_sub_f32_e32 v184, v184, v32
		v_sub_f32_e32 v185, v185, v32
		v_sub_f32_e32 v192, v192, v32
		v_sub_f32_e32 v193, v193, v32
		v_sub_f32_e32 v190, v190, v32
		v_sub_f32_e32 v191, v191, v32
		v_sub_f32_e32 v200, v200, v32
		v_sub_f32_e32 v201, v201, v32
		v_sub_f32_e32 v198, v198, v32
		v_sub_f32_e32 v199, v199, v32
		v_sub_f32_e32 v209, v212, v32
		v_sub_f32_e32 v210, v213, v32
		v_sub_f32_e32 v211, v214, v32
		v_sub_f32_e32 v212, v215, v32
		v_sub_f32_e32 v213, v216, v32
		v_sub_f32_e32 v214, v217, v32
		v_sub_f32_e32 v215, v218, v32
		v_sub_f32_e32 v216, v219, v32
		v_sub_f32_e32 v217, v220, v32
		v_sub_f32_e32 v218, v221, v32
		v_sub_f32_e32 v219, v222, v32
		v_sub_f32_e32 v220, v223, v32
		v_sub_f32_e32 v221, v224, v32
		v_sub_f32_e32 v222, v225, v32
		v_sub_f32_e32 v223, v226, v32
		v_sub_f32_e32 v224, v227, v32
		v_sub_f32_e32 v225, v228, v32
		v_sub_f32_e32 v226, v229, v32
		v_sub_f32_e32 v227, v230, v32
		v_sub_f32_e32 v228, v231, v32
		v_sub_f32_e32 v229, v234, v42
		v_sub_f32_e32 v230, v235, v42
		v_sub_f32_e32 v231, v236, v42
		v_sub_f32_e32 v234, v237, v42
		v_sub_f32_e32 v235, v238, v42
		v_sub_f32_e32 v236, v239, v42
		v_sub_f32_e32 v237, v240, v42
		v_sub_f32_e32 v238, v241, v42
		v_sub_f32_e32 v239, v242, v42
		v_sub_f32_e32 v240, v243, v42
		v_sub_f32_e32 v241, v244, v42
		v_sub_f32_e32 v242, v245, v42
		v_sub_f32_e32 v243, v246, v42
		v_sub_f32_e32 v244, v247, v42
		v_sub_f32_e32 v232, v232, v42
		v_sub_f32_e32 v233, v233, v42
		v_sub_f32_e32 v245, v248, v42
		v_sub_f32_e32 v246, v249, v42
		v_accvgpr_read_b32 v247, a140
		v_sub_f32_e32 v247, v247, v42
		v_accvgpr_read_b32 v248, a141
		v_sub_f32_e32 v248, v248, v42
		v_accvgpr_write_b32 a140, v248
		v_accvgpr_read_b32 v248, a142
		v_sub_f32_e32 v248, v248, v42
		v_accvgpr_write_b32 a141, v248
		v_accvgpr_read_b32 v248, a143
		v_sub_f32_e32 v248, v248, v42
		v_accvgpr_write_b32 a142, v248
		v_accvgpr_read_b32 v248, a144
		v_sub_f32_e32 v248, v248, v42
		v_accvgpr_write_b32 a143, v248
		v_accvgpr_read_b32 v248, a145
		v_sub_f32_e32 v248, v248, v42
		v_sub_f32_e32 v249, v250, v42
		v_sub_f32_e32 v250, v251, v42
		v_accvgpr_write_b32 a144, v250
		v_accvgpr_read_b32 v250, a146
		v_sub_f32_e32 v250, v250, v42
		v_accvgpr_write_b32 a145, v250
		v_accvgpr_read_b32 v250, a147
		v_sub_f32_e32 v250, v250, v42
		v_sub_f32_e32 v251, v252, v42
		v_sub_f32_e32 v252, v253, v42
		v_accvgpr_read_b32 v253, a148
		v_sub_f32_e32 v253, v253, v42
		v_accvgpr_write_b32 a146, v253
		v_accvgpr_read_b32 v253, a149
		v_sub_f32_e32 v253, v253, v42
		v_sub_f32_e32 v140, v140, v42
		v_sub_f32_e32 v141, v141, v42
		v_sub_f32_e32 v40, v40, v42
		v_sub_f32_e32 v41, v41, v42
		v_sub_f32_e32 v142, v142, v42
		v_sub_f32_e32 v143, v143, v42
		v_sub_f32_e32 v148, v148, v42
		v_sub_f32_e32 v149, v149, v42
		v_sub_f32_e32 v178, v178, v42
		v_sub_f32_e32 v179, v179, v42
		v_sub_f32_e32 v150, v150, v42
		v_sub_f32_e32 v151, v151, v42
		v_sub_f32_e32 v182, v182, v42
		v_sub_f32_e32 v183, v183, v42
		v_sub_f32_e32 v152, v152, v42
		v_sub_f32_e32 v153, v153, v42
		v_sub_f32_e32 v154, v154, v42
		v_sub_f32_e32 v155, v155, v42
		v_sub_f32_e32 v156, v156, v42
		v_sub_f32_e32 v157, v157, v42
		v_sub_f32_e32 v186, v186, v42
		v_sub_f32_e32 v187, v187, v42
		v_sub_f32_e32 v158, v158, v42
		v_sub_f32_e32 v159, v159, v42
		v_sub_f32_e32 v194, v194, v42
		v_sub_f32_e32 v195, v195, v42
		v_sub_f32_e32 v160, v160, v42
		v_sub_f32_e32 v161, v161, v42
		v_sub_f32_e32 v196, v196, v42
		v_sub_f32_e32 v197, v197, v42
		v_sub_f32_e32 v162, v162, v42
		v_sub_f32_e32 v163, v163, v42
		v_exp_f32_e32 v44, v44
		s_nop 0
		v_accvgpr_write_b32 a148, v44
		v_exp_f32_e32 v254, v164
		v_exp_f32_e32 v44, v165
		s_nop 0
		v_accvgpr_write_b32 a149, v44
		v_exp_f32_e32 v255, v202
		v_exp_f32_e32 v44, v203
		s_nop 0
		v_accvgpr_write_b32 a150, v44
		v_exp_f32_e32 v164, v204
		v_exp_f32_e32 v44, v166
		s_nop 0
		v_accvgpr_write_b32 a151, v44
		v_exp_f32_e32 v165, v167
		v_exp_f32_e32 v166, v168
		v_exp_f32_e32 v202, v169
		v_exp_f32_e32 v167, v38
		v_exp_f32_e32 v203, v39
		v_exp_f32_e32 v38, v170
		v_exp_f32_e32 v168, v171
		v_exp_f32_e32 v39, v205
		v_exp_f32_e32 v169, v206
		v_exp_f32_e32 v170, v207
		v_exp_f32_e32 v204, v208
		v_exp_f32_e32 v171, v172
		v_exp_f32_e32 v205, v173
		v_exp_f32_e32 v172, v174
		v_exp_f32_e32 v206, v175
		v_exp_f32_e32 v173, v138
		v_exp_f32_e32 v207, v139
		v_exp_f32_e32 v138, v176
		v_exp_f32_e32 v174, v177
		v_exp_f32_e32 v139, v146
		v_exp_f32_e32 v175, v147
		v_exp_f32_e32 v146, v180
		v_exp_f32_e32 v176, v181
		v_exp_f32_e32 v147, v144
		v_exp_f32_e32 v177, v145
		v_exp_f32_e32 v144, v188
		v_exp_f32_e32 v180, v189
		v_exp_f32_e32 v145, v184
		v_exp_f32_e32 v181, v185
		v_exp_f32_e32 v184, v192
		v_exp_f32_e32 v188, v193
		v_exp_f32_e32 v185, v190
		v_exp_f32_e32 v189, v191
		v_exp_f32_e32 v190, v200
		v_exp_f32_e32 v192, v201
		v_exp_f32_e32 v191, v198
		v_exp_f32_e32 v193, v199
		v_exp_f32_e32 v198, v209
		v_exp_f32_e32 v200, v210
		v_exp_f32_e32 v199, v211
		v_exp_f32_e32 v201, v212
		v_exp_f32_e32 v208, v213
		v_exp_f32_e32 v210, v214
		v_exp_f32_e32 v209, v215
		v_exp_f32_e32 v211, v216
		v_exp_f32_e32 v212, v217
		v_exp_f32_e32 v214, v218
		v_exp_f32_e32 v213, v219
		v_exp_f32_e32 v215, v220
		v_exp_f32_e32 v216, v221
		v_exp_f32_e32 v218, v222
		v_exp_f32_e32 v217, v223
		v_exp_f32_e32 v219, v224
		v_exp_f32_e32 v220, v225
		v_exp_f32_e32 v222, v226
		v_exp_f32_e32 v221, v227
		v_exp_f32_e32 v223, v228
		v_exp_f32_e32 v44, v229
		s_nop 0
		v_accvgpr_write_b32 a153, v44
		v_exp_f32_e32 v44, v230
		s_nop 0
		v_accvgpr_write_b32 a155, v44
		v_exp_f32_e32 v224, v231
		v_exp_f32_e32 v226, v234
		v_exp_f32_e32 v225, v235
		v_exp_f32_e32 v227, v236
		v_exp_f32_e32 v228, v237
		v_exp_f32_e32 v230, v238
		v_exp_f32_e32 v229, v239
		v_exp_f32_e32 v231, v240
		v_exp_f32_e32 v234, v241
		v_exp_f32_e32 v236, v242
		v_exp_f32_e32 v235, v243
		v_exp_f32_e32 v237, v244
		v_exp_f32_e32 v238, v232
		v_exp_f32_e32 v240, v233
		v_exp_f32_e32 v239, v245
		v_exp_f32_e32 v241, v246
		v_exp_f32_e32 v232, v247
		v_accvgpr_read_b32 v44, a140
		v_exp_f32_e32 v242, v44
		v_accvgpr_read_b32 v44, a141
		v_exp_f32_e32 v233, v44
		v_accvgpr_read_b32 v44, a142
		v_exp_f32_e32 v243, v44
		v_accvgpr_read_b32 v44, a143
		v_exp_f32_e32 v44, v44
		s_nop 0
		v_accvgpr_write_b32 a140, v44
		v_exp_f32_e32 v244, v248
		v_exp_f32_e32 v44, v249
		s_nop 0
		v_accvgpr_write_b32 a141, v44
		v_accvgpr_read_b32 v44, a144
		v_exp_f32_e32 v245, v44
		v_accvgpr_read_b32 v44, a145
		v_exp_f32_e32 v44, v44
		s_nop 0
		v_accvgpr_write_b32 a142, v44
		v_exp_f32_e32 v246, v250
		v_exp_f32_e32 v44, v251
		s_nop 0
		v_accvgpr_write_b32 a143, v44
		v_exp_f32_e32 v247, v252
		v_accvgpr_read_b32 v44, a146
		v_exp_f32_e32 v248, v44
		v_exp_f32_e32 v250, v253
		v_exp_f32_e32 v249, v140
		v_exp_f32_e32 v251, v141
		v_exp_f32_e32 v140, v40
		v_exp_f32_e32 v252, v41
		v_exp_f32_e32 v141, v142
		v_exp_f32_e32 v253, v143
		v_exp_f32_e32 v40, v148
		v_exp_f32_e32 v142, v149
		v_exp_f32_e32 v41, v178
		v_exp_f32_e32 v143, v179
		v_exp_f32_e32 v148, v150
		v_exp_f32_e32 v178, v151
		v_exp_f32_e32 v149, v182
		v_exp_f32_e32 v179, v183
		v_exp_f32_e32 v150, v152
		v_exp_f32_e32 v182, v153
		v_exp_f32_e32 v151, v154
		v_exp_f32_e32 v183, v155
		v_exp_f32_e32 v152, v156
		v_exp_f32_e32 v154, v157
		v_exp_f32_e32 v153, v186
		v_exp_f32_e32 v155, v187
		v_exp_f32_e32 v156, v158
		v_exp_f32_e32 v186, v159
		v_exp_f32_e32 v157, v194
		v_exp_f32_e32 v187, v195
		v_exp_f32_e32 v44, v160
		s_nop 0
		v_accvgpr_write_b32 a144, v44
		v_exp_f32_e32 v44, v161
		s_nop 0
		v_accvgpr_write_b32 a146, v44
		v_exp_f32_e32 v44, v196
		s_nop 0
		v_accvgpr_write_b32 a145, v44
		v_exp_f32_e32 v44, v197
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
		v_pk_add_f32 v[158:159], v[166:167], v[202:203]
		v_accvgpr_write_b32 a162, v158
		v_accvgpr_write_b32 a163, v159
		v_pk_add_f32 v[158:159], v[38:39], v[168:169]
		v_accvgpr_write_b32 a164, v158
		v_accvgpr_write_b32 a165, v159
		v_pk_add_f32 v[158:159], v[170:171], v[204:205]
		v_accvgpr_write_b32 a166, v158
		v_accvgpr_write_b32 a167, v159
		v_pk_add_f32 v[158:159], v[172:173], v[206:207]
		v_accvgpr_write_b32 a168, v158
		v_accvgpr_write_b32 a169, v159
		v_pk_add_f32 v[158:159], v[138:139], v[174:175]
		v_accvgpr_write_b32 a170, v158
		v_accvgpr_write_b32 a171, v159
		v_pk_add_f32 v[158:159], v[146:147], v[176:177]
		v_accvgpr_write_b32 a172, v158
		v_accvgpr_write_b32 a173, v159
		v_pk_add_f32 v[158:159], v[144:145], v[180:181]
		v_accvgpr_write_b32 a174, v158
		v_accvgpr_write_b32 a175, v159
		v_pk_add_f32 v[158:159], v[184:185], v[188:189]
		v_accvgpr_write_b32 a176, v158
		v_accvgpr_write_b32 a177, v159
		v_pk_add_f32 v[158:159], v[190:191], v[192:193]
		v_accvgpr_write_b32 a178, v158
		v_accvgpr_write_b32 a179, v159
		v_pk_add_f32 v[158:159], v[198:199], v[200:201]
		v_accvgpr_write_b32 a180, v158
		v_accvgpr_write_b32 a181, v159
		v_pk_add_f32 v[158:159], v[208:209], v[210:211]
		v_accvgpr_write_b32 a182, v158
		v_accvgpr_write_b32 a183, v159
		v_pk_add_f32 v[158:159], v[212:213], v[214:215]
		v_accvgpr_write_b32 a184, v158
		v_accvgpr_write_b32 a185, v159
		v_pk_add_f32 v[158:159], v[216:217], v[218:219]
		v_accvgpr_write_b32 a186, v158
		v_accvgpr_write_b32 a187, v159
		v_pk_add_f32 v[158:159], v[220:221], v[222:223]
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
		v_and_b32_e32 v158, 1, v9
		v_lshrrev_b32_e32 v159, 4, v9
		v_and_b32_e32 v159, 1, v159
		v_lshlrev_b32_e32 v159, 4, v159
		v_lshrrev_b32_e32 v160, 3, v9
		v_and_b32_e32 v160, 1, v160
		v_lshlrev_b32_e32 v160, 3, v160
		v_add3_u32 v158, v158, v159, v160
		v_lshrrev_b32_e32 v159, 2, v9
		v_and_b32_e32 v159, 1, v159
		v_lshlrev_b32_e32 v159, 2, v159
		v_lshrrev_b32_e32 v160, 1, v9
		v_and_b32_e32 v160, 1, v160
		v_lshlrev_b32_e32 v160, 1, v160
		v_add3_u32 v158, v158, v159, v160
		v_lshlrev_b32_e32 v158, 2, v158
		ds_bpermute_b32 v159, v158, v44
		s_waitcnt lgkmcnt(0)
		v_accvgpr_write_b32 a152, v159
		v_lshrrev_b32_e32 v159, 4, v9
		v_and_b32_e32 v159, 1, v159
		v_lshlrev_b32_e32 v159, 4, v159
		v_lshrrev_b32_e32 v160, 3, v9
		v_and_b32_e32 v160, 1, v160
		v_lshlrev_b32_e32 v160, 3, v160
		v_lshrrev_b32_e32 v161, 2, v9
		v_and_b32_e32 v161, 1, v161
		v_lshlrev_b32_e32 v161, 2, v161
		v_and_b32_e32 v162, 1, v9
		v_add_u32_e32 v162, 32, v162
		v_lshrrev_b32_e32 v163, 1, v9
		v_and_b32_e32 v163, 1, v163
		v_lshlrev_b32_e32 v163, 1, v163
		v_bitop3_b32 v161, v161, v162, v163 bitop3:0x96
		v_bitop3_b32 v159, v159, v160, v161 bitop3:0x96
		v_lshlrev_b32_e32 v159, 2, v159
		ds_bpermute_b32 v160, v159, v44
		s_waitcnt lgkmcnt(0)
		v_accvgpr_write_b32 a154, v160
		v_pk_add_f32 v[160:161], v[224:225], v[226:227]
		v_accvgpr_write_b32 a160, v160
		v_accvgpr_write_b32 a161, v161
		v_pk_add_f32 v[160:161], v[228:229], v[230:231]
		v_accvgpr_write_b32 a162, v160
		v_accvgpr_write_b32 a163, v161
		v_pk_add_f32 v[160:161], v[234:235], v[236:237]
		v_accvgpr_write_b32 a164, v160
		v_accvgpr_write_b32 a165, v161
		v_pk_add_f32 v[160:161], v[238:239], v[240:241]
		v_accvgpr_write_b32 a166, v160
		v_accvgpr_write_b32 a167, v161
		v_accvgpr_read_b32 v160, a152
		v_accvgpr_read_b32 v161, a153
		v_accvgpr_read_b32 v162, a154
		v_accvgpr_read_b32 v163, a155
		v_pk_add_f32 v[160:161], v[160:161], v[162:163]
		v_accvgpr_write_b32 a168, v160
		v_accvgpr_write_b32 a169, v161
		v_pk_add_f32 v[160:161], v[232:233], v[242:243]
		v_accvgpr_write_b32 a170, v160
		v_accvgpr_write_b32 a171, v161
		v_accvgpr_read_b32 v160, a140
		v_accvgpr_read_b32 v161, a141
		v_pk_add_f32 v[160:161], v[160:161], v[244:245]
		v_accvgpr_write_b32 a172, v160
		v_accvgpr_write_b32 a173, v161
		v_accvgpr_read_b32 v160, a142
		v_accvgpr_read_b32 v161, a143
		v_pk_add_f32 v[160:161], v[160:161], v[246:247]
		v_accvgpr_write_b32 a174, v160
		v_accvgpr_write_b32 a175, v161
		v_pk_add_f32 v[160:161], v[248:249], v[250:251]
		v_accvgpr_write_b32 a176, v160
		v_accvgpr_write_b32 a177, v161
		v_pk_add_f32 v[160:161], v[140:141], v[252:253]
		v_accvgpr_write_b32 a178, v160
		v_accvgpr_write_b32 a179, v161
		v_pk_add_f32 v[160:161], v[40:41], v[142:143]
		v_accvgpr_write_b32 a180, v160
		v_accvgpr_write_b32 a181, v161
		v_pk_add_f32 v[160:161], v[148:149], v[178:179]
		v_accvgpr_write_b32 a182, v160
		v_accvgpr_write_b32 a183, v161
		v_pk_add_f32 v[160:161], v[150:151], v[182:183]
		v_accvgpr_write_b32 a184, v160
		v_accvgpr_write_b32 a185, v161
		v_pk_add_f32 v[160:161], v[152:153], v[154:155]
		v_accvgpr_write_b32 a186, v160
		v_accvgpr_write_b32 a187, v161
		v_pk_add_f32 v[160:161], v[156:157], v[186:187]
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
		v_pk_add_f32 v[194:195], v[162:163], v[160:161]
		v_accvgpr_read_b32 v44, a161
		v_add_f32_e32 v44, v44, v194
		v_add_f32_e32 v44, v195, v44
		ds_bpermute_b32 v160, v158, v44
		ds_bpermute_b32 v158, v159, v44
		v_sub_f32_e32 v16, v16, v32
		v_sub_f32_e32 v21, v21, v42
		v_exp_f32_e32 v162, v16
		v_exp_f32_e32 v194, v21
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v197, v160, v158
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
		v_mov_b32_e32 v195, v194
		v_accvgpr_read_b32 v158, a48
		v_accvgpr_read_b32 v159, a49
		v_pk_mul_f32 v[158:159], v[158:159], v[194:195]
		v_accvgpr_write_b32 a48, v158
		v_accvgpr_write_b32 a49, v159
		v_accvgpr_read_b32 v158, a50
		v_accvgpr_read_b32 v159, a51
		v_pk_mul_f32 v[158:159], v[158:159], v[194:195]
		v_accvgpr_write_b32 a50, v158
		v_accvgpr_write_b32 a51, v159
		v_accvgpr_read_b32 v158, a52
		v_accvgpr_read_b32 v159, a53
		v_pk_mul_f32 v[158:159], v[158:159], v[194:195]
		v_accvgpr_write_b32 a52, v158
		v_accvgpr_write_b32 a53, v159
		v_accvgpr_read_b32 v158, a54
		v_accvgpr_read_b32 v159, a55
		v_pk_mul_f32 v[158:159], v[158:159], v[194:195]
		v_accvgpr_write_b32 a54, v158
		v_accvgpr_write_b32 a55, v159
		v_accvgpr_read_b32 v158, a56
		v_accvgpr_read_b32 v159, a57
		v_pk_mul_f32 v[158:159], v[158:159], v[194:195]
		v_accvgpr_write_b32 a56, v158
		v_accvgpr_write_b32 a57, v159
		v_accvgpr_read_b32 v158, a58
		v_accvgpr_read_b32 v159, a59
		v_pk_mul_f32 v[158:159], v[158:159], v[194:195]
		v_accvgpr_write_b32 a58, v158
		v_accvgpr_write_b32 a59, v159
		v_accvgpr_read_b32 v158, a60
		v_accvgpr_read_b32 v159, a61
		v_pk_mul_f32 v[158:159], v[158:159], v[194:195]
		v_accvgpr_write_b32 a60, v158
		v_accvgpr_write_b32 a61, v159
		v_accvgpr_read_b32 v158, a62
		v_accvgpr_read_b32 v159, a63
		v_pk_mul_f32 v[158:159], v[158:159], v[194:195]
		v_accvgpr_write_b32 a62, v158
		v_accvgpr_write_b32 a63, v159
		v_accvgpr_read_b32 v158, a64
		v_accvgpr_read_b32 v159, a65
		v_pk_mul_f32 v[158:159], v[158:159], v[194:195]
		v_accvgpr_write_b32 a64, v158
		v_accvgpr_write_b32 a65, v159
		v_accvgpr_read_b32 v158, a66
		v_accvgpr_read_b32 v159, a67
		v_pk_mul_f32 v[158:159], v[158:159], v[194:195]
		v_accvgpr_write_b32 a66, v158
		v_accvgpr_write_b32 a67, v159
		v_accvgpr_read_b32 v158, a68
		v_accvgpr_read_b32 v159, a69
		v_pk_mul_f32 v[158:159], v[158:159], v[194:195]
		v_accvgpr_write_b32 a68, v158
		v_accvgpr_write_b32 a69, v159
		v_accvgpr_read_b32 v158, a70
		v_accvgpr_read_b32 v159, a71
		v_pk_mul_f32 v[158:159], v[158:159], v[194:195]
		v_accvgpr_write_b32 a70, v158
		v_accvgpr_write_b32 a71, v159
		v_accvgpr_read_b32 v158, a72
		v_accvgpr_read_b32 v159, a73
		v_pk_mul_f32 v[158:159], v[158:159], v[194:195]
		v_accvgpr_write_b32 a72, v158
		v_accvgpr_write_b32 a73, v159
		v_accvgpr_read_b32 v158, a74
		v_accvgpr_read_b32 v159, a75
		v_pk_mul_f32 v[158:159], v[158:159], v[194:195]
		v_accvgpr_write_b32 a74, v158
		v_accvgpr_write_b32 a75, v159
		v_accvgpr_read_b32 v158, a76
		v_accvgpr_read_b32 v159, a77
		v_pk_mul_f32 v[158:159], v[158:159], v[194:195]
		v_accvgpr_write_b32 a76, v158
		v_accvgpr_write_b32 a77, v159
		v_accvgpr_read_b32 v158, a78
		v_accvgpr_read_b32 v159, a79
		v_pk_mul_f32 v[158:159], v[158:159], v[194:195]
		v_accvgpr_write_b32 a78, v158
		v_accvgpr_write_b32 a79, v159
		v_accvgpr_read_b32 v16, a168
		v_mov_b32_e32 v196, v16
		v_mov_b32_e32 v158, v162
		v_mov_b32_e32 v159, v194
		v_mov_b64_e32 v[160:161], v[36:37]
		v_pk_fma_f32 v[36:37], v[160:161], v[158:159], v[196:197]
		v_accvgpr_read_b32 v16, a148
		v_cvt_pk_bf16_f32 v16, v16, v254
		v_accvgpr_write_b32 a160, v16
		v_accvgpr_read_b32 v16, a149
		v_cvt_pk_bf16_f32 v16, v16, v255
		v_accvgpr_write_b32 a161, v16
		v_accvgpr_read_b32 v16, a150
		v_cvt_pk_bf16_f32 v16, v16, v164
		v_accvgpr_write_b32 a162, v16
		v_accvgpr_read_b32 v16, a151
		v_cvt_pk_bf16_f32 v16, v16, v165
		v_accvgpr_write_b32 a163, v16
		v_cvt_pk_bf16_f32 v160, v166, v202
		v_cvt_pk_bf16_f32 v161, v167, v203
		v_cvt_pk_bf16_f32 v162, v38, v168
		v_cvt_pk_bf16_f32 v163, v39, v169
		v_cvt_pk_bf16_f32 v164, v170, v204
		v_cvt_pk_bf16_f32 v165, v171, v205
		v_cvt_pk_bf16_f32 v166, v172, v206
		v_cvt_pk_bf16_f32 v167, v173, v207
		v_cvt_pk_bf16_f32 v168, v138, v174
		v_cvt_pk_bf16_f32 v169, v139, v175
		v_cvt_pk_bf16_f32 v170, v146, v176
		v_cvt_pk_bf16_f32 v171, v147, v177
		v_cvt_pk_bf16_f32 v172, v144, v180
		v_cvt_pk_bf16_f32 v173, v145, v181
		v_cvt_pk_bf16_f32 v174, v184, v188
		v_cvt_pk_bf16_f32 v175, v185, v189
		v_cvt_pk_bf16_f32 v144, v190, v192
		v_cvt_pk_bf16_f32 v145, v191, v193
		v_cvt_pk_bf16_f32 v146, v198, v200
		v_cvt_pk_bf16_f32 v147, v199, v201
		v_cvt_pk_bf16_f32 v188, v208, v210
		v_cvt_pk_bf16_f32 v189, v209, v211
		v_cvt_pk_bf16_f32 v190, v212, v214
		v_cvt_pk_bf16_f32 v191, v213, v215
		v_cvt_pk_bf16_f32 v192, v216, v218
		v_cvt_pk_bf16_f32 v193, v217, v219
		v_cvt_pk_bf16_f32 v194, v220, v222
		v_cvt_pk_bf16_f32 v195, v221, v223
		v_accvgpr_read_b32 v16, a153
		v_accvgpr_read_b32 v21, a155
		v_cvt_pk_bf16_f32 v196, v16, v21
		v_cvt_pk_bf16_f32 v197, v224, v226
		v_cvt_pk_bf16_f32 v198, v225, v227
		v_cvt_pk_bf16_f32 v199, v228, v230
		v_cvt_pk_bf16_f32 v200, v229, v231
		v_cvt_pk_bf16_f32 v201, v234, v236
		v_cvt_pk_bf16_f32 v202, v235, v237
		v_cvt_pk_bf16_f32 v203, v238, v240
		v_cvt_pk_bf16_f32 v204, v239, v241
		v_cvt_pk_bf16_f32 v205, v232, v242
		v_cvt_pk_bf16_f32 v206, v233, v243
		v_accvgpr_read_b32 v16, a140
		v_cvt_pk_bf16_f32 v207, v16, v244
		v_accvgpr_read_b32 v16, a141
		v_cvt_pk_bf16_f32 v208, v16, v245
		v_accvgpr_read_b32 v16, a142
		v_cvt_pk_bf16_f32 v209, v16, v246
		v_accvgpr_read_b32 v16, a143
		v_cvt_pk_bf16_f32 v210, v16, v247
		v_cvt_pk_bf16_f32 v211, v248, v250
		v_cvt_pk_bf16_f32 v212, v249, v251
		v_cvt_pk_bf16_f32 v213, v140, v252
		v_cvt_pk_bf16_f32 v214, v141, v253
		v_cvt_pk_bf16_f32 v215, v40, v142
		v_cvt_pk_bf16_f32 v216, v41, v143
		v_cvt_pk_bf16_f32 v217, v148, v178
		v_cvt_pk_bf16_f32 v218, v149, v179
		v_cvt_pk_bf16_f32 v219, v150, v182
		v_cvt_pk_bf16_f32 v140, v151, v183
		v_cvt_pk_bf16_f32 v141, v152, v154
		v_cvt_pk_bf16_f32 v142, v153, v155
		v_cvt_pk_bf16_f32 v143, v156, v186
		v_cvt_pk_bf16_f32 v148, v157, v187
		v_accvgpr_read_b32 v16, a144
		v_accvgpr_read_b32 v21, a146
		v_cvt_pk_bf16_f32 v149, v16, v21
		v_accvgpr_read_b32 v16, a145
		v_accvgpr_read_b32 v21, a147
		v_cvt_pk_bf16_f32 v150, v16, v21
		v_accvgpr_read_b32 v16, a156
		v_accvgpr_read_b32 v21, a158
		v_cvt_pk_bf16_f32 v151, v16, v21
		v_accvgpr_read_b32 v152, a160
		v_accvgpr_read_b32 v153, a161
		v_accvgpr_read_b32 v154, a162
		v_accvgpr_read_b32 v155, a163
		s_nop 1
		v_permlane32_swap_b32_e32 v152, v154
		v_permlane32_swap_b32_e32 v153, v155
		v_accvgpr_write_b32 a140, v152
		v_accvgpr_write_b32 a141, v153
		v_accvgpr_write_b32 a142, v154
		v_accvgpr_write_b32 a143, v155
		v_permlane32_swap_b32_e32 v160, v162
		v_permlane32_swap_b32_e32 v161, v163
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		v_permlane32_swap_b32_e32 v168, v170
		v_permlane32_swap_b32_e32 v169, v171
		v_permlane32_swap_b32_e32 v172, v174
		v_permlane32_swap_b32_e32 v173, v175
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_permlane32_swap_b32_e32 v208, v210
		v_permlane32_swap_b32_e32 v209, v211
		v_permlane32_swap_b32_e32 v212, v214
		v_permlane32_swap_b32_e32 v213, v215
		v_permlane32_swap_b32_e32 v216, v218
		v_permlane32_swap_b32_e32 v217, v219
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_permlane32_swap_b32_e32 v148, v150
		v_permlane32_swap_b32_e32 v149, v151
		v_mfma_f32_32x32x16_bf16 v[48:63], a[44:47], a[140:143], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[108:111], a[140:143], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[108:111], v[196:199], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[44:47], v[196:199], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[80:83], v[160:163], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[112:115], v[160:163], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[112:115], v[200:203], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[80:83], v[200:203], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[84:87], v[164:167], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[116:119], v[164:167], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[116:119], v[204:207], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[84:87], v[204:207], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[88:91], v[168:171], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[120:123], v[168:171], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[120:123], v[208:211], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[88:91], v[208:211], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[92:95], v[172:175], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[124:127], v[172:175], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[124:127], v[212:215], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[92:95], v[212:215], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[96:99], v[144:147], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[128:131], v[144:147], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[128:131], v[216:219], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[96:99], v[216:219], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[100:103], v[188:191], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[132:135], v[188:191], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[132:135], v[140:143], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[100:103], v[140:143], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[104:107], v[192:195], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[136:139], v[192:195], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[136:139], v[148:151], a[64:79]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[104:107], v[148:151], a[48:63]
		s_add_i32 s22, s46, 0x80
		s_cmp_lt_i32 s22, s27
		s_mov_b32 s46, s22
		v_mov_b32_e32 v16, v32
		v_mov_b32_e32 v21, v42
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_2
.L_attn_fwd_persistent.loop_exit_2:
		s_mov_b32 m0, s18
		s_nop 0
		ds_read_addtid_b32 v1 offset:1024
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s22, v1
		v_readfirstlane_b32 s26, v2
		s_mul_i32 s22, s22, s26
		s_lshl_b32 s22, s22, 9
		v_accvgpr_read_b32 v1, a0
		s_nop 0
		v_readfirstlane_b32 s26, v1
		s_mul_i32 s26, s1, s26
		s_lshl_b32 s26, s26, 1
		s_add_i32 s27, s22, s26
		v_accvgpr_read_b32 v1, a1
		s_nop 0
		v_readfirstlane_b32 s39, v1
		s_mul_i32 s39, s25, s39
		s_lshl_b32 s39, s39, 1
		s_add_i32 s27, s27, s39
		s_add_i32 s44, s22, 32
		s_add_i32 s44, s44, s26
		s_add_i32 s44, s44, s39
		s_add_i32 s45, s22, 64
		s_add_i32 s45, s45, s26
		s_add_i32 s45, s45, s39
		s_add_i32 s22, s22, 0x60
		s_add_i32 s22, s22, s26
		s_add_i32 s22, s22, s39
		s_and_b32 s46, s0, 15
		s_mul_i32 s46, s46, 2
		s_add_i32 s46, s46, 1
		s_lshr_b32 s47, s46, 1
		s_and_b32 s46, s46, 1
		s_xor_b32 s48, s47, -1
		s_add_i32 s48, s48, 1
		s_add_i32 s48, s48, 31
		s_cmp_eq_u32 s46, 0
		s_cselect_b32 s46, s47, s48
		s_mul_i32 s47, s46, 0x100
		v_and_b32_e32 v1, 1, v0
		v_lshrrev_b32_e32 v7, 1, v0
		v_and_b32_e32 v7, 1, v7
		v_mov_b32_e32 v8, 2
		v_mul_lo_u32 v8, v8, v7
		v_lshrrev_b32_e32 v7, 2, v0
		v_and_b32_e32 v7, 1, v7
		v_mov_b32_e32 v10, 4
		v_mul_lo_u32 v10, v10, v7
		v_bitop3_b32 v1, v1, v8, v10 bitop3:0x96
		v_lshrrev_b32_e32 v7, 3, v0
		v_and_b32_e32 v7, 1, v7
		v_mov_b32_e32 v8, 8
		v_mul_lo_u32 v8, v8, v7
		v_xor_b32_e32 v1, v1, v8
		v_lshrrev_b32_e32 v7, 4, v0
		v_and_b32_e32 v7, 1, v7
		v_mov_b32_e32 v8, 16
		v_mul_lo_u32 v8, v8, v7
		v_lshrrev_b32_e32 v7, 6, v0
		v_and_b32_e32 v7, 1, v7
		v_mov_b32_e32 v10, 32
		v_mul_lo_u32 v10, v10, v7
		v_bitop3_b32 v1, v1, v8, v10 bitop3:0x96
		v_lshrrev_b32_e32 v7, 7, v0
		v_and_b32_e32 v7, 1, v7
		v_mov_b32_e32 v8, 64
		v_mul_lo_u32 v8, v8, v7
		v_xor_b32_e32 v1, v1, v8
		v_add_u32_e32 v1, s47, v1
		v_and_b32_e32 v7, 1, v0
		v_xor_b32_e32 v7, 0x80, v7
		v_lshrrev_b32_e32 v8, 1, v0
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v10, 2
		v_mul_lo_u32 v10, v10, v8
		v_xor_b32_e32 v7, v7, v10
		v_lshrrev_b32_e32 v8, 2, v0
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v10, 4
		v_mul_lo_u32 v10, v10, v8
		v_xor_b32_e32 v7, v7, v10
		v_lshrrev_b32_e32 v8, 3, v0
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v10, 8
		v_mul_lo_u32 v10, v10, v8
		v_lshrrev_b32_e32 v8, 4, v0
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v11, 16
		v_mul_lo_u32 v11, v11, v8
		v_bitop3_b32 v7, v7, v10, v11 bitop3:0x96
		v_lshrrev_b32_e32 v8, 6, v0
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v10, 32
		v_mul_lo_u32 v10, v10, v8
		v_lshrrev_b32_e32 v8, 7, v0
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v11, 64
		v_mul_lo_u32 v11, v11, v8
		v_bitop3_b32 v7, v7, v10, v11 bitop3:0x96
		v_add_u32_e32 v7, s47, v7
		v_cmp_lt_i32_e64 vcc, v1, s23
		s_mov_b64 s[48:49], vcc
		v_cmp_lt_i32_e64 vcc, v7, s23
		s_mov_b64 s[50:51], vcc
		v_lshrrev_b32_e32 v1, 3, v0
		v_and_b32_e32 v1, 1, v1
		v_lshrrev_b32_e32 v7, 4, v0
		v_and_b32_e32 v7, 1, v7
		v_mov_b32_e32 v8, 2
		v_mul_lo_u32 v8, v8, v7
		v_lshrrev_b32_e32 v7, 5, v0
		v_and_b32_e32 v7, 1, v7
		v_mov_b32_e32 v10, 4
		v_mul_lo_u32 v10, v10, v7
		v_bitop3_b32 v1, v1, v8, v10 bitop3:0x96
		v_lshrrev_b32_e32 v7, 6, v0
		v_and_b32_e32 v7, 1, v7
		v_mov_b32_e32 v8, 8
		v_mul_lo_u32 v8, v8, v7
		v_lshrrev_b32_e32 v7, 7, v0
		v_and_b32_e32 v7, 1, v7
		v_mov_b32_e32 v10, 16
		v_mul_lo_u32 v10, v10, v7
		v_bitop3_b32 v1, v1, v8, v10 bitop3:0x96
		v_add_u32_e32 v1, s47, v1
		v_cmp_lt_i32_e64 vcc, v1, s23
		s_mov_b64 s[52:53], vcc
		s_mul_i32 s54, s46, s12
		s_lshl_b32 s54, s54, 9
		s_mul_i32 s55, s1, s10
		s_lshl_b32 s55, s55, 1
		s_add_i32 s54, s54, s55
		s_mul_i32 s55, s25, s11
		s_lshl_b32 s55, s55, 1
		s_add_i32 s54, s54, s55
		v_lshrrev_b32_e32 v1, 7, v0
		v_mul_lo_u32 v1, s12, v1
		v_lshlrev_b32_e32 v1, 5, v1
		v_lshrrev_b32_e32 v7, 6, v0
		v_and_b32_e32 v7, 1, v7
		v_mul_lo_u32 v7, s12, v7
		v_lshlrev_b32_e32 v7, 4, v7
		v_add3_u32 v1, s54, v1, v7
		v_lshrrev_b32_e32 v7, 5, v0
		v_and_b32_e32 v7, 1, v7
		v_mul_lo_u32 v7, s12, v7
		v_lshlrev_b32_e32 v7, 3, v7
		v_lshrrev_b32_e32 v8, 4, v0
		v_and_b32_e32 v8, 1, v8
		v_mul_lo_u32 v8, s12, v8
		v_lshlrev_b32_e32 v8, 2, v8
		v_add3_u32 v1, v1, v7, v8
		v_and_b32_e32 v7, 1, v0
		v_lshlrev_b32_e32 v7, 4, v7
		v_lshrrev_b32_e32 v8, 3, v0
		v_and_b32_e32 v8, 1, v8
		v_mul_lo_u32 v8, s12, v8
		v_lshlrev_b32_e32 v8, 1, v8
		v_add3_u32 v1, v1, v8, v7
		v_lshrrev_b32_e32 v8, 2, v0
		v_and_b32_e32 v8, 1, v8
		v_lshlrev_b32_e32 v8, 6, v8
		v_lshrrev_b32_e32 v10, 1, v0
		v_and_b32_e32 v10, 1, v10
		v_lshlrev_b32_e32 v10, 5, v10
		v_add3_u32 v1, v1, v8, v10
		v_mov_b32_e32 v11, 0x80000000
		v_cndmask_b32_e64 v1, v11, v1, s[52:53]
		buffer_load_dwordx4 v[16:19], v1, s[40:43], 0 offen
		v_lshrrev_b32_e32 v1, 3, v0
		v_and_b32_e32 v1, 1, v1
		v_lshrrev_b32_e32 v12, 4, v0
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v15, 2
		v_mul_lo_u32 v15, v15, v12
		v_bitop3_b32 v1, 32, v1, v15 bitop3:0x96
		v_lshrrev_b32_e32 v12, 5, v0
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v15, 4
		v_mul_lo_u32 v15, v15, v12
		v_xor_b32_e32 v1, v1, v15
		v_lshrrev_b32_e32 v12, 6, v0
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v15, 8
		v_mul_lo_u32 v15, v15, v12
		v_lshrrev_b32_e32 v12, 7, v0
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v20, 16
		v_mul_lo_u32 v20, v20, v12
		v_bitop3_b32 v1, v1, v15, v20 bitop3:0x96
		v_add_u32_e32 v1, s47, v1
		v_cmp_lt_i32_e64 vcc, v1, s23
		s_mov_b64 s[52:53], vcc
		v_lshrrev_b32_e32 v1, 7, v0
		v_lshlrev_b32_e32 v1, 4, v1
		v_lshrrev_b32_e32 v12, 6, v0
		v_and_b32_e32 v12, 1, v12
		v_lshlrev_b32_e32 v12, 3, v12
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
		v_bitop3_b32 v1, v1, v12, v15 bitop3:0x96
		v_mul_lo_u32 v1, s12, v1
		v_lshlrev_b32_e32 v1, 1, v1
		v_add3_u32 v1, s54, v1, v7
		v_add3_u32 v1, v1, v8, v10
		v_cndmask_b32_e64 v1, v11, v1, s[52:53]
		buffer_load_dwordx4 v[24:27], v1, s[40:43], 0 offen
		v_lshrrev_b32_e32 v1, 3, v0
		v_and_b32_e32 v1, 1, v1
		v_lshrrev_b32_e32 v12, 4, v0
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v15, 2
		v_mul_lo_u32 v15, v15, v12
		v_bitop3_b32 v1, 64, v1, v15 bitop3:0x96
		v_lshrrev_b32_e32 v12, 5, v0
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v15, 4
		v_mul_lo_u32 v15, v15, v12
		v_xor_b32_e32 v1, v1, v15
		v_lshrrev_b32_e32 v12, 6, v0
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v15, 8
		v_mul_lo_u32 v15, v15, v12
		v_lshrrev_b32_e32 v12, 7, v0
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v20, 16
		v_mul_lo_u32 v20, v20, v12
		v_bitop3_b32 v1, v1, v15, v20 bitop3:0x96
		v_add_u32_e32 v1, s47, v1
		v_cmp_lt_i32_e64 vcc, v1, s23
		s_mov_b64 s[52:53], vcc
		v_add3_u32 v1, v7, v8, v10
		v_lshrrev_b32_e32 v12, 7, v0
		v_lshlrev_b32_e32 v12, 4, v12
		v_lshrrev_b32_e32 v15, 6, v0
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 3, v15
		v_lshrrev_b32_e32 v20, 5, v0
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v20, 2, v20
		v_lshrrev_b32_e32 v21, 3, v0
		v_and_b32_e32 v21, 1, v21
		v_add_u32_e32 v21, 64, v21
		v_lshrrev_b32_e32 v23, 4, v0
		v_and_b32_e32 v23, 1, v23
		v_lshlrev_b32_e32 v23, 1, v23
		v_bitop3_b32 v20, v20, v21, v23 bitop3:0x96
		v_bitop3_b32 v12, v12, v15, v20 bitop3:0x96
		v_mul_lo_u32 v12, s12, v12
		v_lshlrev_b32_e32 v12, 1, v12
		v_add3_u32 v12, v12, v1, s54
		v_cndmask_b32_e64 v12, v11, v12, s[52:53]
		buffer_load_dwordx4 v[32:35], v12, s[40:43], 0 offen
		v_lshrrev_b32_e32 v12, 3, v0
		v_and_b32_e32 v12, 1, v12
		v_xor_b32_e32 v12, 0x60, v12
		v_lshrrev_b32_e32 v15, 4, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v20, 2
		v_mul_lo_u32 v20, v20, v15
		v_xor_b32_e32 v12, v12, v20
		v_lshrrev_b32_e32 v15, 5, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v20, 4
		v_mul_lo_u32 v20, v20, v15
		v_xor_b32_e32 v12, v12, v20
		v_lshrrev_b32_e32 v15, 6, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v20, 8
		v_mul_lo_u32 v20, v20, v15
		v_lshrrev_b32_e32 v15, 7, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v21, 16
		v_mul_lo_u32 v21, v21, v15
		v_bitop3_b32 v12, v12, v20, v21 bitop3:0x96
		v_add_u32_e32 v12, s47, v12
		v_cmp_lt_i32_e64 vcc, v12, s23
		s_mov_b64 s[52:53], vcc
		v_lshrrev_b32_e32 v12, 7, v0
		v_lshlrev_b32_e32 v12, 4, v12
		v_lshrrev_b32_e32 v15, 6, v0
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 3, v15
		v_lshrrev_b32_e32 v20, 5, v0
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v20, 2, v20
		v_lshrrev_b32_e32 v21, 3, v0
		v_and_b32_e32 v21, 1, v21
		v_add_u32_e32 v21, 0x60, v21
		v_lshrrev_b32_e32 v23, 4, v0
		v_and_b32_e32 v23, 1, v23
		v_lshlrev_b32_e32 v23, 1, v23
		v_bitop3_b32 v20, v20, v21, v23 bitop3:0x96
		v_bitop3_b32 v12, v12, v15, v20 bitop3:0x96
		v_mul_lo_u32 v12, s12, v12
		v_lshlrev_b32_e32 v12, 1, v12
		v_add3_u32 v12, v12, v1, s54
		v_cndmask_b32_e64 v12, v11, v12, s[52:53]
		buffer_load_dwordx4 v[40:43], v12, s[40:43], 0 offen
		v_lshrrev_b32_e32 v12, 3, v0
		v_and_b32_e32 v12, 1, v12
		v_xor_b32_e32 v12, 0x80, v12
		v_lshrrev_b32_e32 v15, 4, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v20, 2
		v_mul_lo_u32 v20, v20, v15
		v_xor_b32_e32 v12, v12, v20
		v_lshrrev_b32_e32 v15, 5, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v20, 4
		v_mul_lo_u32 v20, v20, v15
		v_xor_b32_e32 v12, v12, v20
		v_lshrrev_b32_e32 v15, 6, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v20, 8
		v_mul_lo_u32 v20, v20, v15
		v_lshrrev_b32_e32 v15, 7, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v21, 16
		v_mul_lo_u32 v21, v21, v15
		v_bitop3_b32 v12, v12, v20, v21 bitop3:0x96
		v_add_u32_e32 v12, s47, v12
		v_cmp_lt_i32_e64 vcc, v12, s23
		s_mov_b64 s[52:53], vcc
		v_lshrrev_b32_e32 v12, 7, v0
		v_lshlrev_b32_e32 v12, 4, v12
		v_lshrrev_b32_e32 v15, 6, v0
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 3, v15
		v_lshrrev_b32_e32 v20, 5, v0
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v20, 2, v20
		v_lshrrev_b32_e32 v21, 3, v0
		v_and_b32_e32 v21, 1, v21
		v_add_u32_e32 v21, 0x80, v21
		v_lshrrev_b32_e32 v23, 4, v0
		v_and_b32_e32 v23, 1, v23
		v_lshlrev_b32_e32 v23, 1, v23
		v_bitop3_b32 v20, v20, v21, v23 bitop3:0x96
		v_bitop3_b32 v12, v12, v15, v20 bitop3:0x96
		v_mul_lo_u32 v12, s12, v12
		v_lshlrev_b32_e32 v12, 1, v12
		v_add3_u32 v1, v12, v1, s54
		v_cndmask_b32_e64 v1, v11, v1, s[52:53]
		buffer_load_dwordx4 v[44:47], v1, s[40:43], 0 offen
		v_lshrrev_b32_e32 v1, 3, v0
		v_and_b32_e32 v1, 1, v1
		v_xor_b32_e32 v1, 0xa0, v1
		v_lshrrev_b32_e32 v12, 4, v0
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v15, 2
		v_mul_lo_u32 v15, v15, v12
		v_xor_b32_e32 v1, v1, v15
		v_lshrrev_b32_e32 v12, 5, v0
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v15, 4
		v_mul_lo_u32 v15, v15, v12
		v_xor_b32_e32 v1, v1, v15
		v_lshrrev_b32_e32 v12, 6, v0
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v15, 8
		v_mul_lo_u32 v15, v15, v12
		v_lshrrev_b32_e32 v12, 7, v0
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v20, 16
		v_mul_lo_u32 v20, v20, v12
		v_bitop3_b32 v1, v1, v15, v20 bitop3:0x96
		v_add_u32_e32 v1, s47, v1
		v_cmp_lt_i32_e64 vcc, v1, s23
		s_mov_b64 s[52:53], vcc
		v_add3_u32 v1, v7, v8, v10
		v_lshrrev_b32_e32 v7, 7, v0
		v_lshlrev_b32_e32 v7, 4, v7
		v_lshrrev_b32_e32 v8, 6, v0
		v_and_b32_e32 v8, 1, v8
		v_lshlrev_b32_e32 v8, 3, v8
		v_lshrrev_b32_e32 v10, 5, v0
		v_and_b32_e32 v10, 1, v10
		v_lshlrev_b32_e32 v10, 2, v10
		v_lshrrev_b32_e32 v12, 3, v0
		v_and_b32_e32 v12, 1, v12
		v_add_u32_e32 v12, 0xa0, v12
		v_lshrrev_b32_e32 v15, 4, v0
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 1, v15
		v_bitop3_b32 v10, v10, v12, v15 bitop3:0x96
		v_bitop3_b32 v7, v7, v8, v10 bitop3:0x96
		v_mul_lo_u32 v7, s12, v7
		v_lshlrev_b32_e32 v7, 1, v7
		v_add3_u32 v7, v7, v1, s54
		v_cndmask_b32_e64 v7, v11, v7, s[52:53]
		buffer_load_dwordx4 v[80:83], v7, s[40:43], 0 offen
		v_lshrrev_b32_e32 v7, 3, v0
		v_and_b32_e32 v7, 1, v7
		v_xor_b32_e32 v7, 0xc0, v7
		v_lshrrev_b32_e32 v8, 4, v0
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v10, 2
		v_mul_lo_u32 v10, v10, v8
		v_xor_b32_e32 v7, v7, v10
		v_lshrrev_b32_e32 v8, 5, v0
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v10, 4
		v_mul_lo_u32 v10, v10, v8
		v_xor_b32_e32 v7, v7, v10
		v_lshrrev_b32_e32 v8, 6, v0
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v10, 8
		v_mul_lo_u32 v10, v10, v8
		v_lshrrev_b32_e32 v8, 7, v0
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v12, 16
		v_mul_lo_u32 v12, v12, v8
		v_bitop3_b32 v7, v7, v10, v12 bitop3:0x96
		v_add_u32_e32 v7, s47, v7
		v_cmp_lt_i32_e64 vcc, v7, s23
		s_mov_b64 s[52:53], vcc
		v_lshrrev_b32_e32 v7, 7, v0
		v_lshlrev_b32_e32 v7, 4, v7
		v_lshrrev_b32_e32 v8, 6, v0
		v_and_b32_e32 v8, 1, v8
		v_lshlrev_b32_e32 v8, 3, v8
		v_lshrrev_b32_e32 v10, 5, v0
		v_and_b32_e32 v10, 1, v10
		v_lshlrev_b32_e32 v10, 2, v10
		v_lshrrev_b32_e32 v12, 3, v0
		v_and_b32_e32 v12, 1, v12
		v_add_u32_e32 v12, 0xc0, v12
		v_lshrrev_b32_e32 v15, 4, v0
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 1, v15
		v_bitop3_b32 v10, v10, v12, v15 bitop3:0x96
		v_bitop3_b32 v7, v7, v8, v10 bitop3:0x96
		v_mul_lo_u32 v7, s12, v7
		v_lshlrev_b32_e32 v7, 1, v7
		v_add3_u32 v7, v7, v1, s54
		v_cndmask_b32_e64 v7, v11, v7, s[52:53]
		buffer_load_dwordx4 v[84:87], v7, s[40:43], 0 offen
		v_lshrrev_b32_e32 v7, 3, v0
		v_and_b32_e32 v7, 1, v7
		v_xor_b32_e32 v7, 0xe0, v7
		v_lshrrev_b32_e32 v8, 4, v0
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v10, 2
		v_mul_lo_u32 v10, v10, v8
		v_xor_b32_e32 v7, v7, v10
		v_lshrrev_b32_e32 v8, 5, v0
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v10, 4
		v_mul_lo_u32 v10, v10, v8
		v_xor_b32_e32 v7, v7, v10
		v_lshrrev_b32_e32 v8, 6, v0
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v10, 8
		v_mul_lo_u32 v10, v10, v8
		v_lshrrev_b32_e32 v8, 7, v0
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v12, 16
		v_mul_lo_u32 v12, v12, v8
		v_bitop3_b32 v7, v7, v10, v12 bitop3:0x96
		v_add_u32_e32 v7, s47, v7
		v_cmp_lt_i32_e64 vcc, v7, s23
		v_lshrrev_b32_e32 v7, 7, v0
		v_lshlrev_b32_e32 v7, 4, v7
		v_lshrrev_b32_e32 v8, 6, v0
		v_and_b32_e32 v8, 1, v8
		v_lshlrev_b32_e32 v8, 3, v8
		v_lshrrev_b32_e32 v10, 5, v0
		v_and_b32_e32 v10, 1, v10
		v_lshlrev_b32_e32 v10, 2, v10
		v_lshrrev_b32_e32 v12, 3, v0
		v_and_b32_e32 v12, 1, v12
		v_add_u32_e32 v12, 0xe0, v12
		v_lshrrev_b32_e32 v15, 4, v0
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 1, v15
		v_bitop3_b32 v10, v10, v12, v15 bitop3:0x96
		v_bitop3_b32 v7, v7, v8, v10 bitop3:0x96
		v_mul_lo_u32 v7, s12, v7
		v_lshlrev_b32_e32 v7, 1, v7
		v_add3_u32 v1, v7, v1, s54
		v_rcp_f32_e32 v20, v36
		v_cndmask_b32_e32 v1, v11, v1, vcc
		buffer_load_dwordx4 v[88:91], v1, s[40:43], 0 offen
		s_waitcnt vmcnt(8)
		s_barrier
		v_lshrrev_b32_e32 v1, 6, v0
		v_and_b32_e32 v1, 1, v1
		v_lshlrev_b32_e32 v1, 2, v1
		v_lshrrev_b32_e32 v7, 5, v0
		v_and_b32_e32 v7, 1, v7
		v_lshlrev_b32_e32 v7, 1, v7
		v_lshrrev_b32_e32 v8, 4, v0
		v_and_b32_e32 v8, 1, v8
		v_xor_b32_e32 v8, v0, v8
		v_bitop3_b32 v1, v1, v7, v8 bitop3:0x96
		v_lshlrev_b32_e32 v1, 4, v1
		v_add_u32_e32 v1, 0x10000, v1
		s_waitcnt vmcnt(7)
		ds_write_b128 v1, v[16:19] offset:18864
		s_waitcnt vmcnt(6)
		ds_write_b128 v1, v[24:27] offset:22960
		s_waitcnt vmcnt(5)
		ds_write_b128 v1, v[32:35] offset:27056
		s_waitcnt vmcnt(4)
		ds_write_b128 v1, v[40:43] offset:31152
		v_mov_b32_e32 v21, v20
		v_pk_mul_f32 v[16:17], v[48:49], v[20:21]
		v_pk_mul_f32 v[18:19], v[50:51], v[20:21]
		v_pk_mul_f32 v[24:25], v[52:53], v[20:21]
		v_pk_mul_f32 v[26:27], v[54:55], v[20:21]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_pk_mul_f32 v[28:29], v[56:57], v[20:21]
		v_pk_mul_f32 v[32:33], v[58:59], v[20:21]
		v_pk_mul_f32 v[34:35], v[60:61], v[20:21]
		v_pk_mul_f32 v[38:39], v[62:63], v[20:21]
		v_pk_mul_f32 v[40:41], v[64:65], v[20:21]
		v_pk_mul_f32 v[42:43], v[66:67], v[20:21]
		v_pk_mul_f32 v[48:49], v[68:69], v[20:21]
		v_pk_mul_f32 v[50:51], v[70:71], v[20:21]
		v_pk_mul_f32 v[52:53], v[72:73], v[20:21]
		v_pk_mul_f32 v[54:55], v[74:75], v[20:21]
		v_pk_mul_f32 v[56:57], v[76:77], v[20:21]
		v_pk_mul_f32 v[58:59], v[78:79], v[20:21]
		v_rcp_f32_e32 v20, v37
		v_cvt_pk_bf16_f32 v60, v16, v17
		v_mov_b32_e32 v21, v20
		v_accvgpr_read_b32 v16, a48
		v_accvgpr_read_b32 v17, a49
		v_pk_mul_f32 v[36:37], v[16:17], v[20:21]
		v_accvgpr_read_b32 v16, a50
		v_accvgpr_read_b32 v17, a51
		v_pk_mul_f32 v[64:65], v[16:17], v[20:21]
		v_accvgpr_read_b32 v16, a52
		v_accvgpr_read_b32 v17, a53
		v_pk_mul_f32 v[66:67], v[16:17], v[20:21]
		v_accvgpr_read_b32 v16, a54
		v_accvgpr_read_b32 v17, a55
		v_pk_mul_f32 v[68:69], v[16:17], v[20:21]
		v_accvgpr_read_b32 v16, a56
		v_accvgpr_read_b32 v17, a57
		v_pk_mul_f32 v[70:71], v[16:17], v[20:21]
		v_accvgpr_read_b32 v16, a58
		v_accvgpr_read_b32 v17, a59
		v_pk_mul_f32 v[72:73], v[16:17], v[20:21]
		v_accvgpr_read_b32 v16, a60
		v_accvgpr_read_b32 v17, a61
		v_pk_mul_f32 v[74:75], v[16:17], v[20:21]
		v_accvgpr_read_b32 v16, a62
		v_accvgpr_read_b32 v17, a63
		v_pk_mul_f32 v[76:77], v[16:17], v[20:21]
		v_accvgpr_read_b32 v16, a64
		v_accvgpr_read_b32 v17, a65
		v_pk_mul_f32 v[78:79], v[16:17], v[20:21]
		v_accvgpr_read_b32 v16, a66
		v_accvgpr_read_b32 v17, a67
		v_pk_mul_f32 v[92:93], v[16:17], v[20:21]
		v_accvgpr_read_b32 v16, a68
		v_accvgpr_read_b32 v17, a69
		v_pk_mul_f32 v[94:95], v[16:17], v[20:21]
		v_accvgpr_read_b32 v16, a70
		v_accvgpr_read_b32 v17, a71
		v_pk_mul_f32 v[96:97], v[16:17], v[20:21]
		v_accvgpr_read_b32 v16, a72
		v_accvgpr_read_b32 v17, a73
		v_pk_mul_f32 v[98:99], v[16:17], v[20:21]
		v_accvgpr_read_b32 v16, a74
		v_accvgpr_read_b32 v17, a75
		v_pk_mul_f32 v[100:101], v[16:17], v[20:21]
		v_accvgpr_read_b32 v16, a76
		v_accvgpr_read_b32 v17, a77
		v_pk_mul_f32 v[102:103], v[16:17], v[20:21]
		v_accvgpr_read_b32 v16, a78
		v_accvgpr_read_b32 v17, a79
		v_pk_mul_f32 v[104:105], v[16:17], v[20:21]
		v_cvt_pk_bf16_f32 v61, v18, v19
		v_cvt_pk_bf16_f32 v62, v24, v25
		v_cvt_pk_bf16_f32 v63, v26, v27
		v_cvt_pk_bf16_f32 v16, v28, v29
		v_cvt_pk_bf16_f32 v17, v32, v33
		v_cvt_pk_bf16_f32 v18, v34, v35
		v_cvt_pk_bf16_f32 v19, v38, v39
		v_cvt_pk_bf16_f32 v24, v40, v41
		v_cvt_pk_bf16_f32 v25, v42, v43
		v_cvt_pk_bf16_f32 v26, v48, v49
		v_cvt_pk_bf16_f32 v27, v50, v51
		v_cvt_pk_bf16_f32 v32, v52, v53
		v_cvt_pk_bf16_f32 v33, v54, v55
		v_cvt_pk_bf16_f32 v34, v56, v57
		v_cvt_pk_bf16_f32 v35, v58, v59
		v_cvt_pk_bf16_f32 v40, v36, v37
		v_cvt_pk_bf16_f32 v41, v64, v65
		v_cvt_pk_bf16_f32 v42, v66, v67
		v_cvt_pk_bf16_f32 v43, v68, v69
		v_cvt_pk_bf16_f32 v36, v70, v71
		v_cvt_pk_bf16_f32 v37, v72, v73
		v_cvt_pk_bf16_f32 v38, v74, v75
		v_cvt_pk_bf16_f32 v39, v76, v77
		v_cvt_pk_bf16_f32 v48, v78, v79
		v_cvt_pk_bf16_f32 v49, v92, v93
		v_cvt_pk_bf16_f32 v50, v94, v95
		v_cvt_pk_bf16_f32 v51, v96, v97
		v_cvt_pk_bf16_f32 v52, v98, v99
		v_cvt_pk_bf16_f32 v53, v100, v101
		v_cvt_pk_bf16_f32 v54, v102, v103
		v_cvt_pk_bf16_f32 v55, v104, v105
		v_permlane32_swap_b32_e32 v60, v62
		v_permlane32_swap_b32_e32 v61, v63
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_permlane32_swap_b32_e32 v32, v34
		v_permlane32_swap_b32_e32 v33, v35
		v_permlane32_swap_b32_e32 v40, v42
		v_permlane32_swap_b32_e32 v41, v43
		v_permlane32_swap_b32_e32 v36, v38
		v_permlane32_swap_b32_e32 v37, v39
		v_permlane32_swap_b32_e32 v48, v50
		v_permlane32_swap_b32_e32 v49, v51
		v_permlane32_swap_b32_e32 v52, v54
		v_permlane32_swap_b32_e32 v53, v55
		v_lshrrev_b32_e32 v7, 7, v0
		v_readfirstlane_b32 s40, v2
		s_nop 1
		v_mul_lo_u32 v8, s40, v7
		v_lshlrev_b32_e32 v8, 7, v8
		v_and_b32_e32 v10, 1, v0
		v_readfirstlane_b32 s40, v2
		s_nop 1
		v_mul_lo_u32 v12, s40, v10
		v_lshlrev_b32_e32 v12, 1, v12
		v_add3_u32 v15, s27, v8, v12
		v_lshrrev_b32_e32 v20, 6, v0
		v_and_b32_e32 v20, 1, v20
		v_readfirstlane_b32 s40, v2
		s_nop 1
		v_mul_lo_u32 v21, s40, v20
		v_lshlrev_b32_e32 v21, 6, v21
		v_lshrrev_b32_e32 v23, 4, v0
		v_and_b32_e32 v23, 1, v23
		v_readfirstlane_b32 s40, v2
		s_nop 1
		v_mul_lo_u32 v28, s40, v23
		v_lshlrev_b32_e32 v28, 5, v28
		v_add3_u32 v15, v15, v21, v28
		v_lshrrev_b32_e32 v29, 3, v0
		v_and_b32_e32 v29, 1, v29
		v_readfirstlane_b32 s40, v2
		s_nop 1
		v_mul_lo_u32 v30, s40, v29
		v_lshlrev_b32_e32 v30, 4, v30
		v_lshrrev_b32_e32 v56, 2, v0
		v_and_b32_e32 v56, 1, v56
		v_readfirstlane_b32 s40, v2
		s_nop 1
		v_mul_lo_u32 v57, s40, v56
		v_lshlrev_b32_e32 v57, 3, v57
		v_add3_u32 v15, v15, v30, v57
		v_lshrrev_b32_e32 v58, 1, v0
		v_and_b32_e32 v58, 1, v58
		v_readfirstlane_b32 s40, v2
		s_nop 1
		v_mul_lo_u32 v59, s40, v58
		v_lshlrev_b32_e32 v59, 2, v59
		v_lshrrev_b32_e32 v64, 5, v0
		v_and_b32_e32 v64, 1, v64
		v_lshlrev_b32_e32 v64, 4, v64
		v_add3_u32 v15, v15, v59, v64
		v_accvgpr_read_b32 v65, a2
		s_nop 0
		v_readfirstlane_b32 s40, v65
		v_accvgpr_read_b32 v65, a3
		s_nop 0
		v_readfirstlane_b32 s41, v65
		s_nop 1
		v_cndmask_b32_e64 v15, v11, v15, s[40:41]
		s_mov_b32 s40, s8
		s_mov_b32 s41, s9
		s_mov_b32 s42, s30
		s_mov_b32 s43, s31
		buffer_store_dwordx4 v[60:63], v15, s[40:43], 0 offen
		v_add3_u32 v15, s44, v8, v12
		v_add3_u32 v15, v15, v21, v28
		v_add3_u32 v15, v15, v30, v57
		v_add3_u32 v15, v15, v59, v64
		v_accvgpr_read_b32 v60, a2
		s_nop 0
		v_readfirstlane_b32 s52, v60
		v_accvgpr_read_b32 v60, a3
		s_nop 0
		v_readfirstlane_b32 s53, v60
		s_nop 1
		v_cndmask_b32_e64 v15, v11, v15, s[52:53]
		buffer_store_dwordx4 v[16:19], v15, s[40:43], 0 offen
		v_add3_u32 v15, s45, v8, v12
		v_add3_u32 v15, v15, v21, v28
		v_add3_u32 v15, v15, v30, v57
		v_add3_u32 v15, v15, v59, v64
		v_accvgpr_read_b32 v16, a2
		s_nop 0
		v_readfirstlane_b32 s52, v16
		v_accvgpr_read_b32 v16, a3
		s_nop 0
		v_readfirstlane_b32 s53, v16
		s_nop 1
		v_cndmask_b32_e64 v15, v11, v15, s[52:53]
		buffer_store_dwordx4 v[24:27], v15, s[40:43], 0 offen
		v_add3_u32 v15, s22, v8, v12
		v_add3_u32 v15, v15, v21, v28
		v_add3_u32 v15, v15, v30, v57
		v_add3_u32 v15, v15, v59, v64
		v_accvgpr_read_b32 v16, a2
		s_nop 0
		v_readfirstlane_b32 s52, v16
		v_accvgpr_read_b32 v16, a3
		s_nop 0
		v_readfirstlane_b32 s53, v16
		s_nop 1
		v_cndmask_b32_e64 v15, v11, v15, s[52:53]
		buffer_store_dwordx4 v[32:35], v15, s[40:43], 0 offen
		v_lshlrev_b32_e32 v7, 6, v7
		v_lshlrev_b32_e32 v15, 5, v20
		v_lshlrev_b32_e32 v16, 4, v23
		v_lshlrev_b32_e32 v17, 3, v29
		v_lshlrev_b32_e32 v18, 2, v56
		v_add_u32_e32 v10, 0x80, v10
		v_lshlrev_b32_e32 v19, 1, v58
		v_bitop3_b32 v10, v18, v10, v19 bitop3:0x96
		v_bitop3_b32 v10, v16, v17, v10 bitop3:0x96
		v_bitop3_b32 v7, v7, v15, v10 bitop3:0x96
		v_readfirstlane_b32 s52, v2
		s_nop 1
		v_mul_lo_u32 v7, s52, v7
		v_lshlrev_b32_e32 v7, 1, v7
		v_add3_u32 v10, s27, v7, v64
		v_accvgpr_read_b32 v15, a4
		s_nop 0
		v_readfirstlane_b32 s52, v15
		v_accvgpr_read_b32 v15, a5
		s_nop 0
		v_readfirstlane_b32 s53, v15
		s_nop 1
		v_cndmask_b32_e64 v10, v11, v10, s[52:53]
		buffer_store_dwordx4 v[40:43], v10, s[40:43], 0 offen
		v_add3_u32 v10, s44, v7, v64
		v_accvgpr_read_b32 v15, a4
		s_nop 0
		v_readfirstlane_b32 s52, v15
		v_accvgpr_read_b32 v15, a5
		s_nop 0
		v_readfirstlane_b32 s53, v15
		s_nop 1
		v_cndmask_b32_e64 v10, v11, v10, s[52:53]
		buffer_store_dwordx4 v[36:39], v10, s[40:43], 0 offen
		v_add3_u32 v10, s45, v7, v64
		v_accvgpr_read_b32 v15, a4
		s_nop 0
		v_readfirstlane_b32 s44, v15
		v_accvgpr_read_b32 v15, a5
		s_nop 0
		v_readfirstlane_b32 s45, v15
		s_nop 1
		v_cndmask_b32_e64 v10, v11, v10, s[44:45]
		buffer_store_dwordx4 v[48:51], v10, s[40:43], 0 offen
		v_add3_u32 v10, s22, v7, v64
		v_accvgpr_read_b32 v15, a4
		s_nop 0
		v_readfirstlane_b32 s44, v15
		v_accvgpr_read_b32 v15, a5
		s_nop 0
		v_readfirstlane_b32 s45, v15
		s_nop 1
		v_cndmask_b32_e64 v10, v11, v10, s[44:45]
		buffer_store_dwordx4 v[52:55], v10, s[40:43], 0 offen
		v_lshrrev_b32_e32 v10, 6, v0
		v_and_b32_e32 v10, 1, v10
		v_lshlrev_b32_e32 v10, 3, v10
		v_add_u32_e32 v10, 32, v10
		v_lshrrev_b32_e32 v15, 7, v0
		v_lshlrev_b32_e32 v15, 4, v15
		v_xor_b32_e32 v10, v10, v15
		v_lshrrev_b32_e32 v10, 5, v10
		v_and_b32_e32 v10, 1, v10
		v_lshlrev_b32_e32 v10, 14, v10
		v_add_u32_e32 v10, 0x10000, v10
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
		ds_read_b128 a[8:11], v15 offset:18864
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
		ds_read_b128 a[12:15], v15 offset:18864
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
		ds_read_b128 a[16:19], v15 offset:18864
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
		ds_read_b128 a[20:23], v15 offset:18864
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
		v_add3_u32 v10, v10, v15, v16
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
		v_lshl_add_u32 v15, v15, 4, v10
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
		v_lshl_add_u32 v16, v16, 4, v10
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
		v_lshrrev_b32_e32 v23, 5, v18
		v_and_b32_e32 v23, 1, v23
		v_lshlrev_b32_e32 v23, 1, v23
		v_lshrrev_b32_e32 v17, 4, v17
		v_and_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v20, 6, v20
		v_lshl_add_u32 v17, v17, 7, v20
		v_add_u32_e32 v17, v17, v18
		v_lshrrev_b32_e32 v18, 4, v18
		v_bitop3_b32 v17, v17, v18, 1 bitop3:0x78
		v_bitop3_b32 v17, v19, v23, v17 bitop3:0x96
		v_lshl_add_u32 v17, v17, 4, v10
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(3)
		ds_write_b128 v1, v[44:47] offset:18864
		s_waitcnt vmcnt(2)
		ds_write_b128 v1, v[80:83] offset:22960
		s_waitcnt vmcnt(1)
		ds_write_b128 v1, v[84:87] offset:27056
		s_waitcnt vmcnt(0)
		ds_write_b128 v1, v[88:91] offset:31152
		v_and_b32_e32 v1, 63, v0
		v_lshrrev_b32_e32 v18, 2, v1
		v_and_b32_e32 v18, 1, v18
		v_lshlrev_b32_e32 v18, 5, v18
		v_add_u32_e32 v18, 6, v18
		v_lshrrev_b32_e32 v19, 1, v1
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 4, v19
		v_and_b32_e32 v20, 1, v1
		v_lshlrev_b32_e32 v20, 3, v20
		v_add3_u32 v18, v18, v19, v20
		v_lshrrev_b32_e32 v19, 5, v1
		v_xor_b32_e32 v18, v18, v19
		v_lshrrev_b32_e32 v19, 6, v18
		v_lshrrev_b32_e32 v20, 3, v1
		v_and_b32_e32 v20, 1, v20
		v_add_u32_e32 v19, v19, v20
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 2, v19
		v_lshrrev_b32_e32 v23, 5, v18
		v_and_b32_e32 v23, 1, v23
		v_lshlrev_b32_e32 v23, 1, v23
		v_lshrrev_b32_e32 v1, 4, v1
		v_and_b32_e32 v1, 1, v1
		v_lshlrev_b32_e32 v20, 6, v20
		v_lshl_add_u32 v1, v1, 7, v20
		v_add_u32_e32 v1, v1, v18
		v_lshrrev_b32_e32 v18, 4, v18
		v_bitop3_b32 v1, v1, v18, 1 bitop3:0x78
		v_bitop3_b32 v1, v19, v23, v1 bitop3:0x96
		v_lshl_add_u32 v1, v1, 4, v10
		s_add_i32 s22, s46, 1
		s_mul_i32 s22, s22, 0x100
		s_lshr_b32 s27, s56, 6
		s_mul_i32 s27, 0x410, s27
		s_mov_b32 m0, s27
		s_waitcnt lgkmcnt(0)
		s_barrier
		buffer_load_dwordx4 v31, s[28:31], 0 offen lds
		ds_read_b128 a[24:27], v15 offset:2480
		ds_read_b128 a[28:31], v16 offset:2480
		ds_read_b128 a[32:35], v17 offset:2480
		ds_read_b128 a[36:39], v1 offset:2480
		v_readfirstlane_b32 s44, v4
		s_add_i32 s22, s22, s44
		s_cmp_lt_i32 s24, s22
		s_cselect_b32 s22, s24, s22
		s_add_i32 s44, s22, 0x7f
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_cmp_lt_i32 s44, 0
		s_cselect_b32 s45, s36, 0
		s_add_i32 s44, s44, s45
		s_ashr_i32 s44, s44, 7
		v_readfirstlane_b32 s45, v4
		s_add_i32 s45, s47, s45
		s_cmp_lt_i32 s45, 0
		s_cselect_b32 s52, s36, 0
		s_add_i32 s45, s45, s52
		s_ashr_i32 s45, s45, 7
		s_cmp_lt_i32 s45, s44
		s_cselect_b32 s45, s45, s44
		s_cmp_gt_i32 s45, 0
		s_cselect_b32 s45, s45, 0
		s_add_i32 m0, m0, 0x1040
		v_readfirstlane_b32 s52, v2
		s_mul_i32 s46, s46, s52
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		v_and_b32_e32 v1, 1, v0
		v_xor_b32_e32 v1, 0x80, v1
		v_lshrrev_b32_e32 v10, 1, v0
		v_and_b32_e32 v10, 1, v10
		v_mov_b32_e32 v14, 2
		v_mul_lo_u32 v14, v14, v10
		v_xor_b32_e32 v1, v1, v14
		v_lshrrev_b32_e32 v10, 2, v0
		v_and_b32_e32 v10, 1, v10
		v_mov_b32_e32 v14, 4
		v_mul_lo_u32 v14, v14, v10
		v_xor_b32_e32 v1, v1, v14
		v_lshrrev_b32_e32 v10, 3, v0
		v_and_b32_e32 v10, 1, v10
		v_mov_b32_e32 v14, 8
		v_mul_lo_u32 v14, v14, v10
		v_lshrrev_b32_e32 v10, 4, v0
		v_and_b32_e32 v10, 1, v10
		v_mov_b32_e32 v15, 16
		v_mul_lo_u32 v15, v15, v10
		v_bitop3_b32 v1, v1, v14, v15 bitop3:0x96
		v_lshrrev_b32_e32 v10, 6, v0
		v_and_b32_e32 v10, 1, v10
		v_mov_b32_e32 v14, 32
		v_mul_lo_u32 v14, v14, v10
		v_lshrrev_b32_e32 v10, 7, v0
		v_and_b32_e32 v10, 1, v10
		v_mov_b32_e32 v15, 64
		v_mul_lo_u32 v15, v15, v10
		v_bitop3_b32 v1, v1, v14, v15 bitop3:0x96
		v_mov_b32_e32 v10, s38
		s_nop 0
		v_readfirstlane_b32 s38, v10
		s_nop 1
		v_add_u32_e32 v1, s38, v1
		v_add_u32_e32 v1, s47, v1
		s_add_i32 m0, s27, 0x2080
		v_and_b32_e32 v10, 1, v0
		v_lshrrev_b32_e32 v14, 1, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 2
		v_mul_lo_u32 v15, v15, v14
		v_lshrrev_b32_e32 v14, 2, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v16, 4
		v_mul_lo_u32 v16, v16, v14
		v_bitop3_b32 v10, v10, v15, v16 bitop3:0x96
		v_lshrrev_b32_e32 v14, 3, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 8
		v_mul_lo_u32 v15, v15, v14
		v_xor_b32_e32 v10, v10, v15
		v_lshrrev_b32_e32 v14, 4, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 16
		v_mul_lo_u32 v15, v15, v14
		v_lshrrev_b32_e32 v14, 6, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v16, 32
		v_mul_lo_u32 v16, v16, v14
		v_bitop3_b32 v10, v10, v15, v16 bitop3:0x96
		v_lshrrev_b32_e32 v14, 7, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 64
		v_mul_lo_u32 v15, v15, v14
		v_xor_b32_e32 v10, v10, v15
		v_mov_b32_e32 v14, s37
		s_nop 0
		v_readfirstlane_b32 s37, v14
		s_nop 1
		v_add_u32_e32 v10, s37, v10
		v_add_u32_e32 v10, s47, v10
		v_accvgpr_read_b32 v14, a6
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		s_mul_i32 s37, s44, 0x80
		s_add_i32 m0, s27, 0x30c0
		s_mul_i32 s38, s45, 0x80
		v_accvgpr_read_b32 v14, a7
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		v_readfirstlane_b32 s44, v13
		s_nop 1
		v_mov_b32_e32 v14, s44
		s_lshr_b32 s44, s56, 6
		s_mul_i32 s44, 0x440, s44
		s_add_i32 m0, s44, 0x81f0
		v_readfirstlane_b32 s45, v13
		s_nop 1
		v_mov_b32_e32 v13, s45
		v_accvgpr_read_b32 v15, a40
		buffer_load_dwordx4 v15, s[32:35], 0 offen lds
		v_readfirstlane_b32 s45, v22
		s_nop 1
		v_mov_b32_e32 v16, s45
		s_add_i32 m0, s44, 0x92f0
		v_readfirstlane_b32 s45, v22
		s_nop 1
		v_mov_b32_e32 v17, s45
		v_accvgpr_read_b32 v15, a41
		buffer_load_dwordx4 v15, s[32:35], 0 offen lds
		s_mov_b32 s45, 0
		s_add_i32 m0, s44, 0xa3f0
		v_mov_b64_e32 v[34:35], 0
		v_accvgpr_read_b32 v15, a42
		buffer_load_dwordx4 v15, s[32:35], 0 offen lds
		v_mov_b64_e32 v[32:33], 0
		s_add_i32 m0, s44, 0xb4f0
		s_cmp_lt_i32 0, s38
		v_accvgpr_read_b32 v15, a43
		buffer_load_dwordx4 v15, s[32:35], 0 offen lds
		v_mov_b64_e32 v[36:37], 0
		v_mov_b64_e32 v[38:39], 0
		v_mov_b64_e32 v[40:41], 0
		v_mov_b64_e32 v[42:43], 0
		v_mov_b64_e32 v[44:45], 0
		v_mov_b64_e32 v[46:47], 0
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
		s_add_i32 s47, s45, 0x80
		s_lshr_b32 s52, s45, 7
		s_and_b32 s53, s52, 1
		s_mul_i32 s54, 0x4100, s53
		v_and_b32_e32 v15, 63, v0
		v_lshrrev_b32_e32 v15, 5, v15
		v_lshlrev_b32_e32 v15, 4, v15
		v_and_b32_e32 v18, 63, v0
		v_and_b32_e32 v18, 31, v18
		v_lshrrev_b32_e32 v18, 4, v18
		v_lshlrev_b32_e32 v18, 9, v18
		v_add3_u32 v15, s54, v15, v18
		v_and_b32_e32 v18, 63, v0
		v_and_b32_e32 v18, 31, v18
		v_lshrrev_b32_e32 v18, 3, v18
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v19, 0x2080
		v_mul_lo_u32 v19, v19, v18
		v_and_b32_e32 v18, 63, v0
		v_and_b32_e32 v18, 31, v18
		v_lshrrev_b32_e32 v18, 2, v18
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v20, 0x1040
		v_mul_lo_u32 v20, v20, v18
		v_add3_u32 v15, v15, v19, v20
		v_and_b32_e32 v18, 63, v0
		v_and_b32_e32 v18, 31, v18
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v19, 0x410
		v_mul_lo_u32 v19, v19, v18
		v_and_b32_e32 v18, 63, v0
		v_and_b32_e32 v18, 31, v18
		v_lshrrev_b32_e32 v18, 1, v18
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v20, 0x820
		v_mul_lo_u32 v20, v20, v18
		v_add3_u32 v15, v15, v20, v19
		ds_read_b128 v[24:27], v15
		ds_read_b128 v[48:51], v15 offset:32
		ds_read_b128 v[52:55], v15 offset:64
		ds_read_b128 v[60:63], v15 offset:96
		ds_read_b128 v[68:71], v15 offset:256
		ds_read_b128 v[72:75], v15 offset:288
		ds_read_b128 v[76:79], v15 offset:320
		ds_read_b128 v[112:115], v15 offset:352
		ds_read_b128 v[116:119], v15 offset:128
		ds_read_b128 v[120:123], v15 offset:160
		ds_read_b128 v[124:127], v15 offset:192
		ds_read_b128 v[128:131], v15 offset:224
		ds_read_b128 v[132:135], v15 offset:384
		ds_read_b128 v[136:139], v15 offset:416
		ds_read_b128 v[140:143], v15 offset:448
		ds_read_b128 v[144:147], v15 offset:480
		s_mul_i32 s53, 0x4400, s53
		v_and_b32_e32 v15, 63, v0
		v_lshrrev_b32_e32 v15, 5, v15
		v_mov_b32_e32 v18, 0x2200
		v_mul_lo_u32 v18, v18, v15
		v_and_b32_e32 v15, 63, v0
		v_and_b32_e32 v15, 31, v15
		v_lshrrev_b32_e32 v15, 4, v15
		v_lshlrev_b32_e32 v15, 5, v15
		v_add3_u32 v15, s53, v18, v15
		v_and_b32_e32 v18, 63, v0
		v_and_b32_e32 v18, 15, v18
		v_lshrrev_b32_e32 v18, 2, v18
		v_mov_b32_e32 v19, 0x440
		v_mul_lo_u32 v19, v19, v18
		v_and_b32_e32 v18, 63, v0
		v_and_b32_e32 v18, 15, v18
		v_and_b32_e32 v18, 3, v18
		v_lshlrev_b32_e32 v18, 3, v18
		v_add3_u32 v15, v15, v19, v18
		ds_read_b64_tr_b16 v[148:149], v15 offset:33264
		ds_read_b64_tr_b16 v[150:151], v15 offset:37616
		ds_read_b64_tr_b16 a[4:5], v15 offset:33392
		ds_read_b64_tr_b16 a[6:7], v15 offset:37744
		ds_read_b64_tr_b16 a[40:41], v15 offset:33520
		ds_read_b64_tr_b16 a[42:43], v15 offset:37872
		ds_read_b64_tr_b16 a[44:45], v15 offset:33648
		ds_read_b64_tr_b16 a[46:47], v15 offset:38000
		ds_read_b64_tr_b16 a[64:65], v15 offset:33776
		ds_read_b64_tr_b16 a[66:67], v15 offset:38128
		ds_read_b64_tr_b16 a[68:69], v15 offset:33904
		ds_read_b64_tr_b16 a[70:71], v15 offset:38256
		ds_read_b64_tr_b16 a[72:73], v15 offset:34032
		ds_read_b64_tr_b16 a[74:75], v15 offset:38384
		ds_read_b64_tr_b16 a[76:77], v15 offset:34160
		ds_read_b64_tr_b16 a[78:79], v15 offset:38512
		ds_read_b64_tr_b16 v[152:153], v15 offset:33328
		ds_read_b64_tr_b16 v[154:155], v15 offset:37680
		ds_read_b64_tr_b16 a[80:81], v15 offset:33456
		ds_read_b64_tr_b16 a[82:83], v15 offset:37808
		ds_read_b64_tr_b16 a[84:85], v15 offset:33584
		ds_read_b64_tr_b16 a[86:87], v15 offset:37936
		ds_read_b64_tr_b16 a[88:89], v15 offset:33712
		ds_read_b64_tr_b16 a[90:91], v15 offset:38064
		ds_read_b64_tr_b16 a[92:93], v15 offset:33840
		ds_read_b64_tr_b16 a[94:95], v15 offset:38192
		ds_read_b64_tr_b16 a[96:97], v15 offset:33968
		ds_read_b64_tr_b16 a[98:99], v15 offset:38320
		ds_read_b64_tr_b16 a[100:101], v15 offset:34096
		ds_read_b64_tr_b16 a[102:103], v15 offset:38448
		ds_read_b64_tr_b16 a[104:105], v15 offset:34224
		ds_read_b64_tr_b16 a[106:107], v15 offset:38576
		s_barrier
		v_lshrrev_b32_e32 v15, 3, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v18, 64
		v_mul_lo_u32 v18, v18, v15
		v_lshrrev_b32_e32 v15, 4, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v19, 32
		v_mul_lo_u32 v19, v19, v15
		v_lshrrev_b32_e32 v15, 5, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v20, 16
		v_mul_lo_u32 v20, v20, v15
		v_bitop3_b32 v15, v18, v19, v20 bitop3:0x96
		v_lshrrev_b32_e32 v18, 6, v0
		v_and_b32_e32 v18, 1, v18
		v_lshrrev_b32_e32 v19, 7, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 2
		v_mul_lo_u32 v20, v20, v19
		v_bitop3_b32 v15, v15, v18, v20 bitop3:0x96
		v_add_u32_e32 v15, s47, v15
		v_lshrrev_b32_e32 v18, 3, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v19, 64
		v_mul_lo_u32 v19, v19, v18
		v_lshrrev_b32_e32 v18, 4, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v20, 32
		v_mul_lo_u32 v20, v20, v18
		v_bitop3_b32 v18, 4, v19, v20 bitop3:0x96
		v_lshrrev_b32_e32 v19, 5, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 16
		v_mul_lo_u32 v20, v20, v19
		v_xor_b32_e32 v18, v18, v20
		v_lshrrev_b32_e32 v19, 6, v0
		v_and_b32_e32 v19, 1, v19
		v_lshrrev_b32_e32 v20, 7, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v22, 2
		v_mul_lo_u32 v22, v22, v20
		v_bitop3_b32 v18, v18, v19, v22 bitop3:0x96
		v_add_u32_e32 v18, s47, v18
		v_lshrrev_b32_e32 v19, 3, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 64
		v_mul_lo_u32 v20, v20, v19
		v_lshrrev_b32_e32 v19, 4, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v22, 32
		v_mul_lo_u32 v22, v22, v19
		v_bitop3_b32 v19, 8, v20, v22 bitop3:0x96
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
		v_add_u32_e32 v19, s47, v19
		v_lshrrev_b32_e32 v20, 3, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v22, 64
		v_mul_lo_u32 v22, v22, v20
		v_lshrrev_b32_e32 v20, 4, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v23, 32
		v_mul_lo_u32 v23, v23, v20
		v_bitop3_b32 v20, 12, v22, v23 bitop3:0x96
		v_lshrrev_b32_e32 v22, 5, v0
		v_and_b32_e32 v22, 1, v22
		v_mov_b32_e32 v23, 16
		v_mul_lo_u32 v23, v23, v22
		v_xor_b32_e32 v20, v20, v23
		v_lshrrev_b32_e32 v22, 6, v0
		v_and_b32_e32 v22, 1, v22
		v_lshrrev_b32_e32 v23, 7, v0
		v_and_b32_e32 v23, 1, v23
		v_mov_b32_e32 v29, 2
		v_mul_lo_u32 v29, v29, v23
		v_bitop3_b32 v20, v20, v22, v29 bitop3:0x96
		v_add_u32_e32 v20, s47, v20
		v_cmp_lt_i32_e64 vcc, v15, s24
		s_mov_b64 s[54:55], vcc
		v_cmp_lt_i32_e64 vcc, v18, s24
		s_mov_b64 s[58:59], vcc
		v_cmp_lt_i32_e64 vcc, v19, s24
		s_mov_b64 s[60:61], vcc
		v_cmp_lt_i32_e64 vcc, v20, s24
		s_mov_b64 s[62:63], vcc
		v_lshrrev_b32_e32 v15, 3, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v18, 16
		v_mul_lo_u32 v18, v18, v15
		v_lshrrev_b32_e32 v15, 4, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v19, 32
		v_mul_lo_u32 v19, v19, v15
		v_lshrrev_b32_e32 v15, 5, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v20, 64
		v_mul_lo_u32 v20, v20, v15
		v_bitop3_b32 v15, v18, v19, v20 bitop3:0x96
		v_lshrrev_b32_e32 v18, 6, v0
		v_and_b32_e32 v18, 1, v18
		v_lshrrev_b32_e32 v19, 7, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 2
		v_mul_lo_u32 v20, v20, v19
		v_bitop3_b32 v15, v15, v18, v20 bitop3:0x96
		v_add_u32_e32 v15, s47, v15
		v_lshrrev_b32_e32 v18, 3, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v19, 16
		v_mul_lo_u32 v19, v19, v18
		v_lshrrev_b32_e32 v18, 4, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v20, 32
		v_mul_lo_u32 v20, v20, v18
		v_bitop3_b32 v18, 4, v19, v20 bitop3:0x96
		v_lshrrev_b32_e32 v19, 5, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 64
		v_mul_lo_u32 v20, v20, v19
		v_xor_b32_e32 v18, v18, v20
		v_lshrrev_b32_e32 v19, 6, v0
		v_and_b32_e32 v19, 1, v19
		v_lshrrev_b32_e32 v20, 7, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v22, 2
		v_mul_lo_u32 v22, v22, v20
		v_bitop3_b32 v18, v18, v19, v22 bitop3:0x96
		v_add_u32_e32 v18, s47, v18
		v_lshrrev_b32_e32 v19, 3, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 16
		v_mul_lo_u32 v20, v20, v19
		v_lshrrev_b32_e32 v19, 4, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v22, 32
		v_mul_lo_u32 v22, v22, v19
		v_bitop3_b32 v19, 8, v20, v22 bitop3:0x96
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
		v_add_u32_e32 v19, s47, v19
		v_cmp_lt_i32_e64 vcc, v15, s24
		s_mov_b64 s[64:65], vcc
		v_cmp_lt_i32_e64 vcc, v18, s24
		s_mov_b64 s[66:67], vcc
		v_cmp_lt_i32_e64 vcc, v19, s24
		s_mov_b64 s[68:69], vcc
		s_mul_i32 s53, s15, s45
		s_lshl_b32 s53, s53, 1
		s_lshl_b32 s57, s15, 8
		s_mul_i32 s70, s1, s13
		s_lshl_b32 s70, s70, 1
		s_add_i32 s57, s57, s70
		s_mul_i32 s70, s25, s14
		s_lshl_b32 s70, s70, 1
		s_add_i32 s57, s57, s70
		s_add_i32 s57, s57, s53
		v_lshrrev_b32_e32 v15, 4, v0
		v_and_b32_e32 v15, 1, v15
		v_mul_lo_u32 v15, s15, v15
		v_lshrrev_b32_e32 v18, 5, v0
		v_and_b32_e32 v18, 1, v18
		v_mul_lo_u32 v18, s15, v18
		v_lshrrev_b32_e32 v19, 7, v0
		v_mul_lo_u32 v19, s15, v19
		v_lshrrev_b32_e32 v20, 6, v0
		v_and_b32_e32 v20, 1, v20
		v_mul_lo_u32 v20, s15, v20
		v_lshlrev_b32_e32 v20, 1, v20
		v_lshl_add_u32 v19, v19, 2, v20
		v_lshl_add_u32 v18, v18, 5, v19
		v_lshl_add_u32 v15, v15, 6, v18
		v_lshrrev_b32_e32 v18, 3, v0
		v_and_b32_e32 v18, 1, v18
		v_mul_lo_u32 v18, s15, v18
		v_lshlrev_b32_e32 v18, 7, v18
		v_and_b32_e32 v19, 1, v0
		v_lshlrev_b32_e32 v19, 4, v19
		v_add3_u32 v15, v15, v18, v19
		v_lshrrev_b32_e32 v18, 2, v0
		v_and_b32_e32 v18, 1, v18
		v_lshlrev_b32_e32 v18, 6, v18
		v_lshrrev_b32_e32 v19, 1, v0
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 5, v19
		v_add3_u32 v15, v15, v18, v19
		v_add_u32_e32 v18, s57, v15
		s_add_i32 s52, s52, 1
		s_and_b32 s52, s52, 1
		s_mul_i32 s57, 0x4100, s52
		s_add_i32 s57, s27, s57
		s_mov_b32 m0, s57
		v_cndmask_b32_e64 v18, v11, v18, s[54:55]
		buffer_load_dwordx4 v18, s[28:31], 0 offen lds
		v_lshrrev_b32_e32 v18, 3, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v19, 16
		v_mul_lo_u32 v19, v19, v18
		v_lshrrev_b32_e32 v18, 4, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v20, 32
		v_mul_lo_u32 v20, v20, v18
		v_bitop3_b32 v18, 12, v19, v20 bitop3:0x96
		v_lshrrev_b32_e32 v19, 5, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 64
		v_mul_lo_u32 v20, v20, v19
		v_xor_b32_e32 v18, v18, v20
		v_lshrrev_b32_e32 v19, 6, v0
		v_and_b32_e32 v19, 1, v19
		v_lshrrev_b32_e32 v20, 7, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v22, 2
		v_mul_lo_u32 v22, v22, v20
		v_bitop3_b32 v18, v18, v19, v22 bitop3:0x96
		v_add_u32_e32 v18, s47, v18
		v_add_u32_e32 v15, s53, v15
		s_mul_i32 s53, 0x108, s15
		s_mul_i32 s54, s1, s13
		s_lshl_b32 s54, s54, 1
		s_add_i32 s53, s53, s54
		s_mul_i32 s54, s25, s14
		s_lshl_b32 s54, s54, 1
		s_add_i32 s53, s53, s54
		v_add_u32_e32 v19, s53, v15
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v19, v11, v19, s[58:59]
		buffer_load_dwordx4 v19, s[28:31], 0 offen lds
		s_mul_i32 s53, 0x110, s15
		s_mul_i32 s54, s1, s13
		s_lshl_b32 s54, s54, 1
		s_add_i32 s53, s53, s54
		s_mul_i32 s54, s25, s14
		s_lshl_b32 s54, s54, 1
		s_add_i32 s53, s53, s54
		v_add_u32_e32 v19, s53, v15
		s_add_i32 m0, s57, 0x2080
		v_cndmask_b32_e64 v19, v11, v19, s[60:61]
		buffer_load_dwordx4 v19, s[28:31], 0 offen lds
		s_mul_i32 s53, 0x118, s15
		s_mul_i32 s54, s1, s13
		s_lshl_b32 s54, s54, 1
		s_add_i32 s53, s53, s54
		s_mul_i32 s54, s25, s14
		s_lshl_b32 s54, s54, 1
		s_add_i32 s53, s53, s54
		v_add_u32_e32 v15, s53, v15
		s_add_i32 m0, s57, 0x30c0
		v_cndmask_b32_e64 v15, v11, v15, s[62:63]
		buffer_load_dwordx4 v15, s[28:31], 0 offen lds
		s_barrier
		s_mul_i32 s45, s21, s45
		s_lshl_b32 s45, s45, 1
		s_lshl_b32 s53, s21, 8
		s_mul_i32 s54, s1, s19
		s_lshl_b32 s54, s54, 1
		s_add_i32 s53, s53, s54
		s_mul_i32 s54, s25, s20
		s_lshl_b32 s54, s54, 1
		s_add_i32 s53, s53, s54
		s_add_i32 s53, s53, s45
		v_lshrrev_b32_e32 v15, 4, v0
		v_and_b32_e32 v15, 1, v15
		v_mul_lo_u32 v15, s21, v15
		v_lshrrev_b32_e32 v19, 5, v0
		v_and_b32_e32 v19, 1, v19
		v_mul_lo_u32 v19, s21, v19
		v_lshrrev_b32_e32 v20, 7, v0
		v_mul_lo_u32 v20, s21, v20
		v_lshrrev_b32_e32 v22, 6, v0
		v_and_b32_e32 v22, 1, v22
		v_mul_lo_u32 v22, s21, v22
		v_lshlrev_b32_e32 v22, 1, v22
		v_lshl_add_u32 v20, v20, 2, v22
		v_lshl_add_u32 v19, v19, 7, v20
		v_lshl_add_u32 v15, v15, 6, v19
		v_lshrrev_b32_e32 v19, 3, v0
		v_and_b32_e32 v19, 1, v19
		v_mul_lo_u32 v19, s21, v19
		v_lshlrev_b32_e32 v19, 5, v19
		v_and_b32_e32 v20, 1, v0
		v_lshlrev_b32_e32 v20, 4, v20
		v_add3_u32 v15, v15, v19, v20
		v_lshrrev_b32_e32 v19, 2, v0
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 6, v19
		v_lshrrev_b32_e32 v20, 1, v0
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v20, 5, v20
		v_add3_u32 v15, v15, v19, v20
		v_add_u32_e32 v19, s53, v15
		s_mul_i32 s52, 0x4400, s52
		s_add_i32 s52, s44, s52
		s_add_i32 m0, s52, 0x81f0
		v_cndmask_b32_e64 v19, v11, v19, s[64:65]
		buffer_load_dwordx4 v19, s[32:35], 0 offen lds
		v_add_u32_e32 v15, s45, v15
		s_mul_i32 s45, 0x108, s21
		s_mul_i32 s53, s1, s19
		s_lshl_b32 s53, s53, 1
		s_add_i32 s45, s45, s53
		s_mul_i32 s53, s25, s20
		s_lshl_b32 s53, s53, 1
		s_add_i32 s45, s45, s53
		v_add_u32_e32 v19, s45, v15
		s_add_i32 m0, s52, 0x92f0
		v_cndmask_b32_e64 v19, v11, v19, s[66:67]
		buffer_load_dwordx4 v19, s[32:35], 0 offen lds
		s_mul_i32 s45, 0x110, s21
		s_mul_i32 s53, s1, s19
		s_lshl_b32 s53, s53, 1
		s_add_i32 s45, s45, s53
		s_mul_i32 s53, s25, s20
		s_lshl_b32 s53, s53, 1
		s_add_i32 s45, s45, s53
		v_add_u32_e32 v19, s45, v15
		s_add_i32 m0, s52, 0xa3f0
		v_cndmask_b32_e64 v19, v11, v19, s[68:69]
		buffer_load_dwordx4 v19, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v18, s24
		s_mul_i32 s45, 0x118, s21
		s_mul_i32 s53, s1, s19
		s_lshl_b32 s53, s53, 1
		s_add_i32 s45, s45, s53
		s_mul_i32 s53, s25, s20
		s_lshl_b32 s53, s53, 1
		s_add_i32 s45, s45, s53
		v_add_u32_e32 v15, s45, v15
		s_add_i32 m0, s52, 0xb4f0
		v_cndmask_b32_e32 v15, v11, v15, vcc
		s_cmp_lt_i32 s47, s38
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[160:175], v[24:27], a[8:11], 0
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
		v_mfma_f32_32x32x16_bf16 v[160:175], v[68:71], a[8:11], 0
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
		v_mfma_f32_32x32x16_bf16 v[160:175], v[116:119], a[8:11], 0
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
		v_mfma_f32_32x32x16_bf16 v[160:175], v[132:135], a[8:11], 0
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
		v_mfma_f32_32x32x16_bf16 v[160:175], v[132:135], a[24:27], 0
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
		v_mfma_f32_32x32x16_bf16 v[160:175], v[24:27], a[24:27], 0
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
		buffer_load_dwordx4 v15, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[160:175], v[68:71], a[24:27], 0
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
		v_mfma_f32_32x32x16_bf16 v[160:175], v[116:119], a[24:27], 0
		v_mfma_f32_32x32x16_bf16 a[112:127], v[48:51], a[12:15], a[112:127]
		v_mfma_f32_32x32x16_bf16 a[128:143], v[72:75], a[12:15], a[128:143]
		v_mfma_f32_32x32x16_bf16 a[144:159], v[120:123], a[12:15], a[144:159]
		v_mfma_f32_32x32x16_bf16 a[160:175], v[136:139], a[12:15], a[160:175]
		v_mfma_f32_32x32x16_bf16 a[176:191], v[136:139], a[28:31], a[176:191]
		v_mfma_f32_32x32x16_bf16 a[192:207], v[48:51], a[28:31], a[192:207]
		v_mfma_f32_32x32x16_bf16 a[208:223], v[72:75], a[28:31], a[208:223]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[120:123], a[28:31], v[160:175]
		v_mfma_f32_32x32x16_bf16 a[112:127], v[52:55], a[16:19], a[112:127]
		v_mfma_f32_32x32x16_bf16 a[128:143], v[76:79], a[16:19], a[128:143]
		v_mfma_f32_32x32x16_bf16 a[144:159], v[124:127], a[16:19], a[144:159]
		v_mfma_f32_32x32x16_bf16 a[160:175], v[140:143], a[16:19], a[160:175]
		v_mfma_f32_32x32x16_bf16 a[176:191], v[140:143], a[32:35], a[176:191]
		v_mfma_f32_32x32x16_bf16 a[192:207], v[52:55], a[32:35], a[192:207]
		v_mfma_f32_32x32x16_bf16 a[208:223], v[76:79], a[32:35], a[208:223]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[124:127], a[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 a[112:127], v[60:63], a[20:23], a[112:127]
		v_mfma_f32_32x32x16_bf16 a[128:143], v[112:115], a[20:23], a[128:143]
		v_mfma_f32_32x32x16_bf16 a[144:159], v[128:131], a[20:23], a[144:159]
		v_mfma_f32_32x32x16_bf16 a[160:175], v[144:147], a[20:23], a[160:175]
		v_mfma_f32_32x32x16_bf16 a[176:191], v[144:147], a[36:39], a[176:191]
		v_mfma_f32_32x32x16_bf16 a[192:207], v[60:63], a[36:39], a[192:207]
		v_mfma_f32_32x32x16_bf16 a[208:223], v[112:115], a[36:39], a[208:223]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[128:131], a[36:39], v[160:175]
		s_nop 4
		v_accvgpr_read_b32 v15, a112
		v_accvgpr_read_b32 v18, a113
		v_max_f32_e32 v15, v15, v18
		v_accvgpr_read_b32 v18, a114
		v_accvgpr_read_b32 v19, a115
		v_max_f32_e32 v18, v18, v19
		v_accvgpr_read_b32 v19, a116
		v_accvgpr_read_b32 v20, a117
		v_max_f32_e32 v19, v19, v20
		v_accvgpr_read_b32 v20, a118
		v_accvgpr_read_b32 v22, a119
		v_max_f32_e32 v20, v20, v22
		v_accvgpr_read_b32 v22, a120
		v_accvgpr_read_b32 v23, a121
		v_max_f32_e32 v22, v22, v23
		v_accvgpr_read_b32 v23, a122
		v_accvgpr_read_b32 v24, a123
		v_max_f32_e32 v23, v23, v24
		v_accvgpr_read_b32 v24, a124
		v_accvgpr_read_b32 v25, a125
		v_max_f32_e32 v24, v24, v25
		v_accvgpr_read_b32 v25, a126
		v_accvgpr_read_b32 v26, a127
		v_max_f32_e32 v25, v25, v26
		v_accvgpr_read_b32 v26, a128
		v_accvgpr_read_b32 v27, a129
		v_max_f32_e32 v26, v26, v27
		v_accvgpr_read_b32 v27, a130
		v_accvgpr_read_b32 v29, a131
		v_max_f32_e32 v27, v27, v29
		v_accvgpr_read_b32 v29, a132
		v_accvgpr_read_b32 v31, a133
		v_max_f32_e32 v29, v29, v31
		v_accvgpr_read_b32 v31, a134
		v_accvgpr_read_b32 v48, a135
		v_max_f32_e32 v31, v31, v48
		v_accvgpr_read_b32 v48, a136
		v_accvgpr_read_b32 v49, a137
		v_max_f32_e32 v48, v48, v49
		v_accvgpr_read_b32 v49, a138
		v_accvgpr_read_b32 v50, a139
		v_max_f32_e32 v49, v49, v50
		v_accvgpr_read_b32 v50, a140
		v_accvgpr_read_b32 v51, a141
		v_max_f32_e32 v50, v50, v51
		v_accvgpr_read_b32 v51, a142
		v_accvgpr_read_b32 v52, a143
		v_max_f32_e32 v51, v51, v52
		v_accvgpr_read_b32 v52, a144
		v_accvgpr_read_b32 v53, a145
		v_max_f32_e32 v52, v52, v53
		v_accvgpr_read_b32 v53, a146
		v_accvgpr_read_b32 v54, a147
		v_max_f32_e32 v53, v53, v54
		v_accvgpr_read_b32 v54, a148
		v_accvgpr_read_b32 v55, a149
		v_max_f32_e32 v54, v54, v55
		v_accvgpr_read_b32 v55, a150
		v_accvgpr_read_b32 v56, a151
		v_max_f32_e32 v55, v55, v56
		v_accvgpr_read_b32 v56, a152
		v_accvgpr_read_b32 v58, a153
		v_max_f32_e32 v56, v56, v58
		v_accvgpr_read_b32 v58, a154
		v_accvgpr_read_b32 v60, a155
		v_max_f32_e32 v58, v58, v60
		v_accvgpr_read_b32 v60, a156
		v_accvgpr_read_b32 v61, a157
		v_max_f32_e32 v60, v60, v61
		v_accvgpr_read_b32 v61, a158
		v_accvgpr_read_b32 v62, a159
		v_max_f32_e32 v61, v61, v62
		v_accvgpr_read_b32 v62, a160
		v_accvgpr_read_b32 v63, a161
		v_max_f32_e32 v62, v62, v63
		v_accvgpr_read_b32 v63, a162
		v_accvgpr_read_b32 v65, a163
		v_max_f32_e32 v63, v63, v65
		v_accvgpr_read_b32 v65, a164
		v_accvgpr_read_b32 v66, a165
		v_max_f32_e32 v65, v65, v66
		v_accvgpr_read_b32 v66, a166
		v_accvgpr_read_b32 v67, a167
		v_max_f32_e32 v66, v66, v67
		v_accvgpr_read_b32 v67, a168
		v_accvgpr_read_b32 v68, a169
		v_max_f32_e32 v67, v67, v68
		v_accvgpr_read_b32 v68, a170
		v_accvgpr_read_b32 v69, a171
		v_max_f32_e32 v68, v68, v69
		v_accvgpr_read_b32 v69, a172
		v_accvgpr_read_b32 v70, a173
		v_max_f32_e32 v69, v69, v70
		v_accvgpr_read_b32 v70, a174
		v_accvgpr_read_b32 v71, a175
		v_max_f32_e32 v70, v70, v71
		v_max_f32_e32 v15, v15, v18
		v_max_f32_e32 v18, v19, v20
		v_max_f32_e32 v19, v22, v23
		v_max_f32_e32 v20, v24, v25
		v_max_f32_e32 v22, v26, v27
		v_max_f32_e32 v23, v29, v31
		v_max_f32_e32 v24, v48, v49
		v_max_f32_e32 v25, v50, v51
		v_max_f32_e32 v26, v52, v53
		v_max_f32_e32 v27, v54, v55
		v_max_f32_e32 v29, v56, v58
		v_max_f32_e32 v31, v60, v61
		v_max_f32_e32 v48, v62, v63
		v_max_f32_e32 v49, v65, v66
		v_max_f32_e32 v50, v67, v68
		v_max_f32_e32 v51, v69, v70
		v_max_f32_e32 v15, v15, v18
		v_max_f32_e32 v18, v19, v20
		v_max_f32_e32 v19, v22, v23
		v_max_f32_e32 v20, v24, v25
		v_max_f32_e32 v22, v26, v27
		v_max_f32_e32 v23, v29, v31
		v_max_f32_e32 v24, v48, v49
		v_max_f32_e32 v25, v50, v51
		v_max_f32_e32 v15, v15, v18
		v_max_f32_e32 v18, v19, v20
		v_max_f32_e32 v19, v22, v23
		v_max_f32_e32 v20, v24, v25
		v_max_f32_e32 v15, v15, v18
		v_max_f32_e32 v18, v19, v20
		v_max_f32_e32 v15, v15, v18
		v_and_b32_e32 v18, 1, v9
		v_lshrrev_b32_e32 v19, 4, v9
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 4, v19
		v_lshrrev_b32_e32 v20, 3, v9
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v20, 3, v20
		v_add3_u32 v18, v18, v19, v20
		v_lshrrev_b32_e32 v19, 2, v9
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 2, v19
		v_lshrrev_b32_e32 v20, 1, v9
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v20, 1, v20
		v_add3_u32 v18, v18, v19, v20
		v_lshlrev_b32_e32 v18, 2, v18
		ds_bpermute_b32 v19, v18, v15
		v_lshrrev_b32_e32 v20, 4, v9
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v20, 4, v20
		v_lshrrev_b32_e32 v22, 3, v9
		v_and_b32_e32 v22, 1, v22
		v_lshlrev_b32_e32 v22, 3, v22
		v_lshrrev_b32_e32 v23, 2, v9
		v_and_b32_e32 v23, 1, v23
		v_lshlrev_b32_e32 v23, 2, v23
		v_and_b32_e32 v24, 1, v9
		v_add_u32_e32 v24, 32, v24
		v_lshrrev_b32_e32 v25, 1, v9
		v_and_b32_e32 v25, 1, v25
		v_lshlrev_b32_e32 v25, 1, v25
		v_bitop3_b32 v23, v23, v24, v25 bitop3:0x96
		v_bitop3_b32 v20, v20, v22, v23 bitop3:0x96
		v_lshlrev_b32_e32 v20, 2, v20
		ds_bpermute_b32 v22, v20, v15
		v_accvgpr_read_b32 v15, a192
		v_accvgpr_read_b32 v23, a193
		v_max_f32_e32 v15, v15, v23
		v_accvgpr_read_b32 v23, a194
		v_accvgpr_read_b32 v24, a195
		v_max_f32_e32 v23, v23, v24
		v_accvgpr_read_b32 v24, a196
		v_accvgpr_read_b32 v25, a197
		v_max_f32_e32 v24, v24, v25
		v_accvgpr_read_b32 v25, a198
		v_accvgpr_read_b32 v26, a199
		v_max_f32_e32 v25, v25, v26
		v_accvgpr_read_b32 v26, a200
		v_accvgpr_read_b32 v27, a201
		v_max_f32_e32 v26, v26, v27
		v_accvgpr_read_b32 v27, a202
		v_accvgpr_read_b32 v29, a203
		v_max_f32_e32 v27, v27, v29
		v_accvgpr_read_b32 v29, a204
		v_accvgpr_read_b32 v31, a205
		v_max_f32_e32 v29, v29, v31
		v_accvgpr_read_b32 v31, a206
		v_accvgpr_read_b32 v48, a207
		v_max_f32_e32 v31, v31, v48
		v_accvgpr_read_b32 v48, a208
		v_accvgpr_read_b32 v49, a209
		v_max_f32_e32 v48, v48, v49
		v_accvgpr_read_b32 v49, a210
		v_accvgpr_read_b32 v50, a211
		v_max_f32_e32 v49, v49, v50
		v_accvgpr_read_b32 v50, a212
		v_accvgpr_read_b32 v51, a213
		v_max_f32_e32 v50, v50, v51
		v_accvgpr_read_b32 v51, a214
		v_accvgpr_read_b32 v52, a215
		v_max_f32_e32 v51, v51, v52
		v_accvgpr_read_b32 v52, a216
		v_accvgpr_read_b32 v53, a217
		v_max_f32_e32 v52, v52, v53
		v_accvgpr_read_b32 v53, a218
		v_accvgpr_read_b32 v54, a219
		v_max_f32_e32 v53, v53, v54
		v_accvgpr_read_b32 v54, a220
		v_accvgpr_read_b32 v55, a221
		v_max_f32_e32 v54, v54, v55
		v_accvgpr_read_b32 v55, a222
		v_accvgpr_read_b32 v56, a223
		v_max_f32_e32 v55, v55, v56
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v60, v19, v22
		v_max_f32_e32 v19, v160, v161
		v_max_f32_e32 v22, v162, v163
		v_max_f32_e32 v56, v164, v165
		v_max_f32_e32 v58, v166, v167
		v_max_f32_e32 v61, v168, v169
		v_max_f32_e32 v62, v170, v171
		v_max_f32_e32 v63, v172, v173
		v_max_f32_e32 v65, v174, v175
		v_accvgpr_read_b32 v66, a176
		v_accvgpr_read_b32 v67, a177
		v_max_f32_e32 v66, v66, v67
		v_accvgpr_read_b32 v67, a178
		v_accvgpr_read_b32 v68, a179
		v_max_f32_e32 v67, v67, v68
		v_accvgpr_read_b32 v68, a180
		v_accvgpr_read_b32 v69, a181
		v_max_f32_e32 v68, v68, v69
		v_accvgpr_read_b32 v69, a182
		v_accvgpr_read_b32 v70, a183
		v_max_f32_e32 v69, v69, v70
		v_accvgpr_read_b32 v70, a184
		v_accvgpr_read_b32 v71, a185
		v_max_f32_e32 v70, v70, v71
		v_accvgpr_read_b32 v71, a186
		v_accvgpr_read_b32 v72, a187
		v_max_f32_e32 v71, v71, v72
		v_accvgpr_read_b32 v72, a188
		v_accvgpr_read_b32 v73, a189
		v_max_f32_e32 v72, v72, v73
		v_accvgpr_read_b32 v73, a190
		v_accvgpr_read_b32 v74, a191
		v_max_f32_e32 v73, v73, v74
		v_max_f32_e32 v15, v15, v23
		v_max_f32_e32 v23, v24, v25
		v_max_f32_e32 v24, v26, v27
		v_max_f32_e32 v25, v29, v31
		v_max_f32_e32 v26, v48, v49
		v_max_f32_e32 v27, v50, v51
		v_max_f32_e32 v29, v52, v53
		v_max_f32_e32 v31, v54, v55
		v_max_f32_e32 v19, v19, v22
		v_max_f32_e32 v22, v56, v58
		v_max_f32_e32 v48, v61, v62
		v_max_f32_e32 v49, v63, v65
		v_max_f32_e32 v50, v66, v67
		v_max_f32_e32 v51, v68, v69
		v_max_f32_e32 v52, v70, v71
		v_max_f32_e32 v53, v72, v73
		v_max_f32_e32 v15, v15, v23
		v_max_f32_e32 v23, v24, v25
		v_max_f32_e32 v24, v26, v27
		v_max_f32_e32 v25, v29, v31
		v_max_f32_e32 v19, v19, v22
		v_max_f32_e32 v22, v48, v49
		v_max_f32_e32 v26, v50, v51
		v_max_f32_e32 v27, v52, v53
		v_max_f32_e32 v15, v15, v23
		v_max_f32_e32 v23, v24, v25
		v_max_f32_e32 v19, v19, v22
		v_max_f32_e32 v22, v26, v27
		v_max_f32_e32 v15, v15, v23
		v_max_f32_e32 v19, v19, v22
		v_max_f32_e32 v15, v15, v19
		ds_bpermute_b32 v19, v18, v15
		ds_bpermute_b32 v22, v20, v15
		v_mov_b32_e32 v24, 0x3e38aa3b
		v_mov_b32_e32 v25, 0x3e38aa3b
		v_accvgpr_read_b32 v26, a112
		v_accvgpr_read_b32 v27, a113
		v_pk_mul_f32 v[48:49], v[26:27], v[24:25]
		v_accvgpr_read_b32 v26, a114
		v_accvgpr_read_b32 v27, a115
		v_pk_mul_f32 v[50:51], v[26:27], v[24:25]
		v_accvgpr_read_b32 v26, a116
		v_accvgpr_read_b32 v27, a117
		v_pk_mul_f32 v[52:53], v[26:27], v[24:25]
		v_accvgpr_read_b32 v26, a118
		v_accvgpr_read_b32 v27, a119
		v_pk_mul_f32 v[54:55], v[26:27], v[24:25]
		v_accvgpr_read_b32 v26, a120
		v_accvgpr_read_b32 v27, a121
		v_pk_mul_f32 v[62:63], v[26:27], v[24:25]
		v_accvgpr_read_b32 v26, a122
		v_accvgpr_read_b32 v27, a123
		v_pk_mul_f32 v[66:67], v[26:27], v[24:25]
		v_accvgpr_read_b32 v26, a124
		v_accvgpr_read_b32 v27, a125
		v_pk_mul_f32 v[68:69], v[26:27], v[24:25]
		v_accvgpr_read_b32 v26, a126
		v_accvgpr_read_b32 v27, a127
		v_pk_mul_f32 v[70:71], v[26:27], v[24:25]
		v_accvgpr_read_b32 v26, a128
		v_accvgpr_read_b32 v27, a129
		v_pk_mul_f32 v[72:73], v[26:27], v[24:25]
		v_accvgpr_read_b32 v26, a130
		v_accvgpr_read_b32 v27, a131
		v_pk_mul_f32 v[74:75], v[26:27], v[24:25]
		v_accvgpr_read_b32 v26, a132
		v_accvgpr_read_b32 v27, a133
		v_pk_mul_f32 v[76:77], v[26:27], v[24:25]
		v_accvgpr_read_b32 v26, a134
		v_accvgpr_read_b32 v27, a135
		v_pk_mul_f32 v[78:79], v[26:27], v[24:25]
		v_accvgpr_read_b32 v26, a136
		v_accvgpr_read_b32 v27, a137
		v_pk_mul_f32 v[112:113], v[26:27], v[24:25]
		v_accvgpr_read_b32 v26, a138
		v_accvgpr_read_b32 v27, a139
		v_pk_mul_f32 v[114:115], v[26:27], v[24:25]
		v_accvgpr_read_b32 v26, a140
		v_accvgpr_read_b32 v27, a141
		v_pk_mul_f32 v[116:117], v[26:27], v[24:25]
		v_accvgpr_read_b32 v26, a142
		v_accvgpr_read_b32 v27, a143
		v_pk_mul_f32 v[118:119], v[26:27], v[24:25]
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v61, v19, v22
		v_pk_mul_f32 v[22:23], v[60:61], v[24:25]
		v_max_f32_e32 v15, v14, v22
		v_max_f32_e32 v19, v13, v23
		v_accvgpr_read_b32 v22, a144
		v_accvgpr_read_b32 v23, a145
		v_pk_mul_f32 v[26:27], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a146
		v_accvgpr_read_b32 v23, a147
		v_pk_mul_f32 v[60:61], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a148
		v_accvgpr_read_b32 v23, a149
		v_pk_mul_f32 v[120:121], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a150
		v_accvgpr_read_b32 v23, a151
		v_pk_mul_f32 v[122:123], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a152
		v_accvgpr_read_b32 v23, a153
		v_pk_mul_f32 v[124:125], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a154
		v_accvgpr_read_b32 v23, a155
		v_pk_mul_f32 v[126:127], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a156
		v_accvgpr_read_b32 v23, a157
		v_pk_mul_f32 v[128:129], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a158
		v_accvgpr_read_b32 v23, a159
		v_pk_mul_f32 v[130:131], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a160
		v_accvgpr_read_b32 v23, a161
		v_pk_mul_f32 v[132:133], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a162
		v_accvgpr_read_b32 v23, a163
		v_pk_mul_f32 v[134:135], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a164
		v_accvgpr_read_b32 v23, a165
		v_pk_mul_f32 v[136:137], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a166
		v_accvgpr_read_b32 v23, a167
		v_pk_mul_f32 v[138:139], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a168
		v_accvgpr_read_b32 v23, a169
		v_pk_mul_f32 v[140:141], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a170
		v_accvgpr_read_b32 v23, a171
		v_pk_mul_f32 v[142:143], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a172
		v_accvgpr_read_b32 v23, a173
		v_pk_mul_f32 v[144:145], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a174
		v_accvgpr_read_b32 v23, a175
		v_pk_mul_f32 v[146:147], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a192
		v_accvgpr_read_b32 v23, a193
		v_pk_mul_f32 v[156:157], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a194
		v_accvgpr_read_b32 v23, a195
		v_pk_mul_f32 v[158:159], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a196
		v_accvgpr_read_b32 v23, a197
		v_pk_mul_f32 v[176:177], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a198
		v_accvgpr_read_b32 v23, a199
		v_pk_mul_f32 v[178:179], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a200
		v_accvgpr_read_b32 v23, a201
		v_pk_mul_f32 v[180:181], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a202
		v_accvgpr_read_b32 v23, a203
		v_pk_mul_f32 v[182:183], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a204
		v_accvgpr_read_b32 v23, a205
		v_pk_mul_f32 v[184:185], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a206
		v_accvgpr_read_b32 v23, a207
		v_pk_mul_f32 v[186:187], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a208
		v_accvgpr_read_b32 v23, a209
		v_pk_mul_f32 v[188:189], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a210
		v_accvgpr_read_b32 v23, a211
		v_pk_mul_f32 v[190:191], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a212
		v_accvgpr_read_b32 v23, a213
		v_pk_mul_f32 v[192:193], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a214
		v_accvgpr_read_b32 v23, a215
		v_pk_mul_f32 v[194:195], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a216
		v_accvgpr_read_b32 v23, a217
		v_pk_mul_f32 v[196:197], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a218
		v_accvgpr_read_b32 v23, a219
		v_pk_mul_f32 v[198:199], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a220
		v_accvgpr_read_b32 v23, a221
		v_pk_mul_f32 v[200:201], v[22:23], v[24:25]
		v_accvgpr_read_b32 v22, a222
		v_accvgpr_read_b32 v23, a223
		v_pk_mul_f32 v[202:203], v[22:23], v[24:25]
		v_pk_mul_f32 v[22:23], v[160:161], v[24:25]
		v_pk_mul_f32 v[160:161], v[162:163], v[24:25]
		v_pk_mul_f32 v[162:163], v[164:165], v[24:25]
		v_pk_mul_f32 v[164:165], v[166:167], v[24:25]
		v_pk_mul_f32 v[166:167], v[168:169], v[24:25]
		v_pk_mul_f32 v[168:169], v[170:171], v[24:25]
		v_pk_mul_f32 v[170:171], v[172:173], v[24:25]
		v_pk_mul_f32 v[172:173], v[174:175], v[24:25]
		v_accvgpr_read_b32 v174, a176
		v_accvgpr_read_b32 v175, a177
		v_pk_mul_f32 v[204:205], v[174:175], v[24:25]
		v_accvgpr_read_b32 v174, a178
		v_accvgpr_read_b32 v175, a179
		v_pk_mul_f32 v[206:207], v[174:175], v[24:25]
		v_accvgpr_read_b32 v174, a180
		v_accvgpr_read_b32 v175, a181
		v_pk_mul_f32 v[208:209], v[174:175], v[24:25]
		v_accvgpr_read_b32 v174, a182
		v_accvgpr_read_b32 v175, a183
		v_pk_mul_f32 v[210:211], v[174:175], v[24:25]
		v_accvgpr_read_b32 v174, a184
		v_accvgpr_read_b32 v175, a185
		v_pk_mul_f32 v[212:213], v[174:175], v[24:25]
		v_accvgpr_read_b32 v174, a186
		v_accvgpr_read_b32 v175, a187
		v_pk_mul_f32 v[214:215], v[174:175], v[24:25]
		v_accvgpr_read_b32 v174, a188
		v_accvgpr_read_b32 v175, a189
		v_pk_mul_f32 v[216:217], v[174:175], v[24:25]
		v_accvgpr_read_b32 v174, a190
		v_accvgpr_read_b32 v175, a191
		v_pk_mul_f32 v[218:219], v[174:175], v[24:25]
		v_sub_f32_e32 v24, v48, v15
		v_sub_f32_e32 v25, v49, v15
		v_sub_f32_e32 v29, v50, v15
		v_sub_f32_e32 v31, v51, v15
		v_sub_f32_e32 v48, v52, v15
		v_sub_f32_e32 v49, v53, v15
		v_sub_f32_e32 v50, v54, v15
		v_sub_f32_e32 v51, v55, v15
		v_sub_f32_e32 v52, v62, v15
		v_sub_f32_e32 v53, v63, v15
		v_sub_f32_e32 v54, v66, v15
		v_sub_f32_e32 v55, v67, v15
		v_sub_f32_e32 v56, v68, v15
		v_sub_f32_e32 v58, v69, v15
		v_sub_f32_e32 v62, v70, v15
		v_sub_f32_e32 v63, v71, v15
		v_sub_f32_e32 v65, v72, v15
		v_sub_f32_e32 v66, v73, v15
		v_sub_f32_e32 v67, v74, v15
		v_sub_f32_e32 v68, v75, v15
		v_sub_f32_e32 v69, v76, v15
		v_sub_f32_e32 v70, v77, v15
		v_sub_f32_e32 v71, v78, v15
		v_sub_f32_e32 v72, v79, v15
		v_sub_f32_e32 v73, v112, v15
		v_sub_f32_e32 v74, v113, v15
		v_sub_f32_e32 v75, v114, v15
		v_sub_f32_e32 v76, v115, v15
		v_sub_f32_e32 v77, v116, v15
		v_sub_f32_e32 v78, v117, v15
		v_sub_f32_e32 v79, v118, v15
		v_sub_f32_e32 v112, v119, v15
		v_sub_f32_e32 v26, v26, v15
		v_sub_f32_e32 v27, v27, v15
		v_sub_f32_e32 v60, v60, v15
		v_sub_f32_e32 v61, v61, v15
		v_sub_f32_e32 v113, v120, v15
		v_sub_f32_e32 v114, v121, v15
		v_sub_f32_e32 v115, v122, v15
		v_sub_f32_e32 v116, v123, v15
		v_sub_f32_e32 v117, v124, v15
		v_sub_f32_e32 v118, v125, v15
		v_sub_f32_e32 v119, v126, v15
		v_sub_f32_e32 v120, v127, v15
		v_sub_f32_e32 v121, v128, v15
		v_sub_f32_e32 v122, v129, v15
		v_sub_f32_e32 v123, v130, v15
		v_sub_f32_e32 v124, v131, v15
		v_sub_f32_e32 v125, v132, v15
		v_sub_f32_e32 v126, v133, v15
		v_sub_f32_e32 v127, v134, v15
		v_sub_f32_e32 v128, v135, v15
		v_sub_f32_e32 v129, v136, v15
		v_sub_f32_e32 v130, v137, v15
		v_sub_f32_e32 v131, v138, v15
		v_sub_f32_e32 v132, v139, v15
		v_sub_f32_e32 v133, v140, v15
		v_sub_f32_e32 v134, v141, v15
		v_sub_f32_e32 v135, v142, v15
		v_sub_f32_e32 v136, v143, v15
		v_sub_f32_e32 v137, v144, v15
		v_sub_f32_e32 v138, v145, v15
		v_sub_f32_e32 v139, v146, v15
		v_sub_f32_e32 v140, v147, v15
		v_sub_f32_e32 v141, v156, v19
		v_sub_f32_e32 v142, v157, v19
		v_sub_f32_e32 v143, v158, v19
		v_sub_f32_e32 v144, v159, v19
		v_sub_f32_e32 v145, v176, v19
		v_sub_f32_e32 v146, v177, v19
		v_sub_f32_e32 v147, v178, v19
		v_sub_f32_e32 v156, v179, v19
		v_sub_f32_e32 v157, v180, v19
		v_sub_f32_e32 v158, v181, v19
		v_sub_f32_e32 v159, v182, v19
		v_sub_f32_e32 v174, v183, v19
		v_sub_f32_e32 v175, v184, v19
		v_sub_f32_e32 v176, v185, v19
		v_sub_f32_e32 v177, v186, v19
		v_sub_f32_e32 v178, v187, v19
		v_sub_f32_e32 v179, v188, v19
		v_sub_f32_e32 v180, v189, v19
		v_sub_f32_e32 v181, v190, v19
		v_sub_f32_e32 v182, v191, v19
		v_sub_f32_e32 v183, v192, v19
		v_sub_f32_e32 v184, v193, v19
		v_sub_f32_e32 v185, v194, v19
		v_sub_f32_e32 v186, v195, v19
		v_sub_f32_e32 v187, v196, v19
		v_sub_f32_e32 v188, v197, v19
		v_sub_f32_e32 v189, v198, v19
		v_sub_f32_e32 v190, v199, v19
		v_sub_f32_e32 v191, v200, v19
		v_sub_f32_e32 v192, v201, v19
		v_sub_f32_e32 v193, v202, v19
		v_sub_f32_e32 v194, v203, v19
		v_sub_f32_e32 v22, v22, v19
		v_sub_f32_e32 v23, v23, v19
		v_sub_f32_e32 v160, v160, v19
		v_sub_f32_e32 v161, v161, v19
		v_sub_f32_e32 v162, v162, v19
		v_sub_f32_e32 v163, v163, v19
		v_sub_f32_e32 v164, v164, v19
		v_sub_f32_e32 v165, v165, v19
		v_sub_f32_e32 v166, v166, v19
		v_sub_f32_e32 v167, v167, v19
		v_sub_f32_e32 v168, v168, v19
		v_sub_f32_e32 v169, v169, v19
		v_sub_f32_e32 v170, v170, v19
		v_sub_f32_e32 v171, v171, v19
		v_sub_f32_e32 v172, v172, v19
		v_sub_f32_e32 v173, v173, v19
		v_sub_f32_e32 v195, v204, v19
		v_sub_f32_e32 v196, v205, v19
		v_sub_f32_e32 v197, v206, v19
		v_sub_f32_e32 v198, v207, v19
		v_sub_f32_e32 v199, v208, v19
		v_sub_f32_e32 v200, v209, v19
		v_sub_f32_e32 v201, v210, v19
		v_sub_f32_e32 v202, v211, v19
		v_sub_f32_e32 v203, v212, v19
		v_sub_f32_e32 v204, v213, v19
		v_sub_f32_e32 v205, v214, v19
		v_sub_f32_e32 v206, v215, v19
		v_sub_f32_e32 v207, v216, v19
		v_sub_f32_e32 v208, v217, v19
		v_sub_f32_e32 v209, v218, v19
		v_sub_f32_e32 v210, v219, v19
		v_exp_f32_e32 v212, v24
		v_exp_f32_e32 v214, v25
		v_exp_f32_e32 v213, v29
		v_exp_f32_e32 v215, v31
		v_exp_f32_e32 v24, v48
		v_exp_f32_e32 v216, v49
		v_exp_f32_e32 v25, v50
		v_exp_f32_e32 v217, v51
		v_exp_f32_e32 v48, v52
		v_exp_f32_e32 v50, v53
		v_exp_f32_e32 v49, v54
		v_exp_f32_e32 v51, v55
		v_exp_f32_e32 v52, v56
		v_exp_f32_e32 v54, v58
		v_exp_f32_e32 v53, v62
		v_exp_f32_e32 v55, v63
		v_exp_f32_e32 v62, v65
		v_exp_f32_e32 v218, v66
		v_exp_f32_e32 v63, v67
		v_exp_f32_e32 v219, v68
		v_exp_f32_e32 v66, v69
		v_exp_f32_e32 v68, v70
		v_exp_f32_e32 v67, v71
		v_exp_f32_e32 v69, v72
		v_exp_f32_e32 v70, v73
		v_exp_f32_e32 v72, v74
		v_exp_f32_e32 v71, v75
		v_exp_f32_e32 v73, v76
		v_exp_f32_e32 v74, v77
		v_exp_f32_e32 v76, v78
		v_exp_f32_e32 v75, v79
		v_exp_f32_e32 v77, v112
		v_exp_f32_e32 v78, v26
		v_exp_f32_e32 v220, v27
		v_exp_f32_e32 v79, v60
		v_exp_f32_e32 v221, v61
		v_exp_f32_e32 v26, v113
		v_exp_f32_e32 v60, v114
		v_exp_f32_e32 v27, v115
		v_exp_f32_e32 v61, v116
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
		v_exp_f32_e32 v137, v141
		v_exp_f32_e32 v139, v142
		v_exp_f32_e32 v140, v143
		v_exp_f32_e32 v142, v144
		v_exp_f32_e32 v141, v145
		v_exp_f32_e32 v143, v146
		v_exp_f32_e32 v144, v147
		v_exp_f32_e32 v146, v156
		v_exp_f32_e32 v145, v157
		v_exp_f32_e32 v147, v158
		v_exp_f32_e32 v156, v159
		v_exp_f32_e32 v158, v174
		v_exp_f32_e32 v157, v175
		v_exp_f32_e32 v159, v176
		v_exp_f32_e32 v174, v177
		v_exp_f32_e32 v176, v178
		v_exp_f32_e32 v175, v179
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
		v_exp_f32_e32 v191, v22
		v_exp_f32_e32 v193, v23
		v_exp_f32_e32 v22, v160
		v_exp_f32_e32 v222, v161
		v_exp_f32_e32 v23, v162
		v_exp_f32_e32 v223, v163
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
		v_exp_f32_e32 v169, v195
		v_exp_f32_e32 v171, v196
		v_exp_f32_e32 v172, v197
		v_exp_f32_e32 v194, v198
		v_exp_f32_e32 v173, v199
		v_exp_f32_e32 v195, v200
		v_exp_f32_e32 v196, v201
		v_exp_f32_e32 v198, v202
		v_exp_f32_e32 v197, v203
		v_exp_f32_e32 v199, v204
		v_exp_f32_e32 v200, v205
		v_exp_f32_e32 v202, v206
		v_exp_f32_e32 v201, v207
		v_exp_f32_e32 v203, v208
		v_exp_f32_e32 v204, v209
		v_exp_f32_e32 v206, v210
		v_pk_add_f32 v[208:209], v[212:213], v[214:215]
		v_pk_add_f32 v[210:211], v[24:25], v[216:217]
		v_pk_add_f32 v[224:225], v[48:49], v[50:51]
		v_pk_add_f32 v[226:227], v[52:53], v[54:55]
		v_pk_add_f32 v[228:229], v[62:63], v[218:219]
		v_pk_add_f32 v[230:231], v[66:67], v[68:69]
		v_pk_add_f32 v[232:233], v[70:71], v[72:73]
		v_pk_add_f32 v[234:235], v[74:75], v[76:77]
		v_pk_add_f32 v[236:237], v[78:79], v[220:221]
		v_pk_add_f32 v[238:239], v[26:27], v[60:61]
		v_pk_add_f32 v[240:241], v[112:113], v[114:115]
		v_pk_add_f32 v[242:243], v[116:117], v[118:119]
		v_pk_add_f32 v[244:245], v[120:121], v[122:123]
		v_pk_add_f32 v[246:247], v[124:125], v[126:127]
		v_pk_add_f32 v[248:249], v[128:129], v[130:131]
		v_pk_add_f32 v[250:251], v[132:133], v[134:135]
		v_mov_b32_e32 v252, v209
		v_mov_b32_e32 v253, v211
		v_mov_b32_e32 v254, v208
		v_mov_b32_e32 v255, v210
		v_pk_add_f32 v[208:209], v[254:255], v[252:253]
		v_mov_b32_e32 v210, v225
		v_mov_b32_e32 v211, v227
		v_mov_b32_e32 v252, v224
		v_mov_b32_e32 v253, v226
		v_pk_add_f32 v[224:225], v[252:253], v[210:211]
		v_mov_b32_e32 v210, v229
		v_mov_b32_e32 v211, v231
		v_mov_b32_e32 v226, v228
		v_mov_b32_e32 v227, v230
		v_pk_add_f32 v[228:229], v[226:227], v[210:211]
		v_mov_b32_e32 v210, v233
		v_mov_b32_e32 v211, v235
		v_mov_b32_e32 v226, v232
		v_mov_b32_e32 v227, v234
		v_pk_add_f32 v[230:231], v[226:227], v[210:211]
		v_mov_b32_e32 v210, v237
		v_mov_b32_e32 v211, v239
		v_mov_b32_e32 v226, v236
		v_mov_b32_e32 v227, v238
		v_pk_add_f32 v[232:233], v[226:227], v[210:211]
		v_mov_b32_e32 v210, v241
		v_mov_b32_e32 v211, v243
		v_mov_b32_e32 v226, v240
		v_mov_b32_e32 v227, v242
		v_pk_add_f32 v[234:235], v[226:227], v[210:211]
		v_mov_b32_e32 v210, v245
		v_mov_b32_e32 v211, v247
		v_mov_b32_e32 v226, v244
		v_mov_b32_e32 v227, v246
		v_pk_add_f32 v[236:237], v[226:227], v[210:211]
		v_mov_b32_e32 v210, v249
		v_mov_b32_e32 v211, v251
		v_mov_b32_e32 v226, v248
		v_mov_b32_e32 v227, v250
		v_pk_add_f32 v[238:239], v[226:227], v[210:211]
		v_mov_b32_e32 v210, v209
		v_mov_b32_e32 v211, v225
		v_mov_b32_e32 v226, v208
		v_mov_b32_e32 v227, v224
		v_pk_add_f32 v[208:209], v[226:227], v[210:211]
		v_mov_b32_e32 v210, v229
		v_mov_b32_e32 v211, v231
		v_mov_b32_e32 v224, v228
		v_mov_b32_e32 v225, v230
		v_pk_add_f32 v[226:227], v[224:225], v[210:211]
		v_mov_b32_e32 v210, v233
		v_mov_b32_e32 v211, v235
		v_mov_b32_e32 v224, v232
		v_mov_b32_e32 v225, v234
		v_pk_add_f32 v[228:229], v[224:225], v[210:211]
		v_mov_b32_e32 v210, v237
		v_mov_b32_e32 v211, v239
		v_mov_b32_e32 v224, v236
		v_mov_b32_e32 v225, v238
		v_pk_add_f32 v[230:231], v[224:225], v[210:211]
		v_mov_b32_e32 v210, v209
		v_mov_b32_e32 v211, v227
		v_mov_b32_e32 v224, v208
		v_mov_b32_e32 v225, v226
		v_pk_add_f32 v[208:209], v[224:225], v[210:211]
		v_mov_b32_e32 v210, v229
		v_mov_b32_e32 v211, v231
		v_mov_b32_e32 v224, v228
		v_mov_b32_e32 v225, v230
		v_pk_add_f32 v[226:227], v[224:225], v[210:211]
		v_mov_b32_e32 v210, v209
		v_mov_b32_e32 v211, v227
		v_mov_b32_e32 v224, v208
		v_mov_b32_e32 v225, v226
		v_pk_add_f32 v[208:209], v[224:225], v[210:211]
		v_add_f32_e32 v29, v208, v209
		ds_bpermute_b32 v136, v18, v29
		ds_bpermute_b32 v138, v20, v29
		v_pk_add_f32 v[208:209], v[140:141], v[142:143]
		v_pk_add_f32 v[210:211], v[144:145], v[146:147]
		v_pk_add_f32 v[224:225], v[156:157], v[158:159]
		v_pk_add_f32 v[226:227], v[174:175], v[176:177]
		v_pk_add_f32 v[228:229], v[178:179], v[180:181]
		v_pk_add_f32 v[230:231], v[182:183], v[184:185]
		v_pk_add_f32 v[232:233], v[186:187], v[188:189]
		v_pk_add_f32 v[234:235], v[190:191], v[192:193]
		v_pk_add_f32 v[236:237], v[22:23], v[222:223]
		v_pk_add_f32 v[238:239], v[160:161], v[162:163]
		v_pk_add_f32 v[240:241], v[164:165], v[166:167]
		v_pk_add_f32 v[242:243], v[168:169], v[170:171]
		v_pk_add_f32 v[244:245], v[172:173], v[194:195]
		v_pk_add_f32 v[246:247], v[196:197], v[198:199]
		v_pk_add_f32 v[248:249], v[200:201], v[202:203]
		v_mov_b32_e32 v250, v209
		v_mov_b32_e32 v251, v224
		v_pk_add_f32 v[252:253], v[250:251], v[210:211]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[210:211], v[136:137], v[138:139]
		v_mov_b32_e32 v205, v211
		v_mov_b32_e32 v207, v208
		v_pk_add_f32 v[208:209], v[204:205], v[206:207]
		v_mov_b32_e32 v250, v225
		v_mov_b32_e32 v251, v228
		v_pk_add_f32 v[224:225], v[250:251], v[226:227]
		v_mov_b32_e32 v226, v229
		v_mov_b32_e32 v227, v232
		v_pk_add_f32 v[228:229], v[226:227], v[230:231]
		v_mov_b32_e32 v226, v233
		v_mov_b32_e32 v227, v236
		v_pk_add_f32 v[226:227], v[226:227], v[234:235]
		v_mov_b32_e32 v230, v237
		v_mov_b32_e32 v231, v240
		v_pk_add_f32 v[232:233], v[230:231], v[238:239]
		v_mov_b32_e32 v230, v241
		v_mov_b32_e32 v231, v244
		v_pk_add_f32 v[230:231], v[230:231], v[242:243]
		v_mov_b32_e32 v234, v245
		v_mov_b32_e32 v235, v248
		v_pk_add_f32 v[236:237], v[234:235], v[246:247]
		v_mov_b32_e32 v234, v249
		v_mov_b32_e32 v235, v252
		v_pk_add_f32 v[208:209], v[234:235], v[208:209]
		v_mov_b32_e32 v234, v253
		v_mov_b32_e32 v235, v228
		v_pk_add_f32 v[238:239], v[234:235], v[224:225]
		v_mov_b32_e32 v224, v229
		v_mov_b32_e32 v225, v232
		v_pk_add_f32 v[224:225], v[224:225], v[226:227]
		v_mov_b32_e32 v226, v233
		v_mov_b32_e32 v227, v236
		v_pk_add_f32 v[228:229], v[226:227], v[230:231]
		v_mov_b32_e32 v226, v237
		v_mov_b32_e32 v227, v238
		v_pk_add_f32 v[208:209], v[226:227], v[208:209]
		v_mov_b32_e32 v226, v239
		v_mov_b32_e32 v227, v228
		v_pk_add_f32 v[230:231], v[226:227], v[224:225]
		v_mov_b32_e32 v224, v229
		v_mov_b32_e32 v225, v230
		v_pk_add_f32 v[226:227], v[224:225], v[208:209]
		v_add_f32_e32 v29, v231, v226
		v_add_f32_e32 v29, v227, v29
		ds_bpermute_b32 v31, v18, v29
		ds_bpermute_b32 v18, v20, v29
		v_sub_f32_e32 v14, v14, v15
		v_sub_f32_e32 v13, v13, v19
		v_exp_f32_e32 v208, v14
		v_exp_f32_e32 v224, v13
		v_mov_b32_e32 v209, v208
		v_pk_mul_f32 v[32:33], v[32:33], v[208:209]
		v_pk_mul_f32 v[34:35], v[34:35], v[208:209]
		v_pk_mul_f32 v[36:37], v[36:37], v[208:209]
		v_pk_mul_f32 v[38:39], v[38:39], v[208:209]
		v_pk_mul_f32 v[40:41], v[40:41], v[208:209]
		v_pk_mul_f32 v[42:43], v[42:43], v[208:209]
		v_pk_mul_f32 v[44:45], v[44:45], v[208:209]
		v_pk_mul_f32 v[46:47], v[46:47], v[208:209]
		v_pk_mul_f32 v[80:81], v[80:81], v[208:209]
		v_pk_mul_f32 v[82:83], v[82:83], v[208:209]
		v_pk_mul_f32 v[84:85], v[84:85], v[208:209]
		v_pk_mul_f32 v[86:87], v[86:87], v[208:209]
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v227, v31, v18
		v_pk_mul_f32 v[88:89], v[88:89], v[208:209]
		v_pk_mul_f32 v[90:91], v[90:91], v[208:209]
		v_pk_mul_f32 v[92:93], v[92:93], v[208:209]
		v_pk_mul_f32 v[94:95], v[94:95], v[208:209]
		v_mov_b32_e32 v225, v224
		v_pk_mul_f32 v[96:97], v[96:97], v[224:225]
		v_pk_mul_f32 v[98:99], v[98:99], v[224:225]
		v_pk_mul_f32 v[100:101], v[100:101], v[224:225]
		v_pk_mul_f32 v[102:103], v[102:103], v[224:225]
		v_pk_mul_f32 v[104:105], v[104:105], v[224:225]
		v_pk_mul_f32 v[106:107], v[106:107], v[224:225]
		v_pk_mul_f32 v[108:109], v[108:109], v[224:225]
		v_pk_mul_f32 v[110:111], v[110:111], v[224:225]
		v_accvgpr_read_b32 v228, a48
		v_accvgpr_read_b32 v229, a49
		v_pk_mul_f32 v[228:229], v[228:229], v[224:225]
		v_accvgpr_write_b32 a48, v228
		v_accvgpr_write_b32 a49, v229
		v_accvgpr_read_b32 v228, a50
		v_accvgpr_read_b32 v229, a51
		v_pk_mul_f32 v[228:229], v[228:229], v[224:225]
		v_accvgpr_write_b32 a50, v228
		v_accvgpr_write_b32 a51, v229
		v_accvgpr_read_b32 v228, a52
		v_accvgpr_read_b32 v229, a53
		v_pk_mul_f32 v[228:229], v[228:229], v[224:225]
		v_accvgpr_write_b32 a52, v228
		v_accvgpr_write_b32 a53, v229
		v_accvgpr_read_b32 v228, a54
		v_accvgpr_read_b32 v229, a55
		v_pk_mul_f32 v[228:229], v[228:229], v[224:225]
		v_accvgpr_write_b32 a54, v228
		v_accvgpr_write_b32 a55, v229
		v_accvgpr_read_b32 v228, a56
		v_accvgpr_read_b32 v229, a57
		v_pk_mul_f32 v[228:229], v[228:229], v[224:225]
		v_accvgpr_write_b32 a56, v228
		v_accvgpr_write_b32 a57, v229
		v_accvgpr_read_b32 v228, a58
		v_accvgpr_read_b32 v229, a59
		v_pk_mul_f32 v[228:229], v[228:229], v[224:225]
		v_accvgpr_write_b32 a58, v228
		v_accvgpr_write_b32 a59, v229
		v_accvgpr_read_b32 v228, a60
		v_accvgpr_read_b32 v229, a61
		v_pk_mul_f32 v[228:229], v[228:229], v[224:225]
		v_accvgpr_write_b32 a60, v228
		v_accvgpr_write_b32 a61, v229
		v_accvgpr_read_b32 v228, a62
		v_accvgpr_read_b32 v229, a63
		v_pk_mul_f32 v[228:229], v[228:229], v[224:225]
		v_accvgpr_write_b32 a62, v228
		v_accvgpr_write_b32 a63, v229
		v_mov_b32_e32 v226, v210
		v_mov_b32_e32 v210, v208
		v_mov_b32_e32 v211, v224
		v_mov_b64_e32 v[208:209], v[16:17]
		v_pk_fma_f32 v[16:17], v[208:209], v[210:211], v[226:227]
		v_cvt_pk_bf16_f32 v208, v212, v214
		v_cvt_pk_bf16_f32 v209, v213, v215
		v_cvt_pk_bf16_f32 v210, v24, v216
		v_cvt_pk_bf16_f32 v211, v25, v217
		v_cvt_pk_bf16_f32 v212, v48, v50
		v_cvt_pk_bf16_f32 v213, v49, v51
		v_cvt_pk_bf16_f32 v214, v52, v54
		v_cvt_pk_bf16_f32 v215, v53, v55
		v_cvt_pk_bf16_f32 v48, v62, v218
		v_cvt_pk_bf16_f32 v49, v63, v219
		v_cvt_pk_bf16_f32 v50, v66, v68
		v_cvt_pk_bf16_f32 v51, v67, v69
		v_cvt_pk_bf16_f32 v52, v70, v72
		v_cvt_pk_bf16_f32 v53, v71, v73
		v_cvt_pk_bf16_f32 v54, v74, v76
		v_cvt_pk_bf16_f32 v55, v75, v77
		v_cvt_pk_bf16_f32 v68, v78, v220
		v_cvt_pk_bf16_f32 v69, v79, v221
		v_cvt_pk_bf16_f32 v70, v26, v60
		v_cvt_pk_bf16_f32 v71, v27, v61
		v_cvt_pk_bf16_f32 v24, v112, v114
		v_cvt_pk_bf16_f32 v25, v113, v115
		v_cvt_pk_bf16_f32 v26, v116, v118
		v_cvt_pk_bf16_f32 v27, v117, v119
		v_cvt_pk_bf16_f32 v60, v120, v122
		v_cvt_pk_bf16_f32 v61, v121, v123
		v_cvt_pk_bf16_f32 v62, v124, v126
		v_cvt_pk_bf16_f32 v63, v125, v127
		v_cvt_pk_bf16_f32 v72, v128, v130
		v_cvt_pk_bf16_f32 v73, v129, v131
		v_cvt_pk_bf16_f32 v74, v132, v134
		v_cvt_pk_bf16_f32 v75, v133, v135
		v_cvt_pk_bf16_f32 v76, v137, v139
		v_cvt_pk_bf16_f32 v77, v140, v142
		v_cvt_pk_bf16_f32 v78, v141, v143
		v_cvt_pk_bf16_f32 v79, v144, v146
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
		v_cvt_pk_bf16_f32 v125, v22, v222
		v_cvt_pk_bf16_f32 v126, v23, v223
		v_cvt_pk_bf16_f32 v127, v160, v162
		v_cvt_pk_bf16_f32 v128, v161, v163
		v_cvt_pk_bf16_f32 v129, v164, v166
		v_cvt_pk_bf16_f32 v130, v165, v167
		v_cvt_pk_bf16_f32 v131, v168, v170
		v_cvt_pk_bf16_f32 v132, v169, v171
		v_cvt_pk_bf16_f32 v133, v172, v194
		v_cvt_pk_bf16_f32 v134, v173, v195
		v_cvt_pk_bf16_f32 v135, v196, v198
		v_cvt_pk_bf16_f32 v136, v197, v199
		v_cvt_pk_bf16_f32 v137, v200, v202
		v_cvt_pk_bf16_f32 v138, v201, v203
		v_cvt_pk_bf16_f32 v139, v204, v206
		v_permlane32_swap_b32_e32 v208, v210
		v_permlane32_swap_b32_e32 v209, v211
		v_permlane32_swap_b32_e32 v212, v214
		v_permlane32_swap_b32_e32 v213, v215
		v_permlane32_swap_b32_e32 v48, v50
		v_permlane32_swap_b32_e32 v49, v51
		v_mfma_f32_32x32x16_bf16 v[32:47], v[148:151], v[208:211], v[32:47]
		v_permlane32_swap_b32_e32 v52, v54
		v_permlane32_swap_b32_e32 v53, v55
		v_permlane32_swap_b32_e32 v68, v70
		v_permlane32_swap_b32_e32 v69, v71
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_permlane32_swap_b32_e32 v60, v62
		v_permlane32_swap_b32_e32 v61, v63
		v_permlane32_swap_b32_e32 v72, v74
		v_permlane32_swap_b32_e32 v73, v75
		v_permlane32_swap_b32_e32 v76, v78
		v_permlane32_swap_b32_e32 v77, v79
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[80:95], v[152:155], v[208:211], v[80:95]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 a[48:63], v[152:155], v[76:79], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[96:111], v[148:151], v[76:79], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[4:7], v[212:215], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[80:83], v[212:215], v[80:95]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[80:83], v[112:115], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[4:7], v[112:115], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[40:43], v[48:51], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[84:87], v[48:51], v[80:95]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[84:87], v[116:119], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[40:43], v[116:119], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[44:47], v[52:55], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[88:91], v[52:55], v[80:95]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[88:91], v[120:123], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[44:47], v[120:123], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[64:67], v[68:71], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[92:95], v[68:71], v[80:95]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[92:95], v[124:127], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[64:67], v[124:127], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[68:71], v[24:27], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[96:99], v[24:27], v[80:95]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[96:99], v[128:131], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[68:71], v[128:131], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[72:75], v[60:63], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[100:103], v[60:63], v[80:95]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[100:103], v[132:135], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[72:75], v[132:135], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[76:79], v[72:75], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[104:107], v[72:75], v[80:95]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[104:107], v[136:139], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[76:79], v[136:139], v[96:111]
		s_mov_b32 s45, s47
		v_mov_b32_e32 v14, v15
		v_mov_b32_e32 v13, v19
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_3
.L_attn_fwd_persistent.loop_exit_3:
		s_cmp_lt_i32 s38, s37
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_4
.L_attn_fwd_persistent.loop_head_4:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s27, s38, 0x80
		s_cmp_lt_i32 s38, 0
		s_cselect_b32 s44, s36, 0
		s_add_i32 s44, s38, s44
		s_ashr_i32 s44, s44, 7
		s_cmp_lt_i32 s44, 0
		s_cselect_b32 s45, s16, 0
		s_add_i32 s45, s44, s45
		s_ashr_i32 s45, s45, 1
		s_lshl_b32 s45, s45, 1
		s_xor_b32 s45, s45, -1
		s_add_i32 s45, s45, 1
		s_add_i32 s45, s44, s45
		s_add_i32 s44, s44, 1
		s_cmp_lt_i32 s44, 0
		s_cselect_b32 s47, s16, 0
		s_add_i32 s47, s44, s47
		s_ashr_i32 s47, s47, 1
		s_lshl_b32 s47, s47, 1
		s_xor_b32 s47, s47, -1
		s_add_i32 s47, s47, 1
		s_add_i32 s52, s44, s47
		s_mul_i32 s44, 0x4100, s45
		v_and_b32_e32 v15, 63, v0
		v_lshrrev_b32_e32 v18, 5, v15
		v_and_b32_e32 v15, 31, v15
		v_lshrrev_b32_e32 v19, 4, v15
		v_lshlrev_b32_e32 v19, 9, v19
		v_lshl_add_u32 v18, v18, 4, v19
		v_lshrrev_b32_e32 v19, 3, v15
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 0x2080
		v_mul_lo_u32 v20, v20, v19
		v_lshrrev_b32_e32 v19, 2, v15
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v22, 0x1040
		v_mul_lo_u32 v22, v22, v19
		v_add3_u32 v18, v18, v20, v22
		v_lshrrev_b32_e32 v19, 1, v15
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 0x820
		v_mul_lo_u32 v20, v20, v19
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v19, 0x410
		v_mul_lo_u32 v19, v19, v15
		v_add3_u32 v15, v18, v20, v19
		v_add_u32_e32 v15, s44, v15
		ds_read_b128 v[24:27], v15
		ds_read_b128 v[48:51], v15 offset:32
		ds_read_b128 v[52:55], v15 offset:64
		ds_read_b128 v[60:63], v15 offset:96
		ds_read_b128 v[68:71], v15 offset:256
		ds_read_b128 v[72:75], v15 offset:288
		ds_read_b128 v[76:79], v15 offset:320
		ds_read_b128 v[112:115], v15 offset:352
		ds_read_b128 v[116:119], v15 offset:128
		ds_read_b128 v[120:123], v15 offset:160
		ds_read_b128 v[124:127], v15 offset:192
		ds_read_b128 v[128:131], v15 offset:224
		ds_read_b128 v[132:135], v15 offset:384
		ds_read_b128 v[136:139], v15 offset:416
		ds_read_b128 v[140:143], v15 offset:448
		ds_read_b128 v[144:147], v15 offset:480
		s_mul_i32 s44, 0x4400, s45
		v_and_b32_e32 v15, 63, v0
		v_and_b32_e32 v18, 15, v15
		v_and_b32_e32 v19, 3, v18
		v_lshrrev_b32_e32 v20, 5, v15
		v_mov_b32_e32 v22, 0x2200
		v_mul_lo_u32 v22, v22, v20
		v_and_b32_e32 v15, 31, v15
		v_lshrrev_b32_e32 v15, 4, v15
		v_lshlrev_b32_e32 v15, 5, v15
		v_lshrrev_b32_e32 v18, 2, v18
		v_mov_b32_e32 v20, 0x440
		v_mul_lo_u32 v20, v20, v18
		v_add3_u32 v15, v22, v15, v20
		v_lshl_add_u32 v15, v19, 3, v15
		v_add_u32_e32 v15, s44, v15
		ds_read_b64_tr_b16 v[148:149], v15 offset:33264
		ds_read_b64_tr_b16 v[150:151], v15 offset:37616
		ds_read_b64_tr_b16 a[4:5], v15 offset:33392
		ds_read_b64_tr_b16 a[6:7], v15 offset:37744
		ds_read_b64_tr_b16 a[40:41], v15 offset:33520
		ds_read_b64_tr_b16 a[42:43], v15 offset:37872
		ds_read_b64_tr_b16 a[44:45], v15 offset:33648
		ds_read_b64_tr_b16 a[46:47], v15 offset:38000
		ds_read_b64_tr_b16 a[64:65], v15 offset:33776
		ds_read_b64_tr_b16 a[66:67], v15 offset:38128
		ds_read_b64_tr_b16 a[68:69], v15 offset:33904
		ds_read_b64_tr_b16 a[70:71], v15 offset:38256
		ds_read_b64_tr_b16 a[72:73], v15 offset:34032
		ds_read_b64_tr_b16 a[74:75], v15 offset:38384
		ds_read_b64_tr_b16 a[76:77], v15 offset:34160
		ds_read_b64_tr_b16 a[78:79], v15 offset:38512
		ds_read_b64_tr_b16 v[152:153], v15 offset:33328
		ds_read_b64_tr_b16 v[154:155], v15 offset:37680
		ds_read_b64_tr_b16 a[80:81], v15 offset:33456
		ds_read_b64_tr_b16 a[82:83], v15 offset:37808
		ds_read_b64_tr_b16 a[84:85], v15 offset:33584
		ds_read_b64_tr_b16 a[86:87], v15 offset:37936
		ds_read_b64_tr_b16 a[88:89], v15 offset:33712
		ds_read_b64_tr_b16 a[90:91], v15 offset:38064
		ds_read_b64_tr_b16 a[92:93], v15 offset:33840
		ds_read_b64_tr_b16 a[94:95], v15 offset:38192
		ds_read_b64_tr_b16 a[96:97], v15 offset:33968
		ds_read_b64_tr_b16 a[98:99], v15 offset:38320
		ds_read_b64_tr_b16 a[100:101], v15 offset:34096
		ds_read_b64_tr_b16 a[102:103], v15 offset:38448
		ds_read_b64_tr_b16 a[104:105], v15 offset:34224
		ds_read_b64_tr_b16 a[106:107], v15 offset:38576
		s_cmp_lt_i32 s27, s22
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_2
		s_waitcnt vmcnt(0) lgkmcnt(14)
		s_barrier
		v_lshrrev_b32_e32 v15, 3, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v18, 64
		v_mul_lo_u32 v18, v18, v15
		v_lshrrev_b32_e32 v15, 4, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v19, 32
		v_mul_lo_u32 v19, v19, v15
		v_lshrrev_b32_e32 v15, 5, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v20, 16
		v_mul_lo_u32 v20, v20, v15
		v_bitop3_b32 v15, v18, v19, v20 bitop3:0x96
		v_lshrrev_b32_e32 v18, 6, v0
		v_and_b32_e32 v18, 1, v18
		v_lshrrev_b32_e32 v19, 7, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 2
		v_mul_lo_u32 v20, v20, v19
		v_bitop3_b32 v15, v15, v18, v20 bitop3:0x96
		v_add_u32_e32 v15, s27, v15
		v_lshrrev_b32_e32 v18, 3, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v19, 64
		v_mul_lo_u32 v19, v19, v18
		v_lshrrev_b32_e32 v18, 4, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v20, 32
		v_mul_lo_u32 v20, v20, v18
		v_bitop3_b32 v18, 4, v19, v20 bitop3:0x96
		v_lshrrev_b32_e32 v19, 5, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 16
		v_mul_lo_u32 v20, v20, v19
		v_xor_b32_e32 v18, v18, v20
		v_lshrrev_b32_e32 v19, 6, v0
		v_and_b32_e32 v19, 1, v19
		v_lshrrev_b32_e32 v20, 7, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v22, 2
		v_mul_lo_u32 v22, v22, v20
		v_bitop3_b32 v18, v18, v19, v22 bitop3:0x96
		v_add_u32_e32 v18, s27, v18
		v_lshrrev_b32_e32 v19, 3, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 64
		v_mul_lo_u32 v20, v20, v19
		v_lshrrev_b32_e32 v19, 4, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v22, 32
		v_mul_lo_u32 v22, v22, v19
		v_bitop3_b32 v19, 8, v20, v22 bitop3:0x96
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
		v_add_u32_e32 v19, s27, v19
		v_lshrrev_b32_e32 v20, 3, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v22, 64
		v_mul_lo_u32 v22, v22, v20
		v_lshrrev_b32_e32 v20, 4, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v23, 32
		v_mul_lo_u32 v23, v23, v20
		v_bitop3_b32 v20, 12, v22, v23 bitop3:0x96
		v_lshrrev_b32_e32 v22, 5, v0
		v_and_b32_e32 v22, 1, v22
		v_mov_b32_e32 v23, 16
		v_mul_lo_u32 v23, v23, v22
		v_xor_b32_e32 v20, v20, v23
		v_lshrrev_b32_e32 v22, 6, v0
		v_and_b32_e32 v22, 1, v22
		v_lshrrev_b32_e32 v23, 7, v0
		v_and_b32_e32 v23, 1, v23
		v_mov_b32_e32 v29, 2
		v_mul_lo_u32 v29, v29, v23
		v_bitop3_b32 v20, v20, v22, v29 bitop3:0x96
		v_add_u32_e32 v20, s27, v20
		v_cmp_lt_i32_e64 vcc, v15, s24
		s_mov_b64 s[44:45], vcc
		v_cmp_lt_i32_e64 vcc, v18, s24
		s_mov_b64 s[54:55], vcc
		v_cmp_lt_i32_e64 vcc, v19, s24
		s_mov_b64 s[58:59], vcc
		v_cmp_lt_i32_e64 vcc, v20, s24
		s_mov_b64 s[60:61], vcc
		v_lshrrev_b32_e32 v15, 3, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v18, 16
		v_mul_lo_u32 v18, v18, v15
		v_lshrrev_b32_e32 v15, 4, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v19, 32
		v_mul_lo_u32 v19, v19, v15
		v_lshrrev_b32_e32 v15, 5, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v20, 64
		v_mul_lo_u32 v20, v20, v15
		v_bitop3_b32 v15, v18, v19, v20 bitop3:0x96
		v_lshrrev_b32_e32 v18, 6, v0
		v_and_b32_e32 v18, 1, v18
		v_lshrrev_b32_e32 v19, 7, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 2
		v_mul_lo_u32 v20, v20, v19
		v_bitop3_b32 v15, v15, v18, v20 bitop3:0x96
		v_add_u32_e32 v15, s27, v15
		v_lshrrev_b32_e32 v18, 3, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v19, 16
		v_mul_lo_u32 v19, v19, v18
		v_lshrrev_b32_e32 v18, 4, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v20, 32
		v_mul_lo_u32 v20, v20, v18
		v_bitop3_b32 v18, 4, v19, v20 bitop3:0x96
		v_lshrrev_b32_e32 v19, 5, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 64
		v_mul_lo_u32 v20, v20, v19
		v_xor_b32_e32 v18, v18, v20
		v_lshrrev_b32_e32 v19, 6, v0
		v_and_b32_e32 v19, 1, v19
		v_lshrrev_b32_e32 v20, 7, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v22, 2
		v_mul_lo_u32 v22, v22, v20
		v_bitop3_b32 v18, v18, v19, v22 bitop3:0x96
		v_add_u32_e32 v18, s27, v18
		v_lshrrev_b32_e32 v19, 3, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 16
		v_mul_lo_u32 v20, v20, v19
		v_lshrrev_b32_e32 v19, 4, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v22, 32
		v_mul_lo_u32 v22, v22, v19
		v_bitop3_b32 v19, 8, v20, v22 bitop3:0x96
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
		v_add_u32_e32 v19, s27, v19
		v_cmp_lt_i32_e64 vcc, v15, s24
		s_mov_b64 s[62:63], vcc
		v_cmp_lt_i32_e64 vcc, v18, s24
		s_mov_b64 s[64:65], vcc
		v_cmp_lt_i32_e64 vcc, v19, s24
		s_mov_b64 s[66:67], vcc
		s_mul_i32 s47, s15, s38
		s_lshl_b32 s47, s47, 1
		s_lshl_b32 s53, s15, 8
		s_mul_i32 s57, s1, s13
		s_lshl_b32 s57, s57, 1
		s_add_i32 s53, s53, s57
		s_mul_i32 s57, s25, s14
		s_lshl_b32 s57, s57, 1
		s_add_i32 s53, s53, s57
		s_add_i32 s53, s53, s47
		v_lshrrev_b32_e32 v15, 4, v0
		v_and_b32_e32 v15, 1, v15
		v_mul_lo_u32 v15, s15, v15
		v_lshrrev_b32_e32 v18, 5, v0
		v_and_b32_e32 v18, 1, v18
		v_mul_lo_u32 v18, s15, v18
		v_lshrrev_b32_e32 v19, 7, v0
		v_mul_lo_u32 v19, s15, v19
		v_lshrrev_b32_e32 v20, 6, v0
		v_and_b32_e32 v20, 1, v20
		v_mul_lo_u32 v20, s15, v20
		v_lshlrev_b32_e32 v20, 1, v20
		v_lshl_add_u32 v19, v19, 2, v20
		v_lshl_add_u32 v18, v18, 5, v19
		v_lshl_add_u32 v15, v15, 6, v18
		v_lshrrev_b32_e32 v18, 3, v0
		v_and_b32_e32 v18, 1, v18
		v_mul_lo_u32 v18, s15, v18
		v_lshlrev_b32_e32 v18, 7, v18
		v_and_b32_e32 v19, 1, v0
		v_lshlrev_b32_e32 v19, 4, v19
		v_add3_u32 v15, v15, v18, v19
		v_lshrrev_b32_e32 v18, 2, v0
		v_and_b32_e32 v18, 1, v18
		v_lshlrev_b32_e32 v18, 6, v18
		v_lshrrev_b32_e32 v19, 1, v0
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 5, v19
		v_add3_u32 v15, v15, v18, v19
		v_add_u32_e32 v18, s53, v15
		s_mov_b32 s68, 1
		s_mov_b32 s69, 0
		s_mov_b32 s71, 0
		s_mov_b32 s70, s56
		s_mul_i32 s72, s68, s70
		s_mul_hi_u32 s73, s68, s70
		s_mul_i32 s53, s68, s71
		s_add_i32 s73, s73, s53
		s_mul_i32 s53, s69, s70
		s_add_i32 s73, s73, s53
		s_lshr_b64 s[68:69], s[72:73], 6
		s_mov_b32 s70, 0x410
		s_mov_b32 s71, 0
		s_mul_i32 s72, s70, s68
		s_mul_hi_u32 s73, s70, s68
		s_mul_i32 s53, s70, s69
		s_add_i32 s73, s73, s53
		s_mul_i32 s53, s71, s68
		s_add_i32 s73, s73, s53
		s_cmp_lt_i32 s52, 0
		s_cselect_b32 s53, -1, 0
		s_mov_b32 s70, 0x4100
		s_mov_b32 s71, 0
		s_mul_i32 s74, s70, s52
		s_mul_hi_u32 s75, s70, s52
		s_mul_i32 s57, s70, s53
		s_add_i32 s75, s75, s57
		s_mul_i32 s57, s71, s52
		s_add_i32 s75, s75, s57
		s_add_u32 s70, s72, s74
		s_addc_u32 s71, s73, s75
		s_add_u32 s76, s70, 0
		s_addc_u32 s77, s71, 0
		s_mov_b32 m0, s76
		v_cndmask_b32_e64 v18, v11, v18, s[44:45]
		buffer_load_dwordx4 v18, s[28:31], 0 offen lds
		v_lshrrev_b32_e32 v18, 3, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v19, 16
		v_mul_lo_u32 v19, v19, v18
		v_lshrrev_b32_e32 v18, 4, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v20, 32
		v_mul_lo_u32 v20, v20, v18
		v_bitop3_b32 v18, 12, v19, v20 bitop3:0x96
		v_lshrrev_b32_e32 v19, 5, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 64
		v_mul_lo_u32 v20, v20, v19
		v_xor_b32_e32 v18, v18, v20
		v_lshrrev_b32_e32 v19, 6, v0
		v_and_b32_e32 v19, 1, v19
		v_lshrrev_b32_e32 v20, 7, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v22, 2
		v_mul_lo_u32 v22, v22, v20
		v_bitop3_b32 v18, v18, v19, v22 bitop3:0x96
		v_add_u32_e32 v18, s27, v18
		s_mul_i32 s44, 0x108, s15
		s_mul_i32 s45, s1, s13
		s_lshl_b32 s45, s45, 1
		s_add_i32 s44, s44, s45
		s_mul_i32 s45, s25, s14
		s_lshl_b32 s45, s45, 1
		s_add_i32 s44, s44, s45
		s_add_i32 s44, s44, s47
		v_add_u32_e32 v19, s44, v15
		s_add_u32 s44, s72, 0x1040
		s_addc_u32 s45, s73, 0
		s_add_u32 s44, s44, s74
		s_addc_u32 s45, s45, s75
		s_add_u32 s70, s44, 0
		s_addc_u32 s71, s45, 0
		s_mov_b32 m0, s70
		v_cndmask_b32_e64 v19, v11, v19, s[54:55]
		buffer_load_dwordx4 v19, s[28:31], 0 offen lds
		s_mul_i32 s44, 0x110, s15
		s_mul_i32 s45, s1, s13
		s_lshl_b32 s45, s45, 1
		s_add_i32 s44, s44, s45
		s_mul_i32 s45, s25, s14
		s_lshl_b32 s45, s45, 1
		s_add_i32 s44, s44, s45
		s_add_i32 s44, s44, s47
		v_add_u32_e32 v19, s44, v15
		s_add_u32 s44, s72, 0x2080
		s_addc_u32 s45, s73, 0
		s_add_u32 s44, s44, s74
		s_addc_u32 s45, s45, s75
		s_add_u32 s54, s44, 0
		s_addc_u32 s55, s45, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v19, v11, v19, s[58:59]
		buffer_load_dwordx4 v19, s[28:31], 0 offen lds
		s_mul_i32 s44, 0x118, s15
		s_mul_i32 s45, s1, s13
		s_lshl_b32 s45, s45, 1
		s_add_i32 s44, s44, s45
		s_mul_i32 s45, s25, s14
		s_lshl_b32 s45, s45, 1
		s_add_i32 s44, s44, s45
		s_add_i32 s44, s44, s47
		v_add_u32_e32 v15, s44, v15
		s_add_u32 s44, s72, 0x30c0
		s_addc_u32 s45, s73, 0
		s_add_u32 s44, s44, s74
		s_addc_u32 s45, s45, s75
		s_add_u32 s54, s44, 0
		s_addc_u32 s55, s45, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v15, v11, v15, s[60:61]
		buffer_load_dwordx4 v15, s[28:31], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s44, s21, s38
		s_lshl_b32 s44, s44, 1
		s_lshl_b32 s45, s21, 8
		s_mul_i32 s47, s1, s19
		s_lshl_b32 s47, s47, 1
		s_add_i32 s45, s45, s47
		s_mul_i32 s47, s25, s20
		s_lshl_b32 s47, s47, 1
		s_add_i32 s45, s45, s47
		s_add_i32 s45, s45, s44
		v_lshrrev_b32_e32 v15, 4, v0
		v_and_b32_e32 v15, 1, v15
		v_mul_lo_u32 v15, s21, v15
		v_lshrrev_b32_e32 v19, 5, v0
		v_and_b32_e32 v19, 1, v19
		v_mul_lo_u32 v19, s21, v19
		v_lshrrev_b32_e32 v20, 7, v0
		v_mul_lo_u32 v20, s21, v20
		v_lshrrev_b32_e32 v22, 6, v0
		v_and_b32_e32 v22, 1, v22
		v_mul_lo_u32 v22, s21, v22
		v_lshlrev_b32_e32 v22, 1, v22
		v_lshl_add_u32 v20, v20, 2, v22
		v_lshl_add_u32 v19, v19, 7, v20
		v_lshl_add_u32 v15, v15, 6, v19
		v_lshrrev_b32_e32 v19, 3, v0
		v_and_b32_e32 v19, 1, v19
		v_mul_lo_u32 v19, s21, v19
		v_lshlrev_b32_e32 v19, 5, v19
		v_and_b32_e32 v20, 1, v0
		v_lshlrev_b32_e32 v20, 4, v20
		v_add3_u32 v15, v15, v19, v20
		v_lshrrev_b32_e32 v19, 2, v0
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 6, v19
		v_lshrrev_b32_e32 v20, 1, v0
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v20, 5, v20
		v_add3_u32 v15, v15, v19, v20
		v_add_u32_e32 v19, s45, v15
		s_mov_b32 s54, 0x440
		s_mov_b32 s55, 0
		s_mul_i32 s58, s54, s68
		s_mul_hi_u32 s59, s54, s68
		s_mul_i32 s45, s54, s69
		s_add_i32 s59, s59, s45
		s_mul_i32 s45, s55, s68
		s_add_i32 s59, s59, s45
		s_add_u32 s54, s58, 0x81f0
		s_addc_u32 s55, s59, 0
		s_mov_b32 s60, 0x4400
		s_mov_b32 s61, 0
		s_mul_i32 s68, s60, s52
		s_mul_hi_u32 s69, s60, s52
		s_mul_i32 s45, s60, s53
		s_add_i32 s69, s69, s45
		s_mul_i32 s45, s61, s52
		s_add_i32 s69, s69, s45
		s_add_u32 s52, s54, s68
		s_addc_u32 s53, s55, s69
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v19, v11, v19, s[62:63]
		buffer_load_dwordx4 v19, s[32:35], 0 offen lds
		s_mul_i32 s45, 0x108, s21
		s_mul_i32 s47, s1, s19
		s_lshl_b32 s47, s47, 1
		s_add_i32 s45, s45, s47
		s_mul_i32 s47, s25, s20
		s_lshl_b32 s47, s47, 1
		s_add_i32 s45, s45, s47
		s_add_i32 s45, s45, s44
		v_add_u32_e32 v19, s45, v15
		s_add_u32 s52, s58, 0x92f0
		s_addc_u32 s53, s59, 0
		s_add_u32 s52, s52, s68
		s_addc_u32 s53, s53, s69
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v19, v11, v19, s[64:65]
		buffer_load_dwordx4 v19, s[32:35], 0 offen lds
		s_mul_i32 s45, 0x110, s21
		s_mul_i32 s47, s1, s19
		s_lshl_b32 s47, s47, 1
		s_add_i32 s45, s45, s47
		s_mul_i32 s47, s25, s20
		s_lshl_b32 s47, s47, 1
		s_add_i32 s45, s45, s47
		s_add_i32 s45, s45, s44
		v_add_u32_e32 v19, s45, v15
		s_add_u32 s52, s58, 0xa3f0
		s_addc_u32 s53, s59, 0
		s_add_u32 s52, s52, s68
		s_addc_u32 s53, s53, s69
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v19, v11, v19, s[66:67]
		buffer_load_dwordx4 v19, s[32:35], 0 offen lds
		s_mul_i32 s45, 0x118, s21
		s_mul_i32 s47, s1, s19
		s_lshl_b32 s47, s47, 1
		s_add_i32 s45, s45, s47
		s_mul_i32 s47, s25, s20
		s_lshl_b32 s47, s47, 1
		s_add_i32 s45, s45, s47
		s_add_i32 s44, s45, s44
		v_cmp_lt_i32_e64 vcc, v18, s24
		v_add_u32_e32 v15, s44, v15
		s_add_u32 s44, s58, 0xb4f0
		s_addc_u32 s45, s59, 0
		v_cndmask_b32_e32 v15, v11, v15, vcc
		s_add_u32 s44, s44, s68
		s_addc_u32 s45, s45, s69
		s_add_u32 s52, s44, 0
		s_addc_u32 s53, s45, 0
		s_mov_b32 m0, s52
		s_nop 0
		buffer_load_dwordx4 v15, s[32:35], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_2
.L_attn_fwd_persistent.if_else_2:
.L_attn_fwd_persistent.if_end_2:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[160:175], v[24:27], a[8:11], 0
		v_lshrrev_b32_e32 v15, 5, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v18, 4
		v_mul_lo_u32 v18, v18, v15
		v_add_u32_e32 v15, s38, v18
		v_lshrrev_b32_e32 v18, 5, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v19, 4
		v_mul_lo_u32 v19, v19, v18
		v_xor_b32_e32 v18, 1, v19
		v_add_u32_e32 v18, s38, v18
		v_lshrrev_b32_e32 v19, 5, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 4
		v_mul_lo_u32 v20, v20, v19
		v_xor_b32_e32 v19, 2, v20
		v_add_u32_e32 v19, s38, v19
		v_lshrrev_b32_e32 v20, 5, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v22, 4
		v_mul_lo_u32 v22, v22, v20
		v_xor_b32_e32 v20, 3, v22
		v_add_u32_e32 v20, s38, v20
		v_lshrrev_b32_e32 v22, 5, v0
		v_and_b32_e32 v22, 1, v22
		v_mov_b32_e32 v23, 4
		v_mul_lo_u32 v23, v23, v22
		v_xor_b32_e32 v22, 10, v23
		v_add_u32_e32 v22, s38, v22
		v_lshrrev_b32_e32 v23, 5, v0
		v_and_b32_e32 v23, 1, v23
		v_mov_b32_e32 v29, 4
		v_mul_lo_u32 v29, v29, v23
		v_xor_b32_e32 v23, 11, v29
		v_add_u32_e32 v23, s38, v23
		v_lshrrev_b32_e32 v29, 5, v0
		v_and_b32_e32 v29, 1, v29
		v_mov_b32_e32 v31, 4
		v_mul_lo_u32 v31, v31, v29
		v_xor_b32_e32 v29, 18, v31
		v_add_u32_e32 v29, s38, v29
		v_mfma_f32_32x32x16_bf16 v[176:191], v[68:71], a[8:11], 0
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
		v_lshrrev_b32_e32 v31, 5, v0
		v_and_b32_e32 v31, 1, v31
		v_mov_b32_e32 v56, 4
		v_mul_lo_u32 v56, v56, v31
		v_xor_b32_e32 v31, 19, v56
		v_add_u32_e32 v31, s38, v31
		v_lshrrev_b32_e32 v56, 5, v0
		v_and_b32_e32 v56, 1, v56
		v_mov_b32_e32 v58, 4
		v_mul_lo_u32 v58, v58, v56
		v_xor_b32_e32 v56, 26, v58
		v_add_u32_e32 v56, s38, v56
		v_lshrrev_b32_e32 v58, 5, v0
		v_and_b32_e32 v58, 1, v58
		v_mov_b32_e32 v65, 4
		v_mul_lo_u32 v65, v65, v58
		v_xor_b32_e32 v58, 27, v65
		v_add_u32_e32 v58, s38, v58
		v_lshrrev_b32_e32 v65, 5, v0
		v_and_b32_e32 v65, 1, v65
		v_mov_b32_e32 v66, 4
		v_mul_lo_u32 v66, v66, v65
		v_xor_b32_e32 v65, 34, v66
		v_add_u32_e32 v65, s38, v65
		v_lshrrev_b32_e32 v66, 5, v0
		v_and_b32_e32 v66, 1, v66
		v_mov_b32_e32 v67, 4
		v_mul_lo_u32 v67, v67, v66
		v_xor_b32_e32 v66, 35, v67
		v_add_u32_e32 v66, s38, v66
		v_lshrrev_b32_e32 v67, 5, v0
		v_and_b32_e32 v67, 1, v67
		v_mov_b32_e32 v156, 4
		v_mul_lo_u32 v156, v156, v67
		v_xor_b32_e32 v67, 42, v156
		v_add_u32_e32 v67, s38, v67
		v_lshrrev_b32_e32 v156, 5, v0
		v_and_b32_e32 v156, 1, v156
		v_mov_b32_e32 v157, 4
		v_mul_lo_u32 v157, v157, v156
		v_xor_b32_e32 v156, 43, v157
		v_add_u32_e32 v156, s38, v156
		v_mfma_f32_32x32x16_bf16 v[176:191], v[116:119], a[8:11], 0
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
		v_lshrrev_b32_e32 v157, 5, v0
		v_and_b32_e32 v157, 1, v157
		v_mov_b32_e32 v158, 4
		v_mul_lo_u32 v158, v158, v157
		v_xor_b32_e32 v157, 50, v158
		v_add_u32_e32 v157, s38, v157
		v_lshrrev_b32_e32 v158, 5, v0
		v_and_b32_e32 v158, 1, v158
		v_mov_b32_e32 v159, 4
		v_mul_lo_u32 v159, v159, v158
		v_xor_b32_e32 v158, 51, v159
		v_add_u32_e32 v158, s38, v158
		v_lshrrev_b32_e32 v159, 5, v0
		v_and_b32_e32 v159, 1, v159
		v_mov_b32_e32 v176, 4
		v_mul_lo_u32 v176, v176, v159
		v_xor_b32_e32 v159, 58, v176
		v_add_u32_e32 v159, s38, v159
		v_lshrrev_b32_e32 v176, 5, v0
		v_and_b32_e32 v176, 1, v176
		v_mov_b32_e32 v177, 4
		v_mul_lo_u32 v177, v177, v176
		v_xor_b32_e32 v176, 59, v177
		v_add_u32_e32 v176, s38, v176
		v_lshrrev_b32_e32 v177, 5, v0
		v_and_b32_e32 v177, 1, v177
		v_mov_b32_e32 v178, 4
		v_mul_lo_u32 v178, v178, v177
		v_xor_b32_e32 v177, 0x42, v178
		v_add_u32_e32 v177, s38, v177
		v_lshrrev_b32_e32 v178, 5, v0
		v_and_b32_e32 v178, 1, v178
		v_mov_b32_e32 v179, 4
		v_mul_lo_u32 v179, v179, v178
		v_xor_b32_e32 v178, 0x43, v179
		v_add_u32_e32 v178, s38, v178
		v_lshrrev_b32_e32 v179, 5, v0
		v_and_b32_e32 v179, 1, v179
		v_mov_b32_e32 v180, 4
		v_mul_lo_u32 v180, v180, v179
		v_xor_b32_e32 v179, 0x4a, v180
		v_add_u32_e32 v179, s38, v179
		v_mfma_f32_32x32x16_bf16 v[192:207], v[132:135], a[8:11], 0
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
		v_lshrrev_b32_e32 v180, 5, v0
		v_and_b32_e32 v180, 1, v180
		v_mov_b32_e32 v181, 4
		v_mul_lo_u32 v181, v181, v180
		v_xor_b32_e32 v180, 0x4b, v181
		v_add_u32_e32 v180, s38, v180
		v_lshrrev_b32_e32 v181, 5, v0
		v_and_b32_e32 v181, 1, v181
		v_mov_b32_e32 v182, 4
		v_mul_lo_u32 v182, v182, v181
		v_xor_b32_e32 v181, 0x52, v182
		v_add_u32_e32 v181, s38, v181
		v_lshrrev_b32_e32 v182, 5, v0
		v_and_b32_e32 v182, 1, v182
		v_mov_b32_e32 v183, 4
		v_mul_lo_u32 v183, v183, v182
		v_xor_b32_e32 v182, 0x53, v183
		v_add_u32_e32 v182, s38, v182
		v_lshrrev_b32_e32 v183, 5, v0
		v_and_b32_e32 v183, 1, v183
		v_mov_b32_e32 v184, 4
		v_mul_lo_u32 v184, v184, v183
		v_xor_b32_e32 v183, 0x5a, v184
		v_add_u32_e32 v183, s38, v183
		v_lshrrev_b32_e32 v184, 5, v0
		v_and_b32_e32 v184, 1, v184
		v_mov_b32_e32 v185, 4
		v_mul_lo_u32 v185, v185, v184
		v_xor_b32_e32 v184, 0x5b, v185
		v_add_u32_e32 v184, s38, v184
		v_lshrrev_b32_e32 v185, 5, v0
		v_and_b32_e32 v185, 1, v185
		v_mov_b32_e32 v186, 4
		v_mul_lo_u32 v186, v186, v185
		v_xor_b32_e32 v185, 0x62, v186
		v_add_u32_e32 v185, s38, v185
		v_lshrrev_b32_e32 v186, 5, v0
		v_and_b32_e32 v186, 1, v186
		v_mov_b32_e32 v187, 4
		v_mul_lo_u32 v187, v187, v186
		v_xor_b32_e32 v186, 0x63, v187
		v_add_u32_e32 v186, s38, v186
		v_mfma_f32_32x32x16_bf16 v[192:207], v[132:135], a[24:27], 0
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
		v_add_u32_e32 v132, s38, v132
		v_lshrrev_b32_e32 v133, 5, v0
		v_and_b32_e32 v133, 1, v133
		v_mov_b32_e32 v134, 4
		v_mul_lo_u32 v134, v134, v133
		v_xor_b32_e32 v133, 0x6b, v134
		v_add_u32_e32 v133, s38, v133
		v_lshrrev_b32_e32 v134, 5, v0
		v_and_b32_e32 v134, 1, v134
		v_mov_b32_e32 v135, 4
		v_mul_lo_u32 v135, v135, v134
		v_xor_b32_e32 v134, 0x72, v135
		v_add_u32_e32 v134, s38, v134
		v_lshrrev_b32_e32 v135, 5, v0
		v_and_b32_e32 v135, 1, v135
		v_mov_b32_e32 v187, 4
		v_mul_lo_u32 v187, v187, v135
		v_xor_b32_e32 v135, 0x73, v187
		v_add_u32_e32 v135, s38, v135
		v_lshrrev_b32_e32 v187, 5, v0
		v_and_b32_e32 v187, 1, v187
		v_mov_b32_e32 v188, 4
		v_mul_lo_u32 v188, v188, v187
		v_xor_b32_e32 v187, 0x7a, v188
		v_add_u32_e32 v187, s38, v187
		v_lshrrev_b32_e32 v188, 5, v0
		v_and_b32_e32 v188, 1, v188
		v_mov_b32_e32 v189, 4
		v_mul_lo_u32 v189, v189, v188
		v_xor_b32_e32 v188, 0x7b, v189
		v_add_u32_e32 v188, s38, v188
		v_cmp_ge_i32_e64 vcc, v10, v15
		s_mov_b64 s[44:45], vcc
		v_mfma_f32_32x32x16_bf16 v[192:207], v[24:27], a[24:27], 0
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
		v_cmp_ge_i32_e64 vcc, v10, v18
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v10, v19
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v10, v20
		v_lshrrev_b32_e32 v24, 5, v0
		v_and_b32_e32 v24, 1, v24
		v_mov_b32_e32 v25, 4
		v_mul_lo_u32 v25, v25, v24
		v_xor_b32_e32 v24, 8, v25
		v_add_u32_e32 v24, s38, v24
		v_lshrrev_b32_e32 v25, 5, v0
		v_and_b32_e32 v25, 1, v25
		v_mov_b32_e32 v26, 4
		v_mul_lo_u32 v26, v26, v25
		v_xor_b32_e32 v25, 9, v26
		v_add_u32_e32 v25, s38, v25
		v_lshrrev_b32_e32 v26, 5, v0
		v_and_b32_e32 v26, 1, v26
		v_mov_b32_e32 v27, 4
		v_mul_lo_u32 v27, v27, v26
		v_xor_b32_e32 v26, 16, v27
		v_add_u32_e32 v26, s38, v26
		v_lshrrev_b32_e32 v27, 5, v0
		v_and_b32_e32 v27, 1, v27
		v_mov_b32_e32 v189, 4
		v_mul_lo_u32 v189, v189, v27
		v_xor_b32_e32 v27, 17, v189
		v_add_u32_e32 v27, s38, v27
		v_mfma_f32_32x32x16_bf16 v[192:207], v[68:71], a[24:27], 0
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
		v_lshrrev_b32_e32 v68, 5, v0
		v_and_b32_e32 v68, 1, v68
		v_mov_b32_e32 v69, 4
		v_mul_lo_u32 v69, v69, v68
		v_xor_b32_e32 v68, 24, v69
		v_add_u32_e32 v68, s38, v68
		v_lshrrev_b32_e32 v69, 5, v0
		v_and_b32_e32 v69, 1, v69
		v_mov_b32_e32 v70, 4
		v_mul_lo_u32 v70, v70, v69
		v_xor_b32_e32 v69, 25, v70
		v_add_u32_e32 v69, s38, v69
		v_lshrrev_b32_e32 v70, 5, v0
		v_and_b32_e32 v70, 1, v70
		v_mov_b32_e32 v71, 4
		v_mul_lo_u32 v71, v71, v70
		v_xor_b32_e32 v70, 32, v71
		v_add_u32_e32 v70, s38, v70
		v_lshrrev_b32_e32 v71, 5, v0
		v_and_b32_e32 v71, 1, v71
		v_mov_b32_e32 v189, 4
		v_mul_lo_u32 v189, v189, v71
		v_xor_b32_e32 v71, 33, v189
		v_add_u32_e32 v71, s38, v71
		v_lshrrev_b32_e32 v189, 5, v0
		v_and_b32_e32 v189, 1, v189
		v_mov_b32_e32 v190, 4
		v_mul_lo_u32 v190, v190, v189
		v_xor_b32_e32 v189, 40, v190
		v_add_u32_e32 v189, s38, v189
		v_lshrrev_b32_e32 v190, 5, v0
		v_and_b32_e32 v190, 1, v190
		v_mov_b32_e32 v191, 4
		v_mul_lo_u32 v191, v191, v190
		v_xor_b32_e32 v190, 41, v191
		v_add_u32_e32 v190, s38, v190
		v_lshrrev_b32_e32 v191, 5, v0
		v_and_b32_e32 v191, 1, v191
		v_mov_b32_e32 v192, 4
		v_mul_lo_u32 v192, v192, v191
		v_xor_b32_e32 v191, 48, v192
		v_add_u32_e32 v191, s38, v191
		v_mfma_f32_32x32x16_bf16 v[192:207], v[116:119], a[24:27], 0
		v_lshrrev_b32_e32 v116, 5, v0
		v_and_b32_e32 v116, 1, v116
		v_mov_b32_e32 v117, 4
		v_mul_lo_u32 v117, v117, v116
		v_xor_b32_e32 v116, 49, v117
		v_add_u32_e32 v116, s38, v116
		v_lshrrev_b32_e32 v117, 5, v0
		v_and_b32_e32 v117, 1, v117
		v_mov_b32_e32 v118, 4
		v_mul_lo_u32 v118, v118, v117
		v_xor_b32_e32 v117, 56, v118
		v_add_u32_e32 v117, s38, v117
		v_lshrrev_b32_e32 v118, 5, v0
		v_and_b32_e32 v118, 1, v118
		v_mov_b32_e32 v119, 4
		v_mul_lo_u32 v119, v119, v118
		v_xor_b32_e32 v118, 57, v119
		v_add_u32_e32 v118, s38, v118
		v_lshrrev_b32_e32 v119, 5, v0
		v_and_b32_e32 v119, 1, v119
		v_mov_b32_e32 v208, 4
		v_mul_lo_u32 v208, v208, v119
		v_xor_b32_e32 v119, 64, v208
		v_add_u32_e32 v119, s38, v119
		v_lshrrev_b32_e32 v208, 5, v0
		v_and_b32_e32 v208, 1, v208
		v_mov_b32_e32 v209, 4
		v_mul_lo_u32 v209, v209, v208
		v_xor_b32_e32 v208, 0x41, v209
		v_add_u32_e32 v208, s38, v208
		v_lshrrev_b32_e32 v209, 5, v0
		v_and_b32_e32 v209, 1, v209
		v_mov_b32_e32 v210, 4
		v_mul_lo_u32 v210, v210, v209
		v_xor_b32_e32 v209, 0x48, v210
		v_add_u32_e32 v209, s38, v209
		v_lshrrev_b32_e32 v210, 5, v0
		v_and_b32_e32 v210, 1, v210
		v_mov_b32_e32 v211, 4
		v_mul_lo_u32 v211, v211, v210
		v_xor_b32_e32 v210, 0x49, v211
		v_add_u32_e32 v210, s38, v210
		v_mfma_f32_32x32x16_bf16 v[160:175], v[48:51], a[12:15], v[160:175]
		v_lshrrev_b32_e32 v211, 5, v0
		v_and_b32_e32 v211, 1, v211
		v_mov_b32_e32 v212, 4
		v_mul_lo_u32 v212, v212, v211
		v_xor_b32_e32 v211, 0x50, v212
		v_add_u32_e32 v211, s38, v211
		v_lshrrev_b32_e32 v212, 5, v0
		v_and_b32_e32 v212, 1, v212
		v_mov_b32_e32 v213, 4
		v_mul_lo_u32 v213, v213, v212
		v_xor_b32_e32 v212, 0x51, v213
		v_add_u32_e32 v212, s38, v212
		v_lshrrev_b32_e32 v213, 5, v0
		v_and_b32_e32 v213, 1, v213
		v_mov_b32_e32 v214, 4
		v_mul_lo_u32 v214, v214, v213
		v_xor_b32_e32 v213, 0x58, v214
		v_add_u32_e32 v213, s38, v213
		v_lshrrev_b32_e32 v214, 5, v0
		v_and_b32_e32 v214, 1, v214
		v_mov_b32_e32 v215, 4
		v_mul_lo_u32 v215, v215, v214
		v_xor_b32_e32 v214, 0x59, v215
		v_add_u32_e32 v214, s38, v214
		v_lshrrev_b32_e32 v215, 5, v0
		v_and_b32_e32 v215, 1, v215
		v_mov_b32_e32 v216, 4
		v_mul_lo_u32 v216, v216, v215
		v_xor_b32_e32 v215, 0x60, v216
		v_add_u32_e32 v215, s38, v215
		v_lshrrev_b32_e32 v216, 5, v0
		v_and_b32_e32 v216, 1, v216
		v_mov_b32_e32 v217, 4
		v_mul_lo_u32 v217, v217, v216
		v_xor_b32_e32 v216, 0x61, v217
		v_add_u32_e32 v216, s38, v216
		v_lshrrev_b32_e32 v217, 5, v0
		v_and_b32_e32 v217, 1, v217
		v_mov_b32_e32 v218, 4
		v_mul_lo_u32 v218, v218, v217
		v_xor_b32_e32 v217, 0x68, v218
		v_add_u32_e32 v217, s38, v217
		v_mfma_f32_32x32x16_bf16 a[112:127], v[72:75], a[12:15], a[112:127]
		v_lshrrev_b32_e32 v218, 5, v0
		v_and_b32_e32 v218, 1, v218
		v_mov_b32_e32 v219, 4
		v_mul_lo_u32 v219, v219, v218
		v_xor_b32_e32 v218, 0x69, v219
		v_add_u32_e32 v218, s38, v218
		v_lshrrev_b32_e32 v219, 5, v0
		v_and_b32_e32 v219, 1, v219
		v_mov_b32_e32 v220, 4
		v_mul_lo_u32 v220, v220, v219
		v_xor_b32_e32 v219, 0x70, v220
		v_add_u32_e32 v219, s38, v219
		v_lshrrev_b32_e32 v220, 5, v0
		v_and_b32_e32 v220, 1, v220
		v_mov_b32_e32 v221, 4
		v_mul_lo_u32 v221, v221, v220
		v_xor_b32_e32 v220, 0x71, v221
		v_add_u32_e32 v220, s38, v220
		v_lshrrev_b32_e32 v221, 5, v0
		v_and_b32_e32 v221, 1, v221
		v_mov_b32_e32 v222, 4
		v_mul_lo_u32 v222, v222, v221
		v_xor_b32_e32 v221, 0x78, v222
		v_add_u32_e32 v221, s38, v221
		v_lshrrev_b32_e32 v222, 5, v0
		v_and_b32_e32 v222, 1, v222
		v_mov_b32_e32 v223, 4
		v_mul_lo_u32 v223, v223, v222
		v_xor_b32_e32 v222, 0x79, v223
		v_add_u32_e32 v222, s38, v222
		v_mfma_f32_32x32x16_bf16 a[128:143], v[120:123], a[12:15], a[128:143]
		v_mfma_f32_32x32x16_bf16 a[144:159], v[136:139], a[12:15], a[144:159]
		v_mfma_f32_32x32x16_bf16 a[160:175], v[136:139], a[28:31], a[160:175]
		v_mfma_f32_32x32x16_bf16 a[176:191], v[48:51], a[28:31], a[176:191]
		v_mfma_f32_32x32x16_bf16 a[192:207], v[72:75], a[28:31], a[192:207]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[120:123], a[28:31], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[52:55], a[16:19], v[160:175]
		v_mfma_f32_32x32x16_bf16 a[112:127], v[76:79], a[16:19], a[112:127]
		v_mfma_f32_32x32x16_bf16 a[128:143], v[124:127], a[16:19], a[128:143]
		v_mfma_f32_32x32x16_bf16 a[144:159], v[140:143], a[16:19], a[144:159]
		v_mfma_f32_32x32x16_bf16 a[160:175], v[140:143], a[32:35], a[160:175]
		v_mfma_f32_32x32x16_bf16 a[176:191], v[52:55], a[32:35], a[176:191]
		v_mfma_f32_32x32x16_bf16 a[192:207], v[76:79], a[32:35], a[192:207]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[124:127], a[32:35], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[60:63], a[20:23], v[160:175]
		v_mfma_f32_32x32x16_bf16 a[112:127], v[112:115], a[20:23], a[112:127]
		v_mfma_f32_32x32x16_bf16 a[128:143], v[128:131], a[20:23], a[128:143]
		v_mfma_f32_32x32x16_bf16 a[144:159], v[144:147], a[20:23], a[144:159]
		v_mfma_f32_32x32x16_bf16 a[160:175], v[144:147], a[36:39], a[160:175]
		v_mfma_f32_32x32x16_bf16 a[176:191], v[60:63], a[36:39], a[176:191]
		v_mfma_f32_32x32x16_bf16 a[192:207], v[112:115], a[36:39], a[192:207]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[128:131], a[36:39], v[192:207]
		s_cmp_lt_i32 s27, s37
		v_mov_b32_e32 v48, 0xff800000
		s_nop 2
		v_cndmask_b32_e32 v51, v48, v163, vcc
		v_cmp_ge_i32_e64 vcc, v10, v24
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v10, v25
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v10, v22
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v10, v23
		v_cndmask_b32_e64 v52, v48, v160, s[44:45]
		v_cndmask_b32_e64 v53, v48, v161, s[52:53]
		v_cndmask_b32_e32 v55, v48, v167, vcc
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v10, v27
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v10, v29
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v10, v31
		v_cndmask_b32_e64 v50, v48, v162, s[54:55]
		v_cndmask_b32_e64 v60, v48, v164, s[58:59]
		v_cndmask_b32_e32 v63, v48, v171, vcc
		v_cmp_ge_i32_e64 vcc, v10, v68
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v10, v69
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v10, v56
		s_mov_b64 s[66:67], vcc
		v_cmp_ge_i32_e64 vcc, v10, v58
		v_cndmask_b32_e64 v61, v48, v165, s[60:61]
		v_cndmask_b32_e64 v54, v48, v166, s[62:63]
		v_cndmask_b32_e32 v73, v48, v175, vcc
		v_cmp_ge_i32_e64 vcc, v10, v70
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v10, v71
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v10, v65
		s_mov_b64 s[68:69], vcc
		v_cmp_ge_i32_e64 vcc, v10, v66
		v_cndmask_b32_e64 v74, v48, v168, s[44:45]
		v_cndmask_b32_e64 v75, v48, v169, s[52:53]
		v_accvgpr_read_b32 v49, a115
		v_cndmask_b32_e32 v77, v48, v49, vcc
		v_cmp_ge_i32_e64 vcc, v10, v189
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v10, v190
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v10, v67
		s_mov_b64 s[70:71], vcc
		v_cmp_ge_i32_e64 vcc, v10, v156
		v_cndmask_b32_e64 v62, v48, v170, s[64:65]
		v_cndmask_b32_e64 v78, v48, v172, s[54:55]
		v_accvgpr_read_b32 v49, a119
		v_cndmask_b32_e32 v113, v48, v49, vcc
		v_cmp_ge_i32_e64 vcc, v10, v191
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v10, v116
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v10, v157
		s_mov_b64 s[72:73], vcc
		v_cmp_ge_i32_e64 vcc, v10, v158
		v_cndmask_b32_e64 v79, v48, v173, s[58:59]
		v_cndmask_b32_e64 v72, v48, v174, s[66:67]
		v_accvgpr_read_b32 v49, a123
		v_cndmask_b32_e32 v115, v48, v49, vcc
		v_cmp_ge_i32_e64 vcc, v10, v117
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v10, v118
		s_mov_b64 s[66:67], vcc
		v_cmp_ge_i32_e64 vcc, v10, v159
		s_mov_b64 s[74:75], vcc
		v_cmp_ge_i32_e64 vcc, v10, v176
		v_accvgpr_read_b32 v49, a112
		v_cndmask_b32_e64 v120, v48, v49, s[60:61]
		v_accvgpr_read_b32 v49, a113
		v_cndmask_b32_e64 v121, v48, v49, s[62:63]
		v_accvgpr_read_b32 v49, a127
		v_cndmask_b32_e32 v123, v48, v49, vcc
		v_cmp_ge_i32_e64 vcc, v10, v119
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v10, v208
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v10, v177
		s_mov_b64 s[76:77], vcc
		v_cmp_ge_i32_e64 vcc, v10, v178
		v_accvgpr_read_b32 v49, a114
		v_cndmask_b32_e64 v76, v48, v49, s[68:69]
		v_accvgpr_read_b32 v49, a116
		v_cndmask_b32_e64 v124, v48, v49, s[44:45]
		v_accvgpr_read_b32 v49, a131
		v_cndmask_b32_e32 v127, v48, v49, vcc
		v_cmp_ge_i32_e64 vcc, v10, v209
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v10, v210
		s_mov_b64 s[68:69], vcc
		v_cmp_ge_i32_e64 vcc, v10, v179
		s_mov_b64 s[78:79], vcc
		v_cmp_ge_i32_e64 vcc, v10, v180
		v_accvgpr_read_b32 v49, a117
		v_cndmask_b32_e64 v125, v48, v49, s[52:53]
		v_accvgpr_read_b32 v49, a118
		v_cndmask_b32_e64 v112, v48, v49, s[70:71]
		v_accvgpr_read_b32 v49, a135
		v_cndmask_b32_e32 v129, v48, v49, vcc
		v_cmp_ge_i32_e64 vcc, v10, v211
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v10, v212
		s_mov_b64 s[70:71], vcc
		v_cmp_ge_i32_e64 vcc, v10, v181
		s_mov_b64 s[80:81], vcc
		v_cmp_ge_i32_e64 vcc, v10, v182
		v_accvgpr_read_b32 v49, a120
		v_cndmask_b32_e64 v130, v48, v49, s[54:55]
		v_accvgpr_read_b32 v49, a121
		v_cndmask_b32_e64 v131, v48, v49, s[64:65]
		v_accvgpr_read_b32 v49, a139
		v_cndmask_b32_e32 v137, v48, v49, vcc
		v_cmp_ge_i32_e64 vcc, v10, v213
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v10, v214
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v10, v183
		s_mov_b64 s[82:83], vcc
		v_accvgpr_read_b32 v49, a141
		v_cndmask_b32_e64 v139, v48, v49, s[64:65]
		v_accvgpr_read_b32 v49, a142
		v_cndmask_b32_e64 v140, v48, v49, s[82:83]
		v_cmp_ge_i32_e64 vcc, v10, v184
		v_accvgpr_read_b32 v49, a122
		v_cndmask_b32_e64 v114, v48, v49, s[72:73]
		v_accvgpr_read_b32 v49, a124
		v_cndmask_b32_e64 v142, v48, v49, s[58:59]
		v_accvgpr_read_b32 v49, a143
		v_cndmask_b32_e32 v141, v48, v49, vcc
		v_cmp_ge_i32_e64 vcc, v10, v215
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v10, v216
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v10, v185
		s_mov_b64 s[72:73], vcc
		v_accvgpr_read_b32 v49, a144
		v_cndmask_b32_e64 v144, v48, v49, s[58:59]
		v_accvgpr_read_b32 v49, a145
		v_cndmask_b32_e64 v145, v48, v49, s[64:65]
		v_accvgpr_read_b32 v49, a146
		v_cndmask_b32_e64 v146, v48, v49, s[72:73]
		v_cmp_ge_i32_e64 vcc, v10, v186
		v_accvgpr_read_b32 v49, a125
		v_cndmask_b32_e64 v143, v48, v49, s[66:67]
		v_accvgpr_read_b32 v49, a126
		v_cndmask_b32_e64 v122, v48, v49, s[74:75]
		v_accvgpr_read_b32 v49, a147
		v_cndmask_b32_e32 v147, v48, v49, vcc
		v_cmp_ge_i32_e64 vcc, v10, v217
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v10, v218
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v10, v132
		s_mov_b64 s[66:67], vcc
		v_accvgpr_read_b32 v49, a148
		v_cndmask_b32_e64 v160, v48, v49, s[58:59]
		v_accvgpr_read_b32 v49, a149
		v_cndmask_b32_e64 v161, v48, v49, s[64:65]
		v_accvgpr_read_b32 v49, a150
		v_cndmask_b32_e64 v162, v48, v49, s[66:67]
		v_cmp_ge_i32_e64 vcc, v10, v133
		v_accvgpr_read_b32 v49, a128
		v_cndmask_b32_e64 v164, v48, v49, s[60:61]
		v_accvgpr_read_b32 v49, a129
		v_cndmask_b32_e64 v165, v48, v49, s[62:63]
		v_accvgpr_read_b32 v49, a151
		v_cndmask_b32_e32 v163, v48, v49, vcc
		v_cmp_ge_i32_e64 vcc, v10, v219
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v10, v220
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v10, v134
		s_mov_b64 s[62:63], vcc
		v_accvgpr_read_b32 v49, a152
		v_cndmask_b32_e64 v166, v48, v49, s[58:59]
		v_accvgpr_read_b32 v49, a153
		v_cndmask_b32_e64 v167, v48, v49, s[60:61]
		v_accvgpr_read_b32 v49, a154
		v_cndmask_b32_e64 v168, v48, v49, s[62:63]
		v_cmp_ge_i32_e64 vcc, v10, v135
		v_accvgpr_read_b32 v49, a130
		v_cndmask_b32_e64 v126, v48, v49, s[76:77]
		v_accvgpr_read_b32 v49, a132
		v_cndmask_b32_e64 v170, v48, v49, s[44:45]
		v_accvgpr_read_b32 v49, a155
		v_cndmask_b32_e32 v169, v48, v49, vcc
		v_cmp_ge_i32_e64 vcc, v10, v221
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v10, v222
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v10, v187
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v49, a156
		v_cndmask_b32_e64 v172, v48, v49, s[44:45]
		v_accvgpr_read_b32 v49, a157
		v_cndmask_b32_e64 v173, v48, v49, s[58:59]
		v_accvgpr_read_b32 v49, a158
		v_cndmask_b32_e64 v174, v48, v49, s[60:61]
		v_cmp_ge_i32_e64 vcc, v10, v188
		v_accvgpr_read_b32 v49, a133
		v_cndmask_b32_e64 v171, v48, v49, s[68:69]
		v_accvgpr_read_b32 v49, a134
		v_cndmask_b32_e64 v128, v48, v49, s[78:79]
		v_accvgpr_read_b32 v49, a159
		v_cndmask_b32_e32 v175, v48, v49, vcc
		v_cmp_ge_i32_e64 vcc, v1, v15
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v1, v18
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v1, v19
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v15, a176
		v_cndmask_b32_e64 v18, v48, v15, s[44:45]
		v_accvgpr_read_b32 v15, a177
		v_cndmask_b32_e64 v19, v48, v15, s[58:59]
		v_accvgpr_read_b32 v15, a178
		v_cndmask_b32_e64 v224, v48, v15, s[60:61]
		v_cmp_ge_i32_e64 vcc, v1, v20
		v_accvgpr_read_b32 v15, a136
		v_cndmask_b32_e64 v226, v48, v15, s[52:53]
		v_accvgpr_read_b32 v15, a137
		v_cndmask_b32_e64 v227, v48, v15, s[70:71]
		v_accvgpr_read_b32 v15, a179
		v_cndmask_b32_e32 v225, v48, v15, vcc
		v_cmp_ge_i32_e64 vcc, v1, v24
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v1, v25
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v1, v22
		s_mov_b64 s[58:59], vcc
		v_accvgpr_read_b32 v15, a180
		v_cndmask_b32_e64 v24, v48, v15, s[44:45]
		v_accvgpr_read_b32 v15, a181
		v_cndmask_b32_e64 v25, v48, v15, s[52:53]
		v_accvgpr_read_b32 v15, a182
		v_cndmask_b32_e64 v228, v48, v15, s[58:59]
		v_cmp_ge_i32_e64 vcc, v1, v23
		v_accvgpr_read_b32 v15, a138
		v_cndmask_b32_e64 v136, v48, v15, s[80:81]
		v_accvgpr_read_b32 v15, a140
		v_cndmask_b32_e64 v138, v48, v15, s[54:55]
		v_accvgpr_read_b32 v15, a183
		v_cndmask_b32_e32 v229, v48, v15, vcc
		v_cmp_ge_i32_e64 vcc, v1, v26
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v1, v27
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v1, v29
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v15, a184
		v_cndmask_b32_e64 v22, v48, v15, s[44:45]
		v_accvgpr_read_b32 v15, a185
		v_cndmask_b32_e64 v23, v48, v15, s[52:53]
		v_accvgpr_read_b32 v15, a186
		v_cndmask_b32_e64 v26, v48, v15, s[54:55]
		v_cmp_ge_i32_e64 vcc, v1, v31
		v_max_f32_e32 v15, v52, v53
		v_max_f32_e32 v20, v50, v51
		v_accvgpr_read_b32 v27, a187
		v_cndmask_b32_e32 v27, v48, v27, vcc
		v_cmp_ge_i32_e64 vcc, v1, v68
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v1, v69
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v1, v56
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v29, a188
		v_cndmask_b32_e64 v68, v48, v29, s[44:45]
		v_accvgpr_read_b32 v29, a189
		v_cndmask_b32_e64 v69, v48, v29, s[52:53]
		v_accvgpr_read_b32 v29, a190
		v_cndmask_b32_e64 v230, v48, v29, s[54:55]
		v_cmp_ge_i32_e64 vcc, v1, v58
		v_max_f32_e32 v29, v60, v61
		v_max_f32_e32 v31, v54, v55
		v_accvgpr_read_b32 v49, a191
		v_cndmask_b32_e32 v231, v48, v49, vcc
		v_cmp_ge_i32_e64 vcc, v1, v70
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v1, v71
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v1, v65
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v49, a192
		v_cndmask_b32_e64 v70, v48, v49, s[44:45]
		v_accvgpr_read_b32 v49, a193
		v_cndmask_b32_e64 v71, v48, v49, s[52:53]
		v_accvgpr_read_b32 v49, a194
		v_cndmask_b32_e64 v232, v48, v49, s[54:55]
		v_cmp_ge_i32_e64 vcc, v1, v66
		v_max_f32_e32 v49, v74, v75
		v_max_f32_e32 v56, v62, v63
		v_accvgpr_read_b32 v58, a195
		v_cndmask_b32_e32 v233, v48, v58, vcc
		v_cmp_ge_i32_e64 vcc, v1, v189
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v1, v190
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v1, v67
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v58, a196
		v_cndmask_b32_e64 v66, v48, v58, s[44:45]
		v_accvgpr_read_b32 v58, a197
		v_cndmask_b32_e64 v67, v48, v58, s[52:53]
		v_accvgpr_read_b32 v58, a198
		v_cndmask_b32_e64 v234, v48, v58, s[54:55]
		v_cmp_ge_i32_e64 vcc, v1, v156
		v_max_f32_e32 v58, v78, v79
		v_max_f32_e32 v65, v72, v73
		v_accvgpr_read_b32 v156, a199
		v_cndmask_b32_e32 v235, v48, v156, vcc
		v_cmp_ge_i32_e64 vcc, v1, v191
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v1, v116
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v1, v157
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v116, a200
		v_cndmask_b32_e64 v156, v48, v116, s[44:45]
		v_accvgpr_read_b32 v116, a201
		v_cndmask_b32_e64 v157, v48, v116, s[52:53]
		v_accvgpr_read_b32 v116, a202
		v_cndmask_b32_e64 v190, v48, v116, s[54:55]
		v_cmp_ge_i32_e64 vcc, v1, v158
		v_max_f32_e32 v116, v120, v121
		v_max_f32_e32 v158, v76, v77
		v_accvgpr_read_b32 v189, a203
		v_cndmask_b32_e32 v191, v48, v189, vcc
		v_cmp_ge_i32_e64 vcc, v1, v117
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v1, v118
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v1, v159
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v117, a204
		v_cndmask_b32_e64 v236, v48, v117, s[44:45]
		v_accvgpr_read_b32 v117, a205
		v_cndmask_b32_e64 v237, v48, v117, s[52:53]
		v_accvgpr_read_b32 v117, a206
		v_cndmask_b32_e64 v238, v48, v117, s[54:55]
		v_cmp_ge_i32_e64 vcc, v1, v176
		v_max_f32_e32 v117, v124, v125
		v_max_f32_e32 v118, v112, v113
		v_accvgpr_read_b32 v159, a207
		v_cndmask_b32_e32 v239, v48, v159, vcc
		v_cmp_ge_i32_e64 vcc, v1, v119
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v1, v208
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v1, v177
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v176, v48, v192, s[44:45]
		v_cndmask_b32_e64 v177, v48, v193, s[52:53]
		v_cndmask_b32_e64 v192, v48, v194, s[54:55]
		v_cmp_ge_i32_e64 vcc, v1, v178
		v_max_f32_e32 v119, v130, v131
		v_max_f32_e32 v159, v114, v115
		v_cndmask_b32_e32 v193, v48, v195, vcc
		v_cmp_ge_i32_e64 vcc, v1, v209
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v1, v210
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v1, v179
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v178, v48, v196, s[44:45]
		v_cndmask_b32_e64 v179, v48, v197, s[52:53]
		v_cndmask_b32_e64 v194, v48, v198, s[54:55]
		v_cmp_ge_i32_e64 vcc, v1, v180
		v_max_f32_e32 v180, v142, v143
		v_max_f32_e32 v189, v122, v123
		v_cndmask_b32_e32 v195, v48, v199, vcc
		v_cmp_ge_i32_e64 vcc, v1, v211
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v1, v212
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v1, v181
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v196, v48, v200, s[44:45]
		v_cndmask_b32_e64 v197, v48, v201, s[52:53]
		v_cndmask_b32_e64 v198, v48, v202, s[54:55]
		v_cmp_ge_i32_e64 vcc, v1, v182
		v_max_f32_e32 v181, v164, v165
		v_max_f32_e32 v182, v126, v127
		v_cndmask_b32_e32 v199, v48, v203, vcc
		v_cmp_ge_i32_e64 vcc, v1, v213
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v1, v214
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v1, v183
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v200, v48, v204, s[44:45]
		v_cndmask_b32_e64 v201, v48, v205, s[52:53]
		v_cndmask_b32_e64 v202, v48, v206, s[54:55]
		v_cmp_ge_i32_e64 vcc, v1, v184
		v_max_f32_e32 v183, v170, v171
		v_max_f32_e32 v184, v128, v129
		v_cndmask_b32_e32 v203, v48, v207, vcc
		v_cmp_ge_i32_e64 vcc, v1, v215
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v1, v216
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v1, v185
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v185, a160
		v_cndmask_b32_e64 v204, v48, v185, s[44:45]
		v_accvgpr_read_b32 v185, a161
		v_cndmask_b32_e64 v205, v48, v185, s[52:53]
		v_accvgpr_read_b32 v185, a162
		v_cndmask_b32_e64 v206, v48, v185, s[54:55]
		v_cmp_ge_i32_e64 vcc, v1, v186
		v_max_f32_e32 v185, v226, v227
		v_max_f32_e32 v186, v136, v137
		v_accvgpr_read_b32 v207, a163
		v_cndmask_b32_e32 v207, v48, v207, vcc
		v_cmp_ge_i32_e64 vcc, v1, v217
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v1, v218
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v1, v132
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v132, a164
		v_cndmask_b32_e64 v208, v48, v132, s[44:45]
		v_accvgpr_read_b32 v132, a165
		v_cndmask_b32_e64 v209, v48, v132, s[52:53]
		v_accvgpr_read_b32 v132, a166
		v_cndmask_b32_e64 v210, v48, v132, s[54:55]
		v_cmp_ge_i32_e64 vcc, v1, v133
		v_max_f32_e32 v132, v138, v139
		v_max_f32_e32 v133, v140, v141
		v_accvgpr_read_b32 v211, a167
		v_cndmask_b32_e32 v211, v48, v211, vcc
		v_cmp_ge_i32_e64 vcc, v1, v219
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v1, v220
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v1, v134
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v134, a168
		v_cndmask_b32_e64 v212, v48, v134, s[44:45]
		v_accvgpr_read_b32 v134, a169
		v_cndmask_b32_e64 v213, v48, v134, s[52:53]
		v_accvgpr_read_b32 v134, a170
		v_cndmask_b32_e64 v214, v48, v134, s[54:55]
		v_cmp_ge_i32_e64 vcc, v1, v135
		v_max_f32_e32 v134, v144, v145
		v_max_f32_e32 v135, v146, v147
		v_accvgpr_read_b32 v215, a171
		v_cndmask_b32_e32 v215, v48, v215, vcc
		v_cmp_ge_i32_e64 vcc, v1, v221
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v1, v222
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v1, v187
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v187, a172
		v_cndmask_b32_e64 v216, v48, v187, s[44:45]
		v_accvgpr_read_b32 v187, a173
		v_cndmask_b32_e64 v217, v48, v187, s[52:53]
		v_accvgpr_read_b32 v187, a174
		v_cndmask_b32_e64 v218, v48, v187, s[54:55]
		v_cmp_ge_i32_e64 vcc, v1, v188
		v_max_f32_e32 v187, v160, v161
		v_max_f32_e32 v188, v162, v163
		v_accvgpr_read_b32 v219, a175
		v_cndmask_b32_e32 v219, v48, v219, vcc
		v_max_f32_e32 v48, v166, v167
		v_max_f32_e32 v220, v168, v169
		v_max_f32_e32 v221, v172, v173
		v_max_f32_e32 v222, v174, v175
		v_max_f32_e32 v15, v15, v20
		v_max_f32_e32 v20, v29, v31
		v_max_f32_e32 v29, v49, v56
		v_max_f32_e32 v31, v58, v65
		v_max_f32_e32 v49, v116, v158
		v_max_f32_e32 v56, v117, v118
		v_max_f32_e32 v58, v119, v159
		v_max_f32_e32 v65, v180, v189
		v_max_f32_e32 v116, v181, v182
		v_max_f32_e32 v117, v183, v184
		v_max_f32_e32 v118, v185, v186
		v_max_f32_e32 v119, v132, v133
		v_max_f32_e32 v132, v134, v135
		v_max_f32_e32 v133, v187, v188
		v_max_f32_e32 v48, v48, v220
		v_max_f32_e32 v134, v221, v222
		v_max_f32_e32 v15, v15, v20
		v_max_f32_e32 v20, v29, v31
		v_max_f32_e32 v29, v49, v56
		v_max_f32_e32 v31, v58, v65
		v_max_f32_e32 v49, v116, v117
		v_max_f32_e32 v56, v118, v119
		v_max_f32_e32 v58, v132, v133
		v_max_f32_e32 v48, v48, v134
		v_max_f32_e32 v15, v15, v20
		v_max_f32_e32 v20, v29, v31
		v_max_f32_e32 v29, v49, v56
		v_max_f32_e32 v31, v58, v48
		v_max_f32_e32 v15, v15, v20
		v_max_f32_e32 v20, v29, v31
		v_max_f32_e32 v15, v15, v20
		v_and_b32_e32 v20, 1, v9
		v_lshrrev_b32_e32 v29, 4, v9
		v_and_b32_e32 v29, 1, v29
		v_lshlrev_b32_e32 v29, 4, v29
		v_lshrrev_b32_e32 v31, 3, v9
		v_and_b32_e32 v31, 1, v31
		v_lshlrev_b32_e32 v31, 3, v31
		v_add3_u32 v20, v20, v29, v31
		v_lshrrev_b32_e32 v29, 2, v9
		v_and_b32_e32 v29, 1, v29
		v_lshlrev_b32_e32 v29, 2, v29
		v_lshrrev_b32_e32 v31, 1, v9
		v_and_b32_e32 v31, 1, v31
		v_lshlrev_b32_e32 v31, 1, v31
		v_add3_u32 v20, v20, v29, v31
		v_lshlrev_b32_e32 v20, 2, v20
		ds_bpermute_b32 v29, v20, v15
		v_lshrrev_b32_e32 v31, 4, v9
		v_and_b32_e32 v31, 1, v31
		v_lshlrev_b32_e32 v31, 4, v31
		v_lshrrev_b32_e32 v48, 3, v9
		v_and_b32_e32 v48, 1, v48
		v_lshlrev_b32_e32 v48, 3, v48
		v_lshrrev_b32_e32 v49, 2, v9
		v_and_b32_e32 v49, 1, v49
		v_lshlrev_b32_e32 v49, 2, v49
		v_and_b32_e32 v56, 1, v9
		v_add_u32_e32 v56, 32, v56
		v_lshrrev_b32_e32 v58, 1, v9
		v_and_b32_e32 v58, 1, v58
		v_lshlrev_b32_e32 v58, 1, v58
		v_bitop3_b32 v49, v49, v56, v58 bitop3:0x96
		v_bitop3_b32 v31, v31, v48, v49 bitop3:0x96
		v_lshlrev_b32_e32 v31, 2, v31
		ds_bpermute_b32 v48, v31, v15
		v_max_f32_e32 v15, v18, v19
		v_max_f32_e32 v49, v224, v225
		v_max_f32_e32 v56, v24, v25
		v_max_f32_e32 v58, v228, v229
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v116, v29, v48
		v_max_f32_e32 v29, v22, v23
		v_max_f32_e32 v48, v26, v27
		v_max_f32_e32 v65, v68, v69
		v_max_f32_e32 v117, v230, v231
		v_max_f32_e32 v118, v70, v71
		v_max_f32_e32 v119, v232, v233
		v_max_f32_e32 v132, v66, v67
		v_max_f32_e32 v133, v234, v235
		v_max_f32_e32 v134, v156, v157
		v_max_f32_e32 v135, v190, v191
		v_max_f32_e32 v158, v236, v237
		v_max_f32_e32 v159, v238, v239
		v_max_f32_e32 v180, v176, v177
		v_max_f32_e32 v181, v192, v193
		v_max_f32_e32 v182, v178, v179
		v_max_f32_e32 v183, v194, v195
		v_max_f32_e32 v184, v196, v197
		v_max_f32_e32 v185, v198, v199
		v_max_f32_e32 v186, v200, v201
		v_max_f32_e32 v187, v202, v203
		v_max_f32_e32 v188, v204, v205
		v_max_f32_e32 v189, v206, v207
		v_max_f32_e32 v220, v208, v209
		v_max_f32_e32 v221, v210, v211
		v_max_f32_e32 v222, v212, v213
		v_max_f32_e32 v223, v214, v215
		v_max_f32_e32 v240, v216, v217
		v_max_f32_e32 v241, v218, v219
		v_max_f32_e32 v15, v15, v49
		v_max_f32_e32 v49, v56, v58
		v_max_f32_e32 v29, v29, v48
		v_max_f32_e32 v48, v65, v117
		v_max_f32_e32 v56, v118, v119
		v_max_f32_e32 v58, v132, v133
		v_max_f32_e32 v65, v134, v135
		v_max_f32_e32 v117, v158, v159
		v_max_f32_e32 v118, v180, v181
		v_max_f32_e32 v119, v182, v183
		v_max_f32_e32 v132, v184, v185
		v_max_f32_e32 v133, v186, v187
		v_max_f32_e32 v134, v188, v189
		v_max_f32_e32 v135, v220, v221
		v_max_f32_e32 v158, v222, v223
		v_max_f32_e32 v159, v240, v241
		v_max_f32_e32 v15, v15, v49
		v_max_f32_e32 v29, v29, v48
		v_max_f32_e32 v48, v56, v58
		v_max_f32_e32 v49, v65, v117
		v_max_f32_e32 v56, v118, v119
		v_max_f32_e32 v58, v132, v133
		v_max_f32_e32 v65, v134, v135
		v_max_f32_e32 v117, v158, v159
		v_max_f32_e32 v15, v15, v29
		v_max_f32_e32 v29, v48, v49
		v_max_f32_e32 v48, v56, v58
		v_max_f32_e32 v49, v65, v117
		v_max_f32_e32 v15, v15, v29
		v_max_f32_e32 v29, v48, v49
		v_max_f32_e32 v15, v15, v29
		ds_bpermute_b32 v29, v20, v15
		ds_bpermute_b32 v48, v31, v15
		v_mov_b32_e32 v118, 0x3e38aa3b
		v_mov_b32_e32 v119, 0x3e38aa3b
		v_pk_mul_f32 v[132:133], v[52:53], v[118:119]
		v_pk_mul_f32 v[52:53], v[50:51], v[118:119]
		v_pk_mul_f32 v[50:51], v[60:61], v[118:119]
		v_pk_mul_f32 v[60:61], v[54:55], v[118:119]
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v117, v29, v48
		v_pk_mul_f32 v[48:49], v[116:117], v[118:119]
		v_max_f32_e32 v15, v14, v48
		v_max_f32_e32 v29, v13, v49
		v_pk_mul_f32 v[48:49], v[74:75], v[118:119]
		v_pk_mul_f32 v[54:55], v[62:63], v[118:119]
		v_pk_mul_f32 v[62:63], v[78:79], v[118:119]
		v_pk_mul_f32 v[74:75], v[72:73], v[118:119]
		v_pk_mul_f32 v[72:73], v[120:121], v[118:119]
		v_pk_mul_f32 v[78:79], v[76:77], v[118:119]
		v_pk_mul_f32 v[76:77], v[124:125], v[118:119]
		v_pk_mul_f32 v[116:117], v[112:113], v[118:119]
		v_pk_mul_f32 v[112:113], v[130:131], v[118:119]
		v_pk_mul_f32 v[120:121], v[114:115], v[118:119]
		v_pk_mul_f32 v[114:115], v[142:143], v[118:119]
		v_pk_mul_f32 v[124:125], v[122:123], v[118:119]
		v_pk_mul_f32 v[122:123], v[164:165], v[118:119]
		v_pk_mul_f32 v[130:131], v[126:127], v[118:119]
		v_pk_mul_f32 v[126:127], v[170:171], v[118:119]
		v_pk_mul_f32 v[134:135], v[128:129], v[118:119]
		v_pk_mul_f32 v[128:129], v[226:227], v[118:119]
		v_pk_mul_f32 v[142:143], v[136:137], v[118:119]
		v_pk_mul_f32 v[136:137], v[138:139], v[118:119]
		v_pk_mul_f32 v[138:139], v[140:141], v[118:119]
		v_pk_mul_f32 v[140:141], v[144:145], v[118:119]
		v_pk_mul_f32 v[144:145], v[146:147], v[118:119]
		v_pk_mul_f32 v[146:147], v[160:161], v[118:119]
		v_pk_mul_f32 v[158:159], v[162:163], v[118:119]
		v_pk_mul_f32 v[160:161], v[166:167], v[118:119]
		v_pk_mul_f32 v[162:163], v[168:169], v[118:119]
		v_pk_mul_f32 v[164:165], v[172:173], v[118:119]
		v_pk_mul_f32 v[166:167], v[174:175], v[118:119]
		v_pk_mul_f32 v[168:169], v[18:19], v[118:119]
		v_pk_mul_f32 v[18:19], v[224:225], v[118:119]
		v_pk_mul_f32 v[170:171], v[24:25], v[118:119]
		v_pk_mul_f32 v[24:25], v[228:229], v[118:119]
		v_pk_mul_f32 v[172:173], v[22:23], v[118:119]
		v_pk_mul_f32 v[22:23], v[26:27], v[118:119]
		v_pk_mul_f32 v[26:27], v[68:69], v[118:119]
		v_pk_mul_f32 v[68:69], v[230:231], v[118:119]
		v_pk_mul_f32 v[174:175], v[70:71], v[118:119]
		v_pk_mul_f32 v[70:71], v[232:233], v[118:119]
		v_pk_mul_f32 v[180:181], v[66:67], v[118:119]
		v_pk_mul_f32 v[66:67], v[234:235], v[118:119]
		v_pk_mul_f32 v[182:183], v[156:157], v[118:119]
		v_pk_mul_f32 v[156:157], v[190:191], v[118:119]
		v_pk_mul_f32 v[184:185], v[236:237], v[118:119]
		v_pk_mul_f32 v[186:187], v[238:239], v[118:119]
		v_pk_mul_f32 v[188:189], v[176:177], v[118:119]
		v_pk_mul_f32 v[176:177], v[192:193], v[118:119]
		v_pk_mul_f32 v[190:191], v[178:179], v[118:119]
		v_pk_mul_f32 v[178:179], v[194:195], v[118:119]
		v_pk_mul_f32 v[192:193], v[196:197], v[118:119]
		v_pk_mul_f32 v[194:195], v[198:199], v[118:119]
		v_pk_mul_f32 v[196:197], v[200:201], v[118:119]
		v_pk_mul_f32 v[198:199], v[202:203], v[118:119]
		v_pk_mul_f32 v[200:201], v[204:205], v[118:119]
		v_pk_mul_f32 v[202:203], v[206:207], v[118:119]
		v_pk_mul_f32 v[204:205], v[208:209], v[118:119]
		v_pk_mul_f32 v[206:207], v[210:211], v[118:119]
		v_pk_mul_f32 v[208:209], v[212:213], v[118:119]
		v_pk_mul_f32 v[210:211], v[214:215], v[118:119]
		v_pk_mul_f32 v[212:213], v[216:217], v[118:119]
		v_pk_mul_f32 v[214:215], v[218:219], v[118:119]
		v_sub_f32_e32 v56, v132, v15
		v_sub_f32_e32 v58, v133, v15
		v_sub_f32_e32 v52, v52, v15
		v_sub_f32_e32 v53, v53, v15
		v_sub_f32_e32 v50, v50, v15
		v_sub_f32_e32 v51, v51, v15
		v_sub_f32_e32 v60, v60, v15
		v_sub_f32_e32 v61, v61, v15
		v_sub_f32_e32 v48, v48, v15
		v_sub_f32_e32 v49, v49, v15
		v_sub_f32_e32 v54, v54, v15
		v_sub_f32_e32 v55, v55, v15
		v_sub_f32_e32 v62, v62, v15
		v_sub_f32_e32 v63, v63, v15
		v_sub_f32_e32 v65, v74, v15
		v_sub_f32_e32 v74, v75, v15
		v_sub_f32_e32 v72, v72, v15
		v_sub_f32_e32 v73, v73, v15
		v_sub_f32_e32 v75, v78, v15
		v_sub_f32_e32 v78, v79, v15
		v_sub_f32_e32 v76, v76, v15
		v_sub_f32_e32 v77, v77, v15
		v_sub_f32_e32 v79, v116, v15
		v_sub_f32_e32 v116, v117, v15
		v_sub_f32_e32 v112, v112, v15
		v_sub_f32_e32 v113, v113, v15
		v_sub_f32_e32 v117, v120, v15
		v_sub_f32_e32 v118, v121, v15
		v_sub_f32_e32 v114, v114, v15
		v_sub_f32_e32 v115, v115, v15
		v_sub_f32_e32 v119, v124, v15
		v_sub_f32_e32 v120, v125, v15
		v_sub_f32_e32 v121, v122, v15
		v_sub_f32_e32 v122, v123, v15
		v_sub_f32_e32 v123, v130, v15
		v_sub_f32_e32 v124, v131, v15
		v_sub_f32_e32 v125, v126, v15
		v_sub_f32_e32 v126, v127, v15
		v_sub_f32_e32 v127, v134, v15
		v_sub_f32_e32 v130, v135, v15
		v_sub_f32_e32 v128, v128, v15
		v_sub_f32_e32 v129, v129, v15
		v_sub_f32_e32 v131, v142, v15
		v_sub_f32_e32 v132, v143, v15
		v_sub_f32_e32 v133, v136, v15
		v_sub_f32_e32 v134, v137, v15
		v_sub_f32_e32 v135, v138, v15
		v_sub_f32_e32 v136, v139, v15
		v_sub_f32_e32 v137, v140, v15
		v_sub_f32_e32 v138, v141, v15
		v_sub_f32_e32 v139, v144, v15
		v_sub_f32_e32 v140, v145, v15
		v_sub_f32_e32 v141, v146, v15
		v_sub_f32_e32 v142, v147, v15
		v_sub_f32_e32 v143, v158, v15
		v_sub_f32_e32 v144, v159, v15
		v_sub_f32_e32 v145, v160, v15
		v_sub_f32_e32 v146, v161, v15
		v_sub_f32_e32 v147, v162, v15
		v_sub_f32_e32 v158, v163, v15
		v_sub_f32_e32 v159, v164, v15
		v_sub_f32_e32 v160, v165, v15
		v_sub_f32_e32 v161, v166, v15
		v_sub_f32_e32 v162, v167, v15
		v_sub_f32_e32 v163, v168, v29
		v_sub_f32_e32 v164, v169, v29
		v_sub_f32_e32 v18, v18, v29
		v_sub_f32_e32 v19, v19, v29
		v_sub_f32_e32 v165, v170, v29
		v_sub_f32_e32 v166, v171, v29
		v_sub_f32_e32 v24, v24, v29
		v_sub_f32_e32 v25, v25, v29
		v_sub_f32_e32 v167, v172, v29
		v_sub_f32_e32 v168, v173, v29
		v_sub_f32_e32 v22, v22, v29
		v_sub_f32_e32 v23, v23, v29
		v_sub_f32_e32 v26, v26, v29
		v_sub_f32_e32 v27, v27, v29
		v_sub_f32_e32 v68, v68, v29
		v_sub_f32_e32 v69, v69, v29
		v_sub_f32_e32 v169, v174, v29
		v_sub_f32_e32 v170, v175, v29
		v_sub_f32_e32 v70, v70, v29
		v_sub_f32_e32 v71, v71, v29
		v_sub_f32_e32 v171, v180, v29
		v_sub_f32_e32 v172, v181, v29
		v_sub_f32_e32 v66, v66, v29
		v_sub_f32_e32 v67, v67, v29
		v_sub_f32_e32 v173, v182, v29
		v_sub_f32_e32 v174, v183, v29
		v_sub_f32_e32 v156, v156, v29
		v_sub_f32_e32 v157, v157, v29
		v_sub_f32_e32 v175, v184, v29
		v_sub_f32_e32 v180, v185, v29
		v_sub_f32_e32 v181, v186, v29
		v_sub_f32_e32 v182, v187, v29
		v_sub_f32_e32 v183, v188, v29
		v_sub_f32_e32 v184, v189, v29
		v_sub_f32_e32 v176, v176, v29
		v_sub_f32_e32 v177, v177, v29
		v_sub_f32_e32 v185, v190, v29
		v_sub_f32_e32 v186, v191, v29
		v_sub_f32_e32 v178, v178, v29
		v_sub_f32_e32 v179, v179, v29
		v_sub_f32_e32 v187, v192, v29
		v_sub_f32_e32 v188, v193, v29
		v_sub_f32_e32 v189, v194, v29
		v_sub_f32_e32 v190, v195, v29
		v_sub_f32_e32 v191, v196, v29
		v_sub_f32_e32 v192, v197, v29
		v_sub_f32_e32 v193, v198, v29
		v_sub_f32_e32 v194, v199, v29
		v_sub_f32_e32 v195, v200, v29
		v_sub_f32_e32 v196, v201, v29
		v_sub_f32_e32 v197, v202, v29
		v_sub_f32_e32 v198, v203, v29
		v_sub_f32_e32 v199, v204, v29
		v_sub_f32_e32 v200, v205, v29
		v_sub_f32_e32 v201, v206, v29
		v_sub_f32_e32 v202, v207, v29
		v_sub_f32_e32 v203, v208, v29
		v_sub_f32_e32 v204, v209, v29
		v_sub_f32_e32 v205, v210, v29
		v_sub_f32_e32 v206, v211, v29
		v_sub_f32_e32 v207, v212, v29
		v_sub_f32_e32 v208, v213, v29
		v_sub_f32_e32 v209, v214, v29
		v_sub_f32_e32 v210, v215, v29
		v_exp_f32_e32 v212, v56
		v_exp_f32_e32 v214, v58
		v_exp_f32_e32 v213, v52
		v_exp_f32_e32 v215, v53
		v_exp_f32_e32 v52, v50
		v_exp_f32_e32 v216, v51
		v_exp_f32_e32 v53, v60
		v_exp_f32_e32 v217, v61
		v_exp_f32_e32 v50, v48
		v_exp_f32_e32 v60, v49
		v_exp_f32_e32 v51, v54
		v_exp_f32_e32 v61, v55
		v_exp_f32_e32 v48, v62
		v_exp_f32_e32 v54, v63
		v_exp_f32_e32 v49, v65
		v_exp_f32_e32 v55, v74
		v_exp_f32_e32 v62, v72
		v_exp_f32_e32 v218, v73
		v_exp_f32_e32 v63, v75
		v_exp_f32_e32 v219, v78
		v_exp_f32_e32 v72, v76
		v_exp_f32_e32 v74, v77
		v_exp_f32_e32 v73, v79
		v_exp_f32_e32 v75, v116
		v_exp_f32_e32 v76, v112
		v_exp_f32_e32 v78, v113
		v_exp_f32_e32 v77, v117
		v_exp_f32_e32 v79, v118
		v_exp_f32_e32 v112, v114
		v_exp_f32_e32 v116, v115
		v_exp_f32_e32 v113, v119
		v_exp_f32_e32 v117, v120
		v_exp_f32_e32 v114, v121
		v_exp_f32_e32 v118, v122
		v_exp_f32_e32 v115, v123
		v_exp_f32_e32 v119, v124
		v_exp_f32_e32 v120, v125
		v_exp_f32_e32 v122, v126
		v_exp_f32_e32 v121, v127
		v_exp_f32_e32 v123, v130
		v_exp_f32_e32 v124, v128
		v_exp_f32_e32 v126, v129
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
		v_exp_f32_e32 v139, v144
		v_exp_f32_e32 v140, v145
		v_exp_f32_e32 v142, v146
		v_exp_f32_e32 v141, v147
		v_exp_f32_e32 v143, v158
		v_exp_f32_e32 v144, v159
		v_exp_f32_e32 v146, v160
		v_exp_f32_e32 v145, v161
		v_exp_f32_e32 v147, v162
		v_exp_f32_e32 v159, v163
		v_exp_f32_e32 v161, v164
		v_exp_f32_e32 v162, v18
		v_exp_f32_e32 v220, v19
		v_exp_f32_e32 v163, v165
		v_exp_f32_e32 v221, v166
		v_exp_f32_e32 v18, v24
		v_exp_f32_e32 v164, v25
		v_exp_f32_e32 v19, v167
		v_exp_f32_e32 v165, v168
		v_exp_f32_e32 v24, v22
		v_exp_f32_e32 v166, v23
		v_exp_f32_e32 v25, v26
		v_exp_f32_e32 v167, v27
		v_exp_f32_e32 v22, v68
		v_exp_f32_e32 v26, v69
		v_exp_f32_e32 v23, v169
		v_exp_f32_e32 v27, v170
		v_exp_f32_e32 v68, v70
		v_exp_f32_e32 v168, v71
		v_exp_f32_e32 v69, v171
		v_exp_f32_e32 v169, v172
		v_exp_f32_e32 v70, v66
		v_exp_f32_e32 v170, v67
		v_exp_f32_e32 v71, v173
		v_exp_f32_e32 v171, v174
		v_exp_f32_e32 v66, v156
		v_exp_f32_e32 v172, v157
		v_exp_f32_e32 v67, v175
		v_exp_f32_e32 v173, v180
		v_exp_f32_e32 v156, v181
		v_exp_f32_e32 v174, v182
		v_exp_f32_e32 v157, v183
		v_exp_f32_e32 v175, v184
		v_exp_f32_e32 v180, v176
		v_exp_f32_e32 v182, v177
		v_exp_f32_e32 v181, v185
		v_exp_f32_e32 v183, v186
		v_exp_f32_e32 v176, v178
		v_exp_f32_e32 v184, v179
		v_exp_f32_e32 v177, v187
		v_exp_f32_e32 v185, v188
		v_exp_f32_e32 v178, v189
		v_exp_f32_e32 v186, v190
		v_exp_f32_e32 v179, v191
		v_exp_f32_e32 v187, v192
		v_exp_f32_e32 v188, v193
		v_exp_f32_e32 v190, v194
		v_exp_f32_e32 v189, v195
		v_exp_f32_e32 v191, v196
		v_exp_f32_e32 v192, v197
		v_exp_f32_e32 v194, v198
		v_exp_f32_e32 v193, v199
		v_exp_f32_e32 v195, v200
		v_exp_f32_e32 v196, v201
		v_exp_f32_e32 v198, v202
		v_exp_f32_e32 v197, v203
		v_exp_f32_e32 v199, v204
		v_exp_f32_e32 v200, v205
		v_exp_f32_e32 v202, v206
		v_exp_f32_e32 v201, v207
		v_exp_f32_e32 v203, v208
		v_exp_f32_e32 v204, v209
		v_exp_f32_e32 v206, v210
		v_pk_add_f32 v[208:209], v[212:213], v[214:215]
		v_pk_add_f32 v[210:211], v[52:53], v[216:217]
		v_pk_add_f32 v[222:223], v[50:51], v[60:61]
		v_pk_add_f32 v[224:225], v[48:49], v[54:55]
		v_pk_add_f32 v[226:227], v[62:63], v[218:219]
		v_pk_add_f32 v[228:229], v[72:73], v[74:75]
		v_pk_add_f32 v[230:231], v[76:77], v[78:79]
		v_pk_add_f32 v[232:233], v[112:113], v[116:117]
		v_pk_add_f32 v[234:235], v[114:115], v[118:119]
		v_pk_add_f32 v[236:237], v[120:121], v[122:123]
		v_pk_add_f32 v[238:239], v[124:125], v[126:127]
		v_pk_add_f32 v[240:241], v[128:129], v[130:131]
		v_pk_add_f32 v[242:243], v[132:133], v[134:135]
		v_pk_add_f32 v[244:245], v[136:137], v[138:139]
		v_pk_add_f32 v[246:247], v[140:141], v[142:143]
		v_pk_add_f32 v[248:249], v[144:145], v[146:147]
		v_mov_b32_e32 v250, v209
		v_mov_b32_e32 v251, v211
		v_mov_b32_e32 v252, v208
		v_mov_b32_e32 v253, v210
		v_pk_add_f32 v[208:209], v[252:253], v[250:251]
		v_mov_b32_e32 v210, v223
		v_mov_b32_e32 v211, v225
		v_mov_b32_e32 v250, v222
		v_mov_b32_e32 v251, v224
		v_pk_add_f32 v[222:223], v[250:251], v[210:211]
		v_mov_b32_e32 v210, v227
		v_mov_b32_e32 v211, v229
		v_mov_b32_e32 v224, v226
		v_mov_b32_e32 v225, v228
		v_pk_add_f32 v[226:227], v[224:225], v[210:211]
		v_mov_b32_e32 v210, v231
		v_mov_b32_e32 v211, v233
		v_mov_b32_e32 v224, v230
		v_mov_b32_e32 v225, v232
		v_pk_add_f32 v[228:229], v[224:225], v[210:211]
		v_mov_b32_e32 v210, v235
		v_mov_b32_e32 v211, v237
		v_mov_b32_e32 v224, v234
		v_mov_b32_e32 v225, v236
		v_pk_add_f32 v[230:231], v[224:225], v[210:211]
		v_mov_b32_e32 v210, v239
		v_mov_b32_e32 v211, v241
		v_mov_b32_e32 v224, v238
		v_mov_b32_e32 v225, v240
		v_pk_add_f32 v[232:233], v[224:225], v[210:211]
		v_mov_b32_e32 v210, v243
		v_mov_b32_e32 v211, v245
		v_mov_b32_e32 v224, v242
		v_mov_b32_e32 v225, v244
		v_pk_add_f32 v[234:235], v[224:225], v[210:211]
		v_mov_b32_e32 v210, v247
		v_mov_b32_e32 v211, v249
		v_mov_b32_e32 v224, v246
		v_mov_b32_e32 v225, v248
		v_pk_add_f32 v[236:237], v[224:225], v[210:211]
		v_mov_b32_e32 v210, v209
		v_mov_b32_e32 v211, v223
		v_mov_b32_e32 v224, v208
		v_mov_b32_e32 v225, v222
		v_pk_add_f32 v[208:209], v[224:225], v[210:211]
		v_mov_b32_e32 v210, v227
		v_mov_b32_e32 v211, v229
		v_mov_b32_e32 v222, v226
		v_mov_b32_e32 v223, v228
		v_pk_add_f32 v[224:225], v[222:223], v[210:211]
		v_mov_b32_e32 v210, v231
		v_mov_b32_e32 v211, v233
		v_mov_b32_e32 v222, v230
		v_mov_b32_e32 v223, v232
		v_pk_add_f32 v[226:227], v[222:223], v[210:211]
		v_mov_b32_e32 v210, v235
		v_mov_b32_e32 v211, v237
		v_mov_b32_e32 v222, v234
		v_mov_b32_e32 v223, v236
		v_pk_add_f32 v[228:229], v[222:223], v[210:211]
		v_mov_b32_e32 v210, v209
		v_mov_b32_e32 v211, v225
		v_mov_b32_e32 v222, v208
		v_mov_b32_e32 v223, v224
		v_pk_add_f32 v[208:209], v[222:223], v[210:211]
		v_mov_b32_e32 v210, v227
		v_mov_b32_e32 v211, v229
		v_mov_b32_e32 v222, v226
		v_mov_b32_e32 v223, v228
		v_pk_add_f32 v[224:225], v[222:223], v[210:211]
		v_mov_b32_e32 v210, v209
		v_mov_b32_e32 v211, v225
		v_mov_b32_e32 v222, v208
		v_mov_b32_e32 v223, v224
		v_pk_add_f32 v[208:209], v[222:223], v[210:211]
		v_add_f32_e32 v56, v208, v209
		ds_bpermute_b32 v158, v20, v56
		ds_bpermute_b32 v160, v31, v56
		v_pk_add_f32 v[208:209], v[162:163], v[220:221]
		v_pk_add_f32 v[210:211], v[18:19], v[164:165]
		v_pk_add_f32 v[222:223], v[24:25], v[166:167]
		v_pk_add_f32 v[224:225], v[22:23], v[26:27]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[226:227], v[158:159], v[160:161]
		v_pk_add_f32 v[228:229], v[68:69], v[168:169]
		v_pk_add_f32 v[230:231], v[70:71], v[170:171]
		v_pk_add_f32 v[232:233], v[66:67], v[172:173]
		v_pk_add_f32 v[234:235], v[156:157], v[174:175]
		v_pk_add_f32 v[236:237], v[180:181], v[182:183]
		v_pk_add_f32 v[238:239], v[176:177], v[184:185]
		v_pk_add_f32 v[240:241], v[178:179], v[186:187]
		v_pk_add_f32 v[242:243], v[188:189], v[190:191]
		v_pk_add_f32 v[244:245], v[192:193], v[194:195]
		v_pk_add_f32 v[246:247], v[196:197], v[198:199]
		v_pk_add_f32 v[248:249], v[200:201], v[202:203]
		v_mov_b32_e32 v205, v227
		v_mov_b32_e32 v207, v208
		v_pk_add_f32 v[250:251], v[204:205], v[206:207]
		v_mov_b32_e32 v252, v209
		v_mov_b32_e32 v253, v222
		v_pk_add_f32 v[208:209], v[252:253], v[210:211]
		v_mov_b32_e32 v210, v223
		v_mov_b32_e32 v211, v228
		v_pk_add_f32 v[210:211], v[210:211], v[224:225]
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
		v_mov_b32_e32 v233, v208
		v_pk_add_f32 v[232:233], v[232:233], v[250:251]
		v_mov_b32_e32 v236, v209
		v_mov_b32_e32 v237, v224
		v_pk_add_f32 v[208:209], v[236:237], v[210:211]
		v_mov_b32_e32 v210, v225
		v_mov_b32_e32 v211, v230
		v_pk_add_f32 v[210:211], v[210:211], v[222:223]
		v_mov_b32_e32 v222, v231
		v_mov_b32_e32 v223, v234
		v_pk_add_f32 v[224:225], v[222:223], v[228:229]
		v_mov_b32_e32 v222, v235
		v_mov_b32_e32 v223, v208
		v_pk_add_f32 v[222:223], v[222:223], v[232:233]
		v_mov_b32_e32 v228, v209
		v_mov_b32_e32 v229, v224
		v_pk_add_f32 v[208:209], v[228:229], v[210:211]
		v_mov_b32_e32 v210, v225
		v_mov_b32_e32 v211, v208
		v_pk_add_f32 v[224:225], v[210:211], v[222:223]
		v_add_f32_e32 v56, v209, v224
		v_add_f32_e32 v56, v225, v56
		ds_bpermute_b32 v58, v20, v56
		ds_bpermute_b32 v20, v31, v56
		v_sub_f32_e32 v14, v14, v15
		v_sub_f32_e32 v13, v13, v29
		v_exp_f32_e32 v208, v14
		v_exp_f32_e32 v210, v13
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v223, v58, v20
		v_mov_b32_e32 v209, v208
		v_pk_mul_f32 v[32:33], v[32:33], v[208:209]
		v_pk_mul_f32 v[34:35], v[34:35], v[208:209]
		v_pk_mul_f32 v[36:37], v[36:37], v[208:209]
		v_pk_mul_f32 v[38:39], v[38:39], v[208:209]
		v_pk_mul_f32 v[40:41], v[40:41], v[208:209]
		v_pk_mul_f32 v[42:43], v[42:43], v[208:209]
		v_pk_mul_f32 v[44:45], v[44:45], v[208:209]
		v_pk_mul_f32 v[46:47], v[46:47], v[208:209]
		v_pk_mul_f32 v[80:81], v[80:81], v[208:209]
		v_pk_mul_f32 v[82:83], v[82:83], v[208:209]
		v_pk_mul_f32 v[84:85], v[84:85], v[208:209]
		v_pk_mul_f32 v[86:87], v[86:87], v[208:209]
		v_pk_mul_f32 v[88:89], v[88:89], v[208:209]
		v_pk_mul_f32 v[90:91], v[90:91], v[208:209]
		v_pk_mul_f32 v[92:93], v[92:93], v[208:209]
		v_pk_mul_f32 v[94:95], v[94:95], v[208:209]
		v_mov_b32_e32 v211, v210
		v_pk_mul_f32 v[96:97], v[96:97], v[210:211]
		v_pk_mul_f32 v[98:99], v[98:99], v[210:211]
		v_pk_mul_f32 v[100:101], v[100:101], v[210:211]
		v_pk_mul_f32 v[102:103], v[102:103], v[210:211]
		v_pk_mul_f32 v[104:105], v[104:105], v[210:211]
		v_pk_mul_f32 v[106:107], v[106:107], v[210:211]
		v_pk_mul_f32 v[108:109], v[108:109], v[210:211]
		v_pk_mul_f32 v[110:111], v[110:111], v[210:211]
		v_accvgpr_read_b32 v224, a48
		v_accvgpr_read_b32 v225, a49
		v_pk_mul_f32 v[224:225], v[224:225], v[210:211]
		v_accvgpr_write_b32 a48, v224
		v_accvgpr_write_b32 a49, v225
		v_accvgpr_read_b32 v224, a50
		v_accvgpr_read_b32 v225, a51
		v_pk_mul_f32 v[224:225], v[224:225], v[210:211]
		v_accvgpr_write_b32 a50, v224
		v_accvgpr_write_b32 a51, v225
		v_accvgpr_read_b32 v224, a52
		v_accvgpr_read_b32 v225, a53
		v_pk_mul_f32 v[224:225], v[224:225], v[210:211]
		v_accvgpr_write_b32 a52, v224
		v_accvgpr_write_b32 a53, v225
		v_accvgpr_read_b32 v224, a54
		v_accvgpr_read_b32 v225, a55
		v_pk_mul_f32 v[224:225], v[224:225], v[210:211]
		v_accvgpr_write_b32 a54, v224
		v_accvgpr_write_b32 a55, v225
		v_accvgpr_read_b32 v224, a56
		v_accvgpr_read_b32 v225, a57
		v_pk_mul_f32 v[224:225], v[224:225], v[210:211]
		v_accvgpr_write_b32 a56, v224
		v_accvgpr_write_b32 a57, v225
		v_accvgpr_read_b32 v224, a58
		v_accvgpr_read_b32 v225, a59
		v_pk_mul_f32 v[224:225], v[224:225], v[210:211]
		v_accvgpr_write_b32 a58, v224
		v_accvgpr_write_b32 a59, v225
		v_accvgpr_read_b32 v224, a60
		v_accvgpr_read_b32 v225, a61
		v_pk_mul_f32 v[224:225], v[224:225], v[210:211]
		v_accvgpr_write_b32 a60, v224
		v_accvgpr_write_b32 a61, v225
		v_accvgpr_read_b32 v224, a62
		v_accvgpr_read_b32 v225, a63
		v_pk_mul_f32 v[224:225], v[224:225], v[210:211]
		v_accvgpr_write_b32 a62, v224
		v_accvgpr_write_b32 a63, v225
		v_mov_b32_e32 v222, v226
		v_mov_b32_e32 v224, v208
		v_mov_b32_e32 v225, v210
		v_mov_b64_e32 v[208:209], v[16:17]
		v_pk_fma_f32 v[16:17], v[208:209], v[224:225], v[222:223]
		v_cvt_pk_bf16_f32 v208, v212, v214
		v_cvt_pk_bf16_f32 v209, v213, v215
		v_cvt_pk_bf16_f32 v210, v52, v216
		v_cvt_pk_bf16_f32 v211, v53, v217
		v_cvt_pk_bf16_f32 v212, v50, v60
		v_cvt_pk_bf16_f32 v213, v51, v61
		v_cvt_pk_bf16_f32 v214, v48, v54
		v_cvt_pk_bf16_f32 v215, v49, v55
		v_cvt_pk_bf16_f32 v48, v62, v218
		v_cvt_pk_bf16_f32 v49, v63, v219
		v_cvt_pk_bf16_f32 v50, v72, v74
		v_cvt_pk_bf16_f32 v51, v73, v75
		v_cvt_pk_bf16_f32 v52, v76, v78
		v_cvt_pk_bf16_f32 v53, v77, v79
		v_cvt_pk_bf16_f32 v54, v112, v116
		v_cvt_pk_bf16_f32 v55, v113, v117
		v_cvt_pk_bf16_f32 v60, v114, v118
		v_cvt_pk_bf16_f32 v61, v115, v119
		v_cvt_pk_bf16_f32 v62, v120, v122
		v_cvt_pk_bf16_f32 v63, v121, v123
		v_cvt_pk_bf16_f32 v72, v124, v126
		v_cvt_pk_bf16_f32 v73, v125, v127
		v_cvt_pk_bf16_f32 v74, v128, v130
		v_cvt_pk_bf16_f32 v75, v129, v131
		v_cvt_pk_bf16_f32 v76, v132, v134
		v_cvt_pk_bf16_f32 v77, v133, v135
		v_cvt_pk_bf16_f32 v78, v136, v138
		v_cvt_pk_bf16_f32 v79, v137, v139
		v_cvt_pk_bf16_f32 v112, v140, v142
		v_cvt_pk_bf16_f32 v113, v141, v143
		v_cvt_pk_bf16_f32 v114, v144, v146
		v_cvt_pk_bf16_f32 v115, v145, v147
		v_cvt_pk_bf16_f32 v116, v159, v161
		v_cvt_pk_bf16_f32 v117, v162, v220
		v_cvt_pk_bf16_f32 v118, v163, v221
		v_cvt_pk_bf16_f32 v119, v18, v164
		v_cvt_pk_bf16_f32 v120, v19, v165
		v_cvt_pk_bf16_f32 v121, v24, v166
		v_cvt_pk_bf16_f32 v122, v25, v167
		v_cvt_pk_bf16_f32 v123, v22, v26
		v_cvt_pk_bf16_f32 v124, v23, v27
		v_cvt_pk_bf16_f32 v125, v68, v168
		v_cvt_pk_bf16_f32 v126, v69, v169
		v_cvt_pk_bf16_f32 v127, v70, v170
		v_cvt_pk_bf16_f32 v24, v71, v171
		v_cvt_pk_bf16_f32 v25, v66, v172
		v_cvt_pk_bf16_f32 v26, v67, v173
		v_cvt_pk_bf16_f32 v27, v156, v174
		v_cvt_pk_bf16_f32 v68, v157, v175
		v_cvt_pk_bf16_f32 v69, v180, v182
		v_cvt_pk_bf16_f32 v70, v181, v183
		v_cvt_pk_bf16_f32 v71, v176, v184
		v_cvt_pk_bf16_f32 v128, v177, v185
		v_cvt_pk_bf16_f32 v129, v178, v186
		v_cvt_pk_bf16_f32 v130, v179, v187
		v_cvt_pk_bf16_f32 v131, v188, v190
		v_cvt_pk_bf16_f32 v132, v189, v191
		v_cvt_pk_bf16_f32 v133, v192, v194
		v_cvt_pk_bf16_f32 v134, v193, v195
		v_cvt_pk_bf16_f32 v135, v196, v198
		v_cvt_pk_bf16_f32 v136, v197, v199
		v_cvt_pk_bf16_f32 v137, v200, v202
		v_cvt_pk_bf16_f32 v138, v201, v203
		v_cvt_pk_bf16_f32 v139, v204, v206
		v_permlane32_swap_b32_e32 v208, v210
		v_permlane32_swap_b32_e32 v209, v211
		v_permlane32_swap_b32_e32 v212, v214
		v_permlane32_swap_b32_e32 v213, v215
		v_permlane32_swap_b32_e32 v48, v50
		v_permlane32_swap_b32_e32 v49, v51
		v_mfma_f32_32x32x16_bf16 v[32:47], v[148:151], v[208:211], v[32:47]
		v_permlane32_swap_b32_e32 v52, v54
		v_permlane32_swap_b32_e32 v53, v55
		v_permlane32_swap_b32_e32 v60, v62
		v_permlane32_swap_b32_e32 v61, v63
		v_permlane32_swap_b32_e32 v72, v74
		v_permlane32_swap_b32_e32 v73, v75
		v_permlane32_swap_b32_e32 v76, v78
		v_permlane32_swap_b32_e32 v77, v79
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_mfma_f32_32x32x16_bf16 v[80:95], v[152:155], v[208:211], v[80:95]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_permlane32_swap_b32_e32 v68, v70
		v_permlane32_swap_b32_e32 v69, v71
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 a[48:63], v[152:155], v[116:119], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[96:111], v[148:151], v[116:119], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[4:7], v[212:215], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[80:83], v[212:215], v[80:95]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[80:83], v[120:123], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[4:7], v[120:123], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[40:43], v[48:51], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[84:87], v[48:51], v[80:95]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[84:87], v[124:127], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[40:43], v[124:127], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[44:47], v[52:55], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[88:91], v[52:55], v[80:95]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[88:91], v[24:27], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[44:47], v[24:27], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[64:67], v[60:63], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[92:95], v[60:63], v[80:95]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[92:95], v[68:71], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[64:67], v[68:71], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[68:71], v[72:75], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[96:99], v[72:75], v[80:95]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[96:99], v[128:131], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[68:71], v[128:131], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[72:75], v[76:79], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[100:103], v[76:79], v[80:95]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[100:103], v[132:135], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[72:75], v[132:135], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[76:79], v[112:115], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[104:107], v[112:115], v[80:95]
		v_mfma_f32_32x32x16_bf16 a[48:63], a[104:107], v[136:139], a[48:63]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[76:79], v[136:139], v[96:111]
		s_mov_b32 s38, s27
		v_mov_b32_e32 v14, v15
		v_mov_b32_e32 v13, v29
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_4
.L_attn_fwd_persistent.loop_exit_4:
		v_rcp_f32_e32 v14, v16
		v_rcp_f32_e32 v18, v17
		v_mov_b32_e32 v15, v14
		s_nop 1
		v_pk_mul_f32 v[16:17], v[32:33], v[14:15]
		v_pk_mul_f32 v[22:23], v[34:35], v[14:15]
		v_pk_mul_f32 v[24:25], v[36:37], v[14:15]
		v_pk_mul_f32 v[26:27], v[38:39], v[14:15]
		v_pk_mul_f32 v[32:33], v[40:41], v[14:15]
		v_pk_mul_f32 v[34:35], v[42:43], v[14:15]
		v_pk_mul_f32 v[36:37], v[44:45], v[14:15]
		v_pk_mul_f32 v[38:39], v[46:47], v[14:15]
		v_pk_mul_f32 v[40:41], v[80:81], v[14:15]
		v_pk_mul_f32 v[42:43], v[82:83], v[14:15]
		v_pk_mul_f32 v[44:45], v[84:85], v[14:15]
		v_pk_mul_f32 v[46:47], v[86:87], v[14:15]
		v_pk_mul_f32 v[48:49], v[88:89], v[14:15]
		v_pk_mul_f32 v[50:51], v[90:91], v[14:15]
		v_pk_mul_f32 v[52:53], v[92:93], v[14:15]
		v_pk_mul_f32 v[54:55], v[94:95], v[14:15]
		v_mov_b32_e32 v19, v18
		v_pk_mul_f32 v[14:15], v[96:97], v[18:19]
		v_pk_mul_f32 v[60:61], v[98:99], v[18:19]
		v_pk_mul_f32 v[62:63], v[100:101], v[18:19]
		v_pk_mul_f32 v[66:67], v[102:103], v[18:19]
		v_pk_mul_f32 v[68:69], v[104:105], v[18:19]
		v_pk_mul_f32 v[70:71], v[106:107], v[18:19]
		v_pk_mul_f32 v[72:73], v[108:109], v[18:19]
		v_pk_mul_f32 v[74:75], v[110:111], v[18:19]
		v_accvgpr_read_b32 v76, a48
		v_accvgpr_read_b32 v77, a49
		v_pk_mul_f32 v[78:79], v[76:77], v[18:19]
		v_accvgpr_read_b32 v76, a50
		v_accvgpr_read_b32 v77, a51
		v_pk_mul_f32 v[80:81], v[76:77], v[18:19]
		v_accvgpr_read_b32 v76, a52
		v_accvgpr_read_b32 v77, a53
		v_pk_mul_f32 v[82:83], v[76:77], v[18:19]
		v_accvgpr_read_b32 v76, a54
		v_accvgpr_read_b32 v77, a55
		v_pk_mul_f32 v[84:85], v[76:77], v[18:19]
		v_accvgpr_read_b32 v76, a56
		v_accvgpr_read_b32 v77, a57
		v_pk_mul_f32 v[86:87], v[76:77], v[18:19]
		v_accvgpr_read_b32 v76, a58
		v_accvgpr_read_b32 v77, a59
		v_pk_mul_f32 v[88:89], v[76:77], v[18:19]
		v_accvgpr_read_b32 v76, a60
		v_accvgpr_read_b32 v77, a61
		v_pk_mul_f32 v[90:91], v[76:77], v[18:19]
		v_accvgpr_read_b32 v76, a62
		v_accvgpr_read_b32 v77, a63
		v_pk_mul_f32 v[92:93], v[76:77], v[18:19]
		v_cvt_pk_bf16_f32 v96, v16, v17
		v_cvt_pk_bf16_f32 v97, v22, v23
		v_cvt_pk_bf16_f32 v98, v24, v25
		v_cvt_pk_bf16_f32 v99, v26, v27
		v_cvt_pk_bf16_f32 v16, v32, v33
		v_cvt_pk_bf16_f32 v17, v34, v35
		v_cvt_pk_bf16_f32 v18, v36, v37
		v_cvt_pk_bf16_f32 v19, v38, v39
		v_cvt_pk_bf16_f32 v24, v40, v41
		v_cvt_pk_bf16_f32 v25, v42, v43
		v_cvt_pk_bf16_f32 v26, v44, v45
		v_cvt_pk_bf16_f32 v27, v46, v47
		v_cvt_pk_bf16_f32 v32, v48, v49
		v_cvt_pk_bf16_f32 v33, v50, v51
		v_cvt_pk_bf16_f32 v34, v52, v53
		v_cvt_pk_bf16_f32 v35, v54, v55
		v_cvt_pk_bf16_f32 v36, v14, v15
		v_cvt_pk_bf16_f32 v37, v60, v61
		v_cvt_pk_bf16_f32 v38, v62, v63
		v_cvt_pk_bf16_f32 v39, v66, v67
		v_cvt_pk_bf16_f32 v40, v68, v69
		v_cvt_pk_bf16_f32 v41, v70, v71
		v_cvt_pk_bf16_f32 v42, v72, v73
		v_cvt_pk_bf16_f32 v43, v74, v75
		v_cvt_pk_bf16_f32 v44, v78, v79
		v_cvt_pk_bf16_f32 v45, v80, v81
		v_cvt_pk_bf16_f32 v46, v82, v83
		v_cvt_pk_bf16_f32 v47, v84, v85
		v_cvt_pk_bf16_f32 v48, v86, v87
		v_cvt_pk_bf16_f32 v49, v88, v89
		v_cvt_pk_bf16_f32 v50, v90, v91
		v_cvt_pk_bf16_f32 v51, v92, v93
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
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
		s_lshl_b32 s1, s46, 9
		s_add_i32 s22, s1, s26
		s_add_i32 s22, s22, s39
		v_add3_u32 v1, s22, v8, v12
		v_add3_u32 v1, v1, v21, v28
		v_add3_u32 v1, v1, v30, v57
		v_add3_u32 v1, v1, v59, v64
		v_cndmask_b32_e64 v1, v11, v1, s[48:49]
		buffer_store_dwordx4 v[96:99], v1, s[40:43], 0 offen
		s_add_i32 s25, s1, 32
		s_add_i32 s25, s25, s26
		s_add_i32 s25, s25, s39
		v_add3_u32 v1, s25, v8, v12
		v_add3_u32 v1, v1, v21, v28
		v_add3_u32 v1, v1, v30, v57
		v_add3_u32 v1, v1, v59, v64
		v_cndmask_b32_e64 v1, v11, v1, s[48:49]
		buffer_store_dwordx4 v[16:19], v1, s[40:43], 0 offen
		s_add_i32 s27, s1, 64
		s_add_i32 s27, s27, s26
		s_add_i32 s27, s27, s39
		v_add3_u32 v1, s27, v8, v12
		v_add3_u32 v1, v1, v21, v28
		v_add3_u32 v1, v1, v30, v57
		v_add3_u32 v1, v1, v59, v64
		v_cndmask_b32_e64 v1, v11, v1, s[48:49]
		buffer_store_dwordx4 v[24:27], v1, s[40:43], 0 offen
		s_add_i32 s1, s1, 0x60
		s_add_i32 s1, s1, s26
		s_add_i32 s1, s1, s39
		v_add3_u32 v1, s1, v8, v12
		v_add3_u32 v1, v1, v21, v28
		v_add3_u32 v1, v1, v30, v57
		v_add3_u32 v1, v1, v59, v64
		v_cndmask_b32_e64 v1, v11, v1, s[48:49]
		buffer_store_dwordx4 v[32:35], v1, s[40:43], 0 offen
		v_add3_u32 v1, s22, v7, v64
		v_cndmask_b32_e64 v1, v11, v1, s[50:51]
		buffer_store_dwordx4 v[36:39], v1, s[40:43], 0 offen
		v_add3_u32 v1, s25, v7, v64
		v_cndmask_b32_e64 v1, v11, v1, s[50:51]
		buffer_store_dwordx4 v[40:43], v1, s[40:43], 0 offen
		v_add3_u32 v1, s27, v7, v64
		v_cndmask_b32_e64 v1, v11, v1, s[50:51]
		buffer_store_dwordx4 v[44:47], v1, s[40:43], 0 offen
		v_add3_u32 v1, s1, v7, v64
		v_cndmask_b32_e64 v1, v11, v1, s[50:51]
		buffer_store_dwordx4 v[48:51], v1, s[40:43], 0 offen
		s_branch .L_attn_fwd_persistent.if_end_0
.L_attn_fwd_persistent.if_else_0:
.L_attn_fwd_persistent.if_end_0:
		s_add_i32 s0, s0, 32
		s_lshl_b32 s1, s17, 2
		s_add_i32 s1, s1, 0x189b0
		v_mov_b32_e32 v1, s1
		s_nop 0
		v_readfirstlane_b32 s1, v1
		s_mov_b32 m0, s1
		s_waitcnt lgkmcnt(0)
		s_nop 0
		ds_read_addtid_b32 v1
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v1
		s_mul_i32 s1, s1, 16
		s_nop 0
		v_mov_b32_e32 v1, s1
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
    wave.regalloc.iterations: 488
    wave.regalloc.agpr.dwords: 1092
    wave.regalloc.remat.dwords: 224
    wave.regalloc.sgpr_to_vgpr.dwords: 93
    wave.regalloc.lds.dwords: 2
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
