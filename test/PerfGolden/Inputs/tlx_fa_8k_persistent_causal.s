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
		v_accvgpr_write_b32 a7, 0
		s_and_b32 s0, s16, 7
		v_mov_b32_e32 v1, s0
		v_accvgpr_write_b32 a8, v1
		s_lshr_b32 s0, s16, 3
		v_accvgpr_read_b32 v1, a5
		s_nop 0
		v_readfirstlane_b32 s1, v1
		s_mul_i32 s1, s18, s1
		s_nop 0
		v_mov_b32_e32 v1, s1
		v_accvgpr_write_b32 a9, v1
		v_accvgpr_read_b32 v1, a9
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
		v_accvgpr_write_b32 a10, v1
		v_accvgpr_read_b32 v1, a10
		s_nop 0
		v_readfirstlane_b32 s1, v1
		s_cmp_lt_i32 s0, s1
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_0
.L_attn_fwd_persistent.loop_head_0:
		s_lshr_b32 s1, s0, 4
		s_and_b32 s18, s0, 15
		s_mul_i32 s1, s1, 8
		v_accvgpr_read_b32 v1, a8
		s_nop 0
		v_readfirstlane_b32 s21, v1
		s_add_i32 s1, s21, s1
		v_accvgpr_read_b32 v1, a9
		s_nop 0
		v_readfirstlane_b32 s21, v1
		s_cmp_lt_i32 s1, s21
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_0
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s21, 1, 0
		s_xor_b32 s22, s1, -1
		s_add_i32 s22, s22, 1
		s_cmp_lg_u32 s21, 0
		s_cselect_b32 s21, s22, s1
		s_cselect_b32 s22, 1, 0
		v_accvgpr_read_b32 v1, a5
		s_nop 0
		v_readfirstlane_b32 s23, v1
		s_xor_b32 s23, s23, -1
		s_add_i32 s23, s23, 1
		v_accvgpr_read_b32 v1, a5
		s_nop 0
		v_readfirstlane_b32 s24, v1
		s_cmp_lt_i32 s24, 0
		v_accvgpr_read_b32 v1, a5
		s_nop 0
		v_readfirstlane_b32 s24, v1
		s_cselect_b32 s23, s23, s24
		v_mov_b32_e32 v1, s23
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		v_mov_b32_e32 v2, 0x4f7ffffe
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_mul_i32 s18, s18, 2
		v_readfirstlane_b32 s24, v1
		s_xor_b32 s25, s23, -1
		s_add_i32 s25, s25, 1
		s_mul_i32 s26, s25, s24
		s_mul_hi_u32 s26, s24, s26
		s_add_i32 s24, s24, s26
		s_mul_hi_u32 s24, s21, s24
		s_mul_i32 s26, s24, s23
		s_xor_b32 s26, s26, -1
		s_add_i32 s26, s26, 1
		s_add_i32 s21, s21, s26
		s_cmp_ge_u32 s21, s23
		s_cselect_b32 s26, 1, 0
		s_add_i32 s27, s24, 1
		s_cmp_lg_u32 s26, 0
		s_cselect_b32 s24, s27, s24
		s_cselect_b32 s26, 1, 0
		s_add_i32 s27, s21, s25
		s_cmp_lg_u32 s26, 0
		s_cselect_b32 s21, s27, s21
		s_cmp_ge_u32 s21, s23
		s_cselect_b32 s23, 1, 0
		s_add_i32 s26, s24, 1
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s23, s26, s24
		s_cselect_b32 s24, 1, 0
		v_accvgpr_read_b32 v1, a5
		s_nop 0
		v_readfirstlane_b32 s26, v1
		s_xor_b32 s1, s1, s26
		s_xor_b32 s26, s23, -1
		s_add_i32 s26, s26, 1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s1, s26, s23
		v_mov_b32_e32 v1, s1
		v_accvgpr_write_b32 a11, v1
		s_add_i32 s1, s21, s25
		s_cmp_lg_u32 s24, 0
		s_cselect_b32 s1, s1, s21
		s_xor_b32 s21, s1, -1
		s_add_i32 s21, s21, 1
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s1, s21, s1
		v_mov_b32_e32 v1, s1
		v_accvgpr_write_b32 a12, v1
		s_cmp_lt_i32 s18, 32
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_1
		s_lshr_b32 s1, s18, 1
		s_and_b32 s18, s18, 1
		s_xor_b32 s21, s1, -1
		s_add_i32 s21, s21, 1
		s_add_i32 s21, s21, 31
		s_cmp_eq_u32 s18, 0
		s_cselect_b32 s1, s1, s21
		v_mov_b32_e32 v1, s1
		v_accvgpr_write_b32 a13, v1
		v_accvgpr_read_b32 v1, a13
		s_nop 0
		v_readfirstlane_b32 s1, v1
		s_mul_i32 s1, s1, 0x100
		v_and_b32_e32 v1, 1, v0
		v_lshrrev_b32_e32 v2, 1, v0
		v_and_b32_e32 v2, 1, v2
		v_mov_b32_e32 v3, 2
		v_mul_lo_u32 v3, v3, v2
		v_lshrrev_b32_e32 v2, 2, v0
		v_and_b32_e32 v4, 1, v2
		v_mov_b32_e32 v5, 4
		v_mul_lo_u32 v5, v5, v4
		v_bitop3_b32 v4, v1, v3, v5 bitop3:0x96
		v_lshrrev_b32_e32 v6, 3, v0
		v_and_b32_e32 v7, 1, v6
		v_mov_b32_e32 v8, 8
		v_mul_lo_u32 v8, v8, v7
		v_xor_b32_e32 v4, v4, v8
		v_lshrrev_b32_e32 v9, 4, v0
		v_and_b32_e32 v10, 1, v9
		v_mov_b32_e32 v11, 16
		v_mul_lo_u32 v11, v11, v10
		v_lshrrev_b32_e32 v12, 6, v0
		v_accvgpr_write_b32 a14, v12
		v_accvgpr_read_b32 v12, a14
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v13, 32
		v_mul_lo_u32 v13, v13, v12
		v_bitop3_b32 v4, v4, v11, v13 bitop3:0x96
		v_lshrrev_b32_e32 v14, 7, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 64
		v_mul_lo_u32 v15, v15, v14
		v_xor_b32_e32 v4, v4, v15
		v_accvgpr_write_b32 a15, v4
		v_xor_b32_e32 v1, 0x80, v1
		v_xor_b32_e32 v1, v1, v3
		v_xor_b32_e32 v1, v1, v5
		v_bitop3_b32 v1, v1, v8, v11 bitop3:0x96
		v_bitop3_b32 v1, v1, v13, v15 bitop3:0x96
		v_accvgpr_write_b32 a16, v1
		v_mov_b32_e32 v1, 2
		v_mul_lo_u32 v1, v1, v10
		v_lshrrev_b32_e32 v3, 5, v0
		v_and_b32_e32 v4, 1, v3
		v_mov_b32_e32 v5, 4
		v_mul_lo_u32 v5, v5, v4
		v_bitop3_b32 v8, v7, v1, v5 bitop3:0x96
		v_mov_b32_e32 v11, 8
		v_mul_lo_u32 v11, v11, v12
		v_xor_b32_e32 v8, v8, v11
		v_mov_b32_e32 v13, 16
		v_mul_lo_u32 v13, v13, v14
		v_xad_u32 v8, v8, v13, s1
		v_bitop3_b32 v15, 32, v7, v1 bitop3:0x96
		v_bitop3_b32 v15, v15, v5, v11 bitop3:0x96
		v_xad_u32 v15, v15, v13, s1
		v_bitop3_b32 v16, 64, v7, v1 bitop3:0x96
		v_bitop3_b32 v16, v16, v5, v11 bitop3:0x96
		v_xad_u32 v16, v16, v13, s1
		v_xor_b32_e32 v17, 0x60, v7
		v_xor_b32_e32 v17, v17, v1
		v_xor_b32_e32 v17, v17, v5
		v_xor_b32_e32 v17, v17, v11
		v_xad_u32 v17, v17, v13, s1
		v_xor_b32_e32 v18, 0x80, v7
		v_xor_b32_e32 v18, v18, v1
		v_xor_b32_e32 v18, v18, v5
		v_xor_b32_e32 v18, v18, v11
		v_xad_u32 v18, v18, v13, s1
		v_xor_b32_e32 v19, 0xa0, v7
		v_xor_b32_e32 v19, v19, v1
		v_xor_b32_e32 v19, v19, v5
		v_xor_b32_e32 v19, v19, v11
		v_xad_u32 v19, v19, v13, s1
		v_xor_b32_e32 v20, 0xc0, v7
		v_xor_b32_e32 v20, v20, v1
		v_xor_b32_e32 v20, v20, v5
		v_xor_b32_e32 v20, v20, v11
		v_xad_u32 v20, v20, v13, s1
		v_xor_b32_e32 v21, 0xe0, v7
		v_xor_b32_e32 v1, v21, v1
		v_xor_b32_e32 v1, v1, v5
		v_xor_b32_e32 v1, v1, v11
		v_xad_u32 v1, v1, v13, s1
		v_cmp_lt_i32_e64 s[22:23], v8, s19
		v_cmp_lt_i32_e64 s[24:25], v15, s19
		v_cmp_lt_i32_e64 s[26:27], v16, s19
		v_cmp_lt_i32_e64 s[28:29], v17, s19
		v_cmp_lt_i32_e64 s[30:31], v18, s19
		v_cmp_lt_i32_e64 s[32:33], v19, s19
		v_cmp_lt_i32_e64 s[34:35], v20, s19
		s_mov_b32 s38, 0x7fffffff
		s_mov_b32 s39, 0x31016000
		s_mov_b32 s36, s2
		s_mov_b32 s37, s3
		v_accvgpr_read_b32 v8, a7
		v_and_b32_e32 v8, 0xffff, v8
		v_lshlrev_b32_e32 v11, 16, v8
		v_or_b32_e32 v16, v8, v11
		v_mov_b32_e32 v17, v16
		v_mov_b32_e32 v18, v16
		v_mov_b32_e32 v19, v16
		v_accvgpr_read_b32 v8, a13
		s_nop 0
		v_readfirstlane_b32 s18, v8
		s_mul_i32 s18, s18, s12
		s_lshl_b32 s18, s18, 9
		v_accvgpr_read_b32 v8, a11
		s_nop 0
		v_readfirstlane_b32 s21, v8
		s_mul_i32 s21, s21, s10
		s_lshl_b32 s21, s21, 1
		s_add_i32 s40, s18, s21
		v_accvgpr_read_b32 v8, a12
		s_nop 0
		v_readfirstlane_b32 s41, v8
		s_mul_i32 s41, s41, s11
		s_lshl_b32 s41, s41, 1
		s_add_i32 s40, s40, s41
		v_mul_lo_u32 v8, s12, v6
		v_lshl_add_u32 v11, v8, 1, s40
		v_and_b32_e32 v13, 7, v0
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_0
		buffer_load_dwordx4 v[20:23], v11, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_0:
		s_andn2_b64 exec, s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_0
		v_mov_b32_e32 v20, v16
		v_mov_b32_e32 v21, v17
		v_mov_b32_e32 v22, v18
		v_mov_b32_e32 v23, v19
.L_attn_fwd_persistent.exec_endif_0:
		s_mov_b64 exec, s[96:97]
		s_lshl_b32 s22, s12, 6
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s41
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_1
		buffer_load_dwordx4 v[24:27], v11, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_1:
		s_andn2_b64 exec, s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_1
		v_mov_b32_e32 v24, v16
		v_mov_b32_e32 v25, v17
		v_mov_b32_e32 v26, v18
		v_mov_b32_e32 v27, v19
.L_attn_fwd_persistent.exec_endif_1:
		s_mov_b64 exec, s[96:97]
		s_lshl_b32 s22, s12, 7
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s41
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_2
		buffer_load_dwordx4 v[28:31], v11, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_2:
		s_andn2_b64 exec, s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_2
		v_mov_b32_e32 v28, v16
		v_mov_b32_e32 v29, v17
		v_mov_b32_e32 v30, v18
		v_mov_b32_e32 v31, v19
.L_attn_fwd_persistent.exec_endif_2:
		s_mov_b64 exec, s[96:97]
		s_mul_i32 s22, 0xc0, s12
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s41
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_3
		buffer_load_dwordx4 v[32:35], v11, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_3:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_3
		v_mov_b32_e32 v32, v16
		v_mov_b32_e32 v33, v17
		v_mov_b32_e32 v34, v18
		v_mov_b32_e32 v35, v19
.L_attn_fwd_persistent.exec_endif_3:
		s_mov_b64 exec, s[96:97]
		s_lshl_b32 s22, s12, 8
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s41
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_4
		buffer_load_dwordx4 v[36:39], v11, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_4:
		s_andn2_b64 exec, s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_4
		v_mov_b32_e32 v36, v16
		v_mov_b32_e32 v37, v17
		v_mov_b32_e32 v38, v18
		v_mov_b32_e32 v39, v19
.L_attn_fwd_persistent.exec_endif_4:
		s_mov_b64 exec, s[96:97]
		s_mul_i32 s22, 0x140, s12
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s41
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_5
		buffer_load_dwordx4 v[40:43], v11, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_5:
		s_andn2_b64 exec, s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_5
		v_mov_b32_e32 v40, v16
		v_mov_b32_e32 v41, v17
		v_mov_b32_e32 v42, v18
		v_mov_b32_e32 v43, v19
.L_attn_fwd_persistent.exec_endif_5:
		s_mov_b64 exec, s[96:97]
		s_mul_i32 s22, 0x180, s12
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s41
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_6
		buffer_load_dwordx4 v[44:47], v11, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_6:
		s_andn2_b64 exec, s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_6
		v_mov_b32_e32 v44, v16
		v_mov_b32_e32 v45, v17
		v_mov_b32_e32 v46, v18
		v_mov_b32_e32 v47, v19
.L_attn_fwd_persistent.exec_endif_6:
		s_mov_b64 exec, s[96:97]
		s_mul_i32 s22, 0x1c0, s12
		s_add_i32 s18, s22, s18
		s_add_i32 s18, s18, s21
		s_add_i32 s18, s18, s41
		v_lshl_add_u32 v8, v8, 1, s18
		v_lshl_add_u32 v8, v13, 4, v8
		v_cmp_lt_i32_e64 vcc, v1, s19
		s_and_saveexec_b64 s[96:97], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_7
		buffer_load_dwordx4 v[48:51], v8, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_7:
		s_andn2_b64 exec, s[96:97], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_7
		v_mov_b32_e32 v48, v16
		v_mov_b32_e32 v49, v17
		v_mov_b32_e32 v50, v18
		v_mov_b32_e32 v51, v19
.L_attn_fwd_persistent.exec_endif_7:
		s_mov_b64 exec, s[96:97]
		s_mov_b32 s24, s4
		s_mov_b32 s25, s5
		s_mov_b32 s26, s38
		s_mov_b32 s27, s39
		s_mov_b32 s28, s6
		s_mov_b32 s29, s7
		s_mov_b32 s30, s38
		s_mov_b32 s31, s39
		s_waitcnt vmcnt(0)
		s_barrier
		v_and_b32_e32 v1, 1, v3
		v_accvgpr_write_b32 a17, v1
		v_accvgpr_read_b32 v1, a17
		v_lshlrev_b32_e32 v1, 1, v1
		v_accvgpr_read_b32 v3, a14
		v_and_b32_e32 v3, 1, v3
		v_lshlrev_b32_e32 v3, 2, v3
		v_and_b32_e32 v8, 1, v9
		v_accvgpr_write_b32 a18, v8
		v_accvgpr_read_b32 v8, a18
		v_xor_b32_e32 v3, v3, v8
		v_bitop3_b32 v1, v0, v1, v3 bitop3:0x96
		v_lshlrev_b32_e32 v1, 4, v1
		v_add_u32_e32 v1, 0x10000, v1
		ds_write_b128 v1, v[20:23] offset:2480
		ds_write_b128 v1, v[24:27] offset:6576
		ds_write_b128 v1, v[28:31] offset:10672
		ds_write_b128 v1, v[32:35] offset:14768
		v_mov_b32_e32 v3, 32
		v_mul_lo_u32 v3, v3, v10
		v_mov_b32_e32 v8, 2
		v_mul_lo_u32 v8, v8, v14
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v9, a14
		v_lshlrev_b32_e32 v9, 12, v9
		v_add_u32_e32 v9, 0x10000, v9
		v_and_b32_e32 v10, 63, v0
		v_and_b32_e32 v11, 7, v10
		v_lshrrev_b32_e32 v14, 2, v11
		v_lshl_add_u32 v15, v14, 5, v9
		v_lshrrev_b32_e32 v16, 3, v10
		v_bitop3_b32 v16, v16, 3, 1 bitop3:0x80
		v_lshl_add_u32 v17, v16, 6, v15
		v_lshrrev_b32_e32 v18, 5, v10
		v_and_b32_e32 v10, 31, v10
		v_lshlrev_b32_e32 v19, 3, v10
		v_add_u32_e32 v20, v18, v19
		v_lshrrev_b32_e32 v11, 1, v11
		v_and_b32_e32 v11, 1, v11
		v_xor_b32_e32 v20, v20, v11
		v_lshl_add_u32 v17, v20, 4, v17
		ds_read_b128 a[20:23], v17 offset:2480
		v_lshl_add_u32 v20, v16, 6, v9
		v_add3_u32 v21, 2, v18, v19
		v_lshlrev_b32_e32 v14, 1, v14
		v_bitop3_b32 v21, v21, v14, v11 bitop3:0x96
		v_lshl_add_u32 v20, v21, 4, v20
		ds_read_b128 a[24:27], v20 offset:2480
		v_add3_u32 v21, 4, v18, v19
		v_lshlrev_b32_e32 v16, 2, v16
		v_xor_b32_e32 v11, v16, v11
		v_xor_b32_e32 v16, v21, v11
		v_lshl_add_u32 v15, v16, 4, v15
		ds_read_b128 a[28:31], v15 offset:2480
		v_add3_u32 v16, 6, v18, v19
		v_bitop3_b32 v11, v16, v14, v11 bitop3:0x96
		v_lshl_add_u32 v9, v11, 4, v9
		ds_read_b128 a[32:35], v9 offset:2480
		v_and_b32_e32 v6, 1, v6
		v_lshlrev_b32_e32 v11, 4, v13
		v_and_b32_e32 v2, 1, v2
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[36:39] offset:2480
		ds_write_b128 v1, v[40:43] offset:6576
		ds_write_b128 v1, v[44:47] offset:10672
		ds_write_b128 v1, v[48:51] offset:14768
		v_accvgpr_read_b32 v1, a13
		s_nop 0
		v_readfirstlane_b32 s18, v1
		s_add_i32 s18, s18, 1
		s_mul_i32 s18, s18, 0x100
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[36:39], v17 offset:2480
		ds_read_b128 a[40:43], v20 offset:2480
		ds_read_b128 a[44:47], v15 offset:2480
		ds_read_b128 a[48:51], v9 offset:2480
		v_accvgpr_read_b32 v1, a6
		s_nop 0
		v_readfirstlane_b32 s21, v1
		s_add_i32 s18, s18, s21
		s_cmp_lt_i32 s20, s18
		s_cselect_b32 s18, s20, s18
		s_add_i32 s21, s18, 0x7f
		s_mov_b32 s22, 0x7f
		s_cmp_lt_i32 s21, 0
		s_cselect_b32 s23, s22, 0
		s_add_i32 s21, s21, s23
		s_ashr_i32 s21, s21, 7
		v_accvgpr_read_b32 v1, a6
		s_nop 0
		v_readfirstlane_b32 s23, v1
		s_add_i32 s23, s1, s23
		s_cmp_lt_i32 s23, 0
		s_cselect_b32 s32, s22, 0
		s_add_i32 s23, s23, s32
		s_ashr_i32 s23, s23, 7
		s_cmp_lt_i32 s23, s21
		s_cselect_b32 s23, s23, s21
		s_cmp_gt_i32 s23, 0
		s_cselect_b32 s23, s23, 0
		v_mov_b32_e32 v1, 64
		v_mul_lo_u32 v1, v1, v7
		v_mov_b32_e32 v9, 16
		v_mul_lo_u32 v9, v9, v4
		v_bitop3_b32 v13, v1, v3, v9 bitop3:0x96
		v_bitop3_b32 v13, v13, v12, v8 bitop3:0x96
		v_accvgpr_write_b32 a19, v13
		v_bitop3_b32 v13, 4, v1, v3 bitop3:0x96
		v_xor_b32_e32 v13, v13, v9
		v_bitop3_b32 v14, 8, v1, v3 bitop3:0x96
		v_xor_b32_e32 v14, v14, v9
		v_bitop3_b32 v1, 12, v1, v3 bitop3:0x96
		v_accvgpr_read_b32 v15, a19
		v_cmp_lt_i32_e64 s[32:33], v15, s20
		v_mov_b32_e32 v15, 16
		v_mul_lo_u32 v15, v15, v7
		v_mov_b32_e32 v7, 64
		v_mul_lo_u32 v7, v7, v4
		v_bitop3_b32 v4, v15, v3, v7 bitop3:0x96
		v_bitop3_b32 v4, v4, v12, v8 bitop3:0x96
		v_accvgpr_write_b32 a52, v4
		v_bitop3_b32 v4, 4, v15, v3 bitop3:0x96
		v_bitop3_b32 v16, 8, v15, v3 bitop3:0x96
		v_bitop3_b32 v3, 12, v15, v3 bitop3:0x96
		v_accvgpr_read_b32 v15, a52
		v_cmp_lt_i32_e64 vcc, v15, s20
		v_readfirstlane_b32 s34, v0
		v_accvgpr_read_b32 v15, a11
		s_nop 0
		v_readfirstlane_b32 s35, v15
		s_mul_i32 s35, s35, s13
		s_lshl_b32 s35, s35, 1
		v_accvgpr_read_b32 v15, a12
		s_nop 0
		v_readfirstlane_b32 s36, v15
		s_mul_i32 s36, s36, s14
		s_lshl_b32 s36, s36, 1
		s_add_i32 s37, s35, s36
		v_accvgpr_read_b32 v15, a14
		v_mul_lo_u32 v15, s15, v15
		v_lshlrev_b32_e32 v15, 1, v15
		v_add_u32_e32 v17, s37, v15
		v_accvgpr_read_b32 v19, a17
		v_mul_lo_u32 v19, s15, v19
		v_lshlrev_b32_e32 v19, 5, v19
		v_accvgpr_read_b32 v20, a18
		v_mul_lo_u32 v20, s15, v20
		v_lshlrev_b32_e32 v20, 6, v20
		v_add3_u32 v17, v17, v19, v20
		v_mul_lo_u32 v21, s15, v6
		v_lshlrev_b32_e32 v21, 7, v21
		v_add3_u32 v17, v17, v21, v11
		v_mov_b32_e32 v22, 0x80000000
		v_cndmask_b32_e64 v17, v22, v17, s[32:33]
		s_lshr_b32 s37, s34, 6
		s_mul_i32 s40, 0x410, s37
		s_mov_b32 m0, s40
		v_accvgpr_read_b32 v23, a15
		v_add_u32_e32 v23, s1, v23
		buffer_load_dwordx4 v17, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[42:43], v23, s19
		s_nop 1
		v_mov_b32_e32 v24, s42
		v_mov_b32_e32 v25, s43
		v_accvgpr_write_b32 a54, v24
		v_accvgpr_write_b32 a55, v25
		s_lshl_b32 s41, s15, 3
		s_add_i32 s41, s41, s35
		s_add_i32 s41, s41, s36
		v_add_u32_e32 v17, s41, v15
		v_add3_u32 v17, v17, v19, v20
		v_add3_u32 v17, v17, v21, v11
		v_cndmask_b32_e64 v17, v22, v17, s[32:33]
		s_add_i32 m0, m0, 0x1040
		v_accvgpr_read_b32 v23, a16
		v_add_u32_e32 v23, s1, v23
		buffer_load_dwordx4 v17, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[42:43], v23, s19
		s_nop 1
		v_mov_b32_e32 v24, s42
		v_mov_b32_e32 v25, s43
		v_accvgpr_write_b32 a56, v24
		v_accvgpr_write_b32 a57, v25
		s_lshl_b32 s41, s15, 4
		s_add_i32 s41, s41, s35
		s_add_i32 s41, s41, s36
		v_add_u32_e32 v17, s41, v15
		v_add3_u32 v17, v17, v19, v20
		v_add3_u32 v17, v17, v21, v11
		v_cndmask_b32_e64 v17, v22, v17, s[32:33]
		s_add_i32 m0, m0, 0x1040
		v_lshlrev_b32_e32 v18, 4, v18
		v_accvgpr_write_b32 a53, v18
		buffer_load_dwordx4 v17, s[24:27], 0 offen lds
		v_bitop3_b32 v13, v13, v12, v8 bitop3:0x96
		v_accvgpr_write_b32 a58, v13
		s_mul_i32 s41, 24, s15
		s_add_i32 s41, s41, s35
		s_add_i32 s41, s41, s36
		v_add_u32_e32 v13, s41, v15
		v_add3_u32 v13, v13, v19, v20
		v_add3_u32 v13, v13, v21, v11
		v_cndmask_b32_e64 v13, v22, v13, s[32:33]
		s_add_i32 m0, m0, 0x1040
		v_mov_b32_e32 v17, 0x440
		v_mul_lo_u32 v17, v17, v2
		v_accvgpr_write_b32 a59, v17
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		v_bitop3_b32 v2, v14, v12, v8 bitop3:0x96
		v_accvgpr_write_b32 a60, v2
		v_accvgpr_read_b32 v2, a0
		s_nop 0
		v_readfirstlane_b32 s32, v2
		v_accvgpr_read_b32 v2, a11
		s_nop 0
		v_readfirstlane_b32 s33, v2
		s_mul_i32 s32, s33, s32
		s_lshl_b32 s32, s32, 1
		v_accvgpr_read_b32 v2, a1
		s_nop 0
		v_readfirstlane_b32 s33, v2
		v_accvgpr_read_b32 v2, a12
		s_nop 0
		v_readfirstlane_b32 s41, v2
		s_mul_i32 s33, s41, s33
		s_lshl_b32 s33, s33, 1
		s_add_i32 s41, s32, s33
		v_accvgpr_read_b32 v2, a14
		v_mul_lo_u32 v2, s17, v2
		v_lshlrev_b32_e32 v2, 1, v2
		v_add_u32_e32 v13, s41, v2
		v_accvgpr_read_b32 v14, a17
		v_mul_lo_u32 v14, s17, v14
		v_lshlrev_b32_e32 v14, 7, v14
		v_accvgpr_read_b32 v17, a18
		v_mul_lo_u32 v17, s17, v17
		v_lshlrev_b32_e32 v17, 6, v17
		v_add3_u32 v13, v13, v14, v17
		v_mul_lo_u32 v18, s17, v6
		v_lshlrev_b32_e32 v18, 5, v18
		v_add3_u32 v13, v13, v18, v11
		v_cndmask_b32_e32 v13, v22, v13, vcc
		s_mul_i32 s37, 0x440, s37
		s_add_i32 m0, s37, 0x81f0
		v_xor_b32_e32 v1, v1, v9
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		v_bitop3_b32 v1, v1, v12, v8 bitop3:0x96
		v_accvgpr_write_b32 a61, v1
		s_lshl_b32 s41, s17, 3
		s_add_i32 s41, s41, s32
		s_add_i32 s41, s41, s33
		v_add_u32_e32 v1, s41, v2
		v_add3_u32 v1, v1, v14, v17
		v_add3_u32 v1, v1, v18, v11
		v_cndmask_b32_e32 v1, v22, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v4, v4, v7
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_bitop3_b32 v1, v4, v12, v8 bitop3:0x96
		v_accvgpr_write_b32 a62, v1
		s_lshl_b32 s41, s17, 4
		s_add_i32 s41, s41, s32
		s_add_i32 s41, s41, s33
		v_add_u32_e32 v1, s41, v2
		v_add3_u32 v1, v1, v14, v17
		v_add3_u32 v1, v1, v18, v11
		v_cndmask_b32_e32 v1, v22, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v4, v16, v7
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_bitop3_b32 v1, v4, v12, v8 bitop3:0x96
		v_accvgpr_write_b32 a63, v1
		s_mul_i32 s41, 24, s17
		s_add_i32 s41, s41, s32
		s_add_i32 s41, s41, s33
		v_add_u32_e32 v1, s41, v2
		v_add3_u32 v1, v1, v14, v17
		v_add3_u32 v1, v1, v18, v11
		v_cndmask_b32_e32 v1, v22, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v3, v3, v7
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_bitop3_b32 v1, v3, v12, v8 bitop3:0x96
		v_accvgpr_write_b32 a64, v1
		s_mul_i32 s41, s23, 0x80
		v_mbcnt_lo_u32_b32 v1, -1, 0
		v_mbcnt_hi_u32_b32 v1, -1, v1
		v_and_b32_e32 v1, 31, v1
		v_add_u32_e32 v3, 32, v1
		v_mov_b32_e32 v8, 0x3e38aa3b
		v_mov_b32_e32 v9, 0x3e38aa3b
		s_mov_b32 s23, 0xff800000
		v_mov_b32_e32 v4, s23
		v_mov_b32_e32 v7, s23
		s_mov_b32 s23, 1.0
		v_mov_b32_e32 v12, s23
		v_mov_b32_e32 v13, s23
		s_mov_b32 s23, 0
		v_lshrrev_b32_e32 v16, 4, v10
		v_lshlrev_b32_e32 v16, 9, v16
		v_accvgpr_write_b32 a65, v16
		v_and_b32_e32 v10, 15, v10
		v_mov_b32_e32 v16, 0x410
		v_mul_lo_u32 v16, v16, v10
		v_accvgpr_write_b32 a66, v16
		v_and_b32_e32 v10, 3, v0
		v_accvgpr_write_b32 a67, v10
		v_accvgpr_read_b32 v10, a67
		v_lshlrev_b32_e32 v10, 3, v10
		v_accvgpr_write_b32 a68, v10
		v_accvgpr_read_b32 v10, a17
		v_mov_b32_e32 v16, 0x2200
		v_mul_lo_u32 v16, v16, v10
		v_accvgpr_write_b32 a69, v16
		v_accvgpr_read_b32 v10, a18
		v_lshlrev_b32_e32 v10, 5, v10
		v_accvgpr_write_b32 a70, v10
		v_mov_b32_e32 v10, 0x880
		v_mul_lo_u32 v10, v10, v6
		v_accvgpr_write_b32 a71, v10
		s_lshl_b32 s42, s15, 8
		s_add_i32 s42, s42, s35
		s_add_i32 s42, s42, s36
		s_mul_i32 s43, 0x108, s15
		s_add_i32 s43, s43, s35
		s_add_i32 s43, s43, s36
		s_mul_i32 s44, 0x110, s15
		s_add_i32 s44, s44, s35
		s_add_i32 s44, s44, s36
		s_mul_i32 s45, 0x118, s15
		s_add_i32 s35, s45, s35
		s_add_i32 s36, s35, s36
		s_lshl_b32 s35, s17, 8
		s_add_i32 s35, s35, s32
		s_add_i32 s45, s35, s33
		s_mul_i32 s35, 0x108, s17
		s_add_i32 s35, s35, s32
		s_add_i32 s46, s35, s33
		s_mul_i32 s35, 0x110, s17
		s_add_i32 s35, s35, s32
		s_add_i32 s47, s35, s33
		s_mul_i32 s35, 0x118, s17
		s_add_i32 s32, s35, s32
		s_add_i32 s32, s32, s33
		v_lshlrev_b32_e32 v1, 2, v1
		v_accvgpr_write_b32 a72, v1
		v_lshlrev_b32_e32 v1, 2, v3
		v_accvgpr_write_b32 a73, v1
		v_add3_u32 v1, v15, v19, v20
		v_add_u32_e32 v1, v1, v21
		v_add3_u32 v3, v2, v14, v17
		v_add_u32_e32 v3, v3, v18
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
		s_lshr_b32 s33, s23, 7
		s_and_b32 s35, s33, 1
		s_mul_i32 s48, 0x4100, s35
		v_accvgpr_read_b32 v6, a53
		v_add_u32_e32 v6, s48, v6
		v_accvgpr_read_b32 v10, a65
		v_accvgpr_read_b32 v16, a66
		v_add3_u32 v6, v6, v10, v16
		ds_read_b128 v[24:27], v6
		ds_read_b128 v[28:31], v6 offset:32
		ds_read_b128 v[96:99], v6 offset:64
		ds_read_b128 a[76:79], v6 offset:96
		ds_read_b128 v[100:103], v6 offset:256
		ds_read_b128 v[104:107], v6 offset:288
		ds_read_b128 v[108:111], v6 offset:320
		ds_read_b128 a[80:83], v6 offset:352
		ds_read_b128 v[112:115], v6 offset:128
		ds_read_b128 v[116:119], v6 offset:160
		ds_read_b128 v[120:123], v6 offset:192
		ds_read_b128 a[84:87], v6 offset:224
		ds_read_b128 a[88:91], v6 offset:384
		ds_read_b128 a[92:95], v6 offset:416
		ds_read_b128 a[96:99], v6 offset:448
		ds_read_b128 a[100:103], v6 offset:480
		s_mul_i32 s35, 0x4400, s35
		v_accvgpr_read_b32 v6, a68
		v_add_u32_e32 v6, s35, v6
		v_accvgpr_read_b32 v10, a70
		v_accvgpr_read_b32 v16, a69
		v_add3_u32 v6, v6, v16, v10
		v_accvgpr_read_b32 v10, a59
		v_accvgpr_read_b32 v16, a71
		v_add3_u32 v6, v6, v16, v10
		ds_read_b64_tr_b16 a[104:105], v6 offset:33264
		ds_read_b64_tr_b16 a[106:107], v6 offset:37616
		ds_read_b64_tr_b16 a[108:109], v6 offset:33392
		ds_read_b64_tr_b16 a[110:111], v6 offset:37744
		ds_read_b64_tr_b16 a[112:113], v6 offset:33520
		ds_read_b64_tr_b16 a[114:115], v6 offset:37872
		ds_read_b64_tr_b16 a[116:117], v6 offset:33648
		ds_read_b64_tr_b16 a[118:119], v6 offset:38000
		ds_read_b64_tr_b16 a[120:121], v6 offset:33776
		ds_read_b64_tr_b16 a[122:123], v6 offset:38128
		ds_read_b64_tr_b16 a[124:125], v6 offset:33904
		ds_read_b64_tr_b16 a[126:127], v6 offset:38256
		ds_read_b64_tr_b16 a[128:129], v6 offset:34032
		ds_read_b64_tr_b16 a[130:131], v6 offset:38384
		ds_read_b64_tr_b16 a[132:133], v6 offset:34160
		ds_read_b64_tr_b16 a[134:135], v6 offset:38512
		ds_read_b64_tr_b16 a[136:137], v6 offset:33328
		ds_read_b64_tr_b16 a[138:139], v6 offset:37680
		ds_read_b64_tr_b16 a[140:141], v6 offset:33456
		ds_read_b64_tr_b16 a[142:143], v6 offset:37808
		ds_read_b64_tr_b16 a[144:145], v6 offset:33584
		ds_read_b64_tr_b16 a[146:147], v6 offset:37936
		ds_read_b64_tr_b16 a[148:149], v6 offset:33712
		ds_read_b64_tr_b16 a[150:151], v6 offset:38064
		ds_read_b64_tr_b16 a[152:153], v6 offset:33840
		ds_read_b64_tr_b16 a[154:155], v6 offset:38192
		ds_read_b64_tr_b16 a[156:157], v6 offset:33968
		ds_read_b64_tr_b16 a[158:159], v6 offset:38320
		ds_read_b64_tr_b16 a[160:161], v6 offset:34096
		ds_read_b64_tr_b16 a[162:163], v6 offset:38448
		ds_read_b64_tr_b16 a[164:165], v6 offset:34224
		ds_read_b64_tr_b16 a[166:167], v6 offset:38576
		s_mul_i32 s35, s15, s23
		s_lshl_b32 s35, s35, 1
		s_add_i32 s48, s42, s35
		v_add_u32_e32 v6, s48, v15
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[128:143], v[24:27], a[20:23], 0
		v_add3_u32 v6, v6, v19, v20
		v_mfma_f32_32x32x16_bf16 v[128:143], v[28:31], a[24:27], v[128:143]
		v_add3_u32 v6, v6, v21, v11
		v_mfma_f32_32x32x16_bf16 v[128:143], v[96:99], a[28:31], v[128:143]
		s_add_i32 s33, s33, 1
		v_mfma_f32_32x32x16_bf16 v[144:159], v[24:27], a[36:39], 0
		s_and_b32 s33, s33, 1
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[40:43], v[144:159]
		s_mul_i32 s48, 0x4100, s33
		v_mfma_f32_32x32x16_bf16 v[144:159], v[96:99], a[44:47], v[144:159]
		s_add_i32 s48, s40, s48
		v_mfma_f32_32x32x16_bf16 v[160:175], v[100:103], a[20:23], 0
		s_mov_b32 m0, s48
		v_mfma_f32_32x32x16_bf16 v[160:175], v[104:107], a[24:27], v[160:175]
		s_add_i32 s48, s43, s35
		v_mfma_f32_32x32x16_bf16 v[160:175], v[108:111], a[28:31], v[160:175]
		v_add3_u32 v10, v11, v1, s48
		v_mfma_f32_32x32x16_bf16 v[176:191], v[100:103], a[36:39], 0
		s_add_i32 s48, s44, s35
		v_mfma_f32_32x32x16_bf16 v[176:191], v[104:107], a[40:43], v[176:191]
		v_add3_u32 v16, v11, v1, s48
		v_mfma_f32_32x32x16_bf16 v[176:191], v[108:111], a[44:47], v[176:191]
		s_add_i32 s35, s36, s35
		v_mfma_f32_32x32x16_bf16 v[96:111], v[112:115], a[20:23], 0
		v_add3_u32 v23, v11, v1, s35
		v_mfma_f32_32x32x16_bf16 v[96:111], v[116:119], a[24:27], v[96:111]
		s_mul_i32 s35, s17, s23
		v_mfma_f32_32x32x16_bf16 v[96:111], v[120:123], a[28:31], v[96:111]
		s_add_i32 s23, s23, 0x80
		v_mfma_f32_32x32x16_bf16 v[192:207], v[112:115], a[36:39], 0
		v_accvgpr_read_b32 v24, a19
		v_add_u32_e32 v24, s23, v24
		v_mfma_f32_32x32x16_bf16 v[192:207], v[116:119], a[40:43], v[192:207]
		v_accvgpr_read_b32 v25, a58
		v_add_u32_e32 v25, s23, v25
		v_mfma_f32_32x32x16_bf16 v[192:207], v[120:123], a[44:47], v[192:207]
		v_accvgpr_read_b32 v26, a60
		v_add_u32_e32 v26, s23, v26
		v_mfma_f32_32x32x16_bf16 v[112:127], a[88:91], a[20:23], 0
		v_accvgpr_read_b32 v27, a61
		v_add_u32_e32 v27, s23, v27
		v_mfma_f32_32x32x16_bf16 v[112:127], a[92:95], a[24:27], v[112:127]
		v_cmp_lt_i32_e64 s[48:49], v24, s20
		v_mfma_f32_32x32x16_bf16 v[112:127], a[96:99], a[28:31], v[112:127]
		v_accvgpr_read_b32 v24, a52
		v_add_u32_e32 v24, s23, v24
		v_mfma_f32_32x32x16_bf16 v[208:223], a[88:91], a[36:39], 0
		v_accvgpr_read_b32 v28, a62
		v_add_u32_e32 v28, s23, v28
		v_accvgpr_read_b32 v29, a63
		v_add_u32_e32 v29, s23, v29
		v_cmp_lt_i32_e64 s[50:51], v24, s20
		v_cndmask_b32_e64 v6, v22, v6, s[48:49]
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[48:49], v25, s20
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[52:53], v26, s20
		v_mfma_f32_32x32x16_bf16 v[208:223], a[92:95], a[40:43], v[208:223]
		v_cndmask_b32_e64 v6, v22, v10, s[48:49]
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[208:223], a[96:99], a[44:47], v[208:223]
		v_cndmask_b32_e64 v6, v22, v16, s[52:53]
		v_cmp_lt_i32_e64 s[48:49], v27, s20
		s_add_i32 m0, m0, 0x1040
		v_accvgpr_read_b32 v10, a64
		v_add_u32_e32 v10, s23, v10
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[128:143], a[76:79], a[32:35], v[128:143]
		v_cndmask_b32_e64 v6, v22, v23, s[48:49]
		v_cmp_lt_i32_e64 s[48:49], v28, s20
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s35, s35, 1
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[52:53], v29, s20
		s_add_i32 s54, s45, s35
		v_mfma_f32_32x32x16_bf16 v[144:159], a[76:79], a[48:51], v[144:159]
		v_add_u32_e32 v6, s54, v2
		v_add3_u32 v6, v6, v14, v17
		v_add3_u32 v6, v6, v18, v11
		v_cndmask_b32_e64 v6, v22, v6, s[50:51]
		v_max3_f32 v16, v128, v129, v130
		s_mul_i32 s33, 0x4400, s33
		v_max3_f32 v23, v132, v133, v134
		s_add_i32 s33, s37, s33
		v_max3_f32 v24, v136, v137, v138
		s_add_i32 m0, s33, 0x81f0
		s_add_i32 s33, s46, s35
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_add3_u32 v6, v11, v3, s33
		v_cndmask_b32_e64 v6, v22, v6, s[48:49]
		v_max3_f32 v25, v140, v141, v142
		s_add_i32 m0, m0, 0x1100
		s_add_i32 s33, s47, s35
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_add3_u32 v6, v11, v3, s33
		v_max3_f32 v16, v16, v131, v23
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v6, v22, v6, s[52:53]
		s_add_i32 s33, s32, s35
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v10, s20
		v_add3_u32 v6, v11, v3, s33
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e32 v6, v22, v6, vcc
		v_max3_f32 v10, v24, v139, v25
		v_max3_f32 v10, v16, v135, v10
		v_max3_f32 v16, v144, v145, v146
		v_max3_f32 v23, v148, v149, v150
		v_max3_f32 v24, v152, v153, v154
		v_max3_f32 v25, v156, v157, v158
		v_max3_f32 v16, v16, v147, v23
		v_max3_f32 v23, v24, v155, v25
		v_max3_f32 v16, v16, v151, v23
		s_cmp_lt_i32 s23, s41
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[160:175], a[80:83], a[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[84:87], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[100:103], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[100:103], a[48:51], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[80:83], a[48:51], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[84:87], a[48:51], v[192:207]
		s_nop 6
		v_max3_f32 v6, v160, v161, v162
		v_max3_f32 v23, v164, v165, v166
		v_max3_f32 v24, v168, v169, v170
		v_max3_f32 v25, v172, v173, v174
		v_max3_f32 v26, v96, v97, v98
		v_max3_f32 v27, v100, v101, v102
		v_max3_f32 v28, v104, v105, v106
		v_max3_f32 v29, v108, v109, v110
		v_max3_f32 v30, v112, v113, v114
		v_max3_f32 v31, v116, v117, v118
		v_max3_f32 v224, v120, v121, v122
		v_max3_f32 v225, v124, v125, v126
		v_max3_f32 v6, v6, v163, v23
		v_max3_f32 v23, v24, v171, v25
		v_max3_f32 v24, v26, v99, v27
		v_max3_f32 v25, v28, v107, v29
		v_max3_f32 v26, v30, v115, v31
		v_max3_f32 v27, v224, v123, v225
		v_max3_f32 v6, v6, v167, v23
		v_max3_f32 v23, v24, v103, v25
		v_max3_f32 v24, v26, v119, v27
		v_max3_f32 v6, v10, v143, v6
		v_max3_f32 v10, v23, v111, v24
		v_max3_f32 v6, v6, v175, v10
		v_max_f32_e32 v24, v6, v127
		v_mov_b32_e32 v25, v24
		v_max3_f32 v6, v176, v177, v178
		v_max3_f32 v10, v180, v181, v182
		v_max3_f32 v23, v184, v185, v186
		v_max3_f32 v26, v188, v189, v190
		v_max3_f32 v27, v192, v193, v194
		v_max3_f32 v28, v196, v197, v198
		v_max3_f32 v29, v200, v201, v202
		v_max3_f32 v30, v204, v205, v206
		v_max3_f32 v31, v208, v209, v210
		v_max3_f32 v224, v212, v213, v214
		v_max3_f32 v225, v216, v217, v218
		v_max3_f32 v226, v220, v221, v222
		v_max3_f32 v6, v6, v179, v10
		v_max3_f32 v10, v23, v187, v26
		v_max3_f32 v23, v27, v195, v28
		v_max3_f32 v26, v29, v203, v30
		v_permlane32_swap_b32_e32 v24, v25
		v_max3_f32 v27, v31, v211, v224
		v_max3_f32 v28, v225, v219, v226
		v_max3_f32 v6, v6, v183, v10
		v_max3_f32 v10, v23, v199, v26
		v_max3_f32 v23, v27, v215, v28
		v_max3_f32 v6, v16, v159, v6
		v_max3_f32 v10, v10, v207, v23
		v_max3_f32 v6, v6, v191, v10
		v_max_f32_e32 v26, v6, v223
		v_mov_b32_e32 v27, v26
		v_max_f32_e32 v28, v24, v25
		v_mov_b32_e32 v24, v4
		v_permlane32_swap_b32_e32 v26, v27
		v_max_f32_e32 v29, v26, v27
		v_pk_mul_f32 v[26:27], v[28:29], v[8:9]
		v_max_f32_e32 v28, v4, v26
		v_max_f32_e32 v29, v7, v27
		v_pk_fma_f32 v[26:27], v[128:129], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[130:131], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[132:133], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[134:135], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[136:137], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[138:139], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[140:141], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[142:143], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[160:161], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[162:163], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[164:165], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[166:167], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[168:169], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[170:171], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[172:173], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[174:175], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[96:97], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[98:99], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[108:109], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[110:111], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[112:113], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[114:115], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[116:117], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[118:119], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[120:121], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[122:123], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[124:125], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[126:127], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[144:145], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[146:147], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[148:149], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[150:151], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[154:155], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[156:157], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[158:159], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[176:177], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[178:179], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[180:181], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[182:183], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[184:185], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[186:187], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[188:189], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[190:191], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[192:193], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[194:195], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[196:197], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[198:199], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[200:201], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[202:203], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[204:205], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[206:207], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[208:209], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[210:211], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[212:213], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[214:215], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[216:217], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[218:219], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[220:221], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[218:219], v[222:223], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v220, v26
		v_exp_f32_e32 v222, v27
		v_exp_f32_e32 v26, v30
		v_exp_f32_e32 v224, v31
		v_exp_f32_e32 v30, v128
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
		v_exp_f32_e32 v142, v160
		v_exp_f32_e32 v242, v161
		v_exp_f32_e32 v160, v162
		v_exp_f32_e32 v244, v163
		v_exp_f32_e32 v162, v164
		v_exp_f32_e32 v246, v165
		v_exp_f32_e32 v164, v166
		v_exp_f32_e32 v248, v167
		v_exp_f32_e32 v166, v168
		v_exp_f32_e32 v250, v169
		v_exp_f32_e32 v168, v170
		v_exp_f32_e32 v252, v171
		v_exp_f32_e32 v221, v172
		v_exp_f32_e32 v223, v173
		v_exp_f32_e32 v27, v96
		v_exp_f32_e32 v225, v97
		v_exp_f32_e32 v31, v98
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
		v_exp_f32_e32 v161, v116
		v_exp_f32_e32 v245, v117
		v_exp_f32_e32 v163, v118
		v_exp_f32_e32 v247, v119
		v_exp_f32_e32 v165, v120
		v_exp_f32_e32 v249, v121
		v_exp_f32_e32 v167, v122
		v_exp_f32_e32 v251, v123
		v_exp_f32_e32 v169, v124
		v_exp_f32_e32 v253, v125
		v_exp_f32_e32 v96, v126
		v_exp_f32_e32 v98, v127
		v_exp_f32_e32 v100, v144
		v_exp_f32_e32 v102, v145
		v_exp_f32_e32 v104, v146
		v_exp_f32_e32 v106, v147
		v_exp_f32_e32 v108, v148
		v_exp_f32_e32 v110, v149
		v_exp_f32_e32 v112, v150
		v_exp_f32_e32 v114, v151
		v_exp_f32_e32 v116, v152
		v_exp_f32_e32 v118, v153
		v_exp_f32_e32 v120, v154
		v_exp_f32_e32 v122, v155
		v_exp_f32_e32 v124, v156
		v_exp_f32_e32 v126, v157
		v_exp_f32_e32 v144, v158
		v_exp_f32_e32 v146, v159
		v_exp_f32_e32 v148, v174
		v_exp_f32_e32 v150, v175
		v_exp_f32_e32 v152, v176
		v_exp_f32_e32 v154, v177
		v_exp_f32_e32 v156, v178
		v_exp_f32_e32 v158, v179
		v_exp_f32_e32 v170, v180
		v_exp_f32_e32 v172, v181
		v_exp_f32_e32 v174, v182
		v_exp_f32_e32 v176, v183
		v_exp_f32_e32 v178, v184
		v_exp_f32_e32 v180, v185
		v_exp_f32_e32 v182, v186
		v_exp_f32_e32 v184, v187
		v_exp_f32_e32 v97, v188
		v_exp_f32_e32 v99, v189
		v_exp_f32_e32 v101, v190
		v_exp_f32_e32 v103, v191
		v_exp_f32_e32 v105, v192
		v_exp_f32_e32 v107, v193
		v_exp_f32_e32 v109, v194
		v_exp_f32_e32 v111, v195
		v_exp_f32_e32 v113, v196
		v_exp_f32_e32 v115, v197
		v_exp_f32_e32 v117, v198
		v_exp_f32_e32 v119, v199
		v_exp_f32_e32 v121, v200
		v_exp_f32_e32 v123, v201
		v_exp_f32_e32 v125, v202
		v_exp_f32_e32 v127, v203
		v_exp_f32_e32 v145, v204
		v_exp_f32_e32 v147, v205
		v_exp_f32_e32 v149, v206
		v_exp_f32_e32 v151, v207
		v_exp_f32_e32 v153, v208
		v_exp_f32_e32 v155, v209
		v_exp_f32_e32 v157, v210
		v_exp_f32_e32 v159, v211
		v_exp_f32_e32 v171, v212
		v_exp_f32_e32 v173, v213
		v_exp_f32_e32 v175, v214
		v_exp_f32_e32 v177, v215
		v_exp_f32_e32 v179, v216
		v_exp_f32_e32 v181, v217
		v_exp_f32_e32 v183, v218
		v_exp_f32_e32 v185, v219
		v_pk_add_f32 v[186:187], v[220:221], v[222:223]
		v_pk_add_f32 v[188:189], v[26:27], v[224:225]
		v_pk_add_f32 v[190:191], v[30:31], v[226:227]
		v_pk_add_f32 v[192:193], v[128:129], v[228:229]
		v_pk_add_f32 v[194:195], v[130:131], v[230:231]
		v_pk_add_f32 v[196:197], v[132:133], v[232:233]
		v_pk_add_f32 v[198:199], v[134:135], v[234:235]
		v_pk_add_f32 v[200:201], v[136:137], v[236:237]
		v_pk_add_f32 v[202:203], v[138:139], v[238:239]
		v_pk_add_f32 v[204:205], v[140:141], v[240:241]
		v_pk_add_f32 v[206:207], v[142:143], v[242:243]
		v_pk_add_f32 v[208:209], v[160:161], v[244:245]
		v_pk_add_f32 v[210:211], v[162:163], v[246:247]
		v_pk_add_f32 v[212:213], v[164:165], v[248:249]
		v_pk_add_f32 v[214:215], v[166:167], v[250:251]
		v_pk_add_f32 v[216:217], v[168:169], v[252:253]
		v_pk_add_f32 v[186:187], v[186:187], v[188:189]
		v_pk_add_f32 v[188:189], v[190:191], v[192:193]
		v_pk_add_f32 v[190:191], v[194:195], v[196:197]
		v_pk_add_f32 v[192:193], v[198:199], v[200:201]
		v_pk_add_f32 v[194:195], v[202:203], v[204:205]
		v_pk_add_f32 v[196:197], v[206:207], v[208:209]
		v_pk_add_f32 v[198:199], v[210:211], v[212:213]
		v_pk_add_f32 v[200:201], v[214:215], v[216:217]
		v_pk_add_f32 v[186:187], v[186:187], v[188:189]
		v_pk_add_f32 v[188:189], v[190:191], v[192:193]
		v_pk_add_f32 v[190:191], v[194:195], v[196:197]
		v_pk_add_f32 v[192:193], v[198:199], v[200:201]
		v_pk_add_f32 v[186:187], v[186:187], v[188:189]
		v_pk_add_f32 v[188:189], v[190:191], v[192:193]
		v_pk_add_f32 v[190:191], v[186:187], v[188:189]
		v_add_f32_e32 v4, v190, v191
		v_accvgpr_read_b32 v6, a72
		ds_bpermute_b32 v186, v6, v4
		v_accvgpr_read_b32 v6, a73
		ds_bpermute_b32 v188, v6, v4
		v_pk_add_f32 v[190:191], v[96:97], v[98:99]
		v_pk_add_f32 v[192:193], v[100:101], v[102:103]
		v_pk_add_f32 v[194:195], v[104:105], v[106:107]
		v_pk_add_f32 v[196:197], v[108:109], v[110:111]
		v_pk_add_f32 v[198:199], v[112:113], v[114:115]
		v_pk_add_f32 v[200:201], v[116:117], v[118:119]
		v_pk_add_f32 v[202:203], v[120:121], v[122:123]
		v_pk_add_f32 v[204:205], v[124:125], v[126:127]
		v_pk_add_f32 v[206:207], v[144:145], v[146:147]
		v_pk_add_f32 v[208:209], v[148:149], v[150:151]
		v_pk_add_f32 v[210:211], v[152:153], v[154:155]
		v_pk_add_f32 v[212:213], v[156:157], v[158:159]
		v_pk_add_f32 v[214:215], v[170:171], v[172:173]
		v_pk_add_f32 v[216:217], v[174:175], v[176:177]
		v_pk_add_f32 v[218:219], v[178:179], v[180:181]
		v_accvgpr_write_b32 a74, v218
		v_accvgpr_write_b32 a75, v219
		v_pk_add_f32 v[218:219], v[182:183], v[184:185]
		v_pk_add_f32 v[190:191], v[190:191], v[192:193]
		v_pk_add_f32 v[192:193], v[194:195], v[196:197]
		v_pk_add_f32 v[194:195], v[198:199], v[200:201]
		v_pk_add_f32 v[196:197], v[202:203], v[204:205]
		v_pk_add_f32 v[198:199], v[206:207], v[208:209]
		v_pk_add_f32 v[200:201], v[210:211], v[212:213]
		v_pk_add_f32 v[202:203], v[214:215], v[216:217]
		v_accvgpr_read_b32 v204, a74
		v_accvgpr_read_b32 v205, a75
		v_pk_add_f32 v[204:205], v[204:205], v[218:219]
		v_pk_add_f32 v[190:191], v[190:191], v[192:193]
		v_pk_add_f32 v[192:193], v[194:195], v[196:197]
		v_pk_add_f32 v[194:195], v[198:199], v[200:201]
		v_pk_add_f32 v[196:197], v[202:203], v[204:205]
		v_pk_add_f32 v[190:191], v[190:191], v[192:193]
		v_pk_add_f32 v[192:193], v[194:195], v[196:197]
		v_pk_add_f32 v[194:195], v[190:191], v[192:193]
		v_mov_b32_e32 v189, v195
		v_mov_b32_e32 v187, v194
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[190:191], v[186:187], v[188:189]
		v_mov_b32_e32 v186, v191
		v_mov_b32_e32 v187, v191
		v_cvt_pk_bf16_f32 v192, v220, v222
		v_cvt_pk_bf16_f32 v193, v26, v224
		v_permlane32_swap_b32_e32 v186, v187
		v_add_f32_e32 v189, v186, v187
		v_mov_b32_e32 v25, v7
		v_pk_add_f32 v[6:7], v[24:25], v[28:29] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v24, v6
		v_exp_f32_e32 v25, v7
		v_cvt_pk_bf16_f32 v194, v30, v226
		v_mov_b32_e32 v188, v190
		v_mov_b64_e32 v[6:7], v[12:13]
		v_pk_fma_f32 v[12:13], v[6:7], v[24:25], v[188:189]
		v_cvt_pk_bf16_f32 v195, v128, v228
		v_cvt_pk_bf16_f32 v188, v130, v230
		v_cvt_pk_bf16_f32 v189, v132, v232
		v_cvt_pk_bf16_f32 v190, v134, v234
		v_cvt_pk_bf16_f32 v191, v136, v236
		v_cvt_pk_bf16_f32 v196, v138, v238
		v_cvt_pk_bf16_f32 v197, v140, v240
		v_cvt_pk_bf16_f32 v198, v142, v242
		v_cvt_pk_bf16_f32 v199, v160, v244
		v_cvt_pk_bf16_f32 v200, v162, v246
		v_cvt_pk_bf16_f32 v201, v164, v248
		v_cvt_pk_bf16_f32 v202, v166, v250
		v_cvt_pk_bf16_f32 v203, v168, v252
		v_cvt_pk_bf16_f32 v204, v221, v223
		v_pk_mul_f32 v[32:33], v[32:33], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[34:35], v[34:35], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[36:37], v[36:37], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[38:39], v[38:39], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[40:41], v[40:41], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[42:43], v[42:43], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[44:45], v[44:45], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[46:47], v[46:47], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[48:49], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[50:51], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[52:53], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[54:55], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[56:57], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[58:59], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[60:61], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[62:63], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[64:65], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[66:67], v[66:67], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[68:69], v[68:69], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[70:71], v[70:71], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[72:73], v[72:73], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[74:75], v[74:75], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[76:77], v[76:77], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[78:79], v[78:79], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[80:81], v[80:81], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[82:83], v[82:83], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[84:85], v[84:85], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[86:87], v[86:87], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[88:89], v[88:89], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[90:91], v[90:91], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[92:93], v[92:93], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[94:95], v[94:95], v[24:25] op_sel:[0,1]
		v_cvt_pk_bf16_f32 v205, v27, v225
		v_cvt_pk_bf16_f32 v206, v31, v227
		v_cvt_pk_bf16_f32 v207, v129, v229
		v_cvt_pk_bf16_f32 v24, v131, v231
		v_cvt_pk_bf16_f32 v25, v133, v233
		v_cvt_pk_bf16_f32 v26, v135, v235
		v_cvt_pk_bf16_f32 v27, v137, v237
		v_cvt_pk_bf16_f32 v128, v139, v239
		v_cvt_pk_bf16_f32 v129, v141, v241
		v_cvt_pk_bf16_f32 v130, v143, v243
		v_cvt_pk_bf16_f32 v131, v161, v245
		v_cvt_pk_bf16_f32 v132, v163, v247
		v_cvt_pk_bf16_f32 v133, v165, v249
		v_cvt_pk_bf16_f32 v134, v167, v251
		v_cvt_pk_bf16_f32 v135, v169, v253
		v_cvt_pk_bf16_f32 v136, v96, v98
		v_cvt_pk_bf16_f32 v137, v100, v102
		v_cvt_pk_bf16_f32 v138, v104, v106
		v_cvt_pk_bf16_f32 v139, v108, v110
		v_cvt_pk_bf16_f32 v140, v112, v114
		v_cvt_pk_bf16_f32 v141, v116, v118
		v_cvt_pk_bf16_f32 v142, v120, v122
		v_cvt_pk_bf16_f32 v143, v124, v126
		v_cvt_pk_bf16_f32 v160, v144, v146
		v_cvt_pk_bf16_f32 v161, v148, v150
		v_cvt_pk_bf16_f32 v162, v152, v154
		v_cvt_pk_bf16_f32 v163, v156, v158
		v_cvt_pk_bf16_f32 v164, v170, v172
		v_cvt_pk_bf16_f32 v165, v174, v176
		v_cvt_pk_bf16_f32 v166, v178, v180
		v_cvt_pk_bf16_f32 v167, v182, v184
		v_cvt_pk_bf16_f32 v208, v97, v99
		v_cvt_pk_bf16_f32 v209, v101, v103
		v_cvt_pk_bf16_f32 v210, v105, v107
		v_cvt_pk_bf16_f32 v211, v109, v111
		v_cvt_pk_bf16_f32 v96, v113, v115
		v_cvt_pk_bf16_f32 v97, v117, v119
		v_cvt_pk_bf16_f32 v98, v121, v123
		v_cvt_pk_bf16_f32 v99, v125, v127
		v_cvt_pk_bf16_f32 v100, v145, v147
		v_cvt_pk_bf16_f32 v101, v149, v151
		v_cvt_pk_bf16_f32 v102, v153, v155
		v_cvt_pk_bf16_f32 v103, v157, v159
		v_cvt_pk_bf16_f32 v104, v171, v173
		v_cvt_pk_bf16_f32 v105, v175, v177
		v_cvt_pk_bf16_f32 v106, v179, v181
		v_cvt_pk_bf16_f32 v107, v183, v185
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[32:47], a[104:107], v[192:195], v[32:47]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[48:63], a[136:139], v[192:195], v[48:63]
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_mfma_f32_32x32x16_bf16 v[32:47], a[108:111], v[188:191], v[32:47]
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_mfma_f32_32x32x16_bf16 v[48:63], a[140:143], v[188:191], v[48:63]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[32:47], a[112:115], v[196:199], v[32:47]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[48:63], a[144:147], v[196:199], v[48:63]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[32:47], a[116:119], v[200:203], v[32:47]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[48:63], a[148:151], v[200:203], v[48:63]
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_mfma_f32_32x32x16_bf16 v[80:95], a[136:139], v[136:139], v[80:95]
		v_permlane32_swap_b32_e32 v160, v162
		v_permlane32_swap_b32_e32 v161, v163
		v_mfma_f32_32x32x16_bf16 v[64:79], a[104:107], v[136:139], v[64:79]
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		v_mfma_f32_32x32x16_bf16 v[80:95], a[140:143], v[140:143], v[80:95]
		v_permlane32_swap_b32_e32 v208, v210
		v_permlane32_swap_b32_e32 v209, v211
		v_mfma_f32_32x32x16_bf16 v[64:79], a[108:111], v[140:143], v[64:79]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[160:163], v[80:95]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[64:79], a[112:115], v[160:163], v[64:79]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[80:95], a[148:151], v[164:167], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[116:119], v[164:167], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[120:123], v[204:207], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[152:155], v[204:207], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], v[208:211], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[120:123], v[208:211], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[124:127], v[24:27], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[156:159], v[24:27], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[124:127], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[128:131], v[128:131], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[160:163], v[128:131], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[160:163], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[128:131], v[100:103], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[132:135], v[132:135], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[164:167], v[132:135], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[164:167], v[104:107], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[132:135], v[104:107], v[64:79]
		v_mov_b32_e32 v4, v28
		v_mov_b32_e32 v7, v29
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_1
.L_attn_fwd_persistent.loop_exit_1:
		s_mul_i32 s21, s21, 0x80
		v_accvgpr_read_b32 v1, a15
		v_accvgpr_read_b32 v3, a6
		s_nop 0
		v_readfirstlane_b32 s23, v3
		s_nop 1
		v_add_u32_e32 v1, s23, v1
		v_add_u32_e32 v1, s1, v1
		v_accvgpr_read_b32 v3, a16
		v_accvgpr_read_b32 v6, a6
		s_nop 0
		v_readfirstlane_b32 s23, v6
		s_nop 1
		v_add_u32_e32 v3, s23, v3
		v_add_u32_e32 v3, s1, v3
		v_xor_b32_e32 v6, 1, v5
		v_accvgpr_write_b32 a15, v6
		v_xor_b32_e32 v6, 2, v5
		v_accvgpr_write_b32 a16, v6
		v_xor_b32_e32 v6, 3, v5
		v_accvgpr_write_b32 a68, v6
		v_xor_b32_e32 v6, 8, v5
		v_accvgpr_write_b32 a70, v6
		v_xor_b32_e32 v6, 9, v5
		v_accvgpr_write_b32 a74, v6
		v_xor_b32_e32 v6, 10, v5
		v_accvgpr_write_b32 a75, v6
		v_xor_b32_e32 v6, 11, v5
		v_accvgpr_write_b32 a76, v6
		v_xor_b32_e32 v6, 16, v5
		v_accvgpr_write_b32 a77, v6
		v_xor_b32_e32 v6, 17, v5
		v_accvgpr_write_b32 a78, v6
		v_xor_b32_e32 v6, 18, v5
		v_accvgpr_write_b32 a79, v6
		v_xor_b32_e32 v6, 19, v5
		v_accvgpr_write_b32 a80, v6
		v_xor_b32_e32 v6, 24, v5
		v_accvgpr_write_b32 a81, v6
		v_xor_b32_e32 v6, 25, v5
		v_accvgpr_write_b32 a82, v6
		v_xor_b32_e32 v6, 26, v5
		v_accvgpr_write_b32 a83, v6
		v_xor_b32_e32 v6, 27, v5
		v_accvgpr_write_b32 a84, v6
		v_xor_b32_e32 v6, 32, v5
		v_accvgpr_write_b32 a85, v6
		v_xor_b32_e32 v6, 33, v5
		v_accvgpr_write_b32 a86, v6
		v_xor_b32_e32 v6, 34, v5
		v_accvgpr_write_b32 a87, v6
		v_xor_b32_e32 v6, 35, v5
		v_accvgpr_write_b32 a88, v6
		v_xor_b32_e32 v6, 40, v5
		v_accvgpr_write_b32 a89, v6
		v_xor_b32_e32 v6, 41, v5
		v_accvgpr_write_b32 a90, v6
		v_xor_b32_e32 v6, 42, v5
		v_accvgpr_write_b32 a91, v6
		v_xor_b32_e32 v6, 43, v5
		v_accvgpr_write_b32 a92, v6
		v_xor_b32_e32 v6, 48, v5
		v_accvgpr_write_b32 a93, v6
		v_xor_b32_e32 v6, 49, v5
		v_accvgpr_write_b32 a94, v6
		v_xor_b32_e32 v6, 50, v5
		v_accvgpr_write_b32 a95, v6
		v_xor_b32_e32 v6, 51, v5
		v_accvgpr_write_b32 a96, v6
		v_xor_b32_e32 v6, 56, v5
		v_accvgpr_write_b32 a97, v6
		v_xor_b32_e32 v6, 57, v5
		v_accvgpr_write_b32 a98, v6
		v_xor_b32_e32 v6, 58, v5
		v_accvgpr_write_b32 a99, v6
		v_xor_b32_e32 v6, 59, v5
		v_accvgpr_write_b32 a100, v6
		v_xor_b32_e32 v6, 64, v5
		v_accvgpr_write_b32 a101, v6
		v_xor_b32_e32 v6, 0x41, v5
		v_accvgpr_write_b32 a102, v6
		v_xor_b32_e32 v6, 0x42, v5
		v_accvgpr_write_b32 a103, v6
		v_xor_b32_e32 v6, 0x43, v5
		v_accvgpr_write_b32 a104, v6
		v_xor_b32_e32 v6, 0x48, v5
		v_accvgpr_write_b32 a105, v6
		v_xor_b32_e32 v6, 0x49, v5
		v_accvgpr_write_b32 a106, v6
		v_xor_b32_e32 v6, 0x4a, v5
		v_accvgpr_write_b32 a107, v6
		v_xor_b32_e32 v6, 0x4b, v5
		v_accvgpr_write_b32 a108, v6
		v_xor_b32_e32 v6, 0x50, v5
		v_accvgpr_write_b32 a109, v6
		v_xor_b32_e32 v6, 0x51, v5
		v_accvgpr_write_b32 a110, v6
		v_xor_b32_e32 v6, 0x52, v5
		v_accvgpr_write_b32 a111, v6
		v_xor_b32_e32 v6, 0x53, v5
		v_accvgpr_write_b32 a112, v6
		v_xor_b32_e32 v6, 0x58, v5
		v_accvgpr_write_b32 a113, v6
		v_xor_b32_e32 v6, 0x59, v5
		v_accvgpr_write_b32 a114, v6
		v_xor_b32_e32 v6, 0x5a, v5
		v_accvgpr_write_b32 a115, v6
		v_xor_b32_e32 v6, 0x5b, v5
		v_accvgpr_write_b32 a116, v6
		v_xor_b32_e32 v6, 0x60, v5
		v_accvgpr_write_b32 a117, v6
		v_xor_b32_e32 v6, 0x61, v5
		v_accvgpr_write_b32 a118, v6
		v_xor_b32_e32 v6, 0x62, v5
		v_accvgpr_write_b32 a119, v6
		v_xor_b32_e32 v6, 0x63, v5
		v_accvgpr_write_b32 a120, v6
		v_xor_b32_e32 v6, 0x68, v5
		v_accvgpr_write_b32 a121, v6
		v_xor_b32_e32 v6, 0x69, v5
		v_accvgpr_write_b32 a122, v6
		v_xor_b32_e32 v6, 0x6a, v5
		v_accvgpr_write_b32 a123, v6
		v_xor_b32_e32 v6, 0x6b, v5
		v_accvgpr_write_b32 a124, v6
		v_xor_b32_e32 v6, 0x70, v5
		v_accvgpr_write_b32 a125, v6
		v_xor_b32_e32 v6, 0x71, v5
		v_accvgpr_write_b32 a126, v6
		v_xor_b32_e32 v6, 0x72, v5
		v_accvgpr_write_b32 a127, v6
		v_xor_b32_e32 v6, 0x73, v5
		v_accvgpr_write_b32 a128, v6
		v_xor_b32_e32 v6, 0x78, v5
		v_accvgpr_write_b32 a129, v6
		v_xor_b32_e32 v6, 0x79, v5
		v_accvgpr_write_b32 a130, v6
		v_xor_b32_e32 v6, 0x7a, v5
		v_accvgpr_write_b32 a131, v6
		v_xor_b32_e32 v6, 0x7b, v5
		v_accvgpr_write_b32 a132, v6
		v_accvgpr_read_b32 v6, a53
		v_accvgpr_read_b32 v8, a65
		v_accvgpr_read_b32 v9, a66
		v_add3_u32 v6, v6, v8, v9
		v_accvgpr_write_b32 a53, v6
		v_accvgpr_read_b32 v6, a67
		v_accvgpr_read_b32 v8, a69
		v_lshl_add_u32 v6, v6, 3, v8
		v_accvgpr_read_b32 v8, a18
		v_lshl_add_u32 v6, v8, 5, v6
		v_accvgpr_read_b32 v8, a59
		v_accvgpr_read_b32 v9, a71
		v_add3_u32 v6, v6, v9, v8
		v_accvgpr_write_b32 a18, v6
		v_mov_b32_e32 v6, 0xff800000
		s_cmp_lt_i32 s41, s21
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_2
.L_attn_fwd_persistent.loop_head_2:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s1, s41, 0x80
		s_cmp_lt_i32 s41, 0
		s_cselect_b32 s23, s22, 0
		s_add_i32 s23, s41, s23
		s_ashr_i32 s23, s23, 7
		s_cmp_lt_i32 s23, 0
		s_cselect_b32 s33, s16, 0
		s_add_i32 s33, s23, s33
		s_ashr_i32 s33, s33, 1
		s_lshl_b32 s33, s33, 1
		s_xor_b32 s33, s33, -1
		s_add_i32 s33, s33, 1
		s_add_i32 s33, s23, s33
		s_add_i32 s23, s23, 1
		s_cmp_lt_i32 s23, 0
		s_cselect_b32 s35, s16, 0
		s_add_i32 s35, s23, s35
		s_ashr_i32 s35, s35, 1
		s_lshl_b32 s35, s35, 1
		s_xor_b32 s35, s35, -1
		s_add_i32 s35, s35, 1
		s_add_i32 s48, s23, s35
		s_mul_i32 s23, 0x4100, s33
		v_accvgpr_read_b32 v8, a53
		v_add_u32_e32 v8, s23, v8
		ds_read_b128 v[24:27], v8
		ds_read_b128 a[136:139], v8 offset:32
		ds_read_b128 a[140:143], v8 offset:64
		ds_read_b128 a[144:147], v8 offset:96
		ds_read_b128 a[148:151], v8 offset:256
		ds_read_b128 a[152:155], v8 offset:288
		ds_read_b128 a[156:159], v8 offset:320
		ds_read_b128 a[160:163], v8 offset:352
		ds_read_b128 a[164:167], v8 offset:128
		ds_read_b128 a[168:171], v8 offset:160
		ds_read_b128 a[172:175], v8 offset:192
		ds_read_b128 a[176:179], v8 offset:224
		ds_read_b128 v[28:31], v8 offset:384
		ds_read_b128 a[180:183], v8 offset:416
		ds_read_b128 a[184:187], v8 offset:448
		ds_read_b128 a[188:191], v8 offset:480
		s_mul_i32 s23, 0x4400, s33
		v_accvgpr_read_b32 v8, a18
		v_add_u32_e32 v8, s23, v8
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
		s_cmp_lt_i32 s1, s18
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_2
		v_accvgpr_read_b32 v8, a19
		v_add_u32_e32 v8, s1, v8
		v_cmp_lt_i32_e64 s[50:51], v8, s20
		v_accvgpr_read_b32 v8, a52
		v_add_u32_e32 v8, s1, v8
		v_cmp_lt_i32_e64 s[52:53], v8, s20
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s23, s15, s41
		s_lshl_b32 s23, s23, 1
		s_add_i32 s33, s42, s23
		v_add_u32_e32 v8, s33, v15
		v_add3_u32 v8, v8, v19, v20
		v_add3_u32 v8, v8, v21, v11
		v_cndmask_b32_e64 v8, v22, v8, s[50:51]
		s_mov_b32 s50, 1
		s_mov_b32 s51, 0
		s_mov_b32 s35, 0
		s_mul_i32 s54, s50, s34
		s_mul_hi_u32 s55, s50, s34
		s_mul_i32 s33, s50, s35
		s_add_i32 s55, s55, s33
		s_mul_i32 s33, s51, s34
		s_add_i32 s55, s55, s33
		s_lshr_b64 s[50:51], s[54:55], 6
		s_mov_b32 s54, 0x410
		s_mov_b32 s55, 0
		s_mul_i32 s56, s54, s50
		s_mul_hi_u32 s57, s54, s50
		s_mul_i32 s33, s54, s51
		s_add_i32 s57, s57, s33
		s_mul_i32 s33, s55, s50
		s_add_i32 s57, s57, s33
		s_cmp_lt_i32 s48, 0
		s_cselect_b32 s49, -1, 0
		s_mov_b32 s54, 0x4100
		s_mov_b32 s55, 0
		s_mul_i32 s58, s54, s48
		s_mul_hi_u32 s59, s54, s48
		s_mul_i32 s33, s54, s49
		s_add_i32 s59, s59, s33
		s_mul_i32 s33, s55, s48
		s_add_i32 s59, s59, s33
		s_add_u32 s54, s56, s58
		s_addc_u32 s55, s57, s59
		s_add_u32 s60, s54, 0
		s_addc_u32 s61, s55, 0
		s_mov_b32 m0, s60
		v_accvgpr_read_b32 v9, a58
		v_add_u32_e32 v9, s1, v9
		buffer_load_dwordx4 v8, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v9, s20
		s_add_i32 s33, s43, s23
		v_add_u32_e32 v8, s33, v15
		v_add3_u32 v8, v8, v19, v20
		v_add3_u32 v8, v8, v21, v11
		v_cndmask_b32_e64 v8, v22, v8, s[54:55]
		s_add_u32 s54, s56, 0x1040
		s_addc_u32 s55, s57, 0
		s_add_u32 s54, s54, s58
		s_addc_u32 s55, s55, s59
		s_add_u32 s60, s54, 0
		s_addc_u32 s61, s55, 0
		s_mov_b32 m0, s60
		v_accvgpr_read_b32 v9, a60
		v_add_u32_e32 v9, s1, v9
		buffer_load_dwordx4 v8, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v9, s20
		s_add_i32 s33, s44, s23
		v_add_u32_e32 v8, s33, v15
		v_add3_u32 v8, v8, v19, v20
		v_add3_u32 v8, v8, v21, v11
		v_cndmask_b32_e64 v8, v22, v8, s[54:55]
		s_add_u32 s54, s56, 0x2080
		s_addc_u32 s55, s57, 0
		s_add_u32 s54, s54, s58
		s_addc_u32 s55, s55, s59
		s_add_u32 s60, s54, 0
		s_addc_u32 s61, s55, 0
		s_mov_b32 m0, s60
		v_accvgpr_read_b32 v9, a61
		v_add_u32_e32 v9, s1, v9
		buffer_load_dwordx4 v8, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v9, s20
		s_add_i32 s23, s36, s23
		v_add_u32_e32 v8, s23, v15
		v_add3_u32 v8, v8, v19, v20
		v_add3_u32 v8, v8, v21, v11
		v_cndmask_b32_e64 v8, v22, v8, s[54:55]
		s_add_u32 s54, s56, 0x30c0
		s_addc_u32 s55, s57, 0
		s_add_u32 s54, s54, s58
		s_addc_u32 s55, s55, s59
		s_add_u32 s56, s54, 0
		s_addc_u32 s57, s55, 0
		s_mov_b32 m0, s56
		v_accvgpr_read_b32 v9, a62
		v_add_u32_e32 v9, s1, v9
		buffer_load_dwordx4 v8, s[24:27], 0 offen lds
		s_mul_i32 s23, s17, s41
		s_lshl_b32 s23, s23, 1
		s_add_i32 s33, s45, s23
		v_add_u32_e32 v8, s33, v2
		v_add3_u32 v8, v8, v14, v17
		v_add3_u32 v8, v8, v18, v11
		v_cndmask_b32_e64 v8, v22, v8, s[52:53]
		s_mov_b32 s52, 0x440
		s_mov_b32 s53, 0
		s_mul_i32 s54, s52, s50
		s_mul_hi_u32 s55, s52, s50
		s_mul_i32 s33, s52, s51
		s_add_i32 s55, s55, s33
		s_mul_i32 s33, s53, s50
		s_add_i32 s55, s55, s33
		s_add_u32 s50, s54, 0x81f0
		s_addc_u32 s51, s55, 0
		s_mov_b32 s52, 0x4400
		s_mov_b32 s53, 0
		s_mul_i32 s56, s52, s48
		s_mul_hi_u32 s57, s52, s48
		s_mul_i32 s33, s52, s49
		s_add_i32 s57, s57, s33
		s_mul_i32 s33, s53, s48
		s_add_i32 s57, s57, s33
		s_add_u32 s48, s50, s56
		s_addc_u32 s49, s51, s57
		s_add_u32 s50, s48, 0
		s_addc_u32 s51, s49, 0
		s_mov_b32 m0, s50
		v_accvgpr_read_b32 v10, a63
		v_add_u32_e32 v10, s1, v10
		buffer_load_dwordx4 v8, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[48:49], v9, s20
		s_add_i32 s33, s46, s23
		v_add_u32_e32 v8, s33, v2
		v_add3_u32 v8, v8, v14, v17
		v_add3_u32 v8, v8, v18, v11
		v_cndmask_b32_e64 v8, v22, v8, s[48:49]
		s_add_u32 s48, s54, 0x92f0
		s_addc_u32 s49, s55, 0
		s_add_u32 s48, s48, s56
		s_addc_u32 s49, s49, s57
		s_add_u32 s50, s48, 0
		s_addc_u32 s51, s49, 0
		s_mov_b32 m0, s50
		v_accvgpr_read_b32 v9, a64
		v_add_u32_e32 v9, s1, v9
		buffer_load_dwordx4 v8, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[48:49], v10, s20
		s_add_i32 s33, s47, s23
		v_add_u32_e32 v8, s33, v2
		v_add3_u32 v8, v8, v14, v17
		v_add3_u32 v8, v8, v18, v11
		s_add_u32 s50, s54, 0xa3f0
		s_addc_u32 s51, s55, 0
		s_add_u32 s50, s50, s56
		s_addc_u32 s51, s51, s57
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		v_cndmask_b32_e64 v8, v22, v8, s[48:49]
		buffer_load_dwordx4 v8, s[28:31], 0 offen lds
		s_add_i32 s23, s32, s23
		v_add_u32_e32 v8, s23, v2
		v_add3_u32 v8, v8, v14, v17
		v_cmp_lt_i32_e64 vcc, v9, s20
		v_add3_u32 v8, v8, v18, v11
		s_add_u32 s48, s54, 0xb4f0
		s_addc_u32 s49, s55, 0
		v_cndmask_b32_e32 v8, v22, v8, vcc
		s_add_u32 s48, s48, s56
		s_addc_u32 s49, s49, s57
		s_add_u32 s50, s48, 0
		s_addc_u32 s51, s49, 0
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v8, s[28:31], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_2
.L_attn_fwd_persistent.if_else_2:
.L_attn_fwd_persistent.if_end_2:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[96:111], v[24:27], a[20:23], 0
		s_cmp_lt_i32 s1, s21
		v_mfma_f32_32x32x16_bf16 v[112:127], a[148:151], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[128:143], a[164:167], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[28:31], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[176:191], v[24:27], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[192:207], a[148:151], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[208:223], a[164:167], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[96:111], a[136:139], a[24:27], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[152:155], a[24:27], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[168:171], a[24:27], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[180:183], a[24:27], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[40:43], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[136:139], a[40:43], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[152:155], a[40:43], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[168:171], a[40:43], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[140:143], a[28:31], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[156:159], a[28:31], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[172:175], a[28:31], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[184:187], a[28:31], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[184:187], a[44:47], v[160:175]
		v_add_u32_e32 v8, s41, v5
		v_mfma_f32_32x32x16_bf16 v[176:191], a[140:143], a[44:47], v[176:191]
		v_accvgpr_read_b32 v9, a15
		v_add_u32_e32 v9, s41, v9
		v_mfma_f32_32x32x16_bf16 v[192:207], a[156:159], a[44:47], v[192:207]
		v_accvgpr_read_b32 v10, a16
		v_add_u32_e32 v10, s41, v10
		v_mfma_f32_32x32x16_bf16 v[208:223], a[172:175], a[44:47], v[208:223]
		v_accvgpr_read_b32 v16, a68
		v_add_u32_e32 v16, s41, v16
		v_mfma_f32_32x32x16_bf16 v[96:111], a[144:147], a[32:35], v[96:111]
		v_cmp_ge_i32_e64 vcc, v1, v16
		v_mfma_f32_32x32x16_bf16 v[112:127], a[160:163], a[32:35], v[112:127]
		v_accvgpr_read_b32 v23, a75
		v_add_u32_e32 v23, s41, v23
		v_mfma_f32_32x32x16_bf16 v[128:143], a[176:179], a[32:35], v[128:143]
		v_accvgpr_read_b32 v24, a76
		v_add_u32_e32 v24, s41, v24
		v_mfma_f32_32x32x16_bf16 v[144:159], a[188:191], a[32:35], v[144:159]
		v_accvgpr_read_b32 v25, a79
		v_add_u32_e32 v25, s41, v25
		v_mfma_f32_32x32x16_bf16 v[160:175], a[188:191], a[48:51], v[160:175]
		v_accvgpr_read_b32 v26, a80
		v_add_u32_e32 v26, s41, v26
		v_mfma_f32_32x32x16_bf16 v[176:191], a[144:147], a[48:51], v[176:191]
		v_accvgpr_read_b32 v27, a83
		v_add_u32_e32 v27, s41, v27
		v_mfma_f32_32x32x16_bf16 v[192:207], a[160:163], a[48:51], v[192:207]
		v_cndmask_b32_e32 v29, v6, v99, vcc
		v_mfma_f32_32x32x16_bf16 v[208:223], a[176:179], a[48:51], v[208:223]
		v_accvgpr_read_b32 v28, a84
		v_add_u32_e32 v30, s41, v28
		v_accvgpr_read_b32 v28, a87
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a59, v28
		v_accvgpr_read_b32 v28, a88
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a65, v28
		v_accvgpr_read_b32 v28, a91
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a66, v28
		v_accvgpr_read_b32 v28, a92
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a67, v28
		v_accvgpr_read_b32 v28, a95
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a69, v28
		v_accvgpr_read_b32 v28, a96
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a71, v28
		v_accvgpr_read_b32 v28, a99
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a133, v28
		v_accvgpr_read_b32 v28, a100
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a134, v28
		v_accvgpr_read_b32 v28, a103
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a135, v28
		v_accvgpr_read_b32 v28, a104
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a136, v28
		v_accvgpr_read_b32 v28, a107
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a137, v28
		v_accvgpr_read_b32 v28, a108
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a138, v28
		v_accvgpr_read_b32 v28, a111
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a139, v28
		v_accvgpr_read_b32 v28, a112
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a140, v28
		v_accvgpr_read_b32 v28, a115
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a141, v28
		v_accvgpr_read_b32 v28, a116
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a142, v28
		v_accvgpr_read_b32 v28, a119
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a143, v28
		v_accvgpr_read_b32 v28, a120
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a144, v28
		v_accvgpr_read_b32 v28, a123
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a145, v28
		v_accvgpr_read_b32 v28, a124
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a146, v28
		v_accvgpr_read_b32 v28, a127
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a147, v28
		v_accvgpr_read_b32 v28, a128
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a148, v28
		v_accvgpr_read_b32 v28, a131
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a149, v28
		v_accvgpr_read_b32 v28, a132
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a150, v28
		v_cmp_ge_i32_e64 s[48:49], v1, v8
		v_cmp_ge_i32_e64 s[50:51], v1, v9
		v_cmp_ge_i32_e64 s[52:53], v1, v10
		v_accvgpr_read_b32 v28, a70
		v_add_u32_e32 v31, s41, v28
		v_accvgpr_read_b32 v28, a74
		v_add_u32_e32 v99, s41, v28
		v_cmp_ge_i32_e64 s[54:55], v1, v31
		v_cmp_ge_i32_e64 s[56:57], v1, v99
		v_cmp_ge_i32_e64 s[58:59], v1, v23
		v_cmp_ge_i32_e64 vcc, v1, v24
		v_accvgpr_read_b32 v28, a77
		v_add_u32_e32 v224, s41, v28
		v_accvgpr_read_b32 v28, a78
		v_add_u32_e32 v225, s41, v28
		v_cndmask_b32_e32 v227, v6, v103, vcc
		v_cmp_ge_i32_e64 s[60:61], v1, v224
		v_cmp_ge_i32_e64 s[62:63], v1, v225
		v_cmp_ge_i32_e64 s[64:65], v1, v25
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v28, a81
		v_add_u32_e32 v103, s41, v28
		v_accvgpr_read_b32 v28, a82
		v_add_u32_e32 v228, s41, v28
		v_cndmask_b32_e32 v231, v6, v107, vcc
		v_cmp_ge_i32_e64 s[66:67], v1, v103
		v_cmp_ge_i32_e64 s[68:69], v1, v228
		v_cmp_ge_i32_e64 s[70:71], v1, v27
		v_cmp_ge_i32_e64 vcc, v1, v30
		v_accvgpr_read_b32 v28, a85
		v_add_u32_e32 v107, s41, v28
		v_accvgpr_read_b32 v28, a86
		v_add_u32_e32 v229, s41, v28
		v_cndmask_b32_e32 v233, v6, v111, vcc
		v_cmp_ge_i32_e64 s[72:73], v1, v107
		v_cmp_ge_i32_e64 s[74:75], v1, v229
		v_accvgpr_read_b32 v28, a59
		v_cmp_ge_i32_e64 s[76:77], v1, v28
		v_accvgpr_read_b32 v28, a65
		v_cmp_ge_i32_e64 vcc, v1, v28
		v_accvgpr_read_b32 v28, a89
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a151, v28
		v_accvgpr_read_b32 v28, a90
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a152, v28
		v_cndmask_b32_e32 v235, v6, v115, vcc
		v_accvgpr_read_b32 v28, a151
		v_cmp_ge_i32_e64 s[78:79], v1, v28
		v_accvgpr_read_b32 v28, a152
		v_cmp_ge_i32_e64 s[80:81], v1, v28
		v_accvgpr_read_b32 v28, a66
		v_cmp_ge_i32_e64 s[82:83], v1, v28
		v_accvgpr_read_b32 v28, a67
		v_cmp_ge_i32_e64 vcc, v1, v28
		v_accvgpr_read_b32 v28, a93
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a153, v28
		v_accvgpr_read_b32 v28, a94
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a154, v28
		v_cndmask_b32_e32 v237, v6, v119, vcc
		v_accvgpr_read_b32 v28, a153
		v_cmp_ge_i32_e64 s[84:85], v1, v28
		v_accvgpr_read_b32 v28, a154
		v_cmp_ge_i32_e64 s[86:87], v1, v28
		v_accvgpr_read_b32 v28, a71
		v_cmp_ge_i32_e64 vcc, v1, v28
		v_accvgpr_read_b32 v28, a97
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a155, v28
		v_accvgpr_read_b32 v28, a98
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a156, v28
		v_cndmask_b32_e32 v239, v6, v123, vcc
		v_accvgpr_read_b32 v28, a134
		v_cmp_ge_i32_e64 vcc, v1, v28
		v_accvgpr_read_b32 v28, a101
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a157, v28
		v_accvgpr_read_b32 v28, a102
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a158, v28
		v_cndmask_b32_e32 v241, v6, v127, vcc
		v_accvgpr_read_b32 v28, a136
		v_cmp_ge_i32_e64 vcc, v1, v28
		v_accvgpr_read_b32 v28, a105
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a159, v28
		v_accvgpr_read_b32 v28, a106
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a160, v28
		v_cndmask_b32_e32 v243, v6, v131, vcc
		v_accvgpr_read_b32 v28, a138
		v_cmp_ge_i32_e64 vcc, v1, v28
		v_accvgpr_read_b32 v28, a109
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a161, v28
		v_accvgpr_read_b32 v28, a110
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a162, v28
		v_cndmask_b32_e32 v245, v6, v135, vcc
		v_accvgpr_read_b32 v28, a140
		v_cmp_ge_i32_e64 vcc, v1, v28
		v_accvgpr_read_b32 v28, a113
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a163, v28
		v_accvgpr_read_b32 v28, a114
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a164, v28
		v_cndmask_b32_e32 v247, v6, v139, vcc
		v_accvgpr_read_b32 v28, a142
		v_cmp_ge_i32_e64 vcc, v1, v28
		v_accvgpr_read_b32 v28, a69
		v_cmp_ge_i32_e64 s[88:89], v1, v28
		v_cndmask_b32_e64 v248, v6, v96, s[48:49]
		v_accvgpr_read_b32 v28, a155
		v_cmp_ge_i32_e64 s[48:49], v1, v28
		s_nop 1
		v_mov_b32_e32 v250, s48
		v_mov_b32_e32 v251, s49
		v_accvgpr_write_b32 a166, v250
		v_accvgpr_write_b32 a167, v251
		v_accvgpr_read_b32 v28, a156
		v_cmp_ge_i32_e64 s[48:49], v1, v28
		s_nop 1
		v_mov_b32_e32 v250, s48
		v_mov_b32_e32 v251, s49
		v_accvgpr_write_b32 a168, v250
		v_accvgpr_write_b32 a169, v251
		v_accvgpr_read_b32 v28, a133
		v_cmp_ge_i32_e64 s[48:49], v1, v28
		s_nop 1
		v_mov_b32_e32 v250, s48
		v_mov_b32_e32 v251, s49
		v_accvgpr_write_b32 a170, v250
		v_accvgpr_write_b32 a171, v251
		v_accvgpr_read_b32 v28, a157
		v_cmp_ge_i32_e64 s[48:49], v1, v28
		s_nop 1
		v_mov_b32_e32 v250, s48
		v_mov_b32_e32 v251, s49
		v_accvgpr_write_b32 a172, v250
		v_accvgpr_write_b32 a173, v251
		v_accvgpr_read_b32 v28, a158
		v_cmp_ge_i32_e64 s[48:49], v1, v28
		s_nop 1
		v_mov_b32_e32 v250, s48
		v_mov_b32_e32 v251, s49
		v_accvgpr_write_b32 a174, v250
		v_accvgpr_write_b32 a175, v251
		v_accvgpr_read_b32 v28, a135
		v_cmp_ge_i32_e64 s[48:49], v1, v28
		s_nop 1
		v_mov_b32_e32 v250, s48
		v_mov_b32_e32 v251, s49
		v_accvgpr_write_b32 a176, v250
		v_accvgpr_write_b32 a177, v251
		v_accvgpr_read_b32 v28, a159
		v_cmp_ge_i32_e64 s[48:49], v1, v28
		s_nop 1
		v_mov_b32_e32 v250, s48
		v_mov_b32_e32 v251, s49
		v_accvgpr_write_b32 a178, v250
		v_accvgpr_write_b32 a179, v251
		v_accvgpr_read_b32 v28, a160
		v_cmp_ge_i32_e64 s[48:49], v1, v28
		s_nop 1
		v_mov_b32_e32 v250, s48
		v_mov_b32_e32 v251, s49
		v_accvgpr_write_b32 a180, v250
		v_accvgpr_write_b32 a181, v251
		v_accvgpr_read_b32 v28, a137
		v_cmp_ge_i32_e64 s[48:49], v1, v28
		s_nop 1
		v_mov_b32_e32 v250, s48
		v_mov_b32_e32 v251, s49
		v_accvgpr_write_b32 a182, v250
		v_accvgpr_write_b32 a183, v251
		v_accvgpr_read_b32 v28, a161
		v_cmp_ge_i32_e64 s[48:49], v1, v28
		s_nop 1
		v_mov_b32_e32 v250, s48
		v_mov_b32_e32 v251, s49
		v_accvgpr_write_b32 a184, v250
		v_accvgpr_write_b32 a185, v251
		v_accvgpr_read_b32 v28, a162
		v_cmp_ge_i32_e64 s[48:49], v1, v28
		s_nop 1
		v_mov_b32_e32 v250, s48
		v_mov_b32_e32 v251, s49
		v_accvgpr_write_b32 a186, v250
		v_accvgpr_write_b32 a187, v251
		v_accvgpr_read_b32 v28, a139
		v_cmp_ge_i32_e64 s[48:49], v1, v28
		s_nop 1
		v_mov_b32_e32 v250, s48
		v_mov_b32_e32 v251, s49
		v_accvgpr_write_b32 a188, v250
		v_accvgpr_write_b32 a189, v251
		v_accvgpr_read_b32 v28, a163
		v_cmp_ge_i32_e64 s[48:49], v1, v28
		s_nop 1
		v_mov_b32_e32 v250, s48
		v_mov_b32_e32 v251, s49
		v_accvgpr_write_b32 a190, v250
		v_accvgpr_write_b32 a191, v251
		v_accvgpr_read_b32 v28, a164
		v_cmp_ge_i32_e64 s[48:49], v1, v28
		v_accvgpr_read_b32 v28, a141
		v_cmp_ge_i32_e64 s[90:91], v1, v28
		v_cndmask_b32_e32 v251, v6, v143, vcc
		v_cndmask_b32_e64 v253, v6, v141, s[48:49]
		v_cndmask_b32_e64 v250, v6, v142, s[90:91]
		v_accvgpr_read_b32 v28, a117
		v_add_u32_e32 v96, s41, v28
		v_accvgpr_read_b32 v28, a118
		v_add_u32_e32 v111, s41, v28
		v_cmp_ge_i32_e64 s[48:49], v1, v96
		v_cmp_ge_i32_e64 s[90:91], v1, v111
		v_accvgpr_read_b32 v28, a143
		v_cmp_ge_i32_e64 s[92:93], v1, v28
		v_cndmask_b32_e64 v142, v6, v144, s[48:49]
		v_cndmask_b32_e64 v143, v6, v145, s[90:91]
		v_cndmask_b32_e64 v144, v6, v146, s[92:93]
		v_accvgpr_read_b32 v28, a144
		v_cmp_ge_i32_e64 vcc, v1, v28
		v_accvgpr_read_b32 v28, a121
		v_add_u32_e32 v115, s41, v28
		v_accvgpr_read_b32 v28, a122
		v_add_u32_e32 v119, s41, v28
		v_cndmask_b32_e32 v145, v6, v147, vcc
		v_cmp_ge_i32_e64 s[48:49], v1, v115
		v_cmp_ge_i32_e64 s[90:91], v1, v119
		v_accvgpr_read_b32 v28, a145
		v_cmp_ge_i32_e64 s[92:93], v1, v28
		v_cndmask_b32_e64 v146, v6, v148, s[48:49]
		v_cndmask_b32_e64 v147, v6, v149, s[90:91]
		v_cndmask_b32_e64 v148, v6, v150, s[92:93]
		v_accvgpr_read_b32 v28, a146
		v_cmp_ge_i32_e64 vcc, v1, v28
		v_accvgpr_read_b32 v28, a125
		v_add_u32_e32 v123, s41, v28
		v_accvgpr_read_b32 v28, a126
		v_add_u32_e32 v127, s41, v28
		v_cndmask_b32_e32 v149, v6, v151, vcc
		v_cmp_ge_i32_e64 s[48:49], v1, v123
		v_cmp_ge_i32_e64 s[90:91], v1, v127
		v_accvgpr_read_b32 v28, a147
		v_cmp_ge_i32_e64 s[92:93], v1, v28
		v_cndmask_b32_e64 v150, v6, v152, s[48:49]
		v_cndmask_b32_e64 v151, v6, v153, s[90:91]
		v_cndmask_b32_e64 v152, v6, v154, s[92:93]
		v_accvgpr_read_b32 v28, a148
		v_cmp_ge_i32_e64 vcc, v1, v28
		v_accvgpr_read_b32 v28, a129
		v_add_u32_e32 v131, s41, v28
		v_accvgpr_read_b32 v28, a130
		v_add_u32_e32 v135, s41, v28
		v_cndmask_b32_e32 v153, v6, v155, vcc
		v_cmp_ge_i32_e64 s[48:49], v1, v131
		v_cmp_ge_i32_e64 s[90:91], v1, v135
		v_accvgpr_read_b32 v28, a149
		v_cmp_ge_i32_e64 s[92:93], v1, v28
		v_cndmask_b32_e64 v154, v6, v156, s[48:49]
		v_cndmask_b32_e64 v155, v6, v157, s[90:91]
		v_cndmask_b32_e64 v156, v6, v158, s[92:93]
		v_cndmask_b32_e64 v249, v6, v97, s[50:51]
		v_accvgpr_read_b32 v28, a150
		v_cmp_ge_i32_e64 vcc, v1, v28
		v_max3_f32 v97, v142, v143, v144
		v_max3_f32 v139, v146, v147, v148
		v_cndmask_b32_e32 v157, v6, v159, vcc
		v_cmp_ge_i32_e64 s[48:49], v3, v8
		v_cmp_ge_i32_e64 s[50:51], v3, v9
		v_cmp_ge_i32_e64 s[90:91], v3, v10
		v_max3_f32 v8, v150, v151, v152
		v_accvgpr_write_b32 a165, v8
		v_max3_f32 v8, v154, v155, v156
		v_cndmask_b32_e64 v158, v6, v178, s[90:91]
		v_cmp_ge_i32_e64 vcc, v3, v16
		v_cndmask_b32_e64 v28, v6, v98, s[52:53]
		v_mov_b32_e32 v9, 0xff800000
		v_cndmask_b32_e64 v254, v9, v100, s[54:55]
		v_cndmask_b32_e32 v159, v9, v179, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v31
		v_cmp_ge_i32_e64 s[54:55], v3, v99
		v_cmp_ge_i32_e64 s[90:91], v3, v23
		v_cndmask_b32_e64 v98, v9, v180, s[52:53]
		v_cndmask_b32_e64 v99, v9, v181, s[54:55]
		v_cndmask_b32_e64 v178, v9, v182, s[90:91]
		v_cmp_ge_i32_e64 vcc, v3, v24
		v_cndmask_b32_e64 v255, v9, v101, s[56:57]
		v_cndmask_b32_e64 v226, v9, v102, s[58:59]
		v_cndmask_b32_e64 v100, v9, v104, s[60:61]
		v_cndmask_b32_e32 v179, v9, v183, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v224
		v_cmp_ge_i32_e64 s[54:55], v3, v225
		v_cmp_ge_i32_e64 s[56:57], v3, v25
		v_cndmask_b32_e64 v24, v9, v184, s[52:53]
		v_cndmask_b32_e64 v25, v9, v185, s[54:55]
		v_cndmask_b32_e64 v180, v9, v186, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v26
		v_cndmask_b32_e64 v101, v9, v105, s[62:63]
		v_max3_f32 v10, v248, v249, v28
		v_cndmask_b32_e32 v181, v9, v187, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v103
		v_cmp_ge_i32_e64 s[54:55], v3, v228
		v_cmp_ge_i32_e64 s[56:57], v3, v27
		v_cndmask_b32_e64 v26, v9, v188, s[52:53]
		v_cndmask_b32_e64 v27, v9, v189, s[54:55]
		v_cndmask_b32_e64 v102, v9, v190, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v30
		v_cndmask_b32_e64 v230, v9, v106, s[64:65]
		v_cndmask_b32_e64 v30, v9, v108, s[66:67]
		v_cndmask_b32_e32 v103, v9, v191, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v107
		v_cmp_ge_i32_e64 s[54:55], v3, v229
		v_accvgpr_read_b32 v16, a59
		v_cmp_ge_i32_e64 s[56:57], v3, v16
		v_cndmask_b32_e64 v104, v9, v192, s[52:53]
		v_cndmask_b32_e64 v105, v9, v193, s[54:55]
		v_cndmask_b32_e64 v106, v9, v194, s[56:57]
		v_accvgpr_read_b32 v16, a65
		v_cmp_ge_i32_e64 vcc, v3, v16
		v_cndmask_b32_e64 v31, v9, v109, s[68:69]
		v_cndmask_b32_e64 v232, v9, v110, s[70:71]
		v_cndmask_b32_e64 v108, v9, v112, s[72:73]
		v_cndmask_b32_e32 v107, v9, v195, vcc
		v_accvgpr_read_b32 v16, a151
		v_cmp_ge_i32_e64 s[52:53], v3, v16
		v_accvgpr_read_b32 v16, a152
		v_cmp_ge_i32_e64 s[54:55], v3, v16
		v_accvgpr_read_b32 v16, a66
		v_cmp_ge_i32_e64 s[56:57], v3, v16
		v_cndmask_b32_e64 v182, v9, v196, s[52:53]
		v_cndmask_b32_e64 v183, v9, v197, s[54:55]
		v_cndmask_b32_e64 v184, v9, v198, s[56:57]
		v_accvgpr_read_b32 v16, a67
		v_cmp_ge_i32_e64 vcc, v3, v16
		v_cndmask_b32_e64 v109, v9, v113, s[74:75]
		v_max3_f32 v16, v254, v255, v226
		v_cndmask_b32_e32 v185, v9, v199, vcc
		v_accvgpr_read_b32 v23, a153
		v_cmp_ge_i32_e64 s[52:53], v3, v23
		v_accvgpr_read_b32 v23, a154
		v_cmp_ge_i32_e64 s[54:55], v3, v23
		v_accvgpr_read_b32 v23, a69
		v_cmp_ge_i32_e64 s[56:57], v3, v23
		v_cndmask_b32_e64 v112, v9, v200, s[52:53]
		v_cndmask_b32_e64 v113, v9, v201, s[54:55]
		v_cndmask_b32_e64 v186, v9, v202, s[56:57]
		v_accvgpr_read_b32 v23, a71
		v_cmp_ge_i32_e64 vcc, v3, v23
		v_cndmask_b32_e64 v234, v9, v114, s[76:77]
		v_cndmask_b32_e64 v188, v9, v116, s[78:79]
		v_cndmask_b32_e32 v187, v9, v203, vcc
		v_accvgpr_read_b32 v23, a134
		v_cmp_ge_i32_e64 vcc, v3, v23
		v_accvgpr_read_b32 v23, a155
		v_cmp_ge_i32_e64 s[52:53], v3, v23
		v_accvgpr_read_b32 v23, a156
		v_cmp_ge_i32_e64 s[54:55], v3, v23
		v_accvgpr_read_b32 v23, a133
		v_cmp_ge_i32_e64 s[56:57], v3, v23
		v_cndmask_b32_e64 v190, v9, v204, s[52:53]
		v_cndmask_b32_e64 v191, v9, v205, s[54:55]
		v_cndmask_b32_e64 v192, v9, v206, s[56:57]
		v_cndmask_b32_e64 v189, v9, v117, s[80:81]
		v_cndmask_b32_e64 v236, v9, v118, s[82:83]
		v_cndmask_b32_e32 v193, v9, v207, vcc
		v_accvgpr_read_b32 v23, a157
		v_cmp_ge_i32_e64 s[52:53], v3, v23
		v_accvgpr_read_b32 v23, a158
		v_cmp_ge_i32_e64 s[54:55], v3, v23
		v_accvgpr_read_b32 v23, a136
		v_cmp_ge_i32_e64 vcc, v3, v23
		v_accvgpr_read_b32 v23, a135
		v_cmp_ge_i32_e64 s[56:57], v3, v23
		v_cndmask_b32_e64 v116, v9, v208, s[52:53]
		v_cndmask_b32_e64 v117, v9, v209, s[54:55]
		v_cndmask_b32_e64 v194, v9, v210, s[56:57]
		v_cndmask_b32_e64 v196, v9, v120, s[84:85]
		v_cndmask_b32_e64 v197, v9, v121, s[86:87]
		v_cndmask_b32_e32 v195, v9, v211, vcc
		v_accvgpr_read_b32 v23, a159
		v_cmp_ge_i32_e64 s[52:53], v3, v23
		v_accvgpr_read_b32 v23, a160
		v_cmp_ge_i32_e64 s[54:55], v3, v23
		v_accvgpr_read_b32 v23, a137
		v_cmp_ge_i32_e64 s[56:57], v3, v23
		v_cndmask_b32_e64 v120, v9, v212, s[52:53]
		v_cndmask_b32_e64 v121, v9, v213, s[54:55]
		v_cndmask_b32_e64 v198, v9, v214, s[56:57]
		v_accvgpr_read_b32 v23, a138
		v_cmp_ge_i32_e64 vcc, v3, v23
		v_cndmask_b32_e64 v238, v9, v122, s[88:89]
		v_accvgpr_read_b32 v23, a166
		s_nop 0
		v_readfirstlane_b32 s52, v23
		v_accvgpr_read_b32 v23, a167
		s_nop 0
		v_readfirstlane_b32 s53, v23
		s_nop 1
		v_cndmask_b32_e64 v200, v9, v124, s[52:53]
		v_cndmask_b32_e32 v199, v9, v215, vcc
		v_accvgpr_read_b32 v23, a161
		v_cmp_ge_i32_e64 s[52:53], v3, v23
		v_accvgpr_read_b32 v23, a162
		v_cmp_ge_i32_e64 s[54:55], v3, v23
		v_accvgpr_read_b32 v23, a139
		v_cmp_ge_i32_e64 s[56:57], v3, v23
		v_cndmask_b32_e64 v202, v9, v216, s[52:53]
		v_cndmask_b32_e64 v203, v9, v217, s[54:55]
		v_cndmask_b32_e64 v204, v9, v218, s[56:57]
		v_accvgpr_read_b32 v23, a140
		v_cmp_ge_i32_e64 vcc, v3, v23
		v_accvgpr_read_b32 v23, a168
		s_nop 0
		v_readfirstlane_b32 s52, v23
		v_accvgpr_read_b32 v23, a169
		s_nop 0
		v_readfirstlane_b32 s53, v23
		s_nop 1
		v_cndmask_b32_e64 v201, v9, v125, s[52:53]
		v_accvgpr_read_b32 v23, a170
		s_nop 0
		v_readfirstlane_b32 s52, v23
		v_accvgpr_read_b32 v23, a171
		s_nop 0
		v_readfirstlane_b32 s53, v23
		s_nop 1
		v_cndmask_b32_e64 v240, v9, v126, s[52:53]
		v_cndmask_b32_e32 v205, v9, v219, vcc
		v_accvgpr_read_b32 v23, a163
		v_cmp_ge_i32_e64 s[52:53], v3, v23
		v_accvgpr_read_b32 v23, a164
		v_cmp_ge_i32_e64 s[54:55], v3, v23
		v_accvgpr_read_b32 v23, a141
		v_cmp_ge_i32_e64 s[56:57], v3, v23
		v_cndmask_b32_e64 v124, v9, v220, s[52:53]
		v_cndmask_b32_e64 v125, v9, v221, s[54:55]
		v_cndmask_b32_e64 v206, v9, v222, s[56:57]
		v_accvgpr_read_b32 v23, a142
		v_cmp_ge_i32_e64 vcc, v3, v23
		v_accvgpr_read_b32 v23, a172
		s_nop 0
		v_readfirstlane_b32 s52, v23
		v_accvgpr_read_b32 v23, a173
		s_nop 0
		v_readfirstlane_b32 s53, v23
		s_nop 1
		v_cndmask_b32_e64 v208, v9, v128, s[52:53]
		v_accvgpr_read_b32 v23, a174
		s_nop 0
		v_readfirstlane_b32 s52, v23
		v_accvgpr_read_b32 v23, a175
		s_nop 0
		v_readfirstlane_b32 s53, v23
		s_nop 1
		v_cndmask_b32_e64 v209, v9, v129, s[52:53]
		v_cndmask_b32_e32 v207, v9, v223, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v96
		v_cmp_ge_i32_e64 s[54:55], v3, v111
		v_accvgpr_read_b32 v23, a143
		v_cmp_ge_i32_e64 s[56:57], v3, v23
		v_cndmask_b32_e64 v110, v9, v160, s[52:53]
		v_cndmask_b32_e64 v111, v9, v161, s[54:55]
		v_cndmask_b32_e64 v128, v9, v162, s[56:57]
		v_accvgpr_read_b32 v23, a144
		v_cmp_ge_i32_e64 vcc, v3, v23
		v_accvgpr_read_b32 v23, a176
		s_nop 0
		v_readfirstlane_b32 s52, v23
		v_accvgpr_read_b32 v23, a177
		s_nop 0
		v_readfirstlane_b32 s53, v23
		s_nop 1
		v_cndmask_b32_e64 v242, v9, v130, s[52:53]
		v_accvgpr_read_b32 v23, a178
		s_nop 0
		v_readfirstlane_b32 s52, v23
		v_accvgpr_read_b32 v23, a179
		s_nop 0
		v_readfirstlane_b32 s53, v23
		s_nop 1
		v_cndmask_b32_e64 v160, v9, v132, s[52:53]
		v_cndmask_b32_e32 v129, v9, v163, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v115
		v_cmp_ge_i32_e64 s[54:55], v3, v119
		v_accvgpr_read_b32 v23, a145
		v_cmp_ge_i32_e64 s[56:57], v3, v23
		v_cndmask_b32_e64 v114, v9, v164, s[52:53]
		v_cndmask_b32_e64 v115, v9, v165, s[54:55]
		v_cndmask_b32_e64 v118, v9, v166, s[56:57]
		v_accvgpr_read_b32 v23, a146
		v_cmp_ge_i32_e64 vcc, v3, v23
		v_accvgpr_read_b32 v23, a180
		s_nop 0
		v_readfirstlane_b32 s52, v23
		v_accvgpr_read_b32 v23, a181
		s_nop 0
		v_readfirstlane_b32 s53, v23
		s_nop 1
		v_cndmask_b32_e64 v161, v9, v133, s[52:53]
		v_accvgpr_read_b32 v23, a182
		s_nop 0
		v_readfirstlane_b32 s52, v23
		v_accvgpr_read_b32 v23, a183
		s_nop 0
		v_readfirstlane_b32 s53, v23
		s_nop 1
		v_cndmask_b32_e64 v244, v9, v134, s[52:53]
		v_cndmask_b32_e32 v119, v9, v167, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v123
		v_cmp_ge_i32_e64 s[54:55], v3, v127
		v_accvgpr_read_b32 v23, a147
		v_cmp_ge_i32_e64 s[56:57], v3, v23
		v_cndmask_b32_e64 v122, v9, v168, s[52:53]
		v_cndmask_b32_e64 v123, v9, v169, s[54:55]
		v_cndmask_b32_e64 v126, v9, v170, s[56:57]
		v_accvgpr_read_b32 v23, a148
		v_cmp_ge_i32_e64 vcc, v3, v23
		v_accvgpr_read_b32 v23, a184
		s_nop 0
		v_readfirstlane_b32 s52, v23
		v_accvgpr_read_b32 v23, a185
		s_nop 0
		v_readfirstlane_b32 s53, v23
		s_nop 1
		v_cndmask_b32_e64 v132, v9, v136, s[52:53]
		v_accvgpr_read_b32 v23, a186
		s_nop 0
		v_readfirstlane_b32 s52, v23
		v_accvgpr_read_b32 v23, a187
		s_nop 0
		v_readfirstlane_b32 s53, v23
		s_nop 1
		v_cndmask_b32_e64 v133, v9, v137, s[52:53]
		v_cndmask_b32_e32 v127, v9, v171, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v131
		v_cmp_ge_i32_e64 s[54:55], v3, v135
		v_accvgpr_read_b32 v23, a149
		v_cmp_ge_i32_e64 s[56:57], v3, v23
		v_cndmask_b32_e64 v130, v9, v172, s[52:53]
		v_cndmask_b32_e64 v131, v9, v173, s[54:55]
		v_cndmask_b32_e64 v134, v9, v174, s[56:57]
		v_accvgpr_read_b32 v23, a150
		v_cmp_ge_i32_e64 vcc, v3, v23
		v_accvgpr_read_b32 v23, a188
		s_nop 0
		v_readfirstlane_b32 s52, v23
		v_accvgpr_read_b32 v23, a189
		s_nop 0
		v_readfirstlane_b32 s53, v23
		s_nop 1
		v_cndmask_b32_e64 v246, v9, v138, s[52:53]
		v_accvgpr_read_b32 v23, a190
		s_nop 0
		v_readfirstlane_b32 s52, v23
		v_accvgpr_read_b32 v23, a191
		s_nop 0
		v_readfirstlane_b32 s53, v23
		s_nop 1
		v_cndmask_b32_e64 v252, v9, v140, s[52:53]
		v_cndmask_b32_e32 v135, v9, v175, vcc
		v_max3_f32 v23, v100, v101, v230
		v_max3_f32 v96, v30, v31, v232
		v_max3_f32 v136, v108, v109, v234
		v_max3_f32 v137, v188, v189, v236
		v_max3_f32 v138, v196, v197, v238
		v_max3_f32 v140, v200, v201, v240
		v_max3_f32 v141, v208, v209, v242
		v_max3_f32 v162, v160, v161, v244
		v_max3_f32 v163, v132, v133, v246
		v_max3_f32 v164, v252, v253, v250
		v_max3_f32 v10, v10, v29, v16
		v_max3_f32 v16, v23, v231, v96
		v_max3_f32 v23, v136, v235, v137
		v_max3_f32 v96, v138, v239, v140
		v_max3_f32 v136, v141, v243, v162
		v_max3_f32 v137, v163, v247, v164
		v_max3_f32 v97, v97, v145, v139
		v_accvgpr_read_b32 v138, a165
		v_max3_f32 v8, v138, v153, v8
		v_max3_f32 v10, v10, v227, v16
		v_max3_f32 v16, v23, v237, v96
		v_max3_f32 v23, v136, v245, v137
		v_max3_f32 v8, v97, v149, v8
		v_max3_f32 v10, v10, v233, v16
		v_max3_f32 v8, v23, v251, v8
		v_max3_f32 v8, v10, v241, v8
		v_max_f32_e32 v96, v8, v157
		v_mov_b32_e32 v97, v96
		v_cndmask_b32_e64 v136, v9, v176, s[48:49]
		v_cndmask_b32_e64 v137, v9, v177, s[50:51]
		v_permlane32_swap_b32_e32 v96, v97
		v_max3_f32 v8, v136, v137, v158
		v_max3_f32 v9, v98, v99, v178
		v_max3_f32 v10, v24, v25, v180
		v_max3_f32 v16, v26, v27, v102
		v_max3_f32 v23, v104, v105, v106
		v_max3_f32 v138, v182, v183, v184
		v_max3_f32 v139, v112, v113, v186
		v_max3_f32 v140, v190, v191, v192
		v_max3_f32 v141, v116, v117, v194
		v_max3_f32 v162, v120, v121, v198
		v_max3_f32 v163, v202, v203, v204
		v_max3_f32 v164, v124, v125, v206
		v_max3_f32 v165, v110, v111, v128
		v_max3_f32 v166, v114, v115, v118
		v_max3_f32 v167, v122, v123, v126
		v_max3_f32 v168, v130, v131, v134
		v_max3_f32 v8, v8, v159, v9
		v_max3_f32 v9, v10, v181, v16
		v_max3_f32 v10, v23, v107, v138
		v_max3_f32 v16, v139, v187, v140
		v_max3_f32 v23, v141, v195, v162
		v_max3_f32 v138, v163, v205, v164
		v_max3_f32 v139, v165, v129, v166
		v_max3_f32 v140, v167, v127, v168
		v_max3_f32 v8, v8, v179, v9
		v_max3_f32 v9, v10, v185, v16
		v_max3_f32 v10, v23, v199, v138
		v_max3_f32 v16, v139, v119, v140
		v_max3_f32 v8, v8, v103, v9
		v_max3_f32 v9, v10, v207, v16
		v_max3_f32 v8, v8, v193, v9
		v_max_f32_e32 v138, v8, v135
		v_mov_b32_e32 v139, v138
		v_max_f32_e32 v8, v96, v97
		v_mov_b32_e32 v96, v4
		v_permlane32_swap_b32_e32 v138, v139
		v_max_f32_e32 v9, v138, v139
		v_mov_b32_e32 v138, 0x3e38aa3b
		v_mov_b32_e32 v139, 0x3e38aa3b
		v_pk_mul_f32 v[140:141], v[8:9], v[138:139]
		v_max_f32_e32 v8, v4, v140
		v_max_f32_e32 v9, v7, v141
		v_pk_fma_f32 v[140:141], v[248:249], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[28:29], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[254:255], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[226:227], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[100:101], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[230:231], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[30:31], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[232:233], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[108:109], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[234:235], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[188:189], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[236:237], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[196:197], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[238:239], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[200:201], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[240:241], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[208:209], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[242:243], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[160:161], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[244:245], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[132:133], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[246:247], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[252:253], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[218:219], v[250:251], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[220:221], v[142:143], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[144:145], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[146:147], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[148:149], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[150:151], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[154:155], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[156:157], v[138:139], v[8:9] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[136:137], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[158:159], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[98:99], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[178:179], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[24:25], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[180:181], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[26:27], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[102:103], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[182:183], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[184:185], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[112:113], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[186:187], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[190:191], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[192:193], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[116:117], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[194:195], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[120:121], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[198:199], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[202:203], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[204:205], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[124:125], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[206:207], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[110:111], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[128:129], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[114:115], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[118:119], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[122:123], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[126:127], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[130:131], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[134:135], v[138:139], v[8:9] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v134, v140
		v_exp_f32_e32 v138, v141
		v_exp_f32_e32 v140, v162
		v_exp_f32_e32 v222, v163
		v_exp_f32_e32 v162, v28
		v_exp_f32_e32 v224, v29
		v_exp_f32_e32 v28, v164
		v_exp_f32_e32 v226, v165
		v_exp_f32_e32 v164, v166
		v_exp_f32_e32 v228, v167
		v_exp_f32_e32 v166, v100
		v_exp_f32_e32 v230, v101
		v_exp_f32_e32 v100, v168
		v_exp_f32_e32 v232, v169
		v_exp_f32_e32 v168, v30
		v_exp_f32_e32 v234, v31
		v_exp_f32_e32 v30, v170
		v_exp_f32_e32 v236, v171
		v_exp_f32_e32 v170, v108
		v_exp_f32_e32 v238, v109
		v_exp_f32_e32 v108, v172
		v_exp_f32_e32 v240, v173
		v_exp_f32_e32 v172, v174
		v_exp_f32_e32 v242, v175
		v_exp_f32_e32 v174, v176
		v_exp_f32_e32 v244, v177
		v_exp_f32_e32 v176, v188
		v_exp_f32_e32 v246, v189
		v_exp_f32_e32 v188, v196
		v_exp_f32_e32 v248, v197
		v_exp_f32_e32 v196, v200
		v_exp_f32_e32 v250, v201
		v_exp_f32_e32 v135, v210
		v_exp_f32_e32 v139, v211
		v_exp_f32_e32 v141, v208
		v_exp_f32_e32 v223, v209
		v_exp_f32_e32 v163, v212
		v_exp_f32_e32 v225, v213
		v_exp_f32_e32 v29, v160
		v_exp_f32_e32 v227, v161
		v_exp_f32_e32 v165, v214
		v_exp_f32_e32 v229, v215
		v_exp_f32_e32 v167, v132
		v_exp_f32_e32 v231, v133
		v_exp_f32_e32 v101, v216
		v_exp_f32_e32 v233, v217
		v_exp_f32_e32 v169, v218
		v_exp_f32_e32 v235, v219
		v_exp_f32_e32 v31, v220
		v_exp_f32_e32 v237, v221
		v_exp_f32_e32 v171, v142
		v_exp_f32_e32 v239, v143
		v_exp_f32_e32 v109, v144
		v_exp_f32_e32 v241, v145
		v_exp_f32_e32 v173, v146
		v_exp_f32_e32 v243, v147
		v_exp_f32_e32 v175, v148
		v_exp_f32_e32 v245, v149
		v_exp_f32_e32 v177, v150
		v_exp_f32_e32 v247, v151
		v_exp_f32_e32 v189, v152
		v_exp_f32_e32 v249, v153
		v_exp_f32_e32 v197, v154
		v_exp_f32_e32 v251, v155
		v_exp_f32_e32 v132, v156
		v_exp_f32_e32 v142, v157
		v_exp_f32_e32 v144, v136
		v_exp_f32_e32 v146, v137
		v_exp_f32_e32 v136, v158
		v_exp_f32_e32 v148, v159
		v_exp_f32_e32 v150, v98
		v_exp_f32_e32 v152, v99
		v_exp_f32_e32 v98, v178
		v_exp_f32_e32 v154, v179
		v_exp_f32_e32 v156, v24
		v_exp_f32_e32 v158, v25
		v_exp_f32_e32 v24, v180
		v_exp_f32_e32 v160, v181
		v_exp_f32_e32 v178, v26
		v_exp_f32_e32 v180, v27
		v_exp_f32_e32 v26, v102
		v_exp_f32_e32 v200, v103
		v_exp_f32_e32 v102, v104
		v_exp_f32_e32 v208, v105
		v_exp_f32_e32 v104, v106
		v_exp_f32_e32 v210, v107
		v_exp_f32_e32 v106, v182
		v_exp_f32_e32 v212, v183
		v_exp_f32_e32 v182, v184
		v_exp_f32_e32 v214, v185
		v_exp_f32_e32 v184, v112
		v_exp_f32_e32 v216, v113
		v_exp_f32_e32 v112, v186
		v_exp_f32_e32 v218, v187
		v_exp_f32_e32 v186, v190
		v_exp_f32_e32 v220, v191
		v_exp_f32_e32 v133, v192
		v_exp_f32_e32 v143, v193
		v_exp_f32_e32 v145, v116
		v_exp_f32_e32 v147, v117
		v_exp_f32_e32 v137, v194
		v_exp_f32_e32 v149, v195
		v_exp_f32_e32 v151, v120
		v_exp_f32_e32 v153, v121
		v_exp_f32_e32 v99, v198
		v_exp_f32_e32 v155, v199
		v_exp_f32_e32 v157, v202
		v_exp_f32_e32 v159, v203
		v_exp_f32_e32 v25, v204
		v_exp_f32_e32 v161, v205
		v_exp_f32_e32 v179, v124
		v_exp_f32_e32 v181, v125
		v_exp_f32_e32 v27, v206
		v_exp_f32_e32 v201, v207
		v_exp_f32_e32 v103, v110
		v_exp_f32_e32 v209, v111
		v_exp_f32_e32 v105, v128
		v_exp_f32_e32 v211, v129
		v_exp_f32_e32 v107, v114
		v_exp_f32_e32 v213, v115
		v_exp_f32_e32 v183, v118
		v_exp_f32_e32 v215, v119
		v_exp_f32_e32 v185, v122
		v_exp_f32_e32 v217, v123
		v_exp_f32_e32 v113, v126
		v_exp_f32_e32 v219, v127
		v_exp_f32_e32 v187, v130
		v_exp_f32_e32 v221, v131
		v_pk_add_f32 v[110:111], v[134:135], v[138:139]
		v_pk_add_f32 v[114:115], v[140:141], v[222:223]
		v_pk_add_f32 v[116:117], v[162:163], v[224:225]
		v_pk_add_f32 v[118:119], v[28:29], v[226:227]
		v_pk_add_f32 v[120:121], v[164:165], v[228:229]
		v_pk_add_f32 v[122:123], v[166:167], v[230:231]
		v_pk_add_f32 v[124:125], v[100:101], v[232:233]
		v_pk_add_f32 v[126:127], v[168:169], v[234:235]
		v_pk_add_f32 v[128:129], v[30:31], v[236:237]
		v_pk_add_f32 v[130:131], v[170:171], v[238:239]
		v_pk_add_f32 v[190:191], v[108:109], v[240:241]
		v_pk_add_f32 v[192:193], v[172:173], v[242:243]
		v_pk_add_f32 v[194:195], v[174:175], v[244:245]
		v_pk_add_f32 v[198:199], v[176:177], v[246:247]
		v_pk_add_f32 v[202:203], v[188:189], v[248:249]
		v_pk_add_f32 v[204:205], v[196:197], v[250:251]
		v_pk_add_f32 v[110:111], v[110:111], v[114:115]
		v_pk_add_f32 v[114:115], v[116:117], v[118:119]
		v_pk_add_f32 v[116:117], v[120:121], v[122:123]
		v_pk_add_f32 v[118:119], v[124:125], v[126:127]
		v_pk_add_f32 v[120:121], v[128:129], v[130:131]
		v_pk_add_f32 v[122:123], v[190:191], v[192:193]
		v_pk_add_f32 v[124:125], v[194:195], v[198:199]
		v_pk_add_f32 v[126:127], v[202:203], v[204:205]
		v_pk_add_f32 v[110:111], v[110:111], v[114:115]
		v_pk_add_f32 v[114:115], v[116:117], v[118:119]
		v_pk_add_f32 v[116:117], v[120:121], v[122:123]
		v_pk_add_f32 v[118:119], v[124:125], v[126:127]
		v_pk_add_f32 v[110:111], v[110:111], v[114:115]
		v_pk_add_f32 v[114:115], v[116:117], v[118:119]
		v_pk_add_f32 v[116:117], v[110:111], v[114:115]
		v_add_f32_e32 v4, v116, v117
		v_accvgpr_read_b32 v10, a72
		ds_bpermute_b32 v110, v10, v4
		v_accvgpr_read_b32 v10, a73
		ds_bpermute_b32 v114, v10, v4
		v_pk_add_f32 v[116:117], v[132:133], v[142:143]
		v_pk_add_f32 v[118:119], v[144:145], v[146:147]
		v_pk_add_f32 v[120:121], v[136:137], v[148:149]
		v_pk_add_f32 v[122:123], v[150:151], v[152:153]
		v_pk_add_f32 v[124:125], v[98:99], v[154:155]
		v_pk_add_f32 v[126:127], v[156:157], v[158:159]
		v_pk_add_f32 v[128:129], v[24:25], v[160:161]
		v_pk_add_f32 v[130:131], v[178:179], v[180:181]
		v_pk_add_f32 v[190:191], v[26:27], v[200:201]
		v_pk_add_f32 v[192:193], v[102:103], v[208:209]
		v_pk_add_f32 v[194:195], v[104:105], v[210:211]
		v_pk_add_f32 v[198:199], v[106:107], v[212:213]
		v_pk_add_f32 v[202:203], v[182:183], v[214:215]
		v_pk_add_f32 v[204:205], v[184:185], v[216:217]
		v_pk_add_f32 v[206:207], v[112:113], v[218:219]
		v_pk_add_f32 v[252:253], v[186:187], v[220:221]
		v_pk_add_f32 v[116:117], v[116:117], v[118:119]
		v_pk_add_f32 v[118:119], v[120:121], v[122:123]
		v_pk_add_f32 v[120:121], v[124:125], v[126:127]
		v_pk_add_f32 v[122:123], v[128:129], v[130:131]
		v_pk_add_f32 v[124:125], v[190:191], v[192:193]
		v_pk_add_f32 v[126:127], v[194:195], v[198:199]
		v_pk_add_f32 v[128:129], v[202:203], v[204:205]
		v_pk_add_f32 v[130:131], v[206:207], v[252:253]
		v_pk_add_f32 v[116:117], v[116:117], v[118:119]
		v_pk_add_f32 v[118:119], v[120:121], v[122:123]
		v_pk_add_f32 v[120:121], v[124:125], v[126:127]
		v_pk_add_f32 v[122:123], v[128:129], v[130:131]
		v_pk_add_f32 v[116:117], v[116:117], v[118:119]
		v_pk_add_f32 v[118:119], v[120:121], v[122:123]
		v_pk_add_f32 v[120:121], v[116:117], v[118:119]
		v_mov_b32_e32 v115, v121
		v_mov_b32_e32 v111, v120
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[116:117], v[110:111], v[114:115]
		v_mov_b32_e32 v110, v117
		v_mov_b32_e32 v111, v117
		v_cvt_pk_bf16_f32 v120, v134, v138
		v_cvt_pk_bf16_f32 v121, v140, v222
		v_permlane32_swap_b32_e32 v110, v111
		v_add_f32_e32 v115, v110, v111
		v_mov_b32_e32 v97, v7
		v_pk_add_f32 v[110:111], v[96:97], v[8:9] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v96, v110
		v_exp_f32_e32 v97, v111
		v_cvt_pk_bf16_f32 v122, v162, v224
		v_pk_mul_f32 v[32:33], v[32:33], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[34:35], v[34:35], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[36:37], v[36:37], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[38:39], v[38:39], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[40:41], v[40:41], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[42:43], v[42:43], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[44:45], v[44:45], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[46:47], v[46:47], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[48:49], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[50:51], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[52:53], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[54:55], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[56:57], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[58:59], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[60:61], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[62:63], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[64:65], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[66:67], v[66:67], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[68:69], v[68:69], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[70:71], v[70:71], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[72:73], v[72:73], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[74:75], v[74:75], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[76:77], v[76:77], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[78:79], v[78:79], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[80:81], v[80:81], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[82:83], v[82:83], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[84:85], v[84:85], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[86:87], v[86:87], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[88:89], v[88:89], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[90:91], v[90:91], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[92:93], v[92:93], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[94:95], v[94:95], v[96:97] op_sel:[0,1]
		v_mov_b32_e32 v114, v116
		v_mov_b64_e32 v[110:111], v[12:13]
		v_pk_fma_f32 v[12:13], v[110:111], v[96:97], v[114:115]
		v_cvt_pk_bf16_f32 v123, v28, v226
		v_cvt_pk_bf16_f32 v116, v164, v228
		v_cvt_pk_bf16_f32 v117, v166, v230
		v_cvt_pk_bf16_f32 v118, v100, v232
		v_cvt_pk_bf16_f32 v119, v168, v234
		v_cvt_pk_bf16_f32 v124, v30, v236
		v_cvt_pk_bf16_f32 v125, v170, v238
		v_cvt_pk_bf16_f32 v126, v108, v240
		v_cvt_pk_bf16_f32 v127, v172, v242
		v_cvt_pk_bf16_f32 v128, v174, v244
		v_cvt_pk_bf16_f32 v129, v176, v246
		v_cvt_pk_bf16_f32 v130, v188, v248
		v_cvt_pk_bf16_f32 v131, v196, v250
		v_cvt_pk_bf16_f32 v192, v135, v139
		v_cvt_pk_bf16_f32 v193, v141, v223
		v_cvt_pk_bf16_f32 v194, v163, v225
		v_cvt_pk_bf16_f32 v195, v29, v227
		v_cvt_pk_bf16_f32 v204, v165, v229
		v_cvt_pk_bf16_f32 v205, v167, v231
		v_cvt_pk_bf16_f32 v206, v101, v233
		v_cvt_pk_bf16_f32 v207, v169, v235
		v_cvt_pk_bf16_f32 v164, v31, v237
		v_cvt_pk_bf16_f32 v165, v171, v239
		v_cvt_pk_bf16_f32 v166, v109, v241
		v_cvt_pk_bf16_f32 v167, v173, v243
		v_cvt_pk_bf16_f32 v28, v175, v245
		v_cvt_pk_bf16_f32 v29, v177, v247
		v_cvt_pk_bf16_f32 v30, v189, v249
		v_cvt_pk_bf16_f32 v31, v197, v251
		v_cvt_pk_bf16_f32 v108, v132, v142
		v_cvt_pk_bf16_f32 v109, v144, v146
		v_cvt_pk_bf16_f32 v110, v136, v148
		v_cvt_pk_bf16_f32 v111, v150, v152
		v_cvt_pk_bf16_f32 v168, v98, v154
		v_cvt_pk_bf16_f32 v169, v156, v158
		v_cvt_pk_bf16_f32 v170, v24, v160
		v_cvt_pk_bf16_f32 v171, v178, v180
		v_cvt_pk_bf16_f32 v172, v26, v200
		v_cvt_pk_bf16_f32 v173, v102, v208
		v_cvt_pk_bf16_f32 v174, v104, v210
		v_cvt_pk_bf16_f32 v175, v106, v212
		v_cvt_pk_bf16_f32 v188, v182, v214
		v_cvt_pk_bf16_f32 v189, v184, v216
		v_cvt_pk_bf16_f32 v190, v112, v218
		v_cvt_pk_bf16_f32 v191, v186, v220
		v_cvt_pk_bf16_f32 v196, v133, v143
		v_cvt_pk_bf16_f32 v197, v145, v147
		v_cvt_pk_bf16_f32 v198, v137, v149
		v_cvt_pk_bf16_f32 v199, v151, v153
		v_cvt_pk_bf16_f32 v132, v99, v155
		v_cvt_pk_bf16_f32 v133, v157, v159
		v_cvt_pk_bf16_f32 v134, v25, v161
		v_cvt_pk_bf16_f32 v135, v179, v181
		v_cvt_pk_bf16_f32 v96, v27, v201
		v_cvt_pk_bf16_f32 v97, v103, v209
		v_cvt_pk_bf16_f32 v98, v105, v211
		v_cvt_pk_bf16_f32 v99, v107, v213
		v_cvt_pk_bf16_f32 v24, v183, v215
		v_cvt_pk_bf16_f32 v25, v185, v217
		v_cvt_pk_bf16_f32 v26, v113, v219
		v_cvt_pk_bf16_f32 v27, v187, v221
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[120:123], v[32:47]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[120:123], v[48:63]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[116:119], v[32:47]
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[116:119], v[48:63]
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[124:127], v[32:47]
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[124:127], v[48:63]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[128:131], v[32:47]
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[128:131], v[48:63]
		v_permlane32_swap_b32_e32 v168, v170
		v_permlane32_swap_b32_e32 v169, v171
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[108:111], v[80:95]
		v_permlane32_swap_b32_e32 v172, v174
		v_permlane32_swap_b32_e32 v173, v175
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[108:111], v[64:79]
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[168:171], v[80:95]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[168:171], v[64:79]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[172:175], v[80:95]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[172:175], v[64:79]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[188:191], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[188:191], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[192:195], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[192:195], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[196:199], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[196:199], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[204:207], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[204:207], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[132:135], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[132:135], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[216:219], v[164:167], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[248:251], v[164:167], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[248:251], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[216:219], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[220:223], v[28:31], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[252:255], v[28:31], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[252:255], v[24:27], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[220:223], v[24:27], v[64:79]
		s_cselect_b32 s1, 1, 0
		s_add_i32 s23, s41, 0x80
		s_cmp_lg_u32 s1, 0
		s_mov_b32 s41, s23
		v_mov_b32_e32 v4, v8
		v_mov_b32_e32 v7, v9
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_2
.L_attn_fwd_persistent.loop_exit_2:
		s_mov_b32 s24, s8
		s_mov_b32 s25, s9
		s_mov_b32 s26, s38
		s_mov_b32 s27, s39
		v_rcp_f32_e32 v2, v12
		v_accvgpr_read_b32 v1, a13
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
		v_pk_mul_f32 v[14:15], v[40:41], v[2:3]
		v_pk_mul_f32 v[16:17], v[42:43], v[2:3]
		v_pk_mul_f32 v[18:19], v[44:45], v[2:3]
		v_pk_mul_f32 v[20:21], v[46:47], v[2:3]
		v_pk_mul_f32 v[22:23], v[48:49], v[2:3]
		v_pk_mul_f32 v[24:25], v[50:51], v[2:3]
		v_pk_mul_f32 v[26:27], v[52:53], v[2:3]
		v_pk_mul_f32 v[28:29], v[54:55], v[2:3]
		v_pk_mul_f32 v[30:31], v[56:57], v[2:3]
		v_pk_mul_f32 v[32:33], v[58:59], v[2:3]
		v_pk_mul_f32 v[34:35], v[60:61], v[2:3]
		v_pk_mul_f32 v[36:37], v[62:63], v[2:3]
		v_rcp_f32_e32 v2, v13
		v_cvt_pk_bf16_f32 v40, v4, v5
		v_mov_b32_e32 v3, v2
		v_pk_mul_f32 v[4:5], v[64:65], v[2:3]
		v_pk_mul_f32 v[12:13], v[66:67], v[2:3]
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
		v_cvt_pk_bf16_f32 v8, v14, v15
		v_cvt_pk_bf16_f32 v9, v16, v17
		v_cvt_pk_bf16_f32 v10, v18, v19
		v_cvt_pk_bf16_f32 v11, v20, v21
		v_cvt_pk_bf16_f32 v16, v22, v23
		v_cvt_pk_bf16_f32 v17, v24, v25
		v_cvt_pk_bf16_f32 v18, v26, v27
		v_cvt_pk_bf16_f32 v19, v28, v29
		v_cvt_pk_bf16_f32 v20, v30, v31
		v_cvt_pk_bf16_f32 v21, v32, v33
		v_cvt_pk_bf16_f32 v22, v34, v35
		v_cvt_pk_bf16_f32 v23, v36, v37
		v_cvt_pk_bf16_f32 v24, v4, v5
		v_cvt_pk_bf16_f32 v25, v12, v13
		v_cvt_pk_bf16_f32 v26, v38, v39
		v_cvt_pk_bf16_f32 v27, v44, v45
		v_cvt_pk_bf16_f32 v4, v46, v47
		v_cvt_pk_bf16_f32 v5, v48, v49
		v_cvt_pk_bf16_f32 v6, v50, v51
		v_cvt_pk_bf16_f32 v7, v52, v53
		v_cvt_pk_bf16_f32 v12, v54, v55
		v_cvt_pk_bf16_f32 v13, v56, v57
		v_cvt_pk_bf16_f32 v14, v58, v59
		v_cvt_pk_bf16_f32 v15, v60, v61
		v_cvt_pk_bf16_f32 v28, v62, v63
		v_cvt_pk_bf16_f32 v29, v64, v65
		v_cvt_pk_bf16_f32 v30, v66, v67
		v_cvt_pk_bf16_f32 v31, v68, v69
		v_permlane32_swap_b32_e32 v40, v42
		v_permlane32_swap_b32_e32 v41, v43
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v20, v22
		v_permlane32_swap_b32_e32 v21, v23
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_permlane32_swap_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v5, v7
		v_permlane32_swap_b32_e32 v12, v14
		v_permlane32_swap_b32_e32 v13, v15
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		s_lshl_b32 s1, s1, 9
		v_accvgpr_read_b32 v1, a2
		s_nop 0
		v_readfirstlane_b32 s18, v1
		v_accvgpr_read_b32 v1, a11
		s_nop 0
		v_readfirstlane_b32 s21, v1
		s_mul_i32 s18, s21, s18
		s_lshl_b32 s18, s18, 1
		s_add_i32 s21, s1, s18
		v_accvgpr_read_b32 v1, a3
		s_nop 0
		v_readfirstlane_b32 s22, v1
		v_accvgpr_read_b32 v1, a12
		s_nop 0
		v_readfirstlane_b32 s23, v1
		s_mul_i32 s22, s23, s22
		s_lshl_b32 s22, s22, 1
		s_add_i32 s21, s21, s22
		v_accvgpr_read_b32 v1, a14
		v_accvgpr_read_b32 v2, a4
		s_nop 0
		v_readfirstlane_b32 s23, v2
		s_nop 1
		v_mul_lo_u32 v1, s23, v1
		v_lshl_add_u32 v2, v1, 6, s21
		v_and_b32_e32 v3, 31, v0
		v_accvgpr_read_b32 v32, a4
		s_nop 0
		v_readfirstlane_b32 s21, v32
		s_nop 1
		v_mul_lo_u32 v3, s21, v3
		v_lshl_add_u32 v2, v3, 1, v2
		v_accvgpr_read_b32 v32, a17
		v_lshl_add_u32 v2, v32, 4, v2
		v_accvgpr_read_b32 v32, a54
		s_nop 0
		v_readfirstlane_b32 s28, v32
		v_accvgpr_read_b32 v32, a55
		s_nop 0
		v_readfirstlane_b32 s29, v32
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_8
		buffer_store_dwordx4 v[40:43], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_8:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_8
.L_attn_fwd_persistent.exec_endif_8:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 32
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v1, 6, s21
		v_lshl_add_u32 v2, v3, 1, v2
		v_accvgpr_read_b32 v32, a17
		v_lshl_add_u32 v2, v32, 4, v2
		v_accvgpr_read_b32 v32, a54
		s_nop 0
		v_readfirstlane_b32 s28, v32
		v_accvgpr_read_b32 v32, a55
		s_nop 0
		v_readfirstlane_b32 s29, v32
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_9
		buffer_store_dwordx4 v[8:11], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_9:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_9
.L_attn_fwd_persistent.exec_endif_9:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 64
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v1, 6, s21
		v_lshl_add_u32 v2, v3, 1, v2
		v_accvgpr_read_b32 v8, a17
		v_lshl_add_u32 v2, v8, 4, v2
		v_accvgpr_read_b32 v8, a54
		s_nop 0
		v_readfirstlane_b32 s28, v8
		v_accvgpr_read_b32 v8, a55
		s_nop 0
		v_readfirstlane_b32 s29, v8
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_10
		buffer_store_dwordx4 v[16:19], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_10:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_10
.L_attn_fwd_persistent.exec_endif_10:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x60
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v1, 6, s21
		v_lshl_add_u32 v2, v3, 1, v2
		v_accvgpr_read_b32 v8, a17
		v_lshl_add_u32 v2, v8, 4, v2
		v_accvgpr_read_b32 v8, a54
		s_nop 0
		v_readfirstlane_b32 s28, v8
		v_accvgpr_read_b32 v8, a55
		s_nop 0
		v_readfirstlane_b32 s29, v8
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_11
		buffer_store_dwordx4 v[20:23], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_11:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_11
.L_attn_fwd_persistent.exec_endif_11:
		s_mov_b64 exec, s[96:97]
		v_accvgpr_read_b32 v2, a4
		s_nop 0
		v_readfirstlane_b32 s21, v2
		s_lshl_b32 s21, s21, 8
		s_add_i32 s23, s21, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v1, 6, s23
		v_lshl_add_u32 v2, v3, 1, v2
		v_accvgpr_read_b32 v8, a17
		v_lshl_add_u32 v2, v8, 4, v2
		v_accvgpr_read_b32 v8, a56
		s_nop 0
		v_readfirstlane_b32 s28, v8
		v_accvgpr_read_b32 v8, a57
		s_nop 0
		v_readfirstlane_b32 s29, v8
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_12
		buffer_store_dwordx4 v[24:27], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_12:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_12
.L_attn_fwd_persistent.exec_endif_12:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 32
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v1, 6, s23
		v_lshl_add_u32 v2, v3, 1, v2
		v_accvgpr_read_b32 v8, a17
		v_lshl_add_u32 v2, v8, 4, v2
		v_accvgpr_read_b32 v8, a56
		s_nop 0
		v_readfirstlane_b32 s28, v8
		v_accvgpr_read_b32 v8, a57
		s_nop 0
		v_readfirstlane_b32 s29, v8
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_13
		buffer_store_dwordx4 v[4:7], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_13:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_13
.L_attn_fwd_persistent.exec_endif_13:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 64
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v1, 6, s23
		v_lshl_add_u32 v2, v3, 1, v2
		v_accvgpr_read_b32 v4, a17
		v_lshl_add_u32 v2, v4, 4, v2
		v_accvgpr_read_b32 v4, a56
		s_nop 0
		v_readfirstlane_b32 s28, v4
		v_accvgpr_read_b32 v4, a57
		s_nop 0
		v_readfirstlane_b32 s29, v4
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_14
		buffer_store_dwordx4 v[12:15], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_14:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_14
.L_attn_fwd_persistent.exec_endif_14:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s21, 0x60
		s_add_i32 s1, s21, s1
		s_add_i32 s1, s1, s18
		s_add_i32 s1, s1, s22
		v_lshl_add_u32 v1, v1, 6, s1
		v_lshl_add_u32 v1, v3, 1, v1
		v_accvgpr_read_b32 v2, a17
		v_lshl_add_u32 v1, v2, 4, v1
		v_accvgpr_read_b32 v2, a56
		s_nop 0
		v_readfirstlane_b32 s22, v2
		v_accvgpr_read_b32 v2, a57
		s_nop 0
		v_readfirstlane_b32 s23, v2
		s_and_saveexec_b64 s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_15
		buffer_store_dwordx4 v[28:31], v1, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_15:
		s_andn2_b64 exec, s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_15
.L_attn_fwd_persistent.exec_endif_15:
		s_mov_b64 exec, s[96:97]
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
		s_xor_b32 s21, s18, -1
		s_add_i32 s21, s21, 1
		s_add_i32 s21, s21, 31
		s_cmp_eq_u32 s1, 0
		s_cselect_b32 s1, s18, s21
		v_mov_b32_e32 v1, s1
		v_accvgpr_write_b32 a13, v1
		v_accvgpr_read_b32 v1, a13
		s_nop 0
		v_readfirstlane_b32 s1, v1
		s_mul_i32 s1, s1, 0x100
		v_and_b32_e32 v1, 1, v0
		v_lshrrev_b32_e32 v2, 1, v0
		v_and_b32_e32 v2, 1, v2
		v_mov_b32_e32 v3, 2
		v_mul_lo_u32 v3, v3, v2
		v_lshrrev_b32_e32 v2, 2, v0
		v_and_b32_e32 v4, 1, v2
		v_mov_b32_e32 v5, 4
		v_mul_lo_u32 v5, v5, v4
		v_bitop3_b32 v4, v1, v3, v5 bitop3:0x96
		v_lshrrev_b32_e32 v6, 3, v0
		v_and_b32_e32 v7, 1, v6
		v_mov_b32_e32 v8, 8
		v_mul_lo_u32 v8, v8, v7
		v_xor_b32_e32 v4, v4, v8
		v_lshrrev_b32_e32 v9, 4, v0
		v_and_b32_e32 v10, 1, v9
		v_mov_b32_e32 v11, 16
		v_mul_lo_u32 v11, v11, v10
		v_lshrrev_b32_e32 v12, 6, v0
		v_accvgpr_write_b32 a14, v12
		v_accvgpr_read_b32 v12, a14
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v13, 32
		v_mul_lo_u32 v13, v13, v12
		v_bitop3_b32 v4, v4, v11, v13 bitop3:0x96
		v_lshrrev_b32_e32 v14, 7, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 64
		v_mul_lo_u32 v15, v15, v14
		v_xor_b32_e32 v4, v4, v15
		v_accvgpr_write_b32 a15, v4
		v_xor_b32_e32 v1, 0x80, v1
		v_xor_b32_e32 v1, v1, v3
		v_xor_b32_e32 v1, v1, v5
		v_bitop3_b32 v1, v1, v8, v11 bitop3:0x96
		v_bitop3_b32 v1, v1, v13, v15 bitop3:0x96
		v_accvgpr_write_b32 a16, v1
		v_mov_b32_e32 v1, 2
		v_mul_lo_u32 v1, v1, v10
		v_lshrrev_b32_e32 v3, 5, v0
		v_and_b32_e32 v4, 1, v3
		v_mov_b32_e32 v5, 4
		v_mul_lo_u32 v5, v5, v4
		v_bitop3_b32 v8, v7, v1, v5 bitop3:0x96
		v_mov_b32_e32 v11, 8
		v_mul_lo_u32 v11, v11, v12
		v_xor_b32_e32 v8, v8, v11
		v_mov_b32_e32 v13, 16
		v_mul_lo_u32 v13, v13, v14
		v_xad_u32 v8, v8, v13, s1
		v_bitop3_b32 v15, 32, v7, v1 bitop3:0x96
		v_bitop3_b32 v15, v15, v5, v11 bitop3:0x96
		v_xad_u32 v15, v15, v13, s1
		v_bitop3_b32 v16, 64, v7, v1 bitop3:0x96
		v_bitop3_b32 v16, v16, v5, v11 bitop3:0x96
		v_xad_u32 v16, v16, v13, s1
		v_xor_b32_e32 v17, 0x60, v7
		v_xor_b32_e32 v17, v17, v1
		v_xor_b32_e32 v17, v17, v5
		v_xor_b32_e32 v17, v17, v11
		v_xad_u32 v17, v17, v13, s1
		v_xor_b32_e32 v18, 0x80, v7
		v_xor_b32_e32 v18, v18, v1
		v_xor_b32_e32 v18, v18, v5
		v_xor_b32_e32 v18, v18, v11
		v_xad_u32 v18, v18, v13, s1
		v_xor_b32_e32 v19, 0xa0, v7
		v_xor_b32_e32 v19, v19, v1
		v_xor_b32_e32 v19, v19, v5
		v_xor_b32_e32 v19, v19, v11
		v_xad_u32 v19, v19, v13, s1
		v_xor_b32_e32 v20, 0xc0, v7
		v_xor_b32_e32 v20, v20, v1
		v_xor_b32_e32 v20, v20, v5
		v_xor_b32_e32 v20, v20, v11
		v_xad_u32 v20, v20, v13, s1
		v_xor_b32_e32 v21, 0xe0, v7
		v_xor_b32_e32 v1, v21, v1
		v_xor_b32_e32 v1, v1, v5
		v_xor_b32_e32 v1, v1, v11
		v_xad_u32 v1, v1, v13, s1
		v_cmp_lt_i32_e64 s[22:23], v8, s19
		v_cmp_lt_i32_e64 s[24:25], v15, s19
		v_cmp_lt_i32_e64 s[26:27], v16, s19
		v_cmp_lt_i32_e64 s[28:29], v17, s19
		v_cmp_lt_i32_e64 s[30:31], v18, s19
		v_cmp_lt_i32_e64 s[32:33], v19, s19
		v_cmp_lt_i32_e64 s[34:35], v20, s19
		s_mov_b32 s38, 0x7fffffff
		s_mov_b32 s39, 0x31016000
		s_mov_b32 s36, s2
		s_mov_b32 s37, s3
		v_accvgpr_read_b32 v8, a7
		v_and_b32_e32 v8, 0xffff, v8
		v_lshlrev_b32_e32 v11, 16, v8
		v_or_b32_e32 v16, v8, v11
		v_mov_b32_e32 v17, v16
		v_mov_b32_e32 v18, v16
		v_mov_b32_e32 v19, v16
		v_accvgpr_read_b32 v8, a13
		s_nop 0
		v_readfirstlane_b32 s18, v8
		s_mul_i32 s18, s18, s12
		s_lshl_b32 s18, s18, 9
		v_accvgpr_read_b32 v8, a11
		s_nop 0
		v_readfirstlane_b32 s21, v8
		s_mul_i32 s21, s21, s10
		s_lshl_b32 s21, s21, 1
		s_add_i32 s40, s18, s21
		v_accvgpr_read_b32 v8, a12
		s_nop 0
		v_readfirstlane_b32 s41, v8
		s_mul_i32 s41, s41, s11
		s_lshl_b32 s41, s41, 1
		s_add_i32 s40, s40, s41
		v_mul_lo_u32 v8, s12, v6
		v_lshl_add_u32 v11, v8, 1, s40
		v_and_b32_e32 v13, 7, v0
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_16
		buffer_load_dwordx4 v[20:23], v11, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_16:
		s_andn2_b64 exec, s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_16
		v_mov_b32_e32 v20, v16
		v_mov_b32_e32 v21, v17
		v_mov_b32_e32 v22, v18
		v_mov_b32_e32 v23, v19
.L_attn_fwd_persistent.exec_endif_16:
		s_mov_b64 exec, s[96:97]
		s_lshl_b32 s22, s12, 6
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s41
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_17
		buffer_load_dwordx4 v[24:27], v11, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_17:
		s_andn2_b64 exec, s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_17
		v_mov_b32_e32 v24, v16
		v_mov_b32_e32 v25, v17
		v_mov_b32_e32 v26, v18
		v_mov_b32_e32 v27, v19
.L_attn_fwd_persistent.exec_endif_17:
		s_mov_b64 exec, s[96:97]
		s_lshl_b32 s22, s12, 7
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s41
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_18
		buffer_load_dwordx4 v[28:31], v11, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_18:
		s_andn2_b64 exec, s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_18
		v_mov_b32_e32 v28, v16
		v_mov_b32_e32 v29, v17
		v_mov_b32_e32 v30, v18
		v_mov_b32_e32 v31, v19
.L_attn_fwd_persistent.exec_endif_18:
		s_mov_b64 exec, s[96:97]
		s_mul_i32 s22, 0xc0, s12
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s41
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_19
		buffer_load_dwordx4 v[32:35], v11, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_19:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_19
		v_mov_b32_e32 v32, v16
		v_mov_b32_e32 v33, v17
		v_mov_b32_e32 v34, v18
		v_mov_b32_e32 v35, v19
.L_attn_fwd_persistent.exec_endif_19:
		s_mov_b64 exec, s[96:97]
		s_lshl_b32 s22, s12, 8
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s41
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_20
		buffer_load_dwordx4 v[36:39], v11, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_20:
		s_andn2_b64 exec, s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_20
		v_mov_b32_e32 v36, v16
		v_mov_b32_e32 v37, v17
		v_mov_b32_e32 v38, v18
		v_mov_b32_e32 v39, v19
.L_attn_fwd_persistent.exec_endif_20:
		s_mov_b64 exec, s[96:97]
		s_mul_i32 s22, 0x140, s12
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s41
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_21
		buffer_load_dwordx4 v[40:43], v11, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_21:
		s_andn2_b64 exec, s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_21
		v_mov_b32_e32 v40, v16
		v_mov_b32_e32 v41, v17
		v_mov_b32_e32 v42, v18
		v_mov_b32_e32 v43, v19
.L_attn_fwd_persistent.exec_endif_21:
		s_mov_b64 exec, s[96:97]
		s_mul_i32 s22, 0x180, s12
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s41
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_22
		buffer_load_dwordx4 v[44:47], v11, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_22:
		s_andn2_b64 exec, s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_22
		v_mov_b32_e32 v44, v16
		v_mov_b32_e32 v45, v17
		v_mov_b32_e32 v46, v18
		v_mov_b32_e32 v47, v19
.L_attn_fwd_persistent.exec_endif_22:
		s_mov_b64 exec, s[96:97]
		s_mul_i32 s22, 0x1c0, s12
		s_add_i32 s18, s22, s18
		s_add_i32 s18, s18, s21
		s_add_i32 s18, s18, s41
		v_lshl_add_u32 v8, v8, 1, s18
		v_lshl_add_u32 v8, v13, 4, v8
		v_cmp_lt_i32_e64 vcc, v1, s19
		s_and_saveexec_b64 s[96:97], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_23
		buffer_load_dwordx4 v[48:51], v8, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_23:
		s_andn2_b64 exec, s[96:97], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_23
		v_mov_b32_e32 v48, v16
		v_mov_b32_e32 v49, v17
		v_mov_b32_e32 v50, v18
		v_mov_b32_e32 v51, v19
.L_attn_fwd_persistent.exec_endif_23:
		s_mov_b64 exec, s[96:97]
		s_mov_b32 s24, s4
		s_mov_b32 s25, s5
		s_mov_b32 s26, s38
		s_mov_b32 s27, s39
		s_mov_b32 s28, s6
		s_mov_b32 s29, s7
		s_mov_b32 s30, s38
		s_mov_b32 s31, s39
		s_waitcnt vmcnt(0)
		s_barrier
		v_and_b32_e32 v1, 1, v3
		v_accvgpr_write_b32 a17, v1
		v_accvgpr_read_b32 v1, a17
		v_lshlrev_b32_e32 v1, 1, v1
		v_accvgpr_read_b32 v3, a14
		v_and_b32_e32 v3, 1, v3
		v_lshlrev_b32_e32 v3, 2, v3
		v_and_b32_e32 v8, 1, v9
		v_accvgpr_write_b32 a18, v8
		v_accvgpr_read_b32 v8, a18
		v_xor_b32_e32 v3, v3, v8
		v_bitop3_b32 v1, v0, v1, v3 bitop3:0x96
		v_lshlrev_b32_e32 v1, 4, v1
		v_add_u32_e32 v1, 0x10000, v1
		ds_write_b128 v1, v[20:23] offset:18864
		ds_write_b128 v1, v[24:27] offset:22960
		ds_write_b128 v1, v[28:31] offset:27056
		ds_write_b128 v1, v[32:35] offset:31152
		v_mov_b32_e32 v3, 32
		v_mul_lo_u32 v3, v3, v10
		v_mov_b32_e32 v8, 2
		v_mul_lo_u32 v8, v8, v14
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v9, a14
		v_lshlrev_b32_e32 v9, 12, v9
		v_add_u32_e32 v9, 0x10000, v9
		v_and_b32_e32 v10, 63, v0
		v_and_b32_e32 v11, 7, v10
		v_lshrrev_b32_e32 v14, 2, v11
		v_lshl_add_u32 v15, v14, 5, v9
		v_lshrrev_b32_e32 v16, 3, v10
		v_bitop3_b32 v16, v16, 3, 1 bitop3:0x80
		v_lshl_add_u32 v17, v16, 6, v15
		v_lshrrev_b32_e32 v18, 5, v10
		v_and_b32_e32 v10, 31, v10
		v_lshlrev_b32_e32 v19, 3, v10
		v_add_u32_e32 v20, v18, v19
		v_lshrrev_b32_e32 v11, 1, v11
		v_and_b32_e32 v11, 1, v11
		v_xor_b32_e32 v20, v20, v11
		v_lshl_add_u32 v17, v20, 4, v17
		ds_read_b128 a[20:23], v17 offset:18864
		v_lshl_add_u32 v20, v16, 6, v9
		v_add3_u32 v21, 2, v18, v19
		v_lshlrev_b32_e32 v14, 1, v14
		v_bitop3_b32 v21, v21, v14, v11 bitop3:0x96
		v_lshl_add_u32 v20, v21, 4, v20
		ds_read_b128 a[24:27], v20 offset:18864
		v_add3_u32 v21, 4, v18, v19
		v_lshlrev_b32_e32 v16, 2, v16
		v_xor_b32_e32 v11, v16, v11
		v_xor_b32_e32 v16, v21, v11
		v_lshl_add_u32 v15, v16, 4, v15
		ds_read_b128 a[28:31], v15 offset:18864
		v_add3_u32 v16, 6, v18, v19
		v_bitop3_b32 v11, v16, v14, v11 bitop3:0x96
		v_lshl_add_u32 v9, v11, 4, v9
		ds_read_b128 a[32:35], v9 offset:18864
		v_and_b32_e32 v6, 1, v6
		v_lshlrev_b32_e32 v11, 4, v13
		v_and_b32_e32 v2, 1, v2
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[36:39] offset:18864
		ds_write_b128 v1, v[40:43] offset:22960
		ds_write_b128 v1, v[44:47] offset:27056
		ds_write_b128 v1, v[48:51] offset:31152
		v_accvgpr_read_b32 v1, a13
		s_nop 0
		v_readfirstlane_b32 s18, v1
		s_add_i32 s18, s18, 1
		s_mul_i32 s18, s18, 0x100
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[36:39], v17 offset:18864
		ds_read_b128 a[40:43], v20 offset:18864
		ds_read_b128 a[44:47], v15 offset:18864
		ds_read_b128 a[48:51], v9 offset:18864
		v_accvgpr_read_b32 v1, a6
		s_nop 0
		v_readfirstlane_b32 s21, v1
		s_add_i32 s18, s18, s21
		s_cmp_lt_i32 s20, s18
		s_cselect_b32 s18, s20, s18
		s_add_i32 s21, s18, 0x7f
		s_mov_b32 s22, 0x7f
		s_cmp_lt_i32 s21, 0
		s_cselect_b32 s23, s22, 0
		s_add_i32 s21, s21, s23
		s_ashr_i32 s21, s21, 7
		v_accvgpr_read_b32 v1, a6
		s_nop 0
		v_readfirstlane_b32 s23, v1
		s_add_i32 s23, s1, s23
		s_cmp_lt_i32 s23, 0
		s_cselect_b32 s32, s22, 0
		s_add_i32 s23, s23, s32
		s_ashr_i32 s23, s23, 7
		s_cmp_lt_i32 s23, s21
		s_cselect_b32 s23, s23, s21
		s_cmp_gt_i32 s23, 0
		s_cselect_b32 s23, s23, 0
		v_mov_b32_e32 v1, 64
		v_mul_lo_u32 v1, v1, v7
		v_mov_b32_e32 v9, 16
		v_mul_lo_u32 v9, v9, v4
		v_bitop3_b32 v13, v1, v3, v9 bitop3:0x96
		v_bitop3_b32 v13, v13, v12, v8 bitop3:0x96
		v_accvgpr_write_b32 a19, v13
		v_bitop3_b32 v13, 4, v1, v3 bitop3:0x96
		v_xor_b32_e32 v13, v13, v9
		v_bitop3_b32 v14, 8, v1, v3 bitop3:0x96
		v_xor_b32_e32 v14, v14, v9
		v_bitop3_b32 v1, 12, v1, v3 bitop3:0x96
		v_accvgpr_read_b32 v15, a19
		v_cmp_lt_i32_e64 s[32:33], v15, s20
		v_mov_b32_e32 v15, 16
		v_mul_lo_u32 v15, v15, v7
		v_mov_b32_e32 v7, 64
		v_mul_lo_u32 v7, v7, v4
		v_bitop3_b32 v4, v15, v3, v7 bitop3:0x96
		v_bitop3_b32 v4, v4, v12, v8 bitop3:0x96
		v_accvgpr_write_b32 a52, v4
		v_bitop3_b32 v4, 4, v15, v3 bitop3:0x96
		v_bitop3_b32 v16, 8, v15, v3 bitop3:0x96
		v_bitop3_b32 v3, 12, v15, v3 bitop3:0x96
		v_accvgpr_read_b32 v15, a52
		v_cmp_lt_i32_e64 vcc, v15, s20
		v_readfirstlane_b32 s34, v0
		v_accvgpr_read_b32 v15, a11
		s_nop 0
		v_readfirstlane_b32 s35, v15
		s_mul_i32 s35, s35, s13
		s_lshl_b32 s35, s35, 1
		v_accvgpr_read_b32 v15, a12
		s_nop 0
		v_readfirstlane_b32 s36, v15
		s_mul_i32 s36, s36, s14
		s_lshl_b32 s36, s36, 1
		s_add_i32 s37, s35, s36
		v_accvgpr_read_b32 v15, a14
		v_mul_lo_u32 v15, s15, v15
		v_lshlrev_b32_e32 v15, 1, v15
		v_add_u32_e32 v17, s37, v15
		v_accvgpr_read_b32 v19, a17
		v_mul_lo_u32 v19, s15, v19
		v_lshlrev_b32_e32 v19, 5, v19
		v_accvgpr_read_b32 v20, a18
		v_mul_lo_u32 v20, s15, v20
		v_lshlrev_b32_e32 v20, 6, v20
		v_add3_u32 v17, v17, v19, v20
		v_mul_lo_u32 v21, s15, v6
		v_lshlrev_b32_e32 v21, 7, v21
		v_add3_u32 v17, v17, v21, v11
		v_mov_b32_e32 v22, 0x80000000
		v_cndmask_b32_e64 v17, v22, v17, s[32:33]
		s_lshr_b32 s37, s34, 6
		s_mul_i32 s40, 0x410, s37
		s_mov_b32 m0, s40
		v_accvgpr_read_b32 v23, a15
		v_add_u32_e32 v23, s1, v23
		buffer_load_dwordx4 v17, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[42:43], v23, s19
		s_nop 1
		v_mov_b32_e32 v24, s42
		v_mov_b32_e32 v25, s43
		v_accvgpr_write_b32 a54, v24
		v_accvgpr_write_b32 a55, v25
		s_lshl_b32 s41, s15, 3
		s_add_i32 s41, s41, s35
		s_add_i32 s41, s41, s36
		v_add_u32_e32 v17, s41, v15
		v_add3_u32 v17, v17, v19, v20
		v_add3_u32 v17, v17, v21, v11
		v_cndmask_b32_e64 v17, v22, v17, s[32:33]
		s_add_i32 m0, m0, 0x1040
		v_accvgpr_read_b32 v23, a16
		v_add_u32_e32 v23, s1, v23
		buffer_load_dwordx4 v17, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[42:43], v23, s19
		s_nop 1
		v_mov_b32_e32 v24, s42
		v_mov_b32_e32 v25, s43
		v_accvgpr_write_b32 a56, v24
		v_accvgpr_write_b32 a57, v25
		s_lshl_b32 s41, s15, 4
		s_add_i32 s41, s41, s35
		s_add_i32 s41, s41, s36
		v_add_u32_e32 v17, s41, v15
		v_add3_u32 v17, v17, v19, v20
		v_add3_u32 v17, v17, v21, v11
		v_cndmask_b32_e64 v17, v22, v17, s[32:33]
		s_add_i32 m0, m0, 0x1040
		v_lshlrev_b32_e32 v18, 4, v18
		v_accvgpr_write_b32 a53, v18
		buffer_load_dwordx4 v17, s[24:27], 0 offen lds
		v_bitop3_b32 v13, v13, v12, v8 bitop3:0x96
		v_accvgpr_write_b32 a58, v13
		s_mul_i32 s41, 24, s15
		s_add_i32 s41, s41, s35
		s_add_i32 s41, s41, s36
		v_add_u32_e32 v13, s41, v15
		v_add3_u32 v13, v13, v19, v20
		v_add3_u32 v13, v13, v21, v11
		v_cndmask_b32_e64 v13, v22, v13, s[32:33]
		s_add_i32 m0, m0, 0x1040
		v_mov_b32_e32 v17, 0x440
		v_mul_lo_u32 v17, v17, v2
		v_accvgpr_write_b32 a59, v17
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		v_bitop3_b32 v2, v14, v12, v8 bitop3:0x96
		v_accvgpr_write_b32 a60, v2
		v_accvgpr_read_b32 v2, a0
		s_nop 0
		v_readfirstlane_b32 s32, v2
		v_accvgpr_read_b32 v2, a11
		s_nop 0
		v_readfirstlane_b32 s33, v2
		s_mul_i32 s32, s33, s32
		s_lshl_b32 s32, s32, 1
		v_accvgpr_read_b32 v2, a1
		s_nop 0
		v_readfirstlane_b32 s33, v2
		v_accvgpr_read_b32 v2, a12
		s_nop 0
		v_readfirstlane_b32 s41, v2
		s_mul_i32 s33, s41, s33
		s_lshl_b32 s33, s33, 1
		s_add_i32 s41, s32, s33
		v_accvgpr_read_b32 v2, a14
		v_mul_lo_u32 v2, s17, v2
		v_lshlrev_b32_e32 v2, 1, v2
		v_add_u32_e32 v13, s41, v2
		v_accvgpr_read_b32 v14, a17
		v_mul_lo_u32 v14, s17, v14
		v_lshlrev_b32_e32 v14, 7, v14
		v_accvgpr_read_b32 v17, a18
		v_mul_lo_u32 v17, s17, v17
		v_lshlrev_b32_e32 v17, 6, v17
		v_add3_u32 v13, v13, v14, v17
		v_mul_lo_u32 v18, s17, v6
		v_lshlrev_b32_e32 v18, 5, v18
		v_add3_u32 v13, v13, v18, v11
		v_cndmask_b32_e32 v13, v22, v13, vcc
		s_mul_i32 s37, 0x440, s37
		s_add_i32 m0, s37, 0x81f0
		v_xor_b32_e32 v1, v1, v9
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		v_bitop3_b32 v1, v1, v12, v8 bitop3:0x96
		v_accvgpr_write_b32 a61, v1
		s_lshl_b32 s41, s17, 3
		s_add_i32 s41, s41, s32
		s_add_i32 s41, s41, s33
		v_add_u32_e32 v1, s41, v2
		v_add3_u32 v1, v1, v14, v17
		v_add3_u32 v1, v1, v18, v11
		v_cndmask_b32_e32 v1, v22, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v4, v4, v7
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_bitop3_b32 v1, v4, v12, v8 bitop3:0x96
		v_accvgpr_write_b32 a62, v1
		s_lshl_b32 s41, s17, 4
		s_add_i32 s41, s41, s32
		s_add_i32 s41, s41, s33
		v_add_u32_e32 v1, s41, v2
		v_add3_u32 v1, v1, v14, v17
		v_add3_u32 v1, v1, v18, v11
		v_cndmask_b32_e32 v1, v22, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v4, v16, v7
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_bitop3_b32 v1, v4, v12, v8 bitop3:0x96
		v_accvgpr_write_b32 a63, v1
		s_mul_i32 s41, 24, s17
		s_add_i32 s41, s41, s32
		s_add_i32 s41, s41, s33
		v_add_u32_e32 v1, s41, v2
		v_add3_u32 v1, v1, v14, v17
		v_add3_u32 v1, v1, v18, v11
		v_cndmask_b32_e32 v1, v22, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v3, v3, v7
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_bitop3_b32 v1, v3, v12, v8 bitop3:0x96
		v_accvgpr_write_b32 a64, v1
		s_mul_i32 s41, s23, 0x80
		v_mbcnt_lo_u32_b32 v1, -1, 0
		v_mbcnt_hi_u32_b32 v1, -1, v1
		v_and_b32_e32 v1, 31, v1
		v_add_u32_e32 v3, 32, v1
		v_mov_b32_e32 v8, 0x3e38aa3b
		v_mov_b32_e32 v9, 0x3e38aa3b
		s_mov_b32 s23, 0xff800000
		v_mov_b32_e32 v4, s23
		v_mov_b32_e32 v7, s23
		s_mov_b32 s23, 1.0
		v_mov_b32_e32 v12, s23
		v_mov_b32_e32 v13, s23
		s_mov_b32 s23, 0
		v_lshrrev_b32_e32 v16, 4, v10
		v_lshlrev_b32_e32 v16, 9, v16
		v_accvgpr_write_b32 a65, v16
		v_and_b32_e32 v10, 15, v10
		v_mov_b32_e32 v16, 0x410
		v_mul_lo_u32 v16, v16, v10
		v_accvgpr_write_b32 a66, v16
		v_and_b32_e32 v10, 3, v0
		v_accvgpr_write_b32 a67, v10
		v_accvgpr_read_b32 v10, a67
		v_lshlrev_b32_e32 v10, 3, v10
		v_accvgpr_write_b32 a68, v10
		v_accvgpr_read_b32 v10, a17
		v_mov_b32_e32 v16, 0x2200
		v_mul_lo_u32 v16, v16, v10
		v_accvgpr_write_b32 a69, v16
		v_accvgpr_read_b32 v10, a18
		v_lshlrev_b32_e32 v10, 5, v10
		v_accvgpr_write_b32 a70, v10
		v_mov_b32_e32 v10, 0x880
		v_mul_lo_u32 v10, v10, v6
		v_accvgpr_write_b32 a71, v10
		s_lshl_b32 s42, s15, 8
		s_add_i32 s42, s42, s35
		s_add_i32 s42, s42, s36
		s_mul_i32 s43, 0x108, s15
		s_add_i32 s43, s43, s35
		s_add_i32 s43, s43, s36
		s_mul_i32 s44, 0x110, s15
		s_add_i32 s44, s44, s35
		s_add_i32 s44, s44, s36
		s_mul_i32 s45, 0x118, s15
		s_add_i32 s35, s45, s35
		s_add_i32 s36, s35, s36
		s_lshl_b32 s35, s17, 8
		s_add_i32 s35, s35, s32
		s_add_i32 s45, s35, s33
		s_mul_i32 s35, 0x108, s17
		s_add_i32 s35, s35, s32
		s_add_i32 s46, s35, s33
		s_mul_i32 s35, 0x110, s17
		s_add_i32 s35, s35, s32
		s_add_i32 s47, s35, s33
		s_mul_i32 s35, 0x118, s17
		s_add_i32 s32, s35, s32
		s_add_i32 s32, s32, s33
		v_lshlrev_b32_e32 v1, 2, v1
		v_accvgpr_write_b32 a72, v1
		v_lshlrev_b32_e32 v1, 2, v3
		v_accvgpr_write_b32 a73, v1
		v_add3_u32 v1, v15, v19, v20
		v_add_u32_e32 v1, v1, v21
		v_add3_u32 v3, v2, v14, v17
		v_add_u32_e32 v3, v3, v18
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
		s_lshr_b32 s33, s23, 7
		s_and_b32 s35, s33, 1
		s_mul_i32 s48, 0x4100, s35
		v_accvgpr_read_b32 v6, a53
		v_add_u32_e32 v6, s48, v6
		v_accvgpr_read_b32 v10, a65
		v_accvgpr_read_b32 v16, a66
		v_add3_u32 v6, v6, v10, v16
		ds_read_b128 v[24:27], v6
		ds_read_b128 v[28:31], v6 offset:32
		ds_read_b128 v[96:99], v6 offset:64
		ds_read_b128 a[76:79], v6 offset:96
		ds_read_b128 v[100:103], v6 offset:256
		ds_read_b128 v[104:107], v6 offset:288
		ds_read_b128 v[108:111], v6 offset:320
		ds_read_b128 a[80:83], v6 offset:352
		ds_read_b128 v[112:115], v6 offset:128
		ds_read_b128 v[116:119], v6 offset:160
		ds_read_b128 v[120:123], v6 offset:192
		ds_read_b128 a[84:87], v6 offset:224
		ds_read_b128 a[88:91], v6 offset:384
		ds_read_b128 a[92:95], v6 offset:416
		ds_read_b128 a[96:99], v6 offset:448
		ds_read_b128 a[100:103], v6 offset:480
		s_mul_i32 s35, 0x4400, s35
		v_accvgpr_read_b32 v6, a68
		v_add_u32_e32 v6, s35, v6
		v_accvgpr_read_b32 v10, a70
		v_accvgpr_read_b32 v16, a69
		v_add3_u32 v6, v6, v16, v10
		v_accvgpr_read_b32 v10, a59
		v_accvgpr_read_b32 v16, a71
		v_add3_u32 v6, v6, v16, v10
		ds_read_b64_tr_b16 a[104:105], v6 offset:33264
		ds_read_b64_tr_b16 a[106:107], v6 offset:37616
		ds_read_b64_tr_b16 a[108:109], v6 offset:33392
		ds_read_b64_tr_b16 a[110:111], v6 offset:37744
		ds_read_b64_tr_b16 a[112:113], v6 offset:33520
		ds_read_b64_tr_b16 a[114:115], v6 offset:37872
		ds_read_b64_tr_b16 a[116:117], v6 offset:33648
		ds_read_b64_tr_b16 a[118:119], v6 offset:38000
		ds_read_b64_tr_b16 a[120:121], v6 offset:33776
		ds_read_b64_tr_b16 a[122:123], v6 offset:38128
		ds_read_b64_tr_b16 a[124:125], v6 offset:33904
		ds_read_b64_tr_b16 a[126:127], v6 offset:38256
		ds_read_b64_tr_b16 a[128:129], v6 offset:34032
		ds_read_b64_tr_b16 a[130:131], v6 offset:38384
		ds_read_b64_tr_b16 a[132:133], v6 offset:34160
		ds_read_b64_tr_b16 a[134:135], v6 offset:38512
		ds_read_b64_tr_b16 a[136:137], v6 offset:33328
		ds_read_b64_tr_b16 a[138:139], v6 offset:37680
		ds_read_b64_tr_b16 a[140:141], v6 offset:33456
		ds_read_b64_tr_b16 a[142:143], v6 offset:37808
		ds_read_b64_tr_b16 a[144:145], v6 offset:33584
		ds_read_b64_tr_b16 a[146:147], v6 offset:37936
		ds_read_b64_tr_b16 a[148:149], v6 offset:33712
		ds_read_b64_tr_b16 a[150:151], v6 offset:38064
		ds_read_b64_tr_b16 a[152:153], v6 offset:33840
		ds_read_b64_tr_b16 a[154:155], v6 offset:38192
		ds_read_b64_tr_b16 a[156:157], v6 offset:33968
		ds_read_b64_tr_b16 a[158:159], v6 offset:38320
		ds_read_b64_tr_b16 a[160:161], v6 offset:34096
		ds_read_b64_tr_b16 a[162:163], v6 offset:38448
		ds_read_b64_tr_b16 a[164:165], v6 offset:34224
		ds_read_b64_tr_b16 a[166:167], v6 offset:38576
		s_mul_i32 s35, s15, s23
		s_lshl_b32 s35, s35, 1
		s_add_i32 s48, s42, s35
		v_add_u32_e32 v6, s48, v15
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[128:143], v[24:27], a[20:23], 0
		v_add3_u32 v6, v6, v19, v20
		v_mfma_f32_32x32x16_bf16 v[128:143], v[28:31], a[24:27], v[128:143]
		v_add3_u32 v6, v6, v21, v11
		v_mfma_f32_32x32x16_bf16 v[128:143], v[96:99], a[28:31], v[128:143]
		s_add_i32 s33, s33, 1
		v_mfma_f32_32x32x16_bf16 v[144:159], v[24:27], a[36:39], 0
		s_and_b32 s33, s33, 1
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[40:43], v[144:159]
		s_mul_i32 s48, 0x4100, s33
		v_mfma_f32_32x32x16_bf16 v[144:159], v[96:99], a[44:47], v[144:159]
		s_add_i32 s48, s40, s48
		v_mfma_f32_32x32x16_bf16 v[160:175], v[100:103], a[20:23], 0
		s_mov_b32 m0, s48
		v_mfma_f32_32x32x16_bf16 v[160:175], v[104:107], a[24:27], v[160:175]
		s_add_i32 s48, s43, s35
		v_mfma_f32_32x32x16_bf16 v[160:175], v[108:111], a[28:31], v[160:175]
		v_add3_u32 v10, v11, v1, s48
		v_mfma_f32_32x32x16_bf16 v[176:191], v[100:103], a[36:39], 0
		s_add_i32 s48, s44, s35
		v_mfma_f32_32x32x16_bf16 v[176:191], v[104:107], a[40:43], v[176:191]
		v_add3_u32 v16, v11, v1, s48
		v_mfma_f32_32x32x16_bf16 v[176:191], v[108:111], a[44:47], v[176:191]
		s_add_i32 s35, s36, s35
		v_mfma_f32_32x32x16_bf16 v[96:111], v[112:115], a[20:23], 0
		v_add3_u32 v23, v11, v1, s35
		v_mfma_f32_32x32x16_bf16 v[96:111], v[116:119], a[24:27], v[96:111]
		s_mul_i32 s35, s17, s23
		v_mfma_f32_32x32x16_bf16 v[96:111], v[120:123], a[28:31], v[96:111]
		s_add_i32 s23, s23, 0x80
		v_mfma_f32_32x32x16_bf16 v[192:207], v[112:115], a[36:39], 0
		v_accvgpr_read_b32 v24, a19
		v_add_u32_e32 v24, s23, v24
		v_mfma_f32_32x32x16_bf16 v[192:207], v[116:119], a[40:43], v[192:207]
		v_accvgpr_read_b32 v25, a58
		v_add_u32_e32 v25, s23, v25
		v_mfma_f32_32x32x16_bf16 v[192:207], v[120:123], a[44:47], v[192:207]
		v_accvgpr_read_b32 v26, a60
		v_add_u32_e32 v26, s23, v26
		v_mfma_f32_32x32x16_bf16 v[112:127], a[88:91], a[20:23], 0
		v_accvgpr_read_b32 v27, a61
		v_add_u32_e32 v27, s23, v27
		v_mfma_f32_32x32x16_bf16 v[112:127], a[92:95], a[24:27], v[112:127]
		v_cmp_lt_i32_e64 s[48:49], v24, s20
		v_mfma_f32_32x32x16_bf16 v[112:127], a[96:99], a[28:31], v[112:127]
		v_accvgpr_read_b32 v24, a52
		v_add_u32_e32 v24, s23, v24
		v_mfma_f32_32x32x16_bf16 v[208:223], a[88:91], a[36:39], 0
		v_accvgpr_read_b32 v28, a62
		v_add_u32_e32 v28, s23, v28
		v_accvgpr_read_b32 v29, a63
		v_add_u32_e32 v29, s23, v29
		v_cmp_lt_i32_e64 s[50:51], v24, s20
		v_cndmask_b32_e64 v6, v22, v6, s[48:49]
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[48:49], v25, s20
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[52:53], v26, s20
		v_mfma_f32_32x32x16_bf16 v[208:223], a[92:95], a[40:43], v[208:223]
		v_cndmask_b32_e64 v6, v22, v10, s[48:49]
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[208:223], a[96:99], a[44:47], v[208:223]
		v_cndmask_b32_e64 v6, v22, v16, s[52:53]
		v_cmp_lt_i32_e64 s[48:49], v27, s20
		s_add_i32 m0, m0, 0x1040
		v_accvgpr_read_b32 v10, a64
		v_add_u32_e32 v10, s23, v10
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[128:143], a[76:79], a[32:35], v[128:143]
		v_cndmask_b32_e64 v6, v22, v23, s[48:49]
		v_cmp_lt_i32_e64 s[48:49], v28, s20
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s35, s35, 1
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[52:53], v29, s20
		s_add_i32 s54, s45, s35
		v_mfma_f32_32x32x16_bf16 v[144:159], a[76:79], a[48:51], v[144:159]
		v_add_u32_e32 v6, s54, v2
		v_add3_u32 v6, v6, v14, v17
		v_add3_u32 v6, v6, v18, v11
		v_cndmask_b32_e64 v6, v22, v6, s[50:51]
		v_max3_f32 v16, v128, v129, v130
		s_mul_i32 s33, 0x4400, s33
		v_max3_f32 v23, v132, v133, v134
		s_add_i32 s33, s37, s33
		v_max3_f32 v24, v136, v137, v138
		s_add_i32 m0, s33, 0x81f0
		s_add_i32 s33, s46, s35
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_add3_u32 v6, v11, v3, s33
		v_cndmask_b32_e64 v6, v22, v6, s[48:49]
		v_max3_f32 v25, v140, v141, v142
		s_add_i32 m0, m0, 0x1100
		s_add_i32 s33, s47, s35
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_add3_u32 v6, v11, v3, s33
		v_max3_f32 v16, v16, v131, v23
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v6, v22, v6, s[52:53]
		s_add_i32 s33, s32, s35
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v10, s20
		v_add3_u32 v6, v11, v3, s33
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e32 v6, v22, v6, vcc
		v_max3_f32 v10, v24, v139, v25
		v_max3_f32 v10, v16, v135, v10
		v_max3_f32 v16, v144, v145, v146
		v_max3_f32 v23, v148, v149, v150
		v_max3_f32 v24, v152, v153, v154
		v_max3_f32 v25, v156, v157, v158
		v_max3_f32 v16, v16, v147, v23
		v_max3_f32 v23, v24, v155, v25
		v_max3_f32 v16, v16, v151, v23
		s_cmp_lt_i32 s23, s41
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[160:175], a[80:83], a[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[84:87], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[100:103], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[100:103], a[48:51], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[80:83], a[48:51], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[84:87], a[48:51], v[192:207]
		s_nop 6
		v_max3_f32 v6, v160, v161, v162
		v_max3_f32 v23, v164, v165, v166
		v_max3_f32 v24, v168, v169, v170
		v_max3_f32 v25, v172, v173, v174
		v_max3_f32 v26, v96, v97, v98
		v_max3_f32 v27, v100, v101, v102
		v_max3_f32 v28, v104, v105, v106
		v_max3_f32 v29, v108, v109, v110
		v_max3_f32 v30, v112, v113, v114
		v_max3_f32 v31, v116, v117, v118
		v_max3_f32 v224, v120, v121, v122
		v_max3_f32 v225, v124, v125, v126
		v_max3_f32 v6, v6, v163, v23
		v_max3_f32 v23, v24, v171, v25
		v_max3_f32 v24, v26, v99, v27
		v_max3_f32 v25, v28, v107, v29
		v_max3_f32 v26, v30, v115, v31
		v_max3_f32 v27, v224, v123, v225
		v_max3_f32 v6, v6, v167, v23
		v_max3_f32 v23, v24, v103, v25
		v_max3_f32 v24, v26, v119, v27
		v_max3_f32 v6, v10, v143, v6
		v_max3_f32 v10, v23, v111, v24
		v_max3_f32 v6, v6, v175, v10
		v_max_f32_e32 v24, v6, v127
		v_mov_b32_e32 v25, v24
		v_max3_f32 v6, v176, v177, v178
		v_max3_f32 v10, v180, v181, v182
		v_max3_f32 v23, v184, v185, v186
		v_max3_f32 v26, v188, v189, v190
		v_max3_f32 v27, v192, v193, v194
		v_max3_f32 v28, v196, v197, v198
		v_max3_f32 v29, v200, v201, v202
		v_max3_f32 v30, v204, v205, v206
		v_max3_f32 v31, v208, v209, v210
		v_max3_f32 v224, v212, v213, v214
		v_max3_f32 v225, v216, v217, v218
		v_max3_f32 v226, v220, v221, v222
		v_max3_f32 v6, v6, v179, v10
		v_max3_f32 v10, v23, v187, v26
		v_max3_f32 v23, v27, v195, v28
		v_max3_f32 v26, v29, v203, v30
		v_permlane32_swap_b32_e32 v24, v25
		v_max3_f32 v27, v31, v211, v224
		v_max3_f32 v28, v225, v219, v226
		v_max3_f32 v6, v6, v183, v10
		v_max3_f32 v10, v23, v199, v26
		v_max3_f32 v23, v27, v215, v28
		v_max3_f32 v6, v16, v159, v6
		v_max3_f32 v10, v10, v207, v23
		v_max3_f32 v6, v6, v191, v10
		v_max_f32_e32 v26, v6, v223
		v_mov_b32_e32 v27, v26
		v_max_f32_e32 v28, v24, v25
		v_mov_b32_e32 v24, v4
		v_permlane32_swap_b32_e32 v26, v27
		v_max_f32_e32 v29, v26, v27
		v_pk_mul_f32 v[26:27], v[28:29], v[8:9]
		v_max_f32_e32 v28, v4, v26
		v_max_f32_e32 v29, v7, v27
		v_pk_fma_f32 v[26:27], v[128:129], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[130:131], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[132:133], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[134:135], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[136:137], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[138:139], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[140:141], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[142:143], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[160:161], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[162:163], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[164:165], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[166:167], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[168:169], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[170:171], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[172:173], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[174:175], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[96:97], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[98:99], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[108:109], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[110:111], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[112:113], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[114:115], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[116:117], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[118:119], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[120:121], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[122:123], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[124:125], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[126:127], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[144:145], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[146:147], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[148:149], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[150:151], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[154:155], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[156:157], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[158:159], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[176:177], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[178:179], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[180:181], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[182:183], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[184:185], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[186:187], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[188:189], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[190:191], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[192:193], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[194:195], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[196:197], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[198:199], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[200:201], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[202:203], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[204:205], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[206:207], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[208:209], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[210:211], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[212:213], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[214:215], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[216:217], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[218:219], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[220:221], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[218:219], v[222:223], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v220, v26
		v_exp_f32_e32 v222, v27
		v_exp_f32_e32 v26, v30
		v_exp_f32_e32 v224, v31
		v_exp_f32_e32 v30, v128
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
		v_exp_f32_e32 v142, v160
		v_exp_f32_e32 v242, v161
		v_exp_f32_e32 v160, v162
		v_exp_f32_e32 v244, v163
		v_exp_f32_e32 v162, v164
		v_exp_f32_e32 v246, v165
		v_exp_f32_e32 v164, v166
		v_exp_f32_e32 v248, v167
		v_exp_f32_e32 v166, v168
		v_exp_f32_e32 v250, v169
		v_exp_f32_e32 v168, v170
		v_exp_f32_e32 v252, v171
		v_exp_f32_e32 v221, v172
		v_exp_f32_e32 v223, v173
		v_exp_f32_e32 v27, v96
		v_exp_f32_e32 v225, v97
		v_exp_f32_e32 v31, v98
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
		v_exp_f32_e32 v161, v116
		v_exp_f32_e32 v245, v117
		v_exp_f32_e32 v163, v118
		v_exp_f32_e32 v247, v119
		v_exp_f32_e32 v165, v120
		v_exp_f32_e32 v249, v121
		v_exp_f32_e32 v167, v122
		v_exp_f32_e32 v251, v123
		v_exp_f32_e32 v169, v124
		v_exp_f32_e32 v253, v125
		v_exp_f32_e32 v96, v126
		v_exp_f32_e32 v98, v127
		v_exp_f32_e32 v100, v144
		v_exp_f32_e32 v102, v145
		v_exp_f32_e32 v104, v146
		v_exp_f32_e32 v106, v147
		v_exp_f32_e32 v108, v148
		v_exp_f32_e32 v110, v149
		v_exp_f32_e32 v112, v150
		v_exp_f32_e32 v114, v151
		v_exp_f32_e32 v116, v152
		v_exp_f32_e32 v118, v153
		v_exp_f32_e32 v120, v154
		v_exp_f32_e32 v122, v155
		v_exp_f32_e32 v124, v156
		v_exp_f32_e32 v126, v157
		v_exp_f32_e32 v144, v158
		v_exp_f32_e32 v146, v159
		v_exp_f32_e32 v148, v174
		v_exp_f32_e32 v150, v175
		v_exp_f32_e32 v152, v176
		v_exp_f32_e32 v154, v177
		v_exp_f32_e32 v156, v178
		v_exp_f32_e32 v158, v179
		v_exp_f32_e32 v170, v180
		v_exp_f32_e32 v172, v181
		v_exp_f32_e32 v174, v182
		v_exp_f32_e32 v176, v183
		v_exp_f32_e32 v178, v184
		v_exp_f32_e32 v180, v185
		v_exp_f32_e32 v182, v186
		v_exp_f32_e32 v184, v187
		v_exp_f32_e32 v97, v188
		v_exp_f32_e32 v99, v189
		v_exp_f32_e32 v101, v190
		v_exp_f32_e32 v103, v191
		v_exp_f32_e32 v105, v192
		v_exp_f32_e32 v107, v193
		v_exp_f32_e32 v109, v194
		v_exp_f32_e32 v111, v195
		v_exp_f32_e32 v113, v196
		v_exp_f32_e32 v115, v197
		v_exp_f32_e32 v117, v198
		v_exp_f32_e32 v119, v199
		v_exp_f32_e32 v121, v200
		v_exp_f32_e32 v123, v201
		v_exp_f32_e32 v125, v202
		v_exp_f32_e32 v127, v203
		v_exp_f32_e32 v145, v204
		v_exp_f32_e32 v147, v205
		v_exp_f32_e32 v149, v206
		v_exp_f32_e32 v151, v207
		v_exp_f32_e32 v153, v208
		v_exp_f32_e32 v155, v209
		v_exp_f32_e32 v157, v210
		v_exp_f32_e32 v159, v211
		v_exp_f32_e32 v171, v212
		v_exp_f32_e32 v173, v213
		v_exp_f32_e32 v175, v214
		v_exp_f32_e32 v177, v215
		v_exp_f32_e32 v179, v216
		v_exp_f32_e32 v181, v217
		v_exp_f32_e32 v183, v218
		v_exp_f32_e32 v185, v219
		v_pk_add_f32 v[186:187], v[220:221], v[222:223]
		v_pk_add_f32 v[188:189], v[26:27], v[224:225]
		v_pk_add_f32 v[190:191], v[30:31], v[226:227]
		v_pk_add_f32 v[192:193], v[128:129], v[228:229]
		v_pk_add_f32 v[194:195], v[130:131], v[230:231]
		v_pk_add_f32 v[196:197], v[132:133], v[232:233]
		v_pk_add_f32 v[198:199], v[134:135], v[234:235]
		v_pk_add_f32 v[200:201], v[136:137], v[236:237]
		v_pk_add_f32 v[202:203], v[138:139], v[238:239]
		v_pk_add_f32 v[204:205], v[140:141], v[240:241]
		v_pk_add_f32 v[206:207], v[142:143], v[242:243]
		v_pk_add_f32 v[208:209], v[160:161], v[244:245]
		v_pk_add_f32 v[210:211], v[162:163], v[246:247]
		v_pk_add_f32 v[212:213], v[164:165], v[248:249]
		v_pk_add_f32 v[214:215], v[166:167], v[250:251]
		v_pk_add_f32 v[216:217], v[168:169], v[252:253]
		v_pk_add_f32 v[186:187], v[186:187], v[188:189]
		v_pk_add_f32 v[188:189], v[190:191], v[192:193]
		v_pk_add_f32 v[190:191], v[194:195], v[196:197]
		v_pk_add_f32 v[192:193], v[198:199], v[200:201]
		v_pk_add_f32 v[194:195], v[202:203], v[204:205]
		v_pk_add_f32 v[196:197], v[206:207], v[208:209]
		v_pk_add_f32 v[198:199], v[210:211], v[212:213]
		v_pk_add_f32 v[200:201], v[214:215], v[216:217]
		v_pk_add_f32 v[186:187], v[186:187], v[188:189]
		v_pk_add_f32 v[188:189], v[190:191], v[192:193]
		v_pk_add_f32 v[190:191], v[194:195], v[196:197]
		v_pk_add_f32 v[192:193], v[198:199], v[200:201]
		v_pk_add_f32 v[186:187], v[186:187], v[188:189]
		v_pk_add_f32 v[188:189], v[190:191], v[192:193]
		v_pk_add_f32 v[190:191], v[186:187], v[188:189]
		v_add_f32_e32 v4, v190, v191
		v_accvgpr_read_b32 v6, a72
		ds_bpermute_b32 v186, v6, v4
		v_accvgpr_read_b32 v6, a73
		ds_bpermute_b32 v188, v6, v4
		v_pk_add_f32 v[190:191], v[96:97], v[98:99]
		v_pk_add_f32 v[192:193], v[100:101], v[102:103]
		v_pk_add_f32 v[194:195], v[104:105], v[106:107]
		v_pk_add_f32 v[196:197], v[108:109], v[110:111]
		v_pk_add_f32 v[198:199], v[112:113], v[114:115]
		v_pk_add_f32 v[200:201], v[116:117], v[118:119]
		v_pk_add_f32 v[202:203], v[120:121], v[122:123]
		v_pk_add_f32 v[204:205], v[124:125], v[126:127]
		v_pk_add_f32 v[206:207], v[144:145], v[146:147]
		v_pk_add_f32 v[208:209], v[148:149], v[150:151]
		v_pk_add_f32 v[210:211], v[152:153], v[154:155]
		v_pk_add_f32 v[212:213], v[156:157], v[158:159]
		v_pk_add_f32 v[214:215], v[170:171], v[172:173]
		v_pk_add_f32 v[216:217], v[174:175], v[176:177]
		v_pk_add_f32 v[218:219], v[178:179], v[180:181]
		v_accvgpr_write_b32 a74, v218
		v_accvgpr_write_b32 a75, v219
		v_pk_add_f32 v[218:219], v[182:183], v[184:185]
		v_pk_add_f32 v[190:191], v[190:191], v[192:193]
		v_pk_add_f32 v[192:193], v[194:195], v[196:197]
		v_pk_add_f32 v[194:195], v[198:199], v[200:201]
		v_pk_add_f32 v[196:197], v[202:203], v[204:205]
		v_pk_add_f32 v[198:199], v[206:207], v[208:209]
		v_pk_add_f32 v[200:201], v[210:211], v[212:213]
		v_pk_add_f32 v[202:203], v[214:215], v[216:217]
		v_accvgpr_read_b32 v204, a74
		v_accvgpr_read_b32 v205, a75
		v_pk_add_f32 v[204:205], v[204:205], v[218:219]
		v_pk_add_f32 v[190:191], v[190:191], v[192:193]
		v_pk_add_f32 v[192:193], v[194:195], v[196:197]
		v_pk_add_f32 v[194:195], v[198:199], v[200:201]
		v_pk_add_f32 v[196:197], v[202:203], v[204:205]
		v_pk_add_f32 v[190:191], v[190:191], v[192:193]
		v_pk_add_f32 v[192:193], v[194:195], v[196:197]
		v_pk_add_f32 v[194:195], v[190:191], v[192:193]
		v_mov_b32_e32 v189, v195
		v_mov_b32_e32 v187, v194
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[190:191], v[186:187], v[188:189]
		v_mov_b32_e32 v186, v191
		v_mov_b32_e32 v187, v191
		v_cvt_pk_bf16_f32 v192, v220, v222
		v_cvt_pk_bf16_f32 v193, v26, v224
		v_permlane32_swap_b32_e32 v186, v187
		v_add_f32_e32 v189, v186, v187
		v_mov_b32_e32 v25, v7
		v_pk_add_f32 v[6:7], v[24:25], v[28:29] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v24, v6
		v_exp_f32_e32 v25, v7
		v_cvt_pk_bf16_f32 v194, v30, v226
		v_mov_b32_e32 v188, v190
		v_mov_b64_e32 v[6:7], v[12:13]
		v_pk_fma_f32 v[12:13], v[6:7], v[24:25], v[188:189]
		v_cvt_pk_bf16_f32 v195, v128, v228
		v_cvt_pk_bf16_f32 v188, v130, v230
		v_cvt_pk_bf16_f32 v189, v132, v232
		v_cvt_pk_bf16_f32 v190, v134, v234
		v_cvt_pk_bf16_f32 v191, v136, v236
		v_cvt_pk_bf16_f32 v196, v138, v238
		v_cvt_pk_bf16_f32 v197, v140, v240
		v_cvt_pk_bf16_f32 v198, v142, v242
		v_cvt_pk_bf16_f32 v199, v160, v244
		v_cvt_pk_bf16_f32 v200, v162, v246
		v_cvt_pk_bf16_f32 v201, v164, v248
		v_cvt_pk_bf16_f32 v202, v166, v250
		v_cvt_pk_bf16_f32 v203, v168, v252
		v_cvt_pk_bf16_f32 v204, v221, v223
		v_pk_mul_f32 v[32:33], v[32:33], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[34:35], v[34:35], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[36:37], v[36:37], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[38:39], v[38:39], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[40:41], v[40:41], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[42:43], v[42:43], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[44:45], v[44:45], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[46:47], v[46:47], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[48:49], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[50:51], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[52:53], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[54:55], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[56:57], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[58:59], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[60:61], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[62:63], v[24:25] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[64:65], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[66:67], v[66:67], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[68:69], v[68:69], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[70:71], v[70:71], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[72:73], v[72:73], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[74:75], v[74:75], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[76:77], v[76:77], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[78:79], v[78:79], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[80:81], v[80:81], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[82:83], v[82:83], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[84:85], v[84:85], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[86:87], v[86:87], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[88:89], v[88:89], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[90:91], v[90:91], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[92:93], v[92:93], v[24:25] op_sel:[0,1]
		v_pk_mul_f32 v[94:95], v[94:95], v[24:25] op_sel:[0,1]
		v_cvt_pk_bf16_f32 v205, v27, v225
		v_cvt_pk_bf16_f32 v206, v31, v227
		v_cvt_pk_bf16_f32 v207, v129, v229
		v_cvt_pk_bf16_f32 v24, v131, v231
		v_cvt_pk_bf16_f32 v25, v133, v233
		v_cvt_pk_bf16_f32 v26, v135, v235
		v_cvt_pk_bf16_f32 v27, v137, v237
		v_cvt_pk_bf16_f32 v128, v139, v239
		v_cvt_pk_bf16_f32 v129, v141, v241
		v_cvt_pk_bf16_f32 v130, v143, v243
		v_cvt_pk_bf16_f32 v131, v161, v245
		v_cvt_pk_bf16_f32 v132, v163, v247
		v_cvt_pk_bf16_f32 v133, v165, v249
		v_cvt_pk_bf16_f32 v134, v167, v251
		v_cvt_pk_bf16_f32 v135, v169, v253
		v_cvt_pk_bf16_f32 v136, v96, v98
		v_cvt_pk_bf16_f32 v137, v100, v102
		v_cvt_pk_bf16_f32 v138, v104, v106
		v_cvt_pk_bf16_f32 v139, v108, v110
		v_cvt_pk_bf16_f32 v140, v112, v114
		v_cvt_pk_bf16_f32 v141, v116, v118
		v_cvt_pk_bf16_f32 v142, v120, v122
		v_cvt_pk_bf16_f32 v143, v124, v126
		v_cvt_pk_bf16_f32 v160, v144, v146
		v_cvt_pk_bf16_f32 v161, v148, v150
		v_cvt_pk_bf16_f32 v162, v152, v154
		v_cvt_pk_bf16_f32 v163, v156, v158
		v_cvt_pk_bf16_f32 v164, v170, v172
		v_cvt_pk_bf16_f32 v165, v174, v176
		v_cvt_pk_bf16_f32 v166, v178, v180
		v_cvt_pk_bf16_f32 v167, v182, v184
		v_cvt_pk_bf16_f32 v208, v97, v99
		v_cvt_pk_bf16_f32 v209, v101, v103
		v_cvt_pk_bf16_f32 v210, v105, v107
		v_cvt_pk_bf16_f32 v211, v109, v111
		v_cvt_pk_bf16_f32 v96, v113, v115
		v_cvt_pk_bf16_f32 v97, v117, v119
		v_cvt_pk_bf16_f32 v98, v121, v123
		v_cvt_pk_bf16_f32 v99, v125, v127
		v_cvt_pk_bf16_f32 v100, v145, v147
		v_cvt_pk_bf16_f32 v101, v149, v151
		v_cvt_pk_bf16_f32 v102, v153, v155
		v_cvt_pk_bf16_f32 v103, v157, v159
		v_cvt_pk_bf16_f32 v104, v171, v173
		v_cvt_pk_bf16_f32 v105, v175, v177
		v_cvt_pk_bf16_f32 v106, v179, v181
		v_cvt_pk_bf16_f32 v107, v183, v185
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[32:47], a[104:107], v[192:195], v[32:47]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[48:63], a[136:139], v[192:195], v[48:63]
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_mfma_f32_32x32x16_bf16 v[32:47], a[108:111], v[188:191], v[32:47]
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_mfma_f32_32x32x16_bf16 v[48:63], a[140:143], v[188:191], v[48:63]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[32:47], a[112:115], v[196:199], v[32:47]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[48:63], a[144:147], v[196:199], v[48:63]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[32:47], a[116:119], v[200:203], v[32:47]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[48:63], a[148:151], v[200:203], v[48:63]
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_mfma_f32_32x32x16_bf16 v[80:95], a[136:139], v[136:139], v[80:95]
		v_permlane32_swap_b32_e32 v160, v162
		v_permlane32_swap_b32_e32 v161, v163
		v_mfma_f32_32x32x16_bf16 v[64:79], a[104:107], v[136:139], v[64:79]
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		v_mfma_f32_32x32x16_bf16 v[80:95], a[140:143], v[140:143], v[80:95]
		v_permlane32_swap_b32_e32 v208, v210
		v_permlane32_swap_b32_e32 v209, v211
		v_mfma_f32_32x32x16_bf16 v[64:79], a[108:111], v[140:143], v[64:79]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[160:163], v[80:95]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[64:79], a[112:115], v[160:163], v[64:79]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[80:95], a[148:151], v[164:167], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[116:119], v[164:167], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[120:123], v[204:207], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[152:155], v[204:207], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], v[208:211], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[120:123], v[208:211], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[124:127], v[24:27], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[156:159], v[24:27], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[124:127], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[128:131], v[128:131], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[160:163], v[128:131], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[160:163], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[128:131], v[100:103], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[132:135], v[132:135], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[164:167], v[132:135], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[164:167], v[104:107], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[132:135], v[104:107], v[64:79]
		v_mov_b32_e32 v4, v28
		v_mov_b32_e32 v7, v29
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_3
.L_attn_fwd_persistent.loop_exit_3:
		s_mul_i32 s21, s21, 0x80
		v_accvgpr_read_b32 v1, a6
		s_nop 0
		v_readfirstlane_b32 s23, v1
		v_accvgpr_read_b32 v1, a15
		s_nop 0
		v_add_u32_e32 v1, s23, v1
		v_add_u32_e32 v1, s1, v1
		v_accvgpr_read_b32 v3, a6
		s_nop 0
		v_readfirstlane_b32 s23, v3
		v_accvgpr_read_b32 v3, a16
		s_nop 0
		v_add_u32_e32 v3, s23, v3
		v_add_u32_e32 v3, s1, v3
		v_xor_b32_e32 v6, 1, v5
		v_accvgpr_write_b32 a15, v6
		v_xor_b32_e32 v6, 2, v5
		v_accvgpr_write_b32 a16, v6
		v_xor_b32_e32 v6, 3, v5
		v_accvgpr_write_b32 a68, v6
		v_xor_b32_e32 v6, 8, v5
		v_accvgpr_write_b32 a70, v6
		v_xor_b32_e32 v6, 9, v5
		v_accvgpr_write_b32 a74, v6
		v_xor_b32_e32 v6, 10, v5
		v_accvgpr_write_b32 a75, v6
		v_xor_b32_e32 v6, 11, v5
		v_accvgpr_write_b32 a76, v6
		v_xor_b32_e32 v6, 16, v5
		v_accvgpr_write_b32 a77, v6
		v_xor_b32_e32 v6, 17, v5
		v_accvgpr_write_b32 a78, v6
		v_xor_b32_e32 v6, 18, v5
		v_accvgpr_write_b32 a79, v6
		v_xor_b32_e32 v6, 19, v5
		v_accvgpr_write_b32 a80, v6
		v_xor_b32_e32 v6, 24, v5
		v_accvgpr_write_b32 a81, v6
		v_xor_b32_e32 v6, 25, v5
		v_accvgpr_write_b32 a82, v6
		v_xor_b32_e32 v6, 26, v5
		v_accvgpr_write_b32 a83, v6
		v_xor_b32_e32 v6, 27, v5
		v_accvgpr_write_b32 a84, v6
		v_xor_b32_e32 v6, 32, v5
		v_accvgpr_write_b32 a85, v6
		v_xor_b32_e32 v6, 33, v5
		v_accvgpr_write_b32 a86, v6
		v_xor_b32_e32 v6, 34, v5
		v_accvgpr_write_b32 a87, v6
		v_xor_b32_e32 v6, 35, v5
		v_accvgpr_write_b32 a88, v6
		v_xor_b32_e32 v6, 40, v5
		v_accvgpr_write_b32 a89, v6
		v_xor_b32_e32 v6, 41, v5
		v_accvgpr_write_b32 a90, v6
		v_xor_b32_e32 v6, 42, v5
		v_accvgpr_write_b32 a91, v6
		v_xor_b32_e32 v6, 43, v5
		v_accvgpr_write_b32 a92, v6
		v_xor_b32_e32 v6, 48, v5
		v_accvgpr_write_b32 a93, v6
		v_xor_b32_e32 v6, 49, v5
		v_accvgpr_write_b32 a94, v6
		v_xor_b32_e32 v6, 50, v5
		v_accvgpr_write_b32 a95, v6
		v_xor_b32_e32 v6, 51, v5
		v_accvgpr_write_b32 a96, v6
		v_xor_b32_e32 v6, 56, v5
		v_accvgpr_write_b32 a97, v6
		v_xor_b32_e32 v6, 57, v5
		v_accvgpr_write_b32 a98, v6
		v_xor_b32_e32 v6, 58, v5
		v_accvgpr_write_b32 a99, v6
		v_xor_b32_e32 v6, 59, v5
		v_accvgpr_write_b32 a100, v6
		v_xor_b32_e32 v6, 64, v5
		v_accvgpr_write_b32 a101, v6
		v_xor_b32_e32 v6, 0x41, v5
		v_accvgpr_write_b32 a102, v6
		v_xor_b32_e32 v6, 0x42, v5
		v_accvgpr_write_b32 a103, v6
		v_xor_b32_e32 v6, 0x43, v5
		v_accvgpr_write_b32 a104, v6
		v_xor_b32_e32 v6, 0x48, v5
		v_accvgpr_write_b32 a105, v6
		v_xor_b32_e32 v6, 0x49, v5
		v_accvgpr_write_b32 a106, v6
		v_xor_b32_e32 v6, 0x4a, v5
		v_accvgpr_write_b32 a107, v6
		v_xor_b32_e32 v6, 0x4b, v5
		v_accvgpr_write_b32 a108, v6
		v_xor_b32_e32 v6, 0x50, v5
		v_accvgpr_write_b32 a109, v6
		v_xor_b32_e32 v6, 0x51, v5
		v_accvgpr_write_b32 a110, v6
		v_xor_b32_e32 v6, 0x52, v5
		v_accvgpr_write_b32 a111, v6
		v_xor_b32_e32 v6, 0x53, v5
		v_accvgpr_write_b32 a112, v6
		v_xor_b32_e32 v6, 0x58, v5
		v_accvgpr_write_b32 a113, v6
		v_xor_b32_e32 v6, 0x59, v5
		v_accvgpr_write_b32 a114, v6
		v_xor_b32_e32 v6, 0x5a, v5
		v_accvgpr_write_b32 a115, v6
		v_xor_b32_e32 v6, 0x5b, v5
		v_accvgpr_write_b32 a116, v6
		v_xor_b32_e32 v6, 0x60, v5
		v_accvgpr_write_b32 a117, v6
		v_xor_b32_e32 v6, 0x61, v5
		v_accvgpr_write_b32 a118, v6
		v_xor_b32_e32 v6, 0x62, v5
		v_accvgpr_write_b32 a119, v6
		v_xor_b32_e32 v6, 0x63, v5
		v_accvgpr_write_b32 a120, v6
		v_xor_b32_e32 v6, 0x68, v5
		v_accvgpr_write_b32 a121, v6
		v_xor_b32_e32 v6, 0x69, v5
		v_accvgpr_write_b32 a122, v6
		v_xor_b32_e32 v6, 0x6a, v5
		v_accvgpr_write_b32 a123, v6
		v_xor_b32_e32 v6, 0x6b, v5
		v_accvgpr_write_b32 a124, v6
		v_xor_b32_e32 v6, 0x70, v5
		v_accvgpr_write_b32 a125, v6
		v_xor_b32_e32 v6, 0x71, v5
		v_accvgpr_write_b32 a126, v6
		v_xor_b32_e32 v6, 0x72, v5
		v_accvgpr_write_b32 a127, v6
		v_xor_b32_e32 v6, 0x73, v5
		v_accvgpr_write_b32 a128, v6
		v_xor_b32_e32 v6, 0x78, v5
		v_accvgpr_write_b32 a129, v6
		v_xor_b32_e32 v6, 0x79, v5
		v_accvgpr_write_b32 a130, v6
		v_xor_b32_e32 v6, 0x7a, v5
		v_accvgpr_write_b32 a131, v6
		v_xor_b32_e32 v6, 0x7b, v5
		v_accvgpr_write_b32 a132, v6
		v_accvgpr_read_b32 v6, a53
		v_accvgpr_read_b32 v8, a65
		v_accvgpr_read_b32 v9, a66
		v_add3_u32 v6, v6, v8, v9
		v_accvgpr_write_b32 a53, v6
		v_accvgpr_read_b32 v6, a67
		v_accvgpr_read_b32 v8, a69
		v_lshl_add_u32 v6, v6, 3, v8
		v_accvgpr_read_b32 v8, a18
		v_lshl_add_u32 v6, v8, 5, v6
		v_accvgpr_read_b32 v8, a59
		v_accvgpr_read_b32 v9, a71
		v_add3_u32 v6, v6, v9, v8
		v_accvgpr_write_b32 a18, v6
		v_mov_b32_e32 v6, 0xff800000
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
		s_cselect_b32 s33, s16, 0
		s_add_i32 s33, s23, s33
		s_ashr_i32 s33, s33, 1
		s_lshl_b32 s33, s33, 1
		s_xor_b32 s33, s33, -1
		s_add_i32 s33, s33, 1
		s_add_i32 s33, s23, s33
		s_add_i32 s23, s23, 1
		s_cmp_lt_i32 s23, 0
		s_cselect_b32 s35, s16, 0
		s_add_i32 s35, s23, s35
		s_ashr_i32 s35, s35, 1
		s_lshl_b32 s35, s35, 1
		s_xor_b32 s35, s35, -1
		s_add_i32 s35, s35, 1
		s_add_i32 s48, s23, s35
		s_mul_i32 s23, 0x4100, s33
		v_accvgpr_read_b32 v8, a53
		v_add_u32_e32 v8, s23, v8
		ds_read_b128 v[24:27], v8
		ds_read_b128 a[136:139], v8 offset:32
		ds_read_b128 a[140:143], v8 offset:64
		ds_read_b128 a[144:147], v8 offset:96
		ds_read_b128 a[148:151], v8 offset:256
		ds_read_b128 a[152:155], v8 offset:288
		ds_read_b128 a[156:159], v8 offset:320
		ds_read_b128 a[160:163], v8 offset:352
		ds_read_b128 a[164:167], v8 offset:128
		ds_read_b128 a[168:171], v8 offset:160
		ds_read_b128 a[172:175], v8 offset:192
		ds_read_b128 a[176:179], v8 offset:224
		ds_read_b128 v[28:31], v8 offset:384
		ds_read_b128 a[180:183], v8 offset:416
		ds_read_b128 a[184:187], v8 offset:448
		ds_read_b128 a[188:191], v8 offset:480
		s_mul_i32 s23, 0x4400, s33
		v_accvgpr_read_b32 v8, a18
		v_add_u32_e32 v8, s23, v8
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
		s_cmp_lt_i32 s1, s18
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_4
		v_accvgpr_read_b32 v8, a19
		v_add_u32_e32 v8, s1, v8
		v_cmp_lt_i32_e64 s[50:51], v8, s20
		v_accvgpr_read_b32 v8, a52
		v_add_u32_e32 v8, s1, v8
		v_cmp_lt_i32_e64 s[52:53], v8, s20
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s23, s15, s41
		s_lshl_b32 s23, s23, 1
		s_add_i32 s33, s42, s23
		v_add_u32_e32 v8, s33, v15
		v_add3_u32 v8, v8, v19, v20
		v_add3_u32 v8, v8, v21, v11
		v_cndmask_b32_e64 v8, v22, v8, s[50:51]
		s_mov_b32 s50, 1
		s_mov_b32 s51, 0
		s_mov_b32 s35, 0
		s_mul_i32 s54, s50, s34
		s_mul_hi_u32 s55, s50, s34
		s_mul_i32 s33, s50, s35
		s_add_i32 s55, s55, s33
		s_mul_i32 s33, s51, s34
		s_add_i32 s55, s55, s33
		s_lshr_b64 s[50:51], s[54:55], 6
		s_mov_b32 s54, 0x410
		s_mov_b32 s55, 0
		s_mul_i32 s56, s54, s50
		s_mul_hi_u32 s57, s54, s50
		s_mul_i32 s33, s54, s51
		s_add_i32 s57, s57, s33
		s_mul_i32 s33, s55, s50
		s_add_i32 s57, s57, s33
		s_cmp_lt_i32 s48, 0
		s_cselect_b32 s49, -1, 0
		s_mov_b32 s54, 0x4100
		s_mov_b32 s55, 0
		s_mul_i32 s58, s54, s48
		s_mul_hi_u32 s59, s54, s48
		s_mul_i32 s33, s54, s49
		s_add_i32 s59, s59, s33
		s_mul_i32 s33, s55, s48
		s_add_i32 s59, s59, s33
		s_add_u32 s54, s56, s58
		s_addc_u32 s55, s57, s59
		s_add_u32 s60, s54, 0
		s_addc_u32 s61, s55, 0
		s_mov_b32 m0, s60
		v_accvgpr_read_b32 v9, a58
		v_add_u32_e32 v9, s1, v9
		buffer_load_dwordx4 v8, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v9, s20
		s_add_i32 s33, s43, s23
		v_add_u32_e32 v8, s33, v15
		v_add3_u32 v8, v8, v19, v20
		v_add3_u32 v8, v8, v21, v11
		v_cndmask_b32_e64 v8, v22, v8, s[54:55]
		s_add_u32 s54, s56, 0x1040
		s_addc_u32 s55, s57, 0
		s_add_u32 s54, s54, s58
		s_addc_u32 s55, s55, s59
		s_add_u32 s60, s54, 0
		s_addc_u32 s61, s55, 0
		s_mov_b32 m0, s60
		v_accvgpr_read_b32 v9, a60
		v_add_u32_e32 v9, s1, v9
		buffer_load_dwordx4 v8, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v9, s20
		s_add_i32 s33, s44, s23
		v_add_u32_e32 v8, s33, v15
		v_add3_u32 v8, v8, v19, v20
		v_add3_u32 v8, v8, v21, v11
		v_cndmask_b32_e64 v8, v22, v8, s[54:55]
		s_add_u32 s54, s56, 0x2080
		s_addc_u32 s55, s57, 0
		s_add_u32 s54, s54, s58
		s_addc_u32 s55, s55, s59
		s_add_u32 s60, s54, 0
		s_addc_u32 s61, s55, 0
		s_mov_b32 m0, s60
		v_accvgpr_read_b32 v9, a61
		v_add_u32_e32 v9, s1, v9
		buffer_load_dwordx4 v8, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v9, s20
		s_add_i32 s23, s36, s23
		v_add_u32_e32 v8, s23, v15
		v_add3_u32 v8, v8, v19, v20
		v_add3_u32 v8, v8, v21, v11
		v_cndmask_b32_e64 v8, v22, v8, s[54:55]
		s_add_u32 s54, s56, 0x30c0
		s_addc_u32 s55, s57, 0
		s_add_u32 s54, s54, s58
		s_addc_u32 s55, s55, s59
		s_add_u32 s56, s54, 0
		s_addc_u32 s57, s55, 0
		s_mov_b32 m0, s56
		v_accvgpr_read_b32 v9, a62
		v_add_u32_e32 v9, s1, v9
		buffer_load_dwordx4 v8, s[24:27], 0 offen lds
		s_mul_i32 s23, s17, s41
		s_lshl_b32 s23, s23, 1
		s_add_i32 s33, s45, s23
		v_add_u32_e32 v8, s33, v2
		v_add3_u32 v8, v8, v14, v17
		v_add3_u32 v8, v8, v18, v11
		v_cndmask_b32_e64 v8, v22, v8, s[52:53]
		s_mov_b32 s52, 0x440
		s_mov_b32 s53, 0
		s_mul_i32 s54, s52, s50
		s_mul_hi_u32 s55, s52, s50
		s_mul_i32 s33, s52, s51
		s_add_i32 s55, s55, s33
		s_mul_i32 s33, s53, s50
		s_add_i32 s55, s55, s33
		s_add_u32 s50, s54, 0x81f0
		s_addc_u32 s51, s55, 0
		s_mov_b32 s52, 0x4400
		s_mov_b32 s53, 0
		s_mul_i32 s56, s52, s48
		s_mul_hi_u32 s57, s52, s48
		s_mul_i32 s33, s52, s49
		s_add_i32 s57, s57, s33
		s_mul_i32 s33, s53, s48
		s_add_i32 s57, s57, s33
		s_add_u32 s48, s50, s56
		s_addc_u32 s49, s51, s57
		s_add_u32 s50, s48, 0
		s_addc_u32 s51, s49, 0
		s_mov_b32 m0, s50
		v_accvgpr_read_b32 v10, a63
		v_add_u32_e32 v10, s1, v10
		buffer_load_dwordx4 v8, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[48:49], v9, s20
		s_add_i32 s33, s46, s23
		v_add_u32_e32 v8, s33, v2
		v_add3_u32 v8, v8, v14, v17
		v_add3_u32 v8, v8, v18, v11
		v_cndmask_b32_e64 v8, v22, v8, s[48:49]
		s_add_u32 s48, s54, 0x92f0
		s_addc_u32 s49, s55, 0
		s_add_u32 s48, s48, s56
		s_addc_u32 s49, s49, s57
		s_add_u32 s50, s48, 0
		s_addc_u32 s51, s49, 0
		s_mov_b32 m0, s50
		v_accvgpr_read_b32 v9, a64
		v_add_u32_e32 v9, s1, v9
		buffer_load_dwordx4 v8, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[48:49], v10, s20
		s_add_i32 s33, s47, s23
		v_add_u32_e32 v8, s33, v2
		v_add3_u32 v8, v8, v14, v17
		v_add3_u32 v8, v8, v18, v11
		s_add_u32 s50, s54, 0xa3f0
		s_addc_u32 s51, s55, 0
		s_add_u32 s50, s50, s56
		s_addc_u32 s51, s51, s57
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		v_cndmask_b32_e64 v8, v22, v8, s[48:49]
		buffer_load_dwordx4 v8, s[28:31], 0 offen lds
		s_add_i32 s23, s32, s23
		v_add_u32_e32 v8, s23, v2
		v_add3_u32 v8, v8, v14, v17
		v_cmp_lt_i32_e64 vcc, v9, s20
		v_add3_u32 v8, v8, v18, v11
		s_add_u32 s48, s54, 0xb4f0
		s_addc_u32 s49, s55, 0
		v_cndmask_b32_e32 v8, v22, v8, vcc
		s_add_u32 s48, s48, s56
		s_addc_u32 s49, s49, s57
		s_add_u32 s50, s48, 0
		s_addc_u32 s51, s49, 0
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v8, s[28:31], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_4
.L_attn_fwd_persistent.if_else_4:
.L_attn_fwd_persistent.if_end_4:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[96:111], v[24:27], a[20:23], 0
		s_cmp_lt_i32 s1, s21
		v_mfma_f32_32x32x16_bf16 v[112:127], a[148:151], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[128:143], a[164:167], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[28:31], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[176:191], v[24:27], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[192:207], a[148:151], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[208:223], a[164:167], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[96:111], a[136:139], a[24:27], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[152:155], a[24:27], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[168:171], a[24:27], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[180:183], a[24:27], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[40:43], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[136:139], a[40:43], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[152:155], a[40:43], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[168:171], a[40:43], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[140:143], a[28:31], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[156:159], a[28:31], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[172:175], a[28:31], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[184:187], a[28:31], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[184:187], a[44:47], v[160:175]
		v_add_u32_e32 v8, s41, v5
		v_mfma_f32_32x32x16_bf16 v[176:191], a[140:143], a[44:47], v[176:191]
		v_accvgpr_read_b32 v9, a15
		v_add_u32_e32 v9, s41, v9
		v_mfma_f32_32x32x16_bf16 v[192:207], a[156:159], a[44:47], v[192:207]
		v_accvgpr_read_b32 v10, a16
		v_add_u32_e32 v10, s41, v10
		v_mfma_f32_32x32x16_bf16 v[208:223], a[172:175], a[44:47], v[208:223]
		v_accvgpr_read_b32 v16, a68
		v_add_u32_e32 v16, s41, v16
		v_mfma_f32_32x32x16_bf16 v[96:111], a[144:147], a[32:35], v[96:111]
		v_cmp_ge_i32_e64 vcc, v1, v16
		v_mfma_f32_32x32x16_bf16 v[112:127], a[160:163], a[32:35], v[112:127]
		v_accvgpr_read_b32 v23, a75
		v_add_u32_e32 v23, s41, v23
		v_mfma_f32_32x32x16_bf16 v[128:143], a[176:179], a[32:35], v[128:143]
		v_accvgpr_read_b32 v24, a76
		v_add_u32_e32 v24, s41, v24
		v_mfma_f32_32x32x16_bf16 v[144:159], a[188:191], a[32:35], v[144:159]
		v_accvgpr_read_b32 v25, a79
		v_add_u32_e32 v25, s41, v25
		v_mfma_f32_32x32x16_bf16 v[160:175], a[188:191], a[48:51], v[160:175]
		v_accvgpr_read_b32 v26, a80
		v_add_u32_e32 v26, s41, v26
		v_mfma_f32_32x32x16_bf16 v[176:191], a[144:147], a[48:51], v[176:191]
		v_accvgpr_read_b32 v27, a83
		v_add_u32_e32 v27, s41, v27
		v_mfma_f32_32x32x16_bf16 v[192:207], a[160:163], a[48:51], v[192:207]
		v_cndmask_b32_e32 v29, v6, v99, vcc
		v_mfma_f32_32x32x16_bf16 v[208:223], a[176:179], a[48:51], v[208:223]
		v_accvgpr_read_b32 v28, a84
		v_add_u32_e32 v30, s41, v28
		v_accvgpr_read_b32 v28, a87
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a59, v28
		v_accvgpr_read_b32 v28, a88
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a65, v28
		v_accvgpr_read_b32 v28, a91
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a66, v28
		v_accvgpr_read_b32 v28, a92
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a67, v28
		v_accvgpr_read_b32 v28, a95
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a69, v28
		v_accvgpr_read_b32 v28, a96
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a71, v28
		v_accvgpr_read_b32 v28, a99
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a133, v28
		v_accvgpr_read_b32 v28, a100
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a134, v28
		v_accvgpr_read_b32 v28, a103
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a135, v28
		v_accvgpr_read_b32 v28, a104
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a136, v28
		v_accvgpr_read_b32 v28, a107
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a137, v28
		v_accvgpr_read_b32 v28, a108
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a138, v28
		v_accvgpr_read_b32 v28, a111
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a139, v28
		v_accvgpr_read_b32 v28, a112
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a140, v28
		v_accvgpr_read_b32 v28, a115
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a141, v28
		v_accvgpr_read_b32 v28, a116
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a142, v28
		v_accvgpr_read_b32 v28, a119
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a143, v28
		v_accvgpr_read_b32 v28, a120
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a144, v28
		v_accvgpr_read_b32 v28, a123
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a145, v28
		v_accvgpr_read_b32 v28, a124
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a146, v28
		v_accvgpr_read_b32 v28, a127
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a147, v28
		v_accvgpr_read_b32 v28, a128
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a148, v28
		v_accvgpr_read_b32 v28, a131
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a149, v28
		v_accvgpr_read_b32 v28, a132
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a150, v28
		v_cmp_ge_i32_e64 s[48:49], v1, v8
		v_cmp_ge_i32_e64 s[50:51], v1, v9
		v_cmp_ge_i32_e64 s[52:53], v1, v10
		v_accvgpr_read_b32 v28, a70
		v_add_u32_e32 v31, s41, v28
		v_accvgpr_read_b32 v28, a74
		v_add_u32_e32 v99, s41, v28
		v_cmp_ge_i32_e64 s[54:55], v1, v31
		v_cmp_ge_i32_e64 s[56:57], v1, v99
		v_cmp_ge_i32_e64 s[58:59], v1, v23
		v_cmp_ge_i32_e64 vcc, v1, v24
		v_accvgpr_read_b32 v28, a77
		v_add_u32_e32 v224, s41, v28
		v_accvgpr_read_b32 v28, a78
		v_add_u32_e32 v225, s41, v28
		v_cndmask_b32_e32 v227, v6, v103, vcc
		v_cmp_ge_i32_e64 s[60:61], v1, v224
		v_cmp_ge_i32_e64 s[62:63], v1, v225
		v_cmp_ge_i32_e64 s[64:65], v1, v25
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v28, a81
		v_add_u32_e32 v103, s41, v28
		v_accvgpr_read_b32 v28, a82
		v_add_u32_e32 v228, s41, v28
		v_cndmask_b32_e32 v231, v6, v107, vcc
		v_cmp_ge_i32_e64 s[66:67], v1, v103
		v_cmp_ge_i32_e64 s[68:69], v1, v228
		v_cmp_ge_i32_e64 s[70:71], v1, v27
		v_cmp_ge_i32_e64 vcc, v1, v30
		v_accvgpr_read_b32 v28, a85
		v_add_u32_e32 v107, s41, v28
		v_accvgpr_read_b32 v28, a86
		v_add_u32_e32 v229, s41, v28
		v_cndmask_b32_e32 v233, v6, v111, vcc
		v_cmp_ge_i32_e64 s[72:73], v1, v107
		v_cmp_ge_i32_e64 s[74:75], v1, v229
		v_accvgpr_read_b32 v28, a59
		v_cmp_ge_i32_e64 s[76:77], v1, v28
		v_accvgpr_read_b32 v28, a65
		v_cmp_ge_i32_e64 vcc, v1, v28
		v_accvgpr_read_b32 v28, a89
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a151, v28
		v_accvgpr_read_b32 v28, a90
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a152, v28
		v_cndmask_b32_e32 v235, v6, v115, vcc
		v_accvgpr_read_b32 v28, a151
		v_cmp_ge_i32_e64 s[78:79], v1, v28
		v_accvgpr_read_b32 v28, a152
		v_cmp_ge_i32_e64 s[80:81], v1, v28
		v_accvgpr_read_b32 v28, a66
		v_cmp_ge_i32_e64 s[82:83], v1, v28
		v_accvgpr_read_b32 v28, a67
		v_cmp_ge_i32_e64 vcc, v1, v28
		v_accvgpr_read_b32 v28, a93
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a153, v28
		v_accvgpr_read_b32 v28, a94
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a154, v28
		v_cndmask_b32_e32 v237, v6, v119, vcc
		v_accvgpr_read_b32 v28, a153
		v_cmp_ge_i32_e64 s[84:85], v1, v28
		v_accvgpr_read_b32 v28, a154
		v_cmp_ge_i32_e64 s[86:87], v1, v28
		v_accvgpr_read_b32 v28, a71
		v_cmp_ge_i32_e64 vcc, v1, v28
		v_accvgpr_read_b32 v28, a97
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a155, v28
		v_accvgpr_read_b32 v28, a98
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a156, v28
		v_cndmask_b32_e32 v239, v6, v123, vcc
		v_accvgpr_read_b32 v28, a134
		v_cmp_ge_i32_e64 vcc, v1, v28
		v_accvgpr_read_b32 v28, a101
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a157, v28
		v_accvgpr_read_b32 v28, a102
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a158, v28
		v_cndmask_b32_e32 v241, v6, v127, vcc
		v_accvgpr_read_b32 v28, a136
		v_cmp_ge_i32_e64 vcc, v1, v28
		v_accvgpr_read_b32 v28, a105
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a159, v28
		v_accvgpr_read_b32 v28, a106
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a160, v28
		v_cndmask_b32_e32 v243, v6, v131, vcc
		v_accvgpr_read_b32 v28, a138
		v_cmp_ge_i32_e64 vcc, v1, v28
		v_accvgpr_read_b32 v28, a109
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a161, v28
		v_accvgpr_read_b32 v28, a110
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a162, v28
		v_cndmask_b32_e32 v245, v6, v135, vcc
		v_accvgpr_read_b32 v28, a140
		v_cmp_ge_i32_e64 vcc, v1, v28
		v_accvgpr_read_b32 v28, a113
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a163, v28
		v_accvgpr_read_b32 v28, a114
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_write_b32 a164, v28
		v_cndmask_b32_e32 v247, v6, v139, vcc
		v_accvgpr_read_b32 v28, a142
		v_cmp_ge_i32_e64 vcc, v1, v28
		v_accvgpr_read_b32 v28, a69
		v_cmp_ge_i32_e64 s[88:89], v1, v28
		v_cndmask_b32_e64 v248, v6, v96, s[48:49]
		v_accvgpr_read_b32 v28, a155
		v_cmp_ge_i32_e64 s[48:49], v1, v28
		s_nop 1
		v_mov_b32_e32 v250, s48
		v_mov_b32_e32 v251, s49
		v_accvgpr_write_b32 a166, v250
		v_accvgpr_write_b32 a167, v251
		v_accvgpr_read_b32 v28, a156
		v_cmp_ge_i32_e64 s[48:49], v1, v28
		s_nop 1
		v_mov_b32_e32 v250, s48
		v_mov_b32_e32 v251, s49
		v_accvgpr_write_b32 a168, v250
		v_accvgpr_write_b32 a169, v251
		v_accvgpr_read_b32 v28, a133
		v_cmp_ge_i32_e64 s[48:49], v1, v28
		s_nop 1
		v_mov_b32_e32 v250, s48
		v_mov_b32_e32 v251, s49
		v_accvgpr_write_b32 a170, v250
		v_accvgpr_write_b32 a171, v251
		v_accvgpr_read_b32 v28, a157
		v_cmp_ge_i32_e64 s[48:49], v1, v28
		s_nop 1
		v_mov_b32_e32 v250, s48
		v_mov_b32_e32 v251, s49
		v_accvgpr_write_b32 a172, v250
		v_accvgpr_write_b32 a173, v251
		v_accvgpr_read_b32 v28, a158
		v_cmp_ge_i32_e64 s[48:49], v1, v28
		s_nop 1
		v_mov_b32_e32 v250, s48
		v_mov_b32_e32 v251, s49
		v_accvgpr_write_b32 a174, v250
		v_accvgpr_write_b32 a175, v251
		v_accvgpr_read_b32 v28, a135
		v_cmp_ge_i32_e64 s[48:49], v1, v28
		s_nop 1
		v_mov_b32_e32 v250, s48
		v_mov_b32_e32 v251, s49
		v_accvgpr_write_b32 a176, v250
		v_accvgpr_write_b32 a177, v251
		v_accvgpr_read_b32 v28, a159
		v_cmp_ge_i32_e64 s[48:49], v1, v28
		s_nop 1
		v_mov_b32_e32 v250, s48
		v_mov_b32_e32 v251, s49
		v_accvgpr_write_b32 a178, v250
		v_accvgpr_write_b32 a179, v251
		v_accvgpr_read_b32 v28, a160
		v_cmp_ge_i32_e64 s[48:49], v1, v28
		s_nop 1
		v_mov_b32_e32 v250, s48
		v_mov_b32_e32 v251, s49
		v_accvgpr_write_b32 a180, v250
		v_accvgpr_write_b32 a181, v251
		v_accvgpr_read_b32 v28, a137
		v_cmp_ge_i32_e64 s[48:49], v1, v28
		s_nop 1
		v_mov_b32_e32 v250, s48
		v_mov_b32_e32 v251, s49
		v_accvgpr_write_b32 a182, v250
		v_accvgpr_write_b32 a183, v251
		v_accvgpr_read_b32 v28, a161
		v_cmp_ge_i32_e64 s[48:49], v1, v28
		s_nop 1
		v_mov_b32_e32 v250, s48
		v_mov_b32_e32 v251, s49
		v_accvgpr_write_b32 a184, v250
		v_accvgpr_write_b32 a185, v251
		v_accvgpr_read_b32 v28, a162
		v_cmp_ge_i32_e64 s[48:49], v1, v28
		s_nop 1
		v_mov_b32_e32 v250, s48
		v_mov_b32_e32 v251, s49
		v_accvgpr_write_b32 a186, v250
		v_accvgpr_write_b32 a187, v251
		v_accvgpr_read_b32 v28, a139
		v_cmp_ge_i32_e64 s[48:49], v1, v28
		s_nop 1
		v_mov_b32_e32 v250, s48
		v_mov_b32_e32 v251, s49
		v_accvgpr_write_b32 a188, v250
		v_accvgpr_write_b32 a189, v251
		v_accvgpr_read_b32 v28, a163
		v_cmp_ge_i32_e64 s[48:49], v1, v28
		v_accvgpr_read_b32 v28, a164
		v_cmp_ge_i32_e64 s[90:91], v1, v28
		v_accvgpr_read_b32 v28, a141
		v_cmp_ge_i32_e64 s[92:93], v1, v28
		v_cndmask_b32_e32 v251, v6, v143, vcc
		v_cndmask_b32_e64 v253, v6, v141, s[90:91]
		v_cndmask_b32_e64 v250, v6, v142, s[92:93]
		v_accvgpr_read_b32 v28, a117
		v_add_u32_e32 v96, s41, v28
		v_accvgpr_read_b32 v28, a118
		v_add_u32_e32 v111, s41, v28
		v_cmp_ge_i32_e64 s[90:91], v1, v96
		v_cmp_ge_i32_e64 s[92:93], v1, v111
		v_accvgpr_read_b32 v28, a143
		v_cmp_ge_i32_e64 s[94:95], v1, v28
		v_cndmask_b32_e64 v142, v6, v144, s[90:91]
		v_cndmask_b32_e64 v143, v6, v145, s[92:93]
		v_cndmask_b32_e64 v144, v6, v146, s[94:95]
		v_accvgpr_read_b32 v28, a144
		v_cmp_ge_i32_e64 vcc, v1, v28
		v_accvgpr_read_b32 v28, a121
		v_add_u32_e32 v115, s41, v28
		v_accvgpr_read_b32 v28, a122
		v_add_u32_e32 v119, s41, v28
		v_cndmask_b32_e32 v145, v6, v147, vcc
		v_cmp_ge_i32_e64 s[90:91], v1, v115
		v_cmp_ge_i32_e64 s[92:93], v1, v119
		v_accvgpr_read_b32 v28, a145
		v_cmp_ge_i32_e64 s[94:95], v1, v28
		v_cndmask_b32_e64 v146, v6, v148, s[90:91]
		v_cndmask_b32_e64 v147, v6, v149, s[92:93]
		v_cndmask_b32_e64 v148, v6, v150, s[94:95]
		v_accvgpr_read_b32 v28, a146
		v_cmp_ge_i32_e64 vcc, v1, v28
		v_accvgpr_read_b32 v28, a125
		v_add_u32_e32 v123, s41, v28
		v_accvgpr_read_b32 v28, a126
		v_add_u32_e32 v127, s41, v28
		v_cndmask_b32_e32 v149, v6, v151, vcc
		v_cmp_ge_i32_e64 s[90:91], v1, v123
		v_cmp_ge_i32_e64 s[92:93], v1, v127
		v_accvgpr_read_b32 v28, a147
		v_cmp_ge_i32_e64 s[94:95], v1, v28
		v_cndmask_b32_e64 v150, v6, v152, s[90:91]
		v_cndmask_b32_e64 v151, v6, v153, s[92:93]
		v_cndmask_b32_e64 v152, v6, v154, s[94:95]
		v_accvgpr_read_b32 v28, a148
		v_cmp_ge_i32_e64 vcc, v1, v28
		v_accvgpr_read_b32 v28, a129
		v_add_u32_e32 v131, s41, v28
		v_accvgpr_read_b32 v28, a130
		v_add_u32_e32 v135, s41, v28
		v_cndmask_b32_e32 v153, v6, v155, vcc
		v_cmp_ge_i32_e64 s[90:91], v1, v131
		v_cmp_ge_i32_e64 s[92:93], v1, v135
		v_accvgpr_read_b32 v28, a149
		v_cmp_ge_i32_e64 s[94:95], v1, v28
		v_cndmask_b32_e64 v154, v6, v156, s[90:91]
		v_cndmask_b32_e64 v155, v6, v157, s[92:93]
		v_cndmask_b32_e64 v156, v6, v158, s[94:95]
		v_cndmask_b32_e64 v249, v6, v97, s[50:51]
		v_accvgpr_read_b32 v28, a150
		v_cmp_ge_i32_e64 vcc, v1, v28
		v_max3_f32 v28, v142, v143, v144
		v_accvgpr_write_b32 a165, v28
		v_max3_f32 v97, v146, v147, v148
		v_cndmask_b32_e32 v157, v6, v159, vcc
		v_cmp_ge_i32_e64 s[50:51], v3, v8
		v_cmp_ge_i32_e64 s[90:91], v3, v9
		v_cmp_ge_i32_e64 s[92:93], v3, v10
		v_max3_f32 v8, v150, v151, v152
		v_accvgpr_write_b32 a190, v8
		v_max3_f32 v8, v154, v155, v156
		v_accvgpr_write_b32 a191, v8
		v_cndmask_b32_e64 v8, v6, v178, s[92:93]
		v_cmp_ge_i32_e64 vcc, v3, v16
		v_cndmask_b32_e64 v28, v6, v98, s[52:53]
		v_mov_b32_e32 v10, 0xff800000
		v_cndmask_b32_e64 v158, v10, v100, s[54:55]
		v_cndmask_b32_e32 v9, v10, v179, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v31
		v_cmp_ge_i32_e64 s[54:55], v3, v99
		v_cmp_ge_i32_e64 s[92:93], v3, v23
		v_cndmask_b32_e64 v98, v10, v180, s[52:53]
		v_cndmask_b32_e64 v99, v10, v181, s[54:55]
		v_cndmask_b32_e64 v178, v10, v182, s[92:93]
		v_cmp_ge_i32_e64 vcc, v3, v24
		v_cndmask_b32_e64 v159, v10, v101, s[56:57]
		v_cndmask_b32_e64 v226, v10, v102, s[58:59]
		v_cndmask_b32_e64 v100, v10, v104, s[60:61]
		v_cndmask_b32_e32 v179, v10, v183, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v224
		v_cmp_ge_i32_e64 s[54:55], v3, v225
		v_cmp_ge_i32_e64 s[56:57], v3, v25
		v_cndmask_b32_e64 v24, v10, v184, s[52:53]
		v_cndmask_b32_e64 v25, v10, v185, s[54:55]
		v_cndmask_b32_e64 v180, v10, v186, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v26
		v_cndmask_b32_e64 v101, v10, v105, s[62:63]
		v_max3_f32 v16, v248, v249, v28
		v_cndmask_b32_e32 v181, v10, v187, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v103
		v_cmp_ge_i32_e64 s[54:55], v3, v228
		v_cmp_ge_i32_e64 s[56:57], v3, v27
		v_cndmask_b32_e64 v26, v10, v188, s[52:53]
		v_cndmask_b32_e64 v27, v10, v189, s[54:55]
		v_cndmask_b32_e64 v102, v10, v190, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v30
		v_cndmask_b32_e64 v230, v10, v106, s[64:65]
		v_cndmask_b32_e64 v30, v10, v108, s[66:67]
		v_cndmask_b32_e32 v103, v10, v191, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v107
		v_cmp_ge_i32_e64 s[54:55], v3, v229
		v_accvgpr_read_b32 v23, a59
		v_cmp_ge_i32_e64 s[56:57], v3, v23
		v_cndmask_b32_e64 v104, v10, v192, s[52:53]
		v_cndmask_b32_e64 v105, v10, v193, s[54:55]
		v_cndmask_b32_e64 v106, v10, v194, s[56:57]
		v_accvgpr_read_b32 v23, a65
		v_cmp_ge_i32_e64 vcc, v3, v23
		v_cndmask_b32_e64 v31, v10, v109, s[68:69]
		v_cndmask_b32_e64 v232, v10, v110, s[70:71]
		v_cndmask_b32_e64 v108, v10, v112, s[72:73]
		v_cndmask_b32_e32 v107, v10, v195, vcc
		v_accvgpr_read_b32 v23, a151
		v_cmp_ge_i32_e64 s[52:53], v3, v23
		v_accvgpr_read_b32 v23, a152
		v_cmp_ge_i32_e64 s[54:55], v3, v23
		v_accvgpr_read_b32 v23, a66
		v_cmp_ge_i32_e64 s[56:57], v3, v23
		v_cndmask_b32_e64 v182, v10, v196, s[52:53]
		v_cndmask_b32_e64 v183, v10, v197, s[54:55]
		v_cndmask_b32_e64 v184, v10, v198, s[56:57]
		v_accvgpr_read_b32 v23, a67
		v_cmp_ge_i32_e64 vcc, v3, v23
		v_cndmask_b32_e64 v109, v10, v113, s[74:75]
		v_max3_f32 v23, v158, v159, v226
		v_cndmask_b32_e32 v185, v10, v199, vcc
		v_accvgpr_read_b32 v110, a153
		v_cmp_ge_i32_e64 s[52:53], v3, v110
		v_accvgpr_read_b32 v110, a154
		v_cmp_ge_i32_e64 s[54:55], v3, v110
		v_accvgpr_read_b32 v110, a69
		v_cmp_ge_i32_e64 s[56:57], v3, v110
		v_cndmask_b32_e64 v112, v10, v200, s[52:53]
		v_cndmask_b32_e64 v113, v10, v201, s[54:55]
		v_cndmask_b32_e64 v186, v10, v202, s[56:57]
		v_accvgpr_read_b32 v110, a71
		v_cmp_ge_i32_e64 vcc, v3, v110
		v_cndmask_b32_e64 v234, v10, v114, s[76:77]
		v_cndmask_b32_e64 v188, v10, v116, s[78:79]
		v_cndmask_b32_e32 v187, v10, v203, vcc
		v_accvgpr_read_b32 v110, a134
		v_cmp_ge_i32_e64 vcc, v3, v110
		v_accvgpr_read_b32 v110, a155
		v_cmp_ge_i32_e64 s[52:53], v3, v110
		v_accvgpr_read_b32 v110, a156
		v_cmp_ge_i32_e64 s[54:55], v3, v110
		v_accvgpr_read_b32 v110, a133
		v_cmp_ge_i32_e64 s[56:57], v3, v110
		v_cndmask_b32_e64 v190, v10, v204, s[52:53]
		v_cndmask_b32_e64 v191, v10, v205, s[54:55]
		v_cndmask_b32_e64 v192, v10, v206, s[56:57]
		v_cndmask_b32_e64 v189, v10, v117, s[80:81]
		v_cndmask_b32_e64 v236, v10, v118, s[82:83]
		v_cndmask_b32_e32 v193, v10, v207, vcc
		v_accvgpr_read_b32 v110, a157
		v_cmp_ge_i32_e64 s[52:53], v3, v110
		v_accvgpr_read_b32 v110, a158
		v_cmp_ge_i32_e64 s[54:55], v3, v110
		v_accvgpr_read_b32 v110, a136
		v_cmp_ge_i32_e64 vcc, v3, v110
		v_accvgpr_read_b32 v110, a135
		v_cmp_ge_i32_e64 s[56:57], v3, v110
		v_cndmask_b32_e64 v116, v10, v208, s[52:53]
		v_cndmask_b32_e64 v117, v10, v209, s[54:55]
		v_cndmask_b32_e64 v194, v10, v210, s[56:57]
		v_cndmask_b32_e64 v196, v10, v120, s[84:85]
		v_cndmask_b32_e64 v197, v10, v121, s[86:87]
		v_cndmask_b32_e32 v195, v10, v211, vcc
		v_accvgpr_read_b32 v110, a159
		v_cmp_ge_i32_e64 s[52:53], v3, v110
		v_accvgpr_read_b32 v110, a160
		v_cmp_ge_i32_e64 s[54:55], v3, v110
		v_accvgpr_read_b32 v110, a137
		v_cmp_ge_i32_e64 s[56:57], v3, v110
		v_cndmask_b32_e64 v120, v10, v212, s[52:53]
		v_cndmask_b32_e64 v121, v10, v213, s[54:55]
		v_cndmask_b32_e64 v198, v10, v214, s[56:57]
		v_accvgpr_read_b32 v110, a138
		v_cmp_ge_i32_e64 vcc, v3, v110
		v_cndmask_b32_e64 v238, v10, v122, s[88:89]
		v_accvgpr_read_b32 v110, a166
		s_nop 0
		v_readfirstlane_b32 s52, v110
		v_accvgpr_read_b32 v110, a167
		s_nop 0
		v_readfirstlane_b32 s53, v110
		s_nop 1
		v_cndmask_b32_e64 v200, v10, v124, s[52:53]
		v_cndmask_b32_e32 v199, v10, v215, vcc
		v_accvgpr_read_b32 v110, a161
		v_cmp_ge_i32_e64 s[52:53], v3, v110
		v_accvgpr_read_b32 v110, a162
		v_cmp_ge_i32_e64 s[54:55], v3, v110
		v_accvgpr_read_b32 v110, a139
		v_cmp_ge_i32_e64 s[56:57], v3, v110
		v_cndmask_b32_e64 v202, v10, v216, s[52:53]
		v_cndmask_b32_e64 v203, v10, v217, s[54:55]
		v_cndmask_b32_e64 v204, v10, v218, s[56:57]
		v_accvgpr_read_b32 v110, a140
		v_cmp_ge_i32_e64 vcc, v3, v110
		v_accvgpr_read_b32 v110, a168
		s_nop 0
		v_readfirstlane_b32 s52, v110
		v_accvgpr_read_b32 v110, a169
		s_nop 0
		v_readfirstlane_b32 s53, v110
		s_nop 1
		v_cndmask_b32_e64 v201, v10, v125, s[52:53]
		v_accvgpr_read_b32 v110, a170
		s_nop 0
		v_readfirstlane_b32 s52, v110
		v_accvgpr_read_b32 v110, a171
		s_nop 0
		v_readfirstlane_b32 s53, v110
		s_nop 1
		v_cndmask_b32_e64 v240, v10, v126, s[52:53]
		v_cndmask_b32_e32 v205, v10, v219, vcc
		v_accvgpr_read_b32 v110, a163
		v_cmp_ge_i32_e64 s[52:53], v3, v110
		v_accvgpr_read_b32 v110, a164
		v_cmp_ge_i32_e64 s[54:55], v3, v110
		v_accvgpr_read_b32 v110, a141
		v_cmp_ge_i32_e64 s[56:57], v3, v110
		v_cndmask_b32_e64 v124, v10, v220, s[52:53]
		v_cndmask_b32_e64 v125, v10, v221, s[54:55]
		v_cndmask_b32_e64 v206, v10, v222, s[56:57]
		v_accvgpr_read_b32 v110, a142
		v_cmp_ge_i32_e64 vcc, v3, v110
		v_accvgpr_read_b32 v110, a172
		s_nop 0
		v_readfirstlane_b32 s52, v110
		v_accvgpr_read_b32 v110, a173
		s_nop 0
		v_readfirstlane_b32 s53, v110
		s_nop 1
		v_cndmask_b32_e64 v208, v10, v128, s[52:53]
		v_accvgpr_read_b32 v110, a174
		s_nop 0
		v_readfirstlane_b32 s52, v110
		v_accvgpr_read_b32 v110, a175
		s_nop 0
		v_readfirstlane_b32 s53, v110
		s_nop 1
		v_cndmask_b32_e64 v209, v10, v129, s[52:53]
		v_cndmask_b32_e32 v207, v10, v223, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v96
		v_cmp_ge_i32_e64 s[54:55], v3, v111
		v_accvgpr_read_b32 v96, a143
		v_cmp_ge_i32_e64 s[56:57], v3, v96
		v_cndmask_b32_e64 v110, v10, v160, s[52:53]
		v_cndmask_b32_e64 v111, v10, v161, s[54:55]
		v_cndmask_b32_e64 v128, v10, v162, s[56:57]
		v_accvgpr_read_b32 v96, a144
		v_cmp_ge_i32_e64 vcc, v3, v96
		v_accvgpr_read_b32 v96, a176
		s_nop 0
		v_readfirstlane_b32 s52, v96
		v_accvgpr_read_b32 v96, a177
		s_nop 0
		v_readfirstlane_b32 s53, v96
		s_nop 1
		v_cndmask_b32_e64 v242, v10, v130, s[52:53]
		v_accvgpr_read_b32 v96, a178
		s_nop 0
		v_readfirstlane_b32 s52, v96
		v_accvgpr_read_b32 v96, a179
		s_nop 0
		v_readfirstlane_b32 s53, v96
		s_nop 1
		v_cndmask_b32_e64 v160, v10, v132, s[52:53]
		v_cndmask_b32_e32 v129, v10, v163, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v115
		v_cmp_ge_i32_e64 s[54:55], v3, v119
		v_accvgpr_read_b32 v96, a145
		v_cmp_ge_i32_e64 s[56:57], v3, v96
		v_cndmask_b32_e64 v114, v10, v164, s[52:53]
		v_cndmask_b32_e64 v115, v10, v165, s[54:55]
		v_cndmask_b32_e64 v118, v10, v166, s[56:57]
		v_accvgpr_read_b32 v96, a146
		v_cmp_ge_i32_e64 vcc, v3, v96
		v_accvgpr_read_b32 v96, a180
		s_nop 0
		v_readfirstlane_b32 s52, v96
		v_accvgpr_read_b32 v96, a181
		s_nop 0
		v_readfirstlane_b32 s53, v96
		s_nop 1
		v_cndmask_b32_e64 v161, v10, v133, s[52:53]
		v_accvgpr_read_b32 v96, a182
		s_nop 0
		v_readfirstlane_b32 s52, v96
		v_accvgpr_read_b32 v96, a183
		s_nop 0
		v_readfirstlane_b32 s53, v96
		s_nop 1
		v_cndmask_b32_e64 v244, v10, v134, s[52:53]
		v_cndmask_b32_e32 v119, v10, v167, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v123
		v_cmp_ge_i32_e64 s[54:55], v3, v127
		v_accvgpr_read_b32 v96, a147
		v_cmp_ge_i32_e64 s[56:57], v3, v96
		v_cndmask_b32_e64 v122, v10, v168, s[52:53]
		v_cndmask_b32_e64 v123, v10, v169, s[54:55]
		v_cndmask_b32_e64 v126, v10, v170, s[56:57]
		v_accvgpr_read_b32 v96, a148
		v_cmp_ge_i32_e64 vcc, v3, v96
		v_accvgpr_read_b32 v96, a184
		s_nop 0
		v_readfirstlane_b32 s52, v96
		v_accvgpr_read_b32 v96, a185
		s_nop 0
		v_readfirstlane_b32 s53, v96
		s_nop 1
		v_cndmask_b32_e64 v132, v10, v136, s[52:53]
		v_accvgpr_read_b32 v96, a186
		s_nop 0
		v_readfirstlane_b32 s52, v96
		v_accvgpr_read_b32 v96, a187
		s_nop 0
		v_readfirstlane_b32 s53, v96
		s_nop 1
		v_cndmask_b32_e64 v133, v10, v137, s[52:53]
		v_cndmask_b32_e32 v127, v10, v171, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v131
		v_cmp_ge_i32_e64 s[54:55], v3, v135
		v_accvgpr_read_b32 v96, a149
		v_cmp_ge_i32_e64 s[56:57], v3, v96
		v_cndmask_b32_e64 v130, v10, v172, s[52:53]
		v_cndmask_b32_e64 v131, v10, v173, s[54:55]
		v_cndmask_b32_e64 v134, v10, v174, s[56:57]
		v_accvgpr_read_b32 v96, a150
		v_cmp_ge_i32_e64 vcc, v3, v96
		v_accvgpr_read_b32 v96, a188
		s_nop 0
		v_readfirstlane_b32 s52, v96
		v_accvgpr_read_b32 v96, a189
		s_nop 0
		v_readfirstlane_b32 s53, v96
		s_nop 1
		v_cndmask_b32_e64 v246, v10, v138, s[52:53]
		v_cndmask_b32_e64 v252, v10, v140, s[48:49]
		v_cndmask_b32_e32 v135, v10, v175, vcc
		v_max3_f32 v96, v100, v101, v230
		v_max3_f32 v136, v30, v31, v232
		v_max3_f32 v137, v108, v109, v234
		v_max3_f32 v138, v188, v189, v236
		v_max3_f32 v139, v196, v197, v238
		v_max3_f32 v140, v200, v201, v240
		v_max3_f32 v141, v208, v209, v242
		v_max3_f32 v162, v160, v161, v244
		v_max3_f32 v163, v132, v133, v246
		v_max3_f32 v164, v252, v253, v250
		v_max3_f32 v16, v16, v29, v23
		v_max3_f32 v23, v96, v231, v136
		v_max3_f32 v96, v137, v235, v138
		v_max3_f32 v136, v139, v239, v140
		v_max3_f32 v137, v141, v243, v162
		v_max3_f32 v138, v163, v247, v164
		v_accvgpr_read_b32 v139, a165
		v_max3_f32 v97, v139, v145, v97
		v_accvgpr_read_b32 v139, a190
		v_accvgpr_read_b32 v140, a191
		v_max3_f32 v139, v139, v153, v140
		v_max3_f32 v16, v16, v227, v23
		v_max3_f32 v23, v96, v237, v136
		v_max3_f32 v96, v137, v245, v138
		v_max3_f32 v97, v97, v149, v139
		v_max3_f32 v16, v16, v233, v23
		v_max3_f32 v23, v96, v251, v97
		v_max3_f32 v16, v16, v241, v23
		v_max_f32_e32 v96, v16, v157
		v_mov_b32_e32 v97, v96
		v_cndmask_b32_e64 v136, v10, v176, s[50:51]
		v_cndmask_b32_e64 v137, v10, v177, s[90:91]
		v_permlane32_swap_b32_e32 v96, v97
		v_max3_f32 v10, v136, v137, v8
		v_max3_f32 v16, v98, v99, v178
		v_max3_f32 v23, v24, v25, v180
		v_max3_f32 v138, v26, v27, v102
		v_max3_f32 v139, v104, v105, v106
		v_max3_f32 v140, v182, v183, v184
		v_max3_f32 v141, v112, v113, v186
		v_max3_f32 v162, v190, v191, v192
		v_max3_f32 v163, v116, v117, v194
		v_max3_f32 v164, v120, v121, v198
		v_max3_f32 v165, v202, v203, v204
		v_max3_f32 v166, v124, v125, v206
		v_max3_f32 v167, v110, v111, v128
		v_max3_f32 v168, v114, v115, v118
		v_max3_f32 v169, v122, v123, v126
		v_max3_f32 v170, v130, v131, v134
		v_max3_f32 v10, v10, v9, v16
		v_max3_f32 v16, v23, v181, v138
		v_max3_f32 v23, v139, v107, v140
		v_max3_f32 v138, v141, v187, v162
		v_max3_f32 v139, v163, v195, v164
		v_max3_f32 v140, v165, v205, v166
		v_max3_f32 v141, v167, v129, v168
		v_max3_f32 v162, v169, v127, v170
		v_max3_f32 v10, v10, v179, v16
		v_max3_f32 v16, v23, v185, v138
		v_max3_f32 v23, v139, v199, v140
		v_max3_f32 v138, v141, v119, v162
		v_max3_f32 v10, v10, v103, v16
		v_max3_f32 v16, v23, v207, v138
		v_max3_f32 v10, v10, v193, v16
		v_max_f32_e32 v138, v10, v135
		v_mov_b32_e32 v139, v138
		v_max_f32_e32 v140, v96, v97
		v_mov_b32_e32 v96, v4
		v_permlane32_swap_b32_e32 v138, v139
		v_max_f32_e32 v141, v138, v139
		v_mov_b32_e32 v138, 0x3e38aa3b
		v_mov_b32_e32 v139, 0x3e38aa3b
		v_pk_mul_f32 v[162:163], v[140:141], v[138:139]
		v_max_f32_e32 v140, v4, v162
		v_max_f32_e32 v141, v7, v163
		v_pk_fma_f32 v[162:163], v[248:249], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[28:29], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[158:159], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[226:227], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[100:101], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[230:231], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[30:31], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[232:233], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[108:109], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[234:235], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[188:189], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[236:237], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[196:197], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[238:239], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[200:201], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[240:241], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[208:209], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[242:243], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[160:161], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[244:245], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[132:133], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[246:247], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[252:253], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[218:219], v[250:251], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[220:221], v[142:143], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[144:145], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[146:147], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[148:149], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[150:151], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[154:155], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[156:157], v[138:139], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[136:137], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[8:9], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[8:9], v[98:99], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[178:179], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[24:25], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[180:181], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[26:27], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[102:103], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[182:183], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[184:185], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[112:113], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[186:187], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[190:191], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[192:193], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[116:117], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[194:195], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[120:121], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[198:199], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[202:203], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[204:205], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[124:125], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[206:207], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[110:111], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[128:129], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[114:115], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[118:119], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[122:123], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[126:127], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[130:131], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[134:135], v[138:139], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v134, v162
		v_exp_f32_e32 v138, v163
		v_exp_f32_e32 v162, v164
		v_exp_f32_e32 v222, v165
		v_exp_f32_e32 v164, v28
		v_exp_f32_e32 v224, v29
		v_exp_f32_e32 v28, v158
		v_exp_f32_e32 v226, v159
		v_exp_f32_e32 v158, v166
		v_exp_f32_e32 v228, v167
		v_exp_f32_e32 v166, v100
		v_exp_f32_e32 v230, v101
		v_exp_f32_e32 v100, v168
		v_exp_f32_e32 v232, v169
		v_exp_f32_e32 v168, v30
		v_exp_f32_e32 v234, v31
		v_exp_f32_e32 v30, v170
		v_exp_f32_e32 v236, v171
		v_exp_f32_e32 v170, v108
		v_exp_f32_e32 v238, v109
		v_exp_f32_e32 v108, v172
		v_exp_f32_e32 v240, v173
		v_exp_f32_e32 v172, v174
		v_exp_f32_e32 v242, v175
		v_exp_f32_e32 v174, v176
		v_exp_f32_e32 v244, v177
		v_exp_f32_e32 v176, v188
		v_exp_f32_e32 v246, v189
		v_exp_f32_e32 v188, v196
		v_exp_f32_e32 v248, v197
		v_exp_f32_e32 v196, v200
		v_exp_f32_e32 v250, v201
		v_exp_f32_e32 v135, v210
		v_exp_f32_e32 v139, v211
		v_exp_f32_e32 v163, v208
		v_exp_f32_e32 v223, v209
		v_exp_f32_e32 v165, v212
		v_exp_f32_e32 v225, v213
		v_exp_f32_e32 v29, v160
		v_exp_f32_e32 v227, v161
		v_exp_f32_e32 v159, v214
		v_exp_f32_e32 v229, v215
		v_exp_f32_e32 v167, v132
		v_exp_f32_e32 v231, v133
		v_exp_f32_e32 v101, v216
		v_exp_f32_e32 v233, v217
		v_exp_f32_e32 v169, v218
		v_exp_f32_e32 v235, v219
		v_exp_f32_e32 v31, v220
		v_exp_f32_e32 v237, v221
		v_exp_f32_e32 v171, v142
		v_exp_f32_e32 v239, v143
		v_exp_f32_e32 v109, v144
		v_exp_f32_e32 v241, v145
		v_exp_f32_e32 v173, v146
		v_exp_f32_e32 v243, v147
		v_exp_f32_e32 v175, v148
		v_exp_f32_e32 v245, v149
		v_exp_f32_e32 v177, v150
		v_exp_f32_e32 v247, v151
		v_exp_f32_e32 v189, v152
		v_exp_f32_e32 v249, v153
		v_exp_f32_e32 v197, v154
		v_exp_f32_e32 v251, v155
		v_exp_f32_e32 v132, v156
		v_exp_f32_e32 v142, v157
		v_exp_f32_e32 v144, v136
		v_exp_f32_e32 v146, v137
		v_exp_f32_e32 v136, v8
		v_exp_f32_e32 v148, v9
		v_exp_f32_e32 v8, v98
		v_exp_f32_e32 v150, v99
		v_exp_f32_e32 v98, v178
		v_exp_f32_e32 v152, v179
		v_exp_f32_e32 v154, v24
		v_exp_f32_e32 v156, v25
		v_exp_f32_e32 v24, v180
		v_exp_f32_e32 v160, v181
		v_exp_f32_e32 v178, v26
		v_exp_f32_e32 v180, v27
		v_exp_f32_e32 v26, v102
		v_exp_f32_e32 v200, v103
		v_exp_f32_e32 v102, v104
		v_exp_f32_e32 v208, v105
		v_exp_f32_e32 v104, v106
		v_exp_f32_e32 v210, v107
		v_exp_f32_e32 v106, v182
		v_exp_f32_e32 v212, v183
		v_exp_f32_e32 v182, v184
		v_exp_f32_e32 v214, v185
		v_exp_f32_e32 v184, v112
		v_exp_f32_e32 v216, v113
		v_exp_f32_e32 v112, v186
		v_exp_f32_e32 v218, v187
		v_exp_f32_e32 v186, v190
		v_exp_f32_e32 v220, v191
		v_exp_f32_e32 v133, v192
		v_exp_f32_e32 v143, v193
		v_exp_f32_e32 v145, v116
		v_exp_f32_e32 v147, v117
		v_exp_f32_e32 v137, v194
		v_exp_f32_e32 v149, v195
		v_exp_f32_e32 v9, v120
		v_exp_f32_e32 v151, v121
		v_exp_f32_e32 v99, v198
		v_exp_f32_e32 v153, v199
		v_exp_f32_e32 v155, v202
		v_exp_f32_e32 v157, v203
		v_exp_f32_e32 v25, v204
		v_exp_f32_e32 v161, v205
		v_exp_f32_e32 v179, v124
		v_exp_f32_e32 v181, v125
		v_exp_f32_e32 v27, v206
		v_exp_f32_e32 v201, v207
		v_exp_f32_e32 v103, v110
		v_exp_f32_e32 v209, v111
		v_exp_f32_e32 v105, v128
		v_exp_f32_e32 v211, v129
		v_exp_f32_e32 v107, v114
		v_exp_f32_e32 v213, v115
		v_exp_f32_e32 v183, v118
		v_exp_f32_e32 v215, v119
		v_exp_f32_e32 v185, v122
		v_exp_f32_e32 v217, v123
		v_exp_f32_e32 v113, v126
		v_exp_f32_e32 v219, v127
		v_exp_f32_e32 v187, v130
		v_exp_f32_e32 v221, v131
		v_pk_add_f32 v[110:111], v[134:135], v[138:139]
		v_pk_add_f32 v[114:115], v[162:163], v[222:223]
		v_pk_add_f32 v[116:117], v[164:165], v[224:225]
		v_pk_add_f32 v[118:119], v[28:29], v[226:227]
		v_pk_add_f32 v[120:121], v[158:159], v[228:229]
		v_pk_add_f32 v[122:123], v[166:167], v[230:231]
		v_pk_add_f32 v[124:125], v[100:101], v[232:233]
		v_pk_add_f32 v[126:127], v[168:169], v[234:235]
		v_pk_add_f32 v[128:129], v[30:31], v[236:237]
		v_pk_add_f32 v[130:131], v[170:171], v[238:239]
		v_pk_add_f32 v[190:191], v[108:109], v[240:241]
		v_pk_add_f32 v[192:193], v[172:173], v[242:243]
		v_pk_add_f32 v[194:195], v[174:175], v[244:245]
		v_pk_add_f32 v[198:199], v[176:177], v[246:247]
		v_pk_add_f32 v[202:203], v[188:189], v[248:249]
		v_pk_add_f32 v[204:205], v[196:197], v[250:251]
		v_pk_add_f32 v[110:111], v[110:111], v[114:115]
		v_pk_add_f32 v[114:115], v[116:117], v[118:119]
		v_pk_add_f32 v[116:117], v[120:121], v[122:123]
		v_pk_add_f32 v[118:119], v[124:125], v[126:127]
		v_pk_add_f32 v[120:121], v[128:129], v[130:131]
		v_pk_add_f32 v[122:123], v[190:191], v[192:193]
		v_pk_add_f32 v[124:125], v[194:195], v[198:199]
		v_pk_add_f32 v[126:127], v[202:203], v[204:205]
		v_pk_add_f32 v[110:111], v[110:111], v[114:115]
		v_pk_add_f32 v[114:115], v[116:117], v[118:119]
		v_pk_add_f32 v[116:117], v[120:121], v[122:123]
		v_pk_add_f32 v[118:119], v[124:125], v[126:127]
		v_pk_add_f32 v[110:111], v[110:111], v[114:115]
		v_pk_add_f32 v[114:115], v[116:117], v[118:119]
		v_pk_add_f32 v[116:117], v[110:111], v[114:115]
		v_add_f32_e32 v4, v116, v117
		v_accvgpr_read_b32 v10, a72
		ds_bpermute_b32 v110, v10, v4
		v_accvgpr_read_b32 v10, a73
		ds_bpermute_b32 v114, v10, v4
		v_pk_add_f32 v[116:117], v[132:133], v[142:143]
		v_pk_add_f32 v[118:119], v[144:145], v[146:147]
		v_pk_add_f32 v[120:121], v[136:137], v[148:149]
		v_pk_add_f32 v[122:123], v[8:9], v[150:151]
		v_pk_add_f32 v[124:125], v[98:99], v[152:153]
		v_pk_add_f32 v[126:127], v[154:155], v[156:157]
		v_pk_add_f32 v[128:129], v[24:25], v[160:161]
		v_pk_add_f32 v[130:131], v[178:179], v[180:181]
		v_pk_add_f32 v[190:191], v[26:27], v[200:201]
		v_pk_add_f32 v[192:193], v[102:103], v[208:209]
		v_pk_add_f32 v[194:195], v[104:105], v[210:211]
		v_pk_add_f32 v[198:199], v[106:107], v[212:213]
		v_pk_add_f32 v[202:203], v[182:183], v[214:215]
		v_pk_add_f32 v[204:205], v[184:185], v[216:217]
		v_pk_add_f32 v[206:207], v[112:113], v[218:219]
		v_pk_add_f32 v[252:253], v[186:187], v[220:221]
		v_pk_add_f32 v[116:117], v[116:117], v[118:119]
		v_pk_add_f32 v[118:119], v[120:121], v[122:123]
		v_pk_add_f32 v[120:121], v[124:125], v[126:127]
		v_pk_add_f32 v[122:123], v[128:129], v[130:131]
		v_pk_add_f32 v[124:125], v[190:191], v[192:193]
		v_pk_add_f32 v[126:127], v[194:195], v[198:199]
		v_pk_add_f32 v[128:129], v[202:203], v[204:205]
		v_pk_add_f32 v[130:131], v[206:207], v[252:253]
		v_pk_add_f32 v[116:117], v[116:117], v[118:119]
		v_pk_add_f32 v[118:119], v[120:121], v[122:123]
		v_pk_add_f32 v[120:121], v[124:125], v[126:127]
		v_pk_add_f32 v[122:123], v[128:129], v[130:131]
		v_pk_add_f32 v[116:117], v[116:117], v[118:119]
		v_pk_add_f32 v[118:119], v[120:121], v[122:123]
		v_pk_add_f32 v[120:121], v[116:117], v[118:119]
		v_mov_b32_e32 v115, v121
		v_mov_b32_e32 v111, v120
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[116:117], v[110:111], v[114:115]
		v_mov_b32_e32 v110, v117
		v_mov_b32_e32 v111, v117
		v_cvt_pk_bf16_f32 v120, v134, v138
		v_cvt_pk_bf16_f32 v121, v162, v222
		v_permlane32_swap_b32_e32 v110, v111
		v_add_f32_e32 v115, v110, v111
		v_mov_b32_e32 v97, v7
		v_pk_add_f32 v[110:111], v[96:97], v[140:141] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v96, v110
		v_exp_f32_e32 v97, v111
		v_cvt_pk_bf16_f32 v122, v164, v224
		v_pk_mul_f32 v[32:33], v[32:33], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[34:35], v[34:35], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[36:37], v[36:37], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[38:39], v[38:39], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[40:41], v[40:41], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[42:43], v[42:43], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[44:45], v[44:45], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[46:47], v[46:47], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[48:49], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[50:51], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[52:53], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[54:55], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[56:57], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[58:59], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[60:61], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[62:63], v[96:97] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[64:65], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[66:67], v[66:67], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[68:69], v[68:69], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[70:71], v[70:71], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[72:73], v[72:73], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[74:75], v[74:75], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[76:77], v[76:77], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[78:79], v[78:79], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[80:81], v[80:81], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[82:83], v[82:83], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[84:85], v[84:85], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[86:87], v[86:87], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[88:89], v[88:89], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[90:91], v[90:91], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[92:93], v[92:93], v[96:97] op_sel:[0,1]
		v_pk_mul_f32 v[94:95], v[94:95], v[96:97] op_sel:[0,1]
		v_mov_b32_e32 v114, v116
		v_mov_b64_e32 v[110:111], v[12:13]
		v_pk_fma_f32 v[12:13], v[110:111], v[96:97], v[114:115]
		v_cvt_pk_bf16_f32 v123, v28, v226
		v_cvt_pk_bf16_f32 v116, v158, v228
		v_cvt_pk_bf16_f32 v117, v166, v230
		v_cvt_pk_bf16_f32 v118, v100, v232
		v_cvt_pk_bf16_f32 v119, v168, v234
		v_cvt_pk_bf16_f32 v124, v30, v236
		v_cvt_pk_bf16_f32 v125, v170, v238
		v_cvt_pk_bf16_f32 v126, v108, v240
		v_cvt_pk_bf16_f32 v127, v172, v242
		v_cvt_pk_bf16_f32 v128, v174, v244
		v_cvt_pk_bf16_f32 v129, v176, v246
		v_cvt_pk_bf16_f32 v130, v188, v248
		v_cvt_pk_bf16_f32 v131, v196, v250
		v_cvt_pk_bf16_f32 v192, v135, v139
		v_cvt_pk_bf16_f32 v193, v163, v223
		v_cvt_pk_bf16_f32 v194, v165, v225
		v_cvt_pk_bf16_f32 v195, v29, v227
		v_cvt_pk_bf16_f32 v204, v159, v229
		v_cvt_pk_bf16_f32 v205, v167, v231
		v_cvt_pk_bf16_f32 v206, v101, v233
		v_cvt_pk_bf16_f32 v207, v169, v235
		v_cvt_pk_bf16_f32 v164, v31, v237
		v_cvt_pk_bf16_f32 v165, v171, v239
		v_cvt_pk_bf16_f32 v166, v109, v241
		v_cvt_pk_bf16_f32 v167, v173, v243
		v_cvt_pk_bf16_f32 v28, v175, v245
		v_cvt_pk_bf16_f32 v29, v177, v247
		v_cvt_pk_bf16_f32 v30, v189, v249
		v_cvt_pk_bf16_f32 v31, v197, v251
		v_cvt_pk_bf16_f32 v108, v132, v142
		v_cvt_pk_bf16_f32 v109, v144, v146
		v_cvt_pk_bf16_f32 v110, v136, v148
		v_cvt_pk_bf16_f32 v111, v8, v150
		v_cvt_pk_bf16_f32 v168, v98, v152
		v_cvt_pk_bf16_f32 v169, v154, v156
		v_cvt_pk_bf16_f32 v170, v24, v160
		v_cvt_pk_bf16_f32 v171, v178, v180
		v_cvt_pk_bf16_f32 v172, v26, v200
		v_cvt_pk_bf16_f32 v173, v102, v208
		v_cvt_pk_bf16_f32 v174, v104, v210
		v_cvt_pk_bf16_f32 v175, v106, v212
		v_cvt_pk_bf16_f32 v188, v182, v214
		v_cvt_pk_bf16_f32 v189, v184, v216
		v_cvt_pk_bf16_f32 v190, v112, v218
		v_cvt_pk_bf16_f32 v191, v186, v220
		v_cvt_pk_bf16_f32 v196, v133, v143
		v_cvt_pk_bf16_f32 v197, v145, v147
		v_cvt_pk_bf16_f32 v198, v137, v149
		v_cvt_pk_bf16_f32 v199, v9, v151
		v_cvt_pk_bf16_f32 v132, v99, v153
		v_cvt_pk_bf16_f32 v133, v155, v157
		v_cvt_pk_bf16_f32 v134, v25, v161
		v_cvt_pk_bf16_f32 v135, v179, v181
		v_cvt_pk_bf16_f32 v96, v27, v201
		v_cvt_pk_bf16_f32 v97, v103, v209
		v_cvt_pk_bf16_f32 v98, v105, v211
		v_cvt_pk_bf16_f32 v99, v107, v213
		v_cvt_pk_bf16_f32 v24, v183, v215
		v_cvt_pk_bf16_f32 v25, v185, v217
		v_cvt_pk_bf16_f32 v26, v113, v219
		v_cvt_pk_bf16_f32 v27, v187, v221
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[120:123], v[32:47]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[120:123], v[48:63]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[116:119], v[32:47]
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[116:119], v[48:63]
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[124:127], v[32:47]
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[124:127], v[48:63]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[128:131], v[32:47]
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[128:131], v[48:63]
		v_permlane32_swap_b32_e32 v168, v170
		v_permlane32_swap_b32_e32 v169, v171
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[108:111], v[80:95]
		v_permlane32_swap_b32_e32 v172, v174
		v_permlane32_swap_b32_e32 v173, v175
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[108:111], v[64:79]
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[168:171], v[80:95]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[168:171], v[64:79]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[172:175], v[80:95]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[172:175], v[64:79]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[188:191], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[188:191], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[192:195], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[192:195], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[196:199], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[196:199], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[204:207], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[204:207], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[132:135], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[132:135], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[216:219], v[164:167], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[248:251], v[164:167], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[248:251], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[216:219], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[220:223], v[28:31], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[252:255], v[28:31], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[252:255], v[24:27], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[220:223], v[24:27], v[64:79]
		s_cselect_b32 s1, 1, 0
		s_add_i32 s23, s41, 0x80
		s_cmp_lg_u32 s1, 0
		s_mov_b32 s41, s23
		v_mov_b32_e32 v4, v140
		v_mov_b32_e32 v7, v141
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_4
.L_attn_fwd_persistent.loop_exit_4:
		s_mov_b32 s24, s8
		s_mov_b32 s25, s9
		s_mov_b32 s26, s38
		s_mov_b32 s27, s39
		v_rcp_f32_e32 v2, v12
		v_accvgpr_read_b32 v1, a4
		s_nop 0
		v_readfirstlane_b32 s1, v1
		v_accvgpr_read_b32 v1, a13
		s_nop 0
		v_readfirstlane_b32 s18, v1
		s_mul_i32 s1, s18, s1
		v_mov_b32_e32 v3, v2
		v_pk_mul_f32 v[4:5], v[32:33], v[2:3]
		v_pk_mul_f32 v[6:7], v[34:35], v[2:3]
		v_pk_mul_f32 v[8:9], v[36:37], v[2:3]
		v_pk_mul_f32 v[10:11], v[38:39], v[2:3]
		v_pk_mul_f32 v[14:15], v[40:41], v[2:3]
		v_pk_mul_f32 v[16:17], v[42:43], v[2:3]
		v_pk_mul_f32 v[18:19], v[44:45], v[2:3]
		v_pk_mul_f32 v[20:21], v[46:47], v[2:3]
		v_pk_mul_f32 v[22:23], v[48:49], v[2:3]
		v_pk_mul_f32 v[24:25], v[50:51], v[2:3]
		v_pk_mul_f32 v[26:27], v[52:53], v[2:3]
		v_pk_mul_f32 v[28:29], v[54:55], v[2:3]
		v_pk_mul_f32 v[30:31], v[56:57], v[2:3]
		v_pk_mul_f32 v[32:33], v[58:59], v[2:3]
		v_pk_mul_f32 v[34:35], v[60:61], v[2:3]
		v_pk_mul_f32 v[36:37], v[62:63], v[2:3]
		v_rcp_f32_e32 v2, v13
		v_cvt_pk_bf16_f32 v40, v4, v5
		v_mov_b32_e32 v3, v2
		v_pk_mul_f32 v[4:5], v[64:65], v[2:3]
		v_pk_mul_f32 v[12:13], v[66:67], v[2:3]
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
		v_cvt_pk_bf16_f32 v8, v14, v15
		v_cvt_pk_bf16_f32 v9, v16, v17
		v_cvt_pk_bf16_f32 v10, v18, v19
		v_cvt_pk_bf16_f32 v11, v20, v21
		v_cvt_pk_bf16_f32 v16, v22, v23
		v_cvt_pk_bf16_f32 v17, v24, v25
		v_cvt_pk_bf16_f32 v18, v26, v27
		v_cvt_pk_bf16_f32 v19, v28, v29
		v_cvt_pk_bf16_f32 v20, v30, v31
		v_cvt_pk_bf16_f32 v21, v32, v33
		v_cvt_pk_bf16_f32 v22, v34, v35
		v_cvt_pk_bf16_f32 v23, v36, v37
		v_cvt_pk_bf16_f32 v24, v4, v5
		v_cvt_pk_bf16_f32 v25, v12, v13
		v_cvt_pk_bf16_f32 v26, v38, v39
		v_cvt_pk_bf16_f32 v27, v44, v45
		v_cvt_pk_bf16_f32 v4, v46, v47
		v_cvt_pk_bf16_f32 v5, v48, v49
		v_cvt_pk_bf16_f32 v6, v50, v51
		v_cvt_pk_bf16_f32 v7, v52, v53
		v_cvt_pk_bf16_f32 v12, v54, v55
		v_cvt_pk_bf16_f32 v13, v56, v57
		v_cvt_pk_bf16_f32 v14, v58, v59
		v_cvt_pk_bf16_f32 v15, v60, v61
		v_cvt_pk_bf16_f32 v28, v62, v63
		v_cvt_pk_bf16_f32 v29, v64, v65
		v_cvt_pk_bf16_f32 v30, v66, v67
		v_cvt_pk_bf16_f32 v31, v68, v69
		v_permlane32_swap_b32_e32 v40, v42
		v_permlane32_swap_b32_e32 v41, v43
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v20, v22
		v_permlane32_swap_b32_e32 v21, v23
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_permlane32_swap_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v5, v7
		v_permlane32_swap_b32_e32 v12, v14
		v_permlane32_swap_b32_e32 v13, v15
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		s_lshl_b32 s1, s1, 9
		v_accvgpr_read_b32 v1, a2
		s_nop 0
		v_readfirstlane_b32 s18, v1
		v_accvgpr_read_b32 v1, a11
		s_nop 0
		v_readfirstlane_b32 s21, v1
		s_mul_i32 s18, s21, s18
		s_lshl_b32 s18, s18, 1
		s_add_i32 s21, s1, s18
		v_accvgpr_read_b32 v1, a3
		s_nop 0
		v_readfirstlane_b32 s22, v1
		v_accvgpr_read_b32 v1, a12
		s_nop 0
		v_readfirstlane_b32 s23, v1
		s_mul_i32 s22, s23, s22
		s_lshl_b32 s22, s22, 1
		s_add_i32 s21, s21, s22
		v_accvgpr_read_b32 v1, a4
		s_nop 0
		v_readfirstlane_b32 s23, v1
		v_accvgpr_read_b32 v1, a14
		s_nop 0
		v_mul_lo_u32 v1, s23, v1
		v_lshl_add_u32 v2, v1, 6, s21
		v_and_b32_e32 v3, 31, v0
		v_accvgpr_read_b32 v32, a4
		s_nop 0
		v_readfirstlane_b32 s21, v32
		s_nop 1
		v_mul_lo_u32 v3, s21, v3
		v_lshl_add_u32 v2, v3, 1, v2
		v_accvgpr_read_b32 v32, a17
		v_lshl_add_u32 v2, v32, 4, v2
		v_accvgpr_read_b32 v32, a54
		s_nop 0
		v_readfirstlane_b32 s28, v32
		v_accvgpr_read_b32 v32, a55
		s_nop 0
		v_readfirstlane_b32 s29, v32
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_24
		buffer_store_dwordx4 v[40:43], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_24:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_24
.L_attn_fwd_persistent.exec_endif_24:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 32
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v1, 6, s21
		v_lshl_add_u32 v2, v3, 1, v2
		v_accvgpr_read_b32 v32, a17
		v_lshl_add_u32 v2, v32, 4, v2
		v_accvgpr_read_b32 v32, a54
		s_nop 0
		v_readfirstlane_b32 s28, v32
		v_accvgpr_read_b32 v32, a55
		s_nop 0
		v_readfirstlane_b32 s29, v32
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_25
		buffer_store_dwordx4 v[8:11], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_25:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_25
.L_attn_fwd_persistent.exec_endif_25:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 64
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v1, 6, s21
		v_lshl_add_u32 v2, v3, 1, v2
		v_accvgpr_read_b32 v8, a17
		v_lshl_add_u32 v2, v8, 4, v2
		v_accvgpr_read_b32 v8, a54
		s_nop 0
		v_readfirstlane_b32 s28, v8
		v_accvgpr_read_b32 v8, a55
		s_nop 0
		v_readfirstlane_b32 s29, v8
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_26
		buffer_store_dwordx4 v[16:19], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_26:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_26
.L_attn_fwd_persistent.exec_endif_26:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x60
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v1, 6, s21
		v_lshl_add_u32 v2, v3, 1, v2
		v_accvgpr_read_b32 v8, a17
		v_lshl_add_u32 v2, v8, 4, v2
		v_accvgpr_read_b32 v8, a54
		s_nop 0
		v_readfirstlane_b32 s28, v8
		v_accvgpr_read_b32 v8, a55
		s_nop 0
		v_readfirstlane_b32 s29, v8
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_27
		buffer_store_dwordx4 v[20:23], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_27:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_27
.L_attn_fwd_persistent.exec_endif_27:
		s_mov_b64 exec, s[96:97]
		v_accvgpr_read_b32 v2, a4
		s_nop 0
		v_readfirstlane_b32 s21, v2
		s_lshl_b32 s21, s21, 8
		s_add_i32 s23, s21, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v1, 6, s23
		v_lshl_add_u32 v2, v3, 1, v2
		v_accvgpr_read_b32 v8, a17
		v_lshl_add_u32 v2, v8, 4, v2
		v_accvgpr_read_b32 v8, a56
		s_nop 0
		v_readfirstlane_b32 s28, v8
		v_accvgpr_read_b32 v8, a57
		s_nop 0
		v_readfirstlane_b32 s29, v8
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_28
		buffer_store_dwordx4 v[24:27], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_28:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_28
.L_attn_fwd_persistent.exec_endif_28:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 32
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v1, 6, s23
		v_lshl_add_u32 v2, v3, 1, v2
		v_accvgpr_read_b32 v8, a17
		v_lshl_add_u32 v2, v8, 4, v2
		v_accvgpr_read_b32 v8, a56
		s_nop 0
		v_readfirstlane_b32 s28, v8
		v_accvgpr_read_b32 v8, a57
		s_nop 0
		v_readfirstlane_b32 s29, v8
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_29
		buffer_store_dwordx4 v[4:7], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_29:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_29
.L_attn_fwd_persistent.exec_endif_29:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 64
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v1, 6, s23
		v_lshl_add_u32 v2, v3, 1, v2
		v_accvgpr_read_b32 v4, a17
		v_lshl_add_u32 v2, v4, 4, v2
		v_accvgpr_read_b32 v4, a56
		s_nop 0
		v_readfirstlane_b32 s28, v4
		v_accvgpr_read_b32 v4, a57
		s_nop 0
		v_readfirstlane_b32 s29, v4
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_30
		buffer_store_dwordx4 v[12:15], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_30:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_30
.L_attn_fwd_persistent.exec_endif_30:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s21, 0x60
		s_add_i32 s1, s21, s1
		s_add_i32 s1, s1, s18
		s_add_i32 s1, s1, s22
		v_lshl_add_u32 v1, v1, 6, s1
		v_lshl_add_u32 v1, v3, 1, v1
		v_accvgpr_read_b32 v2, a17
		v_lshl_add_u32 v1, v2, 4, v1
		v_accvgpr_read_b32 v2, a56
		s_nop 0
		v_readfirstlane_b32 s22, v2
		v_accvgpr_read_b32 v2, a57
		s_nop 0
		v_readfirstlane_b32 s23, v2
		s_and_saveexec_b64 s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_31
		buffer_store_dwordx4 v[28:31], v1, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_31:
		s_andn2_b64 exec, s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_31
.L_attn_fwd_persistent.exec_endif_31:
		s_mov_b64 exec, s[96:97]
		s_branch .L_attn_fwd_persistent.if_end_3
.L_attn_fwd_persistent.if_else_3:
.L_attn_fwd_persistent.if_end_3:
		s_branch .L_attn_fwd_persistent.if_end_0
.L_attn_fwd_persistent.if_else_0:
.L_attn_fwd_persistent.if_end_0:
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s0, s0, 32
		v_accvgpr_read_b32 v1, a10
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
		.amdhsa_next_free_vgpr 512
		.amdhsa_next_free_sgpr 98
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
	.set .L_attn_fwd_persistent.numbered_sgpr, 98
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
    .sgpr_count:     98
    .sgpr_spill_count: 0
    .symbol:         _attn_fwd_persistent.kd
    .uses_dynamic_stack: false
    .vgpr_count:     512
    .agpr_count:     256
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 439
    wave.regalloc.agpr.dwords: 823
    wave.regalloc.remat.dwords: 9
    wave.regalloc.sgpr_to_vgpr.dwords: 72
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
