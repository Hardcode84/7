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
		s_add_i32 s25, s24, 1
		s_sub_i32 s26, s1, s23
		s_cmp_ge_u32 s1, s23
		s_cselect_b32 s24, s25, s24
		s_cselect_b32 s1, s26, s1
		s_add_i32 s25, s24, 1
		s_cmp_ge_u32 s1, s23
		s_cselect_b32 s24, s25, s24
		s_cselect_b32 s25, 1, 0
		s_xor_b32 s24, s24, s22
		s_sub_i32 s22, s24, s22
		v_mov_b32_e32 v1, s22
		v_accvgpr_write_b32 a11, v1
		s_sub_i32 s22, s1, s23
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s1, s22, s1
		s_xor_b32 s1, s1, s21
		s_sub_i32 s1, s1, s21
		v_mov_b32_e32 v1, s1
		v_accvgpr_write_b32 a12, v1
		s_cmp_lt_i32 s18, 32
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_1
		s_lshr_b32 s1, s18, 1
		s_and_b32 s18, s18, 1
		s_mov_b32 s21, 31
		s_sub_i32 s21, s21, s1
		s_cmp_eq_u32 s18, 0
		s_cselect_b32 s1, s1, s21
		v_mov_b32_e32 v1, s1
		v_accvgpr_write_b32 a13, v1
		v_accvgpr_read_b32 v1, a13
		s_nop 0
		v_readfirstlane_b32 s1, v1
		s_mul_i32 s1, s1, 0x100
		v_readfirstlane_b32 s18, v0
		s_lshr_b32 s18, s18, 6
		s_nop 0
		v_mov_b32_e32 v1, s18
		v_accvgpr_write_b32 a14, v1
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
		v_cmp_lt_i32_e64 s[28:29], v16, s19
		v_cmp_lt_i32_e64 s[30:31], v17, s19
		v_cmp_lt_i32_e64 s[32:33], v18, s19
		v_cmp_lt_i32_e64 s[34:35], v19, s19
		v_cmp_lt_i32_e64 s[36:37], v20, s19
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
		s_add_i32 s26, s18, s21
		v_accvgpr_read_b32 v8, a12
		s_nop 0
		v_readfirstlane_b32 s38, v8
		s_mul_i32 s38, s38, s11
		s_lshl_b32 s38, s38, 1
		s_add_i32 s26, s26, s38
		v_mul_lo_u32 v8, s12, v6
		v_lshl_add_u32 v11, v8, 1, s26
		v_and_b32_e32 v13, 7, v0
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[100:101], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_0
		buffer_load_dwordx4 v[20:23], v11, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_0:
		s_andn2_b64 exec, s[100:101], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_0
		v_mov_b32_e32 v20, v16
		v_mov_b32_e32 v21, v17
		v_mov_b32_e32 v22, v18
		v_mov_b32_e32 v23, v19
.L_attn_fwd_persistent.exec_endif_0:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s22, s12, 6
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s38
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_1
		buffer_load_dwordx4 v[24:27], v11, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_1:
		s_andn2_b64 exec, s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_1
		v_mov_b32_e32 v24, v16
		v_mov_b32_e32 v25, v17
		v_mov_b32_e32 v26, v18
		v_mov_b32_e32 v27, v19
.L_attn_fwd_persistent.exec_endif_1:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s22, s12, 7
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s38
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_2
		buffer_load_dwordx4 v[28:31], v11, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_2:
		s_andn2_b64 exec, s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_2
		v_mov_b32_e32 v28, v16
		v_mov_b32_e32 v29, v17
		v_mov_b32_e32 v30, v18
		v_mov_b32_e32 v31, v19
.L_attn_fwd_persistent.exec_endif_2:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s22, 0xc0, s12
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s38
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[100:101], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_3
		buffer_load_dwordx4 v[32:35], v11, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_3:
		s_andn2_b64 exec, s[100:101], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_3
		v_mov_b32_e32 v32, v16
		v_mov_b32_e32 v33, v17
		v_mov_b32_e32 v34, v18
		v_mov_b32_e32 v35, v19
.L_attn_fwd_persistent.exec_endif_3:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s22, s12, 8
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s38
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[100:101], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_4
		buffer_load_dwordx4 v[36:39], v11, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_4:
		s_andn2_b64 exec, s[100:101], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_4
		v_mov_b32_e32 v36, v16
		v_mov_b32_e32 v37, v17
		v_mov_b32_e32 v38, v18
		v_mov_b32_e32 v39, v19
.L_attn_fwd_persistent.exec_endif_4:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s22, 0x140, s12
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s38
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[100:101], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_5
		buffer_load_dwordx4 v[40:43], v11, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_5:
		s_andn2_b64 exec, s[100:101], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_5
		v_mov_b32_e32 v40, v16
		v_mov_b32_e32 v41, v17
		v_mov_b32_e32 v42, v18
		v_mov_b32_e32 v43, v19
.L_attn_fwd_persistent.exec_endif_5:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s22, 0x180, s12
		s_add_i32 s22, s22, s18
		s_add_i32 s22, s22, s21
		s_add_i32 s22, s22, s38
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[100:101], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_6
		buffer_load_dwordx4 v[44:47], v11, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_6:
		s_andn2_b64 exec, s[100:101], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_6
		v_mov_b32_e32 v44, v16
		v_mov_b32_e32 v45, v17
		v_mov_b32_e32 v46, v18
		v_mov_b32_e32 v47, v19
.L_attn_fwd_persistent.exec_endif_6:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s22, 0x1c0, s12
		s_add_i32 s18, s22, s18
		s_add_i32 s18, s18, s21
		s_add_i32 s18, s18, s38
		v_lshl_add_u32 v8, v8, 1, s18
		v_lshl_add_u32 v8, v13, 4, v8
		v_cmp_lt_i32_e64 vcc, v1, s19
		s_and_saveexec_b64 s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_7
		buffer_load_dwordx4 v[48:51], v8, s[40:43], 0 offen
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
		v_and_b32_e32 v1, 1, v3
		v_accvgpr_write_b32 a17, v1
		v_accvgpr_read_b32 v1, a17
		v_lshlrev_b32_e32 v1, 1, v1
		v_accvgpr_read_b32 v3, a14
		s_nop 0
		v_readfirstlane_b32 s18, v3
		s_and_b32 s18, s18, 1
		s_lshl_b32 s18, s18, 2
		v_and_b32_e32 v3, 1, v9
		v_xor_b32_e32 v8, s18, v3
		v_bitop3_b32 v1, v0, v1, v8 bitop3:0x96
		v_lshlrev_b32_e32 v1, 4, v1
		v_add_u32_e32 v1, 0x10000, v1
		ds_write_b128 v1, v[20:23] offset:2480
		ds_write_b128 v1, v[24:27] offset:6576
		ds_write_b128 v1, v[28:31] offset:10672
		ds_write_b128 v1, v[32:35] offset:14768
		v_mov_b32_e32 v8, 32
		v_mul_lo_u32 v8, v8, v10
		v_mov_b32_e32 v9, 2
		v_mul_lo_u32 v9, v9, v14
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v10, a14
		s_nop 0
		v_readfirstlane_b32 s18, v10
		s_lshl_b32 s18, s18, 12
		s_add_i32 s18, s18, 0x10000
		v_and_b32_e32 v10, 63, v0
		v_and_b32_e32 v11, 7, v10
		v_lshrrev_b32_e32 v14, 2, v11
		v_lshl_add_u32 v15, v14, 5, s18
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
		v_lshl_add_u32 v11, v11, 4, s18
		ds_read_b128 a[32:35], v11 offset:2480
		v_and_b32_e32 v6, 1, v6
		v_lshlrev_b32_e32 v13, 4, v13
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
		ds_read_b128 a[48:51], v11 offset:2480
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
		v_mov_b32_e32 v11, 16
		v_mul_lo_u32 v11, v11, v4
		v_bitop3_b32 v14, v1, v8, v11 bitop3:0x96
		v_bitop3_b32 v14, v14, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a18, v14
		v_bitop3_b32 v14, 4, v1, v8 bitop3:0x96
		v_xor_b32_e32 v14, v14, v11
		v_bitop3_b32 v15, 8, v1, v8 bitop3:0x96
		v_xor_b32_e32 v15, v15, v11
		v_bitop3_b32 v1, 12, v1, v8 bitop3:0x96
		v_accvgpr_read_b32 v16, a18
		v_cmp_lt_i32_e64 s[24:25], v16, s20
		v_mov_b32_e32 v16, 16
		v_mul_lo_u32 v16, v16, v7
		v_mov_b32_e32 v7, 64
		v_mul_lo_u32 v7, v7, v4
		v_bitop3_b32 v4, v16, v8, v7 bitop3:0x96
		v_bitop3_b32 v4, v4, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a19, v4
		v_bitop3_b32 v4, 4, v16, v8 bitop3:0x96
		v_bitop3_b32 v17, 8, v16, v8 bitop3:0x96
		v_bitop3_b32 v8, 12, v16, v8 bitop3:0x96
		v_accvgpr_read_b32 v16, a19
		v_cmp_lt_i32_e64 vcc, v16, s20
		v_readfirstlane_b32 s26, v0
		v_accvgpr_read_b32 v16, a11
		s_nop 0
		v_readfirstlane_b32 s36, v16
		s_mul_i32 s36, s36, s13
		s_lshl_b32 s36, s36, 1
		v_accvgpr_read_b32 v16, a12
		s_nop 0
		v_readfirstlane_b32 s37, v16
		s_mul_i32 s37, s37, s14
		s_lshl_b32 s37, s37, 1
		s_add_i32 s38, s36, s37
		v_accvgpr_read_b32 v16, a14
		s_nop 0
		v_readfirstlane_b32 s39, v16
		s_mul_i32 s39, s15, s39
		s_lshl_b32 s39, s39, 1
		s_add_i32 s38, s38, s39
		v_accvgpr_read_b32 v16, a17
		v_mul_lo_u32 v16, s15, v16
		v_lshlrev_b32_e32 v16, 5, v16
		v_mul_lo_u32 v19, s15, v3
		v_lshlrev_b32_e32 v19, 6, v19
		v_add3_u32 v20, s38, v16, v19
		v_mul_lo_u32 v21, s15, v6
		v_lshlrev_b32_e32 v21, 7, v21
		v_add3_u32 v20, v20, v21, v13
		v_mov_b32_e32 v22, 0x80000000
		v_cndmask_b32_e64 v20, v22, v20, s[24:25]
		s_lshr_b32 s38, s26, 6
		s_mul_i32 s40, 0x410, s38
		s_mov_b32 m0, s40
		v_accvgpr_read_b32 v23, a15
		v_add_u32_e32 v23, s1, v23
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[44:45], v23, s19
		s_nop 1
		v_mov_b32_e32 v24, s44
		v_mov_b32_e32 v25, s45
		v_accvgpr_write_b32 a52, v24
		v_accvgpr_write_b32 a53, v25
		s_lshl_b32 s41, s15, 3
		s_add_i32 s41, s41, s36
		s_add_i32 s41, s41, s37
		s_add_i32 s41, s41, s39
		v_add3_u32 v20, s41, v16, v19
		v_add3_u32 v20, v20, v21, v13
		v_cndmask_b32_e64 v20, v22, v20, s[24:25]
		s_add_i32 m0, m0, 0x1040
		v_accvgpr_read_b32 v23, a16
		v_add_u32_e32 v23, s1, v23
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[44:45], v23, s19
		s_nop 1
		v_mov_b32_e32 v24, s44
		v_mov_b32_e32 v25, s45
		v_accvgpr_write_b32 a54, v24
		v_accvgpr_write_b32 a55, v25
		s_lshl_b32 s41, s15, 4
		s_add_i32 s41, s41, s36
		s_add_i32 s41, s41, s37
		s_add_i32 s41, s41, s39
		v_add3_u32 v20, s41, v16, v19
		v_add3_u32 v20, v20, v21, v13
		v_cndmask_b32_e64 v20, v22, v20, s[24:25]
		s_add_i32 m0, m0, 0x1040
		v_lshlrev_b32_e32 v18, 4, v18
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		v_bitop3_b32 v14, v14, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a56, v14
		s_mul_i32 s41, 24, s15
		s_add_i32 s41, s41, s36
		s_add_i32 s41, s41, s37
		s_add_i32 s41, s41, s39
		v_add3_u32 v14, s41, v16, v19
		v_add3_u32 v14, v14, v21, v13
		v_cndmask_b32_e64 v14, v22, v14, s[24:25]
		s_add_i32 m0, m0, 0x1040
		v_mov_b32_e32 v20, 0x440
		v_mul_lo_u32 v20, v20, v2
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		v_bitop3_b32 v2, v15, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a57, v2
		v_accvgpr_read_b32 v2, a0
		s_nop 0
		v_readfirstlane_b32 s24, v2
		v_accvgpr_read_b32 v2, a11
		s_nop 0
		v_readfirstlane_b32 s25, v2
		s_mul_i32 s24, s25, s24
		s_lshl_b32 s24, s24, 1
		v_accvgpr_read_b32 v2, a1
		s_nop 0
		v_readfirstlane_b32 s25, v2
		v_accvgpr_read_b32 v2, a12
		s_nop 0
		v_readfirstlane_b32 s41, v2
		s_mul_i32 s25, s41, s25
		s_lshl_b32 s25, s25, 1
		s_add_i32 s41, s24, s25
		v_accvgpr_read_b32 v2, a14
		s_nop 0
		v_readfirstlane_b32 s44, v2
		s_mul_i32 s44, s17, s44
		s_lshl_b32 s44, s44, 1
		s_add_i32 s41, s41, s44
		v_accvgpr_read_b32 v2, a17
		v_mul_lo_u32 v2, s17, v2
		v_lshlrev_b32_e32 v2, 7, v2
		v_mul_lo_u32 v14, s17, v3
		v_lshlrev_b32_e32 v14, 6, v14
		v_add3_u32 v15, s41, v2, v14
		v_mul_lo_u32 v23, s17, v6
		v_lshlrev_b32_e32 v23, 5, v23
		v_add3_u32 v15, v15, v23, v13
		v_cndmask_b32_e32 v15, v22, v15, vcc
		s_mul_i32 s38, 0x440, s38
		s_add_i32 m0, s38, 0x81f0
		v_xor_b32_e32 v1, v1, v11
		buffer_load_dwordx4 v15, s[32:35], 0 offen lds
		v_bitop3_b32 v1, v1, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a58, v1
		s_lshl_b32 s41, s17, 3
		s_add_i32 s41, s41, s24
		s_add_i32 s41, s41, s25
		s_add_i32 s41, s41, s44
		v_add3_u32 v1, s41, v2, v14
		v_add3_u32 v1, v1, v23, v13
		v_cndmask_b32_e32 v1, v22, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v4, v4, v7
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_bitop3_b32 v1, v4, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a59, v1
		s_lshl_b32 s41, s17, 4
		s_add_i32 s41, s41, s24
		s_add_i32 s41, s41, s25
		s_add_i32 s41, s41, s44
		v_add3_u32 v1, s41, v2, v14
		v_add3_u32 v1, v1, v23, v13
		v_cndmask_b32_e32 v1, v22, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v4, v17, v7
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_bitop3_b32 v1, v4, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a60, v1
		s_mul_i32 s41, 24, s17
		s_add_i32 s41, s41, s24
		s_add_i32 s41, s41, s25
		s_add_i32 s41, s41, s44
		v_add3_u32 v1, s41, v2, v14
		v_add3_u32 v1, v1, v23, v13
		v_cndmask_b32_e32 v1, v22, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v4, v8, v7
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_bitop3_b32 v1, v4, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a61, v1
		s_mul_i32 s41, s23, 0x80
		s_lshl_b32 s23, s15, 8
		s_add_i32 s23, s23, s36
		s_add_i32 s23, s23, s37
		s_add_i32 s23, s23, s39
		s_mul_i32 s45, 0x108, s15
		s_add_i32 s45, s45, s36
		s_add_i32 s45, s45, s37
		s_add_i32 s45, s45, s39
		s_mul_i32 s46, 0x110, s15
		s_add_i32 s46, s46, s36
		s_add_i32 s46, s46, s37
		s_add_i32 s46, s46, s39
		s_mul_i32 s47, 0x118, s15
		s_add_i32 s36, s47, s36
		s_add_i32 s36, s36, s37
		s_add_i32 s36, s36, s39
		s_lshl_b32 s37, s17, 8
		s_add_i32 s37, s37, s24
		s_add_i32 s37, s37, s25
		s_add_i32 s37, s37, s44
		s_mul_i32 s39, 0x108, s17
		s_add_i32 s39, s39, s24
		s_add_i32 s39, s39, s25
		s_add_i32 s39, s39, s44
		s_mul_i32 s47, 0x110, s17
		s_add_i32 s47, s47, s24
		s_add_i32 s47, s47, s25
		s_add_i32 s47, s47, s44
		s_mul_i32 s48, 0x118, s17
		s_add_i32 s24, s48, s24
		s_add_i32 s24, s24, s25
		s_add_i32 s24, s24, s44
		v_mbcnt_lo_u32_b32 v1, -1, 0
		v_mbcnt_hi_u32_b32 v1, -1, v1
		v_and_b32_e32 v1, 31, v1
		v_add_u32_e32 v4, 32, v1
		v_mov_b32_e32 v8, 0x3e38aa3b
		v_mov_b32_e32 v9, 0x3e38aa3b
		s_mov_b32 s25, 0xff800000
		v_mov_b32_e32 v7, s25
		v_mov_b32_e32 v11, s25
		s_mov_b32 s25, 1.0
		v_mov_b32_e32 v24, s25
		v_mov_b32_e32 v25, s25
		s_mov_b32 s25, 0
		v_lshrrev_b32_e32 v12, 4, v10
		v_lshlrev_b32_e32 v12, 9, v12
		v_and_b32_e32 v10, 15, v10
		v_mov_b32_e32 v15, 0x410
		v_mul_lo_u32 v15, v15, v10
		v_add3_u32 v10, v18, v12, v15
		v_accvgpr_write_b32 a62, v10
		v_and_b32_e32 v10, 3, v0
		v_accvgpr_read_b32 v12, a17
		v_mov_b32_e32 v15, 0x2200
		v_mul_lo_u32 v15, v15, v12
		v_lshl_add_u32 v10, v10, 3, v15
		v_lshl_add_u32 v3, v3, 5, v10
		v_mov_b32_e32 v10, 0x880
		v_mul_lo_u32 v10, v10, v6
		v_add3_u32 v3, v3, v10, v20
		v_accvgpr_write_b32 a63, v3
		v_lshlrev_b32_e32 v1, 2, v1
		v_accvgpr_write_b32 a64, v1
		v_lshlrev_b32_e32 v1, 2, v4
		v_accvgpr_write_b32 a65, v1
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
		s_lshr_b32 s44, s25, 7
		s_and_b32 s48, s44, 1
		s_mul_i32 s49, 0x4100, s48
		v_accvgpr_read_b32 v1, a62
		v_add_u32_e32 v1, s49, v1
		ds_read_b128 v[28:31], v1
		ds_read_b128 v[96:99], v1 offset:32
		ds_read_b128 v[100:103], v1 offset:64
		ds_read_b128 a[68:71], v1 offset:96
		ds_read_b128 v[104:107], v1 offset:256
		ds_read_b128 v[108:111], v1 offset:288
		ds_read_b128 v[112:115], v1 offset:320
		ds_read_b128 a[72:75], v1 offset:352
		ds_read_b128 v[116:119], v1 offset:128
		ds_read_b128 v[120:123], v1 offset:160
		ds_read_b128 v[124:127], v1 offset:192
		ds_read_b128 a[76:79], v1 offset:224
		ds_read_b128 v[128:131], v1 offset:384
		ds_read_b128 a[80:83], v1 offset:416
		ds_read_b128 a[84:87], v1 offset:448
		ds_read_b128 a[88:91], v1 offset:480
		s_mul_i32 s48, 0x4400, s48
		v_accvgpr_read_b32 v1, a63
		v_add_u32_e32 v1, s48, v1
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
		s_mul_i32 s48, s15, s25
		s_lshl_b32 s48, s48, 1
		s_add_i32 s49, s23, s48
		v_add3_u32 v1, s49, v16, v19
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[20:23], 0
		v_add3_u32 v1, v1, v21, v13
		v_mfma_f32_32x32x16_bf16 v[144:159], v[96:99], a[24:27], v[144:159]
		s_add_i32 s44, s44, 1
		v_mfma_f32_32x32x16_bf16 v[144:159], v[100:103], a[28:31], v[144:159]
		s_and_b32 s44, s44, 1
		v_mfma_f32_32x32x16_bf16 v[160:175], v[28:31], a[36:39], 0
		s_mul_i32 s49, 0x4100, s44
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], a[40:43], v[160:175]
		s_add_i32 s49, s40, s49
		v_mfma_f32_32x32x16_bf16 v[160:175], v[100:103], a[44:47], v[160:175]
		s_mov_b32 m0, s49
		v_mfma_f32_32x32x16_bf16 v[176:191], v[104:107], a[20:23], 0
		s_add_i32 s49, s45, s48
		v_mfma_f32_32x32x16_bf16 v[176:191], v[108:111], a[24:27], v[176:191]
		v_add3_u32 v3, s49, v16, v19
		v_mfma_f32_32x32x16_bf16 v[176:191], v[112:115], a[28:31], v[176:191]
		v_add3_u32 v3, v3, v21, v13
		v_mfma_f32_32x32x16_bf16 v[192:207], v[104:107], a[36:39], 0
		s_add_i32 s49, s46, s48
		v_mfma_f32_32x32x16_bf16 v[192:207], v[108:111], a[40:43], v[192:207]
		v_add3_u32 v4, s49, v16, v19
		v_mfma_f32_32x32x16_bf16 v[192:207], v[112:115], a[44:47], v[192:207]
		v_add3_u32 v4, v4, v21, v13
		v_mfma_f32_32x32x16_bf16 v[96:111], v[116:119], a[20:23], 0
		s_add_i32 s48, s36, s48
		v_mfma_f32_32x32x16_bf16 v[96:111], v[120:123], a[24:27], v[96:111]
		v_add3_u32 v6, s48, v16, v19
		v_mfma_f32_32x32x16_bf16 v[96:111], v[124:127], a[28:31], v[96:111]
		v_add3_u32 v6, v6, v21, v13
		v_mfma_f32_32x32x16_bf16 v[208:223], v[116:119], a[36:39], 0
		s_mul_i32 s48, s17, s25
		v_mfma_f32_32x32x16_bf16 v[208:223], v[120:123], a[40:43], v[208:223]
		s_add_i32 s25, s25, 0x80
		v_mfma_f32_32x32x16_bf16 v[208:223], v[124:127], a[44:47], v[208:223]
		v_accvgpr_read_b32 v10, a18
		v_add_u32_e32 v10, s25, v10
		v_mfma_f32_32x32x16_bf16 v[112:127], v[128:131], a[20:23], 0
		v_accvgpr_read_b32 v12, a56
		v_add_u32_e32 v12, s25, v12
		v_mfma_f32_32x32x16_bf16 v[112:127], a[80:83], a[24:27], v[112:127]
		v_accvgpr_read_b32 v15, a57
		v_add_u32_e32 v15, s25, v15
		v_mfma_f32_32x32x16_bf16 v[112:127], a[84:87], a[28:31], v[112:127]
		v_accvgpr_read_b32 v17, a58
		v_add_u32_e32 v17, s25, v17
		v_mfma_f32_32x32x16_bf16 v[224:239], v[128:131], a[36:39], 0
		v_cmp_lt_i32_e64 s[50:51], v10, s20
		v_accvgpr_read_b32 v10, a19
		v_add_u32_e32 v10, s25, v10
		v_accvgpr_read_b32 v18, a59
		v_add_u32_e32 v18, s25, v18
		v_accvgpr_read_b32 v20, a60
		v_add_u32_e32 v20, s25, v20
		v_accvgpr_read_b32 v26, a61
		v_add_u32_e32 v26, s25, v26
		v_cmp_lt_i32_e64 vcc, v26, s20
		v_cndmask_b32_e64 v1, v22, v1, s[50:51]
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[50:51], v12, s20
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[52:53], v15, s20
		v_cndmask_b32_e64 v1, v22, v3, s[50:51]
		v_cmp_lt_i32_e64 s[50:51], v17, s20
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], a[80:83], a[40:43], v[224:239]
		v_cndmask_b32_e64 v1, v22, v4, s[52:53]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[84:87], a[44:47], v[224:239]
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v3, v22, v6, s[50:51]
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[50:51], v10, s20
		v_cmp_lt_i32_e64 s[52:53], v18, s20
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s48, s48, 1
		s_add_i32 s49, s37, s48
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[144:159], a[68:71], a[32:35], v[144:159]
		v_add3_u32 v1, s49, v2, v14
		v_mfma_f32_32x32x16_bf16 v[160:175], a[68:71], a[48:51], v[160:175]
		v_add3_u32 v1, v1, v23, v13
		v_cndmask_b32_e64 v1, v22, v1, s[50:51]
		v_cmp_lt_i32_e64 s[50:51], v20, s20
		s_mul_i32 s44, 0x4400, s44
		s_add_i32 s44, s38, s44
		s_add_i32 m0, s44, 0x81f0
		s_add_i32 s44, s39, s48
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_add3_u32 v1, s44, v2, v14
		v_add3_u32 v1, v1, v23, v13
		v_cndmask_b32_e64 v1, v22, v1, s[52:53]
		v_max3_f32 v3, v144, v145, v146
		s_add_i32 m0, m0, 0x1100
		s_add_i32 s44, s47, s48
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_add3_u32 v1, s44, v2, v14
		v_add3_u32 v1, v1, v23, v13
		v_max3_f32 v4, v148, v149, v150
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v1, v22, v1, s[50:51]
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_max3_f32 v1, v152, v153, v154
		s_add_i32 s44, s24, s48
		v_add3_u32 v6, s44, v2, v14
		v_add3_u32 v6, v6, v23, v13
		v_cndmask_b32_e32 v6, v22, v6, vcc
		v_max3_f32 v10, v156, v157, v158
		s_add_i32 m0, m0, 0x1100
		v_max3_f32 v3, v3, v147, v4
		v_max3_f32 v1, v1, v155, v10
		v_max3_f32 v1, v3, v151, v1
		v_max3_f32 v3, v160, v161, v162
		v_max3_f32 v4, v164, v165, v166
		v_max3_f32 v10, v168, v169, v170
		v_max3_f32 v12, v172, v173, v174
		v_max3_f32 v3, v3, v163, v4
		v_max3_f32 v4, v10, v171, v12
		v_max3_f32 v3, v3, v167, v4
		s_cmp_lt_i32 s25, s41
		buffer_load_dwordx4 v6, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[176:191], a[72:75], a[32:35], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[76:79], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[88:91], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[88:91], a[48:51], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[72:75], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[76:79], a[48:51], v[208:223]
		s_nop 6
		v_max3_f32 v4, v176, v177, v178
		v_max3_f32 v6, v180, v181, v182
		v_max3_f32 v10, v184, v185, v186
		v_max3_f32 v12, v188, v189, v190
		v_max3_f32 v15, v96, v97, v98
		v_max3_f32 v17, v100, v101, v102
		v_max3_f32 v18, v104, v105, v106
		v_max3_f32 v20, v108, v109, v110
		v_max3_f32 v26, v112, v113, v114
		v_max3_f32 v27, v116, v117, v118
		v_max3_f32 v28, v120, v121, v122
		v_max3_f32 v29, v124, v125, v126
		v_max3_f32 v4, v4, v179, v6
		v_max3_f32 v6, v10, v187, v12
		v_max3_f32 v10, v15, v99, v17
		v_max3_f32 v12, v18, v107, v20
		v_max3_f32 v15, v26, v115, v27
		v_max3_f32 v17, v28, v123, v29
		v_max3_f32 v4, v4, v183, v6
		v_max3_f32 v6, v10, v103, v12
		v_max3_f32 v10, v15, v119, v17
		v_max3_f32 v1, v1, v159, v4
		v_max3_f32 v4, v6, v111, v10
		v_max3_f32 v1, v1, v191, v4
		v_max_f32_e32 v26, v1, v127
		v_mov_b32_e32 v27, v26
		v_max3_f32 v1, v192, v193, v194
		v_max3_f32 v4, v196, v197, v198
		v_max3_f32 v6, v200, v201, v202
		v_max3_f32 v10, v204, v205, v206
		v_max3_f32 v12, v208, v209, v210
		v_max3_f32 v15, v212, v213, v214
		v_max3_f32 v17, v216, v217, v218
		v_max3_f32 v18, v220, v221, v222
		v_max3_f32 v20, v224, v225, v226
		v_max3_f32 v28, v228, v229, v230
		v_max3_f32 v29, v232, v233, v234
		v_max3_f32 v30, v236, v237, v238
		v_max3_f32 v1, v1, v195, v4
		v_max3_f32 v4, v6, v203, v10
		v_max3_f32 v6, v12, v211, v15
		v_max3_f32 v10, v17, v219, v18
		v_permlane32_swap_b32_e32 v26, v27
		v_max3_f32 v12, v20, v227, v28
		v_max3_f32 v15, v29, v235, v30
		v_max3_f32 v1, v1, v199, v4
		v_max3_f32 v4, v6, v215, v10
		v_max3_f32 v6, v12, v231, v15
		v_max3_f32 v1, v3, v175, v1
		v_max3_f32 v3, v4, v223, v6
		v_max3_f32 v1, v1, v207, v3
		v_max_f32_e32 v28, v1, v239
		v_mov_b32_e32 v29, v28
		v_max_f32_e32 v30, v26, v27
		v_mov_b32_e32 v26, v7
		v_permlane32_swap_b32_e32 v28, v29
		v_max_f32_e32 v31, v28, v29
		v_pk_mul_f32 v[28:29], v[30:31], v[8:9]
		v_max_f32_e32 v30, v7, v28
		v_max_f32_e32 v31, v11, v29
		v_pk_fma_f32 v[6:7], v[144:145], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
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
		v_exp_f32_e32 v220, v6
		v_exp_f32_e32 v222, v7
		v_exp_f32_e32 v6, v28
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
		v_exp_f32_e32 v7, v96
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
		v_pk_add_f32 v[188:189], v[6:7], v[224:225]
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
		v_add_f32_e32 v1, v190, v191
		v_accvgpr_read_b32 v3, a64
		ds_bpermute_b32 v186, v3, v1
		v_accvgpr_read_b32 v3, a65
		ds_bpermute_b32 v188, v3, v1
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
		v_accvgpr_write_b32 a66, v218
		v_accvgpr_write_b32 a67, v219
		v_pk_add_f32 v[218:219], v[182:183], v[184:185]
		v_pk_add_f32 v[190:191], v[190:191], v[192:193]
		v_pk_add_f32 v[192:193], v[194:195], v[196:197]
		v_pk_add_f32 v[194:195], v[198:199], v[200:201]
		v_pk_add_f32 v[196:197], v[202:203], v[204:205]
		v_pk_add_f32 v[198:199], v[206:207], v[208:209]
		v_pk_add_f32 v[200:201], v[210:211], v[212:213]
		v_pk_add_f32 v[202:203], v[214:215], v[216:217]
		v_accvgpr_read_b32 v204, a66
		v_accvgpr_read_b32 v205, a67
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
		v_cvt_pk_bf16_f32 v193, v6, v224
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
		v_cvt_pk_bf16_f32 v205, v7, v225
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
		v_mfma_f32_32x32x16_bf16 v[32:47], a[92:95], v[192:195], v[32:47]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[48:63], a[124:127], v[192:195], v[48:63]
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_mfma_f32_32x32x16_bf16 v[32:47], a[96:99], v[188:191], v[32:47]
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_mfma_f32_32x32x16_bf16 v[48:63], a[128:131], v[188:191], v[48:63]
		v_permlane32_swap_b32_e32 v208, v210
		v_permlane32_swap_b32_e32 v209, v211
		v_mfma_f32_32x32x16_bf16 v[32:47], a[100:103], v[196:199], v[32:47]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[48:63], a[132:135], v[196:199], v[48:63]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[32:47], a[104:107], v[200:203], v[32:47]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[48:63], a[136:139], v[200:203], v[48:63]
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_mfma_f32_32x32x16_bf16 v[80:95], a[124:127], v[136:139], v[80:95]
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_mfma_f32_32x32x16_bf16 v[64:79], a[92:95], v[136:139], v[64:79]
		v_permlane32_swap_b32_e32 v148, v150
		v_permlane32_swap_b32_e32 v149, v151
		v_mfma_f32_32x32x16_bf16 v[80:95], a[128:131], v[140:143], v[80:95]
		v_permlane32_swap_b32_e32 v212, v214
		v_permlane32_swap_b32_e32 v213, v215
		v_mfma_f32_32x32x16_bf16 v[64:79], a[96:99], v[140:143], v[64:79]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[80:95], a[132:135], v[144:147], v[80:95]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[64:79], a[100:103], v[144:147], v[64:79]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[80:95], a[136:139], v[148:151], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[104:107], v[148:151], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[108:111], v[204:207], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[140:143], v[204:207], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[140:143], v[212:215], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[108:111], v[212:215], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[112:115], v[208:211], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[144:147], v[208:211], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[112:115], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[116:119], v[128:131], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[148:151], v[128:131], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[148:151], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[116:119], v[100:103], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[120:123], v[132:135], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[152:155], v[132:135], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], v[104:107], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[120:123], v[104:107], v[64:79]
		v_mov_b32_e32 v7, v30
		v_mov_b32_e32 v11, v31
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_1
.L_attn_fwd_persistent.loop_exit_1:
		s_mul_i32 s21, s21, 0x80
		v_accvgpr_read_b32 v1, a15
		v_accvgpr_read_b32 v3, a6
		s_nop 0
		v_readfirstlane_b32 s25, v3
		s_nop 1
		v_add_u32_e32 v1, s25, v1
		v_add_u32_e32 v1, s1, v1
		v_accvgpr_read_b32 v3, a16
		v_accvgpr_read_b32 v4, a6
		s_nop 0
		v_readfirstlane_b32 s25, v4
		s_nop 1
		v_add_u32_e32 v3, s25, v3
		v_add_u32_e32 v3, s1, v3
		v_xor_b32_e32 v4, 1, v5
		v_accvgpr_write_b32 a15, v4
		v_xor_b32_e32 v4, 2, v5
		v_accvgpr_write_b32 a16, v4
		v_xor_b32_e32 v4, 3, v5
		v_accvgpr_write_b32 a66, v4
		v_xor_b32_e32 v4, 8, v5
		v_accvgpr_write_b32 a67, v4
		v_xor_b32_e32 v4, 9, v5
		v_accvgpr_write_b32 a68, v4
		v_xor_b32_e32 v4, 10, v5
		v_accvgpr_write_b32 a69, v4
		v_xor_b32_e32 v4, 11, v5
		v_accvgpr_write_b32 a70, v4
		v_xor_b32_e32 v4, 16, v5
		v_accvgpr_write_b32 a71, v4
		v_xor_b32_e32 v4, 17, v5
		v_accvgpr_write_b32 a72, v4
		v_xor_b32_e32 v4, 18, v5
		v_accvgpr_write_b32 a73, v4
		v_xor_b32_e32 v4, 19, v5
		v_accvgpr_write_b32 a74, v4
		v_xor_b32_e32 v4, 24, v5
		v_accvgpr_write_b32 a75, v4
		v_xor_b32_e32 v4, 25, v5
		v_accvgpr_write_b32 a76, v4
		v_xor_b32_e32 v4, 26, v5
		v_accvgpr_write_b32 a77, v4
		v_xor_b32_e32 v4, 27, v5
		v_accvgpr_write_b32 a78, v4
		v_xor_b32_e32 v4, 32, v5
		v_accvgpr_write_b32 a79, v4
		v_xor_b32_e32 v4, 33, v5
		v_accvgpr_write_b32 a80, v4
		v_xor_b32_e32 v4, 34, v5
		v_accvgpr_write_b32 a81, v4
		v_xor_b32_e32 v4, 35, v5
		v_accvgpr_write_b32 a82, v4
		v_xor_b32_e32 v4, 40, v5
		v_accvgpr_write_b32 a83, v4
		v_xor_b32_e32 v4, 41, v5
		v_accvgpr_write_b32 a84, v4
		v_xor_b32_e32 v4, 42, v5
		v_accvgpr_write_b32 a85, v4
		v_xor_b32_e32 v4, 43, v5
		v_accvgpr_write_b32 a86, v4
		v_xor_b32_e32 v4, 48, v5
		v_accvgpr_write_b32 a87, v4
		v_xor_b32_e32 v4, 49, v5
		v_accvgpr_write_b32 a88, v4
		v_xor_b32_e32 v4, 50, v5
		v_accvgpr_write_b32 a89, v4
		v_xor_b32_e32 v4, 51, v5
		v_accvgpr_write_b32 a90, v4
		v_xor_b32_e32 v4, 56, v5
		v_accvgpr_write_b32 a91, v4
		v_xor_b32_e32 v4, 57, v5
		v_accvgpr_write_b32 a92, v4
		v_xor_b32_e32 v4, 58, v5
		v_accvgpr_write_b32 a93, v4
		v_xor_b32_e32 v4, 59, v5
		v_accvgpr_write_b32 a94, v4
		v_xor_b32_e32 v4, 64, v5
		v_accvgpr_write_b32 a95, v4
		v_xor_b32_e32 v4, 0x41, v5
		v_accvgpr_write_b32 a96, v4
		v_xor_b32_e32 v4, 0x42, v5
		v_accvgpr_write_b32 a97, v4
		v_xor_b32_e32 v4, 0x43, v5
		v_accvgpr_write_b32 a98, v4
		v_xor_b32_e32 v4, 0x48, v5
		v_accvgpr_write_b32 a99, v4
		v_xor_b32_e32 v4, 0x49, v5
		v_accvgpr_write_b32 a100, v4
		v_xor_b32_e32 v4, 0x4a, v5
		v_accvgpr_write_b32 a101, v4
		v_xor_b32_e32 v4, 0x4b, v5
		v_accvgpr_write_b32 a102, v4
		v_xor_b32_e32 v4, 0x50, v5
		v_accvgpr_write_b32 a103, v4
		v_xor_b32_e32 v4, 0x51, v5
		v_accvgpr_write_b32 a104, v4
		v_xor_b32_e32 v4, 0x52, v5
		v_accvgpr_write_b32 a105, v4
		v_xor_b32_e32 v4, 0x53, v5
		v_accvgpr_write_b32 a106, v4
		v_xor_b32_e32 v4, 0x58, v5
		v_accvgpr_write_b32 a107, v4
		v_xor_b32_e32 v4, 0x59, v5
		v_accvgpr_write_b32 a108, v4
		v_xor_b32_e32 v4, 0x5a, v5
		v_accvgpr_write_b32 a109, v4
		v_xor_b32_e32 v4, 0x5b, v5
		v_accvgpr_write_b32 a110, v4
		v_xor_b32_e32 v4, 0x60, v5
		v_accvgpr_write_b32 a111, v4
		v_xor_b32_e32 v4, 0x61, v5
		v_accvgpr_write_b32 a112, v4
		v_xor_b32_e32 v4, 0x62, v5
		v_accvgpr_write_b32 a113, v4
		v_xor_b32_e32 v4, 0x63, v5
		v_accvgpr_write_b32 a114, v4
		v_xor_b32_e32 v4, 0x68, v5
		v_accvgpr_write_b32 a115, v4
		v_xor_b32_e32 v4, 0x69, v5
		v_accvgpr_write_b32 a116, v4
		v_xor_b32_e32 v4, 0x6a, v5
		v_accvgpr_write_b32 a117, v4
		v_xor_b32_e32 v4, 0x6b, v5
		v_accvgpr_write_b32 a118, v4
		v_xor_b32_e32 v4, 0x70, v5
		v_accvgpr_write_b32 a119, v4
		v_xor_b32_e32 v4, 0x71, v5
		v_accvgpr_write_b32 a120, v4
		v_xor_b32_e32 v4, 0x72, v5
		v_accvgpr_write_b32 a121, v4
		v_xor_b32_e32 v4, 0x73, v5
		v_accvgpr_write_b32 a122, v4
		v_xor_b32_e32 v4, 0x78, v5
		v_accvgpr_write_b32 a123, v4
		v_xor_b32_e32 v4, 0x79, v5
		v_accvgpr_write_b32 a124, v4
		v_xor_b32_e32 v4, 0x7a, v5
		v_accvgpr_write_b32 a125, v4
		v_xor_b32_e32 v4, 0x7b, v5
		v_accvgpr_write_b32 a126, v4
		v_mov_b32_e32 v4, 0xff800000
		s_cmp_lt_i32 s41, s21
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_2
.L_attn_fwd_persistent.loop_head_2:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s1, s41, 0x80
		s_cmp_lt_i32 s41, 0
		s_cselect_b32 s25, s22, 0
		s_add_i32 s25, s41, s25
		s_ashr_i32 s25, s25, 7
		s_cmp_lt_i32 s25, 0
		s_cselect_b32 s38, s16, 0
		s_add_i32 s38, s25, s38
		s_ashr_i32 s38, s38, 1
		s_lshl_b32 s38, s38, 1
		s_sub_i32 s38, s25, s38
		s_add_i32 s25, s25, 1
		s_cmp_lt_i32 s25, 0
		s_cselect_b32 s40, s16, 0
		s_add_i32 s40, s25, s40
		s_ashr_i32 s40, s40, 1
		s_lshl_b32 s40, s40, 1
		s_sub_i32 s48, s25, s40
		s_mul_i32 s25, 0x4100, s38
		v_accvgpr_read_b32 v6, a62
		v_add_u32_e32 v6, s25, v6
		ds_read_b128 v[28:31], v6
		ds_read_b128 a[128:131], v6 offset:32
		ds_read_b128 a[132:135], v6 offset:64
		ds_read_b128 a[136:139], v6 offset:96
		ds_read_b128 a[140:143], v6 offset:256
		ds_read_b128 a[144:147], v6 offset:288
		ds_read_b128 a[148:151], v6 offset:320
		ds_read_b128 a[152:155], v6 offset:352
		ds_read_b128 a[156:159], v6 offset:128
		ds_read_b128 a[160:163], v6 offset:160
		ds_read_b128 a[164:167], v6 offset:192
		ds_read_b128 a[168:171], v6 offset:224
		ds_read_b128 v[96:99], v6 offset:384
		ds_read_b128 a[172:175], v6 offset:416
		ds_read_b128 a[176:179], v6 offset:448
		ds_read_b128 a[180:183], v6 offset:480
		s_mul_i32 s25, 0x4400, s38
		v_accvgpr_read_b32 v6, a63
		v_add_u32_e32 v6, s25, v6
		ds_read_b64_tr_b16 a[184:185], v6 offset:33264
		ds_read_b64_tr_b16 a[186:187], v6 offset:37616
		ds_read_b64_tr_b16 a[188:189], v6 offset:33392
		ds_read_b64_tr_b16 a[190:191], v6 offset:37744
		ds_read_b64_tr_b16 a[192:193], v6 offset:33520
		ds_read_b64_tr_b16 a[194:195], v6 offset:37872
		ds_read_b64_tr_b16 a[196:197], v6 offset:33648
		ds_read_b64_tr_b16 a[198:199], v6 offset:38000
		ds_read_b64_tr_b16 a[200:201], v6 offset:33776
		ds_read_b64_tr_b16 a[202:203], v6 offset:38128
		ds_read_b64_tr_b16 a[204:205], v6 offset:33904
		ds_read_b64_tr_b16 a[206:207], v6 offset:38256
		ds_read_b64_tr_b16 a[208:209], v6 offset:34032
		ds_read_b64_tr_b16 a[210:211], v6 offset:38384
		ds_read_b64_tr_b16 a[212:213], v6 offset:34160
		ds_read_b64_tr_b16 a[214:215], v6 offset:38512
		ds_read_b64_tr_b16 a[216:217], v6 offset:33328
		ds_read_b64_tr_b16 a[218:219], v6 offset:37680
		ds_read_b64_tr_b16 a[220:221], v6 offset:33456
		ds_read_b64_tr_b16 a[222:223], v6 offset:37808
		ds_read_b64_tr_b16 a[224:225], v6 offset:33584
		ds_read_b64_tr_b16 a[226:227], v6 offset:37936
		ds_read_b64_tr_b16 a[228:229], v6 offset:33712
		ds_read_b64_tr_b16 a[230:231], v6 offset:38064
		ds_read_b64_tr_b16 a[232:233], v6 offset:33840
		ds_read_b64_tr_b16 a[234:235], v6 offset:38192
		ds_read_b64_tr_b16 a[236:237], v6 offset:33968
		ds_read_b64_tr_b16 a[238:239], v6 offset:38320
		ds_read_b64_tr_b16 a[240:241], v6 offset:34096
		ds_read_b64_tr_b16 a[242:243], v6 offset:38448
		ds_read_b64_tr_b16 a[244:245], v6 offset:34224
		ds_read_b64_tr_b16 a[246:247], v6 offset:38576
		s_cmp_lt_i32 s1, s18
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_2
		v_accvgpr_read_b32 v6, a18
		v_add_u32_e32 v6, s1, v6
		v_cmp_lt_i32_e64 s[50:51], v6, s20
		v_accvgpr_read_b32 v6, a19
		v_add_u32_e32 v6, s1, v6
		v_cmp_lt_i32_e64 s[52:53], v6, s20
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s25, s15, s41
		s_lshl_b32 s25, s25, 1
		s_add_i32 s38, s23, s25
		v_add3_u32 v6, s38, v16, v19
		v_add3_u32 v6, v6, v21, v13
		v_cndmask_b32_e64 v6, v22, v6, s[50:51]
		s_mov_b32 s50, 1
		s_mov_b32 s51, 0
		s_mul_i32 s54, s50, s26
		s_mul_hi_u32 s55, s50, s26
		s_mul_i32 s38, s50, s27
		s_add_i32 s55, s55, s38
		s_mul_i32 s38, s51, s26
		s_add_i32 s55, s55, s38
		s_lshr_b64 s[50:51], s[54:55], 6
		s_mov_b32 s54, 0x410
		s_mov_b32 s55, 0
		s_mul_i32 s56, s54, s50
		s_mul_hi_u32 s57, s54, s50
		s_mul_i32 s38, s54, s51
		s_add_i32 s57, s57, s38
		s_mul_i32 s38, s55, s50
		s_add_i32 s57, s57, s38
		s_cmp_lt_i32 s48, 0
		s_cselect_b32 s49, -1, 0
		s_mov_b32 s54, 0x4100
		s_mov_b32 s55, 0
		s_mul_i32 s58, s54, s48
		s_mul_hi_u32 s59, s54, s48
		s_mul_i32 s38, s54, s49
		s_add_i32 s59, s59, s38
		s_mul_i32 s38, s55, s48
		s_add_i32 s59, s59, s38
		s_add_u32 s54, s56, s58
		s_addc_u32 s55, s57, s59
		s_add_u32 s60, s54, 0
		s_addc_u32 s61, s55, 0
		s_mov_b32 m0, s60
		v_accvgpr_read_b32 v8, a56
		v_add_u32_e32 v8, s1, v8
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v8, s20
		s_add_i32 s38, s45, s25
		v_add3_u32 v6, s38, v16, v19
		v_add3_u32 v6, v6, v21, v13
		v_cndmask_b32_e64 v6, v22, v6, s[54:55]
		s_add_u32 s54, s56, 0x1040
		s_addc_u32 s55, s57, 0
		s_add_u32 s54, s54, s58
		s_addc_u32 s55, s55, s59
		s_add_u32 s60, s54, 0
		s_addc_u32 s61, s55, 0
		s_mov_b32 m0, s60
		v_accvgpr_read_b32 v8, a57
		v_add_u32_e32 v8, s1, v8
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v8, s20
		s_add_i32 s38, s46, s25
		v_add3_u32 v6, s38, v16, v19
		v_add3_u32 v6, v6, v21, v13
		v_cndmask_b32_e64 v6, v22, v6, s[54:55]
		s_add_u32 s54, s56, 0x2080
		s_addc_u32 s55, s57, 0
		s_add_u32 s54, s54, s58
		s_addc_u32 s55, s55, s59
		s_add_u32 s60, s54, 0
		s_addc_u32 s61, s55, 0
		s_mov_b32 m0, s60
		v_accvgpr_read_b32 v8, a58
		v_add_u32_e32 v8, s1, v8
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v8, s20
		s_add_i32 s25, s36, s25
		v_add3_u32 v6, s25, v16, v19
		v_add3_u32 v6, v6, v21, v13
		v_cndmask_b32_e64 v6, v22, v6, s[54:55]
		s_add_u32 s54, s56, 0x30c0
		s_addc_u32 s55, s57, 0
		s_add_u32 s54, s54, s58
		s_addc_u32 s55, s55, s59
		s_add_u32 s56, s54, 0
		s_addc_u32 s57, s55, 0
		s_mov_b32 m0, s56
		v_accvgpr_read_b32 v8, a59
		v_add_u32_e32 v8, s1, v8
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		s_mul_i32 s25, s17, s41
		s_lshl_b32 s25, s25, 1
		s_add_i32 s38, s37, s25
		v_add3_u32 v6, s38, v2, v14
		v_add3_u32 v6, v6, v23, v13
		v_cndmask_b32_e64 v6, v22, v6, s[52:53]
		s_mov_b32 s52, 0x440
		s_mov_b32 s53, 0
		s_mul_i32 s54, s52, s50
		s_mul_hi_u32 s55, s52, s50
		s_mul_i32 s38, s52, s51
		s_add_i32 s55, s55, s38
		s_mul_i32 s38, s53, s50
		s_add_i32 s55, s55, s38
		s_add_u32 s50, s54, 0x81f0
		s_addc_u32 s51, s55, 0
		s_mov_b32 s52, 0x4400
		s_mov_b32 s53, 0
		s_mul_i32 s56, s52, s48
		s_mul_hi_u32 s57, s52, s48
		s_mul_i32 s38, s52, s49
		s_add_i32 s57, s57, s38
		s_mul_i32 s38, s53, s48
		s_add_i32 s57, s57, s38
		s_add_u32 s48, s50, s56
		s_addc_u32 s49, s51, s57
		s_add_u32 s50, s48, 0
		s_addc_u32 s51, s49, 0
		s_mov_b32 m0, s50
		v_accvgpr_read_b32 v9, a60
		v_add_u32_e32 v9, s1, v9
		buffer_load_dwordx4 v6, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[48:49], v8, s20
		s_add_i32 s38, s39, s25
		v_add3_u32 v6, s38, v2, v14
		v_add3_u32 v6, v6, v23, v13
		v_cndmask_b32_e64 v6, v22, v6, s[48:49]
		s_add_u32 s48, s54, 0x92f0
		s_addc_u32 s49, s55, 0
		s_add_u32 s48, s48, s56
		s_addc_u32 s49, s49, s57
		s_add_u32 s50, s48, 0
		s_addc_u32 s51, s49, 0
		s_mov_b32 m0, s50
		v_accvgpr_read_b32 v8, a61
		v_add_u32_e32 v8, s1, v8
		buffer_load_dwordx4 v6, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[48:49], v9, s20
		s_add_i32 s38, s47, s25
		v_add3_u32 v6, s38, v2, v14
		v_add3_u32 v6, v6, v23, v13
		s_add_u32 s50, s54, 0xa3f0
		s_addc_u32 s51, s55, 0
		s_add_u32 s50, s50, s56
		s_addc_u32 s51, s51, s57
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		v_cndmask_b32_e64 v6, v22, v6, s[48:49]
		buffer_load_dwordx4 v6, s[32:35], 0 offen lds
		s_add_i32 s25, s24, s25
		v_add3_u32 v6, s25, v2, v14
		v_cmp_lt_i32_e64 vcc, v8, s20
		v_add3_u32 v6, v6, v23, v13
		s_add_u32 s48, s54, 0xb4f0
		s_addc_u32 s49, s55, 0
		v_cndmask_b32_e32 v6, v22, v6, vcc
		s_add_u32 s48, s48, s56
		s_addc_u32 s49, s49, s57
		s_add_u32 s50, s48, 0
		s_addc_u32 s51, s49, 0
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v6, s[32:35], 0 offen lds
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
		v_add_u32_e32 v6, s41, v5
		v_mfma_f32_32x32x16_bf16 v[96:111], a[132:135], a[44:47], v[96:111]
		v_accvgpr_read_b32 v8, a15
		v_add_u32_e32 v8, s41, v8
		v_mfma_f32_32x32x16_bf16 v[192:207], a[148:151], a[44:47], v[192:207]
		v_accvgpr_read_b32 v9, a16
		v_add_u32_e32 v9, s41, v9
		v_mfma_f32_32x32x16_bf16 v[208:223], a[164:167], a[44:47], v[208:223]
		v_accvgpr_read_b32 v10, a66
		v_add_u32_e32 v10, s41, v10
		v_mfma_f32_32x32x16_bf16 v[112:127], a[136:139], a[32:35], v[112:127]
		v_cmp_ge_i32_e64 vcc, v1, v10
		v_mfma_f32_32x32x16_bf16 v[128:143], a[152:155], a[32:35], v[128:143]
		v_accvgpr_read_b32 v12, a69
		v_add_u32_e32 v12, s41, v12
		v_mfma_f32_32x32x16_bf16 v[144:159], a[168:171], a[32:35], v[144:159]
		v_accvgpr_read_b32 v15, a70
		v_add_u32_e32 v15, s41, v15
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[32:35], v[160:175]
		v_accvgpr_read_b32 v17, a73
		v_add_u32_e32 v17, s41, v17
		v_mfma_f32_32x32x16_bf16 v[176:191], a[180:183], a[48:51], v[176:191]
		v_accvgpr_read_b32 v18, a74
		v_add_u32_e32 v18, s41, v18
		v_mfma_f32_32x32x16_bf16 v[96:111], a[136:139], a[48:51], v[96:111]
		v_accvgpr_read_b32 v20, a77
		v_add_u32_e32 v20, s41, v20
		v_mfma_f32_32x32x16_bf16 v[192:207], a[152:155], a[48:51], v[192:207]
		v_cndmask_b32_e32 v27, v4, v115, vcc
		v_mfma_f32_32x32x16_bf16 v[208:223], a[168:171], a[48:51], v[208:223]
		v_accvgpr_read_b32 v26, a78
		v_add_u32_e32 v28, s41, v26
		v_accvgpr_read_b32 v26, a81
		v_add_u32_e32 v29, s41, v26
		v_accvgpr_read_b32 v26, a82
		v_add_u32_e32 v30, s41, v26
		v_accvgpr_read_b32 v26, a85
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a127, v26
		v_accvgpr_read_b32 v26, a86
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a128, v26
		v_accvgpr_read_b32 v26, a89
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a129, v26
		v_accvgpr_read_b32 v26, a90
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a130, v26
		v_accvgpr_read_b32 v26, a93
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a131, v26
		v_accvgpr_read_b32 v26, a94
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a132, v26
		v_accvgpr_read_b32 v26, a97
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a133, v26
		v_accvgpr_read_b32 v26, a98
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a134, v26
		v_accvgpr_read_b32 v26, a101
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a135, v26
		v_accvgpr_read_b32 v26, a102
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a136, v26
		v_accvgpr_read_b32 v26, a105
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a137, v26
		v_accvgpr_read_b32 v26, a106
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a138, v26
		v_accvgpr_read_b32 v26, a109
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a139, v26
		v_accvgpr_read_b32 v26, a110
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a140, v26
		v_accvgpr_read_b32 v26, a113
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a141, v26
		v_accvgpr_read_b32 v26, a114
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a142, v26
		v_accvgpr_read_b32 v26, a117
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a143, v26
		v_accvgpr_read_b32 v26, a118
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a144, v26
		v_accvgpr_read_b32 v26, a121
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a145, v26
		v_accvgpr_read_b32 v26, a122
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a146, v26
		v_accvgpr_read_b32 v26, a125
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a147, v26
		v_accvgpr_read_b32 v26, a126
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a148, v26
		v_cmp_ge_i32_e64 s[48:49], v1, v6
		v_cmp_ge_i32_e64 s[50:51], v1, v8
		v_cmp_ge_i32_e64 s[52:53], v1, v9
		v_accvgpr_read_b32 v26, a67
		v_add_u32_e32 v31, s41, v26
		v_accvgpr_read_b32 v26, a68
		v_add_u32_e32 v115, s41, v26
		v_cmp_ge_i32_e64 s[54:55], v1, v31
		v_cmp_ge_i32_e64 s[56:57], v1, v115
		v_cmp_ge_i32_e64 s[58:59], v1, v12
		v_cmp_ge_i32_e64 vcc, v1, v15
		v_accvgpr_read_b32 v26, a71
		v_add_u32_e32 v224, s41, v26
		v_accvgpr_read_b32 v26, a72
		v_add_u32_e32 v225, s41, v26
		v_cndmask_b32_e32 v227, v4, v119, vcc
		v_cmp_ge_i32_e64 s[60:61], v1, v224
		v_cmp_ge_i32_e64 s[62:63], v1, v225
		v_cmp_ge_i32_e64 s[64:65], v1, v17
		v_cmp_ge_i32_e64 vcc, v1, v18
		v_accvgpr_read_b32 v26, a75
		v_add_u32_e32 v119, s41, v26
		v_accvgpr_read_b32 v26, a76
		v_add_u32_e32 v228, s41, v26
		v_cndmask_b32_e32 v231, v4, v123, vcc
		v_cmp_ge_i32_e64 s[66:67], v1, v119
		v_cmp_ge_i32_e64 s[68:69], v1, v228
		v_cmp_ge_i32_e64 s[70:71], v1, v20
		v_cmp_ge_i32_e64 vcc, v1, v28
		v_accvgpr_read_b32 v26, a79
		v_add_u32_e32 v123, s41, v26
		v_accvgpr_read_b32 v26, a80
		v_add_u32_e32 v229, s41, v26
		v_cndmask_b32_e32 v233, v4, v127, vcc
		v_cmp_ge_i32_e64 s[72:73], v1, v123
		v_cmp_ge_i32_e64 s[74:75], v1, v229
		v_cmp_ge_i32_e64 s[76:77], v1, v29
		v_cmp_ge_i32_e64 vcc, v1, v30
		v_accvgpr_read_b32 v26, a83
		v_add_u32_e32 v127, s41, v26
		v_accvgpr_read_b32 v26, a84
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a149, v26
		v_cndmask_b32_e32 v235, v4, v131, vcc
		v_cmp_ge_i32_e64 s[78:79], v1, v127
		v_accvgpr_read_b32 v26, a149
		v_cmp_ge_i32_e64 s[80:81], v1, v26
		v_accvgpr_read_b32 v26, a127
		v_cmp_ge_i32_e64 s[82:83], v1, v26
		v_accvgpr_read_b32 v26, a128
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v26, a87
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a150, v26
		v_accvgpr_read_b32 v26, a88
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a151, v26
		v_cndmask_b32_e32 v237, v4, v135, vcc
		v_accvgpr_read_b32 v26, a150
		v_cmp_ge_i32_e64 s[84:85], v1, v26
		v_accvgpr_read_b32 v26, a130
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v26, a91
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a152, v26
		v_accvgpr_read_b32 v26, a92
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a153, v26
		v_cndmask_b32_e32 v239, v4, v139, vcc
		v_accvgpr_read_b32 v26, a132
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v26, a95
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a154, v26
		v_accvgpr_read_b32 v26, a96
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a155, v26
		v_cndmask_b32_e32 v241, v4, v143, vcc
		v_accvgpr_read_b32 v26, a134
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v26, a99
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a156, v26
		v_accvgpr_read_b32 v26, a100
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a157, v26
		v_cndmask_b32_e32 v243, v4, v147, vcc
		v_accvgpr_read_b32 v26, a136
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v26, a103
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a158, v26
		v_accvgpr_read_b32 v26, a104
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a159, v26
		v_cndmask_b32_e32 v245, v4, v151, vcc
		v_accvgpr_read_b32 v26, a138
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v26, a107
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a160, v26
		v_accvgpr_read_b32 v26, a108
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a161, v26
		v_cndmask_b32_e32 v247, v4, v155, vcc
		v_accvgpr_read_b32 v26, a140
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v26, a151
		v_cmp_ge_i32_e64 s[86:87], v1, v26
		v_cndmask_b32_e64 v248, v4, v112, s[48:49]
		v_accvgpr_read_b32 v26, a129
		v_cmp_ge_i32_e64 s[48:49], v1, v26
		v_accvgpr_read_b32 v26, a152
		v_cmp_ge_i32_e64 s[88:89], v1, v26
		s_nop 1
		v_mov_b32_e32 v250, s88
		v_mov_b32_e32 v251, s89
		v_accvgpr_write_b32 a162, v250
		v_accvgpr_write_b32 a163, v251
		v_accvgpr_read_b32 v26, a153
		v_cmp_ge_i32_e64 s[88:89], v1, v26
		s_nop 1
		v_mov_b32_e32 v250, s88
		v_mov_b32_e32 v251, s89
		v_accvgpr_write_b32 a164, v250
		v_accvgpr_write_b32 a165, v251
		v_accvgpr_read_b32 v26, a131
		v_cmp_ge_i32_e64 s[88:89], v1, v26
		s_nop 1
		v_mov_b32_e32 v250, s88
		v_mov_b32_e32 v251, s89
		v_accvgpr_write_b32 a166, v250
		v_accvgpr_write_b32 a167, v251
		v_accvgpr_read_b32 v26, a154
		v_cmp_ge_i32_e64 s[88:89], v1, v26
		s_nop 1
		v_mov_b32_e32 v250, s88
		v_mov_b32_e32 v251, s89
		v_accvgpr_write_b32 a168, v250
		v_accvgpr_write_b32 a169, v251
		v_accvgpr_read_b32 v26, a155
		v_cmp_ge_i32_e64 s[88:89], v1, v26
		s_nop 1
		v_mov_b32_e32 v250, s88
		v_mov_b32_e32 v251, s89
		v_accvgpr_write_b32 a170, v250
		v_accvgpr_write_b32 a171, v251
		v_accvgpr_read_b32 v26, a133
		v_cmp_ge_i32_e64 s[88:89], v1, v26
		s_nop 1
		v_mov_b32_e32 v250, s88
		v_mov_b32_e32 v251, s89
		v_accvgpr_write_b32 a172, v250
		v_accvgpr_write_b32 a173, v251
		v_accvgpr_read_b32 v26, a156
		v_cmp_ge_i32_e64 s[88:89], v1, v26
		s_nop 1
		v_mov_b32_e32 v250, s88
		v_mov_b32_e32 v251, s89
		v_accvgpr_write_b32 a174, v250
		v_accvgpr_write_b32 a175, v251
		v_accvgpr_read_b32 v26, a157
		v_cmp_ge_i32_e64 s[88:89], v1, v26
		s_nop 1
		v_mov_b32_e32 v250, s88
		v_mov_b32_e32 v251, s89
		v_accvgpr_write_b32 a176, v250
		v_accvgpr_write_b32 a177, v251
		v_accvgpr_read_b32 v26, a135
		v_cmp_ge_i32_e64 s[88:89], v1, v26
		s_nop 1
		v_mov_b32_e32 v250, s88
		v_mov_b32_e32 v251, s89
		v_accvgpr_write_b32 a178, v250
		v_accvgpr_write_b32 a179, v251
		v_accvgpr_read_b32 v26, a158
		v_cmp_ge_i32_e64 s[88:89], v1, v26
		s_nop 1
		v_mov_b32_e32 v250, s88
		v_mov_b32_e32 v251, s89
		v_accvgpr_write_b32 a180, v250
		v_accvgpr_write_b32 a181, v251
		v_accvgpr_read_b32 v26, a159
		v_cmp_ge_i32_e64 s[88:89], v1, v26
		s_nop 1
		v_mov_b32_e32 v250, s88
		v_mov_b32_e32 v251, s89
		v_accvgpr_write_b32 a182, v250
		v_accvgpr_write_b32 a183, v251
		v_accvgpr_read_b32 v26, a137
		v_cmp_ge_i32_e64 s[88:89], v1, v26
		v_accvgpr_read_b32 v26, a160
		v_cmp_ge_i32_e64 s[90:91], v1, v26
		v_accvgpr_read_b32 v26, a161
		v_cmp_ge_i32_e64 s[92:93], v1, v26
		v_accvgpr_read_b32 v26, a139
		v_cmp_ge_i32_e64 s[94:95], v1, v26
		v_cndmask_b32_e32 v251, v4, v159, vcc
		v_cndmask_b32_e64 v253, v4, v157, s[92:93]
		v_cndmask_b32_e64 v250, v4, v158, s[94:95]
		v_accvgpr_read_b32 v26, a111
		v_add_u32_e32 v112, s41, v26
		v_accvgpr_read_b32 v26, a112
		v_add_u32_e32 v131, s41, v26
		v_cmp_ge_i32_e64 s[92:93], v1, v112
		v_cmp_ge_i32_e64 s[94:95], v1, v131
		v_accvgpr_read_b32 v26, a141
		v_cmp_ge_i32_e64 s[96:97], v1, v26
		v_cndmask_b32_e64 v158, v4, v160, s[92:93]
		v_cndmask_b32_e64 v159, v4, v161, s[94:95]
		v_cndmask_b32_e64 v160, v4, v162, s[96:97]
		v_accvgpr_read_b32 v26, a142
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v26, a115
		v_add_u32_e32 v135, s41, v26
		v_accvgpr_read_b32 v26, a116
		v_add_u32_e32 v139, s41, v26
		v_cndmask_b32_e32 v161, v4, v163, vcc
		v_cmp_ge_i32_e64 s[92:93], v1, v135
		v_cmp_ge_i32_e64 s[94:95], v1, v139
		v_accvgpr_read_b32 v26, a143
		v_cmp_ge_i32_e64 s[96:97], v1, v26
		v_cndmask_b32_e64 v162, v4, v164, s[92:93]
		v_cndmask_b32_e64 v163, v4, v165, s[94:95]
		v_cndmask_b32_e64 v164, v4, v166, s[96:97]
		v_accvgpr_read_b32 v26, a144
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v26, a119
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a248, v26
		v_accvgpr_read_b32 v26, a120
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a249, v26
		v_cndmask_b32_e32 v165, v4, v167, vcc
		v_accvgpr_read_b32 v26, a248
		v_cmp_ge_i32_e64 s[92:93], v1, v26
		v_accvgpr_read_b32 v26, a249
		v_cmp_ge_i32_e64 s[94:95], v1, v26
		v_accvgpr_read_b32 v26, a145
		v_cmp_ge_i32_e64 s[96:97], v1, v26
		v_cndmask_b32_e64 v166, v4, v168, s[92:93]
		v_cndmask_b32_e64 v167, v4, v169, s[94:95]
		v_cndmask_b32_e64 v168, v4, v170, s[96:97]
		v_accvgpr_read_b32 v26, a146
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v26, a123
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a250, v26
		v_accvgpr_read_b32 v26, a124
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a251, v26
		v_cndmask_b32_e32 v169, v4, v171, vcc
		v_accvgpr_read_b32 v26, a250
		v_cmp_ge_i32_e64 s[92:93], v1, v26
		v_accvgpr_read_b32 v26, a251
		v_cmp_ge_i32_e64 s[94:95], v1, v26
		v_accvgpr_read_b32 v26, a147
		v_cmp_ge_i32_e64 s[96:97], v1, v26
		v_cndmask_b32_e64 v170, v4, v172, s[92:93]
		v_cndmask_b32_e64 v171, v4, v173, s[94:95]
		v_cndmask_b32_e64 v172, v4, v174, s[96:97]
		v_cndmask_b32_e64 v249, v4, v113, s[50:51]
		v_accvgpr_read_b32 v26, a148
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_max3_f32 v26, v158, v159, v160
		v_accvgpr_write_b32 a252, v26
		v_max3_f32 v26, v162, v163, v164
		v_accvgpr_write_b32 a253, v26
		v_cndmask_b32_e32 v173, v4, v175, vcc
		v_cmp_ge_i32_e64 s[50:51], v3, v6
		v_cmp_ge_i32_e64 s[92:93], v3, v8
		v_cmp_ge_i32_e64 s[94:95], v3, v9
		v_max3_f32 v6, v166, v167, v168
		v_accvgpr_write_b32 a254, v6
		v_max3_f32 v6, v170, v171, v172
		v_accvgpr_write_b32 a255, v6
		v_cndmask_b32_e64 v8, v4, v98, s[94:95]
		v_cmp_ge_i32_e64 vcc, v3, v10
		v_cndmask_b32_e64 v26, v4, v114, s[52:53]
		v_mov_b32_e32 v6, 0xff800000
		v_cndmask_b32_e64 v174, v6, v116, s[54:55]
		v_cndmask_b32_e32 v9, v6, v99, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v31
		v_cmp_ge_i32_e64 s[54:55], v3, v115
		v_cmp_ge_i32_e64 s[94:95], v3, v12
		v_cndmask_b32_e64 v98, v6, v100, s[52:53]
		v_cndmask_b32_e64 v99, v6, v101, s[54:55]
		v_cndmask_b32_e64 v100, v6, v102, s[94:95]
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_cndmask_b32_e64 v175, v6, v117, s[56:57]
		v_cndmask_b32_e64 v226, v6, v118, s[58:59]
		v_cndmask_b32_e64 v114, v6, v120, s[60:61]
		v_cndmask_b32_e32 v101, v6, v103, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v224
		v_cmp_ge_i32_e64 s[54:55], v3, v225
		v_cmp_ge_i32_e64 s[56:57], v3, v17
		v_cndmask_b32_e64 v102, v6, v104, s[52:53]
		v_cndmask_b32_e64 v103, v6, v105, s[54:55]
		v_cndmask_b32_e64 v104, v6, v106, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_cndmask_b32_e64 v115, v6, v121, s[62:63]
		v_max3_f32 v10, v248, v249, v26
		v_cndmask_b32_e32 v105, v6, v107, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v119
		v_cmp_ge_i32_e64 s[54:55], v3, v228
		v_cmp_ge_i32_e64 s[56:57], v3, v20
		v_cndmask_b32_e64 v106, v6, v108, s[52:53]
		v_cndmask_b32_e64 v107, v6, v109, s[54:55]
		v_cndmask_b32_e64 v108, v6, v110, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v28
		v_cndmask_b32_e64 v230, v6, v122, s[64:65]
		v_cndmask_b32_e64 v116, v6, v124, s[66:67]
		v_cndmask_b32_e32 v109, v6, v111, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v123
		v_cmp_ge_i32_e64 s[54:55], v3, v229
		v_cmp_ge_i32_e64 s[56:57], v3, v29
		v_cndmask_b32_e64 v28, v6, v192, s[52:53]
		v_cndmask_b32_e64 v29, v6, v193, s[54:55]
		v_cndmask_b32_e64 v110, v6, v194, s[56:57]
		v_cmp_ge_i32_e64 vcc, v3, v30
		v_cndmask_b32_e64 v117, v6, v125, s[68:69]
		v_cndmask_b32_e64 v232, v6, v126, s[70:71]
		v_cndmask_b32_e64 v30, v6, v128, s[72:73]
		v_cndmask_b32_e32 v111, v6, v195, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v127
		v_accvgpr_read_b32 v12, a149
		v_cmp_ge_i32_e64 s[54:55], v3, v12
		v_accvgpr_read_b32 v12, a127
		v_cmp_ge_i32_e64 s[56:57], v3, v12
		v_cndmask_b32_e64 v118, v6, v196, s[52:53]
		v_cndmask_b32_e64 v119, v6, v197, s[54:55]
		v_cndmask_b32_e64 v120, v6, v198, s[56:57]
		v_accvgpr_read_b32 v12, a128
		v_cmp_ge_i32_e64 vcc, v3, v12
		v_cndmask_b32_e64 v31, v6, v129, s[74:75]
		v_max3_f32 v12, v174, v175, v226
		v_cndmask_b32_e32 v121, v6, v199, vcc
		v_accvgpr_read_b32 v15, a150
		v_cmp_ge_i32_e64 s[52:53], v3, v15
		v_accvgpr_read_b32 v15, a151
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_accvgpr_read_b32 v15, a129
		v_cmp_ge_i32_e64 s[56:57], v3, v15
		v_cndmask_b32_e64 v122, v6, v200, s[52:53]
		v_cndmask_b32_e64 v123, v6, v201, s[54:55]
		v_cndmask_b32_e64 v124, v6, v202, s[56:57]
		v_accvgpr_read_b32 v15, a130
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_cndmask_b32_e64 v234, v6, v130, s[76:77]
		v_cndmask_b32_e64 v126, v6, v132, s[78:79]
		v_cndmask_b32_e32 v125, v6, v203, vcc
		v_accvgpr_read_b32 v15, a152
		v_cmp_ge_i32_e64 s[52:53], v3, v15
		v_accvgpr_read_b32 v15, a153
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_accvgpr_read_b32 v15, a131
		v_cmp_ge_i32_e64 s[56:57], v3, v15
		v_cndmask_b32_e64 v128, v6, v204, s[52:53]
		v_cndmask_b32_e64 v129, v6, v205, s[54:55]
		v_cndmask_b32_e64 v192, v6, v206, s[56:57]
		v_accvgpr_read_b32 v15, a132
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_cndmask_b32_e64 v127, v6, v133, s[80:81]
		v_cndmask_b32_e64 v236, v6, v134, s[82:83]
		v_cndmask_b32_e32 v193, v6, v207, vcc
		v_accvgpr_read_b32 v15, a154
		v_cmp_ge_i32_e64 s[52:53], v3, v15
		v_accvgpr_read_b32 v15, a134
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_cndmask_b32_e64 v132, v6, v136, s[84:85]
		v_accvgpr_read_b32 v15, a155
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_accvgpr_read_b32 v15, a133
		v_cmp_ge_i32_e64 s[56:57], v3, v15
		v_cndmask_b32_e64 v194, v6, v208, s[52:53]
		v_cndmask_b32_e64 v195, v6, v209, s[54:55]
		v_cndmask_b32_e64 v196, v6, v210, s[56:57]
		v_cndmask_b32_e64 v133, v6, v137, s[86:87]
		v_cndmask_b32_e32 v197, v6, v211, vcc
		v_accvgpr_read_b32 v15, a156
		v_cmp_ge_i32_e64 s[52:53], v3, v15
		v_accvgpr_read_b32 v15, a157
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_accvgpr_read_b32 v15, a135
		v_cmp_ge_i32_e64 s[56:57], v3, v15
		v_cndmask_b32_e64 v136, v6, v212, s[52:53]
		v_cndmask_b32_e64 v137, v6, v213, s[54:55]
		v_cndmask_b32_e64 v198, v6, v214, s[56:57]
		v_accvgpr_read_b32 v15, a136
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_cndmask_b32_e64 v238, v6, v138, s[48:49]
		v_accvgpr_read_b32 v15, a162
		s_nop 0
		v_readfirstlane_b32 s48, v15
		v_accvgpr_read_b32 v15, a163
		s_nop 0
		v_readfirstlane_b32 s49, v15
		s_nop 1
		v_cndmask_b32_e64 v200, v6, v140, s[48:49]
		v_cndmask_b32_e32 v199, v6, v215, vcc
		v_accvgpr_read_b32 v15, a158
		v_cmp_ge_i32_e64 s[48:49], v3, v15
		v_accvgpr_read_b32 v15, a159
		v_cmp_ge_i32_e64 s[52:53], v3, v15
		v_accvgpr_read_b32 v15, a137
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_cndmask_b32_e64 v202, v6, v216, s[48:49]
		v_cndmask_b32_e64 v203, v6, v217, s[52:53]
		v_cndmask_b32_e64 v204, v6, v218, s[54:55]
		v_accvgpr_read_b32 v15, a138
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_accvgpr_read_b32 v15, a164
		s_nop 0
		v_readfirstlane_b32 s48, v15
		v_accvgpr_read_b32 v15, a165
		s_nop 0
		v_readfirstlane_b32 s49, v15
		s_nop 1
		v_cndmask_b32_e64 v201, v6, v141, s[48:49]
		v_accvgpr_read_b32 v15, a166
		s_nop 0
		v_readfirstlane_b32 s48, v15
		v_accvgpr_read_b32 v15, a167
		s_nop 0
		v_readfirstlane_b32 s49, v15
		s_nop 1
		v_cndmask_b32_e64 v240, v6, v142, s[48:49]
		v_cndmask_b32_e32 v205, v6, v219, vcc
		v_accvgpr_read_b32 v15, a160
		v_cmp_ge_i32_e64 s[48:49], v3, v15
		v_accvgpr_read_b32 v15, a161
		v_cmp_ge_i32_e64 s[52:53], v3, v15
		v_accvgpr_read_b32 v15, a139
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_cndmask_b32_e64 v140, v6, v220, s[48:49]
		v_cndmask_b32_e64 v141, v6, v221, s[52:53]
		v_cndmask_b32_e64 v142, v6, v222, s[54:55]
		v_accvgpr_read_b32 v15, a140
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_accvgpr_read_b32 v15, a168
		s_nop 0
		v_readfirstlane_b32 s48, v15
		v_accvgpr_read_b32 v15, a169
		s_nop 0
		v_readfirstlane_b32 s49, v15
		s_nop 1
		v_cndmask_b32_e64 v206, v6, v144, s[48:49]
		v_accvgpr_read_b32 v15, a170
		s_nop 0
		v_readfirstlane_b32 s48, v15
		v_accvgpr_read_b32 v15, a171
		s_nop 0
		v_readfirstlane_b32 s49, v15
		s_nop 1
		v_cndmask_b32_e64 v207, v6, v145, s[48:49]
		v_cndmask_b32_e32 v143, v6, v223, vcc
		v_cmp_ge_i32_e64 s[48:49], v3, v112
		v_cmp_ge_i32_e64 s[52:53], v3, v131
		v_accvgpr_read_b32 v15, a141
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_cndmask_b32_e64 v112, v6, v176, s[48:49]
		v_cndmask_b32_e64 v113, v6, v177, s[52:53]
		v_cndmask_b32_e64 v130, v6, v178, s[54:55]
		v_accvgpr_read_b32 v15, a142
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_accvgpr_read_b32 v15, a172
		s_nop 0
		v_readfirstlane_b32 s48, v15
		v_accvgpr_read_b32 v15, a173
		s_nop 0
		v_readfirstlane_b32 s49, v15
		s_nop 1
		v_cndmask_b32_e64 v242, v6, v146, s[48:49]
		v_accvgpr_read_b32 v15, a174
		s_nop 0
		v_readfirstlane_b32 s48, v15
		v_accvgpr_read_b32 v15, a175
		s_nop 0
		v_readfirstlane_b32 s49, v15
		s_nop 1
		v_cndmask_b32_e64 v144, v6, v148, s[48:49]
		v_cndmask_b32_e32 v131, v6, v179, vcc
		v_cmp_ge_i32_e64 s[48:49], v3, v135
		v_cmp_ge_i32_e64 s[52:53], v3, v139
		v_accvgpr_read_b32 v15, a143
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_cndmask_b32_e64 v134, v6, v180, s[48:49]
		v_cndmask_b32_e64 v135, v6, v181, s[52:53]
		v_cndmask_b32_e64 v138, v6, v182, s[54:55]
		v_accvgpr_read_b32 v15, a144
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_accvgpr_read_b32 v15, a176
		s_nop 0
		v_readfirstlane_b32 s48, v15
		v_accvgpr_read_b32 v15, a177
		s_nop 0
		v_readfirstlane_b32 s49, v15
		s_nop 1
		v_cndmask_b32_e64 v145, v6, v149, s[48:49]
		v_accvgpr_read_b32 v15, a178
		s_nop 0
		v_readfirstlane_b32 s48, v15
		v_accvgpr_read_b32 v15, a179
		s_nop 0
		v_readfirstlane_b32 s49, v15
		s_nop 1
		v_cndmask_b32_e64 v244, v6, v150, s[48:49]
		v_cndmask_b32_e32 v139, v6, v183, vcc
		v_accvgpr_read_b32 v15, a248
		v_cmp_ge_i32_e64 s[48:49], v3, v15
		v_accvgpr_read_b32 v15, a249
		v_cmp_ge_i32_e64 s[52:53], v3, v15
		v_accvgpr_read_b32 v15, a145
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_cndmask_b32_e64 v146, v6, v184, s[48:49]
		v_cndmask_b32_e64 v147, v6, v185, s[52:53]
		v_cndmask_b32_e64 v148, v6, v186, s[54:55]
		v_accvgpr_read_b32 v15, a146
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_accvgpr_read_b32 v15, a180
		s_nop 0
		v_readfirstlane_b32 s48, v15
		v_accvgpr_read_b32 v15, a181
		s_nop 0
		v_readfirstlane_b32 s49, v15
		s_nop 1
		v_cndmask_b32_e64 v150, v6, v152, s[48:49]
		v_accvgpr_read_b32 v15, a182
		s_nop 0
		v_readfirstlane_b32 s48, v15
		v_accvgpr_read_b32 v15, a183
		s_nop 0
		v_readfirstlane_b32 s49, v15
		s_nop 1
		v_cndmask_b32_e64 v151, v6, v153, s[48:49]
		v_cndmask_b32_e32 v149, v6, v187, vcc
		v_accvgpr_read_b32 v15, a250
		v_cmp_ge_i32_e64 s[48:49], v3, v15
		v_accvgpr_read_b32 v15, a251
		v_cmp_ge_i32_e64 s[52:53], v3, v15
		v_accvgpr_read_b32 v15, a147
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_cndmask_b32_e64 v152, v6, v188, s[48:49]
		v_cndmask_b32_e64 v153, v6, v189, s[52:53]
		v_cndmask_b32_e64 v176, v6, v190, s[54:55]
		v_accvgpr_read_b32 v15, a148
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_cndmask_b32_e64 v246, v6, v154, s[88:89]
		v_cndmask_b32_e64 v252, v6, v156, s[90:91]
		v_cndmask_b32_e32 v177, v6, v191, vcc
		v_max3_f32 v15, v114, v115, v230
		v_max3_f32 v17, v116, v117, v232
		v_max3_f32 v18, v30, v31, v234
		v_max3_f32 v20, v126, v127, v236
		v_max3_f32 v154, v132, v133, v238
		v_max3_f32 v155, v200, v201, v240
		v_max3_f32 v156, v206, v207, v242
		v_max3_f32 v157, v144, v145, v244
		v_max3_f32 v178, v150, v151, v246
		v_max3_f32 v179, v252, v253, v250
		v_max3_f32 v10, v10, v27, v12
		v_max3_f32 v12, v15, v231, v17
		v_max3_f32 v15, v18, v235, v20
		v_max3_f32 v17, v154, v239, v155
		v_max3_f32 v18, v156, v243, v157
		v_max3_f32 v20, v178, v247, v179
		v_accvgpr_read_b32 v154, a252
		v_accvgpr_read_b32 v155, a253
		v_max3_f32 v154, v154, v161, v155
		v_accvgpr_read_b32 v155, a254
		v_accvgpr_read_b32 v156, a255
		v_max3_f32 v155, v155, v169, v156
		v_max3_f32 v10, v10, v227, v12
		v_max3_f32 v12, v15, v237, v17
		v_max3_f32 v15, v18, v245, v20
		v_max3_f32 v17, v154, v165, v155
		v_max3_f32 v10, v10, v233, v12
		v_max3_f32 v12, v15, v251, v17
		v_max3_f32 v10, v10, v241, v12
		v_max_f32_e32 v154, v10, v173
		v_mov_b32_e32 v155, v154
		v_cndmask_b32_e64 v156, v6, v96, s[50:51]
		v_cndmask_b32_e64 v157, v6, v97, s[92:93]
		v_permlane32_swap_b32_e32 v154, v155
		v_max3_f32 v6, v156, v157, v8
		v_max3_f32 v10, v98, v99, v100
		v_max3_f32 v12, v102, v103, v104
		v_max3_f32 v15, v106, v107, v108
		v_max3_f32 v17, v28, v29, v110
		v_max3_f32 v18, v118, v119, v120
		v_max3_f32 v20, v122, v123, v124
		v_max3_f32 v96, v128, v129, v192
		v_max3_f32 v97, v194, v195, v196
		v_max3_f32 v178, v136, v137, v198
		v_max3_f32 v179, v202, v203, v204
		v_max3_f32 v180, v140, v141, v142
		v_max3_f32 v181, v112, v113, v130
		v_max3_f32 v182, v134, v135, v138
		v_max3_f32 v183, v146, v147, v148
		v_max3_f32 v184, v152, v153, v176
		v_max3_f32 v6, v6, v9, v10
		v_max3_f32 v10, v12, v105, v15
		v_max3_f32 v12, v17, v111, v18
		v_max3_f32 v15, v20, v125, v96
		v_max3_f32 v17, v97, v197, v178
		v_max3_f32 v18, v179, v205, v180
		v_max3_f32 v20, v181, v131, v182
		v_max3_f32 v96, v183, v149, v184
		v_max3_f32 v6, v6, v101, v10
		v_max3_f32 v10, v12, v121, v15
		v_max3_f32 v12, v17, v199, v18
		v_max3_f32 v15, v20, v139, v96
		v_max3_f32 v6, v6, v109, v10
		v_max3_f32 v10, v12, v143, v15
		v_max3_f32 v6, v6, v193, v10
		v_max_f32_e32 v96, v6, v177
		v_mov_b32_e32 v97, v96
		v_max_f32_e32 v178, v154, v155
		v_mov_b32_e32 v154, v7
		v_permlane32_swap_b32_e32 v96, v97
		v_max_f32_e32 v179, v96, v97
		v_mov_b32_e32 v96, 0x3e38aa3b
		v_mov_b32_e32 v97, 0x3e38aa3b
		v_pk_mul_f32 v[180:181], v[178:179], v[96:97]
		v_max_f32_e32 v178, v7, v180
		v_max_f32_e32 v179, v11, v181
		v_pk_fma_f32 v[6:7], v[248:249], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[26:27], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[174:175], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[226:227], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[114:115], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[230:231], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[116:117], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[232:233], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[30:31], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[234:235], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[126:127], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[236:237], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[132:133], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[238:239], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[200:201], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[240:241], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[206:207], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[242:243], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[144:145], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[244:245], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[150:151], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[246:247], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[252:253], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[218:219], v[250:251], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[220:221], v[158:159], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[160:161], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[162:163], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[164:165], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[166:167], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[168:169], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[170:171], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[172:173], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[156:157], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[8:9], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[8:9], v[98:99], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[108:109], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[28:29], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[110:111], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[118:119], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[120:121], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[122:123], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[124:125], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[128:129], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[192:193], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[194:195], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[196:197], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[136:137], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[198:199], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[202:203], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[204:205], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[140:141], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[142:143], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[112:113], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[130:131], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[134:135], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[138:139], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[146:147], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[148:149], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[152:153], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[176:177], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v96, v6
		v_exp_f32_e32 v176, v7
		v_exp_f32_e32 v6, v180
		v_exp_f32_e32 v222, v181
		v_exp_f32_e32 v180, v26
		v_exp_f32_e32 v224, v27
		v_exp_f32_e32 v26, v174
		v_exp_f32_e32 v226, v175
		v_exp_f32_e32 v174, v182
		v_exp_f32_e32 v228, v183
		v_exp_f32_e32 v182, v114
		v_exp_f32_e32 v230, v115
		v_exp_f32_e32 v114, v184
		v_exp_f32_e32 v232, v185
		v_exp_f32_e32 v184, v116
		v_exp_f32_e32 v234, v117
		v_exp_f32_e32 v116, v186
		v_exp_f32_e32 v236, v187
		v_exp_f32_e32 v186, v30
		v_exp_f32_e32 v238, v31
		v_exp_f32_e32 v30, v188
		v_exp_f32_e32 v240, v189
		v_exp_f32_e32 v188, v126
		v_exp_f32_e32 v242, v127
		v_exp_f32_e32 v126, v190
		v_exp_f32_e32 v244, v191
		v_exp_f32_e32 v190, v132
		v_exp_f32_e32 v246, v133
		v_exp_f32_e32 v132, v208
		v_exp_f32_e32 v248, v209
		v_exp_f32_e32 v208, v200
		v_exp_f32_e32 v250, v201
		v_exp_f32_e32 v97, v210
		v_exp_f32_e32 v177, v211
		v_exp_f32_e32 v7, v206
		v_exp_f32_e32 v223, v207
		v_exp_f32_e32 v181, v212
		v_exp_f32_e32 v225, v213
		v_exp_f32_e32 v27, v144
		v_exp_f32_e32 v227, v145
		v_exp_f32_e32 v175, v214
		v_exp_f32_e32 v229, v215
		v_exp_f32_e32 v183, v150
		v_exp_f32_e32 v231, v151
		v_exp_f32_e32 v115, v216
		v_exp_f32_e32 v233, v217
		v_exp_f32_e32 v185, v218
		v_exp_f32_e32 v235, v219
		v_exp_f32_e32 v117, v220
		v_exp_f32_e32 v237, v221
		v_exp_f32_e32 v187, v158
		v_exp_f32_e32 v239, v159
		v_exp_f32_e32 v31, v160
		v_exp_f32_e32 v241, v161
		v_exp_f32_e32 v189, v162
		v_exp_f32_e32 v243, v163
		v_exp_f32_e32 v127, v164
		v_exp_f32_e32 v245, v165
		v_exp_f32_e32 v191, v166
		v_exp_f32_e32 v247, v167
		v_exp_f32_e32 v133, v168
		v_exp_f32_e32 v249, v169
		v_exp_f32_e32 v209, v170
		v_exp_f32_e32 v251, v171
		v_exp_f32_e32 v144, v172
		v_exp_f32_e32 v150, v173
		v_exp_f32_e32 v158, v156
		v_exp_f32_e32 v160, v157
		v_exp_f32_e32 v156, v8
		v_exp_f32_e32 v162, v9
		v_exp_f32_e32 v8, v98
		v_exp_f32_e32 v164, v99
		v_exp_f32_e32 v98, v100
		v_exp_f32_e32 v166, v101
		v_exp_f32_e32 v100, v102
		v_exp_f32_e32 v168, v103
		v_exp_f32_e32 v102, v104
		v_exp_f32_e32 v170, v105
		v_exp_f32_e32 v104, v106
		v_exp_f32_e32 v172, v107
		v_exp_f32_e32 v106, v108
		v_exp_f32_e32 v200, v109
		v_exp_f32_e32 v108, v28
		v_exp_f32_e32 v206, v29
		v_exp_f32_e32 v28, v110
		v_exp_f32_e32 v210, v111
		v_exp_f32_e32 v110, v118
		v_exp_f32_e32 v212, v119
		v_exp_f32_e32 v118, v120
		v_exp_f32_e32 v214, v121
		v_exp_f32_e32 v120, v122
		v_exp_f32_e32 v216, v123
		v_exp_f32_e32 v122, v124
		v_exp_f32_e32 v218, v125
		v_exp_f32_e32 v124, v128
		v_exp_f32_e32 v220, v129
		v_exp_f32_e32 v145, v192
		v_exp_f32_e32 v151, v193
		v_exp_f32_e32 v159, v194
		v_exp_f32_e32 v161, v195
		v_exp_f32_e32 v157, v196
		v_exp_f32_e32 v163, v197
		v_exp_f32_e32 v9, v136
		v_exp_f32_e32 v165, v137
		v_exp_f32_e32 v99, v198
		v_exp_f32_e32 v167, v199
		v_exp_f32_e32 v101, v202
		v_exp_f32_e32 v169, v203
		v_exp_f32_e32 v103, v204
		v_exp_f32_e32 v171, v205
		v_exp_f32_e32 v105, v140
		v_exp_f32_e32 v173, v141
		v_exp_f32_e32 v107, v142
		v_exp_f32_e32 v201, v143
		v_exp_f32_e32 v109, v112
		v_exp_f32_e32 v207, v113
		v_exp_f32_e32 v29, v130
		v_exp_f32_e32 v211, v131
		v_exp_f32_e32 v111, v134
		v_exp_f32_e32 v213, v135
		v_exp_f32_e32 v119, v138
		v_exp_f32_e32 v215, v139
		v_exp_f32_e32 v121, v146
		v_exp_f32_e32 v217, v147
		v_exp_f32_e32 v123, v148
		v_exp_f32_e32 v219, v149
		v_exp_f32_e32 v125, v152
		v_exp_f32_e32 v221, v153
		v_pk_add_f32 v[112:113], v[96:97], v[176:177]
		v_pk_add_f32 v[128:129], v[6:7], v[222:223]
		v_pk_add_f32 v[130:131], v[180:181], v[224:225]
		v_pk_add_f32 v[134:135], v[26:27], v[226:227]
		v_pk_add_f32 v[136:137], v[174:175], v[228:229]
		v_pk_add_f32 v[138:139], v[182:183], v[230:231]
		v_pk_add_f32 v[140:141], v[114:115], v[232:233]
		v_pk_add_f32 v[142:143], v[184:185], v[234:235]
		v_pk_add_f32 v[146:147], v[116:117], v[236:237]
		v_pk_add_f32 v[148:149], v[186:187], v[238:239]
		v_pk_add_f32 v[152:153], v[30:31], v[240:241]
		v_pk_add_f32 v[192:193], v[188:189], v[242:243]
		v_pk_add_f32 v[194:195], v[126:127], v[244:245]
		v_pk_add_f32 v[196:197], v[190:191], v[246:247]
		v_pk_add_f32 v[198:199], v[132:133], v[248:249]
		v_pk_add_f32 v[202:203], v[208:209], v[250:251]
		v_pk_add_f32 v[112:113], v[112:113], v[128:129]
		v_pk_add_f32 v[128:129], v[130:131], v[134:135]
		v_pk_add_f32 v[130:131], v[136:137], v[138:139]
		v_pk_add_f32 v[134:135], v[140:141], v[142:143]
		v_pk_add_f32 v[136:137], v[146:147], v[148:149]
		v_pk_add_f32 v[138:139], v[152:153], v[192:193]
		v_pk_add_f32 v[140:141], v[194:195], v[196:197]
		v_pk_add_f32 v[142:143], v[198:199], v[202:203]
		v_pk_add_f32 v[112:113], v[112:113], v[128:129]
		v_pk_add_f32 v[128:129], v[130:131], v[134:135]
		v_pk_add_f32 v[130:131], v[136:137], v[138:139]
		v_pk_add_f32 v[134:135], v[140:141], v[142:143]
		v_pk_add_f32 v[112:113], v[112:113], v[128:129]
		v_pk_add_f32 v[128:129], v[130:131], v[134:135]
		v_pk_add_f32 v[130:131], v[112:113], v[128:129]
		v_add_f32_e32 v10, v130, v131
		v_accvgpr_read_b32 v12, a64
		ds_bpermute_b32 v112, v12, v10
		v_accvgpr_read_b32 v12, a65
		ds_bpermute_b32 v128, v12, v10
		v_pk_add_f32 v[130:131], v[144:145], v[150:151]
		v_pk_add_f32 v[134:135], v[158:159], v[160:161]
		v_pk_add_f32 v[136:137], v[156:157], v[162:163]
		v_pk_add_f32 v[138:139], v[8:9], v[164:165]
		v_pk_add_f32 v[140:141], v[98:99], v[166:167]
		v_pk_add_f32 v[142:143], v[100:101], v[168:169]
		v_pk_add_f32 v[146:147], v[102:103], v[170:171]
		v_pk_add_f32 v[148:149], v[104:105], v[172:173]
		v_pk_add_f32 v[152:153], v[106:107], v[200:201]
		v_pk_add_f32 v[192:193], v[108:109], v[206:207]
		v_pk_add_f32 v[194:195], v[28:29], v[210:211]
		v_pk_add_f32 v[196:197], v[110:111], v[212:213]
		v_pk_add_f32 v[198:199], v[118:119], v[214:215]
		v_pk_add_f32 v[202:203], v[120:121], v[216:217]
		v_pk_add_f32 v[204:205], v[122:123], v[218:219]
		v_pk_add_f32 v[252:253], v[124:125], v[220:221]
		v_pk_add_f32 v[130:131], v[130:131], v[134:135]
		v_pk_add_f32 v[134:135], v[136:137], v[138:139]
		v_pk_add_f32 v[136:137], v[140:141], v[142:143]
		v_pk_add_f32 v[138:139], v[146:147], v[148:149]
		v_pk_add_f32 v[140:141], v[152:153], v[192:193]
		v_pk_add_f32 v[142:143], v[194:195], v[196:197]
		v_pk_add_f32 v[146:147], v[198:199], v[202:203]
		v_pk_add_f32 v[148:149], v[204:205], v[252:253]
		v_pk_add_f32 v[130:131], v[130:131], v[134:135]
		v_pk_add_f32 v[134:135], v[136:137], v[138:139]
		v_pk_add_f32 v[136:137], v[140:141], v[142:143]
		v_pk_add_f32 v[138:139], v[146:147], v[148:149]
		v_pk_add_f32 v[130:131], v[130:131], v[134:135]
		v_pk_add_f32 v[134:135], v[136:137], v[138:139]
		v_pk_add_f32 v[136:137], v[130:131], v[134:135]
		v_mov_b32_e32 v129, v137
		v_mov_b32_e32 v113, v136
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[130:131], v[112:113], v[128:129]
		v_mov_b32_e32 v112, v131
		v_mov_b32_e32 v113, v131
		v_cvt_pk_bf16_f32 v136, v96, v176
		v_cvt_pk_bf16_f32 v137, v6, v222
		v_permlane32_swap_b32_e32 v112, v113
		v_add_f32_e32 v129, v112, v113
		v_mov_b32_e32 v155, v11
		v_pk_add_f32 v[10:11], v[154:155], v[178:179] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v112, v10
		v_exp_f32_e32 v113, v11
		v_cvt_pk_bf16_f32 v138, v180, v224
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
		v_mov_b64_e32 v[10:11], v[24:25]
		v_pk_fma_f32 v[24:25], v[10:11], v[112:113], v[128:129]
		v_cvt_pk_bf16_f32 v139, v26, v226
		v_cvt_pk_bf16_f32 v128, v174, v228
		v_cvt_pk_bf16_f32 v129, v182, v230
		v_cvt_pk_bf16_f32 v130, v114, v232
		v_cvt_pk_bf16_f32 v131, v184, v234
		v_cvt_pk_bf16_f32 v140, v116, v236
		v_cvt_pk_bf16_f32 v141, v186, v238
		v_cvt_pk_bf16_f32 v142, v30, v240
		v_cvt_pk_bf16_f32 v143, v188, v242
		v_cvt_pk_bf16_f32 v152, v126, v244
		v_cvt_pk_bf16_f32 v153, v190, v246
		v_cvt_pk_bf16_f32 v154, v132, v248
		v_cvt_pk_bf16_f32 v155, v208, v250
		v_cvt_pk_bf16_f32 v192, v97, v177
		v_cvt_pk_bf16_f32 v193, v7, v223
		v_cvt_pk_bf16_f32 v194, v181, v225
		v_cvt_pk_bf16_f32 v195, v27, v227
		v_cvt_pk_bf16_f32 v196, v175, v229
		v_cvt_pk_bf16_f32 v197, v183, v231
		v_cvt_pk_bf16_f32 v198, v115, v233
		v_cvt_pk_bf16_f32 v199, v185, v235
		v_cvt_pk_bf16_f32 v112, v117, v237
		v_cvt_pk_bf16_f32 v113, v187, v239
		v_cvt_pk_bf16_f32 v114, v31, v241
		v_cvt_pk_bf16_f32 v115, v189, v243
		v_cvt_pk_bf16_f32 v180, v127, v245
		v_cvt_pk_bf16_f32 v181, v191, v247
		v_cvt_pk_bf16_f32 v182, v133, v249
		v_cvt_pk_bf16_f32 v183, v209, v251
		v_cvt_pk_bf16_f32 v132, v144, v150
		v_cvt_pk_bf16_f32 v133, v158, v160
		v_cvt_pk_bf16_f32 v134, v156, v162
		v_cvt_pk_bf16_f32 v135, v8, v164
		v_cvt_pk_bf16_f32 v184, v98, v166
		v_cvt_pk_bf16_f32 v185, v100, v168
		v_cvt_pk_bf16_f32 v186, v102, v170
		v_cvt_pk_bf16_f32 v187, v104, v172
		v_cvt_pk_bf16_f32 v188, v106, v200
		v_cvt_pk_bf16_f32 v189, v108, v206
		v_cvt_pk_bf16_f32 v190, v28, v210
		v_cvt_pk_bf16_f32 v191, v110, v212
		v_cvt_pk_bf16_f32 v224, v118, v214
		v_cvt_pk_bf16_f32 v225, v120, v216
		v_cvt_pk_bf16_f32 v226, v122, v218
		v_cvt_pk_bf16_f32 v227, v124, v220
		v_cvt_pk_bf16_f32 v228, v145, v151
		v_cvt_pk_bf16_f32 v229, v159, v161
		v_cvt_pk_bf16_f32 v230, v157, v163
		v_cvt_pk_bf16_f32 v231, v9, v165
		v_cvt_pk_bf16_f32 v8, v99, v167
		v_cvt_pk_bf16_f32 v9, v101, v169
		v_cvt_pk_bf16_f32 v10, v103, v171
		v_cvt_pk_bf16_f32 v11, v105, v173
		v_cvt_pk_bf16_f32 v96, v107, v201
		v_cvt_pk_bf16_f32 v97, v109, v207
		v_cvt_pk_bf16_f32 v98, v29, v211
		v_cvt_pk_bf16_f32 v99, v111, v213
		v_cvt_pk_bf16_f32 v28, v119, v215
		v_cvt_pk_bf16_f32 v29, v121, v217
		v_cvt_pk_bf16_f32 v30, v123, v219
		v_cvt_pk_bf16_f32 v31, v125, v221
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[32:47], a[184:187], v[136:139], v[32:47]
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_mfma_f32_32x32x16_bf16 v[48:63], a[216:219], v[136:139], v[48:63]
		v_permlane32_swap_b32_e32 v152, v154
		v_permlane32_swap_b32_e32 v153, v155
		v_mfma_f32_32x32x16_bf16 v[32:47], a[188:191], v[128:131], v[32:47]
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_mfma_f32_32x32x16_bf16 v[48:63], a[220:223], v[128:131], v[48:63]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[140:143], v[32:47]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[140:143], v[48:63]
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[152:155], v[32:47]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[152:155], v[48:63]
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_mfma_f32_32x32x16_bf16 v[80:95], a[216:219], v[132:135], v[80:95]
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[64:79], a[184:187], v[132:135], v[64:79]
		v_permlane32_swap_b32_e32 v224, v226
		v_permlane32_swap_b32_e32 v225, v227
		v_mfma_f32_32x32x16_bf16 v[80:95], a[220:223], v[184:187], v[80:95]
		v_permlane32_swap_b32_e32 v228, v230
		v_permlane32_swap_b32_e32 v229, v231
		v_mfma_f32_32x32x16_bf16 v[64:79], a[188:191], v[184:187], v[64:79]
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[188:191], v[80:95]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[188:191], v[64:79]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[224:227], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[224:227], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[192:195], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[192:195], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[228:231], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[228:231], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[196:199], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[196:199], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[8:11], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[8:11], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[112:115], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[112:115], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[180:183], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[180:183], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[28:31], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[28:31], v[64:79]
		s_cselect_b32 s1, 1, 0
		s_add_i32 s25, s41, 0x80
		s_cmp_lg_u32 s1, 0
		s_mov_b32 s41, s25
		v_mov_b32_e32 v7, v178
		v_mov_b32_e32 v11, v179
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_2
.L_attn_fwd_persistent.loop_exit_2:
		s_mov_b32 s28, s8
		s_mov_b32 s29, s9
		s_mov_b32 s30, s42
		s_mov_b32 s31, s43
		v_rcp_f32_e32 v2, v24
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
		s_nop 0
		v_readfirstlane_b32 s23, v1
		v_accvgpr_read_b32 v1, a4
		s_nop 0
		v_readfirstlane_b32 s24, v1
		s_mul_i32 s23, s24, s23
		s_lshl_b32 s23, s23, 6
		s_add_i32 s21, s21, s23
		v_and_b32_e32 v1, 31, v0
		v_accvgpr_read_b32 v2, a4
		s_nop 0
		v_readfirstlane_b32 s24, v2
		s_nop 1
		v_mul_lo_u32 v1, s24, v1
		v_lshl_add_u32 v2, v1, 1, s21
		v_accvgpr_read_b32 v3, a17
		v_lshl_add_u32 v2, v3, 4, v2
		v_accvgpr_read_b32 v3, a52
		s_nop 0
		v_readfirstlane_b32 s24, v3
		v_accvgpr_read_b32 v3, a53
		s_nop 0
		v_readfirstlane_b32 s25, v3
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_8
		buffer_store_dwordx4 v[40:43], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_8:
		s_andn2_b64 exec, s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_8
.L_attn_fwd_persistent.exec_endif_8:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s21, s1, 32
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		s_add_i32 s21, s21, s23
		v_lshl_add_u32 v2, v1, 1, s21
		v_accvgpr_read_b32 v3, a17
		v_lshl_add_u32 v2, v3, 4, v2
		v_accvgpr_read_b32 v3, a52
		s_nop 0
		v_readfirstlane_b32 s24, v3
		v_accvgpr_read_b32 v3, a53
		s_nop 0
		v_readfirstlane_b32 s25, v3
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_9
		buffer_store_dwordx4 v[8:11], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_9:
		s_andn2_b64 exec, s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_9
.L_attn_fwd_persistent.exec_endif_9:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s21, s1, 64
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		s_add_i32 s21, s21, s23
		v_lshl_add_u32 v2, v1, 1, s21
		v_accvgpr_read_b32 v3, a17
		v_lshl_add_u32 v2, v3, 4, v2
		v_accvgpr_read_b32 v3, a52
		s_nop 0
		v_readfirstlane_b32 s24, v3
		v_accvgpr_read_b32 v3, a53
		s_nop 0
		v_readfirstlane_b32 s25, v3
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_10
		buffer_store_dwordx4 v[12:15], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_10:
		s_andn2_b64 exec, s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_10
.L_attn_fwd_persistent.exec_endif_10:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s21, s1, 0x60
		s_add_i32 s21, s21, s18
		s_add_i32 s21, s21, s22
		s_add_i32 s21, s21, s23
		v_lshl_add_u32 v2, v1, 1, s21
		v_accvgpr_read_b32 v3, a17
		v_lshl_add_u32 v2, v3, 4, v2
		v_accvgpr_read_b32 v3, a52
		s_nop 0
		v_readfirstlane_b32 s24, v3
		v_accvgpr_read_b32 v3, a53
		s_nop 0
		v_readfirstlane_b32 s25, v3
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_11
		buffer_store_dwordx4 v[16:19], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_11:
		s_andn2_b64 exec, s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_11
.L_attn_fwd_persistent.exec_endif_11:
		s_mov_b64 exec, s[100:101]
		v_accvgpr_read_b32 v2, a4
		s_nop 0
		v_readfirstlane_b32 s21, v2
		s_lshl_b32 s21, s21, 8
		s_add_i32 s24, s21, s1
		s_add_i32 s24, s24, s18
		s_add_i32 s24, s24, s22
		s_add_i32 s24, s24, s23
		v_lshl_add_u32 v2, v1, 1, s24
		v_accvgpr_read_b32 v3, a17
		v_lshl_add_u32 v2, v3, 4, v2
		v_accvgpr_read_b32 v3, a54
		s_nop 0
		v_readfirstlane_b32 s24, v3
		v_accvgpr_read_b32 v3, a55
		s_nop 0
		v_readfirstlane_b32 s25, v3
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_12
		buffer_store_dwordx4 v[20:23], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_12:
		s_andn2_b64 exec, s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_12
.L_attn_fwd_persistent.exec_endif_12:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s24, s21, 32
		s_add_i32 s24, s24, s1
		s_add_i32 s24, s24, s18
		s_add_i32 s24, s24, s22
		s_add_i32 s24, s24, s23
		v_lshl_add_u32 v2, v1, 1, s24
		v_accvgpr_read_b32 v3, a17
		v_lshl_add_u32 v2, v3, 4, v2
		v_accvgpr_read_b32 v3, a54
		s_nop 0
		v_readfirstlane_b32 s24, v3
		v_accvgpr_read_b32 v3, a55
		s_nop 0
		v_readfirstlane_b32 s25, v3
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_13
		buffer_store_dwordx4 v[4:7], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_13:
		s_andn2_b64 exec, s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_13
.L_attn_fwd_persistent.exec_endif_13:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s24, s21, 64
		s_add_i32 s24, s24, s1
		s_add_i32 s24, s24, s18
		s_add_i32 s24, s24, s22
		s_add_i32 s24, s24, s23
		v_lshl_add_u32 v2, v1, 1, s24
		v_accvgpr_read_b32 v3, a17
		v_lshl_add_u32 v2, v3, 4, v2
		v_accvgpr_read_b32 v3, a54
		s_nop 0
		v_readfirstlane_b32 s24, v3
		v_accvgpr_read_b32 v3, a55
		s_nop 0
		v_readfirstlane_b32 s25, v3
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_14
		buffer_store_dwordx4 v[24:27], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_14:
		s_andn2_b64 exec, s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_14
.L_attn_fwd_persistent.exec_endif_14:
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
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_15
		buffer_store_dwordx4 v[28:31], v1, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_15:
		s_andn2_b64 exec, s[100:101], s[22:23]
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
		v_accvgpr_write_b32 a13, v1
		v_accvgpr_read_b32 v1, a13
		s_nop 0
		v_readfirstlane_b32 s1, v1
		s_mul_i32 s1, s1, 0x100
		v_readfirstlane_b32 s18, v0
		s_lshr_b32 s18, s18, 6
		s_nop 0
		v_mov_b32_e32 v1, s18
		v_accvgpr_write_b32 a14, v1
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
		v_cmp_lt_i32_e64 s[28:29], v16, s19
		v_cmp_lt_i32_e64 s[30:31], v17, s19
		v_cmp_lt_i32_e64 s[32:33], v18, s19
		v_cmp_lt_i32_e64 s[34:35], v19, s19
		v_cmp_lt_i32_e64 s[36:37], v20, s19
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
		s_add_i32 s26, s18, s21
		v_accvgpr_read_b32 v8, a12
		s_nop 0
		v_readfirstlane_b32 s38, v8
		s_mul_i32 s38, s38, s11
		s_lshl_b32 s38, s38, 1
		s_add_i32 s26, s26, s38
		v_mul_lo_u32 v8, s12, v6
		v_lshl_add_u32 v11, v8, 1, s26
		v_and_b32_e32 v13, 7, v0
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[100:101], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_16
		buffer_load_dwordx4 v[20:23], v11, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_16:
		s_andn2_b64 exec, s[100:101], s[22:23]
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
		s_add_i32 s22, s22, s38
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_17
		buffer_load_dwordx4 v[24:27], v11, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_17:
		s_andn2_b64 exec, s[100:101], s[24:25]
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
		s_add_i32 s22, s22, s38
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_18
		buffer_load_dwordx4 v[28:31], v11, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_18:
		s_andn2_b64 exec, s[100:101], s[28:29]
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
		s_add_i32 s22, s22, s38
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[100:101], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_19
		buffer_load_dwordx4 v[32:35], v11, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_19:
		s_andn2_b64 exec, s[100:101], s[30:31]
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
		s_add_i32 s22, s22, s38
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[100:101], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_20
		buffer_load_dwordx4 v[36:39], v11, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_20:
		s_andn2_b64 exec, s[100:101], s[32:33]
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
		s_add_i32 s22, s22, s38
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[100:101], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_21
		buffer_load_dwordx4 v[40:43], v11, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_21:
		s_andn2_b64 exec, s[100:101], s[34:35]
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
		s_add_i32 s22, s22, s38
		v_lshl_add_u32 v11, v8, 1, s22
		v_lshl_add_u32 v11, v13, 4, v11
		s_and_saveexec_b64 s[100:101], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_22
		buffer_load_dwordx4 v[44:47], v11, s[40:43], 0 offen
.L_attn_fwd_persistent.exec_else_22:
		s_andn2_b64 exec, s[100:101], s[36:37]
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
		s_add_i32 s18, s18, s38
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
		v_accvgpr_read_b32 v3, a14
		s_nop 0
		v_readfirstlane_b32 s18, v3
		s_and_b32 s18, s18, 1
		s_lshl_b32 s18, s18, 2
		v_and_b32_e32 v3, 1, v9
		v_xor_b32_e32 v8, s18, v3
		v_bitop3_b32 v1, v0, v1, v8 bitop3:0x96
		v_lshlrev_b32_e32 v1, 4, v1
		v_add_u32_e32 v1, 0x10000, v1
		ds_write_b128 v1, v[20:23] offset:18864
		ds_write_b128 v1, v[24:27] offset:22960
		ds_write_b128 v1, v[28:31] offset:27056
		ds_write_b128 v1, v[32:35] offset:31152
		v_mov_b32_e32 v8, 32
		v_mul_lo_u32 v8, v8, v10
		v_mov_b32_e32 v9, 2
		v_mul_lo_u32 v9, v9, v14
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v10, a14
		s_nop 0
		v_readfirstlane_b32 s18, v10
		s_lshl_b32 s18, s18, 12
		s_add_i32 s18, s18, 0x10000
		v_and_b32_e32 v10, 63, v0
		v_and_b32_e32 v11, 7, v10
		v_lshrrev_b32_e32 v14, 2, v11
		v_lshl_add_u32 v15, v14, 5, s18
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
		v_lshl_add_u32 v20, v16, 6, s18
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
		v_lshl_add_u32 v11, v11, 4, s18
		ds_read_b128 a[32:35], v11 offset:18864
		v_and_b32_e32 v6, 1, v6
		v_lshlrev_b32_e32 v13, 4, v13
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
		ds_read_b128 a[48:51], v11 offset:18864
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
		v_mov_b32_e32 v11, 16
		v_mul_lo_u32 v11, v11, v4
		v_bitop3_b32 v14, v1, v8, v11 bitop3:0x96
		v_bitop3_b32 v14, v14, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a18, v14
		v_bitop3_b32 v14, 4, v1, v8 bitop3:0x96
		v_xor_b32_e32 v14, v14, v11
		v_bitop3_b32 v15, 8, v1, v8 bitop3:0x96
		v_xor_b32_e32 v15, v15, v11
		v_bitop3_b32 v1, 12, v1, v8 bitop3:0x96
		v_accvgpr_read_b32 v16, a18
		v_cmp_lt_i32_e64 s[24:25], v16, s20
		v_mov_b32_e32 v16, 16
		v_mul_lo_u32 v16, v16, v7
		v_mov_b32_e32 v7, 64
		v_mul_lo_u32 v7, v7, v4
		v_bitop3_b32 v4, v16, v8, v7 bitop3:0x96
		v_bitop3_b32 v4, v4, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a19, v4
		v_bitop3_b32 v4, 4, v16, v8 bitop3:0x96
		v_bitop3_b32 v17, 8, v16, v8 bitop3:0x96
		v_bitop3_b32 v8, 12, v16, v8 bitop3:0x96
		v_accvgpr_read_b32 v16, a19
		v_cmp_lt_i32_e64 vcc, v16, s20
		v_readfirstlane_b32 s36, v0
		v_accvgpr_read_b32 v16, a11
		s_nop 0
		v_readfirstlane_b32 s26, v16
		s_mul_i32 s26, s26, s13
		s_lshl_b32 s26, s26, 1
		v_accvgpr_read_b32 v16, a12
		s_nop 0
		v_readfirstlane_b32 s37, v16
		s_mul_i32 s37, s37, s14
		s_lshl_b32 s37, s37, 1
		s_add_i32 s38, s26, s37
		v_accvgpr_read_b32 v16, a14
		s_nop 0
		v_readfirstlane_b32 s39, v16
		s_mul_i32 s39, s15, s39
		s_lshl_b32 s39, s39, 1
		s_add_i32 s38, s38, s39
		v_accvgpr_read_b32 v16, a17
		v_mul_lo_u32 v16, s15, v16
		v_lshlrev_b32_e32 v16, 5, v16
		v_mul_lo_u32 v19, s15, v3
		v_lshlrev_b32_e32 v19, 6, v19
		v_add3_u32 v20, s38, v16, v19
		v_mul_lo_u32 v21, s15, v6
		v_lshlrev_b32_e32 v21, 7, v21
		v_add3_u32 v20, v20, v21, v13
		v_mov_b32_e32 v22, 0x80000000
		v_cndmask_b32_e64 v20, v22, v20, s[24:25]
		s_lshr_b32 s38, s36, 6
		s_mul_i32 s40, 0x410, s38
		s_mov_b32 m0, s40
		v_accvgpr_read_b32 v23, a15
		v_add_u32_e32 v23, s1, v23
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[44:45], v23, s19
		s_nop 1
		v_mov_b32_e32 v24, s44
		v_mov_b32_e32 v25, s45
		v_accvgpr_write_b32 a52, v24
		v_accvgpr_write_b32 a53, v25
		s_lshl_b32 s41, s15, 3
		s_add_i32 s41, s41, s26
		s_add_i32 s41, s41, s37
		s_add_i32 s41, s41, s39
		v_add3_u32 v20, s41, v16, v19
		v_add3_u32 v20, v20, v21, v13
		v_cndmask_b32_e64 v20, v22, v20, s[24:25]
		s_add_i32 m0, m0, 0x1040
		v_accvgpr_read_b32 v23, a16
		v_add_u32_e32 v23, s1, v23
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[44:45], v23, s19
		s_nop 1
		v_mov_b32_e32 v24, s44
		v_mov_b32_e32 v25, s45
		v_accvgpr_write_b32 a54, v24
		v_accvgpr_write_b32 a55, v25
		s_lshl_b32 s41, s15, 4
		s_add_i32 s41, s41, s26
		s_add_i32 s41, s41, s37
		s_add_i32 s41, s41, s39
		v_add3_u32 v20, s41, v16, v19
		v_add3_u32 v20, v20, v21, v13
		v_cndmask_b32_e64 v20, v22, v20, s[24:25]
		s_add_i32 m0, m0, 0x1040
		v_lshlrev_b32_e32 v18, 4, v18
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		v_bitop3_b32 v14, v14, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a56, v14
		s_mul_i32 s41, 24, s15
		s_add_i32 s41, s41, s26
		s_add_i32 s41, s41, s37
		s_add_i32 s41, s41, s39
		v_add3_u32 v14, s41, v16, v19
		v_add3_u32 v14, v14, v21, v13
		v_cndmask_b32_e64 v14, v22, v14, s[24:25]
		s_add_i32 m0, m0, 0x1040
		v_mov_b32_e32 v20, 0x440
		v_mul_lo_u32 v20, v20, v2
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		v_bitop3_b32 v2, v15, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a57, v2
		v_accvgpr_read_b32 v2, a0
		s_nop 0
		v_readfirstlane_b32 s24, v2
		v_accvgpr_read_b32 v2, a11
		s_nop 0
		v_readfirstlane_b32 s25, v2
		s_mul_i32 s24, s25, s24
		s_lshl_b32 s24, s24, 1
		v_accvgpr_read_b32 v2, a1
		s_nop 0
		v_readfirstlane_b32 s25, v2
		v_accvgpr_read_b32 v2, a12
		s_nop 0
		v_readfirstlane_b32 s41, v2
		s_mul_i32 s25, s41, s25
		s_lshl_b32 s25, s25, 1
		s_add_i32 s41, s24, s25
		v_accvgpr_read_b32 v2, a14
		s_nop 0
		v_readfirstlane_b32 s44, v2
		s_mul_i32 s44, s17, s44
		s_lshl_b32 s44, s44, 1
		s_add_i32 s41, s41, s44
		v_accvgpr_read_b32 v2, a17
		v_mul_lo_u32 v2, s17, v2
		v_lshlrev_b32_e32 v2, 7, v2
		v_mul_lo_u32 v14, s17, v3
		v_lshlrev_b32_e32 v14, 6, v14
		v_add3_u32 v15, s41, v2, v14
		v_mul_lo_u32 v23, s17, v6
		v_lshlrev_b32_e32 v23, 5, v23
		v_add3_u32 v15, v15, v23, v13
		v_cndmask_b32_e32 v15, v22, v15, vcc
		s_mul_i32 s38, 0x440, s38
		s_add_i32 m0, s38, 0x81f0
		v_xor_b32_e32 v1, v1, v11
		buffer_load_dwordx4 v15, s[32:35], 0 offen lds
		v_bitop3_b32 v1, v1, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a58, v1
		s_lshl_b32 s41, s17, 3
		s_add_i32 s41, s41, s24
		s_add_i32 s41, s41, s25
		s_add_i32 s41, s41, s44
		v_add3_u32 v1, s41, v2, v14
		v_add3_u32 v1, v1, v23, v13
		v_cndmask_b32_e32 v1, v22, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v4, v4, v7
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_bitop3_b32 v1, v4, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a59, v1
		s_lshl_b32 s41, s17, 4
		s_add_i32 s41, s41, s24
		s_add_i32 s41, s41, s25
		s_add_i32 s41, s41, s44
		v_add3_u32 v1, s41, v2, v14
		v_add3_u32 v1, v1, v23, v13
		v_cndmask_b32_e32 v1, v22, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v4, v17, v7
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_bitop3_b32 v1, v4, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a60, v1
		s_mul_i32 s41, 24, s17
		s_add_i32 s41, s41, s24
		s_add_i32 s41, s41, s25
		s_add_i32 s41, s41, s44
		v_add3_u32 v1, s41, v2, v14
		v_add3_u32 v1, v1, v23, v13
		v_cndmask_b32_e32 v1, v22, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v4, v8, v7
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_bitop3_b32 v1, v4, v12, v9 bitop3:0x96
		v_accvgpr_write_b32 a61, v1
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
		v_add_u32_e32 v4, 32, v1
		v_mov_b32_e32 v8, 0x3e38aa3b
		v_mov_b32_e32 v9, 0x3e38aa3b
		s_mov_b32 s25, 0xff800000
		v_mov_b32_e32 v7, s25
		v_mov_b32_e32 v11, s25
		s_mov_b32 s25, 1.0
		v_mov_b32_e32 v24, s25
		v_mov_b32_e32 v25, s25
		s_mov_b32 s25, 0
		v_lshrrev_b32_e32 v12, 4, v10
		v_lshlrev_b32_e32 v12, 9, v12
		v_and_b32_e32 v10, 15, v10
		v_mov_b32_e32 v15, 0x410
		v_mul_lo_u32 v15, v15, v10
		v_add3_u32 v10, v18, v12, v15
		v_accvgpr_write_b32 a62, v10
		v_and_b32_e32 v10, 3, v0
		v_accvgpr_read_b32 v12, a17
		v_mov_b32_e32 v15, 0x2200
		v_mul_lo_u32 v15, v15, v12
		v_lshl_add_u32 v10, v10, 3, v15
		v_lshl_add_u32 v3, v3, 5, v10
		v_mov_b32_e32 v10, 0x880
		v_mul_lo_u32 v10, v10, v6
		v_add3_u32 v3, v3, v10, v20
		v_accvgpr_write_b32 a63, v3
		v_lshlrev_b32_e32 v1, 2, v1
		v_accvgpr_write_b32 a64, v1
		v_lshlrev_b32_e32 v1, 2, v4
		v_accvgpr_write_b32 a65, v1
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
		v_accvgpr_read_b32 v1, a62
		v_add_u32_e32 v1, s49, v1
		ds_read_b128 v[28:31], v1
		ds_read_b128 v[96:99], v1 offset:32
		ds_read_b128 v[100:103], v1 offset:64
		ds_read_b128 a[68:71], v1 offset:96
		ds_read_b128 v[104:107], v1 offset:256
		ds_read_b128 v[108:111], v1 offset:288
		ds_read_b128 v[112:115], v1 offset:320
		ds_read_b128 a[72:75], v1 offset:352
		ds_read_b128 v[116:119], v1 offset:128
		ds_read_b128 v[120:123], v1 offset:160
		ds_read_b128 v[124:127], v1 offset:192
		ds_read_b128 a[76:79], v1 offset:224
		ds_read_b128 v[128:131], v1 offset:384
		ds_read_b128 v[132:135], v1 offset:416
		ds_read_b128 a[80:83], v1 offset:448
		ds_read_b128 a[84:87], v1 offset:480
		s_mul_i32 s44, 0x4400, s44
		v_accvgpr_read_b32 v1, a63
		v_add_u32_e32 v1, s44, v1
		ds_read_b64_tr_b16 a[88:89], v1 offset:33264
		ds_read_b64_tr_b16 a[90:91], v1 offset:37616
		ds_read_b64_tr_b16 a[92:93], v1 offset:33392
		ds_read_b64_tr_b16 a[94:95], v1 offset:37744
		ds_read_b64_tr_b16 a[96:97], v1 offset:33520
		ds_read_b64_tr_b16 a[98:99], v1 offset:37872
		ds_read_b64_tr_b16 a[100:101], v1 offset:33648
		ds_read_b64_tr_b16 a[102:103], v1 offset:38000
		ds_read_b64_tr_b16 a[104:105], v1 offset:33776
		ds_read_b64_tr_b16 a[106:107], v1 offset:38128
		ds_read_b64_tr_b16 a[108:109], v1 offset:33904
		ds_read_b64_tr_b16 a[110:111], v1 offset:38256
		ds_read_b64_tr_b16 a[112:113], v1 offset:34032
		ds_read_b64_tr_b16 a[114:115], v1 offset:38384
		ds_read_b64_tr_b16 a[116:117], v1 offset:34160
		ds_read_b64_tr_b16 a[118:119], v1 offset:38512
		ds_read_b64_tr_b16 a[120:121], v1 offset:33328
		ds_read_b64_tr_b16 a[122:123], v1 offset:37680
		ds_read_b64_tr_b16 a[124:125], v1 offset:33456
		ds_read_b64_tr_b16 a[126:127], v1 offset:37808
		ds_read_b64_tr_b16 a[128:129], v1 offset:33584
		ds_read_b64_tr_b16 a[130:131], v1 offset:37936
		ds_read_b64_tr_b16 a[132:133], v1 offset:33712
		ds_read_b64_tr_b16 a[134:135], v1 offset:38064
		ds_read_b64_tr_b16 a[136:137], v1 offset:33840
		ds_read_b64_tr_b16 a[138:139], v1 offset:38192
		ds_read_b64_tr_b16 a[140:141], v1 offset:33968
		ds_read_b64_tr_b16 a[142:143], v1 offset:38320
		ds_read_b64_tr_b16 a[144:145], v1 offset:34096
		ds_read_b64_tr_b16 a[146:147], v1 offset:38448
		ds_read_b64_tr_b16 a[148:149], v1 offset:34224
		ds_read_b64_tr_b16 a[150:151], v1 offset:38576
		s_mul_i32 s44, s15, s25
		s_lshl_b32 s44, s44, 1
		s_add_i32 s49, s23, s44
		v_add3_u32 v1, s49, v16, v19
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[20:23], 0
		v_add3_u32 v1, v1, v21, v13
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
		v_add3_u32 v3, s49, v16, v19
		v_mfma_f32_32x32x16_bf16 v[176:191], v[112:115], a[28:31], v[176:191]
		v_add3_u32 v3, v3, v21, v13
		v_mfma_f32_32x32x16_bf16 v[192:207], v[104:107], a[36:39], 0
		s_add_i32 s49, s46, s44
		v_mfma_f32_32x32x16_bf16 v[192:207], v[108:111], a[40:43], v[192:207]
		v_add3_u32 v4, s49, v16, v19
		v_mfma_f32_32x32x16_bf16 v[192:207], v[112:115], a[44:47], v[192:207]
		v_add3_u32 v4, v4, v21, v13
		v_mfma_f32_32x32x16_bf16 v[96:111], v[116:119], a[20:23], 0
		s_add_i32 s44, s26, s44
		v_mfma_f32_32x32x16_bf16 v[96:111], v[120:123], a[24:27], v[96:111]
		v_add3_u32 v6, s44, v16, v19
		v_mfma_f32_32x32x16_bf16 v[96:111], v[124:127], a[28:31], v[96:111]
		v_add3_u32 v6, v6, v21, v13
		v_mfma_f32_32x32x16_bf16 v[208:223], v[116:119], a[36:39], 0
		s_mul_i32 s44, s17, s25
		v_mfma_f32_32x32x16_bf16 v[208:223], v[120:123], a[40:43], v[208:223]
		s_add_i32 s25, s25, 0x80
		v_mfma_f32_32x32x16_bf16 v[208:223], v[124:127], a[44:47], v[208:223]
		v_accvgpr_read_b32 v10, a18
		v_add_u32_e32 v10, s25, v10
		v_mfma_f32_32x32x16_bf16 v[112:127], v[128:131], a[20:23], 0
		v_accvgpr_read_b32 v12, a56
		v_add_u32_e32 v12, s25, v12
		v_mfma_f32_32x32x16_bf16 v[112:127], v[132:135], a[24:27], v[112:127]
		v_accvgpr_read_b32 v15, a57
		v_add_u32_e32 v15, s25, v15
		v_mfma_f32_32x32x16_bf16 v[112:127], a[80:83], a[28:31], v[112:127]
		v_accvgpr_read_b32 v17, a58
		v_add_u32_e32 v17, s25, v17
		v_mfma_f32_32x32x16_bf16 v[224:239], v[128:131], a[36:39], 0
		v_cmp_lt_i32_e64 s[50:51], v10, s20
		v_accvgpr_read_b32 v10, a19
		v_add_u32_e32 v10, s25, v10
		v_accvgpr_read_b32 v18, a59
		v_add_u32_e32 v18, s25, v18
		v_accvgpr_read_b32 v20, a60
		v_add_u32_e32 v20, s25, v20
		v_accvgpr_read_b32 v26, a61
		v_add_u32_e32 v26, s25, v26
		v_cmp_lt_i32_e64 vcc, v26, s20
		v_cndmask_b32_e64 v1, v22, v1, s[50:51]
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[50:51], v12, s20
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[52:53], v15, s20
		v_cndmask_b32_e64 v1, v22, v3, s[50:51]
		v_cmp_lt_i32_e64 s[50:51], v17, s20
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], v[132:135], a[40:43], v[224:239]
		v_cndmask_b32_e64 v1, v22, v4, s[52:53]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[80:83], a[44:47], v[224:239]
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v3, v22, v6, s[50:51]
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[50:51], v10, s20
		v_cmp_lt_i32_e64 s[52:53], v18, s20
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s44, s44, 1
		s_add_i32 s49, s39, s44
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[144:159], a[68:71], a[32:35], v[144:159]
		v_add3_u32 v1, s49, v2, v14
		v_mfma_f32_32x32x16_bf16 v[160:175], a[68:71], a[48:51], v[160:175]
		v_add3_u32 v1, v1, v23, v13
		v_cndmask_b32_e64 v1, v22, v1, s[50:51]
		v_cmp_lt_i32_e64 s[50:51], v20, s20
		s_mul_i32 s37, 0x4400, s37
		s_add_i32 s37, s38, s37
		s_add_i32 m0, s37, 0x81f0
		s_add_i32 s37, s47, s44
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_add3_u32 v1, s37, v2, v14
		v_add3_u32 v1, v1, v23, v13
		v_cndmask_b32_e64 v1, v22, v1, s[52:53]
		v_max3_f32 v3, v144, v145, v146
		s_add_i32 m0, m0, 0x1100
		s_add_i32 s37, s48, s44
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_add3_u32 v1, s37, v2, v14
		v_add3_u32 v1, v1, v23, v13
		v_max3_f32 v4, v148, v149, v150
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v1, v22, v1, s[50:51]
		buffer_load_dwordx4 v1, s[32:35], 0 offen lds
		v_max3_f32 v1, v152, v153, v154
		s_add_i32 s37, s24, s44
		v_add3_u32 v6, s37, v2, v14
		v_add3_u32 v6, v6, v23, v13
		v_cndmask_b32_e32 v6, v22, v6, vcc
		v_max3_f32 v10, v156, v157, v158
		s_add_i32 m0, m0, 0x1100
		v_max3_f32 v3, v3, v147, v4
		v_max3_f32 v1, v1, v155, v10
		v_max3_f32 v1, v3, v151, v1
		v_max3_f32 v3, v160, v161, v162
		v_max3_f32 v4, v164, v165, v166
		v_max3_f32 v10, v168, v169, v170
		v_max3_f32 v12, v172, v173, v174
		v_max3_f32 v3, v3, v163, v4
		v_max3_f32 v4, v10, v171, v12
		v_max3_f32 v3, v3, v167, v4
		s_cmp_lt_i32 s25, s41
		buffer_load_dwordx4 v6, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[176:191], a[72:75], a[32:35], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[76:79], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[84:87], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[84:87], a[48:51], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[72:75], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[76:79], a[48:51], v[208:223]
		s_nop 6
		v_max3_f32 v4, v176, v177, v178
		v_max3_f32 v6, v180, v181, v182
		v_max3_f32 v10, v184, v185, v186
		v_max3_f32 v12, v188, v189, v190
		v_max3_f32 v15, v96, v97, v98
		v_max3_f32 v17, v100, v101, v102
		v_max3_f32 v18, v104, v105, v106
		v_max3_f32 v20, v108, v109, v110
		v_max3_f32 v26, v112, v113, v114
		v_max3_f32 v27, v116, v117, v118
		v_max3_f32 v28, v120, v121, v122
		v_max3_f32 v29, v124, v125, v126
		v_max3_f32 v4, v4, v179, v6
		v_max3_f32 v6, v10, v187, v12
		v_max3_f32 v10, v15, v99, v17
		v_max3_f32 v12, v18, v107, v20
		v_max3_f32 v15, v26, v115, v27
		v_max3_f32 v17, v28, v123, v29
		v_max3_f32 v4, v4, v183, v6
		v_max3_f32 v6, v10, v103, v12
		v_max3_f32 v10, v15, v119, v17
		v_max3_f32 v1, v1, v159, v4
		v_max3_f32 v4, v6, v111, v10
		v_max3_f32 v1, v1, v191, v4
		v_max_f32_e32 v26, v1, v127
		v_mov_b32_e32 v27, v26
		v_max3_f32 v1, v192, v193, v194
		v_max3_f32 v4, v196, v197, v198
		v_max3_f32 v6, v200, v201, v202
		v_max3_f32 v10, v204, v205, v206
		v_max3_f32 v12, v208, v209, v210
		v_max3_f32 v15, v212, v213, v214
		v_max3_f32 v17, v216, v217, v218
		v_max3_f32 v18, v220, v221, v222
		v_max3_f32 v20, v224, v225, v226
		v_max3_f32 v28, v228, v229, v230
		v_max3_f32 v29, v232, v233, v234
		v_max3_f32 v30, v236, v237, v238
		v_max3_f32 v1, v1, v195, v4
		v_max3_f32 v4, v6, v203, v10
		v_max3_f32 v6, v12, v211, v15
		v_max3_f32 v10, v17, v219, v18
		v_permlane32_swap_b32_e32 v26, v27
		v_max3_f32 v12, v20, v227, v28
		v_max3_f32 v15, v29, v235, v30
		v_max3_f32 v1, v1, v199, v4
		v_max3_f32 v4, v6, v215, v10
		v_max3_f32 v6, v12, v231, v15
		v_max3_f32 v1, v3, v175, v1
		v_max3_f32 v3, v4, v223, v6
		v_max3_f32 v1, v1, v207, v3
		v_max_f32_e32 v28, v1, v239
		v_mov_b32_e32 v29, v28
		v_max_f32_e32 v30, v26, v27
		v_mov_b32_e32 v26, v7
		v_permlane32_swap_b32_e32 v28, v29
		v_max_f32_e32 v31, v28, v29
		v_pk_mul_f32 v[28:29], v[30:31], v[8:9]
		v_max_f32_e32 v30, v7, v28
		v_max_f32_e32 v31, v11, v29
		v_pk_fma_f32 v[6:7], v[144:145], v[8:9], v[30:31] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
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
		v_exp_f32_e32 v220, v6
		v_exp_f32_e32 v222, v7
		v_exp_f32_e32 v6, v28
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
		v_exp_f32_e32 v7, v96
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
		v_pk_add_f32 v[188:189], v[6:7], v[224:225]
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
		v_add_f32_e32 v1, v190, v191
		v_accvgpr_read_b32 v3, a64
		ds_bpermute_b32 v186, v3, v1
		v_accvgpr_read_b32 v3, a65
		ds_bpermute_b32 v188, v3, v1
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
		v_accvgpr_write_b32 a66, v218
		v_accvgpr_write_b32 a67, v219
		v_pk_add_f32 v[218:219], v[182:183], v[184:185]
		v_pk_add_f32 v[190:191], v[190:191], v[192:193]
		v_pk_add_f32 v[192:193], v[194:195], v[196:197]
		v_pk_add_f32 v[194:195], v[198:199], v[200:201]
		v_pk_add_f32 v[196:197], v[202:203], v[204:205]
		v_pk_add_f32 v[198:199], v[206:207], v[208:209]
		v_pk_add_f32 v[200:201], v[210:211], v[212:213]
		v_pk_add_f32 v[202:203], v[214:215], v[216:217]
		v_accvgpr_read_b32 v204, a66
		v_accvgpr_read_b32 v205, a67
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
		v_cvt_pk_bf16_f32 v193, v6, v224
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
		v_cvt_pk_bf16_f32 v205, v7, v225
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
		v_mfma_f32_32x32x16_bf16 v[32:47], a[88:91], v[192:195], v[32:47]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[48:63], a[120:123], v[192:195], v[48:63]
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_mfma_f32_32x32x16_bf16 v[32:47], a[92:95], v[188:191], v[32:47]
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_mfma_f32_32x32x16_bf16 v[48:63], a[124:127], v[188:191], v[48:63]
		v_permlane32_swap_b32_e32 v208, v210
		v_permlane32_swap_b32_e32 v209, v211
		v_mfma_f32_32x32x16_bf16 v[32:47], a[96:99], v[196:199], v[32:47]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[48:63], a[128:131], v[196:199], v[48:63]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[32:47], a[100:103], v[200:203], v[32:47]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[48:63], a[132:135], v[200:203], v[48:63]
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_mfma_f32_32x32x16_bf16 v[80:95], a[120:123], v[136:139], v[80:95]
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_mfma_f32_32x32x16_bf16 v[64:79], a[88:91], v[136:139], v[64:79]
		v_permlane32_swap_b32_e32 v148, v150
		v_permlane32_swap_b32_e32 v149, v151
		v_mfma_f32_32x32x16_bf16 v[80:95], a[124:127], v[140:143], v[80:95]
		v_permlane32_swap_b32_e32 v212, v214
		v_permlane32_swap_b32_e32 v213, v215
		v_mfma_f32_32x32x16_bf16 v[64:79], a[92:95], v[140:143], v[64:79]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[80:95], a[128:131], v[144:147], v[80:95]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[64:79], a[96:99], v[144:147], v[64:79]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[80:95], a[132:135], v[148:151], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[100:103], v[148:151], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[104:107], v[204:207], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[136:139], v[204:207], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[136:139], v[212:215], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[104:107], v[212:215], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[108:111], v[208:211], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[140:143], v[208:211], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[140:143], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[108:111], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[112:115], v[128:131], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[144:147], v[128:131], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[112:115], v[100:103], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[116:119], v[132:135], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[148:151], v[132:135], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[148:151], v[104:107], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[116:119], v[104:107], v[64:79]
		v_mov_b32_e32 v7, v30
		v_mov_b32_e32 v11, v31
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_3
.L_attn_fwd_persistent.loop_exit_3:
		s_mul_i32 s21, s21, 0x80
		v_accvgpr_read_b32 v1, a6
		s_nop 0
		v_readfirstlane_b32 s25, v1
		v_accvgpr_read_b32 v1, a15
		s_nop 0
		v_add_u32_e32 v1, s25, v1
		v_add_u32_e32 v1, s1, v1
		v_accvgpr_read_b32 v3, a6
		s_nop 0
		v_readfirstlane_b32 s25, v3
		v_accvgpr_read_b32 v3, a16
		s_nop 0
		v_add_u32_e32 v3, s25, v3
		v_add_u32_e32 v3, s1, v3
		v_xor_b32_e32 v4, 1, v5
		v_accvgpr_write_b32 a15, v4
		v_xor_b32_e32 v4, 2, v5
		v_accvgpr_write_b32 a16, v4
		v_xor_b32_e32 v4, 3, v5
		v_accvgpr_write_b32 a66, v4
		v_xor_b32_e32 v4, 8, v5
		v_accvgpr_write_b32 a67, v4
		v_xor_b32_e32 v4, 9, v5
		v_accvgpr_write_b32 a68, v4
		v_xor_b32_e32 v4, 10, v5
		v_accvgpr_write_b32 a69, v4
		v_xor_b32_e32 v4, 11, v5
		v_accvgpr_write_b32 a70, v4
		v_xor_b32_e32 v4, 16, v5
		v_accvgpr_write_b32 a71, v4
		v_xor_b32_e32 v4, 17, v5
		v_accvgpr_write_b32 a72, v4
		v_xor_b32_e32 v4, 18, v5
		v_accvgpr_write_b32 a73, v4
		v_xor_b32_e32 v4, 19, v5
		v_accvgpr_write_b32 a74, v4
		v_xor_b32_e32 v4, 24, v5
		v_accvgpr_write_b32 a75, v4
		v_xor_b32_e32 v4, 25, v5
		v_accvgpr_write_b32 a76, v4
		v_xor_b32_e32 v4, 26, v5
		v_accvgpr_write_b32 a77, v4
		v_xor_b32_e32 v4, 27, v5
		v_accvgpr_write_b32 a78, v4
		v_xor_b32_e32 v4, 32, v5
		v_accvgpr_write_b32 a79, v4
		v_xor_b32_e32 v4, 33, v5
		v_accvgpr_write_b32 a80, v4
		v_xor_b32_e32 v4, 34, v5
		v_accvgpr_write_b32 a81, v4
		v_xor_b32_e32 v4, 35, v5
		v_accvgpr_write_b32 a82, v4
		v_xor_b32_e32 v4, 40, v5
		v_accvgpr_write_b32 a83, v4
		v_xor_b32_e32 v4, 41, v5
		v_accvgpr_write_b32 a84, v4
		v_xor_b32_e32 v4, 42, v5
		v_accvgpr_write_b32 a85, v4
		v_xor_b32_e32 v4, 43, v5
		v_accvgpr_write_b32 a86, v4
		v_xor_b32_e32 v4, 48, v5
		v_accvgpr_write_b32 a87, v4
		v_xor_b32_e32 v4, 49, v5
		v_accvgpr_write_b32 a88, v4
		v_xor_b32_e32 v4, 50, v5
		v_accvgpr_write_b32 a89, v4
		v_xor_b32_e32 v4, 51, v5
		v_accvgpr_write_b32 a90, v4
		v_xor_b32_e32 v4, 56, v5
		v_accvgpr_write_b32 a91, v4
		v_xor_b32_e32 v4, 57, v5
		v_accvgpr_write_b32 a92, v4
		v_xor_b32_e32 v4, 58, v5
		v_accvgpr_write_b32 a93, v4
		v_xor_b32_e32 v4, 59, v5
		v_accvgpr_write_b32 a94, v4
		v_xor_b32_e32 v4, 64, v5
		v_accvgpr_write_b32 a95, v4
		v_xor_b32_e32 v4, 0x41, v5
		v_accvgpr_write_b32 a96, v4
		v_xor_b32_e32 v4, 0x42, v5
		v_accvgpr_write_b32 a97, v4
		v_xor_b32_e32 v4, 0x43, v5
		v_accvgpr_write_b32 a98, v4
		v_xor_b32_e32 v4, 0x48, v5
		v_accvgpr_write_b32 a99, v4
		v_xor_b32_e32 v4, 0x49, v5
		v_accvgpr_write_b32 a100, v4
		v_xor_b32_e32 v4, 0x4a, v5
		v_accvgpr_write_b32 a101, v4
		v_xor_b32_e32 v4, 0x4b, v5
		v_accvgpr_write_b32 a102, v4
		v_xor_b32_e32 v4, 0x50, v5
		v_accvgpr_write_b32 a103, v4
		v_xor_b32_e32 v4, 0x51, v5
		v_accvgpr_write_b32 a104, v4
		v_xor_b32_e32 v4, 0x52, v5
		v_accvgpr_write_b32 a105, v4
		v_xor_b32_e32 v4, 0x53, v5
		v_accvgpr_write_b32 a106, v4
		v_xor_b32_e32 v4, 0x58, v5
		v_accvgpr_write_b32 a107, v4
		v_xor_b32_e32 v4, 0x59, v5
		v_accvgpr_write_b32 a108, v4
		v_xor_b32_e32 v4, 0x5a, v5
		v_accvgpr_write_b32 a109, v4
		v_xor_b32_e32 v4, 0x5b, v5
		v_accvgpr_write_b32 a110, v4
		v_xor_b32_e32 v4, 0x60, v5
		v_accvgpr_write_b32 a111, v4
		v_xor_b32_e32 v4, 0x61, v5
		v_accvgpr_write_b32 a112, v4
		v_xor_b32_e32 v4, 0x62, v5
		v_accvgpr_write_b32 a113, v4
		v_xor_b32_e32 v4, 0x63, v5
		v_accvgpr_write_b32 a114, v4
		v_xor_b32_e32 v4, 0x68, v5
		v_accvgpr_write_b32 a115, v4
		v_xor_b32_e32 v4, 0x69, v5
		v_accvgpr_write_b32 a116, v4
		v_xor_b32_e32 v4, 0x6a, v5
		v_accvgpr_write_b32 a117, v4
		v_xor_b32_e32 v4, 0x6b, v5
		v_accvgpr_write_b32 a118, v4
		v_xor_b32_e32 v4, 0x70, v5
		v_accvgpr_write_b32 a119, v4
		v_xor_b32_e32 v4, 0x71, v5
		v_accvgpr_write_b32 a120, v4
		v_xor_b32_e32 v4, 0x72, v5
		v_accvgpr_write_b32 a121, v4
		v_xor_b32_e32 v4, 0x73, v5
		v_accvgpr_write_b32 a122, v4
		v_xor_b32_e32 v4, 0x78, v5
		v_accvgpr_write_b32 a123, v4
		v_xor_b32_e32 v4, 0x79, v5
		v_accvgpr_write_b32 a124, v4
		v_xor_b32_e32 v4, 0x7a, v5
		v_accvgpr_write_b32 a125, v4
		v_xor_b32_e32 v4, 0x7b, v5
		v_accvgpr_write_b32 a126, v4
		v_mov_b32_e32 v4, 0xff800000
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
		v_accvgpr_read_b32 v6, a62
		v_add_u32_e32 v6, s25, v6
		ds_read_b128 v[28:31], v6
		ds_read_b128 a[128:131], v6 offset:32
		ds_read_b128 a[132:135], v6 offset:64
		ds_read_b128 a[136:139], v6 offset:96
		ds_read_b128 a[140:143], v6 offset:256
		ds_read_b128 a[144:147], v6 offset:288
		ds_read_b128 a[148:151], v6 offset:320
		ds_read_b128 a[152:155], v6 offset:352
		ds_read_b128 a[156:159], v6 offset:128
		ds_read_b128 a[160:163], v6 offset:160
		ds_read_b128 a[164:167], v6 offset:192
		ds_read_b128 a[168:171], v6 offset:224
		ds_read_b128 v[96:99], v6 offset:384
		ds_read_b128 a[172:175], v6 offset:416
		ds_read_b128 a[176:179], v6 offset:448
		ds_read_b128 a[180:183], v6 offset:480
		s_mul_i32 s25, 0x4400, s37
		v_accvgpr_read_b32 v6, a63
		v_add_u32_e32 v6, s25, v6
		ds_read_b64_tr_b16 a[184:185], v6 offset:33264
		ds_read_b64_tr_b16 a[186:187], v6 offset:37616
		ds_read_b64_tr_b16 a[188:189], v6 offset:33392
		ds_read_b64_tr_b16 a[190:191], v6 offset:37744
		ds_read_b64_tr_b16 a[192:193], v6 offset:33520
		ds_read_b64_tr_b16 a[194:195], v6 offset:37872
		ds_read_b64_tr_b16 a[196:197], v6 offset:33648
		ds_read_b64_tr_b16 a[198:199], v6 offset:38000
		ds_read_b64_tr_b16 a[200:201], v6 offset:33776
		ds_read_b64_tr_b16 a[202:203], v6 offset:38128
		ds_read_b64_tr_b16 a[204:205], v6 offset:33904
		ds_read_b64_tr_b16 a[206:207], v6 offset:38256
		ds_read_b64_tr_b16 a[208:209], v6 offset:34032
		ds_read_b64_tr_b16 a[210:211], v6 offset:38384
		ds_read_b64_tr_b16 a[212:213], v6 offset:34160
		ds_read_b64_tr_b16 a[214:215], v6 offset:38512
		ds_read_b64_tr_b16 a[216:217], v6 offset:33328
		ds_read_b64_tr_b16 a[218:219], v6 offset:37680
		ds_read_b64_tr_b16 a[220:221], v6 offset:33456
		ds_read_b64_tr_b16 a[222:223], v6 offset:37808
		ds_read_b64_tr_b16 a[224:225], v6 offset:33584
		ds_read_b64_tr_b16 a[226:227], v6 offset:37936
		ds_read_b64_tr_b16 a[228:229], v6 offset:33712
		ds_read_b64_tr_b16 a[230:231], v6 offset:38064
		ds_read_b64_tr_b16 a[232:233], v6 offset:33840
		ds_read_b64_tr_b16 a[234:235], v6 offset:38192
		ds_read_b64_tr_b16 a[236:237], v6 offset:33968
		ds_read_b64_tr_b16 a[238:239], v6 offset:38320
		ds_read_b64_tr_b16 a[240:241], v6 offset:34096
		ds_read_b64_tr_b16 a[242:243], v6 offset:38448
		ds_read_b64_tr_b16 a[244:245], v6 offset:34224
		ds_read_b64_tr_b16 a[246:247], v6 offset:38576
		s_cmp_lt_i32 s1, s18
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_4
		v_accvgpr_read_b32 v6, a18
		v_add_u32_e32 v6, s1, v6
		v_cmp_lt_i32_e64 s[52:53], v6, s20
		v_accvgpr_read_b32 v6, a19
		v_add_u32_e32 v6, s1, v6
		v_cmp_lt_i32_e64 s[54:55], v6, s20
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s25, s15, s41
		s_lshl_b32 s25, s25, 1
		s_add_i32 s37, s23, s25
		v_add3_u32 v6, s37, v16, v19
		v_add3_u32 v6, v6, v21, v13
		v_cndmask_b32_e64 v6, v22, v6, s[52:53]
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
		v_accvgpr_read_b32 v8, a56
		v_add_u32_e32 v8, s1, v8
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[56:57], v8, s20
		s_add_i32 s37, s45, s25
		v_add3_u32 v6, s37, v16, v19
		v_add3_u32 v6, v6, v21, v13
		v_cndmask_b32_e64 v6, v22, v6, s[56:57]
		s_add_u32 s56, s58, 0x1040
		s_addc_u32 s57, s59, 0
		s_add_u32 s56, s56, s60
		s_addc_u32 s57, s57, s61
		s_add_u32 s62, s56, 0
		s_addc_u32 s63, s57, 0
		s_mov_b32 m0, s62
		v_accvgpr_read_b32 v8, a57
		v_add_u32_e32 v8, s1, v8
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[56:57], v8, s20
		s_add_i32 s37, s46, s25
		v_add3_u32 v6, s37, v16, v19
		v_add3_u32 v6, v6, v21, v13
		v_cndmask_b32_e64 v6, v22, v6, s[56:57]
		s_add_u32 s56, s58, 0x2080
		s_addc_u32 s57, s59, 0
		s_add_u32 s56, s56, s60
		s_addc_u32 s57, s57, s61
		s_add_u32 s62, s56, 0
		s_addc_u32 s63, s57, 0
		s_mov_b32 m0, s62
		v_accvgpr_read_b32 v8, a58
		v_add_u32_e32 v8, s1, v8
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[56:57], v8, s20
		s_add_i32 s25, s26, s25
		v_add3_u32 v6, s25, v16, v19
		v_add3_u32 v6, v6, v21, v13
		v_cndmask_b32_e64 v6, v22, v6, s[56:57]
		s_add_u32 s56, s58, 0x30c0
		s_addc_u32 s57, s59, 0
		s_add_u32 s56, s56, s60
		s_addc_u32 s57, s57, s61
		s_add_u32 s58, s56, 0
		s_addc_u32 s59, s57, 0
		s_mov_b32 m0, s58
		v_accvgpr_read_b32 v8, a59
		v_add_u32_e32 v8, s1, v8
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		s_mul_i32 s25, s17, s41
		s_lshl_b32 s25, s25, 1
		s_add_i32 s37, s39, s25
		v_add3_u32 v6, s37, v2, v14
		v_add3_u32 v6, v6, v23, v13
		v_cndmask_b32_e64 v6, v22, v6, s[54:55]
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
		v_accvgpr_read_b32 v9, a60
		v_add_u32_e32 v9, s1, v9
		buffer_load_dwordx4 v6, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[50:51], v8, s20
		s_add_i32 s37, s47, s25
		v_add3_u32 v6, s37, v2, v14
		v_add3_u32 v6, v6, v23, v13
		v_cndmask_b32_e64 v6, v22, v6, s[50:51]
		s_add_u32 s50, s56, 0x92f0
		s_addc_u32 s51, s57, 0
		s_add_u32 s50, s50, s58
		s_addc_u32 s51, s51, s59
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		v_accvgpr_read_b32 v8, a61
		v_add_u32_e32 v8, s1, v8
		buffer_load_dwordx4 v6, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[50:51], v9, s20
		s_add_i32 s37, s48, s25
		v_add3_u32 v6, s37, v2, v14
		v_add3_u32 v6, v6, v23, v13
		s_add_u32 s52, s56, 0xa3f0
		s_addc_u32 s53, s57, 0
		s_add_u32 s52, s52, s58
		s_addc_u32 s53, s53, s59
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v6, v22, v6, s[50:51]
		buffer_load_dwordx4 v6, s[32:35], 0 offen lds
		s_add_i32 s25, s24, s25
		v_add3_u32 v6, s25, v2, v14
		v_cmp_lt_i32_e64 vcc, v8, s20
		v_add3_u32 v6, v6, v23, v13
		s_add_u32 s50, s56, 0xb4f0
		s_addc_u32 s51, s57, 0
		v_cndmask_b32_e32 v6, v22, v6, vcc
		s_add_u32 s50, s50, s58
		s_addc_u32 s51, s51, s59
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		s_nop 0
		buffer_load_dwordx4 v6, s[32:35], 0 offen lds
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
		v_add_u32_e32 v6, s41, v5
		v_mfma_f32_32x32x16_bf16 v[96:111], a[132:135], a[44:47], v[96:111]
		v_accvgpr_read_b32 v8, a15
		v_add_u32_e32 v8, s41, v8
		v_mfma_f32_32x32x16_bf16 v[192:207], a[148:151], a[44:47], v[192:207]
		v_accvgpr_read_b32 v9, a16
		v_add_u32_e32 v9, s41, v9
		v_mfma_f32_32x32x16_bf16 v[208:223], a[164:167], a[44:47], v[208:223]
		v_accvgpr_read_b32 v10, a66
		v_add_u32_e32 v10, s41, v10
		v_mfma_f32_32x32x16_bf16 v[112:127], a[136:139], a[32:35], v[112:127]
		v_cmp_ge_i32_e64 vcc, v1, v10
		v_mfma_f32_32x32x16_bf16 v[128:143], a[152:155], a[32:35], v[128:143]
		v_accvgpr_read_b32 v12, a69
		v_add_u32_e32 v12, s41, v12
		v_mfma_f32_32x32x16_bf16 v[144:159], a[168:171], a[32:35], v[144:159]
		v_accvgpr_read_b32 v15, a70
		v_add_u32_e32 v15, s41, v15
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[32:35], v[160:175]
		v_accvgpr_read_b32 v17, a73
		v_add_u32_e32 v17, s41, v17
		v_mfma_f32_32x32x16_bf16 v[176:191], a[180:183], a[48:51], v[176:191]
		v_accvgpr_read_b32 v18, a74
		v_add_u32_e32 v18, s41, v18
		v_mfma_f32_32x32x16_bf16 v[96:111], a[136:139], a[48:51], v[96:111]
		v_accvgpr_read_b32 v20, a77
		v_add_u32_e32 v20, s41, v20
		v_mfma_f32_32x32x16_bf16 v[192:207], a[152:155], a[48:51], v[192:207]
		v_cndmask_b32_e32 v27, v4, v115, vcc
		v_mfma_f32_32x32x16_bf16 v[208:223], a[168:171], a[48:51], v[208:223]
		v_accvgpr_read_b32 v26, a78
		v_add_u32_e32 v28, s41, v26
		v_accvgpr_read_b32 v26, a81
		v_add_u32_e32 v29, s41, v26
		v_accvgpr_read_b32 v26, a82
		v_add_u32_e32 v30, s41, v26
		v_accvgpr_read_b32 v26, a85
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a127, v26
		v_accvgpr_read_b32 v26, a86
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a128, v26
		v_accvgpr_read_b32 v26, a89
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a129, v26
		v_accvgpr_read_b32 v26, a90
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a130, v26
		v_accvgpr_read_b32 v26, a93
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a131, v26
		v_accvgpr_read_b32 v26, a94
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a132, v26
		v_accvgpr_read_b32 v26, a97
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a133, v26
		v_accvgpr_read_b32 v26, a98
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a134, v26
		v_accvgpr_read_b32 v26, a101
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a135, v26
		v_accvgpr_read_b32 v26, a102
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a136, v26
		v_accvgpr_read_b32 v26, a105
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a137, v26
		v_accvgpr_read_b32 v26, a106
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a138, v26
		v_accvgpr_read_b32 v26, a109
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a139, v26
		v_accvgpr_read_b32 v26, a110
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a140, v26
		v_accvgpr_read_b32 v26, a113
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a141, v26
		v_accvgpr_read_b32 v26, a114
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a142, v26
		v_accvgpr_read_b32 v26, a117
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a143, v26
		v_accvgpr_read_b32 v26, a118
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a144, v26
		v_accvgpr_read_b32 v26, a121
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a145, v26
		v_accvgpr_read_b32 v26, a122
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a146, v26
		v_accvgpr_read_b32 v26, a125
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a147, v26
		v_accvgpr_read_b32 v26, a126
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a148, v26
		v_cmp_ge_i32_e64 s[50:51], v1, v6
		v_cmp_ge_i32_e64 s[52:53], v1, v8
		v_cmp_ge_i32_e64 s[54:55], v1, v9
		v_accvgpr_read_b32 v26, a67
		v_add_u32_e32 v31, s41, v26
		v_accvgpr_read_b32 v26, a68
		v_add_u32_e32 v115, s41, v26
		v_cmp_ge_i32_e64 s[56:57], v1, v31
		v_cmp_ge_i32_e64 s[58:59], v1, v115
		v_cmp_ge_i32_e64 s[60:61], v1, v12
		v_cmp_ge_i32_e64 vcc, v1, v15
		v_accvgpr_read_b32 v26, a71
		v_add_u32_e32 v224, s41, v26
		v_accvgpr_read_b32 v26, a72
		v_add_u32_e32 v225, s41, v26
		v_cndmask_b32_e32 v227, v4, v119, vcc
		v_cmp_ge_i32_e64 s[62:63], v1, v224
		v_cmp_ge_i32_e64 s[64:65], v1, v225
		v_cmp_ge_i32_e64 s[66:67], v1, v17
		v_cmp_ge_i32_e64 vcc, v1, v18
		v_accvgpr_read_b32 v26, a75
		v_add_u32_e32 v119, s41, v26
		v_accvgpr_read_b32 v26, a76
		v_add_u32_e32 v228, s41, v26
		v_cndmask_b32_e32 v231, v4, v123, vcc
		v_cmp_ge_i32_e64 s[68:69], v1, v119
		v_cmp_ge_i32_e64 s[70:71], v1, v228
		v_cmp_ge_i32_e64 s[72:73], v1, v20
		v_cmp_ge_i32_e64 vcc, v1, v28
		v_accvgpr_read_b32 v26, a79
		v_add_u32_e32 v123, s41, v26
		v_accvgpr_read_b32 v26, a80
		v_add_u32_e32 v229, s41, v26
		v_cndmask_b32_e32 v233, v4, v127, vcc
		v_cmp_ge_i32_e64 s[74:75], v1, v123
		v_cmp_ge_i32_e64 s[76:77], v1, v229
		v_cmp_ge_i32_e64 s[78:79], v1, v29
		v_cmp_ge_i32_e64 vcc, v1, v30
		v_accvgpr_read_b32 v26, a83
		v_add_u32_e32 v127, s41, v26
		v_accvgpr_read_b32 v26, a84
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a149, v26
		v_cndmask_b32_e32 v235, v4, v131, vcc
		v_cmp_ge_i32_e64 s[80:81], v1, v127
		v_accvgpr_read_b32 v26, a149
		v_cmp_ge_i32_e64 s[82:83], v1, v26
		v_accvgpr_read_b32 v26, a127
		v_cmp_ge_i32_e64 s[84:85], v1, v26
		v_accvgpr_read_b32 v26, a128
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v26, a87
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a150, v26
		v_accvgpr_read_b32 v26, a88
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a151, v26
		v_cndmask_b32_e32 v237, v4, v135, vcc
		v_accvgpr_read_b32 v26, a150
		v_cmp_ge_i32_e64 s[86:87], v1, v26
		v_accvgpr_read_b32 v26, a130
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v26, a91
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a152, v26
		v_accvgpr_read_b32 v26, a92
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a153, v26
		v_cndmask_b32_e32 v239, v4, v139, vcc
		v_accvgpr_read_b32 v26, a132
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v26, a95
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a154, v26
		v_accvgpr_read_b32 v26, a96
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a155, v26
		v_cndmask_b32_e32 v241, v4, v143, vcc
		v_accvgpr_read_b32 v26, a134
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v26, a99
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a156, v26
		v_accvgpr_read_b32 v26, a100
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a157, v26
		v_cndmask_b32_e32 v243, v4, v147, vcc
		v_accvgpr_read_b32 v26, a136
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v26, a103
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a158, v26
		v_accvgpr_read_b32 v26, a104
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a159, v26
		v_cndmask_b32_e32 v245, v4, v151, vcc
		v_accvgpr_read_b32 v26, a138
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v26, a107
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a160, v26
		v_accvgpr_read_b32 v26, a108
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a161, v26
		v_cndmask_b32_e32 v247, v4, v155, vcc
		v_accvgpr_read_b32 v26, a140
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v26, a151
		v_cmp_ge_i32_e64 s[88:89], v1, v26
		v_cndmask_b32_e64 v248, v4, v112, s[50:51]
		v_accvgpr_read_b32 v26, a129
		v_cmp_ge_i32_e64 s[50:51], v1, v26
		s_nop 1
		v_mov_b32_e32 v250, s50
		v_mov_b32_e32 v251, s51
		v_accvgpr_write_b32 a162, v250
		v_accvgpr_write_b32 a163, v251
		v_accvgpr_read_b32 v26, a152
		v_cmp_ge_i32_e64 s[50:51], v1, v26
		s_nop 1
		v_mov_b32_e32 v250, s50
		v_mov_b32_e32 v251, s51
		v_accvgpr_write_b32 a164, v250
		v_accvgpr_write_b32 a165, v251
		v_accvgpr_read_b32 v26, a153
		v_cmp_ge_i32_e64 s[50:51], v1, v26
		s_nop 1
		v_mov_b32_e32 v250, s50
		v_mov_b32_e32 v251, s51
		v_accvgpr_write_b32 a166, v250
		v_accvgpr_write_b32 a167, v251
		v_accvgpr_read_b32 v26, a131
		v_cmp_ge_i32_e64 s[50:51], v1, v26
		s_nop 1
		v_mov_b32_e32 v250, s50
		v_mov_b32_e32 v251, s51
		v_accvgpr_write_b32 a168, v250
		v_accvgpr_write_b32 a169, v251
		v_accvgpr_read_b32 v26, a154
		v_cmp_ge_i32_e64 s[50:51], v1, v26
		s_nop 1
		v_mov_b32_e32 v250, s50
		v_mov_b32_e32 v251, s51
		v_accvgpr_write_b32 a170, v250
		v_accvgpr_write_b32 a171, v251
		v_accvgpr_read_b32 v26, a155
		v_cmp_ge_i32_e64 s[50:51], v1, v26
		s_nop 1
		v_mov_b32_e32 v250, s50
		v_mov_b32_e32 v251, s51
		v_accvgpr_write_b32 a172, v250
		v_accvgpr_write_b32 a173, v251
		v_accvgpr_read_b32 v26, a133
		v_cmp_ge_i32_e64 s[50:51], v1, v26
		s_nop 1
		v_mov_b32_e32 v250, s50
		v_mov_b32_e32 v251, s51
		v_accvgpr_write_b32 a174, v250
		v_accvgpr_write_b32 a175, v251
		v_accvgpr_read_b32 v26, a156
		v_cmp_ge_i32_e64 s[50:51], v1, v26
		s_nop 1
		v_mov_b32_e32 v250, s50
		v_mov_b32_e32 v251, s51
		v_accvgpr_write_b32 a176, v250
		v_accvgpr_write_b32 a177, v251
		v_accvgpr_read_b32 v26, a157
		v_cmp_ge_i32_e64 s[50:51], v1, v26
		s_nop 1
		v_mov_b32_e32 v250, s50
		v_mov_b32_e32 v251, s51
		v_accvgpr_write_b32 a178, v250
		v_accvgpr_write_b32 a179, v251
		v_accvgpr_read_b32 v26, a135
		v_cmp_ge_i32_e64 s[50:51], v1, v26
		s_nop 1
		v_mov_b32_e32 v250, s50
		v_mov_b32_e32 v251, s51
		v_accvgpr_write_b32 a180, v250
		v_accvgpr_write_b32 a181, v251
		v_accvgpr_read_b32 v26, a158
		v_cmp_ge_i32_e64 s[50:51], v1, v26
		s_nop 1
		v_mov_b32_e32 v250, s50
		v_mov_b32_e32 v251, s51
		v_accvgpr_write_b32 a182, v250
		v_accvgpr_write_b32 a183, v251
		v_accvgpr_read_b32 v26, a159
		v_cmp_ge_i32_e64 s[50:51], v1, v26
		v_accvgpr_read_b32 v26, a137
		v_cmp_ge_i32_e64 s[90:91], v1, v26
		v_accvgpr_read_b32 v26, a160
		v_cmp_ge_i32_e64 s[92:93], v1, v26
		v_accvgpr_read_b32 v26, a161
		v_cmp_ge_i32_e64 s[94:95], v1, v26
		v_accvgpr_read_b32 v26, a139
		v_cmp_ge_i32_e64 s[96:97], v1, v26
		v_cndmask_b32_e32 v251, v4, v159, vcc
		v_cndmask_b32_e64 v253, v4, v157, s[94:95]
		v_cndmask_b32_e64 v250, v4, v158, s[96:97]
		v_accvgpr_read_b32 v26, a111
		v_add_u32_e32 v112, s41, v26
		v_accvgpr_read_b32 v26, a112
		v_add_u32_e32 v131, s41, v26
		v_cmp_ge_i32_e64 s[94:95], v1, v112
		v_cmp_ge_i32_e64 s[96:97], v1, v131
		v_accvgpr_read_b32 v26, a141
		v_cmp_ge_i32_e64 s[98:99], v1, v26
		v_cndmask_b32_e64 v158, v4, v160, s[94:95]
		v_cndmask_b32_e64 v159, v4, v161, s[96:97]
		v_cndmask_b32_e64 v160, v4, v162, s[98:99]
		v_accvgpr_read_b32 v26, a142
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v26, a115
		v_add_u32_e32 v135, s41, v26
		v_accvgpr_read_b32 v26, a116
		v_add_u32_e32 v139, s41, v26
		v_cndmask_b32_e32 v161, v4, v163, vcc
		v_cmp_ge_i32_e64 s[94:95], v1, v135
		v_cmp_ge_i32_e64 s[96:97], v1, v139
		v_accvgpr_read_b32 v26, a143
		v_cmp_ge_i32_e64 s[98:99], v1, v26
		v_cndmask_b32_e64 v162, v4, v164, s[94:95]
		v_cndmask_b32_e64 v163, v4, v165, s[96:97]
		v_cndmask_b32_e64 v164, v4, v166, s[98:99]
		v_accvgpr_read_b32 v26, a144
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v26, a119
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a248, v26
		v_accvgpr_read_b32 v26, a120
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a249, v26
		v_cndmask_b32_e32 v165, v4, v167, vcc
		v_accvgpr_read_b32 v26, a248
		v_cmp_ge_i32_e64 s[94:95], v1, v26
		v_accvgpr_read_b32 v26, a249
		v_cmp_ge_i32_e64 s[96:97], v1, v26
		v_accvgpr_read_b32 v26, a145
		v_cmp_ge_i32_e64 s[98:99], v1, v26
		v_cndmask_b32_e64 v166, v4, v168, s[94:95]
		v_cndmask_b32_e64 v167, v4, v169, s[96:97]
		v_cndmask_b32_e64 v168, v4, v170, s[98:99]
		v_accvgpr_read_b32 v26, a146
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v26, a123
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a250, v26
		v_accvgpr_read_b32 v26, a124
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_write_b32 a251, v26
		v_cndmask_b32_e32 v169, v4, v171, vcc
		v_accvgpr_read_b32 v26, a250
		v_cmp_ge_i32_e64 s[94:95], v1, v26
		v_accvgpr_read_b32 v26, a251
		v_cmp_ge_i32_e64 s[96:97], v1, v26
		v_accvgpr_read_b32 v26, a147
		v_cmp_ge_i32_e64 s[98:99], v1, v26
		v_cndmask_b32_e64 v170, v4, v172, s[94:95]
		v_cndmask_b32_e64 v171, v4, v173, s[96:97]
		v_cndmask_b32_e64 v172, v4, v174, s[98:99]
		v_cndmask_b32_e64 v249, v4, v113, s[52:53]
		v_accvgpr_read_b32 v26, a148
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_max3_f32 v26, v158, v159, v160
		v_accvgpr_write_b32 a252, v26
		v_max3_f32 v26, v162, v163, v164
		v_accvgpr_write_b32 a253, v26
		v_cndmask_b32_e32 v173, v4, v175, vcc
		v_cmp_ge_i32_e64 s[52:53], v3, v6
		v_cmp_ge_i32_e64 s[94:95], v3, v8
		v_cmp_ge_i32_e64 s[96:97], v3, v9
		v_max3_f32 v6, v166, v167, v168
		v_accvgpr_write_b32 a254, v6
		v_max3_f32 v6, v170, v171, v172
		v_accvgpr_write_b32 a255, v6
		v_cndmask_b32_e64 v8, v4, v98, s[96:97]
		v_cmp_ge_i32_e64 vcc, v3, v10
		v_cndmask_b32_e64 v26, v4, v114, s[54:55]
		v_mov_b32_e32 v6, 0xff800000
		v_cndmask_b32_e64 v174, v6, v116, s[56:57]
		v_cndmask_b32_e32 v9, v6, v99, vcc
		v_cmp_ge_i32_e64 s[54:55], v3, v31
		v_cmp_ge_i32_e64 s[56:57], v3, v115
		v_cmp_ge_i32_e64 s[96:97], v3, v12
		v_cndmask_b32_e64 v98, v6, v100, s[54:55]
		v_cndmask_b32_e64 v99, v6, v101, s[56:57]
		v_cndmask_b32_e64 v100, v6, v102, s[96:97]
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_cndmask_b32_e64 v175, v6, v117, s[58:59]
		v_cndmask_b32_e64 v226, v6, v118, s[60:61]
		v_cndmask_b32_e64 v114, v6, v120, s[62:63]
		v_cndmask_b32_e32 v101, v6, v103, vcc
		v_cmp_ge_i32_e64 s[54:55], v3, v224
		v_cmp_ge_i32_e64 s[56:57], v3, v225
		v_cmp_ge_i32_e64 s[58:59], v3, v17
		v_cndmask_b32_e64 v102, v6, v104, s[54:55]
		v_cndmask_b32_e64 v103, v6, v105, s[56:57]
		v_cndmask_b32_e64 v104, v6, v106, s[58:59]
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_cndmask_b32_e64 v115, v6, v121, s[64:65]
		v_max3_f32 v10, v248, v249, v26
		v_cndmask_b32_e32 v105, v6, v107, vcc
		v_cmp_ge_i32_e64 s[54:55], v3, v119
		v_cmp_ge_i32_e64 s[56:57], v3, v228
		v_cmp_ge_i32_e64 s[58:59], v3, v20
		v_cndmask_b32_e64 v106, v6, v108, s[54:55]
		v_cndmask_b32_e64 v107, v6, v109, s[56:57]
		v_cndmask_b32_e64 v108, v6, v110, s[58:59]
		v_cmp_ge_i32_e64 vcc, v3, v28
		v_cndmask_b32_e64 v230, v6, v122, s[66:67]
		v_cndmask_b32_e64 v116, v6, v124, s[68:69]
		v_cndmask_b32_e32 v109, v6, v111, vcc
		v_cmp_ge_i32_e64 s[54:55], v3, v123
		v_cmp_ge_i32_e64 s[56:57], v3, v229
		v_cmp_ge_i32_e64 s[58:59], v3, v29
		v_cndmask_b32_e64 v28, v6, v192, s[54:55]
		v_cndmask_b32_e64 v29, v6, v193, s[56:57]
		v_cndmask_b32_e64 v110, v6, v194, s[58:59]
		v_cmp_ge_i32_e64 vcc, v3, v30
		v_cndmask_b32_e64 v117, v6, v125, s[70:71]
		v_cndmask_b32_e64 v232, v6, v126, s[72:73]
		v_cndmask_b32_e64 v30, v6, v128, s[74:75]
		v_cndmask_b32_e32 v111, v6, v195, vcc
		v_cmp_ge_i32_e64 s[54:55], v3, v127
		v_accvgpr_read_b32 v12, a149
		v_cmp_ge_i32_e64 s[56:57], v3, v12
		v_accvgpr_read_b32 v12, a127
		v_cmp_ge_i32_e64 s[58:59], v3, v12
		v_cndmask_b32_e64 v118, v6, v196, s[54:55]
		v_cndmask_b32_e64 v119, v6, v197, s[56:57]
		v_cndmask_b32_e64 v120, v6, v198, s[58:59]
		v_accvgpr_read_b32 v12, a128
		v_cmp_ge_i32_e64 vcc, v3, v12
		v_cndmask_b32_e64 v31, v6, v129, s[76:77]
		v_max3_f32 v12, v174, v175, v226
		v_cndmask_b32_e32 v121, v6, v199, vcc
		v_accvgpr_read_b32 v15, a150
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_accvgpr_read_b32 v15, a151
		v_cmp_ge_i32_e64 s[56:57], v3, v15
		v_accvgpr_read_b32 v15, a129
		v_cmp_ge_i32_e64 s[58:59], v3, v15
		v_cndmask_b32_e64 v122, v6, v200, s[54:55]
		v_cndmask_b32_e64 v123, v6, v201, s[56:57]
		v_cndmask_b32_e64 v124, v6, v202, s[58:59]
		v_accvgpr_read_b32 v15, a130
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_cndmask_b32_e64 v234, v6, v130, s[78:79]
		v_cndmask_b32_e64 v126, v6, v132, s[80:81]
		v_cndmask_b32_e32 v125, v6, v203, vcc
		v_accvgpr_read_b32 v15, a152
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_accvgpr_read_b32 v15, a153
		v_cmp_ge_i32_e64 s[56:57], v3, v15
		v_accvgpr_read_b32 v15, a131
		v_cmp_ge_i32_e64 s[58:59], v3, v15
		v_cndmask_b32_e64 v128, v6, v204, s[54:55]
		v_cndmask_b32_e64 v129, v6, v205, s[56:57]
		v_cndmask_b32_e64 v192, v6, v206, s[58:59]
		v_accvgpr_read_b32 v15, a132
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_cndmask_b32_e64 v127, v6, v133, s[82:83]
		v_cndmask_b32_e64 v236, v6, v134, s[84:85]
		v_cndmask_b32_e32 v193, v6, v207, vcc
		v_accvgpr_read_b32 v15, a154
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_accvgpr_read_b32 v15, a134
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_cndmask_b32_e64 v132, v6, v136, s[86:87]
		v_accvgpr_read_b32 v15, a155
		v_cmp_ge_i32_e64 s[56:57], v3, v15
		v_accvgpr_read_b32 v15, a133
		v_cmp_ge_i32_e64 s[58:59], v3, v15
		v_cndmask_b32_e64 v194, v6, v208, s[54:55]
		v_cndmask_b32_e64 v195, v6, v209, s[56:57]
		v_cndmask_b32_e64 v196, v6, v210, s[58:59]
		v_cndmask_b32_e64 v133, v6, v137, s[88:89]
		v_cndmask_b32_e32 v197, v6, v211, vcc
		v_accvgpr_read_b32 v15, a156
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_accvgpr_read_b32 v15, a157
		v_cmp_ge_i32_e64 s[56:57], v3, v15
		v_accvgpr_read_b32 v15, a135
		v_cmp_ge_i32_e64 s[58:59], v3, v15
		v_cndmask_b32_e64 v136, v6, v212, s[54:55]
		v_cndmask_b32_e64 v137, v6, v213, s[56:57]
		v_cndmask_b32_e64 v198, v6, v214, s[58:59]
		v_accvgpr_read_b32 v15, a136
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_accvgpr_read_b32 v15, a162
		s_nop 0
		v_readfirstlane_b32 s54, v15
		v_accvgpr_read_b32 v15, a163
		s_nop 0
		v_readfirstlane_b32 s55, v15
		s_nop 1
		v_cndmask_b32_e64 v238, v6, v138, s[54:55]
		v_accvgpr_read_b32 v15, a164
		s_nop 0
		v_readfirstlane_b32 s54, v15
		v_accvgpr_read_b32 v15, a165
		s_nop 0
		v_readfirstlane_b32 s55, v15
		s_nop 1
		v_cndmask_b32_e64 v200, v6, v140, s[54:55]
		v_cndmask_b32_e32 v199, v6, v215, vcc
		v_accvgpr_read_b32 v15, a158
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_accvgpr_read_b32 v15, a159
		v_cmp_ge_i32_e64 s[56:57], v3, v15
		v_accvgpr_read_b32 v15, a137
		v_cmp_ge_i32_e64 s[58:59], v3, v15
		v_cndmask_b32_e64 v202, v6, v216, s[54:55]
		v_cndmask_b32_e64 v203, v6, v217, s[56:57]
		v_cndmask_b32_e64 v204, v6, v218, s[58:59]
		v_accvgpr_read_b32 v15, a138
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_accvgpr_read_b32 v15, a166
		s_nop 0
		v_readfirstlane_b32 s54, v15
		v_accvgpr_read_b32 v15, a167
		s_nop 0
		v_readfirstlane_b32 s55, v15
		s_nop 1
		v_cndmask_b32_e64 v201, v6, v141, s[54:55]
		v_accvgpr_read_b32 v15, a168
		s_nop 0
		v_readfirstlane_b32 s54, v15
		v_accvgpr_read_b32 v15, a169
		s_nop 0
		v_readfirstlane_b32 s55, v15
		s_nop 1
		v_cndmask_b32_e64 v240, v6, v142, s[54:55]
		v_cndmask_b32_e32 v205, v6, v219, vcc
		v_accvgpr_read_b32 v15, a160
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_accvgpr_read_b32 v15, a161
		v_cmp_ge_i32_e64 s[56:57], v3, v15
		v_accvgpr_read_b32 v15, a139
		v_cmp_ge_i32_e64 s[58:59], v3, v15
		v_cndmask_b32_e64 v140, v6, v220, s[54:55]
		v_cndmask_b32_e64 v141, v6, v221, s[56:57]
		v_cndmask_b32_e64 v142, v6, v222, s[58:59]
		v_accvgpr_read_b32 v15, a140
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_accvgpr_read_b32 v15, a170
		s_nop 0
		v_readfirstlane_b32 s54, v15
		v_accvgpr_read_b32 v15, a171
		s_nop 0
		v_readfirstlane_b32 s55, v15
		s_nop 1
		v_cndmask_b32_e64 v206, v6, v144, s[54:55]
		v_accvgpr_read_b32 v15, a172
		s_nop 0
		v_readfirstlane_b32 s54, v15
		v_accvgpr_read_b32 v15, a173
		s_nop 0
		v_readfirstlane_b32 s55, v15
		s_nop 1
		v_cndmask_b32_e64 v207, v6, v145, s[54:55]
		v_cndmask_b32_e32 v143, v6, v223, vcc
		v_cmp_ge_i32_e64 s[54:55], v3, v112
		v_cmp_ge_i32_e64 s[56:57], v3, v131
		v_accvgpr_read_b32 v15, a141
		v_cmp_ge_i32_e64 s[58:59], v3, v15
		v_cndmask_b32_e64 v112, v6, v176, s[54:55]
		v_cndmask_b32_e64 v113, v6, v177, s[56:57]
		v_cndmask_b32_e64 v130, v6, v178, s[58:59]
		v_accvgpr_read_b32 v15, a142
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_accvgpr_read_b32 v15, a174
		s_nop 0
		v_readfirstlane_b32 s54, v15
		v_accvgpr_read_b32 v15, a175
		s_nop 0
		v_readfirstlane_b32 s55, v15
		s_nop 1
		v_cndmask_b32_e64 v242, v6, v146, s[54:55]
		v_accvgpr_read_b32 v15, a176
		s_nop 0
		v_readfirstlane_b32 s54, v15
		v_accvgpr_read_b32 v15, a177
		s_nop 0
		v_readfirstlane_b32 s55, v15
		s_nop 1
		v_cndmask_b32_e64 v144, v6, v148, s[54:55]
		v_cndmask_b32_e32 v131, v6, v179, vcc
		v_cmp_ge_i32_e64 s[54:55], v3, v135
		v_cmp_ge_i32_e64 s[56:57], v3, v139
		v_accvgpr_read_b32 v15, a143
		v_cmp_ge_i32_e64 s[58:59], v3, v15
		v_cndmask_b32_e64 v134, v6, v180, s[54:55]
		v_cndmask_b32_e64 v135, v6, v181, s[56:57]
		v_cndmask_b32_e64 v138, v6, v182, s[58:59]
		v_accvgpr_read_b32 v15, a144
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_accvgpr_read_b32 v15, a178
		s_nop 0
		v_readfirstlane_b32 s54, v15
		v_accvgpr_read_b32 v15, a179
		s_nop 0
		v_readfirstlane_b32 s55, v15
		s_nop 1
		v_cndmask_b32_e64 v145, v6, v149, s[54:55]
		v_accvgpr_read_b32 v15, a180
		s_nop 0
		v_readfirstlane_b32 s54, v15
		v_accvgpr_read_b32 v15, a181
		s_nop 0
		v_readfirstlane_b32 s55, v15
		s_nop 1
		v_cndmask_b32_e64 v244, v6, v150, s[54:55]
		v_cndmask_b32_e32 v139, v6, v183, vcc
		v_accvgpr_read_b32 v15, a248
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_accvgpr_read_b32 v15, a249
		v_cmp_ge_i32_e64 s[56:57], v3, v15
		v_accvgpr_read_b32 v15, a145
		v_cmp_ge_i32_e64 s[58:59], v3, v15
		v_cndmask_b32_e64 v146, v6, v184, s[54:55]
		v_cndmask_b32_e64 v147, v6, v185, s[56:57]
		v_cndmask_b32_e64 v148, v6, v186, s[58:59]
		v_accvgpr_read_b32 v15, a146
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_accvgpr_read_b32 v15, a182
		s_nop 0
		v_readfirstlane_b32 s54, v15
		v_accvgpr_read_b32 v15, a183
		s_nop 0
		v_readfirstlane_b32 s55, v15
		s_nop 1
		v_cndmask_b32_e64 v150, v6, v152, s[54:55]
		v_cndmask_b32_e64 v151, v6, v153, s[50:51]
		v_cndmask_b32_e32 v149, v6, v187, vcc
		v_accvgpr_read_b32 v15, a250
		v_cmp_ge_i32_e64 s[50:51], v3, v15
		v_accvgpr_read_b32 v15, a251
		v_cmp_ge_i32_e64 s[54:55], v3, v15
		v_accvgpr_read_b32 v15, a147
		v_cmp_ge_i32_e64 s[56:57], v3, v15
		v_cndmask_b32_e64 v152, v6, v188, s[50:51]
		v_cndmask_b32_e64 v153, v6, v189, s[54:55]
		v_cndmask_b32_e64 v176, v6, v190, s[56:57]
		v_accvgpr_read_b32 v15, a148
		v_cmp_ge_i32_e64 vcc, v3, v15
		v_cndmask_b32_e64 v246, v6, v154, s[90:91]
		v_cndmask_b32_e64 v252, v6, v156, s[92:93]
		v_cndmask_b32_e32 v177, v6, v191, vcc
		v_max3_f32 v15, v114, v115, v230
		v_max3_f32 v17, v116, v117, v232
		v_max3_f32 v18, v30, v31, v234
		v_max3_f32 v20, v126, v127, v236
		v_max3_f32 v154, v132, v133, v238
		v_max3_f32 v155, v200, v201, v240
		v_max3_f32 v156, v206, v207, v242
		v_max3_f32 v157, v144, v145, v244
		v_max3_f32 v178, v150, v151, v246
		v_max3_f32 v179, v252, v253, v250
		v_max3_f32 v10, v10, v27, v12
		v_max3_f32 v12, v15, v231, v17
		v_max3_f32 v15, v18, v235, v20
		v_max3_f32 v17, v154, v239, v155
		v_max3_f32 v18, v156, v243, v157
		v_max3_f32 v20, v178, v247, v179
		v_accvgpr_read_b32 v154, a252
		v_accvgpr_read_b32 v155, a253
		v_max3_f32 v154, v154, v161, v155
		v_accvgpr_read_b32 v155, a254
		v_accvgpr_read_b32 v156, a255
		v_max3_f32 v155, v155, v169, v156
		v_max3_f32 v10, v10, v227, v12
		v_max3_f32 v12, v15, v237, v17
		v_max3_f32 v15, v18, v245, v20
		v_max3_f32 v17, v154, v165, v155
		v_max3_f32 v10, v10, v233, v12
		v_max3_f32 v12, v15, v251, v17
		v_max3_f32 v10, v10, v241, v12
		v_max_f32_e32 v154, v10, v173
		v_mov_b32_e32 v155, v154
		v_cndmask_b32_e64 v156, v6, v96, s[52:53]
		v_cndmask_b32_e64 v157, v6, v97, s[94:95]
		v_permlane32_swap_b32_e32 v154, v155
		v_max3_f32 v6, v156, v157, v8
		v_max3_f32 v10, v98, v99, v100
		v_max3_f32 v12, v102, v103, v104
		v_max3_f32 v15, v106, v107, v108
		v_max3_f32 v17, v28, v29, v110
		v_max3_f32 v18, v118, v119, v120
		v_max3_f32 v20, v122, v123, v124
		v_max3_f32 v96, v128, v129, v192
		v_max3_f32 v97, v194, v195, v196
		v_max3_f32 v178, v136, v137, v198
		v_max3_f32 v179, v202, v203, v204
		v_max3_f32 v180, v140, v141, v142
		v_max3_f32 v181, v112, v113, v130
		v_max3_f32 v182, v134, v135, v138
		v_max3_f32 v183, v146, v147, v148
		v_max3_f32 v184, v152, v153, v176
		v_max3_f32 v6, v6, v9, v10
		v_max3_f32 v10, v12, v105, v15
		v_max3_f32 v12, v17, v111, v18
		v_max3_f32 v15, v20, v125, v96
		v_max3_f32 v17, v97, v197, v178
		v_max3_f32 v18, v179, v205, v180
		v_max3_f32 v20, v181, v131, v182
		v_max3_f32 v96, v183, v149, v184
		v_max3_f32 v6, v6, v101, v10
		v_max3_f32 v10, v12, v121, v15
		v_max3_f32 v12, v17, v199, v18
		v_max3_f32 v15, v20, v139, v96
		v_max3_f32 v6, v6, v109, v10
		v_max3_f32 v10, v12, v143, v15
		v_max3_f32 v6, v6, v193, v10
		v_max_f32_e32 v96, v6, v177
		v_mov_b32_e32 v97, v96
		v_max_f32_e32 v178, v154, v155
		v_mov_b32_e32 v154, v7
		v_permlane32_swap_b32_e32 v96, v97
		v_max_f32_e32 v179, v96, v97
		v_mov_b32_e32 v96, 0x3e38aa3b
		v_mov_b32_e32 v97, 0x3e38aa3b
		v_pk_mul_f32 v[180:181], v[178:179], v[96:97]
		v_max_f32_e32 v178, v7, v180
		v_max_f32_e32 v179, v11, v181
		v_pk_fma_f32 v[6:7], v[248:249], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[26:27], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[174:175], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[226:227], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[114:115], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[230:231], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[116:117], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[232:233], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[30:31], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[234:235], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[126:127], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[236:237], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[132:133], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[238:239], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[200:201], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[240:241], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[206:207], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[242:243], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[144:145], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[244:245], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[150:151], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[246:247], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[252:253], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[218:219], v[250:251], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[220:221], v[158:159], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[160:161], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[162:163], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[164:165], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[166:167], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[168:169], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[170:171], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[172:173], v[96:97], v[178:179] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[156:157], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[8:9], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[8:9], v[98:99], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[108:109], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[28:29], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[110:111], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[118:119], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[120:121], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[122:123], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[124:125], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[128:129], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[192:193], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[194:195], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[196:197], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[136:137], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[198:199], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[202:203], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[204:205], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[140:141], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[142:143], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[112:113], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[130:131], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[134:135], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[138:139], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[146:147], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[148:149], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[152:153], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[176:177], v[96:97], v[178:179] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v96, v6
		v_exp_f32_e32 v176, v7
		v_exp_f32_e32 v6, v180
		v_exp_f32_e32 v222, v181
		v_exp_f32_e32 v180, v26
		v_exp_f32_e32 v224, v27
		v_exp_f32_e32 v26, v174
		v_exp_f32_e32 v226, v175
		v_exp_f32_e32 v174, v182
		v_exp_f32_e32 v228, v183
		v_exp_f32_e32 v182, v114
		v_exp_f32_e32 v230, v115
		v_exp_f32_e32 v114, v184
		v_exp_f32_e32 v232, v185
		v_exp_f32_e32 v184, v116
		v_exp_f32_e32 v234, v117
		v_exp_f32_e32 v116, v186
		v_exp_f32_e32 v236, v187
		v_exp_f32_e32 v186, v30
		v_exp_f32_e32 v238, v31
		v_exp_f32_e32 v30, v188
		v_exp_f32_e32 v240, v189
		v_exp_f32_e32 v188, v126
		v_exp_f32_e32 v242, v127
		v_exp_f32_e32 v126, v190
		v_exp_f32_e32 v244, v191
		v_exp_f32_e32 v190, v132
		v_exp_f32_e32 v246, v133
		v_exp_f32_e32 v132, v208
		v_exp_f32_e32 v248, v209
		v_exp_f32_e32 v208, v200
		v_exp_f32_e32 v250, v201
		v_exp_f32_e32 v97, v210
		v_exp_f32_e32 v177, v211
		v_exp_f32_e32 v7, v206
		v_exp_f32_e32 v223, v207
		v_exp_f32_e32 v181, v212
		v_exp_f32_e32 v225, v213
		v_exp_f32_e32 v27, v144
		v_exp_f32_e32 v227, v145
		v_exp_f32_e32 v175, v214
		v_exp_f32_e32 v229, v215
		v_exp_f32_e32 v183, v150
		v_exp_f32_e32 v231, v151
		v_exp_f32_e32 v115, v216
		v_exp_f32_e32 v233, v217
		v_exp_f32_e32 v185, v218
		v_exp_f32_e32 v235, v219
		v_exp_f32_e32 v117, v220
		v_exp_f32_e32 v237, v221
		v_exp_f32_e32 v187, v158
		v_exp_f32_e32 v239, v159
		v_exp_f32_e32 v31, v160
		v_exp_f32_e32 v241, v161
		v_exp_f32_e32 v189, v162
		v_exp_f32_e32 v243, v163
		v_exp_f32_e32 v127, v164
		v_exp_f32_e32 v245, v165
		v_exp_f32_e32 v191, v166
		v_exp_f32_e32 v247, v167
		v_exp_f32_e32 v133, v168
		v_exp_f32_e32 v249, v169
		v_exp_f32_e32 v209, v170
		v_exp_f32_e32 v251, v171
		v_exp_f32_e32 v144, v172
		v_exp_f32_e32 v150, v173
		v_exp_f32_e32 v158, v156
		v_exp_f32_e32 v160, v157
		v_exp_f32_e32 v156, v8
		v_exp_f32_e32 v162, v9
		v_exp_f32_e32 v8, v98
		v_exp_f32_e32 v164, v99
		v_exp_f32_e32 v98, v100
		v_exp_f32_e32 v166, v101
		v_exp_f32_e32 v100, v102
		v_exp_f32_e32 v168, v103
		v_exp_f32_e32 v102, v104
		v_exp_f32_e32 v170, v105
		v_exp_f32_e32 v104, v106
		v_exp_f32_e32 v172, v107
		v_exp_f32_e32 v106, v108
		v_exp_f32_e32 v200, v109
		v_exp_f32_e32 v108, v28
		v_exp_f32_e32 v206, v29
		v_exp_f32_e32 v28, v110
		v_exp_f32_e32 v210, v111
		v_exp_f32_e32 v110, v118
		v_exp_f32_e32 v212, v119
		v_exp_f32_e32 v118, v120
		v_exp_f32_e32 v214, v121
		v_exp_f32_e32 v120, v122
		v_exp_f32_e32 v216, v123
		v_exp_f32_e32 v122, v124
		v_exp_f32_e32 v218, v125
		v_exp_f32_e32 v124, v128
		v_exp_f32_e32 v220, v129
		v_exp_f32_e32 v145, v192
		v_exp_f32_e32 v151, v193
		v_exp_f32_e32 v159, v194
		v_exp_f32_e32 v161, v195
		v_exp_f32_e32 v157, v196
		v_exp_f32_e32 v163, v197
		v_exp_f32_e32 v9, v136
		v_exp_f32_e32 v165, v137
		v_exp_f32_e32 v99, v198
		v_exp_f32_e32 v167, v199
		v_exp_f32_e32 v101, v202
		v_exp_f32_e32 v169, v203
		v_exp_f32_e32 v103, v204
		v_exp_f32_e32 v171, v205
		v_exp_f32_e32 v105, v140
		v_exp_f32_e32 v173, v141
		v_exp_f32_e32 v107, v142
		v_exp_f32_e32 v201, v143
		v_exp_f32_e32 v109, v112
		v_exp_f32_e32 v207, v113
		v_exp_f32_e32 v29, v130
		v_exp_f32_e32 v211, v131
		v_exp_f32_e32 v111, v134
		v_exp_f32_e32 v213, v135
		v_exp_f32_e32 v119, v138
		v_exp_f32_e32 v215, v139
		v_exp_f32_e32 v121, v146
		v_exp_f32_e32 v217, v147
		v_exp_f32_e32 v123, v148
		v_exp_f32_e32 v219, v149
		v_exp_f32_e32 v125, v152
		v_exp_f32_e32 v221, v153
		v_pk_add_f32 v[112:113], v[96:97], v[176:177]
		v_pk_add_f32 v[128:129], v[6:7], v[222:223]
		v_pk_add_f32 v[130:131], v[180:181], v[224:225]
		v_pk_add_f32 v[134:135], v[26:27], v[226:227]
		v_pk_add_f32 v[136:137], v[174:175], v[228:229]
		v_pk_add_f32 v[138:139], v[182:183], v[230:231]
		v_pk_add_f32 v[140:141], v[114:115], v[232:233]
		v_pk_add_f32 v[142:143], v[184:185], v[234:235]
		v_pk_add_f32 v[146:147], v[116:117], v[236:237]
		v_pk_add_f32 v[148:149], v[186:187], v[238:239]
		v_pk_add_f32 v[152:153], v[30:31], v[240:241]
		v_pk_add_f32 v[192:193], v[188:189], v[242:243]
		v_pk_add_f32 v[194:195], v[126:127], v[244:245]
		v_pk_add_f32 v[196:197], v[190:191], v[246:247]
		v_pk_add_f32 v[198:199], v[132:133], v[248:249]
		v_pk_add_f32 v[202:203], v[208:209], v[250:251]
		v_pk_add_f32 v[112:113], v[112:113], v[128:129]
		v_pk_add_f32 v[128:129], v[130:131], v[134:135]
		v_pk_add_f32 v[130:131], v[136:137], v[138:139]
		v_pk_add_f32 v[134:135], v[140:141], v[142:143]
		v_pk_add_f32 v[136:137], v[146:147], v[148:149]
		v_pk_add_f32 v[138:139], v[152:153], v[192:193]
		v_pk_add_f32 v[140:141], v[194:195], v[196:197]
		v_pk_add_f32 v[142:143], v[198:199], v[202:203]
		v_pk_add_f32 v[112:113], v[112:113], v[128:129]
		v_pk_add_f32 v[128:129], v[130:131], v[134:135]
		v_pk_add_f32 v[130:131], v[136:137], v[138:139]
		v_pk_add_f32 v[134:135], v[140:141], v[142:143]
		v_pk_add_f32 v[112:113], v[112:113], v[128:129]
		v_pk_add_f32 v[128:129], v[130:131], v[134:135]
		v_pk_add_f32 v[130:131], v[112:113], v[128:129]
		v_add_f32_e32 v10, v130, v131
		v_accvgpr_read_b32 v12, a64
		ds_bpermute_b32 v112, v12, v10
		v_accvgpr_read_b32 v12, a65
		ds_bpermute_b32 v128, v12, v10
		v_pk_add_f32 v[130:131], v[144:145], v[150:151]
		v_pk_add_f32 v[134:135], v[158:159], v[160:161]
		v_pk_add_f32 v[136:137], v[156:157], v[162:163]
		v_pk_add_f32 v[138:139], v[8:9], v[164:165]
		v_pk_add_f32 v[140:141], v[98:99], v[166:167]
		v_pk_add_f32 v[142:143], v[100:101], v[168:169]
		v_pk_add_f32 v[146:147], v[102:103], v[170:171]
		v_pk_add_f32 v[148:149], v[104:105], v[172:173]
		v_pk_add_f32 v[152:153], v[106:107], v[200:201]
		v_pk_add_f32 v[192:193], v[108:109], v[206:207]
		v_pk_add_f32 v[194:195], v[28:29], v[210:211]
		v_pk_add_f32 v[196:197], v[110:111], v[212:213]
		v_pk_add_f32 v[198:199], v[118:119], v[214:215]
		v_pk_add_f32 v[202:203], v[120:121], v[216:217]
		v_pk_add_f32 v[204:205], v[122:123], v[218:219]
		v_pk_add_f32 v[252:253], v[124:125], v[220:221]
		v_pk_add_f32 v[130:131], v[130:131], v[134:135]
		v_pk_add_f32 v[134:135], v[136:137], v[138:139]
		v_pk_add_f32 v[136:137], v[140:141], v[142:143]
		v_pk_add_f32 v[138:139], v[146:147], v[148:149]
		v_pk_add_f32 v[140:141], v[152:153], v[192:193]
		v_pk_add_f32 v[142:143], v[194:195], v[196:197]
		v_pk_add_f32 v[146:147], v[198:199], v[202:203]
		v_pk_add_f32 v[148:149], v[204:205], v[252:253]
		v_pk_add_f32 v[130:131], v[130:131], v[134:135]
		v_pk_add_f32 v[134:135], v[136:137], v[138:139]
		v_pk_add_f32 v[136:137], v[140:141], v[142:143]
		v_pk_add_f32 v[138:139], v[146:147], v[148:149]
		v_pk_add_f32 v[130:131], v[130:131], v[134:135]
		v_pk_add_f32 v[134:135], v[136:137], v[138:139]
		v_pk_add_f32 v[136:137], v[130:131], v[134:135]
		v_mov_b32_e32 v129, v137
		v_mov_b32_e32 v113, v136
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[130:131], v[112:113], v[128:129]
		v_mov_b32_e32 v112, v131
		v_mov_b32_e32 v113, v131
		v_cvt_pk_bf16_f32 v136, v96, v176
		v_cvt_pk_bf16_f32 v137, v6, v222
		v_permlane32_swap_b32_e32 v112, v113
		v_add_f32_e32 v129, v112, v113
		v_mov_b32_e32 v155, v11
		v_pk_add_f32 v[10:11], v[154:155], v[178:179] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v112, v10
		v_exp_f32_e32 v113, v11
		v_cvt_pk_bf16_f32 v138, v180, v224
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
		v_mov_b64_e32 v[10:11], v[24:25]
		v_pk_fma_f32 v[24:25], v[10:11], v[112:113], v[128:129]
		v_cvt_pk_bf16_f32 v139, v26, v226
		v_cvt_pk_bf16_f32 v128, v174, v228
		v_cvt_pk_bf16_f32 v129, v182, v230
		v_cvt_pk_bf16_f32 v130, v114, v232
		v_cvt_pk_bf16_f32 v131, v184, v234
		v_cvt_pk_bf16_f32 v140, v116, v236
		v_cvt_pk_bf16_f32 v141, v186, v238
		v_cvt_pk_bf16_f32 v142, v30, v240
		v_cvt_pk_bf16_f32 v143, v188, v242
		v_cvt_pk_bf16_f32 v152, v126, v244
		v_cvt_pk_bf16_f32 v153, v190, v246
		v_cvt_pk_bf16_f32 v154, v132, v248
		v_cvt_pk_bf16_f32 v155, v208, v250
		v_cvt_pk_bf16_f32 v192, v97, v177
		v_cvt_pk_bf16_f32 v193, v7, v223
		v_cvt_pk_bf16_f32 v194, v181, v225
		v_cvt_pk_bf16_f32 v195, v27, v227
		v_cvt_pk_bf16_f32 v196, v175, v229
		v_cvt_pk_bf16_f32 v197, v183, v231
		v_cvt_pk_bf16_f32 v198, v115, v233
		v_cvt_pk_bf16_f32 v199, v185, v235
		v_cvt_pk_bf16_f32 v112, v117, v237
		v_cvt_pk_bf16_f32 v113, v187, v239
		v_cvt_pk_bf16_f32 v114, v31, v241
		v_cvt_pk_bf16_f32 v115, v189, v243
		v_cvt_pk_bf16_f32 v180, v127, v245
		v_cvt_pk_bf16_f32 v181, v191, v247
		v_cvt_pk_bf16_f32 v182, v133, v249
		v_cvt_pk_bf16_f32 v183, v209, v251
		v_cvt_pk_bf16_f32 v132, v144, v150
		v_cvt_pk_bf16_f32 v133, v158, v160
		v_cvt_pk_bf16_f32 v134, v156, v162
		v_cvt_pk_bf16_f32 v135, v8, v164
		v_cvt_pk_bf16_f32 v184, v98, v166
		v_cvt_pk_bf16_f32 v185, v100, v168
		v_cvt_pk_bf16_f32 v186, v102, v170
		v_cvt_pk_bf16_f32 v187, v104, v172
		v_cvt_pk_bf16_f32 v188, v106, v200
		v_cvt_pk_bf16_f32 v189, v108, v206
		v_cvt_pk_bf16_f32 v190, v28, v210
		v_cvt_pk_bf16_f32 v191, v110, v212
		v_cvt_pk_bf16_f32 v224, v118, v214
		v_cvt_pk_bf16_f32 v225, v120, v216
		v_cvt_pk_bf16_f32 v226, v122, v218
		v_cvt_pk_bf16_f32 v227, v124, v220
		v_cvt_pk_bf16_f32 v228, v145, v151
		v_cvt_pk_bf16_f32 v229, v159, v161
		v_cvt_pk_bf16_f32 v230, v157, v163
		v_cvt_pk_bf16_f32 v231, v9, v165
		v_cvt_pk_bf16_f32 v8, v99, v167
		v_cvt_pk_bf16_f32 v9, v101, v169
		v_cvt_pk_bf16_f32 v10, v103, v171
		v_cvt_pk_bf16_f32 v11, v105, v173
		v_cvt_pk_bf16_f32 v96, v107, v201
		v_cvt_pk_bf16_f32 v97, v109, v207
		v_cvt_pk_bf16_f32 v98, v29, v211
		v_cvt_pk_bf16_f32 v99, v111, v213
		v_cvt_pk_bf16_f32 v28, v119, v215
		v_cvt_pk_bf16_f32 v29, v121, v217
		v_cvt_pk_bf16_f32 v30, v123, v219
		v_cvt_pk_bf16_f32 v31, v125, v221
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[32:47], a[184:187], v[136:139], v[32:47]
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_mfma_f32_32x32x16_bf16 v[48:63], a[216:219], v[136:139], v[48:63]
		v_permlane32_swap_b32_e32 v152, v154
		v_permlane32_swap_b32_e32 v153, v155
		v_mfma_f32_32x32x16_bf16 v[32:47], a[188:191], v[128:131], v[32:47]
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_mfma_f32_32x32x16_bf16 v[48:63], a[220:223], v[128:131], v[48:63]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[140:143], v[32:47]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[140:143], v[48:63]
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[152:155], v[32:47]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[152:155], v[48:63]
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_mfma_f32_32x32x16_bf16 v[80:95], a[216:219], v[132:135], v[80:95]
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[64:79], a[184:187], v[132:135], v[64:79]
		v_permlane32_swap_b32_e32 v224, v226
		v_permlane32_swap_b32_e32 v225, v227
		v_mfma_f32_32x32x16_bf16 v[80:95], a[220:223], v[184:187], v[80:95]
		v_permlane32_swap_b32_e32 v228, v230
		v_permlane32_swap_b32_e32 v229, v231
		v_mfma_f32_32x32x16_bf16 v[64:79], a[188:191], v[184:187], v[64:79]
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[188:191], v[80:95]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[188:191], v[64:79]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[224:227], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[224:227], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[192:195], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[192:195], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[228:231], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[228:231], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[196:199], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[196:199], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[8:11], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[8:11], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[112:115], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[112:115], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[180:183], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[180:183], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[28:31], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[28:31], v[64:79]
		s_cselect_b32 s1, 1, 0
		s_add_i32 s25, s41, 0x80
		s_cmp_lg_u32 s1, 0
		s_mov_b32 s41, s25
		v_mov_b32_e32 v7, v178
		v_mov_b32_e32 v11, v179
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_4
.L_attn_fwd_persistent.loop_exit_4:
		s_mov_b32 s24, s8
		s_mov_b32 s25, s9
		s_mov_b32 s26, s42
		s_mov_b32 s27, s43
		v_rcp_f32_e32 v2, v24
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
		v_accvgpr_read_b32 v3, a52
		s_nop 0
		v_readfirstlane_b32 s28, v3
		v_accvgpr_read_b32 v3, a53
		s_nop 0
		v_readfirstlane_b32 s29, v3
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
		v_accvgpr_read_b32 v3, a52
		s_nop 0
		v_readfirstlane_b32 s28, v3
		v_accvgpr_read_b32 v3, a53
		s_nop 0
		v_readfirstlane_b32 s29, v3
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
		v_accvgpr_read_b32 v3, a52
		s_nop 0
		v_readfirstlane_b32 s28, v3
		v_accvgpr_read_b32 v3, a53
		s_nop 0
		v_readfirstlane_b32 s29, v3
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
		v_accvgpr_read_b32 v3, a52
		s_nop 0
		v_readfirstlane_b32 s28, v3
		v_accvgpr_read_b32 v3, a53
		s_nop 0
		v_readfirstlane_b32 s29, v3
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
		buffer_store_dwordx4 v[20:23], v2, s[24:27], 0 offen
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
		buffer_store_dwordx4 v[28:31], v1, s[24:27], 0 offen
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
	.set .L_attn_fwd_persistent.num_vgpr, 254
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
    wave.regalloc.iterations: 419
    wave.regalloc.agpr.dwords: 791
    wave.regalloc.remat.dwords: 9
    wave.regalloc.sgpr_to_vgpr.dwords: 68
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
