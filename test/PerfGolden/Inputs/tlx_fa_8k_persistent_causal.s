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
		v_readfirstlane_b32 s18, v0
		s_mov_b32 m0, s17
		s_nop 0
		v_mov_b32_e32 v1, s18
		ds_write_addtid_b32 v1 offset:24576
		v_readfirstlane_b32 s18, v1
		s_lshl_b32 s18, s18, 2
		s_add_i32 s18, s18, 0x189b0
		v_mov_b32_e32 v1, s18
		s_load_dword s19, s[0:1], 0x38
		s_load_dword s20, s[0:1], 0x3c
		s_load_dword s21, s[0:1], 0x40
		s_load_dword s22, s[0:1], 0x44
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v2, s22
		v_readfirstlane_b32 s22, v1
		s_mov_b32 m0, s22
		s_nop 0
		ds_write_addtid_b32 v2
		s_load_dword s22, s[0:1], 0x48
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v2, s22
		v_readfirstlane_b32 s22, v1
		s_mov_b32 m0, s22
		s_nop 0
		ds_write_addtid_b32 v2 offset:1024
		s_load_dword s22, s[0:1], 0x4c
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s18
		v_mov_b32_e32 v2, s22
		ds_write_addtid_b32 v2 offset:11264
		s_load_dword s22, s[0:1], 0x50
		s_load_dword s23, s[0:1], 0x54
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v2, s23
		s_load_dword s23, s[0:1], 0x58
		s_load_dword s24, s[0:1], 0x5c
		s_load_dword s25, s[0:1], 0x60
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v3, s25
		v_readfirstlane_b32 s0, v1
		s_mov_b32 m0, s0
		s_nop 0
		ds_write_addtid_b32 v3 offset:4096
		s_and_b32 s0, s16, 7
		v_mov_b32_e32 v4, s0
		s_lshr_b32 s0, s16, 3
		v_readfirstlane_b32 s1, v2
		s_mul_i32 s1, s22, s1
		s_nop 0
		v_mov_b32_e32 v5, s1
		s_nop 0
		v_readfirstlane_b32 s1, v5
		s_add_i32 s1, s1, 7
		s_mov_b32 s16, 1
		s_mov_b32 s22, 7
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s22, s22, 0
		s_add_i32 s1, s1, s22
		s_ashr_i32 s1, s1, 3
		v_mov_b32_e32 v6, s1
		v_readfirstlane_b32 s1, v1
		s_mov_b32 m0, s1
		s_nop 0
		ds_write_addtid_b32 v6 offset:2048
		v_readfirstlane_b32 s1, v6
		s_mul_i32 s1, s1, 16
		s_nop 0
		v_mov_b32_e32 v6, s1
		s_nop 0
		v_readfirstlane_b32 s1, v6
		s_cmp_lt_i32 s0, s1
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_0
.L_attn_fwd_persistent.loop_head_0:
		s_lshr_b32 s1, s0, 4
		s_and_b32 s22, s0, 15
		s_mul_i32 s1, s1, 8
		v_readfirstlane_b32 s25, v4
		s_add_i32 s1, s25, s1
		v_readfirstlane_b32 s25, v5
		s_cmp_lt_i32 s1, s25
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_0
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s25, 1, 0
		s_xor_b32 s26, s1, -1
		s_add_i32 s26, s26, 1
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s25, s26, s1
		s_cselect_b32 s26, 1, 0
		v_readfirstlane_b32 s27, v2
		s_xor_b32 s27, s27, -1
		s_add_i32 s27, s27, 1
		v_readfirstlane_b32 s28, v2
		s_cmp_lt_i32 s28, 0
		v_readfirstlane_b32 s28, v2
		s_cselect_b32 s27, s27, s28
		v_mov_b32_e32 v6, s27
		v_cvt_f32_u32_e32 v6, v6
		v_rcp_iflag_f32_e32 v6, v6
		v_mov_b32_e32 v7, 0x4f7ffffe
		v_mul_f32_e32 v6, v7, v6
		v_cvt_u32_f32_e32 v6, v6
		s_xor_b32 s28, s27, -1
		v_readfirstlane_b32 s29, v6
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
		v_readfirstlane_b32 s30, v2
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
		v_mov_b32_e32 v6, s22
		v_readfirstlane_b32 s22, v1
		s_mov_b32 m0, s22
		s_nop 0
		ds_write_addtid_b32 v6 offset:3072
		v_readfirstlane_b32 s22, v6
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
		v_accvgpr_write_b32 a0, v22
		v_accvgpr_read_b32 v22, a0
		v_and_b32_e32 v23, 1, v22
		v_mov_b32_e32 v24, 64
		v_mul_lo_u32 v24, v24, v23
		v_xor_b32_e32 v11, v11, v24
		v_accvgpr_write_b32 a1, v11
		v_accvgpr_read_b32 v11, a1
		v_add_u32_e32 v11, s22, v11
		v_xor_b32_e32 v7, 0x80, v7
		v_xor_b32_e32 v7, v7, v10
		v_xor_b32_e32 v7, v7, v12
		v_bitop3_b32 v7, v7, v15, v18 bitop3:0x96
		v_bitop3_b32 v7, v7, v21, v24 bitop3:0x96
		v_accvgpr_write_b32 a2, v7
		v_accvgpr_read_b32 v7, a2
		v_add_u32_e32 v7, s22, v7
		v_cmp_lt_i32_e64 vcc, v11, s23
		s_mov_b64 s[26:27], vcc
		v_mov_b32_e32 v10, s26
		v_mov_b32_e32 v11, s27
		v_readfirstlane_b32 s26, v1
		s_mov_b32 m0, s26
		s_nop 0
		ds_write_addtid_b32 v10 offset:7168
		v_readfirstlane_b32 s26, v1
		s_mov_b32 m0, s26
		s_nop 0
		ds_write_addtid_b32 v11 offset:8192
		v_cmp_lt_i32_e64 vcc, v7, s23
		s_mov_b64 s[26:27], vcc
		v_mov_b32_e32 v10, s26
		v_mov_b32_e32 v11, s27
		v_readfirstlane_b32 s26, v1
		s_mov_b32 m0, s26
		s_nop 0
		ds_write_addtid_b32 v10 offset:9216
		v_readfirstlane_b32 s26, v1
		s_mov_b32 m0, s26
		s_nop 0
		ds_write_addtid_b32 v11 offset:10240
		v_mov_b32_e32 v7, 2
		v_mul_lo_u32 v7, v7, v17
		v_lshrrev_b32_e32 v10, 5, v0
		v_and_b32_e32 v11, 1, v10
		v_mov_b32_e32 v12, 4
		v_mul_lo_u32 v12, v12, v11
		v_bitop3_b32 v15, v14, v7, v12 bitop3:0x96
		v_mov_b32_e32 v18, 8
		v_mul_lo_u32 v18, v18, v20
		v_mov_b32_e32 v21, 16
		v_mul_lo_u32 v21, v21, v23
		v_bitop3_b32 v15, v15, v18, v21 bitop3:0x96
		v_accvgpr_write_b32 a3, v15
		v_accvgpr_read_b32 v15, a3
		v_add_u32_e32 v15, s22, v15
		v_cmp_lt_i32_e64 vcc, v15, s23
		s_mov_b64 s[26:27], vcc
		s_mov_b32 s30, 0x7fffffff
		s_mov_b32 s31, 0x31016000
		s_mov_b32 s28, s4
		s_mov_b32 s29, s5
		s_mov_b32 s32, s6
		s_mov_b32 s33, s7
		s_mov_b32 s34, s30
		s_mov_b32 s35, s31
		v_readfirstlane_b32 s36, v6
		s_mul_i32 s36, s36, s12
		s_lshl_b32 s36, s36, 9
		s_mul_i32 s37, s1, s10
		s_lshl_b32 s37, s37, 1
		s_add_i32 s36, s36, s37
		s_mul_i32 s37, s25, s11
		s_lshl_b32 s37, s37, 1
		s_add_i32 s36, s36, s37
		v_accvgpr_read_b32 v15, a0
		v_mul_lo_u32 v15, s12, v15
		v_lshlrev_b32_e32 v15, 5, v15
		v_accvgpr_write_b32 a4, v15
		v_and_b32_e32 v15, 1, v19
		v_accvgpr_write_b32 a5, v15
		v_accvgpr_read_b32 v15, a5
		v_mul_lo_u32 v15, s12, v15
		v_lshlrev_b32_e32 v15, 4, v15
		v_accvgpr_write_b32 a6, v15
		v_accvgpr_read_b32 v15, a4
		v_accvgpr_read_b32 v24, a6
		v_add3_u32 v15, s36, v15, v24
		v_and_b32_e32 v10, 1, v10
		v_accvgpr_write_b32 a7, v10
		v_accvgpr_read_b32 v10, a7
		v_mul_lo_u32 v10, s12, v10
		v_lshlrev_b32_e32 v10, 3, v10
		v_accvgpr_write_b32 a8, v10
		v_and_b32_e32 v10, 1, v16
		v_accvgpr_write_b32 a9, v10
		v_accvgpr_read_b32 v10, a9
		v_mul_lo_u32 v10, s12, v10
		v_lshlrev_b32_e32 v10, 2, v10
		v_accvgpr_write_b32 a10, v10
		v_accvgpr_read_b32 v10, a8
		v_accvgpr_read_b32 v16, a10
		v_add3_u32 v10, v15, v10, v16
		v_and_b32_e32 v13, 1, v13
		v_accvgpr_write_b32 a11, v13
		v_accvgpr_read_b32 v13, a11
		v_mul_lo_u32 v13, s12, v13
		v_lshlrev_b32_e32 v13, 1, v13
		v_accvgpr_write_b32 a12, v13
		v_and_b32_e32 v13, 1, v0
		v_accvgpr_write_b32 a13, v13
		v_accvgpr_read_b32 v13, a13
		v_lshlrev_b32_e32 v13, 4, v13
		v_accvgpr_write_b32 a14, v13
		v_accvgpr_read_b32 v13, a12
		v_accvgpr_read_b32 v15, a14
		v_add3_u32 v10, v10, v13, v15
		v_and_b32_e32 v9, 1, v9
		v_accvgpr_write_b32 a15, v9
		v_accvgpr_read_b32 v9, a15
		v_lshlrev_b32_e32 v9, 6, v9
		v_accvgpr_write_b32 a16, v9
		v_and_b32_e32 v8, 1, v8
		v_accvgpr_write_b32 a17, v8
		v_accvgpr_read_b32 v8, a17
		v_lshlrev_b32_e32 v8, 5, v8
		v_accvgpr_write_b32 a18, v8
		v_accvgpr_read_b32 v8, a16
		v_accvgpr_read_b32 v9, a18
		v_add3_u32 v8, v10, v8, v9
		v_mov_b32_e32 v9, 0x80000000
		v_cndmask_b32_e64 v8, v9, v8, s[26:27]
		s_mov_b32 s40, s2
		s_mov_b32 s41, s3
		s_mov_b32 s42, s30
		s_mov_b32 s43, s31
		buffer_load_dwordx4 v[24:27], v8, s[40:43], 0 offen
		v_bitop3_b32 v8, 32, v14, v7 bitop3:0x96
		v_xor_b32_e32 v8, v8, v12
		v_bitop3_b32 v8, v8, v18, v21 bitop3:0x96
		v_accvgpr_write_b32 a19, v8
		v_accvgpr_read_b32 v8, a19
		v_add_u32_e32 v8, s22, v8
		v_cmp_lt_i32_e64 vcc, v8, s23
		s_mov_b64 s[26:27], vcc
		v_accvgpr_read_b32 v8, a0
		v_lshlrev_b32_e32 v8, 4, v8
		v_accvgpr_read_b32 v10, a5
		v_lshlrev_b32_e32 v10, 3, v10
		v_accvgpr_read_b32 v13, a7
		v_lshlrev_b32_e32 v13, 2, v13
		v_accvgpr_read_b32 v15, a11
		v_add_u32_e32 v15, 32, v15
		v_accvgpr_read_b32 v16, a9
		v_lshlrev_b32_e32 v16, 1, v16
		v_bitop3_b32 v15, v13, v15, v16 bitop3:0x96
		v_bitop3_b32 v15, v8, v10, v15 bitop3:0x96
		v_mul_lo_u32 v15, s12, v15
		v_lshlrev_b32_e32 v15, 1, v15
		v_accvgpr_write_b32 a20, v15
		v_accvgpr_read_b32 v15, a20
		v_accvgpr_read_b32 v28, a14
		v_add3_u32 v15, s36, v15, v28
		v_accvgpr_read_b32 v28, a16
		v_accvgpr_read_b32 v29, a18
		v_add3_u32 v15, v15, v28, v29
		v_cndmask_b32_e64 v15, v9, v15, s[26:27]
		buffer_load_dwordx4 v[28:31], v15, s[40:43], 0 offen
		v_bitop3_b32 v15, 64, v14, v7 bitop3:0x96
		v_xor_b32_e32 v15, v15, v12
		v_bitop3_b32 v15, v15, v18, v21 bitop3:0x96
		v_accvgpr_write_b32 a21, v15
		v_accvgpr_read_b32 v15, a21
		v_add_u32_e32 v15, s22, v15
		v_cmp_lt_i32_e64 vcc, v15, s23
		s_mov_b64 s[26:27], vcc
		v_accvgpr_read_b32 v15, a11
		v_add_u32_e32 v15, 64, v15
		v_bitop3_b32 v15, v13, v15, v16 bitop3:0x96
		v_bitop3_b32 v15, v8, v10, v15 bitop3:0x96
		v_mul_lo_u32 v15, s12, v15
		v_lshlrev_b32_e32 v15, 1, v15
		v_accvgpr_write_b32 a22, v15
		v_accvgpr_read_b32 v15, a22
		v_accvgpr_read_b32 v32, a14
		v_add3_u32 v15, s36, v15, v32
		v_accvgpr_read_b32 v32, a16
		v_accvgpr_read_b32 v33, a18
		v_add3_u32 v15, v15, v32, v33
		v_cndmask_b32_e64 v15, v9, v15, s[26:27]
		buffer_load_dwordx4 v[32:35], v15, s[40:43], 0 offen
		v_xor_b32_e32 v15, 0x60, v14
		v_xor_b32_e32 v15, v15, v7
		v_xor_b32_e32 v15, v15, v12
		v_bitop3_b32 v15, v15, v18, v21 bitop3:0x96
		v_accvgpr_write_b32 a23, v15
		v_accvgpr_read_b32 v15, a23
		v_add_u32_e32 v15, s22, v15
		v_cmp_lt_i32_e64 vcc, v15, s23
		s_mov_b64 s[26:27], vcc
		v_accvgpr_read_b32 v15, a11
		v_add_u32_e32 v15, 0x60, v15
		v_bitop3_b32 v15, v13, v15, v16 bitop3:0x96
		v_bitop3_b32 v15, v8, v10, v15 bitop3:0x96
		v_mul_lo_u32 v15, s12, v15
		v_lshlrev_b32_e32 v15, 1, v15
		v_accvgpr_write_b32 a24, v15
		v_accvgpr_read_b32 v15, a24
		v_accvgpr_read_b32 v36, a14
		v_add3_u32 v15, s36, v15, v36
		v_accvgpr_read_b32 v36, a16
		v_accvgpr_read_b32 v37, a18
		v_add3_u32 v15, v15, v36, v37
		v_cndmask_b32_e64 v15, v9, v15, s[26:27]
		buffer_load_dwordx4 v[36:39], v15, s[40:43], 0 offen
		v_xor_b32_e32 v15, 0x80, v14
		v_xor_b32_e32 v15, v15, v7
		v_xor_b32_e32 v15, v15, v12
		v_bitop3_b32 v15, v15, v18, v21 bitop3:0x96
		v_accvgpr_write_b32 a25, v15
		v_accvgpr_read_b32 v15, a25
		v_add_u32_e32 v15, s22, v15
		v_cmp_lt_i32_e64 vcc, v15, s23
		s_mov_b64 s[26:27], vcc
		v_accvgpr_read_b32 v15, a11
		v_add_u32_e32 v15, 0x80, v15
		v_bitop3_b32 v15, v13, v15, v16 bitop3:0x96
		v_bitop3_b32 v15, v8, v10, v15 bitop3:0x96
		v_mul_lo_u32 v15, s12, v15
		v_lshlrev_b32_e32 v15, 1, v15
		v_accvgpr_write_b32 a26, v15
		v_accvgpr_read_b32 v15, a26
		v_accvgpr_read_b32 v40, a14
		v_add3_u32 v15, s36, v15, v40
		v_accvgpr_read_b32 v40, a16
		v_accvgpr_read_b32 v41, a18
		v_add3_u32 v15, v15, v40, v41
		v_cndmask_b32_e64 v15, v9, v15, s[26:27]
		buffer_load_dwordx4 v[40:43], v15, s[40:43], 0 offen
		v_xor_b32_e32 v15, 0xa0, v14
		v_xor_b32_e32 v15, v15, v7
		v_xor_b32_e32 v15, v15, v12
		v_bitop3_b32 v15, v15, v18, v21 bitop3:0x96
		v_accvgpr_write_b32 a27, v15
		v_accvgpr_read_b32 v15, a27
		v_add_u32_e32 v15, s22, v15
		v_cmp_lt_i32_e64 vcc, v15, s23
		s_mov_b64 s[26:27], vcc
		v_accvgpr_read_b32 v15, a11
		v_add_u32_e32 v15, 0xa0, v15
		v_bitop3_b32 v15, v13, v15, v16 bitop3:0x96
		v_bitop3_b32 v15, v8, v10, v15 bitop3:0x96
		v_mul_lo_u32 v15, s12, v15
		v_lshlrev_b32_e32 v15, 1, v15
		v_accvgpr_write_b32 a28, v15
		v_accvgpr_read_b32 v15, a28
		v_accvgpr_read_b32 v44, a14
		v_add3_u32 v15, s36, v15, v44
		v_accvgpr_read_b32 v44, a16
		v_accvgpr_read_b32 v45, a18
		v_add3_u32 v15, v15, v44, v45
		v_cndmask_b32_e64 v15, v9, v15, s[26:27]
		buffer_load_dwordx4 v[44:47], v15, s[40:43], 0 offen
		v_xor_b32_e32 v15, 0xc0, v14
		v_xor_b32_e32 v15, v15, v7
		v_xor_b32_e32 v15, v15, v12
		v_bitop3_b32 v15, v15, v18, v21 bitop3:0x96
		v_accvgpr_write_b32 a29, v15
		v_accvgpr_read_b32 v15, a29
		v_add_u32_e32 v15, s22, v15
		v_cmp_lt_i32_e64 vcc, v15, s23
		s_mov_b64 s[26:27], vcc
		v_accvgpr_read_b32 v15, a11
		v_add_u32_e32 v15, 0xc0, v15
		v_bitop3_b32 v15, v13, v15, v16 bitop3:0x96
		v_bitop3_b32 v15, v8, v10, v15 bitop3:0x96
		v_mul_lo_u32 v15, s12, v15
		v_lshlrev_b32_e32 v15, 1, v15
		v_accvgpr_write_b32 a30, v15
		v_accvgpr_read_b32 v15, a30
		v_accvgpr_read_b32 v48, a14
		v_add3_u32 v15, s36, v15, v48
		v_accvgpr_read_b32 v48, a16
		v_accvgpr_read_b32 v49, a18
		v_add3_u32 v15, v15, v48, v49
		v_cndmask_b32_e64 v15, v9, v15, s[26:27]
		buffer_load_dwordx4 v[48:51], v15, s[40:43], 0 offen
		v_xor_b32_e32 v15, 0xe0, v14
		v_xor_b32_e32 v7, v15, v7
		v_xor_b32_e32 v7, v7, v12
		v_bitop3_b32 v7, v7, v18, v21 bitop3:0x96
		v_accvgpr_write_b32 a31, v7
		v_accvgpr_read_b32 v7, a31
		v_add_u32_e32 v7, s22, v7
		v_accvgpr_read_b32 v15, a11
		v_add_u32_e32 v15, 0xe0, v15
		v_bitop3_b32 v13, v13, v15, v16 bitop3:0x96
		v_bitop3_b32 v13, v8, v10, v13 bitop3:0x96
		v_mul_lo_u32 v13, s12, v13
		v_lshlrev_b32_e32 v13, 1, v13
		v_accvgpr_write_b32 a32, v13
		v_accvgpr_read_b32 v13, a32
		v_accvgpr_read_b32 v15, a14
		v_add3_u32 v13, s36, v13, v15
		v_cmp_lt_i32_e64 vcc, v7, s23
		v_accvgpr_read_b32 v7, a16
		v_accvgpr_read_b32 v15, a18
		v_add3_u32 v7, v13, v7, v15
		v_cndmask_b32_e32 v7, v9, v7, vcc
		buffer_load_dwordx4 v[52:55], v7, s[40:43], 0 offen
		s_waitcnt vmcnt(8)
		s_barrier
		v_accvgpr_read_b32 v7, a5
		v_lshlrev_b32_e32 v7, 2, v7
		v_accvgpr_read_b32 v13, a7
		v_lshlrev_b32_e32 v13, 1, v13
		v_accvgpr_read_b32 v15, a9
		v_xor_b32_e32 v15, v0, v15
		v_bitop3_b32 v7, v7, v13, v15 bitop3:0x96
		v_lshlrev_b32_e32 v7, 4, v7
		v_add_u32_e32 v7, 0x10000, v7
		v_accvgpr_write_b32 a33, v7
		v_accvgpr_read_b32 v7, a33
		s_waitcnt vmcnt(7)
		ds_write_b128 v7, v[24:27] offset:2480
		v_accvgpr_read_b32 v7, a33
		s_waitcnt vmcnt(6)
		ds_write_b128 v7, v[28:31] offset:6576
		v_accvgpr_read_b32 v7, a33
		s_waitcnt vmcnt(5)
		ds_write_b128 v7, v[32:35] offset:10672
		v_accvgpr_read_b32 v7, a33
		s_waitcnt vmcnt(4)
		ds_write_b128 v7, v[36:39] offset:14768
		v_lshlrev_b32_e32 v7, 12, v19
		v_add_u32_e32 v7, 0x10000, v7
		v_and_b32_e32 v13, 63, v0
		v_lshrrev_b32_e32 v15, 2, v13
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 5, v15
		v_lshrrev_b32_e32 v16, 1, v13
		v_and_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v16, 4, v16
		v_and_b32_e32 v18, 1, v13
		v_lshlrev_b32_e32 v18, 3, v18
		v_add3_u32 v19, v15, v16, v18
		v_lshrrev_b32_e32 v21, 5, v13
		v_accvgpr_write_b32 a34, v21
		v_accvgpr_read_b32 v21, a34
		v_xor_b32_e32 v19, v19, v21
		v_lshrrev_b32_e32 v21, 6, v19
		v_lshrrev_b32_e32 v24, 3, v13
		v_and_b32_e32 v24, 1, v24
		v_add_u32_e32 v21, v21, v24
		v_and_b32_e32 v21, 1, v21
		v_lshlrev_b32_e32 v21, 2, v21
		v_lshrrev_b32_e32 v25, 5, v19
		v_and_b32_e32 v25, 1, v25
		v_lshlrev_b32_e32 v25, 1, v25
		v_lshrrev_b32_e32 v26, 4, v13
		v_and_b32_e32 v26, 1, v26
		v_lshlrev_b32_e32 v27, 6, v24
		v_lshl_add_u32 v26, v26, 7, v27
		v_add_u32_e32 v27, v26, v19
		v_lshrrev_b32_e32 v19, 4, v19
		v_bitop3_b32 v19, v27, v19, 1 bitop3:0x78
		v_bitop3_b32 v19, v21, v25, v19 bitop3:0x96
		v_accvgpr_write_b32 a35, v19
		v_accvgpr_read_b32 v19, a35
		v_lshl_add_u32 v19, v19, 4, v7
		v_accvgpr_write_b32 a36, v19
		v_accvgpr_read_b32 v19, a36
		ds_read_b128 a[40:43], v19 offset:2480
		v_add_u32_e32 v19, 2, v15
		v_add3_u32 v19, v19, v16, v18
		v_accvgpr_read_b32 v21, a34
		v_xor_b32_e32 v19, v19, v21
		v_lshrrev_b32_e32 v21, 6, v19
		v_add_u32_e32 v21, v21, v24
		v_and_b32_e32 v21, 1, v21
		v_lshlrev_b32_e32 v21, 2, v21
		v_lshrrev_b32_e32 v25, 5, v19
		v_and_b32_e32 v25, 1, v25
		v_lshlrev_b32_e32 v25, 1, v25
		v_add_u32_e32 v27, v26, v19
		v_lshrrev_b32_e32 v19, 4, v19
		v_bitop3_b32 v19, v27, v19, 1 bitop3:0x78
		v_bitop3_b32 v19, v21, v25, v19 bitop3:0x96
		v_accvgpr_write_b32 a37, v19
		v_accvgpr_read_b32 v19, a37
		v_lshl_add_u32 v19, v19, 4, v7
		v_accvgpr_write_b32 a38, v19
		v_accvgpr_read_b32 v19, a38
		ds_read_b128 a[44:47], v19 offset:2480
		v_add_u32_e32 v19, 4, v15
		v_add3_u32 v19, v19, v16, v18
		v_accvgpr_read_b32 v21, a34
		v_xor_b32_e32 v19, v19, v21
		v_lshrrev_b32_e32 v21, 6, v19
		v_add_u32_e32 v21, v21, v24
		v_and_b32_e32 v21, 1, v21
		v_lshlrev_b32_e32 v21, 2, v21
		v_lshrrev_b32_e32 v25, 5, v19
		v_and_b32_e32 v25, 1, v25
		v_lshlrev_b32_e32 v25, 1, v25
		v_add_u32_e32 v27, v26, v19
		v_lshrrev_b32_e32 v19, 4, v19
		v_bitop3_b32 v19, v27, v19, 1 bitop3:0x78
		v_bitop3_b32 v19, v21, v25, v19 bitop3:0x96
		v_accvgpr_write_b32 a39, v19
		v_accvgpr_read_b32 v19, a39
		v_lshl_add_u32 v19, v19, 4, v7
		v_accvgpr_write_b32 a48, v19
		v_accvgpr_read_b32 v19, a48
		ds_read_b128 a[52:55], v19 offset:2480
		v_add_u32_e32 v15, 6, v15
		v_add3_u32 v15, v15, v16, v18
		v_accvgpr_read_b32 v16, a34
		v_xor_b32_e32 v15, v15, v16
		v_lshrrev_b32_e32 v16, 6, v15
		v_add_u32_e32 v16, v16, v24
		v_and_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v16, 2, v16
		v_lshrrev_b32_e32 v18, 5, v15
		v_and_b32_e32 v18, 1, v18
		v_lshlrev_b32_e32 v18, 1, v18
		v_add_u32_e32 v19, v26, v15
		v_lshrrev_b32_e32 v15, 4, v15
		v_bitop3_b32 v15, v19, v15, 1 bitop3:0x78
		v_bitop3_b32 v15, v16, v18, v15 bitop3:0x96
		v_accvgpr_write_b32 a49, v15
		v_accvgpr_read_b32 v15, a49
		v_lshl_add_u32 v7, v15, 4, v7
		v_accvgpr_write_b32 a50, v7
		v_accvgpr_read_b32 v7, a50
		ds_read_b128 a[56:59], v7 offset:2480
		v_add_u32_e32 v7, 32, v10
		v_xor_b32_e32 v7, v7, v8
		v_lshrrev_b32_e32 v8, 5, v7
		v_and_b32_e32 v8, 1, v8
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v10, a33
		s_waitcnt vmcnt(3)
		ds_write_b128 v10, v[40:43] offset:2480
		v_accvgpr_read_b32 v10, a33
		s_waitcnt vmcnt(2)
		ds_write_b128 v10, v[44:47] offset:6576
		v_accvgpr_read_b32 v10, a33
		s_waitcnt vmcnt(1)
		ds_write_b128 v10, v[48:51] offset:10672
		v_accvgpr_read_b32 v10, a33
		s_waitcnt vmcnt(0)
		ds_write_b128 v10, v[52:55] offset:14768
		v_lshlrev_b32_e32 v8, 14, v8
		v_accvgpr_write_b32 a51, v8
		v_lshrrev_b32_e32 v8, 4, v7
		v_and_b32_e32 v8, 1, v8
		v_lshlrev_b32_e32 v8, 13, v8
		v_accvgpr_write_b32 a60, v8
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshrrev_b32_e32 v7, 3, v7
		v_and_b32_e32 v7, 1, v7
		v_lshlrev_b32_e32 v7, 12, v7
		v_accvgpr_write_b32 a61, v7
		v_accvgpr_read_b32 v7, a60
		v_accvgpr_read_b32 v8, a61
		v_accvgpr_read_b32 v10, a51
		v_add3_u32 v7, v10, v7, v8
		v_accvgpr_read_b32 v8, a35
		v_lshl_add_u32 v8, v8, 4, v7
		ds_read_b128 a[64:67], v8 offset:51632
		v_accvgpr_read_b32 v8, a37
		v_lshl_add_u32 v8, v8, 4, v7
		ds_read_b128 a[68:71], v8 offset:51632
		v_accvgpr_read_b32 v8, a39
		v_lshl_add_u32 v8, v8, 4, v7
		ds_read_b128 a[72:75], v8 offset:51632
		v_accvgpr_read_b32 v8, a49
		v_lshl_add_u32 v7, v8, 4, v7
		ds_read_b128 a[76:79], v7 offset:51632
		v_readfirstlane_b32 s26, v6
		s_add_i32 s26, s26, 1
		s_mul_i32 s26, s26, 0x100
		v_readfirstlane_b32 s27, v3
		s_add_i32 s26, s26, s27
		s_cmp_lt_i32 s24, s26
		s_cselect_b32 s26, s24, s26
		s_add_i32 s27, s26, 0x7f
		s_mov_b32 s36, 0x7f
		s_cmp_lt_i32 s27, 0
		s_cselect_b32 s37, s36, 0
		s_add_i32 s27, s27, s37
		s_ashr_i32 s27, s27, 7
		v_readfirstlane_b32 s37, v3
		s_add_i32 s37, s22, s37
		s_cmp_lt_i32 s37, 0
		s_cselect_b32 s38, s36, 0
		s_add_i32 s37, s37, s38
		s_ashr_i32 s37, s37, 7
		s_cmp_lt_i32 s37, s27
		s_cselect_b32 s37, s37, s27
		s_cmp_gt_i32 s37, 0
		s_cselect_b32 s37, s37, 0
		v_mov_b32_e32 v6, 64
		v_mul_lo_u32 v6, v6, v14
		v_mov_b32_e32 v7, 32
		v_mul_lo_u32 v7, v7, v17
		v_mov_b32_e32 v8, 16
		v_mul_lo_u32 v8, v8, v11
		v_bitop3_b32 v10, v6, v7, v8 bitop3:0x96
		v_mov_b32_e32 v15, 2
		v_mul_lo_u32 v15, v15, v23
		v_bitop3_b32 v10, v10, v20, v15 bitop3:0x96
		v_bitop3_b32 v16, 4, v6, v7 bitop3:0x96
		v_xor_b32_e32 v16, v16, v8
		v_bitop3_b32 v16, v16, v20, v15 bitop3:0x96
		v_bitop3_b32 v17, 8, v6, v7 bitop3:0x96
		v_xor_b32_e32 v17, v17, v8
		v_bitop3_b32 v17, v17, v20, v15 bitop3:0x96
		v_bitop3_b32 v6, 12, v6, v7 bitop3:0x96
		v_xor_b32_e32 v6, v6, v8
		v_bitop3_b32 v6, v6, v20, v15 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v10, s24
		s_mov_b64 s[38:39], vcc
		v_cmp_lt_i32_e64 vcc, v16, s24
		s_mov_b64 s[44:45], vcc
		v_cmp_lt_i32_e64 vcc, v17, s24
		s_mov_b64 s[46:47], vcc
		v_cmp_lt_i32_e64 vcc, v6, s24
		s_mov_b64 s[48:49], vcc
		v_mov_b32_e32 v8, 16
		v_mul_lo_u32 v8, v8, v14
		v_mov_b32_e32 v14, 64
		v_mul_lo_u32 v14, v14, v11
		v_bitop3_b32 v11, v8, v7, v14 bitop3:0x96
		v_bitop3_b32 v11, v11, v20, v15 bitop3:0x96
		v_bitop3_b32 v18, 4, v8, v7 bitop3:0x96
		v_xor_b32_e32 v18, v18, v14
		v_bitop3_b32 v18, v18, v20, v15 bitop3:0x96
		v_bitop3_b32 v19, 8, v8, v7 bitop3:0x96
		v_xor_b32_e32 v19, v19, v14
		v_bitop3_b32 v19, v19, v20, v15 bitop3:0x96
		v_bitop3_b32 v7, 12, v8, v7 bitop3:0x96
		v_cmp_lt_i32_e64 vcc, v11, s24
		s_mov_b64 s[50:51], vcc
		v_cmp_lt_i32_e64 vcc, v18, s24
		s_mov_b64 s[52:53], vcc
		v_cmp_lt_i32_e64 vcc, v19, s24
		s_mov_b64 s[54:55], vcc
		v_readfirstlane_b32 s56, v0
		v_accvgpr_read_b32 v8, a0
		v_mul_lo_u32 v8, s15, v8
		v_accvgpr_read_b32 v21, a5
		v_mul_lo_u32 v21, s15, v21
		v_lshlrev_b32_e32 v21, 1, v21
		v_lshl_add_u32 v8, v8, 2, v21
		v_accvgpr_read_b32 v21, a7
		v_mul_lo_u32 v21, s15, v21
		v_lshl_add_u32 v8, v21, 5, v8
		v_accvgpr_read_b32 v21, a9
		v_mul_lo_u32 v21, s15, v21
		v_lshl_add_u32 v8, v21, 6, v8
		v_accvgpr_read_b32 v21, a11
		v_mul_lo_u32 v21, s15, v21
		v_lshlrev_b32_e32 v21, 7, v21
		v_accvgpr_read_b32 v23, a14
		v_add3_u32 v8, v8, v21, v23
		v_accvgpr_read_b32 v21, a16
		v_accvgpr_read_b32 v23, a18
		v_add3_u32 v8, v8, v21, v23
		s_mul_i32 s57, s1, s13
		s_lshl_b32 s57, s57, 1
		s_mul_i32 s58, s25, s14
		s_lshl_b32 s58, s58, 1
		s_add_i32 s59, s57, s58
		v_add_u32_e32 v21, s59, v8
		v_cndmask_b32_e64 v21, v9, v21, s[38:39]
		v_accvgpr_write_b32 a62, v21
		s_lshr_b32 s38, s56, 6
		s_mul_i32 s39, 0x410, s38
		s_mov_b32 m0, s39
		v_xor_b32_e32 v7, v7, v14
		v_accvgpr_read_b32 v14, a62
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		v_bitop3_b32 v7, v7, v20, v15 bitop3:0x96
		s_lshl_b32 s59, s15, 3
		s_add_i32 s59, s59, s57
		s_add_i32 s59, s59, s58
		v_add_u32_e32 v14, s59, v8
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v14, v9, v14, s[44:45]
		v_accvgpr_write_b32 a63, v14
		v_accvgpr_read_b32 v14, a63
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		s_lshl_b32 s44, s15, 4
		s_add_i32 s44, s44, s57
		s_add_i32 s44, s44, s58
		v_add_u32_e32 v14, s44, v8
		s_add_i32 m0, s39, 0x2080
		v_cndmask_b32_e64 v14, v9, v14, s[46:47]
		v_accvgpr_write_b32 a80, v14
		v_accvgpr_read_b32 v14, a80
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		s_mul_i32 s44, 24, s15
		s_add_i32 s44, s44, s57
		s_add_i32 s44, s44, s58
		v_add_u32_e32 v14, s44, v8
		s_add_i32 m0, s39, 0x30c0
		v_cndmask_b32_e64 v14, v9, v14, s[48:49]
		v_accvgpr_write_b32 a81, v14
		v_accvgpr_read_b32 v14, a81
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		v_accvgpr_read_b32 v14, a0
		v_mul_lo_u32 v14, s21, v14
		v_accvgpr_read_b32 v15, a5
		v_mul_lo_u32 v15, s21, v15
		v_lshlrev_b32_e32 v15, 1, v15
		v_lshl_add_u32 v14, v14, 2, v15
		v_accvgpr_read_b32 v15, a7
		v_mul_lo_u32 v15, s21, v15
		v_lshl_add_u32 v14, v15, 7, v14
		v_accvgpr_read_b32 v15, a9
		v_mul_lo_u32 v15, s21, v15
		v_lshl_add_u32 v14, v15, 6, v14
		v_accvgpr_read_b32 v15, a11
		v_mul_lo_u32 v15, s21, v15
		v_lshlrev_b32_e32 v15, 5, v15
		v_accvgpr_read_b32 v20, a14
		v_add3_u32 v14, v14, v15, v20
		v_accvgpr_read_b32 v15, a16
		v_accvgpr_read_b32 v20, a18
		v_add3_u32 v14, v14, v15, v20
		s_mul_i32 s44, s1, s19
		s_lshl_b32 s44, s44, 1
		s_mul_i32 s45, s25, s20
		s_lshl_b32 s45, s45, 1
		s_add_i32 s46, s44, s45
		v_add_u32_e32 v15, s46, v14
		s_mul_i32 s38, 0x440, s38
		s_add_i32 m0, s38, 0x81f0
		v_cndmask_b32_e64 v15, v9, v15, s[50:51]
		v_accvgpr_write_b32 a82, v15
		v_accvgpr_read_b32 v15, a82
		buffer_load_dwordx4 v15, s[32:35], 0 offen lds
		s_lshl_b32 s46, s21, 3
		s_add_i32 s46, s46, s44
		s_add_i32 s46, s46, s45
		v_add_u32_e32 v15, s46, v14
		s_add_i32 m0, s38, 0x92f0
		v_cndmask_b32_e64 v15, v9, v15, s[52:53]
		v_accvgpr_write_b32 a83, v15
		v_accvgpr_read_b32 v15, a83
		buffer_load_dwordx4 v15, s[32:35], 0 offen lds
		s_lshl_b32 s46, s21, 4
		s_add_i32 s46, s46, s44
		s_add_i32 s46, s46, s45
		v_add_u32_e32 v15, s46, v14
		s_add_i32 m0, s38, 0xa3f0
		v_cndmask_b32_e64 v15, v9, v15, s[54:55]
		v_accvgpr_write_b32 a84, v15
		v_accvgpr_read_b32 v15, a84
		buffer_load_dwordx4 v15, s[32:35], 0 offen lds
		s_mul_i32 s46, 24, s21
		s_add_i32 s46, s46, s44
		s_add_i32 s46, s46, s45
		v_cmp_lt_i32_e64 vcc, v7, s24
		v_add_u32_e32 v15, s46, v14
		v_mbcnt_lo_u32_b32 v20, -1, 0
		v_cndmask_b32_e32 v15, v9, v15, vcc
		v_accvgpr_write_b32 a85, v15
		s_add_i32 m0, s38, 0xb4f0
		s_mul_i32 s46, s37, 0x80
		v_accvgpr_read_b32 v15, a85
		buffer_load_dwordx4 v15, s[32:35], 0 offen lds
		v_mbcnt_hi_u32_b32 v15, -1, v20
		v_and_b32_e32 v20, 1, v15
		v_lshrrev_b32_e32 v21, 4, v15
		v_and_b32_e32 v21, 1, v21
		v_lshlrev_b32_e32 v21, 4, v21
		v_lshrrev_b32_e32 v23, 3, v15
		v_and_b32_e32 v23, 1, v23
		v_lshlrev_b32_e32 v23, 3, v23
		v_add3_u32 v24, v20, v21, v23
		v_lshrrev_b32_e32 v25, 2, v15
		v_and_b32_e32 v25, 1, v25
		v_lshlrev_b32_e32 v25, 2, v25
		v_lshrrev_b32_e32 v26, 1, v15
		v_and_b32_e32 v26, 1, v26
		v_lshlrev_b32_e32 v26, 1, v26
		v_add3_u32 v24, v24, v25, v26
		v_add_u32_e32 v20, 32, v20
		v_bitop3_b32 v20, v25, v20, v26 bitop3:0x96
		v_bitop3_b32 v20, v21, v23, v20 bitop3:0x96
		v_mov_b32_e32 v26, 0x3e38aa3b
		v_mov_b32_e32 v27, 0x3e38aa3b
		s_mov_b32 s37, 0xff800000
		v_mov_b32_e32 v21, s37
		v_readfirstlane_b32 s37, v1
		s_mov_b32 m0, s37
		s_nop 0
		ds_write_addtid_b32 v21 offset:5120
		v_readfirstlane_b32 s37, v21
		s_nop 1
		v_mov_b32_e32 v23, s37
		v_readfirstlane_b32 s37, v21
		s_nop 1
		v_mov_b32_e32 v21, s37
		s_mov_b32 s37, 1.0
		v_mov_b32_e32 v25, s37
		v_readfirstlane_b32 s37, v1
		s_mov_b32 m0, s37
		s_nop 0
		ds_write_addtid_b32 v25 offset:6144
		v_readfirstlane_b32 s37, v25
		s_nop 1
		v_mov_b32_e32 v28, s37
		v_readfirstlane_b32 s37, v25
		s_nop 1
		v_mov_b32_e32 v29, s37
		s_mov_b32 s37, 0
		v_accvgpr_read_b32 v25, a34
		v_lshlrev_b32_e32 v25, 4, v25
		v_accvgpr_write_b32 a86, v25
		v_and_b32_e32 v25, 31, v13
		v_lshrrev_b32_e32 v30, 4, v25
		v_lshlrev_b32_e32 v31, 9, v30
		v_accvgpr_write_b32 a87, v31
		v_lshrrev_b32_e32 v31, 3, v25
		v_and_b32_e32 v31, 1, v31
		v_mov_b32_e32 v32, 0x2080
		v_mul_lo_u32 v32, v32, v31
		v_accvgpr_write_b32 a88, v32
		v_lshrrev_b32_e32 v31, 2, v25
		v_and_b32_e32 v31, 1, v31
		v_mov_b32_e32 v32, 0x1040
		v_mul_lo_u32 v32, v32, v31
		v_accvgpr_write_b32 a89, v32
		v_lshrrev_b32_e32 v31, 1, v25
		v_and_b32_e32 v31, 1, v31
		v_mov_b32_e32 v32, 0x820
		v_mul_lo_u32 v32, v32, v31
		v_accvgpr_write_b32 a90, v32
		v_and_b32_e32 v25, 1, v25
		v_mov_b32_e32 v31, 0x410
		v_mul_lo_u32 v31, v31, v25
		v_accvgpr_write_b32 a91, v31
		v_accvgpr_read_b32 v25, a34
		v_mov_b32_e32 v31, 0x2200
		v_mul_lo_u32 v31, v31, v25
		v_accvgpr_write_b32 a92, v31
		v_lshlrev_b32_e32 v25, 5, v30
		v_accvgpr_write_b32 a93, v25
		v_and_b32_e32 v13, 15, v13
		v_lshrrev_b32_e32 v25, 2, v13
		v_mov_b32_e32 v30, 0x440
		v_mul_lo_u32 v30, v30, v25
		v_and_b32_e32 v13, 3, v13
		v_accvgpr_write_b32 a94, v13
		v_accvgpr_read_b32 v13, a94
		v_lshlrev_b32_e32 v13, 3, v13
		v_accvgpr_write_b32 a95, v13
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
		v_lshlrev_b32_e32 v13, 2, v24
		v_lshlrev_b32_e32 v20, 2, v20
		s_cmp_lt_i32 0, s46
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
		s_add_i32 s45, s37, 0x80
		s_lshr_b32 s54, s37, 7
		s_and_b32 s55, s54, 1
		s_mul_i32 s57, 0x4100, s55
		v_accvgpr_read_b32 v24, a86
		v_accvgpr_read_b32 v25, a87
		v_add3_u32 v24, s57, v24, v25
		v_accvgpr_read_b32 v25, a88
		v_accvgpr_read_b32 v31, a89
		v_add3_u32 v24, v24, v25, v31
		v_accvgpr_read_b32 v25, a90
		v_accvgpr_read_b32 v31, a91
		v_add3_u32 v24, v24, v25, v31
		ds_read_b128 a[96:99], v24
		ds_read_b128 a[100:103], v24 offset:32
		ds_read_b128 a[104:107], v24 offset:64
		ds_read_b128 a[108:111], v24 offset:96
		ds_read_b128 a[112:115], v24 offset:256
		ds_read_b128 a[116:119], v24 offset:288
		ds_read_b128 a[120:123], v24 offset:320
		ds_read_b128 a[124:127], v24 offset:352
		ds_read_b128 a[128:131], v24 offset:128
		ds_read_b128 a[132:135], v24 offset:160
		ds_read_b128 a[136:139], v24 offset:192
		ds_read_b128 a[140:143], v24 offset:224
		ds_read_b128 v[96:99], v24 offset:384
		ds_read_b128 a[144:147], v24 offset:416
		ds_read_b128 a[148:151], v24 offset:448
		ds_read_b128 a[152:155], v24 offset:480
		s_mul_i32 s55, 0x4400, s55
		v_accvgpr_read_b32 v24, a92
		v_accvgpr_read_b32 v25, a93
		v_add3_u32 v24, s55, v24, v25
		v_accvgpr_read_b32 v25, a95
		v_add3_u32 v24, v24, v30, v25
		ds_read_b64_tr_b16 a[156:157], v24 offset:33264
		ds_read_b64_tr_b16 a[158:159], v24 offset:37616
		ds_read_b64_tr_b16 a[160:161], v24 offset:33392
		ds_read_b64_tr_b16 a[162:163], v24 offset:37744
		ds_read_b64_tr_b16 a[164:165], v24 offset:33520
		ds_read_b64_tr_b16 a[166:167], v24 offset:37872
		ds_read_b64_tr_b16 a[168:169], v24 offset:33648
		ds_read_b64_tr_b16 a[170:171], v24 offset:38000
		ds_read_b64_tr_b16 a[172:173], v24 offset:33776
		ds_read_b64_tr_b16 a[174:175], v24 offset:38128
		ds_read_b64_tr_b16 a[176:177], v24 offset:33904
		ds_read_b64_tr_b16 a[178:179], v24 offset:38256
		ds_read_b64_tr_b16 a[180:181], v24 offset:34032
		ds_read_b64_tr_b16 a[182:183], v24 offset:38384
		ds_read_b64_tr_b16 a[184:185], v24 offset:34160
		ds_read_b64_tr_b16 a[186:187], v24 offset:38512
		ds_read_b64_tr_b16 a[188:189], v24 offset:33328
		ds_read_b64_tr_b16 a[190:191], v24 offset:37680
		ds_read_b64_tr_b16 a[192:193], v24 offset:33456
		ds_read_b64_tr_b16 a[194:195], v24 offset:37808
		ds_read_b64_tr_b16 a[196:197], v24 offset:33584
		ds_read_b64_tr_b16 a[198:199], v24 offset:37936
		ds_read_b64_tr_b16 a[200:201], v24 offset:33712
		ds_read_b64_tr_b16 a[202:203], v24 offset:38064
		ds_read_b64_tr_b16 a[204:205], v24 offset:33840
		ds_read_b64_tr_b16 a[206:207], v24 offset:38192
		ds_read_b64_tr_b16 a[208:209], v24 offset:33968
		ds_read_b64_tr_b16 a[210:211], v24 offset:38320
		ds_read_b64_tr_b16 a[212:213], v24 offset:34096
		ds_read_b64_tr_b16 a[214:215], v24 offset:38448
		ds_read_b64_tr_b16 a[216:217], v24 offset:34224
		ds_read_b64_tr_b16 a[218:219], v24 offset:38576
		v_add_u32_e32 v24, s45, v10
		v_add_u32_e32 v25, s45, v16
		v_add_u32_e32 v31, s45, v17
		v_add_u32_e32 v100, s45, v6
		v_cmp_lt_i32_e64 vcc, v24, s24
		s_mov_b64 s[58:59], vcc
		v_cmp_lt_i32_e64 vcc, v25, s24
		s_mov_b64 s[60:61], vcc
		v_cmp_lt_i32_e64 vcc, v31, s24
		s_mov_b64 s[62:63], vcc
		v_cmp_lt_i32_e64 vcc, v100, s24
		s_mov_b64 s[64:65], vcc
		v_add_u32_e32 v24, s45, v11
		v_add_u32_e32 v25, s45, v18
		v_add_u32_e32 v31, s45, v19
		v_cmp_lt_i32_e64 vcc, v24, s24
		s_mov_b64 s[66:67], vcc
		v_cmp_lt_i32_e64 vcc, v25, s24
		s_mov_b64 s[68:69], vcc
		v_cmp_lt_i32_e64 vcc, v31, s24
		s_mov_b64 s[70:71], vcc
		s_barrier
		s_mul_i32 s55, s15, s37
		s_lshl_b32 s55, s55, 1
		s_add_i32 s57, s47, s55
		v_add_u32_e32 v24, s57, v8
		v_cndmask_b32_e64 v24, v9, v24, s[58:59]
		s_add_i32 s54, s54, 1
		s_and_b32 s54, s54, 1
		s_mul_i32 s57, 0x4100, s54
		s_add_i32 s57, s39, s57
		s_mov_b32 m0, s57
		v_add_u32_e32 v25, s45, v7
		buffer_load_dwordx4 v24, s[28:31], 0 offen lds
		v_add_u32_e32 v24, s55, v8
		v_add_u32_e32 v31, s48, v24
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v31, v9, v31, s[60:61]
		buffer_load_dwordx4 v31, s[28:31], 0 offen lds
		v_add_u32_e32 v31, s49, v24
		s_add_i32 m0, s57, 0x2080
		v_cndmask_b32_e64 v31, v9, v31, s[62:63]
		buffer_load_dwordx4 v31, s[28:31], 0 offen lds
		v_add_u32_e32 v24, s50, v24
		s_add_i32 m0, s57, 0x30c0
		v_cndmask_b32_e64 v24, v9, v24, s[64:65]
		buffer_load_dwordx4 v24, s[28:31], 0 offen lds
		s_barrier
		s_mul_i32 s37, s21, s37
		s_lshl_b32 s37, s37, 1
		s_add_i32 s55, s51, s37
		v_add_u32_e32 v24, s55, v14
		s_mul_i32 s54, 0x4400, s54
		s_add_i32 s54, s38, s54
		s_add_i32 m0, s54, 0x81f0
		v_cndmask_b32_e64 v24, v9, v24, s[66:67]
		buffer_load_dwordx4 v24, s[32:35], 0 offen lds
		v_add_u32_e32 v24, s37, v14
		v_add_u32_e32 v31, s52, v24
		s_add_i32 m0, s54, 0x92f0
		v_cndmask_b32_e64 v31, v9, v31, s[68:69]
		buffer_load_dwordx4 v31, s[32:35], 0 offen lds
		v_add_u32_e32 v31, s53, v24
		s_add_i32 m0, s54, 0xa3f0
		v_cndmask_b32_e64 v31, v9, v31, s[70:71]
		buffer_load_dwordx4 v31, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v25, s24
		v_add_u32_e32 v24, s44, v24
		v_mov_b32_e32 v25, v29
		v_accvgpr_write_b32 a221, v25
		v_cndmask_b32_e32 v24, v9, v24, vcc
		s_add_i32 m0, s54, 0xb4f0
		v_mov_b32_e32 v25, v28
		v_accvgpr_write_b32 a220, v25
		buffer_load_dwordx4 v24, s[32:35], 0 offen lds
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[112:127], a[96:99], a[40:43], 0
		v_mfma_f32_32x32x16_bf16 v[128:143], a[112:115], a[40:43], 0
		v_mfma_f32_32x32x16_bf16 v[144:159], a[128:131], a[40:43], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], a[40:43], 0
		v_mfma_f32_32x32x16_bf16 v[176:191], v[96:99], a[64:67], 0
		v_mfma_f32_32x32x16_bf16 v[96:111], a[96:99], a[64:67], 0
		v_mfma_f32_32x32x16_bf16 v[192:207], a[112:115], a[64:67], 0
		v_mfma_f32_32x32x16_bf16 v[208:223], a[128:131], a[64:67], 0
		v_mfma_f32_32x32x16_bf16 v[112:127], a[100:103], a[44:47], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[116:119], a[44:47], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[132:135], a[44:47], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[144:147], a[44:47], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[144:147], a[68:71], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[100:103], a[68:71], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[116:119], a[68:71], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[132:135], a[68:71], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[104:107], a[52:55], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[120:123], a[52:55], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[136:139], a[52:55], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[148:151], a[52:55], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[148:151], a[72:75], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[104:107], a[72:75], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[120:123], a[72:75], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[136:139], a[72:75], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[108:111], a[56:59], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[124:127], a[56:59], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[140:143], a[56:59], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[152:155], a[56:59], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[152:155], a[76:79], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[108:111], a[76:79], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[124:127], a[76:79], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[140:143], a[76:79], v[208:223]
		s_nop 4
		v_max_f32_e32 v24, v112, v113
		v_max_f32_e32 v25, v114, v115
		v_max_f32_e32 v28, v116, v117
		v_max_f32_e32 v29, v118, v119
		v_max_f32_e32 v31, v120, v121
		v_max_f32_e32 v224, v122, v123
		v_max_f32_e32 v225, v124, v125
		v_max_f32_e32 v226, v126, v127
		v_max_f32_e32 v227, v128, v129
		v_max_f32_e32 v228, v130, v131
		v_max_f32_e32 v229, v132, v133
		v_max_f32_e32 v230, v134, v135
		v_max_f32_e32 v231, v136, v137
		v_max_f32_e32 v232, v138, v139
		v_max_f32_e32 v233, v140, v141
		v_max_f32_e32 v234, v142, v143
		v_max_f32_e32 v235, v144, v145
		v_max_f32_e32 v236, v146, v147
		v_max_f32_e32 v237, v148, v149
		v_max_f32_e32 v238, v150, v151
		v_max_f32_e32 v239, v152, v153
		v_max_f32_e32 v240, v154, v155
		v_max_f32_e32 v241, v156, v157
		v_max_f32_e32 v242, v158, v159
		v_max_f32_e32 v243, v160, v161
		v_max_f32_e32 v244, v162, v163
		v_max_f32_e32 v245, v164, v165
		v_accvgpr_write_b32 a96, v245
		v_max_f32_e32 v245, v166, v167
		v_accvgpr_write_b32 a97, v245
		v_max_f32_e32 v245, v168, v169
		v_accvgpr_write_b32 a98, v245
		v_max_f32_e32 v245, v170, v171
		v_accvgpr_write_b32 a99, v245
		v_max_f32_e32 v245, v172, v173
		v_accvgpr_write_b32 a100, v245
		v_max_f32_e32 v245, v174, v175
		v_max_f32_e32 v24, v24, v25
		v_max_f32_e32 v25, v28, v29
		v_max_f32_e32 v28, v31, v224
		v_max_f32_e32 v29, v225, v226
		v_max_f32_e32 v31, v227, v228
		v_max_f32_e32 v224, v229, v230
		v_max_f32_e32 v225, v231, v232
		v_max_f32_e32 v226, v233, v234
		v_max_f32_e32 v227, v235, v236
		v_max_f32_e32 v228, v237, v238
		v_max_f32_e32 v229, v239, v240
		v_max_f32_e32 v230, v241, v242
		v_max_f32_e32 v231, v243, v244
		v_accvgpr_read_b32 v232, a96
		v_accvgpr_read_b32 v233, a97
		v_max_f32_e32 v232, v232, v233
		v_accvgpr_read_b32 v233, a98
		v_accvgpr_read_b32 v234, a99
		v_max_f32_e32 v233, v233, v234
		v_accvgpr_read_b32 v234, a100
		v_max_f32_e32 v234, v234, v245
		v_max_f32_e32 v24, v24, v25
		v_max_f32_e32 v25, v28, v29
		v_max_f32_e32 v28, v31, v224
		v_max_f32_e32 v29, v225, v226
		v_max_f32_e32 v31, v227, v228
		v_max_f32_e32 v224, v229, v230
		v_max_f32_e32 v225, v231, v232
		v_max_f32_e32 v226, v233, v234
		v_max_f32_e32 v24, v24, v25
		v_max_f32_e32 v25, v28, v29
		v_max_f32_e32 v28, v31, v224
		v_max_f32_e32 v29, v225, v226
		v_max_f32_e32 v24, v24, v25
		v_max_f32_e32 v25, v28, v29
		v_max_f32_e32 v24, v24, v25
		ds_bpermute_b32 v25, v13, v24
		ds_bpermute_b32 v28, v20, v24
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v224, v25, v28
		v_max_f32_e32 v24, v96, v97
		v_max_f32_e32 v25, v98, v99
		v_max_f32_e32 v28, v100, v101
		v_max_f32_e32 v29, v102, v103
		v_max_f32_e32 v31, v104, v105
		v_max_f32_e32 v225, v106, v107
		v_max_f32_e32 v226, v108, v109
		v_max_f32_e32 v227, v110, v111
		v_max_f32_e32 v228, v192, v193
		v_max_f32_e32 v229, v194, v195
		v_max_f32_e32 v230, v196, v197
		v_max_f32_e32 v231, v198, v199
		v_max_f32_e32 v232, v200, v201
		v_max_f32_e32 v233, v202, v203
		v_max_f32_e32 v234, v204, v205
		v_max_f32_e32 v235, v206, v207
		v_max_f32_e32 v236, v208, v209
		v_max_f32_e32 v237, v210, v211
		v_max_f32_e32 v238, v212, v213
		v_max_f32_e32 v239, v214, v215
		v_max_f32_e32 v240, v216, v217
		v_max_f32_e32 v241, v218, v219
		v_max_f32_e32 v242, v220, v221
		v_max_f32_e32 v243, v222, v223
		v_max_f32_e32 v244, v176, v177
		v_accvgpr_write_b32 a96, v244
		v_max_f32_e32 v244, v178, v179
		v_max_f32_e32 v245, v180, v181
		v_accvgpr_write_b32 a97, v245
		v_max_f32_e32 v245, v182, v183
		v_accvgpr_write_b32 a98, v245
		v_max_f32_e32 v245, v184, v185
		v_accvgpr_write_b32 a99, v245
		v_max_f32_e32 v245, v186, v187
		v_accvgpr_write_b32 a100, v245
		v_max_f32_e32 v245, v188, v189
		v_accvgpr_write_b32 a101, v245
		v_max_f32_e32 v245, v190, v191
		v_max_f32_e32 v24, v24, v25
		v_max_f32_e32 v25, v28, v29
		v_max_f32_e32 v28, v31, v225
		v_max_f32_e32 v29, v226, v227
		v_max_f32_e32 v31, v228, v229
		v_max_f32_e32 v225, v230, v231
		v_max_f32_e32 v226, v232, v233
		v_max_f32_e32 v227, v234, v235
		v_max_f32_e32 v228, v236, v237
		v_max_f32_e32 v229, v238, v239
		v_max_f32_e32 v230, v240, v241
		v_max_f32_e32 v231, v242, v243
		v_accvgpr_read_b32 v232, a96
		v_max_f32_e32 v232, v232, v244
		v_accvgpr_read_b32 v233, a97
		v_accvgpr_read_b32 v234, a98
		v_max_f32_e32 v233, v233, v234
		v_accvgpr_read_b32 v234, a99
		v_accvgpr_read_b32 v235, a100
		v_max_f32_e32 v234, v234, v235
		v_accvgpr_read_b32 v235, a101
		v_max_f32_e32 v235, v235, v245
		v_max_f32_e32 v24, v24, v25
		v_max_f32_e32 v25, v28, v29
		v_max_f32_e32 v28, v31, v225
		v_max_f32_e32 v29, v226, v227
		v_max_f32_e32 v31, v228, v229
		v_max_f32_e32 v225, v230, v231
		v_max_f32_e32 v226, v232, v233
		v_max_f32_e32 v227, v234, v235
		v_max_f32_e32 v24, v24, v25
		v_max_f32_e32 v25, v28, v29
		v_max_f32_e32 v28, v31, v225
		v_max_f32_e32 v29, v226, v227
		v_max_f32_e32 v24, v24, v25
		v_max_f32_e32 v25, v28, v29
		v_max_f32_e32 v24, v24, v25
		ds_bpermute_b32 v25, v13, v24
		ds_bpermute_b32 v28, v20, v24
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v225, v25, v28
		v_pk_mul_f32 v[24:25], v[224:225], v[26:27]
		v_max_f32_e32 v24, v23, v24
		v_max_f32_e32 v25, v21, v25
		v_pk_mul_f32 v[28:29], v[112:113], v[26:27]
		v_pk_mul_f32 v[112:113], v[114:115], v[26:27]
		v_pk_mul_f32 v[114:115], v[116:117], v[26:27]
		v_pk_mul_f32 v[116:117], v[118:119], v[26:27]
		v_pk_mul_f32 v[118:119], v[120:121], v[26:27]
		v_pk_mul_f32 v[120:121], v[122:123], v[26:27]
		v_pk_mul_f32 v[122:123], v[124:125], v[26:27]
		v_pk_mul_f32 v[124:125], v[126:127], v[26:27]
		v_pk_mul_f32 v[126:127], v[128:129], v[26:27]
		v_pk_mul_f32 v[128:129], v[130:131], v[26:27]
		v_pk_mul_f32 v[130:131], v[132:133], v[26:27]
		v_pk_mul_f32 v[132:133], v[134:135], v[26:27]
		v_pk_mul_f32 v[134:135], v[136:137], v[26:27]
		v_pk_mul_f32 v[136:137], v[138:139], v[26:27]
		v_pk_mul_f32 v[138:139], v[140:141], v[26:27]
		v_pk_mul_f32 v[140:141], v[142:143], v[26:27]
		v_pk_mul_f32 v[142:143], v[144:145], v[26:27]
		v_pk_mul_f32 v[144:145], v[146:147], v[26:27]
		v_pk_mul_f32 v[146:147], v[148:149], v[26:27]
		v_pk_mul_f32 v[148:149], v[150:151], v[26:27]
		v_pk_mul_f32 v[150:151], v[152:153], v[26:27]
		v_pk_mul_f32 v[152:153], v[154:155], v[26:27]
		v_pk_mul_f32 v[154:155], v[156:157], v[26:27]
		v_pk_mul_f32 v[156:157], v[158:159], v[26:27]
		v_pk_mul_f32 v[158:159], v[160:161], v[26:27]
		v_pk_mul_f32 v[160:161], v[162:163], v[26:27]
		v_pk_mul_f32 v[162:163], v[164:165], v[26:27]
		v_pk_mul_f32 v[164:165], v[166:167], v[26:27]
		v_pk_mul_f32 v[166:167], v[168:169], v[26:27]
		v_pk_mul_f32 v[168:169], v[170:171], v[26:27]
		v_pk_mul_f32 v[170:171], v[172:173], v[26:27]
		v_pk_mul_f32 v[172:173], v[174:175], v[26:27]
		v_pk_mul_f32 v[174:175], v[96:97], v[26:27]
		v_pk_mul_f32 v[96:97], v[98:99], v[26:27]
		v_pk_mul_f32 v[98:99], v[100:101], v[26:27]
		v_pk_mul_f32 v[100:101], v[102:103], v[26:27]
		v_pk_mul_f32 v[102:103], v[104:105], v[26:27]
		v_pk_mul_f32 v[104:105], v[106:107], v[26:27]
		v_pk_mul_f32 v[106:107], v[108:109], v[26:27]
		v_pk_mul_f32 v[108:109], v[110:111], v[26:27]
		v_pk_mul_f32 v[110:111], v[192:193], v[26:27]
		v_pk_mul_f32 v[192:193], v[194:195], v[26:27]
		v_pk_mul_f32 v[194:195], v[196:197], v[26:27]
		v_pk_mul_f32 v[196:197], v[198:199], v[26:27]
		v_pk_mul_f32 v[198:199], v[200:201], v[26:27]
		v_pk_mul_f32 v[200:201], v[202:203], v[26:27]
		v_pk_mul_f32 v[202:203], v[204:205], v[26:27]
		v_pk_mul_f32 v[204:205], v[206:207], v[26:27]
		v_pk_mul_f32 v[206:207], v[208:209], v[26:27]
		v_pk_mul_f32 v[208:209], v[210:211], v[26:27]
		v_pk_mul_f32 v[210:211], v[212:213], v[26:27]
		v_pk_mul_f32 v[212:213], v[214:215], v[26:27]
		v_pk_mul_f32 v[214:215], v[216:217], v[26:27]
		v_pk_mul_f32 v[216:217], v[218:219], v[26:27]
		v_pk_mul_f32 v[218:219], v[220:221], v[26:27]
		v_pk_mul_f32 v[220:221], v[222:223], v[26:27]
		v_pk_mul_f32 v[222:223], v[176:177], v[26:27]
		v_pk_mul_f32 v[176:177], v[178:179], v[26:27]
		v_pk_mul_f32 v[178:179], v[180:181], v[26:27]
		v_pk_mul_f32 v[180:181], v[182:183], v[26:27]
		v_pk_mul_f32 v[182:183], v[184:185], v[26:27]
		v_pk_mul_f32 v[184:185], v[186:187], v[26:27]
		v_pk_mul_f32 v[186:187], v[188:189], v[26:27]
		v_pk_mul_f32 v[188:189], v[190:191], v[26:27]
		v_sub_f32_e32 v28, v28, v24
		v_sub_f32_e32 v29, v29, v24
		v_sub_f32_e32 v31, v112, v24
		v_sub_f32_e32 v112, v113, v24
		v_sub_f32_e32 v113, v114, v24
		v_sub_f32_e32 v114, v115, v24
		v_sub_f32_e32 v115, v116, v24
		v_sub_f32_e32 v116, v117, v24
		v_sub_f32_e32 v117, v118, v24
		v_sub_f32_e32 v118, v119, v24
		v_sub_f32_e32 v119, v120, v24
		v_sub_f32_e32 v120, v121, v24
		v_sub_f32_e32 v121, v122, v24
		v_sub_f32_e32 v122, v123, v24
		v_sub_f32_e32 v123, v124, v24
		v_sub_f32_e32 v124, v125, v24
		v_sub_f32_e32 v125, v126, v24
		v_sub_f32_e32 v126, v127, v24
		v_sub_f32_e32 v127, v128, v24
		v_sub_f32_e32 v128, v129, v24
		v_sub_f32_e32 v129, v130, v24
		v_sub_f32_e32 v130, v131, v24
		v_sub_f32_e32 v131, v132, v24
		v_sub_f32_e32 v132, v133, v24
		v_sub_f32_e32 v133, v134, v24
		v_sub_f32_e32 v134, v135, v24
		v_sub_f32_e32 v135, v136, v24
		v_sub_f32_e32 v136, v137, v24
		v_sub_f32_e32 v137, v138, v24
		v_sub_f32_e32 v138, v139, v24
		v_sub_f32_e32 v139, v140, v24
		v_sub_f32_e32 v140, v141, v24
		v_sub_f32_e32 v141, v142, v24
		v_sub_f32_e32 v142, v143, v24
		v_sub_f32_e32 v143, v144, v24
		v_sub_f32_e32 v144, v145, v24
		v_sub_f32_e32 v145, v146, v24
		v_sub_f32_e32 v146, v147, v24
		v_sub_f32_e32 v147, v148, v24
		v_sub_f32_e32 v148, v149, v24
		v_sub_f32_e32 v149, v150, v24
		v_sub_f32_e32 v150, v151, v24
		v_sub_f32_e32 v151, v152, v24
		v_sub_f32_e32 v152, v153, v24
		v_sub_f32_e32 v153, v154, v24
		v_sub_f32_e32 v154, v155, v24
		v_sub_f32_e32 v155, v156, v24
		v_sub_f32_e32 v156, v157, v24
		v_sub_f32_e32 v157, v158, v24
		v_sub_f32_e32 v158, v159, v24
		v_sub_f32_e32 v159, v160, v24
		v_sub_f32_e32 v160, v161, v24
		v_sub_f32_e32 v161, v162, v24
		v_sub_f32_e32 v162, v163, v24
		v_sub_f32_e32 v163, v164, v24
		v_sub_f32_e32 v164, v165, v24
		v_sub_f32_e32 v165, v166, v24
		v_sub_f32_e32 v166, v167, v24
		v_sub_f32_e32 v167, v168, v24
		v_sub_f32_e32 v168, v169, v24
		v_sub_f32_e32 v169, v170, v24
		v_sub_f32_e32 v170, v171, v24
		v_sub_f32_e32 v171, v172, v24
		v_sub_f32_e32 v172, v173, v24
		v_sub_f32_e32 v173, v174, v25
		v_sub_f32_e32 v174, v175, v25
		v_sub_f32_e32 v96, v96, v25
		v_sub_f32_e32 v97, v97, v25
		v_sub_f32_e32 v98, v98, v25
		v_sub_f32_e32 v99, v99, v25
		v_sub_f32_e32 v100, v100, v25
		v_sub_f32_e32 v101, v101, v25
		v_sub_f32_e32 v102, v102, v25
		v_sub_f32_e32 v103, v103, v25
		v_sub_f32_e32 v104, v104, v25
		v_sub_f32_e32 v105, v105, v25
		v_sub_f32_e32 v106, v106, v25
		v_sub_f32_e32 v107, v107, v25
		v_sub_f32_e32 v108, v108, v25
		v_sub_f32_e32 v109, v109, v25
		v_sub_f32_e32 v110, v110, v25
		v_sub_f32_e32 v111, v111, v25
		v_sub_f32_e32 v175, v192, v25
		v_sub_f32_e32 v190, v193, v25
		v_sub_f32_e32 v191, v194, v25
		v_sub_f32_e32 v192, v195, v25
		v_sub_f32_e32 v193, v196, v25
		v_sub_f32_e32 v194, v197, v25
		v_sub_f32_e32 v195, v198, v25
		v_sub_f32_e32 v196, v199, v25
		v_sub_f32_e32 v197, v200, v25
		v_sub_f32_e32 v198, v201, v25
		v_sub_f32_e32 v199, v202, v25
		v_sub_f32_e32 v200, v203, v25
		v_sub_f32_e32 v201, v204, v25
		v_sub_f32_e32 v202, v205, v25
		v_sub_f32_e32 v203, v206, v25
		v_sub_f32_e32 v204, v207, v25
		v_sub_f32_e32 v205, v208, v25
		v_sub_f32_e32 v206, v209, v25
		v_sub_f32_e32 v207, v210, v25
		v_sub_f32_e32 v208, v211, v25
		v_sub_f32_e32 v209, v212, v25
		v_sub_f32_e32 v210, v213, v25
		v_sub_f32_e32 v211, v214, v25
		v_sub_f32_e32 v212, v215, v25
		v_sub_f32_e32 v213, v216, v25
		v_sub_f32_e32 v214, v217, v25
		v_sub_f32_e32 v215, v218, v25
		v_sub_f32_e32 v216, v219, v25
		v_sub_f32_e32 v217, v220, v25
		v_sub_f32_e32 v218, v221, v25
		v_sub_f32_e32 v219, v222, v25
		v_sub_f32_e32 v220, v223, v25
		v_sub_f32_e32 v176, v176, v25
		v_sub_f32_e32 v177, v177, v25
		v_sub_f32_e32 v178, v178, v25
		v_sub_f32_e32 v179, v179, v25
		v_sub_f32_e32 v180, v180, v25
		v_sub_f32_e32 v181, v181, v25
		v_sub_f32_e32 v182, v182, v25
		v_sub_f32_e32 v183, v183, v25
		v_sub_f32_e32 v184, v184, v25
		v_sub_f32_e32 v185, v185, v25
		v_sub_f32_e32 v186, v186, v25
		v_sub_f32_e32 v187, v187, v25
		v_sub_f32_e32 v188, v188, v25
		v_sub_f32_e32 v189, v189, v25
		v_exp_f32_e32 v222, v28
		v_exp_f32_e32 v224, v29
		v_exp_f32_e32 v223, v31
		v_exp_f32_e32 v225, v112
		v_exp_f32_e32 v226, v113
		v_exp_f32_e32 v112, v114
		v_exp_f32_e32 v227, v115
		v_exp_f32_e32 v113, v116
		v_exp_f32_e32 v114, v117
		v_exp_f32_e32 v116, v118
		v_exp_f32_e32 v115, v119
		v_exp_f32_e32 v117, v120
		v_exp_f32_e32 v118, v121
		v_exp_f32_e32 v120, v122
		v_exp_f32_e32 v119, v123
		v_exp_f32_e32 v121, v124
		v_exp_f32_e32 v122, v125
		v_exp_f32_e32 v124, v126
		v_exp_f32_e32 v123, v127
		v_exp_f32_e32 v125, v128
		v_exp_f32_e32 v126, v129
		v_exp_f32_e32 v128, v130
		v_exp_f32_e32 v127, v131
		v_exp_f32_e32 v129, v132
		v_exp_f32_e32 v130, v133
		v_exp_f32_e32 v132, v134
		v_exp_f32_e32 v131, v135
		v_exp_f32_e32 v133, v136
		v_exp_f32_e32 v134, v137
		v_exp_f32_e32 v136, v138
		v_exp_f32_e32 v135, v139
		v_exp_f32_e32 v137, v140
		v_exp_f32_e32 v138, v141
		v_exp_f32_e32 v140, v142
		v_exp_f32_e32 v139, v143
		v_exp_f32_e32 v141, v144
		v_exp_f32_e32 v142, v145
		v_exp_f32_e32 v144, v146
		v_exp_f32_e32 v143, v147
		v_exp_f32_e32 v145, v148
		v_exp_f32_e32 v146, v149
		v_exp_f32_e32 v148, v150
		v_exp_f32_e32 v147, v151
		v_exp_f32_e32 v149, v152
		v_exp_f32_e32 v150, v153
		v_exp_f32_e32 v152, v154
		v_exp_f32_e32 v151, v155
		v_exp_f32_e32 v153, v156
		v_exp_f32_e32 v154, v157
		v_exp_f32_e32 v156, v158
		v_exp_f32_e32 v155, v159
		v_exp_f32_e32 v157, v160
		v_exp_f32_e32 v158, v161
		v_exp_f32_e32 v160, v162
		v_exp_f32_e32 v159, v163
		v_exp_f32_e32 v161, v164
		v_exp_f32_e32 v162, v165
		v_exp_f32_e32 v164, v166
		v_exp_f32_e32 v163, v167
		v_exp_f32_e32 v165, v168
		v_exp_f32_e32 v166, v169
		v_exp_f32_e32 v168, v170
		v_exp_f32_e32 v167, v171
		v_exp_f32_e32 v169, v172
		v_exp_f32_e32 v171, v173
		v_exp_f32_e32 v173, v174
		v_exp_f32_e32 v228, v96
		v_exp_f32_e32 v230, v97
		v_exp_f32_e32 v229, v98
		v_exp_f32_e32 v231, v99
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
		v_exp_f32_e32 v108, v175
		v_exp_f32_e32 v110, v190
		v_exp_f32_e32 v109, v191
		v_exp_f32_e32 v111, v192
		v_exp_f32_e32 v174, v193
		v_exp_f32_e32 v190, v194
		v_exp_f32_e32 v175, v195
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
		v_exp_f32_e32 v205, v211
		v_exp_f32_e32 v207, v212
		v_exp_f32_e32 v208, v213
		v_exp_f32_e32 v210, v214
		v_exp_f32_e32 v209, v215
		v_exp_f32_e32 v211, v216
		v_exp_f32_e32 v212, v217
		v_exp_f32_e32 v214, v218
		v_exp_f32_e32 v213, v219
		v_exp_f32_e32 v215, v220
		v_exp_f32_e32 v216, v176
		v_exp_f32_e32 v218, v177
		v_exp_f32_e32 v217, v178
		v_exp_f32_e32 v219, v179
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
		v_pk_add_f32 v[28:29], v[222:223], v[224:225]
		v_pk_add_f32 v[188:189], v[226:227], v[112:113]
		v_pk_add_f32 v[220:221], v[114:115], v[116:117]
		v_pk_add_f32 v[232:233], v[118:119], v[120:121]
		v_pk_add_f32 v[234:235], v[122:123], v[124:125]
		v_pk_add_f32 v[236:237], v[126:127], v[128:129]
		v_pk_add_f32 v[238:239], v[130:131], v[132:133]
		v_pk_add_f32 v[240:241], v[134:135], v[136:137]
		v_pk_add_f32 v[242:243], v[138:139], v[140:141]
		v_accvgpr_write_b32 a96, v242
		v_accvgpr_write_b32 a97, v243
		v_pk_add_f32 v[242:243], v[142:143], v[144:145]
		v_accvgpr_write_b32 a98, v242
		v_accvgpr_write_b32 a99, v243
		v_pk_add_f32 v[242:243], v[146:147], v[148:149]
		v_accvgpr_write_b32 a100, v242
		v_accvgpr_write_b32 a101, v243
		v_pk_add_f32 v[242:243], v[150:151], v[152:153]
		v_accvgpr_write_b32 a102, v242
		v_accvgpr_write_b32 a103, v243
		v_pk_add_f32 v[242:243], v[154:155], v[156:157]
		v_accvgpr_write_b32 a104, v242
		v_accvgpr_write_b32 a105, v243
		v_pk_add_f32 v[242:243], v[158:159], v[160:161]
		v_accvgpr_write_b32 a106, v242
		v_accvgpr_write_b32 a107, v243
		v_pk_add_f32 v[242:243], v[162:163], v[164:165]
		v_accvgpr_write_b32 a108, v242
		v_accvgpr_write_b32 a109, v243
		v_pk_add_f32 v[242:243], v[166:167], v[168:169]
		v_accvgpr_write_b32 a110, v242
		v_accvgpr_write_b32 a111, v243
		v_mov_b32_e32 v242, v29
		v_mov_b32_e32 v243, v189
		v_mov_b32_e32 v244, v28
		v_mov_b32_e32 v245, v188
		v_pk_add_f32 v[28:29], v[244:245], v[242:243]
		v_mov_b32_e32 v188, v221
		v_mov_b32_e32 v189, v233
		v_mov_b32_e32 v242, v220
		v_mov_b32_e32 v243, v232
		v_pk_add_f32 v[220:221], v[242:243], v[188:189]
		v_mov_b32_e32 v188, v235
		v_mov_b32_e32 v189, v237
		v_mov_b32_e32 v232, v234
		v_mov_b32_e32 v233, v236
		v_pk_add_f32 v[234:235], v[232:233], v[188:189]
		v_mov_b32_e32 v188, v239
		v_mov_b32_e32 v189, v241
		v_mov_b32_e32 v232, v238
		v_mov_b32_e32 v233, v240
		v_pk_add_f32 v[236:237], v[232:233], v[188:189]
		v_accvgpr_read_b32 v31, a97
		v_mov_b32_e32 v188, v31
		v_accvgpr_read_b32 v31, a99
		v_mov_b32_e32 v189, v31
		v_accvgpr_read_b32 v31, a96
		v_mov_b32_e32 v232, v31
		v_accvgpr_read_b32 v31, a98
		v_mov_b32_e32 v233, v31
		v_pk_add_f32 v[238:239], v[232:233], v[188:189]
		v_accvgpr_read_b32 v31, a101
		v_mov_b32_e32 v188, v31
		v_accvgpr_read_b32 v31, a103
		v_mov_b32_e32 v189, v31
		v_accvgpr_read_b32 v31, a100
		v_mov_b32_e32 v232, v31
		v_accvgpr_read_b32 v31, a102
		v_mov_b32_e32 v233, v31
		v_pk_add_f32 v[240:241], v[232:233], v[188:189]
		v_accvgpr_read_b32 v31, a105
		v_mov_b32_e32 v188, v31
		v_accvgpr_read_b32 v31, a107
		v_mov_b32_e32 v189, v31
		v_accvgpr_read_b32 v31, a104
		v_mov_b32_e32 v232, v31
		v_accvgpr_read_b32 v31, a106
		v_mov_b32_e32 v233, v31
		v_pk_add_f32 v[242:243], v[232:233], v[188:189]
		v_accvgpr_read_b32 v31, a109
		v_mov_b32_e32 v188, v31
		v_accvgpr_read_b32 v31, a111
		v_mov_b32_e32 v189, v31
		v_accvgpr_read_b32 v31, a108
		v_mov_b32_e32 v232, v31
		v_accvgpr_read_b32 v31, a110
		v_mov_b32_e32 v233, v31
		v_pk_add_f32 v[244:245], v[232:233], v[188:189]
		v_mov_b32_e32 v188, v29
		v_mov_b32_e32 v189, v221
		v_mov_b32_e32 v232, v28
		v_mov_b32_e32 v233, v220
		v_pk_add_f32 v[28:29], v[232:233], v[188:189]
		v_mov_b32_e32 v188, v235
		v_mov_b32_e32 v189, v237
		v_mov_b32_e32 v220, v234
		v_mov_b32_e32 v221, v236
		v_pk_add_f32 v[232:233], v[220:221], v[188:189]
		v_mov_b32_e32 v188, v239
		v_mov_b32_e32 v189, v241
		v_mov_b32_e32 v220, v238
		v_mov_b32_e32 v221, v240
		v_pk_add_f32 v[234:235], v[220:221], v[188:189]
		v_mov_b32_e32 v188, v243
		v_mov_b32_e32 v189, v245
		v_mov_b32_e32 v220, v242
		v_mov_b32_e32 v221, v244
		v_pk_add_f32 v[236:237], v[220:221], v[188:189]
		v_mov_b32_e32 v188, v29
		v_mov_b32_e32 v189, v233
		v_mov_b32_e32 v220, v28
		v_mov_b32_e32 v221, v232
		v_pk_add_f32 v[28:29], v[220:221], v[188:189]
		v_mov_b32_e32 v188, v235
		v_mov_b32_e32 v189, v237
		v_mov_b32_e32 v220, v234
		v_mov_b32_e32 v221, v236
		v_pk_add_f32 v[232:233], v[220:221], v[188:189]
		v_mov_b32_e32 v188, v29
		v_mov_b32_e32 v189, v233
		v_mov_b32_e32 v220, v28
		v_mov_b32_e32 v221, v232
		v_pk_add_f32 v[28:29], v[220:221], v[188:189]
		v_add_f32_e32 v28, v28, v29
		ds_bpermute_b32 v170, v13, v28
		ds_bpermute_b32 v172, v20, v28
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[28:29], v[170:171], v[172:173]
		v_pk_add_f32 v[188:189], v[228:229], v[230:231]
		v_pk_add_f32 v[220:221], v[96:97], v[98:99]
		v_accvgpr_write_b32 a96, v220
		v_accvgpr_write_b32 a97, v221
		v_pk_add_f32 v[220:221], v[100:101], v[102:103]
		v_pk_add_f32 v[232:233], v[104:105], v[106:107]
		v_accvgpr_write_b32 a98, v232
		v_accvgpr_write_b32 a99, v233
		v_pk_add_f32 v[232:233], v[108:109], v[110:111]
		v_pk_add_f32 v[234:235], v[174:175], v[190:191]
		v_accvgpr_write_b32 a100, v234
		v_accvgpr_write_b32 a101, v235
		v_pk_add_f32 v[234:235], v[192:193], v[194:195]
		v_pk_add_f32 v[236:237], v[196:197], v[198:199]
		v_accvgpr_write_b32 a102, v236
		v_accvgpr_write_b32 a103, v237
		v_pk_add_f32 v[236:237], v[200:201], v[202:203]
		v_pk_add_f32 v[238:239], v[204:205], v[206:207]
		v_accvgpr_write_b32 a104, v238
		v_accvgpr_write_b32 a105, v239
		v_pk_add_f32 v[238:239], v[208:209], v[210:211]
		v_pk_add_f32 v[240:241], v[212:213], v[214:215]
		v_accvgpr_write_b32 a106, v240
		v_accvgpr_write_b32 a107, v241
		v_pk_add_f32 v[240:241], v[216:217], v[218:219]
		v_pk_add_f32 v[242:243], v[176:177], v[178:179]
		v_accvgpr_write_b32 a108, v242
		v_accvgpr_write_b32 a109, v243
		v_pk_add_f32 v[242:243], v[180:181], v[182:183]
		v_accvgpr_write_b32 a110, v242
		v_accvgpr_write_b32 a111, v243
		v_mov_b32_e32 v187, v188
		v_mov_b32_e32 v185, v29
		v_pk_add_f32 v[242:243], v[184:185], v[186:187]
		v_accvgpr_write_b32 a112, v242
		v_accvgpr_write_b32 a113, v243
		v_mov_b32_e32 v242, v189
		v_mov_b32_e32 v243, v220
		v_accvgpr_read_b32 v188, a96
		v_accvgpr_read_b32 v189, a97
		v_pk_add_f32 v[244:245], v[242:243], v[188:189]
		v_mov_b32_e32 v188, v221
		v_mov_b32_e32 v189, v232
		v_accvgpr_read_b32 v220, a98
		v_accvgpr_read_b32 v221, a99
		v_pk_add_f32 v[188:189], v[188:189], v[220:221]
		v_mov_b32_e32 v220, v233
		v_mov_b32_e32 v221, v234
		v_accvgpr_read_b32 v232, a100
		v_accvgpr_read_b32 v233, a101
		v_pk_add_f32 v[242:243], v[220:221], v[232:233]
		v_mov_b32_e32 v220, v235
		v_mov_b32_e32 v221, v236
		v_accvgpr_read_b32 v232, a102
		v_accvgpr_read_b32 v233, a103
		v_pk_add_f32 v[220:221], v[220:221], v[232:233]
		v_mov_b32_e32 v232, v237
		v_mov_b32_e32 v233, v238
		v_accvgpr_read_b32 v234, a104
		v_accvgpr_read_b32 v235, a105
		v_pk_add_f32 v[236:237], v[232:233], v[234:235]
		v_mov_b32_e32 v232, v239
		v_mov_b32_e32 v233, v240
		v_accvgpr_read_b32 v234, a106
		v_accvgpr_read_b32 v235, a107
		v_pk_add_f32 v[232:233], v[232:233], v[234:235]
		v_mov_b32_e32 v234, v241
		v_accvgpr_read_b32 v29, a110
		v_mov_b32_e32 v235, v29
		v_accvgpr_read_b32 v238, a108
		v_accvgpr_read_b32 v239, a109
		v_pk_add_f32 v[240:241], v[234:235], v[238:239]
		v_accvgpr_read_b32 v29, a111
		v_mov_b32_e32 v234, v29
		v_mov_b32_e32 v235, v244
		v_accvgpr_read_b32 v238, a112
		v_accvgpr_read_b32 v239, a113
		v_pk_add_f32 v[234:235], v[234:235], v[238:239]
		v_mov_b32_e32 v238, v245
		v_mov_b32_e32 v239, v242
		v_pk_add_f32 v[244:245], v[238:239], v[188:189]
		v_mov_b32_e32 v188, v243
		v_mov_b32_e32 v189, v236
		v_pk_add_f32 v[188:189], v[188:189], v[220:221]
		v_mov_b32_e32 v220, v237
		v_mov_b32_e32 v221, v240
		v_pk_add_f32 v[236:237], v[220:221], v[232:233]
		v_mov_b32_e32 v220, v241
		v_mov_b32_e32 v221, v244
		v_pk_add_f32 v[220:221], v[220:221], v[234:235]
		v_mov_b32_e32 v232, v245
		v_mov_b32_e32 v233, v236
		v_pk_add_f32 v[234:235], v[232:233], v[188:189]
		v_mov_b32_e32 v188, v237
		v_mov_b32_e32 v189, v234
		v_pk_add_f32 v[232:233], v[188:189], v[220:221]
		v_add_f32_e32 v29, v235, v232
		v_add_f32_e32 v29, v233, v29
		ds_bpermute_b32 v31, v13, v29
		ds_bpermute_b32 v170, v20, v29
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v189, v31, v170
		v_sub_f32_e32 v23, v23, v24
		v_sub_f32_e32 v21, v21, v25
		v_exp_f32_e32 v220, v23
		v_exp_f32_e32 v232, v21
		v_mov_b32_e32 v221, v220
		v_pk_mul_f32 v[32:33], v[32:33], v[220:221]
		v_pk_mul_f32 v[34:35], v[34:35], v[220:221]
		v_pk_mul_f32 v[36:37], v[36:37], v[220:221]
		v_pk_mul_f32 v[38:39], v[38:39], v[220:221]
		v_pk_mul_f32 v[40:41], v[40:41], v[220:221]
		v_pk_mul_f32 v[42:43], v[42:43], v[220:221]
		v_pk_mul_f32 v[44:45], v[44:45], v[220:221]
		v_pk_mul_f32 v[46:47], v[46:47], v[220:221]
		v_pk_mul_f32 v[48:49], v[48:49], v[220:221]
		v_pk_mul_f32 v[50:51], v[50:51], v[220:221]
		v_pk_mul_f32 v[52:53], v[52:53], v[220:221]
		v_pk_mul_f32 v[54:55], v[54:55], v[220:221]
		v_pk_mul_f32 v[56:57], v[56:57], v[220:221]
		v_pk_mul_f32 v[58:59], v[58:59], v[220:221]
		v_pk_mul_f32 v[60:61], v[60:61], v[220:221]
		v_pk_mul_f32 v[62:63], v[62:63], v[220:221]
		v_mov_b32_e32 v233, v232
		v_pk_mul_f32 v[64:65], v[64:65], v[232:233]
		v_pk_mul_f32 v[66:67], v[66:67], v[232:233]
		v_pk_mul_f32 v[68:69], v[68:69], v[232:233]
		v_pk_mul_f32 v[70:71], v[70:71], v[232:233]
		v_pk_mul_f32 v[72:73], v[72:73], v[232:233]
		v_pk_mul_f32 v[74:75], v[74:75], v[232:233]
		v_pk_mul_f32 v[76:77], v[76:77], v[232:233]
		v_pk_mul_f32 v[78:79], v[78:79], v[232:233]
		v_pk_mul_f32 v[80:81], v[80:81], v[232:233]
		v_pk_mul_f32 v[82:83], v[82:83], v[232:233]
		v_pk_mul_f32 v[84:85], v[84:85], v[232:233]
		v_pk_mul_f32 v[86:87], v[86:87], v[232:233]
		v_pk_mul_f32 v[88:89], v[88:89], v[232:233]
		v_pk_mul_f32 v[90:91], v[90:91], v[232:233]
		v_pk_mul_f32 v[92:93], v[92:93], v[232:233]
		v_pk_mul_f32 v[94:95], v[94:95], v[232:233]
		v_mov_b32_e32 v188, v28
		v_mov_b32_e32 v234, v220
		v_mov_b32_e32 v235, v232
		v_accvgpr_read_b32 v28, a220
		v_accvgpr_read_b32 v29, a221
		v_pk_fma_f32 v[28:29], v[28:29], v[234:235], v[188:189]
		v_cvt_pk_bf16_f32 v232, v222, v224
		v_cvt_pk_bf16_f32 v233, v223, v225
		v_cvt_pk_bf16_f32 v234, v226, v112
		v_cvt_pk_bf16_f32 v235, v227, v113
		v_cvt_pk_bf16_f32 v220, v114, v116
		v_cvt_pk_bf16_f32 v221, v115, v117
		v_cvt_pk_bf16_f32 v222, v118, v120
		v_cvt_pk_bf16_f32 v223, v119, v121
		v_cvt_pk_bf16_f32 v112, v122, v124
		v_cvt_pk_bf16_f32 v113, v123, v125
		v_cvt_pk_bf16_f32 v114, v126, v128
		v_cvt_pk_bf16_f32 v115, v127, v129
		v_cvt_pk_bf16_f32 v116, v130, v132
		v_cvt_pk_bf16_f32 v117, v131, v133
		v_cvt_pk_bf16_f32 v118, v134, v136
		v_cvt_pk_bf16_f32 v119, v135, v137
		v_cvt_pk_bf16_f32 v120, v138, v140
		v_cvt_pk_bf16_f32 v121, v139, v141
		v_cvt_pk_bf16_f32 v122, v142, v144
		v_cvt_pk_bf16_f32 v123, v143, v145
		v_cvt_pk_bf16_f32 v124, v146, v148
		v_cvt_pk_bf16_f32 v125, v147, v149
		v_cvt_pk_bf16_f32 v126, v150, v152
		v_cvt_pk_bf16_f32 v127, v151, v153
		v_cvt_pk_bf16_f32 v128, v154, v156
		v_cvt_pk_bf16_f32 v129, v155, v157
		v_cvt_pk_bf16_f32 v130, v158, v160
		v_cvt_pk_bf16_f32 v131, v159, v161
		v_cvt_pk_bf16_f32 v132, v162, v164
		v_cvt_pk_bf16_f32 v133, v163, v165
		v_cvt_pk_bf16_f32 v134, v166, v168
		v_cvt_pk_bf16_f32 v135, v167, v169
		v_cvt_pk_bf16_f32 v136, v171, v173
		v_cvt_pk_bf16_f32 v137, v228, v230
		v_cvt_pk_bf16_f32 v138, v229, v231
		v_cvt_pk_bf16_f32 v139, v96, v98
		v_cvt_pk_bf16_f32 v140, v97, v99
		v_cvt_pk_bf16_f32 v141, v100, v102
		v_cvt_pk_bf16_f32 v142, v101, v103
		v_cvt_pk_bf16_f32 v143, v104, v106
		v_cvt_pk_bf16_f32 v96, v105, v107
		v_cvt_pk_bf16_f32 v97, v108, v110
		v_cvt_pk_bf16_f32 v98, v109, v111
		v_cvt_pk_bf16_f32 v99, v174, v190
		v_cvt_pk_bf16_f32 v100, v175, v191
		v_cvt_pk_bf16_f32 v101, v192, v194
		v_cvt_pk_bf16_f32 v102, v193, v195
		v_cvt_pk_bf16_f32 v103, v196, v198
		v_cvt_pk_bf16_f32 v104, v197, v199
		v_cvt_pk_bf16_f32 v105, v200, v202
		v_cvt_pk_bf16_f32 v106, v201, v203
		v_cvt_pk_bf16_f32 v107, v204, v206
		v_cvt_pk_bf16_f32 v108, v205, v207
		v_cvt_pk_bf16_f32 v109, v208, v210
		v_cvt_pk_bf16_f32 v110, v209, v211
		v_cvt_pk_bf16_f32 v111, v212, v214
		v_cvt_pk_bf16_f32 v144, v213, v215
		v_cvt_pk_bf16_f32 v145, v216, v218
		v_cvt_pk_bf16_f32 v146, v217, v219
		v_cvt_pk_bf16_f32 v147, v176, v178
		v_cvt_pk_bf16_f32 v148, v177, v179
		v_cvt_pk_bf16_f32 v149, v180, v182
		v_cvt_pk_bf16_f32 v150, v181, v183
		v_cvt_pk_bf16_f32 v151, v184, v186
		v_permlane32_swap_b32_e32 v232, v234
		v_permlane32_swap_b32_e32 v233, v235
		v_permlane32_swap_b32_e32 v220, v222
		v_permlane32_swap_b32_e32 v221, v223
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
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_permlane32_swap_b32_e32 v148, v150
		v_permlane32_swap_b32_e32 v149, v151
		v_mfma_f32_32x32x16_bf16 v[32:47], a[156:159], v[232:235], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[188:191], v[232:235], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[188:191], v[136:139], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[156:159], v[136:139], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[160:163], v[220:223], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[192:195], v[220:223], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[192:195], v[140:143], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[160:163], v[140:143], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[164:167], v[112:115], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[196:199], v[112:115], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[196:199], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[164:167], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[168:171], v[116:119], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[200:203], v[116:119], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[200:203], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[168:171], v[100:103], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[172:175], v[120:123], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[204:207], v[120:123], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[204:207], v[104:107], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[172:175], v[104:107], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[176:179], v[124:127], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[208:211], v[124:127], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[208:211], v[108:111], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[176:179], v[108:111], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[180:183], v[128:131], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[212:215], v[128:131], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[212:215], v[144:147], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[180:183], v[144:147], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[184:187], v[132:135], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[216:219], v[132:135], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[216:219], v[148:151], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[184:187], v[148:151], v[64:79]
		s_cmp_lt_i32 s45, s46
		s_mov_b32 s37, s45
		v_mov_b32_e32 v23, v24
		v_mov_b32_e32 v21, v25
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_1
.L_attn_fwd_persistent.loop_exit_1:
		s_mul_i32 s27, s27, 0x80
		v_accvgpr_read_b32 v13, a1
		v_readfirstlane_b32 s37, v3
		s_nop 1
		v_add_u32_e32 v13, s37, v13
		v_accvgpr_write_b32 a96, v13
		v_accvgpr_read_b32 v13, a96
		v_add_u32_e32 v13, s22, v13
		v_accvgpr_read_b32 v20, a2
		v_readfirstlane_b32 s37, v3
		s_nop 1
		v_add_u32_e32 v20, s37, v20
		v_accvgpr_write_b32 a97, v20
		v_accvgpr_read_b32 v20, a97
		v_add_u32_e32 v20, s22, v20
		v_xor_b32_e32 v24, 1, v12
		v_accvgpr_write_b32 a98, v24
		v_xor_b32_e32 v24, 2, v12
		v_accvgpr_write_b32 a99, v24
		v_xor_b32_e32 v24, 3, v12
		v_accvgpr_write_b32 a100, v24
		v_xor_b32_e32 v24, 8, v12
		v_accvgpr_write_b32 a101, v24
		v_xor_b32_e32 v24, 9, v12
		v_accvgpr_write_b32 a102, v24
		v_xor_b32_e32 v24, 10, v12
		v_accvgpr_write_b32 a103, v24
		v_xor_b32_e32 v24, 11, v12
		v_accvgpr_write_b32 a104, v24
		v_xor_b32_e32 v24, 16, v12
		v_accvgpr_write_b32 a105, v24
		v_xor_b32_e32 v24, 17, v12
		v_accvgpr_write_b32 a106, v24
		v_xor_b32_e32 v24, 18, v12
		v_accvgpr_write_b32 a107, v24
		v_xor_b32_e32 v24, 19, v12
		v_accvgpr_write_b32 a108, v24
		v_xor_b32_e32 v24, 24, v12
		v_accvgpr_write_b32 a109, v24
		v_xor_b32_e32 v24, 25, v12
		v_accvgpr_write_b32 a110, v24
		v_xor_b32_e32 v24, 26, v12
		v_accvgpr_write_b32 a111, v24
		v_xor_b32_e32 v24, 27, v12
		v_accvgpr_write_b32 a112, v24
		v_xor_b32_e32 v24, 32, v12
		v_accvgpr_write_b32 a113, v24
		v_xor_b32_e32 v24, 33, v12
		v_accvgpr_write_b32 a114, v24
		v_xor_b32_e32 v24, 34, v12
		v_accvgpr_write_b32 a115, v24
		v_xor_b32_e32 v24, 35, v12
		v_accvgpr_write_b32 a116, v24
		v_xor_b32_e32 v24, 40, v12
		v_accvgpr_write_b32 a117, v24
		v_xor_b32_e32 v24, 41, v12
		v_accvgpr_write_b32 a118, v24
		v_xor_b32_e32 v24, 42, v12
		v_accvgpr_write_b32 a119, v24
		v_xor_b32_e32 v24, 43, v12
		v_accvgpr_write_b32 a120, v24
		v_xor_b32_e32 v24, 48, v12
		v_accvgpr_write_b32 a121, v24
		v_xor_b32_e32 v24, 49, v12
		v_accvgpr_write_b32 a122, v24
		v_xor_b32_e32 v24, 50, v12
		v_accvgpr_write_b32 a123, v24
		v_xor_b32_e32 v24, 51, v12
		v_accvgpr_write_b32 a124, v24
		v_xor_b32_e32 v24, 56, v12
		v_accvgpr_write_b32 a125, v24
		v_xor_b32_e32 v24, 57, v12
		v_accvgpr_write_b32 a126, v24
		v_xor_b32_e32 v24, 58, v12
		v_accvgpr_write_b32 a127, v24
		v_xor_b32_e32 v24, 59, v12
		v_accvgpr_write_b32 a128, v24
		v_xor_b32_e32 v24, 64, v12
		v_accvgpr_write_b32 a129, v24
		v_xor_b32_e32 v24, 0x41, v12
		v_accvgpr_write_b32 a130, v24
		v_xor_b32_e32 v24, 0x42, v12
		v_accvgpr_write_b32 a131, v24
		v_xor_b32_e32 v24, 0x4a, v12
		v_xor_b32_e32 v25, 0x4b, v12
		v_xor_b32_e32 v26, 0x52, v12
		v_xor_b32_e32 v27, 0x53, v12
		v_xor_b32_e32 v31, 0x5a, v12
		v_xor_b32_e32 v96, 0x5b, v12
		v_xor_b32_e32 v97, 0x62, v12
		v_xor_b32_e32 v98, 0x63, v12
		v_xor_b32_e32 v99, 0x6a, v12
		v_xor_b32_e32 v100, 0x6b, v12
		v_xor_b32_e32 v101, 0x72, v12
		v_xor_b32_e32 v102, 0x73, v12
		v_xor_b32_e32 v103, 0x7a, v12
		v_xor_b32_e32 v12, 0x7b, v12
		v_accvgpr_read_b32 v104, a34
		v_accvgpr_read_b32 v105, a87
		v_lshl_add_u32 v104, v104, 4, v105
		v_accvgpr_read_b32 v105, a88
		v_accvgpr_read_b32 v106, a89
		v_add3_u32 v104, v104, v105, v106
		v_accvgpr_read_b32 v105, a90
		v_accvgpr_read_b32 v106, a91
		v_add3_u32 v104, v104, v105, v106
		v_accvgpr_write_b32 a34, v104
		v_accvgpr_read_b32 v104, a92
		v_accvgpr_read_b32 v105, a93
		v_add3_u32 v30, v104, v105, v30
		v_accvgpr_read_b32 v104, a94
		v_lshl_add_u32 v30, v104, 3, v30
		v_accvgpr_write_b32 a94, v30
		s_cmp_lt_i32 s46, s27
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_2
.L_attn_fwd_persistent.loop_head_2:
		s_mov_b32 m0, s17
		s_nop 0
		ds_write_addtid_b32 v29 offset:29696
		s_mov_b32 m0, s17
		s_nop 0
		ds_write_addtid_b32 v28 offset:28672
		s_mov_b32 m0, s18
		s_nop 0
		ds_write_addtid_b32 v21 offset:19456
		s_mov_b32 m0, s18
		s_nop 0
		ds_write_addtid_b32 v23 offset:18432
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s22, s46, 0x80
		s_cmp_lt_i32 s46, 0
		s_cselect_b32 s37, s36, 0
		s_add_i32 s37, s46, s37
		s_ashr_i32 s37, s37, 7
		s_cmp_lt_i32 s37, 0
		s_cselect_b32 s38, s16, 0
		s_add_i32 s38, s37, s38
		s_ashr_i32 s38, s38, 1
		s_lshl_b32 s38, s38, 1
		s_xor_b32 s38, s38, -1
		s_add_i32 s38, s38, 1
		s_add_i32 s38, s37, s38
		s_add_i32 s37, s37, 1
		s_cmp_lt_i32 s37, 0
		s_cselect_b32 s39, s16, 0
		s_add_i32 s39, s37, s39
		s_ashr_i32 s39, s39, 1
		s_lshl_b32 s39, s39, 1
		s_xor_b32 s39, s39, -1
		s_add_i32 s39, s39, 1
		s_add_i32 s54, s37, s39
		s_mul_i32 s37, 0x4100, s38
		v_accvgpr_read_b32 v21, a34
		v_add_u32_e32 v21, s37, v21
		ds_read_b128 a[132:135], v21
		ds_read_b128 a[136:139], v21 offset:32
		ds_read_b128 a[140:143], v21 offset:64
		ds_read_b128 a[144:147], v21 offset:96
		ds_read_b128 a[148:151], v21 offset:256
		ds_read_b128 a[152:155], v21 offset:288
		ds_read_b128 a[156:159], v21 offset:320
		ds_read_b128 a[160:163], v21 offset:352
		ds_read_b128 a[164:167], v21 offset:128
		ds_read_b128 a[168:171], v21 offset:160
		ds_read_b128 a[172:175], v21 offset:192
		ds_read_b128 a[176:179], v21 offset:224
		ds_read_b128 v[104:107], v21 offset:384
		ds_read_b128 a[180:183], v21 offset:416
		ds_read_b128 a[184:187], v21 offset:448
		ds_read_b128 a[188:191], v21 offset:480
		s_mul_i32 s37, 0x4400, s38
		v_accvgpr_read_b32 v21, a94
		v_add_u32_e32 v21, s37, v21
		ds_read_b64_tr_b16 a[192:193], v21 offset:33264
		ds_read_b64_tr_b16 a[194:195], v21 offset:37616
		ds_read_b64_tr_b16 a[196:197], v21 offset:33392
		ds_read_b64_tr_b16 a[198:199], v21 offset:37744
		ds_read_b64_tr_b16 a[200:201], v21 offset:33520
		ds_read_b64_tr_b16 a[202:203], v21 offset:37872
		ds_read_b64_tr_b16 a[204:205], v21 offset:33648
		ds_read_b64_tr_b16 a[206:207], v21 offset:38000
		ds_read_b64_tr_b16 a[208:209], v21 offset:33776
		ds_read_b64_tr_b16 a[210:211], v21 offset:38128
		ds_read_b64_tr_b16 a[212:213], v21 offset:33904
		ds_read_b64_tr_b16 a[214:215], v21 offset:38256
		ds_read_b64_tr_b16 a[216:217], v21 offset:34032
		ds_read_b64_tr_b16 a[218:219], v21 offset:38384
		ds_read_b64_tr_b16 a[220:221], v21 offset:34160
		ds_read_b64_tr_b16 a[222:223], v21 offset:38512
		ds_read_b64_tr_b16 a[224:225], v21 offset:33328
		ds_read_b64_tr_b16 a[226:227], v21 offset:37680
		ds_read_b64_tr_b16 a[228:229], v21 offset:33456
		ds_read_b64_tr_b16 a[230:231], v21 offset:37808
		ds_read_b64_tr_b16 a[232:233], v21 offset:33584
		ds_read_b64_tr_b16 a[234:235], v21 offset:37936
		ds_read_b64_tr_b16 a[236:237], v21 offset:33712
		ds_read_b64_tr_b16 a[238:239], v21 offset:38064
		ds_read_b64_tr_b16 a[240:241], v21 offset:33840
		ds_read_b64_tr_b16 a[242:243], v21 offset:38192
		ds_read_b64_tr_b16 a[244:245], v21 offset:33968
		ds_read_b64_tr_b16 a[246:247], v21 offset:38320
		ds_read_b64_tr_b16 a[248:249], v21 offset:34096
		ds_read_b64_tr_b16 a[250:251], v21 offset:38448
		ds_read_b64_tr_b16 a[252:253], v21 offset:34224
		ds_read_b64_tr_b16 a[254:255], v21 offset:38576
		s_cmp_lt_i32 s22, s26
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_1
		s_waitcnt lgkmcnt(14)
		s_barrier
		v_add_u32_e32 v21, s22, v10
		v_add_u32_e32 v23, s22, v16
		v_add_u32_e32 v28, s22, v17
		v_add_u32_e32 v29, s22, v6
		v_cmp_lt_i32_e64 vcc, v21, s24
		s_mov_b64 s[38:39], vcc
		v_cmp_lt_i32_e64 vcc, v23, s24
		s_mov_b64 s[58:59], vcc
		v_cmp_lt_i32_e64 vcc, v28, s24
		s_mov_b64 s[60:61], vcc
		v_cmp_lt_i32_e64 vcc, v29, s24
		s_mov_b64 s[62:63], vcc
		v_add_u32_e32 v21, s22, v11
		v_add_u32_e32 v23, s22, v18
		v_add_u32_e32 v28, s22, v19
		v_cmp_lt_i32_e64 vcc, v21, s24
		s_mov_b64 s[64:65], vcc
		v_cmp_lt_i32_e64 vcc, v23, s24
		s_mov_b64 s[66:67], vcc
		v_cmp_lt_i32_e64 vcc, v28, s24
		s_mov_b64 s[68:69], vcc
		s_mul_i32 s37, s15, s46
		s_lshl_b32 s37, s37, 1
		s_add_i32 s45, s47, s37
		v_add_u32_e32 v21, s45, v8
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
		v_cndmask_b32_e64 v21, v9, v21, s[38:39]
		buffer_load_dwordx4 v21, s[28:31], 0 offen lds
		v_add_u32_e32 v21, s22, v7
		s_add_i32 s22, s48, s37
		v_add_u32_e32 v23, s22, v8
		s_add_u32 s38, s74, 0x1040
		s_addc_u32 s39, s75, 0
		s_add_u32 s38, s38, s76
		s_addc_u32 s39, s39, s77
		s_add_u32 s72, s38, 0
		s_addc_u32 s73, s39, 0
		s_mov_b32 m0, s72
		v_cndmask_b32_e64 v23, v9, v23, s[58:59]
		buffer_load_dwordx4 v23, s[28:31], 0 offen lds
		s_add_i32 s22, s49, s37
		v_add_u32_e32 v23, s22, v8
		s_add_u32 s38, s74, 0x2080
		s_addc_u32 s39, s75, 0
		s_add_u32 s38, s38, s76
		s_addc_u32 s39, s39, s77
		s_add_u32 s58, s38, 0
		s_addc_u32 s59, s39, 0
		s_mov_b32 m0, s58
		v_cndmask_b32_e64 v23, v9, v23, s[60:61]
		buffer_load_dwordx4 v23, s[28:31], 0 offen lds
		s_add_i32 s22, s50, s37
		v_add_u32_e32 v23, s22, v8
		s_add_u32 s38, s74, 0x30c0
		s_addc_u32 s39, s75, 0
		s_add_u32 s38, s38, s76
		s_addc_u32 s39, s39, s77
		s_add_u32 s58, s38, 0
		s_addc_u32 s59, s39, 0
		s_mov_b32 m0, s58
		v_cndmask_b32_e64 v23, v9, v23, s[62:63]
		buffer_load_dwordx4 v23, s[28:31], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s22, s21, s46
		s_lshl_b32 s22, s22, 1
		s_add_i32 s37, s51, s22
		v_add_u32_e32 v23, s37, v14
		s_mov_b32 s38, 0x440
		s_mov_b32 s39, 0
		s_mul_i32 s58, s38, s70
		s_mul_hi_u32 s59, s38, s70
		s_mul_i32 s37, s38, s71
		s_add_i32 s59, s59, s37
		s_mul_i32 s37, s39, s70
		s_add_i32 s59, s59, s37
		s_add_u32 s38, s58, 0x81f0
		s_addc_u32 s39, s59, 0
		s_mov_b32 s60, 0x4400
		s_mov_b32 s61, 0
		s_mul_i32 s62, s60, s54
		s_mul_hi_u32 s63, s60, s54
		s_mul_i32 s37, s60, s55
		s_add_i32 s63, s63, s37
		s_mul_i32 s37, s61, s54
		s_add_i32 s63, s63, s37
		s_add_u32 s38, s38, s62
		s_addc_u32 s39, s39, s63
		s_add_u32 s54, s38, 0
		s_addc_u32 s55, s39, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v23, v9, v23, s[64:65]
		buffer_load_dwordx4 v23, s[32:35], 0 offen lds
		s_add_i32 s37, s52, s22
		v_add_u32_e32 v23, s37, v14
		s_add_u32 s38, s58, 0x92f0
		s_addc_u32 s39, s59, 0
		s_add_u32 s38, s38, s62
		s_addc_u32 s39, s39, s63
		s_add_u32 s54, s38, 0
		s_addc_u32 s55, s39, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v23, v9, v23, s[66:67]
		buffer_load_dwordx4 v23, s[32:35], 0 offen lds
		s_add_i32 s37, s53, s22
		v_add_u32_e32 v23, s37, v14
		s_add_u32 s38, s58, 0xa3f0
		s_addc_u32 s39, s59, 0
		s_add_u32 s38, s38, s62
		s_addc_u32 s39, s39, s63
		s_add_u32 s54, s38, 0
		s_addc_u32 s55, s39, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v23, v9, v23, s[68:69]
		buffer_load_dwordx4 v23, s[32:35], 0 offen lds
		s_add_i32 s22, s44, s22
		v_cmp_lt_i32_e64 vcc, v21, s24
		v_add_u32_e32 v21, s22, v14
		s_add_u32 s38, s58, 0xb4f0
		s_addc_u32 s39, s59, 0
		v_cndmask_b32_e32 v21, v9, v21, vcc
		s_add_u32 s38, s38, s62
		s_addc_u32 s39, s39, s63
		s_add_u32 s54, s38, 0
		s_addc_u32 s55, s39, 0
		s_mov_b32 m0, s54
		s_nop 0
		buffer_load_dwordx4 v21, s[32:35], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_1
.L_attn_fwd_persistent.if_else_1:
.L_attn_fwd_persistent.if_end_1:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[112:127], a[132:135], a[40:43], 0
		v_mfma_f32_32x32x16_bf16 v[128:143], a[148:151], a[40:43], 0
		v_mfma_f32_32x32x16_bf16 v[144:159], a[164:167], a[40:43], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[104:107], a[40:43], 0
		v_mfma_f32_32x32x16_bf16 v[176:191], v[104:107], a[64:67], 0
		v_mfma_f32_32x32x16_bf16 v[192:207], a[132:135], a[64:67], 0
		v_mfma_f32_32x32x16_bf16 v[208:223], a[148:151], a[64:67], 0
		v_mfma_f32_32x32x16_bf16 v[224:239], a[164:167], a[64:67], 0
		v_mfma_f32_32x32x16_bf16 v[112:127], a[136:139], a[44:47], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[152:155], a[44:47], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[168:171], a[44:47], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[44:47], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[180:183], a[68:71], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[136:139], a[68:71], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[152:155], a[68:71], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[168:171], a[68:71], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[140:143], a[52:55], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[156:159], a[52:55], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[172:175], a[52:55], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[184:187], a[52:55], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[184:187], a[72:75], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[140:143], a[72:75], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[156:159], a[72:75], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[172:175], a[72:75], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[144:147], a[56:59], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[160:163], a[56:59], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[176:179], a[56:59], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[188:191], a[56:59], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[188:191], a[76:79], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[144:147], a[76:79], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[160:163], a[76:79], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[176:179], a[76:79], v[224:239]
		v_lshrrev_b32_e32 v21, 5, v0
		v_and_b32_e32 v21, 1, v21
		v_accvgpr_write_b32 a132, v21
		v_accvgpr_read_b32 v21, a132
		v_mov_b32_e32 v23, 4
		v_mul_lo_u32 v23, v23, v21
		v_add_u32_e32 v21, s46, v23
		v_accvgpr_write_b32 a132, v21
		v_accvgpr_read_b32 v21, a98
		v_add_u32_e32 v21, s46, v21
		v_accvgpr_write_b32 a133, v21
		v_accvgpr_read_b32 v21, a99
		v_add_u32_e32 v21, s46, v21
		v_accvgpr_write_b32 a134, v21
		v_accvgpr_read_b32 v21, a100
		v_add_u32_e32 v21, s46, v21
		v_accvgpr_write_b32 a135, v21
		v_accvgpr_read_b32 v21, a103
		v_add_u32_e32 v21, s46, v21
		v_accvgpr_write_b32 a136, v21
		v_accvgpr_read_b32 v21, a104
		v_add_u32_e32 v21, s46, v21
		v_accvgpr_write_b32 a137, v21
		v_accvgpr_read_b32 v21, a107
		v_add_u32_e32 v21, s46, v21
		v_accvgpr_write_b32 a138, v21
		v_accvgpr_read_b32 v21, a108
		v_add_u32_e32 v21, s46, v21
		v_accvgpr_write_b32 a139, v21
		v_accvgpr_read_b32 v21, a111
		v_add_u32_e32 v21, s46, v21
		v_accvgpr_write_b32 a140, v21
		v_accvgpr_read_b32 v21, a112
		v_add_u32_e32 v21, s46, v21
		v_accvgpr_write_b32 a141, v21
		v_accvgpr_read_b32 v21, a115
		v_add_u32_e32 v21, s46, v21
		v_accvgpr_write_b32 a142, v21
		v_accvgpr_read_b32 v21, a116
		v_add_u32_e32 v21, s46, v21
		v_accvgpr_write_b32 a143, v21
		v_accvgpr_read_b32 v21, a119
		v_add_u32_e32 v21, s46, v21
		v_accvgpr_write_b32 a144, v21
		v_accvgpr_read_b32 v21, a120
		v_add_u32_e32 v21, s46, v21
		v_accvgpr_write_b32 a145, v21
		v_accvgpr_read_b32 v21, a123
		v_add_u32_e32 v21, s46, v21
		v_accvgpr_write_b32 a146, v21
		v_accvgpr_read_b32 v21, a124
		v_add_u32_e32 v21, s46, v21
		v_accvgpr_write_b32 a147, v21
		v_accvgpr_read_b32 v21, a127
		v_add_u32_e32 v21, s46, v21
		v_accvgpr_write_b32 a148, v21
		v_accvgpr_read_b32 v21, a128
		v_add_u32_e32 v21, s46, v21
		v_accvgpr_write_b32 a149, v21
		v_accvgpr_read_b32 v21, a131
		v_add_u32_e32 v21, s46, v21
		v_accvgpr_write_b32 a150, v21
		v_lshrrev_b32_e32 v21, 5, v0
		v_and_b32_e32 v21, 1, v21
		v_mov_b32_e32 v23, 4
		v_mul_lo_u32 v23, v23, v21
		v_xor_b32_e32 v21, 0x43, v23
		v_add_u32_e32 v21, s46, v21
		v_accvgpr_write_b32 a151, v21
		v_add_u32_e32 v21, s46, v24
		v_accvgpr_write_b32 a152, v21
		v_add_u32_e32 v21, s46, v25
		v_accvgpr_write_b32 a153, v21
		v_add_u32_e32 v21, s46, v26
		v_accvgpr_write_b32 a154, v21
		v_add_u32_e32 v21, s46, v27
		v_accvgpr_write_b32 a155, v21
		v_add_u32_e32 v21, s46, v31
		v_accvgpr_write_b32 a156, v21
		v_add_u32_e32 v21, s46, v96
		v_accvgpr_write_b32 a157, v21
		v_add_u32_e32 v21, s46, v97
		v_accvgpr_write_b32 a158, v21
		v_add_u32_e32 v21, s46, v98
		v_accvgpr_write_b32 a159, v21
		v_add_u32_e32 v21, s46, v99
		v_accvgpr_write_b32 a160, v21
		v_add_u32_e32 v21, s46, v100
		v_accvgpr_write_b32 a161, v21
		v_add_u32_e32 v21, s46, v101
		v_accvgpr_write_b32 a162, v21
		v_add_u32_e32 v21, s46, v102
		v_accvgpr_write_b32 a163, v21
		v_add_u32_e32 v21, s46, v103
		v_accvgpr_write_b32 a164, v21
		v_add_u32_e32 v21, s46, v12
		v_accvgpr_write_b32 a165, v21
		v_accvgpr_read_b32 v21, a132
		v_cmp_ge_i32_e64 vcc, v13, v21
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v21, a133
		v_cmp_ge_i32_e64 vcc, v13, v21
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v21, a134
		v_cmp_ge_i32_e64 vcc, v13, v21
		s_mov_b64 s[58:59], vcc
		v_accvgpr_read_b32 v21, a135
		v_cmp_ge_i32_e64 vcc, v13, v21
		v_accvgpr_read_b32 v21, a101
		v_add_u32_e32 v21, s46, v21
		v_accvgpr_write_b32 a166, v21
		v_accvgpr_read_b32 v21, a102
		v_add_u32_e32 v21, s46, v21
		v_accvgpr_write_b32 a167, v21
		v_mov_b32_e32 v21, 0xff800000
		v_cndmask_b32_e32 v23, v21, v115, vcc
		v_accvgpr_write_b32 a169, v23
		v_accvgpr_read_b32 v23, a166
		v_cmp_ge_i32_e64 vcc, v13, v23
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v23, a167
		v_cmp_ge_i32_e64 vcc, v13, v23
		s_mov_b64 s[62:63], vcc
		v_accvgpr_read_b32 v23, a136
		v_cmp_ge_i32_e64 vcc, v13, v23
		s_mov_b64 s[64:65], vcc
		v_accvgpr_read_b32 v23, a137
		v_cmp_ge_i32_e64 vcc, v13, v23
		v_accvgpr_read_b32 v23, a105
		v_add_u32_e32 v23, s46, v23
		v_accvgpr_write_b32 a170, v23
		v_accvgpr_read_b32 v23, a106
		v_add_u32_e32 v23, s46, v23
		v_accvgpr_write_b32 a171, v23
		v_cndmask_b32_e32 v23, v21, v119, vcc
		v_accvgpr_write_b32 a173, v23
		v_accvgpr_read_b32 v23, a170
		v_cmp_ge_i32_e64 vcc, v13, v23
		s_mov_b64 s[66:67], vcc
		v_accvgpr_read_b32 v23, a171
		v_cmp_ge_i32_e64 vcc, v13, v23
		s_mov_b64 s[68:69], vcc
		v_accvgpr_read_b32 v23, a138
		v_cmp_ge_i32_e64 vcc, v13, v23
		s_mov_b64 s[70:71], vcc
		v_accvgpr_read_b32 v23, a139
		v_cmp_ge_i32_e64 vcc, v13, v23
		v_accvgpr_read_b32 v23, a109
		v_add_u32_e32 v23, s46, v23
		v_accvgpr_write_b32 a174, v23
		v_accvgpr_read_b32 v23, a110
		v_add_u32_e32 v23, s46, v23
		v_accvgpr_write_b32 a175, v23
		v_cndmask_b32_e32 v23, v21, v123, vcc
		v_accvgpr_write_b32 a177, v23
		v_accvgpr_read_b32 v23, a174
		v_cmp_ge_i32_e64 vcc, v13, v23
		s_mov_b64 s[72:73], vcc
		v_accvgpr_read_b32 v23, a175
		v_cmp_ge_i32_e64 vcc, v13, v23
		s_mov_b64 s[74:75], vcc
		v_accvgpr_read_b32 v23, a140
		v_cmp_ge_i32_e64 vcc, v13, v23
		s_mov_b64 s[76:77], vcc
		v_accvgpr_read_b32 v23, a141
		v_cmp_ge_i32_e64 vcc, v13, v23
		v_accvgpr_read_b32 v23, a113
		v_add_u32_e32 v23, s46, v23
		v_accvgpr_write_b32 a178, v23
		v_accvgpr_read_b32 v23, a114
		v_add_u32_e32 v23, s46, v23
		v_accvgpr_write_b32 a179, v23
		v_cndmask_b32_e32 v23, v21, v127, vcc
		v_accvgpr_write_b32 a181, v23
		v_accvgpr_read_b32 v23, a178
		v_cmp_ge_i32_e64 vcc, v13, v23
		s_mov_b64 s[78:79], vcc
		v_accvgpr_read_b32 v23, a179
		v_cmp_ge_i32_e64 vcc, v13, v23
		s_mov_b64 s[80:81], vcc
		v_accvgpr_read_b32 v23, a142
		v_cmp_ge_i32_e64 vcc, v13, v23
		s_mov_b64 s[82:83], vcc
		v_accvgpr_read_b32 v23, a143
		v_cmp_ge_i32_e64 vcc, v13, v23
		v_accvgpr_read_b32 v23, a117
		v_add_u32_e32 v23, s46, v23
		v_accvgpr_write_b32 a182, v23
		v_accvgpr_read_b32 v23, a118
		v_add_u32_e32 v23, s46, v23
		v_accvgpr_write_b32 a183, v23
		v_cndmask_b32_e32 v23, v21, v131, vcc
		v_accvgpr_write_b32 a185, v23
		v_accvgpr_read_b32 v23, a182
		v_cmp_ge_i32_e64 vcc, v13, v23
		s_mov_b64 s[84:85], vcc
		v_accvgpr_read_b32 v23, a183
		v_cmp_ge_i32_e64 vcc, v13, v23
		s_mov_b64 s[86:87], vcc
		v_accvgpr_read_b32 v23, a144
		v_cmp_ge_i32_e64 vcc, v13, v23
		s_mov_b64 s[88:89], vcc
		v_accvgpr_read_b32 v23, a145
		v_cmp_ge_i32_e64 vcc, v13, v23
		v_accvgpr_read_b32 v23, a121
		v_add_u32_e32 v23, s46, v23
		v_accvgpr_write_b32 a184, v23
		v_accvgpr_read_b32 v23, a122
		v_add_u32_e32 v23, s46, v23
		v_accvgpr_write_b32 a186, v23
		v_cndmask_b32_e32 v21, v21, v135, vcc
		v_accvgpr_write_b32 a189, v21
		v_accvgpr_read_b32 v21, a184
		v_cmp_ge_i32_e64 vcc, v13, v21
		s_mov_b64 s[90:91], vcc
		v_accvgpr_read_b32 v21, a186
		v_cmp_ge_i32_e64 vcc, v13, v21
		s_mov_b64 s[92:93], vcc
		v_mov_b32_e32 v28, s92
		v_mov_b32_e32 v29, s93
		v_accvgpr_write_b32 a190, v28
		v_accvgpr_write_b32 a191, v29
		v_accvgpr_read_b32 v21, a146
		v_cmp_ge_i32_e64 vcc, v13, v21
		s_mov_b64 s[92:93], vcc
		s_mov_b32 m0, s17
		v_mov_b32_e32 v28, s92
		v_mov_b32_e32 v29, s93
		ds_write_addtid_b32 v28 offset:32768
		s_mov_b32 m0, s17
		s_nop 0
		ds_write_addtid_b32 v29 offset:33792
		v_accvgpr_read_b32 v21, a147
		v_cmp_ge_i32_e64 vcc, v13, v21
		s_mov_b64 s[92:93], vcc
		v_mov_b32_e32 v28, s92
		v_mov_b32_e32 v29, s93
		v_accvgpr_read_b32 v21, a125
		s_mov_b32 m0, s18
		v_add_u32_e32 v21, s46, v21
		ds_write_addtid_b32 v21 offset:12288
		v_accvgpr_read_b32 v23, a126
		s_mov_b32 m0, s18
		v_add_u32_e32 v23, s46, v23
		ds_write_addtid_b32 v23 offset:13312
		v_mov_b32_e32 v28, 0xff800000
		s_mov_b32 m0, s18
		v_cndmask_b32_e32 v29, v28, v139, vcc
		ds_write_addtid_b32 v29 offset:20480
		v_cmp_ge_i32_e64 vcc, v13, v21
		s_mov_b64 s[92:93], vcc
		s_mov_b32 m0, s17
		v_mov_b32_e32 v104, s92
		v_mov_b32_e32 v105, s93
		ds_write_addtid_b32 v104 offset:34816
		s_mov_b32 m0, s17
		s_nop 0
		ds_write_addtid_b32 v105 offset:35840
		v_cmp_ge_i32_e64 vcc, v13, v23
		s_mov_b64 s[92:93], vcc
		v_mov_b32_e32 v104, s92
		v_mov_b32_e32 v105, s93
		v_accvgpr_read_b32 v21, a148
		v_cmp_ge_i32_e64 vcc, v13, v21
		s_mov_b64 s[92:93], vcc
		v_mov_b32_e32 v106, s92
		v_mov_b32_e32 v107, s93
		v_accvgpr_read_b32 v21, a149
		v_cmp_ge_i32_e64 vcc, v13, v21
		v_accvgpr_read_b32 v21, a129
		s_mov_b32 m0, s18
		v_add_u32_e32 v21, s46, v21
		ds_write_addtid_b32 v21 offset:14336
		v_accvgpr_read_b32 v23, a130
		s_mov_b32 m0, s18
		v_add_u32_e32 v23, s46, v23
		ds_write_addtid_b32 v23 offset:15360
		s_mov_b32 m0, s18
		v_cndmask_b32_e32 v29, v28, v143, vcc
		ds_write_addtid_b32 v29 offset:23552
		v_cmp_ge_i32_e64 vcc, v13, v21
		s_mov_b64 s[92:93], vcc
		v_mov_b32_e32 v108, s92
		v_mov_b32_e32 v109, s93
		v_cmp_ge_i32_e64 vcc, v13, v23
		s_mov_b64 s[92:93], vcc
		v_mov_b32_e32 v110, s92
		v_mov_b32_e32 v111, s93
		v_accvgpr_read_b32 v21, a150
		v_cmp_ge_i32_e64 vcc, v13, v21
		s_mov_b64 s[92:93], vcc
		v_mov_b32_e32 v240, s92
		v_mov_b32_e32 v241, s93
		v_accvgpr_read_b32 v21, a151
		v_cmp_ge_i32_e64 vcc, v13, v21
		v_lshrrev_b32_e32 v21, 5, v0
		v_and_b32_e32 v21, 1, v21
		v_mov_b32_e32 v23, 4
		v_mul_lo_u32 v23, v23, v21
		v_xor_b32_e32 v21, 0x48, v23
		s_mov_b32 m0, s18
		v_add_u32_e32 v21, s46, v21
		ds_write_addtid_b32 v21 offset:16384
		v_lshrrev_b32_e32 v23, 5, v0
		v_and_b32_e32 v23, 1, v23
		v_mov_b32_e32 v29, 4
		v_mul_lo_u32 v29, v29, v23
		v_xor_b32_e32 v23, 0x49, v29
		s_mov_b32 m0, s18
		v_add_u32_e32 v23, s46, v23
		ds_write_addtid_b32 v23 offset:17408
		s_mov_b32 m0, s17
		v_cndmask_b32_e32 v29, v28, v147, vcc
		ds_write_addtid_b32 v29 offset:26624
		v_cmp_ge_i32_e64 vcc, v13, v21
		s_mov_b64 s[92:93], vcc
		v_mov_b32_e32 v242, s92
		v_mov_b32_e32 v243, s93
		v_cmp_ge_i32_e64 vcc, v13, v23
		s_mov_b64 s[92:93], vcc
		v_mov_b32_e32 v244, s92
		v_mov_b32_e32 v245, s93
		v_accvgpr_read_b32 v21, a152
		v_cmp_ge_i32_e64 vcc, v13, v21
		s_mov_b64 s[92:93], vcc
		v_mov_b32_e32 v246, s92
		v_mov_b32_e32 v247, s93
		v_accvgpr_read_b32 v21, a153
		v_cmp_ge_i32_e64 vcc, v13, v21
		v_lshrrev_b32_e32 v21, 5, v0
		v_and_b32_e32 v21, 1, v21
		v_mov_b32_e32 v23, 4
		v_mul_lo_u32 v23, v23, v21
		v_xor_b32_e32 v21, 0x50, v23
		s_mov_b32 m0, s18
		v_add_u32_e32 v21, s46, v21
		ds_write_addtid_b32 v21 offset:21504
		v_lshrrev_b32_e32 v23, 5, v0
		v_and_b32_e32 v23, 1, v23
		v_mov_b32_e32 v29, 4
		v_mul_lo_u32 v29, v29, v23
		v_xor_b32_e32 v23, 0x51, v29
		s_mov_b32 m0, s17
		v_add_u32_e32 v23, s46, v23
		ds_write_addtid_b32 v23 offset:25600
		s_mov_b32 m0, s18
		s_nop 0
		ds_write_addtid_b32 v23 offset:22528
		s_mov_b32 m0, s17
		v_cndmask_b32_e32 v23, v28, v151, vcc
		ds_write_addtid_b32 v23 offset:27648
		v_cmp_ge_i32_e64 vcc, v13, v21
		s_mov_b64 s[92:93], vcc
		s_mov_b32 m0, s17
		v_mov_b32_e32 v248, s92
		v_mov_b32_e32 v249, s93
		s_waitcnt lgkmcnt(2)
		ds_read_addtid_b32 v21 offset:25600
		s_waitcnt lgkmcnt(0)
		v_cmp_ge_i32_e64 vcc, v13, v21
		s_mov_b64 s[92:93], vcc
		v_mov_b32_e32 v250, s92
		v_mov_b32_e32 v251, s93
		v_accvgpr_read_b32 v21, a154
		v_cmp_ge_i32_e64 vcc, v13, v21
		s_mov_b64 s[92:93], vcc
		v_mov_b32_e32 v252, s92
		v_mov_b32_e32 v253, s93
		v_accvgpr_read_b32 v21, a155
		v_cmp_ge_i32_e64 vcc, v13, v21
		v_lshrrev_b32_e32 v21, 5, v0
		v_and_b32_e32 v21, 1, v21
		v_mov_b32_e32 v23, 4
		v_mul_lo_u32 v23, v23, v21
		v_xor_b32_e32 v21, 0x58, v23
		s_mov_b32 m0, s17
		v_add_u32_e32 v21, s46, v21
		ds_write_addtid_b32 v21 offset:30720
		v_lshrrev_b32_e32 v21, 5, v0
		v_and_b32_e32 v21, 1, v21
		v_mov_b32_e32 v23, 4
		v_mul_lo_u32 v23, v23, v21
		v_xor_b32_e32 v21, 0x59, v23
		s_mov_b32 m0, s17
		v_add_u32_e32 v21, s46, v21
		ds_write_addtid_b32 v21 offset:31744
		s_mov_b32 m0, s17
		v_cndmask_b32_e32 v21, v28, v155, vcc
		ds_write_addtid_b32 v21 offset:36864
		s_mov_b32 m0, s17
		s_waitcnt lgkmcnt(2)
		s_nop 0
		ds_read_addtid_b32 v21 offset:30720
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s17
		v_cmp_ge_i32_e64 vcc, v13, v21
		s_mov_b64 s[92:93], vcc
		ds_read_addtid_b32 v21 offset:31744
		s_waitcnt lgkmcnt(0)
		v_cmp_ge_i32_e64 vcc, v13, v21
		s_mov_b64 s[94:95], vcc
		v_accvgpr_read_b32 v21, a156
		v_cmp_ge_i32_e64 vcc, v13, v21
		s_mov_b64 s[96:97], vcc
		s_mov_b32 m0, s17
		v_cndmask_b32_e64 v21, v28, v157, s[94:95]
		ds_write_addtid_b32 v21 offset:37888
		v_cndmask_b32_e64 v254, v28, v158, s[96:97]
		v_accvgpr_read_b32 v21, a157
		v_cmp_ge_i32_e64 vcc, v13, v21
		v_lshrrev_b32_e32 v21, 5, v0
		v_and_b32_e32 v21, 1, v21
		v_mov_b32_e32 v23, 4
		v_mul_lo_u32 v23, v23, v21
		v_xor_b32_e32 v21, 0x60, v23
		v_add_u32_e32 v21, s46, v21
		v_lshrrev_b32_e32 v23, 5, v0
		v_and_b32_e32 v23, 1, v23
		v_mov_b32_e32 v29, 4
		v_mul_lo_u32 v29, v29, v23
		v_xor_b32_e32 v23, 0x61, v29
		v_add_u32_e32 v23, s46, v23
		v_cndmask_b32_e32 v255, v28, v159, vcc
		v_cmp_ge_i32_e64 vcc, v13, v21
		s_mov_b64 s[94:95], vcc
		v_cmp_ge_i32_e64 vcc, v13, v23
		s_mov_b64 s[96:97], vcc
		v_accvgpr_read_b32 v29, a158
		s_mov_b32 m0, s17
		v_cmp_ge_i32_e64 vcc, v13, v29
		s_mov_b64 s[98:99], vcc
		ds_write_addtid_b32 v175 offset:38912
		v_cndmask_b32_e64 v158, v28, v160, s[94:95]
		v_cndmask_b32_e64 v159, v28, v161, s[96:97]
		v_cndmask_b32_e64 v160, v28, v162, s[98:99]
		v_accvgpr_read_b32 v29, a159
		v_cmp_ge_i32_e64 vcc, v13, v29
		v_lshrrev_b32_e32 v29, 5, v0
		v_and_b32_e32 v29, 1, v29
		v_mov_b32_e32 v30, 4
		v_mul_lo_u32 v30, v30, v29
		v_xor_b32_e32 v29, 0x68, v30
		v_add_u32_e32 v29, s46, v29
		v_lshrrev_b32_e32 v30, 5, v0
		v_and_b32_e32 v30, 1, v30
		v_mov_b32_e32 v115, 4
		v_mul_lo_u32 v115, v115, v30
		v_xor_b32_e32 v30, 0x69, v115
		v_add_u32_e32 v30, s46, v30
		v_cndmask_b32_e32 v161, v28, v163, vcc
		v_cmp_ge_i32_e64 vcc, v13, v29
		s_mov_b64 s[94:95], vcc
		v_cmp_ge_i32_e64 vcc, v13, v30
		s_mov_b64 s[96:97], vcc
		v_accvgpr_read_b32 v115, a160
		v_cmp_ge_i32_e64 vcc, v13, v115
		s_mov_b64 s[98:99], vcc
		v_cndmask_b32_e64 v162, v28, v164, s[94:95]
		v_cndmask_b32_e64 v163, v28, v165, s[96:97]
		v_cndmask_b32_e64 v164, v28, v166, s[98:99]
		v_accvgpr_read_b32 v115, a161
		v_cmp_ge_i32_e64 vcc, v13, v115
		v_lshrrev_b32_e32 v115, 5, v0
		v_and_b32_e32 v115, 1, v115
		v_mov_b32_e32 v119, 4
		v_mul_lo_u32 v119, v119, v115
		v_xor_b32_e32 v115, 0x70, v119
		v_add_u32_e32 v115, s46, v115
		v_lshrrev_b32_e32 v119, 5, v0
		v_and_b32_e32 v119, 1, v119
		v_mov_b32_e32 v123, 4
		v_mul_lo_u32 v123, v123, v119
		v_xor_b32_e32 v119, 0x71, v123
		v_add_u32_e32 v119, s46, v119
		v_cndmask_b32_e32 v165, v28, v167, vcc
		v_cmp_ge_i32_e64 vcc, v13, v115
		s_mov_b64 s[94:95], vcc
		v_cmp_ge_i32_e64 vcc, v13, v119
		s_mov_b64 s[96:97], vcc
		v_accvgpr_read_b32 v123, a162
		v_cmp_ge_i32_e64 vcc, v13, v123
		s_mov_b64 s[98:99], vcc
		v_cndmask_b32_e64 v166, v28, v168, s[94:95]
		v_cndmask_b32_e64 v167, v28, v169, s[96:97]
		v_cndmask_b32_e64 v168, v28, v170, s[98:99]
		v_accvgpr_read_b32 v123, a163
		v_cmp_ge_i32_e64 vcc, v13, v123
		v_lshrrev_b32_e32 v123, 5, v0
		v_and_b32_e32 v123, 1, v123
		v_mov_b32_e32 v127, 4
		v_mul_lo_u32 v127, v127, v123
		v_xor_b32_e32 v123, 0x78, v127
		v_add_u32_e32 v123, s46, v123
		v_lshrrev_b32_e32 v127, 5, v0
		v_and_b32_e32 v127, 1, v127
		v_mov_b32_e32 v131, 4
		v_mul_lo_u32 v131, v131, v127
		v_xor_b32_e32 v127, 0x79, v131
		v_add_u32_e32 v127, s46, v127
		v_cndmask_b32_e32 v169, v28, v171, vcc
		v_cmp_ge_i32_e64 vcc, v13, v123
		s_mov_b64 s[94:95], vcc
		v_cmp_ge_i32_e64 vcc, v13, v127
		s_mov_b64 s[96:97], vcc
		v_accvgpr_read_b32 v131, a164
		v_cmp_ge_i32_e64 vcc, v13, v131
		s_mov_b64 s[98:99], vcc
		v_cndmask_b32_e64 v170, v28, v172, s[94:95]
		v_cndmask_b32_e64 v171, v28, v173, s[96:97]
		v_cndmask_b32_e64 v172, v28, v174, s[98:99]
		v_accvgpr_read_b32 v131, a165
		v_cmp_ge_i32_e64 vcc, v13, v131
		v_cndmask_b32_e64 v174, v28, v112, s[38:39]
		s_mov_b32 m0, s17
		v_cndmask_b32_e64 v175, v28, v113, s[54:55]
		s_waitcnt lgkmcnt(0)
		ds_read_addtid_b32 v112 offset:38912
		s_waitcnt lgkmcnt(0)
		v_cndmask_b32_e32 v173, v28, v112, vcc
		v_accvgpr_read_b32 v112, a132
		v_cmp_ge_i32_e64 vcc, v20, v112
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v112, a133
		v_cmp_ge_i32_e64 vcc, v20, v112
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v112, a134
		v_cmp_ge_i32_e64 vcc, v20, v112
		s_mov_b64 s[94:95], vcc
		v_cndmask_b32_e64 v112, v28, v192, s[38:39]
		v_accvgpr_write_b32 a132, v112
		v_cndmask_b32_e64 v112, v28, v193, s[54:55]
		v_accvgpr_write_b32 a133, v112
		v_cndmask_b32_e64 v112, v28, v194, s[94:95]
		v_accvgpr_read_b32 v113, a135
		v_cmp_ge_i32_e64 vcc, v20, v113
		v_cndmask_b32_e64 v113, v28, v114, s[58:59]
		v_accvgpr_write_b32 a168, v113
		v_cndmask_b32_e64 v192, v28, v116, s[60:61]
		v_cndmask_b32_e32 v113, v28, v195, vcc
		v_accvgpr_read_b32 v114, a166
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v114, a167
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v114, a136
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v194, v28, v196, s[38:39]
		v_cndmask_b32_e64 v195, v28, v197, s[54:55]
		v_cndmask_b32_e64 v196, v28, v198, s[58:59]
		v_accvgpr_read_b32 v114, a137
		v_cmp_ge_i32_e64 vcc, v20, v114
		v_cndmask_b32_e64 v193, v28, v117, s[62:63]
		v_cndmask_b32_e64 v114, v28, v118, s[64:65]
		v_accvgpr_write_b32 a172, v114
		v_cndmask_b32_e32 v197, v28, v199, vcc
		v_accvgpr_read_b32 v114, a170
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v114, a171
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v114, a138
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v116, v28, v200, s[38:39]
		v_cndmask_b32_e64 v117, v28, v201, s[54:55]
		v_cndmask_b32_e64 v198, v28, v202, s[58:59]
		v_accvgpr_read_b32 v114, a139
		v_cmp_ge_i32_e64 vcc, v20, v114
		v_cndmask_b32_e64 v200, v28, v120, s[66:67]
		v_cndmask_b32_e64 v201, v28, v121, s[68:69]
		v_cndmask_b32_e32 v199, v28, v203, vcc
		v_accvgpr_read_b32 v114, a174
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v114, a175
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v114, a140
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v120, v28, v204, s[38:39]
		v_cndmask_b32_e64 v121, v28, v205, s[54:55]
		v_cndmask_b32_e64 v202, v28, v206, s[58:59]
		v_accvgpr_read_b32 v114, a141
		v_cmp_ge_i32_e64 vcc, v20, v114
		v_cndmask_b32_e64 v114, v28, v122, s[70:71]
		v_accvgpr_write_b32 a176, v114
		v_cndmask_b32_e64 v204, v28, v124, s[72:73]
		v_cndmask_b32_e32 v203, v28, v207, vcc
		v_accvgpr_read_b32 v114, a178
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v114, a179
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v114, a142
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v206, v28, v208, s[38:39]
		v_cndmask_b32_e64 v207, v28, v209, s[54:55]
		v_cndmask_b32_e64 v208, v28, v210, s[58:59]
		v_accvgpr_read_b32 v114, a143
		v_cmp_ge_i32_e64 vcc, v20, v114
		v_cndmask_b32_e64 v205, v28, v125, s[74:75]
		v_cndmask_b32_e64 v114, v28, v126, s[76:77]
		v_accvgpr_write_b32 a180, v114
		v_cndmask_b32_e32 v209, v28, v211, vcc
		v_accvgpr_read_b32 v114, a182
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v114, a183
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v114, a144
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v124, v28, v212, s[38:39]
		v_cndmask_b32_e64 v125, v28, v213, s[54:55]
		v_cndmask_b32_e64 v210, v28, v214, s[58:59]
		v_accvgpr_read_b32 v114, a145
		v_cmp_ge_i32_e64 vcc, v20, v114
		v_cndmask_b32_e64 v212, v28, v128, s[78:79]
		v_cndmask_b32_e64 v213, v28, v129, s[80:81]
		v_cndmask_b32_e32 v211, v28, v215, vcc
		v_accvgpr_read_b32 v114, a184
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v114, a186
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v114, a146
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v128, v28, v216, s[38:39]
		v_cndmask_b32_e64 v129, v28, v217, s[54:55]
		v_cndmask_b32_e64 v214, v28, v218, s[58:59]
		v_accvgpr_read_b32 v114, a147
		v_cmp_ge_i32_e64 vcc, v20, v114
		v_cndmask_b32_e64 v114, v28, v130, s[82:83]
		v_accvgpr_write_b32 a184, v114
		v_cndmask_b32_e64 v130, v28, v132, s[84:85]
		s_mov_b32 m0, s18
		v_cndmask_b32_e32 v215, v28, v219, vcc
		ds_read_addtid_b32 v114 offset:12288
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s18
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[38:39], vcc
		ds_read_addtid_b32 v114 offset:13312
		s_waitcnt lgkmcnt(0)
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v114, a148
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v216, v28, v220, s[38:39]
		v_cndmask_b32_e64 v217, v28, v221, s[54:55]
		v_cndmask_b32_e64 v218, v28, v222, s[58:59]
		v_accvgpr_read_b32 v114, a149
		v_cmp_ge_i32_e64 vcc, v20, v114
		v_cndmask_b32_e64 v131, v28, v133, s[86:87]
		v_cndmask_b32_e64 v114, v28, v134, s[88:89]
		v_accvgpr_write_b32 a188, v114
		s_mov_b32 m0, s18
		v_cndmask_b32_e32 v219, v28, v223, vcc
		ds_read_addtid_b32 v114 offset:14336
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s18
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[38:39], vcc
		ds_read_addtid_b32 v114 offset:15360
		s_waitcnt lgkmcnt(0)
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v114, a150
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v132, v28, v224, s[38:39]
		v_cndmask_b32_e64 v133, v28, v225, s[54:55]
		v_cndmask_b32_e64 v134, v28, v226, s[58:59]
		v_accvgpr_read_b32 v114, a151
		v_cmp_ge_i32_e64 vcc, v20, v114
		v_mov_b32_e32 v220, s90
		v_mov_b32_e32 v221, s91
		s_nop 0
		v_readfirstlane_b32 s38, v220
		v_readfirstlane_b32 s39, v221
		s_nop 1
		v_cndmask_b32_e64 v220, v28, v136, s[38:39]
		v_accvgpr_read_b32 v114, a190
		s_nop 0
		v_readfirstlane_b32 s38, v114
		v_accvgpr_read_b32 v114, a191
		s_nop 0
		v_readfirstlane_b32 s39, v114
		s_nop 1
		v_cndmask_b32_e64 v221, v28, v137, s[38:39]
		s_mov_b32 m0, s18
		v_cndmask_b32_e32 v135, v28, v227, vcc
		ds_read_addtid_b32 v114 offset:16384
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s18
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[38:39], vcc
		ds_read_addtid_b32 v114 offset:17408
		s_waitcnt lgkmcnt(0)
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v114, a152
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v136, v28, v228, s[38:39]
		v_cndmask_b32_e64 v137, v28, v229, s[54:55]
		v_cndmask_b32_e64 v222, v28, v230, s[58:59]
		v_accvgpr_read_b32 v114, a153
		s_mov_b32 m0, s17
		v_cmp_ge_i32_e64 vcc, v20, v114
		ds_read_addtid_b32 v224 offset:32768
		s_mov_b32 m0, s17
		s_nop 0
		ds_read_addtid_b32 v225 offset:33792
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s38, v224
		v_readfirstlane_b32 s39, v225
		s_mov_b32 m0, s17
		s_nop 0
		v_cndmask_b32_e64 v224, v28, v138, s[38:39]
		ds_read_addtid_b32 v138 offset:34816
		s_mov_b32 m0, s17
		s_nop 0
		ds_read_addtid_b32 v139 offset:35840
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s38, v138
		v_readfirstlane_b32 s39, v139
		s_nop 1
		v_cndmask_b32_e64 v138, v28, v140, s[38:39]
		s_mov_b32 m0, s18
		v_cndmask_b32_e32 v223, v28, v231, vcc
		ds_read_addtid_b32 v114 offset:21504
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s18
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[38:39], vcc
		ds_read_addtid_b32 v114 offset:22528
		s_waitcnt lgkmcnt(0)
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v114, a154
		v_cmp_ge_i32_e64 vcc, v20, v114
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v226, v28, v232, s[38:39]
		v_cndmask_b32_e64 v227, v28, v233, s[54:55]
		v_cndmask_b32_e64 v228, v28, v234, s[58:59]
		v_accvgpr_read_b32 v114, a155
		v_cmp_ge_i32_e64 vcc, v20, v114
		v_readfirstlane_b32 s38, v104
		v_readfirstlane_b32 s39, v105
		s_nop 1
		v_cndmask_b32_e64 v139, v28, v141, s[38:39]
		v_readfirstlane_b32 s38, v106
		v_readfirstlane_b32 s39, v107
		s_nop 1
		v_cndmask_b32_e64 v104, v28, v142, s[38:39]
		s_mov_b32 m0, s17
		v_cndmask_b32_e32 v229, v28, v235, vcc
		ds_read_addtid_b32 v105 offset:30720
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s17
		v_cmp_ge_i32_e64 vcc, v20, v105
		s_mov_b64 s[38:39], vcc
		ds_read_addtid_b32 v105 offset:31744
		s_waitcnt lgkmcnt(0)
		v_cmp_ge_i32_e64 vcc, v20, v105
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v105, a156
		v_cmp_ge_i32_e64 vcc, v20, v105
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v106, v28, v236, s[38:39]
		v_cndmask_b32_e64 v107, v28, v237, s[54:55]
		v_cndmask_b32_e64 v140, v28, v238, s[58:59]
		v_accvgpr_read_b32 v105, a157
		v_cmp_ge_i32_e64 vcc, v20, v105
		v_readfirstlane_b32 s38, v108
		v_readfirstlane_b32 s39, v109
		s_nop 1
		v_cndmask_b32_e64 v108, v28, v144, s[38:39]
		v_readfirstlane_b32 s38, v110
		v_readfirstlane_b32 s39, v111
		s_nop 1
		v_cndmask_b32_e64 v109, v28, v145, s[38:39]
		v_cndmask_b32_e32 v141, v28, v239, vcc
		v_cmp_ge_i32_e64 vcc, v20, v21
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v20, v23
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v21, a158
		v_cmp_ge_i32_e64 vcc, v20, v21
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v110, v28, v176, s[38:39]
		v_cndmask_b32_e64 v111, v28, v177, s[54:55]
		v_cndmask_b32_e64 v142, v28, v178, s[58:59]
		v_accvgpr_read_b32 v21, a159
		v_cmp_ge_i32_e64 vcc, v20, v21
		v_readfirstlane_b32 s38, v240
		v_readfirstlane_b32 s39, v241
		s_nop 1
		v_cndmask_b32_e64 v144, v28, v146, s[38:39]
		v_readfirstlane_b32 s38, v242
		v_readfirstlane_b32 s39, v243
		s_nop 1
		v_cndmask_b32_e64 v146, v28, v148, s[38:39]
		v_cndmask_b32_e32 v143, v28, v179, vcc
		v_cmp_ge_i32_e64 vcc, v20, v29
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v20, v30
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v21, a160
		v_cmp_ge_i32_e64 vcc, v20, v21
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v176, v28, v180, s[38:39]
		v_cndmask_b32_e64 v177, v28, v181, s[54:55]
		v_cndmask_b32_e64 v178, v28, v182, s[58:59]
		v_accvgpr_read_b32 v21, a161
		v_cmp_ge_i32_e64 vcc, v20, v21
		v_readfirstlane_b32 s38, v244
		v_readfirstlane_b32 s39, v245
		s_nop 1
		v_cndmask_b32_e64 v147, v28, v149, s[38:39]
		v_readfirstlane_b32 s38, v246
		v_readfirstlane_b32 s39, v247
		s_nop 1
		v_cndmask_b32_e64 v148, v28, v150, s[38:39]
		v_cndmask_b32_e32 v179, v28, v183, vcc
		v_cmp_ge_i32_e64 vcc, v20, v115
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v20, v119
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v21, a162
		v_cmp_ge_i32_e64 vcc, v20, v21
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v114, v28, v184, s[38:39]
		v_cndmask_b32_e64 v115, v28, v185, s[54:55]
		v_cndmask_b32_e64 v118, v28, v186, s[58:59]
		v_accvgpr_read_b32 v21, a163
		v_cmp_ge_i32_e64 vcc, v20, v21
		v_readfirstlane_b32 s38, v248
		v_readfirstlane_b32 s39, v249
		s_nop 1
		v_cndmask_b32_e64 v150, v28, v152, s[38:39]
		v_readfirstlane_b32 s38, v250
		v_readfirstlane_b32 s39, v251
		s_nop 1
		v_cndmask_b32_e64 v151, v28, v153, s[38:39]
		v_cndmask_b32_e32 v119, v28, v187, vcc
		v_cmp_ge_i32_e64 vcc, v20, v123
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v20, v127
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v21, a164
		v_cmp_ge_i32_e64 vcc, v20, v21
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v122, v28, v188, s[38:39]
		v_cndmask_b32_e64 v123, v28, v189, s[54:55]
		v_cndmask_b32_e64 v126, v28, v190, s[58:59]
		v_accvgpr_read_b32 v21, a165
		v_cmp_ge_i32_e64 vcc, v20, v21
		v_readfirstlane_b32 s38, v252
		v_readfirstlane_b32 s39, v253
		s_nop 1
		v_cndmask_b32_e64 v152, v28, v154, s[38:39]
		v_mov_b32_e32 v154, s92
		v_mov_b32_e32 v155, s93
		s_nop 0
		v_readfirstlane_b32 s38, v154
		v_readfirstlane_b32 s39, v155
		s_nop 1
		v_cndmask_b32_e64 v154, v28, v156, s[38:39]
		v_cndmask_b32_e32 v127, v28, v191, vcc
		v_max_f32_e32 v21, v174, v175
		v_accvgpr_read_b32 v23, a169
		v_accvgpr_read_b32 v28, a168
		v_max_f32_e32 v23, v28, v23
		v_max_f32_e32 v28, v192, v193
		v_accvgpr_read_b32 v29, a173
		v_accvgpr_read_b32 v30, a172
		v_max_f32_e32 v29, v30, v29
		v_max_f32_e32 v30, v200, v201
		v_accvgpr_read_b32 v105, a177
		v_accvgpr_read_b32 v145, a176
		v_max_f32_e32 v105, v145, v105
		v_max_f32_e32 v145, v204, v205
		v_accvgpr_read_b32 v149, a181
		v_accvgpr_read_b32 v153, a180
		v_max_f32_e32 v149, v153, v149
		v_max_f32_e32 v153, v212, v213
		v_accvgpr_read_b32 v155, a185
		v_accvgpr_read_b32 v156, a184
		v_max_f32_e32 v155, v156, v155
		v_max_f32_e32 v156, v130, v131
		v_accvgpr_read_b32 v157, a189
		v_accvgpr_read_b32 v180, a188
		v_max_f32_e32 v157, v180, v157
		s_mov_b32 m0, s18
		v_max_f32_e32 v180, v220, v221
		ds_read_addtid_b32 v181 offset:20480
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v181, v224, v181
		s_mov_b32 m0, s18
		v_max_f32_e32 v182, v138, v139
		ds_read_addtid_b32 v183 offset:23552
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v183, v104, v183
		s_mov_b32 m0, s17
		v_max_f32_e32 v184, v108, v109
		ds_read_addtid_b32 v185 offset:26624
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v185, v144, v185
		s_mov_b32 m0, s17
		v_max_f32_e32 v186, v146, v147
		ds_read_addtid_b32 v187 offset:27648
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v187, v148, v187
		s_mov_b32 m0, s17
		v_max_f32_e32 v188, v150, v151
		ds_read_addtid_b32 v189 offset:36864
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s17
		v_max_f32_e32 v189, v152, v189
		ds_read_addtid_b32 v190 offset:37888
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v190, v154, v190
		v_max_f32_e32 v191, v254, v255
		v_max_f32_e32 v225, v158, v159
		v_max_f32_e32 v230, v160, v161
		v_max_f32_e32 v231, v162, v163
		v_max_f32_e32 v232, v164, v165
		v_max_f32_e32 v233, v166, v167
		v_max_f32_e32 v234, v168, v169
		v_max_f32_e32 v235, v170, v171
		v_max_f32_e32 v236, v172, v173
		v_max_f32_e32 v21, v21, v23
		v_max_f32_e32 v23, v28, v29
		v_max_f32_e32 v28, v30, v105
		v_max_f32_e32 v29, v145, v149
		v_max_f32_e32 v30, v153, v155
		v_max_f32_e32 v105, v156, v157
		v_max_f32_e32 v145, v180, v181
		v_max_f32_e32 v149, v182, v183
		v_max_f32_e32 v153, v184, v185
		v_max_f32_e32 v155, v186, v187
		v_max_f32_e32 v156, v188, v189
		v_max_f32_e32 v157, v190, v191
		v_max_f32_e32 v180, v225, v230
		v_max_f32_e32 v181, v231, v232
		v_max_f32_e32 v182, v233, v234
		v_max_f32_e32 v183, v235, v236
		v_max_f32_e32 v21, v21, v23
		v_max_f32_e32 v23, v28, v29
		v_max_f32_e32 v28, v30, v105
		v_max_f32_e32 v29, v145, v149
		v_max_f32_e32 v30, v153, v155
		v_max_f32_e32 v105, v156, v157
		v_max_f32_e32 v145, v180, v181
		v_max_f32_e32 v149, v182, v183
		v_max_f32_e32 v21, v21, v23
		v_max_f32_e32 v23, v28, v29
		v_max_f32_e32 v28, v30, v105
		v_max_f32_e32 v29, v145, v149
		v_max_f32_e32 v21, v21, v23
		v_max_f32_e32 v23, v28, v29
		v_max_f32_e32 v21, v21, v23
		v_and_b32_e32 v23, 1, v15
		v_lshrrev_b32_e32 v28, 4, v15
		v_and_b32_e32 v28, 1, v28
		v_lshlrev_b32_e32 v28, 4, v28
		v_lshrrev_b32_e32 v29, 3, v15
		v_and_b32_e32 v29, 1, v29
		v_lshlrev_b32_e32 v29, 3, v29
		v_add3_u32 v23, v23, v28, v29
		v_lshrrev_b32_e32 v28, 2, v15
		v_and_b32_e32 v28, 1, v28
		v_lshlrev_b32_e32 v28, 2, v28
		v_lshrrev_b32_e32 v29, 1, v15
		v_and_b32_e32 v29, 1, v29
		v_lshlrev_b32_e32 v29, 1, v29
		v_add3_u32 v23, v23, v28, v29
		v_lshlrev_b32_e32 v23, 2, v23
		ds_bpermute_b32 v28, v23, v21
		v_lshrrev_b32_e32 v29, 4, v15
		v_and_b32_e32 v29, 1, v29
		v_lshlrev_b32_e32 v29, 4, v29
		v_lshrrev_b32_e32 v30, 3, v15
		v_and_b32_e32 v30, 1, v30
		v_lshlrev_b32_e32 v30, 3, v30
		v_lshrrev_b32_e32 v105, 2, v15
		v_and_b32_e32 v105, 1, v105
		v_lshlrev_b32_e32 v105, 2, v105
		v_and_b32_e32 v145, 1, v15
		v_add_u32_e32 v145, 32, v145
		v_lshrrev_b32_e32 v149, 1, v15
		v_and_b32_e32 v149, 1, v149
		v_lshlrev_b32_e32 v149, 1, v149
		v_bitop3_b32 v105, v105, v145, v149 bitop3:0x96
		v_bitop3_b32 v29, v29, v30, v105 bitop3:0x96
		v_lshlrev_b32_e32 v29, 2, v29
		ds_bpermute_b32 v30, v29, v21
		v_accvgpr_read_b32 v21, a132
		v_accvgpr_read_b32 v105, a133
		v_max_f32_e32 v21, v21, v105
		v_max_f32_e32 v105, v112, v113
		v_max_f32_e32 v145, v194, v195
		v_max_f32_e32 v149, v196, v197
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v156, v28, v30
		v_max_f32_e32 v28, v116, v117
		v_max_f32_e32 v30, v198, v199
		v_max_f32_e32 v153, v120, v121
		v_max_f32_e32 v155, v202, v203
		v_max_f32_e32 v157, v206, v207
		v_max_f32_e32 v180, v208, v209
		v_max_f32_e32 v181, v124, v125
		v_max_f32_e32 v182, v210, v211
		v_max_f32_e32 v183, v128, v129
		v_max_f32_e32 v184, v214, v215
		v_max_f32_e32 v185, v216, v217
		v_max_f32_e32 v186, v218, v219
		v_max_f32_e32 v187, v132, v133
		v_max_f32_e32 v188, v134, v135
		v_max_f32_e32 v189, v136, v137
		v_max_f32_e32 v190, v222, v223
		v_max_f32_e32 v191, v226, v227
		v_max_f32_e32 v225, v228, v229
		v_max_f32_e32 v230, v106, v107
		v_max_f32_e32 v231, v140, v141
		v_max_f32_e32 v232, v110, v111
		v_max_f32_e32 v233, v142, v143
		v_max_f32_e32 v234, v176, v177
		v_max_f32_e32 v235, v178, v179
		v_max_f32_e32 v236, v114, v115
		v_max_f32_e32 v237, v118, v119
		v_max_f32_e32 v238, v122, v123
		v_max_f32_e32 v239, v126, v127
		v_max_f32_e32 v21, v21, v105
		v_max_f32_e32 v105, v145, v149
		v_max_f32_e32 v28, v28, v30
		v_max_f32_e32 v30, v153, v155
		v_max_f32_e32 v145, v157, v180
		v_max_f32_e32 v149, v181, v182
		v_max_f32_e32 v153, v183, v184
		v_max_f32_e32 v155, v185, v186
		v_max_f32_e32 v157, v187, v188
		v_max_f32_e32 v180, v189, v190
		v_max_f32_e32 v181, v191, v225
		v_max_f32_e32 v182, v230, v231
		v_max_f32_e32 v183, v232, v233
		v_max_f32_e32 v184, v234, v235
		v_max_f32_e32 v185, v236, v237
		v_max_f32_e32 v186, v238, v239
		v_max_f32_e32 v21, v21, v105
		v_max_f32_e32 v28, v28, v30
		v_max_f32_e32 v30, v145, v149
		v_max_f32_e32 v105, v153, v155
		v_max_f32_e32 v145, v157, v180
		v_max_f32_e32 v149, v181, v182
		v_max_f32_e32 v153, v183, v184
		v_max_f32_e32 v155, v185, v186
		v_max_f32_e32 v21, v21, v28
		v_max_f32_e32 v28, v30, v105
		v_max_f32_e32 v30, v145, v149
		v_max_f32_e32 v105, v153, v155
		v_max_f32_e32 v21, v21, v28
		v_max_f32_e32 v28, v30, v105
		v_max_f32_e32 v21, v21, v28
		ds_bpermute_b32 v28, v23, v21
		ds_bpermute_b32 v30, v29, v21
		v_mov_b32_e32 v180, 0x3e38aa3b
		v_mov_b32_e32 v181, 0x3e38aa3b
		v_pk_mul_f32 v[182:183], v[174:175], v[180:181]
		v_accvgpr_read_b32 v174, a168
		v_accvgpr_read_b32 v175, a169
		v_pk_mul_f32 v[184:185], v[174:175], v[180:181]
		v_pk_mul_f32 v[174:175], v[192:193], v[180:181]
		v_accvgpr_read_b32 v186, a172
		v_accvgpr_read_b32 v187, a173
		v_pk_mul_f32 v[188:189], v[186:187], v[180:181]
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v157, v28, v30
		s_mov_b32 m0, s18
		v_pk_mul_f32 v[186:187], v[156:157], v[180:181]
		ds_read_addtid_b32 v21 offset:18432
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s18
		v_max_f32_e32 v21, v21, v186
		ds_read_addtid_b32 v28 offset:19456
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v30, v28, v187
		v_pk_mul_f32 v[156:157], v[200:201], v[180:181]
		v_accvgpr_read_b32 v186, a176
		v_accvgpr_read_b32 v187, a177
		v_pk_mul_f32 v[190:191], v[186:187], v[180:181]
		v_pk_mul_f32 v[186:187], v[204:205], v[180:181]
		v_accvgpr_read_b32 v192, a180
		v_accvgpr_read_b32 v193, a181
		v_pk_mul_f32 v[200:201], v[192:193], v[180:181]
		v_pk_mul_f32 v[192:193], v[212:213], v[180:181]
		v_accvgpr_read_b32 v204, a184
		v_accvgpr_read_b32 v205, a185
		v_pk_mul_f32 v[212:213], v[204:205], v[180:181]
		v_pk_mul_f32 v[204:205], v[130:131], v[180:181]
		v_accvgpr_read_b32 v130, a188
		v_accvgpr_read_b32 v131, a189
		v_pk_mul_f32 v[230:231], v[130:131], v[180:181]
		s_mov_b32 m0, s18
		v_pk_mul_f32 v[130:131], v[220:221], v[180:181]
		ds_read_addtid_b32 v225 offset:20480
		s_waitcnt lgkmcnt(0)
		v_pk_mul_f32 v[220:221], v[224:225], v[180:181]
		s_mov_b32 m0, s18
		v_pk_mul_f32 v[224:225], v[138:139], v[180:181]
		ds_read_addtid_b32 v105 offset:23552
		s_waitcnt lgkmcnt(0)
		v_pk_mul_f32 v[138:139], v[104:105], v[180:181]
		s_mov_b32 m0, s17
		v_pk_mul_f32 v[104:105], v[108:109], v[180:181]
		ds_read_addtid_b32 v145 offset:26624
		s_waitcnt lgkmcnt(0)
		v_pk_mul_f32 v[108:109], v[144:145], v[180:181]
		s_mov_b32 m0, s17
		v_pk_mul_f32 v[144:145], v[146:147], v[180:181]
		ds_read_addtid_b32 v149 offset:27648
		s_waitcnt lgkmcnt(0)
		v_pk_mul_f32 v[146:147], v[148:149], v[180:181]
		s_mov_b32 m0, s17
		v_pk_mul_f32 v[148:149], v[150:151], v[180:181]
		ds_read_addtid_b32 v153 offset:36864
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s17
		v_pk_mul_f32 v[150:151], v[152:153], v[180:181]
		ds_read_addtid_b32 v155 offset:37888
		s_waitcnt lgkmcnt(0)
		v_pk_mul_f32 v[152:153], v[154:155], v[180:181]
		v_pk_mul_f32 v[154:155], v[254:255], v[180:181]
		v_pk_mul_f32 v[232:233], v[158:159], v[180:181]
		v_pk_mul_f32 v[158:159], v[160:161], v[180:181]
		v_pk_mul_f32 v[160:161], v[162:163], v[180:181]
		v_pk_mul_f32 v[162:163], v[164:165], v[180:181]
		v_pk_mul_f32 v[164:165], v[166:167], v[180:181]
		v_pk_mul_f32 v[166:167], v[168:169], v[180:181]
		v_pk_mul_f32 v[168:169], v[170:171], v[180:181]
		v_pk_mul_f32 v[170:171], v[172:173], v[180:181]
		v_accvgpr_read_b32 v172, a132
		v_accvgpr_read_b32 v173, a133
		v_pk_mul_f32 v[234:235], v[172:173], v[180:181]
		v_pk_mul_f32 v[172:173], v[112:113], v[180:181]
		v_pk_mul_f32 v[112:113], v[194:195], v[180:181]
		v_pk_mul_f32 v[194:195], v[196:197], v[180:181]
		v_pk_mul_f32 v[196:197], v[116:117], v[180:181]
		v_pk_mul_f32 v[116:117], v[198:199], v[180:181]
		v_pk_mul_f32 v[198:199], v[120:121], v[180:181]
		v_pk_mul_f32 v[120:121], v[202:203], v[180:181]
		v_pk_mul_f32 v[202:203], v[206:207], v[180:181]
		v_pk_mul_f32 v[206:207], v[208:209], v[180:181]
		v_pk_mul_f32 v[208:209], v[124:125], v[180:181]
		v_pk_mul_f32 v[124:125], v[210:211], v[180:181]
		v_pk_mul_f32 v[210:211], v[128:129], v[180:181]
		v_pk_mul_f32 v[128:129], v[214:215], v[180:181]
		v_pk_mul_f32 v[214:215], v[216:217], v[180:181]
		v_pk_mul_f32 v[216:217], v[218:219], v[180:181]
		v_pk_mul_f32 v[218:219], v[132:133], v[180:181]
		v_pk_mul_f32 v[132:133], v[134:135], v[180:181]
		v_pk_mul_f32 v[134:135], v[136:137], v[180:181]
		v_pk_mul_f32 v[136:137], v[222:223], v[180:181]
		v_pk_mul_f32 v[222:223], v[226:227], v[180:181]
		v_pk_mul_f32 v[226:227], v[228:229], v[180:181]
		v_pk_mul_f32 v[228:229], v[106:107], v[180:181]
		v_pk_mul_f32 v[106:107], v[140:141], v[180:181]
		v_pk_mul_f32 v[140:141], v[110:111], v[180:181]
		v_pk_mul_f32 v[110:111], v[142:143], v[180:181]
		v_pk_mul_f32 v[142:143], v[176:177], v[180:181]
		v_pk_mul_f32 v[176:177], v[178:179], v[180:181]
		v_pk_mul_f32 v[178:179], v[114:115], v[180:181]
		v_pk_mul_f32 v[114:115], v[118:119], v[180:181]
		v_pk_mul_f32 v[118:119], v[122:123], v[180:181]
		v_pk_mul_f32 v[122:123], v[126:127], v[180:181]
		v_sub_f32_e32 v28, v182, v21
		v_sub_f32_e32 v126, v183, v21
		v_sub_f32_e32 v127, v184, v21
		v_sub_f32_e32 v180, v185, v21
		v_sub_f32_e32 v174, v174, v21
		v_sub_f32_e32 v175, v175, v21
		v_sub_f32_e32 v181, v188, v21
		v_sub_f32_e32 v182, v189, v21
		v_sub_f32_e32 v156, v156, v21
		v_sub_f32_e32 v157, v157, v21
		v_sub_f32_e32 v183, v190, v21
		v_sub_f32_e32 v184, v191, v21
		v_sub_f32_e32 v185, v186, v21
		v_sub_f32_e32 v186, v187, v21
		v_sub_f32_e32 v187, v200, v21
		v_sub_f32_e32 v188, v201, v21
		v_sub_f32_e32 v189, v192, v21
		v_sub_f32_e32 v190, v193, v21
		v_sub_f32_e32 v191, v212, v21
		v_sub_f32_e32 v192, v213, v21
		v_sub_f32_e32 v193, v204, v21
		v_sub_f32_e32 v200, v205, v21
		v_sub_f32_e32 v201, v230, v21
		v_sub_f32_e32 v204, v231, v21
		v_sub_f32_e32 v130, v130, v21
		v_sub_f32_e32 v131, v131, v21
		v_sub_f32_e32 v205, v220, v21
		v_sub_f32_e32 v212, v221, v21
		v_sub_f32_e32 v213, v224, v21
		v_sub_f32_e32 v220, v225, v21
		v_sub_f32_e32 v138, v138, v21
		v_sub_f32_e32 v139, v139, v21
		v_sub_f32_e32 v104, v104, v21
		v_sub_f32_e32 v105, v105, v21
		v_sub_f32_e32 v108, v108, v21
		v_sub_f32_e32 v109, v109, v21
		v_sub_f32_e32 v144, v144, v21
		v_sub_f32_e32 v145, v145, v21
		v_sub_f32_e32 v146, v146, v21
		v_sub_f32_e32 v147, v147, v21
		v_sub_f32_e32 v148, v148, v21
		v_sub_f32_e32 v149, v149, v21
		v_sub_f32_e32 v150, v150, v21
		v_sub_f32_e32 v151, v151, v21
		v_sub_f32_e32 v152, v152, v21
		v_sub_f32_e32 v153, v153, v21
		v_sub_f32_e32 v154, v154, v21
		v_sub_f32_e32 v155, v155, v21
		v_sub_f32_e32 v221, v232, v21
		v_sub_f32_e32 v224, v233, v21
		v_sub_f32_e32 v158, v158, v21
		v_sub_f32_e32 v159, v159, v21
		v_sub_f32_e32 v160, v160, v21
		v_sub_f32_e32 v161, v161, v21
		v_sub_f32_e32 v162, v162, v21
		v_sub_f32_e32 v163, v163, v21
		v_sub_f32_e32 v164, v164, v21
		v_sub_f32_e32 v165, v165, v21
		v_sub_f32_e32 v166, v166, v21
		v_sub_f32_e32 v167, v167, v21
		v_sub_f32_e32 v168, v168, v21
		v_sub_f32_e32 v169, v169, v21
		v_sub_f32_e32 v170, v170, v21
		v_sub_f32_e32 v171, v171, v21
		v_sub_f32_e32 v225, v234, v30
		v_sub_f32_e32 v230, v235, v30
		v_sub_f32_e32 v172, v172, v30
		v_sub_f32_e32 v173, v173, v30
		v_sub_f32_e32 v112, v112, v30
		v_sub_f32_e32 v113, v113, v30
		v_sub_f32_e32 v194, v194, v30
		v_sub_f32_e32 v195, v195, v30
		v_sub_f32_e32 v196, v196, v30
		v_sub_f32_e32 v197, v197, v30
		v_sub_f32_e32 v116, v116, v30
		v_sub_f32_e32 v117, v117, v30
		v_sub_f32_e32 v198, v198, v30
		v_sub_f32_e32 v199, v199, v30
		v_sub_f32_e32 v120, v120, v30
		v_sub_f32_e32 v121, v121, v30
		v_sub_f32_e32 v202, v202, v30
		v_sub_f32_e32 v203, v203, v30
		v_sub_f32_e32 v206, v206, v30
		v_sub_f32_e32 v207, v207, v30
		v_sub_f32_e32 v208, v208, v30
		v_sub_f32_e32 v209, v209, v30
		v_sub_f32_e32 v124, v124, v30
		v_sub_f32_e32 v125, v125, v30
		v_sub_f32_e32 v210, v210, v30
		v_sub_f32_e32 v211, v211, v30
		v_sub_f32_e32 v128, v128, v30
		v_sub_f32_e32 v129, v129, v30
		v_sub_f32_e32 v214, v214, v30
		v_sub_f32_e32 v215, v215, v30
		v_sub_f32_e32 v216, v216, v30
		v_sub_f32_e32 v217, v217, v30
		v_sub_f32_e32 v218, v218, v30
		v_sub_f32_e32 v219, v219, v30
		v_sub_f32_e32 v132, v132, v30
		v_sub_f32_e32 v133, v133, v30
		v_sub_f32_e32 v134, v134, v30
		v_sub_f32_e32 v135, v135, v30
		v_sub_f32_e32 v136, v136, v30
		v_sub_f32_e32 v137, v137, v30
		v_sub_f32_e32 v222, v222, v30
		v_sub_f32_e32 v223, v223, v30
		v_sub_f32_e32 v226, v226, v30
		v_sub_f32_e32 v227, v227, v30
		v_sub_f32_e32 v228, v228, v30
		v_sub_f32_e32 v229, v229, v30
		v_sub_f32_e32 v106, v106, v30
		v_sub_f32_e32 v107, v107, v30
		v_sub_f32_e32 v140, v140, v30
		v_sub_f32_e32 v141, v141, v30
		v_sub_f32_e32 v110, v110, v30
		v_sub_f32_e32 v111, v111, v30
		v_sub_f32_e32 v142, v142, v30
		v_sub_f32_e32 v143, v143, v30
		v_sub_f32_e32 v176, v176, v30
		v_sub_f32_e32 v177, v177, v30
		v_sub_f32_e32 v178, v178, v30
		v_sub_f32_e32 v179, v179, v30
		v_sub_f32_e32 v114, v114, v30
		v_sub_f32_e32 v115, v115, v30
		v_sub_f32_e32 v118, v118, v30
		v_sub_f32_e32 v119, v119, v30
		v_sub_f32_e32 v122, v122, v30
		v_sub_f32_e32 v123, v123, v30
		v_exp_f32_e32 v232, v28
		v_exp_f32_e32 v234, v126
		v_exp_f32_e32 v233, v127
		v_exp_f32_e32 v235, v180
		v_exp_f32_e32 v126, v174
		v_exp_f32_e32 v236, v175
		v_exp_f32_e32 v127, v181
		v_exp_f32_e32 v237, v182
		v_exp_f32_e32 v174, v156
		v_exp_f32_e32 v180, v157
		v_exp_f32_e32 v175, v183
		v_exp_f32_e32 v181, v184
		v_exp_f32_e32 v156, v185
		v_exp_f32_e32 v182, v186
		v_exp_f32_e32 v157, v187
		v_exp_f32_e32 v183, v188
		v_exp_f32_e32 v184, v189
		v_exp_f32_e32 v186, v190
		v_exp_f32_e32 v185, v191
		v_exp_f32_e32 v187, v192
		v_exp_f32_e32 v188, v193
		v_exp_f32_e32 v190, v200
		v_exp_f32_e32 v189, v201
		v_exp_f32_e32 v191, v204
		v_exp_f32_e32 v192, v130
		v_exp_f32_e32 v200, v131
		v_exp_f32_e32 v193, v205
		v_exp_f32_e32 v201, v212
		v_exp_f32_e32 v130, v213
		v_exp_f32_e32 v204, v220
		v_exp_f32_e32 v131, v138
		v_exp_f32_e32 v205, v139
		v_exp_f32_e32 v138, v104
		v_exp_f32_e32 v212, v105
		v_exp_f32_e32 v139, v108
		v_exp_f32_e32 v213, v109
		v_exp_f32_e32 v104, v144
		v_exp_f32_e32 v108, v145
		v_exp_f32_e32 v105, v146
		v_exp_f32_e32 v109, v147
		v_exp_f32_e32 v144, v148
		v_exp_f32_e32 v146, v149
		v_exp_f32_e32 v145, v150
		v_exp_f32_e32 v147, v151
		v_exp_f32_e32 v148, v152
		v_exp_f32_e32 v150, v153
		v_exp_f32_e32 v149, v154
		v_exp_f32_e32 v151, v155
		v_exp_f32_e32 v152, v221
		v_exp_f32_e32 v154, v224
		v_exp_f32_e32 v153, v158
		v_exp_f32_e32 v155, v159
		v_exp_f32_e32 v158, v160
		v_exp_f32_e32 v220, v161
		v_exp_f32_e32 v159, v162
		v_exp_f32_e32 v221, v163
		v_exp_f32_e32 v160, v164
		v_exp_f32_e32 v162, v165
		v_exp_f32_e32 v161, v166
		v_exp_f32_e32 v163, v167
		v_exp_f32_e32 v164, v168
		v_exp_f32_e32 v166, v169
		v_exp_f32_e32 v165, v170
		v_exp_f32_e32 v167, v171
		v_exp_f32_e32 v169, v225
		v_exp_f32_e32 v171, v230
		v_exp_f32_e32 v224, v172
		v_exp_f32_e32 v230, v173
		v_exp_f32_e32 v225, v112
		v_exp_f32_e32 v231, v113
		v_exp_f32_e32 v112, v194
		v_exp_f32_e32 v172, v195
		v_exp_f32_e32 v113, v196
		v_exp_f32_e32 v173, v197
		v_exp_f32_e32 v194, v116
		v_exp_f32_e32 v196, v117
		v_exp_f32_e32 v195, v198
		v_exp_f32_e32 v197, v199
		v_exp_f32_e32 v116, v120
		v_exp_f32_e32 v198, v121
		v_exp_f32_e32 v117, v202
		v_exp_f32_e32 v199, v203
		v_exp_f32_e32 v120, v206
		v_exp_f32_e32 v202, v207
		v_exp_f32_e32 v121, v208
		v_exp_f32_e32 v203, v209
		v_exp_f32_e32 v206, v124
		v_exp_f32_e32 v208, v125
		v_exp_f32_e32 v207, v210
		v_exp_f32_e32 v209, v211
		v_exp_f32_e32 v124, v128
		v_exp_f32_e32 v210, v129
		v_exp_f32_e32 v125, v214
		v_exp_f32_e32 v211, v215
		v_exp_f32_e32 v128, v216
		v_exp_f32_e32 v214, v217
		v_exp_f32_e32 v129, v218
		v_exp_f32_e32 v215, v219
		v_exp_f32_e32 v216, v132
		v_exp_f32_e32 v218, v133
		v_exp_f32_e32 v217, v134
		v_exp_f32_e32 v219, v135
		v_exp_f32_e32 v132, v136
		v_exp_f32_e32 v134, v137
		v_exp_f32_e32 v133, v222
		v_exp_f32_e32 v135, v223
		v_exp_f32_e32 v136, v226
		v_exp_f32_e32 v222, v227
		v_exp_f32_e32 v137, v228
		v_exp_f32_e32 v223, v229
		v_exp_f32_e32 v226, v106
		v_exp_f32_e32 v228, v107
		v_exp_f32_e32 v227, v140
		v_exp_f32_e32 v229, v141
		v_exp_f32_e32 v106, v110
		v_exp_f32_e32 v140, v111
		v_exp_f32_e32 v107, v142
		v_exp_f32_e32 v141, v143
		v_exp_f32_e32 v110, v176
		v_exp_f32_e32 v142, v177
		v_exp_f32_e32 v111, v178
		v_exp_f32_e32 v143, v179
		v_exp_f32_e32 v176, v114
		v_exp_f32_e32 v178, v115
		v_exp_f32_e32 v177, v118
		v_exp_f32_e32 v179, v119
		v_exp_f32_e32 v114, v122
		v_exp_f32_e32 v118, v123
		v_pk_add_f32 v[122:123], v[232:233], v[234:235]
		v_pk_add_f32 v[238:239], v[126:127], v[236:237]
		v_pk_add_f32 v[240:241], v[174:175], v[180:181]
		v_pk_add_f32 v[242:243], v[156:157], v[182:183]
		v_pk_add_f32 v[244:245], v[184:185], v[186:187]
		v_pk_add_f32 v[246:247], v[188:189], v[190:191]
		v_pk_add_f32 v[248:249], v[192:193], v[200:201]
		v_pk_add_f32 v[250:251], v[130:131], v[204:205]
		v_pk_add_f32 v[252:253], v[138:139], v[212:213]
		v_accvgpr_write_b32 a132, v252
		v_accvgpr_write_b32 a133, v253
		v_pk_add_f32 v[252:253], v[104:105], v[108:109]
		v_accvgpr_write_b32 a134, v252
		v_accvgpr_write_b32 a135, v253
		v_pk_add_f32 v[252:253], v[144:145], v[146:147]
		v_accvgpr_write_b32 a136, v252
		v_accvgpr_write_b32 a137, v253
		v_pk_add_f32 v[252:253], v[148:149], v[150:151]
		v_accvgpr_write_b32 a138, v252
		v_accvgpr_write_b32 a139, v253
		v_pk_add_f32 v[252:253], v[152:153], v[154:155]
		v_accvgpr_write_b32 a140, v252
		v_accvgpr_write_b32 a141, v253
		v_pk_add_f32 v[252:253], v[158:159], v[220:221]
		v_accvgpr_write_b32 a142, v252
		v_accvgpr_write_b32 a143, v253
		v_pk_add_f32 v[252:253], v[160:161], v[162:163]
		v_accvgpr_write_b32 a144, v252
		v_accvgpr_write_b32 a145, v253
		v_pk_add_f32 v[252:253], v[164:165], v[166:167]
		v_accvgpr_write_b32 a146, v252
		v_accvgpr_write_b32 a147, v253
		v_mov_b32_e32 v252, v123
		v_mov_b32_e32 v253, v239
		v_mov_b32_e32 v254, v122
		v_mov_b32_e32 v255, v238
		v_pk_add_f32 v[122:123], v[254:255], v[252:253]
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
		v_accvgpr_read_b32 v28, a133
		v_mov_b32_e32 v238, v28
		v_accvgpr_read_b32 v28, a135
		v_mov_b32_e32 v239, v28
		v_accvgpr_read_b32 v28, a132
		v_mov_b32_e32 v242, v28
		v_accvgpr_read_b32 v28, a134
		v_mov_b32_e32 v243, v28
		v_pk_add_f32 v[248:249], v[242:243], v[238:239]
		v_accvgpr_read_b32 v28, a137
		v_mov_b32_e32 v238, v28
		v_accvgpr_read_b32 v28, a139
		v_mov_b32_e32 v239, v28
		v_accvgpr_read_b32 v28, a136
		v_mov_b32_e32 v242, v28
		v_accvgpr_read_b32 v28, a138
		v_mov_b32_e32 v243, v28
		v_pk_add_f32 v[250:251], v[242:243], v[238:239]
		v_accvgpr_read_b32 v28, a141
		v_mov_b32_e32 v238, v28
		v_accvgpr_read_b32 v28, a143
		v_mov_b32_e32 v239, v28
		v_accvgpr_read_b32 v28, a140
		v_mov_b32_e32 v242, v28
		v_accvgpr_read_b32 v28, a142
		v_mov_b32_e32 v243, v28
		v_pk_add_f32 v[252:253], v[242:243], v[238:239]
		v_accvgpr_read_b32 v28, a145
		v_mov_b32_e32 v238, v28
		v_accvgpr_read_b32 v28, a147
		v_mov_b32_e32 v239, v28
		v_accvgpr_read_b32 v28, a144
		v_mov_b32_e32 v242, v28
		v_accvgpr_read_b32 v28, a146
		v_mov_b32_e32 v243, v28
		v_pk_add_f32 v[254:255], v[242:243], v[238:239]
		v_mov_b32_e32 v238, v123
		v_mov_b32_e32 v239, v241
		v_mov_b32_e32 v242, v122
		v_mov_b32_e32 v243, v240
		v_pk_add_f32 v[122:123], v[242:243], v[238:239]
		v_mov_b32_e32 v238, v245
		v_mov_b32_e32 v239, v247
		v_mov_b32_e32 v240, v244
		v_mov_b32_e32 v241, v246
		v_pk_add_f32 v[242:243], v[240:241], v[238:239]
		v_mov_b32_e32 v238, v249
		v_mov_b32_e32 v239, v251
		v_mov_b32_e32 v240, v248
		v_mov_b32_e32 v241, v250
		v_pk_add_f32 v[244:245], v[240:241], v[238:239]
		v_mov_b32_e32 v238, v253
		v_mov_b32_e32 v239, v255
		v_mov_b32_e32 v240, v252
		v_mov_b32_e32 v241, v254
		v_pk_add_f32 v[246:247], v[240:241], v[238:239]
		v_mov_b32_e32 v238, v123
		v_mov_b32_e32 v239, v243
		v_mov_b32_e32 v240, v122
		v_mov_b32_e32 v241, v242
		v_pk_add_f32 v[122:123], v[240:241], v[238:239]
		v_mov_b32_e32 v238, v245
		v_mov_b32_e32 v239, v247
		v_mov_b32_e32 v240, v244
		v_mov_b32_e32 v241, v246
		v_pk_add_f32 v[242:243], v[240:241], v[238:239]
		v_mov_b32_e32 v238, v123
		v_mov_b32_e32 v239, v243
		v_mov_b32_e32 v240, v122
		v_mov_b32_e32 v241, v242
		v_pk_add_f32 v[122:123], v[240:241], v[238:239]
		v_add_f32_e32 v28, v122, v123
		ds_bpermute_b32 v168, v23, v28
		ds_bpermute_b32 v170, v29, v28
		v_pk_add_f32 v[122:123], v[224:225], v[230:231]
		v_pk_add_f32 v[238:239], v[112:113], v[172:173]
		v_accvgpr_write_b32 a132, v238
		v_accvgpr_write_b32 a133, v239
		v_pk_add_f32 v[238:239], v[194:195], v[196:197]
		v_pk_add_f32 v[240:241], v[116:117], v[198:199]
		v_accvgpr_write_b32 a134, v240
		v_accvgpr_write_b32 a135, v241
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[240:241], v[168:169], v[170:171]
		v_pk_add_f32 v[242:243], v[120:121], v[202:203]
		v_pk_add_f32 v[244:245], v[206:207], v[208:209]
		v_accvgpr_write_b32 a136, v244
		v_accvgpr_write_b32 a137, v245
		v_pk_add_f32 v[244:245], v[124:125], v[210:211]
		v_pk_add_f32 v[246:247], v[128:129], v[214:215]
		v_accvgpr_write_b32 a138, v246
		v_accvgpr_write_b32 a139, v247
		v_pk_add_f32 v[246:247], v[216:217], v[218:219]
		v_pk_add_f32 v[248:249], v[132:133], v[134:135]
		v_accvgpr_write_b32 a140, v248
		v_accvgpr_write_b32 a141, v249
		v_pk_add_f32 v[248:249], v[136:137], v[222:223]
		v_pk_add_f32 v[250:251], v[226:227], v[228:229]
		v_accvgpr_write_b32 a142, v250
		v_accvgpr_write_b32 a143, v251
		v_pk_add_f32 v[250:251], v[106:107], v[140:141]
		v_pk_add_f32 v[252:253], v[110:111], v[142:143]
		v_accvgpr_write_b32 a144, v252
		v_accvgpr_write_b32 a145, v253
		v_pk_add_f32 v[252:253], v[176:177], v[178:179]
		v_accvgpr_write_b32 a146, v252
		v_accvgpr_write_b32 a147, v253
		v_mov_b32_e32 v115, v241
		v_mov_b32_e32 v119, v122
		v_pk_add_f32 v[252:253], v[114:115], v[118:119]
		v_accvgpr_write_b32 a148, v252
		v_accvgpr_write_b32 a149, v253
		v_mov_b32_e32 v252, v123
		v_mov_b32_e32 v253, v238
		v_accvgpr_read_b32 v122, a132
		v_accvgpr_read_b32 v123, a133
		v_pk_add_f32 v[254:255], v[252:253], v[122:123]
		v_mov_b32_e32 v122, v239
		v_mov_b32_e32 v123, v242
		v_accvgpr_read_b32 v238, a134
		v_accvgpr_read_b32 v239, a135
		v_pk_add_f32 v[122:123], v[122:123], v[238:239]
		v_mov_b32_e32 v238, v243
		v_mov_b32_e32 v239, v244
		v_accvgpr_read_b32 v242, a136
		v_accvgpr_read_b32 v243, a137
		v_pk_add_f32 v[252:253], v[238:239], v[242:243]
		v_mov_b32_e32 v238, v245
		v_mov_b32_e32 v239, v246
		v_accvgpr_read_b32 v242, a138
		v_accvgpr_read_b32 v243, a139
		v_pk_add_f32 v[238:239], v[238:239], v[242:243]
		v_mov_b32_e32 v242, v247
		v_mov_b32_e32 v243, v248
		v_accvgpr_read_b32 v244, a140
		v_accvgpr_read_b32 v245, a141
		v_pk_add_f32 v[246:247], v[242:243], v[244:245]
		v_mov_b32_e32 v242, v249
		v_mov_b32_e32 v243, v250
		v_accvgpr_read_b32 v244, a142
		v_accvgpr_read_b32 v245, a143
		v_pk_add_f32 v[242:243], v[242:243], v[244:245]
		v_mov_b32_e32 v244, v251
		v_accvgpr_read_b32 v28, a146
		v_mov_b32_e32 v245, v28
		v_accvgpr_read_b32 v248, a144
		v_accvgpr_read_b32 v249, a145
		v_pk_add_f32 v[250:251], v[244:245], v[248:249]
		v_accvgpr_read_b32 v28, a147
		v_mov_b32_e32 v244, v28
		v_mov_b32_e32 v245, v254
		v_accvgpr_read_b32 v248, a148
		v_accvgpr_read_b32 v249, a149
		v_pk_add_f32 v[244:245], v[244:245], v[248:249]
		v_mov_b32_e32 v248, v255
		v_mov_b32_e32 v249, v252
		v_pk_add_f32 v[254:255], v[248:249], v[122:123]
		v_mov_b32_e32 v122, v253
		v_mov_b32_e32 v123, v246
		v_pk_add_f32 v[122:123], v[122:123], v[238:239]
		v_mov_b32_e32 v238, v247
		v_mov_b32_e32 v239, v250
		v_pk_add_f32 v[246:247], v[238:239], v[242:243]
		v_mov_b32_e32 v238, v251
		v_mov_b32_e32 v239, v254
		v_pk_add_f32 v[238:239], v[238:239], v[244:245]
		v_mov_b32_e32 v242, v255
		v_mov_b32_e32 v243, v246
		v_pk_add_f32 v[244:245], v[242:243], v[122:123]
		v_mov_b32_e32 v122, v247
		v_mov_b32_e32 v123, v244
		v_pk_add_f32 v[242:243], v[122:123], v[238:239]
		v_add_f32_e32 v28, v245, v242
		v_add_f32_e32 v28, v243, v28
		ds_bpermute_b32 v115, v23, v28
		ds_bpermute_b32 v23, v29, v28
		s_mov_b32 m0, s18
		s_nop 0
		ds_read_addtid_b32 v28 offset:18432
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s18
		v_sub_f32_e32 v28, v28, v21
		ds_read_addtid_b32 v29 offset:19456
		s_waitcnt lgkmcnt(0)
		v_sub_f32_e32 v29, v29, v30
		v_exp_f32_e32 v122, v28
		v_exp_f32_e32 v238, v29
		v_add_f32_e32 v243, v115, v23
		v_mov_b32_e32 v123, v122
		v_pk_mul_f32 v[32:33], v[32:33], v[122:123]
		v_pk_mul_f32 v[34:35], v[34:35], v[122:123]
		v_pk_mul_f32 v[36:37], v[36:37], v[122:123]
		v_pk_mul_f32 v[38:39], v[38:39], v[122:123]
		v_pk_mul_f32 v[40:41], v[40:41], v[122:123]
		v_pk_mul_f32 v[42:43], v[42:43], v[122:123]
		v_pk_mul_f32 v[44:45], v[44:45], v[122:123]
		v_pk_mul_f32 v[46:47], v[46:47], v[122:123]
		v_pk_mul_f32 v[48:49], v[48:49], v[122:123]
		v_pk_mul_f32 v[50:51], v[50:51], v[122:123]
		v_pk_mul_f32 v[52:53], v[52:53], v[122:123]
		v_pk_mul_f32 v[54:55], v[54:55], v[122:123]
		v_pk_mul_f32 v[56:57], v[56:57], v[122:123]
		v_pk_mul_f32 v[58:59], v[58:59], v[122:123]
		v_pk_mul_f32 v[60:61], v[60:61], v[122:123]
		v_pk_mul_f32 v[62:63], v[62:63], v[122:123]
		v_mov_b32_e32 v239, v238
		v_pk_mul_f32 v[64:65], v[64:65], v[238:239]
		v_pk_mul_f32 v[66:67], v[66:67], v[238:239]
		v_pk_mul_f32 v[68:69], v[68:69], v[238:239]
		v_pk_mul_f32 v[70:71], v[70:71], v[238:239]
		v_pk_mul_f32 v[72:73], v[72:73], v[238:239]
		v_pk_mul_f32 v[74:75], v[74:75], v[238:239]
		v_pk_mul_f32 v[76:77], v[76:77], v[238:239]
		v_pk_mul_f32 v[78:79], v[78:79], v[238:239]
		v_pk_mul_f32 v[80:81], v[80:81], v[238:239]
		v_pk_mul_f32 v[82:83], v[82:83], v[238:239]
		v_pk_mul_f32 v[84:85], v[84:85], v[238:239]
		v_pk_mul_f32 v[86:87], v[86:87], v[238:239]
		v_pk_mul_f32 v[88:89], v[88:89], v[238:239]
		v_pk_mul_f32 v[90:91], v[90:91], v[238:239]
		v_pk_mul_f32 v[92:93], v[92:93], v[238:239]
		v_pk_mul_f32 v[94:95], v[94:95], v[238:239]
		v_mov_b32_e32 v242, v240
		v_mov_b32_e32 v240, v122
		s_mov_b32 m0, s17
		v_mov_b32_e32 v241, v238
		ds_read_addtid_b32 v23 offset:28672
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s17
		v_mov_b32_e32 v122, v23
		ds_read_addtid_b32 v23 offset:29696
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v123, v23
		v_pk_fma_f32 v[28:29], v[122:123], v[240:241], v[242:243]
		v_cvt_pk_bf16_f32 v240, v232, v234
		v_cvt_pk_bf16_f32 v241, v233, v235
		v_cvt_pk_bf16_f32 v242, v126, v236
		v_cvt_pk_bf16_f32 v243, v127, v237
		v_cvt_pk_bf16_f32 v232, v174, v180
		v_cvt_pk_bf16_f32 v233, v175, v181
		v_cvt_pk_bf16_f32 v234, v156, v182
		v_cvt_pk_bf16_f32 v235, v157, v183
		v_cvt_pk_bf16_f32 v180, v184, v186
		v_cvt_pk_bf16_f32 v181, v185, v187
		v_cvt_pk_bf16_f32 v182, v188, v190
		v_cvt_pk_bf16_f32 v183, v189, v191
		v_cvt_pk_bf16_f32 v184, v192, v200
		v_cvt_pk_bf16_f32 v185, v193, v201
		v_cvt_pk_bf16_f32 v186, v130, v204
		v_cvt_pk_bf16_f32 v187, v131, v205
		v_cvt_pk_bf16_f32 v188, v138, v212
		v_cvt_pk_bf16_f32 v189, v139, v213
		v_cvt_pk_bf16_f32 v190, v104, v108
		v_cvt_pk_bf16_f32 v191, v105, v109
		v_cvt_pk_bf16_f32 v236, v144, v146
		v_cvt_pk_bf16_f32 v237, v145, v147
		v_cvt_pk_bf16_f32 v238, v148, v150
		v_cvt_pk_bf16_f32 v239, v149, v151
		v_cvt_pk_bf16_f32 v144, v152, v154
		v_cvt_pk_bf16_f32 v145, v153, v155
		v_cvt_pk_bf16_f32 v146, v158, v220
		v_cvt_pk_bf16_f32 v147, v159, v221
		v_cvt_pk_bf16_f32 v148, v160, v162
		v_cvt_pk_bf16_f32 v149, v161, v163
		v_cvt_pk_bf16_f32 v150, v164, v166
		v_cvt_pk_bf16_f32 v151, v165, v167
		v_cvt_pk_bf16_f32 v152, v169, v171
		v_cvt_pk_bf16_f32 v153, v224, v230
		v_cvt_pk_bf16_f32 v154, v225, v231
		v_cvt_pk_bf16_f32 v155, v112, v172
		v_cvt_pk_bf16_f32 v156, v113, v173
		v_cvt_pk_bf16_f32 v157, v194, v196
		v_cvt_pk_bf16_f32 v158, v195, v197
		v_cvt_pk_bf16_f32 v159, v116, v198
		v_cvt_pk_bf16_f32 v160, v117, v199
		v_cvt_pk_bf16_f32 v161, v120, v202
		v_cvt_pk_bf16_f32 v162, v121, v203
		v_cvt_pk_bf16_f32 v163, v206, v208
		v_cvt_pk_bf16_f32 v120, v207, v209
		v_cvt_pk_bf16_f32 v121, v124, v210
		v_cvt_pk_bf16_f32 v122, v125, v211
		v_cvt_pk_bf16_f32 v123, v128, v214
		v_cvt_pk_bf16_f32 v124, v129, v215
		v_cvt_pk_bf16_f32 v125, v216, v218
		v_cvt_pk_bf16_f32 v126, v217, v219
		v_cvt_pk_bf16_f32 v127, v132, v134
		v_cvt_pk_bf16_f32 v128, v133, v135
		v_cvt_pk_bf16_f32 v129, v136, v222
		v_cvt_pk_bf16_f32 v130, v137, v223
		v_cvt_pk_bf16_f32 v131, v226, v228
		v_cvt_pk_bf16_f32 v132, v227, v229
		v_cvt_pk_bf16_f32 v133, v106, v140
		v_cvt_pk_bf16_f32 v134, v107, v141
		v_cvt_pk_bf16_f32 v135, v110, v142
		v_cvt_pk_bf16_f32 v104, v111, v143
		v_cvt_pk_bf16_f32 v105, v176, v178
		v_cvt_pk_bf16_f32 v106, v177, v179
		v_cvt_pk_bf16_f32 v107, v114, v118
		v_permlane32_swap_b32_e32 v240, v242
		v_permlane32_swap_b32_e32 v241, v243
		v_permlane32_swap_b32_e32 v232, v234
		v_permlane32_swap_b32_e32 v233, v235
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_permlane32_swap_b32_e32 v236, v238
		v_permlane32_swap_b32_e32 v237, v239
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_permlane32_swap_b32_e32 v148, v150
		v_permlane32_swap_b32_e32 v149, v151
		v_permlane32_swap_b32_e32 v152, v154
		v_permlane32_swap_b32_e32 v153, v155
		v_permlane32_swap_b32_e32 v156, v158
		v_permlane32_swap_b32_e32 v157, v159
		v_permlane32_swap_b32_e32 v160, v162
		v_permlane32_swap_b32_e32 v161, v163
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[240:243], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[240:243], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[152:155], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[152:155], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[232:235], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[232:235], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[156:159], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[156:159], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[180:183], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[180:183], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[160:163], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[160:163], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[184:187], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[184:187], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[120:123], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[120:123], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[188:191], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[188:191], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[124:127], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[124:127], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[236:239], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[236:239], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[128:131], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[128:131], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[216:219], v[144:147], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[248:251], v[144:147], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[248:251], v[132:135], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[216:219], v[132:135], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[220:223], v[148:151], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[252:255], v[148:151], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[252:255], v[104:107], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[220:223], v[104:107], v[64:79]
		s_add_i32 s22, s46, 0x80
		s_cmp_lt_i32 s22, s27
		s_mov_b32 s46, s22
		v_mov_b32_e32 v23, v21
		v_mov_b32_e32 v21, v30
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_2
.L_attn_fwd_persistent.loop_exit_2:
		s_mov_b32 m0, s17
		s_nop 0
		ds_read_addtid_b32 v6 offset:24576
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s22, v6
		s_lshl_b32 s22, s22, 2
		s_add_i32 s22, s22, 0x189b0
		s_mov_b32 m0, s22
		s_nop 0
		ds_read_addtid_b32 v6 offset:3072
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s18
		v_readfirstlane_b32 s26, v6
		ds_read_addtid_b32 v6 offset:11264
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s27, v6
		s_mul_i32 s26, s26, s27
		s_mov_b32 m0, s17
		s_lshl_b32 s26, s26, 9
		ds_read_addtid_b32 v6 offset:24576
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s27, v6
		s_lshl_b32 s27, s27, 2
		s_add_i32 s27, s27, 0x189b0
		v_mov_b32_e32 v6, s27
		s_nop 0
		v_readfirstlane_b32 s27, v6
		s_mov_b32 m0, s27
		s_nop 0
		ds_read_addtid_b32 v7
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s27, v7
		s_mul_i32 s27, s1, s27
		s_lshl_b32 s27, s27, 1
		s_add_i32 s37, s26, s27
		v_readfirstlane_b32 s38, v6
		s_mov_b32 m0, s38
		s_nop 0
		ds_read_addtid_b32 v6 offset:1024
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s38, v6
		s_mul_i32 s38, s25, s38
		s_lshl_b32 s38, s38, 1
		s_add_i32 s37, s37, s38
		s_add_i32 s39, s26, 32
		s_add_i32 s39, s39, s27
		s_add_i32 s39, s39, s38
		s_add_i32 s44, s26, 64
		s_add_i32 s44, s44, s27
		s_add_i32 s44, s44, s38
		s_add_i32 s26, s26, 0x60
		s_add_i32 s26, s26, s27
		s_add_i32 s26, s26, s38
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
		v_accvgpr_read_b32 v6, a1
		v_add_u32_e32 v6, s46, v6
		v_accvgpr_read_b32 v7, a2
		v_add_u32_e32 v7, s46, v7
		v_cmp_lt_i32_e64 vcc, v6, s23
		s_mov_b64 s[48:49], vcc
		v_cmp_lt_i32_e64 vcc, v7, s23
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v6, a3
		v_add_u32_e32 v6, s46, v6
		v_cmp_lt_i32_e64 vcc, v6, s23
		s_mov_b64 s[52:53], vcc
		s_mul_i32 s47, s45, s12
		s_lshl_b32 s47, s47, 9
		s_mul_i32 s54, s1, s10
		s_lshl_b32 s54, s54, 1
		s_add_i32 s47, s47, s54
		s_mul_i32 s54, s25, s11
		s_lshl_b32 s54, s54, 1
		s_add_i32 s47, s47, s54
		v_accvgpr_read_b32 v6, a4
		v_accvgpr_read_b32 v7, a6
		v_add3_u32 v6, s47, v6, v7
		v_accvgpr_read_b32 v7, a8
		v_accvgpr_read_b32 v9, a10
		v_add3_u32 v6, v6, v7, v9
		v_accvgpr_read_b32 v7, a12
		v_accvgpr_read_b32 v9, a14
		v_add3_u32 v6, v6, v7, v9
		v_accvgpr_read_b32 v7, a16
		v_accvgpr_read_b32 v9, a18
		v_add3_u32 v6, v6, v7, v9
		v_mov_b32_e32 v7, 0x80000000
		v_cndmask_b32_e64 v6, v7, v6, s[52:53]
		buffer_load_dwordx4 v[16:19], v6, s[40:43], 0 offen
		v_accvgpr_read_b32 v6, a19
		v_add_u32_e32 v6, s46, v6
		v_cmp_lt_i32_e64 vcc, v6, s23
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v6, a20
		v_accvgpr_read_b32 v9, a14
		v_add3_u32 v6, s47, v6, v9
		v_accvgpr_read_b32 v9, a16
		v_accvgpr_read_b32 v10, a18
		v_add3_u32 v6, v6, v9, v10
		v_cndmask_b32_e64 v6, v7, v6, s[52:53]
		buffer_load_dwordx4 v[24:27], v6, s[40:43], 0 offen
		v_accvgpr_read_b32 v6, a21
		v_add_u32_e32 v6, s46, v6
		v_cmp_lt_i32_e64 vcc, v6, s23
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v6, a14
		v_accvgpr_read_b32 v9, a16
		v_accvgpr_read_b32 v10, a18
		v_add3_u32 v6, v6, v9, v10
		v_accvgpr_read_b32 v9, a22
		v_add3_u32 v9, v9, v6, s47
		v_cndmask_b32_e64 v9, v7, v9, s[52:53]
		buffer_load_dwordx4 v[96:99], v9, s[40:43], 0 offen
		v_accvgpr_read_b32 v9, a23
		v_add_u32_e32 v9, s46, v9
		v_cmp_lt_i32_e64 vcc, v9, s23
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v9, a24
		v_add3_u32 v9, v9, v6, s47
		v_cndmask_b32_e64 v9, v7, v9, s[52:53]
		buffer_load_dwordx4 v[100:103], v9, s[40:43], 0 offen
		v_accvgpr_read_b32 v9, a25
		v_add_u32_e32 v9, s46, v9
		v_cmp_lt_i32_e64 vcc, v9, s23
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v9, a26
		v_add3_u32 v6, v9, v6, s47
		v_cndmask_b32_e64 v6, v7, v6, s[52:53]
		buffer_load_dwordx4 v[104:107], v6, s[40:43], 0 offen
		v_accvgpr_read_b32 v6, a27
		v_add_u32_e32 v6, s46, v6
		v_cmp_lt_i32_e64 vcc, v6, s23
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v6, a14
		v_accvgpr_read_b32 v9, a16
		v_accvgpr_read_b32 v10, a18
		v_add3_u32 v6, v6, v9, v10
		v_accvgpr_read_b32 v9, a28
		v_add3_u32 v9, v9, v6, s47
		v_cndmask_b32_e64 v9, v7, v9, s[52:53]
		buffer_load_dwordx4 v[108:111], v9, s[40:43], 0 offen
		v_accvgpr_read_b32 v9, a29
		v_add_u32_e32 v9, s46, v9
		v_cmp_lt_i32_e64 vcc, v9, s23
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v9, a30
		v_add3_u32 v9, v9, v6, s47
		v_cndmask_b32_e64 v9, v7, v9, s[52:53]
		buffer_load_dwordx4 v[112:115], v9, s[40:43], 0 offen
		v_accvgpr_read_b32 v9, a31
		v_add_u32_e32 v9, s46, v9
		v_cmp_lt_i32_e64 vcc, v9, s23
		v_accvgpr_read_b32 v9, a32
		v_add3_u32 v6, v9, v6, s47
		v_rcp_f32_e32 v10, v28
		v_cndmask_b32_e32 v6, v7, v6, vcc
		buffer_load_dwordx4 v[116:119], v6, s[40:43], 0 offen
		s_waitcnt vmcnt(8)
		s_barrier
		v_accvgpr_read_b32 v6, a33
		s_waitcnt vmcnt(7)
		ds_write_b128 v6, v[16:19] offset:18864
		v_accvgpr_read_b32 v6, a33
		s_waitcnt vmcnt(6)
		ds_write_b128 v6, v[24:27] offset:22960
		v_accvgpr_read_b32 v6, a33
		s_waitcnt vmcnt(5)
		ds_write_b128 v6, v[96:99] offset:27056
		v_accvgpr_read_b32 v6, a33
		s_waitcnt vmcnt(4)
		ds_write_b128 v6, v[100:103] offset:31152
		v_mov_b32_e32 v11, v10
		v_pk_mul_f32 v[12:13], v[32:33], v[10:11]
		v_pk_mul_f32 v[16:17], v[34:35], v[10:11]
		v_pk_mul_f32 v[18:19], v[36:37], v[10:11]
		v_pk_mul_f32 v[20:21], v[38:39], v[10:11]
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_pk_mul_f32 v[24:25], v[40:41], v[10:11]
		v_pk_mul_f32 v[26:27], v[42:43], v[10:11]
		v_pk_mul_f32 v[30:31], v[44:45], v[10:11]
		v_pk_mul_f32 v[32:33], v[46:47], v[10:11]
		v_pk_mul_f32 v[34:35], v[48:49], v[10:11]
		v_pk_mul_f32 v[36:37], v[50:51], v[10:11]
		v_pk_mul_f32 v[38:39], v[52:53], v[10:11]
		v_pk_mul_f32 v[40:41], v[54:55], v[10:11]
		v_pk_mul_f32 v[42:43], v[56:57], v[10:11]
		v_pk_mul_f32 v[44:45], v[58:59], v[10:11]
		v_pk_mul_f32 v[46:47], v[60:61], v[10:11]
		v_pk_mul_f32 v[48:49], v[62:63], v[10:11]
		v_rcp_f32_e32 v10, v29
		v_cvt_pk_bf16_f32 v52, v12, v13
		v_mov_b32_e32 v11, v10
		v_pk_mul_f32 v[12:13], v[64:65], v[10:11]
		v_pk_mul_f32 v[28:29], v[66:67], v[10:11]
		v_pk_mul_f32 v[50:51], v[68:69], v[10:11]
		v_pk_mul_f32 v[56:57], v[70:71], v[10:11]
		v_pk_mul_f32 v[58:59], v[72:73], v[10:11]
		v_pk_mul_f32 v[60:61], v[74:75], v[10:11]
		v_pk_mul_f32 v[62:63], v[76:77], v[10:11]
		v_pk_mul_f32 v[64:65], v[78:79], v[10:11]
		v_pk_mul_f32 v[66:67], v[80:81], v[10:11]
		v_pk_mul_f32 v[68:69], v[82:83], v[10:11]
		v_pk_mul_f32 v[70:71], v[84:85], v[10:11]
		v_pk_mul_f32 v[72:73], v[86:87], v[10:11]
		v_pk_mul_f32 v[74:75], v[88:89], v[10:11]
		v_pk_mul_f32 v[76:77], v[90:91], v[10:11]
		v_pk_mul_f32 v[78:79], v[92:93], v[10:11]
		v_pk_mul_f32 v[80:81], v[94:95], v[10:11]
		v_cvt_pk_bf16_f32 v53, v16, v17
		v_cvt_pk_bf16_f32 v54, v18, v19
		v_cvt_pk_bf16_f32 v55, v20, v21
		v_cvt_pk_bf16_f32 v16, v24, v25
		v_cvt_pk_bf16_f32 v17, v26, v27
		v_cvt_pk_bf16_f32 v18, v30, v31
		v_cvt_pk_bf16_f32 v19, v32, v33
		v_cvt_pk_bf16_f32 v24, v34, v35
		v_cvt_pk_bf16_f32 v25, v36, v37
		v_cvt_pk_bf16_f32 v26, v38, v39
		v_cvt_pk_bf16_f32 v27, v40, v41
		v_cvt_pk_bf16_f32 v32, v42, v43
		v_cvt_pk_bf16_f32 v33, v44, v45
		v_cvt_pk_bf16_f32 v34, v46, v47
		v_cvt_pk_bf16_f32 v35, v48, v49
		v_cvt_pk_bf16_f32 v36, v12, v13
		v_cvt_pk_bf16_f32 v37, v28, v29
		v_cvt_pk_bf16_f32 v38, v50, v51
		v_cvt_pk_bf16_f32 v39, v56, v57
		v_cvt_pk_bf16_f32 v28, v58, v59
		v_cvt_pk_bf16_f32 v29, v60, v61
		v_cvt_pk_bf16_f32 v30, v62, v63
		v_cvt_pk_bf16_f32 v31, v64, v65
		v_cvt_pk_bf16_f32 v40, v66, v67
		v_cvt_pk_bf16_f32 v41, v68, v69
		v_cvt_pk_bf16_f32 v42, v70, v71
		v_cvt_pk_bf16_f32 v43, v72, v73
		v_cvt_pk_bf16_f32 v44, v74, v75
		v_cvt_pk_bf16_f32 v45, v76, v77
		v_cvt_pk_bf16_f32 v46, v78, v79
		v_cvt_pk_bf16_f32 v47, v80, v81
		v_permlane32_swap_b32_e32 v52, v54
		v_permlane32_swap_b32_e32 v53, v55
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_permlane32_swap_b32_e32 v32, v34
		v_permlane32_swap_b32_e32 v33, v35
		v_permlane32_swap_b32_e32 v36, v38
		v_permlane32_swap_b32_e32 v37, v39
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_permlane32_swap_b32_e32 v40, v42
		v_permlane32_swap_b32_e32 v41, v43
		v_permlane32_swap_b32_e32 v44, v46
		v_permlane32_swap_b32_e32 v45, v47
		s_mov_b32 m0, s18
		v_accvgpr_read_b32 v6, a0
		ds_read_addtid_b32 v9 offset:11264
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s40, v9
		s_nop 1
		v_mul_lo_u32 v6, s40, v6
		v_lshlrev_b32_e32 v6, 7, v6
		v_accvgpr_write_b32 a1, v6
		s_mov_b32 m0, s18
		v_accvgpr_read_b32 v6, a13
		ds_read_addtid_b32 v9 offset:11264
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s40, v9
		s_nop 1
		v_mul_lo_u32 v6, s40, v6
		v_lshlrev_b32_e32 v6, 1, v6
		v_accvgpr_write_b32 a2, v6
		v_accvgpr_read_b32 v6, a1
		v_accvgpr_read_b32 v9, a2
		v_add3_u32 v6, s37, v6, v9
		s_mov_b32 m0, s18
		v_accvgpr_read_b32 v9, a5
		ds_read_addtid_b32 v10 offset:11264
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s40, v10
		s_nop 1
		v_mul_lo_u32 v9, s40, v9
		v_lshlrev_b32_e32 v9, 6, v9
		v_accvgpr_write_b32 a3, v9
		s_mov_b32 m0, s18
		v_accvgpr_read_b32 v9, a9
		ds_read_addtid_b32 v10 offset:11264
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s40, v10
		s_nop 1
		v_mul_lo_u32 v9, s40, v9
		v_lshlrev_b32_e32 v9, 5, v9
		v_accvgpr_write_b32 a4, v9
		v_accvgpr_read_b32 v9, a3
		v_accvgpr_read_b32 v10, a4
		v_add3_u32 v6, v6, v9, v10
		s_mov_b32 m0, s18
		v_accvgpr_read_b32 v9, a11
		ds_read_addtid_b32 v10 offset:11264
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s40, v10
		s_nop 1
		v_mul_lo_u32 v9, s40, v9
		v_lshlrev_b32_e32 v9, 4, v9
		v_accvgpr_write_b32 a6, v9
		s_mov_b32 m0, s18
		v_accvgpr_read_b32 v9, a15
		ds_read_addtid_b32 v10 offset:11264
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s40, v10
		s_nop 1
		v_mul_lo_u32 v9, s40, v9
		v_lshlrev_b32_e32 v9, 3, v9
		v_accvgpr_write_b32 a8, v9
		v_accvgpr_read_b32 v9, a6
		v_accvgpr_read_b32 v10, a8
		v_add3_u32 v6, v6, v9, v10
		s_mov_b32 m0, s18
		v_accvgpr_read_b32 v9, a17
		ds_read_addtid_b32 v10 offset:11264
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s40, v10
		s_nop 1
		v_mul_lo_u32 v9, s40, v9
		v_lshlrev_b32_e32 v9, 2, v9
		v_accvgpr_write_b32 a10, v9
		v_accvgpr_read_b32 v9, a7
		v_lshlrev_b32_e32 v9, 4, v9
		v_accvgpr_write_b32 a7, v9
		v_accvgpr_read_b32 v9, a10
		v_accvgpr_read_b32 v10, a7
		s_mov_b32 m0, s22
		v_add3_u32 v6, v6, v9, v10
		ds_read_addtid_b32 v10 offset:7168
		s_mov_b32 m0, s22
		s_nop 0
		ds_read_addtid_b32 v11 offset:8192
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s40, v10
		v_readfirstlane_b32 s41, v11
		s_nop 1
		v_cndmask_b32_e64 v6, v7, v6, s[40:41]
		s_mov_b32 s40, s8
		s_mov_b32 s41, s9
		s_mov_b32 s42, s30
		s_mov_b32 s43, s31
		buffer_store_dwordx4 v[52:55], v6, s[40:43], 0 offen
		v_accvgpr_read_b32 v6, a1
		v_accvgpr_read_b32 v9, a2
		v_add3_u32 v6, s39, v6, v9
		v_accvgpr_read_b32 v9, a3
		v_accvgpr_read_b32 v10, a4
		v_add3_u32 v6, v6, v9, v10
		v_accvgpr_read_b32 v9, a6
		v_accvgpr_read_b32 v10, a8
		v_add3_u32 v6, v6, v9, v10
		v_accvgpr_read_b32 v9, a10
		v_accvgpr_read_b32 v10, a7
		s_mov_b32 m0, s22
		v_add3_u32 v6, v6, v9, v10
		ds_read_addtid_b32 v10 offset:7168
		s_mov_b32 m0, s22
		s_nop 0
		ds_read_addtid_b32 v11 offset:8192
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s52, v10
		v_readfirstlane_b32 s53, v11
		s_nop 1
		v_cndmask_b32_e64 v6, v7, v6, s[52:53]
		buffer_store_dwordx4 v[16:19], v6, s[40:43], 0 offen
		v_accvgpr_read_b32 v6, a1
		v_accvgpr_read_b32 v9, a2
		v_add3_u32 v6, s44, v6, v9
		v_accvgpr_read_b32 v9, a3
		v_accvgpr_read_b32 v10, a4
		v_add3_u32 v6, v6, v9, v10
		v_accvgpr_read_b32 v9, a6
		v_accvgpr_read_b32 v10, a8
		v_add3_u32 v6, v6, v9, v10
		v_accvgpr_read_b32 v9, a10
		v_accvgpr_read_b32 v10, a7
		s_mov_b32 m0, s22
		v_add3_u32 v6, v6, v9, v10
		ds_read_addtid_b32 v10 offset:7168
		s_mov_b32 m0, s22
		s_nop 0
		ds_read_addtid_b32 v11 offset:8192
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s52, v10
		v_readfirstlane_b32 s53, v11
		s_nop 1
		v_cndmask_b32_e64 v6, v7, v6, s[52:53]
		buffer_store_dwordx4 v[24:27], v6, s[40:43], 0 offen
		v_accvgpr_read_b32 v6, a1
		v_accvgpr_read_b32 v9, a2
		v_add3_u32 v6, s26, v6, v9
		v_accvgpr_read_b32 v9, a3
		v_accvgpr_read_b32 v10, a4
		v_add3_u32 v6, v6, v9, v10
		v_accvgpr_read_b32 v9, a6
		v_accvgpr_read_b32 v10, a8
		v_add3_u32 v6, v6, v9, v10
		v_accvgpr_read_b32 v9, a10
		v_accvgpr_read_b32 v10, a7
		s_mov_b32 m0, s22
		v_add3_u32 v6, v6, v9, v10
		ds_read_addtid_b32 v10 offset:7168
		s_mov_b32 m0, s22
		s_nop 0
		ds_read_addtid_b32 v11 offset:8192
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s52, v10
		v_readfirstlane_b32 s53, v11
		s_nop 1
		v_cndmask_b32_e64 v6, v7, v6, s[52:53]
		buffer_store_dwordx4 v[32:35], v6, s[40:43], 0 offen
		v_accvgpr_read_b32 v6, a0
		v_lshlrev_b32_e32 v6, 6, v6
		v_accvgpr_read_b32 v9, a5
		v_lshlrev_b32_e32 v9, 5, v9
		v_accvgpr_read_b32 v10, a9
		v_lshlrev_b32_e32 v10, 4, v10
		v_accvgpr_read_b32 v11, a11
		v_lshlrev_b32_e32 v11, 3, v11
		v_accvgpr_read_b32 v12, a15
		v_lshlrev_b32_e32 v12, 2, v12
		v_accvgpr_read_b32 v13, a13
		v_add_u32_e32 v13, 0x80, v13
		v_accvgpr_read_b32 v16, a17
		v_lshlrev_b32_e32 v16, 1, v16
		v_bitop3_b32 v12, v12, v13, v16 bitop3:0x96
		v_bitop3_b32 v10, v10, v11, v12 bitop3:0x96
		s_mov_b32 m0, s18
		v_bitop3_b32 v6, v6, v9, v10 bitop3:0x96
		ds_read_addtid_b32 v9 offset:11264
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s47, v9
		s_nop 1
		v_mul_lo_u32 v6, s47, v6
		v_lshlrev_b32_e32 v6, 1, v6
		v_accvgpr_write_b32 a0, v6
		v_accvgpr_read_b32 v6, a0
		v_accvgpr_read_b32 v9, a7
		s_mov_b32 m0, s22
		v_add3_u32 v6, s37, v6, v9
		ds_read_addtid_b32 v10 offset:9216
		s_mov_b32 m0, s22
		s_nop 0
		ds_read_addtid_b32 v11 offset:10240
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s52, v10
		v_readfirstlane_b32 s53, v11
		s_nop 1
		v_cndmask_b32_e64 v6, v7, v6, s[52:53]
		buffer_store_dwordx4 v[36:39], v6, s[40:43], 0 offen
		v_accvgpr_read_b32 v6, a0
		v_accvgpr_read_b32 v9, a7
		s_mov_b32 m0, s22
		v_add3_u32 v6, s39, v6, v9
		ds_read_addtid_b32 v10 offset:9216
		s_mov_b32 m0, s22
		s_nop 0
		ds_read_addtid_b32 v11 offset:10240
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s52, v10
		v_readfirstlane_b32 s53, v11
		s_nop 1
		v_cndmask_b32_e64 v6, v7, v6, s[52:53]
		buffer_store_dwordx4 v[28:31], v6, s[40:43], 0 offen
		v_accvgpr_read_b32 v6, a0
		v_accvgpr_read_b32 v9, a7
		s_mov_b32 m0, s22
		v_add3_u32 v6, s44, v6, v9
		ds_read_addtid_b32 v10 offset:9216
		s_mov_b32 m0, s22
		s_nop 0
		ds_read_addtid_b32 v11 offset:10240
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s52, v10
		v_readfirstlane_b32 s53, v11
		s_nop 1
		v_cndmask_b32_e64 v6, v7, v6, s[52:53]
		buffer_store_dwordx4 v[40:43], v6, s[40:43], 0 offen
		v_accvgpr_read_b32 v6, a0
		v_accvgpr_read_b32 v9, a7
		s_mov_b32 m0, s22
		v_add3_u32 v6, s26, v6, v9
		ds_read_addtid_b32 v10 offset:9216
		s_mov_b32 m0, s22
		s_nop 0
		ds_read_addtid_b32 v11 offset:10240
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s52, v10
		v_readfirstlane_b32 s53, v11
		s_nop 1
		v_cndmask_b32_e64 v6, v7, v6, s[52:53]
		buffer_store_dwordx4 v[44:47], v6, s[40:43], 0 offen
		v_accvgpr_read_b32 v6, a51
		v_add_u32_e32 v6, 0x10000, v6
		v_accvgpr_read_b32 v9, a36
		ds_read_b128 a[12:15], v9 offset:18864
		v_accvgpr_read_b32 v9, a38
		ds_read_b128 a[16:19], v9 offset:18864
		v_accvgpr_read_b32 v9, a48
		ds_read_b128 a[20:23], v9 offset:18864
		v_accvgpr_read_b32 v9, a50
		ds_read_b128 a[24:27], v9 offset:18864
		v_accvgpr_read_b32 v9, a60
		v_accvgpr_read_b32 v10, a61
		v_add3_u32 v6, v6, v9, v10
		v_accvgpr_read_b32 v9, a35
		v_lshl_add_u32 v9, v9, 4, v6
		v_accvgpr_read_b32 v10, a37
		v_lshl_add_u32 v10, v10, 4, v6
		v_accvgpr_read_b32 v11, a39
		v_lshl_add_u32 v11, v11, 4, v6
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v12, a33
		s_waitcnt vmcnt(3)
		ds_write_b128 v12, v[104:107] offset:18864
		v_accvgpr_read_b32 v12, a33
		s_waitcnt vmcnt(2)
		ds_write_b128 v12, v[108:111] offset:22960
		v_accvgpr_read_b32 v12, a33
		s_waitcnt vmcnt(1)
		ds_write_b128 v12, v[112:115] offset:27056
		v_accvgpr_read_b32 v12, a33
		s_waitcnt vmcnt(0)
		ds_write_b128 v12, v[116:119] offset:31152
		v_accvgpr_read_b32 v12, a49
		v_lshl_add_u32 v6, v12, 4, v6
		s_add_i32 s26, s45, 1
		s_mul_i32 s26, s26, 0x100
		s_lshr_b32 s37, s56, 6
		s_mul_i32 s37, 0x410, s37
		s_mov_b32 m0, s37
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v12, a62
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		ds_read_b128 a[28:31], v9 offset:2480
		ds_read_b128 a[36:39], v10 offset:2480
		ds_read_b128 a[40:43], v11 offset:2480
		ds_read_b128 a[44:47], v6 offset:2480
		s_mov_b32 m0, s22
		s_nop 0
		ds_read_addtid_b32 v6 offset:4096
		s_mov_b32 m0, s37
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s39, v6
		s_add_i32 s26, s26, s39
		s_cmp_lt_i32 s24, s26
		s_cselect_b32 s26, s24, s26
		s_add_i32 s39, s26, 0x7f
		s_barrier
		s_cmp_lt_i32 s39, 0
		s_cselect_b32 s44, s36, 0
		s_add_i32 s39, s39, s44
		s_mov_b32 m0, s22
		s_ashr_i32 s39, s39, 7
		ds_read_addtid_b32 v6 offset:4096
		s_mov_b32 m0, s37
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s44, v6
		s_add_i32 s44, s46, s44
		s_cmp_lt_i32 s44, 0
		s_cselect_b32 s47, s36, 0
		s_add_i32 s44, s44, s47
		s_ashr_i32 s44, s44, 7
		s_cmp_lt_i32 s44, s39
		s_cselect_b32 s44, s44, s39
		s_cmp_gt_i32 s44, 0
		s_cselect_b32 s44, s44, 0
		s_add_i32 m0, m0, 0x1040
		s_mov_b32 m0, s18
		s_nop 0
		ds_read_addtid_b32 v6 offset:11264
		s_mov_b32 m0, s37
		s_nop 0
		s_add_i32 m0, m0, 0x1040
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s47, v6
		s_mul_i32 s45, s45, s47
		v_accvgpr_read_b32 v6, a63
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_accvgpr_read_b32 v6, a97
		v_add_u32_e32 v6, s46, v6
		s_add_i32 m0, s37, 0x2080
		v_accvgpr_read_b32 v9, a96
		v_add_u32_e32 v9, s46, v9
		v_accvgpr_read_b32 v10, a80
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		s_mul_i32 s39, s39, 0x80
		s_add_i32 m0, s37, 0x30c0
		s_mul_i32 s46, s44, 0x80
		v_accvgpr_read_b32 v10, a81
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		s_nop 0
		s_mov_b32 m0, s22
		s_nop 0
		ds_read_addtid_b32 v10 offset:5120
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s44, v10
		s_nop 1
		v_mov_b32_e32 v10, s44
		s_lshr_b32 s44, s56, 6
		s_mul_i32 s44, 0x440, s44
		s_add_i32 m0, s44, 0x81f0
		s_mov_b32 m0, s22
		s_nop 0
		ds_read_addtid_b32 v11 offset:5120
		s_add_i32 m0, s44, 0x81f0
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s47, v11
		s_nop 1
		v_mov_b32_e32 v11, s47
		v_accvgpr_read_b32 v12, a82
		buffer_load_dwordx4 v12, s[32:35], 0 offen lds
		s_nop 0
		s_mov_b32 m0, s22
		s_nop 0
		ds_read_addtid_b32 v12 offset:6144
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s47, v12
		s_nop 1
		v_mov_b32_e32 v12, s47
		s_add_i32 m0, s44, 0x92f0
		s_mov_b32 m0, s22
		s_nop 0
		ds_read_addtid_b32 v13 offset:6144
		s_add_i32 m0, s44, 0x92f0
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s22, v13
		s_nop 1
		v_mov_b32_e32 v13, s22
		v_accvgpr_read_b32 v16, a83
		buffer_load_dwordx4 v16, s[32:35], 0 offen lds
		s_mov_b32 s22, 0
		s_add_i32 m0, s44, 0xa3f0
		v_mov_b64_e32 v[34:35], 0
		v_accvgpr_read_b32 v16, a84
		buffer_load_dwordx4 v16, s[32:35], 0 offen lds
		v_mov_b64_e32 v[32:33], 0
		s_add_i32 m0, s44, 0xb4f0
		s_cmp_lt_i32 0, s46
		v_accvgpr_read_b32 v16, a85
		buffer_load_dwordx4 v16, s[32:35], 0 offen lds
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
		s_add_i32 s47, s22, 0x80
		s_lshr_b32 s52, s22, 7
		s_and_b32 s53, s52, 1
		s_mul_i32 s54, 0x4100, s53
		v_accvgpr_read_b32 v16, a86
		v_accvgpr_read_b32 v17, a87
		v_add3_u32 v16, s54, v16, v17
		v_accvgpr_read_b32 v17, a88
		v_accvgpr_read_b32 v18, a89
		v_add3_u32 v16, v16, v17, v18
		v_accvgpr_read_b32 v17, a90
		v_accvgpr_read_b32 v18, a91
		v_add3_u32 v16, v16, v17, v18
		ds_read_b128 v[24:27], v16
		ds_read_b128 v[28:31], v16 offset:32
		ds_read_b128 a[48:51], v16 offset:64
		ds_read_b128 a[52:55], v16 offset:96
		ds_read_b128 v[96:99], v16 offset:256
		ds_read_b128 v[100:103], v16 offset:288
		ds_read_b128 a[56:59], v16 offset:320
		ds_read_b128 a[60:63], v16 offset:352
		ds_read_b128 v[104:107], v16 offset:128
		ds_read_b128 v[108:111], v16 offset:160
		ds_read_b128 a[64:67], v16 offset:192
		ds_read_b128 a[68:71], v16 offset:224
		ds_read_b128 v[112:115], v16 offset:384
		ds_read_b128 v[116:119], v16 offset:416
		ds_read_b128 v[120:123], v16 offset:448
		ds_read_b128 a[72:75], v16 offset:480
		s_mul_i32 s53, 0x4400, s53
		v_accvgpr_read_b32 v16, a92
		v_accvgpr_read_b32 v17, a93
		v_add3_u32 v16, s53, v16, v17
		v_accvgpr_read_b32 v17, a95
		v_and_b32_e32 v18, 63, v0
		v_and_b32_e32 v18, 15, v18
		v_lshrrev_b32_e32 v18, 2, v18
		v_mov_b32_e32 v19, 0x440
		v_mul_lo_u32 v19, v19, v18
		v_add3_u32 v16, v16, v19, v17
		ds_read_b64_tr_b16 a[76:77], v16 offset:33264
		ds_read_b64_tr_b16 a[78:79], v16 offset:37616
		ds_read_b64_tr_b16 a[80:81], v16 offset:33392
		ds_read_b64_tr_b16 a[82:83], v16 offset:37744
		ds_read_b64_tr_b16 a[132:133], v16 offset:33520
		ds_read_b64_tr_b16 a[134:135], v16 offset:37872
		ds_read_b64_tr_b16 a[136:137], v16 offset:33648
		ds_read_b64_tr_b16 a[138:139], v16 offset:38000
		ds_read_b64_tr_b16 a[140:141], v16 offset:33776
		ds_read_b64_tr_b16 a[142:143], v16 offset:38128
		ds_read_b64_tr_b16 a[144:145], v16 offset:33904
		ds_read_b64_tr_b16 a[146:147], v16 offset:38256
		ds_read_b64_tr_b16 a[148:149], v16 offset:34032
		ds_read_b64_tr_b16 a[150:151], v16 offset:38384
		ds_read_b64_tr_b16 a[152:153], v16 offset:34160
		ds_read_b64_tr_b16 a[154:155], v16 offset:38512
		ds_read_b64_tr_b16 a[156:157], v16 offset:33328
		ds_read_b64_tr_b16 a[158:159], v16 offset:37680
		ds_read_b64_tr_b16 a[160:161], v16 offset:33456
		ds_read_b64_tr_b16 a[162:163], v16 offset:37808
		ds_read_b64_tr_b16 a[164:165], v16 offset:33584
		ds_read_b64_tr_b16 a[166:167], v16 offset:37936
		ds_read_b64_tr_b16 a[168:169], v16 offset:33712
		ds_read_b64_tr_b16 a[170:171], v16 offset:38064
		ds_read_b64_tr_b16 a[172:173], v16 offset:33840
		ds_read_b64_tr_b16 a[174:175], v16 offset:38192
		ds_read_b64_tr_b16 a[176:177], v16 offset:33968
		ds_read_b64_tr_b16 a[178:179], v16 offset:38320
		ds_read_b64_tr_b16 a[180:181], v16 offset:34096
		ds_read_b64_tr_b16 a[182:183], v16 offset:38448
		ds_read_b64_tr_b16 a[184:185], v16 offset:34224
		ds_read_b64_tr_b16 a[186:187], v16 offset:38576
		s_barrier
		v_lshrrev_b32_e32 v16, 3, v0
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v17, 64
		v_mul_lo_u32 v17, v17, v16
		v_lshrrev_b32_e32 v16, 4, v0
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v18, 32
		v_mul_lo_u32 v18, v18, v16
		v_lshrrev_b32_e32 v16, 5, v0
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v19, 16
		v_mul_lo_u32 v19, v19, v16
		v_bitop3_b32 v16, v17, v18, v19 bitop3:0x96
		v_lshrrev_b32_e32 v17, 6, v0
		v_and_b32_e32 v17, 1, v17
		v_and_b32_e32 v18, 1, v22
		v_mov_b32_e32 v19, 2
		v_mul_lo_u32 v19, v19, v18
		v_bitop3_b32 v16, v16, v17, v19 bitop3:0x96
		v_add_u32_e32 v16, s47, v16
		v_lshrrev_b32_e32 v17, 3, v0
		v_and_b32_e32 v17, 1, v17
		v_mov_b32_e32 v18, 64
		v_mul_lo_u32 v18, v18, v17
		v_lshrrev_b32_e32 v17, 4, v0
		v_and_b32_e32 v17, 1, v17
		v_mov_b32_e32 v19, 32
		v_mul_lo_u32 v19, v19, v17
		v_bitop3_b32 v17, 4, v18, v19 bitop3:0x96
		v_lshrrev_b32_e32 v18, 5, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v19, 16
		v_mul_lo_u32 v19, v19, v18
		v_xor_b32_e32 v17, v17, v19
		v_lshrrev_b32_e32 v18, 6, v0
		v_and_b32_e32 v18, 1, v18
		v_and_b32_e32 v19, 1, v22
		v_mov_b32_e32 v20, 2
		v_mul_lo_u32 v20, v20, v19
		v_bitop3_b32 v17, v17, v18, v20 bitop3:0x96
		v_add_u32_e32 v17, s47, v17
		v_lshrrev_b32_e32 v18, 3, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v19, 64
		v_mul_lo_u32 v19, v19, v18
		v_lshrrev_b32_e32 v18, 4, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v20, 32
		v_mul_lo_u32 v20, v20, v18
		v_bitop3_b32 v18, 8, v19, v20 bitop3:0x96
		v_lshrrev_b32_e32 v19, 5, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 16
		v_mul_lo_u32 v20, v20, v19
		v_xor_b32_e32 v18, v18, v20
		v_lshrrev_b32_e32 v19, 6, v0
		v_and_b32_e32 v19, 1, v19
		v_and_b32_e32 v20, 1, v22
		v_mov_b32_e32 v21, 2
		v_mul_lo_u32 v21, v21, v20
		v_bitop3_b32 v18, v18, v19, v21 bitop3:0x96
		v_add_u32_e32 v18, s47, v18
		v_lshrrev_b32_e32 v19, 3, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 64
		v_mul_lo_u32 v20, v20, v19
		v_lshrrev_b32_e32 v19, 4, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v21, 32
		v_mul_lo_u32 v21, v21, v19
		v_bitop3_b32 v19, 12, v20, v21 bitop3:0x96
		v_lshrrev_b32_e32 v20, 5, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v21, 16
		v_mul_lo_u32 v21, v21, v20
		v_xor_b32_e32 v19, v19, v21
		v_lshrrev_b32_e32 v20, 6, v0
		v_and_b32_e32 v20, 1, v20
		v_and_b32_e32 v21, 1, v22
		v_mov_b32_e32 v23, 2
		v_mul_lo_u32 v23, v23, v21
		v_bitop3_b32 v19, v19, v20, v23 bitop3:0x96
		v_add_u32_e32 v19, s47, v19
		v_cmp_lt_i32_e64 vcc, v16, s24
		s_mov_b64 s[54:55], vcc
		v_cmp_lt_i32_e64 vcc, v17, s24
		s_mov_b64 s[58:59], vcc
		v_cmp_lt_i32_e64 vcc, v18, s24
		s_mov_b64 s[60:61], vcc
		v_cmp_lt_i32_e64 vcc, v19, s24
		s_mov_b64 s[62:63], vcc
		v_lshrrev_b32_e32 v16, 3, v0
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v17, 16
		v_mul_lo_u32 v17, v17, v16
		v_lshrrev_b32_e32 v16, 4, v0
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v18, 32
		v_mul_lo_u32 v18, v18, v16
		v_lshrrev_b32_e32 v16, 5, v0
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v19, 64
		v_mul_lo_u32 v19, v19, v16
		v_bitop3_b32 v16, v17, v18, v19 bitop3:0x96
		v_lshrrev_b32_e32 v17, 6, v0
		v_and_b32_e32 v17, 1, v17
		v_and_b32_e32 v18, 1, v22
		v_mov_b32_e32 v19, 2
		v_mul_lo_u32 v19, v19, v18
		v_bitop3_b32 v16, v16, v17, v19 bitop3:0x96
		v_add_u32_e32 v16, s47, v16
		v_lshrrev_b32_e32 v17, 3, v0
		v_and_b32_e32 v17, 1, v17
		v_mov_b32_e32 v18, 16
		v_mul_lo_u32 v18, v18, v17
		v_lshrrev_b32_e32 v17, 4, v0
		v_and_b32_e32 v17, 1, v17
		v_mov_b32_e32 v19, 32
		v_mul_lo_u32 v19, v19, v17
		v_bitop3_b32 v17, 4, v18, v19 bitop3:0x96
		v_lshrrev_b32_e32 v18, 5, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v19, 64
		v_mul_lo_u32 v19, v19, v18
		v_xor_b32_e32 v17, v17, v19
		v_lshrrev_b32_e32 v18, 6, v0
		v_and_b32_e32 v18, 1, v18
		v_and_b32_e32 v19, 1, v22
		v_mov_b32_e32 v20, 2
		v_mul_lo_u32 v20, v20, v19
		v_bitop3_b32 v17, v17, v18, v20 bitop3:0x96
		v_add_u32_e32 v17, s47, v17
		v_lshrrev_b32_e32 v18, 3, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v19, 16
		v_mul_lo_u32 v19, v19, v18
		v_lshrrev_b32_e32 v18, 4, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v20, 32
		v_mul_lo_u32 v20, v20, v18
		v_bitop3_b32 v18, 8, v19, v20 bitop3:0x96
		v_lshrrev_b32_e32 v19, 5, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 64
		v_mul_lo_u32 v20, v20, v19
		v_xor_b32_e32 v18, v18, v20
		v_lshrrev_b32_e32 v19, 6, v0
		v_and_b32_e32 v19, 1, v19
		v_and_b32_e32 v20, 1, v22
		v_mov_b32_e32 v21, 2
		v_mul_lo_u32 v21, v21, v20
		v_bitop3_b32 v18, v18, v19, v21 bitop3:0x96
		v_add_u32_e32 v18, s47, v18
		v_cmp_lt_i32_e64 vcc, v16, s24
		s_mov_b64 s[64:65], vcc
		v_cmp_lt_i32_e64 vcc, v17, s24
		s_mov_b64 s[66:67], vcc
		v_cmp_lt_i32_e64 vcc, v18, s24
		s_mov_b64 s[68:69], vcc
		s_mul_i32 s53, s15, s22
		s_lshl_b32 s53, s53, 1
		s_lshl_b32 s57, s15, 8
		s_mul_i32 s70, s1, s13
		s_lshl_b32 s70, s70, 1
		s_add_i32 s57, s57, s70
		s_mul_i32 s70, s25, s14
		s_lshl_b32 s70, s70, 1
		s_add_i32 s57, s57, s70
		s_add_i32 s57, s57, s53
		v_add_u32_e32 v16, s57, v8
		s_add_i32 s52, s52, 1
		s_and_b32 s52, s52, 1
		s_mul_i32 s57, 0x4100, s52
		s_add_i32 s57, s37, s57
		s_mov_b32 m0, s57
		v_cndmask_b32_e64 v16, v7, v16, s[54:55]
		buffer_load_dwordx4 v16, s[28:31], 0 offen lds
		v_lshrrev_b32_e32 v16, 3, v0
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v17, 16
		v_mul_lo_u32 v17, v17, v16
		v_lshrrev_b32_e32 v16, 4, v0
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v18, 32
		v_mul_lo_u32 v18, v18, v16
		v_bitop3_b32 v16, 12, v17, v18 bitop3:0x96
		v_lshrrev_b32_e32 v17, 5, v0
		v_and_b32_e32 v17, 1, v17
		v_mov_b32_e32 v18, 64
		v_mul_lo_u32 v18, v18, v17
		v_xor_b32_e32 v16, v16, v18
		v_lshrrev_b32_e32 v17, 6, v0
		v_and_b32_e32 v17, 1, v17
		v_and_b32_e32 v18, 1, v22
		v_mov_b32_e32 v19, 2
		v_mul_lo_u32 v19, v19, v18
		v_bitop3_b32 v16, v16, v17, v19 bitop3:0x96
		v_add_u32_e32 v16, s47, v16
		v_add_u32_e32 v17, s53, v8
		s_mul_i32 s53, 0x108, s15
		s_mul_i32 s54, s1, s13
		s_lshl_b32 s54, s54, 1
		s_add_i32 s53, s53, s54
		s_mul_i32 s54, s25, s14
		s_lshl_b32 s54, s54, 1
		s_add_i32 s53, s53, s54
		v_add_u32_e32 v18, s53, v17
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v18, v7, v18, s[58:59]
		buffer_load_dwordx4 v18, s[28:31], 0 offen lds
		s_mul_i32 s53, 0x110, s15
		s_mul_i32 s54, s1, s13
		s_lshl_b32 s54, s54, 1
		s_add_i32 s53, s53, s54
		s_mul_i32 s54, s25, s14
		s_lshl_b32 s54, s54, 1
		s_add_i32 s53, s53, s54
		v_add_u32_e32 v18, s53, v17
		s_add_i32 m0, s57, 0x2080
		v_cndmask_b32_e64 v18, v7, v18, s[60:61]
		buffer_load_dwordx4 v18, s[28:31], 0 offen lds
		s_mul_i32 s53, 0x118, s15
		s_mul_i32 s54, s1, s13
		s_lshl_b32 s54, s54, 1
		s_add_i32 s53, s53, s54
		s_mul_i32 s54, s25, s14
		s_lshl_b32 s54, s54, 1
		s_add_i32 s53, s53, s54
		v_add_u32_e32 v17, s53, v17
		s_add_i32 m0, s57, 0x30c0
		v_cndmask_b32_e64 v17, v7, v17, s[62:63]
		buffer_load_dwordx4 v17, s[28:31], 0 offen lds
		s_barrier
		s_mul_i32 s22, s21, s22
		s_lshl_b32 s22, s22, 1
		s_lshl_b32 s53, s21, 8
		s_mul_i32 s54, s1, s19
		s_lshl_b32 s54, s54, 1
		s_add_i32 s53, s53, s54
		s_mul_i32 s54, s25, s20
		s_lshl_b32 s54, s54, 1
		s_add_i32 s53, s53, s54
		s_add_i32 s53, s53, s22
		v_add_u32_e32 v17, s53, v14
		s_mul_i32 s52, 0x4400, s52
		s_add_i32 s52, s44, s52
		s_add_i32 m0, s52, 0x81f0
		v_cndmask_b32_e64 v17, v7, v17, s[64:65]
		buffer_load_dwordx4 v17, s[32:35], 0 offen lds
		v_add_u32_e32 v17, s22, v14
		s_mul_i32 s22, 0x108, s21
		s_mul_i32 s53, s1, s19
		s_lshl_b32 s53, s53, 1
		s_add_i32 s22, s22, s53
		s_mul_i32 s53, s25, s20
		s_lshl_b32 s53, s53, 1
		s_add_i32 s22, s22, s53
		v_add_u32_e32 v18, s22, v17
		s_add_i32 m0, s52, 0x92f0
		v_cndmask_b32_e64 v18, v7, v18, s[66:67]
		buffer_load_dwordx4 v18, s[32:35], 0 offen lds
		s_mul_i32 s22, 0x110, s21
		s_mul_i32 s53, s1, s19
		s_lshl_b32 s53, s53, 1
		s_add_i32 s22, s22, s53
		s_mul_i32 s53, s25, s20
		s_lshl_b32 s53, s53, 1
		s_add_i32 s22, s22, s53
		v_add_u32_e32 v18, s22, v17
		s_add_i32 m0, s52, 0xa3f0
		v_cndmask_b32_e64 v18, v7, v18, s[68:69]
		buffer_load_dwordx4 v18, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v16, s24
		s_mul_i32 s22, 0x118, s21
		s_mul_i32 s53, s1, s19
		s_lshl_b32 s53, s53, 1
		s_add_i32 s22, s22, s53
		s_mul_i32 s53, s25, s20
		s_lshl_b32 s53, s53, 1
		s_add_i32 s22, s22, s53
		v_add_u32_e32 v16, s22, v17
		s_add_i32 m0, s52, 0xb4f0
		v_cndmask_b32_e32 v16, v7, v16, vcc
		s_cmp_lt_i32 s47, s46
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[128:143], v[24:27], a[12:15], 0
		v_mfma_f32_32x32x16_bf16 v[144:159], v[96:99], a[12:15], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[104:107], a[12:15], 0
		v_mfma_f32_32x32x16_bf16 v[176:191], v[112:115], a[12:15], 0
		v_mfma_f32_32x32x16_bf16 v[192:207], v[112:115], a[28:31], 0
		v_mfma_f32_32x32x16_bf16 v[208:223], v[24:27], a[28:31], 0
		buffer_load_dwordx4 v16, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], v[96:99], a[28:31], 0
		v_mfma_f32_32x32x16_bf16 v[240:255], v[104:107], a[28:31], 0
		v_mfma_f32_32x32x16_bf16 v[128:143], v[28:31], a[16:19], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], v[100:103], a[16:19], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], v[108:111], a[16:19], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[116:119], a[16:19], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[116:119], a[36:39], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[28:31], a[36:39], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], v[100:103], a[36:39], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], v[108:111], a[36:39], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[48:51], a[20:23], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[56:59], a[20:23], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[64:67], a[20:23], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], v[120:123], a[20:23], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[120:123], a[40:43], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[48:51], a[40:43], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[56:59], a[40:43], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[64:67], a[40:43], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[52:55], a[24:27], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[60:63], a[24:27], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[68:71], a[24:27], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[72:75], a[24:27], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[72:75], a[44:47], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[52:55], a[44:47], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[60:63], a[44:47], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[68:71], a[44:47], v[240:255]
		s_nop 4
		v_max_f32_e32 v16, v128, v129
		v_max_f32_e32 v17, v130, v131
		v_max_f32_e32 v18, v132, v133
		v_max_f32_e32 v19, v134, v135
		v_max_f32_e32 v20, v136, v137
		v_max_f32_e32 v21, v138, v139
		v_max_f32_e32 v23, v140, v141
		v_max_f32_e32 v24, v142, v143
		v_max_f32_e32 v25, v144, v145
		v_max_f32_e32 v26, v146, v147
		v_max_f32_e32 v27, v148, v149
		v_max_f32_e32 v28, v150, v151
		v_max_f32_e32 v29, v152, v153
		v_max_f32_e32 v30, v154, v155
		v_max_f32_e32 v31, v156, v157
		v_max_f32_e32 v96, v158, v159
		v_max_f32_e32 v97, v160, v161
		v_max_f32_e32 v98, v162, v163
		v_max_f32_e32 v99, v164, v165
		v_max_f32_e32 v100, v166, v167
		v_max_f32_e32 v101, v168, v169
		v_max_f32_e32 v102, v170, v171
		v_max_f32_e32 v103, v172, v173
		v_max_f32_e32 v104, v174, v175
		v_max_f32_e32 v105, v176, v177
		v_max_f32_e32 v106, v178, v179
		v_max_f32_e32 v107, v180, v181
		v_max_f32_e32 v108, v182, v183
		v_max_f32_e32 v109, v184, v185
		v_max_f32_e32 v110, v186, v187
		v_max_f32_e32 v111, v188, v189
		v_max_f32_e32 v112, v190, v191
		v_max_f32_e32 v16, v16, v17
		v_max_f32_e32 v17, v18, v19
		v_max_f32_e32 v18, v20, v21
		v_max_f32_e32 v19, v23, v24
		v_max_f32_e32 v20, v25, v26
		v_max_f32_e32 v21, v27, v28
		v_max_f32_e32 v23, v29, v30
		v_max_f32_e32 v24, v31, v96
		v_max_f32_e32 v25, v97, v98
		v_max_f32_e32 v26, v99, v100
		v_max_f32_e32 v27, v101, v102
		v_max_f32_e32 v28, v103, v104
		v_max_f32_e32 v29, v105, v106
		v_max_f32_e32 v30, v107, v108
		v_max_f32_e32 v31, v109, v110
		v_max_f32_e32 v96, v111, v112
		v_max_f32_e32 v16, v16, v17
		v_max_f32_e32 v17, v18, v19
		v_max_f32_e32 v18, v20, v21
		v_max_f32_e32 v19, v23, v24
		v_max_f32_e32 v20, v25, v26
		v_max_f32_e32 v21, v27, v28
		v_max_f32_e32 v23, v29, v30
		v_max_f32_e32 v24, v31, v96
		v_max_f32_e32 v16, v16, v17
		v_max_f32_e32 v17, v18, v19
		v_max_f32_e32 v18, v20, v21
		v_max_f32_e32 v19, v23, v24
		v_max_f32_e32 v16, v16, v17
		v_max_f32_e32 v17, v18, v19
		v_max_f32_e32 v16, v16, v17
		v_and_b32_e32 v17, 1, v15
		v_lshrrev_b32_e32 v18, 4, v15
		v_and_b32_e32 v18, 1, v18
		v_lshlrev_b32_e32 v18, 4, v18
		v_lshrrev_b32_e32 v19, 3, v15
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 3, v19
		v_add3_u32 v17, v17, v18, v19
		v_lshrrev_b32_e32 v18, 2, v15
		v_and_b32_e32 v18, 1, v18
		v_lshlrev_b32_e32 v18, 2, v18
		v_lshrrev_b32_e32 v19, 1, v15
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 1, v19
		v_add3_u32 v17, v17, v18, v19
		v_lshlrev_b32_e32 v17, 2, v17
		ds_bpermute_b32 v18, v17, v16
		v_lshrrev_b32_e32 v19, 4, v15
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 4, v19
		v_lshrrev_b32_e32 v20, 3, v15
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v20, 3, v20
		v_lshrrev_b32_e32 v21, 2, v15
		v_and_b32_e32 v21, 1, v21
		v_lshlrev_b32_e32 v21, 2, v21
		v_and_b32_e32 v23, 1, v15
		v_add_u32_e32 v23, 32, v23
		v_lshrrev_b32_e32 v24, 1, v15
		v_and_b32_e32 v24, 1, v24
		v_lshlrev_b32_e32 v24, 1, v24
		v_bitop3_b32 v21, v21, v23, v24 bitop3:0x96
		v_bitop3_b32 v19, v19, v20, v21 bitop3:0x96
		v_lshlrev_b32_e32 v19, 2, v19
		ds_bpermute_b32 v20, v19, v16
		v_max_f32_e32 v16, v208, v209
		v_max_f32_e32 v21, v210, v211
		v_max_f32_e32 v23, v212, v213
		v_max_f32_e32 v24, v214, v215
		v_max_f32_e32 v25, v216, v217
		v_max_f32_e32 v26, v218, v219
		v_max_f32_e32 v27, v220, v221
		v_max_f32_e32 v28, v222, v223
		v_max_f32_e32 v29, v224, v225
		v_max_f32_e32 v30, v226, v227
		v_max_f32_e32 v31, v228, v229
		v_max_f32_e32 v96, v230, v231
		v_max_f32_e32 v97, v232, v233
		v_max_f32_e32 v98, v234, v235
		v_max_f32_e32 v99, v236, v237
		v_max_f32_e32 v100, v238, v239
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v102, v18, v20
		v_max_f32_e32 v18, v240, v241
		v_max_f32_e32 v20, v242, v243
		v_max_f32_e32 v101, v244, v245
		v_max_f32_e32 v103, v246, v247
		v_max_f32_e32 v104, v248, v249
		v_max_f32_e32 v105, v250, v251
		v_max_f32_e32 v106, v252, v253
		v_max_f32_e32 v107, v254, v255
		v_max_f32_e32 v108, v192, v193
		v_max_f32_e32 v109, v194, v195
		v_max_f32_e32 v110, v196, v197
		v_max_f32_e32 v111, v198, v199
		v_max_f32_e32 v112, v200, v201
		v_max_f32_e32 v113, v202, v203
		v_max_f32_e32 v114, v204, v205
		v_max_f32_e32 v115, v206, v207
		v_max_f32_e32 v16, v16, v21
		v_max_f32_e32 v21, v23, v24
		v_max_f32_e32 v23, v25, v26
		v_max_f32_e32 v24, v27, v28
		v_max_f32_e32 v25, v29, v30
		v_max_f32_e32 v26, v31, v96
		v_max_f32_e32 v27, v97, v98
		v_max_f32_e32 v28, v99, v100
		v_max_f32_e32 v18, v18, v20
		v_max_f32_e32 v20, v101, v103
		v_max_f32_e32 v29, v104, v105
		v_max_f32_e32 v30, v106, v107
		v_max_f32_e32 v31, v108, v109
		v_max_f32_e32 v96, v110, v111
		v_max_f32_e32 v97, v112, v113
		v_max_f32_e32 v98, v114, v115
		v_max_f32_e32 v16, v16, v21
		v_max_f32_e32 v21, v23, v24
		v_max_f32_e32 v23, v25, v26
		v_max_f32_e32 v24, v27, v28
		v_max_f32_e32 v18, v18, v20
		v_max_f32_e32 v20, v29, v30
		v_max_f32_e32 v25, v31, v96
		v_max_f32_e32 v26, v97, v98
		v_max_f32_e32 v16, v16, v21
		v_max_f32_e32 v21, v23, v24
		v_max_f32_e32 v18, v18, v20
		v_max_f32_e32 v20, v25, v26
		v_max_f32_e32 v16, v16, v21
		v_max_f32_e32 v18, v18, v20
		v_max_f32_e32 v16, v16, v18
		ds_bpermute_b32 v18, v17, v16
		ds_bpermute_b32 v20, v19, v16
		v_mov_b32_e32 v24, 0x3e38aa3b
		v_mov_b32_e32 v25, 0x3e38aa3b
		v_pk_mul_f32 v[26:27], v[128:129], v[24:25]
		v_pk_mul_f32 v[28:29], v[130:131], v[24:25]
		v_pk_mul_f32 v[30:31], v[132:133], v[24:25]
		v_pk_mul_f32 v[96:97], v[134:135], v[24:25]
		v_pk_mul_f32 v[98:99], v[136:137], v[24:25]
		v_pk_mul_f32 v[100:101], v[138:139], v[24:25]
		v_pk_mul_f32 v[104:105], v[140:141], v[24:25]
		v_pk_mul_f32 v[106:107], v[142:143], v[24:25]
		v_pk_mul_f32 v[108:109], v[144:145], v[24:25]
		v_pk_mul_f32 v[110:111], v[146:147], v[24:25]
		v_pk_mul_f32 v[112:113], v[148:149], v[24:25]
		v_pk_mul_f32 v[114:115], v[150:151], v[24:25]
		v_pk_mul_f32 v[116:117], v[152:153], v[24:25]
		v_pk_mul_f32 v[118:119], v[154:155], v[24:25]
		v_pk_mul_f32 v[120:121], v[156:157], v[24:25]
		v_pk_mul_f32 v[122:123], v[158:159], v[24:25]
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v103, v18, v20
		v_pk_mul_f32 v[20:21], v[102:103], v[24:25]
		v_max_f32_e32 v16, v10, v20
		v_max_f32_e32 v18, v11, v21
		v_pk_mul_f32 v[20:21], v[160:161], v[24:25]
		v_pk_mul_f32 v[102:103], v[162:163], v[24:25]
		v_pk_mul_f32 v[124:125], v[164:165], v[24:25]
		v_pk_mul_f32 v[126:127], v[166:167], v[24:25]
		v_pk_mul_f32 v[128:129], v[168:169], v[24:25]
		v_pk_mul_f32 v[130:131], v[170:171], v[24:25]
		v_pk_mul_f32 v[132:133], v[172:173], v[24:25]
		v_pk_mul_f32 v[134:135], v[174:175], v[24:25]
		v_pk_mul_f32 v[136:137], v[176:177], v[24:25]
		v_pk_mul_f32 v[138:139], v[178:179], v[24:25]
		v_pk_mul_f32 v[140:141], v[180:181], v[24:25]
		v_pk_mul_f32 v[142:143], v[182:183], v[24:25]
		v_pk_mul_f32 v[144:145], v[184:185], v[24:25]
		v_pk_mul_f32 v[146:147], v[186:187], v[24:25]
		v_pk_mul_f32 v[148:149], v[188:189], v[24:25]
		v_pk_mul_f32 v[150:151], v[190:191], v[24:25]
		v_pk_mul_f32 v[152:153], v[208:209], v[24:25]
		v_pk_mul_f32 v[154:155], v[210:211], v[24:25]
		v_pk_mul_f32 v[156:157], v[212:213], v[24:25]
		v_pk_mul_f32 v[158:159], v[214:215], v[24:25]
		v_pk_mul_f32 v[160:161], v[216:217], v[24:25]
		v_pk_mul_f32 v[162:163], v[218:219], v[24:25]
		v_pk_mul_f32 v[164:165], v[220:221], v[24:25]
		v_pk_mul_f32 v[166:167], v[222:223], v[24:25]
		v_pk_mul_f32 v[168:169], v[224:225], v[24:25]
		v_pk_mul_f32 v[170:171], v[226:227], v[24:25]
		v_pk_mul_f32 v[172:173], v[228:229], v[24:25]
		v_pk_mul_f32 v[174:175], v[230:231], v[24:25]
		v_pk_mul_f32 v[176:177], v[232:233], v[24:25]
		v_pk_mul_f32 v[178:179], v[234:235], v[24:25]
		v_pk_mul_f32 v[180:181], v[236:237], v[24:25]
		v_pk_mul_f32 v[182:183], v[238:239], v[24:25]
		v_pk_mul_f32 v[184:185], v[240:241], v[24:25]
		v_pk_mul_f32 v[186:187], v[242:243], v[24:25]
		v_pk_mul_f32 v[188:189], v[244:245], v[24:25]
		v_pk_mul_f32 v[190:191], v[246:247], v[24:25]
		v_pk_mul_f32 v[208:209], v[248:249], v[24:25]
		v_pk_mul_f32 v[210:211], v[250:251], v[24:25]
		v_pk_mul_f32 v[212:213], v[252:253], v[24:25]
		v_pk_mul_f32 v[214:215], v[254:255], v[24:25]
		v_pk_mul_f32 v[216:217], v[192:193], v[24:25]
		v_pk_mul_f32 v[192:193], v[194:195], v[24:25]
		v_pk_mul_f32 v[194:195], v[196:197], v[24:25]
		v_pk_mul_f32 v[196:197], v[198:199], v[24:25]
		v_pk_mul_f32 v[198:199], v[200:201], v[24:25]
		v_pk_mul_f32 v[200:201], v[202:203], v[24:25]
		v_pk_mul_f32 v[202:203], v[204:205], v[24:25]
		v_pk_mul_f32 v[204:205], v[206:207], v[24:25]
		v_sub_f32_e32 v23, v26, v16
		v_sub_f32_e32 v24, v27, v16
		v_sub_f32_e32 v25, v28, v16
		v_sub_f32_e32 v26, v29, v16
		v_sub_f32_e32 v27, v30, v16
		v_sub_f32_e32 v28, v31, v16
		v_sub_f32_e32 v29, v96, v16
		v_sub_f32_e32 v30, v97, v16
		v_sub_f32_e32 v31, v98, v16
		v_sub_f32_e32 v96, v99, v16
		v_sub_f32_e32 v97, v100, v16
		v_sub_f32_e32 v98, v101, v16
		v_sub_f32_e32 v99, v104, v16
		v_sub_f32_e32 v100, v105, v16
		v_sub_f32_e32 v101, v106, v16
		v_sub_f32_e32 v104, v107, v16
		v_sub_f32_e32 v105, v108, v16
		v_sub_f32_e32 v106, v109, v16
		v_sub_f32_e32 v107, v110, v16
		v_sub_f32_e32 v108, v111, v16
		v_sub_f32_e32 v109, v112, v16
		v_sub_f32_e32 v110, v113, v16
		v_sub_f32_e32 v111, v114, v16
		v_sub_f32_e32 v112, v115, v16
		v_sub_f32_e32 v113, v116, v16
		v_sub_f32_e32 v114, v117, v16
		v_sub_f32_e32 v115, v118, v16
		v_sub_f32_e32 v116, v119, v16
		v_sub_f32_e32 v117, v120, v16
		v_sub_f32_e32 v118, v121, v16
		v_sub_f32_e32 v119, v122, v16
		v_sub_f32_e32 v120, v123, v16
		v_sub_f32_e32 v20, v20, v16
		v_sub_f32_e32 v21, v21, v16
		v_sub_f32_e32 v102, v102, v16
		v_sub_f32_e32 v103, v103, v16
		v_sub_f32_e32 v121, v124, v16
		v_sub_f32_e32 v122, v125, v16
		v_sub_f32_e32 v123, v126, v16
		v_sub_f32_e32 v124, v127, v16
		v_sub_f32_e32 v125, v128, v16
		v_sub_f32_e32 v126, v129, v16
		v_sub_f32_e32 v127, v130, v16
		v_sub_f32_e32 v128, v131, v16
		v_sub_f32_e32 v129, v132, v16
		v_sub_f32_e32 v130, v133, v16
		v_sub_f32_e32 v131, v134, v16
		v_sub_f32_e32 v132, v135, v16
		v_sub_f32_e32 v133, v136, v16
		v_sub_f32_e32 v134, v137, v16
		v_sub_f32_e32 v135, v138, v16
		v_sub_f32_e32 v136, v139, v16
		v_sub_f32_e32 v137, v140, v16
		v_sub_f32_e32 v138, v141, v16
		v_sub_f32_e32 v139, v142, v16
		v_sub_f32_e32 v140, v143, v16
		v_sub_f32_e32 v141, v144, v16
		v_sub_f32_e32 v142, v145, v16
		v_sub_f32_e32 v143, v146, v16
		v_sub_f32_e32 v144, v147, v16
		v_sub_f32_e32 v145, v148, v16
		v_sub_f32_e32 v146, v149, v16
		v_sub_f32_e32 v147, v150, v16
		v_sub_f32_e32 v148, v151, v16
		v_sub_f32_e32 v149, v152, v18
		v_sub_f32_e32 v150, v153, v18
		v_sub_f32_e32 v151, v154, v18
		v_sub_f32_e32 v152, v155, v18
		v_sub_f32_e32 v153, v156, v18
		v_sub_f32_e32 v154, v157, v18
		v_sub_f32_e32 v155, v158, v18
		v_sub_f32_e32 v156, v159, v18
		v_sub_f32_e32 v157, v160, v18
		v_sub_f32_e32 v158, v161, v18
		v_sub_f32_e32 v159, v162, v18
		v_sub_f32_e32 v160, v163, v18
		v_sub_f32_e32 v161, v164, v18
		v_sub_f32_e32 v162, v165, v18
		v_sub_f32_e32 v163, v166, v18
		v_sub_f32_e32 v164, v167, v18
		v_sub_f32_e32 v165, v168, v18
		v_sub_f32_e32 v166, v169, v18
		v_sub_f32_e32 v167, v170, v18
		v_sub_f32_e32 v168, v171, v18
		v_sub_f32_e32 v169, v172, v18
		v_sub_f32_e32 v170, v173, v18
		v_sub_f32_e32 v171, v174, v18
		v_sub_f32_e32 v172, v175, v18
		v_sub_f32_e32 v173, v176, v18
		v_sub_f32_e32 v174, v177, v18
		v_sub_f32_e32 v175, v178, v18
		v_sub_f32_e32 v176, v179, v18
		v_sub_f32_e32 v177, v180, v18
		v_sub_f32_e32 v178, v181, v18
		v_sub_f32_e32 v179, v182, v18
		v_sub_f32_e32 v180, v183, v18
		v_sub_f32_e32 v181, v184, v18
		v_sub_f32_e32 v182, v185, v18
		v_sub_f32_e32 v183, v186, v18
		v_sub_f32_e32 v184, v187, v18
		v_sub_f32_e32 v185, v188, v18
		v_sub_f32_e32 v186, v189, v18
		v_sub_f32_e32 v187, v190, v18
		v_sub_f32_e32 v188, v191, v18
		v_sub_f32_e32 v189, v208, v18
		v_sub_f32_e32 v190, v209, v18
		v_sub_f32_e32 v191, v210, v18
		v_sub_f32_e32 v206, v211, v18
		v_sub_f32_e32 v207, v212, v18
		v_sub_f32_e32 v208, v213, v18
		v_sub_f32_e32 v209, v214, v18
		v_sub_f32_e32 v210, v215, v18
		v_sub_f32_e32 v211, v216, v18
		v_sub_f32_e32 v212, v217, v18
		v_sub_f32_e32 v192, v192, v18
		v_sub_f32_e32 v193, v193, v18
		v_sub_f32_e32 v194, v194, v18
		v_sub_f32_e32 v195, v195, v18
		v_sub_f32_e32 v196, v196, v18
		v_sub_f32_e32 v197, v197, v18
		v_sub_f32_e32 v198, v198, v18
		v_sub_f32_e32 v199, v199, v18
		v_sub_f32_e32 v200, v200, v18
		v_sub_f32_e32 v201, v201, v18
		v_sub_f32_e32 v202, v202, v18
		v_sub_f32_e32 v203, v203, v18
		v_sub_f32_e32 v204, v204, v18
		v_sub_f32_e32 v205, v205, v18
		v_exp_f32_e32 v214, v23
		v_exp_f32_e32 v216, v24
		v_exp_f32_e32 v215, v25
		v_exp_f32_e32 v217, v26
		v_exp_f32_e32 v24, v27
		v_exp_f32_e32 v26, v28
		v_exp_f32_e32 v25, v29
		v_exp_f32_e32 v27, v30
		v_exp_f32_e32 v28, v31
		v_exp_f32_e32 v30, v96
		v_exp_f32_e32 v29, v97
		v_exp_f32_e32 v31, v98
		v_exp_f32_e32 v96, v99
		v_exp_f32_e32 v98, v100
		v_exp_f32_e32 v97, v101
		v_exp_f32_e32 v99, v104
		v_exp_f32_e32 v100, v105
		v_exp_f32_e32 v104, v106
		v_exp_f32_e32 v101, v107
		v_exp_f32_e32 v105, v108
		v_exp_f32_e32 v106, v109
		v_exp_f32_e32 v108, v110
		v_exp_f32_e32 v107, v111
		v_exp_f32_e32 v109, v112
		v_exp_f32_e32 v110, v113
		v_exp_f32_e32 v112, v114
		v_exp_f32_e32 v111, v115
		v_exp_f32_e32 v113, v116
		v_exp_f32_e32 v114, v117
		v_exp_f32_e32 v116, v118
		v_exp_f32_e32 v115, v119
		v_exp_f32_e32 v117, v120
		v_exp_f32_e32 v118, v20
		v_exp_f32_e32 v218, v21
		v_exp_f32_e32 v119, v102
		v_exp_f32_e32 v219, v103
		v_exp_f32_e32 v20, v121
		v_exp_f32_e32 v102, v122
		v_exp_f32_e32 v21, v123
		v_exp_f32_e32 v103, v124
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
		v_exp_f32_e32 v140, v145
		v_exp_f32_e32 v142, v146
		v_exp_f32_e32 v141, v147
		v_exp_f32_e32 v143, v148
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
		v_exp_f32_e32 v206, v209
		v_exp_f32_e32 v208, v210
		v_exp_f32_e32 v207, v211
		v_exp_f32_e32 v209, v212
		v_exp_f32_e32 v210, v192
		v_exp_f32_e32 v212, v193
		v_exp_f32_e32 v211, v194
		v_exp_f32_e32 v213, v195
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
		v_pk_add_f32 v[204:205], v[214:215], v[216:217]
		v_pk_add_f32 v[220:221], v[24:25], v[26:27]
		v_pk_add_f32 v[222:223], v[28:29], v[30:31]
		v_pk_add_f32 v[224:225], v[96:97], v[98:99]
		v_pk_add_f32 v[226:227], v[100:101], v[104:105]
		v_pk_add_f32 v[228:229], v[106:107], v[108:109]
		v_pk_add_f32 v[230:231], v[110:111], v[112:113]
		v_pk_add_f32 v[232:233], v[114:115], v[116:117]
		v_pk_add_f32 v[234:235], v[118:119], v[218:219]
		v_pk_add_f32 v[236:237], v[20:21], v[102:103]
		v_pk_add_f32 v[238:239], v[120:121], v[122:123]
		v_pk_add_f32 v[240:241], v[124:125], v[126:127]
		v_pk_add_f32 v[242:243], v[128:129], v[130:131]
		v_pk_add_f32 v[244:245], v[132:133], v[134:135]
		v_pk_add_f32 v[246:247], v[136:137], v[138:139]
		v_pk_add_f32 v[248:249], v[140:141], v[142:143]
		v_mov_b32_e32 v250, v205
		v_mov_b32_e32 v251, v221
		v_mov_b32_e32 v252, v204
		v_mov_b32_e32 v253, v220
		v_pk_add_f32 v[204:205], v[252:253], v[250:251]
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
		v_mov_b32_e32 v220, v205
		v_mov_b32_e32 v221, v223
		v_mov_b32_e32 v224, v204
		v_mov_b32_e32 v225, v222
		v_pk_add_f32 v[204:205], v[224:225], v[220:221]
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
		v_mov_b32_e32 v220, v205
		v_mov_b32_e32 v221, v225
		v_mov_b32_e32 v222, v204
		v_mov_b32_e32 v223, v224
		v_pk_add_f32 v[204:205], v[222:223], v[220:221]
		v_mov_b32_e32 v220, v227
		v_mov_b32_e32 v221, v229
		v_mov_b32_e32 v222, v226
		v_mov_b32_e32 v223, v228
		v_pk_add_f32 v[224:225], v[222:223], v[220:221]
		v_mov_b32_e32 v220, v205
		v_mov_b32_e32 v221, v225
		v_mov_b32_e32 v222, v204
		v_mov_b32_e32 v223, v224
		v_pk_add_f32 v[204:205], v[222:223], v[220:221]
		v_add_f32_e32 v23, v204, v205
		ds_bpermute_b32 v144, v17, v23
		ds_bpermute_b32 v146, v19, v23
		v_pk_add_f32 v[204:205], v[148:149], v[150:151]
		v_pk_add_f32 v[220:221], v[152:153], v[154:155]
		v_pk_add_f32 v[222:223], v[156:157], v[158:159]
		v_pk_add_f32 v[224:225], v[160:161], v[162:163]
		v_pk_add_f32 v[226:227], v[164:165], v[166:167]
		v_pk_add_f32 v[228:229], v[168:169], v[170:171]
		v_pk_add_f32 v[230:231], v[172:173], v[174:175]
		v_pk_add_f32 v[232:233], v[176:177], v[178:179]
		v_pk_add_f32 v[234:235], v[180:181], v[182:183]
		v_pk_add_f32 v[236:237], v[184:185], v[186:187]
		v_pk_add_f32 v[238:239], v[188:189], v[190:191]
		v_pk_add_f32 v[240:241], v[206:207], v[208:209]
		v_pk_add_f32 v[242:243], v[210:211], v[212:213]
		v_pk_add_f32 v[244:245], v[192:193], v[194:195]
		v_pk_add_f32 v[246:247], v[196:197], v[198:199]
		v_mov_b32_e32 v248, v205
		v_mov_b32_e32 v249, v222
		v_pk_add_f32 v[250:251], v[248:249], v[220:221]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[220:221], v[144:145], v[146:147]
		v_mov_b32_e32 v201, v221
		v_mov_b32_e32 v203, v204
		v_pk_add_f32 v[204:205], v[200:201], v[202:203]
		v_mov_b32_e32 v248, v223
		v_mov_b32_e32 v249, v226
		v_pk_add_f32 v[222:223], v[248:249], v[224:225]
		v_mov_b32_e32 v224, v227
		v_mov_b32_e32 v225, v230
		v_pk_add_f32 v[226:227], v[224:225], v[228:229]
		v_mov_b32_e32 v224, v231
		v_mov_b32_e32 v225, v234
		v_pk_add_f32 v[224:225], v[224:225], v[232:233]
		v_mov_b32_e32 v228, v235
		v_mov_b32_e32 v229, v238
		v_pk_add_f32 v[230:231], v[228:229], v[236:237]
		v_mov_b32_e32 v228, v239
		v_mov_b32_e32 v229, v242
		v_pk_add_f32 v[228:229], v[228:229], v[240:241]
		v_mov_b32_e32 v232, v243
		v_mov_b32_e32 v233, v246
		v_pk_add_f32 v[234:235], v[232:233], v[244:245]
		v_mov_b32_e32 v232, v247
		v_mov_b32_e32 v233, v250
		v_pk_add_f32 v[204:205], v[232:233], v[204:205]
		v_mov_b32_e32 v232, v251
		v_mov_b32_e32 v233, v226
		v_pk_add_f32 v[236:237], v[232:233], v[222:223]
		v_mov_b32_e32 v222, v227
		v_mov_b32_e32 v223, v230
		v_pk_add_f32 v[222:223], v[222:223], v[224:225]
		v_mov_b32_e32 v224, v231
		v_mov_b32_e32 v225, v234
		v_pk_add_f32 v[226:227], v[224:225], v[228:229]
		v_mov_b32_e32 v224, v235
		v_mov_b32_e32 v225, v236
		v_pk_add_f32 v[204:205], v[224:225], v[204:205]
		v_mov_b32_e32 v224, v237
		v_mov_b32_e32 v225, v226
		v_pk_add_f32 v[228:229], v[224:225], v[222:223]
		v_mov_b32_e32 v222, v227
		v_mov_b32_e32 v223, v228
		v_pk_add_f32 v[224:225], v[222:223], v[204:205]
		v_add_f32_e32 v23, v229, v224
		v_add_f32_e32 v23, v225, v23
		ds_bpermute_b32 v144, v17, v23
		ds_bpermute_b32 v17, v19, v23
		v_sub_f32_e32 v10, v10, v16
		v_sub_f32_e32 v11, v11, v18
		v_exp_f32_e32 v204, v10
		v_exp_f32_e32 v222, v11
		v_mov_b32_e32 v205, v204
		v_pk_mul_f32 v[32:33], v[32:33], v[204:205]
		v_pk_mul_f32 v[34:35], v[34:35], v[204:205]
		v_pk_mul_f32 v[36:37], v[36:37], v[204:205]
		v_pk_mul_f32 v[38:39], v[38:39], v[204:205]
		v_pk_mul_f32 v[40:41], v[40:41], v[204:205]
		v_pk_mul_f32 v[42:43], v[42:43], v[204:205]
		v_pk_mul_f32 v[44:45], v[44:45], v[204:205]
		v_pk_mul_f32 v[46:47], v[46:47], v[204:205]
		v_pk_mul_f32 v[48:49], v[48:49], v[204:205]
		v_pk_mul_f32 v[50:51], v[50:51], v[204:205]
		v_pk_mul_f32 v[52:53], v[52:53], v[204:205]
		v_pk_mul_f32 v[54:55], v[54:55], v[204:205]
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v11, v144, v17
		v_pk_mul_f32 v[56:57], v[56:57], v[204:205]
		v_pk_mul_f32 v[58:59], v[58:59], v[204:205]
		v_pk_mul_f32 v[60:61], v[60:61], v[204:205]
		v_pk_mul_f32 v[62:63], v[62:63], v[204:205]
		v_mov_b32_e32 v223, v222
		v_pk_mul_f32 v[64:65], v[64:65], v[222:223]
		v_pk_mul_f32 v[66:67], v[66:67], v[222:223]
		v_pk_mul_f32 v[68:69], v[68:69], v[222:223]
		v_pk_mul_f32 v[70:71], v[70:71], v[222:223]
		v_pk_mul_f32 v[72:73], v[72:73], v[222:223]
		v_pk_mul_f32 v[74:75], v[74:75], v[222:223]
		v_pk_mul_f32 v[76:77], v[76:77], v[222:223]
		v_pk_mul_f32 v[78:79], v[78:79], v[222:223]
		v_pk_mul_f32 v[80:81], v[80:81], v[222:223]
		v_pk_mul_f32 v[82:83], v[82:83], v[222:223]
		v_pk_mul_f32 v[84:85], v[84:85], v[222:223]
		v_pk_mul_f32 v[86:87], v[86:87], v[222:223]
		v_pk_mul_f32 v[88:89], v[88:89], v[222:223]
		v_pk_mul_f32 v[90:91], v[90:91], v[222:223]
		v_pk_mul_f32 v[92:93], v[92:93], v[222:223]
		v_pk_mul_f32 v[94:95], v[94:95], v[222:223]
		v_mov_b32_e32 v10, v220
		v_mov_b32_e32 v220, v204
		v_mov_b32_e32 v221, v222
		v_mov_b64_e32 v[204:205], v[12:13]
		v_pk_fma_f32 v[12:13], v[204:205], v[220:221], v[10:11]
		v_cvt_pk_bf16_f32 v220, v214, v216
		v_cvt_pk_bf16_f32 v221, v215, v217
		v_cvt_pk_bf16_f32 v222, v24, v26
		v_cvt_pk_bf16_f32 v223, v25, v27
		v_cvt_pk_bf16_f32 v24, v28, v30
		v_cvt_pk_bf16_f32 v25, v29, v31
		v_cvt_pk_bf16_f32 v26, v96, v98
		v_cvt_pk_bf16_f32 v27, v97, v99
		v_cvt_pk_bf16_f32 v28, v100, v104
		v_cvt_pk_bf16_f32 v29, v101, v105
		v_cvt_pk_bf16_f32 v30, v106, v108
		v_cvt_pk_bf16_f32 v31, v107, v109
		v_cvt_pk_bf16_f32 v96, v110, v112
		v_cvt_pk_bf16_f32 v97, v111, v113
		v_cvt_pk_bf16_f32 v98, v114, v116
		v_cvt_pk_bf16_f32 v99, v115, v117
		v_cvt_pk_bf16_f32 v104, v118, v218
		v_cvt_pk_bf16_f32 v105, v119, v219
		v_cvt_pk_bf16_f32 v106, v20, v102
		v_cvt_pk_bf16_f32 v107, v21, v103
		v_cvt_pk_bf16_f32 v100, v120, v122
		v_cvt_pk_bf16_f32 v101, v121, v123
		v_cvt_pk_bf16_f32 v102, v124, v126
		v_cvt_pk_bf16_f32 v103, v125, v127
		v_cvt_pk_bf16_f32 v108, v128, v130
		v_cvt_pk_bf16_f32 v109, v129, v131
		v_cvt_pk_bf16_f32 v110, v132, v134
		v_cvt_pk_bf16_f32 v111, v133, v135
		v_cvt_pk_bf16_f32 v112, v136, v138
		v_cvt_pk_bf16_f32 v113, v137, v139
		v_cvt_pk_bf16_f32 v114, v140, v142
		v_cvt_pk_bf16_f32 v115, v141, v143
		v_cvt_pk_bf16_f32 v116, v145, v147
		v_cvt_pk_bf16_f32 v117, v148, v150
		v_cvt_pk_bf16_f32 v118, v149, v151
		v_cvt_pk_bf16_f32 v119, v152, v154
		v_cvt_pk_bf16_f32 v120, v153, v155
		v_cvt_pk_bf16_f32 v121, v156, v158
		v_cvt_pk_bf16_f32 v122, v157, v159
		v_cvt_pk_bf16_f32 v123, v160, v162
		v_cvt_pk_bf16_f32 v124, v161, v163
		v_cvt_pk_bf16_f32 v125, v164, v166
		v_cvt_pk_bf16_f32 v126, v165, v167
		v_cvt_pk_bf16_f32 v127, v168, v170
		v_cvt_pk_bf16_f32 v128, v169, v171
		v_cvt_pk_bf16_f32 v129, v172, v174
		v_cvt_pk_bf16_f32 v130, v173, v175
		v_cvt_pk_bf16_f32 v131, v176, v178
		v_cvt_pk_bf16_f32 v132, v177, v179
		v_cvt_pk_bf16_f32 v133, v180, v182
		v_cvt_pk_bf16_f32 v134, v181, v183
		v_cvt_pk_bf16_f32 v135, v184, v186
		v_cvt_pk_bf16_f32 v136, v185, v187
		v_cvt_pk_bf16_f32 v137, v188, v190
		v_cvt_pk_bf16_f32 v138, v189, v191
		v_cvt_pk_bf16_f32 v139, v206, v208
		v_cvt_pk_bf16_f32 v140, v207, v209
		v_cvt_pk_bf16_f32 v141, v210, v212
		v_cvt_pk_bf16_f32 v142, v211, v213
		v_cvt_pk_bf16_f32 v143, v192, v194
		v_cvt_pk_bf16_f32 v144, v193, v195
		v_cvt_pk_bf16_f32 v145, v196, v198
		v_cvt_pk_bf16_f32 v146, v197, v199
		v_cvt_pk_bf16_f32 v147, v200, v202
		v_permlane32_swap_b32_e32 v220, v222
		v_permlane32_swap_b32_e32 v221, v223
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[32:47], a[76:79], v[220:223], v[32:47]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_mfma_f32_32x32x16_bf16 v[48:63], a[156:159], v[220:223], v[48:63]
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
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], v[116:119], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[76:79], v[116:119], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[80:83], v[24:27], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[160:163], v[24:27], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[160:163], v[120:123], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[80:83], v[120:123], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[132:135], v[28:31], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[164:167], v[28:31], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[164:167], v[124:127], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[132:135], v[124:127], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[136:139], v[96:99], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[168:171], v[96:99], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[168:171], v[128:131], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[136:139], v[128:131], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[140:143], v[104:107], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[172:175], v[104:107], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[172:175], v[132:135], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[140:143], v[132:135], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[144:147], v[100:103], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[176:179], v[100:103], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[176:179], v[136:139], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[144:147], v[136:139], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[148:151], v[108:111], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[180:183], v[108:111], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[180:183], v[140:143], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[148:151], v[140:143], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[152:155], v[112:115], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[184:187], v[112:115], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[184:187], v[144:147], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[152:155], v[144:147], v[64:79]
		s_mov_b32 s22, s47
		v_mov_b32_e32 v10, v16
		v_mov_b32_e32 v11, v18
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_3
.L_attn_fwd_persistent.loop_exit_3:
		s_cmp_lt_i32 s46, s39
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_4
.L_attn_fwd_persistent.loop_head_4:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s22, s46, 0x80
		s_cmp_lt_i32 s46, 0
		s_cselect_b32 s37, s36, 0
		s_add_i32 s37, s46, s37
		s_ashr_i32 s37, s37, 7
		s_cmp_lt_i32 s37, 0
		s_cselect_b32 s44, s16, 0
		s_add_i32 s44, s37, s44
		s_ashr_i32 s44, s44, 1
		s_lshl_b32 s44, s44, 1
		s_xor_b32 s44, s44, -1
		s_add_i32 s44, s44, 1
		s_add_i32 s44, s37, s44
		s_add_i32 s37, s37, 1
		s_cmp_lt_i32 s37, 0
		s_cselect_b32 s47, s16, 0
		s_add_i32 s47, s37, s47
		s_ashr_i32 s47, s47, 1
		s_lshl_b32 s47, s47, 1
		s_xor_b32 s47, s47, -1
		s_add_i32 s47, s47, 1
		s_add_i32 s52, s37, s47
		s_mul_i32 s37, 0x4100, s44
		v_accvgpr_read_b32 v16, a34
		v_add_u32_e32 v16, s37, v16
		ds_read_b128 v[24:27], v16
		ds_read_b128 a[48:51], v16 offset:32
		ds_read_b128 a[52:55], v16 offset:64
		ds_read_b128 a[56:59], v16 offset:96
		ds_read_b128 v[28:31], v16 offset:256
		ds_read_b128 a[60:63], v16 offset:288
		ds_read_b128 a[64:67], v16 offset:320
		ds_read_b128 a[68:71], v16 offset:352
		ds_read_b128 a[72:75], v16 offset:128
		ds_read_b128 a[76:79], v16 offset:160
		ds_read_b128 a[80:83], v16 offset:192
		ds_read_b128 a[84:87], v16 offset:224
		ds_read_b128 v[96:99], v16 offset:384
		ds_read_b128 a[88:91], v16 offset:416
		ds_read_b128 a[132:135], v16 offset:448
		ds_read_b128 a[136:139], v16 offset:480
		s_mul_i32 s37, 0x4400, s44
		v_accvgpr_read_b32 v16, a94
		v_add_u32_e32 v16, s37, v16
		ds_read_b64_tr_b16 a[140:141], v16 offset:33264
		ds_read_b64_tr_b16 a[142:143], v16 offset:37616
		ds_read_b64_tr_b16 a[144:145], v16 offset:33392
		ds_read_b64_tr_b16 a[146:147], v16 offset:37744
		ds_read_b64_tr_b16 a[148:149], v16 offset:33520
		ds_read_b64_tr_b16 a[150:151], v16 offset:37872
		ds_read_b64_tr_b16 a[152:153], v16 offset:33648
		ds_read_b64_tr_b16 a[154:155], v16 offset:38000
		ds_read_b64_tr_b16 a[156:157], v16 offset:33776
		ds_read_b64_tr_b16 a[158:159], v16 offset:38128
		ds_read_b64_tr_b16 a[160:161], v16 offset:33904
		ds_read_b64_tr_b16 a[162:163], v16 offset:38256
		ds_read_b64_tr_b16 a[164:165], v16 offset:34032
		ds_read_b64_tr_b16 a[166:167], v16 offset:38384
		ds_read_b64_tr_b16 a[168:169], v16 offset:34160
		ds_read_b64_tr_b16 a[170:171], v16 offset:38512
		ds_read_b64_tr_b16 a[172:173], v16 offset:33328
		ds_read_b64_tr_b16 a[174:175], v16 offset:37680
		ds_read_b64_tr_b16 a[176:177], v16 offset:33456
		ds_read_b64_tr_b16 a[178:179], v16 offset:37808
		ds_read_b64_tr_b16 a[180:181], v16 offset:33584
		ds_read_b64_tr_b16 a[182:183], v16 offset:37936
		ds_read_b64_tr_b16 a[184:185], v16 offset:33712
		ds_read_b64_tr_b16 a[186:187], v16 offset:38064
		ds_read_b64_tr_b16 a[188:189], v16 offset:33840
		ds_read_b64_tr_b16 a[190:191], v16 offset:38192
		ds_read_b64_tr_b16 a[192:193], v16 offset:33968
		ds_read_b64_tr_b16 a[194:195], v16 offset:38320
		ds_read_b64_tr_b16 a[196:197], v16 offset:34096
		ds_read_b64_tr_b16 a[198:199], v16 offset:38448
		ds_read_b64_tr_b16 a[200:201], v16 offset:34224
		ds_read_b64_tr_b16 a[202:203], v16 offset:38576
		s_cmp_lt_i32 s22, s26
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_2
		s_waitcnt vmcnt(0) lgkmcnt(14)
		s_barrier
		v_lshrrev_b32_e32 v16, 3, v0
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v17, 64
		v_mul_lo_u32 v17, v17, v16
		v_lshrrev_b32_e32 v16, 4, v0
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v18, 32
		v_mul_lo_u32 v18, v18, v16
		v_lshrrev_b32_e32 v16, 5, v0
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v19, 16
		v_mul_lo_u32 v19, v19, v16
		v_bitop3_b32 v16, v17, v18, v19 bitop3:0x96
		v_lshrrev_b32_e32 v17, 6, v0
		v_and_b32_e32 v17, 1, v17
		v_and_b32_e32 v18, 1, v22
		v_mov_b32_e32 v19, 2
		v_mul_lo_u32 v19, v19, v18
		v_bitop3_b32 v16, v16, v17, v19 bitop3:0x96
		v_add_u32_e32 v16, s22, v16
		v_lshrrev_b32_e32 v17, 3, v0
		v_and_b32_e32 v17, 1, v17
		v_mov_b32_e32 v18, 64
		v_mul_lo_u32 v18, v18, v17
		v_lshrrev_b32_e32 v17, 4, v0
		v_and_b32_e32 v17, 1, v17
		v_mov_b32_e32 v19, 32
		v_mul_lo_u32 v19, v19, v17
		v_bitop3_b32 v17, 4, v18, v19 bitop3:0x96
		v_lshrrev_b32_e32 v18, 5, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v19, 16
		v_mul_lo_u32 v19, v19, v18
		v_xor_b32_e32 v17, v17, v19
		v_lshrrev_b32_e32 v18, 6, v0
		v_and_b32_e32 v18, 1, v18
		v_and_b32_e32 v19, 1, v22
		v_mov_b32_e32 v20, 2
		v_mul_lo_u32 v20, v20, v19
		v_bitop3_b32 v17, v17, v18, v20 bitop3:0x96
		v_add_u32_e32 v17, s22, v17
		v_lshrrev_b32_e32 v18, 3, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v19, 64
		v_mul_lo_u32 v19, v19, v18
		v_lshrrev_b32_e32 v18, 4, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v20, 32
		v_mul_lo_u32 v20, v20, v18
		v_bitop3_b32 v18, 8, v19, v20 bitop3:0x96
		v_lshrrev_b32_e32 v19, 5, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 16
		v_mul_lo_u32 v20, v20, v19
		v_xor_b32_e32 v18, v18, v20
		v_lshrrev_b32_e32 v19, 6, v0
		v_and_b32_e32 v19, 1, v19
		v_and_b32_e32 v20, 1, v22
		v_mov_b32_e32 v21, 2
		v_mul_lo_u32 v21, v21, v20
		v_bitop3_b32 v18, v18, v19, v21 bitop3:0x96
		v_add_u32_e32 v18, s22, v18
		v_lshrrev_b32_e32 v19, 3, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 64
		v_mul_lo_u32 v20, v20, v19
		v_lshrrev_b32_e32 v19, 4, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v21, 32
		v_mul_lo_u32 v21, v21, v19
		v_bitop3_b32 v19, 12, v20, v21 bitop3:0x96
		v_lshrrev_b32_e32 v20, 5, v0
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v21, 16
		v_mul_lo_u32 v21, v21, v20
		v_xor_b32_e32 v19, v19, v21
		v_lshrrev_b32_e32 v20, 6, v0
		v_and_b32_e32 v20, 1, v20
		v_and_b32_e32 v21, 1, v22
		v_mov_b32_e32 v23, 2
		v_mul_lo_u32 v23, v23, v21
		v_bitop3_b32 v19, v19, v20, v23 bitop3:0x96
		v_add_u32_e32 v19, s22, v19
		v_cmp_lt_i32_e64 vcc, v16, s24
		s_mov_b64 s[54:55], vcc
		v_cmp_lt_i32_e64 vcc, v17, s24
		s_mov_b64 s[58:59], vcc
		v_cmp_lt_i32_e64 vcc, v18, s24
		s_mov_b64 s[60:61], vcc
		v_cmp_lt_i32_e64 vcc, v19, s24
		s_mov_b64 s[62:63], vcc
		v_lshrrev_b32_e32 v16, 3, v0
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v17, 16
		v_mul_lo_u32 v17, v17, v16
		v_lshrrev_b32_e32 v16, 4, v0
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v18, 32
		v_mul_lo_u32 v18, v18, v16
		v_lshrrev_b32_e32 v16, 5, v0
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v19, 64
		v_mul_lo_u32 v19, v19, v16
		v_bitop3_b32 v16, v17, v18, v19 bitop3:0x96
		v_lshrrev_b32_e32 v17, 6, v0
		v_and_b32_e32 v17, 1, v17
		v_and_b32_e32 v18, 1, v22
		v_mov_b32_e32 v19, 2
		v_mul_lo_u32 v19, v19, v18
		v_bitop3_b32 v16, v16, v17, v19 bitop3:0x96
		v_add_u32_e32 v16, s22, v16
		v_lshrrev_b32_e32 v17, 3, v0
		v_and_b32_e32 v17, 1, v17
		v_mov_b32_e32 v18, 16
		v_mul_lo_u32 v18, v18, v17
		v_lshrrev_b32_e32 v17, 4, v0
		v_and_b32_e32 v17, 1, v17
		v_mov_b32_e32 v19, 32
		v_mul_lo_u32 v19, v19, v17
		v_bitop3_b32 v17, 4, v18, v19 bitop3:0x96
		v_lshrrev_b32_e32 v18, 5, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v19, 64
		v_mul_lo_u32 v19, v19, v18
		v_xor_b32_e32 v17, v17, v19
		v_lshrrev_b32_e32 v18, 6, v0
		v_and_b32_e32 v18, 1, v18
		v_and_b32_e32 v19, 1, v22
		v_mov_b32_e32 v20, 2
		v_mul_lo_u32 v20, v20, v19
		v_bitop3_b32 v17, v17, v18, v20 bitop3:0x96
		v_add_u32_e32 v17, s22, v17
		v_lshrrev_b32_e32 v18, 3, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v19, 16
		v_mul_lo_u32 v19, v19, v18
		v_lshrrev_b32_e32 v18, 4, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v20, 32
		v_mul_lo_u32 v20, v20, v18
		v_bitop3_b32 v18, 8, v19, v20 bitop3:0x96
		v_lshrrev_b32_e32 v19, 5, v0
		v_and_b32_e32 v19, 1, v19
		v_mov_b32_e32 v20, 64
		v_mul_lo_u32 v20, v20, v19
		v_xor_b32_e32 v18, v18, v20
		v_lshrrev_b32_e32 v19, 6, v0
		v_and_b32_e32 v19, 1, v19
		v_and_b32_e32 v20, 1, v22
		v_mov_b32_e32 v21, 2
		v_mul_lo_u32 v21, v21, v20
		v_bitop3_b32 v18, v18, v19, v21 bitop3:0x96
		v_add_u32_e32 v18, s22, v18
		v_cmp_lt_i32_e64 vcc, v16, s24
		s_mov_b64 s[64:65], vcc
		v_cmp_lt_i32_e64 vcc, v17, s24
		s_mov_b64 s[66:67], vcc
		v_cmp_lt_i32_e64 vcc, v18, s24
		s_mov_b64 s[68:69], vcc
		s_mul_i32 s37, s15, s46
		s_lshl_b32 s37, s37, 1
		s_lshl_b32 s44, s15, 8
		s_mul_i32 s47, s1, s13
		s_lshl_b32 s47, s47, 1
		s_add_i32 s44, s44, s47
		s_mul_i32 s47, s25, s14
		s_lshl_b32 s47, s47, 1
		s_add_i32 s44, s44, s47
		s_add_i32 s44, s44, s37
		v_add_u32_e32 v16, s44, v8
		s_mov_b32 s70, 1
		s_mov_b32 s71, 0
		s_mov_b32 s73, 0
		s_mov_b32 s72, s56
		s_mul_i32 s74, s70, s72
		s_mul_hi_u32 s75, s70, s72
		s_mul_i32 s44, s70, s73
		s_add_i32 s75, s75, s44
		s_mul_i32 s44, s71, s72
		s_add_i32 s75, s75, s44
		s_lshr_b64 s[70:71], s[74:75], 6
		s_mov_b32 s72, 0x410
		s_mov_b32 s73, 0
		s_mul_i32 s74, s72, s70
		s_mul_hi_u32 s75, s72, s70
		s_mul_i32 s44, s72, s71
		s_add_i32 s75, s75, s44
		s_mul_i32 s44, s73, s70
		s_add_i32 s75, s75, s44
		s_cmp_lt_i32 s52, 0
		s_cselect_b32 s53, -1, 0
		s_mov_b32 s72, 0x4100
		s_mov_b32 s73, 0
		s_mul_i32 s76, s72, s52
		s_mul_hi_u32 s77, s72, s52
		s_mul_i32 s44, s72, s53
		s_add_i32 s77, s77, s44
		s_mul_i32 s44, s73, s52
		s_add_i32 s77, s77, s44
		s_add_u32 s72, s74, s76
		s_addc_u32 s73, s75, s77
		s_add_u32 s78, s72, 0
		s_addc_u32 s79, s73, 0
		s_mov_b32 m0, s78
		v_cndmask_b32_e64 v16, v7, v16, s[54:55]
		buffer_load_dwordx4 v16, s[28:31], 0 offen lds
		v_lshrrev_b32_e32 v16, 3, v0
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v17, 16
		v_mul_lo_u32 v17, v17, v16
		v_lshrrev_b32_e32 v16, 4, v0
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v18, 32
		v_mul_lo_u32 v18, v18, v16
		v_bitop3_b32 v16, 12, v17, v18 bitop3:0x96
		v_lshrrev_b32_e32 v17, 5, v0
		v_and_b32_e32 v17, 1, v17
		v_mov_b32_e32 v18, 64
		v_mul_lo_u32 v18, v18, v17
		v_xor_b32_e32 v16, v16, v18
		v_lshrrev_b32_e32 v17, 6, v0
		v_and_b32_e32 v17, 1, v17
		v_and_b32_e32 v18, 1, v22
		v_mov_b32_e32 v19, 2
		v_mul_lo_u32 v19, v19, v18
		v_bitop3_b32 v16, v16, v17, v19 bitop3:0x96
		v_add_u32_e32 v16, s22, v16
		s_mul_i32 s44, 0x108, s15
		s_mul_i32 s47, s1, s13
		s_lshl_b32 s47, s47, 1
		s_add_i32 s44, s44, s47
		s_mul_i32 s47, s25, s14
		s_lshl_b32 s47, s47, 1
		s_add_i32 s44, s44, s47
		s_add_i32 s44, s44, s37
		v_add_u32_e32 v17, s44, v8
		s_add_u32 s54, s74, 0x1040
		s_addc_u32 s55, s75, 0
		s_add_u32 s54, s54, s76
		s_addc_u32 s55, s55, s77
		s_add_u32 s72, s54, 0
		s_addc_u32 s73, s55, 0
		s_mov_b32 m0, s72
		v_cndmask_b32_e64 v17, v7, v17, s[58:59]
		buffer_load_dwordx4 v17, s[28:31], 0 offen lds
		s_mul_i32 s44, 0x110, s15
		s_mul_i32 s47, s1, s13
		s_lshl_b32 s47, s47, 1
		s_add_i32 s44, s44, s47
		s_mul_i32 s47, s25, s14
		s_lshl_b32 s47, s47, 1
		s_add_i32 s44, s44, s47
		s_add_i32 s44, s44, s37
		v_add_u32_e32 v17, s44, v8
		s_add_u32 s54, s74, 0x2080
		s_addc_u32 s55, s75, 0
		s_add_u32 s54, s54, s76
		s_addc_u32 s55, s55, s77
		s_add_u32 s58, s54, 0
		s_addc_u32 s59, s55, 0
		s_mov_b32 m0, s58
		v_cndmask_b32_e64 v17, v7, v17, s[60:61]
		buffer_load_dwordx4 v17, s[28:31], 0 offen lds
		s_mul_i32 s44, 0x118, s15
		s_mul_i32 s47, s1, s13
		s_lshl_b32 s47, s47, 1
		s_add_i32 s44, s44, s47
		s_mul_i32 s47, s25, s14
		s_lshl_b32 s47, s47, 1
		s_add_i32 s44, s44, s47
		s_add_i32 s37, s44, s37
		v_add_u32_e32 v17, s37, v8
		s_add_u32 s54, s74, 0x30c0
		s_addc_u32 s55, s75, 0
		s_add_u32 s54, s54, s76
		s_addc_u32 s55, s55, s77
		s_add_u32 s58, s54, 0
		s_addc_u32 s59, s55, 0
		s_mov_b32 m0, s58
		v_cndmask_b32_e64 v17, v7, v17, s[62:63]
		buffer_load_dwordx4 v17, s[28:31], 0 offen lds
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s37, s21, s46
		s_lshl_b32 s37, s37, 1
		s_lshl_b32 s44, s21, 8
		s_mul_i32 s47, s1, s19
		s_lshl_b32 s47, s47, 1
		s_add_i32 s44, s44, s47
		s_mul_i32 s47, s25, s20
		s_lshl_b32 s47, s47, 1
		s_add_i32 s44, s44, s47
		s_add_i32 s44, s44, s37
		v_add_u32_e32 v17, s44, v14
		s_mov_b32 s54, 0x440
		s_mov_b32 s55, 0
		s_mul_i32 s58, s54, s70
		s_mul_hi_u32 s59, s54, s70
		s_mul_i32 s44, s54, s71
		s_add_i32 s59, s59, s44
		s_mul_i32 s44, s55, s70
		s_add_i32 s59, s59, s44
		s_add_u32 s54, s58, 0x81f0
		s_addc_u32 s55, s59, 0
		s_mov_b32 s60, 0x4400
		s_mov_b32 s61, 0
		s_mul_i32 s62, s60, s52
		s_mul_hi_u32 s63, s60, s52
		s_mul_i32 s44, s60, s53
		s_add_i32 s63, s63, s44
		s_mul_i32 s44, s61, s52
		s_add_i32 s63, s63, s44
		s_add_u32 s52, s54, s62
		s_addc_u32 s53, s55, s63
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v17, v7, v17, s[64:65]
		buffer_load_dwordx4 v17, s[32:35], 0 offen lds
		s_mul_i32 s44, 0x108, s21
		s_mul_i32 s47, s1, s19
		s_lshl_b32 s47, s47, 1
		s_add_i32 s44, s44, s47
		s_mul_i32 s47, s25, s20
		s_lshl_b32 s47, s47, 1
		s_add_i32 s44, s44, s47
		s_add_i32 s44, s44, s37
		v_add_u32_e32 v17, s44, v14
		s_add_u32 s52, s58, 0x92f0
		s_addc_u32 s53, s59, 0
		s_add_u32 s52, s52, s62
		s_addc_u32 s53, s53, s63
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v17, v7, v17, s[66:67]
		buffer_load_dwordx4 v17, s[32:35], 0 offen lds
		s_mul_i32 s44, 0x110, s21
		s_mul_i32 s47, s1, s19
		s_lshl_b32 s47, s47, 1
		s_add_i32 s44, s44, s47
		s_mul_i32 s47, s25, s20
		s_lshl_b32 s47, s47, 1
		s_add_i32 s44, s44, s47
		s_add_i32 s44, s44, s37
		v_add_u32_e32 v17, s44, v14
		s_add_u32 s52, s58, 0xa3f0
		s_addc_u32 s53, s59, 0
		s_add_u32 s52, s52, s62
		s_addc_u32 s53, s53, s63
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v17, v7, v17, s[68:69]
		buffer_load_dwordx4 v17, s[32:35], 0 offen lds
		s_mul_i32 s44, 0x118, s21
		s_mul_i32 s47, s1, s19
		s_lshl_b32 s47, s47, 1
		s_add_i32 s44, s44, s47
		s_mul_i32 s47, s25, s20
		s_lshl_b32 s47, s47, 1
		s_add_i32 s44, s44, s47
		s_add_i32 s37, s44, s37
		v_cmp_lt_i32_e64 vcc, v16, s24
		v_add_u32_e32 v16, s37, v14
		s_add_u32 s52, s58, 0xb4f0
		s_addc_u32 s53, s59, 0
		v_cndmask_b32_e32 v16, v7, v16, vcc
		s_add_u32 s52, s52, s62
		s_addc_u32 s53, s53, s63
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		s_nop 0
		buffer_load_dwordx4 v16, s[32:35], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_2
.L_attn_fwd_persistent.if_else_2:
.L_attn_fwd_persistent.if_end_2:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[112:127], v[24:27], a[12:15], 0
		v_lshrrev_b32_e32 v16, 5, v0
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v17, 4
		v_mul_lo_u32 v17, v17, v16
		v_add_u32_e32 v16, s46, v17
		v_accvgpr_read_b32 v17, a98
		v_add_u32_e32 v17, s46, v17
		v_accvgpr_read_b32 v18, a99
		v_add_u32_e32 v18, s46, v18
		v_accvgpr_read_b32 v19, a100
		v_add_u32_e32 v19, s46, v19
		v_accvgpr_read_b32 v20, a103
		v_add_u32_e32 v20, s46, v20
		v_accvgpr_read_b32 v21, a104
		v_add_u32_e32 v21, s46, v21
		v_accvgpr_read_b32 v23, a107
		v_add_u32_e32 v23, s46, v23
		v_mfma_f32_32x32x16_bf16 v[128:143], v[28:31], a[12:15], 0
		v_accvgpr_read_b32 v100, a108
		v_add_u32_e32 v100, s46, v100
		v_accvgpr_read_b32 v101, a111
		v_add_u32_e32 v101, s46, v101
		v_accvgpr_read_b32 v102, a112
		v_add_u32_e32 v102, s46, v102
		v_accvgpr_read_b32 v103, a115
		v_add_u32_e32 v103, s46, v103
		v_accvgpr_read_b32 v104, a116
		v_add_u32_e32 v104, s46, v104
		v_accvgpr_read_b32 v105, a119
		v_add_u32_e32 v105, s46, v105
		v_accvgpr_read_b32 v106, a120
		v_add_u32_e32 v106, s46, v106
		v_mfma_f32_32x32x16_bf16 v[144:159], a[72:75], a[12:15], 0
		v_accvgpr_read_b32 v107, a123
		v_add_u32_e32 v107, s46, v107
		v_accvgpr_read_b32 v108, a124
		v_add_u32_e32 v108, s46, v108
		v_accvgpr_read_b32 v109, a127
		v_add_u32_e32 v109, s46, v109
		v_accvgpr_read_b32 v110, a128
		v_add_u32_e32 v110, s46, v110
		v_accvgpr_read_b32 v111, a131
		v_add_u32_e32 v111, s46, v111
		v_accvgpr_write_b32 a5, v111
		v_lshrrev_b32_e32 v111, 5, v0
		v_and_b32_e32 v111, 1, v111
		v_mov_b32_e32 v160, 4
		v_mul_lo_u32 v160, v160, v111
		v_xor_b32_e32 v111, 0x43, v160
		v_add_u32_e32 v111, s46, v111
		v_accvgpr_write_b32 a9, v111
		v_lshrrev_b32_e32 v111, 5, v0
		v_and_b32_e32 v111, 1, v111
		v_mov_b32_e32 v160, 4
		v_mul_lo_u32 v160, v160, v111
		v_xor_b32_e32 v111, 0x4a, v160
		v_add_u32_e32 v111, s46, v111
		v_accvgpr_write_b32 a11, v111
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], a[12:15], 0
		v_lshrrev_b32_e32 v111, 5, v0
		v_and_b32_e32 v111, 1, v111
		v_mov_b32_e32 v176, 4
		v_mul_lo_u32 v176, v176, v111
		v_xor_b32_e32 v111, 0x4b, v176
		v_add_u32_e32 v111, s46, v111
		v_accvgpr_write_b32 a32, v111
		v_lshrrev_b32_e32 v111, 5, v0
		v_and_b32_e32 v111, 1, v111
		v_mov_b32_e32 v176, 4
		v_mul_lo_u32 v176, v176, v111
		v_xor_b32_e32 v111, 0x52, v176
		v_add_u32_e32 v111, s46, v111
		v_accvgpr_write_b32 a33, v111
		v_lshrrev_b32_e32 v111, 5, v0
		v_and_b32_e32 v111, 1, v111
		v_mov_b32_e32 v176, 4
		v_mul_lo_u32 v176, v176, v111
		v_xor_b32_e32 v111, 0x53, v176
		v_add_u32_e32 v111, s46, v111
		v_accvgpr_write_b32 a35, v111
		v_lshrrev_b32_e32 v111, 5, v0
		v_and_b32_e32 v111, 1, v111
		v_mov_b32_e32 v176, 4
		v_mul_lo_u32 v176, v176, v111
		v_xor_b32_e32 v111, 0x5a, v176
		v_add_u32_e32 v111, s46, v111
		v_accvgpr_write_b32 a92, v111
		v_lshrrev_b32_e32 v111, 5, v0
		v_and_b32_e32 v111, 1, v111
		v_mov_b32_e32 v176, 4
		v_mul_lo_u32 v176, v176, v111
		v_xor_b32_e32 v111, 0x5b, v176
		v_add_u32_e32 v111, s46, v111
		v_accvgpr_write_b32 a93, v111
		v_lshrrev_b32_e32 v111, 5, v0
		v_and_b32_e32 v111, 1, v111
		v_mov_b32_e32 v176, 4
		v_mul_lo_u32 v176, v176, v111
		v_xor_b32_e32 v111, 0x62, v176
		v_add_u32_e32 v111, s46, v111
		v_accvgpr_write_b32 a95, v111
		v_lshrrev_b32_e32 v111, 5, v0
		v_and_b32_e32 v111, 1, v111
		v_mov_b32_e32 v176, 4
		v_mul_lo_u32 v176, v176, v111
		v_xor_b32_e32 v111, 0x63, v176
		v_add_u32_e32 v111, s46, v111
		v_accvgpr_write_b32 a96, v111
		v_mfma_f32_32x32x16_bf16 v[176:191], v[96:99], a[28:31], 0
		v_lshrrev_b32_e32 v96, 5, v0
		v_and_b32_e32 v96, 1, v96
		v_mov_b32_e32 v97, 4
		v_mul_lo_u32 v97, v97, v96
		v_xor_b32_e32 v96, 0x6a, v97
		v_add_u32_e32 v96, s46, v96
		v_accvgpr_write_b32 a97, v96
		v_lshrrev_b32_e32 v96, 5, v0
		v_and_b32_e32 v96, 1, v96
		v_mov_b32_e32 v97, 4
		v_mul_lo_u32 v97, v97, v96
		v_xor_b32_e32 v96, 0x6b, v97
		v_add_u32_e32 v96, s46, v96
		v_accvgpr_write_b32 a204, v96
		v_lshrrev_b32_e32 v96, 5, v0
		v_and_b32_e32 v96, 1, v96
		v_mov_b32_e32 v97, 4
		v_mul_lo_u32 v97, v97, v96
		v_xor_b32_e32 v96, 0x72, v97
		v_add_u32_e32 v96, s46, v96
		v_accvgpr_write_b32 a205, v96
		v_lshrrev_b32_e32 v96, 5, v0
		v_and_b32_e32 v96, 1, v96
		v_mov_b32_e32 v97, 4
		v_mul_lo_u32 v97, v97, v96
		v_xor_b32_e32 v96, 0x73, v97
		v_add_u32_e32 v96, s46, v96
		v_accvgpr_write_b32 a206, v96
		v_lshrrev_b32_e32 v96, 5, v0
		v_and_b32_e32 v96, 1, v96
		v_mov_b32_e32 v97, 4
		v_mul_lo_u32 v97, v97, v96
		v_xor_b32_e32 v96, 0x7a, v97
		v_add_u32_e32 v96, s46, v96
		v_accvgpr_write_b32 a207, v96
		v_lshrrev_b32_e32 v96, 5, v0
		v_and_b32_e32 v96, 1, v96
		v_mov_b32_e32 v97, 4
		v_mul_lo_u32 v97, v97, v96
		v_xor_b32_e32 v96, 0x7b, v97
		v_add_u32_e32 v96, s46, v96
		v_accvgpr_write_b32 a208, v96
		v_cmp_ge_i32_e64 vcc, v9, v16
		s_mov_b64 s[52:53], vcc
		v_mfma_f32_32x32x16_bf16 v[192:207], v[24:27], a[28:31], 0
		v_cmp_ge_i32_e64 vcc, v9, v17
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v9, v18
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v9, v19
		v_accvgpr_read_b32 v24, a101
		v_add_u32_e32 v24, s46, v24
		v_accvgpr_read_b32 v25, a102
		v_add_u32_e32 v25, s46, v25
		v_accvgpr_read_b32 v26, a105
		v_add_u32_e32 v26, s46, v26
		v_accvgpr_read_b32 v27, a106
		v_add_u32_e32 v27, s46, v27
		v_mfma_f32_32x32x16_bf16 v[208:223], v[28:31], a[28:31], 0
		v_accvgpr_read_b32 v28, a109
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_read_b32 v29, a110
		v_add_u32_e32 v29, s46, v29
		v_accvgpr_read_b32 v30, a113
		v_add_u32_e32 v30, s46, v30
		v_accvgpr_read_b32 v31, a114
		v_add_u32_e32 v31, s46, v31
		v_accvgpr_read_b32 v96, a117
		v_add_u32_e32 v96, s46, v96
		v_accvgpr_read_b32 v97, a118
		v_add_u32_e32 v97, s46, v97
		v_accvgpr_read_b32 v98, a121
		v_add_u32_e32 v98, s46, v98
		v_mfma_f32_32x32x16_bf16 v[224:239], a[72:75], a[28:31], 0
		v_accvgpr_read_b32 v99, a122
		v_add_u32_e32 v99, s46, v99
		v_accvgpr_read_b32 v111, a125
		v_add_u32_e32 v111, s46, v111
		v_accvgpr_read_b32 v240, a126
		v_add_u32_e32 v240, s46, v240
		v_accvgpr_read_b32 v241, a129
		v_add_u32_e32 v241, s46, v241
		v_accvgpr_write_b32 a72, v241
		v_accvgpr_read_b32 v241, a130
		v_add_u32_e32 v241, s46, v241
		v_accvgpr_write_b32 a73, v241
		v_lshrrev_b32_e32 v241, 5, v0
		v_and_b32_e32 v241, 1, v241
		v_accvgpr_write_b32 a74, v241
		v_accvgpr_read_b32 v241, a74
		v_mov_b32_e32 v242, 4
		v_mul_lo_u32 v242, v242, v241
		v_xor_b32_e32 v241, 0x48, v242
		v_add_u32_e32 v241, s46, v241
		v_accvgpr_write_b32 a74, v241
		v_lshrrev_b32_e32 v241, 5, v0
		v_and_b32_e32 v241, 1, v241
		v_accvgpr_write_b32 a75, v241
		v_accvgpr_read_b32 v241, a75
		v_mov_b32_e32 v242, 4
		v_mul_lo_u32 v242, v242, v241
		v_xor_b32_e32 v241, 0x49, v242
		v_add_u32_e32 v241, s46, v241
		v_accvgpr_write_b32 a75, v241
		v_mfma_f32_32x32x16_bf16 v[112:127], a[48:51], a[16:19], v[112:127]
		v_lshrrev_b32_e32 v241, 5, v0
		v_and_b32_e32 v241, 1, v241
		v_accvgpr_write_b32 a209, v241
		v_accvgpr_read_b32 v241, a209
		v_mov_b32_e32 v242, 4
		v_mul_lo_u32 v242, v242, v241
		v_xor_b32_e32 v241, 0x50, v242
		v_add_u32_e32 v241, s46, v241
		v_accvgpr_write_b32 a209, v241
		v_lshrrev_b32_e32 v241, 5, v0
		v_and_b32_e32 v241, 1, v241
		v_accvgpr_write_b32 a210, v241
		v_accvgpr_read_b32 v241, a210
		v_mov_b32_e32 v242, 4
		v_mul_lo_u32 v242, v242, v241
		v_xor_b32_e32 v241, 0x51, v242
		v_add_u32_e32 v241, s46, v241
		v_accvgpr_write_b32 a210, v241
		v_lshrrev_b32_e32 v241, 5, v0
		v_and_b32_e32 v241, 1, v241
		v_accvgpr_write_b32 a211, v241
		v_accvgpr_read_b32 v241, a211
		v_mov_b32_e32 v242, 4
		v_mul_lo_u32 v242, v242, v241
		v_xor_b32_e32 v241, 0x58, v242
		v_add_u32_e32 v241, s46, v241
		v_accvgpr_write_b32 a211, v241
		v_lshrrev_b32_e32 v241, 5, v0
		v_and_b32_e32 v241, 1, v241
		v_accvgpr_write_b32 a212, v241
		v_accvgpr_read_b32 v241, a212
		v_mov_b32_e32 v242, 4
		v_mul_lo_u32 v242, v242, v241
		v_xor_b32_e32 v241, 0x59, v242
		v_add_u32_e32 v241, s46, v241
		v_accvgpr_write_b32 a212, v241
		v_lshrrev_b32_e32 v241, 5, v0
		v_and_b32_e32 v241, 1, v241
		v_accvgpr_write_b32 a213, v241
		v_accvgpr_read_b32 v241, a213
		v_mov_b32_e32 v242, 4
		v_mul_lo_u32 v242, v242, v241
		v_xor_b32_e32 v241, 0x60, v242
		v_add_u32_e32 v241, s46, v241
		v_accvgpr_write_b32 a213, v241
		v_lshrrev_b32_e32 v241, 5, v0
		v_and_b32_e32 v241, 1, v241
		v_accvgpr_write_b32 a214, v241
		v_accvgpr_read_b32 v241, a214
		v_mov_b32_e32 v242, 4
		v_mul_lo_u32 v242, v242, v241
		v_xor_b32_e32 v241, 0x61, v242
		v_add_u32_e32 v241, s46, v241
		v_accvgpr_write_b32 a214, v241
		v_lshrrev_b32_e32 v241, 5, v0
		v_and_b32_e32 v241, 1, v241
		v_accvgpr_write_b32 a215, v241
		v_accvgpr_read_b32 v241, a215
		v_mov_b32_e32 v242, 4
		v_mul_lo_u32 v242, v242, v241
		v_xor_b32_e32 v241, 0x68, v242
		v_add_u32_e32 v241, s46, v241
		v_accvgpr_write_b32 a215, v241
		v_mfma_f32_32x32x16_bf16 v[128:143], a[60:63], a[16:19], v[128:143]
		v_lshrrev_b32_e32 v241, 5, v0
		v_and_b32_e32 v241, 1, v241
		v_accvgpr_write_b32 a216, v241
		v_accvgpr_read_b32 v241, a216
		v_mov_b32_e32 v242, 4
		v_mul_lo_u32 v242, v242, v241
		v_xor_b32_e32 v241, 0x69, v242
		v_add_u32_e32 v241, s46, v241
		v_accvgpr_write_b32 a216, v241
		v_lshrrev_b32_e32 v241, 5, v0
		v_and_b32_e32 v241, 1, v241
		v_accvgpr_write_b32 a217, v241
		v_accvgpr_read_b32 v241, a217
		v_mov_b32_e32 v242, 4
		v_mul_lo_u32 v242, v242, v241
		v_xor_b32_e32 v241, 0x70, v242
		v_add_u32_e32 v241, s46, v241
		v_accvgpr_write_b32 a217, v241
		v_lshrrev_b32_e32 v241, 5, v0
		v_and_b32_e32 v241, 1, v241
		v_accvgpr_write_b32 a218, v241
		v_accvgpr_read_b32 v241, a218
		v_mov_b32_e32 v242, 4
		v_mul_lo_u32 v242, v242, v241
		v_xor_b32_e32 v241, 0x71, v242
		v_add_u32_e32 v241, s46, v241
		v_accvgpr_write_b32 a218, v241
		v_lshrrev_b32_e32 v241, 5, v0
		v_and_b32_e32 v241, 1, v241
		v_accvgpr_write_b32 a219, v241
		v_accvgpr_read_b32 v241, a219
		v_mov_b32_e32 v242, 4
		v_mul_lo_u32 v242, v242, v241
		v_xor_b32_e32 v241, 0x78, v242
		v_add_u32_e32 v241, s46, v241
		v_accvgpr_write_b32 a219, v241
		v_lshrrev_b32_e32 v241, 5, v0
		v_and_b32_e32 v241, 1, v241
		v_accvgpr_write_b32 a220, v241
		v_accvgpr_read_b32 v241, a220
		v_mov_b32_e32 v242, 4
		v_mul_lo_u32 v242, v242, v241
		v_xor_b32_e32 v241, 0x79, v242
		v_add_u32_e32 v241, s46, v241
		v_accvgpr_write_b32 a220, v241
		v_mfma_f32_32x32x16_bf16 v[144:159], a[76:79], a[16:19], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[88:91], a[16:19], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[88:91], a[36:39], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[48:51], a[36:39], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[60:63], a[36:39], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[76:79], a[36:39], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[52:55], a[20:23], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[64:67], a[20:23], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[80:83], a[20:23], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[132:135], a[20:23], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[132:135], a[40:43], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[52:55], a[40:43], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[64:67], a[40:43], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[80:83], a[40:43], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[56:59], a[24:27], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[68:71], a[24:27], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[84:87], a[24:27], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[136:139], a[24:27], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[136:139], a[44:47], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[56:59], a[44:47], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[68:71], a[44:47], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[84:87], a[44:47], v[224:239]
		s_cmp_lt_i32 s22, s39
		v_mov_b32_e32 v241, 0xff800000
		s_nop 2
		v_cndmask_b32_e32 v243, v241, v115, vcc
		v_cmp_ge_i32_e64 vcc, v9, v24
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v9, v25
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v9, v20
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v9, v21
		v_cndmask_b32_e64 v244, v241, v112, s[52:53]
		v_cndmask_b32_e64 v245, v241, v113, s[54:55]
		v_cndmask_b32_e32 v113, v241, v119, vcc
		v_cmp_ge_i32_e64 vcc, v9, v26
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v9, v27
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v9, v23
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v9, v100
		v_cndmask_b32_e64 v242, v241, v114, s[58:59]
		v_cndmask_b32_e64 v114, v241, v116, s[46:47]
		v_cndmask_b32_e32 v247, v241, v123, vcc
		v_cmp_ge_i32_e64 vcc, v9, v28
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v9, v29
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v9, v101
		s_mov_b64 s[66:67], vcc
		v_cmp_ge_i32_e64 vcc, v9, v102
		v_cndmask_b32_e64 v115, v241, v117, s[60:61]
		v_cndmask_b32_e64 v112, v241, v118, s[62:63]
		v_cndmask_b32_e32 v117, v241, v127, vcc
		v_cmp_ge_i32_e64 vcc, v9, v30
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v9, v31
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v9, v103
		s_mov_b64 s[68:69], vcc
		v_cmp_ge_i32_e64 vcc, v9, v104
		v_cndmask_b32_e64 v118, v241, v120, s[52:53]
		v_cndmask_b32_e64 v119, v241, v121, s[54:55]
		v_cndmask_b32_e32 v121, v241, v131, vcc
		v_cmp_ge_i32_e64 vcc, v9, v96
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v9, v97
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v9, v105
		s_mov_b64 s[70:71], vcc
		v_cmp_ge_i32_e64 vcc, v9, v106
		v_cndmask_b32_e64 v246, v241, v122, s[64:65]
		v_cndmask_b32_e64 v122, v241, v124, s[46:47]
		v_cndmask_b32_e32 v249, v241, v135, vcc
		v_cmp_ge_i32_e64 vcc, v9, v98
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v9, v99
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v9, v107
		s_mov_b64 s[72:73], vcc
		v_cmp_ge_i32_e64 vcc, v9, v108
		v_cndmask_b32_e64 v123, v241, v125, s[58:59]
		v_cndmask_b32_e64 v116, v241, v126, s[66:67]
		v_cndmask_b32_e32 v125, v241, v139, vcc
		v_cmp_ge_i32_e64 vcc, v9, v111
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v9, v240
		s_mov_b64 s[66:67], vcc
		v_cmp_ge_i32_e64 vcc, v9, v109
		s_mov_b64 s[74:75], vcc
		v_cmp_ge_i32_e64 vcc, v9, v110
		v_cndmask_b32_e64 v126, v241, v128, s[60:61]
		v_cndmask_b32_e64 v127, v241, v129, s[62:63]
		v_cndmask_b32_e32 v129, v241, v143, vcc
		v_accvgpr_read_b32 v120, a72
		v_cmp_ge_i32_e64 vcc, v9, v120
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v120, a73
		v_cmp_ge_i32_e64 vcc, v9, v120
		s_mov_b64 s[62:63], vcc
		v_accvgpr_read_b32 v120, a5
		v_cmp_ge_i32_e64 vcc, v9, v120
		s_mov_b64 s[76:77], vcc
		v_accvgpr_read_b32 v120, a9
		v_cmp_ge_i32_e64 vcc, v9, v120
		v_cndmask_b32_e64 v120, v241, v130, s[68:69]
		v_cndmask_b32_e64 v130, v241, v132, s[52:53]
		v_cndmask_b32_e32 v251, v241, v147, vcc
		v_accvgpr_read_b32 v124, a74
		v_cmp_ge_i32_e64 vcc, v9, v124
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v124, a75
		v_cmp_ge_i32_e64 vcc, v9, v124
		s_mov_b64 s[68:69], vcc
		v_accvgpr_read_b32 v124, a11
		v_cmp_ge_i32_e64 vcc, v9, v124
		s_mov_b64 s[78:79], vcc
		v_accvgpr_read_b32 v124, a32
		v_cmp_ge_i32_e64 vcc, v9, v124
		v_cndmask_b32_e64 v131, v241, v133, s[54:55]
		v_cndmask_b32_e64 v248, v241, v134, s[70:71]
		v_cndmask_b32_e32 v133, v241, v151, vcc
		v_accvgpr_read_b32 v124, a209
		v_cmp_ge_i32_e64 vcc, v9, v124
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v124, a210
		v_cmp_ge_i32_e64 vcc, v9, v124
		s_mov_b64 s[70:71], vcc
		v_accvgpr_read_b32 v124, a33
		v_cmp_ge_i32_e64 vcc, v9, v124
		s_mov_b64 s[80:81], vcc
		v_accvgpr_read_b32 v124, a35
		v_cmp_ge_i32_e64 vcc, v9, v124
		v_cndmask_b32_e64 v134, v241, v136, s[46:47]
		v_cndmask_b32_e64 v135, v241, v137, s[64:65]
		v_cndmask_b32_e32 v137, v241, v155, vcc
		v_accvgpr_read_b32 v124, a211
		v_cmp_ge_i32_e64 vcc, v9, v124
		s_mov_b64 s[46:47], vcc
		v_accvgpr_read_b32 v124, a212
		v_cmp_ge_i32_e64 vcc, v9, v124
		s_mov_b64 s[64:65], vcc
		v_accvgpr_read_b32 v124, a92
		v_cmp_ge_i32_e64 vcc, v9, v124
		s_mov_b64 s[82:83], vcc
		v_cndmask_b32_e64 v253, v241, v157, s[64:65]
		v_cndmask_b32_e64 v254, v241, v158, s[82:83]
		v_accvgpr_read_b32 v124, a93
		v_cmp_ge_i32_e64 vcc, v9, v124
		v_cndmask_b32_e64 v124, v241, v138, s[72:73]
		v_cndmask_b32_e64 v138, v241, v140, s[58:59]
		v_cndmask_b32_e32 v255, v241, v159, vcc
		v_accvgpr_read_b32 v128, a213
		v_cmp_ge_i32_e64 vcc, v9, v128
		s_mov_b64 s[58:59], vcc
		v_accvgpr_read_b32 v128, a214
		v_cmp_ge_i32_e64 vcc, v9, v128
		s_mov_b64 s[64:65], vcc
		v_accvgpr_read_b32 v128, a95
		v_cmp_ge_i32_e64 vcc, v9, v128
		s_mov_b64 s[72:73], vcc
		v_cndmask_b32_e64 v158, v241, v160, s[58:59]
		v_cndmask_b32_e64 v159, v241, v161, s[64:65]
		v_cndmask_b32_e64 v160, v241, v162, s[72:73]
		v_accvgpr_read_b32 v128, a96
		v_cmp_ge_i32_e64 vcc, v9, v128
		v_cndmask_b32_e64 v139, v241, v141, s[66:67]
		v_cndmask_b32_e64 v128, v241, v142, s[74:75]
		v_cndmask_b32_e32 v161, v241, v163, vcc
		v_accvgpr_read_b32 v132, a215
		v_cmp_ge_i32_e64 vcc, v9, v132
		s_mov_b64 s[58:59], vcc
		v_accvgpr_read_b32 v132, a216
		v_cmp_ge_i32_e64 vcc, v9, v132
		s_mov_b64 s[64:65], vcc
		v_accvgpr_read_b32 v132, a97
		v_cmp_ge_i32_e64 vcc, v9, v132
		s_mov_b64 s[66:67], vcc
		v_cndmask_b32_e64 v140, v241, v164, s[58:59]
		v_cndmask_b32_e64 v141, v241, v165, s[64:65]
		v_cndmask_b32_e64 v142, v241, v166, s[66:67]
		v_accvgpr_read_b32 v132, a204
		v_cmp_ge_i32_e64 vcc, v9, v132
		v_cndmask_b32_e64 v162, v241, v144, s[60:61]
		v_cndmask_b32_e64 v163, v241, v145, s[62:63]
		v_cndmask_b32_e32 v143, v241, v167, vcc
		v_accvgpr_read_b32 v132, a217
		v_cmp_ge_i32_e64 vcc, v9, v132
		s_mov_b64 s[58:59], vcc
		v_accvgpr_read_b32 v132, a218
		v_cmp_ge_i32_e64 vcc, v9, v132
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v132, a205
		v_cmp_ge_i32_e64 vcc, v9, v132
		s_mov_b64 s[62:63], vcc
		v_cndmask_b32_e64 v144, v241, v168, s[58:59]
		v_cndmask_b32_e64 v145, v241, v169, s[60:61]
		v_cndmask_b32_e64 v164, v241, v170, s[62:63]
		v_accvgpr_read_b32 v132, a206
		v_cmp_ge_i32_e64 vcc, v9, v132
		v_cndmask_b32_e64 v250, v241, v146, s[76:77]
		v_cndmask_b32_e64 v146, v241, v148, s[52:53]
		v_cndmask_b32_e32 v165, v241, v171, vcc
		v_accvgpr_read_b32 v132, a219
		v_cmp_ge_i32_e64 vcc, v9, v132
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v132, a220
		v_cmp_ge_i32_e64 vcc, v9, v132
		s_mov_b64 s[58:59], vcc
		v_accvgpr_read_b32 v132, a207
		v_cmp_ge_i32_e64 vcc, v9, v132
		s_mov_b64 s[60:61], vcc
		v_cndmask_b32_e64 v166, v241, v172, s[52:53]
		v_cndmask_b32_e64 v167, v241, v173, s[58:59]
		v_cndmask_b32_e64 v168, v241, v174, s[60:61]
		v_accvgpr_read_b32 v132, a208
		v_cmp_ge_i32_e64 vcc, v9, v132
		v_cndmask_b32_e64 v147, v241, v149, s[68:69]
		v_cndmask_b32_e64 v132, v241, v150, s[78:79]
		v_cndmask_b32_e32 v169, v241, v175, vcc
		v_cmp_ge_i32_e64 vcc, v6, v16
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v6, v17
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v6, v18
		s_mov_b64 s[60:61], vcc
		v_cndmask_b32_e64 v16, v241, v192, s[52:53]
		v_cndmask_b32_e64 v17, v241, v193, s[58:59]
		v_cndmask_b32_e64 v148, v241, v194, s[60:61]
		v_cmp_ge_i32_e64 vcc, v6, v19
		v_cndmask_b32_e64 v18, v241, v152, s[54:55]
		v_cndmask_b32_e64 v19, v241, v153, s[70:71]
		v_cndmask_b32_e32 v149, v241, v195, vcc
		v_cmp_ge_i32_e64 vcc, v6, v24
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v6, v25
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v6, v20
		s_mov_b64 s[58:59], vcc
		v_cndmask_b32_e64 v24, v241, v196, s[52:53]
		v_cndmask_b32_e64 v25, v241, v197, s[54:55]
		v_cndmask_b32_e64 v150, v241, v198, s[58:59]
		v_cmp_ge_i32_e64 vcc, v6, v21
		v_cndmask_b32_e64 v136, v241, v154, s[80:81]
		v_cndmask_b32_e64 v252, v241, v156, s[46:47]
		v_cndmask_b32_e32 v151, v241, v199, vcc
		v_cmp_ge_i32_e64 vcc, v6, v26
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v6, v27
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v6, v23
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v20, v241, v200, s[46:47]
		v_cndmask_b32_e64 v21, v241, v201, s[52:53]
		v_cndmask_b32_e64 v26, v241, v202, s[54:55]
		v_cmp_ge_i32_e64 vcc, v6, v100
		v_max_f32_e32 v23, v244, v245
		v_max_f32_e32 v100, v242, v243
		v_cndmask_b32_e32 v27, v241, v203, vcc
		v_cmp_ge_i32_e64 vcc, v6, v28
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v6, v29
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v6, v101
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v28, v241, v204, s[46:47]
		v_cndmask_b32_e64 v29, v241, v205, s[52:53]
		v_cndmask_b32_e64 v152, v241, v206, s[54:55]
		v_cmp_ge_i32_e64 vcc, v6, v102
		v_max_f32_e32 v101, v114, v115
		v_max_f32_e32 v102, v112, v113
		v_cndmask_b32_e32 v153, v241, v207, vcc
		v_cmp_ge_i32_e64 vcc, v6, v30
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v6, v31
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v6, v103
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v30, v241, v208, s[46:47]
		v_cndmask_b32_e64 v31, v241, v209, s[52:53]
		v_cndmask_b32_e64 v154, v241, v210, s[54:55]
		v_cmp_ge_i32_e64 vcc, v6, v104
		v_max_f32_e32 v103, v118, v119
		v_max_f32_e32 v104, v246, v247
		v_cndmask_b32_e32 v155, v241, v211, vcc
		v_cmp_ge_i32_e64 vcc, v6, v96
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v6, v97
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v6, v105
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v96, v241, v212, s[46:47]
		v_cndmask_b32_e64 v97, v241, v213, s[52:53]
		v_cndmask_b32_e64 v156, v241, v214, s[54:55]
		v_cmp_ge_i32_e64 vcc, v6, v106
		v_max_f32_e32 v105, v122, v123
		v_max_f32_e32 v106, v116, v117
		v_cndmask_b32_e32 v157, v241, v215, vcc
		v_cmp_ge_i32_e64 vcc, v6, v98
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v6, v99
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v6, v107
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v98, v241, v216, s[46:47]
		v_cndmask_b32_e64 v99, v241, v217, s[52:53]
		v_cndmask_b32_e64 v170, v241, v218, s[54:55]
		v_cmp_ge_i32_e64 vcc, v6, v108
		v_max_f32_e32 v107, v126, v127
		v_max_f32_e32 v108, v120, v121
		v_cndmask_b32_e32 v171, v241, v219, vcc
		v_cmp_ge_i32_e64 vcc, v6, v111
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v6, v240
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v6, v109
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v172, v241, v220, s[46:47]
		v_cndmask_b32_e64 v173, v241, v221, s[52:53]
		v_cndmask_b32_e64 v174, v241, v222, s[54:55]
		v_cmp_ge_i32_e64 vcc, v6, v110
		v_max_f32_e32 v109, v130, v131
		v_max_f32_e32 v110, v248, v249
		v_cndmask_b32_e32 v175, v241, v223, vcc
		v_accvgpr_read_b32 v111, a72
		v_cmp_ge_i32_e64 vcc, v6, v111
		s_mov_b64 s[46:47], vcc
		v_accvgpr_read_b32 v111, a73
		v_cmp_ge_i32_e64 vcc, v6, v111
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v111, a5
		v_cmp_ge_i32_e64 vcc, v6, v111
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v192, v241, v224, s[46:47]
		v_cndmask_b32_e64 v193, v241, v225, s[52:53]
		v_cndmask_b32_e64 v194, v241, v226, s[54:55]
		v_accvgpr_read_b32 v111, a9
		v_cmp_ge_i32_e64 vcc, v6, v111
		v_max_f32_e32 v111, v134, v135
		v_max_f32_e32 v196, v124, v125
		v_cndmask_b32_e32 v195, v241, v227, vcc
		v_accvgpr_read_b32 v197, a74
		v_cmp_ge_i32_e64 vcc, v6, v197
		s_mov_b64 s[46:47], vcc
		v_accvgpr_read_b32 v197, a75
		v_cmp_ge_i32_e64 vcc, v6, v197
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v197, a11
		v_cmp_ge_i32_e64 vcc, v6, v197
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v198, v241, v228, s[46:47]
		v_cndmask_b32_e64 v199, v241, v229, s[52:53]
		v_cndmask_b32_e64 v200, v241, v230, s[54:55]
		v_accvgpr_read_b32 v197, a32
		v_cmp_ge_i32_e64 vcc, v6, v197
		v_max_f32_e32 v197, v138, v139
		v_max_f32_e32 v202, v128, v129
		v_cndmask_b32_e32 v201, v241, v231, vcc
		v_accvgpr_read_b32 v203, a209
		v_cmp_ge_i32_e64 vcc, v6, v203
		s_mov_b64 s[46:47], vcc
		v_accvgpr_read_b32 v203, a210
		v_cmp_ge_i32_e64 vcc, v6, v203
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v203, a33
		v_cmp_ge_i32_e64 vcc, v6, v203
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v204, v241, v232, s[46:47]
		v_cndmask_b32_e64 v205, v241, v233, s[52:53]
		v_cndmask_b32_e64 v206, v241, v234, s[54:55]
		v_accvgpr_read_b32 v203, a35
		v_cmp_ge_i32_e64 vcc, v6, v203
		v_max_f32_e32 v203, v162, v163
		v_max_f32_e32 v208, v250, v251
		v_cndmask_b32_e32 v207, v241, v235, vcc
		v_accvgpr_read_b32 v209, a211
		v_cmp_ge_i32_e64 vcc, v6, v209
		s_mov_b64 s[46:47], vcc
		v_accvgpr_read_b32 v209, a212
		v_cmp_ge_i32_e64 vcc, v6, v209
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v209, a92
		v_cmp_ge_i32_e64 vcc, v6, v209
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v210, v241, v236, s[46:47]
		v_cndmask_b32_e64 v211, v241, v237, s[52:53]
		v_cndmask_b32_e64 v212, v241, v238, s[54:55]
		v_accvgpr_read_b32 v209, a93
		v_cmp_ge_i32_e64 vcc, v6, v209
		v_max_f32_e32 v209, v146, v147
		v_max_f32_e32 v214, v132, v133
		v_cndmask_b32_e32 v213, v241, v239, vcc
		v_accvgpr_read_b32 v215, a213
		v_cmp_ge_i32_e64 vcc, v6, v215
		s_mov_b64 s[46:47], vcc
		v_accvgpr_read_b32 v215, a214
		v_cmp_ge_i32_e64 vcc, v6, v215
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v215, a95
		v_cmp_ge_i32_e64 vcc, v6, v215
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v216, v241, v176, s[46:47]
		v_cndmask_b32_e64 v217, v241, v177, s[52:53]
		v_cndmask_b32_e64 v176, v241, v178, s[54:55]
		v_accvgpr_read_b32 v177, a96
		v_cmp_ge_i32_e64 vcc, v6, v177
		v_max_f32_e32 v178, v18, v19
		v_max_f32_e32 v215, v136, v137
		v_cndmask_b32_e32 v177, v241, v179, vcc
		v_accvgpr_read_b32 v179, a215
		v_cmp_ge_i32_e64 vcc, v6, v179
		s_mov_b64 s[46:47], vcc
		v_accvgpr_read_b32 v179, a216
		v_cmp_ge_i32_e64 vcc, v6, v179
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v179, a97
		v_cmp_ge_i32_e64 vcc, v6, v179
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v218, v241, v180, s[46:47]
		v_cndmask_b32_e64 v219, v241, v181, s[52:53]
		v_cndmask_b32_e64 v180, v241, v182, s[54:55]
		v_accvgpr_read_b32 v179, a204
		v_cmp_ge_i32_e64 vcc, v6, v179
		v_max_f32_e32 v179, v252, v253
		v_max_f32_e32 v182, v254, v255
		v_cndmask_b32_e32 v181, v241, v183, vcc
		v_accvgpr_read_b32 v183, a217
		v_cmp_ge_i32_e64 vcc, v6, v183
		s_mov_b64 s[46:47], vcc
		v_accvgpr_read_b32 v183, a218
		v_cmp_ge_i32_e64 vcc, v6, v183
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v183, a205
		v_cmp_ge_i32_e64 vcc, v6, v183
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v220, v241, v184, s[46:47]
		v_cndmask_b32_e64 v221, v241, v185, s[52:53]
		v_cndmask_b32_e64 v184, v241, v186, s[54:55]
		v_accvgpr_read_b32 v183, a206
		v_cmp_ge_i32_e64 vcc, v6, v183
		v_max_f32_e32 v183, v158, v159
		v_max_f32_e32 v186, v160, v161
		v_cndmask_b32_e32 v185, v241, v187, vcc
		v_accvgpr_read_b32 v187, a219
		v_cmp_ge_i32_e64 vcc, v6, v187
		s_mov_b64 s[46:47], vcc
		v_accvgpr_read_b32 v187, a220
		v_cmp_ge_i32_e64 vcc, v6, v187
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v187, a207
		v_cmp_ge_i32_e64 vcc, v6, v187
		s_mov_b64 s[54:55], vcc
		v_cndmask_b32_e64 v222, v241, v188, s[46:47]
		v_cndmask_b32_e64 v223, v241, v189, s[52:53]
		v_cndmask_b32_e64 v188, v241, v190, s[54:55]
		v_accvgpr_read_b32 v187, a208
		v_cmp_ge_i32_e64 vcc, v6, v187
		v_max_f32_e32 v187, v140, v141
		v_max_f32_e32 v190, v142, v143
		v_cndmask_b32_e32 v189, v241, v191, vcc
		v_max_f32_e32 v191, v144, v145
		v_max_f32_e32 v224, v164, v165
		v_max_f32_e32 v225, v166, v167
		v_max_f32_e32 v226, v168, v169
		v_max_f32_e32 v23, v23, v100
		v_max_f32_e32 v100, v101, v102
		v_max_f32_e32 v101, v103, v104
		v_max_f32_e32 v102, v105, v106
		v_max_f32_e32 v103, v107, v108
		v_max_f32_e32 v104, v109, v110
		v_max_f32_e32 v105, v111, v196
		v_max_f32_e32 v106, v197, v202
		v_max_f32_e32 v107, v203, v208
		v_max_f32_e32 v108, v209, v214
		v_max_f32_e32 v109, v178, v215
		v_max_f32_e32 v110, v179, v182
		v_max_f32_e32 v111, v183, v186
		v_max_f32_e32 v178, v187, v190
		v_max_f32_e32 v179, v191, v224
		v_max_f32_e32 v182, v225, v226
		v_max_f32_e32 v23, v23, v100
		v_max_f32_e32 v100, v101, v102
		v_max_f32_e32 v101, v103, v104
		v_max_f32_e32 v102, v105, v106
		v_max_f32_e32 v103, v107, v108
		v_max_f32_e32 v104, v109, v110
		v_max_f32_e32 v105, v111, v178
		v_max_f32_e32 v106, v179, v182
		v_max_f32_e32 v23, v23, v100
		v_max_f32_e32 v100, v101, v102
		v_max_f32_e32 v101, v103, v104
		v_max_f32_e32 v102, v105, v106
		v_max_f32_e32 v23, v23, v100
		v_max_f32_e32 v100, v101, v102
		v_max_f32_e32 v23, v23, v100
		v_and_b32_e32 v100, 1, v15
		v_lshrrev_b32_e32 v101, 4, v15
		v_and_b32_e32 v101, 1, v101
		v_lshlrev_b32_e32 v101, 4, v101
		v_lshrrev_b32_e32 v102, 3, v15
		v_and_b32_e32 v102, 1, v102
		v_lshlrev_b32_e32 v102, 3, v102
		v_add3_u32 v100, v100, v101, v102
		v_lshrrev_b32_e32 v101, 2, v15
		v_and_b32_e32 v101, 1, v101
		v_lshlrev_b32_e32 v101, 2, v101
		v_lshrrev_b32_e32 v102, 1, v15
		v_and_b32_e32 v102, 1, v102
		v_lshlrev_b32_e32 v102, 1, v102
		v_add3_u32 v100, v100, v101, v102
		v_lshlrev_b32_e32 v100, 2, v100
		ds_bpermute_b32 v101, v100, v23
		v_lshrrev_b32_e32 v102, 4, v15
		v_and_b32_e32 v102, 1, v102
		v_lshlrev_b32_e32 v102, 4, v102
		v_lshrrev_b32_e32 v103, 3, v15
		v_and_b32_e32 v103, 1, v103
		v_lshlrev_b32_e32 v103, 3, v103
		v_lshrrev_b32_e32 v104, 2, v15
		v_and_b32_e32 v104, 1, v104
		v_lshlrev_b32_e32 v104, 2, v104
		v_and_b32_e32 v105, 1, v15
		v_add_u32_e32 v105, 32, v105
		v_lshrrev_b32_e32 v106, 1, v15
		v_and_b32_e32 v106, 1, v106
		v_lshlrev_b32_e32 v106, 1, v106
		v_bitop3_b32 v104, v104, v105, v106 bitop3:0x96
		v_bitop3_b32 v102, v102, v103, v104 bitop3:0x96
		v_lshlrev_b32_e32 v102, 2, v102
		ds_bpermute_b32 v103, v102, v23
		v_max_f32_e32 v23, v16, v17
		v_max_f32_e32 v104, v148, v149
		v_max_f32_e32 v105, v24, v25
		v_max_f32_e32 v106, v150, v151
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v108, v101, v103
		v_max_f32_e32 v101, v20, v21
		v_max_f32_e32 v103, v26, v27
		v_max_f32_e32 v107, v28, v29
		v_max_f32_e32 v109, v152, v153
		v_max_f32_e32 v110, v30, v31
		v_max_f32_e32 v111, v154, v155
		v_max_f32_e32 v178, v96, v97
		v_max_f32_e32 v179, v156, v157
		v_max_f32_e32 v182, v98, v99
		v_max_f32_e32 v183, v170, v171
		v_max_f32_e32 v186, v172, v173
		v_max_f32_e32 v187, v174, v175
		v_max_f32_e32 v190, v192, v193
		v_max_f32_e32 v191, v194, v195
		v_max_f32_e32 v196, v198, v199
		v_max_f32_e32 v197, v200, v201
		v_max_f32_e32 v202, v204, v205
		v_max_f32_e32 v203, v206, v207
		v_max_f32_e32 v208, v210, v211
		v_max_f32_e32 v209, v212, v213
		v_max_f32_e32 v214, v216, v217
		v_max_f32_e32 v215, v176, v177
		v_max_f32_e32 v224, v218, v219
		v_max_f32_e32 v225, v180, v181
		v_max_f32_e32 v226, v220, v221
		v_max_f32_e32 v227, v184, v185
		v_max_f32_e32 v228, v222, v223
		v_max_f32_e32 v229, v188, v189
		v_max_f32_e32 v23, v23, v104
		v_max_f32_e32 v104, v105, v106
		v_max_f32_e32 v101, v101, v103
		v_max_f32_e32 v103, v107, v109
		v_max_f32_e32 v105, v110, v111
		v_max_f32_e32 v106, v178, v179
		v_max_f32_e32 v107, v182, v183
		v_max_f32_e32 v109, v186, v187
		v_max_f32_e32 v110, v190, v191
		v_max_f32_e32 v111, v196, v197
		v_max_f32_e32 v178, v202, v203
		v_max_f32_e32 v179, v208, v209
		v_max_f32_e32 v182, v214, v215
		v_max_f32_e32 v183, v224, v225
		v_max_f32_e32 v186, v226, v227
		v_max_f32_e32 v187, v228, v229
		v_max_f32_e32 v23, v23, v104
		v_max_f32_e32 v101, v101, v103
		v_max_f32_e32 v103, v105, v106
		v_max_f32_e32 v104, v107, v109
		v_max_f32_e32 v105, v110, v111
		v_max_f32_e32 v106, v178, v179
		v_max_f32_e32 v107, v182, v183
		v_max_f32_e32 v109, v186, v187
		v_max_f32_e32 v23, v23, v101
		v_max_f32_e32 v101, v103, v104
		v_max_f32_e32 v103, v105, v106
		v_max_f32_e32 v104, v107, v109
		v_max_f32_e32 v23, v23, v101
		v_max_f32_e32 v101, v103, v104
		v_max_f32_e32 v23, v23, v101
		ds_bpermute_b32 v101, v100, v23
		ds_bpermute_b32 v103, v102, v23
		v_mov_b32_e32 v104, 0x3e38aa3b
		v_mov_b32_e32 v105, 0x3e38aa3b
		v_pk_mul_f32 v[106:107], v[244:245], v[104:105]
		v_pk_mul_f32 v[110:111], v[242:243], v[104:105]
		v_pk_mul_f32 v[178:179], v[114:115], v[104:105]
		v_pk_mul_f32 v[114:115], v[112:113], v[104:105]
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v109, v101, v103
		v_pk_mul_f32 v[112:113], v[108:109], v[104:105]
		v_max_f32_e32 v23, v10, v112
		v_max_f32_e32 v101, v11, v113
		v_pk_mul_f32 v[108:109], v[118:119], v[104:105]
		v_pk_mul_f32 v[112:113], v[246:247], v[104:105]
		v_pk_mul_f32 v[118:119], v[122:123], v[104:105]
		v_pk_mul_f32 v[122:123], v[116:117], v[104:105]
		v_pk_mul_f32 v[116:117], v[126:127], v[104:105]
		v_pk_mul_f32 v[126:127], v[120:121], v[104:105]
		v_pk_mul_f32 v[120:121], v[130:131], v[104:105]
		v_pk_mul_f32 v[130:131], v[248:249], v[104:105]
		v_pk_mul_f32 v[182:183], v[134:135], v[104:105]
		v_pk_mul_f32 v[134:135], v[124:125], v[104:105]
		v_pk_mul_f32 v[124:125], v[138:139], v[104:105]
		v_pk_mul_f32 v[138:139], v[128:129], v[104:105]
		v_pk_mul_f32 v[128:129], v[162:163], v[104:105]
		v_pk_mul_f32 v[162:163], v[250:251], v[104:105]
		v_pk_mul_f32 v[186:187], v[146:147], v[104:105]
		v_pk_mul_f32 v[146:147], v[132:133], v[104:105]
		v_pk_mul_f32 v[132:133], v[18:19], v[104:105]
		v_pk_mul_f32 v[18:19], v[136:137], v[104:105]
		v_pk_mul_f32 v[136:137], v[252:253], v[104:105]
		v_pk_mul_f32 v[190:191], v[254:255], v[104:105]
		v_pk_mul_f32 v[196:197], v[158:159], v[104:105]
		v_pk_mul_f32 v[158:159], v[160:161], v[104:105]
		v_pk_mul_f32 v[160:161], v[140:141], v[104:105]
		v_pk_mul_f32 v[140:141], v[142:143], v[104:105]
		v_pk_mul_f32 v[142:143], v[144:145], v[104:105]
		v_pk_mul_f32 v[144:145], v[164:165], v[104:105]
		v_pk_mul_f32 v[164:165], v[166:167], v[104:105]
		v_pk_mul_f32 v[166:167], v[168:169], v[104:105]
		v_pk_mul_f32 v[168:169], v[16:17], v[104:105]
		v_pk_mul_f32 v[16:17], v[148:149], v[104:105]
		v_pk_mul_f32 v[148:149], v[24:25], v[104:105]
		v_pk_mul_f32 v[24:25], v[150:151], v[104:105]
		v_pk_mul_f32 v[150:151], v[20:21], v[104:105]
		v_pk_mul_f32 v[20:21], v[26:27], v[104:105]
		v_pk_mul_f32 v[26:27], v[28:29], v[104:105]
		v_pk_mul_f32 v[28:29], v[152:153], v[104:105]
		v_pk_mul_f32 v[152:153], v[30:31], v[104:105]
		v_pk_mul_f32 v[30:31], v[154:155], v[104:105]
		v_pk_mul_f32 v[154:155], v[96:97], v[104:105]
		v_pk_mul_f32 v[96:97], v[156:157], v[104:105]
		v_pk_mul_f32 v[156:157], v[98:99], v[104:105]
		v_pk_mul_f32 v[98:99], v[170:171], v[104:105]
		v_pk_mul_f32 v[170:171], v[172:173], v[104:105]
		v_pk_mul_f32 v[172:173], v[174:175], v[104:105]
		v_pk_mul_f32 v[174:175], v[192:193], v[104:105]
		v_pk_mul_f32 v[192:193], v[194:195], v[104:105]
		v_pk_mul_f32 v[194:195], v[198:199], v[104:105]
		v_pk_mul_f32 v[198:199], v[200:201], v[104:105]
		v_pk_mul_f32 v[200:201], v[204:205], v[104:105]
		v_pk_mul_f32 v[202:203], v[206:207], v[104:105]
		v_pk_mul_f32 v[204:205], v[210:211], v[104:105]
		v_pk_mul_f32 v[206:207], v[212:213], v[104:105]
		v_pk_mul_f32 v[208:209], v[216:217], v[104:105]
		v_pk_mul_f32 v[210:211], v[176:177], v[104:105]
		v_pk_mul_f32 v[176:177], v[218:219], v[104:105]
		v_pk_mul_f32 v[212:213], v[180:181], v[104:105]
		v_pk_mul_f32 v[180:181], v[220:221], v[104:105]
		v_pk_mul_f32 v[214:215], v[184:185], v[104:105]
		v_pk_mul_f32 v[184:185], v[222:223], v[104:105]
		v_pk_mul_f32 v[216:217], v[188:189], v[104:105]
		v_sub_f32_e32 v103, v106, v23
		v_sub_f32_e32 v104, v107, v23
		v_sub_f32_e32 v105, v110, v23
		v_sub_f32_e32 v106, v111, v23
		v_sub_f32_e32 v107, v178, v23
		v_sub_f32_e32 v110, v179, v23
		v_sub_f32_e32 v111, v114, v23
		v_sub_f32_e32 v114, v115, v23
		v_sub_f32_e32 v108, v108, v23
		v_sub_f32_e32 v109, v109, v23
		v_sub_f32_e32 v112, v112, v23
		v_sub_f32_e32 v113, v113, v23
		v_sub_f32_e32 v115, v118, v23
		v_sub_f32_e32 v118, v119, v23
		v_sub_f32_e32 v119, v122, v23
		v_sub_f32_e32 v122, v123, v23
		v_sub_f32_e32 v116, v116, v23
		v_sub_f32_e32 v117, v117, v23
		v_sub_f32_e32 v123, v126, v23
		v_sub_f32_e32 v126, v127, v23
		v_sub_f32_e32 v120, v120, v23
		v_sub_f32_e32 v121, v121, v23
		v_sub_f32_e32 v127, v130, v23
		v_sub_f32_e32 v130, v131, v23
		v_sub_f32_e32 v131, v182, v23
		v_sub_f32_e32 v178, v183, v23
		v_sub_f32_e32 v134, v134, v23
		v_sub_f32_e32 v135, v135, v23
		v_sub_f32_e32 v124, v124, v23
		v_sub_f32_e32 v125, v125, v23
		v_sub_f32_e32 v138, v138, v23
		v_sub_f32_e32 v139, v139, v23
		v_sub_f32_e32 v128, v128, v23
		v_sub_f32_e32 v129, v129, v23
		v_sub_f32_e32 v162, v162, v23
		v_sub_f32_e32 v163, v163, v23
		v_sub_f32_e32 v179, v186, v23
		v_sub_f32_e32 v182, v187, v23
		v_sub_f32_e32 v146, v146, v23
		v_sub_f32_e32 v147, v147, v23
		v_sub_f32_e32 v132, v132, v23
		v_sub_f32_e32 v133, v133, v23
		v_sub_f32_e32 v18, v18, v23
		v_sub_f32_e32 v19, v19, v23
		v_sub_f32_e32 v136, v136, v23
		v_sub_f32_e32 v137, v137, v23
		v_sub_f32_e32 v183, v190, v23
		v_sub_f32_e32 v186, v191, v23
		v_sub_f32_e32 v187, v196, v23
		v_sub_f32_e32 v188, v197, v23
		v_sub_f32_e32 v158, v158, v23
		v_sub_f32_e32 v159, v159, v23
		v_sub_f32_e32 v160, v160, v23
		v_sub_f32_e32 v161, v161, v23
		v_sub_f32_e32 v140, v140, v23
		v_sub_f32_e32 v141, v141, v23
		v_sub_f32_e32 v142, v142, v23
		v_sub_f32_e32 v143, v143, v23
		v_sub_f32_e32 v144, v144, v23
		v_sub_f32_e32 v145, v145, v23
		v_sub_f32_e32 v164, v164, v23
		v_sub_f32_e32 v165, v165, v23
		v_sub_f32_e32 v166, v166, v23
		v_sub_f32_e32 v167, v167, v23
		v_sub_f32_e32 v168, v168, v101
		v_sub_f32_e32 v169, v169, v101
		v_sub_f32_e32 v16, v16, v101
		v_sub_f32_e32 v17, v17, v101
		v_sub_f32_e32 v148, v148, v101
		v_sub_f32_e32 v149, v149, v101
		v_sub_f32_e32 v24, v24, v101
		v_sub_f32_e32 v25, v25, v101
		v_sub_f32_e32 v150, v150, v101
		v_sub_f32_e32 v151, v151, v101
		v_sub_f32_e32 v20, v20, v101
		v_sub_f32_e32 v21, v21, v101
		v_sub_f32_e32 v26, v26, v101
		v_sub_f32_e32 v27, v27, v101
		v_sub_f32_e32 v28, v28, v101
		v_sub_f32_e32 v29, v29, v101
		v_sub_f32_e32 v152, v152, v101
		v_sub_f32_e32 v153, v153, v101
		v_sub_f32_e32 v30, v30, v101
		v_sub_f32_e32 v31, v31, v101
		v_sub_f32_e32 v154, v154, v101
		v_sub_f32_e32 v155, v155, v101
		v_sub_f32_e32 v96, v96, v101
		v_sub_f32_e32 v97, v97, v101
		v_sub_f32_e32 v156, v156, v101
		v_sub_f32_e32 v157, v157, v101
		v_sub_f32_e32 v98, v98, v101
		v_sub_f32_e32 v99, v99, v101
		v_sub_f32_e32 v170, v170, v101
		v_sub_f32_e32 v171, v171, v101
		v_sub_f32_e32 v172, v172, v101
		v_sub_f32_e32 v173, v173, v101
		v_sub_f32_e32 v174, v174, v101
		v_sub_f32_e32 v175, v175, v101
		v_sub_f32_e32 v189, v192, v101
		v_sub_f32_e32 v190, v193, v101
		v_sub_f32_e32 v191, v194, v101
		v_sub_f32_e32 v192, v195, v101
		v_sub_f32_e32 v193, v198, v101
		v_sub_f32_e32 v194, v199, v101
		v_sub_f32_e32 v195, v200, v101
		v_sub_f32_e32 v196, v201, v101
		v_sub_f32_e32 v197, v202, v101
		v_sub_f32_e32 v198, v203, v101
		v_sub_f32_e32 v199, v204, v101
		v_sub_f32_e32 v200, v205, v101
		v_sub_f32_e32 v201, v206, v101
		v_sub_f32_e32 v202, v207, v101
		v_sub_f32_e32 v203, v208, v101
		v_sub_f32_e32 v204, v209, v101
		v_sub_f32_e32 v205, v210, v101
		v_sub_f32_e32 v206, v211, v101
		v_sub_f32_e32 v176, v176, v101
		v_sub_f32_e32 v177, v177, v101
		v_sub_f32_e32 v207, v212, v101
		v_sub_f32_e32 v208, v213, v101
		v_sub_f32_e32 v180, v180, v101
		v_sub_f32_e32 v181, v181, v101
		v_sub_f32_e32 v209, v214, v101
		v_sub_f32_e32 v210, v215, v101
		v_sub_f32_e32 v184, v184, v101
		v_sub_f32_e32 v185, v185, v101
		v_sub_f32_e32 v211, v216, v101
		v_sub_f32_e32 v212, v217, v101
		v_exp_f32_e32 v214, v103
		v_exp_f32_e32 v216, v104
		v_exp_f32_e32 v215, v105
		v_exp_f32_e32 v217, v106
		v_exp_f32_e32 v104, v107
		v_exp_f32_e32 v106, v110
		v_exp_f32_e32 v105, v111
		v_exp_f32_e32 v107, v114
		v_exp_f32_e32 v110, v108
		v_exp_f32_e32 v218, v109
		v_exp_f32_e32 v111, v112
		v_exp_f32_e32 v219, v113
		v_exp_f32_e32 v108, v115
		v_exp_f32_e32 v112, v118
		v_exp_f32_e32 v109, v119
		v_exp_f32_e32 v113, v122
		v_exp_f32_e32 v114, v116
		v_exp_f32_e32 v118, v117
		v_exp_f32_e32 v115, v123
		v_exp_f32_e32 v119, v126
		v_exp_f32_e32 v116, v120
		v_exp_f32_e32 v122, v121
		v_exp_f32_e32 v117, v127
		v_exp_f32_e32 v123, v130
		v_exp_f32_e32 v120, v131
		v_exp_f32_e32 v126, v178
		v_exp_f32_e32 v121, v134
		v_exp_f32_e32 v127, v135
		v_exp_f32_e32 v130, v124
		v_exp_f32_e32 v134, v125
		v_exp_f32_e32 v131, v138
		v_exp_f32_e32 v135, v139
		v_exp_f32_e32 v124, v128
		v_exp_f32_e32 v138, v129
		v_exp_f32_e32 v125, v162
		v_exp_f32_e32 v139, v163
		v_exp_f32_e32 v128, v179
		v_exp_f32_e32 v162, v182
		v_exp_f32_e32 v129, v146
		v_exp_f32_e32 v163, v147
		v_exp_f32_e32 v146, v132
		v_exp_f32_e32 v178, v133
		v_exp_f32_e32 v147, v18
		v_exp_f32_e32 v179, v19
		v_exp_f32_e32 v18, v136
		v_exp_f32_e32 v132, v137
		v_exp_f32_e32 v19, v183
		v_exp_f32_e32 v133, v186
		v_exp_f32_e32 v136, v187
		v_exp_f32_e32 v182, v188
		v_exp_f32_e32 v137, v158
		v_exp_f32_e32 v183, v159
		v_exp_f32_e32 v158, v160
		v_exp_f32_e32 v186, v161
		v_exp_f32_e32 v159, v140
		v_exp_f32_e32 v187, v141
		v_exp_f32_e32 v140, v142
		v_exp_f32_e32 v160, v143
		v_exp_f32_e32 v141, v144
		v_exp_f32_e32 v161, v145
		v_exp_f32_e32 v142, v164
		v_exp_f32_e32 v144, v165
		v_exp_f32_e32 v143, v166
		v_exp_f32_e32 v145, v167
		v_exp_f32_e32 v165, v168
		v_exp_f32_e32 v167, v169
		v_exp_f32_e32 v168, v16
		v_exp_f32_e32 v220, v17
		v_exp_f32_e32 v169, v148
		v_exp_f32_e32 v221, v149
		v_exp_f32_e32 v16, v24
		v_exp_f32_e32 v148, v25
		v_exp_f32_e32 v17, v150
		v_exp_f32_e32 v149, v151
		v_exp_f32_e32 v24, v20
		v_exp_f32_e32 v150, v21
		v_exp_f32_e32 v25, v26
		v_exp_f32_e32 v151, v27
		v_exp_f32_e32 v20, v28
		v_exp_f32_e32 v26, v29
		v_exp_f32_e32 v21, v152
		v_exp_f32_e32 v27, v153
		v_exp_f32_e32 v28, v30
		v_exp_f32_e32 v152, v31
		v_exp_f32_e32 v29, v154
		v_exp_f32_e32 v153, v155
		v_exp_f32_e32 v30, v96
		v_exp_f32_e32 v154, v97
		v_exp_f32_e32 v31, v156
		v_exp_f32_e32 v155, v157
		v_exp_f32_e32 v96, v98
		v_exp_f32_e32 v156, v99
		v_exp_f32_e32 v97, v170
		v_exp_f32_e32 v157, v171
		v_exp_f32_e32 v98, v172
		v_exp_f32_e32 v170, v173
		v_exp_f32_e32 v99, v174
		v_exp_f32_e32 v171, v175
		v_exp_f32_e32 v172, v189
		v_exp_f32_e32 v174, v190
		v_exp_f32_e32 v173, v191
		v_exp_f32_e32 v175, v192
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
		v_exp_f32_e32 v201, v176
		v_exp_f32_e32 v203, v177
		v_exp_f32_e32 v176, v207
		v_exp_f32_e32 v204, v208
		v_exp_f32_e32 v177, v180
		v_exp_f32_e32 v205, v181
		v_exp_f32_e32 v180, v209
		v_exp_f32_e32 v206, v210
		v_exp_f32_e32 v181, v184
		v_exp_f32_e32 v207, v185
		v_exp_f32_e32 v184, v211
		v_exp_f32_e32 v208, v212
		v_pk_add_f32 v[210:211], v[214:215], v[216:217]
		v_pk_add_f32 v[212:213], v[104:105], v[106:107]
		v_pk_add_f32 v[222:223], v[110:111], v[218:219]
		v_pk_add_f32 v[224:225], v[108:109], v[112:113]
		v_pk_add_f32 v[226:227], v[114:115], v[118:119]
		v_pk_add_f32 v[228:229], v[116:117], v[122:123]
		v_pk_add_f32 v[230:231], v[120:121], v[126:127]
		v_pk_add_f32 v[232:233], v[130:131], v[134:135]
		v_pk_add_f32 v[234:235], v[124:125], v[138:139]
		v_pk_add_f32 v[236:237], v[128:129], v[162:163]
		v_pk_add_f32 v[238:239], v[146:147], v[178:179]
		v_pk_add_f32 v[240:241], v[18:19], v[132:133]
		v_pk_add_f32 v[242:243], v[136:137], v[182:183]
		v_pk_add_f32 v[244:245], v[158:159], v[186:187]
		v_pk_add_f32 v[246:247], v[140:141], v[160:161]
		v_pk_add_f32 v[248:249], v[142:143], v[144:145]
		v_mov_b32_e32 v250, v211
		v_mov_b32_e32 v251, v213
		v_mov_b32_e32 v252, v210
		v_mov_b32_e32 v253, v212
		v_pk_add_f32 v[210:211], v[252:253], v[250:251]
		v_mov_b32_e32 v212, v223
		v_mov_b32_e32 v213, v225
		v_mov_b32_e32 v250, v222
		v_mov_b32_e32 v251, v224
		v_pk_add_f32 v[222:223], v[250:251], v[212:213]
		v_mov_b32_e32 v212, v227
		v_mov_b32_e32 v213, v229
		v_mov_b32_e32 v224, v226
		v_mov_b32_e32 v225, v228
		v_pk_add_f32 v[226:227], v[224:225], v[212:213]
		v_mov_b32_e32 v212, v231
		v_mov_b32_e32 v213, v233
		v_mov_b32_e32 v224, v230
		v_mov_b32_e32 v225, v232
		v_pk_add_f32 v[228:229], v[224:225], v[212:213]
		v_mov_b32_e32 v212, v235
		v_mov_b32_e32 v213, v237
		v_mov_b32_e32 v224, v234
		v_mov_b32_e32 v225, v236
		v_pk_add_f32 v[230:231], v[224:225], v[212:213]
		v_mov_b32_e32 v212, v239
		v_mov_b32_e32 v213, v241
		v_mov_b32_e32 v224, v238
		v_mov_b32_e32 v225, v240
		v_pk_add_f32 v[232:233], v[224:225], v[212:213]
		v_mov_b32_e32 v212, v243
		v_mov_b32_e32 v213, v245
		v_mov_b32_e32 v224, v242
		v_mov_b32_e32 v225, v244
		v_pk_add_f32 v[234:235], v[224:225], v[212:213]
		v_mov_b32_e32 v212, v247
		v_mov_b32_e32 v213, v249
		v_mov_b32_e32 v224, v246
		v_mov_b32_e32 v225, v248
		v_pk_add_f32 v[236:237], v[224:225], v[212:213]
		v_mov_b32_e32 v212, v211
		v_mov_b32_e32 v213, v223
		v_mov_b32_e32 v224, v210
		v_mov_b32_e32 v225, v222
		v_pk_add_f32 v[210:211], v[224:225], v[212:213]
		v_mov_b32_e32 v212, v227
		v_mov_b32_e32 v213, v229
		v_mov_b32_e32 v222, v226
		v_mov_b32_e32 v223, v228
		v_pk_add_f32 v[224:225], v[222:223], v[212:213]
		v_mov_b32_e32 v212, v231
		v_mov_b32_e32 v213, v233
		v_mov_b32_e32 v222, v230
		v_mov_b32_e32 v223, v232
		v_pk_add_f32 v[226:227], v[222:223], v[212:213]
		v_mov_b32_e32 v212, v235
		v_mov_b32_e32 v213, v237
		v_mov_b32_e32 v222, v234
		v_mov_b32_e32 v223, v236
		v_pk_add_f32 v[228:229], v[222:223], v[212:213]
		v_mov_b32_e32 v212, v211
		v_mov_b32_e32 v213, v225
		v_mov_b32_e32 v222, v210
		v_mov_b32_e32 v223, v224
		v_pk_add_f32 v[210:211], v[222:223], v[212:213]
		v_mov_b32_e32 v212, v227
		v_mov_b32_e32 v213, v229
		v_mov_b32_e32 v222, v226
		v_mov_b32_e32 v223, v228
		v_pk_add_f32 v[224:225], v[222:223], v[212:213]
		v_mov_b32_e32 v212, v211
		v_mov_b32_e32 v213, v225
		v_mov_b32_e32 v222, v210
		v_mov_b32_e32 v223, v224
		v_pk_add_f32 v[210:211], v[222:223], v[212:213]
		v_add_f32_e32 v103, v210, v211
		ds_bpermute_b32 v164, v100, v103
		ds_bpermute_b32 v166, v102, v103
		v_pk_add_f32 v[210:211], v[168:169], v[220:221]
		v_pk_add_f32 v[212:213], v[16:17], v[148:149]
		v_pk_add_f32 v[222:223], v[24:25], v[150:151]
		v_pk_add_f32 v[224:225], v[20:21], v[26:27]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[226:227], v[164:165], v[166:167]
		v_pk_add_f32 v[228:229], v[28:29], v[152:153]
		v_pk_add_f32 v[230:231], v[30:31], v[154:155]
		v_pk_add_f32 v[232:233], v[96:97], v[156:157]
		v_pk_add_f32 v[234:235], v[98:99], v[170:171]
		v_pk_add_f32 v[236:237], v[172:173], v[174:175]
		v_pk_add_f32 v[238:239], v[188:189], v[190:191]
		v_pk_add_f32 v[240:241], v[192:193], v[194:195]
		v_pk_add_f32 v[242:243], v[196:197], v[198:199]
		v_pk_add_f32 v[244:245], v[200:201], v[202:203]
		v_pk_add_f32 v[246:247], v[176:177], v[204:205]
		v_pk_add_f32 v[248:249], v[180:181], v[206:207]
		v_mov_b32_e32 v185, v227
		v_mov_b32_e32 v209, v210
		v_pk_add_f32 v[250:251], v[184:185], v[208:209]
		v_mov_b32_e32 v252, v211
		v_mov_b32_e32 v253, v222
		v_pk_add_f32 v[210:211], v[252:253], v[212:213]
		v_mov_b32_e32 v212, v223
		v_mov_b32_e32 v213, v228
		v_pk_add_f32 v[212:213], v[212:213], v[224:225]
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
		v_mov_b32_e32 v233, v210
		v_pk_add_f32 v[232:233], v[232:233], v[250:251]
		v_mov_b32_e32 v236, v211
		v_mov_b32_e32 v237, v224
		v_pk_add_f32 v[210:211], v[236:237], v[212:213]
		v_mov_b32_e32 v212, v225
		v_mov_b32_e32 v213, v230
		v_pk_add_f32 v[212:213], v[212:213], v[222:223]
		v_mov_b32_e32 v222, v231
		v_mov_b32_e32 v223, v234
		v_pk_add_f32 v[224:225], v[222:223], v[228:229]
		v_mov_b32_e32 v222, v235
		v_mov_b32_e32 v223, v210
		v_pk_add_f32 v[222:223], v[222:223], v[232:233]
		v_mov_b32_e32 v228, v211
		v_mov_b32_e32 v229, v224
		v_pk_add_f32 v[210:211], v[228:229], v[212:213]
		v_mov_b32_e32 v212, v225
		v_mov_b32_e32 v213, v210
		v_pk_add_f32 v[224:225], v[212:213], v[222:223]
		v_add_f32_e32 v103, v211, v224
		v_add_f32_e32 v103, v225, v103
		ds_bpermute_b32 v164, v100, v103
		ds_bpermute_b32 v100, v102, v103
		v_sub_f32_e32 v10, v10, v23
		v_sub_f32_e32 v11, v11, v101
		v_exp_f32_e32 v102, v10
		v_exp_f32_e32 v210, v11
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v11, v164, v100
		v_mov_b32_e32 v103, v102
		v_pk_mul_f32 v[32:33], v[32:33], v[102:103]
		v_pk_mul_f32 v[34:35], v[34:35], v[102:103]
		v_pk_mul_f32 v[36:37], v[36:37], v[102:103]
		v_pk_mul_f32 v[38:39], v[38:39], v[102:103]
		v_pk_mul_f32 v[40:41], v[40:41], v[102:103]
		v_pk_mul_f32 v[42:43], v[42:43], v[102:103]
		v_pk_mul_f32 v[44:45], v[44:45], v[102:103]
		v_pk_mul_f32 v[46:47], v[46:47], v[102:103]
		v_pk_mul_f32 v[48:49], v[48:49], v[102:103]
		v_pk_mul_f32 v[50:51], v[50:51], v[102:103]
		v_pk_mul_f32 v[52:53], v[52:53], v[102:103]
		v_pk_mul_f32 v[54:55], v[54:55], v[102:103]
		v_pk_mul_f32 v[56:57], v[56:57], v[102:103]
		v_pk_mul_f32 v[58:59], v[58:59], v[102:103]
		v_pk_mul_f32 v[60:61], v[60:61], v[102:103]
		v_pk_mul_f32 v[62:63], v[62:63], v[102:103]
		v_mov_b32_e32 v211, v210
		v_pk_mul_f32 v[64:65], v[64:65], v[210:211]
		v_pk_mul_f32 v[66:67], v[66:67], v[210:211]
		v_pk_mul_f32 v[68:69], v[68:69], v[210:211]
		v_pk_mul_f32 v[70:71], v[70:71], v[210:211]
		v_pk_mul_f32 v[72:73], v[72:73], v[210:211]
		v_pk_mul_f32 v[74:75], v[74:75], v[210:211]
		v_pk_mul_f32 v[76:77], v[76:77], v[210:211]
		v_pk_mul_f32 v[78:79], v[78:79], v[210:211]
		v_pk_mul_f32 v[80:81], v[80:81], v[210:211]
		v_pk_mul_f32 v[82:83], v[82:83], v[210:211]
		v_pk_mul_f32 v[84:85], v[84:85], v[210:211]
		v_pk_mul_f32 v[86:87], v[86:87], v[210:211]
		v_pk_mul_f32 v[88:89], v[88:89], v[210:211]
		v_pk_mul_f32 v[90:91], v[90:91], v[210:211]
		v_pk_mul_f32 v[92:93], v[92:93], v[210:211]
		v_pk_mul_f32 v[94:95], v[94:95], v[210:211]
		v_mov_b32_e32 v10, v226
		v_mov_b32_e32 v212, v102
		v_mov_b32_e32 v213, v210
		v_mov_b64_e32 v[102:103], v[12:13]
		v_pk_fma_f32 v[12:13], v[102:103], v[212:213], v[10:11]
		v_cvt_pk_bf16_f32 v224, v214, v216
		v_cvt_pk_bf16_f32 v225, v215, v217
		v_cvt_pk_bf16_f32 v226, v104, v106
		v_cvt_pk_bf16_f32 v227, v105, v107
		v_cvt_pk_bf16_f32 v104, v110, v218
		v_cvt_pk_bf16_f32 v105, v111, v219
		v_cvt_pk_bf16_f32 v106, v108, v112
		v_cvt_pk_bf16_f32 v107, v109, v113
		v_cvt_pk_bf16_f32 v108, v114, v118
		v_cvt_pk_bf16_f32 v109, v115, v119
		v_cvt_pk_bf16_f32 v110, v116, v122
		v_cvt_pk_bf16_f32 v111, v117, v123
		v_cvt_pk_bf16_f32 v112, v120, v126
		v_cvt_pk_bf16_f32 v113, v121, v127
		v_cvt_pk_bf16_f32 v114, v130, v134
		v_cvt_pk_bf16_f32 v115, v131, v135
		v_cvt_pk_bf16_f32 v116, v124, v138
		v_cvt_pk_bf16_f32 v117, v125, v139
		v_cvt_pk_bf16_f32 v118, v128, v162
		v_cvt_pk_bf16_f32 v119, v129, v163
		v_cvt_pk_bf16_f32 v120, v146, v178
		v_cvt_pk_bf16_f32 v121, v147, v179
		v_cvt_pk_bf16_f32 v122, v18, v132
		v_cvt_pk_bf16_f32 v123, v19, v133
		v_cvt_pk_bf16_f32 v124, v136, v182
		v_cvt_pk_bf16_f32 v125, v137, v183
		v_cvt_pk_bf16_f32 v126, v158, v186
		v_cvt_pk_bf16_f32 v127, v159, v187
		v_cvt_pk_bf16_f32 v128, v140, v160
		v_cvt_pk_bf16_f32 v129, v141, v161
		v_cvt_pk_bf16_f32 v130, v142, v144
		v_cvt_pk_bf16_f32 v131, v143, v145
		v_cvt_pk_bf16_f32 v132, v165, v167
		v_cvt_pk_bf16_f32 v133, v168, v220
		v_cvt_pk_bf16_f32 v134, v169, v221
		v_cvt_pk_bf16_f32 v135, v16, v148
		v_cvt_pk_bf16_f32 v136, v17, v149
		v_cvt_pk_bf16_f32 v137, v24, v150
		v_cvt_pk_bf16_f32 v138, v25, v151
		v_cvt_pk_bf16_f32 v139, v20, v26
		v_cvt_pk_bf16_f32 v16, v21, v27
		v_cvt_pk_bf16_f32 v17, v28, v152
		v_cvt_pk_bf16_f32 v18, v29, v153
		v_cvt_pk_bf16_f32 v19, v30, v154
		v_cvt_pk_bf16_f32 v24, v31, v155
		v_cvt_pk_bf16_f32 v25, v96, v156
		v_cvt_pk_bf16_f32 v26, v97, v157
		v_cvt_pk_bf16_f32 v27, v98, v170
		v_cvt_pk_bf16_f32 v28, v99, v171
		v_cvt_pk_bf16_f32 v29, v172, v174
		v_cvt_pk_bf16_f32 v30, v173, v175
		v_cvt_pk_bf16_f32 v31, v188, v190
		v_cvt_pk_bf16_f32 v96, v189, v191
		v_cvt_pk_bf16_f32 v97, v192, v194
		v_cvt_pk_bf16_f32 v98, v193, v195
		v_cvt_pk_bf16_f32 v99, v196, v198
		v_cvt_pk_bf16_f32 v140, v197, v199
		v_cvt_pk_bf16_f32 v141, v200, v202
		v_cvt_pk_bf16_f32 v142, v201, v203
		v_cvt_pk_bf16_f32 v143, v176, v204
		v_cvt_pk_bf16_f32 v144, v177, v205
		v_cvt_pk_bf16_f32 v145, v180, v206
		v_cvt_pk_bf16_f32 v146, v181, v207
		v_cvt_pk_bf16_f32 v147, v184, v208
		v_permlane32_swap_b32_e32 v224, v226
		v_permlane32_swap_b32_e32 v225, v227
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_mfma_f32_32x32x16_bf16 v[32:47], a[140:143], v[224:227], v[32:47]
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
		v_mfma_f32_32x32x16_bf16 v[48:63], a[172:175], v[224:227], v[48:63]
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_mfma_f32_32x32x16_bf16 v[80:95], a[172:175], v[132:135], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[140:143], v[132:135], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[144:147], v[104:107], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[176:179], v[104:107], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[176:179], v[136:139], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[144:147], v[136:139], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[148:151], v[108:111], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[180:183], v[108:111], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[180:183], v[16:19], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[148:151], v[16:19], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[152:155], v[112:115], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[184:187], v[112:115], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[184:187], v[24:27], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[152:155], v[24:27], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[156:159], v[116:119], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[188:191], v[116:119], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[188:191], v[28:31], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[156:159], v[28:31], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[160:163], v[120:123], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[192:195], v[120:123], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[192:195], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[160:163], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[164:167], v[124:127], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[196:199], v[124:127], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[196:199], v[140:143], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[164:167], v[140:143], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[168:171], v[128:131], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[200:203], v[128:131], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[200:203], v[144:147], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[168:171], v[144:147], v[64:79]
		s_mov_b32 s46, s22
		v_mov_b32_e32 v10, v23
		v_mov_b32_e32 v11, v101
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_4
.L_attn_fwd_persistent.loop_exit_4:
		v_rcp_f32_e32 v8, v12
		v_rcp_f32_e32 v10, v13
		v_mov_b32_e32 v9, v8
		s_nop 1
		v_pk_mul_f32 v[12:13], v[32:33], v[8:9]
		v_pk_mul_f32 v[14:15], v[34:35], v[8:9]
		v_pk_mul_f32 v[16:17], v[36:37], v[8:9]
		v_pk_mul_f32 v[18:19], v[38:39], v[8:9]
		v_pk_mul_f32 v[20:21], v[40:41], v[8:9]
		v_pk_mul_f32 v[22:23], v[42:43], v[8:9]
		v_pk_mul_f32 v[24:25], v[44:45], v[8:9]
		v_pk_mul_f32 v[26:27], v[46:47], v[8:9]
		v_pk_mul_f32 v[28:29], v[48:49], v[8:9]
		v_pk_mul_f32 v[30:31], v[50:51], v[8:9]
		v_pk_mul_f32 v[32:33], v[52:53], v[8:9]
		v_pk_mul_f32 v[34:35], v[54:55], v[8:9]
		v_pk_mul_f32 v[36:37], v[56:57], v[8:9]
		v_pk_mul_f32 v[38:39], v[58:59], v[8:9]
		v_pk_mul_f32 v[40:41], v[60:61], v[8:9]
		v_pk_mul_f32 v[42:43], v[62:63], v[8:9]
		v_mov_b32_e32 v11, v10
		v_pk_mul_f32 v[8:9], v[64:65], v[10:11]
		v_pk_mul_f32 v[44:45], v[66:67], v[10:11]
		v_pk_mul_f32 v[46:47], v[68:69], v[10:11]
		v_pk_mul_f32 v[48:49], v[70:71], v[10:11]
		v_pk_mul_f32 v[50:51], v[72:73], v[10:11]
		v_pk_mul_f32 v[52:53], v[74:75], v[10:11]
		v_pk_mul_f32 v[54:55], v[76:77], v[10:11]
		v_pk_mul_f32 v[56:57], v[78:79], v[10:11]
		v_pk_mul_f32 v[58:59], v[80:81], v[10:11]
		v_pk_mul_f32 v[60:61], v[82:83], v[10:11]
		v_pk_mul_f32 v[62:63], v[84:85], v[10:11]
		v_pk_mul_f32 v[64:65], v[86:87], v[10:11]
		v_pk_mul_f32 v[66:67], v[88:89], v[10:11]
		v_pk_mul_f32 v[68:69], v[90:91], v[10:11]
		v_pk_mul_f32 v[70:71], v[92:93], v[10:11]
		v_pk_mul_f32 v[72:73], v[94:95], v[10:11]
		v_cvt_pk_bf16_f32 v76, v12, v13
		v_cvt_pk_bf16_f32 v77, v14, v15
		v_cvt_pk_bf16_f32 v78, v16, v17
		v_cvt_pk_bf16_f32 v79, v18, v19
		v_cvt_pk_bf16_f32 v12, v20, v21
		v_cvt_pk_bf16_f32 v13, v22, v23
		v_cvt_pk_bf16_f32 v14, v24, v25
		v_cvt_pk_bf16_f32 v15, v26, v27
		v_cvt_pk_bf16_f32 v16, v28, v29
		v_cvt_pk_bf16_f32 v17, v30, v31
		v_cvt_pk_bf16_f32 v18, v32, v33
		v_cvt_pk_bf16_f32 v19, v34, v35
		v_cvt_pk_bf16_f32 v20, v36, v37
		v_cvt_pk_bf16_f32 v21, v38, v39
		v_cvt_pk_bf16_f32 v22, v40, v41
		v_cvt_pk_bf16_f32 v23, v42, v43
		v_cvt_pk_bf16_f32 v24, v8, v9
		v_cvt_pk_bf16_f32 v25, v44, v45
		v_cvt_pk_bf16_f32 v26, v46, v47
		v_cvt_pk_bf16_f32 v27, v48, v49
		v_cvt_pk_bf16_f32 v8, v50, v51
		v_cvt_pk_bf16_f32 v9, v52, v53
		v_cvt_pk_bf16_f32 v10, v54, v55
		v_cvt_pk_bf16_f32 v11, v56, v57
		v_cvt_pk_bf16_f32 v28, v58, v59
		v_cvt_pk_bf16_f32 v29, v60, v61
		v_cvt_pk_bf16_f32 v30, v62, v63
		v_cvt_pk_bf16_f32 v31, v64, v65
		v_cvt_pk_bf16_f32 v32, v66, v67
		v_cvt_pk_bf16_f32 v33, v68, v69
		v_cvt_pk_bf16_f32 v34, v70, v71
		v_cvt_pk_bf16_f32 v35, v72, v73
		v_permlane32_swap_b32_e32 v76, v78
		v_permlane32_swap_b32_e32 v77, v79
		v_permlane32_swap_b32_e32 v12, v14
		v_permlane32_swap_b32_e32 v13, v15
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v20, v22
		v_permlane32_swap_b32_e32 v21, v23
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_permlane32_swap_b32_e32 v32, v34
		v_permlane32_swap_b32_e32 v33, v35
		s_lshl_b32 s1, s45, 9
		s_add_i32 s22, s1, s27
		s_add_i32 s22, s22, s38
		v_accvgpr_read_b32 v6, a1
		v_accvgpr_read_b32 v36, a2
		v_add3_u32 v6, s22, v6, v36
		v_accvgpr_read_b32 v36, a3
		v_accvgpr_read_b32 v37, a4
		v_add3_u32 v6, v6, v36, v37
		v_accvgpr_read_b32 v36, a6
		v_accvgpr_read_b32 v37, a8
		v_add3_u32 v6, v6, v36, v37
		v_accvgpr_read_b32 v36, a10
		v_accvgpr_read_b32 v37, a7
		v_add3_u32 v6, v6, v36, v37
		v_cndmask_b32_e64 v6, v7, v6, s[48:49]
		buffer_store_dwordx4 v[76:79], v6, s[40:43], 0 offen
		s_add_i32 s25, s1, 32
		s_add_i32 s25, s25, s27
		s_add_i32 s25, s25, s38
		v_accvgpr_read_b32 v6, a1
		v_accvgpr_read_b32 v36, a2
		v_add3_u32 v6, s25, v6, v36
		v_accvgpr_read_b32 v36, a3
		v_accvgpr_read_b32 v37, a4
		v_add3_u32 v6, v6, v36, v37
		v_accvgpr_read_b32 v36, a6
		v_accvgpr_read_b32 v37, a8
		v_add3_u32 v6, v6, v36, v37
		v_accvgpr_read_b32 v36, a10
		v_accvgpr_read_b32 v37, a7
		v_add3_u32 v6, v6, v36, v37
		v_cndmask_b32_e64 v6, v7, v6, s[48:49]
		buffer_store_dwordx4 v[12:15], v6, s[40:43], 0 offen
		s_add_i32 s26, s1, 64
		s_add_i32 s26, s26, s27
		s_add_i32 s26, s26, s38
		v_accvgpr_read_b32 v6, a1
		v_accvgpr_read_b32 v12, a2
		v_add3_u32 v6, s26, v6, v12
		v_accvgpr_read_b32 v12, a3
		v_accvgpr_read_b32 v13, a4
		v_add3_u32 v6, v6, v12, v13
		v_accvgpr_read_b32 v12, a6
		v_accvgpr_read_b32 v13, a8
		v_add3_u32 v6, v6, v12, v13
		v_accvgpr_read_b32 v12, a10
		v_accvgpr_read_b32 v13, a7
		v_add3_u32 v6, v6, v12, v13
		v_cndmask_b32_e64 v6, v7, v6, s[48:49]
		buffer_store_dwordx4 v[16:19], v6, s[40:43], 0 offen
		s_add_i32 s1, s1, 0x60
		s_add_i32 s1, s1, s27
		s_add_i32 s1, s1, s38
		v_accvgpr_read_b32 v6, a1
		v_accvgpr_read_b32 v12, a2
		v_add3_u32 v6, s1, v6, v12
		v_accvgpr_read_b32 v12, a3
		v_accvgpr_read_b32 v13, a4
		v_add3_u32 v6, v6, v12, v13
		v_accvgpr_read_b32 v12, a6
		v_accvgpr_read_b32 v13, a8
		v_add3_u32 v6, v6, v12, v13
		v_accvgpr_read_b32 v12, a10
		v_accvgpr_read_b32 v13, a7
		v_add3_u32 v6, v6, v12, v13
		v_cndmask_b32_e64 v6, v7, v6, s[48:49]
		buffer_store_dwordx4 v[20:23], v6, s[40:43], 0 offen
		v_accvgpr_read_b32 v6, a0
		v_accvgpr_read_b32 v12, a7
		v_add3_u32 v6, s22, v6, v12
		v_cndmask_b32_e64 v6, v7, v6, s[50:51]
		buffer_store_dwordx4 v[24:27], v6, s[40:43], 0 offen
		v_accvgpr_read_b32 v6, a0
		v_accvgpr_read_b32 v12, a7
		v_add3_u32 v6, s25, v6, v12
		v_cndmask_b32_e64 v6, v7, v6, s[50:51]
		buffer_store_dwordx4 v[8:11], v6, s[40:43], 0 offen
		v_accvgpr_read_b32 v6, a0
		s_nop 0
		v_accvgpr_read_b32 v8, a7
		v_add3_u32 v6, s26, v6, v8
		v_cndmask_b32_e64 v6, v7, v6, s[50:51]
		buffer_store_dwordx4 v[28:31], v6, s[40:43], 0 offen
		v_accvgpr_read_b32 v6, a0
		v_accvgpr_read_b32 v8, a7
		v_add3_u32 v6, s1, v6, v8
		v_cndmask_b32_e64 v6, v7, v6, s[50:51]
		buffer_store_dwordx4 v[32:35], v6, s[40:43], 0 offen
		s_branch .L_attn_fwd_persistent.if_end_0
.L_attn_fwd_persistent.if_else_0:
.L_attn_fwd_persistent.if_end_0:
		s_mov_b32 m0, s17
		s_add_i32 s0, s0, 32
		ds_read_addtid_b32 v6 offset:24576
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v6
		s_lshl_b32 s1, s1, 2
		s_add_i32 s1, s1, 0x189b0
		s_mov_b32 m0, s1
		s_nop 0
		ds_read_addtid_b32 v6 offset:2048
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s1, v6
		s_mul_i32 s1, s1, 16
		s_nop 0
		v_mov_b32_e32 v6, s1
		s_nop 0
		v_readfirstlane_b32 s1, v6
		s_cmp_lt_i32 s0, s1
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_0
.L_attn_fwd_persistent.loop_exit_0:
		s_endpgm
	.size	_attn_fwd_persistent, .-_attn_fwd_persistent
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _attn_fwd_persistent
		.amdhsa_group_segment_fixed_size 140720
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
		.amdhsa_next_free_sgpr 100
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
	.set .L_attn_fwd_persistent.numbered_sgpr, 100
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
    .group_segment_fixed_size: 140720
    .kernarg_segment_align: 8
    .kernarg_segment_size: 104
    .max_flat_workgroup_size: 256
    .name:           _attn_fwd_persistent
    .private_segment_fixed_size: 0
    .sgpr_count:     100
    .sgpr_spill_count: 0
    .symbol:         _attn_fwd_persistent.kd
    .uses_dynamic_stack: false
    .vgpr_count:     512
    .agpr_count:     256
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 517
    wave.regalloc.agpr.dwords: 821
    wave.regalloc.remat.dwords: 108
    wave.regalloc.sgpr_to_vgpr.dwords: 92
    wave.regalloc.lds.dwords: 39
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
