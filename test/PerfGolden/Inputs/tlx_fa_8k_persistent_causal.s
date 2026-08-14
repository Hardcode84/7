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
		v_accvgpr_write_b32 a10, v1
		s_add_i32 s1, s21, s25
		s_cmp_lg_u32 s24, 0
		s_cselect_b32 s1, s1, s21
		s_xor_b32 s21, s1, -1
		s_add_i32 s21, s21, 1
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s1, s21, s1
		v_mov_b32_e32 v1, s1
		v_accvgpr_write_b32 a11, v1
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
		v_accvgpr_write_b32 a12, v1
		v_accvgpr_read_b32 v1, a12
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
		v_accvgpr_write_b32 a13, v12
		v_accvgpr_read_b32 v12, a13
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v13, 32
		v_mul_lo_u32 v13, v13, v12
		v_bitop3_b32 v4, v4, v11, v13 bitop3:0x96
		v_lshrrev_b32_e32 v14, 7, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 64
		v_mul_lo_u32 v15, v15, v14
		v_xor_b32_e32 v4, v4, v15
		v_accvgpr_write_b32 a14, v4
		v_xor_b32_e32 v1, 0x80, v1
		v_xor_b32_e32 v1, v1, v3
		v_xor_b32_e32 v1, v1, v5
		v_bitop3_b32 v1, v1, v8, v11 bitop3:0x96
		v_bitop3_b32 v1, v1, v13, v15 bitop3:0x96
		v_accvgpr_write_b32 a15, v1
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
		v_cmp_lt_i32_e64 s[36:37], v1, s19
		s_mov_b32 s42, 0x7fffffff
		s_mov_b32 s43, 0x31016000
		s_mov_b32 s40, s2
		s_mov_b32 s41, s3
		v_accvgpr_read_b32 v1, a12
		s_nop 0
		v_readfirstlane_b32 s18, v1
		s_mul_i32 s18, s18, s12
		s_lshl_b32 s18, s18, 9
		v_accvgpr_read_b32 v1, a10
		s_nop 0
		v_readfirstlane_b32 s21, v1
		s_mul_i32 s21, s21, s10
		s_lshl_b32 s21, s21, 1
		s_add_i32 s38, s18, s21
		v_accvgpr_read_b32 v1, a11
		s_nop 0
		v_readfirstlane_b32 s39, v1
		s_mul_i32 s39, s39, s11
		s_lshl_b32 s39, s39, 1
		s_add_i32 s38, s38, s39
		v_mul_lo_u32 v1, s12, v6
		v_lshl_add_u32 v8, v1, 1, s38
		v_and_b32_e32 v11, 7, v0
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_0
		buffer_load_ushort v13, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_0:
		s_andn2_b64 exec, s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_0
		v_mov_b32_e32 v13, 0
.L_attn_fwd_persistent.exec_endif_0:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s38, s18, 2
		s_add_i32 s38, s38, s21
		s_add_i32 s38, s38, s39
		v_lshl_add_u32 v8, v1, 1, s38
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_1
		buffer_load_ushort v15, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_1:
		s_andn2_b64 exec, s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_1
		v_mov_b32_e32 v15, 0
.L_attn_fwd_persistent.exec_endif_1:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s38, s18, 4
		s_add_i32 s38, s38, s21
		s_add_i32 s38, s38, s39
		v_lshl_add_u32 v8, v1, 1, s38
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_2
		buffer_load_ushort v16, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_2:
		s_andn2_b64 exec, s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_2
		v_mov_b32_e32 v16, 0
.L_attn_fwd_persistent.exec_endif_2:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s38, s18, 6
		s_add_i32 s38, s38, s21
		s_add_i32 s38, s38, s39
		v_lshl_add_u32 v8, v1, 1, s38
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_3
		buffer_load_ushort v17, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_3:
		s_andn2_b64 exec, s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_3
		v_mov_b32_e32 v17, 0
.L_attn_fwd_persistent.exec_endif_3:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s38, s18, 8
		s_add_i32 s38, s38, s21
		s_add_i32 s38, s38, s39
		v_lshl_add_u32 v8, v1, 1, s38
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_4
		buffer_load_ushort v18, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_4:
		s_andn2_b64 exec, s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_4
		v_mov_b32_e32 v18, 0
.L_attn_fwd_persistent.exec_endif_4:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s38, s18, 10
		s_add_i32 s38, s38, s21
		s_add_i32 s38, s38, s39
		v_lshl_add_u32 v8, v1, 1, s38
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_5
		buffer_load_ushort v19, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_5:
		s_andn2_b64 exec, s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_5
		v_mov_b32_e32 v19, 0
.L_attn_fwd_persistent.exec_endif_5:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s38, s18, 12
		s_add_i32 s38, s38, s21
		s_add_i32 s38, s38, s39
		v_lshl_add_u32 v8, v1, 1, s38
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_6
		buffer_load_ushort v20, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_6:
		s_andn2_b64 exec, s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_6
		v_mov_b32_e32 v20, 0
.L_attn_fwd_persistent.exec_endif_6:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s38, s18, 14
		s_add_i32 s38, s38, s21
		s_add_i32 s38, s38, s39
		v_lshl_add_u32 v8, v1, 1, s38
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_7
		buffer_load_ushort v21, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_7:
		s_andn2_b64 exec, s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_7
		v_mov_b32_e32 v21, 0
.L_attn_fwd_persistent.exec_endif_7:
		s_mov_b64 exec, s[96:97]
		s_lshl_b32 s22, s12, 6
		s_add_i32 s23, s22, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_8
		buffer_load_ushort v22, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_8:
		s_andn2_b64 exec, s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_8
		v_mov_b32_e32 v22, 0
.L_attn_fwd_persistent.exec_endif_8:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 2
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_9
		buffer_load_ushort v23, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_9:
		s_andn2_b64 exec, s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_9
		v_mov_b32_e32 v23, 0
.L_attn_fwd_persistent.exec_endif_9:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 4
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_10
		buffer_load_ushort v24, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_10:
		s_andn2_b64 exec, s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_10
		v_mov_b32_e32 v24, 0
.L_attn_fwd_persistent.exec_endif_10:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 6
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_11
		buffer_load_ushort v25, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_11:
		s_andn2_b64 exec, s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_11
		v_mov_b32_e32 v25, 0
.L_attn_fwd_persistent.exec_endif_11:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 8
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_12
		buffer_load_ushort v26, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_12:
		s_andn2_b64 exec, s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_12
		v_mov_b32_e32 v26, 0
.L_attn_fwd_persistent.exec_endif_12:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 10
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_13
		buffer_load_ushort v27, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_13:
		s_andn2_b64 exec, s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_13
		v_mov_b32_e32 v27, 0
.L_attn_fwd_persistent.exec_endif_13:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 12
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_14
		buffer_load_ushort v28, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_14:
		s_andn2_b64 exec, s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_14
		v_mov_b32_e32 v28, 0
.L_attn_fwd_persistent.exec_endif_14:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s22, s22, 14
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s39
		v_lshl_add_u32 v8, v1, 1, s22
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_15
		buffer_load_ushort v29, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_15:
		s_andn2_b64 exec, s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_15
		v_mov_b32_e32 v29, 0
.L_attn_fwd_persistent.exec_endif_15:
		s_mov_b64 exec, s[96:97]
		s_lshl_b32 s22, s12, 7
		s_add_i32 s23, s22, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_16
		buffer_load_ushort v30, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_16:
		s_andn2_b64 exec, s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_16
		v_mov_b32_e32 v30, 0
.L_attn_fwd_persistent.exec_endif_16:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 2
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_17
		buffer_load_ushort v31, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_17:
		s_andn2_b64 exec, s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_17
		v_mov_b32_e32 v31, 0
.L_attn_fwd_persistent.exec_endif_17:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 4
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_18
		buffer_load_ushort v32, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_18:
		s_andn2_b64 exec, s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_18
		v_mov_b32_e32 v32, 0
.L_attn_fwd_persistent.exec_endif_18:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 6
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_19
		buffer_load_ushort v33, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_19:
		s_andn2_b64 exec, s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_19
		v_mov_b32_e32 v33, 0
.L_attn_fwd_persistent.exec_endif_19:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 8
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_20
		buffer_load_ushort v34, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_20:
		s_andn2_b64 exec, s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_20
		v_mov_b32_e32 v34, 0
.L_attn_fwd_persistent.exec_endif_20:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 10
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_21
		buffer_load_ushort v35, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_21:
		s_andn2_b64 exec, s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_21
		v_mov_b32_e32 v35, 0
.L_attn_fwd_persistent.exec_endif_21:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 12
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_22
		buffer_load_ushort v36, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_22:
		s_andn2_b64 exec, s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_22
		v_mov_b32_e32 v36, 0
.L_attn_fwd_persistent.exec_endif_22:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s22, s22, 14
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s39
		v_lshl_add_u32 v8, v1, 1, s22
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_23
		buffer_load_ushort v37, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_23:
		s_andn2_b64 exec, s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_23
		v_mov_b32_e32 v37, 0
.L_attn_fwd_persistent.exec_endif_23:
		s_mov_b64 exec, s[96:97]
		s_mul_i32 s22, 0xc0, s12
		s_add_i32 s23, s22, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_24
		buffer_load_ushort v38, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_24:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_24
		v_mov_b32_e32 v38, 0
.L_attn_fwd_persistent.exec_endif_24:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 2
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_25
		buffer_load_ushort v39, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_25:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_25
		v_mov_b32_e32 v39, 0
.L_attn_fwd_persistent.exec_endif_25:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 4
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_26
		buffer_load_ushort v40, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_26:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_26
		v_mov_b32_e32 v40, 0
.L_attn_fwd_persistent.exec_endif_26:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 6
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_27
		buffer_load_ushort v41, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_27:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_27
		v_mov_b32_e32 v41, 0
.L_attn_fwd_persistent.exec_endif_27:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 8
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_28
		buffer_load_ushort v42, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_28:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_28
		v_mov_b32_e32 v42, 0
.L_attn_fwd_persistent.exec_endif_28:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 10
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_29
		buffer_load_ushort v43, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_29:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_29
		v_mov_b32_e32 v43, 0
.L_attn_fwd_persistent.exec_endif_29:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 12
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_30
		buffer_load_ushort v44, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_30:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_30
		v_mov_b32_e32 v44, 0
.L_attn_fwd_persistent.exec_endif_30:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s22, s22, 14
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s39
		v_lshl_add_u32 v8, v1, 1, s22
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_31
		buffer_load_ushort v45, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_31:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_31
		v_mov_b32_e32 v45, 0
.L_attn_fwd_persistent.exec_endif_31:
		s_mov_b64 exec, s[96:97]
		s_lshl_b32 s22, s12, 8
		s_add_i32 s23, s22, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_32
		buffer_load_ushort v46, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_32:
		s_andn2_b64 exec, s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_32
		v_mov_b32_e32 v46, 0
.L_attn_fwd_persistent.exec_endif_32:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 2
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_33
		buffer_load_ushort v47, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_33:
		s_andn2_b64 exec, s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_33
		v_mov_b32_e32 v47, 0
.L_attn_fwd_persistent.exec_endif_33:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 4
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_34
		buffer_load_ushort v48, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_34:
		s_andn2_b64 exec, s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_34
		v_mov_b32_e32 v48, 0
.L_attn_fwd_persistent.exec_endif_34:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 6
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_35
		buffer_load_ushort v49, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_35:
		s_andn2_b64 exec, s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_35
		v_mov_b32_e32 v49, 0
.L_attn_fwd_persistent.exec_endif_35:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 8
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_36
		buffer_load_ushort v50, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_36:
		s_andn2_b64 exec, s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_36
		v_mov_b32_e32 v50, 0
.L_attn_fwd_persistent.exec_endif_36:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 10
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_37
		buffer_load_ushort v51, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_37:
		s_andn2_b64 exec, s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_37
		v_mov_b32_e32 v51, 0
.L_attn_fwd_persistent.exec_endif_37:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 12
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_38
		buffer_load_ushort v52, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_38:
		s_andn2_b64 exec, s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_38
		v_mov_b32_e32 v52, 0
.L_attn_fwd_persistent.exec_endif_38:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s22, s22, 14
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s39
		v_lshl_add_u32 v8, v1, 1, s22
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_39
		buffer_load_ushort v53, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_39:
		s_andn2_b64 exec, s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_39
		v_mov_b32_e32 v53, 0
.L_attn_fwd_persistent.exec_endif_39:
		s_mov_b64 exec, s[96:97]
		s_mul_i32 s22, 0x140, s12
		s_add_i32 s23, s22, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_40
		buffer_load_ushort v54, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_40:
		s_andn2_b64 exec, s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_40
		v_mov_b32_e32 v54, 0
.L_attn_fwd_persistent.exec_endif_40:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 2
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_41
		buffer_load_ushort v55, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_41:
		s_andn2_b64 exec, s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_41
		v_mov_b32_e32 v55, 0
.L_attn_fwd_persistent.exec_endif_41:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 4
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_42
		buffer_load_ushort v56, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_42:
		s_andn2_b64 exec, s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_42
		v_mov_b32_e32 v56, 0
.L_attn_fwd_persistent.exec_endif_42:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 6
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_43
		buffer_load_ushort v57, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_43:
		s_andn2_b64 exec, s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_43
		v_mov_b32_e32 v57, 0
.L_attn_fwd_persistent.exec_endif_43:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 8
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_44
		buffer_load_ushort v58, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_44:
		s_andn2_b64 exec, s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_44
		v_mov_b32_e32 v58, 0
.L_attn_fwd_persistent.exec_endif_44:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 10
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_45
		buffer_load_ushort v59, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_45:
		s_andn2_b64 exec, s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_45
		v_mov_b32_e32 v59, 0
.L_attn_fwd_persistent.exec_endif_45:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 12
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_46
		buffer_load_ushort v60, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_46:
		s_andn2_b64 exec, s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_46
		v_mov_b32_e32 v60, 0
.L_attn_fwd_persistent.exec_endif_46:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s22, s22, 14
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s39
		v_lshl_add_u32 v8, v1, 1, s22
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_47
		buffer_load_ushort v61, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_47:
		s_andn2_b64 exec, s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_47
		v_mov_b32_e32 v61, 0
.L_attn_fwd_persistent.exec_endif_47:
		s_mov_b64 exec, s[96:97]
		s_mul_i32 s22, 0x180, s12
		s_add_i32 s23, s22, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_48
		buffer_load_ushort v62, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_48:
		s_andn2_b64 exec, s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_48
		v_mov_b32_e32 v62, 0
.L_attn_fwd_persistent.exec_endif_48:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 2
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_49
		buffer_load_ushort v63, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_49:
		s_andn2_b64 exec, s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_49
		v_mov_b32_e32 v63, 0
.L_attn_fwd_persistent.exec_endif_49:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 4
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_50
		buffer_load_ushort v64, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_50:
		s_andn2_b64 exec, s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_50
		v_mov_b32_e32 v64, 0
.L_attn_fwd_persistent.exec_endif_50:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 6
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_51
		buffer_load_ushort v65, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_51:
		s_andn2_b64 exec, s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_51
		v_mov_b32_e32 v65, 0
.L_attn_fwd_persistent.exec_endif_51:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 8
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_52
		buffer_load_ushort v66, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_52:
		s_andn2_b64 exec, s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_52
		v_mov_b32_e32 v66, 0
.L_attn_fwd_persistent.exec_endif_52:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 10
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_53
		buffer_load_ushort v67, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_53:
		s_andn2_b64 exec, s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_53
		v_mov_b32_e32 v67, 0
.L_attn_fwd_persistent.exec_endif_53:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 12
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_54
		buffer_load_ushort v68, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_54:
		s_andn2_b64 exec, s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_54
		v_mov_b32_e32 v68, 0
.L_attn_fwd_persistent.exec_endif_54:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s22, s22, 14
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s39
		v_lshl_add_u32 v8, v1, 1, s22
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_55
		buffer_load_ushort v69, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_55:
		s_andn2_b64 exec, s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_55
		v_mov_b32_e32 v69, 0
.L_attn_fwd_persistent.exec_endif_55:
		s_mov_b64 exec, s[96:97]
		s_mul_i32 s22, 0x1c0, s12
		s_add_i32 s23, s22, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_56
		buffer_load_ushort v70, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_56:
		s_andn2_b64 exec, s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_56
		v_mov_b32_e32 v70, 0
.L_attn_fwd_persistent.exec_endif_56:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 2
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_57
		buffer_load_ushort v71, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_57:
		s_andn2_b64 exec, s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_57
		v_mov_b32_e32 v71, 0
.L_attn_fwd_persistent.exec_endif_57:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 4
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_58
		buffer_load_ushort v72, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_58:
		s_andn2_b64 exec, s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_58
		v_mov_b32_e32 v72, 0
.L_attn_fwd_persistent.exec_endif_58:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 6
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_59
		buffer_load_ushort v73, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_59:
		s_andn2_b64 exec, s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_59
		v_mov_b32_e32 v73, 0
.L_attn_fwd_persistent.exec_endif_59:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 8
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_60
		buffer_load_ushort v74, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_60:
		s_andn2_b64 exec, s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_60
		v_mov_b32_e32 v74, 0
.L_attn_fwd_persistent.exec_endif_60:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 10
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_61
		buffer_load_ushort v75, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_61:
		s_andn2_b64 exec, s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_61
		v_mov_b32_e32 v75, 0
.L_attn_fwd_persistent.exec_endif_61:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 12
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_62
		buffer_load_ushort v76, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_62:
		s_andn2_b64 exec, s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_62
		v_mov_b32_e32 v76, 0
.L_attn_fwd_persistent.exec_endif_62:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s22, s22, 14
		s_add_i32 s18, s22, s18
		s_add_i32 s18, s18, s21
		s_add_i32 s18, s18, s39
		v_lshl_add_u32 v1, v1, 1, s18
		v_lshl_add_u32 v1, v11, 4, v1
		s_and_saveexec_b64 s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_63
		buffer_load_ushort v8, v1, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_63:
		s_andn2_b64 exec, s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_63
		v_mov_b32_e32 v8, 0
.L_attn_fwd_persistent.exec_endif_63:
		s_mov_b64 exec, s[96:97]
		s_mov_b32 s24, s4
		s_mov_b32 s25, s5
		s_mov_b32 s26, s42
		s_mov_b32 s27, s43
		s_mov_b32 s28, s6
		s_mov_b32 s29, s7
		s_mov_b32 s30, s42
		s_mov_b32 s31, s43
		s_waitcnt vmcnt(0)
		s_barrier
		s_mov_b32 s18, 0x5040100
		v_perm_b32 v80, v15, v13, s18
		v_perm_b32 v81, v17, v16, s18
		v_perm_b32 v82, v19, v18, s18
		v_perm_b32 v83, v21, v20, s18
		v_perm_b32 v16, v23, v22, s18
		v_perm_b32 v17, v25, v24, s18
		v_perm_b32 v18, v27, v26, s18
		v_perm_b32 v19, v29, v28, s18
		v_perm_b32 v20, v31, v30, s18
		v_perm_b32 v21, v33, v32, s18
		v_perm_b32 v22, v35, v34, s18
		v_perm_b32 v23, v37, v36, s18
		v_perm_b32 v24, v39, v38, s18
		v_perm_b32 v25, v41, v40, s18
		v_perm_b32 v26, v43, v42, s18
		v_perm_b32 v27, v45, v44, s18
		v_perm_b32 v28, v47, v46, s18
		v_perm_b32 v29, v49, v48, s18
		v_perm_b32 v30, v51, v50, s18
		v_perm_b32 v31, v53, v52, s18
		v_perm_b32 v32, v55, v54, s18
		v_perm_b32 v33, v57, v56, s18
		v_perm_b32 v34, v59, v58, s18
		v_perm_b32 v35, v61, v60, s18
		v_perm_b32 v36, v63, v62, s18
		v_perm_b32 v37, v65, v64, s18
		v_perm_b32 v38, v67, v66, s18
		v_perm_b32 v39, v69, v68, s18
		v_perm_b32 v40, v71, v70, s18
		v_perm_b32 v41, v73, v72, s18
		v_perm_b32 v42, v75, v74, s18
		v_perm_b32 v43, v8, v76, s18
		v_and_b32_e32 v1, 1, v3
		v_lshlrev_b32_e32 v3, 1, v1
		v_accvgpr_read_b32 v8, a13
		v_and_b32_e32 v8, 1, v8
		v_lshlrev_b32_e32 v8, 2, v8
		v_and_b32_e32 v9, 1, v9
		v_accvgpr_write_b32 a16, v9
		v_accvgpr_read_b32 v9, a16
		v_xor_b32_e32 v8, v8, v9
		v_bitop3_b32 v3, v0, v3, v8 bitop3:0x96
		v_lshlrev_b32_e32 v3, 4, v3
		v_add_u32_e32 v3, 0x10000, v3
		ds_write_b128 v3, v[80:83] offset:2480
		ds_write_b128 v3, v[16:19] offset:6576
		ds_write_b128 v3, v[20:23] offset:10672
		ds_write_b128 v3, v[24:27] offset:14768
		v_mov_b32_e32 v8, 32
		v_mul_lo_u32 v8, v8, v10
		v_mov_b32_e32 v9, 2
		v_mul_lo_u32 v9, v9, v14
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v10, a13
		v_lshlrev_b32_e32 v10, 12, v10
		v_add_u32_e32 v10, 0x10000, v10
		v_and_b32_e32 v13, 63, v0
		v_and_b32_e32 v14, 7, v13
		v_lshrrev_b32_e32 v15, 2, v14
		v_lshl_add_u32 v16, v15, 5, v10
		v_lshrrev_b32_e32 v17, 3, v13
		v_bitop3_b32 v17, v17, 3, 1 bitop3:0x80
		v_lshl_add_u32 v18, v17, 6, v16
		v_lshrrev_b32_e32 v19, 5, v13
		v_and_b32_e32 v13, 31, v13
		v_lshlrev_b32_e32 v20, 3, v13
		v_add_u32_e32 v21, v19, v20
		v_lshrrev_b32_e32 v14, 1, v14
		v_and_b32_e32 v14, 1, v14
		v_xor_b32_e32 v21, v21, v14
		v_lshl_add_u32 v18, v21, 4, v18
		ds_read_b128 a[20:23], v18 offset:2480
		v_lshl_add_u32 v21, v17, 6, v10
		v_add3_u32 v22, 2, v19, v20
		v_lshlrev_b32_e32 v15, 1, v15
		v_bitop3_b32 v22, v22, v15, v14 bitop3:0x96
		v_lshl_add_u32 v21, v22, 4, v21
		ds_read_b128 a[24:27], v21 offset:2480
		v_add3_u32 v22, 4, v19, v20
		v_lshlrev_b32_e32 v17, 2, v17
		v_xor_b32_e32 v14, v17, v14
		v_xor_b32_e32 v17, v22, v14
		v_lshl_add_u32 v16, v17, 4, v16
		ds_read_b128 a[28:31], v16 offset:2480
		v_add3_u32 v17, 6, v19, v20
		v_bitop3_b32 v14, v17, v15, v14 bitop3:0x96
		v_lshl_add_u32 v10, v14, 4, v10
		ds_read_b128 a[32:35], v10 offset:2480
		v_and_b32_e32 v6, 1, v6
		v_lshlrev_b32_e32 v11, 4, v11
		v_and_b32_e32 v2, 1, v2
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v3, v[28:31] offset:2480
		ds_write_b128 v3, v[32:35] offset:6576
		ds_write_b128 v3, v[36:39] offset:10672
		ds_write_b128 v3, v[40:43] offset:14768
		v_accvgpr_read_b32 v3, a12
		s_nop 0
		v_readfirstlane_b32 s18, v3
		s_add_i32 s18, s18, 1
		s_mul_i32 s18, s18, 0x100
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[36:39], v18 offset:2480
		ds_read_b128 a[40:43], v21 offset:2480
		ds_read_b128 a[44:47], v16 offset:2480
		ds_read_b128 a[48:51], v10 offset:2480
		v_accvgpr_read_b32 v3, a6
		s_nop 0
		v_readfirstlane_b32 s21, v3
		s_add_i32 s18, s18, s21
		s_cmp_lt_i32 s20, s18
		s_cselect_b32 s18, s20, s18
		s_add_i32 s21, s18, 0x7f
		s_mov_b32 s22, 0x7f
		s_cmp_lt_i32 s21, 0
		s_cselect_b32 s23, s22, 0
		s_add_i32 s21, s21, s23
		s_ashr_i32 s21, s21, 7
		v_accvgpr_read_b32 v3, a6
		s_nop 0
		v_readfirstlane_b32 s23, v3
		s_add_i32 s23, s1, s23
		s_cmp_lt_i32 s23, 0
		s_cselect_b32 s32, s22, 0
		s_add_i32 s23, s23, s32
		s_ashr_i32 s23, s23, 7
		s_cmp_lt_i32 s23, s21
		s_cselect_b32 s23, s23, s21
		s_cmp_gt_i32 s23, 0
		s_cselect_b32 s23, s23, 0
		v_mov_b32_e32 v3, 64
		v_mul_lo_u32 v3, v3, v7
		v_mov_b32_e32 v10, 16
		v_mul_lo_u32 v10, v10, v4
		v_bitop3_b32 v14, v3, v8, v10 bitop3:0x96
		v_bitop3_b32 v14, v14, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a17, v14
		v_bitop3_b32 v14, 4, v3, v8 bitop3:0x96
		v_xor_b32_e32 v14, v14, v10
		v_bitop3_b32 v15, 8, v3, v8 bitop3:0x96
		v_xor_b32_e32 v15, v15, v10
		v_bitop3_b32 v3, 12, v3, v8 bitop3:0x96
		v_accvgpr_read_b32 v16, a17
		v_cmp_lt_i32_e64 s[32:33], v16, s20
		v_mov_b32_e32 v16, 16
		v_mul_lo_u32 v16, v16, v7
		v_mov_b32_e32 v7, 64
		v_mul_lo_u32 v7, v7, v4
		v_bitop3_b32 v4, v16, v8, v7 bitop3:0x96
		v_bitop3_b32 v4, v4, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a18, v4
		v_bitop3_b32 v4, 4, v16, v8 bitop3:0x96
		v_bitop3_b32 v17, 8, v16, v8 bitop3:0x96
		v_bitop3_b32 v8, 12, v16, v8 bitop3:0x96
		v_accvgpr_read_b32 v16, a18
		v_cmp_lt_i32_e64 vcc, v16, s20
		v_readfirstlane_b32 s34, v0
		v_accvgpr_read_b32 v16, a10
		s_nop 0
		v_readfirstlane_b32 s35, v16
		s_mul_i32 s35, s35, s13
		s_lshl_b32 s35, s35, 1
		v_accvgpr_read_b32 v16, a11
		s_nop 0
		v_readfirstlane_b32 s36, v16
		s_mul_i32 s36, s36, s14
		s_lshl_b32 s36, s36, 1
		s_add_i32 s37, s35, s36
		v_accvgpr_read_b32 v16, a13
		v_mul_lo_u32 v16, s15, v16
		v_lshlrev_b32_e32 v16, 1, v16
		v_add_u32_e32 v18, s37, v16
		v_mul_lo_u32 v20, s15, v1
		v_lshlrev_b32_e32 v20, 5, v20
		v_accvgpr_read_b32 v21, a16
		v_mul_lo_u32 v21, s15, v21
		v_lshlrev_b32_e32 v21, 6, v21
		v_add3_u32 v18, v18, v20, v21
		v_mul_lo_u32 v22, s15, v6
		v_lshlrev_b32_e32 v22, 7, v22
		v_add3_u32 v18, v18, v22, v11
		v_mov_b32_e32 v23, 0x80000000
		v_cndmask_b32_e64 v18, v23, v18, s[32:33]
		s_lshr_b32 s37, s34, 6
		s_mul_i32 s38, 0x410, s37
		s_mov_b32 m0, s38
		v_accvgpr_read_b32 v24, a14
		v_add_u32_e32 v24, s1, v24
		buffer_load_dwordx4 v18, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[40:41], v24, s19
		s_lshl_b32 s39, s15, 3
		s_add_i32 s39, s39, s35
		s_add_i32 s39, s39, s36
		v_add_u32_e32 v18, s39, v16
		v_add3_u32 v18, v18, v20, v21
		v_add3_u32 v18, v18, v22, v11
		v_cndmask_b32_e64 v18, v23, v18, s[32:33]
		s_add_i32 m0, m0, 0x1040
		v_accvgpr_read_b32 v24, a15
		v_add_u32_e32 v24, s1, v24
		buffer_load_dwordx4 v18, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[44:45], v24, s19
		s_lshl_b32 s39, s15, 4
		s_add_i32 s39, s39, s35
		s_add_i32 s39, s39, s36
		v_add_u32_e32 v18, s39, v16
		v_add3_u32 v18, v18, v20, v21
		v_add3_u32 v18, v18, v22, v11
		v_cndmask_b32_e64 v18, v23, v18, s[32:33]
		s_add_i32 m0, m0, 0x1040
		v_lshlrev_b32_e32 v19, 4, v19
		v_accvgpr_write_b32 a19, v19
		buffer_load_dwordx4 v18, s[24:27], 0 offen lds
		v_bitop3_b32 v14, v14, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a52, v14
		s_mul_i32 s39, 24, s15
		s_add_i32 s39, s39, s35
		s_add_i32 s39, s39, s36
		v_add_u32_e32 v14, s39, v16
		v_add3_u32 v14, v14, v20, v21
		v_add3_u32 v14, v14, v22, v11
		v_cndmask_b32_e64 v14, v23, v14, s[32:33]
		s_add_i32 m0, m0, 0x1040
		v_mov_b32_e32 v18, 0x440
		v_mul_lo_u32 v18, v18, v2
		v_accvgpr_write_b32 a53, v18
		buffer_load_dwordx4 v14, s[24:27], 0 offen lds
		v_bitop3_b32 v2, v15, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a54, v2
		v_accvgpr_read_b32 v2, a0
		s_nop 0
		v_readfirstlane_b32 s32, v2
		v_accvgpr_read_b32 v2, a10
		s_nop 0
		v_readfirstlane_b32 s33, v2
		s_mul_i32 s32, s33, s32
		s_lshl_b32 s32, s32, 1
		v_accvgpr_read_b32 v2, a1
		s_nop 0
		v_readfirstlane_b32 s33, v2
		v_accvgpr_read_b32 v2, a11
		s_nop 0
		v_readfirstlane_b32 s39, v2
		s_mul_i32 s33, s39, s33
		s_lshl_b32 s33, s33, 1
		s_add_i32 s39, s32, s33
		v_accvgpr_read_b32 v2, a13
		v_mul_lo_u32 v2, s17, v2
		v_lshlrev_b32_e32 v2, 1, v2
		v_add_u32_e32 v14, s39, v2
		v_mul_lo_u32 v15, s17, v1
		v_lshlrev_b32_e32 v15, 7, v15
		v_accvgpr_read_b32 v18, a16
		v_mul_lo_u32 v18, s17, v18
		v_lshlrev_b32_e32 v18, 6, v18
		v_add3_u32 v14, v14, v15, v18
		v_mul_lo_u32 v19, s17, v6
		v_lshlrev_b32_e32 v19, 5, v19
		v_add3_u32 v14, v14, v19, v11
		v_cndmask_b32_e32 v14, v23, v14, vcc
		s_mul_i32 s37, 0x440, s37
		s_add_i32 m0, s37, 0x81f0
		v_xor_b32_e32 v3, v3, v10
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		v_bitop3_b32 v3, v3, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a55, v3
		s_lshl_b32 s39, s17, 3
		s_add_i32 s39, s39, s32
		s_add_i32 s39, s39, s33
		v_add_u32_e32 v3, s39, v2
		v_add3_u32 v3, v3, v15, v18
		v_add3_u32 v3, v3, v19, v11
		v_cndmask_b32_e32 v3, v23, v3, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v4, v4, v7
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_bitop3_b32 v3, v4, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a56, v3
		s_lshl_b32 s39, s17, 4
		s_add_i32 s39, s39, s32
		s_add_i32 s39, s39, s33
		v_add_u32_e32 v3, s39, v2
		v_add3_u32 v3, v3, v15, v18
		v_add3_u32 v3, v3, v19, v11
		v_cndmask_b32_e32 v3, v23, v3, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v4, v17, v7
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_bitop3_b32 v3, v4, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a57, v3
		s_mul_i32 s39, 24, s17
		s_add_i32 s39, s39, s32
		s_add_i32 s39, s39, s33
		v_add_u32_e32 v3, s39, v2
		v_add3_u32 v3, v3, v15, v18
		v_add3_u32 v3, v3, v19, v11
		v_cndmask_b32_e32 v3, v23, v3, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v4, v8, v7
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_bitop3_b32 v3, v4, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a58, v3
		s_mul_i32 s39, s23, 0x80
		v_mbcnt_lo_u32_b32 v3, -1, 0
		v_mbcnt_hi_u32_b32 v3, -1, v3
		v_and_b32_e32 v3, 31, v3
		v_add_u32_e32 v4, 32, v3
		v_mov_b32_e32 v8, 0x3e38aa3b
		v_mov_b32_e32 v9, 0x3e38aa3b
		s_mov_b32 s23, 0xff800000
		v_mov_b32_e32 v7, s23
		v_mov_b32_e32 v10, s23
		s_mov_b32 s23, 1.0
		v_mov_b32_e32 v24, s23
		v_mov_b32_e32 v25, s23
		s_mov_b32 s23, 0
		v_lshrrev_b32_e32 v12, 4, v13
		v_lshlrev_b32_e32 v12, 9, v12
		v_accvgpr_write_b32 a59, v12
		v_and_b32_e32 v12, 15, v13
		v_mov_b32_e32 v13, 0x410
		v_mul_lo_u32 v13, v13, v12
		v_accvgpr_write_b32 a60, v13
		v_and_b32_e32 v12, 3, v0
		v_accvgpr_write_b32 a61, v12
		v_accvgpr_read_b32 v12, a61
		v_lshlrev_b32_e32 v12, 3, v12
		v_accvgpr_write_b32 a62, v12
		v_mov_b32_e32 v12, 0x2200
		v_mul_lo_u32 v12, v12, v1
		v_accvgpr_write_b32 a63, v12
		v_accvgpr_read_b32 v12, a16
		v_lshlrev_b32_e32 v12, 5, v12
		v_accvgpr_write_b32 a64, v12
		v_mov_b32_e32 v12, 0x880
		v_mul_lo_u32 v12, v12, v6
		v_accvgpr_write_b32 a65, v12
		s_lshl_b32 s46, s15, 8
		s_add_i32 s46, s46, s35
		s_add_i32 s46, s46, s36
		s_mul_i32 s47, 0x108, s15
		s_add_i32 s47, s47, s35
		s_add_i32 s47, s47, s36
		s_mul_i32 s48, 0x110, s15
		s_add_i32 s48, s48, s35
		s_add_i32 s48, s48, s36
		s_mul_i32 s49, 0x118, s15
		s_add_i32 s35, s49, s35
		s_add_i32 s36, s35, s36
		s_lshl_b32 s35, s17, 8
		s_add_i32 s35, s35, s32
		s_add_i32 s49, s35, s33
		s_mul_i32 s35, 0x108, s17
		s_add_i32 s35, s35, s32
		s_add_i32 s50, s35, s33
		s_mul_i32 s35, 0x110, s17
		s_add_i32 s35, s35, s32
		s_add_i32 s51, s35, s33
		s_mul_i32 s35, 0x118, s17
		s_add_i32 s32, s35, s32
		s_add_i32 s32, s32, s33
		v_lshlrev_b32_e32 v3, 2, v3
		v_accvgpr_write_b32 a66, v3
		v_lshlrev_b32_e32 v3, 2, v4
		v_accvgpr_write_b32 a67, v3
		v_add3_u32 v3, v16, v20, v21
		v_add_u32_e32 v3, v3, v22
		v_add3_u32 v4, v2, v15, v18
		v_add_u32_e32 v4, v4, v19
		s_cmp_lt_i32 0, s39
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
		s_mul_i32 s52, 0x4100, s35
		v_accvgpr_read_b32 v6, a19
		v_add_u32_e32 v6, s52, v6
		v_accvgpr_read_b32 v12, a59
		v_accvgpr_read_b32 v13, a60
		v_add3_u32 v6, v6, v12, v13
		ds_read_b128 v[28:31], v6
		ds_read_b128 v[96:99], v6 offset:32
		ds_read_b128 v[100:103], v6 offset:64
		ds_read_b128 a[68:71], v6 offset:96
		ds_read_b128 v[104:107], v6 offset:256
		ds_read_b128 v[108:111], v6 offset:288
		ds_read_b128 v[112:115], v6 offset:320
		ds_read_b128 a[72:75], v6 offset:352
		ds_read_b128 v[116:119], v6 offset:128
		ds_read_b128 v[120:123], v6 offset:160
		ds_read_b128 v[124:127], v6 offset:192
		ds_read_b128 a[76:79], v6 offset:224
		ds_read_b128 a[80:83], v6 offset:384
		ds_read_b128 a[84:87], v6 offset:416
		ds_read_b128 a[88:91], v6 offset:448
		ds_read_b128 a[92:95], v6 offset:480
		s_mul_i32 s35, 0x4400, s35
		v_accvgpr_read_b32 v6, a62
		v_add_u32_e32 v6, s35, v6
		v_accvgpr_read_b32 v12, a64
		v_accvgpr_read_b32 v13, a63
		v_add3_u32 v6, v6, v13, v12
		v_accvgpr_read_b32 v12, a53
		v_accvgpr_read_b32 v13, a65
		v_add3_u32 v6, v6, v13, v12
		ds_read_b64_tr_b16 a[96:97], v6 offset:33264
		ds_read_b64_tr_b16 a[98:99], v6 offset:37616
		ds_read_b64_tr_b16 a[100:101], v6 offset:33392
		ds_read_b64_tr_b16 a[102:103], v6 offset:37744
		ds_read_b64_tr_b16 a[104:105], v6 offset:33520
		ds_read_b64_tr_b16 a[106:107], v6 offset:37872
		ds_read_b64_tr_b16 a[108:109], v6 offset:33648
		ds_read_b64_tr_b16 a[110:111], v6 offset:38000
		ds_read_b64_tr_b16 a[112:113], v6 offset:33776
		ds_read_b64_tr_b16 a[114:115], v6 offset:38128
		ds_read_b64_tr_b16 a[116:117], v6 offset:33904
		ds_read_b64_tr_b16 a[118:119], v6 offset:38256
		ds_read_b64_tr_b16 a[120:121], v6 offset:34032
		ds_read_b64_tr_b16 a[122:123], v6 offset:38384
		ds_read_b64_tr_b16 a[124:125], v6 offset:34160
		ds_read_b64_tr_b16 a[126:127], v6 offset:38512
		ds_read_b64_tr_b16 a[128:129], v6 offset:33328
		ds_read_b64_tr_b16 a[130:131], v6 offset:37680
		ds_read_b64_tr_b16 a[132:133], v6 offset:33456
		ds_read_b64_tr_b16 a[134:135], v6 offset:37808
		ds_read_b64_tr_b16 a[136:137], v6 offset:33584
		ds_read_b64_tr_b16 a[138:139], v6 offset:37936
		ds_read_b64_tr_b16 a[140:141], v6 offset:33712
		ds_read_b64_tr_b16 a[142:143], v6 offset:38064
		ds_read_b64_tr_b16 a[144:145], v6 offset:33840
		ds_read_b64_tr_b16 a[146:147], v6 offset:38192
		ds_read_b64_tr_b16 a[148:149], v6 offset:33968
		ds_read_b64_tr_b16 a[150:151], v6 offset:38320
		ds_read_b64_tr_b16 a[152:153], v6 offset:34096
		ds_read_b64_tr_b16 a[154:155], v6 offset:38448
		ds_read_b64_tr_b16 a[156:157], v6 offset:34224
		ds_read_b64_tr_b16 a[158:159], v6 offset:38576
		s_mul_i32 s35, s15, s23
		s_lshl_b32 s35, s35, 1
		s_add_i32 s52, s46, s35
		v_add_u32_e32 v6, s52, v16
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[128:143], v[28:31], a[20:23], 0
		v_add3_u32 v6, v6, v20, v21
		v_mfma_f32_32x32x16_bf16 v[128:143], v[96:99], a[24:27], v[128:143]
		v_add3_u32 v6, v6, v22, v11
		v_mfma_f32_32x32x16_bf16 v[128:143], v[100:103], a[28:31], v[128:143]
		s_add_i32 s33, s33, 1
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[36:39], 0
		s_and_b32 s33, s33, 1
		v_mfma_f32_32x32x16_bf16 v[144:159], v[96:99], a[40:43], v[144:159]
		s_mul_i32 s52, 0x4100, s33
		v_mfma_f32_32x32x16_bf16 v[144:159], v[100:103], a[44:47], v[144:159]
		s_add_i32 s52, s38, s52
		v_mfma_f32_32x32x16_bf16 v[160:175], v[104:107], a[20:23], 0
		s_mov_b32 m0, s52
		v_mfma_f32_32x32x16_bf16 v[160:175], v[108:111], a[24:27], v[160:175]
		s_add_i32 s52, s47, s35
		v_mfma_f32_32x32x16_bf16 v[160:175], v[112:115], a[28:31], v[160:175]
		v_add3_u32 v12, v11, v3, s52
		v_mfma_f32_32x32x16_bf16 v[176:191], v[104:107], a[36:39], 0
		s_add_i32 s52, s48, s35
		v_mfma_f32_32x32x16_bf16 v[176:191], v[108:111], a[40:43], v[176:191]
		v_add3_u32 v13, v11, v3, s52
		v_mfma_f32_32x32x16_bf16 v[176:191], v[112:115], a[44:47], v[176:191]
		s_add_i32 s35, s36, s35
		v_mfma_f32_32x32x16_bf16 v[96:111], v[116:119], a[20:23], 0
		v_add3_u32 v14, v11, v3, s35
		v_mfma_f32_32x32x16_bf16 v[96:111], v[120:123], a[24:27], v[96:111]
		s_mul_i32 s35, s17, s23
		v_mfma_f32_32x32x16_bf16 v[96:111], v[124:127], a[28:31], v[96:111]
		s_add_i32 s23, s23, 0x80
		v_mfma_f32_32x32x16_bf16 v[192:207], v[116:119], a[36:39], 0
		v_accvgpr_read_b32 v17, a17
		v_add_u32_e32 v17, s23, v17
		v_mfma_f32_32x32x16_bf16 v[192:207], v[120:123], a[40:43], v[192:207]
		v_accvgpr_read_b32 v26, a52
		v_add_u32_e32 v26, s23, v26
		v_mfma_f32_32x32x16_bf16 v[192:207], v[124:127], a[44:47], v[192:207]
		v_accvgpr_read_b32 v27, a54
		v_add_u32_e32 v27, s23, v27
		v_mfma_f32_32x32x16_bf16 v[112:127], a[80:83], a[20:23], 0
		v_accvgpr_read_b32 v28, a55
		v_add_u32_e32 v28, s23, v28
		v_mfma_f32_32x32x16_bf16 v[112:127], a[84:87], a[24:27], v[112:127]
		v_cmp_lt_i32_e64 s[52:53], v17, s20
		v_mfma_f32_32x32x16_bf16 v[112:127], a[88:91], a[28:31], v[112:127]
		v_accvgpr_read_b32 v17, a18
		v_add_u32_e32 v17, s23, v17
		v_mfma_f32_32x32x16_bf16 v[208:223], a[80:83], a[36:39], 0
		v_accvgpr_read_b32 v29, a56
		v_add_u32_e32 v29, s23, v29
		v_accvgpr_read_b32 v30, a57
		v_add_u32_e32 v30, s23, v30
		v_cmp_lt_i32_e64 s[54:55], v17, s20
		v_cndmask_b32_e64 v6, v23, v6, s[52:53]
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[52:53], v26, s20
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[56:57], v27, s20
		v_mfma_f32_32x32x16_bf16 v[208:223], a[84:87], a[40:43], v[208:223]
		v_cndmask_b32_e64 v6, v23, v12, s[52:53]
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[208:223], a[88:91], a[44:47], v[208:223]
		v_cndmask_b32_e64 v6, v23, v13, s[56:57]
		v_cmp_lt_i32_e64 s[52:53], v28, s20
		s_add_i32 m0, m0, 0x1040
		v_accvgpr_read_b32 v12, a58
		v_add_u32_e32 v12, s23, v12
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[128:143], a[68:71], a[32:35], v[128:143]
		v_cndmask_b32_e64 v6, v23, v14, s[52:53]
		v_cmp_lt_i32_e64 s[52:53], v29, s20
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s35, s35, 1
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[56:57], v30, s20
		s_add_i32 s58, s49, s35
		v_mfma_f32_32x32x16_bf16 v[144:159], a[68:71], a[48:51], v[144:159]
		v_add_u32_e32 v6, s58, v2
		v_add3_u32 v6, v6, v15, v18
		v_add3_u32 v6, v6, v19, v11
		v_cndmask_b32_e64 v6, v23, v6, s[54:55]
		v_max3_f32 v13, v128, v129, v130
		s_mul_i32 s33, 0x4400, s33
		v_max3_f32 v14, v132, v133, v134
		s_add_i32 s33, s37, s33
		v_max3_f32 v17, v136, v137, v138
		s_add_i32 m0, s33, 0x81f0
		s_add_i32 s33, s50, s35
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_add3_u32 v6, v11, v4, s33
		v_cndmask_b32_e64 v6, v23, v6, s[52:53]
		v_max3_f32 v26, v140, v141, v142
		s_add_i32 m0, m0, 0x1100
		s_add_i32 s33, s51, s35
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_add3_u32 v6, v11, v4, s33
		v_max3_f32 v13, v13, v131, v14
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v6, v23, v6, s[56:57]
		s_add_i32 s33, s32, s35
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v12, s20
		v_add3_u32 v6, v11, v4, s33
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e32 v6, v23, v6, vcc
		v_max3_f32 v12, v17, v139, v26
		v_max3_f32 v12, v13, v135, v12
		v_max3_f32 v13, v144, v145, v146
		v_max3_f32 v14, v148, v149, v150
		v_max3_f32 v17, v152, v153, v154
		v_max3_f32 v26, v156, v157, v158
		v_max3_f32 v13, v13, v147, v14
		v_max3_f32 v14, v17, v155, v26
		v_max3_f32 v13, v13, v151, v14
		s_cmp_lt_i32 s23, s39
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[160:175], a[72:75], a[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[76:79], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[92:95], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[92:95], a[48:51], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[72:75], a[48:51], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[76:79], a[48:51], v[192:207]
		s_nop 6
		v_max3_f32 v6, v160, v161, v162
		v_max3_f32 v14, v164, v165, v166
		v_max3_f32 v17, v168, v169, v170
		v_max3_f32 v26, v172, v173, v174
		v_max3_f32 v27, v96, v97, v98
		v_max3_f32 v28, v100, v101, v102
		v_max3_f32 v29, v104, v105, v106
		v_max3_f32 v30, v108, v109, v110
		v_max3_f32 v31, v112, v113, v114
		v_max3_f32 v224, v116, v117, v118
		v_max3_f32 v225, v120, v121, v122
		v_max3_f32 v226, v124, v125, v126
		v_max3_f32 v6, v6, v163, v14
		v_max3_f32 v14, v17, v171, v26
		v_max3_f32 v17, v27, v99, v28
		v_max3_f32 v26, v29, v107, v30
		v_max3_f32 v27, v31, v115, v224
		v_max3_f32 v28, v225, v123, v226
		v_max3_f32 v6, v6, v167, v14
		v_max3_f32 v14, v17, v103, v26
		v_max3_f32 v17, v27, v119, v28
		v_max3_f32 v6, v12, v143, v6
		v_max3_f32 v12, v14, v111, v17
		v_max3_f32 v6, v6, v175, v12
		v_max_f32_e32 v26, v6, v127
		v_mov_b32_e32 v27, v26
		v_max3_f32 v6, v176, v177, v178
		v_max3_f32 v12, v180, v181, v182
		v_max3_f32 v14, v184, v185, v186
		v_max3_f32 v17, v188, v189, v190
		v_max3_f32 v28, v192, v193, v194
		v_max3_f32 v29, v196, v197, v198
		v_max3_f32 v30, v200, v201, v202
		v_max3_f32 v31, v204, v205, v206
		v_max3_f32 v224, v208, v209, v210
		v_max3_f32 v225, v212, v213, v214
		v_max3_f32 v226, v216, v217, v218
		v_max3_f32 v227, v220, v221, v222
		v_max3_f32 v6, v6, v179, v12
		v_max3_f32 v12, v14, v187, v17
		v_max3_f32 v14, v28, v195, v29
		v_max3_f32 v17, v30, v203, v31
		v_permlane32_swap_b32_e32 v26, v27
		v_max3_f32 v28, v224, v211, v225
		v_max3_f32 v29, v226, v219, v227
		v_max3_f32 v6, v6, v183, v12
		v_max3_f32 v12, v14, v199, v17
		v_max3_f32 v14, v28, v215, v29
		v_max3_f32 v6, v13, v159, v6
		v_max3_f32 v12, v12, v207, v14
		v_max3_f32 v6, v6, v191, v12
		v_max_f32_e32 v12, v6, v223
		v_mov_b32_e32 v13, v12
		v_max_f32_e32 v28, v26, v27
		v_mov_b32_e32 v26, v7
		v_permlane32_swap_b32_e32 v12, v13
		v_max_f32_e32 v29, v12, v13
		v_pk_mul_f32 v[12:13], v[28:29], v[8:9]
		v_max_f32_e32 v28, v7, v12
		v_max_f32_e32 v29, v10, v13
		v_pk_fma_f32 v[6:7], v[128:129], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[12:13], v[130:131], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[132:133], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[134:135], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[136:137], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[138:139], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[140:141], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[142:143], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[160:161], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[162:163], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[164:165], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[166:167], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[168:169], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[170:171], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[172:173], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[174:175], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[96:97], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
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
		v_pk_fma_f32 v[172:173], v[178:179], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[180:181], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[182:183], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[184:185], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[186:187], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[188:189], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[190:191], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[192:193], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[194:195], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[196:197], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[198:199], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[200:201], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[202:203], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[204:205], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[206:207], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[208:209], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[210:211], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[212:213], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[214:215], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[216:217], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[218:219], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[220:221], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[222:223], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v218, v6
		v_exp_f32_e32 v220, v7
		v_exp_f32_e32 v6, v12
		v_exp_f32_e32 v222, v13
		v_exp_f32_e32 v12, v30
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
		v_exp_f32_e32 v219, v170
		v_exp_f32_e32 v221, v171
		v_exp_f32_e32 v7, v96
		v_exp_f32_e32 v223, v97
		v_exp_f32_e32 v13, v98
		v_exp_f32_e32 v225, v99
		v_exp_f32_e32 v31, v100
		v_exp_f32_e32 v227, v101
		v_exp_f32_e32 v129, v102
		v_exp_f32_e32 v229, v103
		v_exp_f32_e32 v131, v104
		v_exp_f32_e32 v231, v105
		v_exp_f32_e32 v133, v106
		v_exp_f32_e32 v233, v107
		v_exp_f32_e32 v135, v108
		v_exp_f32_e32 v235, v109
		v_exp_f32_e32 v137, v110
		v_exp_f32_e32 v237, v111
		v_exp_f32_e32 v139, v112
		v_exp_f32_e32 v239, v113
		v_exp_f32_e32 v141, v114
		v_exp_f32_e32 v241, v115
		v_exp_f32_e32 v143, v116
		v_exp_f32_e32 v243, v117
		v_exp_f32_e32 v161, v118
		v_exp_f32_e32 v245, v119
		v_exp_f32_e32 v163, v120
		v_exp_f32_e32 v247, v121
		v_exp_f32_e32 v165, v122
		v_exp_f32_e32 v249, v123
		v_exp_f32_e32 v167, v124
		v_exp_f32_e32 v251, v125
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
		v_exp_f32_e32 v148, v172
		v_exp_f32_e32 v150, v173
		v_exp_f32_e32 v152, v174
		v_exp_f32_e32 v154, v175
		v_exp_f32_e32 v156, v176
		v_exp_f32_e32 v158, v177
		v_exp_f32_e32 v168, v178
		v_exp_f32_e32 v170, v179
		v_exp_f32_e32 v172, v180
		v_exp_f32_e32 v174, v181
		v_exp_f32_e32 v176, v182
		v_exp_f32_e32 v178, v183
		v_exp_f32_e32 v180, v184
		v_exp_f32_e32 v182, v185
		v_exp_f32_e32 v97, v186
		v_exp_f32_e32 v99, v187
		v_exp_f32_e32 v101, v188
		v_exp_f32_e32 v103, v189
		v_exp_f32_e32 v105, v190
		v_exp_f32_e32 v107, v191
		v_exp_f32_e32 v109, v192
		v_exp_f32_e32 v111, v193
		v_exp_f32_e32 v113, v194
		v_exp_f32_e32 v115, v195
		v_exp_f32_e32 v117, v196
		v_exp_f32_e32 v119, v197
		v_exp_f32_e32 v121, v198
		v_exp_f32_e32 v123, v199
		v_exp_f32_e32 v125, v200
		v_exp_f32_e32 v127, v201
		v_exp_f32_e32 v145, v202
		v_exp_f32_e32 v147, v203
		v_exp_f32_e32 v149, v204
		v_exp_f32_e32 v151, v205
		v_exp_f32_e32 v153, v206
		v_exp_f32_e32 v155, v207
		v_exp_f32_e32 v157, v208
		v_exp_f32_e32 v159, v209
		v_exp_f32_e32 v169, v210
		v_exp_f32_e32 v171, v211
		v_exp_f32_e32 v173, v212
		v_exp_f32_e32 v175, v213
		v_exp_f32_e32 v177, v214
		v_exp_f32_e32 v179, v215
		v_exp_f32_e32 v181, v216
		v_exp_f32_e32 v183, v217
		v_pk_add_f32 v[184:185], v[218:219], v[220:221]
		v_pk_add_f32 v[186:187], v[6:7], v[222:223]
		v_pk_add_f32 v[188:189], v[12:13], v[224:225]
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
		v_pk_add_f32 v[184:185], v[184:185], v[186:187]
		v_pk_add_f32 v[186:187], v[188:189], v[190:191]
		v_pk_add_f32 v[188:189], v[192:193], v[194:195]
		v_pk_add_f32 v[190:191], v[196:197], v[198:199]
		v_pk_add_f32 v[192:193], v[200:201], v[202:203]
		v_pk_add_f32 v[194:195], v[204:205], v[206:207]
		v_pk_add_f32 v[196:197], v[208:209], v[210:211]
		v_pk_add_f32 v[198:199], v[212:213], v[214:215]
		v_pk_add_f32 v[184:185], v[184:185], v[186:187]
		v_pk_add_f32 v[186:187], v[188:189], v[190:191]
		v_pk_add_f32 v[188:189], v[192:193], v[194:195]
		v_pk_add_f32 v[190:191], v[196:197], v[198:199]
		v_pk_add_f32 v[184:185], v[184:185], v[186:187]
		v_pk_add_f32 v[186:187], v[188:189], v[190:191]
		v_pk_add_f32 v[188:189], v[184:185], v[186:187]
		v_add_f32_e32 v14, v188, v189
		v_accvgpr_read_b32 v17, a66
		ds_bpermute_b32 v184, v17, v14
		v_accvgpr_read_b32 v17, a67
		ds_bpermute_b32 v186, v17, v14
		v_pk_add_f32 v[188:189], v[96:97], v[98:99]
		v_pk_add_f32 v[190:191], v[100:101], v[102:103]
		v_pk_add_f32 v[192:193], v[104:105], v[106:107]
		v_pk_add_f32 v[194:195], v[108:109], v[110:111]
		v_pk_add_f32 v[196:197], v[112:113], v[114:115]
		v_pk_add_f32 v[198:199], v[116:117], v[118:119]
		v_pk_add_f32 v[200:201], v[120:121], v[122:123]
		v_pk_add_f32 v[202:203], v[124:125], v[126:127]
		v_pk_add_f32 v[204:205], v[144:145], v[146:147]
		v_pk_add_f32 v[206:207], v[148:149], v[150:151]
		v_pk_add_f32 v[208:209], v[152:153], v[154:155]
		v_pk_add_f32 v[210:211], v[156:157], v[158:159]
		v_pk_add_f32 v[212:213], v[168:169], v[170:171]
		v_pk_add_f32 v[214:215], v[172:173], v[174:175]
		v_pk_add_f32 v[216:217], v[176:177], v[178:179]
		v_pk_add_f32 v[252:253], v[180:181], v[182:183]
		v_pk_add_f32 v[188:189], v[188:189], v[190:191]
		v_pk_add_f32 v[190:191], v[192:193], v[194:195]
		v_pk_add_f32 v[192:193], v[196:197], v[198:199]
		v_pk_add_f32 v[194:195], v[200:201], v[202:203]
		v_pk_add_f32 v[196:197], v[204:205], v[206:207]
		v_pk_add_f32 v[198:199], v[208:209], v[210:211]
		v_pk_add_f32 v[200:201], v[212:213], v[214:215]
		v_pk_add_f32 v[202:203], v[216:217], v[252:253]
		v_pk_add_f32 v[188:189], v[188:189], v[190:191]
		v_pk_add_f32 v[190:191], v[192:193], v[194:195]
		v_pk_add_f32 v[192:193], v[196:197], v[198:199]
		v_pk_add_f32 v[194:195], v[200:201], v[202:203]
		v_pk_add_f32 v[188:189], v[188:189], v[190:191]
		v_pk_add_f32 v[190:191], v[192:193], v[194:195]
		v_pk_add_f32 v[192:193], v[188:189], v[190:191]
		v_mov_b32_e32 v187, v193
		v_mov_b32_e32 v185, v192
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[188:189], v[184:185], v[186:187]
		v_mov_b32_e32 v184, v189
		v_mov_b32_e32 v185, v189
		v_cvt_pk_bf16_f32 v192, v218, v220
		v_cvt_pk_bf16_f32 v193, v6, v222
		v_permlane32_swap_b32_e32 v184, v185
		v_add_f32_e32 v187, v184, v185
		v_mov_b32_e32 v27, v10
		v_pk_add_f32 v[184:185], v[26:27], v[28:29] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v26, v184
		v_exp_f32_e32 v27, v185
		v_cvt_pk_bf16_f32 v194, v12, v224
		v_mov_b32_e32 v186, v188
		v_mov_b64_e32 v[184:185], v[24:25]
		v_pk_fma_f32 v[24:25], v[184:185], v[26:27], v[186:187]
		v_cvt_pk_bf16_f32 v195, v30, v226
		v_cvt_pk_bf16_f32 v184, v128, v228
		v_cvt_pk_bf16_f32 v185, v130, v230
		v_cvt_pk_bf16_f32 v186, v132, v232
		v_cvt_pk_bf16_f32 v187, v134, v234
		v_cvt_pk_bf16_f32 v188, v136, v236
		v_cvt_pk_bf16_f32 v189, v138, v238
		v_cvt_pk_bf16_f32 v190, v140, v240
		v_cvt_pk_bf16_f32 v191, v142, v242
		v_cvt_pk_bf16_f32 v196, v160, v244
		v_cvt_pk_bf16_f32 v197, v162, v246
		v_cvt_pk_bf16_f32 v198, v164, v248
		v_cvt_pk_bf16_f32 v199, v166, v250
		v_cvt_pk_bf16_f32 v200, v219, v221
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
		v_cvt_pk_bf16_f32 v201, v7, v223
		v_cvt_pk_bf16_f32 v202, v13, v225
		v_cvt_pk_bf16_f32 v203, v31, v227
		v_cvt_pk_bf16_f32 v204, v129, v229
		v_cvt_pk_bf16_f32 v205, v131, v231
		v_cvt_pk_bf16_f32 v206, v133, v233
		v_cvt_pk_bf16_f32 v207, v135, v235
		v_cvt_pk_bf16_f32 v128, v137, v237
		v_cvt_pk_bf16_f32 v129, v139, v239
		v_cvt_pk_bf16_f32 v130, v141, v241
		v_cvt_pk_bf16_f32 v131, v143, v243
		v_cvt_pk_bf16_f32 v132, v161, v245
		v_cvt_pk_bf16_f32 v133, v163, v247
		v_cvt_pk_bf16_f32 v134, v165, v249
		v_cvt_pk_bf16_f32 v135, v167, v251
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
		v_cvt_pk_bf16_f32 v164, v168, v170
		v_cvt_pk_bf16_f32 v165, v172, v174
		v_cvt_pk_bf16_f32 v166, v176, v178
		v_cvt_pk_bf16_f32 v167, v180, v182
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
		v_cvt_pk_bf16_f32 v104, v169, v171
		v_cvt_pk_bf16_f32 v105, v173, v175
		v_cvt_pk_bf16_f32 v106, v177, v179
		v_cvt_pk_bf16_f32 v107, v181, v183
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_mfma_f32_32x32x16_bf16 v[32:47], a[96:99], v[192:195], v[32:47]
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[48:63], a[128:131], v[192:195], v[48:63]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[32:47], a[100:103], v[184:187], v[32:47]
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_mfma_f32_32x32x16_bf16 v[48:63], a[132:135], v[184:187], v[48:63]
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_mfma_f32_32x32x16_bf16 v[32:47], a[104:107], v[188:191], v[32:47]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[48:63], a[136:139], v[188:191], v[48:63]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[32:47], a[108:111], v[196:199], v[32:47]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[48:63], a[140:143], v[196:199], v[48:63]
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_mfma_f32_32x32x16_bf16 v[80:95], a[128:131], v[136:139], v[80:95]
		v_permlane32_swap_b32_e32 v160, v162
		v_permlane32_swap_b32_e32 v161, v163
		v_mfma_f32_32x32x16_bf16 v[64:79], a[96:99], v[136:139], v[64:79]
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		v_mfma_f32_32x32x16_bf16 v[80:95], a[132:135], v[140:143], v[80:95]
		v_permlane32_swap_b32_e32 v208, v210
		v_permlane32_swap_b32_e32 v209, v211
		v_mfma_f32_32x32x16_bf16 v[64:79], a[100:103], v[140:143], v[64:79]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[80:95], a[136:139], v[160:163], v[80:95]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[64:79], a[104:107], v[160:163], v[64:79]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[80:95], a[140:143], v[164:167], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[108:111], v[164:167], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[112:115], v[200:203], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[144:147], v[200:203], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[208:211], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[112:115], v[208:211], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[116:119], v[204:207], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[148:151], v[204:207], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[148:151], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[116:119], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[120:123], v[128:131], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[152:155], v[128:131], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[120:123], v[100:103], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[124:127], v[132:135], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[156:159], v[132:135], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], v[104:107], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[124:127], v[104:107], v[64:79]
		v_mov_b32_e32 v7, v28
		v_mov_b32_e32 v10, v29
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_1
.L_attn_fwd_persistent.loop_exit_1:
		s_mul_i32 s21, s21, 0x80
		v_accvgpr_read_b32 v3, a14
		v_accvgpr_read_b32 v4, a6
		s_nop 0
		v_readfirstlane_b32 s23, v4
		s_nop 1
		v_add_u32_e32 v3, s23, v3
		v_add_u32_e32 v3, s1, v3
		v_accvgpr_read_b32 v4, a15
		v_accvgpr_read_b32 v6, a6
		s_nop 0
		v_readfirstlane_b32 s23, v6
		s_nop 1
		v_add_u32_e32 v4, s23, v4
		v_add_u32_e32 v4, s1, v4
		v_xor_b32_e32 v6, 1, v5
		v_accvgpr_write_b32 a14, v6
		v_xor_b32_e32 v6, 2, v5
		v_accvgpr_write_b32 a15, v6
		v_xor_b32_e32 v6, 3, v5
		v_accvgpr_write_b32 a62, v6
		v_xor_b32_e32 v6, 8, v5
		v_accvgpr_write_b32 a64, v6
		v_xor_b32_e32 v6, 9, v5
		v_accvgpr_write_b32 a68, v6
		v_xor_b32_e32 v6, 10, v5
		v_accvgpr_write_b32 a69, v6
		v_xor_b32_e32 v6, 11, v5
		v_accvgpr_write_b32 a70, v6
		v_xor_b32_e32 v6, 16, v5
		v_accvgpr_write_b32 a71, v6
		v_xor_b32_e32 v6, 17, v5
		v_accvgpr_write_b32 a72, v6
		v_xor_b32_e32 v6, 18, v5
		v_accvgpr_write_b32 a73, v6
		v_xor_b32_e32 v6, 19, v5
		v_accvgpr_write_b32 a74, v6
		v_xor_b32_e32 v6, 24, v5
		v_accvgpr_write_b32 a75, v6
		v_xor_b32_e32 v6, 25, v5
		v_accvgpr_write_b32 a76, v6
		v_xor_b32_e32 v6, 26, v5
		v_accvgpr_write_b32 a77, v6
		v_xor_b32_e32 v6, 27, v5
		v_accvgpr_write_b32 a78, v6
		v_xor_b32_e32 v6, 32, v5
		v_accvgpr_write_b32 a79, v6
		v_xor_b32_e32 v6, 33, v5
		v_accvgpr_write_b32 a80, v6
		v_xor_b32_e32 v6, 34, v5
		v_accvgpr_write_b32 a81, v6
		v_xor_b32_e32 v6, 35, v5
		v_accvgpr_write_b32 a82, v6
		v_xor_b32_e32 v6, 40, v5
		v_accvgpr_write_b32 a83, v6
		v_xor_b32_e32 v6, 41, v5
		v_accvgpr_write_b32 a84, v6
		v_xor_b32_e32 v6, 42, v5
		v_accvgpr_write_b32 a85, v6
		v_xor_b32_e32 v6, 43, v5
		v_accvgpr_write_b32 a86, v6
		v_xor_b32_e32 v6, 48, v5
		v_accvgpr_write_b32 a87, v6
		v_xor_b32_e32 v6, 49, v5
		v_accvgpr_write_b32 a88, v6
		v_xor_b32_e32 v6, 50, v5
		v_accvgpr_write_b32 a89, v6
		v_xor_b32_e32 v6, 51, v5
		v_accvgpr_write_b32 a90, v6
		v_xor_b32_e32 v6, 56, v5
		v_accvgpr_write_b32 a91, v6
		v_xor_b32_e32 v6, 57, v5
		v_accvgpr_write_b32 a92, v6
		v_xor_b32_e32 v6, 58, v5
		v_accvgpr_write_b32 a93, v6
		v_xor_b32_e32 v6, 59, v5
		v_accvgpr_write_b32 a94, v6
		v_xor_b32_e32 v6, 64, v5
		v_accvgpr_write_b32 a95, v6
		v_xor_b32_e32 v6, 0x41, v5
		v_accvgpr_write_b32 a96, v6
		v_xor_b32_e32 v6, 0x42, v5
		v_accvgpr_write_b32 a97, v6
		v_xor_b32_e32 v6, 0x43, v5
		v_accvgpr_write_b32 a98, v6
		v_xor_b32_e32 v6, 0x48, v5
		v_accvgpr_write_b32 a99, v6
		v_xor_b32_e32 v6, 0x49, v5
		v_accvgpr_write_b32 a100, v6
		v_xor_b32_e32 v6, 0x4a, v5
		v_accvgpr_write_b32 a101, v6
		v_xor_b32_e32 v6, 0x4b, v5
		v_accvgpr_write_b32 a102, v6
		v_xor_b32_e32 v6, 0x50, v5
		v_accvgpr_write_b32 a103, v6
		v_xor_b32_e32 v6, 0x51, v5
		v_accvgpr_write_b32 a104, v6
		v_xor_b32_e32 v6, 0x52, v5
		v_accvgpr_write_b32 a105, v6
		v_xor_b32_e32 v6, 0x53, v5
		v_accvgpr_write_b32 a106, v6
		v_xor_b32_e32 v6, 0x58, v5
		v_accvgpr_write_b32 a107, v6
		v_xor_b32_e32 v6, 0x59, v5
		v_accvgpr_write_b32 a108, v6
		v_xor_b32_e32 v6, 0x5a, v5
		v_accvgpr_write_b32 a109, v6
		v_xor_b32_e32 v6, 0x5b, v5
		v_accvgpr_write_b32 a110, v6
		v_xor_b32_e32 v6, 0x60, v5
		v_accvgpr_write_b32 a111, v6
		v_xor_b32_e32 v6, 0x61, v5
		v_accvgpr_write_b32 a112, v6
		v_xor_b32_e32 v6, 0x62, v5
		v_accvgpr_write_b32 a113, v6
		v_xor_b32_e32 v6, 0x63, v5
		v_accvgpr_write_b32 a114, v6
		v_xor_b32_e32 v6, 0x68, v5
		v_accvgpr_write_b32 a115, v6
		v_xor_b32_e32 v6, 0x69, v5
		v_accvgpr_write_b32 a116, v6
		v_xor_b32_e32 v6, 0x6a, v5
		v_accvgpr_write_b32 a117, v6
		v_xor_b32_e32 v6, 0x6b, v5
		v_accvgpr_write_b32 a118, v6
		v_xor_b32_e32 v6, 0x70, v5
		v_accvgpr_write_b32 a119, v6
		v_xor_b32_e32 v6, 0x71, v5
		v_accvgpr_write_b32 a120, v6
		v_xor_b32_e32 v6, 0x72, v5
		v_accvgpr_write_b32 a121, v6
		v_xor_b32_e32 v6, 0x73, v5
		v_accvgpr_write_b32 a122, v6
		v_xor_b32_e32 v6, 0x78, v5
		v_accvgpr_write_b32 a123, v6
		v_xor_b32_e32 v6, 0x79, v5
		v_accvgpr_write_b32 a124, v6
		v_xor_b32_e32 v6, 0x7a, v5
		v_accvgpr_write_b32 a125, v6
		v_xor_b32_e32 v6, 0x7b, v5
		v_accvgpr_write_b32 a126, v6
		v_accvgpr_read_b32 v6, a19
		v_accvgpr_read_b32 v12, a59
		v_accvgpr_read_b32 v13, a60
		v_add3_u32 v6, v6, v12, v13
		v_accvgpr_write_b32 a19, v6
		v_accvgpr_read_b32 v6, a61
		v_accvgpr_read_b32 v12, a63
		v_lshl_add_u32 v6, v6, 3, v12
		v_accvgpr_read_b32 v12, a16
		v_lshl_add_u32 v6, v12, 5, v6
		v_accvgpr_read_b32 v12, a53
		v_accvgpr_read_b32 v13, a65
		v_add3_u32 v6, v6, v13, v12
		v_accvgpr_write_b32 a16, v6
		v_mov_b32_e32 v6, 0xff800000
		s_cmp_lt_i32 s39, s21
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_2
.L_attn_fwd_persistent.loop_head_2:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s1, s39, 0x80
		s_cmp_lt_i32 s39, 0
		s_cselect_b32 s23, s22, 0
		s_add_i32 s23, s39, s23
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
		s_add_i32 s52, s23, s35
		s_mul_i32 s23, 0x4100, s33
		v_accvgpr_read_b32 v12, a19
		v_add_u32_e32 v12, s23, v12
		ds_read_b128 v[28:31], v12
		ds_read_b128 a[128:131], v12 offset:32
		ds_read_b128 a[132:135], v12 offset:64
		ds_read_b128 a[136:139], v12 offset:96
		ds_read_b128 a[140:143], v12 offset:256
		ds_read_b128 a[144:147], v12 offset:288
		ds_read_b128 a[148:151], v12 offset:320
		ds_read_b128 a[152:155], v12 offset:352
		ds_read_b128 a[156:159], v12 offset:128
		ds_read_b128 a[160:163], v12 offset:160
		ds_read_b128 a[164:167], v12 offset:192
		ds_read_b128 a[168:171], v12 offset:224
		ds_read_b128 v[96:99], v12 offset:384
		ds_read_b128 a[172:175], v12 offset:416
		ds_read_b128 a[176:179], v12 offset:448
		ds_read_b128 a[180:183], v12 offset:480
		s_mul_i32 s23, 0x4400, s33
		v_accvgpr_read_b32 v12, a16
		v_add_u32_e32 v12, s23, v12
		ds_read_b64_tr_b16 a[184:185], v12 offset:33264
		ds_read_b64_tr_b16 a[186:187], v12 offset:37616
		ds_read_b64_tr_b16 a[188:189], v12 offset:33392
		ds_read_b64_tr_b16 a[190:191], v12 offset:37744
		ds_read_b64_tr_b16 a[192:193], v12 offset:33520
		ds_read_b64_tr_b16 a[194:195], v12 offset:37872
		ds_read_b64_tr_b16 a[196:197], v12 offset:33648
		ds_read_b64_tr_b16 a[198:199], v12 offset:38000
		ds_read_b64_tr_b16 a[200:201], v12 offset:33776
		ds_read_b64_tr_b16 a[202:203], v12 offset:38128
		ds_read_b64_tr_b16 a[204:205], v12 offset:33904
		ds_read_b64_tr_b16 a[206:207], v12 offset:38256
		ds_read_b64_tr_b16 a[208:209], v12 offset:34032
		ds_read_b64_tr_b16 a[210:211], v12 offset:38384
		ds_read_b64_tr_b16 a[212:213], v12 offset:34160
		ds_read_b64_tr_b16 a[214:215], v12 offset:38512
		ds_read_b64_tr_b16 a[216:217], v12 offset:33328
		ds_read_b64_tr_b16 a[218:219], v12 offset:37680
		ds_read_b64_tr_b16 a[220:221], v12 offset:33456
		ds_read_b64_tr_b16 a[222:223], v12 offset:37808
		ds_read_b64_tr_b16 a[224:225], v12 offset:33584
		ds_read_b64_tr_b16 a[226:227], v12 offset:37936
		ds_read_b64_tr_b16 a[228:229], v12 offset:33712
		ds_read_b64_tr_b16 a[230:231], v12 offset:38064
		ds_read_b64_tr_b16 a[232:233], v12 offset:33840
		ds_read_b64_tr_b16 a[234:235], v12 offset:38192
		ds_read_b64_tr_b16 a[236:237], v12 offset:33968
		ds_read_b64_tr_b16 a[238:239], v12 offset:38320
		ds_read_b64_tr_b16 a[240:241], v12 offset:34096
		ds_read_b64_tr_b16 a[242:243], v12 offset:38448
		ds_read_b64_tr_b16 a[244:245], v12 offset:34224
		ds_read_b64_tr_b16 a[246:247], v12 offset:38576
		s_cmp_lt_i32 s1, s18
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_2
		v_accvgpr_read_b32 v12, a17
		v_add_u32_e32 v12, s1, v12
		v_cmp_lt_i32_e64 s[54:55], v12, s20
		v_accvgpr_read_b32 v12, a18
		v_add_u32_e32 v12, s1, v12
		v_cmp_lt_i32_e64 s[56:57], v12, s20
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s23, s15, s39
		s_lshl_b32 s23, s23, 1
		s_add_i32 s33, s46, s23
		v_add_u32_e32 v12, s33, v16
		v_add3_u32 v12, v12, v20, v21
		v_add3_u32 v12, v12, v22, v11
		v_cndmask_b32_e64 v12, v23, v12, s[54:55]
		s_mov_b32 s54, 1
		s_mov_b32 s55, 0
		s_mov_b32 s35, 0
		s_mul_i32 s58, s54, s34
		s_mul_hi_u32 s59, s54, s34
		s_mul_i32 s33, s54, s35
		s_add_i32 s59, s59, s33
		s_mul_i32 s33, s55, s34
		s_add_i32 s59, s59, s33
		s_lshr_b64 s[54:55], s[58:59], 6
		s_mov_b32 s58, 0x410
		s_mov_b32 s59, 0
		s_mul_i32 s60, s58, s54
		s_mul_hi_u32 s61, s58, s54
		s_mul_i32 s33, s58, s55
		s_add_i32 s61, s61, s33
		s_mul_i32 s33, s59, s54
		s_add_i32 s61, s61, s33
		s_cmp_lt_i32 s52, 0
		s_cselect_b32 s53, -1, 0
		s_mov_b32 s58, 0x4100
		s_mov_b32 s59, 0
		s_mul_i32 s62, s58, s52
		s_mul_hi_u32 s63, s58, s52
		s_mul_i32 s33, s58, s53
		s_add_i32 s63, s63, s33
		s_mul_i32 s33, s59, s52
		s_add_i32 s63, s63, s33
		s_add_u32 s58, s60, s62
		s_addc_u32 s59, s61, s63
		s_add_u32 s64, s58, 0
		s_addc_u32 s65, s59, 0
		s_mov_b32 m0, s64
		v_accvgpr_read_b32 v13, a52
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[58:59], v13, s20
		s_add_i32 s33, s47, s23
		v_add_u32_e32 v12, s33, v16
		v_add3_u32 v12, v12, v20, v21
		v_add3_u32 v12, v12, v22, v11
		v_cndmask_b32_e64 v12, v23, v12, s[58:59]
		s_add_u32 s58, s60, 0x1040
		s_addc_u32 s59, s61, 0
		s_add_u32 s58, s58, s62
		s_addc_u32 s59, s59, s63
		s_add_u32 s64, s58, 0
		s_addc_u32 s65, s59, 0
		s_mov_b32 m0, s64
		v_accvgpr_read_b32 v13, a54
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[58:59], v13, s20
		s_add_i32 s33, s48, s23
		v_add_u32_e32 v12, s33, v16
		v_add3_u32 v12, v12, v20, v21
		v_add3_u32 v12, v12, v22, v11
		v_cndmask_b32_e64 v12, v23, v12, s[58:59]
		s_add_u32 s58, s60, 0x2080
		s_addc_u32 s59, s61, 0
		s_add_u32 s58, s58, s62
		s_addc_u32 s59, s59, s63
		s_add_u32 s64, s58, 0
		s_addc_u32 s65, s59, 0
		s_mov_b32 m0, s64
		v_accvgpr_read_b32 v13, a55
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[58:59], v13, s20
		s_add_i32 s23, s36, s23
		v_add_u32_e32 v12, s23, v16
		v_add3_u32 v12, v12, v20, v21
		v_add3_u32 v12, v12, v22, v11
		v_cndmask_b32_e64 v12, v23, v12, s[58:59]
		s_add_u32 s58, s60, 0x30c0
		s_addc_u32 s59, s61, 0
		s_add_u32 s58, s58, s62
		s_addc_u32 s59, s59, s63
		s_add_u32 s60, s58, 0
		s_addc_u32 s61, s59, 0
		s_mov_b32 m0, s60
		v_accvgpr_read_b32 v13, a56
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		s_mul_i32 s23, s17, s39
		s_lshl_b32 s23, s23, 1
		s_add_i32 s33, s49, s23
		v_add_u32_e32 v12, s33, v2
		v_add3_u32 v12, v12, v15, v18
		v_add3_u32 v12, v12, v19, v11
		v_cndmask_b32_e64 v12, v23, v12, s[56:57]
		s_mov_b32 s56, 0x440
		s_mov_b32 s57, 0
		s_mul_i32 s58, s56, s54
		s_mul_hi_u32 s59, s56, s54
		s_mul_i32 s33, s56, s55
		s_add_i32 s59, s59, s33
		s_mul_i32 s33, s57, s54
		s_add_i32 s59, s59, s33
		s_add_u32 s54, s58, 0x81f0
		s_addc_u32 s55, s59, 0
		s_mov_b32 s56, 0x4400
		s_mov_b32 s57, 0
		s_mul_i32 s60, s56, s52
		s_mul_hi_u32 s61, s56, s52
		s_mul_i32 s33, s56, s53
		s_add_i32 s61, s61, s33
		s_mul_i32 s33, s57, s52
		s_add_i32 s61, s61, s33
		s_add_u32 s52, s54, s60
		s_addc_u32 s53, s55, s61
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		v_accvgpr_read_b32 v14, a57
		v_add_u32_e32 v14, s1, v14
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[52:53], v13, s20
		s_add_i32 s33, s50, s23
		v_add_u32_e32 v12, s33, v2
		v_add3_u32 v12, v12, v15, v18
		v_add3_u32 v12, v12, v19, v11
		v_cndmask_b32_e64 v12, v23, v12, s[52:53]
		s_add_u32 s52, s58, 0x92f0
		s_addc_u32 s53, s59, 0
		s_add_u32 s52, s52, s60
		s_addc_u32 s53, s53, s61
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		v_accvgpr_read_b32 v13, a58
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[52:53], v14, s20
		s_add_i32 s33, s51, s23
		v_add_u32_e32 v12, s33, v2
		v_add3_u32 v12, v12, v15, v18
		v_add3_u32 v12, v12, v19, v11
		s_add_u32 s54, s58, 0xa3f0
		s_addc_u32 s55, s59, 0
		s_add_u32 s54, s54, s60
		s_addc_u32 s55, s55, s61
		s_add_u32 s56, s54, 0
		s_addc_u32 s57, s55, 0
		s_mov_b32 m0, s56
		v_cndmask_b32_e64 v12, v23, v12, s[52:53]
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		s_add_i32 s23, s32, s23
		v_add_u32_e32 v12, s23, v2
		v_add3_u32 v12, v12, v15, v18
		v_cmp_lt_i32_e64 vcc, v13, s20
		v_add3_u32 v12, v12, v19, v11
		s_add_u32 s52, s58, 0xb4f0
		s_addc_u32 s53, s59, 0
		v_cndmask_b32_e32 v12, v23, v12, vcc
		s_add_u32 s52, s52, s60
		s_addc_u32 s53, s53, s61
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		s_nop 0
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
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
		v_add_u32_e32 v12, s39, v5
		v_mfma_f32_32x32x16_bf16 v[96:111], a[132:135], a[44:47], v[96:111]
		v_accvgpr_read_b32 v13, a14
		v_add_u32_e32 v13, s39, v13
		v_mfma_f32_32x32x16_bf16 v[192:207], a[148:151], a[44:47], v[192:207]
		v_accvgpr_read_b32 v14, a15
		v_add_u32_e32 v14, s39, v14
		v_mfma_f32_32x32x16_bf16 v[208:223], a[164:167], a[44:47], v[208:223]
		v_accvgpr_read_b32 v17, a62
		v_add_u32_e32 v17, s39, v17
		v_mfma_f32_32x32x16_bf16 v[112:127], a[136:139], a[32:35], v[112:127]
		v_cmp_ge_i32_e64 vcc, v3, v17
		v_mfma_f32_32x32x16_bf16 v[128:143], a[152:155], a[32:35], v[128:143]
		v_accvgpr_read_b32 v26, a69
		v_add_u32_e32 v26, s39, v26
		v_mfma_f32_32x32x16_bf16 v[144:159], a[168:171], a[32:35], v[144:159]
		v_accvgpr_read_b32 v27, a70
		v_add_u32_e32 v27, s39, v27
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[32:35], v[160:175]
		v_accvgpr_read_b32 v28, a73
		v_add_u32_e32 v28, s39, v28
		v_mfma_f32_32x32x16_bf16 v[176:191], a[180:183], a[48:51], v[176:191]
		v_accvgpr_read_b32 v29, a74
		v_add_u32_e32 v29, s39, v29
		v_mfma_f32_32x32x16_bf16 v[96:111], a[136:139], a[48:51], v[96:111]
		v_accvgpr_read_b32 v30, a77
		v_add_u32_e32 v30, s39, v30
		v_mfma_f32_32x32x16_bf16 v[192:207], a[152:155], a[48:51], v[192:207]
		v_cndmask_b32_e32 v225, v6, v115, vcc
		v_mfma_f32_32x32x16_bf16 v[208:223], a[168:171], a[48:51], v[208:223]
		v_accvgpr_read_b32 v31, a78
		v_add_u32_e32 v31, s39, v31
		v_accvgpr_read_b32 v115, a81
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a53, v115
		v_accvgpr_read_b32 v115, a82
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a59, v115
		v_accvgpr_read_b32 v115, a85
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a60, v115
		v_accvgpr_read_b32 v115, a86
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a61, v115
		v_accvgpr_read_b32 v115, a89
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a63, v115
		v_accvgpr_read_b32 v115, a90
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a65, v115
		v_accvgpr_read_b32 v115, a93
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a127, v115
		v_accvgpr_read_b32 v115, a94
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a128, v115
		v_accvgpr_read_b32 v115, a97
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a129, v115
		v_accvgpr_read_b32 v115, a98
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a130, v115
		v_accvgpr_read_b32 v115, a101
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a131, v115
		v_accvgpr_read_b32 v115, a102
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a132, v115
		v_accvgpr_read_b32 v115, a105
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a133, v115
		v_accvgpr_read_b32 v115, a106
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a134, v115
		v_accvgpr_read_b32 v115, a109
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a135, v115
		v_accvgpr_read_b32 v115, a110
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a136, v115
		v_accvgpr_read_b32 v115, a113
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a137, v115
		v_accvgpr_read_b32 v115, a114
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a138, v115
		v_accvgpr_read_b32 v115, a117
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a139, v115
		v_accvgpr_read_b32 v115, a118
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a140, v115
		v_accvgpr_read_b32 v115, a121
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a141, v115
		v_accvgpr_read_b32 v115, a122
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a142, v115
		v_accvgpr_read_b32 v115, a125
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a143, v115
		v_accvgpr_read_b32 v115, a126
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a144, v115
		v_cmp_ge_i32_e64 s[52:53], v3, v12
		v_cmp_ge_i32_e64 s[54:55], v3, v13
		v_cmp_ge_i32_e64 s[56:57], v3, v14
		v_accvgpr_read_b32 v115, a64
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_read_b32 v224, a68
		v_add_u32_e32 v226, s39, v224
		v_cmp_ge_i32_e64 s[58:59], v3, v115
		v_cmp_ge_i32_e64 s[60:61], v3, v226
		v_cmp_ge_i32_e64 s[62:63], v3, v26
		v_cmp_ge_i32_e64 vcc, v3, v27
		v_accvgpr_read_b32 v224, a71
		v_add_u32_e32 v227, s39, v224
		v_accvgpr_read_b32 v224, a72
		v_add_u32_e32 v228, s39, v224
		v_cndmask_b32_e32 v231, v6, v119, vcc
		v_cmp_ge_i32_e64 s[64:65], v3, v227
		v_cmp_ge_i32_e64 s[66:67], v3, v228
		v_cmp_ge_i32_e64 s[68:69], v3, v28
		v_cmp_ge_i32_e64 vcc, v3, v29
		v_accvgpr_read_b32 v119, a75
		v_add_u32_e32 v119, s39, v119
		v_accvgpr_read_b32 v224, a76
		v_add_u32_e32 v229, s39, v224
		v_cndmask_b32_e32 v233, v6, v123, vcc
		v_cmp_ge_i32_e64 s[70:71], v3, v119
		v_cmp_ge_i32_e64 s[72:73], v3, v229
		v_cmp_ge_i32_e64 s[74:75], v3, v30
		v_cmp_ge_i32_e64 vcc, v3, v31
		v_accvgpr_read_b32 v123, a79
		v_add_u32_e32 v123, s39, v123
		v_accvgpr_read_b32 v224, a80
		v_add_u32_e32 v224, s39, v224
		v_accvgpr_write_b32 a145, v224
		v_cndmask_b32_e32 v235, v6, v127, vcc
		v_cmp_ge_i32_e64 s[76:77], v3, v123
		v_accvgpr_read_b32 v127, a145
		v_cmp_ge_i32_e64 s[78:79], v3, v127
		v_accvgpr_read_b32 v127, a53
		v_cmp_ge_i32_e64 s[80:81], v3, v127
		v_accvgpr_read_b32 v127, a59
		v_cmp_ge_i32_e64 vcc, v3, v127
		v_accvgpr_read_b32 v127, a83
		v_add_u32_e32 v127, s39, v127
		v_accvgpr_write_b32 a146, v127
		v_accvgpr_read_b32 v127, a84
		v_add_u32_e32 v127, s39, v127
		v_accvgpr_write_b32 a147, v127
		v_cndmask_b32_e32 v237, v6, v131, vcc
		v_accvgpr_read_b32 v127, a146
		v_cmp_ge_i32_e64 s[82:83], v3, v127
		v_accvgpr_read_b32 v127, a147
		v_cmp_ge_i32_e64 s[84:85], v3, v127
		v_accvgpr_read_b32 v127, a60
		v_cmp_ge_i32_e64 s[86:87], v3, v127
		v_accvgpr_read_b32 v127, a61
		v_cmp_ge_i32_e64 vcc, v3, v127
		v_accvgpr_read_b32 v127, a87
		v_add_u32_e32 v127, s39, v127
		v_accvgpr_write_b32 a148, v127
		v_accvgpr_read_b32 v127, a88
		v_add_u32_e32 v127, s39, v127
		v_accvgpr_write_b32 a149, v127
		v_cndmask_b32_e32 v239, v6, v135, vcc
		v_accvgpr_read_b32 v127, a148
		v_cmp_ge_i32_e64 s[88:89], v3, v127
		s_nop 1
		v_mov_b32_e32 v240, s88
		v_mov_b32_e32 v241, s89
		v_accvgpr_write_b32 a150, v240
		v_accvgpr_write_b32 a151, v241
		v_accvgpr_read_b32 v127, a149
		v_cmp_ge_i32_e64 s[88:89], v3, v127
		v_accvgpr_read_b32 v127, a65
		v_cmp_ge_i32_e64 vcc, v3, v127
		v_accvgpr_read_b32 v127, a91
		v_add_u32_e32 v127, s39, v127
		v_accvgpr_write_b32 a152, v127
		v_accvgpr_read_b32 v127, a92
		v_add_u32_e32 v127, s39, v127
		v_accvgpr_write_b32 a153, v127
		v_cndmask_b32_e32 v241, v6, v139, vcc
		v_accvgpr_read_b32 v127, a128
		v_cmp_ge_i32_e64 vcc, v3, v127
		v_accvgpr_read_b32 v127, a95
		v_add_u32_e32 v127, s39, v127
		v_accvgpr_write_b32 a154, v127
		v_accvgpr_read_b32 v127, a96
		v_add_u32_e32 v127, s39, v127
		v_accvgpr_write_b32 a155, v127
		v_cndmask_b32_e32 v243, v6, v143, vcc
		v_accvgpr_read_b32 v127, a130
		v_cmp_ge_i32_e64 vcc, v3, v127
		v_accvgpr_read_b32 v127, a99
		v_add_u32_e32 v127, s39, v127
		v_accvgpr_write_b32 a156, v127
		v_accvgpr_read_b32 v127, a100
		v_add_u32_e32 v127, s39, v127
		v_accvgpr_write_b32 a157, v127
		v_cndmask_b32_e32 v245, v6, v147, vcc
		v_accvgpr_read_b32 v127, a132
		v_cmp_ge_i32_e64 vcc, v3, v127
		v_accvgpr_read_b32 v127, a103
		v_add_u32_e32 v127, s39, v127
		v_accvgpr_write_b32 a158, v127
		v_accvgpr_read_b32 v127, a104
		v_add_u32_e32 v127, s39, v127
		v_accvgpr_write_b32 a159, v127
		v_cndmask_b32_e32 v247, v6, v151, vcc
		v_accvgpr_read_b32 v127, a134
		v_cmp_ge_i32_e64 vcc, v3, v127
		v_accvgpr_read_b32 v127, a107
		v_add_u32_e32 v127, s39, v127
		v_accvgpr_write_b32 a160, v127
		v_accvgpr_read_b32 v127, a108
		v_add_u32_e32 v127, s39, v127
		v_accvgpr_write_b32 a161, v127
		v_cndmask_b32_e32 v249, v6, v155, vcc
		v_accvgpr_read_b32 v127, a136
		v_cmp_ge_i32_e64 vcc, v3, v127
		v_accvgpr_read_b32 v127, a63
		v_cmp_ge_i32_e64 s[90:91], v3, v127
		s_nop 1
		v_mov_b32_e32 v250, s90
		v_mov_b32_e32 v251, s91
		v_accvgpr_write_b32 a162, v250
		v_accvgpr_write_b32 a163, v251
		v_cndmask_b32_e64 v250, v6, v112, s[52:53]
		v_accvgpr_read_b32 v112, a152
		v_cmp_ge_i32_e64 s[52:53], v3, v112
		s_nop 1
		v_mov_b32_e32 v252, s52
		v_mov_b32_e32 v253, s53
		v_accvgpr_write_b32 a164, v252
		v_accvgpr_write_b32 a165, v253
		v_accvgpr_read_b32 v112, a153
		v_cmp_ge_i32_e64 s[52:53], v3, v112
		s_nop 1
		v_mov_b32_e32 v252, s52
		v_mov_b32_e32 v253, s53
		v_accvgpr_write_b32 a166, v252
		v_accvgpr_write_b32 a167, v253
		v_accvgpr_read_b32 v112, a127
		v_cmp_ge_i32_e64 s[52:53], v3, v112
		s_nop 1
		v_mov_b32_e32 v252, s52
		v_mov_b32_e32 v253, s53
		v_accvgpr_write_b32 a168, v252
		v_accvgpr_write_b32 a169, v253
		v_accvgpr_read_b32 v112, a154
		v_cmp_ge_i32_e64 s[52:53], v3, v112
		s_nop 1
		v_mov_b32_e32 v252, s52
		v_mov_b32_e32 v253, s53
		v_accvgpr_write_b32 a170, v252
		v_accvgpr_write_b32 a171, v253
		v_accvgpr_read_b32 v112, a155
		v_cmp_ge_i32_e64 s[52:53], v3, v112
		s_nop 1
		v_mov_b32_e32 v252, s52
		v_mov_b32_e32 v253, s53
		v_accvgpr_write_b32 a172, v252
		v_accvgpr_write_b32 a173, v253
		v_accvgpr_read_b32 v112, a129
		v_cmp_ge_i32_e64 s[52:53], v3, v112
		s_nop 1
		v_mov_b32_e32 v252, s52
		v_mov_b32_e32 v253, s53
		v_accvgpr_write_b32 a174, v252
		v_accvgpr_write_b32 a175, v253
		v_accvgpr_read_b32 v112, a156
		v_cmp_ge_i32_e64 s[52:53], v3, v112
		s_nop 1
		v_mov_b32_e32 v252, s52
		v_mov_b32_e32 v253, s53
		v_accvgpr_write_b32 a176, v252
		v_accvgpr_write_b32 a177, v253
		v_accvgpr_read_b32 v112, a157
		v_cmp_ge_i32_e64 s[52:53], v3, v112
		s_nop 1
		v_mov_b32_e32 v252, s52
		v_mov_b32_e32 v253, s53
		v_accvgpr_write_b32 a178, v252
		v_accvgpr_write_b32 a179, v253
		v_accvgpr_read_b32 v112, a131
		v_cmp_ge_i32_e64 s[52:53], v3, v112
		s_nop 1
		v_mov_b32_e32 v252, s52
		v_mov_b32_e32 v253, s53
		v_accvgpr_write_b32 a180, v252
		v_accvgpr_write_b32 a181, v253
		v_accvgpr_read_b32 v112, a158
		v_cmp_ge_i32_e64 s[52:53], v3, v112
		s_nop 1
		v_mov_b32_e32 v252, s52
		v_mov_b32_e32 v253, s53
		v_accvgpr_write_b32 a182, v252
		v_accvgpr_write_b32 a183, v253
		v_accvgpr_read_b32 v112, a159
		v_cmp_ge_i32_e64 s[52:53], v3, v112
		s_nop 1
		v_mov_b32_e32 v252, s52
		v_mov_b32_e32 v253, s53
		v_accvgpr_write_b32 a248, v252
		v_accvgpr_write_b32 a249, v253
		v_accvgpr_read_b32 v112, a133
		v_cmp_ge_i32_e64 s[52:53], v3, v112
		s_nop 1
		v_mov_b32_e32 v252, s52
		v_mov_b32_e32 v253, s53
		v_accvgpr_write_b32 a250, v252
		v_accvgpr_write_b32 a251, v253
		v_accvgpr_read_b32 v112, a160
		v_cmp_ge_i32_e64 s[52:53], v3, v112
		s_nop 1
		v_mov_b32_e32 v252, s52
		v_mov_b32_e32 v253, s53
		v_accvgpr_write_b32 a252, v252
		v_accvgpr_write_b32 a253, v253
		v_accvgpr_read_b32 v112, a161
		v_cmp_ge_i32_e64 s[52:53], v3, v112
		v_accvgpr_read_b32 v112, a135
		v_cmp_ge_i32_e64 s[90:91], v3, v112
		v_cndmask_b32_e32 v253, v6, v159, vcc
		v_cndmask_b32_e64 v255, v6, v157, s[52:53]
		v_cndmask_b32_e64 v252, v6, v158, s[90:91]
		v_accvgpr_read_b32 v112, a111
		v_add_u32_e32 v112, s39, v112
		v_accvgpr_read_b32 v127, a112
		v_add_u32_e32 v127, s39, v127
		v_cmp_ge_i32_e64 s[52:53], v3, v112
		v_cmp_ge_i32_e64 s[90:91], v3, v127
		v_accvgpr_read_b32 v131, a137
		v_cmp_ge_i32_e64 s[92:93], v3, v131
		v_cndmask_b32_e64 v158, v6, v160, s[52:53]
		v_cndmask_b32_e64 v159, v6, v161, s[90:91]
		v_cndmask_b32_e64 v160, v6, v162, s[92:93]
		v_accvgpr_read_b32 v131, a138
		v_cmp_ge_i32_e64 vcc, v3, v131
		v_accvgpr_read_b32 v131, a115
		v_add_u32_e32 v131, s39, v131
		v_accvgpr_read_b32 v135, a116
		v_add_u32_e32 v135, s39, v135
		v_cndmask_b32_e32 v161, v6, v163, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v131
		v_cmp_ge_i32_e64 s[90:91], v3, v135
		v_accvgpr_read_b32 v139, a139
		v_cmp_ge_i32_e64 s[92:93], v3, v139
		v_cndmask_b32_e64 v162, v6, v164, s[52:53]
		v_cndmask_b32_e64 v163, v6, v165, s[90:91]
		v_cndmask_b32_e64 v164, v6, v166, s[92:93]
		v_accvgpr_read_b32 v139, a140
		v_cmp_ge_i32_e64 vcc, v3, v139
		v_accvgpr_read_b32 v139, a119
		v_add_u32_e32 v139, s39, v139
		v_accvgpr_read_b32 v143, a120
		v_add_u32_e32 v143, s39, v143
		v_cndmask_b32_e32 v165, v6, v167, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v139
		v_cmp_ge_i32_e64 s[90:91], v3, v143
		v_accvgpr_read_b32 v147, a141
		v_cmp_ge_i32_e64 s[92:93], v3, v147
		v_cndmask_b32_e64 v166, v6, v168, s[52:53]
		v_cndmask_b32_e64 v167, v6, v169, s[90:91]
		v_cndmask_b32_e64 v168, v6, v170, s[92:93]
		v_accvgpr_read_b32 v147, a142
		v_cmp_ge_i32_e64 vcc, v3, v147
		v_accvgpr_read_b32 v147, a123
		v_add_u32_e32 v147, s39, v147
		v_accvgpr_read_b32 v151, a124
		v_add_u32_e32 v151, s39, v151
		v_cndmask_b32_e32 v169, v6, v171, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v147
		v_cmp_ge_i32_e64 s[90:91], v3, v151
		v_accvgpr_read_b32 v155, a143
		v_cmp_ge_i32_e64 s[92:93], v3, v155
		v_cndmask_b32_e64 v170, v6, v172, s[52:53]
		v_cndmask_b32_e64 v171, v6, v173, s[90:91]
		v_cndmask_b32_e64 v172, v6, v174, s[92:93]
		v_cndmask_b32_e64 v251, v6, v113, s[54:55]
		v_accvgpr_read_b32 v113, a144
		v_cmp_ge_i32_e64 vcc, v3, v113
		v_max3_f32 v113, v158, v159, v160
		v_max3_f32 v155, v162, v163, v164
		v_cndmask_b32_e32 v173, v6, v175, vcc
		v_cmp_ge_i32_e64 s[52:53], v4, v12
		v_cmp_ge_i32_e64 s[54:55], v4, v13
		v_cmp_ge_i32_e64 s[90:91], v4, v14
		v_max3_f32 v12, v166, v167, v168
		v_accvgpr_write_b32 a254, v12
		v_max3_f32 v12, v170, v171, v172
		v_accvgpr_write_b32 a255, v12
		v_cndmask_b32_e64 v12, v6, v98, s[90:91]
		v_cmp_ge_i32_e64 vcc, v4, v17
		v_cndmask_b32_e64 v224, v6, v114, s[56:57]
		v_cndmask_b32_e64 v174, v6, v116, s[58:59]
		v_cndmask_b32_e32 v13, v6, v99, vcc
		v_cmp_ge_i32_e64 s[56:57], v4, v115
		v_cmp_ge_i32_e64 s[58:59], v4, v226
		v_cmp_ge_i32_e64 s[90:91], v4, v26
		v_cndmask_b32_e64 v98, v6, v100, s[56:57]
		v_cndmask_b32_e64 v99, v6, v101, s[58:59]
		v_cndmask_b32_e64 v100, v6, v102, s[90:91]
		v_cmp_ge_i32_e64 vcc, v4, v27
		v_cndmask_b32_e64 v175, v6, v117, s[60:61]
		v_cndmask_b32_e64 v230, v6, v118, s[62:63]
		v_cndmask_b32_e64 v26, v6, v120, s[64:65]
		v_cndmask_b32_e32 v101, v6, v103, vcc
		v_cmp_ge_i32_e64 s[56:57], v4, v227
		v_cmp_ge_i32_e64 s[58:59], v4, v228
		v_cmp_ge_i32_e64 s[60:61], v4, v28
		v_cndmask_b32_e64 v102, v6, v104, s[56:57]
		v_cndmask_b32_e64 v103, v6, v105, s[58:59]
		v_cndmask_b32_e64 v104, v6, v106, s[60:61]
		v_cmp_ge_i32_e64 vcc, v4, v29
		v_cndmask_b32_e64 v27, v6, v121, s[66:67]
		v_max3_f32 v14, v250, v251, v224
		v_cndmask_b32_e32 v105, v6, v107, vcc
		v_cmp_ge_i32_e64 s[56:57], v4, v119
		v_cmp_ge_i32_e64 s[58:59], v4, v229
		v_cmp_ge_i32_e64 s[60:61], v4, v30
		v_cndmask_b32_e64 v28, v6, v108, s[56:57]
		v_cndmask_b32_e64 v29, v6, v109, s[58:59]
		v_cndmask_b32_e64 v106, v6, v110, s[60:61]
		v_cmp_ge_i32_e64 vcc, v4, v31
		v_cndmask_b32_e64 v232, v6, v122, s[68:69]
		v_cndmask_b32_e64 v30, v6, v124, s[70:71]
		v_cndmask_b32_e32 v107, v6, v111, vcc
		v_cmp_ge_i32_e64 s[56:57], v4, v123
		v_accvgpr_read_b32 v17, a145
		v_cmp_ge_i32_e64 s[58:59], v4, v17
		v_accvgpr_read_b32 v17, a53
		v_cmp_ge_i32_e64 s[60:61], v4, v17
		v_cndmask_b32_e64 v108, v6, v192, s[56:57]
		v_cndmask_b32_e64 v109, v6, v193, s[58:59]
		v_cndmask_b32_e64 v110, v6, v194, s[60:61]
		v_accvgpr_read_b32 v17, a59
		v_cmp_ge_i32_e64 vcc, v4, v17
		v_cndmask_b32_e64 v31, v6, v125, s[72:73]
		v_cndmask_b32_e64 v234, v6, v126, s[74:75]
		v_cndmask_b32_e64 v114, v6, v128, s[76:77]
		v_cndmask_b32_e32 v111, v6, v195, vcc
		v_accvgpr_read_b32 v17, a146
		v_cmp_ge_i32_e64 s[56:57], v4, v17
		v_accvgpr_read_b32 v17, a147
		v_cmp_ge_i32_e64 s[58:59], v4, v17
		v_accvgpr_read_b32 v17, a60
		v_cmp_ge_i32_e64 s[60:61], v4, v17
		v_cndmask_b32_e64 v116, v6, v196, s[56:57]
		v_cndmask_b32_e64 v117, v6, v197, s[58:59]
		v_cndmask_b32_e64 v118, v6, v198, s[60:61]
		v_accvgpr_read_b32 v17, a61
		v_cmp_ge_i32_e64 vcc, v4, v17
		v_cndmask_b32_e64 v115, v6, v129, s[78:79]
		v_max3_f32 v17, v174, v175, v230
		v_cndmask_b32_e32 v119, v6, v199, vcc
		v_accvgpr_read_b32 v120, a148
		v_cmp_ge_i32_e64 s[56:57], v4, v120
		v_accvgpr_read_b32 v120, a149
		v_cmp_ge_i32_e64 s[58:59], v4, v120
		v_accvgpr_read_b32 v120, a63
		v_cmp_ge_i32_e64 s[60:61], v4, v120
		v_cndmask_b32_e64 v120, v6, v200, s[56:57]
		v_cndmask_b32_e64 v121, v6, v201, s[58:59]
		v_cndmask_b32_e64 v122, v6, v202, s[60:61]
		v_accvgpr_read_b32 v123, a65
		v_cmp_ge_i32_e64 vcc, v4, v123
		v_cndmask_b32_e64 v236, v6, v130, s[80:81]
		v_cndmask_b32_e64 v124, v6, v132, s[82:83]
		v_cndmask_b32_e32 v123, v6, v203, vcc
		v_accvgpr_read_b32 v125, a128
		v_cmp_ge_i32_e64 vcc, v4, v125
		v_accvgpr_read_b32 v125, a152
		v_cmp_ge_i32_e64 s[56:57], v4, v125
		v_accvgpr_read_b32 v125, a153
		v_cmp_ge_i32_e64 s[58:59], v4, v125
		v_accvgpr_read_b32 v125, a127
		v_cmp_ge_i32_e64 s[60:61], v4, v125
		v_cndmask_b32_e64 v128, v6, v204, s[56:57]
		v_cndmask_b32_e64 v129, v6, v205, s[58:59]
		v_cndmask_b32_e64 v192, v6, v206, s[60:61]
		v_cndmask_b32_e64 v125, v6, v133, s[84:85]
		v_cndmask_b32_e64 v238, v6, v134, s[86:87]
		v_cndmask_b32_e32 v193, v6, v207, vcc
		v_accvgpr_read_b32 v126, a154
		v_cmp_ge_i32_e64 s[56:57], v4, v126
		v_accvgpr_read_b32 v126, a155
		v_cmp_ge_i32_e64 s[58:59], v4, v126
		v_accvgpr_read_b32 v126, a130
		v_cmp_ge_i32_e64 vcc, v4, v126
		v_accvgpr_read_b32 v126, a129
		v_cmp_ge_i32_e64 s[60:61], v4, v126
		v_cndmask_b32_e64 v132, v6, v208, s[56:57]
		v_cndmask_b32_e64 v133, v6, v209, s[58:59]
		v_cndmask_b32_e64 v194, v6, v210, s[60:61]
		v_accvgpr_read_b32 v126, a150
		s_nop 0
		v_readfirstlane_b32 s56, v126
		v_accvgpr_read_b32 v126, a151
		s_nop 0
		v_readfirstlane_b32 s57, v126
		s_nop 1
		v_cndmask_b32_e64 v196, v6, v136, s[56:57]
		v_cndmask_b32_e64 v197, v6, v137, s[88:89]
		v_cndmask_b32_e32 v195, v6, v211, vcc
		v_accvgpr_read_b32 v126, a156
		v_cmp_ge_i32_e64 s[56:57], v4, v126
		v_accvgpr_read_b32 v126, a157
		v_cmp_ge_i32_e64 s[58:59], v4, v126
		v_accvgpr_read_b32 v126, a131
		v_cmp_ge_i32_e64 s[60:61], v4, v126
		v_cndmask_b32_e64 v136, v6, v212, s[56:57]
		v_cndmask_b32_e64 v137, v6, v213, s[58:59]
		v_cndmask_b32_e64 v198, v6, v214, s[60:61]
		v_accvgpr_read_b32 v126, a132
		v_cmp_ge_i32_e64 vcc, v4, v126
		v_accvgpr_read_b32 v126, a162
		s_nop 0
		v_readfirstlane_b32 s56, v126
		v_accvgpr_read_b32 v126, a163
		s_nop 0
		v_readfirstlane_b32 s57, v126
		s_nop 1
		v_cndmask_b32_e64 v240, v6, v138, s[56:57]
		v_accvgpr_read_b32 v126, a164
		s_nop 0
		v_readfirstlane_b32 s56, v126
		v_accvgpr_read_b32 v126, a165
		s_nop 0
		v_readfirstlane_b32 s57, v126
		s_nop 1
		v_cndmask_b32_e64 v200, v6, v140, s[56:57]
		v_cndmask_b32_e32 v199, v6, v215, vcc
		v_accvgpr_read_b32 v126, a158
		v_cmp_ge_i32_e64 s[56:57], v4, v126
		v_accvgpr_read_b32 v126, a159
		v_cmp_ge_i32_e64 s[58:59], v4, v126
		v_accvgpr_read_b32 v126, a133
		v_cmp_ge_i32_e64 s[60:61], v4, v126
		v_cndmask_b32_e64 v202, v6, v216, s[56:57]
		v_cndmask_b32_e64 v203, v6, v217, s[58:59]
		v_cndmask_b32_e64 v204, v6, v218, s[60:61]
		v_accvgpr_read_b32 v126, a134
		v_cmp_ge_i32_e64 vcc, v4, v126
		v_accvgpr_read_b32 v126, a166
		s_nop 0
		v_readfirstlane_b32 s56, v126
		v_accvgpr_read_b32 v126, a167
		s_nop 0
		v_readfirstlane_b32 s57, v126
		s_nop 1
		v_cndmask_b32_e64 v201, v6, v141, s[56:57]
		v_accvgpr_read_b32 v126, a168
		s_nop 0
		v_readfirstlane_b32 s56, v126
		v_accvgpr_read_b32 v126, a169
		s_nop 0
		v_readfirstlane_b32 s57, v126
		s_nop 1
		v_cndmask_b32_e64 v242, v6, v142, s[56:57]
		v_cndmask_b32_e32 v205, v6, v219, vcc
		v_accvgpr_read_b32 v126, a160
		v_cmp_ge_i32_e64 s[56:57], v4, v126
		v_accvgpr_read_b32 v126, a161
		v_cmp_ge_i32_e64 s[58:59], v4, v126
		v_accvgpr_read_b32 v126, a135
		v_cmp_ge_i32_e64 s[60:61], v4, v126
		v_cndmask_b32_e64 v140, v6, v220, s[56:57]
		v_cndmask_b32_e64 v141, v6, v221, s[58:59]
		v_cndmask_b32_e64 v206, v6, v222, s[60:61]
		v_accvgpr_read_b32 v126, a136
		v_cmp_ge_i32_e64 vcc, v4, v126
		v_accvgpr_read_b32 v126, a170
		s_nop 0
		v_readfirstlane_b32 s56, v126
		v_accvgpr_read_b32 v126, a171
		s_nop 0
		v_readfirstlane_b32 s57, v126
		s_nop 1
		v_cndmask_b32_e64 v208, v6, v144, s[56:57]
		v_accvgpr_read_b32 v126, a172
		s_nop 0
		v_readfirstlane_b32 s56, v126
		v_accvgpr_read_b32 v126, a173
		s_nop 0
		v_readfirstlane_b32 s57, v126
		s_nop 1
		v_cndmask_b32_e64 v209, v6, v145, s[56:57]
		v_cndmask_b32_e32 v207, v6, v223, vcc
		v_cmp_ge_i32_e64 s[56:57], v4, v112
		v_cmp_ge_i32_e64 s[58:59], v4, v127
		v_accvgpr_read_b32 v112, a137
		v_cmp_ge_i32_e64 s[60:61], v4, v112
		v_cndmask_b32_e64 v126, v6, v176, s[56:57]
		v_cndmask_b32_e64 v127, v6, v177, s[58:59]
		v_cndmask_b32_e64 v144, v6, v178, s[60:61]
		v_accvgpr_read_b32 v112, a138
		v_cmp_ge_i32_e64 vcc, v4, v112
		v_accvgpr_read_b32 v112, a174
		s_nop 0
		v_readfirstlane_b32 s56, v112
		v_accvgpr_read_b32 v112, a175
		s_nop 0
		v_readfirstlane_b32 s57, v112
		s_nop 1
		v_cndmask_b32_e64 v244, v6, v146, s[56:57]
		v_accvgpr_read_b32 v112, a176
		s_nop 0
		v_readfirstlane_b32 s56, v112
		v_accvgpr_read_b32 v112, a177
		s_nop 0
		v_readfirstlane_b32 s57, v112
		s_nop 1
		v_cndmask_b32_e64 v176, v6, v148, s[56:57]
		v_cndmask_b32_e32 v145, v6, v179, vcc
		v_cmp_ge_i32_e64 s[56:57], v4, v131
		v_cmp_ge_i32_e64 s[58:59], v4, v135
		v_accvgpr_read_b32 v112, a139
		v_cmp_ge_i32_e64 s[60:61], v4, v112
		v_cndmask_b32_e64 v130, v6, v180, s[56:57]
		v_cndmask_b32_e64 v131, v6, v181, s[58:59]
		v_cndmask_b32_e64 v134, v6, v182, s[60:61]
		v_accvgpr_read_b32 v112, a140
		v_cmp_ge_i32_e64 vcc, v4, v112
		v_accvgpr_read_b32 v112, a178
		s_nop 0
		v_readfirstlane_b32 s56, v112
		v_accvgpr_read_b32 v112, a179
		s_nop 0
		v_readfirstlane_b32 s57, v112
		s_nop 1
		v_cndmask_b32_e64 v177, v6, v149, s[56:57]
		v_accvgpr_read_b32 v112, a180
		s_nop 0
		v_readfirstlane_b32 s56, v112
		v_accvgpr_read_b32 v112, a181
		s_nop 0
		v_readfirstlane_b32 s57, v112
		s_nop 1
		v_cndmask_b32_e64 v246, v6, v150, s[56:57]
		v_cndmask_b32_e32 v135, v6, v183, vcc
		v_cmp_ge_i32_e64 s[56:57], v4, v139
		v_cmp_ge_i32_e64 s[58:59], v4, v143
		v_accvgpr_read_b32 v112, a141
		v_cmp_ge_i32_e64 s[60:61], v4, v112
		v_cndmask_b32_e64 v138, v6, v184, s[56:57]
		v_cndmask_b32_e64 v139, v6, v185, s[58:59]
		v_cndmask_b32_e64 v142, v6, v186, s[60:61]
		v_accvgpr_read_b32 v112, a142
		v_cmp_ge_i32_e64 vcc, v4, v112
		v_accvgpr_read_b32 v112, a182
		s_nop 0
		v_readfirstlane_b32 s56, v112
		v_accvgpr_read_b32 v112, a183
		s_nop 0
		v_readfirstlane_b32 s57, v112
		s_nop 1
		v_cndmask_b32_e64 v148, v6, v152, s[56:57]
		v_accvgpr_read_b32 v112, a248
		s_nop 0
		v_readfirstlane_b32 s56, v112
		v_accvgpr_read_b32 v112, a249
		s_nop 0
		v_readfirstlane_b32 s57, v112
		s_nop 1
		v_cndmask_b32_e64 v149, v6, v153, s[56:57]
		v_cndmask_b32_e32 v143, v6, v187, vcc
		v_cmp_ge_i32_e64 s[56:57], v4, v147
		v_cmp_ge_i32_e64 s[58:59], v4, v151
		v_accvgpr_read_b32 v112, a143
		v_cmp_ge_i32_e64 s[60:61], v4, v112
		v_cndmask_b32_e64 v146, v6, v188, s[56:57]
		v_cndmask_b32_e64 v147, v6, v189, s[58:59]
		v_cndmask_b32_e64 v150, v6, v190, s[60:61]
		v_accvgpr_read_b32 v112, a144
		v_cmp_ge_i32_e64 vcc, v4, v112
		v_accvgpr_read_b32 v112, a250
		s_nop 0
		v_readfirstlane_b32 s56, v112
		v_accvgpr_read_b32 v112, a251
		s_nop 0
		v_readfirstlane_b32 s57, v112
		s_nop 1
		v_cndmask_b32_e64 v248, v6, v154, s[56:57]
		v_accvgpr_read_b32 v112, a252
		s_nop 0
		v_readfirstlane_b32 s56, v112
		v_accvgpr_read_b32 v112, a253
		s_nop 0
		v_readfirstlane_b32 s57, v112
		s_nop 1
		v_cndmask_b32_e64 v254, v6, v156, s[56:57]
		v_cndmask_b32_e32 v151, v6, v191, vcc
		v_max3_f32 v112, v26, v27, v232
		v_max3_f32 v152, v30, v31, v234
		v_max3_f32 v153, v114, v115, v236
		v_max3_f32 v154, v124, v125, v238
		v_max3_f32 v156, v196, v197, v240
		v_max3_f32 v157, v200, v201, v242
		v_max3_f32 v178, v208, v209, v244
		v_max3_f32 v179, v176, v177, v246
		v_max3_f32 v180, v148, v149, v248
		v_max3_f32 v181, v254, v255, v252
		v_max3_f32 v14, v14, v225, v17
		v_max3_f32 v17, v112, v233, v152
		v_max3_f32 v112, v153, v237, v154
		v_max3_f32 v152, v156, v241, v157
		v_max3_f32 v153, v178, v245, v179
		v_max3_f32 v154, v180, v249, v181
		v_max3_f32 v113, v113, v161, v155
		v_accvgpr_read_b32 v155, a254
		v_accvgpr_read_b32 v156, a255
		v_max3_f32 v155, v155, v169, v156
		v_max3_f32 v14, v14, v231, v17
		v_max3_f32 v17, v112, v239, v152
		v_max3_f32 v112, v153, v247, v154
		v_max3_f32 v113, v113, v165, v155
		v_max3_f32 v14, v14, v235, v17
		v_max3_f32 v17, v112, v253, v113
		v_max3_f32 v14, v14, v243, v17
		v_max_f32_e32 v112, v14, v173
		v_mov_b32_e32 v113, v112
		v_cndmask_b32_e64 v152, v6, v96, s[52:53]
		v_cndmask_b32_e64 v153, v6, v97, s[54:55]
		v_permlane32_swap_b32_e32 v112, v113
		v_max3_f32 v14, v152, v153, v12
		v_max3_f32 v17, v98, v99, v100
		v_max3_f32 v96, v102, v103, v104
		v_max3_f32 v97, v28, v29, v106
		v_max3_f32 v154, v108, v109, v110
		v_max3_f32 v155, v116, v117, v118
		v_max3_f32 v156, v120, v121, v122
		v_max3_f32 v157, v128, v129, v192
		v_max3_f32 v178, v132, v133, v194
		v_max3_f32 v179, v136, v137, v198
		v_max3_f32 v180, v202, v203, v204
		v_max3_f32 v181, v140, v141, v206
		v_max3_f32 v182, v126, v127, v144
		v_max3_f32 v183, v130, v131, v134
		v_max3_f32 v184, v138, v139, v142
		v_max3_f32 v185, v146, v147, v150
		v_max3_f32 v14, v14, v13, v17
		v_max3_f32 v17, v96, v105, v97
		v_max3_f32 v96, v154, v111, v155
		v_max3_f32 v97, v156, v123, v157
		v_max3_f32 v154, v178, v195, v179
		v_max3_f32 v155, v180, v205, v181
		v_max3_f32 v156, v182, v145, v183
		v_max3_f32 v157, v184, v143, v185
		v_max3_f32 v14, v14, v101, v17
		v_max3_f32 v17, v96, v119, v97
		v_max3_f32 v96, v154, v199, v155
		v_max3_f32 v97, v156, v135, v157
		v_max3_f32 v14, v14, v107, v17
		v_max3_f32 v17, v96, v207, v97
		v_max3_f32 v14, v14, v193, v17
		v_max_f32_e32 v96, v14, v151
		v_mov_b32_e32 v97, v96
		v_max_f32_e32 v154, v112, v113
		v_mov_b32_e32 v112, v7
		v_permlane32_swap_b32_e32 v96, v97
		v_max_f32_e32 v155, v96, v97
		v_pk_mul_f32 v[96:97], v[154:155], v[8:9]
		v_max_f32_e32 v154, v7, v96
		v_max_f32_e32 v155, v10, v97
		v_pk_fma_f32 v[96:97], v[250:251], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[224:225], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[174:175], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[230:231], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[26:27], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[232:233], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[30:31], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[234:235], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[114:115], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[236:237], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[124:125], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[238:239], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[196:197], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[240:241], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[200:201], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[242:243], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[208:209], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[244:245], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[176:177], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[246:247], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[148:149], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[248:249], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[254:255], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[218:219], v[252:253], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[220:221], v[158:159], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[160:161], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[162:163], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[164:165], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[166:167], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[168:169], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[170:171], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[172:173], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[152:153], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[12:13], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[12:13], v[98:99], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[28:29], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[106:107], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[108:109], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[110:111], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[116:117], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[118:119], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[120:121], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[122:123], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[128:129], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[192:193], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[132:133], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[194:195], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[136:137], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[198:199], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[202:203], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[204:205], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[140:141], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[206:207], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[126:127], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[144:145], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[130:131], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[134:135], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[138:139], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[142:143], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[146:147], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[150:151], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v150, v96
		v_exp_f32_e32 v222, v97
		v_exp_f32_e32 v96, v156
		v_exp_f32_e32 v224, v157
		v_exp_f32_e32 v156, v178
		v_exp_f32_e32 v226, v179
		v_exp_f32_e32 v178, v174
		v_exp_f32_e32 v228, v175
		v_exp_f32_e32 v174, v180
		v_exp_f32_e32 v230, v181
		v_exp_f32_e32 v180, v26
		v_exp_f32_e32 v232, v27
		v_exp_f32_e32 v26, v182
		v_exp_f32_e32 v234, v183
		v_exp_f32_e32 v182, v30
		v_exp_f32_e32 v236, v31
		v_exp_f32_e32 v30, v184
		v_exp_f32_e32 v238, v185
		v_exp_f32_e32 v184, v114
		v_exp_f32_e32 v240, v115
		v_exp_f32_e32 v114, v186
		v_exp_f32_e32 v242, v187
		v_exp_f32_e32 v186, v124
		v_exp_f32_e32 v244, v125
		v_exp_f32_e32 v124, v188
		v_exp_f32_e32 v246, v189
		v_exp_f32_e32 v188, v190
		v_exp_f32_e32 v248, v191
		v_exp_f32_e32 v190, v196
		v_exp_f32_e32 v250, v197
		v_exp_f32_e32 v196, v200
		v_exp_f32_e32 v252, v201
		v_exp_f32_e32 v151, v210
		v_exp_f32_e32 v223, v211
		v_exp_f32_e32 v97, v208
		v_exp_f32_e32 v225, v209
		v_exp_f32_e32 v157, v212
		v_exp_f32_e32 v227, v213
		v_exp_f32_e32 v179, v176
		v_exp_f32_e32 v229, v177
		v_exp_f32_e32 v175, v214
		v_exp_f32_e32 v231, v215
		v_exp_f32_e32 v181, v148
		v_exp_f32_e32 v233, v149
		v_exp_f32_e32 v27, v216
		v_exp_f32_e32 v235, v217
		v_exp_f32_e32 v183, v218
		v_exp_f32_e32 v237, v219
		v_exp_f32_e32 v31, v220
		v_exp_f32_e32 v239, v221
		v_exp_f32_e32 v185, v158
		v_exp_f32_e32 v241, v159
		v_exp_f32_e32 v115, v160
		v_exp_f32_e32 v243, v161
		v_exp_f32_e32 v187, v162
		v_exp_f32_e32 v245, v163
		v_exp_f32_e32 v125, v164
		v_exp_f32_e32 v247, v165
		v_exp_f32_e32 v189, v166
		v_exp_f32_e32 v249, v167
		v_exp_f32_e32 v191, v168
		v_exp_f32_e32 v251, v169
		v_exp_f32_e32 v197, v170
		v_exp_f32_e32 v253, v171
		v_exp_f32_e32 v148, v172
		v_exp_f32_e32 v158, v173
		v_exp_f32_e32 v160, v152
		v_exp_f32_e32 v162, v153
		v_exp_f32_e32 v152, v12
		v_exp_f32_e32 v164, v13
		v_exp_f32_e32 v12, v98
		v_exp_f32_e32 v166, v99
		v_exp_f32_e32 v98, v100
		v_exp_f32_e32 v168, v101
		v_exp_f32_e32 v100, v102
		v_exp_f32_e32 v170, v103
		v_exp_f32_e32 v102, v104
		v_exp_f32_e32 v172, v105
		v_exp_f32_e32 v104, v28
		v_exp_f32_e32 v176, v29
		v_exp_f32_e32 v28, v106
		v_exp_f32_e32 v200, v107
		v_exp_f32_e32 v106, v108
		v_exp_f32_e32 v208, v109
		v_exp_f32_e32 v108, v110
		v_exp_f32_e32 v210, v111
		v_exp_f32_e32 v110, v116
		v_exp_f32_e32 v212, v117
		v_exp_f32_e32 v116, v118
		v_exp_f32_e32 v214, v119
		v_exp_f32_e32 v118, v120
		v_exp_f32_e32 v216, v121
		v_exp_f32_e32 v120, v122
		v_exp_f32_e32 v218, v123
		v_exp_f32_e32 v122, v128
		v_exp_f32_e32 v220, v129
		v_exp_f32_e32 v149, v192
		v_exp_f32_e32 v159, v193
		v_exp_f32_e32 v161, v132
		v_exp_f32_e32 v163, v133
		v_exp_f32_e32 v153, v194
		v_exp_f32_e32 v165, v195
		v_exp_f32_e32 v13, v136
		v_exp_f32_e32 v167, v137
		v_exp_f32_e32 v99, v198
		v_exp_f32_e32 v169, v199
		v_exp_f32_e32 v101, v202
		v_exp_f32_e32 v171, v203
		v_exp_f32_e32 v103, v204
		v_exp_f32_e32 v173, v205
		v_exp_f32_e32 v105, v140
		v_exp_f32_e32 v177, v141
		v_exp_f32_e32 v29, v206
		v_exp_f32_e32 v201, v207
		v_exp_f32_e32 v107, v126
		v_exp_f32_e32 v209, v127
		v_exp_f32_e32 v109, v144
		v_exp_f32_e32 v211, v145
		v_exp_f32_e32 v111, v130
		v_exp_f32_e32 v213, v131
		v_exp_f32_e32 v117, v134
		v_exp_f32_e32 v215, v135
		v_exp_f32_e32 v119, v138
		v_exp_f32_e32 v217, v139
		v_exp_f32_e32 v121, v142
		v_exp_f32_e32 v219, v143
		v_exp_f32_e32 v123, v146
		v_exp_f32_e32 v221, v147
		v_pk_add_f32 v[126:127], v[150:151], v[222:223]
		v_pk_add_f32 v[128:129], v[96:97], v[224:225]
		v_pk_add_f32 v[130:131], v[156:157], v[226:227]
		v_pk_add_f32 v[132:133], v[178:179], v[228:229]
		v_pk_add_f32 v[134:135], v[174:175], v[230:231]
		v_pk_add_f32 v[136:137], v[180:181], v[232:233]
		v_pk_add_f32 v[138:139], v[26:27], v[234:235]
		v_pk_add_f32 v[140:141], v[182:183], v[236:237]
		v_pk_add_f32 v[142:143], v[30:31], v[238:239]
		v_pk_add_f32 v[144:145], v[184:185], v[240:241]
		v_pk_add_f32 v[146:147], v[114:115], v[242:243]
		v_pk_add_f32 v[192:193], v[186:187], v[244:245]
		v_pk_add_f32 v[194:195], v[124:125], v[246:247]
		v_pk_add_f32 v[198:199], v[188:189], v[248:249]
		v_pk_add_f32 v[202:203], v[190:191], v[250:251]
		v_pk_add_f32 v[204:205], v[196:197], v[252:253]
		v_pk_add_f32 v[126:127], v[126:127], v[128:129]
		v_pk_add_f32 v[128:129], v[130:131], v[132:133]
		v_pk_add_f32 v[130:131], v[134:135], v[136:137]
		v_pk_add_f32 v[132:133], v[138:139], v[140:141]
		v_pk_add_f32 v[134:135], v[142:143], v[144:145]
		v_pk_add_f32 v[136:137], v[146:147], v[192:193]
		v_pk_add_f32 v[138:139], v[194:195], v[198:199]
		v_pk_add_f32 v[140:141], v[202:203], v[204:205]
		v_pk_add_f32 v[126:127], v[126:127], v[128:129]
		v_pk_add_f32 v[128:129], v[130:131], v[132:133]
		v_pk_add_f32 v[130:131], v[134:135], v[136:137]
		v_pk_add_f32 v[132:133], v[138:139], v[140:141]
		v_pk_add_f32 v[126:127], v[126:127], v[128:129]
		v_pk_add_f32 v[128:129], v[130:131], v[132:133]
		v_pk_add_f32 v[130:131], v[126:127], v[128:129]
		v_add_f32_e32 v7, v130, v131
		v_accvgpr_read_b32 v14, a66
		ds_bpermute_b32 v126, v14, v7
		v_accvgpr_read_b32 v14, a67
		ds_bpermute_b32 v128, v14, v7
		v_pk_add_f32 v[130:131], v[148:149], v[158:159]
		v_pk_add_f32 v[132:133], v[160:161], v[162:163]
		v_pk_add_f32 v[134:135], v[152:153], v[164:165]
		v_pk_add_f32 v[136:137], v[12:13], v[166:167]
		v_pk_add_f32 v[138:139], v[98:99], v[168:169]
		v_pk_add_f32 v[140:141], v[100:101], v[170:171]
		v_pk_add_f32 v[142:143], v[102:103], v[172:173]
		v_pk_add_f32 v[144:145], v[104:105], v[176:177]
		v_pk_add_f32 v[146:147], v[28:29], v[200:201]
		v_pk_add_f32 v[192:193], v[106:107], v[208:209]
		v_pk_add_f32 v[194:195], v[108:109], v[210:211]
		v_pk_add_f32 v[198:199], v[110:111], v[212:213]
		v_pk_add_f32 v[202:203], v[116:117], v[214:215]
		v_pk_add_f32 v[204:205], v[118:119], v[216:217]
		v_pk_add_f32 v[206:207], v[120:121], v[218:219]
		v_pk_add_f32 v[254:255], v[122:123], v[220:221]
		v_pk_add_f32 v[130:131], v[130:131], v[132:133]
		v_pk_add_f32 v[132:133], v[134:135], v[136:137]
		v_pk_add_f32 v[134:135], v[138:139], v[140:141]
		v_pk_add_f32 v[136:137], v[142:143], v[144:145]
		v_pk_add_f32 v[138:139], v[146:147], v[192:193]
		v_pk_add_f32 v[140:141], v[194:195], v[198:199]
		v_pk_add_f32 v[142:143], v[202:203], v[204:205]
		v_pk_add_f32 v[144:145], v[206:207], v[254:255]
		v_pk_add_f32 v[130:131], v[130:131], v[132:133]
		v_pk_add_f32 v[132:133], v[134:135], v[136:137]
		v_pk_add_f32 v[134:135], v[138:139], v[140:141]
		v_pk_add_f32 v[136:137], v[142:143], v[144:145]
		v_pk_add_f32 v[130:131], v[130:131], v[132:133]
		v_pk_add_f32 v[132:133], v[134:135], v[136:137]
		v_pk_add_f32 v[134:135], v[130:131], v[132:133]
		v_mov_b32_e32 v129, v135
		v_mov_b32_e32 v127, v134
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[130:131], v[126:127], v[128:129]
		v_mov_b32_e32 v126, v131
		v_mov_b32_e32 v127, v131
		v_cvt_pk_bf16_f32 v132, v150, v222
		v_cvt_pk_bf16_f32 v133, v96, v224
		v_permlane32_swap_b32_e32 v126, v127
		v_add_f32_e32 v129, v126, v127
		v_mov_b32_e32 v113, v10
		v_pk_add_f32 v[126:127], v[112:113], v[154:155] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v112, v126
		v_exp_f32_e32 v113, v127
		v_cvt_pk_bf16_f32 v134, v156, v226
		v_pk_mul_f32 v[32:33], v[32:33], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[34:35], v[34:35], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[36:37], v[36:37], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[38:39], v[38:39], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[40:41], v[40:41], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[42:43], v[42:43], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[44:45], v[44:45], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[46:47], v[46:47], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[48:49], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[50:51], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[52:53], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[54:55], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[56:57], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[58:59], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[60:61], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[62:63], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[64:65], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[66:67], v[66:67], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[68:69], v[68:69], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[70:71], v[70:71], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[72:73], v[72:73], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[74:75], v[74:75], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[76:77], v[76:77], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[78:79], v[78:79], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[80:81], v[80:81], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[82:83], v[82:83], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[84:85], v[84:85], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[86:87], v[86:87], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[88:89], v[88:89], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[90:91], v[90:91], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[92:93], v[92:93], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[94:95], v[94:95], v[112:113] op_sel:[0,1]
		v_mov_b32_e32 v128, v130
		v_mov_b64_e32 v[126:127], v[24:25]
		v_pk_fma_f32 v[24:25], v[126:127], v[112:113], v[128:129]
		v_cvt_pk_bf16_f32 v135, v178, v228
		v_cvt_pk_bf16_f32 v128, v174, v230
		v_cvt_pk_bf16_f32 v129, v180, v232
		v_cvt_pk_bf16_f32 v130, v26, v234
		v_cvt_pk_bf16_f32 v131, v182, v236
		v_cvt_pk_bf16_f32 v136, v30, v238
		v_cvt_pk_bf16_f32 v137, v184, v240
		v_cvt_pk_bf16_f32 v138, v114, v242
		v_cvt_pk_bf16_f32 v139, v186, v244
		v_cvt_pk_bf16_f32 v140, v124, v246
		v_cvt_pk_bf16_f32 v141, v188, v248
		v_cvt_pk_bf16_f32 v142, v190, v250
		v_cvt_pk_bf16_f32 v143, v196, v252
		v_cvt_pk_bf16_f32 v144, v151, v223
		v_cvt_pk_bf16_f32 v145, v97, v225
		v_cvt_pk_bf16_f32 v146, v157, v227
		v_cvt_pk_bf16_f32 v147, v179, v229
		v_cvt_pk_bf16_f32 v192, v175, v231
		v_cvt_pk_bf16_f32 v193, v181, v233
		v_cvt_pk_bf16_f32 v194, v27, v235
		v_cvt_pk_bf16_f32 v195, v183, v237
		v_cvt_pk_bf16_f32 v180, v31, v239
		v_cvt_pk_bf16_f32 v181, v185, v241
		v_cvt_pk_bf16_f32 v182, v115, v243
		v_cvt_pk_bf16_f32 v183, v187, v245
		v_cvt_pk_bf16_f32 v112, v125, v247
		v_cvt_pk_bf16_f32 v113, v189, v249
		v_cvt_pk_bf16_f32 v114, v191, v251
		v_cvt_pk_bf16_f32 v115, v197, v253
		v_cvt_pk_bf16_f32 v124, v148, v158
		v_cvt_pk_bf16_f32 v125, v160, v162
		v_cvt_pk_bf16_f32 v126, v152, v164
		v_cvt_pk_bf16_f32 v127, v12, v166
		v_cvt_pk_bf16_f32 v184, v98, v168
		v_cvt_pk_bf16_f32 v185, v100, v170
		v_cvt_pk_bf16_f32 v186, v102, v172
		v_cvt_pk_bf16_f32 v187, v104, v176
		v_cvt_pk_bf16_f32 v188, v28, v200
		v_cvt_pk_bf16_f32 v189, v106, v208
		v_cvt_pk_bf16_f32 v190, v108, v210
		v_cvt_pk_bf16_f32 v191, v110, v212
		v_cvt_pk_bf16_f32 v196, v116, v214
		v_cvt_pk_bf16_f32 v197, v118, v216
		v_cvt_pk_bf16_f32 v198, v120, v218
		v_cvt_pk_bf16_f32 v199, v122, v220
		v_cvt_pk_bf16_f32 v204, v149, v159
		v_cvt_pk_bf16_f32 v205, v161, v163
		v_cvt_pk_bf16_f32 v206, v153, v165
		v_cvt_pk_bf16_f32 v207, v13, v167
		v_cvt_pk_bf16_f32 v148, v99, v169
		v_cvt_pk_bf16_f32 v149, v101, v171
		v_cvt_pk_bf16_f32 v150, v103, v173
		v_cvt_pk_bf16_f32 v151, v105, v177
		v_cvt_pk_bf16_f32 v96, v29, v201
		v_cvt_pk_bf16_f32 v97, v107, v209
		v_cvt_pk_bf16_f32 v98, v109, v211
		v_cvt_pk_bf16_f32 v99, v111, v213
		v_cvt_pk_bf16_f32 v28, v117, v215
		v_cvt_pk_bf16_f32 v29, v119, v217
		v_cvt_pk_bf16_f32 v30, v121, v219
		v_cvt_pk_bf16_f32 v31, v123, v221
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[32:47], a[184:187], v[132:135], v[32:47]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[48:63], a[216:219], v[132:135], v[48:63]
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_mfma_f32_32x32x16_bf16 v[32:47], a[188:191], v[128:131], v[32:47]
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_mfma_f32_32x32x16_bf16 v[48:63], a[220:223], v[128:131], v[48:63]
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[136:139], v[32:47]
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[136:139], v[48:63]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[140:143], v[32:47]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[140:143], v[48:63]
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_mfma_f32_32x32x16_bf16 v[80:95], a[216:219], v[124:127], v[80:95]
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[64:79], a[184:187], v[124:127], v[64:79]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[80:95], a[220:223], v[184:187], v[80:95]
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_mfma_f32_32x32x16_bf16 v[64:79], a[188:191], v[184:187], v[64:79]
		v_permlane32_swap_b32_e32 v148, v150
		v_permlane32_swap_b32_e32 v149, v151
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[188:191], v[80:95]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[188:191], v[64:79]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[196:199], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[196:199], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[144:147], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[144:147], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[204:207], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[204:207], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[192:195], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[192:195], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[148:151], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[148:151], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[180:183], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[180:183], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[112:115], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[112:115], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[28:31], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[28:31], v[64:79]
		s_cselect_b32 s1, 1, 0
		s_add_i32 s23, s39, 0x80
		s_cmp_lg_u32 s1, 0
		s_mov_b32 s39, s23
		v_mov_b32_e32 v7, v154
		v_mov_b32_e32 v10, v155
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_2
.L_attn_fwd_persistent.loop_exit_2:
		s_mov_b32 s24, s8
		s_mov_b32 s25, s9
		s_mov_b32 s26, s42
		s_mov_b32 s27, s43
		v_rcp_f32_e32 v2, v24
		v_accvgpr_read_b32 v3, a12
		s_nop 0
		v_readfirstlane_b32 s1, v3
		v_accvgpr_read_b32 v3, a4
		s_nop 0
		v_readfirstlane_b32 s18, v3
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
		v_and_b32_e32 v2, 0xffff, v40
		v_lshrrev_b32_e32 v3, 16, v40
		v_and_b32_e32 v3, 0xffff, v3
		v_and_b32_e32 v32, 0xffff, v41
		v_lshrrev_b32_e32 v33, 16, v41
		v_and_b32_e32 v33, 0xffff, v33
		v_and_b32_e32 v34, 0xffff, v42
		v_lshrrev_b32_e32 v35, 16, v42
		v_and_b32_e32 v35, 0xffff, v35
		v_and_b32_e32 v36, 0xffff, v43
		v_lshrrev_b32_e32 v37, 16, v43
		v_and_b32_e32 v37, 0xffff, v37
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
		v_and_b32_e32 v38, 0xffff, v8
		v_lshrrev_b32_e32 v8, 16, v8
		v_and_b32_e32 v8, 0xffff, v8
		v_and_b32_e32 v39, 0xffff, v9
		v_lshrrev_b32_e32 v9, 16, v9
		v_and_b32_e32 v9, 0xffff, v9
		v_and_b32_e32 v40, 0xffff, v10
		v_lshrrev_b32_e32 v10, 16, v10
		v_and_b32_e32 v10, 0xffff, v10
		v_and_b32_e32 v41, 0xffff, v11
		v_lshrrev_b32_e32 v11, 16, v11
		v_and_b32_e32 v11, 0xffff, v11
		v_permlane32_swap_b32_e32 v12, v14
		v_permlane32_swap_b32_e32 v13, v15
		v_and_b32_e32 v42, 0xffff, v12
		v_lshrrev_b32_e32 v12, 16, v12
		v_and_b32_e32 v12, 0xffff, v12
		v_and_b32_e32 v43, 0xffff, v13
		v_lshrrev_b32_e32 v13, 16, v13
		v_and_b32_e32 v13, 0xffff, v13
		v_and_b32_e32 v44, 0xffff, v14
		v_lshrrev_b32_e32 v14, 16, v14
		v_and_b32_e32 v14, 0xffff, v14
		v_and_b32_e32 v45, 0xffff, v15
		v_lshrrev_b32_e32 v15, 16, v15
		v_and_b32_e32 v15, 0xffff, v15
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_and_b32_e32 v46, 0xffff, v16
		v_lshrrev_b32_e32 v16, 16, v16
		v_and_b32_e32 v16, 0xffff, v16
		v_and_b32_e32 v47, 0xffff, v17
		v_lshrrev_b32_e32 v17, 16, v17
		v_and_b32_e32 v17, 0xffff, v17
		v_and_b32_e32 v48, 0xffff, v18
		v_lshrrev_b32_e32 v18, 16, v18
		v_and_b32_e32 v18, 0xffff, v18
		v_and_b32_e32 v49, 0xffff, v19
		v_lshrrev_b32_e32 v19, 16, v19
		v_and_b32_e32 v19, 0xffff, v19
		v_permlane32_swap_b32_e32 v20, v22
		v_permlane32_swap_b32_e32 v21, v23
		v_and_b32_e32 v50, 0xffff, v20
		v_lshrrev_b32_e32 v20, 16, v20
		v_and_b32_e32 v20, 0xffff, v20
		v_and_b32_e32 v51, 0xffff, v21
		v_lshrrev_b32_e32 v21, 16, v21
		v_and_b32_e32 v21, 0xffff, v21
		v_and_b32_e32 v52, 0xffff, v22
		v_lshrrev_b32_e32 v22, 16, v22
		v_and_b32_e32 v22, 0xffff, v22
		v_and_b32_e32 v53, 0xffff, v23
		v_lshrrev_b32_e32 v23, 16, v23
		v_and_b32_e32 v23, 0xffff, v23
		v_permlane32_swap_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v5, v7
		v_and_b32_e32 v54, 0xffff, v4
		v_lshrrev_b32_e32 v4, 16, v4
		v_and_b32_e32 v4, 0xffff, v4
		v_and_b32_e32 v55, 0xffff, v5
		v_lshrrev_b32_e32 v5, 16, v5
		v_and_b32_e32 v5, 0xffff, v5
		v_and_b32_e32 v56, 0xffff, v6
		v_lshrrev_b32_e32 v6, 16, v6
		v_and_b32_e32 v6, 0xffff, v6
		v_and_b32_e32 v57, 0xffff, v7
		v_lshrrev_b32_e32 v7, 16, v7
		v_and_b32_e32 v7, 0xffff, v7
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_and_b32_e32 v58, 0xffff, v24
		v_lshrrev_b32_e32 v24, 16, v24
		v_and_b32_e32 v24, 0xffff, v24
		v_and_b32_e32 v59, 0xffff, v25
		v_lshrrev_b32_e32 v25, 16, v25
		v_and_b32_e32 v25, 0xffff, v25
		v_and_b32_e32 v60, 0xffff, v26
		v_lshrrev_b32_e32 v26, 16, v26
		v_and_b32_e32 v26, 0xffff, v26
		v_and_b32_e32 v61, 0xffff, v27
		v_lshrrev_b32_e32 v27, 16, v27
		v_and_b32_e32 v27, 0xffff, v27
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_and_b32_e32 v62, 0xffff, v28
		v_lshrrev_b32_e32 v28, 16, v28
		v_and_b32_e32 v28, 0xffff, v28
		v_and_b32_e32 v63, 0xffff, v29
		v_lshrrev_b32_e32 v29, 16, v29
		v_and_b32_e32 v29, 0xffff, v29
		v_and_b32_e32 v64, 0xffff, v30
		v_lshrrev_b32_e32 v30, 16, v30
		v_and_b32_e32 v30, 0xffff, v30
		v_and_b32_e32 v65, 0xffff, v31
		v_lshrrev_b32_e32 v31, 16, v31
		v_and_b32_e32 v31, 0xffff, v31
		s_lshl_b32 s1, s1, 9
		v_accvgpr_read_b32 v66, a2
		s_nop 0
		v_readfirstlane_b32 s18, v66
		v_accvgpr_read_b32 v66, a10
		s_nop 0
		v_readfirstlane_b32 s21, v66
		s_mul_i32 s18, s21, s18
		s_lshl_b32 s18, s18, 1
		s_add_i32 s21, s1, s18
		v_accvgpr_read_b32 v66, a3
		s_nop 0
		v_readfirstlane_b32 s22, v66
		v_accvgpr_read_b32 v66, a11
		s_nop 0
		v_readfirstlane_b32 s23, v66
		s_mul_i32 s22, s23, s22
		s_lshl_b32 s22, s22, 1
		s_add_i32 s21, s21, s22
		v_accvgpr_read_b32 v66, a13
		v_accvgpr_read_b32 v67, a4
		s_nop 0
		v_readfirstlane_b32 s23, v67
		s_nop 1
		v_mul_lo_u32 v66, s23, v66
		v_lshl_add_u32 v67, v66, 6, s21
		v_and_b32_e32 v68, 31, v0
		v_accvgpr_read_b32 v69, a4
		s_nop 0
		v_readfirstlane_b32 s21, v69
		s_nop 1
		v_mul_lo_u32 v68, s21, v68
		v_lshl_add_u32 v67, v68, 1, v67
		v_lshl_add_u32 v67, v1, 4, v67
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_64
		buffer_store_short v2, v67, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_64:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_64
.L_attn_fwd_persistent.exec_endif_64:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 2
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_65
		buffer_store_short v3, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_65:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_65
.L_attn_fwd_persistent.exec_endif_65:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 4
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_66
		buffer_store_short v32, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_66:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_66
.L_attn_fwd_persistent.exec_endif_66:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 6
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_67
		buffer_store_short v33, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_67:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_67
.L_attn_fwd_persistent.exec_endif_67:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 8
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_68
		buffer_store_short v34, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_68:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_68
.L_attn_fwd_persistent.exec_endif_68:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 10
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_69
		buffer_store_short v35, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_69:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_69
.L_attn_fwd_persistent.exec_endif_69:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 12
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_70
		buffer_store_short v36, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_70:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_70
.L_attn_fwd_persistent.exec_endif_70:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 14
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_71
		buffer_store_short v37, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_71:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_71
.L_attn_fwd_persistent.exec_endif_71:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 32
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_72
		buffer_store_short v38, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_72:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_72
.L_attn_fwd_persistent.exec_endif_72:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 34
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_73
		buffer_store_short v8, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_73:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_73
.L_attn_fwd_persistent.exec_endif_73:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 36
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_74
		buffer_store_short v39, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_74:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_74
.L_attn_fwd_persistent.exec_endif_74:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 38
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_75
		buffer_store_short v9, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_75:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_75
.L_attn_fwd_persistent.exec_endif_75:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 40
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_76
		buffer_store_short v40, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_76:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_76
.L_attn_fwd_persistent.exec_endif_76:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 42
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_77
		buffer_store_short v10, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_77:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_77
.L_attn_fwd_persistent.exec_endif_77:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 44
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_78
		buffer_store_short v41, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_78:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_78
.L_attn_fwd_persistent.exec_endif_78:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 46
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_79
		buffer_store_short v11, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_79:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_79
.L_attn_fwd_persistent.exec_endif_79:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 64
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_80
		buffer_store_short v42, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_80:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_80
.L_attn_fwd_persistent.exec_endif_80:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x42
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_81
		buffer_store_short v12, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_81:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_81
.L_attn_fwd_persistent.exec_endif_81:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x44
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_82
		buffer_store_short v43, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_82:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_82
.L_attn_fwd_persistent.exec_endif_82:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x46
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_83
		buffer_store_short v13, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_83:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_83
.L_attn_fwd_persistent.exec_endif_83:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x48
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_84
		buffer_store_short v44, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_84:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_84
.L_attn_fwd_persistent.exec_endif_84:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x4a
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_85
		buffer_store_short v14, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_85:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_85
.L_attn_fwd_persistent.exec_endif_85:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x4c
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_86
		buffer_store_short v45, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_86:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_86
.L_attn_fwd_persistent.exec_endif_86:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x4e
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_87
		buffer_store_short v15, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_87:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_87
.L_attn_fwd_persistent.exec_endif_87:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x60
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_88
		buffer_store_short v46, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_88:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_88
.L_attn_fwd_persistent.exec_endif_88:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x62
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_89
		buffer_store_short v16, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_89:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_89
.L_attn_fwd_persistent.exec_endif_89:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x64
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_90
		buffer_store_short v47, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_90:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_90
.L_attn_fwd_persistent.exec_endif_90:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x66
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_91
		buffer_store_short v17, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_91:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_91
.L_attn_fwd_persistent.exec_endif_91:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x68
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_92
		buffer_store_short v48, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_92:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_92
.L_attn_fwd_persistent.exec_endif_92:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x6a
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_93
		buffer_store_short v18, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_93:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_93
.L_attn_fwd_persistent.exec_endif_93:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x6c
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_94
		buffer_store_short v49, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_94:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_94
.L_attn_fwd_persistent.exec_endif_94:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x6e
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_95
		buffer_store_short v19, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_95:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_95
.L_attn_fwd_persistent.exec_endif_95:
		s_mov_b64 exec, s[96:97]
		v_accvgpr_read_b32 v2, a4
		s_nop 0
		v_readfirstlane_b32 s21, v2
		s_lshl_b32 s21, s21, 8
		s_add_i32 s23, s21, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_96
		buffer_store_short v50, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_96:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_96
.L_attn_fwd_persistent.exec_endif_96:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 2
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_97
		buffer_store_short v20, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_97:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_97
.L_attn_fwd_persistent.exec_endif_97:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 4
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_98
		buffer_store_short v51, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_98:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_98
.L_attn_fwd_persistent.exec_endif_98:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 6
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_99
		buffer_store_short v21, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_99:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_99
.L_attn_fwd_persistent.exec_endif_99:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 8
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_100
		buffer_store_short v52, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_100:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_100
.L_attn_fwd_persistent.exec_endif_100:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 10
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_101
		buffer_store_short v22, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_101:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_101
.L_attn_fwd_persistent.exec_endif_101:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 12
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_102
		buffer_store_short v53, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_102:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_102
.L_attn_fwd_persistent.exec_endif_102:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 14
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_103
		buffer_store_short v23, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_103:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_103
.L_attn_fwd_persistent.exec_endif_103:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 32
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_104
		buffer_store_short v54, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_104:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_104
.L_attn_fwd_persistent.exec_endif_104:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 34
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_105
		buffer_store_short v4, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_105:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_105
.L_attn_fwd_persistent.exec_endif_105:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 36
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_106
		buffer_store_short v55, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_106:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_106
.L_attn_fwd_persistent.exec_endif_106:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 38
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_107
		buffer_store_short v5, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_107:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_107
.L_attn_fwd_persistent.exec_endif_107:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 40
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_108
		buffer_store_short v56, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_108:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_108
.L_attn_fwd_persistent.exec_endif_108:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 42
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_109
		buffer_store_short v6, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_109:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_109
.L_attn_fwd_persistent.exec_endif_109:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 44
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_110
		buffer_store_short v57, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_110:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_110
.L_attn_fwd_persistent.exec_endif_110:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 46
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_111
		buffer_store_short v7, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_111:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_111
.L_attn_fwd_persistent.exec_endif_111:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 64
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_112
		buffer_store_short v58, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_112:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_112
.L_attn_fwd_persistent.exec_endif_112:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 0x42
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_113
		buffer_store_short v24, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_113:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_113
.L_attn_fwd_persistent.exec_endif_113:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 0x44
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_114
		buffer_store_short v59, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_114:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_114
.L_attn_fwd_persistent.exec_endif_114:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 0x46
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_115
		buffer_store_short v25, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_115:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_115
.L_attn_fwd_persistent.exec_endif_115:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 0x48
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_116
		buffer_store_short v60, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_116:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_116
.L_attn_fwd_persistent.exec_endif_116:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 0x4a
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_117
		buffer_store_short v26, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_117:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_117
.L_attn_fwd_persistent.exec_endif_117:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 0x4c
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_118
		buffer_store_short v61, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_118:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_118
.L_attn_fwd_persistent.exec_endif_118:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 0x4e
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_119
		buffer_store_short v27, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_119:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_119
.L_attn_fwd_persistent.exec_endif_119:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 0x60
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_120
		buffer_store_short v62, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_120:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_120
.L_attn_fwd_persistent.exec_endif_120:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 0x62
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_121
		buffer_store_short v28, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_121:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_121
.L_attn_fwd_persistent.exec_endif_121:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 0x64
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_122
		buffer_store_short v63, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_122:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_122
.L_attn_fwd_persistent.exec_endif_122:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 0x66
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_123
		buffer_store_short v29, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_123:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_123
.L_attn_fwd_persistent.exec_endif_123:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 0x68
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_124
		buffer_store_short v64, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_124:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_124
.L_attn_fwd_persistent.exec_endif_124:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 0x6a
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_125
		buffer_store_short v30, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_125:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_125
.L_attn_fwd_persistent.exec_endif_125:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 0x6c
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_126
		buffer_store_short v65, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_126:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_126
.L_attn_fwd_persistent.exec_endif_126:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s21, 0x6e
		s_add_i32 s1, s21, s1
		s_add_i32 s1, s1, s18
		s_add_i32 s1, s1, s22
		v_lshl_add_u32 v2, v66, 6, s1
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v1, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_127
		buffer_store_short v31, v1, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_127:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_127
.L_attn_fwd_persistent.exec_endif_127:
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
		v_accvgpr_write_b32 a12, v1
		v_accvgpr_read_b32 v1, a12
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
		v_accvgpr_write_b32 a13, v12
		v_accvgpr_read_b32 v12, a13
		v_and_b32_e32 v12, 1, v12
		v_mov_b32_e32 v13, 32
		v_mul_lo_u32 v13, v13, v12
		v_bitop3_b32 v4, v4, v11, v13 bitop3:0x96
		v_lshrrev_b32_e32 v14, 7, v0
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 64
		v_mul_lo_u32 v15, v15, v14
		v_xor_b32_e32 v4, v4, v15
		v_accvgpr_write_b32 a14, v4
		v_xor_b32_e32 v1, 0x80, v1
		v_xor_b32_e32 v1, v1, v3
		v_xor_b32_e32 v1, v1, v5
		v_bitop3_b32 v1, v1, v8, v11 bitop3:0x96
		v_bitop3_b32 v1, v1, v13, v15 bitop3:0x96
		v_accvgpr_write_b32 a15, v1
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
		v_cmp_lt_i32_e64 s[36:37], v1, s19
		s_mov_b32 s42, 0x7fffffff
		s_mov_b32 s43, 0x31016000
		s_mov_b32 s40, s2
		s_mov_b32 s41, s3
		v_accvgpr_read_b32 v1, a12
		s_nop 0
		v_readfirstlane_b32 s18, v1
		s_mul_i32 s18, s18, s12
		s_lshl_b32 s18, s18, 9
		v_accvgpr_read_b32 v1, a10
		s_nop 0
		v_readfirstlane_b32 s21, v1
		s_mul_i32 s21, s21, s10
		s_lshl_b32 s21, s21, 1
		s_add_i32 s38, s18, s21
		v_accvgpr_read_b32 v1, a11
		s_nop 0
		v_readfirstlane_b32 s39, v1
		s_mul_i32 s39, s39, s11
		s_lshl_b32 s39, s39, 1
		s_add_i32 s38, s38, s39
		v_mul_lo_u32 v1, s12, v6
		v_lshl_add_u32 v8, v1, 1, s38
		v_and_b32_e32 v11, 7, v0
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_128
		buffer_load_ushort v13, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_128:
		s_andn2_b64 exec, s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_128
		v_mov_b32_e32 v13, 0
.L_attn_fwd_persistent.exec_endif_128:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s38, s18, 2
		s_add_i32 s38, s38, s21
		s_add_i32 s38, s38, s39
		v_lshl_add_u32 v8, v1, 1, s38
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_129
		buffer_load_ushort v15, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_129:
		s_andn2_b64 exec, s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_129
		v_mov_b32_e32 v15, 0
.L_attn_fwd_persistent.exec_endif_129:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s38, s18, 4
		s_add_i32 s38, s38, s21
		s_add_i32 s38, s38, s39
		v_lshl_add_u32 v8, v1, 1, s38
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_130
		buffer_load_ushort v16, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_130:
		s_andn2_b64 exec, s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_130
		v_mov_b32_e32 v16, 0
.L_attn_fwd_persistent.exec_endif_130:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s38, s18, 6
		s_add_i32 s38, s38, s21
		s_add_i32 s38, s38, s39
		v_lshl_add_u32 v8, v1, 1, s38
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_131
		buffer_load_ushort v17, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_131:
		s_andn2_b64 exec, s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_131
		v_mov_b32_e32 v17, 0
.L_attn_fwd_persistent.exec_endif_131:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s38, s18, 8
		s_add_i32 s38, s38, s21
		s_add_i32 s38, s38, s39
		v_lshl_add_u32 v8, v1, 1, s38
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_132
		buffer_load_ushort v18, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_132:
		s_andn2_b64 exec, s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_132
		v_mov_b32_e32 v18, 0
.L_attn_fwd_persistent.exec_endif_132:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s38, s18, 10
		s_add_i32 s38, s38, s21
		s_add_i32 s38, s38, s39
		v_lshl_add_u32 v8, v1, 1, s38
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_133
		buffer_load_ushort v19, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_133:
		s_andn2_b64 exec, s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_133
		v_mov_b32_e32 v19, 0
.L_attn_fwd_persistent.exec_endif_133:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s38, s18, 12
		s_add_i32 s38, s38, s21
		s_add_i32 s38, s38, s39
		v_lshl_add_u32 v8, v1, 1, s38
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_134
		buffer_load_ushort v20, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_134:
		s_andn2_b64 exec, s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_134
		v_mov_b32_e32 v20, 0
.L_attn_fwd_persistent.exec_endif_134:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s38, s18, 14
		s_add_i32 s38, s38, s21
		s_add_i32 s38, s38, s39
		v_lshl_add_u32 v8, v1, 1, s38
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_135
		buffer_load_ushort v21, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_135:
		s_andn2_b64 exec, s[96:97], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_135
		v_mov_b32_e32 v21, 0
.L_attn_fwd_persistent.exec_endif_135:
		s_mov_b64 exec, s[96:97]
		s_lshl_b32 s22, s12, 6
		s_add_i32 s23, s22, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_136
		buffer_load_ushort v22, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_136:
		s_andn2_b64 exec, s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_136
		v_mov_b32_e32 v22, 0
.L_attn_fwd_persistent.exec_endif_136:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 2
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_137
		buffer_load_ushort v23, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_137:
		s_andn2_b64 exec, s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_137
		v_mov_b32_e32 v23, 0
.L_attn_fwd_persistent.exec_endif_137:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 4
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_138
		buffer_load_ushort v24, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_138:
		s_andn2_b64 exec, s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_138
		v_mov_b32_e32 v24, 0
.L_attn_fwd_persistent.exec_endif_138:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 6
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_139
		buffer_load_ushort v25, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_139:
		s_andn2_b64 exec, s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_139
		v_mov_b32_e32 v25, 0
.L_attn_fwd_persistent.exec_endif_139:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 8
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_140
		buffer_load_ushort v26, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_140:
		s_andn2_b64 exec, s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_140
		v_mov_b32_e32 v26, 0
.L_attn_fwd_persistent.exec_endif_140:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 10
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_141
		buffer_load_ushort v27, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_141:
		s_andn2_b64 exec, s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_141
		v_mov_b32_e32 v27, 0
.L_attn_fwd_persistent.exec_endif_141:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 12
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_142
		buffer_load_ushort v28, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_142:
		s_andn2_b64 exec, s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_142
		v_mov_b32_e32 v28, 0
.L_attn_fwd_persistent.exec_endif_142:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s22, s22, 14
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s39
		v_lshl_add_u32 v8, v1, 1, s22
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_143
		buffer_load_ushort v29, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_143:
		s_andn2_b64 exec, s[96:97], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_143
		v_mov_b32_e32 v29, 0
.L_attn_fwd_persistent.exec_endif_143:
		s_mov_b64 exec, s[96:97]
		s_lshl_b32 s22, s12, 7
		s_add_i32 s23, s22, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_144
		buffer_load_ushort v30, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_144:
		s_andn2_b64 exec, s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_144
		v_mov_b32_e32 v30, 0
.L_attn_fwd_persistent.exec_endif_144:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 2
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_145
		buffer_load_ushort v31, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_145:
		s_andn2_b64 exec, s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_145
		v_mov_b32_e32 v31, 0
.L_attn_fwd_persistent.exec_endif_145:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 4
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_146
		buffer_load_ushort v32, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_146:
		s_andn2_b64 exec, s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_146
		v_mov_b32_e32 v32, 0
.L_attn_fwd_persistent.exec_endif_146:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 6
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_147
		buffer_load_ushort v33, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_147:
		s_andn2_b64 exec, s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_147
		v_mov_b32_e32 v33, 0
.L_attn_fwd_persistent.exec_endif_147:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 8
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_148
		buffer_load_ushort v34, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_148:
		s_andn2_b64 exec, s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_148
		v_mov_b32_e32 v34, 0
.L_attn_fwd_persistent.exec_endif_148:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 10
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_149
		buffer_load_ushort v35, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_149:
		s_andn2_b64 exec, s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_149
		v_mov_b32_e32 v35, 0
.L_attn_fwd_persistent.exec_endif_149:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 12
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_150
		buffer_load_ushort v36, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_150:
		s_andn2_b64 exec, s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_150
		v_mov_b32_e32 v36, 0
.L_attn_fwd_persistent.exec_endif_150:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s22, s22, 14
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s39
		v_lshl_add_u32 v8, v1, 1, s22
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_151
		buffer_load_ushort v37, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_151:
		s_andn2_b64 exec, s[96:97], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_151
		v_mov_b32_e32 v37, 0
.L_attn_fwd_persistent.exec_endif_151:
		s_mov_b64 exec, s[96:97]
		s_mul_i32 s22, 0xc0, s12
		s_add_i32 s23, s22, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_152
		buffer_load_ushort v38, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_152:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_152
		v_mov_b32_e32 v38, 0
.L_attn_fwd_persistent.exec_endif_152:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 2
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_153
		buffer_load_ushort v39, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_153:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_153
		v_mov_b32_e32 v39, 0
.L_attn_fwd_persistent.exec_endif_153:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 4
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_154
		buffer_load_ushort v40, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_154:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_154
		v_mov_b32_e32 v40, 0
.L_attn_fwd_persistent.exec_endif_154:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 6
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_155
		buffer_load_ushort v41, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_155:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_155
		v_mov_b32_e32 v41, 0
.L_attn_fwd_persistent.exec_endif_155:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 8
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_156
		buffer_load_ushort v42, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_156:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_156
		v_mov_b32_e32 v42, 0
.L_attn_fwd_persistent.exec_endif_156:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 10
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_157
		buffer_load_ushort v43, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_157:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_157
		v_mov_b32_e32 v43, 0
.L_attn_fwd_persistent.exec_endif_157:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 12
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_158
		buffer_load_ushort v44, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_158:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_158
		v_mov_b32_e32 v44, 0
.L_attn_fwd_persistent.exec_endif_158:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s22, s22, 14
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s39
		v_lshl_add_u32 v8, v1, 1, s22
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_159
		buffer_load_ushort v45, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_159:
		s_andn2_b64 exec, s[96:97], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_159
		v_mov_b32_e32 v45, 0
.L_attn_fwd_persistent.exec_endif_159:
		s_mov_b64 exec, s[96:97]
		s_lshl_b32 s22, s12, 8
		s_add_i32 s23, s22, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_160
		buffer_load_ushort v46, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_160:
		s_andn2_b64 exec, s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_160
		v_mov_b32_e32 v46, 0
.L_attn_fwd_persistent.exec_endif_160:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 2
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_161
		buffer_load_ushort v47, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_161:
		s_andn2_b64 exec, s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_161
		v_mov_b32_e32 v47, 0
.L_attn_fwd_persistent.exec_endif_161:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 4
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_162
		buffer_load_ushort v48, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_162:
		s_andn2_b64 exec, s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_162
		v_mov_b32_e32 v48, 0
.L_attn_fwd_persistent.exec_endif_162:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 6
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_163
		buffer_load_ushort v49, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_163:
		s_andn2_b64 exec, s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_163
		v_mov_b32_e32 v49, 0
.L_attn_fwd_persistent.exec_endif_163:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 8
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_164
		buffer_load_ushort v50, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_164:
		s_andn2_b64 exec, s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_164
		v_mov_b32_e32 v50, 0
.L_attn_fwd_persistent.exec_endif_164:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 10
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_165
		buffer_load_ushort v51, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_165:
		s_andn2_b64 exec, s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_165
		v_mov_b32_e32 v51, 0
.L_attn_fwd_persistent.exec_endif_165:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 12
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_166
		buffer_load_ushort v52, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_166:
		s_andn2_b64 exec, s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_166
		v_mov_b32_e32 v52, 0
.L_attn_fwd_persistent.exec_endif_166:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s22, s22, 14
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s39
		v_lshl_add_u32 v8, v1, 1, s22
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_167
		buffer_load_ushort v53, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_167:
		s_andn2_b64 exec, s[96:97], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_167
		v_mov_b32_e32 v53, 0
.L_attn_fwd_persistent.exec_endif_167:
		s_mov_b64 exec, s[96:97]
		s_mul_i32 s22, 0x140, s12
		s_add_i32 s23, s22, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_168
		buffer_load_ushort v54, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_168:
		s_andn2_b64 exec, s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_168
		v_mov_b32_e32 v54, 0
.L_attn_fwd_persistent.exec_endif_168:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 2
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_169
		buffer_load_ushort v55, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_169:
		s_andn2_b64 exec, s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_169
		v_mov_b32_e32 v55, 0
.L_attn_fwd_persistent.exec_endif_169:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 4
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_170
		buffer_load_ushort v56, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_170:
		s_andn2_b64 exec, s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_170
		v_mov_b32_e32 v56, 0
.L_attn_fwd_persistent.exec_endif_170:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 6
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_171
		buffer_load_ushort v57, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_171:
		s_andn2_b64 exec, s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_171
		v_mov_b32_e32 v57, 0
.L_attn_fwd_persistent.exec_endif_171:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 8
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_172
		buffer_load_ushort v58, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_172:
		s_andn2_b64 exec, s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_172
		v_mov_b32_e32 v58, 0
.L_attn_fwd_persistent.exec_endif_172:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 10
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_173
		buffer_load_ushort v59, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_173:
		s_andn2_b64 exec, s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_173
		v_mov_b32_e32 v59, 0
.L_attn_fwd_persistent.exec_endif_173:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 12
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_174
		buffer_load_ushort v60, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_174:
		s_andn2_b64 exec, s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_174
		v_mov_b32_e32 v60, 0
.L_attn_fwd_persistent.exec_endif_174:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s22, s22, 14
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s39
		v_lshl_add_u32 v8, v1, 1, s22
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_175
		buffer_load_ushort v61, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_175:
		s_andn2_b64 exec, s[96:97], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_175
		v_mov_b32_e32 v61, 0
.L_attn_fwd_persistent.exec_endif_175:
		s_mov_b64 exec, s[96:97]
		s_mul_i32 s22, 0x180, s12
		s_add_i32 s23, s22, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_176
		buffer_load_ushort v62, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_176:
		s_andn2_b64 exec, s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_176
		v_mov_b32_e32 v62, 0
.L_attn_fwd_persistent.exec_endif_176:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 2
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_177
		buffer_load_ushort v63, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_177:
		s_andn2_b64 exec, s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_177
		v_mov_b32_e32 v63, 0
.L_attn_fwd_persistent.exec_endif_177:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 4
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_178
		buffer_load_ushort v64, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_178:
		s_andn2_b64 exec, s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_178
		v_mov_b32_e32 v64, 0
.L_attn_fwd_persistent.exec_endif_178:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 6
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_179
		buffer_load_ushort v65, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_179:
		s_andn2_b64 exec, s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_179
		v_mov_b32_e32 v65, 0
.L_attn_fwd_persistent.exec_endif_179:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 8
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_180
		buffer_load_ushort v66, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_180:
		s_andn2_b64 exec, s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_180
		v_mov_b32_e32 v66, 0
.L_attn_fwd_persistent.exec_endif_180:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 10
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_181
		buffer_load_ushort v67, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_181:
		s_andn2_b64 exec, s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_181
		v_mov_b32_e32 v67, 0
.L_attn_fwd_persistent.exec_endif_181:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 12
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_182
		buffer_load_ushort v68, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_182:
		s_andn2_b64 exec, s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_182
		v_mov_b32_e32 v68, 0
.L_attn_fwd_persistent.exec_endif_182:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s22, s22, 14
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s39
		v_lshl_add_u32 v8, v1, 1, s22
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_183
		buffer_load_ushort v69, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_183:
		s_andn2_b64 exec, s[96:97], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_183
		v_mov_b32_e32 v69, 0
.L_attn_fwd_persistent.exec_endif_183:
		s_mov_b64 exec, s[96:97]
		s_mul_i32 s22, 0x1c0, s12
		s_add_i32 s23, s22, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_184
		buffer_load_ushort v70, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_184:
		s_andn2_b64 exec, s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_184
		v_mov_b32_e32 v70, 0
.L_attn_fwd_persistent.exec_endif_184:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 2
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_185
		buffer_load_ushort v71, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_185:
		s_andn2_b64 exec, s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_185
		v_mov_b32_e32 v71, 0
.L_attn_fwd_persistent.exec_endif_185:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 4
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_186
		buffer_load_ushort v72, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_186:
		s_andn2_b64 exec, s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_186
		v_mov_b32_e32 v72, 0
.L_attn_fwd_persistent.exec_endif_186:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 6
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_187
		buffer_load_ushort v73, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_187:
		s_andn2_b64 exec, s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_187
		v_mov_b32_e32 v73, 0
.L_attn_fwd_persistent.exec_endif_187:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 8
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_188
		buffer_load_ushort v74, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_188:
		s_andn2_b64 exec, s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_188
		v_mov_b32_e32 v74, 0
.L_attn_fwd_persistent.exec_endif_188:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 10
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_189
		buffer_load_ushort v75, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_189:
		s_andn2_b64 exec, s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_189
		v_mov_b32_e32 v75, 0
.L_attn_fwd_persistent.exec_endif_189:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s22, 12
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s39
		v_lshl_add_u32 v8, v1, 1, s23
		v_lshl_add_u32 v8, v11, 4, v8
		s_and_saveexec_b64 s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_190
		buffer_load_ushort v76, v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_190:
		s_andn2_b64 exec, s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_190
		v_mov_b32_e32 v76, 0
.L_attn_fwd_persistent.exec_endif_190:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s22, s22, 14
		s_add_i32 s18, s22, s18
		s_add_i32 s18, s18, s21
		s_add_i32 s18, s18, s39
		v_lshl_add_u32 v1, v1, 1, s18
		v_lshl_add_u32 v1, v11, 4, v1
		s_and_saveexec_b64 s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_191
		buffer_load_ushort v8, v1, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_191:
		s_andn2_b64 exec, s[96:97], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_191
		v_mov_b32_e32 v8, 0
.L_attn_fwd_persistent.exec_endif_191:
		s_mov_b64 exec, s[96:97]
		s_mov_b32 s24, s4
		s_mov_b32 s25, s5
		s_mov_b32 s26, s42
		s_mov_b32 s27, s43
		s_mov_b32 s28, s6
		s_mov_b32 s29, s7
		s_mov_b32 s30, s42
		s_mov_b32 s31, s43
		s_waitcnt vmcnt(0)
		s_barrier
		s_mov_b32 s18, 0x5040100
		v_perm_b32 v80, v15, v13, s18
		v_perm_b32 v81, v17, v16, s18
		v_perm_b32 v82, v19, v18, s18
		v_perm_b32 v83, v21, v20, s18
		v_perm_b32 v16, v23, v22, s18
		v_perm_b32 v17, v25, v24, s18
		v_perm_b32 v18, v27, v26, s18
		v_perm_b32 v19, v29, v28, s18
		v_perm_b32 v20, v31, v30, s18
		v_perm_b32 v21, v33, v32, s18
		v_perm_b32 v22, v35, v34, s18
		v_perm_b32 v23, v37, v36, s18
		v_perm_b32 v24, v39, v38, s18
		v_perm_b32 v25, v41, v40, s18
		v_perm_b32 v26, v43, v42, s18
		v_perm_b32 v27, v45, v44, s18
		v_perm_b32 v28, v47, v46, s18
		v_perm_b32 v29, v49, v48, s18
		v_perm_b32 v30, v51, v50, s18
		v_perm_b32 v31, v53, v52, s18
		v_perm_b32 v32, v55, v54, s18
		v_perm_b32 v33, v57, v56, s18
		v_perm_b32 v34, v59, v58, s18
		v_perm_b32 v35, v61, v60, s18
		v_perm_b32 v36, v63, v62, s18
		v_perm_b32 v37, v65, v64, s18
		v_perm_b32 v38, v67, v66, s18
		v_perm_b32 v39, v69, v68, s18
		v_perm_b32 v40, v71, v70, s18
		v_perm_b32 v41, v73, v72, s18
		v_perm_b32 v42, v75, v74, s18
		v_perm_b32 v43, v8, v76, s18
		v_and_b32_e32 v1, 1, v3
		v_lshlrev_b32_e32 v3, 1, v1
		v_accvgpr_read_b32 v8, a13
		v_and_b32_e32 v8, 1, v8
		v_lshlrev_b32_e32 v8, 2, v8
		v_and_b32_e32 v9, 1, v9
		v_accvgpr_write_b32 a16, v9
		v_accvgpr_read_b32 v9, a16
		v_xor_b32_e32 v8, v8, v9
		v_bitop3_b32 v3, v0, v3, v8 bitop3:0x96
		v_lshlrev_b32_e32 v3, 4, v3
		v_add_u32_e32 v3, 0x10000, v3
		ds_write_b128 v3, v[80:83] offset:18864
		ds_write_b128 v3, v[16:19] offset:22960
		ds_write_b128 v3, v[20:23] offset:27056
		ds_write_b128 v3, v[24:27] offset:31152
		v_mov_b32_e32 v8, 32
		v_mul_lo_u32 v8, v8, v10
		v_mov_b32_e32 v9, 2
		v_mul_lo_u32 v9, v9, v14
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v10, a13
		v_lshlrev_b32_e32 v10, 12, v10
		v_add_u32_e32 v10, 0x10000, v10
		v_and_b32_e32 v13, 63, v0
		v_and_b32_e32 v14, 7, v13
		v_lshrrev_b32_e32 v15, 2, v14
		v_lshl_add_u32 v16, v15, 5, v10
		v_lshrrev_b32_e32 v17, 3, v13
		v_bitop3_b32 v17, v17, 3, 1 bitop3:0x80
		v_lshl_add_u32 v18, v17, 6, v16
		v_lshrrev_b32_e32 v19, 5, v13
		v_and_b32_e32 v13, 31, v13
		v_lshlrev_b32_e32 v20, 3, v13
		v_add_u32_e32 v21, v19, v20
		v_lshrrev_b32_e32 v14, 1, v14
		v_and_b32_e32 v14, 1, v14
		v_xor_b32_e32 v21, v21, v14
		v_lshl_add_u32 v18, v21, 4, v18
		ds_read_b128 a[20:23], v18 offset:18864
		v_lshl_add_u32 v21, v17, 6, v10
		v_add3_u32 v22, 2, v19, v20
		v_lshlrev_b32_e32 v15, 1, v15
		v_bitop3_b32 v22, v22, v15, v14 bitop3:0x96
		v_lshl_add_u32 v21, v22, 4, v21
		ds_read_b128 a[24:27], v21 offset:18864
		v_add3_u32 v22, 4, v19, v20
		v_lshlrev_b32_e32 v17, 2, v17
		v_xor_b32_e32 v14, v17, v14
		v_xor_b32_e32 v17, v22, v14
		v_lshl_add_u32 v16, v17, 4, v16
		ds_read_b128 a[28:31], v16 offset:18864
		v_add3_u32 v17, 6, v19, v20
		v_bitop3_b32 v14, v17, v15, v14 bitop3:0x96
		v_lshl_add_u32 v10, v14, 4, v10
		ds_read_b128 a[32:35], v10 offset:18864
		v_and_b32_e32 v6, 1, v6
		v_lshlrev_b32_e32 v11, 4, v11
		v_and_b32_e32 v2, 1, v2
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v3, v[28:31] offset:18864
		ds_write_b128 v3, v[32:35] offset:22960
		ds_write_b128 v3, v[36:39] offset:27056
		ds_write_b128 v3, v[40:43] offset:31152
		v_accvgpr_read_b32 v3, a12
		s_nop 0
		v_readfirstlane_b32 s18, v3
		s_add_i32 s18, s18, 1
		s_mul_i32 s18, s18, 0x100
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[36:39], v18 offset:18864
		ds_read_b128 a[40:43], v21 offset:18864
		ds_read_b128 a[44:47], v16 offset:18864
		ds_read_b128 a[48:51], v10 offset:18864
		v_accvgpr_read_b32 v3, a6
		s_nop 0
		v_readfirstlane_b32 s21, v3
		s_add_i32 s18, s18, s21
		s_cmp_lt_i32 s20, s18
		s_cselect_b32 s18, s20, s18
		s_add_i32 s21, s18, 0x7f
		s_mov_b32 s22, 0x7f
		s_cmp_lt_i32 s21, 0
		s_cselect_b32 s23, s22, 0
		s_add_i32 s21, s21, s23
		s_ashr_i32 s21, s21, 7
		v_accvgpr_read_b32 v3, a6
		s_nop 0
		v_readfirstlane_b32 s23, v3
		s_add_i32 s23, s1, s23
		s_cmp_lt_i32 s23, 0
		s_cselect_b32 s32, s22, 0
		s_add_i32 s23, s23, s32
		s_ashr_i32 s23, s23, 7
		s_cmp_lt_i32 s23, s21
		s_cselect_b32 s23, s23, s21
		s_cmp_gt_i32 s23, 0
		s_cselect_b32 s23, s23, 0
		v_mov_b32_e32 v3, 64
		v_mul_lo_u32 v3, v3, v7
		v_mov_b32_e32 v10, 16
		v_mul_lo_u32 v10, v10, v4
		v_bitop3_b32 v14, v3, v8, v10 bitop3:0x96
		v_bitop3_b32 v14, v14, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a17, v14
		v_bitop3_b32 v14, 4, v3, v8 bitop3:0x96
		v_xor_b32_e32 v14, v14, v10
		v_bitop3_b32 v15, 8, v3, v8 bitop3:0x96
		v_xor_b32_e32 v15, v15, v10
		v_bitop3_b32 v3, 12, v3, v8 bitop3:0x96
		v_accvgpr_read_b32 v16, a17
		v_cmp_lt_i32_e64 s[32:33], v16, s20
		v_mov_b32_e32 v16, 16
		v_mul_lo_u32 v16, v16, v7
		v_mov_b32_e32 v7, 64
		v_mul_lo_u32 v7, v7, v4
		v_bitop3_b32 v4, v16, v8, v7 bitop3:0x96
		v_bitop3_b32 v4, v4, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a18, v4
		v_bitop3_b32 v4, 4, v16, v8 bitop3:0x96
		v_bitop3_b32 v17, 8, v16, v8 bitop3:0x96
		v_bitop3_b32 v8, 12, v16, v8 bitop3:0x96
		v_accvgpr_read_b32 v16, a18
		v_cmp_lt_i32_e64 vcc, v16, s20
		v_readfirstlane_b32 s34, v0
		v_accvgpr_read_b32 v16, a10
		s_nop 0
		v_readfirstlane_b32 s35, v16
		s_mul_i32 s35, s35, s13
		s_lshl_b32 s35, s35, 1
		v_accvgpr_read_b32 v16, a11
		s_nop 0
		v_readfirstlane_b32 s36, v16
		s_mul_i32 s36, s36, s14
		s_lshl_b32 s36, s36, 1
		s_add_i32 s37, s35, s36
		v_accvgpr_read_b32 v16, a13
		v_mul_lo_u32 v16, s15, v16
		v_lshlrev_b32_e32 v16, 1, v16
		v_add_u32_e32 v18, s37, v16
		v_mul_lo_u32 v20, s15, v1
		v_lshlrev_b32_e32 v20, 5, v20
		v_accvgpr_read_b32 v21, a16
		v_mul_lo_u32 v21, s15, v21
		v_lshlrev_b32_e32 v21, 6, v21
		v_add3_u32 v18, v18, v20, v21
		v_mul_lo_u32 v22, s15, v6
		v_lshlrev_b32_e32 v22, 7, v22
		v_add3_u32 v18, v18, v22, v11
		v_mov_b32_e32 v23, 0x80000000
		v_cndmask_b32_e64 v18, v23, v18, s[32:33]
		s_lshr_b32 s37, s34, 6
		s_mul_i32 s38, 0x410, s37
		s_mov_b32 m0, s38
		v_accvgpr_read_b32 v24, a14
		v_add_u32_e32 v24, s1, v24
		buffer_load_dwordx4 v18, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[40:41], v24, s19
		s_lshl_b32 s39, s15, 3
		s_add_i32 s39, s39, s35
		s_add_i32 s39, s39, s36
		v_add_u32_e32 v18, s39, v16
		v_add3_u32 v18, v18, v20, v21
		v_add3_u32 v18, v18, v22, v11
		v_cndmask_b32_e64 v18, v23, v18, s[32:33]
		s_add_i32 m0, m0, 0x1040
		v_accvgpr_read_b32 v24, a15
		v_add_u32_e32 v24, s1, v24
		buffer_load_dwordx4 v18, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[44:45], v24, s19
		s_lshl_b32 s39, s15, 4
		s_add_i32 s39, s39, s35
		s_add_i32 s39, s39, s36
		v_add_u32_e32 v18, s39, v16
		v_add3_u32 v18, v18, v20, v21
		v_add3_u32 v18, v18, v22, v11
		v_cndmask_b32_e64 v18, v23, v18, s[32:33]
		s_add_i32 m0, m0, 0x1040
		v_lshlrev_b32_e32 v19, 4, v19
		v_accvgpr_write_b32 a19, v19
		buffer_load_dwordx4 v18, s[24:27], 0 offen lds
		v_bitop3_b32 v14, v14, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a52, v14
		s_mul_i32 s39, 24, s15
		s_add_i32 s39, s39, s35
		s_add_i32 s39, s39, s36
		v_add_u32_e32 v14, s39, v16
		v_add3_u32 v14, v14, v20, v21
		v_add3_u32 v14, v14, v22, v11
		v_cndmask_b32_e64 v14, v23, v14, s[32:33]
		s_add_i32 m0, m0, 0x1040
		v_mov_b32_e32 v18, 0x440
		v_mul_lo_u32 v18, v18, v2
		v_accvgpr_write_b32 a53, v18
		buffer_load_dwordx4 v14, s[24:27], 0 offen lds
		v_bitop3_b32 v2, v15, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a54, v2
		v_accvgpr_read_b32 v2, a0
		s_nop 0
		v_readfirstlane_b32 s32, v2
		v_accvgpr_read_b32 v2, a10
		s_nop 0
		v_readfirstlane_b32 s33, v2
		s_mul_i32 s32, s33, s32
		s_lshl_b32 s32, s32, 1
		v_accvgpr_read_b32 v2, a1
		s_nop 0
		v_readfirstlane_b32 s33, v2
		v_accvgpr_read_b32 v2, a11
		s_nop 0
		v_readfirstlane_b32 s39, v2
		s_mul_i32 s33, s39, s33
		s_lshl_b32 s33, s33, 1
		s_add_i32 s39, s32, s33
		v_accvgpr_read_b32 v2, a13
		v_mul_lo_u32 v2, s17, v2
		v_lshlrev_b32_e32 v2, 1, v2
		v_add_u32_e32 v14, s39, v2
		v_mul_lo_u32 v15, s17, v1
		v_lshlrev_b32_e32 v15, 7, v15
		v_accvgpr_read_b32 v18, a16
		v_mul_lo_u32 v18, s17, v18
		v_lshlrev_b32_e32 v18, 6, v18
		v_add3_u32 v14, v14, v15, v18
		v_mul_lo_u32 v19, s17, v6
		v_lshlrev_b32_e32 v19, 5, v19
		v_add3_u32 v14, v14, v19, v11
		v_cndmask_b32_e32 v14, v23, v14, vcc
		s_mul_i32 s37, 0x440, s37
		s_add_i32 m0, s37, 0x81f0
		v_xor_b32_e32 v3, v3, v10
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		v_bitop3_b32 v3, v3, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a55, v3
		s_lshl_b32 s39, s17, 3
		s_add_i32 s39, s39, s32
		s_add_i32 s39, s39, s33
		v_add_u32_e32 v3, s39, v2
		v_add3_u32 v3, v3, v15, v18
		v_add3_u32 v3, v3, v19, v11
		v_cndmask_b32_e32 v3, v23, v3, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v4, v4, v7
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_bitop3_b32 v3, v4, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a56, v3
		s_lshl_b32 s39, s17, 4
		s_add_i32 s39, s39, s32
		s_add_i32 s39, s39, s33
		v_add_u32_e32 v3, s39, v2
		v_add3_u32 v3, v3, v15, v18
		v_add3_u32 v3, v3, v19, v11
		v_cndmask_b32_e32 v3, v23, v3, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v4, v17, v7
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_bitop3_b32 v3, v4, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a57, v3
		s_mul_i32 s39, 24, s17
		s_add_i32 s39, s39, s32
		s_add_i32 s39, s39, s33
		v_add_u32_e32 v3, s39, v2
		v_add3_u32 v3, v3, v15, v18
		v_add3_u32 v3, v3, v19, v11
		v_cndmask_b32_e32 v3, v23, v3, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v4, v8, v7
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_bitop3_b32 v3, v4, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a58, v3
		s_mul_i32 s39, s23, 0x80
		v_mbcnt_lo_u32_b32 v3, -1, 0
		v_mbcnt_hi_u32_b32 v3, -1, v3
		v_and_b32_e32 v3, 31, v3
		v_add_u32_e32 v4, 32, v3
		v_mov_b32_e32 v8, 0x3e38aa3b
		v_mov_b32_e32 v9, 0x3e38aa3b
		s_mov_b32 s23, 0xff800000
		v_mov_b32_e32 v7, s23
		v_mov_b32_e32 v10, s23
		s_mov_b32 s23, 1.0
		v_mov_b32_e32 v24, s23
		v_mov_b32_e32 v25, s23
		s_mov_b32 s23, 0
		v_lshrrev_b32_e32 v12, 4, v13
		v_lshlrev_b32_e32 v12, 9, v12
		v_accvgpr_write_b32 a59, v12
		v_and_b32_e32 v12, 15, v13
		v_mov_b32_e32 v13, 0x410
		v_mul_lo_u32 v13, v13, v12
		v_accvgpr_write_b32 a60, v13
		v_and_b32_e32 v12, 3, v0
		v_accvgpr_write_b32 a61, v12
		v_accvgpr_read_b32 v12, a61
		v_lshlrev_b32_e32 v12, 3, v12
		v_accvgpr_write_b32 a62, v12
		v_mov_b32_e32 v12, 0x2200
		v_mul_lo_u32 v12, v12, v1
		v_accvgpr_write_b32 a63, v12
		v_accvgpr_read_b32 v12, a16
		v_lshlrev_b32_e32 v12, 5, v12
		v_accvgpr_write_b32 a64, v12
		v_mov_b32_e32 v12, 0x880
		v_mul_lo_u32 v12, v12, v6
		v_accvgpr_write_b32 a65, v12
		s_lshl_b32 s46, s15, 8
		s_add_i32 s46, s46, s35
		s_add_i32 s46, s46, s36
		s_mul_i32 s47, 0x108, s15
		s_add_i32 s47, s47, s35
		s_add_i32 s47, s47, s36
		s_mul_i32 s48, 0x110, s15
		s_add_i32 s48, s48, s35
		s_add_i32 s48, s48, s36
		s_mul_i32 s49, 0x118, s15
		s_add_i32 s35, s49, s35
		s_add_i32 s36, s35, s36
		s_lshl_b32 s35, s17, 8
		s_add_i32 s35, s35, s32
		s_add_i32 s49, s35, s33
		s_mul_i32 s35, 0x108, s17
		s_add_i32 s35, s35, s32
		s_add_i32 s50, s35, s33
		s_mul_i32 s35, 0x110, s17
		s_add_i32 s35, s35, s32
		s_add_i32 s51, s35, s33
		s_mul_i32 s35, 0x118, s17
		s_add_i32 s32, s35, s32
		s_add_i32 s32, s32, s33
		v_lshlrev_b32_e32 v3, 2, v3
		v_accvgpr_write_b32 a66, v3
		v_lshlrev_b32_e32 v3, 2, v4
		v_accvgpr_write_b32 a67, v3
		v_add3_u32 v3, v16, v20, v21
		v_add_u32_e32 v3, v3, v22
		v_add3_u32 v4, v2, v15, v18
		v_add_u32_e32 v4, v4, v19
		s_cmp_lt_i32 0, s39
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
		s_mul_i32 s52, 0x4100, s35
		v_accvgpr_read_b32 v6, a19
		v_add_u32_e32 v6, s52, v6
		v_accvgpr_read_b32 v12, a59
		v_accvgpr_read_b32 v13, a60
		v_add3_u32 v6, v6, v12, v13
		ds_read_b128 v[28:31], v6
		ds_read_b128 v[96:99], v6 offset:32
		ds_read_b128 v[100:103], v6 offset:64
		ds_read_b128 a[68:71], v6 offset:96
		ds_read_b128 v[104:107], v6 offset:256
		ds_read_b128 v[108:111], v6 offset:288
		ds_read_b128 v[112:115], v6 offset:320
		ds_read_b128 a[72:75], v6 offset:352
		ds_read_b128 v[116:119], v6 offset:128
		ds_read_b128 v[120:123], v6 offset:160
		ds_read_b128 v[124:127], v6 offset:192
		ds_read_b128 a[76:79], v6 offset:224
		ds_read_b128 a[80:83], v6 offset:384
		ds_read_b128 a[84:87], v6 offset:416
		ds_read_b128 a[88:91], v6 offset:448
		ds_read_b128 a[92:95], v6 offset:480
		s_mul_i32 s35, 0x4400, s35
		v_accvgpr_read_b32 v6, a62
		v_add_u32_e32 v6, s35, v6
		v_accvgpr_read_b32 v12, a64
		v_accvgpr_read_b32 v13, a63
		v_add3_u32 v6, v6, v13, v12
		v_accvgpr_read_b32 v12, a53
		v_accvgpr_read_b32 v13, a65
		v_add3_u32 v6, v6, v13, v12
		ds_read_b64_tr_b16 a[96:97], v6 offset:33264
		ds_read_b64_tr_b16 a[98:99], v6 offset:37616
		ds_read_b64_tr_b16 a[100:101], v6 offset:33392
		ds_read_b64_tr_b16 a[102:103], v6 offset:37744
		ds_read_b64_tr_b16 a[104:105], v6 offset:33520
		ds_read_b64_tr_b16 a[106:107], v6 offset:37872
		ds_read_b64_tr_b16 a[108:109], v6 offset:33648
		ds_read_b64_tr_b16 a[110:111], v6 offset:38000
		ds_read_b64_tr_b16 a[112:113], v6 offset:33776
		ds_read_b64_tr_b16 a[114:115], v6 offset:38128
		ds_read_b64_tr_b16 a[116:117], v6 offset:33904
		ds_read_b64_tr_b16 a[118:119], v6 offset:38256
		ds_read_b64_tr_b16 a[120:121], v6 offset:34032
		ds_read_b64_tr_b16 a[122:123], v6 offset:38384
		ds_read_b64_tr_b16 a[124:125], v6 offset:34160
		ds_read_b64_tr_b16 a[126:127], v6 offset:38512
		ds_read_b64_tr_b16 a[128:129], v6 offset:33328
		ds_read_b64_tr_b16 a[130:131], v6 offset:37680
		ds_read_b64_tr_b16 a[132:133], v6 offset:33456
		ds_read_b64_tr_b16 a[134:135], v6 offset:37808
		ds_read_b64_tr_b16 a[136:137], v6 offset:33584
		ds_read_b64_tr_b16 a[138:139], v6 offset:37936
		ds_read_b64_tr_b16 a[140:141], v6 offset:33712
		ds_read_b64_tr_b16 a[142:143], v6 offset:38064
		ds_read_b64_tr_b16 a[144:145], v6 offset:33840
		ds_read_b64_tr_b16 a[146:147], v6 offset:38192
		ds_read_b64_tr_b16 a[148:149], v6 offset:33968
		ds_read_b64_tr_b16 a[150:151], v6 offset:38320
		ds_read_b64_tr_b16 a[152:153], v6 offset:34096
		ds_read_b64_tr_b16 a[154:155], v6 offset:38448
		ds_read_b64_tr_b16 a[156:157], v6 offset:34224
		ds_read_b64_tr_b16 a[158:159], v6 offset:38576
		s_mul_i32 s35, s15, s23
		s_lshl_b32 s35, s35, 1
		s_add_i32 s52, s46, s35
		v_add_u32_e32 v6, s52, v16
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[128:143], v[28:31], a[20:23], 0
		v_add3_u32 v6, v6, v20, v21
		v_mfma_f32_32x32x16_bf16 v[128:143], v[96:99], a[24:27], v[128:143]
		v_add3_u32 v6, v6, v22, v11
		v_mfma_f32_32x32x16_bf16 v[128:143], v[100:103], a[28:31], v[128:143]
		s_add_i32 s33, s33, 1
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[36:39], 0
		s_and_b32 s33, s33, 1
		v_mfma_f32_32x32x16_bf16 v[144:159], v[96:99], a[40:43], v[144:159]
		s_mul_i32 s52, 0x4100, s33
		v_mfma_f32_32x32x16_bf16 v[144:159], v[100:103], a[44:47], v[144:159]
		s_add_i32 s52, s38, s52
		v_mfma_f32_32x32x16_bf16 v[160:175], v[104:107], a[20:23], 0
		s_mov_b32 m0, s52
		v_mfma_f32_32x32x16_bf16 v[160:175], v[108:111], a[24:27], v[160:175]
		s_add_i32 s52, s47, s35
		v_mfma_f32_32x32x16_bf16 v[160:175], v[112:115], a[28:31], v[160:175]
		v_add3_u32 v12, v11, v3, s52
		v_mfma_f32_32x32x16_bf16 v[176:191], v[104:107], a[36:39], 0
		s_add_i32 s52, s48, s35
		v_mfma_f32_32x32x16_bf16 v[176:191], v[108:111], a[40:43], v[176:191]
		v_add3_u32 v13, v11, v3, s52
		v_mfma_f32_32x32x16_bf16 v[176:191], v[112:115], a[44:47], v[176:191]
		s_add_i32 s35, s36, s35
		v_mfma_f32_32x32x16_bf16 v[96:111], v[116:119], a[20:23], 0
		v_add3_u32 v14, v11, v3, s35
		v_mfma_f32_32x32x16_bf16 v[96:111], v[120:123], a[24:27], v[96:111]
		s_mul_i32 s35, s17, s23
		v_mfma_f32_32x32x16_bf16 v[96:111], v[124:127], a[28:31], v[96:111]
		s_add_i32 s23, s23, 0x80
		v_mfma_f32_32x32x16_bf16 v[192:207], v[116:119], a[36:39], 0
		v_accvgpr_read_b32 v17, a17
		v_add_u32_e32 v17, s23, v17
		v_mfma_f32_32x32x16_bf16 v[192:207], v[120:123], a[40:43], v[192:207]
		v_accvgpr_read_b32 v26, a52
		v_add_u32_e32 v26, s23, v26
		v_mfma_f32_32x32x16_bf16 v[192:207], v[124:127], a[44:47], v[192:207]
		v_accvgpr_read_b32 v27, a54
		v_add_u32_e32 v27, s23, v27
		v_mfma_f32_32x32x16_bf16 v[112:127], a[80:83], a[20:23], 0
		v_accvgpr_read_b32 v28, a55
		v_add_u32_e32 v28, s23, v28
		v_mfma_f32_32x32x16_bf16 v[112:127], a[84:87], a[24:27], v[112:127]
		v_cmp_lt_i32_e64 s[52:53], v17, s20
		v_mfma_f32_32x32x16_bf16 v[112:127], a[88:91], a[28:31], v[112:127]
		v_accvgpr_read_b32 v17, a18
		v_add_u32_e32 v17, s23, v17
		v_mfma_f32_32x32x16_bf16 v[208:223], a[80:83], a[36:39], 0
		v_accvgpr_read_b32 v29, a56
		v_add_u32_e32 v29, s23, v29
		v_accvgpr_read_b32 v30, a57
		v_add_u32_e32 v30, s23, v30
		v_cmp_lt_i32_e64 s[54:55], v17, s20
		v_cndmask_b32_e64 v6, v23, v6, s[52:53]
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[52:53], v26, s20
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[56:57], v27, s20
		v_mfma_f32_32x32x16_bf16 v[208:223], a[84:87], a[40:43], v[208:223]
		v_cndmask_b32_e64 v6, v23, v12, s[52:53]
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[208:223], a[88:91], a[44:47], v[208:223]
		v_cndmask_b32_e64 v6, v23, v13, s[56:57]
		v_cmp_lt_i32_e64 s[52:53], v28, s20
		s_add_i32 m0, m0, 0x1040
		v_accvgpr_read_b32 v12, a58
		v_add_u32_e32 v12, s23, v12
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[128:143], a[68:71], a[32:35], v[128:143]
		v_cndmask_b32_e64 v6, v23, v14, s[52:53]
		v_cmp_lt_i32_e64 s[52:53], v29, s20
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s35, s35, 1
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[56:57], v30, s20
		s_add_i32 s58, s49, s35
		v_mfma_f32_32x32x16_bf16 v[144:159], a[68:71], a[48:51], v[144:159]
		v_add_u32_e32 v6, s58, v2
		v_add3_u32 v6, v6, v15, v18
		v_add3_u32 v6, v6, v19, v11
		v_cndmask_b32_e64 v6, v23, v6, s[54:55]
		v_max3_f32 v13, v128, v129, v130
		s_mul_i32 s33, 0x4400, s33
		v_max3_f32 v14, v132, v133, v134
		s_add_i32 s33, s37, s33
		v_max3_f32 v17, v136, v137, v138
		s_add_i32 m0, s33, 0x81f0
		s_add_i32 s33, s50, s35
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_add3_u32 v6, v11, v4, s33
		v_cndmask_b32_e64 v6, v23, v6, s[52:53]
		v_max3_f32 v26, v140, v141, v142
		s_add_i32 m0, m0, 0x1100
		s_add_i32 s33, s51, s35
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_add3_u32 v6, v11, v4, s33
		v_max3_f32 v13, v13, v131, v14
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v6, v23, v6, s[56:57]
		s_add_i32 s33, s32, s35
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 vcc, v12, s20
		v_add3_u32 v6, v11, v4, s33
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e32 v6, v23, v6, vcc
		v_max3_f32 v12, v17, v139, v26
		v_max3_f32 v12, v13, v135, v12
		v_max3_f32 v13, v144, v145, v146
		v_max3_f32 v14, v148, v149, v150
		v_max3_f32 v17, v152, v153, v154
		v_max3_f32 v26, v156, v157, v158
		v_max3_f32 v13, v13, v147, v14
		v_max3_f32 v14, v17, v155, v26
		v_max3_f32 v13, v13, v151, v14
		s_cmp_lt_i32 s23, s39
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[160:175], a[72:75], a[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[76:79], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[92:95], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[92:95], a[48:51], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[72:75], a[48:51], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[76:79], a[48:51], v[192:207]
		s_nop 6
		v_max3_f32 v6, v160, v161, v162
		v_max3_f32 v14, v164, v165, v166
		v_max3_f32 v17, v168, v169, v170
		v_max3_f32 v26, v172, v173, v174
		v_max3_f32 v27, v96, v97, v98
		v_max3_f32 v28, v100, v101, v102
		v_max3_f32 v29, v104, v105, v106
		v_max3_f32 v30, v108, v109, v110
		v_max3_f32 v31, v112, v113, v114
		v_max3_f32 v224, v116, v117, v118
		v_max3_f32 v225, v120, v121, v122
		v_max3_f32 v226, v124, v125, v126
		v_max3_f32 v6, v6, v163, v14
		v_max3_f32 v14, v17, v171, v26
		v_max3_f32 v17, v27, v99, v28
		v_max3_f32 v26, v29, v107, v30
		v_max3_f32 v27, v31, v115, v224
		v_max3_f32 v28, v225, v123, v226
		v_max3_f32 v6, v6, v167, v14
		v_max3_f32 v14, v17, v103, v26
		v_max3_f32 v17, v27, v119, v28
		v_max3_f32 v6, v12, v143, v6
		v_max3_f32 v12, v14, v111, v17
		v_max3_f32 v6, v6, v175, v12
		v_max_f32_e32 v26, v6, v127
		v_mov_b32_e32 v27, v26
		v_max3_f32 v6, v176, v177, v178
		v_max3_f32 v12, v180, v181, v182
		v_max3_f32 v14, v184, v185, v186
		v_max3_f32 v17, v188, v189, v190
		v_max3_f32 v28, v192, v193, v194
		v_max3_f32 v29, v196, v197, v198
		v_max3_f32 v30, v200, v201, v202
		v_max3_f32 v31, v204, v205, v206
		v_max3_f32 v224, v208, v209, v210
		v_max3_f32 v225, v212, v213, v214
		v_max3_f32 v226, v216, v217, v218
		v_max3_f32 v227, v220, v221, v222
		v_max3_f32 v6, v6, v179, v12
		v_max3_f32 v12, v14, v187, v17
		v_max3_f32 v14, v28, v195, v29
		v_max3_f32 v17, v30, v203, v31
		v_permlane32_swap_b32_e32 v26, v27
		v_max3_f32 v28, v224, v211, v225
		v_max3_f32 v29, v226, v219, v227
		v_max3_f32 v6, v6, v183, v12
		v_max3_f32 v12, v14, v199, v17
		v_max3_f32 v14, v28, v215, v29
		v_max3_f32 v6, v13, v159, v6
		v_max3_f32 v12, v12, v207, v14
		v_max3_f32 v6, v6, v191, v12
		v_max_f32_e32 v12, v6, v223
		v_mov_b32_e32 v13, v12
		v_max_f32_e32 v28, v26, v27
		v_mov_b32_e32 v26, v7
		v_permlane32_swap_b32_e32 v12, v13
		v_max_f32_e32 v29, v12, v13
		v_pk_mul_f32 v[12:13], v[28:29], v[8:9]
		v_max_f32_e32 v28, v7, v12
		v_max_f32_e32 v29, v10, v13
		v_pk_fma_f32 v[6:7], v[128:129], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[12:13], v[130:131], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[132:133], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[134:135], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[136:137], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[138:139], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[140:141], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[142:143], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[160:161], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[162:163], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[164:165], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[166:167], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[168:169], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[170:171], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[172:173], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[174:175], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[96:97], v[8:9], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
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
		v_pk_fma_f32 v[172:173], v[178:179], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[180:181], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[182:183], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[184:185], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[186:187], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[188:189], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[190:191], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[192:193], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[194:195], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[196:197], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[198:199], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[200:201], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[202:203], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[204:205], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[206:207], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[208:209], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[210:211], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[212:213], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[214:215], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[216:217], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[218:219], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[220:221], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[222:223], v[8:9], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v218, v6
		v_exp_f32_e32 v220, v7
		v_exp_f32_e32 v6, v12
		v_exp_f32_e32 v222, v13
		v_exp_f32_e32 v12, v30
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
		v_exp_f32_e32 v219, v170
		v_exp_f32_e32 v221, v171
		v_exp_f32_e32 v7, v96
		v_exp_f32_e32 v223, v97
		v_exp_f32_e32 v13, v98
		v_exp_f32_e32 v225, v99
		v_exp_f32_e32 v31, v100
		v_exp_f32_e32 v227, v101
		v_exp_f32_e32 v129, v102
		v_exp_f32_e32 v229, v103
		v_exp_f32_e32 v131, v104
		v_exp_f32_e32 v231, v105
		v_exp_f32_e32 v133, v106
		v_exp_f32_e32 v233, v107
		v_exp_f32_e32 v135, v108
		v_exp_f32_e32 v235, v109
		v_exp_f32_e32 v137, v110
		v_exp_f32_e32 v237, v111
		v_exp_f32_e32 v139, v112
		v_exp_f32_e32 v239, v113
		v_exp_f32_e32 v141, v114
		v_exp_f32_e32 v241, v115
		v_exp_f32_e32 v143, v116
		v_exp_f32_e32 v243, v117
		v_exp_f32_e32 v161, v118
		v_exp_f32_e32 v245, v119
		v_exp_f32_e32 v163, v120
		v_exp_f32_e32 v247, v121
		v_exp_f32_e32 v165, v122
		v_exp_f32_e32 v249, v123
		v_exp_f32_e32 v167, v124
		v_exp_f32_e32 v251, v125
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
		v_exp_f32_e32 v148, v172
		v_exp_f32_e32 v150, v173
		v_exp_f32_e32 v152, v174
		v_exp_f32_e32 v154, v175
		v_exp_f32_e32 v156, v176
		v_exp_f32_e32 v158, v177
		v_exp_f32_e32 v168, v178
		v_exp_f32_e32 v170, v179
		v_exp_f32_e32 v172, v180
		v_exp_f32_e32 v174, v181
		v_exp_f32_e32 v176, v182
		v_exp_f32_e32 v178, v183
		v_exp_f32_e32 v180, v184
		v_exp_f32_e32 v182, v185
		v_exp_f32_e32 v97, v186
		v_exp_f32_e32 v99, v187
		v_exp_f32_e32 v101, v188
		v_exp_f32_e32 v103, v189
		v_exp_f32_e32 v105, v190
		v_exp_f32_e32 v107, v191
		v_exp_f32_e32 v109, v192
		v_exp_f32_e32 v111, v193
		v_exp_f32_e32 v113, v194
		v_exp_f32_e32 v115, v195
		v_exp_f32_e32 v117, v196
		v_exp_f32_e32 v119, v197
		v_exp_f32_e32 v121, v198
		v_exp_f32_e32 v123, v199
		v_exp_f32_e32 v125, v200
		v_exp_f32_e32 v127, v201
		v_exp_f32_e32 v145, v202
		v_exp_f32_e32 v147, v203
		v_exp_f32_e32 v149, v204
		v_exp_f32_e32 v151, v205
		v_exp_f32_e32 v153, v206
		v_exp_f32_e32 v155, v207
		v_exp_f32_e32 v157, v208
		v_exp_f32_e32 v159, v209
		v_exp_f32_e32 v169, v210
		v_exp_f32_e32 v171, v211
		v_exp_f32_e32 v173, v212
		v_exp_f32_e32 v175, v213
		v_exp_f32_e32 v177, v214
		v_exp_f32_e32 v179, v215
		v_exp_f32_e32 v181, v216
		v_exp_f32_e32 v183, v217
		v_pk_add_f32 v[184:185], v[218:219], v[220:221]
		v_pk_add_f32 v[186:187], v[6:7], v[222:223]
		v_pk_add_f32 v[188:189], v[12:13], v[224:225]
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
		v_pk_add_f32 v[184:185], v[184:185], v[186:187]
		v_pk_add_f32 v[186:187], v[188:189], v[190:191]
		v_pk_add_f32 v[188:189], v[192:193], v[194:195]
		v_pk_add_f32 v[190:191], v[196:197], v[198:199]
		v_pk_add_f32 v[192:193], v[200:201], v[202:203]
		v_pk_add_f32 v[194:195], v[204:205], v[206:207]
		v_pk_add_f32 v[196:197], v[208:209], v[210:211]
		v_pk_add_f32 v[198:199], v[212:213], v[214:215]
		v_pk_add_f32 v[184:185], v[184:185], v[186:187]
		v_pk_add_f32 v[186:187], v[188:189], v[190:191]
		v_pk_add_f32 v[188:189], v[192:193], v[194:195]
		v_pk_add_f32 v[190:191], v[196:197], v[198:199]
		v_pk_add_f32 v[184:185], v[184:185], v[186:187]
		v_pk_add_f32 v[186:187], v[188:189], v[190:191]
		v_pk_add_f32 v[188:189], v[184:185], v[186:187]
		v_add_f32_e32 v14, v188, v189
		v_accvgpr_read_b32 v17, a66
		ds_bpermute_b32 v184, v17, v14
		v_accvgpr_read_b32 v17, a67
		ds_bpermute_b32 v186, v17, v14
		v_pk_add_f32 v[188:189], v[96:97], v[98:99]
		v_pk_add_f32 v[190:191], v[100:101], v[102:103]
		v_pk_add_f32 v[192:193], v[104:105], v[106:107]
		v_pk_add_f32 v[194:195], v[108:109], v[110:111]
		v_pk_add_f32 v[196:197], v[112:113], v[114:115]
		v_pk_add_f32 v[198:199], v[116:117], v[118:119]
		v_pk_add_f32 v[200:201], v[120:121], v[122:123]
		v_pk_add_f32 v[202:203], v[124:125], v[126:127]
		v_pk_add_f32 v[204:205], v[144:145], v[146:147]
		v_pk_add_f32 v[206:207], v[148:149], v[150:151]
		v_pk_add_f32 v[208:209], v[152:153], v[154:155]
		v_pk_add_f32 v[210:211], v[156:157], v[158:159]
		v_pk_add_f32 v[212:213], v[168:169], v[170:171]
		v_pk_add_f32 v[214:215], v[172:173], v[174:175]
		v_pk_add_f32 v[216:217], v[176:177], v[178:179]
		v_pk_add_f32 v[252:253], v[180:181], v[182:183]
		v_pk_add_f32 v[188:189], v[188:189], v[190:191]
		v_pk_add_f32 v[190:191], v[192:193], v[194:195]
		v_pk_add_f32 v[192:193], v[196:197], v[198:199]
		v_pk_add_f32 v[194:195], v[200:201], v[202:203]
		v_pk_add_f32 v[196:197], v[204:205], v[206:207]
		v_pk_add_f32 v[198:199], v[208:209], v[210:211]
		v_pk_add_f32 v[200:201], v[212:213], v[214:215]
		v_pk_add_f32 v[202:203], v[216:217], v[252:253]
		v_pk_add_f32 v[188:189], v[188:189], v[190:191]
		v_pk_add_f32 v[190:191], v[192:193], v[194:195]
		v_pk_add_f32 v[192:193], v[196:197], v[198:199]
		v_pk_add_f32 v[194:195], v[200:201], v[202:203]
		v_pk_add_f32 v[188:189], v[188:189], v[190:191]
		v_pk_add_f32 v[190:191], v[192:193], v[194:195]
		v_pk_add_f32 v[192:193], v[188:189], v[190:191]
		v_mov_b32_e32 v187, v193
		v_mov_b32_e32 v185, v192
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[188:189], v[184:185], v[186:187]
		v_mov_b32_e32 v184, v189
		v_mov_b32_e32 v185, v189
		v_cvt_pk_bf16_f32 v192, v218, v220
		v_cvt_pk_bf16_f32 v193, v6, v222
		v_permlane32_swap_b32_e32 v184, v185
		v_add_f32_e32 v187, v184, v185
		v_mov_b32_e32 v27, v10
		v_pk_add_f32 v[184:185], v[26:27], v[28:29] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v26, v184
		v_exp_f32_e32 v27, v185
		v_cvt_pk_bf16_f32 v194, v12, v224
		v_mov_b32_e32 v186, v188
		v_mov_b64_e32 v[184:185], v[24:25]
		v_pk_fma_f32 v[24:25], v[184:185], v[26:27], v[186:187]
		v_cvt_pk_bf16_f32 v195, v30, v226
		v_cvt_pk_bf16_f32 v184, v128, v228
		v_cvt_pk_bf16_f32 v185, v130, v230
		v_cvt_pk_bf16_f32 v186, v132, v232
		v_cvt_pk_bf16_f32 v187, v134, v234
		v_cvt_pk_bf16_f32 v188, v136, v236
		v_cvt_pk_bf16_f32 v189, v138, v238
		v_cvt_pk_bf16_f32 v190, v140, v240
		v_cvt_pk_bf16_f32 v191, v142, v242
		v_cvt_pk_bf16_f32 v196, v160, v244
		v_cvt_pk_bf16_f32 v197, v162, v246
		v_cvt_pk_bf16_f32 v198, v164, v248
		v_cvt_pk_bf16_f32 v199, v166, v250
		v_cvt_pk_bf16_f32 v200, v219, v221
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
		v_cvt_pk_bf16_f32 v201, v7, v223
		v_cvt_pk_bf16_f32 v202, v13, v225
		v_cvt_pk_bf16_f32 v203, v31, v227
		v_cvt_pk_bf16_f32 v204, v129, v229
		v_cvt_pk_bf16_f32 v205, v131, v231
		v_cvt_pk_bf16_f32 v206, v133, v233
		v_cvt_pk_bf16_f32 v207, v135, v235
		v_cvt_pk_bf16_f32 v128, v137, v237
		v_cvt_pk_bf16_f32 v129, v139, v239
		v_cvt_pk_bf16_f32 v130, v141, v241
		v_cvt_pk_bf16_f32 v131, v143, v243
		v_cvt_pk_bf16_f32 v132, v161, v245
		v_cvt_pk_bf16_f32 v133, v163, v247
		v_cvt_pk_bf16_f32 v134, v165, v249
		v_cvt_pk_bf16_f32 v135, v167, v251
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
		v_cvt_pk_bf16_f32 v164, v168, v170
		v_cvt_pk_bf16_f32 v165, v172, v174
		v_cvt_pk_bf16_f32 v166, v176, v178
		v_cvt_pk_bf16_f32 v167, v180, v182
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
		v_cvt_pk_bf16_f32 v104, v169, v171
		v_cvt_pk_bf16_f32 v105, v173, v175
		v_cvt_pk_bf16_f32 v106, v177, v179
		v_cvt_pk_bf16_f32 v107, v181, v183
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_mfma_f32_32x32x16_bf16 v[32:47], a[96:99], v[192:195], v[32:47]
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[48:63], a[128:131], v[192:195], v[48:63]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[32:47], a[100:103], v[184:187], v[32:47]
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_mfma_f32_32x32x16_bf16 v[48:63], a[132:135], v[184:187], v[48:63]
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_mfma_f32_32x32x16_bf16 v[32:47], a[104:107], v[188:191], v[32:47]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[48:63], a[136:139], v[188:191], v[48:63]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[32:47], a[108:111], v[196:199], v[32:47]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[48:63], a[140:143], v[196:199], v[48:63]
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_mfma_f32_32x32x16_bf16 v[80:95], a[128:131], v[136:139], v[80:95]
		v_permlane32_swap_b32_e32 v160, v162
		v_permlane32_swap_b32_e32 v161, v163
		v_mfma_f32_32x32x16_bf16 v[64:79], a[96:99], v[136:139], v[64:79]
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		v_mfma_f32_32x32x16_bf16 v[80:95], a[132:135], v[140:143], v[80:95]
		v_permlane32_swap_b32_e32 v208, v210
		v_permlane32_swap_b32_e32 v209, v211
		v_mfma_f32_32x32x16_bf16 v[64:79], a[100:103], v[140:143], v[64:79]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[80:95], a[136:139], v[160:163], v[80:95]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[64:79], a[104:107], v[160:163], v[64:79]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[80:95], a[140:143], v[164:167], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[108:111], v[164:167], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[112:115], v[200:203], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[144:147], v[200:203], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[208:211], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[112:115], v[208:211], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[116:119], v[204:207], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[148:151], v[204:207], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[148:151], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[116:119], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[120:123], v[128:131], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[152:155], v[128:131], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[120:123], v[100:103], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[124:127], v[132:135], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[156:159], v[132:135], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], v[104:107], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[124:127], v[104:107], v[64:79]
		v_mov_b32_e32 v7, v28
		v_mov_b32_e32 v10, v29
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_3
.L_attn_fwd_persistent.loop_exit_3:
		s_mul_i32 s21, s21, 0x80
		v_accvgpr_read_b32 v3, a6
		s_nop 0
		v_readfirstlane_b32 s23, v3
		v_accvgpr_read_b32 v3, a14
		s_nop 0
		v_add_u32_e32 v3, s23, v3
		v_add_u32_e32 v3, s1, v3
		v_accvgpr_read_b32 v4, a6
		s_nop 0
		v_readfirstlane_b32 s23, v4
		v_accvgpr_read_b32 v4, a15
		s_nop 0
		v_add_u32_e32 v4, s23, v4
		v_add_u32_e32 v4, s1, v4
		v_xor_b32_e32 v6, 1, v5
		v_accvgpr_write_b32 a14, v6
		v_xor_b32_e32 v6, 2, v5
		v_accvgpr_write_b32 a15, v6
		v_xor_b32_e32 v6, 3, v5
		v_accvgpr_write_b32 a62, v6
		v_xor_b32_e32 v6, 8, v5
		v_accvgpr_write_b32 a64, v6
		v_xor_b32_e32 v6, 9, v5
		v_accvgpr_write_b32 a68, v6
		v_xor_b32_e32 v6, 10, v5
		v_accvgpr_write_b32 a69, v6
		v_xor_b32_e32 v6, 11, v5
		v_accvgpr_write_b32 a70, v6
		v_xor_b32_e32 v6, 16, v5
		v_accvgpr_write_b32 a71, v6
		v_xor_b32_e32 v6, 17, v5
		v_accvgpr_write_b32 a72, v6
		v_xor_b32_e32 v6, 18, v5
		v_accvgpr_write_b32 a73, v6
		v_xor_b32_e32 v6, 19, v5
		v_accvgpr_write_b32 a74, v6
		v_xor_b32_e32 v6, 24, v5
		v_accvgpr_write_b32 a75, v6
		v_xor_b32_e32 v6, 25, v5
		v_accvgpr_write_b32 a76, v6
		v_xor_b32_e32 v6, 26, v5
		v_accvgpr_write_b32 a77, v6
		v_xor_b32_e32 v6, 27, v5
		v_accvgpr_write_b32 a78, v6
		v_xor_b32_e32 v6, 32, v5
		v_accvgpr_write_b32 a79, v6
		v_xor_b32_e32 v6, 33, v5
		v_accvgpr_write_b32 a80, v6
		v_xor_b32_e32 v6, 34, v5
		v_accvgpr_write_b32 a81, v6
		v_xor_b32_e32 v6, 35, v5
		v_accvgpr_write_b32 a82, v6
		v_xor_b32_e32 v6, 40, v5
		v_accvgpr_write_b32 a83, v6
		v_xor_b32_e32 v6, 41, v5
		v_accvgpr_write_b32 a84, v6
		v_xor_b32_e32 v6, 42, v5
		v_accvgpr_write_b32 a85, v6
		v_xor_b32_e32 v6, 43, v5
		v_accvgpr_write_b32 a86, v6
		v_xor_b32_e32 v6, 48, v5
		v_accvgpr_write_b32 a87, v6
		v_xor_b32_e32 v6, 49, v5
		v_accvgpr_write_b32 a88, v6
		v_xor_b32_e32 v6, 50, v5
		v_accvgpr_write_b32 a89, v6
		v_xor_b32_e32 v6, 51, v5
		v_accvgpr_write_b32 a90, v6
		v_xor_b32_e32 v6, 56, v5
		v_accvgpr_write_b32 a91, v6
		v_xor_b32_e32 v6, 57, v5
		v_accvgpr_write_b32 a92, v6
		v_xor_b32_e32 v6, 58, v5
		v_accvgpr_write_b32 a93, v6
		v_xor_b32_e32 v6, 59, v5
		v_accvgpr_write_b32 a94, v6
		v_xor_b32_e32 v6, 64, v5
		v_accvgpr_write_b32 a95, v6
		v_xor_b32_e32 v6, 0x41, v5
		v_accvgpr_write_b32 a96, v6
		v_xor_b32_e32 v6, 0x42, v5
		v_accvgpr_write_b32 a97, v6
		v_xor_b32_e32 v6, 0x43, v5
		v_accvgpr_write_b32 a98, v6
		v_xor_b32_e32 v6, 0x48, v5
		v_accvgpr_write_b32 a99, v6
		v_xor_b32_e32 v6, 0x49, v5
		v_accvgpr_write_b32 a100, v6
		v_xor_b32_e32 v6, 0x4a, v5
		v_accvgpr_write_b32 a101, v6
		v_xor_b32_e32 v6, 0x4b, v5
		v_accvgpr_write_b32 a102, v6
		v_xor_b32_e32 v6, 0x50, v5
		v_accvgpr_write_b32 a103, v6
		v_xor_b32_e32 v6, 0x51, v5
		v_accvgpr_write_b32 a104, v6
		v_xor_b32_e32 v6, 0x52, v5
		v_accvgpr_write_b32 a105, v6
		v_xor_b32_e32 v6, 0x53, v5
		v_accvgpr_write_b32 a106, v6
		v_xor_b32_e32 v6, 0x58, v5
		v_accvgpr_write_b32 a107, v6
		v_xor_b32_e32 v6, 0x59, v5
		v_accvgpr_write_b32 a108, v6
		v_xor_b32_e32 v6, 0x5a, v5
		v_accvgpr_write_b32 a109, v6
		v_xor_b32_e32 v6, 0x5b, v5
		v_accvgpr_write_b32 a110, v6
		v_xor_b32_e32 v6, 0x60, v5
		v_accvgpr_write_b32 a111, v6
		v_xor_b32_e32 v6, 0x61, v5
		v_accvgpr_write_b32 a112, v6
		v_xor_b32_e32 v6, 0x62, v5
		v_accvgpr_write_b32 a113, v6
		v_xor_b32_e32 v6, 0x63, v5
		v_accvgpr_write_b32 a114, v6
		v_xor_b32_e32 v6, 0x68, v5
		v_accvgpr_write_b32 a115, v6
		v_xor_b32_e32 v6, 0x69, v5
		v_accvgpr_write_b32 a116, v6
		v_xor_b32_e32 v6, 0x6a, v5
		v_accvgpr_write_b32 a117, v6
		v_xor_b32_e32 v6, 0x6b, v5
		v_accvgpr_write_b32 a118, v6
		v_xor_b32_e32 v6, 0x70, v5
		v_accvgpr_write_b32 a119, v6
		v_xor_b32_e32 v6, 0x71, v5
		v_accvgpr_write_b32 a120, v6
		v_xor_b32_e32 v6, 0x72, v5
		v_accvgpr_write_b32 a121, v6
		v_xor_b32_e32 v6, 0x73, v5
		v_accvgpr_write_b32 a122, v6
		v_xor_b32_e32 v6, 0x78, v5
		v_accvgpr_write_b32 a123, v6
		v_xor_b32_e32 v6, 0x79, v5
		v_accvgpr_write_b32 a124, v6
		v_xor_b32_e32 v6, 0x7a, v5
		v_accvgpr_write_b32 a125, v6
		v_xor_b32_e32 v6, 0x7b, v5
		v_accvgpr_write_b32 a126, v6
		v_accvgpr_read_b32 v6, a19
		v_accvgpr_read_b32 v12, a59
		v_accvgpr_read_b32 v13, a60
		v_add3_u32 v6, v6, v12, v13
		v_accvgpr_write_b32 a19, v6
		v_accvgpr_read_b32 v6, a61
		v_accvgpr_read_b32 v12, a63
		v_lshl_add_u32 v6, v6, 3, v12
		v_accvgpr_read_b32 v12, a16
		v_lshl_add_u32 v6, v12, 5, v6
		v_accvgpr_read_b32 v12, a53
		v_accvgpr_read_b32 v13, a65
		v_add3_u32 v6, v6, v13, v12
		v_accvgpr_write_b32 a16, v6
		v_mov_b32_e32 v6, 0xff800000
		s_cmp_lt_i32 s39, s21
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_4
.L_attn_fwd_persistent.loop_head_4:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s1, s39, 0x80
		s_cmp_lt_i32 s39, 0
		s_cselect_b32 s23, s22, 0
		s_add_i32 s23, s39, s23
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
		s_add_i32 s52, s23, s35
		s_mul_i32 s23, 0x4100, s33
		v_accvgpr_read_b32 v12, a19
		v_add_u32_e32 v12, s23, v12
		ds_read_b128 v[28:31], v12
		ds_read_b128 a[128:131], v12 offset:32
		ds_read_b128 a[132:135], v12 offset:64
		ds_read_b128 a[136:139], v12 offset:96
		ds_read_b128 a[140:143], v12 offset:256
		ds_read_b128 a[144:147], v12 offset:288
		ds_read_b128 a[148:151], v12 offset:320
		ds_read_b128 a[152:155], v12 offset:352
		ds_read_b128 a[156:159], v12 offset:128
		ds_read_b128 a[160:163], v12 offset:160
		ds_read_b128 a[164:167], v12 offset:192
		ds_read_b128 a[168:171], v12 offset:224
		ds_read_b128 v[96:99], v12 offset:384
		ds_read_b128 a[172:175], v12 offset:416
		ds_read_b128 a[176:179], v12 offset:448
		ds_read_b128 a[180:183], v12 offset:480
		s_mul_i32 s23, 0x4400, s33
		v_accvgpr_read_b32 v12, a16
		v_add_u32_e32 v12, s23, v12
		ds_read_b64_tr_b16 a[184:185], v12 offset:33264
		ds_read_b64_tr_b16 a[186:187], v12 offset:37616
		ds_read_b64_tr_b16 a[188:189], v12 offset:33392
		ds_read_b64_tr_b16 a[190:191], v12 offset:37744
		ds_read_b64_tr_b16 a[192:193], v12 offset:33520
		ds_read_b64_tr_b16 a[194:195], v12 offset:37872
		ds_read_b64_tr_b16 a[196:197], v12 offset:33648
		ds_read_b64_tr_b16 a[198:199], v12 offset:38000
		ds_read_b64_tr_b16 a[200:201], v12 offset:33776
		ds_read_b64_tr_b16 a[202:203], v12 offset:38128
		ds_read_b64_tr_b16 a[204:205], v12 offset:33904
		ds_read_b64_tr_b16 a[206:207], v12 offset:38256
		ds_read_b64_tr_b16 a[208:209], v12 offset:34032
		ds_read_b64_tr_b16 a[210:211], v12 offset:38384
		ds_read_b64_tr_b16 a[212:213], v12 offset:34160
		ds_read_b64_tr_b16 a[214:215], v12 offset:38512
		ds_read_b64_tr_b16 a[216:217], v12 offset:33328
		ds_read_b64_tr_b16 a[218:219], v12 offset:37680
		ds_read_b64_tr_b16 a[220:221], v12 offset:33456
		ds_read_b64_tr_b16 a[222:223], v12 offset:37808
		ds_read_b64_tr_b16 a[224:225], v12 offset:33584
		ds_read_b64_tr_b16 a[226:227], v12 offset:37936
		ds_read_b64_tr_b16 a[228:229], v12 offset:33712
		ds_read_b64_tr_b16 a[230:231], v12 offset:38064
		ds_read_b64_tr_b16 a[232:233], v12 offset:33840
		ds_read_b64_tr_b16 a[234:235], v12 offset:38192
		ds_read_b64_tr_b16 a[236:237], v12 offset:33968
		ds_read_b64_tr_b16 a[238:239], v12 offset:38320
		ds_read_b64_tr_b16 a[240:241], v12 offset:34096
		ds_read_b64_tr_b16 a[242:243], v12 offset:38448
		ds_read_b64_tr_b16 a[244:245], v12 offset:34224
		ds_read_b64_tr_b16 a[246:247], v12 offset:38576
		s_cmp_lt_i32 s1, s18
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_4
		v_accvgpr_read_b32 v12, a17
		v_add_u32_e32 v12, s1, v12
		v_cmp_lt_i32_e64 s[54:55], v12, s20
		v_accvgpr_read_b32 v12, a18
		v_add_u32_e32 v12, s1, v12
		v_cmp_lt_i32_e64 s[56:57], v12, s20
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s23, s15, s39
		s_lshl_b32 s23, s23, 1
		s_add_i32 s33, s46, s23
		v_add_u32_e32 v12, s33, v16
		v_add3_u32 v12, v12, v20, v21
		v_add3_u32 v12, v12, v22, v11
		v_cndmask_b32_e64 v12, v23, v12, s[54:55]
		s_mov_b32 s54, 1
		s_mov_b32 s55, 0
		s_mov_b32 s35, 0
		s_mul_i32 s58, s54, s34
		s_mul_hi_u32 s59, s54, s34
		s_mul_i32 s33, s54, s35
		s_add_i32 s59, s59, s33
		s_mul_i32 s33, s55, s34
		s_add_i32 s59, s59, s33
		s_lshr_b64 s[54:55], s[58:59], 6
		s_mov_b32 s58, 0x410
		s_mov_b32 s59, 0
		s_mul_i32 s60, s58, s54
		s_mul_hi_u32 s61, s58, s54
		s_mul_i32 s33, s58, s55
		s_add_i32 s61, s61, s33
		s_mul_i32 s33, s59, s54
		s_add_i32 s61, s61, s33
		s_cmp_lt_i32 s52, 0
		s_cselect_b32 s53, -1, 0
		s_mov_b32 s58, 0x4100
		s_mov_b32 s59, 0
		s_mul_i32 s62, s58, s52
		s_mul_hi_u32 s63, s58, s52
		s_mul_i32 s33, s58, s53
		s_add_i32 s63, s63, s33
		s_mul_i32 s33, s59, s52
		s_add_i32 s63, s63, s33
		s_add_u32 s58, s60, s62
		s_addc_u32 s59, s61, s63
		s_add_u32 s64, s58, 0
		s_addc_u32 s65, s59, 0
		s_mov_b32 m0, s64
		v_accvgpr_read_b32 v13, a52
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[58:59], v13, s20
		s_add_i32 s33, s47, s23
		v_add_u32_e32 v12, s33, v16
		v_add3_u32 v12, v12, v20, v21
		v_add3_u32 v12, v12, v22, v11
		v_cndmask_b32_e64 v12, v23, v12, s[58:59]
		s_add_u32 s58, s60, 0x1040
		s_addc_u32 s59, s61, 0
		s_add_u32 s58, s58, s62
		s_addc_u32 s59, s59, s63
		s_add_u32 s64, s58, 0
		s_addc_u32 s65, s59, 0
		s_mov_b32 m0, s64
		v_accvgpr_read_b32 v13, a54
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[58:59], v13, s20
		s_add_i32 s33, s48, s23
		v_add_u32_e32 v12, s33, v16
		v_add3_u32 v12, v12, v20, v21
		v_add3_u32 v12, v12, v22, v11
		v_cndmask_b32_e64 v12, v23, v12, s[58:59]
		s_add_u32 s58, s60, 0x2080
		s_addc_u32 s59, s61, 0
		s_add_u32 s58, s58, s62
		s_addc_u32 s59, s59, s63
		s_add_u32 s64, s58, 0
		s_addc_u32 s65, s59, 0
		s_mov_b32 m0, s64
		v_accvgpr_read_b32 v13, a55
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[58:59], v13, s20
		s_add_i32 s23, s36, s23
		v_add_u32_e32 v12, s23, v16
		v_add3_u32 v12, v12, v20, v21
		v_add3_u32 v12, v12, v22, v11
		v_cndmask_b32_e64 v12, v23, v12, s[58:59]
		s_add_u32 s58, s60, 0x30c0
		s_addc_u32 s59, s61, 0
		s_add_u32 s58, s58, s62
		s_addc_u32 s59, s59, s63
		s_add_u32 s60, s58, 0
		s_addc_u32 s61, s59, 0
		s_mov_b32 m0, s60
		v_accvgpr_read_b32 v13, a56
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v12, s[24:27], 0 offen lds
		s_mul_i32 s23, s17, s39
		s_lshl_b32 s23, s23, 1
		s_add_i32 s33, s49, s23
		v_add_u32_e32 v12, s33, v2
		v_add3_u32 v12, v12, v15, v18
		v_add3_u32 v12, v12, v19, v11
		v_cndmask_b32_e64 v12, v23, v12, s[56:57]
		s_mov_b32 s56, 0x440
		s_mov_b32 s57, 0
		s_mul_i32 s58, s56, s54
		s_mul_hi_u32 s59, s56, s54
		s_mul_i32 s33, s56, s55
		s_add_i32 s59, s59, s33
		s_mul_i32 s33, s57, s54
		s_add_i32 s59, s59, s33
		s_add_u32 s54, s58, 0x81f0
		s_addc_u32 s55, s59, 0
		s_mov_b32 s56, 0x4400
		s_mov_b32 s57, 0
		s_mul_i32 s60, s56, s52
		s_mul_hi_u32 s61, s56, s52
		s_mul_i32 s33, s56, s53
		s_add_i32 s61, s61, s33
		s_mul_i32 s33, s57, s52
		s_add_i32 s61, s61, s33
		s_add_u32 s52, s54, s60
		s_addc_u32 s53, s55, s61
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		v_accvgpr_read_b32 v14, a57
		v_add_u32_e32 v14, s1, v14
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[52:53], v13, s20
		s_add_i32 s33, s50, s23
		v_add_u32_e32 v12, s33, v2
		v_add3_u32 v12, v12, v15, v18
		v_add3_u32 v12, v12, v19, v11
		v_cndmask_b32_e64 v12, v23, v12, s[52:53]
		s_add_u32 s52, s58, 0x92f0
		s_addc_u32 s53, s59, 0
		s_add_u32 s52, s52, s60
		s_addc_u32 s53, s53, s61
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		v_accvgpr_read_b32 v13, a58
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[52:53], v14, s20
		s_add_i32 s33, s51, s23
		v_add_u32_e32 v12, s33, v2
		v_add3_u32 v12, v12, v15, v18
		v_add3_u32 v12, v12, v19, v11
		s_add_u32 s54, s58, 0xa3f0
		s_addc_u32 s55, s59, 0
		s_add_u32 s54, s54, s60
		s_addc_u32 s55, s55, s61
		s_add_u32 s56, s54, 0
		s_addc_u32 s57, s55, 0
		s_mov_b32 m0, s56
		v_cndmask_b32_e64 v12, v23, v12, s[52:53]
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
		s_add_i32 s23, s32, s23
		v_add_u32_e32 v12, s23, v2
		v_add3_u32 v12, v12, v15, v18
		v_cmp_lt_i32_e64 vcc, v13, s20
		v_add3_u32 v12, v12, v19, v11
		s_add_u32 s52, s58, 0xb4f0
		s_addc_u32 s53, s59, 0
		v_cndmask_b32_e32 v12, v23, v12, vcc
		s_add_u32 s52, s52, s60
		s_addc_u32 s53, s53, s61
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		s_nop 0
		buffer_load_dwordx4 v12, s[28:31], 0 offen lds
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
		v_add_u32_e32 v12, s39, v5
		v_mfma_f32_32x32x16_bf16 v[96:111], a[132:135], a[44:47], v[96:111]
		v_accvgpr_read_b32 v13, a14
		v_add_u32_e32 v13, s39, v13
		v_mfma_f32_32x32x16_bf16 v[192:207], a[148:151], a[44:47], v[192:207]
		v_accvgpr_read_b32 v14, a15
		v_add_u32_e32 v14, s39, v14
		v_mfma_f32_32x32x16_bf16 v[208:223], a[164:167], a[44:47], v[208:223]
		v_accvgpr_read_b32 v17, a62
		v_add_u32_e32 v17, s39, v17
		v_mfma_f32_32x32x16_bf16 v[112:127], a[136:139], a[32:35], v[112:127]
		v_cmp_ge_i32_e64 vcc, v3, v17
		v_mfma_f32_32x32x16_bf16 v[128:143], a[152:155], a[32:35], v[128:143]
		v_accvgpr_read_b32 v26, a69
		v_add_u32_e32 v26, s39, v26
		v_mfma_f32_32x32x16_bf16 v[144:159], a[168:171], a[32:35], v[144:159]
		v_accvgpr_read_b32 v27, a70
		v_add_u32_e32 v27, s39, v27
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[32:35], v[160:175]
		v_accvgpr_read_b32 v28, a73
		v_add_u32_e32 v28, s39, v28
		v_mfma_f32_32x32x16_bf16 v[176:191], a[180:183], a[48:51], v[176:191]
		v_accvgpr_read_b32 v29, a74
		v_add_u32_e32 v29, s39, v29
		v_mfma_f32_32x32x16_bf16 v[96:111], a[136:139], a[48:51], v[96:111]
		v_accvgpr_read_b32 v30, a77
		v_add_u32_e32 v30, s39, v30
		v_mfma_f32_32x32x16_bf16 v[192:207], a[152:155], a[48:51], v[192:207]
		v_cndmask_b32_e32 v225, v6, v115, vcc
		v_mfma_f32_32x32x16_bf16 v[208:223], a[168:171], a[48:51], v[208:223]
		v_accvgpr_read_b32 v31, a78
		v_add_u32_e32 v31, s39, v31
		v_accvgpr_read_b32 v115, a81
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a53, v115
		v_accvgpr_read_b32 v115, a82
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a59, v115
		v_accvgpr_read_b32 v115, a85
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a60, v115
		v_accvgpr_read_b32 v115, a86
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a61, v115
		v_accvgpr_read_b32 v115, a89
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a63, v115
		v_accvgpr_read_b32 v115, a90
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a65, v115
		v_accvgpr_read_b32 v115, a93
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a127, v115
		v_accvgpr_read_b32 v115, a94
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a128, v115
		v_accvgpr_read_b32 v115, a97
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a129, v115
		v_accvgpr_read_b32 v115, a98
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a130, v115
		v_accvgpr_read_b32 v115, a101
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a131, v115
		v_accvgpr_read_b32 v115, a102
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a132, v115
		v_accvgpr_read_b32 v115, a105
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a133, v115
		v_accvgpr_read_b32 v115, a106
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a134, v115
		v_accvgpr_read_b32 v115, a109
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a135, v115
		v_accvgpr_read_b32 v115, a110
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a136, v115
		v_accvgpr_read_b32 v115, a113
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a137, v115
		v_accvgpr_read_b32 v115, a114
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a138, v115
		v_accvgpr_read_b32 v115, a117
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a139, v115
		v_accvgpr_read_b32 v115, a118
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a140, v115
		v_accvgpr_read_b32 v115, a121
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a141, v115
		v_accvgpr_read_b32 v115, a122
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a142, v115
		v_accvgpr_read_b32 v115, a125
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a143, v115
		v_accvgpr_read_b32 v115, a126
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_write_b32 a144, v115
		v_cmp_ge_i32_e64 s[52:53], v3, v12
		v_cmp_ge_i32_e64 s[54:55], v3, v13
		v_cmp_ge_i32_e64 s[56:57], v3, v14
		v_accvgpr_read_b32 v115, a64
		v_add_u32_e32 v115, s39, v115
		v_accvgpr_read_b32 v224, a68
		v_add_u32_e32 v226, s39, v224
		v_cmp_ge_i32_e64 s[58:59], v3, v115
		v_cmp_ge_i32_e64 s[60:61], v3, v226
		v_cmp_ge_i32_e64 s[62:63], v3, v26
		v_cmp_ge_i32_e64 vcc, v3, v27
		v_accvgpr_read_b32 v224, a71
		v_add_u32_e32 v227, s39, v224
		v_accvgpr_read_b32 v224, a72
		v_add_u32_e32 v228, s39, v224
		v_cndmask_b32_e32 v231, v6, v119, vcc
		v_cmp_ge_i32_e64 s[64:65], v3, v227
		v_cmp_ge_i32_e64 s[66:67], v3, v228
		v_cmp_ge_i32_e64 s[68:69], v3, v28
		v_cmp_ge_i32_e64 vcc, v3, v29
		v_accvgpr_read_b32 v119, a75
		v_add_u32_e32 v119, s39, v119
		v_accvgpr_read_b32 v224, a76
		v_add_u32_e32 v229, s39, v224
		v_cndmask_b32_e32 v233, v6, v123, vcc
		v_cmp_ge_i32_e64 s[70:71], v3, v119
		v_cmp_ge_i32_e64 s[72:73], v3, v229
		v_cmp_ge_i32_e64 s[74:75], v3, v30
		v_cmp_ge_i32_e64 vcc, v3, v31
		v_accvgpr_read_b32 v123, a79
		v_add_u32_e32 v123, s39, v123
		v_accvgpr_read_b32 v224, a80
		v_add_u32_e32 v224, s39, v224
		v_accvgpr_write_b32 a145, v224
		v_cndmask_b32_e32 v235, v6, v127, vcc
		v_cmp_ge_i32_e64 s[76:77], v3, v123
		v_accvgpr_read_b32 v127, a145
		v_cmp_ge_i32_e64 s[78:79], v3, v127
		v_accvgpr_read_b32 v127, a53
		v_cmp_ge_i32_e64 s[80:81], v3, v127
		v_accvgpr_read_b32 v127, a59
		v_cmp_ge_i32_e64 vcc, v3, v127
		v_accvgpr_read_b32 v127, a83
		v_add_u32_e32 v127, s39, v127
		v_accvgpr_write_b32 a146, v127
		v_accvgpr_read_b32 v127, a84
		v_add_u32_e32 v127, s39, v127
		v_accvgpr_write_b32 a147, v127
		v_cndmask_b32_e32 v237, v6, v131, vcc
		v_accvgpr_read_b32 v127, a146
		v_cmp_ge_i32_e64 s[82:83], v3, v127
		v_accvgpr_read_b32 v127, a147
		v_cmp_ge_i32_e64 s[84:85], v3, v127
		v_accvgpr_read_b32 v127, a60
		v_cmp_ge_i32_e64 s[86:87], v3, v127
		v_accvgpr_read_b32 v127, a61
		v_cmp_ge_i32_e64 vcc, v3, v127
		v_accvgpr_read_b32 v127, a87
		v_add_u32_e32 v127, s39, v127
		v_accvgpr_write_b32 a148, v127
		v_accvgpr_read_b32 v127, a88
		v_add_u32_e32 v127, s39, v127
		v_accvgpr_write_b32 a149, v127
		v_cndmask_b32_e32 v239, v6, v135, vcc
		v_accvgpr_read_b32 v127, a148
		v_cmp_ge_i32_e64 s[88:89], v3, v127
		v_accvgpr_read_b32 v127, a149
		v_cmp_ge_i32_e64 s[90:91], v3, v127
		s_nop 1
		v_mov_b32_e32 v240, s90
		v_mov_b32_e32 v241, s91
		v_accvgpr_write_b32 a150, v240
		v_accvgpr_write_b32 a151, v241
		v_accvgpr_read_b32 v127, a65
		v_cmp_ge_i32_e64 vcc, v3, v127
		v_accvgpr_read_b32 v127, a91
		v_add_u32_e32 v127, s39, v127
		v_accvgpr_write_b32 a152, v127
		v_accvgpr_read_b32 v127, a92
		v_add_u32_e32 v127, s39, v127
		v_accvgpr_write_b32 a153, v127
		v_cndmask_b32_e32 v241, v6, v139, vcc
		v_accvgpr_read_b32 v127, a128
		v_cmp_ge_i32_e64 vcc, v3, v127
		v_accvgpr_read_b32 v127, a95
		v_add_u32_e32 v127, s39, v127
		v_accvgpr_write_b32 a154, v127
		v_accvgpr_read_b32 v127, a96
		v_add_u32_e32 v127, s39, v127
		v_accvgpr_write_b32 a155, v127
		v_cndmask_b32_e32 v243, v6, v143, vcc
		v_accvgpr_read_b32 v127, a130
		v_cmp_ge_i32_e64 vcc, v3, v127
		v_accvgpr_read_b32 v127, a99
		v_add_u32_e32 v127, s39, v127
		v_accvgpr_write_b32 a156, v127
		v_accvgpr_read_b32 v127, a100
		v_add_u32_e32 v127, s39, v127
		v_accvgpr_write_b32 a157, v127
		v_cndmask_b32_e32 v245, v6, v147, vcc
		v_accvgpr_read_b32 v127, a132
		v_cmp_ge_i32_e64 vcc, v3, v127
		v_accvgpr_read_b32 v127, a103
		v_add_u32_e32 v127, s39, v127
		v_accvgpr_write_b32 a158, v127
		v_accvgpr_read_b32 v127, a104
		v_add_u32_e32 v127, s39, v127
		v_accvgpr_write_b32 a159, v127
		v_cndmask_b32_e32 v247, v6, v151, vcc
		v_accvgpr_read_b32 v127, a134
		v_cmp_ge_i32_e64 vcc, v3, v127
		v_accvgpr_read_b32 v127, a107
		v_add_u32_e32 v127, s39, v127
		v_accvgpr_write_b32 a160, v127
		v_accvgpr_read_b32 v127, a108
		v_add_u32_e32 v127, s39, v127
		v_accvgpr_write_b32 a161, v127
		v_cndmask_b32_e32 v249, v6, v155, vcc
		v_accvgpr_read_b32 v127, a136
		v_cmp_ge_i32_e64 vcc, v3, v127
		v_accvgpr_read_b32 v127, a63
		v_cmp_ge_i32_e64 s[90:91], v3, v127
		s_nop 1
		v_mov_b32_e32 v250, s90
		v_mov_b32_e32 v251, s91
		v_accvgpr_write_b32 a162, v250
		v_accvgpr_write_b32 a163, v251
		v_cndmask_b32_e64 v250, v6, v112, s[52:53]
		v_accvgpr_read_b32 v112, a152
		v_cmp_ge_i32_e64 s[52:53], v3, v112
		s_nop 1
		v_mov_b32_e32 v252, s52
		v_mov_b32_e32 v253, s53
		v_accvgpr_write_b32 a164, v252
		v_accvgpr_write_b32 a165, v253
		v_accvgpr_read_b32 v112, a153
		v_cmp_ge_i32_e64 s[52:53], v3, v112
		s_nop 1
		v_mov_b32_e32 v252, s52
		v_mov_b32_e32 v253, s53
		v_accvgpr_write_b32 a166, v252
		v_accvgpr_write_b32 a167, v253
		v_accvgpr_read_b32 v112, a127
		v_cmp_ge_i32_e64 s[52:53], v3, v112
		s_nop 1
		v_mov_b32_e32 v252, s52
		v_mov_b32_e32 v253, s53
		v_accvgpr_write_b32 a168, v252
		v_accvgpr_write_b32 a169, v253
		v_accvgpr_read_b32 v112, a154
		v_cmp_ge_i32_e64 s[52:53], v3, v112
		s_nop 1
		v_mov_b32_e32 v252, s52
		v_mov_b32_e32 v253, s53
		v_accvgpr_write_b32 a170, v252
		v_accvgpr_write_b32 a171, v253
		v_accvgpr_read_b32 v112, a155
		v_cmp_ge_i32_e64 s[52:53], v3, v112
		s_nop 1
		v_mov_b32_e32 v252, s52
		v_mov_b32_e32 v253, s53
		v_accvgpr_write_b32 a172, v252
		v_accvgpr_write_b32 a173, v253
		v_accvgpr_read_b32 v112, a129
		v_cmp_ge_i32_e64 s[52:53], v3, v112
		s_nop 1
		v_mov_b32_e32 v252, s52
		v_mov_b32_e32 v253, s53
		v_accvgpr_write_b32 a174, v252
		v_accvgpr_write_b32 a175, v253
		v_accvgpr_read_b32 v112, a156
		v_cmp_ge_i32_e64 s[52:53], v3, v112
		s_nop 1
		v_mov_b32_e32 v252, s52
		v_mov_b32_e32 v253, s53
		v_accvgpr_write_b32 a176, v252
		v_accvgpr_write_b32 a177, v253
		v_accvgpr_read_b32 v112, a157
		v_cmp_ge_i32_e64 s[52:53], v3, v112
		s_nop 1
		v_mov_b32_e32 v252, s52
		v_mov_b32_e32 v253, s53
		v_accvgpr_write_b32 a178, v252
		v_accvgpr_write_b32 a179, v253
		v_accvgpr_read_b32 v112, a131
		v_cmp_ge_i32_e64 s[52:53], v3, v112
		s_nop 1
		v_mov_b32_e32 v252, s52
		v_mov_b32_e32 v253, s53
		v_accvgpr_write_b32 a180, v252
		v_accvgpr_write_b32 a181, v253
		v_accvgpr_read_b32 v112, a158
		v_cmp_ge_i32_e64 s[52:53], v3, v112
		s_nop 1
		v_mov_b32_e32 v252, s52
		v_mov_b32_e32 v253, s53
		v_accvgpr_write_b32 a182, v252
		v_accvgpr_write_b32 a183, v253
		v_accvgpr_read_b32 v112, a159
		v_cmp_ge_i32_e64 s[52:53], v3, v112
		s_nop 1
		v_mov_b32_e32 v252, s52
		v_mov_b32_e32 v253, s53
		v_accvgpr_write_b32 a248, v252
		v_accvgpr_write_b32 a249, v253
		v_accvgpr_read_b32 v112, a133
		v_cmp_ge_i32_e64 s[52:53], v3, v112
		s_nop 1
		v_mov_b32_e32 v252, s52
		v_mov_b32_e32 v253, s53
		v_accvgpr_write_b32 a250, v252
		v_accvgpr_write_b32 a251, v253
		v_accvgpr_read_b32 v112, a160
		v_cmp_ge_i32_e64 s[52:53], v3, v112
		v_accvgpr_read_b32 v112, a161
		v_cmp_ge_i32_e64 s[90:91], v3, v112
		v_accvgpr_read_b32 v112, a135
		v_cmp_ge_i32_e64 s[92:93], v3, v112
		v_cndmask_b32_e32 v253, v6, v159, vcc
		v_cndmask_b32_e64 v255, v6, v157, s[90:91]
		v_cndmask_b32_e64 v252, v6, v158, s[92:93]
		v_accvgpr_read_b32 v112, a111
		v_add_u32_e32 v112, s39, v112
		v_accvgpr_read_b32 v127, a112
		v_add_u32_e32 v127, s39, v127
		v_cmp_ge_i32_e64 s[90:91], v3, v112
		v_cmp_ge_i32_e64 s[92:93], v3, v127
		v_accvgpr_read_b32 v131, a137
		v_cmp_ge_i32_e64 s[94:95], v3, v131
		v_cndmask_b32_e64 v158, v6, v160, s[90:91]
		v_cndmask_b32_e64 v159, v6, v161, s[92:93]
		v_cndmask_b32_e64 v160, v6, v162, s[94:95]
		v_accvgpr_read_b32 v131, a138
		v_cmp_ge_i32_e64 vcc, v3, v131
		v_accvgpr_read_b32 v131, a115
		v_add_u32_e32 v131, s39, v131
		v_accvgpr_read_b32 v135, a116
		v_add_u32_e32 v135, s39, v135
		v_cndmask_b32_e32 v161, v6, v163, vcc
		v_cmp_ge_i32_e64 s[90:91], v3, v131
		v_cmp_ge_i32_e64 s[92:93], v3, v135
		v_accvgpr_read_b32 v139, a139
		v_cmp_ge_i32_e64 s[94:95], v3, v139
		v_cndmask_b32_e64 v162, v6, v164, s[90:91]
		v_cndmask_b32_e64 v163, v6, v165, s[92:93]
		v_cndmask_b32_e64 v164, v6, v166, s[94:95]
		v_accvgpr_read_b32 v139, a140
		v_cmp_ge_i32_e64 vcc, v3, v139
		v_accvgpr_read_b32 v139, a119
		v_add_u32_e32 v139, s39, v139
		v_accvgpr_read_b32 v143, a120
		v_add_u32_e32 v143, s39, v143
		v_cndmask_b32_e32 v165, v6, v167, vcc
		v_cmp_ge_i32_e64 s[90:91], v3, v139
		v_cmp_ge_i32_e64 s[92:93], v3, v143
		v_accvgpr_read_b32 v147, a141
		v_cmp_ge_i32_e64 s[94:95], v3, v147
		v_cndmask_b32_e64 v166, v6, v168, s[90:91]
		v_cndmask_b32_e64 v167, v6, v169, s[92:93]
		v_cndmask_b32_e64 v168, v6, v170, s[94:95]
		v_accvgpr_read_b32 v147, a142
		v_cmp_ge_i32_e64 vcc, v3, v147
		v_accvgpr_read_b32 v147, a123
		v_add_u32_e32 v147, s39, v147
		v_accvgpr_read_b32 v151, a124
		v_add_u32_e32 v151, s39, v151
		v_cndmask_b32_e32 v169, v6, v171, vcc
		v_cmp_ge_i32_e64 s[90:91], v3, v147
		v_cmp_ge_i32_e64 s[92:93], v3, v151
		v_accvgpr_read_b32 v155, a143
		v_cmp_ge_i32_e64 s[94:95], v3, v155
		v_cndmask_b32_e64 v170, v6, v172, s[90:91]
		v_cndmask_b32_e64 v171, v6, v173, s[92:93]
		v_cndmask_b32_e64 v172, v6, v174, s[94:95]
		v_cndmask_b32_e64 v251, v6, v113, s[54:55]
		v_accvgpr_read_b32 v113, a144
		v_cmp_ge_i32_e64 vcc, v3, v113
		v_max3_f32 v113, v158, v159, v160
		v_max3_f32 v155, v162, v163, v164
		v_cndmask_b32_e32 v173, v6, v175, vcc
		v_cmp_ge_i32_e64 s[54:55], v4, v12
		v_cmp_ge_i32_e64 s[90:91], v4, v13
		v_cmp_ge_i32_e64 s[92:93], v4, v14
		v_max3_f32 v12, v166, v167, v168
		v_accvgpr_write_b32 a252, v12
		v_max3_f32 v12, v170, v171, v172
		v_accvgpr_write_b32 a253, v12
		v_cndmask_b32_e64 v12, v6, v98, s[92:93]
		v_cmp_ge_i32_e64 vcc, v4, v17
		v_cndmask_b32_e64 v224, v6, v114, s[56:57]
		v_cndmask_b32_e64 v174, v6, v116, s[58:59]
		v_cndmask_b32_e32 v13, v6, v99, vcc
		v_cmp_ge_i32_e64 s[56:57], v4, v115
		v_cmp_ge_i32_e64 s[58:59], v4, v226
		v_cmp_ge_i32_e64 s[92:93], v4, v26
		v_cndmask_b32_e64 v98, v6, v100, s[56:57]
		v_cndmask_b32_e64 v99, v6, v101, s[58:59]
		v_cndmask_b32_e64 v100, v6, v102, s[92:93]
		v_cmp_ge_i32_e64 vcc, v4, v27
		v_cndmask_b32_e64 v175, v6, v117, s[60:61]
		v_cndmask_b32_e64 v230, v6, v118, s[62:63]
		v_cndmask_b32_e64 v26, v6, v120, s[64:65]
		v_cndmask_b32_e32 v101, v6, v103, vcc
		v_cmp_ge_i32_e64 s[56:57], v4, v227
		v_cmp_ge_i32_e64 s[58:59], v4, v228
		v_cmp_ge_i32_e64 s[60:61], v4, v28
		v_cndmask_b32_e64 v102, v6, v104, s[56:57]
		v_cndmask_b32_e64 v103, v6, v105, s[58:59]
		v_cndmask_b32_e64 v104, v6, v106, s[60:61]
		v_cmp_ge_i32_e64 vcc, v4, v29
		v_cndmask_b32_e64 v27, v6, v121, s[66:67]
		v_max3_f32 v14, v250, v251, v224
		v_cndmask_b32_e32 v105, v6, v107, vcc
		v_cmp_ge_i32_e64 s[56:57], v4, v119
		v_cmp_ge_i32_e64 s[58:59], v4, v229
		v_cmp_ge_i32_e64 s[60:61], v4, v30
		v_cndmask_b32_e64 v28, v6, v108, s[56:57]
		v_cndmask_b32_e64 v29, v6, v109, s[58:59]
		v_cndmask_b32_e64 v106, v6, v110, s[60:61]
		v_cmp_ge_i32_e64 vcc, v4, v31
		v_cndmask_b32_e64 v232, v6, v122, s[68:69]
		v_cndmask_b32_e64 v30, v6, v124, s[70:71]
		v_cndmask_b32_e32 v107, v6, v111, vcc
		v_cmp_ge_i32_e64 s[56:57], v4, v123
		v_accvgpr_read_b32 v17, a145
		v_cmp_ge_i32_e64 s[58:59], v4, v17
		v_accvgpr_read_b32 v17, a53
		v_cmp_ge_i32_e64 s[60:61], v4, v17
		v_cndmask_b32_e64 v108, v6, v192, s[56:57]
		v_cndmask_b32_e64 v109, v6, v193, s[58:59]
		v_cndmask_b32_e64 v110, v6, v194, s[60:61]
		v_accvgpr_read_b32 v17, a59
		v_cmp_ge_i32_e64 vcc, v4, v17
		v_cndmask_b32_e64 v31, v6, v125, s[72:73]
		v_cndmask_b32_e64 v234, v6, v126, s[74:75]
		v_cndmask_b32_e64 v114, v6, v128, s[76:77]
		v_cndmask_b32_e32 v111, v6, v195, vcc
		v_accvgpr_read_b32 v17, a146
		v_cmp_ge_i32_e64 s[56:57], v4, v17
		v_accvgpr_read_b32 v17, a147
		v_cmp_ge_i32_e64 s[58:59], v4, v17
		v_accvgpr_read_b32 v17, a60
		v_cmp_ge_i32_e64 s[60:61], v4, v17
		v_cndmask_b32_e64 v116, v6, v196, s[56:57]
		v_cndmask_b32_e64 v117, v6, v197, s[58:59]
		v_cndmask_b32_e64 v118, v6, v198, s[60:61]
		v_accvgpr_read_b32 v17, a61
		v_cmp_ge_i32_e64 vcc, v4, v17
		v_cndmask_b32_e64 v115, v6, v129, s[78:79]
		v_max3_f32 v17, v174, v175, v230
		v_cndmask_b32_e32 v119, v6, v199, vcc
		v_accvgpr_read_b32 v120, a148
		v_cmp_ge_i32_e64 s[56:57], v4, v120
		v_accvgpr_read_b32 v120, a149
		v_cmp_ge_i32_e64 s[58:59], v4, v120
		v_accvgpr_read_b32 v120, a63
		v_cmp_ge_i32_e64 s[60:61], v4, v120
		v_cndmask_b32_e64 v120, v6, v200, s[56:57]
		v_cndmask_b32_e64 v121, v6, v201, s[58:59]
		v_cndmask_b32_e64 v122, v6, v202, s[60:61]
		v_accvgpr_read_b32 v123, a65
		v_cmp_ge_i32_e64 vcc, v4, v123
		v_cndmask_b32_e64 v236, v6, v130, s[80:81]
		v_cndmask_b32_e64 v124, v6, v132, s[82:83]
		v_cndmask_b32_e32 v123, v6, v203, vcc
		v_accvgpr_read_b32 v125, a128
		v_cmp_ge_i32_e64 vcc, v4, v125
		v_accvgpr_read_b32 v125, a152
		v_cmp_ge_i32_e64 s[56:57], v4, v125
		v_accvgpr_read_b32 v125, a153
		v_cmp_ge_i32_e64 s[58:59], v4, v125
		v_accvgpr_read_b32 v125, a127
		v_cmp_ge_i32_e64 s[60:61], v4, v125
		v_cndmask_b32_e64 v128, v6, v204, s[56:57]
		v_cndmask_b32_e64 v129, v6, v205, s[58:59]
		v_cndmask_b32_e64 v192, v6, v206, s[60:61]
		v_cndmask_b32_e64 v125, v6, v133, s[84:85]
		v_cndmask_b32_e64 v238, v6, v134, s[86:87]
		v_cndmask_b32_e32 v193, v6, v207, vcc
		v_accvgpr_read_b32 v126, a154
		v_cmp_ge_i32_e64 s[56:57], v4, v126
		v_accvgpr_read_b32 v126, a155
		v_cmp_ge_i32_e64 s[58:59], v4, v126
		v_accvgpr_read_b32 v126, a130
		v_cmp_ge_i32_e64 vcc, v4, v126
		v_accvgpr_read_b32 v126, a129
		v_cmp_ge_i32_e64 s[60:61], v4, v126
		v_cndmask_b32_e64 v132, v6, v208, s[56:57]
		v_cndmask_b32_e64 v133, v6, v209, s[58:59]
		v_cndmask_b32_e64 v194, v6, v210, s[60:61]
		v_cndmask_b32_e64 v196, v6, v136, s[88:89]
		v_accvgpr_read_b32 v126, a150
		s_nop 0
		v_readfirstlane_b32 s56, v126
		v_accvgpr_read_b32 v126, a151
		s_nop 0
		v_readfirstlane_b32 s57, v126
		s_nop 1
		v_cndmask_b32_e64 v197, v6, v137, s[56:57]
		v_cndmask_b32_e32 v195, v6, v211, vcc
		v_accvgpr_read_b32 v126, a156
		v_cmp_ge_i32_e64 s[56:57], v4, v126
		v_accvgpr_read_b32 v126, a157
		v_cmp_ge_i32_e64 s[58:59], v4, v126
		v_accvgpr_read_b32 v126, a131
		v_cmp_ge_i32_e64 s[60:61], v4, v126
		v_cndmask_b32_e64 v136, v6, v212, s[56:57]
		v_cndmask_b32_e64 v137, v6, v213, s[58:59]
		v_cndmask_b32_e64 v198, v6, v214, s[60:61]
		v_accvgpr_read_b32 v126, a132
		v_cmp_ge_i32_e64 vcc, v4, v126
		v_accvgpr_read_b32 v126, a162
		s_nop 0
		v_readfirstlane_b32 s56, v126
		v_accvgpr_read_b32 v126, a163
		s_nop 0
		v_readfirstlane_b32 s57, v126
		s_nop 1
		v_cndmask_b32_e64 v240, v6, v138, s[56:57]
		v_accvgpr_read_b32 v126, a164
		s_nop 0
		v_readfirstlane_b32 s56, v126
		v_accvgpr_read_b32 v126, a165
		s_nop 0
		v_readfirstlane_b32 s57, v126
		s_nop 1
		v_cndmask_b32_e64 v200, v6, v140, s[56:57]
		v_cndmask_b32_e32 v199, v6, v215, vcc
		v_accvgpr_read_b32 v126, a158
		v_cmp_ge_i32_e64 s[56:57], v4, v126
		v_accvgpr_read_b32 v126, a159
		v_cmp_ge_i32_e64 s[58:59], v4, v126
		v_accvgpr_read_b32 v126, a133
		v_cmp_ge_i32_e64 s[60:61], v4, v126
		v_cndmask_b32_e64 v202, v6, v216, s[56:57]
		v_cndmask_b32_e64 v203, v6, v217, s[58:59]
		v_cndmask_b32_e64 v204, v6, v218, s[60:61]
		v_accvgpr_read_b32 v126, a134
		v_cmp_ge_i32_e64 vcc, v4, v126
		v_accvgpr_read_b32 v126, a166
		s_nop 0
		v_readfirstlane_b32 s56, v126
		v_accvgpr_read_b32 v126, a167
		s_nop 0
		v_readfirstlane_b32 s57, v126
		s_nop 1
		v_cndmask_b32_e64 v201, v6, v141, s[56:57]
		v_accvgpr_read_b32 v126, a168
		s_nop 0
		v_readfirstlane_b32 s56, v126
		v_accvgpr_read_b32 v126, a169
		s_nop 0
		v_readfirstlane_b32 s57, v126
		s_nop 1
		v_cndmask_b32_e64 v242, v6, v142, s[56:57]
		v_cndmask_b32_e32 v205, v6, v219, vcc
		v_accvgpr_read_b32 v126, a160
		v_cmp_ge_i32_e64 s[56:57], v4, v126
		v_accvgpr_read_b32 v126, a161
		v_cmp_ge_i32_e64 s[58:59], v4, v126
		v_accvgpr_read_b32 v126, a135
		v_cmp_ge_i32_e64 s[60:61], v4, v126
		v_cndmask_b32_e64 v140, v6, v220, s[56:57]
		v_cndmask_b32_e64 v141, v6, v221, s[58:59]
		v_cndmask_b32_e64 v206, v6, v222, s[60:61]
		v_accvgpr_read_b32 v126, a136
		v_cmp_ge_i32_e64 vcc, v4, v126
		v_accvgpr_read_b32 v126, a170
		s_nop 0
		v_readfirstlane_b32 s56, v126
		v_accvgpr_read_b32 v126, a171
		s_nop 0
		v_readfirstlane_b32 s57, v126
		s_nop 1
		v_cndmask_b32_e64 v208, v6, v144, s[56:57]
		v_accvgpr_read_b32 v126, a172
		s_nop 0
		v_readfirstlane_b32 s56, v126
		v_accvgpr_read_b32 v126, a173
		s_nop 0
		v_readfirstlane_b32 s57, v126
		s_nop 1
		v_cndmask_b32_e64 v209, v6, v145, s[56:57]
		v_cndmask_b32_e32 v207, v6, v223, vcc
		v_cmp_ge_i32_e64 s[56:57], v4, v112
		v_cmp_ge_i32_e64 s[58:59], v4, v127
		v_accvgpr_read_b32 v112, a137
		v_cmp_ge_i32_e64 s[60:61], v4, v112
		v_cndmask_b32_e64 v126, v6, v176, s[56:57]
		v_cndmask_b32_e64 v127, v6, v177, s[58:59]
		v_cndmask_b32_e64 v144, v6, v178, s[60:61]
		v_accvgpr_read_b32 v112, a138
		v_cmp_ge_i32_e64 vcc, v4, v112
		v_accvgpr_read_b32 v112, a174
		s_nop 0
		v_readfirstlane_b32 s56, v112
		v_accvgpr_read_b32 v112, a175
		s_nop 0
		v_readfirstlane_b32 s57, v112
		s_nop 1
		v_cndmask_b32_e64 v244, v6, v146, s[56:57]
		v_accvgpr_read_b32 v112, a176
		s_nop 0
		v_readfirstlane_b32 s56, v112
		v_accvgpr_read_b32 v112, a177
		s_nop 0
		v_readfirstlane_b32 s57, v112
		s_nop 1
		v_cndmask_b32_e64 v176, v6, v148, s[56:57]
		v_cndmask_b32_e32 v145, v6, v179, vcc
		v_cmp_ge_i32_e64 s[56:57], v4, v131
		v_cmp_ge_i32_e64 s[58:59], v4, v135
		v_accvgpr_read_b32 v112, a139
		v_cmp_ge_i32_e64 s[60:61], v4, v112
		v_cndmask_b32_e64 v130, v6, v180, s[56:57]
		v_cndmask_b32_e64 v131, v6, v181, s[58:59]
		v_cndmask_b32_e64 v134, v6, v182, s[60:61]
		v_accvgpr_read_b32 v112, a140
		v_cmp_ge_i32_e64 vcc, v4, v112
		v_accvgpr_read_b32 v112, a178
		s_nop 0
		v_readfirstlane_b32 s56, v112
		v_accvgpr_read_b32 v112, a179
		s_nop 0
		v_readfirstlane_b32 s57, v112
		s_nop 1
		v_cndmask_b32_e64 v177, v6, v149, s[56:57]
		v_accvgpr_read_b32 v112, a180
		s_nop 0
		v_readfirstlane_b32 s56, v112
		v_accvgpr_read_b32 v112, a181
		s_nop 0
		v_readfirstlane_b32 s57, v112
		s_nop 1
		v_cndmask_b32_e64 v246, v6, v150, s[56:57]
		v_cndmask_b32_e32 v135, v6, v183, vcc
		v_cmp_ge_i32_e64 s[56:57], v4, v139
		v_cmp_ge_i32_e64 s[58:59], v4, v143
		v_accvgpr_read_b32 v112, a141
		v_cmp_ge_i32_e64 s[60:61], v4, v112
		v_cndmask_b32_e64 v138, v6, v184, s[56:57]
		v_cndmask_b32_e64 v139, v6, v185, s[58:59]
		v_cndmask_b32_e64 v142, v6, v186, s[60:61]
		v_accvgpr_read_b32 v112, a142
		v_cmp_ge_i32_e64 vcc, v4, v112
		v_accvgpr_read_b32 v112, a182
		s_nop 0
		v_readfirstlane_b32 s56, v112
		v_accvgpr_read_b32 v112, a183
		s_nop 0
		v_readfirstlane_b32 s57, v112
		s_nop 1
		v_cndmask_b32_e64 v148, v6, v152, s[56:57]
		v_accvgpr_read_b32 v112, a248
		s_nop 0
		v_readfirstlane_b32 s56, v112
		v_accvgpr_read_b32 v112, a249
		s_nop 0
		v_readfirstlane_b32 s57, v112
		s_nop 1
		v_cndmask_b32_e64 v149, v6, v153, s[56:57]
		v_cndmask_b32_e32 v143, v6, v187, vcc
		v_cmp_ge_i32_e64 s[56:57], v4, v147
		v_cmp_ge_i32_e64 s[58:59], v4, v151
		v_accvgpr_read_b32 v112, a143
		v_cmp_ge_i32_e64 s[60:61], v4, v112
		v_cndmask_b32_e64 v146, v6, v188, s[56:57]
		v_cndmask_b32_e64 v147, v6, v189, s[58:59]
		v_cndmask_b32_e64 v150, v6, v190, s[60:61]
		v_accvgpr_read_b32 v112, a144
		v_cmp_ge_i32_e64 vcc, v4, v112
		v_accvgpr_read_b32 v112, a250
		s_nop 0
		v_readfirstlane_b32 s56, v112
		v_accvgpr_read_b32 v112, a251
		s_nop 0
		v_readfirstlane_b32 s57, v112
		s_nop 1
		v_cndmask_b32_e64 v248, v6, v154, s[56:57]
		v_cndmask_b32_e64 v254, v6, v156, s[52:53]
		v_cndmask_b32_e32 v151, v6, v191, vcc
		v_max3_f32 v112, v26, v27, v232
		v_max3_f32 v152, v30, v31, v234
		v_max3_f32 v153, v114, v115, v236
		v_max3_f32 v154, v124, v125, v238
		v_max3_f32 v156, v196, v197, v240
		v_max3_f32 v157, v200, v201, v242
		v_max3_f32 v178, v208, v209, v244
		v_max3_f32 v179, v176, v177, v246
		v_max3_f32 v180, v148, v149, v248
		v_max3_f32 v181, v254, v255, v252
		v_max3_f32 v14, v14, v225, v17
		v_max3_f32 v17, v112, v233, v152
		v_max3_f32 v112, v153, v237, v154
		v_max3_f32 v152, v156, v241, v157
		v_max3_f32 v153, v178, v245, v179
		v_max3_f32 v154, v180, v249, v181
		v_max3_f32 v113, v113, v161, v155
		v_accvgpr_read_b32 v155, a252
		v_accvgpr_read_b32 v156, a253
		v_max3_f32 v155, v155, v169, v156
		v_max3_f32 v14, v14, v231, v17
		v_max3_f32 v17, v112, v239, v152
		v_max3_f32 v112, v153, v247, v154
		v_max3_f32 v113, v113, v165, v155
		v_max3_f32 v14, v14, v235, v17
		v_max3_f32 v17, v112, v253, v113
		v_max3_f32 v14, v14, v243, v17
		v_max_f32_e32 v112, v14, v173
		v_mov_b32_e32 v113, v112
		v_cndmask_b32_e64 v152, v6, v96, s[54:55]
		v_cndmask_b32_e64 v153, v6, v97, s[90:91]
		v_permlane32_swap_b32_e32 v112, v113
		v_max3_f32 v14, v152, v153, v12
		v_max3_f32 v17, v98, v99, v100
		v_max3_f32 v96, v102, v103, v104
		v_max3_f32 v97, v28, v29, v106
		v_max3_f32 v154, v108, v109, v110
		v_max3_f32 v155, v116, v117, v118
		v_max3_f32 v156, v120, v121, v122
		v_max3_f32 v157, v128, v129, v192
		v_max3_f32 v178, v132, v133, v194
		v_max3_f32 v179, v136, v137, v198
		v_max3_f32 v180, v202, v203, v204
		v_max3_f32 v181, v140, v141, v206
		v_max3_f32 v182, v126, v127, v144
		v_max3_f32 v183, v130, v131, v134
		v_max3_f32 v184, v138, v139, v142
		v_max3_f32 v185, v146, v147, v150
		v_max3_f32 v14, v14, v13, v17
		v_max3_f32 v17, v96, v105, v97
		v_max3_f32 v96, v154, v111, v155
		v_max3_f32 v97, v156, v123, v157
		v_max3_f32 v154, v178, v195, v179
		v_max3_f32 v155, v180, v205, v181
		v_max3_f32 v156, v182, v145, v183
		v_max3_f32 v157, v184, v143, v185
		v_max3_f32 v14, v14, v101, v17
		v_max3_f32 v17, v96, v119, v97
		v_max3_f32 v96, v154, v199, v155
		v_max3_f32 v97, v156, v135, v157
		v_max3_f32 v14, v14, v107, v17
		v_max3_f32 v17, v96, v207, v97
		v_max3_f32 v14, v14, v193, v17
		v_max_f32_e32 v96, v14, v151
		v_mov_b32_e32 v97, v96
		v_max_f32_e32 v154, v112, v113
		v_mov_b32_e32 v112, v7
		v_permlane32_swap_b32_e32 v96, v97
		v_max_f32_e32 v155, v96, v97
		v_pk_mul_f32 v[96:97], v[154:155], v[8:9]
		v_max_f32_e32 v154, v7, v96
		v_max_f32_e32 v155, v10, v97
		v_pk_fma_f32 v[96:97], v[250:251], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[224:225], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[174:175], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[230:231], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[26:27], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[232:233], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[30:31], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[234:235], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[114:115], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[236:237], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[124:125], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[238:239], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[196:197], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[240:241], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[200:201], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[242:243], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[208:209], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[244:245], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[176:177], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[246:247], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[148:149], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[248:249], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[254:255], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[218:219], v[252:253], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[220:221], v[158:159], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[160:161], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[162:163], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[164:165], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[166:167], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[168:169], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[170:171], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[172:173], v[8:9], v[154:155] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[152:153], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[12:13], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[12:13], v[98:99], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[28:29], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[106:107], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[108:109], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[110:111], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[116:117], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[118:119], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[120:121], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[122:123], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[128:129], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[192:193], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[132:133], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[194:195], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[136:137], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[198:199], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[202:203], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[204:205], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[140:141], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[206:207], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[126:127], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[144:145], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[130:131], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[134:135], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[138:139], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[142:143], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[146:147], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[150:151], v[8:9], v[154:155] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v150, v96
		v_exp_f32_e32 v222, v97
		v_exp_f32_e32 v96, v156
		v_exp_f32_e32 v224, v157
		v_exp_f32_e32 v156, v178
		v_exp_f32_e32 v226, v179
		v_exp_f32_e32 v178, v174
		v_exp_f32_e32 v228, v175
		v_exp_f32_e32 v174, v180
		v_exp_f32_e32 v230, v181
		v_exp_f32_e32 v180, v26
		v_exp_f32_e32 v232, v27
		v_exp_f32_e32 v26, v182
		v_exp_f32_e32 v234, v183
		v_exp_f32_e32 v182, v30
		v_exp_f32_e32 v236, v31
		v_exp_f32_e32 v30, v184
		v_exp_f32_e32 v238, v185
		v_exp_f32_e32 v184, v114
		v_exp_f32_e32 v240, v115
		v_exp_f32_e32 v114, v186
		v_exp_f32_e32 v242, v187
		v_exp_f32_e32 v186, v124
		v_exp_f32_e32 v244, v125
		v_exp_f32_e32 v124, v188
		v_exp_f32_e32 v246, v189
		v_exp_f32_e32 v188, v190
		v_exp_f32_e32 v248, v191
		v_exp_f32_e32 v190, v196
		v_exp_f32_e32 v250, v197
		v_exp_f32_e32 v196, v200
		v_exp_f32_e32 v252, v201
		v_exp_f32_e32 v151, v210
		v_exp_f32_e32 v223, v211
		v_exp_f32_e32 v97, v208
		v_exp_f32_e32 v225, v209
		v_exp_f32_e32 v157, v212
		v_exp_f32_e32 v227, v213
		v_exp_f32_e32 v179, v176
		v_exp_f32_e32 v229, v177
		v_exp_f32_e32 v175, v214
		v_exp_f32_e32 v231, v215
		v_exp_f32_e32 v181, v148
		v_exp_f32_e32 v233, v149
		v_exp_f32_e32 v27, v216
		v_exp_f32_e32 v235, v217
		v_exp_f32_e32 v183, v218
		v_exp_f32_e32 v237, v219
		v_exp_f32_e32 v31, v220
		v_exp_f32_e32 v239, v221
		v_exp_f32_e32 v185, v158
		v_exp_f32_e32 v241, v159
		v_exp_f32_e32 v115, v160
		v_exp_f32_e32 v243, v161
		v_exp_f32_e32 v187, v162
		v_exp_f32_e32 v245, v163
		v_exp_f32_e32 v125, v164
		v_exp_f32_e32 v247, v165
		v_exp_f32_e32 v189, v166
		v_exp_f32_e32 v249, v167
		v_exp_f32_e32 v191, v168
		v_exp_f32_e32 v251, v169
		v_exp_f32_e32 v197, v170
		v_exp_f32_e32 v253, v171
		v_exp_f32_e32 v148, v172
		v_exp_f32_e32 v158, v173
		v_exp_f32_e32 v160, v152
		v_exp_f32_e32 v162, v153
		v_exp_f32_e32 v152, v12
		v_exp_f32_e32 v164, v13
		v_exp_f32_e32 v12, v98
		v_exp_f32_e32 v166, v99
		v_exp_f32_e32 v98, v100
		v_exp_f32_e32 v168, v101
		v_exp_f32_e32 v100, v102
		v_exp_f32_e32 v170, v103
		v_exp_f32_e32 v102, v104
		v_exp_f32_e32 v172, v105
		v_exp_f32_e32 v104, v28
		v_exp_f32_e32 v176, v29
		v_exp_f32_e32 v28, v106
		v_exp_f32_e32 v200, v107
		v_exp_f32_e32 v106, v108
		v_exp_f32_e32 v208, v109
		v_exp_f32_e32 v108, v110
		v_exp_f32_e32 v210, v111
		v_exp_f32_e32 v110, v116
		v_exp_f32_e32 v212, v117
		v_exp_f32_e32 v116, v118
		v_exp_f32_e32 v214, v119
		v_exp_f32_e32 v118, v120
		v_exp_f32_e32 v216, v121
		v_exp_f32_e32 v120, v122
		v_exp_f32_e32 v218, v123
		v_exp_f32_e32 v122, v128
		v_exp_f32_e32 v220, v129
		v_exp_f32_e32 v149, v192
		v_exp_f32_e32 v159, v193
		v_exp_f32_e32 v161, v132
		v_exp_f32_e32 v163, v133
		v_exp_f32_e32 v153, v194
		v_exp_f32_e32 v165, v195
		v_exp_f32_e32 v13, v136
		v_exp_f32_e32 v167, v137
		v_exp_f32_e32 v99, v198
		v_exp_f32_e32 v169, v199
		v_exp_f32_e32 v101, v202
		v_exp_f32_e32 v171, v203
		v_exp_f32_e32 v103, v204
		v_exp_f32_e32 v173, v205
		v_exp_f32_e32 v105, v140
		v_exp_f32_e32 v177, v141
		v_exp_f32_e32 v29, v206
		v_exp_f32_e32 v201, v207
		v_exp_f32_e32 v107, v126
		v_exp_f32_e32 v209, v127
		v_exp_f32_e32 v109, v144
		v_exp_f32_e32 v211, v145
		v_exp_f32_e32 v111, v130
		v_exp_f32_e32 v213, v131
		v_exp_f32_e32 v117, v134
		v_exp_f32_e32 v215, v135
		v_exp_f32_e32 v119, v138
		v_exp_f32_e32 v217, v139
		v_exp_f32_e32 v121, v142
		v_exp_f32_e32 v219, v143
		v_exp_f32_e32 v123, v146
		v_exp_f32_e32 v221, v147
		v_pk_add_f32 v[126:127], v[150:151], v[222:223]
		v_pk_add_f32 v[128:129], v[96:97], v[224:225]
		v_pk_add_f32 v[130:131], v[156:157], v[226:227]
		v_pk_add_f32 v[132:133], v[178:179], v[228:229]
		v_pk_add_f32 v[134:135], v[174:175], v[230:231]
		v_pk_add_f32 v[136:137], v[180:181], v[232:233]
		v_pk_add_f32 v[138:139], v[26:27], v[234:235]
		v_pk_add_f32 v[140:141], v[182:183], v[236:237]
		v_pk_add_f32 v[142:143], v[30:31], v[238:239]
		v_pk_add_f32 v[144:145], v[184:185], v[240:241]
		v_pk_add_f32 v[146:147], v[114:115], v[242:243]
		v_pk_add_f32 v[192:193], v[186:187], v[244:245]
		v_pk_add_f32 v[194:195], v[124:125], v[246:247]
		v_pk_add_f32 v[198:199], v[188:189], v[248:249]
		v_pk_add_f32 v[202:203], v[190:191], v[250:251]
		v_pk_add_f32 v[204:205], v[196:197], v[252:253]
		v_pk_add_f32 v[126:127], v[126:127], v[128:129]
		v_pk_add_f32 v[128:129], v[130:131], v[132:133]
		v_pk_add_f32 v[130:131], v[134:135], v[136:137]
		v_pk_add_f32 v[132:133], v[138:139], v[140:141]
		v_pk_add_f32 v[134:135], v[142:143], v[144:145]
		v_pk_add_f32 v[136:137], v[146:147], v[192:193]
		v_pk_add_f32 v[138:139], v[194:195], v[198:199]
		v_pk_add_f32 v[140:141], v[202:203], v[204:205]
		v_pk_add_f32 v[126:127], v[126:127], v[128:129]
		v_pk_add_f32 v[128:129], v[130:131], v[132:133]
		v_pk_add_f32 v[130:131], v[134:135], v[136:137]
		v_pk_add_f32 v[132:133], v[138:139], v[140:141]
		v_pk_add_f32 v[126:127], v[126:127], v[128:129]
		v_pk_add_f32 v[128:129], v[130:131], v[132:133]
		v_pk_add_f32 v[130:131], v[126:127], v[128:129]
		v_add_f32_e32 v7, v130, v131
		v_accvgpr_read_b32 v14, a66
		ds_bpermute_b32 v126, v14, v7
		v_accvgpr_read_b32 v14, a67
		ds_bpermute_b32 v128, v14, v7
		v_pk_add_f32 v[130:131], v[148:149], v[158:159]
		v_pk_add_f32 v[132:133], v[160:161], v[162:163]
		v_pk_add_f32 v[134:135], v[152:153], v[164:165]
		v_pk_add_f32 v[136:137], v[12:13], v[166:167]
		v_pk_add_f32 v[138:139], v[98:99], v[168:169]
		v_pk_add_f32 v[140:141], v[100:101], v[170:171]
		v_pk_add_f32 v[142:143], v[102:103], v[172:173]
		v_pk_add_f32 v[144:145], v[104:105], v[176:177]
		v_pk_add_f32 v[146:147], v[28:29], v[200:201]
		v_pk_add_f32 v[192:193], v[106:107], v[208:209]
		v_pk_add_f32 v[194:195], v[108:109], v[210:211]
		v_pk_add_f32 v[198:199], v[110:111], v[212:213]
		v_pk_add_f32 v[202:203], v[116:117], v[214:215]
		v_pk_add_f32 v[204:205], v[118:119], v[216:217]
		v_pk_add_f32 v[206:207], v[120:121], v[218:219]
		v_pk_add_f32 v[254:255], v[122:123], v[220:221]
		v_pk_add_f32 v[130:131], v[130:131], v[132:133]
		v_pk_add_f32 v[132:133], v[134:135], v[136:137]
		v_pk_add_f32 v[134:135], v[138:139], v[140:141]
		v_pk_add_f32 v[136:137], v[142:143], v[144:145]
		v_pk_add_f32 v[138:139], v[146:147], v[192:193]
		v_pk_add_f32 v[140:141], v[194:195], v[198:199]
		v_pk_add_f32 v[142:143], v[202:203], v[204:205]
		v_pk_add_f32 v[144:145], v[206:207], v[254:255]
		v_pk_add_f32 v[130:131], v[130:131], v[132:133]
		v_pk_add_f32 v[132:133], v[134:135], v[136:137]
		v_pk_add_f32 v[134:135], v[138:139], v[140:141]
		v_pk_add_f32 v[136:137], v[142:143], v[144:145]
		v_pk_add_f32 v[130:131], v[130:131], v[132:133]
		v_pk_add_f32 v[132:133], v[134:135], v[136:137]
		v_pk_add_f32 v[134:135], v[130:131], v[132:133]
		v_mov_b32_e32 v129, v135
		v_mov_b32_e32 v127, v134
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[130:131], v[126:127], v[128:129]
		v_mov_b32_e32 v126, v131
		v_mov_b32_e32 v127, v131
		v_cvt_pk_bf16_f32 v132, v150, v222
		v_cvt_pk_bf16_f32 v133, v96, v224
		v_permlane32_swap_b32_e32 v126, v127
		v_add_f32_e32 v129, v126, v127
		v_mov_b32_e32 v113, v10
		v_pk_add_f32 v[126:127], v[112:113], v[154:155] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v112, v126
		v_exp_f32_e32 v113, v127
		v_cvt_pk_bf16_f32 v134, v156, v226
		v_pk_mul_f32 v[32:33], v[32:33], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[34:35], v[34:35], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[36:37], v[36:37], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[38:39], v[38:39], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[40:41], v[40:41], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[42:43], v[42:43], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[44:45], v[44:45], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[46:47], v[46:47], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[48:49], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[50:51], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[52:53], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[54:55], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[56:57], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[58:59], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[60:61], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[62:63], v[112:113] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[64:65], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[66:67], v[66:67], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[68:69], v[68:69], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[70:71], v[70:71], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[72:73], v[72:73], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[74:75], v[74:75], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[76:77], v[76:77], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[78:79], v[78:79], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[80:81], v[80:81], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[82:83], v[82:83], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[84:85], v[84:85], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[86:87], v[86:87], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[88:89], v[88:89], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[90:91], v[90:91], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[92:93], v[92:93], v[112:113] op_sel:[0,1]
		v_pk_mul_f32 v[94:95], v[94:95], v[112:113] op_sel:[0,1]
		v_mov_b32_e32 v128, v130
		v_mov_b64_e32 v[126:127], v[24:25]
		v_pk_fma_f32 v[24:25], v[126:127], v[112:113], v[128:129]
		v_cvt_pk_bf16_f32 v135, v178, v228
		v_cvt_pk_bf16_f32 v128, v174, v230
		v_cvt_pk_bf16_f32 v129, v180, v232
		v_cvt_pk_bf16_f32 v130, v26, v234
		v_cvt_pk_bf16_f32 v131, v182, v236
		v_cvt_pk_bf16_f32 v136, v30, v238
		v_cvt_pk_bf16_f32 v137, v184, v240
		v_cvt_pk_bf16_f32 v138, v114, v242
		v_cvt_pk_bf16_f32 v139, v186, v244
		v_cvt_pk_bf16_f32 v140, v124, v246
		v_cvt_pk_bf16_f32 v141, v188, v248
		v_cvt_pk_bf16_f32 v142, v190, v250
		v_cvt_pk_bf16_f32 v143, v196, v252
		v_cvt_pk_bf16_f32 v144, v151, v223
		v_cvt_pk_bf16_f32 v145, v97, v225
		v_cvt_pk_bf16_f32 v146, v157, v227
		v_cvt_pk_bf16_f32 v147, v179, v229
		v_cvt_pk_bf16_f32 v192, v175, v231
		v_cvt_pk_bf16_f32 v193, v181, v233
		v_cvt_pk_bf16_f32 v194, v27, v235
		v_cvt_pk_bf16_f32 v195, v183, v237
		v_cvt_pk_bf16_f32 v180, v31, v239
		v_cvt_pk_bf16_f32 v181, v185, v241
		v_cvt_pk_bf16_f32 v182, v115, v243
		v_cvt_pk_bf16_f32 v183, v187, v245
		v_cvt_pk_bf16_f32 v112, v125, v247
		v_cvt_pk_bf16_f32 v113, v189, v249
		v_cvt_pk_bf16_f32 v114, v191, v251
		v_cvt_pk_bf16_f32 v115, v197, v253
		v_cvt_pk_bf16_f32 v124, v148, v158
		v_cvt_pk_bf16_f32 v125, v160, v162
		v_cvt_pk_bf16_f32 v126, v152, v164
		v_cvt_pk_bf16_f32 v127, v12, v166
		v_cvt_pk_bf16_f32 v184, v98, v168
		v_cvt_pk_bf16_f32 v185, v100, v170
		v_cvt_pk_bf16_f32 v186, v102, v172
		v_cvt_pk_bf16_f32 v187, v104, v176
		v_cvt_pk_bf16_f32 v188, v28, v200
		v_cvt_pk_bf16_f32 v189, v106, v208
		v_cvt_pk_bf16_f32 v190, v108, v210
		v_cvt_pk_bf16_f32 v191, v110, v212
		v_cvt_pk_bf16_f32 v196, v116, v214
		v_cvt_pk_bf16_f32 v197, v118, v216
		v_cvt_pk_bf16_f32 v198, v120, v218
		v_cvt_pk_bf16_f32 v199, v122, v220
		v_cvt_pk_bf16_f32 v204, v149, v159
		v_cvt_pk_bf16_f32 v205, v161, v163
		v_cvt_pk_bf16_f32 v206, v153, v165
		v_cvt_pk_bf16_f32 v207, v13, v167
		v_cvt_pk_bf16_f32 v148, v99, v169
		v_cvt_pk_bf16_f32 v149, v101, v171
		v_cvt_pk_bf16_f32 v150, v103, v173
		v_cvt_pk_bf16_f32 v151, v105, v177
		v_cvt_pk_bf16_f32 v96, v29, v201
		v_cvt_pk_bf16_f32 v97, v107, v209
		v_cvt_pk_bf16_f32 v98, v109, v211
		v_cvt_pk_bf16_f32 v99, v111, v213
		v_cvt_pk_bf16_f32 v28, v117, v215
		v_cvt_pk_bf16_f32 v29, v119, v217
		v_cvt_pk_bf16_f32 v30, v121, v219
		v_cvt_pk_bf16_f32 v31, v123, v221
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[32:47], a[184:187], v[132:135], v[32:47]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[48:63], a[216:219], v[132:135], v[48:63]
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_mfma_f32_32x32x16_bf16 v[32:47], a[188:191], v[128:131], v[32:47]
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_mfma_f32_32x32x16_bf16 v[48:63], a[220:223], v[128:131], v[48:63]
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[136:139], v[32:47]
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[136:139], v[48:63]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[140:143], v[32:47]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[140:143], v[48:63]
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_mfma_f32_32x32x16_bf16 v[80:95], a[216:219], v[124:127], v[80:95]
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[64:79], a[184:187], v[124:127], v[64:79]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[80:95], a[220:223], v[184:187], v[80:95]
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_mfma_f32_32x32x16_bf16 v[64:79], a[188:191], v[184:187], v[64:79]
		v_permlane32_swap_b32_e32 v148, v150
		v_permlane32_swap_b32_e32 v149, v151
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[188:191], v[80:95]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[188:191], v[64:79]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[196:199], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[196:199], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[144:147], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[144:147], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[204:207], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[204:207], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[192:195], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[192:195], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[148:151], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[148:151], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[180:183], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[180:183], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[112:115], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[112:115], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[28:31], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[28:31], v[64:79]
		s_cselect_b32 s1, 1, 0
		s_add_i32 s23, s39, 0x80
		s_cmp_lg_u32 s1, 0
		s_mov_b32 s39, s23
		v_mov_b32_e32 v7, v154
		v_mov_b32_e32 v10, v155
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_4
.L_attn_fwd_persistent.loop_exit_4:
		s_mov_b32 s24, s8
		s_mov_b32 s25, s9
		s_mov_b32 s26, s42
		s_mov_b32 s27, s43
		v_rcp_f32_e32 v2, v24
		v_accvgpr_read_b32 v3, a4
		s_nop 0
		v_readfirstlane_b32 s1, v3
		v_accvgpr_read_b32 v3, a12
		s_nop 0
		v_readfirstlane_b32 s18, v3
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
		v_and_b32_e32 v2, 0xffff, v40
		v_lshrrev_b32_e32 v3, 16, v40
		v_and_b32_e32 v3, 0xffff, v3
		v_and_b32_e32 v32, 0xffff, v41
		v_lshrrev_b32_e32 v33, 16, v41
		v_and_b32_e32 v33, 0xffff, v33
		v_and_b32_e32 v34, 0xffff, v42
		v_lshrrev_b32_e32 v35, 16, v42
		v_and_b32_e32 v35, 0xffff, v35
		v_and_b32_e32 v36, 0xffff, v43
		v_lshrrev_b32_e32 v37, 16, v43
		v_and_b32_e32 v37, 0xffff, v37
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
		v_and_b32_e32 v38, 0xffff, v8
		v_lshrrev_b32_e32 v8, 16, v8
		v_and_b32_e32 v8, 0xffff, v8
		v_and_b32_e32 v39, 0xffff, v9
		v_lshrrev_b32_e32 v9, 16, v9
		v_and_b32_e32 v9, 0xffff, v9
		v_and_b32_e32 v40, 0xffff, v10
		v_lshrrev_b32_e32 v10, 16, v10
		v_and_b32_e32 v10, 0xffff, v10
		v_and_b32_e32 v41, 0xffff, v11
		v_lshrrev_b32_e32 v11, 16, v11
		v_and_b32_e32 v11, 0xffff, v11
		v_permlane32_swap_b32_e32 v12, v14
		v_permlane32_swap_b32_e32 v13, v15
		v_and_b32_e32 v42, 0xffff, v12
		v_lshrrev_b32_e32 v12, 16, v12
		v_and_b32_e32 v12, 0xffff, v12
		v_and_b32_e32 v43, 0xffff, v13
		v_lshrrev_b32_e32 v13, 16, v13
		v_and_b32_e32 v13, 0xffff, v13
		v_and_b32_e32 v44, 0xffff, v14
		v_lshrrev_b32_e32 v14, 16, v14
		v_and_b32_e32 v14, 0xffff, v14
		v_and_b32_e32 v45, 0xffff, v15
		v_lshrrev_b32_e32 v15, 16, v15
		v_and_b32_e32 v15, 0xffff, v15
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_and_b32_e32 v46, 0xffff, v16
		v_lshrrev_b32_e32 v16, 16, v16
		v_and_b32_e32 v16, 0xffff, v16
		v_and_b32_e32 v47, 0xffff, v17
		v_lshrrev_b32_e32 v17, 16, v17
		v_and_b32_e32 v17, 0xffff, v17
		v_and_b32_e32 v48, 0xffff, v18
		v_lshrrev_b32_e32 v18, 16, v18
		v_and_b32_e32 v18, 0xffff, v18
		v_and_b32_e32 v49, 0xffff, v19
		v_lshrrev_b32_e32 v19, 16, v19
		v_and_b32_e32 v19, 0xffff, v19
		v_permlane32_swap_b32_e32 v20, v22
		v_permlane32_swap_b32_e32 v21, v23
		v_and_b32_e32 v50, 0xffff, v20
		v_lshrrev_b32_e32 v20, 16, v20
		v_and_b32_e32 v20, 0xffff, v20
		v_and_b32_e32 v51, 0xffff, v21
		v_lshrrev_b32_e32 v21, 16, v21
		v_and_b32_e32 v21, 0xffff, v21
		v_and_b32_e32 v52, 0xffff, v22
		v_lshrrev_b32_e32 v22, 16, v22
		v_and_b32_e32 v22, 0xffff, v22
		v_and_b32_e32 v53, 0xffff, v23
		v_lshrrev_b32_e32 v23, 16, v23
		v_and_b32_e32 v23, 0xffff, v23
		v_permlane32_swap_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v5, v7
		v_and_b32_e32 v54, 0xffff, v4
		v_lshrrev_b32_e32 v4, 16, v4
		v_and_b32_e32 v4, 0xffff, v4
		v_and_b32_e32 v55, 0xffff, v5
		v_lshrrev_b32_e32 v5, 16, v5
		v_and_b32_e32 v5, 0xffff, v5
		v_and_b32_e32 v56, 0xffff, v6
		v_lshrrev_b32_e32 v6, 16, v6
		v_and_b32_e32 v6, 0xffff, v6
		v_and_b32_e32 v57, 0xffff, v7
		v_lshrrev_b32_e32 v7, 16, v7
		v_and_b32_e32 v7, 0xffff, v7
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_and_b32_e32 v58, 0xffff, v24
		v_lshrrev_b32_e32 v24, 16, v24
		v_and_b32_e32 v24, 0xffff, v24
		v_and_b32_e32 v59, 0xffff, v25
		v_lshrrev_b32_e32 v25, 16, v25
		v_and_b32_e32 v25, 0xffff, v25
		v_and_b32_e32 v60, 0xffff, v26
		v_lshrrev_b32_e32 v26, 16, v26
		v_and_b32_e32 v26, 0xffff, v26
		v_and_b32_e32 v61, 0xffff, v27
		v_lshrrev_b32_e32 v27, 16, v27
		v_and_b32_e32 v27, 0xffff, v27
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_and_b32_e32 v62, 0xffff, v28
		v_lshrrev_b32_e32 v28, 16, v28
		v_and_b32_e32 v28, 0xffff, v28
		v_and_b32_e32 v63, 0xffff, v29
		v_lshrrev_b32_e32 v29, 16, v29
		v_and_b32_e32 v29, 0xffff, v29
		v_and_b32_e32 v64, 0xffff, v30
		v_lshrrev_b32_e32 v30, 16, v30
		v_and_b32_e32 v30, 0xffff, v30
		v_and_b32_e32 v65, 0xffff, v31
		v_lshrrev_b32_e32 v31, 16, v31
		v_and_b32_e32 v31, 0xffff, v31
		s_lshl_b32 s1, s1, 9
		v_accvgpr_read_b32 v66, a2
		s_nop 0
		v_readfirstlane_b32 s18, v66
		v_accvgpr_read_b32 v66, a10
		s_nop 0
		v_readfirstlane_b32 s21, v66
		s_mul_i32 s18, s21, s18
		s_lshl_b32 s18, s18, 1
		s_add_i32 s21, s1, s18
		v_accvgpr_read_b32 v66, a3
		s_nop 0
		v_readfirstlane_b32 s22, v66
		v_accvgpr_read_b32 v66, a11
		s_nop 0
		v_readfirstlane_b32 s23, v66
		s_mul_i32 s22, s23, s22
		s_lshl_b32 s22, s22, 1
		s_add_i32 s21, s21, s22
		v_accvgpr_read_b32 v66, a4
		s_nop 0
		v_readfirstlane_b32 s23, v66
		v_accvgpr_read_b32 v66, a13
		s_nop 0
		v_mul_lo_u32 v66, s23, v66
		v_lshl_add_u32 v67, v66, 6, s21
		v_and_b32_e32 v68, 31, v0
		v_accvgpr_read_b32 v69, a4
		s_nop 0
		v_readfirstlane_b32 s21, v69
		s_nop 1
		v_mul_lo_u32 v68, s21, v68
		v_lshl_add_u32 v67, v68, 1, v67
		v_lshl_add_u32 v67, v1, 4, v67
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_192
		buffer_store_short v2, v67, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_192:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_192
.L_attn_fwd_persistent.exec_endif_192:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 2
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_193
		buffer_store_short v3, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_193:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_193
.L_attn_fwd_persistent.exec_endif_193:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 4
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_194
		buffer_store_short v32, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_194:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_194
.L_attn_fwd_persistent.exec_endif_194:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 6
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_195
		buffer_store_short v33, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_195:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_195
.L_attn_fwd_persistent.exec_endif_195:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 8
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_196
		buffer_store_short v34, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_196:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_196
.L_attn_fwd_persistent.exec_endif_196:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 10
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_197
		buffer_store_short v35, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_197:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_197
.L_attn_fwd_persistent.exec_endif_197:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 12
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_198
		buffer_store_short v36, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_198:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_198
.L_attn_fwd_persistent.exec_endif_198:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 14
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_199
		buffer_store_short v37, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_199:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_199
.L_attn_fwd_persistent.exec_endif_199:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 32
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_200
		buffer_store_short v38, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_200:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_200
.L_attn_fwd_persistent.exec_endif_200:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 34
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_201
		buffer_store_short v8, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_201:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_201
.L_attn_fwd_persistent.exec_endif_201:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 36
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_202
		buffer_store_short v39, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_202:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_202
.L_attn_fwd_persistent.exec_endif_202:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 38
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_203
		buffer_store_short v9, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_203:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_203
.L_attn_fwd_persistent.exec_endif_203:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 40
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_204
		buffer_store_short v40, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_204:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_204
.L_attn_fwd_persistent.exec_endif_204:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 42
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_205
		buffer_store_short v10, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_205:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_205
.L_attn_fwd_persistent.exec_endif_205:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 44
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_206
		buffer_store_short v41, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_206:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_206
.L_attn_fwd_persistent.exec_endif_206:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 46
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_207
		buffer_store_short v11, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_207:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_207
.L_attn_fwd_persistent.exec_endif_207:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 64
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_208
		buffer_store_short v42, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_208:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_208
.L_attn_fwd_persistent.exec_endif_208:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x42
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_209
		buffer_store_short v12, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_209:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_209
.L_attn_fwd_persistent.exec_endif_209:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x44
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_210
		buffer_store_short v43, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_210:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_210
.L_attn_fwd_persistent.exec_endif_210:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x46
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_211
		buffer_store_short v13, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_211:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_211
.L_attn_fwd_persistent.exec_endif_211:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x48
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_212
		buffer_store_short v44, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_212:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_212
.L_attn_fwd_persistent.exec_endif_212:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x4a
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_213
		buffer_store_short v14, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_213:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_213
.L_attn_fwd_persistent.exec_endif_213:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x4c
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_214
		buffer_store_short v45, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_214:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_214
.L_attn_fwd_persistent.exec_endif_214:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x4e
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_215
		buffer_store_short v15, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_215:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_215
.L_attn_fwd_persistent.exec_endif_215:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x60
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_216
		buffer_store_short v46, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_216:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_216
.L_attn_fwd_persistent.exec_endif_216:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x62
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_217
		buffer_store_short v16, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_217:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_217
.L_attn_fwd_persistent.exec_endif_217:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x64
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_218
		buffer_store_short v47, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_218:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_218
.L_attn_fwd_persistent.exec_endif_218:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x66
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_219
		buffer_store_short v17, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_219:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_219
.L_attn_fwd_persistent.exec_endif_219:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x68
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_220
		buffer_store_short v48, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_220:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_220
.L_attn_fwd_persistent.exec_endif_220:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x6a
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_221
		buffer_store_short v18, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_221:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_221
.L_attn_fwd_persistent.exec_endif_221:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x6c
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_222
		buffer_store_short v49, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_222:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_222
.L_attn_fwd_persistent.exec_endif_222:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s1, 0x6e
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		v_lshl_add_u32 v2, v66, 6, s21
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_223
		buffer_store_short v19, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_223:
		s_andn2_b64 exec, s[96:97], s[40:41]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_223
.L_attn_fwd_persistent.exec_endif_223:
		s_mov_b64 exec, s[96:97]
		v_accvgpr_read_b32 v2, a4
		s_nop 0
		v_readfirstlane_b32 s21, v2
		s_lshl_b32 s21, s21, 8
		s_add_i32 s23, s21, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_224
		buffer_store_short v50, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_224:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_224
.L_attn_fwd_persistent.exec_endif_224:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 2
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_225
		buffer_store_short v20, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_225:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_225
.L_attn_fwd_persistent.exec_endif_225:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 4
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_226
		buffer_store_short v51, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_226:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_226
.L_attn_fwd_persistent.exec_endif_226:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 6
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_227
		buffer_store_short v21, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_227:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_227
.L_attn_fwd_persistent.exec_endif_227:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 8
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_228
		buffer_store_short v52, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_228:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_228
.L_attn_fwd_persistent.exec_endif_228:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 10
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_229
		buffer_store_short v22, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_229:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_229
.L_attn_fwd_persistent.exec_endif_229:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 12
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_230
		buffer_store_short v53, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_230:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_230
.L_attn_fwd_persistent.exec_endif_230:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 14
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_231
		buffer_store_short v23, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_231:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_231
.L_attn_fwd_persistent.exec_endif_231:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 32
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_232
		buffer_store_short v54, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_232:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_232
.L_attn_fwd_persistent.exec_endif_232:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 34
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_233
		buffer_store_short v4, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_233:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_233
.L_attn_fwd_persistent.exec_endif_233:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 36
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_234
		buffer_store_short v55, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_234:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_234
.L_attn_fwd_persistent.exec_endif_234:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 38
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_235
		buffer_store_short v5, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_235:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_235
.L_attn_fwd_persistent.exec_endif_235:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 40
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_236
		buffer_store_short v56, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_236:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_236
.L_attn_fwd_persistent.exec_endif_236:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 42
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_237
		buffer_store_short v6, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_237:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_237
.L_attn_fwd_persistent.exec_endif_237:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 44
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_238
		buffer_store_short v57, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_238:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_238
.L_attn_fwd_persistent.exec_endif_238:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 46
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_239
		buffer_store_short v7, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_239:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_239
.L_attn_fwd_persistent.exec_endif_239:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 64
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_240
		buffer_store_short v58, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_240:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_240
.L_attn_fwd_persistent.exec_endif_240:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 0x42
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_241
		buffer_store_short v24, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_241:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_241
.L_attn_fwd_persistent.exec_endif_241:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 0x44
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_242
		buffer_store_short v59, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_242:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_242
.L_attn_fwd_persistent.exec_endif_242:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 0x46
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_243
		buffer_store_short v25, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_243:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_243
.L_attn_fwd_persistent.exec_endif_243:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 0x48
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_244
		buffer_store_short v60, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_244:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_244
.L_attn_fwd_persistent.exec_endif_244:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 0x4a
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_245
		buffer_store_short v26, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_245:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_245
.L_attn_fwd_persistent.exec_endif_245:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 0x4c
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_246
		buffer_store_short v61, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_246:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_246
.L_attn_fwd_persistent.exec_endif_246:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 0x4e
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_247
		buffer_store_short v27, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_247:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_247
.L_attn_fwd_persistent.exec_endif_247:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 0x60
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_248
		buffer_store_short v62, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_248:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_248
.L_attn_fwd_persistent.exec_endif_248:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 0x62
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_249
		buffer_store_short v28, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_249:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_249
.L_attn_fwd_persistent.exec_endif_249:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 0x64
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_250
		buffer_store_short v63, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_250:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_250
.L_attn_fwd_persistent.exec_endif_250:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 0x66
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_251
		buffer_store_short v29, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_251:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_251
.L_attn_fwd_persistent.exec_endif_251:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 0x68
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_252
		buffer_store_short v64, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_252:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_252
.L_attn_fwd_persistent.exec_endif_252:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 0x6a
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_253
		buffer_store_short v30, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_253:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_253
.L_attn_fwd_persistent.exec_endif_253:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s23, s21, 0x6c
		s_add_i32 s23, s23, s1
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v2, v66, 6, s23
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v2, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_254
		buffer_store_short v65, v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_254:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_254
.L_attn_fwd_persistent.exec_endif_254:
		s_mov_b64 exec, s[96:97]
		s_add_i32 s21, s21, 0x6e
		s_add_i32 s1, s21, s1
		s_add_i32 s1, s1, s18
		s_add_i32 s1, s1, s22
		v_lshl_add_u32 v2, v66, 6, s1
		v_lshl_add_u32 v2, v68, 1, v2
		v_lshl_add_u32 v1, v1, 4, v2
		s_and_saveexec_b64 s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_255
		buffer_store_short v31, v1, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_255:
		s_andn2_b64 exec, s[96:97], s[44:45]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_255
.L_attn_fwd_persistent.exec_endif_255:
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
    wave.regalloc.iterations: 432
    wave.regalloc.agpr.dwords: 818
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
