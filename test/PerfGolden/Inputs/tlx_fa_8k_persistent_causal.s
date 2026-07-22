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
		v_mov_b32_e32 v1, s19
		v_accvgpr_write_b32 a2, v1
		s_load_dword s19, s[0:1], 0x48
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v1, s19
		v_accvgpr_write_b32 a3, v1
		s_load_dword s19, s[0:1], 0x4c
		s_load_dword s20, s[0:1], 0x50
		s_load_dword s21, s[0:1], 0x54
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v1, s21
		s_load_dword s21, s[0:1], 0x58
		s_load_dword s22, s[0:1], 0x5c
		s_load_dword s23, s[0:1], 0x60
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v2, s23
		v_accvgpr_write_b32 a4, 0
		s_and_b32 s0, s16, 7
		v_mov_b32_e32 v3, s0
		v_accvgpr_write_b32 a5, v3
		s_lshr_b32 s0, s16, 3
		v_readfirstlane_b32 s1, v1
		s_mul_i32 s1, s20, s1
		s_nop 0
		v_mov_b32_e32 v3, s1
		v_accvgpr_write_b32 a6, v3
		v_accvgpr_read_b32 v3, a6
		s_nop 0
		v_readfirstlane_b32 s1, v3
		s_add_i32 s1, s1, 7
		s_mov_b32 s16, 1
		s_mov_b32 s20, 7
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s20, s20, 0
		s_add_i32 s1, s1, s20
		s_ashr_i32 s1, s1, 3
		s_mul_i32 s1, s1, 16
		v_mov_b32_e32 v3, s1
		v_accvgpr_write_b32 a7, v3
		v_accvgpr_read_b32 v3, a7
		s_nop 0
		v_readfirstlane_b32 s1, v3
		s_cmp_lt_i32 s0, s1
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_0
.L_attn_fwd_persistent.loop_head_0:
		s_lshr_b32 s1, s0, 4
		s_and_b32 s20, s0, 15
		s_mul_i32 s1, s1, 8
		v_accvgpr_read_b32 v3, a5
		s_nop 0
		v_readfirstlane_b32 s24, v3
		s_add_i32 s1, s24, s1
		v_accvgpr_read_b32 v3, a6
		s_nop 0
		v_readfirstlane_b32 s24, v3
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
		v_mov_b32_e32 v3, s26
		v_cvt_f32_u32_e32 v3, v3
		v_rcp_iflag_f32_e32 v3, v3
		v_mov_b32_e32 v4, 0x4f7ffffe
		v_mul_f32_e32 v3, v4, v3
		v_cvt_u32_f32_e32 v3, v3
		s_xor_b32 s27, s26, -1
		v_readfirstlane_b32 s28, v3
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
		s_mov_b32 m0, s17
		v_mov_b32_e32 v3, s1
		ds_write_addtid_b32 v3 offset:1024
		s_add_i32 s1, s24, s27
		s_cmp_lg_u32 s28, 0
		s_cselect_b32 s1, s1, s24
		s_xor_b32 s24, s1, -1
		s_add_i32 s24, s24, 1
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s1, s24, s1
		s_mov_b32 m0, s17
		v_mov_b32_e32 v4, s1
		ds_write_addtid_b32 v4 offset:2048
		s_mul_i32 s1, s20, 2
		s_cmp_lt_i32 s1, 32
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_1
		s_lshr_b32 s20, s1, 1
		s_and_b32 s1, s1, 1
		s_xor_b32 s24, s20, -1
		s_add_i32 s24, s24, 1
		s_add_i32 s24, s24, 31
		s_cmp_eq_u32 s1, 0
		s_cselect_b32 s1, s20, s24
		v_mov_b32_e32 v5, s1
		s_nop 0
		v_readfirstlane_b32 s1, v5
		s_mul_i32 s1, s1, 0x100
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
		v_accvgpr_write_b32 a8, v21
		v_accvgpr_read_b32 v21, a8
		v_and_b32_e32 v21, 1, v21
		v_mov_b32_e32 v22, 64
		v_mul_lo_u32 v22, v22, v21
		v_xor_b32_e32 v10, v10, v22
		v_accvgpr_write_b32 a9, v10
		v_accvgpr_read_b32 v10, a9
		v_add_u32_e32 v10, s1, v10
		v_xor_b32_e32 v6, 0x80, v6
		v_xor_b32_e32 v6, v6, v9
		v_xor_b32_e32 v6, v6, v11
		v_bitop3_b32 v6, v6, v14, v17 bitop3:0x96
		v_bitop3_b32 v6, v6, v20, v22 bitop3:0x96
		v_accvgpr_write_b32 a10, v6
		v_accvgpr_read_b32 v6, a10
		v_add_u32_e32 v6, s1, v6
		v_cmp_lt_i32_e64 vcc, v10, s21
		s_mov_b64 s[24:25], vcc
		v_mov_b32_e32 v10, s24
		v_mov_b32_e32 v11, s25
		v_cmp_lt_i32_e64 vcc, v6, s21
		s_mov_b64 s[24:25], vcc
		v_mov_b32_e32 v22, s24
		v_mov_b32_e32 v23, s25
		v_accvgpr_write_b32 a12, v22
		v_accvgpr_write_b32 a13, v23
		v_mov_b32_e32 v6, 2
		v_mul_lo_u32 v6, v6, v16
		v_lshrrev_b32_e32 v9, 5, v0
		v_and_b32_e32 v14, 1, v9
		v_accvgpr_write_b32 a11, v14
		v_accvgpr_read_b32 v14, a11
		v_mov_b32_e32 v17, 4
		v_mul_lo_u32 v17, v17, v14
		v_bitop3_b32 v14, v13, v6, v17 bitop3:0x96
		v_mov_b32_e32 v20, 8
		v_mul_lo_u32 v20, v20, v19
		v_xor_b32_e32 v14, v14, v20
		v_mov_b32_e32 v22, 16
		v_mul_lo_u32 v22, v22, v21
		v_xad_u32 v14, v14, v22, s1
		v_bitop3_b32 v23, 32, v13, v6 bitop3:0x96
		v_bitop3_b32 v23, v23, v17, v20 bitop3:0x96
		v_xad_u32 v23, v23, v22, s1
		v_bitop3_b32 v24, 64, v13, v6 bitop3:0x96
		v_bitop3_b32 v24, v24, v17, v20 bitop3:0x96
		v_xad_u32 v24, v24, v22, s1
		v_xor_b32_e32 v25, 0x60, v13
		v_xor_b32_e32 v25, v25, v6
		v_xor_b32_e32 v25, v25, v17
		v_xor_b32_e32 v25, v25, v20
		v_xad_u32 v25, v25, v22, s1
		v_xor_b32_e32 v26, 0x80, v13
		v_xor_b32_e32 v26, v26, v6
		v_xor_b32_e32 v26, v26, v17
		v_xor_b32_e32 v26, v26, v20
		v_xad_u32 v26, v26, v22, s1
		v_xor_b32_e32 v27, 0xa0, v13
		v_xor_b32_e32 v27, v27, v6
		v_xor_b32_e32 v27, v27, v17
		v_xor_b32_e32 v27, v27, v20
		v_xad_u32 v27, v27, v22, s1
		v_xor_b32_e32 v28, 0xc0, v13
		v_xor_b32_e32 v28, v28, v6
		v_xor_b32_e32 v28, v28, v17
		v_xor_b32_e32 v28, v28, v20
		v_xad_u32 v28, v28, v22, s1
		v_xor_b32_e32 v29, 0xe0, v13
		v_xor_b32_e32 v6, v29, v6
		v_xor_b32_e32 v6, v6, v17
		v_xor_b32_e32 v6, v6, v20
		v_xad_u32 v6, v6, v22, s1
		s_mov_b32 s26, 0x7fffffff
		s_mov_b32 s27, 0x31016000
		s_mov_b32 s24, s2
		s_mov_b32 s25, s3
		v_accvgpr_read_b32 v20, a4
		v_and_b32_e32 v20, 0xffff, v20
		v_lshlrev_b32_e32 v22, 16, v20
		v_or_b32_e32 v32, v20, v22
		v_mov_b32_e32 v33, v32
		v_mov_b32_e32 v34, v32
		v_mov_b32_e32 v35, v32
		v_readfirstlane_b32 s20, v5
		s_mul_i32 s20, s20, s12
		s_lshl_b32 s20, s20, 9
		v_readfirstlane_b32 s28, v3
		s_mul_i32 s28, s28, s10
		s_lshl_b32 s28, s28, 1
		s_add_i32 s20, s20, s28
		v_readfirstlane_b32 s28, v4
		s_mul_i32 s28, s28, s11
		s_lshl_b32 s28, s28, 1
		s_add_i32 s20, s20, s28
		v_accvgpr_read_b32 v20, a8
		v_mul_lo_u32 v20, s12, v20
		v_lshl_add_u32 v20, v20, 5, s20
		v_and_b32_e32 v22, 1, v18
		v_accvgpr_write_b32 a14, v22
		v_accvgpr_read_b32 v22, a14
		v_mul_lo_u32 v22, s12, v22
		v_lshl_add_u32 v20, v22, 4, v20
		v_and_b32_e32 v9, 1, v9
		v_mul_lo_u32 v22, s12, v9
		v_lshl_add_u32 v20, v22, 3, v20
		v_and_b32_e32 v15, 1, v15
		v_accvgpr_write_b32 a15, v15
		v_accvgpr_read_b32 v15, a15
		v_mul_lo_u32 v15, s12, v15
		v_lshl_add_u32 v15, v15, 2, v20
		v_and_b32_e32 v12, 1, v12
		v_accvgpr_write_b32 a16, v12
		v_accvgpr_read_b32 v12, a16
		v_mul_lo_u32 v12, s12, v12
		v_lshl_add_u32 v12, v12, 1, v15
		v_and_b32_e32 v15, 1, v0
		v_accvgpr_write_b32 a17, v15
		v_accvgpr_read_b32 v15, a17
		v_lshl_add_u32 v12, v15, 4, v12
		v_and_b32_e32 v15, 1, v8
		v_accvgpr_write_b32 a18, v15
		v_accvgpr_read_b32 v15, a18
		v_lshl_add_u32 v12, v15, 6, v12
		v_and_b32_e32 v7, 1, v7
		v_accvgpr_write_b32 a19, v7
		v_accvgpr_read_b32 v7, a19
		v_lshl_add_u32 v7, v7, 5, v12
		v_cmp_lt_i32_e64 vcc, v14, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_0
		buffer_load_dwordx4 v[36:39], v7, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_0:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_0
		v_mov_b32_e32 v36, v32
		v_mov_b32_e32 v37, v33
		v_mov_b32_e32 v38, v34
		v_mov_b32_e32 v39, v35
.L_attn_fwd_persistent.exec_endif_0:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v7, a8
		v_lshlrev_b32_e32 v7, 4, v7
		v_accvgpr_read_b32 v12, a14
		v_lshlrev_b32_e32 v12, 3, v12
		v_lshlrev_b32_e32 v14, 2, v9
		v_accvgpr_read_b32 v15, a16
		v_add_u32_e32 v15, 32, v15
		v_accvgpr_read_b32 v20, a15
		v_lshlrev_b32_e32 v20, 1, v20
		v_bitop3_b32 v15, v14, v15, v20 bitop3:0x96
		v_bitop3_b32 v15, v7, v12, v15 bitop3:0x96
		v_mul_lo_u32 v15, s12, v15
		v_lshl_add_u32 v15, v15, 1, s20
		v_accvgpr_read_b32 v22, a17
		v_lshl_add_u32 v15, v22, 4, v15
		v_accvgpr_read_b32 v22, a18
		v_lshl_add_u32 v15, v22, 6, v15
		v_accvgpr_read_b32 v22, a19
		v_lshl_add_u32 v15, v22, 5, v15
		v_cmp_lt_i32_e64 vcc, v23, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_1
		buffer_load_dwordx4 v[40:43], v15, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_1:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_1
		v_mov_b32_e32 v40, v32
		v_mov_b32_e32 v41, v33
		v_mov_b32_e32 v42, v34
		v_mov_b32_e32 v43, v35
.L_attn_fwd_persistent.exec_endif_1:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v15, a16
		v_add_u32_e32 v15, 64, v15
		v_bitop3_b32 v15, v14, v15, v20 bitop3:0x96
		v_bitop3_b32 v15, v7, v12, v15 bitop3:0x96
		v_mul_lo_u32 v15, s12, v15
		v_lshl_add_u32 v15, v15, 1, s20
		v_accvgpr_read_b32 v22, a17
		v_lshl_add_u32 v15, v22, 4, v15
		v_accvgpr_read_b32 v22, a18
		v_lshl_add_u32 v15, v22, 6, v15
		v_accvgpr_read_b32 v22, a19
		v_lshl_add_u32 v15, v22, 5, v15
		v_cmp_lt_i32_e64 vcc, v24, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_2
		buffer_load_dwordx4 v[44:47], v15, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_2:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_2
		v_mov_b32_e32 v44, v32
		v_mov_b32_e32 v45, v33
		v_mov_b32_e32 v46, v34
		v_mov_b32_e32 v47, v35
.L_attn_fwd_persistent.exec_endif_2:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v15, a16
		v_add_u32_e32 v15, 0x60, v15
		v_bitop3_b32 v15, v14, v15, v20 bitop3:0x96
		v_bitop3_b32 v15, v7, v12, v15 bitop3:0x96
		v_mul_lo_u32 v15, s12, v15
		v_lshl_add_u32 v15, v15, 1, s20
		v_accvgpr_read_b32 v22, a17
		v_lshl_add_u32 v15, v22, 4, v15
		v_accvgpr_read_b32 v22, a18
		v_lshl_add_u32 v15, v22, 6, v15
		v_accvgpr_read_b32 v22, a19
		v_lshl_add_u32 v15, v22, 5, v15
		v_cmp_lt_i32_e64 vcc, v25, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_3
		buffer_load_dwordx4 v[48:51], v15, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_3:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_3
		v_mov_b32_e32 v48, v32
		v_mov_b32_e32 v49, v33
		v_mov_b32_e32 v50, v34
		v_mov_b32_e32 v51, v35
.L_attn_fwd_persistent.exec_endif_3:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v15, a16
		v_add_u32_e32 v15, 0x80, v15
		v_bitop3_b32 v15, v14, v15, v20 bitop3:0x96
		v_bitop3_b32 v15, v7, v12, v15 bitop3:0x96
		v_mul_lo_u32 v15, s12, v15
		v_lshl_add_u32 v15, v15, 1, s20
		v_accvgpr_read_b32 v22, a17
		v_lshl_add_u32 v15, v22, 4, v15
		v_accvgpr_read_b32 v22, a18
		v_lshl_add_u32 v15, v22, 6, v15
		v_accvgpr_read_b32 v22, a19
		v_lshl_add_u32 v15, v22, 5, v15
		v_cmp_lt_i32_e64 vcc, v26, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_4
		buffer_load_dwordx4 v[52:55], v15, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_4:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_4
		v_mov_b32_e32 v52, v32
		v_mov_b32_e32 v53, v33
		v_mov_b32_e32 v54, v34
		v_mov_b32_e32 v55, v35
.L_attn_fwd_persistent.exec_endif_4:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v15, a16
		v_add_u32_e32 v15, 0xa0, v15
		v_bitop3_b32 v15, v14, v15, v20 bitop3:0x96
		v_bitop3_b32 v15, v7, v12, v15 bitop3:0x96
		v_mul_lo_u32 v15, s12, v15
		v_lshl_add_u32 v15, v15, 1, s20
		v_accvgpr_read_b32 v22, a17
		v_lshl_add_u32 v15, v22, 4, v15
		v_accvgpr_read_b32 v22, a18
		v_lshl_add_u32 v15, v22, 6, v15
		v_accvgpr_read_b32 v22, a19
		v_lshl_add_u32 v15, v22, 5, v15
		v_cmp_lt_i32_e64 vcc, v27, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_5
		buffer_load_dwordx4 v[24:27], v15, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_5:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_5
		v_mov_b32_e32 v24, v32
		v_mov_b32_e32 v25, v33
		v_mov_b32_e32 v26, v34
		v_mov_b32_e32 v27, v35
.L_attn_fwd_persistent.exec_endif_5:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v15, a16
		v_add_u32_e32 v15, 0xc0, v15
		v_bitop3_b32 v15, v14, v15, v20 bitop3:0x96
		v_bitop3_b32 v15, v7, v12, v15 bitop3:0x96
		v_mul_lo_u32 v15, s12, v15
		v_lshl_add_u32 v15, v15, 1, s20
		v_accvgpr_read_b32 v22, a17
		v_lshl_add_u32 v15, v22, 4, v15
		v_accvgpr_read_b32 v22, a18
		v_lshl_add_u32 v15, v22, 6, v15
		v_accvgpr_read_b32 v22, a19
		v_lshl_add_u32 v15, v22, 5, v15
		v_cmp_lt_i32_e64 vcc, v28, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_6
		buffer_load_dwordx4 v[28:31], v15, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_6:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_6
		v_mov_b32_e32 v28, v32
		v_mov_b32_e32 v29, v33
		v_mov_b32_e32 v30, v34
		v_mov_b32_e32 v31, v35
.L_attn_fwd_persistent.exec_endif_6:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v15, a16
		v_add_u32_e32 v15, 0xe0, v15
		v_bitop3_b32 v14, v14, v15, v20 bitop3:0x96
		v_bitop3_b32 v12, v7, v12, v14 bitop3:0x96
		v_mul_lo_u32 v12, s12, v12
		v_lshl_add_u32 v12, v12, 1, s20
		v_accvgpr_read_b32 v14, a17
		v_lshl_add_u32 v12, v14, 4, v12
		v_accvgpr_read_b32 v14, a18
		v_lshl_add_u32 v12, v14, 6, v12
		v_accvgpr_read_b32 v14, a19
		v_lshl_add_u32 v12, v14, 5, v12
		v_cmp_lt_i32_e64 vcc, v6, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_7
		buffer_load_dwordx4 v[56:59], v12, s[24:27], 0 offen
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
		v_accvgpr_read_b32 v6, a14
		v_lshlrev_b32_e32 v6, 2, v6
		v_lshlrev_b32_e32 v12, 1, v9
		v_accvgpr_read_b32 v14, a15
		v_xor_b32_e32 v14, v0, v14
		v_bitop3_b32 v6, v6, v12, v14 bitop3:0x96
		v_lshlrev_b32_e32 v6, 4, v6
		v_add_u32_e32 v6, 0x10000, v6
		ds_write_b128 v6, v[36:39] offset:2480
		ds_write_b128 v6, v[40:43] offset:6576
		ds_write_b128 v6, v[44:47] offset:10672
		ds_write_b128 v6, v[48:51] offset:14768
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
		v_accvgpr_write_b32 a20, v23
		v_accvgpr_read_b32 v23, a20
		v_xor_b32_e32 v22, v22, v23
		v_lshrrev_b32_e32 v23, 6, v22
		v_lshrrev_b32_e32 v32, 3, v14
		v_and_b32_e32 v32, 1, v32
		v_add_u32_e32 v23, v23, v32
		v_and_b32_e32 v23, 1, v23
		v_lshlrev_b32_e32 v23, 2, v23
		v_lshrrev_b32_e32 v33, 5, v22
		v_and_b32_e32 v33, 1, v33
		v_lshlrev_b32_e32 v33, 1, v33
		v_lshrrev_b32_e32 v34, 4, v14
		v_and_b32_e32 v34, 1, v34
		v_lshlrev_b32_e32 v35, 6, v32
		v_lshl_add_u32 v34, v34, 7, v35
		v_add_u32_e32 v35, v34, v22
		v_lshrrev_b32_e32 v22, 4, v22
		v_bitop3_b32 v22, v35, v22, 1 bitop3:0x78
		v_bitop3_b32 v22, v23, v33, v22 bitop3:0x96
		v_lshl_add_u32 v23, v22, 4, v12
		ds_read_b128 a[24:27], v23 offset:2480
		v_add_u32_e32 v23, 2, v15
		v_add3_u32 v23, v23, v18, v20
		v_accvgpr_read_b32 v33, a20
		v_xor_b32_e32 v23, v23, v33
		v_lshrrev_b32_e32 v33, 6, v23
		v_add_u32_e32 v33, v33, v32
		v_and_b32_e32 v33, 1, v33
		v_lshlrev_b32_e32 v33, 2, v33
		v_lshrrev_b32_e32 v35, 5, v23
		v_and_b32_e32 v35, 1, v35
		v_lshlrev_b32_e32 v35, 1, v35
		v_add_u32_e32 v36, v34, v23
		v_lshrrev_b32_e32 v23, 4, v23
		v_bitop3_b32 v23, v36, v23, 1 bitop3:0x78
		v_bitop3_b32 v23, v33, v35, v23 bitop3:0x96
		v_lshl_add_u32 v33, v23, 4, v12
		ds_read_b128 a[28:31], v33 offset:2480
		v_add_u32_e32 v33, 4, v15
		v_add3_u32 v33, v33, v18, v20
		v_accvgpr_read_b32 v35, a20
		v_xor_b32_e32 v33, v33, v35
		v_lshrrev_b32_e32 v35, 6, v33
		v_add_u32_e32 v35, v35, v32
		v_and_b32_e32 v35, 1, v35
		v_lshlrev_b32_e32 v35, 2, v35
		v_lshrrev_b32_e32 v36, 5, v33
		v_and_b32_e32 v36, 1, v36
		v_lshlrev_b32_e32 v36, 1, v36
		v_add_u32_e32 v37, v34, v33
		v_lshrrev_b32_e32 v33, 4, v33
		v_bitop3_b32 v33, v37, v33, 1 bitop3:0x78
		v_bitop3_b32 v33, v35, v36, v33 bitop3:0x96
		v_lshl_add_u32 v35, v33, 4, v12
		ds_read_b128 a[32:35], v35 offset:2480
		v_add_u32_e32 v15, 6, v15
		v_add3_u32 v15, v15, v18, v20
		v_accvgpr_read_b32 v18, a20
		v_xor_b32_e32 v15, v15, v18
		v_lshrrev_b32_e32 v18, 6, v15
		v_add_u32_e32 v18, v18, v32
		v_and_b32_e32 v18, 1, v18
		v_lshlrev_b32_e32 v18, 2, v18
		v_lshrrev_b32_e32 v20, 5, v15
		v_and_b32_e32 v20, 1, v20
		v_lshlrev_b32_e32 v20, 1, v20
		v_add_u32_e32 v32, v34, v15
		v_lshrrev_b32_e32 v15, 4, v15
		v_bitop3_b32 v15, v32, v15, 1 bitop3:0x78
		v_bitop3_b32 v15, v18, v20, v15 bitop3:0x96
		v_lshl_add_u32 v12, v15, 4, v12
		ds_read_b128 a[36:39], v12 offset:2480
		v_accvgpr_read_b32 v12, a14
		v_lshl_add_u32 v12, v12, 3, 32
		v_xor_b32_e32 v7, v12, v7
		v_lshrrev_b32_e32 v12, 5, v7
		v_and_b32_e32 v12, 1, v12
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v6, v[52:55] offset:2480
		ds_write_b128 v6, v[24:27] offset:6576
		ds_write_b128 v6, v[28:31] offset:10672
		ds_write_b128 v6, v[56:59] offset:14768
		v_lshrrev_b32_e32 v6, 4, v7
		v_and_b32_e32 v6, 1, v6
		v_lshlrev_b32_e32 v6, 13, v6
		v_lshl_add_u32 v6, v12, 14, v6
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshrrev_b32_e32 v7, 3, v7
		v_and_b32_e32 v7, 1, v7
		v_lshl_add_u32 v6, v7, 12, v6
		v_lshl_add_u32 v7, v22, 4, v6
		ds_read_b128 a[40:43], v7 offset:51632
		v_lshl_add_u32 v7, v23, 4, v6
		ds_read_b128 a[44:47], v7 offset:51632
		v_lshl_add_u32 v7, v33, 4, v6
		ds_read_b128 a[48:51], v7 offset:51632
		v_lshl_add_u32 v6, v15, 4, v6
		ds_read_b128 a[52:55], v6 offset:51632
		v_readfirstlane_b32 s20, v5
		s_add_i32 s20, s20, 1
		s_mul_i32 s20, s20, 0x100
		v_readfirstlane_b32 s24, v2
		s_add_i32 s20, s20, s24
		s_cmp_lt_i32 s22, s20
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_cselect_b32 s20, s22, s20
		s_add_i32 s24, s20, 0x7f
		s_mov_b32 s25, 0x7f
		s_cmp_lt_i32 s24, 0
		s_cselect_b32 s36, s25, 0
		s_add_i32 s24, s24, s36
		s_ashr_i32 s24, s24, 7
		v_readfirstlane_b32 s36, v2
		s_add_i32 s36, s1, s36
		s_cmp_lt_i32 s36, 0
		s_cselect_b32 s37, s25, 0
		s_add_i32 s36, s36, s37
		s_ashr_i32 s36, s36, 7
		s_cmp_lt_i32 s36, s24
		s_cselect_b32 s36, s36, s24
		s_cmp_gt_i32 s36, 0
		s_cselect_b32 s36, s36, 0
		v_mov_b32_e32 v6, 64
		v_mul_lo_u32 v6, v6, v13
		v_mov_b32_e32 v7, 32
		v_mul_lo_u32 v7, v7, v16
		v_accvgpr_read_b32 v12, a11
		v_mov_b32_e32 v15, 16
		v_mul_lo_u32 v15, v15, v12
		v_bitop3_b32 v12, v6, v7, v15 bitop3:0x96
		v_mov_b32_e32 v16, 2
		v_mul_lo_u32 v16, v16, v21
		v_bitop3_b32 v12, v12, v19, v16 bitop3:0x96
		v_accvgpr_write_b32 a21, v12
		v_bitop3_b32 v12, 4, v6, v7 bitop3:0x96
		v_xor_b32_e32 v12, v12, v15
		v_bitop3_b32 v12, v12, v19, v16 bitop3:0x96
		v_accvgpr_write_b32 a22, v12
		v_bitop3_b32 v12, 8, v6, v7 bitop3:0x96
		v_xor_b32_e32 v12, v12, v15
		v_bitop3_b32 v12, v12, v19, v16 bitop3:0x96
		v_accvgpr_write_b32 a23, v12
		v_bitop3_b32 v6, 12, v6, v7 bitop3:0x96
		v_xor_b32_e32 v6, v6, v15
		v_bitop3_b32 v6, v6, v19, v16 bitop3:0x96
		v_accvgpr_write_b32 a56, v6
		v_accvgpr_read_b32 v6, a21
		v_cmp_lt_i32_e64 vcc, v6, s22
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v6, a22
		v_cmp_lt_i32_e64 vcc, v6, s22
		s_mov_b64 s[40:41], vcc
		v_accvgpr_read_b32 v6, a23
		v_cmp_lt_i32_e64 vcc, v6, s22
		s_mov_b64 s[42:43], vcc
		v_accvgpr_read_b32 v6, a56
		v_cmp_lt_i32_e64 vcc, v6, s22
		s_mov_b64 s[44:45], vcc
		v_mov_b32_e32 v6, 16
		v_mul_lo_u32 v6, v6, v13
		v_accvgpr_read_b32 v12, a11
		v_mov_b32_e32 v13, 64
		v_mul_lo_u32 v13, v13, v12
		v_bitop3_b32 v12, v6, v7, v13 bitop3:0x96
		v_bitop3_b32 v12, v12, v19, v16 bitop3:0x96
		v_accvgpr_write_b32 a57, v12
		v_bitop3_b32 v12, 4, v6, v7 bitop3:0x96
		v_xor_b32_e32 v12, v12, v13
		v_bitop3_b32 v12, v12, v19, v16 bitop3:0x96
		v_accvgpr_write_b32 a58, v12
		v_bitop3_b32 v12, 8, v6, v7 bitop3:0x96
		v_xor_b32_e32 v12, v12, v13
		v_bitop3_b32 v12, v12, v19, v16 bitop3:0x96
		v_accvgpr_write_b32 a59, v12
		v_bitop3_b32 v6, 12, v6, v7 bitop3:0x96
		v_accvgpr_read_b32 v7, a57
		v_cmp_lt_i32_e64 vcc, v7, s22
		s_mov_b64 s[46:47], vcc
		v_accvgpr_read_b32 v7, a58
		v_cmp_lt_i32_e64 vcc, v7, s22
		s_mov_b64 s[48:49], vcc
		v_accvgpr_read_b32 v7, a59
		v_cmp_lt_i32_e64 vcc, v7, s22
		s_mov_b64 s[50:51], vcc
		v_readfirstlane_b32 s52, v0
		v_accvgpr_read_b32 v7, a8
		v_lshlrev_b32_e32 v7, 1, v7
		v_accvgpr_read_b32 v12, a15
		v_lshlrev_b32_e32 v12, 5, v12
		v_accvgpr_write_b32 a60, v12
		v_accvgpr_read_b32 v12, a16
		v_accvgpr_read_b32 v15, a60
		v_lshl_add_u32 v12, v12, 6, v15
		v_lshlrev_b32_e32 v15, 4, v9
		v_accvgpr_write_b32 a61, v15
		v_accvgpr_read_b32 v15, a61
		v_xor_b32_e32 v12, v12, v15
		v_accvgpr_read_b32 v15, a14
		v_bitop3_b32 v12, v7, v15, v12 bitop3:0x96
		v_mul_lo_u32 v15, s15, v12
		v_accvgpr_read_b32 v18, a17
		v_lshlrev_b32_e32 v18, 4, v18
		v_lshl_add_u32 v15, v15, 1, v18
		v_accvgpr_read_b32 v20, a18
		v_lshlrev_b32_e32 v20, 6, v20
		v_accvgpr_read_b32 v21, a19
		v_lshlrev_b32_e32 v21, 5, v21
		v_add3_u32 v15, v15, v20, v21
		v_accvgpr_write_b32 a62, v15
		v_readfirstlane_b32 s37, v3
		s_mul_i32 s37, s37, s13
		s_lshl_b32 s37, s37, 1
		v_readfirstlane_b32 s53, v4
		s_mul_i32 s53, s53, s14
		s_lshl_b32 s53, s53, 1
		s_add_i32 s54, s37, s53
		v_accvgpr_read_b32 v15, a62
		v_add_u32_e32 v15, s54, v15
		v_mov_b32_e32 v22, 0x80000000
		v_cndmask_b32_e64 v15, v22, v15, s[38:39]
		s_lshr_b32 s38, s52, 6
		s_mul_i32 s39, 0x410, s38
		s_mov_b32 m0, s39
		v_xor_b32_e32 v6, v6, v13
		buffer_load_dwordx4 v15, s[28:31], 0 offen lds
		v_bitop3_b32 v6, v6, v19, v16 bitop3:0x96
		v_accvgpr_write_b32 a63, v6
		v_xor_b32_e32 v6, 4, v12
		v_mul_lo_u32 v13, s15, v6
		v_lshl_add_u32 v13, v13, 1, v18
		v_add3_u32 v13, v13, v20, v21
		v_accvgpr_write_b32 a64, v13
		v_accvgpr_read_b32 v13, a64
		v_add_u32_e32 v13, s54, v13
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v13, v22, v13, s[40:41]
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		v_xor_b32_e32 v12, 8, v12
		v_mul_lo_u32 v12, s15, v12
		v_lshl_add_u32 v12, v12, 1, v18
		v_add3_u32 v12, v12, v20, v21
		v_accvgpr_write_b32 a65, v12
		v_accvgpr_read_b32 v12, a65
		v_add_u32_e32 v12, s54, v12
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v12, v22, v12, s[42:43]
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		v_xor_b32_e32 v6, 8, v6
		v_mul_lo_u32 v6, s15, v6
		v_lshl_add_u32 v6, v6, 1, v18
		v_add3_u32 v6, v6, v20, v21
		v_accvgpr_write_b32 a66, v6
		v_accvgpr_read_b32 v6, a66
		v_add_u32_e32 v6, s54, v6
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v6, v22, v6, s[44:45]
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_accvgpr_read_b32 v6, a60
		v_lshl_add_u32 v6, v9, 6, v6
		v_accvgpr_read_b32 v12, a16
		v_lshl_add_u32 v6, v12, 4, v6
		v_accvgpr_read_b32 v12, a14
		v_bitop3_b32 v6, v7, v6, v12 bitop3:0x96
		v_mul_lo_u32 v7, s18, v6
		v_lshl_add_u32 v7, v7, 1, v18
		v_add3_u32 v7, v7, v20, v21
		v_accvgpr_write_b32 a67, v7
		v_accvgpr_read_b32 v7, a0
		s_nop 0
		v_readfirstlane_b32 s40, v7
		v_readfirstlane_b32 s41, v3
		s_mul_i32 s40, s41, s40
		s_lshl_b32 s40, s40, 1
		v_accvgpr_read_b32 v7, a1
		s_nop 0
		v_readfirstlane_b32 s41, v7
		v_readfirstlane_b32 s42, v4
		s_mul_i32 s41, s42, s41
		s_lshl_b32 s41, s41, 1
		s_add_i32 s42, s40, s41
		v_accvgpr_read_b32 v7, a67
		v_add_u32_e32 v7, s42, v7
		s_mul_i32 s38, 0x440, s38
		s_add_i32 m0, s38, 0x81f0
		v_cndmask_b32_e64 v7, v22, v7, s[46:47]
		buffer_load_dwordx4 v7, s[32:35], 0 offen lds
		v_xor_b32_e32 v7, 4, v6
		v_mul_lo_u32 v12, s18, v7
		v_lshl_add_u32 v12, v12, 1, v18
		v_add3_u32 v12, v12, v20, v21
		v_accvgpr_write_b32 a68, v12
		v_accvgpr_read_b32 v12, a68
		v_add_u32_e32 v12, s42, v12
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v12, v22, v12, s[48:49]
		buffer_load_dwordx4 v12, s[32:35], 0 offen lds
		v_xor_b32_e32 v6, 8, v6
		v_mul_lo_u32 v6, s18, v6
		v_lshl_add_u32 v6, v6, 1, v18
		v_add3_u32 v6, v6, v20, v21
		v_accvgpr_write_b32 a69, v6
		v_accvgpr_read_b32 v6, a69
		v_add_u32_e32 v6, s42, v6
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v6, v22, v6, s[50:51]
		buffer_load_dwordx4 v6, s[32:35], 0 offen lds
		v_xor_b32_e32 v6, 8, v7
		v_mul_lo_u32 v6, s18, v6
		v_lshl_add_u32 v6, v6, 1, v18
		v_add3_u32 v6, v6, v20, v21
		v_accvgpr_write_b32 a70, v6
		v_accvgpr_read_b32 v6, a63
		v_cmp_lt_i32_e64 vcc, v6, s22
		v_accvgpr_read_b32 v6, a70
		v_add_u32_e32 v6, s42, v6
		v_mbcnt_lo_u32_b32 v7, -1, 0
		v_cndmask_b32_e32 v6, v22, v6, vcc
		s_add_i32 m0, m0, 0x1100
		s_mul_i32 s42, s36, 0x80
		buffer_load_dwordx4 v6, s[32:35], 0 offen lds
		v_mbcnt_hi_u32_b32 v6, -1, v7
		v_and_b32_e32 v7, 1, v6
		v_lshrrev_b32_e32 v12, 4, v6
		v_and_b32_e32 v12, 1, v12
		v_lshlrev_b32_e32 v12, 4, v12
		v_lshrrev_b32_e32 v13, 3, v6
		v_and_b32_e32 v13, 1, v13
		v_lshlrev_b32_e32 v13, 3, v13
		v_add3_u32 v15, v7, v12, v13
		v_lshrrev_b32_e32 v16, 2, v6
		v_and_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v16, 2, v16
		v_lshrrev_b32_e32 v6, 1, v6
		v_and_b32_e32 v6, 1, v6
		v_lshlrev_b32_e32 v6, 1, v6
		v_add3_u32 v15, v15, v16, v6
		v_add_u32_e32 v7, 32, v7
		v_bitop3_b32 v6, v16, v7, v6 bitop3:0x96
		v_bitop3_b32 v6, v12, v13, v6 bitop3:0x96
		v_mov_b32_e32 v12, 0x3e38aa3b
		v_mov_b32_e32 v13, 0x3e38aa3b
		s_mov_b32 s36, 0xff800000
		v_mov_b32_e32 v7, s36
		v_mov_b32_e32 v16, s36
		s_mov_b32 s36, 1.0
		v_mov_b32_e32 v18, s36
		v_mov_b32_e32 v19, s36
		s_mov_b32 s36, 0
		v_accvgpr_read_b32 v20, a20
		v_lshlrev_b32_e32 v20, 4, v20
		v_accvgpr_write_b32 a71, v20
		v_and_b32_e32 v14, 31, v14
		v_lshrrev_b32_e32 v20, 4, v14
		v_lshlrev_b32_e32 v20, 9, v20
		v_accvgpr_write_b32 a72, v20
		v_lshrrev_b32_e32 v20, 3, v14
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v21, 0x2080
		v_mul_lo_u32 v21, v21, v20
		v_accvgpr_write_b32 a73, v21
		v_lshrrev_b32_e32 v20, 2, v14
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v21, 0x1040
		v_mul_lo_u32 v21, v21, v20
		v_accvgpr_write_b32 a74, v21
		v_lshrrev_b32_e32 v20, 1, v14
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v21, 0x820
		v_mul_lo_u32 v21, v21, v20
		v_accvgpr_write_b32 a75, v21
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v20, 0x410
		v_mul_lo_u32 v20, v20, v14
		v_accvgpr_write_b32 a76, v20
		v_and_b32_e32 v14, 3, v0
		v_accvgpr_write_b32 a77, v14
		v_accvgpr_read_b32 v14, a77
		v_lshlrev_b32_e32 v14, 3, v14
		v_accvgpr_write_b32 a78, v14
		v_mov_b32_e32 v14, 0x2200
		v_mul_lo_u32 v14, v14, v9
		v_accvgpr_write_b32 a79, v14
		v_and_b32_e32 v8, 3, v8
		v_mov_b32_e32 v9, 0x440
		v_mul_lo_u32 v9, v9, v8
		v_accvgpr_write_b32 a80, v9
		s_lshl_b32 s43, s15, 8
		s_add_i32 s37, s43, s37
		s_add_i32 s37, s37, s53
		s_lshl_b32 s43, s18, 8
		s_add_i32 s40, s43, s40
		s_add_i32 s40, s40, s41
		v_lshlrev_b32_e32 v8, 2, v15
		v_lshlrev_b32_e32 v6, 2, v6
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
		s_lshr_b32 s41, s36, 7
		s_and_b32 s43, s41, 1
		s_mul_i32 s44, 0x4100, s43
		v_accvgpr_read_b32 v9, a71
		v_accvgpr_read_b32 v14, a72
		v_add3_u32 v9, s44, v9, v14
		v_accvgpr_read_b32 v14, a73
		v_accvgpr_read_b32 v15, a74
		v_add3_u32 v9, v9, v14, v15
		v_accvgpr_read_b32 v14, a75
		v_accvgpr_read_b32 v15, a76
		v_add3_u32 v9, v9, v14, v15
		ds_read_b128 v[24:27], v9
		ds_read_b128 a[84:87], v9 offset:32
		ds_read_b128 a[88:91], v9 offset:64
		ds_read_b128 a[92:95], v9 offset:96
		ds_read_b128 v[28:31], v9 offset:256
		ds_read_b128 a[96:99], v9 offset:288
		ds_read_b128 a[100:103], v9 offset:320
		ds_read_b128 a[104:107], v9 offset:352
		ds_read_b128 a[108:111], v9 offset:128
		ds_read_b128 a[112:115], v9 offset:160
		ds_read_b128 a[116:119], v9 offset:192
		ds_read_b128 a[120:123], v9 offset:224
		ds_read_b128 v[96:99], v9 offset:384
		ds_read_b128 a[124:127], v9 offset:416
		ds_read_b128 a[128:131], v9 offset:448
		ds_read_b128 a[132:135], v9 offset:480
		s_mul_i32 s43, 0x4400, s43
		v_accvgpr_read_b32 v9, a78
		v_accvgpr_read_b32 v14, a79
		v_add3_u32 v9, s43, v9, v14
		v_accvgpr_read_b32 v14, a80
		v_accvgpr_read_b32 v15, a60
		v_add3_u32 v9, v9, v15, v14
		ds_read_b64_tr_b16 a[136:137], v9 offset:33264
		ds_read_b64_tr_b16 a[138:139], v9 offset:37616
		ds_read_b64_tr_b16 a[140:141], v9 offset:33392
		ds_read_b64_tr_b16 a[142:143], v9 offset:37744
		ds_read_b64_tr_b16 a[144:145], v9 offset:33520
		ds_read_b64_tr_b16 a[146:147], v9 offset:37872
		ds_read_b64_tr_b16 a[148:149], v9 offset:33648
		ds_read_b64_tr_b16 a[150:151], v9 offset:38000
		ds_read_b64_tr_b16 a[152:153], v9 offset:33776
		ds_read_b64_tr_b16 a[154:155], v9 offset:38128
		ds_read_b64_tr_b16 a[156:157], v9 offset:33904
		ds_read_b64_tr_b16 a[158:159], v9 offset:38256
		ds_read_b64_tr_b16 a[160:161], v9 offset:34032
		ds_read_b64_tr_b16 a[162:163], v9 offset:38384
		ds_read_b64_tr_b16 a[164:165], v9 offset:34160
		ds_read_b64_tr_b16 a[166:167], v9 offset:38512
		ds_read_b64_tr_b16 a[168:169], v9 offset:33328
		ds_read_b64_tr_b16 a[170:171], v9 offset:37680
		ds_read_b64_tr_b16 a[172:173], v9 offset:33456
		ds_read_b64_tr_b16 a[174:175], v9 offset:37808
		ds_read_b64_tr_b16 a[176:177], v9 offset:33584
		ds_read_b64_tr_b16 a[178:179], v9 offset:37936
		ds_read_b64_tr_b16 a[180:181], v9 offset:33712
		ds_read_b64_tr_b16 a[182:183], v9 offset:38064
		ds_read_b64_tr_b16 a[184:185], v9 offset:33840
		ds_read_b64_tr_b16 a[186:187], v9 offset:38192
		ds_read_b64_tr_b16 a[188:189], v9 offset:33968
		ds_read_b64_tr_b16 a[190:191], v9 offset:38320
		ds_read_b64_tr_b16 a[192:193], v9 offset:34096
		ds_read_b64_tr_b16 a[194:195], v9 offset:38448
		ds_read_b64_tr_b16 a[196:197], v9 offset:34224
		ds_read_b64_tr_b16 a[198:199], v9 offset:38576
		s_mul_i32 s43, s15, s36
		s_lshl_b32 s43, s43, 1
		s_add_i32 s43, s37, s43
		v_accvgpr_read_b32 v9, a62
		v_add_u32_e32 v9, s43, v9
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v14, a64
		v_add_u32_e32 v14, s43, v14
		s_add_i32 s41, s41, 1
		v_accvgpr_read_b32 v15, a65
		v_add_u32_e32 v15, s43, v15
		s_and_b32 s41, s41, 1
		v_accvgpr_read_b32 v20, a66
		v_add_u32_e32 v20, s43, v20
		s_mul_i32 s43, 0x4100, s41
		v_mfma_f32_32x32x16_bf16 v[112:127], v[24:27], a[24:27], 0
		s_add_i32 s43, s39, s43
		v_mfma_f32_32x32x16_bf16 v[128:143], v[28:31], a[24:27], 0
		s_mov_b32 m0, s43
		v_mfma_f32_32x32x16_bf16 v[144:159], a[108:111], a[24:27], 0
		s_mul_i32 s43, s18, s36
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], a[24:27], 0
		s_add_i32 s36, s36, 0x80
		v_mfma_f32_32x32x16_bf16 v[176:191], v[96:99], a[40:43], 0
		v_accvgpr_read_b32 v21, a21
		v_add_u32_e32 v21, s36, v21
		v_mfma_f32_32x32x16_bf16 v[96:111], v[24:27], a[40:43], 0
		v_accvgpr_read_b32 v23, a22
		v_add_u32_e32 v23, s36, v23
		v_mfma_f32_32x32x16_bf16 v[192:207], v[28:31], a[40:43], 0
		v_accvgpr_read_b32 v24, a23
		v_add_u32_e32 v24, s36, v24
		v_mfma_f32_32x32x16_bf16 v[208:223], a[108:111], a[40:43], 0
		v_accvgpr_read_b32 v25, a56
		v_add_u32_e32 v25, s36, v25
		v_mfma_f32_32x32x16_bf16 v[112:127], a[84:87], a[28:31], v[112:127]
		v_cmp_lt_i32_e64 vcc, v21, s22
		s_mov_b64 s[44:45], vcc
		v_mfma_f32_32x32x16_bf16 v[128:143], a[96:99], a[28:31], v[128:143]
		v_cmp_lt_i32_e64 vcc, v23, s22
		s_mov_b64 s[46:47], vcc
		v_mfma_f32_32x32x16_bf16 v[144:159], a[112:115], a[28:31], v[144:159]
		v_cmp_lt_i32_e64 vcc, v24, s22
		s_mov_b64 s[48:49], vcc
		v_mfma_f32_32x32x16_bf16 v[160:175], a[124:127], a[28:31], v[160:175]
		v_cmp_lt_i32_e64 vcc, v25, s22
		s_mov_b64 s[50:51], vcc
		v_mfma_f32_32x32x16_bf16 v[176:191], a[124:127], a[44:47], v[176:191]
		v_accvgpr_read_b32 v21, a57
		v_add_u32_e32 v21, s36, v21
		v_mfma_f32_32x32x16_bf16 v[96:111], a[84:87], a[44:47], v[96:111]
		v_accvgpr_read_b32 v23, a58
		v_add_u32_e32 v23, s36, v23
		v_mfma_f32_32x32x16_bf16 v[192:207], a[96:99], a[44:47], v[192:207]
		v_accvgpr_read_b32 v24, a59
		v_add_u32_e32 v24, s36, v24
		v_mfma_f32_32x32x16_bf16 v[208:223], a[112:115], a[44:47], v[208:223]
		v_cmp_lt_i32_e64 vcc, v21, s22
		s_mov_b64 s[54:55], vcc
		v_mfma_f32_32x32x16_bf16 v[112:127], a[88:91], a[32:35], v[112:127]
		v_cmp_lt_i32_e64 vcc, v23, s22
		s_mov_b64 s[56:57], vcc
		v_mfma_f32_32x32x16_bf16 v[128:143], a[100:103], a[32:35], v[128:143]
		v_cmp_lt_i32_e64 vcc, v24, s22
		s_mov_b64 s[58:59], vcc
		v_mfma_f32_32x32x16_bf16 v[144:159], a[116:119], a[32:35], v[144:159]
		v_cndmask_b32_e64 v9, v22, v9, s[44:45]
		buffer_load_dwordx4 v9, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[160:175], a[128:131], a[32:35], v[160:175]
		v_accvgpr_read_b32 v9, a63
		v_add_u32_e32 v9, s36, v9
		v_cndmask_b32_e64 v14, v22, v14, s[46:47]
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v15, v22, v15, s[48:49]
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		v_cndmask_b32_e64 v14, v22, v20, s[50:51]
		v_cmp_lt_i32_e64 vcc, v9, s22
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s43, s43, 1
		s_add_i32 s43, s40, s43
		buffer_load_dwordx4 v15, s[28:31], 0 offen lds
		v_accvgpr_read_b32 v9, a67
		v_add_u32_e32 v9, s43, v9
		v_cndmask_b32_e64 v9, v22, v9, s[54:55]
		s_add_i32 m0, m0, 0x1040
		s_mul_i32 s41, 0x4400, s41
		s_add_i32 s41, s38, s41
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		v_accvgpr_read_b32 v14, a68
		v_add_u32_e32 v14, s43, v14
		v_cndmask_b32_e64 v14, v22, v14, s[56:57]
		s_add_i32 m0, s41, 0x81f0
		v_accvgpr_read_b32 v15, a69
		v_add_u32_e32 v15, s43, v15
		v_cndmask_b32_e64 v15, v22, v15, s[58:59]
		buffer_load_dwordx4 v9, s[32:35], 0 offen lds
		v_accvgpr_read_b32 v9, a70
		v_add_u32_e32 v9, s43, v9
		v_cndmask_b32_e32 v9, v22, v9, vcc
		s_add_i32 m0, m0, 0x1100
		v_mfma_f32_32x32x16_bf16 v[176:191], a[128:131], a[48:51], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[88:91], a[48:51], v[96:111]
		buffer_load_dwordx4 v14, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[192:207], a[100:103], a[48:51], v[192:207]
		s_add_i32 m0, m0, 0x1100
		v_mfma_f32_32x32x16_bf16 v[208:223], a[116:119], a[48:51], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[92:95], a[36:39], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[104:107], a[36:39], v[128:143]
		buffer_load_dwordx4 v15, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[144:159], a[120:123], a[36:39], v[144:159]
		s_add_i32 m0, m0, 0x1100
		s_cmp_lt_i32 s36, s42
		v_mfma_f32_32x32x16_bf16 v[160:175], a[132:135], a[36:39], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[132:135], a[52:55], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[92:95], a[52:55], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[104:107], a[52:55], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[120:123], a[52:55], v[208:223]
		buffer_load_dwordx4 v9, s[32:35], 0 offen lds
		s_nop 0
		v_max_f32_e32 v9, v112, v113
		v_max_f32_e32 v14, v114, v115
		v_max_f32_e32 v15, v116, v117
		v_max_f32_e32 v20, v118, v119
		v_max_f32_e32 v21, v120, v121
		v_max_f32_e32 v23, v122, v123
		v_max_f32_e32 v24, v124, v125
		v_max_f32_e32 v25, v126, v127
		v_max_f32_e32 v26, v128, v129
		v_max_f32_e32 v27, v130, v131
		v_max_f32_e32 v28, v132, v133
		v_max_f32_e32 v29, v134, v135
		v_max_f32_e32 v30, v136, v137
		v_max_f32_e32 v31, v138, v139
		v_max_f32_e32 v224, v140, v141
		v_max_f32_e32 v225, v142, v143
		v_max_f32_e32 v226, v144, v145
		v_max_f32_e32 v227, v146, v147
		v_max_f32_e32 v228, v148, v149
		v_max_f32_e32 v229, v150, v151
		v_max_f32_e32 v230, v152, v153
		v_max_f32_e32 v231, v154, v155
		v_max_f32_e32 v232, v156, v157
		v_max_f32_e32 v233, v158, v159
		v_max_f32_e32 v234, v160, v161
		v_max_f32_e32 v235, v162, v163
		v_max_f32_e32 v236, v164, v165
		v_max_f32_e32 v237, v166, v167
		v_max_f32_e32 v238, v168, v169
		v_max_f32_e32 v239, v170, v171
		v_max_f32_e32 v240, v172, v173
		v_max_f32_e32 v241, v174, v175
		v_max_f32_e32 v9, v9, v14
		v_max_f32_e32 v14, v15, v20
		v_max_f32_e32 v15, v21, v23
		v_max_f32_e32 v20, v24, v25
		v_max_f32_e32 v21, v26, v27
		v_max_f32_e32 v23, v28, v29
		v_max_f32_e32 v24, v30, v31
		v_max_f32_e32 v25, v224, v225
		v_max_f32_e32 v26, v226, v227
		v_max_f32_e32 v27, v228, v229
		v_max_f32_e32 v28, v230, v231
		v_max_f32_e32 v29, v232, v233
		v_max_f32_e32 v30, v234, v235
		v_max_f32_e32 v31, v236, v237
		v_max_f32_e32 v224, v238, v239
		v_max_f32_e32 v225, v240, v241
		v_max_f32_e32 v9, v9, v14
		v_max_f32_e32 v14, v15, v20
		v_max_f32_e32 v15, v21, v23
		v_max_f32_e32 v20, v24, v25
		v_max_f32_e32 v21, v26, v27
		v_max_f32_e32 v23, v28, v29
		v_max_f32_e32 v24, v30, v31
		v_max_f32_e32 v25, v224, v225
		v_max_f32_e32 v9, v9, v14
		v_max_f32_e32 v14, v15, v20
		v_max_f32_e32 v15, v21, v23
		v_max_f32_e32 v20, v24, v25
		v_max_f32_e32 v9, v9, v14
		v_max_f32_e32 v14, v15, v20
		v_max_f32_e32 v9, v9, v14
		ds_bpermute_b32 v14, v8, v9
		ds_bpermute_b32 v15, v6, v9
		v_max_f32_e32 v9, v96, v97
		v_max_f32_e32 v20, v98, v99
		v_max_f32_e32 v21, v100, v101
		v_max_f32_e32 v23, v102, v103
		v_max_f32_e32 v24, v104, v105
		v_max_f32_e32 v25, v106, v107
		v_max_f32_e32 v26, v108, v109
		v_max_f32_e32 v27, v110, v111
		v_max_f32_e32 v28, v192, v193
		v_max_f32_e32 v29, v194, v195
		v_max_f32_e32 v30, v196, v197
		v_max_f32_e32 v31, v198, v199
		v_max_f32_e32 v224, v200, v201
		v_max_f32_e32 v225, v202, v203
		v_max_f32_e32 v226, v204, v205
		v_max_f32_e32 v227, v206, v207
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v228, v14, v15
		v_max_f32_e32 v14, v208, v209
		v_max_f32_e32 v15, v210, v211
		v_max_f32_e32 v229, v212, v213
		v_max_f32_e32 v230, v214, v215
		v_max_f32_e32 v231, v216, v217
		v_max_f32_e32 v232, v218, v219
		v_max_f32_e32 v233, v220, v221
		v_max_f32_e32 v234, v222, v223
		v_max_f32_e32 v235, v176, v177
		v_max_f32_e32 v236, v178, v179
		v_max_f32_e32 v237, v180, v181
		v_max_f32_e32 v238, v182, v183
		v_max_f32_e32 v239, v184, v185
		v_max_f32_e32 v240, v186, v187
		v_max_f32_e32 v241, v188, v189
		v_max_f32_e32 v242, v190, v191
		v_max_f32_e32 v9, v9, v20
		v_max_f32_e32 v20, v21, v23
		v_max_f32_e32 v21, v24, v25
		v_max_f32_e32 v23, v26, v27
		v_max_f32_e32 v24, v28, v29
		v_max_f32_e32 v25, v30, v31
		v_max_f32_e32 v26, v224, v225
		v_max_f32_e32 v27, v226, v227
		v_max_f32_e32 v14, v14, v15
		v_max_f32_e32 v15, v229, v230
		v_max_f32_e32 v28, v231, v232
		v_max_f32_e32 v29, v233, v234
		v_max_f32_e32 v30, v235, v236
		v_max_f32_e32 v31, v237, v238
		v_max_f32_e32 v224, v239, v240
		v_max_f32_e32 v225, v241, v242
		v_max_f32_e32 v9, v9, v20
		v_max_f32_e32 v20, v21, v23
		v_max_f32_e32 v21, v24, v25
		v_max_f32_e32 v23, v26, v27
		v_max_f32_e32 v14, v14, v15
		v_max_f32_e32 v15, v28, v29
		v_max_f32_e32 v24, v30, v31
		v_max_f32_e32 v25, v224, v225
		v_max_f32_e32 v9, v9, v20
		v_max_f32_e32 v20, v21, v23
		v_max_f32_e32 v14, v14, v15
		v_max_f32_e32 v15, v24, v25
		v_max_f32_e32 v9, v9, v20
		v_max_f32_e32 v14, v14, v15
		v_max_f32_e32 v9, v9, v14
		ds_bpermute_b32 v14, v8, v9
		ds_bpermute_b32 v15, v6, v9
		v_pk_mul_f32 v[20:21], v[112:113], v[12:13]
		v_pk_mul_f32 v[24:25], v[114:115], v[12:13]
		v_pk_mul_f32 v[26:27], v[116:117], v[12:13]
		v_pk_mul_f32 v[28:29], v[118:119], v[12:13]
		v_pk_mul_f32 v[30:31], v[120:121], v[12:13]
		v_pk_mul_f32 v[112:113], v[122:123], v[12:13]
		v_pk_mul_f32 v[114:115], v[124:125], v[12:13]
		v_pk_mul_f32 v[116:117], v[126:127], v[12:13]
		v_pk_mul_f32 v[118:119], v[128:129], v[12:13]
		v_pk_mul_f32 v[120:121], v[130:131], v[12:13]
		v_pk_mul_f32 v[122:123], v[132:133], v[12:13]
		v_pk_mul_f32 v[124:125], v[134:135], v[12:13]
		v_pk_mul_f32 v[126:127], v[136:137], v[12:13]
		v_pk_mul_f32 v[128:129], v[138:139], v[12:13]
		v_pk_mul_f32 v[130:131], v[140:141], v[12:13]
		v_pk_mul_f32 v[132:133], v[142:143], v[12:13]
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v229, v14, v15
		v_pk_mul_f32 v[14:15], v[228:229], v[12:13]
		v_max_f32_e32 v9, v7, v14
		v_max_f32_e32 v14, v16, v15
		v_pk_mul_f32 v[134:135], v[144:145], v[12:13]
		v_pk_mul_f32 v[136:137], v[146:147], v[12:13]
		v_pk_mul_f32 v[138:139], v[148:149], v[12:13]
		v_pk_mul_f32 v[140:141], v[150:151], v[12:13]
		v_pk_mul_f32 v[142:143], v[152:153], v[12:13]
		v_pk_mul_f32 v[144:145], v[154:155], v[12:13]
		v_pk_mul_f32 v[146:147], v[156:157], v[12:13]
		v_pk_mul_f32 v[148:149], v[158:159], v[12:13]
		v_pk_mul_f32 v[150:151], v[160:161], v[12:13]
		v_pk_mul_f32 v[152:153], v[162:163], v[12:13]
		v_pk_mul_f32 v[154:155], v[164:165], v[12:13]
		v_pk_mul_f32 v[156:157], v[166:167], v[12:13]
		v_pk_mul_f32 v[158:159], v[168:169], v[12:13]
		v_pk_mul_f32 v[160:161], v[170:171], v[12:13]
		v_pk_mul_f32 v[162:163], v[172:173], v[12:13]
		v_pk_mul_f32 v[164:165], v[174:175], v[12:13]
		v_pk_mul_f32 v[166:167], v[96:97], v[12:13]
		v_pk_mul_f32 v[96:97], v[98:99], v[12:13]
		v_pk_mul_f32 v[98:99], v[100:101], v[12:13]
		v_pk_mul_f32 v[100:101], v[102:103], v[12:13]
		v_pk_mul_f32 v[102:103], v[104:105], v[12:13]
		v_pk_mul_f32 v[104:105], v[106:107], v[12:13]
		v_pk_mul_f32 v[106:107], v[108:109], v[12:13]
		v_pk_mul_f32 v[108:109], v[110:111], v[12:13]
		v_pk_mul_f32 v[110:111], v[192:193], v[12:13]
		v_pk_mul_f32 v[168:169], v[194:195], v[12:13]
		v_pk_mul_f32 v[170:171], v[196:197], v[12:13]
		v_pk_mul_f32 v[172:173], v[198:199], v[12:13]
		v_pk_mul_f32 v[174:175], v[200:201], v[12:13]
		v_pk_mul_f32 v[192:193], v[202:203], v[12:13]
		v_pk_mul_f32 v[194:195], v[204:205], v[12:13]
		v_pk_mul_f32 v[196:197], v[206:207], v[12:13]
		v_pk_mul_f32 v[198:199], v[208:209], v[12:13]
		v_pk_mul_f32 v[200:201], v[210:211], v[12:13]
		v_pk_mul_f32 v[202:203], v[212:213], v[12:13]
		v_pk_mul_f32 v[204:205], v[214:215], v[12:13]
		v_pk_mul_f32 v[206:207], v[216:217], v[12:13]
		v_pk_mul_f32 v[208:209], v[218:219], v[12:13]
		v_pk_mul_f32 v[210:211], v[220:221], v[12:13]
		v_pk_mul_f32 v[212:213], v[222:223], v[12:13]
		v_pk_mul_f32 v[214:215], v[176:177], v[12:13]
		v_pk_mul_f32 v[176:177], v[178:179], v[12:13]
		v_pk_mul_f32 v[178:179], v[180:181], v[12:13]
		v_pk_mul_f32 v[180:181], v[182:183], v[12:13]
		v_pk_mul_f32 v[182:183], v[184:185], v[12:13]
		v_pk_mul_f32 v[184:185], v[186:187], v[12:13]
		v_pk_mul_f32 v[186:187], v[188:189], v[12:13]
		v_pk_mul_f32 v[188:189], v[190:191], v[12:13]
		v_sub_f32_e32 v15, v20, v9
		v_sub_f32_e32 v20, v21, v9
		v_sub_f32_e32 v21, v24, v9
		v_sub_f32_e32 v23, v25, v9
		v_sub_f32_e32 v24, v26, v9
		v_sub_f32_e32 v25, v27, v9
		v_sub_f32_e32 v26, v28, v9
		v_sub_f32_e32 v27, v29, v9
		v_sub_f32_e32 v28, v30, v9
		v_sub_f32_e32 v29, v31, v9
		v_sub_f32_e32 v30, v112, v9
		v_sub_f32_e32 v31, v113, v9
		v_sub_f32_e32 v112, v114, v9
		v_sub_f32_e32 v113, v115, v9
		v_sub_f32_e32 v114, v116, v9
		v_sub_f32_e32 v115, v117, v9
		v_sub_f32_e32 v116, v118, v9
		v_sub_f32_e32 v117, v119, v9
		v_sub_f32_e32 v118, v120, v9
		v_sub_f32_e32 v119, v121, v9
		v_sub_f32_e32 v120, v122, v9
		v_sub_f32_e32 v121, v123, v9
		v_sub_f32_e32 v122, v124, v9
		v_sub_f32_e32 v123, v125, v9
		v_sub_f32_e32 v124, v126, v9
		v_sub_f32_e32 v125, v127, v9
		v_sub_f32_e32 v126, v128, v9
		v_sub_f32_e32 v127, v129, v9
		v_sub_f32_e32 v128, v130, v9
		v_sub_f32_e32 v129, v131, v9
		v_sub_f32_e32 v130, v132, v9
		v_sub_f32_e32 v131, v133, v9
		v_sub_f32_e32 v132, v134, v9
		v_sub_f32_e32 v133, v135, v9
		v_sub_f32_e32 v134, v136, v9
		v_sub_f32_e32 v135, v137, v9
		v_sub_f32_e32 v136, v138, v9
		v_sub_f32_e32 v137, v139, v9
		v_sub_f32_e32 v138, v140, v9
		v_sub_f32_e32 v139, v141, v9
		v_sub_f32_e32 v140, v142, v9
		v_sub_f32_e32 v141, v143, v9
		v_sub_f32_e32 v142, v144, v9
		v_sub_f32_e32 v143, v145, v9
		v_sub_f32_e32 v144, v146, v9
		v_sub_f32_e32 v145, v147, v9
		v_sub_f32_e32 v146, v148, v9
		v_sub_f32_e32 v147, v149, v9
		v_sub_f32_e32 v148, v150, v9
		v_sub_f32_e32 v149, v151, v9
		v_sub_f32_e32 v150, v152, v9
		v_sub_f32_e32 v151, v153, v9
		v_sub_f32_e32 v152, v154, v9
		v_sub_f32_e32 v153, v155, v9
		v_sub_f32_e32 v154, v156, v9
		v_sub_f32_e32 v155, v157, v9
		v_sub_f32_e32 v156, v158, v9
		v_sub_f32_e32 v157, v159, v9
		v_sub_f32_e32 v158, v160, v9
		v_sub_f32_e32 v159, v161, v9
		v_sub_f32_e32 v160, v162, v9
		v_sub_f32_e32 v161, v163, v9
		v_sub_f32_e32 v162, v164, v9
		v_sub_f32_e32 v163, v165, v9
		v_sub_f32_e32 v164, v166, v14
		v_sub_f32_e32 v165, v167, v14
		v_sub_f32_e32 v96, v96, v14
		v_sub_f32_e32 v97, v97, v14
		v_sub_f32_e32 v98, v98, v14
		v_sub_f32_e32 v99, v99, v14
		v_sub_f32_e32 v100, v100, v14
		v_sub_f32_e32 v101, v101, v14
		v_sub_f32_e32 v102, v102, v14
		v_sub_f32_e32 v103, v103, v14
		v_sub_f32_e32 v104, v104, v14
		v_sub_f32_e32 v105, v105, v14
		v_sub_f32_e32 v106, v106, v14
		v_sub_f32_e32 v107, v107, v14
		v_sub_f32_e32 v108, v108, v14
		v_sub_f32_e32 v109, v109, v14
		v_sub_f32_e32 v110, v110, v14
		v_sub_f32_e32 v111, v111, v14
		v_sub_f32_e32 v166, v168, v14
		v_sub_f32_e32 v167, v169, v14
		v_sub_f32_e32 v168, v170, v14
		v_sub_f32_e32 v169, v171, v14
		v_sub_f32_e32 v170, v172, v14
		v_sub_f32_e32 v171, v173, v14
		v_sub_f32_e32 v172, v174, v14
		v_sub_f32_e32 v173, v175, v14
		v_sub_f32_e32 v174, v192, v14
		v_sub_f32_e32 v175, v193, v14
		v_sub_f32_e32 v190, v194, v14
		v_sub_f32_e32 v191, v195, v14
		v_sub_f32_e32 v192, v196, v14
		v_sub_f32_e32 v193, v197, v14
		v_sub_f32_e32 v194, v198, v14
		v_sub_f32_e32 v195, v199, v14
		v_sub_f32_e32 v196, v200, v14
		v_sub_f32_e32 v197, v201, v14
		v_sub_f32_e32 v198, v202, v14
		v_sub_f32_e32 v199, v203, v14
		v_sub_f32_e32 v200, v204, v14
		v_sub_f32_e32 v201, v205, v14
		v_sub_f32_e32 v202, v206, v14
		v_sub_f32_e32 v203, v207, v14
		v_sub_f32_e32 v204, v208, v14
		v_sub_f32_e32 v205, v209, v14
		v_sub_f32_e32 v206, v210, v14
		v_sub_f32_e32 v207, v211, v14
		v_sub_f32_e32 v208, v212, v14
		v_sub_f32_e32 v209, v213, v14
		v_sub_f32_e32 v210, v214, v14
		v_sub_f32_e32 v211, v215, v14
		v_sub_f32_e32 v176, v176, v14
		v_sub_f32_e32 v177, v177, v14
		v_sub_f32_e32 v178, v178, v14
		v_sub_f32_e32 v179, v179, v14
		v_sub_f32_e32 v180, v180, v14
		v_sub_f32_e32 v181, v181, v14
		v_sub_f32_e32 v182, v182, v14
		v_sub_f32_e32 v183, v183, v14
		v_sub_f32_e32 v184, v184, v14
		v_sub_f32_e32 v185, v185, v14
		v_sub_f32_e32 v186, v186, v14
		v_sub_f32_e32 v187, v187, v14
		v_sub_f32_e32 v188, v188, v14
		v_sub_f32_e32 v189, v189, v14
		v_exp_f32_e32 v212, v15
		v_exp_f32_e32 v214, v20
		v_exp_f32_e32 v213, v21
		v_exp_f32_e32 v215, v23
		v_exp_f32_e32 v20, v24
		v_exp_f32_e32 v216, v25
		v_exp_f32_e32 v21, v26
		v_exp_f32_e32 v217, v27
		v_exp_f32_e32 v24, v28
		v_exp_f32_e32 v26, v29
		v_exp_f32_e32 v25, v30
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
		v_exp_f32_e32 v161, v164
		v_exp_f32_e32 v163, v165
		v_exp_f32_e32 v164, v96
		v_exp_f32_e32 v218, v97
		v_exp_f32_e32 v165, v98
		v_exp_f32_e32 v219, v99
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
		v_exp_f32_e32 v108, v166
		v_exp_f32_e32 v110, v167
		v_exp_f32_e32 v109, v168
		v_exp_f32_e32 v111, v169
		v_exp_f32_e32 v166, v170
		v_exp_f32_e32 v168, v171
		v_exp_f32_e32 v167, v172
		v_exp_f32_e32 v169, v173
		v_exp_f32_e32 v170, v174
		v_exp_f32_e32 v172, v175
		v_exp_f32_e32 v171, v190
		v_exp_f32_e32 v173, v191
		v_exp_f32_e32 v174, v192
		v_exp_f32_e32 v190, v193
		v_exp_f32_e32 v175, v194
		v_exp_f32_e32 v191, v195
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
		v_exp_f32_e32 v201, v206
		v_exp_f32_e32 v203, v207
		v_exp_f32_e32 v204, v208
		v_exp_f32_e32 v206, v209
		v_exp_f32_e32 v205, v210
		v_exp_f32_e32 v207, v211
		v_exp_f32_e32 v208, v176
		v_exp_f32_e32 v210, v177
		v_exp_f32_e32 v209, v178
		v_exp_f32_e32 v211, v179
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
		v_pk_add_f32 v[188:189], v[212:213], v[214:215]
		v_pk_add_f32 v[220:221], v[20:21], v[216:217]
		v_pk_add_f32 v[222:223], v[24:25], v[26:27]
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
		v_mov_b32_e32 v250, v189
		v_mov_b32_e32 v251, v221
		v_mov_b32_e32 v252, v188
		v_mov_b32_e32 v253, v220
		v_pk_add_f32 v[188:189], v[252:253], v[250:251]
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
		v_mov_b32_e32 v220, v189
		v_mov_b32_e32 v221, v223
		v_mov_b32_e32 v224, v188
		v_mov_b32_e32 v225, v222
		v_pk_add_f32 v[188:189], v[224:225], v[220:221]
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
		v_mov_b32_e32 v220, v189
		v_mov_b32_e32 v221, v225
		v_mov_b32_e32 v222, v188
		v_mov_b32_e32 v223, v224
		v_pk_add_f32 v[188:189], v[222:223], v[220:221]
		v_mov_b32_e32 v220, v227
		v_mov_b32_e32 v221, v229
		v_mov_b32_e32 v222, v226
		v_mov_b32_e32 v223, v228
		v_pk_add_f32 v[224:225], v[222:223], v[220:221]
		v_mov_b32_e32 v220, v189
		v_mov_b32_e32 v221, v225
		v_mov_b32_e32 v222, v188
		v_mov_b32_e32 v223, v224
		v_pk_add_f32 v[188:189], v[222:223], v[220:221]
		v_add_f32_e32 v15, v188, v189
		ds_bpermute_b32 v160, v8, v15
		ds_bpermute_b32 v162, v6, v15
		v_pk_add_f32 v[188:189], v[164:165], v[218:219]
		v_pk_add_f32 v[220:221], v[96:97], v[98:99]
		v_pk_add_f32 v[222:223], v[100:101], v[102:103]
		v_pk_add_f32 v[224:225], v[104:105], v[106:107]
		v_pk_add_f32 v[226:227], v[108:109], v[110:111]
		v_pk_add_f32 v[228:229], v[166:167], v[168:169]
		v_pk_add_f32 v[230:231], v[170:171], v[172:173]
		v_pk_add_f32 v[232:233], v[174:175], v[190:191]
		v_pk_add_f32 v[234:235], v[192:193], v[194:195]
		v_pk_add_f32 v[236:237], v[196:197], v[198:199]
		v_pk_add_f32 v[238:239], v[200:201], v[202:203]
		v_pk_add_f32 v[240:241], v[204:205], v[206:207]
		v_pk_add_f32 v[242:243], v[208:209], v[210:211]
		v_pk_add_f32 v[244:245], v[176:177], v[178:179]
		v_pk_add_f32 v[246:247], v[180:181], v[182:183]
		v_mov_b32_e32 v248, v189
		v_mov_b32_e32 v249, v222
		v_pk_add_f32 v[250:251], v[248:249], v[220:221]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[220:221], v[160:161], v[162:163]
		v_mov_b32_e32 v185, v221
		v_mov_b32_e32 v187, v188
		v_pk_add_f32 v[188:189], v[184:185], v[186:187]
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
		v_pk_add_f32 v[188:189], v[232:233], v[188:189]
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
		v_pk_add_f32 v[188:189], v[224:225], v[188:189]
		v_mov_b32_e32 v224, v237
		v_mov_b32_e32 v225, v226
		v_pk_add_f32 v[228:229], v[224:225], v[222:223]
		v_mov_b32_e32 v222, v227
		v_mov_b32_e32 v223, v228
		v_pk_add_f32 v[224:225], v[222:223], v[188:189]
		v_add_f32_e32 v15, v229, v224
		v_add_f32_e32 v15, v225, v15
		ds_bpermute_b32 v23, v8, v15
		ds_bpermute_b32 v160, v6, v15
		v_sub_f32_e32 v7, v7, v9
		v_sub_f32_e32 v15, v16, v14
		v_exp_f32_e32 v188, v7
		v_exp_f32_e32 v222, v15
		v_mov_b32_e32 v189, v188
		v_pk_mul_f32 v[32:33], v[32:33], v[188:189]
		v_pk_mul_f32 v[34:35], v[34:35], v[188:189]
		v_pk_mul_f32 v[36:37], v[36:37], v[188:189]
		v_pk_mul_f32 v[38:39], v[38:39], v[188:189]
		v_pk_mul_f32 v[40:41], v[40:41], v[188:189]
		v_pk_mul_f32 v[42:43], v[42:43], v[188:189]
		v_pk_mul_f32 v[44:45], v[44:45], v[188:189]
		v_pk_mul_f32 v[46:47], v[46:47], v[188:189]
		v_pk_mul_f32 v[48:49], v[48:49], v[188:189]
		v_pk_mul_f32 v[50:51], v[50:51], v[188:189]
		v_pk_mul_f32 v[52:53], v[52:53], v[188:189]
		v_pk_mul_f32 v[54:55], v[54:55], v[188:189]
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v225, v23, v160
		v_pk_mul_f32 v[56:57], v[56:57], v[188:189]
		v_pk_mul_f32 v[58:59], v[58:59], v[188:189]
		v_pk_mul_f32 v[60:61], v[60:61], v[188:189]
		v_pk_mul_f32 v[62:63], v[62:63], v[188:189]
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
		v_mov_b32_e32 v224, v220
		v_mov_b32_e32 v220, v188
		v_mov_b32_e32 v221, v222
		v_mov_b64_e32 v[188:189], v[18:19]
		v_pk_fma_f32 v[18:19], v[188:189], v[220:221], v[224:225]
		v_cvt_pk_bf16_f32 v220, v212, v214
		v_cvt_pk_bf16_f32 v221, v213, v215
		v_cvt_pk_bf16_f32 v222, v20, v216
		v_cvt_pk_bf16_f32 v223, v21, v217
		v_cvt_pk_bf16_f32 v212, v24, v26
		v_cvt_pk_bf16_f32 v213, v25, v27
		v_cvt_pk_bf16_f32 v214, v28, v30
		v_cvt_pk_bf16_f32 v215, v29, v31
		v_cvt_pk_bf16_f32 v24, v112, v114
		v_cvt_pk_bf16_f32 v25, v113, v115
		v_cvt_pk_bf16_f32 v26, v116, v118
		v_cvt_pk_bf16_f32 v27, v117, v119
		v_cvt_pk_bf16_f32 v28, v120, v122
		v_cvt_pk_bf16_f32 v29, v121, v123
		v_cvt_pk_bf16_f32 v30, v124, v126
		v_cvt_pk_bf16_f32 v31, v125, v127
		v_cvt_pk_bf16_f32 v112, v128, v130
		v_cvt_pk_bf16_f32 v113, v129, v131
		v_cvt_pk_bf16_f32 v114, v132, v134
		v_cvt_pk_bf16_f32 v115, v133, v135
		v_cvt_pk_bf16_f32 v116, v136, v138
		v_cvt_pk_bf16_f32 v117, v137, v139
		v_cvt_pk_bf16_f32 v118, v140, v142
		v_cvt_pk_bf16_f32 v119, v141, v143
		v_cvt_pk_bf16_f32 v120, v144, v146
		v_cvt_pk_bf16_f32 v121, v145, v147
		v_cvt_pk_bf16_f32 v122, v148, v150
		v_cvt_pk_bf16_f32 v123, v149, v151
		v_cvt_pk_bf16_f32 v124, v152, v154
		v_cvt_pk_bf16_f32 v125, v153, v155
		v_cvt_pk_bf16_f32 v126, v156, v158
		v_cvt_pk_bf16_f32 v127, v157, v159
		v_cvt_pk_bf16_f32 v128, v161, v163
		v_cvt_pk_bf16_f32 v129, v164, v218
		v_cvt_pk_bf16_f32 v130, v165, v219
		v_cvt_pk_bf16_f32 v131, v96, v98
		v_cvt_pk_bf16_f32 v132, v97, v99
		v_cvt_pk_bf16_f32 v133, v100, v102
		v_cvt_pk_bf16_f32 v134, v101, v103
		v_cvt_pk_bf16_f32 v135, v104, v106
		v_cvt_pk_bf16_f32 v96, v105, v107
		v_cvt_pk_bf16_f32 v97, v108, v110
		v_cvt_pk_bf16_f32 v98, v109, v111
		v_cvt_pk_bf16_f32 v99, v166, v168
		v_cvt_pk_bf16_f32 v100, v167, v169
		v_cvt_pk_bf16_f32 v101, v170, v172
		v_cvt_pk_bf16_f32 v102, v171, v173
		v_cvt_pk_bf16_f32 v103, v174, v190
		v_cvt_pk_bf16_f32 v104, v175, v191
		v_cvt_pk_bf16_f32 v105, v192, v194
		v_cvt_pk_bf16_f32 v106, v193, v195
		v_cvt_pk_bf16_f32 v107, v196, v198
		v_cvt_pk_bf16_f32 v108, v197, v199
		v_cvt_pk_bf16_f32 v109, v200, v202
		v_cvt_pk_bf16_f32 v110, v201, v203
		v_cvt_pk_bf16_f32 v111, v204, v206
		v_cvt_pk_bf16_f32 v136, v205, v207
		v_cvt_pk_bf16_f32 v137, v208, v210
		v_cvt_pk_bf16_f32 v138, v209, v211
		v_cvt_pk_bf16_f32 v139, v176, v178
		v_cvt_pk_bf16_f32 v140, v177, v179
		v_cvt_pk_bf16_f32 v141, v180, v182
		v_cvt_pk_bf16_f32 v142, v181, v183
		v_cvt_pk_bf16_f32 v143, v184, v186
		v_permlane32_swap_b32_e32 v220, v222
		v_permlane32_swap_b32_e32 v221, v223
		v_permlane32_swap_b32_e32 v212, v214
		v_permlane32_swap_b32_e32 v213, v215
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[32:47], a[136:139], v[220:223], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[168:171], v[220:223], v[48:63]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[32:47], a[140:143], v[212:215], v[32:47]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[48:63], a[172:175], v[212:215], v[48:63]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[32:47], a[144:147], v[24:27], v[32:47]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[48:63], a[176:179], v[24:27], v[48:63]
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_mfma_f32_32x32x16_bf16 v[32:47], a[148:151], v[28:31], v[32:47]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[48:63], a[180:183], v[28:31], v[48:63]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[32:47], a[152:155], v[112:115], v[32:47]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[80:95], a[168:171], v[128:131], v[80:95]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[64:79], a[136:139], v[128:131], v[64:79]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[80:95], a[172:175], v[132:135], v[80:95]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[64:79], a[140:143], v[132:135], v[64:79]
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_mfma_f32_32x32x16_bf16 v[80:95], a[176:179], v[96:99], v[80:95]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[64:79], a[144:147], v[96:99], v[64:79]
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_mfma_f32_32x32x16_bf16 v[80:95], a[180:183], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[148:151], v[100:103], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[184:187], v[112:115], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[184:187], v[104:107], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[152:155], v[104:107], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[156:159], v[116:119], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[188:191], v[116:119], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[188:191], v[108:111], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[156:159], v[108:111], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[160:163], v[120:123], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[192:195], v[120:123], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[192:195], v[136:139], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[160:163], v[136:139], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[164:167], v[124:127], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[196:199], v[124:127], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[196:199], v[140:143], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[164:167], v[140:143], v[64:79]
		v_mov_b32_e32 v7, v9
		v_mov_b32_e32 v16, v14
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_1
.L_attn_fwd_persistent.loop_exit_1:
		s_mul_i32 s24, s24, 0x80
		v_accvgpr_read_b32 v9, a9
		v_readfirstlane_b32 s36, v2
		s_nop 1
		v_add_u32_e32 v9, s36, v9
		v_add_u32_e32 v9, s1, v9
		v_accvgpr_read_b32 v12, a10
		v_readfirstlane_b32 s36, v2
		s_nop 1
		v_add_u32_e32 v12, s36, v12
		v_add_u32_e32 v12, s1, v12
		v_xor_b32_e32 v13, 1, v17
		v_accvgpr_write_b32 a9, v13
		v_xor_b32_e32 v13, 2, v17
		v_accvgpr_write_b32 a10, v13
		v_xor_b32_e32 v13, 3, v17
		v_accvgpr_write_b32 a71, v13
		v_xor_b32_e32 v13, 8, v17
		v_accvgpr_write_b32 a78, v13
		v_xor_b32_e32 v13, 9, v17
		v_accvgpr_write_b32 a81, v13
		v_xor_b32_e32 v13, 10, v17
		v_accvgpr_write_b32 a82, v13
		v_xor_b32_e32 v13, 11, v17
		v_accvgpr_write_b32 a83, v13
		v_xor_b32_e32 v13, 16, v17
		v_accvgpr_write_b32 a84, v13
		v_xor_b32_e32 v13, 17, v17
		v_accvgpr_write_b32 a85, v13
		v_xor_b32_e32 v13, 18, v17
		v_accvgpr_write_b32 a86, v13
		v_xor_b32_e32 v13, 19, v17
		v_accvgpr_write_b32 a87, v13
		v_xor_b32_e32 v13, 24, v17
		v_accvgpr_write_b32 a88, v13
		v_xor_b32_e32 v13, 25, v17
		v_accvgpr_write_b32 a89, v13
		v_xor_b32_e32 v13, 26, v17
		v_accvgpr_write_b32 a90, v13
		v_xor_b32_e32 v13, 27, v17
		v_accvgpr_write_b32 a91, v13
		v_xor_b32_e32 v13, 32, v17
		v_accvgpr_write_b32 a92, v13
		v_xor_b32_e32 v13, 33, v17
		v_accvgpr_write_b32 a93, v13
		v_xor_b32_e32 v13, 34, v17
		v_accvgpr_write_b32 a94, v13
		v_xor_b32_e32 v13, 35, v17
		v_accvgpr_write_b32 a95, v13
		v_xor_b32_e32 v13, 40, v17
		v_accvgpr_write_b32 a96, v13
		v_xor_b32_e32 v13, 41, v17
		v_accvgpr_write_b32 a97, v13
		v_xor_b32_e32 v13, 42, v17
		v_accvgpr_write_b32 a98, v13
		v_xor_b32_e32 v13, 43, v17
		v_accvgpr_write_b32 a99, v13
		v_xor_b32_e32 v13, 48, v17
		v_accvgpr_write_b32 a100, v13
		v_xor_b32_e32 v13, 49, v17
		v_accvgpr_write_b32 a101, v13
		v_xor_b32_e32 v13, 50, v17
		v_accvgpr_write_b32 a102, v13
		v_xor_b32_e32 v13, 51, v17
		v_accvgpr_write_b32 a103, v13
		v_xor_b32_e32 v13, 56, v17
		v_accvgpr_write_b32 a104, v13
		v_xor_b32_e32 v13, 57, v17
		v_accvgpr_write_b32 a105, v13
		v_xor_b32_e32 v13, 58, v17
		v_accvgpr_write_b32 a106, v13
		v_xor_b32_e32 v13, 59, v17
		v_accvgpr_write_b32 a107, v13
		v_xor_b32_e32 v13, 64, v17
		v_accvgpr_write_b32 a108, v13
		v_xor_b32_e32 v13, 0x41, v17
		v_accvgpr_write_b32 a109, v13
		v_xor_b32_e32 v13, 0x42, v17
		v_accvgpr_write_b32 a110, v13
		v_xor_b32_e32 v13, 0x43, v17
		v_accvgpr_write_b32 a111, v13
		v_xor_b32_e32 v13, 0x48, v17
		v_accvgpr_write_b32 a112, v13
		v_xor_b32_e32 v13, 0x49, v17
		v_accvgpr_write_b32 a113, v13
		v_xor_b32_e32 v13, 0x4a, v17
		v_accvgpr_write_b32 a114, v13
		v_xor_b32_e32 v13, 0x4b, v17
		v_accvgpr_write_b32 a115, v13
		v_xor_b32_e32 v13, 0x50, v17
		v_accvgpr_write_b32 a116, v13
		v_xor_b32_e32 v13, 0x51, v17
		v_accvgpr_write_b32 a117, v13
		v_xor_b32_e32 v13, 0x52, v17
		v_accvgpr_write_b32 a118, v13
		v_xor_b32_e32 v13, 0x53, v17
		v_accvgpr_write_b32 a119, v13
		v_xor_b32_e32 v13, 0x58, v17
		v_accvgpr_write_b32 a120, v13
		v_xor_b32_e32 v13, 0x59, v17
		v_accvgpr_write_b32 a121, v13
		v_xor_b32_e32 v13, 0x5a, v17
		v_accvgpr_write_b32 a122, v13
		v_xor_b32_e32 v13, 0x5b, v17
		v_accvgpr_write_b32 a123, v13
		v_xor_b32_e32 v13, 0x60, v17
		v_accvgpr_write_b32 a124, v13
		v_xor_b32_e32 v13, 0x61, v17
		v_accvgpr_write_b32 a125, v13
		v_xor_b32_e32 v13, 0x62, v17
		v_accvgpr_write_b32 a126, v13
		v_xor_b32_e32 v13, 0x63, v17
		v_accvgpr_write_b32 a127, v13
		v_xor_b32_e32 v13, 0x68, v17
		v_accvgpr_write_b32 a128, v13
		v_xor_b32_e32 v13, 0x69, v17
		v_accvgpr_write_b32 a129, v13
		v_xor_b32_e32 v13, 0x6a, v17
		v_accvgpr_write_b32 a130, v13
		v_xor_b32_e32 v13, 0x6b, v17
		v_accvgpr_write_b32 a131, v13
		v_xor_b32_e32 v13, 0x70, v17
		v_accvgpr_write_b32 a132, v13
		v_xor_b32_e32 v13, 0x71, v17
		v_accvgpr_write_b32 a133, v13
		v_xor_b32_e32 v13, 0x72, v17
		v_accvgpr_write_b32 a134, v13
		v_xor_b32_e32 v13, 0x73, v17
		v_accvgpr_write_b32 a135, v13
		v_xor_b32_e32 v13, 0x78, v17
		v_accvgpr_write_b32 a136, v13
		v_xor_b32_e32 v13, 0x79, v17
		v_accvgpr_write_b32 a137, v13
		v_xor_b32_e32 v13, 0x7a, v17
		v_accvgpr_write_b32 a138, v13
		v_xor_b32_e32 v13, 0x7b, v17
		v_accvgpr_write_b32 a139, v13
		v_accvgpr_read_b32 v13, a20
		v_accvgpr_read_b32 v14, a72
		v_lshl_add_u32 v13, v13, 4, v14
		v_accvgpr_read_b32 v14, a73
		v_accvgpr_read_b32 v15, a74
		v_add3_u32 v13, v13, v14, v15
		v_accvgpr_read_b32 v14, a75
		v_accvgpr_read_b32 v15, a76
		v_add3_u32 v13, v13, v14, v15
		v_accvgpr_write_b32 a20, v13
		v_accvgpr_read_b32 v13, a77
		v_accvgpr_read_b32 v14, a79
		v_lshl_add_u32 v13, v13, 3, v14
		v_accvgpr_read_b32 v14, a80
		v_accvgpr_read_b32 v15, a60
		v_add3_u32 v13, v13, v15, v14
		v_accvgpr_write_b32 a60, v13
		v_mov_b32_e32 v13, 0xff800000
		s_cmp_lt_i32 s42, s24
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_2
.L_attn_fwd_persistent.loop_head_2:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s1, s42, 0x80
		s_cmp_lt_i32 s42, 0
		s_cselect_b32 s36, s25, 0
		s_add_i32 s36, s42, s36
		s_ashr_i32 s36, s36, 7
		s_cmp_lt_i32 s36, 0
		s_cselect_b32 s38, s16, 0
		s_add_i32 s38, s36, s38
		s_ashr_i32 s38, s38, 1
		s_lshl_b32 s38, s38, 1
		s_xor_b32 s38, s38, -1
		s_add_i32 s38, s38, 1
		s_add_i32 s38, s36, s38
		s_add_i32 s36, s36, 1
		s_cmp_lt_i32 s36, 0
		s_cselect_b32 s39, s16, 0
		s_add_i32 s39, s36, s39
		s_ashr_i32 s39, s39, 1
		s_lshl_b32 s39, s39, 1
		s_xor_b32 s39, s39, -1
		s_add_i32 s39, s39, 1
		s_add_i32 s44, s36, s39
		s_mul_i32 s36, 0x4100, s38
		v_accvgpr_read_b32 v14, a20
		v_add_u32_e32 v14, s36, v14
		ds_read_b128 v[24:27], v14
		ds_read_b128 a[72:75], v14 offset:32
		ds_read_b128 a[140:143], v14 offset:64
		ds_read_b128 a[144:147], v14 offset:96
		ds_read_b128 a[148:151], v14 offset:256
		ds_read_b128 a[152:155], v14 offset:288
		ds_read_b128 a[156:159], v14 offset:320
		ds_read_b128 a[160:163], v14 offset:352
		ds_read_b128 a[164:167], v14 offset:128
		ds_read_b128 a[168:171], v14 offset:160
		ds_read_b128 a[172:175], v14 offset:192
		ds_read_b128 a[176:179], v14 offset:224
		ds_read_b128 v[28:31], v14 offset:384
		ds_read_b128 a[180:183], v14 offset:416
		ds_read_b128 a[184:187], v14 offset:448
		ds_read_b128 a[188:191], v14 offset:480
		s_mul_i32 s36, 0x4400, s38
		v_accvgpr_read_b32 v14, a60
		v_add_u32_e32 v14, s36, v14
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
		s_cmp_lt_i32 s1, s20
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_2
		v_accvgpr_read_b32 v14, a21
		v_add_u32_e32 v14, s1, v14
		v_accvgpr_read_b32 v15, a22
		v_add_u32_e32 v15, s1, v15
		v_accvgpr_read_b32 v20, a23
		v_add_u32_e32 v20, s1, v20
		v_accvgpr_read_b32 v21, a56
		v_add_u32_e32 v21, s1, v21
		v_cmp_lt_i32_e64 vcc, v14, s22
		s_mov_b64 s[38:39], vcc
		v_cmp_lt_i32_e64 vcc, v15, s22
		s_mov_b64 s[46:47], vcc
		v_cmp_lt_i32_e64 vcc, v20, s22
		s_mov_b64 s[48:49], vcc
		v_cmp_lt_i32_e64 vcc, v21, s22
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v14, a57
		v_add_u32_e32 v14, s1, v14
		v_accvgpr_read_b32 v15, a58
		v_add_u32_e32 v15, s1, v15
		v_accvgpr_read_b32 v20, a59
		v_add_u32_e32 v20, s1, v20
		v_cmp_lt_i32_e64 vcc, v14, s22
		s_mov_b64 s[54:55], vcc
		v_cmp_lt_i32_e64 vcc, v15, s22
		s_mov_b64 s[56:57], vcc
		v_cmp_lt_i32_e64 vcc, v20, s22
		s_mov_b64 s[58:59], vcc
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s36, s15, s42
		s_lshl_b32 s36, s36, 1
		s_add_i32 s36, s37, s36
		v_accvgpr_read_b32 v14, a62
		v_add_u32_e32 v14, s36, v14
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
		v_cndmask_b32_e64 v14, v22, v14, s[38:39]
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		v_accvgpr_read_b32 v14, a63
		v_add_u32_e32 v14, s1, v14
		v_accvgpr_read_b32 v15, a64
		v_add_u32_e32 v15, s36, v15
		s_add_u32 s38, s64, 0x1040
		s_addc_u32 s39, s65, 0
		s_add_u32 s38, s38, s66
		s_addc_u32 s39, s39, s67
		s_add_u32 s62, s38, 0
		s_addc_u32 s63, s39, 0
		s_mov_b32 m0, s62
		v_cndmask_b32_e64 v15, v22, v15, s[46:47]
		buffer_load_dwordx4 v15, s[28:31], 0 offen lds
		v_accvgpr_read_b32 v15, a65
		v_add_u32_e32 v15, s36, v15
		s_add_u32 s38, s64, 0x2080
		s_addc_u32 s39, s65, 0
		s_add_u32 s38, s38, s66
		s_addc_u32 s39, s39, s67
		s_add_u32 s46, s38, 0
		s_addc_u32 s47, s39, 0
		s_mov_b32 m0, s46
		v_cndmask_b32_e64 v15, v22, v15, s[48:49]
		buffer_load_dwordx4 v15, s[28:31], 0 offen lds
		v_accvgpr_read_b32 v15, a66
		v_add_u32_e32 v15, s36, v15
		s_add_u32 s38, s64, 0x30c0
		s_addc_u32 s39, s65, 0
		s_add_u32 s38, s38, s66
		s_addc_u32 s39, s39, s67
		s_add_u32 s46, s38, 0
		s_addc_u32 s47, s39, 0
		s_mov_b32 m0, s46
		v_cndmask_b32_e64 v15, v22, v15, s[50:51]
		buffer_load_dwordx4 v15, s[28:31], 0 offen lds
		s_mul_i32 s1, s18, s42
		s_lshl_b32 s1, s1, 1
		s_add_i32 s1, s40, s1
		v_accvgpr_read_b32 v15, a67
		v_add_u32_e32 v15, s1, v15
		s_mov_b32 s38, 0x440
		s_mov_b32 s39, 0
		s_mul_i32 s46, s38, s60
		s_mul_hi_u32 s47, s38, s60
		s_mul_i32 s36, s38, s61
		s_add_i32 s47, s47, s36
		s_mul_i32 s36, s39, s60
		s_add_i32 s47, s47, s36
		s_add_u32 s38, s46, 0x81f0
		s_addc_u32 s39, s47, 0
		s_mov_b32 s48, 0x4400
		s_mov_b32 s49, 0
		s_mul_i32 s50, s48, s44
		s_mul_hi_u32 s51, s48, s44
		s_mul_i32 s36, s48, s45
		s_add_i32 s51, s51, s36
		s_mul_i32 s36, s49, s44
		s_add_i32 s51, s51, s36
		s_add_u32 s38, s38, s50
		s_addc_u32 s39, s39, s51
		s_add_u32 s44, s38, 0
		s_addc_u32 s45, s39, 0
		s_mov_b32 m0, s44
		v_cndmask_b32_e64 v15, v22, v15, s[54:55]
		buffer_load_dwordx4 v15, s[32:35], 0 offen lds
		v_accvgpr_read_b32 v15, a68
		v_add_u32_e32 v15, s1, v15
		s_add_u32 s38, s46, 0x92f0
		s_addc_u32 s39, s47, 0
		s_add_u32 s38, s38, s50
		s_addc_u32 s39, s39, s51
		s_add_u32 s44, s38, 0
		s_addc_u32 s45, s39, 0
		s_mov_b32 m0, s44
		v_cndmask_b32_e64 v15, v22, v15, s[56:57]
		buffer_load_dwordx4 v15, s[32:35], 0 offen lds
		v_accvgpr_read_b32 v15, a69
		v_add_u32_e32 v15, s1, v15
		s_add_u32 s38, s46, 0xa3f0
		s_addc_u32 s39, s47, 0
		s_add_u32 s38, s38, s50
		s_addc_u32 s39, s39, s51
		s_add_u32 s44, s38, 0
		s_addc_u32 s45, s39, 0
		s_mov_b32 m0, s44
		v_cndmask_b32_e64 v15, v22, v15, s[58:59]
		buffer_load_dwordx4 v15, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v14, s22
		v_accvgpr_read_b32 v14, a70
		v_add_u32_e32 v14, s1, v14
		s_add_u32 s38, s46, 0xb4f0
		s_addc_u32 s39, s47, 0
		v_cndmask_b32_e32 v14, v22, v14, vcc
		s_add_u32 s38, s38, s50
		s_addc_u32 s39, s39, s51
		s_add_u32 s44, s38, 0
		s_addc_u32 s45, s39, 0
		s_mov_b32 m0, s44
		s_nop 0
		buffer_load_dwordx4 v14, s[32:35], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_2
.L_attn_fwd_persistent.if_else_2:
.L_attn_fwd_persistent.if_end_2:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[96:111], v[24:27], a[24:27], 0
		v_mfma_f32_32x32x16_bf16 v[112:127], a[148:151], a[24:27], 0
		v_mfma_f32_32x32x16_bf16 v[128:143], a[164:167], a[24:27], 0
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[24:27], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[28:31], a[40:43], 0
		v_mfma_f32_32x32x16_bf16 v[176:191], v[24:27], a[40:43], 0
		v_mfma_f32_32x32x16_bf16 v[192:207], a[148:151], a[40:43], 0
		v_mfma_f32_32x32x16_bf16 v[208:223], a[164:167], a[40:43], 0
		v_mfma_f32_32x32x16_bf16 v[96:111], a[72:75], a[28:31], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[152:155], a[28:31], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[168:171], a[28:31], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[180:183], a[28:31], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[44:47], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[72:75], a[44:47], v[176:191]
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
		v_mfma_f32_32x32x16_bf16 v[96:111], a[144:147], a[36:39], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[160:163], a[36:39], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[176:179], a[36:39], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[188:191], a[36:39], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[188:191], a[52:55], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[144:147], a[52:55], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[160:163], a[52:55], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[176:179], a[52:55], v[208:223]
		v_add_u32_e32 v14, s42, v17
		v_accvgpr_read_b32 v15, a9
		v_add_u32_e32 v15, s42, v15
		v_accvgpr_read_b32 v20, a10
		v_add_u32_e32 v20, s42, v20
		v_accvgpr_read_b32 v21, a71
		v_add_u32_e32 v21, s42, v21
		v_accvgpr_read_b32 v23, a82
		v_add_u32_e32 v23, s42, v23
		v_accvgpr_read_b32 v24, a83
		v_add_u32_e32 v24, s42, v24
		v_accvgpr_read_b32 v25, a86
		v_add_u32_e32 v25, s42, v25
		v_accvgpr_read_b32 v26, a87
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_read_b32 v27, a90
		v_add_u32_e32 v27, s42, v27
		v_accvgpr_read_b32 v28, a91
		v_add_u32_e32 v28, s42, v28
		v_accvgpr_read_b32 v29, a94
		v_add_u32_e32 v29, s42, v29
		v_accvgpr_read_b32 v30, a95
		v_add_u32_e32 v30, s42, v30
		v_accvgpr_read_b32 v31, a98
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a72, v31
		v_accvgpr_read_b32 v31, a99
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a73, v31
		v_accvgpr_read_b32 v31, a102
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a74, v31
		v_accvgpr_read_b32 v31, a103
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a75, v31
		v_accvgpr_read_b32 v31, a106
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a76, v31
		v_accvgpr_read_b32 v31, a107
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a77, v31
		v_accvgpr_read_b32 v31, a110
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a79, v31
		v_accvgpr_read_b32 v31, a111
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a80, v31
		v_accvgpr_read_b32 v31, a114
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a140, v31
		v_accvgpr_read_b32 v31, a115
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a141, v31
		v_accvgpr_read_b32 v31, a118
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a142, v31
		v_accvgpr_read_b32 v31, a119
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a143, v31
		v_accvgpr_read_b32 v31, a122
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a144, v31
		v_accvgpr_read_b32 v31, a123
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a145, v31
		v_accvgpr_read_b32 v31, a126
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a146, v31
		v_accvgpr_read_b32 v31, a127
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a147, v31
		v_accvgpr_read_b32 v31, a130
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a148, v31
		v_accvgpr_read_b32 v31, a131
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a149, v31
		v_accvgpr_read_b32 v31, a134
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a150, v31
		v_accvgpr_read_b32 v31, a135
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a151, v31
		v_accvgpr_read_b32 v31, a138
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a152, v31
		v_accvgpr_read_b32 v31, a139
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a153, v31
		v_cmp_ge_i32_e64 vcc, v9, v14
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v9, v15
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v9, v20
		s_mov_b64 s[46:47], vcc
		v_cmp_ge_i32_e64 vcc, v9, v21
		v_accvgpr_read_b32 v31, a78
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_read_b32 v224, a81
		v_add_u32_e32 v224, s42, v224
		v_cndmask_b32_e32 v227, v13, v99, vcc
		v_cmp_ge_i32_e64 vcc, v9, v31
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v9, v224
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v9, v23
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v9, v24
		v_accvgpr_read_b32 v99, a84
		v_add_u32_e32 v99, s42, v99
		v_accvgpr_read_b32 v225, a85
		v_add_u32_e32 v225, s42, v225
		v_cndmask_b32_e32 v229, v13, v103, vcc
		v_cmp_ge_i32_e64 vcc, v9, v99
		s_mov_b64 s[56:57], vcc
		v_cmp_ge_i32_e64 vcc, v9, v225
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v9, v25
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v9, v26
		v_accvgpr_read_b32 v103, a88
		v_add_u32_e32 v103, s42, v103
		v_accvgpr_read_b32 v226, a89
		v_add_u32_e32 v230, s42, v226
		v_cndmask_b32_e32 v233, v13, v107, vcc
		v_cmp_ge_i32_e64 vcc, v9, v103
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v9, v230
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v9, v27
		s_mov_b64 s[66:67], vcc
		v_cmp_ge_i32_e64 vcc, v9, v28
		v_accvgpr_read_b32 v107, a92
		v_add_u32_e32 v107, s42, v107
		v_accvgpr_read_b32 v226, a93
		v_add_u32_e32 v231, s42, v226
		v_cndmask_b32_e32 v235, v13, v111, vcc
		v_cmp_ge_i32_e64 vcc, v9, v107
		s_mov_b64 s[68:69], vcc
		v_cmp_ge_i32_e64 vcc, v9, v231
		s_mov_b64 s[70:71], vcc
		v_cmp_ge_i32_e64 vcc, v9, v29
		s_mov_b64 s[72:73], vcc
		v_cmp_ge_i32_e64 vcc, v9, v30
		v_accvgpr_read_b32 v111, a96
		v_add_u32_e32 v111, s42, v111
		v_accvgpr_read_b32 v226, a97
		v_add_u32_e32 v226, s42, v226
		v_accvgpr_write_b32 a154, v226
		v_cndmask_b32_e32 v237, v13, v115, vcc
		v_cmp_ge_i32_e64 vcc, v9, v111
		s_mov_b64 s[74:75], vcc
		v_accvgpr_read_b32 v115, a154
		v_cmp_ge_i32_e64 vcc, v9, v115
		s_mov_b64 s[76:77], vcc
		v_accvgpr_read_b32 v115, a72
		v_cmp_ge_i32_e64 vcc, v9, v115
		s_mov_b64 s[78:79], vcc
		v_accvgpr_read_b32 v115, a73
		v_cmp_ge_i32_e64 vcc, v9, v115
		v_accvgpr_read_b32 v115, a100
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a155, v115
		v_accvgpr_read_b32 v115, a101
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a156, v115
		v_cndmask_b32_e32 v239, v13, v119, vcc
		v_accvgpr_read_b32 v115, a155
		v_cmp_ge_i32_e64 vcc, v9, v115
		s_mov_b64 s[80:81], vcc
		v_accvgpr_read_b32 v115, a156
		v_cmp_ge_i32_e64 vcc, v9, v115
		s_mov_b64 s[82:83], vcc
		v_accvgpr_read_b32 v115, a74
		v_cmp_ge_i32_e64 vcc, v9, v115
		s_mov_b64 s[84:85], vcc
		v_accvgpr_read_b32 v115, a75
		v_cmp_ge_i32_e64 vcc, v9, v115
		s_mov_b64 s[86:87], vcc
		v_mov_b32_e32 v240, s86
		v_mov_b32_e32 v241, s87
		v_accvgpr_read_b32 v115, a104
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a157, v115
		v_accvgpr_read_b32 v115, a105
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a158, v115
		v_cndmask_b32_e32 v241, v13, v123, vcc
		v_accvgpr_read_b32 v115, a157
		v_cmp_ge_i32_e64 vcc, v9, v115
		s_mov_b64 s[86:87], vcc
		v_accvgpr_read_b32 v115, a158
		v_cmp_ge_i32_e64 vcc, v9, v115
		s_mov_b64 s[88:89], vcc
		v_accvgpr_read_b32 v115, a76
		v_cmp_ge_i32_e64 vcc, v9, v115
		s_mov_b64 s[90:91], vcc
		v_mov_b32_e32 v242, s90
		v_mov_b32_e32 v243, s91
		v_accvgpr_write_b32 a160, v242
		v_accvgpr_write_b32 a161, v243
		v_accvgpr_read_b32 v115, a77
		v_cmp_ge_i32_e64 vcc, v9, v115
		v_accvgpr_read_b32 v115, a108
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a159, v115
		v_accvgpr_read_b32 v115, a109
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a162, v115
		v_cndmask_b32_e32 v243, v13, v127, vcc
		v_accvgpr_read_b32 v115, a159
		v_cmp_ge_i32_e64 vcc, v9, v115
		s_mov_b64 s[90:91], vcc
		v_mov_b32_e32 v244, s90
		v_mov_b32_e32 v245, s91
		v_accvgpr_write_b32 a164, v244
		v_accvgpr_write_b32 a165, v245
		v_accvgpr_read_b32 v115, a162
		v_cmp_ge_i32_e64 vcc, v9, v115
		s_mov_b64 s[90:91], vcc
		v_mov_b32_e32 v244, s90
		v_mov_b32_e32 v245, s91
		v_accvgpr_write_b32 a166, v244
		v_accvgpr_write_b32 a167, v245
		v_accvgpr_read_b32 v115, a79
		v_cmp_ge_i32_e64 vcc, v9, v115
		s_mov_b64 s[90:91], vcc
		v_mov_b32_e32 v244, s90
		v_mov_b32_e32 v245, s91
		v_accvgpr_write_b32 a168, v244
		v_accvgpr_write_b32 a169, v245
		v_accvgpr_read_b32 v115, a80
		v_cmp_ge_i32_e64 vcc, v9, v115
		s_mov_b64 s[90:91], vcc
		v_mov_b32_e32 v244, s90
		v_mov_b32_e32 v245, s91
		v_accvgpr_read_b32 v115, a112
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a163, v115
		v_accvgpr_read_b32 v115, a113
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a170, v115
		v_cndmask_b32_e32 v245, v13, v131, vcc
		v_accvgpr_read_b32 v115, a163
		v_cmp_ge_i32_e64 vcc, v9, v115
		s_mov_b64 s[90:91], vcc
		v_mov_b32_e32 v246, s90
		v_mov_b32_e32 v247, s91
		v_accvgpr_write_b32 a172, v246
		v_accvgpr_write_b32 a173, v247
		v_accvgpr_read_b32 v115, a170
		v_cmp_ge_i32_e64 vcc, v9, v115
		s_mov_b64 s[90:91], vcc
		v_mov_b32_e32 v246, s90
		v_mov_b32_e32 v247, s91
		v_accvgpr_write_b32 a174, v246
		v_accvgpr_write_b32 a175, v247
		v_accvgpr_read_b32 v115, a140
		v_cmp_ge_i32_e64 vcc, v9, v115
		s_mov_b64 s[90:91], vcc
		v_mov_b32_e32 v246, s90
		v_mov_b32_e32 v247, s91
		v_accvgpr_write_b32 a176, v246
		v_accvgpr_write_b32 a177, v247
		v_accvgpr_read_b32 v115, a141
		v_cmp_ge_i32_e64 vcc, v9, v115
		v_accvgpr_read_b32 v115, a116
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a171, v115
		v_accvgpr_read_b32 v115, a117
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a178, v115
		v_cndmask_b32_e32 v247, v13, v135, vcc
		v_accvgpr_read_b32 v115, a171
		v_cmp_ge_i32_e64 vcc, v9, v115
		s_mov_b64 s[90:91], vcc
		v_mov_b32_e32 v248, s90
		v_mov_b32_e32 v249, s91
		v_accvgpr_write_b32 a180, v248
		v_accvgpr_write_b32 a181, v249
		v_accvgpr_read_b32 v115, a178
		v_cmp_ge_i32_e64 vcc, v9, v115
		s_mov_b64 s[90:91], vcc
		v_mov_b32_e32 v248, s90
		v_mov_b32_e32 v249, s91
		v_accvgpr_write_b32 a182, v248
		v_accvgpr_write_b32 a183, v249
		v_accvgpr_read_b32 v115, a142
		v_cmp_ge_i32_e64 vcc, v9, v115
		s_mov_b64 s[90:91], vcc
		v_mov_b32_e32 v248, s90
		v_mov_b32_e32 v249, s91
		v_accvgpr_write_b32 a184, v248
		v_accvgpr_write_b32 a185, v249
		v_accvgpr_read_b32 v115, a143
		v_cmp_ge_i32_e64 vcc, v9, v115
		s_mov_b64 s[90:91], vcc
		v_mov_b32_e32 v248, s90
		v_mov_b32_e32 v249, s91
		v_accvgpr_read_b32 v115, a120
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a179, v115
		v_accvgpr_read_b32 v115, a121
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a186, v115
		v_cndmask_b32_e32 v249, v13, v139, vcc
		v_accvgpr_read_b32 v115, a179
		v_cmp_ge_i32_e64 vcc, v9, v115
		s_mov_b64 s[90:91], vcc
		v_accvgpr_read_b32 v115, a186
		v_cmp_ge_i32_e64 vcc, v9, v115
		s_mov_b64 s[92:93], vcc
		v_accvgpr_read_b32 v115, a144
		v_cmp_ge_i32_e64 vcc, v9, v115
		s_mov_b64 s[94:95], vcc
		v_cndmask_b32_e64 v251, v13, v141, s[92:93]
		v_cndmask_b32_e64 v252, v13, v142, s[94:95]
		v_accvgpr_read_b32 v115, a145
		v_cmp_ge_i32_e64 vcc, v9, v115
		v_accvgpr_read_b32 v115, a124
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_read_b32 v119, a125
		v_add_u32_e32 v119, s42, v119
		v_cndmask_b32_e32 v253, v13, v143, vcc
		v_cmp_ge_i32_e64 vcc, v9, v115
		s_mov_b64 s[92:93], vcc
		v_cmp_ge_i32_e64 vcc, v9, v119
		s_mov_b64 s[94:95], vcc
		v_accvgpr_read_b32 v123, a146
		v_cmp_ge_i32_e64 vcc, v9, v123
		s_mov_b64 s[96:97], vcc
		v_cndmask_b32_e64 v142, v13, v144, s[92:93]
		v_cndmask_b32_e64 v143, v13, v145, s[94:95]
		v_cndmask_b32_e64 v144, v13, v146, s[96:97]
		v_accvgpr_read_b32 v123, a147
		v_cmp_ge_i32_e64 vcc, v9, v123
		v_accvgpr_read_b32 v123, a128
		v_add_u32_e32 v123, s42, v123
		v_accvgpr_read_b32 v127, a129
		v_add_u32_e32 v127, s42, v127
		v_accvgpr_write_b32 a187, v127
		v_cndmask_b32_e32 v145, v13, v147, vcc
		v_cmp_ge_i32_e64 vcc, v9, v123
		s_mov_b64 s[92:93], vcc
		v_accvgpr_read_b32 v127, a187
		v_cmp_ge_i32_e64 vcc, v9, v127
		s_mov_b64 s[94:95], vcc
		v_accvgpr_read_b32 v127, a148
		v_cmp_ge_i32_e64 vcc, v9, v127
		s_mov_b64 s[96:97], vcc
		v_cndmask_b32_e64 v146, v13, v148, s[92:93]
		v_cndmask_b32_e64 v147, v13, v149, s[94:95]
		v_cndmask_b32_e64 v148, v13, v150, s[96:97]
		v_accvgpr_read_b32 v127, a149
		v_cmp_ge_i32_e64 vcc, v9, v127
		v_accvgpr_read_b32 v127, a132
		v_add_u32_e32 v127, s42, v127
		v_accvgpr_write_b32 a188, v127
		v_accvgpr_read_b32 v127, a133
		v_add_u32_e32 v127, s42, v127
		v_accvgpr_write_b32 a189, v127
		v_cndmask_b32_e32 v149, v13, v151, vcc
		v_accvgpr_read_b32 v127, a188
		v_cmp_ge_i32_e64 vcc, v9, v127
		s_mov_b64 s[92:93], vcc
		v_accvgpr_read_b32 v127, a189
		v_cmp_ge_i32_e64 vcc, v9, v127
		s_mov_b64 s[94:95], vcc
		v_accvgpr_read_b32 v127, a150
		v_cmp_ge_i32_e64 vcc, v9, v127
		s_mov_b64 s[96:97], vcc
		v_cndmask_b32_e64 v150, v13, v152, s[92:93]
		v_cndmask_b32_e64 v151, v13, v153, s[94:95]
		v_cndmask_b32_e64 v152, v13, v154, s[96:97]
		v_accvgpr_read_b32 v127, a151
		v_cmp_ge_i32_e64 vcc, v9, v127
		v_accvgpr_read_b32 v127, a136
		v_add_u32_e32 v127, s42, v127
		v_accvgpr_write_b32 a190, v127
		v_accvgpr_read_b32 v127, a137
		v_add_u32_e32 v127, s42, v127
		v_accvgpr_write_b32 a191, v127
		v_cndmask_b32_e32 v153, v13, v155, vcc
		v_accvgpr_read_b32 v127, a190
		v_cmp_ge_i32_e64 vcc, v9, v127
		s_mov_b64 s[92:93], vcc
		v_accvgpr_read_b32 v127, a191
		v_cmp_ge_i32_e64 vcc, v9, v127
		s_mov_b64 s[94:95], vcc
		v_accvgpr_read_b32 v127, a152
		v_cmp_ge_i32_e64 vcc, v9, v127
		s_mov_b64 s[96:97], vcc
		v_cndmask_b32_e64 v154, v13, v156, s[92:93]
		v_cndmask_b32_e64 v155, v13, v157, s[94:95]
		v_cndmask_b32_e64 v156, v13, v158, s[96:97]
		v_accvgpr_read_b32 v127, a153
		v_cmp_ge_i32_e64 vcc, v9, v127
		v_mov_b32_e32 v127, 0xff800000
		v_cndmask_b32_e64 v254, v127, v96, s[38:39]
		v_cndmask_b32_e64 v255, v127, v97, s[44:45]
		v_cndmask_b32_e32 v157, v127, v159, vcc
		v_cmp_ge_i32_e64 vcc, v12, v14
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v12, v15
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v12, v20
		s_mov_b64 s[92:93], vcc
		v_cndmask_b32_e64 v14, v127, v176, s[38:39]
		v_cndmask_b32_e64 v15, v127, v177, s[44:45]
		v_cndmask_b32_e64 v96, v127, v178, s[92:93]
		v_cmp_ge_i32_e64 vcc, v12, v21
		v_cndmask_b32_e64 v226, v127, v98, s[46:47]
		v_cndmask_b32_e64 v20, v127, v100, s[48:49]
		v_cndmask_b32_e32 v97, v127, v179, vcc
		v_cmp_ge_i32_e64 vcc, v12, v31
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v12, v224
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v158, v127, v180, s[38:39]
		v_cndmask_b32_e64 v159, v127, v181, s[44:45]
		v_cndmask_b32_e64 v176, v127, v182, s[46:47]
		v_cmp_ge_i32_e64 vcc, v12, v24
		v_cndmask_b32_e64 v21, v127, v101, s[50:51]
		v_cndmask_b32_e64 v228, v127, v102, s[54:55]
		v_cndmask_b32_e32 v177, v127, v183, vcc
		v_cmp_ge_i32_e64 vcc, v12, v99
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v12, v225
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v12, v25
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v24, v127, v184, s[38:39]
		v_cndmask_b32_e64 v25, v127, v185, s[44:45]
		v_cndmask_b32_e64 v98, v127, v186, s[46:47]
		v_cmp_ge_i32_e64 vcc, v12, v26
		v_cndmask_b32_e64 v100, v127, v104, s[56:57]
		v_cndmask_b32_e64 v101, v127, v105, s[58:59]
		v_cndmask_b32_e32 v99, v127, v187, vcc
		v_cmp_ge_i32_e64 vcc, v12, v103
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v12, v230
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v12, v27
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v26, v127, v188, s[38:39]
		v_cndmask_b32_e64 v27, v127, v189, s[44:45]
		v_cndmask_b32_e64 v102, v127, v190, s[46:47]
		v_cmp_ge_i32_e64 vcc, v12, v28
		v_cndmask_b32_e64 v232, v127, v106, s[60:61]
		v_cndmask_b32_e64 v104, v127, v108, s[62:63]
		v_cndmask_b32_e32 v103, v127, v191, vcc
		v_cmp_ge_i32_e64 vcc, v12, v107
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v12, v231
		s_mov_b64 s[44:45], vcc
		v_cmp_ge_i32_e64 vcc, v12, v29
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v28, v127, v192, s[38:39]
		v_cndmask_b32_e64 v29, v127, v193, s[44:45]
		v_cndmask_b32_e64 v106, v127, v194, s[46:47]
		v_cmp_ge_i32_e64 vcc, v12, v30
		v_cndmask_b32_e64 v105, v127, v109, s[64:65]
		v_cndmask_b32_e64 v234, v127, v110, s[66:67]
		v_cndmask_b32_e32 v107, v127, v195, vcc
		v_cmp_ge_i32_e64 vcc, v12, v111
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v23, a154
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[44:45], vcc
		v_accvgpr_read_b32 v23, a72
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v30, v127, v196, s[38:39]
		v_cndmask_b32_e64 v31, v127, v197, s[44:45]
		v_cndmask_b32_e64 v108, v127, v198, s[46:47]
		v_accvgpr_read_b32 v23, a73
		v_cmp_ge_i32_e64 vcc, v12, v23
		v_cndmask_b32_e64 v110, v127, v112, s[68:69]
		v_cndmask_b32_e64 v111, v127, v113, s[70:71]
		v_cndmask_b32_e32 v109, v127, v199, vcc
		v_accvgpr_read_b32 v23, a155
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v23, a156
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[44:45], vcc
		v_accvgpr_read_b32 v23, a74
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v112, v127, v200, s[38:39]
		v_cndmask_b32_e64 v113, v127, v201, s[44:45]
		v_cndmask_b32_e64 v178, v127, v202, s[46:47]
		v_accvgpr_read_b32 v23, a75
		v_cmp_ge_i32_e64 vcc, v12, v23
		v_cndmask_b32_e64 v236, v127, v114, s[72:73]
		v_cndmask_b32_e64 v180, v127, v116, s[74:75]
		v_cndmask_b32_e32 v179, v127, v203, vcc
		v_accvgpr_read_b32 v23, a157
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v23, a158
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[44:45], vcc
		v_accvgpr_read_b32 v23, a76
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v182, v127, v204, s[38:39]
		v_cndmask_b32_e64 v183, v127, v205, s[44:45]
		v_cndmask_b32_e64 v184, v127, v206, s[46:47]
		v_accvgpr_read_b32 v23, a77
		v_cmp_ge_i32_e64 vcc, v12, v23
		v_cndmask_b32_e64 v181, v127, v117, s[76:77]
		v_cndmask_b32_e64 v238, v127, v118, s[78:79]
		v_cndmask_b32_e32 v185, v127, v207, vcc
		v_accvgpr_read_b32 v23, a159
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v23, a162
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[44:45], vcc
		v_accvgpr_read_b32 v23, a79
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v116, v127, v208, s[38:39]
		v_cndmask_b32_e64 v117, v127, v209, s[44:45]
		v_cndmask_b32_e64 v186, v127, v210, s[46:47]
		v_accvgpr_read_b32 v23, a80
		v_cmp_ge_i32_e64 vcc, v12, v23
		v_cndmask_b32_e64 v188, v127, v120, s[80:81]
		v_mov_b32_e32 v190, s82
		v_mov_b32_e32 v191, s83
		s_nop 0
		v_readfirstlane_b32 s38, v190
		v_readfirstlane_b32 s39, v191
		s_nop 1
		v_cndmask_b32_e64 v189, v127, v121, s[38:39]
		v_cndmask_b32_e32 v187, v127, v211, vcc
		v_accvgpr_read_b32 v23, a163
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v23, a170
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[44:45], vcc
		v_accvgpr_read_b32 v23, a140
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v120, v127, v212, s[38:39]
		v_cndmask_b32_e64 v121, v127, v213, s[44:45]
		v_cndmask_b32_e64 v190, v127, v214, s[46:47]
		v_accvgpr_read_b32 v23, a141
		v_cmp_ge_i32_e64 vcc, v12, v23
		v_mov_b32_e32 v192, s84
		v_mov_b32_e32 v193, s85
		s_nop 0
		v_readfirstlane_b32 s38, v192
		v_readfirstlane_b32 s39, v193
		s_nop 1
		v_cndmask_b32_e64 v240, v127, v122, s[38:39]
		v_mov_b32_e32 v192, s86
		v_mov_b32_e32 v193, s87
		s_nop 0
		v_readfirstlane_b32 s38, v192
		v_readfirstlane_b32 s39, v193
		s_nop 1
		v_cndmask_b32_e64 v192, v127, v124, s[38:39]
		v_cndmask_b32_e32 v191, v127, v215, vcc
		v_accvgpr_read_b32 v23, a171
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v23, a178
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[44:45], vcc
		v_accvgpr_read_b32 v23, a142
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v194, v127, v216, s[38:39]
		v_cndmask_b32_e64 v195, v127, v217, s[44:45]
		v_cndmask_b32_e64 v196, v127, v218, s[46:47]
		v_accvgpr_read_b32 v23, a143
		v_cmp_ge_i32_e64 vcc, v12, v23
		v_mov_b32_e32 v198, s88
		v_mov_b32_e32 v199, s89
		s_nop 0
		v_readfirstlane_b32 s38, v198
		v_readfirstlane_b32 s39, v199
		s_nop 1
		v_cndmask_b32_e64 v193, v127, v125, s[38:39]
		v_accvgpr_read_b32 v23, a160
		s_nop 0
		v_readfirstlane_b32 s38, v23
		v_accvgpr_read_b32 v23, a161
		s_nop 0
		v_readfirstlane_b32 s39, v23
		s_nop 1
		v_cndmask_b32_e64 v242, v127, v126, s[38:39]
		v_cndmask_b32_e32 v197, v127, v219, vcc
		v_accvgpr_read_b32 v23, a179
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v23, a186
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[44:45], vcc
		v_accvgpr_read_b32 v23, a144
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v124, v127, v220, s[38:39]
		v_cndmask_b32_e64 v125, v127, v221, s[44:45]
		v_cndmask_b32_e64 v198, v127, v222, s[46:47]
		v_accvgpr_read_b32 v23, a145
		v_cmp_ge_i32_e64 vcc, v12, v23
		v_accvgpr_read_b32 v23, a164
		s_nop 0
		v_readfirstlane_b32 s38, v23
		v_accvgpr_read_b32 v23, a165
		s_nop 0
		v_readfirstlane_b32 s39, v23
		s_nop 1
		v_cndmask_b32_e64 v200, v127, v128, s[38:39]
		v_accvgpr_read_b32 v23, a166
		s_nop 0
		v_readfirstlane_b32 s38, v23
		v_accvgpr_read_b32 v23, a167
		s_nop 0
		v_readfirstlane_b32 s39, v23
		s_nop 1
		v_cndmask_b32_e64 v201, v127, v129, s[38:39]
		v_cndmask_b32_e32 v199, v127, v223, vcc
		v_cmp_ge_i32_e64 vcc, v12, v115
		s_mov_b64 s[38:39], vcc
		v_cmp_ge_i32_e64 vcc, v12, v119
		s_mov_b64 s[44:45], vcc
		v_accvgpr_read_b32 v23, a146
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v114, v127, v160, s[38:39]
		v_cndmask_b32_e64 v115, v127, v161, s[44:45]
		v_cndmask_b32_e64 v118, v127, v162, s[46:47]
		v_accvgpr_read_b32 v23, a147
		v_cmp_ge_i32_e64 vcc, v12, v23
		v_accvgpr_read_b32 v23, a168
		s_nop 0
		v_readfirstlane_b32 s38, v23
		v_accvgpr_read_b32 v23, a169
		s_nop 0
		v_readfirstlane_b32 s39, v23
		s_nop 1
		v_cndmask_b32_e64 v244, v127, v130, s[38:39]
		v_accvgpr_read_b32 v23, a172
		s_nop 0
		v_readfirstlane_b32 s38, v23
		v_accvgpr_read_b32 v23, a173
		s_nop 0
		v_readfirstlane_b32 s39, v23
		s_nop 1
		v_cndmask_b32_e64 v128, v127, v132, s[38:39]
		v_cndmask_b32_e32 v119, v127, v163, vcc
		v_cmp_ge_i32_e64 vcc, v12, v123
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v23, a187
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[44:45], vcc
		v_accvgpr_read_b32 v23, a148
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v122, v127, v164, s[38:39]
		v_cndmask_b32_e64 v123, v127, v165, s[44:45]
		v_cndmask_b32_e64 v130, v127, v166, s[46:47]
		v_accvgpr_read_b32 v23, a149
		v_cmp_ge_i32_e64 vcc, v12, v23
		v_accvgpr_read_b32 v23, a174
		s_nop 0
		v_readfirstlane_b32 s38, v23
		v_accvgpr_read_b32 v23, a175
		s_nop 0
		v_readfirstlane_b32 s39, v23
		s_nop 1
		v_cndmask_b32_e64 v129, v127, v133, s[38:39]
		v_accvgpr_read_b32 v23, a176
		s_nop 0
		v_readfirstlane_b32 s38, v23
		v_accvgpr_read_b32 v23, a177
		s_nop 0
		v_readfirstlane_b32 s39, v23
		s_nop 1
		v_cndmask_b32_e64 v246, v127, v134, s[38:39]
		v_cndmask_b32_e32 v131, v127, v167, vcc
		v_accvgpr_read_b32 v23, a188
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v23, a189
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[44:45], vcc
		v_accvgpr_read_b32 v23, a150
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v132, v127, v168, s[38:39]
		v_cndmask_b32_e64 v133, v127, v169, s[44:45]
		v_cndmask_b32_e64 v134, v127, v170, s[46:47]
		v_accvgpr_read_b32 v23, a151
		v_cmp_ge_i32_e64 vcc, v12, v23
		v_accvgpr_read_b32 v23, a180
		s_nop 0
		v_readfirstlane_b32 s38, v23
		v_accvgpr_read_b32 v23, a181
		s_nop 0
		v_readfirstlane_b32 s39, v23
		s_nop 1
		v_cndmask_b32_e64 v160, v127, v136, s[38:39]
		v_accvgpr_read_b32 v23, a182
		s_nop 0
		v_readfirstlane_b32 s38, v23
		v_accvgpr_read_b32 v23, a183
		s_nop 0
		v_readfirstlane_b32 s39, v23
		s_nop 1
		v_cndmask_b32_e64 v161, v127, v137, s[38:39]
		v_cndmask_b32_e32 v135, v127, v171, vcc
		v_accvgpr_read_b32 v23, a190
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[38:39], vcc
		v_accvgpr_read_b32 v23, a191
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[44:45], vcc
		v_accvgpr_read_b32 v23, a152
		v_cmp_ge_i32_e64 vcc, v12, v23
		s_mov_b64 s[46:47], vcc
		v_cndmask_b32_e64 v136, v127, v172, s[38:39]
		v_cndmask_b32_e64 v137, v127, v173, s[44:45]
		v_cndmask_b32_e64 v162, v127, v174, s[46:47]
		v_accvgpr_read_b32 v23, a153
		v_cmp_ge_i32_e64 vcc, v12, v23
		v_accvgpr_read_b32 v23, a184
		s_nop 0
		v_readfirstlane_b32 s38, v23
		v_accvgpr_read_b32 v23, a185
		s_nop 0
		v_readfirstlane_b32 s39, v23
		s_nop 1
		v_cndmask_b32_e64 v248, v127, v138, s[38:39]
		v_mov_b32_e32 v138, s90
		v_mov_b32_e32 v139, s91
		s_nop 0
		v_readfirstlane_b32 s38, v138
		v_readfirstlane_b32 s39, v139
		s_nop 1
		v_cndmask_b32_e64 v250, v127, v140, s[38:39]
		v_cndmask_b32_e32 v163, v127, v175, vcc
		v_max_f32_e32 v23, v254, v255
		v_max_f32_e32 v126, v226, v227
		v_max_f32_e32 v127, v20, v21
		v_max_f32_e32 v138, v228, v229
		v_max_f32_e32 v139, v100, v101
		v_max_f32_e32 v140, v232, v233
		v_max_f32_e32 v141, v104, v105
		v_max_f32_e32 v164, v234, v235
		v_max_f32_e32 v165, v110, v111
		v_max_f32_e32 v166, v236, v237
		v_max_f32_e32 v167, v180, v181
		v_max_f32_e32 v168, v238, v239
		v_max_f32_e32 v169, v188, v189
		v_max_f32_e32 v170, v240, v241
		v_max_f32_e32 v171, v192, v193
		v_max_f32_e32 v172, v242, v243
		v_max_f32_e32 v173, v200, v201
		v_max_f32_e32 v174, v244, v245
		v_max_f32_e32 v175, v128, v129
		v_max_f32_e32 v202, v246, v247
		v_max_f32_e32 v203, v160, v161
		v_max_f32_e32 v204, v248, v249
		v_max_f32_e32 v205, v250, v251
		v_max_f32_e32 v206, v252, v253
		v_max_f32_e32 v207, v142, v143
		v_max_f32_e32 v208, v144, v145
		v_max_f32_e32 v209, v146, v147
		v_max_f32_e32 v210, v148, v149
		v_max_f32_e32 v211, v150, v151
		v_max_f32_e32 v212, v152, v153
		v_max_f32_e32 v213, v154, v155
		v_max_f32_e32 v214, v156, v157
		v_max_f32_e32 v23, v23, v126
		v_max_f32_e32 v126, v127, v138
		v_max_f32_e32 v127, v139, v140
		v_max_f32_e32 v138, v141, v164
		v_max_f32_e32 v139, v165, v166
		v_max_f32_e32 v140, v167, v168
		v_max_f32_e32 v141, v169, v170
		v_max_f32_e32 v164, v171, v172
		v_max_f32_e32 v165, v173, v174
		v_max_f32_e32 v166, v175, v202
		v_max_f32_e32 v167, v203, v204
		v_max_f32_e32 v168, v205, v206
		v_max_f32_e32 v169, v207, v208
		v_max_f32_e32 v170, v209, v210
		v_max_f32_e32 v171, v211, v212
		v_max_f32_e32 v172, v213, v214
		v_max_f32_e32 v23, v23, v126
		v_max_f32_e32 v126, v127, v138
		v_max_f32_e32 v127, v139, v140
		v_max_f32_e32 v138, v141, v164
		v_max_f32_e32 v139, v165, v166
		v_max_f32_e32 v140, v167, v168
		v_max_f32_e32 v141, v169, v170
		v_max_f32_e32 v164, v171, v172
		v_max_f32_e32 v23, v23, v126
		v_max_f32_e32 v126, v127, v138
		v_max_f32_e32 v127, v139, v140
		v_max_f32_e32 v138, v141, v164
		v_max_f32_e32 v23, v23, v126
		v_max_f32_e32 v126, v127, v138
		v_max_f32_e32 v23, v23, v126
		ds_bpermute_b32 v126, v8, v23
		ds_bpermute_b32 v127, v6, v23
		v_max_f32_e32 v23, v14, v15
		v_max_f32_e32 v138, v96, v97
		v_max_f32_e32 v139, v158, v159
		v_max_f32_e32 v140, v176, v177
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v164, v126, v127
		v_max_f32_e32 v126, v24, v25
		v_max_f32_e32 v127, v98, v99
		v_max_f32_e32 v141, v26, v27
		v_max_f32_e32 v165, v102, v103
		v_max_f32_e32 v166, v28, v29
		v_max_f32_e32 v167, v106, v107
		v_max_f32_e32 v168, v30, v31
		v_max_f32_e32 v169, v108, v109
		v_max_f32_e32 v170, v112, v113
		v_max_f32_e32 v171, v178, v179
		v_max_f32_e32 v172, v182, v183
		v_max_f32_e32 v173, v184, v185
		v_max_f32_e32 v174, v116, v117
		v_max_f32_e32 v175, v186, v187
		v_max_f32_e32 v202, v120, v121
		v_max_f32_e32 v203, v190, v191
		v_max_f32_e32 v204, v194, v195
		v_max_f32_e32 v205, v196, v197
		v_max_f32_e32 v206, v124, v125
		v_max_f32_e32 v207, v198, v199
		v_max_f32_e32 v208, v114, v115
		v_max_f32_e32 v209, v118, v119
		v_max_f32_e32 v210, v122, v123
		v_max_f32_e32 v211, v130, v131
		v_max_f32_e32 v212, v132, v133
		v_max_f32_e32 v213, v134, v135
		v_max_f32_e32 v214, v136, v137
		v_max_f32_e32 v215, v162, v163
		v_max_f32_e32 v23, v23, v138
		v_max_f32_e32 v138, v139, v140
		v_max_f32_e32 v126, v126, v127
		v_max_f32_e32 v127, v141, v165
		v_max_f32_e32 v139, v166, v167
		v_max_f32_e32 v140, v168, v169
		v_max_f32_e32 v141, v170, v171
		v_max_f32_e32 v165, v172, v173
		v_max_f32_e32 v166, v174, v175
		v_max_f32_e32 v167, v202, v203
		v_max_f32_e32 v168, v204, v205
		v_max_f32_e32 v169, v206, v207
		v_max_f32_e32 v170, v208, v209
		v_max_f32_e32 v171, v210, v211
		v_max_f32_e32 v172, v212, v213
		v_max_f32_e32 v173, v214, v215
		v_max_f32_e32 v23, v23, v138
		v_max_f32_e32 v126, v126, v127
		v_max_f32_e32 v127, v139, v140
		v_max_f32_e32 v138, v141, v165
		v_max_f32_e32 v139, v166, v167
		v_max_f32_e32 v140, v168, v169
		v_max_f32_e32 v141, v170, v171
		v_max_f32_e32 v165, v172, v173
		v_max_f32_e32 v23, v23, v126
		v_max_f32_e32 v126, v127, v138
		v_max_f32_e32 v127, v139, v140
		v_max_f32_e32 v138, v141, v165
		v_max_f32_e32 v23, v23, v126
		v_max_f32_e32 v126, v127, v138
		v_max_f32_e32 v23, v23, v126
		ds_bpermute_b32 v126, v8, v23
		ds_bpermute_b32 v127, v6, v23
		v_mov_b32_e32 v138, 0x3e38aa3b
		v_mov_b32_e32 v139, 0x3e38aa3b
		v_pk_mul_f32 v[140:141], v[254:255], v[138:139]
		v_pk_mul_f32 v[166:167], v[226:227], v[138:139]
		v_pk_mul_f32 v[168:169], v[20:21], v[138:139]
		v_pk_mul_f32 v[20:21], v[228:229], v[138:139]
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v165, v126, v127
		v_pk_mul_f32 v[126:127], v[164:165], v[138:139]
		v_max_f32_e32 v23, v7, v126
		v_max_f32_e32 v126, v16, v127
		v_pk_mul_f32 v[164:165], v[100:101], v[138:139]
		v_pk_mul_f32 v[100:101], v[232:233], v[138:139]
		v_pk_mul_f32 v[170:171], v[104:105], v[138:139]
		v_pk_mul_f32 v[104:105], v[234:235], v[138:139]
		v_pk_mul_f32 v[172:173], v[110:111], v[138:139]
		v_pk_mul_f32 v[110:111], v[236:237], v[138:139]
		v_pk_mul_f32 v[174:175], v[180:181], v[138:139]
		v_pk_mul_f32 v[180:181], v[238:239], v[138:139]
		v_pk_mul_f32 v[202:203], v[188:189], v[138:139]
		v_pk_mul_f32 v[188:189], v[240:241], v[138:139]
		v_pk_mul_f32 v[204:205], v[192:193], v[138:139]
		v_pk_mul_f32 v[192:193], v[242:243], v[138:139]
		v_pk_mul_f32 v[206:207], v[200:201], v[138:139]
		v_pk_mul_f32 v[200:201], v[244:245], v[138:139]
		v_pk_mul_f32 v[208:209], v[128:129], v[138:139]
		v_pk_mul_f32 v[128:129], v[246:247], v[138:139]
		v_pk_mul_f32 v[210:211], v[160:161], v[138:139]
		v_pk_mul_f32 v[160:161], v[248:249], v[138:139]
		v_pk_mul_f32 v[212:213], v[250:251], v[138:139]
		v_pk_mul_f32 v[214:215], v[252:253], v[138:139]
		v_pk_mul_f32 v[216:217], v[142:143], v[138:139]
		v_pk_mul_f32 v[142:143], v[144:145], v[138:139]
		v_pk_mul_f32 v[144:145], v[146:147], v[138:139]
		v_pk_mul_f32 v[146:147], v[148:149], v[138:139]
		v_pk_mul_f32 v[148:149], v[150:151], v[138:139]
		v_pk_mul_f32 v[150:151], v[152:153], v[138:139]
		v_pk_mul_f32 v[152:153], v[154:155], v[138:139]
		v_pk_mul_f32 v[154:155], v[156:157], v[138:139]
		v_pk_mul_f32 v[156:157], v[14:15], v[138:139]
		v_pk_mul_f32 v[14:15], v[96:97], v[138:139]
		v_pk_mul_f32 v[96:97], v[158:159], v[138:139]
		v_pk_mul_f32 v[158:159], v[176:177], v[138:139]
		v_pk_mul_f32 v[176:177], v[24:25], v[138:139]
		v_pk_mul_f32 v[24:25], v[98:99], v[138:139]
		v_pk_mul_f32 v[98:99], v[26:27], v[138:139]
		v_pk_mul_f32 v[26:27], v[102:103], v[138:139]
		v_pk_mul_f32 v[102:103], v[28:29], v[138:139]
		v_pk_mul_f32 v[28:29], v[106:107], v[138:139]
		v_pk_mul_f32 v[106:107], v[30:31], v[138:139]
		v_pk_mul_f32 v[30:31], v[108:109], v[138:139]
		v_pk_mul_f32 v[108:109], v[112:113], v[138:139]
		v_pk_mul_f32 v[112:113], v[178:179], v[138:139]
		v_pk_mul_f32 v[178:179], v[182:183], v[138:139]
		v_pk_mul_f32 v[182:183], v[184:185], v[138:139]
		v_pk_mul_f32 v[184:185], v[116:117], v[138:139]
		v_pk_mul_f32 v[116:117], v[186:187], v[138:139]
		v_pk_mul_f32 v[186:187], v[120:121], v[138:139]
		v_pk_mul_f32 v[120:121], v[190:191], v[138:139]
		v_pk_mul_f32 v[190:191], v[194:195], v[138:139]
		v_pk_mul_f32 v[194:195], v[196:197], v[138:139]
		v_pk_mul_f32 v[196:197], v[124:125], v[138:139]
		v_pk_mul_f32 v[124:125], v[198:199], v[138:139]
		v_pk_mul_f32 v[198:199], v[114:115], v[138:139]
		v_pk_mul_f32 v[114:115], v[118:119], v[138:139]
		v_pk_mul_f32 v[118:119], v[122:123], v[138:139]
		v_pk_mul_f32 v[122:123], v[130:131], v[138:139]
		v_pk_mul_f32 v[130:131], v[132:133], v[138:139]
		v_pk_mul_f32 v[132:133], v[134:135], v[138:139]
		v_pk_mul_f32 v[134:135], v[136:137], v[138:139]
		v_pk_mul_f32 v[136:137], v[162:163], v[138:139]
		v_sub_f32_e32 v127, v140, v23
		v_sub_f32_e32 v138, v141, v23
		v_sub_f32_e32 v139, v166, v23
		v_sub_f32_e32 v140, v167, v23
		v_sub_f32_e32 v141, v168, v23
		v_sub_f32_e32 v162, v169, v23
		v_sub_f32_e32 v20, v20, v23
		v_sub_f32_e32 v21, v21, v23
		v_sub_f32_e32 v163, v164, v23
		v_sub_f32_e32 v164, v165, v23
		v_sub_f32_e32 v100, v100, v23
		v_sub_f32_e32 v101, v101, v23
		v_sub_f32_e32 v165, v170, v23
		v_sub_f32_e32 v166, v171, v23
		v_sub_f32_e32 v104, v104, v23
		v_sub_f32_e32 v105, v105, v23
		v_sub_f32_e32 v167, v172, v23
		v_sub_f32_e32 v168, v173, v23
		v_sub_f32_e32 v110, v110, v23
		v_sub_f32_e32 v111, v111, v23
		v_sub_f32_e32 v169, v174, v23
		v_sub_f32_e32 v170, v175, v23
		v_sub_f32_e32 v171, v180, v23
		v_sub_f32_e32 v172, v181, v23
		v_sub_f32_e32 v173, v202, v23
		v_sub_f32_e32 v174, v203, v23
		v_sub_f32_e32 v175, v188, v23
		v_sub_f32_e32 v180, v189, v23
		v_sub_f32_e32 v181, v204, v23
		v_sub_f32_e32 v188, v205, v23
		v_sub_f32_e32 v189, v192, v23
		v_sub_f32_e32 v192, v193, v23
		v_sub_f32_e32 v193, v206, v23
		v_sub_f32_e32 v202, v207, v23
		v_sub_f32_e32 v200, v200, v23
		v_sub_f32_e32 v201, v201, v23
		v_sub_f32_e32 v203, v208, v23
		v_sub_f32_e32 v204, v209, v23
		v_sub_f32_e32 v128, v128, v23
		v_sub_f32_e32 v129, v129, v23
		v_sub_f32_e32 v205, v210, v23
		v_sub_f32_e32 v206, v211, v23
		v_sub_f32_e32 v160, v160, v23
		v_sub_f32_e32 v161, v161, v23
		v_sub_f32_e32 v207, v212, v23
		v_sub_f32_e32 v208, v213, v23
		v_sub_f32_e32 v209, v214, v23
		v_sub_f32_e32 v210, v215, v23
		v_sub_f32_e32 v211, v216, v23
		v_sub_f32_e32 v212, v217, v23
		v_sub_f32_e32 v142, v142, v23
		v_sub_f32_e32 v143, v143, v23
		v_sub_f32_e32 v144, v144, v23
		v_sub_f32_e32 v145, v145, v23
		v_sub_f32_e32 v146, v146, v23
		v_sub_f32_e32 v147, v147, v23
		v_sub_f32_e32 v148, v148, v23
		v_sub_f32_e32 v149, v149, v23
		v_sub_f32_e32 v150, v150, v23
		v_sub_f32_e32 v151, v151, v23
		v_sub_f32_e32 v152, v152, v23
		v_sub_f32_e32 v153, v153, v23
		v_sub_f32_e32 v154, v154, v23
		v_sub_f32_e32 v155, v155, v23
		v_sub_f32_e32 v156, v156, v126
		v_sub_f32_e32 v157, v157, v126
		v_sub_f32_e32 v14, v14, v126
		v_sub_f32_e32 v15, v15, v126
		v_sub_f32_e32 v96, v96, v126
		v_sub_f32_e32 v97, v97, v126
		v_sub_f32_e32 v158, v158, v126
		v_sub_f32_e32 v159, v159, v126
		v_sub_f32_e32 v176, v176, v126
		v_sub_f32_e32 v177, v177, v126
		v_sub_f32_e32 v24, v24, v126
		v_sub_f32_e32 v25, v25, v126
		v_sub_f32_e32 v98, v98, v126
		v_sub_f32_e32 v99, v99, v126
		v_sub_f32_e32 v26, v26, v126
		v_sub_f32_e32 v27, v27, v126
		v_sub_f32_e32 v102, v102, v126
		v_sub_f32_e32 v103, v103, v126
		v_sub_f32_e32 v28, v28, v126
		v_sub_f32_e32 v29, v29, v126
		v_sub_f32_e32 v106, v106, v126
		v_sub_f32_e32 v107, v107, v126
		v_sub_f32_e32 v30, v30, v126
		v_sub_f32_e32 v31, v31, v126
		v_sub_f32_e32 v108, v108, v126
		v_sub_f32_e32 v109, v109, v126
		v_sub_f32_e32 v112, v112, v126
		v_sub_f32_e32 v113, v113, v126
		v_sub_f32_e32 v178, v178, v126
		v_sub_f32_e32 v179, v179, v126
		v_sub_f32_e32 v182, v182, v126
		v_sub_f32_e32 v183, v183, v126
		v_sub_f32_e32 v184, v184, v126
		v_sub_f32_e32 v185, v185, v126
		v_sub_f32_e32 v116, v116, v126
		v_sub_f32_e32 v117, v117, v126
		v_sub_f32_e32 v186, v186, v126
		v_sub_f32_e32 v187, v187, v126
		v_sub_f32_e32 v120, v120, v126
		v_sub_f32_e32 v121, v121, v126
		v_sub_f32_e32 v190, v190, v126
		v_sub_f32_e32 v191, v191, v126
		v_sub_f32_e32 v194, v194, v126
		v_sub_f32_e32 v195, v195, v126
		v_sub_f32_e32 v196, v196, v126
		v_sub_f32_e32 v197, v197, v126
		v_sub_f32_e32 v124, v124, v126
		v_sub_f32_e32 v125, v125, v126
		v_sub_f32_e32 v198, v198, v126
		v_sub_f32_e32 v199, v199, v126
		v_sub_f32_e32 v114, v114, v126
		v_sub_f32_e32 v115, v115, v126
		v_sub_f32_e32 v118, v118, v126
		v_sub_f32_e32 v119, v119, v126
		v_sub_f32_e32 v122, v122, v126
		v_sub_f32_e32 v123, v123, v126
		v_sub_f32_e32 v130, v130, v126
		v_sub_f32_e32 v131, v131, v126
		v_sub_f32_e32 v132, v132, v126
		v_sub_f32_e32 v133, v133, v126
		v_sub_f32_e32 v134, v134, v126
		v_sub_f32_e32 v135, v135, v126
		v_sub_f32_e32 v136, v136, v126
		v_sub_f32_e32 v137, v137, v126
		v_exp_f32_e32 v214, v127
		v_exp_f32_e32 v216, v138
		v_exp_f32_e32 v215, v139
		v_exp_f32_e32 v217, v140
		v_exp_f32_e32 v138, v141
		v_exp_f32_e32 v140, v162
		v_exp_f32_e32 v139, v20
		v_exp_f32_e32 v141, v21
		v_exp_f32_e32 v20, v163
		v_exp_f32_e32 v162, v164
		v_exp_f32_e32 v21, v100
		v_exp_f32_e32 v163, v101
		v_exp_f32_e32 v100, v165
		v_exp_f32_e32 v164, v166
		v_exp_f32_e32 v101, v104
		v_exp_f32_e32 v165, v105
		v_exp_f32_e32 v104, v167
		v_exp_f32_e32 v166, v168
		v_exp_f32_e32 v105, v110
		v_exp_f32_e32 v167, v111
		v_exp_f32_e32 v110, v169
		v_exp_f32_e32 v168, v170
		v_exp_f32_e32 v111, v171
		v_exp_f32_e32 v169, v172
		v_exp_f32_e32 v170, v173
		v_exp_f32_e32 v172, v174
		v_exp_f32_e32 v171, v175
		v_exp_f32_e32 v173, v180
		v_exp_f32_e32 v174, v181
		v_exp_f32_e32 v180, v188
		v_exp_f32_e32 v175, v189
		v_exp_f32_e32 v181, v192
		v_exp_f32_e32 v188, v193
		v_exp_f32_e32 v192, v202
		v_exp_f32_e32 v189, v200
		v_exp_f32_e32 v193, v201
		v_exp_f32_e32 v200, v203
		v_exp_f32_e32 v202, v204
		v_exp_f32_e32 v201, v128
		v_exp_f32_e32 v203, v129
		v_exp_f32_e32 v128, v205
		v_exp_f32_e32 v204, v206
		v_exp_f32_e32 v129, v160
		v_exp_f32_e32 v205, v161
		v_exp_f32_e32 v160, v207
		v_exp_f32_e32 v206, v208
		v_exp_f32_e32 v161, v209
		v_exp_f32_e32 v207, v210
		v_exp_f32_e32 v208, v211
		v_exp_f32_e32 v210, v212
		v_exp_f32_e32 v209, v142
		v_exp_f32_e32 v211, v143
		v_exp_f32_e32 v142, v144
		v_exp_f32_e32 v212, v145
		v_exp_f32_e32 v143, v146
		v_exp_f32_e32 v213, v147
		v_exp_f32_e32 v144, v148
		v_exp_f32_e32 v146, v149
		v_exp_f32_e32 v145, v150
		v_exp_f32_e32 v147, v151
		v_exp_f32_e32 v148, v152
		v_exp_f32_e32 v150, v153
		v_exp_f32_e32 v149, v154
		v_exp_f32_e32 v151, v155
		v_exp_f32_e32 v153, v156
		v_exp_f32_e32 v155, v157
		v_exp_f32_e32 v156, v14
		v_exp_f32_e32 v218, v15
		v_exp_f32_e32 v157, v96
		v_exp_f32_e32 v219, v97
		v_exp_f32_e32 v14, v158
		v_exp_f32_e32 v96, v159
		v_exp_f32_e32 v15, v176
		v_exp_f32_e32 v97, v177
		v_exp_f32_e32 v158, v24
		v_exp_f32_e32 v176, v25
		v_exp_f32_e32 v159, v98
		v_exp_f32_e32 v177, v99
		v_exp_f32_e32 v24, v26
		v_exp_f32_e32 v98, v27
		v_exp_f32_e32 v25, v102
		v_exp_f32_e32 v99, v103
		v_exp_f32_e32 v26, v28
		v_exp_f32_e32 v102, v29
		v_exp_f32_e32 v27, v106
		v_exp_f32_e32 v103, v107
		v_exp_f32_e32 v28, v30
		v_exp_f32_e32 v106, v31
		v_exp_f32_e32 v29, v108
		v_exp_f32_e32 v107, v109
		v_exp_f32_e32 v30, v112
		v_exp_f32_e32 v108, v113
		v_exp_f32_e32 v31, v178
		v_exp_f32_e32 v109, v179
		v_exp_f32_e32 v112, v182
		v_exp_f32_e32 v178, v183
		v_exp_f32_e32 v113, v184
		v_exp_f32_e32 v179, v185
		v_exp_f32_e32 v182, v116
		v_exp_f32_e32 v184, v117
		v_exp_f32_e32 v183, v186
		v_exp_f32_e32 v185, v187
		v_exp_f32_e32 v116, v120
		v_exp_f32_e32 v186, v121
		v_exp_f32_e32 v117, v190
		v_exp_f32_e32 v187, v191
		v_exp_f32_e32 v120, v194
		v_exp_f32_e32 v190, v195
		v_exp_f32_e32 v121, v196
		v_exp_f32_e32 v191, v197
		v_exp_f32_e32 v194, v124
		v_exp_f32_e32 v196, v125
		v_exp_f32_e32 v195, v198
		v_exp_f32_e32 v197, v199
		v_exp_f32_e32 v124, v114
		v_exp_f32_e32 v198, v115
		v_exp_f32_e32 v125, v118
		v_exp_f32_e32 v199, v119
		v_exp_f32_e32 v114, v122
		v_exp_f32_e32 v118, v123
		v_exp_f32_e32 v115, v130
		v_exp_f32_e32 v119, v131
		v_exp_f32_e32 v122, v132
		v_exp_f32_e32 v130, v133
		v_exp_f32_e32 v123, v134
		v_exp_f32_e32 v131, v135
		v_exp_f32_e32 v132, v136
		v_exp_f32_e32 v134, v137
		v_pk_add_f32 v[136:137], v[214:215], v[216:217]
		v_pk_add_f32 v[220:221], v[138:139], v[140:141]
		v_pk_add_f32 v[222:223], v[20:21], v[162:163]
		v_pk_add_f32 v[224:225], v[100:101], v[164:165]
		v_pk_add_f32 v[226:227], v[104:105], v[166:167]
		v_pk_add_f32 v[228:229], v[110:111], v[168:169]
		v_pk_add_f32 v[230:231], v[170:171], v[172:173]
		v_pk_add_f32 v[232:233], v[174:175], v[180:181]
		v_pk_add_f32 v[234:235], v[188:189], v[192:193]
		v_pk_add_f32 v[236:237], v[200:201], v[202:203]
		v_pk_add_f32 v[238:239], v[128:129], v[204:205]
		v_pk_add_f32 v[240:241], v[160:161], v[206:207]
		v_pk_add_f32 v[242:243], v[208:209], v[210:211]
		v_pk_add_f32 v[244:245], v[142:143], v[212:213]
		v_pk_add_f32 v[246:247], v[144:145], v[146:147]
		v_pk_add_f32 v[248:249], v[148:149], v[150:151]
		v_mov_b32_e32 v250, v137
		v_mov_b32_e32 v251, v221
		v_mov_b32_e32 v252, v136
		v_mov_b32_e32 v253, v220
		v_pk_add_f32 v[136:137], v[252:253], v[250:251]
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
		v_mov_b32_e32 v220, v137
		v_mov_b32_e32 v221, v223
		v_mov_b32_e32 v224, v136
		v_mov_b32_e32 v225, v222
		v_pk_add_f32 v[136:137], v[224:225], v[220:221]
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
		v_mov_b32_e32 v220, v137
		v_mov_b32_e32 v221, v225
		v_mov_b32_e32 v222, v136
		v_mov_b32_e32 v223, v224
		v_pk_add_f32 v[136:137], v[222:223], v[220:221]
		v_mov_b32_e32 v220, v227
		v_mov_b32_e32 v221, v229
		v_mov_b32_e32 v222, v226
		v_mov_b32_e32 v223, v228
		v_pk_add_f32 v[224:225], v[222:223], v[220:221]
		v_mov_b32_e32 v220, v137
		v_mov_b32_e32 v221, v225
		v_mov_b32_e32 v222, v136
		v_mov_b32_e32 v223, v224
		v_pk_add_f32 v[136:137], v[222:223], v[220:221]
		v_add_f32_e32 v127, v136, v137
		ds_bpermute_b32 v152, v8, v127
		ds_bpermute_b32 v154, v6, v127
		v_pk_add_f32 v[136:137], v[156:157], v[218:219]
		v_pk_add_f32 v[220:221], v[14:15], v[96:97]
		v_pk_add_f32 v[222:223], v[158:159], v[176:177]
		v_pk_add_f32 v[224:225], v[24:25], v[98:99]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[226:227], v[152:153], v[154:155]
		v_pk_add_f32 v[228:229], v[26:27], v[102:103]
		v_pk_add_f32 v[230:231], v[28:29], v[106:107]
		v_pk_add_f32 v[232:233], v[30:31], v[108:109]
		v_pk_add_f32 v[234:235], v[112:113], v[178:179]
		v_pk_add_f32 v[236:237], v[182:183], v[184:185]
		v_pk_add_f32 v[238:239], v[116:117], v[186:187]
		v_pk_add_f32 v[240:241], v[120:121], v[190:191]
		v_pk_add_f32 v[242:243], v[194:195], v[196:197]
		v_pk_add_f32 v[244:245], v[124:125], v[198:199]
		v_pk_add_f32 v[246:247], v[114:115], v[118:119]
		v_pk_add_f32 v[248:249], v[122:123], v[130:131]
		v_mov_b32_e32 v133, v227
		v_mov_b32_e32 v135, v136
		v_pk_add_f32 v[250:251], v[132:133], v[134:135]
		v_mov_b32_e32 v252, v137
		v_mov_b32_e32 v253, v222
		v_pk_add_f32 v[136:137], v[252:253], v[220:221]
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
		v_mov_b32_e32 v233, v136
		v_pk_add_f32 v[232:233], v[232:233], v[250:251]
		v_mov_b32_e32 v236, v137
		v_mov_b32_e32 v237, v224
		v_pk_add_f32 v[136:137], v[236:237], v[220:221]
		v_mov_b32_e32 v220, v225
		v_mov_b32_e32 v221, v230
		v_pk_add_f32 v[220:221], v[220:221], v[222:223]
		v_mov_b32_e32 v222, v231
		v_mov_b32_e32 v223, v234
		v_pk_add_f32 v[224:225], v[222:223], v[228:229]
		v_mov_b32_e32 v222, v235
		v_mov_b32_e32 v223, v136
		v_pk_add_f32 v[222:223], v[222:223], v[232:233]
		v_mov_b32_e32 v228, v137
		v_mov_b32_e32 v229, v224
		v_pk_add_f32 v[136:137], v[228:229], v[220:221]
		v_mov_b32_e32 v220, v225
		v_mov_b32_e32 v221, v136
		v_pk_add_f32 v[224:225], v[220:221], v[222:223]
		v_add_f32_e32 v127, v137, v224
		v_add_f32_e32 v127, v225, v127
		ds_bpermute_b32 v133, v8, v127
		ds_bpermute_b32 v135, v6, v127
		v_sub_f32_e32 v7, v7, v23
		v_sub_f32_e32 v16, v16, v126
		v_exp_f32_e32 v136, v7
		v_exp_f32_e32 v220, v16
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v223, v133, v135
		v_mov_b32_e32 v137, v136
		v_pk_mul_f32 v[32:33], v[32:33], v[136:137]
		v_pk_mul_f32 v[34:35], v[34:35], v[136:137]
		v_pk_mul_f32 v[36:37], v[36:37], v[136:137]
		v_pk_mul_f32 v[38:39], v[38:39], v[136:137]
		v_pk_mul_f32 v[40:41], v[40:41], v[136:137]
		v_pk_mul_f32 v[42:43], v[42:43], v[136:137]
		v_pk_mul_f32 v[44:45], v[44:45], v[136:137]
		v_pk_mul_f32 v[46:47], v[46:47], v[136:137]
		v_pk_mul_f32 v[48:49], v[48:49], v[136:137]
		v_pk_mul_f32 v[50:51], v[50:51], v[136:137]
		v_pk_mul_f32 v[52:53], v[52:53], v[136:137]
		v_pk_mul_f32 v[54:55], v[54:55], v[136:137]
		v_pk_mul_f32 v[56:57], v[56:57], v[136:137]
		v_pk_mul_f32 v[58:59], v[58:59], v[136:137]
		v_pk_mul_f32 v[60:61], v[60:61], v[136:137]
		v_pk_mul_f32 v[62:63], v[62:63], v[136:137]
		v_mov_b32_e32 v221, v220
		v_pk_mul_f32 v[64:65], v[64:65], v[220:221]
		v_pk_mul_f32 v[66:67], v[66:67], v[220:221]
		v_pk_mul_f32 v[68:69], v[68:69], v[220:221]
		v_pk_mul_f32 v[70:71], v[70:71], v[220:221]
		v_pk_mul_f32 v[72:73], v[72:73], v[220:221]
		v_pk_mul_f32 v[74:75], v[74:75], v[220:221]
		v_pk_mul_f32 v[76:77], v[76:77], v[220:221]
		v_pk_mul_f32 v[78:79], v[78:79], v[220:221]
		v_pk_mul_f32 v[80:81], v[80:81], v[220:221]
		v_pk_mul_f32 v[82:83], v[82:83], v[220:221]
		v_pk_mul_f32 v[84:85], v[84:85], v[220:221]
		v_pk_mul_f32 v[86:87], v[86:87], v[220:221]
		v_pk_mul_f32 v[88:89], v[88:89], v[220:221]
		v_pk_mul_f32 v[90:91], v[90:91], v[220:221]
		v_pk_mul_f32 v[92:93], v[92:93], v[220:221]
		v_pk_mul_f32 v[94:95], v[94:95], v[220:221]
		v_mov_b32_e32 v222, v226
		v_mov_b32_e32 v224, v136
		v_mov_b32_e32 v225, v220
		v_mov_b64_e32 v[136:137], v[18:19]
		v_pk_fma_f32 v[18:19], v[136:137], v[224:225], v[222:223]
		v_cvt_pk_bf16_f32 v220, v214, v216
		v_cvt_pk_bf16_f32 v221, v215, v217
		v_cvt_pk_bf16_f32 v222, v138, v140
		v_cvt_pk_bf16_f32 v223, v139, v141
		v_cvt_pk_bf16_f32 v136, v20, v162
		v_cvt_pk_bf16_f32 v137, v21, v163
		v_cvt_pk_bf16_f32 v138, v100, v164
		v_cvt_pk_bf16_f32 v139, v101, v165
		v_cvt_pk_bf16_f32 v224, v104, v166
		v_cvt_pk_bf16_f32 v225, v105, v167
		v_cvt_pk_bf16_f32 v226, v110, v168
		v_cvt_pk_bf16_f32 v227, v111, v169
		v_cvt_pk_bf16_f32 v164, v170, v172
		v_cvt_pk_bf16_f32 v165, v171, v173
		v_cvt_pk_bf16_f32 v166, v174, v180
		v_cvt_pk_bf16_f32 v167, v175, v181
		v_cvt_pk_bf16_f32 v168, v188, v192
		v_cvt_pk_bf16_f32 v169, v189, v193
		v_cvt_pk_bf16_f32 v170, v200, v202
		v_cvt_pk_bf16_f32 v171, v201, v203
		v_cvt_pk_bf16_f32 v172, v128, v204
		v_cvt_pk_bf16_f32 v173, v129, v205
		v_cvt_pk_bf16_f32 v174, v160, v206
		v_cvt_pk_bf16_f32 v175, v161, v207
		v_cvt_pk_bf16_f32 v160, v208, v210
		v_cvt_pk_bf16_f32 v161, v209, v211
		v_cvt_pk_bf16_f32 v162, v142, v212
		v_cvt_pk_bf16_f32 v163, v143, v213
		v_cvt_pk_bf16_f32 v140, v144, v146
		v_cvt_pk_bf16_f32 v141, v145, v147
		v_cvt_pk_bf16_f32 v142, v148, v150
		v_cvt_pk_bf16_f32 v143, v149, v151
		v_cvt_pk_bf16_f32 v144, v153, v155
		v_cvt_pk_bf16_f32 v145, v156, v218
		v_cvt_pk_bf16_f32 v146, v157, v219
		v_cvt_pk_bf16_f32 v147, v14, v96
		v_cvt_pk_bf16_f32 v148, v15, v97
		v_cvt_pk_bf16_f32 v149, v158, v176
		v_cvt_pk_bf16_f32 v150, v159, v177
		v_cvt_pk_bf16_f32 v151, v24, v98
		v_cvt_pk_bf16_f32 v152, v25, v99
		v_cvt_pk_bf16_f32 v153, v26, v102
		v_cvt_pk_bf16_f32 v154, v27, v103
		v_cvt_pk_bf16_f32 v155, v28, v106
		v_cvt_pk_bf16_f32 v24, v29, v107
		v_cvt_pk_bf16_f32 v25, v30, v108
		v_cvt_pk_bf16_f32 v26, v31, v109
		v_cvt_pk_bf16_f32 v27, v112, v178
		v_cvt_pk_bf16_f32 v28, v113, v179
		v_cvt_pk_bf16_f32 v29, v182, v184
		v_cvt_pk_bf16_f32 v30, v183, v185
		v_cvt_pk_bf16_f32 v31, v116, v186
		v_cvt_pk_bf16_f32 v96, v117, v187
		v_cvt_pk_bf16_f32 v97, v120, v190
		v_cvt_pk_bf16_f32 v98, v121, v191
		v_cvt_pk_bf16_f32 v99, v194, v196
		v_cvt_pk_bf16_f32 v100, v195, v197
		v_cvt_pk_bf16_f32 v101, v124, v198
		v_cvt_pk_bf16_f32 v102, v125, v199
		v_cvt_pk_bf16_f32 v103, v114, v118
		v_cvt_pk_bf16_f32 v104, v115, v119
		v_cvt_pk_bf16_f32 v105, v122, v130
		v_cvt_pk_bf16_f32 v106, v123, v131
		v_cvt_pk_bf16_f32 v107, v132, v134
		v_permlane32_swap_b32_e32 v220, v222
		v_permlane32_swap_b32_e32 v221, v223
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_permlane32_swap_b32_e32 v224, v226
		v_permlane32_swap_b32_e32 v225, v227
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		v_permlane32_swap_b32_e32 v168, v170
		v_permlane32_swap_b32_e32 v169, v171
		v_permlane32_swap_b32_e32 v172, v174
		v_permlane32_swap_b32_e32 v173, v175
		v_permlane32_swap_b32_e32 v160, v162
		v_permlane32_swap_b32_e32 v161, v163
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_permlane32_swap_b32_e32 v148, v150
		v_permlane32_swap_b32_e32 v149, v151
		v_permlane32_swap_b32_e32 v152, v154
		v_permlane32_swap_b32_e32 v153, v155
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[220:223], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[220:223], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[144:147], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[144:147], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[136:139], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[136:139], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[148:151], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[148:151], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[224:227], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[224:227], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[152:155], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[152:155], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[164:167], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[164:167], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[24:27], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[24:27], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[168:171], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[168:171], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[28:31], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[28:31], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[172:175], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[172:175], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[216:219], v[160:163], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[248:251], v[160:163], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[248:251], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[216:219], v[100:103], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[220:223], v[140:143], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[252:255], v[140:143], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[252:255], v[104:107], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[220:223], v[104:107], v[64:79]
		s_add_i32 s1, s42, 0x80
		s_cmp_lt_i32 s1, s24
		s_mov_b32 s42, s1
		v_mov_b32_e32 v7, v23
		v_mov_b32_e32 v16, v126
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_2
.L_attn_fwd_persistent.loop_exit_2:
		s_mov_b32 s28, s8
		s_mov_b32 s29, s9
		s_mov_b32 s30, s26
		s_mov_b32 s31, s27
		v_rcp_f32_e32 v6, v18
		v_rcp_f32_e32 v8, v19
		v_mov_b32_e32 v7, v6
		v_pk_mul_f32 v[12:13], v[32:33], v[6:7]
		v_pk_mul_f32 v[14:15], v[34:35], v[6:7]
		v_pk_mul_f32 v[16:17], v[36:37], v[6:7]
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
		v_accvgpr_read_b32 v8, a11
		v_mov_b32_e32 v9, 8
		v_mul_lo_u32 v9, v9, v8
		v_xor_b32_e32 v8, 16, v9
		v_xor_b32_e32 v74, 32, v9
		v_xor_b32_e32 v75, 48, v9
		s_mov_b32 s1, 64
		v_cmp_lt_i32_e64 vcc, v9, s1
		s_mov_b64 s[24:25], vcc
		v_readfirstlane_b32 s26, v10
		v_readfirstlane_b32 s27, v11
		s_nop 1
		v_mov_b32_e32 v9, s27
		v_mov_b32_e32 v10, s26
		s_nop 0
		v_readfirstlane_b32 s20, v10
		s_and_b32 s26, s20, s24
		v_readfirstlane_b32 s20, v9
		s_and_b32 s27, s20, s25
		v_cmp_lt_i32_e64 vcc, v8, s1
		s_mov_b64 s[32:33], vcc
		v_readfirstlane_b32 s20, v10
		s_and_b32 s34, s20, s32
		v_readfirstlane_b32 s20, v9
		s_and_b32 s35, s20, s33
		v_cmp_lt_i32_e64 vcc, v74, s1
		s_mov_b64 s[36:37], vcc
		v_readfirstlane_b32 s20, v10
		s_and_b32 s38, s20, s36
		v_readfirstlane_b32 s20, v9
		s_and_b32 s39, s20, s37
		v_cmp_lt_i32_e64 vcc, v75, s1
		s_mov_b64 s[40:41], vcc
		v_readfirstlane_b32 s1, v10
		s_and_b32 s42, s1, s40
		v_readfirstlane_b32 s1, v9
		s_and_b32 s43, s1, s41
		v_accvgpr_read_b32 v8, a12
		s_nop 0
		v_readfirstlane_b32 s44, v8
		v_accvgpr_read_b32 v8, a13
		s_nop 0
		v_readfirstlane_b32 s45, v8
		s_nop 1
		v_mov_b32_e32 v8, s45
		v_mov_b32_e32 v9, s44
		s_nop 0
		v_readfirstlane_b32 s1, v9
		s_and_b32 s44, s1, s24
		v_readfirstlane_b32 s1, v8
		s_and_b32 s45, s1, s25
		v_readfirstlane_b32 s1, v9
		s_and_b32 s24, s1, s32
		v_readfirstlane_b32 s1, v8
		s_and_b32 s25, s1, s33
		v_readfirstlane_b32 s1, v9
		s_and_b32 s32, s1, s36
		v_readfirstlane_b32 s1, v8
		s_and_b32 s33, s1, s37
		v_readfirstlane_b32 s1, v9
		s_and_b32 s36, s1, s40
		v_readfirstlane_b32 s1, v8
		s_and_b32 s37, s1, s41
		v_cvt_pk_bf16_f32 v8, v12, v13
		v_cvt_pk_bf16_f32 v9, v14, v15
		v_cvt_pk_bf16_f32 v10, v16, v17
		v_cvt_pk_bf16_f32 v11, v18, v19
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
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
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
		v_readfirstlane_b32 s1, v5
		s_mul_i32 s1, s1, s19
		s_lshl_b32 s1, s1, 9
		v_accvgpr_read_b32 v5, a2
		s_nop 0
		v_readfirstlane_b32 s20, v5
		v_readfirstlane_b32 s40, v3
		s_mul_i32 s20, s40, s20
		s_lshl_b32 s20, s20, 1
		s_add_i32 s40, s1, s20
		v_accvgpr_read_b32 v5, a3
		s_nop 0
		v_readfirstlane_b32 s41, v5
		v_readfirstlane_b32 s46, v4
		s_mul_i32 s41, s46, s41
		s_lshl_b32 s41, s41, 1
		s_add_i32 s40, s40, s41
		v_accvgpr_read_b32 v5, a8
		v_mul_lo_u32 v5, s19, v5
		v_lshl_add_u32 v6, v5, 7, s40
		v_accvgpr_read_b32 v7, a17
		v_mul_lo_u32 v7, s19, v7
		v_lshl_add_u32 v6, v7, 1, v6
		v_accvgpr_read_b32 v40, a14
		v_mul_lo_u32 v40, s19, v40
		v_lshl_add_u32 v6, v40, 6, v6
		v_accvgpr_read_b32 v41, a15
		v_mul_lo_u32 v41, s19, v41
		v_lshl_add_u32 v6, v41, 5, v6
		v_accvgpr_read_b32 v42, a16
		v_mul_lo_u32 v42, s19, v42
		v_lshl_add_u32 v6, v42, 4, v6
		v_accvgpr_read_b32 v43, a18
		v_mul_lo_u32 v43, s19, v43
		v_lshl_add_u32 v6, v43, 3, v6
		v_accvgpr_read_b32 v44, a19
		v_mul_lo_u32 v44, s19, v44
		v_lshlrev_b32_e32 v44, 2, v44
		v_accvgpr_read_b32 v45, a61
		v_add3_u32 v6, v6, v44, v45
		s_and_saveexec_b64 s[98:99], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_8
		buffer_store_dwordx4 v[8:11], v6, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_8:
		s_andn2_b64 exec, s[98:99], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_8
.L_attn_fwd_persistent.exec_endif_8:
		s_mov_b64 exec, s[98:99]
		s_add_i32 s26, s1, 32
		s_add_i32 s26, s26, s20
		s_add_i32 s26, s26, s41
		v_lshl_add_u32 v6, v5, 7, s26
		v_lshl_add_u32 v6, v7, 1, v6
		v_lshl_add_u32 v6, v40, 6, v6
		v_lshl_add_u32 v6, v41, 5, v6
		v_lshl_add_u32 v6, v42, 4, v6
		v_lshl_add_u32 v6, v43, 3, v6
		v_accvgpr_read_b32 v8, a61
		v_add3_u32 v6, v6, v44, v8
		s_and_saveexec_b64 s[98:99], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_9
		buffer_store_dwordx4 v[12:15], v6, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_9:
		s_andn2_b64 exec, s[98:99], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_9
.L_attn_fwd_persistent.exec_endif_9:
		s_mov_b64 exec, s[98:99]
		s_add_i32 s27, s1, 64
		s_add_i32 s27, s27, s20
		s_add_i32 s27, s27, s41
		v_lshl_add_u32 v6, v5, 7, s27
		v_lshl_add_u32 v6, v7, 1, v6
		v_lshl_add_u32 v6, v40, 6, v6
		v_lshl_add_u32 v6, v41, 5, v6
		v_lshl_add_u32 v6, v42, 4, v6
		v_lshl_add_u32 v6, v43, 3, v6
		v_accvgpr_read_b32 v8, a61
		v_add3_u32 v6, v6, v44, v8
		s_and_saveexec_b64 s[98:99], s[38:39]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_10
		buffer_store_dwordx4 v[16:19], v6, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_10:
		s_andn2_b64 exec, s[98:99], s[38:39]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_10
.L_attn_fwd_persistent.exec_endif_10:
		s_mov_b64 exec, s[98:99]
		s_add_i32 s1, s1, 0x60
		s_add_i32 s1, s1, s20
		s_add_i32 s1, s1, s41
		v_lshl_add_u32 v5, v5, 7, s1
		v_lshl_add_u32 v5, v7, 1, v5
		v_lshl_add_u32 v5, v40, 6, v5
		v_lshl_add_u32 v5, v41, 5, v5
		v_lshl_add_u32 v5, v42, 4, v5
		v_lshl_add_u32 v5, v43, 3, v5
		v_accvgpr_read_b32 v6, a61
		v_add3_u32 v5, v5, v44, v6
		s_and_saveexec_b64 s[98:99], s[42:43]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_11
		buffer_store_dwordx4 v[20:23], v5, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_11:
		s_andn2_b64 exec, s[98:99], s[42:43]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_11
.L_attn_fwd_persistent.exec_endif_11:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v5, a8
		v_lshlrev_b32_e32 v5, 6, v5
		v_accvgpr_read_b32 v6, a14
		v_lshlrev_b32_e32 v6, 5, v6
		v_accvgpr_read_b32 v7, a15
		v_lshlrev_b32_e32 v7, 4, v7
		v_accvgpr_read_b32 v8, a16
		v_lshlrev_b32_e32 v8, 3, v8
		v_accvgpr_read_b32 v9, a18
		v_lshlrev_b32_e32 v9, 2, v9
		v_accvgpr_read_b32 v10, a17
		v_add_u32_e32 v10, 0x80, v10
		v_accvgpr_read_b32 v11, a19
		v_lshlrev_b32_e32 v11, 1, v11
		v_bitop3_b32 v9, v9, v10, v11 bitop3:0x96
		v_bitop3_b32 v7, v7, v8, v9 bitop3:0x96
		v_bitop3_b32 v5, v5, v6, v7 bitop3:0x96
		v_mul_lo_u32 v5, s19, v5
		v_lshlrev_b32_e32 v5, 1, v5
		v_accvgpr_read_b32 v6, a61
		v_add3_u32 v6, s40, v5, v6
		s_and_saveexec_b64 s[98:99], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_12
		buffer_store_dwordx4 v[24:27], v6, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_12:
		s_andn2_b64 exec, s[98:99], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_12
.L_attn_fwd_persistent.exec_endif_12:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v6, a61
		v_add3_u32 v6, s26, v5, v6
		s_and_saveexec_b64 s[98:99], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_13
		buffer_store_dwordx4 v[28:31], v6, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_13:
		s_andn2_b64 exec, s[98:99], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_13
.L_attn_fwd_persistent.exec_endif_13:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v6, a61
		v_add3_u32 v6, s27, v5, v6
		s_and_saveexec_b64 s[98:99], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_14
		buffer_store_dwordx4 v[32:35], v6, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_14:
		s_andn2_b64 exec, s[98:99], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_14
.L_attn_fwd_persistent.exec_endif_14:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v6, a61
		v_add3_u32 v5, s1, v5, v6
		s_and_saveexec_b64 s[98:99], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_15
		buffer_store_dwordx4 v[36:39], v5, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_15:
		s_andn2_b64 exec, s[98:99], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_15
.L_attn_fwd_persistent.exec_endif_15:
		s_mov_b64 exec, s[98:99]
		s_branch .L_attn_fwd_persistent.if_end_1
.L_attn_fwd_persistent.if_else_1:
.L_attn_fwd_persistent.if_end_1:
		s_and_b32 s1, s0, 15
		s_mul_i32 s1, s1, 2
		s_add_i32 s1, s1, 1
		s_cmp_lt_i32 s1, 32
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_3
		s_lshr_b32 s20, s1, 1
		s_and_b32 s1, s1, 1
		s_xor_b32 s24, s20, -1
		s_add_i32 s24, s24, 1
		s_add_i32 s24, s24, 31
		s_cmp_eq_u32 s1, 0
		s_cselect_b32 s1, s20, s24
		s_mul_i32 s20, s1, 0x100
		v_and_b32_e32 v5, 1, v0
		v_lshrrev_b32_e32 v6, 1, v0
		v_and_b32_e32 v7, 1, v6
		v_mov_b32_e32 v8, 2
		v_mul_lo_u32 v8, v8, v7
		v_lshrrev_b32_e32 v7, 2, v0
		v_and_b32_e32 v9, 1, v7
		v_mov_b32_e32 v10, 4
		v_mul_lo_u32 v10, v10, v9
		v_bitop3_b32 v9, v5, v8, v10 bitop3:0x96
		v_lshrrev_b32_e32 v11, 3, v0
		v_and_b32_e32 v12, 1, v11
		v_mov_b32_e32 v13, 8
		v_mul_lo_u32 v13, v13, v12
		v_xor_b32_e32 v9, v9, v13
		v_lshrrev_b32_e32 v14, 4, v0
		v_and_b32_e32 v15, 1, v14
		v_mov_b32_e32 v16, 16
		v_mul_lo_u32 v16, v16, v15
		v_lshrrev_b32_e32 v17, 6, v0
		v_and_b32_e32 v18, 1, v17
		v_mov_b32_e32 v19, 32
		v_mul_lo_u32 v19, v19, v18
		v_bitop3_b32 v9, v9, v16, v19 bitop3:0x96
		v_lshrrev_b32_e32 v20, 7, v0
		v_accvgpr_write_b32 a8, v20
		v_accvgpr_read_b32 v20, a8
		v_and_b32_e32 v20, 1, v20
		v_mov_b32_e32 v21, 64
		v_mul_lo_u32 v21, v21, v20
		v_xor_b32_e32 v9, v9, v21
		v_accvgpr_write_b32 a9, v9
		v_accvgpr_read_b32 v9, a9
		v_add_u32_e32 v9, s20, v9
		v_xor_b32_e32 v5, 0x80, v5
		v_xor_b32_e32 v5, v5, v8
		v_xor_b32_e32 v5, v5, v10
		v_bitop3_b32 v5, v5, v13, v16 bitop3:0x96
		v_bitop3_b32 v5, v5, v19, v21 bitop3:0x96
		v_accvgpr_write_b32 a10, v5
		v_accvgpr_read_b32 v5, a10
		v_add_u32_e32 v5, s20, v5
		v_cmp_lt_i32_e64 vcc, v9, s21
		s_mov_b64 s[24:25], vcc
		v_cmp_lt_i32_e64 vcc, v5, s21
		s_mov_b64 s[26:27], vcc
		v_mov_b32_e32 v5, 2
		v_mul_lo_u32 v5, v5, v15
		v_lshrrev_b32_e32 v8, 5, v0
		v_and_b32_e32 v9, 1, v8
		v_accvgpr_write_b32 a11, v9
		v_accvgpr_read_b32 v9, a11
		v_mov_b32_e32 v10, 4
		v_mul_lo_u32 v10, v10, v9
		v_bitop3_b32 v9, v12, v5, v10 bitop3:0x96
		v_mov_b32_e32 v13, 8
		v_mul_lo_u32 v13, v13, v18
		v_xor_b32_e32 v9, v9, v13
		v_mov_b32_e32 v16, 16
		v_mul_lo_u32 v16, v16, v20
		v_xad_u32 v9, v9, v16, s20
		v_bitop3_b32 v19, 32, v12, v5 bitop3:0x96
		v_bitop3_b32 v19, v19, v10, v13 bitop3:0x96
		v_xad_u32 v19, v19, v16, s20
		v_bitop3_b32 v21, 64, v12, v5 bitop3:0x96
		v_bitop3_b32 v21, v21, v10, v13 bitop3:0x96
		v_xad_u32 v21, v21, v16, s20
		v_xor_b32_e32 v22, 0x60, v12
		v_xor_b32_e32 v22, v22, v5
		v_xor_b32_e32 v22, v22, v10
		v_xor_b32_e32 v22, v22, v13
		v_xad_u32 v22, v22, v16, s20
		v_xor_b32_e32 v23, 0x80, v12
		v_xor_b32_e32 v23, v23, v5
		v_xor_b32_e32 v23, v23, v10
		v_xor_b32_e32 v23, v23, v13
		v_xad_u32 v23, v23, v16, s20
		v_xor_b32_e32 v24, 0xa0, v12
		v_xor_b32_e32 v24, v24, v5
		v_xor_b32_e32 v24, v24, v10
		v_xor_b32_e32 v24, v24, v13
		v_xad_u32 v24, v24, v16, s20
		v_xor_b32_e32 v25, 0xc0, v12
		v_xor_b32_e32 v25, v25, v5
		v_xor_b32_e32 v25, v25, v10
		v_xor_b32_e32 v25, v25, v13
		v_xad_u32 v25, v25, v16, s20
		v_xor_b32_e32 v26, 0xe0, v12
		v_xor_b32_e32 v5, v26, v5
		v_xor_b32_e32 v5, v5, v10
		v_xor_b32_e32 v5, v5, v13
		v_xad_u32 v5, v5, v16, s20
		s_mov_b32 s30, 0x7fffffff
		s_mov_b32 s31, 0x31016000
		s_mov_b32 s28, s2
		s_mov_b32 s29, s3
		v_accvgpr_read_b32 v13, a4
		v_and_b32_e32 v13, 0xffff, v13
		v_lshlrev_b32_e32 v16, 16, v13
		v_or_b32_e32 v28, v13, v16
		v_mov_b32_e32 v29, v28
		v_mov_b32_e32 v30, v28
		v_mov_b32_e32 v31, v28
		s_mul_i32 s32, s1, s12
		s_lshl_b32 s32, s32, 9
		v_readfirstlane_b32 s33, v3
		s_mul_i32 s33, s33, s10
		s_lshl_b32 s33, s33, 1
		s_add_i32 s32, s32, s33
		v_readfirstlane_b32 s33, v4
		s_mul_i32 s33, s33, s11
		s_lshl_b32 s33, s33, 1
		s_add_i32 s32, s32, s33
		v_accvgpr_read_b32 v13, a8
		v_mul_lo_u32 v13, s12, v13
		v_lshl_add_u32 v13, v13, 5, s32
		v_and_b32_e32 v16, 1, v17
		v_accvgpr_write_b32 a12, v16
		v_accvgpr_read_b32 v16, a12
		v_mul_lo_u32 v16, s12, v16
		v_lshl_add_u32 v13, v16, 4, v13
		v_and_b32_e32 v8, 1, v8
		v_mul_lo_u32 v16, s12, v8
		v_lshl_add_u32 v13, v16, 3, v13
		v_and_b32_e32 v14, 1, v14
		v_accvgpr_write_b32 a13, v14
		v_accvgpr_read_b32 v14, a13
		v_mul_lo_u32 v14, s12, v14
		v_lshl_add_u32 v13, v14, 2, v13
		v_and_b32_e32 v11, 1, v11
		v_accvgpr_write_b32 a14, v11
		v_accvgpr_read_b32 v11, a14
		v_mul_lo_u32 v11, s12, v11
		v_lshl_add_u32 v11, v11, 1, v13
		v_and_b32_e32 v13, 1, v0
		v_accvgpr_write_b32 a15, v13
		v_accvgpr_read_b32 v13, a15
		v_lshl_add_u32 v11, v13, 4, v11
		v_and_b32_e32 v13, 1, v7
		v_accvgpr_write_b32 a16, v13
		v_accvgpr_read_b32 v13, a16
		v_lshl_add_u32 v11, v13, 6, v11
		v_and_b32_e32 v6, 1, v6
		v_accvgpr_write_b32 a17, v6
		v_accvgpr_read_b32 v6, a17
		v_lshl_add_u32 v6, v6, 5, v11
		v_cmp_lt_i32_e64 vcc, v9, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_16
		buffer_load_dwordx4 v[32:35], v6, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_16:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_16
		v_mov_b32_e32 v32, v28
		v_mov_b32_e32 v33, v29
		v_mov_b32_e32 v34, v30
		v_mov_b32_e32 v35, v31
.L_attn_fwd_persistent.exec_endif_16:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v6, a8
		v_lshlrev_b32_e32 v6, 4, v6
		v_accvgpr_read_b32 v9, a12
		v_lshlrev_b32_e32 v9, 3, v9
		v_lshlrev_b32_e32 v11, 2, v8
		v_accvgpr_read_b32 v13, a14
		v_add_u32_e32 v13, 32, v13
		v_accvgpr_read_b32 v14, a13
		v_lshlrev_b32_e32 v14, 1, v14
		v_bitop3_b32 v13, v11, v13, v14 bitop3:0x96
		v_bitop3_b32 v13, v6, v9, v13 bitop3:0x96
		v_mul_lo_u32 v13, s12, v13
		v_lshl_add_u32 v13, v13, 1, s32
		v_accvgpr_read_b32 v16, a15
		v_lshl_add_u32 v13, v16, 4, v13
		v_accvgpr_read_b32 v16, a16
		v_lshl_add_u32 v13, v16, 6, v13
		v_accvgpr_read_b32 v16, a17
		v_lshl_add_u32 v13, v16, 5, v13
		v_cmp_lt_i32_e64 vcc, v19, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_17
		buffer_load_dwordx4 v[36:39], v13, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_17:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_17
		v_mov_b32_e32 v36, v28
		v_mov_b32_e32 v37, v29
		v_mov_b32_e32 v38, v30
		v_mov_b32_e32 v39, v31
.L_attn_fwd_persistent.exec_endif_17:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v13, a14
		v_add_u32_e32 v13, 64, v13
		v_bitop3_b32 v13, v11, v13, v14 bitop3:0x96
		v_bitop3_b32 v13, v6, v9, v13 bitop3:0x96
		v_mul_lo_u32 v13, s12, v13
		v_lshl_add_u32 v13, v13, 1, s32
		v_accvgpr_read_b32 v16, a15
		v_lshl_add_u32 v13, v16, 4, v13
		v_accvgpr_read_b32 v16, a16
		v_lshl_add_u32 v13, v16, 6, v13
		v_accvgpr_read_b32 v16, a17
		v_lshl_add_u32 v13, v16, 5, v13
		v_cmp_lt_i32_e64 vcc, v21, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_18
		buffer_load_dwordx4 v[40:43], v13, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_18:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_18
		v_mov_b32_e32 v40, v28
		v_mov_b32_e32 v41, v29
		v_mov_b32_e32 v42, v30
		v_mov_b32_e32 v43, v31
.L_attn_fwd_persistent.exec_endif_18:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v13, a14
		v_add_u32_e32 v13, 0x60, v13
		v_bitop3_b32 v13, v11, v13, v14 bitop3:0x96
		v_bitop3_b32 v13, v6, v9, v13 bitop3:0x96
		v_mul_lo_u32 v13, s12, v13
		v_lshl_add_u32 v13, v13, 1, s32
		v_accvgpr_read_b32 v16, a15
		v_lshl_add_u32 v13, v16, 4, v13
		v_accvgpr_read_b32 v16, a16
		v_lshl_add_u32 v13, v16, 6, v13
		v_accvgpr_read_b32 v16, a17
		v_lshl_add_u32 v13, v16, 5, v13
		v_cmp_lt_i32_e64 vcc, v22, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_19
		buffer_load_dwordx4 v[44:47], v13, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_19:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_19
		v_mov_b32_e32 v44, v28
		v_mov_b32_e32 v45, v29
		v_mov_b32_e32 v46, v30
		v_mov_b32_e32 v47, v31
.L_attn_fwd_persistent.exec_endif_19:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v13, a14
		v_add_u32_e32 v13, 0x80, v13
		v_bitop3_b32 v13, v11, v13, v14 bitop3:0x96
		v_bitop3_b32 v13, v6, v9, v13 bitop3:0x96
		v_mul_lo_u32 v13, s12, v13
		v_lshl_add_u32 v13, v13, 1, s32
		v_accvgpr_read_b32 v16, a15
		v_lshl_add_u32 v13, v16, 4, v13
		v_accvgpr_read_b32 v16, a16
		v_lshl_add_u32 v13, v16, 6, v13
		v_accvgpr_read_b32 v16, a17
		v_lshl_add_u32 v13, v16, 5, v13
		v_cmp_lt_i32_e64 vcc, v23, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_20
		buffer_load_dwordx4 v[48:51], v13, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_20:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_20
		v_mov_b32_e32 v48, v28
		v_mov_b32_e32 v49, v29
		v_mov_b32_e32 v50, v30
		v_mov_b32_e32 v51, v31
.L_attn_fwd_persistent.exec_endif_20:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v13, a14
		v_add_u32_e32 v13, 0xa0, v13
		v_bitop3_b32 v13, v11, v13, v14 bitop3:0x96
		v_bitop3_b32 v13, v6, v9, v13 bitop3:0x96
		v_mul_lo_u32 v13, s12, v13
		v_lshl_add_u32 v13, v13, 1, s32
		v_accvgpr_read_b32 v16, a15
		v_lshl_add_u32 v13, v16, 4, v13
		v_accvgpr_read_b32 v16, a16
		v_lshl_add_u32 v13, v16, 6, v13
		v_accvgpr_read_b32 v16, a17
		v_lshl_add_u32 v13, v16, 5, v13
		v_cmp_lt_i32_e64 vcc, v24, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_21
		buffer_load_dwordx4 v[52:55], v13, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_21:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_21
		v_mov_b32_e32 v52, v28
		v_mov_b32_e32 v53, v29
		v_mov_b32_e32 v54, v30
		v_mov_b32_e32 v55, v31
.L_attn_fwd_persistent.exec_endif_21:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v13, a14
		v_add_u32_e32 v13, 0xc0, v13
		v_bitop3_b32 v13, v11, v13, v14 bitop3:0x96
		v_bitop3_b32 v13, v6, v9, v13 bitop3:0x96
		v_mul_lo_u32 v13, s12, v13
		v_lshl_add_u32 v13, v13, 1, s32
		v_accvgpr_read_b32 v16, a15
		v_lshl_add_u32 v13, v16, 4, v13
		v_accvgpr_read_b32 v16, a16
		v_lshl_add_u32 v13, v16, 6, v13
		v_accvgpr_read_b32 v16, a17
		v_lshl_add_u32 v13, v16, 5, v13
		v_cmp_lt_i32_e64 vcc, v25, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_22
		buffer_load_dwordx4 v[24:27], v13, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_22:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_22
		v_mov_b32_e32 v24, v28
		v_mov_b32_e32 v25, v29
		v_mov_b32_e32 v26, v30
		v_mov_b32_e32 v27, v31
.L_attn_fwd_persistent.exec_endif_22:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v13, a14
		v_add_u32_e32 v13, 0xe0, v13
		v_bitop3_b32 v11, v11, v13, v14 bitop3:0x96
		v_bitop3_b32 v9, v6, v9, v11 bitop3:0x96
		v_mul_lo_u32 v9, s12, v9
		v_lshl_add_u32 v9, v9, 1, s32
		v_accvgpr_read_b32 v11, a15
		v_lshl_add_u32 v9, v11, 4, v9
		v_accvgpr_read_b32 v11, a16
		v_lshl_add_u32 v9, v11, 6, v9
		v_accvgpr_read_b32 v11, a17
		v_lshl_add_u32 v9, v11, 5, v9
		v_cmp_lt_i32_e64 vcc, v5, s21
		s_and_saveexec_b64 s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_23
		buffer_load_dwordx4 v[56:59], v9, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_23:
		s_andn2_b64 exec, s[98:99], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_23
		v_mov_b32_e32 v56, v28
		v_mov_b32_e32 v57, v29
		v_mov_b32_e32 v58, v30
		v_mov_b32_e32 v59, v31
.L_attn_fwd_persistent.exec_endif_23:
		s_mov_b64 exec, s[98:99]
		s_mov_b32 s32, s4
		s_mov_b32 s33, s5
		s_mov_b32 s34, s30
		s_mov_b32 s35, s31
		s_mov_b32 s36, s6
		s_mov_b32 s37, s7
		s_mov_b32 s38, s30
		s_mov_b32 s39, s31
		s_waitcnt vmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v5, a12
		v_lshlrev_b32_e32 v5, 2, v5
		v_lshlrev_b32_e32 v9, 1, v8
		v_accvgpr_read_b32 v11, a13
		v_xor_b32_e32 v11, v0, v11
		v_bitop3_b32 v5, v5, v9, v11 bitop3:0x96
		v_lshlrev_b32_e32 v5, 4, v5
		v_add_u32_e32 v5, 0x10000, v5
		ds_write_b128 v5, v[32:35] offset:18864
		ds_write_b128 v5, v[36:39] offset:22960
		ds_write_b128 v5, v[40:43] offset:27056
		ds_write_b128 v5, v[44:47] offset:31152
		v_lshlrev_b32_e32 v9, 12, v17
		v_add_u32_e32 v9, 0x10000, v9
		v_and_b32_e32 v11, 63, v0
		v_lshrrev_b32_e32 v13, 2, v11
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_and_b32_e32 v13, 1, v13
		v_lshlrev_b32_e32 v13, 5, v13
		v_lshrrev_b32_e32 v14, 1, v11
		v_and_b32_e32 v14, 1, v14
		v_lshlrev_b32_e32 v14, 4, v14
		v_and_b32_e32 v16, 1, v11
		v_lshlrev_b32_e32 v16, 3, v16
		v_add3_u32 v17, v13, v14, v16
		v_lshrrev_b32_e32 v19, 5, v11
		v_accvgpr_write_b32 a18, v19
		v_accvgpr_read_b32 v19, a18
		v_xor_b32_e32 v17, v17, v19
		v_lshrrev_b32_e32 v19, 6, v17
		v_lshrrev_b32_e32 v21, 3, v11
		v_and_b32_e32 v21, 1, v21
		v_add_u32_e32 v19, v19, v21
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 2, v19
		v_lshrrev_b32_e32 v22, 5, v17
		v_and_b32_e32 v22, 1, v22
		v_lshlrev_b32_e32 v22, 1, v22
		v_lshrrev_b32_e32 v23, 4, v11
		v_and_b32_e32 v23, 1, v23
		v_lshlrev_b32_e32 v28, 6, v21
		v_lshl_add_u32 v23, v23, 7, v28
		v_add_u32_e32 v28, v23, v17
		v_lshrrev_b32_e32 v17, 4, v17
		v_bitop3_b32 v17, v28, v17, 1 bitop3:0x78
		v_bitop3_b32 v17, v19, v22, v17 bitop3:0x96
		v_lshl_add_u32 v19, v17, 4, v9
		ds_read_b128 a[20:23], v19 offset:18864
		v_add_u32_e32 v19, 2, v13
		v_add3_u32 v19, v19, v14, v16
		v_accvgpr_read_b32 v22, a18
		v_xor_b32_e32 v19, v19, v22
		v_lshrrev_b32_e32 v22, 6, v19
		v_add_u32_e32 v22, v22, v21
		v_and_b32_e32 v22, 1, v22
		v_lshlrev_b32_e32 v22, 2, v22
		v_lshrrev_b32_e32 v28, 5, v19
		v_and_b32_e32 v28, 1, v28
		v_lshlrev_b32_e32 v28, 1, v28
		v_add_u32_e32 v29, v23, v19
		v_lshrrev_b32_e32 v19, 4, v19
		v_bitop3_b32 v19, v29, v19, 1 bitop3:0x78
		v_bitop3_b32 v19, v22, v28, v19 bitop3:0x96
		v_lshl_add_u32 v22, v19, 4, v9
		ds_read_b128 a[24:27], v22 offset:18864
		v_add_u32_e32 v22, 4, v13
		v_add3_u32 v22, v22, v14, v16
		v_accvgpr_read_b32 v28, a18
		v_xor_b32_e32 v22, v22, v28
		v_lshrrev_b32_e32 v28, 6, v22
		v_add_u32_e32 v28, v28, v21
		v_and_b32_e32 v28, 1, v28
		v_lshlrev_b32_e32 v28, 2, v28
		v_lshrrev_b32_e32 v29, 5, v22
		v_and_b32_e32 v29, 1, v29
		v_lshlrev_b32_e32 v29, 1, v29
		v_add_u32_e32 v30, v23, v22
		v_lshrrev_b32_e32 v22, 4, v22
		v_bitop3_b32 v22, v30, v22, 1 bitop3:0x78
		v_bitop3_b32 v22, v28, v29, v22 bitop3:0x96
		v_lshl_add_u32 v28, v22, 4, v9
		ds_read_b128 a[28:31], v28 offset:18864
		v_add_u32_e32 v13, 6, v13
		v_add3_u32 v13, v13, v14, v16
		v_accvgpr_read_b32 v14, a18
		v_xor_b32_e32 v13, v13, v14
		v_lshrrev_b32_e32 v14, 6, v13
		v_add_u32_e32 v14, v14, v21
		v_and_b32_e32 v14, 1, v14
		v_lshlrev_b32_e32 v14, 2, v14
		v_lshrrev_b32_e32 v16, 5, v13
		v_and_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v16, 1, v16
		v_add_u32_e32 v21, v23, v13
		v_lshrrev_b32_e32 v13, 4, v13
		v_bitop3_b32 v13, v21, v13, 1 bitop3:0x78
		v_bitop3_b32 v13, v14, v16, v13 bitop3:0x96
		v_lshl_add_u32 v9, v13, 4, v9
		ds_read_b128 a[32:35], v9 offset:18864
		v_accvgpr_read_b32 v9, a12
		v_lshl_add_u32 v9, v9, 3, 32
		v_xor_b32_e32 v6, v9, v6
		v_lshrrev_b32_e32 v9, 5, v6
		v_and_b32_e32 v9, 1, v9
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v5, v[48:51] offset:18864
		ds_write_b128 v5, v[52:55] offset:22960
		ds_write_b128 v5, v[24:27] offset:27056
		ds_write_b128 v5, v[56:59] offset:31152
		v_lshlrev_b32_e32 v5, 14, v9
		v_add_u32_e32 v5, 0x10000, v5
		v_lshrrev_b32_e32 v9, 4, v6
		v_and_b32_e32 v9, 1, v9
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshl_add_u32 v5, v9, 13, v5
		v_lshrrev_b32_e32 v6, 3, v6
		v_and_b32_e32 v6, 1, v6
		v_lshl_add_u32 v5, v6, 12, v5
		v_lshl_add_u32 v6, v17, 4, v5
		ds_read_b128 a[36:39], v6 offset:2480
		v_lshl_add_u32 v6, v19, 4, v5
		ds_read_b128 a[40:43], v6 offset:2480
		v_lshl_add_u32 v6, v22, 4, v5
		ds_read_b128 a[44:47], v6 offset:2480
		v_lshl_add_u32 v5, v13, 4, v5
		ds_read_b128 a[48:51], v5 offset:2480
		s_add_i32 s28, s1, 1
		s_mul_i32 s28, s28, 0x100
		v_mov_b32_e32 v5, s23
		s_nop 0
		v_readfirstlane_b32 s29, v5
		s_add_i32 s28, s28, s29
		s_cmp_lt_i32 s22, s28
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_cselect_b32 s28, s22, s28
		s_add_i32 s29, s28, 0x7f
		s_mov_b32 s40, 0x7f
		s_cmp_lt_i32 s29, 0
		s_cselect_b32 s41, s40, 0
		s_add_i32 s29, s29, s41
		s_ashr_i32 s29, s29, 7
		v_readfirstlane_b32 s41, v5
		s_add_i32 s41, s20, s41
		s_cmp_lt_i32 s41, 0
		s_cselect_b32 s42, s40, 0
		s_add_i32 s41, s41, s42
		s_ashr_i32 s41, s41, 7
		s_cmp_lt_i32 s41, s29
		s_cselect_b32 s41, s41, s29
		s_cmp_gt_i32 s41, 0
		s_cselect_b32 s41, s41, 0
		v_mov_b32_e32 v6, 64
		v_mul_lo_u32 v6, v6, v12
		v_mov_b32_e32 v9, 32
		v_mul_lo_u32 v9, v9, v15
		v_accvgpr_read_b32 v13, a11
		v_mov_b32_e32 v14, 16
		v_mul_lo_u32 v14, v14, v13
		v_bitop3_b32 v13, v6, v9, v14 bitop3:0x96
		v_mov_b32_e32 v15, 2
		v_mul_lo_u32 v15, v15, v20
		v_bitop3_b32 v13, v13, v18, v15 bitop3:0x96
		v_accvgpr_write_b32 a19, v13
		v_bitop3_b32 v13, 4, v6, v9 bitop3:0x96
		v_xor_b32_e32 v13, v13, v14
		v_bitop3_b32 v13, v13, v18, v15 bitop3:0x96
		v_accvgpr_write_b32 a52, v13
		v_bitop3_b32 v13, 8, v6, v9 bitop3:0x96
		v_xor_b32_e32 v13, v13, v14
		v_bitop3_b32 v13, v13, v18, v15 bitop3:0x96
		v_accvgpr_write_b32 a53, v13
		v_bitop3_b32 v6, 12, v6, v9 bitop3:0x96
		v_xor_b32_e32 v6, v6, v14
		v_bitop3_b32 v6, v6, v18, v15 bitop3:0x96
		v_accvgpr_write_b32 a54, v6
		v_accvgpr_read_b32 v6, a19
		v_cmp_lt_i32_e64 vcc, v6, s22
		s_mov_b64 s[42:43], vcc
		v_accvgpr_read_b32 v6, a52
		v_cmp_lt_i32_e64 vcc, v6, s22
		s_mov_b64 s[44:45], vcc
		v_accvgpr_read_b32 v6, a53
		v_cmp_lt_i32_e64 vcc, v6, s22
		s_mov_b64 s[46:47], vcc
		v_accvgpr_read_b32 v6, a54
		v_cmp_lt_i32_e64 vcc, v6, s22
		s_mov_b64 s[48:49], vcc
		v_mov_b32_e32 v6, 16
		v_mul_lo_u32 v6, v6, v12
		v_accvgpr_read_b32 v12, a11
		v_mov_b32_e32 v13, 64
		v_mul_lo_u32 v13, v13, v12
		v_bitop3_b32 v12, v6, v9, v13 bitop3:0x96
		v_bitop3_b32 v12, v12, v18, v15 bitop3:0x96
		v_accvgpr_write_b32 a55, v12
		v_bitop3_b32 v12, 4, v6, v9 bitop3:0x96
		v_xor_b32_e32 v12, v12, v13
		v_bitop3_b32 v12, v12, v18, v15 bitop3:0x96
		v_accvgpr_write_b32 a56, v12
		v_bitop3_b32 v12, 8, v6, v9 bitop3:0x96
		v_xor_b32_e32 v12, v12, v13
		v_bitop3_b32 v12, v12, v18, v15 bitop3:0x96
		v_accvgpr_write_b32 a57, v12
		v_bitop3_b32 v6, 12, v6, v9 bitop3:0x96
		v_accvgpr_read_b32 v9, a55
		v_cmp_lt_i32_e64 vcc, v9, s22
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v9, a56
		v_cmp_lt_i32_e64 vcc, v9, s22
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v9, a57
		v_cmp_lt_i32_e64 vcc, v9, s22
		s_mov_b64 s[54:55], vcc
		v_readfirstlane_b32 s56, v0
		v_accvgpr_read_b32 v9, a8
		v_lshlrev_b32_e32 v9, 1, v9
		v_accvgpr_read_b32 v12, a13
		v_lshlrev_b32_e32 v12, 5, v12
		v_accvgpr_write_b32 a58, v12
		v_accvgpr_read_b32 v12, a14
		v_accvgpr_read_b32 v14, a58
		v_lshl_add_u32 v12, v12, 6, v14
		v_lshlrev_b32_e32 v14, 4, v8
		v_accvgpr_write_b32 a59, v14
		v_accvgpr_read_b32 v14, a59
		v_xor_b32_e32 v12, v12, v14
		v_accvgpr_read_b32 v14, a12
		v_bitop3_b32 v12, v9, v14, v12 bitop3:0x96
		v_mul_lo_u32 v14, s15, v12
		v_accvgpr_read_b32 v16, a15
		v_lshlrev_b32_e32 v16, 4, v16
		v_lshl_add_u32 v14, v14, 1, v16
		v_accvgpr_read_b32 v17, a16
		v_lshlrev_b32_e32 v17, 6, v17
		v_accvgpr_read_b32 v19, a17
		v_lshlrev_b32_e32 v19, 5, v19
		v_add3_u32 v14, v14, v17, v19
		v_accvgpr_write_b32 a60, v14
		v_readfirstlane_b32 s57, v3
		s_mul_i32 s57, s57, s13
		s_lshl_b32 s57, s57, 1
		v_readfirstlane_b32 s58, v4
		s_mul_i32 s58, s58, s14
		s_lshl_b32 s58, s58, 1
		s_add_i32 s59, s57, s58
		v_accvgpr_read_b32 v14, a60
		v_add_u32_e32 v14, s59, v14
		v_mov_b32_e32 v20, 0x80000000
		v_cndmask_b32_e64 v14, v20, v14, s[42:43]
		s_lshr_b32 s42, s56, 6
		s_mul_i32 s43, 0x410, s42
		s_mov_b32 m0, s43
		v_xor_b32_e32 v6, v6, v13
		buffer_load_dwordx4 v14, s[32:35], 0 offen lds
		v_bitop3_b32 v6, v6, v18, v15 bitop3:0x96
		v_accvgpr_write_b32 a61, v6
		v_xor_b32_e32 v6, 4, v12
		v_mul_lo_u32 v13, s15, v6
		v_lshl_add_u32 v13, v13, 1, v16
		v_add3_u32 v13, v13, v17, v19
		v_accvgpr_write_b32 a62, v13
		v_accvgpr_read_b32 v13, a62
		v_add_u32_e32 v13, s59, v13
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v13, v20, v13, s[44:45]
		buffer_load_dwordx4 v13, s[32:35], 0 offen lds
		v_xor_b32_e32 v12, 8, v12
		v_mul_lo_u32 v12, s15, v12
		v_lshl_add_u32 v12, v12, 1, v16
		v_add3_u32 v12, v12, v17, v19
		v_add_u32_e32 v13, s59, v12
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v13, v20, v13, s[46:47]
		buffer_load_dwordx4 v13, s[32:35], 0 offen lds
		v_xor_b32_e32 v6, 8, v6
		v_mul_lo_u32 v6, s15, v6
		v_lshl_add_u32 v6, v6, 1, v16
		v_add3_u32 v6, v6, v17, v19
		v_add_u32_e32 v13, s59, v6
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v13, v20, v13, s[48:49]
		buffer_load_dwordx4 v13, s[32:35], 0 offen lds
		v_accvgpr_read_b32 v13, a58
		v_lshl_add_u32 v13, v8, 6, v13
		v_accvgpr_read_b32 v14, a14
		v_lshl_add_u32 v13, v14, 4, v13
		v_accvgpr_read_b32 v14, a12
		v_bitop3_b32 v9, v9, v13, v14 bitop3:0x96
		v_mul_lo_u32 v13, s18, v9
		v_lshl_add_u32 v13, v13, 1, v16
		v_add3_u32 v13, v13, v17, v19
		v_accvgpr_read_b32 v14, a0
		s_nop 0
		v_readfirstlane_b32 s44, v14
		v_readfirstlane_b32 s45, v3
		s_mul_i32 s44, s45, s44
		s_lshl_b32 s44, s44, 1
		v_accvgpr_read_b32 v3, a1
		s_nop 0
		v_readfirstlane_b32 s45, v3
		v_readfirstlane_b32 s46, v4
		s_mul_i32 s45, s46, s45
		s_lshl_b32 s45, s45, 1
		s_add_i32 s46, s44, s45
		v_add_u32_e32 v3, s46, v13
		s_mul_i32 s42, 0x440, s42
		s_add_i32 m0, s42, 0x81f0
		v_cndmask_b32_e64 v3, v20, v3, s[50:51]
		buffer_load_dwordx4 v3, s[36:39], 0 offen lds
		v_xor_b32_e32 v3, 4, v9
		v_mul_lo_u32 v4, s18, v3
		v_lshl_add_u32 v4, v4, 1, v16
		v_add3_u32 v4, v4, v17, v19
		v_add_u32_e32 v14, s46, v4
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v14, v20, v14, s[52:53]
		buffer_load_dwordx4 v14, s[36:39], 0 offen lds
		v_xor_b32_e32 v9, 8, v9
		v_mul_lo_u32 v9, s18, v9
		v_lshl_add_u32 v9, v9, 1, v16
		v_add3_u32 v9, v9, v17, v19
		v_add_u32_e32 v14, s46, v9
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v14, v20, v14, s[54:55]
		buffer_load_dwordx4 v14, s[36:39], 0 offen lds
		v_xor_b32_e32 v3, 8, v3
		v_mul_lo_u32 v3, s18, v3
		v_lshl_add_u32 v3, v3, 1, v16
		v_add3_u32 v3, v3, v17, v19
		v_accvgpr_read_b32 v14, a61
		v_cmp_lt_i32_e64 vcc, v14, s22
		v_add_u32_e32 v14, s46, v3
		v_mbcnt_lo_u32_b32 v15, -1, 0
		v_cndmask_b32_e32 v14, v20, v14, vcc
		s_add_i32 m0, m0, 0x1100
		s_mul_i32 s46, s41, 0x80
		buffer_load_dwordx4 v14, s[36:39], 0 offen lds
		v_mbcnt_hi_u32_b32 v14, -1, v15
		v_and_b32_e32 v15, 1, v14
		v_lshrrev_b32_e32 v16, 4, v14
		v_and_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v16, 4, v16
		v_lshrrev_b32_e32 v17, 3, v14
		v_and_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v17, 3, v17
		v_add3_u32 v18, v15, v16, v17
		v_lshrrev_b32_e32 v19, 2, v14
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v19, 2, v19
		v_lshrrev_b32_e32 v21, 1, v14
		v_and_b32_e32 v21, 1, v21
		v_lshlrev_b32_e32 v21, 1, v21
		v_add3_u32 v18, v18, v19, v21
		v_add_u32_e32 v15, 32, v15
		v_bitop3_b32 v15, v19, v15, v21 bitop3:0x96
		v_bitop3_b32 v15, v16, v17, v15 bitop3:0x96
		v_mov_b32_e32 v16, 0x3e38aa3b
		v_mov_b32_e32 v17, 0x3e38aa3b
		s_mov_b32 s41, 0xff800000
		v_mov_b32_e32 v19, s41
		v_mov_b32_e32 v21, s41
		s_mov_b32 s41, 1.0
		v_mov_b32_e32 v22, s41
		v_mov_b32_e32 v23, s41
		s_mov_b32 s41, 0
		v_accvgpr_read_b32 v24, a18
		v_lshlrev_b32_e32 v24, 4, v24
		v_accvgpr_write_b32 a63, v24
		v_and_b32_e32 v11, 31, v11
		v_lshrrev_b32_e32 v24, 4, v11
		v_lshlrev_b32_e32 v24, 9, v24
		v_accvgpr_write_b32 a64, v24
		v_lshrrev_b32_e32 v24, 3, v11
		v_and_b32_e32 v24, 1, v24
		v_mov_b32_e32 v25, 0x2080
		v_mul_lo_u32 v25, v25, v24
		v_accvgpr_write_b32 a65, v25
		v_lshrrev_b32_e32 v24, 2, v11
		v_and_b32_e32 v24, 1, v24
		v_mov_b32_e32 v25, 0x1040
		v_mul_lo_u32 v25, v25, v24
		v_accvgpr_write_b32 a66, v25
		v_lshrrev_b32_e32 v24, 1, v11
		v_and_b32_e32 v24, 1, v24
		v_mov_b32_e32 v25, 0x820
		v_mul_lo_u32 v25, v25, v24
		v_accvgpr_write_b32 a67, v25
		v_and_b32_e32 v11, 1, v11
		v_mov_b32_e32 v24, 0x410
		v_mul_lo_u32 v24, v24, v11
		v_accvgpr_write_b32 a68, v24
		v_and_b32_e32 v11, 3, v0
		v_accvgpr_write_b32 a69, v11
		v_accvgpr_read_b32 v11, a69
		v_lshlrev_b32_e32 v11, 3, v11
		v_accvgpr_write_b32 a70, v11
		v_mov_b32_e32 v11, 0x2200
		v_mul_lo_u32 v11, v11, v8
		v_accvgpr_write_b32 a71, v11
		v_and_b32_e32 v7, 3, v7
		v_mov_b32_e32 v8, 0x440
		v_mul_lo_u32 v8, v8, v7
		v_accvgpr_write_b32 a72, v8
		s_lshl_b32 s47, s15, 8
		s_add_i32 s47, s47, s57
		s_add_i32 s47, s47, s58
		s_lshl_b32 s48, s18, 8
		s_add_i32 s44, s48, s44
		s_add_i32 s44, s44, s45
		v_lshlrev_b32_e32 v7, 2, v18
		v_lshlrev_b32_e32 v8, 2, v15
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
		s_lshr_b32 s45, s41, 7
		s_and_b32 s48, s45, 1
		s_mul_i32 s49, 0x4100, s48
		v_accvgpr_read_b32 v11, a63
		v_accvgpr_read_b32 v15, a64
		v_add3_u32 v11, s49, v11, v15
		v_accvgpr_read_b32 v15, a65
		v_accvgpr_read_b32 v18, a66
		v_add3_u32 v11, v11, v15, v18
		v_accvgpr_read_b32 v15, a67
		v_accvgpr_read_b32 v18, a68
		v_add3_u32 v11, v11, v15, v18
		ds_read_b128 v[24:27], v11
		ds_read_b128 a[76:79], v11 offset:32
		ds_read_b128 a[80:83], v11 offset:64
		ds_read_b128 a[84:87], v11 offset:96
		ds_read_b128 v[28:31], v11 offset:256
		ds_read_b128 a[88:91], v11 offset:288
		ds_read_b128 a[92:95], v11 offset:320
		ds_read_b128 a[96:99], v11 offset:352
		ds_read_b128 a[100:103], v11 offset:128
		ds_read_b128 a[104:107], v11 offset:160
		ds_read_b128 a[108:111], v11 offset:192
		ds_read_b128 a[112:115], v11 offset:224
		ds_read_b128 v[96:99], v11 offset:384
		ds_read_b128 a[116:119], v11 offset:416
		ds_read_b128 a[120:123], v11 offset:448
		ds_read_b128 a[124:127], v11 offset:480
		s_mul_i32 s48, 0x4400, s48
		v_accvgpr_read_b32 v11, a70
		v_accvgpr_read_b32 v15, a71
		v_add3_u32 v11, s48, v11, v15
		v_accvgpr_read_b32 v15, a72
		v_accvgpr_read_b32 v18, a58
		v_add3_u32 v11, v11, v18, v15
		ds_read_b64_tr_b16 a[128:129], v11 offset:33264
		ds_read_b64_tr_b16 a[130:131], v11 offset:37616
		ds_read_b64_tr_b16 a[132:133], v11 offset:33392
		ds_read_b64_tr_b16 a[134:135], v11 offset:37744
		ds_read_b64_tr_b16 a[136:137], v11 offset:33520
		ds_read_b64_tr_b16 a[138:139], v11 offset:37872
		ds_read_b64_tr_b16 a[140:141], v11 offset:33648
		ds_read_b64_tr_b16 a[142:143], v11 offset:38000
		ds_read_b64_tr_b16 a[144:145], v11 offset:33776
		ds_read_b64_tr_b16 a[146:147], v11 offset:38128
		ds_read_b64_tr_b16 a[148:149], v11 offset:33904
		ds_read_b64_tr_b16 a[150:151], v11 offset:38256
		ds_read_b64_tr_b16 a[152:153], v11 offset:34032
		ds_read_b64_tr_b16 a[154:155], v11 offset:38384
		ds_read_b64_tr_b16 a[156:157], v11 offset:34160
		ds_read_b64_tr_b16 a[158:159], v11 offset:38512
		ds_read_b64_tr_b16 a[160:161], v11 offset:33328
		ds_read_b64_tr_b16 a[162:163], v11 offset:37680
		ds_read_b64_tr_b16 a[164:165], v11 offset:33456
		ds_read_b64_tr_b16 a[166:167], v11 offset:37808
		ds_read_b64_tr_b16 a[168:169], v11 offset:33584
		ds_read_b64_tr_b16 a[170:171], v11 offset:37936
		ds_read_b64_tr_b16 a[172:173], v11 offset:33712
		ds_read_b64_tr_b16 a[174:175], v11 offset:38064
		ds_read_b64_tr_b16 a[176:177], v11 offset:33840
		ds_read_b64_tr_b16 a[178:179], v11 offset:38192
		ds_read_b64_tr_b16 a[180:181], v11 offset:33968
		ds_read_b64_tr_b16 a[182:183], v11 offset:38320
		ds_read_b64_tr_b16 a[184:185], v11 offset:34096
		ds_read_b64_tr_b16 a[186:187], v11 offset:38448
		ds_read_b64_tr_b16 a[188:189], v11 offset:34224
		ds_read_b64_tr_b16 a[190:191], v11 offset:38576
		s_mul_i32 s48, s15, s41
		s_lshl_b32 s48, s48, 1
		s_add_i32 s48, s47, s48
		v_accvgpr_read_b32 v11, a60
		v_add_u32_e32 v11, s48, v11
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v15, a62
		v_add_u32_e32 v15, s48, v15
		s_add_i32 s45, s45, 1
		v_add_u32_e32 v18, s48, v12
		s_and_b32 s45, s45, 1
		v_add_u32_e32 v100, s48, v6
		s_mul_i32 s48, 0x4100, s45
		v_mfma_f32_32x32x16_bf16 v[112:127], v[24:27], a[20:23], 0
		s_add_i32 s48, s43, s48
		v_mfma_f32_32x32x16_bf16 v[128:143], v[28:31], a[20:23], 0
		s_mov_b32 m0, s48
		v_mfma_f32_32x32x16_bf16 v[144:159], a[100:103], a[20:23], 0
		s_mul_i32 s48, s18, s41
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], a[20:23], 0
		s_add_i32 s41, s41, 0x80
		v_mfma_f32_32x32x16_bf16 v[176:191], v[96:99], a[36:39], 0
		v_accvgpr_read_b32 v96, a19
		v_add_u32_e32 v96, s41, v96
		v_mfma_f32_32x32x16_bf16 v[192:207], v[24:27], a[36:39], 0
		v_accvgpr_read_b32 v24, a52
		v_add_u32_e32 v24, s41, v24
		v_mfma_f32_32x32x16_bf16 v[208:223], v[28:31], a[36:39], 0
		v_accvgpr_read_b32 v25, a53
		v_add_u32_e32 v25, s41, v25
		v_mfma_f32_32x32x16_bf16 v[224:239], a[100:103], a[36:39], 0
		v_accvgpr_read_b32 v26, a54
		v_add_u32_e32 v26, s41, v26
		v_mfma_f32_32x32x16_bf16 v[112:127], a[76:79], a[24:27], v[112:127]
		v_cmp_lt_i32_e64 vcc, v96, s22
		s_mov_b64 s[50:51], vcc
		v_mfma_f32_32x32x16_bf16 v[128:143], a[88:91], a[24:27], v[128:143]
		v_cmp_lt_i32_e64 vcc, v24, s22
		s_mov_b64 s[52:53], vcc
		v_mfma_f32_32x32x16_bf16 v[144:159], a[104:107], a[24:27], v[144:159]
		v_cmp_lt_i32_e64 vcc, v25, s22
		s_mov_b64 s[54:55], vcc
		v_mfma_f32_32x32x16_bf16 v[160:175], a[116:119], a[24:27], v[160:175]
		v_cmp_lt_i32_e64 vcc, v26, s22
		s_mov_b64 s[58:59], vcc
		v_mfma_f32_32x32x16_bf16 v[176:191], a[116:119], a[40:43], v[176:191]
		v_accvgpr_read_b32 v24, a55
		v_add_u32_e32 v24, s41, v24
		v_mfma_f32_32x32x16_bf16 v[192:207], a[76:79], a[40:43], v[192:207]
		v_accvgpr_read_b32 v25, a56
		v_add_u32_e32 v25, s41, v25
		v_mfma_f32_32x32x16_bf16 v[208:223], a[88:91], a[40:43], v[208:223]
		v_accvgpr_read_b32 v26, a57
		v_add_u32_e32 v26, s41, v26
		v_mfma_f32_32x32x16_bf16 v[224:239], a[104:107], a[40:43], v[224:239]
		v_cmp_lt_i32_e64 vcc, v24, s22
		s_mov_b64 s[60:61], vcc
		v_mfma_f32_32x32x16_bf16 v[112:127], a[80:83], a[28:31], v[112:127]
		v_cmp_lt_i32_e64 vcc, v25, s22
		s_mov_b64 s[62:63], vcc
		v_mfma_f32_32x32x16_bf16 v[128:143], a[92:95], a[28:31], v[128:143]
		v_cmp_lt_i32_e64 vcc, v26, s22
		s_mov_b64 s[64:65], vcc
		v_mfma_f32_32x32x16_bf16 v[144:159], a[108:111], a[28:31], v[144:159]
		v_cndmask_b32_e64 v11, v20, v11, s[50:51]
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[160:175], a[120:123], a[28:31], v[160:175]
		v_accvgpr_read_b32 v11, a61
		v_add_u32_e32 v11, s41, v11
		v_cndmask_b32_e64 v15, v20, v15, s[52:53]
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v18, v20, v18, s[54:55]
		buffer_load_dwordx4 v15, s[32:35], 0 offen lds
		v_cndmask_b32_e64 v15, v20, v100, s[58:59]
		v_cmp_lt_i32_e64 vcc, v11, s22
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s48, s48, 1
		s_add_i32 s48, s44, s48
		buffer_load_dwordx4 v18, s[32:35], 0 offen lds
		v_add_u32_e32 v11, s48, v13
		v_cndmask_b32_e64 v11, v20, v11, s[60:61]
		s_add_i32 m0, m0, 0x1040
		s_mul_i32 s45, 0x4400, s45
		s_add_i32 s45, s42, s45
		buffer_load_dwordx4 v15, s[32:35], 0 offen lds
		v_add_u32_e32 v15, s48, v4
		v_cndmask_b32_e64 v15, v20, v15, s[62:63]
		s_add_i32 m0, s45, 0x81f0
		v_add_u32_e32 v18, s48, v9
		v_cndmask_b32_e64 v18, v20, v18, s[64:65]
		buffer_load_dwordx4 v11, s[36:39], 0 offen lds
		v_add_u32_e32 v11, s48, v3
		v_cndmask_b32_e32 v11, v20, v11, vcc
		s_add_i32 m0, m0, 0x1100
		v_mfma_f32_32x32x16_bf16 v[176:191], a[120:123], a[44:47], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[80:83], a[44:47], v[192:207]
		buffer_load_dwordx4 v15, s[36:39], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[208:223], a[92:95], a[44:47], v[208:223]
		s_add_i32 m0, m0, 0x1100
		v_mfma_f32_32x32x16_bf16 v[224:239], a[108:111], a[44:47], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[84:87], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[96:99], a[32:35], v[128:143]
		buffer_load_dwordx4 v18, s[36:39], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[144:159], a[112:115], a[32:35], v[144:159]
		s_add_i32 m0, m0, 0x1100
		s_cmp_lt_i32 s41, s46
		v_mfma_f32_32x32x16_bf16 v[160:175], a[124:127], a[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[124:127], a[48:51], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[84:87], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[96:99], a[48:51], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[112:115], a[48:51], v[224:239]
		buffer_load_dwordx4 v11, s[36:39], 0 offen lds
		s_nop 0
		v_max_f32_e32 v11, v112, v113
		v_max_f32_e32 v15, v114, v115
		v_max_f32_e32 v18, v116, v117
		v_max_f32_e32 v24, v118, v119
		v_max_f32_e32 v25, v120, v121
		v_max_f32_e32 v26, v122, v123
		v_max_f32_e32 v27, v124, v125
		v_max_f32_e32 v28, v126, v127
		v_max_f32_e32 v29, v128, v129
		v_max_f32_e32 v30, v130, v131
		v_max_f32_e32 v31, v132, v133
		v_max_f32_e32 v96, v134, v135
		v_max_f32_e32 v97, v136, v137
		v_max_f32_e32 v98, v138, v139
		v_max_f32_e32 v99, v140, v141
		v_max_f32_e32 v100, v142, v143
		v_max_f32_e32 v101, v144, v145
		v_max_f32_e32 v102, v146, v147
		v_max_f32_e32 v103, v148, v149
		v_max_f32_e32 v104, v150, v151
		v_max_f32_e32 v105, v152, v153
		v_max_f32_e32 v106, v154, v155
		v_max_f32_e32 v107, v156, v157
		v_max_f32_e32 v108, v158, v159
		v_max_f32_e32 v109, v160, v161
		v_max_f32_e32 v110, v162, v163
		v_max_f32_e32 v111, v164, v165
		v_max_f32_e32 v240, v166, v167
		v_max_f32_e32 v241, v168, v169
		v_max_f32_e32 v242, v170, v171
		v_max_f32_e32 v243, v172, v173
		v_max_f32_e32 v244, v174, v175
		v_max_f32_e32 v11, v11, v15
		v_max_f32_e32 v15, v18, v24
		v_max_f32_e32 v18, v25, v26
		v_max_f32_e32 v24, v27, v28
		v_max_f32_e32 v25, v29, v30
		v_max_f32_e32 v26, v31, v96
		v_max_f32_e32 v27, v97, v98
		v_max_f32_e32 v28, v99, v100
		v_max_f32_e32 v29, v101, v102
		v_max_f32_e32 v30, v103, v104
		v_max_f32_e32 v31, v105, v106
		v_max_f32_e32 v96, v107, v108
		v_max_f32_e32 v97, v109, v110
		v_max_f32_e32 v98, v111, v240
		v_max_f32_e32 v99, v241, v242
		v_max_f32_e32 v100, v243, v244
		v_max_f32_e32 v11, v11, v15
		v_max_f32_e32 v15, v18, v24
		v_max_f32_e32 v18, v25, v26
		v_max_f32_e32 v24, v27, v28
		v_max_f32_e32 v25, v29, v30
		v_max_f32_e32 v26, v31, v96
		v_max_f32_e32 v27, v97, v98
		v_max_f32_e32 v28, v99, v100
		v_max_f32_e32 v11, v11, v15
		v_max_f32_e32 v15, v18, v24
		v_max_f32_e32 v18, v25, v26
		v_max_f32_e32 v24, v27, v28
		v_max_f32_e32 v11, v11, v15
		v_max_f32_e32 v15, v18, v24
		v_max_f32_e32 v11, v11, v15
		ds_bpermute_b32 v15, v7, v11
		ds_bpermute_b32 v18, v8, v11
		v_max_f32_e32 v11, v192, v193
		v_max_f32_e32 v24, v194, v195
		v_max_f32_e32 v25, v196, v197
		v_max_f32_e32 v26, v198, v199
		v_max_f32_e32 v27, v200, v201
		v_max_f32_e32 v28, v202, v203
		v_max_f32_e32 v29, v204, v205
		v_max_f32_e32 v30, v206, v207
		v_max_f32_e32 v31, v208, v209
		v_max_f32_e32 v96, v210, v211
		v_max_f32_e32 v97, v212, v213
		v_max_f32_e32 v98, v214, v215
		v_max_f32_e32 v99, v216, v217
		v_max_f32_e32 v100, v218, v219
		v_max_f32_e32 v101, v220, v221
		v_max_f32_e32 v102, v222, v223
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v104, v15, v18
		v_max_f32_e32 v15, v224, v225
		v_max_f32_e32 v18, v226, v227
		v_max_f32_e32 v103, v228, v229
		v_max_f32_e32 v105, v230, v231
		v_max_f32_e32 v106, v232, v233
		v_max_f32_e32 v107, v234, v235
		v_max_f32_e32 v108, v236, v237
		v_max_f32_e32 v109, v238, v239
		v_max_f32_e32 v110, v176, v177
		v_max_f32_e32 v111, v178, v179
		v_max_f32_e32 v240, v180, v181
		v_max_f32_e32 v241, v182, v183
		v_max_f32_e32 v242, v184, v185
		v_max_f32_e32 v243, v186, v187
		v_max_f32_e32 v244, v188, v189
		v_max_f32_e32 v245, v190, v191
		v_max_f32_e32 v11, v11, v24
		v_max_f32_e32 v24, v25, v26
		v_max_f32_e32 v25, v27, v28
		v_max_f32_e32 v26, v29, v30
		v_max_f32_e32 v27, v31, v96
		v_max_f32_e32 v28, v97, v98
		v_max_f32_e32 v29, v99, v100
		v_max_f32_e32 v30, v101, v102
		v_max_f32_e32 v15, v15, v18
		v_max_f32_e32 v18, v103, v105
		v_max_f32_e32 v31, v106, v107
		v_max_f32_e32 v96, v108, v109
		v_max_f32_e32 v97, v110, v111
		v_max_f32_e32 v98, v240, v241
		v_max_f32_e32 v99, v242, v243
		v_max_f32_e32 v100, v244, v245
		v_max_f32_e32 v11, v11, v24
		v_max_f32_e32 v24, v25, v26
		v_max_f32_e32 v25, v27, v28
		v_max_f32_e32 v26, v29, v30
		v_max_f32_e32 v15, v15, v18
		v_max_f32_e32 v18, v31, v96
		v_max_f32_e32 v27, v97, v98
		v_max_f32_e32 v28, v99, v100
		v_max_f32_e32 v11, v11, v24
		v_max_f32_e32 v24, v25, v26
		v_max_f32_e32 v15, v15, v18
		v_max_f32_e32 v18, v27, v28
		v_max_f32_e32 v11, v11, v24
		v_max_f32_e32 v15, v15, v18
		v_max_f32_e32 v11, v11, v15
		ds_bpermute_b32 v15, v7, v11
		ds_bpermute_b32 v18, v8, v11
		v_pk_mul_f32 v[24:25], v[112:113], v[16:17]
		v_pk_mul_f32 v[26:27], v[114:115], v[16:17]
		v_pk_mul_f32 v[28:29], v[116:117], v[16:17]
		v_pk_mul_f32 v[30:31], v[118:119], v[16:17]
		v_pk_mul_f32 v[96:97], v[120:121], v[16:17]
		v_pk_mul_f32 v[98:99], v[122:123], v[16:17]
		v_pk_mul_f32 v[100:101], v[124:125], v[16:17]
		v_pk_mul_f32 v[102:103], v[126:127], v[16:17]
		v_pk_mul_f32 v[106:107], v[128:129], v[16:17]
		v_pk_mul_f32 v[108:109], v[130:131], v[16:17]
		v_pk_mul_f32 v[110:111], v[132:133], v[16:17]
		v_pk_mul_f32 v[112:113], v[134:135], v[16:17]
		v_pk_mul_f32 v[114:115], v[136:137], v[16:17]
		v_pk_mul_f32 v[116:117], v[138:139], v[16:17]
		v_pk_mul_f32 v[118:119], v[140:141], v[16:17]
		v_pk_mul_f32 v[120:121], v[142:143], v[16:17]
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v105, v15, v18
		v_pk_mul_f32 v[122:123], v[104:105], v[16:17]
		v_max_f32_e32 v11, v19, v122
		v_max_f32_e32 v15, v21, v123
		v_pk_mul_f32 v[104:105], v[144:145], v[16:17]
		v_pk_mul_f32 v[122:123], v[146:147], v[16:17]
		v_pk_mul_f32 v[124:125], v[148:149], v[16:17]
		v_pk_mul_f32 v[126:127], v[150:151], v[16:17]
		v_pk_mul_f32 v[128:129], v[152:153], v[16:17]
		v_pk_mul_f32 v[130:131], v[154:155], v[16:17]
		v_pk_mul_f32 v[132:133], v[156:157], v[16:17]
		v_pk_mul_f32 v[134:135], v[158:159], v[16:17]
		v_pk_mul_f32 v[136:137], v[160:161], v[16:17]
		v_pk_mul_f32 v[138:139], v[162:163], v[16:17]
		v_pk_mul_f32 v[140:141], v[164:165], v[16:17]
		v_pk_mul_f32 v[142:143], v[166:167], v[16:17]
		v_pk_mul_f32 v[144:145], v[168:169], v[16:17]
		v_pk_mul_f32 v[146:147], v[170:171], v[16:17]
		v_pk_mul_f32 v[148:149], v[172:173], v[16:17]
		v_pk_mul_f32 v[150:151], v[174:175], v[16:17]
		v_pk_mul_f32 v[152:153], v[192:193], v[16:17]
		v_pk_mul_f32 v[154:155], v[194:195], v[16:17]
		v_pk_mul_f32 v[156:157], v[196:197], v[16:17]
		v_pk_mul_f32 v[158:159], v[198:199], v[16:17]
		v_pk_mul_f32 v[160:161], v[200:201], v[16:17]
		v_pk_mul_f32 v[162:163], v[202:203], v[16:17]
		v_pk_mul_f32 v[164:165], v[204:205], v[16:17]
		v_pk_mul_f32 v[166:167], v[206:207], v[16:17]
		v_pk_mul_f32 v[168:169], v[208:209], v[16:17]
		v_pk_mul_f32 v[170:171], v[210:211], v[16:17]
		v_pk_mul_f32 v[172:173], v[212:213], v[16:17]
		v_pk_mul_f32 v[174:175], v[214:215], v[16:17]
		v_pk_mul_f32 v[192:193], v[216:217], v[16:17]
		v_pk_mul_f32 v[194:195], v[218:219], v[16:17]
		v_pk_mul_f32 v[196:197], v[220:221], v[16:17]
		v_pk_mul_f32 v[198:199], v[222:223], v[16:17]
		v_pk_mul_f32 v[200:201], v[224:225], v[16:17]
		v_pk_mul_f32 v[202:203], v[226:227], v[16:17]
		v_pk_mul_f32 v[204:205], v[228:229], v[16:17]
		v_pk_mul_f32 v[206:207], v[230:231], v[16:17]
		v_pk_mul_f32 v[208:209], v[232:233], v[16:17]
		v_pk_mul_f32 v[210:211], v[234:235], v[16:17]
		v_pk_mul_f32 v[212:213], v[236:237], v[16:17]
		v_pk_mul_f32 v[214:215], v[238:239], v[16:17]
		v_pk_mul_f32 v[216:217], v[176:177], v[16:17]
		v_pk_mul_f32 v[176:177], v[178:179], v[16:17]
		v_pk_mul_f32 v[178:179], v[180:181], v[16:17]
		v_pk_mul_f32 v[180:181], v[182:183], v[16:17]
		v_pk_mul_f32 v[182:183], v[184:185], v[16:17]
		v_pk_mul_f32 v[184:185], v[186:187], v[16:17]
		v_pk_mul_f32 v[186:187], v[188:189], v[16:17]
		v_pk_mul_f32 v[188:189], v[190:191], v[16:17]
		v_sub_f32_e32 v18, v24, v11
		v_sub_f32_e32 v24, v25, v11
		v_sub_f32_e32 v25, v26, v11
		v_sub_f32_e32 v26, v27, v11
		v_sub_f32_e32 v27, v28, v11
		v_sub_f32_e32 v28, v29, v11
		v_sub_f32_e32 v29, v30, v11
		v_sub_f32_e32 v30, v31, v11
		v_sub_f32_e32 v31, v96, v11
		v_sub_f32_e32 v96, v97, v11
		v_sub_f32_e32 v97, v98, v11
		v_sub_f32_e32 v98, v99, v11
		v_sub_f32_e32 v99, v100, v11
		v_sub_f32_e32 v100, v101, v11
		v_sub_f32_e32 v101, v102, v11
		v_sub_f32_e32 v102, v103, v11
		v_sub_f32_e32 v103, v106, v11
		v_sub_f32_e32 v106, v107, v11
		v_sub_f32_e32 v107, v108, v11
		v_sub_f32_e32 v108, v109, v11
		v_sub_f32_e32 v109, v110, v11
		v_sub_f32_e32 v110, v111, v11
		v_sub_f32_e32 v111, v112, v11
		v_sub_f32_e32 v112, v113, v11
		v_sub_f32_e32 v113, v114, v11
		v_sub_f32_e32 v114, v115, v11
		v_sub_f32_e32 v115, v116, v11
		v_sub_f32_e32 v116, v117, v11
		v_sub_f32_e32 v117, v118, v11
		v_sub_f32_e32 v118, v119, v11
		v_sub_f32_e32 v119, v120, v11
		v_sub_f32_e32 v120, v121, v11
		v_sub_f32_e32 v104, v104, v11
		v_sub_f32_e32 v105, v105, v11
		v_sub_f32_e32 v121, v122, v11
		v_sub_f32_e32 v122, v123, v11
		v_sub_f32_e32 v123, v124, v11
		v_sub_f32_e32 v124, v125, v11
		v_sub_f32_e32 v125, v126, v11
		v_sub_f32_e32 v126, v127, v11
		v_sub_f32_e32 v127, v128, v11
		v_sub_f32_e32 v128, v129, v11
		v_sub_f32_e32 v129, v130, v11
		v_sub_f32_e32 v130, v131, v11
		v_sub_f32_e32 v131, v132, v11
		v_sub_f32_e32 v132, v133, v11
		v_sub_f32_e32 v133, v134, v11
		v_sub_f32_e32 v134, v135, v11
		v_sub_f32_e32 v135, v136, v11
		v_sub_f32_e32 v136, v137, v11
		v_sub_f32_e32 v137, v138, v11
		v_sub_f32_e32 v138, v139, v11
		v_sub_f32_e32 v139, v140, v11
		v_sub_f32_e32 v140, v141, v11
		v_sub_f32_e32 v141, v142, v11
		v_sub_f32_e32 v142, v143, v11
		v_sub_f32_e32 v143, v144, v11
		v_sub_f32_e32 v144, v145, v11
		v_sub_f32_e32 v145, v146, v11
		v_sub_f32_e32 v146, v147, v11
		v_sub_f32_e32 v147, v148, v11
		v_sub_f32_e32 v148, v149, v11
		v_sub_f32_e32 v149, v150, v11
		v_sub_f32_e32 v150, v151, v11
		v_sub_f32_e32 v151, v152, v15
		v_sub_f32_e32 v152, v153, v15
		v_sub_f32_e32 v153, v154, v15
		v_sub_f32_e32 v154, v155, v15
		v_sub_f32_e32 v155, v156, v15
		v_sub_f32_e32 v156, v157, v15
		v_sub_f32_e32 v157, v158, v15
		v_sub_f32_e32 v158, v159, v15
		v_sub_f32_e32 v159, v160, v15
		v_sub_f32_e32 v160, v161, v15
		v_sub_f32_e32 v161, v162, v15
		v_sub_f32_e32 v162, v163, v15
		v_sub_f32_e32 v163, v164, v15
		v_sub_f32_e32 v164, v165, v15
		v_sub_f32_e32 v165, v166, v15
		v_sub_f32_e32 v166, v167, v15
		v_sub_f32_e32 v167, v168, v15
		v_sub_f32_e32 v168, v169, v15
		v_sub_f32_e32 v169, v170, v15
		v_sub_f32_e32 v170, v171, v15
		v_sub_f32_e32 v171, v172, v15
		v_sub_f32_e32 v172, v173, v15
		v_sub_f32_e32 v173, v174, v15
		v_sub_f32_e32 v174, v175, v15
		v_sub_f32_e32 v175, v192, v15
		v_sub_f32_e32 v190, v193, v15
		v_sub_f32_e32 v191, v194, v15
		v_sub_f32_e32 v192, v195, v15
		v_sub_f32_e32 v193, v196, v15
		v_sub_f32_e32 v194, v197, v15
		v_sub_f32_e32 v195, v198, v15
		v_sub_f32_e32 v196, v199, v15
		v_sub_f32_e32 v197, v200, v15
		v_sub_f32_e32 v198, v201, v15
		v_sub_f32_e32 v199, v202, v15
		v_sub_f32_e32 v200, v203, v15
		v_sub_f32_e32 v201, v204, v15
		v_sub_f32_e32 v202, v205, v15
		v_sub_f32_e32 v203, v206, v15
		v_sub_f32_e32 v204, v207, v15
		v_sub_f32_e32 v205, v208, v15
		v_sub_f32_e32 v206, v209, v15
		v_sub_f32_e32 v207, v210, v15
		v_sub_f32_e32 v208, v211, v15
		v_sub_f32_e32 v209, v212, v15
		v_sub_f32_e32 v210, v213, v15
		v_sub_f32_e32 v211, v214, v15
		v_sub_f32_e32 v212, v215, v15
		v_sub_f32_e32 v213, v216, v15
		v_sub_f32_e32 v214, v217, v15
		v_sub_f32_e32 v176, v176, v15
		v_sub_f32_e32 v177, v177, v15
		v_sub_f32_e32 v178, v178, v15
		v_sub_f32_e32 v179, v179, v15
		v_sub_f32_e32 v180, v180, v15
		v_sub_f32_e32 v181, v181, v15
		v_sub_f32_e32 v182, v182, v15
		v_sub_f32_e32 v183, v183, v15
		v_sub_f32_e32 v184, v184, v15
		v_sub_f32_e32 v185, v185, v15
		v_sub_f32_e32 v186, v186, v15
		v_sub_f32_e32 v187, v187, v15
		v_sub_f32_e32 v188, v188, v15
		v_sub_f32_e32 v189, v189, v15
		v_exp_f32_e32 v216, v18
		v_exp_f32_e32 v218, v24
		v_exp_f32_e32 v217, v25
		v_exp_f32_e32 v219, v26
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
		v_exp_f32_e32 v99, v102
		v_exp_f32_e32 v100, v103
		v_exp_f32_e32 v102, v106
		v_exp_f32_e32 v101, v107
		v_exp_f32_e32 v103, v108
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
		v_exp_f32_e32 v118, v104
		v_exp_f32_e32 v220, v105
		v_exp_f32_e32 v119, v121
		v_exp_f32_e32 v221, v122
		v_exp_f32_e32 v104, v123
		v_exp_f32_e32 v120, v124
		v_exp_f32_e32 v105, v125
		v_exp_f32_e32 v121, v126
		v_exp_f32_e32 v122, v127
		v_exp_f32_e32 v124, v128
		v_exp_f32_e32 v123, v129
		v_exp_f32_e32 v125, v130
		v_exp_f32_e32 v126, v131
		v_exp_f32_e32 v128, v132
		v_exp_f32_e32 v127, v133
		v_exp_f32_e32 v129, v134
		v_exp_f32_e32 v130, v135
		v_exp_f32_e32 v132, v136
		v_exp_f32_e32 v131, v137
		v_exp_f32_e32 v133, v138
		v_exp_f32_e32 v134, v139
		v_exp_f32_e32 v136, v140
		v_exp_f32_e32 v135, v141
		v_exp_f32_e32 v137, v142
		v_exp_f32_e32 v138, v143
		v_exp_f32_e32 v140, v144
		v_exp_f32_e32 v139, v145
		v_exp_f32_e32 v141, v146
		v_exp_f32_e32 v142, v147
		v_exp_f32_e32 v144, v148
		v_exp_f32_e32 v143, v149
		v_exp_f32_e32 v145, v150
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
		v_exp_f32_e32 v170, v173
		v_exp_f32_e32 v172, v174
		v_exp_f32_e32 v171, v175
		v_exp_f32_e32 v173, v190
		v_exp_f32_e32 v174, v191
		v_exp_f32_e32 v190, v192
		v_exp_f32_e32 v175, v193
		v_exp_f32_e32 v191, v194
		v_exp_f32_e32 v192, v195
		v_exp_f32_e32 v194, v196
		v_exp_f32_e32 v193, v197
		v_exp_f32_e32 v195, v198
		v_exp_f32_e32 v196, v199
		v_exp_f32_e32 v198, v200
		v_exp_f32_e32 v197, v201
		v_exp_f32_e32 v199, v202
		v_exp_f32_e32 v200, v203
		v_exp_f32_e32 v202, v204
		v_exp_f32_e32 v201, v205
		v_exp_f32_e32 v203, v206
		v_exp_f32_e32 v204, v207
		v_exp_f32_e32 v206, v208
		v_exp_f32_e32 v205, v209
		v_exp_f32_e32 v207, v210
		v_exp_f32_e32 v208, v211
		v_exp_f32_e32 v210, v212
		v_exp_f32_e32 v209, v213
		v_exp_f32_e32 v211, v214
		v_exp_f32_e32 v212, v176
		v_exp_f32_e32 v214, v177
		v_exp_f32_e32 v213, v178
		v_exp_f32_e32 v215, v179
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
		v_pk_add_f32 v[188:189], v[216:217], v[218:219]
		v_pk_add_f32 v[222:223], v[24:25], v[26:27]
		v_pk_add_f32 v[224:225], v[28:29], v[30:31]
		v_pk_add_f32 v[226:227], v[96:97], v[98:99]
		v_pk_add_f32 v[228:229], v[100:101], v[102:103]
		v_pk_add_f32 v[230:231], v[106:107], v[108:109]
		v_pk_add_f32 v[232:233], v[110:111], v[112:113]
		v_pk_add_f32 v[234:235], v[114:115], v[116:117]
		v_pk_add_f32 v[236:237], v[118:119], v[220:221]
		v_pk_add_f32 v[238:239], v[104:105], v[120:121]
		v_pk_add_f32 v[240:241], v[122:123], v[124:125]
		v_pk_add_f32 v[242:243], v[126:127], v[128:129]
		v_pk_add_f32 v[244:245], v[130:131], v[132:133]
		v_pk_add_f32 v[246:247], v[134:135], v[136:137]
		v_pk_add_f32 v[248:249], v[138:139], v[140:141]
		v_pk_add_f32 v[250:251], v[142:143], v[144:145]
		v_accvgpr_write_b32 a74, v250
		v_accvgpr_write_b32 a75, v251
		v_mov_b32_e32 v250, v189
		v_mov_b32_e32 v251, v223
		v_mov_b32_e32 v252, v188
		v_mov_b32_e32 v253, v222
		v_pk_add_f32 v[188:189], v[252:253], v[250:251]
		v_mov_b32_e32 v222, v225
		v_mov_b32_e32 v223, v227
		v_mov_b32_e32 v250, v224
		v_mov_b32_e32 v251, v226
		v_pk_add_f32 v[224:225], v[250:251], v[222:223]
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
		v_accvgpr_read_b32 v18, a75
		v_mov_b32_e32 v223, v18
		v_mov_b32_e32 v226, v248
		v_accvgpr_read_b32 v18, a74
		v_mov_b32_e32 v227, v18
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
		v_add_f32_e32 v18, v188, v189
		ds_bpermute_b32 v146, v7, v18
		ds_bpermute_b32 v148, v8, v18
		v_pk_add_f32 v[188:189], v[150:151], v[152:153]
		v_pk_add_f32 v[222:223], v[154:155], v[156:157]
		v_pk_add_f32 v[224:225], v[158:159], v[160:161]
		v_pk_add_f32 v[226:227], v[162:163], v[164:165]
		v_pk_add_f32 v[228:229], v[166:167], v[168:169]
		v_pk_add_f32 v[230:231], v[170:171], v[172:173]
		v_pk_add_f32 v[232:233], v[174:175], v[190:191]
		v_pk_add_f32 v[234:235], v[192:193], v[194:195]
		v_pk_add_f32 v[236:237], v[196:197], v[198:199]
		v_pk_add_f32 v[238:239], v[200:201], v[202:203]
		v_pk_add_f32 v[240:241], v[204:205], v[206:207]
		v_pk_add_f32 v[242:243], v[208:209], v[210:211]
		v_pk_add_f32 v[244:245], v[212:213], v[214:215]
		v_pk_add_f32 v[246:247], v[176:177], v[178:179]
		v_pk_add_f32 v[248:249], v[180:181], v[182:183]
		v_mov_b32_e32 v250, v189
		v_mov_b32_e32 v251, v224
		v_pk_add_f32 v[252:253], v[250:251], v[222:223]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[222:223], v[146:147], v[148:149]
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
		v_add_f32_e32 v18, v231, v226
		v_add_f32_e32 v18, v227, v18
		ds_bpermute_b32 v146, v7, v18
		ds_bpermute_b32 v148, v8, v18
		v_sub_f32_e32 v18, v19, v11
		v_sub_f32_e32 v19, v21, v15
		v_exp_f32_e32 v188, v18
		v_exp_f32_e32 v224, v19
		v_mov_b32_e32 v189, v188
		v_pk_mul_f32 v[32:33], v[32:33], v[188:189]
		v_pk_mul_f32 v[34:35], v[34:35], v[188:189]
		v_pk_mul_f32 v[36:37], v[36:37], v[188:189]
		v_pk_mul_f32 v[38:39], v[38:39], v[188:189]
		v_pk_mul_f32 v[40:41], v[40:41], v[188:189]
		v_pk_mul_f32 v[42:43], v[42:43], v[188:189]
		v_pk_mul_f32 v[44:45], v[44:45], v[188:189]
		v_pk_mul_f32 v[46:47], v[46:47], v[188:189]
		v_pk_mul_f32 v[48:49], v[48:49], v[188:189]
		v_pk_mul_f32 v[50:51], v[50:51], v[188:189]
		v_pk_mul_f32 v[52:53], v[52:53], v[188:189]
		v_pk_mul_f32 v[54:55], v[54:55], v[188:189]
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v19, v146, v148
		v_pk_mul_f32 v[56:57], v[56:57], v[188:189]
		v_pk_mul_f32 v[58:59], v[58:59], v[188:189]
		v_pk_mul_f32 v[60:61], v[60:61], v[188:189]
		v_pk_mul_f32 v[62:63], v[62:63], v[188:189]
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
		v_mov_b32_e32 v18, v222
		v_mov_b32_e32 v222, v188
		v_mov_b32_e32 v223, v224
		v_mov_b64_e32 v[188:189], v[22:23]
		v_pk_fma_f32 v[22:23], v[188:189], v[222:223], v[18:19]
		v_cvt_pk_bf16_f32 v224, v216, v218
		v_cvt_pk_bf16_f32 v225, v217, v219
		v_cvt_pk_bf16_f32 v226, v24, v26
		v_cvt_pk_bf16_f32 v227, v25, v27
		v_cvt_pk_bf16_f32 v24, v28, v30
		v_cvt_pk_bf16_f32 v25, v29, v31
		v_cvt_pk_bf16_f32 v26, v96, v98
		v_cvt_pk_bf16_f32 v27, v97, v99
		v_cvt_pk_bf16_f32 v28, v100, v102
		v_cvt_pk_bf16_f32 v29, v101, v103
		v_cvt_pk_bf16_f32 v30, v106, v108
		v_cvt_pk_bf16_f32 v31, v107, v109
		v_cvt_pk_bf16_f32 v96, v110, v112
		v_cvt_pk_bf16_f32 v97, v111, v113
		v_cvt_pk_bf16_f32 v98, v114, v116
		v_cvt_pk_bf16_f32 v99, v115, v117
		v_cvt_pk_bf16_f32 v100, v118, v220
		v_cvt_pk_bf16_f32 v101, v119, v221
		v_cvt_pk_bf16_f32 v102, v104, v120
		v_cvt_pk_bf16_f32 v103, v105, v121
		v_cvt_pk_bf16_f32 v104, v122, v124
		v_cvt_pk_bf16_f32 v105, v123, v125
		v_cvt_pk_bf16_f32 v106, v126, v128
		v_cvt_pk_bf16_f32 v107, v127, v129
		v_cvt_pk_bf16_f32 v108, v130, v132
		v_cvt_pk_bf16_f32 v109, v131, v133
		v_cvt_pk_bf16_f32 v110, v134, v136
		v_cvt_pk_bf16_f32 v111, v135, v137
		v_cvt_pk_bf16_f32 v112, v138, v140
		v_cvt_pk_bf16_f32 v113, v139, v141
		v_cvt_pk_bf16_f32 v114, v142, v144
		v_cvt_pk_bf16_f32 v115, v143, v145
		v_cvt_pk_bf16_f32 v116, v147, v149
		v_cvt_pk_bf16_f32 v117, v150, v152
		v_cvt_pk_bf16_f32 v118, v151, v153
		v_cvt_pk_bf16_f32 v119, v154, v156
		v_cvt_pk_bf16_f32 v120, v155, v157
		v_cvt_pk_bf16_f32 v121, v158, v160
		v_cvt_pk_bf16_f32 v122, v159, v161
		v_cvt_pk_bf16_f32 v123, v162, v164
		v_cvt_pk_bf16_f32 v124, v163, v165
		v_cvt_pk_bf16_f32 v125, v166, v168
		v_cvt_pk_bf16_f32 v126, v167, v169
		v_cvt_pk_bf16_f32 v127, v170, v172
		v_cvt_pk_bf16_f32 v128, v171, v173
		v_cvt_pk_bf16_f32 v129, v174, v190
		v_cvt_pk_bf16_f32 v130, v175, v191
		v_cvt_pk_bf16_f32 v131, v192, v194
		v_cvt_pk_bf16_f32 v132, v193, v195
		v_cvt_pk_bf16_f32 v133, v196, v198
		v_cvt_pk_bf16_f32 v134, v197, v199
		v_cvt_pk_bf16_f32 v135, v200, v202
		v_cvt_pk_bf16_f32 v136, v201, v203
		v_cvt_pk_bf16_f32 v137, v204, v206
		v_cvt_pk_bf16_f32 v138, v205, v207
		v_cvt_pk_bf16_f32 v139, v208, v210
		v_cvt_pk_bf16_f32 v140, v209, v211
		v_cvt_pk_bf16_f32 v141, v212, v214
		v_cvt_pk_bf16_f32 v142, v213, v215
		v_cvt_pk_bf16_f32 v143, v176, v178
		v_cvt_pk_bf16_f32 v144, v177, v179
		v_cvt_pk_bf16_f32 v145, v180, v182
		v_cvt_pk_bf16_f32 v146, v181, v183
		v_cvt_pk_bf16_f32 v147, v184, v186
		v_permlane32_swap_b32_e32 v224, v226
		v_permlane32_swap_b32_e32 v225, v227
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[32:47], a[128:131], v[224:227], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[160:163], v[224:227], v[48:63]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[32:47], a[132:135], v[24:27], v[32:47]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[48:63], a[164:167], v[24:27], v[48:63]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[32:47], a[136:139], v[28:31], v[32:47]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[48:63], a[168:171], v[28:31], v[48:63]
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_mfma_f32_32x32x16_bf16 v[32:47], a[140:143], v[96:99], v[32:47]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[48:63], a[172:175], v[96:99], v[48:63]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[32:47], a[144:147], v[100:103], v[32:47]
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_mfma_f32_32x32x16_bf16 v[80:95], a[160:163], v[116:119], v[80:95]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[64:79], a[128:131], v[116:119], v[64:79]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[80:95], a[164:167], v[120:123], v[80:95]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[64:79], a[132:135], v[120:123], v[64:79]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[80:95], a[168:171], v[124:127], v[80:95]
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_mfma_f32_32x32x16_bf16 v[64:79], a[136:139], v[124:127], v[64:79]
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_mfma_f32_32x32x16_bf16 v[80:95], a[172:175], v[128:131], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[140:143], v[128:131], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[176:179], v[100:103], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[176:179], v[132:135], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[144:147], v[132:135], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[148:151], v[104:107], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[180:183], v[104:107], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[180:183], v[136:139], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[148:151], v[136:139], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[152:155], v[108:111], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[184:187], v[108:111], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[184:187], v[140:143], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[152:155], v[140:143], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[156:159], v[112:115], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[188:191], v[112:115], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[188:191], v[144:147], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[156:159], v[144:147], v[64:79]
		v_mov_b32_e32 v19, v11
		v_mov_b32_e32 v21, v15
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_3
.L_attn_fwd_persistent.loop_exit_3:
		s_mul_i32 s29, s29, 0x80
		v_readfirstlane_b32 s41, v5
		v_accvgpr_read_b32 v7, a9
		s_nop 0
		v_add_u32_e32 v7, s41, v7
		v_add_u32_e32 v7, s20, v7
		v_readfirstlane_b32 s41, v5
		v_accvgpr_read_b32 v5, a10
		s_nop 0
		v_add_u32_e32 v5, s41, v5
		v_add_u32_e32 v5, s20, v5
		v_xor_b32_e32 v8, 1, v10
		v_accvgpr_write_b32 a9, v8
		v_xor_b32_e32 v8, 2, v10
		v_accvgpr_write_b32 a10, v8
		v_xor_b32_e32 v8, 3, v10
		v_accvgpr_write_b32 a63, v8
		v_xor_b32_e32 v8, 8, v10
		v_accvgpr_write_b32 a70, v8
		v_xor_b32_e32 v8, 9, v10
		v_accvgpr_write_b32 a73, v8
		v_xor_b32_e32 v8, 10, v10
		v_accvgpr_write_b32 a74, v8
		v_xor_b32_e32 v8, 11, v10
		v_accvgpr_write_b32 a75, v8
		v_xor_b32_e32 v8, 16, v10
		v_accvgpr_write_b32 a76, v8
		v_xor_b32_e32 v8, 17, v10
		v_accvgpr_write_b32 a77, v8
		v_xor_b32_e32 v8, 18, v10
		v_accvgpr_write_b32 a78, v8
		v_xor_b32_e32 v8, 19, v10
		v_accvgpr_write_b32 a79, v8
		v_xor_b32_e32 v8, 24, v10
		v_accvgpr_write_b32 a80, v8
		v_xor_b32_e32 v8, 25, v10
		v_accvgpr_write_b32 a81, v8
		v_xor_b32_e32 v8, 26, v10
		v_accvgpr_write_b32 a82, v8
		v_xor_b32_e32 v8, 27, v10
		v_accvgpr_write_b32 a83, v8
		v_xor_b32_e32 v8, 32, v10
		v_accvgpr_write_b32 a84, v8
		v_xor_b32_e32 v8, 33, v10
		v_accvgpr_write_b32 a85, v8
		v_xor_b32_e32 v8, 34, v10
		v_accvgpr_write_b32 a86, v8
		v_xor_b32_e32 v8, 35, v10
		v_accvgpr_write_b32 a87, v8
		v_xor_b32_e32 v8, 40, v10
		v_accvgpr_write_b32 a88, v8
		v_xor_b32_e32 v8, 41, v10
		v_accvgpr_write_b32 a89, v8
		v_xor_b32_e32 v8, 42, v10
		v_accvgpr_write_b32 a90, v8
		v_xor_b32_e32 v8, 43, v10
		v_accvgpr_write_b32 a91, v8
		v_xor_b32_e32 v8, 48, v10
		v_accvgpr_write_b32 a92, v8
		v_xor_b32_e32 v8, 49, v10
		v_accvgpr_write_b32 a93, v8
		v_xor_b32_e32 v8, 50, v10
		v_accvgpr_write_b32 a94, v8
		v_xor_b32_e32 v8, 51, v10
		v_accvgpr_write_b32 a95, v8
		v_xor_b32_e32 v8, 56, v10
		v_accvgpr_write_b32 a96, v8
		v_xor_b32_e32 v8, 57, v10
		v_accvgpr_write_b32 a97, v8
		v_xor_b32_e32 v8, 58, v10
		v_accvgpr_write_b32 a98, v8
		v_xor_b32_e32 v8, 59, v10
		v_accvgpr_write_b32 a99, v8
		v_xor_b32_e32 v8, 64, v10
		v_accvgpr_write_b32 a100, v8
		v_xor_b32_e32 v8, 0x41, v10
		v_accvgpr_write_b32 a101, v8
		v_xor_b32_e32 v8, 0x42, v10
		v_accvgpr_write_b32 a102, v8
		v_xor_b32_e32 v8, 0x43, v10
		v_accvgpr_write_b32 a103, v8
		v_xor_b32_e32 v8, 0x48, v10
		v_accvgpr_write_b32 a104, v8
		v_xor_b32_e32 v8, 0x49, v10
		v_accvgpr_write_b32 a105, v8
		v_xor_b32_e32 v8, 0x4a, v10
		v_accvgpr_write_b32 a106, v8
		v_xor_b32_e32 v8, 0x4b, v10
		v_accvgpr_write_b32 a107, v8
		v_xor_b32_e32 v8, 0x50, v10
		v_accvgpr_write_b32 a108, v8
		v_xor_b32_e32 v8, 0x51, v10
		v_accvgpr_write_b32 a109, v8
		v_xor_b32_e32 v8, 0x52, v10
		v_accvgpr_write_b32 a110, v8
		v_xor_b32_e32 v8, 0x53, v10
		v_accvgpr_write_b32 a111, v8
		v_xor_b32_e32 v8, 0x58, v10
		v_accvgpr_write_b32 a112, v8
		v_xor_b32_e32 v8, 0x59, v10
		v_accvgpr_write_b32 a113, v8
		v_xor_b32_e32 v8, 0x5a, v10
		v_accvgpr_write_b32 a114, v8
		v_xor_b32_e32 v8, 0x5b, v10
		v_accvgpr_write_b32 a115, v8
		v_xor_b32_e32 v8, 0x60, v10
		v_accvgpr_write_b32 a116, v8
		v_xor_b32_e32 v8, 0x61, v10
		v_accvgpr_write_b32 a117, v8
		v_xor_b32_e32 v8, 0x62, v10
		v_accvgpr_write_b32 a118, v8
		v_xor_b32_e32 v8, 0x63, v10
		v_accvgpr_write_b32 a119, v8
		v_xor_b32_e32 v8, 0x68, v10
		v_accvgpr_write_b32 a120, v8
		v_xor_b32_e32 v8, 0x69, v10
		v_accvgpr_write_b32 a121, v8
		v_xor_b32_e32 v8, 0x6a, v10
		v_accvgpr_write_b32 a122, v8
		v_xor_b32_e32 v8, 0x6b, v10
		v_accvgpr_write_b32 a123, v8
		v_xor_b32_e32 v8, 0x70, v10
		v_accvgpr_write_b32 a124, v8
		v_xor_b32_e32 v8, 0x71, v10
		v_accvgpr_write_b32 a125, v8
		v_xor_b32_e32 v8, 0x72, v10
		v_accvgpr_write_b32 a126, v8
		v_xor_b32_e32 v8, 0x73, v10
		v_accvgpr_write_b32 a127, v8
		v_xor_b32_e32 v8, 0x78, v10
		v_accvgpr_write_b32 a128, v8
		v_xor_b32_e32 v8, 0x79, v10
		v_accvgpr_write_b32 a129, v8
		v_xor_b32_e32 v8, 0x7a, v10
		v_accvgpr_write_b32 a130, v8
		v_xor_b32_e32 v8, 0x7b, v10
		v_accvgpr_write_b32 a131, v8
		v_accvgpr_read_b32 v8, a18
		v_accvgpr_read_b32 v11, a64
		v_lshl_add_u32 v8, v8, 4, v11
		v_accvgpr_read_b32 v11, a65
		v_accvgpr_read_b32 v15, a66
		v_add3_u32 v8, v8, v11, v15
		v_accvgpr_read_b32 v11, a67
		v_accvgpr_read_b32 v15, a68
		v_add3_u32 v8, v8, v11, v15
		v_accvgpr_write_b32 a18, v8
		v_accvgpr_read_b32 v8, a69
		v_accvgpr_read_b32 v11, a71
		v_lshl_add_u32 v8, v8, 3, v11
		v_accvgpr_read_b32 v11, a72
		v_accvgpr_read_b32 v15, a58
		v_add3_u32 v8, v8, v15, v11
		v_accvgpr_write_b32 a58, v8
		s_cmp_lt_i32 s46, s29
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_4
.L_attn_fwd_persistent.loop_head_4:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s20, s46, 0x80
		s_cmp_lt_i32 s46, 0
		s_cselect_b32 s41, s40, 0
		s_add_i32 s41, s46, s41
		s_ashr_i32 s41, s41, 7
		s_cmp_lt_i32 s41, 0
		s_cselect_b32 s42, s16, 0
		s_add_i32 s42, s41, s42
		s_ashr_i32 s42, s42, 1
		s_lshl_b32 s42, s42, 1
		s_xor_b32 s42, s42, -1
		s_add_i32 s42, s42, 1
		s_add_i32 s42, s41, s42
		s_add_i32 s41, s41, 1
		s_cmp_lt_i32 s41, 0
		s_cselect_b32 s43, s16, 0
		s_add_i32 s43, s41, s43
		s_ashr_i32 s43, s43, 1
		s_lshl_b32 s43, s43, 1
		s_xor_b32 s43, s43, -1
		s_add_i32 s43, s43, 1
		s_add_i32 s48, s41, s43
		s_mul_i32 s41, 0x4100, s42
		v_accvgpr_read_b32 v8, a18
		v_add_u32_e32 v8, s41, v8
		ds_read_b128 a[64:67], v8
		ds_read_b128 a[132:135], v8 offset:32
		ds_read_b128 a[136:139], v8 offset:64
		ds_read_b128 a[140:143], v8 offset:96
		ds_read_b128 a[144:147], v8 offset:256
		ds_read_b128 a[148:151], v8 offset:288
		ds_read_b128 a[152:155], v8 offset:320
		ds_read_b128 a[156:159], v8 offset:352
		ds_read_b128 a[160:163], v8 offset:128
		ds_read_b128 a[164:167], v8 offset:160
		ds_read_b128 a[168:171], v8 offset:192
		ds_read_b128 a[172:175], v8 offset:224
		ds_read_b128 a[176:179], v8 offset:384
		ds_read_b128 a[180:183], v8 offset:416
		ds_read_b128 a[184:187], v8 offset:448
		ds_read_b128 a[188:191], v8 offset:480
		s_mul_i32 s41, 0x4400, s42
		v_accvgpr_read_b32 v8, a58
		v_add_u32_e32 v8, s41, v8
		ds_read_b64_tr_b16 a[192:193], v8 offset:33264
		ds_read_b64_tr_b16 a[194:195], v8 offset:37616
		ds_read_b64_tr_b16 a[196:197], v8 offset:33392
		ds_read_b64_tr_b16 a[198:199], v8 offset:37744
		ds_read_b64_tr_b16 a[200:201], v8 offset:33520
		ds_read_b64_tr_b16 a[202:203], v8 offset:37872
		ds_read_b64_tr_b16 a[204:205], v8 offset:33648
		ds_read_b64_tr_b16 a[206:207], v8 offset:38000
		ds_read_b64_tr_b16 a[208:209], v8 offset:33776
		ds_read_b64_tr_b16 a[210:211], v8 offset:38128
		ds_read_b64_tr_b16 a[212:213], v8 offset:33904
		ds_read_b64_tr_b16 a[214:215], v8 offset:38256
		ds_read_b64_tr_b16 a[216:217], v8 offset:34032
		ds_read_b64_tr_b16 a[218:219], v8 offset:38384
		ds_read_b64_tr_b16 a[220:221], v8 offset:34160
		ds_read_b64_tr_b16 a[222:223], v8 offset:38512
		ds_read_b64_tr_b16 a[224:225], v8 offset:33328
		ds_read_b64_tr_b16 a[226:227], v8 offset:37680
		ds_read_b64_tr_b16 a[228:229], v8 offset:33456
		ds_read_b64_tr_b16 a[230:231], v8 offset:37808
		ds_read_b64_tr_b16 a[232:233], v8 offset:33584
		ds_read_b64_tr_b16 a[234:235], v8 offset:37936
		ds_read_b64_tr_b16 a[236:237], v8 offset:33712
		ds_read_b64_tr_b16 a[238:239], v8 offset:38064
		ds_read_b64_tr_b16 a[240:241], v8 offset:33840
		ds_read_b64_tr_b16 a[242:243], v8 offset:38192
		ds_read_b64_tr_b16 a[244:245], v8 offset:33968
		ds_read_b64_tr_b16 a[246:247], v8 offset:38320
		ds_read_b64_tr_b16 a[248:249], v8 offset:34096
		ds_read_b64_tr_b16 a[250:251], v8 offset:38448
		ds_read_b64_tr_b16 a[252:253], v8 offset:34224
		ds_read_b64_tr_b16 a[254:255], v8 offset:38576
		s_cmp_lt_i32 s20, s28
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_4
		v_accvgpr_read_b32 v8, a19
		v_add_u32_e32 v8, s20, v8
		v_accvgpr_read_b32 v11, a52
		v_add_u32_e32 v11, s20, v11
		v_accvgpr_read_b32 v15, a53
		v_add_u32_e32 v15, s20, v15
		v_accvgpr_read_b32 v16, a54
		v_add_u32_e32 v16, s20, v16
		v_cmp_lt_i32_e64 vcc, v8, s22
		s_mov_b64 s[42:43], vcc
		v_cmp_lt_i32_e64 vcc, v11, s22
		s_mov_b64 s[50:51], vcc
		v_cmp_lt_i32_e64 vcc, v15, s22
		s_mov_b64 s[52:53], vcc
		v_cmp_lt_i32_e64 vcc, v16, s22
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v8, a55
		v_add_u32_e32 v8, s20, v8
		v_accvgpr_read_b32 v11, a56
		v_add_u32_e32 v11, s20, v11
		v_accvgpr_read_b32 v15, a57
		v_add_u32_e32 v15, s20, v15
		v_cmp_lt_i32_e64 vcc, v8, s22
		s_mov_b64 s[58:59], vcc
		v_cmp_lt_i32_e64 vcc, v11, s22
		s_mov_b64 s[60:61], vcc
		v_cmp_lt_i32_e64 vcc, v15, s22
		s_mov_b64 s[62:63], vcc
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s41, s15, s46
		s_lshl_b32 s41, s41, 1
		s_add_i32 s41, s47, s41
		v_accvgpr_read_b32 v8, a60
		v_add_u32_e32 v8, s41, v8
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
		v_cndmask_b32_e64 v8, v20, v8, s[42:43]
		buffer_load_dwordx4 v8, s[32:35], 0 offen lds
		v_accvgpr_read_b32 v8, a61
		v_add_u32_e32 v8, s20, v8
		v_accvgpr_read_b32 v11, a62
		v_add_u32_e32 v11, s41, v11
		s_add_u32 s42, s68, 0x1040
		s_addc_u32 s43, s69, 0
		s_add_u32 s42, s42, s70
		s_addc_u32 s43, s43, s71
		s_add_u32 s66, s42, 0
		s_addc_u32 s67, s43, 0
		s_mov_b32 m0, s66
		v_cndmask_b32_e64 v11, v20, v11, s[50:51]
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		v_add_u32_e32 v11, s41, v12
		s_add_u32 s42, s68, 0x2080
		s_addc_u32 s43, s69, 0
		s_add_u32 s42, s42, s70
		s_addc_u32 s43, s43, s71
		s_add_u32 s50, s42, 0
		s_addc_u32 s51, s43, 0
		s_mov_b32 m0, s50
		v_cndmask_b32_e64 v11, v20, v11, s[52:53]
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		v_add_u32_e32 v11, s41, v6
		s_add_u32 s42, s68, 0x30c0
		s_addc_u32 s43, s69, 0
		s_add_u32 s42, s42, s70
		s_addc_u32 s43, s43, s71
		s_add_u32 s50, s42, 0
		s_addc_u32 s51, s43, 0
		s_mov_b32 m0, s50
		v_cndmask_b32_e64 v11, v20, v11, s[54:55]
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		s_mul_i32 s41, s18, s46
		s_lshl_b32 s41, s41, 1
		s_add_i32 s41, s44, s41
		v_add_u32_e32 v11, s41, v13
		s_mov_b32 s42, 0x440
		s_mov_b32 s43, 0
		s_mul_i32 s50, s42, s64
		s_mul_hi_u32 s51, s42, s64
		s_mul_i32 s45, s42, s65
		s_add_i32 s51, s51, s45
		s_mul_i32 s45, s43, s64
		s_add_i32 s51, s51, s45
		s_add_u32 s42, s50, 0x81f0
		s_addc_u32 s43, s51, 0
		s_mov_b32 s52, 0x4400
		s_mov_b32 s53, 0
		s_mul_i32 s54, s52, s48
		s_mul_hi_u32 s55, s52, s48
		s_mul_i32 s45, s52, s49
		s_add_i32 s55, s55, s45
		s_mul_i32 s45, s53, s48
		s_add_i32 s55, s55, s45
		s_add_u32 s42, s42, s54
		s_addc_u32 s43, s43, s55
		s_add_u32 s48, s42, 0
		s_addc_u32 s49, s43, 0
		s_mov_b32 m0, s48
		v_cndmask_b32_e64 v11, v20, v11, s[58:59]
		buffer_load_dwordx4 v11, s[36:39], 0 offen lds
		v_add_u32_e32 v11, s41, v4
		s_add_u32 s42, s50, 0x92f0
		s_addc_u32 s43, s51, 0
		s_add_u32 s42, s42, s54
		s_addc_u32 s43, s43, s55
		s_add_u32 s48, s42, 0
		s_addc_u32 s49, s43, 0
		s_mov_b32 m0, s48
		v_cndmask_b32_e64 v11, v20, v11, s[60:61]
		buffer_load_dwordx4 v11, s[36:39], 0 offen lds
		v_add_u32_e32 v11, s41, v9
		s_add_u32 s42, s50, 0xa3f0
		s_addc_u32 s43, s51, 0
		s_add_u32 s42, s42, s54
		s_addc_u32 s43, s43, s55
		s_add_u32 s48, s42, 0
		s_addc_u32 s49, s43, 0
		s_mov_b32 m0, s48
		v_cndmask_b32_e64 v11, v20, v11, s[62:63]
		buffer_load_dwordx4 v11, s[36:39], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v8, s22
		v_add_u32_e32 v8, s41, v3
		s_add_u32 s42, s50, 0xb4f0
		s_addc_u32 s43, s51, 0
		v_cndmask_b32_e32 v8, v20, v8, vcc
		s_add_u32 s42, s42, s54
		s_addc_u32 s43, s43, s55
		s_add_u32 s48, s42, 0
		s_addc_u32 s49, s43, 0
		s_mov_b32 m0, s48
		s_nop 0
		buffer_load_dwordx4 v8, s[36:39], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_4
.L_attn_fwd_persistent.if_else_4:
.L_attn_fwd_persistent.if_end_4:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[96:111], a[64:67], a[20:23], 0
		s_mov_b32 m0, s17
		v_add_u32_e32 v8, s46, v10
		ds_write_addtid_b32 v8
		v_accvgpr_read_b32 v11, a9
		v_add_u32_e32 v11, s46, v11
		v_accvgpr_read_b32 v15, a10
		v_add_u32_e32 v15, s46, v15
		v_accvgpr_read_b32 v16, a63
		v_add_u32_e32 v16, s46, v16
		v_accvgpr_read_b32 v17, a74
		v_add_u32_e32 v17, s46, v17
		v_accvgpr_read_b32 v18, a75
		v_add_u32_e32 v18, s46, v18
		v_accvgpr_read_b32 v24, a78
		v_add_u32_e32 v24, s46, v24
		v_mfma_f32_32x32x16_bf16 v[112:127], a[144:147], a[20:23], 0
		v_accvgpr_read_b32 v25, a79
		v_add_u32_e32 v25, s46, v25
		v_accvgpr_read_b32 v26, a82
		v_add_u32_e32 v26, s46, v26
		v_accvgpr_read_b32 v27, a83
		v_add_u32_e32 v27, s46, v27
		v_accvgpr_read_b32 v28, a86
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_read_b32 v29, a87
		v_add_u32_e32 v29, s46, v29
		v_accvgpr_read_b32 v30, a90
		v_add_u32_e32 v30, s46, v30
		v_accvgpr_read_b32 v31, a91
		v_add_u32_e32 v31, s46, v31
		v_mfma_f32_32x32x16_bf16 v[128:143], a[160:163], a[20:23], 0
		v_accvgpr_read_b32 v144, a94
		v_add_u32_e32 v144, s46, v144
		v_accvgpr_read_b32 v145, a95
		v_add_u32_e32 v145, s46, v145
		v_accvgpr_read_b32 v146, a98
		v_add_u32_e32 v146, s46, v146
		v_accvgpr_read_b32 v147, a99
		v_add_u32_e32 v147, s46, v147
		v_accvgpr_read_b32 v148, a102
		v_add_u32_e32 v148, s46, v148
		v_accvgpr_read_b32 v149, a103
		v_add_u32_e32 v149, s46, v149
		v_accvgpr_read_b32 v150, a106
		v_add_u32_e32 v150, s46, v150
		v_mfma_f32_32x32x16_bf16 v[160:175], a[176:179], a[20:23], 0
		v_accvgpr_read_b32 v151, a107
		v_add_u32_e32 v151, s46, v151
		v_accvgpr_read_b32 v152, a110
		v_add_u32_e32 v152, s46, v152
		v_accvgpr_read_b32 v153, a111
		v_add_u32_e32 v153, s46, v153
		v_accvgpr_read_b32 v154, a114
		v_add_u32_e32 v154, s46, v154
		v_accvgpr_read_b32 v155, a115
		v_add_u32_e32 v155, s46, v155
		v_accvgpr_read_b32 v156, a118
		v_add_u32_e32 v156, s46, v156
		v_accvgpr_write_b32 a68, v156
		v_accvgpr_read_b32 v156, a119
		v_add_u32_e32 v156, s46, v156
		v_accvgpr_write_b32 a69, v156
		v_mfma_f32_32x32x16_bf16 v[176:191], a[176:179], a[36:39], 0
		v_accvgpr_read_b32 v156, a122
		v_add_u32_e32 v156, s46, v156
		v_accvgpr_write_b32 a71, v156
		v_accvgpr_read_b32 v156, a123
		v_add_u32_e32 v156, s46, v156
		v_accvgpr_write_b32 a72, v156
		v_accvgpr_read_b32 v156, a126
		v_add_u32_e32 v156, s46, v156
		v_accvgpr_write_b32 a176, v156
		v_accvgpr_read_b32 v156, a127
		v_add_u32_e32 v156, s46, v156
		v_accvgpr_write_b32 a177, v156
		v_accvgpr_read_b32 v156, a130
		v_add_u32_e32 v156, s46, v156
		v_accvgpr_write_b32 a178, v156
		v_accvgpr_read_b32 v156, a131
		v_add_u32_e32 v156, s46, v156
		v_accvgpr_write_b32 a179, v156
		v_cmp_ge_i32_e64 vcc, v7, v8
		s_mov_b64 s[42:43], vcc
		v_mfma_f32_32x32x16_bf16 v[192:207], a[64:67], a[36:39], 0
		v_cmp_ge_i32_e64 vcc, v7, v11
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v7, v15
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v7, v16
		v_accvgpr_read_b32 v8, a70
		v_add_u32_e32 v8, s46, v8
		v_accvgpr_read_b32 v156, a73
		v_add_u32_e32 v156, s46, v156
		v_accvgpr_read_b32 v157, a76
		v_add_u32_e32 v157, s46, v157
		v_accvgpr_read_b32 v158, a77
		v_add_u32_e32 v158, s46, v158
		v_mfma_f32_32x32x16_bf16 v[208:223], a[144:147], a[36:39], 0
		v_accvgpr_read_b32 v159, a80
		v_add_u32_e32 v159, s46, v159
		v_accvgpr_read_b32 v224, a81
		v_add_u32_e32 v224, s46, v224
		v_accvgpr_read_b32 v225, a84
		v_add_u32_e32 v225, s46, v225
		v_accvgpr_read_b32 v226, a85
		v_add_u32_e32 v226, s46, v226
		v_accvgpr_read_b32 v227, a88
		v_add_u32_e32 v227, s46, v227
		v_accvgpr_read_b32 v228, a89
		v_add_u32_e32 v228, s46, v228
		v_accvgpr_read_b32 v229, a92
		v_add_u32_e32 v229, s46, v229
		v_mfma_f32_32x32x16_bf16 v[240:255], a[160:163], a[36:39], 0
		v_accvgpr_read_b32 v230, a93
		v_add_u32_e32 v230, s46, v230
		v_accvgpr_read_b32 v231, a96
		v_add_u32_e32 v231, s46, v231
		v_accvgpr_read_b32 v232, a97
		v_add_u32_e32 v232, s46, v232
		v_accvgpr_write_b32 a64, v232
		v_accvgpr_read_b32 v232, a100
		v_add_u32_e32 v232, s46, v232
		v_accvgpr_write_b32 a65, v232
		v_accvgpr_read_b32 v232, a101
		v_add_u32_e32 v232, s46, v232
		v_accvgpr_write_b32 a66, v232
		v_accvgpr_read_b32 v232, a104
		v_add_u32_e32 v232, s46, v232
		v_accvgpr_write_b32 a67, v232
		v_accvgpr_read_b32 v232, a105
		v_add_u32_e32 v232, s46, v232
		v_accvgpr_write_b32 a144, v232
		v_mfma_f32_32x32x16_bf16 v[96:111], a[132:135], a[24:27], v[96:111]
		v_accvgpr_read_b32 v232, a108
		v_add_u32_e32 v232, s46, v232
		v_accvgpr_write_b32 a145, v232
		v_accvgpr_read_b32 v232, a109
		v_add_u32_e32 v232, s46, v232
		v_accvgpr_write_b32 a146, v232
		v_accvgpr_read_b32 v232, a112
		v_add_u32_e32 v232, s46, v232
		v_accvgpr_write_b32 a147, v232
		v_accvgpr_read_b32 v232, a113
		v_add_u32_e32 v232, s46, v232
		v_accvgpr_write_b32 a160, v232
		v_accvgpr_read_b32 v232, a116
		v_add_u32_e32 v232, s46, v232
		v_accvgpr_write_b32 a161, v232
		v_accvgpr_read_b32 v232, a117
		v_add_u32_e32 v232, s46, v232
		v_accvgpr_write_b32 a162, v232
		v_accvgpr_read_b32 v232, a120
		v_add_u32_e32 v232, s46, v232
		v_accvgpr_write_b32 a163, v232
		v_mfma_f32_32x32x16_bf16 v[112:127], a[148:151], a[24:27], v[112:127]
		v_accvgpr_read_b32 v232, a121
		v_add_u32_e32 v232, s46, v232
		v_accvgpr_read_b32 v233, a124
		v_add_u32_e32 v233, s46, v233
		v_accvgpr_read_b32 v234, a125
		v_add_u32_e32 v234, s46, v234
		v_accvgpr_read_b32 v235, a128
		v_add_u32_e32 v235, s46, v235
		v_accvgpr_read_b32 v236, a129
		v_add_u32_e32 v236, s46, v236
		v_mfma_f32_32x32x16_bf16 v[128:143], a[164:167], a[24:27], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[24:27], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[180:183], a[40:43], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[132:135], a[40:43], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[148:151], a[40:43], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[164:167], a[40:43], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[136:139], a[28:31], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[152:155], a[28:31], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[168:171], a[28:31], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[184:187], a[28:31], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[184:187], a[44:47], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[136:139], a[44:47], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[152:155], a[44:47], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[168:171], a[44:47], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[140:143], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[156:159], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[172:175], a[32:35], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[188:191], a[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[188:191], a[48:51], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[140:143], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[156:159], a[48:51], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[172:175], a[48:51], v[240:255]
		s_cmp_lt_i32 s20, s29
		v_mov_b32_e32 v237, 0xff800000
		v_accvgpr_write_b32 a132, v237
		v_accvgpr_read_b32 v237, a132
		s_nop 0
		v_cndmask_b32_e32 v99, v237, v99, vcc
		v_accvgpr_write_b32 a135, v99
		v_cmp_ge_i32_e64 vcc, v7, v8
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v7, v156
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v7, v17
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v7, v18
		v_accvgpr_read_b32 v99, a132
		v_cndmask_b32_e64 v96, v99, v96, s[42:43]
		v_accvgpr_write_b32 a136, v96
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v96, v96, v97, s[48:49]
		v_accvgpr_write_b32 a137, v96
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e32 v96, v96, v103, vcc
		v_accvgpr_write_b32 a139, v96
		v_cmp_ge_i32_e64 vcc, v7, v157
		s_mov_b64 s[42:43], vcc
		v_cmp_ge_i32_e64 vcc, v7, v158
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v7, v24
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v7, v25
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v96, v96, v98, s[50:51]
		v_accvgpr_write_b32 a134, v96
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v98, v96, v100, s[52:53]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e32 v96, v96, v107, vcc
		v_accvgpr_write_b32 a141, v96
		v_cmp_ge_i32_e64 vcc, v7, v159
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v7, v224
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v7, v26
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v7, v27
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v99, v96, v101, s[54:55]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v96, v96, v102, s[58:59]
		v_accvgpr_write_b32 a138, v96
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e32 v101, v96, v111, vcc
		v_cmp_ge_i32_e64 vcc, v7, v225
		s_mov_b64 s[54:55], vcc
		v_cmp_ge_i32_e64 vcc, v7, v226
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v7, v28
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v7, v29
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v102, v96, v104, s[42:43]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v103, v96, v105, s[48:49]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e32 v96, v96, v115, vcc
		v_accvgpr_write_b32 a143, v96
		v_cmp_ge_i32_e64 vcc, v7, v227
		s_mov_b64 s[42:43], vcc
		v_cmp_ge_i32_e64 vcc, v7, v228
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v7, v30
		s_mov_b64 s[66:67], vcc
		v_cmp_ge_i32_e64 vcc, v7, v31
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v96, v96, v106, s[60:61]
		v_accvgpr_write_b32 a140, v96
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v104, v96, v108, s[50:51]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e32 v96, v96, v119, vcc
		v_accvgpr_write_b32 a149, v96
		v_cmp_ge_i32_e64 vcc, v7, v229
		s_mov_b64 s[50:51], vcc
		v_cmp_ge_i32_e64 vcc, v7, v230
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v7, v144
		s_mov_b64 s[68:69], vcc
		v_cmp_ge_i32_e64 vcc, v7, v145
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v105, v96, v109, s[52:53]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v100, v96, v110, s[62:63]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e32 v107, v96, v123, vcc
		v_cmp_ge_i32_e64 vcc, v7, v231
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v96, a64
		v_cmp_ge_i32_e64 vcc, v7, v96
		s_mov_b64 s[62:63], vcc
		v_cmp_ge_i32_e64 vcc, v7, v146
		s_mov_b64 s[70:71], vcc
		v_cmp_ge_i32_e64 vcc, v7, v147
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v108, v96, v112, s[54:55]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v109, v96, v113, s[58:59]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e32 v111, v96, v127, vcc
		v_accvgpr_read_b32 v96, a65
		v_cmp_ge_i32_e64 vcc, v7, v96
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v96, a66
		v_cmp_ge_i32_e64 vcc, v7, v96
		s_mov_b64 s[58:59], vcc
		v_cmp_ge_i32_e64 vcc, v7, v148
		s_mov_b64 s[72:73], vcc
		v_cmp_ge_i32_e64 vcc, v7, v149
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v96, v96, v114, s[64:65]
		v_accvgpr_write_b32 a142, v96
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v112, v96, v116, s[42:43]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e32 v115, v96, v131, vcc
		v_accvgpr_read_b32 v96, a67
		v_cmp_ge_i32_e64 vcc, v7, v96
		s_mov_b64 s[42:43], vcc
		v_accvgpr_read_b32 v96, a144
		v_cmp_ge_i32_e64 vcc, v7, v96
		s_mov_b64 s[64:65], vcc
		v_cmp_ge_i32_e64 vcc, v7, v150
		s_mov_b64 s[74:75], vcc
		v_cmp_ge_i32_e64 vcc, v7, v151
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v113, v96, v117, s[48:49]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v96, v96, v118, s[66:67]
		v_accvgpr_write_b32 a148, v96
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e32 v117, v96, v135, vcc
		v_accvgpr_read_b32 v96, a145
		v_cmp_ge_i32_e64 vcc, v7, v96
		s_mov_b64 s[48:49], vcc
		v_accvgpr_read_b32 v96, a146
		v_cmp_ge_i32_e64 vcc, v7, v96
		s_mov_b64 s[66:67], vcc
		v_cmp_ge_i32_e64 vcc, v7, v152
		s_mov_b64 s[76:77], vcc
		v_cmp_ge_i32_e64 vcc, v7, v153
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v96, v96, v120, s[50:51]
		v_accvgpr_write_b32 a150, v96
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v96, v96, v121, s[60:61]
		v_accvgpr_write_b32 a151, v96
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e32 v119, v96, v139, vcc
		v_accvgpr_read_b32 v96, a147
		v_cmp_ge_i32_e64 vcc, v7, v96
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v96, a160
		v_cmp_ge_i32_e64 vcc, v7, v96
		s_mov_b64 s[60:61], vcc
		v_cmp_ge_i32_e64 vcc, v7, v154
		s_mov_b64 s[78:79], vcc
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v121, v96, v141, s[60:61]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v238, v96, v142, s[78:79]
		v_cmp_ge_i32_e64 vcc, v7, v155
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v106, v96, v122, s[68:69]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v122, v96, v124, s[52:53]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e32 v239, v96, v143, vcc
		v_accvgpr_read_b32 v96, a161
		v_cmp_ge_i32_e64 vcc, v7, v96
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v96, a162
		v_cmp_ge_i32_e64 vcc, v7, v96
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v96, a68
		v_cmp_ge_i32_e64 vcc, v7, v96
		s_mov_b64 s[68:69], vcc
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v142, v96, v160, s[52:53]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v143, v96, v161, s[60:61]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v160, v96, v162, s[68:69]
		v_accvgpr_read_b32 v96, a69
		v_cmp_ge_i32_e64 vcc, v7, v96
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v123, v96, v125, s[62:63]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v110, v96, v126, s[70:71]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e32 v161, v96, v163, vcc
		v_accvgpr_read_b32 v96, a163
		v_cmp_ge_i32_e64 vcc, v7, v96
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v7, v232
		s_mov_b64 s[60:61], vcc
		v_accvgpr_read_b32 v96, a71
		v_cmp_ge_i32_e64 vcc, v7, v96
		s_mov_b64 s[62:63], vcc
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v124, v96, v164, s[52:53]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v125, v96, v165, s[60:61]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v126, v96, v166, s[62:63]
		v_accvgpr_read_b32 v96, a72
		v_cmp_ge_i32_e64 vcc, v7, v96
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v162, v96, v128, s[54:55]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v163, v96, v129, s[58:59]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e32 v127, v96, v167, vcc
		v_cmp_ge_i32_e64 vcc, v7, v233
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v7, v234
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v96, a176
		v_cmp_ge_i32_e64 vcc, v7, v96
		s_mov_b64 s[58:59], vcc
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v128, v96, v168, s[52:53]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v129, v96, v169, s[54:55]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v164, v96, v170, s[58:59]
		v_accvgpr_read_b32 v96, a177
		v_cmp_ge_i32_e64 vcc, v7, v96
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v114, v96, v130, s[72:73]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v130, v96, v132, s[42:43]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e32 v165, v96, v171, vcc
		v_cmp_ge_i32_e64 vcc, v7, v235
		s_mov_b64 s[42:43], vcc
		v_cmp_ge_i32_e64 vcc, v7, v236
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v96, a178
		v_cmp_ge_i32_e64 vcc, v7, v96
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v166, v96, v172, s[42:43]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v167, v96, v173, s[52:53]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v168, v96, v174, s[54:55]
		v_accvgpr_read_b32 v96, a179
		v_cmp_ge_i32_e64 vcc, v7, v96
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v131, v96, v133, s[64:65]
		v_accvgpr_read_b32 v96, a132
		v_cndmask_b32_e64 v116, v96, v134, s[74:75]
		v_accvgpr_read_b32 v96, a132
		s_mov_b32 m0, s17
		v_cndmask_b32_e32 v169, v96, v175, vcc
		s_waitcnt lgkmcnt(0)
		ds_read_addtid_b32 v96
		s_waitcnt lgkmcnt(0)
		v_cmp_ge_i32_e64 vcc, v5, v96
		s_mov_b64 s[42:43], vcc
		v_cmp_ge_i32_e64 vcc, v5, v11
		s_mov_b64 s[52:53], vcc
		v_cmp_ge_i32_e64 vcc, v5, v15
		s_mov_b64 s[54:55], vcc
		v_accvgpr_read_b32 v11, a132
		v_cndmask_b32_e64 v96, v11, v192, s[42:43]
		v_accvgpr_read_b32 v11, a132
		v_cndmask_b32_e64 v97, v11, v193, s[52:53]
		v_accvgpr_read_b32 v11, a132
		v_cndmask_b32_e64 v132, v11, v194, s[54:55]
		v_cmp_ge_i32_e64 vcc, v5, v16
		v_accvgpr_read_b32 v11, a132
		v_cndmask_b32_e64 v134, v11, v136, s[48:49]
		v_accvgpr_read_b32 v11, a132
		v_cndmask_b32_e64 v135, v11, v137, s[66:67]
		v_accvgpr_read_b32 v11, a132
		v_cndmask_b32_e32 v133, v11, v195, vcc
		v_cmp_ge_i32_e64 vcc, v5, v8
		s_mov_b64 s[42:43], vcc
		v_cmp_ge_i32_e64 vcc, v5, v156
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v5, v17
		s_mov_b64 s[52:53], vcc
		v_accvgpr_read_b32 v8, a132
		v_cndmask_b32_e64 v16, v8, v196, s[42:43]
		v_accvgpr_read_b32 v8, a132
		v_cndmask_b32_e64 v17, v8, v197, s[48:49]
		v_accvgpr_read_b32 v8, a132
		v_cndmask_b32_e64 v136, v8, v198, s[52:53]
		v_cmp_ge_i32_e64 vcc, v5, v18
		v_accvgpr_read_b32 v8, a132
		v_cndmask_b32_e64 v118, v8, v138, s[76:77]
		v_accvgpr_read_b32 v8, a132
		v_cndmask_b32_e64 v120, v8, v140, s[50:51]
		v_accvgpr_read_b32 v8, a132
		v_cndmask_b32_e32 v137, v8, v199, vcc
		v_cmp_ge_i32_e64 vcc, v5, v157
		s_mov_b64 s[42:43], vcc
		v_cmp_ge_i32_e64 vcc, v5, v158
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v5, v24
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v8, a132
		v_cndmask_b32_e64 v138, v8, v200, s[42:43]
		v_accvgpr_read_b32 v8, a132
		v_cndmask_b32_e64 v139, v8, v201, s[48:49]
		v_accvgpr_read_b32 v8, a132
		v_cndmask_b32_e64 v140, v8, v202, s[50:51]
		v_cmp_ge_i32_e64 vcc, v5, v25
		v_accvgpr_read_b32 v8, a136
		v_accvgpr_read_b32 v11, a137
		v_max_f32_e32 v8, v8, v11
		v_accvgpr_read_b32 v11, a135
		v_accvgpr_read_b32 v15, a134
		v_max_f32_e32 v11, v15, v11
		v_accvgpr_read_b32 v15, a132
		v_cndmask_b32_e32 v141, v15, v203, vcc
		v_cmp_ge_i32_e64 vcc, v5, v159
		s_mov_b64 s[42:43], vcc
		v_cmp_ge_i32_e64 vcc, v5, v224
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v5, v26
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v15, a132
		v_cndmask_b32_e64 v24, v15, v204, s[42:43]
		v_accvgpr_read_b32 v15, a132
		v_cndmask_b32_e64 v25, v15, v205, s[48:49]
		v_accvgpr_read_b32 v15, a132
		v_cndmask_b32_e64 v156, v15, v206, s[50:51]
		v_cmp_ge_i32_e64 vcc, v5, v27
		v_max_f32_e32 v15, v98, v99
		v_accvgpr_read_b32 v18, a139
		v_accvgpr_read_b32 v26, a138
		v_max_f32_e32 v18, v26, v18
		v_accvgpr_read_b32 v26, a132
		v_cndmask_b32_e32 v157, v26, v207, vcc
		v_cmp_ge_i32_e64 vcc, v5, v225
		s_mov_b64 s[42:43], vcc
		v_cmp_ge_i32_e64 vcc, v5, v226
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v5, v28
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v26, a132
		v_cndmask_b32_e64 v158, v26, v208, s[42:43]
		v_accvgpr_read_b32 v26, a132
		v_cndmask_b32_e64 v159, v26, v209, s[48:49]
		v_accvgpr_read_b32 v26, a132
		v_cndmask_b32_e64 v170, v26, v210, s[50:51]
		v_cmp_ge_i32_e64 vcc, v5, v29
		v_max_f32_e32 v26, v102, v103
		v_accvgpr_read_b32 v27, a141
		v_accvgpr_read_b32 v28, a140
		v_max_f32_e32 v27, v28, v27
		v_accvgpr_read_b32 v28, a132
		v_cndmask_b32_e32 v171, v28, v211, vcc
		v_cmp_ge_i32_e64 vcc, v5, v227
		s_mov_b64 s[42:43], vcc
		v_cmp_ge_i32_e64 vcc, v5, v228
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v5, v30
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v28, a132
		v_cndmask_b32_e64 v172, v28, v212, s[42:43]
		v_accvgpr_read_b32 v28, a132
		v_cndmask_b32_e64 v173, v28, v213, s[48:49]
		v_accvgpr_read_b32 v28, a132
		v_cndmask_b32_e64 v174, v28, v214, s[50:51]
		v_cmp_ge_i32_e64 vcc, v5, v31
		v_max_f32_e32 v28, v104, v105
		v_max_f32_e32 v29, v100, v101
		v_accvgpr_read_b32 v30, a132
		v_cndmask_b32_e32 v175, v30, v215, vcc
		v_cmp_ge_i32_e64 vcc, v5, v229
		s_mov_b64 s[42:43], vcc
		v_cmp_ge_i32_e64 vcc, v5, v230
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v5, v144
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v30, a132
		v_cndmask_b32_e64 v192, v30, v216, s[42:43]
		v_accvgpr_read_b32 v30, a132
		v_cndmask_b32_e64 v193, v30, v217, s[48:49]
		v_accvgpr_read_b32 v30, a132
		v_cndmask_b32_e64 v194, v30, v218, s[50:51]
		v_cmp_ge_i32_e64 vcc, v5, v145
		v_max_f32_e32 v30, v108, v109
		v_accvgpr_read_b32 v31, a143
		v_accvgpr_read_b32 v144, a142
		v_max_f32_e32 v31, v144, v31
		v_accvgpr_read_b32 v144, a132
		v_cndmask_b32_e32 v195, v144, v219, vcc
		v_cmp_ge_i32_e64 vcc, v5, v231
		s_mov_b64 s[42:43], vcc
		v_accvgpr_read_b32 v144, a64
		v_cmp_ge_i32_e64 vcc, v5, v144
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v5, v146
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v144, a132
		v_cndmask_b32_e64 v196, v144, v220, s[42:43]
		v_accvgpr_read_b32 v144, a132
		v_cndmask_b32_e64 v197, v144, v221, s[48:49]
		v_accvgpr_read_b32 v144, a132
		v_cndmask_b32_e64 v198, v144, v222, s[50:51]
		v_cmp_ge_i32_e64 vcc, v5, v147
		v_max_f32_e32 v144, v112, v113
		v_accvgpr_read_b32 v145, a149
		v_accvgpr_read_b32 v146, a148
		v_max_f32_e32 v145, v146, v145
		v_accvgpr_read_b32 v146, a132
		v_cndmask_b32_e32 v199, v146, v223, vcc
		v_accvgpr_read_b32 v146, a65
		v_cmp_ge_i32_e64 vcc, v5, v146
		s_mov_b64 s[42:43], vcc
		v_accvgpr_read_b32 v146, a66
		v_cmp_ge_i32_e64 vcc, v5, v146
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v5, v148
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v146, a132
		v_cndmask_b32_e64 v200, v146, v240, s[42:43]
		v_accvgpr_read_b32 v146, a132
		v_cndmask_b32_e64 v201, v146, v241, s[48:49]
		v_accvgpr_read_b32 v146, a132
		v_cndmask_b32_e64 v202, v146, v242, s[50:51]
		v_cmp_ge_i32_e64 vcc, v5, v149
		v_accvgpr_read_b32 v146, a150
		v_accvgpr_read_b32 v147, a151
		v_max_f32_e32 v146, v146, v147
		v_max_f32_e32 v147, v106, v107
		v_accvgpr_read_b32 v148, a132
		v_cndmask_b32_e32 v203, v148, v243, vcc
		v_accvgpr_read_b32 v148, a67
		v_cmp_ge_i32_e64 vcc, v5, v148
		s_mov_b64 s[42:43], vcc
		v_accvgpr_read_b32 v148, a144
		v_cmp_ge_i32_e64 vcc, v5, v148
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v5, v150
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v148, a132
		v_cndmask_b32_e64 v204, v148, v244, s[42:43]
		v_accvgpr_read_b32 v148, a132
		v_cndmask_b32_e64 v205, v148, v245, s[48:49]
		v_accvgpr_read_b32 v148, a132
		v_cndmask_b32_e64 v206, v148, v246, s[50:51]
		v_cmp_ge_i32_e64 vcc, v5, v151
		v_max_f32_e32 v148, v122, v123
		v_max_f32_e32 v149, v110, v111
		v_accvgpr_read_b32 v150, a132
		v_cndmask_b32_e32 v207, v150, v247, vcc
		v_accvgpr_read_b32 v150, a145
		v_cmp_ge_i32_e64 vcc, v5, v150
		s_mov_b64 s[42:43], vcc
		v_accvgpr_read_b32 v150, a146
		v_cmp_ge_i32_e64 vcc, v5, v150
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v5, v152
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v150, a132
		v_cndmask_b32_e64 v208, v150, v248, s[42:43]
		v_accvgpr_read_b32 v150, a132
		v_cndmask_b32_e64 v209, v150, v249, s[48:49]
		v_accvgpr_read_b32 v150, a132
		v_cndmask_b32_e64 v210, v150, v250, s[50:51]
		v_cmp_ge_i32_e64 vcc, v5, v153
		v_max_f32_e32 v150, v162, v163
		v_max_f32_e32 v151, v114, v115
		v_accvgpr_read_b32 v152, a132
		v_cndmask_b32_e32 v211, v152, v251, vcc
		v_accvgpr_read_b32 v152, a147
		v_cmp_ge_i32_e64 vcc, v5, v152
		s_mov_b64 s[42:43], vcc
		v_accvgpr_read_b32 v152, a160
		v_cmp_ge_i32_e64 vcc, v5, v152
		s_mov_b64 s[48:49], vcc
		v_cmp_ge_i32_e64 vcc, v5, v154
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v152, a132
		v_cndmask_b32_e64 v212, v152, v252, s[42:43]
		v_accvgpr_read_b32 v152, a132
		v_cndmask_b32_e64 v213, v152, v253, s[48:49]
		v_accvgpr_read_b32 v152, a132
		v_cndmask_b32_e64 v214, v152, v254, s[50:51]
		v_cmp_ge_i32_e64 vcc, v5, v155
		v_max_f32_e32 v152, v130, v131
		v_max_f32_e32 v153, v116, v117
		v_accvgpr_read_b32 v154, a132
		v_cndmask_b32_e32 v215, v154, v255, vcc
		v_accvgpr_read_b32 v154, a161
		v_cmp_ge_i32_e64 vcc, v5, v154
		s_mov_b64 s[42:43], vcc
		v_accvgpr_read_b32 v154, a162
		v_cmp_ge_i32_e64 vcc, v5, v154
		s_mov_b64 s[48:49], vcc
		v_accvgpr_read_b32 v154, a68
		v_cmp_ge_i32_e64 vcc, v5, v154
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v154, a132
		v_cndmask_b32_e64 v216, v154, v176, s[42:43]
		v_accvgpr_read_b32 v154, a132
		v_cndmask_b32_e64 v217, v154, v177, s[48:49]
		v_accvgpr_read_b32 v154, a132
		v_cndmask_b32_e64 v176, v154, v178, s[50:51]
		v_accvgpr_read_b32 v154, a69
		v_cmp_ge_i32_e64 vcc, v5, v154
		v_max_f32_e32 v154, v134, v135
		v_max_f32_e32 v155, v118, v119
		v_accvgpr_read_b32 v177, a132
		v_cndmask_b32_e32 v177, v177, v179, vcc
		v_accvgpr_read_b32 v178, a163
		v_cmp_ge_i32_e64 vcc, v5, v178
		s_mov_b64 s[42:43], vcc
		v_cmp_ge_i32_e64 vcc, v5, v232
		s_mov_b64 s[48:49], vcc
		v_accvgpr_read_b32 v178, a71
		v_cmp_ge_i32_e64 vcc, v5, v178
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v178, a132
		v_cndmask_b32_e64 v218, v178, v180, s[42:43]
		v_accvgpr_read_b32 v178, a132
		v_cndmask_b32_e64 v219, v178, v181, s[48:49]
		v_accvgpr_read_b32 v178, a132
		v_cndmask_b32_e64 v180, v178, v182, s[50:51]
		v_accvgpr_read_b32 v178, a72
		v_cmp_ge_i32_e64 vcc, v5, v178
		v_max_f32_e32 v178, v120, v121
		v_max_f32_e32 v179, v238, v239
		v_accvgpr_read_b32 v181, a132
		v_cndmask_b32_e32 v181, v181, v183, vcc
		v_cmp_ge_i32_e64 vcc, v5, v233
		s_mov_b64 s[42:43], vcc
		v_cmp_ge_i32_e64 vcc, v5, v234
		s_mov_b64 s[48:49], vcc
		v_accvgpr_read_b32 v182, a176
		v_cmp_ge_i32_e64 vcc, v5, v182
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v182, a132
		v_cndmask_b32_e64 v220, v182, v184, s[42:43]
		v_accvgpr_read_b32 v182, a132
		v_cndmask_b32_e64 v221, v182, v185, s[48:49]
		v_accvgpr_read_b32 v182, a132
		v_cndmask_b32_e64 v184, v182, v186, s[50:51]
		v_accvgpr_read_b32 v182, a177
		v_cmp_ge_i32_e64 vcc, v5, v182
		v_max_f32_e32 v182, v142, v143
		v_max_f32_e32 v183, v160, v161
		v_accvgpr_read_b32 v185, a132
		v_cndmask_b32_e32 v185, v185, v187, vcc
		v_cmp_ge_i32_e64 vcc, v5, v235
		s_mov_b64 s[42:43], vcc
		v_cmp_ge_i32_e64 vcc, v5, v236
		s_mov_b64 s[48:49], vcc
		v_accvgpr_read_b32 v186, a178
		v_cmp_ge_i32_e64 vcc, v5, v186
		s_mov_b64 s[50:51], vcc
		v_accvgpr_read_b32 v186, a132
		v_cndmask_b32_e64 v222, v186, v188, s[42:43]
		v_accvgpr_read_b32 v186, a132
		v_cndmask_b32_e64 v223, v186, v189, s[48:49]
		v_accvgpr_read_b32 v186, a132
		v_cndmask_b32_e64 v188, v186, v190, s[50:51]
		v_accvgpr_read_b32 v186, a179
		v_cmp_ge_i32_e64 vcc, v5, v186
		v_max_f32_e32 v186, v124, v125
		v_max_f32_e32 v187, v126, v127
		v_accvgpr_read_b32 v189, a132
		v_cndmask_b32_e32 v189, v189, v191, vcc
		v_max_f32_e32 v190, v128, v129
		v_max_f32_e32 v191, v164, v165
		v_max_f32_e32 v224, v166, v167
		v_max_f32_e32 v225, v168, v169
		v_max_f32_e32 v8, v8, v11
		v_max_f32_e32 v11, v15, v18
		v_max_f32_e32 v15, v26, v27
		v_max_f32_e32 v18, v28, v29
		v_max_f32_e32 v26, v30, v31
		v_max_f32_e32 v27, v144, v145
		v_max_f32_e32 v28, v146, v147
		v_max_f32_e32 v29, v148, v149
		v_max_f32_e32 v30, v150, v151
		v_max_f32_e32 v31, v152, v153
		v_max_f32_e32 v144, v154, v155
		v_max_f32_e32 v145, v178, v179
		v_max_f32_e32 v146, v182, v183
		v_max_f32_e32 v147, v186, v187
		v_max_f32_e32 v148, v190, v191
		v_max_f32_e32 v149, v224, v225
		v_max_f32_e32 v8, v8, v11
		v_max_f32_e32 v11, v15, v18
		v_max_f32_e32 v15, v26, v27
		v_max_f32_e32 v18, v28, v29
		v_max_f32_e32 v26, v30, v31
		v_max_f32_e32 v27, v144, v145
		v_max_f32_e32 v28, v146, v147
		v_max_f32_e32 v29, v148, v149
		v_max_f32_e32 v8, v8, v11
		v_max_f32_e32 v11, v15, v18
		v_max_f32_e32 v15, v26, v27
		v_max_f32_e32 v18, v28, v29
		v_max_f32_e32 v8, v8, v11
		v_max_f32_e32 v11, v15, v18
		v_max_f32_e32 v8, v8, v11
		v_and_b32_e32 v11, 1, v14
		v_lshrrev_b32_e32 v15, 4, v14
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 4, v15
		v_lshrrev_b32_e32 v18, 3, v14
		v_and_b32_e32 v18, 1, v18
		v_lshlrev_b32_e32 v18, 3, v18
		v_add3_u32 v11, v11, v15, v18
		v_lshrrev_b32_e32 v15, 2, v14
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v15, 2, v15
		v_lshrrev_b32_e32 v18, 1, v14
		v_and_b32_e32 v18, 1, v18
		v_lshlrev_b32_e32 v18, 1, v18
		v_add3_u32 v11, v11, v15, v18
		v_lshlrev_b32_e32 v11, 2, v11
		ds_bpermute_b32 v15, v11, v8
		v_lshrrev_b32_e32 v18, 4, v14
		v_and_b32_e32 v18, 1, v18
		v_lshlrev_b32_e32 v18, 4, v18
		v_lshrrev_b32_e32 v26, 3, v14
		v_and_b32_e32 v26, 1, v26
		v_lshlrev_b32_e32 v26, 3, v26
		v_lshrrev_b32_e32 v27, 2, v14
		v_and_b32_e32 v27, 1, v27
		v_lshlrev_b32_e32 v27, 2, v27
		v_and_b32_e32 v28, 1, v14
		v_add_u32_e32 v28, 32, v28
		v_lshrrev_b32_e32 v29, 1, v14
		v_and_b32_e32 v29, 1, v29
		v_lshlrev_b32_e32 v29, 1, v29
		v_bitop3_b32 v27, v27, v28, v29 bitop3:0x96
		v_bitop3_b32 v18, v18, v26, v27 bitop3:0x96
		v_lshlrev_b32_e32 v18, 2, v18
		ds_bpermute_b32 v26, v18, v8
		v_max_f32_e32 v8, v96, v97
		v_max_f32_e32 v27, v132, v133
		v_max_f32_e32 v28, v16, v17
		v_max_f32_e32 v29, v136, v137
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v30, v15, v26
		v_max_f32_e32 v15, v138, v139
		v_max_f32_e32 v26, v140, v141
		v_max_f32_e32 v31, v24, v25
		v_max_f32_e32 v144, v156, v157
		v_max_f32_e32 v145, v158, v159
		v_max_f32_e32 v146, v170, v171
		v_max_f32_e32 v147, v172, v173
		v_max_f32_e32 v148, v174, v175
		v_max_f32_e32 v149, v192, v193
		v_max_f32_e32 v150, v194, v195
		v_max_f32_e32 v151, v196, v197
		v_max_f32_e32 v152, v198, v199
		v_max_f32_e32 v153, v200, v201
		v_max_f32_e32 v154, v202, v203
		v_max_f32_e32 v155, v204, v205
		v_max_f32_e32 v178, v206, v207
		v_max_f32_e32 v179, v208, v209
		v_max_f32_e32 v182, v210, v211
		v_max_f32_e32 v183, v212, v213
		v_max_f32_e32 v186, v214, v215
		v_max_f32_e32 v187, v216, v217
		v_max_f32_e32 v190, v176, v177
		v_max_f32_e32 v191, v218, v219
		v_max_f32_e32 v224, v180, v181
		v_max_f32_e32 v225, v220, v221
		v_max_f32_e32 v226, v184, v185
		v_max_f32_e32 v227, v222, v223
		v_max_f32_e32 v228, v188, v189
		v_max_f32_e32 v8, v8, v27
		v_max_f32_e32 v27, v28, v29
		v_max_f32_e32 v15, v15, v26
		v_max_f32_e32 v26, v31, v144
		v_max_f32_e32 v28, v145, v146
		v_max_f32_e32 v29, v147, v148
		v_max_f32_e32 v31, v149, v150
		v_max_f32_e32 v144, v151, v152
		v_max_f32_e32 v145, v153, v154
		v_max_f32_e32 v146, v155, v178
		v_max_f32_e32 v147, v179, v182
		v_max_f32_e32 v148, v183, v186
		v_max_f32_e32 v149, v187, v190
		v_max_f32_e32 v150, v191, v224
		v_max_f32_e32 v151, v225, v226
		v_max_f32_e32 v152, v227, v228
		v_max_f32_e32 v8, v8, v27
		v_max_f32_e32 v15, v15, v26
		v_max_f32_e32 v26, v28, v29
		v_max_f32_e32 v27, v31, v144
		v_max_f32_e32 v28, v145, v146
		v_max_f32_e32 v29, v147, v148
		v_max_f32_e32 v31, v149, v150
		v_max_f32_e32 v144, v151, v152
		v_max_f32_e32 v8, v8, v15
		v_max_f32_e32 v15, v26, v27
		v_max_f32_e32 v26, v28, v29
		v_max_f32_e32 v27, v31, v144
		v_max_f32_e32 v8, v8, v15
		v_max_f32_e32 v15, v26, v27
		v_max_f32_e32 v8, v8, v15
		ds_bpermute_b32 v15, v11, v8
		ds_bpermute_b32 v26, v18, v8
		v_mov_b32_e32 v28, 0x3e38aa3b
		v_mov_b32_e32 v29, 0x3e38aa3b
		v_accvgpr_read_b32 v144, a136
		v_accvgpr_read_b32 v145, a137
		v_pk_mul_f32 v[146:147], v[144:145], v[28:29]
		v_accvgpr_read_b32 v144, a134
		v_accvgpr_read_b32 v145, a135
		v_pk_mul_f32 v[148:149], v[144:145], v[28:29]
		v_pk_mul_f32 v[144:145], v[98:99], v[28:29]
		v_accvgpr_read_b32 v98, a138
		v_accvgpr_read_b32 v99, a139
		v_pk_mul_f32 v[150:151], v[98:99], v[28:29]
		s_waitcnt lgkmcnt(0)
		v_max_f32_e32 v31, v15, v26
		v_pk_mul_f32 v[26:27], v[30:31], v[28:29]
		v_max_f32_e32 v8, v19, v26
		v_max_f32_e32 v15, v21, v27
		v_pk_mul_f32 v[26:27], v[102:103], v[28:29]
		v_accvgpr_read_b32 v30, a140
		v_accvgpr_read_b32 v31, a141
		v_pk_mul_f32 v[98:99], v[30:31], v[28:29]
		v_pk_mul_f32 v[30:31], v[104:105], v[28:29]
		v_pk_mul_f32 v[102:103], v[100:101], v[28:29]
		v_pk_mul_f32 v[100:101], v[108:109], v[28:29]
		v_accvgpr_read_b32 v104, a142
		v_accvgpr_read_b32 v105, a143
		v_pk_mul_f32 v[108:109], v[104:105], v[28:29]
		v_pk_mul_f32 v[104:105], v[112:113], v[28:29]
		v_accvgpr_read_b32 v112, a148
		v_accvgpr_read_b32 v113, a149
		v_pk_mul_f32 v[152:153], v[112:113], v[28:29]
		v_accvgpr_read_b32 v112, a150
		v_accvgpr_read_b32 v113, a151
		v_pk_mul_f32 v[154:155], v[112:113], v[28:29]
		v_pk_mul_f32 v[112:113], v[106:107], v[28:29]
		v_pk_mul_f32 v[106:107], v[122:123], v[28:29]
		v_pk_mul_f32 v[122:123], v[110:111], v[28:29]
		v_pk_mul_f32 v[110:111], v[162:163], v[28:29]
		v_pk_mul_f32 v[162:163], v[114:115], v[28:29]
		v_pk_mul_f32 v[114:115], v[130:131], v[28:29]
		v_pk_mul_f32 v[130:131], v[116:117], v[28:29]
		v_pk_mul_f32 v[116:117], v[134:135], v[28:29]
		v_pk_mul_f32 v[134:135], v[118:119], v[28:29]
		v_pk_mul_f32 v[118:119], v[120:121], v[28:29]
		v_pk_mul_f32 v[120:121], v[238:239], v[28:29]
		v_pk_mul_f32 v[178:179], v[142:143], v[28:29]
		v_pk_mul_f32 v[142:143], v[160:161], v[28:29]
		v_pk_mul_f32 v[160:161], v[124:125], v[28:29]
		v_pk_mul_f32 v[124:125], v[126:127], v[28:29]
		v_pk_mul_f32 v[126:127], v[128:129], v[28:29]
		v_pk_mul_f32 v[128:129], v[164:165], v[28:29]
		v_pk_mul_f32 v[164:165], v[166:167], v[28:29]
		v_pk_mul_f32 v[166:167], v[168:169], v[28:29]
		v_pk_mul_f32 v[168:169], v[96:97], v[28:29]
		v_pk_mul_f32 v[96:97], v[132:133], v[28:29]
		v_pk_mul_f32 v[132:133], v[16:17], v[28:29]
		v_pk_mul_f32 v[16:17], v[136:137], v[28:29]
		v_pk_mul_f32 v[136:137], v[138:139], v[28:29]
		v_pk_mul_f32 v[138:139], v[140:141], v[28:29]
		v_pk_mul_f32 v[140:141], v[24:25], v[28:29]
		v_pk_mul_f32 v[24:25], v[156:157], v[28:29]
		v_pk_mul_f32 v[156:157], v[158:159], v[28:29]
		v_pk_mul_f32 v[158:159], v[170:171], v[28:29]
		v_pk_mul_f32 v[170:171], v[172:173], v[28:29]
		v_pk_mul_f32 v[172:173], v[174:175], v[28:29]
		v_pk_mul_f32 v[174:175], v[192:193], v[28:29]
		v_pk_mul_f32 v[182:183], v[194:195], v[28:29]
		v_pk_mul_f32 v[186:187], v[196:197], v[28:29]
		v_pk_mul_f32 v[190:191], v[198:199], v[28:29]
		v_pk_mul_f32 v[192:193], v[200:201], v[28:29]
		v_pk_mul_f32 v[194:195], v[202:203], v[28:29]
		v_pk_mul_f32 v[196:197], v[204:205], v[28:29]
		v_pk_mul_f32 v[198:199], v[206:207], v[28:29]
		v_pk_mul_f32 v[200:201], v[208:209], v[28:29]
		v_pk_mul_f32 v[202:203], v[210:211], v[28:29]
		v_pk_mul_f32 v[204:205], v[212:213], v[28:29]
		v_pk_mul_f32 v[206:207], v[214:215], v[28:29]
		v_pk_mul_f32 v[208:209], v[216:217], v[28:29]
		v_pk_mul_f32 v[210:211], v[176:177], v[28:29]
		v_pk_mul_f32 v[176:177], v[218:219], v[28:29]
		v_pk_mul_f32 v[212:213], v[180:181], v[28:29]
		v_pk_mul_f32 v[180:181], v[220:221], v[28:29]
		v_pk_mul_f32 v[214:215], v[184:185], v[28:29]
		v_pk_mul_f32 v[184:185], v[222:223], v[28:29]
		v_pk_mul_f32 v[216:217], v[188:189], v[28:29]
		v_sub_f32_e32 v28, v146, v8
		v_sub_f32_e32 v29, v147, v8
		v_sub_f32_e32 v146, v148, v8
		v_sub_f32_e32 v147, v149, v8
		v_sub_f32_e32 v144, v144, v8
		v_sub_f32_e32 v145, v145, v8
		v_sub_f32_e32 v148, v150, v8
		v_sub_f32_e32 v149, v151, v8
		v_sub_f32_e32 v26, v26, v8
		v_sub_f32_e32 v27, v27, v8
		v_sub_f32_e32 v98, v98, v8
		v_sub_f32_e32 v99, v99, v8
		v_sub_f32_e32 v30, v30, v8
		v_sub_f32_e32 v31, v31, v8
		v_sub_f32_e32 v102, v102, v8
		v_sub_f32_e32 v103, v103, v8
		v_sub_f32_e32 v100, v100, v8
		v_sub_f32_e32 v101, v101, v8
		v_sub_f32_e32 v108, v108, v8
		v_sub_f32_e32 v109, v109, v8
		v_sub_f32_e32 v104, v104, v8
		v_sub_f32_e32 v105, v105, v8
		v_sub_f32_e32 v150, v152, v8
		v_sub_f32_e32 v151, v153, v8
		v_sub_f32_e32 v152, v154, v8
		v_sub_f32_e32 v153, v155, v8
		v_sub_f32_e32 v112, v112, v8
		v_sub_f32_e32 v113, v113, v8
		v_sub_f32_e32 v106, v106, v8
		v_sub_f32_e32 v107, v107, v8
		v_sub_f32_e32 v122, v122, v8
		v_sub_f32_e32 v123, v123, v8
		v_sub_f32_e32 v110, v110, v8
		v_sub_f32_e32 v111, v111, v8
		v_sub_f32_e32 v154, v162, v8
		v_sub_f32_e32 v155, v163, v8
		v_sub_f32_e32 v114, v114, v8
		v_sub_f32_e32 v115, v115, v8
		v_sub_f32_e32 v130, v130, v8
		v_sub_f32_e32 v131, v131, v8
		v_sub_f32_e32 v116, v116, v8
		v_sub_f32_e32 v117, v117, v8
		v_sub_f32_e32 v134, v134, v8
		v_sub_f32_e32 v135, v135, v8
		v_sub_f32_e32 v118, v118, v8
		v_sub_f32_e32 v119, v119, v8
		v_sub_f32_e32 v120, v120, v8
		v_sub_f32_e32 v121, v121, v8
		v_sub_f32_e32 v162, v178, v8
		v_sub_f32_e32 v163, v179, v8
		v_sub_f32_e32 v142, v142, v8
		v_sub_f32_e32 v143, v143, v8
		v_sub_f32_e32 v160, v160, v8
		v_sub_f32_e32 v161, v161, v8
		v_sub_f32_e32 v124, v124, v8
		v_sub_f32_e32 v125, v125, v8
		v_sub_f32_e32 v126, v126, v8
		v_sub_f32_e32 v127, v127, v8
		v_sub_f32_e32 v128, v128, v8
		v_sub_f32_e32 v129, v129, v8
		v_sub_f32_e32 v164, v164, v8
		v_sub_f32_e32 v165, v165, v8
		v_sub_f32_e32 v166, v166, v8
		v_sub_f32_e32 v167, v167, v8
		v_sub_f32_e32 v168, v168, v15
		v_sub_f32_e32 v169, v169, v15
		v_sub_f32_e32 v96, v96, v15
		v_sub_f32_e32 v97, v97, v15
		v_sub_f32_e32 v132, v132, v15
		v_sub_f32_e32 v133, v133, v15
		v_sub_f32_e32 v16, v16, v15
		v_sub_f32_e32 v17, v17, v15
		v_sub_f32_e32 v136, v136, v15
		v_sub_f32_e32 v137, v137, v15
		v_sub_f32_e32 v138, v138, v15
		v_sub_f32_e32 v139, v139, v15
		v_sub_f32_e32 v140, v140, v15
		v_sub_f32_e32 v141, v141, v15
		v_sub_f32_e32 v24, v24, v15
		v_sub_f32_e32 v25, v25, v15
		v_sub_f32_e32 v156, v156, v15
		v_sub_f32_e32 v157, v157, v15
		v_sub_f32_e32 v158, v158, v15
		v_sub_f32_e32 v159, v159, v15
		v_sub_f32_e32 v170, v170, v15
		v_sub_f32_e32 v171, v171, v15
		v_sub_f32_e32 v172, v172, v15
		v_sub_f32_e32 v173, v173, v15
		v_sub_f32_e32 v174, v174, v15
		v_sub_f32_e32 v175, v175, v15
		v_sub_f32_e32 v178, v182, v15
		v_sub_f32_e32 v179, v183, v15
		v_sub_f32_e32 v182, v186, v15
		v_sub_f32_e32 v183, v187, v15
		v_sub_f32_e32 v186, v190, v15
		v_sub_f32_e32 v187, v191, v15
		v_sub_f32_e32 v188, v192, v15
		v_sub_f32_e32 v189, v193, v15
		v_sub_f32_e32 v190, v194, v15
		v_sub_f32_e32 v191, v195, v15
		v_sub_f32_e32 v192, v196, v15
		v_sub_f32_e32 v193, v197, v15
		v_sub_f32_e32 v194, v198, v15
		v_sub_f32_e32 v195, v199, v15
		v_sub_f32_e32 v196, v200, v15
		v_sub_f32_e32 v197, v201, v15
		v_sub_f32_e32 v198, v202, v15
		v_sub_f32_e32 v199, v203, v15
		v_sub_f32_e32 v200, v204, v15
		v_sub_f32_e32 v201, v205, v15
		v_sub_f32_e32 v202, v206, v15
		v_sub_f32_e32 v203, v207, v15
		v_sub_f32_e32 v204, v208, v15
		v_sub_f32_e32 v205, v209, v15
		v_sub_f32_e32 v206, v210, v15
		v_sub_f32_e32 v207, v211, v15
		v_sub_f32_e32 v176, v176, v15
		v_sub_f32_e32 v177, v177, v15
		v_sub_f32_e32 v208, v212, v15
		v_sub_f32_e32 v209, v213, v15
		v_sub_f32_e32 v180, v180, v15
		v_sub_f32_e32 v181, v181, v15
		v_sub_f32_e32 v210, v214, v15
		v_sub_f32_e32 v211, v215, v15
		v_sub_f32_e32 v184, v184, v15
		v_sub_f32_e32 v185, v185, v15
		v_sub_f32_e32 v212, v216, v15
		v_sub_f32_e32 v213, v217, v15
		v_exp_f32_e32 v214, v28
		v_exp_f32_e32 v216, v29
		v_exp_f32_e32 v215, v146
		v_exp_f32_e32 v217, v147
		v_exp_f32_e32 v28, v144
		v_exp_f32_e32 v146, v145
		v_exp_f32_e32 v29, v148
		v_exp_f32_e32 v147, v149
		v_exp_f32_e32 v144, v26
		v_exp_f32_e32 v148, v27
		v_exp_f32_e32 v145, v98
		v_exp_f32_e32 v149, v99
		v_exp_f32_e32 v26, v30
		v_exp_f32_e32 v98, v31
		v_exp_f32_e32 v27, v102
		v_exp_f32_e32 v99, v103
		v_exp_f32_e32 v30, v100
		v_exp_f32_e32 v102, v101
		v_exp_f32_e32 v31, v108
		v_exp_f32_e32 v103, v109
		v_exp_f32_e32 v100, v104
		v_exp_f32_e32 v108, v105
		v_exp_f32_e32 v101, v150
		v_exp_f32_e32 v109, v151
		v_exp_f32_e32 v104, v152
		v_exp_f32_e32 v150, v153
		v_exp_f32_e32 v105, v112
		v_exp_f32_e32 v151, v113
		v_exp_f32_e32 v112, v106
		v_exp_f32_e32 v152, v107
		v_exp_f32_e32 v113, v122
		v_exp_f32_e32 v153, v123
		v_exp_f32_e32 v106, v110
		v_exp_f32_e32 v122, v111
		v_exp_f32_e32 v107, v154
		v_exp_f32_e32 v123, v155
		v_exp_f32_e32 v110, v114
		v_exp_f32_e32 v154, v115
		v_exp_f32_e32 v111, v130
		v_exp_f32_e32 v155, v131
		v_exp_f32_e32 v114, v116
		v_exp_f32_e32 v130, v117
		v_exp_f32_e32 v115, v134
		v_exp_f32_e32 v131, v135
		v_exp_f32_e32 v116, v118
		v_exp_f32_e32 v134, v119
		v_exp_f32_e32 v117, v120
		v_exp_f32_e32 v135, v121
		v_exp_f32_e32 v118, v162
		v_exp_f32_e32 v120, v163
		v_exp_f32_e32 v119, v142
		v_exp_f32_e32 v121, v143
		v_exp_f32_e32 v142, v160
		v_exp_f32_e32 v162, v161
		v_exp_f32_e32 v143, v124
		v_exp_f32_e32 v163, v125
		v_exp_f32_e32 v124, v126
		v_exp_f32_e32 v160, v127
		v_exp_f32_e32 v125, v128
		v_exp_f32_e32 v161, v129
		v_exp_f32_e32 v126, v164
		v_exp_f32_e32 v128, v165
		v_exp_f32_e32 v127, v166
		v_exp_f32_e32 v129, v167
		v_exp_f32_e32 v165, v168
		v_exp_f32_e32 v167, v169
		v_exp_f32_e32 v168, v96
		v_exp_f32_e32 v218, v97
		v_exp_f32_e32 v169, v132
		v_exp_f32_e32 v219, v133
		v_exp_f32_e32 v96, v16
		v_exp_f32_e32 v132, v17
		v_exp_f32_e32 v97, v136
		v_exp_f32_e32 v133, v137
		v_exp_f32_e32 v16, v138
		v_exp_f32_e32 v136, v139
		v_exp_f32_e32 v17, v140
		v_exp_f32_e32 v137, v141
		v_exp_f32_e32 v138, v24
		v_exp_f32_e32 v140, v25
		v_exp_f32_e32 v139, v156
		v_exp_f32_e32 v141, v157
		v_exp_f32_e32 v24, v158
		v_exp_f32_e32 v156, v159
		v_exp_f32_e32 v25, v170
		v_exp_f32_e32 v157, v171
		v_exp_f32_e32 v158, v172
		v_exp_f32_e32 v170, v173
		v_exp_f32_e32 v159, v174
		v_exp_f32_e32 v171, v175
		v_exp_f32_e32 v172, v178
		v_exp_f32_e32 v174, v179
		v_exp_f32_e32 v173, v182
		v_exp_f32_e32 v175, v183
		v_exp_f32_e32 v178, v186
		v_exp_f32_e32 v182, v187
		v_exp_f32_e32 v179, v188
		v_exp_f32_e32 v183, v189
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
		v_exp_f32_e32 v199, v204
		v_exp_f32_e32 v201, v205
		v_exp_f32_e32 v202, v206
		v_exp_f32_e32 v204, v207
		v_exp_f32_e32 v203, v176
		v_exp_f32_e32 v205, v177
		v_exp_f32_e32 v176, v208
		v_exp_f32_e32 v206, v209
		v_exp_f32_e32 v177, v180
		v_exp_f32_e32 v207, v181
		v_exp_f32_e32 v180, v210
		v_exp_f32_e32 v208, v211
		v_exp_f32_e32 v181, v184
		v_exp_f32_e32 v209, v185
		v_exp_f32_e32 v184, v212
		v_exp_f32_e32 v210, v213
		v_pk_add_f32 v[212:213], v[214:215], v[216:217]
		v_pk_add_f32 v[220:221], v[28:29], v[146:147]
		v_pk_add_f32 v[222:223], v[144:145], v[148:149]
		v_pk_add_f32 v[224:225], v[26:27], v[98:99]
		v_pk_add_f32 v[226:227], v[30:31], v[102:103]
		v_pk_add_f32 v[228:229], v[100:101], v[108:109]
		v_pk_add_f32 v[230:231], v[104:105], v[150:151]
		v_pk_add_f32 v[232:233], v[112:113], v[152:153]
		v_pk_add_f32 v[234:235], v[106:107], v[122:123]
		v_pk_add_f32 v[236:237], v[110:111], v[154:155]
		v_pk_add_f32 v[238:239], v[114:115], v[130:131]
		v_pk_add_f32 v[240:241], v[116:117], v[134:135]
		v_pk_add_f32 v[242:243], v[118:119], v[120:121]
		v_pk_add_f32 v[244:245], v[142:143], v[162:163]
		v_pk_add_f32 v[246:247], v[124:125], v[160:161]
		v_pk_add_f32 v[248:249], v[126:127], v[128:129]
		v_mov_b32_e32 v250, v213
		v_mov_b32_e32 v251, v221
		v_mov_b32_e32 v252, v212
		v_mov_b32_e32 v253, v220
		v_pk_add_f32 v[212:213], v[252:253], v[250:251]
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
		v_mov_b32_e32 v220, v213
		v_mov_b32_e32 v221, v223
		v_mov_b32_e32 v224, v212
		v_mov_b32_e32 v225, v222
		v_pk_add_f32 v[212:213], v[224:225], v[220:221]
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
		v_mov_b32_e32 v220, v213
		v_mov_b32_e32 v221, v225
		v_mov_b32_e32 v222, v212
		v_mov_b32_e32 v223, v224
		v_pk_add_f32 v[212:213], v[222:223], v[220:221]
		v_mov_b32_e32 v220, v227
		v_mov_b32_e32 v221, v229
		v_mov_b32_e32 v222, v226
		v_mov_b32_e32 v223, v228
		v_pk_add_f32 v[224:225], v[222:223], v[220:221]
		v_mov_b32_e32 v220, v213
		v_mov_b32_e32 v221, v225
		v_mov_b32_e32 v222, v212
		v_mov_b32_e32 v223, v224
		v_pk_add_f32 v[212:213], v[222:223], v[220:221]
		v_add_f32_e32 v185, v212, v213
		ds_bpermute_b32 v164, v11, v185
		ds_bpermute_b32 v166, v18, v185
		v_pk_add_f32 v[212:213], v[168:169], v[218:219]
		v_pk_add_f32 v[220:221], v[96:97], v[132:133]
		v_pk_add_f32 v[222:223], v[16:17], v[136:137]
		v_pk_add_f32 v[224:225], v[138:139], v[140:141]
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[226:227], v[164:165], v[166:167]
		v_pk_add_f32 v[228:229], v[24:25], v[156:157]
		v_pk_add_f32 v[230:231], v[158:159], v[170:171]
		v_pk_add_f32 v[232:233], v[172:173], v[174:175]
		v_pk_add_f32 v[234:235], v[178:179], v[182:183]
		v_pk_add_f32 v[236:237], v[186:187], v[188:189]
		v_pk_add_f32 v[238:239], v[190:191], v[192:193]
		v_pk_add_f32 v[240:241], v[194:195], v[196:197]
		v_pk_add_f32 v[242:243], v[198:199], v[200:201]
		v_pk_add_f32 v[244:245], v[202:203], v[204:205]
		v_pk_add_f32 v[246:247], v[176:177], v[206:207]
		v_pk_add_f32 v[248:249], v[180:181], v[208:209]
		v_mov_b32_e32 v185, v227
		v_mov_b32_e32 v211, v212
		v_pk_add_f32 v[250:251], v[184:185], v[210:211]
		v_mov_b32_e32 v252, v213
		v_mov_b32_e32 v253, v222
		v_pk_add_f32 v[212:213], v[252:253], v[220:221]
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
		v_mov_b32_e32 v233, v212
		v_pk_add_f32 v[232:233], v[232:233], v[250:251]
		v_mov_b32_e32 v236, v213
		v_mov_b32_e32 v237, v224
		v_pk_add_f32 v[212:213], v[236:237], v[220:221]
		v_mov_b32_e32 v220, v225
		v_mov_b32_e32 v221, v230
		v_pk_add_f32 v[220:221], v[220:221], v[222:223]
		v_mov_b32_e32 v222, v231
		v_mov_b32_e32 v223, v234
		v_pk_add_f32 v[224:225], v[222:223], v[228:229]
		v_mov_b32_e32 v222, v235
		v_mov_b32_e32 v223, v212
		v_pk_add_f32 v[222:223], v[222:223], v[232:233]
		v_mov_b32_e32 v228, v213
		v_mov_b32_e32 v229, v224
		v_pk_add_f32 v[212:213], v[228:229], v[220:221]
		v_mov_b32_e32 v220, v225
		v_mov_b32_e32 v221, v212
		v_pk_add_f32 v[224:225], v[220:221], v[222:223]
		v_add_f32_e32 v164, v213, v224
		v_add_f32_e32 v164, v225, v164
		ds_bpermute_b32 v166, v11, v164
		ds_bpermute_b32 v11, v18, v164
		v_sub_f32_e32 v18, v19, v8
		v_sub_f32_e32 v19, v21, v15
		v_exp_f32_e32 v212, v18
		v_exp_f32_e32 v220, v19
		s_waitcnt lgkmcnt(0)
		v_add_f32_e32 v19, v166, v11
		v_mov_b32_e32 v213, v212
		v_pk_mul_f32 v[32:33], v[32:33], v[212:213]
		v_pk_mul_f32 v[34:35], v[34:35], v[212:213]
		v_pk_mul_f32 v[36:37], v[36:37], v[212:213]
		v_pk_mul_f32 v[38:39], v[38:39], v[212:213]
		v_pk_mul_f32 v[40:41], v[40:41], v[212:213]
		v_pk_mul_f32 v[42:43], v[42:43], v[212:213]
		v_pk_mul_f32 v[44:45], v[44:45], v[212:213]
		v_pk_mul_f32 v[46:47], v[46:47], v[212:213]
		v_pk_mul_f32 v[48:49], v[48:49], v[212:213]
		v_pk_mul_f32 v[50:51], v[50:51], v[212:213]
		v_pk_mul_f32 v[52:53], v[52:53], v[212:213]
		v_pk_mul_f32 v[54:55], v[54:55], v[212:213]
		v_pk_mul_f32 v[56:57], v[56:57], v[212:213]
		v_pk_mul_f32 v[58:59], v[58:59], v[212:213]
		v_pk_mul_f32 v[60:61], v[60:61], v[212:213]
		v_pk_mul_f32 v[62:63], v[62:63], v[212:213]
		v_mov_b32_e32 v221, v220
		v_pk_mul_f32 v[64:65], v[64:65], v[220:221]
		v_pk_mul_f32 v[66:67], v[66:67], v[220:221]
		v_pk_mul_f32 v[68:69], v[68:69], v[220:221]
		v_pk_mul_f32 v[70:71], v[70:71], v[220:221]
		v_pk_mul_f32 v[72:73], v[72:73], v[220:221]
		v_pk_mul_f32 v[74:75], v[74:75], v[220:221]
		v_pk_mul_f32 v[76:77], v[76:77], v[220:221]
		v_pk_mul_f32 v[78:79], v[78:79], v[220:221]
		v_pk_mul_f32 v[80:81], v[80:81], v[220:221]
		v_pk_mul_f32 v[82:83], v[82:83], v[220:221]
		v_pk_mul_f32 v[84:85], v[84:85], v[220:221]
		v_pk_mul_f32 v[86:87], v[86:87], v[220:221]
		v_pk_mul_f32 v[88:89], v[88:89], v[220:221]
		v_pk_mul_f32 v[90:91], v[90:91], v[220:221]
		v_pk_mul_f32 v[92:93], v[92:93], v[220:221]
		v_pk_mul_f32 v[94:95], v[94:95], v[220:221]
		v_mov_b32_e32 v18, v226
		v_mov_b32_e32 v222, v212
		v_mov_b32_e32 v223, v220
		v_mov_b64_e32 v[212:213], v[22:23]
		v_pk_fma_f32 v[22:23], v[212:213], v[222:223], v[18:19]
		v_cvt_pk_bf16_f32 v220, v214, v216
		v_cvt_pk_bf16_f32 v221, v215, v217
		v_cvt_pk_bf16_f32 v222, v28, v146
		v_cvt_pk_bf16_f32 v223, v29, v147
		v_cvt_pk_bf16_f32 v212, v144, v148
		v_cvt_pk_bf16_f32 v213, v145, v149
		v_cvt_pk_bf16_f32 v214, v26, v98
		v_cvt_pk_bf16_f32 v215, v27, v99
		v_cvt_pk_bf16_f32 v144, v30, v102
		v_cvt_pk_bf16_f32 v145, v31, v103
		v_cvt_pk_bf16_f32 v146, v100, v108
		v_cvt_pk_bf16_f32 v147, v101, v109
		v_cvt_pk_bf16_f32 v28, v104, v150
		v_cvt_pk_bf16_f32 v29, v105, v151
		v_cvt_pk_bf16_f32 v30, v112, v152
		v_cvt_pk_bf16_f32 v31, v113, v153
		v_cvt_pk_bf16_f32 v100, v106, v122
		v_cvt_pk_bf16_f32 v101, v107, v123
		v_cvt_pk_bf16_f32 v102, v110, v154
		v_cvt_pk_bf16_f32 v103, v111, v155
		v_cvt_pk_bf16_f32 v104, v114, v130
		v_cvt_pk_bf16_f32 v105, v115, v131
		v_cvt_pk_bf16_f32 v106, v116, v134
		v_cvt_pk_bf16_f32 v107, v117, v135
		v_cvt_pk_bf16_f32 v108, v118, v120
		v_cvt_pk_bf16_f32 v109, v119, v121
		v_cvt_pk_bf16_f32 v110, v142, v162
		v_cvt_pk_bf16_f32 v111, v143, v163
		v_cvt_pk_bf16_f32 v112, v124, v160
		v_cvt_pk_bf16_f32 v113, v125, v161
		v_cvt_pk_bf16_f32 v114, v126, v128
		v_cvt_pk_bf16_f32 v115, v127, v129
		v_cvt_pk_bf16_f32 v116, v165, v167
		v_cvt_pk_bf16_f32 v117, v168, v218
		v_cvt_pk_bf16_f32 v118, v169, v219
		v_cvt_pk_bf16_f32 v119, v96, v132
		v_cvt_pk_bf16_f32 v120, v97, v133
		v_cvt_pk_bf16_f32 v121, v16, v136
		v_cvt_pk_bf16_f32 v122, v17, v137
		v_cvt_pk_bf16_f32 v123, v138, v140
		v_cvt_pk_bf16_f32 v16, v139, v141
		v_cvt_pk_bf16_f32 v17, v24, v156
		v_cvt_pk_bf16_f32 v18, v25, v157
		v_cvt_pk_bf16_f32 v19, v158, v170
		v_cvt_pk_bf16_f32 v24, v159, v171
		v_cvt_pk_bf16_f32 v25, v172, v174
		v_cvt_pk_bf16_f32 v26, v173, v175
		v_cvt_pk_bf16_f32 v27, v178, v182
		v_cvt_pk_bf16_f32 v96, v179, v183
		v_cvt_pk_bf16_f32 v97, v186, v188
		v_cvt_pk_bf16_f32 v98, v187, v189
		v_cvt_pk_bf16_f32 v99, v190, v192
		v_cvt_pk_bf16_f32 v124, v191, v193
		v_cvt_pk_bf16_f32 v125, v194, v196
		v_cvt_pk_bf16_f32 v126, v195, v197
		v_cvt_pk_bf16_f32 v127, v198, v200
		v_cvt_pk_bf16_f32 v128, v199, v201
		v_cvt_pk_bf16_f32 v129, v202, v204
		v_cvt_pk_bf16_f32 v130, v203, v205
		v_cvt_pk_bf16_f32 v131, v176, v206
		v_cvt_pk_bf16_f32 v132, v177, v207
		v_cvt_pk_bf16_f32 v133, v180, v208
		v_cvt_pk_bf16_f32 v134, v181, v209
		v_cvt_pk_bf16_f32 v135, v184, v210
		v_permlane32_swap_b32_e32 v220, v222
		v_permlane32_swap_b32_e32 v221, v223
		v_permlane32_swap_b32_e32 v212, v214
		v_permlane32_swap_b32_e32 v213, v215
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[220:223], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[220:223], v[48:63]
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[212:215], v[32:47]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[212:215], v[48:63]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[144:147], v[32:47]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[144:147], v[48:63]
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[28:31], v[32:47]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[28:31], v[48:63]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[100:103], v[32:47]
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[116:119], v[80:95]
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[116:119], v[64:79]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[120:123], v[80:95]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[120:123], v[64:79]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[16:19], v[80:95]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[16:19], v[64:79]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[24:27], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[24:27], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[100:103], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[104:107], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[104:107], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[124:127], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[124:127], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[216:219], v[108:111], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[248:251], v[108:111], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[248:251], v[128:131], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[216:219], v[128:131], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[220:223], v[112:115], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[252:255], v[112:115], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[252:255], v[132:135], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[220:223], v[132:135], v[64:79]
		s_mov_b32 s46, s20
		v_mov_b32_e32 v19, v8
		v_mov_b32_e32 v21, v15
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_4
.L_attn_fwd_persistent.loop_exit_4:
		s_mov_b32 s32, s8
		s_mov_b32 s33, s9
		s_mov_b32 s34, s30
		s_mov_b32 s35, s31
		v_rcp_f32_e32 v4, v22
		v_rcp_f32_e32 v6, v23
		v_mov_b32_e32 v5, v4
		v_pk_mul_f32 v[8:9], v[32:33], v[4:5]
		v_pk_mul_f32 v[10:11], v[34:35], v[4:5]
		v_pk_mul_f32 v[12:13], v[36:37], v[4:5]
		v_pk_mul_f32 v[14:15], v[38:39], v[4:5]
		v_pk_mul_f32 v[16:17], v[40:41], v[4:5]
		v_pk_mul_f32 v[18:19], v[42:43], v[4:5]
		v_pk_mul_f32 v[20:21], v[44:45], v[4:5]
		v_pk_mul_f32 v[22:23], v[46:47], v[4:5]
		v_pk_mul_f32 v[24:25], v[48:49], v[4:5]
		v_pk_mul_f32 v[26:27], v[50:51], v[4:5]
		v_pk_mul_f32 v[28:29], v[52:53], v[4:5]
		v_pk_mul_f32 v[30:31], v[54:55], v[4:5]
		v_pk_mul_f32 v[32:33], v[56:57], v[4:5]
		v_pk_mul_f32 v[34:35], v[58:59], v[4:5]
		v_pk_mul_f32 v[36:37], v[60:61], v[4:5]
		v_pk_mul_f32 v[38:39], v[62:63], v[4:5]
		v_mov_b32_e32 v7, v6
		v_pk_mul_f32 v[4:5], v[64:65], v[6:7]
		v_pk_mul_f32 v[40:41], v[66:67], v[6:7]
		v_pk_mul_f32 v[42:43], v[68:69], v[6:7]
		v_pk_mul_f32 v[44:45], v[70:71], v[6:7]
		v_pk_mul_f32 v[46:47], v[72:73], v[6:7]
		v_pk_mul_f32 v[48:49], v[74:75], v[6:7]
		v_pk_mul_f32 v[50:51], v[76:77], v[6:7]
		v_pk_mul_f32 v[52:53], v[78:79], v[6:7]
		v_pk_mul_f32 v[54:55], v[80:81], v[6:7]
		v_pk_mul_f32 v[56:57], v[82:83], v[6:7]
		v_pk_mul_f32 v[58:59], v[84:85], v[6:7]
		v_pk_mul_f32 v[60:61], v[86:87], v[6:7]
		v_pk_mul_f32 v[62:63], v[88:89], v[6:7]
		v_pk_mul_f32 v[64:65], v[90:91], v[6:7]
		v_pk_mul_f32 v[66:67], v[92:93], v[6:7]
		v_pk_mul_f32 v[68:69], v[94:95], v[6:7]
		v_accvgpr_read_b32 v3, a11
		v_mov_b32_e32 v6, 8
		v_mul_lo_u32 v6, v6, v3
		v_xor_b32_e32 v3, 16, v6
		v_xor_b32_e32 v7, 32, v6
		v_xor_b32_e32 v70, 48, v6
		s_mov_b32 s20, 64
		v_cmp_lt_i32_e64 vcc, v6, s20
		s_mov_b64 s[28:29], vcc
		s_and_b32 s30, s24, s28
		s_and_b32 s31, s25, s29
		v_cmp_lt_i32_e64 vcc, v3, s20
		s_mov_b64 s[36:37], vcc
		s_and_b32 s38, s24, s36
		s_and_b32 s39, s25, s37
		v_cmp_lt_i32_e64 vcc, v7, s20
		s_mov_b64 s[40:41], vcc
		s_and_b32 s42, s24, s40
		s_and_b32 s43, s25, s41
		v_cmp_lt_i32_e64 vcc, v70, s20
		s_mov_b64 s[44:45], vcc
		s_and_b32 s46, s24, s44
		s_and_b32 s47, s25, s45
		s_and_b32 s24, s26, s28
		s_and_b32 s25, s27, s29
		s_and_b32 s28, s26, s36
		s_and_b32 s29, s27, s37
		s_and_b32 s36, s26, s40
		s_and_b32 s37, s27, s41
		s_and_b32 s40, s26, s44
		s_and_b32 s41, s27, s45
		v_cvt_pk_bf16_f32 v72, v8, v9
		v_cvt_pk_bf16_f32 v73, v10, v11
		v_cvt_pk_bf16_f32 v74, v12, v13
		v_cvt_pk_bf16_f32 v75, v14, v15
		v_cvt_pk_bf16_f32 v8, v16, v17
		v_cvt_pk_bf16_f32 v9, v18, v19
		v_cvt_pk_bf16_f32 v10, v20, v21
		v_cvt_pk_bf16_f32 v11, v22, v23
		v_cvt_pk_bf16_f32 v12, v24, v25
		v_cvt_pk_bf16_f32 v13, v26, v27
		v_cvt_pk_bf16_f32 v14, v28, v29
		v_cvt_pk_bf16_f32 v15, v30, v31
		v_cvt_pk_bf16_f32 v16, v32, v33
		v_cvt_pk_bf16_f32 v17, v34, v35
		v_cvt_pk_bf16_f32 v18, v36, v37
		v_cvt_pk_bf16_f32 v19, v38, v39
		v_cvt_pk_bf16_f32 v20, v4, v5
		v_cvt_pk_bf16_f32 v21, v40, v41
		v_cvt_pk_bf16_f32 v22, v42, v43
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
		v_permlane32_swap_b32_e32 v72, v74
		v_permlane32_swap_b32_e32 v73, v75
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
		s_mul_i32 s1, s1, s19
		s_lshl_b32 s1, s1, 9
		v_accvgpr_read_b32 v3, a2
		s_mov_b32 m0, s17
		v_readfirstlane_b32 s20, v3
		ds_read_addtid_b32 v3 offset:1024
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s26, v3
		s_mul_i32 s20, s26, s20
		s_lshl_b32 s20, s20, 1
		s_add_i32 s26, s1, s20
		v_accvgpr_read_b32 v3, a3
		s_mov_b32 m0, s17
		v_readfirstlane_b32 s27, v3
		ds_read_addtid_b32 v3 offset:2048
		s_waitcnt lgkmcnt(0)
		v_readfirstlane_b32 s44, v3
		s_mul_i32 s27, s44, s27
		s_lshl_b32 s27, s27, 1
		s_add_i32 s26, s26, s27
		v_accvgpr_read_b32 v3, a8
		v_mul_lo_u32 v3, s19, v3
		v_lshl_add_u32 v32, v3, 7, s26
		v_accvgpr_read_b32 v33, a15
		v_mul_lo_u32 v33, s19, v33
		v_lshl_add_u32 v32, v33, 1, v32
		v_accvgpr_read_b32 v34, a12
		v_mul_lo_u32 v34, s19, v34
		v_lshl_add_u32 v32, v34, 6, v32
		v_accvgpr_read_b32 v35, a13
		v_mul_lo_u32 v35, s19, v35
		v_lshl_add_u32 v32, v35, 5, v32
		v_accvgpr_read_b32 v36, a14
		v_mul_lo_u32 v36, s19, v36
		v_lshl_add_u32 v32, v36, 4, v32
		v_accvgpr_read_b32 v37, a16
		v_mul_lo_u32 v37, s19, v37
		v_lshl_add_u32 v32, v37, 3, v32
		v_accvgpr_read_b32 v38, a17
		v_mul_lo_u32 v38, s19, v38
		v_lshlrev_b32_e32 v38, 2, v38
		v_accvgpr_read_b32 v39, a59
		v_add3_u32 v32, v32, v38, v39
		s_and_saveexec_b64 s[98:99], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_24
		buffer_store_dwordx4 v[72:75], v32, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_24:
		s_andn2_b64 exec, s[98:99], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_24
.L_attn_fwd_persistent.exec_endif_24:
		s_mov_b64 exec, s[98:99]
		s_add_i32 s30, s1, 32
		s_add_i32 s30, s30, s20
		s_add_i32 s30, s30, s27
		v_lshl_add_u32 v32, v3, 7, s30
		v_lshl_add_u32 v32, v33, 1, v32
		v_lshl_add_u32 v32, v34, 6, v32
		v_lshl_add_u32 v32, v35, 5, v32
		v_lshl_add_u32 v32, v36, 4, v32
		v_lshl_add_u32 v32, v37, 3, v32
		v_accvgpr_read_b32 v39, a59
		v_add3_u32 v32, v32, v38, v39
		s_and_saveexec_b64 s[98:99], s[38:39]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_25
		buffer_store_dwordx4 v[8:11], v32, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_25:
		s_andn2_b64 exec, s[98:99], s[38:39]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_25
.L_attn_fwd_persistent.exec_endif_25:
		s_mov_b64 exec, s[98:99]
		s_add_i32 s31, s1, 64
		s_add_i32 s31, s31, s20
		s_add_i32 s31, s31, s27
		v_lshl_add_u32 v8, v3, 7, s31
		v_lshl_add_u32 v8, v33, 1, v8
		v_lshl_add_u32 v8, v34, 6, v8
		v_lshl_add_u32 v8, v35, 5, v8
		v_lshl_add_u32 v8, v36, 4, v8
		v_lshl_add_u32 v8, v37, 3, v8
		v_accvgpr_read_b32 v9, a59
		v_add3_u32 v8, v8, v38, v9
		s_and_saveexec_b64 s[98:99], s[42:43]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_26
		buffer_store_dwordx4 v[12:15], v8, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_26:
		s_andn2_b64 exec, s[98:99], s[42:43]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_26
.L_attn_fwd_persistent.exec_endif_26:
		s_mov_b64 exec, s[98:99]
		s_add_i32 s1, s1, 0x60
		s_add_i32 s1, s1, s20
		s_add_i32 s1, s1, s27
		v_lshl_add_u32 v3, v3, 7, s1
		v_lshl_add_u32 v3, v33, 1, v3
		v_lshl_add_u32 v3, v34, 6, v3
		v_lshl_add_u32 v3, v35, 5, v3
		v_lshl_add_u32 v3, v36, 4, v3
		v_lshl_add_u32 v3, v37, 3, v3
		v_accvgpr_read_b32 v8, a59
		v_add3_u32 v3, v3, v38, v8
		s_and_saveexec_b64 s[98:99], s[46:47]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_27
		buffer_store_dwordx4 v[16:19], v3, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_27:
		s_andn2_b64 exec, s[98:99], s[46:47]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_27
.L_attn_fwd_persistent.exec_endif_27:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v3, a8
		v_lshlrev_b32_e32 v3, 6, v3
		v_accvgpr_read_b32 v8, a12
		v_lshlrev_b32_e32 v8, 5, v8
		v_accvgpr_read_b32 v9, a13
		v_lshlrev_b32_e32 v9, 4, v9
		v_accvgpr_read_b32 v10, a14
		v_lshlrev_b32_e32 v10, 3, v10
		v_accvgpr_read_b32 v11, a16
		v_lshlrev_b32_e32 v11, 2, v11
		v_accvgpr_read_b32 v12, a15
		v_add_u32_e32 v12, 0x80, v12
		v_accvgpr_read_b32 v13, a17
		v_lshlrev_b32_e32 v13, 1, v13
		v_bitop3_b32 v11, v11, v12, v13 bitop3:0x96
		v_bitop3_b32 v9, v9, v10, v11 bitop3:0x96
		v_bitop3_b32 v3, v3, v8, v9 bitop3:0x96
		v_mul_lo_u32 v3, s19, v3
		v_lshlrev_b32_e32 v3, 1, v3
		v_accvgpr_read_b32 v8, a59
		v_add3_u32 v8, s26, v3, v8
		s_and_saveexec_b64 s[98:99], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_28
		buffer_store_dwordx4 v[20:23], v8, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_28:
		s_andn2_b64 exec, s[98:99], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_28
.L_attn_fwd_persistent.exec_endif_28:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v8, a59
		v_add3_u32 v8, s30, v3, v8
		s_and_saveexec_b64 s[98:99], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_29
		buffer_store_dwordx4 v[4:7], v8, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_29:
		s_andn2_b64 exec, s[98:99], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_29
.L_attn_fwd_persistent.exec_endif_29:
		s_mov_b64 exec, s[98:99]
		s_nop 0
		v_accvgpr_read_b32 v4, a59
		v_add3_u32 v4, s31, v3, v4
		s_and_saveexec_b64 s[98:99], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_30
		buffer_store_dwordx4 v[24:27], v4, s[32:35], 0 offen
.L_attn_fwd_persistent.exec_else_30:
		s_andn2_b64 exec, s[98:99], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_30
.L_attn_fwd_persistent.exec_endif_30:
		s_mov_b64 exec, s[98:99]
		v_accvgpr_read_b32 v4, a59
		v_add3_u32 v3, s1, v3, v4
		s_and_saveexec_b64 s[98:99], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_31
		buffer_store_dwordx4 v[28:31], v3, s[32:35], 0 offen
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
		v_accvgpr_read_b32 v3, a7
		s_nop 0
		v_readfirstlane_b32 s1, v3
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
    wave.regalloc.iterations: 451
    wave.regalloc.agpr.dwords: 853
    wave.regalloc.remat.dwords: 26
    wave.regalloc.sgpr_to_vgpr.dwords: 57
    wave.regalloc.lds.dwords: 3
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
