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
		v_mov_b32_e32 v9, 2
		v_mul_lo_u32 v9, v9, v14
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v10, a14
		v_lshlrev_b32_e32 v10, 12, v10
		v_add_u32_e32 v10, 0x10000, v10
		v_and_b32_e32 v11, 63, v0
		v_lshrrev_b32_e32 v14, 5, v11
		v_and_b32_e32 v15, 31, v11
		v_lshl_add_u32 v16, v15, 3, v14
		v_and_b32_e32 v17, 7, v11
		v_lshrrev_b32_e32 v18, 2, v17
		v_lshlrev_b32_e32 v18, 1, v18
		v_lshrrev_b32_e32 v11, 3, v11
		v_and_b32_e32 v11, 1, v11
		v_lshlrev_b32_e32 v11, 2, v11
		v_lshrrev_b32_e32 v19, 1, v17
		v_bitop3_b32 v19, v11, v19, 1 bitop3:0x78
		v_bitop3_b32 v16, v16, v18, v19 bitop3:0x96
		v_lshl_add_u32 v16, v16, 4, v10
		ds_read_b128 a[20:23], v16 offset:2480
		v_add_u32_e32 v18, 2, v14
		v_lshl_add_u32 v19, v15, 3, v18
		v_lshl_add_u32 v18, v17, 3, v18
		v_lshrrev_b32_e32 v20, 5, v18
		v_lshlrev_b32_e32 v20, 1, v20
		v_lshrrev_b32_e32 v18, 4, v18
		v_bitop3_b32 v18, v11, v18, 1 bitop3:0x78
		v_bitop3_b32 v18, v19, v20, v18 bitop3:0x96
		v_lshl_add_u32 v18, v18, 4, v10
		ds_read_b128 a[24:27], v18 offset:2480
		v_add_u32_e32 v19, 4, v14
		v_lshl_add_u32 v20, v15, 3, v19
		v_lshl_add_u32 v19, v17, 3, v19
		v_lshrrev_b32_e32 v21, 5, v19
		v_lshlrev_b32_e32 v21, 1, v21
		v_lshrrev_b32_e32 v19, 4, v19
		v_bitop3_b32 v19, v11, v19, 1 bitop3:0x78
		v_bitop3_b32 v19, v20, v21, v19 bitop3:0x96
		v_lshl_add_u32 v19, v19, 4, v10
		ds_read_b128 a[28:31], v19 offset:2480
		v_add_u32_e32 v20, 6, v14
		v_lshl_add_u32 v21, v15, 3, v20
		v_lshl_add_u32 v17, v17, 3, v20
		v_lshrrev_b32_e32 v20, 5, v17
		v_lshlrev_b32_e32 v20, 1, v20
		v_lshrrev_b32_e32 v17, 4, v17
		v_bitop3_b32 v11, v11, v17, 1 bitop3:0x78
		v_bitop3_b32 v11, v21, v20, v11 bitop3:0x96
		v_lshl_add_u32 v10, v11, 4, v10
		ds_read_b128 a[32:35], v10 offset:2480
		v_and_b32_e32 v6, 1, v6
		v_lshlrev_b32_e32 v11, 4, v13
		v_and_b32_e32 v2, 3, v2
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
		ds_read_b128 a[36:39], v16 offset:2480
		ds_read_b128 a[40:43], v18 offset:2480
		ds_read_b128 a[44:47], v19 offset:2480
		ds_read_b128 a[48:51], v10 offset:2480
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
		v_mov_b32_e32 v10, 16
		v_mul_lo_u32 v10, v10, v4
		v_bitop3_b32 v13, v1, v3, v10 bitop3:0x96
		v_bitop3_b32 v13, v13, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a18, v13
		v_bitop3_b32 v13, 4, v1, v3 bitop3:0x96
		v_xor_b32_e32 v13, v13, v10
		v_bitop3_b32 v16, 8, v1, v3 bitop3:0x96
		v_xor_b32_e32 v16, v16, v10
		v_bitop3_b32 v1, 12, v1, v3 bitop3:0x96
		v_accvgpr_read_b32 v17, a18
		v_cmp_lt_i32_e64 s[32:33], v17, s20
		v_mov_b32_e32 v17, 16
		v_mul_lo_u32 v17, v17, v7
		v_mov_b32_e32 v7, 64
		v_mul_lo_u32 v7, v7, v4
		v_bitop3_b32 v4, v17, v3, v7 bitop3:0x96
		v_bitop3_b32 v4, v4, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a19, v4
		v_bitop3_b32 v4, 4, v17, v3 bitop3:0x96
		v_bitop3_b32 v18, 8, v17, v3 bitop3:0x96
		v_bitop3_b32 v3, 12, v17, v3 bitop3:0x96
		v_accvgpr_read_b32 v17, a19
		v_cmp_lt_i32_e64 vcc, v17, s20
		v_readfirstlane_b32 s34, v0
		v_accvgpr_read_b32 v17, a14
		v_mul_lo_u32 v17, s15, v17
		v_accvgpr_read_b32 v19, a17
		v_mul_lo_u32 v19, s15, v19
		v_lshlrev_b32_e32 v19, 5, v19
		v_lshl_add_u32 v17, v17, 1, v19
		v_mul_lo_u32 v19, s15, v8
		v_lshl_add_u32 v17, v19, 6, v17
		v_mul_lo_u32 v19, s15, v6
		v_lshlrev_b32_e32 v19, 7, v19
		v_add3_u32 v17, v17, v19, v11
		v_accvgpr_read_b32 v19, a11
		s_nop 0
		v_readfirstlane_b32 s35, v19
		s_mul_i32 s35, s35, s13
		s_lshl_b32 s35, s35, 1
		v_accvgpr_read_b32 v19, a12
		s_nop 0
		v_readfirstlane_b32 s36, v19
		s_mul_i32 s36, s36, s14
		s_lshl_b32 s36, s36, 1
		s_add_i32 s37, s35, s36
		v_add_u32_e32 v19, s37, v17
		v_mov_b32_e32 v20, 0x80000000
		v_cndmask_b32_e64 v19, v20, v19, s[32:33]
		s_lshr_b32 s37, s34, 6
		s_mul_i32 s40, 0x410, s37
		s_mov_b32 m0, s40
		v_accvgpr_read_b32 v21, a15
		v_add_u32_e32 v21, s1, v21
		buffer_load_dwordx4 v19, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[42:43], v21, s19
		s_nop 1
		v_mov_b32_e32 v22, s42
		v_mov_b32_e32 v23, s43
		v_accvgpr_write_b32 a52, v22
		v_accvgpr_write_b32 a53, v23
		s_lshl_b32 s41, s15, 3
		s_add_i32 s41, s41, s35
		s_add_i32 s41, s41, s36
		v_add_u32_e32 v19, s41, v17
		v_cndmask_b32_e64 v19, v20, v19, s[32:33]
		s_add_i32 m0, m0, 0x1040
		v_accvgpr_read_b32 v21, a16
		v_add_u32_e32 v21, s1, v21
		buffer_load_dwordx4 v19, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[42:43], v21, s19
		s_nop 1
		v_mov_b32_e32 v22, s42
		v_mov_b32_e32 v23, s43
		v_accvgpr_write_b32 a54, v22
		v_accvgpr_write_b32 a55, v23
		s_lshl_b32 s41, s15, 4
		s_add_i32 s41, s41, s35
		s_add_i32 s41, s41, s36
		v_add_u32_e32 v19, s41, v17
		v_cndmask_b32_e64 v19, v20, v19, s[32:33]
		s_add_i32 m0, m0, 0x1040
		v_lshlrev_b32_e32 v14, 4, v14
		v_accvgpr_write_b32 a56, v14
		buffer_load_dwordx4 v19, s[24:27], 0 offen lds
		v_bitop3_b32 v13, v13, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a57, v13
		s_mul_i32 s41, 24, s15
		s_add_i32 s41, s41, s35
		s_add_i32 s41, s41, s36
		v_add_u32_e32 v13, s41, v17
		v_cndmask_b32_e64 v13, v20, v13, s[32:33]
		s_add_i32 m0, m0, 0x1040
		v_mov_b32_e32 v14, 0x440
		v_mul_lo_u32 v14, v14, v2
		v_accvgpr_write_b32 a58, v14
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		v_bitop3_b32 v2, v16, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a59, v2
		v_accvgpr_read_b32 v2, a14
		v_mul_lo_u32 v2, s17, v2
		v_accvgpr_read_b32 v13, a17
		v_mul_lo_u32 v13, s17, v13
		v_lshlrev_b32_e32 v13, 7, v13
		v_lshl_add_u32 v2, v2, 1, v13
		v_mul_lo_u32 v13, s17, v8
		v_lshl_add_u32 v2, v13, 6, v2
		v_mul_lo_u32 v6, s17, v6
		v_lshlrev_b32_e32 v6, 5, v6
		v_add3_u32 v2, v2, v6, v11
		v_accvgpr_read_b32 v6, a0
		s_nop 0
		v_readfirstlane_b32 s32, v6
		v_accvgpr_read_b32 v6, a11
		s_nop 0
		v_readfirstlane_b32 s33, v6
		s_mul_i32 s32, s33, s32
		s_lshl_b32 s32, s32, 1
		v_accvgpr_read_b32 v6, a1
		s_nop 0
		v_readfirstlane_b32 s33, v6
		v_accvgpr_read_b32 v6, a12
		s_nop 0
		v_readfirstlane_b32 s41, v6
		s_mul_i32 s33, s41, s33
		s_lshl_b32 s33, s33, 1
		s_add_i32 s41, s32, s33
		v_add_u32_e32 v6, s41, v2
		v_cndmask_b32_e32 v6, v20, v6, vcc
		s_mul_i32 s37, 0x440, s37
		s_add_i32 m0, s37, 0x81f0
		v_xor_b32_e32 v1, v1, v10
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_bitop3_b32 v1, v1, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a60, v1
		s_lshl_b32 s41, s17, 3
		s_add_i32 s41, s41, s32
		s_add_i32 s41, s41, s33
		v_add_u32_e32 v1, s41, v2
		v_cndmask_b32_e32 v1, v20, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v4, v4, v7
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_bitop3_b32 v1, v4, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a61, v1
		s_lshl_b32 s41, s17, 4
		s_add_i32 s41, s41, s32
		s_add_i32 s41, s41, s33
		v_add_u32_e32 v1, s41, v2
		v_cndmask_b32_e32 v1, v20, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v4, v18, v7
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_bitop3_b32 v1, v4, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a62, v1
		s_mul_i32 s41, 24, s17
		s_add_i32 s41, s41, s32
		s_add_i32 s41, s41, s33
		v_add_u32_e32 v1, s41, v2
		v_cndmask_b32_e32 v1, v20, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v3, v3, v7
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_bitop3_b32 v1, v3, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a63, v1
		s_mul_i32 s41, s23, 0x80
		v_mbcnt_lo_u32_b32 v1, -1, 0
		v_mbcnt_hi_u32_b32 v1, -1, v1
		v_and_b32_e32 v1, 31, v1
		v_add_u32_e32 v3, 32, v1
		v_mov_b32_e32 v6, 0x3e38aa3b
		v_mov_b32_e32 v7, 0x3e38aa3b
		s_mov_b32 s23, 0xff800000
		v_mov_b32_e32 v4, s23
		v_mov_b32_e32 v9, s23
		s_mov_b32 s23, 1.0
		v_mov_b32_e32 v10, s23
		v_mov_b32_e32 v11, s23
		s_mov_b32 s23, 0
		v_lshrrev_b32_e32 v12, 4, v15
		v_lshlrev_b32_e32 v12, 9, v12
		v_accvgpr_write_b32 a64, v12
		v_and_b32_e32 v12, 15, v15
		v_mov_b32_e32 v13, 0x410
		v_mul_lo_u32 v13, v13, v12
		v_and_b32_e32 v12, 3, v0
		v_accvgpr_write_b32 a65, v12
		v_accvgpr_read_b32 v12, a65
		v_lshlrev_b32_e32 v12, 3, v12
		v_accvgpr_write_b32 a66, v12
		v_accvgpr_read_b32 v12, a17
		v_mov_b32_e32 v14, 0x2200
		v_mul_lo_u32 v14, v14, v12
		v_accvgpr_write_b32 a67, v14
		v_lshlrev_b32_e32 v8, 5, v8
		v_accvgpr_write_b32 a68, v8
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
		v_accvgpr_write_b32 a69, v1
		v_lshlrev_b32_e32 v1, 2, v3
		v_accvgpr_write_b32 a70, v1
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
		v_accvgpr_read_b32 v1, a56
		v_add_u32_e32 v1, s48, v1
		v_accvgpr_read_b32 v3, a64
		v_add3_u32 v1, v1, v3, v13
		ds_read_b128 v[24:27], v1
		ds_read_b128 v[28:31], v1 offset:32
		ds_read_b128 v[96:99], v1 offset:64
		ds_read_b128 a[72:75], v1 offset:96
		ds_read_b128 v[100:103], v1 offset:256
		ds_read_b128 v[104:107], v1 offset:288
		ds_read_b128 v[108:111], v1 offset:320
		ds_read_b128 a[76:79], v1 offset:352
		ds_read_b128 v[112:115], v1 offset:128
		ds_read_b128 v[116:119], v1 offset:160
		ds_read_b128 v[120:123], v1 offset:192
		ds_read_b128 a[80:83], v1 offset:224
		ds_read_b128 v[124:127], v1 offset:384
		ds_read_b128 v[128:131], v1 offset:416
		ds_read_b128 a[84:87], v1 offset:448
		ds_read_b128 a[88:91], v1 offset:480
		s_mul_i32 s35, 0x4400, s35
		v_accvgpr_read_b32 v1, a66
		v_accvgpr_read_b32 v3, a67
		v_add3_u32 v1, s35, v1, v3
		v_accvgpr_read_b32 v3, a58
		v_accvgpr_read_b32 v8, a68
		v_add3_u32 v1, v1, v8, v3
		ds_read_b64_tr_b16 a[92:93], v1 offset:33264
		ds_read_b64_tr_b16 a[94:95], v1 offset:37616
		ds_read_b64_tr_b16 a[96:97], v1 offset:33392
		ds_read_b64_tr_b16 a[98:99], v1 offset:37744
		ds_read_b64_tr_b16 a[100:101], v1 offset:33520
		ds_read_b64_tr_b16 a[102:103], v1 offset:37872
		ds_read_b64_tr_b16 a[104:105], v1 offset:33648
		ds_read_b64_tr_b16 a[106:107], v1 offset:38000
		ds_read_b64_tr_b16 a[108:109], v1 offset:33776
		ds_read_b64_tr_b16 a[110:111], v1 offset:38128
		ds_read_b64_tr_b16 a[112:113], v1 offset:33904
		ds_read_b64_tr_b16 a[114:115], v1 offset:38256
		ds_read_b64_tr_b16 a[116:117], v1 offset:34032
		ds_read_b64_tr_b16 a[118:119], v1 offset:38384
		ds_read_b64_tr_b16 a[120:121], v1 offset:34160
		ds_read_b64_tr_b16 a[122:123], v1 offset:38512
		ds_read_b64_tr_b16 a[124:125], v1 offset:33328
		ds_read_b64_tr_b16 a[126:127], v1 offset:37680
		ds_read_b64_tr_b16 a[128:129], v1 offset:33456
		ds_read_b64_tr_b16 a[130:131], v1 offset:37808
		ds_read_b64_tr_b16 a[132:133], v1 offset:33584
		ds_read_b64_tr_b16 a[134:135], v1 offset:37936
		ds_read_b64_tr_b16 a[136:137], v1 offset:33712
		ds_read_b64_tr_b16 a[138:139], v1 offset:38064
		ds_read_b64_tr_b16 a[140:141], v1 offset:33840
		ds_read_b64_tr_b16 a[142:143], v1 offset:38192
		ds_read_b64_tr_b16 a[144:145], v1 offset:33968
		ds_read_b64_tr_b16 a[146:147], v1 offset:38320
		ds_read_b64_tr_b16 a[148:149], v1 offset:34096
		ds_read_b64_tr_b16 a[150:151], v1 offset:38448
		ds_read_b64_tr_b16 a[152:153], v1 offset:34224
		ds_read_b64_tr_b16 a[154:155], v1 offset:38576
		s_mul_i32 s35, s15, s23
		s_lshl_b32 s35, s35, 1
		s_add_i32 s48, s42, s35
		v_add_u32_e32 v1, s48, v17
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v3, s35, v17
		s_add_i32 s33, s33, 1
		v_add_u32_e32 v8, s43, v3
		s_and_b32 s33, s33, 1
		v_add_u32_e32 v12, s44, v3
		s_mul_i32 s35, 0x4100, s33
		v_add_u32_e32 v3, s36, v3
		s_add_i32 s35, s40, s35
		v_mfma_f32_32x32x16_bf16 v[144:159], v[24:27], a[20:23], 0
		s_mov_b32 m0, s35
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[24:27], v[144:159]
		s_mul_i32 s35, s17, s23
		v_mfma_f32_32x32x16_bf16 v[144:159], v[96:99], a[28:31], v[144:159]
		s_add_i32 s23, s23, 0x80
		v_mfma_f32_32x32x16_bf16 v[160:175], v[24:27], a[36:39], 0
		v_accvgpr_read_b32 v14, a18
		v_add_u32_e32 v14, s23, v14
		v_mfma_f32_32x32x16_bf16 v[160:175], v[28:31], a[40:43], v[160:175]
		v_accvgpr_read_b32 v15, a57
		v_add_u32_e32 v15, s23, v15
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], a[44:47], v[160:175]
		v_accvgpr_read_b32 v16, a59
		v_add_u32_e32 v16, s23, v16
		v_mfma_f32_32x32x16_bf16 v[176:191], v[100:103], a[20:23], 0
		v_accvgpr_read_b32 v18, a60
		v_add_u32_e32 v18, s23, v18
		v_mfma_f32_32x32x16_bf16 v[176:191], v[104:107], a[24:27], v[176:191]
		v_cmp_lt_i32_e64 s[48:49], v14, s20
		v_mfma_f32_32x32x16_bf16 v[176:191], v[108:111], a[28:31], v[176:191]
		v_accvgpr_read_b32 v14, a19
		v_add_u32_e32 v14, s23, v14
		v_mfma_f32_32x32x16_bf16 v[192:207], v[100:103], a[36:39], 0
		v_accvgpr_read_b32 v19, a61
		v_add_u32_e32 v19, s23, v19
		v_mfma_f32_32x32x16_bf16 v[192:207], v[104:107], a[40:43], v[192:207]
		v_accvgpr_read_b32 v21, a62
		v_add_u32_e32 v21, s23, v21
		v_mfma_f32_32x32x16_bf16 v[192:207], v[108:111], a[44:47], v[192:207]
		v_cmp_lt_i32_e64 s[50:51], v14, s20
		v_mfma_f32_32x32x16_bf16 v[96:111], v[112:115], a[20:23], 0
		v_cndmask_b32_e64 v1, v20, v1, s[48:49]
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[96:111], v[116:119], a[24:27], v[96:111]
		v_cmp_lt_i32_e64 s[48:49], v15, s20
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[52:53], v16, s20
		v_mfma_f32_32x32x16_bf16 v[96:111], v[120:123], a[28:31], v[96:111]
		v_cndmask_b32_e64 v1, v20, v8, s[48:49]
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[208:223], v[112:115], a[36:39], 0
		v_cndmask_b32_e64 v1, v20, v12, s[52:53]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[116:119], a[40:43], v[208:223]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_32x32x16_bf16 v[208:223], v[120:123], a[44:47], v[208:223]
		v_cmp_lt_i32_e64 s[48:49], v18, s20
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		v_accvgpr_read_b32 v1, a63
		v_add_u32_e32 v1, s23, v1
		v_mfma_f32_32x32x16_bf16 v[224:239], v[124:127], a[20:23], 0
		v_cndmask_b32_e64 v3, v20, v3, s[48:49]
		v_cmp_lt_i32_e64 s[48:49], v19, s20
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s35, s35, 1
		buffer_load_dwordx4 v3, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[52:53], v21, s20
		s_add_i32 s54, s45, s35
		v_mfma_f32_32x32x16_bf16 v[224:239], v[128:131], a[24:27], v[224:239]
		v_add_u32_e32 v3, s54, v2
		v_mfma_f32_32x32x16_bf16 v[224:239], a[84:87], a[28:31], v[224:239]
		v_cndmask_b32_e64 v3, v20, v3, s[50:51]
		v_cmp_lt_i32_e64 vcc, v1, s20
		s_mul_i32 s33, 0x4400, s33
		v_add_u32_e32 v1, s35, v2
		s_add_i32 s33, s37, s33
		v_add_u32_e32 v8, s46, v1
		s_add_i32 m0, s33, 0x81f0
		v_cndmask_b32_e64 v8, v20, v8, s[48:49]
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_add_u32_e32 v3, s47, v1
		v_cndmask_b32_e64 v3, v20, v3, s[52:53]
		s_add_i32 m0, m0, 0x1100
		v_add_u32_e32 v1, s32, v1
		v_cndmask_b32_e32 v1, v20, v1, vcc
		buffer_load_dwordx4 v8, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[240:255], v[124:127], a[36:39], 0
		s_add_i32 m0, m0, 0x1100
		v_mfma_f32_32x32x16_bf16 v[240:255], v[128:131], a[40:43], v[240:255]
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[240:255], a[84:87], a[44:47], v[240:255]
		s_add_i32 m0, m0, 0x1100
		s_cmp_lt_i32 s23, s41
		v_mfma_f32_32x32x16_bf16 v[144:159], a[72:75], a[32:35], v[144:159]
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[176:191], a[76:79], a[32:35], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[80:83], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[88:91], a[32:35], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[88:91], a[48:51], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[72:75], a[48:51], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[76:79], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[80:83], a[48:51], v[208:223]
		s_nop 3
		v_max3_f32 v1, v144, v145, v146
		v_max3_f32 v3, v148, v149, v150
		v_max3_f32 v8, v152, v153, v154
		v_max3_f32 v12, v156, v157, v158
		v_max3_f32 v14, v176, v177, v178
		v_max3_f32 v15, v180, v181, v182
		v_max3_f32 v16, v184, v185, v186
		v_max3_f32 v18, v188, v189, v190
		v_max3_f32 v19, v96, v97, v98
		v_max3_f32 v21, v100, v101, v102
		v_max3_f32 v22, v104, v105, v106
		v_max3_f32 v23, v108, v109, v110
		v_max3_f32 v24, v224, v225, v226
		v_max3_f32 v25, v228, v229, v230
		v_max3_f32 v26, v232, v233, v234
		v_max3_f32 v27, v236, v237, v238
		v_max3_f32 v1, v1, v147, v3
		v_max3_f32 v3, v8, v155, v12
		v_max3_f32 v8, v14, v179, v15
		v_max3_f32 v12, v16, v187, v18
		v_max3_f32 v14, v19, v99, v21
		v_max3_f32 v15, v22, v107, v23
		v_max3_f32 v16, v24, v227, v25
		v_max3_f32 v18, v26, v235, v27
		v_max3_f32 v1, v1, v151, v3
		v_max3_f32 v3, v8, v183, v12
		v_max3_f32 v8, v14, v103, v15
		v_max3_f32 v12, v16, v231, v18
		v_max3_f32 v1, v1, v159, v3
		v_max3_f32 v3, v8, v111, v12
		v_max3_f32 v1, v1, v191, v3
		v_max_f32_e32 v14, v1, v239
		v_mov_b32_e32 v15, v14
		v_max3_f32 v1, v160, v161, v162
		v_max3_f32 v3, v164, v165, v166
		v_max3_f32 v8, v168, v169, v170
		v_max3_f32 v12, v172, v173, v174
		v_max3_f32 v16, v192, v193, v194
		v_max3_f32 v18, v196, v197, v198
		v_max3_f32 v19, v200, v201, v202
		v_max3_f32 v21, v204, v205, v206
		v_max3_f32 v22, v208, v209, v210
		v_max3_f32 v23, v212, v213, v214
		v_max3_f32 v24, v216, v217, v218
		v_max3_f32 v25, v220, v221, v222
		v_max3_f32 v26, v240, v241, v242
		v_max3_f32 v27, v244, v245, v246
		v_max3_f32 v28, v248, v249, v250
		v_max3_f32 v29, v252, v253, v254
		v_permlane32_swap_b32_e32 v14, v15
		v_max3_f32 v1, v1, v163, v3
		v_max3_f32 v3, v8, v171, v12
		v_max3_f32 v8, v16, v195, v18
		v_max3_f32 v12, v19, v203, v21
		v_max3_f32 v16, v22, v211, v23
		v_max3_f32 v18, v24, v219, v25
		v_max3_f32 v19, v26, v243, v27
		v_max3_f32 v21, v28, v251, v29
		v_max3_f32 v1, v1, v167, v3
		v_max3_f32 v3, v8, v199, v12
		v_max3_f32 v8, v16, v215, v18
		v_max3_f32 v12, v19, v247, v21
		v_max3_f32 v1, v1, v175, v3
		v_max3_f32 v3, v8, v223, v12
		v_max3_f32 v1, v1, v207, v3
		v_max_f32_e32 v18, v1, v255
		v_mov_b32_e32 v19, v18
		v_max_f32_e32 v22, v14, v15
		v_mov_b32_e32 v14, v4
		v_permlane32_swap_b32_e32 v18, v19
		v_max_f32_e32 v23, v18, v19
		v_pk_mul_f32 v[18:19], v[22:23], v[6:7]
		v_max_f32_e32 v22, v4, v18
		v_max_f32_e32 v23, v9, v19
		v_pk_fma_f32 v[18:19], v[144:145], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[146:147], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[148:149], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[150:151], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[152:153], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[154:155], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[156:157], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[158:159], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[176:177], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[178:179], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[180:181], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[182:183], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[184:185], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[186:187], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[188:189], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[190:191], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[96:97], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[98:99], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[108:109], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[110:111], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[224:225], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[226:227], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[228:229], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[230:231], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[232:233], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[234:235], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[236:237], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[238:239], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[160:161], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[162:163], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[164:165], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[166:167], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[168:169], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[170:171], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[172:173], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[174:175], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[192:193], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[194:195], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[196:197], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[198:199], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[200:201], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[202:203], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[204:205], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[206:207], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[208:209], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[210:211], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[212:213], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[214:215], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[216:217], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[218:219], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[220:221], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[222:223], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[240:241], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[242:243], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[244:245], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[246:247], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[248:249], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[250:251], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[252:253], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[254:255], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v214, v18
		v_exp_f32_e32 v216, v19
		v_exp_f32_e32 v18, v24
		v_exp_f32_e32 v218, v25
		v_exp_f32_e32 v24, v26
		v_exp_f32_e32 v220, v27
		v_exp_f32_e32 v26, v28
		v_exp_f32_e32 v222, v29
		v_exp_f32_e32 v28, v30
		v_exp_f32_e32 v224, v31
		v_exp_f32_e32 v30, v112
		v_exp_f32_e32 v226, v113
		v_exp_f32_e32 v112, v114
		v_exp_f32_e32 v228, v115
		v_exp_f32_e32 v114, v116
		v_exp_f32_e32 v230, v117
		v_exp_f32_e32 v116, v118
		v_exp_f32_e32 v232, v119
		v_exp_f32_e32 v118, v120
		v_exp_f32_e32 v234, v121
		v_exp_f32_e32 v120, v122
		v_exp_f32_e32 v236, v123
		v_exp_f32_e32 v122, v124
		v_exp_f32_e32 v238, v125
		v_exp_f32_e32 v124, v126
		v_exp_f32_e32 v240, v127
		v_exp_f32_e32 v126, v128
		v_exp_f32_e32 v242, v129
		v_exp_f32_e32 v128, v130
		v_exp_f32_e32 v244, v131
		v_exp_f32_e32 v130, v132
		v_exp_f32_e32 v246, v133
		v_exp_f32_e32 v215, v134
		v_exp_f32_e32 v217, v135
		v_exp_f32_e32 v19, v96
		v_exp_f32_e32 v219, v97
		v_exp_f32_e32 v25, v98
		v_exp_f32_e32 v221, v99
		v_exp_f32_e32 v27, v100
		v_exp_f32_e32 v223, v101
		v_exp_f32_e32 v29, v102
		v_exp_f32_e32 v225, v103
		v_exp_f32_e32 v31, v104
		v_exp_f32_e32 v227, v105
		v_exp_f32_e32 v113, v106
		v_exp_f32_e32 v229, v107
		v_exp_f32_e32 v115, v108
		v_exp_f32_e32 v231, v109
		v_exp_f32_e32 v117, v110
		v_exp_f32_e32 v233, v111
		v_exp_f32_e32 v119, v136
		v_exp_f32_e32 v235, v137
		v_exp_f32_e32 v121, v138
		v_exp_f32_e32 v237, v139
		v_exp_f32_e32 v123, v140
		v_exp_f32_e32 v239, v141
		v_exp_f32_e32 v125, v142
		v_exp_f32_e32 v241, v143
		v_exp_f32_e32 v127, v144
		v_exp_f32_e32 v243, v145
		v_exp_f32_e32 v129, v146
		v_exp_f32_e32 v245, v147
		v_exp_f32_e32 v131, v148
		v_exp_f32_e32 v247, v149
		v_exp_f32_e32 v96, v150
		v_exp_f32_e32 v98, v151
		v_exp_f32_e32 v100, v152
		v_exp_f32_e32 v102, v153
		v_exp_f32_e32 v104, v154
		v_exp_f32_e32 v106, v155
		v_exp_f32_e32 v108, v156
		v_exp_f32_e32 v110, v157
		v_exp_f32_e32 v132, v158
		v_exp_f32_e32 v134, v159
		v_exp_f32_e32 v136, v160
		v_exp_f32_e32 v138, v161
		v_exp_f32_e32 v140, v162
		v_exp_f32_e32 v142, v163
		v_exp_f32_e32 v144, v164
		v_exp_f32_e32 v146, v165
		v_exp_f32_e32 v148, v166
		v_exp_f32_e32 v150, v167
		v_exp_f32_e32 v152, v168
		v_exp_f32_e32 v154, v169
		v_exp_f32_e32 v156, v170
		v_exp_f32_e32 v158, v171
		v_exp_f32_e32 v160, v172
		v_exp_f32_e32 v162, v173
		v_exp_f32_e32 v164, v174
		v_exp_f32_e32 v166, v175
		v_exp_f32_e32 v168, v176
		v_exp_f32_e32 v170, v177
		v_exp_f32_e32 v172, v178
		v_exp_f32_e32 v174, v179
		v_exp_f32_e32 v176, v180
		v_exp_f32_e32 v178, v181
		v_exp_f32_e32 v97, v182
		v_exp_f32_e32 v99, v183
		v_exp_f32_e32 v101, v184
		v_exp_f32_e32 v103, v185
		v_exp_f32_e32 v105, v186
		v_exp_f32_e32 v107, v187
		v_exp_f32_e32 v109, v188
		v_exp_f32_e32 v111, v189
		v_exp_f32_e32 v133, v190
		v_exp_f32_e32 v135, v191
		v_exp_f32_e32 v137, v192
		v_exp_f32_e32 v139, v193
		v_exp_f32_e32 v141, v194
		v_exp_f32_e32 v143, v195
		v_exp_f32_e32 v145, v196
		v_exp_f32_e32 v147, v197
		v_exp_f32_e32 v149, v198
		v_exp_f32_e32 v151, v199
		v_exp_f32_e32 v153, v200
		v_exp_f32_e32 v155, v201
		v_exp_f32_e32 v157, v202
		v_exp_f32_e32 v159, v203
		v_exp_f32_e32 v161, v204
		v_exp_f32_e32 v163, v205
		v_exp_f32_e32 v165, v206
		v_exp_f32_e32 v167, v207
		v_exp_f32_e32 v169, v208
		v_exp_f32_e32 v171, v209
		v_exp_f32_e32 v173, v210
		v_exp_f32_e32 v175, v211
		v_exp_f32_e32 v177, v212
		v_exp_f32_e32 v179, v213
		v_pk_add_f32 v[180:181], v[214:215], v[216:217]
		v_pk_add_f32 v[182:183], v[18:19], v[218:219]
		v_pk_add_f32 v[184:185], v[24:25], v[220:221]
		v_pk_add_f32 v[186:187], v[26:27], v[222:223]
		v_pk_add_f32 v[188:189], v[28:29], v[224:225]
		v_pk_add_f32 v[190:191], v[30:31], v[226:227]
		v_pk_add_f32 v[192:193], v[112:113], v[228:229]
		v_pk_add_f32 v[194:195], v[114:115], v[230:231]
		v_pk_add_f32 v[196:197], v[116:117], v[232:233]
		v_pk_add_f32 v[198:199], v[118:119], v[234:235]
		v_pk_add_f32 v[200:201], v[120:121], v[236:237]
		v_pk_add_f32 v[202:203], v[122:123], v[238:239]
		v_pk_add_f32 v[204:205], v[124:125], v[240:241]
		v_pk_add_f32 v[206:207], v[126:127], v[242:243]
		v_pk_add_f32 v[208:209], v[128:129], v[244:245]
		v_pk_add_f32 v[210:211], v[130:131], v[246:247]
		v_pk_add_f32 v[180:181], v[180:181], v[182:183]
		v_pk_add_f32 v[182:183], v[184:185], v[186:187]
		v_pk_add_f32 v[184:185], v[188:189], v[190:191]
		v_pk_add_f32 v[186:187], v[192:193], v[194:195]
		v_pk_add_f32 v[188:189], v[196:197], v[198:199]
		v_pk_add_f32 v[190:191], v[200:201], v[202:203]
		v_pk_add_f32 v[192:193], v[204:205], v[206:207]
		v_pk_add_f32 v[194:195], v[208:209], v[210:211]
		v_pk_add_f32 v[180:181], v[180:181], v[182:183]
		v_pk_add_f32 v[182:183], v[184:185], v[186:187]
		v_pk_add_f32 v[184:185], v[188:189], v[190:191]
		v_pk_add_f32 v[186:187], v[192:193], v[194:195]
		v_pk_add_f32 v[180:181], v[180:181], v[182:183]
		v_pk_add_f32 v[182:183], v[184:185], v[186:187]
		v_pk_add_f32 v[184:185], v[180:181], v[182:183]
		v_add_f32_e32 v1, v184, v185
		v_accvgpr_read_b32 v3, a69
		ds_bpermute_b32 v180, v3, v1
		v_accvgpr_read_b32 v3, a70
		ds_bpermute_b32 v182, v3, v1
		v_pk_add_f32 v[184:185], v[96:97], v[98:99]
		v_pk_add_f32 v[186:187], v[100:101], v[102:103]
		v_pk_add_f32 v[188:189], v[104:105], v[106:107]
		v_pk_add_f32 v[190:191], v[108:109], v[110:111]
		v_pk_add_f32 v[192:193], v[132:133], v[134:135]
		v_pk_add_f32 v[194:195], v[136:137], v[138:139]
		v_pk_add_f32 v[196:197], v[140:141], v[142:143]
		v_pk_add_f32 v[198:199], v[144:145], v[146:147]
		v_pk_add_f32 v[200:201], v[148:149], v[150:151]
		v_pk_add_f32 v[202:203], v[152:153], v[154:155]
		v_pk_add_f32 v[204:205], v[156:157], v[158:159]
		v_pk_add_f32 v[206:207], v[160:161], v[162:163]
		v_pk_add_f32 v[208:209], v[164:165], v[166:167]
		v_pk_add_f32 v[210:211], v[168:169], v[170:171]
		v_pk_add_f32 v[212:213], v[172:173], v[174:175]
		v_pk_add_f32 v[248:249], v[176:177], v[178:179]
		v_pk_add_f32 v[184:185], v[184:185], v[186:187]
		v_pk_add_f32 v[186:187], v[188:189], v[190:191]
		v_pk_add_f32 v[188:189], v[192:193], v[194:195]
		v_pk_add_f32 v[190:191], v[196:197], v[198:199]
		v_pk_add_f32 v[192:193], v[200:201], v[202:203]
		v_pk_add_f32 v[194:195], v[204:205], v[206:207]
		v_pk_add_f32 v[196:197], v[208:209], v[210:211]
		v_pk_add_f32 v[198:199], v[212:213], v[248:249]
		v_pk_add_f32 v[184:185], v[184:185], v[186:187]
		v_pk_add_f32 v[186:187], v[188:189], v[190:191]
		v_pk_add_f32 v[188:189], v[192:193], v[194:195]
		v_pk_add_f32 v[190:191], v[196:197], v[198:199]
		v_pk_add_f32 v[184:185], v[184:185], v[186:187]
		v_pk_add_f32 v[186:187], v[188:189], v[190:191]
		v_pk_add_f32 v[188:189], v[184:185], v[186:187]
		v_mov_b32_e32 v183, v189
		v_mov_b32_e32 v181, v188
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[184:185], v[180:181], v[182:183]
		v_mov_b32_e32 v180, v185
		v_mov_b32_e32 v181, v185
		v_cvt_pk_bf16_f32 v188, v214, v216
		v_cvt_pk_bf16_f32 v189, v18, v218
		v_permlane32_swap_b32_e32 v180, v181
		v_add_f32_e32 v183, v180, v181
		v_mov_b32_e32 v15, v9
		v_pk_add_f32 v[8:9], v[14:15], v[22:23] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v14, v8
		v_exp_f32_e32 v15, v9
		v_cvt_pk_bf16_f32 v190, v24, v220
		v_mov_b32_e32 v182, v184
		v_mov_b64_e32 v[8:9], v[10:11]
		v_pk_fma_f32 v[10:11], v[8:9], v[14:15], v[182:183]
		v_cvt_pk_bf16_f32 v191, v26, v222
		v_cvt_pk_bf16_f32 v180, v28, v224
		v_cvt_pk_bf16_f32 v181, v30, v226
		v_cvt_pk_bf16_f32 v182, v112, v228
		v_cvt_pk_bf16_f32 v183, v114, v230
		v_cvt_pk_bf16_f32 v184, v116, v232
		v_cvt_pk_bf16_f32 v185, v118, v234
		v_cvt_pk_bf16_f32 v186, v120, v236
		v_cvt_pk_bf16_f32 v187, v122, v238
		v_cvt_pk_bf16_f32 v192, v124, v240
		v_cvt_pk_bf16_f32 v193, v126, v242
		v_cvt_pk_bf16_f32 v194, v128, v244
		v_cvt_pk_bf16_f32 v195, v130, v246
		v_cvt_pk_bf16_f32 v196, v215, v217
		v_pk_mul_f32 v[32:33], v[32:33], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[34:35], v[34:35], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[36:37], v[36:37], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[38:39], v[38:39], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[40:41], v[40:41], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[42:43], v[42:43], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[44:45], v[44:45], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[46:47], v[46:47], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[48:49], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[50:51], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[52:53], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[54:55], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[56:57], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[58:59], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[60:61], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[62:63], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[64:65], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[66:67], v[66:67], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[68:69], v[68:69], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[70:71], v[70:71], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[72:73], v[72:73], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[74:75], v[74:75], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[76:77], v[76:77], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[78:79], v[78:79], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[80:81], v[80:81], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[82:83], v[82:83], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[84:85], v[84:85], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[86:87], v[86:87], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[88:89], v[88:89], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[90:91], v[90:91], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[92:93], v[92:93], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[94:95], v[94:95], v[14:15] op_sel:[0,1]
		v_cvt_pk_bf16_f32 v197, v19, v219
		v_cvt_pk_bf16_f32 v198, v25, v221
		v_cvt_pk_bf16_f32 v199, v27, v223
		v_cvt_pk_bf16_f32 v24, v29, v225
		v_cvt_pk_bf16_f32 v25, v31, v227
		v_cvt_pk_bf16_f32 v26, v113, v229
		v_cvt_pk_bf16_f32 v27, v115, v231
		v_cvt_pk_bf16_f32 v28, v117, v233
		v_cvt_pk_bf16_f32 v29, v119, v235
		v_cvt_pk_bf16_f32 v30, v121, v237
		v_cvt_pk_bf16_f32 v31, v123, v239
		v_cvt_pk_bf16_f32 v112, v125, v241
		v_cvt_pk_bf16_f32 v113, v127, v243
		v_cvt_pk_bf16_f32 v114, v129, v245
		v_cvt_pk_bf16_f32 v115, v131, v247
		v_cvt_pk_bf16_f32 v116, v96, v98
		v_cvt_pk_bf16_f32 v117, v100, v102
		v_cvt_pk_bf16_f32 v118, v104, v106
		v_cvt_pk_bf16_f32 v119, v108, v110
		v_cvt_pk_bf16_f32 v120, v132, v134
		v_cvt_pk_bf16_f32 v121, v136, v138
		v_cvt_pk_bf16_f32 v122, v140, v142
		v_cvt_pk_bf16_f32 v123, v144, v146
		v_cvt_pk_bf16_f32 v124, v148, v150
		v_cvt_pk_bf16_f32 v125, v152, v154
		v_cvt_pk_bf16_f32 v126, v156, v158
		v_cvt_pk_bf16_f32 v127, v160, v162
		v_cvt_pk_bf16_f32 v128, v164, v166
		v_cvt_pk_bf16_f32 v129, v168, v170
		v_cvt_pk_bf16_f32 v130, v172, v174
		v_cvt_pk_bf16_f32 v131, v176, v178
		v_cvt_pk_bf16_f32 v200, v97, v99
		v_cvt_pk_bf16_f32 v201, v101, v103
		v_cvt_pk_bf16_f32 v202, v105, v107
		v_cvt_pk_bf16_f32 v203, v109, v111
		v_cvt_pk_bf16_f32 v96, v133, v135
		v_cvt_pk_bf16_f32 v97, v137, v139
		v_cvt_pk_bf16_f32 v98, v141, v143
		v_cvt_pk_bf16_f32 v99, v145, v147
		v_cvt_pk_bf16_f32 v100, v149, v151
		v_cvt_pk_bf16_f32 v101, v153, v155
		v_cvt_pk_bf16_f32 v102, v157, v159
		v_cvt_pk_bf16_f32 v103, v161, v163
		v_cvt_pk_bf16_f32 v104, v165, v167
		v_cvt_pk_bf16_f32 v105, v169, v171
		v_cvt_pk_bf16_f32 v106, v173, v175
		v_cvt_pk_bf16_f32 v107, v177, v179
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		v_mfma_f32_32x32x16_bf16 v[32:47], a[92:95], v[188:191], v[32:47]
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_mfma_f32_32x32x16_bf16 v[48:63], a[124:127], v[188:191], v[48:63]
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_mfma_f32_32x32x16_bf16 v[32:47], a[96:99], v[180:183], v[32:47]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[48:63], a[128:131], v[180:183], v[48:63]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[32:47], a[100:103], v[184:187], v[32:47]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[48:63], a[132:135], v[184:187], v[48:63]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[32:47], a[104:107], v[192:195], v[32:47]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[48:63], a[136:139], v[192:195], v[48:63]
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_mfma_f32_32x32x16_bf16 v[80:95], a[124:127], v[116:119], v[80:95]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[64:79], a[92:95], v[116:119], v[64:79]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[80:95], a[128:131], v[120:123], v[80:95]
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_mfma_f32_32x32x16_bf16 v[64:79], a[96:99], v[120:123], v[64:79]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[80:95], a[132:135], v[124:127], v[80:95]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[64:79], a[100:103], v[124:127], v[64:79]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[80:95], a[136:139], v[128:131], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[104:107], v[128:131], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[108:111], v[196:199], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[140:143], v[196:199], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[140:143], v[200:203], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[108:111], v[200:203], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[112:115], v[24:27], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[144:147], v[24:27], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[112:115], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[116:119], v[28:31], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[148:151], v[28:31], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[148:151], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[116:119], v[100:103], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[120:123], v[112:115], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[152:155], v[112:115], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], v[104:107], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[120:123], v[104:107], v[64:79]
		v_mov_b32_e32 v4, v22
		v_mov_b32_e32 v9, v23
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
		v_accvgpr_read_b32 v8, a6
		s_nop 0
		v_readfirstlane_b32 s23, v8
		s_nop 1
		v_add_u32_e32 v3, s23, v3
		v_add_u32_e32 v3, s1, v3
		v_xor_b32_e32 v8, 1, v5
		v_accvgpr_write_b32 a15, v8
		v_xor_b32_e32 v8, 2, v5
		v_accvgpr_write_b32 a16, v8
		v_xor_b32_e32 v8, 3, v5
		v_accvgpr_write_b32 a66, v8
		v_xor_b32_e32 v8, 8, v5
		v_accvgpr_write_b32 a71, v8
		v_xor_b32_e32 v8, 9, v5
		v_accvgpr_write_b32 a72, v8
		v_xor_b32_e32 v8, 10, v5
		v_accvgpr_write_b32 a73, v8
		v_xor_b32_e32 v8, 11, v5
		v_accvgpr_write_b32 a74, v8
		v_xor_b32_e32 v8, 16, v5
		v_accvgpr_write_b32 a75, v8
		v_xor_b32_e32 v8, 17, v5
		v_accvgpr_write_b32 a76, v8
		v_xor_b32_e32 v8, 18, v5
		v_accvgpr_write_b32 a77, v8
		v_xor_b32_e32 v8, 19, v5
		v_accvgpr_write_b32 a78, v8
		v_xor_b32_e32 v8, 24, v5
		v_accvgpr_write_b32 a79, v8
		v_xor_b32_e32 v8, 25, v5
		v_accvgpr_write_b32 a80, v8
		v_xor_b32_e32 v8, 26, v5
		v_accvgpr_write_b32 a81, v8
		v_xor_b32_e32 v8, 27, v5
		v_accvgpr_write_b32 a82, v8
		v_xor_b32_e32 v8, 32, v5
		v_accvgpr_write_b32 a83, v8
		v_xor_b32_e32 v8, 33, v5
		v_accvgpr_write_b32 a84, v8
		v_xor_b32_e32 v8, 34, v5
		v_accvgpr_write_b32 a85, v8
		v_xor_b32_e32 v8, 35, v5
		v_accvgpr_write_b32 a86, v8
		v_xor_b32_e32 v8, 40, v5
		v_accvgpr_write_b32 a87, v8
		v_xor_b32_e32 v8, 41, v5
		v_accvgpr_write_b32 a88, v8
		v_xor_b32_e32 v8, 42, v5
		v_accvgpr_write_b32 a89, v8
		v_xor_b32_e32 v8, 43, v5
		v_accvgpr_write_b32 a90, v8
		v_xor_b32_e32 v8, 48, v5
		v_accvgpr_write_b32 a91, v8
		v_xor_b32_e32 v8, 49, v5
		v_accvgpr_write_b32 a92, v8
		v_xor_b32_e32 v8, 50, v5
		v_accvgpr_write_b32 a93, v8
		v_xor_b32_e32 v8, 51, v5
		v_accvgpr_write_b32 a94, v8
		v_xor_b32_e32 v8, 56, v5
		v_accvgpr_write_b32 a95, v8
		v_xor_b32_e32 v8, 57, v5
		v_accvgpr_write_b32 a96, v8
		v_xor_b32_e32 v8, 58, v5
		v_accvgpr_write_b32 a97, v8
		v_xor_b32_e32 v8, 59, v5
		v_accvgpr_write_b32 a98, v8
		v_xor_b32_e32 v8, 64, v5
		v_accvgpr_write_b32 a99, v8
		v_xor_b32_e32 v8, 0x41, v5
		v_accvgpr_write_b32 a100, v8
		v_xor_b32_e32 v8, 0x42, v5
		v_accvgpr_write_b32 a101, v8
		v_xor_b32_e32 v8, 0x43, v5
		v_accvgpr_write_b32 a102, v8
		v_xor_b32_e32 v8, 0x48, v5
		v_accvgpr_write_b32 a103, v8
		v_xor_b32_e32 v8, 0x49, v5
		v_accvgpr_write_b32 a104, v8
		v_xor_b32_e32 v8, 0x4a, v5
		v_accvgpr_write_b32 a105, v8
		v_xor_b32_e32 v8, 0x4b, v5
		v_accvgpr_write_b32 a106, v8
		v_xor_b32_e32 v8, 0x50, v5
		v_accvgpr_write_b32 a107, v8
		v_xor_b32_e32 v8, 0x51, v5
		v_accvgpr_write_b32 a108, v8
		v_xor_b32_e32 v8, 0x52, v5
		v_accvgpr_write_b32 a109, v8
		v_xor_b32_e32 v8, 0x53, v5
		v_accvgpr_write_b32 a110, v8
		v_xor_b32_e32 v8, 0x58, v5
		v_accvgpr_write_b32 a111, v8
		v_xor_b32_e32 v8, 0x59, v5
		v_accvgpr_write_b32 a112, v8
		v_xor_b32_e32 v8, 0x5a, v5
		v_accvgpr_write_b32 a113, v8
		v_xor_b32_e32 v8, 0x5b, v5
		v_accvgpr_write_b32 a114, v8
		v_xor_b32_e32 v8, 0x60, v5
		v_accvgpr_write_b32 a115, v8
		v_xor_b32_e32 v8, 0x61, v5
		v_accvgpr_write_b32 a116, v8
		v_xor_b32_e32 v8, 0x62, v5
		v_accvgpr_write_b32 a117, v8
		v_xor_b32_e32 v8, 0x63, v5
		v_accvgpr_write_b32 a118, v8
		v_xor_b32_e32 v8, 0x68, v5
		v_accvgpr_write_b32 a119, v8
		v_xor_b32_e32 v8, 0x69, v5
		v_accvgpr_write_b32 a120, v8
		v_xor_b32_e32 v8, 0x6a, v5
		v_accvgpr_write_b32 a121, v8
		v_xor_b32_e32 v8, 0x6b, v5
		v_accvgpr_write_b32 a122, v8
		v_xor_b32_e32 v8, 0x70, v5
		v_accvgpr_write_b32 a123, v8
		v_xor_b32_e32 v8, 0x71, v5
		v_accvgpr_write_b32 a124, v8
		v_xor_b32_e32 v8, 0x72, v5
		v_accvgpr_write_b32 a125, v8
		v_xor_b32_e32 v8, 0x73, v5
		v_accvgpr_write_b32 a126, v8
		v_xor_b32_e32 v8, 0x78, v5
		v_accvgpr_write_b32 a127, v8
		v_xor_b32_e32 v8, 0x79, v5
		v_accvgpr_write_b32 a128, v8
		v_xor_b32_e32 v8, 0x7a, v5
		v_accvgpr_write_b32 a129, v8
		v_xor_b32_e32 v8, 0x7b, v5
		v_accvgpr_write_b32 a130, v8
		v_accvgpr_read_b32 v8, a56
		v_accvgpr_read_b32 v12, a64
		v_add3_u32 v8, v8, v12, v13
		v_accvgpr_write_b32 a56, v8
		v_accvgpr_read_b32 v8, a65
		v_accvgpr_read_b32 v12, a67
		v_lshl_add_u32 v8, v8, 3, v12
		v_accvgpr_read_b32 v12, a58
		v_accvgpr_read_b32 v13, a68
		v_add3_u32 v8, v8, v13, v12
		v_accvgpr_write_b32 a58, v8
		v_mov_b32_e32 v8, 0xff800000
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
		v_accvgpr_read_b32 v12, a56
		v_add_u32_e32 v12, s23, v12
		ds_read_b128 v[24:27], v12
		ds_read_b128 a[132:135], v12 offset:32
		ds_read_b128 a[136:139], v12 offset:64
		ds_read_b128 a[140:143], v12 offset:96
		ds_read_b128 a[144:147], v12 offset:256
		ds_read_b128 a[148:151], v12 offset:288
		ds_read_b128 a[152:155], v12 offset:320
		ds_read_b128 a[156:159], v12 offset:352
		ds_read_b128 a[160:163], v12 offset:128
		ds_read_b128 a[164:167], v12 offset:160
		ds_read_b128 a[168:171], v12 offset:192
		ds_read_b128 a[172:175], v12 offset:224
		ds_read_b128 v[28:31], v12 offset:384
		ds_read_b128 a[176:179], v12 offset:416
		ds_read_b128 a[180:183], v12 offset:448
		ds_read_b128 a[184:187], v12 offset:480
		s_mul_i32 s23, 0x4400, s33
		v_accvgpr_read_b32 v12, a58
		v_add_u32_e32 v12, s23, v12
		ds_read_b64_tr_b16 a[188:189], v12 offset:33264
		ds_read_b64_tr_b16 a[190:191], v12 offset:37616
		ds_read_b64_tr_b16 a[192:193], v12 offset:33392
		ds_read_b64_tr_b16 a[194:195], v12 offset:37744
		ds_read_b64_tr_b16 a[196:197], v12 offset:33520
		ds_read_b64_tr_b16 a[198:199], v12 offset:37872
		ds_read_b64_tr_b16 a[200:201], v12 offset:33648
		ds_read_b64_tr_b16 a[202:203], v12 offset:38000
		ds_read_b64_tr_b16 a[204:205], v12 offset:33776
		ds_read_b64_tr_b16 a[206:207], v12 offset:38128
		ds_read_b64_tr_b16 a[208:209], v12 offset:33904
		ds_read_b64_tr_b16 a[210:211], v12 offset:38256
		ds_read_b64_tr_b16 a[212:213], v12 offset:34032
		ds_read_b64_tr_b16 a[214:215], v12 offset:38384
		ds_read_b64_tr_b16 a[216:217], v12 offset:34160
		ds_read_b64_tr_b16 a[218:219], v12 offset:38512
		ds_read_b64_tr_b16 a[220:221], v12 offset:33328
		ds_read_b64_tr_b16 a[222:223], v12 offset:37680
		ds_read_b64_tr_b16 a[224:225], v12 offset:33456
		ds_read_b64_tr_b16 a[226:227], v12 offset:37808
		ds_read_b64_tr_b16 a[228:229], v12 offset:33584
		ds_read_b64_tr_b16 a[230:231], v12 offset:37936
		ds_read_b64_tr_b16 a[232:233], v12 offset:33712
		ds_read_b64_tr_b16 a[234:235], v12 offset:38064
		ds_read_b64_tr_b16 a[236:237], v12 offset:33840
		ds_read_b64_tr_b16 a[238:239], v12 offset:38192
		ds_read_b64_tr_b16 a[240:241], v12 offset:33968
		ds_read_b64_tr_b16 a[242:243], v12 offset:38320
		ds_read_b64_tr_b16 a[244:245], v12 offset:34096
		ds_read_b64_tr_b16 a[246:247], v12 offset:38448
		ds_read_b64_tr_b16 a[248:249], v12 offset:34224
		ds_read_b64_tr_b16 a[250:251], v12 offset:38576
		s_cmp_lt_i32 s1, s18
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_2
		v_accvgpr_read_b32 v12, a18
		v_add_u32_e32 v12, s1, v12
		v_cmp_lt_i32_e64 s[50:51], v12, s20
		v_accvgpr_read_b32 v12, a19
		v_add_u32_e32 v12, s1, v12
		v_cmp_lt_i32_e64 s[52:53], v12, s20
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s23, s15, s41
		s_lshl_b32 s23, s23, 1
		s_add_i32 s33, s42, s23
		v_add_u32_e32 v12, s33, v17
		v_cndmask_b32_e64 v12, v20, v12, s[50:51]
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
		v_accvgpr_read_b32 v13, a57
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v13, s20
		s_add_i32 s33, s43, s23
		v_add_u32_e32 v12, s33, v17
		v_cndmask_b32_e64 v12, v20, v12, s[54:55]
		s_add_u32 s54, s56, 0x1040
		s_addc_u32 s55, s57, 0
		s_add_u32 s54, s54, s58
		s_addc_u32 s55, s55, s59
		s_add_u32 s60, s54, 0
		s_addc_u32 s61, s55, 0
		s_mov_b32 m0, s60
		v_accvgpr_read_b32 v13, a59
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v13, s20
		s_add_i32 s33, s44, s23
		v_add_u32_e32 v12, s33, v17
		v_cndmask_b32_e64 v12, v20, v12, s[54:55]
		s_add_u32 s54, s56, 0x2080
		s_addc_u32 s55, s57, 0
		s_add_u32 s54, s54, s58
		s_addc_u32 s55, s55, s59
		s_add_u32 s60, s54, 0
		s_addc_u32 s61, s55, 0
		s_mov_b32 m0, s60
		v_accvgpr_read_b32 v13, a60
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v13, s20
		s_add_i32 s23, s36, s23
		v_add_u32_e32 v12, s23, v17
		v_cndmask_b32_e64 v12, v20, v12, s[54:55]
		s_add_u32 s54, s56, 0x30c0
		s_addc_u32 s55, s57, 0
		s_add_u32 s54, s54, s58
		s_addc_u32 s55, s55, s59
		s_add_u32 s56, s54, 0
		s_addc_u32 s57, s55, 0
		s_mov_b32 m0, s56
		v_accvgpr_read_b32 v13, a61
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		s_mul_i32 s23, s17, s41
		s_lshl_b32 s23, s23, 1
		s_add_i32 s33, s45, s23
		v_add_u32_e32 v12, s33, v2
		v_cndmask_b32_e64 v12, v20, v12, s[52:53]
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
		v_accvgpr_read_b32 v14, a62
		v_add_u32_e32 v14, s1, v14
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[48:49], v13, s20
		s_add_i32 s33, s46, s23
		v_add_u32_e32 v12, s33, v2
		v_cndmask_b32_e64 v12, v20, v12, s[48:49]
		s_add_u32 s48, s54, 0x92f0
		s_addc_u32 s49, s55, 0
		s_add_u32 s48, s48, s56
		s_addc_u32 s49, s49, s57
		s_add_u32 s50, s48, 0
		s_addc_u32 s51, s49, 0
		s_mov_b32 m0, s50
		v_accvgpr_read_b32 v13, a63
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[48:49], v14, s20
		s_add_i32 s33, s47, s23
		v_add_u32_e32 v12, s33, v2
		s_add_u32 s50, s54, 0xa3f0
		s_addc_u32 s51, s55, 0
		s_add_u32 s50, s50, s56
		s_addc_u32 s51, s51, s57
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		v_cndmask_b32_e64 v12, v20, v12, s[48:49]
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		s_add_i32 s23, s32, s23
		v_cmp_lt_i32_e64 vcc, v13, s20
		v_add_u32_e32 v12, s23, v2
		s_add_u32 s48, s54, 0xb4f0
		s_addc_u32 s49, s55, 0
		v_cndmask_b32_e32 v12, v20, v12, vcc
		s_add_u32 s48, s48, s56
		s_addc_u32 s49, s49, s57
		s_add_u32 s50, s48, 0
		s_addc_u32 s51, s49, 0
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_2
.L_attn_fwd_persistent.if_else_2:
.L_attn_fwd_persistent.if_end_2:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[96:111], v[24:27], a[20:23], 0
		s_cmp_lt_i32 s1, s21
		v_mfma_f32_32x32x16_bf16 v[112:127], a[144:147], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[128:143], a[160:163], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[28:31], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[176:191], v[24:27], a[36:39], 0
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
		v_add_u32_e32 v12, s41, v5
		v_mfma_f32_32x32x16_bf16 v[176:191], a[136:139], a[44:47], v[176:191]
		v_accvgpr_read_b32 v13, a15
		v_add_u32_e32 v13, s41, v13
		v_mfma_f32_32x32x16_bf16 v[192:207], a[152:155], a[44:47], v[192:207]
		v_accvgpr_read_b32 v14, a16
		v_add_u32_e32 v14, s41, v14
		v_mfma_f32_32x32x16_bf16 v[208:223], a[168:171], a[44:47], v[208:223]
		v_accvgpr_read_b32 v15, a66
		v_add_u32_e32 v15, s41, v15
		v_mfma_f32_32x32x16_bf16 v[96:111], a[140:143], a[32:35], v[96:111]
		v_cmp_ge_i32_e64 vcc, v1, v15
		v_mfma_f32_32x32x16_bf16 v[112:127], a[156:159], a[32:35], v[112:127]
		v_accvgpr_read_b32 v16, a73
		v_add_u32_e32 v16, s41, v16
		v_mfma_f32_32x32x16_bf16 v[128:143], a[172:175], a[32:35], v[128:143]
		v_accvgpr_read_b32 v18, a74
		v_add_u32_e32 v18, s41, v18
		v_mfma_f32_32x32x16_bf16 v[144:159], a[184:187], a[32:35], v[144:159]
		v_accvgpr_read_b32 v19, a77
		v_add_u32_e32 v19, s41, v19
		v_mfma_f32_32x32x16_bf16 v[160:175], a[184:187], a[48:51], v[160:175]
		v_accvgpr_read_b32 v21, a78
		v_add_u32_e32 v21, s41, v21
		v_mfma_f32_32x32x16_bf16 v[176:191], a[140:143], a[48:51], v[176:191]
		v_accvgpr_read_b32 v22, a81
		v_add_u32_e32 v22, s41, v22
		v_mfma_f32_32x32x16_bf16 v[192:207], a[156:159], a[48:51], v[192:207]
		v_cndmask_b32_e32 v25, v8, v99, vcc
		v_mfma_f32_32x32x16_bf16 v[208:223], a[172:175], a[48:51], v[208:223]
		v_accvgpr_read_b32 v23, a82
		v_add_u32_e32 v23, s41, v23
		v_accvgpr_read_b32 v24, a85
		v_add_u32_e32 v26, s41, v24
		v_accvgpr_read_b32 v24, a86
		v_add_u32_e32 v27, s41, v24
		v_accvgpr_read_b32 v24, a89
		v_add_u32_e32 v28, s41, v24
		v_accvgpr_read_b32 v24, a90
		v_add_u32_e32 v29, s41, v24
		v_accvgpr_read_b32 v24, a93
		v_add_u32_e32 v30, s41, v24
		v_accvgpr_read_b32 v24, a94
		v_add_u32_e32 v31, s41, v24
		v_accvgpr_read_b32 v24, a97
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a64, v24
		v_accvgpr_read_b32 v24, a98
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a65, v24
		v_accvgpr_read_b32 v24, a101
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a67, v24
		v_accvgpr_read_b32 v24, a102
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a68, v24
		v_accvgpr_read_b32 v24, a105
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a131, v24
		v_accvgpr_read_b32 v24, a106
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a132, v24
		v_accvgpr_read_b32 v24, a109
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a133, v24
		v_accvgpr_read_b32 v24, a110
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a134, v24
		v_accvgpr_read_b32 v24, a113
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a135, v24
		v_accvgpr_read_b32 v24, a114
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a136, v24
		v_accvgpr_read_b32 v24, a117
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a137, v24
		v_accvgpr_read_b32 v24, a118
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a138, v24
		v_accvgpr_read_b32 v24, a121
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a139, v24
		v_accvgpr_read_b32 v24, a122
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a140, v24
		v_accvgpr_read_b32 v24, a125
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a141, v24
		v_accvgpr_read_b32 v24, a126
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a142, v24
		v_accvgpr_read_b32 v24, a129
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a143, v24
		v_accvgpr_read_b32 v24, a130
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a144, v24
		v_cmp_ge_i32_e64 s[48:49], v1, v12
		v_cmp_ge_i32_e64 s[50:51], v1, v13
		v_cmp_ge_i32_e64 s[52:53], v1, v14
		v_accvgpr_read_b32 v24, a71
		v_add_u32_e32 v99, s41, v24
		v_accvgpr_read_b32 v24, a72
		v_add_u32_e32 v224, s41, v24
		v_cmp_ge_i32_e64 s[54:55], v1, v99
		v_cmp_ge_i32_e64 s[56:57], v1, v224
		v_cmp_ge_i32_e64 s[58:59], v1, v16
		v_cmp_ge_i32_e64 vcc, v1, v18
		v_accvgpr_read_b32 v24, a75
		v_add_u32_e32 v225, s41, v24
		v_accvgpr_read_b32 v24, a76
		v_add_u32_e32 v226, s41, v24
		v_cndmask_b32_e32 v229, v8, v103, vcc
		v_cmp_ge_i32_e64 s[60:61], v1, v225
		v_cmp_ge_i32_e64 s[62:63], v1, v226
		v_cmp_ge_i32_e64 s[64:65], v1, v19
		v_cmp_ge_i32_e64 vcc, v1, v21
		v_accvgpr_read_b32 v24, a79
		v_add_u32_e32 v103, s41, v24
		v_accvgpr_read_b32 v24, a80
		v_add_u32_e32 v227, s41, v24
		v_cndmask_b32_e32 v231, v8, v107, vcc
		v_cmp_ge_i32_e64 s[66:67], v1, v103
		v_cmp_ge_i32_e64 s[68:69], v1, v227
		v_cmp_ge_i32_e64 s[70:71], v1, v22
		v_cmp_ge_i32_e64 vcc, v1, v23
		v_accvgpr_read_b32 v24, a83
		v_add_u32_e32 v107, s41, v24
		v_accvgpr_read_b32 v24, a84
		v_add_u32_e32 v232, s41, v24
		v_cndmask_b32_e32 v235, v8, v111, vcc
		v_cmp_ge_i32_e64 s[72:73], v1, v107
		v_cmp_ge_i32_e64 s[74:75], v1, v232
		v_cmp_ge_i32_e64 s[76:77], v1, v26
		v_cmp_ge_i32_e64 vcc, v1, v27
		v_accvgpr_read_b32 v24, a87
		v_add_u32_e32 v111, s41, v24
		v_accvgpr_read_b32 v24, a88
		v_add_u32_e32 v233, s41, v24
		v_cndmask_b32_e32 v237, v8, v115, vcc
		v_cmp_ge_i32_e64 s[78:79], v1, v111
		v_cmp_ge_i32_e64 s[80:81], v1, v233
		v_cmp_ge_i32_e64 s[82:83], v1, v28
		v_cmp_ge_i32_e64 vcc, v1, v29
		v_accvgpr_read_b32 v24, a91
		v_add_u32_e32 v115, s41, v24
		v_accvgpr_read_b32 v24, a92
		v_add_u32_e32 v236, s41, v24
		v_cndmask_b32_e32 v239, v8, v119, vcc
		v_cmp_ge_i32_e64 s[84:85], v1, v115
		v_cmp_ge_i32_e64 s[86:87], v1, v236
		v_cmp_ge_i32_e64 vcc, v1, v31
		v_accvgpr_read_b32 v24, a95
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a145, v24
		v_accvgpr_read_b32 v24, a96
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a146, v24
		v_cndmask_b32_e32 v241, v8, v123, vcc
		v_accvgpr_read_b32 v24, a65
		v_cmp_ge_i32_e64 vcc, v1, v24
		v_accvgpr_read_b32 v24, a99
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a147, v24
		v_accvgpr_read_b32 v24, a100
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a148, v24
		v_cndmask_b32_e32 v243, v8, v127, vcc
		v_accvgpr_read_b32 v24, a68
		v_cmp_ge_i32_e64 vcc, v1, v24
		v_accvgpr_read_b32 v24, a103
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a149, v24
		v_accvgpr_read_b32 v24, a104
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a150, v24
		v_cndmask_b32_e32 v245, v8, v131, vcc
		v_accvgpr_read_b32 v24, a132
		v_cmp_ge_i32_e64 vcc, v1, v24
		v_accvgpr_read_b32 v24, a107
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a151, v24
		v_accvgpr_read_b32 v24, a108
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a152, v24
		v_cndmask_b32_e32 v247, v8, v135, vcc
		v_accvgpr_read_b32 v24, a134
		v_cmp_ge_i32_e64 vcc, v1, v24
		v_accvgpr_read_b32 v24, a111
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a153, v24
		v_accvgpr_read_b32 v24, a112
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a154, v24
		v_cndmask_b32_e32 v249, v8, v139, vcc
		v_accvgpr_read_b32 v24, a136
		v_cmp_ge_i32_e64 vcc, v1, v24
		v_cmp_ge_i32_e64 s[88:89], v1, v30
		v_cndmask_b32_e64 v250, v8, v96, s[48:49]
		v_accvgpr_read_b32 v24, a145
		v_cmp_ge_i32_e64 s[48:49], v1, v24
		s_nop 1
		v_mov_b32_e32 v252, s48
		v_mov_b32_e32 v253, s49
		v_accvgpr_write_b32 a156, v252
		v_accvgpr_write_b32 a157, v253
		v_accvgpr_read_b32 v24, a146
		v_cmp_ge_i32_e64 s[48:49], v1, v24
		s_nop 1
		v_mov_b32_e32 v252, s48
		v_mov_b32_e32 v253, s49
		v_accvgpr_write_b32 a158, v252
		v_accvgpr_write_b32 a159, v253
		v_accvgpr_read_b32 v24, a64
		v_cmp_ge_i32_e64 s[48:49], v1, v24
		s_nop 1
		v_mov_b32_e32 v252, s48
		v_mov_b32_e32 v253, s49
		v_accvgpr_write_b32 a160, v252
		v_accvgpr_write_b32 a161, v253
		v_accvgpr_read_b32 v24, a147
		v_cmp_ge_i32_e64 s[48:49], v1, v24
		s_nop 1
		v_mov_b32_e32 v252, s48
		v_mov_b32_e32 v253, s49
		v_accvgpr_write_b32 a162, v252
		v_accvgpr_write_b32 a163, v253
		v_accvgpr_read_b32 v24, a148
		v_cmp_ge_i32_e64 s[48:49], v1, v24
		s_nop 1
		v_mov_b32_e32 v252, s48
		v_mov_b32_e32 v253, s49
		v_accvgpr_write_b32 a164, v252
		v_accvgpr_write_b32 a165, v253
		v_accvgpr_read_b32 v24, a67
		v_cmp_ge_i32_e64 s[48:49], v1, v24
		s_nop 1
		v_mov_b32_e32 v252, s48
		v_mov_b32_e32 v253, s49
		v_accvgpr_write_b32 a166, v252
		v_accvgpr_write_b32 a167, v253
		v_accvgpr_read_b32 v24, a149
		v_cmp_ge_i32_e64 s[48:49], v1, v24
		s_nop 1
		v_mov_b32_e32 v252, s48
		v_mov_b32_e32 v253, s49
		v_accvgpr_write_b32 a168, v252
		v_accvgpr_write_b32 a169, v253
		v_accvgpr_read_b32 v24, a150
		v_cmp_ge_i32_e64 s[48:49], v1, v24
		s_nop 1
		v_mov_b32_e32 v252, s48
		v_mov_b32_e32 v253, s49
		v_accvgpr_write_b32 a170, v252
		v_accvgpr_write_b32 a171, v253
		v_accvgpr_read_b32 v24, a131
		v_cmp_ge_i32_e64 s[48:49], v1, v24
		s_nop 1
		v_mov_b32_e32 v252, s48
		v_mov_b32_e32 v253, s49
		v_accvgpr_write_b32 a172, v252
		v_accvgpr_write_b32 a173, v253
		v_accvgpr_read_b32 v24, a151
		v_cmp_ge_i32_e64 s[48:49], v1, v24
		s_nop 1
		v_mov_b32_e32 v252, s48
		v_mov_b32_e32 v253, s49
		v_accvgpr_write_b32 a174, v252
		v_accvgpr_write_b32 a175, v253
		v_accvgpr_read_b32 v24, a152
		v_cmp_ge_i32_e64 s[48:49], v1, v24
		s_nop 1
		v_mov_b32_e32 v252, s48
		v_mov_b32_e32 v253, s49
		v_accvgpr_write_b32 a176, v252
		v_accvgpr_write_b32 a177, v253
		v_accvgpr_read_b32 v24, a133
		v_cmp_ge_i32_e64 s[48:49], v1, v24
		s_nop 1
		v_mov_b32_e32 v252, s48
		v_mov_b32_e32 v253, s49
		v_accvgpr_write_b32 a178, v252
		v_accvgpr_write_b32 a179, v253
		v_accvgpr_read_b32 v24, a153
		v_cmp_ge_i32_e64 s[48:49], v1, v24
		s_nop 1
		v_mov_b32_e32 v252, s48
		v_mov_b32_e32 v253, s49
		v_accvgpr_write_b32 a180, v252
		v_accvgpr_write_b32 a181, v253
		v_accvgpr_read_b32 v24, a154
		v_cmp_ge_i32_e64 s[48:49], v1, v24
		v_accvgpr_read_b32 v24, a135
		v_cmp_ge_i32_e64 s[90:91], v1, v24
		v_cndmask_b32_e32 v253, v8, v143, vcc
		v_cndmask_b32_e64 v255, v8, v141, s[48:49]
		v_cndmask_b32_e64 v252, v8, v142, s[90:91]
		v_accvgpr_read_b32 v24, a115
		v_add_u32_e32 v96, s41, v24
		v_accvgpr_read_b32 v24, a116
		v_add_u32_e32 v119, s41, v24
		v_cmp_ge_i32_e64 s[48:49], v1, v96
		v_cmp_ge_i32_e64 s[90:91], v1, v119
		v_accvgpr_read_b32 v24, a137
		v_cmp_ge_i32_e64 s[92:93], v1, v24
		v_cndmask_b32_e64 v142, v8, v144, s[48:49]
		v_cndmask_b32_e64 v143, v8, v145, s[90:91]
		v_cndmask_b32_e64 v144, v8, v146, s[92:93]
		v_accvgpr_read_b32 v24, a138
		v_cmp_ge_i32_e64 vcc, v1, v24
		v_accvgpr_read_b32 v24, a119
		v_add_u32_e32 v123, s41, v24
		v_accvgpr_read_b32 v24, a120
		v_add_u32_e32 v127, s41, v24
		v_cndmask_b32_e32 v145, v8, v147, vcc
		v_cmp_ge_i32_e64 s[48:49], v1, v123
		v_cmp_ge_i32_e64 s[90:91], v1, v127
		v_accvgpr_read_b32 v24, a139
		v_cmp_ge_i32_e64 s[92:93], v1, v24
		v_cndmask_b32_e64 v146, v8, v148, s[48:49]
		v_cndmask_b32_e64 v147, v8, v149, s[90:91]
		v_cndmask_b32_e64 v148, v8, v150, s[92:93]
		v_accvgpr_read_b32 v24, a140
		v_cmp_ge_i32_e64 vcc, v1, v24
		v_accvgpr_read_b32 v24, a123
		v_add_u32_e32 v131, s41, v24
		v_accvgpr_read_b32 v24, a124
		v_add_u32_e32 v135, s41, v24
		v_cndmask_b32_e32 v149, v8, v151, vcc
		v_cmp_ge_i32_e64 s[48:49], v1, v131
		v_cmp_ge_i32_e64 s[90:91], v1, v135
		v_accvgpr_read_b32 v24, a141
		v_cmp_ge_i32_e64 s[92:93], v1, v24
		v_cndmask_b32_e64 v150, v8, v152, s[48:49]
		v_cndmask_b32_e64 v151, v8, v153, s[90:91]
		v_cndmask_b32_e64 v152, v8, v154, s[92:93]
		v_accvgpr_read_b32 v24, a142
		v_cmp_ge_i32_e64 vcc, v1, v24
		v_accvgpr_read_b32 v24, a127
		v_add_u32_e32 v139, s41, v24
		v_accvgpr_read_b32 v24, a128
		v_add_u32_e32 v141, s41, v24
		v_cndmask_b32_e32 v153, v8, v155, vcc
		v_cmp_ge_i32_e64 s[48:49], v1, v139
		v_cmp_ge_i32_e64 s[90:91], v1, v141
		v_accvgpr_read_b32 v24, a143
		v_cmp_ge_i32_e64 s[92:93], v1, v24
		v_cndmask_b32_e64 v154, v8, v156, s[48:49]
		v_cndmask_b32_e64 v155, v8, v157, s[90:91]
		v_cndmask_b32_e64 v156, v8, v158, s[92:93]
		v_cndmask_b32_e64 v251, v8, v97, s[50:51]
		v_accvgpr_read_b32 v24, a144
		v_cmp_ge_i32_e64 vcc, v1, v24
		v_max3_f32 v97, v142, v143, v144
		v_max3_f32 v158, v146, v147, v148
		v_cndmask_b32_e32 v157, v8, v159, vcc
		v_cmp_ge_i32_e64 s[48:49], v3, v12
		v_cmp_ge_i32_e64 s[50:51], v3, v13
		v_cmp_ge_i32_e64 s[90:91], v3, v14
		v_max3_f32 v12, v150, v151, v152
		v_accvgpr_write_b32 a155, v12
		v_max3_f32 v12, v154, v155, v156
		v_accvgpr_write_b32 a182, v12
		v_cndmask_b32_e64 v12, v8, v178, s[90:91]
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_cndmask_b32_e64 v24, v8, v98, s[52:53]
		v_cndmask_b32_e64 v14, v8, v100, s[54:55]
		v_cndmask_b32_e32 v13, v8, v179, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v99
		v_cmp_ge_i32_e64 s[54:55], v3, v224
		v_cmp_ge_i32_e64 s[90:91], v3, v16
		v_cndmask_b32_e64 v98, v8, v180, s[52:53]
		v_cndmask_b32_e64 v99, v8, v181, s[54:55]
		v_cndmask_b32_e64 v178, v8, v182, s[90:91]
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_cndmask_b32_e64 v15, v8, v101, s[56:57]
		v_cndmask_b32_e64 v228, v8, v102, s[58:59]
		v_cndmask_b32_e64 v100, v8, v104, s[60:61]
		v_cndmask_b32_e32 v179, v8, v183, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v225
		v_cmp_ge_i32_e64 s[54:55], v3, v226
		v_cmp_ge_i32_e64 s[56:57], v3, v19
		v_cndmask_b32_e64 v18, v8, v184, s[52:53]
		v_cndmask_b32_e64 v19, v8, v185, s[54:55]
		v_cndmask_b32_e64 v180, v8, v186, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v21
		v_cndmask_b32_e64 v101, v8, v105, s[62:63]
		v_max3_f32 v16, v250, v251, v24
		v_cndmask_b32_e32 v181, v8, v187, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v103
		v_cmp_ge_i32_e64 s[54:55], v3, v227
		v_cmp_ge_i32_e64 s[56:57], v3, v22
		v_cndmask_b32_e64 v102, v8, v188, s[52:53]
		v_cndmask_b32_e64 v103, v8, v189, s[54:55]
		v_cndmask_b32_e64 v104, v8, v190, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v23
		v_cndmask_b32_e64 v230, v8, v106, s[64:65]
		v_cndmask_b32_e64 v22, v8, v108, s[66:67]
		v_cndmask_b32_e32 v105, v8, v191, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v107
		v_cmp_ge_i32_e64 s[54:55], v3, v232
		v_cmp_ge_i32_e64 s[56:57], v3, v26
		v_cndmask_b32_e64 v106, v8, v192, s[52:53]
		v_cndmask_b32_e64 v107, v8, v193, s[54:55]
		v_cndmask_b32_e64 v182, v8, v194, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v27
		v_cndmask_b32_e64 v23, v8, v109, s[68:69]
		v_cndmask_b32_e64 v234, v8, v110, s[70:71]
		v_cndmask_b32_e64 v26, v8, v112, s[72:73]
		v_cndmask_b32_e32 v183, v8, v195, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v111
		v_cmp_ge_i32_e64 s[54:55], v3, v233
		v_cmp_ge_i32_e64 s[56:57], v3, v28
		v_cndmask_b32_e64 v108, v8, v196, s[52:53]
		v_cndmask_b32_e64 v109, v8, v197, s[54:55]
		v_cndmask_b32_e64 v110, v8, v198, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v29
		v_cndmask_b32_e64 v27, v8, v113, s[74:75]
		v_max3_f32 v21, v14, v15, v228
		v_cndmask_b32_e32 v111, v8, v199, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v115
		v_cmp_ge_i32_e64 s[54:55], v3, v236
		v_cmp_ge_i32_e64 s[56:57], v3, v30
		v_cndmask_b32_e64 v28, v8, v200, s[52:53]
		v_cndmask_b32_e64 v29, v8, v201, s[54:55]
		v_cndmask_b32_e64 v112, v8, v202, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v31
		v_cndmask_b32_e64 v236, v8, v114, s[76:77]
		v_cndmask_b32_e64 v30, v8, v116, s[78:79]
		v_cndmask_b32_e32 v113, v8, v203, vcc
		v_accvgpr_read_b32 v31, a65
		v_cmp_ge_i32_e64 vcc, v3, v31
		v_accvgpr_read_b32 v31, a145
		v_cmp_ge_i32_e64 s[52:53], v3, v31
		v_accvgpr_read_b32 v31, a146
		v_cmp_ge_i32_e64 s[54:55], v3, v31
		v_accvgpr_read_b32 v31, a64
		v_cmp_ge_i32_e64 s[56:57], v3, v31
		v_cndmask_b32_e64 v114, v8, v204, s[52:53]
		v_cndmask_b32_e64 v115, v8, v205, s[54:55]
		v_cndmask_b32_e64 v184, v8, v206, s[56:57]
		v_cndmask_b32_e64 v31, v8, v117, s[80:81]
		v_cndmask_b32_e64 v238, v8, v118, s[82:83]
		v_cndmask_b32_e32 v185, v8, v207, vcc
		v_accvgpr_read_b32 v116, a147
		v_cmp_ge_i32_e64 s[52:53], v3, v116
		v_accvgpr_read_b32 v116, a148
		v_cmp_ge_i32_e64 s[54:55], v3, v116
		v_accvgpr_read_b32 v116, a68
		v_cmp_ge_i32_e64 vcc, v3, v116
		v_accvgpr_read_b32 v116, a67
		v_cmp_ge_i32_e64 s[56:57], v3, v116
		v_cndmask_b32_e64 v116, v8, v208, s[52:53]
		v_cndmask_b32_e64 v117, v8, v209, s[54:55]
		v_cndmask_b32_e64 v186, v8, v210, s[56:57]
		v_cndmask_b32_e64 v188, v8, v120, s[84:85]
		v_cndmask_b32_e64 v189, v8, v121, s[86:87]
		v_cndmask_b32_e32 v187, v8, v211, vcc
		v_accvgpr_read_b32 v118, a149
		v_cmp_ge_i32_e64 s[52:53], v3, v118
		v_accvgpr_read_b32 v118, a150
		v_cmp_ge_i32_e64 s[54:55], v3, v118
		v_accvgpr_read_b32 v118, a131
		v_cmp_ge_i32_e64 s[56:57], v3, v118
		v_cndmask_b32_e64 v120, v8, v212, s[52:53]
		v_cndmask_b32_e64 v121, v8, v213, s[54:55]
		v_cndmask_b32_e64 v190, v8, v214, s[56:57]
		v_accvgpr_read_b32 v118, a132
		v_cmp_ge_i32_e64 vcc, v3, v118
		v_cndmask_b32_e64 v240, v8, v122, s[88:89]
		v_accvgpr_read_b32 v118, a156
		s_nop 0
		v_readfirstlane_b32 s52, v118
		v_accvgpr_read_b32 v118, a157
		s_nop 0
		v_readfirstlane_b32 s53, v118
		s_nop 1
		v_cndmask_b32_e64 v192, v8, v124, s[52:53]
		v_cndmask_b32_e32 v191, v8, v215, vcc
		v_accvgpr_read_b32 v118, a151
		v_cmp_ge_i32_e64 s[52:53], v3, v118
		v_accvgpr_read_b32 v118, a152
		v_cmp_ge_i32_e64 s[54:55], v3, v118
		v_accvgpr_read_b32 v118, a133
		v_cmp_ge_i32_e64 s[56:57], v3, v118
		v_cndmask_b32_e64 v194, v8, v216, s[52:53]
		v_cndmask_b32_e64 v195, v8, v217, s[54:55]
		v_cndmask_b32_e64 v196, v8, v218, s[56:57]
		v_accvgpr_read_b32 v118, a134
		v_cmp_ge_i32_e64 vcc, v3, v118
		v_accvgpr_read_b32 v118, a158
		s_nop 0
		v_readfirstlane_b32 s52, v118
		v_accvgpr_read_b32 v118, a159
		s_nop 0
		v_readfirstlane_b32 s53, v118
		s_nop 1
		v_cndmask_b32_e64 v193, v8, v125, s[52:53]
		v_accvgpr_read_b32 v118, a160
		s_nop 0
		v_readfirstlane_b32 s52, v118
		v_accvgpr_read_b32 v118, a161
		s_nop 0
		v_readfirstlane_b32 s53, v118
		s_nop 1
		v_cndmask_b32_e64 v242, v8, v126, s[52:53]
		v_cndmask_b32_e32 v197, v8, v219, vcc
		v_accvgpr_read_b32 v118, a153
		v_cmp_ge_i32_e64 s[52:53], v3, v118
		v_accvgpr_read_b32 v118, a154
		v_cmp_ge_i32_e64 s[54:55], v3, v118
		v_accvgpr_read_b32 v118, a135
		v_cmp_ge_i32_e64 s[56:57], v3, v118
		v_cndmask_b32_e64 v124, v8, v220, s[52:53]
		v_cndmask_b32_e64 v125, v8, v221, s[54:55]
		v_cndmask_b32_e64 v198, v8, v222, s[56:57]
		v_accvgpr_read_b32 v118, a136
		v_cmp_ge_i32_e64 vcc, v3, v118
		v_accvgpr_read_b32 v118, a162
		s_nop 0
		v_readfirstlane_b32 s52, v118
		v_accvgpr_read_b32 v118, a163
		s_nop 0
		v_readfirstlane_b32 s53, v118
		s_nop 1
		v_cndmask_b32_e64 v200, v8, v128, s[52:53]
		v_accvgpr_read_b32 v118, a164
		s_nop 0
		v_readfirstlane_b32 s52, v118
		v_accvgpr_read_b32 v118, a165
		s_nop 0
		v_readfirstlane_b32 s53, v118
		s_nop 1
		v_cndmask_b32_e64 v201, v8, v129, s[52:53]
		v_cndmask_b32_e32 v199, v8, v223, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v96
		v_cmp_ge_i32_e64 s[54:55], v3, v119
		v_accvgpr_read_b32 v96, a137
		v_cmp_ge_i32_e64 s[56:57], v3, v96
		v_cndmask_b32_e64 v118, v8, v160, s[52:53]
		v_cndmask_b32_e64 v119, v8, v161, s[54:55]
		v_cndmask_b32_e64 v128, v8, v162, s[56:57]
		v_accvgpr_read_b32 v96, a138
		v_cmp_ge_i32_e64 vcc, v3, v96
		v_accvgpr_read_b32 v96, a166
		s_nop 0
		v_readfirstlane_b32 s52, v96
		v_accvgpr_read_b32 v96, a167
		s_nop 0
		v_readfirstlane_b32 s53, v96
		s_nop 1
		v_cndmask_b32_e64 v244, v8, v130, s[52:53]
		v_accvgpr_read_b32 v96, a168
		s_nop 0
		v_readfirstlane_b32 s52, v96
		v_accvgpr_read_b32 v96, a169
		s_nop 0
		v_readfirstlane_b32 s53, v96
		s_nop 1
		v_cndmask_b32_e64 v160, v8, v132, s[52:53]
		v_cndmask_b32_e32 v129, v8, v163, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v123
		v_cmp_ge_i32_e64 s[54:55], v3, v127
		v_accvgpr_read_b32 v96, a139
		v_cmp_ge_i32_e64 s[56:57], v3, v96
		v_cndmask_b32_e64 v122, v8, v164, s[52:53]
		v_cndmask_b32_e64 v123, v8, v165, s[54:55]
		v_cndmask_b32_e64 v126, v8, v166, s[56:57]
		v_accvgpr_read_b32 v96, a140
		v_cmp_ge_i32_e64 vcc, v3, v96
		v_accvgpr_read_b32 v96, a170
		s_nop 0
		v_readfirstlane_b32 s52, v96
		v_accvgpr_read_b32 v96, a171
		s_nop 0
		v_readfirstlane_b32 s53, v96
		s_nop 1
		v_cndmask_b32_e64 v161, v8, v133, s[52:53]
		v_accvgpr_read_b32 v96, a172
		s_nop 0
		v_readfirstlane_b32 s52, v96
		v_accvgpr_read_b32 v96, a173
		s_nop 0
		v_readfirstlane_b32 s53, v96
		s_nop 1
		v_cndmask_b32_e64 v246, v8, v134, s[52:53]
		v_cndmask_b32_e32 v127, v8, v167, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v131
		v_cmp_ge_i32_e64 s[54:55], v3, v135
		v_accvgpr_read_b32 v96, a141
		v_cmp_ge_i32_e64 s[56:57], v3, v96
		v_cndmask_b32_e64 v130, v8, v168, s[52:53]
		v_cndmask_b32_e64 v131, v8, v169, s[54:55]
		v_cndmask_b32_e64 v132, v8, v170, s[56:57]
		v_accvgpr_read_b32 v96, a142
		v_cmp_ge_i32_e64 vcc, v3, v96
		v_accvgpr_read_b32 v96, a174
		s_nop 0
		v_readfirstlane_b32 s52, v96
		v_accvgpr_read_b32 v96, a175
		s_nop 0
		v_readfirstlane_b32 s53, v96
		s_nop 1
		v_cndmask_b32_e64 v134, v8, v136, s[52:53]
		v_accvgpr_read_b32 v96, a176
		s_nop 0
		v_readfirstlane_b32 s52, v96
		v_accvgpr_read_b32 v96, a177
		s_nop 0
		v_readfirstlane_b32 s53, v96
		s_nop 1
		v_cndmask_b32_e64 v135, v8, v137, s[52:53]
		v_cndmask_b32_e32 v133, v8, v171, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v139
		v_cmp_ge_i32_e64 s[54:55], v3, v141
		v_accvgpr_read_b32 v96, a143
		v_cmp_ge_i32_e64 s[56:57], v3, v96
		v_cndmask_b32_e64 v136, v8, v172, s[52:53]
		v_cndmask_b32_e64 v137, v8, v173, s[54:55]
		v_cndmask_b32_e64 v162, v8, v174, s[56:57]
		v_accvgpr_read_b32 v96, a144
		v_cmp_ge_i32_e64 vcc, v3, v96
		v_accvgpr_read_b32 v96, a178
		s_nop 0
		v_readfirstlane_b32 s52, v96
		v_accvgpr_read_b32 v96, a179
		s_nop 0
		v_readfirstlane_b32 s53, v96
		s_nop 1
		v_cndmask_b32_e64 v248, v8, v138, s[52:53]
		v_accvgpr_read_b32 v96, a180
		s_nop 0
		v_readfirstlane_b32 s52, v96
		v_accvgpr_read_b32 v96, a181
		s_nop 0
		v_readfirstlane_b32 s53, v96
		s_nop 1
		v_cndmask_b32_e64 v254, v8, v140, s[52:53]
		v_cndmask_b32_e32 v163, v8, v175, vcc
		v_max3_f32 v96, v100, v101, v230
		v_max3_f32 v138, v22, v23, v234
		v_max3_f32 v139, v26, v27, v236
		v_max3_f32 v140, v30, v31, v238
		v_max3_f32 v141, v188, v189, v240
		v_max3_f32 v159, v192, v193, v242
		v_max3_f32 v164, v200, v201, v244
		v_max3_f32 v165, v160, v161, v246
		v_max3_f32 v166, v134, v135, v248
		v_max3_f32 v167, v254, v255, v252
		v_max3_f32 v16, v16, v25, v21
		v_max3_f32 v21, v96, v231, v138
		v_max3_f32 v96, v139, v237, v140
		v_max3_f32 v138, v141, v241, v159
		v_max3_f32 v139, v164, v245, v165
		v_max3_f32 v140, v166, v249, v167
		v_max3_f32 v97, v97, v145, v158
		v_accvgpr_read_b32 v141, a155
		v_accvgpr_read_b32 v158, a182
		v_max3_f32 v141, v141, v153, v158
		v_max3_f32 v16, v16, v229, v21
		v_max3_f32 v21, v96, v239, v138
		v_max3_f32 v96, v139, v247, v140
		v_max3_f32 v97, v97, v149, v141
		v_max3_f32 v16, v16, v235, v21
		v_max3_f32 v21, v96, v253, v97
		v_max3_f32 v16, v16, v243, v21
		v_max_f32_e32 v96, v16, v157
		v_mov_b32_e32 v97, v96
		v_cndmask_b32_e64 v138, v8, v176, s[48:49]
		v_cndmask_b32_e64 v139, v8, v177, s[50:51]
		v_permlane32_swap_b32_e32 v96, v97
		v_max3_f32 v16, v138, v139, v12
		v_max3_f32 v21, v98, v99, v178
		v_max3_f32 v140, v18, v19, v180
		v_max3_f32 v141, v102, v103, v104
		v_max3_f32 v158, v106, v107, v182
		v_max3_f32 v159, v108, v109, v110
		v_max3_f32 v164, v28, v29, v112
		v_max3_f32 v165, v114, v115, v184
		v_max3_f32 v166, v116, v117, v186
		v_max3_f32 v167, v120, v121, v190
		v_max3_f32 v168, v194, v195, v196
		v_max3_f32 v169, v124, v125, v198
		v_max3_f32 v170, v118, v119, v128
		v_max3_f32 v171, v122, v123, v126
		v_max3_f32 v172, v130, v131, v132
		v_max3_f32 v173, v136, v137, v162
		v_max3_f32 v16, v16, v13, v21
		v_max3_f32 v21, v140, v181, v141
		v_max3_f32 v140, v158, v183, v159
		v_max3_f32 v141, v164, v113, v165
		v_max3_f32 v158, v166, v187, v167
		v_max3_f32 v159, v168, v197, v169
		v_max3_f32 v164, v170, v129, v171
		v_max3_f32 v165, v172, v133, v173
		v_max3_f32 v16, v16, v179, v21
		v_max3_f32 v21, v140, v111, v141
		v_max3_f32 v140, v158, v191, v159
		v_max3_f32 v141, v164, v127, v165
		v_max3_f32 v16, v16, v105, v21
		v_max3_f32 v21, v140, v199, v141
		v_max3_f32 v16, v16, v185, v21
		v_max_f32_e32 v140, v16, v163
		v_mov_b32_e32 v141, v140
		v_max_f32_e32 v158, v96, v97
		v_mov_b32_e32 v96, v4
		v_permlane32_swap_b32_e32 v140, v141
		v_max_f32_e32 v159, v140, v141
		v_pk_mul_f32 v[140:141], v[158:159], v[6:7]
		v_max_f32_e32 v158, v4, v140
		v_max_f32_e32 v159, v9, v141
		v_pk_fma_f32 v[140:141], v[250:251], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[24:25], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[14:15], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[14:15], v[228:229], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[100:101], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[230:231], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[22:23], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[22:23], v[234:235], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[26:27], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[236:237], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[30:31], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[238:239], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[188:189], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[240:241], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[192:193], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[242:243], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[200:201], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[244:245], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[160:161], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[246:247], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[134:135], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[248:249], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[254:255], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[252:253], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[142:143], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[144:145], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[146:147], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[148:149], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[150:151], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[154:155], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[156:157], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[138:139], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[12:13], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[12:13], v[98:99], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[178:179], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[18:19], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[18:19], v[180:181], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[102:103], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[182:183], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[108:109], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[110:111], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[28:29], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[112:113], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[114:115], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[184:185], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[116:117], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[186:187], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[120:121], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[190:191], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[194:195], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[196:197], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[124:125], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[198:199], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[118:119], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[128:129], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[122:123], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[126:127], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[130:131], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[132:133], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[136:137], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[162:163], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v162, v140
		v_exp_f32_e32 v214, v141
		v_exp_f32_e32 v140, v164
		v_exp_f32_e32 v216, v165
		v_exp_f32_e32 v164, v24
		v_exp_f32_e32 v218, v25
		v_exp_f32_e32 v24, v14
		v_exp_f32_e32 v220, v15
		v_exp_f32_e32 v14, v166
		v_exp_f32_e32 v222, v167
		v_exp_f32_e32 v166, v100
		v_exp_f32_e32 v224, v101
		v_exp_f32_e32 v100, v168
		v_exp_f32_e32 v226, v169
		v_exp_f32_e32 v168, v22
		v_exp_f32_e32 v228, v23
		v_exp_f32_e32 v22, v170
		v_exp_f32_e32 v230, v171
		v_exp_f32_e32 v170, v26
		v_exp_f32_e32 v232, v27
		v_exp_f32_e32 v26, v172
		v_exp_f32_e32 v234, v173
		v_exp_f32_e32 v172, v30
		v_exp_f32_e32 v236, v31
		v_exp_f32_e32 v30, v174
		v_exp_f32_e32 v238, v175
		v_exp_f32_e32 v174, v176
		v_exp_f32_e32 v240, v177
		v_exp_f32_e32 v176, v188
		v_exp_f32_e32 v242, v189
		v_exp_f32_e32 v188, v192
		v_exp_f32_e32 v244, v193
		v_exp_f32_e32 v163, v202
		v_exp_f32_e32 v215, v203
		v_exp_f32_e32 v141, v200
		v_exp_f32_e32 v217, v201
		v_exp_f32_e32 v165, v204
		v_exp_f32_e32 v219, v205
		v_exp_f32_e32 v25, v160
		v_exp_f32_e32 v221, v161
		v_exp_f32_e32 v15, v206
		v_exp_f32_e32 v223, v207
		v_exp_f32_e32 v167, v134
		v_exp_f32_e32 v225, v135
		v_exp_f32_e32 v101, v208
		v_exp_f32_e32 v227, v209
		v_exp_f32_e32 v169, v210
		v_exp_f32_e32 v229, v211
		v_exp_f32_e32 v23, v212
		v_exp_f32_e32 v231, v213
		v_exp_f32_e32 v171, v142
		v_exp_f32_e32 v233, v143
		v_exp_f32_e32 v27, v144
		v_exp_f32_e32 v235, v145
		v_exp_f32_e32 v173, v146
		v_exp_f32_e32 v237, v147
		v_exp_f32_e32 v31, v148
		v_exp_f32_e32 v239, v149
		v_exp_f32_e32 v175, v150
		v_exp_f32_e32 v241, v151
		v_exp_f32_e32 v177, v152
		v_exp_f32_e32 v243, v153
		v_exp_f32_e32 v189, v154
		v_exp_f32_e32 v245, v155
		v_exp_f32_e32 v134, v156
		v_exp_f32_e32 v142, v157
		v_exp_f32_e32 v144, v138
		v_exp_f32_e32 v146, v139
		v_exp_f32_e32 v138, v12
		v_exp_f32_e32 v148, v13
		v_exp_f32_e32 v12, v98
		v_exp_f32_e32 v150, v99
		v_exp_f32_e32 v98, v178
		v_exp_f32_e32 v152, v179
		v_exp_f32_e32 v154, v18
		v_exp_f32_e32 v156, v19
		v_exp_f32_e32 v18, v180
		v_exp_f32_e32 v160, v181
		v_exp_f32_e32 v178, v102
		v_exp_f32_e32 v180, v103
		v_exp_f32_e32 v102, v104
		v_exp_f32_e32 v192, v105
		v_exp_f32_e32 v104, v106
		v_exp_f32_e32 v200, v107
		v_exp_f32_e32 v106, v182
		v_exp_f32_e32 v202, v183
		v_exp_f32_e32 v182, v108
		v_exp_f32_e32 v204, v109
		v_exp_f32_e32 v108, v110
		v_exp_f32_e32 v206, v111
		v_exp_f32_e32 v110, v28
		v_exp_f32_e32 v208, v29
		v_exp_f32_e32 v28, v112
		v_exp_f32_e32 v210, v113
		v_exp_f32_e32 v112, v114
		v_exp_f32_e32 v212, v115
		v_exp_f32_e32 v135, v184
		v_exp_f32_e32 v143, v185
		v_exp_f32_e32 v145, v116
		v_exp_f32_e32 v147, v117
		v_exp_f32_e32 v139, v186
		v_exp_f32_e32 v149, v187
		v_exp_f32_e32 v13, v120
		v_exp_f32_e32 v151, v121
		v_exp_f32_e32 v99, v190
		v_exp_f32_e32 v153, v191
		v_exp_f32_e32 v155, v194
		v_exp_f32_e32 v157, v195
		v_exp_f32_e32 v19, v196
		v_exp_f32_e32 v161, v197
		v_exp_f32_e32 v179, v124
		v_exp_f32_e32 v181, v125
		v_exp_f32_e32 v103, v198
		v_exp_f32_e32 v193, v199
		v_exp_f32_e32 v105, v118
		v_exp_f32_e32 v201, v119
		v_exp_f32_e32 v107, v128
		v_exp_f32_e32 v203, v129
		v_exp_f32_e32 v183, v122
		v_exp_f32_e32 v205, v123
		v_exp_f32_e32 v109, v126
		v_exp_f32_e32 v207, v127
		v_exp_f32_e32 v111, v130
		v_exp_f32_e32 v209, v131
		v_exp_f32_e32 v29, v132
		v_exp_f32_e32 v211, v133
		v_exp_f32_e32 v113, v136
		v_exp_f32_e32 v213, v137
		v_pk_add_f32 v[114:115], v[162:163], v[214:215]
		v_pk_add_f32 v[116:117], v[140:141], v[216:217]
		v_pk_add_f32 v[118:119], v[164:165], v[218:219]
		v_pk_add_f32 v[120:121], v[24:25], v[220:221]
		v_pk_add_f32 v[122:123], v[14:15], v[222:223]
		v_pk_add_f32 v[124:125], v[166:167], v[224:225]
		v_pk_add_f32 v[126:127], v[100:101], v[226:227]
		v_pk_add_f32 v[128:129], v[168:169], v[228:229]
		v_pk_add_f32 v[130:131], v[22:23], v[230:231]
		v_pk_add_f32 v[132:133], v[170:171], v[232:233]
		v_pk_add_f32 v[136:137], v[26:27], v[234:235]
		v_pk_add_f32 v[184:185], v[172:173], v[236:237]
		v_pk_add_f32 v[186:187], v[30:31], v[238:239]
		v_pk_add_f32 v[190:191], v[174:175], v[240:241]
		v_pk_add_f32 v[194:195], v[176:177], v[242:243]
		v_pk_add_f32 v[196:197], v[188:189], v[244:245]
		v_pk_add_f32 v[114:115], v[114:115], v[116:117]
		v_pk_add_f32 v[116:117], v[118:119], v[120:121]
		v_pk_add_f32 v[118:119], v[122:123], v[124:125]
		v_pk_add_f32 v[120:121], v[126:127], v[128:129]
		v_pk_add_f32 v[122:123], v[130:131], v[132:133]
		v_pk_add_f32 v[124:125], v[136:137], v[184:185]
		v_pk_add_f32 v[126:127], v[186:187], v[190:191]
		v_pk_add_f32 v[128:129], v[194:195], v[196:197]
		v_pk_add_f32 v[114:115], v[114:115], v[116:117]
		v_pk_add_f32 v[116:117], v[118:119], v[120:121]
		v_pk_add_f32 v[118:119], v[122:123], v[124:125]
		v_pk_add_f32 v[120:121], v[126:127], v[128:129]
		v_pk_add_f32 v[114:115], v[114:115], v[116:117]
		v_pk_add_f32 v[116:117], v[118:119], v[120:121]
		v_pk_add_f32 v[118:119], v[114:115], v[116:117]
		v_add_f32_e32 v4, v118, v119
		v_accvgpr_read_b32 v16, a69
		ds_bpermute_b32 v114, v16, v4
		v_accvgpr_read_b32 v16, a70
		ds_bpermute_b32 v116, v16, v4
		v_pk_add_f32 v[118:119], v[134:135], v[142:143]
		v_pk_add_f32 v[120:121], v[144:145], v[146:147]
		v_pk_add_f32 v[122:123], v[138:139], v[148:149]
		v_pk_add_f32 v[124:125], v[12:13], v[150:151]
		v_pk_add_f32 v[126:127], v[98:99], v[152:153]
		v_pk_add_f32 v[128:129], v[154:155], v[156:157]
		v_pk_add_f32 v[130:131], v[18:19], v[160:161]
		v_pk_add_f32 v[132:133], v[178:179], v[180:181]
		v_pk_add_f32 v[136:137], v[102:103], v[192:193]
		v_pk_add_f32 v[184:185], v[104:105], v[200:201]
		v_pk_add_f32 v[186:187], v[106:107], v[202:203]
		v_pk_add_f32 v[190:191], v[182:183], v[204:205]
		v_pk_add_f32 v[194:195], v[108:109], v[206:207]
		v_pk_add_f32 v[196:197], v[110:111], v[208:209]
		v_pk_add_f32 v[198:199], v[28:29], v[210:211]
		v_pk_add_f32 v[246:247], v[112:113], v[212:213]
		v_pk_add_f32 v[118:119], v[118:119], v[120:121]
		v_pk_add_f32 v[120:121], v[122:123], v[124:125]
		v_pk_add_f32 v[122:123], v[126:127], v[128:129]
		v_pk_add_f32 v[124:125], v[130:131], v[132:133]
		v_pk_add_f32 v[126:127], v[136:137], v[184:185]
		v_pk_add_f32 v[128:129], v[186:187], v[190:191]
		v_pk_add_f32 v[130:131], v[194:195], v[196:197]
		v_pk_add_f32 v[132:133], v[198:199], v[246:247]
		v_pk_add_f32 v[118:119], v[118:119], v[120:121]
		v_pk_add_f32 v[120:121], v[122:123], v[124:125]
		v_pk_add_f32 v[122:123], v[126:127], v[128:129]
		v_pk_add_f32 v[124:125], v[130:131], v[132:133]
		v_pk_add_f32 v[118:119], v[118:119], v[120:121]
		v_pk_add_f32 v[120:121], v[122:123], v[124:125]
		v_pk_add_f32 v[122:123], v[118:119], v[120:121]
		v_mov_b32_e32 v117, v123
		v_mov_b32_e32 v115, v122
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[118:119], v[114:115], v[116:117]
		v_mov_b32_e32 v114, v119
		v_mov_b32_e32 v115, v119
		v_cvt_pk_bf16_f32 v120, v162, v214
		v_cvt_pk_bf16_f32 v121, v140, v216
		v_permlane32_swap_b32_e32 v114, v115
		v_add_f32_e32 v117, v114, v115
		v_mov_b32_e32 v97, v9
		v_pk_add_f32 v[114:115], v[96:97], v[158:159] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v96, v114
		v_exp_f32_e32 v97, v115
		v_cvt_pk_bf16_f32 v122, v164, v218
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
		v_mov_b32_e32 v116, v118
		v_mov_b64_e32 v[114:115], v[10:11]
		v_pk_fma_f32 v[10:11], v[114:115], v[96:97], v[116:117]
		v_cvt_pk_bf16_f32 v123, v24, v220
		v_cvt_pk_bf16_f32 v116, v14, v222
		v_cvt_pk_bf16_f32 v117, v166, v224
		v_cvt_pk_bf16_f32 v118, v100, v226
		v_cvt_pk_bf16_f32 v119, v168, v228
		v_cvt_pk_bf16_f32 v124, v22, v230
		v_cvt_pk_bf16_f32 v125, v170, v232
		v_cvt_pk_bf16_f32 v126, v26, v234
		v_cvt_pk_bf16_f32 v127, v172, v236
		v_cvt_pk_bf16_f32 v128, v30, v238
		v_cvt_pk_bf16_f32 v129, v174, v240
		v_cvt_pk_bf16_f32 v130, v176, v242
		v_cvt_pk_bf16_f32 v131, v188, v244
		v_cvt_pk_bf16_f32 v184, v163, v215
		v_cvt_pk_bf16_f32 v185, v141, v217
		v_cvt_pk_bf16_f32 v186, v165, v219
		v_cvt_pk_bf16_f32 v187, v25, v221
		v_cvt_pk_bf16_f32 v196, v15, v223
		v_cvt_pk_bf16_f32 v197, v167, v225
		v_cvt_pk_bf16_f32 v198, v101, v227
		v_cvt_pk_bf16_f32 v199, v169, v229
		v_cvt_pk_bf16_f32 v164, v23, v231
		v_cvt_pk_bf16_f32 v165, v171, v233
		v_cvt_pk_bf16_f32 v166, v27, v235
		v_cvt_pk_bf16_f32 v167, v173, v237
		v_cvt_pk_bf16_f32 v24, v31, v239
		v_cvt_pk_bf16_f32 v25, v175, v241
		v_cvt_pk_bf16_f32 v26, v177, v243
		v_cvt_pk_bf16_f32 v27, v189, v245
		v_cvt_pk_bf16_f32 v168, v134, v142
		v_cvt_pk_bf16_f32 v169, v144, v146
		v_cvt_pk_bf16_f32 v170, v138, v148
		v_cvt_pk_bf16_f32 v171, v12, v150
		v_cvt_pk_bf16_f32 v172, v98, v152
		v_cvt_pk_bf16_f32 v173, v154, v156
		v_cvt_pk_bf16_f32 v174, v18, v160
		v_cvt_pk_bf16_f32 v175, v178, v180
		v_cvt_pk_bf16_f32 v188, v102, v192
		v_cvt_pk_bf16_f32 v189, v104, v200
		v_cvt_pk_bf16_f32 v190, v106, v202
		v_cvt_pk_bf16_f32 v191, v182, v204
		v_cvt_pk_bf16_f32 v216, v108, v206
		v_cvt_pk_bf16_f32 v217, v110, v208
		v_cvt_pk_bf16_f32 v218, v28, v210
		v_cvt_pk_bf16_f32 v219, v112, v212
		v_cvt_pk_bf16_f32 v220, v135, v143
		v_cvt_pk_bf16_f32 v221, v145, v147
		v_cvt_pk_bf16_f32 v222, v139, v149
		v_cvt_pk_bf16_f32 v223, v13, v151
		v_cvt_pk_bf16_f32 v12, v99, v153
		v_cvt_pk_bf16_f32 v13, v155, v157
		v_cvt_pk_bf16_f32 v14, v19, v161
		v_cvt_pk_bf16_f32 v15, v179, v181
		v_cvt_pk_bf16_f32 v96, v103, v193
		v_cvt_pk_bf16_f32 v97, v105, v201
		v_cvt_pk_bf16_f32 v98, v107, v203
		v_cvt_pk_bf16_f32 v99, v183, v205
		v_cvt_pk_bf16_f32 v100, v109, v207
		v_cvt_pk_bf16_f32 v101, v111, v209
		v_cvt_pk_bf16_f32 v102, v29, v211
		v_cvt_pk_bf16_f32 v103, v113, v213
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[32:47], a[188:191], v[120:123], v[32:47]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[48:63], a[220:223], v[120:123], v[48:63]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[116:119], v[32:47]
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[116:119], v[48:63]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[124:127], v[32:47]
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[124:127], v[48:63]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[128:131], v[32:47]
		v_permlane32_swap_b32_e32 v168, v170
		v_permlane32_swap_b32_e32 v169, v171
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[128:131], v[48:63]
		v_permlane32_swap_b32_e32 v172, v174
		v_permlane32_swap_b32_e32 v173, v175
		v_mfma_f32_32x32x16_bf16 v[80:95], a[220:223], v[168:171], v[80:95]
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[64:79], a[188:191], v[168:171], v[64:79]
		v_permlane32_swap_b32_e32 v216, v218
		v_permlane32_swap_b32_e32 v217, v219
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[172:175], v[80:95]
		v_permlane32_swap_b32_e32 v220, v222
		v_permlane32_swap_b32_e32 v221, v223
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[172:175], v[64:79]
		v_permlane32_swap_b32_e32 v12, v14
		v_permlane32_swap_b32_e32 v13, v15
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[188:191], v[80:95]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[188:191], v[64:79]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[216:219], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[216:219], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[184:187], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[184:187], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[220:223], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[220:223], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[196:199], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[196:199], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[12:15], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[12:15], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[164:167], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[164:167], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[216:219], v[24:27], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[248:251], v[24:27], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[248:251], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[216:219], v[100:103], v[64:79]
		s_cselect_b32 s1, 1, 0
		s_add_i32 s23, s41, 0x80
		s_cmp_lg_u32 s1, 0
		s_mov_b32 s41, s23
		v_mov_b32_e32 v4, v158
		v_mov_b32_e32 v9, v159
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_2
.L_attn_fwd_persistent.loop_exit_2:
		s_mov_b32 s24, s8
		s_mov_b32 s25, s9
		s_mov_b32 s26, s38
		s_mov_b32 s27, s39
		v_rcp_f32_e32 v2, v10
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
		v_pk_mul_f32 v[12:13], v[38:39], v[2:3]
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
		v_rcp_f32_e32 v2, v11
		v_cvt_pk_bf16_f32 v40, v4, v5
		v_mov_b32_e32 v3, v2
		v_pk_mul_f32 v[4:5], v[64:65], v[2:3]
		v_pk_mul_f32 v[10:11], v[66:67], v[2:3]
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
		v_cvt_pk_bf16_f32 v43, v12, v13
		v_cvt_pk_bf16_f32 v72, v14, v15
		v_cvt_pk_bf16_f32 v73, v16, v17
		v_cvt_pk_bf16_f32 v74, v18, v19
		v_cvt_pk_bf16_f32 v75, v20, v21
		v_cvt_pk_bf16_f32 v12, v22, v23
		v_cvt_pk_bf16_f32 v13, v24, v25
		v_cvt_pk_bf16_f32 v14, v26, v27
		v_cvt_pk_bf16_f32 v15, v28, v29
		v_cvt_pk_bf16_f32 v16, v30, v31
		v_cvt_pk_bf16_f32 v17, v32, v33
		v_cvt_pk_bf16_f32 v18, v34, v35
		v_cvt_pk_bf16_f32 v19, v36, v37
		v_cvt_pk_bf16_f32 v20, v4, v5
		v_cvt_pk_bf16_f32 v21, v10, v11
		v_cvt_pk_bf16_f32 v22, v38, v39
		v_cvt_pk_bf16_f32 v23, v44, v45
		v_cvt_pk_bf16_f32 v4, v46, v47
		v_cvt_pk_bf16_f32 v5, v48, v49
		v_cvt_pk_bf16_f32 v6, v50, v51
		v_cvt_pk_bf16_f32 v7, v52, v53
		v_cvt_pk_bf16_f32 v8, v54, v55
		v_cvt_pk_bf16_f32 v9, v56, v57
		v_cvt_pk_bf16_f32 v10, v58, v59
		v_cvt_pk_bf16_f32 v11, v60, v61
		v_cvt_pk_bf16_f32 v24, v62, v63
		v_cvt_pk_bf16_f32 v25, v64, v65
		v_cvt_pk_bf16_f32 v26, v66, v67
		v_cvt_pk_bf16_f32 v27, v68, v69
		v_permlane32_swap_b32_e32 v40, v42
		v_permlane32_swap_b32_e32 v41, v43
		v_permlane32_swap_b32_e32 v72, v74
		v_permlane32_swap_b32_e32 v73, v75
		v_permlane32_swap_b32_e32 v12, v14
		v_permlane32_swap_b32_e32 v13, v15
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v20, v22
		v_permlane32_swap_b32_e32 v21, v23
		v_permlane32_swap_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v5, v7
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
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
		v_accvgpr_read_b32 v28, a4
		s_nop 0
		v_readfirstlane_b32 s21, v28
		s_nop 1
		v_mul_lo_u32 v3, s21, v3
		v_lshl_add_u32 v2, v3, 1, v2
		v_accvgpr_read_b32 v28, a17
		v_lshl_add_u32 v2, v28, 4, v2
		v_accvgpr_read_b32 v28, a52
		s_nop 0
		v_readfirstlane_b32 s28, v28
		v_accvgpr_read_b32 v28, a53
		s_nop 0
		v_readfirstlane_b32 s29, v28
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
		v_accvgpr_read_b32 v28, a17
		v_lshl_add_u32 v2, v28, 4, v2
		v_accvgpr_read_b32 v28, a52
		s_nop 0
		v_readfirstlane_b32 s28, v28
		v_accvgpr_read_b32 v28, a53
		s_nop 0
		v_readfirstlane_b32 s29, v28
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_9
		buffer_store_dwordx4 v[72:75], v2, s[24:27], 0 offen
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
		v_accvgpr_read_b32 v28, a17
		v_lshl_add_u32 v2, v28, 4, v2
		v_accvgpr_read_b32 v28, a52
		s_nop 0
		v_readfirstlane_b32 s28, v28
		v_accvgpr_read_b32 v28, a53
		s_nop 0
		v_readfirstlane_b32 s29, v28
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_10
		buffer_store_dwordx4 v[12:15], v2, s[24:27], 0 offen
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
		v_accvgpr_read_b32 v12, a17
		v_lshl_add_u32 v2, v12, 4, v2
		v_accvgpr_read_b32 v12, a52
		s_nop 0
		v_readfirstlane_b32 s28, v12
		v_accvgpr_read_b32 v12, a53
		s_nop 0
		v_readfirstlane_b32 s29, v12
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_11
		buffer_store_dwordx4 v[16:19], v2, s[24:27], 0 offen
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
		v_accvgpr_read_b32 v12, a17
		v_lshl_add_u32 v2, v12, 4, v2
		v_accvgpr_read_b32 v12, a54
		s_nop 0
		v_readfirstlane_b32 s28, v12
		v_accvgpr_read_b32 v12, a55
		s_nop 0
		v_readfirstlane_b32 s29, v12
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_12
		buffer_store_dwordx4 v[20:23], v2, s[24:27], 0 offen
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
		v_accvgpr_read_b32 v12, a17
		v_lshl_add_u32 v2, v12, 4, v2
		v_accvgpr_read_b32 v12, a54
		s_nop 0
		v_readfirstlane_b32 s28, v12
		v_accvgpr_read_b32 v12, a55
		s_nop 0
		v_readfirstlane_b32 s29, v12
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
		v_accvgpr_read_b32 v4, a54
		s_nop 0
		v_readfirstlane_b32 s28, v4
		v_accvgpr_read_b32 v4, a55
		s_nop 0
		v_readfirstlane_b32 s29, v4
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_14
		buffer_store_dwordx4 v[8:11], v2, s[24:27], 0 offen
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
		v_accvgpr_read_b32 v2, a54
		s_nop 0
		v_readfirstlane_b32 s22, v2
		v_accvgpr_read_b32 v2, a55
		s_nop 0
		v_readfirstlane_b32 s23, v2
		s_and_saveexec_b64 s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_15
		buffer_store_dwordx4 v[24:27], v1, s[24:27], 0 offen
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
		v_mov_b32_e32 v9, 2
		v_mul_lo_u32 v9, v9, v14
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v10, a14
		v_lshlrev_b32_e32 v10, 12, v10
		v_add_u32_e32 v10, 0x10000, v10
		v_and_b32_e32 v11, 63, v0
		v_lshrrev_b32_e32 v14, 5, v11
		v_and_b32_e32 v15, 31, v11
		v_lshl_add_u32 v16, v15, 3, v14
		v_and_b32_e32 v17, 7, v11
		v_lshrrev_b32_e32 v18, 2, v17
		v_lshlrev_b32_e32 v18, 1, v18
		v_lshrrev_b32_e32 v11, 3, v11
		v_and_b32_e32 v11, 1, v11
		v_lshlrev_b32_e32 v11, 2, v11
		v_lshrrev_b32_e32 v19, 1, v17
		v_bitop3_b32 v19, v11, v19, 1 bitop3:0x78
		v_bitop3_b32 v16, v16, v18, v19 bitop3:0x96
		v_lshl_add_u32 v16, v16, 4, v10
		ds_read_b128 a[20:23], v16 offset:18864
		v_add_u32_e32 v18, 2, v14
		v_lshl_add_u32 v19, v15, 3, v18
		v_lshl_add_u32 v18, v17, 3, v18
		v_lshrrev_b32_e32 v20, 5, v18
		v_lshlrev_b32_e32 v20, 1, v20
		v_lshrrev_b32_e32 v18, 4, v18
		v_bitop3_b32 v18, v11, v18, 1 bitop3:0x78
		v_bitop3_b32 v18, v19, v20, v18 bitop3:0x96
		v_lshl_add_u32 v18, v18, 4, v10
		ds_read_b128 a[24:27], v18 offset:18864
		v_add_u32_e32 v19, 4, v14
		v_lshl_add_u32 v20, v15, 3, v19
		v_lshl_add_u32 v19, v17, 3, v19
		v_lshrrev_b32_e32 v21, 5, v19
		v_lshlrev_b32_e32 v21, 1, v21
		v_lshrrev_b32_e32 v19, 4, v19
		v_bitop3_b32 v19, v11, v19, 1 bitop3:0x78
		v_bitop3_b32 v19, v20, v21, v19 bitop3:0x96
		v_lshl_add_u32 v19, v19, 4, v10
		ds_read_b128 a[28:31], v19 offset:18864
		v_add_u32_e32 v20, 6, v14
		v_lshl_add_u32 v21, v15, 3, v20
		v_lshl_add_u32 v17, v17, 3, v20
		v_lshrrev_b32_e32 v20, 5, v17
		v_lshlrev_b32_e32 v20, 1, v20
		v_lshrrev_b32_e32 v17, 4, v17
		v_bitop3_b32 v11, v11, v17, 1 bitop3:0x78
		v_bitop3_b32 v11, v21, v20, v11 bitop3:0x96
		v_lshl_add_u32 v10, v11, 4, v10
		ds_read_b128 a[32:35], v10 offset:18864
		v_and_b32_e32 v6, 1, v6
		v_lshlrev_b32_e32 v11, 4, v13
		v_and_b32_e32 v2, 3, v2
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
		ds_read_b128 a[36:39], v16 offset:18864
		ds_read_b128 a[40:43], v18 offset:18864
		ds_read_b128 a[44:47], v19 offset:18864
		ds_read_b128 a[48:51], v10 offset:18864
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
		v_mov_b32_e32 v10, 16
		v_mul_lo_u32 v10, v10, v4
		v_bitop3_b32 v13, v1, v3, v10 bitop3:0x96
		v_bitop3_b32 v13, v13, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a18, v13
		v_bitop3_b32 v13, 4, v1, v3 bitop3:0x96
		v_xor_b32_e32 v13, v13, v10
		v_bitop3_b32 v16, 8, v1, v3 bitop3:0x96
		v_xor_b32_e32 v16, v16, v10
		v_bitop3_b32 v1, 12, v1, v3 bitop3:0x96
		v_accvgpr_read_b32 v17, a18
		v_cmp_lt_i32_e64 s[32:33], v17, s20
		v_mov_b32_e32 v17, 16
		v_mul_lo_u32 v17, v17, v7
		v_mov_b32_e32 v7, 64
		v_mul_lo_u32 v7, v7, v4
		v_bitop3_b32 v4, v17, v3, v7 bitop3:0x96
		v_bitop3_b32 v4, v4, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a19, v4
		v_bitop3_b32 v4, 4, v17, v3 bitop3:0x96
		v_bitop3_b32 v18, 8, v17, v3 bitop3:0x96
		v_bitop3_b32 v3, 12, v17, v3 bitop3:0x96
		v_accvgpr_read_b32 v17, a19
		v_cmp_lt_i32_e64 vcc, v17, s20
		v_readfirstlane_b32 s34, v0
		v_accvgpr_read_b32 v17, a14
		v_mul_lo_u32 v17, s15, v17
		v_accvgpr_read_b32 v19, a17
		v_mul_lo_u32 v19, s15, v19
		v_lshlrev_b32_e32 v19, 5, v19
		v_lshl_add_u32 v17, v17, 1, v19
		v_mul_lo_u32 v19, s15, v8
		v_lshl_add_u32 v17, v19, 6, v17
		v_mul_lo_u32 v19, s15, v6
		v_lshlrev_b32_e32 v19, 7, v19
		v_add3_u32 v17, v17, v19, v11
		v_accvgpr_read_b32 v19, a11
		s_nop 0
		v_readfirstlane_b32 s35, v19
		s_mul_i32 s35, s35, s13
		s_lshl_b32 s35, s35, 1
		v_accvgpr_read_b32 v19, a12
		s_nop 0
		v_readfirstlane_b32 s36, v19
		s_mul_i32 s36, s36, s14
		s_lshl_b32 s36, s36, 1
		s_add_i32 s37, s35, s36
		v_add_u32_e32 v19, s37, v17
		v_mov_b32_e32 v20, 0x80000000
		v_cndmask_b32_e64 v19, v20, v19, s[32:33]
		s_lshr_b32 s37, s34, 6
		s_mul_i32 s40, 0x410, s37
		s_mov_b32 m0, s40
		v_accvgpr_read_b32 v21, a15
		v_add_u32_e32 v21, s1, v21
		buffer_load_dwordx4 v19, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[42:43], v21, s19
		s_nop 1
		v_mov_b32_e32 v22, s42
		v_mov_b32_e32 v23, s43
		v_accvgpr_write_b32 a52, v22
		v_accvgpr_write_b32 a53, v23
		s_lshl_b32 s41, s15, 3
		s_add_i32 s41, s41, s35
		s_add_i32 s41, s41, s36
		v_add_u32_e32 v19, s41, v17
		v_cndmask_b32_e64 v19, v20, v19, s[32:33]
		s_add_i32 m0, m0, 0x1040
		v_accvgpr_read_b32 v21, a16
		v_add_u32_e32 v21, s1, v21
		buffer_load_dwordx4 v19, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[42:43], v21, s19
		s_nop 1
		v_mov_b32_e32 v22, s42
		v_mov_b32_e32 v23, s43
		v_accvgpr_write_b32 a54, v22
		v_accvgpr_write_b32 a55, v23
		s_lshl_b32 s41, s15, 4
		s_add_i32 s41, s41, s35
		s_add_i32 s41, s41, s36
		v_add_u32_e32 v19, s41, v17
		v_cndmask_b32_e64 v19, v20, v19, s[32:33]
		s_add_i32 m0, m0, 0x1040
		v_lshlrev_b32_e32 v14, 4, v14
		v_accvgpr_write_b32 a56, v14
		buffer_load_dwordx4 v19, s[24:27], 0 offen lds
		v_bitop3_b32 v13, v13, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a57, v13
		s_mul_i32 s41, 24, s15
		s_add_i32 s41, s41, s35
		s_add_i32 s41, s41, s36
		v_add_u32_e32 v13, s41, v17
		v_cndmask_b32_e64 v13, v20, v13, s[32:33]
		s_add_i32 m0, m0, 0x1040
		v_mov_b32_e32 v14, 0x440
		v_mul_lo_u32 v14, v14, v2
		v_accvgpr_write_b32 a58, v14
		buffer_load_dwordx4 v13, s[24:27], 0 offen lds
		v_bitop3_b32 v2, v16, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a59, v2
		v_accvgpr_read_b32 v2, a14
		v_mul_lo_u32 v2, s17, v2
		v_accvgpr_read_b32 v13, a17
		v_mul_lo_u32 v13, s17, v13
		v_lshlrev_b32_e32 v13, 7, v13
		v_lshl_add_u32 v2, v2, 1, v13
		v_mul_lo_u32 v13, s17, v8
		v_lshl_add_u32 v2, v13, 6, v2
		v_mul_lo_u32 v6, s17, v6
		v_lshlrev_b32_e32 v6, 5, v6
		v_add3_u32 v2, v2, v6, v11
		v_accvgpr_read_b32 v6, a0
		s_nop 0
		v_readfirstlane_b32 s32, v6
		v_accvgpr_read_b32 v6, a11
		s_nop 0
		v_readfirstlane_b32 s33, v6
		s_mul_i32 s32, s33, s32
		s_lshl_b32 s32, s32, 1
		v_accvgpr_read_b32 v6, a1
		s_nop 0
		v_readfirstlane_b32 s33, v6
		v_accvgpr_read_b32 v6, a12
		s_nop 0
		v_readfirstlane_b32 s41, v6
		s_mul_i32 s33, s41, s33
		s_lshl_b32 s33, s33, 1
		s_add_i32 s41, s32, s33
		v_add_u32_e32 v6, s41, v2
		v_cndmask_b32_e32 v6, v20, v6, vcc
		s_mul_i32 s37, 0x440, s37
		s_add_i32 m0, s37, 0x81f0
		v_xor_b32_e32 v1, v1, v10
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_bitop3_b32 v1, v1, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a60, v1
		s_lshl_b32 s41, s17, 3
		s_add_i32 s41, s41, s32
		s_add_i32 s41, s41, s33
		v_add_u32_e32 v1, s41, v2
		v_cndmask_b32_e32 v1, v20, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v4, v4, v7
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_bitop3_b32 v1, v4, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a61, v1
		s_lshl_b32 s41, s17, 4
		s_add_i32 s41, s41, s32
		s_add_i32 s41, s41, s33
		v_add_u32_e32 v1, s41, v2
		v_cndmask_b32_e32 v1, v20, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v4, v18, v7
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_bitop3_b32 v1, v4, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a62, v1
		s_mul_i32 s41, 24, s17
		s_add_i32 s41, s41, s32
		s_add_i32 s41, s41, s33
		v_add_u32_e32 v1, s41, v2
		v_cndmask_b32_e32 v1, v20, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v3, v3, v7
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_bitop3_b32 v1, v3, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a63, v1
		s_mul_i32 s41, s23, 0x80
		v_mbcnt_lo_u32_b32 v1, -1, 0
		v_mbcnt_hi_u32_b32 v1, -1, v1
		v_and_b32_e32 v1, 31, v1
		v_add_u32_e32 v3, 32, v1
		v_mov_b32_e32 v6, 0x3e38aa3b
		v_mov_b32_e32 v7, 0x3e38aa3b
		s_mov_b32 s23, 0xff800000
		v_mov_b32_e32 v4, s23
		v_mov_b32_e32 v9, s23
		s_mov_b32 s23, 1.0
		v_mov_b32_e32 v10, s23
		v_mov_b32_e32 v11, s23
		s_mov_b32 s23, 0
		v_lshrrev_b32_e32 v12, 4, v15
		v_lshlrev_b32_e32 v12, 9, v12
		v_accvgpr_write_b32 a64, v12
		v_and_b32_e32 v12, 15, v15
		v_mov_b32_e32 v13, 0x410
		v_mul_lo_u32 v13, v13, v12
		v_and_b32_e32 v12, 3, v0
		v_accvgpr_write_b32 a65, v12
		v_accvgpr_read_b32 v12, a65
		v_lshlrev_b32_e32 v12, 3, v12
		v_accvgpr_write_b32 a66, v12
		v_accvgpr_read_b32 v12, a17
		v_mov_b32_e32 v14, 0x2200
		v_mul_lo_u32 v14, v14, v12
		v_accvgpr_write_b32 a67, v14
		v_lshlrev_b32_e32 v8, 5, v8
		v_accvgpr_write_b32 a68, v8
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
		v_accvgpr_write_b32 a69, v1
		v_lshlrev_b32_e32 v1, 2, v3
		v_accvgpr_write_b32 a70, v1
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
		v_accvgpr_read_b32 v1, a56
		v_add_u32_e32 v1, s48, v1
		v_accvgpr_read_b32 v3, a64
		v_add3_u32 v1, v1, v3, v13
		ds_read_b128 v[24:27], v1
		ds_read_b128 v[28:31], v1 offset:32
		ds_read_b128 v[96:99], v1 offset:64
		ds_read_b128 a[72:75], v1 offset:96
		ds_read_b128 v[100:103], v1 offset:256
		ds_read_b128 v[104:107], v1 offset:288
		ds_read_b128 v[108:111], v1 offset:320
		ds_read_b128 a[76:79], v1 offset:352
		ds_read_b128 v[112:115], v1 offset:128
		ds_read_b128 v[116:119], v1 offset:160
		ds_read_b128 v[120:123], v1 offset:192
		ds_read_b128 a[80:83], v1 offset:224
		ds_read_b128 v[124:127], v1 offset:384
		ds_read_b128 v[128:131], v1 offset:416
		ds_read_b128 a[84:87], v1 offset:448
		ds_read_b128 a[88:91], v1 offset:480
		s_mul_i32 s35, 0x4400, s35
		v_accvgpr_read_b32 v1, a66
		v_accvgpr_read_b32 v3, a67
		v_add3_u32 v1, s35, v1, v3
		v_accvgpr_read_b32 v3, a58
		v_accvgpr_read_b32 v8, a68
		v_add3_u32 v1, v1, v8, v3
		ds_read_b64_tr_b16 a[92:93], v1 offset:33264
		ds_read_b64_tr_b16 a[94:95], v1 offset:37616
		ds_read_b64_tr_b16 a[96:97], v1 offset:33392
		ds_read_b64_tr_b16 a[98:99], v1 offset:37744
		ds_read_b64_tr_b16 a[100:101], v1 offset:33520
		ds_read_b64_tr_b16 a[102:103], v1 offset:37872
		ds_read_b64_tr_b16 a[104:105], v1 offset:33648
		ds_read_b64_tr_b16 a[106:107], v1 offset:38000
		ds_read_b64_tr_b16 a[108:109], v1 offset:33776
		ds_read_b64_tr_b16 a[110:111], v1 offset:38128
		ds_read_b64_tr_b16 a[112:113], v1 offset:33904
		ds_read_b64_tr_b16 a[114:115], v1 offset:38256
		ds_read_b64_tr_b16 a[116:117], v1 offset:34032
		ds_read_b64_tr_b16 a[118:119], v1 offset:38384
		ds_read_b64_tr_b16 a[120:121], v1 offset:34160
		ds_read_b64_tr_b16 a[122:123], v1 offset:38512
		ds_read_b64_tr_b16 a[124:125], v1 offset:33328
		ds_read_b64_tr_b16 a[126:127], v1 offset:37680
		ds_read_b64_tr_b16 a[128:129], v1 offset:33456
		ds_read_b64_tr_b16 a[130:131], v1 offset:37808
		ds_read_b64_tr_b16 a[132:133], v1 offset:33584
		ds_read_b64_tr_b16 a[134:135], v1 offset:37936
		ds_read_b64_tr_b16 a[136:137], v1 offset:33712
		ds_read_b64_tr_b16 a[138:139], v1 offset:38064
		ds_read_b64_tr_b16 a[140:141], v1 offset:33840
		ds_read_b64_tr_b16 a[142:143], v1 offset:38192
		ds_read_b64_tr_b16 a[144:145], v1 offset:33968
		ds_read_b64_tr_b16 a[146:147], v1 offset:38320
		ds_read_b64_tr_b16 a[148:149], v1 offset:34096
		ds_read_b64_tr_b16 a[150:151], v1 offset:38448
		ds_read_b64_tr_b16 a[152:153], v1 offset:34224
		ds_read_b64_tr_b16 a[154:155], v1 offset:38576
		s_mul_i32 s35, s15, s23
		s_lshl_b32 s35, s35, 1
		s_add_i32 s48, s42, s35
		v_add_u32_e32 v1, s48, v17
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v3, s35, v17
		s_add_i32 s33, s33, 1
		v_add_u32_e32 v8, s43, v3
		s_and_b32 s33, s33, 1
		v_add_u32_e32 v12, s44, v3
		s_mul_i32 s35, 0x4100, s33
		v_add_u32_e32 v3, s36, v3
		s_add_i32 s35, s40, s35
		v_mfma_f32_32x32x16_bf16 v[144:159], v[24:27], a[20:23], 0
		s_mov_b32 m0, s35
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[24:27], v[144:159]
		s_mul_i32 s35, s17, s23
		v_mfma_f32_32x32x16_bf16 v[144:159], v[96:99], a[28:31], v[144:159]
		s_add_i32 s23, s23, 0x80
		v_mfma_f32_32x32x16_bf16 v[160:175], v[24:27], a[36:39], 0
		v_accvgpr_read_b32 v14, a18
		v_add_u32_e32 v14, s23, v14
		v_mfma_f32_32x32x16_bf16 v[160:175], v[28:31], a[40:43], v[160:175]
		v_accvgpr_read_b32 v15, a57
		v_add_u32_e32 v15, s23, v15
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], a[44:47], v[160:175]
		v_accvgpr_read_b32 v16, a59
		v_add_u32_e32 v16, s23, v16
		v_mfma_f32_32x32x16_bf16 v[176:191], v[100:103], a[20:23], 0
		v_accvgpr_read_b32 v18, a60
		v_add_u32_e32 v18, s23, v18
		v_mfma_f32_32x32x16_bf16 v[176:191], v[104:107], a[24:27], v[176:191]
		v_cmp_lt_i32_e64 s[48:49], v14, s20
		v_mfma_f32_32x32x16_bf16 v[176:191], v[108:111], a[28:31], v[176:191]
		v_accvgpr_read_b32 v14, a19
		v_add_u32_e32 v14, s23, v14
		v_mfma_f32_32x32x16_bf16 v[192:207], v[100:103], a[36:39], 0
		v_accvgpr_read_b32 v19, a61
		v_add_u32_e32 v19, s23, v19
		v_mfma_f32_32x32x16_bf16 v[192:207], v[104:107], a[40:43], v[192:207]
		v_accvgpr_read_b32 v21, a62
		v_add_u32_e32 v21, s23, v21
		v_mfma_f32_32x32x16_bf16 v[192:207], v[108:111], a[44:47], v[192:207]
		v_cmp_lt_i32_e64 s[50:51], v14, s20
		v_mfma_f32_32x32x16_bf16 v[96:111], v[112:115], a[20:23], 0
		v_cndmask_b32_e64 v1, v20, v1, s[48:49]
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[96:111], v[116:119], a[24:27], v[96:111]
		v_cmp_lt_i32_e64 s[48:49], v15, s20
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[52:53], v16, s20
		v_mfma_f32_32x32x16_bf16 v[96:111], v[120:123], a[28:31], v[96:111]
		v_cndmask_b32_e64 v1, v20, v8, s[48:49]
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[208:223], v[112:115], a[36:39], 0
		v_cndmask_b32_e64 v1, v20, v12, s[52:53]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[116:119], a[40:43], v[208:223]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_32x32x16_bf16 v[208:223], v[120:123], a[44:47], v[208:223]
		v_cmp_lt_i32_e64 s[48:49], v18, s20
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		v_accvgpr_read_b32 v1, a63
		v_add_u32_e32 v1, s23, v1
		v_mfma_f32_32x32x16_bf16 v[224:239], v[124:127], a[20:23], 0
		v_cndmask_b32_e64 v3, v20, v3, s[48:49]
		v_cmp_lt_i32_e64 s[48:49], v19, s20
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s35, s35, 1
		buffer_load_dwordx4 v3, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[52:53], v21, s20
		s_add_i32 s54, s45, s35
		v_mfma_f32_32x32x16_bf16 v[224:239], v[128:131], a[24:27], v[224:239]
		v_add_u32_e32 v3, s54, v2
		v_mfma_f32_32x32x16_bf16 v[224:239], a[84:87], a[28:31], v[224:239]
		v_cndmask_b32_e64 v3, v20, v3, s[50:51]
		v_cmp_lt_i32_e64 vcc, v1, s20
		s_mul_i32 s33, 0x4400, s33
		v_add_u32_e32 v1, s35, v2
		s_add_i32 s33, s37, s33
		v_add_u32_e32 v8, s46, v1
		s_add_i32 m0, s33, 0x81f0
		v_cndmask_b32_e64 v8, v20, v8, s[48:49]
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_add_u32_e32 v3, s47, v1
		v_cndmask_b32_e64 v3, v20, v3, s[52:53]
		s_add_i32 m0, m0, 0x1100
		v_add_u32_e32 v1, s32, v1
		v_cndmask_b32_e32 v1, v20, v1, vcc
		buffer_load_dwordx4 v8, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[240:255], v[124:127], a[36:39], 0
		s_add_i32 m0, m0, 0x1100
		v_mfma_f32_32x32x16_bf16 v[240:255], v[128:131], a[40:43], v[240:255]
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[240:255], a[84:87], a[44:47], v[240:255]
		s_add_i32 m0, m0, 0x1100
		s_cmp_lt_i32 s23, s41
		v_mfma_f32_32x32x16_bf16 v[144:159], a[72:75], a[32:35], v[144:159]
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[176:191], a[76:79], a[32:35], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[80:83], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[88:91], a[32:35], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[240:255], a[88:91], a[48:51], v[240:255]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[72:75], a[48:51], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[76:79], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[80:83], a[48:51], v[208:223]
		s_nop 3
		v_max3_f32 v1, v144, v145, v146
		v_max3_f32 v3, v148, v149, v150
		v_max3_f32 v8, v152, v153, v154
		v_max3_f32 v12, v156, v157, v158
		v_max3_f32 v14, v176, v177, v178
		v_max3_f32 v15, v180, v181, v182
		v_max3_f32 v16, v184, v185, v186
		v_max3_f32 v18, v188, v189, v190
		v_max3_f32 v19, v96, v97, v98
		v_max3_f32 v21, v100, v101, v102
		v_max3_f32 v22, v104, v105, v106
		v_max3_f32 v23, v108, v109, v110
		v_max3_f32 v24, v224, v225, v226
		v_max3_f32 v25, v228, v229, v230
		v_max3_f32 v26, v232, v233, v234
		v_max3_f32 v27, v236, v237, v238
		v_max3_f32 v1, v1, v147, v3
		v_max3_f32 v3, v8, v155, v12
		v_max3_f32 v8, v14, v179, v15
		v_max3_f32 v12, v16, v187, v18
		v_max3_f32 v14, v19, v99, v21
		v_max3_f32 v15, v22, v107, v23
		v_max3_f32 v16, v24, v227, v25
		v_max3_f32 v18, v26, v235, v27
		v_max3_f32 v1, v1, v151, v3
		v_max3_f32 v3, v8, v183, v12
		v_max3_f32 v8, v14, v103, v15
		v_max3_f32 v12, v16, v231, v18
		v_max3_f32 v1, v1, v159, v3
		v_max3_f32 v3, v8, v111, v12
		v_max3_f32 v1, v1, v191, v3
		v_max_f32_e32 v14, v1, v239
		v_mov_b32_e32 v15, v14
		v_max3_f32 v1, v160, v161, v162
		v_max3_f32 v3, v164, v165, v166
		v_max3_f32 v8, v168, v169, v170
		v_max3_f32 v12, v172, v173, v174
		v_max3_f32 v16, v192, v193, v194
		v_max3_f32 v18, v196, v197, v198
		v_max3_f32 v19, v200, v201, v202
		v_max3_f32 v21, v204, v205, v206
		v_max3_f32 v22, v208, v209, v210
		v_max3_f32 v23, v212, v213, v214
		v_max3_f32 v24, v216, v217, v218
		v_max3_f32 v25, v220, v221, v222
		v_max3_f32 v26, v240, v241, v242
		v_max3_f32 v27, v244, v245, v246
		v_max3_f32 v28, v248, v249, v250
		v_max3_f32 v29, v252, v253, v254
		v_permlane32_swap_b32_e32 v14, v15
		v_max3_f32 v1, v1, v163, v3
		v_max3_f32 v3, v8, v171, v12
		v_max3_f32 v8, v16, v195, v18
		v_max3_f32 v12, v19, v203, v21
		v_max3_f32 v16, v22, v211, v23
		v_max3_f32 v18, v24, v219, v25
		v_max3_f32 v19, v26, v243, v27
		v_max3_f32 v21, v28, v251, v29
		v_max3_f32 v1, v1, v167, v3
		v_max3_f32 v3, v8, v199, v12
		v_max3_f32 v8, v16, v215, v18
		v_max3_f32 v12, v19, v247, v21
		v_max3_f32 v1, v1, v175, v3
		v_max3_f32 v3, v8, v223, v12
		v_max3_f32 v1, v1, v207, v3
		v_max_f32_e32 v18, v1, v255
		v_mov_b32_e32 v19, v18
		v_max_f32_e32 v22, v14, v15
		v_mov_b32_e32 v14, v4
		v_permlane32_swap_b32_e32 v18, v19
		v_max_f32_e32 v23, v18, v19
		v_pk_mul_f32 v[18:19], v[22:23], v[6:7]
		v_max_f32_e32 v22, v4, v18
		v_max_f32_e32 v23, v9, v19
		v_pk_fma_f32 v[18:19], v[144:145], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[146:147], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[148:149], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[150:151], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[152:153], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[154:155], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[156:157], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[158:159], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[176:177], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[178:179], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[180:181], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[182:183], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[184:185], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[186:187], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[188:189], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[190:191], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[96:97], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[98:99], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[108:109], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[110:111], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[224:225], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[226:227], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[228:229], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[230:231], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[232:233], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[234:235], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[236:237], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[238:239], v[6:7], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[160:161], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[162:163], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[164:165], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[166:167], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[168:169], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[170:171], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[172:173], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[174:175], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[192:193], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[194:195], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[196:197], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[198:199], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[200:201], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[202:203], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[204:205], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[206:207], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[208:209], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[210:211], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[212:213], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[214:215], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[216:217], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[218:219], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[220:221], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[222:223], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[240:241], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[242:243], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[244:245], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[246:247], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[248:249], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[250:251], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[252:253], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[254:255], v[6:7], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v214, v18
		v_exp_f32_e32 v216, v19
		v_exp_f32_e32 v18, v24
		v_exp_f32_e32 v218, v25
		v_exp_f32_e32 v24, v26
		v_exp_f32_e32 v220, v27
		v_exp_f32_e32 v26, v28
		v_exp_f32_e32 v222, v29
		v_exp_f32_e32 v28, v30
		v_exp_f32_e32 v224, v31
		v_exp_f32_e32 v30, v112
		v_exp_f32_e32 v226, v113
		v_exp_f32_e32 v112, v114
		v_exp_f32_e32 v228, v115
		v_exp_f32_e32 v114, v116
		v_exp_f32_e32 v230, v117
		v_exp_f32_e32 v116, v118
		v_exp_f32_e32 v232, v119
		v_exp_f32_e32 v118, v120
		v_exp_f32_e32 v234, v121
		v_exp_f32_e32 v120, v122
		v_exp_f32_e32 v236, v123
		v_exp_f32_e32 v122, v124
		v_exp_f32_e32 v238, v125
		v_exp_f32_e32 v124, v126
		v_exp_f32_e32 v240, v127
		v_exp_f32_e32 v126, v128
		v_exp_f32_e32 v242, v129
		v_exp_f32_e32 v128, v130
		v_exp_f32_e32 v244, v131
		v_exp_f32_e32 v130, v132
		v_exp_f32_e32 v246, v133
		v_exp_f32_e32 v215, v134
		v_exp_f32_e32 v217, v135
		v_exp_f32_e32 v19, v96
		v_exp_f32_e32 v219, v97
		v_exp_f32_e32 v25, v98
		v_exp_f32_e32 v221, v99
		v_exp_f32_e32 v27, v100
		v_exp_f32_e32 v223, v101
		v_exp_f32_e32 v29, v102
		v_exp_f32_e32 v225, v103
		v_exp_f32_e32 v31, v104
		v_exp_f32_e32 v227, v105
		v_exp_f32_e32 v113, v106
		v_exp_f32_e32 v229, v107
		v_exp_f32_e32 v115, v108
		v_exp_f32_e32 v231, v109
		v_exp_f32_e32 v117, v110
		v_exp_f32_e32 v233, v111
		v_exp_f32_e32 v119, v136
		v_exp_f32_e32 v235, v137
		v_exp_f32_e32 v121, v138
		v_exp_f32_e32 v237, v139
		v_exp_f32_e32 v123, v140
		v_exp_f32_e32 v239, v141
		v_exp_f32_e32 v125, v142
		v_exp_f32_e32 v241, v143
		v_exp_f32_e32 v127, v144
		v_exp_f32_e32 v243, v145
		v_exp_f32_e32 v129, v146
		v_exp_f32_e32 v245, v147
		v_exp_f32_e32 v131, v148
		v_exp_f32_e32 v247, v149
		v_exp_f32_e32 v96, v150
		v_exp_f32_e32 v98, v151
		v_exp_f32_e32 v100, v152
		v_exp_f32_e32 v102, v153
		v_exp_f32_e32 v104, v154
		v_exp_f32_e32 v106, v155
		v_exp_f32_e32 v108, v156
		v_exp_f32_e32 v110, v157
		v_exp_f32_e32 v132, v158
		v_exp_f32_e32 v134, v159
		v_exp_f32_e32 v136, v160
		v_exp_f32_e32 v138, v161
		v_exp_f32_e32 v140, v162
		v_exp_f32_e32 v142, v163
		v_exp_f32_e32 v144, v164
		v_exp_f32_e32 v146, v165
		v_exp_f32_e32 v148, v166
		v_exp_f32_e32 v150, v167
		v_exp_f32_e32 v152, v168
		v_exp_f32_e32 v154, v169
		v_exp_f32_e32 v156, v170
		v_exp_f32_e32 v158, v171
		v_exp_f32_e32 v160, v172
		v_exp_f32_e32 v162, v173
		v_exp_f32_e32 v164, v174
		v_exp_f32_e32 v166, v175
		v_exp_f32_e32 v168, v176
		v_exp_f32_e32 v170, v177
		v_exp_f32_e32 v172, v178
		v_exp_f32_e32 v174, v179
		v_exp_f32_e32 v176, v180
		v_exp_f32_e32 v178, v181
		v_exp_f32_e32 v97, v182
		v_exp_f32_e32 v99, v183
		v_exp_f32_e32 v101, v184
		v_exp_f32_e32 v103, v185
		v_exp_f32_e32 v105, v186
		v_exp_f32_e32 v107, v187
		v_exp_f32_e32 v109, v188
		v_exp_f32_e32 v111, v189
		v_exp_f32_e32 v133, v190
		v_exp_f32_e32 v135, v191
		v_exp_f32_e32 v137, v192
		v_exp_f32_e32 v139, v193
		v_exp_f32_e32 v141, v194
		v_exp_f32_e32 v143, v195
		v_exp_f32_e32 v145, v196
		v_exp_f32_e32 v147, v197
		v_exp_f32_e32 v149, v198
		v_exp_f32_e32 v151, v199
		v_exp_f32_e32 v153, v200
		v_exp_f32_e32 v155, v201
		v_exp_f32_e32 v157, v202
		v_exp_f32_e32 v159, v203
		v_exp_f32_e32 v161, v204
		v_exp_f32_e32 v163, v205
		v_exp_f32_e32 v165, v206
		v_exp_f32_e32 v167, v207
		v_exp_f32_e32 v169, v208
		v_exp_f32_e32 v171, v209
		v_exp_f32_e32 v173, v210
		v_exp_f32_e32 v175, v211
		v_exp_f32_e32 v177, v212
		v_exp_f32_e32 v179, v213
		v_pk_add_f32 v[180:181], v[214:215], v[216:217]
		v_pk_add_f32 v[182:183], v[18:19], v[218:219]
		v_pk_add_f32 v[184:185], v[24:25], v[220:221]
		v_pk_add_f32 v[186:187], v[26:27], v[222:223]
		v_pk_add_f32 v[188:189], v[28:29], v[224:225]
		v_pk_add_f32 v[190:191], v[30:31], v[226:227]
		v_pk_add_f32 v[192:193], v[112:113], v[228:229]
		v_pk_add_f32 v[194:195], v[114:115], v[230:231]
		v_pk_add_f32 v[196:197], v[116:117], v[232:233]
		v_pk_add_f32 v[198:199], v[118:119], v[234:235]
		v_pk_add_f32 v[200:201], v[120:121], v[236:237]
		v_pk_add_f32 v[202:203], v[122:123], v[238:239]
		v_pk_add_f32 v[204:205], v[124:125], v[240:241]
		v_pk_add_f32 v[206:207], v[126:127], v[242:243]
		v_pk_add_f32 v[208:209], v[128:129], v[244:245]
		v_pk_add_f32 v[210:211], v[130:131], v[246:247]
		v_pk_add_f32 v[180:181], v[180:181], v[182:183]
		v_pk_add_f32 v[182:183], v[184:185], v[186:187]
		v_pk_add_f32 v[184:185], v[188:189], v[190:191]
		v_pk_add_f32 v[186:187], v[192:193], v[194:195]
		v_pk_add_f32 v[188:189], v[196:197], v[198:199]
		v_pk_add_f32 v[190:191], v[200:201], v[202:203]
		v_pk_add_f32 v[192:193], v[204:205], v[206:207]
		v_pk_add_f32 v[194:195], v[208:209], v[210:211]
		v_pk_add_f32 v[180:181], v[180:181], v[182:183]
		v_pk_add_f32 v[182:183], v[184:185], v[186:187]
		v_pk_add_f32 v[184:185], v[188:189], v[190:191]
		v_pk_add_f32 v[186:187], v[192:193], v[194:195]
		v_pk_add_f32 v[180:181], v[180:181], v[182:183]
		v_pk_add_f32 v[182:183], v[184:185], v[186:187]
		v_pk_add_f32 v[184:185], v[180:181], v[182:183]
		v_add_f32_e32 v1, v184, v185
		v_accvgpr_read_b32 v3, a69
		ds_bpermute_b32 v180, v3, v1
		v_accvgpr_read_b32 v3, a70
		ds_bpermute_b32 v182, v3, v1
		v_pk_add_f32 v[184:185], v[96:97], v[98:99]
		v_pk_add_f32 v[186:187], v[100:101], v[102:103]
		v_pk_add_f32 v[188:189], v[104:105], v[106:107]
		v_pk_add_f32 v[190:191], v[108:109], v[110:111]
		v_pk_add_f32 v[192:193], v[132:133], v[134:135]
		v_pk_add_f32 v[194:195], v[136:137], v[138:139]
		v_pk_add_f32 v[196:197], v[140:141], v[142:143]
		v_pk_add_f32 v[198:199], v[144:145], v[146:147]
		v_pk_add_f32 v[200:201], v[148:149], v[150:151]
		v_pk_add_f32 v[202:203], v[152:153], v[154:155]
		v_pk_add_f32 v[204:205], v[156:157], v[158:159]
		v_pk_add_f32 v[206:207], v[160:161], v[162:163]
		v_pk_add_f32 v[208:209], v[164:165], v[166:167]
		v_pk_add_f32 v[210:211], v[168:169], v[170:171]
		v_pk_add_f32 v[212:213], v[172:173], v[174:175]
		v_pk_add_f32 v[248:249], v[176:177], v[178:179]
		v_pk_add_f32 v[184:185], v[184:185], v[186:187]
		v_pk_add_f32 v[186:187], v[188:189], v[190:191]
		v_pk_add_f32 v[188:189], v[192:193], v[194:195]
		v_pk_add_f32 v[190:191], v[196:197], v[198:199]
		v_pk_add_f32 v[192:193], v[200:201], v[202:203]
		v_pk_add_f32 v[194:195], v[204:205], v[206:207]
		v_pk_add_f32 v[196:197], v[208:209], v[210:211]
		v_pk_add_f32 v[198:199], v[212:213], v[248:249]
		v_pk_add_f32 v[184:185], v[184:185], v[186:187]
		v_pk_add_f32 v[186:187], v[188:189], v[190:191]
		v_pk_add_f32 v[188:189], v[192:193], v[194:195]
		v_pk_add_f32 v[190:191], v[196:197], v[198:199]
		v_pk_add_f32 v[184:185], v[184:185], v[186:187]
		v_pk_add_f32 v[186:187], v[188:189], v[190:191]
		v_pk_add_f32 v[188:189], v[184:185], v[186:187]
		v_mov_b32_e32 v183, v189
		v_mov_b32_e32 v181, v188
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[184:185], v[180:181], v[182:183]
		v_mov_b32_e32 v180, v185
		v_mov_b32_e32 v181, v185
		v_cvt_pk_bf16_f32 v188, v214, v216
		v_cvt_pk_bf16_f32 v189, v18, v218
		v_permlane32_swap_b32_e32 v180, v181
		v_add_f32_e32 v183, v180, v181
		v_mov_b32_e32 v15, v9
		v_pk_add_f32 v[8:9], v[14:15], v[22:23] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v14, v8
		v_exp_f32_e32 v15, v9
		v_cvt_pk_bf16_f32 v190, v24, v220
		v_mov_b32_e32 v182, v184
		v_mov_b64_e32 v[8:9], v[10:11]
		v_pk_fma_f32 v[10:11], v[8:9], v[14:15], v[182:183]
		v_cvt_pk_bf16_f32 v191, v26, v222
		v_cvt_pk_bf16_f32 v180, v28, v224
		v_cvt_pk_bf16_f32 v181, v30, v226
		v_cvt_pk_bf16_f32 v182, v112, v228
		v_cvt_pk_bf16_f32 v183, v114, v230
		v_cvt_pk_bf16_f32 v184, v116, v232
		v_cvt_pk_bf16_f32 v185, v118, v234
		v_cvt_pk_bf16_f32 v186, v120, v236
		v_cvt_pk_bf16_f32 v187, v122, v238
		v_cvt_pk_bf16_f32 v192, v124, v240
		v_cvt_pk_bf16_f32 v193, v126, v242
		v_cvt_pk_bf16_f32 v194, v128, v244
		v_cvt_pk_bf16_f32 v195, v130, v246
		v_cvt_pk_bf16_f32 v196, v215, v217
		v_pk_mul_f32 v[32:33], v[32:33], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[34:35], v[34:35], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[36:37], v[36:37], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[38:39], v[38:39], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[40:41], v[40:41], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[42:43], v[42:43], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[44:45], v[44:45], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[46:47], v[46:47], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[48:49], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[50:51], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[52:53], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[54:55], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[56:57], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[58:59], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[60:61], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[62:63], v[14:15] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[64:65], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[66:67], v[66:67], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[68:69], v[68:69], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[70:71], v[70:71], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[72:73], v[72:73], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[74:75], v[74:75], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[76:77], v[76:77], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[78:79], v[78:79], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[80:81], v[80:81], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[82:83], v[82:83], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[84:85], v[84:85], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[86:87], v[86:87], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[88:89], v[88:89], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[90:91], v[90:91], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[92:93], v[92:93], v[14:15] op_sel:[0,1]
		v_pk_mul_f32 v[94:95], v[94:95], v[14:15] op_sel:[0,1]
		v_cvt_pk_bf16_f32 v197, v19, v219
		v_cvt_pk_bf16_f32 v198, v25, v221
		v_cvt_pk_bf16_f32 v199, v27, v223
		v_cvt_pk_bf16_f32 v24, v29, v225
		v_cvt_pk_bf16_f32 v25, v31, v227
		v_cvt_pk_bf16_f32 v26, v113, v229
		v_cvt_pk_bf16_f32 v27, v115, v231
		v_cvt_pk_bf16_f32 v28, v117, v233
		v_cvt_pk_bf16_f32 v29, v119, v235
		v_cvt_pk_bf16_f32 v30, v121, v237
		v_cvt_pk_bf16_f32 v31, v123, v239
		v_cvt_pk_bf16_f32 v112, v125, v241
		v_cvt_pk_bf16_f32 v113, v127, v243
		v_cvt_pk_bf16_f32 v114, v129, v245
		v_cvt_pk_bf16_f32 v115, v131, v247
		v_cvt_pk_bf16_f32 v116, v96, v98
		v_cvt_pk_bf16_f32 v117, v100, v102
		v_cvt_pk_bf16_f32 v118, v104, v106
		v_cvt_pk_bf16_f32 v119, v108, v110
		v_cvt_pk_bf16_f32 v120, v132, v134
		v_cvt_pk_bf16_f32 v121, v136, v138
		v_cvt_pk_bf16_f32 v122, v140, v142
		v_cvt_pk_bf16_f32 v123, v144, v146
		v_cvt_pk_bf16_f32 v124, v148, v150
		v_cvt_pk_bf16_f32 v125, v152, v154
		v_cvt_pk_bf16_f32 v126, v156, v158
		v_cvt_pk_bf16_f32 v127, v160, v162
		v_cvt_pk_bf16_f32 v128, v164, v166
		v_cvt_pk_bf16_f32 v129, v168, v170
		v_cvt_pk_bf16_f32 v130, v172, v174
		v_cvt_pk_bf16_f32 v131, v176, v178
		v_cvt_pk_bf16_f32 v200, v97, v99
		v_cvt_pk_bf16_f32 v201, v101, v103
		v_cvt_pk_bf16_f32 v202, v105, v107
		v_cvt_pk_bf16_f32 v203, v109, v111
		v_cvt_pk_bf16_f32 v96, v133, v135
		v_cvt_pk_bf16_f32 v97, v137, v139
		v_cvt_pk_bf16_f32 v98, v141, v143
		v_cvt_pk_bf16_f32 v99, v145, v147
		v_cvt_pk_bf16_f32 v100, v149, v151
		v_cvt_pk_bf16_f32 v101, v153, v155
		v_cvt_pk_bf16_f32 v102, v157, v159
		v_cvt_pk_bf16_f32 v103, v161, v163
		v_cvt_pk_bf16_f32 v104, v165, v167
		v_cvt_pk_bf16_f32 v105, v169, v171
		v_cvt_pk_bf16_f32 v106, v173, v175
		v_cvt_pk_bf16_f32 v107, v177, v179
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		v_mfma_f32_32x32x16_bf16 v[32:47], a[92:95], v[188:191], v[32:47]
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_mfma_f32_32x32x16_bf16 v[48:63], a[124:127], v[188:191], v[48:63]
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_mfma_f32_32x32x16_bf16 v[32:47], a[96:99], v[180:183], v[32:47]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[48:63], a[128:131], v[180:183], v[48:63]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[32:47], a[100:103], v[184:187], v[32:47]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[48:63], a[132:135], v[184:187], v[48:63]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[32:47], a[104:107], v[192:195], v[32:47]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[48:63], a[136:139], v[192:195], v[48:63]
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_mfma_f32_32x32x16_bf16 v[80:95], a[124:127], v[116:119], v[80:95]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[64:79], a[92:95], v[116:119], v[64:79]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[80:95], a[128:131], v[120:123], v[80:95]
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_mfma_f32_32x32x16_bf16 v[64:79], a[96:99], v[120:123], v[64:79]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[80:95], a[132:135], v[124:127], v[80:95]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[64:79], a[100:103], v[124:127], v[64:79]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[80:95], a[136:139], v[128:131], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[104:107], v[128:131], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[108:111], v[196:199], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[140:143], v[196:199], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[140:143], v[200:203], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[108:111], v[200:203], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[112:115], v[24:27], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[144:147], v[24:27], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[112:115], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[116:119], v[28:31], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[148:151], v[28:31], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[148:151], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[116:119], v[100:103], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[120:123], v[112:115], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[152:155], v[112:115], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], v[104:107], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[120:123], v[104:107], v[64:79]
		v_mov_b32_e32 v4, v22
		v_mov_b32_e32 v9, v23
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
		v_xor_b32_e32 v8, 1, v5
		v_accvgpr_write_b32 a15, v8
		v_xor_b32_e32 v8, 2, v5
		v_accvgpr_write_b32 a16, v8
		v_xor_b32_e32 v8, 3, v5
		v_accvgpr_write_b32 a66, v8
		v_xor_b32_e32 v8, 8, v5
		v_accvgpr_write_b32 a71, v8
		v_xor_b32_e32 v8, 9, v5
		v_accvgpr_write_b32 a72, v8
		v_xor_b32_e32 v8, 10, v5
		v_accvgpr_write_b32 a73, v8
		v_xor_b32_e32 v8, 11, v5
		v_accvgpr_write_b32 a74, v8
		v_xor_b32_e32 v8, 16, v5
		v_accvgpr_write_b32 a75, v8
		v_xor_b32_e32 v8, 17, v5
		v_accvgpr_write_b32 a76, v8
		v_xor_b32_e32 v8, 18, v5
		v_accvgpr_write_b32 a77, v8
		v_xor_b32_e32 v8, 19, v5
		v_accvgpr_write_b32 a78, v8
		v_xor_b32_e32 v8, 24, v5
		v_accvgpr_write_b32 a79, v8
		v_xor_b32_e32 v8, 25, v5
		v_accvgpr_write_b32 a80, v8
		v_xor_b32_e32 v8, 26, v5
		v_accvgpr_write_b32 a81, v8
		v_xor_b32_e32 v8, 27, v5
		v_accvgpr_write_b32 a82, v8
		v_xor_b32_e32 v8, 32, v5
		v_accvgpr_write_b32 a83, v8
		v_xor_b32_e32 v8, 33, v5
		v_accvgpr_write_b32 a84, v8
		v_xor_b32_e32 v8, 34, v5
		v_accvgpr_write_b32 a85, v8
		v_xor_b32_e32 v8, 35, v5
		v_accvgpr_write_b32 a86, v8
		v_xor_b32_e32 v8, 40, v5
		v_accvgpr_write_b32 a87, v8
		v_xor_b32_e32 v8, 41, v5
		v_accvgpr_write_b32 a88, v8
		v_xor_b32_e32 v8, 42, v5
		v_accvgpr_write_b32 a89, v8
		v_xor_b32_e32 v8, 43, v5
		v_accvgpr_write_b32 a90, v8
		v_xor_b32_e32 v8, 48, v5
		v_accvgpr_write_b32 a91, v8
		v_xor_b32_e32 v8, 49, v5
		v_accvgpr_write_b32 a92, v8
		v_xor_b32_e32 v8, 50, v5
		v_accvgpr_write_b32 a93, v8
		v_xor_b32_e32 v8, 51, v5
		v_accvgpr_write_b32 a94, v8
		v_xor_b32_e32 v8, 56, v5
		v_accvgpr_write_b32 a95, v8
		v_xor_b32_e32 v8, 57, v5
		v_accvgpr_write_b32 a96, v8
		v_xor_b32_e32 v8, 58, v5
		v_accvgpr_write_b32 a97, v8
		v_xor_b32_e32 v8, 59, v5
		v_accvgpr_write_b32 a98, v8
		v_xor_b32_e32 v8, 64, v5
		v_accvgpr_write_b32 a99, v8
		v_xor_b32_e32 v8, 0x41, v5
		v_accvgpr_write_b32 a100, v8
		v_xor_b32_e32 v8, 0x42, v5
		v_accvgpr_write_b32 a101, v8
		v_xor_b32_e32 v8, 0x43, v5
		v_accvgpr_write_b32 a102, v8
		v_xor_b32_e32 v8, 0x48, v5
		v_accvgpr_write_b32 a103, v8
		v_xor_b32_e32 v8, 0x49, v5
		v_accvgpr_write_b32 a104, v8
		v_xor_b32_e32 v8, 0x4a, v5
		v_accvgpr_write_b32 a105, v8
		v_xor_b32_e32 v8, 0x4b, v5
		v_accvgpr_write_b32 a106, v8
		v_xor_b32_e32 v8, 0x50, v5
		v_accvgpr_write_b32 a107, v8
		v_xor_b32_e32 v8, 0x51, v5
		v_accvgpr_write_b32 a108, v8
		v_xor_b32_e32 v8, 0x52, v5
		v_accvgpr_write_b32 a109, v8
		v_xor_b32_e32 v8, 0x53, v5
		v_accvgpr_write_b32 a110, v8
		v_xor_b32_e32 v8, 0x58, v5
		v_accvgpr_write_b32 a111, v8
		v_xor_b32_e32 v8, 0x59, v5
		v_accvgpr_write_b32 a112, v8
		v_xor_b32_e32 v8, 0x5a, v5
		v_accvgpr_write_b32 a113, v8
		v_xor_b32_e32 v8, 0x5b, v5
		v_accvgpr_write_b32 a114, v8
		v_xor_b32_e32 v8, 0x60, v5
		v_accvgpr_write_b32 a115, v8
		v_xor_b32_e32 v8, 0x61, v5
		v_accvgpr_write_b32 a116, v8
		v_xor_b32_e32 v8, 0x62, v5
		v_accvgpr_write_b32 a117, v8
		v_xor_b32_e32 v8, 0x63, v5
		v_accvgpr_write_b32 a118, v8
		v_xor_b32_e32 v8, 0x68, v5
		v_accvgpr_write_b32 a119, v8
		v_xor_b32_e32 v8, 0x69, v5
		v_accvgpr_write_b32 a120, v8
		v_xor_b32_e32 v8, 0x6a, v5
		v_accvgpr_write_b32 a121, v8
		v_xor_b32_e32 v8, 0x6b, v5
		v_accvgpr_write_b32 a122, v8
		v_xor_b32_e32 v8, 0x70, v5
		v_accvgpr_write_b32 a123, v8
		v_xor_b32_e32 v8, 0x71, v5
		v_accvgpr_write_b32 a124, v8
		v_xor_b32_e32 v8, 0x72, v5
		v_accvgpr_write_b32 a125, v8
		v_xor_b32_e32 v8, 0x73, v5
		v_accvgpr_write_b32 a126, v8
		v_xor_b32_e32 v8, 0x78, v5
		v_accvgpr_write_b32 a127, v8
		v_xor_b32_e32 v8, 0x79, v5
		v_accvgpr_write_b32 a128, v8
		v_xor_b32_e32 v8, 0x7a, v5
		v_accvgpr_write_b32 a129, v8
		v_xor_b32_e32 v8, 0x7b, v5
		v_accvgpr_write_b32 a130, v8
		v_accvgpr_read_b32 v8, a56
		v_accvgpr_read_b32 v12, a64
		v_add3_u32 v8, v8, v12, v13
		v_accvgpr_write_b32 a56, v8
		v_accvgpr_read_b32 v8, a65
		v_accvgpr_read_b32 v12, a67
		v_lshl_add_u32 v8, v8, 3, v12
		v_accvgpr_read_b32 v12, a58
		v_accvgpr_read_b32 v13, a68
		v_add3_u32 v8, v8, v13, v12
		v_accvgpr_write_b32 a58, v8
		v_mov_b32_e32 v8, 0xff800000
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
		v_accvgpr_read_b32 v12, a56
		v_add_u32_e32 v12, s23, v12
		ds_read_b128 v[24:27], v12
		ds_read_b128 a[132:135], v12 offset:32
		ds_read_b128 a[136:139], v12 offset:64
		ds_read_b128 a[140:143], v12 offset:96
		ds_read_b128 a[144:147], v12 offset:256
		ds_read_b128 a[148:151], v12 offset:288
		ds_read_b128 a[152:155], v12 offset:320
		ds_read_b128 a[156:159], v12 offset:352
		ds_read_b128 a[160:163], v12 offset:128
		ds_read_b128 a[164:167], v12 offset:160
		ds_read_b128 a[168:171], v12 offset:192
		ds_read_b128 a[172:175], v12 offset:224
		ds_read_b128 v[28:31], v12 offset:384
		ds_read_b128 a[176:179], v12 offset:416
		ds_read_b128 a[180:183], v12 offset:448
		ds_read_b128 a[184:187], v12 offset:480
		s_mul_i32 s23, 0x4400, s33
		v_accvgpr_read_b32 v12, a58
		v_add_u32_e32 v12, s23, v12
		ds_read_b64_tr_b16 a[188:189], v12 offset:33264
		ds_read_b64_tr_b16 a[190:191], v12 offset:37616
		ds_read_b64_tr_b16 a[192:193], v12 offset:33392
		ds_read_b64_tr_b16 a[194:195], v12 offset:37744
		ds_read_b64_tr_b16 a[196:197], v12 offset:33520
		ds_read_b64_tr_b16 a[198:199], v12 offset:37872
		ds_read_b64_tr_b16 a[200:201], v12 offset:33648
		ds_read_b64_tr_b16 a[202:203], v12 offset:38000
		ds_read_b64_tr_b16 a[204:205], v12 offset:33776
		ds_read_b64_tr_b16 a[206:207], v12 offset:38128
		ds_read_b64_tr_b16 a[208:209], v12 offset:33904
		ds_read_b64_tr_b16 a[210:211], v12 offset:38256
		ds_read_b64_tr_b16 a[212:213], v12 offset:34032
		ds_read_b64_tr_b16 a[214:215], v12 offset:38384
		ds_read_b64_tr_b16 a[216:217], v12 offset:34160
		ds_read_b64_tr_b16 a[218:219], v12 offset:38512
		ds_read_b64_tr_b16 a[220:221], v12 offset:33328
		ds_read_b64_tr_b16 a[222:223], v12 offset:37680
		ds_read_b64_tr_b16 a[224:225], v12 offset:33456
		ds_read_b64_tr_b16 a[226:227], v12 offset:37808
		ds_read_b64_tr_b16 a[228:229], v12 offset:33584
		ds_read_b64_tr_b16 a[230:231], v12 offset:37936
		ds_read_b64_tr_b16 a[232:233], v12 offset:33712
		ds_read_b64_tr_b16 a[234:235], v12 offset:38064
		ds_read_b64_tr_b16 a[236:237], v12 offset:33840
		ds_read_b64_tr_b16 a[238:239], v12 offset:38192
		ds_read_b64_tr_b16 a[240:241], v12 offset:33968
		ds_read_b64_tr_b16 a[242:243], v12 offset:38320
		ds_read_b64_tr_b16 a[244:245], v12 offset:34096
		ds_read_b64_tr_b16 a[246:247], v12 offset:38448
		ds_read_b64_tr_b16 a[248:249], v12 offset:34224
		ds_read_b64_tr_b16 a[250:251], v12 offset:38576
		s_cmp_lt_i32 s1, s18
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_4
		v_accvgpr_read_b32 v12, a18
		v_add_u32_e32 v12, s1, v12
		v_cmp_lt_i32_e64 s[50:51], v12, s20
		v_accvgpr_read_b32 v12, a19
		v_add_u32_e32 v12, s1, v12
		v_cmp_lt_i32_e64 s[52:53], v12, s20
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s23, s15, s41
		s_lshl_b32 s23, s23, 1
		s_add_i32 s33, s42, s23
		v_add_u32_e32 v12, s33, v17
		v_cndmask_b32_e64 v12, v20, v12, s[50:51]
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
		v_accvgpr_read_b32 v13, a57
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v13, s20
		s_add_i32 s33, s43, s23
		v_add_u32_e32 v12, s33, v17
		v_cndmask_b32_e64 v12, v20, v12, s[54:55]
		s_add_u32 s54, s56, 0x1040
		s_addc_u32 s55, s57, 0
		s_add_u32 s54, s54, s58
		s_addc_u32 s55, s55, s59
		s_add_u32 s60, s54, 0
		s_addc_u32 s61, s55, 0
		s_mov_b32 m0, s60
		v_accvgpr_read_b32 v13, a59
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v13, s20
		s_add_i32 s33, s44, s23
		v_add_u32_e32 v12, s33, v17
		v_cndmask_b32_e64 v12, v20, v12, s[54:55]
		s_add_u32 s54, s56, 0x2080
		s_addc_u32 s55, s57, 0
		s_add_u32 s54, s54, s58
		s_addc_u32 s55, s55, s59
		s_add_u32 s60, s54, 0
		s_addc_u32 s61, s55, 0
		s_mov_b32 m0, s60
		v_accvgpr_read_b32 v13, a60
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v13, s20
		s_add_i32 s23, s36, s23
		v_add_u32_e32 v12, s23, v17
		v_cndmask_b32_e64 v12, v20, v12, s[54:55]
		s_add_u32 s54, s56, 0x30c0
		s_addc_u32 s55, s57, 0
		s_add_u32 s54, s54, s58
		s_addc_u32 s55, s55, s59
		s_add_u32 s56, s54, 0
		s_addc_u32 s57, s55, 0
		s_mov_b32 m0, s56
		v_accvgpr_read_b32 v13, a61
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		s_mul_i32 s23, s17, s41
		s_lshl_b32 s23, s23, 1
		s_add_i32 s33, s45, s23
		v_add_u32_e32 v12, s33, v2
		v_cndmask_b32_e64 v12, v20, v12, s[52:53]
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
		v_accvgpr_read_b32 v14, a62
		v_add_u32_e32 v14, s1, v14
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[48:49], v13, s20
		s_add_i32 s33, s46, s23
		v_add_u32_e32 v12, s33, v2
		v_cndmask_b32_e64 v12, v20, v12, s[48:49]
		s_add_u32 s48, s54, 0x92f0
		s_addc_u32 s49, s55, 0
		s_add_u32 s48, s48, s56
		s_addc_u32 s49, s49, s57
		s_add_u32 s50, s48, 0
		s_addc_u32 s51, s49, 0
		s_mov_b32 m0, s50
		v_accvgpr_read_b32 v13, a63
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[48:49], v14, s20
		s_add_i32 s33, s47, s23
		v_add_u32_e32 v12, s33, v2
		s_add_u32 s50, s54, 0xa3f0
		s_addc_u32 s51, s55, 0
		s_add_u32 s50, s50, s56
		s_addc_u32 s51, s51, s57
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		v_cndmask_b32_e64 v12, v20, v12, s[48:49]
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		s_add_i32 s23, s32, s23
		v_cmp_lt_i32_e64 vcc, v13, s20
		v_add_u32_e32 v12, s23, v2
		s_add_u32 s48, s54, 0xb4f0
		s_addc_u32 s49, s55, 0
		v_cndmask_b32_e32 v12, v20, v12, vcc
		s_add_u32 s48, s48, s56
		s_addc_u32 s49, s49, s57
		s_add_u32 s50, s48, 0
		s_addc_u32 s51, s49, 0
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_4
.L_attn_fwd_persistent.if_else_4:
.L_attn_fwd_persistent.if_end_4:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[96:111], v[24:27], a[20:23], 0
		s_cmp_lt_i32 s1, s21
		v_mfma_f32_32x32x16_bf16 v[112:127], a[144:147], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[128:143], a[160:163], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[28:31], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[176:191], v[24:27], a[36:39], 0
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
		v_add_u32_e32 v12, s41, v5
		v_mfma_f32_32x32x16_bf16 v[176:191], a[136:139], a[44:47], v[176:191]
		v_accvgpr_read_b32 v13, a15
		v_add_u32_e32 v13, s41, v13
		v_mfma_f32_32x32x16_bf16 v[192:207], a[152:155], a[44:47], v[192:207]
		v_accvgpr_read_b32 v14, a16
		v_add_u32_e32 v14, s41, v14
		v_mfma_f32_32x32x16_bf16 v[208:223], a[168:171], a[44:47], v[208:223]
		v_accvgpr_read_b32 v15, a66
		v_add_u32_e32 v15, s41, v15
		v_mfma_f32_32x32x16_bf16 v[96:111], a[140:143], a[32:35], v[96:111]
		v_cmp_ge_i32_e64 vcc, v1, v15
		v_mfma_f32_32x32x16_bf16 v[112:127], a[156:159], a[32:35], v[112:127]
		v_accvgpr_read_b32 v16, a73
		v_add_u32_e32 v16, s41, v16
		v_mfma_f32_32x32x16_bf16 v[128:143], a[172:175], a[32:35], v[128:143]
		v_accvgpr_read_b32 v18, a74
		v_add_u32_e32 v18, s41, v18
		v_mfma_f32_32x32x16_bf16 v[144:159], a[184:187], a[32:35], v[144:159]
		v_accvgpr_read_b32 v19, a77
		v_add_u32_e32 v19, s41, v19
		v_mfma_f32_32x32x16_bf16 v[160:175], a[184:187], a[48:51], v[160:175]
		v_accvgpr_read_b32 v21, a78
		v_add_u32_e32 v21, s41, v21
		v_mfma_f32_32x32x16_bf16 v[176:191], a[140:143], a[48:51], v[176:191]
		v_accvgpr_read_b32 v22, a81
		v_add_u32_e32 v22, s41, v22
		v_mfma_f32_32x32x16_bf16 v[192:207], a[156:159], a[48:51], v[192:207]
		v_cndmask_b32_e32 v25, v8, v99, vcc
		v_mfma_f32_32x32x16_bf16 v[208:223], a[172:175], a[48:51], v[208:223]
		v_accvgpr_read_b32 v23, a82
		v_add_u32_e32 v23, s41, v23
		v_accvgpr_read_b32 v24, a85
		v_add_u32_e32 v26, s41, v24
		v_accvgpr_read_b32 v24, a86
		v_add_u32_e32 v27, s41, v24
		v_accvgpr_read_b32 v24, a89
		v_add_u32_e32 v28, s41, v24
		v_accvgpr_read_b32 v24, a90
		v_add_u32_e32 v29, s41, v24
		v_accvgpr_read_b32 v24, a93
		v_add_u32_e32 v30, s41, v24
		v_accvgpr_read_b32 v24, a94
		v_add_u32_e32 v31, s41, v24
		v_accvgpr_read_b32 v24, a97
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a64, v24
		v_accvgpr_read_b32 v24, a98
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a65, v24
		v_accvgpr_read_b32 v24, a101
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a67, v24
		v_accvgpr_read_b32 v24, a102
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a68, v24
		v_accvgpr_read_b32 v24, a105
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a131, v24
		v_accvgpr_read_b32 v24, a106
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a132, v24
		v_accvgpr_read_b32 v24, a109
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a133, v24
		v_accvgpr_read_b32 v24, a110
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a134, v24
		v_accvgpr_read_b32 v24, a113
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a135, v24
		v_accvgpr_read_b32 v24, a114
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a136, v24
		v_accvgpr_read_b32 v24, a117
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a137, v24
		v_accvgpr_read_b32 v24, a118
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a138, v24
		v_accvgpr_read_b32 v24, a121
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a139, v24
		v_accvgpr_read_b32 v24, a122
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a140, v24
		v_accvgpr_read_b32 v24, a125
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a141, v24
		v_accvgpr_read_b32 v24, a126
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a142, v24
		v_accvgpr_read_b32 v24, a129
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a143, v24
		v_accvgpr_read_b32 v24, a130
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a144, v24
		v_cmp_ge_i32_e64 s[48:49], v1, v12
		v_cmp_ge_i32_e64 s[50:51], v1, v13
		v_cmp_ge_i32_e64 s[52:53], v1, v14
		v_accvgpr_read_b32 v24, a71
		v_add_u32_e32 v99, s41, v24
		v_accvgpr_read_b32 v24, a72
		v_add_u32_e32 v224, s41, v24
		v_cmp_ge_i32_e64 s[54:55], v1, v99
		v_cmp_ge_i32_e64 s[56:57], v1, v224
		v_cmp_ge_i32_e64 s[58:59], v1, v16
		v_cmp_ge_i32_e64 vcc, v1, v18
		v_accvgpr_read_b32 v24, a75
		v_add_u32_e32 v225, s41, v24
		v_accvgpr_read_b32 v24, a76
		v_add_u32_e32 v226, s41, v24
		v_cndmask_b32_e32 v229, v8, v103, vcc
		v_cmp_ge_i32_e64 s[60:61], v1, v225
		v_cmp_ge_i32_e64 s[62:63], v1, v226
		v_cmp_ge_i32_e64 s[64:65], v1, v19
		v_cmp_ge_i32_e64 vcc, v1, v21
		v_accvgpr_read_b32 v24, a79
		v_add_u32_e32 v103, s41, v24
		v_accvgpr_read_b32 v24, a80
		v_add_u32_e32 v227, s41, v24
		v_cndmask_b32_e32 v231, v8, v107, vcc
		v_cmp_ge_i32_e64 s[66:67], v1, v103
		v_cmp_ge_i32_e64 s[68:69], v1, v227
		v_cmp_ge_i32_e64 s[70:71], v1, v22
		v_cmp_ge_i32_e64 vcc, v1, v23
		v_accvgpr_read_b32 v24, a83
		v_add_u32_e32 v107, s41, v24
		v_accvgpr_read_b32 v24, a84
		v_add_u32_e32 v232, s41, v24
		v_cndmask_b32_e32 v235, v8, v111, vcc
		v_cmp_ge_i32_e64 s[72:73], v1, v107
		v_cmp_ge_i32_e64 s[74:75], v1, v232
		v_cmp_ge_i32_e64 s[76:77], v1, v26
		v_cmp_ge_i32_e64 vcc, v1, v27
		v_accvgpr_read_b32 v24, a87
		v_add_u32_e32 v111, s41, v24
		v_accvgpr_read_b32 v24, a88
		v_add_u32_e32 v233, s41, v24
		v_cndmask_b32_e32 v237, v8, v115, vcc
		v_cmp_ge_i32_e64 s[78:79], v1, v111
		v_cmp_ge_i32_e64 s[80:81], v1, v233
		v_cmp_ge_i32_e64 s[82:83], v1, v28
		v_cmp_ge_i32_e64 vcc, v1, v29
		v_accvgpr_read_b32 v24, a91
		v_add_u32_e32 v115, s41, v24
		v_accvgpr_read_b32 v24, a92
		v_add_u32_e32 v236, s41, v24
		v_cndmask_b32_e32 v239, v8, v119, vcc
		v_cmp_ge_i32_e64 s[84:85], v1, v115
		v_cmp_ge_i32_e64 s[86:87], v1, v236
		v_cmp_ge_i32_e64 vcc, v1, v31
		v_accvgpr_read_b32 v24, a95
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a145, v24
		v_accvgpr_read_b32 v24, a96
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a146, v24
		v_cndmask_b32_e32 v241, v8, v123, vcc
		v_accvgpr_read_b32 v24, a65
		v_cmp_ge_i32_e64 vcc, v1, v24
		v_accvgpr_read_b32 v24, a99
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a147, v24
		v_accvgpr_read_b32 v24, a100
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a148, v24
		v_cndmask_b32_e32 v243, v8, v127, vcc
		v_accvgpr_read_b32 v24, a68
		v_cmp_ge_i32_e64 vcc, v1, v24
		v_accvgpr_read_b32 v24, a103
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a149, v24
		v_accvgpr_read_b32 v24, a104
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a150, v24
		v_cndmask_b32_e32 v245, v8, v131, vcc
		v_accvgpr_read_b32 v24, a132
		v_cmp_ge_i32_e64 vcc, v1, v24
		v_accvgpr_read_b32 v24, a107
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a151, v24
		v_accvgpr_read_b32 v24, a108
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a152, v24
		v_cndmask_b32_e32 v247, v8, v135, vcc
		v_accvgpr_read_b32 v24, a134
		v_cmp_ge_i32_e64 vcc, v1, v24
		v_accvgpr_read_b32 v24, a111
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a153, v24
		v_accvgpr_read_b32 v24, a112
		v_add_u32_e32 v24, s41, v24
		v_accvgpr_write_b32 a154, v24
		v_cndmask_b32_e32 v249, v8, v139, vcc
		v_accvgpr_read_b32 v24, a136
		v_cmp_ge_i32_e64 vcc, v1, v24
		v_cmp_ge_i32_e64 s[88:89], v1, v30
		v_cndmask_b32_e64 v250, v8, v96, s[48:49]
		v_accvgpr_read_b32 v24, a145
		v_cmp_ge_i32_e64 s[48:49], v1, v24
		s_nop 1
		v_mov_b32_e32 v252, s48
		v_mov_b32_e32 v253, s49
		v_accvgpr_write_b32 a156, v252
		v_accvgpr_write_b32 a157, v253
		v_accvgpr_read_b32 v24, a146
		v_cmp_ge_i32_e64 s[48:49], v1, v24
		s_nop 1
		v_mov_b32_e32 v252, s48
		v_mov_b32_e32 v253, s49
		v_accvgpr_write_b32 a158, v252
		v_accvgpr_write_b32 a159, v253
		v_accvgpr_read_b32 v24, a64
		v_cmp_ge_i32_e64 s[48:49], v1, v24
		s_nop 1
		v_mov_b32_e32 v252, s48
		v_mov_b32_e32 v253, s49
		v_accvgpr_write_b32 a160, v252
		v_accvgpr_write_b32 a161, v253
		v_accvgpr_read_b32 v24, a147
		v_cmp_ge_i32_e64 s[48:49], v1, v24
		s_nop 1
		v_mov_b32_e32 v252, s48
		v_mov_b32_e32 v253, s49
		v_accvgpr_write_b32 a162, v252
		v_accvgpr_write_b32 a163, v253
		v_accvgpr_read_b32 v24, a148
		v_cmp_ge_i32_e64 s[48:49], v1, v24
		s_nop 1
		v_mov_b32_e32 v252, s48
		v_mov_b32_e32 v253, s49
		v_accvgpr_write_b32 a164, v252
		v_accvgpr_write_b32 a165, v253
		v_accvgpr_read_b32 v24, a67
		v_cmp_ge_i32_e64 s[48:49], v1, v24
		s_nop 1
		v_mov_b32_e32 v252, s48
		v_mov_b32_e32 v253, s49
		v_accvgpr_write_b32 a166, v252
		v_accvgpr_write_b32 a167, v253
		v_accvgpr_read_b32 v24, a149
		v_cmp_ge_i32_e64 s[48:49], v1, v24
		s_nop 1
		v_mov_b32_e32 v252, s48
		v_mov_b32_e32 v253, s49
		v_accvgpr_write_b32 a168, v252
		v_accvgpr_write_b32 a169, v253
		v_accvgpr_read_b32 v24, a150
		v_cmp_ge_i32_e64 s[48:49], v1, v24
		s_nop 1
		v_mov_b32_e32 v252, s48
		v_mov_b32_e32 v253, s49
		v_accvgpr_write_b32 a170, v252
		v_accvgpr_write_b32 a171, v253
		v_accvgpr_read_b32 v24, a131
		v_cmp_ge_i32_e64 s[48:49], v1, v24
		s_nop 1
		v_mov_b32_e32 v252, s48
		v_mov_b32_e32 v253, s49
		v_accvgpr_write_b32 a172, v252
		v_accvgpr_write_b32 a173, v253
		v_accvgpr_read_b32 v24, a151
		v_cmp_ge_i32_e64 s[48:49], v1, v24
		s_nop 1
		v_mov_b32_e32 v252, s48
		v_mov_b32_e32 v253, s49
		v_accvgpr_write_b32 a174, v252
		v_accvgpr_write_b32 a175, v253
		v_accvgpr_read_b32 v24, a152
		v_cmp_ge_i32_e64 s[48:49], v1, v24
		s_nop 1
		v_mov_b32_e32 v252, s48
		v_mov_b32_e32 v253, s49
		v_accvgpr_write_b32 a176, v252
		v_accvgpr_write_b32 a177, v253
		v_accvgpr_read_b32 v24, a133
		v_cmp_ge_i32_e64 s[48:49], v1, v24
		s_nop 1
		v_mov_b32_e32 v252, s48
		v_mov_b32_e32 v253, s49
		v_accvgpr_write_b32 a178, v252
		v_accvgpr_write_b32 a179, v253
		v_accvgpr_read_b32 v24, a153
		v_cmp_ge_i32_e64 s[48:49], v1, v24
		v_accvgpr_read_b32 v24, a154
		v_cmp_ge_i32_e64 s[90:91], v1, v24
		v_accvgpr_read_b32 v24, a135
		v_cmp_ge_i32_e64 s[92:93], v1, v24
		v_cndmask_b32_e32 v253, v8, v143, vcc
		v_cndmask_b32_e64 v255, v8, v141, s[90:91]
		v_cndmask_b32_e64 v252, v8, v142, s[92:93]
		v_accvgpr_read_b32 v24, a115
		v_add_u32_e32 v96, s41, v24
		v_accvgpr_read_b32 v24, a116
		v_add_u32_e32 v119, s41, v24
		v_cmp_ge_i32_e64 s[90:91], v1, v96
		v_cmp_ge_i32_e64 s[92:93], v1, v119
		v_accvgpr_read_b32 v24, a137
		v_cmp_ge_i32_e64 s[94:95], v1, v24
		v_cndmask_b32_e64 v142, v8, v144, s[90:91]
		v_cndmask_b32_e64 v143, v8, v145, s[92:93]
		v_cndmask_b32_e64 v144, v8, v146, s[94:95]
		v_accvgpr_read_b32 v24, a138
		v_cmp_ge_i32_e64 vcc, v1, v24
		v_accvgpr_read_b32 v24, a119
		v_add_u32_e32 v123, s41, v24
		v_accvgpr_read_b32 v24, a120
		v_add_u32_e32 v127, s41, v24
		v_cndmask_b32_e32 v145, v8, v147, vcc
		v_cmp_ge_i32_e64 s[90:91], v1, v123
		v_cmp_ge_i32_e64 s[92:93], v1, v127
		v_accvgpr_read_b32 v24, a139
		v_cmp_ge_i32_e64 s[94:95], v1, v24
		v_cndmask_b32_e64 v146, v8, v148, s[90:91]
		v_cndmask_b32_e64 v147, v8, v149, s[92:93]
		v_cndmask_b32_e64 v148, v8, v150, s[94:95]
		v_accvgpr_read_b32 v24, a140
		v_cmp_ge_i32_e64 vcc, v1, v24
		v_accvgpr_read_b32 v24, a123
		v_add_u32_e32 v131, s41, v24
		v_accvgpr_read_b32 v24, a124
		v_add_u32_e32 v135, s41, v24
		v_cndmask_b32_e32 v149, v8, v151, vcc
		v_cmp_ge_i32_e64 s[90:91], v1, v131
		v_cmp_ge_i32_e64 s[92:93], v1, v135
		v_accvgpr_read_b32 v24, a141
		v_cmp_ge_i32_e64 s[94:95], v1, v24
		v_cndmask_b32_e64 v150, v8, v152, s[90:91]
		v_cndmask_b32_e64 v151, v8, v153, s[92:93]
		v_cndmask_b32_e64 v152, v8, v154, s[94:95]
		v_accvgpr_read_b32 v24, a142
		v_cmp_ge_i32_e64 vcc, v1, v24
		v_accvgpr_read_b32 v24, a127
		v_add_u32_e32 v139, s41, v24
		v_accvgpr_read_b32 v24, a128
		v_add_u32_e32 v141, s41, v24
		v_cndmask_b32_e32 v153, v8, v155, vcc
		v_cmp_ge_i32_e64 s[90:91], v1, v139
		v_cmp_ge_i32_e64 s[92:93], v1, v141
		v_accvgpr_read_b32 v24, a143
		v_cmp_ge_i32_e64 s[94:95], v1, v24
		v_cndmask_b32_e64 v154, v8, v156, s[90:91]
		v_cndmask_b32_e64 v155, v8, v157, s[92:93]
		v_cndmask_b32_e64 v156, v8, v158, s[94:95]
		v_cndmask_b32_e64 v251, v8, v97, s[50:51]
		v_accvgpr_read_b32 v24, a144
		v_cmp_ge_i32_e64 vcc, v1, v24
		v_max3_f32 v97, v142, v143, v144
		v_max3_f32 v158, v146, v147, v148
		v_cndmask_b32_e32 v157, v8, v159, vcc
		v_cmp_ge_i32_e64 s[50:51], v3, v12
		v_cmp_ge_i32_e64 s[90:91], v3, v13
		v_cmp_ge_i32_e64 s[92:93], v3, v14
		v_max3_f32 v12, v150, v151, v152
		v_accvgpr_write_b32 a155, v12
		v_max3_f32 v12, v154, v155, v156
		v_accvgpr_write_b32 a180, v12
		v_cndmask_b32_e64 v12, v8, v178, s[92:93]
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_cndmask_b32_e64 v24, v8, v98, s[52:53]
		v_cndmask_b32_e64 v14, v8, v100, s[54:55]
		v_cndmask_b32_e32 v13, v8, v179, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v99
		v_cmp_ge_i32_e64 s[54:55], v3, v224
		v_cmp_ge_i32_e64 s[92:93], v3, v16
		v_cndmask_b32_e64 v98, v8, v180, s[52:53]
		v_cndmask_b32_e64 v99, v8, v181, s[54:55]
		v_cndmask_b32_e64 v178, v8, v182, s[92:93]
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_cndmask_b32_e64 v15, v8, v101, s[56:57]
		v_cndmask_b32_e64 v228, v8, v102, s[58:59]
		v_cndmask_b32_e64 v100, v8, v104, s[60:61]
		v_cndmask_b32_e32 v179, v8, v183, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v225
		v_cmp_ge_i32_e64 s[54:55], v3, v226
		v_cmp_ge_i32_e64 s[56:57], v3, v19
		v_cndmask_b32_e64 v18, v8, v184, s[52:53]
		v_cndmask_b32_e64 v19, v8, v185, s[54:55]
		v_cndmask_b32_e64 v180, v8, v186, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v21
		v_cndmask_b32_e64 v101, v8, v105, s[62:63]
		v_max3_f32 v16, v250, v251, v24
		v_cndmask_b32_e32 v181, v8, v187, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v103
		v_cmp_ge_i32_e64 s[54:55], v3, v227
		v_cmp_ge_i32_e64 s[56:57], v3, v22
		v_cndmask_b32_e64 v102, v8, v188, s[52:53]
		v_cndmask_b32_e64 v103, v8, v189, s[54:55]
		v_cndmask_b32_e64 v104, v8, v190, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v23
		v_cndmask_b32_e64 v230, v8, v106, s[64:65]
		v_cndmask_b32_e64 v22, v8, v108, s[66:67]
		v_cndmask_b32_e32 v105, v8, v191, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v107
		v_cmp_ge_i32_e64 s[54:55], v3, v232
		v_cmp_ge_i32_e64 s[56:57], v3, v26
		v_cndmask_b32_e64 v106, v8, v192, s[52:53]
		v_cndmask_b32_e64 v107, v8, v193, s[54:55]
		v_cndmask_b32_e64 v182, v8, v194, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v27
		v_cndmask_b32_e64 v23, v8, v109, s[68:69]
		v_cndmask_b32_e64 v234, v8, v110, s[70:71]
		v_cndmask_b32_e64 v26, v8, v112, s[72:73]
		v_cndmask_b32_e32 v183, v8, v195, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v111
		v_cmp_ge_i32_e64 s[54:55], v3, v233
		v_cmp_ge_i32_e64 s[56:57], v3, v28
		v_cndmask_b32_e64 v108, v8, v196, s[52:53]
		v_cndmask_b32_e64 v109, v8, v197, s[54:55]
		v_cndmask_b32_e64 v110, v8, v198, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v29
		v_cndmask_b32_e64 v27, v8, v113, s[74:75]
		v_max3_f32 v21, v14, v15, v228
		v_cndmask_b32_e32 v111, v8, v199, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v115
		v_cmp_ge_i32_e64 s[54:55], v3, v236
		v_cmp_ge_i32_e64 s[56:57], v3, v30
		v_cndmask_b32_e64 v28, v8, v200, s[52:53]
		v_cndmask_b32_e64 v29, v8, v201, s[54:55]
		v_cndmask_b32_e64 v112, v8, v202, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v31
		v_cndmask_b32_e64 v236, v8, v114, s[76:77]
		v_cndmask_b32_e64 v30, v8, v116, s[78:79]
		v_cndmask_b32_e32 v113, v8, v203, vcc
		v_accvgpr_read_b32 v31, a65
		v_cmp_ge_i32_e64 vcc, v3, v31
		v_accvgpr_read_b32 v31, a145
		v_cmp_ge_i32_e64 s[52:53], v3, v31
		v_accvgpr_read_b32 v31, a146
		v_cmp_ge_i32_e64 s[54:55], v3, v31
		v_accvgpr_read_b32 v31, a64
		v_cmp_ge_i32_e64 s[56:57], v3, v31
		v_cndmask_b32_e64 v114, v8, v204, s[52:53]
		v_cndmask_b32_e64 v115, v8, v205, s[54:55]
		v_cndmask_b32_e64 v184, v8, v206, s[56:57]
		v_cndmask_b32_e64 v31, v8, v117, s[80:81]
		v_cndmask_b32_e64 v238, v8, v118, s[82:83]
		v_cndmask_b32_e32 v185, v8, v207, vcc
		v_accvgpr_read_b32 v116, a147
		v_cmp_ge_i32_e64 s[52:53], v3, v116
		v_accvgpr_read_b32 v116, a148
		v_cmp_ge_i32_e64 s[54:55], v3, v116
		v_accvgpr_read_b32 v116, a68
		v_cmp_ge_i32_e64 vcc, v3, v116
		v_accvgpr_read_b32 v116, a67
		v_cmp_ge_i32_e64 s[56:57], v3, v116
		v_cndmask_b32_e64 v116, v8, v208, s[52:53]
		v_cndmask_b32_e64 v117, v8, v209, s[54:55]
		v_cndmask_b32_e64 v186, v8, v210, s[56:57]
		v_cndmask_b32_e64 v188, v8, v120, s[84:85]
		v_cndmask_b32_e64 v189, v8, v121, s[86:87]
		v_cndmask_b32_e32 v187, v8, v211, vcc
		v_accvgpr_read_b32 v118, a149
		v_cmp_ge_i32_e64 s[52:53], v3, v118
		v_accvgpr_read_b32 v118, a150
		v_cmp_ge_i32_e64 s[54:55], v3, v118
		v_accvgpr_read_b32 v118, a131
		v_cmp_ge_i32_e64 s[56:57], v3, v118
		v_cndmask_b32_e64 v120, v8, v212, s[52:53]
		v_cndmask_b32_e64 v121, v8, v213, s[54:55]
		v_cndmask_b32_e64 v190, v8, v214, s[56:57]
		v_accvgpr_read_b32 v118, a132
		v_cmp_ge_i32_e64 vcc, v3, v118
		v_cndmask_b32_e64 v240, v8, v122, s[88:89]
		v_accvgpr_read_b32 v118, a156
		s_nop 0
		v_readfirstlane_b32 s52, v118
		v_accvgpr_read_b32 v118, a157
		s_nop 0
		v_readfirstlane_b32 s53, v118
		s_nop 1
		v_cndmask_b32_e64 v192, v8, v124, s[52:53]
		v_cndmask_b32_e32 v191, v8, v215, vcc
		v_accvgpr_read_b32 v118, a151
		v_cmp_ge_i32_e64 s[52:53], v3, v118
		v_accvgpr_read_b32 v118, a152
		v_cmp_ge_i32_e64 s[54:55], v3, v118
		v_accvgpr_read_b32 v118, a133
		v_cmp_ge_i32_e64 s[56:57], v3, v118
		v_cndmask_b32_e64 v194, v8, v216, s[52:53]
		v_cndmask_b32_e64 v195, v8, v217, s[54:55]
		v_cndmask_b32_e64 v196, v8, v218, s[56:57]
		v_accvgpr_read_b32 v118, a134
		v_cmp_ge_i32_e64 vcc, v3, v118
		v_accvgpr_read_b32 v118, a158
		s_nop 0
		v_readfirstlane_b32 s52, v118
		v_accvgpr_read_b32 v118, a159
		s_nop 0
		v_readfirstlane_b32 s53, v118
		s_nop 1
		v_cndmask_b32_e64 v193, v8, v125, s[52:53]
		v_accvgpr_read_b32 v118, a160
		s_nop 0
		v_readfirstlane_b32 s52, v118
		v_accvgpr_read_b32 v118, a161
		s_nop 0
		v_readfirstlane_b32 s53, v118
		s_nop 1
		v_cndmask_b32_e64 v242, v8, v126, s[52:53]
		v_cndmask_b32_e32 v197, v8, v219, vcc
		v_accvgpr_read_b32 v118, a153
		v_cmp_ge_i32_e64 s[52:53], v3, v118
		v_accvgpr_read_b32 v118, a154
		v_cmp_ge_i32_e64 s[54:55], v3, v118
		v_accvgpr_read_b32 v118, a135
		v_cmp_ge_i32_e64 s[56:57], v3, v118
		v_cndmask_b32_e64 v124, v8, v220, s[52:53]
		v_cndmask_b32_e64 v125, v8, v221, s[54:55]
		v_cndmask_b32_e64 v198, v8, v222, s[56:57]
		v_accvgpr_read_b32 v118, a136
		v_cmp_ge_i32_e64 vcc, v3, v118
		v_accvgpr_read_b32 v118, a162
		s_nop 0
		v_readfirstlane_b32 s52, v118
		v_accvgpr_read_b32 v118, a163
		s_nop 0
		v_readfirstlane_b32 s53, v118
		s_nop 1
		v_cndmask_b32_e64 v200, v8, v128, s[52:53]
		v_accvgpr_read_b32 v118, a164
		s_nop 0
		v_readfirstlane_b32 s52, v118
		v_accvgpr_read_b32 v118, a165
		s_nop 0
		v_readfirstlane_b32 s53, v118
		s_nop 1
		v_cndmask_b32_e64 v201, v8, v129, s[52:53]
		v_cndmask_b32_e32 v199, v8, v223, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v96
		v_cmp_ge_i32_e64 s[54:55], v3, v119
		v_accvgpr_read_b32 v96, a137
		v_cmp_ge_i32_e64 s[56:57], v3, v96
		v_cndmask_b32_e64 v118, v8, v160, s[52:53]
		v_cndmask_b32_e64 v119, v8, v161, s[54:55]
		v_cndmask_b32_e64 v128, v8, v162, s[56:57]
		v_accvgpr_read_b32 v96, a138
		v_cmp_ge_i32_e64 vcc, v3, v96
		v_accvgpr_read_b32 v96, a166
		s_nop 0
		v_readfirstlane_b32 s52, v96
		v_accvgpr_read_b32 v96, a167
		s_nop 0
		v_readfirstlane_b32 s53, v96
		s_nop 1
		v_cndmask_b32_e64 v244, v8, v130, s[52:53]
		v_accvgpr_read_b32 v96, a168
		s_nop 0
		v_readfirstlane_b32 s52, v96
		v_accvgpr_read_b32 v96, a169
		s_nop 0
		v_readfirstlane_b32 s53, v96
		s_nop 1
		v_cndmask_b32_e64 v160, v8, v132, s[52:53]
		v_cndmask_b32_e32 v129, v8, v163, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v123
		v_cmp_ge_i32_e64 s[54:55], v3, v127
		v_accvgpr_read_b32 v96, a139
		v_cmp_ge_i32_e64 s[56:57], v3, v96
		v_cndmask_b32_e64 v122, v8, v164, s[52:53]
		v_cndmask_b32_e64 v123, v8, v165, s[54:55]
		v_cndmask_b32_e64 v126, v8, v166, s[56:57]
		v_accvgpr_read_b32 v96, a140
		v_cmp_ge_i32_e64 vcc, v3, v96
		v_accvgpr_read_b32 v96, a170
		s_nop 0
		v_readfirstlane_b32 s52, v96
		v_accvgpr_read_b32 v96, a171
		s_nop 0
		v_readfirstlane_b32 s53, v96
		s_nop 1
		v_cndmask_b32_e64 v161, v8, v133, s[52:53]
		v_accvgpr_read_b32 v96, a172
		s_nop 0
		v_readfirstlane_b32 s52, v96
		v_accvgpr_read_b32 v96, a173
		s_nop 0
		v_readfirstlane_b32 s53, v96
		s_nop 1
		v_cndmask_b32_e64 v246, v8, v134, s[52:53]
		v_cndmask_b32_e32 v127, v8, v167, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v131
		v_cmp_ge_i32_e64 s[54:55], v3, v135
		v_accvgpr_read_b32 v96, a141
		v_cmp_ge_i32_e64 s[56:57], v3, v96
		v_cndmask_b32_e64 v130, v8, v168, s[52:53]
		v_cndmask_b32_e64 v131, v8, v169, s[54:55]
		v_cndmask_b32_e64 v132, v8, v170, s[56:57]
		v_accvgpr_read_b32 v96, a142
		v_cmp_ge_i32_e64 vcc, v3, v96
		v_accvgpr_read_b32 v96, a174
		s_nop 0
		v_readfirstlane_b32 s52, v96
		v_accvgpr_read_b32 v96, a175
		s_nop 0
		v_readfirstlane_b32 s53, v96
		s_nop 1
		v_cndmask_b32_e64 v134, v8, v136, s[52:53]
		v_accvgpr_read_b32 v96, a176
		s_nop 0
		v_readfirstlane_b32 s52, v96
		v_accvgpr_read_b32 v96, a177
		s_nop 0
		v_readfirstlane_b32 s53, v96
		s_nop 1
		v_cndmask_b32_e64 v135, v8, v137, s[52:53]
		v_cndmask_b32_e32 v133, v8, v171, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v139
		v_cmp_ge_i32_e64 s[54:55], v3, v141
		v_accvgpr_read_b32 v96, a143
		v_cmp_ge_i32_e64 s[56:57], v3, v96
		v_cndmask_b32_e64 v136, v8, v172, s[52:53]
		v_cndmask_b32_e64 v137, v8, v173, s[54:55]
		v_cndmask_b32_e64 v162, v8, v174, s[56:57]
		v_accvgpr_read_b32 v96, a144
		v_cmp_ge_i32_e64 vcc, v3, v96
		v_accvgpr_read_b32 v96, a178
		s_nop 0
		v_readfirstlane_b32 s52, v96
		v_accvgpr_read_b32 v96, a179
		s_nop 0
		v_readfirstlane_b32 s53, v96
		s_nop 1
		v_cndmask_b32_e64 v248, v8, v138, s[52:53]
		v_cndmask_b32_e64 v254, v8, v140, s[48:49]
		v_cndmask_b32_e32 v163, v8, v175, vcc
		v_max3_f32 v96, v100, v101, v230
		v_max3_f32 v138, v22, v23, v234
		v_max3_f32 v139, v26, v27, v236
		v_max3_f32 v140, v30, v31, v238
		v_max3_f32 v141, v188, v189, v240
		v_max3_f32 v159, v192, v193, v242
		v_max3_f32 v164, v200, v201, v244
		v_max3_f32 v165, v160, v161, v246
		v_max3_f32 v166, v134, v135, v248
		v_max3_f32 v167, v254, v255, v252
		v_max3_f32 v16, v16, v25, v21
		v_max3_f32 v21, v96, v231, v138
		v_max3_f32 v96, v139, v237, v140
		v_max3_f32 v138, v141, v241, v159
		v_max3_f32 v139, v164, v245, v165
		v_max3_f32 v140, v166, v249, v167
		v_max3_f32 v97, v97, v145, v158
		v_accvgpr_read_b32 v141, a155
		v_accvgpr_read_b32 v158, a180
		v_max3_f32 v141, v141, v153, v158
		v_max3_f32 v16, v16, v229, v21
		v_max3_f32 v21, v96, v239, v138
		v_max3_f32 v96, v139, v247, v140
		v_max3_f32 v97, v97, v149, v141
		v_max3_f32 v16, v16, v235, v21
		v_max3_f32 v21, v96, v253, v97
		v_max3_f32 v16, v16, v243, v21
		v_max_f32_e32 v96, v16, v157
		v_mov_b32_e32 v97, v96
		v_cndmask_b32_e64 v138, v8, v176, s[50:51]
		v_cndmask_b32_e64 v139, v8, v177, s[90:91]
		v_permlane32_swap_b32_e32 v96, v97
		v_max3_f32 v16, v138, v139, v12
		v_max3_f32 v21, v98, v99, v178
		v_max3_f32 v140, v18, v19, v180
		v_max3_f32 v141, v102, v103, v104
		v_max3_f32 v158, v106, v107, v182
		v_max3_f32 v159, v108, v109, v110
		v_max3_f32 v164, v28, v29, v112
		v_max3_f32 v165, v114, v115, v184
		v_max3_f32 v166, v116, v117, v186
		v_max3_f32 v167, v120, v121, v190
		v_max3_f32 v168, v194, v195, v196
		v_max3_f32 v169, v124, v125, v198
		v_max3_f32 v170, v118, v119, v128
		v_max3_f32 v171, v122, v123, v126
		v_max3_f32 v172, v130, v131, v132
		v_max3_f32 v173, v136, v137, v162
		v_max3_f32 v16, v16, v13, v21
		v_max3_f32 v21, v140, v181, v141
		v_max3_f32 v140, v158, v183, v159
		v_max3_f32 v141, v164, v113, v165
		v_max3_f32 v158, v166, v187, v167
		v_max3_f32 v159, v168, v197, v169
		v_max3_f32 v164, v170, v129, v171
		v_max3_f32 v165, v172, v133, v173
		v_max3_f32 v16, v16, v179, v21
		v_max3_f32 v21, v140, v111, v141
		v_max3_f32 v140, v158, v191, v159
		v_max3_f32 v141, v164, v127, v165
		v_max3_f32 v16, v16, v105, v21
		v_max3_f32 v21, v140, v199, v141
		v_max3_f32 v16, v16, v185, v21
		v_max_f32_e32 v140, v16, v163
		v_mov_b32_e32 v141, v140
		v_max_f32_e32 v158, v96, v97
		v_mov_b32_e32 v96, v4
		v_permlane32_swap_b32_e32 v140, v141
		v_max_f32_e32 v159, v140, v141
		v_pk_mul_f32 v[140:141], v[158:159], v[6:7]
		v_max_f32_e32 v158, v4, v140
		v_max_f32_e32 v159, v9, v141
		v_pk_fma_f32 v[140:141], v[250:251], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[24:25], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[14:15], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[14:15], v[228:229], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[100:101], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[230:231], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[22:23], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[22:23], v[234:235], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[26:27], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[236:237], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[30:31], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[238:239], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[188:189], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[240:241], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[192:193], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[242:243], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[200:201], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[244:245], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[160:161], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[246:247], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[134:135], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[248:249], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[254:255], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[252:253], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[142:143], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[144:145], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[146:147], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[148:149], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[150:151], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[154:155], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[156:157], v[6:7], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[138:139], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[12:13], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[12:13], v[98:99], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[178:179], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[18:19], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[18:19], v[180:181], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[102:103], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[182:183], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[108:109], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[110:111], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[28:29], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[112:113], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[114:115], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[184:185], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[116:117], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[186:187], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[120:121], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[190:191], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[194:195], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[196:197], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[124:125], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[198:199], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[118:119], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[128:129], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[122:123], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[126:127], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[130:131], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[132:133], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[136:137], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[162:163], v[6:7], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v162, v140
		v_exp_f32_e32 v214, v141
		v_exp_f32_e32 v140, v164
		v_exp_f32_e32 v216, v165
		v_exp_f32_e32 v164, v24
		v_exp_f32_e32 v218, v25
		v_exp_f32_e32 v24, v14
		v_exp_f32_e32 v220, v15
		v_exp_f32_e32 v14, v166
		v_exp_f32_e32 v222, v167
		v_exp_f32_e32 v166, v100
		v_exp_f32_e32 v224, v101
		v_exp_f32_e32 v100, v168
		v_exp_f32_e32 v226, v169
		v_exp_f32_e32 v168, v22
		v_exp_f32_e32 v228, v23
		v_exp_f32_e32 v22, v170
		v_exp_f32_e32 v230, v171
		v_exp_f32_e32 v170, v26
		v_exp_f32_e32 v232, v27
		v_exp_f32_e32 v26, v172
		v_exp_f32_e32 v234, v173
		v_exp_f32_e32 v172, v30
		v_exp_f32_e32 v236, v31
		v_exp_f32_e32 v30, v174
		v_exp_f32_e32 v238, v175
		v_exp_f32_e32 v174, v176
		v_exp_f32_e32 v240, v177
		v_exp_f32_e32 v176, v188
		v_exp_f32_e32 v242, v189
		v_exp_f32_e32 v188, v192
		v_exp_f32_e32 v244, v193
		v_exp_f32_e32 v163, v202
		v_exp_f32_e32 v215, v203
		v_exp_f32_e32 v141, v200
		v_exp_f32_e32 v217, v201
		v_exp_f32_e32 v165, v204
		v_exp_f32_e32 v219, v205
		v_exp_f32_e32 v25, v160
		v_exp_f32_e32 v221, v161
		v_exp_f32_e32 v15, v206
		v_exp_f32_e32 v223, v207
		v_exp_f32_e32 v167, v134
		v_exp_f32_e32 v225, v135
		v_exp_f32_e32 v101, v208
		v_exp_f32_e32 v227, v209
		v_exp_f32_e32 v169, v210
		v_exp_f32_e32 v229, v211
		v_exp_f32_e32 v23, v212
		v_exp_f32_e32 v231, v213
		v_exp_f32_e32 v171, v142
		v_exp_f32_e32 v233, v143
		v_exp_f32_e32 v27, v144
		v_exp_f32_e32 v235, v145
		v_exp_f32_e32 v173, v146
		v_exp_f32_e32 v237, v147
		v_exp_f32_e32 v31, v148
		v_exp_f32_e32 v239, v149
		v_exp_f32_e32 v175, v150
		v_exp_f32_e32 v241, v151
		v_exp_f32_e32 v177, v152
		v_exp_f32_e32 v243, v153
		v_exp_f32_e32 v189, v154
		v_exp_f32_e32 v245, v155
		v_exp_f32_e32 v134, v156
		v_exp_f32_e32 v142, v157
		v_exp_f32_e32 v144, v138
		v_exp_f32_e32 v146, v139
		v_exp_f32_e32 v138, v12
		v_exp_f32_e32 v148, v13
		v_exp_f32_e32 v12, v98
		v_exp_f32_e32 v150, v99
		v_exp_f32_e32 v98, v178
		v_exp_f32_e32 v152, v179
		v_exp_f32_e32 v154, v18
		v_exp_f32_e32 v156, v19
		v_exp_f32_e32 v18, v180
		v_exp_f32_e32 v160, v181
		v_exp_f32_e32 v178, v102
		v_exp_f32_e32 v180, v103
		v_exp_f32_e32 v102, v104
		v_exp_f32_e32 v192, v105
		v_exp_f32_e32 v104, v106
		v_exp_f32_e32 v200, v107
		v_exp_f32_e32 v106, v182
		v_exp_f32_e32 v202, v183
		v_exp_f32_e32 v182, v108
		v_exp_f32_e32 v204, v109
		v_exp_f32_e32 v108, v110
		v_exp_f32_e32 v206, v111
		v_exp_f32_e32 v110, v28
		v_exp_f32_e32 v208, v29
		v_exp_f32_e32 v28, v112
		v_exp_f32_e32 v210, v113
		v_exp_f32_e32 v112, v114
		v_exp_f32_e32 v212, v115
		v_exp_f32_e32 v135, v184
		v_exp_f32_e32 v143, v185
		v_exp_f32_e32 v145, v116
		v_exp_f32_e32 v147, v117
		v_exp_f32_e32 v139, v186
		v_exp_f32_e32 v149, v187
		v_exp_f32_e32 v13, v120
		v_exp_f32_e32 v151, v121
		v_exp_f32_e32 v99, v190
		v_exp_f32_e32 v153, v191
		v_exp_f32_e32 v155, v194
		v_exp_f32_e32 v157, v195
		v_exp_f32_e32 v19, v196
		v_exp_f32_e32 v161, v197
		v_exp_f32_e32 v179, v124
		v_exp_f32_e32 v181, v125
		v_exp_f32_e32 v103, v198
		v_exp_f32_e32 v193, v199
		v_exp_f32_e32 v105, v118
		v_exp_f32_e32 v201, v119
		v_exp_f32_e32 v107, v128
		v_exp_f32_e32 v203, v129
		v_exp_f32_e32 v183, v122
		v_exp_f32_e32 v205, v123
		v_exp_f32_e32 v109, v126
		v_exp_f32_e32 v207, v127
		v_exp_f32_e32 v111, v130
		v_exp_f32_e32 v209, v131
		v_exp_f32_e32 v29, v132
		v_exp_f32_e32 v211, v133
		v_exp_f32_e32 v113, v136
		v_exp_f32_e32 v213, v137
		v_pk_add_f32 v[114:115], v[162:163], v[214:215]
		v_pk_add_f32 v[116:117], v[140:141], v[216:217]
		v_pk_add_f32 v[118:119], v[164:165], v[218:219]
		v_pk_add_f32 v[120:121], v[24:25], v[220:221]
		v_pk_add_f32 v[122:123], v[14:15], v[222:223]
		v_pk_add_f32 v[124:125], v[166:167], v[224:225]
		v_pk_add_f32 v[126:127], v[100:101], v[226:227]
		v_pk_add_f32 v[128:129], v[168:169], v[228:229]
		v_pk_add_f32 v[130:131], v[22:23], v[230:231]
		v_pk_add_f32 v[132:133], v[170:171], v[232:233]
		v_pk_add_f32 v[136:137], v[26:27], v[234:235]
		v_pk_add_f32 v[184:185], v[172:173], v[236:237]
		v_pk_add_f32 v[186:187], v[30:31], v[238:239]
		v_pk_add_f32 v[190:191], v[174:175], v[240:241]
		v_pk_add_f32 v[194:195], v[176:177], v[242:243]
		v_pk_add_f32 v[196:197], v[188:189], v[244:245]
		v_pk_add_f32 v[114:115], v[114:115], v[116:117]
		v_pk_add_f32 v[116:117], v[118:119], v[120:121]
		v_pk_add_f32 v[118:119], v[122:123], v[124:125]
		v_pk_add_f32 v[120:121], v[126:127], v[128:129]
		v_pk_add_f32 v[122:123], v[130:131], v[132:133]
		v_pk_add_f32 v[124:125], v[136:137], v[184:185]
		v_pk_add_f32 v[126:127], v[186:187], v[190:191]
		v_pk_add_f32 v[128:129], v[194:195], v[196:197]
		v_pk_add_f32 v[114:115], v[114:115], v[116:117]
		v_pk_add_f32 v[116:117], v[118:119], v[120:121]
		v_pk_add_f32 v[118:119], v[122:123], v[124:125]
		v_pk_add_f32 v[120:121], v[126:127], v[128:129]
		v_pk_add_f32 v[114:115], v[114:115], v[116:117]
		v_pk_add_f32 v[116:117], v[118:119], v[120:121]
		v_pk_add_f32 v[118:119], v[114:115], v[116:117]
		v_add_f32_e32 v4, v118, v119
		v_accvgpr_read_b32 v16, a69
		ds_bpermute_b32 v114, v16, v4
		v_accvgpr_read_b32 v16, a70
		ds_bpermute_b32 v116, v16, v4
		v_pk_add_f32 v[118:119], v[134:135], v[142:143]
		v_pk_add_f32 v[120:121], v[144:145], v[146:147]
		v_pk_add_f32 v[122:123], v[138:139], v[148:149]
		v_pk_add_f32 v[124:125], v[12:13], v[150:151]
		v_pk_add_f32 v[126:127], v[98:99], v[152:153]
		v_pk_add_f32 v[128:129], v[154:155], v[156:157]
		v_pk_add_f32 v[130:131], v[18:19], v[160:161]
		v_pk_add_f32 v[132:133], v[178:179], v[180:181]
		v_pk_add_f32 v[136:137], v[102:103], v[192:193]
		v_pk_add_f32 v[184:185], v[104:105], v[200:201]
		v_pk_add_f32 v[186:187], v[106:107], v[202:203]
		v_pk_add_f32 v[190:191], v[182:183], v[204:205]
		v_pk_add_f32 v[194:195], v[108:109], v[206:207]
		v_pk_add_f32 v[196:197], v[110:111], v[208:209]
		v_pk_add_f32 v[198:199], v[28:29], v[210:211]
		v_pk_add_f32 v[246:247], v[112:113], v[212:213]
		v_pk_add_f32 v[118:119], v[118:119], v[120:121]
		v_pk_add_f32 v[120:121], v[122:123], v[124:125]
		v_pk_add_f32 v[122:123], v[126:127], v[128:129]
		v_pk_add_f32 v[124:125], v[130:131], v[132:133]
		v_pk_add_f32 v[126:127], v[136:137], v[184:185]
		v_pk_add_f32 v[128:129], v[186:187], v[190:191]
		v_pk_add_f32 v[130:131], v[194:195], v[196:197]
		v_pk_add_f32 v[132:133], v[198:199], v[246:247]
		v_pk_add_f32 v[118:119], v[118:119], v[120:121]
		v_pk_add_f32 v[120:121], v[122:123], v[124:125]
		v_pk_add_f32 v[122:123], v[126:127], v[128:129]
		v_pk_add_f32 v[124:125], v[130:131], v[132:133]
		v_pk_add_f32 v[118:119], v[118:119], v[120:121]
		v_pk_add_f32 v[120:121], v[122:123], v[124:125]
		v_pk_add_f32 v[122:123], v[118:119], v[120:121]
		v_mov_b32_e32 v117, v123
		v_mov_b32_e32 v115, v122
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[118:119], v[114:115], v[116:117]
		v_mov_b32_e32 v114, v119
		v_mov_b32_e32 v115, v119
		v_cvt_pk_bf16_f32 v120, v162, v214
		v_cvt_pk_bf16_f32 v121, v140, v216
		v_permlane32_swap_b32_e32 v114, v115
		v_add_f32_e32 v117, v114, v115
		v_mov_b32_e32 v97, v9
		v_pk_add_f32 v[114:115], v[96:97], v[158:159] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v96, v114
		v_exp_f32_e32 v97, v115
		v_cvt_pk_bf16_f32 v122, v164, v218
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
		v_mov_b32_e32 v116, v118
		v_mov_b64_e32 v[114:115], v[10:11]
		v_pk_fma_f32 v[10:11], v[114:115], v[96:97], v[116:117]
		v_cvt_pk_bf16_f32 v123, v24, v220
		v_cvt_pk_bf16_f32 v116, v14, v222
		v_cvt_pk_bf16_f32 v117, v166, v224
		v_cvt_pk_bf16_f32 v118, v100, v226
		v_cvt_pk_bf16_f32 v119, v168, v228
		v_cvt_pk_bf16_f32 v124, v22, v230
		v_cvt_pk_bf16_f32 v125, v170, v232
		v_cvt_pk_bf16_f32 v126, v26, v234
		v_cvt_pk_bf16_f32 v127, v172, v236
		v_cvt_pk_bf16_f32 v128, v30, v238
		v_cvt_pk_bf16_f32 v129, v174, v240
		v_cvt_pk_bf16_f32 v130, v176, v242
		v_cvt_pk_bf16_f32 v131, v188, v244
		v_cvt_pk_bf16_f32 v184, v163, v215
		v_cvt_pk_bf16_f32 v185, v141, v217
		v_cvt_pk_bf16_f32 v186, v165, v219
		v_cvt_pk_bf16_f32 v187, v25, v221
		v_cvt_pk_bf16_f32 v196, v15, v223
		v_cvt_pk_bf16_f32 v197, v167, v225
		v_cvt_pk_bf16_f32 v198, v101, v227
		v_cvt_pk_bf16_f32 v199, v169, v229
		v_cvt_pk_bf16_f32 v164, v23, v231
		v_cvt_pk_bf16_f32 v165, v171, v233
		v_cvt_pk_bf16_f32 v166, v27, v235
		v_cvt_pk_bf16_f32 v167, v173, v237
		v_cvt_pk_bf16_f32 v24, v31, v239
		v_cvt_pk_bf16_f32 v25, v175, v241
		v_cvt_pk_bf16_f32 v26, v177, v243
		v_cvt_pk_bf16_f32 v27, v189, v245
		v_cvt_pk_bf16_f32 v168, v134, v142
		v_cvt_pk_bf16_f32 v169, v144, v146
		v_cvt_pk_bf16_f32 v170, v138, v148
		v_cvt_pk_bf16_f32 v171, v12, v150
		v_cvt_pk_bf16_f32 v172, v98, v152
		v_cvt_pk_bf16_f32 v173, v154, v156
		v_cvt_pk_bf16_f32 v174, v18, v160
		v_cvt_pk_bf16_f32 v175, v178, v180
		v_cvt_pk_bf16_f32 v188, v102, v192
		v_cvt_pk_bf16_f32 v189, v104, v200
		v_cvt_pk_bf16_f32 v190, v106, v202
		v_cvt_pk_bf16_f32 v191, v182, v204
		v_cvt_pk_bf16_f32 v216, v108, v206
		v_cvt_pk_bf16_f32 v217, v110, v208
		v_cvt_pk_bf16_f32 v218, v28, v210
		v_cvt_pk_bf16_f32 v219, v112, v212
		v_cvt_pk_bf16_f32 v220, v135, v143
		v_cvt_pk_bf16_f32 v221, v145, v147
		v_cvt_pk_bf16_f32 v222, v139, v149
		v_cvt_pk_bf16_f32 v223, v13, v151
		v_cvt_pk_bf16_f32 v12, v99, v153
		v_cvt_pk_bf16_f32 v13, v155, v157
		v_cvt_pk_bf16_f32 v14, v19, v161
		v_cvt_pk_bf16_f32 v15, v179, v181
		v_cvt_pk_bf16_f32 v96, v103, v193
		v_cvt_pk_bf16_f32 v97, v105, v201
		v_cvt_pk_bf16_f32 v98, v107, v203
		v_cvt_pk_bf16_f32 v99, v183, v205
		v_cvt_pk_bf16_f32 v100, v109, v207
		v_cvt_pk_bf16_f32 v101, v111, v209
		v_cvt_pk_bf16_f32 v102, v29, v211
		v_cvt_pk_bf16_f32 v103, v113, v213
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[32:47], a[188:191], v[120:123], v[32:47]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[48:63], a[220:223], v[120:123], v[48:63]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[116:119], v[32:47]
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[116:119], v[48:63]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[124:127], v[32:47]
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[124:127], v[48:63]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[128:131], v[32:47]
		v_permlane32_swap_b32_e32 v168, v170
		v_permlane32_swap_b32_e32 v169, v171
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[128:131], v[48:63]
		v_permlane32_swap_b32_e32 v172, v174
		v_permlane32_swap_b32_e32 v173, v175
		v_mfma_f32_32x32x16_bf16 v[80:95], a[220:223], v[168:171], v[80:95]
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[64:79], a[188:191], v[168:171], v[64:79]
		v_permlane32_swap_b32_e32 v216, v218
		v_permlane32_swap_b32_e32 v217, v219
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[172:175], v[80:95]
		v_permlane32_swap_b32_e32 v220, v222
		v_permlane32_swap_b32_e32 v221, v223
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[172:175], v[64:79]
		v_permlane32_swap_b32_e32 v12, v14
		v_permlane32_swap_b32_e32 v13, v15
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[188:191], v[80:95]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[188:191], v[64:79]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[216:219], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[216:219], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[184:187], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[184:187], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[220:223], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[220:223], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[196:199], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[196:199], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[12:15], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[12:15], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[164:167], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[164:167], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[216:219], v[24:27], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[248:251], v[24:27], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[248:251], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[216:219], v[100:103], v[64:79]
		s_cselect_b32 s1, 1, 0
		s_add_i32 s23, s41, 0x80
		s_cmp_lg_u32 s1, 0
		s_mov_b32 s41, s23
		v_mov_b32_e32 v4, v158
		v_mov_b32_e32 v9, v159
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_4
.L_attn_fwd_persistent.loop_exit_4:
		s_mov_b32 s24, s8
		s_mov_b32 s25, s9
		s_mov_b32 s26, s38
		s_mov_b32 s27, s39
		v_rcp_f32_e32 v2, v10
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
		v_pk_mul_f32 v[12:13], v[38:39], v[2:3]
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
		v_rcp_f32_e32 v2, v11
		v_cvt_pk_bf16_f32 v40, v4, v5
		v_mov_b32_e32 v3, v2
		v_pk_mul_f32 v[4:5], v[64:65], v[2:3]
		v_pk_mul_f32 v[10:11], v[66:67], v[2:3]
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
		v_cvt_pk_bf16_f32 v43, v12, v13
		v_cvt_pk_bf16_f32 v72, v14, v15
		v_cvt_pk_bf16_f32 v73, v16, v17
		v_cvt_pk_bf16_f32 v74, v18, v19
		v_cvt_pk_bf16_f32 v75, v20, v21
		v_cvt_pk_bf16_f32 v12, v22, v23
		v_cvt_pk_bf16_f32 v13, v24, v25
		v_cvt_pk_bf16_f32 v14, v26, v27
		v_cvt_pk_bf16_f32 v15, v28, v29
		v_cvt_pk_bf16_f32 v16, v30, v31
		v_cvt_pk_bf16_f32 v17, v32, v33
		v_cvt_pk_bf16_f32 v18, v34, v35
		v_cvt_pk_bf16_f32 v19, v36, v37
		v_cvt_pk_bf16_f32 v20, v4, v5
		v_cvt_pk_bf16_f32 v21, v10, v11
		v_cvt_pk_bf16_f32 v22, v38, v39
		v_cvt_pk_bf16_f32 v23, v44, v45
		v_cvt_pk_bf16_f32 v4, v46, v47
		v_cvt_pk_bf16_f32 v5, v48, v49
		v_cvt_pk_bf16_f32 v6, v50, v51
		v_cvt_pk_bf16_f32 v7, v52, v53
		v_cvt_pk_bf16_f32 v8, v54, v55
		v_cvt_pk_bf16_f32 v9, v56, v57
		v_cvt_pk_bf16_f32 v10, v58, v59
		v_cvt_pk_bf16_f32 v11, v60, v61
		v_cvt_pk_bf16_f32 v24, v62, v63
		v_cvt_pk_bf16_f32 v25, v64, v65
		v_cvt_pk_bf16_f32 v26, v66, v67
		v_cvt_pk_bf16_f32 v27, v68, v69
		v_permlane32_swap_b32_e32 v40, v42
		v_permlane32_swap_b32_e32 v41, v43
		v_permlane32_swap_b32_e32 v72, v74
		v_permlane32_swap_b32_e32 v73, v75
		v_permlane32_swap_b32_e32 v12, v14
		v_permlane32_swap_b32_e32 v13, v15
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v20, v22
		v_permlane32_swap_b32_e32 v21, v23
		v_permlane32_swap_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v5, v7
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
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
		v_accvgpr_read_b32 v28, a4
		s_nop 0
		v_readfirstlane_b32 s21, v28
		s_nop 1
		v_mul_lo_u32 v3, s21, v3
		v_lshl_add_u32 v2, v3, 1, v2
		v_accvgpr_read_b32 v28, a17
		v_lshl_add_u32 v2, v28, 4, v2
		v_accvgpr_read_b32 v28, a52
		s_nop 0
		v_readfirstlane_b32 s28, v28
		v_accvgpr_read_b32 v28, a53
		s_nop 0
		v_readfirstlane_b32 s29, v28
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
		v_accvgpr_read_b32 v28, a17
		v_lshl_add_u32 v2, v28, 4, v2
		v_accvgpr_read_b32 v28, a52
		s_nop 0
		v_readfirstlane_b32 s28, v28
		v_accvgpr_read_b32 v28, a53
		s_nop 0
		v_readfirstlane_b32 s29, v28
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_25
		buffer_store_dwordx4 v[72:75], v2, s[24:27], 0 offen
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
		v_accvgpr_read_b32 v28, a17
		v_lshl_add_u32 v2, v28, 4, v2
		v_accvgpr_read_b32 v28, a52
		s_nop 0
		v_readfirstlane_b32 s28, v28
		v_accvgpr_read_b32 v28, a53
		s_nop 0
		v_readfirstlane_b32 s29, v28
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_26
		buffer_store_dwordx4 v[12:15], v2, s[24:27], 0 offen
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
		v_accvgpr_read_b32 v12, a17
		v_lshl_add_u32 v2, v12, 4, v2
		v_accvgpr_read_b32 v12, a52
		s_nop 0
		v_readfirstlane_b32 s28, v12
		v_accvgpr_read_b32 v12, a53
		s_nop 0
		v_readfirstlane_b32 s29, v12
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_27
		buffer_store_dwordx4 v[16:19], v2, s[24:27], 0 offen
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
		v_accvgpr_read_b32 v12, a17
		v_lshl_add_u32 v2, v12, 4, v2
		v_accvgpr_read_b32 v12, a54
		s_nop 0
		v_readfirstlane_b32 s28, v12
		v_accvgpr_read_b32 v12, a55
		s_nop 0
		v_readfirstlane_b32 s29, v12
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_28
		buffer_store_dwordx4 v[20:23], v2, s[24:27], 0 offen
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
		v_accvgpr_read_b32 v12, a17
		v_lshl_add_u32 v2, v12, 4, v2
		v_accvgpr_read_b32 v12, a54
		s_nop 0
		v_readfirstlane_b32 s28, v12
		v_accvgpr_read_b32 v12, a55
		s_nop 0
		v_readfirstlane_b32 s29, v12
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
		v_accvgpr_read_b32 v4, a54
		s_nop 0
		v_readfirstlane_b32 s28, v4
		v_accvgpr_read_b32 v4, a55
		s_nop 0
		v_readfirstlane_b32 s29, v4
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_30
		buffer_store_dwordx4 v[8:11], v2, s[24:27], 0 offen
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
		v_accvgpr_read_b32 v2, a54
		s_nop 0
		v_readfirstlane_b32 s22, v2
		v_accvgpr_read_b32 v2, a55
		s_nop 0
		v_readfirstlane_b32 s23, v2
		s_and_saveexec_b64 s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_31
		buffer_store_dwordx4 v[24:27], v1, s[24:27], 0 offen
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
		.amdhsa_next_free_vgpr 508
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
	.set .L_attn_fwd_persistent.num_agpr, 252
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
    .vgpr_count:     508
    .agpr_count:     252
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 403
    wave.regalloc.agpr.dwords: 777
    wave.regalloc.remat.dwords: 3
    wave.regalloc.sgpr_to_vgpr.dwords: 72
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
