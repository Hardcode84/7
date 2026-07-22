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
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v1, s18
		v_accvgpr_write_b32 a0, v1
		s_load_dword s18, s[0:1], 0x3c
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v1, s18
		v_accvgpr_write_b32 a1, v1
		s_load_dword s18, s[0:1], 0x40
		s_load_dword s19, s[0:1], 0x44
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s17
		v_mov_b32_e32 v1, s19
		ds_write_addtid_b32 v1
		s_load_dword s19, s[0:1], 0x48
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s17
		v_mov_b32_e32 v2, s19
		ds_write_addtid_b32 v2 offset:1024
		s_load_dword s19, s[0:1], 0x4c
		s_load_dword s20, s[0:1], 0x50
		s_load_dword s21, s[0:1], 0x54
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v3, s21
		s_load_dword s21, s[0:1], 0x58
		s_load_dword s22, s[0:1], 0x5c
		s_load_dword s23, s[0:1], 0x60
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v4, s23
		v_accvgpr_write_b32 a2, 0
		s_and_b32 s0, s16, 7
		v_mov_b32_e32 v5, s0
		v_accvgpr_write_b32 a3, v5
		s_lshr_b32 s0, s16, 3
		v_readfirstlane_b32 s1, v3
		s_mul_i32 s1, s20, s1
		s_nop 0
		v_mov_b32_e32 v5, s1
		v_accvgpr_write_b32 a4, v5
		v_accvgpr_read_b32 v5, a4
		s_nop 0
		v_readfirstlane_b32 s1, v5
		s_add_i32 s1, s1, 7
		s_mov_b32 s16, 1
		s_mov_b32 s20, 7
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s20, s20, 0
		s_add_i32 s1, s1, s20
		s_ashr_i32 s1, s1, 3
		s_mul_i32 s1, s1, 16
		v_mov_b32_e32 v5, s1
		v_accvgpr_write_b32 a5, v5
		v_accvgpr_read_b32 v5, a5
		s_nop 0
		v_readfirstlane_b32 s1, v5
		s_cmp_lt_i32 s0, s1
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_0
.L_attn_fwd_persistent.loop_head_0:
		s_lshr_b32 s1, s0, 4
		s_and_b32 s20, s0, 15
		s_mul_i32 s1, s1, 8
		v_accvgpr_read_b32 v5, a3
		s_nop 0
		v_readfirstlane_b32 s24, v5
		s_add_i32 s1, s24, s1
		v_accvgpr_read_b32 v5, a4
		s_nop 0
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
		v_readfirstlane_b32 s26, v3
		s_xor_b32 s26, s26, -1
		s_add_i32 s26, s26, 1
		v_readfirstlane_b32 s27, v3
		s_cmp_lt_i32 s27, 0
		v_readfirstlane_b32 s27, v3
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
		v_readfirstlane_b32 s29, v3
		s_xor_b32 s1, s1, s29
		s_xor_b32 s29, s26, -1
		s_add_i32 s29, s29, 1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s1, s29, s26
		s_mov_b32 m0, s17
		v_mov_b32_e32 v5, s1
		ds_write_addtid_b32 v5 offset:2048
		s_add_i32 s1, s24, s27
		s_cmp_lg_u32 s28, 0
		s_cselect_b32 s1, s1, s24
		s_xor_b32 s24, s1, -1
		s_add_i32 s24, s24, 1
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s1, s24, s1
		v_mov_b32_e32 v6, s1
		s_mul_i32 s20, s20, 2
		s_cmp_lt_i32 s20, 32
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_1
		s_lshr_b32 s24, s20, 1
		s_and_b32 s20, s20, 1
		s_xor_b32 s25, s24, -1
		s_add_i32 s25, s25, 1
		s_add_i32 s25, s25, 31
		s_cmp_eq_u32 s20, 0
		s_cselect_b32 s20, s24, s25
		v_mov_b32_e32 v7, s20
		s_nop 0
		v_readfirstlane_b32 s20, v7
		s_mul_i32 s20, s20, 0x100
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
		v_accvgpr_write_b32 a6, v23
		v_accvgpr_read_b32 v23, a6
		v_and_b32_e32 v23, 1, v23
		v_mov_b32_e32 v24, 64
		v_mul_lo_u32 v24, v24, v23
		v_xor_b32_e32 v12, v12, v24
		v_accvgpr_write_b32 a7, v12
		v_accvgpr_read_b32 v12, a7
		v_add_u32_e32 v12, s20, v12
		v_xor_b32_e32 v8, 0x80, v8
		v_xor_b32_e32 v8, v8, v11
		v_xor_b32_e32 v8, v8, v13
		v_bitop3_b32 v8, v8, v16, v19 bitop3:0x96
		v_bitop3_b32 v8, v8, v22, v24 bitop3:0x96
		v_accvgpr_write_b32 a8, v8
		v_accvgpr_read_b32 v8, a8
		v_add_u32_e32 v8, s20, v8
		v_cmp_lt_i32_e64 vcc, v12, s21
		s_mov_b64 s[24:25], vcc
		v_mov_b32_e32 v12, s24
		v_mov_b32_e32 v13, s25
		v_cmp_lt_i32_e64 vcc, v8, s21
		s_mov_b64 s[24:25], vcc
		v_mov_b32_e32 v24, s24
		v_mov_b32_e32 v25, s25
		v_accvgpr_write_b32 a10, v24
		v_accvgpr_write_b32 a11, v25
		v_mov_b32_e32 v8, 2
		v_mul_lo_u32 v8, v8, v18
		v_lshrrev_b32_e32 v11, 5, v0
		v_and_b32_e32 v16, 1, v11
		v_accvgpr_write_b32 a9, v16
		v_accvgpr_read_b32 v16, a9
		v_mov_b32_e32 v19, 4
		v_mul_lo_u32 v19, v19, v16
		v_bitop3_b32 v16, v15, v8, v19 bitop3:0x96
		v_mov_b32_e32 v22, 8
		v_mul_lo_u32 v22, v22, v21
		v_xor_b32_e32 v16, v16, v22
		v_mov_b32_e32 v24, 16
		v_mul_lo_u32 v24, v24, v23
		v_xad_u32 v16, v16, v24, s20
		v_bitop3_b32 v25, 32, v15, v8 bitop3:0x96
		v_bitop3_b32 v25, v25, v19, v22 bitop3:0x96
		v_xad_u32 v25, v25, v24, s20
		v_bitop3_b32 v26, 64, v15, v8 bitop3:0x96
		v_bitop3_b32 v26, v26, v19, v22 bitop3:0x96
		v_xad_u32 v26, v26, v24, s20
		v_xor_b32_e32 v27, 0x60, v15
		v_xor_b32_e32 v27, v27, v8
		v_xor_b32_e32 v27, v27, v19
		v_xor_b32_e32 v27, v27, v22
		v_xad_u32 v27, v27, v24, s20
		v_xor_b32_e32 v28, 0x80, v15
		v_xor_b32_e32 v28, v28, v8
		v_xor_b32_e32 v28, v28, v19
		v_xor_b32_e32 v28, v28, v22
		v_xad_u32 v28, v28, v24, s20
		v_xor_b32_e32 v29, 0xa0, v15
		v_xor_b32_e32 v29, v29, v8
		v_xor_b32_e32 v29, v29, v19
		v_xor_b32_e32 v29, v29, v22
		v_xad_u32 v29, v29, v24, s20
		v_xor_b32_e32 v30, 0xc0, v15
		v_xor_b32_e32 v30, v30, v8
		v_xor_b32_e32 v30, v30, v19
		v_xor_b32_e32 v30, v30, v22
		v_xad_u32 v30, v30, v24, s20
		v_xor_b32_e32 v31, 0xe0, v15
		v_xor_b32_e32 v8, v31, v8
		v_xor_b32_e32 v8, v8, v19
		v_xor_b32_e32 v8, v8, v22
		v_xad_u32 v8, v8, v24, s20
		s_mov_b32 s26, 0x7fffffff
		s_mov_b32 s27, 0x31016000
		s_mov_b32 s24, s2
		s_mov_b32 s25, s3
		v_accvgpr_read_b32 v22, a2
		v_and_b32_e32 v22, 0xffff, v22
		v_lshlrev_b32_e32 v24, 16, v22
		v_or_b32_e32 v32, v22, v24
		v_mov_b32_e32 v33, v32
		v_mov_b32_e32 v34, v32
		v_mov_b32_e32 v35, v32
		v_readfirstlane_b32 s28, v7
		s_mul_i32 s28, s28, s12
		s_lshl_b32 s28, s28, 9
		v_readfirstlane_b32 s29, v5
		s_mul_i32 s29, s29, s10
		s_lshl_b32 s29, s29, 1
		s_add_i32 s28, s28, s29
		v_readfirstlane_b32 s29, v6
		s_mul_i32 s29, s29, s11
		s_lshl_b32 s29, s29, 1
		s_add_i32 s28, s28, s29
		v_accvgpr_read_b32 v22, a6
		v_mul_lo_u32 v22, s12, v22
		v_lshl_add_u32 v22, v22, 5, s28
		v_and_b32_e32 v24, 1, v20
		v_accvgpr_write_b32 a12, v24
		v_accvgpr_read_b32 v24, a12
		v_mul_lo_u32 v24, s12, v24
		v_lshl_add_u32 v22, v24, 4, v22
		v_and_b32_e32 v11, 1, v11
		v_mul_lo_u32 v24, s12, v11
		v_lshl_add_u32 v22, v24, 3, v22
		v_and_b32_e32 v17, 1, v17
		v_accvgpr_write_b32 a13, v17
		v_accvgpr_read_b32 v17, a13
		v_mul_lo_u32 v17, s12, v17
		v_lshl_add_u32 v17, v17, 2, v22
		v_and_b32_e32 v14, 1, v14
		v_accvgpr_write_b32 a14, v14
		v_accvgpr_read_b32 v14, a14
		v_mul_lo_u32 v14, s12, v14
		v_lshl_add_u32 v14, v14, 1, v17
		v_and_b32_e32 v17, 1, v0
		v_accvgpr_write_b32 a15, v17
		v_accvgpr_read_b32 v17, a15
		v_lshl_add_u32 v14, v17, 4, v14
		v_and_b32_e32 v17, 1, v10
		v_accvgpr_write_b32 a16, v17
		v_accvgpr_read_b32 v17, a16
		v_lshl_add_u32 v14, v17, 6, v14
		v_and_b32_e32 v9, 1, v9
		v_accvgpr_write_b32 a17, v9
		v_accvgpr_read_b32 v9, a17
		v_lshl_add_u32 v9, v9, 5, v14
		v_cmp_lt_i32_e64 vcc, v16, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_0
		buffer_load_dwordx4 v[36:39], v9, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_0:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_0
		v_mov_b32_e32 v36, v32
		v_mov_b32_e32 v37, v33
		v_mov_b32_e32 v38, v34
		v_mov_b32_e32 v39, v35
.L_attn_fwd_persistent.exec_endif_0:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v9, a6
		v_lshlrev_b32_e32 v9, 4, v9
		v_accvgpr_read_b32 v14, a12
		v_lshlrev_b32_e32 v14, 3, v14
		v_lshlrev_b32_e32 v16, 2, v11
		v_accvgpr_read_b32 v17, a14
		v_add_u32_e32 v17, 32, v17
		v_accvgpr_read_b32 v22, a13
		v_lshlrev_b32_e32 v22, 1, v22
		v_bitop3_b32 v17, v16, v17, v22 bitop3:0x96
		v_bitop3_b32 v17, v9, v14, v17 bitop3:0x96
		v_mul_lo_u32 v17, s12, v17
		v_lshl_add_u32 v17, v17, 1, s28
		v_accvgpr_read_b32 v24, a15
		v_lshl_add_u32 v17, v24, 4, v17
		v_accvgpr_read_b32 v24, a16
		v_lshl_add_u32 v17, v24, 6, v17
		v_accvgpr_read_b32 v24, a17
		v_lshl_add_u32 v17, v24, 5, v17
		v_cmp_lt_i32_e64 vcc, v25, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_1
		buffer_load_dwordx4 v[40:43], v17, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_1:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_1
		v_mov_b32_e32 v40, v32
		v_mov_b32_e32 v41, v33
		v_mov_b32_e32 v42, v34
		v_mov_b32_e32 v43, v35
.L_attn_fwd_persistent.exec_endif_1:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v17, a14
		v_add_u32_e32 v17, 64, v17
		v_bitop3_b32 v17, v16, v17, v22 bitop3:0x96
		v_bitop3_b32 v17, v9, v14, v17 bitop3:0x96
		v_mul_lo_u32 v17, s12, v17
		v_lshl_add_u32 v17, v17, 1, s28
		v_accvgpr_read_b32 v24, a15
		v_lshl_add_u32 v17, v24, 4, v17
		v_accvgpr_read_b32 v24, a16
		v_lshl_add_u32 v17, v24, 6, v17
		v_accvgpr_read_b32 v24, a17
		v_lshl_add_u32 v17, v24, 5, v17
		v_cmp_lt_i32_e64 vcc, v26, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_2
		buffer_load_dwordx4 v[44:47], v17, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_2:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_2
		v_mov_b32_e32 v44, v32
		v_mov_b32_e32 v45, v33
		v_mov_b32_e32 v46, v34
		v_mov_b32_e32 v47, v35
.L_attn_fwd_persistent.exec_endif_2:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v17, a14
		v_add_u32_e32 v17, 0x60, v17
		v_bitop3_b32 v17, v16, v17, v22 bitop3:0x96
		v_bitop3_b32 v17, v9, v14, v17 bitop3:0x96
		v_mul_lo_u32 v17, s12, v17
		v_lshl_add_u32 v17, v17, 1, s28
		v_accvgpr_read_b32 v24, a15
		v_lshl_add_u32 v17, v24, 4, v17
		v_accvgpr_read_b32 v24, a16
		v_lshl_add_u32 v17, v24, 6, v17
		v_accvgpr_read_b32 v24, a17
		v_lshl_add_u32 v17, v24, 5, v17
		v_cmp_lt_i32_e64 vcc, v27, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_3
		buffer_load_dwordx4 v[24:27], v17, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_3:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_3
		v_mov_b32_e32 v24, v32
		v_mov_b32_e32 v25, v33
		v_mov_b32_e32 v26, v34
		v_mov_b32_e32 v27, v35
.L_attn_fwd_persistent.exec_endif_3:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v17, a14
		v_add_u32_e32 v17, 0x80, v17
		v_bitop3_b32 v17, v16, v17, v22 bitop3:0x96
		v_bitop3_b32 v17, v9, v14, v17 bitop3:0x96
		v_mul_lo_u32 v17, s12, v17
		v_lshl_add_u32 v17, v17, 1, s28
		v_accvgpr_read_b32 v31, a15
		v_lshl_add_u32 v17, v31, 4, v17
		v_accvgpr_read_b32 v31, a16
		v_lshl_add_u32 v17, v31, 6, v17
		v_accvgpr_read_b32 v31, a17
		v_lshl_add_u32 v17, v31, 5, v17
		v_cmp_lt_i32_e64 vcc, v28, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_4
		buffer_load_dwordx4 v[48:51], v17, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_4:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_4
		v_mov_b32_e32 v48, v32
		v_mov_b32_e32 v49, v33
		v_mov_b32_e32 v50, v34
		v_mov_b32_e32 v51, v35
.L_attn_fwd_persistent.exec_endif_4:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v17, a14
		v_add_u32_e32 v17, 0xa0, v17
		v_bitop3_b32 v17, v16, v17, v22 bitop3:0x96
		v_bitop3_b32 v17, v9, v14, v17 bitop3:0x96
		v_mul_lo_u32 v17, s12, v17
		v_lshl_add_u32 v17, v17, 1, s28
		v_accvgpr_read_b32 v28, a15
		v_lshl_add_u32 v17, v28, 4, v17
		v_accvgpr_read_b32 v28, a16
		v_lshl_add_u32 v17, v28, 6, v17
		v_accvgpr_read_b32 v28, a17
		v_lshl_add_u32 v17, v28, 5, v17
		v_cmp_lt_i32_e64 vcc, v29, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_5
		buffer_load_dwordx4 v[52:55], v17, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_5:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_5
		v_mov_b32_e32 v52, v32
		v_mov_b32_e32 v53, v33
		v_mov_b32_e32 v54, v34
		v_mov_b32_e32 v55, v35
.L_attn_fwd_persistent.exec_endif_5:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v17, a14
		v_add_u32_e32 v17, 0xc0, v17
		v_bitop3_b32 v17, v16, v17, v22 bitop3:0x96
		v_bitop3_b32 v17, v9, v14, v17 bitop3:0x96
		v_mul_lo_u32 v17, s12, v17
		v_lshl_add_u32 v17, v17, 1, s28
		v_accvgpr_read_b32 v28, a15
		v_lshl_add_u32 v17, v28, 4, v17
		v_accvgpr_read_b32 v28, a16
		v_lshl_add_u32 v17, v28, 6, v17
		v_accvgpr_read_b32 v28, a17
		v_lshl_add_u32 v17, v28, 5, v17
		v_cmp_lt_i32_e64 vcc, v30, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_6
		buffer_load_dwordx4 v[28:31], v17, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_6:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_6
		v_mov_b32_e32 v28, v32
		v_mov_b32_e32 v29, v33
		v_mov_b32_e32 v30, v34
		v_mov_b32_e32 v31, v35
.L_attn_fwd_persistent.exec_endif_6:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v17, a14
		v_add_u32_e32 v17, 0xe0, v17
		v_bitop3_b32 v16, v16, v17, v22 bitop3:0x96
		v_bitop3_b32 v14, v9, v14, v16 bitop3:0x96
		v_mul_lo_u32 v14, s12, v14
		v_lshl_add_u32 v14, v14, 1, s28
		v_accvgpr_read_b32 v16, a15
		v_lshl_add_u32 v14, v16, 4, v14
		v_accvgpr_read_b32 v16, a16
		v_lshl_add_u32 v14, v16, 6, v14
		v_accvgpr_read_b32 v16, a17
		v_lshl_add_u32 v14, v16, 5, v14
		v_cmp_lt_i32_e64 vcc, v8, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_7
		buffer_load_dwordx4 v[56:59], v14, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_7:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_7
		v_mov_b32_e32 v56, v32
		v_mov_b32_e32 v57, v33
		v_mov_b32_e32 v58, v34
		v_mov_b32_e32 v59, v35
.L_attn_fwd_persistent.exec_endif_7:
		s_mov_b64 exec, s[98:99]
		s_mov_b32 s28, s4
		s_mov_b32 s29, s5
		s_mov_b32 s30, s26
		s_mov_b32 s31, s27
		s_mov_b32 s32, s6
		s_mov_b32 s33, s7
		s_mov_b32 s34, s26
		s_mov_b32 s35, s27
		s_waitcnt vmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v8, a12
		v_lshlrev_b32_e32 v8, 2, v8
		v_lshlrev_b32_e32 v14, 1, v11
		v_accvgpr_read_b32 v16, a13
		v_xor_b32_e32 v16, v0, v16
		v_bitop3_b32 v8, v8, v14, v16 bitop3:0x96
		v_lshlrev_b32_e32 v8, 4, v8
		v_add_u32_e32 v8, 0x10000, v8
		ds_write_b128 v8, v[36:39] offset:2480
		ds_write_b128 v8, v[40:43] offset:6576
		ds_write_b128 v8, v[44:47] offset:10672
		ds_write_b128 v8, v[24:27] offset:14768
		v_lshlrev_b32_e32 v14, 12, v20
		v_add_u32_e32 v14, 0x10000, v14
		v_and_b32_e32 v16, 63, v0
		v_lshrrev_b32_e32 v17, 2, v16
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v17, 5, v17
		v_lshrrev_b32_e32 v20, 1, v16
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v20, 4, v20
		v_and_b32_e32 v22, 1, v16
		v_lshlrev_b32_e32 v22, 3, v22
		v_add3_u32 v24, v17, v20, v22
		v_lshrrev_b32_e32 v25, 5, v16
		v_accvgpr_write_b32 a18, v25
		v_accvgpr_read_b32 v25, a18
		v_xor_b32_e32 v24, v24, v25
		v_lshrrev_b32_e32 v25, 6, v24
		v_lshrrev_b32_e32 v26, 3, v16
		v_and_b32_e32 v26, 1, v26
		v_add_u32_e32 v25, v25, v26
		v_and_b32_e32 v25, 1, v25
		v_lshlrev_b32_e32 v25, 2, v25
		v_lshrrev_b32_e32 v27, 5, v24
		v_and_b32_e32 v27, 1, v27
		v_lshlrev_b32_e32 v27, 1, v27
		v_lshrrev_b32_e32 v32, 4, v16
		v_and_b32_e32 v32, 1, v32
		v_lshlrev_b32_e32 v33, 6, v26
		v_lshl_add_u32 v32, v32, 7, v33
		v_add_u32_e32 v33, v32, v24
		v_lshrrev_b32_e32 v24, 4, v24
		v_bitop3_b32 v24, v33, v24, 1 bitop3:0x78
		v_bitop3_b32 v24, v25, v27, v24 bitop3:0x96
		v_lshl_add_u32 v25, v24, 4, v14
		ds_read_b128 a[20:23], v25 offset:2480
		v_add_u32_e32 v25, 2, v17
		v_add3_u32 v25, v25, v20, v22
		v_accvgpr_read_b32 v27, a18
		v_xor_b32_e32 v25, v25, v27
		v_lshrrev_b32_e32 v27, 6, v25
		v_add_u32_e32 v27, v27, v26
		v_and_b32_e32 v27, 1, v27
		v_lshlrev_b32_e32 v27, 2, v27
		v_lshrrev_b32_e32 v33, 5, v25
		v_and_b32_e32 v33, 1, v33
		v_lshlrev_b32_e32 v33, 1, v33
		v_add_u32_e32 v34, v32, v25
		v_lshrrev_b32_e32 v25, 4, v25
		v_bitop3_b32 v25, v34, v25, 1 bitop3:0x78
		v_bitop3_b32 v25, v27, v33, v25 bitop3:0x96
		v_lshl_add_u32 v27, v25, 4, v14
		ds_read_b128 a[24:27], v27 offset:2480
		v_add_u32_e32 v27, 4, v17
		v_add3_u32 v27, v27, v20, v22
		v_accvgpr_read_b32 v33, a18
		v_xor_b32_e32 v27, v27, v33
		v_lshrrev_b32_e32 v33, 6, v27
		v_add_u32_e32 v33, v33, v26
		v_and_b32_e32 v33, 1, v33
		v_lshlrev_b32_e32 v33, 2, v33
		v_lshrrev_b32_e32 v34, 5, v27
		v_and_b32_e32 v34, 1, v34
		v_lshlrev_b32_e32 v34, 1, v34
		v_add_u32_e32 v35, v32, v27
		v_lshrrev_b32_e32 v27, 4, v27
		v_bitop3_b32 v27, v35, v27, 1 bitop3:0x78
		v_bitop3_b32 v27, v33, v34, v27 bitop3:0x96
		v_lshl_add_u32 v33, v27, 4, v14
		ds_read_b128 a[28:31], v33 offset:2480
		v_add_u32_e32 v17, 6, v17
		v_add3_u32 v17, v17, v20, v22
		v_accvgpr_read_b32 v20, a18
		v_xor_b32_e32 v17, v17, v20
		v_lshrrev_b32_e32 v20, 6, v17
		v_add_u32_e32 v20, v20, v26
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v20, 2, v20
		v_lshrrev_b32_e32 v22, 5, v17
		v_and_b32_e32 v22, 1, v22
		v_lshlrev_b32_e32 v22, 1, v22
		v_add_u32_e32 v26, v32, v17
		v_lshrrev_b32_e32 v17, 4, v17
		v_bitop3_b32 v17, v26, v17, 1 bitop3:0x78
		v_bitop3_b32 v17, v20, v22, v17 bitop3:0x96
		v_lshl_add_u32 v14, v17, 4, v14
		ds_read_b128 a[32:35], v14 offset:2480
		v_accvgpr_read_b32 v14, a12
		v_lshl_add_u32 v14, v14, 3, 32
		v_xor_b32_e32 v9, v14, v9
		v_lshrrev_b32_e32 v14, 5, v9
		v_and_b32_e32 v14, 1, v14
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v8, v[48:51] offset:2480
		ds_write_b128 v8, v[52:55] offset:6576
		ds_write_b128 v8, v[28:31] offset:10672
		ds_write_b128 v8, v[56:59] offset:14768
		v_lshrrev_b32_e32 v8, 4, v9
		v_and_b32_e32 v8, 1, v8
		v_lshlrev_b32_e32 v8, 13, v8
		v_lshl_add_u32 v8, v14, 14, v8
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshrrev_b32_e32 v9, 3, v9
		v_and_b32_e32 v9, 1, v9
		v_lshl_add_u32 v8, v9, 12, v8
		v_lshl_add_u32 v9, v24, 4, v8
		ds_read_b128 a[36:39], v9 offset:51632
		v_lshl_add_u32 v9, v25, 4, v8
		ds_read_b128 a[40:43], v9 offset:51632
		v_lshl_add_u32 v9, v27, 4, v8
		ds_read_b128 a[44:47], v9 offset:51632
		v_lshl_add_u32 v8, v17, 4, v8
		ds_read_b128 a[48:51], v8 offset:51632
		v_readfirstlane_b32 s24, v7
		s_add_i32 s24, s24, 1
		s_mul_i32 s24, s24, 0x100
		v_readfirstlane_b32 s25, v4
		s_add_i32 s24, s24, s25
		s_cmp_lt_i32 s22, s24
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_cselect_b32 s24, s22, s24
		s_add_i32 s25, s24, 0x7f
		s_mov_b32 s36, 0x7f
		s_cmp_lt_i32 s25, 0
		s_cselect_b32 s37, s36, 0
		s_add_i32 s25, s25, s37
		s_ashr_i32 s25, s25, 7
		v_readfirstlane_b32 s37, v4
		s_add_i32 s37, s20, s37
		s_cmp_lt_i32 s37, 0
		s_cselect_b32 s38, s36, 0
		s_add_i32 s37, s37, s38
		s_ashr_i32 s37, s37, 7
		s_cmp_lt_i32 s37, s25
		s_cselect_b32 s37, s37, s25
		s_cmp_gt_i32 s37, 0
		s_cselect_b32 s37, s37, 0
		v_mov_b32_e32 v8, 64
		v_mul_lo_u32 v8, v8, v15
		v_mov_b32_e32 v9, 32
		v_mul_lo_u32 v9, v9, v18
		v_accvgpr_read_b32 v14, a9
		v_mov_b32_e32 v17, 16
		v_mul_lo_u32 v17, v17, v14
		v_bitop3_b32 v14, v8, v9, v17 bitop3:0x96
		v_mov_b32_e32 v18, 2
		v_mul_lo_u32 v18, v18, v23
		v_bitop3_b32 v14, v14, v21, v18 bitop3:0x96
		v_accvgpr_write_b32 a19, v14
		v_bitop3_b32 v14, 4, v8, v9 bitop3:0x96
		v_xor_b32_e32 v14, v14, v17
		v_bitop3_b32 v14, v14, v21, v18 bitop3:0x96
		v_accvgpr_write_b32 a52, v14
		v_bitop3_b32 v14, 8, v8, v9 bitop3:0x96
		v_xor_b32_e32 v14, v14, v17
		v_bitop3_b32 v14, v14, v21, v18 bitop3:0x96
		v_accvgpr_write_b32 a53, v14
		v_bitop3_b32 v8, 12, v8, v9 bitop3:0x96
		v_xor_b32_e32 v8, v8, v17
		v_bitop3_b32 v8, v8, v21, v18 bitop3:0x96
		v_accvgpr_write_b32 a54, v8
		v_accvgpr_read_b32 v8, a19
		v_cmp_lt_i32_e64 vcc, v8, s22
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v8, a52
		v_cmp_lt_i32_e64 vcc, v8, s22
		s_mov_b64 s[40:41], vcc
		v_accvgpr_read_b32 v8, a53
		v_cmp_lt_i32_e64 vcc, v8, s22
		s_mov_b64 s[42:43], vcc
		v_accvgpr_read_b32 v8, a54
		v_cmp_lt_i32_e64 vcc, v8, s22
		s_mov_b64 s[44:45], vcc
		v_mov_b32_e32 v8, 16
		v_mul_lo_u32 v8, v8, v15
		v_accvgpr_read_b32 v14, a9
		v_mov_b32_e32 v15, 64
		v_mul_lo_u32 v15, v15, v14
		v_bitop3_b32 v14, v8, v9, v15 bitop3:0x96
		v_bitop3_b32 v14, v14, v21, v18 bitop3:0x96
		v_accvgpr_write_b32 a55, v14
		v_bitop3_b32 v14, 4, v8, v9 bitop3:0x96
		v_xor_b32_e32 v14, v14, v15
		v_bitop3_b32 v14, v14, v21, v18 bitop3:0x96
		v_accvgpr_write_b32 a56, v14
		v_bitop3_b32 v14, 8, v8, v9 bitop3:0x96
		v_xor_b32_e32 v14, v14, v15
		v_bitop3_b32 v14, v14, v21, v18 bitop3:0x96
		v_accvgpr_write_b32 a57, v14
		v_bitop3_b32 v8, 12, v8, v9 bitop3:0x96
		v_accvgpr_read_b32 v9, a55
		v_cmp_lt_i32_e64 vcc, v9, s22
		s_mov_b64 s[46:47], vcc
		v_accvgpr_read_b32 v9, a56
		v_cmp_lt_i32_e64 vcc, v9, s22
		s_mov_b64 s[48:49], vcc
		v_accvgpr_read_b32 v9, a57
		v_cmp_lt_i32_e64 vcc, v9, s22
		s_mov_b64 s[50:51], vcc
		v_readfirstlane_b32 s52, v0
		v_accvgpr_read_b32 v9, a6
		v_lshlrev_b32_e32 v9, 1, v9
		v_accvgpr_read_b32 v14, a13
		v_lshlrev_b32_e32 v14, 5, v14
		v_accvgpr_write_b32 a58, v14
		v_accvgpr_read_b32 v14, a14
		v_accvgpr_read_b32 v17, a58
		v_lshl_add_u32 v14, v14, 6, v17
		v_lshlrev_b32_e32 v17, 4, v11
		v_accvgpr_write_b32 a59, v17
		v_accvgpr_read_b32 v17, a59
		v_xor_b32_e32 v14, v14, v17
		v_accvgpr_read_b32 v17, a12
		v_bitop3_b32 v14, v9, v17, v14 bitop3:0x96
		v_mul_lo_u32 v17, s15, v14
		v_accvgpr_read_b32 v20, a15
		v_lshlrev_b32_e32 v20, 4, v20
		v_lshl_add_u32 v17, v17, 1, v20
		v_accvgpr_read_b32 v22, a16
		v_lshlrev_b32_e32 v22, 6, v22
		v_accvgpr_read_b32 v23, a17
		v_lshlrev_b32_e32 v23, 5, v23
		v_add3_u32 v17, v17, v22, v23
		v_accvgpr_write_b32 a60, v17
		v_readfirstlane_b32 s53, v5
		s_mul_i32 s53, s53, s13
		s_lshl_b32 s53, s53, 1
		v_readfirstlane_b32 s54, v6
		s_mul_i32 s54, s54, s14
		s_lshl_b32 s54, s54, 1
		s_add_i32 s55, s53, s54
		v_accvgpr_read_b32 v17, a60
		v_add_u32_e32 v17, s55, v17
		v_mov_b32_e32 v24, 0x80000000
		v_cndmask_b32_e64 v17, v24, v17, s[38:39]
		s_lshr_b32 s38, s52, 6
		s_mul_i32 s39, 0x410, s38
		s_mov_b32 m0, s39
		v_xor_b32_e32 v8, v8, v15
		buffer_load_dwordx4 v17, s[28:31], 0 offen lds
		v_bitop3_b32 v8, v8, v21, v18 bitop3:0x96
		v_accvgpr_write_b32 a61, v8
		v_xor_b32_e32 v8, 4, v14
		v_mul_lo_u32 v15, s15, v8
		v_lshl_add_u32 v15, v15, 1, v20
		v_add3_u32 v15, v15, v22, v23
		v_accvgpr_write_b32 a62, v15
		v_accvgpr_read_b32 v15, a62
		v_add_u32_e32 v15, s55, v15
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v15, v24, v15, s[40:41]
		buffer_load_dwordx4 v15, s[28:31], 0 offen lds
		v_xor_b32_e32 v14, 8, v14
		v_mul_lo_u32 v14, s15, v14
		v_lshl_add_u32 v14, v14, 1, v20
		v_add3_u32 v14, v14, v22, v23
		v_accvgpr_write_b32 a63, v14
		v_accvgpr_read_b32 v14, a63
		v_add_u32_e32 v14, s55, v14
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v14, v24, v14, s[42:43]
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		v_xor_b32_e32 v8, 8, v8
		v_mul_lo_u32 v8, s15, v8
		v_lshl_add_u32 v8, v8, 1, v20
		v_add3_u32 v8, v8, v22, v23
		v_accvgpr_write_b32 a64, v8
		v_accvgpr_read_b32 v8, a64
		v_add_u32_e32 v8, s55, v8
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v8, v24, v8, s[44:45]
		buffer_load_dwordx4 v8, s[28:31], 0 offen lds
		v_accvgpr_read_b32 v8, a58
		v_lshl_add_u32 v8, v11, 6, v8
		v_accvgpr_read_b32 v14, a14
		v_lshl_add_u32 v8, v14, 4, v8
		v_accvgpr_read_b32 v14, a12
		v_bitop3_b32 v8, v9, v8, v14 bitop3:0x96
		v_mul_lo_u32 v9, s18, v8
		v_lshl_add_u32 v9, v9, 1, v20
		v_add3_u32 v9, v9, v22, v23
		v_accvgpr_write_b32 a65, v9
		v_accvgpr_read_b32 v9, a0
		s_nop 0
		v_readfirstlane_b32 s40, v9
		v_readfirstlane_b32 s41, v5
		s_mul_i32 s40, s41, s40
		s_lshl_b32 s40, s40, 1
		v_accvgpr_read_b32 v9, a1
		s_nop 0
		v_readfirstlane_b32 s41, v9
		v_readfirstlane_b32 s42, v6
		s_mul_i32 s41, s42, s41
		s_lshl_b32 s41, s41, 1
		s_add_i32 s42, s40, s41
		v_accvgpr_read_b32 v6, a65
		v_add_u32_e32 v6, s42, v6
		s_mul_i32 s38, 0x440, s38
		s_add_i32 m0, s38, 0x81f0
		v_cndmask_b32_e64 v6, v24, v6, s[46:47]
		buffer_load_dwordx4 v6, s[32:35], 0 offen lds
		v_xor_b32_e32 v6, 4, v8
		v_mul_lo_u32 v9, s18, v6
		v_lshl_add_u32 v9, v9, 1, v20
		v_add3_u32 v9, v9, v22, v23
		v_accvgpr_write_b32 a66, v9
		v_accvgpr_read_b32 v9, a66
		v_add_u32_e32 v9, s42, v9
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v9, v24, v9, s[48:49]
		buffer_load_dwordx4 v9, s[32:35], 0 offen lds
		v_xor_b32_e32 v8, 8, v8
		v_mul_lo_u32 v8, s18, v8
		v_lshl_add_u32 v8, v8, 1, v20
		v_add3_u32 v8, v8, v22, v23
		v_accvgpr_write_b32 a67, v8
		v_accvgpr_read_b32 v8, a67
		v_add_u32_e32 v8, s42, v8
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v8, v24, v8, s[50:51]
		buffer_load_dwordx4 v8, s[32:35], 0 offen lds
		v_xor_b32_e32 v6, 8, v6
		v_mul_lo_u32 v6, s18, v6
		v_lshl_add_u32 v6, v6, 1, v20
		v_add3_u32 v6, v6, v22, v23
		v_accvgpr_write_b32 a68, v6
		v_accvgpr_read_b32 v6, a61
		v_cmp_lt_i32_e64 vcc, v6, s22
		v_accvgpr_read_b32 v6, a68
		v_add_u32_e32 v6, s42, v6
		v_mbcnt_lo_u32_b32 v8, -1, 0
		v_cndmask_b32_e32 v6, v24, v6, vcc
		s_add_i32 m0, m0, 0x1100
		s_mul_i32 s42, s37, 0x80
		buffer_load_dwordx4 v6, s[32:35], 0 offen lds
		v_mbcnt_hi_u32_b32 v6, -1, v8
		v_and_b32_e32 v8, 1, v6
		v_lshrrev_b32_e32 v9, 4, v6
		v_and_b32_e32 v9, 1, v9
		v_lshlrev_b32_e32 v9, 4, v9
		v_lshrrev_b32_e32 v14, 3, v6
		v_and_b32_e32 v14, 1, v14
		v_lshlrev_b32_e32 v14, 3, v14
		v_add3_u32 v15, v8, v9, v14
		v_lshrrev_b32_e32 v17, 2, v6
		v_and_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v17, 2, v17
		v_lshrrev_b32_e32 v6, 1, v6
		v_and_b32_e32 v6, 1, v6
		v_lshlrev_b32_e32 v6, 1, v6
		v_add3_u32 v15, v15, v17, v6
		v_add_u32_e32 v8, 32, v8
		v_bitop3_b32 v6, v17, v8, v6 bitop3:0x96
		v_bitop3_b32 v6, v9, v14, v6 bitop3:0x96
		v_mov_b32_e32 v8, 0x3e38aa3b
		v_mov_b32_e32 v9, 0x3e38aa3b
		s_mov_b32 s37, 0xff800000
		v_mov_b32_e32 v14, s37
		v_mov_b32_e32 v17, s37
		s_mov_b32 s37, 1.0
		v_mov_b32_e32 v20, s37
		v_mov_b32_e32 v21, s37
		s_mov_b32 s37, 0
		v_accvgpr_read_b32 v18, a18
		v_lshlrev_b32_e32 v18, 4, v18
		v_accvgpr_write_b32 a69, v18
		v_and_b32_e32 v16, 31, v16
		v_lshrrev_b32_e32 v18, 4, v16
		v_lshlrev_b32_e32 v18, 9, v18
		v_accvgpr_write_b32 a70, v18
		v_lshrrev_b32_e32 v18, 3, v16
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v22, 0x2080
		v_mul_lo_u32 v22, v22, v18
		v_accvgpr_write_b32 a71, v22
		v_lshrrev_b32_e32 v18, 2, v16
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v22, 0x1040
		v_mul_lo_u32 v22, v22, v18
		v_accvgpr_write_b32 a72, v22
		v_lshrrev_b32_e32 v18, 1, v16
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v22, 0x820
		v_mul_lo_u32 v22, v22, v18
		v_accvgpr_write_b32 a73, v22
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v18, 0x410
		v_mul_lo_u32 v18, v18, v16
		v_accvgpr_write_b32 a74, v18
		v_and_b32_e32 v16, 3, v0
		v_accvgpr_write_b32 a75, v16
		v_accvgpr_read_b32 v16, a75
		v_lshlrev_b32_e32 v16, 3, v16
		v_accvgpr_write_b32 a76, v16
		v_mov_b32_e32 v16, 0x2200
		v_mul_lo_u32 v16, v16, v11
		v_accvgpr_write_b32 a77, v16
		v_and_b32_e32 v10, 3, v10
		v_mov_b32_e32 v11, 0x440
		v_mul_lo_u32 v11, v11, v10
		v_accvgpr_write_b32 a78, v11
		s_lshl_b32 s43, s15, 8
		s_add_i32 s43, s43, s53
		s_add_i32 s43, s43, s54
		s_lshl_b32 s44, s18, 8
		s_add_i32 s40, s44, s40
		s_add_i32 s40, s40, s41
		v_lshlrev_b32_e32 v10, 2, v15
		v_accvgpr_write_b32 a79, v10
		v_lshlrev_b32_e32 v6, 2, v6
		v_accvgpr_write_b32 a80, v6
		s_cmp_lt_i32 0, s42
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
		s_lshr_b32 s41, s37, 7
		s_and_b32 s44, s41, 1
		s_mul_i32 s45, 0x4100, s44
		v_accvgpr_read_b32 v6, a69
		v_accvgpr_read_b32 v10, a70
		v_add3_u32 v6, s45, v6, v10
		v_accvgpr_read_b32 v10, a71
		v_accvgpr_read_b32 v11, a72
		v_add3_u32 v6, v6, v10, v11
		v_accvgpr_read_b32 v10, a73
		v_accvgpr_read_b32 v11, a74
		v_add3_u32 v6, v6, v10, v11
		ds_read_b128 v[28:31], v6
		ds_read_b128 a[84:87], v6 offset:32
		ds_read_b128 a[88:91], v6 offset:64
		ds_read_b128 a[92:95], v6 offset:96
		ds_read_b128 v[96:99], v6 offset:256
		ds_read_b128 a[96:99], v6 offset:288
		ds_read_b128 a[100:103], v6 offset:320
		ds_read_b128 a[104:107], v6 offset:352
		ds_read_b128 a[108:111], v6 offset:128
		ds_read_b128 a[112:115], v6 offset:160
		ds_read_b128 a[116:119], v6 offset:192
		ds_read_b128 a[120:123], v6 offset:224
		ds_read_b128 v[100:103], v6 offset:384
		ds_read_b128 a[124:127], v6 offset:416
		ds_read_b128 a[128:131], v6 offset:448
		ds_read_b128 a[132:135], v6 offset:480
		s_mul_i32 s44, 0x4400, s44
		v_accvgpr_read_b32 v6, a76
		v_accvgpr_read_b32 v10, a77
		v_add3_u32 v6, s44, v6, v10
		v_accvgpr_read_b32 v10, a78
		v_accvgpr_read_b32 v11, a58
		v_add3_u32 v6, v6, v11, v10
		ds_read_b64_tr_b16 a[136:137], v6 offset:33264
		ds_read_b64_tr_b16 a[138:139], v6 offset:37616
		ds_read_b64_tr_b16 a[140:141], v6 offset:33392
		ds_read_b64_tr_b16 a[142:143], v6 offset:37744
		ds_read_b64_tr_b16 a[144:145], v6 offset:33520
		ds_read_b64_tr_b16 a[146:147], v6 offset:37872
		ds_read_b64_tr_b16 a[148:149], v6 offset:33648
		ds_read_b64_tr_b16 a[150:151], v6 offset:38000
		ds_read_b64_tr_b16 a[152:153], v6 offset:33776
		ds_read_b64_tr_b16 a[154:155], v6 offset:38128
		ds_read_b64_tr_b16 a[156:157], v6 offset:33904
		ds_read_b64_tr_b16 a[158:159], v6 offset:38256
		ds_read_b64_tr_b16 a[160:161], v6 offset:34032
		ds_read_b64_tr_b16 a[162:163], v6 offset:38384
		ds_read_b64_tr_b16 a[164:165], v6 offset:34160
		ds_read_b64_tr_b16 a[166:167], v6 offset:38512
		ds_read_b64_tr_b16 a[168:169], v6 offset:33328
		ds_read_b64_tr_b16 a[170:171], v6 offset:37680
		ds_read_b64_tr_b16 a[172:173], v6 offset:33456
		ds_read_b64_tr_b16 a[174:175], v6 offset:37808
		ds_read_b64_tr_b16 a[176:177], v6 offset:33584
		ds_read_b64_tr_b16 a[178:179], v6 offset:37936
		ds_read_b64_tr_b16 a[180:181], v6 offset:33712
		ds_read_b64_tr_b16 a[182:183], v6 offset:38064
		ds_read_b64_tr_b16 a[184:185], v6 offset:33840
		ds_read_b64_tr_b16 a[186:187], v6 offset:38192
		ds_read_b64_tr_b16 a[188:189], v6 offset:33968
		ds_read_b64_tr_b16 a[190:191], v6 offset:38320
		ds_read_b64_tr_b16 a[192:193], v6 offset:34096
		ds_read_b64_tr_b16 a[194:195], v6 offset:38448
		ds_read_b64_tr_b16 a[196:197], v6 offset:34224
		ds_read_b64_tr_b16 a[198:199], v6 offset:38576
		s_mul_i32 s44, s15, s37
		s_lshl_b32 s44, s44, 1
		s_add_i32 s44, s43, s44
		v_accvgpr_read_b32 v6, a60
		v_add_u32_e32 v6, s44, v6
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v10, a62
		v_add_u32_e32 v10, s44, v10
		s_add_i32 s41, s41, 1
		v_accvgpr_read_b32 v11, a63
		v_add_u32_e32 v11, s44, v11
		s_and_b32 s41, s41, 1
		v_accvgpr_read_b32 v15, a64
		v_add_u32_e32 v15, s44, v15
		s_mul_i32 s44, 0x4100, s41
		v_mfma_f32_32x32x16_bf16 v[112:127], v[28:31], a[20:23], 0
		s_add_i32 s44, s39, s44
		v_mfma_f32_32x32x16_bf16 v[128:143], v[96:99], a[20:23], 0
		s_mov_b32 m0, s44
		v_mfma_f32_32x32x16_bf16 v[144:159], a[108:111], a[20:23], 0
		s_mul_i32 s44, s18, s37
		v_mfma_f32_32x32x16_bf16 v[160:175], v[100:103], a[20:23], 0
		s_add_i32 s37, s37, 0x80
		v_mfma_f32_32x32x16_bf16 v[176:191], v[100:103], a[36:39], 0
		v_accvgpr_read_b32 v16, a19
		v_add_u32_e32 v16, s37, v16
		v_mfma_f32_32x32x16_bf16 v[192:207], v[28:31], a[36:39], 0
		v_accvgpr_read_b32 v18, a52
		v_add_u32_e32 v18, s37, v18
		v_mfma_f32_32x32x16_bf16 v[208:223], v[96:99], a[36:39], 0
		v_accvgpr_read_b32 v22, a53
		v_add_u32_e32 v22, s37, v22
		v_mfma_f32_32x32x16_bf16 v[96:111], a[108:111], a[36:39], 0
		v_accvgpr_read_b32 v23, a54
		v_add_u32_e32 v23, s37, v23
		v_mfma_f32_32x32x16_bf16 v[112:127], a[84:87], a[24:27], v[112:127]
		v_cmp_lt_i32_e64 vcc, v16, s22
		s_mov_b64 s[46:47], vcc
		v_mfma_f32_32x32x16_bf16 v[128:143], a[96:99], a[24:27], v[128:143]
		v_cmp_lt_i32_e64 vcc, v18, s22
		s_mov_b64 s[48:49], vcc
		v_mfma_f32_32x32x16_bf16 v[144:159], a[112:115], a[24:27], v[144:159]
		v_cmp_lt_i32_e64 vcc, v22, s22
		s_mov_b64 s[50:51], vcc
		v_mfma_f32_32x32x16_bf16 v[160:175], a[124:127], a[24:27], v[160:175]
		v_cmp_lt_i32_e64 vcc, v23, s22
		s_mov_b64 s[54:55], vcc
		v_mfma_f32_32x32x16_bf16 v[176:191], a[124:127], a[40:43], v[176:191]
		v_accvgpr_read_b32 v16, a55
		v_add_u32_e32 v16, s37, v16
		v_mfma_f32_32x32x16_bf16 v[192:207], a[84:87], a[40:43], v[192:207]
		v_accvgpr_read_b32 v18, a56
		v_add_u32_e32 v18, s37, v18
		v_mfma_f32_32x32x16_bf16 v[208:223], a[96:99], a[40:43], v[208:223]
		v_accvgpr_read_b32 v22, a57
		v_add_u32_e32 v22, s37, v22
		v_mfma_f32_32x32x16_bf16 v[96:111], a[112:115], a[40:43], v[96:111]
		v_cmp_lt_i32_e64 vcc, v16, s22
		s_mov_b64 s[56:57], vcc
		v_mfma_f32_32x32x16_bf16 v[112:127], a[88:91], a[28:31], v[112:127]
		v_cmp_lt_i32_e64 vcc, v18, s22
		s_mov_b64 s[58:59], vcc
		v_mfma_f32_32x32x16_bf16 v[128:143], a[100:103], a[28:31], v[128:143]
		v_cmp_lt_i32_e64 vcc, v22, s22
		s_mov_b64 s[60:61], vcc
		v_mfma_f32_32x32x16_bf16 v[144:159], a[116:119], a[28:31], v[144:159]
		v_cndmask_b32_e64 v6, v24, v6, s[46:47]
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[160:175], a[128:131], a[28:31], v[160:175]
		v_accvgpr_read_b32 v6, a61
		v_add_u32_e32 v6, s37, v6
		v_cndmask_b32_e64 v10, v24, v10, s[48:49]
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v11, v24, v11, s[50:51]
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		v_cndmask_b32_e64 v10, v24, v15, s[54:55]
		v_cmp_lt_i32_e64 vcc, v6, s22
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s44, s44, 1
		s_add_i32 s44, s40, s44
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		v_accvgpr_read_b32 v6, a65
		v_add_u32_e32 v6, s44, v6
		v_cndmask_b32_e64 v6, v24, v6, s[56:57]
		s_add_i32 m0, m0, 0x1040
		s_mul_i32 s41, 0x4400, s41
		s_add_i32 s41, s38, s41
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		v_accvgpr_read_b32 v10, a66
		v_add_u32_e32 v10, s44, v10
		v_cndmask_b32_e64 v10, v24, v10, s[58:59]
		s_add_i32 m0, s41, 0x81f0
		v_accvgpr_read_b32 v11, a67
		v_add_u32_e32 v11, s44, v11
		v_cndmask_b32_e64 v11, v24, v11, s[60:61]
		buffer_load_dwordx4 v6, s[32:35], 0 offen lds
		v_accvgpr_read_b32 v6, a68
		v_add_u32_e32 v6, s44, v6
		v_cndmask_b32_e32 v6, v24, v6, vcc
		s_add_i32 m0, m0, 0x1100
		v_mfma_f32_32x32x16_bf16 v[176:191], a[128:131], a[44:47], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[88:91], a[44:47], v[192:207]
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[208:223], a[100:103], a[44:47], v[208:223]
		s_add_i32 m0, m0, 0x1100
		v_mfma_f32_32x32x16_bf16 v[96:111], a[116:119], a[44:47], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[92:95], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[104:107], a[32:35], v[128:143]
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[144:159], a[120:123], a[32:35], v[144:159]
		s_add_i32 m0, m0, 0x1100
		s_cmp_lt_i32 s37, s42
		v_mfma_f32_32x32x16_bf16 v[160:175], a[132:135], a[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[132:135], a[48:51], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[92:95], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[104:107], a[48:51], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[120:123], a[48:51], v[96:111]
		buffer_load_dwordx4 v6, s[32:35], 0 offen lds
		s_nop 0
		v_max3_f32 v6, v112, v113, v114
		v_max3_f32 v10, v116, v117, v118
		v_max3_f32 v11, v120, v121, v122
		v_max3_f32 v15, v124, v125, v126
		v_max3_f32 v16, v128, v129, v130
		v_max3_f32 v18, v132, v133, v134
		v_max3_f32 v22, v136, v137, v138
		v_max3_f32 v23, v140, v141, v142
		v_max3_f32 v25, v144, v145, v146
		v_max3_f32 v26, v148, v149, v150
		v_max3_f32 v27, v152, v153, v154
		v_max3_f32 v28, v156, v157, v158
		v_max3_f32 v29, v160, v161, v162
		v_max3_f32 v30, v164, v165, v166
		v_max3_f32 v31, v168, v169, v170
		v_max3_f32 v224, v172, v173, v174
		v_max3_f32 v6, v6, v115, v10
		v_max3_f32 v10, v11, v123, v15
		v_max3_f32 v11, v16, v131, v18
		v_max3_f32 v15, v22, v139, v23
		v_max3_f32 v16, v25, v147, v26
		v_max3_f32 v18, v27, v155, v28
		v_max3_f32 v22, v29, v163, v30
		v_max3_f32 v23, v31, v171, v224
		v_max3_f32 v6, v6, v119, v10
		v_max3_f32 v10, v11, v135, v15
		v_max3_f32 v11, v16, v151, v18
		v_max3_f32 v15, v22, v167, v23
		v_max3_f32 v6, v6, v127, v10
		v_max3_f32 v10, v11, v159, v15
		v_max3_f32 v6, v6, v143, v10
		v_max_f32_e32 v6, v6, v175
		v_mov_b32_e32 v10, v6
		v_mov_b32_e32 v11, v6
		s_nop 1
		v_permlane32_swap_b32_e32 v10, v11
		v_max_f32_e32 v22, v10, v11
		v_max3_f32 v6, v192, v193, v194
		v_max3_f32 v10, v196, v197, v198
		v_max3_f32 v11, v200, v201, v202
		v_max3_f32 v15, v204, v205, v206
		v_max3_f32 v16, v208, v209, v210
		v_max3_f32 v18, v212, v213, v214
		v_max3_f32 v23, v216, v217, v218
		v_max3_f32 v25, v220, v221, v222
		v_max3_f32 v26, v96, v97, v98
		v_max3_f32 v27, v100, v101, v102
		v_max3_f32 v28, v104, v105, v106
		v_max3_f32 v29, v108, v109, v110
		v_max3_f32 v30, v176, v177, v178
		v_max3_f32 v31, v180, v181, v182
		v_max3_f32 v224, v184, v185, v186
		v_max3_f32 v225, v188, v189, v190
		v_max3_f32 v6, v6, v195, v10
		v_max3_f32 v10, v11, v203, v15
		v_max3_f32 v11, v16, v211, v18
		v_max3_f32 v15, v23, v219, v25
		v_max3_f32 v16, v26, v99, v27
		v_max3_f32 v18, v28, v107, v29
		v_max3_f32 v23, v30, v179, v31
		v_max3_f32 v25, v224, v187, v225
		v_max3_f32 v6, v6, v199, v10
		v_max3_f32 v10, v11, v215, v15
		v_max3_f32 v11, v16, v103, v18
		v_max3_f32 v15, v23, v183, v25
		v_max3_f32 v6, v6, v207, v10
		v_max3_f32 v10, v11, v111, v15
		v_max3_f32 v6, v6, v223, v10
		v_max_f32_e32 v6, v6, v191
		v_mov_b32_e32 v10, v6
		v_mov_b32_e32 v11, v6
		s_nop 1
		v_permlane32_swap_b32_e32 v10, v11
		v_max_f32_e32 v23, v10, v11
		v_pk_mul_f32 v[10:11], v[22:23], v[8:9]
		v_max_f32_e32 v22, v14, v10
		v_max_f32_e32 v23, v17, v11
		v_pk_fma_f32 v[10:11], v[112:113], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[114:115], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[116:117], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[118:119], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[120:121], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[122:123], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[124:125], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[126:127], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[128:129], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[130:131], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[132:133], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[134:135], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[136:137], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[138:139], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[140:141], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[142:143], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[144:145], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[146:147], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[148:149], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[150:151], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[152:153], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[154:155], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[156:157], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[158:159], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[160:161], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[162:163], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[164:165], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[166:167], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[168:169], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[170:171], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[172:173], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[174:175], v[8:9], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[192:193], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[194:195], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[196:197], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[198:199], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[200:201], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[202:203], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[204:205], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[206:207], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[208:209], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[210:211], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[212:213], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[214:215], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[216:217], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[218:219], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[220:221], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[222:223], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[96:97], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[98:99], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[108:109], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[110:111], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[176:177], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[178:179], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[180:181], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[182:183], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[184:185], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[186:187], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[188:189], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[190:191], v[8:9], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v190, v10
		v_exp_f32_e32 v218, v11
		v_exp_f32_e32 v191, v26
		v_exp_f32_e32 v219, v27
		v_exp_f32_e32 v10, v28
		v_exp_f32_e32 v26, v29
		v_exp_f32_e32 v11, v30
		v_exp_f32_e32 v27, v31
		v_exp_f32_e32 v28, v112
		v_exp_f32_e32 v30, v113
		v_exp_f32_e32 v29, v114
		v_exp_f32_e32 v31, v115
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
		v_exp_f32_e32 v165, v168
		v_exp_f32_e32 v167, v169
		v_exp_f32_e32 v168, v170
		v_exp_f32_e32 v220, v171
		v_exp_f32_e32 v169, v172
		v_exp_f32_e32 v221, v173
		v_exp_f32_e32 v170, v174
		v_exp_f32_e32 v172, v175
		v_exp_f32_e32 v171, v192
		v_exp_f32_e32 v173, v193
		v_exp_f32_e32 v174, v194
		v_exp_f32_e32 v192, v195
		v_exp_f32_e32 v175, v196
		v_exp_f32_e32 v193, v197
		v_exp_f32_e32 v194, v198
		v_exp_f32_e32 v196, v199
		v_exp_f32_e32 v195, v200
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
		v_exp_f32_e32 v207, v212
		v_exp_f32_e32 v209, v213
		v_exp_f32_e32 v210, v214
		v_exp_f32_e32 v212, v215
		v_exp_f32_e32 v211, v216
		v_exp_f32_e32 v213, v217
		v_exp_f32_e32 v214, v96
		v_exp_f32_e32 v216, v97
		v_exp_f32_e32 v215, v98
		v_exp_f32_e32 v217, v99
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
		v_exp_f32_e32 v108, v176
		v_exp_f32_e32 v110, v177
		v_exp_f32_e32 v109, v178
		v_exp_f32_e32 v111, v179
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
		v_pk_add_f32 v[188:189], v[190:191], v[218:219]
		v_pk_add_f32 v[222:223], v[10:11], v[26:27]
		v_pk_add_f32 v[224:225], v[28:29], v[30:31]
		v_pk_add_f32 v[226:227], v[112:113], v[114:115]
		v_pk_add_f32 v[228:229], v[116:117], v[118:119]
		v_pk_add_f32 v[230:231], v[120:121], v[122:123]
		v_pk_add_f32 v[232:233], v[124:125], v[126:127]
		v_pk_add_f32 v[234:235], v[128:129], v[130:131]
		v_pk_add_f32 v[236:237], v[132:133], v[134:135]
		v_pk_add_f32 v[238:239], v[136:137], v[138:139]
		v_pk_add_f32 v[240:241], v[140:141], v[142:143]
		v_pk_add_f32 v[242:243], v[144:145], v[146:147]
		v_pk_add_f32 v[244:245], v[148:149], v[150:151]
		v_pk_add_f32 v[246:247], v[152:153], v[154:155]
		v_pk_add_f32 v[248:249], v[156:157], v[158:159]
		v_pk_add_f32 v[250:251], v[160:161], v[162:163]
		v_mov_b32_e32 v252, v189
		v_mov_b32_e32 v253, v223
		v_mov_b32_e32 v254, v188
		v_mov_b32_e32 v255, v222
		v_pk_add_f32 v[188:189], v[254:255], v[252:253]
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
		v_mov_b32_e32 v222, v189
		v_mov_b32_e32 v223, v225
		v_mov_b32_e32 v226, v188
		v_mov_b32_e32 v227, v224
		v_pk_add_f32 v[188:189], v[226:227], v[222:223]
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
		v_mov_b32_e32 v222, v189
		v_mov_b32_e32 v223, v227
		v_mov_b32_e32 v224, v188
		v_mov_b32_e32 v225, v226
		v_pk_add_f32 v[188:189], v[224:225], v[222:223]
		v_mov_b32_e32 v222, v229
		v_mov_b32_e32 v223, v231
		v_mov_b32_e32 v224, v228
		v_mov_b32_e32 v225, v230
		v_pk_add_f32 v[226:227], v[224:225], v[222:223]
		v_mov_b32_e32 v222, v189
		v_mov_b32_e32 v223, v227
		v_mov_b32_e32 v224, v188
		v_mov_b32_e32 v225, v226
		v_pk_add_f32 v[188:189], v[224:225], v[222:223]
		v_add_f32_e32 v6, v188, v189
		v_accvgpr_read_b32 v15, a79
		ds_bpermute_b32 v164, v15, v6
		v_accvgpr_read_b32 v15, a80
		ds_bpermute_b32 v166, v15, v6
		v_pk_add_f32 v[188:189], v[168:169], v[220:221]
		v_pk_add_f32 v[222:223], v[170:171], v[172:173]
		v_pk_add_f32 v[224:225], v[174:175], v[192:193]
		v_pk_add_f32 v[226:227], v[194:195], v[196:197]
		v_pk_add_f32 v[228:229], v[198:199], v[200:201]
		v_pk_add_f32 v[230:231], v[202:203], v[204:205]
		v_pk_add_f32 v[232:233], v[206:207], v[208:209]
		v_pk_add_f32 v[234:235], v[210:211], v[212:213]
		v_pk_add_f32 v[236:237], v[214:215], v[216:217]
		v_pk_add_f32 v[238:239], v[96:97], v[98:99]
		v_pk_add_f32 v[240:241], v[100:101], v[102:103]
		v_pk_add_f32 v[242:243], v[104:105], v[106:107]
		v_pk_add_f32 v[244:245], v[108:109], v[110:111]
		v_pk_add_f32 v[246:247], v[176:177], v[178:179]
		v_pk_add_f32 v[248:249], v[180:181], v[182:183]
		v_mov_b32_e32 v250, v189
		v_mov_b32_e32 v251, v224
		v_pk_add_f32 v[252:253], v[250:251], v[222:223]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[222:223], v[164:165], v[166:167]
		v_mov_b32_e32 v185, v223
		v_mov_b32_e32 v187, v188
		v_pk_add_f32 v[188:189], v[184:185], v[186:187]
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
		v_pk_add_f32 v[188:189], v[234:235], v[188:189]
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
		v_pk_add_f32 v[188:189], v[226:227], v[188:189]
		v_mov_b32_e32 v226, v239
		v_mov_b32_e32 v227, v228
		v_pk_add_f32 v[230:231], v[226:227], v[224:225]
		v_mov_b32_e32 v224, v229
		v_mov_b32_e32 v225, v230
		v_pk_add_f32 v[226:227], v[224:225], v[188:189]
		v_add_f32_e32 v6, v231, v226
		v_add_f32_e32 v6, v227, v6
		v_mov_b32_e32 v188, v6
		v_mov_b32_e32 v189, v6
		s_nop 1
		v_permlane32_swap_b32_e32 v188, v189
		v_add_f32_e32 v225, v188, v189
		v_sub_f32_e32 v6, v14, v22
		v_sub_f32_e32 v14, v17, v23
		v_exp_f32_e32 v16, v6
		v_exp_f32_e32 v188, v14
		v_mov_b32_e32 v17, v16
		v_pk_mul_f32 v[32:33], v[32:33], v[16:17]
		v_pk_mul_f32 v[34:35], v[34:35], v[16:17]
		v_pk_mul_f32 v[36:37], v[36:37], v[16:17]
		v_pk_mul_f32 v[38:39], v[38:39], v[16:17]
		v_pk_mul_f32 v[40:41], v[40:41], v[16:17]
		v_pk_mul_f32 v[42:43], v[42:43], v[16:17]
		v_pk_mul_f32 v[44:45], v[44:45], v[16:17]
		v_pk_mul_f32 v[46:47], v[46:47], v[16:17]
		v_pk_mul_f32 v[48:49], v[48:49], v[16:17]
		v_pk_mul_f32 v[50:51], v[50:51], v[16:17]
		v_pk_mul_f32 v[52:53], v[52:53], v[16:17]
		v_pk_mul_f32 v[54:55], v[54:55], v[16:17]
		v_pk_mul_f32 v[56:57], v[56:57], v[16:17]
		v_pk_mul_f32 v[58:59], v[58:59], v[16:17]
		v_pk_mul_f32 v[60:61], v[60:61], v[16:17]
		v_pk_mul_f32 v[62:63], v[62:63], v[16:17]
		v_mov_b32_e32 v189, v188
		v_pk_mul_f32 v[64:65], v[64:65], v[188:189]
		v_pk_mul_f32 v[66:67], v[66:67], v[188:189]
		v_pk_mul_f32 v[68:69], v[68:69], v[188:189]
		v_pk_mul_f32 v[70:71], v[70:71], v[188:189]
		v_pk_mul_f32 v[72:73], v[72:73], v[188:189]
		v_pk_mul_f32 v[74:75], v[74:75], v[188:189]
		v_pk_mul_f32 v[76:77], v[76:77], v[188:189]
		v_pk_mul_f32 v[78:79], v[78:79], v[188:189]
		v_pk_mul_f32 v[80:81], v[80:81], v[188:189]
		v_pk_mul_f32 v[82:83], v[82:83], v[188:189]
		v_pk_mul_f32 v[84:85], v[84:85], v[188:189]
		v_pk_mul_f32 v[86:87], v[86:87], v[188:189]
		v_pk_mul_f32 v[88:89], v[88:89], v[188:189]
		v_pk_mul_f32 v[90:91], v[90:91], v[188:189]
		v_pk_mul_f32 v[92:93], v[92:93], v[188:189]
		v_pk_mul_f32 v[94:95], v[94:95], v[188:189]
		v_mov_b32_e32 v14, v16
		v_mov_b32_e32 v15, v188
		v_mov_b32_e32 v224, v222
		v_mov_b64_e32 v[16:17], v[20:21]
		v_pk_fma_f32 v[20:21], v[16:17], v[14:15], v[224:225]
		v_cvt_pk_bf16_f32 v224, v190, v218
		v_cvt_pk_bf16_f32 v225, v191, v219
		v_cvt_pk_bf16_f32 v226, v10, v26
		v_cvt_pk_bf16_f32 v227, v11, v27
		v_cvt_pk_bf16_f32 v188, v28, v30
		v_cvt_pk_bf16_f32 v189, v29, v31
		v_cvt_pk_bf16_f32 v190, v112, v114
		v_cvt_pk_bf16_f32 v191, v113, v115
		v_cvt_pk_bf16_f32 v28, v116, v118
		v_cvt_pk_bf16_f32 v29, v117, v119
		v_cvt_pk_bf16_f32 v30, v120, v122
		v_cvt_pk_bf16_f32 v31, v121, v123
		v_cvt_pk_bf16_f32 v112, v124, v126
		v_cvt_pk_bf16_f32 v113, v125, v127
		v_cvt_pk_bf16_f32 v114, v128, v130
		v_cvt_pk_bf16_f32 v115, v129, v131
		v_cvt_pk_bf16_f32 v116, v132, v134
		v_cvt_pk_bf16_f32 v117, v133, v135
		v_cvt_pk_bf16_f32 v118, v136, v138
		v_cvt_pk_bf16_f32 v119, v137, v139
		v_cvt_pk_bf16_f32 v120, v140, v142
		v_cvt_pk_bf16_f32 v121, v141, v143
		v_cvt_pk_bf16_f32 v122, v144, v146
		v_cvt_pk_bf16_f32 v123, v145, v147
		v_cvt_pk_bf16_f32 v124, v148, v150
		v_cvt_pk_bf16_f32 v125, v149, v151
		v_cvt_pk_bf16_f32 v126, v152, v154
		v_cvt_pk_bf16_f32 v127, v153, v155
		v_cvt_pk_bf16_f32 v128, v156, v158
		v_cvt_pk_bf16_f32 v129, v157, v159
		v_cvt_pk_bf16_f32 v130, v160, v162
		v_cvt_pk_bf16_f32 v131, v161, v163
		v_cvt_pk_bf16_f32 v132, v165, v167
		v_cvt_pk_bf16_f32 v133, v168, v220
		v_cvt_pk_bf16_f32 v134, v169, v221
		v_cvt_pk_bf16_f32 v135, v170, v172
		v_cvt_pk_bf16_f32 v136, v171, v173
		v_cvt_pk_bf16_f32 v137, v174, v192
		v_cvt_pk_bf16_f32 v138, v175, v193
		v_cvt_pk_bf16_f32 v139, v194, v196
		v_cvt_pk_bf16_f32 v140, v195, v197
		v_cvt_pk_bf16_f32 v141, v198, v200
		v_cvt_pk_bf16_f32 v142, v199, v201
		v_cvt_pk_bf16_f32 v143, v202, v204
		v_cvt_pk_bf16_f32 v144, v203, v205
		v_cvt_pk_bf16_f32 v145, v206, v208
		v_cvt_pk_bf16_f32 v146, v207, v209
		v_cvt_pk_bf16_f32 v147, v210, v212
		v_cvt_pk_bf16_f32 v148, v211, v213
		v_cvt_pk_bf16_f32 v149, v214, v216
		v_cvt_pk_bf16_f32 v150, v215, v217
		v_cvt_pk_bf16_f32 v151, v96, v98
		v_cvt_pk_bf16_f32 v152, v97, v99
		v_cvt_pk_bf16_f32 v153, v100, v102
		v_cvt_pk_bf16_f32 v154, v101, v103
		v_cvt_pk_bf16_f32 v155, v104, v106
		v_cvt_pk_bf16_f32 v96, v105, v107
		v_cvt_pk_bf16_f32 v97, v108, v110
		v_cvt_pk_bf16_f32 v98, v109, v111
		v_cvt_pk_bf16_f32 v99, v176, v178
		v_cvt_pk_bf16_f32 v100, v177, v179
		v_cvt_pk_bf16_f32 v101, v180, v182
		v_cvt_pk_bf16_f32 v102, v181, v183
		v_cvt_pk_bf16_f32 v103, v184, v186
		v_permlane32_swap_b32_e32 v224, v226
		v_permlane32_swap_b32_e32 v225, v227
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[32:47], a[136:139], v[224:227], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[168:171], v[224:227], v[48:63]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[32:47], a[140:143], v[188:191], v[32:47]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[48:63], a[172:175], v[188:191], v[48:63]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[32:47], a[144:147], v[28:31], v[32:47]
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_mfma_f32_32x32x16_bf16 v[48:63], a[176:179], v[28:31], v[48:63]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[32:47], a[148:151], v[112:115], v[32:47]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[48:63], a[180:183], v[112:115], v[48:63]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[32:47], a[152:155], v[116:119], v[32:47]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[80:95], a[168:171], v[132:135], v[80:95]
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_mfma_f32_32x32x16_bf16 v[64:79], a[136:139], v[132:135], v[64:79]
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_mfma_f32_32x32x16_bf16 v[80:95], a[172:175], v[136:139], v[80:95]
		v_permlane32_swap_b32_e32 v148, v150
		v_permlane32_swap_b32_e32 v149, v151
		v_mfma_f32_32x32x16_bf16 v[64:79], a[140:143], v[136:139], v[64:79]
		v_permlane32_swap_b32_e32 v152, v154
		v_permlane32_swap_b32_e32 v153, v155
		v_mfma_f32_32x32x16_bf16 v[80:95], a[176:179], v[140:143], v[80:95]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[64:79], a[144:147], v[140:143], v[64:79]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[80:95], a[180:183], v[144:147], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[148:151], v[144:147], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[184:187], v[116:119], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[184:187], v[148:151], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[152:155], v[148:151], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[156:159], v[120:123], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[188:191], v[120:123], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[188:191], v[152:155], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[156:159], v[152:155], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[160:163], v[124:127], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[192:195], v[124:127], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[192:195], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[160:163], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[164:167], v[128:131], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[196:199], v[128:131], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[196:199], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[164:167], v[100:103], v[64:79]
		v_mov_b32_e32 v14, v22
		v_mov_b32_e32 v17, v23
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_1
.L_attn_fwd_persistent.loop_exit_1:
		s_mul_i32 s25, s25, 0x80
		v_accvgpr_read_b32 v6, a7
		v_readfirstlane_b32 s37, v4
		s_nop 1
		v_add_u32_e32 v6, s37, v6
		v_add_u32_e32 v6, s20, v6
		v_accvgpr_read_b32 v8, a8
		v_readfirstlane_b32 s37, v4
		s_nop 1
		v_add_u32_e32 v8, s37, v8
		v_add_u32_e32 v8, s20, v8
		v_xor_b32_e32 v9, 1, v19
		v_accvgpr_write_b32 a7, v9
		v_xor_b32_e32 v9, 2, v19
		v_accvgpr_write_b32 a8, v9
		v_xor_b32_e32 v9, 3, v19
		v_accvgpr_write_b32 a69, v9
		v_xor_b32_e32 v9, 8, v19
		v_accvgpr_write_b32 a76, v9
		v_xor_b32_e32 v9, 9, v19
		v_accvgpr_write_b32 a81, v9
		v_xor_b32_e32 v9, 10, v19
		v_accvgpr_write_b32 a82, v9
		v_xor_b32_e32 v9, 11, v19
		v_accvgpr_write_b32 a83, v9
		v_xor_b32_e32 v9, 16, v19
		v_accvgpr_write_b32 a84, v9
		v_xor_b32_e32 v9, 17, v19
		v_accvgpr_write_b32 a85, v9
		v_xor_b32_e32 v9, 18, v19
		v_accvgpr_write_b32 a86, v9
		v_xor_b32_e32 v9, 19, v19
		v_accvgpr_write_b32 a87, v9
		v_xor_b32_e32 v9, 24, v19
		v_accvgpr_write_b32 a88, v9
		v_xor_b32_e32 v9, 25, v19
		v_accvgpr_write_b32 a89, v9
		v_xor_b32_e32 v9, 26, v19
		v_accvgpr_write_b32 a90, v9
		v_xor_b32_e32 v9, 27, v19
		v_accvgpr_write_b32 a91, v9
		v_xor_b32_e32 v9, 32, v19
		v_accvgpr_write_b32 a92, v9
		v_xor_b32_e32 v9, 33, v19
		v_accvgpr_write_b32 a93, v9
		v_xor_b32_e32 v9, 34, v19
		v_accvgpr_write_b32 a94, v9
		v_xor_b32_e32 v9, 35, v19
		v_accvgpr_write_b32 a95, v9
		v_xor_b32_e32 v9, 40, v19
		v_accvgpr_write_b32 a96, v9
		v_xor_b32_e32 v9, 41, v19
		v_accvgpr_write_b32 a97, v9
		v_xor_b32_e32 v9, 42, v19
		v_accvgpr_write_b32 a98, v9
		v_xor_b32_e32 v9, 43, v19
		v_accvgpr_write_b32 a99, v9
		v_xor_b32_e32 v9, 48, v19
		v_accvgpr_write_b32 a100, v9
		v_xor_b32_e32 v9, 49, v19
		v_accvgpr_write_b32 a101, v9
		v_xor_b32_e32 v9, 50, v19
		v_accvgpr_write_b32 a102, v9
		v_xor_b32_e32 v9, 51, v19
		v_accvgpr_write_b32 a103, v9
		v_xor_b32_e32 v9, 56, v19
		v_accvgpr_write_b32 a104, v9
		v_xor_b32_e32 v9, 57, v19
		v_accvgpr_write_b32 a105, v9
		v_xor_b32_e32 v9, 58, v19
		v_accvgpr_write_b32 a106, v9
		v_xor_b32_e32 v9, 59, v19
		v_accvgpr_write_b32 a107, v9
		v_xor_b32_e32 v9, 64, v19
		v_accvgpr_write_b32 a108, v9
		v_xor_b32_e32 v9, 0x41, v19
		v_accvgpr_write_b32 a109, v9
		v_xor_b32_e32 v9, 0x42, v19
		v_accvgpr_write_b32 a110, v9
		v_xor_b32_e32 v9, 0x43, v19
		v_accvgpr_write_b32 a111, v9
		v_xor_b32_e32 v9, 0x48, v19
		v_accvgpr_write_b32 a112, v9
		v_xor_b32_e32 v9, 0x49, v19
		v_accvgpr_write_b32 a113, v9
		v_xor_b32_e32 v9, 0x4a, v19
		v_accvgpr_write_b32 a114, v9
		v_xor_b32_e32 v9, 0x4b, v19
		v_accvgpr_write_b32 a115, v9
		v_xor_b32_e32 v9, 0x50, v19
		v_accvgpr_write_b32 a116, v9
		v_xor_b32_e32 v9, 0x51, v19
		v_accvgpr_write_b32 a117, v9
		v_xor_b32_e32 v9, 0x52, v19
		v_accvgpr_write_b32 a118, v9
		v_xor_b32_e32 v9, 0x53, v19
		v_accvgpr_write_b32 a119, v9
		v_xor_b32_e32 v9, 0x58, v19
		v_accvgpr_write_b32 a120, v9
		v_xor_b32_e32 v9, 0x59, v19
		v_accvgpr_write_b32 a121, v9
		v_xor_b32_e32 v9, 0x5a, v19
		v_accvgpr_write_b32 a122, v9
		v_xor_b32_e32 v9, 0x5b, v19
		v_accvgpr_write_b32 a123, v9
		v_xor_b32_e32 v9, 0x60, v19
		v_accvgpr_write_b32 a124, v9
		v_xor_b32_e32 v9, 0x61, v19
		v_accvgpr_write_b32 a125, v9
		v_xor_b32_e32 v9, 0x62, v19
		v_accvgpr_write_b32 a126, v9
		v_xor_b32_e32 v9, 0x63, v19
		v_accvgpr_write_b32 a127, v9
		v_xor_b32_e32 v9, 0x68, v19
		v_accvgpr_write_b32 a128, v9
		v_xor_b32_e32 v9, 0x69, v19
		v_accvgpr_write_b32 a129, v9
		v_xor_b32_e32 v9, 0x6a, v19
		v_accvgpr_write_b32 a130, v9
		v_xor_b32_e32 v9, 0x6b, v19
		v_accvgpr_write_b32 a131, v9
		v_xor_b32_e32 v9, 0x70, v19
		v_accvgpr_write_b32 a132, v9
		v_xor_b32_e32 v9, 0x71, v19
		v_accvgpr_write_b32 a133, v9
		v_xor_b32_e32 v9, 0x72, v19
		v_accvgpr_write_b32 a134, v9
		v_xor_b32_e32 v9, 0x73, v19
		v_accvgpr_write_b32 a135, v9
		v_xor_b32_e32 v9, 0x78, v19
		v_accvgpr_write_b32 a136, v9
		v_xor_b32_e32 v9, 0x79, v19
		v_accvgpr_write_b32 a137, v9
		v_xor_b32_e32 v9, 0x7a, v19
		v_accvgpr_write_b32 a138, v9
		v_xor_b32_e32 v9, 0x7b, v19
		v_accvgpr_write_b32 a139, v9
		v_accvgpr_read_b32 v9, a18
		v_accvgpr_read_b32 v10, a70
		v_lshl_add_u32 v9, v9, 4, v10
		v_accvgpr_read_b32 v10, a71
		v_accvgpr_read_b32 v11, a72
		v_add3_u32 v9, v9, v10, v11
		v_accvgpr_read_b32 v10, a73
		v_accvgpr_read_b32 v11, a74
		v_add3_u32 v9, v9, v10, v11
		v_accvgpr_write_b32 a18, v9
		v_accvgpr_read_b32 v9, a75
		v_accvgpr_read_b32 v10, a77
		v_lshl_add_u32 v9, v9, 3, v10
		v_accvgpr_read_b32 v10, a78
		v_accvgpr_read_b32 v11, a58
		v_add3_u32 v9, v9, v11, v10
		v_accvgpr_write_b32 a58, v9
		v_mov_b32_e32 v9, 0xff800000
		s_cmp_lt_i32 s42, s25
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_2
.L_attn_fwd_persistent.loop_head_2:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s20, s42, 0x80
		s_cmp_lt_i32 s42, 0
		s_cselect_b32 s37, s36, 0
		s_add_i32 s37, s42, s37
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
		s_add_i32 s44, s37, s39
		s_mul_i32 s37, 0x4100, s38
		v_accvgpr_read_b32 v10, a18
		v_add_u32_e32 v10, s37, v10
		ds_read_b128 v[28:31], v10
		ds_read_b128 a[72:75], v10 offset:32
		ds_read_b128 a[140:143], v10 offset:64
		ds_read_b128 a[144:147], v10 offset:96
		ds_read_b128 a[148:151], v10 offset:256
		ds_read_b128 a[152:155], v10 offset:288
		ds_read_b128 a[156:159], v10 offset:320
		ds_read_b128 a[160:163], v10 offset:352
		ds_read_b128 a[164:167], v10 offset:128
		ds_read_b128 a[168:171], v10 offset:160
		ds_read_b128 a[172:175], v10 offset:192
		ds_read_b128 a[176:179], v10 offset:224
		ds_read_b128 v[96:99], v10 offset:384
		ds_read_b128 a[180:183], v10 offset:416
		ds_read_b128 a[184:187], v10 offset:448
		ds_read_b128 a[188:191], v10 offset:480
		s_mul_i32 s37, 0x4400, s38
		v_accvgpr_read_b32 v10, a58
		v_add_u32_e32 v10, s37, v10
		ds_read_b64_tr_b16 a[192:193], v10 offset:33264
		ds_read_b64_tr_b16 a[194:195], v10 offset:37616
		ds_read_b64_tr_b16 a[196:197], v10 offset:33392
		ds_read_b64_tr_b16 a[198:199], v10 offset:37744
		ds_read_b64_tr_b16 a[200:201], v10 offset:33520
		ds_read_b64_tr_b16 a[202:203], v10 offset:37872
		ds_read_b64_tr_b16 a[204:205], v10 offset:33648
		ds_read_b64_tr_b16 a[206:207], v10 offset:38000
		ds_read_b64_tr_b16 a[208:209], v10 offset:33776
		ds_read_b64_tr_b16 a[210:211], v10 offset:38128
		ds_read_b64_tr_b16 a[212:213], v10 offset:33904
		ds_read_b64_tr_b16 a[214:215], v10 offset:38256
		ds_read_b64_tr_b16 a[216:217], v10 offset:34032
		ds_read_b64_tr_b16 a[218:219], v10 offset:38384
		ds_read_b64_tr_b16 a[220:221], v10 offset:34160
		ds_read_b64_tr_b16 a[222:223], v10 offset:38512
		ds_read_b64_tr_b16 a[224:225], v10 offset:33328
		ds_read_b64_tr_b16 a[226:227], v10 offset:37680
		ds_read_b64_tr_b16 a[228:229], v10 offset:33456
		ds_read_b64_tr_b16 a[230:231], v10 offset:37808
		ds_read_b64_tr_b16 a[232:233], v10 offset:33584
		ds_read_b64_tr_b16 a[234:235], v10 offset:37936
		ds_read_b64_tr_b16 a[236:237], v10 offset:33712
		ds_read_b64_tr_b16 a[238:239], v10 offset:38064
		ds_read_b64_tr_b16 a[240:241], v10 offset:33840
		ds_read_b64_tr_b16 a[242:243], v10 offset:38192
		ds_read_b64_tr_b16 a[244:245], v10 offset:33968
		ds_read_b64_tr_b16 a[246:247], v10 offset:38320
		ds_read_b64_tr_b16 a[248:249], v10 offset:34096
		ds_read_b64_tr_b16 a[250:251], v10 offset:38448
		ds_read_b64_tr_b16 a[252:253], v10 offset:34224
		ds_read_b64_tr_b16 a[254:255], v10 offset:38576
		s_cmp_lt_i32 s20, s24
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_2
		v_accvgpr_read_b32 v10, a19
		v_add_u32_e32 v10, s20, v10
		v_accvgpr_read_b32 v11, a52
		v_add_u32_e32 v11, s20, v11
		v_accvgpr_read_b32 v15, a53
		v_add_u32_e32 v15, s20, v15
		v_accvgpr_read_b32 v16, a54
		v_add_u32_e32 v16, s20, v16
		v_cmp_lt_i32_e64 vcc, v10, s22
		s_mov_b64 s[38:39], vcc
		v_cmp_lt_i32_e64 vcc, v11, s22
		s_mov_b64 s[46:47], vcc
		v_cmp_lt_i32_e64 vcc, v15, s22
		s_mov_b64 s[48:49], vcc
		v_cmp_lt_i32_e64 vcc, v16, s22
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v10, a55
		v_add_u32_e32 v10, s20, v10
		v_accvgpr_read_b32 v11, a56
		v_add_u32_e32 v11, s20, v11
		v_accvgpr_read_b32 v15, a57
		v_add_u32_e32 v15, s20, v15
		v_cmp_lt_i32_e64 vcc, v10, s22
		s_mov_b64 s[54:55], vcc
		v_cmp_lt_i32_e64 vcc, v11, s22
		s_mov_b64 s[56:57], vcc
		v_cmp_lt_i32_e64 vcc, v15, s22
		s_mov_b64 s[58:59], vcc
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s37, s15, s42
		s_lshl_b32 s37, s37, 1
		s_add_i32 s37, s43, s37
		v_accvgpr_read_b32 v10, a60
		v_add_u32_e32 v10, s37, v10
		s_mov_b32 s60, 1
		s_mov_b32 s61, 0
		s_mov_b32 s53, 0
		s_mul_i32 s62, s60, s52
		s_mul_hi_u32 s63, s60, s52
		s_mul_i32 s41, s60, s53
		s_add_i32 s63, s63, s41
		s_mul_i32 s41, s61, s52
		s_add_i32 s63, s63, s41
		s_lshr_b64 s[60:61], s[62:63], 6
		s_mov_b32 s62, 0x410
		s_mov_b32 s63, 0
		s_mul_i32 s64, s62, s60
		s_mul_hi_u32 s65, s62, s60
		s_mul_i32 s41, s62, s61
		s_add_i32 s65, s65, s41
		s_mul_i32 s41, s63, s60
		s_add_i32 s65, s65, s41
		s_cmp_lt_i32 s44, 0
		s_cselect_b32 s45, -1, 0
		s_mov_b32 s62, 0x4100
		s_mov_b32 s63, 0
		s_mul_i32 s66, s62, s44
		s_mul_hi_u32 s67, s62, s44
		s_mul_i32 s41, s62, s45
		s_add_i32 s67, s67, s41
		s_mul_i32 s41, s63, s44
		s_add_i32 s67, s67, s41
		s_add_u32 s62, s64, s66
		s_addc_u32 s63, s65, s67
		s_add_u32 s68, s62, 0
		s_addc_u32 s69, s63, 0
		s_mov_b32 m0, s68
		v_cndmask_b32_e64 v10, v24, v10, s[38:39]
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		v_accvgpr_read_b32 v10, a61
		v_add_u32_e32 v10, s20, v10
		v_accvgpr_read_b32 v11, a62
		v_add_u32_e32 v11, s37, v11
		s_add_u32 s38, s64, 0x1040
		s_addc_u32 s39, s65, 0
		s_add_u32 s38, s38, s66
		s_addc_u32 s39, s39, s67
		s_add_u32 s62, s38, 0
		s_addc_u32 s63, s39, 0
		s_mov_b32 m0, s62
		v_cndmask_b32_e64 v11, v24, v11, s[46:47]
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		v_accvgpr_read_b32 v11, a63
		v_add_u32_e32 v11, s37, v11
		s_add_u32 s38, s64, 0x2080
		s_addc_u32 s39, s65, 0
		s_add_u32 s38, s38, s66
		s_addc_u32 s39, s39, s67
		s_add_u32 s46, s38, 0
		s_addc_u32 s47, s39, 0
		s_mov_b32 m0, s46
		v_cndmask_b32_e64 v11, v24, v11, s[48:49]
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		v_accvgpr_read_b32 v11, a64
		v_add_u32_e32 v11, s37, v11
		s_add_u32 s38, s64, 0x30c0
		s_addc_u32 s39, s65, 0
		s_add_u32 s38, s38, s66
		s_addc_u32 s39, s39, s67
		s_add_u32 s46, s38, 0
		s_addc_u32 s47, s39, 0
		s_mov_b32 m0, s46
		v_cndmask_b32_e64 v11, v24, v11, s[50:51]
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		s_mul_i32 s20, s18, s42
		s_lshl_b32 s20, s20, 1
		s_add_i32 s20, s40, s20
		v_accvgpr_read_b32 v11, a65
		v_add_u32_e32 v11, s20, v11
		s_mov_b32 s38, 0x440
		s_mov_b32 s39, 0
		s_mul_i32 s46, s38, s60
		s_mul_hi_u32 s47, s38, s60
		s_mul_i32 s37, s38, s61
		s_add_i32 s47, s47, s37
		s_mul_i32 s37, s39, s60
		s_add_i32 s47, s47, s37
		s_add_u32 s38, s46, 0x81f0
		s_addc_u32 s39, s47, 0
		s_mov_b32 s48, 0x4400
		s_mov_b32 s49, 0
		s_mul_i32 s50, s48, s44
		s_mul_hi_u32 s51, s48, s44
		s_mul_i32 s37, s48, s45
		s_add_i32 s51, s51, s37
		s_mul_i32 s37, s49, s44
		s_add_i32 s51, s51, s37
		s_add_u32 s38, s38, s50
		s_addc_u32 s39, s39, s51
		s_add_u32 s44, s38, 0
		s_addc_u32 s45, s39, 0
		s_mov_b32 m0, s44
		v_cndmask_b32_e64 v11, v24, v11, s[54:55]
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		v_accvgpr_read_b32 v11, a66
		v_add_u32_e32 v11, s20, v11
		s_add_u32 s38, s46, 0x92f0
		s_addc_u32 s39, s47, 0
		s_add_u32 s38, s38, s50
		s_addc_u32 s39, s39, s51
		s_add_u32 s44, s38, 0
		s_addc_u32 s45, s39, 0
		s_mov_b32 m0, s44
		v_cndmask_b32_e64 v11, v24, v11, s[56:57]
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		v_accvgpr_read_b32 v11, a67
		v_add_u32_e32 v11, s20, v11
		s_add_u32 s38, s46, 0xa3f0
		s_addc_u32 s39, s47, 0
		s_add_u32 s38, s38, s50
		s_addc_u32 s39, s39, s51
		s_add_u32 s44, s38, 0
		s_addc_u32 s45, s39, 0
		s_mov_b32 m0, s44
		v_cndmask_b32_e64 v11, v24, v11, s[58:59]
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v10, s22
		v_accvgpr_read_b32 v10, a68
		v_add_u32_e32 v10, s20, v10
		s_add_u32 s38, s46, 0xb4f0
		s_addc_u32 s39, s47, 0
		v_cndmask_b32_e32 v10, v24, v10, vcc
		s_add_u32 s38, s38, s50
		s_addc_u32 s39, s39, s51
		s_add_u32 s44, s38, 0
		s_addc_u32 s45, s39, 0
		s_mov_b32 m0, s44
		s_nop 0
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_2
.L_attn_fwd_persistent.if_else_2:
.L_attn_fwd_persistent.if_end_2:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[112:127], v[28:31], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[128:143], a[148:151], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[144:159], a[164:167], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[176:191], v[96:99], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[96:111], v[28:31], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[192:207], a[148:151], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[208:223], a[164:167], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[112:127], a[72:75], a[24:27], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[152:155], a[24:27], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[168:171], a[24:27], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[24:27], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[180:183], a[40:43], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[72:75], a[40:43], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[152:155], a[40:43], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[168:171], a[40:43], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[140:143], a[28:31], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[156:159], a[28:31], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[172:175], a[28:31], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[184:187], a[28:31], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[184:187], a[44:47], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[140:143], a[44:47], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[156:159], a[44:47], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[172:175], a[44:47], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[144:147], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[160:163], a[32:35], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[176:179], a[32:35], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[188:191], a[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[188:191], a[48:51], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[144:147], a[48:51], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[160:163], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[176:179], a[48:51], v[208:223]
		v_add_u32_e32 v10, s42, v19
		v_accvgpr_read_b32 v11, a7
		v_add_u32_e32 v11, s42, v11
		v_accvgpr_read_b32 v15, a8
		v_add_u32_e32 v15, s42, v15
		v_accvgpr_read_b32 v16, a69
		v_add_u32_e32 v16, s42, v16
		v_accvgpr_read_b32 v18, a82
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_read_b32 v22, a83
		v_add_u32_e32 v22, s42, v22
		v_accvgpr_read_b32 v23, a86
		v_add_u32_e32 v23, s42, v23
		v_accvgpr_read_b32 v25, a87
		v_add_u32_e32 v25, s42, v25
		v_accvgpr_read_b32 v26, a90
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_read_b32 v27, a91
		v_add_u32_e32 v27, s42, v27
		v_accvgpr_read_b32 v28, a94
		v_add_u32_e32 v28, s42, v28
		v_accvgpr_read_b32 v29, a95
		v_add_u32_e32 v29, s42, v29
		v_accvgpr_read_b32 v30, a98
		v_add_u32_e32 v30, s42, v30
		v_accvgpr_write_b32 a70, v30
		v_accvgpr_read_b32 v30, a99
		v_add_u32_e32 v30, s42, v30
		v_accvgpr_write_b32 a71, v30
		v_accvgpr_read_b32 v30, a102
		v_add_u32_e32 v30, s42, v30
		v_accvgpr_write_b32 a72, v30
		v_accvgpr_read_b32 v30, a103
		v_add_u32_e32 v30, s42, v30
		v_accvgpr_write_b32 a73, v30
		v_accvgpr_read_b32 v30, a106
		v_add_u32_e32 v30, s42, v30
		v_accvgpr_write_b32 a74, v30
		v_accvgpr_read_b32 v30, a107
		v_add_u32_e32 v30, s42, v30
		v_accvgpr_write_b32 a75, v30
		v_accvgpr_read_b32 v30, a110
		v_add_u32_e32 v30, s42, v30
		v_accvgpr_write_b32 a77, v30
		v_accvgpr_read_b32 v30, a111
		v_add_u32_e32 v30, s42, v30
		v_accvgpr_write_b32 a78, v30
		v_accvgpr_read_b32 v30, a114
		v_add_u32_e32 v30, s42, v30
		v_accvgpr_write_b32 a140, v30
		v_accvgpr_read_b32 v30, a115
		v_add_u32_e32 v30, s42, v30
		v_accvgpr_write_b32 a141, v30
		v_accvgpr_read_b32 v30, a118
		v_add_u32_e32 v30, s42, v30
		v_accvgpr_write_b32 a142, v30
		v_accvgpr_read_b32 v30, a119
		v_add_u32_e32 v30, s42, v30
		v_accvgpr_write_b32 a143, v30
		v_accvgpr_read_b32 v30, a122
		v_add_u32_e32 v30, s42, v30
		v_accvgpr_write_b32 a144, v30
		v_accvgpr_read_b32 v30, a123
		v_add_u32_e32 v30, s42, v30
		v_accvgpr_write_b32 a145, v30
		v_accvgpr_read_b32 v30, a126
		v_add_u32_e32 v30, s42, v30
		v_accvgpr_write_b32 a146, v30
		v_accvgpr_read_b32 v30, a127
		v_add_u32_e32 v30, s42, v30
		v_accvgpr_write_b32 a147, v30
		v_accvgpr_read_b32 v30, a130
		v_add_u32_e32 v30, s42, v30
		v_accvgpr_write_b32 a148, v30
		v_accvgpr_read_b32 v30, a131
		v_add_u32_e32 v30, s42, v30
		v_accvgpr_write_b32 a149, v30
		v_accvgpr_read_b32 v30, a134
		v_add_u32_e32 v30, s42, v30
		v_accvgpr_write_b32 a150, v30
		v_accvgpr_read_b32 v30, a135
		v_add_u32_e32 v30, s42, v30
		v_accvgpr_write_b32 a151, v30
		v_accvgpr_read_b32 v30, a138
		v_add_u32_e32 v30, s42, v30
		v_accvgpr_write_b32 a152, v30
		v_accvgpr_read_b32 v30, a139
		v_add_u32_e32 v30, s42, v30
		v_accvgpr_write_b32 a153, v30
		v_cmp_ge_i32_e64 vcc, v6, v10
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v6, v11
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v6, v15
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v6, v16
		v_accvgpr_read_b32 v30, a76
		v_add_u32_e32 v30, s42, v30
		v_accvgpr_read_b32 v31, a81
		v_add_u32_e32 v31, s42, v31
		v_cndmask_b32_e32 v225, v9, v115, vcc
		v_cmp_ge_i32_e64 vcc, v6, v30
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v6, v31
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v6, v18
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v6, v22
		v_accvgpr_read_b32 v115, a84
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_read_b32 v224, a85
		v_add_u32_e32 v226, s42, v224
		v_cndmask_b32_e32 v229, v9, v119, vcc
		v_cmp_ge_i32_e64 vcc, v6, v115
		s_mov_b64 s[56:57], vcc
		v_cmp_ge_i32_e64 vcc, v6, v226
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v6, v23
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v6, v25
		v_accvgpr_read_b32 v119, a88
		v_add_u32_e32 v119, s42, v119
		v_accvgpr_read_b32 v224, a89
		v_add_u32_e32 v227, s42, v224
		v_cndmask_b32_e32 v231, v9, v123, vcc
		v_cmp_ge_i32_e64 vcc, v6, v119
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v6, v227
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v6, v26
		s_mov_b64 s[66:67], vcc
		v_cmp_ge_i32_e64 vcc, v6, v27
		v_accvgpr_read_b32 v123, a92
		v_add_u32_e32 v123, s42, v123
		v_accvgpr_read_b32 v224, a93
		v_add_u32_e32 v232, s42, v224
		v_cndmask_b32_e32 v235, v9, v127, vcc
		v_cmp_ge_i32_e64 vcc, v6, v123
		s_mov_b64 s[68:69], vcc
		v_cmp_ge_i32_e64 vcc, v6, v232
		s_mov_b64 s[70:71], vcc
		v_cmp_ge_i32_e64 vcc, v6, v28
		s_mov_b64 s[72:73], vcc
		v_cmp_ge_i32_e64 vcc, v6, v29
		v_accvgpr_read_b32 v127, a96
		v_add_u32_e32 v127, s42, v127
		v_accvgpr_read_b32 v224, a97
		v_add_u32_e32 v224, s42, v224
		v_accvgpr_write_b32 a154, v224
		v_cndmask_b32_e32 v237, v9, v131, vcc
		v_cmp_ge_i32_e64 vcc, v6, v127
		s_mov_b64 s[74:75], vcc
		v_accvgpr_read_b32 v131, a154
		v_cmp_ge_i32_e64 vcc, v6, v131
		s_mov_b64 s[76:77], vcc
		v_accvgpr_read_b32 v131, a70
		v_cmp_ge_i32_e64 vcc, v6, v131
		s_mov_b64 s[78:79], vcc
		v_accvgpr_read_b32 v131, a71
		v_cmp_ge_i32_e64 vcc, v6, v131
		v_accvgpr_read_b32 v131, a100
		v_add_u32_e32 v131, s42, v131
		v_accvgpr_write_b32 a155, v131
		v_accvgpr_read_b32 v131, a101
		v_add_u32_e32 v131, s42, v131
		v_accvgpr_write_b32 a156, v131
		v_cndmask_b32_e32 v239, v9, v135, vcc
		v_accvgpr_read_b32 v131, a155
		v_cmp_ge_i32_e64 vcc, v6, v131
		s_mov_b64 s[80:81], vcc
		v_accvgpr_read_b32 v131, a156
		v_cmp_ge_i32_e64 vcc, v6, v131
		s_mov_b64 s[82:83], vcc
		v_accvgpr_read_b32 v131, a72
		v_cmp_ge_i32_e64 vcc, v6, v131
		s_mov_b64 s[84:85], vcc
		v_accvgpr_read_b32 v131, a73
		v_cmp_ge_i32_e64 vcc, v6, v131
		s_mov_b64 s[86:87], vcc
		v_mov_b32_e32 v240, s86
		v_mov_b32_e32 v241, s87
		v_accvgpr_read_b32 v131, a104
		v_add_u32_e32 v131, s42, v131
		v_accvgpr_write_b32 a157, v131
		v_accvgpr_read_b32 v131, a105
		v_add_u32_e32 v131, s42, v131
		v_accvgpr_write_b32 a158, v131
		v_cndmask_b32_e32 v241, v9, v139, vcc
		v_accvgpr_read_b32 v131, a157
		v_cmp_ge_i32_e64 vcc, v6, v131
		s_mov_b64 s[86:87], vcc
		v_accvgpr_read_b32 v131, a158
		v_cmp_ge_i32_e64 vcc, v6, v131
		s_mov_b64 s[88:89], vcc
		v_accvgpr_read_b32 v131, a74
		v_cmp_ge_i32_e64 vcc, v6, v131
		s_mov_b64 s[90:91], vcc
		v_mov_b32_e32 v242, s90
		v_mov_b32_e32 v243, s91
		v_accvgpr_write_b32 a160, v242
		v_accvgpr_write_b32 a161, v243
		v_accvgpr_read_b32 v131, a75
		v_cmp_ge_i32_e64 vcc, v6, v131
		v_accvgpr_read_b32 v131, a108
		v_add_u32_e32 v131, s42, v131
		v_accvgpr_write_b32 a159, v131
		v_accvgpr_read_b32 v131, a109
		v_add_u32_e32 v131, s42, v131
		v_accvgpr_write_b32 a162, v131
		v_cndmask_b32_e32 v243, v9, v143, vcc
		v_accvgpr_read_b32 v131, a159
		v_cmp_ge_i32_e64 vcc, v6, v131
		s_mov_b64 s[90:91], vcc
		v_mov_b32_e32 v244, s90
		v_mov_b32_e32 v245, s91
		v_accvgpr_write_b32 a164, v244
		v_accvgpr_write_b32 a165, v245
		v_accvgpr_read_b32 v131, a162
		v_cmp_ge_i32_e64 vcc, v6, v131
		s_mov_b64 s[90:91], vcc
		v_mov_b32_e32 v244, s90
		v_mov_b32_e32 v245, s91
		v_accvgpr_write_b32 a166, v244
		v_accvgpr_write_b32 a167, v245
		v_accvgpr_read_b32 v131, a77
		v_cmp_ge_i32_e64 vcc, v6, v131
		s_mov_b64 s[90:91], vcc
		v_mov_b32_e32 v244, s90
		v_mov_b32_e32 v245, s91
		v_accvgpr_write_b32 a168, v244
		v_accvgpr_write_b32 a169, v245
		v_accvgpr_read_b32 v131, a78
		v_cmp_ge_i32_e64 vcc, v6, v131
		s_mov_b64 s[90:91], vcc
		v_mov_b32_e32 v244, s90
		v_mov_b32_e32 v245, s91
		v_accvgpr_read_b32 v131, a112
		v_add_u32_e32 v131, s42, v131
		v_accvgpr_write_b32 a163, v131
		v_accvgpr_read_b32 v131, a113
		v_add_u32_e32 v131, s42, v131
		v_accvgpr_write_b32 a170, v131
		v_cndmask_b32_e32 v245, v9, v147, vcc
		v_accvgpr_read_b32 v131, a163
		v_cmp_ge_i32_e64 vcc, v6, v131
		s_mov_b64 s[90:91], vcc
		v_mov_b32_e32 v246, s90
		v_mov_b32_e32 v247, s91
		v_accvgpr_write_b32 a172, v246
		v_accvgpr_write_b32 a173, v247
		v_accvgpr_read_b32 v131, a170
		v_cmp_ge_i32_e64 vcc, v6, v131
		s_mov_b64 s[90:91], vcc
		v_mov_b32_e32 v246, s90
		v_mov_b32_e32 v247, s91
		v_accvgpr_write_b32 a174, v246
		v_accvgpr_write_b32 a175, v247
		v_accvgpr_read_b32 v131, a140
		v_cmp_ge_i32_e64 vcc, v6, v131
		s_mov_b64 s[90:91], vcc
		v_mov_b32_e32 v246, s90
		v_mov_b32_e32 v247, s91
		v_accvgpr_write_b32 a176, v246
		v_accvgpr_write_b32 a177, v247
		v_accvgpr_read_b32 v131, a141
		v_cmp_ge_i32_e64 vcc, v6, v131
		v_accvgpr_read_b32 v131, a116
		v_add_u32_e32 v131, s42, v131
		v_accvgpr_write_b32 a171, v131
		v_accvgpr_read_b32 v131, a117
		v_add_u32_e32 v131, s42, v131
		v_accvgpr_write_b32 a178, v131
		v_cndmask_b32_e32 v247, v9, v151, vcc
		v_accvgpr_read_b32 v131, a171
		v_cmp_ge_i32_e64 vcc, v6, v131
		s_mov_b64 s[90:91], vcc
		v_mov_b32_e32 v248, s90
		v_mov_b32_e32 v249, s91
		v_accvgpr_write_b32 a180, v248
		v_accvgpr_write_b32 a181, v249
		v_accvgpr_read_b32 v131, a178
		v_cmp_ge_i32_e64 vcc, v6, v131
		s_mov_b64 s[90:91], vcc
		v_mov_b32_e32 v248, s90
		v_mov_b32_e32 v249, s91
		v_accvgpr_write_b32 a182, v248
		v_accvgpr_write_b32 a183, v249
		v_accvgpr_read_b32 v131, a142
		v_cmp_ge_i32_e64 vcc, v6, v131
		s_mov_b64 s[90:91], vcc
		v_mov_b32_e32 v248, s90
		v_mov_b32_e32 v249, s91
		v_accvgpr_write_b32 a184, v248
		v_accvgpr_write_b32 a185, v249
		v_accvgpr_read_b32 v131, a143
		v_cmp_ge_i32_e64 vcc, v6, v131
		s_mov_b64 s[90:91], vcc
		v_mov_b32_e32 v248, s90
		v_mov_b32_e32 v249, s91
		v_accvgpr_read_b32 v131, a120
		v_add_u32_e32 v131, s42, v131
		v_accvgpr_write_b32 a179, v131
		v_accvgpr_read_b32 v131, a121
		v_add_u32_e32 v131, s42, v131
		v_accvgpr_write_b32 a186, v131
		v_cndmask_b32_e32 v249, v9, v155, vcc
		v_accvgpr_read_b32 v131, a179
		v_cmp_ge_i32_e64 vcc, v6, v131
		s_mov_b64 s[90:91], vcc
		v_accvgpr_read_b32 v131, a186
		v_cmp_ge_i32_e64 vcc, v6, v131
		s_mov_b64 s[92:93], vcc
		v_accvgpr_read_b32 v131, a144
		v_cmp_ge_i32_e64 vcc, v6, v131
		s_mov_b64 s[94:95], vcc
		v_cndmask_b32_e64 v251, v9, v157, s[92:93]
		v_cndmask_b32_e64 v252, v9, v158, s[94:95]
		v_accvgpr_read_b32 v131, a145
		v_cmp_ge_i32_e64 vcc, v6, v131
		v_accvgpr_read_b32 v131, a124
		v_add_u32_e32 v131, s42, v131
		v_accvgpr_read_b32 v135, a125
		v_add_u32_e32 v135, s42, v135
		v_cndmask_b32_e32 v253, v9, v159, vcc
		v_cmp_ge_i32_e64 vcc, v6, v131
		s_mov_b64 s[92:93], vcc
		v_cmp_ge_i32_e64 vcc, v6, v135
		s_mov_b64 s[94:95], vcc
		v_accvgpr_read_b32 v139, a146
		v_cmp_ge_i32_e64 vcc, v6, v139
		s_mov_b64 s[96:97], vcc
		v_cndmask_b32_e64 v158, v9, v160, s[92:93]
		v_cndmask_b32_e64 v159, v9, v161, s[94:95]
		v_cndmask_b32_e64 v160, v9, v162, s[96:97]
		v_accvgpr_read_b32 v139, a147
		v_cmp_ge_i32_e64 vcc, v6, v139
		v_accvgpr_read_b32 v139, a128
		v_add_u32_e32 v139, s42, v139
		v_accvgpr_read_b32 v143, a129
		v_add_u32_e32 v143, s42, v143
		v_accvgpr_write_b32 a187, v143
		v_cndmask_b32_e32 v161, v9, v163, vcc
		v_cmp_ge_i32_e64 vcc, v6, v139
		s_mov_b64 s[92:93], vcc
		v_accvgpr_read_b32 v143, a187
		v_cmp_ge_i32_e64 vcc, v6, v143
		s_mov_b64 s[94:95], vcc
		v_accvgpr_read_b32 v143, a148
		v_cmp_ge_i32_e64 vcc, v6, v143
		s_mov_b64 s[96:97], vcc
		v_cndmask_b32_e64 v162, v9, v164, s[92:93]
		v_cndmask_b32_e64 v163, v9, v165, s[94:95]
		v_cndmask_b32_e64 v164, v9, v166, s[96:97]
		v_accvgpr_read_b32 v143, a149
		v_cmp_ge_i32_e64 vcc, v6, v143
		v_accvgpr_read_b32 v143, a132
		v_add_u32_e32 v143, s42, v143
		v_accvgpr_write_b32 a188, v143
		v_accvgpr_read_b32 v143, a133
		v_add_u32_e32 v143, s42, v143
		v_accvgpr_write_b32 a189, v143
		v_cndmask_b32_e32 v165, v9, v167, vcc
		v_accvgpr_read_b32 v143, a188
		v_cmp_ge_i32_e64 vcc, v6, v143
		s_mov_b64 s[92:93], vcc
		v_accvgpr_read_b32 v143, a189
		v_cmp_ge_i32_e64 vcc, v6, v143
		s_mov_b64 s[94:95], vcc
		v_accvgpr_read_b32 v143, a150
		v_cmp_ge_i32_e64 vcc, v6, v143
		s_mov_b64 s[96:97], vcc
		v_cndmask_b32_e64 v166, v9, v168, s[92:93]
		v_cndmask_b32_e64 v167, v9, v169, s[94:95]
		v_cndmask_b32_e64 v168, v9, v170, s[96:97]
		v_accvgpr_read_b32 v143, a151
		v_cmp_ge_i32_e64 vcc, v6, v143
		v_accvgpr_read_b32 v143, a136
		v_add_u32_e32 v143, s42, v143
		v_accvgpr_write_b32 a190, v143
		v_accvgpr_read_b32 v143, a137
		v_add_u32_e32 v143, s42, v143
		v_accvgpr_write_b32 a191, v143
		v_cndmask_b32_e32 v169, v9, v171, vcc
		v_accvgpr_read_b32 v143, a190
		v_cmp_ge_i32_e64 vcc, v6, v143
		s_mov_b64 s[92:93], vcc
		v_accvgpr_read_b32 v143, a191
		v_cmp_ge_i32_e64 vcc, v6, v143
		s_mov_b64 s[94:95], vcc
		v_accvgpr_read_b32 v143, a152
		v_cmp_ge_i32_e64 vcc, v6, v143
		s_mov_b64 s[96:97], vcc
		v_cndmask_b32_e64 v170, v9, v172, s[92:93]
		v_cndmask_b32_e64 v171, v9, v173, s[94:95]
		v_cndmask_b32_e64 v172, v9, v174, s[96:97]
		v_accvgpr_read_b32 v143, a153
		v_cmp_ge_i32_e64 vcc, v6, v143
		v_mov_b32_e32 v143, 0xff800000
		v_cndmask_b32_e64 v254, v143, v112, s[38:39]
		v_cndmask_b32_e64 v255, v143, v113, s[44:45]
		v_cndmask_b32_e32 v173, v143, v175, vcc
		v_cmp_ge_i32_e64 vcc, v8, v10
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v8, v11
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[92:93], vcc
		v_cndmask_b32_e64 v10, v143, v96, s[38:39]
		v_cndmask_b32_e64 v11, v143, v97, s[44:45]
		v_cndmask_b32_e64 v96, v143, v98, s[92:93]
		v_cmp_ge_i32_e64 vcc, v8, v16
		v_cndmask_b32_e64 v224, v143, v114, s[46:47]
		v_cndmask_b32_e64 v112, v143, v116, s[48:49]
		v_cndmask_b32_e32 v97, v143, v99, vcc
		v_cmp_ge_i32_e64 vcc, v8, v30
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v8, v31
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v8, v18
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v30, v143, v100, s[38:39]
		v_cndmask_b32_e64 v31, v143, v101, s[44:45]
		v_cndmask_b32_e64 v98, v143, v102, s[46:47]
		v_cmp_ge_i32_e64 vcc, v8, v22
		v_cndmask_b32_e64 v113, v143, v117, s[50:51]
		v_cndmask_b32_e64 v228, v143, v118, s[54:55]
		v_cndmask_b32_e32 v99, v143, v103, vcc
		v_cmp_ge_i32_e64 vcc, v8, v115
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v8, v226
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v8, v23
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v22, v143, v104, s[38:39]
		v_cndmask_b32_e64 v23, v143, v105, s[44:45]
		v_cndmask_b32_e64 v100, v143, v106, s[46:47]
		v_cmp_ge_i32_e64 vcc, v8, v25
		v_cndmask_b32_e64 v102, v143, v120, s[56:57]
		v_cndmask_b32_e64 v103, v143, v121, s[58:59]
		v_cndmask_b32_e32 v101, v143, v107, vcc
		v_cmp_ge_i32_e64 vcc, v8, v119
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v8, v227
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v8, v26
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v104, v143, v108, s[38:39]
		v_cndmask_b32_e64 v105, v143, v109, s[44:45]
		v_cndmask_b32_e64 v106, v143, v110, s[46:47]
		v_cmp_ge_i32_e64 vcc, v8, v27
		v_cndmask_b32_e64 v230, v143, v122, s[60:61]
		v_cndmask_b32_e64 v26, v143, v124, s[62:63]
		v_cndmask_b32_e32 v107, v143, v111, vcc
		v_cmp_ge_i32_e64 vcc, v8, v123
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v8, v232
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v8, v28
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v108, v143, v192, s[38:39]
		v_cndmask_b32_e64 v109, v143, v193, s[44:45]
		v_cndmask_b32_e64 v110, v143, v194, s[46:47]
		v_cmp_ge_i32_e64 vcc, v8, v29
		v_cndmask_b32_e64 v27, v143, v125, s[64:65]
		v_cndmask_b32_e64 v234, v143, v126, s[66:67]
		v_cndmask_b32_e32 v111, v143, v195, vcc
		v_cmp_ge_i32_e64 vcc, v8, v127
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v15, a154
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[44:45], vcc
		v_accvgpr_read_b32 v15, a70
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v28, v143, v196, s[38:39]
		v_cndmask_b32_e64 v29, v143, v197, s[44:45]
		v_cndmask_b32_e64 v114, v143, v198, s[46:47]
		v_accvgpr_read_b32 v15, a71
		v_cmp_ge_i32_e64 vcc, v8, v15
		v_cndmask_b32_e64 v116, v143, v128, s[68:69]
		v_cndmask_b32_e64 v117, v143, v129, s[70:71]
		v_cndmask_b32_e32 v115, v143, v199, vcc
		v_accvgpr_read_b32 v15, a155
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v15, a156
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[44:45], vcc
		v_accvgpr_read_b32 v15, a72
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v118, v143, v200, s[38:39]
		v_cndmask_b32_e64 v119, v143, v201, s[44:45]
		v_cndmask_b32_e64 v120, v143, v202, s[46:47]
		v_accvgpr_read_b32 v15, a73
		v_cmp_ge_i32_e64 vcc, v8, v15
		v_cndmask_b32_e64 v236, v143, v130, s[72:73]
		v_cndmask_b32_e64 v122, v143, v132, s[74:75]
		v_cndmask_b32_e32 v121, v143, v203, vcc
		v_accvgpr_read_b32 v15, a157
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v15, a158
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[44:45], vcc
		v_accvgpr_read_b32 v15, a74
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v124, v143, v204, s[38:39]
		v_cndmask_b32_e64 v125, v143, v205, s[44:45]
		v_cndmask_b32_e64 v126, v143, v206, s[46:47]
		v_accvgpr_read_b32 v15, a75
		v_cmp_ge_i32_e64 vcc, v8, v15
		v_cndmask_b32_e64 v123, v143, v133, s[76:77]
		v_cndmask_b32_e64 v238, v143, v134, s[78:79]
		v_cndmask_b32_e32 v127, v143, v207, vcc
		v_accvgpr_read_b32 v15, a159
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v15, a162
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[44:45], vcc
		v_accvgpr_read_b32 v15, a77
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v128, v143, v208, s[38:39]
		v_cndmask_b32_e64 v129, v143, v209, s[44:45]
		v_cndmask_b32_e64 v132, v143, v210, s[46:47]
		v_accvgpr_read_b32 v15, a78
		v_cmp_ge_i32_e64 vcc, v8, v15
		v_cndmask_b32_e64 v174, v143, v136, s[80:81]
		v_cndmask_b32_e64 v175, v143, v137, s[82:83]
		v_cndmask_b32_e32 v133, v143, v211, vcc
		v_accvgpr_read_b32 v15, a163
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v15, a170
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[44:45], vcc
		v_accvgpr_read_b32 v15, a140
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v136, v143, v212, s[38:39]
		v_cndmask_b32_e64 v137, v143, v213, s[44:45]
		v_cndmask_b32_e64 v192, v143, v214, s[46:47]
		v_accvgpr_read_b32 v15, a141
		v_cmp_ge_i32_e64 vcc, v8, v15
		v_mov_b32_e32 v194, s84
		v_mov_b32_e32 v195, s85
		s_nop 0
		v_readfirstlane_b32 s38, v194
		v_readfirstlane_b32 s39, v195
		s_nop 1
		v_cndmask_b32_e64 v240, v143, v138, s[38:39]
		v_mov_b32_e32 v194, s86
		v_mov_b32_e32 v195, s87
		s_nop 0
		v_readfirstlane_b32 s38, v194
		v_readfirstlane_b32 s39, v195
		s_nop 1
		v_cndmask_b32_e64 v194, v143, v140, s[38:39]
		v_cndmask_b32_e32 v193, v143, v215, vcc
		v_accvgpr_read_b32 v15, a171
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v15, a178
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[44:45], vcc
		v_accvgpr_read_b32 v15, a142
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v196, v143, v216, s[38:39]
		v_cndmask_b32_e64 v197, v143, v217, s[44:45]
		v_cndmask_b32_e64 v198, v143, v218, s[46:47]
		v_accvgpr_read_b32 v15, a143
		v_cmp_ge_i32_e64 vcc, v8, v15
		v_mov_b32_e32 v200, s88
		v_mov_b32_e32 v201, s89
		s_nop 0
		v_readfirstlane_b32 s38, v200
		v_readfirstlane_b32 s39, v201
		s_nop 1
		v_cndmask_b32_e64 v195, v143, v141, s[38:39]
		v_accvgpr_read_b32 v15, a160
		s_nop 0
		v_readfirstlane_b32 s38, v15
		v_accvgpr_read_b32 v15, a161
		s_nop 0
		v_readfirstlane_b32 s39, v15
		s_nop 1
		v_cndmask_b32_e64 v242, v143, v142, s[38:39]
		v_cndmask_b32_e32 v199, v143, v219, vcc
		v_accvgpr_read_b32 v15, a179
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v15, a186
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[44:45], vcc
		v_accvgpr_read_b32 v15, a144
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v140, v143, v220, s[38:39]
		v_cndmask_b32_e64 v141, v143, v221, s[44:45]
		v_cndmask_b32_e64 v200, v143, v222, s[46:47]
		v_accvgpr_read_b32 v15, a145
		v_cmp_ge_i32_e64 vcc, v8, v15
		v_accvgpr_read_b32 v15, a164
		s_nop 0
		v_readfirstlane_b32 s38, v15
		v_accvgpr_read_b32 v15, a165
		s_nop 0
		v_readfirstlane_b32 s39, v15
		s_nop 1
		v_cndmask_b32_e64 v202, v143, v144, s[38:39]
		v_accvgpr_read_b32 v15, a166
		s_nop 0
		v_readfirstlane_b32 s38, v15
		v_accvgpr_read_b32 v15, a167
		s_nop 0
		v_readfirstlane_b32 s39, v15
		s_nop 1
		v_cndmask_b32_e64 v203, v143, v145, s[38:39]
		v_cndmask_b32_e32 v201, v143, v223, vcc
		v_cmp_ge_i32_e64 vcc, v8, v131
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v8, v135
		s_mov_b64 s[44:45], vcc
		v_accvgpr_read_b32 v15, a146
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v130, v143, v176, s[38:39]
		v_cndmask_b32_e64 v131, v143, v177, s[44:45]
		v_cndmask_b32_e64 v134, v143, v178, s[46:47]
		v_accvgpr_read_b32 v15, a147
		v_cmp_ge_i32_e64 vcc, v8, v15
		v_accvgpr_read_b32 v15, a168
		s_nop 0
		v_readfirstlane_b32 s38, v15
		v_accvgpr_read_b32 v15, a169
		s_nop 0
		v_readfirstlane_b32 s39, v15
		s_nop 1
		v_cndmask_b32_e64 v244, v143, v146, s[38:39]
		v_accvgpr_read_b32 v15, a172
		s_nop 0
		v_readfirstlane_b32 s38, v15
		v_accvgpr_read_b32 v15, a173
		s_nop 0
		v_readfirstlane_b32 s39, v15
		s_nop 1
		v_cndmask_b32_e64 v144, v143, v148, s[38:39]
		v_cndmask_b32_e32 v135, v143, v179, vcc
		v_cmp_ge_i32_e64 vcc, v8, v139
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v15, a187
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[44:45], vcc
		v_accvgpr_read_b32 v15, a148
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v138, v143, v180, s[38:39]
		v_cndmask_b32_e64 v139, v143, v181, s[44:45]
		v_cndmask_b32_e64 v146, v143, v182, s[46:47]
		v_accvgpr_read_b32 v15, a149
		v_cmp_ge_i32_e64 vcc, v8, v15
		v_accvgpr_read_b32 v15, a174
		s_nop 0
		v_readfirstlane_b32 s38, v15
		v_accvgpr_read_b32 v15, a175
		s_nop 0
		v_readfirstlane_b32 s39, v15
		s_nop 1
		v_cndmask_b32_e64 v145, v143, v149, s[38:39]
		v_accvgpr_read_b32 v15, a176
		s_nop 0
		v_readfirstlane_b32 s38, v15
		v_accvgpr_read_b32 v15, a177
		s_nop 0
		v_readfirstlane_b32 s39, v15
		s_nop 1
		v_cndmask_b32_e64 v246, v143, v150, s[38:39]
		v_cndmask_b32_e32 v147, v143, v183, vcc
		v_accvgpr_read_b32 v15, a188
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v15, a189
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[44:45], vcc
		v_accvgpr_read_b32 v15, a150
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v148, v143, v184, s[38:39]
		v_cndmask_b32_e64 v149, v143, v185, s[44:45]
		v_cndmask_b32_e64 v150, v143, v186, s[46:47]
		v_accvgpr_read_b32 v15, a151
		v_cmp_ge_i32_e64 vcc, v8, v15
		v_accvgpr_read_b32 v15, a180
		s_nop 0
		v_readfirstlane_b32 s38, v15
		v_accvgpr_read_b32 v15, a181
		s_nop 0
		v_readfirstlane_b32 s39, v15
		s_nop 1
		v_cndmask_b32_e64 v176, v143, v152, s[38:39]
		v_accvgpr_read_b32 v15, a182
		s_nop 0
		v_readfirstlane_b32 s38, v15
		v_accvgpr_read_b32 v15, a183
		s_nop 0
		v_readfirstlane_b32 s39, v15
		s_nop 1
		v_cndmask_b32_e64 v177, v143, v153, s[38:39]
		v_cndmask_b32_e32 v151, v143, v187, vcc
		v_accvgpr_read_b32 v15, a190
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v15, a191
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[44:45], vcc
		v_accvgpr_read_b32 v15, a152
		v_cmp_ge_i32_e64 vcc, v8, v15
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v152, v143, v188, s[38:39]
		v_cndmask_b32_e64 v153, v143, v189, s[44:45]
		v_cndmask_b32_e64 v178, v143, v190, s[46:47]
		v_accvgpr_read_b32 v15, a153
		v_cmp_ge_i32_e64 vcc, v8, v15
		v_accvgpr_read_b32 v15, a184
		s_nop 0
		v_readfirstlane_b32 s38, v15
		v_accvgpr_read_b32 v15, a185
		s_nop 0
		v_readfirstlane_b32 s39, v15
		s_nop 1
		v_cndmask_b32_e64 v248, v143, v154, s[38:39]
		v_mov_b32_e32 v154, s90
		v_mov_b32_e32 v155, s91
		s_nop 0
		v_readfirstlane_b32 s38, v154
		v_readfirstlane_b32 s39, v155
		s_nop 1
		v_cndmask_b32_e64 v250, v143, v156, s[38:39]
		v_cndmask_b32_e32 v179, v143, v191, vcc
		v_max3_f32 v15, v254, v255, v224
		v_max3_f32 v16, v112, v113, v228
		v_max3_f32 v18, v102, v103, v230
		v_max3_f32 v25, v26, v27, v234
		v_max3_f32 v142, v116, v117, v236
		v_max3_f32 v143, v122, v123, v238
		v_max3_f32 v154, v174, v175, v240
		v_max3_f32 v155, v194, v195, v242
		v_max3_f32 v156, v202, v203, v244
		v_max3_f32 v157, v144, v145, v246
		v_max3_f32 v180, v176, v177, v248
		v_max3_f32 v181, v250, v251, v252
		v_max3_f32 v182, v158, v159, v160
		v_max3_f32 v183, v162, v163, v164
		v_max3_f32 v184, v166, v167, v168
		v_max3_f32 v185, v170, v171, v172
		v_max3_f32 v15, v15, v225, v16
		v_max3_f32 v16, v18, v231, v25
		v_max3_f32 v18, v142, v237, v143
		v_max3_f32 v25, v154, v241, v155
		v_max3_f32 v142, v156, v245, v157
		v_max3_f32 v143, v180, v249, v181
		v_max3_f32 v154, v182, v161, v183
		v_max3_f32 v155, v184, v169, v185
		v_max3_f32 v15, v15, v229, v16
		v_max3_f32 v16, v18, v239, v25
		v_max3_f32 v18, v142, v247, v143
		v_max3_f32 v25, v154, v165, v155
		v_max3_f32 v15, v15, v235, v16
		v_max3_f32 v16, v18, v253, v25
		v_max3_f32 v15, v15, v243, v16
		v_max_f32_e32 v15, v15, v173
		v_mov_b32_e32 v142, v15
		v_mov_b32_e32 v143, v15
		s_nop 1
		v_permlane32_swap_b32_e32 v142, v143
		v_max_f32_e32 v154, v142, v143
		v_max3_f32 v15, v10, v11, v96
		v_max3_f32 v16, v30, v31, v98
		v_max3_f32 v18, v22, v23, v100
		v_max3_f32 v25, v104, v105, v106
		v_max3_f32 v142, v108, v109, v110
		v_max3_f32 v143, v28, v29, v114
		v_max3_f32 v155, v118, v119, v120
		v_max3_f32 v156, v124, v125, v126
		v_max3_f32 v157, v128, v129, v132
		v_max3_f32 v180, v136, v137, v192
		v_max3_f32 v181, v196, v197, v198
		v_max3_f32 v182, v140, v141, v200
		v_max3_f32 v183, v130, v131, v134
		v_max3_f32 v184, v138, v139, v146
		v_max3_f32 v185, v148, v149, v150
		v_max3_f32 v186, v152, v153, v178
		v_max3_f32 v15, v15, v97, v16
		v_max3_f32 v16, v18, v101, v25
		v_max3_f32 v18, v142, v111, v143
		v_max3_f32 v25, v155, v121, v156
		v_max3_f32 v142, v157, v133, v180
		v_max3_f32 v143, v181, v199, v182
		v_max3_f32 v155, v183, v135, v184
		v_max3_f32 v156, v185, v151, v186
		v_max3_f32 v15, v15, v99, v16
		v_max3_f32 v16, v18, v115, v25
		v_max3_f32 v18, v142, v193, v143
		v_max3_f32 v25, v155, v147, v156
		v_max3_f32 v15, v15, v107, v16
		v_max3_f32 v16, v18, v201, v25
		v_max3_f32 v15, v15, v127, v16
		v_max_f32_e32 v15, v15, v179
		v_mov_b32_e32 v142, v15
		v_mov_b32_e32 v143, v15
		s_nop 1
		v_permlane32_swap_b32_e32 v142, v143
		v_max_f32_e32 v155, v142, v143
		v_mov_b32_e32 v142, 0x3e38aa3b
		v_mov_b32_e32 v143, 0x3e38aa3b
		v_pk_mul_f32 v[156:157], v[154:155], v[142:143]
		v_max_f32_e32 v154, v14, v156
		v_max_f32_e32 v155, v17, v157
		v_pk_fma_f32 v[156:157], v[254:255], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[224:225], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[112:113], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[228:229], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[102:103], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[230:231], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[26:27], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[234:235], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[116:117], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[236:237], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[122:123], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[238:239], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[174:175], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[240:241], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[194:195], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[242:243], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[202:203], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[244:245], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[144:145], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[246:247], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[176:177], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[248:249], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[250:251], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[252:253], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[218:219], v[158:159], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[160:161], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[162:163], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[164:165], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[166:167], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[168:169], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[170:171], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[172:173], v[142:143], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[10:11], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[10:11], v[96:97], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[30:31], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[98:99], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[22:23], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[22:23], v[100:101], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[104:105], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[108:109], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[110:111], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[28:29], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[114:115], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[118:119], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[120:121], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[124:125], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[126:127], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[128:129], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[132:133], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[136:137], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[192:193], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[196:197], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[198:199], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[140:141], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[200:201], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[130:131], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[134:135], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[138:139], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[146:147], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[148:149], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[150:151], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[178:179], v[142:143], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v142, v156
		v_exp_f32_e32 v178, v157
		v_exp_f32_e32 v143, v180
		v_exp_f32_e32 v179, v181
		v_exp_f32_e32 v156, v182
		v_exp_f32_e32 v180, v183
		v_exp_f32_e32 v157, v112
		v_exp_f32_e32 v181, v113
		v_exp_f32_e32 v112, v184
		v_exp_f32_e32 v182, v185
		v_exp_f32_e32 v113, v102
		v_exp_f32_e32 v183, v103
		v_exp_f32_e32 v102, v186
		v_exp_f32_e32 v184, v187
		v_exp_f32_e32 v103, v26
		v_exp_f32_e32 v185, v27
		v_exp_f32_e32 v26, v188
		v_exp_f32_e32 v186, v189
		v_exp_f32_e32 v27, v116
		v_exp_f32_e32 v187, v117
		v_exp_f32_e32 v116, v190
		v_exp_f32_e32 v188, v191
		v_exp_f32_e32 v117, v122
		v_exp_f32_e32 v189, v123
		v_exp_f32_e32 v122, v204
		v_exp_f32_e32 v190, v205
		v_exp_f32_e32 v123, v174
		v_exp_f32_e32 v191, v175
		v_exp_f32_e32 v174, v206
		v_exp_f32_e32 v204, v207
		v_exp_f32_e32 v175, v194
		v_exp_f32_e32 v205, v195
		v_exp_f32_e32 v194, v208
		v_exp_f32_e32 v206, v209
		v_exp_f32_e32 v195, v202
		v_exp_f32_e32 v207, v203
		v_exp_f32_e32 v202, v210
		v_exp_f32_e32 v208, v211
		v_exp_f32_e32 v203, v144
		v_exp_f32_e32 v209, v145
		v_exp_f32_e32 v144, v212
		v_exp_f32_e32 v210, v213
		v_exp_f32_e32 v145, v176
		v_exp_f32_e32 v211, v177
		v_exp_f32_e32 v176, v214
		v_exp_f32_e32 v212, v215
		v_exp_f32_e32 v177, v216
		v_exp_f32_e32 v213, v217
		v_exp_f32_e32 v214, v218
		v_exp_f32_e32 v216, v219
		v_exp_f32_e32 v215, v158
		v_exp_f32_e32 v217, v159
		v_exp_f32_e32 v158, v160
		v_exp_f32_e32 v218, v161
		v_exp_f32_e32 v159, v162
		v_exp_f32_e32 v219, v163
		v_exp_f32_e32 v160, v164
		v_exp_f32_e32 v162, v165
		v_exp_f32_e32 v161, v166
		v_exp_f32_e32 v163, v167
		v_exp_f32_e32 v164, v168
		v_exp_f32_e32 v166, v169
		v_exp_f32_e32 v165, v170
		v_exp_f32_e32 v167, v171
		v_exp_f32_e32 v169, v172
		v_exp_f32_e32 v171, v173
		v_exp_f32_e32 v172, v10
		v_exp_f32_e32 v220, v11
		v_exp_f32_e32 v173, v96
		v_exp_f32_e32 v221, v97
		v_exp_f32_e32 v10, v30
		v_exp_f32_e32 v96, v31
		v_exp_f32_e32 v11, v98
		v_exp_f32_e32 v97, v99
		v_exp_f32_e32 v30, v22
		v_exp_f32_e32 v98, v23
		v_exp_f32_e32 v31, v100
		v_exp_f32_e32 v99, v101
		v_exp_f32_e32 v22, v104
		v_exp_f32_e32 v100, v105
		v_exp_f32_e32 v23, v106
		v_exp_f32_e32 v101, v107
		v_exp_f32_e32 v104, v108
		v_exp_f32_e32 v106, v109
		v_exp_f32_e32 v105, v110
		v_exp_f32_e32 v107, v111
		v_exp_f32_e32 v108, v28
		v_exp_f32_e32 v110, v29
		v_exp_f32_e32 v109, v114
		v_exp_f32_e32 v111, v115
		v_exp_f32_e32 v28, v118
		v_exp_f32_e32 v114, v119
		v_exp_f32_e32 v29, v120
		v_exp_f32_e32 v115, v121
		v_exp_f32_e32 v118, v124
		v_exp_f32_e32 v120, v125
		v_exp_f32_e32 v119, v126
		v_exp_f32_e32 v121, v127
		v_exp_f32_e32 v124, v128
		v_exp_f32_e32 v126, v129
		v_exp_f32_e32 v125, v132
		v_exp_f32_e32 v127, v133
		v_exp_f32_e32 v128, v136
		v_exp_f32_e32 v132, v137
		v_exp_f32_e32 v129, v192
		v_exp_f32_e32 v133, v193
		v_exp_f32_e32 v136, v196
		v_exp_f32_e32 v192, v197
		v_exp_f32_e32 v137, v198
		v_exp_f32_e32 v193, v199
		v_exp_f32_e32 v196, v140
		v_exp_f32_e32 v198, v141
		v_exp_f32_e32 v197, v200
		v_exp_f32_e32 v199, v201
		v_exp_f32_e32 v140, v130
		v_exp_f32_e32 v200, v131
		v_exp_f32_e32 v141, v134
		v_exp_f32_e32 v201, v135
		v_exp_f32_e32 v130, v138
		v_exp_f32_e32 v134, v139
		v_exp_f32_e32 v131, v146
		v_exp_f32_e32 v135, v147
		v_exp_f32_e32 v138, v148
		v_exp_f32_e32 v146, v149
		v_exp_f32_e32 v139, v150
		v_exp_f32_e32 v147, v151
		v_exp_f32_e32 v148, v152
		v_exp_f32_e32 v150, v153
		v_pk_add_f32 v[152:153], v[142:143], v[178:179]
		v_pk_add_f32 v[222:223], v[156:157], v[180:181]
		v_pk_add_f32 v[224:225], v[112:113], v[182:183]
		v_pk_add_f32 v[226:227], v[102:103], v[184:185]
		v_pk_add_f32 v[228:229], v[26:27], v[186:187]
		v_pk_add_f32 v[230:231], v[116:117], v[188:189]
		v_pk_add_f32 v[232:233], v[122:123], v[190:191]
		v_pk_add_f32 v[234:235], v[174:175], v[204:205]
		v_pk_add_f32 v[236:237], v[194:195], v[206:207]
		v_pk_add_f32 v[238:239], v[202:203], v[208:209]
		v_pk_add_f32 v[240:241], v[144:145], v[210:211]
		v_pk_add_f32 v[242:243], v[176:177], v[212:213]
		v_pk_add_f32 v[244:245], v[214:215], v[216:217]
		v_pk_add_f32 v[246:247], v[158:159], v[218:219]
		v_pk_add_f32 v[248:249], v[160:161], v[162:163]
		v_pk_add_f32 v[250:251], v[164:165], v[166:167]
		v_mov_b32_e32 v252, v153
		v_mov_b32_e32 v253, v223
		v_mov_b32_e32 v254, v152
		v_mov_b32_e32 v255, v222
		v_pk_add_f32 v[152:153], v[254:255], v[252:253]
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
		v_mov_b32_e32 v222, v153
		v_mov_b32_e32 v223, v225
		v_mov_b32_e32 v226, v152
		v_mov_b32_e32 v227, v224
		v_pk_add_f32 v[152:153], v[226:227], v[222:223]
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
		v_mov_b32_e32 v222, v153
		v_mov_b32_e32 v223, v227
		v_mov_b32_e32 v224, v152
		v_mov_b32_e32 v225, v226
		v_pk_add_f32 v[152:153], v[224:225], v[222:223]
		v_mov_b32_e32 v222, v229
		v_mov_b32_e32 v223, v231
		v_mov_b32_e32 v224, v228
		v_mov_b32_e32 v225, v230
		v_pk_add_f32 v[226:227], v[224:225], v[222:223]
		v_mov_b32_e32 v222, v153
		v_mov_b32_e32 v223, v227
		v_mov_b32_e32 v224, v152
		v_mov_b32_e32 v225, v226
		v_pk_add_f32 v[152:153], v[224:225], v[222:223]
		v_add_f32_e32 v15, v152, v153
		v_accvgpr_read_b32 v16, a79
		ds_bpermute_b32 v168, v16, v15
		v_accvgpr_read_b32 v16, a80
		ds_bpermute_b32 v170, v16, v15
		v_pk_add_f32 v[152:153], v[172:173], v[220:221]
		v_pk_add_f32 v[222:223], v[10:11], v[96:97]
		v_pk_add_f32 v[224:225], v[30:31], v[98:99]
		v_pk_add_f32 v[226:227], v[22:23], v[100:101]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[228:229], v[168:169], v[170:171]
		v_pk_add_f32 v[230:231], v[104:105], v[106:107]
		v_pk_add_f32 v[232:233], v[108:109], v[110:111]
		v_pk_add_f32 v[234:235], v[28:29], v[114:115]
		v_pk_add_f32 v[236:237], v[118:119], v[120:121]
		v_pk_add_f32 v[238:239], v[124:125], v[126:127]
		v_pk_add_f32 v[240:241], v[128:129], v[132:133]
		v_pk_add_f32 v[242:243], v[136:137], v[192:193]
		v_pk_add_f32 v[244:245], v[196:197], v[198:199]
		v_pk_add_f32 v[246:247], v[140:141], v[200:201]
		v_pk_add_f32 v[248:249], v[130:131], v[134:135]
		v_pk_add_f32 v[250:251], v[138:139], v[146:147]
		v_mov_b32_e32 v149, v229
		v_mov_b32_e32 v151, v152
		v_pk_add_f32 v[252:253], v[148:149], v[150:151]
		v_mov_b32_e32 v254, v153
		v_mov_b32_e32 v255, v224
		v_pk_add_f32 v[152:153], v[254:255], v[222:223]
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
		v_mov_b32_e32 v235, v152
		v_pk_add_f32 v[234:235], v[234:235], v[252:253]
		v_mov_b32_e32 v238, v153
		v_mov_b32_e32 v239, v226
		v_pk_add_f32 v[152:153], v[238:239], v[222:223]
		v_mov_b32_e32 v222, v227
		v_mov_b32_e32 v223, v232
		v_pk_add_f32 v[222:223], v[222:223], v[224:225]
		v_mov_b32_e32 v224, v233
		v_mov_b32_e32 v225, v236
		v_pk_add_f32 v[226:227], v[224:225], v[230:231]
		v_mov_b32_e32 v224, v237
		v_mov_b32_e32 v225, v152
		v_pk_add_f32 v[224:225], v[224:225], v[234:235]
		v_mov_b32_e32 v230, v153
		v_mov_b32_e32 v231, v226
		v_pk_add_f32 v[152:153], v[230:231], v[222:223]
		v_mov_b32_e32 v222, v227
		v_mov_b32_e32 v223, v152
		v_pk_add_f32 v[226:227], v[222:223], v[224:225]
		v_add_f32_e32 v15, v153, v226
		v_add_f32_e32 v15, v227, v15
		v_mov_b32_e32 v152, v15
		v_mov_b32_e32 v153, v15
		s_nop 1
		v_permlane32_swap_b32_e32 v152, v153
		v_add_f32_e32 v223, v152, v153
		v_sub_f32_e32 v14, v14, v154
		v_sub_f32_e32 v15, v17, v155
		v_exp_f32_e32 v16, v14
		v_exp_f32_e32 v152, v15
		v_mov_b32_e32 v17, v16
		v_pk_mul_f32 v[32:33], v[32:33], v[16:17]
		v_pk_mul_f32 v[34:35], v[34:35], v[16:17]
		v_pk_mul_f32 v[36:37], v[36:37], v[16:17]
		v_pk_mul_f32 v[38:39], v[38:39], v[16:17]
		v_pk_mul_f32 v[40:41], v[40:41], v[16:17]
		v_pk_mul_f32 v[42:43], v[42:43], v[16:17]
		v_pk_mul_f32 v[44:45], v[44:45], v[16:17]
		v_pk_mul_f32 v[46:47], v[46:47], v[16:17]
		v_pk_mul_f32 v[48:49], v[48:49], v[16:17]
		v_pk_mul_f32 v[50:51], v[50:51], v[16:17]
		v_pk_mul_f32 v[52:53], v[52:53], v[16:17]
		v_pk_mul_f32 v[54:55], v[54:55], v[16:17]
		v_pk_mul_f32 v[56:57], v[56:57], v[16:17]
		v_pk_mul_f32 v[58:59], v[58:59], v[16:17]
		v_pk_mul_f32 v[60:61], v[60:61], v[16:17]
		v_pk_mul_f32 v[62:63], v[62:63], v[16:17]
		v_mov_b32_e32 v153, v152
		v_pk_mul_f32 v[64:65], v[64:65], v[152:153]
		v_pk_mul_f32 v[66:67], v[66:67], v[152:153]
		v_pk_mul_f32 v[68:69], v[68:69], v[152:153]
		v_pk_mul_f32 v[70:71], v[70:71], v[152:153]
		v_pk_mul_f32 v[72:73], v[72:73], v[152:153]
		v_pk_mul_f32 v[74:75], v[74:75], v[152:153]
		v_pk_mul_f32 v[76:77], v[76:77], v[152:153]
		v_pk_mul_f32 v[78:79], v[78:79], v[152:153]
		v_pk_mul_f32 v[80:81], v[80:81], v[152:153]
		v_pk_mul_f32 v[82:83], v[82:83], v[152:153]
		v_pk_mul_f32 v[84:85], v[84:85], v[152:153]
		v_pk_mul_f32 v[86:87], v[86:87], v[152:153]
		v_pk_mul_f32 v[88:89], v[88:89], v[152:153]
		v_pk_mul_f32 v[90:91], v[90:91], v[152:153]
		v_pk_mul_f32 v[92:93], v[92:93], v[152:153]
		v_pk_mul_f32 v[94:95], v[94:95], v[152:153]
		v_mov_b32_e32 v14, v16
		v_mov_b32_e32 v15, v152
		v_mov_b32_e32 v222, v228
		v_mov_b64_e32 v[16:17], v[20:21]
		v_pk_fma_f32 v[20:21], v[16:17], v[14:15], v[222:223]
		v_cvt_pk_bf16_f32 v224, v142, v178
		v_cvt_pk_bf16_f32 v225, v143, v179
		v_cvt_pk_bf16_f32 v226, v156, v180
		v_cvt_pk_bf16_f32 v227, v157, v181
		v_cvt_pk_bf16_f32 v228, v112, v182
		v_cvt_pk_bf16_f32 v229, v113, v183
		v_cvt_pk_bf16_f32 v230, v102, v184
		v_cvt_pk_bf16_f32 v231, v103, v185
		v_cvt_pk_bf16_f32 v180, v26, v186
		v_cvt_pk_bf16_f32 v181, v27, v187
		v_cvt_pk_bf16_f32 v182, v116, v188
		v_cvt_pk_bf16_f32 v183, v117, v189
		v_cvt_pk_bf16_f32 v184, v122, v190
		v_cvt_pk_bf16_f32 v185, v123, v191
		v_cvt_pk_bf16_f32 v186, v174, v204
		v_cvt_pk_bf16_f32 v187, v175, v205
		v_cvt_pk_bf16_f32 v188, v194, v206
		v_cvt_pk_bf16_f32 v189, v195, v207
		v_cvt_pk_bf16_f32 v190, v202, v208
		v_cvt_pk_bf16_f32 v191, v203, v209
		v_cvt_pk_bf16_f32 v204, v144, v210
		v_cvt_pk_bf16_f32 v205, v145, v211
		v_cvt_pk_bf16_f32 v206, v176, v212
		v_cvt_pk_bf16_f32 v207, v177, v213
		v_cvt_pk_bf16_f32 v176, v214, v216
		v_cvt_pk_bf16_f32 v177, v215, v217
		v_cvt_pk_bf16_f32 v178, v158, v218
		v_cvt_pk_bf16_f32 v179, v159, v219
		v_cvt_pk_bf16_f32 v156, v160, v162
		v_cvt_pk_bf16_f32 v157, v161, v163
		v_cvt_pk_bf16_f32 v158, v164, v166
		v_cvt_pk_bf16_f32 v159, v165, v167
		v_cvt_pk_bf16_f32 v160, v169, v171
		v_cvt_pk_bf16_f32 v161, v172, v220
		v_cvt_pk_bf16_f32 v162, v173, v221
		v_cvt_pk_bf16_f32 v163, v10, v96
		v_cvt_pk_bf16_f32 v164, v11, v97
		v_cvt_pk_bf16_f32 v165, v30, v98
		v_cvt_pk_bf16_f32 v166, v31, v99
		v_cvt_pk_bf16_f32 v167, v22, v100
		v_cvt_pk_bf16_f32 v96, v23, v101
		v_cvt_pk_bf16_f32 v97, v104, v106
		v_cvt_pk_bf16_f32 v98, v105, v107
		v_cvt_pk_bf16_f32 v99, v108, v110
		v_cvt_pk_bf16_f32 v100, v109, v111
		v_cvt_pk_bf16_f32 v101, v28, v114
		v_cvt_pk_bf16_f32 v102, v29, v115
		v_cvt_pk_bf16_f32 v103, v118, v120
		v_cvt_pk_bf16_f32 v28, v119, v121
		v_cvt_pk_bf16_f32 v29, v124, v126
		v_cvt_pk_bf16_f32 v30, v125, v127
		v_cvt_pk_bf16_f32 v31, v128, v132
		v_cvt_pk_bf16_f32 v104, v129, v133
		v_cvt_pk_bf16_f32 v105, v136, v192
		v_cvt_pk_bf16_f32 v106, v137, v193
		v_cvt_pk_bf16_f32 v107, v196, v198
		v_cvt_pk_bf16_f32 v108, v197, v199
		v_cvt_pk_bf16_f32 v109, v140, v200
		v_cvt_pk_bf16_f32 v110, v141, v201
		v_cvt_pk_bf16_f32 v111, v130, v134
		v_cvt_pk_bf16_f32 v112, v131, v135
		v_cvt_pk_bf16_f32 v113, v138, v146
		v_cvt_pk_bf16_f32 v114, v139, v147
		v_cvt_pk_bf16_f32 v115, v148, v150
		v_permlane32_swap_b32_e32 v224, v226
		v_permlane32_swap_b32_e32 v225, v227
		v_permlane32_swap_b32_e32 v228, v230
		v_permlane32_swap_b32_e32 v229, v231
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_permlane32_swap_b32_e32 v176, v178
		v_permlane32_swap_b32_e32 v177, v179
		v_permlane32_swap_b32_e32 v156, v158
		v_permlane32_swap_b32_e32 v157, v159
		v_permlane32_swap_b32_e32 v160, v162
		v_permlane32_swap_b32_e32 v161, v163
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[224:227], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[224:227], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[160:163], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[160:163], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[228:231], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[228:231], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[164:167], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[164:167], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[180:183], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[180:183], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[184:187], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[184:187], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[100:103], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[188:191], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[188:191], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[28:31], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[28:31], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[204:207], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[204:207], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[104:107], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[104:107], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[216:219], v[176:179], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[248:251], v[176:179], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[248:251], v[108:111], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[216:219], v[108:111], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[220:223], v[156:159], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[252:255], v[156:159], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[252:255], v[112:115], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[220:223], v[112:115], v[64:79]
		s_add_i32 s20, s42, 0x80
		s_cmp_lt_i32 s20, s25
		s_mov_b32 s42, s20
		v_mov_b32_e32 v14, v154
		v_mov_b32_e32 v17, v155
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_2
.L_attn_fwd_persistent.loop_exit_2:
		s_mov_b32 s28, s8
		s_mov_b32 s29, s9
		s_mov_b32 s30, s26
		s_mov_b32 s31, s27
		v_rcp_f32_e32 v8, v20
		v_rcp_f32_e32 v10, v21
		v_mov_b32_e32 v9, v8
		v_pk_mul_f32 v[14:15], v[32:33], v[8:9]
		v_pk_mul_f32 v[16:17], v[34:35], v[8:9]
		v_pk_mul_f32 v[18:19], v[36:37], v[8:9]
		v_pk_mul_f32 v[20:21], v[38:39], v[8:9]
		v_pk_mul_f32 v[22:23], v[40:41], v[8:9]
		v_pk_mul_f32 v[24:25], v[42:43], v[8:9]
		v_pk_mul_f32 v[26:27], v[44:45], v[8:9]
		v_pk_mul_f32 v[28:29], v[46:47], v[8:9]
		v_pk_mul_f32 v[30:31], v[48:49], v[8:9]
		v_pk_mul_f32 v[32:33], v[50:51], v[8:9]
		v_pk_mul_f32 v[34:35], v[52:53], v[8:9]
		v_pk_mul_f32 v[36:37], v[54:55], v[8:9]
		v_pk_mul_f32 v[38:39], v[56:57], v[8:9]
		v_pk_mul_f32 v[40:41], v[58:59], v[8:9]
		v_pk_mul_f32 v[42:43], v[60:61], v[8:9]
		v_pk_mul_f32 v[44:45], v[62:63], v[8:9]
		v_mov_b32_e32 v11, v10
		v_pk_mul_f32 v[8:9], v[64:65], v[10:11]
		v_pk_mul_f32 v[46:47], v[66:67], v[10:11]
		v_pk_mul_f32 v[48:49], v[68:69], v[10:11]
		v_pk_mul_f32 v[50:51], v[70:71], v[10:11]
		v_pk_mul_f32 v[52:53], v[72:73], v[10:11]
		v_pk_mul_f32 v[54:55], v[74:75], v[10:11]
		v_pk_mul_f32 v[56:57], v[76:77], v[10:11]
		v_pk_mul_f32 v[58:59], v[78:79], v[10:11]
		v_pk_mul_f32 v[60:61], v[80:81], v[10:11]
		v_pk_mul_f32 v[62:63], v[82:83], v[10:11]
		v_pk_mul_f32 v[64:65], v[84:85], v[10:11]
		v_pk_mul_f32 v[66:67], v[86:87], v[10:11]
		v_pk_mul_f32 v[68:69], v[88:89], v[10:11]
		v_pk_mul_f32 v[70:71], v[90:91], v[10:11]
		v_pk_mul_f32 v[72:73], v[92:93], v[10:11]
		v_pk_mul_f32 v[74:75], v[94:95], v[10:11]
		v_accvgpr_read_b32 v6, a9
		v_mov_b32_e32 v10, 8
		v_mul_lo_u32 v10, v10, v6
		v_xor_b32_e32 v6, 16, v10
		v_xor_b32_e32 v11, 32, v10
		v_xor_b32_e32 v76, 48, v10
		s_mov_b32 s20, 64
		v_cmp_lt_i32_e64 vcc, v10, s20
		s_mov_b64 s[24:25], vcc
		v_readfirstlane_b32 s26, v12
		v_readfirstlane_b32 s27, v13
		s_nop 1
		v_mov_b32_e32 v10, s27
		v_mov_b32_e32 v12, s26
		s_nop 0
		v_readfirstlane_b32 s26, v12
		s_and_b32 s32, s26, s24
		v_readfirstlane_b32 s26, v10
		s_and_b32 s33, s26, s25
		v_cmp_lt_i32_e64 vcc, v6, s20
		s_mov_b64 s[26:27], vcc
		v_readfirstlane_b32 s34, v12
		s_and_b32 s36, s34, s26
		v_readfirstlane_b32 s34, v10
		s_and_b32 s37, s34, s27
		v_cmp_lt_i32_e64 vcc, v11, s20
		s_mov_b64 s[34:35], vcc
		v_readfirstlane_b32 s38, v12
		s_and_b32 s40, s38, s34
		v_readfirstlane_b32 s38, v10
		s_and_b32 s41, s38, s35
		v_cmp_lt_i32_e64 vcc, v76, s20
		s_mov_b64 s[38:39], vcc
		v_readfirstlane_b32 s20, v12
		s_and_b32 s42, s20, s38
		v_readfirstlane_b32 s20, v10
		s_and_b32 s43, s20, s39
		v_accvgpr_read_b32 v6, a10
		s_nop 0
		v_readfirstlane_b32 s44, v6
		v_accvgpr_read_b32 v6, a11
		s_nop 0
		v_readfirstlane_b32 s45, v6
		s_nop 1
		v_mov_b32_e32 v6, s45
		v_mov_b32_e32 v10, s44
		s_nop 0
		v_readfirstlane_b32 s20, v10
		s_and_b32 s44, s20, s24
		v_readfirstlane_b32 s20, v6
		s_and_b32 s45, s20, s25
		v_readfirstlane_b32 s20, v10
		s_and_b32 s24, s20, s26
		v_readfirstlane_b32 s20, v6
		s_and_b32 s25, s20, s27
		v_readfirstlane_b32 s20, v10
		s_and_b32 s26, s20, s34
		v_readfirstlane_b32 s20, v6
		s_and_b32 s27, s20, s35
		v_readfirstlane_b32 s20, v10
		s_and_b32 s34, s20, s38
		v_readfirstlane_b32 s20, v6
		s_and_b32 s35, s20, s39
		v_cvt_pk_bf16_f32 v76, v14, v15
		v_cvt_pk_bf16_f32 v77, v16, v17
		v_cvt_pk_bf16_f32 v78, v18, v19
		v_cvt_pk_bf16_f32 v79, v20, v21
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
		v_cvt_pk_bf16_f32 v24, v8, v9
		v_cvt_pk_bf16_f32 v25, v46, v47
		v_cvt_pk_bf16_f32 v26, v48, v49
		v_cvt_pk_bf16_f32 v27, v50, v51
		v_cvt_pk_bf16_f32 v8, v52, v53
		v_cvt_pk_bf16_f32 v9, v54, v55
		v_cvt_pk_bf16_f32 v10, v56, v57
		v_cvt_pk_bf16_f32 v11, v58, v59
		v_cvt_pk_bf16_f32 v28, v60, v61
		v_cvt_pk_bf16_f32 v29, v62, v63
		v_cvt_pk_bf16_f32 v30, v64, v65
		v_cvt_pk_bf16_f32 v31, v66, v67
		v_cvt_pk_bf16_f32 v32, v68, v69
		v_cvt_pk_bf16_f32 v33, v70, v71
		v_cvt_pk_bf16_f32 v34, v72, v73
		v_cvt_pk_bf16_f32 v35, v74, v75
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
		v_readfirstlane_b32 s20, v7
		s_mul_i32 s20, s20, s19
		s_lshl_b32 s20, s20, 9
		v_readfirstlane_b32 s38, v1
		v_readfirstlane_b32 s39, v5
		s_mul_i32 s38, s39, s38
		s_lshl_b32 s38, s38, 1
		s_add_i32 s39, s20, s38
		v_readfirstlane_b32 s46, v2
		v_mov_b32_e32 v6, s1
		s_nop 0
		v_readfirstlane_b32 s47, v6
		s_mul_i32 s46, s47, s46
		s_lshl_b32 s46, s46, 1
		s_add_i32 s39, s39, s46
		v_accvgpr_read_b32 v6, a6
		v_mul_lo_u32 v6, s19, v6
		v_lshl_add_u32 v7, v6, 7, s39
		v_accvgpr_read_b32 v36, a15
		v_mul_lo_u32 v36, s19, v36
		v_lshl_add_u32 v7, v36, 1, v7
		v_accvgpr_read_b32 v37, a12
		v_mul_lo_u32 v37, s19, v37
		v_lshl_add_u32 v7, v37, 6, v7
		v_accvgpr_read_b32 v38, a13
		v_mul_lo_u32 v38, s19, v38
		v_lshl_add_u32 v7, v38, 5, v7
		v_accvgpr_read_b32 v39, a14
		v_mul_lo_u32 v39, s19, v39
		v_lshl_add_u32 v7, v39, 4, v7
		v_accvgpr_read_b32 v40, a16
		v_mul_lo_u32 v40, s19, v40
		v_lshl_add_u32 v7, v40, 3, v7
		v_accvgpr_read_b32 v41, a17
		v_mul_lo_u32 v41, s19, v41
		v_lshlrev_b32_e32 v41, 2, v41
		v_accvgpr_read_b32 v42, a59
		v_add3_u32 v7, v7, v41, v42
		s_and_saveexec_b64 s[98:99], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_8
		buffer_store_dwordx4 v[76:79], v7, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_8:
		s_andn2_b64 exec, s[98:99], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_8
.L_attn_fwd_persistent.exec_endif_8:
		s_mov_b64 exec, s[98:99]
		s_add_i32 s32, s20, 32
		s_add_i32 s32, s32, s38
		s_add_i32 s32, s32, s46
		v_lshl_add_u32 v7, v6, 7, s32
		v_lshl_add_u32 v7, v36, 1, v7
		v_lshl_add_u32 v7, v37, 6, v7
		v_lshl_add_u32 v7, v38, 5, v7
		v_lshl_add_u32 v7, v39, 4, v7
		v_lshl_add_u32 v7, v40, 3, v7
		v_accvgpr_read_b32 v42, a59
		v_add3_u32 v7, v7, v41, v42
		s_and_saveexec_b64 s[98:99], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_9
		buffer_store_dwordx4 v[12:15], v7, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_9:
		s_andn2_b64 exec, s[98:99], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_9
.L_attn_fwd_persistent.exec_endif_9:
		s_mov_b64 exec, s[98:99]
		s_add_i32 s33, s20, 64
		s_add_i32 s33, s33, s38
		s_add_i32 s33, s33, s46
		v_lshl_add_u32 v7, v6, 7, s33
		v_lshl_add_u32 v7, v36, 1, v7
		v_lshl_add_u32 v7, v37, 6, v7
		v_lshl_add_u32 v7, v38, 5, v7
		v_lshl_add_u32 v7, v39, 4, v7
		v_lshl_add_u32 v7, v40, 3, v7
		v_accvgpr_read_b32 v12, a59
		v_add3_u32 v7, v7, v41, v12
		s_and_saveexec_b64 s[98:99], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_10
		buffer_store_dwordx4 v[16:19], v7, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_10:
		s_andn2_b64 exec, s[98:99], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_10
.L_attn_fwd_persistent.exec_endif_10:
		s_mov_b64 exec, s[98:99]
		s_add_i32 s20, s20, 0x60
		s_add_i32 s20, s20, s38
		s_add_i32 s20, s20, s46
		v_lshl_add_u32 v6, v6, 7, s20
		v_lshl_add_u32 v6, v36, 1, v6
		v_lshl_add_u32 v6, v37, 6, v6
		v_lshl_add_u32 v6, v38, 5, v6
		v_lshl_add_u32 v6, v39, 4, v6
		v_lshl_add_u32 v6, v40, 3, v6
		v_accvgpr_read_b32 v7, a59
		v_add3_u32 v6, v6, v41, v7
		s_and_saveexec_b64 s[98:99], s[42:43]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_11
		buffer_store_dwordx4 v[20:23], v6, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_11:
		s_andn2_b64 exec, s[98:99], s[42:43]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_11
.L_attn_fwd_persistent.exec_endif_11:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v6, a6
		v_lshlrev_b32_e32 v6, 6, v6
		v_accvgpr_read_b32 v7, a12
		v_lshlrev_b32_e32 v7, 5, v7
		v_accvgpr_read_b32 v12, a13
		v_lshlrev_b32_e32 v12, 4, v12
		v_accvgpr_read_b32 v13, a14
		v_lshlrev_b32_e32 v13, 3, v13
		v_accvgpr_read_b32 v14, a16
		v_lshlrev_b32_e32 v14, 2, v14
		v_accvgpr_read_b32 v15, a15
		v_add_u32_e32 v15, 0x80, v15
		v_accvgpr_read_b32 v16, a17
		v_lshlrev_b32_e32 v16, 1, v16
		v_bitop3_b32 v14, v14, v15, v16 bitop3:0x96
		v_bitop3_b32 v12, v12, v13, v14 bitop3:0x96
		v_bitop3_b32 v6, v6, v7, v12 bitop3:0x96
		v_mul_lo_u32 v6, s19, v6
		v_lshlrev_b32_e32 v6, 1, v6
		v_accvgpr_read_b32 v7, a59
		v_add3_u32 v7, s39, v6, v7
		s_and_saveexec_b64 s[98:99], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_12
		buffer_store_dwordx4 v[24:27], v7, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_12:
		s_andn2_b64 exec, s[98:99], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_12
.L_attn_fwd_persistent.exec_endif_12:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v7, a59
		v_add3_u32 v7, s32, v6, v7
		s_and_saveexec_b64 s[98:99], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_13
		buffer_store_dwordx4 v[8:11], v7, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_13:
		s_andn2_b64 exec, s[98:99], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_13
.L_attn_fwd_persistent.exec_endif_13:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v7, a59
		v_add3_u32 v7, s33, v6, v7
		s_and_saveexec_b64 s[98:99], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_14
		buffer_store_dwordx4 v[28:31], v7, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_14:
		s_andn2_b64 exec, s[98:99], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_14
.L_attn_fwd_persistent.exec_endif_14:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v7, a59
		v_add3_u32 v6, s20, v6, v7
		s_and_saveexec_b64 s[98:99], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_15
		buffer_store_dwordx4 v[32:35], v6, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_15:
		s_andn2_b64 exec, s[98:99], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_15
.L_attn_fwd_persistent.exec_endif_15:
		s_mov_b64 exec, s[98:99]
		s_branch .L_attn_fwd_persistent.if_end_1
.L_attn_fwd_persistent.if_else_1:
.L_attn_fwd_persistent.if_end_1:
		s_and_b32 s20, s0, 15
		s_mul_i32 s20, s20, 2
		s_add_i32 s20, s20, 1
		s_cmp_lt_i32 s20, 32
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_3
		s_lshr_b32 s24, s20, 1
		s_and_b32 s20, s20, 1
		s_xor_b32 s25, s24, -1
		s_add_i32 s25, s25, 1
		s_add_i32 s25, s25, 31
		s_cmp_eq_u32 s20, 0
		s_cselect_b32 s20, s24, s25
		s_mul_i32 s24, s20, 0x100
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
		v_accvgpr_write_b32 a6, v21
		v_accvgpr_read_b32 v21, a6
		v_and_b32_e32 v21, 1, v21
		v_mov_b32_e32 v22, 64
		v_mul_lo_u32 v22, v22, v21
		v_xor_b32_e32 v10, v10, v22
		v_accvgpr_write_b32 a7, v10
		v_accvgpr_read_b32 v10, a7
		v_add_u32_e32 v10, s24, v10
		v_xor_b32_e32 v6, 0x80, v6
		v_xor_b32_e32 v6, v6, v9
		v_xor_b32_e32 v6, v6, v11
		v_bitop3_b32 v6, v6, v14, v17 bitop3:0x96
		v_bitop3_b32 v6, v6, v20, v22 bitop3:0x96
		v_accvgpr_write_b32 a8, v6
		v_accvgpr_read_b32 v6, a8
		v_add_u32_e32 v6, s24, v6
		v_cmp_lt_i32_e64 vcc, v10, s21
		s_mov_b64 s[26:27], vcc
		v_cmp_lt_i32_e64 vcc, v6, s21
		s_mov_b64 s[28:29], vcc
		v_mov_b32_e32 v6, 2
		v_mul_lo_u32 v6, v6, v16
		v_lshrrev_b32_e32 v9, 5, v0
		v_and_b32_e32 v10, 1, v9
		v_accvgpr_write_b32 a9, v10
		v_accvgpr_read_b32 v10, a9
		v_mov_b32_e32 v11, 4
		v_mul_lo_u32 v11, v11, v10
		v_bitop3_b32 v14, v13, v6, v11 bitop3:0x96
		v_mov_b32_e32 v17, 8
		v_mul_lo_u32 v17, v17, v19
		v_xor_b32_e32 v14, v14, v17
		v_mov_b32_e32 v20, 16
		v_mul_lo_u32 v20, v20, v21
		v_xad_u32 v14, v14, v20, s24
		v_bitop3_b32 v22, 32, v13, v6 bitop3:0x96
		v_bitop3_b32 v22, v22, v11, v17 bitop3:0x96
		v_xad_u32 v22, v22, v20, s24
		v_bitop3_b32 v23, 64, v13, v6 bitop3:0x96
		v_bitop3_b32 v23, v23, v11, v17 bitop3:0x96
		v_xad_u32 v23, v23, v20, s24
		v_xor_b32_e32 v24, 0x60, v13
		v_xor_b32_e32 v24, v24, v6
		v_xor_b32_e32 v24, v24, v11
		v_xor_b32_e32 v24, v24, v17
		v_xad_u32 v24, v24, v20, s24
		v_xor_b32_e32 v25, 0x80, v13
		v_xor_b32_e32 v25, v25, v6
		v_xor_b32_e32 v25, v25, v11
		v_xor_b32_e32 v25, v25, v17
		v_xad_u32 v25, v25, v20, s24
		v_xor_b32_e32 v26, 0xa0, v13
		v_xor_b32_e32 v26, v26, v6
		v_xor_b32_e32 v26, v26, v11
		v_xor_b32_e32 v26, v26, v17
		v_xad_u32 v26, v26, v20, s24
		v_xor_b32_e32 v27, 0xc0, v13
		v_xor_b32_e32 v27, v27, v6
		v_xor_b32_e32 v27, v27, v11
		v_xor_b32_e32 v27, v27, v17
		v_xad_u32 v27, v27, v20, s24
		v_xor_b32_e32 v28, 0xe0, v13
		v_xor_b32_e32 v6, v28, v6
		v_xor_b32_e32 v6, v6, v11
		v_xor_b32_e32 v6, v6, v17
		v_xad_u32 v6, v6, v20, s24
		s_mov_b32 s34, 0x7fffffff
		s_mov_b32 s35, 0x31016000
		s_mov_b32 s32, s2
		s_mov_b32 s33, s3
		v_accvgpr_read_b32 v17, a2
		v_and_b32_e32 v17, 0xffff, v17
		v_lshlrev_b32_e32 v20, 16, v17
		v_or_b32_e32 v28, v17, v20
		v_mov_b32_e32 v29, v28
		v_mov_b32_e32 v30, v28
		v_mov_b32_e32 v31, v28
		s_mul_i32 s25, s20, s12
		s_lshl_b32 s25, s25, 9
		v_readfirstlane_b32 s30, v5
		s_mul_i32 s30, s30, s10
		s_lshl_b32 s30, s30, 1
		s_add_i32 s25, s25, s30
		v_mov_b32_e32 v17, s1
		s_nop 0
		v_readfirstlane_b32 s1, v17
		s_mul_i32 s1, s1, s11
		s_lshl_b32 s1, s1, 1
		s_add_i32 s1, s25, s1
		v_accvgpr_read_b32 v20, a6
		v_mul_lo_u32 v20, s12, v20
		v_lshl_add_u32 v20, v20, 5, s1
		v_and_b32_e32 v32, 1, v18
		v_accvgpr_write_b32 a10, v32
		v_accvgpr_read_b32 v32, a10
		v_mul_lo_u32 v32, s12, v32
		v_lshl_add_u32 v20, v32, 4, v20
		v_and_b32_e32 v9, 1, v9
		v_mul_lo_u32 v32, s12, v9
		v_lshl_add_u32 v20, v32, 3, v20
		v_and_b32_e32 v15, 1, v15
		v_accvgpr_write_b32 a11, v15
		v_accvgpr_read_b32 v15, a11
		v_mul_lo_u32 v15, s12, v15
		v_lshl_add_u32 v15, v15, 2, v20
		v_and_b32_e32 v12, 1, v12
		v_accvgpr_write_b32 a12, v12
		v_accvgpr_read_b32 v12, a12
		v_mul_lo_u32 v12, s12, v12
		v_lshl_add_u32 v12, v12, 1, v15
		v_and_b32_e32 v15, 1, v0
		v_accvgpr_write_b32 a13, v15
		v_accvgpr_read_b32 v15, a13
		v_lshl_add_u32 v12, v15, 4, v12
		v_and_b32_e32 v15, 1, v8
		v_accvgpr_write_b32 a14, v15
		v_accvgpr_read_b32 v15, a14
		v_lshl_add_u32 v12, v15, 6, v12
		v_and_b32_e32 v7, 1, v7
		v_accvgpr_write_b32 a15, v7
		v_accvgpr_read_b32 v7, a15
		v_lshl_add_u32 v7, v7, 5, v12
		v_cmp_lt_i32_e64 vcc, v14, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_16
		buffer_load_dwordx4 v[32:35], v7, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_16:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_16
		v_mov_b32_e32 v32, v28
		v_mov_b32_e32 v33, v29
		v_mov_b32_e32 v34, v30
		v_mov_b32_e32 v35, v31
.L_attn_fwd_persistent.exec_endif_16:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v7, a6
		v_lshlrev_b32_e32 v7, 4, v7
		v_accvgpr_read_b32 v12, a10
		v_lshlrev_b32_e32 v12, 3, v12
		v_lshlrev_b32_e32 v14, 2, v9
		v_accvgpr_read_b32 v15, a12
		v_add_u32_e32 v15, 32, v15
		v_accvgpr_read_b32 v20, a11
		v_lshlrev_b32_e32 v20, 1, v20
		v_bitop3_b32 v15, v14, v15, v20 bitop3:0x96
		v_bitop3_b32 v15, v7, v12, v15 bitop3:0x96
		v_mul_lo_u32 v15, s12, v15
		v_lshl_add_u32 v15, v15, 1, s1
		v_accvgpr_read_b32 v36, a13
		v_lshl_add_u32 v15, v36, 4, v15
		v_accvgpr_read_b32 v36, a14
		v_lshl_add_u32 v15, v36, 6, v15
		v_accvgpr_read_b32 v36, a15
		v_lshl_add_u32 v15, v36, 5, v15
		v_cmp_lt_i32_e64 vcc, v22, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_17
		buffer_load_dwordx4 v[36:39], v15, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_17:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_17
		v_mov_b32_e32 v36, v28
		v_mov_b32_e32 v37, v29
		v_mov_b32_e32 v38, v30
		v_mov_b32_e32 v39, v31
.L_attn_fwd_persistent.exec_endif_17:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v15, a12
		v_add_u32_e32 v15, 64, v15
		v_bitop3_b32 v15, v14, v15, v20 bitop3:0x96
		v_bitop3_b32 v15, v7, v12, v15 bitop3:0x96
		v_mul_lo_u32 v15, s12, v15
		v_lshl_add_u32 v15, v15, 1, s1
		v_accvgpr_read_b32 v22, a13
		v_lshl_add_u32 v15, v22, 4, v15
		v_accvgpr_read_b32 v22, a14
		v_lshl_add_u32 v15, v22, 6, v15
		v_accvgpr_read_b32 v22, a15
		v_lshl_add_u32 v15, v22, 5, v15
		v_cmp_lt_i32_e64 vcc, v23, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_18
		buffer_load_dwordx4 v[40:43], v15, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_18:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_18
		v_mov_b32_e32 v40, v28
		v_mov_b32_e32 v41, v29
		v_mov_b32_e32 v42, v30
		v_mov_b32_e32 v43, v31
.L_attn_fwd_persistent.exec_endif_18:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v15, a12
		v_add_u32_e32 v15, 0x60, v15
		v_bitop3_b32 v15, v14, v15, v20 bitop3:0x96
		v_bitop3_b32 v15, v7, v12, v15 bitop3:0x96
		v_mul_lo_u32 v15, s12, v15
		v_lshl_add_u32 v15, v15, 1, s1
		v_accvgpr_read_b32 v22, a13
		v_lshl_add_u32 v15, v22, 4, v15
		v_accvgpr_read_b32 v22, a14
		v_lshl_add_u32 v15, v22, 6, v15
		v_accvgpr_read_b32 v22, a15
		v_lshl_add_u32 v15, v22, 5, v15
		v_cmp_lt_i32_e64 vcc, v24, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_19
		buffer_load_dwordx4 v[44:47], v15, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_19:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_19
		v_mov_b32_e32 v44, v28
		v_mov_b32_e32 v45, v29
		v_mov_b32_e32 v46, v30
		v_mov_b32_e32 v47, v31
.L_attn_fwd_persistent.exec_endif_19:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v15, a12
		v_add_u32_e32 v15, 0x80, v15
		v_bitop3_b32 v15, v14, v15, v20 bitop3:0x96
		v_bitop3_b32 v15, v7, v12, v15 bitop3:0x96
		v_mul_lo_u32 v15, s12, v15
		v_lshl_add_u32 v15, v15, 1, s1
		v_accvgpr_read_b32 v22, a13
		v_lshl_add_u32 v15, v22, 4, v15
		v_accvgpr_read_b32 v22, a14
		v_lshl_add_u32 v15, v22, 6, v15
		v_accvgpr_read_b32 v22, a15
		v_lshl_add_u32 v15, v22, 5, v15
		v_cmp_lt_i32_e64 vcc, v25, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_20
		buffer_load_dwordx4 v[48:51], v15, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_20:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_20
		v_mov_b32_e32 v48, v28
		v_mov_b32_e32 v49, v29
		v_mov_b32_e32 v50, v30
		v_mov_b32_e32 v51, v31
.L_attn_fwd_persistent.exec_endif_20:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v15, a12
		v_add_u32_e32 v15, 0xa0, v15
		v_bitop3_b32 v15, v14, v15, v20 bitop3:0x96
		v_bitop3_b32 v15, v7, v12, v15 bitop3:0x96
		v_mul_lo_u32 v15, s12, v15
		v_lshl_add_u32 v15, v15, 1, s1
		v_accvgpr_read_b32 v22, a13
		v_lshl_add_u32 v15, v22, 4, v15
		v_accvgpr_read_b32 v22, a14
		v_lshl_add_u32 v15, v22, 6, v15
		v_accvgpr_read_b32 v22, a15
		v_lshl_add_u32 v15, v22, 5, v15
		v_cmp_lt_i32_e64 vcc, v26, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_21
		buffer_load_dwordx4 v[52:55], v15, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_21:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_21
		v_mov_b32_e32 v52, v28
		v_mov_b32_e32 v53, v29
		v_mov_b32_e32 v54, v30
		v_mov_b32_e32 v55, v31
.L_attn_fwd_persistent.exec_endif_21:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v15, a12
		v_add_u32_e32 v15, 0xc0, v15
		v_bitop3_b32 v15, v14, v15, v20 bitop3:0x96
		v_bitop3_b32 v15, v7, v12, v15 bitop3:0x96
		v_mul_lo_u32 v15, s12, v15
		v_lshl_add_u32 v15, v15, 1, s1
		v_accvgpr_read_b32 v22, a13
		v_lshl_add_u32 v15, v22, 4, v15
		v_accvgpr_read_b32 v22, a14
		v_lshl_add_u32 v15, v22, 6, v15
		v_accvgpr_read_b32 v22, a15
		v_lshl_add_u32 v15, v22, 5, v15
		v_cmp_lt_i32_e64 vcc, v27, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_22
		buffer_load_dwordx4 v[24:27], v15, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_22:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_22
		v_mov_b32_e32 v24, v28
		v_mov_b32_e32 v25, v29
		v_mov_b32_e32 v26, v30
		v_mov_b32_e32 v27, v31
.L_attn_fwd_persistent.exec_endif_22:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v15, a12
		v_add_u32_e32 v15, 0xe0, v15
		v_bitop3_b32 v14, v14, v15, v20 bitop3:0x96
		v_bitop3_b32 v12, v7, v12, v14 bitop3:0x96
		v_mul_lo_u32 v12, s12, v12
		v_lshl_add_u32 v12, v12, 1, s1
		v_accvgpr_read_b32 v14, a13
		v_lshl_add_u32 v12, v14, 4, v12
		v_accvgpr_read_b32 v14, a14
		v_lshl_add_u32 v12, v14, 6, v12
		v_accvgpr_read_b32 v14, a15
		v_lshl_add_u32 v12, v14, 5, v12
		v_cmp_lt_i32_e64 vcc, v6, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_23
		buffer_load_dwordx4 v[56:59], v12, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_23:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_23
		v_mov_b32_e32 v56, v28
		v_mov_b32_e32 v57, v29
		v_mov_b32_e32 v58, v30
		v_mov_b32_e32 v59, v31
.L_attn_fwd_persistent.exec_endif_23:
		s_mov_b64 exec, s[98:99]
		s_mov_b32 s36, s4
		s_mov_b32 s37, s5
		s_mov_b32 s38, s34
		s_mov_b32 s39, s35
		s_mov_b32 s40, s6
		s_mov_b32 s41, s7
		s_mov_b32 s42, s34
		s_mov_b32 s43, s35
		s_waitcnt vmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v6, a10
		v_lshlrev_b32_e32 v6, 2, v6
		v_lshlrev_b32_e32 v12, 1, v9
		v_accvgpr_read_b32 v14, a11
		v_xor_b32_e32 v14, v0, v14
		v_bitop3_b32 v6, v6, v12, v14 bitop3:0x96
		v_lshlrev_b32_e32 v6, 4, v6
		v_add_u32_e32 v6, 0x10000, v6
		ds_write_b128 v6, v[32:35] offset:18864
		ds_write_b128 v6, v[36:39] offset:22960
		ds_write_b128 v6, v[40:43] offset:27056
		ds_write_b128 v6, v[44:47] offset:31152
		v_lshlrev_b32_e32 v12, 12, v18
		v_add_u32_e32 v12, 0x10000, v12
		v_and_b32_e32 v14, 63, v0
		v_lshrrev_b32_e32 v15, 2, v14
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 5, v15
		v_lshrrev_b32_e32 v18, 1, v14
		v_and_b32_e32 v18, 1, v18
		v_lshlrev_b32_e32 v18, 4, v18
		v_and_b32_e32 v20, 1, v14
		v_lshlrev_b32_e32 v20, 3, v20
		v_add3_u32 v22, v15, v18, v20
		v_lshrrev_b32_e32 v23, 5, v14
		v_accvgpr_write_b32 a16, v23
		v_accvgpr_read_b32 v23, a16
		v_xor_b32_e32 v22, v22, v23
		v_lshrrev_b32_e32 v23, 6, v22
		v_lshrrev_b32_e32 v28, 3, v14
		v_and_b32_e32 v28, 1, v28
		v_add_u32_e32 v23, v23, v28
		v_and_b32_e32 v23, 1, v23
		v_lshlrev_b32_e32 v23, 2, v23
		v_lshrrev_b32_e32 v29, 5, v22
		v_and_b32_e32 v29, 1, v29
		v_lshlrev_b32_e32 v29, 1, v29
		v_lshrrev_b32_e32 v30, 4, v14
		v_and_b32_e32 v30, 1, v30
		v_lshlrev_b32_e32 v31, 6, v28
		v_lshl_add_u32 v30, v30, 7, v31
		v_add_u32_e32 v31, v30, v22
		v_lshrrev_b32_e32 v22, 4, v22
		v_bitop3_b32 v22, v31, v22, 1 bitop3:0x78
		v_bitop3_b32 v22, v23, v29, v22 bitop3:0x96
		v_lshl_add_u32 v23, v22, 4, v12
		ds_read_b128 a[20:23], v23 offset:18864
		v_add_u32_e32 v23, 2, v15
		v_add3_u32 v23, v23, v18, v20
		v_accvgpr_read_b32 v29, a16
		v_xor_b32_e32 v23, v23, v29
		v_lshrrev_b32_e32 v29, 6, v23
		v_add_u32_e32 v29, v29, v28
		v_and_b32_e32 v29, 1, v29
		v_lshlrev_b32_e32 v29, 2, v29
		v_lshrrev_b32_e32 v31, 5, v23
		v_and_b32_e32 v31, 1, v31
		v_lshlrev_b32_e32 v31, 1, v31
		v_add_u32_e32 v32, v30, v23
		v_lshrrev_b32_e32 v23, 4, v23
		v_bitop3_b32 v23, v32, v23, 1 bitop3:0x78
		v_bitop3_b32 v23, v29, v31, v23 bitop3:0x96
		v_lshl_add_u32 v29, v23, 4, v12
		ds_read_b128 a[24:27], v29 offset:18864
		v_add_u32_e32 v29, 4, v15
		v_add3_u32 v29, v29, v18, v20
		v_accvgpr_read_b32 v31, a16
		v_xor_b32_e32 v29, v29, v31
		v_lshrrev_b32_e32 v31, 6, v29
		v_add_u32_e32 v31, v31, v28
		v_and_b32_e32 v31, 1, v31
		v_lshlrev_b32_e32 v31, 2, v31
		v_lshrrev_b32_e32 v32, 5, v29
		v_and_b32_e32 v32, 1, v32
		v_lshlrev_b32_e32 v32, 1, v32
		v_add_u32_e32 v33, v30, v29
		v_lshrrev_b32_e32 v29, 4, v29
		v_bitop3_b32 v29, v33, v29, 1 bitop3:0x78
		v_bitop3_b32 v29, v31, v32, v29 bitop3:0x96
		v_lshl_add_u32 v31, v29, 4, v12
		ds_read_b128 a[28:31], v31 offset:18864
		v_add_u32_e32 v15, 6, v15
		v_add3_u32 v15, v15, v18, v20
		v_accvgpr_read_b32 v18, a16
		v_xor_b32_e32 v15, v15, v18
		v_lshrrev_b32_e32 v18, 6, v15
		v_add_u32_e32 v18, v18, v28
		v_and_b32_e32 v18, 1, v18
		v_lshlrev_b32_e32 v18, 2, v18
		v_lshrrev_b32_e32 v20, 5, v15
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v20, 1, v20
		v_add_u32_e32 v28, v30, v15
		v_lshrrev_b32_e32 v15, 4, v15
		v_bitop3_b32 v15, v28, v15, 1 bitop3:0x78
		v_bitop3_b32 v15, v18, v20, v15 bitop3:0x96
		v_lshl_add_u32 v12, v15, 4, v12
		ds_read_b128 a[32:35], v12 offset:18864
		v_accvgpr_read_b32 v12, a10
		v_lshl_add_u32 v12, v12, 3, 32
		v_xor_b32_e32 v7, v12, v7
		v_lshrrev_b32_e32 v12, 5, v7
		v_and_b32_e32 v12, 1, v12
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v6, v[48:51] offset:18864
		ds_write_b128 v6, v[52:55] offset:22960
		ds_write_b128 v6, v[24:27] offset:27056
		ds_write_b128 v6, v[56:59] offset:31152
		v_lshlrev_b32_e32 v6, 14, v12
		v_add_u32_e32 v6, 0x10000, v6
		v_lshrrev_b32_e32 v12, 4, v7
		v_and_b32_e32 v12, 1, v12
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshl_add_u32 v6, v12, 13, v6
		v_lshrrev_b32_e32 v7, 3, v7
		v_and_b32_e32 v7, 1, v7
		v_lshl_add_u32 v6, v7, 12, v6
		v_lshl_add_u32 v7, v22, 4, v6
		ds_read_b128 a[36:39], v7 offset:2480
		v_lshl_add_u32 v7, v23, 4, v6
		ds_read_b128 a[40:43], v7 offset:2480
		v_lshl_add_u32 v7, v29, 4, v6
		ds_read_b128 a[44:47], v7 offset:2480
		v_lshl_add_u32 v6, v15, 4, v6
		ds_read_b128 a[48:51], v6 offset:2480
		s_add_i32 s1, s20, 1
		s_mul_i32 s1, s1, 0x100
		v_mov_b32_e32 v6, s23
		s_nop 0
		v_readfirstlane_b32 s25, v6
		s_add_i32 s1, s1, s25
		s_cmp_lt_i32 s22, s1
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_cselect_b32 s1, s22, s1
		s_add_i32 s25, s1, 0x7f
		s_mov_b32 s30, 0x7f
		s_cmp_lt_i32 s25, 0
		s_cselect_b32 s31, s30, 0
		s_add_i32 s25, s25, s31
		s_ashr_i32 s25, s25, 7
		v_readfirstlane_b32 s31, v6
		s_add_i32 s31, s24, s31
		s_cmp_lt_i32 s31, 0
		s_cselect_b32 s32, s30, 0
		s_add_i32 s31, s31, s32
		s_ashr_i32 s31, s31, 7
		s_cmp_lt_i32 s31, s25
		s_cselect_b32 s31, s31, s25
		s_cmp_gt_i32 s31, 0
		s_cselect_b32 s31, s31, 0
		v_mov_b32_e32 v7, 64
		v_mul_lo_u32 v7, v7, v13
		v_mov_b32_e32 v12, 32
		v_mul_lo_u32 v12, v12, v16
		v_accvgpr_read_b32 v15, a9
		v_mov_b32_e32 v16, 16
		v_mul_lo_u32 v16, v16, v15
		v_bitop3_b32 v15, v7, v12, v16 bitop3:0x96
		v_mov_b32_e32 v18, 2
		v_mul_lo_u32 v18, v18, v21
		v_bitop3_b32 v15, v15, v19, v18 bitop3:0x96
		v_accvgpr_write_b32 a17, v15
		v_bitop3_b32 v15, 4, v7, v12 bitop3:0x96
		v_xor_b32_e32 v15, v15, v16
		v_bitop3_b32 v15, v15, v19, v18 bitop3:0x96
		v_accvgpr_write_b32 a18, v15
		v_bitop3_b32 v15, 8, v7, v12 bitop3:0x96
		v_xor_b32_e32 v15, v15, v16
		v_bitop3_b32 v15, v15, v19, v18 bitop3:0x96
		v_accvgpr_write_b32 a19, v15
		v_bitop3_b32 v7, 12, v7, v12 bitop3:0x96
		v_xor_b32_e32 v7, v7, v16
		v_bitop3_b32 v7, v7, v19, v18 bitop3:0x96
		v_accvgpr_write_b32 a52, v7
		v_accvgpr_read_b32 v7, a17
		v_cmp_lt_i32_e64 vcc, v7, s22
		s_mov_b64 s[32:33], vcc
		v_accvgpr_read_b32 v7, a18
		v_cmp_lt_i32_e64 vcc, v7, s22
		s_mov_b64 s[44:45], vcc
		v_accvgpr_read_b32 v7, a19
		v_cmp_lt_i32_e64 vcc, v7, s22
		s_mov_b64 s[46:47], vcc
		v_accvgpr_read_b32 v7, a52
		v_cmp_lt_i32_e64 vcc, v7, s22
		s_mov_b64 s[48:49], vcc
		v_mov_b32_e32 v7, 16
		v_mul_lo_u32 v7, v7, v13
		v_accvgpr_read_b32 v13, a9
		v_mov_b32_e32 v15, 64
		v_mul_lo_u32 v15, v15, v13
		v_bitop3_b32 v13, v7, v12, v15 bitop3:0x96
		v_bitop3_b32 v13, v13, v19, v18 bitop3:0x96
		v_accvgpr_write_b32 a53, v13
		v_bitop3_b32 v13, 4, v7, v12 bitop3:0x96
		v_xor_b32_e32 v13, v13, v15
		v_bitop3_b32 v13, v13, v19, v18 bitop3:0x96
		v_accvgpr_write_b32 a54, v13
		v_bitop3_b32 v13, 8, v7, v12 bitop3:0x96
		v_xor_b32_e32 v13, v13, v15
		v_bitop3_b32 v13, v13, v19, v18 bitop3:0x96
		v_accvgpr_write_b32 a55, v13
		v_bitop3_b32 v7, 12, v7, v12 bitop3:0x96
		v_accvgpr_read_b32 v12, a53
		v_cmp_lt_i32_e64 vcc, v12, s22
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v12, a54
		v_cmp_lt_i32_e64 vcc, v12, s22
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v12, a55
		v_cmp_lt_i32_e64 vcc, v12, s22
		s_mov_b64 s[54:55], vcc
		v_readfirstlane_b32 s56, v0
		v_accvgpr_read_b32 v12, a6
		v_lshlrev_b32_e32 v12, 1, v12
		v_accvgpr_read_b32 v13, a11
		v_lshlrev_b32_e32 v13, 5, v13
		v_accvgpr_write_b32 a56, v13
		v_accvgpr_read_b32 v13, a12
		v_accvgpr_read_b32 v16, a56
		v_lshl_add_u32 v13, v13, 6, v16
		v_lshlrev_b32_e32 v16, 4, v9
		v_accvgpr_write_b32 a57, v16
		v_accvgpr_read_b32 v16, a57
		v_xor_b32_e32 v13, v13, v16
		v_accvgpr_read_b32 v16, a10
		v_bitop3_b32 v13, v12, v16, v13 bitop3:0x96
		v_mul_lo_u32 v16, s15, v13
		v_accvgpr_read_b32 v20, a13
		v_lshlrev_b32_e32 v20, 4, v20
		v_lshl_add_u32 v16, v16, 1, v20
		v_accvgpr_read_b32 v21, a14
		v_lshlrev_b32_e32 v21, 6, v21
		v_accvgpr_read_b32 v22, a15
		v_lshlrev_b32_e32 v22, 5, v22
		v_add3_u32 v16, v16, v21, v22
		v_accvgpr_write_b32 a58, v16
		v_readfirstlane_b32 s57, v5
		s_mul_i32 s57, s57, s13
		s_lshl_b32 s57, s57, 1
		v_readfirstlane_b32 s58, v17
		s_mul_i32 s58, s58, s14
		s_lshl_b32 s58, s58, 1
		s_add_i32 s59, s57, s58
		v_accvgpr_read_b32 v16, a58
		v_add_u32_e32 v16, s59, v16
		v_mov_b32_e32 v23, 0x80000000
		v_cndmask_b32_e64 v16, v23, v16, s[32:33]
		s_lshr_b32 s32, s56, 6
		s_mul_i32 s33, 0x410, s32
		s_mov_b32 m0, s33
		v_xor_b32_e32 v7, v7, v15
		buffer_load_dwordx4 v16, s[36:39], 0 offen lds
		v_bitop3_b32 v7, v7, v19, v18 bitop3:0x96
		v_accvgpr_write_b32 a59, v7
		v_xor_b32_e32 v7, 4, v13
		v_mul_lo_u32 v15, s15, v7
		v_lshl_add_u32 v15, v15, 1, v20
		v_add3_u32 v15, v15, v21, v22
		v_accvgpr_write_b32 a60, v15
		v_accvgpr_read_b32 v15, a60
		v_add_u32_e32 v15, s59, v15
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v15, v23, v15, s[44:45]
		buffer_load_dwordx4 v15, s[36:39], 0 offen lds
		v_xor_b32_e32 v13, 8, v13
		v_mul_lo_u32 v13, s15, v13
		v_lshl_add_u32 v13, v13, 1, v20
		v_add3_u32 v13, v13, v21, v22
		v_accvgpr_write_b32 a61, v13
		v_accvgpr_read_b32 v13, a61
		v_add_u32_e32 v13, s59, v13
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v13, v23, v13, s[46:47]
		buffer_load_dwordx4 v13, s[36:39], 0 offen lds
		v_xor_b32_e32 v7, 8, v7
		v_mul_lo_u32 v7, s15, v7
		v_lshl_add_u32 v7, v7, 1, v20
		v_add3_u32 v7, v7, v21, v22
		v_accvgpr_write_b32 a62, v7
		v_accvgpr_read_b32 v7, a62
		v_add_u32_e32 v7, s59, v7
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v7, v23, v7, s[48:49]
		buffer_load_dwordx4 v7, s[36:39], 0 offen lds
		v_accvgpr_read_b32 v7, a56
		v_lshl_add_u32 v7, v9, 6, v7
		v_accvgpr_read_b32 v13, a12
		v_lshl_add_u32 v7, v13, 4, v7
		v_accvgpr_read_b32 v13, a10
		v_bitop3_b32 v7, v12, v7, v13 bitop3:0x96
		v_mul_lo_u32 v12, s18, v7
		v_lshl_add_u32 v12, v12, 1, v20
		v_add3_u32 v12, v12, v21, v22
		v_accvgpr_write_b32 a63, v12
		v_accvgpr_read_b32 v12, a0
		s_nop 0
		v_readfirstlane_b32 s44, v12
		v_readfirstlane_b32 s45, v5
		s_mul_i32 s44, s45, s44
		s_lshl_b32 s44, s44, 1
		v_accvgpr_read_b32 v5, a1
		s_nop 0
		v_readfirstlane_b32 s45, v5
		v_readfirstlane_b32 s46, v17
		s_mul_i32 s45, s46, s45
		s_lshl_b32 s45, s45, 1
		s_add_i32 s46, s44, s45
		v_accvgpr_read_b32 v5, a63
		v_add_u32_e32 v5, s46, v5
		s_mul_i32 s32, 0x440, s32
		s_add_i32 m0, s32, 0x81f0
		v_cndmask_b32_e64 v5, v23, v5, s[50:51]
		buffer_load_dwordx4 v5, s[40:43], 0 offen lds
		v_xor_b32_e32 v5, 4, v7
		v_mul_lo_u32 v12, s18, v5
		v_lshl_add_u32 v12, v12, 1, v20
		v_add3_u32 v12, v12, v21, v22
		v_accvgpr_write_b32 a64, v12
		v_accvgpr_read_b32 v12, a64
		v_add_u32_e32 v12, s46, v12
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v12, v23, v12, s[52:53]
		buffer_load_dwordx4 v12, s[40:43], 0 offen lds
		v_xor_b32_e32 v7, 8, v7
		v_mul_lo_u32 v7, s18, v7
		v_lshl_add_u32 v7, v7, 1, v20
		v_add3_u32 v7, v7, v21, v22
		v_add_u32_e32 v12, s46, v7
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v12, v23, v12, s[54:55]
		buffer_load_dwordx4 v12, s[40:43], 0 offen lds
		v_xor_b32_e32 v5, 8, v5
		v_mul_lo_u32 v5, s18, v5
		v_lshl_add_u32 v5, v5, 1, v20
		v_add3_u32 v5, v5, v21, v22
		v_accvgpr_read_b32 v12, a59
		v_cmp_lt_i32_e64 vcc, v12, s22
		v_add_u32_e32 v12, s46, v5
		v_mbcnt_lo_u32_b32 v13, -1, 0
		v_cndmask_b32_e32 v12, v23, v12, vcc
		s_add_i32 m0, m0, 0x1100
		s_mul_i32 s46, s31, 0x80
		buffer_load_dwordx4 v12, s[40:43], 0 offen lds
		v_mbcnt_hi_u32_b32 v12, -1, v13
		v_and_b32_e32 v13, 1, v12
		v_lshrrev_b32_e32 v15, 4, v12
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 4, v15
		v_lshrrev_b32_e32 v16, 3, v12
		v_and_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v16, 3, v16
		v_add3_u32 v18, v13, v15, v16
		v_lshrrev_b32_e32 v19, 2, v12
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 2, v19
		v_lshrrev_b32_e32 v12, 1, v12
		v_and_b32_e32 v12, 1, v12
		v_lshlrev_b32_e32 v12, 1, v12
		v_add3_u32 v18, v18, v19, v12
		v_add_u32_e32 v13, 32, v13
		v_bitop3_b32 v12, v19, v13, v12 bitop3:0x96
		v_bitop3_b32 v12, v15, v16, v12 bitop3:0x96
		v_mov_b32_e32 v20, 0x3e38aa3b
		v_mov_b32_e32 v21, 0x3e38aa3b
		s_mov_b32 s31, 0xff800000
		v_mov_b32_e32 v13, s31
		v_mov_b32_e32 v15, s31
		s_mov_b32 s31, 1.0
		v_mov_b32_e32 v24, s31
		v_mov_b32_e32 v25, s31
		s_mov_b32 s31, 0
		v_accvgpr_read_b32 v16, a16
		v_lshlrev_b32_e32 v16, 4, v16
		v_accvgpr_write_b32 a65, v16
		v_and_b32_e32 v14, 31, v14
		v_lshrrev_b32_e32 v16, 4, v14
		v_lshlrev_b32_e32 v16, 9, v16
		v_accvgpr_write_b32 a66, v16
		v_lshrrev_b32_e32 v16, 3, v14
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v19, 0x2080
		v_mul_lo_u32 v19, v19, v16
		v_accvgpr_write_b32 a67, v19
		v_lshrrev_b32_e32 v16, 2, v14
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v19, 0x1040
		v_mul_lo_u32 v19, v19, v16
		v_accvgpr_write_b32 a68, v19
		v_lshrrev_b32_e32 v16, 1, v14
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v19, 0x820
		v_mul_lo_u32 v19, v19, v16
		v_accvgpr_write_b32 a69, v19
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v16, 0x410
		v_mul_lo_u32 v16, v16, v14
		v_accvgpr_write_b32 a70, v16
		v_and_b32_e32 v14, 3, v0
		v_accvgpr_write_b32 a71, v14
		v_accvgpr_read_b32 v14, a71
		v_lshlrev_b32_e32 v14, 3, v14
		v_accvgpr_write_b32 a72, v14
		v_mov_b32_e32 v14, 0x2200
		v_mul_lo_u32 v14, v14, v9
		v_accvgpr_write_b32 a73, v14
		v_and_b32_e32 v8, 3, v8
		v_mov_b32_e32 v9, 0x440
		v_mul_lo_u32 v9, v9, v8
		v_accvgpr_write_b32 a74, v9
		s_lshl_b32 s47, s15, 8
		s_add_i32 s47, s47, s57
		s_add_i32 s47, s47, s58
		s_lshl_b32 s48, s18, 8
		s_add_i32 s44, s48, s44
		s_add_i32 s44, s44, s45
		v_lshlrev_b32_e32 v8, 2, v18
		v_accvgpr_write_b32 a75, v8
		v_lshlrev_b32_e32 v8, 2, v12
		v_accvgpr_write_b32 a76, v8
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
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_3
.L_attn_fwd_persistent.loop_head_3:
		s_waitcnt vmcnt(0)
		s_barrier
		s_lshr_b32 s45, s31, 7
		s_and_b32 s48, s45, 1
		s_mul_i32 s49, 0x4100, s48
		v_accvgpr_read_b32 v8, a65
		v_accvgpr_read_b32 v9, a66
		v_add3_u32 v8, s49, v8, v9
		v_accvgpr_read_b32 v9, a67
		v_accvgpr_read_b32 v12, a68
		v_add3_u32 v8, v8, v9, v12
		v_accvgpr_read_b32 v9, a69
		v_accvgpr_read_b32 v12, a70
		v_add3_u32 v8, v8, v9, v12
		ds_read_b128 v[28:31], v8
		ds_read_b128 a[80:83], v8 offset:32
		ds_read_b128 a[84:87], v8 offset:64
		ds_read_b128 a[88:91], v8 offset:96
		ds_read_b128 v[96:99], v8 offset:256
		ds_read_b128 a[92:95], v8 offset:288
		ds_read_b128 a[96:99], v8 offset:320
		ds_read_b128 a[100:103], v8 offset:352
		ds_read_b128 a[104:107], v8 offset:128
		ds_read_b128 a[108:111], v8 offset:160
		ds_read_b128 a[112:115], v8 offset:192
		ds_read_b128 a[116:119], v8 offset:224
		ds_read_b128 v[100:103], v8 offset:384
		ds_read_b128 a[120:123], v8 offset:416
		ds_read_b128 a[124:127], v8 offset:448
		ds_read_b128 a[128:131], v8 offset:480
		s_mul_i32 s48, 0x4400, s48
		v_accvgpr_read_b32 v8, a72
		v_accvgpr_read_b32 v9, a73
		v_add3_u32 v8, s48, v8, v9
		v_accvgpr_read_b32 v9, a74
		v_accvgpr_read_b32 v12, a56
		v_add3_u32 v8, v8, v12, v9
		ds_read_b64_tr_b16 a[132:133], v8 offset:33264
		ds_read_b64_tr_b16 a[134:135], v8 offset:37616
		ds_read_b64_tr_b16 a[136:137], v8 offset:33392
		ds_read_b64_tr_b16 a[138:139], v8 offset:37744
		ds_read_b64_tr_b16 a[140:141], v8 offset:33520
		ds_read_b64_tr_b16 a[142:143], v8 offset:37872
		ds_read_b64_tr_b16 a[144:145], v8 offset:33648
		ds_read_b64_tr_b16 a[146:147], v8 offset:38000
		ds_read_b64_tr_b16 a[148:149], v8 offset:33776
		ds_read_b64_tr_b16 a[150:151], v8 offset:38128
		ds_read_b64_tr_b16 a[152:153], v8 offset:33904
		ds_read_b64_tr_b16 a[154:155], v8 offset:38256
		ds_read_b64_tr_b16 a[156:157], v8 offset:34032
		ds_read_b64_tr_b16 a[158:159], v8 offset:38384
		ds_read_b64_tr_b16 a[160:161], v8 offset:34160
		ds_read_b64_tr_b16 a[162:163], v8 offset:38512
		ds_read_b64_tr_b16 a[164:165], v8 offset:33328
		ds_read_b64_tr_b16 a[166:167], v8 offset:37680
		ds_read_b64_tr_b16 a[168:169], v8 offset:33456
		ds_read_b64_tr_b16 a[170:171], v8 offset:37808
		ds_read_b64_tr_b16 a[172:173], v8 offset:33584
		ds_read_b64_tr_b16 a[174:175], v8 offset:37936
		ds_read_b64_tr_b16 a[176:177], v8 offset:33712
		ds_read_b64_tr_b16 a[178:179], v8 offset:38064
		ds_read_b64_tr_b16 a[180:181], v8 offset:33840
		ds_read_b64_tr_b16 a[182:183], v8 offset:38192
		ds_read_b64_tr_b16 a[184:185], v8 offset:33968
		ds_read_b64_tr_b16 a[186:187], v8 offset:38320
		ds_read_b64_tr_b16 a[188:189], v8 offset:34096
		ds_read_b64_tr_b16 a[190:191], v8 offset:38448
		ds_read_b64_tr_b16 a[192:193], v8 offset:34224
		ds_read_b64_tr_b16 a[194:195], v8 offset:38576
		s_mul_i32 s48, s15, s31
		s_lshl_b32 s48, s48, 1
		s_add_i32 s48, s47, s48
		v_accvgpr_read_b32 v8, a58
		v_add_u32_e32 v8, s48, v8
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v9, a60
		v_add_u32_e32 v9, s48, v9
		s_add_i32 s45, s45, 1
		v_accvgpr_read_b32 v12, a61
		v_add_u32_e32 v12, s48, v12
		s_and_b32 s45, s45, 1
		v_accvgpr_read_b32 v14, a62
		v_add_u32_e32 v14, s48, v14
		s_mul_i32 s48, 0x4100, s45
		v_mfma_f32_32x32x16_bf16 v[112:127], v[28:31], a[20:23], 0
		s_add_i32 s48, s33, s48
		v_mfma_f32_32x32x16_bf16 v[128:143], v[96:99], a[20:23], 0
		s_mov_b32 m0, s48
		v_mfma_f32_32x32x16_bf16 v[144:159], a[104:107], a[20:23], 0
		s_mul_i32 s48, s18, s31
		v_mfma_f32_32x32x16_bf16 v[160:175], v[100:103], a[20:23], 0
		s_add_i32 s31, s31, 0x80
		v_mfma_f32_32x32x16_bf16 v[176:191], v[100:103], a[36:39], 0
		v_accvgpr_read_b32 v16, a17
		v_add_u32_e32 v16, s31, v16
		v_mfma_f32_32x32x16_bf16 v[192:207], v[28:31], a[36:39], 0
		v_accvgpr_read_b32 v18, a18
		v_add_u32_e32 v18, s31, v18
		v_mfma_f32_32x32x16_bf16 v[208:223], v[96:99], a[36:39], 0
		v_accvgpr_read_b32 v19, a19
		v_add_u32_e32 v19, s31, v19
		v_mfma_f32_32x32x16_bf16 v[96:111], a[104:107], a[36:39], 0
		v_accvgpr_read_b32 v22, a52
		v_add_u32_e32 v22, s31, v22
		v_mfma_f32_32x32x16_bf16 v[112:127], a[80:83], a[24:27], v[112:127]
		v_cmp_lt_i32_e64 vcc, v16, s22
		s_mov_b64 s[50:51], vcc
		v_mfma_f32_32x32x16_bf16 v[128:143], a[92:95], a[24:27], v[128:143]
		v_cmp_lt_i32_e64 vcc, v18, s22
		s_mov_b64 s[52:53], vcc
		v_mfma_f32_32x32x16_bf16 v[144:159], a[108:111], a[24:27], v[144:159]
		v_cmp_lt_i32_e64 vcc, v19, s22
		s_mov_b64 s[54:55], vcc
		v_mfma_f32_32x32x16_bf16 v[160:175], a[120:123], a[24:27], v[160:175]
		v_cmp_lt_i32_e64 vcc, v22, s22
		s_mov_b64 s[58:59], vcc
		v_mfma_f32_32x32x16_bf16 v[176:191], a[120:123], a[40:43], v[176:191]
		v_accvgpr_read_b32 v16, a53
		v_add_u32_e32 v16, s31, v16
		v_mfma_f32_32x32x16_bf16 v[192:207], a[80:83], a[40:43], v[192:207]
		v_accvgpr_read_b32 v18, a54
		v_add_u32_e32 v18, s31, v18
		v_mfma_f32_32x32x16_bf16 v[208:223], a[92:95], a[40:43], v[208:223]
		v_accvgpr_read_b32 v19, a55
		v_add_u32_e32 v19, s31, v19
		v_mfma_f32_32x32x16_bf16 v[96:111], a[108:111], a[40:43], v[96:111]
		v_cmp_lt_i32_e64 vcc, v16, s22
		s_mov_b64 s[60:61], vcc
		v_mfma_f32_32x32x16_bf16 v[112:127], a[84:87], a[28:31], v[112:127]
		v_cmp_lt_i32_e64 vcc, v18, s22
		s_mov_b64 s[62:63], vcc
		v_mfma_f32_32x32x16_bf16 v[128:143], a[96:99], a[28:31], v[128:143]
		v_cmp_lt_i32_e64 vcc, v19, s22
		s_mov_b64 s[64:65], vcc
		v_mfma_f32_32x32x16_bf16 v[144:159], a[112:115], a[28:31], v[144:159]
		v_cndmask_b32_e64 v8, v23, v8, s[50:51]
		buffer_load_dwordx4 v8, s[36:39], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[160:175], a[124:127], a[28:31], v[160:175]
		v_accvgpr_read_b32 v8, a59
		v_add_u32_e32 v8, s31, v8
		v_cndmask_b32_e64 v9, v23, v9, s[52:53]
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v12, v23, v12, s[54:55]
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		v_cndmask_b32_e64 v9, v23, v14, s[58:59]
		v_cmp_lt_i32_e64 vcc, v8, s22
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s48, s48, 1
		s_add_i32 s48, s44, s48
		buffer_load_dwordx4 v12, s[36:39], 0 offen lds
		v_accvgpr_read_b32 v8, a63
		v_add_u32_e32 v8, s48, v8
		v_cndmask_b32_e64 v8, v23, v8, s[60:61]
		s_add_i32 m0, m0, 0x1040
		s_mul_i32 s45, 0x4400, s45
		s_add_i32 s45, s32, s45
		buffer_load_dwordx4 v9, s[36:39], 0 offen lds
		v_accvgpr_read_b32 v9, a64
		v_add_u32_e32 v9, s48, v9
		v_cndmask_b32_e64 v9, v23, v9, s[62:63]
		s_add_i32 m0, s45, 0x81f0
		v_add_u32_e32 v12, s48, v7
		v_cndmask_b32_e64 v12, v23, v12, s[64:65]
		buffer_load_dwordx4 v8, s[40:43], 0 offen lds
		v_add_u32_e32 v8, s48, v5
		v_cndmask_b32_e32 v8, v23, v8, vcc
		s_add_i32 m0, m0, 0x1100
		v_mfma_f32_32x32x16_bf16 v[176:191], a[124:127], a[44:47], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[84:87], a[44:47], v[192:207]
		buffer_load_dwordx4 v9, s[40:43], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[208:223], a[96:99], a[44:47], v[208:223]
		s_add_i32 m0, m0, 0x1100
		v_mfma_f32_32x32x16_bf16 v[96:111], a[112:115], a[44:47], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[88:91], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[100:103], a[32:35], v[128:143]
		buffer_load_dwordx4 v12, s[40:43], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[144:159], a[116:119], a[32:35], v[144:159]
		s_add_i32 m0, m0, 0x1100
		s_cmp_lt_i32 s31, s46
		v_mfma_f32_32x32x16_bf16 v[160:175], a[128:131], a[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[128:131], a[48:51], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[88:91], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[100:103], a[48:51], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[116:119], a[48:51], v[96:111]
		buffer_load_dwordx4 v8, s[40:43], 0 offen lds
		s_nop 0
		v_max3_f32 v8, v112, v113, v114
		v_max3_f32 v9, v116, v117, v118
		v_max3_f32 v12, v120, v121, v122
		v_max3_f32 v14, v124, v125, v126
		v_max3_f32 v16, v128, v129, v130
		v_max3_f32 v18, v132, v133, v134
		v_max3_f32 v19, v136, v137, v138
		v_max3_f32 v22, v140, v141, v142
		v_max3_f32 v26, v144, v145, v146
		v_max3_f32 v27, v148, v149, v150
		v_max3_f32 v28, v152, v153, v154
		v_max3_f32 v29, v156, v157, v158
		v_max3_f32 v30, v160, v161, v162
		v_max3_f32 v31, v164, v165, v166
		v_max3_f32 v224, v168, v169, v170
		v_max3_f32 v225, v172, v173, v174
		v_max3_f32 v8, v8, v115, v9
		v_max3_f32 v9, v12, v123, v14
		v_max3_f32 v12, v16, v131, v18
		v_max3_f32 v14, v19, v139, v22
		v_max3_f32 v16, v26, v147, v27
		v_max3_f32 v18, v28, v155, v29
		v_max3_f32 v19, v30, v163, v31
		v_max3_f32 v22, v224, v171, v225
		v_max3_f32 v8, v8, v119, v9
		v_max3_f32 v9, v12, v135, v14
		v_max3_f32 v12, v16, v151, v18
		v_max3_f32 v14, v19, v167, v22
		v_max3_f32 v8, v8, v127, v9
		v_max3_f32 v9, v12, v159, v14
		v_max3_f32 v8, v8, v143, v9
		v_max_f32_e32 v8, v8, v175
		v_mov_b32_e32 v18, v8
		v_mov_b32_e32 v19, v8
		s_nop 1
		v_permlane32_swap_b32_e32 v18, v19
		v_max_f32_e32 v8, v18, v19
		v_max3_f32 v9, v192, v193, v194
		v_max3_f32 v12, v196, v197, v198
		v_max3_f32 v14, v200, v201, v202
		v_max3_f32 v16, v204, v205, v206
		v_max3_f32 v18, v208, v209, v210
		v_max3_f32 v19, v212, v213, v214
		v_max3_f32 v22, v216, v217, v218
		v_max3_f32 v26, v220, v221, v222
		v_max3_f32 v27, v96, v97, v98
		v_max3_f32 v28, v100, v101, v102
		v_max3_f32 v29, v104, v105, v106
		v_max3_f32 v30, v108, v109, v110
		v_max3_f32 v31, v176, v177, v178
		v_max3_f32 v224, v180, v181, v182
		v_max3_f32 v225, v184, v185, v186
		v_max3_f32 v226, v188, v189, v190
		v_max3_f32 v9, v9, v195, v12
		v_max3_f32 v12, v14, v203, v16
		v_max3_f32 v14, v18, v211, v19
		v_max3_f32 v16, v22, v219, v26
		v_max3_f32 v18, v27, v99, v28
		v_max3_f32 v19, v29, v107, v30
		v_max3_f32 v22, v31, v179, v224
		v_max3_f32 v26, v225, v187, v226
		v_max3_f32 v9, v9, v199, v12
		v_max3_f32 v12, v14, v215, v16
		v_max3_f32 v14, v18, v103, v19
		v_max3_f32 v16, v22, v183, v26
		v_max3_f32 v9, v9, v207, v12
		v_max3_f32 v12, v14, v111, v16
		v_max3_f32 v9, v9, v223, v12
		v_max_f32_e32 v9, v9, v191
		v_mov_b32_e32 v18, v9
		v_mov_b32_e32 v19, v9
		s_nop 1
		v_permlane32_swap_b32_e32 v18, v19
		v_max_f32_e32 v9, v18, v19
		v_pk_mul_f32 v[18:19], v[8:9], v[20:21]
		v_max_f32_e32 v8, v13, v18
		v_max_f32_e32 v9, v15, v19
		v_pk_fma_f32 v[18:19], v[112:113], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[114:115], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[116:117], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[118:119], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[120:121], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[122:123], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[124:125], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[126:127], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[128:129], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[130:131], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[132:133], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[134:135], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[136:137], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[138:139], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[140:141], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[142:143], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[144:145], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[146:147], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[148:149], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[150:151], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[152:153], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[154:155], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[156:157], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[158:159], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[160:161], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[162:163], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[164:165], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[166:167], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[168:169], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[170:171], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[172:173], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[174:175], v[20:21], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[192:193], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[194:195], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[196:197], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[198:199], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[200:201], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[202:203], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[204:205], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[206:207], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[208:209], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[210:211], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[212:213], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[214:215], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[216:217], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[218:219], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[220:221], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[222:223], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[96:97], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[98:99], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[108:109], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[110:111], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[176:177], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[178:179], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[180:181], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[182:183], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[184:185], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[186:187], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[188:189], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[190:191], v[20:21], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v190, v18
		v_exp_f32_e32 v218, v19
		v_exp_f32_e32 v191, v26
		v_exp_f32_e32 v219, v27
		v_exp_f32_e32 v18, v28
		v_exp_f32_e32 v26, v29
		v_exp_f32_e32 v19, v30
		v_exp_f32_e32 v27, v31
		v_exp_f32_e32 v28, v112
		v_exp_f32_e32 v30, v113
		v_exp_f32_e32 v29, v114
		v_exp_f32_e32 v31, v115
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
		v_exp_f32_e32 v165, v168
		v_exp_f32_e32 v167, v169
		v_exp_f32_e32 v168, v170
		v_exp_f32_e32 v220, v171
		v_exp_f32_e32 v169, v172
		v_exp_f32_e32 v221, v173
		v_exp_f32_e32 v170, v174
		v_exp_f32_e32 v172, v175
		v_exp_f32_e32 v171, v192
		v_exp_f32_e32 v173, v193
		v_exp_f32_e32 v174, v194
		v_exp_f32_e32 v192, v195
		v_exp_f32_e32 v175, v196
		v_exp_f32_e32 v193, v197
		v_exp_f32_e32 v194, v198
		v_exp_f32_e32 v196, v199
		v_exp_f32_e32 v195, v200
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
		v_exp_f32_e32 v207, v212
		v_exp_f32_e32 v209, v213
		v_exp_f32_e32 v210, v214
		v_exp_f32_e32 v212, v215
		v_exp_f32_e32 v211, v216
		v_exp_f32_e32 v213, v217
		v_exp_f32_e32 v214, v96
		v_exp_f32_e32 v216, v97
		v_exp_f32_e32 v215, v98
		v_exp_f32_e32 v217, v99
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
		v_exp_f32_e32 v108, v176
		v_exp_f32_e32 v110, v177
		v_exp_f32_e32 v109, v178
		v_exp_f32_e32 v111, v179
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
		v_pk_add_f32 v[188:189], v[190:191], v[218:219]
		v_pk_add_f32 v[222:223], v[18:19], v[26:27]
		v_pk_add_f32 v[224:225], v[28:29], v[30:31]
		v_pk_add_f32 v[226:227], v[112:113], v[114:115]
		v_pk_add_f32 v[228:229], v[116:117], v[118:119]
		v_pk_add_f32 v[230:231], v[120:121], v[122:123]
		v_pk_add_f32 v[232:233], v[124:125], v[126:127]
		v_pk_add_f32 v[234:235], v[128:129], v[130:131]
		v_pk_add_f32 v[236:237], v[132:133], v[134:135]
		v_pk_add_f32 v[238:239], v[136:137], v[138:139]
		v_pk_add_f32 v[240:241], v[140:141], v[142:143]
		v_pk_add_f32 v[242:243], v[144:145], v[146:147]
		v_pk_add_f32 v[244:245], v[148:149], v[150:151]
		v_pk_add_f32 v[246:247], v[152:153], v[154:155]
		v_pk_add_f32 v[248:249], v[156:157], v[158:159]
		v_pk_add_f32 v[250:251], v[160:161], v[162:163]
		v_mov_b32_e32 v252, v189
		v_mov_b32_e32 v253, v223
		v_mov_b32_e32 v254, v188
		v_mov_b32_e32 v255, v222
		v_pk_add_f32 v[188:189], v[254:255], v[252:253]
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
		v_mov_b32_e32 v222, v189
		v_mov_b32_e32 v223, v225
		v_mov_b32_e32 v226, v188
		v_mov_b32_e32 v227, v224
		v_pk_add_f32 v[188:189], v[226:227], v[222:223]
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
		v_mov_b32_e32 v222, v189
		v_mov_b32_e32 v223, v227
		v_mov_b32_e32 v224, v188
		v_mov_b32_e32 v225, v226
		v_pk_add_f32 v[188:189], v[224:225], v[222:223]
		v_mov_b32_e32 v222, v229
		v_mov_b32_e32 v223, v231
		v_mov_b32_e32 v224, v228
		v_mov_b32_e32 v225, v230
		v_pk_add_f32 v[226:227], v[224:225], v[222:223]
		v_mov_b32_e32 v222, v189
		v_mov_b32_e32 v223, v227
		v_mov_b32_e32 v224, v188
		v_mov_b32_e32 v225, v226
		v_pk_add_f32 v[188:189], v[224:225], v[222:223]
		v_add_f32_e32 v12, v188, v189
		v_accvgpr_read_b32 v14, a75
		ds_bpermute_b32 v164, v14, v12
		v_accvgpr_read_b32 v14, a76
		ds_bpermute_b32 v166, v14, v12
		v_pk_add_f32 v[188:189], v[168:169], v[220:221]
		v_pk_add_f32 v[222:223], v[170:171], v[172:173]
		v_pk_add_f32 v[224:225], v[174:175], v[192:193]
		v_pk_add_f32 v[226:227], v[194:195], v[196:197]
		v_pk_add_f32 v[228:229], v[198:199], v[200:201]
		v_pk_add_f32 v[230:231], v[202:203], v[204:205]
		v_pk_add_f32 v[232:233], v[206:207], v[208:209]
		v_pk_add_f32 v[234:235], v[210:211], v[212:213]
		v_pk_add_f32 v[236:237], v[214:215], v[216:217]
		v_pk_add_f32 v[238:239], v[96:97], v[98:99]
		v_pk_add_f32 v[240:241], v[100:101], v[102:103]
		v_pk_add_f32 v[242:243], v[104:105], v[106:107]
		v_pk_add_f32 v[244:245], v[108:109], v[110:111]
		v_pk_add_f32 v[246:247], v[176:177], v[178:179]
		v_pk_add_f32 v[248:249], v[180:181], v[182:183]
		v_mov_b32_e32 v250, v189
		v_mov_b32_e32 v251, v224
		v_pk_add_f32 v[252:253], v[250:251], v[222:223]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[222:223], v[164:165], v[166:167]
		v_mov_b32_e32 v185, v223
		v_mov_b32_e32 v187, v188
		v_pk_add_f32 v[188:189], v[184:185], v[186:187]
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
		v_pk_add_f32 v[188:189], v[234:235], v[188:189]
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
		v_pk_add_f32 v[188:189], v[226:227], v[188:189]
		v_mov_b32_e32 v226, v239
		v_mov_b32_e32 v227, v228
		v_pk_add_f32 v[230:231], v[226:227], v[224:225]
		v_mov_b32_e32 v224, v229
		v_mov_b32_e32 v225, v230
		v_pk_add_f32 v[226:227], v[224:225], v[188:189]
		v_add_f32_e32 v12, v231, v226
		v_add_f32_e32 v12, v227, v12
		v_mov_b32_e32 v188, v12
		v_mov_b32_e32 v189, v12
		s_nop 1
		v_permlane32_swap_b32_e32 v188, v189
		v_add_f32_e32 v225, v188, v189
		v_sub_f32_e32 v12, v13, v8
		v_sub_f32_e32 v13, v15, v9
		v_exp_f32_e32 v14, v12
		v_exp_f32_e32 v188, v13
		v_mov_b32_e32 v15, v14
		v_pk_mul_f32 v[32:33], v[32:33], v[14:15]
		v_pk_mul_f32 v[34:35], v[34:35], v[14:15]
		v_pk_mul_f32 v[36:37], v[36:37], v[14:15]
		v_pk_mul_f32 v[38:39], v[38:39], v[14:15]
		v_pk_mul_f32 v[40:41], v[40:41], v[14:15]
		v_pk_mul_f32 v[42:43], v[42:43], v[14:15]
		v_pk_mul_f32 v[44:45], v[44:45], v[14:15]
		v_pk_mul_f32 v[46:47], v[46:47], v[14:15]
		v_pk_mul_f32 v[48:49], v[48:49], v[14:15]
		v_pk_mul_f32 v[50:51], v[50:51], v[14:15]
		v_pk_mul_f32 v[52:53], v[52:53], v[14:15]
		v_pk_mul_f32 v[54:55], v[54:55], v[14:15]
		v_pk_mul_f32 v[56:57], v[56:57], v[14:15]
		v_pk_mul_f32 v[58:59], v[58:59], v[14:15]
		v_pk_mul_f32 v[60:61], v[60:61], v[14:15]
		v_pk_mul_f32 v[62:63], v[62:63], v[14:15]
		v_mov_b32_e32 v189, v188
		v_pk_mul_f32 v[64:65], v[64:65], v[188:189]
		v_pk_mul_f32 v[66:67], v[66:67], v[188:189]
		v_pk_mul_f32 v[68:69], v[68:69], v[188:189]
		v_pk_mul_f32 v[70:71], v[70:71], v[188:189]
		v_pk_mul_f32 v[72:73], v[72:73], v[188:189]
		v_pk_mul_f32 v[74:75], v[74:75], v[188:189]
		v_pk_mul_f32 v[76:77], v[76:77], v[188:189]
		v_pk_mul_f32 v[78:79], v[78:79], v[188:189]
		v_pk_mul_f32 v[80:81], v[80:81], v[188:189]
		v_pk_mul_f32 v[82:83], v[82:83], v[188:189]
		v_pk_mul_f32 v[84:85], v[84:85], v[188:189]
		v_pk_mul_f32 v[86:87], v[86:87], v[188:189]
		v_pk_mul_f32 v[88:89], v[88:89], v[188:189]
		v_pk_mul_f32 v[90:91], v[90:91], v[188:189]
		v_pk_mul_f32 v[92:93], v[92:93], v[188:189]
		v_pk_mul_f32 v[94:95], v[94:95], v[188:189]
		v_mov_b32_e32 v12, v14
		v_mov_b32_e32 v13, v188
		v_mov_b32_e32 v224, v222
		v_mov_b64_e32 v[14:15], v[24:25]
		v_pk_fma_f32 v[24:25], v[14:15], v[12:13], v[224:225]
		v_cvt_pk_bf16_f32 v12, v190, v218
		v_cvt_pk_bf16_f32 v13, v191, v219
		v_cvt_pk_bf16_f32 v14, v18, v26
		v_cvt_pk_bf16_f32 v15, v19, v27
		v_cvt_pk_bf16_f32 v188, v28, v30
		v_cvt_pk_bf16_f32 v189, v29, v31
		v_cvt_pk_bf16_f32 v190, v112, v114
		v_cvt_pk_bf16_f32 v191, v113, v115
		v_cvt_pk_bf16_f32 v28, v116, v118
		v_cvt_pk_bf16_f32 v29, v117, v119
		v_cvt_pk_bf16_f32 v30, v120, v122
		v_cvt_pk_bf16_f32 v31, v121, v123
		v_cvt_pk_bf16_f32 v112, v124, v126
		v_cvt_pk_bf16_f32 v113, v125, v127
		v_cvt_pk_bf16_f32 v114, v128, v130
		v_cvt_pk_bf16_f32 v115, v129, v131
		v_cvt_pk_bf16_f32 v116, v132, v134
		v_cvt_pk_bf16_f32 v117, v133, v135
		v_cvt_pk_bf16_f32 v118, v136, v138
		v_cvt_pk_bf16_f32 v119, v137, v139
		v_cvt_pk_bf16_f32 v120, v140, v142
		v_cvt_pk_bf16_f32 v121, v141, v143
		v_cvt_pk_bf16_f32 v122, v144, v146
		v_cvt_pk_bf16_f32 v123, v145, v147
		v_cvt_pk_bf16_f32 v124, v148, v150
		v_cvt_pk_bf16_f32 v125, v149, v151
		v_cvt_pk_bf16_f32 v126, v152, v154
		v_cvt_pk_bf16_f32 v127, v153, v155
		v_cvt_pk_bf16_f32 v128, v156, v158
		v_cvt_pk_bf16_f32 v129, v157, v159
		v_cvt_pk_bf16_f32 v130, v160, v162
		v_cvt_pk_bf16_f32 v131, v161, v163
		v_cvt_pk_bf16_f32 v132, v165, v167
		v_cvt_pk_bf16_f32 v133, v168, v220
		v_cvt_pk_bf16_f32 v134, v169, v221
		v_cvt_pk_bf16_f32 v135, v170, v172
		v_cvt_pk_bf16_f32 v136, v171, v173
		v_cvt_pk_bf16_f32 v137, v174, v192
		v_cvt_pk_bf16_f32 v138, v175, v193
		v_cvt_pk_bf16_f32 v139, v194, v196
		v_cvt_pk_bf16_f32 v140, v195, v197
		v_cvt_pk_bf16_f32 v141, v198, v200
		v_cvt_pk_bf16_f32 v142, v199, v201
		v_cvt_pk_bf16_f32 v143, v202, v204
		v_cvt_pk_bf16_f32 v144, v203, v205
		v_cvt_pk_bf16_f32 v145, v206, v208
		v_cvt_pk_bf16_f32 v146, v207, v209
		v_cvt_pk_bf16_f32 v147, v210, v212
		v_cvt_pk_bf16_f32 v148, v211, v213
		v_cvt_pk_bf16_f32 v149, v214, v216
		v_cvt_pk_bf16_f32 v150, v215, v217
		v_cvt_pk_bf16_f32 v151, v96, v98
		v_cvt_pk_bf16_f32 v152, v97, v99
		v_cvt_pk_bf16_f32 v153, v100, v102
		v_cvt_pk_bf16_f32 v154, v101, v103
		v_cvt_pk_bf16_f32 v155, v104, v106
		v_cvt_pk_bf16_f32 v96, v105, v107
		v_cvt_pk_bf16_f32 v97, v108, v110
		v_cvt_pk_bf16_f32 v98, v109, v111
		v_cvt_pk_bf16_f32 v99, v176, v178
		v_cvt_pk_bf16_f32 v100, v177, v179
		v_cvt_pk_bf16_f32 v101, v180, v182
		v_cvt_pk_bf16_f32 v102, v181, v183
		v_cvt_pk_bf16_f32 v103, v184, v186
		v_permlane32_swap_b32_e32 v12, v14
		v_permlane32_swap_b32_e32 v13, v15
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[32:47], a[132:135], v[12:15], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[164:167], v[12:15], v[48:63]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[32:47], a[136:139], v[188:191], v[32:47]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[48:63], a[168:171], v[188:191], v[48:63]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[32:47], a[140:143], v[28:31], v[32:47]
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_mfma_f32_32x32x16_bf16 v[48:63], a[172:175], v[28:31], v[48:63]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[32:47], a[144:147], v[112:115], v[32:47]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[48:63], a[176:179], v[112:115], v[48:63]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[32:47], a[148:151], v[116:119], v[32:47]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[80:95], a[164:167], v[132:135], v[80:95]
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_mfma_f32_32x32x16_bf16 v[64:79], a[132:135], v[132:135], v[64:79]
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_mfma_f32_32x32x16_bf16 v[80:95], a[168:171], v[136:139], v[80:95]
		v_permlane32_swap_b32_e32 v148, v150
		v_permlane32_swap_b32_e32 v149, v151
		v_mfma_f32_32x32x16_bf16 v[64:79], a[136:139], v[136:139], v[64:79]
		v_permlane32_swap_b32_e32 v152, v154
		v_permlane32_swap_b32_e32 v153, v155
		v_mfma_f32_32x32x16_bf16 v[80:95], a[172:175], v[140:143], v[80:95]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[64:79], a[140:143], v[140:143], v[64:79]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[80:95], a[176:179], v[144:147], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[144:147], v[144:147], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[180:183], v[116:119], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[180:183], v[148:151], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[148:151], v[148:151], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[152:155], v[120:123], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[184:187], v[120:123], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[184:187], v[152:155], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[152:155], v[152:155], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[156:159], v[124:127], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[188:191], v[124:127], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[188:191], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[156:159], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[160:163], v[128:131], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[192:195], v[128:131], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[192:195], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[160:163], v[100:103], v[64:79]
		v_mov_b32_e32 v13, v8
		v_mov_b32_e32 v15, v9
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_3
.L_attn_fwd_persistent.loop_exit_3:
		s_mul_i32 s25, s25, 0x80
		v_readfirstlane_b32 s31, v6
		v_accvgpr_read_b32 v8, a7
		s_nop 0
		v_add_u32_e32 v8, s31, v8
		v_add_u32_e32 v8, s24, v8
		v_readfirstlane_b32 s31, v6
		v_accvgpr_read_b32 v6, a8
		s_nop 0
		v_add_u32_e32 v6, s31, v6
		v_add_u32_e32 v6, s24, v6
		v_xor_b32_e32 v9, 1, v11
		v_accvgpr_write_b32 a7, v9
		v_xor_b32_e32 v9, 2, v11
		v_accvgpr_write_b32 a8, v9
		v_xor_b32_e32 v9, 3, v11
		v_accvgpr_write_b32 a65, v9
		v_xor_b32_e32 v9, 8, v11
		v_accvgpr_write_b32 a72, v9
		v_xor_b32_e32 v9, 9, v11
		v_accvgpr_write_b32 a77, v9
		v_xor_b32_e32 v9, 10, v11
		v_accvgpr_write_b32 a78, v9
		v_xor_b32_e32 v9, 11, v11
		v_accvgpr_write_b32 a79, v9
		v_xor_b32_e32 v9, 16, v11
		v_accvgpr_write_b32 a80, v9
		v_xor_b32_e32 v9, 17, v11
		v_accvgpr_write_b32 a81, v9
		v_xor_b32_e32 v9, 18, v11
		v_accvgpr_write_b32 a82, v9
		v_xor_b32_e32 v9, 19, v11
		v_accvgpr_write_b32 a83, v9
		v_xor_b32_e32 v9, 24, v11
		v_accvgpr_write_b32 a84, v9
		v_xor_b32_e32 v9, 25, v11
		v_accvgpr_write_b32 a85, v9
		v_xor_b32_e32 v9, 26, v11
		v_accvgpr_write_b32 a86, v9
		v_xor_b32_e32 v9, 27, v11
		v_accvgpr_write_b32 a87, v9
		v_xor_b32_e32 v9, 32, v11
		v_accvgpr_write_b32 a88, v9
		v_xor_b32_e32 v9, 33, v11
		v_accvgpr_write_b32 a89, v9
		v_xor_b32_e32 v9, 34, v11
		v_accvgpr_write_b32 a90, v9
		v_xor_b32_e32 v9, 35, v11
		v_accvgpr_write_b32 a91, v9
		v_xor_b32_e32 v9, 40, v11
		v_accvgpr_write_b32 a92, v9
		v_xor_b32_e32 v9, 41, v11
		v_accvgpr_write_b32 a93, v9
		v_xor_b32_e32 v9, 42, v11
		v_accvgpr_write_b32 a94, v9
		v_xor_b32_e32 v9, 43, v11
		v_accvgpr_write_b32 a95, v9
		v_xor_b32_e32 v9, 48, v11
		v_accvgpr_write_b32 a96, v9
		v_xor_b32_e32 v9, 49, v11
		v_accvgpr_write_b32 a97, v9
		v_xor_b32_e32 v9, 50, v11
		v_accvgpr_write_b32 a98, v9
		v_xor_b32_e32 v9, 51, v11
		v_accvgpr_write_b32 a99, v9
		v_xor_b32_e32 v9, 56, v11
		v_accvgpr_write_b32 a100, v9
		v_xor_b32_e32 v9, 57, v11
		v_accvgpr_write_b32 a101, v9
		v_xor_b32_e32 v9, 58, v11
		v_accvgpr_write_b32 a102, v9
		v_xor_b32_e32 v9, 59, v11
		v_accvgpr_write_b32 a103, v9
		v_xor_b32_e32 v9, 64, v11
		v_accvgpr_write_b32 a104, v9
		v_xor_b32_e32 v9, 0x41, v11
		v_accvgpr_write_b32 a105, v9
		v_xor_b32_e32 v9, 0x42, v11
		v_accvgpr_write_b32 a106, v9
		v_xor_b32_e32 v9, 0x43, v11
		v_accvgpr_write_b32 a107, v9
		v_xor_b32_e32 v9, 0x48, v11
		v_accvgpr_write_b32 a108, v9
		v_xor_b32_e32 v9, 0x49, v11
		v_accvgpr_write_b32 a109, v9
		v_xor_b32_e32 v9, 0x4a, v11
		v_accvgpr_write_b32 a110, v9
		v_xor_b32_e32 v9, 0x4b, v11
		v_accvgpr_write_b32 a111, v9
		v_xor_b32_e32 v9, 0x50, v11
		v_accvgpr_write_b32 a112, v9
		v_xor_b32_e32 v9, 0x51, v11
		v_accvgpr_write_b32 a113, v9
		v_xor_b32_e32 v9, 0x52, v11
		v_accvgpr_write_b32 a114, v9
		v_xor_b32_e32 v9, 0x53, v11
		v_accvgpr_write_b32 a115, v9
		v_xor_b32_e32 v9, 0x58, v11
		v_accvgpr_write_b32 a116, v9
		v_xor_b32_e32 v9, 0x59, v11
		v_accvgpr_write_b32 a117, v9
		v_xor_b32_e32 v9, 0x5a, v11
		v_accvgpr_write_b32 a118, v9
		v_xor_b32_e32 v9, 0x5b, v11
		v_accvgpr_write_b32 a119, v9
		v_xor_b32_e32 v9, 0x60, v11
		v_accvgpr_write_b32 a120, v9
		v_xor_b32_e32 v9, 0x61, v11
		v_accvgpr_write_b32 a121, v9
		v_xor_b32_e32 v9, 0x62, v11
		v_accvgpr_write_b32 a122, v9
		v_xor_b32_e32 v9, 0x63, v11
		v_accvgpr_write_b32 a123, v9
		v_xor_b32_e32 v9, 0x68, v11
		v_accvgpr_write_b32 a124, v9
		v_xor_b32_e32 v9, 0x69, v11
		v_accvgpr_write_b32 a125, v9
		v_xor_b32_e32 v9, 0x6a, v11
		v_accvgpr_write_b32 a126, v9
		v_xor_b32_e32 v9, 0x6b, v11
		v_accvgpr_write_b32 a127, v9
		v_xor_b32_e32 v9, 0x70, v11
		v_accvgpr_write_b32 a128, v9
		v_xor_b32_e32 v9, 0x71, v11
		v_accvgpr_write_b32 a129, v9
		v_xor_b32_e32 v9, 0x72, v11
		v_accvgpr_write_b32 a130, v9
		v_xor_b32_e32 v9, 0x73, v11
		v_accvgpr_write_b32 a131, v9
		v_xor_b32_e32 v9, 0x7a, v11
		v_xor_b32_e32 v12, 0x7b, v11
		v_accvgpr_read_b32 v14, a16
		v_accvgpr_read_b32 v16, a66
		v_lshl_add_u32 v14, v14, 4, v16
		v_accvgpr_read_b32 v16, a67
		v_accvgpr_read_b32 v18, a68
		v_add3_u32 v14, v14, v16, v18
		v_accvgpr_read_b32 v16, a69
		v_accvgpr_read_b32 v18, a70
		v_add3_u32 v14, v14, v16, v18
		v_accvgpr_write_b32 a16, v14
		v_accvgpr_read_b32 v14, a71
		v_accvgpr_read_b32 v16, a73
		v_lshl_add_u32 v14, v14, 3, v16
		v_accvgpr_read_b32 v16, a74
		v_accvgpr_read_b32 v18, a56
		v_add3_u32 v14, v14, v18, v16
		v_accvgpr_write_b32 a56, v14
		s_cmp_lt_i32 s46, s25
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_4
.L_attn_fwd_persistent.loop_head_4:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s24, s46, 0x80
		s_cmp_lt_i32 s46, 0
		s_cselect_b32 s31, s30, 0
		s_add_i32 s31, s46, s31
		s_ashr_i32 s31, s31, 7
		s_cmp_lt_i32 s31, 0
		s_cselect_b32 s32, s16, 0
		s_add_i32 s32, s31, s32
		s_ashr_i32 s32, s32, 1
		s_lshl_b32 s32, s32, 1
		s_xor_b32 s32, s32, -1
		s_add_i32 s32, s32, 1
		s_add_i32 s32, s31, s32
		s_add_i32 s31, s31, 1
		s_cmp_lt_i32 s31, 0
		s_cselect_b32 s33, s16, 0
		s_add_i32 s33, s31, s33
		s_ashr_i32 s33, s33, 1
		s_lshl_b32 s33, s33, 1
		s_xor_b32 s33, s33, -1
		s_add_i32 s33, s33, 1
		s_add_i32 s48, s31, s33
		s_mul_i32 s31, 0x4100, s32
		v_accvgpr_read_b32 v14, a16
		v_add_u32_e32 v14, s31, v14
		ds_read_b128 a[68:71], v14
		ds_read_b128 a[132:135], v14 offset:32
		ds_read_b128 a[136:139], v14 offset:64
		ds_read_b128 a[140:143], v14 offset:96
		ds_read_b128 a[144:147], v14 offset:256
		ds_read_b128 a[148:151], v14 offset:288
		ds_read_b128 a[152:155], v14 offset:320
		ds_read_b128 a[156:159], v14 offset:352
		ds_read_b128 a[160:163], v14 offset:128
		ds_read_b128 a[164:167], v14 offset:160
		ds_read_b128 a[168:171], v14 offset:192
		ds_read_b128 a[172:175], v14 offset:224
		ds_read_b128 a[176:179], v14 offset:384
		ds_read_b128 a[180:183], v14 offset:416
		ds_read_b128 a[184:187], v14 offset:448
		ds_read_b128 a[188:191], v14 offset:480
		s_mul_i32 s31, 0x4400, s32
		v_accvgpr_read_b32 v14, a56
		v_add_u32_e32 v14, s31, v14
		ds_read_b64_tr_b16 a[192:193], v14 offset:33264
		ds_read_b64_tr_b16 a[194:195], v14 offset:37616
		ds_read_b64_tr_b16 a[196:197], v14 offset:33392
		ds_read_b64_tr_b16 a[198:199], v14 offset:37744
		ds_read_b64_tr_b16 a[200:201], v14 offset:33520
		ds_read_b64_tr_b16 a[202:203], v14 offset:37872
		ds_read_b64_tr_b16 a[204:205], v14 offset:33648
		ds_read_b64_tr_b16 a[206:207], v14 offset:38000
		ds_read_b64_tr_b16 a[208:209], v14 offset:33776
		ds_read_b64_tr_b16 a[210:211], v14 offset:38128
		ds_read_b64_tr_b16 a[212:213], v14 offset:33904
		ds_read_b64_tr_b16 a[214:215], v14 offset:38256
		ds_read_b64_tr_b16 a[216:217], v14 offset:34032
		ds_read_b64_tr_b16 a[218:219], v14 offset:38384
		ds_read_b64_tr_b16 a[220:221], v14 offset:34160
		ds_read_b64_tr_b16 a[222:223], v14 offset:38512
		ds_read_b64_tr_b16 a[224:225], v14 offset:33328
		ds_read_b64_tr_b16 a[226:227], v14 offset:37680
		ds_read_b64_tr_b16 a[228:229], v14 offset:33456
		ds_read_b64_tr_b16 a[230:231], v14 offset:37808
		ds_read_b64_tr_b16 a[232:233], v14 offset:33584
		ds_read_b64_tr_b16 a[234:235], v14 offset:37936
		ds_read_b64_tr_b16 a[236:237], v14 offset:33712
		ds_read_b64_tr_b16 a[238:239], v14 offset:38064
		ds_read_b64_tr_b16 a[240:241], v14 offset:33840
		ds_read_b64_tr_b16 a[242:243], v14 offset:38192
		ds_read_b64_tr_b16 a[244:245], v14 offset:33968
		ds_read_b64_tr_b16 a[246:247], v14 offset:38320
		ds_read_b64_tr_b16 a[248:249], v14 offset:34096
		ds_read_b64_tr_b16 a[250:251], v14 offset:38448
		ds_read_b64_tr_b16 a[252:253], v14 offset:34224
		ds_read_b64_tr_b16 a[254:255], v14 offset:38576
		s_cmp_lt_i32 s24, s1
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_4
		v_accvgpr_read_b32 v14, a17
		v_add_u32_e32 v14, s24, v14
		v_accvgpr_read_b32 v16, a18
		v_add_u32_e32 v16, s24, v16
		v_accvgpr_read_b32 v18, a19
		v_add_u32_e32 v18, s24, v18
		v_accvgpr_read_b32 v19, a52
		v_add_u32_e32 v19, s24, v19
		v_cmp_lt_i32_e64 vcc, v14, s22
		s_mov_b64 s[32:33], vcc
		v_cmp_lt_i32_e64 vcc, v16, s22
		s_mov_b64 s[50:51], vcc
		v_cmp_lt_i32_e64 vcc, v18, s22
		s_mov_b64 s[52:53], vcc
		v_cmp_lt_i32_e64 vcc, v19, s22
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v14, a53
		v_add_u32_e32 v14, s24, v14
		v_accvgpr_read_b32 v16, a54
		v_add_u32_e32 v16, s24, v16
		v_accvgpr_read_b32 v18, a55
		v_add_u32_e32 v18, s24, v18
		v_cmp_lt_i32_e64 vcc, v14, s22
		s_mov_b64 s[58:59], vcc
		v_cmp_lt_i32_e64 vcc, v16, s22
		s_mov_b64 s[60:61], vcc
		v_cmp_lt_i32_e64 vcc, v18, s22
		s_mov_b64 s[62:63], vcc
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s31, s15, s46
		s_lshl_b32 s31, s31, 1
		s_add_i32 s31, s47, s31
		v_accvgpr_read_b32 v14, a58
		v_add_u32_e32 v14, s31, v14
		s_mov_b32 s64, 1
		s_mov_b32 s65, 0
		s_mov_b32 s57, 0
		s_mul_i32 s66, s64, s56
		s_mul_hi_u32 s67, s64, s56
		s_mul_i32 s45, s64, s57
		s_add_i32 s67, s67, s45
		s_mul_i32 s45, s65, s56
		s_add_i32 s67, s67, s45
		s_lshr_b64 s[64:65], s[66:67], 6
		s_mov_b32 s66, 0x410
		s_mov_b32 s67, 0
		s_mul_i32 s68, s66, s64
		s_mul_hi_u32 s69, s66, s64
		s_mul_i32 s45, s66, s65
		s_add_i32 s69, s69, s45
		s_mul_i32 s45, s67, s64
		s_add_i32 s69, s69, s45
		s_cmp_lt_i32 s48, 0
		s_cselect_b32 s49, -1, 0
		s_mov_b32 s66, 0x4100
		s_mov_b32 s67, 0
		s_mul_i32 s70, s66, s48
		s_mul_hi_u32 s71, s66, s48
		s_mul_i32 s45, s66, s49
		s_add_i32 s71, s71, s45
		s_mul_i32 s45, s67, s48
		s_add_i32 s71, s71, s45
		s_add_u32 s66, s68, s70
		s_addc_u32 s67, s69, s71
		s_add_u32 s72, s66, 0
		s_addc_u32 s73, s67, 0
		s_mov_b32 m0, s72
		v_cndmask_b32_e64 v14, v23, v14, s[32:33]
		buffer_load_dwordx4 v14, s[36:39], 0 offen lds
		v_accvgpr_read_b32 v14, a59
		v_add_u32_e32 v14, s24, v14
		v_accvgpr_read_b32 v16, a60
		v_add_u32_e32 v16, s31, v16
		s_add_u32 s32, s68, 0x1040
		s_addc_u32 s33, s69, 0
		s_add_u32 s32, s32, s70
		s_addc_u32 s33, s33, s71
		s_add_u32 s66, s32, 0
		s_addc_u32 s67, s33, 0
		s_mov_b32 m0, s66
		v_cndmask_b32_e64 v16, v23, v16, s[50:51]
		buffer_load_dwordx4 v16, s[36:39], 0 offen lds
		v_accvgpr_read_b32 v16, a61
		v_add_u32_e32 v16, s31, v16
		s_add_u32 s32, s68, 0x2080
		s_addc_u32 s33, s69, 0
		s_add_u32 s32, s32, s70
		s_addc_u32 s33, s33, s71
		s_add_u32 s50, s32, 0
		s_addc_u32 s51, s33, 0
		s_mov_b32 m0, s50
		v_cndmask_b32_e64 v16, v23, v16, s[52:53]
		buffer_load_dwordx4 v16, s[36:39], 0 offen lds
		v_accvgpr_read_b32 v16, a62
		v_add_u32_e32 v16, s31, v16
		s_add_u32 s32, s68, 0x30c0
		s_addc_u32 s33, s69, 0
		s_add_u32 s32, s32, s70
		s_addc_u32 s33, s33, s71
		s_add_u32 s50, s32, 0
		s_addc_u32 s51, s33, 0
		s_mov_b32 m0, s50
		v_cndmask_b32_e64 v16, v23, v16, s[54:55]
		buffer_load_dwordx4 v16, s[36:39], 0 offen lds
		s_mul_i32 s31, s18, s46
		s_lshl_b32 s31, s31, 1
		s_add_i32 s31, s44, s31
		v_accvgpr_read_b32 v16, a63
		v_add_u32_e32 v16, s31, v16
		s_mov_b32 s32, 0x440
		s_mov_b32 s33, 0
		s_mul_i32 s50, s32, s64
		s_mul_hi_u32 s51, s32, s64
		s_mul_i32 s45, s32, s65
		s_add_i32 s51, s51, s45
		s_mul_i32 s45, s33, s64
		s_add_i32 s51, s51, s45
		s_add_u32 s32, s50, 0x81f0
		s_addc_u32 s33, s51, 0
		s_mov_b32 s52, 0x4400
		s_mov_b32 s53, 0
		s_mul_i32 s54, s52, s48
		s_mul_hi_u32 s55, s52, s48
		s_mul_i32 s45, s52, s49
		s_add_i32 s55, s55, s45
		s_mul_i32 s45, s53, s48
		s_add_i32 s55, s55, s45
		s_add_u32 s32, s32, s54
		s_addc_u32 s33, s33, s55
		s_add_u32 s48, s32, 0
		s_addc_u32 s49, s33, 0
		s_mov_b32 m0, s48
		v_cndmask_b32_e64 v16, v23, v16, s[58:59]
		buffer_load_dwordx4 v16, s[40:43], 0 offen lds
		v_accvgpr_read_b32 v16, a64
		v_add_u32_e32 v16, s31, v16
		s_add_u32 s32, s50, 0x92f0
		s_addc_u32 s33, s51, 0
		s_add_u32 s32, s32, s54
		s_addc_u32 s33, s33, s55
		s_add_u32 s48, s32, 0
		s_addc_u32 s49, s33, 0
		s_mov_b32 m0, s48
		v_cndmask_b32_e64 v16, v23, v16, s[60:61]
		buffer_load_dwordx4 v16, s[40:43], 0 offen lds
		v_add_u32_e32 v16, s31, v7
		s_add_u32 s32, s50, 0xa3f0
		s_addc_u32 s33, s51, 0
		s_add_u32 s32, s32, s54
		s_addc_u32 s33, s33, s55
		s_add_u32 s48, s32, 0
		s_addc_u32 s49, s33, 0
		s_mov_b32 m0, s48
		v_cndmask_b32_e64 v16, v23, v16, s[62:63]
		buffer_load_dwordx4 v16, s[40:43], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v14, s22
		v_add_u32_e32 v14, s31, v5
		s_add_u32 s32, s50, 0xb4f0
		s_addc_u32 s33, s51, 0
		v_cndmask_b32_e32 v14, v23, v14, vcc
		s_add_u32 s32, s32, s54
		s_addc_u32 s33, s33, s55
		s_add_u32 s48, s32, 0
		s_addc_u32 s49, s33, 0
		s_mov_b32 m0, s48
		s_nop 0
		buffer_load_dwordx4 v14, s[40:43], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_4
.L_attn_fwd_persistent.if_else_4:
.L_attn_fwd_persistent.if_end_4:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[96:111], a[68:71], a[20:23], 0
		v_add_u32_e32 v14, s46, v11
		v_accvgpr_read_b32 v16, a7
		v_add_u32_e32 v16, s46, v16
		v_accvgpr_read_b32 v18, a8
		v_add_u32_e32 v18, s46, v18
		v_accvgpr_read_b32 v19, a65
		v_add_u32_e32 v19, s46, v19
		v_accvgpr_read_b32 v20, a78
		v_add_u32_e32 v20, s46, v20
		v_accvgpr_read_b32 v21, a79
		v_add_u32_e32 v21, s46, v21
		v_accvgpr_read_b32 v22, a82
		v_add_u32_e32 v22, s46, v22
		v_mfma_f32_32x32x16_bf16 v[112:127], a[144:147], a[20:23], 0
		v_accvgpr_read_b32 v26, a83
		v_add_u32_e32 v26, s46, v26
		v_accvgpr_read_b32 v27, a86
		v_add_u32_e32 v27, s46, v27
		v_accvgpr_read_b32 v28, a87
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_read_b32 v29, a90
		v_add_u32_e32 v29, s46, v29
		v_accvgpr_read_b32 v30, a91
		v_add_u32_e32 v30, s46, v30
		v_accvgpr_read_b32 v31, a94
		v_add_u32_e32 v31, s46, v31
		v_accvgpr_read_b32 v128, a95
		v_add_u32_e32 v128, s46, v128
		v_mfma_f32_32x32x16_bf16 v[144:159], a[160:163], a[20:23], 0
		v_accvgpr_read_b32 v129, a98
		v_add_u32_e32 v129, s46, v129
		v_accvgpr_read_b32 v130, a99
		v_add_u32_e32 v130, s46, v130
		v_accvgpr_read_b32 v131, a102
		v_add_u32_e32 v131, s46, v131
		v_accvgpr_read_b32 v132, a103
		v_add_u32_e32 v132, s46, v132
		v_accvgpr_read_b32 v133, a106
		v_add_u32_e32 v133, s46, v133
		v_accvgpr_read_b32 v134, a107
		v_add_u32_e32 v134, s46, v134
		v_accvgpr_read_b32 v135, a110
		v_add_u32_e32 v135, s46, v135
		v_mfma_f32_32x32x16_bf16 v[160:175], a[176:179], a[20:23], 0
		v_accvgpr_read_b32 v136, a111
		v_add_u32_e32 v136, s46, v136
		v_accvgpr_read_b32 v137, a114
		v_add_u32_e32 v137, s46, v137
		v_accvgpr_read_b32 v138, a115
		v_add_u32_e32 v138, s46, v138
		v_accvgpr_read_b32 v139, a118
		v_add_u32_e32 v139, s46, v139
		v_accvgpr_read_b32 v140, a119
		v_add_u32_e32 v140, s46, v140
		v_accvgpr_read_b32 v141, a122
		v_add_u32_e32 v141, s46, v141
		v_accvgpr_write_b32 a66, v141
		v_accvgpr_read_b32 v141, a123
		v_add_u32_e32 v141, s46, v141
		v_accvgpr_write_b32 a67, v141
		v_mfma_f32_32x32x16_bf16 v[176:191], a[176:179], a[36:39], 0
		v_accvgpr_read_b32 v141, a126
		v_add_u32_e32 v141, s46, v141
		v_accvgpr_write_b32 a73, v141
		v_accvgpr_read_b32 v141, a127
		v_add_u32_e32 v141, s46, v141
		v_accvgpr_write_b32 a74, v141
		v_accvgpr_read_b32 v141, a130
		v_add_u32_e32 v141, s46, v141
		v_accvgpr_write_b32 a176, v141
		v_accvgpr_read_b32 v141, a131
		v_add_u32_e32 v141, s46, v141
		v_accvgpr_write_b32 a177, v141
		v_add_u32_e32 v141, s46, v9
		v_accvgpr_write_b32 a178, v141
		v_add_u32_e32 v141, s46, v12
		v_accvgpr_write_b32 a179, v141
		v_cmp_ge_i32_e64 vcc, v8, v14
		s_mov_b64 s[32:33], vcc
		v_mfma_f32_32x32x16_bf16 v[192:207], a[68:71], a[36:39], 0
		v_cmp_ge_i32_e64 vcc, v8, v16
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v8, v18
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v8, v19
		v_accvgpr_read_b32 v14, a72
		v_add_u32_e32 v14, s46, v14
		v_accvgpr_read_b32 v141, a77
		v_add_u32_e32 v141, s46, v141
		v_accvgpr_read_b32 v142, a80
		v_add_u32_e32 v142, s46, v142
		v_accvgpr_read_b32 v143, a81
		v_add_u32_e32 v143, s46, v143
		v_mfma_f32_32x32x16_bf16 v[208:223], a[144:147], a[36:39], 0
		v_accvgpr_read_b32 v224, a84
		v_add_u32_e32 v224, s46, v224
		v_accvgpr_read_b32 v225, a85
		v_add_u32_e32 v225, s46, v225
		v_accvgpr_read_b32 v226, a88
		v_add_u32_e32 v226, s46, v226
		v_accvgpr_read_b32 v227, a89
		v_add_u32_e32 v227, s46, v227
		v_accvgpr_read_b32 v228, a92
		v_add_u32_e32 v228, s46, v228
		v_accvgpr_read_b32 v229, a93
		v_add_u32_e32 v229, s46, v229
		v_accvgpr_read_b32 v230, a96
		v_add_u32_e32 v230, s46, v230
		v_mfma_f32_32x32x16_bf16 v[240:255], a[160:163], a[36:39], 0
		v_accvgpr_read_b32 v231, a97
		v_add_u32_e32 v231, s46, v231
		v_accvgpr_read_b32 v232, a100
		v_add_u32_e32 v232, s46, v232
		v_accvgpr_read_b32 v233, a101
		v_add_u32_e32 v233, s46, v233
		v_accvgpr_write_b32 a68, v233
		v_accvgpr_read_b32 v233, a104
		v_add_u32_e32 v233, s46, v233
		v_accvgpr_write_b32 a69, v233
		v_accvgpr_read_b32 v233, a105
		v_add_u32_e32 v233, s46, v233
		v_accvgpr_write_b32 a70, v233
		v_accvgpr_read_b32 v233, a108
		v_add_u32_e32 v233, s46, v233
		v_accvgpr_write_b32 a71, v233
		v_accvgpr_read_b32 v233, a109
		v_add_u32_e32 v233, s46, v233
		v_accvgpr_write_b32 a144, v233
		v_mfma_f32_32x32x16_bf16 v[96:111], a[132:135], a[24:27], v[96:111]
		v_accvgpr_read_b32 v233, a112
		v_add_u32_e32 v233, s46, v233
		v_accvgpr_write_b32 a145, v233
		v_accvgpr_read_b32 v233, a113
		v_add_u32_e32 v233, s46, v233
		v_accvgpr_write_b32 a146, v233
		v_accvgpr_read_b32 v233, a116
		v_add_u32_e32 v233, s46, v233
		v_accvgpr_write_b32 a147, v233
		v_accvgpr_read_b32 v233, a117
		v_add_u32_e32 v233, s46, v233
		v_accvgpr_write_b32 a160, v233
		v_accvgpr_read_b32 v233, a120
		v_add_u32_e32 v233, s46, v233
		v_accvgpr_write_b32 a161, v233
		v_accvgpr_read_b32 v233, a121
		v_add_u32_e32 v233, s46, v233
		v_accvgpr_write_b32 a162, v233
		v_accvgpr_read_b32 v233, a124
		v_add_u32_e32 v233, s46, v233
		v_accvgpr_write_b32 a163, v233
		v_mfma_f32_32x32x16_bf16 v[112:127], a[148:151], a[24:27], v[112:127]
		v_accvgpr_read_b32 v233, a125
		v_add_u32_e32 v233, s46, v233
		v_accvgpr_read_b32 v234, a128
		v_add_u32_e32 v234, s46, v234
		v_accvgpr_read_b32 v235, a129
		v_add_u32_e32 v235, s46, v235
		v_mov_b32_e32 v236, 4
		v_mul_lo_u32 v236, v236, v10
		v_xor_b32_e32 v236, 0x79, v236
		v_add_u32_e32 v236, s46, v236
		v_mfma_f32_32x32x16_bf16 v[144:159], a[164:167], a[24:27], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[24:27], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[180:183], a[40:43], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[132:135], a[40:43], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[148:151], a[40:43], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[164:167], a[40:43], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[136:139], a[28:31], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[152:155], a[28:31], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[168:171], a[28:31], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[184:187], a[28:31], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[184:187], a[44:47], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[136:139], a[44:47], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[152:155], a[44:47], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[168:171], a[44:47], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[140:143], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[156:159], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[172:175], a[32:35], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[188:191], a[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[188:191], a[48:51], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[140:143], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[156:159], a[48:51], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[172:175], a[48:51], v[240:255]
		s_cmp_lt_i32 s24, s25
		v_mov_b32_e32 v237, 0xff800000
		v_accvgpr_write_b32 a132, v237
		v_accvgpr_read_b32 v237, a132
		s_nop 0
		v_cndmask_b32_e32 v99, v237, v99, vcc
		v_accvgpr_write_b32 a135, v99
		v_cmp_ge_i32_e64 vcc, v8, v14
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v8, v141
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v8, v20
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v8, v21
		v_accvgpr_read_b32 v99, a132
		v_cndmask_b32_e64 v96, v99, v96, s[32:33]
		v_accvgpr_write_b32 a136, v96
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v96, v96, v97, s[48:49]
		v_accvgpr_write_b32 a137, v96
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e32 v96, v96, v103, vcc
		v_accvgpr_write_b32 a139, v96
		v_cmp_ge_i32_e64 vcc, v8, v142
		s_mov_b64 s[32:33], vcc
		v_cmp_ge_i32_e64 vcc, v8, v143
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v8, v22
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v8, v26
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v96, v96, v98, s[50:51]
		v_accvgpr_write_b32 a134, v96
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v98, v96, v100, s[52:53]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e32 v96, v96, v107, vcc
		v_accvgpr_write_b32 a141, v96
		v_cmp_ge_i32_e64 vcc, v8, v224
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v8, v225
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v8, v27
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v8, v28
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v99, v96, v101, s[54:55]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v96, v96, v102, s[58:59]
		v_accvgpr_write_b32 a138, v96
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e32 v101, v96, v111, vcc
		v_cmp_ge_i32_e64 vcc, v8, v226
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v8, v227
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v8, v29
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v8, v30
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v102, v96, v104, s[32:33]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v103, v96, v105, s[48:49]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e32 v96, v96, v115, vcc
		v_accvgpr_write_b32 a143, v96
		v_cmp_ge_i32_e64 vcc, v8, v228
		s_mov_b64 s[32:33], vcc
		v_cmp_ge_i32_e64 vcc, v8, v229
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v8, v31
		s_mov_b64 s[66:67], vcc
		v_cmp_ge_i32_e64 vcc, v8, v128
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v96, v96, v106, s[60:61]
		v_accvgpr_write_b32 a140, v96
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v104, v96, v108, s[50:51]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e32 v96, v96, v119, vcc
		v_accvgpr_write_b32 a149, v96
		v_cmp_ge_i32_e64 vcc, v8, v230
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v8, v231
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v8, v129
		s_mov_b64 s[68:69], vcc
		v_cmp_ge_i32_e64 vcc, v8, v130
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v105, v96, v109, s[52:53]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v100, v96, v110, s[62:63]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e32 v107, v96, v123, vcc
		v_cmp_ge_i32_e64 vcc, v8, v232
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v96, a68
		v_cmp_ge_i32_e64 vcc, v8, v96
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v8, v131
		s_mov_b64 s[70:71], vcc
		v_cmp_ge_i32_e64 vcc, v8, v132
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v108, v96, v112, s[54:55]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v109, v96, v113, s[58:59]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e32 v111, v96, v127, vcc
		v_accvgpr_read_b32 v96, a69
		v_cmp_ge_i32_e64 vcc, v8, v96
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v96, a70
		v_cmp_ge_i32_e64 vcc, v8, v96
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v8, v133
		s_mov_b64 s[72:73], vcc
		v_cmp_ge_i32_e64 vcc, v8, v134
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v96, v96, v114, s[64:65]
		v_accvgpr_write_b32 a142, v96
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v112, v96, v116, s[32:33]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e32 v115, v96, v147, vcc
		v_accvgpr_read_b32 v96, a71
		v_cmp_ge_i32_e64 vcc, v8, v96
		s_mov_b64 s[32:33], vcc
		v_accvgpr_read_b32 v96, a144
		v_cmp_ge_i32_e64 vcc, v8, v96
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v8, v135
		s_mov_b64 s[74:75], vcc
		v_cmp_ge_i32_e64 vcc, v8, v136
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v113, v96, v117, s[48:49]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v96, v96, v118, s[66:67]
		v_accvgpr_write_b32 a148, v96
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e32 v117, v96, v151, vcc
		v_accvgpr_read_b32 v96, a145
		v_cmp_ge_i32_e64 vcc, v8, v96
		s_mov_b64 s[48:49], vcc
		v_accvgpr_read_b32 v96, a146
		v_cmp_ge_i32_e64 vcc, v8, v96
		s_mov_b64 s[66:67], vcc
		v_cmp_ge_i32_e64 vcc, v8, v137
		s_mov_b64 s[76:77], vcc
		v_cmp_ge_i32_e64 vcc, v8, v138
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v96, v96, v120, s[50:51]
		v_accvgpr_write_b32 a150, v96
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v96, v96, v121, s[60:61]
		v_accvgpr_write_b32 a151, v96
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e32 v119, v96, v155, vcc
		v_accvgpr_read_b32 v96, a147
		v_cmp_ge_i32_e64 vcc, v8, v96
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v96, a160
		v_cmp_ge_i32_e64 vcc, v8, v96
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v8, v139
		s_mov_b64 s[78:79], vcc
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v121, v96, v157, s[60:61]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v238, v96, v158, s[78:79]
		v_cmp_ge_i32_e64 vcc, v8, v140
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v106, v96, v122, s[68:69]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v122, v96, v124, s[52:53]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e32 v239, v96, v159, vcc
		v_accvgpr_read_b32 v96, a161
		v_cmp_ge_i32_e64 vcc, v8, v96
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v96, a162
		v_cmp_ge_i32_e64 vcc, v8, v96
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v96, a66
		v_cmp_ge_i32_e64 vcc, v8, v96
		s_mov_b64 s[68:69], vcc
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v158, v96, v160, s[52:53]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v159, v96, v161, s[60:61]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v160, v96, v162, s[68:69]
		v_accvgpr_read_b32 v96, a67
		v_cmp_ge_i32_e64 vcc, v8, v96
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v123, v96, v125, s[62:63]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v110, v96, v126, s[70:71]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e32 v161, v96, v163, vcc
		v_accvgpr_read_b32 v96, a163
		v_cmp_ge_i32_e64 vcc, v8, v96
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v8, v233
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v96, a73
		v_cmp_ge_i32_e64 vcc, v8, v96
		s_mov_b64 s[62:63], vcc
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v124, v96, v164, s[52:53]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v125, v96, v165, s[60:61]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v126, v96, v166, s[62:63]
		v_accvgpr_read_b32 v96, a74
		v_cmp_ge_i32_e64 vcc, v8, v96
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v162, v96, v144, s[54:55]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v163, v96, v145, s[58:59]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e32 v127, v96, v167, vcc
		v_cmp_ge_i32_e64 vcc, v8, v234
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v8, v235
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v96, a176
		v_cmp_ge_i32_e64 vcc, v8, v96
		s_mov_b64 s[58:59], vcc
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v144, v96, v168, s[52:53]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v145, v96, v169, s[54:55]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v164, v96, v170, s[58:59]
		v_accvgpr_read_b32 v96, a177
		v_cmp_ge_i32_e64 vcc, v8, v96
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v114, v96, v146, s[72:73]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v146, v96, v148, s[32:33]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e32 v165, v96, v171, vcc
		v_mov_b32_e32 v96, 4
		v_mul_lo_u32 v96, v96, v10
		v_xor_b32_e32 v96, 0x78, v96
		v_add_u32_e32 v96, s46, v96
		v_cmp_ge_i32_e64 vcc, v8, v96
		s_mov_b64 s[32:33], vcc
		v_cmp_ge_i32_e64 vcc, v8, v236
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v97, a178
		v_cmp_ge_i32_e64 vcc, v8, v97
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v97, a132
		v_cndmask_b32_e64 v166, v97, v172, s[32:33]
		v_accvgpr_read_b32 v97, a132
		v_cndmask_b32_e64 v167, v97, v173, s[52:53]
		v_accvgpr_read_b32 v97, a132
		v_cndmask_b32_e64 v168, v97, v174, s[54:55]
		v_accvgpr_read_b32 v97, a179
		v_cmp_ge_i32_e64 vcc, v8, v97
		v_accvgpr_read_b32 v97, a132
		v_cndmask_b32_e64 v147, v97, v149, s[64:65]
		v_accvgpr_read_b32 v97, a132
		v_cndmask_b32_e64 v116, v97, v150, s[74:75]
		v_accvgpr_read_b32 v97, a132
		v_cndmask_b32_e32 v169, v97, v175, vcc
		v_mov_b32_e32 v97, 4
		v_mul_lo_u32 v97, v97, v10
		v_add_u32_e32 v97, s46, v97
		v_cmp_ge_i32_e64 vcc, v6, v97
		s_mov_b64 s[32:33], vcc
		v_cmp_ge_i32_e64 vcc, v6, v16
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v6, v18
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v16, a132
		v_cndmask_b32_e64 v148, v16, v192, s[32:33]
		v_accvgpr_read_b32 v16, a132
		v_cndmask_b32_e64 v149, v16, v193, s[52:53]
		v_accvgpr_read_b32 v16, a132
		v_cndmask_b32_e64 v150, v16, v194, s[54:55]
		v_cmp_ge_i32_e64 vcc, v6, v19
		v_accvgpr_read_b32 v16, a132
		v_cndmask_b32_e64 v18, v16, v152, s[48:49]
		v_accvgpr_read_b32 v16, a132
		v_cndmask_b32_e64 v19, v16, v153, s[66:67]
		v_accvgpr_read_b32 v16, a132
		v_cndmask_b32_e32 v151, v16, v195, vcc
		v_cmp_ge_i32_e64 vcc, v6, v14
		s_mov_b64 s[32:33], vcc
		v_cmp_ge_i32_e64 vcc, v6, v141
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v6, v20
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v14, a132
		v_cndmask_b32_e64 v152, v14, v196, s[32:33]
		v_accvgpr_read_b32 v14, a132
		v_cndmask_b32_e64 v153, v14, v197, s[48:49]
		v_accvgpr_read_b32 v14, a132
		v_cndmask_b32_e64 v170, v14, v198, s[52:53]
		v_cmp_ge_i32_e64 vcc, v6, v21
		v_accvgpr_read_b32 v14, a132
		v_cndmask_b32_e64 v118, v14, v154, s[76:77]
		v_accvgpr_read_b32 v14, a132
		v_cndmask_b32_e64 v120, v14, v156, s[50:51]
		v_accvgpr_read_b32 v14, a132
		v_cndmask_b32_e32 v171, v14, v199, vcc
		v_cmp_ge_i32_e64 vcc, v6, v142
		s_mov_b64 s[32:33], vcc
		v_cmp_ge_i32_e64 vcc, v6, v143
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v6, v22
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v14, a132
		v_cndmask_b32_e64 v20, v14, v200, s[32:33]
		v_accvgpr_read_b32 v14, a132
		v_cndmask_b32_e64 v21, v14, v201, s[48:49]
		v_accvgpr_read_b32 v14, a132
		v_cndmask_b32_e64 v142, v14, v202, s[50:51]
		v_cmp_ge_i32_e64 vcc, v6, v26
		v_accvgpr_read_b32 v14, a134
		v_accvgpr_read_b32 v16, a136
		v_accvgpr_read_b32 v22, a137
		v_max3_f32 v14, v16, v22, v14
		v_accvgpr_read_b32 v16, a138
		v_max3_f32 v16, v98, v99, v16
		v_accvgpr_read_b32 v22, a132
		v_cndmask_b32_e32 v143, v22, v203, vcc
		v_cmp_ge_i32_e64 vcc, v6, v224
		s_mov_b64 s[32:33], vcc
		v_cmp_ge_i32_e64 vcc, v6, v225
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v6, v27
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v22, a132
		v_cndmask_b32_e64 v26, v22, v204, s[32:33]
		v_accvgpr_read_b32 v22, a132
		v_cndmask_b32_e64 v27, v22, v205, s[48:49]
		v_accvgpr_read_b32 v22, a132
		v_cndmask_b32_e64 v154, v22, v206, s[50:51]
		v_cmp_ge_i32_e64 vcc, v6, v28
		v_accvgpr_read_b32 v22, a140
		v_max3_f32 v22, v102, v103, v22
		v_max3_f32 v28, v104, v105, v100
		v_accvgpr_read_b32 v97, a132
		v_cndmask_b32_e32 v155, v97, v207, vcc
		v_cmp_ge_i32_e64 vcc, v6, v226
		s_mov_b64 s[32:33], vcc
		v_cmp_ge_i32_e64 vcc, v6, v227
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v6, v29
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v29, a132
		v_cndmask_b32_e64 v156, v29, v208, s[32:33]
		v_accvgpr_read_b32 v29, a132
		v_cndmask_b32_e64 v157, v29, v209, s[48:49]
		v_accvgpr_read_b32 v29, a132
		v_cndmask_b32_e64 v172, v29, v210, s[50:51]
		v_cmp_ge_i32_e64 vcc, v6, v30
		v_accvgpr_read_b32 v29, a142
		v_max3_f32 v29, v108, v109, v29
		v_accvgpr_read_b32 v30, a148
		v_max3_f32 v30, v112, v113, v30
		v_accvgpr_read_b32 v97, a132
		v_cndmask_b32_e32 v173, v97, v211, vcc
		v_cmp_ge_i32_e64 vcc, v6, v228
		s_mov_b64 s[32:33], vcc
		v_cmp_ge_i32_e64 vcc, v6, v229
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v6, v31
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v31, a132
		v_cndmask_b32_e64 v174, v31, v212, s[32:33]
		v_accvgpr_read_b32 v31, a132
		v_cndmask_b32_e64 v175, v31, v213, s[48:49]
		v_accvgpr_read_b32 v31, a132
		v_cndmask_b32_e64 v192, v31, v214, s[50:51]
		v_cmp_ge_i32_e64 vcc, v6, v128
		v_accvgpr_read_b32 v31, a150
		v_accvgpr_read_b32 v97, a151
		v_max3_f32 v31, v31, v97, v106
		v_max3_f32 v97, v122, v123, v110
		v_accvgpr_read_b32 v128, a132
		v_cndmask_b32_e32 v193, v128, v215, vcc
		v_cmp_ge_i32_e64 vcc, v6, v230
		s_mov_b64 s[32:33], vcc
		v_cmp_ge_i32_e64 vcc, v6, v231
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v6, v129
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v128, a132
		v_cndmask_b32_e64 v194, v128, v216, s[32:33]
		v_accvgpr_read_b32 v128, a132
		v_cndmask_b32_e64 v195, v128, v217, s[48:49]
		v_accvgpr_read_b32 v128, a132
		v_cndmask_b32_e64 v196, v128, v218, s[50:51]
		v_cmp_ge_i32_e64 vcc, v6, v130
		v_max3_f32 v128, v162, v163, v114
		v_max3_f32 v129, v146, v147, v116
		v_accvgpr_read_b32 v130, a132
		v_cndmask_b32_e32 v197, v130, v219, vcc
		v_cmp_ge_i32_e64 vcc, v6, v232
		s_mov_b64 s[32:33], vcc
		v_accvgpr_read_b32 v130, a68
		v_cmp_ge_i32_e64 vcc, v6, v130
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v6, v131
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v130, a132
		v_cndmask_b32_e64 v198, v130, v220, s[32:33]
		v_accvgpr_read_b32 v130, a132
		v_cndmask_b32_e64 v199, v130, v221, s[48:49]
		v_accvgpr_read_b32 v130, a132
		v_cndmask_b32_e64 v200, v130, v222, s[50:51]
		v_cmp_ge_i32_e64 vcc, v6, v132
		v_max3_f32 v130, v18, v19, v118
		v_max3_f32 v131, v120, v121, v238
		v_accvgpr_read_b32 v132, a132
		v_cndmask_b32_e32 v201, v132, v223, vcc
		v_accvgpr_read_b32 v132, a69
		v_cmp_ge_i32_e64 vcc, v6, v132
		s_mov_b64 s[32:33], vcc
		v_accvgpr_read_b32 v132, a70
		v_cmp_ge_i32_e64 vcc, v6, v132
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v6, v133
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v132, a132
		v_cndmask_b32_e64 v202, v132, v240, s[32:33]
		v_accvgpr_read_b32 v132, a132
		v_cndmask_b32_e64 v203, v132, v241, s[48:49]
		v_accvgpr_read_b32 v132, a132
		v_cndmask_b32_e64 v204, v132, v242, s[50:51]
		v_cmp_ge_i32_e64 vcc, v6, v134
		v_max3_f32 v132, v158, v159, v160
		v_max3_f32 v133, v124, v125, v126
		v_accvgpr_read_b32 v134, a132
		v_cndmask_b32_e32 v205, v134, v243, vcc
		v_accvgpr_read_b32 v134, a71
		v_cmp_ge_i32_e64 vcc, v6, v134
		s_mov_b64 s[32:33], vcc
		v_accvgpr_read_b32 v134, a144
		v_cmp_ge_i32_e64 vcc, v6, v134
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v6, v135
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v134, a132
		v_cndmask_b32_e64 v206, v134, v244, s[32:33]
		v_accvgpr_read_b32 v134, a132
		v_cndmask_b32_e64 v207, v134, v245, s[48:49]
		v_accvgpr_read_b32 v134, a132
		v_cndmask_b32_e64 v208, v134, v246, s[50:51]
		v_cmp_ge_i32_e64 vcc, v6, v136
		v_max3_f32 v134, v144, v145, v164
		v_max3_f32 v135, v166, v167, v168
		v_accvgpr_read_b32 v136, a132
		v_cndmask_b32_e32 v209, v136, v247, vcc
		v_accvgpr_read_b32 v136, a145
		v_cmp_ge_i32_e64 vcc, v6, v136
		s_mov_b64 s[32:33], vcc
		v_accvgpr_read_b32 v136, a146
		v_cmp_ge_i32_e64 vcc, v6, v136
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v6, v137
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v136, a132
		v_cndmask_b32_e64 v210, v136, v248, s[32:33]
		v_accvgpr_read_b32 v136, a132
		v_cndmask_b32_e64 v211, v136, v249, s[48:49]
		v_accvgpr_read_b32 v136, a132
		v_cndmask_b32_e64 v212, v136, v250, s[50:51]
		v_cmp_ge_i32_e64 vcc, v6, v138
		v_accvgpr_read_b32 v136, a135
		v_max3_f32 v14, v14, v136, v16
		v_accvgpr_read_b32 v16, a141
		v_max3_f32 v16, v22, v16, v28
		v_accvgpr_read_b32 v22, a132
		v_cndmask_b32_e32 v213, v22, v251, vcc
		v_accvgpr_read_b32 v22, a147
		v_cmp_ge_i32_e64 vcc, v6, v22
		s_mov_b64 s[32:33], vcc
		v_accvgpr_read_b32 v22, a160
		v_cmp_ge_i32_e64 vcc, v6, v22
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v6, v139
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v22, a132
		v_cndmask_b32_e64 v136, v22, v252, s[32:33]
		v_accvgpr_read_b32 v22, a132
		v_cndmask_b32_e64 v137, v22, v253, s[48:49]
		v_accvgpr_read_b32 v22, a132
		v_cndmask_b32_e64 v138, v22, v254, s[50:51]
		v_cmp_ge_i32_e64 vcc, v6, v140
		v_accvgpr_read_b32 v22, a143
		v_max3_f32 v22, v29, v22, v30
		v_max3_f32 v28, v31, v107, v97
		v_accvgpr_read_b32 v29, a132
		v_cndmask_b32_e32 v139, v29, v255, vcc
		v_accvgpr_read_b32 v29, a161
		v_cmp_ge_i32_e64 vcc, v6, v29
		s_mov_b64 s[32:33], vcc
		v_accvgpr_read_b32 v29, a162
		v_cmp_ge_i32_e64 vcc, v6, v29
		s_mov_b64 s[48:49], vcc
		v_accvgpr_read_b32 v29, a66
		v_cmp_ge_i32_e64 vcc, v6, v29
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v29, a132
		v_cndmask_b32_e64 v30, v29, v176, s[32:33]
		v_accvgpr_read_b32 v29, a132
		v_cndmask_b32_e64 v31, v29, v177, s[48:49]
		v_accvgpr_read_b32 v29, a132
		v_cndmask_b32_e64 v140, v29, v178, s[50:51]
		v_accvgpr_read_b32 v29, a67
		v_cmp_ge_i32_e64 vcc, v6, v29
		v_max3_f32 v29, v128, v115, v129
		v_max3_f32 v97, v130, v119, v131
		v_accvgpr_read_b32 v128, a132
		v_cndmask_b32_e32 v141, v128, v179, vcc
		v_accvgpr_read_b32 v128, a163
		v_cmp_ge_i32_e64 vcc, v6, v128
		s_mov_b64 s[32:33], vcc
		v_cmp_ge_i32_e64 vcc, v6, v233
		s_mov_b64 s[48:49], vcc
		v_accvgpr_read_b32 v128, a73
		v_cmp_ge_i32_e64 vcc, v6, v128
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v128, a132
		v_cndmask_b32_e64 v130, v128, v180, s[32:33]
		v_accvgpr_read_b32 v128, a132
		v_cndmask_b32_e64 v131, v128, v181, s[48:49]
		v_accvgpr_read_b32 v128, a132
		v_cndmask_b32_e64 v176, v128, v182, s[50:51]
		v_accvgpr_read_b32 v128, a74
		v_cmp_ge_i32_e64 vcc, v6, v128
		v_max3_f32 v128, v132, v161, v133
		v_max3_f32 v129, v134, v165, v135
		v_accvgpr_read_b32 v132, a132
		v_cndmask_b32_e32 v177, v132, v183, vcc
		v_cmp_ge_i32_e64 vcc, v6, v234
		s_mov_b64 s[32:33], vcc
		v_cmp_ge_i32_e64 vcc, v6, v235
		s_mov_b64 s[48:49], vcc
		v_accvgpr_read_b32 v132, a176
		v_cmp_ge_i32_e64 vcc, v6, v132
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v132, a132
		v_cndmask_b32_e64 v134, v132, v184, s[32:33]
		v_accvgpr_read_b32 v132, a132
		v_cndmask_b32_e64 v135, v132, v185, s[48:49]
		v_accvgpr_read_b32 v132, a132
		v_cndmask_b32_e64 v178, v132, v186, s[50:51]
		v_accvgpr_read_b32 v132, a177
		v_cmp_ge_i32_e64 vcc, v6, v132
		v_accvgpr_read_b32 v132, a139
		v_max3_f32 v14, v14, v132, v16
		v_accvgpr_read_b32 v16, a149
		v_max3_f32 v16, v22, v16, v28
		v_accvgpr_read_b32 v22, a132
		v_cndmask_b32_e32 v179, v22, v187, vcc
		v_cmp_ge_i32_e64 vcc, v6, v96
		s_mov_b64 s[32:33], vcc
		v_cmp_ge_i32_e64 vcc, v6, v236
		s_mov_b64 s[48:49], vcc
		v_accvgpr_read_b32 v22, a178
		v_cmp_ge_i32_e64 vcc, v6, v22
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v22, a132
		v_cndmask_b32_e64 v132, v22, v188, s[32:33]
		v_accvgpr_read_b32 v22, a132
		v_cndmask_b32_e64 v133, v22, v189, s[48:49]
		v_accvgpr_read_b32 v22, a132
		v_cndmask_b32_e64 v180, v22, v190, s[50:51]
		v_accvgpr_read_b32 v22, a179
		v_cmp_ge_i32_e64 vcc, v6, v22
		v_max3_f32 v22, v29, v117, v97
		v_max3_f32 v28, v128, v127, v129
		v_accvgpr_read_b32 v29, a132
		v_cndmask_b32_e32 v181, v29, v191, vcc
		v_max3_f32 v14, v14, v101, v16
		v_max3_f32 v16, v22, v239, v28
		v_max3_f32 v14, v14, v111, v16
		v_max_f32_e32 v14, v14, v169
		v_mov_b32_e32 v28, v14
		v_mov_b32_e32 v29, v14
		s_nop 1
		v_permlane32_swap_b32_e32 v28, v29
		v_max_f32_e32 v96, v28, v29
		v_max3_f32 v14, v148, v149, v150
		v_max3_f32 v16, v152, v153, v170
		v_max3_f32 v22, v20, v21, v142
		v_max3_f32 v28, v26, v27, v154
		v_max3_f32 v29, v156, v157, v172
		v_max3_f32 v97, v174, v175, v192
		v_max3_f32 v128, v194, v195, v196
		v_max3_f32 v129, v198, v199, v200
		v_max3_f32 v182, v202, v203, v204
		v_max3_f32 v183, v206, v207, v208
		v_max3_f32 v184, v210, v211, v212
		v_max3_f32 v185, v136, v137, v138
		v_max3_f32 v186, v30, v31, v140
		v_max3_f32 v187, v130, v131, v176
		v_max3_f32 v188, v134, v135, v178
		v_max3_f32 v189, v132, v133, v180
		v_max3_f32 v14, v14, v151, v16
		v_max3_f32 v16, v22, v143, v28
		v_max3_f32 v22, v29, v173, v97
		v_max3_f32 v28, v128, v197, v129
		v_max3_f32 v29, v182, v205, v183
		v_max3_f32 v97, v184, v213, v185
		v_max3_f32 v128, v186, v141, v187
		v_max3_f32 v129, v188, v179, v189
		v_max3_f32 v14, v14, v171, v16
		v_max3_f32 v16, v22, v193, v28
		v_max3_f32 v22, v29, v209, v97
		v_max3_f32 v28, v128, v177, v129
		v_max3_f32 v14, v14, v155, v16
		v_max3_f32 v16, v22, v139, v28
		v_max3_f32 v14, v14, v201, v16
		v_max_f32_e32 v14, v14, v181
		v_mov_b32_e32 v28, v14
		v_mov_b32_e32 v29, v14
		s_nop 1
		v_permlane32_swap_b32_e32 v28, v29
		v_max_f32_e32 v97, v28, v29
		v_mov_b32_e32 v28, 0x3e38aa3b
		v_mov_b32_e32 v29, 0x3e38aa3b
		v_pk_mul_f32 v[128:129], v[96:97], v[28:29]
		v_max_f32_e32 v96, v13, v128
		v_max_f32_e32 v97, v15, v129
		v_accvgpr_read_b32 v128, a136
		v_accvgpr_read_b32 v129, a137
		v_pk_fma_f32 v[182:183], v[128:129], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_accvgpr_read_b32 v128, a134
		v_accvgpr_read_b32 v129, a135
		v_pk_fma_f32 v[184:185], v[128:129], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[98:99], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_accvgpr_read_b32 v98, a138
		v_accvgpr_read_b32 v99, a139
		v_pk_fma_f32 v[186:187], v[98:99], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[102:103], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_accvgpr_read_b32 v102, a140
		v_accvgpr_read_b32 v103, a141
		v_pk_fma_f32 v[188:189], v[102:103], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[100:101], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[108:109], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_accvgpr_read_b32 v108, a142
		v_accvgpr_read_b32 v109, a143
		v_pk_fma_f32 v[190:191], v[108:109], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[112:113], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_accvgpr_read_b32 v112, a148
		v_accvgpr_read_b32 v113, a149
		v_pk_fma_f32 v[214:215], v[112:113], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_accvgpr_read_b32 v112, a150
		v_accvgpr_read_b32 v113, a151
		v_pk_fma_f32 v[216:217], v[112:113], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[106:107], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[122:123], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[110:111], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[162:163], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[114:115], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[146:147], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[116:117], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[18:19], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[18:19], v[118:119], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[120:121], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[238:239], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[218:219], v[158:159], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[160:161], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[124:125], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[126:127], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[144:145], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[164:165], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[166:167], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[168:169], v[28:29], v[96:97] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[148:149], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[150:151], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[170:171], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[20:21], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[20:21], v[142:143], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[26:27], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[154:155], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[156:157], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[172:173], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[174:175], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[192:193], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[194:195], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[196:197], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[198:199], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[200:201], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[202:203], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[204:205], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[206:207], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[208:209], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[210:211], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[212:213], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[136:137], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[138:139], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[30:31], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[140:141], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[130:131], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[176:177], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[134:135], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[178:179], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[132:133], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[180:181], v[28:29], v[96:97] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v28, v182
		v_exp_f32_e32 v180, v183
		v_exp_f32_e32 v29, v184
		v_exp_f32_e32 v181, v185
		v_exp_f32_e32 v182, v128
		v_exp_f32_e32 v184, v129
		v_exp_f32_e32 v183, v186
		v_exp_f32_e32 v185, v187
		v_exp_f32_e32 v128, v98
		v_exp_f32_e32 v186, v99
		v_exp_f32_e32 v129, v188
		v_exp_f32_e32 v187, v189
		v_exp_f32_e32 v98, v102
		v_exp_f32_e32 v188, v103
		v_exp_f32_e32 v99, v104
		v_exp_f32_e32 v189, v105
		v_exp_f32_e32 v102, v100
		v_exp_f32_e32 v104, v101
		v_exp_f32_e32 v103, v190
		v_exp_f32_e32 v105, v191
		v_exp_f32_e32 v100, v108
		v_exp_f32_e32 v190, v109
		v_exp_f32_e32 v101, v214
		v_exp_f32_e32 v191, v215
		v_exp_f32_e32 v108, v216
		v_exp_f32_e32 v214, v217
		v_exp_f32_e32 v109, v112
		v_exp_f32_e32 v215, v113
		v_exp_f32_e32 v112, v106
		v_exp_f32_e32 v216, v107
		v_exp_f32_e32 v113, v122
		v_exp_f32_e32 v217, v123
		v_exp_f32_e32 v106, v110
		v_exp_f32_e32 v122, v111
		v_exp_f32_e32 v107, v162
		v_exp_f32_e32 v123, v163
		v_exp_f32_e32 v110, v114
		v_exp_f32_e32 v162, v115
		v_exp_f32_e32 v111, v146
		v_exp_f32_e32 v163, v147
		v_exp_f32_e32 v114, v116
		v_exp_f32_e32 v146, v117
		v_exp_f32_e32 v115, v18
		v_exp_f32_e32 v147, v19
		v_exp_f32_e32 v18, v118
		v_exp_f32_e32 v116, v119
		v_exp_f32_e32 v19, v120
		v_exp_f32_e32 v117, v121
		v_exp_f32_e32 v118, v218
		v_exp_f32_e32 v120, v219
		v_exp_f32_e32 v119, v158
		v_exp_f32_e32 v121, v159
		v_exp_f32_e32 v158, v160
		v_exp_f32_e32 v218, v161
		v_exp_f32_e32 v159, v124
		v_exp_f32_e32 v219, v125
		v_exp_f32_e32 v124, v126
		v_exp_f32_e32 v160, v127
		v_exp_f32_e32 v125, v144
		v_exp_f32_e32 v161, v145
		v_exp_f32_e32 v126, v164
		v_exp_f32_e32 v144, v165
		v_exp_f32_e32 v127, v166
		v_exp_f32_e32 v145, v167
		v_exp_f32_e32 v165, v168
		v_exp_f32_e32 v167, v169
		v_exp_f32_e32 v168, v148
		v_exp_f32_e32 v220, v149
		v_exp_f32_e32 v169, v150
		v_exp_f32_e32 v221, v151
		v_exp_f32_e32 v148, v152
		v_exp_f32_e32 v150, v153
		v_exp_f32_e32 v149, v170
		v_exp_f32_e32 v151, v171
		v_exp_f32_e32 v152, v20
		v_exp_f32_e32 v170, v21
		v_exp_f32_e32 v153, v142
		v_exp_f32_e32 v171, v143
		v_exp_f32_e32 v20, v26
		v_exp_f32_e32 v142, v27
		v_exp_f32_e32 v21, v154
		v_exp_f32_e32 v143, v155
		v_exp_f32_e32 v26, v156
		v_exp_f32_e32 v154, v157
		v_exp_f32_e32 v27, v172
		v_exp_f32_e32 v155, v173
		v_exp_f32_e32 v156, v174
		v_exp_f32_e32 v172, v175
		v_exp_f32_e32 v157, v192
		v_exp_f32_e32 v173, v193
		v_exp_f32_e32 v174, v194
		v_exp_f32_e32 v192, v195
		v_exp_f32_e32 v175, v196
		v_exp_f32_e32 v193, v197
		v_exp_f32_e32 v194, v198
		v_exp_f32_e32 v196, v199
		v_exp_f32_e32 v195, v200
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
		v_exp_f32_e32 v207, v212
		v_exp_f32_e32 v209, v213
		v_exp_f32_e32 v210, v136
		v_exp_f32_e32 v212, v137
		v_exp_f32_e32 v211, v138
		v_exp_f32_e32 v213, v139
		v_exp_f32_e32 v136, v30
		v_exp_f32_e32 v138, v31
		v_exp_f32_e32 v137, v140
		v_exp_f32_e32 v139, v141
		v_exp_f32_e32 v30, v130
		v_exp_f32_e32 v140, v131
		v_exp_f32_e32 v31, v176
		v_exp_f32_e32 v141, v177
		v_exp_f32_e32 v130, v134
		v_exp_f32_e32 v176, v135
		v_exp_f32_e32 v131, v178
		v_exp_f32_e32 v177, v179
		v_exp_f32_e32 v134, v132
		v_exp_f32_e32 v178, v133
		v_pk_add_f32 v[132:133], v[28:29], v[180:181]
		v_pk_add_f32 v[222:223], v[182:183], v[184:185]
		v_pk_add_f32 v[224:225], v[128:129], v[186:187]
		v_pk_add_f32 v[226:227], v[98:99], v[188:189]
		v_pk_add_f32 v[228:229], v[102:103], v[104:105]
		v_pk_add_f32 v[230:231], v[100:101], v[190:191]
		v_pk_add_f32 v[232:233], v[108:109], v[214:215]
		v_pk_add_f32 v[234:235], v[112:113], v[216:217]
		v_pk_add_f32 v[236:237], v[106:107], v[122:123]
		v_pk_add_f32 v[238:239], v[110:111], v[162:163]
		v_pk_add_f32 v[240:241], v[114:115], v[146:147]
		v_pk_add_f32 v[242:243], v[18:19], v[116:117]
		v_pk_add_f32 v[244:245], v[118:119], v[120:121]
		v_pk_add_f32 v[246:247], v[158:159], v[218:219]
		v_pk_add_f32 v[248:249], v[124:125], v[160:161]
		v_pk_add_f32 v[250:251], v[126:127], v[144:145]
		v_mov_b32_e32 v252, v133
		v_mov_b32_e32 v253, v223
		v_mov_b32_e32 v254, v132
		v_mov_b32_e32 v255, v222
		v_pk_add_f32 v[132:133], v[254:255], v[252:253]
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
		v_mov_b32_e32 v222, v133
		v_mov_b32_e32 v223, v225
		v_mov_b32_e32 v226, v132
		v_mov_b32_e32 v227, v224
		v_pk_add_f32 v[132:133], v[226:227], v[222:223]
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
		v_mov_b32_e32 v222, v133
		v_mov_b32_e32 v223, v227
		v_mov_b32_e32 v224, v132
		v_mov_b32_e32 v225, v226
		v_pk_add_f32 v[132:133], v[224:225], v[222:223]
		v_mov_b32_e32 v222, v229
		v_mov_b32_e32 v223, v231
		v_mov_b32_e32 v224, v228
		v_mov_b32_e32 v225, v230
		v_pk_add_f32 v[226:227], v[224:225], v[222:223]
		v_mov_b32_e32 v222, v133
		v_mov_b32_e32 v223, v227
		v_mov_b32_e32 v224, v132
		v_mov_b32_e32 v225, v226
		v_pk_add_f32 v[132:133], v[224:225], v[222:223]
		v_add_f32_e32 v14, v132, v133
		v_accvgpr_read_b32 v16, a75
		ds_bpermute_b32 v164, v16, v14
		v_accvgpr_read_b32 v16, a76
		ds_bpermute_b32 v166, v16, v14
		v_pk_add_f32 v[132:133], v[168:169], v[220:221]
		v_pk_add_f32 v[222:223], v[148:149], v[150:151]
		v_pk_add_f32 v[224:225], v[152:153], v[170:171]
		v_pk_add_f32 v[226:227], v[20:21], v[142:143]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[228:229], v[164:165], v[166:167]
		v_pk_add_f32 v[230:231], v[26:27], v[154:155]
		v_pk_add_f32 v[232:233], v[156:157], v[172:173]
		v_pk_add_f32 v[234:235], v[174:175], v[192:193]
		v_pk_add_f32 v[236:237], v[194:195], v[196:197]
		v_pk_add_f32 v[238:239], v[198:199], v[200:201]
		v_pk_add_f32 v[240:241], v[202:203], v[204:205]
		v_pk_add_f32 v[242:243], v[206:207], v[208:209]
		v_pk_add_f32 v[244:245], v[210:211], v[212:213]
		v_pk_add_f32 v[246:247], v[136:137], v[138:139]
		v_pk_add_f32 v[248:249], v[30:31], v[140:141]
		v_pk_add_f32 v[250:251], v[130:131], v[176:177]
		v_mov_b32_e32 v135, v229
		v_mov_b32_e32 v179, v132
		v_pk_add_f32 v[252:253], v[134:135], v[178:179]
		v_mov_b32_e32 v254, v133
		v_mov_b32_e32 v255, v224
		v_pk_add_f32 v[132:133], v[254:255], v[222:223]
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
		v_mov_b32_e32 v235, v132
		v_pk_add_f32 v[234:235], v[234:235], v[252:253]
		v_mov_b32_e32 v238, v133
		v_mov_b32_e32 v239, v226
		v_pk_add_f32 v[132:133], v[238:239], v[222:223]
		v_mov_b32_e32 v222, v227
		v_mov_b32_e32 v223, v232
		v_pk_add_f32 v[222:223], v[222:223], v[224:225]
		v_mov_b32_e32 v224, v233
		v_mov_b32_e32 v225, v236
		v_pk_add_f32 v[226:227], v[224:225], v[230:231]
		v_mov_b32_e32 v224, v237
		v_mov_b32_e32 v225, v132
		v_pk_add_f32 v[224:225], v[224:225], v[234:235]
		v_mov_b32_e32 v230, v133
		v_mov_b32_e32 v231, v226
		v_pk_add_f32 v[132:133], v[230:231], v[222:223]
		v_mov_b32_e32 v222, v227
		v_mov_b32_e32 v223, v132
		v_pk_add_f32 v[226:227], v[222:223], v[224:225]
		v_add_f32_e32 v14, v133, v226
		v_add_f32_e32 v14, v227, v14
		v_mov_b32_e32 v132, v14
		v_mov_b32_e32 v133, v14
		s_nop 1
		v_permlane32_swap_b32_e32 v132, v133
		v_add_f32_e32 v223, v132, v133
		v_sub_f32_e32 v13, v13, v96
		v_sub_f32_e32 v14, v15, v97
		v_exp_f32_e32 v132, v13
		v_exp_f32_e32 v224, v14
		v_mov_b32_e32 v133, v132
		v_pk_mul_f32 v[32:33], v[32:33], v[132:133]
		v_pk_mul_f32 v[34:35], v[34:35], v[132:133]
		v_pk_mul_f32 v[36:37], v[36:37], v[132:133]
		v_pk_mul_f32 v[38:39], v[38:39], v[132:133]
		v_pk_mul_f32 v[40:41], v[40:41], v[132:133]
		v_pk_mul_f32 v[42:43], v[42:43], v[132:133]
		v_pk_mul_f32 v[44:45], v[44:45], v[132:133]
		v_pk_mul_f32 v[46:47], v[46:47], v[132:133]
		v_pk_mul_f32 v[48:49], v[48:49], v[132:133]
		v_pk_mul_f32 v[50:51], v[50:51], v[132:133]
		v_pk_mul_f32 v[52:53], v[52:53], v[132:133]
		v_pk_mul_f32 v[54:55], v[54:55], v[132:133]
		v_pk_mul_f32 v[56:57], v[56:57], v[132:133]
		v_pk_mul_f32 v[58:59], v[58:59], v[132:133]
		v_pk_mul_f32 v[60:61], v[60:61], v[132:133]
		v_pk_mul_f32 v[62:63], v[62:63], v[132:133]
		v_mov_b32_e32 v225, v224
		v_pk_mul_f32 v[64:65], v[64:65], v[224:225]
		v_pk_mul_f32 v[66:67], v[66:67], v[224:225]
		v_pk_mul_f32 v[68:69], v[68:69], v[224:225]
		v_pk_mul_f32 v[70:71], v[70:71], v[224:225]
		v_pk_mul_f32 v[72:73], v[72:73], v[224:225]
		v_pk_mul_f32 v[74:75], v[74:75], v[224:225]
		v_pk_mul_f32 v[76:77], v[76:77], v[224:225]
		v_pk_mul_f32 v[78:79], v[78:79], v[224:225]
		v_pk_mul_f32 v[80:81], v[80:81], v[224:225]
		v_pk_mul_f32 v[82:83], v[82:83], v[224:225]
		v_pk_mul_f32 v[84:85], v[84:85], v[224:225]
		v_pk_mul_f32 v[86:87], v[86:87], v[224:225]
		v_pk_mul_f32 v[88:89], v[88:89], v[224:225]
		v_pk_mul_f32 v[90:91], v[90:91], v[224:225]
		v_pk_mul_f32 v[92:93], v[92:93], v[224:225]
		v_pk_mul_f32 v[94:95], v[94:95], v[224:225]
		v_mov_b32_e32 v14, v132
		v_mov_b32_e32 v15, v224
		v_mov_b32_e32 v222, v228
		v_mov_b64_e32 v[132:133], v[24:25]
		v_pk_fma_f32 v[24:25], v[132:133], v[14:15], v[222:223]
		v_cvt_pk_bf16_f32 v224, v28, v180
		v_cvt_pk_bf16_f32 v225, v29, v181
		v_cvt_pk_bf16_f32 v226, v182, v184
		v_cvt_pk_bf16_f32 v227, v183, v185
		v_cvt_pk_bf16_f32 v180, v128, v186
		v_cvt_pk_bf16_f32 v181, v129, v187
		v_cvt_pk_bf16_f32 v182, v98, v188
		v_cvt_pk_bf16_f32 v183, v99, v189
		v_cvt_pk_bf16_f32 v184, v102, v104
		v_cvt_pk_bf16_f32 v185, v103, v105
		v_cvt_pk_bf16_f32 v186, v100, v190
		v_cvt_pk_bf16_f32 v187, v101, v191
		v_cvt_pk_bf16_f32 v100, v108, v214
		v_cvt_pk_bf16_f32 v101, v109, v215
		v_cvt_pk_bf16_f32 v102, v112, v216
		v_cvt_pk_bf16_f32 v103, v113, v217
		v_cvt_pk_bf16_f32 v188, v106, v122
		v_cvt_pk_bf16_f32 v189, v107, v123
		v_cvt_pk_bf16_f32 v190, v110, v162
		v_cvt_pk_bf16_f32 v191, v111, v163
		v_cvt_pk_bf16_f32 v104, v114, v146
		v_cvt_pk_bf16_f32 v105, v115, v147
		v_cvt_pk_bf16_f32 v106, v18, v116
		v_cvt_pk_bf16_f32 v107, v19, v117
		v_cvt_pk_bf16_f32 v108, v118, v120
		v_cvt_pk_bf16_f32 v109, v119, v121
		v_cvt_pk_bf16_f32 v110, v158, v218
		v_cvt_pk_bf16_f32 v111, v159, v219
		v_cvt_pk_bf16_f32 v112, v124, v160
		v_cvt_pk_bf16_f32 v113, v125, v161
		v_cvt_pk_bf16_f32 v114, v126, v144
		v_cvt_pk_bf16_f32 v115, v127, v145
		v_cvt_pk_bf16_f32 v116, v165, v167
		v_cvt_pk_bf16_f32 v117, v168, v220
		v_cvt_pk_bf16_f32 v118, v169, v221
		v_cvt_pk_bf16_f32 v119, v148, v150
		v_cvt_pk_bf16_f32 v120, v149, v151
		v_cvt_pk_bf16_f32 v121, v152, v170
		v_cvt_pk_bf16_f32 v122, v153, v171
		v_cvt_pk_bf16_f32 v123, v20, v142
		v_cvt_pk_bf16_f32 v124, v21, v143
		v_cvt_pk_bf16_f32 v125, v26, v154
		v_cvt_pk_bf16_f32 v126, v27, v155
		v_cvt_pk_bf16_f32 v127, v156, v172
		v_cvt_pk_bf16_f32 v144, v157, v173
		v_cvt_pk_bf16_f32 v145, v174, v192
		v_cvt_pk_bf16_f32 v146, v175, v193
		v_cvt_pk_bf16_f32 v147, v194, v196
		v_cvt_pk_bf16_f32 v148, v195, v197
		v_cvt_pk_bf16_f32 v149, v198, v200
		v_cvt_pk_bf16_f32 v150, v199, v201
		v_cvt_pk_bf16_f32 v151, v202, v204
		v_cvt_pk_bf16_f32 v152, v203, v205
		v_cvt_pk_bf16_f32 v153, v206, v208
		v_cvt_pk_bf16_f32 v154, v207, v209
		v_cvt_pk_bf16_f32 v155, v210, v212
		v_cvt_pk_bf16_f32 v156, v211, v213
		v_cvt_pk_bf16_f32 v157, v136, v138
		v_cvt_pk_bf16_f32 v158, v137, v139
		v_cvt_pk_bf16_f32 v159, v30, v140
		v_cvt_pk_bf16_f32 v136, v31, v141
		v_cvt_pk_bf16_f32 v137, v130, v176
		v_cvt_pk_bf16_f32 v138, v131, v177
		v_cvt_pk_bf16_f32 v139, v134, v178
		v_permlane32_swap_b32_e32 v224, v226
		v_permlane32_swap_b32_e32 v225, v227
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[224:227], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[224:227], v[48:63]
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[180:183], v[32:47]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[180:183], v[48:63]
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[184:187], v[32:47]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[184:187], v[48:63]
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[100:103], v[32:47]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[100:103], v[48:63]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[188:191], v[32:47]
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[116:119], v[80:95]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[116:119], v[64:79]
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[120:123], v[80:95]
		v_permlane32_swap_b32_e32 v148, v150
		v_permlane32_swap_b32_e32 v149, v151
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[120:123], v[64:79]
		v_permlane32_swap_b32_e32 v152, v154
		v_permlane32_swap_b32_e32 v153, v155
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[124:127], v[80:95]
		v_permlane32_swap_b32_e32 v156, v158
		v_permlane32_swap_b32_e32 v157, v159
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[124:127], v[64:79]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[144:147], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[144:147], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[188:191], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[148:151], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[148:151], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[104:107], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[104:107], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[152:155], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[152:155], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[216:219], v[108:111], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[248:251], v[108:111], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[248:251], v[156:159], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[216:219], v[156:159], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[220:223], v[112:115], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[252:255], v[112:115], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[252:255], v[136:139], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[220:223], v[136:139], v[64:79]
		s_mov_b32 s46, s24
		v_mov_b32_e32 v13, v96
		v_mov_b32_e32 v15, v97
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_4
.L_attn_fwd_persistent.loop_exit_4:
		s_mov_b32 s36, s8
		s_mov_b32 s37, s9
		s_mov_b32 s38, s34
		s_mov_b32 s39, s35
		v_rcp_f32_e32 v6, v24
		v_rcp_f32_e32 v8, v25
		v_mov_b32_e32 v7, v6
		v_pk_mul_f32 v[10:11], v[32:33], v[6:7]
		v_pk_mul_f32 v[12:13], v[34:35], v[6:7]
		v_pk_mul_f32 v[14:15], v[36:37], v[6:7]
		v_pk_mul_f32 v[18:19], v[38:39], v[6:7]
		v_pk_mul_f32 v[20:21], v[40:41], v[6:7]
		v_pk_mul_f32 v[22:23], v[42:43], v[6:7]
		v_pk_mul_f32 v[24:25], v[44:45], v[6:7]
		v_pk_mul_f32 v[26:27], v[46:47], v[6:7]
		v_pk_mul_f32 v[28:29], v[48:49], v[6:7]
		v_pk_mul_f32 v[30:31], v[50:51], v[6:7]
		v_pk_mul_f32 v[32:33], v[52:53], v[6:7]
		v_pk_mul_f32 v[34:35], v[54:55], v[6:7]
		v_pk_mul_f32 v[36:37], v[56:57], v[6:7]
		v_pk_mul_f32 v[38:39], v[58:59], v[6:7]
		v_pk_mul_f32 v[40:41], v[60:61], v[6:7]
		v_pk_mul_f32 v[42:43], v[62:63], v[6:7]
		v_mov_b32_e32 v9, v8
		v_pk_mul_f32 v[6:7], v[64:65], v[8:9]
		v_pk_mul_f32 v[44:45], v[66:67], v[8:9]
		v_pk_mul_f32 v[46:47], v[68:69], v[8:9]
		v_pk_mul_f32 v[48:49], v[70:71], v[8:9]
		v_pk_mul_f32 v[50:51], v[72:73], v[8:9]
		v_pk_mul_f32 v[52:53], v[74:75], v[8:9]
		v_pk_mul_f32 v[54:55], v[76:77], v[8:9]
		v_pk_mul_f32 v[56:57], v[78:79], v[8:9]
		v_pk_mul_f32 v[58:59], v[80:81], v[8:9]
		v_pk_mul_f32 v[60:61], v[82:83], v[8:9]
		v_pk_mul_f32 v[62:63], v[84:85], v[8:9]
		v_pk_mul_f32 v[64:65], v[86:87], v[8:9]
		v_pk_mul_f32 v[66:67], v[88:89], v[8:9]
		v_pk_mul_f32 v[68:69], v[90:91], v[8:9]
		v_pk_mul_f32 v[70:71], v[92:93], v[8:9]
		v_pk_mul_f32 v[72:73], v[94:95], v[8:9]
		v_accvgpr_read_b32 v5, a9
		v_mov_b32_e32 v8, 8
		v_mul_lo_u32 v8, v8, v5
		v_xor_b32_e32 v5, 16, v8
		v_xor_b32_e32 v9, 32, v8
		v_xor_b32_e32 v16, 48, v8
		s_mov_b32 s1, 64
		v_cmp_lt_i32_e64 vcc, v8, s1
		s_mov_b64 s[24:25], vcc
		s_and_b32 s30, s26, s24
		s_and_b32 s31, s27, s25
		v_cmp_lt_i32_e64 vcc, v5, s1
		s_mov_b64 s[32:33], vcc
		s_and_b32 s34, s26, s32
		s_and_b32 s35, s27, s33
		v_cmp_lt_i32_e64 vcc, v9, s1
		s_mov_b64 s[40:41], vcc
		s_and_b32 s42, s26, s40
		s_and_b32 s43, s27, s41
		v_cmp_lt_i32_e64 vcc, v16, s1
		s_mov_b64 s[44:45], vcc
		s_and_b32 s46, s26, s44
		s_and_b32 s47, s27, s45
		s_and_b32 s26, s28, s24
		s_and_b32 s27, s29, s25
		s_and_b32 s24, s28, s32
		s_and_b32 s25, s29, s33
		s_and_b32 s32, s28, s40
		s_and_b32 s33, s29, s41
		s_and_b32 s40, s28, s44
		s_and_b32 s41, s29, s45
		v_cvt_pk_bf16_f32 v76, v10, v11
		v_cvt_pk_bf16_f32 v77, v12, v13
		v_cvt_pk_bf16_f32 v78, v14, v15
		v_cvt_pk_bf16_f32 v79, v18, v19
		v_cvt_pk_bf16_f32 v8, v20, v21
		v_cvt_pk_bf16_f32 v9, v22, v23
		v_cvt_pk_bf16_f32 v10, v24, v25
		v_cvt_pk_bf16_f32 v11, v26, v27
		v_cvt_pk_bf16_f32 v12, v28, v29
		v_cvt_pk_bf16_f32 v13, v30, v31
		v_cvt_pk_bf16_f32 v14, v32, v33
		v_cvt_pk_bf16_f32 v15, v34, v35
		v_cvt_pk_bf16_f32 v20, v36, v37
		v_cvt_pk_bf16_f32 v21, v38, v39
		v_cvt_pk_bf16_f32 v22, v40, v41
		v_cvt_pk_bf16_f32 v23, v42, v43
		v_cvt_pk_bf16_f32 v24, v6, v7
		v_cvt_pk_bf16_f32 v25, v44, v45
		v_cvt_pk_bf16_f32 v26, v46, v47
		v_cvt_pk_bf16_f32 v27, v48, v49
		v_cvt_pk_bf16_f32 v28, v50, v51
		v_cvt_pk_bf16_f32 v29, v52, v53
		v_cvt_pk_bf16_f32 v30, v54, v55
		v_cvt_pk_bf16_f32 v31, v56, v57
		v_cvt_pk_bf16_f32 v32, v58, v59
		v_cvt_pk_bf16_f32 v33, v60, v61
		v_cvt_pk_bf16_f32 v34, v62, v63
		v_cvt_pk_bf16_f32 v35, v64, v65
		v_cvt_pk_bf16_f32 v36, v66, v67
		v_cvt_pk_bf16_f32 v37, v68, v69
		v_cvt_pk_bf16_f32 v38, v70, v71
		v_cvt_pk_bf16_f32 v39, v72, v73
		v_permlane32_swap_b32_e32 v76, v78
		v_permlane32_swap_b32_e32 v77, v79
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
		v_permlane32_swap_b32_e32 v36, v38
		v_permlane32_swap_b32_e32 v37, v39
		s_mul_i32 s1, s20, s19
		s_mov_b32 m0, s17
		s_lshl_b32 s1, s1, 9
		ds_read_addtid_b32 v5
		s_waitcnt lgkmcnt(0)
		s_mov_b32 m0, s17
		v_readfirstlane_b32 s20, v5
		ds_read_addtid_b32 v5 offset:2048
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s28, v5
		s_mul_i32 s20, s28, s20
		s_lshl_b32 s20, s20, 1
		s_mov_b32 m0, s17
		s_add_i32 s28, s1, s20
		ds_read_addtid_b32 v5 offset:1024
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s29, v5
		v_readfirstlane_b32 s44, v17
		s_mul_i32 s29, s44, s29
		s_lshl_b32 s29, s29, 1
		s_add_i32 s28, s28, s29
		v_accvgpr_read_b32 v5, a6
		v_mul_lo_u32 v5, s19, v5
		v_lshl_add_u32 v6, v5, 7, s28
		v_accvgpr_read_b32 v7, a13
		v_mul_lo_u32 v7, s19, v7
		v_lshl_add_u32 v6, v7, 1, v6
		v_accvgpr_read_b32 v16, a10
		v_mul_lo_u32 v16, s19, v16
		v_lshl_add_u32 v6, v16, 6, v6
		v_accvgpr_read_b32 v17, a11
		v_mul_lo_u32 v17, s19, v17
		v_lshl_add_u32 v6, v17, 5, v6
		v_accvgpr_read_b32 v18, a12
		v_mul_lo_u32 v18, s19, v18
		v_lshl_add_u32 v6, v18, 4, v6
		v_accvgpr_read_b32 v19, a14
		v_mul_lo_u32 v19, s19, v19
		v_lshl_add_u32 v6, v19, 3, v6
		v_accvgpr_read_b32 v40, a15
		v_mul_lo_u32 v40, s19, v40
		v_lshlrev_b32_e32 v40, 2, v40
		v_accvgpr_read_b32 v41, a57
		v_add3_u32 v6, v6, v40, v41
		s_and_saveexec_b64 s[98:99], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_24
		buffer_store_dwordx4 v[76:79], v6, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_24:
		s_andn2_b64 exec, s[98:99], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_24
.L_attn_fwd_persistent.exec_endif_24:
		s_mov_b64 exec, s[98:99]
		s_add_i32 s30, s1, 32
		s_add_i32 s30, s30, s20
		s_add_i32 s30, s30, s29
		v_lshl_add_u32 v6, v5, 7, s30
		v_lshl_add_u32 v6, v7, 1, v6
		v_lshl_add_u32 v6, v16, 6, v6
		v_lshl_add_u32 v6, v17, 5, v6
		v_lshl_add_u32 v6, v18, 4, v6
		v_lshl_add_u32 v6, v19, 3, v6
		v_accvgpr_read_b32 v41, a57
		v_add3_u32 v6, v6, v40, v41
		s_and_saveexec_b64 s[98:99], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_25
		buffer_store_dwordx4 v[8:11], v6, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_25:
		s_andn2_b64 exec, s[98:99], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_25
.L_attn_fwd_persistent.exec_endif_25:
		s_mov_b64 exec, s[98:99]
		s_add_i32 s31, s1, 64
		s_add_i32 s31, s31, s20
		s_add_i32 s31, s31, s29
		v_lshl_add_u32 v6, v5, 7, s31
		v_lshl_add_u32 v6, v7, 1, v6
		v_lshl_add_u32 v6, v16, 6, v6
		v_lshl_add_u32 v6, v17, 5, v6
		v_lshl_add_u32 v6, v18, 4, v6
		v_lshl_add_u32 v6, v19, 3, v6
		v_accvgpr_read_b32 v8, a57
		v_add3_u32 v6, v6, v40, v8
		s_and_saveexec_b64 s[98:99], s[42:43]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_26
		buffer_store_dwordx4 v[12:15], v6, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_26:
		s_andn2_b64 exec, s[98:99], s[42:43]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_26
.L_attn_fwd_persistent.exec_endif_26:
		s_mov_b64 exec, s[98:99]
		s_add_i32 s1, s1, 0x60
		s_add_i32 s1, s1, s20
		s_add_i32 s1, s1, s29
		v_lshl_add_u32 v5, v5, 7, s1
		v_lshl_add_u32 v5, v7, 1, v5
		v_lshl_add_u32 v5, v16, 6, v5
		v_lshl_add_u32 v5, v17, 5, v5
		v_lshl_add_u32 v5, v18, 4, v5
		v_lshl_add_u32 v5, v19, 3, v5
		v_accvgpr_read_b32 v6, a57
		v_add3_u32 v5, v5, v40, v6
		s_and_saveexec_b64 s[98:99], s[46:47]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_27
		buffer_store_dwordx4 v[20:23], v5, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_27:
		s_andn2_b64 exec, s[98:99], s[46:47]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_27
.L_attn_fwd_persistent.exec_endif_27:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v5, a6
		v_lshlrev_b32_e32 v5, 6, v5
		v_accvgpr_read_b32 v6, a10
		v_lshlrev_b32_e32 v6, 5, v6
		v_accvgpr_read_b32 v7, a11
		v_lshlrev_b32_e32 v7, 4, v7
		v_accvgpr_read_b32 v8, a12
		v_lshlrev_b32_e32 v8, 3, v8
		v_accvgpr_read_b32 v9, a14
		v_lshlrev_b32_e32 v9, 2, v9
		v_accvgpr_read_b32 v10, a13
		v_add_u32_e32 v10, 0x80, v10
		v_accvgpr_read_b32 v11, a15
		v_lshlrev_b32_e32 v11, 1, v11
		v_bitop3_b32 v9, v9, v10, v11 bitop3:0x96
		v_bitop3_b32 v7, v7, v8, v9 bitop3:0x96
		v_bitop3_b32 v5, v5, v6, v7 bitop3:0x96
		v_mul_lo_u32 v5, s19, v5
		v_lshlrev_b32_e32 v5, 1, v5
		v_accvgpr_read_b32 v6, a57
		v_add3_u32 v6, s28, v5, v6
		s_and_saveexec_b64 s[98:99], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_28
		buffer_store_dwordx4 v[24:27], v6, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_28:
		s_andn2_b64 exec, s[98:99], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_28
.L_attn_fwd_persistent.exec_endif_28:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v6, a57
		v_add3_u32 v6, s30, v5, v6
		s_and_saveexec_b64 s[98:99], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_29
		buffer_store_dwordx4 v[28:31], v6, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_29:
		s_andn2_b64 exec, s[98:99], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_29
.L_attn_fwd_persistent.exec_endif_29:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v6, a57
		v_add3_u32 v6, s31, v5, v6
		s_and_saveexec_b64 s[98:99], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_30
		buffer_store_dwordx4 v[32:35], v6, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_30:
		s_andn2_b64 exec, s[98:99], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_30
.L_attn_fwd_persistent.exec_endif_30:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v6, a57
		v_add3_u32 v5, s1, v5, v6
		s_and_saveexec_b64 s[98:99], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_31
		buffer_store_dwordx4 v[36:39], v5, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_31:
		s_andn2_b64 exec, s[98:99], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_31
.L_attn_fwd_persistent.exec_endif_31:
		s_mov_b64 exec, s[98:99]
		s_branch .L_attn_fwd_persistent.if_end_3
.L_attn_fwd_persistent.if_else_3:
.L_attn_fwd_persistent.if_end_3:
		s_branch .L_attn_fwd_persistent.if_end_0
.L_attn_fwd_persistent.if_else_0:
.L_attn_fwd_persistent.if_end_0:
		s_add_i32 s0, s0, 32
		v_accvgpr_read_b32 v5, a5
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
		.amdhsa_group_segment_fixed_size 103856
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
    .group_segment_fixed_size: 103856
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
    wave.regalloc.iterations: 455
    wave.regalloc.agpr.dwords: 853
    wave.regalloc.remat.dwords: 27
    wave.regalloc.sgpr_to_vgpr.dwords: 56
    wave.regalloc.lds.dwords: 3
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
