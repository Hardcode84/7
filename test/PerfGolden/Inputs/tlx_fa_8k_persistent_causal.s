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
		s_mov_b32 m0, s17
		v_mov_b32_e32 v1, s21
		ds_write_addtid_b32 v1 offset:11264
		s_load_dword s21, s[0:1], 0x50
		s_load_dword s22, s[0:1], 0x54
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v1, s22
		s_load_dword s22, s[0:1], 0x58
		s_load_dword s23, s[0:1], 0x5c
		s_load_dword s24, s[0:1], 0x60
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s17
		v_mov_b32_e32 v2, s24
		ds_write_addtid_b32 v2 offset:4096
		s_and_b32 s0, s16, 7
		v_mov_b32_e32 v3, s0
		s_lshr_b32 s0, s16, 3
		v_readfirstlane_b32 s1, v1
		s_mul_i32 s1, s21, s1
		s_nop 0
		v_mov_b32_e32 v4, s1
		s_nop 0
		v_readfirstlane_b32 s1, v4
		s_add_i32 s1, s1, 7
		s_mov_b32 s16, 1
		s_mov_b32 s21, 7
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s21, s21, 0
		s_add_i32 s1, s1, s21
		s_ashr_i32 s1, s1, 3
		s_mov_b32 m0, s17
		v_mov_b32_e32 v5, s1
		ds_write_addtid_b32 v5 offset:2048
		v_readfirstlane_b32 s1, v5
		s_mul_i32 s1, s1, 16
		s_nop 0
		v_mov_b32_e32 v5, s1
		s_nop 0
		v_readfirstlane_b32 s1, v5
		s_cmp_lt_i32 s0, s1
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_0
.L_attn_fwd_persistent.loop_head_0:
		s_lshr_b32 s1, s0, 4
		s_and_b32 s21, s0, 15
		s_mul_i32 s1, s1, 8
		v_readfirstlane_b32 s24, v3
		s_add_i32 s1, s24, s1
		v_readfirstlane_b32 s24, v4
		s_cmp_lt_i32 s1, s24
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_0
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s24, 1, 0
		s_xor_b32 s25, s1, -1
		s_add_i32 s25, s25, 1
		s_cmp_lg_u32 s24, 0
		s_cselect_b32 s24, s25, s1
		s_cselect_b32 s25, 1, 0
		v_readfirstlane_b32 s26, v1
		s_xor_b32 s26, s26, -1
		s_add_i32 s26, s26, 1
		v_readfirstlane_b32 s27, v1
		s_cmp_lt_i32 s27, 0
		v_readfirstlane_b32 s27, v1
		s_cselect_b32 s26, s26, s27
		v_mov_b32_e32 v5, s26
		v_cvt_f32_u32_e32 v5, v5
		v_rcp_iflag_f32_e32 v5, v5
		v_mov_b32_e32 v6, 0x4f7ffffe
		v_mul_f32_e32 v5, v6, v5
		v_cvt_u32_f32_e32 v5, v5
		s_xor_b32 s27, s26, -1
		v_readfirstlane_b32 s28, v5
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
		v_readfirstlane_b32 s29, v1
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
		s_mov_b32 m0, s17
		v_mov_b32_e32 v5, s21
		ds_write_addtid_b32 v5 offset:3072
		v_readfirstlane_b32 s21, v5
		s_mul_i32 s21, s21, 0x100
		v_and_b32_e32 v6, 1, v0
		v_lshrrev_b32_e32 v7, 1, v0
		v_and_b32_e32 v8, 1, v7
		v_mov_b32_e32 v9, 2
		v_mul_lo_u32 v9, v9, v8
		v_lshrrev_b32_e32 v8, 2, v0
		v_and_b32_e32 v10, 1, v8
		v_mov_b32_e32 v11, 4
		v_mul_lo_u32 v11, v11, v10
		v_bitop3_b32 v10, v6, v9, v11 bitop3:0x96
		v_lshrrev_b32_e32 v12, 3, v0
		v_and_b32_e32 v13, 1, v12
		v_mov_b32_e32 v14, 8
		v_mul_lo_u32 v14, v14, v13
		v_xor_b32_e32 v10, v10, v14
		v_lshrrev_b32_e32 v15, 4, v0
		v_and_b32_e32 v16, 1, v15
		v_mov_b32_e32 v17, 16
		v_mul_lo_u32 v17, v17, v16
		v_lshrrev_b32_e32 v18, 6, v0
		v_and_b32_e32 v19, 1, v18
		v_mov_b32_e32 v20, 32
		v_mul_lo_u32 v20, v20, v19
		v_bitop3_b32 v10, v10, v17, v20 bitop3:0x96
		v_lshrrev_b32_e32 v21, 7, v0
		v_and_b32_e32 v22, 1, v21
		v_mov_b32_e32 v23, 64
		v_mul_lo_u32 v23, v23, v22
		v_xor_b32_e32 v10, v10, v23
		v_add_u32_e32 v24, s21, v10
		v_xor_b32_e32 v6, 0x80, v6
		v_xor_b32_e32 v6, v6, v9
		v_xor_b32_e32 v6, v6, v11
		v_bitop3_b32 v6, v6, v14, v17 bitop3:0x96
		v_bitop3_b32 v6, v6, v20, v23 bitop3:0x96
		v_add_u32_e32 v9, s21, v6
		v_cmp_lt_i32_e64 vcc, v24, s22
		s_mov_b64 s[26:27], vcc
		s_mov_b32 m0, s17
		v_mov_b32_e32 v24, s26
		v_mov_b32_e32 v25, s27
		ds_write_addtid_b32 v24 offset:7168
		s_mov_b32 m0, s17
		s_nop 0
		ds_write_addtid_b32 v25 offset:8192
		v_cmp_lt_i32_e64 vcc, v9, s22
		s_mov_b64 s[26:27], vcc
		s_mov_b32 m0, s17
		v_mov_b32_e32 v24, s26
		v_mov_b32_e32 v25, s27
		ds_write_addtid_b32 v24 offset:9216
		s_mov_b32 m0, s17
		s_nop 0
		ds_write_addtid_b32 v25 offset:10240
		v_mov_b32_e32 v9, 2
		v_mul_lo_u32 v9, v9, v16
		v_lshrrev_b32_e32 v11, 5, v0
		v_and_b32_e32 v14, 1, v11
		v_mov_b32_e32 v17, 4
		v_mul_lo_u32 v17, v17, v14
		v_bitop3_b32 v20, v13, v9, v17 bitop3:0x96
		v_mov_b32_e32 v23, 8
		v_mul_lo_u32 v23, v23, v19
		v_mov_b32_e32 v24, 16
		v_mul_lo_u32 v24, v24, v22
		v_bitop3_b32 v20, v20, v23, v24 bitop3:0x96
		v_add_u32_e32 v20, s21, v20
		v_cmp_lt_i32_e64 vcc, v20, s22
		s_mov_b64 s[26:27], vcc
		s_mov_b32 s30, 0x7fffffff
		s_mov_b32 s31, 0x31016000
		s_mov_b32 s28, s4
		s_mov_b32 s29, s5
		s_mov_b32 s32, s6
		s_mov_b32 s33, s7
		s_mov_b32 s34, s30
		s_mov_b32 s35, s31
		v_readfirstlane_b32 s25, v5
		s_mul_i32 s25, s25, s12
		s_lshl_b32 s25, s25, 9
		s_mul_i32 s36, s1, s10
		s_lshl_b32 s36, s36, 1
		s_add_i32 s25, s25, s36
		s_mul_i32 s36, s24, s11
		s_lshl_b32 s36, s36, 1
		s_add_i32 s25, s25, s36
		v_mul_lo_u32 v20, s12, v21
		v_lshlrev_b32_e32 v20, 5, v20
		v_and_b32_e32 v25, 1, v18
		v_mul_lo_u32 v26, s12, v25
		v_lshlrev_b32_e32 v26, 4, v26
		v_add3_u32 v20, s25, v20, v26
		v_and_b32_e32 v11, 1, v11
		v_mul_lo_u32 v26, s12, v11
		v_lshlrev_b32_e32 v26, 3, v26
		v_and_b32_e32 v15, 1, v15
		v_mul_lo_u32 v27, s12, v15
		v_lshlrev_b32_e32 v27, 2, v27
		v_add3_u32 v20, v20, v26, v27
		v_and_b32_e32 v12, 1, v12
		v_mul_lo_u32 v26, s12, v12
		v_lshlrev_b32_e32 v26, 1, v26
		v_accvgpr_write_b32 a0, v26
		v_and_b32_e32 v26, 1, v0
		v_lshlrev_b32_e32 v26, 4, v26
		v_accvgpr_read_b32 v27, a0
		v_add3_u32 v20, v20, v27, v26
		v_and_b32_e32 v8, 1, v8
		v_lshlrev_b32_e32 v8, 6, v8
		v_and_b32_e32 v7, 1, v7
		v_lshlrev_b32_e32 v7, 5, v7
		v_add3_u32 v20, v20, v8, v7
		v_mov_b32_e32 v27, 0x80000000
		v_cndmask_b32_e64 v20, v27, v20, s[26:27]
		s_mov_b32 s36, s2
		s_mov_b32 s37, s3
		s_mov_b32 s38, s30
		s_mov_b32 s39, s31
		buffer_load_dwordx4 v[28:31], v20, s[36:39], 0 offen
		v_bitop3_b32 v20, 32, v13, v9 bitop3:0x96
		v_xor_b32_e32 v20, v20, v17
		v_bitop3_b32 v20, v20, v23, v24 bitop3:0x96
		v_accvgpr_write_b32 a1, v20
		v_accvgpr_read_b32 v20, a1
		v_add_u32_e32 v20, s21, v20
		v_cmp_lt_i32_e64 vcc, v20, s22
		s_mov_b64 s[26:27], vcc
		v_lshlrev_b32_e32 v20, 4, v21
		v_lshlrev_b32_e32 v32, 3, v25
		v_lshlrev_b32_e32 v33, 2, v11
		v_add_u32_e32 v34, 32, v12
		v_lshlrev_b32_e32 v35, 1, v15
		v_bitop3_b32 v34, v33, v34, v35 bitop3:0x96
		v_bitop3_b32 v34, v20, v32, v34 bitop3:0x96
		v_mul_lo_u32 v34, s12, v34
		v_lshlrev_b32_e32 v34, 1, v34
		v_accvgpr_write_b32 a2, v34
		v_accvgpr_read_b32 v34, a2
		v_add3_u32 v34, s25, v34, v26
		v_add3_u32 v34, v34, v8, v7
		v_cndmask_b32_e64 v34, v27, v34, s[26:27]
		buffer_load_dwordx4 v[36:39], v34, s[36:39], 0 offen
		v_bitop3_b32 v34, 64, v13, v9 bitop3:0x96
		v_xor_b32_e32 v34, v34, v17
		v_bitop3_b32 v34, v34, v23, v24 bitop3:0x96
		v_accvgpr_write_b32 a3, v34
		v_accvgpr_read_b32 v34, a3
		v_add_u32_e32 v34, s21, v34
		v_cmp_lt_i32_e64 vcc, v34, s22
		s_mov_b64 s[26:27], vcc
		v_add_u32_e32 v34, 64, v12
		v_bitop3_b32 v34, v33, v34, v35 bitop3:0x96
		v_bitop3_b32 v34, v20, v32, v34 bitop3:0x96
		v_mul_lo_u32 v34, s12, v34
		v_lshlrev_b32_e32 v34, 1, v34
		v_accvgpr_write_b32 a4, v34
		v_accvgpr_read_b32 v34, a4
		v_add3_u32 v34, s25, v34, v26
		v_add3_u32 v34, v34, v8, v7
		v_cndmask_b32_e64 v34, v27, v34, s[26:27]
		buffer_load_dwordx4 v[40:43], v34, s[36:39], 0 offen
		v_xor_b32_e32 v34, 0x60, v13
		v_xor_b32_e32 v34, v34, v9
		v_xor_b32_e32 v34, v34, v17
		v_bitop3_b32 v34, v34, v23, v24 bitop3:0x96
		v_accvgpr_write_b32 a5, v34
		v_accvgpr_read_b32 v34, a5
		v_add_u32_e32 v34, s21, v34
		v_cmp_lt_i32_e64 vcc, v34, s22
		s_mov_b64 s[26:27], vcc
		v_add_u32_e32 v34, 0x60, v12
		v_bitop3_b32 v34, v33, v34, v35 bitop3:0x96
		v_bitop3_b32 v34, v20, v32, v34 bitop3:0x96
		v_mul_lo_u32 v34, s12, v34
		v_lshlrev_b32_e32 v34, 1, v34
		v_accvgpr_write_b32 a6, v34
		v_accvgpr_read_b32 v34, a6
		v_add3_u32 v34, s25, v34, v26
		v_add3_u32 v34, v34, v8, v7
		v_cndmask_b32_e64 v34, v27, v34, s[26:27]
		buffer_load_dwordx4 v[44:47], v34, s[36:39], 0 offen
		v_xor_b32_e32 v34, 0x80, v13
		v_xor_b32_e32 v34, v34, v9
		v_xor_b32_e32 v34, v34, v17
		v_bitop3_b32 v34, v34, v23, v24 bitop3:0x96
		v_accvgpr_write_b32 a7, v34
		v_accvgpr_read_b32 v34, a7
		v_add_u32_e32 v34, s21, v34
		v_cmp_lt_i32_e64 vcc, v34, s22
		s_mov_b64 s[26:27], vcc
		v_add_u32_e32 v34, 0x80, v12
		v_bitop3_b32 v34, v33, v34, v35 bitop3:0x96
		v_bitop3_b32 v34, v20, v32, v34 bitop3:0x96
		v_mul_lo_u32 v34, s12, v34
		v_lshlrev_b32_e32 v34, 1, v34
		v_accvgpr_write_b32 a8, v34
		v_accvgpr_read_b32 v34, a8
		v_add3_u32 v34, s25, v34, v26
		v_add3_u32 v34, v34, v8, v7
		v_cndmask_b32_e64 v34, v27, v34, s[26:27]
		buffer_load_dwordx4 v[48:51], v34, s[36:39], 0 offen
		v_xor_b32_e32 v34, 0xa0, v13
		v_xor_b32_e32 v34, v34, v9
		v_xor_b32_e32 v34, v34, v17
		v_bitop3_b32 v34, v34, v23, v24 bitop3:0x96
		v_accvgpr_write_b32 a9, v34
		v_accvgpr_read_b32 v34, a9
		v_add_u32_e32 v34, s21, v34
		v_cmp_lt_i32_e64 vcc, v34, s22
		s_mov_b64 s[26:27], vcc
		v_add_u32_e32 v34, 0xa0, v12
		v_bitop3_b32 v34, v33, v34, v35 bitop3:0x96
		v_bitop3_b32 v34, v20, v32, v34 bitop3:0x96
		v_mul_lo_u32 v34, s12, v34
		v_lshlrev_b32_e32 v34, 1, v34
		v_accvgpr_write_b32 a10, v34
		v_accvgpr_read_b32 v34, a10
		v_add3_u32 v34, s25, v34, v26
		v_add3_u32 v34, v34, v8, v7
		v_cndmask_b32_e64 v34, v27, v34, s[26:27]
		buffer_load_dwordx4 v[52:55], v34, s[36:39], 0 offen
		v_xor_b32_e32 v34, 0xc0, v13
		v_xor_b32_e32 v34, v34, v9
		v_xor_b32_e32 v34, v34, v17
		v_bitop3_b32 v34, v34, v23, v24 bitop3:0x96
		v_accvgpr_write_b32 a11, v34
		v_accvgpr_read_b32 v34, a11
		v_add_u32_e32 v34, s21, v34
		v_cmp_lt_i32_e64 vcc, v34, s22
		s_mov_b64 s[26:27], vcc
		v_add_u32_e32 v34, 0xc0, v12
		v_bitop3_b32 v34, v33, v34, v35 bitop3:0x96
		v_bitop3_b32 v34, v20, v32, v34 bitop3:0x96
		v_mul_lo_u32 v34, s12, v34
		v_lshlrev_b32_e32 v34, 1, v34
		v_accvgpr_write_b32 a12, v34
		v_accvgpr_read_b32 v34, a12
		v_add3_u32 v34, s25, v34, v26
		v_add3_u32 v34, v34, v8, v7
		v_cndmask_b32_e64 v34, v27, v34, s[26:27]
		buffer_load_dwordx4 v[56:59], v34, s[36:39], 0 offen
		v_xor_b32_e32 v34, 0xe0, v13
		v_xor_b32_e32 v9, v34, v9
		v_xor_b32_e32 v9, v9, v17
		v_bitop3_b32 v9, v9, v23, v24 bitop3:0x96
		v_accvgpr_write_b32 a13, v9
		v_accvgpr_read_b32 v9, a13
		v_add_u32_e32 v9, s21, v9
		v_add_u32_e32 v23, 0xe0, v12
		v_bitop3_b32 v23, v33, v23, v35 bitop3:0x96
		v_bitop3_b32 v23, v20, v32, v23 bitop3:0x96
		v_mul_lo_u32 v23, s12, v23
		v_lshlrev_b32_e32 v23, 1, v23
		v_accvgpr_write_b32 a14, v23
		v_accvgpr_read_b32 v23, a14
		v_add3_u32 v23, s25, v23, v26
		v_cmp_lt_i32_e64 vcc, v9, s22
		v_add3_u32 v9, v23, v8, v7
		s_nop 0
		v_cndmask_b32_e32 v9, v27, v9, vcc
		buffer_load_dwordx4 v[60:63], v9, s[36:39], 0 offen
		s_waitcnt vmcnt(8)
		s_barrier
		v_lshlrev_b32_e32 v9, 2, v25
		v_lshlrev_b32_e32 v23, 1, v11
		v_xor_b32_e32 v24, v0, v15
		v_bitop3_b32 v9, v9, v23, v24 bitop3:0x96
		v_lshlrev_b32_e32 v9, 4, v9
		v_add_u32_e32 v9, 0x10000, v9
		s_waitcnt vmcnt(7)
		ds_write_b128 v9, v[28:31] offset:2480
		s_waitcnt vmcnt(6)
		ds_write_b128 v9, v[36:39] offset:6576
		s_waitcnt vmcnt(5)
		ds_write_b128 v9, v[40:43] offset:10672
		s_waitcnt vmcnt(4)
		ds_write_b128 v9, v[44:47] offset:14768
		v_lshlrev_b32_e32 v18, 12, v18
		v_add_u32_e32 v18, 0x10000, v18
		v_and_b32_e32 v23, 63, v0
		v_lshrrev_b32_e32 v24, 2, v23
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v24, 1, v24
		v_lshlrev_b32_e32 v24, 5, v24
		v_lshrrev_b32_e32 v28, 1, v23
		v_and_b32_e32 v28, 1, v28
		v_lshlrev_b32_e32 v28, 4, v28
		v_and_b32_e32 v29, 1, v23
		v_lshlrev_b32_e32 v29, 3, v29
		v_add3_u32 v30, v24, v28, v29
		v_lshrrev_b32_e32 v31, 5, v23
		v_xor_b32_e32 v30, v30, v31
		v_lshrrev_b32_e32 v33, 6, v30
		v_lshrrev_b32_e32 v34, 3, v23
		v_and_b32_e32 v34, 1, v34
		v_add_u32_e32 v33, v33, v34
		v_and_b32_e32 v33, 1, v33
		v_lshlrev_b32_e32 v33, 2, v33
		v_lshrrev_b32_e32 v35, 5, v30
		v_and_b32_e32 v35, 1, v35
		v_lshlrev_b32_e32 v35, 1, v35
		v_lshrrev_b32_e32 v36, 4, v23
		v_and_b32_e32 v36, 1, v36
		v_lshlrev_b32_e32 v37, 6, v34
		v_lshl_add_u32 v36, v36, 7, v37
		v_add_u32_e32 v37, v36, v30
		v_lshrrev_b32_e32 v30, 4, v30
		v_bitop3_b32 v30, v37, v30, 1 bitop3:0x78
		v_bitop3_b32 v30, v33, v35, v30 bitop3:0x96
		v_lshl_add_u32 v33, v30, 4, v18
		v_accvgpr_write_b32 a15, v33
		v_accvgpr_read_b32 v33, a15
		ds_read_b128 a[16:19], v33 offset:2480
		v_add_u32_e32 v33, 2, v24
		v_add3_u32 v33, v33, v28, v29
		v_xor_b32_e32 v33, v33, v31
		v_lshrrev_b32_e32 v35, 6, v33
		v_add_u32_e32 v35, v35, v34
		v_and_b32_e32 v35, 1, v35
		v_lshlrev_b32_e32 v35, 2, v35
		v_lshrrev_b32_e32 v37, 5, v33
		v_and_b32_e32 v37, 1, v37
		v_lshlrev_b32_e32 v37, 1, v37
		v_add_u32_e32 v38, v36, v33
		v_lshrrev_b32_e32 v33, 4, v33
		v_bitop3_b32 v33, v38, v33, 1 bitop3:0x78
		v_bitop3_b32 v33, v35, v37, v33 bitop3:0x96
		v_lshl_add_u32 v35, v33, 4, v18
		v_accvgpr_write_b32 a20, v35
		v_accvgpr_read_b32 v35, a20
		ds_read_b128 a[24:27], v35 offset:2480
		v_add_u32_e32 v35, 4, v24
		v_add3_u32 v35, v35, v28, v29
		v_xor_b32_e32 v35, v35, v31
		v_lshrrev_b32_e32 v37, 6, v35
		v_add_u32_e32 v37, v37, v34
		v_and_b32_e32 v37, 1, v37
		v_lshlrev_b32_e32 v37, 2, v37
		v_lshrrev_b32_e32 v38, 5, v35
		v_and_b32_e32 v38, 1, v38
		v_lshlrev_b32_e32 v38, 1, v38
		v_add_u32_e32 v39, v36, v35
		v_lshrrev_b32_e32 v35, 4, v35
		v_bitop3_b32 v35, v39, v35, 1 bitop3:0x78
		v_bitop3_b32 v35, v37, v38, v35 bitop3:0x96
		v_lshl_add_u32 v37, v35, 4, v18
		v_accvgpr_write_b32 a21, v37
		v_accvgpr_read_b32 v37, a21
		ds_read_b128 a[28:31], v37 offset:2480
		v_add_u32_e32 v24, 6, v24
		v_add3_u32 v24, v24, v28, v29
		v_xor_b32_e32 v24, v24, v31
		v_lshrrev_b32_e32 v28, 6, v24
		v_add_u32_e32 v28, v28, v34
		v_and_b32_e32 v28, 1, v28
		v_lshlrev_b32_e32 v28, 2, v28
		v_lshrrev_b32_e32 v29, 5, v24
		v_and_b32_e32 v29, 1, v29
		v_lshlrev_b32_e32 v29, 1, v29
		v_add_u32_e32 v34, v36, v24
		v_lshrrev_b32_e32 v24, 4, v24
		v_bitop3_b32 v24, v34, v24, 1 bitop3:0x78
		v_bitop3_b32 v24, v28, v29, v24 bitop3:0x96
		v_lshl_add_u32 v18, v24, 4, v18
		v_accvgpr_write_b32 a22, v18
		v_accvgpr_read_b32 v18, a22
		ds_read_b128 a[32:35], v18 offset:2480
		v_add_u32_e32 v18, 32, v32
		v_xor_b32_e32 v18, v18, v20
		v_lshrrev_b32_e32 v20, 5, v18
		v_and_b32_e32 v20, 1, v20
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(3)
		ds_write_b128 v9, v[48:51] offset:2480
		s_waitcnt vmcnt(2)
		ds_write_b128 v9, v[52:55] offset:6576
		s_waitcnt vmcnt(1)
		ds_write_b128 v9, v[56:59] offset:10672
		s_waitcnt vmcnt(0)
		ds_write_b128 v9, v[60:63] offset:14768
		v_lshlrev_b32_e32 v9, 14, v20
		v_accvgpr_write_b32 a23, v9
		v_lshrrev_b32_e32 v9, 4, v18
		v_and_b32_e32 v9, 1, v9
		v_lshlrev_b32_e32 v9, 13, v9
		v_accvgpr_write_b32 a36, v9
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshrrev_b32_e32 v9, 3, v18
		v_and_b32_e32 v9, 1, v9
		v_lshlrev_b32_e32 v9, 12, v9
		v_accvgpr_write_b32 a37, v9
		v_accvgpr_read_b32 v9, a36
		v_accvgpr_read_b32 v18, a37
		v_accvgpr_read_b32 v20, a23
		v_add3_u32 v9, v20, v9, v18
		v_lshl_add_u32 v18, v30, 4, v9
		ds_read_b128 a[40:43], v18 offset:51632
		v_lshl_add_u32 v18, v33, 4, v9
		ds_read_b128 a[44:47], v18 offset:51632
		v_lshl_add_u32 v18, v35, 4, v9
		ds_read_b128 a[48:51], v18 offset:51632
		v_lshl_add_u32 v9, v24, 4, v9
		ds_read_b128 a[52:55], v9 offset:51632
		v_readfirstlane_b32 s25, v5
		s_add_i32 s25, s25, 1
		s_mul_i32 s25, s25, 0x100
		v_readfirstlane_b32 s26, v2
		s_add_i32 s25, s25, s26
		s_cmp_lt_i32 s23, s25
		s_cselect_b32 s25, s23, s25
		s_add_i32 s26, s25, 0x7f
		s_mov_b32 s27, 0x7f
		s_cmp_lt_i32 s26, 0
		s_cselect_b32 s40, s27, 0
		s_add_i32 s26, s26, s40
		s_ashr_i32 s26, s26, 7
		v_readfirstlane_b32 s40, v2
		s_add_i32 s40, s21, s40
		s_cmp_lt_i32 s40, 0
		s_cselect_b32 s41, s27, 0
		s_add_i32 s40, s40, s41
		s_ashr_i32 s40, s40, 7
		s_cmp_lt_i32 s40, s26
		s_cselect_b32 s40, s40, s26
		s_cmp_gt_i32 s40, 0
		s_cselect_b32 s40, s40, 0
		v_mov_b32_e32 v5, 64
		v_mul_lo_u32 v5, v5, v13
		v_mov_b32_e32 v9, 32
		v_mul_lo_u32 v9, v9, v16
		v_mov_b32_e32 v16, 16
		v_mul_lo_u32 v16, v16, v14
		v_bitop3_b32 v18, v5, v9, v16 bitop3:0x96
		v_mov_b32_e32 v20, 2
		v_mul_lo_u32 v20, v20, v22
		v_bitop3_b32 v18, v18, v19, v20 bitop3:0x96
		v_bitop3_b32 v22, 4, v5, v9 bitop3:0x96
		v_xor_b32_e32 v22, v22, v16
		v_bitop3_b32 v22, v22, v19, v20 bitop3:0x96
		v_bitop3_b32 v24, 8, v5, v9 bitop3:0x96
		v_xor_b32_e32 v24, v24, v16
		v_bitop3_b32 v24, v24, v19, v20 bitop3:0x96
		v_bitop3_b32 v5, 12, v5, v9 bitop3:0x96
		v_xor_b32_e32 v5, v5, v16
		v_bitop3_b32 v5, v5, v19, v20 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v18, s23
		s_mov_b64 s[42:43], vcc
		v_cmp_lt_i32_e64 vcc, v22, s23
		s_mov_b64 s[44:45], vcc
		v_cmp_lt_i32_e64 vcc, v24, s23
		s_mov_b64 s[46:47], vcc
		v_cmp_lt_i32_e64 vcc, v5, s23
		s_mov_b64 s[48:49], vcc
		v_mov_b32_e32 v16, 16
		v_mul_lo_u32 v16, v16, v13
		v_mov_b32_e32 v13, 64
		v_mul_lo_u32 v13, v13, v14
		v_bitop3_b32 v14, v16, v9, v13 bitop3:0x96
		v_bitop3_b32 v14, v14, v19, v20 bitop3:0x96
		v_bitop3_b32 v28, 4, v16, v9 bitop3:0x96
		v_xor_b32_e32 v28, v28, v13
		v_bitop3_b32 v28, v28, v19, v20 bitop3:0x96
		v_bitop3_b32 v29, 8, v16, v9 bitop3:0x96
		v_xor_b32_e32 v29, v29, v13
		v_bitop3_b32 v29, v29, v19, v20 bitop3:0x96
		v_bitop3_b32 v9, 12, v16, v9 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v14, s23
		s_mov_b64 s[50:51], vcc
		v_cmp_lt_i32_e64 vcc, v28, s23
		s_mov_b64 s[52:53], vcc
		v_cmp_lt_i32_e64 vcc, v29, s23
		s_mov_b64 s[54:55], vcc
		v_readfirstlane_b32 s56, v0
		v_mul_lo_u32 v16, s15, v21
		v_mul_lo_u32 v30, s15, v25
		v_lshlrev_b32_e32 v30, 1, v30
		v_lshl_add_u32 v16, v16, 2, v30
		v_mul_lo_u32 v30, s15, v11
		v_lshl_add_u32 v16, v30, 5, v16
		v_mul_lo_u32 v30, s15, v15
		v_lshl_add_u32 v16, v30, 6, v16
		v_mul_lo_u32 v30, s15, v12
		v_lshlrev_b32_e32 v30, 7, v30
		v_add3_u32 v16, v16, v30, v26
		v_add3_u32 v16, v16, v8, v7
		s_mul_i32 s41, s1, s13
		s_lshl_b32 s41, s41, 1
		s_mul_i32 s57, s24, s14
		s_lshl_b32 s57, s57, 1
		s_add_i32 s58, s41, s57
		v_add_u32_e32 v30, s58, v16
		v_cndmask_b32_e64 v30, v27, v30, s[42:43]
		v_accvgpr_write_b32 a38, v30
		s_lshr_b32 s42, s56, 6
		s_mul_i32 s43, 0x410, s42
		s_mov_b32 m0, s43
		v_xor_b32_e32 v9, v9, v13
		v_accvgpr_read_b32 v13, a38
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		v_bitop3_b32 v9, v9, v19, v20 bitop3:0x96
		s_lshl_b32 s58, s15, 3
		s_add_i32 s58, s58, s41
		s_add_i32 s58, s58, s57
		v_add_u32_e32 v13, s58, v16
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v13, v27, v13, s[44:45]
		v_accvgpr_write_b32 a39, v13
		v_accvgpr_read_b32 v13, a39
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		s_lshl_b32 s44, s15, 4
		s_add_i32 s44, s44, s41
		s_add_i32 s44, s44, s57
		v_add_u32_e32 v13, s44, v16
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v13, v27, v13, s[46:47]
		v_accvgpr_write_b32 a56, v13
		v_accvgpr_read_b32 v13, a56
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		s_mul_i32 s44, 24, s15
		s_add_i32 s44, s44, s41
		s_add_i32 s44, s44, s57
		v_add_u32_e32 v13, s44, v16
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v13, v27, v13, s[48:49]
		v_accvgpr_write_b32 a57, v13
		v_accvgpr_read_b32 v13, a57
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		v_mul_lo_u32 v13, s20, v21
		v_mul_lo_u32 v19, s20, v25
		v_lshlrev_b32_e32 v19, 1, v19
		v_lshl_add_u32 v13, v13, 2, v19
		v_mul_lo_u32 v11, s20, v11
		v_lshl_add_u32 v11, v11, 7, v13
		v_mul_lo_u32 v13, s20, v15
		v_lshl_add_u32 v11, v13, 6, v11
		v_mul_lo_u32 v12, s20, v12
		v_lshlrev_b32_e32 v12, 5, v12
		v_add3_u32 v11, v11, v12, v26
		v_add3_u32 v7, v11, v8, v7
		s_mul_i32 s44, s1, s18
		s_lshl_b32 s44, s44, 1
		s_mul_i32 s45, s24, s19
		s_lshl_b32 s45, s45, 1
		s_add_i32 s46, s44, s45
		v_add_u32_e32 v8, s46, v7
		s_mul_i32 s42, 0x440, s42
		s_add_i32 m0, s42, 0x81f0
		v_cndmask_b32_e64 v8, v27, v8, s[50:51]
		v_accvgpr_write_b32 a58, v8
		v_accvgpr_read_b32 v8, a58
		buffer_load_dwordx4 v8, s[32:35], 0 offen lds
		s_lshl_b32 s46, s20, 3
		s_add_i32 s46, s46, s44
		s_add_i32 s46, s46, s45
		v_add_u32_e32 v8, s46, v7
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v8, v27, v8, s[52:53]
		v_accvgpr_write_b32 a59, v8
		v_accvgpr_read_b32 v8, a59
		buffer_load_dwordx4 v8, s[32:35], 0 offen lds
		s_lshl_b32 s46, s20, 4
		s_add_i32 s46, s46, s44
		s_add_i32 s46, s46, s45
		v_add_u32_e32 v8, s46, v7
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v8, v27, v8, s[54:55]
		v_accvgpr_write_b32 a60, v8
		v_accvgpr_read_b32 v8, a60
		buffer_load_dwordx4 v8, s[32:35], 0 offen lds
		s_mul_i32 s46, 24, s20
		s_add_i32 s46, s46, s44
		s_add_i32 s46, s46, s45
		v_cmp_lt_i32_e64 vcc, v9, s23
		v_add_u32_e32 v8, s46, v7
		v_mbcnt_lo_u32_b32 v11, -1, 0
		v_cndmask_b32_e32 v8, v27, v8, vcc
		v_accvgpr_write_b32 a61, v8
		s_add_i32 m0, m0, 0x1100
		s_mul_i32 s46, s40, 0x80
		v_accvgpr_read_b32 v8, a61
		buffer_load_dwordx4 v8, s[32:35], 0 offen lds
		v_mbcnt_hi_u32_b32 v8, -1, v11
		v_and_b32_e32 v11, 1, v8
		v_lshrrev_b32_e32 v12, 4, v8
		v_and_b32_e32 v12, 1, v12
		v_lshlrev_b32_e32 v12, 4, v12
		v_lshrrev_b32_e32 v13, 3, v8
		v_and_b32_e32 v13, 1, v13
		v_lshlrev_b32_e32 v13, 3, v13
		v_add3_u32 v15, v11, v12, v13
		v_lshrrev_b32_e32 v19, 2, v8
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 2, v19
		v_lshrrev_b32_e32 v20, 1, v8
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v20, 1, v20
		v_add3_u32 v15, v15, v19, v20
		v_add_u32_e32 v11, 32, v11
		v_bitop3_b32 v11, v19, v11, v20 bitop3:0x96
		v_bitop3_b32 v11, v12, v13, v11 bitop3:0x96
		v_mov_b32_e32 v12, 0x3e38aa3b
		v_mov_b32_e32 v13, 0x3e38aa3b
		s_mov_b32 s40, 0xff800000
		s_mov_b32 m0, s17
		v_mov_b32_e32 v19, s40
		ds_write_addtid_b32 v19 offset:5120
		v_readfirstlane_b32 s40, v19
		s_nop 1
		v_mov_b32_e32 v20, s40
		v_readfirstlane_b32 s40, v19
		s_nop 1
		v_mov_b32_e32 v19, s40
		s_mov_b32 s40, 1.0
		s_mov_b32 m0, s17
		v_mov_b32_e32 v21, s40
		ds_write_addtid_b32 v21 offset:6144
		v_readfirstlane_b32 s40, v21
		s_nop 1
		v_mov_b32_e32 v32, s40
		v_readfirstlane_b32 s40, v21
		s_nop 1
		v_mov_b32_e32 v33, s40
		s_mov_b32 s40, 0
		v_lshlrev_b32_e32 v21, 4, v31
		v_and_b32_e32 v25, 31, v23
		v_lshrrev_b32_e32 v26, 4, v25
		v_lshlrev_b32_e32 v30, 9, v26
		v_lshrrev_b32_e32 v34, 3, v25
		v_and_b32_e32 v34, 1, v34
		v_mov_b32_e32 v35, 0x2080
		v_mul_lo_u32 v35, v35, v34
		v_lshrrev_b32_e32 v34, 2, v25
		v_and_b32_e32 v34, 1, v34
		v_mov_b32_e32 v36, 0x1040
		v_mul_lo_u32 v36, v36, v34
		v_lshrrev_b32_e32 v34, 1, v25
		v_and_b32_e32 v34, 1, v34
		v_mov_b32_e32 v37, 0x820
		v_mul_lo_u32 v37, v37, v34
		v_and_b32_e32 v25, 1, v25
		v_mov_b32_e32 v34, 0x410
		v_mul_lo_u32 v34, v34, v25
		v_mov_b32_e32 v25, 0x2200
		v_mul_lo_u32 v25, v25, v31
		v_lshlrev_b32_e32 v26, 5, v26
		v_and_b32_e32 v23, 15, v23
		v_lshrrev_b32_e32 v38, 2, v23
		v_mov_b32_e32 v39, 0x440
		v_mul_lo_u32 v39, v39, v38
		v_and_b32_e32 v23, 3, v23
		v_lshlrev_b32_e32 v38, 3, v23
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
		v_lshlrev_b32_e32 v15, 2, v15
		v_lshlrev_b32_e32 v11, 2, v11
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
		v_mov_b64_e32 v[80:81], 0
		v_mov_b64_e32 v[82:83], 0
		v_mov_b64_e32 v[84:85], 0
		v_mov_b64_e32 v[86:87], 0
		v_mov_b64_e32 v[88:89], 0
		v_mov_b64_e32 v[90:91], 0
		v_mov_b64_e32 v[92:93], 0
		v_mov_b64_e32 v[94:95], 0
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
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_1
.L_attn_fwd_persistent.loop_head_1:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s45, s40, 0x80
		s_lshr_b32 s53, s40, 7
		s_and_b32 s54, s53, 1
		s_mul_i32 s55, 0x4100, s54
		v_add3_u32 v40, s55, v21, v30
		v_add3_u32 v40, v40, v35, v36
		v_add3_u32 v40, v40, v37, v34
		ds_read_b128 a[80:83], v40
		ds_read_b128 a[84:87], v40 offset:32
		ds_read_b128 a[88:91], v40 offset:64
		ds_read_b128 a[92:95], v40 offset:96
		ds_read_b128 a[96:99], v40 offset:256
		ds_read_b128 a[100:103], v40 offset:288
		ds_read_b128 a[104:107], v40 offset:320
		ds_read_b128 a[108:111], v40 offset:352
		ds_read_b128 a[112:115], v40 offset:128
		ds_read_b128 a[116:119], v40 offset:160
		ds_read_b128 a[120:123], v40 offset:192
		ds_read_b128 a[124:127], v40 offset:224
		ds_read_b128 v[44:47], v40 offset:384
		ds_read_b128 a[128:131], v40 offset:416
		ds_read_b128 a[132:135], v40 offset:448
		ds_read_b128 a[136:139], v40 offset:480
		s_mul_i32 s54, 0x4400, s54
		v_add3_u32 v40, s54, v25, v26
		v_add3_u32 v40, v40, v39, v38
		ds_read_b64_tr_b16 a[140:141], v40 offset:33264
		ds_read_b64_tr_b16 a[142:143], v40 offset:37616
		ds_read_b64_tr_b16 a[144:145], v40 offset:33392
		ds_read_b64_tr_b16 a[146:147], v40 offset:37744
		ds_read_b64_tr_b16 a[148:149], v40 offset:33520
		ds_read_b64_tr_b16 a[150:151], v40 offset:37872
		ds_read_b64_tr_b16 a[152:153], v40 offset:33648
		ds_read_b64_tr_b16 a[154:155], v40 offset:38000
		ds_read_b64_tr_b16 a[156:157], v40 offset:33776
		ds_read_b64_tr_b16 a[158:159], v40 offset:38128
		ds_read_b64_tr_b16 a[160:161], v40 offset:33904
		ds_read_b64_tr_b16 a[162:163], v40 offset:38256
		ds_read_b64_tr_b16 a[164:165], v40 offset:34032
		ds_read_b64_tr_b16 a[166:167], v40 offset:38384
		ds_read_b64_tr_b16 a[168:169], v40 offset:34160
		ds_read_b64_tr_b16 a[170:171], v40 offset:38512
		ds_read_b64_tr_b16 a[172:173], v40 offset:33328
		ds_read_b64_tr_b16 a[174:175], v40 offset:37680
		ds_read_b64_tr_b16 a[176:177], v40 offset:33456
		ds_read_b64_tr_b16 a[178:179], v40 offset:37808
		ds_read_b64_tr_b16 a[180:181], v40 offset:33584
		ds_read_b64_tr_b16 a[182:183], v40 offset:37936
		ds_read_b64_tr_b16 a[184:185], v40 offset:33712
		ds_read_b64_tr_b16 a[186:187], v40 offset:38064
		ds_read_b64_tr_b16 a[188:189], v40 offset:33840
		ds_read_b64_tr_b16 a[190:191], v40 offset:38192
		ds_read_b64_tr_b16 a[192:193], v40 offset:33968
		ds_read_b64_tr_b16 a[194:195], v40 offset:38320
		ds_read_b64_tr_b16 a[196:197], v40 offset:34096
		ds_read_b64_tr_b16 a[198:199], v40 offset:38448
		ds_read_b64_tr_b16 a[200:201], v40 offset:34224
		ds_read_b64_tr_b16 a[202:203], v40 offset:38576
		v_add_u32_e32 v40, s45, v18
		v_add_u32_e32 v41, s45, v22
		v_add_u32_e32 v42, s45, v24
		v_add_u32_e32 v43, s45, v5
		v_cmp_lt_i32_e64 vcc, v40, s23
		s_mov_b64 s[54:55], vcc
		v_cmp_lt_i32_e64 vcc, v41, s23
		s_mov_b64 s[58:59], vcc
		v_cmp_lt_i32_e64 vcc, v42, s23
		s_mov_b64 s[60:61], vcc
		v_cmp_lt_i32_e64 vcc, v43, s23
		s_mov_b64 s[62:63], vcc
		v_add_u32_e32 v40, s45, v14
		v_add_u32_e32 v41, s45, v28
		v_add_u32_e32 v42, s45, v29
		v_cmp_lt_i32_e64 vcc, v40, s23
		s_mov_b64 s[64:65], vcc
		v_cmp_lt_i32_e64 vcc, v41, s23
		s_mov_b64 s[66:67], vcc
		v_cmp_lt_i32_e64 vcc, v42, s23
		s_mov_b64 s[68:69], vcc
		s_barrier
		s_mul_i32 s57, s15, s40
		s_lshl_b32 s57, s57, 1
		s_add_i32 s70, s47, s57
		v_add_u32_e32 v40, s70, v16
		v_cndmask_b32_e64 v40, v27, v40, s[54:55]
		s_add_i32 s53, s53, 1
		s_and_b32 s53, s53, 1
		s_mul_i32 s54, 0x4100, s53
		s_add_i32 s54, s43, s54
		s_mov_b32 m0, s54
		v_add_u32_e32 v41, s45, v9
		buffer_load_dwordx4 v40, s[28:31], 0 offen lds
		v_add_u32_e32 v40, s57, v16
		v_add_u32_e32 v42, s48, v40
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v42, v27, v42, s[58:59]
		buffer_load_dwordx4 v42, s[28:31], 0 offen lds
		v_add_u32_e32 v42, s49, v40
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v42, v27, v42, s[60:61]
		buffer_load_dwordx4 v42, s[28:31], 0 offen lds
		v_add_u32_e32 v40, s41, v40
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v40, v27, v40, s[62:63]
		buffer_load_dwordx4 v40, s[28:31], 0 offen lds
		s_barrier
		s_mul_i32 s40, s20, s40
		s_lshl_b32 s40, s40, 1
		s_add_i32 s54, s50, s40
		v_add_u32_e32 v40, s54, v7
		s_mul_i32 s53, 0x4400, s53
		s_add_i32 s53, s42, s53
		s_add_i32 m0, s53, 0x81f0
		v_cndmask_b32_e64 v40, v27, v40, s[64:65]
		buffer_load_dwordx4 v40, s[32:35], 0 offen lds
		v_add_u32_e32 v40, s40, v7
		v_add_u32_e32 v42, s51, v40
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v42, v27, v42, s[66:67]
		buffer_load_dwordx4 v42, s[32:35], 0 offen lds
		v_add_u32_e32 v42, s52, v40
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v42, v27, v42, s[68:69]
		buffer_load_dwordx4 v42, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v41, s23
		v_add_u32_e32 v40, s44, v40
		v_accvgpr_write_b32 a63, v33
		v_cndmask_b32_e32 v33, v27, v40, vcc
		s_add_i32 m0, m0, 0x1100
		v_accvgpr_write_b32 a62, v32
		buffer_load_dwordx4 v33, s[32:35], 0 offen lds
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[96:111], a[80:83], a[16:19], 0
		v_mfma_f32_32x32x16_bf16 v[112:127], a[96:99], a[16:19], 0
		v_mfma_f32_32x32x16_bf16 v[128:143], a[112:115], a[16:19], 0
		v_mfma_f32_32x32x16_bf16 v[144:159], v[44:47], a[16:19], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[44:47], a[40:43], 0
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
		v_mfma_f32_32x32x16_bf16 v[160:175], a[80:83], a[40:43], 0
		v_mfma_f32_32x32x16_bf16 v[176:191], a[96:99], a[40:43], 0
		s_nop 11
		v_accvgpr_write_b32 a224, v176
		v_accvgpr_write_b32 a225, v177
		v_accvgpr_write_b32 a226, v178
		v_accvgpr_write_b32 a227, v179
		v_accvgpr_write_b32 a228, v180
		v_accvgpr_write_b32 a229, v181
		v_accvgpr_write_b32 a230, v182
		v_accvgpr_write_b32 a231, v183
		v_accvgpr_write_b32 a232, v184
		v_accvgpr_write_b32 a233, v185
		v_accvgpr_write_b32 a234, v186
		v_accvgpr_write_b32 a235, v187
		v_accvgpr_write_b32 a236, v188
		v_accvgpr_write_b32 a237, v189
		v_accvgpr_write_b32 a238, v190
		v_accvgpr_write_b32 a239, v191
		v_mfma_f32_32x32x16_bf16 v[176:191], a[112:115], a[40:43], 0
		v_mfma_f32_32x32x16_bf16 v[96:111], a[84:87], a[24:27], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[100:103], a[24:27], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[116:119], a[24:27], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[128:131], a[24:27], v[144:159]
		v_mfma_f32_32x32x16_bf16 a[208:223], a[128:131], a[44:47], a[208:223]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[84:87], a[44:47], v[160:175]
		v_mfma_f32_32x32x16_bf16 a[224:239], a[100:103], a[44:47], a[224:239]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[116:119], a[44:47], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[88:91], a[28:31], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[104:107], a[28:31], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[120:123], a[28:31], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[132:135], a[28:31], v[144:159]
		v_mfma_f32_32x32x16_bf16 a[208:223], a[132:135], a[48:51], a[208:223]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[88:91], a[48:51], v[160:175]
		v_mfma_f32_32x32x16_bf16 a[224:239], a[104:107], a[48:51], a[224:239]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[120:123], a[48:51], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[92:95], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[108:111], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[124:127], a[32:35], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[136:139], a[32:35], v[144:159]
		v_mfma_f32_32x32x16_bf16 a[208:223], a[136:139], a[52:55], a[208:223]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[92:95], a[52:55], v[160:175]
		v_mfma_f32_32x32x16_bf16 a[224:239], a[108:111], a[52:55], a[224:239]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[124:127], a[52:55], v[176:191]
		s_nop 4
		v_max_f32_e32 v32, v96, v97
		v_max_f32_e32 v33, v98, v99
		v_max_f32_e32 v40, v100, v101
		v_max_f32_e32 v41, v102, v103
		v_max_f32_e32 v42, v104, v105
		v_max_f32_e32 v43, v106, v107
		v_max_f32_e32 v44, v108, v109
		v_max_f32_e32 v45, v110, v111
		v_max_f32_e32 v46, v112, v113
		v_max_f32_e32 v47, v114, v115
		v_max_f32_e32 v192, v116, v117
		v_max_f32_e32 v193, v118, v119
		v_max_f32_e32 v194, v120, v121
		v_max_f32_e32 v195, v122, v123
		v_max_f32_e32 v196, v124, v125
		v_max_f32_e32 v197, v126, v127
		v_max_f32_e32 v198, v128, v129
		v_max_f32_e32 v199, v130, v131
		v_max_f32_e32 v200, v132, v133
		v_max_f32_e32 v201, v134, v135
		v_max_f32_e32 v202, v136, v137
		v_max_f32_e32 v203, v138, v139
		v_max_f32_e32 v204, v140, v141
		v_max_f32_e32 v205, v142, v143
		v_max_f32_e32 v206, v144, v145
		v_max_f32_e32 v207, v146, v147
		v_max_f32_e32 v208, v148, v149
		v_max_f32_e32 v209, v150, v151
		v_max_f32_e32 v210, v152, v153
		v_max_f32_e32 v211, v154, v155
		v_max_f32_e32 v212, v156, v157
		v_max_f32_e32 v213, v158, v159
		v_max_f32_e32 v32, v32, v33
		v_max_f32_e32 v33, v40, v41
		v_max_f32_e32 v40, v42, v43
		v_max_f32_e32 v41, v44, v45
		v_max_f32_e32 v42, v46, v47
		v_max_f32_e32 v43, v192, v193
		v_max_f32_e32 v44, v194, v195
		v_max_f32_e32 v45, v196, v197
		v_max_f32_e32 v46, v198, v199
		v_max_f32_e32 v47, v200, v201
		v_max_f32_e32 v192, v202, v203
		v_max_f32_e32 v193, v204, v205
		v_max_f32_e32 v194, v206, v207
		v_max_f32_e32 v195, v208, v209
		v_max_f32_e32 v196, v210, v211
		v_max_f32_e32 v197, v212, v213
		v_max_f32_e32 v32, v32, v33
		v_max_f32_e32 v33, v40, v41
		v_max_f32_e32 v40, v42, v43
		v_max_f32_e32 v41, v44, v45
		v_max_f32_e32 v42, v46, v47
		v_max_f32_e32 v43, v192, v193
		v_max_f32_e32 v44, v194, v195
		v_max_f32_e32 v45, v196, v197
		v_max_f32_e32 v32, v32, v33
		v_max_f32_e32 v33, v40, v41
		v_max_f32_e32 v40, v42, v43
		v_max_f32_e32 v41, v44, v45
		v_max_f32_e32 v32, v32, v33
		v_max_f32_e32 v33, v40, v41
		v_max_f32_e32 v32, v32, v33
		ds_bpermute_b32 v33, v15, v32
		ds_bpermute_b32 v40, v11, v32
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v42, v33, v40
		v_max_f32_e32 v32, v160, v161
		v_max_f32_e32 v33, v162, v163
		v_max_f32_e32 v40, v164, v165
		v_max_f32_e32 v41, v166, v167
		v_max_f32_e32 v43, v168, v169
		v_max_f32_e32 v44, v170, v171
		v_max_f32_e32 v45, v172, v173
		v_max_f32_e32 v46, v174, v175
		v_accvgpr_read_b32 v47, a224
		v_accvgpr_read_b32 v192, a225
		v_max_f32_e32 v47, v47, v192
		v_accvgpr_read_b32 v192, a226
		v_accvgpr_read_b32 v193, a227
		v_max_f32_e32 v192, v192, v193
		v_accvgpr_read_b32 v193, a228
		v_accvgpr_read_b32 v194, a229
		v_max_f32_e32 v193, v193, v194
		v_accvgpr_read_b32 v194, a230
		v_accvgpr_read_b32 v195, a231
		v_max_f32_e32 v194, v194, v195
		v_accvgpr_read_b32 v195, a232
		v_accvgpr_read_b32 v196, a233
		v_max_f32_e32 v195, v195, v196
		v_accvgpr_read_b32 v196, a234
		v_accvgpr_read_b32 v197, a235
		v_max_f32_e32 v196, v196, v197
		v_accvgpr_read_b32 v197, a236
		v_accvgpr_read_b32 v198, a237
		v_max_f32_e32 v197, v197, v198
		v_accvgpr_read_b32 v198, a238
		v_accvgpr_read_b32 v199, a239
		v_max_f32_e32 v198, v198, v199
		v_max_f32_e32 v199, v176, v177
		v_max_f32_e32 v200, v178, v179
		v_max_f32_e32 v201, v180, v181
		v_max_f32_e32 v202, v182, v183
		v_max_f32_e32 v203, v184, v185
		v_max_f32_e32 v204, v186, v187
		v_max_f32_e32 v205, v188, v189
		v_max_f32_e32 v206, v190, v191
		v_accvgpr_read_b32 v207, a208
		v_accvgpr_read_b32 v208, a209
		v_max_f32_e32 v207, v207, v208
		v_accvgpr_read_b32 v208, a210
		v_accvgpr_read_b32 v209, a211
		v_max_f32_e32 v208, v208, v209
		v_accvgpr_read_b32 v209, a212
		v_accvgpr_read_b32 v210, a213
		v_max_f32_e32 v209, v209, v210
		v_accvgpr_read_b32 v210, a214
		v_accvgpr_read_b32 v211, a215
		v_max_f32_e32 v210, v210, v211
		v_accvgpr_read_b32 v211, a216
		v_accvgpr_read_b32 v212, a217
		v_max_f32_e32 v211, v211, v212
		v_accvgpr_read_b32 v212, a218
		v_accvgpr_read_b32 v213, a219
		v_max_f32_e32 v212, v212, v213
		v_accvgpr_read_b32 v213, a220
		v_accvgpr_read_b32 v214, a221
		v_max_f32_e32 v213, v213, v214
		v_accvgpr_read_b32 v214, a222
		v_accvgpr_read_b32 v215, a223
		v_max_f32_e32 v214, v214, v215
		v_max_f32_e32 v32, v32, v33
		v_max_f32_e32 v33, v40, v41
		v_max_f32_e32 v40, v43, v44
		v_max_f32_e32 v41, v45, v46
		v_max_f32_e32 v43, v47, v192
		v_max_f32_e32 v44, v193, v194
		v_max_f32_e32 v45, v195, v196
		v_max_f32_e32 v46, v197, v198
		v_max_f32_e32 v47, v199, v200
		v_max_f32_e32 v192, v201, v202
		v_max_f32_e32 v193, v203, v204
		v_max_f32_e32 v194, v205, v206
		v_max_f32_e32 v195, v207, v208
		v_max_f32_e32 v196, v209, v210
		v_max_f32_e32 v197, v211, v212
		v_max_f32_e32 v198, v213, v214
		v_max_f32_e32 v32, v32, v33
		v_max_f32_e32 v33, v40, v41
		v_max_f32_e32 v40, v43, v44
		v_max_f32_e32 v41, v45, v46
		v_max_f32_e32 v43, v47, v192
		v_max_f32_e32 v44, v193, v194
		v_max_f32_e32 v45, v195, v196
		v_max_f32_e32 v46, v197, v198
		v_max_f32_e32 v32, v32, v33
		v_max_f32_e32 v33, v40, v41
		v_max_f32_e32 v40, v43, v44
		v_max_f32_e32 v41, v45, v46
		v_max_f32_e32 v32, v32, v33
		v_max_f32_e32 v33, v40, v41
		v_max_f32_e32 v32, v32, v33
		ds_bpermute_b32 v33, v15, v32
		ds_bpermute_b32 v40, v11, v32
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v43, v33, v40
		v_pk_mul_f32 v[32:33], v[42:43], v[12:13]
		v_max_f32_e32 v40, v20, v32
		v_max_f32_e32 v41, v19, v33
		v_pk_mul_f32 v[32:33], v[96:97], v[12:13]
		v_pk_mul_f32 v[42:43], v[98:99], v[12:13]
		v_pk_mul_f32 v[44:45], v[100:101], v[12:13]
		v_pk_mul_f32 v[46:47], v[102:103], v[12:13]
		v_pk_mul_f32 v[96:97], v[104:105], v[12:13]
		v_pk_mul_f32 v[98:99], v[106:107], v[12:13]
		v_pk_mul_f32 v[100:101], v[108:109], v[12:13]
		v_pk_mul_f32 v[102:103], v[110:111], v[12:13]
		v_pk_mul_f32 v[104:105], v[112:113], v[12:13]
		v_pk_mul_f32 v[106:107], v[114:115], v[12:13]
		v_pk_mul_f32 v[108:109], v[116:117], v[12:13]
		v_pk_mul_f32 v[110:111], v[118:119], v[12:13]
		v_pk_mul_f32 v[112:113], v[120:121], v[12:13]
		v_pk_mul_f32 v[114:115], v[122:123], v[12:13]
		v_pk_mul_f32 v[116:117], v[124:125], v[12:13]
		v_pk_mul_f32 v[118:119], v[126:127], v[12:13]
		v_pk_mul_f32 v[120:121], v[128:129], v[12:13]
		v_pk_mul_f32 v[122:123], v[130:131], v[12:13]
		v_pk_mul_f32 v[124:125], v[132:133], v[12:13]
		v_pk_mul_f32 v[126:127], v[134:135], v[12:13]
		v_pk_mul_f32 v[128:129], v[136:137], v[12:13]
		v_pk_mul_f32 v[130:131], v[138:139], v[12:13]
		v_pk_mul_f32 v[132:133], v[140:141], v[12:13]
		v_pk_mul_f32 v[134:135], v[142:143], v[12:13]
		v_pk_mul_f32 v[136:137], v[144:145], v[12:13]
		v_pk_mul_f32 v[138:139], v[146:147], v[12:13]
		v_pk_mul_f32 v[140:141], v[148:149], v[12:13]
		v_pk_mul_f32 v[142:143], v[150:151], v[12:13]
		v_pk_mul_f32 v[144:145], v[152:153], v[12:13]
		v_pk_mul_f32 v[146:147], v[154:155], v[12:13]
		v_pk_mul_f32 v[148:149], v[156:157], v[12:13]
		v_pk_mul_f32 v[150:151], v[158:159], v[12:13]
		v_pk_mul_f32 v[152:153], v[160:161], v[12:13]
		v_pk_mul_f32 v[154:155], v[162:163], v[12:13]
		v_pk_mul_f32 v[156:157], v[164:165], v[12:13]
		v_pk_mul_f32 v[158:159], v[166:167], v[12:13]
		v_pk_mul_f32 v[160:161], v[168:169], v[12:13]
		v_pk_mul_f32 v[162:163], v[170:171], v[12:13]
		v_pk_mul_f32 v[164:165], v[172:173], v[12:13]
		v_pk_mul_f32 v[166:167], v[174:175], v[12:13]
		v_accvgpr_read_b32 v168, a224
		v_accvgpr_read_b32 v169, a225
		v_pk_mul_f32 v[170:171], v[168:169], v[12:13]
		v_accvgpr_read_b32 v168, a226
		v_accvgpr_read_b32 v169, a227
		v_pk_mul_f32 v[172:173], v[168:169], v[12:13]
		v_accvgpr_read_b32 v168, a228
		v_accvgpr_read_b32 v169, a229
		v_pk_mul_f32 v[174:175], v[168:169], v[12:13]
		v_accvgpr_read_b32 v168, a230
		v_accvgpr_read_b32 v169, a231
		v_pk_mul_f32 v[192:193], v[168:169], v[12:13]
		v_accvgpr_read_b32 v168, a232
		v_accvgpr_read_b32 v169, a233
		v_pk_mul_f32 v[194:195], v[168:169], v[12:13]
		v_accvgpr_read_b32 v168, a234
		v_accvgpr_read_b32 v169, a235
		v_pk_mul_f32 v[196:197], v[168:169], v[12:13]
		v_accvgpr_read_b32 v168, a236
		v_accvgpr_read_b32 v169, a237
		v_pk_mul_f32 v[198:199], v[168:169], v[12:13]
		v_accvgpr_read_b32 v168, a238
		v_accvgpr_read_b32 v169, a239
		v_pk_mul_f32 v[200:201], v[168:169], v[12:13]
		v_pk_mul_f32 v[168:169], v[176:177], v[12:13]
		v_pk_mul_f32 v[176:177], v[178:179], v[12:13]
		v_pk_mul_f32 v[178:179], v[180:181], v[12:13]
		v_pk_mul_f32 v[180:181], v[182:183], v[12:13]
		v_pk_mul_f32 v[182:183], v[184:185], v[12:13]
		v_pk_mul_f32 v[184:185], v[186:187], v[12:13]
		v_pk_mul_f32 v[186:187], v[188:189], v[12:13]
		v_pk_mul_f32 v[188:189], v[190:191], v[12:13]
		v_accvgpr_read_b32 v190, a208
		v_accvgpr_read_b32 v191, a209
		v_pk_mul_f32 v[202:203], v[190:191], v[12:13]
		v_accvgpr_read_b32 v190, a210
		v_accvgpr_read_b32 v191, a211
		v_pk_mul_f32 v[204:205], v[190:191], v[12:13]
		v_accvgpr_read_b32 v190, a212
		v_accvgpr_read_b32 v191, a213
		v_pk_mul_f32 v[206:207], v[190:191], v[12:13]
		v_accvgpr_read_b32 v190, a214
		v_accvgpr_read_b32 v191, a215
		v_pk_mul_f32 v[208:209], v[190:191], v[12:13]
		v_accvgpr_read_b32 v190, a216
		v_accvgpr_read_b32 v191, a217
		v_pk_mul_f32 v[210:211], v[190:191], v[12:13]
		v_accvgpr_read_b32 v190, a218
		v_accvgpr_read_b32 v191, a219
		v_pk_mul_f32 v[212:213], v[190:191], v[12:13]
		v_accvgpr_read_b32 v190, a220
		v_accvgpr_read_b32 v191, a221
		v_pk_mul_f32 v[214:215], v[190:191], v[12:13]
		v_accvgpr_read_b32 v190, a222
		v_accvgpr_read_b32 v191, a223
		v_pk_mul_f32 v[216:217], v[190:191], v[12:13]
		v_sub_f32_e32 v32, v32, v40
		v_sub_f32_e32 v33, v33, v40
		v_sub_f32_e32 v42, v42, v40
		v_sub_f32_e32 v43, v43, v40
		v_sub_f32_e32 v44, v44, v40
		v_sub_f32_e32 v45, v45, v40
		v_sub_f32_e32 v46, v46, v40
		v_sub_f32_e32 v47, v47, v40
		v_sub_f32_e32 v96, v96, v40
		v_sub_f32_e32 v97, v97, v40
		v_sub_f32_e32 v98, v98, v40
		v_sub_f32_e32 v99, v99, v40
		v_sub_f32_e32 v100, v100, v40
		v_sub_f32_e32 v101, v101, v40
		v_sub_f32_e32 v102, v102, v40
		v_sub_f32_e32 v103, v103, v40
		v_sub_f32_e32 v104, v104, v40
		v_sub_f32_e32 v105, v105, v40
		v_sub_f32_e32 v106, v106, v40
		v_sub_f32_e32 v107, v107, v40
		v_sub_f32_e32 v108, v108, v40
		v_sub_f32_e32 v109, v109, v40
		v_sub_f32_e32 v110, v110, v40
		v_sub_f32_e32 v111, v111, v40
		v_sub_f32_e32 v112, v112, v40
		v_sub_f32_e32 v113, v113, v40
		v_sub_f32_e32 v114, v114, v40
		v_sub_f32_e32 v115, v115, v40
		v_sub_f32_e32 v116, v116, v40
		v_sub_f32_e32 v117, v117, v40
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
		v_sub_f32_e32 v138, v138, v40
		v_sub_f32_e32 v139, v139, v40
		v_sub_f32_e32 v140, v140, v40
		v_sub_f32_e32 v141, v141, v40
		v_sub_f32_e32 v142, v142, v40
		v_sub_f32_e32 v143, v143, v40
		v_sub_f32_e32 v144, v144, v40
		v_sub_f32_e32 v145, v145, v40
		v_sub_f32_e32 v146, v146, v40
		v_sub_f32_e32 v147, v147, v40
		v_sub_f32_e32 v148, v148, v40
		v_sub_f32_e32 v149, v149, v40
		v_sub_f32_e32 v150, v150, v40
		v_sub_f32_e32 v151, v151, v40
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
		v_sub_f32_e32 v170, v170, v41
		v_sub_f32_e32 v171, v171, v41
		v_sub_f32_e32 v172, v172, v41
		v_sub_f32_e32 v173, v173, v41
		v_sub_f32_e32 v174, v174, v41
		v_sub_f32_e32 v175, v175, v41
		v_sub_f32_e32 v190, v192, v41
		v_sub_f32_e32 v191, v193, v41
		v_sub_f32_e32 v192, v194, v41
		v_sub_f32_e32 v193, v195, v41
		v_sub_f32_e32 v194, v196, v41
		v_sub_f32_e32 v195, v197, v41
		v_sub_f32_e32 v196, v198, v41
		v_sub_f32_e32 v197, v199, v41
		v_sub_f32_e32 v198, v200, v41
		v_sub_f32_e32 v199, v201, v41
		v_sub_f32_e32 v168, v168, v41
		v_sub_f32_e32 v169, v169, v41
		v_sub_f32_e32 v176, v176, v41
		v_sub_f32_e32 v177, v177, v41
		v_sub_f32_e32 v178, v178, v41
		v_sub_f32_e32 v179, v179, v41
		v_sub_f32_e32 v180, v180, v41
		v_sub_f32_e32 v181, v181, v41
		v_sub_f32_e32 v182, v182, v41
		v_sub_f32_e32 v183, v183, v41
		v_sub_f32_e32 v184, v184, v41
		v_sub_f32_e32 v185, v185, v41
		v_sub_f32_e32 v186, v186, v41
		v_sub_f32_e32 v187, v187, v41
		v_sub_f32_e32 v188, v188, v41
		v_sub_f32_e32 v189, v189, v41
		v_sub_f32_e32 v200, v202, v41
		v_sub_f32_e32 v201, v203, v41
		v_sub_f32_e32 v202, v204, v41
		v_sub_f32_e32 v203, v205, v41
		v_sub_f32_e32 v204, v206, v41
		v_sub_f32_e32 v205, v207, v41
		v_sub_f32_e32 v206, v208, v41
		v_sub_f32_e32 v207, v209, v41
		v_sub_f32_e32 v208, v210, v41
		v_sub_f32_e32 v209, v211, v41
		v_sub_f32_e32 v210, v212, v41
		v_sub_f32_e32 v211, v213, v41
		v_sub_f32_e32 v212, v214, v41
		v_sub_f32_e32 v213, v215, v41
		v_sub_f32_e32 v214, v216, v41
		v_sub_f32_e32 v215, v217, v41
		v_exp_f32_e32 v32, v32
		s_nop 0
		v_accvgpr_write_b32 a80, v32
		v_exp_f32_e32 v32, v33
		s_nop 0
		v_accvgpr_write_b32 a82, v32
		v_exp_f32_e32 v32, v42
		s_nop 0
		v_accvgpr_write_b32 a81, v32
		v_exp_f32_e32 v32, v43
		s_nop 0
		v_accvgpr_write_b32 a83, v32
		v_exp_f32_e32 v42, v44
		v_exp_f32_e32 v216, v45
		v_exp_f32_e32 v43, v46
		v_exp_f32_e32 v217, v47
		v_exp_f32_e32 v44, v96
		v_exp_f32_e32 v46, v97
		v_exp_f32_e32 v45, v98
		v_exp_f32_e32 v47, v99
		v_exp_f32_e32 v96, v100
		v_exp_f32_e32 v98, v101
		v_exp_f32_e32 v97, v102
		v_exp_f32_e32 v99, v103
		v_exp_f32_e32 v100, v104
		v_exp_f32_e32 v102, v105
		v_exp_f32_e32 v101, v106
		v_exp_f32_e32 v103, v107
		v_exp_f32_e32 v104, v108
		v_exp_f32_e32 v106, v109
		v_exp_f32_e32 v105, v110
		v_exp_f32_e32 v107, v111
		v_exp_f32_e32 v108, v112
		v_exp_f32_e32 v110, v113
		v_exp_f32_e32 v109, v114
		v_exp_f32_e32 v111, v115
		v_exp_f32_e32 v112, v116
		v_exp_f32_e32 v114, v117
		v_exp_f32_e32 v113, v118
		v_exp_f32_e32 v115, v119
		v_exp_f32_e32 v116, v120
		v_exp_f32_e32 v118, v121
		v_exp_f32_e32 v117, v122
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
		v_exp_f32_e32 v144, v148
		v_exp_f32_e32 v146, v149
		v_exp_f32_e32 v145, v150
		v_exp_f32_e32 v147, v151
		v_exp_f32_e32 v32, v152
		s_nop 0
		v_accvgpr_write_b32 a85, v32
		v_exp_f32_e32 v149, v153
		v_exp_f32_e32 v150, v154
		v_exp_f32_e32 v152, v155
		v_exp_f32_e32 v151, v156
		v_exp_f32_e32 v153, v157
		v_exp_f32_e32 v154, v158
		v_exp_f32_e32 v156, v159
		v_exp_f32_e32 v155, v160
		v_exp_f32_e32 v157, v161
		v_exp_f32_e32 v158, v162
		v_exp_f32_e32 v160, v163
		v_exp_f32_e32 v159, v164
		v_exp_f32_e32 v161, v165
		v_exp_f32_e32 v162, v166
		v_exp_f32_e32 v164, v167
		v_exp_f32_e32 v163, v170
		v_exp_f32_e32 v165, v171
		v_exp_f32_e32 v166, v172
		v_exp_f32_e32 v170, v173
		v_exp_f32_e32 v167, v174
		v_exp_f32_e32 v171, v175
		v_exp_f32_e32 v172, v190
		v_exp_f32_e32 v174, v191
		v_exp_f32_e32 v173, v192
		v_exp_f32_e32 v175, v193
		v_exp_f32_e32 v190, v194
		v_exp_f32_e32 v192, v195
		v_exp_f32_e32 v191, v196
		v_exp_f32_e32 v193, v197
		v_exp_f32_e32 v194, v198
		v_exp_f32_e32 v196, v199
		v_exp_f32_e32 v195, v168
		v_exp_f32_e32 v197, v169
		v_exp_f32_e32 v168, v176
		v_exp_f32_e32 v198, v177
		v_exp_f32_e32 v169, v178
		v_exp_f32_e32 v199, v179
		v_exp_f32_e32 v176, v180
		v_exp_f32_e32 v178, v181
		v_exp_f32_e32 v177, v182
		v_exp_f32_e32 v179, v183
		v_exp_f32_e32 v180, v184
		v_exp_f32_e32 v182, v185
		v_exp_f32_e32 v181, v186
		v_exp_f32_e32 v183, v187
		v_exp_f32_e32 v184, v188
		v_exp_f32_e32 v186, v189
		v_exp_f32_e32 v185, v200
		v_exp_f32_e32 v187, v201
		v_exp_f32_e32 v188, v202
		v_exp_f32_e32 v200, v203
		v_exp_f32_e32 v189, v204
		v_exp_f32_e32 v201, v205
		v_exp_f32_e32 v202, v206
		v_exp_f32_e32 v204, v207
		v_exp_f32_e32 v203, v208
		v_exp_f32_e32 v205, v209
		v_exp_f32_e32 v206, v210
		v_exp_f32_e32 v208, v211
		v_exp_f32_e32 v207, v212
		v_exp_f32_e32 v209, v213
		v_exp_f32_e32 v32, v214
		s_nop 0
		v_accvgpr_write_b32 a86, v32
		v_exp_f32_e32 v210, v215
		v_accvgpr_read_b32 v32, a80
		v_accvgpr_read_b32 v33, a81
		v_accvgpr_read_b32 v212, a82
		v_accvgpr_read_b32 v213, a83
		v_pk_add_f32 v[214:215], v[32:33], v[212:213]
		v_pk_add_f32 v[32:33], v[42:43], v[216:217]
		v_pk_add_f32 v[212:213], v[44:45], v[46:47]
		v_accvgpr_write_b32 a88, v212
		v_accvgpr_write_b32 a89, v213
		v_pk_add_f32 v[212:213], v[96:97], v[98:99]
		v_accvgpr_write_b32 a90, v212
		v_accvgpr_write_b32 a91, v213
		v_pk_add_f32 v[212:213], v[100:101], v[102:103]
		v_accvgpr_write_b32 a92, v212
		v_accvgpr_write_b32 a93, v213
		v_pk_add_f32 v[212:213], v[104:105], v[106:107]
		v_accvgpr_write_b32 a94, v212
		v_accvgpr_write_b32 a95, v213
		v_pk_add_f32 v[212:213], v[108:109], v[110:111]
		v_accvgpr_write_b32 a96, v212
		v_accvgpr_write_b32 a97, v213
		v_pk_add_f32 v[212:213], v[112:113], v[114:115]
		v_accvgpr_write_b32 a98, v212
		v_accvgpr_write_b32 a99, v213
		v_pk_add_f32 v[212:213], v[116:117], v[118:119]
		v_accvgpr_write_b32 a100, v212
		v_accvgpr_write_b32 a101, v213
		v_pk_add_f32 v[212:213], v[120:121], v[122:123]
		v_accvgpr_write_b32 a102, v212
		v_accvgpr_write_b32 a103, v213
		v_pk_add_f32 v[212:213], v[124:125], v[126:127]
		v_accvgpr_write_b32 a104, v212
		v_accvgpr_write_b32 a105, v213
		v_pk_add_f32 v[212:213], v[128:129], v[130:131]
		v_accvgpr_write_b32 a106, v212
		v_accvgpr_write_b32 a107, v213
		v_pk_add_f32 v[212:213], v[132:133], v[134:135]
		v_accvgpr_write_b32 a108, v212
		v_accvgpr_write_b32 a109, v213
		v_pk_add_f32 v[212:213], v[136:137], v[138:139]
		v_accvgpr_write_b32 a110, v212
		v_accvgpr_write_b32 a111, v213
		v_pk_add_f32 v[212:213], v[140:141], v[142:143]
		v_accvgpr_write_b32 a112, v212
		v_accvgpr_write_b32 a113, v213
		v_pk_add_f32 v[212:213], v[144:145], v[146:147]
		v_accvgpr_write_b32 a114, v212
		v_accvgpr_write_b32 a115, v213
		v_mov_b32_e32 v148, v215
		v_accvgpr_write_b32 a116, v148
		v_accvgpr_write_b32 a117, v33
		v_mov_b32_e32 v212, v214
		v_mov_b32_e32 v213, v32
		v_accvgpr_read_b32 v32, a116
		v_accvgpr_read_b32 v33, a117
		v_pk_add_f32 v[32:33], v[212:213], v[32:33]
		v_accvgpr_write_b32 a116, v32
		v_accvgpr_write_b32 a117, v33
		v_accvgpr_read_b32 v32, a89
		v_mov_b32_e32 v212, v32
		v_accvgpr_read_b32 v32, a91
		v_mov_b32_e32 v213, v32
		v_accvgpr_read_b32 v32, a88
		v_mov_b32_e32 v214, v32
		v_accvgpr_read_b32 v32, a90
		v_mov_b32_e32 v215, v32
		v_pk_add_f32 v[32:33], v[214:215], v[212:213]
		v_accvgpr_write_b32 a88, v32
		v_accvgpr_write_b32 a89, v33
		v_accvgpr_read_b32 v32, a93
		v_mov_b32_e32 v212, v32
		v_accvgpr_read_b32 v32, a95
		v_mov_b32_e32 v213, v32
		v_accvgpr_read_b32 v32, a92
		v_mov_b32_e32 v214, v32
		v_accvgpr_read_b32 v32, a94
		v_mov_b32_e32 v215, v32
		v_pk_add_f32 v[32:33], v[214:215], v[212:213]
		v_accvgpr_write_b32 a90, v32
		v_accvgpr_write_b32 a91, v33
		v_accvgpr_read_b32 v32, a97
		v_mov_b32_e32 v212, v32
		v_accvgpr_read_b32 v32, a99
		v_mov_b32_e32 v213, v32
		v_accvgpr_read_b32 v32, a96
		v_mov_b32_e32 v214, v32
		v_accvgpr_read_b32 v32, a98
		v_mov_b32_e32 v215, v32
		v_pk_add_f32 v[32:33], v[214:215], v[212:213]
		v_accvgpr_write_b32 a92, v32
		v_accvgpr_write_b32 a93, v33
		v_accvgpr_read_b32 v32, a101
		v_mov_b32_e32 v212, v32
		v_accvgpr_read_b32 v32, a103
		v_mov_b32_e32 v213, v32
		v_accvgpr_read_b32 v32, a100
		v_mov_b32_e32 v214, v32
		v_accvgpr_read_b32 v32, a102
		v_mov_b32_e32 v215, v32
		v_pk_add_f32 v[32:33], v[214:215], v[212:213]
		v_accvgpr_write_b32 a94, v32
		v_accvgpr_write_b32 a95, v33
		v_accvgpr_read_b32 v32, a105
		v_mov_b32_e32 v212, v32
		v_accvgpr_read_b32 v32, a107
		v_mov_b32_e32 v213, v32
		v_accvgpr_read_b32 v32, a104
		v_mov_b32_e32 v214, v32
		v_accvgpr_read_b32 v32, a106
		v_mov_b32_e32 v215, v32
		v_pk_add_f32 v[32:33], v[214:215], v[212:213]
		v_accvgpr_write_b32 a96, v32
		v_accvgpr_write_b32 a97, v33
		v_accvgpr_read_b32 v32, a109
		v_mov_b32_e32 v212, v32
		v_accvgpr_read_b32 v32, a111
		v_mov_b32_e32 v213, v32
		v_accvgpr_read_b32 v32, a108
		v_mov_b32_e32 v214, v32
		v_accvgpr_read_b32 v32, a110
		v_mov_b32_e32 v215, v32
		v_pk_add_f32 v[32:33], v[214:215], v[212:213]
		v_accvgpr_write_b32 a98, v32
		v_accvgpr_write_b32 a99, v33
		v_accvgpr_read_b32 v32, a113
		v_mov_b32_e32 v212, v32
		v_accvgpr_read_b32 v32, a115
		v_mov_b32_e32 v213, v32
		v_accvgpr_read_b32 v32, a112
		v_mov_b32_e32 v214, v32
		v_accvgpr_read_b32 v32, a114
		v_mov_b32_e32 v215, v32
		v_pk_add_f32 v[32:33], v[214:215], v[212:213]
		v_accvgpr_write_b32 a100, v32
		v_accvgpr_write_b32 a101, v33
		v_accvgpr_read_b32 v32, a117
		v_mov_b32_e32 v212, v32
		v_accvgpr_read_b32 v32, a89
		v_mov_b32_e32 v213, v32
		v_accvgpr_read_b32 v32, a116
		v_mov_b32_e32 v214, v32
		v_accvgpr_read_b32 v32, a88
		v_mov_b32_e32 v215, v32
		v_pk_add_f32 v[32:33], v[214:215], v[212:213]
		v_accvgpr_write_b32 a88, v32
		v_accvgpr_write_b32 a89, v33
		v_accvgpr_read_b32 v32, a91
		v_mov_b32_e32 v212, v32
		v_accvgpr_read_b32 v32, a93
		v_mov_b32_e32 v213, v32
		v_accvgpr_read_b32 v32, a90
		v_mov_b32_e32 v214, v32
		v_accvgpr_read_b32 v32, a92
		v_mov_b32_e32 v215, v32
		v_pk_add_f32 v[32:33], v[214:215], v[212:213]
		v_accvgpr_write_b32 a90, v32
		v_accvgpr_write_b32 a91, v33
		v_accvgpr_read_b32 v32, a95
		v_mov_b32_e32 v212, v32
		v_accvgpr_read_b32 v32, a97
		v_mov_b32_e32 v213, v32
		v_accvgpr_read_b32 v32, a94
		v_mov_b32_e32 v214, v32
		v_accvgpr_read_b32 v32, a96
		v_mov_b32_e32 v215, v32
		v_pk_add_f32 v[32:33], v[214:215], v[212:213]
		v_accvgpr_write_b32 a92, v32
		v_accvgpr_write_b32 a93, v33
		v_accvgpr_read_b32 v32, a99
		v_mov_b32_e32 v212, v32
		v_accvgpr_read_b32 v32, a101
		v_mov_b32_e32 v213, v32
		v_accvgpr_read_b32 v32, a98
		v_mov_b32_e32 v214, v32
		v_accvgpr_read_b32 v32, a100
		v_mov_b32_e32 v215, v32
		v_pk_add_f32 v[32:33], v[214:215], v[212:213]
		v_accvgpr_write_b32 a94, v32
		v_accvgpr_write_b32 a95, v33
		v_accvgpr_read_b32 v32, a89
		v_mov_b32_e32 v212, v32
		v_accvgpr_read_b32 v32, a91
		v_mov_b32_e32 v213, v32
		v_accvgpr_read_b32 v32, a88
		v_mov_b32_e32 v214, v32
		v_accvgpr_read_b32 v32, a90
		v_mov_b32_e32 v215, v32
		v_pk_add_f32 v[32:33], v[214:215], v[212:213]
		v_accvgpr_write_b32 a88, v32
		v_accvgpr_write_b32 a89, v33
		v_accvgpr_read_b32 v32, a93
		v_mov_b32_e32 v212, v32
		v_accvgpr_read_b32 v32, a95
		v_mov_b32_e32 v213, v32
		v_accvgpr_read_b32 v32, a92
		v_mov_b32_e32 v214, v32
		v_accvgpr_read_b32 v32, a94
		v_mov_b32_e32 v215, v32
		v_pk_add_f32 v[32:33], v[214:215], v[212:213]
		v_accvgpr_read_b32 v148, a89
		v_mov_b32_e32 v212, v148
		v_mov_b32_e32 v213, v33
		v_accvgpr_read_b32 v33, a88
		v_mov_b32_e32 v214, v33
		v_mov_b32_e32 v215, v32
		v_pk_add_f32 v[32:33], v[214:215], v[212:213]
		v_add_f32_e32 v32, v32, v33
		ds_bpermute_b32 v33, v15, v32
		s_waitcnt lgkmcnt(0)
		v_accvgpr_write_b32 a84, v33
		ds_bpermute_b32 v148, v11, v32
		v_accvgpr_read_b32 v32, a84
		v_accvgpr_read_b32 v33, a85
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[32:33], v[32:33], v[148:149]
		v_accvgpr_write_b32 a88, v32
		v_accvgpr_write_b32 a89, v33
		v_pk_add_f32 v[32:33], v[150:151], v[152:153]
		v_pk_add_f32 v[212:213], v[154:155], v[156:157]
		v_accvgpr_write_b32 a90, v212
		v_accvgpr_write_b32 a91, v213
		v_pk_add_f32 v[212:213], v[158:159], v[160:161]
		v_accvgpr_write_b32 a92, v212
		v_accvgpr_write_b32 a93, v213
		v_pk_add_f32 v[212:213], v[162:163], v[164:165]
		v_accvgpr_write_b32 a94, v212
		v_accvgpr_write_b32 a95, v213
		v_pk_add_f32 v[212:213], v[166:167], v[170:171]
		v_accvgpr_write_b32 a96, v212
		v_accvgpr_write_b32 a97, v213
		v_pk_add_f32 v[212:213], v[172:173], v[174:175]
		v_accvgpr_write_b32 a98, v212
		v_accvgpr_write_b32 a99, v213
		v_pk_add_f32 v[212:213], v[190:191], v[192:193]
		v_accvgpr_write_b32 a100, v212
		v_accvgpr_write_b32 a101, v213
		v_pk_add_f32 v[212:213], v[194:195], v[196:197]
		v_accvgpr_write_b32 a102, v212
		v_accvgpr_write_b32 a103, v213
		v_pk_add_f32 v[212:213], v[168:169], v[198:199]
		v_accvgpr_write_b32 a104, v212
		v_accvgpr_write_b32 a105, v213
		v_pk_add_f32 v[212:213], v[176:177], v[178:179]
		v_accvgpr_write_b32 a106, v212
		v_accvgpr_write_b32 a107, v213
		v_pk_add_f32 v[212:213], v[180:181], v[182:183]
		v_accvgpr_write_b32 a108, v212
		v_accvgpr_write_b32 a109, v213
		v_pk_add_f32 v[212:213], v[184:185], v[186:187]
		v_accvgpr_write_b32 a110, v212
		v_accvgpr_write_b32 a111, v213
		v_pk_add_f32 v[212:213], v[188:189], v[200:201]
		v_accvgpr_write_b32 a112, v212
		v_accvgpr_write_b32 a113, v213
		v_pk_add_f32 v[212:213], v[202:203], v[204:205]
		v_accvgpr_write_b32 a114, v212
		v_accvgpr_write_b32 a115, v213
		v_pk_add_f32 v[212:213], v[206:207], v[208:209]
		v_accvgpr_write_b32 a116, v212
		v_accvgpr_write_b32 a117, v213
		v_mov_b32_e32 v211, v32
		v_accvgpr_read_b32 v32, a89
		v_accvgpr_write_b32 a87, v32
		v_accvgpr_read_b32 v212, a86
		v_accvgpr_read_b32 v213, a87
		v_pk_add_f32 v[212:213], v[212:213], v[210:211]
		v_accvgpr_write_b32 a118, v212
		v_accvgpr_write_b32 a119, v213
		v_mov_b32_e32 v32, v33
		v_accvgpr_write_b32 a120, v32
		v_accvgpr_read_b32 v32, a92
		v_accvgpr_write_b32 a121, v32
		v_accvgpr_read_b32 v32, a90
		v_accvgpr_read_b32 v33, a91
		v_accvgpr_read_b32 v212, a120
		v_accvgpr_read_b32 v213, a121
		v_pk_add_f32 v[32:33], v[212:213], v[32:33]
		v_accvgpr_write_b32 a90, v32
		v_accvgpr_write_b32 a91, v33
		v_accvgpr_read_b32 v32, a93
		v_mov_b32_e32 v212, v32
		v_accvgpr_read_b32 v32, a96
		v_mov_b32_e32 v213, v32
		v_accvgpr_read_b32 v32, a94
		v_accvgpr_read_b32 v33, a95
		v_pk_add_f32 v[32:33], v[212:213], v[32:33]
		v_accvgpr_write_b32 a92, v32
		v_accvgpr_write_b32 a93, v33
		v_accvgpr_read_b32 v32, a97
		v_mov_b32_e32 v212, v32
		v_accvgpr_read_b32 v32, a100
		v_mov_b32_e32 v213, v32
		v_accvgpr_read_b32 v32, a98
		v_accvgpr_read_b32 v33, a99
		v_pk_add_f32 v[32:33], v[212:213], v[32:33]
		v_accvgpr_write_b32 a94, v32
		v_accvgpr_write_b32 a95, v33
		v_accvgpr_read_b32 v32, a101
		v_mov_b32_e32 v212, v32
		v_accvgpr_read_b32 v32, a104
		v_mov_b32_e32 v213, v32
		v_accvgpr_read_b32 v32, a102
		v_accvgpr_read_b32 v33, a103
		v_pk_add_f32 v[32:33], v[212:213], v[32:33]
		v_accvgpr_write_b32 a96, v32
		v_accvgpr_write_b32 a97, v33
		v_accvgpr_read_b32 v32, a105
		v_mov_b32_e32 v212, v32
		v_accvgpr_read_b32 v32, a108
		v_mov_b32_e32 v213, v32
		v_accvgpr_read_b32 v32, a106
		v_accvgpr_read_b32 v33, a107
		v_pk_add_f32 v[32:33], v[212:213], v[32:33]
		v_accvgpr_write_b32 a98, v32
		v_accvgpr_write_b32 a99, v33
		v_accvgpr_read_b32 v32, a109
		v_mov_b32_e32 v212, v32
		v_accvgpr_read_b32 v32, a112
		v_mov_b32_e32 v213, v32
		v_accvgpr_read_b32 v32, a110
		v_accvgpr_read_b32 v33, a111
		v_pk_add_f32 v[32:33], v[212:213], v[32:33]
		v_accvgpr_write_b32 a100, v32
		v_accvgpr_write_b32 a101, v33
		v_accvgpr_read_b32 v32, a113
		v_mov_b32_e32 v212, v32
		v_accvgpr_read_b32 v32, a116
		v_mov_b32_e32 v213, v32
		v_accvgpr_read_b32 v32, a114
		v_accvgpr_read_b32 v33, a115
		v_pk_add_f32 v[32:33], v[212:213], v[32:33]
		v_accvgpr_write_b32 a102, v32
		v_accvgpr_write_b32 a103, v33
		v_accvgpr_read_b32 v32, a117
		v_mov_b32_e32 v212, v32
		v_accvgpr_read_b32 v32, a90
		v_mov_b32_e32 v213, v32
		v_accvgpr_read_b32 v32, a118
		v_accvgpr_read_b32 v33, a119
		v_pk_add_f32 v[32:33], v[212:213], v[32:33]
		v_accvgpr_write_b32 a104, v32
		v_accvgpr_write_b32 a105, v33
		v_accvgpr_read_b32 v32, a91
		v_mov_b32_e32 v212, v32
		v_accvgpr_read_b32 v32, a94
		v_mov_b32_e32 v213, v32
		v_accvgpr_read_b32 v32, a92
		v_accvgpr_read_b32 v33, a93
		v_pk_add_f32 v[32:33], v[212:213], v[32:33]
		v_accvgpr_write_b32 a90, v32
		v_accvgpr_write_b32 a91, v33
		v_accvgpr_read_b32 v32, a95
		v_mov_b32_e32 v212, v32
		v_accvgpr_read_b32 v32, a98
		v_mov_b32_e32 v213, v32
		v_accvgpr_read_b32 v32, a96
		v_accvgpr_read_b32 v33, a97
		v_pk_add_f32 v[32:33], v[212:213], v[32:33]
		v_accvgpr_write_b32 a92, v32
		v_accvgpr_write_b32 a93, v33
		v_accvgpr_read_b32 v32, a99
		v_mov_b32_e32 v212, v32
		v_accvgpr_read_b32 v32, a102
		v_mov_b32_e32 v213, v32
		v_accvgpr_read_b32 v32, a100
		v_accvgpr_read_b32 v33, a101
		v_pk_add_f32 v[32:33], v[212:213], v[32:33]
		v_accvgpr_write_b32 a94, v32
		v_accvgpr_write_b32 a95, v33
		v_accvgpr_read_b32 v32, a103
		v_mov_b32_e32 v212, v32
		v_accvgpr_read_b32 v32, a90
		v_mov_b32_e32 v213, v32
		v_accvgpr_read_b32 v32, a104
		v_accvgpr_read_b32 v33, a105
		v_pk_add_f32 v[32:33], v[212:213], v[32:33]
		v_accvgpr_write_b32 a96, v32
		v_accvgpr_write_b32 a97, v33
		v_accvgpr_read_b32 v32, a91
		v_accvgpr_write_b32 a90, v32
		v_accvgpr_read_b32 v32, a94
		v_accvgpr_write_b32 a91, v32
		v_accvgpr_read_b32 v32, a92
		v_accvgpr_read_b32 v33, a93
		v_accvgpr_read_b32 v212, a90
		v_accvgpr_read_b32 v213, a91
		v_pk_add_f32 v[32:33], v[212:213], v[32:33]
		v_accvgpr_write_b32 a90, v32
		v_accvgpr_write_b32 a91, v33
		v_accvgpr_read_b32 v32, a95
		v_accvgpr_write_b32 a92, v32
		v_accvgpr_read_b32 v32, a90
		v_accvgpr_write_b32 a93, v32
		v_accvgpr_read_b32 v32, a96
		v_accvgpr_read_b32 v33, a97
		v_accvgpr_read_b32 v212, a92
		v_accvgpr_read_b32 v213, a93
		v_pk_add_f32 v[214:215], v[212:213], v[32:33]
		v_accvgpr_read_b32 v32, a91
		v_add_f32_e32 v32, v32, v214
		v_add_f32_e32 v32, v215, v32
		ds_bpermute_b32 v33, v15, v32
		ds_bpermute_b32 v148, v11, v32
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v32, v33, v148
		v_accvgpr_write_b32 a91, v32
		v_sub_f32_e32 v20, v20, v40
		v_sub_f32_e32 v19, v19, v41
		v_exp_f32_e32 v32, v20
		v_exp_f32_e32 v212, v19
		v_mov_b32_e32 v33, v32
		v_pk_mul_f32 v[48:49], v[48:49], v[32:33]
		v_pk_mul_f32 v[50:51], v[50:51], v[32:33]
		v_pk_mul_f32 v[52:53], v[52:53], v[32:33]
		v_pk_mul_f32 v[54:55], v[54:55], v[32:33]
		v_pk_mul_f32 v[56:57], v[56:57], v[32:33]
		v_pk_mul_f32 v[58:59], v[58:59], v[32:33]
		v_pk_mul_f32 v[60:61], v[60:61], v[32:33]
		v_pk_mul_f32 v[62:63], v[62:63], v[32:33]
		v_pk_mul_f32 v[64:65], v[64:65], v[32:33]
		v_pk_mul_f32 v[66:67], v[66:67], v[32:33]
		v_pk_mul_f32 v[68:69], v[68:69], v[32:33]
		v_pk_mul_f32 v[70:71], v[70:71], v[32:33]
		v_pk_mul_f32 v[72:73], v[72:73], v[32:33]
		v_pk_mul_f32 v[74:75], v[74:75], v[32:33]
		v_pk_mul_f32 v[76:77], v[76:77], v[32:33]
		v_pk_mul_f32 v[78:79], v[78:79], v[32:33]
		v_mov_b32_e32 v213, v212
		v_pk_mul_f32 v[80:81], v[80:81], v[212:213]
		v_pk_mul_f32 v[82:83], v[82:83], v[212:213]
		v_pk_mul_f32 v[84:85], v[84:85], v[212:213]
		v_pk_mul_f32 v[86:87], v[86:87], v[212:213]
		v_pk_mul_f32 v[88:89], v[88:89], v[212:213]
		v_pk_mul_f32 v[90:91], v[90:91], v[212:213]
		v_pk_mul_f32 v[92:93], v[92:93], v[212:213]
		v_pk_mul_f32 v[94:95], v[94:95], v[212:213]
		v_accvgpr_read_b32 v214, a64
		v_accvgpr_read_b32 v215, a65
		v_pk_mul_f32 v[214:215], v[214:215], v[212:213]
		v_accvgpr_write_b32 a64, v214
		v_accvgpr_write_b32 a65, v215
		v_accvgpr_read_b32 v214, a66
		v_accvgpr_read_b32 v215, a67
		v_pk_mul_f32 v[214:215], v[214:215], v[212:213]
		v_accvgpr_write_b32 a66, v214
		v_accvgpr_write_b32 a67, v215
		v_accvgpr_read_b32 v214, a68
		v_accvgpr_read_b32 v215, a69
		v_pk_mul_f32 v[214:215], v[214:215], v[212:213]
		v_accvgpr_write_b32 a68, v214
		v_accvgpr_write_b32 a69, v215
		v_accvgpr_read_b32 v214, a70
		v_accvgpr_read_b32 v215, a71
		v_pk_mul_f32 v[214:215], v[214:215], v[212:213]
		v_accvgpr_write_b32 a70, v214
		v_accvgpr_write_b32 a71, v215
		v_accvgpr_read_b32 v214, a72
		v_accvgpr_read_b32 v215, a73
		v_pk_mul_f32 v[214:215], v[214:215], v[212:213]
		v_accvgpr_write_b32 a72, v214
		v_accvgpr_write_b32 a73, v215
		v_accvgpr_read_b32 v214, a74
		v_accvgpr_read_b32 v215, a75
		v_pk_mul_f32 v[214:215], v[214:215], v[212:213]
		v_accvgpr_write_b32 a74, v214
		v_accvgpr_write_b32 a75, v215
		v_accvgpr_read_b32 v214, a76
		v_accvgpr_read_b32 v215, a77
		v_pk_mul_f32 v[214:215], v[214:215], v[212:213]
		v_accvgpr_write_b32 a76, v214
		v_accvgpr_write_b32 a77, v215
		v_accvgpr_read_b32 v214, a78
		v_accvgpr_read_b32 v215, a79
		v_pk_mul_f32 v[214:215], v[214:215], v[212:213]
		v_accvgpr_write_b32 a78, v214
		v_accvgpr_write_b32 a79, v215
		v_accvgpr_read_b32 v19, a88
		v_accvgpr_write_b32 a90, v19
		v_mov_b32_e32 v214, v32
		v_mov_b32_e32 v215, v212
		v_accvgpr_read_b32 v32, a62
		v_accvgpr_read_b32 v33, a63
		v_accvgpr_read_b32 v212, a90
		v_accvgpr_read_b32 v213, a91
		v_pk_fma_f32 v[32:33], v[32:33], v[214:215], v[212:213]
		v_accvgpr_read_b32 v19, a80
		v_accvgpr_read_b32 v20, a82
		v_cvt_pk_bf16_f32 v212, v19, v20
		v_accvgpr_read_b32 v19, a81
		v_accvgpr_read_b32 v20, a83
		v_cvt_pk_bf16_f32 v213, v19, v20
		v_cvt_pk_bf16_f32 v214, v42, v216
		v_cvt_pk_bf16_f32 v215, v43, v217
		v_cvt_pk_bf16_f32 v216, v44, v46
		v_cvt_pk_bf16_f32 v217, v45, v47
		v_cvt_pk_bf16_f32 v218, v96, v98
		v_cvt_pk_bf16_f32 v219, v97, v99
		v_cvt_pk_bf16_f32 v44, v100, v102
		v_cvt_pk_bf16_f32 v45, v101, v103
		v_cvt_pk_bf16_f32 v46, v104, v106
		v_cvt_pk_bf16_f32 v47, v105, v107
		v_cvt_pk_bf16_f32 v96, v108, v110
		v_cvt_pk_bf16_f32 v97, v109, v111
		v_cvt_pk_bf16_f32 v98, v112, v114
		v_cvt_pk_bf16_f32 v99, v113, v115
		v_cvt_pk_bf16_f32 v100, v116, v118
		v_cvt_pk_bf16_f32 v101, v117, v119
		v_cvt_pk_bf16_f32 v102, v120, v122
		v_cvt_pk_bf16_f32 v103, v121, v123
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
		v_accvgpr_read_b32 v19, a85
		v_cvt_pk_bf16_f32 v116, v19, v149
		v_cvt_pk_bf16_f32 v117, v150, v152
		v_cvt_pk_bf16_f32 v118, v151, v153
		v_cvt_pk_bf16_f32 v119, v154, v156
		v_cvt_pk_bf16_f32 v120, v155, v157
		v_cvt_pk_bf16_f32 v121, v158, v160
		v_cvt_pk_bf16_f32 v122, v159, v161
		v_cvt_pk_bf16_f32 v123, v162, v164
		v_cvt_pk_bf16_f32 v124, v163, v165
		v_cvt_pk_bf16_f32 v125, v166, v170
		v_cvt_pk_bf16_f32 v126, v167, v171
		v_cvt_pk_bf16_f32 v127, v172, v174
		v_cvt_pk_bf16_f32 v128, v173, v175
		v_cvt_pk_bf16_f32 v129, v190, v192
		v_cvt_pk_bf16_f32 v130, v191, v193
		v_cvt_pk_bf16_f32 v131, v194, v196
		v_cvt_pk_bf16_f32 v132, v195, v197
		v_cvt_pk_bf16_f32 v133, v168, v198
		v_cvt_pk_bf16_f32 v134, v169, v199
		v_cvt_pk_bf16_f32 v135, v176, v178
		v_cvt_pk_bf16_f32 v136, v177, v179
		v_cvt_pk_bf16_f32 v137, v180, v182
		v_cvt_pk_bf16_f32 v138, v181, v183
		v_cvt_pk_bf16_f32 v139, v184, v186
		v_cvt_pk_bf16_f32 v140, v185, v187
		v_cvt_pk_bf16_f32 v141, v188, v200
		v_cvt_pk_bf16_f32 v142, v189, v201
		v_cvt_pk_bf16_f32 v143, v202, v204
		v_cvt_pk_bf16_f32 v144, v203, v205
		v_cvt_pk_bf16_f32 v145, v206, v208
		v_cvt_pk_bf16_f32 v146, v207, v209
		v_accvgpr_read_b32 v19, a86
		v_cvt_pk_bf16_f32 v147, v19, v210
		v_permlane32_swap_b32_e32 v212, v214
		v_permlane32_swap_b32_e32 v213, v215
		v_permlane32_swap_b32_e32 v216, v218
		v_permlane32_swap_b32_e32 v217, v219
		v_permlane32_swap_b32_e32 v44, v46
		v_permlane32_swap_b32_e32 v45, v47
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
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_mfma_f32_32x32x16_bf16 v[48:63], a[140:143], v[212:215], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[172:175], v[212:215], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[172:175], v[116:119], a[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[140:143], v[116:119], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[144:147], v[216:219], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[176:179], v[216:219], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[176:179], v[120:123], a[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[120:123], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[148:151], v[44:47], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[180:183], v[44:47], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[180:183], v[124:127], a[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[148:151], v[124:127], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[152:155], v[96:99], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[184:187], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[184:187], v[128:131], a[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], v[128:131], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[156:159], v[100:103], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[188:191], v[100:103], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[188:191], v[132:135], a[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], v[132:135], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[160:163], v[104:107], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[104:107], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[192:195], v[136:139], a[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[160:163], v[136:139], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[164:167], v[108:111], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[108:111], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[196:199], v[140:143], a[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[164:167], v[140:143], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[168:171], v[112:115], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[112:115], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[200:203], v[144:147], a[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[168:171], v[144:147], v[80:95]
		s_cmp_lt_i32 s45, s46
		s_mov_b32 s40, s45
		v_mov_b32_e32 v20, v40
		v_mov_b32_e32 v19, v41
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_1
.L_attn_fwd_persistent.loop_exit_1:
		s_mul_i32 s26, s26, 0x80
		v_readfirstlane_b32 s40, v2
		s_nop 1
		v_add_u32_e32 v10, s40, v10
		v_accvgpr_write_b32 a62, v10
		v_accvgpr_read_b32 v10, a62
		v_add_u32_e32 v10, s21, v10
		v_readfirstlane_b32 s40, v2
		s_nop 1
		v_add_u32_e32 v6, s40, v6
		v_accvgpr_write_b32 a63, v6
		v_accvgpr_read_b32 v6, a63
		v_add_u32_e32 v6, s21, v6
		v_xor_b32_e32 v11, 1, v17
		v_xor_b32_e32 v12, 2, v17
		v_xor_b32_e32 v13, 3, v17
		v_xor_b32_e32 v15, 8, v17
		v_xor_b32_e32 v21, 9, v17
		v_xor_b32_e32 v38, 10, v17
		v_xor_b32_e32 v40, 11, v17
		v_xor_b32_e32 v41, 16, v17
		v_xor_b32_e32 v42, 17, v17
		v_xor_b32_e32 v43, 18, v17
		v_xor_b32_e32 v44, 19, v17
		v_xor_b32_e32 v45, 24, v17
		v_xor_b32_e32 v46, 25, v17
		v_xor_b32_e32 v47, 26, v17
		v_xor_b32_e32 v96, 27, v17
		v_xor_b32_e32 v97, 32, v17
		v_xor_b32_e32 v98, 33, v17
		v_xor_b32_e32 v99, 34, v17
		v_xor_b32_e32 v100, 35, v17
		v_xor_b32_e32 v101, 40, v17
		v_xor_b32_e32 v102, 41, v17
		v_xor_b32_e32 v103, 42, v17
		v_xor_b32_e32 v104, 43, v17
		v_xor_b32_e32 v105, 48, v17
		v_xor_b32_e32 v106, 49, v17
		v_xor_b32_e32 v107, 50, v17
		v_xor_b32_e32 v108, 51, v17
		v_xor_b32_e32 v109, 56, v17
		v_xor_b32_e32 v110, 57, v17
		v_xor_b32_e32 v111, 58, v17
		v_xor_b32_e32 v112, 59, v17
		v_xor_b32_e32 v113, 64, v17
		v_xor_b32_e32 v114, 0x41, v17
		v_xor_b32_e32 v115, 0x42, v17
		v_xor_b32_e32 v116, 0x43, v17
		v_xor_b32_e32 v117, 0x48, v17
		v_xor_b32_e32 v118, 0x49, v17
		v_xor_b32_e32 v119, 0x4a, v17
		v_xor_b32_e32 v120, 0x4b, v17
		v_xor_b32_e32 v121, 0x50, v17
		v_xor_b32_e32 v122, 0x51, v17
		v_xor_b32_e32 v123, 0x52, v17
		v_xor_b32_e32 v124, 0x53, v17
		v_xor_b32_e32 v125, 0x5a, v17
		v_xor_b32_e32 v126, 0x5b, v17
		v_xor_b32_e32 v127, 0x62, v17
		v_xor_b32_e32 v128, 0x63, v17
		v_xor_b32_e32 v129, 0x6a, v17
		v_xor_b32_e32 v130, 0x6b, v17
		v_xor_b32_e32 v131, 0x72, v17
		v_xor_b32_e32 v132, 0x73, v17
		v_xor_b32_e32 v133, 0x7a, v17
		v_xor_b32_e32 v134, 0x7b, v17
		v_lshl_add_u32 v30, v31, 4, v30
		v_add3_u32 v30, v30, v35, v36
		v_add3_u32 v30, v30, v37, v34
		v_add3_u32 v25, v25, v26, v39
		v_lshl_add_u32 v23, v23, 3, v25
		v_mov_b32_e32 v25, 0xff800000
		s_cmp_lt_i32 s46, s26
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_2
.L_attn_fwd_persistent.loop_head_2:
		s_mov_b32 m0, s17
		s_nop 0
		ds_write_addtid_b32 v20 offset:12288
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s21, s46, 0x80
		s_cmp_lt_i32 s46, 0
		s_cselect_b32 s40, s27, 0
		s_add_i32 s40, s46, s40
		s_ashr_i32 s40, s40, 7
		s_cmp_lt_i32 s40, 0
		s_cselect_b32 s42, s16, 0
		s_add_i32 s42, s40, s42
		s_ashr_i32 s42, s42, 1
		s_lshl_b32 s42, s42, 1
		s_xor_b32 s42, s42, -1
		s_add_i32 s42, s42, 1
		s_add_i32 s42, s40, s42
		s_add_i32 s40, s40, 1
		s_cmp_lt_i32 s40, 0
		s_cselect_b32 s43, s16, 0
		s_add_i32 s43, s40, s43
		s_ashr_i32 s43, s43, 1
		s_lshl_b32 s43, s43, 1
		s_xor_b32 s43, s43, -1
		s_add_i32 s43, s43, 1
		s_add_i32 s54, s40, s43
		s_mul_i32 s40, 0x4100, s42
		v_add_u32_e32 v26, s40, v30
		ds_read_b128 a[80:83], v26
		ds_read_b128 a[84:87], v26 offset:32
		ds_read_b128 a[88:91], v26 offset:64
		ds_read_b128 a[92:95], v26 offset:96
		ds_read_b128 a[96:99], v26 offset:256
		ds_read_b128 a[100:103], v26 offset:288
		ds_read_b128 a[104:107], v26 offset:320
		ds_read_b128 a[108:111], v26 offset:352
		ds_read_b128 a[112:115], v26 offset:128
		ds_read_b128 a[116:119], v26 offset:160
		ds_read_b128 a[120:123], v26 offset:192
		ds_read_b128 a[124:127], v26 offset:224
		ds_read_b128 a[128:131], v26 offset:384
		ds_read_b128 a[132:135], v26 offset:416
		ds_read_b128 a[136:139], v26 offset:448
		ds_read_b128 a[140:143], v26 offset:480
		s_mul_i32 s40, 0x4400, s42
		v_add_u32_e32 v26, s40, v23
		ds_read_b64_tr_b16 a[144:145], v26 offset:33264
		ds_read_b64_tr_b16 a[146:147], v26 offset:37616
		ds_read_b64_tr_b16 a[148:149], v26 offset:33392
		ds_read_b64_tr_b16 a[150:151], v26 offset:37744
		ds_read_b64_tr_b16 a[152:153], v26 offset:33520
		ds_read_b64_tr_b16 a[154:155], v26 offset:37872
		ds_read_b64_tr_b16 a[156:157], v26 offset:33648
		ds_read_b64_tr_b16 a[158:159], v26 offset:38000
		ds_read_b64_tr_b16 a[160:161], v26 offset:33776
		ds_read_b64_tr_b16 a[162:163], v26 offset:38128
		ds_read_b64_tr_b16 a[164:165], v26 offset:33904
		ds_read_b64_tr_b16 a[166:167], v26 offset:38256
		ds_read_b64_tr_b16 a[168:169], v26 offset:34032
		ds_read_b64_tr_b16 a[170:171], v26 offset:38384
		ds_read_b64_tr_b16 a[172:173], v26 offset:34160
		ds_read_b64_tr_b16 a[174:175], v26 offset:38512
		ds_read_b64_tr_b16 a[176:177], v26 offset:33328
		ds_read_b64_tr_b16 a[178:179], v26 offset:37680
		ds_read_b64_tr_b16 a[180:181], v26 offset:33456
		ds_read_b64_tr_b16 a[182:183], v26 offset:37808
		ds_read_b64_tr_b16 a[184:185], v26 offset:33584
		ds_read_b64_tr_b16 a[186:187], v26 offset:37936
		ds_read_b64_tr_b16 a[188:189], v26 offset:33712
		ds_read_b64_tr_b16 a[190:191], v26 offset:38064
		ds_read_b64_tr_b16 a[192:193], v26 offset:33840
		ds_read_b64_tr_b16 a[194:195], v26 offset:38192
		ds_read_b64_tr_b16 a[196:197], v26 offset:33968
		ds_read_b64_tr_b16 a[198:199], v26 offset:38320
		ds_read_b64_tr_b16 a[200:201], v26 offset:34096
		ds_read_b64_tr_b16 a[202:203], v26 offset:38448
		ds_read_b64_tr_b16 a[204:205], v26 offset:34224
		ds_read_b64_tr_b16 a[206:207], v26 offset:38576
		s_cmp_lt_i32 s21, s25
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_1
		s_waitcnt lgkmcnt(14)
		s_barrier
		v_add_u32_e32 v26, s21, v18
		v_add_u32_e32 v31, s21, v22
		v_add_u32_e32 v34, s21, v24
		v_add_u32_e32 v35, s21, v5
		v_cmp_lt_i32_e64 vcc, v26, s23
		s_mov_b64 s[42:43], vcc
		v_cmp_lt_i32_e64 vcc, v31, s23
		s_mov_b64 s[58:59], vcc
		v_cmp_lt_i32_e64 vcc, v34, s23
		s_mov_b64 s[60:61], vcc
		v_cmp_lt_i32_e64 vcc, v35, s23
		s_mov_b64 s[62:63], vcc
		v_add_u32_e32 v26, s21, v14
		v_add_u32_e32 v31, s21, v28
		v_add_u32_e32 v34, s21, v29
		v_cmp_lt_i32_e64 vcc, v26, s23
		s_mov_b64 s[64:65], vcc
		v_cmp_lt_i32_e64 vcc, v31, s23
		s_mov_b64 s[66:67], vcc
		v_cmp_lt_i32_e64 vcc, v34, s23
		s_mov_b64 s[68:69], vcc
		s_mul_i32 s40, s15, s46
		s_lshl_b32 s40, s40, 1
		s_add_i32 s45, s47, s40
		v_add_u32_e32 v26, s45, v16
		s_mov_b32 s70, 1
		s_mov_b32 s71, 0
		s_mov_b32 s57, 0
		s_mul_i32 s72, s70, s56
		s_mul_hi_u32 s73, s70, s56
		s_mul_i32 s45, s70, s57
		s_add_i32 s73, s73, s45
		s_mul_i32 s45, s71, s56
		s_add_i32 s73, s73, s45
		s_lshr_b64 s[70:71], s[72:73], 6
		s_mov_b32 s72, 0x410
		s_mov_b32 s73, 0
		s_mul_i32 s74, s72, s70
		s_mul_hi_u32 s75, s72, s70
		s_mul_i32 s45, s72, s71
		s_add_i32 s75, s75, s45
		s_mul_i32 s45, s73, s70
		s_add_i32 s75, s75, s45
		s_cmp_lt_i32 s54, 0
		s_cselect_b32 s55, -1, 0
		s_mov_b32 s72, 0x4100
		s_mov_b32 s73, 0
		s_mul_i32 s76, s72, s54
		s_mul_hi_u32 s77, s72, s54
		s_mul_i32 s45, s72, s55
		s_add_i32 s77, s77, s45
		s_mul_i32 s45, s73, s54
		s_add_i32 s77, s77, s45
		s_add_u32 s72, s74, s76
		s_addc_u32 s73, s75, s77
		s_add_u32 s78, s72, 0
		s_addc_u32 s79, s73, 0
		s_mov_b32 m0, s78
		v_cndmask_b32_e64 v26, v27, v26, s[42:43]
		buffer_load_dwordx4 v26, s[28:31], 0 offen lds
		v_add_u32_e32 v26, s21, v9
		s_add_i32 s21, s48, s40
		v_add_u32_e32 v31, s21, v16
		s_add_u32 s42, s74, 0x1040
		s_addc_u32 s43, s75, 0
		s_add_u32 s42, s42, s76
		s_addc_u32 s43, s43, s77
		s_add_u32 s72, s42, 0
		s_addc_u32 s73, s43, 0
		s_mov_b32 m0, s72
		v_cndmask_b32_e64 v31, v27, v31, s[58:59]
		buffer_load_dwordx4 v31, s[28:31], 0 offen lds
		s_add_i32 s21, s49, s40
		v_add_u32_e32 v31, s21, v16
		s_add_u32 s42, s74, 0x2080
		s_addc_u32 s43, s75, 0
		s_add_u32 s42, s42, s76
		s_addc_u32 s43, s43, s77
		s_add_u32 s58, s42, 0
		s_addc_u32 s59, s43, 0
		s_mov_b32 m0, s58
		v_cndmask_b32_e64 v31, v27, v31, s[60:61]
		buffer_load_dwordx4 v31, s[28:31], 0 offen lds
		s_add_i32 s21, s41, s40
		v_add_u32_e32 v31, s21, v16
		s_add_u32 s42, s74, 0x30c0
		s_addc_u32 s43, s75, 0
		s_add_u32 s42, s42, s76
		s_addc_u32 s43, s43, s77
		s_add_u32 s58, s42, 0
		s_addc_u32 s59, s43, 0
		s_mov_b32 m0, s58
		v_cndmask_b32_e64 v31, v27, v31, s[62:63]
		buffer_load_dwordx4 v31, s[28:31], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s21, s20, s46
		s_lshl_b32 s21, s21, 1
		s_add_i32 s40, s50, s21
		v_add_u32_e32 v31, s40, v7
		s_mov_b32 s42, 0x440
		s_mov_b32 s43, 0
		s_mul_i32 s58, s42, s70
		s_mul_hi_u32 s59, s42, s70
		s_mul_i32 s40, s42, s71
		s_add_i32 s59, s59, s40
		s_mul_i32 s40, s43, s70
		s_add_i32 s59, s59, s40
		s_add_u32 s42, s58, 0x81f0
		s_addc_u32 s43, s59, 0
		s_mov_b32 s60, 0x4400
		s_mov_b32 s61, 0
		s_mul_i32 s62, s60, s54
		s_mul_hi_u32 s63, s60, s54
		s_mul_i32 s40, s60, s55
		s_add_i32 s63, s63, s40
		s_mul_i32 s40, s61, s54
		s_add_i32 s63, s63, s40
		s_add_u32 s42, s42, s62
		s_addc_u32 s43, s43, s63
		s_add_u32 s54, s42, 0
		s_addc_u32 s55, s43, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v31, v27, v31, s[64:65]
		buffer_load_dwordx4 v31, s[32:35], 0 offen lds
		s_add_i32 s40, s51, s21
		v_add_u32_e32 v31, s40, v7
		s_add_u32 s42, s58, 0x92f0
		s_addc_u32 s43, s59, 0
		s_add_u32 s42, s42, s62
		s_addc_u32 s43, s43, s63
		s_add_u32 s54, s42, 0
		s_addc_u32 s55, s43, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v31, v27, v31, s[66:67]
		buffer_load_dwordx4 v31, s[32:35], 0 offen lds
		s_add_i32 s40, s52, s21
		v_add_u32_e32 v31, s40, v7
		s_add_u32 s42, s58, 0xa3f0
		s_addc_u32 s43, s59, 0
		s_add_u32 s42, s42, s62
		s_addc_u32 s43, s43, s63
		s_add_u32 s54, s42, 0
		s_addc_u32 s55, s43, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v31, v27, v31, s[68:69]
		buffer_load_dwordx4 v31, s[32:35], 0 offen lds
		s_add_i32 s21, s44, s21
		v_cmp_lt_i32_e64 vcc, v26, s23
		v_add_u32_e32 v26, s21, v7
		s_add_u32 s42, s58, 0xb4f0
		s_addc_u32 s43, s59, 0
		v_cndmask_b32_e32 v26, v27, v26, vcc
		s_add_u32 s42, s42, s62
		s_addc_u32 s43, s43, s63
		s_add_u32 s54, s42, 0
		s_addc_u32 s55, s43, 0
		s_mov_b32 m0, s54
		s_nop 0
		buffer_load_dwordx4 v26, s[32:35], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_1
.L_attn_fwd_persistent.if_else_1:
.L_attn_fwd_persistent.if_end_1:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[144:159], a[80:83], a[16:19], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], a[96:99], a[16:19], 0
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
		v_mfma_f32_32x32x16_bf16 v[160:175], a[112:115], a[16:19], 0
		s_nop 11
		v_accvgpr_write_b32 a224, v160
		v_accvgpr_write_b32 a225, v161
		v_accvgpr_write_b32 a226, v162
		v_accvgpr_write_b32 a227, v163
		v_accvgpr_write_b32 a228, v164
		v_accvgpr_write_b32 a229, v165
		v_accvgpr_write_b32 a230, v166
		v_accvgpr_write_b32 a231, v167
		v_accvgpr_write_b32 a232, v168
		v_accvgpr_write_b32 a233, v169
		v_accvgpr_write_b32 a234, v170
		v_accvgpr_write_b32 a235, v171
		v_accvgpr_write_b32 a236, v172
		v_accvgpr_write_b32 a237, v173
		v_accvgpr_write_b32 a238, v174
		v_accvgpr_write_b32 a239, v175
		v_mfma_f32_32x32x16_bf16 v[160:175], a[128:131], a[16:19], 0
		v_mfma_f32_32x32x16_bf16 v[176:191], a[128:131], a[40:43], 0
		s_nop 11
		v_accvgpr_write_b32 a240, v176
		v_accvgpr_write_b32 a241, v177
		v_accvgpr_write_b32 a242, v178
		v_accvgpr_write_b32 a243, v179
		v_accvgpr_write_b32 a244, v180
		v_accvgpr_write_b32 a245, v181
		v_accvgpr_write_b32 a246, v182
		v_accvgpr_write_b32 a247, v183
		v_accvgpr_write_b32 a248, v184
		v_accvgpr_write_b32 a249, v185
		v_accvgpr_write_b32 a250, v186
		v_accvgpr_write_b32 a251, v187
		v_accvgpr_write_b32 a252, v188
		v_accvgpr_write_b32 a253, v189
		v_accvgpr_write_b32 a254, v190
		v_accvgpr_write_b32 a255, v191
		v_mfma_f32_32x32x16_bf16 v[176:191], a[80:83], a[40:43], 0
		v_mfma_f32_32x32x16_bf16 v[192:207], a[96:99], a[40:43], 0
		v_mfma_f32_32x32x16_bf16 v[208:223], a[112:115], a[40:43], 0
		v_mfma_f32_32x32x16_bf16 v[144:159], a[84:87], a[24:27], v[144:159]
		v_mfma_f32_32x32x16_bf16 a[208:223], a[100:103], a[24:27], a[208:223]
		v_mfma_f32_32x32x16_bf16 a[224:239], a[116:119], a[24:27], a[224:239]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[132:135], a[24:27], v[160:175]
		v_mfma_f32_32x32x16_bf16 a[240:255], a[132:135], a[44:47], a[240:255]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[84:87], a[44:47], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[100:103], a[44:47], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[116:119], a[44:47], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[88:91], a[28:31], v[144:159]
		v_mfma_f32_32x32x16_bf16 a[208:223], a[104:107], a[28:31], a[208:223]
		v_mfma_f32_32x32x16_bf16 a[224:239], a[120:123], a[28:31], a[224:239]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[136:139], a[28:31], v[160:175]
		v_mfma_f32_32x32x16_bf16 a[240:255], a[136:139], a[48:51], a[240:255]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[88:91], a[48:51], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[104:107], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[120:123], a[48:51], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[92:95], a[32:35], v[144:159]
		v_mfma_f32_32x32x16_bf16 a[208:223], a[108:111], a[32:35], a[208:223]
		v_mfma_f32_32x32x16_bf16 a[224:239], a[124:127], a[32:35], a[224:239]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[140:143], a[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 a[240:255], a[140:143], a[52:55], a[240:255]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[92:95], a[52:55], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[108:111], a[52:55], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[124:127], a[52:55], v[208:223]
		v_add_u32_e32 v26, s46, v17
		v_accvgpr_write_b32 a80, v26
		v_add_u32_e32 v26, s46, v11
		v_accvgpr_write_b32 a81, v26
		v_add_u32_e32 v26, s46, v12
		v_accvgpr_write_b32 a82, v26
		v_add_u32_e32 v26, s46, v13
		v_accvgpr_write_b32 a83, v26
		v_add_u32_e32 v26, s46, v38
		v_accvgpr_write_b32 a84, v26
		v_add_u32_e32 v26, s46, v40
		v_accvgpr_write_b32 a85, v26
		v_add_u32_e32 v26, s46, v43
		v_accvgpr_write_b32 a86, v26
		v_add_u32_e32 v26, s46, v44
		v_accvgpr_write_b32 a87, v26
		v_add_u32_e32 v26, s46, v47
		v_accvgpr_write_b32 a88, v26
		v_add_u32_e32 v26, s46, v96
		v_accvgpr_write_b32 a89, v26
		v_add_u32_e32 v26, s46, v99
		v_accvgpr_write_b32 a90, v26
		v_add_u32_e32 v26, s46, v100
		v_accvgpr_write_b32 a91, v26
		v_add_u32_e32 v26, s46, v103
		v_accvgpr_write_b32 a92, v26
		v_add_u32_e32 v26, s46, v104
		v_accvgpr_write_b32 a93, v26
		v_add_u32_e32 v26, s46, v107
		v_accvgpr_write_b32 a94, v26
		v_add_u32_e32 v26, s46, v108
		v_accvgpr_write_b32 a95, v26
		v_add_u32_e32 v26, s46, v111
		v_accvgpr_write_b32 a96, v26
		v_add_u32_e32 v26, s46, v112
		v_accvgpr_write_b32 a97, v26
		v_add_u32_e32 v26, s46, v115
		v_accvgpr_write_b32 a98, v26
		v_add_u32_e32 v26, s46, v116
		v_accvgpr_write_b32 a99, v26
		v_add_u32_e32 v26, s46, v119
		v_accvgpr_write_b32 a100, v26
		v_add_u32_e32 v26, s46, v120
		v_accvgpr_write_b32 a101, v26
		v_add_u32_e32 v26, s46, v123
		v_accvgpr_write_b32 a102, v26
		v_add_u32_e32 v26, s46, v124
		v_accvgpr_write_b32 a103, v26
		v_add_u32_e32 v26, s46, v125
		v_accvgpr_write_b32 a104, v26
		v_add_u32_e32 v26, s46, v126
		v_accvgpr_write_b32 a105, v26
		v_add_u32_e32 v26, s46, v127
		v_accvgpr_write_b32 a106, v26
		v_add_u32_e32 v26, s46, v128
		v_accvgpr_write_b32 a107, v26
		v_add_u32_e32 v26, s46, v129
		v_accvgpr_write_b32 a108, v26
		v_add_u32_e32 v26, s46, v130
		v_accvgpr_write_b32 a109, v26
		v_add_u32_e32 v26, s46, v131
		v_accvgpr_write_b32 a110, v26
		v_add_u32_e32 v26, s46, v132
		v_accvgpr_write_b32 a111, v26
		v_add_u32_e32 v26, s46, v133
		v_accvgpr_write_b32 a112, v26
		v_add_u32_e32 v26, s46, v134
		v_accvgpr_write_b32 a113, v26
		v_accvgpr_read_b32 v26, a80
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[42:43], vcc
		v_accvgpr_read_b32 v26, a81
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v26, a82
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[58:59], vcc
		v_accvgpr_read_b32 v26, a83
		v_cmp_ge_i32_e64 vcc, v10, v26
		v_add_u32_e32 v26, s46, v15
		v_accvgpr_write_b32 a114, v26
		v_add_u32_e32 v26, s46, v21
		v_cndmask_b32_e32 v31, v25, v147, vcc
		v_accvgpr_write_b32 a117, v31
		v_accvgpr_read_b32 v31, a114
		v_cmp_ge_i32_e64 vcc, v10, v31
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[62:63], vcc
		v_accvgpr_read_b32 v26, a84
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[64:65], vcc
		v_accvgpr_read_b32 v26, a85
		v_cmp_ge_i32_e64 vcc, v10, v26
		v_add_u32_e32 v26, s46, v41
		v_accvgpr_write_b32 a115, v26
		v_add_u32_e32 v26, s46, v42
		v_cndmask_b32_e32 v31, v25, v151, vcc
		v_accvgpr_write_b32 a119, v31
		v_accvgpr_read_b32 v31, a115
		v_cmp_ge_i32_e64 vcc, v10, v31
		s_mov_b64 s[66:67], vcc
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[68:69], vcc
		v_accvgpr_read_b32 v26, a86
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[70:71], vcc
		v_accvgpr_read_b32 v26, a87
		v_cmp_ge_i32_e64 vcc, v10, v26
		v_add_u32_e32 v26, s46, v45
		v_accvgpr_write_b32 a120, v26
		v_add_u32_e32 v26, s46, v46
		v_cndmask_b32_e32 v31, v25, v155, vcc
		v_accvgpr_write_b32 a123, v31
		v_accvgpr_read_b32 v31, a120
		v_cmp_ge_i32_e64 vcc, v10, v31
		s_mov_b64 s[72:73], vcc
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[74:75], vcc
		v_accvgpr_read_b32 v26, a88
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[76:77], vcc
		v_accvgpr_read_b32 v26, a89
		v_cmp_ge_i32_e64 vcc, v10, v26
		v_add_u32_e32 v26, s46, v97
		v_accvgpr_write_b32 a121, v26
		v_add_u32_e32 v26, s46, v98
		v_cndmask_b32_e32 v31, v25, v159, vcc
		v_accvgpr_write_b32 a125, v31
		v_accvgpr_read_b32 v31, a121
		v_cmp_ge_i32_e64 vcc, v10, v31
		s_mov_b64 s[78:79], vcc
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[80:81], vcc
		v_accvgpr_read_b32 v26, a90
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[82:83], vcc
		v_accvgpr_read_b32 v26, a91
		v_cmp_ge_i32_e64 vcc, v10, v26
		v_add_u32_e32 v26, s46, v101
		v_accvgpr_write_b32 a126, v26
		v_add_u32_e32 v26, s46, v102
		v_accvgpr_write_b32 a127, v26
		v_accvgpr_read_b32 v26, a211
		v_cndmask_b32_e32 v26, v25, v26, vcc
		v_accvgpr_write_b32 a129, v26
		v_accvgpr_read_b32 v26, a126
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[84:85], vcc
		v_accvgpr_read_b32 v26, a127
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[86:87], vcc
		v_accvgpr_read_b32 v26, a92
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[88:89], vcc
		v_mov_b32_e32 v34, s88
		v_mov_b32_e32 v35, s89
		v_accvgpr_read_b32 v26, a93
		v_cmp_ge_i32_e64 vcc, v10, v26
		v_add_u32_e32 v26, s46, v105
		v_accvgpr_write_b32 a128, v26
		v_add_u32_e32 v26, s46, v106
		v_accvgpr_write_b32 a130, v26
		v_accvgpr_read_b32 v26, a215
		v_cndmask_b32_e32 v26, v25, v26, vcc
		v_accvgpr_write_b32 a133, v26
		v_accvgpr_read_b32 v26, a128
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[88:89], vcc
		v_mov_b32_e32 v36, s88
		v_mov_b32_e32 v37, s89
		v_accvgpr_read_b32 v26, a130
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[88:89], vcc
		v_mov_b32_e32 v136, s88
		v_mov_b32_e32 v137, s89
		v_accvgpr_write_b32 a134, v136
		v_accvgpr_write_b32 a135, v137
		v_accvgpr_read_b32 v26, a94
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[88:89], vcc
		v_mov_b32_e32 v136, s88
		v_mov_b32_e32 v137, s89
		v_accvgpr_write_b32 a136, v136
		v_accvgpr_write_b32 a137, v137
		v_accvgpr_read_b32 v26, a95
		v_cmp_ge_i32_e64 vcc, v10, v26
		v_add_u32_e32 v26, s46, v109
		v_add_u32_e32 v31, s46, v110
		v_accvgpr_read_b32 v39, a219
		v_cndmask_b32_e32 v39, v25, v39, vcc
		v_accvgpr_write_b32 a139, v39
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[88:89], vcc
		v_mov_b32_e32 v136, s88
		v_mov_b32_e32 v137, s89
		v_accvgpr_write_b32 a140, v136
		v_accvgpr_write_b32 a141, v137
		v_cmp_ge_i32_e64 vcc, v10, v31
		s_mov_b64 s[88:89], vcc
		v_mov_b32_e32 v136, s88
		v_mov_b32_e32 v137, s89
		v_accvgpr_write_b32 a142, v136
		v_accvgpr_write_b32 a143, v137
		v_accvgpr_read_b32 v26, a96
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[88:89], vcc
		v_mov_b32_e32 v136, s88
		v_mov_b32_e32 v137, s89
		v_accvgpr_read_b32 v26, a97
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[88:89], vcc
		v_mov_b32_e32 v138, s88
		v_mov_b32_e32 v139, s89
		v_add_u32_e32 v26, s46, v113
		v_add_u32_e32 v31, s46, v114
		v_accvgpr_read_b32 v39, a223
		v_cndmask_b32_e32 v139, v25, v39, vcc
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[88:89], vcc
		v_mov_b32_e32 v140, s88
		v_mov_b32_e32 v141, s89
		v_cmp_ge_i32_e64 vcc, v10, v31
		s_mov_b64 s[88:89], vcc
		v_mov_b32_e32 v142, s88
		v_mov_b32_e32 v143, s89
		v_accvgpr_read_b32 v26, a98
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[88:89], vcc
		v_mov_b32_e32 v224, s88
		v_mov_b32_e32 v225, s89
		v_accvgpr_read_b32 v26, a99
		v_cmp_ge_i32_e64 vcc, v10, v26
		v_add_u32_e32 v26, s46, v117
		v_add_u32_e32 v31, s46, v118
		v_accvgpr_read_b32 v39, a227
		v_mov_b32_e32 v135, 0xff800000
		v_cndmask_b32_e32 v227, v135, v39, vcc
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[88:89], vcc
		v_mov_b32_e32 v228, s88
		v_mov_b32_e32 v229, s89
		v_cmp_ge_i32_e64 vcc, v10, v31
		s_mov_b64 s[88:89], vcc
		v_mov_b32_e32 v230, s88
		v_mov_b32_e32 v231, s89
		v_accvgpr_read_b32 v26, a100
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[88:89], vcc
		v_mov_b32_e32 v232, s88
		v_mov_b32_e32 v233, s89
		v_accvgpr_read_b32 v26, a101
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[88:89], vcc
		v_mov_b32_e32 v234, s88
		v_mov_b32_e32 v235, s89
		v_add_u32_e32 v26, s46, v121
		v_add_u32_e32 v31, s46, v122
		v_accvgpr_read_b32 v39, a231
		v_cndmask_b32_e32 v235, v135, v39, vcc
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[88:89], vcc
		v_mov_b32_e32 v236, s88
		v_mov_b32_e32 v237, s89
		v_cmp_ge_i32_e64 vcc, v10, v31
		s_mov_b64 s[88:89], vcc
		v_mov_b32_e32 v238, s88
		v_mov_b32_e32 v239, s89
		v_accvgpr_read_b32 v26, a102
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[88:89], vcc
		v_mov_b32_e32 v240, s88
		v_mov_b32_e32 v241, s89
		v_accvgpr_read_b32 v26, a103
		v_cmp_ge_i32_e64 vcc, v10, v26
		v_lshrrev_b32_e32 v26, 5, v0
		v_and_b32_e32 v26, 1, v26
		v_mov_b32_e32 v31, 4
		v_mul_lo_u32 v31, v31, v26
		v_xor_b32_e32 v26, 0x58, v31
		v_add_u32_e32 v26, s46, v26
		v_lshrrev_b32_e32 v31, 5, v0
		v_and_b32_e32 v31, 1, v31
		v_mov_b32_e32 v39, 4
		v_mul_lo_u32 v39, v39, v31
		v_xor_b32_e32 v31, 0x59, v39
		v_add_u32_e32 v31, s46, v31
		v_accvgpr_read_b32 v39, a235
		v_cndmask_b32_e32 v243, v135, v39, vcc
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[88:89], vcc
		v_mov_b32_e32 v244, s88
		v_mov_b32_e32 v245, s89
		v_cmp_ge_i32_e64 vcc, v10, v31
		s_mov_b64 s[88:89], vcc
		v_accvgpr_read_b32 v26, a104
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[90:91], vcc
		v_accvgpr_read_b32 v26, a237
		v_cndmask_b32_e64 v247, v135, v26, s[88:89]
		v_accvgpr_read_b32 v26, a238
		v_cndmask_b32_e64 v248, v135, v26, s[90:91]
		v_accvgpr_read_b32 v26, a105
		v_cmp_ge_i32_e64 vcc, v10, v26
		v_lshrrev_b32_e32 v26, 5, v0
		v_and_b32_e32 v26, 1, v26
		v_mov_b32_e32 v31, 4
		v_mul_lo_u32 v31, v31, v26
		v_xor_b32_e32 v26, 0x60, v31
		v_add_u32_e32 v26, s46, v26
		v_lshrrev_b32_e32 v31, 5, v0
		v_and_b32_e32 v31, 1, v31
		v_mov_b32_e32 v39, 4
		v_mul_lo_u32 v39, v39, v31
		v_xor_b32_e32 v31, 0x61, v39
		v_add_u32_e32 v31, s46, v31
		v_accvgpr_read_b32 v39, a239
		v_cndmask_b32_e32 v249, v135, v39, vcc
		v_cmp_ge_i32_e64 vcc, v10, v26
		s_mov_b64 s[88:89], vcc
		v_cmp_ge_i32_e64 vcc, v10, v31
		s_mov_b64 s[90:91], vcc
		v_accvgpr_read_b32 v39, a106
		v_cmp_ge_i32_e64 vcc, v10, v39
		s_mov_b64 s[92:93], vcc
		v_cndmask_b32_e64 v250, v135, v160, s[88:89]
		v_cndmask_b32_e64 v251, v135, v161, s[90:91]
		v_cndmask_b32_e64 v160, v135, v162, s[92:93]
		v_accvgpr_read_b32 v39, a107
		v_cmp_ge_i32_e64 vcc, v10, v39
		v_lshrrev_b32_e32 v39, 5, v0
		v_and_b32_e32 v39, 1, v39
		v_mov_b32_e32 v138, 4
		v_mul_lo_u32 v138, v138, v39
		v_xor_b32_e32 v39, 0x68, v138
		v_add_u32_e32 v39, s46, v39
		v_lshrrev_b32_e32 v138, 5, v0
		v_and_b32_e32 v138, 1, v138
		v_mov_b32_e32 v147, 4
		v_mul_lo_u32 v147, v147, v138
		v_xor_b32_e32 v138, 0x69, v147
		v_add_u32_e32 v147, s46, v138
		v_cndmask_b32_e32 v161, v135, v163, vcc
		v_cmp_ge_i32_e64 vcc, v10, v39
		s_mov_b64 s[88:89], vcc
		v_cmp_ge_i32_e64 vcc, v10, v147
		s_mov_b64 s[90:91], vcc
		v_accvgpr_read_b32 v138, a108
		v_cmp_ge_i32_e64 vcc, v10, v138
		s_mov_b64 s[92:93], vcc
		v_cndmask_b32_e64 v162, v135, v164, s[88:89]
		v_cndmask_b32_e64 v163, v135, v165, s[90:91]
		v_cndmask_b32_e64 v164, v135, v166, s[92:93]
		v_accvgpr_read_b32 v138, a109
		v_cmp_ge_i32_e64 vcc, v10, v138
		v_lshrrev_b32_e32 v138, 5, v0
		v_and_b32_e32 v138, 1, v138
		v_mov_b32_e32 v151, 4
		v_mul_lo_u32 v151, v151, v138
		v_xor_b32_e32 v138, 0x70, v151
		v_add_u32_e32 v151, s46, v138
		v_lshrrev_b32_e32 v138, 5, v0
		v_and_b32_e32 v138, 1, v138
		v_mov_b32_e32 v155, 4
		v_mul_lo_u32 v155, v155, v138
		v_xor_b32_e32 v138, 0x71, v155
		v_add_u32_e32 v155, s46, v138
		v_cndmask_b32_e32 v165, v135, v167, vcc
		v_cmp_ge_i32_e64 vcc, v10, v151
		s_mov_b64 s[88:89], vcc
		v_cmp_ge_i32_e64 vcc, v10, v155
		s_mov_b64 s[90:91], vcc
		v_accvgpr_read_b32 v138, a110
		v_cmp_ge_i32_e64 vcc, v10, v138
		s_mov_b64 s[92:93], vcc
		v_cndmask_b32_e64 v166, v135, v168, s[88:89]
		v_cndmask_b32_e64 v167, v135, v169, s[90:91]
		v_cndmask_b32_e64 v168, v135, v170, s[92:93]
		v_accvgpr_read_b32 v138, a111
		v_cmp_ge_i32_e64 vcc, v10, v138
		v_lshrrev_b32_e32 v138, 5, v0
		v_and_b32_e32 v138, 1, v138
		v_mov_b32_e32 v159, 4
		v_mul_lo_u32 v159, v159, v138
		v_xor_b32_e32 v138, 0x78, v159
		v_add_u32_e32 v159, s46, v138
		v_lshrrev_b32_e32 v138, 5, v0
		v_and_b32_e32 v138, 1, v138
		v_mov_b32_e32 v169, 4
		v_mul_lo_u32 v169, v169, v138
		v_xor_b32_e32 v138, 0x79, v169
		v_add_u32_e32 v170, s46, v138
		v_cndmask_b32_e32 v169, v135, v171, vcc
		v_cmp_ge_i32_e64 vcc, v10, v159
		s_mov_b64 s[88:89], vcc
		v_cmp_ge_i32_e64 vcc, v10, v170
		s_mov_b64 s[90:91], vcc
		v_accvgpr_read_b32 v138, a112
		v_cmp_ge_i32_e64 vcc, v10, v138
		s_mov_b64 s[92:93], vcc
		v_cndmask_b32_e64 v252, v135, v172, s[88:89]
		v_cndmask_b32_e64 v253, v135, v173, s[90:91]
		v_cndmask_b32_e64 v172, v135, v174, s[92:93]
		v_accvgpr_read_b32 v138, a113
		v_cmp_ge_i32_e64 vcc, v10, v138
		v_cndmask_b32_e64 v254, v135, v144, s[42:43]
		v_cndmask_b32_e64 v255, v135, v145, s[54:55]
		v_cndmask_b32_e32 v173, v135, v175, vcc
		v_accvgpr_read_b32 v138, a80
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[42:43], vcc
		v_accvgpr_read_b32 v138, a81
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v138, a82
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[88:89], vcc
		v_cndmask_b32_e64 v144, v135, v176, s[42:43]
		v_cndmask_b32_e64 v145, v135, v177, s[54:55]
		v_cndmask_b32_e64 v174, v135, v178, s[88:89]
		v_accvgpr_read_b32 v138, a83
		v_cmp_ge_i32_e64 vcc, v6, v138
		v_cndmask_b32_e64 v138, v135, v146, s[58:59]
		v_accvgpr_write_b32 a116, v138
		v_cndmask_b32_e64 v176, v135, v148, s[60:61]
		v_cndmask_b32_e32 v175, v135, v179, vcc
		v_accvgpr_read_b32 v138, a114
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[42:43], vcc
		v_lshrrev_b32_e32 v138, 5, v0
		v_and_b32_e32 v138, 1, v138
		v_mov_b32_e32 v146, 4
		v_mul_lo_u32 v146, v146, v138
		v_xor_b32_e32 v138, 9, v146
		v_add_u32_e32 v138, s46, v138
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v138, a84
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v178, v135, v180, s[42:43]
		v_cndmask_b32_e64 v179, v135, v181, s[54:55]
		v_cndmask_b32_e64 v180, v135, v182, s[58:59]
		v_accvgpr_read_b32 v138, a85
		v_cmp_ge_i32_e64 vcc, v6, v138
		v_cndmask_b32_e64 v177, v135, v149, s[62:63]
		v_cndmask_b32_e64 v138, v135, v150, s[64:65]
		v_accvgpr_write_b32 a118, v138
		v_cndmask_b32_e32 v181, v135, v183, vcc
		v_accvgpr_read_b32 v138, a115
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[42:43], vcc
		v_lshrrev_b32_e32 v138, 5, v0
		v_and_b32_e32 v138, 1, v138
		v_mov_b32_e32 v146, 4
		v_mul_lo_u32 v146, v146, v138
		v_xor_b32_e32 v138, 17, v146
		v_add_u32_e32 v138, s46, v138
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v138, a86
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v148, v135, v184, s[42:43]
		v_cndmask_b32_e64 v149, v135, v185, s[54:55]
		v_cndmask_b32_e64 v182, v135, v186, s[58:59]
		v_accvgpr_read_b32 v138, a87
		v_cmp_ge_i32_e64 vcc, v6, v138
		v_cndmask_b32_e64 v184, v135, v152, s[66:67]
		v_cndmask_b32_e64 v185, v135, v153, s[68:69]
		v_cndmask_b32_e32 v183, v135, v187, vcc
		v_accvgpr_read_b32 v138, a120
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[42:43], vcc
		v_lshrrev_b32_e32 v138, 5, v0
		v_and_b32_e32 v138, 1, v138
		v_mov_b32_e32 v146, 4
		v_mul_lo_u32 v146, v146, v138
		v_xor_b32_e32 v138, 25, v146
		v_add_u32_e32 v138, s46, v138
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v138, a88
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v152, v135, v188, s[42:43]
		v_cndmask_b32_e64 v153, v135, v189, s[54:55]
		v_cndmask_b32_e64 v186, v135, v190, s[58:59]
		v_accvgpr_read_b32 v138, a89
		v_cmp_ge_i32_e64 vcc, v6, v138
		v_cndmask_b32_e64 v138, v135, v154, s[70:71]
		v_accvgpr_write_b32 a122, v138
		v_cndmask_b32_e64 v188, v135, v156, s[72:73]
		v_cndmask_b32_e32 v187, v135, v191, vcc
		v_accvgpr_read_b32 v138, a121
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[42:43], vcc
		v_lshrrev_b32_e32 v138, 5, v0
		v_and_b32_e32 v138, 1, v138
		v_mov_b32_e32 v146, 4
		v_mul_lo_u32 v146, v146, v138
		v_xor_b32_e32 v138, 33, v146
		v_add_u32_e32 v138, s46, v138
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v138, a90
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v190, v135, v192, s[42:43]
		v_cndmask_b32_e64 v191, v135, v193, s[54:55]
		v_cndmask_b32_e64 v192, v135, v194, s[58:59]
		v_accvgpr_read_b32 v138, a91
		v_cmp_ge_i32_e64 vcc, v6, v138
		v_cndmask_b32_e64 v189, v135, v157, s[74:75]
		v_cndmask_b32_e64 v138, v135, v158, s[76:77]
		v_accvgpr_write_b32 a124, v138
		v_cndmask_b32_e32 v193, v135, v195, vcc
		v_accvgpr_read_b32 v138, a126
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[42:43], vcc
		v_accvgpr_read_b32 v138, a127
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v138, a92
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v156, v135, v196, s[42:43]
		v_cndmask_b32_e64 v157, v135, v197, s[54:55]
		v_cndmask_b32_e64 v194, v135, v198, s[58:59]
		v_accvgpr_read_b32 v138, a93
		v_cmp_ge_i32_e64 vcc, v6, v138
		v_accvgpr_read_b32 v138, a208
		v_cndmask_b32_e64 v196, v135, v138, s[78:79]
		v_accvgpr_read_b32 v138, a209
		v_cndmask_b32_e64 v197, v135, v138, s[80:81]
		v_cndmask_b32_e32 v195, v135, v199, vcc
		v_accvgpr_read_b32 v138, a128
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[42:43], vcc
		v_accvgpr_read_b32 v138, a130
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v138, a94
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v138, v135, v200, s[42:43]
		v_accvgpr_write_b32 a80, v138
		v_cndmask_b32_e64 v138, v135, v201, s[54:55]
		v_accvgpr_write_b32 a81, v138
		v_cndmask_b32_e64 v198, v135, v202, s[58:59]
		v_accvgpr_read_b32 v138, a95
		v_cmp_ge_i32_e64 vcc, v6, v138
		v_accvgpr_read_b32 v138, a210
		v_cndmask_b32_e64 v138, v135, v138, s[82:83]
		v_accvgpr_write_b32 a128, v138
		v_accvgpr_read_b32 v138, a212
		v_cndmask_b32_e64 v200, v135, v138, s[84:85]
		v_cndmask_b32_e32 v199, v135, v203, vcc
		v_lshrrev_b32_e32 v138, 5, v0
		v_and_b32_e32 v138, 1, v138
		v_mov_b32_e32 v146, 4
		v_mul_lo_u32 v146, v146, v138
		v_xor_b32_e32 v138, 56, v146
		v_add_u32_e32 v138, s46, v138
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[42:43], vcc
		v_lshrrev_b32_e32 v138, 5, v0
		v_and_b32_e32 v138, 1, v138
		v_mov_b32_e32 v146, 4
		v_mul_lo_u32 v146, v146, v138
		v_xor_b32_e32 v138, 57, v146
		v_add_u32_e32 v138, s46, v138
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v138, a96
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v138, v135, v204, s[42:43]
		v_accvgpr_write_b32 a82, v138
		v_cndmask_b32_e64 v138, v135, v205, s[54:55]
		v_accvgpr_write_b32 a83, v138
		v_cndmask_b32_e64 v202, v135, v206, s[58:59]
		v_accvgpr_read_b32 v138, a97
		v_cmp_ge_i32_e64 vcc, v6, v138
		v_accvgpr_read_b32 v138, a213
		v_mov_b32_e32 v204, s86
		v_mov_b32_e32 v205, s87
		s_nop 0
		v_readfirstlane_b32 s42, v204
		v_readfirstlane_b32 s43, v205
		s_nop 1
		v_cndmask_b32_e64 v201, v135, v138, s[42:43]
		v_accvgpr_read_b32 v138, a214
		v_readfirstlane_b32 s42, v34
		v_readfirstlane_b32 s43, v35
		s_nop 1
		v_cndmask_b32_e64 v34, v135, v138, s[42:43]
		v_accvgpr_write_b32 a132, v34
		v_cndmask_b32_e32 v203, v135, v207, vcc
		v_lshrrev_b32_e32 v34, 5, v0
		v_and_b32_e32 v34, 1, v34
		v_mov_b32_e32 v35, 4
		v_mul_lo_u32 v35, v35, v34
		v_xor_b32_e32 v34, 64, v35
		v_add_u32_e32 v34, s46, v34
		v_cmp_ge_i32_e64 vcc, v6, v34
		s_mov_b64 s[42:43], vcc
		v_lshrrev_b32_e32 v34, 5, v0
		v_and_b32_e32 v34, 1, v34
		v_mov_b32_e32 v35, 4
		v_mul_lo_u32 v35, v35, v34
		v_xor_b32_e32 v34, 0x41, v35
		v_add_u32_e32 v34, s46, v34
		v_cmp_ge_i32_e64 vcc, v6, v34
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v34, a98
		v_cmp_ge_i32_e64 vcc, v6, v34
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v34, v135, v208, s[42:43]
		v_cndmask_b32_e64 v35, v135, v209, s[54:55]
		v_cndmask_b32_e64 v204, v135, v210, s[58:59]
		v_accvgpr_read_b32 v138, a99
		v_cmp_ge_i32_e64 vcc, v6, v138
		v_accvgpr_read_b32 v138, a216
		v_readfirstlane_b32 s42, v36
		v_readfirstlane_b32 s43, v37
		s_nop 1
		v_cndmask_b32_e64 v36, v135, v138, s[42:43]
		v_accvgpr_read_b32 v37, a217
		v_accvgpr_read_b32 v138, a134
		s_nop 0
		v_readfirstlane_b32 s42, v138
		v_accvgpr_read_b32 v138, a135
		s_nop 0
		v_readfirstlane_b32 s43, v138
		s_nop 1
		v_cndmask_b32_e64 v37, v135, v37, s[42:43]
		v_cndmask_b32_e32 v205, v135, v211, vcc
		v_lshrrev_b32_e32 v138, 5, v0
		v_and_b32_e32 v138, 1, v138
		v_mov_b32_e32 v146, 4
		v_mul_lo_u32 v146, v146, v138
		v_xor_b32_e32 v138, 0x48, v146
		v_add_u32_e32 v138, s46, v138
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[42:43], vcc
		v_lshrrev_b32_e32 v138, 5, v0
		v_and_b32_e32 v138, 1, v138
		v_mov_b32_e32 v146, 4
		v_mul_lo_u32 v146, v146, v138
		v_xor_b32_e32 v138, 0x49, v146
		v_add_u32_e32 v138, s46, v138
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v138, a100
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v206, v135, v212, s[42:43]
		v_cndmask_b32_e64 v207, v135, v213, s[54:55]
		v_cndmask_b32_e64 v208, v135, v214, s[58:59]
		v_accvgpr_read_b32 v138, a101
		v_cmp_ge_i32_e64 vcc, v6, v138
		v_accvgpr_read_b32 v138, a218
		v_accvgpr_read_b32 v146, a136
		s_nop 0
		v_readfirstlane_b32 s42, v146
		v_accvgpr_read_b32 v146, a137
		s_nop 0
		v_readfirstlane_b32 s43, v146
		s_nop 1
		v_cndmask_b32_e64 v138, v135, v138, s[42:43]
		v_accvgpr_write_b32 a138, v138
		v_accvgpr_read_b32 v138, a220
		v_accvgpr_read_b32 v146, a140
		s_nop 0
		v_readfirstlane_b32 s42, v146
		v_accvgpr_read_b32 v146, a141
		s_nop 0
		v_readfirstlane_b32 s43, v146
		s_nop 1
		v_cndmask_b32_e64 v210, v135, v138, s[42:43]
		v_cndmask_b32_e32 v209, v135, v215, vcc
		v_lshrrev_b32_e32 v138, 5, v0
		v_and_b32_e32 v138, 1, v138
		v_mov_b32_e32 v146, 4
		v_mul_lo_u32 v146, v146, v138
		v_xor_b32_e32 v138, 0x50, v146
		v_add_u32_e32 v138, s46, v138
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[42:43], vcc
		v_lshrrev_b32_e32 v138, 5, v0
		v_and_b32_e32 v138, 1, v138
		v_mov_b32_e32 v146, 4
		v_mul_lo_u32 v146, v146, v138
		v_xor_b32_e32 v138, 0x51, v146
		v_add_u32_e32 v138, s46, v138
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v138, a102
		v_cmp_ge_i32_e64 vcc, v6, v138
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v212, v135, v216, s[42:43]
		v_cndmask_b32_e64 v213, v135, v217, s[54:55]
		v_cndmask_b32_e64 v214, v135, v218, s[58:59]
		v_accvgpr_read_b32 v138, a103
		v_cmp_ge_i32_e64 vcc, v6, v138
		v_accvgpr_read_b32 v138, a221
		v_accvgpr_read_b32 v146, a142
		s_nop 0
		v_readfirstlane_b32 s42, v146
		v_accvgpr_read_b32 v146, a143
		s_nop 0
		v_readfirstlane_b32 s43, v146
		s_nop 1
		v_cndmask_b32_e64 v211, v135, v138, s[42:43]
		v_accvgpr_read_b32 v138, a222
		v_readfirstlane_b32 s42, v136
		v_readfirstlane_b32 s43, v137
		s_nop 1
		v_cndmask_b32_e64 v138, v135, v138, s[42:43]
		v_cndmask_b32_e32 v215, v135, v219, vcc
		v_lshrrev_b32_e32 v136, 5, v0
		v_and_b32_e32 v136, 1, v136
		v_mov_b32_e32 v137, 4
		v_mul_lo_u32 v137, v137, v136
		v_xor_b32_e32 v136, 0x58, v137
		v_add_u32_e32 v136, s46, v136
		v_cmp_ge_i32_e64 vcc, v6, v136
		s_mov_b64 s[42:43], vcc
		v_lshrrev_b32_e32 v136, 5, v0
		v_and_b32_e32 v136, 1, v136
		v_mov_b32_e32 v137, 4
		v_mul_lo_u32 v137, v137, v136
		v_xor_b32_e32 v136, 0x59, v137
		v_add_u32_e32 v136, s46, v136
		v_cmp_ge_i32_e64 vcc, v6, v136
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v136, a104
		v_cmp_ge_i32_e64 vcc, v6, v136
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v136, v135, v220, s[42:43]
		v_cndmask_b32_e64 v137, v135, v221, s[54:55]
		v_cndmask_b32_e64 v216, v135, v222, s[58:59]
		v_accvgpr_read_b32 v146, a105
		v_cmp_ge_i32_e64 vcc, v6, v146
		v_accvgpr_read_b32 v146, a224
		v_readfirstlane_b32 s42, v140
		v_readfirstlane_b32 s43, v141
		s_nop 1
		v_cndmask_b32_e64 v140, v135, v146, s[42:43]
		v_accvgpr_read_b32 v141, a225
		v_readfirstlane_b32 s42, v142
		v_readfirstlane_b32 s43, v143
		s_nop 1
		v_cndmask_b32_e64 v141, v135, v141, s[42:43]
		v_cndmask_b32_e32 v217, v135, v223, vcc
		v_cmp_ge_i32_e64 vcc, v6, v26
		s_mov_b64 s[42:43], vcc
		v_cmp_ge_i32_e64 vcc, v6, v31
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v26, a106
		v_cmp_ge_i32_e64 vcc, v6, v26
		s_mov_b64 s[58:59], vcc
		v_accvgpr_read_b32 v26, a240
		v_cndmask_b32_e64 v142, v135, v26, s[42:43]
		v_accvgpr_read_b32 v26, a241
		v_cndmask_b32_e64 v143, v135, v26, s[54:55]
		v_accvgpr_read_b32 v26, a242
		v_cndmask_b32_e64 v218, v135, v26, s[58:59]
		v_accvgpr_read_b32 v26, a107
		v_cmp_ge_i32_e64 vcc, v6, v26
		v_accvgpr_read_b32 v26, a226
		v_readfirstlane_b32 s42, v224
		v_readfirstlane_b32 s43, v225
		s_nop 1
		v_cndmask_b32_e64 v226, v135, v26, s[42:43]
		v_accvgpr_read_b32 v26, a228
		v_readfirstlane_b32 s42, v228
		v_readfirstlane_b32 s43, v229
		s_nop 1
		v_cndmask_b32_e64 v220, v135, v26, s[42:43]
		v_accvgpr_read_b32 v26, a243
		v_cndmask_b32_e32 v219, v135, v26, vcc
		v_cmp_ge_i32_e64 vcc, v6, v39
		s_mov_b64 s[42:43], vcc
		v_cmp_ge_i32_e64 vcc, v6, v147
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v26, a108
		v_cmp_ge_i32_e64 vcc, v6, v26
		s_mov_b64 s[58:59], vcc
		v_accvgpr_read_b32 v26, a244
		v_cndmask_b32_e64 v146, v135, v26, s[42:43]
		v_accvgpr_read_b32 v26, a245
		v_cndmask_b32_e64 v147, v135, v26, s[54:55]
		v_accvgpr_read_b32 v26, a246
		v_cndmask_b32_e64 v222, v135, v26, s[58:59]
		v_accvgpr_read_b32 v26, a109
		v_cmp_ge_i32_e64 vcc, v6, v26
		v_accvgpr_read_b32 v26, a229
		v_readfirstlane_b32 s42, v230
		v_readfirstlane_b32 s43, v231
		s_nop 1
		v_cndmask_b32_e64 v221, v135, v26, s[42:43]
		v_accvgpr_read_b32 v26, a230
		v_readfirstlane_b32 s42, v232
		v_readfirstlane_b32 s43, v233
		s_nop 1
		v_cndmask_b32_e64 v234, v135, v26, s[42:43]
		v_accvgpr_read_b32 v26, a247
		v_cndmask_b32_e32 v223, v135, v26, vcc
		v_cmp_ge_i32_e64 vcc, v6, v151
		s_mov_b64 s[42:43], vcc
		v_cmp_ge_i32_e64 vcc, v6, v155
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v26, a110
		v_cmp_ge_i32_e64 vcc, v6, v26
		s_mov_b64 s[58:59], vcc
		v_accvgpr_read_b32 v26, a248
		v_cndmask_b32_e64 v150, v135, v26, s[42:43]
		v_accvgpr_read_b32 v26, a249
		v_cndmask_b32_e64 v151, v135, v26, s[54:55]
		v_accvgpr_read_b32 v26, a250
		v_cndmask_b32_e64 v154, v135, v26, s[58:59]
		v_accvgpr_read_b32 v26, a111
		v_cmp_ge_i32_e64 vcc, v6, v26
		v_accvgpr_read_b32 v26, a232
		v_readfirstlane_b32 s42, v236
		v_readfirstlane_b32 s43, v237
		s_nop 1
		v_cndmask_b32_e64 v224, v135, v26, s[42:43]
		v_accvgpr_read_b32 v26, a233
		v_readfirstlane_b32 s42, v238
		v_readfirstlane_b32 s43, v239
		s_nop 1
		v_cndmask_b32_e64 v225, v135, v26, s[42:43]
		v_accvgpr_read_b32 v26, a251
		v_cndmask_b32_e32 v155, v135, v26, vcc
		v_cmp_ge_i32_e64 vcc, v6, v159
		s_mov_b64 s[42:43], vcc
		v_cmp_ge_i32_e64 vcc, v6, v170
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v26, a112
		v_cmp_ge_i32_e64 vcc, v6, v26
		s_mov_b64 s[58:59], vcc
		v_accvgpr_read_b32 v26, a252
		v_cndmask_b32_e64 v158, v135, v26, s[42:43]
		v_accvgpr_read_b32 v26, a253
		v_cndmask_b32_e64 v159, v135, v26, s[54:55]
		v_accvgpr_read_b32 v26, a254
		v_cndmask_b32_e64 v170, v135, v26, s[58:59]
		v_accvgpr_read_b32 v26, a113
		v_cmp_ge_i32_e64 vcc, v6, v26
		v_accvgpr_read_b32 v26, a234
		v_readfirstlane_b32 s42, v240
		v_readfirstlane_b32 s43, v241
		s_nop 1
		v_cndmask_b32_e64 v242, v135, v26, s[42:43]
		v_accvgpr_read_b32 v26, a236
		v_readfirstlane_b32 s42, v244
		v_readfirstlane_b32 s43, v245
		s_nop 1
		v_cndmask_b32_e64 v246, v135, v26, s[42:43]
		v_accvgpr_read_b32 v26, a255
		v_cndmask_b32_e32 v171, v135, v26, vcc
		v_max_f32_e32 v26, v254, v255
		v_accvgpr_read_b32 v31, a117
		v_accvgpr_read_b32 v39, a116
		v_max_f32_e32 v31, v39, v31
		v_max_f32_e32 v39, v176, v177
		v_accvgpr_read_b32 v135, a119
		v_accvgpr_read_b32 v228, a118
		v_max_f32_e32 v135, v228, v135
		v_max_f32_e32 v228, v184, v185
		v_accvgpr_read_b32 v229, a123
		v_accvgpr_read_b32 v230, a122
		v_max_f32_e32 v229, v230, v229
		v_max_f32_e32 v230, v188, v189
		v_accvgpr_read_b32 v231, a125
		v_accvgpr_read_b32 v232, a124
		v_max_f32_e32 v231, v232, v231
		v_max_f32_e32 v232, v196, v197
		v_accvgpr_read_b32 v233, a129
		v_accvgpr_read_b32 v236, a128
		v_max_f32_e32 v233, v236, v233
		v_max_f32_e32 v236, v200, v201
		v_accvgpr_read_b32 v237, a133
		v_accvgpr_read_b32 v238, a132
		v_max_f32_e32 v237, v238, v237
		v_max_f32_e32 v238, v36, v37
		v_accvgpr_read_b32 v239, a139
		v_accvgpr_read_b32 v240, a138
		v_max_f32_e32 v239, v240, v239
		v_max_f32_e32 v240, v210, v211
		v_max_f32_e32 v241, v138, v139
		v_max_f32_e32 v244, v140, v141
		v_accvgpr_write_b32 a84, v244
		v_max_f32_e32 v244, v226, v227
		v_accvgpr_write_b32 a85, v244
		v_max_f32_e32 v244, v220, v221
		v_accvgpr_write_b32 a86, v244
		v_max_f32_e32 v244, v234, v235
		v_accvgpr_write_b32 a87, v244
		v_max_f32_e32 v244, v224, v225
		v_accvgpr_write_b32 a88, v244
		v_max_f32_e32 v244, v242, v243
		v_accvgpr_write_b32 a89, v244
		v_max_f32_e32 v244, v246, v247
		v_accvgpr_write_b32 a90, v244
		v_max_f32_e32 v244, v248, v249
		v_accvgpr_write_b32 a91, v244
		v_max_f32_e32 v244, v250, v251
		v_accvgpr_write_b32 a92, v244
		v_max_f32_e32 v244, v160, v161
		v_accvgpr_write_b32 a93, v244
		v_max_f32_e32 v244, v162, v163
		v_accvgpr_write_b32 a94, v244
		v_max_f32_e32 v244, v164, v165
		v_accvgpr_write_b32 a95, v244
		v_max_f32_e32 v244, v166, v167
		v_accvgpr_write_b32 a96, v244
		v_max_f32_e32 v244, v168, v169
		v_accvgpr_write_b32 a97, v244
		v_max_f32_e32 v244, v252, v253
		v_accvgpr_write_b32 a98, v244
		v_max_f32_e32 v244, v172, v173
		v_max_f32_e32 v26, v26, v31
		v_max_f32_e32 v31, v39, v135
		v_max_f32_e32 v39, v228, v229
		v_max_f32_e32 v135, v230, v231
		v_max_f32_e32 v228, v232, v233
		v_max_f32_e32 v229, v236, v237
		v_max_f32_e32 v230, v238, v239
		v_max_f32_e32 v231, v240, v241
		v_accvgpr_read_b32 v232, a84
		v_accvgpr_read_b32 v233, a85
		v_max_f32_e32 v232, v232, v233
		v_accvgpr_read_b32 v233, a86
		v_accvgpr_read_b32 v236, a87
		v_max_f32_e32 v233, v233, v236
		v_accvgpr_read_b32 v236, a88
		v_accvgpr_read_b32 v237, a89
		v_max_f32_e32 v236, v236, v237
		v_accvgpr_read_b32 v237, a90
		v_accvgpr_read_b32 v238, a91
		v_max_f32_e32 v237, v237, v238
		v_accvgpr_read_b32 v238, a92
		v_accvgpr_read_b32 v239, a93
		v_max_f32_e32 v238, v238, v239
		v_accvgpr_read_b32 v239, a94
		v_accvgpr_read_b32 v240, a95
		v_max_f32_e32 v239, v239, v240
		v_accvgpr_read_b32 v240, a96
		v_accvgpr_read_b32 v241, a97
		v_max_f32_e32 v240, v240, v241
		v_accvgpr_read_b32 v241, a98
		v_max_f32_e32 v241, v241, v244
		v_max_f32_e32 v26, v26, v31
		v_max_f32_e32 v31, v39, v135
		v_max_f32_e32 v39, v228, v229
		v_max_f32_e32 v135, v230, v231
		v_max_f32_e32 v228, v232, v233
		v_max_f32_e32 v229, v236, v237
		v_max_f32_e32 v230, v238, v239
		v_max_f32_e32 v231, v240, v241
		v_max_f32_e32 v26, v26, v31
		v_max_f32_e32 v31, v39, v135
		v_max_f32_e32 v39, v228, v229
		v_max_f32_e32 v135, v230, v231
		v_max_f32_e32 v26, v26, v31
		v_max_f32_e32 v31, v39, v135
		v_max_f32_e32 v26, v26, v31
		v_and_b32_e32 v31, 1, v8
		v_lshrrev_b32_e32 v39, 4, v8
		v_and_b32_e32 v39, 1, v39
		v_lshlrev_b32_e32 v39, 4, v39
		v_lshrrev_b32_e32 v135, 3, v8
		v_and_b32_e32 v135, 1, v135
		v_lshlrev_b32_e32 v135, 3, v135
		v_add3_u32 v31, v31, v39, v135
		v_lshrrev_b32_e32 v39, 2, v8
		v_and_b32_e32 v39, 1, v39
		v_lshlrev_b32_e32 v39, 2, v39
		v_lshrrev_b32_e32 v135, 1, v8
		v_and_b32_e32 v135, 1, v135
		v_lshlrev_b32_e32 v135, 1, v135
		v_add3_u32 v31, v31, v39, v135
		v_lshlrev_b32_e32 v31, 2, v31
		ds_bpermute_b32 v39, v31, v26
		v_lshrrev_b32_e32 v135, 4, v8
		v_and_b32_e32 v135, 1, v135
		v_lshlrev_b32_e32 v135, 4, v135
		v_lshrrev_b32_e32 v228, 3, v8
		v_and_b32_e32 v228, 1, v228
		v_lshlrev_b32_e32 v228, 3, v228
		v_lshrrev_b32_e32 v229, 2, v8
		v_and_b32_e32 v229, 1, v229
		v_lshlrev_b32_e32 v229, 2, v229
		v_and_b32_e32 v230, 1, v8
		v_add_u32_e32 v230, 32, v230
		v_lshrrev_b32_e32 v231, 1, v8
		v_and_b32_e32 v231, 1, v231
		v_lshlrev_b32_e32 v231, 1, v231
		v_bitop3_b32 v229, v229, v230, v231 bitop3:0x96
		v_bitop3_b32 v135, v135, v228, v229 bitop3:0x96
		v_lshlrev_b32_e32 v135, 2, v135
		ds_bpermute_b32 v228, v135, v26
		v_max_f32_e32 v26, v144, v145
		v_max_f32_e32 v229, v174, v175
		v_max_f32_e32 v230, v178, v179
		v_max_f32_e32 v231, v180, v181
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v232, v39, v228
		v_max_f32_e32 v39, v148, v149
		v_max_f32_e32 v228, v182, v183
		v_max_f32_e32 v233, v152, v153
		v_max_f32_e32 v236, v186, v187
		v_max_f32_e32 v237, v190, v191
		v_max_f32_e32 v238, v192, v193
		v_max_f32_e32 v239, v156, v157
		v_max_f32_e32 v240, v194, v195
		v_accvgpr_read_b32 v241, a80
		v_accvgpr_read_b32 v244, a81
		v_max_f32_e32 v241, v241, v244
		v_accvgpr_write_b32 a84, v241
		v_max_f32_e32 v241, v198, v199
		v_accvgpr_write_b32 a85, v241
		v_accvgpr_read_b32 v241, a82
		v_accvgpr_read_b32 v244, a83
		v_max_f32_e32 v241, v241, v244
		v_accvgpr_write_b32 a86, v241
		v_max_f32_e32 v241, v202, v203
		v_max_f32_e32 v244, v34, v35
		v_accvgpr_write_b32 a87, v244
		v_max_f32_e32 v244, v204, v205
		v_accvgpr_write_b32 a88, v244
		v_max_f32_e32 v244, v206, v207
		v_accvgpr_write_b32 a89, v244
		v_max_f32_e32 v244, v208, v209
		v_accvgpr_write_b32 a90, v244
		v_max_f32_e32 v244, v212, v213
		v_accvgpr_write_b32 a91, v244
		v_max_f32_e32 v244, v214, v215
		v_accvgpr_write_b32 a92, v244
		v_max_f32_e32 v244, v136, v137
		v_accvgpr_write_b32 a93, v244
		v_max_f32_e32 v244, v216, v217
		v_accvgpr_write_b32 a94, v244
		v_max_f32_e32 v244, v142, v143
		v_accvgpr_write_b32 a95, v244
		v_max_f32_e32 v244, v218, v219
		v_accvgpr_write_b32 a96, v244
		v_max_f32_e32 v244, v146, v147
		v_accvgpr_write_b32 a97, v244
		v_max_f32_e32 v244, v222, v223
		v_accvgpr_write_b32 a98, v244
		v_max_f32_e32 v244, v150, v151
		v_accvgpr_write_b32 a99, v244
		v_max_f32_e32 v244, v154, v155
		v_accvgpr_write_b32 a100, v244
		v_max_f32_e32 v244, v158, v159
		v_accvgpr_write_b32 a101, v244
		v_max_f32_e32 v244, v170, v171
		v_max_f32_e32 v26, v26, v229
		v_max_f32_e32 v229, v230, v231
		v_max_f32_e32 v39, v39, v228
		v_max_f32_e32 v228, v233, v236
		v_max_f32_e32 v230, v237, v238
		v_max_f32_e32 v231, v239, v240
		v_accvgpr_read_b32 v233, a84
		v_accvgpr_read_b32 v236, a85
		v_max_f32_e32 v233, v233, v236
		v_accvgpr_read_b32 v236, a86
		v_max_f32_e32 v236, v236, v241
		v_accvgpr_read_b32 v237, a87
		v_accvgpr_read_b32 v238, a88
		v_max_f32_e32 v237, v237, v238
		v_accvgpr_read_b32 v238, a89
		v_accvgpr_read_b32 v239, a90
		v_max_f32_e32 v238, v238, v239
		v_accvgpr_read_b32 v239, a91
		v_accvgpr_read_b32 v240, a92
		v_max_f32_e32 v239, v239, v240
		v_accvgpr_write_b32 a84, v239
		v_accvgpr_read_b32 v239, a93
		v_accvgpr_read_b32 v240, a94
		v_max_f32_e32 v239, v239, v240
		v_accvgpr_read_b32 v240, a95
		v_accvgpr_read_b32 v241, a96
		v_max_f32_e32 v240, v240, v241
		v_accvgpr_write_b32 a85, v240
		v_accvgpr_read_b32 v240, a97
		v_accvgpr_read_b32 v241, a98
		v_max_f32_e32 v240, v240, v241
		v_accvgpr_write_b32 a86, v240
		v_accvgpr_read_b32 v240, a99
		v_accvgpr_read_b32 v241, a100
		v_max_f32_e32 v240, v240, v241
		v_accvgpr_read_b32 v241, a101
		v_max_f32_e32 v241, v241, v244
		v_max_f32_e32 v26, v26, v229
		v_max_f32_e32 v39, v39, v228
		v_max_f32_e32 v228, v230, v231
		v_max_f32_e32 v229, v233, v236
		v_max_f32_e32 v230, v237, v238
		v_accvgpr_read_b32 v231, a84
		v_max_f32_e32 v231, v231, v239
		v_accvgpr_read_b32 v233, a85
		v_accvgpr_read_b32 v236, a86
		v_max_f32_e32 v233, v233, v236
		v_max_f32_e32 v236, v240, v241
		v_max_f32_e32 v26, v26, v39
		v_max_f32_e32 v39, v228, v229
		v_max_f32_e32 v228, v230, v231
		v_max_f32_e32 v229, v233, v236
		v_max_f32_e32 v26, v26, v39
		v_max_f32_e32 v39, v228, v229
		v_max_f32_e32 v26, v26, v39
		ds_bpermute_b32 v39, v31, v26
		ds_bpermute_b32 v228, v135, v26
		v_mov_b32_e32 v230, 0x3e38aa3b
		v_mov_b32_e32 v231, 0x3e38aa3b
		v_pk_mul_f32 v[236:237], v[254:255], v[230:231]
		v_accvgpr_read_b32 v238, a116
		v_accvgpr_read_b32 v239, a117
		v_pk_mul_f32 v[240:241], v[238:239], v[230:231]
		v_pk_mul_f32 v[238:239], v[176:177], v[230:231]
		v_accvgpr_read_b32 v176, a118
		v_accvgpr_read_b32 v177, a119
		v_pk_mul_f32 v[244:245], v[176:177], v[230:231]
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v233, v39, v228
		v_pk_mul_f32 v[176:177], v[232:233], v[230:231]
		s_mov_b32 m0, s17
		v_max_f32_e32 v20, v20, v176
		ds_write_addtid_b32 v20 offset:13312
		s_mov_b32 m0, s17
		v_max_f32_e32 v26, v19, v177
		ds_write_addtid_b32 v26 offset:14336
		v_pk_mul_f32 v[176:177], v[184:185], v[230:231]
		v_accvgpr_read_b32 v184, a122
		v_accvgpr_read_b32 v185, a123
		v_pk_mul_f32 v[228:229], v[184:185], v[230:231]
		v_pk_mul_f32 v[184:185], v[188:189], v[230:231]
		v_accvgpr_read_b32 v188, a124
		v_accvgpr_read_b32 v189, a125
		v_pk_mul_f32 v[232:233], v[188:189], v[230:231]
		v_pk_mul_f32 v[188:189], v[196:197], v[230:231]
		v_accvgpr_write_b32 a84, v188
		v_accvgpr_write_b32 a85, v189
		v_accvgpr_read_b32 v188, a128
		v_accvgpr_read_b32 v189, a129
		v_pk_mul_f32 v[196:197], v[188:189], v[230:231]
		v_pk_mul_f32 v[188:189], v[200:201], v[230:231]
		v_accvgpr_write_b32 a86, v188
		v_accvgpr_write_b32 a87, v189
		v_accvgpr_read_b32 v188, a132
		v_accvgpr_read_b32 v189, a133
		v_pk_mul_f32 v[200:201], v[188:189], v[230:231]
		v_pk_mul_f32 v[36:37], v[36:37], v[230:231]
		v_accvgpr_write_b32 a88, v36
		v_accvgpr_write_b32 a89, v37
		v_accvgpr_read_b32 v36, a138
		v_accvgpr_read_b32 v37, a139
		v_pk_mul_f32 v[188:189], v[36:37], v[230:231]
		v_pk_mul_f32 v[36:37], v[210:211], v[230:231]
		v_pk_mul_f32 v[210:211], v[138:139], v[230:231]
		v_pk_mul_f32 v[138:139], v[140:141], v[230:231]
		v_pk_mul_f32 v[140:141], v[226:227], v[230:231]
		v_pk_mul_f32 v[226:227], v[220:221], v[230:231]
		v_pk_mul_f32 v[220:221], v[234:235], v[230:231]
		v_pk_mul_f32 v[234:235], v[224:225], v[230:231]
		v_pk_mul_f32 v[224:225], v[242:243], v[230:231]
		v_pk_mul_f32 v[242:243], v[246:247], v[230:231]
		v_pk_mul_f32 v[246:247], v[248:249], v[230:231]
		v_pk_mul_f32 v[248:249], v[250:251], v[230:231]
		v_pk_mul_f32 v[250:251], v[160:161], v[230:231]
		v_pk_mul_f32 v[160:161], v[162:163], v[230:231]
		v_pk_mul_f32 v[162:163], v[164:165], v[230:231]
		v_pk_mul_f32 v[164:165], v[166:167], v[230:231]
		v_pk_mul_f32 v[166:167], v[168:169], v[230:231]
		v_pk_mul_f32 v[168:169], v[252:253], v[230:231]
		v_pk_mul_f32 v[252:253], v[172:173], v[230:231]
		v_pk_mul_f32 v[172:173], v[144:145], v[230:231]
		v_pk_mul_f32 v[144:145], v[174:175], v[230:231]
		v_pk_mul_f32 v[174:175], v[178:179], v[230:231]
		v_pk_mul_f32 v[178:179], v[180:181], v[230:231]
		v_pk_mul_f32 v[180:181], v[148:149], v[230:231]
		v_pk_mul_f32 v[148:149], v[182:183], v[230:231]
		v_pk_mul_f32 v[182:183], v[152:153], v[230:231]
		v_pk_mul_f32 v[152:153], v[186:187], v[230:231]
		v_pk_mul_f32 v[186:187], v[190:191], v[230:231]
		v_pk_mul_f32 v[190:191], v[192:193], v[230:231]
		v_pk_mul_f32 v[192:193], v[156:157], v[230:231]
		v_pk_mul_f32 v[156:157], v[194:195], v[230:231]
		v_accvgpr_write_b32 a90, v156
		v_accvgpr_write_b32 a91, v157
		v_accvgpr_read_b32 v156, a80
		v_accvgpr_read_b32 v157, a81
		v_pk_mul_f32 v[194:195], v[156:157], v[230:231]
		v_pk_mul_f32 v[156:157], v[198:199], v[230:231]
		v_accvgpr_write_b32 a80, v156
		v_accvgpr_write_b32 a81, v157
		v_accvgpr_read_b32 v156, a82
		v_accvgpr_read_b32 v157, a83
		v_pk_mul_f32 v[198:199], v[156:157], v[230:231]
		v_pk_mul_f32 v[156:157], v[202:203], v[230:231]
		v_pk_mul_f32 v[202:203], v[34:35], v[230:231]
		v_pk_mul_f32 v[34:35], v[204:205], v[230:231]
		v_pk_mul_f32 v[204:205], v[206:207], v[230:231]
		v_pk_mul_f32 v[206:207], v[208:209], v[230:231]
		v_pk_mul_f32 v[208:209], v[212:213], v[230:231]
		v_pk_mul_f32 v[212:213], v[214:215], v[230:231]
		v_pk_mul_f32 v[214:215], v[136:137], v[230:231]
		v_pk_mul_f32 v[136:137], v[216:217], v[230:231]
		v_pk_mul_f32 v[216:217], v[142:143], v[230:231]
		v_pk_mul_f32 v[142:143], v[218:219], v[230:231]
		v_pk_mul_f32 v[218:219], v[146:147], v[230:231]
		v_pk_mul_f32 v[146:147], v[222:223], v[230:231]
		v_pk_mul_f32 v[222:223], v[150:151], v[230:231]
		v_pk_mul_f32 v[150:151], v[154:155], v[230:231]
		v_pk_mul_f32 v[154:155], v[158:159], v[230:231]
		v_pk_mul_f32 v[158:159], v[170:171], v[230:231]
		v_sub_f32_e32 v39, v236, v20
		v_sub_f32_e32 v170, v237, v20
		v_sub_f32_e32 v171, v240, v20
		v_sub_f32_e32 v230, v241, v20
		v_sub_f32_e32 v231, v238, v20
		v_sub_f32_e32 v236, v239, v20
		v_sub_f32_e32 v237, v244, v20
		v_sub_f32_e32 v238, v245, v20
		v_sub_f32_e32 v176, v176, v20
		v_sub_f32_e32 v177, v177, v20
		v_sub_f32_e32 v228, v228, v20
		v_sub_f32_e32 v229, v229, v20
		v_sub_f32_e32 v184, v184, v20
		v_sub_f32_e32 v185, v185, v20
		v_sub_f32_e32 v232, v232, v20
		v_sub_f32_e32 v233, v233, v20
		v_accvgpr_read_b32 v239, a84
		v_sub_f32_e32 v239, v239, v20
		v_accvgpr_read_b32 v240, a85
		v_sub_f32_e32 v240, v240, v20
		v_sub_f32_e32 v196, v196, v20
		v_sub_f32_e32 v197, v197, v20
		v_accvgpr_read_b32 v241, a86
		v_sub_f32_e32 v241, v241, v20
		v_accvgpr_read_b32 v244, a87
		v_sub_f32_e32 v244, v244, v20
		v_sub_f32_e32 v200, v200, v20
		v_sub_f32_e32 v201, v201, v20
		v_accvgpr_read_b32 v245, a88
		v_sub_f32_e32 v245, v245, v20
		v_accvgpr_write_b32 a82, v245
		v_accvgpr_read_b32 v245, a89
		v_sub_f32_e32 v245, v245, v20
		v_sub_f32_e32 v188, v188, v20
		v_sub_f32_e32 v189, v189, v20
		v_sub_f32_e32 v36, v36, v20
		v_sub_f32_e32 v37, v37, v20
		v_sub_f32_e32 v210, v210, v20
		v_sub_f32_e32 v211, v211, v20
		v_sub_f32_e32 v138, v138, v20
		v_sub_f32_e32 v139, v139, v20
		v_sub_f32_e32 v140, v140, v20
		v_sub_f32_e32 v141, v141, v20
		v_sub_f32_e32 v226, v226, v20
		v_sub_f32_e32 v227, v227, v20
		v_sub_f32_e32 v220, v220, v20
		v_sub_f32_e32 v221, v221, v20
		v_sub_f32_e32 v234, v234, v20
		v_sub_f32_e32 v235, v235, v20
		v_sub_f32_e32 v224, v224, v20
		v_sub_f32_e32 v225, v225, v20
		v_sub_f32_e32 v242, v242, v20
		v_sub_f32_e32 v243, v243, v20
		v_sub_f32_e32 v246, v246, v20
		v_sub_f32_e32 v247, v247, v20
		v_sub_f32_e32 v248, v248, v20
		v_sub_f32_e32 v249, v249, v20
		v_sub_f32_e32 v250, v250, v20
		v_sub_f32_e32 v251, v251, v20
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
		v_sub_f32_e32 v252, v252, v20
		v_sub_f32_e32 v253, v253, v20
		v_sub_f32_e32 v172, v172, v26
		v_sub_f32_e32 v173, v173, v26
		v_sub_f32_e32 v144, v144, v26
		v_sub_f32_e32 v145, v145, v26
		v_sub_f32_e32 v174, v174, v26
		v_sub_f32_e32 v175, v175, v26
		v_sub_f32_e32 v178, v178, v26
		v_sub_f32_e32 v179, v179, v26
		v_sub_f32_e32 v180, v180, v26
		v_sub_f32_e32 v181, v181, v26
		v_sub_f32_e32 v148, v148, v26
		v_sub_f32_e32 v149, v149, v26
		v_sub_f32_e32 v182, v182, v26
		v_sub_f32_e32 v183, v183, v26
		v_sub_f32_e32 v152, v152, v26
		v_sub_f32_e32 v153, v153, v26
		v_sub_f32_e32 v186, v186, v26
		v_sub_f32_e32 v187, v187, v26
		v_sub_f32_e32 v190, v190, v26
		v_sub_f32_e32 v191, v191, v26
		v_sub_f32_e32 v192, v192, v26
		v_sub_f32_e32 v193, v193, v26
		v_accvgpr_write_b32 a83, v193
		v_accvgpr_read_b32 v193, a90
		v_sub_f32_e32 v193, v193, v26
		v_accvgpr_write_b32 a84, v193
		v_accvgpr_read_b32 v193, a91
		v_sub_f32_e32 v193, v193, v26
		v_sub_f32_e32 v194, v194, v26
		v_sub_f32_e32 v195, v195, v26
		v_accvgpr_write_b32 a85, v195
		v_accvgpr_read_b32 v195, a80
		v_sub_f32_e32 v195, v195, v26
		v_accvgpr_write_b32 a80, v195
		v_accvgpr_read_b32 v195, a81
		v_sub_f32_e32 v195, v195, v26
		v_sub_f32_e32 v198, v198, v26
		v_sub_f32_e32 v199, v199, v26
		v_sub_f32_e32 v156, v156, v26
		v_sub_f32_e32 v157, v157, v26
		v_sub_f32_e32 v202, v202, v26
		v_sub_f32_e32 v203, v203, v26
		v_sub_f32_e32 v34, v34, v26
		v_sub_f32_e32 v35, v35, v26
		v_sub_f32_e32 v204, v204, v26
		v_sub_f32_e32 v205, v205, v26
		v_sub_f32_e32 v206, v206, v26
		v_sub_f32_e32 v207, v207, v26
		v_sub_f32_e32 v208, v208, v26
		v_sub_f32_e32 v209, v209, v26
		v_sub_f32_e32 v212, v212, v26
		v_sub_f32_e32 v213, v213, v26
		v_sub_f32_e32 v214, v214, v26
		v_sub_f32_e32 v215, v215, v26
		v_sub_f32_e32 v136, v136, v26
		v_sub_f32_e32 v137, v137, v26
		v_sub_f32_e32 v216, v216, v26
		v_sub_f32_e32 v217, v217, v26
		v_sub_f32_e32 v142, v142, v26
		v_sub_f32_e32 v143, v143, v26
		v_sub_f32_e32 v218, v218, v26
		v_sub_f32_e32 v219, v219, v26
		v_sub_f32_e32 v146, v146, v26
		v_sub_f32_e32 v147, v147, v26
		v_sub_f32_e32 v222, v222, v26
		v_sub_f32_e32 v223, v223, v26
		v_sub_f32_e32 v150, v150, v26
		v_sub_f32_e32 v151, v151, v26
		v_sub_f32_e32 v154, v154, v26
		v_sub_f32_e32 v155, v155, v26
		v_sub_f32_e32 v158, v158, v26
		v_sub_f32_e32 v159, v159, v26
		v_exp_f32_e32 v39, v39
		s_nop 0
		v_accvgpr_write_b32 a86, v39
		v_exp_f32_e32 v254, v170
		v_exp_f32_e32 v39, v171
		s_nop 0
		v_accvgpr_write_b32 a87, v39
		s_mov_b32 m0, s17
		v_exp_f32_e32 v255, v230
		ds_write_addtid_b32 v255 offset:15360
		v_exp_f32_e32 v39, v231
		s_nop 0
		v_accvgpr_write_b32 a88, v39
		s_mov_b32 m0, s17
		v_exp_f32_e32 v170, v236
		ds_write_addtid_b32 v170 offset:18432
		v_exp_f32_e32 v39, v237
		s_nop 0
		v_accvgpr_write_b32 a89, v39
		s_mov_b32 m0, s17
		v_exp_f32_e32 v171, v238
		ds_write_addtid_b32 v171 offset:19456
		s_mov_b32 m0, s17
		v_exp_f32_e32 v230, v176
		ds_write_addtid_b32 v230 offset:20480
		s_mov_b32 m0, s17
		v_exp_f32_e32 v236, v177
		ds_write_addtid_b32 v236 offset:22528
		s_mov_b32 m0, s17
		v_exp_f32_e32 v231, v228
		ds_write_addtid_b32 v231 offset:21504
		s_mov_b32 m0, s17
		v_exp_f32_e32 v237, v229
		ds_write_addtid_b32 v237 offset:23552
		s_mov_b32 m0, s17
		v_exp_f32_e32 v176, v184
		ds_write_addtid_b32 v176 offset:24576
		s_mov_b32 m0, s17
		v_exp_f32_e32 v228, v185
		ds_write_addtid_b32 v228 offset:26624
		s_mov_b32 m0, s17
		v_exp_f32_e32 v177, v232
		ds_write_addtid_b32 v177 offset:25600
		s_mov_b32 m0, s17
		v_exp_f32_e32 v229, v233
		ds_write_addtid_b32 v229 offset:27648
		v_exp_f32_e32 v184, v239
		v_exp_f32_e32 v232, v240
		v_exp_f32_e32 v185, v196
		v_exp_f32_e32 v233, v197
		v_exp_f32_e32 v196, v241
		v_exp_f32_e32 v238, v244
		v_exp_f32_e32 v197, v200
		v_exp_f32_e32 v239, v201
		v_accvgpr_read_b32 v39, a82
		v_exp_f32_e32 v200, v39
		v_exp_f32_e32 v240, v245
		v_exp_f32_e32 v201, v188
		v_exp_f32_e32 v241, v189
		v_exp_f32_e32 v188, v36
		v_exp_f32_e32 v244, v37
		v_exp_f32_e32 v189, v210
		v_exp_f32_e32 v245, v211
		v_exp_f32_e32 v36, v138
		v_exp_f32_e32 v210, v139
		v_exp_f32_e32 v37, v140
		v_exp_f32_e32 v211, v141
		v_exp_f32_e32 v138, v226
		v_exp_f32_e32 v140, v227
		v_exp_f32_e32 v139, v220
		v_exp_f32_e32 v141, v221
		v_exp_f32_e32 v220, v234
		v_exp_f32_e32 v226, v235
		v_exp_f32_e32 v221, v224
		v_exp_f32_e32 v227, v225
		v_exp_f32_e32 v224, v242
		v_exp_f32_e32 v234, v243
		v_exp_f32_e32 v225, v246
		v_exp_f32_e32 v235, v247
		v_exp_f32_e32 v242, v248
		v_exp_f32_e32 v246, v249
		v_exp_f32_e32 v243, v250
		v_exp_f32_e32 v247, v251
		v_exp_f32_e32 v248, v160
		v_exp_f32_e32 v250, v161
		v_exp_f32_e32 v249, v162
		v_exp_f32_e32 v251, v163
		v_exp_f32_e32 v160, v164
		v_exp_f32_e32 v162, v165
		v_exp_f32_e32 v161, v166
		v_exp_f32_e32 v163, v167
		v_exp_f32_e32 v164, v168
		v_exp_f32_e32 v166, v169
		v_exp_f32_e32 v165, v252
		v_exp_f32_e32 v167, v253
		v_exp_f32_e32 v39, v172
		s_nop 0
		v_accvgpr_write_b32 a91, v39
		v_exp_f32_e32 v39, v173
		s_nop 0
		v_accvgpr_write_b32 a93, v39
		v_exp_f32_e32 v168, v144
		v_exp_f32_e32 v172, v145
		v_exp_f32_e32 v169, v174
		v_exp_f32_e32 v173, v175
		v_exp_f32_e32 v144, v178
		v_exp_f32_e32 v174, v179
		v_exp_f32_e32 v145, v180
		v_exp_f32_e32 v175, v181
		v_exp_f32_e32 v178, v148
		v_exp_f32_e32 v180, v149
		v_exp_f32_e32 v179, v182
		v_exp_f32_e32 v181, v183
		v_exp_f32_e32 v148, v152
		v_exp_f32_e32 v182, v153
		v_exp_f32_e32 v149, v186
		v_exp_f32_e32 v183, v187
		v_exp_f32_e32 v152, v190
		v_exp_f32_e32 v186, v191
		v_exp_f32_e32 v153, v192
		v_accvgpr_read_b32 v39, a83
		v_exp_f32_e32 v187, v39
		v_accvgpr_read_b32 v39, a84
		v_exp_f32_e32 v39, v39
		s_nop 0
		v_accvgpr_write_b32 a82, v39
		v_exp_f32_e32 v190, v193
		v_exp_f32_e32 v39, v194
		s_nop 0
		v_accvgpr_write_b32 a83, v39
		v_accvgpr_read_b32 v39, a85
		v_exp_f32_e32 v191, v39
		v_accvgpr_read_b32 v39, a80
		v_exp_f32_e32 v192, v39
		v_exp_f32_e32 v252, v195
		v_exp_f32_e32 v193, v198
		v_exp_f32_e32 v253, v199
		v_exp_f32_e32 v194, v156
		v_exp_f32_e32 v198, v157
		v_exp_f32_e32 v195, v202
		v_exp_f32_e32 v199, v203
		v_exp_f32_e32 v156, v34
		v_exp_f32_e32 v202, v35
		v_exp_f32_e32 v157, v204
		v_exp_f32_e32 v203, v205
		v_exp_f32_e32 v34, v206
		v_exp_f32_e32 v204, v207
		v_exp_f32_e32 v35, v208
		v_exp_f32_e32 v205, v209
		v_exp_f32_e32 v206, v212
		v_exp_f32_e32 v208, v213
		v_exp_f32_e32 v207, v214
		v_exp_f32_e32 v209, v215
		v_exp_f32_e32 v212, v136
		v_exp_f32_e32 v214, v137
		v_exp_f32_e32 v213, v216
		v_exp_f32_e32 v215, v217
		v_exp_f32_e32 v136, v142
		v_exp_f32_e32 v216, v143
		v_exp_f32_e32 v137, v218
		v_exp_f32_e32 v217, v219
		v_exp_f32_e32 v142, v146
		v_exp_f32_e32 v218, v147
		v_exp_f32_e32 v143, v222
		v_exp_f32_e32 v219, v223
		v_exp_f32_e32 v39, v150
		s_nop 0
		v_accvgpr_write_b32 a80, v39
		v_exp_f32_e32 v146, v151
		v_exp_f32_e32 v39, v154
		s_nop 0
		v_accvgpr_write_b32 a81, v39
		v_exp_f32_e32 v147, v155
		v_exp_f32_e32 v39, v158
		s_nop 0
		v_accvgpr_write_b32 a84, v39
		v_exp_f32_e32 v39, v159
		s_nop 0
		v_accvgpr_write_b32 a94, v39
		v_accvgpr_read_b32 v150, a86
		v_accvgpr_read_b32 v151, a87
		v_pk_add_f32 v[150:151], v[150:151], v[254:255]
		v_accvgpr_write_b32 a96, v150
		v_accvgpr_write_b32 a97, v151
		v_accvgpr_read_b32 v150, a88
		v_accvgpr_read_b32 v151, a89
		v_pk_add_f32 v[154:155], v[150:151], v[170:171]
		v_pk_add_f32 v[150:151], v[230:231], v[236:237]
		v_accvgpr_write_b32 a98, v150
		v_accvgpr_write_b32 a99, v151
		v_pk_add_f32 v[150:151], v[176:177], v[228:229]
		v_accvgpr_write_b32 a100, v150
		v_accvgpr_write_b32 a101, v151
		v_pk_add_f32 v[150:151], v[184:185], v[232:233]
		v_accvgpr_write_b32 a102, v150
		v_accvgpr_write_b32 a103, v151
		v_pk_add_f32 v[150:151], v[196:197], v[238:239]
		v_accvgpr_write_b32 a104, v150
		v_accvgpr_write_b32 a105, v151
		v_pk_add_f32 v[150:151], v[200:201], v[240:241]
		v_accvgpr_write_b32 a106, v150
		v_accvgpr_write_b32 a107, v151
		v_pk_add_f32 v[150:151], v[188:189], v[244:245]
		v_accvgpr_write_b32 a108, v150
		v_accvgpr_write_b32 a109, v151
		v_pk_add_f32 v[150:151], v[36:37], v[210:211]
		v_accvgpr_write_b32 a110, v150
		v_accvgpr_write_b32 a111, v151
		v_pk_add_f32 v[150:151], v[138:139], v[140:141]
		v_accvgpr_write_b32 a112, v150
		v_accvgpr_write_b32 a113, v151
		v_pk_add_f32 v[150:151], v[220:221], v[226:227]
		v_accvgpr_write_b32 a114, v150
		v_accvgpr_write_b32 a115, v151
		v_pk_add_f32 v[150:151], v[224:225], v[234:235]
		v_accvgpr_write_b32 a116, v150
		v_accvgpr_write_b32 a117, v151
		v_pk_add_f32 v[150:151], v[242:243], v[246:247]
		v_accvgpr_write_b32 a118, v150
		v_accvgpr_write_b32 a119, v151
		v_pk_add_f32 v[150:151], v[248:249], v[250:251]
		v_accvgpr_write_b32 a120, v150
		v_accvgpr_write_b32 a121, v151
		v_pk_add_f32 v[150:151], v[160:161], v[162:163]
		v_accvgpr_write_b32 a122, v150
		v_accvgpr_write_b32 a123, v151
		v_pk_add_f32 v[150:151], v[164:165], v[166:167]
		v_accvgpr_write_b32 a124, v150
		v_accvgpr_write_b32 a125, v151
		v_accvgpr_read_b32 v39, a97
		v_accvgpr_write_b32 a126, v39
		v_mov_b32_e32 v39, v155
		v_accvgpr_write_b32 a127, v39
		v_accvgpr_read_b32 v39, a96
		v_accvgpr_write_b32 a96, v39
		v_mov_b32_e32 v39, v154
		v_accvgpr_write_b32 a97, v39
		v_accvgpr_read_b32 v150, a126
		v_accvgpr_read_b32 v151, a127
		v_accvgpr_read_b32 v154, a96
		v_accvgpr_read_b32 v155, a97
		v_pk_add_f32 v[150:151], v[154:155], v[150:151]
		v_accvgpr_write_b32 a96, v150
		v_accvgpr_write_b32 a97, v151
		v_accvgpr_read_b32 v39, a99
		v_mov_b32_e32 v150, v39
		v_accvgpr_read_b32 v39, a101
		v_mov_b32_e32 v151, v39
		v_accvgpr_read_b32 v39, a98
		v_mov_b32_e32 v154, v39
		v_accvgpr_read_b32 v39, a100
		v_mov_b32_e32 v155, v39
		v_pk_add_f32 v[150:151], v[154:155], v[150:151]
		v_accvgpr_write_b32 a98, v150
		v_accvgpr_write_b32 a99, v151
		v_accvgpr_read_b32 v39, a103
		v_mov_b32_e32 v150, v39
		v_accvgpr_read_b32 v39, a105
		v_mov_b32_e32 v151, v39
		v_accvgpr_read_b32 v39, a102
		v_mov_b32_e32 v154, v39
		v_accvgpr_read_b32 v39, a104
		v_mov_b32_e32 v155, v39
		v_pk_add_f32 v[150:151], v[154:155], v[150:151]
		v_accvgpr_write_b32 a100, v150
		v_accvgpr_write_b32 a101, v151
		v_accvgpr_read_b32 v39, a107
		v_mov_b32_e32 v150, v39
		v_accvgpr_read_b32 v39, a109
		v_mov_b32_e32 v151, v39
		v_accvgpr_read_b32 v39, a106
		v_mov_b32_e32 v154, v39
		v_accvgpr_read_b32 v39, a108
		v_mov_b32_e32 v155, v39
		v_pk_add_f32 v[150:151], v[154:155], v[150:151]
		v_accvgpr_write_b32 a102, v150
		v_accvgpr_write_b32 a103, v151
		v_accvgpr_read_b32 v39, a111
		v_mov_b32_e32 v150, v39
		v_accvgpr_read_b32 v39, a113
		v_mov_b32_e32 v151, v39
		v_accvgpr_read_b32 v39, a110
		v_mov_b32_e32 v154, v39
		v_accvgpr_read_b32 v39, a112
		v_mov_b32_e32 v155, v39
		v_pk_add_f32 v[150:151], v[154:155], v[150:151]
		v_accvgpr_write_b32 a104, v150
		v_accvgpr_write_b32 a105, v151
		v_accvgpr_read_b32 v39, a115
		v_mov_b32_e32 v150, v39
		v_accvgpr_read_b32 v39, a117
		v_mov_b32_e32 v151, v39
		v_accvgpr_read_b32 v39, a114
		v_mov_b32_e32 v154, v39
		v_accvgpr_read_b32 v39, a116
		v_mov_b32_e32 v155, v39
		v_pk_add_f32 v[150:151], v[154:155], v[150:151]
		v_accvgpr_write_b32 a106, v150
		v_accvgpr_write_b32 a107, v151
		v_accvgpr_read_b32 v39, a119
		v_mov_b32_e32 v150, v39
		v_accvgpr_read_b32 v39, a121
		v_mov_b32_e32 v151, v39
		v_accvgpr_read_b32 v39, a118
		v_mov_b32_e32 v154, v39
		v_accvgpr_read_b32 v39, a120
		v_mov_b32_e32 v155, v39
		v_pk_add_f32 v[150:151], v[154:155], v[150:151]
		v_accvgpr_write_b32 a108, v150
		v_accvgpr_write_b32 a109, v151
		v_accvgpr_read_b32 v39, a123
		v_mov_b32_e32 v150, v39
		v_accvgpr_read_b32 v39, a125
		v_mov_b32_e32 v151, v39
		v_accvgpr_read_b32 v39, a122
		v_mov_b32_e32 v154, v39
		v_accvgpr_read_b32 v39, a124
		v_mov_b32_e32 v155, v39
		v_pk_add_f32 v[150:151], v[154:155], v[150:151]
		v_accvgpr_write_b32 a110, v150
		v_accvgpr_write_b32 a111, v151
		v_accvgpr_read_b32 v39, a97
		v_mov_b32_e32 v150, v39
		v_accvgpr_read_b32 v39, a99
		v_mov_b32_e32 v151, v39
		v_accvgpr_read_b32 v39, a96
		v_mov_b32_e32 v154, v39
		v_accvgpr_read_b32 v39, a98
		v_mov_b32_e32 v155, v39
		v_pk_add_f32 v[150:151], v[154:155], v[150:151]
		v_accvgpr_write_b32 a96, v150
		v_accvgpr_write_b32 a97, v151
		v_accvgpr_read_b32 v39, a101
		v_mov_b32_e32 v150, v39
		v_accvgpr_read_b32 v39, a103
		v_mov_b32_e32 v151, v39
		v_accvgpr_read_b32 v39, a100
		v_mov_b32_e32 v154, v39
		v_accvgpr_read_b32 v39, a102
		v_mov_b32_e32 v155, v39
		v_pk_add_f32 v[150:151], v[154:155], v[150:151]
		v_accvgpr_write_b32 a98, v150
		v_accvgpr_write_b32 a99, v151
		v_accvgpr_read_b32 v39, a105
		v_mov_b32_e32 v150, v39
		v_accvgpr_read_b32 v39, a107
		v_mov_b32_e32 v151, v39
		v_accvgpr_read_b32 v39, a104
		v_mov_b32_e32 v154, v39
		v_accvgpr_read_b32 v39, a106
		v_mov_b32_e32 v155, v39
		v_pk_add_f32 v[150:151], v[154:155], v[150:151]
		v_accvgpr_write_b32 a100, v150
		v_accvgpr_write_b32 a101, v151
		v_accvgpr_read_b32 v39, a109
		v_mov_b32_e32 v150, v39
		v_accvgpr_read_b32 v39, a111
		v_mov_b32_e32 v151, v39
		v_accvgpr_read_b32 v39, a108
		v_mov_b32_e32 v154, v39
		v_accvgpr_read_b32 v39, a110
		v_mov_b32_e32 v155, v39
		v_pk_add_f32 v[150:151], v[154:155], v[150:151]
		v_accvgpr_write_b32 a102, v150
		v_accvgpr_write_b32 a103, v151
		v_accvgpr_read_b32 v39, a97
		v_mov_b32_e32 v150, v39
		v_accvgpr_read_b32 v39, a99
		v_mov_b32_e32 v151, v39
		v_accvgpr_read_b32 v39, a96
		v_mov_b32_e32 v154, v39
		v_accvgpr_read_b32 v39, a98
		v_mov_b32_e32 v155, v39
		v_pk_add_f32 v[150:151], v[154:155], v[150:151]
		v_accvgpr_write_b32 a96, v150
		v_accvgpr_write_b32 a97, v151
		v_accvgpr_read_b32 v39, a101
		v_mov_b32_e32 v150, v39
		v_accvgpr_read_b32 v39, a103
		v_mov_b32_e32 v151, v39
		v_accvgpr_read_b32 v39, a100
		v_mov_b32_e32 v154, v39
		v_accvgpr_read_b32 v39, a102
		v_mov_b32_e32 v155, v39
		v_pk_add_f32 v[158:159], v[154:155], v[150:151]
		v_accvgpr_read_b32 v39, a97
		v_mov_b32_e32 v150, v39
		v_mov_b32_e32 v151, v159
		v_accvgpr_read_b32 v39, a96
		v_mov_b32_e32 v154, v39
		v_mov_b32_e32 v155, v158
		v_pk_add_f32 v[158:159], v[154:155], v[150:151]
		v_add_f32_e32 v39, v158, v159
		ds_bpermute_b32 v150, v31, v39
		s_waitcnt lgkmcnt(0)
		v_accvgpr_write_b32 a90, v150
		ds_bpermute_b32 v150, v135, v39
		s_waitcnt lgkmcnt(0)
		v_accvgpr_write_b32 a92, v150
		v_pk_add_f32 v[150:151], v[168:169], v[172:173]
		v_accvgpr_write_b32 a96, v150
		v_accvgpr_write_b32 a97, v151
		v_pk_add_f32 v[150:151], v[144:145], v[174:175]
		v_accvgpr_write_b32 a98, v150
		v_accvgpr_write_b32 a99, v151
		v_pk_add_f32 v[150:151], v[178:179], v[180:181]
		v_accvgpr_write_b32 a100, v150
		v_accvgpr_write_b32 a101, v151
		v_pk_add_f32 v[150:151], v[148:149], v[182:183]
		v_accvgpr_write_b32 a102, v150
		v_accvgpr_write_b32 a103, v151
		v_accvgpr_read_b32 v150, a90
		v_accvgpr_read_b32 v151, a91
		v_accvgpr_read_b32 v154, a92
		v_accvgpr_read_b32 v155, a93
		v_pk_add_f32 v[150:151], v[150:151], v[154:155]
		v_accvgpr_write_b32 a104, v150
		v_accvgpr_write_b32 a105, v151
		v_pk_add_f32 v[150:151], v[152:153], v[186:187]
		v_accvgpr_write_b32 a106, v150
		v_accvgpr_write_b32 a107, v151
		v_accvgpr_read_b32 v150, a82
		v_accvgpr_read_b32 v151, a83
		v_pk_add_f32 v[150:151], v[150:151], v[190:191]
		v_accvgpr_write_b32 a108, v150
		v_accvgpr_write_b32 a109, v151
		v_pk_add_f32 v[150:151], v[192:193], v[252:253]
		v_accvgpr_write_b32 a110, v150
		v_accvgpr_write_b32 a111, v151
		v_pk_add_f32 v[150:151], v[194:195], v[198:199]
		v_accvgpr_write_b32 a112, v150
		v_accvgpr_write_b32 a113, v151
		v_pk_add_f32 v[150:151], v[156:157], v[202:203]
		v_accvgpr_write_b32 a114, v150
		v_accvgpr_write_b32 a115, v151
		v_pk_add_f32 v[150:151], v[34:35], v[204:205]
		v_accvgpr_write_b32 a116, v150
		v_accvgpr_write_b32 a117, v151
		v_pk_add_f32 v[150:151], v[206:207], v[208:209]
		v_accvgpr_write_b32 a118, v150
		v_accvgpr_write_b32 a119, v151
		v_pk_add_f32 v[150:151], v[212:213], v[214:215]
		v_accvgpr_write_b32 a120, v150
		v_accvgpr_write_b32 a121, v151
		v_pk_add_f32 v[150:151], v[136:137], v[216:217]
		v_accvgpr_write_b32 a122, v150
		v_accvgpr_write_b32 a123, v151
		v_pk_add_f32 v[150:151], v[142:143], v[218:219]
		v_accvgpr_write_b32 a124, v150
		v_accvgpr_write_b32 a125, v151
		v_accvgpr_read_b32 v150, a80
		v_accvgpr_read_b32 v151, a81
		v_pk_add_f32 v[150:151], v[150:151], v[146:147]
		v_accvgpr_write_b32 a126, v150
		v_accvgpr_write_b32 a127, v151
		v_accvgpr_read_b32 v39, a105
		v_accvgpr_write_b32 a85, v39
		v_accvgpr_read_b32 v39, a96
		v_accvgpr_write_b32 a95, v39
		v_accvgpr_read_b32 v150, a84
		v_accvgpr_read_b32 v151, a85
		v_accvgpr_read_b32 v154, a94
		v_accvgpr_read_b32 v155, a95
		v_pk_add_f32 v[150:151], v[150:151], v[154:155]
		v_accvgpr_write_b32 a128, v150
		v_accvgpr_write_b32 a129, v151
		v_accvgpr_read_b32 v39, a97
		v_mov_b32_e32 v150, v39
		v_accvgpr_read_b32 v39, a100
		v_mov_b32_e32 v151, v39
		v_accvgpr_read_b32 v154, a98
		v_accvgpr_read_b32 v155, a99
		v_pk_add_f32 v[150:151], v[150:151], v[154:155]
		v_accvgpr_write_b32 a96, v150
		v_accvgpr_write_b32 a97, v151
		v_accvgpr_read_b32 v39, a101
		v_mov_b32_e32 v150, v39
		v_accvgpr_read_b32 v39, a106
		v_mov_b32_e32 v151, v39
		v_accvgpr_read_b32 v154, a102
		v_accvgpr_read_b32 v155, a103
		v_pk_add_f32 v[150:151], v[150:151], v[154:155]
		v_accvgpr_write_b32 a98, v150
		v_accvgpr_write_b32 a99, v151
		v_accvgpr_read_b32 v39, a107
		v_mov_b32_e32 v150, v39
		v_accvgpr_read_b32 v39, a110
		v_mov_b32_e32 v151, v39
		v_accvgpr_read_b32 v154, a108
		v_accvgpr_read_b32 v155, a109
		v_pk_add_f32 v[150:151], v[150:151], v[154:155]
		v_accvgpr_write_b32 a100, v150
		v_accvgpr_write_b32 a101, v151
		v_accvgpr_read_b32 v39, a111
		v_mov_b32_e32 v150, v39
		v_accvgpr_read_b32 v39, a114
		v_mov_b32_e32 v151, v39
		v_accvgpr_read_b32 v154, a112
		v_accvgpr_read_b32 v155, a113
		v_pk_add_f32 v[150:151], v[150:151], v[154:155]
		v_accvgpr_write_b32 a102, v150
		v_accvgpr_write_b32 a103, v151
		v_accvgpr_read_b32 v39, a115
		v_mov_b32_e32 v150, v39
		v_accvgpr_read_b32 v39, a118
		v_mov_b32_e32 v151, v39
		v_accvgpr_read_b32 v154, a116
		v_accvgpr_read_b32 v155, a117
		v_pk_add_f32 v[150:151], v[150:151], v[154:155]
		v_accvgpr_write_b32 a106, v150
		v_accvgpr_write_b32 a107, v151
		v_accvgpr_read_b32 v39, a119
		v_mov_b32_e32 v150, v39
		v_accvgpr_read_b32 v39, a122
		v_mov_b32_e32 v151, v39
		v_accvgpr_read_b32 v154, a120
		v_accvgpr_read_b32 v155, a121
		v_pk_add_f32 v[150:151], v[150:151], v[154:155]
		v_accvgpr_write_b32 a108, v150
		v_accvgpr_write_b32 a109, v151
		v_accvgpr_read_b32 v39, a123
		v_mov_b32_e32 v150, v39
		v_accvgpr_read_b32 v39, a126
		v_mov_b32_e32 v151, v39
		v_accvgpr_read_b32 v154, a124
		v_accvgpr_read_b32 v155, a125
		v_pk_add_f32 v[150:151], v[150:151], v[154:155]
		v_accvgpr_write_b32 a110, v150
		v_accvgpr_write_b32 a111, v151
		v_accvgpr_read_b32 v39, a127
		v_mov_b32_e32 v150, v39
		v_accvgpr_read_b32 v39, a96
		v_mov_b32_e32 v151, v39
		v_accvgpr_read_b32 v154, a128
		v_accvgpr_read_b32 v155, a129
		v_pk_add_f32 v[150:151], v[150:151], v[154:155]
		v_accvgpr_write_b32 a112, v150
		v_accvgpr_write_b32 a113, v151
		v_accvgpr_read_b32 v39, a97
		v_mov_b32_e32 v150, v39
		v_accvgpr_read_b32 v39, a100
		v_mov_b32_e32 v151, v39
		v_accvgpr_read_b32 v154, a98
		v_accvgpr_read_b32 v155, a99
		v_pk_add_f32 v[150:151], v[150:151], v[154:155]
		v_accvgpr_write_b32 a96, v150
		v_accvgpr_write_b32 a97, v151
		v_accvgpr_read_b32 v39, a101
		v_mov_b32_e32 v150, v39
		v_accvgpr_read_b32 v39, a106
		v_mov_b32_e32 v151, v39
		v_accvgpr_read_b32 v154, a102
		v_accvgpr_read_b32 v155, a103
		v_pk_add_f32 v[150:151], v[150:151], v[154:155]
		v_accvgpr_write_b32 a98, v150
		v_accvgpr_write_b32 a99, v151
		v_accvgpr_read_b32 v39, a107
		v_mov_b32_e32 v150, v39
		v_accvgpr_read_b32 v39, a110
		v_mov_b32_e32 v151, v39
		v_accvgpr_read_b32 v154, a108
		v_accvgpr_read_b32 v155, a109
		v_pk_add_f32 v[150:151], v[150:151], v[154:155]
		v_accvgpr_write_b32 a100, v150
		v_accvgpr_write_b32 a101, v151
		v_accvgpr_read_b32 v39, a111
		v_mov_b32_e32 v150, v39
		v_accvgpr_read_b32 v39, a96
		v_mov_b32_e32 v151, v39
		v_accvgpr_read_b32 v154, a112
		v_accvgpr_read_b32 v155, a113
		v_pk_add_f32 v[150:151], v[150:151], v[154:155]
		v_accvgpr_write_b32 a102, v150
		v_accvgpr_write_b32 a103, v151
		v_accvgpr_read_b32 v39, a97
		v_accvgpr_write_b32 a96, v39
		v_accvgpr_read_b32 v39, a100
		v_accvgpr_write_b32 a97, v39
		v_accvgpr_read_b32 v150, a98
		v_accvgpr_read_b32 v151, a99
		v_accvgpr_read_b32 v154, a96
		v_accvgpr_read_b32 v155, a97
		v_pk_add_f32 v[150:151], v[154:155], v[150:151]
		v_accvgpr_write_b32 a96, v150
		v_accvgpr_write_b32 a97, v151
		v_accvgpr_read_b32 v39, a101
		v_accvgpr_write_b32 a98, v39
		v_accvgpr_read_b32 v39, a96
		v_accvgpr_write_b32 a99, v39
		v_accvgpr_read_b32 v150, a102
		v_accvgpr_read_b32 v151, a103
		v_accvgpr_read_b32 v154, a98
		v_accvgpr_read_b32 v155, a99
		v_pk_add_f32 v[158:159], v[154:155], v[150:151]
		v_accvgpr_read_b32 v39, a97
		v_add_f32_e32 v39, v39, v158
		v_add_f32_e32 v39, v159, v39
		ds_bpermute_b32 v150, v31, v39
		ds_bpermute_b32 v31, v135, v39
		s_mov_b32 m0, s17
		s_nop 0
		ds_read_addtid_b32 v39 offset:12288
		s_waitcnt lgkmcnt(0)
		v_sub_f32_e32 v20, v39, v20
		v_sub_f32_e32 v19, v19, v26
		v_exp_f32_e32 v154, v20
		v_exp_f32_e32 v158, v19
		v_add_f32_e32 v171, v150, v31
		v_mov_b32_e32 v155, v154
		v_pk_mul_f32 v[48:49], v[48:49], v[154:155]
		v_pk_mul_f32 v[50:51], v[50:51], v[154:155]
		v_pk_mul_f32 v[52:53], v[52:53], v[154:155]
		v_pk_mul_f32 v[54:55], v[54:55], v[154:155]
		v_pk_mul_f32 v[56:57], v[56:57], v[154:155]
		v_pk_mul_f32 v[58:59], v[58:59], v[154:155]
		v_pk_mul_f32 v[60:61], v[60:61], v[154:155]
		v_pk_mul_f32 v[62:63], v[62:63], v[154:155]
		v_pk_mul_f32 v[64:65], v[64:65], v[154:155]
		v_pk_mul_f32 v[66:67], v[66:67], v[154:155]
		v_pk_mul_f32 v[68:69], v[68:69], v[154:155]
		v_pk_mul_f32 v[70:71], v[70:71], v[154:155]
		v_pk_mul_f32 v[72:73], v[72:73], v[154:155]
		v_pk_mul_f32 v[74:75], v[74:75], v[154:155]
		v_pk_mul_f32 v[76:77], v[76:77], v[154:155]
		v_pk_mul_f32 v[78:79], v[78:79], v[154:155]
		v_mov_b32_e32 v159, v158
		v_pk_mul_f32 v[80:81], v[80:81], v[158:159]
		v_pk_mul_f32 v[82:83], v[82:83], v[158:159]
		v_pk_mul_f32 v[84:85], v[84:85], v[158:159]
		v_pk_mul_f32 v[86:87], v[86:87], v[158:159]
		v_pk_mul_f32 v[88:89], v[88:89], v[158:159]
		v_pk_mul_f32 v[90:91], v[90:91], v[158:159]
		v_pk_mul_f32 v[92:93], v[92:93], v[158:159]
		v_pk_mul_f32 v[94:95], v[94:95], v[158:159]
		v_accvgpr_read_b32 v150, a64
		v_accvgpr_read_b32 v151, a65
		v_pk_mul_f32 v[150:151], v[150:151], v[158:159]
		v_accvgpr_write_b32 a64, v150
		v_accvgpr_write_b32 a65, v151
		v_accvgpr_read_b32 v150, a66
		v_accvgpr_read_b32 v151, a67
		v_pk_mul_f32 v[150:151], v[150:151], v[158:159]
		v_accvgpr_write_b32 a66, v150
		v_accvgpr_write_b32 a67, v151
		v_accvgpr_read_b32 v150, a68
		v_accvgpr_read_b32 v151, a69
		v_pk_mul_f32 v[150:151], v[150:151], v[158:159]
		v_accvgpr_write_b32 a68, v150
		v_accvgpr_write_b32 a69, v151
		v_accvgpr_read_b32 v150, a70
		v_accvgpr_read_b32 v151, a71
		v_pk_mul_f32 v[150:151], v[150:151], v[158:159]
		v_accvgpr_write_b32 a70, v150
		v_accvgpr_write_b32 a71, v151
		v_accvgpr_read_b32 v150, a72
		v_accvgpr_read_b32 v151, a73
		v_pk_mul_f32 v[150:151], v[150:151], v[158:159]
		v_accvgpr_write_b32 a72, v150
		v_accvgpr_write_b32 a73, v151
		v_accvgpr_read_b32 v150, a74
		v_accvgpr_read_b32 v151, a75
		v_pk_mul_f32 v[150:151], v[150:151], v[158:159]
		v_accvgpr_write_b32 a74, v150
		v_accvgpr_write_b32 a75, v151
		v_accvgpr_read_b32 v150, a76
		v_accvgpr_read_b32 v151, a77
		v_pk_mul_f32 v[150:151], v[150:151], v[158:159]
		v_accvgpr_write_b32 a76, v150
		v_accvgpr_write_b32 a77, v151
		v_accvgpr_read_b32 v150, a78
		v_accvgpr_read_b32 v151, a79
		v_pk_mul_f32 v[150:151], v[150:151], v[158:159]
		v_accvgpr_write_b32 a78, v150
		v_accvgpr_write_b32 a79, v151
		v_accvgpr_read_b32 v19, a104
		v_mov_b32_e32 v170, v19
		v_mov_b32_e32 v150, v154
		v_mov_b32_e32 v151, v158
		v_mov_b64_e32 v[154:155], v[32:33]
		s_mov_b32 m0, s17
		v_pk_fma_f32 v[32:33], v[154:155], v[150:151], v[170:171]
		ds_write_addtid_b32 v32 offset:16384
		s_mov_b32 m0, s17
		s_nop 0
		ds_write_addtid_b32 v33 offset:17408
		v_accvgpr_read_b32 v19, a86
		v_cvt_pk_bf16_f32 v19, v19, v254
		v_accvgpr_write_b32 a96, v19
		s_mov_b32 m0, s17
		v_accvgpr_read_b32 v19, a87
		ds_read_addtid_b32 v20 offset:15360
		s_waitcnt lgkmcnt(0)
		v_cvt_pk_bf16_f32 v19, v19, v20
		v_accvgpr_write_b32 a97, v19
		s_mov_b32 m0, s17
		v_accvgpr_read_b32 v19, a88
		ds_read_addtid_b32 v20 offset:18432
		s_waitcnt lgkmcnt(0)
		v_cvt_pk_bf16_f32 v19, v19, v20
		v_accvgpr_write_b32 a98, v19
		s_mov_b32 m0, s17
		v_accvgpr_read_b32 v19, a89
		ds_read_addtid_b32 v20 offset:19456
		s_waitcnt lgkmcnt(0)
		v_cvt_pk_bf16_f32 v19, v19, v20
		s_mov_b32 m0, s17
		v_accvgpr_write_b32 a99, v19
		ds_read_addtid_b32 v19 offset:20480
		s_mov_b32 m0, s17
		s_nop 0
		ds_read_addtid_b32 v20 offset:22528
		s_waitcnt lgkmcnt(0)
		v_cvt_pk_bf16_f32 v19, v19, v20
		s_mov_b32 m0, s17
		v_accvgpr_write_b32 a100, v19
		ds_read_addtid_b32 v19 offset:21504
		s_mov_b32 m0, s17
		s_nop 0
		ds_read_addtid_b32 v20 offset:23552
		s_waitcnt lgkmcnt(0)
		v_cvt_pk_bf16_f32 v19, v19, v20
		s_mov_b32 m0, s17
		v_accvgpr_write_b32 a101, v19
		ds_read_addtid_b32 v19 offset:24576
		s_mov_b32 m0, s17
		s_nop 0
		ds_read_addtid_b32 v20 offset:26624
		s_waitcnt lgkmcnt(0)
		v_cvt_pk_bf16_f32 v19, v19, v20
		s_mov_b32 m0, s17
		v_accvgpr_write_b32 a102, v19
		ds_read_addtid_b32 v19 offset:25600
		s_mov_b32 m0, s17
		s_nop 0
		ds_read_addtid_b32 v20 offset:27648
		s_waitcnt lgkmcnt(0)
		v_cvt_pk_bf16_f32 v19, v19, v20
		v_accvgpr_write_b32 a103, v19
		v_cvt_pk_bf16_f32 v228, v184, v232
		v_cvt_pk_bf16_f32 v229, v185, v233
		v_cvt_pk_bf16_f32 v230, v196, v238
		v_cvt_pk_bf16_f32 v231, v197, v239
		v_cvt_pk_bf16_f32 v19, v200, v240
		v_accvgpr_write_b32 a104, v19
		v_cvt_pk_bf16_f32 v19, v201, v241
		v_accvgpr_write_b32 a105, v19
		v_cvt_pk_bf16_f32 v19, v188, v244
		v_accvgpr_write_b32 a106, v19
		v_cvt_pk_bf16_f32 v19, v189, v245
		v_accvgpr_write_b32 a107, v19
		v_cvt_pk_bf16_f32 v19, v36, v210
		v_accvgpr_write_b32 a108, v19
		v_cvt_pk_bf16_f32 v19, v37, v211
		v_accvgpr_write_b32 a109, v19
		v_cvt_pk_bf16_f32 v19, v138, v140
		v_accvgpr_write_b32 a110, v19
		v_cvt_pk_bf16_f32 v19, v139, v141
		v_accvgpr_write_b32 a111, v19
		v_cvt_pk_bf16_f32 v236, v220, v226
		v_cvt_pk_bf16_f32 v237, v221, v227
		v_cvt_pk_bf16_f32 v238, v224, v234
		v_cvt_pk_bf16_f32 v239, v225, v235
		v_cvt_pk_bf16_f32 v220, v242, v246
		v_cvt_pk_bf16_f32 v221, v243, v247
		v_cvt_pk_bf16_f32 v222, v248, v250
		v_cvt_pk_bf16_f32 v223, v249, v251
		v_cvt_pk_bf16_f32 v224, v160, v162
		v_cvt_pk_bf16_f32 v225, v161, v163
		v_cvt_pk_bf16_f32 v226, v164, v166
		v_cvt_pk_bf16_f32 v227, v165, v167
		v_accvgpr_read_b32 v19, a91
		v_accvgpr_read_b32 v20, a93
		v_cvt_pk_bf16_f32 v160, v19, v20
		v_cvt_pk_bf16_f32 v161, v168, v172
		v_cvt_pk_bf16_f32 v162, v169, v173
		v_cvt_pk_bf16_f32 v163, v144, v174
		v_cvt_pk_bf16_f32 v164, v145, v175
		v_cvt_pk_bf16_f32 v165, v178, v180
		v_cvt_pk_bf16_f32 v166, v179, v181
		v_cvt_pk_bf16_f32 v167, v148, v182
		v_cvt_pk_bf16_f32 v168, v149, v183
		v_cvt_pk_bf16_f32 v169, v152, v186
		v_cvt_pk_bf16_f32 v170, v153, v187
		v_accvgpr_read_b32 v19, a82
		v_cvt_pk_bf16_f32 v171, v19, v190
		v_accvgpr_read_b32 v19, a83
		v_cvt_pk_bf16_f32 v148, v19, v191
		v_cvt_pk_bf16_f32 v149, v192, v252
		v_cvt_pk_bf16_f32 v150, v193, v253
		v_cvt_pk_bf16_f32 v151, v194, v198
		v_cvt_pk_bf16_f32 v152, v195, v199
		v_cvt_pk_bf16_f32 v153, v156, v202
		v_cvt_pk_bf16_f32 v154, v157, v203
		v_cvt_pk_bf16_f32 v155, v34, v204
		v_cvt_pk_bf16_f32 v156, v35, v205
		v_cvt_pk_bf16_f32 v157, v206, v208
		v_cvt_pk_bf16_f32 v158, v207, v209
		v_cvt_pk_bf16_f32 v159, v212, v214
		v_cvt_pk_bf16_f32 v32, v213, v215
		v_cvt_pk_bf16_f32 v33, v136, v216
		v_cvt_pk_bf16_f32 v34, v137, v217
		v_cvt_pk_bf16_f32 v35, v142, v218
		v_cvt_pk_bf16_f32 v136, v143, v219
		v_accvgpr_read_b32 v19, a80
		v_cvt_pk_bf16_f32 v137, v19, v146
		v_accvgpr_read_b32 v19, a81
		v_cvt_pk_bf16_f32 v138, v19, v147
		v_accvgpr_read_b32 v19, a84
		v_accvgpr_read_b32 v20, a94
		v_cvt_pk_bf16_f32 v139, v19, v20
		v_accvgpr_read_b32 v140, a96
		v_accvgpr_read_b32 v141, a97
		v_accvgpr_read_b32 v142, a98
		v_accvgpr_read_b32 v143, a99
		s_nop 1
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_accvgpr_write_b32 a80, v140
		v_accvgpr_write_b32 a81, v141
		v_accvgpr_write_b32 a82, v142
		v_accvgpr_write_b32 a83, v143
		v_accvgpr_read_b32 v140, a100
		v_accvgpr_read_b32 v141, a101
		v_accvgpr_read_b32 v142, a102
		v_accvgpr_read_b32 v143, a103
		s_nop 1
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_accvgpr_write_b32 a84, v140
		v_accvgpr_write_b32 a85, v141
		v_accvgpr_write_b32 a86, v142
		v_accvgpr_write_b32 a87, v143
		v_permlane32_swap_b32_e32 v228, v230
		v_permlane32_swap_b32_e32 v229, v231
		v_accvgpr_read_b32 v140, a104
		v_accvgpr_read_b32 v141, a105
		v_accvgpr_read_b32 v142, a106
		v_accvgpr_read_b32 v143, a107
		s_nop 1
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_accvgpr_write_b32 a88, v140
		v_accvgpr_write_b32 a89, v141
		v_accvgpr_write_b32 a90, v142
		v_accvgpr_write_b32 a91, v143
		v_accvgpr_read_b32 v140, a108
		v_accvgpr_read_b32 v141, a109
		v_accvgpr_read_b32 v142, a110
		v_accvgpr_read_b32 v143, a111
		s_nop 1
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_accvgpr_write_b32 a92, v140
		v_accvgpr_write_b32 a93, v141
		v_accvgpr_write_b32 a94, v142
		v_accvgpr_write_b32 a95, v143
		v_permlane32_swap_b32_e32 v236, v238
		v_permlane32_swap_b32_e32 v237, v239
		v_permlane32_swap_b32_e32 v220, v222
		v_permlane32_swap_b32_e32 v221, v223
		v_permlane32_swap_b32_e32 v224, v226
		v_permlane32_swap_b32_e32 v225, v227
		v_permlane32_swap_b32_e32 v160, v162
		v_permlane32_swap_b32_e32 v161, v163
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		v_permlane32_swap_b32_e32 v168, v170
		v_permlane32_swap_b32_e32 v169, v171
		v_permlane32_swap_b32_e32 v148, v150
		v_permlane32_swap_b32_e32 v149, v151
		v_permlane32_swap_b32_e32 v152, v154
		v_permlane32_swap_b32_e32 v153, v155
		v_permlane32_swap_b32_e32 v156, v158
		v_permlane32_swap_b32_e32 v157, v159
		v_permlane32_swap_b32_e32 v32, v34
		v_permlane32_swap_b32_e32 v33, v35
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[48:63], a[144:147], a[80:83], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[176:179], a[80:83], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[176:179], v[160:163], a[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[160:163], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[148:151], a[84:87], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[180:183], a[84:87], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[180:183], v[164:167], a[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[148:151], v[164:167], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[152:155], v[228:231], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[184:187], v[228:231], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[184:187], v[168:171], a[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], v[168:171], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[156:159], a[88:91], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[188:191], a[88:91], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[188:191], v[148:151], a[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], v[148:151], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[160:163], a[92:95], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], a[92:95], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[192:195], v[152:155], a[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[160:163], v[152:155], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[164:167], v[236:239], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[236:239], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[196:199], v[156:159], a[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[164:167], v[156:159], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[168:171], v[220:223], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[220:223], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[200:203], v[32:35], a[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[168:171], v[32:35], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[172:175], v[224:227], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[224:227], v[64:79]
		v_mfma_f32_32x32x16_bf16 a[64:79], a[204:207], v[136:139], a[64:79]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[172:175], v[136:139], v[80:95]
		s_add_i32 s21, s46, 0x80
		s_mov_b32 m0, s17
		s_cmp_lt_i32 s21, s26
		ds_read_addtid_b32 v32 offset:16384
		s_mov_b32 m0, s17
		s_nop 0
		ds_read_addtid_b32 v33 offset:17408
		s_mov_b32 m0, s17
		s_mov_b32 s46, s21
		ds_read_addtid_b32 v19 offset:13312
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s17
		v_mov_b32_e32 v20, v19
		ds_read_addtid_b32 v19 offset:14336
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_2
.L_attn_fwd_persistent.loop_exit_2:
		s_mov_b32 m0, s17
		s_nop 0
		ds_read_addtid_b32 v5 offset:3072
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s17
		v_readfirstlane_b32 s21, v5
		ds_read_addtid_b32 v5 offset:11264
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s25, v5
		s_mul_i32 s21, s21, s25
		s_mov_b32 m0, s17
		s_lshl_b32 s21, s21, 9
		ds_read_addtid_b32 v5
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s25, v5
		s_mul_i32 s25, s1, s25
		s_lshl_b32 s25, s25, 1
		s_mov_b32 m0, s17
		s_add_i32 s26, s21, s25
		ds_read_addtid_b32 v5 offset:1024
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s40, v5
		s_mul_i32 s40, s24, s40
		s_lshl_b32 s40, s40, 1
		s_add_i32 s26, s26, s40
		s_add_i32 s41, s21, 32
		s_add_i32 s41, s41, s25
		s_add_i32 s41, s41, s40
		s_add_i32 s42, s21, 64
		s_add_i32 s42, s42, s25
		s_add_i32 s42, s42, s40
		s_add_i32 s21, s21, 0x60
		s_add_i32 s21, s21, s25
		s_add_i32 s21, s21, s40
		s_and_b32 s43, s0, 15
		s_mul_i32 s43, s43, 2
		s_add_i32 s43, s43, 1
		s_lshr_b32 s44, s43, 1
		s_and_b32 s43, s43, 1
		s_xor_b32 s45, s44, -1
		s_add_i32 s45, s45, 1
		s_add_i32 s45, s45, 31
		s_cmp_eq_u32 s43, 0
		s_cselect_b32 s43, s44, s45
		s_mul_i32 s44, s43, 0x100
		v_and_b32_e32 v5, 1, v0
		v_lshrrev_b32_e32 v6, 1, v0
		v_and_b32_e32 v6, 1, v6
		v_mov_b32_e32 v7, 2
		v_mul_lo_u32 v7, v7, v6
		v_lshrrev_b32_e32 v6, 2, v0
		v_and_b32_e32 v6, 1, v6
		v_mov_b32_e32 v9, 4
		v_mul_lo_u32 v9, v9, v6
		v_bitop3_b32 v5, v5, v7, v9 bitop3:0x96
		v_lshrrev_b32_e32 v6, 3, v0
		v_and_b32_e32 v6, 1, v6
		v_mov_b32_e32 v7, 8
		v_mul_lo_u32 v7, v7, v6
		v_xor_b32_e32 v5, v5, v7
		v_lshrrev_b32_e32 v6, 4, v0
		v_and_b32_e32 v6, 1, v6
		v_mov_b32_e32 v7, 16
		v_mul_lo_u32 v7, v7, v6
		v_lshrrev_b32_e32 v6, 6, v0
		v_and_b32_e32 v6, 1, v6
		v_mov_b32_e32 v9, 32
		v_mul_lo_u32 v9, v9, v6
		v_bitop3_b32 v5, v5, v7, v9 bitop3:0x96
		v_lshrrev_b32_e32 v6, 7, v0
		v_and_b32_e32 v6, 1, v6
		v_mov_b32_e32 v7, 64
		v_mul_lo_u32 v7, v7, v6
		v_xor_b32_e32 v5, v5, v7
		v_add_u32_e32 v5, s44, v5
		v_and_b32_e32 v6, 1, v0
		v_xor_b32_e32 v6, 0x80, v6
		v_lshrrev_b32_e32 v7, 1, v0
		v_and_b32_e32 v7, 1, v7
		v_mov_b32_e32 v9, 2
		v_mul_lo_u32 v9, v9, v7
		v_xor_b32_e32 v6, v6, v9
		v_lshrrev_b32_e32 v7, 2, v0
		v_and_b32_e32 v7, 1, v7
		v_mov_b32_e32 v9, 4
		v_mul_lo_u32 v9, v9, v7
		v_xor_b32_e32 v6, v6, v9
		v_lshrrev_b32_e32 v7, 3, v0
		v_and_b32_e32 v7, 1, v7
		v_mov_b32_e32 v9, 8
		v_mul_lo_u32 v9, v9, v7
		v_lshrrev_b32_e32 v7, 4, v0
		v_and_b32_e32 v7, 1, v7
		v_mov_b32_e32 v10, 16
		v_mul_lo_u32 v10, v10, v7
		v_bitop3_b32 v6, v6, v9, v10 bitop3:0x96
		v_lshrrev_b32_e32 v7, 6, v0
		v_and_b32_e32 v7, 1, v7
		v_mov_b32_e32 v9, 32
		v_mul_lo_u32 v9, v9, v7
		v_lshrrev_b32_e32 v7, 7, v0
		v_and_b32_e32 v7, 1, v7
		v_mov_b32_e32 v10, 64
		v_mul_lo_u32 v10, v10, v7
		v_bitop3_b32 v6, v6, v9, v10 bitop3:0x96
		v_add_u32_e32 v6, s44, v6
		v_cmp_lt_i32_e64 vcc, v5, s22
		s_mov_b64 s[46:47], vcc
		v_cmp_lt_i32_e64 vcc, v6, s22
		s_mov_b64 s[48:49], vcc
		v_lshrrev_b32_e32 v5, 3, v0
		v_and_b32_e32 v5, 1, v5
		v_lshrrev_b32_e32 v6, 4, v0
		v_and_b32_e32 v6, 1, v6
		v_mov_b32_e32 v7, 2
		v_mul_lo_u32 v7, v7, v6
		v_lshrrev_b32_e32 v6, 5, v0
		v_and_b32_e32 v6, 1, v6
		v_mov_b32_e32 v9, 4
		v_mul_lo_u32 v9, v9, v6
		v_bitop3_b32 v5, v5, v7, v9 bitop3:0x96
		v_lshrrev_b32_e32 v6, 6, v0
		v_and_b32_e32 v6, 1, v6
		v_mov_b32_e32 v7, 8
		v_mul_lo_u32 v7, v7, v6
		v_lshrrev_b32_e32 v6, 7, v0
		v_and_b32_e32 v6, 1, v6
		v_mov_b32_e32 v9, 16
		v_mul_lo_u32 v9, v9, v6
		v_bitop3_b32 v5, v5, v7, v9 bitop3:0x96
		v_add_u32_e32 v5, s44, v5
		v_cmp_lt_i32_e64 vcc, v5, s22
		s_mov_b64 s[50:51], vcc
		s_mul_i32 s45, s43, s12
		s_lshl_b32 s45, s45, 9
		s_mul_i32 s52, s1, s10
		s_lshl_b32 s52, s52, 1
		s_add_i32 s45, s45, s52
		s_mul_i32 s52, s24, s11
		s_lshl_b32 s52, s52, 1
		s_add_i32 s45, s45, s52
		v_lshrrev_b32_e32 v5, 7, v0
		v_mul_lo_u32 v5, s12, v5
		v_lshlrev_b32_e32 v5, 5, v5
		v_lshrrev_b32_e32 v6, 6, v0
		v_and_b32_e32 v6, 1, v6
		v_mul_lo_u32 v6, s12, v6
		v_lshlrev_b32_e32 v6, 4, v6
		v_add3_u32 v5, s45, v5, v6
		v_lshrrev_b32_e32 v6, 5, v0
		v_and_b32_e32 v6, 1, v6
		v_mul_lo_u32 v6, s12, v6
		v_lshlrev_b32_e32 v6, 3, v6
		v_lshrrev_b32_e32 v7, 4, v0
		v_and_b32_e32 v7, 1, v7
		v_mul_lo_u32 v7, s12, v7
		v_lshlrev_b32_e32 v7, 2, v7
		v_add3_u32 v5, v5, v6, v7
		v_accvgpr_read_b32 v6, a0
		v_and_b32_e32 v7, 1, v0
		v_lshlrev_b32_e32 v7, 4, v7
		v_add3_u32 v5, v5, v6, v7
		v_lshrrev_b32_e32 v6, 2, v0
		v_and_b32_e32 v6, 1, v6
		v_lshlrev_b32_e32 v6, 6, v6
		v_lshrrev_b32_e32 v9, 1, v0
		v_and_b32_e32 v9, 1, v9
		v_lshlrev_b32_e32 v9, 5, v9
		v_add3_u32 v5, v5, v6, v9
		v_mov_b32_e32 v10, 0x80000000
		v_cndmask_b32_e64 v5, v10, v5, s[50:51]
		buffer_load_dwordx4 v[12:15], v5, s[36:39], 0 offen
		v_accvgpr_read_b32 v5, a1
		v_add_u32_e32 v5, s44, v5
		v_cmp_lt_i32_e64 vcc, v5, s22
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v5, a2
		v_add3_u32 v5, s45, v5, v7
		v_add3_u32 v5, v5, v6, v9
		v_cndmask_b32_e64 v5, v10, v5, s[50:51]
		buffer_load_dwordx4 v[16:19], v5, s[36:39], 0 offen
		v_accvgpr_read_b32 v5, a3
		v_add_u32_e32 v5, s44, v5
		v_cmp_lt_i32_e64 vcc, v5, s22
		s_mov_b64 s[50:51], vcc
		v_add3_u32 v5, v7, v6, v9
		v_accvgpr_read_b32 v11, a4
		v_add3_u32 v11, v11, v5, s45
		v_cndmask_b32_e64 v11, v10, v11, s[50:51]
		buffer_load_dwordx4 v[20:23], v11, s[36:39], 0 offen
		v_accvgpr_read_b32 v11, a5
		v_add_u32_e32 v11, s44, v11
		v_cmp_lt_i32_e64 vcc, v11, s22
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v11, a6
		v_add3_u32 v11, v11, v5, s45
		v_cndmask_b32_e64 v11, v10, v11, s[50:51]
		buffer_load_dwordx4 v[24:27], v11, s[36:39], 0 offen
		v_accvgpr_read_b32 v11, a7
		v_add_u32_e32 v11, s44, v11
		v_cmp_lt_i32_e64 vcc, v11, s22
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v11, a8
		v_add3_u32 v5, v11, v5, s45
		v_cndmask_b32_e64 v5, v10, v5, s[50:51]
		buffer_load_dwordx4 v[28:31], v5, s[36:39], 0 offen
		v_accvgpr_read_b32 v5, a9
		v_add_u32_e32 v5, s44, v5
		v_cmp_lt_i32_e64 vcc, v5, s22
		s_mov_b64 s[50:51], vcc
		v_add3_u32 v5, v7, v6, v9
		v_accvgpr_read_b32 v6, a10
		v_add3_u32 v6, v6, v5, s45
		v_cndmask_b32_e64 v6, v10, v6, s[50:51]
		buffer_load_dwordx4 v[36:39], v6, s[36:39], 0 offen
		v_accvgpr_read_b32 v6, a11
		v_add_u32_e32 v6, s44, v6
		v_cmp_lt_i32_e64 vcc, v6, s22
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v6, a12
		v_add3_u32 v6, v6, v5, s45
		v_cndmask_b32_e64 v6, v10, v6, s[50:51]
		buffer_load_dwordx4 v[40:43], v6, s[36:39], 0 offen
		v_accvgpr_read_b32 v6, a13
		v_add_u32_e32 v6, s44, v6
		v_cmp_lt_i32_e64 vcc, v6, s22
		v_accvgpr_read_b32 v6, a14
		v_add3_u32 v5, v6, v5, s45
		v_rcp_f32_e32 v6, v32
		v_cndmask_b32_e32 v5, v10, v5, vcc
		buffer_load_dwordx4 v[44:47], v5, s[36:39], 0 offen
		s_waitcnt vmcnt(8)
		s_barrier
		v_lshrrev_b32_e32 v5, 6, v0
		v_and_b32_e32 v5, 1, v5
		v_lshlrev_b32_e32 v5, 2, v5
		v_lshrrev_b32_e32 v7, 5, v0
		v_and_b32_e32 v7, 1, v7
		v_lshlrev_b32_e32 v7, 1, v7
		v_lshrrev_b32_e32 v9, 4, v0
		v_and_b32_e32 v9, 1, v9
		v_xor_b32_e32 v9, v0, v9
		v_bitop3_b32 v5, v5, v7, v9 bitop3:0x96
		v_lshlrev_b32_e32 v5, 4, v5
		v_add_u32_e32 v5, 0x10000, v5
		s_waitcnt vmcnt(7)
		ds_write_b128 v5, v[12:15] offset:18864
		s_waitcnt vmcnt(6)
		ds_write_b128 v5, v[16:19] offset:22960
		s_waitcnt vmcnt(5)
		ds_write_b128 v5, v[20:23] offset:27056
		s_waitcnt vmcnt(4)
		ds_write_b128 v5, v[24:27] offset:31152
		v_mov_b32_e32 v7, v6
		v_pk_mul_f32 v[12:13], v[48:49], v[6:7]
		v_pk_mul_f32 v[14:15], v[50:51], v[6:7]
		v_pk_mul_f32 v[16:17], v[52:53], v[6:7]
		v_pk_mul_f32 v[18:19], v[54:55], v[6:7]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_pk_mul_f32 v[20:21], v[56:57], v[6:7]
		v_pk_mul_f32 v[22:23], v[58:59], v[6:7]
		v_pk_mul_f32 v[24:25], v[60:61], v[6:7]
		v_pk_mul_f32 v[26:27], v[62:63], v[6:7]
		v_pk_mul_f32 v[34:35], v[64:65], v[6:7]
		v_pk_mul_f32 v[48:49], v[66:67], v[6:7]
		v_pk_mul_f32 v[50:51], v[68:69], v[6:7]
		v_pk_mul_f32 v[52:53], v[70:71], v[6:7]
		v_pk_mul_f32 v[54:55], v[72:73], v[6:7]
		v_pk_mul_f32 v[56:57], v[74:75], v[6:7]
		v_pk_mul_f32 v[58:59], v[76:77], v[6:7]
		v_pk_mul_f32 v[60:61], v[78:79], v[6:7]
		v_rcp_f32_e32 v6, v33
		v_cvt_pk_bf16_f32 v64, v12, v13
		v_mov_b32_e32 v7, v6
		v_pk_mul_f32 v[12:13], v[80:81], v[6:7]
		v_pk_mul_f32 v[32:33], v[82:83], v[6:7]
		v_pk_mul_f32 v[62:63], v[84:85], v[6:7]
		v_pk_mul_f32 v[68:69], v[86:87], v[6:7]
		v_pk_mul_f32 v[70:71], v[88:89], v[6:7]
		v_pk_mul_f32 v[72:73], v[90:91], v[6:7]
		v_pk_mul_f32 v[74:75], v[92:93], v[6:7]
		v_pk_mul_f32 v[76:77], v[94:95], v[6:7]
		v_accvgpr_read_b32 v66, a64
		v_accvgpr_read_b32 v67, a65
		v_pk_mul_f32 v[78:79], v[66:67], v[6:7]
		v_accvgpr_read_b32 v66, a66
		v_accvgpr_read_b32 v67, a67
		v_pk_mul_f32 v[80:81], v[66:67], v[6:7]
		v_accvgpr_read_b32 v66, a68
		v_accvgpr_read_b32 v67, a69
		v_pk_mul_f32 v[82:83], v[66:67], v[6:7]
		v_accvgpr_read_b32 v66, a70
		v_accvgpr_read_b32 v67, a71
		v_pk_mul_f32 v[84:85], v[66:67], v[6:7]
		v_accvgpr_read_b32 v66, a72
		v_accvgpr_read_b32 v67, a73
		v_pk_mul_f32 v[86:87], v[66:67], v[6:7]
		v_accvgpr_read_b32 v66, a74
		v_accvgpr_read_b32 v67, a75
		v_pk_mul_f32 v[88:89], v[66:67], v[6:7]
		v_accvgpr_read_b32 v66, a76
		v_accvgpr_read_b32 v67, a77
		v_pk_mul_f32 v[90:91], v[66:67], v[6:7]
		v_accvgpr_read_b32 v66, a78
		v_accvgpr_read_b32 v67, a79
		v_pk_mul_f32 v[92:93], v[66:67], v[6:7]
		v_cvt_pk_bf16_f32 v65, v14, v15
		v_cvt_pk_bf16_f32 v66, v16, v17
		v_cvt_pk_bf16_f32 v67, v18, v19
		v_cvt_pk_bf16_f32 v16, v20, v21
		v_cvt_pk_bf16_f32 v17, v22, v23
		v_cvt_pk_bf16_f32 v18, v24, v25
		v_cvt_pk_bf16_f32 v19, v26, v27
		v_cvt_pk_bf16_f32 v20, v34, v35
		v_cvt_pk_bf16_f32 v21, v48, v49
		v_cvt_pk_bf16_f32 v22, v50, v51
		v_cvt_pk_bf16_f32 v23, v52, v53
		v_cvt_pk_bf16_f32 v24, v54, v55
		v_cvt_pk_bf16_f32 v25, v56, v57
		v_cvt_pk_bf16_f32 v26, v58, v59
		v_cvt_pk_bf16_f32 v27, v60, v61
		v_cvt_pk_bf16_f32 v48, v12, v13
		v_cvt_pk_bf16_f32 v49, v32, v33
		v_cvt_pk_bf16_f32 v50, v62, v63
		v_cvt_pk_bf16_f32 v51, v68, v69
		v_cvt_pk_bf16_f32 v12, v70, v71
		v_cvt_pk_bf16_f32 v13, v72, v73
		v_cvt_pk_bf16_f32 v14, v74, v75
		v_cvt_pk_bf16_f32 v15, v76, v77
		v_cvt_pk_bf16_f32 v32, v78, v79
		v_cvt_pk_bf16_f32 v33, v80, v81
		v_cvt_pk_bf16_f32 v34, v82, v83
		v_cvt_pk_bf16_f32 v35, v84, v85
		v_cvt_pk_bf16_f32 v52, v86, v87
		v_cvt_pk_bf16_f32 v53, v88, v89
		v_cvt_pk_bf16_f32 v54, v90, v91
		v_cvt_pk_bf16_f32 v55, v92, v93
		v_permlane32_swap_b32_e32 v64, v66
		v_permlane32_swap_b32_e32 v65, v67
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v20, v22
		v_permlane32_swap_b32_e32 v21, v23
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_permlane32_swap_b32_e32 v48, v50
		v_permlane32_swap_b32_e32 v49, v51
		v_permlane32_swap_b32_e32 v12, v14
		v_permlane32_swap_b32_e32 v13, v15
		v_permlane32_swap_b32_e32 v32, v34
		v_permlane32_swap_b32_e32 v33, v35
		v_permlane32_swap_b32_e32 v52, v54
		v_permlane32_swap_b32_e32 v53, v55
		s_mov_b32 m0, s17
		v_lshrrev_b32_e32 v6, 7, v0
		ds_read_addtid_b32 v7 offset:11264
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s36, v7
		s_nop 1
		v_mul_lo_u32 v7, s36, v6
		v_lshlrev_b32_e32 v7, 7, v7
		v_accvgpr_write_b32 a0, v7
		s_mov_b32 m0, s17
		v_and_b32_e32 v7, 1, v0
		ds_read_addtid_b32 v9 offset:11264
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s36, v9
		s_nop 1
		v_mul_lo_u32 v9, s36, v7
		v_lshlrev_b32_e32 v9, 1, v9
		v_accvgpr_read_b32 v11, a0
		v_add3_u32 v11, s26, v11, v9
		v_lshrrev_b32_e32 v56, 6, v0
		s_mov_b32 m0, s17
		v_and_b32_e32 v56, 1, v56
		ds_read_addtid_b32 v57 offset:11264
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s36, v57
		s_nop 1
		v_mul_lo_u32 v57, s36, v56
		v_lshlrev_b32_e32 v57, 6, v57
		v_accvgpr_write_b32 a1, v57
		v_lshrrev_b32_e32 v57, 4, v0
		s_mov_b32 m0, s17
		v_and_b32_e32 v57, 1, v57
		ds_read_addtid_b32 v58 offset:11264
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s36, v58
		s_nop 1
		v_mul_lo_u32 v58, s36, v57
		v_lshlrev_b32_e32 v58, 5, v58
		v_accvgpr_write_b32 a2, v58
		v_accvgpr_read_b32 v58, a1
		v_accvgpr_read_b32 v59, a2
		v_add3_u32 v11, v11, v58, v59
		v_lshrrev_b32_e32 v58, 3, v0
		s_mov_b32 m0, s17
		v_and_b32_e32 v58, 1, v58
		ds_read_addtid_b32 v59 offset:11264
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s36, v59
		s_nop 1
		v_mul_lo_u32 v59, s36, v58
		v_lshlrev_b32_e32 v59, 4, v59
		v_accvgpr_write_b32 a3, v59
		v_lshrrev_b32_e32 v59, 2, v0
		s_mov_b32 m0, s17
		v_and_b32_e32 v59, 1, v59
		ds_read_addtid_b32 v60 offset:11264
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s36, v60
		s_nop 1
		v_mul_lo_u32 v60, s36, v59
		v_lshlrev_b32_e32 v60, 3, v60
		v_accvgpr_write_b32 a4, v60
		v_accvgpr_read_b32 v60, a3
		v_accvgpr_read_b32 v61, a4
		v_add3_u32 v11, v11, v60, v61
		v_lshrrev_b32_e32 v60, 1, v0
		s_mov_b32 m0, s17
		v_and_b32_e32 v60, 1, v60
		ds_read_addtid_b32 v61 offset:11264
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s36, v61
		s_nop 1
		v_mul_lo_u32 v61, s36, v60
		v_lshlrev_b32_e32 v61, 2, v61
		v_accvgpr_write_b32 a5, v61
		v_lshrrev_b32_e32 v61, 5, v0
		v_and_b32_e32 v61, 1, v61
		v_lshlrev_b32_e32 v61, 4, v61
		v_accvgpr_read_b32 v62, a5
		s_mov_b32 m0, s17
		v_add3_u32 v11, v11, v62, v61
		ds_read_addtid_b32 v62 offset:7168
		s_mov_b32 m0, s17
		s_nop 0
		ds_read_addtid_b32 v63 offset:8192
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s36, v62
		v_readfirstlane_b32 s37, v63
		s_nop 1
		v_cndmask_b32_e64 v11, v10, v11, s[36:37]
		s_mov_b32 s36, s8
		s_mov_b32 s37, s9
		s_mov_b32 s38, s30
		s_mov_b32 s39, s31
		buffer_store_dwordx4 v[64:67], v11, s[36:39], 0 offen
		v_accvgpr_read_b32 v11, a0
		v_add3_u32 v11, s41, v11, v9
		v_accvgpr_read_b32 v62, a1
		v_accvgpr_read_b32 v63, a2
		v_add3_u32 v11, v11, v62, v63
		v_accvgpr_read_b32 v62, a3
		v_accvgpr_read_b32 v63, a4
		v_add3_u32 v11, v11, v62, v63
		v_accvgpr_read_b32 v62, a5
		s_mov_b32 m0, s17
		v_add3_u32 v11, v11, v62, v61
		ds_read_addtid_b32 v62 offset:7168
		s_mov_b32 m0, s17
		s_nop 0
		ds_read_addtid_b32 v63 offset:8192
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s50, v62
		v_readfirstlane_b32 s51, v63
		s_nop 1
		v_cndmask_b32_e64 v11, v10, v11, s[50:51]
		buffer_store_dwordx4 v[16:19], v11, s[36:39], 0 offen
		v_accvgpr_read_b32 v11, a0
		v_add3_u32 v11, s42, v11, v9
		v_accvgpr_read_b32 v16, a1
		v_accvgpr_read_b32 v17, a2
		v_add3_u32 v11, v11, v16, v17
		v_accvgpr_read_b32 v16, a3
		v_accvgpr_read_b32 v17, a4
		v_add3_u32 v11, v11, v16, v17
		v_accvgpr_read_b32 v16, a5
		s_mov_b32 m0, s17
		v_add3_u32 v11, v11, v16, v61
		ds_read_addtid_b32 v16 offset:7168
		s_mov_b32 m0, s17
		s_nop 0
		ds_read_addtid_b32 v17 offset:8192
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s50, v16
		v_readfirstlane_b32 s51, v17
		s_nop 1
		v_cndmask_b32_e64 v11, v10, v11, s[50:51]
		buffer_store_dwordx4 v[20:23], v11, s[36:39], 0 offen
		v_accvgpr_read_b32 v11, a0
		v_add3_u32 v11, s21, v11, v9
		v_accvgpr_read_b32 v16, a1
		v_accvgpr_read_b32 v17, a2
		v_add3_u32 v11, v11, v16, v17
		v_accvgpr_read_b32 v16, a3
		v_accvgpr_read_b32 v17, a4
		v_add3_u32 v11, v11, v16, v17
		v_accvgpr_read_b32 v16, a5
		s_mov_b32 m0, s17
		v_add3_u32 v11, v11, v16, v61
		ds_read_addtid_b32 v16 offset:7168
		s_mov_b32 m0, s17
		s_nop 0
		ds_read_addtid_b32 v17 offset:8192
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s50, v16
		v_readfirstlane_b32 s51, v17
		s_nop 1
		v_cndmask_b32_e64 v11, v10, v11, s[50:51]
		buffer_store_dwordx4 v[24:27], v11, s[36:39], 0 offen
		v_lshlrev_b32_e32 v6, 6, v6
		v_lshlrev_b32_e32 v11, 5, v56
		v_lshlrev_b32_e32 v16, 4, v57
		v_lshlrev_b32_e32 v17, 3, v58
		v_lshlrev_b32_e32 v18, 2, v59
		v_add_u32_e32 v7, 0x80, v7
		v_lshlrev_b32_e32 v19, 1, v60
		v_bitop3_b32 v7, v18, v7, v19 bitop3:0x96
		v_bitop3_b32 v7, v16, v17, v7 bitop3:0x96
		s_mov_b32 m0, s17
		v_bitop3_b32 v6, v6, v11, v7 bitop3:0x96
		ds_read_addtid_b32 v7 offset:11264
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s45, v7
		s_nop 1
		v_mul_lo_u32 v6, s45, v6
		v_lshlrev_b32_e32 v6, 1, v6
		v_accvgpr_write_b32 a6, v6
		v_accvgpr_read_b32 v6, a6
		s_mov_b32 m0, s17
		v_add3_u32 v6, s26, v6, v61
		ds_read_addtid_b32 v16 offset:9216
		s_mov_b32 m0, s17
		s_nop 0
		ds_read_addtid_b32 v17 offset:10240
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s50, v16
		v_readfirstlane_b32 s51, v17
		s_nop 1
		v_cndmask_b32_e64 v6, v10, v6, s[50:51]
		buffer_store_dwordx4 v[48:51], v6, s[36:39], 0 offen
		v_accvgpr_read_b32 v6, a6
		s_mov_b32 m0, s17
		v_add3_u32 v6, s41, v6, v61
		ds_read_addtid_b32 v16 offset:9216
		s_mov_b32 m0, s17
		s_nop 0
		ds_read_addtid_b32 v17 offset:10240
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s50, v16
		v_readfirstlane_b32 s51, v17
		s_nop 1
		v_cndmask_b32_e64 v6, v10, v6, s[50:51]
		buffer_store_dwordx4 v[12:15], v6, s[36:39], 0 offen
		v_accvgpr_read_b32 v6, a6
		s_mov_b32 m0, s17
		v_add3_u32 v6, s42, v6, v61
		ds_read_addtid_b32 v12 offset:9216
		s_mov_b32 m0, s17
		s_nop 0
		ds_read_addtid_b32 v13 offset:10240
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s50, v12
		v_readfirstlane_b32 s51, v13
		s_nop 1
		v_cndmask_b32_e64 v6, v10, v6, s[50:51]
		buffer_store_dwordx4 v[32:35], v6, s[36:39], 0 offen
		v_accvgpr_read_b32 v6, a6
		s_mov_b32 m0, s17
		v_add3_u32 v6, s21, v6, v61
		ds_read_addtid_b32 v12 offset:9216
		s_mov_b32 m0, s17
		s_nop 0
		ds_read_addtid_b32 v13 offset:10240
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s50, v12
		v_readfirstlane_b32 s51, v13
		s_nop 1
		v_cndmask_b32_e64 v6, v10, v6, s[50:51]
		buffer_store_dwordx4 v[52:55], v6, s[36:39], 0 offen
		v_accvgpr_read_b32 v6, a23
		v_add_u32_e32 v6, 0x10000, v6
		v_accvgpr_read_b32 v7, a15
		ds_read_b128 a[8:11], v7 offset:18864
		v_accvgpr_read_b32 v7, a20
		ds_read_b128 a[12:15], v7 offset:18864
		v_accvgpr_read_b32 v7, a21
		ds_read_b128 a[16:19], v7 offset:18864
		v_accvgpr_read_b32 v7, a22
		ds_read_b128 a[20:23], v7 offset:18864
		v_accvgpr_read_b32 v7, a36
		v_accvgpr_read_b32 v11, a37
		v_add3_u32 v6, v6, v7, v11
		v_and_b32_e32 v7, 63, v0
		v_lshrrev_b32_e32 v11, 2, v7
		v_and_b32_e32 v11, 1, v11
		v_lshlrev_b32_e32 v11, 5, v11
		v_lshrrev_b32_e32 v12, 1, v7
		v_and_b32_e32 v12, 1, v12
		v_lshlrev_b32_e32 v12, 4, v12
		v_and_b32_e32 v13, 1, v7
		v_lshlrev_b32_e32 v13, 3, v13
		v_add3_u32 v11, v11, v12, v13
		v_lshrrev_b32_e32 v12, 5, v7
		v_xor_b32_e32 v11, v11, v12
		v_lshrrev_b32_e32 v12, 6, v11
		v_lshrrev_b32_e32 v13, 3, v7
		v_and_b32_e32 v13, 1, v13
		v_add_u32_e32 v12, v12, v13
		v_and_b32_e32 v12, 1, v12
		v_lshlrev_b32_e32 v12, 2, v12
		v_lshrrev_b32_e32 v14, 5, v11
		v_and_b32_e32 v14, 1, v14
		v_lshlrev_b32_e32 v14, 1, v14
		v_lshrrev_b32_e32 v7, 4, v7
		v_and_b32_e32 v7, 1, v7
		v_lshlrev_b32_e32 v13, 6, v13
		v_lshl_add_u32 v7, v7, 7, v13
		v_add_u32_e32 v7, v7, v11
		v_lshrrev_b32_e32 v11, 4, v11
		v_bitop3_b32 v7, v7, v11, 1 bitop3:0x78
		v_bitop3_b32 v7, v12, v14, v7 bitop3:0x96
		v_lshl_add_u32 v7, v7, 4, v6
		v_and_b32_e32 v11, 63, v0
		v_lshrrev_b32_e32 v12, 2, v11
		v_and_b32_e32 v12, 1, v12
		v_lshlrev_b32_e32 v12, 5, v12
		v_add_u32_e32 v12, 2, v12
		v_lshrrev_b32_e32 v13, 1, v11
		v_and_b32_e32 v13, 1, v13
		v_lshlrev_b32_e32 v13, 4, v13
		v_and_b32_e32 v14, 1, v11
		v_lshlrev_b32_e32 v14, 3, v14
		v_add3_u32 v12, v12, v13, v14
		v_lshrrev_b32_e32 v13, 5, v11
		v_xor_b32_e32 v12, v12, v13
		v_lshrrev_b32_e32 v13, 6, v12
		v_lshrrev_b32_e32 v14, 3, v11
		v_and_b32_e32 v14, 1, v14
		v_add_u32_e32 v13, v13, v14
		v_and_b32_e32 v13, 1, v13
		v_lshlrev_b32_e32 v13, 2, v13
		v_lshrrev_b32_e32 v15, 5, v12
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 1, v15
		v_lshrrev_b32_e32 v11, 4, v11
		v_and_b32_e32 v11, 1, v11
		v_lshlrev_b32_e32 v14, 6, v14
		v_lshl_add_u32 v11, v11, 7, v14
		v_add_u32_e32 v11, v11, v12
		v_lshrrev_b32_e32 v12, 4, v12
		v_bitop3_b32 v11, v11, v12, 1 bitop3:0x78
		v_bitop3_b32 v11, v13, v15, v11 bitop3:0x96
		v_lshl_add_u32 v11, v11, 4, v6
		v_and_b32_e32 v12, 63, v0
		v_lshrrev_b32_e32 v13, 2, v12
		v_and_b32_e32 v13, 1, v13
		v_lshlrev_b32_e32 v13, 5, v13
		v_add_u32_e32 v13, 4, v13
		v_lshrrev_b32_e32 v14, 1, v12
		v_and_b32_e32 v14, 1, v14
		v_lshlrev_b32_e32 v14, 4, v14
		v_and_b32_e32 v15, 1, v12
		v_lshlrev_b32_e32 v15, 3, v15
		v_add3_u32 v13, v13, v14, v15
		v_lshrrev_b32_e32 v14, 5, v12
		v_xor_b32_e32 v13, v13, v14
		v_lshrrev_b32_e32 v14, 6, v13
		v_lshrrev_b32_e32 v15, 3, v12
		v_and_b32_e32 v15, 1, v15
		v_add_u32_e32 v14, v14, v15
		v_and_b32_e32 v14, 1, v14
		v_lshlrev_b32_e32 v14, 2, v14
		v_lshrrev_b32_e32 v16, 5, v13
		v_and_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v16, 1, v16
		v_lshrrev_b32_e32 v12, 4, v12
		v_and_b32_e32 v12, 1, v12
		v_lshlrev_b32_e32 v15, 6, v15
		v_lshl_add_u32 v12, v12, 7, v15
		v_add_u32_e32 v12, v12, v13
		v_lshrrev_b32_e32 v13, 4, v13
		v_bitop3_b32 v12, v12, v13, 1 bitop3:0x78
		v_bitop3_b32 v12, v14, v16, v12 bitop3:0x96
		v_lshl_add_u32 v12, v12, 4, v6
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_waitcnt vmcnt(3)
		ds_write_b128 v5, v[28:31] offset:18864
		s_waitcnt vmcnt(2)
		ds_write_b128 v5, v[36:39] offset:22960
		s_waitcnt vmcnt(1)
		ds_write_b128 v5, v[40:43] offset:27056
		s_waitcnt vmcnt(0)
		ds_write_b128 v5, v[44:47] offset:31152
		v_and_b32_e32 v5, 63, v0
		v_lshrrev_b32_e32 v13, 2, v5
		v_and_b32_e32 v13, 1, v13
		v_lshlrev_b32_e32 v13, 5, v13
		v_add_u32_e32 v13, 6, v13
		v_lshrrev_b32_e32 v14, 1, v5
		v_and_b32_e32 v14, 1, v14
		v_lshlrev_b32_e32 v14, 4, v14
		v_and_b32_e32 v15, 1, v5
		v_lshlrev_b32_e32 v15, 3, v15
		v_add3_u32 v13, v13, v14, v15
		v_lshrrev_b32_e32 v14, 5, v5
		v_xor_b32_e32 v13, v13, v14
		v_lshrrev_b32_e32 v14, 6, v13
		v_lshrrev_b32_e32 v15, 3, v5
		v_and_b32_e32 v15, 1, v15
		v_add_u32_e32 v14, v14, v15
		v_and_b32_e32 v14, 1, v14
		v_lshlrev_b32_e32 v14, 2, v14
		v_lshrrev_b32_e32 v16, 5, v13
		v_and_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v16, 1, v16
		v_lshrrev_b32_e32 v5, 4, v5
		v_and_b32_e32 v5, 1, v5
		v_lshlrev_b32_e32 v15, 6, v15
		v_lshl_add_u32 v5, v5, 7, v15
		v_add_u32_e32 v5, v5, v13
		v_lshrrev_b32_e32 v13, 4, v13
		v_bitop3_b32 v5, v5, v13, 1 bitop3:0x78
		v_bitop3_b32 v5, v14, v16, v5 bitop3:0x96
		v_lshl_add_u32 v5, v5, 4, v6
		s_add_i32 s21, s43, 1
		s_mul_i32 s21, s21, 0x100
		s_lshr_b32 s26, s56, 6
		s_mul_i32 s26, 0x410, s26
		s_mov_b32 m0, s26
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v6, a38
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		ds_read_b128 a[24:27], v7 offset:2480
		ds_read_b128 a[28:31], v11 offset:2480
		ds_read_b128 a[32:35], v12 offset:2480
		ds_read_b128 a[40:43], v5 offset:2480
		s_mov_b32 m0, s17
		s_nop 0
		ds_read_addtid_b32 v5 offset:4096
		s_mov_b32 m0, s26
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s41, v5
		s_add_i32 s21, s21, s41
		s_cmp_lt_i32 s23, s21
		s_cselect_b32 s21, s23, s21
		s_add_i32 s41, s21, 0x7f
		s_barrier
		s_cmp_lt_i32 s41, 0
		s_cselect_b32 s42, s27, 0
		s_add_i32 s41, s41, s42
		s_mov_b32 m0, s17
		s_ashr_i32 s41, s41, 7
		ds_read_addtid_b32 v5 offset:4096
		s_mov_b32 m0, s26
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s42, v5
		s_add_i32 s42, s44, s42
		s_cmp_lt_i32 s42, 0
		s_cselect_b32 s45, s27, 0
		s_add_i32 s42, s42, s45
		s_ashr_i32 s42, s42, 7
		s_cmp_lt_i32 s42, s41
		s_cselect_b32 s42, s42, s41
		s_cmp_gt_i32 s42, 0
		s_cselect_b32 s42, s42, 0
		s_add_i32 m0, m0, 0x1040
		s_mov_b32 m0, s17
		s_nop 0
		ds_read_addtid_b32 v5 offset:11264
		s_mov_b32 m0, s26
		s_nop 0
		s_add_i32 m0, m0, 0x1040
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s45, v5
		s_mul_i32 s43, s43, s45
		v_accvgpr_read_b32 v5, a39
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		v_accvgpr_read_b32 v5, a63
		v_add_u32_e32 v5, s44, v5
		s_add_i32 m0, m0, 0x1040
		v_accvgpr_read_b32 v6, a62
		v_add_u32_e32 v6, s44, v6
		v_accvgpr_read_b32 v7, a56
		buffer_load_dwordx4 v7, s[28:31], 0 offen lds
		s_mul_i32 s41, s41, 0x80
		s_add_i32 m0, m0, 0x1040
		s_mul_i32 s44, s42, 0x80
		v_accvgpr_read_b32 v7, a57
		buffer_load_dwordx4 v7, s[28:31], 0 offen lds
		s_nop 0
		s_mov_b32 m0, s17
		s_nop 0
		ds_read_addtid_b32 v7 offset:5120
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s42, v7
		s_nop 1
		v_mov_b32_e32 v7, s42
		s_lshr_b32 s42, s56, 6
		s_mul_i32 s42, 0x440, s42
		s_add_i32 m0, s42, 0x81f0
		s_mov_b32 m0, s17
		s_nop 0
		ds_read_addtid_b32 v11 offset:5120
		s_add_i32 m0, s42, 0x81f0
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s45, v11
		s_nop 1
		v_mov_b32_e32 v11, s45
		v_accvgpr_read_b32 v12, a58
		buffer_load_dwordx4 v12, s[32:35], 0 offen lds
		s_nop 0
		s_mov_b32 m0, s17
		s_nop 0
		ds_read_addtid_b32 v12 offset:6144
		s_add_i32 m0, s42, 0x81f0
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s45, v12
		s_nop 1
		v_mov_b32_e32 v12, s45
		v_accvgpr_write_b32 a36, v12
		s_add_i32 m0, m0, 0x1100
		s_mov_b32 m0, s17
		s_nop 0
		ds_read_addtid_b32 v12 offset:6144
		s_add_i32 m0, s42, 0x81f0
		s_nop 0
		s_add_i32 m0, m0, 0x1100
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s45, v12
		s_nop 1
		v_mov_b32_e32 v12, s45
		v_accvgpr_write_b32 a37, v12
		v_accvgpr_read_b32 v12, a59
		buffer_load_dwordx4 v12, s[32:35], 0 offen lds
		s_mov_b32 s45, 0
		s_add_i32 m0, m0, 0x1100
		v_mov_b64_e32 v[18:19], 0
		v_accvgpr_read_b32 v12, a60
		buffer_load_dwordx4 v12, s[32:35], 0 offen lds
		v_mov_b64_e32 v[16:17], 0
		s_add_i32 m0, m0, 0x1100
		s_cmp_lt_i32 0, s44
		v_accvgpr_read_b32 v12, a61
		buffer_load_dwordx4 v12, s[32:35], 0 offen lds
		v_mov_b64_e32 v[20:21], 0
		v_mov_b64_e32 v[22:23], 0
		v_mov_b64_e32 v[24:25], 0
		v_mov_b64_e32 v[26:27], 0
		v_mov_b64_e32 v[28:29], 0
		v_mov_b64_e32 v[30:31], 0
		v_mov_b64_e32 v[32:33], 0
		v_mov_b64_e32 v[34:35], 0
		v_mov_b64_e32 v[36:37], 0
		v_mov_b64_e32 v[38:39], 0
		v_mov_b64_e32 v[40:41], 0
		v_mov_b64_e32 v[42:43], 0
		v_mov_b64_e32 v[44:45], 0
		v_mov_b64_e32 v[46:47], 0
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
		s_add_i32 s50, s45, 0x80
		s_lshr_b32 s51, s45, 7
		s_and_b32 s52, s51, 1
		s_mul_i32 s53, 0x4100, s52
		v_and_b32_e32 v12, 63, v0
		v_lshrrev_b32_e32 v12, 5, v12
		v_lshlrev_b32_e32 v12, 4, v12
		v_and_b32_e32 v13, 63, v0
		v_and_b32_e32 v13, 31, v13
		v_lshrrev_b32_e32 v13, 4, v13
		v_lshlrev_b32_e32 v13, 9, v13
		v_add3_u32 v12, s53, v12, v13
		v_and_b32_e32 v13, 63, v0
		v_and_b32_e32 v13, 31, v13
		v_lshrrev_b32_e32 v13, 3, v13
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v14, 0x2080
		v_mul_lo_u32 v14, v14, v13
		v_and_b32_e32 v13, 63, v0
		v_and_b32_e32 v13, 31, v13
		v_lshrrev_b32_e32 v13, 2, v13
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v15, 0x1040
		v_mul_lo_u32 v15, v15, v13
		v_add3_u32 v12, v12, v14, v15
		v_and_b32_e32 v13, 63, v0
		v_and_b32_e32 v13, 31, v13
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v14, 0x410
		v_mul_lo_u32 v14, v14, v13
		v_and_b32_e32 v13, 63, v0
		v_and_b32_e32 v13, 31, v13
		v_lshrrev_b32_e32 v13, 1, v13
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v15, 0x820
		v_mul_lo_u32 v15, v15, v13
		v_add3_u32 v12, v12, v15, v14
		ds_read_b128 v[48:51], v12
		ds_read_b128 v[52:55], v12 offset:32
		ds_read_b128 a[44:47], v12 offset:64
		ds_read_b128 a[48:51], v12 offset:96
		ds_read_b128 v[56:59], v12 offset:256
		ds_read_b128 v[96:99], v12 offset:288
		ds_read_b128 a[52:55], v12 offset:320
		ds_read_b128 a[56:59], v12 offset:352
		ds_read_b128 v[100:103], v12 offset:128
		ds_read_b128 v[104:107], v12 offset:160
		ds_read_b128 a[60:63], v12 offset:192
		ds_read_b128 a[64:67], v12 offset:224
		ds_read_b128 v[108:111], v12 offset:384
		ds_read_b128 v[112:115], v12 offset:416
		ds_read_b128 a[68:71], v12 offset:448
		ds_read_b128 a[72:75], v12 offset:480
		s_mul_i32 s52, 0x4400, s52
		v_and_b32_e32 v12, 63, v0
		v_lshrrev_b32_e32 v12, 5, v12
		v_mov_b32_e32 v13, 0x2200
		v_mul_lo_u32 v13, v13, v12
		v_and_b32_e32 v12, 63, v0
		v_and_b32_e32 v12, 31, v12
		v_lshrrev_b32_e32 v12, 4, v12
		v_lshlrev_b32_e32 v12, 5, v12
		v_add3_u32 v12, s52, v13, v12
		v_and_b32_e32 v13, 63, v0
		v_and_b32_e32 v13, 15, v13
		v_lshrrev_b32_e32 v13, 2, v13
		v_mov_b32_e32 v14, 0x440
		v_mul_lo_u32 v14, v14, v13
		v_and_b32_e32 v13, 63, v0
		v_and_b32_e32 v13, 15, v13
		v_and_b32_e32 v13, 3, v13
		v_lshlrev_b32_e32 v13, 3, v13
		v_add3_u32 v12, v12, v14, v13
		ds_read_b64_tr_b16 a[76:77], v12 offset:33264
		ds_read_b64_tr_b16 a[78:79], v12 offset:37616
		ds_read_b64_tr_b16 a[80:81], v12 offset:33392
		ds_read_b64_tr_b16 a[82:83], v12 offset:37744
		ds_read_b64_tr_b16 a[84:85], v12 offset:33520
		ds_read_b64_tr_b16 a[86:87], v12 offset:37872
		ds_read_b64_tr_b16 a[88:89], v12 offset:33648
		ds_read_b64_tr_b16 a[90:91], v12 offset:38000
		ds_read_b64_tr_b16 a[92:93], v12 offset:33776
		ds_read_b64_tr_b16 a[94:95], v12 offset:38128
		ds_read_b64_tr_b16 a[96:97], v12 offset:33904
		ds_read_b64_tr_b16 a[98:99], v12 offset:38256
		ds_read_b64_tr_b16 a[100:101], v12 offset:34032
		ds_read_b64_tr_b16 a[102:103], v12 offset:38384
		ds_read_b64_tr_b16 a[104:105], v12 offset:34160
		ds_read_b64_tr_b16 a[106:107], v12 offset:38512
		ds_read_b64_tr_b16 a[108:109], v12 offset:33328
		ds_read_b64_tr_b16 a[110:111], v12 offset:37680
		ds_read_b64_tr_b16 a[112:113], v12 offset:33456
		ds_read_b64_tr_b16 a[114:115], v12 offset:37808
		ds_read_b64_tr_b16 a[116:117], v12 offset:33584
		ds_read_b64_tr_b16 a[118:119], v12 offset:37936
		ds_read_b64_tr_b16 a[120:121], v12 offset:33712
		ds_read_b64_tr_b16 a[122:123], v12 offset:38064
		ds_read_b64_tr_b16 a[124:125], v12 offset:33840
		ds_read_b64_tr_b16 a[126:127], v12 offset:38192
		ds_read_b64_tr_b16 a[128:129], v12 offset:33968
		ds_read_b64_tr_b16 a[130:131], v12 offset:38320
		ds_read_b64_tr_b16 a[132:133], v12 offset:34096
		ds_read_b64_tr_b16 a[134:135], v12 offset:38448
		ds_read_b64_tr_b16 a[136:137], v12 offset:34224
		ds_read_b64_tr_b16 a[138:139], v12 offset:38576
		s_barrier
		v_lshrrev_b32_e32 v12, 3, v0
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v13, 64
		v_mul_lo_u32 v13, v13, v12
		v_lshrrev_b32_e32 v12, 4, v0
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v14, 32
		v_mul_lo_u32 v14, v14, v12
		v_lshrrev_b32_e32 v12, 5, v0
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v15, 16
		v_mul_lo_u32 v15, v15, v12
		v_bitop3_b32 v12, v13, v14, v15 bitop3:0x96
		v_lshrrev_b32_e32 v13, 6, v0
		v_and_b32_e32 v13, 1, v13
		v_lshrrev_b32_e32 v14, 7, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 2
		v_mul_lo_u32 v15, v15, v14
		v_bitop3_b32 v12, v12, v13, v15 bitop3:0x96
		v_add_u32_e32 v12, s50, v12
		v_lshrrev_b32_e32 v13, 3, v0
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v14, 64
		v_mul_lo_u32 v14, v14, v13
		v_lshrrev_b32_e32 v13, 4, v0
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v15, 32
		v_mul_lo_u32 v15, v15, v13
		v_bitop3_b32 v13, 4, v14, v15 bitop3:0x96
		v_lshrrev_b32_e32 v14, 5, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 16
		v_mul_lo_u32 v15, v15, v14
		v_xor_b32_e32 v13, v13, v15
		v_lshrrev_b32_e32 v14, 6, v0
		v_and_b32_e32 v14, 1, v14
		v_lshrrev_b32_e32 v15, 7, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v60, 2
		v_mul_lo_u32 v60, v60, v15
		v_bitop3_b32 v13, v13, v14, v60 bitop3:0x96
		v_add_u32_e32 v13, s50, v13
		v_lshrrev_b32_e32 v14, 3, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 64
		v_mul_lo_u32 v15, v15, v14
		v_lshrrev_b32_e32 v14, 4, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v60, 32
		v_mul_lo_u32 v60, v60, v14
		v_bitop3_b32 v14, 8, v15, v60 bitop3:0x96
		v_lshrrev_b32_e32 v15, 5, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v60, 16
		v_mul_lo_u32 v60, v60, v15
		v_xor_b32_e32 v14, v14, v60
		v_lshrrev_b32_e32 v15, 6, v0
		v_and_b32_e32 v15, 1, v15
		v_lshrrev_b32_e32 v60, 7, v0
		v_and_b32_e32 v60, 1, v60
		v_mov_b32_e32 v62, 2
		v_mul_lo_u32 v62, v62, v60
		v_bitop3_b32 v14, v14, v15, v62 bitop3:0x96
		v_add_u32_e32 v14, s50, v14
		v_lshrrev_b32_e32 v15, 3, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v60, 64
		v_mul_lo_u32 v60, v60, v15
		v_lshrrev_b32_e32 v15, 4, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v62, 32
		v_mul_lo_u32 v62, v62, v15
		v_bitop3_b32 v15, 12, v60, v62 bitop3:0x96
		v_lshrrev_b32_e32 v60, 5, v0
		v_and_b32_e32 v60, 1, v60
		v_mov_b32_e32 v62, 16
		v_mul_lo_u32 v62, v62, v60
		v_xor_b32_e32 v15, v15, v62
		v_lshrrev_b32_e32 v60, 6, v0
		v_and_b32_e32 v60, 1, v60
		v_lshrrev_b32_e32 v62, 7, v0
		v_and_b32_e32 v62, 1, v62
		v_mov_b32_e32 v63, 2
		v_mul_lo_u32 v63, v63, v62
		v_bitop3_b32 v15, v15, v60, v63 bitop3:0x96
		v_add_u32_e32 v15, s50, v15
		v_cmp_lt_i32_e64 vcc, v12, s23
		s_mov_b64 s[52:53], vcc
		v_cmp_lt_i32_e64 vcc, v13, s23
		s_mov_b64 s[54:55], vcc
		v_cmp_lt_i32_e64 vcc, v14, s23
		s_mov_b64 s[58:59], vcc
		v_cmp_lt_i32_e64 vcc, v15, s23
		s_mov_b64 s[60:61], vcc
		v_lshrrev_b32_e32 v12, 3, v0
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v13, 16
		v_mul_lo_u32 v13, v13, v12
		v_lshrrev_b32_e32 v12, 4, v0
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v14, 32
		v_mul_lo_u32 v14, v14, v12
		v_lshrrev_b32_e32 v12, 5, v0
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v15, 64
		v_mul_lo_u32 v15, v15, v12
		v_bitop3_b32 v12, v13, v14, v15 bitop3:0x96
		v_lshrrev_b32_e32 v13, 6, v0
		v_and_b32_e32 v13, 1, v13
		v_lshrrev_b32_e32 v14, 7, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 2
		v_mul_lo_u32 v15, v15, v14
		v_bitop3_b32 v12, v12, v13, v15 bitop3:0x96
		v_add_u32_e32 v12, s50, v12
		v_lshrrev_b32_e32 v13, 3, v0
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v14, 16
		v_mul_lo_u32 v14, v14, v13
		v_lshrrev_b32_e32 v13, 4, v0
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v15, 32
		v_mul_lo_u32 v15, v15, v13
		v_bitop3_b32 v13, 4, v14, v15 bitop3:0x96
		v_lshrrev_b32_e32 v14, 5, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 64
		v_mul_lo_u32 v15, v15, v14
		v_xor_b32_e32 v13, v13, v15
		v_lshrrev_b32_e32 v14, 6, v0
		v_and_b32_e32 v14, 1, v14
		v_lshrrev_b32_e32 v15, 7, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v60, 2
		v_mul_lo_u32 v60, v60, v15
		v_bitop3_b32 v13, v13, v14, v60 bitop3:0x96
		v_add_u32_e32 v13, s50, v13
		v_lshrrev_b32_e32 v14, 3, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 16
		v_mul_lo_u32 v15, v15, v14
		v_lshrrev_b32_e32 v14, 4, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v60, 32
		v_mul_lo_u32 v60, v60, v14
		v_bitop3_b32 v14, 8, v15, v60 bitop3:0x96
		v_lshrrev_b32_e32 v15, 5, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v60, 64
		v_mul_lo_u32 v60, v60, v15
		v_xor_b32_e32 v14, v14, v60
		v_lshrrev_b32_e32 v15, 6, v0
		v_and_b32_e32 v15, 1, v15
		v_lshrrev_b32_e32 v60, 7, v0
		v_and_b32_e32 v60, 1, v60
		v_mov_b32_e32 v62, 2
		v_mul_lo_u32 v62, v62, v60
		v_bitop3_b32 v14, v14, v15, v62 bitop3:0x96
		v_add_u32_e32 v14, s50, v14
		v_cmp_lt_i32_e64 vcc, v12, s23
		s_mov_b64 s[62:63], vcc
		v_cmp_lt_i32_e64 vcc, v13, s23
		s_mov_b64 s[64:65], vcc
		v_cmp_lt_i32_e64 vcc, v14, s23
		s_mov_b64 s[66:67], vcc
		s_mul_i32 s57, s15, s45
		s_lshl_b32 s57, s57, 1
		s_lshl_b32 s68, s15, 8
		s_mul_i32 s69, s1, s13
		s_lshl_b32 s69, s69, 1
		s_add_i32 s68, s68, s69
		s_mul_i32 s69, s24, s14
		s_lshl_b32 s69, s69, 1
		s_add_i32 s68, s68, s69
		s_add_i32 s68, s68, s57
		v_lshrrev_b32_e32 v12, 4, v0
		v_and_b32_e32 v12, 1, v12
		v_mul_lo_u32 v12, s15, v12
		v_lshrrev_b32_e32 v13, 5, v0
		v_and_b32_e32 v13, 1, v13
		v_mul_lo_u32 v13, s15, v13
		v_lshrrev_b32_e32 v14, 7, v0
		v_mul_lo_u32 v14, s15, v14
		v_lshrrev_b32_e32 v15, 6, v0
		v_and_b32_e32 v15, 1, v15
		v_mul_lo_u32 v15, s15, v15
		v_lshlrev_b32_e32 v15, 1, v15
		v_lshl_add_u32 v14, v14, 2, v15
		v_lshl_add_u32 v13, v13, 5, v14
		v_lshl_add_u32 v12, v12, 6, v13
		v_lshrrev_b32_e32 v13, 3, v0
		v_and_b32_e32 v13, 1, v13
		v_mul_lo_u32 v13, s15, v13
		v_lshlrev_b32_e32 v13, 7, v13
		v_and_b32_e32 v14, 1, v0
		v_lshlrev_b32_e32 v14, 4, v14
		v_add3_u32 v12, v12, v13, v14
		v_lshrrev_b32_e32 v13, 2, v0
		v_and_b32_e32 v13, 1, v13
		v_lshlrev_b32_e32 v13, 6, v13
		v_lshrrev_b32_e32 v14, 1, v0
		v_and_b32_e32 v14, 1, v14
		v_lshlrev_b32_e32 v14, 5, v14
		v_add3_u32 v12, v12, v13, v14
		v_add_u32_e32 v13, s68, v12
		s_add_i32 s51, s51, 1
		s_and_b32 s51, s51, 1
		s_mul_i32 s68, 0x4100, s51
		s_add_i32 s68, s26, s68
		s_mov_b32 m0, s68
		v_cndmask_b32_e64 v13, v10, v13, s[52:53]
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		v_lshrrev_b32_e32 v13, 3, v0
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v14, 16
		v_mul_lo_u32 v14, v14, v13
		v_lshrrev_b32_e32 v13, 4, v0
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v15, 32
		v_mul_lo_u32 v15, v15, v13
		v_bitop3_b32 v13, 12, v14, v15 bitop3:0x96
		v_lshrrev_b32_e32 v14, 5, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 64
		v_mul_lo_u32 v15, v15, v14
		v_xor_b32_e32 v13, v13, v15
		v_lshrrev_b32_e32 v14, 6, v0
		v_and_b32_e32 v14, 1, v14
		v_lshrrev_b32_e32 v15, 7, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v60, 2
		v_mul_lo_u32 v60, v60, v15
		v_bitop3_b32 v13, v13, v14, v60 bitop3:0x96
		v_add_u32_e32 v13, s50, v13
		v_add_u32_e32 v12, s57, v12
		s_mul_i32 s52, 0x108, s15
		s_mul_i32 s53, s1, s13
		s_lshl_b32 s53, s53, 1
		s_add_i32 s52, s52, s53
		s_mul_i32 s53, s24, s14
		s_lshl_b32 s53, s53, 1
		s_add_i32 s52, s52, s53
		v_add_u32_e32 v14, s52, v12
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v14, v10, v14, s[54:55]
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		s_mul_i32 s52, 0x110, s15
		s_mul_i32 s53, s1, s13
		s_lshl_b32 s53, s53, 1
		s_add_i32 s52, s52, s53
		s_mul_i32 s53, s24, s14
		s_lshl_b32 s53, s53, 1
		s_add_i32 s52, s52, s53
		v_add_u32_e32 v14, s52, v12
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v14, v10, v14, s[58:59]
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		s_mul_i32 s52, 0x118, s15
		s_mul_i32 s53, s1, s13
		s_lshl_b32 s53, s53, 1
		s_add_i32 s52, s52, s53
		s_mul_i32 s53, s24, s14
		s_lshl_b32 s53, s53, 1
		s_add_i32 s52, s52, s53
		v_add_u32_e32 v12, s52, v12
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v12, v10, v12, s[60:61]
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		s_barrier
		s_mul_i32 s45, s20, s45
		s_lshl_b32 s45, s45, 1
		s_lshl_b32 s52, s20, 8
		s_mul_i32 s53, s1, s18
		s_lshl_b32 s53, s53, 1
		s_add_i32 s52, s52, s53
		s_mul_i32 s53, s24, s19
		s_lshl_b32 s53, s53, 1
		s_add_i32 s52, s52, s53
		s_add_i32 s52, s52, s45
		v_lshrrev_b32_e32 v12, 4, v0
		v_and_b32_e32 v12, 1, v12
		v_mul_lo_u32 v12, s20, v12
		v_lshrrev_b32_e32 v14, 5, v0
		v_and_b32_e32 v14, 1, v14
		v_mul_lo_u32 v14, s20, v14
		v_lshrrev_b32_e32 v15, 7, v0
		v_mul_lo_u32 v15, s20, v15
		v_lshrrev_b32_e32 v60, 6, v0
		v_and_b32_e32 v60, 1, v60
		v_mul_lo_u32 v60, s20, v60
		v_lshlrev_b32_e32 v60, 1, v60
		v_lshl_add_u32 v15, v15, 2, v60
		v_lshl_add_u32 v14, v14, 7, v15
		v_lshl_add_u32 v12, v12, 6, v14
		v_lshrrev_b32_e32 v14, 3, v0
		v_and_b32_e32 v14, 1, v14
		v_mul_lo_u32 v14, s20, v14
		v_lshlrev_b32_e32 v14, 5, v14
		v_and_b32_e32 v15, 1, v0
		v_lshlrev_b32_e32 v15, 4, v15
		v_add3_u32 v12, v12, v14, v15
		v_lshrrev_b32_e32 v14, 2, v0
		v_and_b32_e32 v14, 1, v14
		v_lshlrev_b32_e32 v14, 6, v14
		v_lshrrev_b32_e32 v15, 1, v0
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 5, v15
		v_add3_u32 v12, v12, v14, v15
		v_add_u32_e32 v14, s52, v12
		s_mul_i32 s51, 0x4400, s51
		s_add_i32 s51, s42, s51
		s_add_i32 m0, s51, 0x81f0
		v_cndmask_b32_e64 v14, v10, v14, s[62:63]
		buffer_load_dwordx4 v14, s[32:35], 0 offen lds
		v_add_u32_e32 v12, s45, v12
		s_mul_i32 s45, 0x108, s20
		s_mul_i32 s51, s1, s18
		s_lshl_b32 s51, s51, 1
		s_add_i32 s45, s45, s51
		s_mul_i32 s51, s24, s19
		s_lshl_b32 s51, s51, 1
		s_add_i32 s45, s45, s51
		v_add_u32_e32 v14, s45, v12
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v14, v10, v14, s[64:65]
		buffer_load_dwordx4 v14, s[32:35], 0 offen lds
		s_mul_i32 s45, 0x110, s20
		s_mul_i32 s51, s1, s18
		s_lshl_b32 s51, s51, 1
		s_add_i32 s45, s45, s51
		s_mul_i32 s51, s24, s19
		s_lshl_b32 s51, s51, 1
		s_add_i32 s45, s45, s51
		v_add_u32_e32 v14, s45, v12
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v14, v10, v14, s[66:67]
		buffer_load_dwordx4 v14, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v13, s23
		s_mul_i32 s45, 0x118, s20
		s_mul_i32 s51, s1, s18
		s_lshl_b32 s51, s51, 1
		s_add_i32 s45, s45, s51
		s_mul_i32 s51, s24, s19
		s_lshl_b32 s51, s51, 1
		s_add_i32 s45, s45, s51
		v_add_u32_e32 v12, s45, v12
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e32 v12, v10, v12, vcc
		s_cmp_lt_i32 s50, s44
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[128:143], v[48:51], a[8:11], 0
		v_mfma_f32_32x32x16_bf16 v[144:159], v[56:59], a[8:11], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[100:103], a[8:11], 0
		v_mfma_f32_32x32x16_bf16 v[176:191], v[108:111], a[8:11], 0
		v_mfma_f32_32x32x16_bf16 v[192:207], v[108:111], a[24:27], 0
		v_mfma_f32_32x32x16_bf16 v[208:223], v[48:51], a[24:27], 0
		buffer_load_dwordx4 v12, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], v[56:59], a[24:27], 0
		v_mfma_f32_32x32x16_bf16 v[240:255], v[100:103], a[24:27], 0
		v_mfma_f32_32x32x16_bf16 v[128:143], v[52:55], a[12:15], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], v[96:99], a[12:15], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[104:107], a[12:15], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[112:115], a[12:15], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[112:115], a[28:31], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[52:55], a[28:31], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[96:99], a[28:31], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[104:107], a[28:31], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[44:47], a[16:19], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[52:55], a[16:19], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[60:63], a[16:19], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[68:71], a[16:19], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[68:71], a[32:35], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[44:47], a[32:35], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[52:55], a[32:35], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[60:63], a[32:35], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[48:51], a[20:23], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[56:59], a[20:23], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[64:67], a[20:23], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[72:75], a[20:23], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[72:75], a[40:43], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[48:51], a[40:43], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[56:59], a[40:43], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[64:67], a[40:43], v[240:255]
		s_nop 4
		v_max_f32_e32 v12, v128, v129
		v_max_f32_e32 v13, v130, v131
		v_max_f32_e32 v14, v132, v133
		v_max_f32_e32 v15, v134, v135
		v_max_f32_e32 v48, v136, v137
		v_max_f32_e32 v49, v138, v139
		v_max_f32_e32 v50, v140, v141
		v_max_f32_e32 v51, v142, v143
		v_max_f32_e32 v52, v144, v145
		v_max_f32_e32 v53, v146, v147
		v_max_f32_e32 v54, v148, v149
		v_max_f32_e32 v55, v150, v151
		v_max_f32_e32 v56, v152, v153
		v_max_f32_e32 v57, v154, v155
		v_max_f32_e32 v58, v156, v157
		v_max_f32_e32 v59, v158, v159
		v_max_f32_e32 v60, v160, v161
		v_max_f32_e32 v62, v162, v163
		v_max_f32_e32 v63, v164, v165
		v_max_f32_e32 v96, v166, v167
		v_max_f32_e32 v97, v168, v169
		v_max_f32_e32 v98, v170, v171
		v_max_f32_e32 v99, v172, v173
		v_max_f32_e32 v100, v174, v175
		v_max_f32_e32 v101, v176, v177
		v_max_f32_e32 v102, v178, v179
		v_max_f32_e32 v103, v180, v181
		v_max_f32_e32 v104, v182, v183
		v_max_f32_e32 v105, v184, v185
		v_max_f32_e32 v106, v186, v187
		v_max_f32_e32 v107, v188, v189
		v_max_f32_e32 v108, v190, v191
		v_max_f32_e32 v12, v12, v13
		v_max_f32_e32 v13, v14, v15
		v_max_f32_e32 v14, v48, v49
		v_max_f32_e32 v15, v50, v51
		v_max_f32_e32 v48, v52, v53
		v_max_f32_e32 v49, v54, v55
		v_max_f32_e32 v50, v56, v57
		v_max_f32_e32 v51, v58, v59
		v_max_f32_e32 v52, v60, v62
		v_max_f32_e32 v53, v63, v96
		v_max_f32_e32 v54, v97, v98
		v_max_f32_e32 v55, v99, v100
		v_max_f32_e32 v56, v101, v102
		v_max_f32_e32 v57, v103, v104
		v_max_f32_e32 v58, v105, v106
		v_max_f32_e32 v59, v107, v108
		v_max_f32_e32 v12, v12, v13
		v_max_f32_e32 v13, v14, v15
		v_max_f32_e32 v14, v48, v49
		v_max_f32_e32 v15, v50, v51
		v_max_f32_e32 v48, v52, v53
		v_max_f32_e32 v49, v54, v55
		v_max_f32_e32 v50, v56, v57
		v_max_f32_e32 v51, v58, v59
		v_max_f32_e32 v12, v12, v13
		v_max_f32_e32 v13, v14, v15
		v_max_f32_e32 v14, v48, v49
		v_max_f32_e32 v15, v50, v51
		v_max_f32_e32 v12, v12, v13
		v_max_f32_e32 v13, v14, v15
		v_max_f32_e32 v12, v12, v13
		v_and_b32_e32 v13, 1, v8
		v_lshrrev_b32_e32 v14, 4, v8
		v_and_b32_e32 v14, 1, v14
		v_lshlrev_b32_e32 v14, 4, v14
		v_lshrrev_b32_e32 v15, 3, v8
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 3, v15
		v_add3_u32 v13, v13, v14, v15
		v_lshrrev_b32_e32 v14, 2, v8
		v_and_b32_e32 v14, 1, v14
		v_lshlrev_b32_e32 v14, 2, v14
		v_lshrrev_b32_e32 v15, 1, v8
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 1, v15
		v_add3_u32 v13, v13, v14, v15
		v_lshlrev_b32_e32 v13, 2, v13
		ds_bpermute_b32 v14, v13, v12
		v_lshrrev_b32_e32 v15, 4, v8
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 4, v15
		v_lshrrev_b32_e32 v48, 3, v8
		v_and_b32_e32 v48, 1, v48
		v_lshlrev_b32_e32 v48, 3, v48
		v_lshrrev_b32_e32 v49, 2, v8
		v_and_b32_e32 v49, 1, v49
		v_lshlrev_b32_e32 v49, 2, v49
		v_and_b32_e32 v50, 1, v8
		v_add_u32_e32 v50, 32, v50
		v_lshrrev_b32_e32 v51, 1, v8
		v_and_b32_e32 v51, 1, v51
		v_lshlrev_b32_e32 v51, 1, v51
		v_bitop3_b32 v49, v49, v50, v51 bitop3:0x96
		v_bitop3_b32 v15, v15, v48, v49 bitop3:0x96
		v_lshlrev_b32_e32 v15, 2, v15
		ds_bpermute_b32 v48, v15, v12
		v_max_f32_e32 v12, v208, v209
		v_max_f32_e32 v49, v210, v211
		v_max_f32_e32 v50, v212, v213
		v_max_f32_e32 v51, v214, v215
		v_max_f32_e32 v52, v216, v217
		v_max_f32_e32 v53, v218, v219
		v_max_f32_e32 v54, v220, v221
		v_max_f32_e32 v55, v222, v223
		v_max_f32_e32 v56, v224, v225
		v_max_f32_e32 v57, v226, v227
		v_max_f32_e32 v58, v228, v229
		v_max_f32_e32 v59, v230, v231
		v_max_f32_e32 v60, v232, v233
		v_max_f32_e32 v62, v234, v235
		v_max_f32_e32 v63, v236, v237
		v_max_f32_e32 v96, v238, v239
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v98, v14, v48
		v_max_f32_e32 v14, v240, v241
		v_max_f32_e32 v48, v242, v243
		v_max_f32_e32 v97, v244, v245
		v_max_f32_e32 v99, v246, v247
		v_max_f32_e32 v100, v248, v249
		v_max_f32_e32 v101, v250, v251
		v_max_f32_e32 v102, v252, v253
		v_max_f32_e32 v103, v254, v255
		v_max_f32_e32 v104, v192, v193
		v_max_f32_e32 v105, v194, v195
		v_max_f32_e32 v106, v196, v197
		v_max_f32_e32 v107, v198, v199
		v_max_f32_e32 v108, v200, v201
		v_max_f32_e32 v109, v202, v203
		v_max_f32_e32 v110, v204, v205
		v_max_f32_e32 v111, v206, v207
		v_max_f32_e32 v12, v12, v49
		v_max_f32_e32 v49, v50, v51
		v_max_f32_e32 v50, v52, v53
		v_max_f32_e32 v51, v54, v55
		v_max_f32_e32 v52, v56, v57
		v_max_f32_e32 v53, v58, v59
		v_max_f32_e32 v54, v60, v62
		v_max_f32_e32 v55, v63, v96
		v_max_f32_e32 v14, v14, v48
		v_max_f32_e32 v48, v97, v99
		v_max_f32_e32 v56, v100, v101
		v_max_f32_e32 v57, v102, v103
		v_max_f32_e32 v58, v104, v105
		v_max_f32_e32 v59, v106, v107
		v_max_f32_e32 v60, v108, v109
		v_max_f32_e32 v62, v110, v111
		v_max_f32_e32 v12, v12, v49
		v_max_f32_e32 v49, v50, v51
		v_max_f32_e32 v50, v52, v53
		v_max_f32_e32 v51, v54, v55
		v_max_f32_e32 v14, v14, v48
		v_max_f32_e32 v48, v56, v57
		v_max_f32_e32 v52, v58, v59
		v_max_f32_e32 v53, v60, v62
		v_max_f32_e32 v12, v12, v49
		v_max_f32_e32 v49, v50, v51
		v_max_f32_e32 v14, v14, v48
		v_max_f32_e32 v48, v52, v53
		v_max_f32_e32 v12, v12, v49
		v_max_f32_e32 v14, v14, v48
		v_max_f32_e32 v12, v12, v14
		ds_bpermute_b32 v14, v13, v12
		ds_bpermute_b32 v48, v15, v12
		v_mov_b32_e32 v50, 0x3e38aa3b
		v_mov_b32_e32 v51, 0x3e38aa3b
		v_pk_mul_f32 v[52:53], v[128:129], v[50:51]
		v_pk_mul_f32 v[54:55], v[130:131], v[50:51]
		v_pk_mul_f32 v[56:57], v[132:133], v[50:51]
		v_pk_mul_f32 v[58:59], v[134:135], v[50:51]
		v_pk_mul_f32 v[62:63], v[136:137], v[50:51]
		v_pk_mul_f32 v[96:97], v[138:139], v[50:51]
		v_pk_mul_f32 v[100:101], v[140:141], v[50:51]
		v_pk_mul_f32 v[102:103], v[142:143], v[50:51]
		v_pk_mul_f32 v[104:105], v[144:145], v[50:51]
		v_pk_mul_f32 v[106:107], v[146:147], v[50:51]
		v_pk_mul_f32 v[108:109], v[148:149], v[50:51]
		v_pk_mul_f32 v[110:111], v[150:151], v[50:51]
		v_pk_mul_f32 v[112:113], v[152:153], v[50:51]
		v_pk_mul_f32 v[114:115], v[154:155], v[50:51]
		v_pk_mul_f32 v[116:117], v[156:157], v[50:51]
		v_pk_mul_f32 v[118:119], v[158:159], v[50:51]
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v99, v14, v48
		v_pk_mul_f32 v[48:49], v[98:99], v[50:51]
		v_max_f32_e32 v12, v7, v48
		v_max_f32_e32 v14, v11, v49
		v_pk_mul_f32 v[48:49], v[160:161], v[50:51]
		v_pk_mul_f32 v[98:99], v[162:163], v[50:51]
		v_pk_mul_f32 v[120:121], v[164:165], v[50:51]
		v_pk_mul_f32 v[122:123], v[166:167], v[50:51]
		v_pk_mul_f32 v[124:125], v[168:169], v[50:51]
		v_pk_mul_f32 v[126:127], v[170:171], v[50:51]
		v_pk_mul_f32 v[128:129], v[172:173], v[50:51]
		v_pk_mul_f32 v[130:131], v[174:175], v[50:51]
		v_pk_mul_f32 v[132:133], v[176:177], v[50:51]
		v_pk_mul_f32 v[134:135], v[178:179], v[50:51]
		v_pk_mul_f32 v[136:137], v[180:181], v[50:51]
		v_pk_mul_f32 v[138:139], v[182:183], v[50:51]
		v_pk_mul_f32 v[140:141], v[184:185], v[50:51]
		v_pk_mul_f32 v[142:143], v[186:187], v[50:51]
		v_pk_mul_f32 v[144:145], v[188:189], v[50:51]
		v_pk_mul_f32 v[146:147], v[190:191], v[50:51]
		v_pk_mul_f32 v[148:149], v[208:209], v[50:51]
		v_pk_mul_f32 v[150:151], v[210:211], v[50:51]
		v_pk_mul_f32 v[152:153], v[212:213], v[50:51]
		v_pk_mul_f32 v[154:155], v[214:215], v[50:51]
		v_pk_mul_f32 v[156:157], v[216:217], v[50:51]
		v_pk_mul_f32 v[158:159], v[218:219], v[50:51]
		v_pk_mul_f32 v[160:161], v[220:221], v[50:51]
		v_pk_mul_f32 v[162:163], v[222:223], v[50:51]
		v_pk_mul_f32 v[164:165], v[224:225], v[50:51]
		v_pk_mul_f32 v[166:167], v[226:227], v[50:51]
		v_pk_mul_f32 v[168:169], v[228:229], v[50:51]
		v_pk_mul_f32 v[170:171], v[230:231], v[50:51]
		v_pk_mul_f32 v[172:173], v[232:233], v[50:51]
		v_pk_mul_f32 v[174:175], v[234:235], v[50:51]
		v_pk_mul_f32 v[176:177], v[236:237], v[50:51]
		v_pk_mul_f32 v[178:179], v[238:239], v[50:51]
		v_pk_mul_f32 v[180:181], v[240:241], v[50:51]
		v_pk_mul_f32 v[182:183], v[242:243], v[50:51]
		v_pk_mul_f32 v[184:185], v[244:245], v[50:51]
		v_pk_mul_f32 v[186:187], v[246:247], v[50:51]
		v_pk_mul_f32 v[188:189], v[248:249], v[50:51]
		v_pk_mul_f32 v[190:191], v[250:251], v[50:51]
		v_pk_mul_f32 v[208:209], v[252:253], v[50:51]
		v_pk_mul_f32 v[210:211], v[254:255], v[50:51]
		v_pk_mul_f32 v[212:213], v[192:193], v[50:51]
		v_pk_mul_f32 v[192:193], v[194:195], v[50:51]
		v_pk_mul_f32 v[194:195], v[196:197], v[50:51]
		v_pk_mul_f32 v[196:197], v[198:199], v[50:51]
		v_pk_mul_f32 v[198:199], v[200:201], v[50:51]
		v_pk_mul_f32 v[200:201], v[202:203], v[50:51]
		v_pk_mul_f32 v[202:203], v[204:205], v[50:51]
		v_pk_mul_f32 v[204:205], v[206:207], v[50:51]
		v_sub_f32_e32 v50, v52, v12
		v_sub_f32_e32 v51, v53, v12
		v_sub_f32_e32 v52, v54, v12
		v_sub_f32_e32 v53, v55, v12
		v_sub_f32_e32 v54, v56, v12
		v_sub_f32_e32 v55, v57, v12
		v_sub_f32_e32 v56, v58, v12
		v_sub_f32_e32 v57, v59, v12
		v_sub_f32_e32 v58, v62, v12
		v_sub_f32_e32 v59, v63, v12
		v_sub_f32_e32 v60, v96, v12
		v_sub_f32_e32 v62, v97, v12
		v_sub_f32_e32 v63, v100, v12
		v_sub_f32_e32 v96, v101, v12
		v_sub_f32_e32 v97, v102, v12
		v_sub_f32_e32 v100, v103, v12
		v_sub_f32_e32 v101, v104, v12
		v_sub_f32_e32 v102, v105, v12
		v_sub_f32_e32 v103, v106, v12
		v_sub_f32_e32 v104, v107, v12
		v_sub_f32_e32 v105, v108, v12
		v_sub_f32_e32 v106, v109, v12
		v_sub_f32_e32 v107, v110, v12
		v_sub_f32_e32 v108, v111, v12
		v_sub_f32_e32 v109, v112, v12
		v_sub_f32_e32 v110, v113, v12
		v_sub_f32_e32 v111, v114, v12
		v_sub_f32_e32 v112, v115, v12
		v_sub_f32_e32 v113, v116, v12
		v_sub_f32_e32 v114, v117, v12
		v_sub_f32_e32 v115, v118, v12
		v_sub_f32_e32 v116, v119, v12
		v_sub_f32_e32 v48, v48, v12
		v_sub_f32_e32 v49, v49, v12
		v_sub_f32_e32 v98, v98, v12
		v_sub_f32_e32 v99, v99, v12
		v_sub_f32_e32 v117, v120, v12
		v_sub_f32_e32 v118, v121, v12
		v_sub_f32_e32 v119, v122, v12
		v_sub_f32_e32 v120, v123, v12
		v_sub_f32_e32 v121, v124, v12
		v_sub_f32_e32 v122, v125, v12
		v_sub_f32_e32 v123, v126, v12
		v_sub_f32_e32 v124, v127, v12
		v_sub_f32_e32 v125, v128, v12
		v_sub_f32_e32 v126, v129, v12
		v_sub_f32_e32 v127, v130, v12
		v_sub_f32_e32 v128, v131, v12
		v_sub_f32_e32 v129, v132, v12
		v_sub_f32_e32 v130, v133, v12
		v_sub_f32_e32 v131, v134, v12
		v_sub_f32_e32 v132, v135, v12
		v_sub_f32_e32 v133, v136, v12
		v_sub_f32_e32 v134, v137, v12
		v_sub_f32_e32 v135, v138, v12
		v_sub_f32_e32 v136, v139, v12
		v_sub_f32_e32 v137, v140, v12
		v_sub_f32_e32 v138, v141, v12
		v_sub_f32_e32 v139, v142, v12
		v_sub_f32_e32 v140, v143, v12
		v_sub_f32_e32 v141, v144, v12
		v_sub_f32_e32 v142, v145, v12
		v_sub_f32_e32 v143, v146, v12
		v_sub_f32_e32 v144, v147, v12
		v_sub_f32_e32 v145, v148, v14
		v_sub_f32_e32 v146, v149, v14
		v_sub_f32_e32 v147, v150, v14
		v_sub_f32_e32 v148, v151, v14
		v_sub_f32_e32 v149, v152, v14
		v_sub_f32_e32 v150, v153, v14
		v_sub_f32_e32 v151, v154, v14
		v_sub_f32_e32 v152, v155, v14
		v_sub_f32_e32 v153, v156, v14
		v_sub_f32_e32 v154, v157, v14
		v_sub_f32_e32 v155, v158, v14
		v_sub_f32_e32 v156, v159, v14
		v_sub_f32_e32 v157, v160, v14
		v_sub_f32_e32 v158, v161, v14
		v_sub_f32_e32 v159, v162, v14
		v_sub_f32_e32 v160, v163, v14
		v_sub_f32_e32 v161, v164, v14
		v_sub_f32_e32 v162, v165, v14
		v_sub_f32_e32 v163, v166, v14
		v_sub_f32_e32 v164, v167, v14
		v_sub_f32_e32 v165, v168, v14
		v_sub_f32_e32 v166, v169, v14
		v_sub_f32_e32 v167, v170, v14
		v_sub_f32_e32 v168, v171, v14
		v_sub_f32_e32 v169, v172, v14
		v_sub_f32_e32 v170, v173, v14
		v_sub_f32_e32 v171, v174, v14
		v_sub_f32_e32 v172, v175, v14
		v_sub_f32_e32 v173, v176, v14
		v_sub_f32_e32 v174, v177, v14
		v_sub_f32_e32 v175, v178, v14
		v_sub_f32_e32 v176, v179, v14
		v_sub_f32_e32 v177, v180, v14
		v_sub_f32_e32 v178, v181, v14
		v_sub_f32_e32 v179, v182, v14
		v_sub_f32_e32 v180, v183, v14
		v_sub_f32_e32 v181, v184, v14
		v_sub_f32_e32 v182, v185, v14
		v_sub_f32_e32 v183, v186, v14
		v_sub_f32_e32 v184, v187, v14
		v_sub_f32_e32 v185, v188, v14
		v_sub_f32_e32 v186, v189, v14
		v_sub_f32_e32 v187, v190, v14
		v_sub_f32_e32 v188, v191, v14
		v_sub_f32_e32 v189, v208, v14
		v_sub_f32_e32 v190, v209, v14
		v_sub_f32_e32 v191, v210, v14
		v_sub_f32_e32 v206, v211, v14
		v_sub_f32_e32 v207, v212, v14
		v_sub_f32_e32 v208, v213, v14
		v_sub_f32_e32 v192, v192, v14
		v_sub_f32_e32 v193, v193, v14
		v_sub_f32_e32 v194, v194, v14
		v_sub_f32_e32 v195, v195, v14
		v_sub_f32_e32 v196, v196, v14
		v_sub_f32_e32 v197, v197, v14
		v_sub_f32_e32 v198, v198, v14
		v_sub_f32_e32 v199, v199, v14
		v_sub_f32_e32 v200, v200, v14
		v_sub_f32_e32 v201, v201, v14
		v_sub_f32_e32 v202, v202, v14
		v_sub_f32_e32 v203, v203, v14
		v_sub_f32_e32 v204, v204, v14
		v_sub_f32_e32 v205, v205, v14
		v_exp_f32_e32 v210, v50
		v_exp_f32_e32 v212, v51
		v_exp_f32_e32 v211, v52
		v_exp_f32_e32 v213, v53
		v_exp_f32_e32 v50, v54
		v_exp_f32_e32 v52, v55
		v_exp_f32_e32 v51, v56
		v_exp_f32_e32 v53, v57
		v_exp_f32_e32 v54, v58
		v_exp_f32_e32 v56, v59
		v_exp_f32_e32 v55, v60
		v_exp_f32_e32 v57, v62
		v_exp_f32_e32 v58, v63
		v_exp_f32_e32 v62, v96
		v_exp_f32_e32 v59, v97
		v_exp_f32_e32 v63, v100
		v_exp_f32_e32 v96, v101
		v_exp_f32_e32 v100, v102
		v_exp_f32_e32 v97, v103
		v_exp_f32_e32 v101, v104
		v_exp_f32_e32 v102, v105
		v_exp_f32_e32 v104, v106
		v_exp_f32_e32 v103, v107
		v_exp_f32_e32 v105, v108
		v_exp_f32_e32 v106, v109
		v_exp_f32_e32 v108, v110
		v_exp_f32_e32 v107, v111
		v_exp_f32_e32 v109, v112
		v_exp_f32_e32 v110, v113
		v_exp_f32_e32 v112, v114
		v_exp_f32_e32 v111, v115
		v_exp_f32_e32 v113, v116
		v_exp_f32_e32 v114, v48
		v_exp_f32_e32 v214, v49
		v_exp_f32_e32 v115, v98
		v_exp_f32_e32 v215, v99
		v_exp_f32_e32 v48, v117
		v_exp_f32_e32 v98, v118
		v_exp_f32_e32 v49, v119
		v_exp_f32_e32 v99, v120
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
		v_exp_f32_e32 v139, v144
		v_exp_f32_e32 v141, v145
		v_exp_f32_e32 v143, v146
		v_exp_f32_e32 v144, v147
		v_exp_f32_e32 v146, v148
		v_exp_f32_e32 v145, v149
		v_exp_f32_e32 v147, v150
		v_exp_f32_e32 v148, v151
		v_exp_f32_e32 v150, v152
		v_exp_f32_e32 v149, v153
		v_exp_f32_e32 v151, v154
		v_exp_f32_e32 v152, v155
		v_exp_f32_e32 v154, v156
		v_exp_f32_e32 v153, v157
		v_exp_f32_e32 v155, v158
		v_exp_f32_e32 v156, v159
		v_exp_f32_e32 v158, v160
		v_exp_f32_e32 v157, v161
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
		v_exp_f32_e32 v185, v189
		v_exp_f32_e32 v187, v190
		v_exp_f32_e32 v188, v191
		v_exp_f32_e32 v190, v206
		v_exp_f32_e32 v189, v207
		v_exp_f32_e32 v191, v208
		v_exp_f32_e32 v206, v192
		v_exp_f32_e32 v208, v193
		v_exp_f32_e32 v207, v194
		v_exp_f32_e32 v209, v195
		v_exp_f32_e32 v192, v196
		v_exp_f32_e32 v194, v197
		v_exp_f32_e32 v193, v198
		v_exp_f32_e32 v195, v199
		v_exp_f32_e32 v196, v200
		v_exp_f32_e32 v198, v201
		v_exp_f32_e32 v197, v202
		v_exp_f32_e32 v199, v203
		v_exp_f32_e32 v200, v204
		v_exp_f32_e32 v202, v205
		v_pk_add_f32 v[204:205], v[210:211], v[212:213]
		v_pk_add_f32 v[216:217], v[50:51], v[52:53]
		v_pk_add_f32 v[218:219], v[54:55], v[56:57]
		v_pk_add_f32 v[220:221], v[58:59], v[62:63]
		v_pk_add_f32 v[222:223], v[96:97], v[100:101]
		v_pk_add_f32 v[224:225], v[102:103], v[104:105]
		v_pk_add_f32 v[226:227], v[106:107], v[108:109]
		v_pk_add_f32 v[228:229], v[110:111], v[112:113]
		v_pk_add_f32 v[230:231], v[114:115], v[214:215]
		v_pk_add_f32 v[232:233], v[48:49], v[98:99]
		v_pk_add_f32 v[234:235], v[116:117], v[118:119]
		v_pk_add_f32 v[236:237], v[120:121], v[122:123]
		v_pk_add_f32 v[238:239], v[124:125], v[126:127]
		v_pk_add_f32 v[240:241], v[128:129], v[130:131]
		v_accvgpr_write_b32 a38, v240
		v_accvgpr_write_b32 a39, v241
		v_pk_add_f32 v[240:241], v[132:133], v[134:135]
		v_accvgpr_write_b32 a44, v240
		v_accvgpr_write_b32 a45, v241
		v_pk_add_f32 v[240:241], v[136:137], v[138:139]
		v_accvgpr_write_b32 a46, v240
		v_accvgpr_write_b32 a47, v241
		v_mov_b32_e32 v240, v205
		v_mov_b32_e32 v241, v217
		v_mov_b32_e32 v242, v204
		v_mov_b32_e32 v243, v216
		v_pk_add_f32 v[204:205], v[242:243], v[240:241]
		v_mov_b32_e32 v216, v219
		v_mov_b32_e32 v217, v221
		v_mov_b32_e32 v240, v218
		v_mov_b32_e32 v241, v220
		v_pk_add_f32 v[218:219], v[240:241], v[216:217]
		v_mov_b32_e32 v216, v223
		v_mov_b32_e32 v217, v225
		v_mov_b32_e32 v220, v222
		v_mov_b32_e32 v221, v224
		v_pk_add_f32 v[222:223], v[220:221], v[216:217]
		v_mov_b32_e32 v216, v227
		v_mov_b32_e32 v217, v229
		v_mov_b32_e32 v220, v226
		v_mov_b32_e32 v221, v228
		v_pk_add_f32 v[224:225], v[220:221], v[216:217]
		v_mov_b32_e32 v216, v231
		v_mov_b32_e32 v217, v233
		v_mov_b32_e32 v220, v230
		v_mov_b32_e32 v221, v232
		v_pk_add_f32 v[226:227], v[220:221], v[216:217]
		v_mov_b32_e32 v216, v235
		v_mov_b32_e32 v217, v237
		v_mov_b32_e32 v220, v234
		v_mov_b32_e32 v221, v236
		v_pk_add_f32 v[228:229], v[220:221], v[216:217]
		v_mov_b32_e32 v216, v239
		v_accvgpr_read_b32 v60, a39
		v_mov_b32_e32 v217, v60
		v_mov_b32_e32 v220, v238
		v_accvgpr_read_b32 v60, a38
		v_mov_b32_e32 v221, v60
		v_pk_add_f32 v[230:231], v[220:221], v[216:217]
		v_accvgpr_read_b32 v60, a45
		v_mov_b32_e32 v216, v60
		v_accvgpr_read_b32 v60, a47
		v_mov_b32_e32 v217, v60
		v_accvgpr_read_b32 v60, a44
		v_mov_b32_e32 v220, v60
		v_accvgpr_read_b32 v60, a46
		v_mov_b32_e32 v221, v60
		v_pk_add_f32 v[232:233], v[220:221], v[216:217]
		v_mov_b32_e32 v216, v205
		v_mov_b32_e32 v217, v219
		v_mov_b32_e32 v220, v204
		v_mov_b32_e32 v221, v218
		v_pk_add_f32 v[204:205], v[220:221], v[216:217]
		v_mov_b32_e32 v216, v223
		v_mov_b32_e32 v217, v225
		v_mov_b32_e32 v218, v222
		v_mov_b32_e32 v219, v224
		v_pk_add_f32 v[220:221], v[218:219], v[216:217]
		v_mov_b32_e32 v216, v227
		v_mov_b32_e32 v217, v229
		v_mov_b32_e32 v218, v226
		v_mov_b32_e32 v219, v228
		v_pk_add_f32 v[222:223], v[218:219], v[216:217]
		v_mov_b32_e32 v216, v231
		v_mov_b32_e32 v217, v233
		v_mov_b32_e32 v218, v230
		v_mov_b32_e32 v219, v232
		v_pk_add_f32 v[224:225], v[218:219], v[216:217]
		v_mov_b32_e32 v216, v205
		v_mov_b32_e32 v217, v221
		v_mov_b32_e32 v218, v204
		v_mov_b32_e32 v219, v220
		v_pk_add_f32 v[204:205], v[218:219], v[216:217]
		v_mov_b32_e32 v216, v223
		v_mov_b32_e32 v217, v225
		v_mov_b32_e32 v218, v222
		v_mov_b32_e32 v219, v224
		v_pk_add_f32 v[220:221], v[218:219], v[216:217]
		v_mov_b32_e32 v216, v205
		v_mov_b32_e32 v217, v221
		v_mov_b32_e32 v218, v204
		v_mov_b32_e32 v219, v220
		v_pk_add_f32 v[204:205], v[218:219], v[216:217]
		v_add_f32_e32 v60, v204, v205
		ds_bpermute_b32 v140, v13, v60
		ds_bpermute_b32 v142, v15, v60
		v_pk_add_f32 v[204:205], v[144:145], v[146:147]
		v_pk_add_f32 v[216:217], v[148:149], v[150:151]
		v_pk_add_f32 v[218:219], v[152:153], v[154:155]
		v_pk_add_f32 v[220:221], v[156:157], v[158:159]
		v_pk_add_f32 v[222:223], v[160:161], v[162:163]
		v_pk_add_f32 v[224:225], v[164:165], v[166:167]
		v_pk_add_f32 v[226:227], v[168:169], v[170:171]
		v_pk_add_f32 v[228:229], v[172:173], v[174:175]
		v_pk_add_f32 v[230:231], v[176:177], v[178:179]
		v_pk_add_f32 v[232:233], v[180:181], v[182:183]
		v_pk_add_f32 v[234:235], v[184:185], v[186:187]
		v_pk_add_f32 v[236:237], v[188:189], v[190:191]
		v_accvgpr_write_b32 a38, v236
		v_accvgpr_write_b32 a39, v237
		v_pk_add_f32 v[236:237], v[206:207], v[208:209]
		v_pk_add_f32 v[238:239], v[192:193], v[194:195]
		v_accvgpr_write_b32 a44, v238
		v_accvgpr_write_b32 a45, v239
		v_pk_add_f32 v[238:239], v[196:197], v[198:199]
		v_mov_b32_e32 v240, v205
		v_mov_b32_e32 v241, v218
		v_pk_add_f32 v[242:243], v[240:241], v[216:217]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[216:217], v[140:141], v[142:143]
		v_mov_b32_e32 v201, v217
		v_mov_b32_e32 v203, v204
		v_pk_add_f32 v[204:205], v[200:201], v[202:203]
		v_mov_b32_e32 v240, v219
		v_mov_b32_e32 v241, v222
		v_pk_add_f32 v[218:219], v[240:241], v[220:221]
		v_mov_b32_e32 v220, v223
		v_mov_b32_e32 v221, v226
		v_pk_add_f32 v[222:223], v[220:221], v[224:225]
		v_mov_b32_e32 v220, v227
		v_mov_b32_e32 v221, v230
		v_pk_add_f32 v[220:221], v[220:221], v[228:229]
		v_mov_b32_e32 v224, v231
		v_mov_b32_e32 v225, v234
		v_pk_add_f32 v[226:227], v[224:225], v[232:233]
		v_mov_b32_e32 v224, v235
		v_mov_b32_e32 v225, v236
		v_accvgpr_read_b32 v228, a38
		v_accvgpr_read_b32 v229, a39
		v_pk_add_f32 v[224:225], v[224:225], v[228:229]
		v_mov_b32_e32 v228, v237
		v_mov_b32_e32 v229, v238
		v_accvgpr_read_b32 v230, a44
		v_accvgpr_read_b32 v231, a45
		v_pk_add_f32 v[232:233], v[228:229], v[230:231]
		v_mov_b32_e32 v228, v239
		v_mov_b32_e32 v229, v242
		v_pk_add_f32 v[204:205], v[228:229], v[204:205]
		v_mov_b32_e32 v228, v243
		v_mov_b32_e32 v229, v222
		v_pk_add_f32 v[230:231], v[228:229], v[218:219]
		v_mov_b32_e32 v218, v223
		v_mov_b32_e32 v219, v226
		v_pk_add_f32 v[218:219], v[218:219], v[220:221]
		v_mov_b32_e32 v220, v227
		v_mov_b32_e32 v221, v232
		v_pk_add_f32 v[222:223], v[220:221], v[224:225]
		v_mov_b32_e32 v220, v233
		v_mov_b32_e32 v221, v230
		v_pk_add_f32 v[204:205], v[220:221], v[204:205]
		v_mov_b32_e32 v220, v231
		v_mov_b32_e32 v221, v222
		v_pk_add_f32 v[224:225], v[220:221], v[218:219]
		v_mov_b32_e32 v218, v223
		v_mov_b32_e32 v219, v224
		v_pk_add_f32 v[220:221], v[218:219], v[204:205]
		v_add_f32_e32 v60, v225, v220
		v_add_f32_e32 v60, v221, v60
		ds_bpermute_b32 v140, v13, v60
		ds_bpermute_b32 v13, v15, v60
		v_sub_f32_e32 v7, v7, v12
		v_sub_f32_e32 v11, v11, v14
		v_exp_f32_e32 v204, v7
		v_exp_f32_e32 v218, v11
		v_mov_b32_e32 v205, v204
		v_pk_mul_f32 v[16:17], v[16:17], v[204:205]
		v_pk_mul_f32 v[18:19], v[18:19], v[204:205]
		v_pk_mul_f32 v[20:21], v[20:21], v[204:205]
		v_pk_mul_f32 v[22:23], v[22:23], v[204:205]
		v_pk_mul_f32 v[24:25], v[24:25], v[204:205]
		v_pk_mul_f32 v[26:27], v[26:27], v[204:205]
		v_pk_mul_f32 v[28:29], v[28:29], v[204:205]
		v_pk_mul_f32 v[30:31], v[30:31], v[204:205]
		v_pk_mul_f32 v[32:33], v[32:33], v[204:205]
		v_pk_mul_f32 v[34:35], v[34:35], v[204:205]
		v_pk_mul_f32 v[36:37], v[36:37], v[204:205]
		v_pk_mul_f32 v[38:39], v[38:39], v[204:205]
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v221, v140, v13
		v_pk_mul_f32 v[40:41], v[40:41], v[204:205]
		v_pk_mul_f32 v[42:43], v[42:43], v[204:205]
		v_pk_mul_f32 v[44:45], v[44:45], v[204:205]
		v_pk_mul_f32 v[46:47], v[46:47], v[204:205]
		v_mov_b32_e32 v219, v218
		v_pk_mul_f32 v[64:65], v[64:65], v[218:219]
		v_pk_mul_f32 v[66:67], v[66:67], v[218:219]
		v_pk_mul_f32 v[68:69], v[68:69], v[218:219]
		v_pk_mul_f32 v[70:71], v[70:71], v[218:219]
		v_pk_mul_f32 v[72:73], v[72:73], v[218:219]
		v_pk_mul_f32 v[74:75], v[74:75], v[218:219]
		v_pk_mul_f32 v[76:77], v[76:77], v[218:219]
		v_pk_mul_f32 v[78:79], v[78:79], v[218:219]
		v_pk_mul_f32 v[80:81], v[80:81], v[218:219]
		v_pk_mul_f32 v[82:83], v[82:83], v[218:219]
		v_pk_mul_f32 v[84:85], v[84:85], v[218:219]
		v_pk_mul_f32 v[86:87], v[86:87], v[218:219]
		v_pk_mul_f32 v[88:89], v[88:89], v[218:219]
		v_pk_mul_f32 v[90:91], v[90:91], v[218:219]
		v_pk_mul_f32 v[92:93], v[92:93], v[218:219]
		v_pk_mul_f32 v[94:95], v[94:95], v[218:219]
		v_mov_b32_e32 v220, v216
		v_mov_b32_e32 v216, v204
		v_mov_b32_e32 v217, v218
		v_accvgpr_read_b32 v7, a36
		v_mov_b32_e32 v204, v7
		v_accvgpr_read_b32 v7, a37
		v_mov_b32_e32 v205, v7
		v_pk_fma_f32 v[204:205], v[204:205], v[216:217], v[220:221]
		v_accvgpr_write_b32 a36, v204
		v_accvgpr_write_b32 a37, v205
		v_cvt_pk_bf16_f32 v216, v210, v212
		v_cvt_pk_bf16_f32 v217, v211, v213
		v_cvt_pk_bf16_f32 v218, v50, v52
		v_cvt_pk_bf16_f32 v219, v51, v53
		v_cvt_pk_bf16_f32 v220, v54, v56
		v_cvt_pk_bf16_f32 v221, v55, v57
		v_cvt_pk_bf16_f32 v222, v58, v62
		v_cvt_pk_bf16_f32 v223, v59, v63
		v_cvt_pk_bf16_f32 v52, v96, v100
		v_cvt_pk_bf16_f32 v53, v97, v101
		v_cvt_pk_bf16_f32 v54, v102, v104
		v_cvt_pk_bf16_f32 v55, v103, v105
		v_cvt_pk_bf16_f32 v56, v106, v108
		v_cvt_pk_bf16_f32 v57, v107, v109
		v_cvt_pk_bf16_f32 v58, v110, v112
		v_cvt_pk_bf16_f32 v59, v111, v113
		v_cvt_pk_bf16_f32 v100, v114, v214
		v_cvt_pk_bf16_f32 v101, v115, v215
		v_cvt_pk_bf16_f32 v102, v48, v98
		v_cvt_pk_bf16_f32 v103, v49, v99
		v_cvt_pk_bf16_f32 v48, v116, v118
		v_cvt_pk_bf16_f32 v49, v117, v119
		v_cvt_pk_bf16_f32 v50, v120, v122
		v_cvt_pk_bf16_f32 v51, v121, v123
		v_cvt_pk_bf16_f32 v96, v124, v126
		v_cvt_pk_bf16_f32 v97, v125, v127
		v_cvt_pk_bf16_f32 v98, v128, v130
		v_cvt_pk_bf16_f32 v99, v129, v131
		v_cvt_pk_bf16_f32 v104, v132, v134
		v_cvt_pk_bf16_f32 v105, v133, v135
		v_cvt_pk_bf16_f32 v106, v136, v138
		v_cvt_pk_bf16_f32 v107, v137, v139
		v_cvt_pk_bf16_f32 v108, v141, v143
		v_cvt_pk_bf16_f32 v109, v144, v146
		v_cvt_pk_bf16_f32 v110, v145, v147
		v_cvt_pk_bf16_f32 v111, v148, v150
		v_cvt_pk_bf16_f32 v112, v149, v151
		v_cvt_pk_bf16_f32 v113, v152, v154
		v_cvt_pk_bf16_f32 v114, v153, v155
		v_cvt_pk_bf16_f32 v115, v156, v158
		v_cvt_pk_bf16_f32 v116, v157, v159
		v_cvt_pk_bf16_f32 v117, v160, v162
		v_cvt_pk_bf16_f32 v118, v161, v163
		v_cvt_pk_bf16_f32 v119, v164, v166
		v_cvt_pk_bf16_f32 v120, v165, v167
		v_cvt_pk_bf16_f32 v121, v168, v170
		v_cvt_pk_bf16_f32 v122, v169, v171
		v_cvt_pk_bf16_f32 v123, v172, v174
		v_cvt_pk_bf16_f32 v124, v173, v175
		v_cvt_pk_bf16_f32 v125, v176, v178
		v_cvt_pk_bf16_f32 v126, v177, v179
		v_cvt_pk_bf16_f32 v127, v180, v182
		v_cvt_pk_bf16_f32 v128, v181, v183
		v_cvt_pk_bf16_f32 v129, v184, v186
		v_cvt_pk_bf16_f32 v130, v185, v187
		v_cvt_pk_bf16_f32 v131, v188, v190
		v_cvt_pk_bf16_f32 v132, v189, v191
		v_cvt_pk_bf16_f32 v133, v206, v208
		v_cvt_pk_bf16_f32 v134, v207, v209
		v_cvt_pk_bf16_f32 v135, v192, v194
		v_cvt_pk_bf16_f32 v136, v193, v195
		v_cvt_pk_bf16_f32 v137, v196, v198
		v_cvt_pk_bf16_f32 v138, v197, v199
		v_cvt_pk_bf16_f32 v139, v200, v202
		v_permlane32_swap_b32_e32 v216, v218
		v_permlane32_swap_b32_e32 v217, v219
		v_permlane32_swap_b32_e32 v220, v222
		v_permlane32_swap_b32_e32 v221, v223
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[16:31], a[76:79], v[216:219], v[16:31]
		v_permlane32_swap_b32_e32 v52, v54
		v_permlane32_swap_b32_e32 v53, v55
		v_permlane32_swap_b32_e32 v56, v58
		v_permlane32_swap_b32_e32 v57, v59
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_permlane32_swap_b32_e32 v48, v50
		v_permlane32_swap_b32_e32 v49, v51
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_mfma_f32_32x32x16_bf16 v[32:47], a[108:111], v[216:219], v[32:47]
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
		v_mfma_f32_32x32x16_bf16 v[80:95], a[108:111], v[108:111], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[76:79], v[108:111], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[80:83], v[220:223], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[112:115], v[220:223], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[112:115], v[112:115], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[80:83], v[112:115], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[84:87], v[52:55], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[116:119], v[52:55], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[116:119], v[116:119], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[84:87], v[116:119], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[88:91], v[56:59], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[120:123], v[56:59], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[120:123], v[120:123], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[88:91], v[120:123], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[92:95], v[100:103], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[124:127], v[100:103], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[124:127], v[124:127], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[92:95], v[124:127], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[96:99], v[48:51], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[128:131], v[48:51], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[128:131], v[128:131], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[96:99], v[128:131], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[100:103], v[96:99], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[132:135], v[96:99], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[132:135], v[132:135], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[100:103], v[132:135], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[104:107], v[104:107], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[136:139], v[104:107], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[136:139], v[136:139], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[104:107], v[136:139], v[64:79]
		s_mov_b32 s45, s50
		v_mov_b32_e32 v7, v12
		v_mov_b32_e32 v11, v14
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_3
.L_attn_fwd_persistent.loop_exit_3:
		s_cmp_lt_i32 s44, s41
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_4
.L_attn_fwd_persistent.loop_head_4:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s26, s44, 0x80
		s_cmp_lt_i32 s44, 0
		s_cselect_b32 s42, s27, 0
		s_add_i32 s42, s44, s42
		s_ashr_i32 s42, s42, 7
		s_cmp_lt_i32 s42, 0
		s_cselect_b32 s45, s16, 0
		s_add_i32 s45, s42, s45
		s_ashr_i32 s45, s45, 1
		s_lshl_b32 s45, s45, 1
		s_xor_b32 s45, s45, -1
		s_add_i32 s45, s45, 1
		s_add_i32 s45, s42, s45
		s_add_i32 s42, s42, 1
		s_cmp_lt_i32 s42, 0
		s_cselect_b32 s50, s16, 0
		s_add_i32 s50, s42, s50
		s_ashr_i32 s50, s50, 1
		s_lshl_b32 s50, s50, 1
		s_xor_b32 s50, s50, -1
		s_add_i32 s50, s50, 1
		s_add_i32 s52, s42, s50
		s_mul_i32 s42, 0x4100, s45
		v_and_b32_e32 v12, 63, v0
		v_lshrrev_b32_e32 v13, 5, v12
		v_and_b32_e32 v12, 31, v12
		v_lshrrev_b32_e32 v14, 4, v12
		v_lshlrev_b32_e32 v14, 9, v14
		v_lshl_add_u32 v13, v13, 4, v14
		v_lshrrev_b32_e32 v14, 3, v12
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 0x2080
		v_mul_lo_u32 v15, v15, v14
		v_lshrrev_b32_e32 v14, 2, v12
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v48, 0x1040
		v_mul_lo_u32 v48, v48, v14
		v_add3_u32 v13, v13, v15, v48
		v_lshrrev_b32_e32 v14, 1, v12
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 0x820
		v_mul_lo_u32 v15, v15, v14
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v14, 0x410
		v_mul_lo_u32 v14, v14, v12
		v_add3_u32 v12, v13, v15, v14
		v_add_u32_e32 v12, s42, v12
		ds_read_b128 v[48:51], v12
		ds_read_b128 a[44:47], v12 offset:32
		ds_read_b128 a[48:51], v12 offset:64
		ds_read_b128 a[52:55], v12 offset:96
		ds_read_b128 v[52:55], v12 offset:256
		ds_read_b128 a[56:59], v12 offset:288
		ds_read_b128 a[60:63], v12 offset:320
		ds_read_b128 a[64:67], v12 offset:352
		ds_read_b128 a[68:71], v12 offset:128
		ds_read_b128 a[72:75], v12 offset:160
		ds_read_b128 a[76:79], v12 offset:192
		ds_read_b128 a[80:83], v12 offset:224
		ds_read_b128 v[56:59], v12 offset:384
		ds_read_b128 a[84:87], v12 offset:416
		ds_read_b128 a[88:91], v12 offset:448
		ds_read_b128 a[92:95], v12 offset:480
		s_mul_i32 s42, 0x4400, s45
		v_and_b32_e32 v12, 63, v0
		v_and_b32_e32 v13, 15, v12
		v_and_b32_e32 v14, 3, v13
		v_lshrrev_b32_e32 v15, 5, v12
		v_mov_b32_e32 v60, 0x2200
		v_mul_lo_u32 v60, v60, v15
		v_and_b32_e32 v12, 31, v12
		v_lshrrev_b32_e32 v12, 4, v12
		v_lshlrev_b32_e32 v12, 5, v12
		v_lshrrev_b32_e32 v13, 2, v13
		v_mov_b32_e32 v15, 0x440
		v_mul_lo_u32 v15, v15, v13
		v_add3_u32 v12, v60, v12, v15
		v_lshl_add_u32 v12, v14, 3, v12
		v_add_u32_e32 v12, s42, v12
		ds_read_b64_tr_b16 a[96:97], v12 offset:33264
		ds_read_b64_tr_b16 a[98:99], v12 offset:37616
		ds_read_b64_tr_b16 a[100:101], v12 offset:33392
		ds_read_b64_tr_b16 a[102:103], v12 offset:37744
		ds_read_b64_tr_b16 a[104:105], v12 offset:33520
		ds_read_b64_tr_b16 a[106:107], v12 offset:37872
		ds_read_b64_tr_b16 a[108:109], v12 offset:33648
		ds_read_b64_tr_b16 a[110:111], v12 offset:38000
		ds_read_b64_tr_b16 a[112:113], v12 offset:33776
		ds_read_b64_tr_b16 a[114:115], v12 offset:38128
		ds_read_b64_tr_b16 a[116:117], v12 offset:33904
		ds_read_b64_tr_b16 a[118:119], v12 offset:38256
		ds_read_b64_tr_b16 a[120:121], v12 offset:34032
		ds_read_b64_tr_b16 a[122:123], v12 offset:38384
		ds_read_b64_tr_b16 a[124:125], v12 offset:34160
		ds_read_b64_tr_b16 a[126:127], v12 offset:38512
		ds_read_b64_tr_b16 a[128:129], v12 offset:33328
		ds_read_b64_tr_b16 a[130:131], v12 offset:37680
		ds_read_b64_tr_b16 a[132:133], v12 offset:33456
		ds_read_b64_tr_b16 a[134:135], v12 offset:37808
		ds_read_b64_tr_b16 a[136:137], v12 offset:33584
		ds_read_b64_tr_b16 a[138:139], v12 offset:37936
		ds_read_b64_tr_b16 a[140:141], v12 offset:33712
		ds_read_b64_tr_b16 a[142:143], v12 offset:38064
		ds_read_b64_tr_b16 a[144:145], v12 offset:33840
		ds_read_b64_tr_b16 a[146:147], v12 offset:38192
		ds_read_b64_tr_b16 a[148:149], v12 offset:33968
		ds_read_b64_tr_b16 a[150:151], v12 offset:38320
		ds_read_b64_tr_b16 a[152:153], v12 offset:34096
		ds_read_b64_tr_b16 a[154:155], v12 offset:38448
		ds_read_b64_tr_b16 a[156:157], v12 offset:34224
		ds_read_b64_tr_b16 a[158:159], v12 offset:38576
		s_cmp_lt_i32 s26, s21
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_2
		s_waitcnt vmcnt(0) lgkmcnt(14)
		s_barrier
		v_lshrrev_b32_e32 v12, 3, v0
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v13, 64
		v_mul_lo_u32 v13, v13, v12
		v_lshrrev_b32_e32 v12, 4, v0
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v14, 32
		v_mul_lo_u32 v14, v14, v12
		v_lshrrev_b32_e32 v12, 5, v0
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v15, 16
		v_mul_lo_u32 v15, v15, v12
		v_bitop3_b32 v12, v13, v14, v15 bitop3:0x96
		v_lshrrev_b32_e32 v13, 6, v0
		v_and_b32_e32 v13, 1, v13
		v_lshrrev_b32_e32 v14, 7, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 2
		v_mul_lo_u32 v15, v15, v14
		v_bitop3_b32 v12, v12, v13, v15 bitop3:0x96
		v_add_u32_e32 v12, s26, v12
		v_lshrrev_b32_e32 v13, 3, v0
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v14, 64
		v_mul_lo_u32 v14, v14, v13
		v_lshrrev_b32_e32 v13, 4, v0
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v15, 32
		v_mul_lo_u32 v15, v15, v13
		v_bitop3_b32 v13, 4, v14, v15 bitop3:0x96
		v_lshrrev_b32_e32 v14, 5, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 16
		v_mul_lo_u32 v15, v15, v14
		v_xor_b32_e32 v13, v13, v15
		v_lshrrev_b32_e32 v14, 6, v0
		v_and_b32_e32 v14, 1, v14
		v_lshrrev_b32_e32 v15, 7, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v60, 2
		v_mul_lo_u32 v60, v60, v15
		v_bitop3_b32 v13, v13, v14, v60 bitop3:0x96
		v_add_u32_e32 v13, s26, v13
		v_lshrrev_b32_e32 v14, 3, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 64
		v_mul_lo_u32 v15, v15, v14
		v_lshrrev_b32_e32 v14, 4, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v60, 32
		v_mul_lo_u32 v60, v60, v14
		v_bitop3_b32 v14, 8, v15, v60 bitop3:0x96
		v_lshrrev_b32_e32 v15, 5, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v60, 16
		v_mul_lo_u32 v60, v60, v15
		v_xor_b32_e32 v14, v14, v60
		v_lshrrev_b32_e32 v15, 6, v0
		v_and_b32_e32 v15, 1, v15
		v_lshrrev_b32_e32 v60, 7, v0
		v_and_b32_e32 v60, 1, v60
		v_mov_b32_e32 v62, 2
		v_mul_lo_u32 v62, v62, v60
		v_bitop3_b32 v14, v14, v15, v62 bitop3:0x96
		v_add_u32_e32 v14, s26, v14
		v_lshrrev_b32_e32 v15, 3, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v60, 64
		v_mul_lo_u32 v60, v60, v15
		v_lshrrev_b32_e32 v15, 4, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v62, 32
		v_mul_lo_u32 v62, v62, v15
		v_bitop3_b32 v15, 12, v60, v62 bitop3:0x96
		v_lshrrev_b32_e32 v60, 5, v0
		v_and_b32_e32 v60, 1, v60
		v_mov_b32_e32 v62, 16
		v_mul_lo_u32 v62, v62, v60
		v_xor_b32_e32 v15, v15, v62
		v_lshrrev_b32_e32 v60, 6, v0
		v_and_b32_e32 v60, 1, v60
		v_lshrrev_b32_e32 v62, 7, v0
		v_and_b32_e32 v62, 1, v62
		v_mov_b32_e32 v63, 2
		v_mul_lo_u32 v63, v63, v62
		v_bitop3_b32 v15, v15, v60, v63 bitop3:0x96
		v_add_u32_e32 v15, s26, v15
		v_cmp_lt_i32_e64 vcc, v12, s23
		s_mov_b64 s[50:51], vcc
		v_cmp_lt_i32_e64 vcc, v13, s23
		s_mov_b64 s[54:55], vcc
		v_cmp_lt_i32_e64 vcc, v14, s23
		s_mov_b64 s[58:59], vcc
		v_cmp_lt_i32_e64 vcc, v15, s23
		s_mov_b64 s[60:61], vcc
		v_lshrrev_b32_e32 v12, 3, v0
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v13, 16
		v_mul_lo_u32 v13, v13, v12
		v_lshrrev_b32_e32 v12, 4, v0
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v14, 32
		v_mul_lo_u32 v14, v14, v12
		v_lshrrev_b32_e32 v12, 5, v0
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v15, 64
		v_mul_lo_u32 v15, v15, v12
		v_bitop3_b32 v12, v13, v14, v15 bitop3:0x96
		v_lshrrev_b32_e32 v13, 6, v0
		v_and_b32_e32 v13, 1, v13
		v_lshrrev_b32_e32 v14, 7, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 2
		v_mul_lo_u32 v15, v15, v14
		v_bitop3_b32 v12, v12, v13, v15 bitop3:0x96
		v_add_u32_e32 v12, s26, v12
		v_lshrrev_b32_e32 v13, 3, v0
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v14, 16
		v_mul_lo_u32 v14, v14, v13
		v_lshrrev_b32_e32 v13, 4, v0
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v15, 32
		v_mul_lo_u32 v15, v15, v13
		v_bitop3_b32 v13, 4, v14, v15 bitop3:0x96
		v_lshrrev_b32_e32 v14, 5, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 64
		v_mul_lo_u32 v15, v15, v14
		v_xor_b32_e32 v13, v13, v15
		v_lshrrev_b32_e32 v14, 6, v0
		v_and_b32_e32 v14, 1, v14
		v_lshrrev_b32_e32 v15, 7, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v60, 2
		v_mul_lo_u32 v60, v60, v15
		v_bitop3_b32 v13, v13, v14, v60 bitop3:0x96
		v_add_u32_e32 v13, s26, v13
		v_lshrrev_b32_e32 v14, 3, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 16
		v_mul_lo_u32 v15, v15, v14
		v_lshrrev_b32_e32 v14, 4, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v60, 32
		v_mul_lo_u32 v60, v60, v14
		v_bitop3_b32 v14, 8, v15, v60 bitop3:0x96
		v_lshrrev_b32_e32 v15, 5, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v60, 64
		v_mul_lo_u32 v60, v60, v15
		v_xor_b32_e32 v14, v14, v60
		v_lshrrev_b32_e32 v15, 6, v0
		v_and_b32_e32 v15, 1, v15
		v_lshrrev_b32_e32 v60, 7, v0
		v_and_b32_e32 v60, 1, v60
		v_mov_b32_e32 v62, 2
		v_mul_lo_u32 v62, v62, v60
		v_bitop3_b32 v14, v14, v15, v62 bitop3:0x96
		v_add_u32_e32 v14, s26, v14
		v_cmp_lt_i32_e64 vcc, v12, s23
		s_mov_b64 s[62:63], vcc
		v_cmp_lt_i32_e64 vcc, v13, s23
		s_mov_b64 s[64:65], vcc
		v_cmp_lt_i32_e64 vcc, v14, s23
		s_mov_b64 s[66:67], vcc
		s_mul_i32 s42, s15, s44
		s_lshl_b32 s42, s42, 1
		s_lshl_b32 s45, s15, 8
		s_mul_i32 s53, s1, s13
		s_lshl_b32 s53, s53, 1
		s_add_i32 s45, s45, s53
		s_mul_i32 s53, s24, s14
		s_lshl_b32 s53, s53, 1
		s_add_i32 s45, s45, s53
		s_add_i32 s45, s45, s42
		v_lshrrev_b32_e32 v12, 4, v0
		v_and_b32_e32 v12, 1, v12
		v_mul_lo_u32 v12, s15, v12
		v_lshrrev_b32_e32 v13, 5, v0
		v_and_b32_e32 v13, 1, v13
		v_mul_lo_u32 v13, s15, v13
		v_lshrrev_b32_e32 v14, 7, v0
		v_mul_lo_u32 v14, s15, v14
		v_lshrrev_b32_e32 v15, 6, v0
		v_and_b32_e32 v15, 1, v15
		v_mul_lo_u32 v15, s15, v15
		v_lshlrev_b32_e32 v15, 1, v15
		v_lshl_add_u32 v14, v14, 2, v15
		v_lshl_add_u32 v13, v13, 5, v14
		v_lshl_add_u32 v12, v12, 6, v13
		v_lshrrev_b32_e32 v13, 3, v0
		v_and_b32_e32 v13, 1, v13
		v_mul_lo_u32 v13, s15, v13
		v_lshlrev_b32_e32 v13, 7, v13
		v_and_b32_e32 v14, 1, v0
		v_lshlrev_b32_e32 v14, 4, v14
		v_add3_u32 v12, v12, v13, v14
		v_lshrrev_b32_e32 v13, 2, v0
		v_and_b32_e32 v13, 1, v13
		v_lshlrev_b32_e32 v13, 6, v13
		v_lshrrev_b32_e32 v14, 1, v0
		v_and_b32_e32 v14, 1, v14
		v_lshlrev_b32_e32 v14, 5, v14
		v_add3_u32 v12, v12, v13, v14
		v_add_u32_e32 v13, s45, v12
		s_mov_b32 s68, 1
		s_mov_b32 s69, 0
		s_mov_b32 s71, 0
		s_mov_b32 s70, s56
		s_mul_i32 s72, s68, s70
		s_mul_hi_u32 s73, s68, s70
		s_mul_i32 s45, s68, s71
		s_add_i32 s73, s73, s45
		s_mul_i32 s45, s69, s70
		s_add_i32 s73, s73, s45
		s_lshr_b64 s[68:69], s[72:73], 6
		s_mov_b32 s70, 0x410
		s_mov_b32 s71, 0
		s_mul_i32 s72, s70, s68
		s_mul_hi_u32 s73, s70, s68
		s_mul_i32 s45, s70, s69
		s_add_i32 s73, s73, s45
		s_mul_i32 s45, s71, s68
		s_add_i32 s73, s73, s45
		s_cmp_lt_i32 s52, 0
		s_cselect_b32 s53, -1, 0
		s_mov_b32 s70, 0x4100
		s_mov_b32 s71, 0
		s_mul_i32 s74, s70, s52
		s_mul_hi_u32 s75, s70, s52
		s_mul_i32 s45, s70, s53
		s_add_i32 s75, s75, s45
		s_mul_i32 s45, s71, s52
		s_add_i32 s75, s75, s45
		s_add_u32 s70, s72, s74
		s_addc_u32 s71, s73, s75
		s_add_u32 s76, s70, 0
		s_addc_u32 s77, s71, 0
		s_mov_b32 m0, s76
		v_cndmask_b32_e64 v13, v10, v13, s[50:51]
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		v_lshrrev_b32_e32 v13, 3, v0
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v14, 16
		v_mul_lo_u32 v14, v14, v13
		v_lshrrev_b32_e32 v13, 4, v0
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v15, 32
		v_mul_lo_u32 v15, v15, v13
		v_bitop3_b32 v13, 12, v14, v15 bitop3:0x96
		v_lshrrev_b32_e32 v14, 5, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 64
		v_mul_lo_u32 v15, v15, v14
		v_xor_b32_e32 v13, v13, v15
		v_lshrrev_b32_e32 v14, 6, v0
		v_and_b32_e32 v14, 1, v14
		v_lshrrev_b32_e32 v15, 7, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v60, 2
		v_mul_lo_u32 v60, v60, v15
		v_bitop3_b32 v13, v13, v14, v60 bitop3:0x96
		v_add_u32_e32 v13, s26, v13
		s_mul_i32 s45, 0x108, s15
		s_mul_i32 s50, s1, s13
		s_lshl_b32 s50, s50, 1
		s_add_i32 s45, s45, s50
		s_mul_i32 s50, s24, s14
		s_lshl_b32 s50, s50, 1
		s_add_i32 s45, s45, s50
		s_add_i32 s45, s45, s42
		v_add_u32_e32 v14, s45, v12
		s_add_u32 s50, s72, 0x1040
		s_addc_u32 s51, s73, 0
		s_add_u32 s50, s50, s74
		s_addc_u32 s51, s51, s75
		s_add_u32 s70, s50, 0
		s_addc_u32 s71, s51, 0
		s_mov_b32 m0, s70
		v_cndmask_b32_e64 v14, v10, v14, s[54:55]
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		s_mul_i32 s45, 0x110, s15
		s_mul_i32 s50, s1, s13
		s_lshl_b32 s50, s50, 1
		s_add_i32 s45, s45, s50
		s_mul_i32 s50, s24, s14
		s_lshl_b32 s50, s50, 1
		s_add_i32 s45, s45, s50
		s_add_i32 s45, s45, s42
		v_add_u32_e32 v14, s45, v12
		s_add_u32 s50, s72, 0x2080
		s_addc_u32 s51, s73, 0
		s_add_u32 s50, s50, s74
		s_addc_u32 s51, s51, s75
		s_add_u32 s54, s50, 0
		s_addc_u32 s55, s51, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v14, v10, v14, s[58:59]
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		s_mul_i32 s45, 0x118, s15
		s_mul_i32 s50, s1, s13
		s_lshl_b32 s50, s50, 1
		s_add_i32 s45, s45, s50
		s_mul_i32 s50, s24, s14
		s_lshl_b32 s50, s50, 1
		s_add_i32 s45, s45, s50
		s_add_i32 s42, s45, s42
		v_add_u32_e32 v12, s42, v12
		s_add_u32 s50, s72, 0x30c0
		s_addc_u32 s51, s73, 0
		s_add_u32 s50, s50, s74
		s_addc_u32 s51, s51, s75
		s_add_u32 s54, s50, 0
		s_addc_u32 s55, s51, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v12, v10, v12, s[60:61]
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s42, s20, s44
		s_lshl_b32 s42, s42, 1
		s_lshl_b32 s45, s20, 8
		s_mul_i32 s50, s1, s18
		s_lshl_b32 s50, s50, 1
		s_add_i32 s45, s45, s50
		s_mul_i32 s50, s24, s19
		s_lshl_b32 s50, s50, 1
		s_add_i32 s45, s45, s50
		s_add_i32 s45, s45, s42
		v_lshrrev_b32_e32 v12, 4, v0
		v_and_b32_e32 v12, 1, v12
		v_mul_lo_u32 v12, s20, v12
		v_lshrrev_b32_e32 v14, 5, v0
		v_and_b32_e32 v14, 1, v14
		v_mul_lo_u32 v14, s20, v14
		v_lshrrev_b32_e32 v15, 7, v0
		v_mul_lo_u32 v15, s20, v15
		v_lshrrev_b32_e32 v60, 6, v0
		v_and_b32_e32 v60, 1, v60
		v_mul_lo_u32 v60, s20, v60
		v_lshlrev_b32_e32 v60, 1, v60
		v_lshl_add_u32 v15, v15, 2, v60
		v_lshl_add_u32 v14, v14, 7, v15
		v_lshl_add_u32 v12, v12, 6, v14
		v_lshrrev_b32_e32 v14, 3, v0
		v_and_b32_e32 v14, 1, v14
		v_mul_lo_u32 v14, s20, v14
		v_lshlrev_b32_e32 v14, 5, v14
		v_and_b32_e32 v15, 1, v0
		v_lshlrev_b32_e32 v15, 4, v15
		v_add3_u32 v12, v12, v14, v15
		v_lshrrev_b32_e32 v14, 2, v0
		v_and_b32_e32 v14, 1, v14
		v_lshlrev_b32_e32 v14, 6, v14
		v_lshrrev_b32_e32 v15, 1, v0
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 5, v15
		v_add3_u32 v12, v12, v14, v15
		v_add_u32_e32 v14, s45, v12
		s_mov_b32 s50, 0x440
		s_mov_b32 s51, 0
		s_mul_i32 s54, s50, s68
		s_mul_hi_u32 s55, s50, s68
		s_mul_i32 s45, s50, s69
		s_add_i32 s55, s55, s45
		s_mul_i32 s45, s51, s68
		s_add_i32 s55, s55, s45
		s_add_u32 s50, s54, 0x81f0
		s_addc_u32 s51, s55, 0
		s_mov_b32 s58, 0x4400
		s_mov_b32 s59, 0
		s_mul_i32 s60, s58, s52
		s_mul_hi_u32 s61, s58, s52
		s_mul_i32 s45, s58, s53
		s_add_i32 s61, s61, s45
		s_mul_i32 s45, s59, s52
		s_add_i32 s61, s61, s45
		s_add_u32 s50, s50, s60
		s_addc_u32 s51, s51, s61
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		v_cndmask_b32_e64 v14, v10, v14, s[62:63]
		buffer_load_dwordx4 v14, s[32:35], 0 offen lds
		s_mul_i32 s45, 0x108, s20
		s_mul_i32 s50, s1, s18
		s_lshl_b32 s50, s50, 1
		s_add_i32 s45, s45, s50
		s_mul_i32 s50, s24, s19
		s_lshl_b32 s50, s50, 1
		s_add_i32 s45, s45, s50
		s_add_i32 s45, s45, s42
		v_add_u32_e32 v14, s45, v12
		s_add_u32 s50, s54, 0x92f0
		s_addc_u32 s51, s55, 0
		s_add_u32 s50, s50, s60
		s_addc_u32 s51, s51, s61
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		v_cndmask_b32_e64 v14, v10, v14, s[64:65]
		buffer_load_dwordx4 v14, s[32:35], 0 offen lds
		s_mul_i32 s45, 0x110, s20
		s_mul_i32 s50, s1, s18
		s_lshl_b32 s50, s50, 1
		s_add_i32 s45, s45, s50
		s_mul_i32 s50, s24, s19
		s_lshl_b32 s50, s50, 1
		s_add_i32 s45, s45, s50
		s_add_i32 s45, s45, s42
		v_add_u32_e32 v14, s45, v12
		s_add_u32 s50, s54, 0xa3f0
		s_addc_u32 s51, s55, 0
		s_add_u32 s50, s50, s60
		s_addc_u32 s51, s51, s61
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		v_cndmask_b32_e64 v14, v10, v14, s[66:67]
		buffer_load_dwordx4 v14, s[32:35], 0 offen lds
		s_mul_i32 s45, 0x118, s20
		s_mul_i32 s50, s1, s18
		s_lshl_b32 s50, s50, 1
		s_add_i32 s45, s45, s50
		s_mul_i32 s50, s24, s19
		s_lshl_b32 s50, s50, 1
		s_add_i32 s45, s45, s50
		s_add_i32 s42, s45, s42
		v_cmp_lt_i32_e64 vcc, v13, s23
		v_add_u32_e32 v12, s42, v12
		s_add_u32 s50, s54, 0xb4f0
		s_addc_u32 s51, s55, 0
		v_cndmask_b32_e32 v12, v10, v12, vcc
		s_add_u32 s50, s50, s60
		s_addc_u32 s51, s51, s61
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		s_nop 0
		buffer_load_dwordx4 v12, s[32:35], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_2
.L_attn_fwd_persistent.if_else_2:
.L_attn_fwd_persistent.if_end_2:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[96:111], v[48:51], a[8:11], 0
		v_lshrrev_b32_e32 v12, 5, v0
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v13, 4
		v_mul_lo_u32 v13, v13, v12
		v_add_u32_e32 v12, s44, v13
		v_lshrrev_b32_e32 v13, 5, v0
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v14, 4
		v_mul_lo_u32 v14, v14, v13
		v_xor_b32_e32 v13, 1, v14
		v_add_u32_e32 v13, s44, v13
		v_lshrrev_b32_e32 v14, 5, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 4
		v_mul_lo_u32 v15, v15, v14
		v_xor_b32_e32 v14, 2, v15
		v_add_u32_e32 v14, s44, v14
		v_lshrrev_b32_e32 v15, 5, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v60, 4
		v_mul_lo_u32 v60, v60, v15
		v_xor_b32_e32 v15, 3, v60
		v_add_u32_e32 v15, s44, v15
		v_lshrrev_b32_e32 v60, 5, v0
		v_and_b32_e32 v60, 1, v60
		v_mov_b32_e32 v62, 4
		v_mul_lo_u32 v62, v62, v60
		v_xor_b32_e32 v60, 10, v62
		v_add_u32_e32 v60, s44, v60
		v_lshrrev_b32_e32 v62, 5, v0
		v_and_b32_e32 v62, 1, v62
		v_mov_b32_e32 v63, 4
		v_mul_lo_u32 v63, v63, v62
		v_xor_b32_e32 v62, 11, v63
		v_add_u32_e32 v62, s44, v62
		v_lshrrev_b32_e32 v63, 5, v0
		v_and_b32_e32 v63, 1, v63
		v_mov_b32_e32 v112, 4
		v_mul_lo_u32 v112, v112, v63
		v_xor_b32_e32 v63, 18, v112
		v_add_u32_e32 v63, s44, v63
		v_mfma_f32_32x32x16_bf16 v[112:127], v[52:55], a[8:11], 0
		v_lshrrev_b32_e32 v128, 5, v0
		v_and_b32_e32 v128, 1, v128
		v_mov_b32_e32 v129, 4
		v_mul_lo_u32 v129, v129, v128
		v_xor_b32_e32 v128, 19, v129
		v_add_u32_e32 v128, s44, v128
		v_lshrrev_b32_e32 v129, 5, v0
		v_and_b32_e32 v129, 1, v129
		v_mov_b32_e32 v130, 4
		v_mul_lo_u32 v130, v130, v129
		v_xor_b32_e32 v129, 26, v130
		v_add_u32_e32 v129, s44, v129
		v_lshrrev_b32_e32 v130, 5, v0
		v_and_b32_e32 v130, 1, v130
		v_mov_b32_e32 v131, 4
		v_mul_lo_u32 v131, v131, v130
		v_xor_b32_e32 v130, 27, v131
		v_add_u32_e32 v130, s44, v130
		v_lshrrev_b32_e32 v131, 5, v0
		v_and_b32_e32 v131, 1, v131
		v_mov_b32_e32 v132, 4
		v_mul_lo_u32 v132, v132, v131
		v_xor_b32_e32 v131, 34, v132
		v_add_u32_e32 v131, s44, v131
		v_lshrrev_b32_e32 v132, 5, v0
		v_and_b32_e32 v132, 1, v132
		v_mov_b32_e32 v133, 4
		v_mul_lo_u32 v133, v133, v132
		v_xor_b32_e32 v132, 35, v133
		v_add_u32_e32 v132, s44, v132
		v_lshrrev_b32_e32 v133, 5, v0
		v_and_b32_e32 v133, 1, v133
		v_mov_b32_e32 v134, 4
		v_mul_lo_u32 v134, v134, v133
		v_xor_b32_e32 v133, 42, v134
		v_add_u32_e32 v133, s44, v133
		v_lshrrev_b32_e32 v134, 5, v0
		v_and_b32_e32 v134, 1, v134
		v_mov_b32_e32 v135, 4
		v_mul_lo_u32 v135, v135, v134
		v_xor_b32_e32 v134, 43, v135
		v_add_u32_e32 v134, s44, v134
		v_mfma_f32_32x32x16_bf16 v[144:159], a[68:71], a[8:11], 0
		v_lshrrev_b32_e32 v135, 5, v0
		v_and_b32_e32 v135, 1, v135
		v_mov_b32_e32 v136, 4
		v_mul_lo_u32 v136, v136, v135
		v_xor_b32_e32 v135, 50, v136
		v_add_u32_e32 v135, s44, v135
		v_lshrrev_b32_e32 v136, 5, v0
		v_and_b32_e32 v136, 1, v136
		v_mov_b32_e32 v137, 4
		v_mul_lo_u32 v137, v137, v136
		v_xor_b32_e32 v136, 51, v137
		v_add_u32_e32 v136, s44, v136
		v_lshrrev_b32_e32 v137, 5, v0
		v_and_b32_e32 v137, 1, v137
		v_mov_b32_e32 v138, 4
		v_mul_lo_u32 v138, v138, v137
		v_xor_b32_e32 v137, 58, v138
		v_add_u32_e32 v137, s44, v137
		v_lshrrev_b32_e32 v138, 5, v0
		v_and_b32_e32 v138, 1, v138
		v_mov_b32_e32 v139, 4
		v_mul_lo_u32 v139, v139, v138
		v_xor_b32_e32 v138, 59, v139
		v_add_u32_e32 v138, s44, v138
		v_lshrrev_b32_e32 v139, 5, v0
		v_and_b32_e32 v139, 1, v139
		v_mov_b32_e32 v140, 4
		v_mul_lo_u32 v140, v140, v139
		v_xor_b32_e32 v139, 0x42, v140
		v_add_u32_e32 v139, s44, v139
		v_lshrrev_b32_e32 v140, 5, v0
		v_and_b32_e32 v140, 1, v140
		v_mov_b32_e32 v141, 4
		v_mul_lo_u32 v141, v141, v140
		v_xor_b32_e32 v140, 0x43, v141
		v_add_u32_e32 v140, s44, v140
		v_lshrrev_b32_e32 v141, 5, v0
		v_and_b32_e32 v141, 1, v141
		v_mov_b32_e32 v142, 4
		v_mul_lo_u32 v142, v142, v141
		v_xor_b32_e32 v141, 0x4a, v142
		v_add_u32_e32 v141, s44, v141
		v_mfma_f32_32x32x16_bf16 v[160:175], v[56:59], a[8:11], 0
		v_lshrrev_b32_e32 v142, 5, v0
		v_and_b32_e32 v142, 1, v142
		v_mov_b32_e32 v143, 4
		v_mul_lo_u32 v143, v143, v142
		v_xor_b32_e32 v142, 0x4b, v143
		v_add_u32_e32 v142, s44, v142
		v_lshrrev_b32_e32 v143, 5, v0
		v_and_b32_e32 v143, 1, v143
		v_mov_b32_e32 v176, 4
		v_mul_lo_u32 v176, v176, v143
		v_xor_b32_e32 v143, 0x52, v176
		v_add_u32_e32 v143, s44, v143
		v_lshrrev_b32_e32 v176, 5, v0
		v_and_b32_e32 v176, 1, v176
		v_mov_b32_e32 v177, 4
		v_mul_lo_u32 v177, v177, v176
		v_xor_b32_e32 v176, 0x53, v177
		v_add_u32_e32 v176, s44, v176
		v_lshrrev_b32_e32 v177, 5, v0
		v_and_b32_e32 v177, 1, v177
		v_mov_b32_e32 v178, 4
		v_mul_lo_u32 v178, v178, v177
		v_xor_b32_e32 v177, 0x5a, v178
		v_add_u32_e32 v177, s44, v177
		v_lshrrev_b32_e32 v178, 5, v0
		v_and_b32_e32 v178, 1, v178
		v_mov_b32_e32 v179, 4
		v_mul_lo_u32 v179, v179, v178
		v_xor_b32_e32 v178, 0x5b, v179
		v_add_u32_e32 v178, s44, v178
		v_lshrrev_b32_e32 v179, 5, v0
		v_and_b32_e32 v179, 1, v179
		v_mov_b32_e32 v180, 4
		v_mul_lo_u32 v180, v180, v179
		v_xor_b32_e32 v179, 0x62, v180
		v_add_u32_e32 v179, s44, v179
		v_lshrrev_b32_e32 v180, 5, v0
		v_and_b32_e32 v180, 1, v180
		v_mov_b32_e32 v181, 4
		v_mul_lo_u32 v181, v181, v180
		v_xor_b32_e32 v180, 0x63, v181
		v_add_u32_e32 v180, s44, v180
		v_mfma_f32_32x32x16_bf16 v[192:207], v[56:59], a[24:27], 0
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
		v_lshrrev_b32_e32 v56, 5, v0
		v_and_b32_e32 v56, 1, v56
		v_mov_b32_e32 v57, 4
		v_mul_lo_u32 v57, v57, v56
		v_xor_b32_e32 v56, 0x6a, v57
		v_add_u32_e32 v56, s44, v56
		v_lshrrev_b32_e32 v57, 5, v0
		v_and_b32_e32 v57, 1, v57
		v_mov_b32_e32 v58, 4
		v_mul_lo_u32 v58, v58, v57
		v_xor_b32_e32 v57, 0x6b, v58
		v_add_u32_e32 v57, s44, v57
		v_lshrrev_b32_e32 v58, 5, v0
		v_and_b32_e32 v58, 1, v58
		v_mov_b32_e32 v59, 4
		v_mul_lo_u32 v59, v59, v58
		v_xor_b32_e32 v58, 0x72, v59
		v_add_u32_e32 v58, s44, v58
		v_lshrrev_b32_e32 v59, 5, v0
		v_and_b32_e32 v59, 1, v59
		v_mov_b32_e32 v181, 4
		v_mul_lo_u32 v181, v181, v59
		v_xor_b32_e32 v59, 0x73, v181
		v_add_u32_e32 v59, s44, v59
		v_lshrrev_b32_e32 v181, 5, v0
		v_and_b32_e32 v181, 1, v181
		v_mov_b32_e32 v182, 4
		v_mul_lo_u32 v182, v182, v181
		v_xor_b32_e32 v181, 0x7a, v182
		v_add_u32_e32 v181, s44, v181
		v_lshrrev_b32_e32 v182, 5, v0
		v_and_b32_e32 v182, 1, v182
		v_mov_b32_e32 v183, 4
		v_mul_lo_u32 v183, v183, v182
		v_xor_b32_e32 v182, 0x7b, v183
		v_add_u32_e32 v182, s44, v182
		v_cmp_ge_i32_e64 vcc, v6, v12
		s_mov_b64 s[50:51], vcc
		v_mfma_f32_32x32x16_bf16 v[192:207], v[48:51], a[24:27], 0
		v_cmp_ge_i32_e64 vcc, v6, v13
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v6, v14
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v6, v15
		v_lshrrev_b32_e32 v48, 5, v0
		v_and_b32_e32 v48, 1, v48
		v_mov_b32_e32 v49, 4
		v_mul_lo_u32 v49, v49, v48
		v_xor_b32_e32 v48, 8, v49
		v_add_u32_e32 v48, s44, v48
		v_lshrrev_b32_e32 v49, 5, v0
		v_and_b32_e32 v49, 1, v49
		v_mov_b32_e32 v50, 4
		v_mul_lo_u32 v50, v50, v49
		v_xor_b32_e32 v49, 9, v50
		v_add_u32_e32 v49, s44, v49
		v_lshrrev_b32_e32 v50, 5, v0
		v_and_b32_e32 v50, 1, v50
		v_mov_b32_e32 v51, 4
		v_mul_lo_u32 v51, v51, v50
		v_xor_b32_e32 v50, 16, v51
		v_add_u32_e32 v50, s44, v50
		v_lshrrev_b32_e32 v51, 5, v0
		v_and_b32_e32 v51, 1, v51
		v_mov_b32_e32 v183, 4
		v_mul_lo_u32 v183, v183, v51
		v_xor_b32_e32 v51, 17, v183
		v_add_u32_e32 v51, s44, v51
		v_mfma_f32_32x32x16_bf16 v[208:223], v[52:55], a[24:27], 0
		v_lshrrev_b32_e32 v52, 5, v0
		v_and_b32_e32 v52, 1, v52
		v_mov_b32_e32 v53, 4
		v_mul_lo_u32 v53, v53, v52
		v_xor_b32_e32 v52, 24, v53
		v_add_u32_e32 v52, s44, v52
		v_lshrrev_b32_e32 v53, 5, v0
		v_and_b32_e32 v53, 1, v53
		v_mov_b32_e32 v54, 4
		v_mul_lo_u32 v54, v54, v53
		v_xor_b32_e32 v53, 25, v54
		v_add_u32_e32 v53, s44, v53
		v_lshrrev_b32_e32 v54, 5, v0
		v_and_b32_e32 v54, 1, v54
		v_mov_b32_e32 v55, 4
		v_mul_lo_u32 v55, v55, v54
		v_xor_b32_e32 v54, 32, v55
		v_add_u32_e32 v54, s44, v54
		v_lshrrev_b32_e32 v55, 5, v0
		v_and_b32_e32 v55, 1, v55
		v_mov_b32_e32 v183, 4
		v_mul_lo_u32 v183, v183, v55
		v_xor_b32_e32 v55, 33, v183
		v_add_u32_e32 v55, s44, v55
		v_lshrrev_b32_e32 v183, 5, v0
		v_and_b32_e32 v183, 1, v183
		v_mov_b32_e32 v184, 4
		v_mul_lo_u32 v184, v184, v183
		v_xor_b32_e32 v183, 40, v184
		v_add_u32_e32 v183, s44, v183
		v_lshrrev_b32_e32 v184, 5, v0
		v_and_b32_e32 v184, 1, v184
		v_mov_b32_e32 v185, 4
		v_mul_lo_u32 v185, v185, v184
		v_xor_b32_e32 v184, 41, v185
		v_add_u32_e32 v184, s44, v184
		v_lshrrev_b32_e32 v185, 5, v0
		v_and_b32_e32 v185, 1, v185
		v_mov_b32_e32 v186, 4
		v_mul_lo_u32 v186, v186, v185
		v_xor_b32_e32 v185, 48, v186
		v_add_u32_e32 v185, s44, v185
		v_mfma_f32_32x32x16_bf16 v[224:239], a[68:71], a[24:27], 0
		v_lshrrev_b32_e32 v186, 5, v0
		v_and_b32_e32 v186, 1, v186
		v_mov_b32_e32 v187, 4
		v_mul_lo_u32 v187, v187, v186
		v_xor_b32_e32 v186, 49, v187
		v_add_u32_e32 v186, s44, v186
		v_lshrrev_b32_e32 v187, 5, v0
		v_and_b32_e32 v187, 1, v187
		v_mov_b32_e32 v188, 4
		v_mul_lo_u32 v188, v188, v187
		v_xor_b32_e32 v187, 56, v188
		v_add_u32_e32 v187, s44, v187
		v_lshrrev_b32_e32 v188, 5, v0
		v_and_b32_e32 v188, 1, v188
		v_mov_b32_e32 v189, 4
		v_mul_lo_u32 v189, v189, v188
		v_xor_b32_e32 v188, 57, v189
		v_add_u32_e32 v188, s44, v188
		v_lshrrev_b32_e32 v189, 5, v0
		v_and_b32_e32 v189, 1, v189
		v_mov_b32_e32 v190, 4
		v_mul_lo_u32 v190, v190, v189
		v_xor_b32_e32 v189, 64, v190
		v_add_u32_e32 v189, s44, v189
		v_lshrrev_b32_e32 v190, 5, v0
		v_and_b32_e32 v190, 1, v190
		v_mov_b32_e32 v191, 4
		v_mul_lo_u32 v191, v191, v190
		v_xor_b32_e32 v190, 0x41, v191
		v_add_u32_e32 v190, s44, v190
		v_lshrrev_b32_e32 v191, 5, v0
		v_and_b32_e32 v191, 1, v191
		v_mov_b32_e32 v240, 4
		v_mul_lo_u32 v240, v240, v191
		v_xor_b32_e32 v191, 0x48, v240
		v_add_u32_e32 v191, s44, v191
		v_lshrrev_b32_e32 v240, 5, v0
		v_and_b32_e32 v240, 1, v240
		v_mov_b32_e32 v241, 4
		v_mul_lo_u32 v241, v241, v240
		v_xor_b32_e32 v240, 0x49, v241
		v_add_u32_e32 v240, s44, v240
		v_mfma_f32_32x32x16_bf16 v[96:111], a[44:47], a[12:15], v[96:111]
		v_lshrrev_b32_e32 v241, 5, v0
		v_and_b32_e32 v241, 1, v241
		v_mov_b32_e32 v242, 4
		v_mul_lo_u32 v242, v242, v241
		v_xor_b32_e32 v241, 0x50, v242
		v_add_u32_e32 v241, s44, v241
		v_lshrrev_b32_e32 v242, 5, v0
		v_and_b32_e32 v242, 1, v242
		v_mov_b32_e32 v243, 4
		v_mul_lo_u32 v243, v243, v242
		v_xor_b32_e32 v242, 0x51, v243
		v_add_u32_e32 v242, s44, v242
		v_lshrrev_b32_e32 v243, 5, v0
		v_and_b32_e32 v243, 1, v243
		v_mov_b32_e32 v244, 4
		v_mul_lo_u32 v244, v244, v243
		v_xor_b32_e32 v243, 0x58, v244
		v_add_u32_e32 v243, s44, v243
		v_lshrrev_b32_e32 v244, 5, v0
		v_and_b32_e32 v244, 1, v244
		v_mov_b32_e32 v245, 4
		v_mul_lo_u32 v245, v245, v244
		v_xor_b32_e32 v244, 0x59, v245
		v_add_u32_e32 v244, s44, v244
		v_lshrrev_b32_e32 v245, 5, v0
		v_and_b32_e32 v245, 1, v245
		v_mov_b32_e32 v246, 4
		v_mul_lo_u32 v246, v246, v245
		v_xor_b32_e32 v245, 0x60, v246
		v_add_u32_e32 v245, s44, v245
		v_lshrrev_b32_e32 v246, 5, v0
		v_and_b32_e32 v246, 1, v246
		v_mov_b32_e32 v247, 4
		v_mul_lo_u32 v247, v247, v246
		v_xor_b32_e32 v246, 0x61, v247
		v_add_u32_e32 v246, s44, v246
		v_lshrrev_b32_e32 v247, 5, v0
		v_and_b32_e32 v247, 1, v247
		v_mov_b32_e32 v248, 4
		v_mul_lo_u32 v248, v248, v247
		v_xor_b32_e32 v247, 0x68, v248
		v_add_u32_e32 v247, s44, v247
		v_mfma_f32_32x32x16_bf16 v[112:127], a[56:59], a[12:15], v[112:127]
		v_lshrrev_b32_e32 v248, 5, v0
		v_and_b32_e32 v248, 1, v248
		v_mov_b32_e32 v249, 4
		v_mul_lo_u32 v249, v249, v248
		v_xor_b32_e32 v248, 0x69, v249
		v_add_u32_e32 v248, s44, v248
		v_lshrrev_b32_e32 v249, 5, v0
		v_and_b32_e32 v249, 1, v249
		v_mov_b32_e32 v250, 4
		v_mul_lo_u32 v250, v250, v249
		v_xor_b32_e32 v249, 0x70, v250
		v_add_u32_e32 v249, s44, v249
		v_lshrrev_b32_e32 v250, 5, v0
		v_and_b32_e32 v250, 1, v250
		v_mov_b32_e32 v251, 4
		v_mul_lo_u32 v251, v251, v250
		v_xor_b32_e32 v250, 0x71, v251
		v_add_u32_e32 v250, s44, v250
		v_lshrrev_b32_e32 v251, 5, v0
		v_and_b32_e32 v251, 1, v251
		v_mov_b32_e32 v252, 4
		v_mul_lo_u32 v252, v252, v251
		v_xor_b32_e32 v251, 0x78, v252
		v_add_u32_e32 v251, s44, v251
		v_lshrrev_b32_e32 v252, 5, v0
		v_and_b32_e32 v252, 1, v252
		v_mov_b32_e32 v253, 4
		v_mul_lo_u32 v253, v253, v252
		v_xor_b32_e32 v252, 0x79, v253
		v_add_u32_e32 v252, s44, v252
		v_mfma_f32_32x32x16_bf16 v[144:159], a[72:75], a[12:15], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[84:87], a[12:15], v[160:175]
		v_mfma_f32_32x32x16_bf16 a[160:175], a[84:87], a[28:31], a[160:175]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[44:47], a[28:31], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[56:59], a[28:31], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[72:75], a[28:31], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[48:51], a[16:19], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[60:63], a[16:19], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[76:79], a[16:19], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[88:91], a[16:19], v[160:175]
		v_mfma_f32_32x32x16_bf16 a[160:175], a[88:91], a[32:35], a[160:175]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[48:51], a[32:35], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[60:63], a[32:35], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[76:79], a[32:35], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[52:55], a[20:23], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[64:67], a[20:23], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[80:83], a[20:23], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[92:95], a[20:23], v[160:175]
		v_mfma_f32_32x32x16_bf16 a[160:175], a[92:95], a[40:43], a[160:175]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[52:55], a[40:43], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[64:67], a[40:43], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[80:83], a[40:43], v[224:239]
		s_cmp_lt_i32 s26, s41
		v_mov_b32_e32 v253, 0xff800000
		s_nop 2
		v_cndmask_b32_e32 v99, v253, v99, vcc
		v_accvgpr_write_b32 a39, v99
		v_cmp_ge_i32_e64 vcc, v6, v48
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v6, v49
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v6, v60
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v6, v62
		v_cndmask_b32_e64 v96, v253, v96, s[50:51]
		v_accvgpr_write_b32 a44, v96
		v_cndmask_b32_e64 v96, v253, v97, s[52:53]
		v_accvgpr_write_b32 a45, v96
		v_cndmask_b32_e32 v97, v253, v103, vcc
		v_cmp_ge_i32_e64 vcc, v6, v50
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v6, v51
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v6, v63
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v6, v128
		v_cndmask_b32_e64 v96, v253, v98, s[54:55]
		v_accvgpr_write_b32 a38, v96
		v_cndmask_b32_e64 v98, v253, v100, s[44:45]
		v_cndmask_b32_e32 v96, v253, v107, vcc
		v_accvgpr_write_b32 a47, v96
		v_cmp_ge_i32_e64 vcc, v6, v52
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v6, v53
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v6, v129
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v6, v130
		v_cndmask_b32_e64 v99, v253, v101, s[58:59]
		v_cndmask_b32_e64 v96, v253, v102, s[60:61]
		v_cndmask_b32_e32 v101, v253, v111, vcc
		v_cmp_ge_i32_e64 vcc, v6, v54
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v6, v55
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v6, v131
		s_mov_b64 s[66:67], vcc
		v_cmp_ge_i32_e64 vcc, v6, v132
		v_cndmask_b32_e64 v102, v253, v104, s[50:51]
		v_cndmask_b32_e64 v103, v253, v105, s[52:53]
		v_cndmask_b32_e32 v100, v253, v115, vcc
		v_accvgpr_write_b32 a49, v100
		v_cmp_ge_i32_e64 vcc, v6, v183
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v6, v184
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v6, v133
		s_mov_b64 s[68:69], vcc
		v_cmp_ge_i32_e64 vcc, v6, v134
		v_cndmask_b32_e64 v100, v253, v106, s[62:63]
		v_accvgpr_write_b32 a46, v100
		v_cndmask_b32_e64 v104, v253, v108, s[44:45]
		v_cndmask_b32_e32 v100, v253, v119, vcc
		v_accvgpr_write_b32 a51, v100
		v_cmp_ge_i32_e64 vcc, v6, v185
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v6, v186
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v6, v135
		s_mov_b64 s[70:71], vcc
		v_cmp_ge_i32_e64 vcc, v6, v136
		v_cndmask_b32_e64 v105, v253, v109, s[54:55]
		v_cndmask_b32_e64 v100, v253, v110, s[64:65]
		v_cndmask_b32_e32 v107, v253, v123, vcc
		v_cmp_ge_i32_e64 vcc, v6, v187
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v6, v188
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v6, v137
		s_mov_b64 s[72:73], vcc
		v_cmp_ge_i32_e64 vcc, v6, v138
		v_cndmask_b32_e64 v108, v253, v112, s[58:59]
		v_cndmask_b32_e64 v109, v253, v113, s[60:61]
		v_cndmask_b32_e32 v111, v253, v127, vcc
		v_cmp_ge_i32_e64 vcc, v6, v189
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v6, v190
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v6, v139
		s_mov_b64 s[74:75], vcc
		v_cmp_ge_i32_e64 vcc, v6, v140
		v_cndmask_b32_e64 v106, v253, v114, s[66:67]
		v_accvgpr_write_b32 a48, v106
		v_cndmask_b32_e64 v112, v253, v116, s[50:51]
		v_cndmask_b32_e32 v115, v253, v147, vcc
		v_cmp_ge_i32_e64 vcc, v6, v191
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v6, v240
		s_mov_b64 s[66:67], vcc
		v_cmp_ge_i32_e64 vcc, v6, v141
		s_mov_b64 s[76:77], vcc
		v_cmp_ge_i32_e64 vcc, v6, v142
		v_cndmask_b32_e64 v113, v253, v117, s[52:53]
		v_cndmask_b32_e64 v106, v253, v118, s[68:69]
		v_accvgpr_write_b32 a50, v106
		v_cndmask_b32_e32 v117, v253, v151, vcc
		v_cmp_ge_i32_e64 vcc, v6, v241
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v6, v242
		s_mov_b64 s[68:69], vcc
		v_cmp_ge_i32_e64 vcc, v6, v143
		s_mov_b64 s[78:79], vcc
		v_cmp_ge_i32_e64 vcc, v6, v176
		v_cndmask_b32_e64 v106, v253, v120, s[44:45]
		v_accvgpr_write_b32 a52, v106
		v_cndmask_b32_e64 v106, v253, v121, s[62:63]
		v_accvgpr_write_b32 a53, v106
		v_cndmask_b32_e32 v119, v253, v155, vcc
		v_cmp_ge_i32_e64 vcc, v6, v243
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v6, v244
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v6, v177
		s_mov_b64 s[80:81], vcc
		v_cndmask_b32_e64 v121, v253, v157, s[62:63]
		v_cndmask_b32_e64 v254, v253, v158, s[80:81]
		v_cmp_ge_i32_e64 vcc, v6, v178
		v_cndmask_b32_e64 v106, v253, v122, s[70:71]
		v_cndmask_b32_e64 v122, v253, v124, s[54:55]
		v_cndmask_b32_e32 v255, v253, v159, vcc
		v_cmp_ge_i32_e64 vcc, v6, v245
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v6, v246
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v6, v179
		s_mov_b64 s[70:71], vcc
		v_cndmask_b32_e64 v158, v253, v160, s[54:55]
		v_cndmask_b32_e64 v159, v253, v161, s[62:63]
		v_cndmask_b32_e64 v160, v253, v162, s[70:71]
		v_cmp_ge_i32_e64 vcc, v6, v180
		v_cndmask_b32_e64 v123, v253, v125, s[64:65]
		v_cndmask_b32_e64 v110, v253, v126, s[72:73]
		v_cndmask_b32_e32 v161, v253, v163, vcc
		v_cmp_ge_i32_e64 vcc, v6, v247
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v6, v248
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v6, v56
		s_mov_b64 s[64:65], vcc
		v_cndmask_b32_e64 v124, v253, v164, s[54:55]
		v_cndmask_b32_e64 v125, v253, v165, s[62:63]
		v_cndmask_b32_e64 v126, v253, v166, s[64:65]
		v_cmp_ge_i32_e64 vcc, v6, v57
		v_cndmask_b32_e64 v162, v253, v144, s[58:59]
		v_cndmask_b32_e64 v163, v253, v145, s[60:61]
		v_cndmask_b32_e32 v127, v253, v167, vcc
		v_cmp_ge_i32_e64 vcc, v6, v249
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v6, v250
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v6, v58
		s_mov_b64 s[60:61], vcc
		v_cndmask_b32_e64 v144, v253, v168, s[54:55]
		v_cndmask_b32_e64 v145, v253, v169, s[58:59]
		v_cndmask_b32_e64 v164, v253, v170, s[60:61]
		v_cmp_ge_i32_e64 vcc, v6, v59
		v_cndmask_b32_e64 v114, v253, v146, s[74:75]
		v_cndmask_b32_e64 v146, v253, v148, s[50:51]
		v_cndmask_b32_e32 v165, v253, v171, vcc
		v_cmp_ge_i32_e64 vcc, v6, v251
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v6, v252
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v6, v181
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v166, v253, v172, s[50:51]
		v_cndmask_b32_e64 v167, v253, v173, s[54:55]
		v_cndmask_b32_e64 v168, v253, v174, s[58:59]
		v_cmp_ge_i32_e64 vcc, v6, v182
		v_cndmask_b32_e64 v147, v253, v149, s[66:67]
		v_cndmask_b32_e64 v116, v253, v150, s[76:77]
		v_cndmask_b32_e32 v169, v253, v175, vcc
		v_cmp_ge_i32_e64 vcc, v5, v12
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v5, v13
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v5, v14
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v12, v253, v192, s[50:51]
		v_cndmask_b32_e64 v13, v253, v193, s[54:55]
		v_cndmask_b32_e64 v148, v253, v194, s[58:59]
		v_cmp_ge_i32_e64 vcc, v5, v15
		v_cndmask_b32_e64 v14, v253, v152, s[52:53]
		v_cndmask_b32_e64 v15, v253, v153, s[68:69]
		v_cndmask_b32_e32 v149, v253, v195, vcc
		v_cmp_ge_i32_e64 vcc, v5, v48
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v5, v49
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v5, v60
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v48, v253, v196, s[50:51]
		v_cndmask_b32_e64 v49, v253, v197, s[52:53]
		v_cndmask_b32_e64 v150, v253, v198, s[54:55]
		v_cmp_ge_i32_e64 vcc, v5, v62
		v_cndmask_b32_e64 v118, v253, v154, s[78:79]
		v_cndmask_b32_e64 v120, v253, v156, s[44:45]
		v_cndmask_b32_e32 v151, v253, v199, vcc
		v_cmp_ge_i32_e64 vcc, v5, v50
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v5, v51
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v5, v63
		s_mov_b64 s[52:53], vcc
		v_cndmask_b32_e64 v50, v253, v200, s[44:45]
		v_cndmask_b32_e64 v51, v253, v201, s[50:51]
		v_cndmask_b32_e64 v62, v253, v202, s[52:53]
		v_cmp_ge_i32_e64 vcc, v5, v128
		v_accvgpr_read_b32 v60, a44
		v_accvgpr_read_b32 v63, a45
		v_max_f32_e32 v60, v60, v63
		v_accvgpr_read_b32 v63, a39
		v_accvgpr_read_b32 v128, a38
		v_max_f32_e32 v128, v128, v63
		v_cndmask_b32_e32 v63, v253, v203, vcc
		v_cmp_ge_i32_e64 vcc, v5, v52
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v5, v53
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v5, v129
		s_mov_b64 s[52:53], vcc
		v_cndmask_b32_e64 v52, v253, v204, s[44:45]
		v_cndmask_b32_e64 v53, v253, v205, s[50:51]
		v_cndmask_b32_e64 v152, v253, v206, s[52:53]
		v_cmp_ge_i32_e64 vcc, v5, v130
		v_max_f32_e32 v129, v98, v99
		v_max_f32_e32 v130, v96, v97
		v_cndmask_b32_e32 v153, v253, v207, vcc
		v_cmp_ge_i32_e64 vcc, v5, v54
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v5, v55
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v5, v131
		s_mov_b64 s[52:53], vcc
		v_cndmask_b32_e64 v54, v253, v208, s[44:45]
		v_cndmask_b32_e64 v55, v253, v209, s[50:51]
		v_cndmask_b32_e64 v154, v253, v210, s[52:53]
		v_cmp_ge_i32_e64 vcc, v5, v132
		v_max_f32_e32 v131, v102, v103
		v_accvgpr_read_b32 v132, a47
		v_accvgpr_read_b32 v155, a46
		v_max_f32_e32 v132, v155, v132
		v_cndmask_b32_e32 v155, v253, v211, vcc
		v_cmp_ge_i32_e64 vcc, v5, v183
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v5, v184
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v5, v133
		s_mov_b64 s[52:53], vcc
		v_cndmask_b32_e64 v156, v253, v212, s[44:45]
		v_cndmask_b32_e64 v157, v253, v213, s[50:51]
		v_cndmask_b32_e64 v170, v253, v214, s[52:53]
		v_cmp_ge_i32_e64 vcc, v5, v134
		v_max_f32_e32 v133, v104, v105
		v_max_f32_e32 v134, v100, v101
		v_cndmask_b32_e32 v171, v253, v215, vcc
		v_cmp_ge_i32_e64 vcc, v5, v185
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v5, v186
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v5, v135
		s_mov_b64 s[52:53], vcc
		v_cndmask_b32_e64 v172, v253, v216, s[44:45]
		v_cndmask_b32_e64 v173, v253, v217, s[50:51]
		v_cndmask_b32_e64 v174, v253, v218, s[52:53]
		v_cmp_ge_i32_e64 vcc, v5, v136
		v_max_f32_e32 v135, v108, v109
		v_accvgpr_read_b32 v136, a49
		v_accvgpr_read_b32 v175, a48
		v_max_f32_e32 v136, v175, v136
		v_cndmask_b32_e32 v175, v253, v219, vcc
		v_cmp_ge_i32_e64 vcc, v5, v187
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v5, v188
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v5, v137
		s_mov_b64 s[52:53], vcc
		v_cndmask_b32_e64 v184, v253, v220, s[44:45]
		v_cndmask_b32_e64 v185, v253, v221, s[50:51]
		v_cndmask_b32_e64 v186, v253, v222, s[52:53]
		v_cmp_ge_i32_e64 vcc, v5, v138
		v_max_f32_e32 v137, v112, v113
		v_accvgpr_read_b32 v138, a51
		v_accvgpr_read_b32 v183, a50
		v_max_f32_e32 v138, v183, v138
		v_cndmask_b32_e32 v187, v253, v223, vcc
		v_cmp_ge_i32_e64 vcc, v5, v189
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v5, v190
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v5, v139
		s_mov_b64 s[52:53], vcc
		v_cndmask_b32_e64 v188, v253, v224, s[44:45]
		v_cndmask_b32_e64 v189, v253, v225, s[50:51]
		v_cndmask_b32_e64 v192, v253, v226, s[52:53]
		v_cmp_ge_i32_e64 vcc, v5, v140
		v_accvgpr_read_b32 v139, a52
		v_accvgpr_read_b32 v140, a53
		v_max_f32_e32 v139, v139, v140
		v_max_f32_e32 v140, v106, v107
		v_cndmask_b32_e32 v193, v253, v227, vcc
		v_cmp_ge_i32_e64 vcc, v5, v191
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v5, v240
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v5, v141
		s_mov_b64 s[52:53], vcc
		v_cndmask_b32_e64 v190, v253, v228, s[44:45]
		v_cndmask_b32_e64 v191, v253, v229, s[50:51]
		v_cndmask_b32_e64 v194, v253, v230, s[52:53]
		v_cmp_ge_i32_e64 vcc, v5, v142
		v_max_f32_e32 v141, v122, v123
		v_max_f32_e32 v142, v110, v111
		v_cndmask_b32_e32 v195, v253, v231, vcc
		v_cmp_ge_i32_e64 vcc, v5, v241
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v5, v242
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v5, v143
		s_mov_b64 s[52:53], vcc
		v_cndmask_b32_e64 v196, v253, v232, s[44:45]
		v_cndmask_b32_e64 v197, v253, v233, s[50:51]
		v_cndmask_b32_e64 v198, v253, v234, s[52:53]
		v_cmp_ge_i32_e64 vcc, v5, v176
		v_max_f32_e32 v143, v162, v163
		v_max_f32_e32 v176, v114, v115
		v_cndmask_b32_e32 v199, v253, v235, vcc
		v_cmp_ge_i32_e64 vcc, v5, v243
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v5, v244
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v5, v177
		s_mov_b64 s[52:53], vcc
		v_cndmask_b32_e64 v200, v253, v236, s[44:45]
		v_cndmask_b32_e64 v201, v253, v237, s[50:51]
		v_cndmask_b32_e64 v202, v253, v238, s[52:53]
		v_cmp_ge_i32_e64 vcc, v5, v178
		v_max_f32_e32 v177, v146, v147
		v_max_f32_e32 v178, v116, v117
		v_cndmask_b32_e32 v203, v253, v239, vcc
		v_cmp_ge_i32_e64 vcc, v5, v245
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v5, v246
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v5, v179
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v179, a160
		v_cndmask_b32_e64 v204, v253, v179, s[44:45]
		v_accvgpr_read_b32 v179, a161
		v_cndmask_b32_e64 v205, v253, v179, s[50:51]
		v_accvgpr_read_b32 v179, a162
		v_cndmask_b32_e64 v206, v253, v179, s[52:53]
		v_cmp_ge_i32_e64 vcc, v5, v180
		v_max_f32_e32 v179, v14, v15
		v_max_f32_e32 v180, v118, v119
		v_accvgpr_read_b32 v183, a163
		v_cndmask_b32_e32 v207, v253, v183, vcc
		v_cmp_ge_i32_e64 vcc, v5, v247
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v5, v248
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v5, v56
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v56, a164
		v_cndmask_b32_e64 v208, v253, v56, s[44:45]
		v_accvgpr_read_b32 v56, a165
		v_cndmask_b32_e64 v209, v253, v56, s[50:51]
		v_accvgpr_read_b32 v56, a166
		v_cndmask_b32_e64 v210, v253, v56, s[52:53]
		v_cmp_ge_i32_e64 vcc, v5, v57
		v_max_f32_e32 v56, v120, v121
		v_max_f32_e32 v57, v254, v255
		v_accvgpr_read_b32 v183, a167
		v_cndmask_b32_e32 v211, v253, v183, vcc
		v_cmp_ge_i32_e64 vcc, v5, v249
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v5, v250
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v5, v58
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v58, a168
		v_cndmask_b32_e64 v212, v253, v58, s[44:45]
		v_accvgpr_read_b32 v58, a169
		v_cndmask_b32_e64 v213, v253, v58, s[50:51]
		v_accvgpr_read_b32 v58, a170
		v_cndmask_b32_e64 v214, v253, v58, s[52:53]
		v_cmp_ge_i32_e64 vcc, v5, v59
		v_max_f32_e32 v58, v158, v159
		v_max_f32_e32 v59, v160, v161
		v_accvgpr_read_b32 v183, a171
		v_cndmask_b32_e32 v215, v253, v183, vcc
		v_cmp_ge_i32_e64 vcc, v5, v251
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v5, v252
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v5, v181
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v181, a172
		v_cndmask_b32_e64 v216, v253, v181, s[44:45]
		v_accvgpr_read_b32 v181, a173
		v_cndmask_b32_e64 v217, v253, v181, s[50:51]
		v_accvgpr_read_b32 v181, a174
		v_cndmask_b32_e64 v218, v253, v181, s[52:53]
		v_cmp_ge_i32_e64 vcc, v5, v182
		v_max_f32_e32 v181, v124, v125
		v_max_f32_e32 v182, v126, v127
		v_accvgpr_read_b32 v183, a175
		v_cndmask_b32_e32 v219, v253, v183, vcc
		v_max_f32_e32 v183, v144, v145
		v_max_f32_e32 v220, v164, v165
		v_max_f32_e32 v221, v166, v167
		v_max_f32_e32 v222, v168, v169
		v_max_f32_e32 v60, v60, v128
		v_max_f32_e32 v128, v129, v130
		v_max_f32_e32 v129, v131, v132
		v_max_f32_e32 v130, v133, v134
		v_max_f32_e32 v131, v135, v136
		v_max_f32_e32 v132, v137, v138
		v_max_f32_e32 v133, v139, v140
		v_max_f32_e32 v134, v141, v142
		v_max_f32_e32 v135, v143, v176
		v_max_f32_e32 v136, v177, v178
		v_max_f32_e32 v137, v179, v180
		v_max_f32_e32 v56, v56, v57
		v_max_f32_e32 v57, v58, v59
		v_max_f32_e32 v58, v181, v182
		v_max_f32_e32 v59, v183, v220
		v_max_f32_e32 v138, v221, v222
		v_max_f32_e32 v60, v60, v128
		v_max_f32_e32 v128, v129, v130
		v_max_f32_e32 v129, v131, v132
		v_max_f32_e32 v130, v133, v134
		v_max_f32_e32 v131, v135, v136
		v_max_f32_e32 v56, v137, v56
		v_max_f32_e32 v57, v57, v58
		v_max_f32_e32 v58, v59, v138
		v_max_f32_e32 v59, v60, v128
		v_max_f32_e32 v60, v129, v130
		v_max_f32_e32 v56, v131, v56
		v_max_f32_e32 v57, v57, v58
		v_max_f32_e32 v58, v59, v60
		v_max_f32_e32 v56, v56, v57
		v_max_f32_e32 v56, v58, v56
		v_and_b32_e32 v57, 1, v8
		v_lshrrev_b32_e32 v58, 4, v8
		v_and_b32_e32 v58, 1, v58
		v_lshlrev_b32_e32 v58, 4, v58
		v_lshrrev_b32_e32 v59, 3, v8
		v_and_b32_e32 v59, 1, v59
		v_lshlrev_b32_e32 v59, 3, v59
		v_add3_u32 v57, v57, v58, v59
		v_lshrrev_b32_e32 v58, 2, v8
		v_and_b32_e32 v58, 1, v58
		v_lshlrev_b32_e32 v58, 2, v58
		v_lshrrev_b32_e32 v59, 1, v8
		v_and_b32_e32 v59, 1, v59
		v_lshlrev_b32_e32 v59, 1, v59
		v_add3_u32 v57, v57, v58, v59
		v_lshlrev_b32_e32 v57, 2, v57
		ds_bpermute_b32 v58, v57, v56
		v_lshrrev_b32_e32 v59, 4, v8
		v_and_b32_e32 v59, 1, v59
		v_lshlrev_b32_e32 v59, 4, v59
		v_lshrrev_b32_e32 v60, 3, v8
		v_and_b32_e32 v60, 1, v60
		v_lshlrev_b32_e32 v60, 3, v60
		v_lshrrev_b32_e32 v128, 2, v8
		v_and_b32_e32 v128, 1, v128
		v_lshlrev_b32_e32 v128, 2, v128
		v_and_b32_e32 v129, 1, v8
		v_add_u32_e32 v129, 32, v129
		v_lshrrev_b32_e32 v130, 1, v8
		v_and_b32_e32 v130, 1, v130
		v_lshlrev_b32_e32 v130, 1, v130
		v_bitop3_b32 v128, v128, v129, v130 bitop3:0x96
		v_bitop3_b32 v59, v59, v60, v128 bitop3:0x96
		v_lshlrev_b32_e32 v59, 2, v59
		ds_bpermute_b32 v60, v59, v56
		v_max_f32_e32 v56, v12, v13
		v_max_f32_e32 v128, v148, v149
		v_max_f32_e32 v129, v48, v49
		v_max_f32_e32 v130, v150, v151
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v132, v58, v60
		v_max_f32_e32 v58, v50, v51
		v_max_f32_e32 v60, v62, v63
		v_max_f32_e32 v131, v52, v53
		v_max_f32_e32 v133, v152, v153
		v_max_f32_e32 v134, v54, v55
		v_max_f32_e32 v135, v154, v155
		v_max_f32_e32 v136, v156, v157
		v_max_f32_e32 v137, v170, v171
		v_max_f32_e32 v138, v172, v173
		v_max_f32_e32 v139, v174, v175
		v_max_f32_e32 v140, v184, v185
		v_max_f32_e32 v141, v186, v187
		v_max_f32_e32 v142, v188, v189
		v_max_f32_e32 v143, v192, v193
		v_max_f32_e32 v176, v190, v191
		v_max_f32_e32 v177, v194, v195
		v_max_f32_e32 v178, v196, v197
		v_max_f32_e32 v179, v198, v199
		v_max_f32_e32 v180, v200, v201
		v_max_f32_e32 v181, v202, v203
		v_max_f32_e32 v182, v204, v205
		v_max_f32_e32 v183, v206, v207
		v_max_f32_e32 v220, v208, v209
		v_max_f32_e32 v221, v210, v211
		v_max_f32_e32 v222, v212, v213
		v_max_f32_e32 v223, v214, v215
		v_max_f32_e32 v224, v216, v217
		v_max_f32_e32 v225, v218, v219
		v_max_f32_e32 v56, v56, v128
		v_max_f32_e32 v128, v129, v130
		v_max_f32_e32 v58, v58, v60
		v_max_f32_e32 v60, v131, v133
		v_max_f32_e32 v129, v134, v135
		v_max_f32_e32 v130, v136, v137
		v_max_f32_e32 v131, v138, v139
		v_max_f32_e32 v133, v140, v141
		v_max_f32_e32 v134, v142, v143
		v_max_f32_e32 v135, v176, v177
		v_max_f32_e32 v136, v178, v179
		v_max_f32_e32 v137, v180, v181
		v_max_f32_e32 v138, v182, v183
		v_max_f32_e32 v139, v220, v221
		v_max_f32_e32 v140, v222, v223
		v_max_f32_e32 v141, v224, v225
		v_max_f32_e32 v56, v56, v128
		v_max_f32_e32 v58, v58, v60
		v_max_f32_e32 v60, v129, v130
		v_max_f32_e32 v128, v131, v133
		v_max_f32_e32 v129, v134, v135
		v_max_f32_e32 v130, v136, v137
		v_max_f32_e32 v131, v138, v139
		v_max_f32_e32 v133, v140, v141
		v_max_f32_e32 v56, v56, v58
		v_max_f32_e32 v58, v60, v128
		v_max_f32_e32 v60, v129, v130
		v_max_f32_e32 v128, v131, v133
		v_max_f32_e32 v56, v56, v58
		v_max_f32_e32 v58, v60, v128
		v_max_f32_e32 v56, v56, v58
		ds_bpermute_b32 v58, v57, v56
		ds_bpermute_b32 v60, v59, v56
		v_mov_b32_e32 v128, 0x3e38aa3b
		v_mov_b32_e32 v129, 0x3e38aa3b
		v_accvgpr_read_b32 v130, a44
		v_accvgpr_read_b32 v131, a45
		v_pk_mul_f32 v[134:135], v[130:131], v[128:129]
		v_accvgpr_read_b32 v130, a38
		v_accvgpr_read_b32 v131, a39
		v_pk_mul_f32 v[136:137], v[130:131], v[128:129]
		v_pk_mul_f32 v[130:131], v[98:99], v[128:129]
		v_pk_mul_f32 v[98:99], v[96:97], v[128:129]
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v133, v58, v60
		v_pk_mul_f32 v[96:97], v[132:133], v[128:129]
		v_max_f32_e32 v56, v7, v96
		v_max_f32_e32 v58, v11, v97
		v_pk_mul_f32 v[96:97], v[102:103], v[128:129]
		v_accvgpr_read_b32 v102, a46
		v_accvgpr_read_b32 v103, a47
		v_pk_mul_f32 v[132:133], v[102:103], v[128:129]
		v_pk_mul_f32 v[102:103], v[104:105], v[128:129]
		v_pk_mul_f32 v[104:105], v[100:101], v[128:129]
		v_pk_mul_f32 v[100:101], v[108:109], v[128:129]
		v_accvgpr_read_b32 v108, a48
		v_accvgpr_read_b32 v109, a49
		v_pk_mul_f32 v[138:139], v[108:109], v[128:129]
		v_pk_mul_f32 v[108:109], v[112:113], v[128:129]
		v_accvgpr_read_b32 v112, a50
		v_accvgpr_read_b32 v113, a51
		v_pk_mul_f32 v[140:141], v[112:113], v[128:129]
		v_accvgpr_read_b32 v112, a52
		v_accvgpr_read_b32 v113, a53
		v_pk_mul_f32 v[142:143], v[112:113], v[128:129]
		v_pk_mul_f32 v[112:113], v[106:107], v[128:129]
		v_pk_mul_f32 v[106:107], v[122:123], v[128:129]
		v_pk_mul_f32 v[122:123], v[110:111], v[128:129]
		v_pk_mul_f32 v[110:111], v[162:163], v[128:129]
		v_pk_mul_f32 v[162:163], v[114:115], v[128:129]
		v_pk_mul_f32 v[114:115], v[146:147], v[128:129]
		v_pk_mul_f32 v[146:147], v[116:117], v[128:129]
		v_pk_mul_f32 v[116:117], v[14:15], v[128:129]
		v_pk_mul_f32 v[14:15], v[118:119], v[128:129]
		v_pk_mul_f32 v[118:119], v[120:121], v[128:129]
		v_pk_mul_f32 v[120:121], v[254:255], v[128:129]
		v_pk_mul_f32 v[176:177], v[158:159], v[128:129]
		v_pk_mul_f32 v[158:159], v[160:161], v[128:129]
		v_pk_mul_f32 v[160:161], v[124:125], v[128:129]
		v_pk_mul_f32 v[124:125], v[126:127], v[128:129]
		v_pk_mul_f32 v[126:127], v[144:145], v[128:129]
		v_pk_mul_f32 v[144:145], v[164:165], v[128:129]
		v_pk_mul_f32 v[164:165], v[166:167], v[128:129]
		v_pk_mul_f32 v[166:167], v[168:169], v[128:129]
		v_pk_mul_f32 v[168:169], v[12:13], v[128:129]
		v_pk_mul_f32 v[12:13], v[148:149], v[128:129]
		v_pk_mul_f32 v[148:149], v[48:49], v[128:129]
		v_pk_mul_f32 v[48:49], v[150:151], v[128:129]
		v_pk_mul_f32 v[150:151], v[50:51], v[128:129]
		v_pk_mul_f32 v[50:51], v[62:63], v[128:129]
		v_pk_mul_f32 v[62:63], v[52:53], v[128:129]
		v_pk_mul_f32 v[52:53], v[152:153], v[128:129]
		v_pk_mul_f32 v[152:153], v[54:55], v[128:129]
		v_pk_mul_f32 v[54:55], v[154:155], v[128:129]
		v_pk_mul_f32 v[154:155], v[156:157], v[128:129]
		v_pk_mul_f32 v[156:157], v[170:171], v[128:129]
		v_pk_mul_f32 v[170:171], v[172:173], v[128:129]
		v_pk_mul_f32 v[172:173], v[174:175], v[128:129]
		v_pk_mul_f32 v[174:175], v[184:185], v[128:129]
		v_pk_mul_f32 v[178:179], v[186:187], v[128:129]
		v_pk_mul_f32 v[180:181], v[188:189], v[128:129]
		v_pk_mul_f32 v[182:183], v[192:193], v[128:129]
		v_pk_mul_f32 v[184:185], v[190:191], v[128:129]
		v_pk_mul_f32 v[186:187], v[194:195], v[128:129]
		v_pk_mul_f32 v[188:189], v[196:197], v[128:129]
		v_pk_mul_f32 v[190:191], v[198:199], v[128:129]
		v_pk_mul_f32 v[192:193], v[200:201], v[128:129]
		v_pk_mul_f32 v[194:195], v[202:203], v[128:129]
		v_pk_mul_f32 v[196:197], v[204:205], v[128:129]
		v_pk_mul_f32 v[198:199], v[206:207], v[128:129]
		v_pk_mul_f32 v[200:201], v[208:209], v[128:129]
		v_pk_mul_f32 v[202:203], v[210:211], v[128:129]
		v_pk_mul_f32 v[204:205], v[212:213], v[128:129]
		v_pk_mul_f32 v[206:207], v[214:215], v[128:129]
		v_pk_mul_f32 v[208:209], v[216:217], v[128:129]
		v_pk_mul_f32 v[210:211], v[218:219], v[128:129]
		v_sub_f32_e32 v60, v134, v56
		v_sub_f32_e32 v128, v135, v56
		v_sub_f32_e32 v129, v136, v56
		v_sub_f32_e32 v134, v137, v56
		v_sub_f32_e32 v130, v130, v56
		v_sub_f32_e32 v131, v131, v56
		v_sub_f32_e32 v98, v98, v56
		v_sub_f32_e32 v99, v99, v56
		v_sub_f32_e32 v96, v96, v56
		v_sub_f32_e32 v97, v97, v56
		v_sub_f32_e32 v132, v132, v56
		v_sub_f32_e32 v133, v133, v56
		v_sub_f32_e32 v102, v102, v56
		v_sub_f32_e32 v103, v103, v56
		v_sub_f32_e32 v104, v104, v56
		v_sub_f32_e32 v105, v105, v56
		v_sub_f32_e32 v100, v100, v56
		v_sub_f32_e32 v101, v101, v56
		v_sub_f32_e32 v135, v138, v56
		v_sub_f32_e32 v136, v139, v56
		v_sub_f32_e32 v108, v108, v56
		v_sub_f32_e32 v109, v109, v56
		v_sub_f32_e32 v137, v140, v56
		v_sub_f32_e32 v138, v141, v56
		v_sub_f32_e32 v139, v142, v56
		v_sub_f32_e32 v140, v143, v56
		v_sub_f32_e32 v112, v112, v56
		v_sub_f32_e32 v113, v113, v56
		v_sub_f32_e32 v106, v106, v56
		v_sub_f32_e32 v107, v107, v56
		v_sub_f32_e32 v122, v122, v56
		v_sub_f32_e32 v123, v123, v56
		v_sub_f32_e32 v110, v110, v56
		v_sub_f32_e32 v111, v111, v56
		v_sub_f32_e32 v141, v162, v56
		v_sub_f32_e32 v142, v163, v56
		v_sub_f32_e32 v114, v114, v56
		v_sub_f32_e32 v115, v115, v56
		v_sub_f32_e32 v143, v146, v56
		v_sub_f32_e32 v146, v147, v56
		v_sub_f32_e32 v116, v116, v56
		v_sub_f32_e32 v117, v117, v56
		v_sub_f32_e32 v14, v14, v56
		v_sub_f32_e32 v15, v15, v56
		v_sub_f32_e32 v118, v118, v56
		v_sub_f32_e32 v119, v119, v56
		v_sub_f32_e32 v120, v120, v56
		v_sub_f32_e32 v121, v121, v56
		v_sub_f32_e32 v147, v176, v56
		v_sub_f32_e32 v162, v177, v56
		v_sub_f32_e32 v158, v158, v56
		v_sub_f32_e32 v159, v159, v56
		v_sub_f32_e32 v160, v160, v56
		v_sub_f32_e32 v161, v161, v56
		v_sub_f32_e32 v124, v124, v56
		v_sub_f32_e32 v125, v125, v56
		v_sub_f32_e32 v126, v126, v56
		v_sub_f32_e32 v127, v127, v56
		v_sub_f32_e32 v144, v144, v56
		v_sub_f32_e32 v145, v145, v56
		v_sub_f32_e32 v163, v164, v56
		v_sub_f32_e32 v164, v165, v56
		v_sub_f32_e32 v165, v166, v56
		v_sub_f32_e32 v166, v167, v56
		v_sub_f32_e32 v167, v168, v58
		v_sub_f32_e32 v168, v169, v58
		v_sub_f32_e32 v12, v12, v58
		v_sub_f32_e32 v13, v13, v58
		v_sub_f32_e32 v148, v148, v58
		v_sub_f32_e32 v149, v149, v58
		v_sub_f32_e32 v48, v48, v58
		v_sub_f32_e32 v49, v49, v58
		v_sub_f32_e32 v150, v150, v58
		v_sub_f32_e32 v151, v151, v58
		v_sub_f32_e32 v50, v50, v58
		v_sub_f32_e32 v51, v51, v58
		v_sub_f32_e32 v62, v62, v58
		v_sub_f32_e32 v63, v63, v58
		v_sub_f32_e32 v52, v52, v58
		v_sub_f32_e32 v53, v53, v58
		v_sub_f32_e32 v152, v152, v58
		v_sub_f32_e32 v153, v153, v58
		v_sub_f32_e32 v54, v54, v58
		v_sub_f32_e32 v55, v55, v58
		v_sub_f32_e32 v154, v154, v58
		v_sub_f32_e32 v155, v155, v58
		v_sub_f32_e32 v156, v156, v58
		v_sub_f32_e32 v157, v157, v58
		v_sub_f32_e32 v169, v170, v58
		v_sub_f32_e32 v170, v171, v58
		v_sub_f32_e32 v171, v172, v58
		v_sub_f32_e32 v172, v173, v58
		v_sub_f32_e32 v173, v174, v58
		v_sub_f32_e32 v174, v175, v58
		v_sub_f32_e32 v175, v178, v58
		v_sub_f32_e32 v176, v179, v58
		v_sub_f32_e32 v177, v180, v58
		v_sub_f32_e32 v178, v181, v58
		v_sub_f32_e32 v179, v182, v58
		v_sub_f32_e32 v180, v183, v58
		v_sub_f32_e32 v181, v184, v58
		v_sub_f32_e32 v182, v185, v58
		v_sub_f32_e32 v183, v186, v58
		v_sub_f32_e32 v184, v187, v58
		v_sub_f32_e32 v185, v188, v58
		v_sub_f32_e32 v186, v189, v58
		v_sub_f32_e32 v187, v190, v58
		v_sub_f32_e32 v188, v191, v58
		v_sub_f32_e32 v189, v192, v58
		v_sub_f32_e32 v190, v193, v58
		v_sub_f32_e32 v191, v194, v58
		v_sub_f32_e32 v192, v195, v58
		v_sub_f32_e32 v193, v196, v58
		v_sub_f32_e32 v194, v197, v58
		v_sub_f32_e32 v195, v198, v58
		v_sub_f32_e32 v196, v199, v58
		v_sub_f32_e32 v197, v200, v58
		v_sub_f32_e32 v198, v201, v58
		v_sub_f32_e32 v199, v202, v58
		v_sub_f32_e32 v200, v203, v58
		v_sub_f32_e32 v201, v204, v58
		v_sub_f32_e32 v202, v205, v58
		v_sub_f32_e32 v203, v206, v58
		v_sub_f32_e32 v204, v207, v58
		v_sub_f32_e32 v205, v208, v58
		v_sub_f32_e32 v206, v209, v58
		v_sub_f32_e32 v207, v210, v58
		v_sub_f32_e32 v208, v211, v58
		v_exp_f32_e32 v210, v60
		v_exp_f32_e32 v212, v128
		v_exp_f32_e32 v211, v129
		v_exp_f32_e32 v213, v134
		v_exp_f32_e32 v128, v130
		v_exp_f32_e32 v214, v131
		v_exp_f32_e32 v129, v98
		v_exp_f32_e32 v215, v99
		v_exp_f32_e32 v98, v96
		v_exp_f32_e32 v130, v97
		v_exp_f32_e32 v99, v132
		v_exp_f32_e32 v131, v133
		v_exp_f32_e32 v96, v102
		v_exp_f32_e32 v132, v103
		v_exp_f32_e32 v97, v104
		v_exp_f32_e32 v133, v105
		v_exp_f32_e32 v102, v100
		v_exp_f32_e32 v104, v101
		v_exp_f32_e32 v103, v135
		v_exp_f32_e32 v105, v136
		v_exp_f32_e32 v100, v108
		v_exp_f32_e32 v134, v109
		v_exp_f32_e32 v101, v137
		v_exp_f32_e32 v135, v138
		v_exp_f32_e32 v108, v139
		v_exp_f32_e32 v136, v140
		v_exp_f32_e32 v109, v112
		v_exp_f32_e32 v137, v113
		v_exp_f32_e32 v112, v106
		v_exp_f32_e32 v138, v107
		v_exp_f32_e32 v113, v122
		v_exp_f32_e32 v139, v123
		v_exp_f32_e32 v106, v110
		v_exp_f32_e32 v122, v111
		v_exp_f32_e32 v107, v141
		v_exp_f32_e32 v123, v142
		v_exp_f32_e32 v110, v114
		v_exp_f32_e32 v140, v115
		v_exp_f32_e32 v111, v143
		v_exp_f32_e32 v141, v146
		v_exp_f32_e32 v114, v116
		v_exp_f32_e32 v142, v117
		v_exp_f32_e32 v115, v14
		v_exp_f32_e32 v143, v15
		v_exp_f32_e32 v14, v118
		v_exp_f32_e32 v116, v119
		v_exp_f32_e32 v15, v120
		v_exp_f32_e32 v117, v121
		v_exp_f32_e32 v118, v147
		v_exp_f32_e32 v120, v162
		v_exp_f32_e32 v119, v158
		v_exp_f32_e32 v121, v159
		v_exp_f32_e32 v146, v160
		v_exp_f32_e32 v158, v161
		v_exp_f32_e32 v147, v124
		v_exp_f32_e32 v159, v125
		v_exp_f32_e32 v124, v126
		v_exp_f32_e32 v160, v127
		v_exp_f32_e32 v125, v144
		v_exp_f32_e32 v161, v145
		v_exp_f32_e32 v126, v163
		v_exp_f32_e32 v144, v164
		v_exp_f32_e32 v127, v165
		v_exp_f32_e32 v145, v166
		v_exp_f32_e32 v163, v167
		v_exp_f32_e32 v165, v168
		v_exp_f32_e32 v166, v12
		v_exp_f32_e32 v216, v13
		v_exp_f32_e32 v167, v148
		v_exp_f32_e32 v217, v149
		v_exp_f32_e32 v12, v48
		v_exp_f32_e32 v148, v49
		v_exp_f32_e32 v13, v150
		v_exp_f32_e32 v149, v151
		v_exp_f32_e32 v48, v50
		v_exp_f32_e32 v150, v51
		v_exp_f32_e32 v49, v62
		v_exp_f32_e32 v151, v63
		v_exp_f32_e32 v50, v52
		v_exp_f32_e32 v62, v53
		v_exp_f32_e32 v51, v152
		v_exp_f32_e32 v63, v153
		v_exp_f32_e32 v52, v54
		v_exp_f32_e32 v152, v55
		v_exp_f32_e32 v53, v154
		v_exp_f32_e32 v153, v155
		v_exp_f32_e32 v54, v156
		v_exp_f32_e32 v154, v157
		v_exp_f32_e32 v55, v169
		v_exp_f32_e32 v155, v170
		v_exp_f32_e32 v156, v171
		v_exp_f32_e32 v168, v172
		v_exp_f32_e32 v157, v173
		v_exp_f32_e32 v169, v174
		v_exp_f32_e32 v170, v175
		v_exp_f32_e32 v172, v176
		v_exp_f32_e32 v171, v177
		v_exp_f32_e32 v173, v178
		v_exp_f32_e32 v174, v179
		v_exp_f32_e32 v176, v180
		v_exp_f32_e32 v175, v181
		v_exp_f32_e32 v177, v182
		v_exp_f32_e32 v178, v183
		v_exp_f32_e32 v180, v184
		v_exp_f32_e32 v179, v185
		v_exp_f32_e32 v181, v186
		v_exp_f32_e32 v182, v187
		v_exp_f32_e32 v184, v188
		v_exp_f32_e32 v183, v189
		v_exp_f32_e32 v185, v190
		v_exp_f32_e32 v186, v191
		v_exp_f32_e32 v188, v192
		v_exp_f32_e32 v187, v193
		v_exp_f32_e32 v189, v194
		v_exp_f32_e32 v190, v195
		v_exp_f32_e32 v192, v196
		v_exp_f32_e32 v191, v197
		v_exp_f32_e32 v193, v198
		v_exp_f32_e32 v194, v199
		v_exp_f32_e32 v196, v200
		v_exp_f32_e32 v195, v201
		v_exp_f32_e32 v197, v202
		v_exp_f32_e32 v198, v203
		v_exp_f32_e32 v200, v204
		v_exp_f32_e32 v199, v205
		v_exp_f32_e32 v201, v206
		v_exp_f32_e32 v202, v207
		v_exp_f32_e32 v204, v208
		v_pk_add_f32 v[206:207], v[210:211], v[212:213]
		v_pk_add_f32 v[208:209], v[128:129], v[214:215]
		v_pk_add_f32 v[218:219], v[98:99], v[130:131]
		v_pk_add_f32 v[220:221], v[96:97], v[132:133]
		v_pk_add_f32 v[222:223], v[102:103], v[104:105]
		v_pk_add_f32 v[224:225], v[100:101], v[134:135]
		v_pk_add_f32 v[226:227], v[108:109], v[136:137]
		v_pk_add_f32 v[228:229], v[112:113], v[138:139]
		v_pk_add_f32 v[230:231], v[106:107], v[122:123]
		v_pk_add_f32 v[232:233], v[110:111], v[140:141]
		v_pk_add_f32 v[234:235], v[114:115], v[142:143]
		v_pk_add_f32 v[236:237], v[14:15], v[116:117]
		v_pk_add_f32 v[238:239], v[118:119], v[120:121]
		v_pk_add_f32 v[240:241], v[146:147], v[158:159]
		v_pk_add_f32 v[242:243], v[124:125], v[160:161]
		v_pk_add_f32 v[244:245], v[126:127], v[144:145]
		v_mov_b32_e32 v246, v207
		v_mov_b32_e32 v247, v209
		v_mov_b32_e32 v248, v206
		v_mov_b32_e32 v249, v208
		v_pk_add_f32 v[206:207], v[248:249], v[246:247]
		v_mov_b32_e32 v208, v219
		v_mov_b32_e32 v209, v221
		v_mov_b32_e32 v246, v218
		v_mov_b32_e32 v247, v220
		v_pk_add_f32 v[218:219], v[246:247], v[208:209]
		v_mov_b32_e32 v208, v223
		v_mov_b32_e32 v209, v225
		v_mov_b32_e32 v220, v222
		v_mov_b32_e32 v221, v224
		v_pk_add_f32 v[222:223], v[220:221], v[208:209]
		v_mov_b32_e32 v208, v227
		v_mov_b32_e32 v209, v229
		v_mov_b32_e32 v220, v226
		v_mov_b32_e32 v221, v228
		v_pk_add_f32 v[224:225], v[220:221], v[208:209]
		v_mov_b32_e32 v208, v231
		v_mov_b32_e32 v209, v233
		v_mov_b32_e32 v220, v230
		v_mov_b32_e32 v221, v232
		v_pk_add_f32 v[226:227], v[220:221], v[208:209]
		v_mov_b32_e32 v208, v235
		v_mov_b32_e32 v209, v237
		v_mov_b32_e32 v220, v234
		v_mov_b32_e32 v221, v236
		v_pk_add_f32 v[228:229], v[220:221], v[208:209]
		v_mov_b32_e32 v208, v239
		v_mov_b32_e32 v209, v241
		v_mov_b32_e32 v220, v238
		v_mov_b32_e32 v221, v240
		v_pk_add_f32 v[230:231], v[220:221], v[208:209]
		v_mov_b32_e32 v208, v243
		v_mov_b32_e32 v209, v245
		v_mov_b32_e32 v220, v242
		v_mov_b32_e32 v221, v244
		v_pk_add_f32 v[232:233], v[220:221], v[208:209]
		v_mov_b32_e32 v208, v207
		v_mov_b32_e32 v209, v219
		v_mov_b32_e32 v220, v206
		v_mov_b32_e32 v221, v218
		v_pk_add_f32 v[206:207], v[220:221], v[208:209]
		v_mov_b32_e32 v208, v223
		v_mov_b32_e32 v209, v225
		v_mov_b32_e32 v218, v222
		v_mov_b32_e32 v219, v224
		v_pk_add_f32 v[220:221], v[218:219], v[208:209]
		v_mov_b32_e32 v208, v227
		v_mov_b32_e32 v209, v229
		v_mov_b32_e32 v218, v226
		v_mov_b32_e32 v219, v228
		v_pk_add_f32 v[222:223], v[218:219], v[208:209]
		v_mov_b32_e32 v208, v231
		v_mov_b32_e32 v209, v233
		v_mov_b32_e32 v218, v230
		v_mov_b32_e32 v219, v232
		v_pk_add_f32 v[224:225], v[218:219], v[208:209]
		v_mov_b32_e32 v208, v207
		v_mov_b32_e32 v209, v221
		v_mov_b32_e32 v218, v206
		v_mov_b32_e32 v219, v220
		v_pk_add_f32 v[206:207], v[218:219], v[208:209]
		v_mov_b32_e32 v208, v223
		v_mov_b32_e32 v209, v225
		v_mov_b32_e32 v218, v222
		v_mov_b32_e32 v219, v224
		v_pk_add_f32 v[220:221], v[218:219], v[208:209]
		v_mov_b32_e32 v208, v207
		v_mov_b32_e32 v209, v221
		v_mov_b32_e32 v218, v206
		v_mov_b32_e32 v219, v220
		v_pk_add_f32 v[206:207], v[218:219], v[208:209]
		v_add_f32_e32 v60, v206, v207
		ds_bpermute_b32 v162, v57, v60
		ds_bpermute_b32 v164, v59, v60
		v_pk_add_f32 v[206:207], v[166:167], v[216:217]
		v_pk_add_f32 v[208:209], v[12:13], v[148:149]
		v_pk_add_f32 v[218:219], v[48:49], v[150:151]
		v_pk_add_f32 v[220:221], v[50:51], v[62:63]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[222:223], v[162:163], v[164:165]
		v_pk_add_f32 v[224:225], v[52:53], v[152:153]
		v_pk_add_f32 v[226:227], v[54:55], v[154:155]
		v_pk_add_f32 v[228:229], v[156:157], v[168:169]
		v_pk_add_f32 v[230:231], v[170:171], v[172:173]
		v_pk_add_f32 v[232:233], v[174:175], v[176:177]
		v_pk_add_f32 v[234:235], v[178:179], v[180:181]
		v_pk_add_f32 v[236:237], v[182:183], v[184:185]
		v_pk_add_f32 v[238:239], v[186:187], v[188:189]
		v_pk_add_f32 v[240:241], v[190:191], v[192:193]
		v_pk_add_f32 v[242:243], v[194:195], v[196:197]
		v_pk_add_f32 v[244:245], v[198:199], v[200:201]
		v_mov_b32_e32 v203, v223
		v_mov_b32_e32 v205, v206
		v_pk_add_f32 v[246:247], v[202:203], v[204:205]
		v_mov_b32_e32 v248, v207
		v_mov_b32_e32 v249, v218
		v_pk_add_f32 v[206:207], v[248:249], v[208:209]
		v_mov_b32_e32 v208, v219
		v_mov_b32_e32 v209, v224
		v_pk_add_f32 v[208:209], v[208:209], v[220:221]
		v_mov_b32_e32 v218, v225
		v_mov_b32_e32 v219, v228
		v_pk_add_f32 v[220:221], v[218:219], v[226:227]
		v_mov_b32_e32 v218, v229
		v_mov_b32_e32 v219, v232
		v_pk_add_f32 v[218:219], v[218:219], v[230:231]
		v_mov_b32_e32 v224, v233
		v_mov_b32_e32 v225, v236
		v_pk_add_f32 v[226:227], v[224:225], v[234:235]
		v_mov_b32_e32 v224, v237
		v_mov_b32_e32 v225, v240
		v_pk_add_f32 v[224:225], v[224:225], v[238:239]
		v_mov_b32_e32 v228, v241
		v_mov_b32_e32 v229, v244
		v_pk_add_f32 v[230:231], v[228:229], v[242:243]
		v_mov_b32_e32 v228, v245
		v_mov_b32_e32 v229, v206
		v_pk_add_f32 v[228:229], v[228:229], v[246:247]
		v_mov_b32_e32 v232, v207
		v_mov_b32_e32 v233, v220
		v_pk_add_f32 v[206:207], v[232:233], v[208:209]
		v_mov_b32_e32 v208, v221
		v_mov_b32_e32 v209, v226
		v_pk_add_f32 v[208:209], v[208:209], v[218:219]
		v_mov_b32_e32 v218, v227
		v_mov_b32_e32 v219, v230
		v_pk_add_f32 v[220:221], v[218:219], v[224:225]
		v_mov_b32_e32 v218, v231
		v_mov_b32_e32 v219, v206
		v_pk_add_f32 v[218:219], v[218:219], v[228:229]
		v_mov_b32_e32 v224, v207
		v_mov_b32_e32 v225, v220
		v_pk_add_f32 v[206:207], v[224:225], v[208:209]
		v_mov_b32_e32 v208, v221
		v_mov_b32_e32 v209, v206
		v_pk_add_f32 v[220:221], v[208:209], v[218:219]
		v_add_f32_e32 v60, v207, v220
		v_add_f32_e32 v60, v221, v60
		ds_bpermute_b32 v162, v57, v60
		ds_bpermute_b32 v57, v59, v60
		v_sub_f32_e32 v7, v7, v56
		v_sub_f32_e32 v11, v11, v58
		v_exp_f32_e32 v206, v7
		v_exp_f32_e32 v208, v11
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v219, v162, v57
		v_mov_b32_e32 v207, v206
		v_pk_mul_f32 v[16:17], v[16:17], v[206:207]
		v_pk_mul_f32 v[18:19], v[18:19], v[206:207]
		v_pk_mul_f32 v[20:21], v[20:21], v[206:207]
		v_pk_mul_f32 v[22:23], v[22:23], v[206:207]
		v_pk_mul_f32 v[24:25], v[24:25], v[206:207]
		v_pk_mul_f32 v[26:27], v[26:27], v[206:207]
		v_pk_mul_f32 v[28:29], v[28:29], v[206:207]
		v_pk_mul_f32 v[30:31], v[30:31], v[206:207]
		v_pk_mul_f32 v[32:33], v[32:33], v[206:207]
		v_pk_mul_f32 v[34:35], v[34:35], v[206:207]
		v_pk_mul_f32 v[36:37], v[36:37], v[206:207]
		v_pk_mul_f32 v[38:39], v[38:39], v[206:207]
		v_pk_mul_f32 v[40:41], v[40:41], v[206:207]
		v_pk_mul_f32 v[42:43], v[42:43], v[206:207]
		v_pk_mul_f32 v[44:45], v[44:45], v[206:207]
		v_pk_mul_f32 v[46:47], v[46:47], v[206:207]
		v_mov_b32_e32 v209, v208
		v_pk_mul_f32 v[64:65], v[64:65], v[208:209]
		v_pk_mul_f32 v[66:67], v[66:67], v[208:209]
		v_pk_mul_f32 v[68:69], v[68:69], v[208:209]
		v_pk_mul_f32 v[70:71], v[70:71], v[208:209]
		v_pk_mul_f32 v[72:73], v[72:73], v[208:209]
		v_pk_mul_f32 v[74:75], v[74:75], v[208:209]
		v_pk_mul_f32 v[76:77], v[76:77], v[208:209]
		v_pk_mul_f32 v[78:79], v[78:79], v[208:209]
		v_pk_mul_f32 v[80:81], v[80:81], v[208:209]
		v_pk_mul_f32 v[82:83], v[82:83], v[208:209]
		v_pk_mul_f32 v[84:85], v[84:85], v[208:209]
		v_pk_mul_f32 v[86:87], v[86:87], v[208:209]
		v_pk_mul_f32 v[88:89], v[88:89], v[208:209]
		v_pk_mul_f32 v[90:91], v[90:91], v[208:209]
		v_pk_mul_f32 v[92:93], v[92:93], v[208:209]
		v_pk_mul_f32 v[94:95], v[94:95], v[208:209]
		v_mov_b32_e32 v218, v222
		v_mov_b32_e32 v220, v206
		v_mov_b32_e32 v221, v208
		v_accvgpr_read_b32 v7, a36
		v_mov_b32_e32 v206, v7
		v_accvgpr_read_b32 v7, a37
		v_mov_b32_e32 v207, v7
		v_pk_fma_f32 v[206:207], v[206:207], v[220:221], v[218:219]
		v_accvgpr_write_b32 a36, v206
		v_accvgpr_write_b32 a37, v207
		v_cvt_pk_bf16_f32 v220, v210, v212
		v_cvt_pk_bf16_f32 v221, v211, v213
		v_cvt_pk_bf16_f32 v222, v128, v214
		v_cvt_pk_bf16_f32 v223, v129, v215
		v_cvt_pk_bf16_f32 v208, v98, v130
		v_cvt_pk_bf16_f32 v209, v99, v131
		v_cvt_pk_bf16_f32 v210, v96, v132
		v_cvt_pk_bf16_f32 v211, v97, v133
		v_cvt_pk_bf16_f32 v96, v102, v104
		v_cvt_pk_bf16_f32 v97, v103, v105
		v_cvt_pk_bf16_f32 v98, v100, v134
		v_cvt_pk_bf16_f32 v99, v101, v135
		v_cvt_pk_bf16_f32 v100, v108, v136
		v_cvt_pk_bf16_f32 v101, v109, v137
		v_cvt_pk_bf16_f32 v102, v112, v138
		v_cvt_pk_bf16_f32 v103, v113, v139
		v_cvt_pk_bf16_f32 v128, v106, v122
		v_cvt_pk_bf16_f32 v129, v107, v123
		v_cvt_pk_bf16_f32 v130, v110, v140
		v_cvt_pk_bf16_f32 v131, v111, v141
		v_cvt_pk_bf16_f32 v104, v114, v142
		v_cvt_pk_bf16_f32 v105, v115, v143
		v_cvt_pk_bf16_f32 v106, v14, v116
		v_cvt_pk_bf16_f32 v107, v15, v117
		v_cvt_pk_bf16_f32 v108, v118, v120
		v_cvt_pk_bf16_f32 v109, v119, v121
		v_cvt_pk_bf16_f32 v110, v146, v158
		v_cvt_pk_bf16_f32 v111, v147, v159
		v_cvt_pk_bf16_f32 v112, v124, v160
		v_cvt_pk_bf16_f32 v113, v125, v161
		v_cvt_pk_bf16_f32 v114, v126, v144
		v_cvt_pk_bf16_f32 v115, v127, v145
		v_cvt_pk_bf16_f32 v116, v163, v165
		v_cvt_pk_bf16_f32 v117, v166, v216
		v_cvt_pk_bf16_f32 v118, v167, v217
		v_cvt_pk_bf16_f32 v119, v12, v148
		v_cvt_pk_bf16_f32 v120, v13, v149
		v_cvt_pk_bf16_f32 v121, v48, v150
		v_cvt_pk_bf16_f32 v122, v49, v151
		v_cvt_pk_bf16_f32 v123, v50, v62
		v_cvt_pk_bf16_f32 v12, v51, v63
		v_cvt_pk_bf16_f32 v13, v52, v152
		v_cvt_pk_bf16_f32 v14, v53, v153
		v_cvt_pk_bf16_f32 v15, v54, v154
		v_cvt_pk_bf16_f32 v48, v55, v155
		v_cvt_pk_bf16_f32 v49, v156, v168
		v_cvt_pk_bf16_f32 v50, v157, v169
		v_cvt_pk_bf16_f32 v51, v170, v172
		v_cvt_pk_bf16_f32 v52, v171, v173
		v_cvt_pk_bf16_f32 v53, v174, v176
		v_cvt_pk_bf16_f32 v54, v175, v177
		v_cvt_pk_bf16_f32 v55, v178, v180
		v_cvt_pk_bf16_f32 v124, v179, v181
		v_cvt_pk_bf16_f32 v125, v182, v184
		v_cvt_pk_bf16_f32 v126, v183, v185
		v_cvt_pk_bf16_f32 v127, v186, v188
		v_cvt_pk_bf16_f32 v132, v187, v189
		v_cvt_pk_bf16_f32 v133, v190, v192
		v_cvt_pk_bf16_f32 v134, v191, v193
		v_cvt_pk_bf16_f32 v135, v194, v196
		v_cvt_pk_bf16_f32 v136, v195, v197
		v_cvt_pk_bf16_f32 v137, v198, v200
		v_cvt_pk_bf16_f32 v138, v199, v201
		v_cvt_pk_bf16_f32 v139, v202, v204
		v_permlane32_swap_b32_e32 v220, v222
		v_permlane32_swap_b32_e32 v221, v223
		v_permlane32_swap_b32_e32 v208, v210
		v_permlane32_swap_b32_e32 v209, v211
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[16:31], a[96:99], v[220:223], v[16:31]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[32:47], a[128:131], v[220:223], v[32:47]
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_permlane32_swap_b32_e32 v12, v14
		v_permlane32_swap_b32_e32 v13, v15
		v_permlane32_swap_b32_e32 v48, v50
		v_permlane32_swap_b32_e32 v49, v51
		v_permlane32_swap_b32_e32 v52, v54
		v_permlane32_swap_b32_e32 v53, v55
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[80:95], a[128:131], v[116:119], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[96:99], v[116:119], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[100:103], v[208:211], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[132:135], v[208:211], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[132:135], v[120:123], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[100:103], v[120:123], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[104:107], v[96:99], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[136:139], v[96:99], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[136:139], v[12:15], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[104:107], v[12:15], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[108:111], v[100:103], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[140:143], v[100:103], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[140:143], v[48:51], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[108:111], v[48:51], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[112:115], v[128:131], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[144:147], v[128:131], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[52:55], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[112:115], v[52:55], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[116:119], v[104:107], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[148:151], v[104:107], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[148:151], v[124:127], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[116:119], v[124:127], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[120:123], v[108:111], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[152:155], v[108:111], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], v[132:135], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[120:123], v[132:135], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[16:31], a[124:127], v[112:115], v[16:31]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[156:159], v[112:115], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], v[136:139], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[124:127], v[136:139], v[64:79]
		s_mov_b32 s44, s26
		v_mov_b32_e32 v7, v56
		v_mov_b32_e32 v11, v58
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_4
.L_attn_fwd_persistent.loop_exit_4:
		v_accvgpr_read_b32 v5, a36
		v_rcp_f32_e32 v6, v5
		v_accvgpr_read_b32 v5, a37
		v_rcp_f32_e32 v12, v5
		v_mov_b32_e32 v7, v6
		v_pk_mul_f32 v[14:15], v[16:17], v[6:7]
		v_pk_mul_f32 v[16:17], v[18:19], v[6:7]
		v_pk_mul_f32 v[18:19], v[20:21], v[6:7]
		v_pk_mul_f32 v[20:21], v[22:23], v[6:7]
		v_pk_mul_f32 v[22:23], v[24:25], v[6:7]
		v_pk_mul_f32 v[24:25], v[26:27], v[6:7]
		v_pk_mul_f32 v[26:27], v[28:29], v[6:7]
		v_pk_mul_f32 v[28:29], v[30:31], v[6:7]
		v_pk_mul_f32 v[30:31], v[32:33], v[6:7]
		v_pk_mul_f32 v[32:33], v[34:35], v[6:7]
		v_pk_mul_f32 v[34:35], v[36:37], v[6:7]
		v_pk_mul_f32 v[36:37], v[38:39], v[6:7]
		v_pk_mul_f32 v[38:39], v[40:41], v[6:7]
		v_pk_mul_f32 v[40:41], v[42:43], v[6:7]
		v_pk_mul_f32 v[42:43], v[44:45], v[6:7]
		v_pk_mul_f32 v[44:45], v[46:47], v[6:7]
		v_mov_b32_e32 v13, v12
		v_pk_mul_f32 v[6:7], v[64:65], v[12:13]
		v_pk_mul_f32 v[46:47], v[66:67], v[12:13]
		v_pk_mul_f32 v[48:49], v[68:69], v[12:13]
		v_pk_mul_f32 v[50:51], v[70:71], v[12:13]
		v_pk_mul_f32 v[52:53], v[72:73], v[12:13]
		v_pk_mul_f32 v[54:55], v[74:75], v[12:13]
		v_pk_mul_f32 v[56:57], v[76:77], v[12:13]
		v_pk_mul_f32 v[58:59], v[78:79], v[12:13]
		v_pk_mul_f32 v[62:63], v[80:81], v[12:13]
		v_pk_mul_f32 v[64:65], v[82:83], v[12:13]
		v_pk_mul_f32 v[66:67], v[84:85], v[12:13]
		v_pk_mul_f32 v[68:69], v[86:87], v[12:13]
		v_pk_mul_f32 v[70:71], v[88:89], v[12:13]
		v_pk_mul_f32 v[72:73], v[90:91], v[12:13]
		v_pk_mul_f32 v[74:75], v[92:93], v[12:13]
		v_pk_mul_f32 v[76:77], v[94:95], v[12:13]
		v_cvt_pk_bf16_f32 v80, v14, v15
		v_cvt_pk_bf16_f32 v81, v16, v17
		v_cvt_pk_bf16_f32 v82, v18, v19
		v_cvt_pk_bf16_f32 v83, v20, v21
		v_cvt_pk_bf16_f32 v12, v22, v23
		v_cvt_pk_bf16_f32 v13, v24, v25
		v_cvt_pk_bf16_f32 v14, v26, v27
		v_cvt_pk_bf16_f32 v15, v28, v29
		v_cvt_pk_bf16_f32 v16, v30, v31
		v_cvt_pk_bf16_f32 v17, v32, v33
		v_cvt_pk_bf16_f32 v18, v34, v35
		v_cvt_pk_bf16_f32 v19, v36, v37
		v_cvt_pk_bf16_f32 v20, v38, v39
		v_cvt_pk_bf16_f32 v21, v40, v41
		v_cvt_pk_bf16_f32 v22, v42, v43
		v_cvt_pk_bf16_f32 v23, v44, v45
		v_cvt_pk_bf16_f32 v24, v6, v7
		v_cvt_pk_bf16_f32 v25, v46, v47
		v_cvt_pk_bf16_f32 v26, v48, v49
		v_cvt_pk_bf16_f32 v27, v50, v51
		v_cvt_pk_bf16_f32 v28, v52, v53
		v_cvt_pk_bf16_f32 v29, v54, v55
		v_cvt_pk_bf16_f32 v30, v56, v57
		v_cvt_pk_bf16_f32 v31, v58, v59
		v_cvt_pk_bf16_f32 v32, v62, v63
		v_cvt_pk_bf16_f32 v33, v64, v65
		v_cvt_pk_bf16_f32 v34, v66, v67
		v_cvt_pk_bf16_f32 v35, v68, v69
		v_cvt_pk_bf16_f32 v36, v70, v71
		v_cvt_pk_bf16_f32 v37, v72, v73
		v_cvt_pk_bf16_f32 v38, v74, v75
		v_cvt_pk_bf16_f32 v39, v76, v77
		v_permlane32_swap_b32_e32 v80, v82
		v_permlane32_swap_b32_e32 v81, v83
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
		v_permlane32_swap_b32_e32 v36, v38
		v_permlane32_swap_b32_e32 v37, v39
		s_lshl_b32 s1, s43, 9
		s_add_i32 s21, s1, s25
		s_add_i32 s21, s21, s40
		v_accvgpr_read_b32 v5, a0
		v_add3_u32 v5, s21, v5, v9
		v_accvgpr_read_b32 v6, a1
		v_accvgpr_read_b32 v7, a2
		v_add3_u32 v5, v5, v6, v7
		v_accvgpr_read_b32 v6, a3
		v_accvgpr_read_b32 v7, a4
		v_add3_u32 v5, v5, v6, v7
		v_accvgpr_read_b32 v6, a5
		v_add3_u32 v5, v5, v6, v61
		v_cndmask_b32_e64 v5, v10, v5, s[46:47]
		buffer_store_dwordx4 v[80:83], v5, s[36:39], 0 offen
		s_add_i32 s24, s1, 32
		s_add_i32 s24, s24, s25
		s_add_i32 s24, s24, s40
		v_accvgpr_read_b32 v5, a0
		v_add3_u32 v5, s24, v5, v9
		v_accvgpr_read_b32 v6, a1
		v_accvgpr_read_b32 v7, a2
		v_add3_u32 v5, v5, v6, v7
		v_accvgpr_read_b32 v6, a3
		v_accvgpr_read_b32 v7, a4
		v_add3_u32 v5, v5, v6, v7
		v_accvgpr_read_b32 v6, a5
		v_add3_u32 v5, v5, v6, v61
		v_cndmask_b32_e64 v5, v10, v5, s[46:47]
		buffer_store_dwordx4 v[12:15], v5, s[36:39], 0 offen
		s_add_i32 s26, s1, 64
		s_add_i32 s26, s26, s25
		s_add_i32 s26, s26, s40
		v_accvgpr_read_b32 v5, a0
		v_add3_u32 v5, s26, v5, v9
		v_accvgpr_read_b32 v6, a1
		v_accvgpr_read_b32 v7, a2
		v_add3_u32 v5, v5, v6, v7
		v_accvgpr_read_b32 v6, a3
		v_accvgpr_read_b32 v7, a4
		v_add3_u32 v5, v5, v6, v7
		v_accvgpr_read_b32 v6, a5
		v_add3_u32 v5, v5, v6, v61
		v_cndmask_b32_e64 v5, v10, v5, s[46:47]
		buffer_store_dwordx4 v[16:19], v5, s[36:39], 0 offen
		s_add_i32 s1, s1, 0x60
		s_add_i32 s1, s1, s25
		s_add_i32 s1, s1, s40
		v_accvgpr_read_b32 v5, a0
		v_add3_u32 v5, s1, v5, v9
		v_accvgpr_read_b32 v6, a1
		v_accvgpr_read_b32 v7, a2
		v_add3_u32 v5, v5, v6, v7
		v_accvgpr_read_b32 v6, a3
		v_accvgpr_read_b32 v7, a4
		v_add3_u32 v5, v5, v6, v7
		v_accvgpr_read_b32 v6, a5
		v_add3_u32 v5, v5, v6, v61
		v_cndmask_b32_e64 v5, v10, v5, s[46:47]
		buffer_store_dwordx4 v[20:23], v5, s[36:39], 0 offen
		v_accvgpr_read_b32 v5, a6
		v_add3_u32 v5, s21, v5, v61
		v_cndmask_b32_e64 v5, v10, v5, s[48:49]
		buffer_store_dwordx4 v[24:27], v5, s[36:39], 0 offen
		v_accvgpr_read_b32 v5, a6
		v_add3_u32 v5, s24, v5, v61
		v_cndmask_b32_e64 v5, v10, v5, s[48:49]
		buffer_store_dwordx4 v[28:31], v5, s[36:39], 0 offen
		v_accvgpr_read_b32 v5, a6
		v_add3_u32 v5, s26, v5, v61
		v_cndmask_b32_e64 v5, v10, v5, s[48:49]
		buffer_store_dwordx4 v[32:35], v5, s[36:39], 0 offen
		v_accvgpr_read_b32 v5, a6
		v_add3_u32 v5, s1, v5, v61
		v_cndmask_b32_e64 v5, v10, v5, s[48:49]
		buffer_store_dwordx4 v[36:39], v5, s[36:39], 0 offen
		s_branch .L_attn_fwd_persistent.if_end_0
.L_attn_fwd_persistent.if_else_0:
.L_attn_fwd_persistent.if_end_0:
		s_mov_b32 m0, s17
		s_add_i32 s0, s0, 32
		s_waitcnt lgkmcnt(0)
		ds_read_addtid_b32 v5 offset:2048
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v5
		s_mul_i32 s1, s1, 16
		s_nop 0
		v_mov_b32_e32 v5, s1
		s_nop 0
		v_readfirstlane_b32 s1, v5
		s_cmp_lt_i32 s0, s1
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_0
.L_attn_fwd_persistent.loop_exit_0:
		s_endpgm
	.size	_attn_fwd_persistent, .-_attn_fwd_persistent
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _attn_fwd_persistent
		.amdhsa_group_segment_fixed_size 129456
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
		.amdhsa_next_free_sgpr 94
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
	.set .L_attn_fwd_persistent.numbered_sgpr, 94
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
    .group_segment_fixed_size: 129456
    .kernarg_segment_align: 8
    .kernarg_segment_size: 104
    .max_flat_workgroup_size: 256
    .name:           _attn_fwd_persistent
    .private_segment_fixed_size: 0
    .sgpr_count:     94
    .sgpr_spill_count: 0
    .symbol:         _attn_fwd_persistent.kd
    .uses_dynamic_stack: false
    .vgpr_count:     512
    .agpr_count:     256
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 626
    wave.regalloc.agpr.dwords: 1110
    wave.regalloc.remat.dwords: 186
    wave.regalloc.sgpr_to_vgpr.dwords: 94
    wave.regalloc.lds.dwords: 28
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
