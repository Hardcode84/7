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
		s_cmp_ge_u32 s1, s23
		s_cselect_b32 s25, 1, 0
		s_add_i32 s26, s24, 1
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s24, s26, s24
		s_cselect_b32 s25, 1, 0
		s_sub_i32 s26, s1, s23
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s1, s26, s1
		s_cmp_ge_u32 s1, s23
		s_cselect_b32 s25, 1, 0
		s_add_i32 s26, s24, 1
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s24, s26, s24
		s_cselect_b32 s25, 1, 0
		s_xor_b32 s24, s24, s22
		s_sub_i32 s22, s24, s22
		v_mov_b32_e32 v1, s22
		s_sub_i32 s23, s1, s23
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s1, s23, s1
		s_xor_b32 s1, s1, s21
		s_sub_i32 s1, s1, s21
		v_mov_b32_e32 v2, s1
		v_accvgpr_write_b32 a11, v2
		s_cmp_lt_i32 s18, 32
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_1
		s_lshr_b32 s1, s18, 1
		s_and_b32 s18, s18, 1
		s_mov_b32 s21, 31
		s_sub_i32 s21, s21, s1
		s_cmp_eq_u32 s18, 0
		s_cselect_b32 s1, s1, s21
		v_mov_b32_e32 v2, s1
		v_accvgpr_write_b32 a12, v2
		v_accvgpr_read_b32 v2, a12
		s_nop 0
		v_readfirstlane_b32 s1, v2
		s_mul_i32 s1, s1, 0x100
		v_readfirstlane_b32 s18, v0
		s_lshr_b32 s18, s18, 6
		s_nop 0
		v_mov_b32_e32 v2, s18
		v_accvgpr_write_b32 a13, v2
		v_and_b32_e32 v2, 1, v0
		v_lshrrev_b32_e32 v3, 1, v0
		v_and_b32_e32 v3, 1, v3
		v_mov_b32_e32 v4, 2
		v_mul_lo_u32 v4, v4, v3
		v_lshrrev_b32_e32 v3, 2, v0
		v_and_b32_e32 v5, 1, v3
		v_mov_b32_e32 v6, 4
		v_mul_lo_u32 v6, v6, v5
		v_bitop3_b32 v5, v2, v4, v6 bitop3:0x96
		v_lshrrev_b32_e32 v7, 3, v0
		v_and_b32_e32 v8, 1, v7
		v_mov_b32_e32 v9, 8
		v_mul_lo_u32 v9, v9, v8
		v_xor_b32_e32 v5, v5, v9
		v_lshrrev_b32_e32 v10, 4, v0
		v_and_b32_e32 v11, 1, v10
		v_mov_b32_e32 v12, 16
		v_mul_lo_u32 v12, v12, v11
		v_lshrrev_b32_e32 v13, 6, v0
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v14, 32
		v_mul_lo_u32 v14, v14, v13
		v_bitop3_b32 v5, v5, v12, v14 bitop3:0x96
		v_lshrrev_b32_e32 v15, 7, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v16, 64
		v_mul_lo_u32 v16, v16, v15
		v_xor_b32_e32 v5, v5, v16
		v_accvgpr_write_b32 a14, v5
		v_xor_b32_e32 v2, 0x80, v2
		v_xor_b32_e32 v2, v2, v4
		v_xor_b32_e32 v2, v2, v6
		v_bitop3_b32 v2, v2, v9, v12 bitop3:0x96
		v_bitop3_b32 v2, v2, v14, v16 bitop3:0x96
		v_accvgpr_write_b32 a15, v2
		v_mov_b32_e32 v2, 2
		v_mul_lo_u32 v2, v2, v11
		v_lshrrev_b32_e32 v4, 5, v0
		v_and_b32_e32 v5, 1, v4
		v_mov_b32_e32 v6, 4
		v_mul_lo_u32 v6, v6, v5
		v_bitop3_b32 v9, v8, v2, v6 bitop3:0x96
		v_mov_b32_e32 v12, 8
		v_mul_lo_u32 v12, v12, v13
		v_xor_b32_e32 v9, v9, v12
		v_mov_b32_e32 v14, 16
		v_mul_lo_u32 v14, v14, v15
		v_xad_u32 v9, v9, v14, s1
		v_bitop3_b32 v16, 32, v8, v2 bitop3:0x96
		v_bitop3_b32 v16, v16, v6, v12 bitop3:0x96
		v_xad_u32 v16, v16, v14, s1
		v_bitop3_b32 v17, 64, v8, v2 bitop3:0x96
		v_bitop3_b32 v17, v17, v6, v12 bitop3:0x96
		v_xad_u32 v17, v17, v14, s1
		v_xor_b32_e32 v18, 0x60, v8
		v_xor_b32_e32 v18, v18, v2
		v_xor_b32_e32 v18, v18, v6
		v_xor_b32_e32 v18, v18, v12
		v_xad_u32 v18, v18, v14, s1
		v_xor_b32_e32 v19, 0x80, v8
		v_xor_b32_e32 v19, v19, v2
		v_xor_b32_e32 v19, v19, v6
		v_xor_b32_e32 v19, v19, v12
		v_xad_u32 v19, v19, v14, s1
		v_xor_b32_e32 v20, 0xa0, v8
		v_xor_b32_e32 v20, v20, v2
		v_xor_b32_e32 v20, v20, v6
		v_xor_b32_e32 v20, v20, v12
		v_xad_u32 v20, v20, v14, s1
		v_xor_b32_e32 v21, 0xc0, v8
		v_xor_b32_e32 v21, v21, v2
		v_xor_b32_e32 v21, v21, v6
		v_xor_b32_e32 v21, v21, v12
		v_xad_u32 v21, v21, v14, s1
		v_xor_b32_e32 v22, 0xe0, v8
		v_xor_b32_e32 v2, v22, v2
		v_xor_b32_e32 v2, v2, v6
		v_xor_b32_e32 v2, v2, v12
		v_xad_u32 v2, v2, v14, s1
		v_cmp_lt_i32_e64 s[24:25], v9, s19
		v_cmp_lt_i32_e64 s[28:29], v16, s19
		v_cmp_lt_i32_e64 s[30:31], v17, s19
		v_cmp_lt_i32_e64 s[32:33], v18, s19
		v_cmp_lt_i32_e64 s[34:35], v19, s19
		v_cmp_lt_i32_e64 s[36:37], v20, s19
		v_cmp_lt_i32_e64 s[38:39], v21, s19
		s_mov_b32 s42, 0x7fffffff
		s_mov_b32 s43, 0x31016000
		s_mov_b32 s40, s2
		s_mov_b32 s41, s3
		v_accvgpr_read_b32 v9, a7
		v_and_b32_e32 v9, 0xffff, v9
		v_lshlrev_b32_e32 v12, 16, v9
		v_or_b32_e32 v16, v9, v12
		v_mov_b32_e32 v17, v16
		v_mov_b32_e32 v18, v16
		v_mov_b32_e32 v19, v16
		v_accvgpr_read_b32 v9, a12
		s_nop 0
		v_readfirstlane_b32 s18, v9
		s_mul_i32 s18, s18, s12
		s_lshl_b32 s18, s18, 9
		v_readfirstlane_b32 s21, v1
		s_mul_i32 s21, s21, s10
		s_lshl_b32 s21, s21, 1
		s_add_i32 s23, s18, s21
		v_accvgpr_read_b32 v9, a11
		s_nop 0
		v_readfirstlane_b32 s26, v9
		s_mul_i32 s26, s26, s11
		s_lshl_b32 s26, s26, 1
		s_add_i32 s23, s23, s26
		v_mul_lo_u32 v9, s12, v7
		v_lshl_add_u32 v12, v9, 1, s23
		v_and_b32_e32 v14, 7, v0
		v_lshl_add_u32 v12, v14, 4, v12
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_0
		buffer_load_dwordx4 v[20:23], v12, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_0:
		s_andn2_b64 exec, s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_0
		v_mov_b32_e32 v20, v16
		v_mov_b32_e32 v21, v17
		v_mov_b32_e32 v22, v18
		v_mov_b32_e32 v23, v19
.L_attn_fwd_persistent.exec_endif_0:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s23, s12, 6
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s26
		v_lshl_add_u32 v12, v9, 1, s23
		v_lshl_add_u32 v12, v14, 4, v12
		s_and_saveexec_b64 s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_1
		buffer_load_dwordx4 v[24:27], v12, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_1:
		s_andn2_b64 exec, s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_1
		v_mov_b32_e32 v24, v16
		v_mov_b32_e32 v25, v17
		v_mov_b32_e32 v26, v18
		v_mov_b32_e32 v27, v19
.L_attn_fwd_persistent.exec_endif_1:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s23, s12, 7
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s26
		v_lshl_add_u32 v12, v9, 1, s23
		v_lshl_add_u32 v12, v14, 4, v12
		s_and_saveexec_b64 s[100:101], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_2
		buffer_load_dwordx4 v[28:31], v12, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_2:
		s_andn2_b64 exec, s[100:101], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_2
		v_mov_b32_e32 v28, v16
		v_mov_b32_e32 v29, v17
		v_mov_b32_e32 v30, v18
		v_mov_b32_e32 v31, v19
.L_attn_fwd_persistent.exec_endif_2:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s23, 0xc0, s12
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s26
		v_lshl_add_u32 v12, v9, 1, s23
		v_lshl_add_u32 v12, v14, 4, v12
		s_and_saveexec_b64 s[100:101], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_3
		buffer_load_dwordx4 v[32:35], v12, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_3:
		s_andn2_b64 exec, s[100:101], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_3
		v_mov_b32_e32 v32, v16
		v_mov_b32_e32 v33, v17
		v_mov_b32_e32 v34, v18
		v_mov_b32_e32 v35, v19
.L_attn_fwd_persistent.exec_endif_3:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s23, s12, 8
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s26
		v_lshl_add_u32 v12, v9, 1, s23
		v_lshl_add_u32 v12, v14, 4, v12
		s_and_saveexec_b64 s[100:101], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_4
		buffer_load_dwordx4 v[36:39], v12, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_4:
		s_andn2_b64 exec, s[100:101], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_4
		v_mov_b32_e32 v36, v16
		v_mov_b32_e32 v37, v17
		v_mov_b32_e32 v38, v18
		v_mov_b32_e32 v39, v19
.L_attn_fwd_persistent.exec_endif_4:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s23, 0x140, s12
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s26
		v_lshl_add_u32 v12, v9, 1, s23
		v_lshl_add_u32 v12, v14, 4, v12
		s_and_saveexec_b64 s[100:101], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_5
		buffer_load_dwordx4 v[40:43], v12, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_5:
		s_andn2_b64 exec, s[100:101], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_5
		v_mov_b32_e32 v40, v16
		v_mov_b32_e32 v41, v17
		v_mov_b32_e32 v42, v18
		v_mov_b32_e32 v43, v19
.L_attn_fwd_persistent.exec_endif_5:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s23, 0x180, s12
		s_add_i32 s23, s23, s18
		s_add_i32 s23, s23, s21
		s_add_i32 s23, s23, s26
		v_lshl_add_u32 v12, v9, 1, s23
		v_lshl_add_u32 v12, v14, 4, v12
		s_and_saveexec_b64 s[100:101], s[38:39]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_6
		buffer_load_dwordx4 v[44:47], v12, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_6:
		s_andn2_b64 exec, s[100:101], s[38:39]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_6
		v_mov_b32_e32 v44, v16
		v_mov_b32_e32 v45, v17
		v_mov_b32_e32 v46, v18
		v_mov_b32_e32 v47, v19
.L_attn_fwd_persistent.exec_endif_6:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s23, 0x1c0, s12
		s_add_i32 s18, s23, s18
		s_add_i32 s18, s18, s21
		s_add_i32 s18, s18, s26
		v_lshl_add_u32 v9, v9, 1, s18
		v_lshl_add_u32 v9, v14, 4, v9
		v_cmp_lt_i32_e64 vcc, v2, s19
		s_and_saveexec_b64 s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_7
		buffer_load_dwordx4 v[48:51], v9, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_7:
		s_andn2_b64 exec, s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_7
		v_mov_b32_e32 v48, v16
		v_mov_b32_e32 v49, v17
		v_mov_b32_e32 v50, v18
		v_mov_b32_e32 v51, v19
.L_attn_fwd_persistent.exec_endif_7:
		s_mov_b64 exec, s[100:101]
		s_mov_b32 s28, s4
		s_mov_b32 s29, s5
		s_mov_b32 s30, s42
		s_mov_b32 s31, s43
		s_mov_b32 s32, s6
		s_mov_b32 s33, s7
		s_mov_b32 s34, s42
		s_mov_b32 s35, s43
		s_waitcnt vmcnt(0)
		s_barrier
		v_and_b32_e32 v2, 1, v4
		v_accvgpr_write_b32 a16, v2
		v_accvgpr_read_b32 v2, a16
		v_lshlrev_b32_e32 v2, 1, v2
		v_accvgpr_read_b32 v4, a13
		s_nop 0
		v_readfirstlane_b32 s18, v4
		s_and_b32 s18, s18, 1
		s_lshl_b32 s18, s18, 2
		v_and_b32_e32 v4, 1, v10
		v_accvgpr_write_b32 a17, v4
		v_accvgpr_read_b32 v4, a17
		v_xor_b32_e32 v4, s18, v4
		v_bitop3_b32 v2, v0, v2, v4 bitop3:0x96
		v_lshlrev_b32_e32 v2, 4, v2
		v_add_u32_e32 v2, 0x10000, v2
		ds_write_b128 v2, v[20:23] offset:2480
		ds_write_b128 v2, v[24:27] offset:6576
		ds_write_b128 v2, v[28:31] offset:10672
		ds_write_b128 v2, v[32:35] offset:14768
		v_mov_b32_e32 v4, 32
		v_mul_lo_u32 v4, v4, v11
		v_mov_b32_e32 v9, 2
		v_mul_lo_u32 v9, v9, v15
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v10, a13
		s_nop 0
		v_readfirstlane_b32 s18, v10
		s_lshl_b32 s18, s18, 12
		s_add_i32 s18, s18, 0x10000
		v_and_b32_e32 v10, 63, v0
		v_and_b32_e32 v11, 7, v10
		v_lshrrev_b32_e32 v12, 2, v11
		v_lshl_add_u32 v15, v12, 5, s18
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
		v_lshl_add_u32 v20, v16, 6, s18
		v_add3_u32 v21, 2, v18, v19
		v_lshlrev_b32_e32 v12, 1, v12
		v_bitop3_b32 v21, v21, v12, v11 bitop3:0x96
		v_lshl_add_u32 v20, v21, 4, v20
		ds_read_b128 a[24:27], v20 offset:2480
		v_add3_u32 v21, 4, v18, v19
		v_lshlrev_b32_e32 v16, 2, v16
		v_xor_b32_e32 v11, v16, v11
		v_xor_b32_e32 v16, v21, v11
		v_lshl_add_u32 v15, v16, 4, v15
		ds_read_b128 a[28:31], v15 offset:2480
		v_add3_u32 v16, 6, v18, v19
		v_bitop3_b32 v11, v16, v12, v11 bitop3:0x96
		v_lshl_add_u32 v11, v11, 4, s18
		ds_read_b128 a[32:35], v11 offset:2480
		v_and_b32_e32 v7, 1, v7
		v_lshlrev_b32_e32 v12, 4, v14
		v_and_b32_e32 v3, 1, v3
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[36:39] offset:2480
		ds_write_b128 v2, v[40:43] offset:6576
		ds_write_b128 v2, v[44:47] offset:10672
		ds_write_b128 v2, v[48:51] offset:14768
		v_accvgpr_read_b32 v2, a12
		s_nop 0
		v_readfirstlane_b32 s18, v2
		s_add_i32 s18, s18, 1
		s_mul_i32 s18, s18, 0x100
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[36:39], v17 offset:2480
		ds_read_b128 a[40:43], v20 offset:2480
		ds_read_b128 a[44:47], v15 offset:2480
		ds_read_b128 a[48:51], v11 offset:2480
		v_accvgpr_read_b32 v2, a6
		s_nop 0
		v_readfirstlane_b32 s21, v2
		s_add_i32 s18, s18, s21
		s_cmp_lt_i32 s20, s18
		s_cselect_b32 s18, s20, s18
		s_add_i32 s21, s18, 0x7f
		s_mov_b32 s23, 0x7f
		s_cmp_lt_i32 s21, 0
		s_cselect_b32 s24, s23, 0
		s_add_i32 s21, s21, s24
		s_ashr_i32 s21, s21, 7
		v_accvgpr_read_b32 v2, a6
		s_nop 0
		v_readfirstlane_b32 s24, v2
		s_add_i32 s24, s1, s24
		s_cmp_lt_i32 s24, 0
		s_cselect_b32 s25, s23, 0
		s_add_i32 s24, s24, s25
		s_ashr_i32 s24, s24, 7
		s_cmp_lt_i32 s24, s21
		s_cselect_b32 s24, s24, s21
		s_cmp_gt_i32 s24, 0
		s_cselect_b32 s24, s24, 0
		v_mov_b32_e32 v2, 64
		v_mul_lo_u32 v2, v2, v8
		v_mov_b32_e32 v11, 16
		v_mul_lo_u32 v11, v11, v5
		v_bitop3_b32 v14, v2, v4, v11 bitop3:0x96
		v_bitop3_b32 v14, v14, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a18, v14
		v_bitop3_b32 v14, 4, v2, v4 bitop3:0x96
		v_xor_b32_e32 v14, v14, v11
		v_bitop3_b32 v15, 8, v2, v4 bitop3:0x96
		v_xor_b32_e32 v15, v15, v11
		v_bitop3_b32 v2, 12, v2, v4 bitop3:0x96
		v_accvgpr_read_b32 v16, a18
		v_cmp_lt_i32_e64 s[36:37], v16, s20
		v_mov_b32_e32 v16, 16
		v_mul_lo_u32 v16, v16, v8
		v_mov_b32_e32 v8, 64
		v_mul_lo_u32 v8, v8, v5
		v_bitop3_b32 v5, v16, v4, v8 bitop3:0x96
		v_bitop3_b32 v5, v5, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a19, v5
		v_bitop3_b32 v5, 4, v16, v4 bitop3:0x96
		v_bitop3_b32 v17, 8, v16, v4 bitop3:0x96
		v_bitop3_b32 v4, 12, v16, v4 bitop3:0x96
		v_accvgpr_read_b32 v16, a19
		v_cmp_lt_i32_e64 vcc, v16, s20
		v_readfirstlane_b32 s26, v0
		v_readfirstlane_b32 s25, v1
		s_mul_i32 s25, s25, s13
		s_lshl_b32 s25, s25, 1
		v_accvgpr_read_b32 v16, a11
		s_nop 0
		v_readfirstlane_b32 s38, v16
		s_mul_i32 s38, s38, s14
		s_lshl_b32 s38, s38, 1
		s_add_i32 s39, s25, s38
		v_accvgpr_read_b32 v16, a13
		s_nop 0
		v_readfirstlane_b32 s40, v16
		s_mul_i32 s40, s15, s40
		s_lshl_b32 s40, s40, 1
		s_add_i32 s39, s39, s40
		v_accvgpr_read_b32 v16, a16
		v_mul_lo_u32 v16, s15, v16
		v_lshlrev_b32_e32 v16, 5, v16
		v_accvgpr_read_b32 v19, a17
		v_mul_lo_u32 v19, s15, v19
		v_lshlrev_b32_e32 v19, 6, v19
		v_add3_u32 v20, s39, v16, v19
		v_mul_lo_u32 v21, s15, v7
		v_lshlrev_b32_e32 v21, 7, v21
		v_add3_u32 v20, v20, v21, v12
		v_mov_b32_e32 v22, 0x80000000
		v_cndmask_b32_e64 v20, v22, v20, s[36:37]
		s_lshr_b32 s39, s26, 6
		s_mul_i32 s41, 0x410, s39
		s_mov_b32 m0, s41
		v_accvgpr_read_b32 v23, a14
		v_add_u32_e32 v23, s1, v23
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[44:45], v23, s19
		s_nop 1
		v_mov_b32_e32 v24, s44
		v_mov_b32_e32 v25, s45
		v_accvgpr_write_b32 a52, v24
		v_accvgpr_write_b32 a53, v25
		s_lshl_b32 s44, s15, 3
		s_add_i32 s44, s44, s25
		s_add_i32 s44, s44, s38
		s_add_i32 s44, s44, s40
		v_add3_u32 v20, s44, v16, v19
		v_add3_u32 v20, v20, v21, v12
		v_cndmask_b32_e64 v20, v22, v20, s[36:37]
		s_add_i32 m0, m0, 0x1040
		v_accvgpr_read_b32 v23, a15
		v_add_u32_e32 v23, s1, v23
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[44:45], v23, s19
		s_nop 1
		v_mov_b32_e32 v24, s44
		v_mov_b32_e32 v25, s45
		v_accvgpr_write_b32 a54, v24
		v_accvgpr_write_b32 a55, v25
		s_lshl_b32 s44, s15, 4
		s_add_i32 s44, s44, s25
		s_add_i32 s44, s44, s38
		s_add_i32 s44, s44, s40
		v_add3_u32 v20, s44, v16, v19
		v_add3_u32 v20, v20, v21, v12
		v_cndmask_b32_e64 v20, v22, v20, s[36:37]
		s_add_i32 m0, m0, 0x1040
		v_lshlrev_b32_e32 v18, 4, v18
		v_accvgpr_write_b32 a56, v18
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		v_bitop3_b32 v14, v14, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a57, v14
		s_mul_i32 s44, 24, s15
		s_add_i32 s44, s44, s25
		s_add_i32 s44, s44, s38
		s_add_i32 s44, s44, s40
		v_add3_u32 v14, s44, v16, v19
		v_add3_u32 v14, v14, v21, v12
		v_cndmask_b32_e64 v14, v22, v14, s[36:37]
		s_add_i32 m0, m0, 0x1040
		v_mov_b32_e32 v18, 0x440
		v_mul_lo_u32 v18, v18, v3
		v_accvgpr_write_b32 a58, v18
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		v_bitop3_b32 v3, v15, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a59, v3
		v_accvgpr_read_b32 v3, a0
		s_nop 0
		v_readfirstlane_b32 s36, v3
		v_readfirstlane_b32 s37, v1
		s_mul_i32 s36, s37, s36
		s_lshl_b32 s36, s36, 1
		v_accvgpr_read_b32 v1, a1
		s_nop 0
		v_readfirstlane_b32 s37, v1
		v_accvgpr_read_b32 v1, a11
		s_nop 0
		v_readfirstlane_b32 s44, v1
		s_mul_i32 s37, s44, s37
		s_lshl_b32 s37, s37, 1
		s_add_i32 s44, s36, s37
		v_accvgpr_read_b32 v1, a13
		s_nop 0
		v_readfirstlane_b32 s45, v1
		s_mul_i32 s45, s17, s45
		s_lshl_b32 s45, s45, 1
		s_add_i32 s44, s44, s45
		v_accvgpr_read_b32 v1, a16
		v_mul_lo_u32 v1, s17, v1
		v_lshlrev_b32_e32 v1, 7, v1
		v_accvgpr_read_b32 v3, a17
		v_mul_lo_u32 v3, s17, v3
		v_lshlrev_b32_e32 v3, 6, v3
		v_add3_u32 v14, s44, v1, v3
		v_mul_lo_u32 v15, s17, v7
		v_lshlrev_b32_e32 v15, 5, v15
		v_add3_u32 v14, v14, v15, v12
		v_cndmask_b32_e32 v14, v22, v14, vcc
		s_mul_i32 s39, 0x440, s39
		s_add_i32 m0, s39, 0x81f0
		v_xor_b32_e32 v2, v2, v11
		buffer_load_dwordx4 v14, s[32:35], 0 offen lds
		v_bitop3_b32 v2, v2, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a60, v2
		s_lshl_b32 s44, s17, 3
		s_add_i32 s44, s44, s36
		s_add_i32 s44, s44, s37
		s_add_i32 s44, s44, s45
		v_add3_u32 v2, s44, v1, v3
		v_add3_u32 v2, v2, v15, v12
		v_cndmask_b32_e32 v2, v22, v2, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v5, v5, v8
		buffer_load_dwordx4 v2, s[32:35], 0 offen lds
		v_bitop3_b32 v2, v5, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a61, v2
		s_lshl_b32 s44, s17, 4
		s_add_i32 s44, s44, s36
		s_add_i32 s44, s44, s37
		s_add_i32 s44, s44, s45
		v_add3_u32 v2, s44, v1, v3
		v_add3_u32 v2, v2, v15, v12
		v_cndmask_b32_e32 v2, v22, v2, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v5, v17, v8
		buffer_load_dwordx4 v2, s[32:35], 0 offen lds
		v_bitop3_b32 v2, v5, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a62, v2
		s_mul_i32 s44, 24, s17
		s_add_i32 s44, s44, s36
		s_add_i32 s44, s44, s37
		s_add_i32 s44, s44, s45
		v_add3_u32 v2, s44, v1, v3
		v_add3_u32 v2, v2, v15, v12
		v_cndmask_b32_e32 v2, v22, v2, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v4, v4, v8
		buffer_load_dwordx4 v2, s[32:35], 0 offen lds
		v_bitop3_b32 v2, v4, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a63, v2
		s_mul_i32 s44, s24, 0x80
		s_lshl_b32 s24, s15, 8
		s_add_i32 s24, s24, s25
		s_add_i32 s24, s24, s38
		s_add_i32 s24, s24, s40
		s_mul_i32 s46, 0x108, s15
		s_add_i32 s46, s46, s25
		s_add_i32 s46, s46, s38
		s_add_i32 s46, s46, s40
		s_mul_i32 s47, 0x110, s15
		s_add_i32 s47, s47, s25
		s_add_i32 s47, s47, s38
		s_add_i32 s47, s47, s40
		s_mul_i32 s48, 0x118, s15
		s_add_i32 s25, s48, s25
		s_add_i32 s25, s25, s38
		s_add_i32 s25, s25, s40
		s_lshl_b32 s38, s17, 8
		s_add_i32 s38, s38, s36
		s_add_i32 s38, s38, s37
		s_add_i32 s38, s38, s45
		s_mul_i32 s40, 0x108, s17
		s_add_i32 s40, s40, s36
		s_add_i32 s40, s40, s37
		s_add_i32 s40, s40, s45
		s_mul_i32 s48, 0x110, s17
		s_add_i32 s48, s48, s36
		s_add_i32 s48, s48, s37
		s_add_i32 s48, s48, s45
		s_mul_i32 s49, 0x118, s17
		s_add_i32 s36, s49, s36
		s_add_i32 s36, s36, s37
		s_add_i32 s36, s36, s45
		v_mbcnt_lo_u32_b32 v2, -1, 0
		v_mbcnt_hi_u32_b32 v2, -1, v2
		v_and_b32_e32 v2, 31, v2
		v_add_u32_e32 v4, 32, v2
		v_mov_b32_e32 v8, 0x3e38aa3b
		v_mov_b32_e32 v9, 0x3e38aa3b
		s_mov_b32 s37, 0xff800000
		v_mov_b32_e32 v5, s37
		v_mov_b32_e32 v11, s37
		s_mov_b32 s37, 1.0
		v_mov_b32_e32 v24, s37
		v_mov_b32_e32 v25, s37
		s_mov_b32 s37, 0
		v_lshrrev_b32_e32 v13, 4, v10
		v_lshlrev_b32_e32 v13, 9, v13
		v_accvgpr_write_b32 a64, v13
		v_and_b32_e32 v10, 15, v10
		v_mov_b32_e32 v13, 0x410
		v_mul_lo_u32 v13, v13, v10
		v_accvgpr_write_b32 a65, v13
		v_and_b32_e32 v10, 3, v0
		v_accvgpr_write_b32 a66, v10
		v_accvgpr_read_b32 v10, a66
		v_lshlrev_b32_e32 v10, 3, v10
		v_accvgpr_write_b32 a67, v10
		v_accvgpr_read_b32 v10, a16
		v_mov_b32_e32 v13, 0x2200
		v_mul_lo_u32 v13, v13, v10
		v_accvgpr_write_b32 a68, v13
		v_accvgpr_read_b32 v10, a17
		v_lshlrev_b32_e32 v10, 5, v10
		v_accvgpr_write_b32 a69, v10
		v_mov_b32_e32 v10, 0x880
		v_mul_lo_u32 v10, v10, v7
		v_accvgpr_write_b32 a70, v10
		v_lshlrev_b32_e32 v2, 2, v2
		v_accvgpr_write_b32 a71, v2
		v_lshlrev_b32_e32 v2, 2, v4
		v_accvgpr_write_b32 a72, v2
		s_cmp_lt_i32 0, s44
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
		s_lshr_b32 s45, s37, 7
		s_and_b32 s49, s45, 1
		s_mul_i32 s50, 0x4100, s49
		v_accvgpr_read_b32 v2, a56
		v_add_u32_e32 v2, s50, v2
		v_accvgpr_read_b32 v4, a64
		v_accvgpr_read_b32 v7, a65
		v_add3_u32 v2, v2, v4, v7
		ds_read_b128 v[28:31], v2
		ds_read_b128 v[96:99], v2 offset:32
		ds_read_b128 v[100:103], v2 offset:64
		ds_read_b128 a[76:79], v2 offset:96
		ds_read_b128 v[104:107], v2 offset:256
		ds_read_b128 v[108:111], v2 offset:288
		ds_read_b128 v[112:115], v2 offset:320
		ds_read_b128 a[80:83], v2 offset:352
		ds_read_b128 v[116:119], v2 offset:128
		ds_read_b128 v[120:123], v2 offset:160
		ds_read_b128 v[124:127], v2 offset:192
		ds_read_b128 a[84:87], v2 offset:224
		ds_read_b128 v[128:131], v2 offset:384
		ds_read_b128 a[88:91], v2 offset:416
		ds_read_b128 a[92:95], v2 offset:448
		ds_read_b128 a[96:99], v2 offset:480
		s_mul_i32 s49, 0x4400, s49
		v_accvgpr_read_b32 v2, a67
		v_add_u32_e32 v2, s49, v2
		v_accvgpr_read_b32 v4, a69
		v_accvgpr_read_b32 v7, a68
		v_add3_u32 v2, v2, v7, v4
		v_accvgpr_read_b32 v4, a58
		v_accvgpr_read_b32 v7, a70
		v_add3_u32 v2, v2, v7, v4
		ds_read_b64_tr_b16 a[100:101], v2 offset:33264
		ds_read_b64_tr_b16 a[102:103], v2 offset:37616
		ds_read_b64_tr_b16 a[104:105], v2 offset:33392
		ds_read_b64_tr_b16 a[106:107], v2 offset:37744
		ds_read_b64_tr_b16 a[108:109], v2 offset:33520
		ds_read_b64_tr_b16 a[110:111], v2 offset:37872
		ds_read_b64_tr_b16 a[112:113], v2 offset:33648
		ds_read_b64_tr_b16 a[114:115], v2 offset:38000
		ds_read_b64_tr_b16 a[116:117], v2 offset:33776
		ds_read_b64_tr_b16 a[118:119], v2 offset:38128
		ds_read_b64_tr_b16 a[120:121], v2 offset:33904
		ds_read_b64_tr_b16 a[122:123], v2 offset:38256
		ds_read_b64_tr_b16 a[124:125], v2 offset:34032
		ds_read_b64_tr_b16 a[126:127], v2 offset:38384
		ds_read_b64_tr_b16 a[128:129], v2 offset:34160
		ds_read_b64_tr_b16 a[130:131], v2 offset:38512
		ds_read_b64_tr_b16 a[132:133], v2 offset:33328
		ds_read_b64_tr_b16 a[134:135], v2 offset:37680
		ds_read_b64_tr_b16 a[136:137], v2 offset:33456
		ds_read_b64_tr_b16 a[138:139], v2 offset:37808
		ds_read_b64_tr_b16 a[140:141], v2 offset:33584
		ds_read_b64_tr_b16 a[142:143], v2 offset:37936
		ds_read_b64_tr_b16 a[144:145], v2 offset:33712
		ds_read_b64_tr_b16 a[146:147], v2 offset:38064
		ds_read_b64_tr_b16 a[148:149], v2 offset:33840
		ds_read_b64_tr_b16 a[150:151], v2 offset:38192
		ds_read_b64_tr_b16 a[152:153], v2 offset:33968
		ds_read_b64_tr_b16 a[154:155], v2 offset:38320
		ds_read_b64_tr_b16 a[156:157], v2 offset:34096
		ds_read_b64_tr_b16 a[158:159], v2 offset:38448
		ds_read_b64_tr_b16 a[160:161], v2 offset:34224
		ds_read_b64_tr_b16 a[162:163], v2 offset:38576
		s_mul_i32 s49, s15, s37
		s_lshl_b32 s49, s49, 1
		s_add_i32 s50, s24, s49
		v_add3_u32 v2, s50, v16, v19
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[20:23], 0
		v_add3_u32 v2, v2, v21, v12
		v_mfma_f32_32x32x16_bf16 v[144:159], v[96:99], a[24:27], v[144:159]
		s_add_i32 s45, s45, 1
		v_mfma_f32_32x32x16_bf16 v[144:159], v[100:103], a[28:31], v[144:159]
		s_and_b32 s45, s45, 1
		v_mfma_f32_32x32x16_bf16 v[160:175], v[28:31], a[36:39], 0
		s_mul_i32 s50, 0x4100, s45
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], a[40:43], v[160:175]
		s_add_i32 s50, s41, s50
		v_mfma_f32_32x32x16_bf16 v[160:175], v[100:103], a[44:47], v[160:175]
		s_mov_b32 m0, s50
		v_mfma_f32_32x32x16_bf16 v[176:191], v[104:107], a[20:23], 0
		s_add_i32 s50, s46, s49
		v_mfma_f32_32x32x16_bf16 v[176:191], v[108:111], a[24:27], v[176:191]
		v_add3_u32 v4, s50, v16, v19
		v_mfma_f32_32x32x16_bf16 v[176:191], v[112:115], a[28:31], v[176:191]
		v_add3_u32 v4, v4, v21, v12
		v_mfma_f32_32x32x16_bf16 v[192:207], v[104:107], a[36:39], 0
		s_add_i32 s50, s47, s49
		v_mfma_f32_32x32x16_bf16 v[192:207], v[108:111], a[40:43], v[192:207]
		v_add3_u32 v7, s50, v16, v19
		v_mfma_f32_32x32x16_bf16 v[192:207], v[112:115], a[44:47], v[192:207]
		v_add3_u32 v7, v7, v21, v12
		v_mfma_f32_32x32x16_bf16 v[96:111], v[116:119], a[20:23], 0
		s_add_i32 s49, s25, s49
		v_mfma_f32_32x32x16_bf16 v[96:111], v[120:123], a[24:27], v[96:111]
		v_add3_u32 v10, s49, v16, v19
		v_mfma_f32_32x32x16_bf16 v[96:111], v[124:127], a[28:31], v[96:111]
		v_add3_u32 v10, v10, v21, v12
		v_mfma_f32_32x32x16_bf16 v[208:223], v[116:119], a[36:39], 0
		s_mul_i32 s49, s17, s37
		v_mfma_f32_32x32x16_bf16 v[208:223], v[120:123], a[40:43], v[208:223]
		s_add_i32 s37, s37, 0x80
		v_mfma_f32_32x32x16_bf16 v[208:223], v[124:127], a[44:47], v[208:223]
		v_accvgpr_read_b32 v13, a18
		v_add_u32_e32 v13, s37, v13
		v_mfma_f32_32x32x16_bf16 v[112:127], v[128:131], a[20:23], 0
		v_accvgpr_read_b32 v14, a57
		v_add_u32_e32 v14, s37, v14
		v_mfma_f32_32x32x16_bf16 v[112:127], a[88:91], a[24:27], v[112:127]
		v_accvgpr_read_b32 v17, a59
		v_add_u32_e32 v17, s37, v17
		v_mfma_f32_32x32x16_bf16 v[112:127], a[92:95], a[28:31], v[112:127]
		v_accvgpr_read_b32 v18, a60
		v_add_u32_e32 v18, s37, v18
		v_mfma_f32_32x32x16_bf16 v[224:239], v[128:131], a[36:39], 0
		v_cmp_lt_i32_e64 s[50:51], v13, s20
		v_accvgpr_read_b32 v13, a19
		v_add_u32_e32 v13, s37, v13
		v_accvgpr_read_b32 v20, a61
		v_add_u32_e32 v20, s37, v20
		v_accvgpr_read_b32 v23, a62
		v_add_u32_e32 v23, s37, v23
		v_accvgpr_read_b32 v26, a63
		v_add_u32_e32 v26, s37, v26
		v_cmp_lt_i32_e64 vcc, v26, s20
		v_cndmask_b32_e64 v2, v22, v2, s[50:51]
		buffer_load_dwordx4 v2, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[50:51], v14, s20
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[52:53], v17, s20
		v_cndmask_b32_e64 v2, v22, v4, s[50:51]
		v_cmp_lt_i32_e64 s[50:51], v18, s20
		buffer_load_dwordx4 v2, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], a[88:91], a[40:43], v[224:239]
		v_cndmask_b32_e64 v2, v22, v7, s[52:53]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[92:95], a[44:47], v[224:239]
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v4, v22, v10, s[50:51]
		buffer_load_dwordx4 v2, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[50:51], v13, s20
		v_cmp_lt_i32_e64 s[52:53], v20, s20
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s49, s49, 1
		s_add_i32 s54, s38, s49
		buffer_load_dwordx4 v4, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[144:159], a[76:79], a[32:35], v[144:159]
		v_add3_u32 v2, s54, v1, v3
		v_mfma_f32_32x32x16_bf16 v[160:175], a[76:79], a[48:51], v[160:175]
		v_add3_u32 v2, v2, v15, v12
		v_cndmask_b32_e64 v2, v22, v2, s[50:51]
		v_cmp_lt_i32_e64 s[50:51], v23, s20
		s_mul_i32 s45, 0x4400, s45
		s_add_i32 s45, s39, s45
		s_add_i32 m0, s45, 0x81f0
		s_add_i32 s45, s40, s49
		buffer_load_dwordx4 v2, s[32:35], 0 offen lds
		v_add3_u32 v2, s45, v1, v3
		v_add3_u32 v2, v2, v15, v12
		v_cndmask_b32_e64 v2, v22, v2, s[52:53]
		v_max3_f32 v4, v144, v145, v146
		s_add_i32 m0, m0, 0x1100
		s_add_i32 s45, s48, s49
		buffer_load_dwordx4 v2, s[32:35], 0 offen lds
		v_add3_u32 v2, s45, v1, v3
		v_add3_u32 v2, v2, v15, v12
		v_max3_f32 v7, v148, v149, v150
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v2, v22, v2, s[50:51]
		buffer_load_dwordx4 v2, s[32:35], 0 offen lds
		v_max3_f32 v2, v152, v153, v154
		s_add_i32 s45, s36, s49
		v_add3_u32 v10, s45, v1, v3
		v_add3_u32 v10, v10, v15, v12
		v_cndmask_b32_e32 v10, v22, v10, vcc
		v_max3_f32 v13, v156, v157, v158
		s_add_i32 m0, m0, 0x1100
		v_max3_f32 v4, v4, v147, v7
		v_max3_f32 v2, v2, v155, v13
		v_max3_f32 v2, v4, v151, v2
		v_max3_f32 v4, v160, v161, v162
		v_max3_f32 v7, v164, v165, v166
		v_max3_f32 v13, v168, v169, v170
		v_max3_f32 v14, v172, v173, v174
		v_max3_f32 v4, v4, v163, v7
		v_max3_f32 v7, v13, v171, v14
		v_max3_f32 v4, v4, v167, v7
		s_cmp_lt_i32 s37, s44
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[176:191], a[80:83], a[32:35], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[84:87], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[96:99], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[96:99], a[48:51], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[80:83], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[84:87], a[48:51], v[208:223]
		s_nop 6
		v_max3_f32 v7, v176, v177, v178
		v_max3_f32 v10, v180, v181, v182
		v_max3_f32 v13, v184, v185, v186
		v_max3_f32 v14, v188, v189, v190
		v_max3_f32 v17, v96, v97, v98
		v_max3_f32 v18, v100, v101, v102
		v_max3_f32 v20, v104, v105, v106
		v_max3_f32 v23, v108, v109, v110
		v_max3_f32 v26, v112, v113, v114
		v_max3_f32 v27, v116, v117, v118
		v_max3_f32 v28, v120, v121, v122
		v_max3_f32 v29, v124, v125, v126
		v_max3_f32 v7, v7, v179, v10
		v_max3_f32 v10, v13, v187, v14
		v_max3_f32 v13, v17, v99, v18
		v_max3_f32 v14, v20, v107, v23
		v_max3_f32 v17, v26, v115, v27
		v_max3_f32 v18, v28, v123, v29
		v_max3_f32 v7, v7, v183, v10
		v_max3_f32 v10, v13, v103, v14
		v_max3_f32 v13, v17, v119, v18
		v_max3_f32 v2, v2, v159, v7
		v_max3_f32 v7, v10, v111, v13
		v_max3_f32 v2, v2, v191, v7
		v_max_f32_e32 v26, v2, v127
		v_mov_b32_e32 v27, v26
		v_max3_f32 v2, v192, v193, v194
		v_max3_f32 v7, v196, v197, v198
		v_max3_f32 v10, v200, v201, v202
		v_max3_f32 v13, v204, v205, v206
		v_max3_f32 v14, v208, v209, v210
		v_max3_f32 v17, v212, v213, v214
		v_max3_f32 v18, v216, v217, v218
		v_max3_f32 v20, v220, v221, v222
		v_max3_f32 v23, v224, v225, v226
		v_max3_f32 v28, v228, v229, v230
		v_max3_f32 v29, v232, v233, v234
		v_max3_f32 v30, v236, v237, v238
		v_max3_f32 v2, v2, v195, v7
		v_max3_f32 v7, v10, v203, v13
		v_max3_f32 v10, v14, v211, v17
		v_max3_f32 v13, v18, v219, v20
		v_permlane32_swap_b32_e32 v26, v27
		v_max3_f32 v14, v23, v227, v28
		v_max3_f32 v17, v29, v235, v30
		v_max3_f32 v2, v2, v199, v7
		v_max3_f32 v7, v10, v215, v13
		v_max3_f32 v10, v14, v231, v17
		v_max3_f32 v2, v4, v175, v2
		v_max3_f32 v4, v7, v223, v10
		v_max3_f32 v2, v2, v207, v4
		v_max_f32_e32 v28, v2, v239
		v_mov_b32_e32 v29, v28
		v_max_f32_e32 v30, v26, v27
		v_mov_b32_e32 v26, v5
		v_permlane32_swap_b32_e32 v28, v29
		v_max_f32_e32 v31, v28, v29
		v_pk_mul_f32 v[28:29], v[30:31], v[8:9]
		v_max_f32_e32 v30, v5, v28
		v_max_f32_e32 v31, v11, v29
		v_pk_fma_f32 v[4:5], v[144:145], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[146:147], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[148:149], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[150:151], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[152:153], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[154:155], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[156:157], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[158:159], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[176:177], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[178:179], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[180:181], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[182:183], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[184:185], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[186:187], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[188:189], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[190:191], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[96:97], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[98:99], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[108:109], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[110:111], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[112:113], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[114:115], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[116:117], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[118:119], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[120:121], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[122:123], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[124:125], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[126:127], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[160:161], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[162:163], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[164:165], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[166:167], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[168:169], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[170:171], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[172:173], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[174:175], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[192:193], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[194:195], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[196:197], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[198:199], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[200:201], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[202:203], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[204:205], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[206:207], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[208:209], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[210:211], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[212:213], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[214:215], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[216:217], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[218:219], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[220:221], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[222:223], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[224:225], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[226:227], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[228:229], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[230:231], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[232:233], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[234:235], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[236:237], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[218:219], v[238:239], v[8:9], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v220, v4
		v_exp_f32_e32 v222, v5
		v_exp_f32_e32 v4, v28
		v_exp_f32_e32 v224, v29
		v_exp_f32_e32 v28, v128
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
		v_exp_f32_e32 v142, v144
		v_exp_f32_e32 v242, v145
		v_exp_f32_e32 v144, v146
		v_exp_f32_e32 v244, v147
		v_exp_f32_e32 v146, v148
		v_exp_f32_e32 v246, v149
		v_exp_f32_e32 v148, v150
		v_exp_f32_e32 v248, v151
		v_exp_f32_e32 v150, v152
		v_exp_f32_e32 v250, v153
		v_exp_f32_e32 v152, v154
		v_exp_f32_e32 v252, v155
		v_exp_f32_e32 v221, v156
		v_exp_f32_e32 v223, v157
		v_exp_f32_e32 v5, v96
		v_exp_f32_e32 v225, v97
		v_exp_f32_e32 v29, v98
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
		v_exp_f32_e32 v145, v116
		v_exp_f32_e32 v245, v117
		v_exp_f32_e32 v147, v118
		v_exp_f32_e32 v247, v119
		v_exp_f32_e32 v149, v120
		v_exp_f32_e32 v249, v121
		v_exp_f32_e32 v151, v122
		v_exp_f32_e32 v251, v123
		v_exp_f32_e32 v153, v124
		v_exp_f32_e32 v253, v125
		v_exp_f32_e32 v96, v126
		v_exp_f32_e32 v98, v127
		v_exp_f32_e32 v100, v158
		v_exp_f32_e32 v102, v159
		v_exp_f32_e32 v104, v160
		v_exp_f32_e32 v106, v161
		v_exp_f32_e32 v108, v162
		v_exp_f32_e32 v110, v163
		v_exp_f32_e32 v112, v164
		v_exp_f32_e32 v114, v165
		v_exp_f32_e32 v116, v166
		v_exp_f32_e32 v118, v167
		v_exp_f32_e32 v120, v168
		v_exp_f32_e32 v122, v169
		v_exp_f32_e32 v124, v170
		v_exp_f32_e32 v126, v171
		v_exp_f32_e32 v154, v172
		v_exp_f32_e32 v156, v173
		v_exp_f32_e32 v158, v174
		v_exp_f32_e32 v160, v175
		v_exp_f32_e32 v162, v176
		v_exp_f32_e32 v164, v177
		v_exp_f32_e32 v166, v178
		v_exp_f32_e32 v168, v179
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
		v_exp_f32_e32 v155, v204
		v_exp_f32_e32 v157, v205
		v_exp_f32_e32 v159, v206
		v_exp_f32_e32 v161, v207
		v_exp_f32_e32 v163, v208
		v_exp_f32_e32 v165, v209
		v_exp_f32_e32 v167, v210
		v_exp_f32_e32 v169, v211
		v_exp_f32_e32 v171, v212
		v_exp_f32_e32 v173, v213
		v_exp_f32_e32 v175, v214
		v_exp_f32_e32 v177, v215
		v_exp_f32_e32 v179, v216
		v_exp_f32_e32 v181, v217
		v_exp_f32_e32 v183, v218
		v_exp_f32_e32 v185, v219
		v_pk_add_f32 v[186:187], v[220:221], v[222:223]
		v_pk_add_f32 v[188:189], v[4:5], v[224:225]
		v_pk_add_f32 v[190:191], v[28:29], v[226:227]
		v_pk_add_f32 v[192:193], v[128:129], v[228:229]
		v_pk_add_f32 v[194:195], v[130:131], v[230:231]
		v_pk_add_f32 v[196:197], v[132:133], v[232:233]
		v_pk_add_f32 v[198:199], v[134:135], v[234:235]
		v_pk_add_f32 v[200:201], v[136:137], v[236:237]
		v_pk_add_f32 v[202:203], v[138:139], v[238:239]
		v_pk_add_f32 v[204:205], v[140:141], v[240:241]
		v_pk_add_f32 v[206:207], v[142:143], v[242:243]
		v_pk_add_f32 v[208:209], v[144:145], v[244:245]
		v_pk_add_f32 v[210:211], v[146:147], v[246:247]
		v_pk_add_f32 v[212:213], v[148:149], v[248:249]
		v_pk_add_f32 v[214:215], v[150:151], v[250:251]
		v_pk_add_f32 v[216:217], v[152:153], v[252:253]
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
		v_add_f32_e32 v2, v190, v191
		v_accvgpr_read_b32 v7, a71
		ds_bpermute_b32 v186, v7, v2
		v_accvgpr_read_b32 v7, a72
		ds_bpermute_b32 v188, v7, v2
		v_pk_add_f32 v[190:191], v[96:97], v[98:99]
		v_pk_add_f32 v[192:193], v[100:101], v[102:103]
		v_pk_add_f32 v[194:195], v[104:105], v[106:107]
		v_pk_add_f32 v[196:197], v[108:109], v[110:111]
		v_pk_add_f32 v[198:199], v[112:113], v[114:115]
		v_pk_add_f32 v[200:201], v[116:117], v[118:119]
		v_pk_add_f32 v[202:203], v[120:121], v[122:123]
		v_pk_add_f32 v[204:205], v[124:125], v[126:127]
		v_pk_add_f32 v[206:207], v[154:155], v[156:157]
		v_pk_add_f32 v[208:209], v[158:159], v[160:161]
		v_pk_add_f32 v[210:211], v[162:163], v[164:165]
		v_pk_add_f32 v[212:213], v[166:167], v[168:169]
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
		v_cvt_pk_bf16_f32 v193, v4, v224
		v_permlane32_swap_b32_e32 v186, v187
		v_add_f32_e32 v189, v186, v187
		v_mov_b32_e32 v27, v11
		v_pk_add_f32 v[10:11], v[26:27], v[30:31] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v26, v10
		v_exp_f32_e32 v27, v11
		v_cvt_pk_bf16_f32 v194, v28, v226
		v_mov_b32_e32 v188, v190
		v_mov_b64_e32 v[10:11], v[24:25]
		v_pk_fma_f32 v[24:25], v[10:11], v[26:27], v[188:189]
		v_cvt_pk_bf16_f32 v195, v128, v228
		v_cvt_pk_bf16_f32 v188, v130, v230
		v_cvt_pk_bf16_f32 v189, v132, v232
		v_cvt_pk_bf16_f32 v190, v134, v234
		v_cvt_pk_bf16_f32 v191, v136, v236
		v_cvt_pk_bf16_f32 v196, v138, v238
		v_cvt_pk_bf16_f32 v197, v140, v240
		v_cvt_pk_bf16_f32 v198, v142, v242
		v_cvt_pk_bf16_f32 v199, v144, v244
		v_cvt_pk_bf16_f32 v200, v146, v246
		v_cvt_pk_bf16_f32 v201, v148, v248
		v_cvt_pk_bf16_f32 v202, v150, v250
		v_cvt_pk_bf16_f32 v203, v152, v252
		v_cvt_pk_bf16_f32 v204, v221, v223
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
		v_cvt_pk_bf16_f32 v205, v5, v225
		v_cvt_pk_bf16_f32 v206, v29, v227
		v_cvt_pk_bf16_f32 v207, v129, v229
		v_cvt_pk_bf16_f32 v208, v131, v231
		v_cvt_pk_bf16_f32 v209, v133, v233
		v_cvt_pk_bf16_f32 v210, v135, v235
		v_cvt_pk_bf16_f32 v211, v137, v237
		v_cvt_pk_bf16_f32 v128, v139, v239
		v_cvt_pk_bf16_f32 v129, v141, v241
		v_cvt_pk_bf16_f32 v130, v143, v243
		v_cvt_pk_bf16_f32 v131, v145, v245
		v_cvt_pk_bf16_f32 v132, v147, v247
		v_cvt_pk_bf16_f32 v133, v149, v249
		v_cvt_pk_bf16_f32 v134, v151, v251
		v_cvt_pk_bf16_f32 v135, v153, v253
		v_cvt_pk_bf16_f32 v136, v96, v98
		v_cvt_pk_bf16_f32 v137, v100, v102
		v_cvt_pk_bf16_f32 v138, v104, v106
		v_cvt_pk_bf16_f32 v139, v108, v110
		v_cvt_pk_bf16_f32 v140, v112, v114
		v_cvt_pk_bf16_f32 v141, v116, v118
		v_cvt_pk_bf16_f32 v142, v120, v122
		v_cvt_pk_bf16_f32 v143, v124, v126
		v_cvt_pk_bf16_f32 v144, v154, v156
		v_cvt_pk_bf16_f32 v145, v158, v160
		v_cvt_pk_bf16_f32 v146, v162, v164
		v_cvt_pk_bf16_f32 v147, v166, v168
		v_cvt_pk_bf16_f32 v148, v170, v172
		v_cvt_pk_bf16_f32 v149, v174, v176
		v_cvt_pk_bf16_f32 v150, v178, v180
		v_cvt_pk_bf16_f32 v151, v182, v184
		v_cvt_pk_bf16_f32 v212, v97, v99
		v_cvt_pk_bf16_f32 v213, v101, v103
		v_cvt_pk_bf16_f32 v214, v105, v107
		v_cvt_pk_bf16_f32 v215, v109, v111
		v_cvt_pk_bf16_f32 v96, v113, v115
		v_cvt_pk_bf16_f32 v97, v117, v119
		v_cvt_pk_bf16_f32 v98, v121, v123
		v_cvt_pk_bf16_f32 v99, v125, v127
		v_cvt_pk_bf16_f32 v100, v155, v157
		v_cvt_pk_bf16_f32 v101, v159, v161
		v_cvt_pk_bf16_f32 v102, v163, v165
		v_cvt_pk_bf16_f32 v103, v167, v169
		v_cvt_pk_bf16_f32 v104, v171, v173
		v_cvt_pk_bf16_f32 v105, v175, v177
		v_cvt_pk_bf16_f32 v106, v179, v181
		v_cvt_pk_bf16_f32 v107, v183, v185
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[32:47], a[100:103], v[192:195], v[32:47]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[48:63], a[132:135], v[192:195], v[48:63]
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_mfma_f32_32x32x16_bf16 v[32:47], a[104:107], v[188:191], v[32:47]
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_mfma_f32_32x32x16_bf16 v[48:63], a[136:139], v[188:191], v[48:63]
		v_permlane32_swap_b32_e32 v208, v210
		v_permlane32_swap_b32_e32 v209, v211
		v_mfma_f32_32x32x16_bf16 v[32:47], a[108:111], v[196:199], v[32:47]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[48:63], a[140:143], v[196:199], v[48:63]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[32:47], a[112:115], v[200:203], v[32:47]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[48:63], a[144:147], v[200:203], v[48:63]
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_mfma_f32_32x32x16_bf16 v[80:95], a[132:135], v[136:139], v[80:95]
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_mfma_f32_32x32x16_bf16 v[64:79], a[100:103], v[136:139], v[64:79]
		v_permlane32_swap_b32_e32 v148, v150
		v_permlane32_swap_b32_e32 v149, v151
		v_mfma_f32_32x32x16_bf16 v[80:95], a[136:139], v[140:143], v[80:95]
		v_permlane32_swap_b32_e32 v212, v214
		v_permlane32_swap_b32_e32 v213, v215
		v_mfma_f32_32x32x16_bf16 v[64:79], a[104:107], v[140:143], v[64:79]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[80:95], a[140:143], v[144:147], v[80:95]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[64:79], a[108:111], v[144:147], v[64:79]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[148:151], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[112:115], v[148:151], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[116:119], v[204:207], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[148:151], v[204:207], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[148:151], v[212:215], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[116:119], v[212:215], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[120:123], v[208:211], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[152:155], v[208:211], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[120:123], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[124:127], v[128:131], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[156:159], v[128:131], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[124:127], v[100:103], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[128:131], v[132:135], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[160:163], v[132:135], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[160:163], v[104:107], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[128:131], v[104:107], v[64:79]
		v_mov_b32_e32 v5, v30
		v_mov_b32_e32 v11, v31
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_1
.L_attn_fwd_persistent.loop_exit_1:
		s_mul_i32 s21, s21, 0x80
		v_accvgpr_read_b32 v2, a14
		v_accvgpr_read_b32 v4, a6
		s_nop 0
		v_readfirstlane_b32 s37, v4
		s_nop 1
		v_add_u32_e32 v2, s37, v2
		v_add_u32_e32 v2, s1, v2
		v_accvgpr_read_b32 v4, a15
		v_accvgpr_read_b32 v7, a6
		s_nop 0
		v_readfirstlane_b32 s37, v7
		s_nop 1
		v_add_u32_e32 v4, s37, v4
		v_add_u32_e32 v4, s1, v4
		v_xor_b32_e32 v7, 1, v6
		v_accvgpr_write_b32 a14, v7
		v_xor_b32_e32 v7, 2, v6
		v_accvgpr_write_b32 a15, v7
		v_xor_b32_e32 v7, 3, v6
		v_accvgpr_write_b32 a67, v7
		v_xor_b32_e32 v7, 8, v6
		v_accvgpr_write_b32 a69, v7
		v_xor_b32_e32 v7, 9, v6
		v_accvgpr_write_b32 a73, v7
		v_xor_b32_e32 v7, 10, v6
		v_accvgpr_write_b32 a74, v7
		v_xor_b32_e32 v7, 11, v6
		v_accvgpr_write_b32 a75, v7
		v_xor_b32_e32 v7, 16, v6
		v_accvgpr_write_b32 a76, v7
		v_xor_b32_e32 v7, 17, v6
		v_accvgpr_write_b32 a77, v7
		v_xor_b32_e32 v7, 18, v6
		v_accvgpr_write_b32 a78, v7
		v_xor_b32_e32 v7, 19, v6
		v_accvgpr_write_b32 a79, v7
		v_xor_b32_e32 v7, 24, v6
		v_accvgpr_write_b32 a80, v7
		v_xor_b32_e32 v7, 25, v6
		v_accvgpr_write_b32 a81, v7
		v_xor_b32_e32 v7, 26, v6
		v_accvgpr_write_b32 a82, v7
		v_xor_b32_e32 v7, 27, v6
		v_accvgpr_write_b32 a83, v7
		v_xor_b32_e32 v7, 32, v6
		v_accvgpr_write_b32 a84, v7
		v_xor_b32_e32 v7, 33, v6
		v_accvgpr_write_b32 a85, v7
		v_xor_b32_e32 v7, 34, v6
		v_accvgpr_write_b32 a86, v7
		v_xor_b32_e32 v7, 35, v6
		v_accvgpr_write_b32 a87, v7
		v_xor_b32_e32 v7, 40, v6
		v_accvgpr_write_b32 a88, v7
		v_xor_b32_e32 v7, 41, v6
		v_accvgpr_write_b32 a89, v7
		v_xor_b32_e32 v7, 42, v6
		v_accvgpr_write_b32 a90, v7
		v_xor_b32_e32 v7, 43, v6
		v_accvgpr_write_b32 a91, v7
		v_xor_b32_e32 v7, 48, v6
		v_accvgpr_write_b32 a92, v7
		v_xor_b32_e32 v7, 49, v6
		v_accvgpr_write_b32 a93, v7
		v_xor_b32_e32 v7, 50, v6
		v_accvgpr_write_b32 a94, v7
		v_xor_b32_e32 v7, 51, v6
		v_accvgpr_write_b32 a95, v7
		v_xor_b32_e32 v7, 56, v6
		v_accvgpr_write_b32 a96, v7
		v_xor_b32_e32 v7, 57, v6
		v_accvgpr_write_b32 a97, v7
		v_xor_b32_e32 v7, 58, v6
		v_accvgpr_write_b32 a98, v7
		v_xor_b32_e32 v7, 59, v6
		v_accvgpr_write_b32 a99, v7
		v_xor_b32_e32 v7, 64, v6
		v_accvgpr_write_b32 a100, v7
		v_xor_b32_e32 v7, 0x41, v6
		v_accvgpr_write_b32 a101, v7
		v_xor_b32_e32 v7, 0x42, v6
		v_accvgpr_write_b32 a102, v7
		v_xor_b32_e32 v7, 0x43, v6
		v_accvgpr_write_b32 a103, v7
		v_xor_b32_e32 v7, 0x48, v6
		v_accvgpr_write_b32 a104, v7
		v_xor_b32_e32 v7, 0x49, v6
		v_accvgpr_write_b32 a105, v7
		v_xor_b32_e32 v7, 0x4a, v6
		v_accvgpr_write_b32 a106, v7
		v_xor_b32_e32 v7, 0x4b, v6
		v_accvgpr_write_b32 a107, v7
		v_xor_b32_e32 v7, 0x50, v6
		v_accvgpr_write_b32 a108, v7
		v_xor_b32_e32 v7, 0x51, v6
		v_accvgpr_write_b32 a109, v7
		v_xor_b32_e32 v7, 0x52, v6
		v_accvgpr_write_b32 a110, v7
		v_xor_b32_e32 v7, 0x53, v6
		v_accvgpr_write_b32 a111, v7
		v_xor_b32_e32 v7, 0x58, v6
		v_accvgpr_write_b32 a112, v7
		v_xor_b32_e32 v7, 0x59, v6
		v_accvgpr_write_b32 a113, v7
		v_xor_b32_e32 v7, 0x5a, v6
		v_accvgpr_write_b32 a114, v7
		v_xor_b32_e32 v7, 0x5b, v6
		v_accvgpr_write_b32 a115, v7
		v_xor_b32_e32 v7, 0x60, v6
		v_accvgpr_write_b32 a116, v7
		v_xor_b32_e32 v7, 0x61, v6
		v_accvgpr_write_b32 a117, v7
		v_xor_b32_e32 v7, 0x62, v6
		v_accvgpr_write_b32 a118, v7
		v_xor_b32_e32 v7, 0x63, v6
		v_accvgpr_write_b32 a119, v7
		v_xor_b32_e32 v7, 0x68, v6
		v_accvgpr_write_b32 a120, v7
		v_xor_b32_e32 v7, 0x69, v6
		v_accvgpr_write_b32 a121, v7
		v_xor_b32_e32 v7, 0x6a, v6
		v_accvgpr_write_b32 a122, v7
		v_xor_b32_e32 v7, 0x6b, v6
		v_accvgpr_write_b32 a123, v7
		v_xor_b32_e32 v7, 0x70, v6
		v_accvgpr_write_b32 a124, v7
		v_xor_b32_e32 v7, 0x71, v6
		v_accvgpr_write_b32 a125, v7
		v_xor_b32_e32 v7, 0x72, v6
		v_accvgpr_write_b32 a126, v7
		v_xor_b32_e32 v7, 0x73, v6
		v_accvgpr_write_b32 a127, v7
		v_xor_b32_e32 v7, 0x78, v6
		v_accvgpr_write_b32 a128, v7
		v_xor_b32_e32 v7, 0x79, v6
		v_accvgpr_write_b32 a129, v7
		v_xor_b32_e32 v7, 0x7a, v6
		v_accvgpr_write_b32 a130, v7
		v_xor_b32_e32 v7, 0x7b, v6
		v_accvgpr_write_b32 a131, v7
		v_accvgpr_read_b32 v7, a56
		v_accvgpr_read_b32 v8, a64
		v_accvgpr_read_b32 v9, a65
		v_add3_u32 v7, v7, v8, v9
		v_accvgpr_write_b32 a56, v7
		v_accvgpr_read_b32 v7, a66
		v_accvgpr_read_b32 v8, a68
		v_lshl_add_u32 v7, v7, 3, v8
		v_accvgpr_read_b32 v8, a17
		v_lshl_add_u32 v7, v8, 5, v7
		v_accvgpr_read_b32 v8, a58
		v_accvgpr_read_b32 v9, a70
		v_add3_u32 v7, v7, v9, v8
		v_accvgpr_write_b32 a17, v7
		v_mov_b32_e32 v7, 0xff800000
		s_cmp_lt_i32 s44, s21
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_2
.L_attn_fwd_persistent.loop_head_2:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s1, s44, 0x80
		s_cmp_lt_i32 s44, 0
		s_cselect_b32 s37, s23, 0
		s_add_i32 s37, s44, s37
		s_ashr_i32 s37, s37, 7
		s_cmp_lt_i32 s37, 0
		s_cselect_b32 s39, s16, 0
		s_add_i32 s39, s37, s39
		s_ashr_i32 s39, s39, 1
		s_lshl_b32 s39, s39, 1
		s_sub_i32 s39, s37, s39
		s_add_i32 s37, s37, 1
		s_cmp_lt_i32 s37, 0
		s_cselect_b32 s41, s16, 0
		s_add_i32 s41, s37, s41
		s_ashr_i32 s41, s41, 1
		s_lshl_b32 s41, s41, 1
		s_sub_i32 s50, s37, s41
		s_mul_i32 s37, 0x4100, s39
		v_accvgpr_read_b32 v8, a56
		v_add_u32_e32 v8, s37, v8
		ds_read_b128 a[132:135], v8
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
		s_mul_i32 s37, 0x4400, s39
		v_accvgpr_read_b32 v8, a17
		v_add_u32_e32 v8, s37, v8
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
		v_accvgpr_read_b32 v8, a18
		v_add_u32_e32 v8, s1, v8
		v_cmp_lt_i32_e64 s[52:53], v8, s20
		v_accvgpr_read_b32 v8, a19
		v_add_u32_e32 v8, s1, v8
		v_cmp_lt_i32_e64 s[54:55], v8, s20
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s37, s15, s44
		s_lshl_b32 s37, s37, 1
		s_add_i32 s39, s24, s37
		v_add3_u32 v8, s39, v16, v19
		v_add3_u32 v8, v8, v21, v12
		v_cndmask_b32_e64 v8, v22, v8, s[52:53]
		s_mov_b32 s52, 1
		s_mov_b32 s53, 0
		s_mul_i32 s56, s52, s26
		s_mul_hi_u32 s57, s52, s26
		s_mul_i32 s39, s52, s27
		s_add_i32 s57, s57, s39
		s_mul_i32 s39, s53, s26
		s_add_i32 s57, s57, s39
		s_lshr_b64 s[52:53], s[56:57], 6
		s_mov_b32 s56, 0x410
		s_mov_b32 s57, 0
		s_mul_i32 s58, s56, s52
		s_mul_hi_u32 s59, s56, s52
		s_mul_i32 s39, s56, s53
		s_add_i32 s59, s59, s39
		s_mul_i32 s39, s57, s52
		s_add_i32 s59, s59, s39
		s_cmp_lt_i32 s50, 0
		s_cselect_b32 s51, -1, 0
		s_mov_b32 s56, 0x4100
		s_mov_b32 s57, 0
		s_mul_i32 s60, s56, s50
		s_mul_hi_u32 s61, s56, s50
		s_mul_i32 s39, s56, s51
		s_add_i32 s61, s61, s39
		s_mul_i32 s39, s57, s50
		s_add_i32 s61, s61, s39
		s_add_u32 s56, s58, s60
		s_addc_u32 s57, s59, s61
		s_add_u32 s62, s56, 0
		s_addc_u32 s63, s57, 0
		s_mov_b32 m0, s62
		v_accvgpr_read_b32 v9, a57
		v_add_u32_e32 v9, s1, v9
		buffer_load_dwordx4 v8, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[56:57], v9, s20
		s_add_i32 s39, s46, s37
		v_add3_u32 v8, s39, v16, v19
		v_add3_u32 v8, v8, v21, v12
		v_cndmask_b32_e64 v8, v22, v8, s[56:57]
		s_add_u32 s56, s58, 0x1040
		s_addc_u32 s57, s59, 0
		s_add_u32 s56, s56, s60
		s_addc_u32 s57, s57, s61
		s_add_u32 s62, s56, 0
		s_addc_u32 s63, s57, 0
		s_mov_b32 m0, s62
		v_accvgpr_read_b32 v9, a59
		v_add_u32_e32 v9, s1, v9
		buffer_load_dwordx4 v8, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[56:57], v9, s20
		s_add_i32 s39, s47, s37
		v_add3_u32 v8, s39, v16, v19
		v_add3_u32 v8, v8, v21, v12
		v_cndmask_b32_e64 v8, v22, v8, s[56:57]
		s_add_u32 s56, s58, 0x2080
		s_addc_u32 s57, s59, 0
		s_add_u32 s56, s56, s60
		s_addc_u32 s57, s57, s61
		s_add_u32 s62, s56, 0
		s_addc_u32 s63, s57, 0
		s_mov_b32 m0, s62
		v_accvgpr_read_b32 v9, a60
		v_add_u32_e32 v9, s1, v9
		buffer_load_dwordx4 v8, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[56:57], v9, s20
		s_add_i32 s37, s25, s37
		v_add3_u32 v8, s37, v16, v19
		v_add3_u32 v8, v8, v21, v12
		v_cndmask_b32_e64 v8, v22, v8, s[56:57]
		s_add_u32 s56, s58, 0x30c0
		s_addc_u32 s57, s59, 0
		s_add_u32 s56, s56, s60
		s_addc_u32 s57, s57, s61
		s_add_u32 s58, s56, 0
		s_addc_u32 s59, s57, 0
		s_mov_b32 m0, s58
		v_accvgpr_read_b32 v9, a61
		v_add_u32_e32 v9, s1, v9
		buffer_load_dwordx4 v8, s[28:31], 0 offen lds
		s_mul_i32 s37, s17, s44
		s_lshl_b32 s37, s37, 1
		s_add_i32 s39, s38, s37
		v_add3_u32 v8, s39, v1, v3
		v_add3_u32 v8, v8, v15, v12
		v_cndmask_b32_e64 v8, v22, v8, s[54:55]
		s_mov_b32 s54, 0x440
		s_mov_b32 s55, 0
		s_mul_i32 s56, s54, s52
		s_mul_hi_u32 s57, s54, s52
		s_mul_i32 s39, s54, s53
		s_add_i32 s57, s57, s39
		s_mul_i32 s39, s55, s52
		s_add_i32 s57, s57, s39
		s_add_u32 s52, s56, 0x81f0
		s_addc_u32 s53, s57, 0
		s_mov_b32 s54, 0x4400
		s_mov_b32 s55, 0
		s_mul_i32 s58, s54, s50
		s_mul_hi_u32 s59, s54, s50
		s_mul_i32 s39, s54, s51
		s_add_i32 s59, s59, s39
		s_mul_i32 s39, s55, s50
		s_add_i32 s59, s59, s39
		s_add_u32 s50, s52, s58
		s_addc_u32 s51, s53, s59
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		v_accvgpr_read_b32 v10, a62
		v_add_u32_e32 v10, s1, v10
		buffer_load_dwordx4 v8, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[50:51], v9, s20
		s_add_i32 s39, s40, s37
		v_add3_u32 v8, s39, v1, v3
		v_add3_u32 v8, v8, v15, v12
		v_cndmask_b32_e64 v8, v22, v8, s[50:51]
		s_add_u32 s50, s56, 0x92f0
		s_addc_u32 s51, s57, 0
		s_add_u32 s50, s50, s58
		s_addc_u32 s51, s51, s59
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		v_accvgpr_read_b32 v9, a63
		v_add_u32_e32 v9, s1, v9
		buffer_load_dwordx4 v8, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[50:51], v10, s20
		s_add_i32 s39, s48, s37
		v_add3_u32 v8, s39, v1, v3
		v_add3_u32 v8, v8, v15, v12
		s_add_u32 s52, s56, 0xa3f0
		s_addc_u32 s53, s57, 0
		s_add_u32 s52, s52, s58
		s_addc_u32 s53, s53, s59
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v8, v22, v8, s[50:51]
		buffer_load_dwordx4 v8, s[32:35], 0 offen lds
		s_add_i32 s37, s36, s37
		v_add3_u32 v8, s37, v1, v3
		v_cmp_lt_i32_e64 vcc, v9, s20
		v_add3_u32 v8, v8, v15, v12
		s_add_u32 s50, s56, 0xb4f0
		s_addc_u32 s51, s57, 0
		v_cndmask_b32_e32 v8, v22, v8, vcc
		s_add_u32 s50, s50, s58
		s_addc_u32 s51, s51, s59
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		s_nop 0
		buffer_load_dwordx4 v8, s[32:35], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_2
.L_attn_fwd_persistent.if_else_2:
.L_attn_fwd_persistent.if_end_2:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[96:111], a[132:135], a[20:23], 0
		s_cmp_lt_i32 s1, s21
		v_mfma_f32_32x32x16_bf16 v[112:127], a[148:151], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[128:143], a[164:167], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[28:31], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[176:191], a[132:135], a[36:39], 0
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
		v_add_u32_e32 v8, s44, v6
		v_mfma_f32_32x32x16_bf16 v[176:191], a[140:143], a[44:47], v[176:191]
		v_accvgpr_read_b32 v9, a14
		v_add_u32_e32 v9, s44, v9
		v_mfma_f32_32x32x16_bf16 v[192:207], a[156:159], a[44:47], v[192:207]
		v_accvgpr_read_b32 v10, a15
		v_add_u32_e32 v10, s44, v10
		v_mfma_f32_32x32x16_bf16 v[208:223], a[172:175], a[44:47], v[208:223]
		v_accvgpr_read_b32 v13, a67
		v_add_u32_e32 v13, s44, v13
		v_mfma_f32_32x32x16_bf16 v[96:111], a[144:147], a[32:35], v[96:111]
		v_cmp_ge_i32_e64 vcc, v2, v13
		v_mfma_f32_32x32x16_bf16 v[112:127], a[160:163], a[32:35], v[112:127]
		v_accvgpr_read_b32 v14, a74
		v_add_u32_e32 v14, s44, v14
		v_mfma_f32_32x32x16_bf16 v[128:143], a[176:179], a[32:35], v[128:143]
		v_accvgpr_read_b32 v17, a75
		v_add_u32_e32 v17, s44, v17
		v_mfma_f32_32x32x16_bf16 v[144:159], a[188:191], a[32:35], v[144:159]
		v_accvgpr_read_b32 v18, a78
		v_add_u32_e32 v18, s44, v18
		v_mfma_f32_32x32x16_bf16 v[160:175], a[188:191], a[48:51], v[160:175]
		v_accvgpr_read_b32 v20, a79
		v_add_u32_e32 v20, s44, v20
		v_mfma_f32_32x32x16_bf16 v[176:191], a[144:147], a[48:51], v[176:191]
		v_accvgpr_read_b32 v23, a82
		v_add_u32_e32 v23, s44, v23
		v_mfma_f32_32x32x16_bf16 v[192:207], a[160:163], a[48:51], v[192:207]
		v_cndmask_b32_e32 v27, v7, v99, vcc
		v_mfma_f32_32x32x16_bf16 v[208:223], a[176:179], a[48:51], v[208:223]
		v_accvgpr_read_b32 v26, a83
		v_add_u32_e32 v28, s44, v26
		v_accvgpr_read_b32 v26, a86
		v_add_u32_e32 v29, s44, v26
		v_accvgpr_read_b32 v26, a87
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a58, v26
		v_accvgpr_read_b32 v26, a90
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a64, v26
		v_accvgpr_read_b32 v26, a91
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a65, v26
		v_accvgpr_read_b32 v26, a94
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a66, v26
		v_accvgpr_read_b32 v26, a95
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a68, v26
		v_accvgpr_read_b32 v26, a98
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a70, v26
		v_accvgpr_read_b32 v26, a99
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a132, v26
		v_accvgpr_read_b32 v26, a102
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a133, v26
		v_accvgpr_read_b32 v26, a103
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a134, v26
		v_accvgpr_read_b32 v26, a106
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a135, v26
		v_accvgpr_read_b32 v26, a107
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a136, v26
		v_accvgpr_read_b32 v26, a110
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a137, v26
		v_accvgpr_read_b32 v26, a111
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a138, v26
		v_accvgpr_read_b32 v26, a114
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a139, v26
		v_accvgpr_read_b32 v26, a115
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a140, v26
		v_accvgpr_read_b32 v26, a118
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a141, v26
		v_accvgpr_read_b32 v26, a119
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a142, v26
		v_accvgpr_read_b32 v26, a122
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a143, v26
		v_accvgpr_read_b32 v26, a123
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a144, v26
		v_accvgpr_read_b32 v26, a126
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a145, v26
		v_accvgpr_read_b32 v26, a127
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a146, v26
		v_accvgpr_read_b32 v26, a130
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a147, v26
		v_accvgpr_read_b32 v26, a131
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a148, v26
		v_cmp_ge_i32_e64 s[50:51], v2, v8
		v_cmp_ge_i32_e64 s[52:53], v2, v9
		v_cmp_ge_i32_e64 s[54:55], v2, v10
		v_accvgpr_read_b32 v26, a69
		v_add_u32_e32 v30, s44, v26
		v_accvgpr_read_b32 v26, a73
		v_add_u32_e32 v31, s44, v26
		v_cmp_ge_i32_e64 s[56:57], v2, v30
		v_cmp_ge_i32_e64 s[58:59], v2, v31
		v_cmp_ge_i32_e64 s[60:61], v2, v14
		v_cmp_ge_i32_e64 vcc, v2, v17
		v_accvgpr_read_b32 v26, a76
		v_add_u32_e32 v99, s44, v26
		v_accvgpr_read_b32 v26, a77
		v_add_u32_e32 v224, s44, v26
		v_cndmask_b32_e32 v227, v7, v103, vcc
		v_cmp_ge_i32_e64 s[62:63], v2, v99
		v_cmp_ge_i32_e64 s[64:65], v2, v224
		v_cmp_ge_i32_e64 s[66:67], v2, v18
		v_cmp_ge_i32_e64 vcc, v2, v20
		v_accvgpr_read_b32 v26, a80
		v_add_u32_e32 v103, s44, v26
		v_accvgpr_read_b32 v26, a81
		v_add_u32_e32 v225, s44, v26
		v_cndmask_b32_e32 v229, v7, v107, vcc
		v_cmp_ge_i32_e64 s[68:69], v2, v103
		v_cmp_ge_i32_e64 s[70:71], v2, v225
		v_cmp_ge_i32_e64 s[72:73], v2, v23
		v_cmp_ge_i32_e64 vcc, v2, v28
		v_accvgpr_read_b32 v26, a84
		v_add_u32_e32 v107, s44, v26
		v_accvgpr_read_b32 v26, a85
		v_add_u32_e32 v230, s44, v26
		v_cndmask_b32_e32 v233, v7, v111, vcc
		v_cmp_ge_i32_e64 s[74:75], v2, v107
		v_cmp_ge_i32_e64 s[76:77], v2, v230
		v_cmp_ge_i32_e64 s[78:79], v2, v29
		v_accvgpr_read_b32 v26, a58
		v_cmp_ge_i32_e64 vcc, v2, v26
		v_accvgpr_read_b32 v26, a88
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a149, v26
		v_accvgpr_read_b32 v26, a89
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a150, v26
		v_cndmask_b32_e32 v235, v7, v115, vcc
		v_accvgpr_read_b32 v26, a149
		v_cmp_ge_i32_e64 s[80:81], v2, v26
		v_accvgpr_read_b32 v26, a150
		v_cmp_ge_i32_e64 s[82:83], v2, v26
		v_accvgpr_read_b32 v26, a64
		v_cmp_ge_i32_e64 s[84:85], v2, v26
		v_accvgpr_read_b32 v26, a65
		v_cmp_ge_i32_e64 vcc, v2, v26
		v_accvgpr_read_b32 v26, a92
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a151, v26
		v_accvgpr_read_b32 v26, a93
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a152, v26
		v_cndmask_b32_e32 v237, v7, v119, vcc
		v_accvgpr_read_b32 v26, a151
		v_cmp_ge_i32_e64 s[86:87], v2, v26
		v_accvgpr_read_b32 v26, a68
		v_cmp_ge_i32_e64 vcc, v2, v26
		v_accvgpr_read_b32 v26, a96
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a153, v26
		v_accvgpr_read_b32 v26, a97
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a154, v26
		v_cndmask_b32_e32 v239, v7, v123, vcc
		v_accvgpr_read_b32 v26, a132
		v_cmp_ge_i32_e64 vcc, v2, v26
		v_accvgpr_read_b32 v26, a100
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a155, v26
		v_accvgpr_read_b32 v26, a101
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a156, v26
		v_cndmask_b32_e32 v241, v7, v127, vcc
		v_accvgpr_read_b32 v26, a134
		v_cmp_ge_i32_e64 vcc, v2, v26
		v_accvgpr_read_b32 v26, a104
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a157, v26
		v_accvgpr_read_b32 v26, a105
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a158, v26
		v_cndmask_b32_e32 v243, v7, v131, vcc
		v_accvgpr_read_b32 v26, a136
		v_cmp_ge_i32_e64 vcc, v2, v26
		v_accvgpr_read_b32 v26, a108
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a159, v26
		v_accvgpr_read_b32 v26, a109
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a160, v26
		v_cndmask_b32_e32 v245, v7, v135, vcc
		v_accvgpr_read_b32 v26, a138
		v_cmp_ge_i32_e64 vcc, v2, v26
		v_accvgpr_read_b32 v26, a112
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a161, v26
		v_accvgpr_read_b32 v26, a113
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a162, v26
		v_cndmask_b32_e32 v247, v7, v139, vcc
		v_accvgpr_read_b32 v26, a140
		v_cmp_ge_i32_e64 vcc, v2, v26
		v_accvgpr_read_b32 v26, a152
		v_cmp_ge_i32_e64 s[88:89], v2, v26
		v_cndmask_b32_e64 v248, v7, v96, s[50:51]
		v_accvgpr_read_b32 v26, a66
		v_cmp_ge_i32_e64 s[50:51], v2, v26
		v_accvgpr_read_b32 v26, a153
		v_cmp_ge_i32_e64 s[90:91], v2, v26
		s_nop 1
		v_mov_b32_e32 v250, s90
		v_mov_b32_e32 v251, s91
		v_accvgpr_write_b32 a164, v250
		v_accvgpr_write_b32 a165, v251
		v_accvgpr_read_b32 v26, a154
		v_cmp_ge_i32_e64 s[90:91], v2, v26
		s_nop 1
		v_mov_b32_e32 v250, s90
		v_mov_b32_e32 v251, s91
		v_accvgpr_write_b32 a166, v250
		v_accvgpr_write_b32 a167, v251
		v_accvgpr_read_b32 v26, a70
		v_cmp_ge_i32_e64 s[90:91], v2, v26
		s_nop 1
		v_mov_b32_e32 v250, s90
		v_mov_b32_e32 v251, s91
		v_accvgpr_write_b32 a168, v250
		v_accvgpr_write_b32 a169, v251
		v_accvgpr_read_b32 v26, a155
		v_cmp_ge_i32_e64 s[90:91], v2, v26
		s_nop 1
		v_mov_b32_e32 v250, s90
		v_mov_b32_e32 v251, s91
		v_accvgpr_write_b32 a170, v250
		v_accvgpr_write_b32 a171, v251
		v_accvgpr_read_b32 v26, a156
		v_cmp_ge_i32_e64 s[90:91], v2, v26
		s_nop 1
		v_mov_b32_e32 v250, s90
		v_mov_b32_e32 v251, s91
		v_accvgpr_write_b32 a172, v250
		v_accvgpr_write_b32 a173, v251
		v_accvgpr_read_b32 v26, a133
		v_cmp_ge_i32_e64 s[90:91], v2, v26
		s_nop 1
		v_mov_b32_e32 v250, s90
		v_mov_b32_e32 v251, s91
		v_accvgpr_write_b32 a174, v250
		v_accvgpr_write_b32 a175, v251
		v_accvgpr_read_b32 v26, a157
		v_cmp_ge_i32_e64 s[90:91], v2, v26
		s_nop 1
		v_mov_b32_e32 v250, s90
		v_mov_b32_e32 v251, s91
		v_accvgpr_write_b32 a176, v250
		v_accvgpr_write_b32 a177, v251
		v_accvgpr_read_b32 v26, a158
		v_cmp_ge_i32_e64 s[90:91], v2, v26
		s_nop 1
		v_mov_b32_e32 v250, s90
		v_mov_b32_e32 v251, s91
		v_accvgpr_write_b32 a178, v250
		v_accvgpr_write_b32 a179, v251
		v_accvgpr_read_b32 v26, a135
		v_cmp_ge_i32_e64 s[90:91], v2, v26
		s_nop 1
		v_mov_b32_e32 v250, s90
		v_mov_b32_e32 v251, s91
		v_accvgpr_write_b32 a180, v250
		v_accvgpr_write_b32 a181, v251
		v_accvgpr_read_b32 v26, a159
		v_cmp_ge_i32_e64 s[90:91], v2, v26
		s_nop 1
		v_mov_b32_e32 v250, s90
		v_mov_b32_e32 v251, s91
		v_accvgpr_write_b32 a182, v250
		v_accvgpr_write_b32 a183, v251
		v_accvgpr_read_b32 v26, a160
		v_cmp_ge_i32_e64 s[90:91], v2, v26
		s_nop 1
		v_mov_b32_e32 v250, s90
		v_mov_b32_e32 v251, s91
		v_accvgpr_write_b32 a184, v250
		v_accvgpr_write_b32 a185, v251
		v_accvgpr_read_b32 v26, a137
		v_cmp_ge_i32_e64 s[90:91], v2, v26
		v_accvgpr_read_b32 v26, a161
		v_cmp_ge_i32_e64 s[92:93], v2, v26
		v_accvgpr_read_b32 v26, a162
		v_cmp_ge_i32_e64 s[94:95], v2, v26
		v_accvgpr_read_b32 v26, a139
		v_cmp_ge_i32_e64 s[96:97], v2, v26
		v_cndmask_b32_e32 v251, v7, v143, vcc
		v_cndmask_b32_e64 v253, v7, v141, s[94:95]
		v_cndmask_b32_e64 v250, v7, v142, s[96:97]
		v_accvgpr_read_b32 v26, a116
		v_add_u32_e32 v96, s44, v26
		v_accvgpr_read_b32 v26, a117
		v_add_u32_e32 v111, s44, v26
		v_cmp_ge_i32_e64 s[94:95], v2, v96
		v_cmp_ge_i32_e64 s[96:97], v2, v111
		v_accvgpr_read_b32 v26, a141
		v_cmp_ge_i32_e64 s[98:99], v2, v26
		v_cndmask_b32_e64 v142, v7, v144, s[94:95]
		v_cndmask_b32_e64 v143, v7, v145, s[96:97]
		v_cndmask_b32_e64 v144, v7, v146, s[98:99]
		v_accvgpr_read_b32 v26, a142
		v_cmp_ge_i32_e64 vcc, v2, v26
		v_accvgpr_read_b32 v26, a120
		v_add_u32_e32 v115, s44, v26
		v_accvgpr_read_b32 v26, a121
		v_add_u32_e32 v119, s44, v26
		v_cndmask_b32_e32 v145, v7, v147, vcc
		v_cmp_ge_i32_e64 s[94:95], v2, v115
		v_cmp_ge_i32_e64 s[96:97], v2, v119
		v_accvgpr_read_b32 v26, a143
		v_cmp_ge_i32_e64 s[98:99], v2, v26
		v_cndmask_b32_e64 v146, v7, v148, s[94:95]
		v_cndmask_b32_e64 v147, v7, v149, s[96:97]
		v_cndmask_b32_e64 v148, v7, v150, s[98:99]
		v_accvgpr_read_b32 v26, a144
		v_cmp_ge_i32_e64 vcc, v2, v26
		v_accvgpr_read_b32 v26, a124
		v_add_u32_e32 v123, s44, v26
		v_accvgpr_read_b32 v26, a125
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a163, v26
		v_cndmask_b32_e32 v149, v7, v151, vcc
		v_cmp_ge_i32_e64 s[94:95], v2, v123
		v_accvgpr_read_b32 v26, a163
		v_cmp_ge_i32_e64 s[96:97], v2, v26
		v_accvgpr_read_b32 v26, a145
		v_cmp_ge_i32_e64 s[98:99], v2, v26
		v_cndmask_b32_e64 v150, v7, v152, s[94:95]
		v_cndmask_b32_e64 v151, v7, v153, s[96:97]
		v_cndmask_b32_e64 v152, v7, v154, s[98:99]
		v_accvgpr_read_b32 v26, a146
		v_cmp_ge_i32_e64 vcc, v2, v26
		v_accvgpr_read_b32 v26, a128
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a186, v26
		v_accvgpr_read_b32 v26, a129
		v_add_u32_e32 v26, s44, v26
		v_accvgpr_write_b32 a187, v26
		v_cndmask_b32_e32 v153, v7, v155, vcc
		v_accvgpr_read_b32 v26, a186
		v_cmp_ge_i32_e64 s[94:95], v2, v26
		v_accvgpr_read_b32 v26, a187
		v_cmp_ge_i32_e64 s[96:97], v2, v26
		v_accvgpr_read_b32 v26, a147
		v_cmp_ge_i32_e64 s[98:99], v2, v26
		v_cndmask_b32_e64 v154, v7, v156, s[94:95]
		v_cndmask_b32_e64 v155, v7, v157, s[96:97]
		v_cndmask_b32_e64 v156, v7, v158, s[98:99]
		v_cndmask_b32_e64 v249, v7, v97, s[52:53]
		v_accvgpr_read_b32 v26, a148
		v_cmp_ge_i32_e64 vcc, v2, v26
		v_max3_f32 v26, v142, v143, v144
		v_accvgpr_write_b32 a188, v26
		v_max3_f32 v26, v146, v147, v148
		v_accvgpr_write_b32 a189, v26
		v_cndmask_b32_e32 v157, v7, v159, vcc
		v_cmp_ge_i32_e64 s[52:53], v4, v8
		v_cmp_ge_i32_e64 s[94:95], v4, v9
		v_cmp_ge_i32_e64 s[96:97], v4, v10
		v_max3_f32 v8, v150, v151, v152
		v_accvgpr_write_b32 a190, v8
		v_max3_f32 v8, v154, v155, v156
		v_accvgpr_write_b32 a191, v8
		v_cndmask_b32_e64 v8, v7, v178, s[96:97]
		v_cmp_ge_i32_e64 vcc, v4, v13
		v_cndmask_b32_e64 v26, v7, v98, s[54:55]
		v_mov_b32_e32 v10, 0xff800000
		v_cndmask_b32_e64 v158, v10, v100, s[56:57]
		v_cndmask_b32_e32 v9, v10, v179, vcc
		v_cmp_ge_i32_e64 s[54:55], v4, v30
		v_cmp_ge_i32_e64 s[56:57], v4, v31
		v_cmp_ge_i32_e64 s[96:97], v4, v14
		v_cndmask_b32_e64 v30, v10, v180, s[54:55]
		v_cndmask_b32_e64 v31, v10, v181, s[56:57]
		v_cndmask_b32_e64 v178, v10, v182, s[96:97]
		v_cmp_ge_i32_e64 vcc, v4, v17
		v_cndmask_b32_e64 v159, v10, v101, s[58:59]
		v_cndmask_b32_e64 v226, v10, v102, s[60:61]
		v_cndmask_b32_e64 v100, v10, v104, s[62:63]
		v_cndmask_b32_e32 v179, v10, v183, vcc
		v_cmp_ge_i32_e64 s[54:55], v4, v99
		v_cmp_ge_i32_e64 s[56:57], v4, v224
		v_cmp_ge_i32_e64 s[58:59], v4, v18
		v_cndmask_b32_e64 v98, v10, v184, s[54:55]
		v_cndmask_b32_e64 v99, v10, v185, s[56:57]
		v_cndmask_b32_e64 v180, v10, v186, s[58:59]
		v_cmp_ge_i32_e64 vcc, v4, v20
		v_cndmask_b32_e64 v101, v10, v105, s[64:65]
		v_max3_f32 v13, v248, v249, v26
		v_cndmask_b32_e32 v181, v10, v187, vcc
		v_cmp_ge_i32_e64 s[54:55], v4, v103
		v_cmp_ge_i32_e64 s[56:57], v4, v225
		v_cmp_ge_i32_e64 s[58:59], v4, v23
		v_cndmask_b32_e64 v102, v10, v188, s[54:55]
		v_cndmask_b32_e64 v103, v10, v189, s[56:57]
		v_cndmask_b32_e64 v104, v10, v190, s[58:59]
		v_cmp_ge_i32_e64 vcc, v4, v28
		v_cndmask_b32_e64 v228, v10, v106, s[66:67]
		v_cndmask_b32_e64 v182, v10, v108, s[68:69]
		v_cndmask_b32_e32 v105, v10, v191, vcc
		v_cmp_ge_i32_e64 s[54:55], v4, v107
		v_cmp_ge_i32_e64 s[56:57], v4, v230
		v_cmp_ge_i32_e64 s[58:59], v4, v29
		v_cndmask_b32_e64 v28, v10, v192, s[54:55]
		v_cndmask_b32_e64 v29, v10, v193, s[56:57]
		v_cndmask_b32_e64 v106, v10, v194, s[58:59]
		v_accvgpr_read_b32 v14, a58
		v_cmp_ge_i32_e64 vcc, v4, v14
		v_cndmask_b32_e64 v183, v10, v109, s[70:71]
		v_cndmask_b32_e64 v232, v10, v110, s[72:73]
		v_cndmask_b32_e64 v108, v10, v112, s[74:75]
		v_cndmask_b32_e32 v107, v10, v195, vcc
		v_accvgpr_read_b32 v14, a149
		v_cmp_ge_i32_e64 s[54:55], v4, v14
		v_accvgpr_read_b32 v14, a150
		v_cmp_ge_i32_e64 s[56:57], v4, v14
		v_accvgpr_read_b32 v14, a64
		v_cmp_ge_i32_e64 s[58:59], v4, v14
		v_cndmask_b32_e64 v184, v10, v196, s[54:55]
		v_cndmask_b32_e64 v185, v10, v197, s[56:57]
		v_cndmask_b32_e64 v186, v10, v198, s[58:59]
		v_accvgpr_read_b32 v14, a65
		v_cmp_ge_i32_e64 vcc, v4, v14
		v_cndmask_b32_e64 v109, v10, v113, s[76:77]
		v_max3_f32 v14, v158, v159, v226
		v_cndmask_b32_e32 v187, v10, v199, vcc
		v_accvgpr_read_b32 v17, a151
		v_cmp_ge_i32_e64 s[54:55], v4, v17
		v_accvgpr_read_b32 v17, a152
		v_cmp_ge_i32_e64 s[56:57], v4, v17
		v_accvgpr_read_b32 v17, a66
		v_cmp_ge_i32_e64 s[58:59], v4, v17
		v_cndmask_b32_e64 v112, v10, v200, s[54:55]
		v_cndmask_b32_e64 v113, v10, v201, s[56:57]
		v_cndmask_b32_e64 v188, v10, v202, s[58:59]
		v_accvgpr_read_b32 v17, a68
		v_cmp_ge_i32_e64 vcc, v4, v17
		v_cndmask_b32_e64 v234, v10, v114, s[78:79]
		v_cndmask_b32_e64 v190, v10, v116, s[80:81]
		v_cndmask_b32_e32 v189, v10, v203, vcc
		v_accvgpr_read_b32 v17, a153
		v_cmp_ge_i32_e64 s[54:55], v4, v17
		v_accvgpr_read_b32 v17, a154
		v_cmp_ge_i32_e64 s[56:57], v4, v17
		v_accvgpr_read_b32 v17, a70
		v_cmp_ge_i32_e64 s[58:59], v4, v17
		v_cndmask_b32_e64 v192, v10, v204, s[54:55]
		v_cndmask_b32_e64 v193, v10, v205, s[56:57]
		v_cndmask_b32_e64 v194, v10, v206, s[58:59]
		v_accvgpr_read_b32 v17, a132
		v_cmp_ge_i32_e64 vcc, v4, v17
		v_cndmask_b32_e64 v191, v10, v117, s[82:83]
		v_cndmask_b32_e64 v236, v10, v118, s[84:85]
		v_cndmask_b32_e32 v195, v10, v207, vcc
		v_accvgpr_read_b32 v17, a155
		v_cmp_ge_i32_e64 s[54:55], v4, v17
		v_accvgpr_read_b32 v17, a134
		v_cmp_ge_i32_e64 vcc, v4, v17
		v_cndmask_b32_e64 v116, v10, v120, s[86:87]
		v_accvgpr_read_b32 v17, a156
		v_cmp_ge_i32_e64 s[56:57], v4, v17
		v_accvgpr_read_b32 v17, a133
		v_cmp_ge_i32_e64 s[58:59], v4, v17
		v_cndmask_b32_e64 v196, v10, v208, s[54:55]
		v_cndmask_b32_e64 v197, v10, v209, s[56:57]
		v_cndmask_b32_e64 v198, v10, v210, s[58:59]
		v_cndmask_b32_e64 v117, v10, v121, s[88:89]
		v_cndmask_b32_e32 v199, v10, v211, vcc
		v_accvgpr_read_b32 v17, a157
		v_cmp_ge_i32_e64 s[54:55], v4, v17
		v_accvgpr_read_b32 v17, a158
		v_cmp_ge_i32_e64 s[56:57], v4, v17
		v_accvgpr_read_b32 v17, a135
		v_cmp_ge_i32_e64 s[58:59], v4, v17
		v_cndmask_b32_e64 v120, v10, v212, s[54:55]
		v_cndmask_b32_e64 v121, v10, v213, s[56:57]
		v_cndmask_b32_e64 v200, v10, v214, s[58:59]
		v_accvgpr_read_b32 v17, a136
		v_cmp_ge_i32_e64 vcc, v4, v17
		v_cndmask_b32_e64 v238, v10, v122, s[50:51]
		v_accvgpr_read_b32 v17, a164
		s_nop 0
		v_readfirstlane_b32 s50, v17
		v_accvgpr_read_b32 v17, a165
		s_nop 0
		v_readfirstlane_b32 s51, v17
		s_nop 1
		v_cndmask_b32_e64 v202, v10, v124, s[50:51]
		v_cndmask_b32_e32 v201, v10, v215, vcc
		v_accvgpr_read_b32 v17, a159
		v_cmp_ge_i32_e64 s[50:51], v4, v17
		v_accvgpr_read_b32 v17, a160
		v_cmp_ge_i32_e64 s[54:55], v4, v17
		v_accvgpr_read_b32 v17, a137
		v_cmp_ge_i32_e64 s[56:57], v4, v17
		v_cndmask_b32_e64 v204, v10, v216, s[50:51]
		v_cndmask_b32_e64 v205, v10, v217, s[54:55]
		v_cndmask_b32_e64 v206, v10, v218, s[56:57]
		v_accvgpr_read_b32 v17, a138
		v_cmp_ge_i32_e64 vcc, v4, v17
		v_accvgpr_read_b32 v17, a166
		s_nop 0
		v_readfirstlane_b32 s50, v17
		v_accvgpr_read_b32 v17, a167
		s_nop 0
		v_readfirstlane_b32 s51, v17
		s_nop 1
		v_cndmask_b32_e64 v203, v10, v125, s[50:51]
		v_accvgpr_read_b32 v17, a168
		s_nop 0
		v_readfirstlane_b32 s50, v17
		v_accvgpr_read_b32 v17, a169
		s_nop 0
		v_readfirstlane_b32 s51, v17
		s_nop 1
		v_cndmask_b32_e64 v240, v10, v126, s[50:51]
		v_cndmask_b32_e32 v207, v10, v219, vcc
		v_accvgpr_read_b32 v17, a161
		v_cmp_ge_i32_e64 s[50:51], v4, v17
		v_accvgpr_read_b32 v17, a162
		v_cmp_ge_i32_e64 s[54:55], v4, v17
		v_accvgpr_read_b32 v17, a139
		v_cmp_ge_i32_e64 s[56:57], v4, v17
		v_cndmask_b32_e64 v124, v10, v220, s[50:51]
		v_cndmask_b32_e64 v125, v10, v221, s[54:55]
		v_cndmask_b32_e64 v126, v10, v222, s[56:57]
		v_accvgpr_read_b32 v17, a140
		v_cmp_ge_i32_e64 vcc, v4, v17
		v_accvgpr_read_b32 v17, a170
		s_nop 0
		v_readfirstlane_b32 s50, v17
		v_accvgpr_read_b32 v17, a171
		s_nop 0
		v_readfirstlane_b32 s51, v17
		s_nop 1
		v_cndmask_b32_e64 v208, v10, v128, s[50:51]
		v_accvgpr_read_b32 v17, a172
		s_nop 0
		v_readfirstlane_b32 s50, v17
		v_accvgpr_read_b32 v17, a173
		s_nop 0
		v_readfirstlane_b32 s51, v17
		s_nop 1
		v_cndmask_b32_e64 v209, v10, v129, s[50:51]
		v_cndmask_b32_e32 v127, v10, v223, vcc
		v_cmp_ge_i32_e64 s[50:51], v4, v96
		v_cmp_ge_i32_e64 s[54:55], v4, v111
		v_accvgpr_read_b32 v17, a141
		v_cmp_ge_i32_e64 s[56:57], v4, v17
		v_cndmask_b32_e64 v96, v10, v160, s[50:51]
		v_cndmask_b32_e64 v97, v10, v161, s[54:55]
		v_cndmask_b32_e64 v110, v10, v162, s[56:57]
		v_accvgpr_read_b32 v17, a142
		v_cmp_ge_i32_e64 vcc, v4, v17
		v_accvgpr_read_b32 v17, a174
		s_nop 0
		v_readfirstlane_b32 s50, v17
		v_accvgpr_read_b32 v17, a175
		s_nop 0
		v_readfirstlane_b32 s51, v17
		s_nop 1
		v_cndmask_b32_e64 v242, v10, v130, s[50:51]
		v_accvgpr_read_b32 v17, a176
		s_nop 0
		v_readfirstlane_b32 s50, v17
		v_accvgpr_read_b32 v17, a177
		s_nop 0
		v_readfirstlane_b32 s51, v17
		s_nop 1
		v_cndmask_b32_e64 v128, v10, v132, s[50:51]
		v_cndmask_b32_e32 v111, v10, v163, vcc
		v_cmp_ge_i32_e64 s[50:51], v4, v115
		v_cmp_ge_i32_e64 s[54:55], v4, v119
		v_accvgpr_read_b32 v17, a143
		v_cmp_ge_i32_e64 s[56:57], v4, v17
		v_cndmask_b32_e64 v114, v10, v164, s[50:51]
		v_cndmask_b32_e64 v115, v10, v165, s[54:55]
		v_cndmask_b32_e64 v118, v10, v166, s[56:57]
		v_accvgpr_read_b32 v17, a144
		v_cmp_ge_i32_e64 vcc, v4, v17
		v_accvgpr_read_b32 v17, a178
		s_nop 0
		v_readfirstlane_b32 s50, v17
		v_accvgpr_read_b32 v17, a179
		s_nop 0
		v_readfirstlane_b32 s51, v17
		s_nop 1
		v_cndmask_b32_e64 v129, v10, v133, s[50:51]
		v_accvgpr_read_b32 v17, a180
		s_nop 0
		v_readfirstlane_b32 s50, v17
		v_accvgpr_read_b32 v17, a181
		s_nop 0
		v_readfirstlane_b32 s51, v17
		s_nop 1
		v_cndmask_b32_e64 v244, v10, v134, s[50:51]
		v_cndmask_b32_e32 v119, v10, v167, vcc
		v_cmp_ge_i32_e64 s[50:51], v4, v123
		v_accvgpr_read_b32 v17, a163
		v_cmp_ge_i32_e64 s[54:55], v4, v17
		v_accvgpr_read_b32 v17, a145
		v_cmp_ge_i32_e64 s[56:57], v4, v17
		v_cndmask_b32_e64 v122, v10, v168, s[50:51]
		v_cndmask_b32_e64 v123, v10, v169, s[54:55]
		v_cndmask_b32_e64 v130, v10, v170, s[56:57]
		v_accvgpr_read_b32 v17, a146
		v_cmp_ge_i32_e64 vcc, v4, v17
		v_accvgpr_read_b32 v17, a182
		s_nop 0
		v_readfirstlane_b32 s50, v17
		v_accvgpr_read_b32 v17, a183
		s_nop 0
		v_readfirstlane_b32 s51, v17
		s_nop 1
		v_cndmask_b32_e64 v132, v10, v136, s[50:51]
		v_accvgpr_read_b32 v17, a184
		s_nop 0
		v_readfirstlane_b32 s50, v17
		v_accvgpr_read_b32 v17, a185
		s_nop 0
		v_readfirstlane_b32 s51, v17
		s_nop 1
		v_cndmask_b32_e64 v133, v10, v137, s[50:51]
		v_cndmask_b32_e32 v131, v10, v171, vcc
		v_accvgpr_read_b32 v17, a186
		v_cmp_ge_i32_e64 s[50:51], v4, v17
		v_accvgpr_read_b32 v17, a187
		v_cmp_ge_i32_e64 s[54:55], v4, v17
		v_accvgpr_read_b32 v17, a147
		v_cmp_ge_i32_e64 s[56:57], v4, v17
		v_cndmask_b32_e64 v134, v10, v172, s[50:51]
		v_cndmask_b32_e64 v135, v10, v173, s[54:55]
		v_cndmask_b32_e64 v136, v10, v174, s[56:57]
		v_accvgpr_read_b32 v17, a148
		v_cmp_ge_i32_e64 vcc, v4, v17
		v_cndmask_b32_e64 v246, v10, v138, s[90:91]
		v_cndmask_b32_e64 v252, v10, v140, s[92:93]
		v_cndmask_b32_e32 v137, v10, v175, vcc
		v_max3_f32 v17, v100, v101, v228
		v_max3_f32 v18, v182, v183, v232
		v_max3_f32 v20, v108, v109, v234
		v_max3_f32 v23, v190, v191, v236
		v_max3_f32 v138, v116, v117, v238
		v_max3_f32 v139, v202, v203, v240
		v_max3_f32 v140, v208, v209, v242
		v_max3_f32 v141, v128, v129, v244
		v_max3_f32 v160, v132, v133, v246
		v_max3_f32 v161, v252, v253, v250
		v_max3_f32 v13, v13, v27, v14
		v_max3_f32 v14, v17, v229, v18
		v_max3_f32 v17, v20, v235, v23
		v_max3_f32 v18, v138, v239, v139
		v_max3_f32 v20, v140, v243, v141
		v_max3_f32 v23, v160, v247, v161
		v_accvgpr_read_b32 v138, a188
		v_accvgpr_read_b32 v139, a189
		v_max3_f32 v138, v138, v145, v139
		v_accvgpr_read_b32 v139, a190
		v_accvgpr_read_b32 v140, a191
		v_max3_f32 v139, v139, v153, v140
		v_max3_f32 v13, v13, v227, v14
		v_max3_f32 v14, v17, v237, v18
		v_max3_f32 v17, v20, v245, v23
		v_max3_f32 v18, v138, v149, v139
		v_max3_f32 v13, v13, v233, v14
		v_max3_f32 v14, v17, v251, v18
		v_max3_f32 v13, v13, v241, v14
		v_max_f32_e32 v138, v13, v157
		v_mov_b32_e32 v139, v138
		v_cndmask_b32_e64 v140, v10, v176, s[52:53]
		v_cndmask_b32_e64 v141, v10, v177, s[94:95]
		v_permlane32_swap_b32_e32 v138, v139
		v_max3_f32 v10, v140, v141, v8
		v_max3_f32 v13, v30, v31, v178
		v_max3_f32 v14, v98, v99, v180
		v_max3_f32 v17, v102, v103, v104
		v_max3_f32 v18, v28, v29, v106
		v_max3_f32 v20, v184, v185, v186
		v_max3_f32 v23, v112, v113, v188
		v_max3_f32 v160, v192, v193, v194
		v_max3_f32 v161, v196, v197, v198
		v_max3_f32 v162, v120, v121, v200
		v_max3_f32 v163, v204, v205, v206
		v_max3_f32 v164, v124, v125, v126
		v_max3_f32 v165, v96, v97, v110
		v_max3_f32 v166, v114, v115, v118
		v_max3_f32 v167, v122, v123, v130
		v_max3_f32 v168, v134, v135, v136
		v_max3_f32 v10, v10, v9, v13
		v_max3_f32 v13, v14, v181, v17
		v_max3_f32 v14, v18, v107, v20
		v_max3_f32 v17, v23, v189, v160
		v_max3_f32 v18, v161, v199, v162
		v_max3_f32 v20, v163, v207, v164
		v_max3_f32 v23, v165, v111, v166
		v_max3_f32 v160, v167, v131, v168
		v_max3_f32 v10, v10, v179, v13
		v_max3_f32 v13, v14, v187, v17
		v_max3_f32 v14, v18, v201, v20
		v_max3_f32 v17, v23, v119, v160
		v_max3_f32 v10, v10, v105, v13
		v_max3_f32 v13, v14, v127, v17
		v_max3_f32 v10, v10, v195, v13
		v_max_f32_e32 v160, v10, v137
		v_mov_b32_e32 v161, v160
		v_max_f32_e32 v162, v138, v139
		v_mov_b32_e32 v138, v5
		v_permlane32_swap_b32_e32 v160, v161
		v_max_f32_e32 v163, v160, v161
		v_mov_b32_e32 v160, 0x3e38aa3b
		v_mov_b32_e32 v161, 0x3e38aa3b
		v_pk_mul_f32 v[164:165], v[162:163], v[160:161]
		v_max_f32_e32 v162, v5, v164
		v_max_f32_e32 v163, v11, v165
		v_pk_fma_f32 v[164:165], v[248:249], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[26:27], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[158:159], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[226:227], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[100:101], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[228:229], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[182:183], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[232:233], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[108:109], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[234:235], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[190:191], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[236:237], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[116:117], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[238:239], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[202:203], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[240:241], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[208:209], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[242:243], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[128:129], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[244:245], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[132:133], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[246:247], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[218:219], v[252:253], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[220:221], v[250:251], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[222:223], v[142:143], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[144:145], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[146:147], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[148:149], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[150:151], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[154:155], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[156:157], v[160:161], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[140:141], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[8:9], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[8:9], v[30:31], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[178:179], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[98:99], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[180:181], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[102:103], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[28:29], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[106:107], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[184:185], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[186:187], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[112:113], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[188:189], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[192:193], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[194:195], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[196:197], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[198:199], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[120:121], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[200:201], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[204:205], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[206:207], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[124:125], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[126:127], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[96:97], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[110:111], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[114:115], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[118:119], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[122:123], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[130:131], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[134:135], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[136:137], v[160:161], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v136, v164
		v_exp_f32_e32 v160, v165
		v_exp_f32_e32 v164, v166
		v_exp_f32_e32 v224, v167
		v_exp_f32_e32 v166, v26
		v_exp_f32_e32 v226, v27
		v_exp_f32_e32 v26, v158
		v_exp_f32_e32 v228, v159
		v_exp_f32_e32 v158, v168
		v_exp_f32_e32 v230, v169
		v_exp_f32_e32 v168, v100
		v_exp_f32_e32 v232, v101
		v_exp_f32_e32 v100, v170
		v_exp_f32_e32 v234, v171
		v_exp_f32_e32 v170, v172
		v_exp_f32_e32 v236, v173
		v_exp_f32_e32 v172, v174
		v_exp_f32_e32 v238, v175
		v_exp_f32_e32 v174, v108
		v_exp_f32_e32 v240, v109
		v_exp_f32_e32 v108, v176
		v_exp_f32_e32 v242, v177
		v_exp_f32_e32 v176, v182
		v_exp_f32_e32 v244, v183
		v_exp_f32_e32 v182, v190
		v_exp_f32_e32 v246, v191
		v_exp_f32_e32 v190, v116
		v_exp_f32_e32 v248, v117
		v_exp_f32_e32 v116, v210
		v_exp_f32_e32 v250, v211
		v_exp_f32_e32 v210, v202
		v_exp_f32_e32 v252, v203
		v_exp_f32_e32 v137, v212
		v_exp_f32_e32 v161, v213
		v_exp_f32_e32 v165, v208
		v_exp_f32_e32 v225, v209
		v_exp_f32_e32 v167, v214
		v_exp_f32_e32 v227, v215
		v_exp_f32_e32 v27, v128
		v_exp_f32_e32 v229, v129
		v_exp_f32_e32 v159, v216
		v_exp_f32_e32 v231, v217
		v_exp_f32_e32 v169, v132
		v_exp_f32_e32 v233, v133
		v_exp_f32_e32 v101, v218
		v_exp_f32_e32 v235, v219
		v_exp_f32_e32 v171, v220
		v_exp_f32_e32 v237, v221
		v_exp_f32_e32 v173, v222
		v_exp_f32_e32 v239, v223
		v_exp_f32_e32 v175, v142
		v_exp_f32_e32 v241, v143
		v_exp_f32_e32 v109, v144
		v_exp_f32_e32 v243, v145
		v_exp_f32_e32 v177, v146
		v_exp_f32_e32 v245, v147
		v_exp_f32_e32 v183, v148
		v_exp_f32_e32 v247, v149
		v_exp_f32_e32 v191, v150
		v_exp_f32_e32 v249, v151
		v_exp_f32_e32 v117, v152
		v_exp_f32_e32 v251, v153
		v_exp_f32_e32 v211, v154
		v_exp_f32_e32 v253, v155
		v_exp_f32_e32 v128, v156
		v_exp_f32_e32 v132, v157
		v_exp_f32_e32 v142, v140
		v_exp_f32_e32 v144, v141
		v_exp_f32_e32 v140, v8
		v_exp_f32_e32 v146, v9
		v_exp_f32_e32 v8, v30
		v_exp_f32_e32 v148, v31
		v_exp_f32_e32 v30, v178
		v_exp_f32_e32 v150, v179
		v_exp_f32_e32 v152, v98
		v_exp_f32_e32 v154, v99
		v_exp_f32_e32 v98, v180
		v_exp_f32_e32 v156, v181
		v_exp_f32_e32 v178, v102
		v_exp_f32_e32 v180, v103
		v_exp_f32_e32 v102, v104
		v_exp_f32_e32 v202, v105
		v_exp_f32_e32 v104, v28
		v_exp_f32_e32 v208, v29
		v_exp_f32_e32 v28, v106
		v_exp_f32_e32 v212, v107
		v_exp_f32_e32 v106, v184
		v_exp_f32_e32 v214, v185
		v_exp_f32_e32 v184, v186
		v_exp_f32_e32 v216, v187
		v_exp_f32_e32 v186, v112
		v_exp_f32_e32 v218, v113
		v_exp_f32_e32 v112, v188
		v_exp_f32_e32 v220, v189
		v_exp_f32_e32 v188, v192
		v_exp_f32_e32 v222, v193
		v_exp_f32_e32 v129, v194
		v_exp_f32_e32 v133, v195
		v_exp_f32_e32 v143, v196
		v_exp_f32_e32 v145, v197
		v_exp_f32_e32 v141, v198
		v_exp_f32_e32 v147, v199
		v_exp_f32_e32 v9, v120
		v_exp_f32_e32 v149, v121
		v_exp_f32_e32 v31, v200
		v_exp_f32_e32 v151, v201
		v_exp_f32_e32 v153, v204
		v_exp_f32_e32 v155, v205
		v_exp_f32_e32 v99, v206
		v_exp_f32_e32 v157, v207
		v_exp_f32_e32 v179, v124
		v_exp_f32_e32 v181, v125
		v_exp_f32_e32 v103, v126
		v_exp_f32_e32 v203, v127
		v_exp_f32_e32 v105, v96
		v_exp_f32_e32 v209, v97
		v_exp_f32_e32 v29, v110
		v_exp_f32_e32 v213, v111
		v_exp_f32_e32 v107, v114
		v_exp_f32_e32 v215, v115
		v_exp_f32_e32 v185, v118
		v_exp_f32_e32 v217, v119
		v_exp_f32_e32 v187, v122
		v_exp_f32_e32 v219, v123
		v_exp_f32_e32 v113, v130
		v_exp_f32_e32 v221, v131
		v_exp_f32_e32 v189, v134
		v_exp_f32_e32 v223, v135
		v_pk_add_f32 v[96:97], v[136:137], v[160:161]
		v_pk_add_f32 v[110:111], v[164:165], v[224:225]
		v_pk_add_f32 v[114:115], v[166:167], v[226:227]
		v_pk_add_f32 v[118:119], v[26:27], v[228:229]
		v_pk_add_f32 v[120:121], v[158:159], v[230:231]
		v_pk_add_f32 v[122:123], v[168:169], v[232:233]
		v_pk_add_f32 v[124:125], v[100:101], v[234:235]
		v_pk_add_f32 v[126:127], v[170:171], v[236:237]
		v_pk_add_f32 v[130:131], v[172:173], v[238:239]
		v_pk_add_f32 v[134:135], v[174:175], v[240:241]
		v_pk_add_f32 v[192:193], v[108:109], v[242:243]
		v_pk_add_f32 v[194:195], v[176:177], v[244:245]
		v_pk_add_f32 v[196:197], v[182:183], v[246:247]
		v_pk_add_f32 v[198:199], v[190:191], v[248:249]
		v_pk_add_f32 v[200:201], v[116:117], v[250:251]
		v_pk_add_f32 v[204:205], v[210:211], v[252:253]
		v_pk_add_f32 v[96:97], v[96:97], v[110:111]
		v_pk_add_f32 v[110:111], v[114:115], v[118:119]
		v_pk_add_f32 v[114:115], v[120:121], v[122:123]
		v_pk_add_f32 v[118:119], v[124:125], v[126:127]
		v_pk_add_f32 v[120:121], v[130:131], v[134:135]
		v_pk_add_f32 v[122:123], v[192:193], v[194:195]
		v_pk_add_f32 v[124:125], v[196:197], v[198:199]
		v_pk_add_f32 v[126:127], v[200:201], v[204:205]
		v_pk_add_f32 v[96:97], v[96:97], v[110:111]
		v_pk_add_f32 v[110:111], v[114:115], v[118:119]
		v_pk_add_f32 v[114:115], v[120:121], v[122:123]
		v_pk_add_f32 v[118:119], v[124:125], v[126:127]
		v_pk_add_f32 v[96:97], v[96:97], v[110:111]
		v_pk_add_f32 v[110:111], v[114:115], v[118:119]
		v_pk_add_f32 v[114:115], v[96:97], v[110:111]
		v_add_f32_e32 v5, v114, v115
		v_accvgpr_read_b32 v10, a71
		ds_bpermute_b32 v96, v10, v5
		v_accvgpr_read_b32 v10, a72
		ds_bpermute_b32 v110, v10, v5
		v_pk_add_f32 v[114:115], v[128:129], v[132:133]
		v_pk_add_f32 v[118:119], v[142:143], v[144:145]
		v_pk_add_f32 v[120:121], v[140:141], v[146:147]
		v_pk_add_f32 v[122:123], v[8:9], v[148:149]
		v_pk_add_f32 v[124:125], v[30:31], v[150:151]
		v_pk_add_f32 v[126:127], v[152:153], v[154:155]
		v_pk_add_f32 v[130:131], v[98:99], v[156:157]
		v_pk_add_f32 v[134:135], v[178:179], v[180:181]
		v_pk_add_f32 v[192:193], v[102:103], v[202:203]
		v_pk_add_f32 v[194:195], v[104:105], v[208:209]
		v_pk_add_f32 v[196:197], v[28:29], v[212:213]
		v_pk_add_f32 v[198:199], v[106:107], v[214:215]
		v_pk_add_f32 v[200:201], v[184:185], v[216:217]
		v_pk_add_f32 v[204:205], v[186:187], v[218:219]
		v_pk_add_f32 v[206:207], v[112:113], v[220:221]
		v_pk_add_f32 v[254:255], v[188:189], v[222:223]
		v_pk_add_f32 v[114:115], v[114:115], v[118:119]
		v_pk_add_f32 v[118:119], v[120:121], v[122:123]
		v_pk_add_f32 v[120:121], v[124:125], v[126:127]
		v_pk_add_f32 v[122:123], v[130:131], v[134:135]
		v_pk_add_f32 v[124:125], v[192:193], v[194:195]
		v_pk_add_f32 v[126:127], v[196:197], v[198:199]
		v_pk_add_f32 v[130:131], v[200:201], v[204:205]
		v_pk_add_f32 v[134:135], v[206:207], v[254:255]
		v_pk_add_f32 v[114:115], v[114:115], v[118:119]
		v_pk_add_f32 v[118:119], v[120:121], v[122:123]
		v_pk_add_f32 v[120:121], v[124:125], v[126:127]
		v_pk_add_f32 v[122:123], v[130:131], v[134:135]
		v_pk_add_f32 v[114:115], v[114:115], v[118:119]
		v_pk_add_f32 v[118:119], v[120:121], v[122:123]
		v_pk_add_f32 v[120:121], v[114:115], v[118:119]
		v_mov_b32_e32 v111, v121
		v_mov_b32_e32 v97, v120
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[114:115], v[96:97], v[110:111]
		v_mov_b32_e32 v96, v115
		v_mov_b32_e32 v97, v115
		v_cvt_pk_bf16_f32 v120, v136, v160
		v_cvt_pk_bf16_f32 v121, v164, v224
		v_permlane32_swap_b32_e32 v96, v97
		v_add_f32_e32 v111, v96, v97
		v_mov_b32_e32 v139, v11
		v_pk_add_f32 v[10:11], v[138:139], v[162:163] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v96, v10
		v_exp_f32_e32 v97, v11
		v_cvt_pk_bf16_f32 v122, v166, v226
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
		v_mov_b32_e32 v110, v114
		v_mov_b64_e32 v[10:11], v[24:25]
		v_pk_fma_f32 v[24:25], v[10:11], v[96:97], v[110:111]
		v_cvt_pk_bf16_f32 v123, v26, v228
		v_cvt_pk_bf16_f32 v124, v158, v230
		v_cvt_pk_bf16_f32 v125, v168, v232
		v_cvt_pk_bf16_f32 v126, v100, v234
		v_cvt_pk_bf16_f32 v127, v170, v236
		v_cvt_pk_bf16_f32 v192, v172, v238
		v_cvt_pk_bf16_f32 v193, v174, v240
		v_cvt_pk_bf16_f32 v194, v108, v242
		v_cvt_pk_bf16_f32 v195, v176, v244
		v_cvt_pk_bf16_f32 v196, v182, v246
		v_cvt_pk_bf16_f32 v197, v190, v248
		v_cvt_pk_bf16_f32 v198, v116, v250
		v_cvt_pk_bf16_f32 v199, v210, v252
		v_cvt_pk_bf16_f32 v204, v137, v161
		v_cvt_pk_bf16_f32 v205, v165, v225
		v_cvt_pk_bf16_f32 v206, v167, v227
		v_cvt_pk_bf16_f32 v207, v27, v229
		v_cvt_pk_bf16_f32 v136, v159, v231
		v_cvt_pk_bf16_f32 v137, v169, v233
		v_cvt_pk_bf16_f32 v138, v101, v235
		v_cvt_pk_bf16_f32 v139, v171, v237
		v_cvt_pk_bf16_f32 v164, v173, v239
		v_cvt_pk_bf16_f32 v165, v175, v241
		v_cvt_pk_bf16_f32 v166, v109, v243
		v_cvt_pk_bf16_f32 v167, v177, v245
		v_cvt_pk_bf16_f32 v108, v183, v247
		v_cvt_pk_bf16_f32 v109, v191, v249
		v_cvt_pk_bf16_f32 v110, v117, v251
		v_cvt_pk_bf16_f32 v111, v211, v253
		v_cvt_pk_bf16_f32 v116, v128, v132
		v_cvt_pk_bf16_f32 v117, v142, v144
		v_cvt_pk_bf16_f32 v118, v140, v146
		v_cvt_pk_bf16_f32 v119, v8, v148
		v_cvt_pk_bf16_f32 v168, v30, v150
		v_cvt_pk_bf16_f32 v169, v152, v154
		v_cvt_pk_bf16_f32 v170, v98, v156
		v_cvt_pk_bf16_f32 v171, v178, v180
		v_cvt_pk_bf16_f32 v172, v102, v202
		v_cvt_pk_bf16_f32 v173, v104, v208
		v_cvt_pk_bf16_f32 v174, v28, v212
		v_cvt_pk_bf16_f32 v175, v106, v214
		v_cvt_pk_bf16_f32 v224, v184, v216
		v_cvt_pk_bf16_f32 v225, v186, v218
		v_cvt_pk_bf16_f32 v226, v112, v220
		v_cvt_pk_bf16_f32 v227, v188, v222
		v_cvt_pk_bf16_f32 v228, v129, v133
		v_cvt_pk_bf16_f32 v229, v143, v145
		v_cvt_pk_bf16_f32 v230, v141, v147
		v_cvt_pk_bf16_f32 v231, v9, v149
		v_cvt_pk_bf16_f32 v8, v31, v151
		v_cvt_pk_bf16_f32 v9, v153, v155
		v_cvt_pk_bf16_f32 v10, v99, v157
		v_cvt_pk_bf16_f32 v11, v179, v181
		v_cvt_pk_bf16_f32 v96, v103, v203
		v_cvt_pk_bf16_f32 v97, v105, v209
		v_cvt_pk_bf16_f32 v98, v29, v213
		v_cvt_pk_bf16_f32 v99, v107, v215
		v_cvt_pk_bf16_f32 v28, v185, v217
		v_cvt_pk_bf16_f32 v29, v187, v219
		v_cvt_pk_bf16_f32 v30, v113, v221
		v_cvt_pk_bf16_f32 v31, v189, v223
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[120:123], v[32:47]
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[120:123], v[48:63]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[124:127], v[32:47]
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[124:127], v[48:63]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[192:195], v[32:47]
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[192:195], v[48:63]
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[196:199], v[32:47]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[196:199], v[48:63]
		v_permlane32_swap_b32_e32 v168, v170
		v_permlane32_swap_b32_e32 v169, v171
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[116:119], v[80:95]
		v_permlane32_swap_b32_e32 v172, v174
		v_permlane32_swap_b32_e32 v173, v175
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[116:119], v[64:79]
		v_permlane32_swap_b32_e32 v224, v226
		v_permlane32_swap_b32_e32 v225, v227
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[168:171], v[80:95]
		v_permlane32_swap_b32_e32 v228, v230
		v_permlane32_swap_b32_e32 v229, v231
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[168:171], v[64:79]
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[172:175], v[80:95]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[172:175], v[64:79]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[224:227], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[224:227], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[204:207], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[204:207], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[228:231], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[228:231], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[136:139], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[136:139], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[8:11], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[8:11], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[216:219], v[164:167], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[248:251], v[164:167], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[248:251], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[216:219], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[220:223], v[108:111], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[252:255], v[108:111], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[252:255], v[28:31], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[220:223], v[28:31], v[64:79]
		s_cselect_b32 s1, 1, 0
		s_add_i32 s37, s44, 0x80
		s_cmp_lg_u32 s1, 0
		s_mov_b32 s44, s37
		v_mov_b32_e32 v5, v162
		v_mov_b32_e32 v11, v163
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_2
.L_attn_fwd_persistent.loop_exit_2:
		s_mov_b32 s28, s8
		s_mov_b32 s29, s9
		s_mov_b32 s30, s42
		s_mov_b32 s31, s43
		v_rcp_f32_e32 v2, v24
		v_accvgpr_read_b32 v1, a12
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
		s_lshl_b32 s1, s1, 9
		v_accvgpr_read_b32 v1, a2
		s_nop 0
		v_readfirstlane_b32 s18, v1
		v_mov_b32_e32 v1, s22
		s_nop 0
		v_readfirstlane_b32 s21, v1
		s_mul_i32 s18, s21, s18
		s_lshl_b32 s18, s18, 1
		s_add_i32 s21, s1, s18
		v_accvgpr_read_b32 v1, a3
		s_nop 0
		v_readfirstlane_b32 s23, v1
		v_accvgpr_read_b32 v1, a11
		s_nop 0
		v_readfirstlane_b32 s24, v1
		s_mul_i32 s23, s24, s23
		s_lshl_b32 s23, s23, 1
		s_add_i32 s21, s21, s23
		v_accvgpr_read_b32 v1, a13
		s_nop 0
		v_readfirstlane_b32 s24, v1
		v_accvgpr_read_b32 v1, a4
		s_nop 0
		v_readfirstlane_b32 s25, v1
		s_mul_i32 s24, s25, s24
		s_lshl_b32 s24, s24, 6
		s_add_i32 s21, s21, s24
		v_and_b32_e32 v1, 31, v0
		v_accvgpr_read_b32 v2, a4
		s_nop 0
		v_readfirstlane_b32 s25, v2
		s_nop 1
		v_mul_lo_u32 v1, s25, v1
		v_lshl_add_u32 v2, v1, 1, s21
		v_accvgpr_read_b32 v3, a16
		v_lshl_add_u32 v2, v3, 4, v2
		v_accvgpr_read_b32 v3, a52
		s_nop 0
		v_readfirstlane_b32 s32, v3
		v_accvgpr_read_b32 v3, a53
		s_nop 0
		v_readfirstlane_b32 s33, v3
		s_and_saveexec_b64 s[100:101], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_8
		buffer_store_dwordx4 v[40:43], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_8:
		s_andn2_b64 exec, s[100:101], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_8
.L_attn_fwd_persistent.exec_endif_8:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s21, s1, 32
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s23
		s_add_i32 s21, s21, s24
		v_lshl_add_u32 v2, v1, 1, s21
		v_accvgpr_read_b32 v3, a16
		v_lshl_add_u32 v2, v3, 4, v2
		v_accvgpr_read_b32 v3, a52
		s_nop 0
		v_readfirstlane_b32 s32, v3
		v_accvgpr_read_b32 v3, a53
		s_nop 0
		v_readfirstlane_b32 s33, v3
		s_and_saveexec_b64 s[100:101], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_9
		buffer_store_dwordx4 v[8:11], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_9:
		s_andn2_b64 exec, s[100:101], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_9
.L_attn_fwd_persistent.exec_endif_9:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s21, s1, 64
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s23
		s_add_i32 s21, s21, s24
		v_lshl_add_u32 v2, v1, 1, s21
		v_accvgpr_read_b32 v3, a16
		v_lshl_add_u32 v2, v3, 4, v2
		v_accvgpr_read_b32 v3, a52
		s_nop 0
		v_readfirstlane_b32 s32, v3
		v_accvgpr_read_b32 v3, a53
		s_nop 0
		v_readfirstlane_b32 s33, v3
		s_and_saveexec_b64 s[100:101], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_10
		buffer_store_dwordx4 v[12:15], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_10:
		s_andn2_b64 exec, s[100:101], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_10
.L_attn_fwd_persistent.exec_endif_10:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s21, s1, 0x60
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s23
		s_add_i32 s21, s21, s24
		v_lshl_add_u32 v2, v1, 1, s21
		v_accvgpr_read_b32 v3, a16
		v_lshl_add_u32 v2, v3, 4, v2
		v_accvgpr_read_b32 v3, a52
		s_nop 0
		v_readfirstlane_b32 s32, v3
		v_accvgpr_read_b32 v3, a53
		s_nop 0
		v_readfirstlane_b32 s33, v3
		s_and_saveexec_b64 s[100:101], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_11
		buffer_store_dwordx4 v[16:19], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_11:
		s_andn2_b64 exec, s[100:101], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_11
.L_attn_fwd_persistent.exec_endif_11:
		s_mov_b64 exec, s[100:101]
		v_accvgpr_read_b32 v2, a4
		s_nop 0
		v_readfirstlane_b32 s21, v2
		s_lshl_b32 s21, s21, 8
		s_add_i32 s25, s21, s1
		s_add_i32 s25, s25, s18
		s_add_i32 s25, s25, s23
		s_add_i32 s25, s25, s24
		v_lshl_add_u32 v2, v1, 1, s25
		v_accvgpr_read_b32 v3, a16
		v_lshl_add_u32 v2, v3, 4, v2
		v_accvgpr_read_b32 v3, a54
		s_nop 0
		v_readfirstlane_b32 s32, v3
		v_accvgpr_read_b32 v3, a55
		s_nop 0
		v_readfirstlane_b32 s33, v3
		s_and_saveexec_b64 s[100:101], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_12
		buffer_store_dwordx4 v[20:23], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_12:
		s_andn2_b64 exec, s[100:101], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_12
.L_attn_fwd_persistent.exec_endif_12:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s25, s21, 32
		s_add_i32 s25, s25, s1
		s_add_i32 s25, s25, s18
		s_add_i32 s25, s25, s23
		s_add_i32 s25, s25, s24
		v_lshl_add_u32 v2, v1, 1, s25
		v_accvgpr_read_b32 v3, a16
		v_lshl_add_u32 v2, v3, 4, v2
		v_accvgpr_read_b32 v3, a54
		s_nop 0
		v_readfirstlane_b32 s32, v3
		v_accvgpr_read_b32 v3, a55
		s_nop 0
		v_readfirstlane_b32 s33, v3
		s_and_saveexec_b64 s[100:101], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_13
		buffer_store_dwordx4 v[4:7], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_13:
		s_andn2_b64 exec, s[100:101], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_13
.L_attn_fwd_persistent.exec_endif_13:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s25, s21, 64
		s_add_i32 s25, s25, s1
		s_add_i32 s25, s25, s18
		s_add_i32 s25, s25, s23
		s_add_i32 s25, s25, s24
		v_lshl_add_u32 v2, v1, 1, s25
		v_accvgpr_read_b32 v3, a16
		v_lshl_add_u32 v2, v3, 4, v2
		v_accvgpr_read_b32 v3, a54
		s_nop 0
		v_readfirstlane_b32 s32, v3
		v_accvgpr_read_b32 v3, a55
		s_nop 0
		v_readfirstlane_b32 s33, v3
		s_and_saveexec_b64 s[100:101], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_14
		buffer_store_dwordx4 v[24:27], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_14:
		s_andn2_b64 exec, s[100:101], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_14
.L_attn_fwd_persistent.exec_endif_14:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s21, s21, 0x60
		s_add_i32 s1, s21, s1
		s_add_i32 s1, s1, s18
		s_add_i32 s1, s1, s23
		s_add_i32 s1, s1, s24
		v_lshl_add_u32 v1, v1, 1, s1
		v_accvgpr_read_b32 v2, a16
		v_lshl_add_u32 v1, v2, 4, v1
		v_accvgpr_read_b32 v2, a54
		s_nop 0
		v_readfirstlane_b32 s24, v2
		v_accvgpr_read_b32 v2, a55
		s_nop 0
		v_readfirstlane_b32 s25, v2
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_15
		buffer_store_dwordx4 v[28:31], v1, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_15:
		s_andn2_b64 exec, s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_15
.L_attn_fwd_persistent.exec_endif_15:
		s_mov_b64 exec, s[100:101]
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
		v_readfirstlane_b32 s18, v0
		s_lshr_b32 s18, s18, 6
		s_nop 0
		v_mov_b32_e32 v1, s18
		v_accvgpr_write_b32 a13, v1
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
		v_cmp_lt_i32_e64 s[24:25], v8, s19
		v_cmp_lt_i32_e64 s[28:29], v15, s19
		v_cmp_lt_i32_e64 s[30:31], v16, s19
		v_cmp_lt_i32_e64 s[32:33], v17, s19
		v_cmp_lt_i32_e64 s[34:35], v18, s19
		v_cmp_lt_i32_e64 s[36:37], v19, s19
		v_cmp_lt_i32_e64 s[38:39], v20, s19
		s_mov_b32 s42, 0x7fffffff
		s_mov_b32 s43, 0x31016000
		s_mov_b32 s40, s2
		s_mov_b32 s41, s3
		v_accvgpr_read_b32 v8, a7
		v_and_b32_e32 v8, 0xffff, v8
		v_lshlrev_b32_e32 v11, 16, v8
		v_or_b32_e32 v16, v8, v11
		v_mov_b32_e32 v17, v16
		v_mov_b32_e32 v18, v16
		v_mov_b32_e32 v19, v16
		v_accvgpr_read_b32 v8, a12
		s_nop 0
		v_readfirstlane_b32 s18, v8
		s_mul_i32 s18, s18, s12
		s_lshl_b32 s18, s18, 9
		v_mov_b32_e32 v8, s22
		v_accvgpr_write_b32 a16, v8
		v_accvgpr_read_b32 v8, a16
		s_nop 0
		v_readfirstlane_b32 s21, v8
		s_mul_i32 s21, s21, s10
		s_lshl_b32 s21, s21, 1
		s_add_i32 s22, s18, s21
		v_accvgpr_read_b32 v8, a11
		s_nop 0
		v_readfirstlane_b32 s23, v8
		s_mul_i32 s23, s23, s11
		s_lshl_b32 s23, s23, 1
		s_add_i32 s22, s22, s23
		v_mul_lo_u32 v8, s12, v6
		v_lshl_add_u32 v11, v8, 1, s22
		v_and_b32_e32 v13, 7, v0
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_16
		buffer_load_dwordx4 v[20:23], v11, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_16:
		s_andn2_b64 exec, s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_16
		v_mov_b32_e32 v20, v16
		v_mov_b32_e32 v21, v17
		v_mov_b32_e32 v22, v18
		v_mov_b32_e32 v23, v19
.L_attn_fwd_persistent.exec_endif_16:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s22, s12, 6
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s23
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_17
		buffer_load_dwordx4 v[24:27], v11, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_17:
		s_andn2_b64 exec, s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_17
		v_mov_b32_e32 v24, v16
		v_mov_b32_e32 v25, v17
		v_mov_b32_e32 v26, v18
		v_mov_b32_e32 v27, v19
.L_attn_fwd_persistent.exec_endif_17:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s22, s12, 7
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s23
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[100:101], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_18
		buffer_load_dwordx4 v[28:31], v11, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_18:
		s_andn2_b64 exec, s[100:101], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_18
		v_mov_b32_e32 v28, v16
		v_mov_b32_e32 v29, v17
		v_mov_b32_e32 v30, v18
		v_mov_b32_e32 v31, v19
.L_attn_fwd_persistent.exec_endif_18:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s22, 0xc0, s12
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s23
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[100:101], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_19
		buffer_load_dwordx4 v[32:35], v11, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_19:
		s_andn2_b64 exec, s[100:101], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_19
		v_mov_b32_e32 v32, v16
		v_mov_b32_e32 v33, v17
		v_mov_b32_e32 v34, v18
		v_mov_b32_e32 v35, v19
.L_attn_fwd_persistent.exec_endif_19:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s22, s12, 8
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s23
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[100:101], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_20
		buffer_load_dwordx4 v[36:39], v11, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_20:
		s_andn2_b64 exec, s[100:101], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_20
		v_mov_b32_e32 v36, v16
		v_mov_b32_e32 v37, v17
		v_mov_b32_e32 v38, v18
		v_mov_b32_e32 v39, v19
.L_attn_fwd_persistent.exec_endif_20:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s22, 0x140, s12
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s23
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[100:101], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_21
		buffer_load_dwordx4 v[40:43], v11, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_21:
		s_andn2_b64 exec, s[100:101], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_21
		v_mov_b32_e32 v40, v16
		v_mov_b32_e32 v41, v17
		v_mov_b32_e32 v42, v18
		v_mov_b32_e32 v43, v19
.L_attn_fwd_persistent.exec_endif_21:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s22, 0x180, s12
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s23
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[100:101], s[38:39]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_22
		buffer_load_dwordx4 v[44:47], v11, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_22:
		s_andn2_b64 exec, s[100:101], s[38:39]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_22
		v_mov_b32_e32 v44, v16
		v_mov_b32_e32 v45, v17
		v_mov_b32_e32 v46, v18
		v_mov_b32_e32 v47, v19
.L_attn_fwd_persistent.exec_endif_22:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s22, 0x1c0, s12
		s_add_i32 s18, s22, s18
		s_add_i32 s18, s18, s21
		s_add_i32 s18, s18, s23
		v_lshl_add_u32 v8, v8, 1, s18
		v_lshl_add_u32 v8, v13, 4, v8
		v_cmp_lt_i32_e64 vcc, v1, s19
		s_and_saveexec_b64 s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_23
		buffer_load_dwordx4 v[48:51], v8, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_23:
		s_andn2_b64 exec, s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_23
		v_mov_b32_e32 v48, v16
		v_mov_b32_e32 v49, v17
		v_mov_b32_e32 v50, v18
		v_mov_b32_e32 v51, v19
.L_attn_fwd_persistent.exec_endif_23:
		s_mov_b64 exec, s[100:101]
		s_mov_b32 s28, s4
		s_mov_b32 s29, s5
		s_mov_b32 s30, s42
		s_mov_b32 s31, s43
		s_mov_b32 s32, s6
		s_mov_b32 s33, s7
		s_mov_b32 s34, s42
		s_mov_b32 s35, s43
		s_waitcnt vmcnt(0)
		s_barrier
		v_and_b32_e32 v1, 1, v3
		v_accvgpr_write_b32 a17, v1
		v_accvgpr_read_b32 v1, a17
		v_lshlrev_b32_e32 v1, 1, v1
		v_accvgpr_read_b32 v3, a13
		s_nop 0
		v_readfirstlane_b32 s18, v3
		s_and_b32 s18, s18, 1
		s_lshl_b32 s18, s18, 2
		v_and_b32_e32 v3, 1, v9
		v_accvgpr_write_b32 a18, v3
		v_accvgpr_read_b32 v3, a18
		v_xor_b32_e32 v3, s18, v3
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
		v_accvgpr_read_b32 v9, a13
		s_nop 0
		v_readfirstlane_b32 s18, v9
		s_lshl_b32 s18, s18, 12
		s_add_i32 s18, s18, 0x10000
		v_and_b32_e32 v9, 63, v0
		v_and_b32_e32 v10, 7, v9
		v_lshrrev_b32_e32 v11, 2, v10
		v_lshl_add_u32 v14, v11, 5, s18
		v_lshrrev_b32_e32 v15, 3, v9
		v_bitop3_b32 v15, v15, 3, 1 bitop3:0x80
		v_lshl_add_u32 v16, v15, 6, v14
		v_lshrrev_b32_e32 v17, 5, v9
		v_and_b32_e32 v9, 31, v9
		v_lshlrev_b32_e32 v18, 3, v9
		v_add_u32_e32 v19, v17, v18
		v_lshrrev_b32_e32 v10, 1, v10
		v_and_b32_e32 v10, 1, v10
		v_xor_b32_e32 v19, v19, v10
		v_lshl_add_u32 v16, v19, 4, v16
		ds_read_b128 a[20:23], v16 offset:18864
		v_lshl_add_u32 v19, v15, 6, s18
		v_add3_u32 v20, 2, v17, v18
		v_lshlrev_b32_e32 v11, 1, v11
		v_bitop3_b32 v20, v20, v11, v10 bitop3:0x96
		v_lshl_add_u32 v19, v20, 4, v19
		ds_read_b128 a[24:27], v19 offset:18864
		v_add3_u32 v20, 4, v17, v18
		v_lshlrev_b32_e32 v15, 2, v15
		v_xor_b32_e32 v10, v15, v10
		v_xor_b32_e32 v15, v20, v10
		v_lshl_add_u32 v14, v15, 4, v14
		ds_read_b128 a[28:31], v14 offset:18864
		v_add3_u32 v15, 6, v17, v18
		v_bitop3_b32 v10, v15, v11, v10 bitop3:0x96
		v_lshl_add_u32 v10, v10, 4, s18
		ds_read_b128 a[32:35], v10 offset:18864
		v_and_b32_e32 v6, 1, v6
		v_lshlrev_b32_e32 v11, 4, v13
		v_and_b32_e32 v2, 1, v2
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[36:39] offset:18864
		ds_write_b128 v1, v[40:43] offset:22960
		ds_write_b128 v1, v[44:47] offset:27056
		ds_write_b128 v1, v[48:51] offset:31152
		v_accvgpr_read_b32 v1, a12
		s_nop 0
		v_readfirstlane_b32 s18, v1
		s_add_i32 s18, s18, 1
		s_mul_i32 s18, s18, 0x100
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[36:39], v16 offset:18864
		ds_read_b128 a[40:43], v19 offset:18864
		ds_read_b128 a[44:47], v14 offset:18864
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
		s_cselect_b32 s24, s22, 0
		s_add_i32 s23, s23, s24
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
		v_bitop3_b32 v13, v13, v12, v8 bitop3:0x96
		v_accvgpr_write_b32 a19, v13
		v_bitop3_b32 v13, 4, v1, v3 bitop3:0x96
		v_xor_b32_e32 v13, v13, v10
		v_bitop3_b32 v14, 8, v1, v3 bitop3:0x96
		v_xor_b32_e32 v14, v14, v10
		v_bitop3_b32 v1, 12, v1, v3 bitop3:0x96
		v_accvgpr_read_b32 v15, a19
		v_cmp_lt_i32_e64 s[24:25], v15, s20
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
		v_readfirstlane_b32 s36, v0
		v_accvgpr_read_b32 v15, a16
		s_nop 0
		v_readfirstlane_b32 s26, v15
		s_mul_i32 s26, s26, s13
		s_lshl_b32 s26, s26, 1
		v_accvgpr_read_b32 v15, a11
		s_nop 0
		v_readfirstlane_b32 s37, v15
		s_mul_i32 s37, s37, s14
		s_lshl_b32 s37, s37, 1
		s_add_i32 s38, s26, s37
		v_accvgpr_read_b32 v15, a13
		s_nop 0
		v_readfirstlane_b32 s39, v15
		s_mul_i32 s39, s15, s39
		s_lshl_b32 s39, s39, 1
		s_add_i32 s38, s38, s39
		v_accvgpr_read_b32 v15, a17
		v_mul_lo_u32 v15, s15, v15
		v_lshlrev_b32_e32 v15, 5, v15
		v_accvgpr_read_b32 v18, a18
		v_mul_lo_u32 v18, s15, v18
		v_lshlrev_b32_e32 v18, 6, v18
		v_add3_u32 v19, s38, v15, v18
		v_mul_lo_u32 v20, s15, v6
		v_lshlrev_b32_e32 v20, 7, v20
		v_add3_u32 v19, v19, v20, v11
		v_mov_b32_e32 v21, 0x80000000
		v_cndmask_b32_e64 v19, v21, v19, s[24:25]
		s_lshr_b32 s38, s36, 6
		s_mul_i32 s40, 0x410, s38
		s_mov_b32 m0, s40
		v_accvgpr_read_b32 v22, a14
		v_add_u32_e32 v22, s1, v22
		buffer_load_dwordx4 v19, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[44:45], v22, s19
		s_nop 1
		v_mov_b32_e32 v22, s44
		v_mov_b32_e32 v23, s45
		s_lshl_b32 s41, s15, 3
		s_add_i32 s41, s41, s26
		s_add_i32 s41, s41, s37
		s_add_i32 s41, s41, s39
		v_add3_u32 v19, s41, v15, v18
		v_add3_u32 v19, v19, v20, v11
		v_cndmask_b32_e64 v19, v21, v19, s[24:25]
		s_add_i32 m0, m0, 0x1040
		v_accvgpr_read_b32 v24, a15
		v_add_u32_e32 v24, s1, v24
		buffer_load_dwordx4 v19, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[44:45], v24, s19
		s_nop 1
		v_mov_b32_e32 v24, s44
		v_mov_b32_e32 v25, s45
		v_accvgpr_write_b32 a54, v24
		v_accvgpr_write_b32 a55, v25
		s_lshl_b32 s41, s15, 4
		s_add_i32 s41, s41, s26
		s_add_i32 s41, s41, s37
		s_add_i32 s41, s41, s39
		v_add3_u32 v19, s41, v15, v18
		v_add3_u32 v19, v19, v20, v11
		v_cndmask_b32_e64 v19, v21, v19, s[24:25]
		s_add_i32 m0, m0, 0x1040
		v_lshlrev_b32_e32 v17, 4, v17
		v_accvgpr_write_b32 a53, v17
		buffer_load_dwordx4 v19, s[28:31], 0 offen lds
		v_bitop3_b32 v13, v13, v12, v8 bitop3:0x96
		v_accvgpr_write_b32 a56, v13
		s_mul_i32 s41, 24, s15
		s_add_i32 s41, s41, s26
		s_add_i32 s41, s41, s37
		s_add_i32 s41, s41, s39
		v_add3_u32 v13, s41, v15, v18
		v_add3_u32 v13, v13, v20, v11
		v_cndmask_b32_e64 v13, v21, v13, s[24:25]
		s_add_i32 m0, m0, 0x1040
		v_mov_b32_e32 v17, 0x440
		v_mul_lo_u32 v17, v17, v2
		v_accvgpr_write_b32 a57, v17
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		v_bitop3_b32 v2, v14, v12, v8 bitop3:0x96
		v_accvgpr_write_b32 a58, v2
		v_accvgpr_read_b32 v2, a0
		s_nop 0
		v_readfirstlane_b32 s24, v2
		v_accvgpr_read_b32 v2, a16
		s_nop 0
		v_readfirstlane_b32 s25, v2
		s_mul_i32 s24, s25, s24
		s_lshl_b32 s24, s24, 1
		v_accvgpr_read_b32 v2, a1
		s_nop 0
		v_readfirstlane_b32 s25, v2
		v_accvgpr_read_b32 v2, a11
		s_nop 0
		v_readfirstlane_b32 s41, v2
		s_mul_i32 s25, s41, s25
		s_lshl_b32 s25, s25, 1
		s_add_i32 s41, s24, s25
		v_accvgpr_read_b32 v2, a13
		s_nop 0
		v_readfirstlane_b32 s44, v2
		s_mul_i32 s44, s17, s44
		s_lshl_b32 s44, s44, 1
		s_add_i32 s41, s41, s44
		v_accvgpr_read_b32 v2, a17
		v_mul_lo_u32 v2, s17, v2
		v_lshlrev_b32_e32 v2, 7, v2
		v_accvgpr_read_b32 v13, a18
		v_mul_lo_u32 v13, s17, v13
		v_lshlrev_b32_e32 v13, 6, v13
		v_add3_u32 v14, s41, v2, v13
		v_mul_lo_u32 v17, s17, v6
		v_lshlrev_b32_e32 v17, 5, v17
		v_add3_u32 v14, v14, v17, v11
		v_cndmask_b32_e32 v14, v21, v14, vcc
		s_mul_i32 s38, 0x440, s38
		s_add_i32 m0, s38, 0x81f0
		v_xor_b32_e32 v1, v1, v10
		buffer_load_dwordx4 v14, s[32:35], 0 offen lds
		v_bitop3_b32 v1, v1, v12, v8 bitop3:0x96
		v_accvgpr_write_b32 a59, v1
		s_lshl_b32 s41, s17, 3
		s_add_i32 s41, s41, s24
		s_add_i32 s41, s41, s25
		s_add_i32 s41, s41, s44
		v_add3_u32 v1, s41, v2, v13
		v_add3_u32 v1, v1, v17, v11
		v_cndmask_b32_e32 v1, v21, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v4, v4, v7
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_bitop3_b32 v1, v4, v12, v8 bitop3:0x96
		v_accvgpr_write_b32 a60, v1
		s_lshl_b32 s41, s17, 4
		s_add_i32 s41, s41, s24
		s_add_i32 s41, s41, s25
		s_add_i32 s41, s41, s44
		v_add3_u32 v1, s41, v2, v13
		v_add3_u32 v1, v1, v17, v11
		v_cndmask_b32_e32 v1, v21, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v4, v16, v7
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_bitop3_b32 v1, v4, v12, v8 bitop3:0x96
		v_accvgpr_write_b32 a61, v1
		s_mul_i32 s41, 24, s17
		s_add_i32 s41, s41, s24
		s_add_i32 s41, s41, s25
		s_add_i32 s41, s41, s44
		v_add3_u32 v1, s41, v2, v13
		v_add3_u32 v1, v1, v17, v11
		v_cndmask_b32_e32 v1, v21, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v3, v3, v7
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_bitop3_b32 v1, v3, v12, v8 bitop3:0x96
		v_accvgpr_write_b32 a62, v1
		s_mul_i32 s41, s23, 0x80
		s_lshl_b32 s23, s15, 8
		s_add_i32 s23, s23, s26
		s_add_i32 s23, s23, s37
		s_add_i32 s23, s23, s39
		s_mul_i32 s45, 0x108, s15
		s_add_i32 s45, s45, s26
		s_add_i32 s45, s45, s37
		s_add_i32 s45, s45, s39
		s_mul_i32 s46, 0x110, s15
		s_add_i32 s46, s46, s26
		s_add_i32 s46, s46, s37
		s_add_i32 s46, s46, s39
		s_mul_i32 s47, 0x118, s15
		s_add_i32 s26, s47, s26
		s_add_i32 s26, s26, s37
		s_add_i32 s26, s26, s39
		s_lshl_b32 s37, s17, 8
		s_add_i32 s37, s37, s24
		s_add_i32 s37, s37, s25
		s_add_i32 s39, s37, s44
		s_mul_i32 s37, 0x108, s17
		s_add_i32 s37, s37, s24
		s_add_i32 s37, s37, s25
		s_add_i32 s47, s37, s44
		s_mul_i32 s37, 0x110, s17
		s_add_i32 s37, s37, s24
		s_add_i32 s37, s37, s25
		s_add_i32 s48, s37, s44
		s_mul_i32 s37, 0x118, s17
		s_add_i32 s24, s37, s24
		s_add_i32 s24, s24, s25
		s_add_i32 s24, s24, s44
		v_mbcnt_lo_u32_b32 v1, -1, 0
		v_mbcnt_hi_u32_b32 v1, -1, v1
		v_and_b32_e32 v1, 31, v1
		v_add_u32_e32 v3, 32, v1
		v_mov_b32_e32 v24, 0x3e38aa3b
		v_mov_b32_e32 v25, 0x3e38aa3b
		s_mov_b32 s25, 0xff800000
		v_mov_b32_e32 v4, s25
		v_mov_b32_e32 v7, s25
		s_mov_b32 s25, 1.0
		v_mov_b32_e32 v26, s25
		v_mov_b32_e32 v27, s25
		s_mov_b32 s25, 0
		v_lshrrev_b32_e32 v8, 4, v9
		v_lshlrev_b32_e32 v8, 9, v8
		v_accvgpr_write_b32 a63, v8
		v_and_b32_e32 v8, 15, v9
		v_mov_b32_e32 v9, 0x410
		v_mul_lo_u32 v9, v9, v8
		v_accvgpr_write_b32 a64, v9
		v_and_b32_e32 v8, 3, v0
		v_accvgpr_write_b32 a65, v8
		v_accvgpr_read_b32 v8, a65
		v_lshlrev_b32_e32 v8, 3, v8
		v_accvgpr_write_b32 a66, v8
		v_accvgpr_read_b32 v8, a17
		v_mov_b32_e32 v9, 0x2200
		v_mul_lo_u32 v9, v9, v8
		v_accvgpr_write_b32 a67, v9
		v_accvgpr_read_b32 v8, a18
		v_lshlrev_b32_e32 v8, 5, v8
		v_accvgpr_write_b32 a68, v8
		v_mov_b32_e32 v8, 0x880
		v_mul_lo_u32 v8, v8, v6
		v_accvgpr_write_b32 a69, v8
		v_lshlrev_b32_e32 v1, 2, v1
		v_accvgpr_write_b32 a70, v1
		v_lshlrev_b32_e32 v1, 2, v3
		v_accvgpr_write_b32 a71, v1
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
		s_and_b32 s44, s37, 1
		s_mul_i32 s49, 0x4100, s44
		v_accvgpr_read_b32 v1, a53
		v_add_u32_e32 v1, s49, v1
		v_accvgpr_read_b32 v3, a63
		v_accvgpr_read_b32 v6, a64
		v_add3_u32 v1, v1, v3, v6
		ds_read_b128 v[28:31], v1
		ds_read_b128 v[96:99], v1 offset:32
		ds_read_b128 v[100:103], v1 offset:64
		ds_read_b128 a[72:75], v1 offset:96
		ds_read_b128 v[104:107], v1 offset:256
		ds_read_b128 v[108:111], v1 offset:288
		ds_read_b128 v[112:115], v1 offset:320
		ds_read_b128 a[76:79], v1 offset:352
		ds_read_b128 v[116:119], v1 offset:128
		ds_read_b128 v[120:123], v1 offset:160
		ds_read_b128 v[124:127], v1 offset:192
		ds_read_b128 a[80:83], v1 offset:224
		ds_read_b128 v[128:131], v1 offset:384
		ds_read_b128 a[84:87], v1 offset:416
		ds_read_b128 a[88:91], v1 offset:448
		ds_read_b128 a[92:95], v1 offset:480
		s_mul_i32 s44, 0x4400, s44
		v_accvgpr_read_b32 v1, a66
		v_add_u32_e32 v1, s44, v1
		v_accvgpr_read_b32 v3, a68
		v_accvgpr_read_b32 v6, a67
		v_add3_u32 v1, v1, v6, v3
		v_accvgpr_read_b32 v3, a57
		v_accvgpr_read_b32 v6, a69
		v_add3_u32 v1, v1, v6, v3
		ds_read_b64_tr_b16 a[96:97], v1 offset:33264
		ds_read_b64_tr_b16 a[98:99], v1 offset:37616
		ds_read_b64_tr_b16 a[100:101], v1 offset:33392
		ds_read_b64_tr_b16 a[102:103], v1 offset:37744
		ds_read_b64_tr_b16 a[104:105], v1 offset:33520
		ds_read_b64_tr_b16 a[106:107], v1 offset:37872
		ds_read_b64_tr_b16 a[108:109], v1 offset:33648
		ds_read_b64_tr_b16 a[110:111], v1 offset:38000
		ds_read_b64_tr_b16 a[112:113], v1 offset:33776
		ds_read_b64_tr_b16 a[114:115], v1 offset:38128
		ds_read_b64_tr_b16 a[116:117], v1 offset:33904
		ds_read_b64_tr_b16 a[118:119], v1 offset:38256
		ds_read_b64_tr_b16 a[120:121], v1 offset:34032
		ds_read_b64_tr_b16 a[122:123], v1 offset:38384
		ds_read_b64_tr_b16 a[124:125], v1 offset:34160
		ds_read_b64_tr_b16 a[126:127], v1 offset:38512
		ds_read_b64_tr_b16 a[128:129], v1 offset:33328
		ds_read_b64_tr_b16 a[130:131], v1 offset:37680
		ds_read_b64_tr_b16 a[132:133], v1 offset:33456
		ds_read_b64_tr_b16 a[134:135], v1 offset:37808
		ds_read_b64_tr_b16 a[136:137], v1 offset:33584
		ds_read_b64_tr_b16 a[138:139], v1 offset:37936
		ds_read_b64_tr_b16 a[140:141], v1 offset:33712
		ds_read_b64_tr_b16 a[142:143], v1 offset:38064
		ds_read_b64_tr_b16 a[144:145], v1 offset:33840
		ds_read_b64_tr_b16 a[146:147], v1 offset:38192
		ds_read_b64_tr_b16 a[148:149], v1 offset:33968
		ds_read_b64_tr_b16 a[150:151], v1 offset:38320
		ds_read_b64_tr_b16 a[152:153], v1 offset:34096
		ds_read_b64_tr_b16 a[154:155], v1 offset:38448
		ds_read_b64_tr_b16 a[156:157], v1 offset:34224
		ds_read_b64_tr_b16 a[158:159], v1 offset:38576
		s_mul_i32 s44, s15, s25
		s_lshl_b32 s44, s44, 1
		s_add_i32 s49, s23, s44
		v_add3_u32 v1, s49, v15, v18
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[20:23], 0
		v_add3_u32 v1, v1, v20, v11
		v_mfma_f32_32x32x16_bf16 v[144:159], v[96:99], a[24:27], v[144:159]
		s_add_i32 s37, s37, 1
		v_mfma_f32_32x32x16_bf16 v[144:159], v[100:103], a[28:31], v[144:159]
		s_and_b32 s37, s37, 1
		v_mfma_f32_32x32x16_bf16 v[160:175], v[28:31], a[36:39], 0
		s_mul_i32 s49, 0x4100, s37
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], a[40:43], v[160:175]
		s_add_i32 s49, s40, s49
		v_mfma_f32_32x32x16_bf16 v[160:175], v[100:103], a[44:47], v[160:175]
		s_mov_b32 m0, s49
		v_mfma_f32_32x32x16_bf16 v[176:191], v[104:107], a[20:23], 0
		s_add_i32 s49, s45, s44
		v_mfma_f32_32x32x16_bf16 v[176:191], v[108:111], a[24:27], v[176:191]
		v_add3_u32 v3, s49, v15, v18
		v_mfma_f32_32x32x16_bf16 v[176:191], v[112:115], a[28:31], v[176:191]
		v_add3_u32 v3, v3, v20, v11
		v_mfma_f32_32x32x16_bf16 v[192:207], v[104:107], a[36:39], 0
		s_add_i32 s49, s46, s44
		v_mfma_f32_32x32x16_bf16 v[192:207], v[108:111], a[40:43], v[192:207]
		v_add3_u32 v6, s49, v15, v18
		v_mfma_f32_32x32x16_bf16 v[192:207], v[112:115], a[44:47], v[192:207]
		v_add3_u32 v6, v6, v20, v11
		v_mfma_f32_32x32x16_bf16 v[96:111], v[116:119], a[20:23], 0
		s_add_i32 s44, s26, s44
		v_mfma_f32_32x32x16_bf16 v[96:111], v[120:123], a[24:27], v[96:111]
		v_add3_u32 v8, s44, v15, v18
		v_mfma_f32_32x32x16_bf16 v[96:111], v[124:127], a[28:31], v[96:111]
		v_add3_u32 v8, v8, v20, v11
		v_mfma_f32_32x32x16_bf16 v[208:223], v[116:119], a[36:39], 0
		s_mul_i32 s44, s17, s25
		v_mfma_f32_32x32x16_bf16 v[208:223], v[120:123], a[40:43], v[208:223]
		s_add_i32 s25, s25, 0x80
		v_mfma_f32_32x32x16_bf16 v[208:223], v[124:127], a[44:47], v[208:223]
		v_accvgpr_read_b32 v9, a19
		v_add_u32_e32 v9, s25, v9
		v_mfma_f32_32x32x16_bf16 v[112:127], v[128:131], a[20:23], 0
		v_accvgpr_read_b32 v10, a56
		v_add_u32_e32 v10, s25, v10
		v_mfma_f32_32x32x16_bf16 v[112:127], a[84:87], a[24:27], v[112:127]
		v_accvgpr_read_b32 v12, a58
		v_add_u32_e32 v12, s25, v12
		v_mfma_f32_32x32x16_bf16 v[112:127], a[88:91], a[28:31], v[112:127]
		v_accvgpr_read_b32 v14, a59
		v_add_u32_e32 v14, s25, v14
		v_mfma_f32_32x32x16_bf16 v[224:239], v[128:131], a[36:39], 0
		v_cmp_lt_i32_e64 s[50:51], v9, s20
		v_accvgpr_read_b32 v9, a52
		v_add_u32_e32 v9, s25, v9
		v_accvgpr_read_b32 v16, a60
		v_add_u32_e32 v16, s25, v16
		v_accvgpr_read_b32 v19, a61
		v_add_u32_e32 v19, s25, v19
		v_accvgpr_read_b32 v28, a62
		v_add_u32_e32 v28, s25, v28
		v_cmp_lt_i32_e64 vcc, v28, s20
		v_cndmask_b32_e64 v1, v21, v1, s[50:51]
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[50:51], v10, s20
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[52:53], v12, s20
		v_cndmask_b32_e64 v1, v21, v3, s[50:51]
		v_cmp_lt_i32_e64 s[50:51], v14, s20
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], a[84:87], a[40:43], v[224:239]
		v_cndmask_b32_e64 v1, v21, v6, s[52:53]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[88:91], a[44:47], v[224:239]
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v3, v21, v8, s[50:51]
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[50:51], v9, s20
		v_cmp_lt_i32_e64 s[52:53], v16, s20
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s44, s44, 1
		s_add_i32 s49, s39, s44
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[144:159], a[72:75], a[32:35], v[144:159]
		v_add3_u32 v1, s49, v2, v13
		v_mfma_f32_32x32x16_bf16 v[160:175], a[72:75], a[48:51], v[160:175]
		v_add3_u32 v1, v1, v17, v11
		v_cndmask_b32_e64 v1, v21, v1, s[50:51]
		v_cmp_lt_i32_e64 s[50:51], v19, s20
		s_mul_i32 s37, 0x4400, s37
		s_add_i32 s37, s38, s37
		s_add_i32 m0, s37, 0x81f0
		s_add_i32 s37, s47, s44
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_add3_u32 v1, s37, v2, v13
		v_add3_u32 v1, v1, v17, v11
		v_cndmask_b32_e64 v1, v21, v1, s[52:53]
		v_max3_f32 v3, v144, v145, v146
		s_add_i32 m0, m0, 0x1100
		s_add_i32 s37, s48, s44
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_add3_u32 v1, s37, v2, v13
		v_add3_u32 v1, v1, v17, v11
		v_max3_f32 v6, v148, v149, v150
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v1, v21, v1, s[50:51]
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_max3_f32 v1, v152, v153, v154
		s_add_i32 s37, s24, s44
		v_add3_u32 v8, s37, v2, v13
		v_add3_u32 v8, v8, v17, v11
		v_cndmask_b32_e32 v8, v21, v8, vcc
		v_max3_f32 v9, v156, v157, v158
		s_add_i32 m0, m0, 0x1100
		v_max3_f32 v3, v3, v147, v6
		v_max3_f32 v1, v1, v155, v9
		v_max3_f32 v1, v3, v151, v1
		v_max3_f32 v3, v160, v161, v162
		v_max3_f32 v6, v164, v165, v166
		v_max3_f32 v9, v168, v169, v170
		v_max3_f32 v10, v172, v173, v174
		v_max3_f32 v3, v3, v163, v6
		v_max3_f32 v6, v9, v171, v10
		v_max3_f32 v3, v3, v167, v6
		s_cmp_lt_i32 s25, s41
		buffer_load_dwordx4 v8, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[176:191], a[76:79], a[32:35], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[80:83], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[92:95], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[92:95], a[48:51], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[76:79], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[80:83], a[48:51], v[208:223]
		s_nop 6
		v_max3_f32 v6, v176, v177, v178
		v_max3_f32 v8, v180, v181, v182
		v_max3_f32 v9, v184, v185, v186
		v_max3_f32 v10, v188, v189, v190
		v_max3_f32 v12, v96, v97, v98
		v_max3_f32 v14, v100, v101, v102
		v_max3_f32 v16, v104, v105, v106
		v_max3_f32 v19, v108, v109, v110
		v_max3_f32 v28, v112, v113, v114
		v_max3_f32 v29, v116, v117, v118
		v_max3_f32 v30, v120, v121, v122
		v_max3_f32 v31, v124, v125, v126
		v_max3_f32 v6, v6, v179, v8
		v_max3_f32 v8, v9, v187, v10
		v_max3_f32 v9, v12, v99, v14
		v_max3_f32 v10, v16, v107, v19
		v_max3_f32 v12, v28, v115, v29
		v_max3_f32 v14, v30, v123, v31
		v_max3_f32 v6, v6, v183, v8
		v_max3_f32 v8, v9, v103, v10
		v_max3_f32 v9, v12, v119, v14
		v_max3_f32 v1, v1, v159, v6
		v_max3_f32 v6, v8, v111, v9
		v_max3_f32 v1, v1, v191, v6
		v_max_f32_e32 v8, v1, v127
		v_mov_b32_e32 v9, v8
		v_max3_f32 v1, v192, v193, v194
		v_max3_f32 v6, v196, v197, v198
		v_max3_f32 v10, v200, v201, v202
		v_max3_f32 v12, v204, v205, v206
		v_max3_f32 v14, v208, v209, v210
		v_max3_f32 v16, v212, v213, v214
		v_max3_f32 v19, v216, v217, v218
		v_max3_f32 v28, v220, v221, v222
		v_max3_f32 v29, v224, v225, v226
		v_max3_f32 v30, v228, v229, v230
		v_max3_f32 v31, v232, v233, v234
		v_max3_f32 v128, v236, v237, v238
		v_max3_f32 v1, v1, v195, v6
		v_max3_f32 v6, v10, v203, v12
		v_max3_f32 v10, v14, v211, v16
		v_max3_f32 v12, v19, v219, v28
		v_permlane32_swap_b32_e32 v8, v9
		v_max3_f32 v14, v29, v227, v30
		v_max3_f32 v16, v31, v235, v128
		v_max3_f32 v1, v1, v199, v6
		v_max3_f32 v6, v10, v215, v12
		v_max3_f32 v10, v14, v231, v16
		v_max3_f32 v1, v3, v175, v1
		v_max3_f32 v3, v6, v223, v10
		v_max3_f32 v1, v1, v207, v3
		v_max_f32_e32 v28, v1, v239
		v_mov_b32_e32 v29, v28
		v_max_f32_e32 v30, v8, v9
		v_mov_b32_e32 v8, v4
		v_permlane32_swap_b32_e32 v28, v29
		v_max_f32_e32 v31, v28, v29
		v_pk_mul_f32 v[28:29], v[30:31], v[24:25]
		v_max_f32_e32 v30, v4, v28
		v_max_f32_e32 v31, v7, v29
		v_pk_fma_f32 v[28:29], v[144:145], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[146:147], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[148:149], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[150:151], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[152:153], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[154:155], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[156:157], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[158:159], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[176:177], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[178:179], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[180:181], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[182:183], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[184:185], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[186:187], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[188:189], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[190:191], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[96:97], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[98:99], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[108:109], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[110:111], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[112:113], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[114:115], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[116:117], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[118:119], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[120:121], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[122:123], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[124:125], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[126:127], v[24:25], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[160:161], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[162:163], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[164:165], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[166:167], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[168:169], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[170:171], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[172:173], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[174:175], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[192:193], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[194:195], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[196:197], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[198:199], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[200:201], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[202:203], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[204:205], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[206:207], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[208:209], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[210:211], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[212:213], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[214:215], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[216:217], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[218:219], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[220:221], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[222:223], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[224:225], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[226:227], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[228:229], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[230:231], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[232:233], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[234:235], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[218:219], v[236:237], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[220:221], v[238:239], v[24:25], v[30:31] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v222, v28
		v_exp_f32_e32 v224, v29
		v_exp_f32_e32 v28, v128
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
		v_exp_f32_e32 v142, v144
		v_exp_f32_e32 v242, v145
		v_exp_f32_e32 v144, v146
		v_exp_f32_e32 v244, v147
		v_exp_f32_e32 v146, v148
		v_exp_f32_e32 v246, v149
		v_exp_f32_e32 v148, v150
		v_exp_f32_e32 v248, v151
		v_exp_f32_e32 v150, v152
		v_exp_f32_e32 v250, v153
		v_exp_f32_e32 v152, v154
		v_exp_f32_e32 v252, v155
		v_exp_f32_e32 v154, v156
		v_exp_f32_e32 v254, v157
		v_exp_f32_e32 v223, v158
		v_exp_f32_e32 v225, v159
		v_exp_f32_e32 v29, v96
		v_exp_f32_e32 v227, v97
		v_exp_f32_e32 v129, v98
		v_exp_f32_e32 v229, v99
		v_exp_f32_e32 v131, v100
		v_exp_f32_e32 v231, v101
		v_exp_f32_e32 v133, v102
		v_exp_f32_e32 v233, v103
		v_exp_f32_e32 v135, v104
		v_exp_f32_e32 v235, v105
		v_exp_f32_e32 v137, v106
		v_exp_f32_e32 v237, v107
		v_exp_f32_e32 v139, v108
		v_exp_f32_e32 v239, v109
		v_exp_f32_e32 v141, v110
		v_exp_f32_e32 v241, v111
		v_exp_f32_e32 v143, v112
		v_exp_f32_e32 v243, v113
		v_exp_f32_e32 v145, v114
		v_exp_f32_e32 v245, v115
		v_exp_f32_e32 v147, v116
		v_exp_f32_e32 v247, v117
		v_exp_f32_e32 v149, v118
		v_exp_f32_e32 v249, v119
		v_exp_f32_e32 v151, v120
		v_exp_f32_e32 v251, v121
		v_exp_f32_e32 v153, v122
		v_exp_f32_e32 v253, v123
		v_exp_f32_e32 v155, v124
		v_exp_f32_e32 v255, v125
		v_exp_f32_e32 v96, v126
		v_exp_f32_e32 v98, v127
		v_exp_f32_e32 v100, v160
		v_exp_f32_e32 v102, v161
		v_exp_f32_e32 v104, v162
		v_exp_f32_e32 v106, v163
		v_exp_f32_e32 v108, v164
		v_exp_f32_e32 v110, v165
		v_exp_f32_e32 v112, v166
		v_exp_f32_e32 v114, v167
		v_exp_f32_e32 v116, v168
		v_exp_f32_e32 v118, v169
		v_exp_f32_e32 v120, v170
		v_exp_f32_e32 v122, v171
		v_exp_f32_e32 v124, v172
		v_exp_f32_e32 v126, v173
		v_exp_f32_e32 v156, v174
		v_exp_f32_e32 v158, v175
		v_exp_f32_e32 v160, v176
		v_exp_f32_e32 v162, v177
		v_exp_f32_e32 v164, v178
		v_exp_f32_e32 v166, v179
		v_exp_f32_e32 v168, v180
		v_exp_f32_e32 v170, v181
		v_exp_f32_e32 v172, v182
		v_exp_f32_e32 v174, v183
		v_exp_f32_e32 v176, v184
		v_exp_f32_e32 v178, v185
		v_exp_f32_e32 v180, v186
		v_exp_f32_e32 v182, v187
		v_exp_f32_e32 v184, v188
		v_exp_f32_e32 v186, v189
		v_exp_f32_e32 v97, v190
		v_exp_f32_e32 v99, v191
		v_exp_f32_e32 v101, v192
		v_exp_f32_e32 v103, v193
		v_exp_f32_e32 v105, v194
		v_exp_f32_e32 v107, v195
		v_exp_f32_e32 v109, v196
		v_exp_f32_e32 v111, v197
		v_exp_f32_e32 v113, v198
		v_exp_f32_e32 v115, v199
		v_exp_f32_e32 v117, v200
		v_exp_f32_e32 v119, v201
		v_exp_f32_e32 v121, v202
		v_exp_f32_e32 v123, v203
		v_exp_f32_e32 v125, v204
		v_exp_f32_e32 v127, v205
		v_exp_f32_e32 v157, v206
		v_exp_f32_e32 v159, v207
		v_exp_f32_e32 v161, v208
		v_exp_f32_e32 v163, v209
		v_exp_f32_e32 v165, v210
		v_exp_f32_e32 v167, v211
		v_exp_f32_e32 v169, v212
		v_exp_f32_e32 v171, v213
		v_exp_f32_e32 v173, v214
		v_exp_f32_e32 v175, v215
		v_exp_f32_e32 v177, v216
		v_exp_f32_e32 v179, v217
		v_exp_f32_e32 v181, v218
		v_exp_f32_e32 v183, v219
		v_exp_f32_e32 v185, v220
		v_exp_f32_e32 v187, v221
		v_pk_add_f32 v[188:189], v[222:223], v[224:225]
		v_pk_add_f32 v[190:191], v[28:29], v[226:227]
		v_pk_add_f32 v[192:193], v[128:129], v[228:229]
		v_pk_add_f32 v[194:195], v[130:131], v[230:231]
		v_pk_add_f32 v[196:197], v[132:133], v[232:233]
		v_pk_add_f32 v[198:199], v[134:135], v[234:235]
		v_pk_add_f32 v[200:201], v[136:137], v[236:237]
		v_pk_add_f32 v[202:203], v[138:139], v[238:239]
		v_pk_add_f32 v[204:205], v[140:141], v[240:241]
		v_pk_add_f32 v[206:207], v[142:143], v[242:243]
		v_pk_add_f32 v[208:209], v[144:145], v[244:245]
		v_pk_add_f32 v[210:211], v[146:147], v[246:247]
		v_pk_add_f32 v[212:213], v[148:149], v[248:249]
		v_pk_add_f32 v[214:215], v[150:151], v[250:251]
		v_pk_add_f32 v[216:217], v[152:153], v[252:253]
		v_pk_add_f32 v[218:219], v[154:155], v[254:255]
		v_pk_add_f32 v[188:189], v[188:189], v[190:191]
		v_pk_add_f32 v[190:191], v[192:193], v[194:195]
		v_pk_add_f32 v[192:193], v[196:197], v[198:199]
		v_pk_add_f32 v[194:195], v[200:201], v[202:203]
		v_pk_add_f32 v[196:197], v[204:205], v[206:207]
		v_pk_add_f32 v[198:199], v[208:209], v[210:211]
		v_pk_add_f32 v[200:201], v[212:213], v[214:215]
		v_pk_add_f32 v[202:203], v[216:217], v[218:219]
		v_pk_add_f32 v[188:189], v[188:189], v[190:191]
		v_pk_add_f32 v[190:191], v[192:193], v[194:195]
		v_pk_add_f32 v[192:193], v[196:197], v[198:199]
		v_pk_add_f32 v[194:195], v[200:201], v[202:203]
		v_pk_add_f32 v[188:189], v[188:189], v[190:191]
		v_pk_add_f32 v[190:191], v[192:193], v[194:195]
		v_pk_add_f32 v[192:193], v[188:189], v[190:191]
		v_add_f32_e32 v1, v192, v193
		v_accvgpr_read_b32 v3, a70
		ds_bpermute_b32 v188, v3, v1
		v_accvgpr_read_b32 v3, a71
		ds_bpermute_b32 v190, v3, v1
		v_pk_add_f32 v[192:193], v[96:97], v[98:99]
		v_pk_add_f32 v[194:195], v[100:101], v[102:103]
		v_pk_add_f32 v[196:197], v[104:105], v[106:107]
		v_pk_add_f32 v[198:199], v[108:109], v[110:111]
		v_pk_add_f32 v[200:201], v[112:113], v[114:115]
		v_pk_add_f32 v[202:203], v[116:117], v[118:119]
		v_pk_add_f32 v[204:205], v[120:121], v[122:123]
		v_pk_add_f32 v[206:207], v[124:125], v[126:127]
		v_pk_add_f32 v[208:209], v[156:157], v[158:159]
		v_pk_add_f32 v[210:211], v[160:161], v[162:163]
		v_pk_add_f32 v[212:213], v[164:165], v[166:167]
		v_pk_add_f32 v[214:215], v[168:169], v[170:171]
		v_pk_add_f32 v[216:217], v[172:173], v[174:175]
		v_pk_add_f32 v[218:219], v[176:177], v[178:179]
		v_pk_add_f32 v[220:221], v[180:181], v[182:183]
		v_accvgpr_write_b32 a72, v220
		v_accvgpr_write_b32 a73, v221
		v_pk_add_f32 v[220:221], v[184:185], v[186:187]
		v_pk_add_f32 v[192:193], v[192:193], v[194:195]
		v_pk_add_f32 v[194:195], v[196:197], v[198:199]
		v_pk_add_f32 v[196:197], v[200:201], v[202:203]
		v_pk_add_f32 v[198:199], v[204:205], v[206:207]
		v_pk_add_f32 v[200:201], v[208:209], v[210:211]
		v_pk_add_f32 v[202:203], v[212:213], v[214:215]
		v_pk_add_f32 v[204:205], v[216:217], v[218:219]
		v_accvgpr_read_b32 v206, a72
		v_accvgpr_read_b32 v207, a73
		v_pk_add_f32 v[206:207], v[206:207], v[220:221]
		v_pk_add_f32 v[192:193], v[192:193], v[194:195]
		v_pk_add_f32 v[194:195], v[196:197], v[198:199]
		v_pk_add_f32 v[196:197], v[200:201], v[202:203]
		v_pk_add_f32 v[198:199], v[204:205], v[206:207]
		v_pk_add_f32 v[192:193], v[192:193], v[194:195]
		v_pk_add_f32 v[194:195], v[196:197], v[198:199]
		v_pk_add_f32 v[196:197], v[192:193], v[194:195]
		v_mov_b32_e32 v191, v197
		v_mov_b32_e32 v189, v196
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[192:193], v[188:189], v[190:191]
		v_mov_b32_e32 v188, v193
		v_mov_b32_e32 v189, v193
		v_cvt_pk_bf16_f32 v196, v222, v224
		v_cvt_pk_bf16_f32 v197, v28, v226
		v_permlane32_swap_b32_e32 v188, v189
		v_add_f32_e32 v191, v188, v189
		v_mov_b32_e32 v9, v7
		v_pk_add_f32 v[6:7], v[8:9], v[30:31] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v8, v6
		v_exp_f32_e32 v9, v7
		v_cvt_pk_bf16_f32 v198, v128, v228
		v_mov_b32_e32 v190, v192
		v_mov_b64_e32 v[6:7], v[26:27]
		v_pk_fma_f32 v[26:27], v[6:7], v[8:9], v[190:191]
		v_cvt_pk_bf16_f32 v199, v130, v230
		v_cvt_pk_bf16_f32 v188, v132, v232
		v_cvt_pk_bf16_f32 v189, v134, v234
		v_cvt_pk_bf16_f32 v190, v136, v236
		v_cvt_pk_bf16_f32 v191, v138, v238
		v_cvt_pk_bf16_f32 v192, v140, v240
		v_cvt_pk_bf16_f32 v193, v142, v242
		v_cvt_pk_bf16_f32 v194, v144, v244
		v_cvt_pk_bf16_f32 v195, v146, v246
		v_cvt_pk_bf16_f32 v200, v148, v248
		v_cvt_pk_bf16_f32 v201, v150, v250
		v_cvt_pk_bf16_f32 v202, v152, v252
		v_cvt_pk_bf16_f32 v203, v154, v254
		v_cvt_pk_bf16_f32 v204, v223, v225
		v_pk_mul_f32 v[32:33], v[32:33], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[34:35], v[34:35], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[36:37], v[36:37], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[38:39], v[38:39], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[40:41], v[40:41], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[42:43], v[42:43], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[44:45], v[44:45], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[46:47], v[46:47], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[48:49], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[50:51], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[52:53], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[54:55], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[56:57], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[58:59], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[60:61], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[62:63], v[8:9] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[64:65], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[66:67], v[66:67], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[68:69], v[68:69], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[70:71], v[70:71], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[72:73], v[72:73], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[74:75], v[74:75], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[76:77], v[76:77], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[78:79], v[78:79], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[80:81], v[80:81], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[82:83], v[82:83], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[84:85], v[84:85], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[86:87], v[86:87], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[88:89], v[88:89], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[90:91], v[90:91], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[92:93], v[92:93], v[8:9] op_sel:[0,1]
		v_pk_mul_f32 v[94:95], v[94:95], v[8:9] op_sel:[0,1]
		v_cvt_pk_bf16_f32 v205, v29, v227
		v_cvt_pk_bf16_f32 v206, v129, v229
		v_cvt_pk_bf16_f32 v207, v131, v231
		v_cvt_pk_bf16_f32 v128, v133, v233
		v_cvt_pk_bf16_f32 v129, v135, v235
		v_cvt_pk_bf16_f32 v130, v137, v237
		v_cvt_pk_bf16_f32 v131, v139, v239
		v_cvt_pk_bf16_f32 v132, v141, v241
		v_cvt_pk_bf16_f32 v133, v143, v243
		v_cvt_pk_bf16_f32 v134, v145, v245
		v_cvt_pk_bf16_f32 v135, v147, v247
		v_cvt_pk_bf16_f32 v136, v149, v249
		v_cvt_pk_bf16_f32 v137, v151, v251
		v_cvt_pk_bf16_f32 v138, v153, v253
		v_cvt_pk_bf16_f32 v139, v155, v255
		v_cvt_pk_bf16_f32 v140, v96, v98
		v_cvt_pk_bf16_f32 v141, v100, v102
		v_cvt_pk_bf16_f32 v142, v104, v106
		v_cvt_pk_bf16_f32 v143, v108, v110
		v_cvt_pk_bf16_f32 v144, v112, v114
		v_cvt_pk_bf16_f32 v145, v116, v118
		v_cvt_pk_bf16_f32 v146, v120, v122
		v_cvt_pk_bf16_f32 v147, v124, v126
		v_cvt_pk_bf16_f32 v148, v156, v158
		v_cvt_pk_bf16_f32 v149, v160, v162
		v_cvt_pk_bf16_f32 v150, v164, v166
		v_cvt_pk_bf16_f32 v151, v168, v170
		v_cvt_pk_bf16_f32 v152, v172, v174
		v_cvt_pk_bf16_f32 v153, v176, v178
		v_cvt_pk_bf16_f32 v154, v180, v182
		v_cvt_pk_bf16_f32 v155, v184, v186
		v_cvt_pk_bf16_f32 v208, v97, v99
		v_cvt_pk_bf16_f32 v209, v101, v103
		v_cvt_pk_bf16_f32 v210, v105, v107
		v_cvt_pk_bf16_f32 v211, v109, v111
		v_cvt_pk_bf16_f32 v96, v113, v115
		v_cvt_pk_bf16_f32 v97, v117, v119
		v_cvt_pk_bf16_f32 v98, v121, v123
		v_cvt_pk_bf16_f32 v99, v125, v127
		v_cvt_pk_bf16_f32 v100, v157, v159
		v_cvt_pk_bf16_f32 v101, v161, v163
		v_cvt_pk_bf16_f32 v102, v165, v167
		v_cvt_pk_bf16_f32 v103, v169, v171
		v_cvt_pk_bf16_f32 v104, v173, v175
		v_cvt_pk_bf16_f32 v105, v177, v179
		v_cvt_pk_bf16_f32 v106, v181, v183
		v_cvt_pk_bf16_f32 v107, v185, v187
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[32:47], a[96:99], v[196:199], v[32:47]
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_mfma_f32_32x32x16_bf16 v[48:63], a[128:131], v[196:199], v[48:63]
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_mfma_f32_32x32x16_bf16 v[32:47], a[100:103], v[188:191], v[32:47]
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_mfma_f32_32x32x16_bf16 v[48:63], a[132:135], v[188:191], v[48:63]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[32:47], a[104:107], v[192:195], v[32:47]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[48:63], a[136:139], v[192:195], v[48:63]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[32:47], a[108:111], v[200:203], v[32:47]
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_mfma_f32_32x32x16_bf16 v[48:63], a[140:143], v[200:203], v[48:63]
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_mfma_f32_32x32x16_bf16 v[80:95], a[128:131], v[140:143], v[80:95]
		v_permlane32_swap_b32_e32 v148, v150
		v_permlane32_swap_b32_e32 v149, v151
		v_mfma_f32_32x32x16_bf16 v[64:79], a[96:99], v[140:143], v[64:79]
		v_permlane32_swap_b32_e32 v152, v154
		v_permlane32_swap_b32_e32 v153, v155
		v_mfma_f32_32x32x16_bf16 v[80:95], a[132:135], v[144:147], v[80:95]
		v_permlane32_swap_b32_e32 v208, v210
		v_permlane32_swap_b32_e32 v209, v211
		v_mfma_f32_32x32x16_bf16 v[64:79], a[100:103], v[144:147], v[64:79]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[80:95], a[136:139], v[148:151], v[80:95]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[64:79], a[104:107], v[148:151], v[64:79]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[80:95], a[140:143], v[152:155], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[108:111], v[152:155], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[112:115], v[204:207], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[144:147], v[204:207], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[208:211], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[112:115], v[208:211], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[116:119], v[128:131], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[148:151], v[128:131], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[148:151], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[116:119], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[120:123], v[132:135], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[152:155], v[132:135], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[120:123], v[100:103], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[124:127], v[136:139], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[156:159], v[136:139], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], v[104:107], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[124:127], v[104:107], v[64:79]
		v_mov_b32_e32 v4, v30
		v_mov_b32_e32 v7, v31
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_3
.L_attn_fwd_persistent.loop_exit_3:
		s_mul_i32 s21, s21, 0x80
		v_accvgpr_read_b32 v1, a6
		s_nop 0
		v_readfirstlane_b32 s25, v1
		v_accvgpr_read_b32 v1, a14
		s_nop 0
		v_add_u32_e32 v1, s25, v1
		v_add_u32_e32 v1, s1, v1
		v_accvgpr_read_b32 v3, a6
		s_nop 0
		v_readfirstlane_b32 s25, v3
		v_accvgpr_read_b32 v3, a15
		s_nop 0
		v_add_u32_e32 v3, s25, v3
		v_add_u32_e32 v3, s1, v3
		v_xor_b32_e32 v6, 1, v5
		v_accvgpr_write_b32 a14, v6
		v_xor_b32_e32 v6, 2, v5
		v_accvgpr_write_b32 a15, v6
		v_xor_b32_e32 v6, 3, v5
		v_accvgpr_write_b32 a66, v6
		v_xor_b32_e32 v6, 8, v5
		v_accvgpr_write_b32 a68, v6
		v_xor_b32_e32 v6, 9, v5
		v_accvgpr_write_b32 a72, v6
		v_xor_b32_e32 v6, 10, v5
		v_accvgpr_write_b32 a73, v6
		v_xor_b32_e32 v6, 11, v5
		v_accvgpr_write_b32 a74, v6
		v_xor_b32_e32 v6, 16, v5
		v_accvgpr_write_b32 a75, v6
		v_xor_b32_e32 v6, 17, v5
		v_accvgpr_write_b32 a76, v6
		v_xor_b32_e32 v6, 18, v5
		v_accvgpr_write_b32 a77, v6
		v_xor_b32_e32 v6, 19, v5
		v_accvgpr_write_b32 a78, v6
		v_xor_b32_e32 v6, 24, v5
		v_accvgpr_write_b32 a79, v6
		v_xor_b32_e32 v6, 25, v5
		v_accvgpr_write_b32 a80, v6
		v_xor_b32_e32 v6, 26, v5
		v_accvgpr_write_b32 a81, v6
		v_xor_b32_e32 v6, 27, v5
		v_accvgpr_write_b32 a82, v6
		v_xor_b32_e32 v6, 32, v5
		v_accvgpr_write_b32 a83, v6
		v_xor_b32_e32 v6, 33, v5
		v_accvgpr_write_b32 a84, v6
		v_xor_b32_e32 v6, 34, v5
		v_accvgpr_write_b32 a85, v6
		v_xor_b32_e32 v6, 35, v5
		v_accvgpr_write_b32 a86, v6
		v_xor_b32_e32 v6, 40, v5
		v_accvgpr_write_b32 a87, v6
		v_xor_b32_e32 v6, 41, v5
		v_accvgpr_write_b32 a88, v6
		v_xor_b32_e32 v6, 42, v5
		v_accvgpr_write_b32 a89, v6
		v_xor_b32_e32 v6, 43, v5
		v_accvgpr_write_b32 a90, v6
		v_xor_b32_e32 v6, 48, v5
		v_accvgpr_write_b32 a91, v6
		v_xor_b32_e32 v6, 49, v5
		v_accvgpr_write_b32 a92, v6
		v_xor_b32_e32 v6, 50, v5
		v_accvgpr_write_b32 a93, v6
		v_xor_b32_e32 v6, 51, v5
		v_accvgpr_write_b32 a94, v6
		v_xor_b32_e32 v6, 56, v5
		v_accvgpr_write_b32 a95, v6
		v_xor_b32_e32 v6, 57, v5
		v_accvgpr_write_b32 a96, v6
		v_xor_b32_e32 v6, 58, v5
		v_accvgpr_write_b32 a97, v6
		v_xor_b32_e32 v6, 59, v5
		v_accvgpr_write_b32 a98, v6
		v_xor_b32_e32 v6, 64, v5
		v_accvgpr_write_b32 a99, v6
		v_xor_b32_e32 v6, 0x41, v5
		v_accvgpr_write_b32 a100, v6
		v_xor_b32_e32 v6, 0x42, v5
		v_accvgpr_write_b32 a101, v6
		v_xor_b32_e32 v6, 0x43, v5
		v_accvgpr_write_b32 a102, v6
		v_xor_b32_e32 v6, 0x48, v5
		v_accvgpr_write_b32 a103, v6
		v_xor_b32_e32 v6, 0x49, v5
		v_accvgpr_write_b32 a104, v6
		v_xor_b32_e32 v6, 0x4a, v5
		v_accvgpr_write_b32 a105, v6
		v_xor_b32_e32 v6, 0x4b, v5
		v_accvgpr_write_b32 a106, v6
		v_xor_b32_e32 v6, 0x50, v5
		v_accvgpr_write_b32 a107, v6
		v_xor_b32_e32 v6, 0x51, v5
		v_accvgpr_write_b32 a108, v6
		v_xor_b32_e32 v6, 0x52, v5
		v_accvgpr_write_b32 a109, v6
		v_xor_b32_e32 v6, 0x53, v5
		v_accvgpr_write_b32 a110, v6
		v_xor_b32_e32 v6, 0x58, v5
		v_accvgpr_write_b32 a111, v6
		v_xor_b32_e32 v6, 0x59, v5
		v_accvgpr_write_b32 a112, v6
		v_xor_b32_e32 v6, 0x5a, v5
		v_accvgpr_write_b32 a113, v6
		v_xor_b32_e32 v6, 0x5b, v5
		v_accvgpr_write_b32 a114, v6
		v_xor_b32_e32 v6, 0x60, v5
		v_accvgpr_write_b32 a115, v6
		v_xor_b32_e32 v6, 0x61, v5
		v_accvgpr_write_b32 a116, v6
		v_xor_b32_e32 v6, 0x62, v5
		v_accvgpr_write_b32 a117, v6
		v_xor_b32_e32 v6, 0x63, v5
		v_accvgpr_write_b32 a118, v6
		v_xor_b32_e32 v6, 0x68, v5
		v_accvgpr_write_b32 a119, v6
		v_xor_b32_e32 v6, 0x69, v5
		v_accvgpr_write_b32 a120, v6
		v_xor_b32_e32 v6, 0x6a, v5
		v_accvgpr_write_b32 a121, v6
		v_xor_b32_e32 v6, 0x6b, v5
		v_accvgpr_write_b32 a122, v6
		v_xor_b32_e32 v6, 0x70, v5
		v_accvgpr_write_b32 a123, v6
		v_xor_b32_e32 v6, 0x71, v5
		v_accvgpr_write_b32 a124, v6
		v_xor_b32_e32 v6, 0x72, v5
		v_accvgpr_write_b32 a125, v6
		v_xor_b32_e32 v6, 0x73, v5
		v_accvgpr_write_b32 a126, v6
		v_xor_b32_e32 v6, 0x78, v5
		v_accvgpr_write_b32 a127, v6
		v_xor_b32_e32 v6, 0x79, v5
		v_accvgpr_write_b32 a128, v6
		v_xor_b32_e32 v6, 0x7a, v5
		v_accvgpr_write_b32 a129, v6
		v_xor_b32_e32 v6, 0x7b, v5
		v_accvgpr_write_b32 a130, v6
		v_accvgpr_read_b32 v6, a53
		v_accvgpr_read_b32 v8, a63
		v_accvgpr_read_b32 v9, a64
		v_add3_u32 v6, v6, v8, v9
		v_accvgpr_write_b32 a53, v6
		v_accvgpr_read_b32 v6, a65
		v_accvgpr_read_b32 v8, a67
		v_lshl_add_u32 v6, v6, 3, v8
		v_accvgpr_read_b32 v8, a18
		v_lshl_add_u32 v6, v8, 5, v6
		v_accvgpr_read_b32 v8, a57
		v_accvgpr_read_b32 v9, a69
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
		s_cselect_b32 s25, s22, 0
		s_add_i32 s25, s41, s25
		s_ashr_i32 s25, s25, 7
		s_cmp_lt_i32 s25, 0
		s_cselect_b32 s37, s16, 0
		s_add_i32 s37, s25, s37
		s_ashr_i32 s37, s37, 1
		s_lshl_b32 s37, s37, 1
		s_sub_i32 s37, s25, s37
		s_add_i32 s25, s25, 1
		s_cmp_lt_i32 s25, 0
		s_cselect_b32 s38, s16, 0
		s_add_i32 s38, s25, s38
		s_ashr_i32 s38, s38, 1
		s_lshl_b32 s38, s38, 1
		s_sub_i32 s50, s25, s38
		s_mul_i32 s25, 0x4100, s37
		v_accvgpr_read_b32 v8, a53
		v_add_u32_e32 v8, s25, v8
		ds_read_b128 a[132:135], v8
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
		s_mul_i32 s25, 0x4400, s37
		v_accvgpr_read_b32 v8, a18
		v_add_u32_e32 v8, s25, v8
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
		v_cmp_lt_i32_e64 s[52:53], v8, s20
		v_accvgpr_read_b32 v8, a52
		v_add_u32_e32 v8, s1, v8
		v_cmp_lt_i32_e64 s[54:55], v8, s20
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s25, s15, s41
		s_lshl_b32 s25, s25, 1
		s_add_i32 s37, s23, s25
		v_add3_u32 v8, s37, v15, v18
		v_add3_u32 v8, v8, v20, v11
		v_cndmask_b32_e64 v8, v21, v8, s[52:53]
		s_mov_b32 s52, 1
		s_mov_b32 s53, 0
		s_mov_b32 s37, s27
		s_mul_i32 s56, s52, s36
		s_mul_hi_u32 s57, s52, s36
		s_mul_i32 s38, s52, s37
		s_add_i32 s57, s57, s38
		s_mul_i32 s38, s53, s36
		s_add_i32 s57, s57, s38
		s_lshr_b64 s[52:53], s[56:57], 6
		s_mov_b32 s56, 0x410
		s_mov_b32 s57, 0
		s_mul_i32 s58, s56, s52
		s_mul_hi_u32 s59, s56, s52
		s_mul_i32 s37, s56, s53
		s_add_i32 s59, s59, s37
		s_mul_i32 s37, s57, s52
		s_add_i32 s59, s59, s37
		s_cmp_lt_i32 s50, 0
		s_cselect_b32 s51, -1, 0
		s_mov_b32 s56, 0x4100
		s_mov_b32 s57, 0
		s_mul_i32 s60, s56, s50
		s_mul_hi_u32 s61, s56, s50
		s_mul_i32 s37, s56, s51
		s_add_i32 s61, s61, s37
		s_mul_i32 s37, s57, s50
		s_add_i32 s61, s61, s37
		s_add_u32 s56, s58, s60
		s_addc_u32 s57, s59, s61
		s_add_u32 s62, s56, 0
		s_addc_u32 s63, s57, 0
		s_mov_b32 m0, s62
		v_accvgpr_read_b32 v9, a56
		v_add_u32_e32 v9, s1, v9
		buffer_load_dwordx4 v8, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[56:57], v9, s20
		s_add_i32 s37, s45, s25
		v_add3_u32 v8, s37, v15, v18
		v_add3_u32 v8, v8, v20, v11
		v_cndmask_b32_e64 v8, v21, v8, s[56:57]
		s_add_u32 s56, s58, 0x1040
		s_addc_u32 s57, s59, 0
		s_add_u32 s56, s56, s60
		s_addc_u32 s57, s57, s61
		s_add_u32 s62, s56, 0
		s_addc_u32 s63, s57, 0
		s_mov_b32 m0, s62
		v_accvgpr_read_b32 v9, a58
		v_add_u32_e32 v9, s1, v9
		buffer_load_dwordx4 v8, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[56:57], v9, s20
		s_add_i32 s37, s46, s25
		v_add3_u32 v8, s37, v15, v18
		v_add3_u32 v8, v8, v20, v11
		v_cndmask_b32_e64 v8, v21, v8, s[56:57]
		s_add_u32 s56, s58, 0x2080
		s_addc_u32 s57, s59, 0
		s_add_u32 s56, s56, s60
		s_addc_u32 s57, s57, s61
		s_add_u32 s62, s56, 0
		s_addc_u32 s63, s57, 0
		s_mov_b32 m0, s62
		v_accvgpr_read_b32 v9, a59
		v_add_u32_e32 v9, s1, v9
		buffer_load_dwordx4 v8, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[56:57], v9, s20
		s_add_i32 s25, s26, s25
		v_add3_u32 v8, s25, v15, v18
		v_add3_u32 v8, v8, v20, v11
		v_cndmask_b32_e64 v8, v21, v8, s[56:57]
		s_add_u32 s56, s58, 0x30c0
		s_addc_u32 s57, s59, 0
		s_add_u32 s56, s56, s60
		s_addc_u32 s57, s57, s61
		s_add_u32 s58, s56, 0
		s_addc_u32 s59, s57, 0
		s_mov_b32 m0, s58
		v_accvgpr_read_b32 v9, a60
		v_add_u32_e32 v9, s1, v9
		buffer_load_dwordx4 v8, s[28:31], 0 offen lds
		s_mul_i32 s25, s17, s41
		s_lshl_b32 s25, s25, 1
		s_add_i32 s37, s39, s25
		v_add3_u32 v8, s37, v2, v13
		v_add3_u32 v8, v8, v17, v11
		v_cndmask_b32_e64 v8, v21, v8, s[54:55]
		s_mov_b32 s54, 0x440
		s_mov_b32 s55, 0
		s_mul_i32 s56, s54, s52
		s_mul_hi_u32 s57, s54, s52
		s_mul_i32 s37, s54, s53
		s_add_i32 s57, s57, s37
		s_mul_i32 s37, s55, s52
		s_add_i32 s57, s57, s37
		s_add_u32 s52, s56, 0x81f0
		s_addc_u32 s53, s57, 0
		s_mov_b32 s54, 0x4400
		s_mov_b32 s55, 0
		s_mul_i32 s58, s54, s50
		s_mul_hi_u32 s59, s54, s50
		s_mul_i32 s37, s54, s51
		s_add_i32 s59, s59, s37
		s_mul_i32 s37, s55, s50
		s_add_i32 s59, s59, s37
		s_add_u32 s50, s52, s58
		s_addc_u32 s51, s53, s59
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		v_accvgpr_read_b32 v10, a61
		v_add_u32_e32 v10, s1, v10
		buffer_load_dwordx4 v8, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[50:51], v9, s20
		s_add_i32 s37, s47, s25
		v_add3_u32 v8, s37, v2, v13
		v_add3_u32 v8, v8, v17, v11
		v_cndmask_b32_e64 v8, v21, v8, s[50:51]
		s_add_u32 s50, s56, 0x92f0
		s_addc_u32 s51, s57, 0
		s_add_u32 s50, s50, s58
		s_addc_u32 s51, s51, s59
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		v_accvgpr_read_b32 v9, a62
		v_add_u32_e32 v9, s1, v9
		buffer_load_dwordx4 v8, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[50:51], v10, s20
		s_add_i32 s37, s48, s25
		v_add3_u32 v8, s37, v2, v13
		v_add3_u32 v8, v8, v17, v11
		s_add_u32 s52, s56, 0xa3f0
		s_addc_u32 s53, s57, 0
		s_add_u32 s52, s52, s58
		s_addc_u32 s53, s53, s59
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v8, v21, v8, s[50:51]
		buffer_load_dwordx4 v8, s[32:35], 0 offen lds
		s_add_i32 s25, s24, s25
		v_add3_u32 v8, s25, v2, v13
		v_cmp_lt_i32_e64 vcc, v9, s20
		v_add3_u32 v8, v8, v17, v11
		s_add_u32 s50, s56, 0xb4f0
		s_addc_u32 s51, s57, 0
		v_cndmask_b32_e32 v8, v21, v8, vcc
		s_add_u32 s50, s50, s58
		s_addc_u32 s51, s51, s59
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		s_nop 0
		buffer_load_dwordx4 v8, s[32:35], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_4
.L_attn_fwd_persistent.if_else_4:
.L_attn_fwd_persistent.if_end_4:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[96:111], a[132:135], a[20:23], 0
		s_cmp_lt_i32 s1, s21
		v_mfma_f32_32x32x16_bf16 v[112:127], a[148:151], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[128:143], a[164:167], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[20:23], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[28:31], a[36:39], 0
		v_mfma_f32_32x32x16_bf16 v[176:191], a[132:135], a[36:39], 0
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
		v_accvgpr_read_b32 v9, a14
		v_add_u32_e32 v9, s41, v9
		v_mfma_f32_32x32x16_bf16 v[192:207], a[156:159], a[44:47], v[192:207]
		v_accvgpr_read_b32 v10, a15
		v_add_u32_e32 v10, s41, v10
		v_mfma_f32_32x32x16_bf16 v[208:223], a[172:175], a[44:47], v[208:223]
		v_accvgpr_read_b32 v12, a66
		v_add_u32_e32 v12, s41, v12
		v_mfma_f32_32x32x16_bf16 v[96:111], a[144:147], a[32:35], v[96:111]
		v_cmp_ge_i32_e64 vcc, v1, v12
		v_mfma_f32_32x32x16_bf16 v[112:127], a[160:163], a[32:35], v[112:127]
		v_accvgpr_read_b32 v14, a73
		v_add_u32_e32 v14, s41, v14
		v_mfma_f32_32x32x16_bf16 v[128:143], a[176:179], a[32:35], v[128:143]
		v_accvgpr_read_b32 v16, a74
		v_add_u32_e32 v16, s41, v16
		v_mfma_f32_32x32x16_bf16 v[144:159], a[188:191], a[32:35], v[144:159]
		v_accvgpr_read_b32 v19, a77
		v_add_u32_e32 v19, s41, v19
		v_mfma_f32_32x32x16_bf16 v[160:175], a[188:191], a[48:51], v[160:175]
		v_accvgpr_read_b32 v28, a78
		v_add_u32_e32 v28, s41, v28
		v_mfma_f32_32x32x16_bf16 v[176:191], a[144:147], a[48:51], v[176:191]
		v_accvgpr_read_b32 v29, a81
		v_add_u32_e32 v29, s41, v29
		v_mfma_f32_32x32x16_bf16 v[192:207], a[160:163], a[48:51], v[192:207]
		v_cndmask_b32_e32 v31, v6, v99, vcc
		v_mfma_f32_32x32x16_bf16 v[208:223], a[176:179], a[48:51], v[208:223]
		v_accvgpr_read_b32 v30, a82
		v_add_u32_e32 v99, s41, v30
		v_accvgpr_read_b32 v30, a85
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a57, v30
		v_accvgpr_read_b32 v30, a86
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a63, v30
		v_accvgpr_read_b32 v30, a89
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a64, v30
		v_accvgpr_read_b32 v30, a90
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a65, v30
		v_accvgpr_read_b32 v30, a93
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a67, v30
		v_accvgpr_read_b32 v30, a94
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a69, v30
		v_accvgpr_read_b32 v30, a97
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a131, v30
		v_accvgpr_read_b32 v30, a98
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a132, v30
		v_accvgpr_read_b32 v30, a101
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a133, v30
		v_accvgpr_read_b32 v30, a102
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a134, v30
		v_accvgpr_read_b32 v30, a105
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a135, v30
		v_accvgpr_read_b32 v30, a106
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a136, v30
		v_accvgpr_read_b32 v30, a109
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a137, v30
		v_accvgpr_read_b32 v30, a110
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a138, v30
		v_accvgpr_read_b32 v30, a113
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a139, v30
		v_accvgpr_read_b32 v30, a114
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a140, v30
		v_accvgpr_read_b32 v30, a117
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a141, v30
		v_accvgpr_read_b32 v30, a118
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a142, v30
		v_accvgpr_read_b32 v30, a121
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a143, v30
		v_accvgpr_read_b32 v30, a122
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a144, v30
		v_accvgpr_read_b32 v30, a125
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a145, v30
		v_accvgpr_read_b32 v30, a126
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a146, v30
		v_accvgpr_read_b32 v30, a129
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a147, v30
		v_accvgpr_read_b32 v30, a130
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a148, v30
		v_cmp_ge_i32_e64 s[50:51], v1, v8
		v_cmp_ge_i32_e64 s[52:53], v1, v9
		v_cmp_ge_i32_e64 s[54:55], v1, v10
		v_accvgpr_read_b32 v30, a68
		v_add_u32_e32 v224, s41, v30
		v_accvgpr_read_b32 v30, a72
		v_add_u32_e32 v225, s41, v30
		v_cmp_ge_i32_e64 s[56:57], v1, v224
		v_cmp_ge_i32_e64 s[58:59], v1, v225
		v_cmp_ge_i32_e64 s[60:61], v1, v14
		v_cmp_ge_i32_e64 vcc, v1, v16
		v_accvgpr_read_b32 v30, a75
		v_add_u32_e32 v226, s41, v30
		v_accvgpr_read_b32 v30, a76
		v_add_u32_e32 v227, s41, v30
		v_cndmask_b32_e32 v229, v6, v103, vcc
		v_cmp_ge_i32_e64 s[62:63], v1, v226
		v_cmp_ge_i32_e64 s[64:65], v1, v227
		v_cmp_ge_i32_e64 s[66:67], v1, v19
		v_cmp_ge_i32_e64 vcc, v1, v28
		v_accvgpr_read_b32 v30, a79
		v_add_u32_e32 v103, s41, v30
		v_accvgpr_read_b32 v30, a80
		v_add_u32_e32 v230, s41, v30
		v_cndmask_b32_e32 v233, v6, v107, vcc
		v_cmp_ge_i32_e64 s[68:69], v1, v103
		v_cmp_ge_i32_e64 s[70:71], v1, v230
		v_cmp_ge_i32_e64 s[72:73], v1, v29
		v_cmp_ge_i32_e64 vcc, v1, v99
		v_accvgpr_read_b32 v30, a83
		v_add_u32_e32 v107, s41, v30
		v_accvgpr_read_b32 v30, a84
		v_add_u32_e32 v231, s41, v30
		v_cndmask_b32_e32 v235, v6, v111, vcc
		v_cmp_ge_i32_e64 s[74:75], v1, v107
		v_cmp_ge_i32_e64 s[76:77], v1, v231
		v_accvgpr_read_b32 v30, a57
		v_cmp_ge_i32_e64 s[78:79], v1, v30
		v_accvgpr_read_b32 v30, a63
		v_cmp_ge_i32_e64 vcc, v1, v30
		v_accvgpr_read_b32 v30, a87
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a149, v30
		v_accvgpr_read_b32 v30, a88
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a150, v30
		v_cndmask_b32_e32 v237, v6, v115, vcc
		v_accvgpr_read_b32 v30, a149
		v_cmp_ge_i32_e64 s[80:81], v1, v30
		v_accvgpr_read_b32 v30, a150
		v_cmp_ge_i32_e64 s[82:83], v1, v30
		v_accvgpr_read_b32 v30, a64
		v_cmp_ge_i32_e64 s[84:85], v1, v30
		v_accvgpr_read_b32 v30, a65
		v_cmp_ge_i32_e64 vcc, v1, v30
		v_accvgpr_read_b32 v30, a91
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a151, v30
		v_accvgpr_read_b32 v30, a92
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a152, v30
		v_cndmask_b32_e32 v239, v6, v119, vcc
		v_accvgpr_read_b32 v30, a151
		v_cmp_ge_i32_e64 s[86:87], v1, v30
		v_accvgpr_read_b32 v30, a69
		v_cmp_ge_i32_e64 vcc, v1, v30
		v_accvgpr_read_b32 v30, a95
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a153, v30
		v_accvgpr_read_b32 v30, a96
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a154, v30
		v_cndmask_b32_e32 v241, v6, v123, vcc
		v_accvgpr_read_b32 v30, a132
		v_cmp_ge_i32_e64 vcc, v1, v30
		v_accvgpr_read_b32 v30, a99
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a155, v30
		v_accvgpr_read_b32 v30, a100
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a156, v30
		v_cndmask_b32_e32 v243, v6, v127, vcc
		v_accvgpr_read_b32 v30, a134
		v_cmp_ge_i32_e64 vcc, v1, v30
		v_accvgpr_read_b32 v30, a103
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a157, v30
		v_accvgpr_read_b32 v30, a104
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a158, v30
		v_cndmask_b32_e32 v245, v6, v131, vcc
		v_accvgpr_read_b32 v30, a136
		v_cmp_ge_i32_e64 vcc, v1, v30
		v_accvgpr_read_b32 v30, a107
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a159, v30
		v_accvgpr_read_b32 v30, a108
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a160, v30
		v_cndmask_b32_e32 v247, v6, v135, vcc
		v_accvgpr_read_b32 v30, a138
		v_cmp_ge_i32_e64 vcc, v1, v30
		v_accvgpr_read_b32 v30, a111
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a161, v30
		v_accvgpr_read_b32 v30, a112
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_write_b32 a162, v30
		v_cndmask_b32_e32 v249, v6, v139, vcc
		v_accvgpr_read_b32 v30, a140
		v_cmp_ge_i32_e64 vcc, v1, v30
		v_accvgpr_read_b32 v30, a152
		v_cmp_ge_i32_e64 s[88:89], v1, v30
		v_cndmask_b32_e64 v250, v6, v96, s[50:51]
		v_accvgpr_read_b32 v30, a67
		v_cmp_ge_i32_e64 s[50:51], v1, v30
		s_nop 1
		v_mov_b32_e32 v252, s50
		v_mov_b32_e32 v253, s51
		v_accvgpr_write_b32 a164, v252
		v_accvgpr_write_b32 a165, v253
		v_accvgpr_read_b32 v30, a153
		v_cmp_ge_i32_e64 s[50:51], v1, v30
		s_nop 1
		v_mov_b32_e32 v252, s50
		v_mov_b32_e32 v253, s51
		v_accvgpr_write_b32 a166, v252
		v_accvgpr_write_b32 a167, v253
		v_accvgpr_read_b32 v30, a154
		v_cmp_ge_i32_e64 s[50:51], v1, v30
		s_nop 1
		v_mov_b32_e32 v252, s50
		v_mov_b32_e32 v253, s51
		v_accvgpr_write_b32 a168, v252
		v_accvgpr_write_b32 a169, v253
		v_accvgpr_read_b32 v30, a131
		v_cmp_ge_i32_e64 s[50:51], v1, v30
		s_nop 1
		v_mov_b32_e32 v252, s50
		v_mov_b32_e32 v253, s51
		v_accvgpr_write_b32 a170, v252
		v_accvgpr_write_b32 a171, v253
		v_accvgpr_read_b32 v30, a155
		v_cmp_ge_i32_e64 s[50:51], v1, v30
		s_nop 1
		v_mov_b32_e32 v252, s50
		v_mov_b32_e32 v253, s51
		v_accvgpr_write_b32 a172, v252
		v_accvgpr_write_b32 a173, v253
		v_accvgpr_read_b32 v30, a156
		v_cmp_ge_i32_e64 s[50:51], v1, v30
		s_nop 1
		v_mov_b32_e32 v252, s50
		v_mov_b32_e32 v253, s51
		v_accvgpr_write_b32 a174, v252
		v_accvgpr_write_b32 a175, v253
		v_accvgpr_read_b32 v30, a133
		v_cmp_ge_i32_e64 s[50:51], v1, v30
		s_nop 1
		v_mov_b32_e32 v252, s50
		v_mov_b32_e32 v253, s51
		v_accvgpr_write_b32 a176, v252
		v_accvgpr_write_b32 a177, v253
		v_accvgpr_read_b32 v30, a157
		v_cmp_ge_i32_e64 s[50:51], v1, v30
		s_nop 1
		v_mov_b32_e32 v252, s50
		v_mov_b32_e32 v253, s51
		v_accvgpr_write_b32 a178, v252
		v_accvgpr_write_b32 a179, v253
		v_accvgpr_read_b32 v30, a158
		v_cmp_ge_i32_e64 s[50:51], v1, v30
		s_nop 1
		v_mov_b32_e32 v252, s50
		v_mov_b32_e32 v253, s51
		v_accvgpr_write_b32 a180, v252
		v_accvgpr_write_b32 a181, v253
		v_accvgpr_read_b32 v30, a135
		v_cmp_ge_i32_e64 s[50:51], v1, v30
		s_nop 1
		v_mov_b32_e32 v252, s50
		v_mov_b32_e32 v253, s51
		v_accvgpr_write_b32 a182, v252
		v_accvgpr_write_b32 a183, v253
		v_accvgpr_read_b32 v30, a159
		v_cmp_ge_i32_e64 s[50:51], v1, v30
		s_nop 1
		v_mov_b32_e32 v252, s50
		v_mov_b32_e32 v253, s51
		v_accvgpr_write_b32 a184, v252
		v_accvgpr_write_b32 a185, v253
		v_accvgpr_read_b32 v30, a160
		v_cmp_ge_i32_e64 s[50:51], v1, v30
		v_accvgpr_read_b32 v30, a137
		v_cmp_ge_i32_e64 s[90:91], v1, v30
		v_accvgpr_read_b32 v30, a161
		v_cmp_ge_i32_e64 s[92:93], v1, v30
		v_accvgpr_read_b32 v30, a162
		v_cmp_ge_i32_e64 s[94:95], v1, v30
		v_accvgpr_read_b32 v30, a139
		v_cmp_ge_i32_e64 s[96:97], v1, v30
		v_cndmask_b32_e32 v253, v6, v143, vcc
		v_cndmask_b32_e64 v255, v6, v141, s[94:95]
		v_cndmask_b32_e64 v252, v6, v142, s[96:97]
		v_accvgpr_read_b32 v30, a115
		v_add_u32_e32 v96, s41, v30
		v_accvgpr_read_b32 v30, a116
		v_add_u32_e32 v111, s41, v30
		v_cmp_ge_i32_e64 s[94:95], v1, v96
		v_cmp_ge_i32_e64 s[96:97], v1, v111
		v_accvgpr_read_b32 v30, a141
		v_cmp_ge_i32_e64 s[98:99], v1, v30
		v_cndmask_b32_e64 v142, v6, v144, s[94:95]
		v_cndmask_b32_e64 v143, v6, v145, s[96:97]
		v_cndmask_b32_e64 v144, v6, v146, s[98:99]
		v_accvgpr_read_b32 v30, a142
		v_cmp_ge_i32_e64 vcc, v1, v30
		v_accvgpr_read_b32 v30, a119
		v_add_u32_e32 v115, s41, v30
		v_accvgpr_read_b32 v30, a120
		v_add_u32_e32 v119, s41, v30
		v_cndmask_b32_e32 v145, v6, v147, vcc
		v_cmp_ge_i32_e64 s[94:95], v1, v115
		v_cmp_ge_i32_e64 s[96:97], v1, v119
		v_accvgpr_read_b32 v30, a143
		v_cmp_ge_i32_e64 s[98:99], v1, v30
		v_cndmask_b32_e64 v146, v6, v148, s[94:95]
		v_cndmask_b32_e64 v147, v6, v149, s[96:97]
		v_cndmask_b32_e64 v148, v6, v150, s[98:99]
		v_accvgpr_read_b32 v30, a144
		v_cmp_ge_i32_e64 vcc, v1, v30
		v_accvgpr_read_b32 v30, a123
		v_add_u32_e32 v123, s41, v30
		v_accvgpr_read_b32 v30, a124
		v_add_u32_e32 v127, s41, v30
		v_cndmask_b32_e32 v149, v6, v151, vcc
		v_cmp_ge_i32_e64 s[94:95], v1, v123
		v_cmp_ge_i32_e64 s[96:97], v1, v127
		v_accvgpr_read_b32 v30, a145
		v_cmp_ge_i32_e64 s[98:99], v1, v30
		v_cndmask_b32_e64 v150, v6, v152, s[94:95]
		v_cndmask_b32_e64 v151, v6, v153, s[96:97]
		v_cndmask_b32_e64 v152, v6, v154, s[98:99]
		v_accvgpr_read_b32 v30, a146
		v_cmp_ge_i32_e64 vcc, v1, v30
		v_accvgpr_read_b32 v30, a127
		v_add_u32_e32 v131, s41, v30
		v_accvgpr_read_b32 v30, a128
		v_add_u32_e32 v135, s41, v30
		v_cndmask_b32_e32 v153, v6, v155, vcc
		v_cmp_ge_i32_e64 s[94:95], v1, v131
		v_cmp_ge_i32_e64 s[96:97], v1, v135
		v_accvgpr_read_b32 v30, a147
		v_cmp_ge_i32_e64 s[98:99], v1, v30
		v_cndmask_b32_e64 v154, v6, v156, s[94:95]
		v_cndmask_b32_e64 v155, v6, v157, s[96:97]
		v_cndmask_b32_e64 v156, v6, v158, s[98:99]
		v_cndmask_b32_e64 v251, v6, v97, s[52:53]
		v_accvgpr_read_b32 v30, a148
		v_cmp_ge_i32_e64 vcc, v1, v30
		v_max3_f32 v97, v142, v143, v144
		v_max3_f32 v139, v146, v147, v148
		v_cndmask_b32_e32 v157, v6, v159, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v8
		v_cmp_ge_i32_e64 s[94:95], v3, v9
		v_cmp_ge_i32_e64 s[96:97], v3, v10
		v_max3_f32 v8, v150, v151, v152
		v_accvgpr_write_b32 a163, v8
		v_max3_f32 v8, v154, v155, v156
		v_accvgpr_write_b32 a186, v8
		v_cndmask_b32_e64 v8, v6, v178, s[96:97]
		v_cmp_ge_i32_e64 vcc, v3, v12
		v_cndmask_b32_e64 v30, v6, v98, s[54:55]
		v_cndmask_b32_e64 v158, v6, v100, s[56:57]
		v_cndmask_b32_e32 v9, v6, v179, vcc
		v_cmp_ge_i32_e64 s[54:55], v3, v224
		v_cmp_ge_i32_e64 s[56:57], v3, v225
		v_cmp_ge_i32_e64 s[96:97], v3, v14
		v_cndmask_b32_e64 v178, v6, v180, s[54:55]
		v_cndmask_b32_e64 v179, v6, v181, s[56:57]
		v_cndmask_b32_e64 v180, v6, v182, s[96:97]
		v_cmp_ge_i32_e64 vcc, v3, v16
		v_cndmask_b32_e64 v159, v6, v101, s[58:59]
		v_cndmask_b32_e64 v228, v6, v102, s[60:61]
		v_cndmask_b32_e64 v100, v6, v104, s[62:63]
		v_cndmask_b32_e32 v181, v6, v183, vcc
		v_cmp_ge_i32_e64 s[54:55], v3, v226
		v_cmp_ge_i32_e64 s[56:57], v3, v227
		v_cmp_ge_i32_e64 s[58:59], v3, v19
		v_cndmask_b32_e64 v182, v6, v184, s[54:55]
		v_cndmask_b32_e64 v183, v6, v185, s[56:57]
		v_cndmask_b32_e64 v184, v6, v186, s[58:59]
		v_cmp_ge_i32_e64 vcc, v3, v28
		v_cndmask_b32_e64 v101, v6, v105, s[64:65]
		v_max3_f32 v10, v250, v251, v30
		v_cndmask_b32_e32 v185, v6, v187, vcc
		v_cmp_ge_i32_e64 s[54:55], v3, v103
		v_cmp_ge_i32_e64 s[56:57], v3, v230
		v_cmp_ge_i32_e64 s[58:59], v3, v29
		v_cndmask_b32_e64 v28, v6, v188, s[54:55]
		v_cndmask_b32_e64 v29, v6, v189, s[56:57]
		v_cndmask_b32_e64 v102, v6, v190, s[58:59]
		v_cmp_ge_i32_e64 vcc, v3, v99
		v_cndmask_b32_e64 v232, v6, v106, s[66:67]
		v_cndmask_b32_e64 v98, v6, v108, s[68:69]
		v_cndmask_b32_e32 v103, v6, v191, vcc
		v_cmp_ge_i32_e64 s[54:55], v3, v107
		v_cmp_ge_i32_e64 s[56:57], v3, v231
		v_accvgpr_read_b32 v12, a57
		v_cmp_ge_i32_e64 s[58:59], v3, v12
		v_cndmask_b32_e64 v104, v6, v192, s[54:55]
		v_cndmask_b32_e64 v105, v6, v193, s[56:57]
		v_cndmask_b32_e64 v106, v6, v194, s[58:59]
		v_accvgpr_read_b32 v12, a63
		v_cmp_ge_i32_e64 vcc, v3, v12
		v_cndmask_b32_e64 v99, v6, v109, s[70:71]
		v_cndmask_b32_e64 v234, v6, v110, s[72:73]
		v_cndmask_b32_e64 v108, v6, v112, s[74:75]
		v_cndmask_b32_e32 v107, v6, v195, vcc
		v_accvgpr_read_b32 v12, a149
		v_cmp_ge_i32_e64 s[54:55], v3, v12
		v_accvgpr_read_b32 v12, a150
		v_cmp_ge_i32_e64 s[56:57], v3, v12
		v_accvgpr_read_b32 v12, a64
		v_cmp_ge_i32_e64 s[58:59], v3, v12
		v_cndmask_b32_e64 v186, v6, v196, s[54:55]
		v_cndmask_b32_e64 v187, v6, v197, s[56:57]
		v_cndmask_b32_e64 v188, v6, v198, s[58:59]
		v_accvgpr_read_b32 v12, a65
		v_cmp_ge_i32_e64 vcc, v3, v12
		v_cndmask_b32_e64 v109, v6, v113, s[76:77]
		v_max3_f32 v12, v158, v159, v228
		v_cndmask_b32_e32 v189, v6, v199, vcc
		v_accvgpr_read_b32 v14, a151
		v_cmp_ge_i32_e64 s[54:55], v3, v14
		v_accvgpr_read_b32 v14, a152
		v_cmp_ge_i32_e64 s[56:57], v3, v14
		v_accvgpr_read_b32 v14, a67
		v_cmp_ge_i32_e64 s[58:59], v3, v14
		v_cndmask_b32_e64 v112, v6, v200, s[54:55]
		v_cndmask_b32_e64 v113, v6, v201, s[56:57]
		v_cndmask_b32_e64 v190, v6, v202, s[58:59]
		v_accvgpr_read_b32 v14, a69
		v_cmp_ge_i32_e64 vcc, v3, v14
		v_cndmask_b32_e64 v236, v6, v114, s[78:79]
		v_cndmask_b32_e64 v192, v6, v116, s[80:81]
		v_cndmask_b32_e32 v191, v6, v203, vcc
		v_accvgpr_read_b32 v14, a153
		v_cmp_ge_i32_e64 s[54:55], v3, v14
		v_accvgpr_read_b32 v14, a154
		v_cmp_ge_i32_e64 s[56:57], v3, v14
		v_accvgpr_read_b32 v14, a131
		v_cmp_ge_i32_e64 s[58:59], v3, v14
		v_cndmask_b32_e64 v194, v6, v204, s[54:55]
		v_cndmask_b32_e64 v195, v6, v205, s[56:57]
		v_cndmask_b32_e64 v196, v6, v206, s[58:59]
		v_accvgpr_read_b32 v14, a132
		v_cmp_ge_i32_e64 vcc, v3, v14
		v_cndmask_b32_e64 v193, v6, v117, s[82:83]
		v_cndmask_b32_e64 v238, v6, v118, s[84:85]
		v_cndmask_b32_e32 v197, v6, v207, vcc
		v_accvgpr_read_b32 v14, a155
		v_cmp_ge_i32_e64 s[54:55], v3, v14
		v_accvgpr_read_b32 v14, a134
		v_cmp_ge_i32_e64 vcc, v3, v14
		v_cndmask_b32_e64 v116, v6, v120, s[86:87]
		v_accvgpr_read_b32 v14, a156
		v_cmp_ge_i32_e64 s[56:57], v3, v14
		v_accvgpr_read_b32 v14, a133
		v_cmp_ge_i32_e64 s[58:59], v3, v14
		v_cndmask_b32_e64 v198, v6, v208, s[54:55]
		v_cndmask_b32_e64 v199, v6, v209, s[56:57]
		v_cndmask_b32_e64 v200, v6, v210, s[58:59]
		v_cndmask_b32_e64 v117, v6, v121, s[88:89]
		v_cndmask_b32_e32 v201, v6, v211, vcc
		v_accvgpr_read_b32 v14, a157
		v_cmp_ge_i32_e64 s[54:55], v3, v14
		v_accvgpr_read_b32 v14, a158
		v_cmp_ge_i32_e64 s[56:57], v3, v14
		v_accvgpr_read_b32 v14, a135
		v_cmp_ge_i32_e64 s[58:59], v3, v14
		v_cndmask_b32_e64 v120, v6, v212, s[54:55]
		v_cndmask_b32_e64 v121, v6, v213, s[56:57]
		v_cndmask_b32_e64 v202, v6, v214, s[58:59]
		v_accvgpr_read_b32 v14, a136
		v_cmp_ge_i32_e64 vcc, v3, v14
		v_accvgpr_read_b32 v14, a164
		s_nop 0
		v_readfirstlane_b32 s54, v14
		v_accvgpr_read_b32 v14, a165
		s_nop 0
		v_readfirstlane_b32 s55, v14
		s_nop 1
		v_cndmask_b32_e64 v240, v6, v122, s[54:55]
		v_accvgpr_read_b32 v14, a166
		s_nop 0
		v_readfirstlane_b32 s54, v14
		v_accvgpr_read_b32 v14, a167
		s_nop 0
		v_readfirstlane_b32 s55, v14
		s_nop 1
		v_cndmask_b32_e64 v204, v6, v124, s[54:55]
		v_cndmask_b32_e32 v203, v6, v215, vcc
		v_accvgpr_read_b32 v14, a159
		v_cmp_ge_i32_e64 s[54:55], v3, v14
		v_accvgpr_read_b32 v14, a160
		v_cmp_ge_i32_e64 s[56:57], v3, v14
		v_accvgpr_read_b32 v14, a137
		v_cmp_ge_i32_e64 s[58:59], v3, v14
		v_cndmask_b32_e64 v206, v6, v216, s[54:55]
		v_cndmask_b32_e64 v207, v6, v217, s[56:57]
		v_cndmask_b32_e64 v208, v6, v218, s[58:59]
		v_accvgpr_read_b32 v14, a138
		v_cmp_ge_i32_e64 vcc, v3, v14
		v_accvgpr_read_b32 v14, a168
		s_nop 0
		v_readfirstlane_b32 s54, v14
		v_accvgpr_read_b32 v14, a169
		s_nop 0
		v_readfirstlane_b32 s55, v14
		s_nop 1
		v_cndmask_b32_e64 v205, v6, v125, s[54:55]
		v_accvgpr_read_b32 v14, a170
		s_nop 0
		v_readfirstlane_b32 s54, v14
		v_accvgpr_read_b32 v14, a171
		s_nop 0
		v_readfirstlane_b32 s55, v14
		s_nop 1
		v_cndmask_b32_e64 v242, v6, v126, s[54:55]
		v_cndmask_b32_e32 v209, v6, v219, vcc
		v_accvgpr_read_b32 v14, a161
		v_cmp_ge_i32_e64 s[54:55], v3, v14
		v_accvgpr_read_b32 v14, a162
		v_cmp_ge_i32_e64 s[56:57], v3, v14
		v_accvgpr_read_b32 v14, a139
		v_cmp_ge_i32_e64 s[58:59], v3, v14
		v_cndmask_b32_e64 v124, v6, v220, s[54:55]
		v_cndmask_b32_e64 v125, v6, v221, s[56:57]
		v_cndmask_b32_e64 v210, v6, v222, s[58:59]
		v_accvgpr_read_b32 v14, a140
		v_cmp_ge_i32_e64 vcc, v3, v14
		v_accvgpr_read_b32 v14, a172
		s_nop 0
		v_readfirstlane_b32 s54, v14
		v_accvgpr_read_b32 v14, a173
		s_nop 0
		v_readfirstlane_b32 s55, v14
		s_nop 1
		v_cndmask_b32_e64 v212, v6, v128, s[54:55]
		v_accvgpr_read_b32 v14, a174
		s_nop 0
		v_readfirstlane_b32 s54, v14
		v_accvgpr_read_b32 v14, a175
		s_nop 0
		v_readfirstlane_b32 s55, v14
		s_nop 1
		v_cndmask_b32_e64 v213, v6, v129, s[54:55]
		v_cndmask_b32_e32 v211, v6, v223, vcc
		v_cmp_ge_i32_e64 s[54:55], v3, v96
		v_cmp_ge_i32_e64 s[56:57], v3, v111
		v_accvgpr_read_b32 v14, a141
		v_cmp_ge_i32_e64 s[58:59], v3, v14
		v_cndmask_b32_e64 v110, v6, v160, s[54:55]
		v_cndmask_b32_e64 v111, v6, v161, s[56:57]
		v_cndmask_b32_e64 v128, v6, v162, s[58:59]
		v_accvgpr_read_b32 v14, a142
		v_cmp_ge_i32_e64 vcc, v3, v14
		v_accvgpr_read_b32 v14, a176
		s_nop 0
		v_readfirstlane_b32 s54, v14
		v_accvgpr_read_b32 v14, a177
		s_nop 0
		v_readfirstlane_b32 s55, v14
		s_nop 1
		v_cndmask_b32_e64 v244, v6, v130, s[54:55]
		v_accvgpr_read_b32 v14, a178
		s_nop 0
		v_readfirstlane_b32 s54, v14
		v_accvgpr_read_b32 v14, a179
		s_nop 0
		v_readfirstlane_b32 s55, v14
		s_nop 1
		v_cndmask_b32_e64 v160, v6, v132, s[54:55]
		v_cndmask_b32_e32 v129, v6, v163, vcc
		v_cmp_ge_i32_e64 s[54:55], v3, v115
		v_cmp_ge_i32_e64 s[56:57], v3, v119
		v_accvgpr_read_b32 v14, a143
		v_cmp_ge_i32_e64 s[58:59], v3, v14
		v_cndmask_b32_e64 v114, v6, v164, s[54:55]
		v_cndmask_b32_e64 v115, v6, v165, s[56:57]
		v_cndmask_b32_e64 v118, v6, v166, s[58:59]
		v_accvgpr_read_b32 v14, a144
		v_cmp_ge_i32_e64 vcc, v3, v14
		v_accvgpr_read_b32 v14, a180
		s_nop 0
		v_readfirstlane_b32 s54, v14
		v_accvgpr_read_b32 v14, a181
		s_nop 0
		v_readfirstlane_b32 s55, v14
		s_nop 1
		v_cndmask_b32_e64 v161, v6, v133, s[54:55]
		v_accvgpr_read_b32 v14, a182
		s_nop 0
		v_readfirstlane_b32 s54, v14
		v_accvgpr_read_b32 v14, a183
		s_nop 0
		v_readfirstlane_b32 s55, v14
		s_nop 1
		v_cndmask_b32_e64 v246, v6, v134, s[54:55]
		v_cndmask_b32_e32 v119, v6, v167, vcc
		v_cmp_ge_i32_e64 s[54:55], v3, v123
		v_cmp_ge_i32_e64 s[56:57], v3, v127
		v_accvgpr_read_b32 v14, a145
		v_cmp_ge_i32_e64 s[58:59], v3, v14
		v_cndmask_b32_e64 v122, v6, v168, s[54:55]
		v_cndmask_b32_e64 v123, v6, v169, s[56:57]
		v_cndmask_b32_e64 v126, v6, v170, s[58:59]
		v_accvgpr_read_b32 v14, a146
		v_cmp_ge_i32_e64 vcc, v3, v14
		v_accvgpr_read_b32 v14, a184
		s_nop 0
		v_readfirstlane_b32 s54, v14
		v_accvgpr_read_b32 v14, a185
		s_nop 0
		v_readfirstlane_b32 s55, v14
		s_nop 1
		v_cndmask_b32_e64 v132, v6, v136, s[54:55]
		v_cndmask_b32_e64 v133, v6, v137, s[50:51]
		v_cndmask_b32_e32 v127, v6, v171, vcc
		v_cmp_ge_i32_e64 s[50:51], v3, v131
		v_cmp_ge_i32_e64 s[54:55], v3, v135
		v_accvgpr_read_b32 v14, a147
		v_cmp_ge_i32_e64 s[56:57], v3, v14
		v_cndmask_b32_e64 v130, v6, v172, s[50:51]
		v_cndmask_b32_e64 v131, v6, v173, s[54:55]
		v_cndmask_b32_e64 v134, v6, v174, s[56:57]
		v_accvgpr_read_b32 v14, a148
		v_cmp_ge_i32_e64 vcc, v3, v14
		v_cndmask_b32_e64 v248, v6, v138, s[90:91]
		v_cndmask_b32_e64 v254, v6, v140, s[92:93]
		v_cndmask_b32_e32 v135, v6, v175, vcc
		v_max3_f32 v14, v100, v101, v232
		v_max3_f32 v16, v98, v99, v234
		v_max3_f32 v19, v108, v109, v236
		v_max3_f32 v96, v192, v193, v238
		v_max3_f32 v136, v116, v117, v240
		v_max3_f32 v137, v204, v205, v242
		v_max3_f32 v138, v212, v213, v244
		v_max3_f32 v140, v160, v161, v246
		v_max3_f32 v141, v132, v133, v248
		v_max3_f32 v162, v254, v255, v252
		v_max3_f32 v10, v10, v31, v12
		v_max3_f32 v12, v14, v233, v16
		v_max3_f32 v14, v19, v237, v96
		v_max3_f32 v16, v136, v241, v137
		v_max3_f32 v19, v138, v245, v140
		v_max3_f32 v96, v141, v249, v162
		v_max3_f32 v97, v97, v145, v139
		v_accvgpr_read_b32 v136, a163
		v_accvgpr_read_b32 v137, a186
		v_max3_f32 v136, v136, v153, v137
		v_max3_f32 v10, v10, v229, v12
		v_max3_f32 v12, v14, v239, v16
		v_max3_f32 v14, v19, v247, v96
		v_max3_f32 v16, v97, v149, v136
		v_max3_f32 v10, v10, v235, v12
		v_max3_f32 v12, v14, v253, v16
		v_max3_f32 v10, v10, v243, v12
		v_max_f32_e32 v96, v10, v157
		v_mov_b32_e32 v97, v96
		v_cndmask_b32_e64 v136, v6, v176, s[52:53]
		v_cndmask_b32_e64 v137, v6, v177, s[94:95]
		v_permlane32_swap_b32_e32 v96, v97
		v_max3_f32 v10, v136, v137, v8
		v_max3_f32 v12, v178, v179, v180
		v_max3_f32 v14, v182, v183, v184
		v_max3_f32 v16, v28, v29, v102
		v_max3_f32 v19, v104, v105, v106
		v_max3_f32 v138, v186, v187, v188
		v_max3_f32 v139, v112, v113, v190
		v_max3_f32 v140, v194, v195, v196
		v_max3_f32 v141, v198, v199, v200
		v_max3_f32 v162, v120, v121, v202
		v_max3_f32 v163, v206, v207, v208
		v_max3_f32 v164, v124, v125, v210
		v_max3_f32 v165, v110, v111, v128
		v_max3_f32 v166, v114, v115, v118
		v_max3_f32 v167, v122, v123, v126
		v_max3_f32 v168, v130, v131, v134
		v_max3_f32 v10, v10, v9, v12
		v_max3_f32 v12, v14, v185, v16
		v_max3_f32 v14, v19, v107, v138
		v_max3_f32 v16, v139, v191, v140
		v_max3_f32 v19, v141, v201, v162
		v_max3_f32 v138, v163, v209, v164
		v_max3_f32 v139, v165, v129, v166
		v_max3_f32 v140, v167, v127, v168
		v_max3_f32 v10, v10, v181, v12
		v_max3_f32 v12, v14, v189, v16
		v_max3_f32 v14, v19, v203, v138
		v_max3_f32 v16, v139, v119, v140
		v_max3_f32 v10, v10, v103, v12
		v_max3_f32 v12, v14, v211, v16
		v_max3_f32 v10, v10, v197, v12
		v_max_f32_e32 v138, v10, v135
		v_mov_b32_e32 v139, v138
		v_max_f32_e32 v140, v96, v97
		v_mov_b32_e32 v96, v4
		v_permlane32_swap_b32_e32 v138, v139
		v_max_f32_e32 v141, v138, v139
		v_pk_mul_f32 v[138:139], v[140:141], v[24:25]
		v_max_f32_e32 v140, v4, v138
		v_max_f32_e32 v141, v7, v139
		v_pk_fma_f32 v[138:139], v[250:251], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[30:31], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[158:159], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[228:229], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[100:101], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[232:233], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[98:99], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[234:235], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[108:109], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[236:237], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[192:193], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[238:239], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[116:117], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[240:241], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[204:205], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[242:243], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[212:213], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[244:245], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[160:161], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[246:247], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[132:133], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[248:249], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[218:219], v[254:255], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[220:221], v[252:253], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[222:223], v[142:143], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[144:145], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[146:147], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[148:149], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[150:151], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[154:155], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[156:157], v[24:25], v[140:141] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[136:137], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[8:9], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[8:9], v[178:179], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[180:181], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[182:183], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[184:185], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[28:29], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[102:103], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[186:187], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[188:189], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[112:113], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[190:191], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[194:195], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[196:197], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[198:199], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[200:201], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[120:121], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[202:203], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[206:207], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[208:209], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[124:125], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[210:211], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[110:111], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[128:129], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[114:115], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[118:119], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[122:123], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[126:127], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[130:131], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[134:135], v[24:25], v[140:141] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v134, v138
		v_exp_f32_e32 v224, v139
		v_exp_f32_e32 v138, v162
		v_exp_f32_e32 v226, v163
		v_exp_f32_e32 v162, v30
		v_exp_f32_e32 v228, v31
		v_exp_f32_e32 v30, v158
		v_exp_f32_e32 v230, v159
		v_exp_f32_e32 v158, v164
		v_exp_f32_e32 v232, v165
		v_exp_f32_e32 v164, v100
		v_exp_f32_e32 v234, v101
		v_exp_f32_e32 v100, v166
		v_exp_f32_e32 v236, v167
		v_exp_f32_e32 v166, v98
		v_exp_f32_e32 v238, v99
		v_exp_f32_e32 v98, v168
		v_exp_f32_e32 v240, v169
		v_exp_f32_e32 v168, v108
		v_exp_f32_e32 v242, v109
		v_exp_f32_e32 v108, v170
		v_exp_f32_e32 v244, v171
		v_exp_f32_e32 v170, v172
		v_exp_f32_e32 v246, v173
		v_exp_f32_e32 v172, v174
		v_exp_f32_e32 v248, v175
		v_exp_f32_e32 v174, v116
		v_exp_f32_e32 v250, v117
		v_exp_f32_e32 v116, v176
		v_exp_f32_e32 v252, v177
		v_exp_f32_e32 v176, v192
		v_exp_f32_e32 v254, v193
		v_exp_f32_e32 v135, v204
		v_exp_f32_e32 v225, v205
		v_exp_f32_e32 v139, v212
		v_exp_f32_e32 v227, v213
		v_exp_f32_e32 v163, v214
		v_exp_f32_e32 v229, v215
		v_exp_f32_e32 v31, v160
		v_exp_f32_e32 v231, v161
		v_exp_f32_e32 v159, v216
		v_exp_f32_e32 v233, v217
		v_exp_f32_e32 v165, v132
		v_exp_f32_e32 v235, v133
		v_exp_f32_e32 v101, v218
		v_exp_f32_e32 v237, v219
		v_exp_f32_e32 v167, v220
		v_exp_f32_e32 v239, v221
		v_exp_f32_e32 v99, v222
		v_exp_f32_e32 v241, v223
		v_exp_f32_e32 v169, v142
		v_exp_f32_e32 v243, v143
		v_exp_f32_e32 v109, v144
		v_exp_f32_e32 v245, v145
		v_exp_f32_e32 v171, v146
		v_exp_f32_e32 v247, v147
		v_exp_f32_e32 v173, v148
		v_exp_f32_e32 v249, v149
		v_exp_f32_e32 v175, v150
		v_exp_f32_e32 v251, v151
		v_exp_f32_e32 v117, v152
		v_exp_f32_e32 v253, v153
		v_exp_f32_e32 v177, v154
		v_exp_f32_e32 v255, v155
		v_exp_f32_e32 v132, v156
		v_exp_f32_e32 v142, v157
		v_exp_f32_e32 v144, v136
		v_exp_f32_e32 v146, v137
		v_exp_f32_e32 v136, v8
		v_exp_f32_e32 v148, v9
		v_exp_f32_e32 v8, v178
		v_exp_f32_e32 v150, v179
		v_exp_f32_e32 v152, v180
		v_exp_f32_e32 v154, v181
		v_exp_f32_e32 v156, v182
		v_exp_f32_e32 v160, v183
		v_exp_f32_e32 v178, v184
		v_exp_f32_e32 v180, v185
		v_exp_f32_e32 v182, v28
		v_exp_f32_e32 v184, v29
		v_exp_f32_e32 v28, v102
		v_exp_f32_e32 v192, v103
		v_exp_f32_e32 v102, v104
		v_exp_f32_e32 v204, v105
		v_exp_f32_e32 v104, v106
		v_exp_f32_e32 v212, v107
		v_exp_f32_e32 v106, v186
		v_exp_f32_e32 v214, v187
		v_exp_f32_e32 v186, v188
		v_exp_f32_e32 v216, v189
		v_exp_f32_e32 v188, v112
		v_exp_f32_e32 v218, v113
		v_exp_f32_e32 v112, v190
		v_exp_f32_e32 v220, v191
		v_exp_f32_e32 v190, v194
		v_exp_f32_e32 v222, v195
		v_exp_f32_e32 v133, v196
		v_exp_f32_e32 v143, v197
		v_exp_f32_e32 v145, v198
		v_exp_f32_e32 v147, v199
		v_exp_f32_e32 v137, v200
		v_exp_f32_e32 v149, v201
		v_exp_f32_e32 v9, v120
		v_exp_f32_e32 v151, v121
		v_exp_f32_e32 v153, v202
		v_exp_f32_e32 v155, v203
		v_exp_f32_e32 v157, v206
		v_exp_f32_e32 v161, v207
		v_exp_f32_e32 v179, v208
		v_exp_f32_e32 v181, v209
		v_exp_f32_e32 v183, v124
		v_exp_f32_e32 v185, v125
		v_exp_f32_e32 v29, v210
		v_exp_f32_e32 v193, v211
		v_exp_f32_e32 v103, v110
		v_exp_f32_e32 v205, v111
		v_exp_f32_e32 v105, v128
		v_exp_f32_e32 v213, v129
		v_exp_f32_e32 v107, v114
		v_exp_f32_e32 v215, v115
		v_exp_f32_e32 v187, v118
		v_exp_f32_e32 v217, v119
		v_exp_f32_e32 v189, v122
		v_exp_f32_e32 v219, v123
		v_exp_f32_e32 v113, v126
		v_exp_f32_e32 v221, v127
		v_exp_f32_e32 v191, v130
		v_exp_f32_e32 v223, v131
		v_pk_add_f32 v[110:111], v[134:135], v[224:225]
		v_pk_add_f32 v[114:115], v[138:139], v[226:227]
		v_pk_add_f32 v[118:119], v[162:163], v[228:229]
		v_pk_add_f32 v[120:121], v[30:31], v[230:231]
		v_pk_add_f32 v[122:123], v[158:159], v[232:233]
		v_pk_add_f32 v[124:125], v[164:165], v[234:235]
		v_pk_add_f32 v[126:127], v[100:101], v[236:237]
		v_pk_add_f32 v[128:129], v[166:167], v[238:239]
		v_pk_add_f32 v[130:131], v[98:99], v[240:241]
		v_pk_add_f32 v[194:195], v[168:169], v[242:243]
		v_pk_add_f32 v[196:197], v[108:109], v[244:245]
		v_pk_add_f32 v[198:199], v[170:171], v[246:247]
		v_pk_add_f32 v[200:201], v[172:173], v[248:249]
		v_pk_add_f32 v[202:203], v[174:175], v[250:251]
		v_pk_add_f32 v[206:207], v[116:117], v[252:253]
		v_pk_add_f32 v[208:209], v[176:177], v[254:255]
		v_pk_add_f32 v[110:111], v[110:111], v[114:115]
		v_pk_add_f32 v[114:115], v[118:119], v[120:121]
		v_pk_add_f32 v[118:119], v[122:123], v[124:125]
		v_pk_add_f32 v[120:121], v[126:127], v[128:129]
		v_pk_add_f32 v[122:123], v[130:131], v[194:195]
		v_pk_add_f32 v[124:125], v[196:197], v[198:199]
		v_pk_add_f32 v[126:127], v[200:201], v[202:203]
		v_pk_add_f32 v[128:129], v[206:207], v[208:209]
		v_pk_add_f32 v[110:111], v[110:111], v[114:115]
		v_pk_add_f32 v[114:115], v[118:119], v[120:121]
		v_pk_add_f32 v[118:119], v[122:123], v[124:125]
		v_pk_add_f32 v[120:121], v[126:127], v[128:129]
		v_pk_add_f32 v[110:111], v[110:111], v[114:115]
		v_pk_add_f32 v[114:115], v[118:119], v[120:121]
		v_pk_add_f32 v[118:119], v[110:111], v[114:115]
		v_add_f32_e32 v4, v118, v119
		v_accvgpr_read_b32 v10, a70
		ds_bpermute_b32 v110, v10, v4
		v_accvgpr_read_b32 v10, a71
		ds_bpermute_b32 v114, v10, v4
		v_pk_add_f32 v[118:119], v[132:133], v[142:143]
		v_pk_add_f32 v[120:121], v[144:145], v[146:147]
		v_pk_add_f32 v[122:123], v[136:137], v[148:149]
		v_pk_add_f32 v[124:125], v[8:9], v[150:151]
		v_pk_add_f32 v[126:127], v[152:153], v[154:155]
		v_pk_add_f32 v[128:129], v[156:157], v[160:161]
		v_pk_add_f32 v[130:131], v[178:179], v[180:181]
		v_pk_add_f32 v[194:195], v[182:183], v[184:185]
		v_pk_add_f32 v[196:197], v[28:29], v[192:193]
		v_pk_add_f32 v[198:199], v[102:103], v[204:205]
		v_pk_add_f32 v[200:201], v[104:105], v[212:213]
		v_pk_add_f32 v[202:203], v[106:107], v[214:215]
		v_pk_add_f32 v[206:207], v[186:187], v[216:217]
		v_pk_add_f32 v[208:209], v[188:189], v[218:219]
		v_pk_add_f32 v[210:211], v[112:113], v[220:221]
		v_accvgpr_write_b32 a64, v210
		v_accvgpr_write_b32 a65, v211
		v_pk_add_f32 v[210:211], v[190:191], v[222:223]
		v_pk_add_f32 v[118:119], v[118:119], v[120:121]
		v_pk_add_f32 v[120:121], v[122:123], v[124:125]
		v_pk_add_f32 v[122:123], v[126:127], v[128:129]
		v_pk_add_f32 v[124:125], v[130:131], v[194:195]
		v_pk_add_f32 v[126:127], v[196:197], v[198:199]
		v_pk_add_f32 v[128:129], v[200:201], v[202:203]
		v_pk_add_f32 v[130:131], v[206:207], v[208:209]
		v_accvgpr_read_b32 v194, a64
		v_accvgpr_read_b32 v195, a65
		v_pk_add_f32 v[194:195], v[194:195], v[210:211]
		v_pk_add_f32 v[118:119], v[118:119], v[120:121]
		v_pk_add_f32 v[120:121], v[122:123], v[124:125]
		v_pk_add_f32 v[122:123], v[126:127], v[128:129]
		v_pk_add_f32 v[124:125], v[130:131], v[194:195]
		v_pk_add_f32 v[118:119], v[118:119], v[120:121]
		v_pk_add_f32 v[120:121], v[122:123], v[124:125]
		v_pk_add_f32 v[122:123], v[118:119], v[120:121]
		v_mov_b32_e32 v115, v123
		v_mov_b32_e32 v111, v122
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[118:119], v[110:111], v[114:115]
		v_mov_b32_e32 v110, v119
		v_mov_b32_e32 v111, v119
		v_cvt_pk_bf16_f32 v120, v134, v224
		v_cvt_pk_bf16_f32 v121, v138, v226
		v_permlane32_swap_b32_e32 v110, v111
		v_add_f32_e32 v115, v110, v111
		v_mov_b32_e32 v97, v7
		v_pk_add_f32 v[110:111], v[96:97], v[140:141] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v96, v110
		v_exp_f32_e32 v97, v111
		v_cvt_pk_bf16_f32 v122, v162, v228
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
		v_mov_b32_e32 v114, v118
		v_mov_b64_e32 v[110:111], v[26:27]
		v_pk_fma_f32 v[26:27], v[110:111], v[96:97], v[114:115]
		v_cvt_pk_bf16_f32 v123, v30, v230
		v_cvt_pk_bf16_f32 v124, v158, v232
		v_cvt_pk_bf16_f32 v125, v164, v234
		v_cvt_pk_bf16_f32 v126, v100, v236
		v_cvt_pk_bf16_f32 v127, v166, v238
		v_cvt_pk_bf16_f32 v128, v98, v240
		v_cvt_pk_bf16_f32 v129, v168, v242
		v_cvt_pk_bf16_f32 v130, v108, v244
		v_cvt_pk_bf16_f32 v131, v170, v246
		v_cvt_pk_bf16_f32 v196, v172, v248
		v_cvt_pk_bf16_f32 v197, v174, v250
		v_cvt_pk_bf16_f32 v198, v116, v252
		v_cvt_pk_bf16_f32 v199, v176, v254
		v_cvt_pk_bf16_f32 v200, v135, v225
		v_cvt_pk_bf16_f32 v201, v139, v227
		v_cvt_pk_bf16_f32 v202, v163, v229
		v_cvt_pk_bf16_f32 v203, v31, v231
		v_cvt_pk_bf16_f32 v208, v159, v233
		v_cvt_pk_bf16_f32 v209, v165, v235
		v_cvt_pk_bf16_f32 v210, v101, v237
		v_cvt_pk_bf16_f32 v211, v167, v239
		v_cvt_pk_bf16_f32 v164, v99, v241
		v_cvt_pk_bf16_f32 v165, v169, v243
		v_cvt_pk_bf16_f32 v166, v109, v245
		v_cvt_pk_bf16_f32 v167, v171, v247
		v_cvt_pk_bf16_f32 v96, v173, v249
		v_cvt_pk_bf16_f32 v97, v175, v251
		v_cvt_pk_bf16_f32 v98, v117, v253
		v_cvt_pk_bf16_f32 v99, v177, v255
		v_cvt_pk_bf16_f32 v108, v132, v142
		v_cvt_pk_bf16_f32 v109, v144, v146
		v_cvt_pk_bf16_f32 v110, v136, v148
		v_cvt_pk_bf16_f32 v111, v8, v150
		v_cvt_pk_bf16_f32 v116, v152, v154
		v_cvt_pk_bf16_f32 v117, v156, v160
		v_cvt_pk_bf16_f32 v118, v178, v180
		v_cvt_pk_bf16_f32 v119, v182, v184
		v_cvt_pk_bf16_f32 v168, v28, v192
		v_cvt_pk_bf16_f32 v169, v102, v204
		v_cvt_pk_bf16_f32 v170, v104, v212
		v_cvt_pk_bf16_f32 v171, v106, v214
		v_cvt_pk_bf16_f32 v172, v186, v216
		v_cvt_pk_bf16_f32 v173, v188, v218
		v_cvt_pk_bf16_f32 v174, v112, v220
		v_cvt_pk_bf16_f32 v175, v190, v222
		v_cvt_pk_bf16_f32 v224, v133, v143
		v_cvt_pk_bf16_f32 v225, v145, v147
		v_cvt_pk_bf16_f32 v226, v137, v149
		v_cvt_pk_bf16_f32 v227, v9, v151
		v_cvt_pk_bf16_f32 v132, v153, v155
		v_cvt_pk_bf16_f32 v133, v157, v161
		v_cvt_pk_bf16_f32 v134, v179, v181
		v_cvt_pk_bf16_f32 v135, v183, v185
		v_cvt_pk_bf16_f32 v136, v29, v193
		v_cvt_pk_bf16_f32 v137, v103, v205
		v_cvt_pk_bf16_f32 v138, v105, v213
		v_cvt_pk_bf16_f32 v139, v107, v215
		v_cvt_pk_bf16_f32 v28, v187, v217
		v_cvt_pk_bf16_f32 v29, v189, v219
		v_cvt_pk_bf16_f32 v30, v113, v221
		v_cvt_pk_bf16_f32 v31, v191, v223
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[120:123], v[32:47]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[120:123], v[48:63]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[124:127], v[32:47]
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[124:127], v[48:63]
		v_permlane32_swap_b32_e32 v208, v210
		v_permlane32_swap_b32_e32 v209, v211
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[128:131], v[32:47]
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[128:131], v[48:63]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[196:199], v[32:47]
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[196:199], v[48:63]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[108:111], v[80:95]
		v_permlane32_swap_b32_e32 v168, v170
		v_permlane32_swap_b32_e32 v169, v171
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[108:111], v[64:79]
		v_permlane32_swap_b32_e32 v172, v174
		v_permlane32_swap_b32_e32 v173, v175
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[116:119], v[80:95]
		v_permlane32_swap_b32_e32 v224, v226
		v_permlane32_swap_b32_e32 v225, v227
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[116:119], v[64:79]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[168:171], v[80:95]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[168:171], v[64:79]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[172:175], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[172:175], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[200:203], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[200:203], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[224:227], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[224:227], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[208:211], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[208:211], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[132:135], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[132:135], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[216:219], v[164:167], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[248:251], v[164:167], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[248:251], v[136:139], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[216:219], v[136:139], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[220:223], v[96:99], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[252:255], v[96:99], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[252:255], v[28:31], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[220:223], v[28:31], v[64:79]
		s_cselect_b32 s1, 1, 0
		s_add_i32 s25, s41, 0x80
		s_cmp_lg_u32 s1, 0
		s_mov_b32 s41, s25
		v_mov_b32_e32 v4, v140
		v_mov_b32_e32 v7, v141
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_4
.L_attn_fwd_persistent.loop_exit_4:
		s_mov_b32 s24, s8
		s_mov_b32 s25, s9
		s_mov_b32 s26, s42
		s_mov_b32 s27, s43
		v_rcp_f32_e32 v2, v26
		v_accvgpr_read_b32 v1, a4
		s_nop 0
		v_readfirstlane_b32 s1, v1
		v_accvgpr_read_b32 v1, a12
		s_nop 0
		v_readfirstlane_b32 s18, v1
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
		v_pk_mul_f32 v[24:25], v[50:51], v[2:3]
		v_pk_mul_f32 v[28:29], v[52:53], v[2:3]
		v_pk_mul_f32 v[30:31], v[54:55], v[2:3]
		v_pk_mul_f32 v[32:33], v[56:57], v[2:3]
		v_pk_mul_f32 v[34:35], v[58:59], v[2:3]
		v_pk_mul_f32 v[36:37], v[60:61], v[2:3]
		v_pk_mul_f32 v[38:39], v[62:63], v[2:3]
		v_rcp_f32_e32 v2, v27
		v_cvt_pk_bf16_f32 v40, v4, v5
		v_mov_b32_e32 v3, v2
		v_pk_mul_f32 v[4:5], v[64:65], v[2:3]
		v_pk_mul_f32 v[26:27], v[66:67], v[2:3]
		v_pk_mul_f32 v[44:45], v[68:69], v[2:3]
		v_pk_mul_f32 v[46:47], v[70:71], v[2:3]
		v_pk_mul_f32 v[48:49], v[72:73], v[2:3]
		v_pk_mul_f32 v[50:51], v[74:75], v[2:3]
		v_pk_mul_f32 v[52:53], v[76:77], v[2:3]
		v_pk_mul_f32 v[54:55], v[78:79], v[2:3]
		v_pk_mul_f32 v[56:57], v[80:81], v[2:3]
		v_pk_mul_f32 v[58:59], v[82:83], v[2:3]
		v_pk_mul_f32 v[60:61], v[84:85], v[2:3]
		v_pk_mul_f32 v[62:63], v[86:87], v[2:3]
		v_pk_mul_f32 v[64:65], v[88:89], v[2:3]
		v_pk_mul_f32 v[66:67], v[90:91], v[2:3]
		v_pk_mul_f32 v[68:69], v[92:93], v[2:3]
		v_pk_mul_f32 v[70:71], v[94:95], v[2:3]
		v_cvt_pk_bf16_f32 v41, v6, v7
		v_cvt_pk_bf16_f32 v42, v8, v9
		v_cvt_pk_bf16_f32 v43, v10, v11
		v_cvt_pk_bf16_f32 v8, v12, v13
		v_cvt_pk_bf16_f32 v9, v14, v15
		v_cvt_pk_bf16_f32 v10, v16, v17
		v_cvt_pk_bf16_f32 v11, v18, v19
		v_cvt_pk_bf16_f32 v12, v20, v21
		v_cvt_pk_bf16_f32 v13, v24, v25
		v_cvt_pk_bf16_f32 v14, v28, v29
		v_cvt_pk_bf16_f32 v15, v30, v31
		v_cvt_pk_bf16_f32 v16, v32, v33
		v_cvt_pk_bf16_f32 v17, v34, v35
		v_cvt_pk_bf16_f32 v18, v36, v37
		v_cvt_pk_bf16_f32 v19, v38, v39
		v_cvt_pk_bf16_f32 v28, v4, v5
		v_cvt_pk_bf16_f32 v29, v26, v27
		v_cvt_pk_bf16_f32 v30, v44, v45
		v_cvt_pk_bf16_f32 v31, v46, v47
		v_cvt_pk_bf16_f32 v4, v48, v49
		v_cvt_pk_bf16_f32 v5, v50, v51
		v_cvt_pk_bf16_f32 v6, v52, v53
		v_cvt_pk_bf16_f32 v7, v54, v55
		v_cvt_pk_bf16_f32 v24, v56, v57
		v_cvt_pk_bf16_f32 v25, v58, v59
		v_cvt_pk_bf16_f32 v26, v60, v61
		v_cvt_pk_bf16_f32 v27, v62, v63
		v_cvt_pk_bf16_f32 v32, v64, v65
		v_cvt_pk_bf16_f32 v33, v66, v67
		v_cvt_pk_bf16_f32 v34, v68, v69
		v_cvt_pk_bf16_f32 v35, v70, v71
		v_permlane32_swap_b32_e32 v40, v42
		v_permlane32_swap_b32_e32 v41, v43
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
		v_permlane32_swap_b32_e32 v12, v14
		v_permlane32_swap_b32_e32 v13, v15
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_permlane32_swap_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v5, v7
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_permlane32_swap_b32_e32 v32, v34
		v_permlane32_swap_b32_e32 v33, v35
		s_lshl_b32 s1, s1, 9
		v_accvgpr_read_b32 v1, a2
		s_nop 0
		v_readfirstlane_b32 s18, v1
		v_accvgpr_read_b32 v1, a16
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
		v_accvgpr_read_b32 v1, a13
		s_nop 0
		v_readfirstlane_b32 s28, v1
		s_mul_i32 s23, s23, s28
		s_lshl_b32 s23, s23, 6
		s_add_i32 s21, s21, s23
		v_and_b32_e32 v1, 31, v0
		v_accvgpr_read_b32 v2, a4
		s_nop 0
		v_readfirstlane_b32 s28, v2
		s_nop 1
		v_mul_lo_u32 v1, s28, v1
		v_lshl_add_u32 v2, v1, 1, s21
		v_accvgpr_read_b32 v3, a17
		v_lshl_add_u32 v2, v3, 4, v2
		v_readfirstlane_b32 s28, v22
		v_readfirstlane_b32 s29, v23
		s_and_saveexec_b64 s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_24
		buffer_store_dwordx4 v[40:43], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_24:
		s_andn2_b64 exec, s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_24
.L_attn_fwd_persistent.exec_endif_24:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s21, s1, 32
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		s_add_i32 s21, s21, s23
		v_lshl_add_u32 v2, v1, 1, s21
		v_accvgpr_read_b32 v3, a17
		v_lshl_add_u32 v2, v3, 4, v2
		v_readfirstlane_b32 s28, v22
		v_readfirstlane_b32 s29, v23
		s_and_saveexec_b64 s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_25
		buffer_store_dwordx4 v[8:11], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_25:
		s_andn2_b64 exec, s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_25
.L_attn_fwd_persistent.exec_endif_25:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s21, s1, 64
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		s_add_i32 s21, s21, s23
		v_lshl_add_u32 v2, v1, 1, s21
		v_accvgpr_read_b32 v3, a17
		v_lshl_add_u32 v2, v3, 4, v2
		v_readfirstlane_b32 s28, v22
		v_readfirstlane_b32 s29, v23
		s_and_saveexec_b64 s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_26
		buffer_store_dwordx4 v[12:15], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_26:
		s_andn2_b64 exec, s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_26
.L_attn_fwd_persistent.exec_endif_26:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s21, s1, 0x60
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		s_add_i32 s21, s21, s23
		v_lshl_add_u32 v2, v1, 1, s21
		v_accvgpr_read_b32 v3, a17
		v_lshl_add_u32 v2, v3, 4, v2
		v_readfirstlane_b32 s28, v22
		v_readfirstlane_b32 s29, v23
		s_and_saveexec_b64 s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_27
		buffer_store_dwordx4 v[16:19], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_27:
		s_andn2_b64 exec, s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_27
.L_attn_fwd_persistent.exec_endif_27:
		s_mov_b64 exec, s[100:101]
		v_accvgpr_read_b32 v2, a4
		s_nop 0
		v_readfirstlane_b32 s21, v2
		s_lshl_b32 s21, s21, 8
		s_add_i32 s28, s21, s1
		s_add_i32 s28, s28, s18
		s_add_i32 s28, s28, s22
		s_add_i32 s28, s28, s23
		v_lshl_add_u32 v2, v1, 1, s28
		v_accvgpr_read_b32 v3, a17
		v_lshl_add_u32 v2, v3, 4, v2
		v_accvgpr_read_b32 v3, a54
		s_nop 0
		v_readfirstlane_b32 s28, v3
		v_accvgpr_read_b32 v3, a55
		s_nop 0
		v_readfirstlane_b32 s29, v3
		s_and_saveexec_b64 s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_28
		buffer_store_dwordx4 v[28:31], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_28:
		s_andn2_b64 exec, s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_28
.L_attn_fwd_persistent.exec_endif_28:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s28, s21, 32
		s_add_i32 s28, s28, s1
		s_add_i32 s28, s28, s18
		s_add_i32 s28, s28, s22
		s_add_i32 s28, s28, s23
		v_lshl_add_u32 v2, v1, 1, s28
		v_accvgpr_read_b32 v3, a17
		v_lshl_add_u32 v2, v3, 4, v2
		v_accvgpr_read_b32 v3, a54
		s_nop 0
		v_readfirstlane_b32 s28, v3
		v_accvgpr_read_b32 v3, a55
		s_nop 0
		v_readfirstlane_b32 s29, v3
		s_and_saveexec_b64 s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_29
		buffer_store_dwordx4 v[4:7], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_29:
		s_andn2_b64 exec, s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_29
.L_attn_fwd_persistent.exec_endif_29:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s28, s21, 64
		s_add_i32 s28, s28, s1
		s_add_i32 s28, s28, s18
		s_add_i32 s28, s28, s22
		s_add_i32 s28, s28, s23
		v_lshl_add_u32 v2, v1, 1, s28
		v_accvgpr_read_b32 v3, a17
		v_lshl_add_u32 v2, v3, 4, v2
		v_accvgpr_read_b32 v3, a54
		s_nop 0
		v_readfirstlane_b32 s28, v3
		v_accvgpr_read_b32 v3, a55
		s_nop 0
		v_readfirstlane_b32 s29, v3
		s_and_saveexec_b64 s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_30
		buffer_store_dwordx4 v[24:27], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_30:
		s_andn2_b64 exec, s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_30
.L_attn_fwd_persistent.exec_endif_30:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s21, s21, 0x60
		s_add_i32 s1, s21, s1
		s_add_i32 s1, s1, s18
		s_add_i32 s1, s1, s22
		s_add_i32 s1, s1, s23
		v_lshl_add_u32 v1, v1, 1, s1
		v_accvgpr_read_b32 v2, a17
		v_lshl_add_u32 v1, v2, 4, v1
		v_accvgpr_read_b32 v2, a54
		s_nop 0
		v_readfirstlane_b32 s22, v2
		v_accvgpr_read_b32 v2, a55
		s_nop 0
		v_readfirstlane_b32 s23, v2
		s_and_saveexec_b64 s[100:101], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_31
		buffer_store_dwordx4 v[32:35], v1, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_31:
		s_andn2_b64 exec, s[100:101], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_31
.L_attn_fwd_persistent.exec_endif_31:
		s_mov_b64 exec, s[100:101]
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
    .vgpr_count:     512
    .agpr_count:     256
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 439
    wave.regalloc.agpr.dwords: 821
    wave.regalloc.remat.dwords: 7
    wave.regalloc.sgpr_to_vgpr.dwords: 68
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
