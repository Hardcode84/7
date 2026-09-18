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
		v_and_b32_e32 v3, 1, v2
		v_mov_b32_e32 v4, 2
		v_mul_lo_u32 v4, v4, v3
		v_lshrrev_b32_e32 v3, 2, v0
		v_and_b32_e32 v5, 1, v3
		v_mov_b32_e32 v6, 4
		v_mul_lo_u32 v6, v6, v5
		v_bitop3_b32 v5, v1, v4, v6 bitop3:0x96
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
		v_accvgpr_write_b32 a15, v5
		v_xor_b32_e32 v1, 0x80, v1
		v_xor_b32_e32 v1, v1, v4
		v_xor_b32_e32 v1, v1, v6
		v_bitop3_b32 v1, v1, v9, v12 bitop3:0x96
		v_bitop3_b32 v1, v1, v14, v16 bitop3:0x96
		v_accvgpr_write_b32 a16, v1
		v_mov_b32_e32 v1, 2
		v_mul_lo_u32 v1, v1, v11
		v_lshrrev_b32_e32 v4, 5, v0
		v_and_b32_e32 v5, 1, v4
		v_mov_b32_e32 v6, 4
		v_mul_lo_u32 v6, v6, v5
		v_bitop3_b32 v9, v8, v1, v6 bitop3:0x96
		v_mov_b32_e32 v12, 8
		v_mul_lo_u32 v12, v12, v13
		v_xor_b32_e32 v9, v9, v12
		v_mov_b32_e32 v14, 16
		v_mul_lo_u32 v14, v14, v15
		v_xad_u32 v9, v9, v14, s1
		v_bitop3_b32 v16, 32, v8, v1 bitop3:0x96
		v_bitop3_b32 v16, v16, v6, v12 bitop3:0x96
		v_xad_u32 v16, v16, v14, s1
		v_bitop3_b32 v17, 64, v8, v1 bitop3:0x96
		v_bitop3_b32 v17, v17, v6, v12 bitop3:0x96
		v_xad_u32 v17, v17, v14, s1
		v_xor_b32_e32 v18, 0x60, v8
		v_xor_b32_e32 v18, v18, v1
		v_xor_b32_e32 v18, v18, v6
		v_xor_b32_e32 v18, v18, v12
		v_xad_u32 v18, v18, v14, s1
		v_xor_b32_e32 v19, 0x80, v8
		v_xor_b32_e32 v19, v19, v1
		v_xor_b32_e32 v19, v19, v6
		v_xor_b32_e32 v19, v19, v12
		v_xad_u32 v19, v19, v14, s1
		v_xor_b32_e32 v20, 0xa0, v8
		v_xor_b32_e32 v20, v20, v1
		v_xor_b32_e32 v20, v20, v6
		v_xor_b32_e32 v20, v20, v12
		v_xad_u32 v20, v20, v14, s1
		v_xor_b32_e32 v21, 0xc0, v8
		v_xor_b32_e32 v21, v21, v1
		v_xor_b32_e32 v21, v21, v6
		v_xor_b32_e32 v21, v21, v12
		v_xad_u32 v21, v21, v14, s1
		v_xor_b32_e32 v22, 0xe0, v8
		v_xor_b32_e32 v1, v22, v1
		v_xor_b32_e32 v1, v1, v6
		v_xor_b32_e32 v1, v1, v12
		v_xad_u32 v1, v1, v14, s1
		v_cmp_lt_i32_e64 s[22:23], v9, s19
		v_cmp_lt_i32_e64 s[24:25], v16, s19
		v_cmp_lt_i32_e64 s[28:29], v17, s19
		v_cmp_lt_i32_e64 s[30:31], v18, s19
		v_cmp_lt_i32_e64 s[32:33], v19, s19
		v_cmp_lt_i32_e64 s[34:35], v20, s19
		v_cmp_lt_i32_e64 s[36:37], v21, s19
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
		v_accvgpr_read_b32 v9, a13
		s_nop 0
		v_readfirstlane_b32 s18, v9
		s_mul_i32 s18, s18, s12
		s_lshl_b32 s18, s18, 9
		v_accvgpr_read_b32 v9, a11
		s_nop 0
		v_readfirstlane_b32 s21, v9
		s_mul_i32 s21, s21, s10
		s_lshl_b32 s21, s21, 1
		s_add_i32 s26, s18, s21
		v_accvgpr_read_b32 v9, a12
		s_nop 0
		v_readfirstlane_b32 s38, v9
		s_mul_i32 s38, s38, s11
		s_lshl_b32 s38, s38, 1
		s_add_i32 s26, s26, s38
		v_mul_lo_u32 v9, s12, v7
		v_lshl_add_u32 v12, v9, 1, s26
		v_and_b32_e32 v14, 7, v0
		v_lshl_add_u32 v12, v14, 4, v12
		s_and_saveexec_b64 s[100:101], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_0
		buffer_load_dwordx4 v[20:23], v12, s[40:43], 0 offen
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
		v_lshl_add_u32 v12, v9, 1, s22
		v_lshl_add_u32 v12, v14, 4, v12
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_1
		buffer_load_dwordx4 v[24:27], v12, s[40:43], 0 offen
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
		v_lshl_add_u32 v12, v9, 1, s22
		v_lshl_add_u32 v12, v14, 4, v12
		s_and_saveexec_b64 s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_2
		buffer_load_dwordx4 v[28:31], v12, s[40:43], 0 offen
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
		v_lshl_add_u32 v12, v9, 1, s22
		v_lshl_add_u32 v12, v14, 4, v12
		s_and_saveexec_b64 s[100:101], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_3
		buffer_load_dwordx4 v[32:35], v12, s[40:43], 0 offen
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
		v_lshl_add_u32 v12, v9, 1, s22
		v_lshl_add_u32 v12, v14, 4, v12
		s_and_saveexec_b64 s[100:101], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_4
		buffer_load_dwordx4 v[36:39], v12, s[40:43], 0 offen
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
		v_lshl_add_u32 v12, v9, 1, s22
		v_lshl_add_u32 v12, v14, 4, v12
		s_and_saveexec_b64 s[100:101], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_5
		buffer_load_dwordx4 v[40:43], v12, s[40:43], 0 offen
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
		v_lshl_add_u32 v12, v9, 1, s22
		v_lshl_add_u32 v12, v14, 4, v12
		s_and_saveexec_b64 s[100:101], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_6
		buffer_load_dwordx4 v[44:47], v12, s[40:43], 0 offen
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
		v_lshl_add_u32 v9, v9, 1, s18
		v_lshl_add_u32 v9, v14, 4, v9
		v_cmp_lt_i32_e64 vcc, v1, s19
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
		v_and_b32_e32 v1, 5, v4
		v_bitop3_b32 v1, 4, v2, v1 bitop3:0x6a
		v_bitop3_b32 v1, 2, v7, v1 bitop3:0x6a
		v_xor_b32_e32 v1, v0, v1
		v_lshlrev_b32_e32 v1, 4, v1
		v_add_u32_e32 v1, 0x10000, v1
		ds_write_b128 v1, v[20:23] offset:2480
		ds_write_b128 v1, v[24:27] offset:6576
		ds_write_b128 v1, v[28:31] offset:10672
		ds_write_b128 v1, v[32:35] offset:14768
		v_mov_b32_e32 v2, 32
		v_mul_lo_u32 v2, v2, v11
		v_mov_b32_e32 v9, 2
		v_mul_lo_u32 v9, v9, v15
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v11, a14
		s_nop 0
		v_readfirstlane_b32 s18, v11
		s_lshl_b32 s18, s18, 12
		s_add_i32 s18, s18, 0x10000
		v_and_b32_e32 v11, 63, v0
		v_lshrrev_b32_e32 v12, 5, v11
		v_and_b32_e32 v15, 31, v11
		v_lshlrev_b32_e32 v16, 3, v15
		v_add_u32_e32 v17, v12, v16
		v_lshlrev_b32_e32 v18, 2, v15
		v_and_b32_e32 v19, 7, v11
		v_lshrrev_b32_e32 v19, 2, v19
		v_lshrrev_b32_e32 v11, 3, v11
		v_and_b32_e32 v11, 3, v11
		v_lshl_add_u32 v11, v11, 1, v19
		v_and_b32_e32 v11, 5, v11
		v_bitop3_b32 v19, 4, v18, v11 bitop3:0x6a
		v_xor_b32_e32 v17, v17, v19
		v_lshlrev_b32_e32 v17, 4, v17
		v_and_b32_e32 v19, 2, v15
		v_lshlrev_b32_e32 v20, 4, v19
		v_add3_u32 v17, s18, v17, v20
		ds_read_b128 a[20:23], v17 offset:2480
		v_add3_u32 v21, 2, v12, v16
		v_add_u32_e32 v22, 1, v18
		v_bitop3_b32 v22, 4, v22, v11 bitop3:0x6a
		v_bitop3_b32 v21, v21, v19, v22 bitop3:0x96
		v_lshl_add_u32 v21, v21, 4, s18
		ds_read_b128 a[24:27], v21 offset:2480
		v_add3_u32 v22, 4, v12, v16
		v_add_u32_e32 v23, 2, v18
		v_bitop3_b32 v23, 4, v23, v11 bitop3:0x6a
		v_xor_b32_e32 v22, v22, v23
		v_lshlrev_b32_e32 v22, 4, v22
		v_add3_u32 v20, s18, v22, v20
		ds_read_b128 a[28:31], v20 offset:2480
		v_add3_u32 v16, 6, v12, v16
		v_add_u32_e32 v18, 3, v18
		v_bitop3_b32 v11, 4, v18, v11 bitop3:0x6a
		v_bitop3_b32 v11, v16, v19, v11 bitop3:0x96
		v_lshl_add_u32 v11, v11, 4, s18
		ds_read_b128 a[32:35], v11 offset:2480
		v_and_b32_e32 v4, 1, v4
		v_accvgpr_write_b32 a17, v4
		v_and_b32_e32 v4, 1, v10
		v_and_b32_e32 v7, 1, v7
		v_lshlrev_b32_e32 v10, 4, v14
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[36:39] offset:2480
		ds_write_b128 v1, v[40:43] offset:6576
		ds_write_b128 v1, v[44:47] offset:10672
		ds_write_b128 v1, v[48:51] offset:14768
		v_and_b32_e32 v1, 1, v3
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[36:39], v17 offset:2480
		ds_read_b128 a[40:43], v21 offset:2480
		ds_read_b128 a[44:47], v20 offset:2480
		ds_read_b128 a[48:51], v11 offset:2480
		v_accvgpr_read_b32 v3, a13
		s_nop 0
		v_readfirstlane_b32 s18, v3
		s_add_i32 s18, s18, 1
		s_mul_i32 s18, s18, 0x100
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
		s_cselect_b32 s24, s22, 0
		s_add_i32 s23, s23, s24
		s_ashr_i32 s23, s23, 7
		s_cmp_lt_i32 s23, s21
		s_cselect_b32 s23, s23, s21
		s_cmp_gt_i32 s23, 0
		s_cselect_b32 s23, s23, 0
		v_mov_b32_e32 v3, 64
		v_mul_lo_u32 v3, v3, v8
		v_mov_b32_e32 v11, 16
		v_mul_lo_u32 v11, v11, v5
		v_bitop3_b32 v14, v3, v2, v11 bitop3:0x96
		v_bitop3_b32 v14, v14, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a18, v14
		v_bitop3_b32 v14, 4, v3, v2 bitop3:0x96
		v_xor_b32_e32 v14, v14, v11
		v_bitop3_b32 v16, 8, v3, v2 bitop3:0x96
		v_xor_b32_e32 v16, v16, v11
		v_bitop3_b32 v3, 12, v3, v2 bitop3:0x96
		v_accvgpr_read_b32 v17, a18
		v_cmp_lt_i32_e64 s[24:25], v17, s20
		v_mov_b32_e32 v17, 16
		v_mul_lo_u32 v17, v17, v8
		v_mov_b32_e32 v8, 64
		v_mul_lo_u32 v8, v8, v5
		v_bitop3_b32 v5, v17, v2, v8 bitop3:0x96
		v_bitop3_b32 v5, v5, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a19, v5
		v_bitop3_b32 v5, 4, v17, v2 bitop3:0x96
		v_bitop3_b32 v18, 8, v17, v2 bitop3:0x96
		v_bitop3_b32 v2, 12, v17, v2 bitop3:0x96
		v_accvgpr_read_b32 v17, a19
		v_cmp_lt_i32_e64 vcc, v17, s20
		v_readfirstlane_b32 s26, v0
		v_accvgpr_read_b32 v17, a11
		s_nop 0
		v_readfirstlane_b32 s36, v17
		s_mul_i32 s36, s36, s13
		s_lshl_b32 s36, s36, 1
		v_accvgpr_read_b32 v17, a12
		s_nop 0
		v_readfirstlane_b32 s37, v17
		s_mul_i32 s37, s37, s14
		s_lshl_b32 s37, s37, 1
		s_add_i32 s38, s36, s37
		v_accvgpr_read_b32 v17, a14
		s_nop 0
		v_readfirstlane_b32 s39, v17
		s_mul_i32 s39, s15, s39
		s_lshl_b32 s39, s39, 1
		s_add_i32 s38, s38, s39
		v_accvgpr_read_b32 v17, a17
		v_mul_lo_u32 v17, s15, v17
		v_lshlrev_b32_e32 v17, 5, v17
		v_mul_lo_u32 v19, s15, v4
		v_lshlrev_b32_e32 v19, 6, v19
		v_add3_u32 v20, s38, v17, v19
		v_mul_lo_u32 v21, s15, v7
		v_lshlrev_b32_e32 v21, 7, v21
		v_add3_u32 v20, v20, v21, v10
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
		v_add3_u32 v20, s41, v17, v19
		v_add3_u32 v20, v20, v21, v10
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
		v_add3_u32 v20, s41, v17, v19
		v_add3_u32 v20, v20, v21, v10
		v_cndmask_b32_e64 v20, v22, v20, s[24:25]
		s_add_i32 m0, m0, 0x1040
		v_lshlrev_b32_e32 v12, 4, v12
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		v_bitop3_b32 v14, v14, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a56, v14
		s_mul_i32 s41, 24, s15
		s_add_i32 s41, s41, s36
		s_add_i32 s41, s41, s37
		s_add_i32 s41, s41, s39
		v_add3_u32 v14, s41, v17, v19
		v_add3_u32 v14, v14, v21, v10
		v_cndmask_b32_e64 v14, v22, v14, s[24:25]
		s_add_i32 m0, m0, 0x1040
		v_mov_b32_e32 v20, 0x440
		v_mul_lo_u32 v20, v20, v1
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		v_bitop3_b32 v1, v16, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a57, v1
		v_accvgpr_read_b32 v1, a0
		s_nop 0
		v_readfirstlane_b32 s24, v1
		v_accvgpr_read_b32 v1, a11
		s_nop 0
		v_readfirstlane_b32 s25, v1
		s_mul_i32 s24, s25, s24
		s_lshl_b32 s24, s24, 1
		v_accvgpr_read_b32 v1, a1
		s_nop 0
		v_readfirstlane_b32 s25, v1
		v_accvgpr_read_b32 v1, a12
		s_nop 0
		v_readfirstlane_b32 s41, v1
		s_mul_i32 s25, s41, s25
		s_lshl_b32 s25, s25, 1
		s_add_i32 s41, s24, s25
		v_accvgpr_read_b32 v1, a14
		s_nop 0
		v_readfirstlane_b32 s44, v1
		s_mul_i32 s44, s17, s44
		s_lshl_b32 s44, s44, 1
		s_add_i32 s41, s41, s44
		v_accvgpr_read_b32 v1, a17
		v_mul_lo_u32 v1, s17, v1
		v_lshlrev_b32_e32 v1, 7, v1
		v_mul_lo_u32 v14, s17, v4
		v_lshlrev_b32_e32 v14, 6, v14
		v_add3_u32 v16, s41, v1, v14
		v_mul_lo_u32 v23, s17, v7
		v_lshlrev_b32_e32 v23, 5, v23
		v_add3_u32 v16, v16, v23, v10
		v_cndmask_b32_e32 v16, v22, v16, vcc
		s_mul_i32 s38, 0x440, s38
		s_add_i32 m0, s38, 0x81f0
		v_xor_b32_e32 v3, v3, v11
		buffer_load_dwordx4 v16, s[32:35], 0 offen lds
		v_bitop3_b32 v3, v3, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a58, v3
		s_lshl_b32 s41, s17, 3
		s_add_i32 s41, s41, s24
		s_add_i32 s41, s41, s25
		s_add_i32 s41, s41, s44
		v_add3_u32 v3, s41, v1, v14
		v_add3_u32 v3, v3, v23, v10
		v_cndmask_b32_e32 v3, v22, v3, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v5, v5, v8
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
		v_bitop3_b32 v3, v5, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a59, v3
		s_lshl_b32 s41, s17, 4
		s_add_i32 s41, s41, s24
		s_add_i32 s41, s41, s25
		s_add_i32 s41, s41, s44
		v_add3_u32 v3, s41, v1, v14
		v_add3_u32 v3, v3, v23, v10
		v_cndmask_b32_e32 v3, v22, v3, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v5, v18, v8
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
		v_bitop3_b32 v3, v5, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a60, v3
		s_mul_i32 s41, 24, s17
		s_add_i32 s41, s41, s24
		s_add_i32 s41, s41, s25
		s_add_i32 s41, s41, s44
		v_add3_u32 v3, s41, v1, v14
		v_add3_u32 v3, v3, v23, v10
		v_cndmask_b32_e32 v3, v22, v3, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v2, v2, v8
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
		v_bitop3_b32 v2, v2, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a61, v2
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
		v_mov_b32_e32 v2, 0x3e38aa3b
		v_mov_b32_e32 v3, 0x3e38aa3b
		s_mov_b32 s25, 0xff800000
		v_mov_b32_e32 v5, s25
		v_mov_b32_e32 v8, s25
		s_mov_b32 s25, 1.0
		v_mov_b32_e32 v24, s25
		v_mov_b32_e32 v25, s25
		s_mov_b32 s25, 0
		v_lshrrev_b32_e32 v9, 4, v15
		v_lshlrev_b32_e32 v9, 9, v9
		v_and_b32_e32 v11, 15, v15
		v_mov_b32_e32 v13, 0x410
		v_mul_lo_u32 v13, v13, v11
		v_add3_u32 v9, v12, v9, v13
		v_accvgpr_write_b32 a62, v9
		v_and_b32_e32 v9, 3, v0
		v_accvgpr_read_b32 v11, a17
		v_mov_b32_e32 v12, 0x2200
		v_mul_lo_u32 v12, v12, v11
		v_lshl_add_u32 v9, v9, 3, v12
		v_lshl_add_u32 v4, v4, 5, v9
		v_mov_b32_e32 v9, 0x880
		v_mul_lo_u32 v9, v9, v7
		v_add3_u32 v4, v4, v9, v20
		v_accvgpr_write_b32 a63, v4
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
		v_accvgpr_read_b32 v4, a62
		v_add_u32_e32 v4, s49, v4
		ds_read_b128 v[28:31], v4
		ds_read_b128 v[96:99], v4 offset:32
		ds_read_b128 v[100:103], v4 offset:64
		ds_read_b128 a[64:67], v4 offset:96
		ds_read_b128 v[104:107], v4 offset:256
		ds_read_b128 v[108:111], v4 offset:288
		ds_read_b128 v[112:115], v4 offset:320
		ds_read_b128 a[68:71], v4 offset:352
		ds_read_b128 v[116:119], v4 offset:128
		ds_read_b128 v[120:123], v4 offset:160
		ds_read_b128 v[124:127], v4 offset:192
		ds_read_b128 a[72:75], v4 offset:224
		ds_read_b128 v[128:131], v4 offset:384
		ds_read_b128 a[76:79], v4 offset:416
		ds_read_b128 a[80:83], v4 offset:448
		ds_read_b128 a[84:87], v4 offset:480
		s_mul_i32 s48, 0x4400, s48
		v_accvgpr_read_b32 v4, a63
		v_add_u32_e32 v4, s48, v4
		ds_read_b64_tr_b16 a[88:89], v4 offset:33264
		ds_read_b64_tr_b16 a[90:91], v4 offset:37616
		ds_read_b64_tr_b16 a[92:93], v4 offset:33392
		ds_read_b64_tr_b16 a[94:95], v4 offset:37744
		ds_read_b64_tr_b16 a[96:97], v4 offset:33520
		ds_read_b64_tr_b16 a[98:99], v4 offset:37872
		ds_read_b64_tr_b16 a[100:101], v4 offset:33648
		ds_read_b64_tr_b16 a[102:103], v4 offset:38000
		ds_read_b64_tr_b16 a[104:105], v4 offset:33776
		ds_read_b64_tr_b16 a[106:107], v4 offset:38128
		ds_read_b64_tr_b16 a[108:109], v4 offset:33904
		ds_read_b64_tr_b16 a[110:111], v4 offset:38256
		ds_read_b64_tr_b16 a[112:113], v4 offset:34032
		ds_read_b64_tr_b16 a[114:115], v4 offset:38384
		ds_read_b64_tr_b16 a[116:117], v4 offset:34160
		ds_read_b64_tr_b16 a[118:119], v4 offset:38512
		ds_read_b64_tr_b16 a[120:121], v4 offset:33328
		ds_read_b64_tr_b16 a[122:123], v4 offset:37680
		ds_read_b64_tr_b16 a[124:125], v4 offset:33456
		ds_read_b64_tr_b16 a[126:127], v4 offset:37808
		ds_read_b64_tr_b16 a[128:129], v4 offset:33584
		ds_read_b64_tr_b16 a[130:131], v4 offset:37936
		ds_read_b64_tr_b16 a[132:133], v4 offset:33712
		ds_read_b64_tr_b16 a[134:135], v4 offset:38064
		ds_read_b64_tr_b16 a[136:137], v4 offset:33840
		ds_read_b64_tr_b16 a[138:139], v4 offset:38192
		ds_read_b64_tr_b16 a[140:141], v4 offset:33968
		ds_read_b64_tr_b16 a[142:143], v4 offset:38320
		ds_read_b64_tr_b16 a[144:145], v4 offset:34096
		ds_read_b64_tr_b16 a[146:147], v4 offset:38448
		ds_read_b64_tr_b16 a[148:149], v4 offset:34224
		ds_read_b64_tr_b16 a[150:151], v4 offset:38576
		s_mul_i32 s48, s15, s25
		s_lshl_b32 s48, s48, 1
		s_add_i32 s49, s23, s48
		v_add3_u32 v4, s49, v17, v19
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[20:23], 0
		v_add3_u32 v4, v4, v21, v10
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
		v_add3_u32 v7, s49, v17, v19
		v_mfma_f32_32x32x16_bf16 v[176:191], v[112:115], a[28:31], v[176:191]
		v_add3_u32 v7, v7, v21, v10
		v_mfma_f32_32x32x16_bf16 v[192:207], v[104:107], a[36:39], 0
		s_add_i32 s49, s46, s48
		v_mfma_f32_32x32x16_bf16 v[192:207], v[108:111], a[40:43], v[192:207]
		v_add3_u32 v9, s49, v17, v19
		v_mfma_f32_32x32x16_bf16 v[192:207], v[112:115], a[44:47], v[192:207]
		v_add3_u32 v9, v9, v21, v10
		v_mfma_f32_32x32x16_bf16 v[96:111], v[116:119], a[20:23], 0
		s_add_i32 s48, s36, s48
		v_mfma_f32_32x32x16_bf16 v[96:111], v[120:123], a[24:27], v[96:111]
		v_add3_u32 v11, s48, v17, v19
		v_mfma_f32_32x32x16_bf16 v[96:111], v[124:127], a[28:31], v[96:111]
		v_add3_u32 v11, v11, v21, v10
		v_mfma_f32_32x32x16_bf16 v[208:223], v[116:119], a[36:39], 0
		s_mul_i32 s48, s17, s25
		v_mfma_f32_32x32x16_bf16 v[208:223], v[120:123], a[40:43], v[208:223]
		s_add_i32 s25, s25, 0x80
		v_mfma_f32_32x32x16_bf16 v[208:223], v[124:127], a[44:47], v[208:223]
		v_accvgpr_read_b32 v12, a18
		v_add_u32_e32 v12, s25, v12
		v_mfma_f32_32x32x16_bf16 v[112:127], v[128:131], a[20:23], 0
		v_accvgpr_read_b32 v13, a56
		v_add_u32_e32 v13, s25, v13
		v_mfma_f32_32x32x16_bf16 v[112:127], a[76:79], a[24:27], v[112:127]
		v_accvgpr_read_b32 v15, a57
		v_add_u32_e32 v15, s25, v15
		v_mfma_f32_32x32x16_bf16 v[112:127], a[80:83], a[28:31], v[112:127]
		v_accvgpr_read_b32 v16, a58
		v_add_u32_e32 v16, s25, v16
		v_mfma_f32_32x32x16_bf16 v[224:239], v[128:131], a[36:39], 0
		v_cmp_lt_i32_e64 s[50:51], v12, s20
		v_accvgpr_read_b32 v12, a19
		v_add_u32_e32 v12, s25, v12
		v_accvgpr_read_b32 v18, a59
		v_add_u32_e32 v18, s25, v18
		v_accvgpr_read_b32 v20, a60
		v_add_u32_e32 v20, s25, v20
		v_accvgpr_read_b32 v26, a61
		v_add_u32_e32 v26, s25, v26
		v_cmp_lt_i32_e64 vcc, v26, s20
		v_cndmask_b32_e64 v4, v22, v4, s[50:51]
		buffer_load_dwordx4 v4, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[50:51], v13, s20
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[52:53], v15, s20
		v_cndmask_b32_e64 v4, v22, v7, s[50:51]
		v_cmp_lt_i32_e64 s[50:51], v16, s20
		buffer_load_dwordx4 v4, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], a[76:79], a[40:43], v[224:239]
		v_cndmask_b32_e64 v4, v22, v9, s[52:53]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[80:83], a[44:47], v[224:239]
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v7, v22, v11, s[50:51]
		buffer_load_dwordx4 v4, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[50:51], v12, s20
		v_cmp_lt_i32_e64 s[52:53], v18, s20
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s48, s48, 1
		s_add_i32 s49, s37, s48
		buffer_load_dwordx4 v7, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[144:159], a[64:67], a[32:35], v[144:159]
		v_add3_u32 v4, s49, v1, v14
		v_mfma_f32_32x32x16_bf16 v[160:175], a[64:67], a[48:51], v[160:175]
		v_add3_u32 v4, v4, v23, v10
		v_cndmask_b32_e64 v4, v22, v4, s[50:51]
		v_cmp_lt_i32_e64 s[50:51], v20, s20
		s_mul_i32 s44, 0x4400, s44
		s_add_i32 s44, s38, s44
		s_add_i32 m0, s44, 0x81f0
		s_add_i32 s44, s39, s48
		buffer_load_dwordx4 v4, s[32:35], 0 offen lds
		v_add3_u32 v4, s44, v1, v14
		v_add3_u32 v4, v4, v23, v10
		v_cndmask_b32_e64 v4, v22, v4, s[52:53]
		v_max3_f32 v7, v144, v145, v146
		s_add_i32 m0, m0, 0x1100
		s_add_i32 s44, s47, s48
		buffer_load_dwordx4 v4, s[32:35], 0 offen lds
		v_add3_u32 v4, s44, v1, v14
		v_add3_u32 v4, v4, v23, v10
		v_max3_f32 v9, v148, v149, v150
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v4, v22, v4, s[50:51]
		buffer_load_dwordx4 v4, s[32:35], 0 offen lds
		v_max3_f32 v4, v152, v153, v154
		s_add_i32 s44, s24, s48
		v_add3_u32 v11, s44, v1, v14
		v_add3_u32 v11, v11, v23, v10
		v_cndmask_b32_e32 v11, v22, v11, vcc
		v_max3_f32 v12, v156, v157, v158
		s_add_i32 m0, m0, 0x1100
		v_max3_f32 v7, v7, v147, v9
		v_max3_f32 v4, v4, v155, v12
		v_max3_f32 v4, v7, v151, v4
		v_max3_f32 v7, v160, v161, v162
		v_max3_f32 v9, v164, v165, v166
		v_max3_f32 v12, v168, v169, v170
		v_max3_f32 v13, v172, v173, v174
		v_max3_f32 v7, v7, v163, v9
		v_max3_f32 v9, v12, v171, v13
		v_max3_f32 v7, v7, v167, v9
		s_cmp_lt_i32 s25, s41
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[176:191], a[68:71], a[32:35], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[72:75], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[84:87], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[84:87], a[48:51], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[68:71], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[72:75], a[48:51], v[208:223]
		s_nop 6
		v_max3_f32 v9, v176, v177, v178
		v_max3_f32 v11, v180, v181, v182
		v_max3_f32 v12, v184, v185, v186
		v_max3_f32 v13, v188, v189, v190
		v_max3_f32 v15, v96, v97, v98
		v_max3_f32 v16, v100, v101, v102
		v_max3_f32 v18, v104, v105, v106
		v_max3_f32 v20, v108, v109, v110
		v_max3_f32 v26, v112, v113, v114
		v_max3_f32 v27, v116, v117, v118
		v_max3_f32 v28, v120, v121, v122
		v_max3_f32 v29, v124, v125, v126
		v_max3_f32 v9, v9, v179, v11
		v_max3_f32 v11, v12, v187, v13
		v_max3_f32 v12, v15, v99, v16
		v_max3_f32 v13, v18, v107, v20
		v_max3_f32 v15, v26, v115, v27
		v_max3_f32 v16, v28, v123, v29
		v_max3_f32 v9, v9, v183, v11
		v_max3_f32 v11, v12, v103, v13
		v_max3_f32 v12, v15, v119, v16
		v_max3_f32 v4, v4, v159, v9
		v_max3_f32 v9, v11, v111, v12
		v_max3_f32 v4, v4, v191, v9
		v_max_f32_e32 v12, v4, v127
		v_mov_b32_e32 v13, v12
		v_max3_f32 v4, v192, v193, v194
		v_max3_f32 v9, v196, v197, v198
		v_max3_f32 v11, v200, v201, v202
		v_max3_f32 v15, v204, v205, v206
		v_max3_f32 v16, v208, v209, v210
		v_max3_f32 v18, v212, v213, v214
		v_max3_f32 v20, v216, v217, v218
		v_max3_f32 v26, v220, v221, v222
		v_max3_f32 v27, v224, v225, v226
		v_max3_f32 v28, v228, v229, v230
		v_max3_f32 v29, v232, v233, v234
		v_max3_f32 v30, v236, v237, v238
		v_max3_f32 v4, v4, v195, v9
		v_max3_f32 v9, v11, v203, v15
		v_max3_f32 v11, v16, v211, v18
		v_max3_f32 v15, v20, v219, v26
		v_permlane32_swap_b32_e32 v12, v13
		v_max3_f32 v16, v27, v227, v28
		v_max3_f32 v18, v29, v235, v30
		v_max3_f32 v4, v4, v199, v9
		v_max3_f32 v9, v11, v215, v15
		v_max3_f32 v11, v16, v231, v18
		v_max3_f32 v4, v7, v175, v4
		v_max3_f32 v7, v9, v223, v11
		v_max3_f32 v4, v4, v207, v7
		v_max_f32_e32 v26, v4, v239
		v_mov_b32_e32 v27, v26
		v_max_f32_e32 v28, v12, v13
		v_mov_b32_e32 v12, v5
		v_permlane32_swap_b32_e32 v26, v27
		v_max_f32_e32 v29, v26, v27
		v_pk_mul_f32 v[26:27], v[28:29], v[2:3]
		v_max_f32_e32 v28, v5, v26
		v_max_f32_e32 v29, v8, v27
		v_pk_fma_f32 v[4:5], v[144:145], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[146:147], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[148:149], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[150:151], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[152:153], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[154:155], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[156:157], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[158:159], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[176:177], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[178:179], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[180:181], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[182:183], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[184:185], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[186:187], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[188:189], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[190:191], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[96:97], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[98:99], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[108:109], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[110:111], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[112:113], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[114:115], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[116:117], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[118:119], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[120:121], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[122:123], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[124:125], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[126:127], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[160:161], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[162:163], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[164:165], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[166:167], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[168:169], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[170:171], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[172:173], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[174:175], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[192:193], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[194:195], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[196:197], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[198:199], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[200:201], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[202:203], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[204:205], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[206:207], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[208:209], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[210:211], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[212:213], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[214:215], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[216:217], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[218:219], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[220:221], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[222:223], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[224:225], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[226:227], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[228:229], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[230:231], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[232:233], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[234:235], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[236:237], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[238:239], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v218, v4
		v_exp_f32_e32 v220, v5
		v_exp_f32_e32 v4, v26
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
		v_exp_f32_e32 v219, v154
		v_exp_f32_e32 v221, v155
		v_exp_f32_e32 v5, v96
		v_exp_f32_e32 v223, v97
		v_exp_f32_e32 v27, v98
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
		v_exp_f32_e32 v145, v118
		v_exp_f32_e32 v245, v119
		v_exp_f32_e32 v147, v120
		v_exp_f32_e32 v247, v121
		v_exp_f32_e32 v149, v122
		v_exp_f32_e32 v249, v123
		v_exp_f32_e32 v151, v124
		v_exp_f32_e32 v251, v125
		v_exp_f32_e32 v96, v156
		v_exp_f32_e32 v98, v157
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
		v_exp_f32_e32 v152, v171
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
		v_exp_f32_e32 v183, v186
		v_exp_f32_e32 v185, v187
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
		v_exp_f32_e32 v153, v203
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
		v_pk_add_f32 v[186:187], v[218:219], v[220:221]
		v_pk_add_f32 v[188:189], v[4:5], v[222:223]
		v_pk_add_f32 v[190:191], v[26:27], v[224:225]
		v_pk_add_f32 v[192:193], v[30:31], v[226:227]
		v_pk_add_f32 v[194:195], v[128:129], v[228:229]
		v_pk_add_f32 v[196:197], v[130:131], v[230:231]
		v_pk_add_f32 v[198:199], v[132:133], v[232:233]
		v_pk_add_f32 v[200:201], v[134:135], v[234:235]
		v_pk_add_f32 v[202:203], v[136:137], v[236:237]
		v_pk_add_f32 v[204:205], v[138:139], v[238:239]
		v_pk_add_f32 v[206:207], v[140:141], v[240:241]
		v_pk_add_f32 v[208:209], v[142:143], v[242:243]
		v_pk_add_f32 v[210:211], v[144:145], v[244:245]
		v_pk_add_f32 v[212:213], v[146:147], v[246:247]
		v_pk_add_f32 v[214:215], v[148:149], v[248:249]
		v_pk_add_f32 v[216:217], v[150:151], v[250:251]
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
		v_add_f32_e32 v186, v190, v191
		v_mov_b32_e32 v187, v186
		v_exp_f32_e32 v182, v126
		v_exp_f32_e32 v184, v127
		v_permlane32_swap_b32_e32 v186, v187
		v_pk_add_f32 v[126:127], v[182:183], v[184:185]
		v_pk_add_f32 v[188:189], v[96:97], v[98:99]
		v_pk_add_f32 v[190:191], v[100:101], v[102:103]
		v_pk_add_f32 v[192:193], v[104:105], v[106:107]
		v_pk_add_f32 v[194:195], v[108:109], v[110:111]
		v_pk_add_f32 v[196:197], v[112:113], v[114:115]
		v_pk_add_f32 v[198:199], v[116:117], v[118:119]
		v_pk_add_f32 v[200:201], v[120:121], v[122:123]
		v_pk_add_f32 v[202:203], v[124:125], v[152:153]
		v_pk_add_f32 v[204:205], v[154:155], v[156:157]
		v_pk_add_f32 v[206:207], v[158:159], v[160:161]
		v_pk_add_f32 v[208:209], v[162:163], v[164:165]
		v_pk_add_f32 v[210:211], v[166:167], v[168:169]
		v_pk_add_f32 v[212:213], v[170:171], v[172:173]
		v_pk_add_f32 v[214:215], v[174:175], v[176:177]
		v_pk_add_f32 v[216:217], v[178:179], v[180:181]
		v_pk_add_f32 v[126:127], v[126:127], v[188:189]
		v_pk_add_f32 v[188:189], v[190:191], v[192:193]
		v_pk_add_f32 v[190:191], v[194:195], v[196:197]
		v_pk_add_f32 v[192:193], v[198:199], v[200:201]
		v_pk_add_f32 v[194:195], v[202:203], v[204:205]
		v_pk_add_f32 v[196:197], v[206:207], v[208:209]
		v_pk_add_f32 v[198:199], v[210:211], v[212:213]
		v_pk_add_f32 v[200:201], v[214:215], v[216:217]
		v_pk_add_f32 v[126:127], v[126:127], v[188:189]
		v_pk_add_f32 v[188:189], v[190:191], v[192:193]
		v_pk_add_f32 v[190:191], v[194:195], v[196:197]
		v_pk_add_f32 v[192:193], v[198:199], v[200:201]
		v_pk_add_f32 v[126:127], v[126:127], v[188:189]
		v_pk_add_f32 v[188:189], v[190:191], v[192:193]
		v_pk_add_f32 v[190:191], v[126:127], v[188:189]
		v_mov_b32_e32 v126, v187
		v_mov_b32_e32 v127, v191
		v_mov_b32_e32 v188, v186
		v_mov_b32_e32 v189, v190
		v_pk_add_f32 v[186:187], v[188:189], v[126:127]
		v_mov_b32_e32 v126, v187
		v_mov_b32_e32 v127, v187
		v_cvt_pk_bf16_f32 v188, v218, v220
		v_cvt_pk_bf16_f32 v189, v4, v222
		v_permlane32_swap_b32_e32 v126, v127
		v_add_f32_e32 v193, v126, v127
		v_mov_b32_e32 v13, v8
		v_pk_add_f32 v[8:9], v[12:13], v[28:29] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v12, v8
		v_exp_f32_e32 v13, v9
		v_cvt_pk_bf16_f32 v190, v26, v224
		v_mov_b32_e32 v192, v186
		v_mov_b64_e32 v[8:9], v[24:25]
		v_pk_fma_f32 v[24:25], v[8:9], v[12:13], v[192:193]
		v_cvt_pk_bf16_f32 v191, v30, v226
		v_cvt_pk_bf16_f32 v192, v128, v228
		v_cvt_pk_bf16_f32 v193, v130, v230
		v_cvt_pk_bf16_f32 v194, v132, v232
		v_cvt_pk_bf16_f32 v195, v134, v234
		v_cvt_pk_bf16_f32 v196, v136, v236
		v_cvt_pk_bf16_f32 v197, v138, v238
		v_cvt_pk_bf16_f32 v198, v140, v240
		v_cvt_pk_bf16_f32 v199, v142, v242
		v_cvt_pk_bf16_f32 v200, v144, v244
		v_cvt_pk_bf16_f32 v201, v146, v246
		v_cvt_pk_bf16_f32 v202, v148, v248
		v_cvt_pk_bf16_f32 v203, v150, v250
		v_cvt_pk_bf16_f32 v204, v219, v221
		v_pk_mul_f32 v[32:33], v[32:33], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[34:35], v[34:35], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[36:37], v[36:37], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[38:39], v[38:39], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[40:41], v[40:41], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[42:43], v[42:43], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[44:45], v[44:45], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[46:47], v[46:47], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[48:49], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[50:51], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[52:53], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[54:55], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[56:57], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[58:59], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[60:61], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[62:63], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[64:65], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[66:67], v[66:67], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[68:69], v[68:69], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[70:71], v[70:71], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[72:73], v[72:73], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[74:75], v[74:75], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[76:77], v[76:77], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[78:79], v[78:79], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[80:81], v[80:81], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[82:83], v[82:83], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[84:85], v[84:85], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[86:87], v[86:87], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[88:89], v[88:89], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[90:91], v[90:91], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[92:93], v[92:93], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[94:95], v[94:95], v[12:13] op_sel:[0,1]
		v_cvt_pk_bf16_f32 v205, v5, v223
		v_cvt_pk_bf16_f32 v206, v27, v225
		v_cvt_pk_bf16_f32 v207, v31, v227
		v_cvt_pk_bf16_f32 v208, v129, v229
		v_cvt_pk_bf16_f32 v209, v131, v231
		v_cvt_pk_bf16_f32 v210, v133, v233
		v_cvt_pk_bf16_f32 v211, v135, v235
		v_cvt_pk_bf16_f32 v128, v137, v237
		v_cvt_pk_bf16_f32 v129, v139, v239
		v_cvt_pk_bf16_f32 v130, v141, v241
		v_cvt_pk_bf16_f32 v131, v143, v243
		v_cvt_pk_bf16_f32 v132, v145, v245
		v_cvt_pk_bf16_f32 v133, v147, v247
		v_cvt_pk_bf16_f32 v134, v149, v249
		v_cvt_pk_bf16_f32 v135, v151, v251
		v_cvt_pk_bf16_f32 v136, v182, v184
		v_cvt_pk_bf16_f32 v137, v96, v98
		v_cvt_pk_bf16_f32 v138, v100, v102
		v_cvt_pk_bf16_f32 v139, v104, v106
		v_cvt_pk_bf16_f32 v140, v108, v110
		v_cvt_pk_bf16_f32 v141, v112, v114
		v_cvt_pk_bf16_f32 v142, v116, v118
		v_cvt_pk_bf16_f32 v143, v120, v122
		v_cvt_pk_bf16_f32 v144, v124, v152
		v_cvt_pk_bf16_f32 v145, v154, v156
		v_cvt_pk_bf16_f32 v146, v158, v160
		v_cvt_pk_bf16_f32 v147, v162, v164
		v_cvt_pk_bf16_f32 v148, v166, v168
		v_cvt_pk_bf16_f32 v149, v170, v172
		v_cvt_pk_bf16_f32 v150, v174, v176
		v_cvt_pk_bf16_f32 v151, v178, v180
		v_cvt_pk_bf16_f32 v212, v183, v185
		v_cvt_pk_bf16_f32 v213, v97, v99
		v_cvt_pk_bf16_f32 v214, v101, v103
		v_cvt_pk_bf16_f32 v215, v105, v107
		v_cvt_pk_bf16_f32 v96, v109, v111
		v_cvt_pk_bf16_f32 v97, v113, v115
		v_cvt_pk_bf16_f32 v98, v117, v119
		v_cvt_pk_bf16_f32 v99, v121, v123
		v_cvt_pk_bf16_f32 v100, v125, v153
		v_cvt_pk_bf16_f32 v101, v155, v157
		v_cvt_pk_bf16_f32 v102, v159, v161
		v_cvt_pk_bf16_f32 v103, v163, v165
		v_cvt_pk_bf16_f32 v104, v167, v169
		v_cvt_pk_bf16_f32 v105, v171, v173
		v_cvt_pk_bf16_f32 v106, v175, v177
		v_cvt_pk_bf16_f32 v107, v179, v181
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_mfma_f32_32x32x16_bf16 v[32:47], a[88:91], v[188:191], v[32:47]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[48:63], a[120:123], v[188:191], v[48:63]
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_mfma_f32_32x32x16_bf16 v[32:47], a[92:95], v[192:195], v[32:47]
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_mfma_f32_32x32x16_bf16 v[48:63], a[124:127], v[192:195], v[48:63]
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
		v_mov_b32_e32 v5, v28
		v_mov_b32_e32 v8, v29
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_1
.L_attn_fwd_persistent.loop_exit_1:
		s_mul_i32 s21, s21, 0x80
		v_accvgpr_read_b32 v4, a15
		v_accvgpr_read_b32 v7, a6
		s_nop 0
		v_readfirstlane_b32 s25, v7
		s_nop 1
		v_add_u32_e32 v4, s25, v4
		v_add_u32_e32 v4, s1, v4
		v_accvgpr_read_b32 v7, a16
		v_accvgpr_read_b32 v9, a6
		s_nop 0
		v_readfirstlane_b32 s25, v9
		s_nop 1
		v_add_u32_e32 v7, s25, v7
		v_add_u32_e32 v7, s1, v7
		v_xor_b32_e32 v9, 1, v6
		v_accvgpr_write_b32 a15, v9
		v_xor_b32_e32 v9, 2, v6
		v_accvgpr_write_b32 a16, v9
		v_xor_b32_e32 v9, 3, v6
		v_accvgpr_write_b32 a64, v9
		v_xor_b32_e32 v9, 8, v6
		v_accvgpr_write_b32 a65, v9
		v_xor_b32_e32 v9, 9, v6
		v_accvgpr_write_b32 a66, v9
		v_xor_b32_e32 v9, 10, v6
		v_accvgpr_write_b32 a67, v9
		v_xor_b32_e32 v9, 11, v6
		v_accvgpr_write_b32 a68, v9
		v_xor_b32_e32 v9, 16, v6
		v_accvgpr_write_b32 a69, v9
		v_xor_b32_e32 v9, 17, v6
		v_accvgpr_write_b32 a70, v9
		v_xor_b32_e32 v9, 18, v6
		v_accvgpr_write_b32 a71, v9
		v_xor_b32_e32 v9, 19, v6
		v_accvgpr_write_b32 a72, v9
		v_xor_b32_e32 v9, 24, v6
		v_accvgpr_write_b32 a73, v9
		v_xor_b32_e32 v9, 25, v6
		v_accvgpr_write_b32 a74, v9
		v_xor_b32_e32 v9, 26, v6
		v_accvgpr_write_b32 a75, v9
		v_xor_b32_e32 v9, 27, v6
		v_accvgpr_write_b32 a76, v9
		v_xor_b32_e32 v9, 32, v6
		v_accvgpr_write_b32 a77, v9
		v_xor_b32_e32 v9, 33, v6
		v_accvgpr_write_b32 a78, v9
		v_xor_b32_e32 v9, 34, v6
		v_accvgpr_write_b32 a79, v9
		v_xor_b32_e32 v9, 35, v6
		v_accvgpr_write_b32 a80, v9
		v_xor_b32_e32 v9, 40, v6
		v_accvgpr_write_b32 a81, v9
		v_xor_b32_e32 v9, 41, v6
		v_accvgpr_write_b32 a82, v9
		v_xor_b32_e32 v9, 42, v6
		v_accvgpr_write_b32 a83, v9
		v_xor_b32_e32 v9, 43, v6
		v_accvgpr_write_b32 a84, v9
		v_xor_b32_e32 v9, 48, v6
		v_accvgpr_write_b32 a85, v9
		v_xor_b32_e32 v9, 49, v6
		v_accvgpr_write_b32 a86, v9
		v_xor_b32_e32 v9, 50, v6
		v_accvgpr_write_b32 a87, v9
		v_xor_b32_e32 v9, 51, v6
		v_accvgpr_write_b32 a88, v9
		v_xor_b32_e32 v9, 56, v6
		v_accvgpr_write_b32 a89, v9
		v_xor_b32_e32 v9, 57, v6
		v_accvgpr_write_b32 a90, v9
		v_xor_b32_e32 v9, 58, v6
		v_accvgpr_write_b32 a91, v9
		v_xor_b32_e32 v9, 59, v6
		v_accvgpr_write_b32 a92, v9
		v_xor_b32_e32 v9, 64, v6
		v_accvgpr_write_b32 a93, v9
		v_xor_b32_e32 v9, 0x41, v6
		v_accvgpr_write_b32 a94, v9
		v_xor_b32_e32 v9, 0x42, v6
		v_accvgpr_write_b32 a95, v9
		v_xor_b32_e32 v9, 0x43, v6
		v_accvgpr_write_b32 a96, v9
		v_xor_b32_e32 v9, 0x48, v6
		v_accvgpr_write_b32 a97, v9
		v_xor_b32_e32 v9, 0x49, v6
		v_accvgpr_write_b32 a98, v9
		v_xor_b32_e32 v9, 0x4a, v6
		v_accvgpr_write_b32 a99, v9
		v_xor_b32_e32 v9, 0x4b, v6
		v_accvgpr_write_b32 a100, v9
		v_xor_b32_e32 v9, 0x50, v6
		v_accvgpr_write_b32 a101, v9
		v_xor_b32_e32 v9, 0x51, v6
		v_accvgpr_write_b32 a102, v9
		v_xor_b32_e32 v9, 0x52, v6
		v_accvgpr_write_b32 a103, v9
		v_xor_b32_e32 v9, 0x53, v6
		v_accvgpr_write_b32 a104, v9
		v_xor_b32_e32 v9, 0x58, v6
		v_accvgpr_write_b32 a105, v9
		v_xor_b32_e32 v9, 0x59, v6
		v_accvgpr_write_b32 a106, v9
		v_xor_b32_e32 v9, 0x5a, v6
		v_accvgpr_write_b32 a107, v9
		v_xor_b32_e32 v9, 0x5b, v6
		v_accvgpr_write_b32 a108, v9
		v_xor_b32_e32 v9, 0x60, v6
		v_accvgpr_write_b32 a109, v9
		v_xor_b32_e32 v9, 0x61, v6
		v_accvgpr_write_b32 a110, v9
		v_xor_b32_e32 v9, 0x62, v6
		v_accvgpr_write_b32 a111, v9
		v_xor_b32_e32 v9, 0x63, v6
		v_accvgpr_write_b32 a112, v9
		v_xor_b32_e32 v9, 0x68, v6
		v_accvgpr_write_b32 a113, v9
		v_xor_b32_e32 v9, 0x69, v6
		v_accvgpr_write_b32 a114, v9
		v_xor_b32_e32 v9, 0x6a, v6
		v_accvgpr_write_b32 a115, v9
		v_xor_b32_e32 v9, 0x6b, v6
		v_accvgpr_write_b32 a116, v9
		v_xor_b32_e32 v9, 0x70, v6
		v_accvgpr_write_b32 a117, v9
		v_xor_b32_e32 v9, 0x71, v6
		v_accvgpr_write_b32 a118, v9
		v_xor_b32_e32 v9, 0x72, v6
		v_accvgpr_write_b32 a119, v9
		v_xor_b32_e32 v9, 0x73, v6
		v_accvgpr_write_b32 a120, v9
		v_xor_b32_e32 v9, 0x78, v6
		v_accvgpr_write_b32 a121, v9
		v_xor_b32_e32 v9, 0x79, v6
		v_accvgpr_write_b32 a122, v9
		v_xor_b32_e32 v9, 0x7a, v6
		v_accvgpr_write_b32 a123, v9
		v_xor_b32_e32 v9, 0x7b, v6
		v_accvgpr_write_b32 a124, v9
		v_mov_b32_e32 v9, 0xff800000
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
		v_accvgpr_read_b32 v11, a62
		v_add_u32_e32 v11, s25, v11
		ds_read_b128 v[28:31], v11
		ds_read_b128 a[128:131], v11 offset:32
		ds_read_b128 a[132:135], v11 offset:64
		ds_read_b128 a[136:139], v11 offset:96
		ds_read_b128 a[140:143], v11 offset:256
		ds_read_b128 a[144:147], v11 offset:288
		ds_read_b128 a[148:151], v11 offset:320
		ds_read_b128 a[152:155], v11 offset:352
		ds_read_b128 a[156:159], v11 offset:128
		ds_read_b128 a[160:163], v11 offset:160
		ds_read_b128 a[164:167], v11 offset:192
		ds_read_b128 a[168:171], v11 offset:224
		ds_read_b128 v[96:99], v11 offset:384
		ds_read_b128 a[172:175], v11 offset:416
		ds_read_b128 a[176:179], v11 offset:448
		ds_read_b128 a[180:183], v11 offset:480
		s_mul_i32 s25, 0x4400, s38
		v_accvgpr_read_b32 v11, a63
		v_add_u32_e32 v11, s25, v11
		ds_read_b64_tr_b16 a[184:185], v11 offset:33264
		ds_read_b64_tr_b16 a[186:187], v11 offset:37616
		ds_read_b64_tr_b16 a[188:189], v11 offset:33392
		ds_read_b64_tr_b16 a[190:191], v11 offset:37744
		ds_read_b64_tr_b16 a[192:193], v11 offset:33520
		ds_read_b64_tr_b16 a[194:195], v11 offset:37872
		ds_read_b64_tr_b16 a[196:197], v11 offset:33648
		ds_read_b64_tr_b16 a[198:199], v11 offset:38000
		ds_read_b64_tr_b16 a[200:201], v11 offset:33776
		ds_read_b64_tr_b16 a[202:203], v11 offset:38128
		ds_read_b64_tr_b16 a[204:205], v11 offset:33904
		ds_read_b64_tr_b16 a[206:207], v11 offset:38256
		ds_read_b64_tr_b16 a[208:209], v11 offset:34032
		ds_read_b64_tr_b16 a[210:211], v11 offset:38384
		ds_read_b64_tr_b16 a[212:213], v11 offset:34160
		ds_read_b64_tr_b16 a[214:215], v11 offset:38512
		ds_read_b64_tr_b16 a[216:217], v11 offset:33328
		ds_read_b64_tr_b16 a[218:219], v11 offset:37680
		ds_read_b64_tr_b16 a[220:221], v11 offset:33456
		ds_read_b64_tr_b16 a[222:223], v11 offset:37808
		ds_read_b64_tr_b16 a[224:225], v11 offset:33584
		ds_read_b64_tr_b16 a[226:227], v11 offset:37936
		ds_read_b64_tr_b16 a[228:229], v11 offset:33712
		ds_read_b64_tr_b16 a[230:231], v11 offset:38064
		ds_read_b64_tr_b16 a[232:233], v11 offset:33840
		ds_read_b64_tr_b16 a[234:235], v11 offset:38192
		ds_read_b64_tr_b16 a[236:237], v11 offset:33968
		ds_read_b64_tr_b16 a[238:239], v11 offset:38320
		ds_read_b64_tr_b16 a[240:241], v11 offset:34096
		ds_read_b64_tr_b16 a[242:243], v11 offset:38448
		ds_read_b64_tr_b16 a[244:245], v11 offset:34224
		ds_read_b64_tr_b16 a[246:247], v11 offset:38576
		s_cmp_lt_i32 s1, s18
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_2
		v_accvgpr_read_b32 v11, a18
		v_add_u32_e32 v11, s1, v11
		v_cmp_lt_i32_e64 s[50:51], v11, s20
		v_accvgpr_read_b32 v11, a19
		v_add_u32_e32 v11, s1, v11
		v_cmp_lt_i32_e64 s[52:53], v11, s20
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s25, s15, s41
		s_lshl_b32 s25, s25, 1
		s_add_i32 s38, s23, s25
		v_add3_u32 v11, s38, v17, v19
		v_add3_u32 v11, v11, v21, v10
		v_cndmask_b32_e64 v11, v22, v11, s[50:51]
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
		v_accvgpr_read_b32 v12, a56
		v_add_u32_e32 v12, s1, v12
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v12, s20
		s_add_i32 s38, s45, s25
		v_add3_u32 v11, s38, v17, v19
		v_add3_u32 v11, v11, v21, v10
		v_cndmask_b32_e64 v11, v22, v11, s[54:55]
		s_add_u32 s54, s56, 0x1040
		s_addc_u32 s55, s57, 0
		s_add_u32 s54, s54, s58
		s_addc_u32 s55, s55, s59
		s_add_u32 s60, s54, 0
		s_addc_u32 s61, s55, 0
		s_mov_b32 m0, s60
		v_accvgpr_read_b32 v12, a57
		v_add_u32_e32 v12, s1, v12
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v12, s20
		s_add_i32 s38, s46, s25
		v_add3_u32 v11, s38, v17, v19
		v_add3_u32 v11, v11, v21, v10
		v_cndmask_b32_e64 v11, v22, v11, s[54:55]
		s_add_u32 s54, s56, 0x2080
		s_addc_u32 s55, s57, 0
		s_add_u32 s54, s54, s58
		s_addc_u32 s55, s55, s59
		s_add_u32 s60, s54, 0
		s_addc_u32 s61, s55, 0
		s_mov_b32 m0, s60
		v_accvgpr_read_b32 v12, a58
		v_add_u32_e32 v12, s1, v12
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v12, s20
		s_add_i32 s25, s36, s25
		v_add3_u32 v11, s25, v17, v19
		v_add3_u32 v11, v11, v21, v10
		v_cndmask_b32_e64 v11, v22, v11, s[54:55]
		s_add_u32 s54, s56, 0x30c0
		s_addc_u32 s55, s57, 0
		s_add_u32 s54, s54, s58
		s_addc_u32 s55, s55, s59
		s_add_u32 s56, s54, 0
		s_addc_u32 s57, s55, 0
		s_mov_b32 m0, s56
		v_accvgpr_read_b32 v12, a59
		v_add_u32_e32 v12, s1, v12
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		s_mul_i32 s25, s17, s41
		s_lshl_b32 s25, s25, 1
		s_add_i32 s38, s37, s25
		v_add3_u32 v11, s38, v1, v14
		v_add3_u32 v11, v11, v23, v10
		v_cndmask_b32_e64 v11, v22, v11, s[52:53]
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
		v_accvgpr_read_b32 v13, a60
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[48:49], v12, s20
		s_add_i32 s38, s39, s25
		v_add3_u32 v11, s38, v1, v14
		v_add3_u32 v11, v11, v23, v10
		v_cndmask_b32_e64 v11, v22, v11, s[48:49]
		s_add_u32 s48, s54, 0x92f0
		s_addc_u32 s49, s55, 0
		s_add_u32 s48, s48, s56
		s_addc_u32 s49, s49, s57
		s_add_u32 s50, s48, 0
		s_addc_u32 s51, s49, 0
		s_mov_b32 m0, s50
		v_accvgpr_read_b32 v12, a61
		v_add_u32_e32 v12, s1, v12
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[48:49], v13, s20
		s_add_i32 s38, s47, s25
		v_add3_u32 v11, s38, v1, v14
		v_add3_u32 v11, v11, v23, v10
		s_add_u32 s50, s54, 0xa3f0
		s_addc_u32 s51, s55, 0
		s_add_u32 s50, s50, s56
		s_addc_u32 s51, s51, s57
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		v_cndmask_b32_e64 v11, v22, v11, s[48:49]
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		s_add_i32 s25, s24, s25
		v_add3_u32 v11, s25, v1, v14
		v_cmp_lt_i32_e64 vcc, v12, s20
		v_add3_u32 v11, v11, v23, v10
		s_add_u32 s48, s54, 0xb4f0
		s_addc_u32 s49, s55, 0
		v_cndmask_b32_e32 v11, v22, v11, vcc
		s_add_u32 s48, s48, s56
		s_addc_u32 s49, s49, s57
		s_add_u32 s50, s48, 0
		s_addc_u32 s51, s49, 0
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
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
		v_mfma_f32_32x32x16_bf16 v[96:111], a[132:135], a[44:47], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[148:151], a[44:47], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[164:167], a[44:47], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[136:139], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[152:155], a[32:35], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[168:171], a[32:35], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[180:183], a[48:51], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[136:139], a[48:51], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[152:155], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[168:171], a[48:51], v[208:223]
		v_add_u32_e32 v11, s41, v6
		v_accvgpr_read_b32 v12, a15
		v_add_u32_e32 v12, s41, v12
		v_accvgpr_read_b32 v13, a16
		v_add_u32_e32 v13, s41, v13
		v_accvgpr_read_b32 v15, a64
		v_add_u32_e32 v15, s41, v15
		v_accvgpr_read_b32 v16, a67
		v_add_u32_e32 v16, s41, v16
		v_accvgpr_read_b32 v18, a68
		v_add_u32_e32 v18, s41, v18
		v_accvgpr_read_b32 v20, a71
		v_add_u32_e32 v20, s41, v20
		v_accvgpr_read_b32 v26, a72
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_read_b32 v27, a75
		v_add_u32_e32 v27, s41, v27
		v_accvgpr_read_b32 v28, a76
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_read_b32 v29, a79
		v_add_u32_e32 v29, s41, v29
		v_accvgpr_read_b32 v30, a80
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_read_b32 v31, a83
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a125, v31
		v_accvgpr_read_b32 v31, a84
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a126, v31
		v_accvgpr_read_b32 v31, a87
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a127, v31
		v_accvgpr_read_b32 v31, a88
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a128, v31
		v_accvgpr_read_b32 v31, a91
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a129, v31
		v_accvgpr_read_b32 v31, a92
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a130, v31
		v_accvgpr_read_b32 v31, a95
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a131, v31
		v_accvgpr_read_b32 v31, a96
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a132, v31
		v_accvgpr_read_b32 v31, a99
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a133, v31
		v_accvgpr_read_b32 v31, a100
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a134, v31
		v_accvgpr_read_b32 v31, a103
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a135, v31
		v_accvgpr_read_b32 v31, a104
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a136, v31
		v_accvgpr_read_b32 v31, a107
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a137, v31
		v_accvgpr_read_b32 v31, a108
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a138, v31
		v_accvgpr_read_b32 v31, a111
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a139, v31
		v_accvgpr_read_b32 v31, a112
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a140, v31
		v_accvgpr_read_b32 v31, a115
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a141, v31
		v_accvgpr_read_b32 v31, a116
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a142, v31
		v_accvgpr_read_b32 v31, a119
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a143, v31
		v_accvgpr_read_b32 v31, a120
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a144, v31
		v_accvgpr_read_b32 v31, a123
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a145, v31
		v_accvgpr_read_b32 v31, a124
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a146, v31
		v_cmp_ge_i32_e64 s[48:49], v4, v11
		v_cmp_ge_i32_e64 s[50:51], v4, v12
		v_cmp_ge_i32_e64 s[52:53], v4, v13
		v_cmp_ge_i32_e64 vcc, v4, v15
		v_accvgpr_read_b32 v31, a65
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_read_b32 v224, a66
		v_add_u32_e32 v224, s41, v224
		v_cndmask_b32_e32 v227, v9, v115, vcc
		v_cmp_ge_i32_e64 s[54:55], v4, v31
		v_cmp_ge_i32_e64 s[56:57], v4, v224
		v_cmp_ge_i32_e64 s[58:59], v4, v16
		v_cmp_ge_i32_e64 vcc, v4, v18
		v_accvgpr_read_b32 v115, a69
		v_add_u32_e32 v115, s41, v115
		v_accvgpr_read_b32 v225, a70
		v_add_u32_e32 v225, s41, v225
		v_cndmask_b32_e32 v229, v9, v119, vcc
		v_cmp_ge_i32_e64 s[60:61], v4, v115
		v_cmp_ge_i32_e64 s[62:63], v4, v225
		v_cmp_ge_i32_e64 s[64:65], v4, v20
		v_cmp_ge_i32_e64 vcc, v4, v26
		v_accvgpr_read_b32 v119, a73
		v_add_u32_e32 v119, s41, v119
		v_accvgpr_read_b32 v226, a74
		v_add_u32_e32 v230, s41, v226
		v_cndmask_b32_e32 v233, v9, v123, vcc
		v_cmp_ge_i32_e64 s[66:67], v4, v119
		v_cmp_ge_i32_e64 s[68:69], v4, v230
		v_cmp_ge_i32_e64 s[70:71], v4, v27
		v_cmp_ge_i32_e64 vcc, v4, v28
		v_accvgpr_read_b32 v123, a77
		v_add_u32_e32 v123, s41, v123
		v_accvgpr_read_b32 v226, a78
		v_add_u32_e32 v231, s41, v226
		v_cndmask_b32_e32 v235, v9, v127, vcc
		v_cmp_ge_i32_e64 s[72:73], v4, v123
		v_cmp_ge_i32_e64 s[74:75], v4, v231
		v_cmp_ge_i32_e64 s[76:77], v4, v29
		v_cmp_ge_i32_e64 vcc, v4, v30
		v_accvgpr_read_b32 v127, a81
		v_add_u32_e32 v127, s41, v127
		v_accvgpr_read_b32 v226, a82
		v_add_u32_e32 v226, s41, v226
		v_accvgpr_write_b32 a147, v226
		v_cndmask_b32_e32 v237, v9, v131, vcc
		v_cmp_ge_i32_e64 s[78:79], v4, v127
		v_accvgpr_read_b32 v131, a147
		v_cmp_ge_i32_e64 s[80:81], v4, v131
		v_accvgpr_read_b32 v131, a125
		v_cmp_ge_i32_e64 s[82:83], v4, v131
		v_accvgpr_read_b32 v131, a126
		v_cmp_ge_i32_e64 vcc, v4, v131
		v_accvgpr_read_b32 v131, a85
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a148, v131
		v_accvgpr_read_b32 v131, a86
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a149, v131
		v_cndmask_b32_e32 v239, v9, v135, vcc
		v_accvgpr_read_b32 v131, a148
		v_cmp_ge_i32_e64 s[84:85], v4, v131
		v_accvgpr_read_b32 v131, a128
		v_cmp_ge_i32_e64 vcc, v4, v131
		v_accvgpr_read_b32 v131, a89
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a150, v131
		v_accvgpr_read_b32 v131, a90
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a151, v131
		v_cndmask_b32_e32 v241, v9, v139, vcc
		v_accvgpr_read_b32 v131, a130
		v_cmp_ge_i32_e64 vcc, v4, v131
		v_accvgpr_read_b32 v131, a93
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a152, v131
		v_accvgpr_read_b32 v131, a94
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a153, v131
		v_cndmask_b32_e32 v243, v9, v143, vcc
		v_accvgpr_read_b32 v131, a132
		v_cmp_ge_i32_e64 vcc, v4, v131
		v_accvgpr_read_b32 v131, a97
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a154, v131
		v_accvgpr_read_b32 v131, a98
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a155, v131
		v_cndmask_b32_e32 v245, v9, v147, vcc
		v_accvgpr_read_b32 v131, a134
		v_cmp_ge_i32_e64 vcc, v4, v131
		v_accvgpr_read_b32 v131, a101
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a156, v131
		v_accvgpr_read_b32 v131, a102
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a157, v131
		v_cndmask_b32_e32 v247, v9, v151, vcc
		v_accvgpr_read_b32 v131, a136
		v_cmp_ge_i32_e64 vcc, v4, v131
		v_accvgpr_read_b32 v131, a105
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a158, v131
		v_accvgpr_read_b32 v131, a106
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a159, v131
		v_cndmask_b32_e32 v249, v9, v155, vcc
		v_accvgpr_read_b32 v131, a138
		v_cmp_ge_i32_e64 vcc, v4, v131
		v_accvgpr_read_b32 v131, a149
		v_cmp_ge_i32_e64 s[86:87], v4, v131
		v_cndmask_b32_e64 v250, v9, v112, s[48:49]
		v_accvgpr_read_b32 v112, a127
		v_cmp_ge_i32_e64 s[48:49], v4, v112
		v_accvgpr_read_b32 v112, a150
		v_cmp_ge_i32_e64 s[88:89], v4, v112
		s_nop 1
		v_mov_b32_e32 v252, s88
		v_mov_b32_e32 v253, s89
		v_accvgpr_write_b32 a160, v252
		v_accvgpr_write_b32 a161, v253
		v_accvgpr_read_b32 v112, a151
		v_cmp_ge_i32_e64 s[88:89], v4, v112
		s_nop 1
		v_mov_b32_e32 v252, s88
		v_mov_b32_e32 v253, s89
		v_accvgpr_write_b32 a162, v252
		v_accvgpr_write_b32 a163, v253
		v_accvgpr_read_b32 v112, a129
		v_cmp_ge_i32_e64 s[88:89], v4, v112
		s_nop 1
		v_mov_b32_e32 v252, s88
		v_mov_b32_e32 v253, s89
		v_accvgpr_write_b32 a164, v252
		v_accvgpr_write_b32 a165, v253
		v_accvgpr_read_b32 v112, a152
		v_cmp_ge_i32_e64 s[88:89], v4, v112
		s_nop 1
		v_mov_b32_e32 v252, s88
		v_mov_b32_e32 v253, s89
		v_accvgpr_write_b32 a166, v252
		v_accvgpr_write_b32 a167, v253
		v_accvgpr_read_b32 v112, a153
		v_cmp_ge_i32_e64 s[88:89], v4, v112
		s_nop 1
		v_mov_b32_e32 v252, s88
		v_mov_b32_e32 v253, s89
		v_accvgpr_write_b32 a168, v252
		v_accvgpr_write_b32 a169, v253
		v_accvgpr_read_b32 v112, a131
		v_cmp_ge_i32_e64 s[88:89], v4, v112
		s_nop 1
		v_mov_b32_e32 v252, s88
		v_mov_b32_e32 v253, s89
		v_accvgpr_write_b32 a170, v252
		v_accvgpr_write_b32 a171, v253
		v_accvgpr_read_b32 v112, a154
		v_cmp_ge_i32_e64 s[88:89], v4, v112
		s_nop 1
		v_mov_b32_e32 v252, s88
		v_mov_b32_e32 v253, s89
		v_accvgpr_write_b32 a172, v252
		v_accvgpr_write_b32 a173, v253
		v_accvgpr_read_b32 v112, a155
		v_cmp_ge_i32_e64 s[88:89], v4, v112
		s_nop 1
		v_mov_b32_e32 v252, s88
		v_mov_b32_e32 v253, s89
		v_accvgpr_write_b32 a174, v252
		v_accvgpr_write_b32 a175, v253
		v_accvgpr_read_b32 v112, a133
		v_cmp_ge_i32_e64 s[88:89], v4, v112
		s_nop 1
		v_mov_b32_e32 v252, s88
		v_mov_b32_e32 v253, s89
		v_accvgpr_write_b32 a176, v252
		v_accvgpr_write_b32 a177, v253
		v_accvgpr_read_b32 v112, a156
		v_cmp_ge_i32_e64 s[88:89], v4, v112
		s_nop 1
		v_mov_b32_e32 v252, s88
		v_mov_b32_e32 v253, s89
		v_accvgpr_write_b32 a178, v252
		v_accvgpr_write_b32 a179, v253
		v_accvgpr_read_b32 v112, a157
		v_cmp_ge_i32_e64 s[88:89], v4, v112
		s_nop 1
		v_mov_b32_e32 v252, s88
		v_mov_b32_e32 v253, s89
		v_accvgpr_write_b32 a180, v252
		v_accvgpr_write_b32 a181, v253
		v_accvgpr_read_b32 v112, a135
		v_cmp_ge_i32_e64 s[88:89], v4, v112
		v_accvgpr_read_b32 v112, a158
		v_cmp_ge_i32_e64 s[90:91], v4, v112
		v_accvgpr_read_b32 v112, a159
		v_cmp_ge_i32_e64 s[92:93], v4, v112
		v_accvgpr_read_b32 v112, a137
		v_cmp_ge_i32_e64 s[94:95], v4, v112
		v_cndmask_b32_e32 v253, v9, v159, vcc
		v_cndmask_b32_e64 v255, v9, v157, s[92:93]
		v_cndmask_b32_e64 v252, v9, v158, s[94:95]
		v_accvgpr_read_b32 v112, a109
		v_add_u32_e32 v112, s41, v112
		v_accvgpr_read_b32 v131, a110
		v_add_u32_e32 v131, s41, v131
		v_cmp_ge_i32_e64 s[92:93], v4, v112
		v_cmp_ge_i32_e64 s[94:95], v4, v131
		v_accvgpr_read_b32 v135, a139
		v_cmp_ge_i32_e64 s[96:97], v4, v135
		v_cndmask_b32_e64 v158, v9, v160, s[92:93]
		v_cndmask_b32_e64 v159, v9, v161, s[94:95]
		v_cndmask_b32_e64 v160, v9, v162, s[96:97]
		v_accvgpr_read_b32 v135, a140
		v_cmp_ge_i32_e64 vcc, v4, v135
		v_accvgpr_read_b32 v135, a113
		v_add_u32_e32 v135, s41, v135
		v_accvgpr_read_b32 v139, a114
		v_add_u32_e32 v139, s41, v139
		v_cndmask_b32_e32 v161, v9, v163, vcc
		v_cmp_ge_i32_e64 s[92:93], v4, v135
		v_cmp_ge_i32_e64 s[94:95], v4, v139
		v_accvgpr_read_b32 v143, a141
		v_cmp_ge_i32_e64 s[96:97], v4, v143
		v_cndmask_b32_e64 v162, v9, v164, s[92:93]
		v_cndmask_b32_e64 v163, v9, v165, s[94:95]
		v_cndmask_b32_e64 v164, v9, v166, s[96:97]
		v_accvgpr_read_b32 v143, a142
		v_cmp_ge_i32_e64 vcc, v4, v143
		v_accvgpr_read_b32 v143, a117
		v_add_u32_e32 v143, s41, v143
		v_accvgpr_read_b32 v147, a118
		v_add_u32_e32 v147, s41, v147
		v_cndmask_b32_e32 v165, v9, v167, vcc
		v_cmp_ge_i32_e64 s[92:93], v4, v143
		v_cmp_ge_i32_e64 s[94:95], v4, v147
		v_accvgpr_read_b32 v151, a143
		v_cmp_ge_i32_e64 s[96:97], v4, v151
		v_cndmask_b32_e64 v166, v9, v168, s[92:93]
		v_cndmask_b32_e64 v167, v9, v169, s[94:95]
		v_cndmask_b32_e64 v168, v9, v170, s[96:97]
		v_accvgpr_read_b32 v151, a144
		v_cmp_ge_i32_e64 vcc, v4, v151
		v_accvgpr_read_b32 v151, a121
		v_add_u32_e32 v151, s41, v151
		v_accvgpr_read_b32 v155, a122
		v_add_u32_e32 v155, s41, v155
		v_cndmask_b32_e32 v169, v9, v171, vcc
		v_cmp_ge_i32_e64 s[92:93], v4, v151
		v_cmp_ge_i32_e64 s[94:95], v4, v155
		v_accvgpr_read_b32 v157, a145
		v_cmp_ge_i32_e64 s[96:97], v4, v157
		v_cndmask_b32_e64 v170, v9, v172, s[92:93]
		v_cndmask_b32_e64 v171, v9, v173, s[94:95]
		v_cndmask_b32_e64 v172, v9, v174, s[96:97]
		v_cndmask_b32_e64 v251, v9, v113, s[50:51]
		v_accvgpr_read_b32 v113, a146
		v_cmp_ge_i32_e64 vcc, v4, v113
		v_max3_f32 v113, v158, v159, v160
		v_max3_f32 v157, v162, v163, v164
		v_cndmask_b32_e32 v173, v9, v175, vcc
		v_cmp_ge_i32_e64 s[50:51], v7, v11
		v_cmp_ge_i32_e64 s[92:93], v7, v12
		v_cmp_ge_i32_e64 s[94:95], v7, v13
		v_max3_f32 v11, v166, v167, v168
		v_accvgpr_write_b32 a182, v11
		v_max3_f32 v11, v170, v171, v172
		v_cndmask_b32_e64 v12, v9, v98, s[94:95]
		v_cmp_ge_i32_e64 vcc, v7, v15
		v_cndmask_b32_e64 v226, v9, v114, s[52:53]
		v_cndmask_b32_e64 v174, v9, v116, s[54:55]
		v_cndmask_b32_e32 v13, v9, v99, vcc
		v_cmp_ge_i32_e64 s[52:53], v7, v31
		v_cmp_ge_i32_e64 s[54:55], v7, v224
		v_cmp_ge_i32_e64 s[94:95], v7, v16
		v_cndmask_b32_e64 v98, v9, v100, s[52:53]
		v_cndmask_b32_e64 v99, v9, v101, s[54:55]
		v_cndmask_b32_e64 v100, v9, v102, s[94:95]
		v_cmp_ge_i32_e64 vcc, v7, v18
		v_cndmask_b32_e64 v175, v9, v117, s[56:57]
		v_cndmask_b32_e64 v228, v9, v118, s[58:59]
		v_cndmask_b32_e64 v116, v9, v120, s[60:61]
		v_cndmask_b32_e32 v101, v9, v103, vcc
		v_cmp_ge_i32_e64 s[52:53], v7, v115
		v_cmp_ge_i32_e64 s[54:55], v7, v225
		v_cmp_ge_i32_e64 s[56:57], v7, v20
		v_cndmask_b32_e64 v102, v9, v104, s[52:53]
		v_cndmask_b32_e64 v103, v9, v105, s[54:55]
		v_cndmask_b32_e64 v104, v9, v106, s[56:57]
		v_cmp_ge_i32_e64 vcc, v7, v26
		v_cndmask_b32_e64 v117, v9, v121, s[62:63]
		v_max3_f32 v15, v250, v251, v226
		v_cndmask_b32_e32 v105, v9, v107, vcc
		v_cmp_ge_i32_e64 s[52:53], v7, v119
		v_cmp_ge_i32_e64 s[54:55], v7, v230
		v_cmp_ge_i32_e64 s[56:57], v7, v27
		v_cndmask_b32_e64 v26, v9, v108, s[52:53]
		v_cndmask_b32_e64 v27, v9, v109, s[54:55]
		v_cndmask_b32_e64 v106, v9, v110, s[56:57]
		v_cmp_ge_i32_e64 vcc, v7, v28
		v_cndmask_b32_e64 v232, v9, v122, s[64:65]
		v_cndmask_b32_e64 v108, v9, v124, s[66:67]
		v_cndmask_b32_e32 v107, v9, v111, vcc
		v_cmp_ge_i32_e64 s[52:53], v7, v123
		v_cmp_ge_i32_e64 s[54:55], v7, v231
		v_cmp_ge_i32_e64 s[56:57], v7, v29
		v_cndmask_b32_e64 v28, v9, v192, s[52:53]
		v_cndmask_b32_e64 v29, v9, v193, s[54:55]
		v_cndmask_b32_e64 v110, v9, v194, s[56:57]
		v_cmp_ge_i32_e64 vcc, v7, v30
		v_cndmask_b32_e64 v109, v9, v125, s[68:69]
		v_cndmask_b32_e64 v234, v9, v126, s[70:71]
		v_cndmask_b32_e64 v30, v9, v128, s[72:73]
		v_cndmask_b32_e32 v111, v9, v195, vcc
		v_cmp_ge_i32_e64 s[52:53], v7, v127
		v_accvgpr_read_b32 v16, a147
		v_cmp_ge_i32_e64 s[54:55], v7, v16
		v_accvgpr_read_b32 v16, a125
		v_cmp_ge_i32_e64 s[56:57], v7, v16
		v_cndmask_b32_e64 v114, v9, v196, s[52:53]
		v_cndmask_b32_e64 v115, v9, v197, s[54:55]
		v_cndmask_b32_e64 v118, v9, v198, s[56:57]
		v_accvgpr_read_b32 v16, a126
		v_cmp_ge_i32_e64 vcc, v7, v16
		v_cndmask_b32_e64 v31, v9, v129, s[74:75]
		v_max3_f32 v16, v174, v175, v228
		v_cndmask_b32_e32 v119, v9, v199, vcc
		v_accvgpr_read_b32 v18, a148
		v_cmp_ge_i32_e64 s[52:53], v7, v18
		v_accvgpr_read_b32 v18, a149
		v_cmp_ge_i32_e64 s[54:55], v7, v18
		v_accvgpr_read_b32 v18, a127
		v_cmp_ge_i32_e64 s[56:57], v7, v18
		v_cndmask_b32_e64 v120, v9, v200, s[52:53]
		v_cndmask_b32_e64 v121, v9, v201, s[54:55]
		v_cndmask_b32_e64 v122, v9, v202, s[56:57]
		v_accvgpr_read_b32 v18, a128
		v_cmp_ge_i32_e64 vcc, v7, v18
		v_cndmask_b32_e64 v236, v9, v130, s[76:77]
		v_cndmask_b32_e64 v124, v9, v132, s[78:79]
		v_cndmask_b32_e32 v123, v9, v203, vcc
		v_accvgpr_read_b32 v18, a150
		v_cmp_ge_i32_e64 s[52:53], v7, v18
		v_accvgpr_read_b32 v18, a151
		v_cmp_ge_i32_e64 s[54:55], v7, v18
		v_accvgpr_read_b32 v18, a129
		v_cmp_ge_i32_e64 s[56:57], v7, v18
		v_cndmask_b32_e64 v126, v9, v204, s[52:53]
		v_cndmask_b32_e64 v127, v9, v205, s[54:55]
		v_cndmask_b32_e64 v128, v9, v206, s[56:57]
		v_accvgpr_read_b32 v18, a130
		v_cmp_ge_i32_e64 vcc, v7, v18
		v_cndmask_b32_e64 v125, v9, v133, s[80:81]
		v_cndmask_b32_e64 v238, v9, v134, s[82:83]
		v_cndmask_b32_e32 v129, v9, v207, vcc
		v_accvgpr_read_b32 v18, a152
		v_cmp_ge_i32_e64 s[52:53], v7, v18
		v_accvgpr_read_b32 v18, a132
		v_cmp_ge_i32_e64 vcc, v7, v18
		v_cndmask_b32_e64 v132, v9, v136, s[84:85]
		v_accvgpr_read_b32 v18, a153
		v_cmp_ge_i32_e64 s[54:55], v7, v18
		v_accvgpr_read_b32 v18, a131
		v_cmp_ge_i32_e64 s[56:57], v7, v18
		v_cndmask_b32_e64 v192, v9, v208, s[52:53]
		v_cndmask_b32_e64 v193, v9, v209, s[54:55]
		v_cndmask_b32_e64 v194, v9, v210, s[56:57]
		v_cndmask_b32_e64 v133, v9, v137, s[86:87]
		v_cndmask_b32_e32 v195, v9, v211, vcc
		v_accvgpr_read_b32 v18, a154
		v_cmp_ge_i32_e64 s[52:53], v7, v18
		v_accvgpr_read_b32 v18, a155
		v_cmp_ge_i32_e64 s[54:55], v7, v18
		v_accvgpr_read_b32 v18, a133
		v_cmp_ge_i32_e64 s[56:57], v7, v18
		v_cndmask_b32_e64 v136, v9, v212, s[52:53]
		v_cndmask_b32_e64 v137, v9, v213, s[54:55]
		v_cndmask_b32_e64 v196, v9, v214, s[56:57]
		v_accvgpr_read_b32 v18, a134
		v_cmp_ge_i32_e64 vcc, v7, v18
		v_cndmask_b32_e64 v240, v9, v138, s[48:49]
		v_accvgpr_read_b32 v18, a160
		s_nop 0
		v_readfirstlane_b32 s48, v18
		v_accvgpr_read_b32 v18, a161
		s_nop 0
		v_readfirstlane_b32 s49, v18
		s_nop 1
		v_cndmask_b32_e64 v198, v9, v140, s[48:49]
		v_cndmask_b32_e32 v197, v9, v215, vcc
		v_accvgpr_read_b32 v18, a156
		v_cmp_ge_i32_e64 s[48:49], v7, v18
		v_accvgpr_read_b32 v18, a157
		v_cmp_ge_i32_e64 s[52:53], v7, v18
		v_accvgpr_read_b32 v18, a135
		v_cmp_ge_i32_e64 s[54:55], v7, v18
		v_cndmask_b32_e64 v200, v9, v216, s[48:49]
		v_cndmask_b32_e64 v201, v9, v217, s[52:53]
		v_cndmask_b32_e64 v202, v9, v218, s[54:55]
		v_accvgpr_read_b32 v18, a136
		v_cmp_ge_i32_e64 vcc, v7, v18
		v_accvgpr_read_b32 v18, a162
		s_nop 0
		v_readfirstlane_b32 s48, v18
		v_accvgpr_read_b32 v18, a163
		s_nop 0
		v_readfirstlane_b32 s49, v18
		s_nop 1
		v_cndmask_b32_e64 v199, v9, v141, s[48:49]
		v_accvgpr_read_b32 v18, a164
		s_nop 0
		v_readfirstlane_b32 s48, v18
		v_accvgpr_read_b32 v18, a165
		s_nop 0
		v_readfirstlane_b32 s49, v18
		s_nop 1
		v_cndmask_b32_e64 v242, v9, v142, s[48:49]
		v_cndmask_b32_e32 v203, v9, v219, vcc
		v_accvgpr_read_b32 v18, a158
		v_cmp_ge_i32_e64 s[48:49], v7, v18
		v_accvgpr_read_b32 v18, a159
		v_cmp_ge_i32_e64 s[52:53], v7, v18
		v_accvgpr_read_b32 v18, a137
		v_cmp_ge_i32_e64 s[54:55], v7, v18
		v_cndmask_b32_e64 v140, v9, v220, s[48:49]
		v_cndmask_b32_e64 v141, v9, v221, s[52:53]
		v_cndmask_b32_e64 v204, v9, v222, s[54:55]
		v_accvgpr_read_b32 v18, a138
		v_cmp_ge_i32_e64 vcc, v7, v18
		v_accvgpr_read_b32 v18, a166
		s_nop 0
		v_readfirstlane_b32 s48, v18
		v_accvgpr_read_b32 v18, a167
		s_nop 0
		v_readfirstlane_b32 s49, v18
		s_nop 1
		v_cndmask_b32_e64 v206, v9, v144, s[48:49]
		v_accvgpr_read_b32 v18, a168
		s_nop 0
		v_readfirstlane_b32 s48, v18
		v_accvgpr_read_b32 v18, a169
		s_nop 0
		v_readfirstlane_b32 s49, v18
		s_nop 1
		v_cndmask_b32_e64 v207, v9, v145, s[48:49]
		v_cndmask_b32_e32 v205, v9, v223, vcc
		v_cmp_ge_i32_e64 s[48:49], v7, v112
		v_cmp_ge_i32_e64 s[52:53], v7, v131
		v_accvgpr_read_b32 v18, a139
		v_cmp_ge_i32_e64 s[54:55], v7, v18
		v_cndmask_b32_e64 v130, v9, v176, s[48:49]
		v_cndmask_b32_e64 v131, v9, v177, s[52:53]
		v_cndmask_b32_e64 v144, v9, v178, s[54:55]
		v_accvgpr_read_b32 v18, a140
		v_cmp_ge_i32_e64 vcc, v7, v18
		v_accvgpr_read_b32 v18, a170
		s_nop 0
		v_readfirstlane_b32 s48, v18
		v_accvgpr_read_b32 v18, a171
		s_nop 0
		v_readfirstlane_b32 s49, v18
		s_nop 1
		v_cndmask_b32_e64 v244, v9, v146, s[48:49]
		v_accvgpr_read_b32 v18, a172
		s_nop 0
		v_readfirstlane_b32 s48, v18
		v_accvgpr_read_b32 v18, a173
		s_nop 0
		v_readfirstlane_b32 s49, v18
		s_nop 1
		v_cndmask_b32_e64 v176, v9, v148, s[48:49]
		v_cndmask_b32_e32 v145, v9, v179, vcc
		v_cmp_ge_i32_e64 s[48:49], v7, v135
		v_cmp_ge_i32_e64 s[52:53], v7, v139
		v_accvgpr_read_b32 v18, a141
		v_cmp_ge_i32_e64 s[54:55], v7, v18
		v_cndmask_b32_e64 v134, v9, v180, s[48:49]
		v_cndmask_b32_e64 v135, v9, v181, s[52:53]
		v_cndmask_b32_e64 v138, v9, v182, s[54:55]
		v_accvgpr_read_b32 v18, a142
		v_cmp_ge_i32_e64 vcc, v7, v18
		v_accvgpr_read_b32 v18, a174
		s_nop 0
		v_readfirstlane_b32 s48, v18
		v_accvgpr_read_b32 v18, a175
		s_nop 0
		v_readfirstlane_b32 s49, v18
		s_nop 1
		v_cndmask_b32_e64 v177, v9, v149, s[48:49]
		v_accvgpr_read_b32 v18, a176
		s_nop 0
		v_readfirstlane_b32 s48, v18
		v_accvgpr_read_b32 v18, a177
		s_nop 0
		v_readfirstlane_b32 s49, v18
		s_nop 1
		v_cndmask_b32_e64 v246, v9, v150, s[48:49]
		v_cndmask_b32_e32 v139, v9, v183, vcc
		v_cmp_ge_i32_e64 s[48:49], v7, v143
		v_cmp_ge_i32_e64 s[52:53], v7, v147
		v_accvgpr_read_b32 v18, a143
		v_cmp_ge_i32_e64 s[54:55], v7, v18
		v_cndmask_b32_e64 v142, v9, v184, s[48:49]
		v_cndmask_b32_e64 v143, v9, v185, s[52:53]
		v_cndmask_b32_e64 v146, v9, v186, s[54:55]
		v_accvgpr_read_b32 v18, a144
		v_cmp_ge_i32_e64 vcc, v7, v18
		v_accvgpr_read_b32 v18, a178
		s_nop 0
		v_readfirstlane_b32 s48, v18
		v_accvgpr_read_b32 v18, a179
		s_nop 0
		v_readfirstlane_b32 s49, v18
		s_nop 1
		v_cndmask_b32_e64 v148, v9, v152, s[48:49]
		v_accvgpr_read_b32 v18, a180
		s_nop 0
		v_readfirstlane_b32 s48, v18
		v_accvgpr_read_b32 v18, a181
		s_nop 0
		v_readfirstlane_b32 s49, v18
		s_nop 1
		v_cndmask_b32_e64 v149, v9, v153, s[48:49]
		v_cndmask_b32_e32 v147, v9, v187, vcc
		v_cmp_ge_i32_e64 s[48:49], v7, v151
		v_cmp_ge_i32_e64 s[52:53], v7, v155
		v_accvgpr_read_b32 v18, a145
		v_cmp_ge_i32_e64 s[54:55], v7, v18
		v_cndmask_b32_e64 v150, v9, v188, s[48:49]
		v_cndmask_b32_e64 v151, v9, v189, s[52:53]
		v_cndmask_b32_e64 v152, v9, v190, s[54:55]
		v_accvgpr_read_b32 v18, a146
		v_cmp_ge_i32_e64 vcc, v7, v18
		v_cndmask_b32_e64 v248, v9, v154, s[88:89]
		v_cndmask_b32_e64 v254, v9, v156, s[90:91]
		v_cndmask_b32_e32 v153, v9, v191, vcc
		v_max3_f32 v18, v116, v117, v232
		v_max3_f32 v20, v108, v109, v234
		v_max3_f32 v112, v30, v31, v236
		v_max3_f32 v154, v124, v125, v238
		v_max3_f32 v155, v132, v133, v240
		v_max3_f32 v156, v198, v199, v242
		v_max3_f32 v178, v206, v207, v244
		v_max3_f32 v179, v176, v177, v246
		v_max3_f32 v180, v148, v149, v248
		v_max3_f32 v181, v254, v255, v252
		v_max3_f32 v15, v15, v227, v16
		v_max3_f32 v16, v18, v233, v20
		v_max3_f32 v18, v112, v237, v154
		v_max3_f32 v20, v155, v241, v156
		v_max3_f32 v112, v178, v245, v179
		v_max3_f32 v154, v180, v249, v181
		v_max3_f32 v113, v113, v161, v157
		v_accvgpr_read_b32 v155, a182
		v_max3_f32 v11, v155, v169, v11
		v_max3_f32 v15, v15, v229, v16
		v_max3_f32 v16, v18, v239, v20
		v_max3_f32 v18, v112, v247, v154
		v_max3_f32 v11, v113, v165, v11
		v_max3_f32 v15, v15, v235, v16
		v_max3_f32 v11, v18, v253, v11
		v_max3_f32 v11, v15, v243, v11
		v_max_f32_e32 v112, v11, v173
		v_mov_b32_e32 v113, v112
		v_cndmask_b32_e64 v154, v9, v96, s[50:51]
		v_cndmask_b32_e64 v155, v9, v97, s[92:93]
		v_permlane32_swap_b32_e32 v112, v113
		v_max3_f32 v11, v154, v155, v12
		v_max3_f32 v15, v98, v99, v100
		v_max3_f32 v16, v102, v103, v104
		v_max3_f32 v18, v26, v27, v106
		v_max3_f32 v20, v28, v29, v110
		v_max3_f32 v96, v114, v115, v118
		v_max3_f32 v97, v120, v121, v122
		v_max3_f32 v156, v126, v127, v128
		v_max3_f32 v157, v192, v193, v194
		v_max3_f32 v178, v136, v137, v196
		v_max3_f32 v179, v200, v201, v202
		v_max3_f32 v180, v140, v141, v204
		v_max3_f32 v181, v130, v131, v144
		v_max3_f32 v182, v134, v135, v138
		v_max3_f32 v183, v142, v143, v146
		v_max3_f32 v184, v150, v151, v152
		v_max3_f32 v11, v11, v13, v15
		v_max3_f32 v15, v16, v105, v18
		v_max3_f32 v16, v20, v111, v96
		v_max3_f32 v18, v97, v123, v156
		v_max3_f32 v20, v157, v195, v178
		v_max3_f32 v96, v179, v203, v180
		v_max3_f32 v97, v181, v145, v182
		v_max3_f32 v156, v183, v147, v184
		v_max3_f32 v11, v11, v101, v15
		v_max3_f32 v15, v16, v119, v18
		v_max3_f32 v16, v20, v197, v96
		v_max3_f32 v18, v97, v139, v156
		v_max3_f32 v11, v11, v107, v15
		v_max3_f32 v15, v16, v205, v18
		v_max3_f32 v11, v11, v129, v15
		v_max_f32_e32 v96, v11, v153
		v_mov_b32_e32 v97, v96
		v_max_f32_e32 v156, v112, v113
		v_mov_b32_e32 v112, v5
		v_permlane32_swap_b32_e32 v96, v97
		v_max_f32_e32 v157, v96, v97
		v_pk_mul_f32 v[96:97], v[156:157], v[2:3]
		v_max_f32_e32 v156, v5, v96
		v_max_f32_e32 v157, v8, v97
		v_pk_fma_f32 v[96:97], v[250:251], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[226:227], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[174:175], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[228:229], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[116:117], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[232:233], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[108:109], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[234:235], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[30:31], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[236:237], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[124:125], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[238:239], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[132:133], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[240:241], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[198:199], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[242:243], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[206:207], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[244:245], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[176:177], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[246:247], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[148:149], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[248:249], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[254:255], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[218:219], v[252:253], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[220:221], v[158:159], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[160:161], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[162:163], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[164:165], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[166:167], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[168:169], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[170:171], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[172:173], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[154:155], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[12:13], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[12:13], v[98:99], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[26:27], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[106:107], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[28:29], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[110:111], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[114:115], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[118:119], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[120:121], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[122:123], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[126:127], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[128:129], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[192:193], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[194:195], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[136:137], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[196:197], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[200:201], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[202:203], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[140:141], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[204:205], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[130:131], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[144:145], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[134:135], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[138:139], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[142:143], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[146:147], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[150:151], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v152, v96
		v_exp_f32_e32 v222, v97
		v_exp_f32_e32 v96, v178
		v_exp_f32_e32 v224, v179
		v_exp_f32_e32 v178, v180
		v_exp_f32_e32 v226, v181
		v_exp_f32_e32 v180, v174
		v_exp_f32_e32 v228, v175
		v_exp_f32_e32 v174, v182
		v_exp_f32_e32 v230, v183
		v_exp_f32_e32 v182, v116
		v_exp_f32_e32 v232, v117
		v_exp_f32_e32 v116, v184
		v_exp_f32_e32 v234, v185
		v_exp_f32_e32 v184, v108
		v_exp_f32_e32 v236, v109
		v_exp_f32_e32 v108, v186
		v_exp_f32_e32 v238, v187
		v_exp_f32_e32 v186, v30
		v_exp_f32_e32 v240, v31
		v_exp_f32_e32 v30, v188
		v_exp_f32_e32 v242, v189
		v_exp_f32_e32 v188, v124
		v_exp_f32_e32 v244, v125
		v_exp_f32_e32 v124, v190
		v_exp_f32_e32 v246, v191
		v_exp_f32_e32 v190, v132
		v_exp_f32_e32 v248, v133
		v_exp_f32_e32 v132, v208
		v_exp_f32_e32 v250, v209
		v_exp_f32_e32 v208, v198
		v_exp_f32_e32 v252, v199
		v_exp_f32_e32 v153, v210
		v_exp_f32_e32 v223, v211
		v_exp_f32_e32 v97, v206
		v_exp_f32_e32 v225, v207
		v_exp_f32_e32 v179, v212
		v_exp_f32_e32 v227, v213
		v_exp_f32_e32 v181, v176
		v_exp_f32_e32 v229, v177
		v_exp_f32_e32 v175, v214
		v_exp_f32_e32 v231, v215
		v_exp_f32_e32 v183, v148
		v_exp_f32_e32 v233, v149
		v_exp_f32_e32 v117, v216
		v_exp_f32_e32 v235, v217
		v_exp_f32_e32 v185, v218
		v_exp_f32_e32 v237, v219
		v_exp_f32_e32 v109, v220
		v_exp_f32_e32 v239, v221
		v_exp_f32_e32 v187, v158
		v_exp_f32_e32 v241, v159
		v_exp_f32_e32 v31, v160
		v_exp_f32_e32 v243, v161
		v_exp_f32_e32 v189, v162
		v_exp_f32_e32 v245, v163
		v_exp_f32_e32 v125, v164
		v_exp_f32_e32 v247, v165
		v_exp_f32_e32 v191, v166
		v_exp_f32_e32 v249, v167
		v_exp_f32_e32 v133, v168
		v_exp_f32_e32 v251, v169
		v_exp_f32_e32 v209, v170
		v_exp_f32_e32 v253, v171
		v_exp_f32_e32 v148, v154
		v_exp_f32_e32 v158, v155
		v_exp_f32_e32 v154, v12
		v_exp_f32_e32 v160, v13
		v_exp_f32_e32 v12, v98
		v_exp_f32_e32 v162, v99
		v_exp_f32_e32 v98, v100
		v_exp_f32_e32 v164, v101
		v_exp_f32_e32 v100, v102
		v_exp_f32_e32 v166, v103
		v_exp_f32_e32 v102, v104
		v_exp_f32_e32 v168, v105
		v_exp_f32_e32 v104, v26
		v_exp_f32_e32 v170, v27
		v_exp_f32_e32 v26, v106
		v_exp_f32_e32 v176, v107
		v_exp_f32_e32 v106, v28
		v_exp_f32_e32 v198, v29
		v_exp_f32_e32 v28, v110
		v_exp_f32_e32 v206, v111
		v_exp_f32_e32 v110, v114
		v_exp_f32_e32 v210, v115
		v_exp_f32_e32 v114, v118
		v_exp_f32_e32 v212, v119
		v_exp_f32_e32 v118, v120
		v_exp_f32_e32 v214, v121
		v_exp_f32_e32 v120, v122
		v_exp_f32_e32 v216, v123
		v_exp_f32_e32 v122, v126
		v_exp_f32_e32 v218, v127
		v_exp_f32_e32 v127, v128
		v_exp_f32_e32 v221, v129
		v_exp_f32_e32 v149, v192
		v_exp_f32_e32 v159, v193
		v_exp_f32_e32 v155, v194
		v_exp_f32_e32 v161, v195
		v_exp_f32_e32 v13, v136
		v_exp_f32_e32 v163, v137
		v_exp_f32_e32 v99, v196
		v_exp_f32_e32 v165, v197
		v_exp_f32_e32 v101, v200
		v_exp_f32_e32 v167, v201
		v_exp_f32_e32 v103, v202
		v_exp_f32_e32 v169, v203
		v_exp_f32_e32 v105, v140
		v_exp_f32_e32 v171, v141
		v_exp_f32_e32 v27, v204
		v_exp_f32_e32 v177, v205
		v_exp_f32_e32 v107, v130
		v_exp_f32_e32 v199, v131
		v_exp_f32_e32 v29, v144
		v_exp_f32_e32 v207, v145
		v_exp_f32_e32 v111, v134
		v_exp_f32_e32 v211, v135
		v_exp_f32_e32 v115, v138
		v_exp_f32_e32 v213, v139
		v_exp_f32_e32 v119, v142
		v_exp_f32_e32 v215, v143
		v_exp_f32_e32 v121, v146
		v_exp_f32_e32 v217, v147
		v_exp_f32_e32 v123, v150
		v_exp_f32_e32 v219, v151
		v_pk_add_f32 v[128:129], v[152:153], v[222:223]
		v_pk_add_f32 v[130:131], v[96:97], v[224:225]
		v_pk_add_f32 v[134:135], v[178:179], v[226:227]
		v_pk_add_f32 v[136:137], v[180:181], v[228:229]
		v_pk_add_f32 v[138:139], v[174:175], v[230:231]
		v_pk_add_f32 v[140:141], v[182:183], v[232:233]
		v_pk_add_f32 v[142:143], v[116:117], v[234:235]
		v_pk_add_f32 v[144:145], v[184:185], v[236:237]
		v_pk_add_f32 v[146:147], v[108:109], v[238:239]
		v_pk_add_f32 v[150:151], v[186:187], v[240:241]
		v_pk_add_f32 v[192:193], v[30:31], v[242:243]
		v_pk_add_f32 v[194:195], v[188:189], v[244:245]
		v_pk_add_f32 v[196:197], v[124:125], v[246:247]
		v_pk_add_f32 v[200:201], v[190:191], v[248:249]
		v_pk_add_f32 v[202:203], v[132:133], v[250:251]
		v_pk_add_f32 v[204:205], v[208:209], v[252:253]
		v_pk_add_f32 v[128:129], v[128:129], v[130:131]
		v_pk_add_f32 v[130:131], v[134:135], v[136:137]
		v_pk_add_f32 v[134:135], v[138:139], v[140:141]
		v_pk_add_f32 v[136:137], v[142:143], v[144:145]
		v_pk_add_f32 v[138:139], v[146:147], v[150:151]
		v_pk_add_f32 v[140:141], v[192:193], v[194:195]
		v_pk_add_f32 v[142:143], v[196:197], v[200:201]
		v_pk_add_f32 v[144:145], v[202:203], v[204:205]
		v_pk_add_f32 v[128:129], v[128:129], v[130:131]
		v_pk_add_f32 v[130:131], v[134:135], v[136:137]
		v_pk_add_f32 v[134:135], v[138:139], v[140:141]
		v_pk_add_f32 v[136:137], v[142:143], v[144:145]
		v_pk_add_f32 v[128:129], v[128:129], v[130:131]
		v_pk_add_f32 v[130:131], v[134:135], v[136:137]
		v_pk_add_f32 v[134:135], v[128:129], v[130:131]
		v_add_f32_e32 v128, v134, v135
		v_mov_b32_e32 v129, v128
		v_exp_f32_e32 v126, v172
		v_exp_f32_e32 v220, v173
		v_permlane32_swap_b32_e32 v128, v129
		v_pk_add_f32 v[130:131], v[126:127], v[220:221]
		v_pk_add_f32 v[134:135], v[148:149], v[158:159]
		v_pk_add_f32 v[136:137], v[154:155], v[160:161]
		v_pk_add_f32 v[138:139], v[12:13], v[162:163]
		v_pk_add_f32 v[140:141], v[98:99], v[164:165]
		v_pk_add_f32 v[142:143], v[100:101], v[166:167]
		v_pk_add_f32 v[144:145], v[102:103], v[168:169]
		v_pk_add_f32 v[146:147], v[104:105], v[170:171]
		v_pk_add_f32 v[150:151], v[26:27], v[176:177]
		v_pk_add_f32 v[172:173], v[106:107], v[198:199]
		v_pk_add_f32 v[192:193], v[28:29], v[206:207]
		v_pk_add_f32 v[194:195], v[110:111], v[210:211]
		v_pk_add_f32 v[196:197], v[114:115], v[212:213]
		v_pk_add_f32 v[200:201], v[118:119], v[214:215]
		v_pk_add_f32 v[202:203], v[120:121], v[216:217]
		v_pk_add_f32 v[204:205], v[122:123], v[218:219]
		v_pk_add_f32 v[130:131], v[130:131], v[134:135]
		v_pk_add_f32 v[134:135], v[136:137], v[138:139]
		v_pk_add_f32 v[136:137], v[140:141], v[142:143]
		v_pk_add_f32 v[138:139], v[144:145], v[146:147]
		v_pk_add_f32 v[140:141], v[150:151], v[172:173]
		v_pk_add_f32 v[142:143], v[192:193], v[194:195]
		v_pk_add_f32 v[144:145], v[196:197], v[200:201]
		v_pk_add_f32 v[146:147], v[202:203], v[204:205]
		v_pk_add_f32 v[130:131], v[130:131], v[134:135]
		v_pk_add_f32 v[134:135], v[136:137], v[138:139]
		v_pk_add_f32 v[136:137], v[140:141], v[142:143]
		v_pk_add_f32 v[138:139], v[144:145], v[146:147]
		v_pk_add_f32 v[130:131], v[130:131], v[134:135]
		v_pk_add_f32 v[134:135], v[136:137], v[138:139]
		v_pk_add_f32 v[136:137], v[130:131], v[134:135]
		v_mov_b32_e32 v130, v129
		v_mov_b32_e32 v131, v137
		v_mov_b32_e32 v134, v128
		v_mov_b32_e32 v135, v136
		v_pk_add_f32 v[128:129], v[134:135], v[130:131]
		v_mov_b32_e32 v130, v129
		v_mov_b32_e32 v131, v129
		v_cvt_pk_bf16_f32 v136, v152, v222
		v_cvt_pk_bf16_f32 v137, v96, v224
		v_permlane32_swap_b32_e32 v130, v131
		v_add_f32_e32 v135, v130, v131
		v_mov_b32_e32 v113, v8
		v_pk_add_f32 v[130:131], v[112:113], v[156:157] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v112, v130
		v_exp_f32_e32 v113, v131
		v_cvt_pk_bf16_f32 v138, v178, v226
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
		v_mov_b32_e32 v134, v128
		v_mov_b64_e32 v[128:129], v[24:25]
		v_pk_fma_f32 v[24:25], v[128:129], v[112:113], v[134:135]
		v_cvt_pk_bf16_f32 v139, v180, v228
		v_cvt_pk_bf16_f32 v128, v174, v230
		v_cvt_pk_bf16_f32 v129, v182, v232
		v_cvt_pk_bf16_f32 v130, v116, v234
		v_cvt_pk_bf16_f32 v131, v184, v236
		v_cvt_pk_bf16_f32 v140, v108, v238
		v_cvt_pk_bf16_f32 v141, v186, v240
		v_cvt_pk_bf16_f32 v142, v30, v242
		v_cvt_pk_bf16_f32 v143, v188, v244
		v_cvt_pk_bf16_f32 v144, v124, v246
		v_cvt_pk_bf16_f32 v145, v190, v248
		v_cvt_pk_bf16_f32 v146, v132, v250
		v_cvt_pk_bf16_f32 v147, v208, v252
		v_cvt_pk_bf16_f32 v192, v153, v223
		v_cvt_pk_bf16_f32 v193, v97, v225
		v_cvt_pk_bf16_f32 v194, v179, v227
		v_cvt_pk_bf16_f32 v195, v181, v229
		v_cvt_pk_bf16_f32 v200, v175, v231
		v_cvt_pk_bf16_f32 v201, v183, v233
		v_cvt_pk_bf16_f32 v202, v117, v235
		v_cvt_pk_bf16_f32 v203, v185, v237
		v_cvt_pk_bf16_f32 v172, v109, v239
		v_cvt_pk_bf16_f32 v173, v187, v241
		v_cvt_pk_bf16_f32 v174, v31, v243
		v_cvt_pk_bf16_f32 v175, v189, v245
		v_cvt_pk_bf16_f32 v180, v125, v247
		v_cvt_pk_bf16_f32 v181, v191, v249
		v_cvt_pk_bf16_f32 v182, v133, v251
		v_cvt_pk_bf16_f32 v183, v209, v253
		v_cvt_pk_bf16_f32 v132, v126, v220
		v_cvt_pk_bf16_f32 v133, v148, v158
		v_cvt_pk_bf16_f32 v134, v154, v160
		v_cvt_pk_bf16_f32 v135, v12, v162
		v_cvt_pk_bf16_f32 v184, v98, v164
		v_cvt_pk_bf16_f32 v185, v100, v166
		v_cvt_pk_bf16_f32 v186, v102, v168
		v_cvt_pk_bf16_f32 v187, v104, v170
		v_cvt_pk_bf16_f32 v188, v26, v176
		v_cvt_pk_bf16_f32 v189, v106, v198
		v_cvt_pk_bf16_f32 v190, v28, v206
		v_cvt_pk_bf16_f32 v191, v110, v210
		v_cvt_pk_bf16_f32 v224, v114, v212
		v_cvt_pk_bf16_f32 v225, v118, v214
		v_cvt_pk_bf16_f32 v226, v120, v216
		v_cvt_pk_bf16_f32 v227, v122, v218
		v_cvt_pk_bf16_f32 v228, v127, v221
		v_cvt_pk_bf16_f32 v229, v149, v159
		v_cvt_pk_bf16_f32 v230, v155, v161
		v_cvt_pk_bf16_f32 v231, v13, v163
		v_cvt_pk_bf16_f32 v124, v99, v165
		v_cvt_pk_bf16_f32 v125, v101, v167
		v_cvt_pk_bf16_f32 v126, v103, v169
		v_cvt_pk_bf16_f32 v127, v105, v171
		v_cvt_pk_bf16_f32 v96, v27, v177
		v_cvt_pk_bf16_f32 v97, v107, v199
		v_cvt_pk_bf16_f32 v98, v29, v207
		v_cvt_pk_bf16_f32 v99, v111, v211
		v_cvt_pk_bf16_f32 v28, v115, v213
		v_cvt_pk_bf16_f32 v29, v119, v215
		v_cvt_pk_bf16_f32 v30, v121, v217
		v_cvt_pk_bf16_f32 v31, v123, v219
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[32:47], a[184:187], v[136:139], v[32:47]
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_mfma_f32_32x32x16_bf16 v[48:63], a[216:219], v[136:139], v[48:63]
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_mfma_f32_32x32x16_bf16 v[32:47], a[188:191], v[128:131], v[32:47]
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[220:223], v[128:131], v[48:63]
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[140:143], v[32:47]
		v_permlane32_swap_b32_e32 v172, v174
		v_permlane32_swap_b32_e32 v173, v175
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[140:143], v[48:63]
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[144:147], v[32:47]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[144:147], v[48:63]
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
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[188:191], v[80:95]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[188:191], v[64:79]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[224:227], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[224:227], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[192:195], v[32:47]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[192:195], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[228:231], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[228:231], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[200:203], v[32:47]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[200:203], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[124:127], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[124:127], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[172:175], v[32:47]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[172:175], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[180:183], v[32:47]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[180:183], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[28:31], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[28:31], v[64:79]
		s_cselect_b32 s1, 1, 0
		s_add_i32 s25, s41, 0x80
		s_cmp_lg_u32 s1, 0
		s_mov_b32 s41, s25
		v_mov_b32_e32 v5, v156
		v_mov_b32_e32 v8, v157
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
		v_and_b32_e32 v3, 1, v2
		v_mov_b32_e32 v4, 2
		v_mul_lo_u32 v4, v4, v3
		v_lshrrev_b32_e32 v3, 2, v0
		v_and_b32_e32 v5, 1, v3
		v_mov_b32_e32 v6, 4
		v_mul_lo_u32 v6, v6, v5
		v_bitop3_b32 v5, v1, v4, v6 bitop3:0x96
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
		v_accvgpr_write_b32 a15, v5
		v_xor_b32_e32 v1, 0x80, v1
		v_xor_b32_e32 v1, v1, v4
		v_xor_b32_e32 v1, v1, v6
		v_bitop3_b32 v1, v1, v9, v12 bitop3:0x96
		v_bitop3_b32 v1, v1, v14, v16 bitop3:0x96
		v_accvgpr_write_b32 a16, v1
		v_mov_b32_e32 v1, 2
		v_mul_lo_u32 v1, v1, v11
		v_lshrrev_b32_e32 v4, 5, v0
		v_and_b32_e32 v5, 1, v4
		v_mov_b32_e32 v6, 4
		v_mul_lo_u32 v6, v6, v5
		v_bitop3_b32 v9, v8, v1, v6 bitop3:0x96
		v_mov_b32_e32 v12, 8
		v_mul_lo_u32 v12, v12, v13
		v_xor_b32_e32 v9, v9, v12
		v_mov_b32_e32 v14, 16
		v_mul_lo_u32 v14, v14, v15
		v_xad_u32 v9, v9, v14, s1
		v_bitop3_b32 v16, 32, v8, v1 bitop3:0x96
		v_bitop3_b32 v16, v16, v6, v12 bitop3:0x96
		v_xad_u32 v16, v16, v14, s1
		v_bitop3_b32 v17, 64, v8, v1 bitop3:0x96
		v_bitop3_b32 v17, v17, v6, v12 bitop3:0x96
		v_xad_u32 v17, v17, v14, s1
		v_xor_b32_e32 v18, 0x60, v8
		v_xor_b32_e32 v18, v18, v1
		v_xor_b32_e32 v18, v18, v6
		v_xor_b32_e32 v18, v18, v12
		v_xad_u32 v18, v18, v14, s1
		v_xor_b32_e32 v19, 0x80, v8
		v_xor_b32_e32 v19, v19, v1
		v_xor_b32_e32 v19, v19, v6
		v_xor_b32_e32 v19, v19, v12
		v_xad_u32 v19, v19, v14, s1
		v_xor_b32_e32 v20, 0xa0, v8
		v_xor_b32_e32 v20, v20, v1
		v_xor_b32_e32 v20, v20, v6
		v_xor_b32_e32 v20, v20, v12
		v_xad_u32 v20, v20, v14, s1
		v_xor_b32_e32 v21, 0xc0, v8
		v_xor_b32_e32 v21, v21, v1
		v_xor_b32_e32 v21, v21, v6
		v_xor_b32_e32 v21, v21, v12
		v_xad_u32 v21, v21, v14, s1
		v_xor_b32_e32 v22, 0xe0, v8
		v_xor_b32_e32 v1, v22, v1
		v_xor_b32_e32 v1, v1, v6
		v_xor_b32_e32 v1, v1, v12
		v_xad_u32 v1, v1, v14, s1
		v_cmp_lt_i32_e64 s[22:23], v9, s19
		v_cmp_lt_i32_e64 s[24:25], v16, s19
		v_cmp_lt_i32_e64 s[28:29], v17, s19
		v_cmp_lt_i32_e64 s[30:31], v18, s19
		v_cmp_lt_i32_e64 s[32:33], v19, s19
		v_cmp_lt_i32_e64 s[34:35], v20, s19
		v_cmp_lt_i32_e64 s[36:37], v21, s19
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
		v_accvgpr_read_b32 v9, a13
		s_nop 0
		v_readfirstlane_b32 s18, v9
		s_mul_i32 s18, s18, s12
		s_lshl_b32 s18, s18, 9
		v_accvgpr_read_b32 v9, a11
		s_nop 0
		v_readfirstlane_b32 s21, v9
		s_mul_i32 s21, s21, s10
		s_lshl_b32 s21, s21, 1
		s_add_i32 s26, s18, s21
		v_accvgpr_read_b32 v9, a12
		s_nop 0
		v_readfirstlane_b32 s38, v9
		s_mul_i32 s38, s38, s11
		s_lshl_b32 s38, s38, 1
		s_add_i32 s26, s26, s38
		v_mul_lo_u32 v9, s12, v7
		v_lshl_add_u32 v12, v9, 1, s26
		v_and_b32_e32 v14, 7, v0
		v_lshl_add_u32 v12, v14, 4, v12
		s_and_saveexec_b64 s[100:101], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_16
		buffer_load_dwordx4 v[20:23], v12, s[40:43], 0 offen
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
		v_lshl_add_u32 v12, v9, 1, s22
		v_lshl_add_u32 v12, v14, 4, v12
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_17
		buffer_load_dwordx4 v[24:27], v12, s[40:43], 0 offen
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
		v_lshl_add_u32 v12, v9, 1, s22
		v_lshl_add_u32 v12, v14, 4, v12
		s_and_saveexec_b64 s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_18
		buffer_load_dwordx4 v[28:31], v12, s[40:43], 0 offen
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
		v_lshl_add_u32 v12, v9, 1, s22
		v_lshl_add_u32 v12, v14, 4, v12
		s_and_saveexec_b64 s[100:101], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_19
		buffer_load_dwordx4 v[32:35], v12, s[40:43], 0 offen
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
		v_lshl_add_u32 v12, v9, 1, s22
		v_lshl_add_u32 v12, v14, 4, v12
		s_and_saveexec_b64 s[100:101], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_20
		buffer_load_dwordx4 v[36:39], v12, s[40:43], 0 offen
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
		v_lshl_add_u32 v12, v9, 1, s22
		v_lshl_add_u32 v12, v14, 4, v12
		s_and_saveexec_b64 s[100:101], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_21
		buffer_load_dwordx4 v[40:43], v12, s[40:43], 0 offen
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
		v_lshl_add_u32 v12, v9, 1, s22
		v_lshl_add_u32 v12, v14, 4, v12
		s_and_saveexec_b64 s[100:101], s[36:37]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_22
		buffer_load_dwordx4 v[44:47], v12, s[40:43], 0 offen
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
		v_lshl_add_u32 v9, v9, 1, s18
		v_lshl_add_u32 v9, v14, 4, v9
		v_cmp_lt_i32_e64 vcc, v1, s19
		s_and_saveexec_b64 s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_23
		buffer_load_dwordx4 v[48:51], v9, s[40:43], 0 offen
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
		v_and_b32_e32 v1, 5, v4
		v_bitop3_b32 v1, 4, v2, v1 bitop3:0x6a
		v_bitop3_b32 v1, 2, v7, v1 bitop3:0x6a
		v_xor_b32_e32 v1, v0, v1
		v_lshlrev_b32_e32 v1, 4, v1
		v_add_u32_e32 v1, 0x10000, v1
		ds_write_b128 v1, v[20:23] offset:18864
		ds_write_b128 v1, v[24:27] offset:22960
		ds_write_b128 v1, v[28:31] offset:27056
		ds_write_b128 v1, v[32:35] offset:31152
		v_mov_b32_e32 v2, 32
		v_mul_lo_u32 v2, v2, v11
		v_mov_b32_e32 v9, 2
		v_mul_lo_u32 v9, v9, v15
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v11, a14
		s_nop 0
		v_readfirstlane_b32 s18, v11
		s_lshl_b32 s18, s18, 12
		s_add_i32 s18, s18, 0x10000
		v_and_b32_e32 v11, 63, v0
		v_lshrrev_b32_e32 v12, 5, v11
		v_and_b32_e32 v15, 31, v11
		v_lshlrev_b32_e32 v16, 3, v15
		v_add_u32_e32 v17, v12, v16
		v_lshlrev_b32_e32 v18, 2, v15
		v_and_b32_e32 v19, 7, v11
		v_lshrrev_b32_e32 v19, 2, v19
		v_lshrrev_b32_e32 v11, 3, v11
		v_and_b32_e32 v11, 3, v11
		v_lshl_add_u32 v11, v11, 1, v19
		v_and_b32_e32 v11, 5, v11
		v_bitop3_b32 v19, 4, v18, v11 bitop3:0x6a
		v_xor_b32_e32 v17, v17, v19
		v_lshlrev_b32_e32 v17, 4, v17
		v_and_b32_e32 v19, 2, v15
		v_lshlrev_b32_e32 v20, 4, v19
		v_add3_u32 v17, s18, v17, v20
		ds_read_b128 a[20:23], v17 offset:18864
		v_add3_u32 v21, 2, v12, v16
		v_add_u32_e32 v22, 1, v18
		v_bitop3_b32 v22, 4, v22, v11 bitop3:0x6a
		v_bitop3_b32 v21, v21, v19, v22 bitop3:0x96
		v_lshl_add_u32 v21, v21, 4, s18
		ds_read_b128 a[24:27], v21 offset:18864
		v_add3_u32 v22, 4, v12, v16
		v_add_u32_e32 v23, 2, v18
		v_bitop3_b32 v23, 4, v23, v11 bitop3:0x6a
		v_xor_b32_e32 v22, v22, v23
		v_lshlrev_b32_e32 v22, 4, v22
		v_add3_u32 v20, s18, v22, v20
		ds_read_b128 a[28:31], v20 offset:18864
		v_add3_u32 v16, 6, v12, v16
		v_add_u32_e32 v18, 3, v18
		v_bitop3_b32 v11, 4, v18, v11 bitop3:0x6a
		v_bitop3_b32 v11, v16, v19, v11 bitop3:0x96
		v_lshl_add_u32 v11, v11, 4, s18
		ds_read_b128 a[32:35], v11 offset:18864
		v_and_b32_e32 v4, 1, v4
		v_accvgpr_write_b32 a17, v4
		v_and_b32_e32 v4, 1, v10
		v_and_b32_e32 v7, 1, v7
		v_lshlrev_b32_e32 v10, 4, v14
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[36:39] offset:18864
		ds_write_b128 v1, v[40:43] offset:22960
		ds_write_b128 v1, v[44:47] offset:27056
		ds_write_b128 v1, v[48:51] offset:31152
		v_and_b32_e32 v1, 1, v3
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[36:39], v17 offset:18864
		ds_read_b128 a[40:43], v21 offset:18864
		ds_read_b128 a[44:47], v20 offset:18864
		ds_read_b128 a[48:51], v11 offset:18864
		v_accvgpr_read_b32 v3, a13
		s_nop 0
		v_readfirstlane_b32 s18, v3
		s_add_i32 s18, s18, 1
		s_mul_i32 s18, s18, 0x100
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
		s_cselect_b32 s24, s22, 0
		s_add_i32 s23, s23, s24
		s_ashr_i32 s23, s23, 7
		s_cmp_lt_i32 s23, s21
		s_cselect_b32 s23, s23, s21
		s_cmp_gt_i32 s23, 0
		s_cselect_b32 s23, s23, 0
		v_mov_b32_e32 v3, 64
		v_mul_lo_u32 v3, v3, v8
		v_mov_b32_e32 v11, 16
		v_mul_lo_u32 v11, v11, v5
		v_bitop3_b32 v14, v3, v2, v11 bitop3:0x96
		v_bitop3_b32 v14, v14, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a18, v14
		v_bitop3_b32 v14, 4, v3, v2 bitop3:0x96
		v_xor_b32_e32 v14, v14, v11
		v_bitop3_b32 v16, 8, v3, v2 bitop3:0x96
		v_xor_b32_e32 v16, v16, v11
		v_bitop3_b32 v3, 12, v3, v2 bitop3:0x96
		v_accvgpr_read_b32 v17, a18
		v_cmp_lt_i32_e64 s[24:25], v17, s20
		v_mov_b32_e32 v17, 16
		v_mul_lo_u32 v17, v17, v8
		v_mov_b32_e32 v8, 64
		v_mul_lo_u32 v8, v8, v5
		v_bitop3_b32 v5, v17, v2, v8 bitop3:0x96
		v_bitop3_b32 v5, v5, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a19, v5
		v_bitop3_b32 v5, 4, v17, v2 bitop3:0x96
		v_bitop3_b32 v18, 8, v17, v2 bitop3:0x96
		v_bitop3_b32 v2, 12, v17, v2 bitop3:0x96
		v_accvgpr_read_b32 v17, a19
		v_cmp_lt_i32_e64 vcc, v17, s20
		v_readfirstlane_b32 s36, v0
		v_accvgpr_read_b32 v17, a11
		s_nop 0
		v_readfirstlane_b32 s26, v17
		s_mul_i32 s26, s26, s13
		s_lshl_b32 s26, s26, 1
		v_accvgpr_read_b32 v17, a12
		s_nop 0
		v_readfirstlane_b32 s37, v17
		s_mul_i32 s37, s37, s14
		s_lshl_b32 s37, s37, 1
		s_add_i32 s38, s26, s37
		v_accvgpr_read_b32 v17, a14
		s_nop 0
		v_readfirstlane_b32 s39, v17
		s_mul_i32 s39, s15, s39
		s_lshl_b32 s39, s39, 1
		s_add_i32 s38, s38, s39
		v_accvgpr_read_b32 v17, a17
		v_mul_lo_u32 v17, s15, v17
		v_lshlrev_b32_e32 v17, 5, v17
		v_mul_lo_u32 v19, s15, v4
		v_lshlrev_b32_e32 v19, 6, v19
		v_add3_u32 v20, s38, v17, v19
		v_mul_lo_u32 v21, s15, v7
		v_lshlrev_b32_e32 v21, 7, v21
		v_add3_u32 v20, v20, v21, v10
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
		v_add3_u32 v20, s41, v17, v19
		v_add3_u32 v20, v20, v21, v10
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
		v_add3_u32 v20, s41, v17, v19
		v_add3_u32 v20, v20, v21, v10
		v_cndmask_b32_e64 v20, v22, v20, s[24:25]
		s_add_i32 m0, m0, 0x1040
		v_lshlrev_b32_e32 v12, 4, v12
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		v_bitop3_b32 v14, v14, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a56, v14
		s_mul_i32 s41, 24, s15
		s_add_i32 s41, s41, s26
		s_add_i32 s41, s41, s37
		s_add_i32 s41, s41, s39
		v_add3_u32 v14, s41, v17, v19
		v_add3_u32 v14, v14, v21, v10
		v_cndmask_b32_e64 v14, v22, v14, s[24:25]
		s_add_i32 m0, m0, 0x1040
		v_mov_b32_e32 v20, 0x440
		v_mul_lo_u32 v20, v20, v1
		buffer_load_dwordx4 v14, s[28:31], 0 offen lds
		v_bitop3_b32 v1, v16, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a57, v1
		v_accvgpr_read_b32 v1, a0
		s_nop 0
		v_readfirstlane_b32 s24, v1
		v_accvgpr_read_b32 v1, a11
		s_nop 0
		v_readfirstlane_b32 s25, v1
		s_mul_i32 s24, s25, s24
		s_lshl_b32 s24, s24, 1
		v_accvgpr_read_b32 v1, a1
		s_nop 0
		v_readfirstlane_b32 s25, v1
		v_accvgpr_read_b32 v1, a12
		s_nop 0
		v_readfirstlane_b32 s41, v1
		s_mul_i32 s25, s41, s25
		s_lshl_b32 s25, s25, 1
		s_add_i32 s41, s24, s25
		v_accvgpr_read_b32 v1, a14
		s_nop 0
		v_readfirstlane_b32 s44, v1
		s_mul_i32 s44, s17, s44
		s_lshl_b32 s44, s44, 1
		s_add_i32 s41, s41, s44
		v_accvgpr_read_b32 v1, a17
		v_mul_lo_u32 v1, s17, v1
		v_lshlrev_b32_e32 v1, 7, v1
		v_mul_lo_u32 v14, s17, v4
		v_lshlrev_b32_e32 v14, 6, v14
		v_add3_u32 v16, s41, v1, v14
		v_mul_lo_u32 v23, s17, v7
		v_lshlrev_b32_e32 v23, 5, v23
		v_add3_u32 v16, v16, v23, v10
		v_cndmask_b32_e32 v16, v22, v16, vcc
		s_mul_i32 s38, 0x440, s38
		s_add_i32 m0, s38, 0x81f0
		v_xor_b32_e32 v3, v3, v11
		buffer_load_dwordx4 v16, s[32:35], 0 offen lds
		v_bitop3_b32 v3, v3, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a58, v3
		s_lshl_b32 s41, s17, 3
		s_add_i32 s41, s41, s24
		s_add_i32 s41, s41, s25
		s_add_i32 s41, s41, s44
		v_add3_u32 v3, s41, v1, v14
		v_add3_u32 v3, v3, v23, v10
		v_cndmask_b32_e32 v3, v22, v3, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v5, v5, v8
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
		v_bitop3_b32 v3, v5, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a59, v3
		s_lshl_b32 s41, s17, 4
		s_add_i32 s41, s41, s24
		s_add_i32 s41, s41, s25
		s_add_i32 s41, s41, s44
		v_add3_u32 v3, s41, v1, v14
		v_add3_u32 v3, v3, v23, v10
		v_cndmask_b32_e32 v3, v22, v3, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v5, v18, v8
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
		v_bitop3_b32 v3, v5, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a60, v3
		s_mul_i32 s41, 24, s17
		s_add_i32 s41, s41, s24
		s_add_i32 s41, s41, s25
		s_add_i32 s41, s41, s44
		v_add3_u32 v3, s41, v1, v14
		v_add3_u32 v3, v3, v23, v10
		v_cndmask_b32_e32 v3, v22, v3, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v2, v2, v8
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
		v_bitop3_b32 v2, v2, v13, v9 bitop3:0x96
		v_accvgpr_write_b32 a61, v2
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
		v_mov_b32_e32 v2, 0x3e38aa3b
		v_mov_b32_e32 v3, 0x3e38aa3b
		s_mov_b32 s25, 0xff800000
		v_mov_b32_e32 v5, s25
		v_mov_b32_e32 v8, s25
		s_mov_b32 s25, 1.0
		v_mov_b32_e32 v24, s25
		v_mov_b32_e32 v25, s25
		s_mov_b32 s25, 0
		v_lshrrev_b32_e32 v9, 4, v15
		v_lshlrev_b32_e32 v9, 9, v9
		v_and_b32_e32 v11, 15, v15
		v_mov_b32_e32 v13, 0x410
		v_mul_lo_u32 v13, v13, v11
		v_add3_u32 v9, v12, v9, v13
		v_accvgpr_write_b32 a62, v9
		v_and_b32_e32 v9, 3, v0
		v_accvgpr_read_b32 v11, a17
		v_mov_b32_e32 v12, 0x2200
		v_mul_lo_u32 v12, v12, v11
		v_lshl_add_u32 v9, v9, 3, v12
		v_lshl_add_u32 v4, v4, 5, v9
		v_mov_b32_e32 v9, 0x880
		v_mul_lo_u32 v9, v9, v7
		v_add3_u32 v4, v4, v9, v20
		v_accvgpr_write_b32 a63, v4
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
		v_accvgpr_read_b32 v4, a62
		v_add_u32_e32 v4, s49, v4
		ds_read_b128 v[28:31], v4
		ds_read_b128 v[96:99], v4 offset:32
		ds_read_b128 v[100:103], v4 offset:64
		ds_read_b128 a[64:67], v4 offset:96
		ds_read_b128 v[104:107], v4 offset:256
		ds_read_b128 v[108:111], v4 offset:288
		ds_read_b128 v[112:115], v4 offset:320
		ds_read_b128 a[68:71], v4 offset:352
		ds_read_b128 v[116:119], v4 offset:128
		ds_read_b128 v[120:123], v4 offset:160
		ds_read_b128 v[124:127], v4 offset:192
		ds_read_b128 a[72:75], v4 offset:224
		ds_read_b128 v[128:131], v4 offset:384
		ds_read_b128 v[132:135], v4 offset:416
		ds_read_b128 a[76:79], v4 offset:448
		ds_read_b128 a[80:83], v4 offset:480
		s_mul_i32 s44, 0x4400, s44
		v_accvgpr_read_b32 v4, a63
		v_add_u32_e32 v4, s44, v4
		ds_read_b64_tr_b16 a[84:85], v4 offset:33264
		ds_read_b64_tr_b16 a[86:87], v4 offset:37616
		ds_read_b64_tr_b16 a[88:89], v4 offset:33392
		ds_read_b64_tr_b16 a[90:91], v4 offset:37744
		ds_read_b64_tr_b16 a[92:93], v4 offset:33520
		ds_read_b64_tr_b16 a[94:95], v4 offset:37872
		ds_read_b64_tr_b16 a[96:97], v4 offset:33648
		ds_read_b64_tr_b16 a[98:99], v4 offset:38000
		ds_read_b64_tr_b16 a[100:101], v4 offset:33776
		ds_read_b64_tr_b16 a[102:103], v4 offset:38128
		ds_read_b64_tr_b16 a[104:105], v4 offset:33904
		ds_read_b64_tr_b16 a[106:107], v4 offset:38256
		ds_read_b64_tr_b16 a[108:109], v4 offset:34032
		ds_read_b64_tr_b16 a[110:111], v4 offset:38384
		ds_read_b64_tr_b16 a[112:113], v4 offset:34160
		ds_read_b64_tr_b16 a[114:115], v4 offset:38512
		ds_read_b64_tr_b16 a[116:117], v4 offset:33328
		ds_read_b64_tr_b16 a[118:119], v4 offset:37680
		ds_read_b64_tr_b16 a[120:121], v4 offset:33456
		ds_read_b64_tr_b16 a[122:123], v4 offset:37808
		ds_read_b64_tr_b16 a[124:125], v4 offset:33584
		ds_read_b64_tr_b16 a[126:127], v4 offset:37936
		ds_read_b64_tr_b16 a[128:129], v4 offset:33712
		ds_read_b64_tr_b16 a[130:131], v4 offset:38064
		ds_read_b64_tr_b16 a[132:133], v4 offset:33840
		ds_read_b64_tr_b16 a[134:135], v4 offset:38192
		ds_read_b64_tr_b16 a[136:137], v4 offset:33968
		ds_read_b64_tr_b16 a[138:139], v4 offset:38320
		ds_read_b64_tr_b16 a[140:141], v4 offset:34096
		ds_read_b64_tr_b16 a[142:143], v4 offset:38448
		ds_read_b64_tr_b16 a[144:145], v4 offset:34224
		ds_read_b64_tr_b16 a[146:147], v4 offset:38576
		s_mul_i32 s44, s15, s25
		s_lshl_b32 s44, s44, 1
		s_add_i32 s49, s23, s44
		v_add3_u32 v4, s49, v17, v19
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[20:23], 0
		v_add3_u32 v4, v4, v21, v10
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
		v_add3_u32 v7, s49, v17, v19
		v_mfma_f32_32x32x16_bf16 v[176:191], v[112:115], a[28:31], v[176:191]
		v_add3_u32 v7, v7, v21, v10
		v_mfma_f32_32x32x16_bf16 v[192:207], v[104:107], a[36:39], 0
		s_add_i32 s49, s46, s44
		v_mfma_f32_32x32x16_bf16 v[192:207], v[108:111], a[40:43], v[192:207]
		v_add3_u32 v9, s49, v17, v19
		v_mfma_f32_32x32x16_bf16 v[192:207], v[112:115], a[44:47], v[192:207]
		v_add3_u32 v9, v9, v21, v10
		v_mfma_f32_32x32x16_bf16 v[96:111], v[116:119], a[20:23], 0
		s_add_i32 s44, s26, s44
		v_mfma_f32_32x32x16_bf16 v[96:111], v[120:123], a[24:27], v[96:111]
		v_add3_u32 v11, s44, v17, v19
		v_mfma_f32_32x32x16_bf16 v[96:111], v[124:127], a[28:31], v[96:111]
		v_add3_u32 v11, v11, v21, v10
		v_mfma_f32_32x32x16_bf16 v[208:223], v[116:119], a[36:39], 0
		s_mul_i32 s44, s17, s25
		v_mfma_f32_32x32x16_bf16 v[208:223], v[120:123], a[40:43], v[208:223]
		s_add_i32 s25, s25, 0x80
		v_mfma_f32_32x32x16_bf16 v[208:223], v[124:127], a[44:47], v[208:223]
		v_accvgpr_read_b32 v12, a18
		v_add_u32_e32 v12, s25, v12
		v_mfma_f32_32x32x16_bf16 v[112:127], v[128:131], a[20:23], 0
		v_accvgpr_read_b32 v13, a56
		v_add_u32_e32 v13, s25, v13
		v_mfma_f32_32x32x16_bf16 v[112:127], v[132:135], a[24:27], v[112:127]
		v_accvgpr_read_b32 v15, a57
		v_add_u32_e32 v15, s25, v15
		v_mfma_f32_32x32x16_bf16 v[112:127], a[76:79], a[28:31], v[112:127]
		v_accvgpr_read_b32 v16, a58
		v_add_u32_e32 v16, s25, v16
		v_mfma_f32_32x32x16_bf16 v[224:239], v[128:131], a[36:39], 0
		v_cmp_lt_i32_e64 s[50:51], v12, s20
		v_accvgpr_read_b32 v12, a19
		v_add_u32_e32 v12, s25, v12
		v_accvgpr_read_b32 v18, a59
		v_add_u32_e32 v18, s25, v18
		v_accvgpr_read_b32 v20, a60
		v_add_u32_e32 v20, s25, v20
		v_accvgpr_read_b32 v26, a61
		v_add_u32_e32 v26, s25, v26
		v_cmp_lt_i32_e64 vcc, v26, s20
		v_cndmask_b32_e64 v4, v22, v4, s[50:51]
		buffer_load_dwordx4 v4, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[50:51], v13, s20
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[52:53], v15, s20
		v_cndmask_b32_e64 v4, v22, v7, s[50:51]
		v_cmp_lt_i32_e64 s[50:51], v16, s20
		buffer_load_dwordx4 v4, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], v[132:135], a[40:43], v[224:239]
		v_cndmask_b32_e64 v4, v22, v9, s[52:53]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[76:79], a[44:47], v[224:239]
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v7, v22, v11, s[50:51]
		buffer_load_dwordx4 v4, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[50:51], v12, s20
		v_cmp_lt_i32_e64 s[52:53], v18, s20
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s44, s44, 1
		s_add_i32 s49, s39, s44
		buffer_load_dwordx4 v7, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[144:159], a[64:67], a[32:35], v[144:159]
		v_add3_u32 v4, s49, v1, v14
		v_mfma_f32_32x32x16_bf16 v[160:175], a[64:67], a[48:51], v[160:175]
		v_add3_u32 v4, v4, v23, v10
		v_cndmask_b32_e64 v4, v22, v4, s[50:51]
		v_cmp_lt_i32_e64 s[50:51], v20, s20
		s_mul_i32 s37, 0x4400, s37
		s_add_i32 s37, s38, s37
		s_add_i32 m0, s37, 0x81f0
		s_add_i32 s37, s47, s44
		buffer_load_dwordx4 v4, s[32:35], 0 offen lds
		v_add3_u32 v4, s37, v1, v14
		v_add3_u32 v4, v4, v23, v10
		v_cndmask_b32_e64 v4, v22, v4, s[52:53]
		v_max3_f32 v7, v144, v145, v146
		s_add_i32 m0, m0, 0x1100
		s_add_i32 s37, s48, s44
		buffer_load_dwordx4 v4, s[32:35], 0 offen lds
		v_add3_u32 v4, s37, v1, v14
		v_add3_u32 v4, v4, v23, v10
		v_max3_f32 v9, v148, v149, v150
		s_add_i32 m0, m0, 0x1100
		v_cndmask_b32_e64 v4, v22, v4, s[50:51]
		buffer_load_dwordx4 v4, s[32:35], 0 offen lds
		v_max3_f32 v4, v152, v153, v154
		s_add_i32 s37, s24, s44
		v_add3_u32 v11, s37, v1, v14
		v_add3_u32 v11, v11, v23, v10
		v_cndmask_b32_e32 v11, v22, v11, vcc
		v_max3_f32 v12, v156, v157, v158
		s_add_i32 m0, m0, 0x1100
		v_max3_f32 v7, v7, v147, v9
		v_max3_f32 v4, v4, v155, v12
		v_max3_f32 v4, v7, v151, v4
		v_max3_f32 v7, v160, v161, v162
		v_max3_f32 v9, v164, v165, v166
		v_max3_f32 v12, v168, v169, v170
		v_max3_f32 v13, v172, v173, v174
		v_max3_f32 v7, v7, v163, v9
		v_max3_f32 v9, v12, v171, v13
		v_max3_f32 v7, v7, v167, v9
		s_cmp_lt_i32 s25, s41
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[176:191], a[68:71], a[32:35], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[72:75], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[80:83], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[80:83], a[48:51], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[68:71], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[72:75], a[48:51], v[208:223]
		s_nop 6
		v_max3_f32 v9, v176, v177, v178
		v_max3_f32 v11, v180, v181, v182
		v_max3_f32 v12, v184, v185, v186
		v_max3_f32 v13, v188, v189, v190
		v_max3_f32 v15, v96, v97, v98
		v_max3_f32 v16, v100, v101, v102
		v_max3_f32 v18, v104, v105, v106
		v_max3_f32 v20, v108, v109, v110
		v_max3_f32 v26, v112, v113, v114
		v_max3_f32 v27, v116, v117, v118
		v_max3_f32 v28, v120, v121, v122
		v_max3_f32 v29, v124, v125, v126
		v_max3_f32 v9, v9, v179, v11
		v_max3_f32 v11, v12, v187, v13
		v_max3_f32 v12, v15, v99, v16
		v_max3_f32 v13, v18, v107, v20
		v_max3_f32 v15, v26, v115, v27
		v_max3_f32 v16, v28, v123, v29
		v_max3_f32 v9, v9, v183, v11
		v_max3_f32 v11, v12, v103, v13
		v_max3_f32 v12, v15, v119, v16
		v_max3_f32 v4, v4, v159, v9
		v_max3_f32 v9, v11, v111, v12
		v_max3_f32 v4, v4, v191, v9
		v_max_f32_e32 v12, v4, v127
		v_mov_b32_e32 v13, v12
		v_max3_f32 v4, v192, v193, v194
		v_max3_f32 v9, v196, v197, v198
		v_max3_f32 v11, v200, v201, v202
		v_max3_f32 v15, v204, v205, v206
		v_max3_f32 v16, v208, v209, v210
		v_max3_f32 v18, v212, v213, v214
		v_max3_f32 v20, v216, v217, v218
		v_max3_f32 v26, v220, v221, v222
		v_max3_f32 v27, v224, v225, v226
		v_max3_f32 v28, v228, v229, v230
		v_max3_f32 v29, v232, v233, v234
		v_max3_f32 v30, v236, v237, v238
		v_max3_f32 v4, v4, v195, v9
		v_max3_f32 v9, v11, v203, v15
		v_max3_f32 v11, v16, v211, v18
		v_max3_f32 v15, v20, v219, v26
		v_permlane32_swap_b32_e32 v12, v13
		v_max3_f32 v16, v27, v227, v28
		v_max3_f32 v18, v29, v235, v30
		v_max3_f32 v4, v4, v199, v9
		v_max3_f32 v9, v11, v215, v15
		v_max3_f32 v11, v16, v231, v18
		v_max3_f32 v4, v7, v175, v4
		v_max3_f32 v7, v9, v223, v11
		v_max3_f32 v4, v4, v207, v7
		v_max_f32_e32 v26, v4, v239
		v_mov_b32_e32 v27, v26
		v_max_f32_e32 v28, v12, v13
		v_mov_b32_e32 v12, v5
		v_permlane32_swap_b32_e32 v26, v27
		v_max_f32_e32 v29, v26, v27
		v_pk_mul_f32 v[26:27], v[28:29], v[2:3]
		v_max_f32_e32 v28, v5, v26
		v_max_f32_e32 v29, v8, v27
		v_pk_fma_f32 v[4:5], v[144:145], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[146:147], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[148:149], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[150:151], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[152:153], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[154:155], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[156:157], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[158:159], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[176:177], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[178:179], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[180:181], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[182:183], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[184:185], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[186:187], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[188:189], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[190:191], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[96:97], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[98:99], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[108:109], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[110:111], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[112:113], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[114:115], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[116:117], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[118:119], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[120:121], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[122:123], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[124:125], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[126:127], v[2:3], v[28:29] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[160:161], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[162:163], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[164:165], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[166:167], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[168:169], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[170:171], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[172:173], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[174:175], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[192:193], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[194:195], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[196:197], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[198:199], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[200:201], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[202:203], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[204:205], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[206:207], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[208:209], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[210:211], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[212:213], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[214:215], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[216:217], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[218:219], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[220:221], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[222:223], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[224:225], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[226:227], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[228:229], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[230:231], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[232:233], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[234:235], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[236:237], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[238:239], v[2:3], v[28:29] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v218, v4
		v_exp_f32_e32 v220, v5
		v_exp_f32_e32 v4, v26
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
		v_exp_f32_e32 v219, v154
		v_exp_f32_e32 v221, v155
		v_exp_f32_e32 v5, v96
		v_exp_f32_e32 v223, v97
		v_exp_f32_e32 v27, v98
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
		v_exp_f32_e32 v145, v118
		v_exp_f32_e32 v245, v119
		v_exp_f32_e32 v147, v120
		v_exp_f32_e32 v247, v121
		v_exp_f32_e32 v149, v122
		v_exp_f32_e32 v249, v123
		v_exp_f32_e32 v151, v124
		v_exp_f32_e32 v251, v125
		v_exp_f32_e32 v96, v156
		v_exp_f32_e32 v98, v157
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
		v_exp_f32_e32 v152, v171
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
		v_exp_f32_e32 v183, v186
		v_exp_f32_e32 v185, v187
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
		v_exp_f32_e32 v153, v203
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
		v_pk_add_f32 v[186:187], v[218:219], v[220:221]
		v_pk_add_f32 v[188:189], v[4:5], v[222:223]
		v_pk_add_f32 v[190:191], v[26:27], v[224:225]
		v_pk_add_f32 v[192:193], v[30:31], v[226:227]
		v_pk_add_f32 v[194:195], v[128:129], v[228:229]
		v_pk_add_f32 v[196:197], v[130:131], v[230:231]
		v_pk_add_f32 v[198:199], v[132:133], v[232:233]
		v_pk_add_f32 v[200:201], v[134:135], v[234:235]
		v_pk_add_f32 v[202:203], v[136:137], v[236:237]
		v_pk_add_f32 v[204:205], v[138:139], v[238:239]
		v_pk_add_f32 v[206:207], v[140:141], v[240:241]
		v_pk_add_f32 v[208:209], v[142:143], v[242:243]
		v_pk_add_f32 v[210:211], v[144:145], v[244:245]
		v_pk_add_f32 v[212:213], v[146:147], v[246:247]
		v_pk_add_f32 v[214:215], v[148:149], v[248:249]
		v_pk_add_f32 v[216:217], v[150:151], v[250:251]
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
		v_add_f32_e32 v186, v190, v191
		v_mov_b32_e32 v187, v186
		v_exp_f32_e32 v182, v126
		v_exp_f32_e32 v184, v127
		v_permlane32_swap_b32_e32 v186, v187
		v_pk_add_f32 v[126:127], v[182:183], v[184:185]
		v_pk_add_f32 v[188:189], v[96:97], v[98:99]
		v_pk_add_f32 v[190:191], v[100:101], v[102:103]
		v_pk_add_f32 v[192:193], v[104:105], v[106:107]
		v_pk_add_f32 v[194:195], v[108:109], v[110:111]
		v_pk_add_f32 v[196:197], v[112:113], v[114:115]
		v_pk_add_f32 v[198:199], v[116:117], v[118:119]
		v_pk_add_f32 v[200:201], v[120:121], v[122:123]
		v_pk_add_f32 v[202:203], v[124:125], v[152:153]
		v_pk_add_f32 v[204:205], v[154:155], v[156:157]
		v_pk_add_f32 v[206:207], v[158:159], v[160:161]
		v_pk_add_f32 v[208:209], v[162:163], v[164:165]
		v_pk_add_f32 v[210:211], v[166:167], v[168:169]
		v_pk_add_f32 v[212:213], v[170:171], v[172:173]
		v_pk_add_f32 v[214:215], v[174:175], v[176:177]
		v_pk_add_f32 v[216:217], v[178:179], v[180:181]
		v_pk_add_f32 v[126:127], v[126:127], v[188:189]
		v_pk_add_f32 v[188:189], v[190:191], v[192:193]
		v_pk_add_f32 v[190:191], v[194:195], v[196:197]
		v_pk_add_f32 v[192:193], v[198:199], v[200:201]
		v_pk_add_f32 v[194:195], v[202:203], v[204:205]
		v_pk_add_f32 v[196:197], v[206:207], v[208:209]
		v_pk_add_f32 v[198:199], v[210:211], v[212:213]
		v_pk_add_f32 v[200:201], v[214:215], v[216:217]
		v_pk_add_f32 v[126:127], v[126:127], v[188:189]
		v_pk_add_f32 v[188:189], v[190:191], v[192:193]
		v_pk_add_f32 v[190:191], v[194:195], v[196:197]
		v_pk_add_f32 v[192:193], v[198:199], v[200:201]
		v_pk_add_f32 v[126:127], v[126:127], v[188:189]
		v_pk_add_f32 v[188:189], v[190:191], v[192:193]
		v_pk_add_f32 v[190:191], v[126:127], v[188:189]
		v_mov_b32_e32 v126, v187
		v_mov_b32_e32 v127, v191
		v_mov_b32_e32 v188, v186
		v_mov_b32_e32 v189, v190
		v_pk_add_f32 v[186:187], v[188:189], v[126:127]
		v_mov_b32_e32 v126, v187
		v_mov_b32_e32 v127, v187
		v_cvt_pk_bf16_f32 v188, v218, v220
		v_cvt_pk_bf16_f32 v189, v4, v222
		v_permlane32_swap_b32_e32 v126, v127
		v_add_f32_e32 v193, v126, v127
		v_mov_b32_e32 v13, v8
		v_pk_add_f32 v[8:9], v[12:13], v[28:29] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v12, v8
		v_exp_f32_e32 v13, v9
		v_cvt_pk_bf16_f32 v190, v26, v224
		v_mov_b32_e32 v192, v186
		v_mov_b64_e32 v[8:9], v[24:25]
		v_pk_fma_f32 v[24:25], v[8:9], v[12:13], v[192:193]
		v_cvt_pk_bf16_f32 v191, v30, v226
		v_cvt_pk_bf16_f32 v192, v128, v228
		v_cvt_pk_bf16_f32 v193, v130, v230
		v_cvt_pk_bf16_f32 v194, v132, v232
		v_cvt_pk_bf16_f32 v195, v134, v234
		v_cvt_pk_bf16_f32 v196, v136, v236
		v_cvt_pk_bf16_f32 v197, v138, v238
		v_cvt_pk_bf16_f32 v198, v140, v240
		v_cvt_pk_bf16_f32 v199, v142, v242
		v_cvt_pk_bf16_f32 v200, v144, v244
		v_cvt_pk_bf16_f32 v201, v146, v246
		v_cvt_pk_bf16_f32 v202, v148, v248
		v_cvt_pk_bf16_f32 v203, v150, v250
		v_cvt_pk_bf16_f32 v204, v219, v221
		v_pk_mul_f32 v[32:33], v[32:33], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[34:35], v[34:35], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[36:37], v[36:37], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[38:39], v[38:39], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[40:41], v[40:41], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[42:43], v[42:43], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[44:45], v[44:45], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[46:47], v[46:47], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[48:49], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[50:51], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[52:53], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[54:55], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[56:57], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[58:59], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[60:61], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[62:63], v[12:13] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[64:65], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[66:67], v[66:67], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[68:69], v[68:69], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[70:71], v[70:71], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[72:73], v[72:73], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[74:75], v[74:75], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[76:77], v[76:77], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[78:79], v[78:79], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[80:81], v[80:81], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[82:83], v[82:83], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[84:85], v[84:85], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[86:87], v[86:87], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[88:89], v[88:89], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[90:91], v[90:91], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[92:93], v[92:93], v[12:13] op_sel:[0,1]
		v_pk_mul_f32 v[94:95], v[94:95], v[12:13] op_sel:[0,1]
		v_cvt_pk_bf16_f32 v205, v5, v223
		v_cvt_pk_bf16_f32 v206, v27, v225
		v_cvt_pk_bf16_f32 v207, v31, v227
		v_cvt_pk_bf16_f32 v208, v129, v229
		v_cvt_pk_bf16_f32 v209, v131, v231
		v_cvt_pk_bf16_f32 v210, v133, v233
		v_cvt_pk_bf16_f32 v211, v135, v235
		v_cvt_pk_bf16_f32 v128, v137, v237
		v_cvt_pk_bf16_f32 v129, v139, v239
		v_cvt_pk_bf16_f32 v130, v141, v241
		v_cvt_pk_bf16_f32 v131, v143, v243
		v_cvt_pk_bf16_f32 v132, v145, v245
		v_cvt_pk_bf16_f32 v133, v147, v247
		v_cvt_pk_bf16_f32 v134, v149, v249
		v_cvt_pk_bf16_f32 v135, v151, v251
		v_cvt_pk_bf16_f32 v136, v182, v184
		v_cvt_pk_bf16_f32 v137, v96, v98
		v_cvt_pk_bf16_f32 v138, v100, v102
		v_cvt_pk_bf16_f32 v139, v104, v106
		v_cvt_pk_bf16_f32 v140, v108, v110
		v_cvt_pk_bf16_f32 v141, v112, v114
		v_cvt_pk_bf16_f32 v142, v116, v118
		v_cvt_pk_bf16_f32 v143, v120, v122
		v_cvt_pk_bf16_f32 v144, v124, v152
		v_cvt_pk_bf16_f32 v145, v154, v156
		v_cvt_pk_bf16_f32 v146, v158, v160
		v_cvt_pk_bf16_f32 v147, v162, v164
		v_cvt_pk_bf16_f32 v148, v166, v168
		v_cvt_pk_bf16_f32 v149, v170, v172
		v_cvt_pk_bf16_f32 v150, v174, v176
		v_cvt_pk_bf16_f32 v151, v178, v180
		v_cvt_pk_bf16_f32 v212, v183, v185
		v_cvt_pk_bf16_f32 v213, v97, v99
		v_cvt_pk_bf16_f32 v214, v101, v103
		v_cvt_pk_bf16_f32 v215, v105, v107
		v_cvt_pk_bf16_f32 v96, v109, v111
		v_cvt_pk_bf16_f32 v97, v113, v115
		v_cvt_pk_bf16_f32 v98, v117, v119
		v_cvt_pk_bf16_f32 v99, v121, v123
		v_cvt_pk_bf16_f32 v100, v125, v153
		v_cvt_pk_bf16_f32 v101, v155, v157
		v_cvt_pk_bf16_f32 v102, v159, v161
		v_cvt_pk_bf16_f32 v103, v163, v165
		v_cvt_pk_bf16_f32 v104, v167, v169
		v_cvt_pk_bf16_f32 v105, v171, v173
		v_cvt_pk_bf16_f32 v106, v175, v177
		v_cvt_pk_bf16_f32 v107, v179, v181
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_mfma_f32_32x32x16_bf16 v[32:47], a[84:87], v[188:191], v[32:47]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[48:63], a[116:119], v[188:191], v[48:63]
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_mfma_f32_32x32x16_bf16 v[32:47], a[88:91], v[192:195], v[32:47]
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_mfma_f32_32x32x16_bf16 v[48:63], a[120:123], v[192:195], v[48:63]
		v_permlane32_swap_b32_e32 v208, v210
		v_permlane32_swap_b32_e32 v209, v211
		v_mfma_f32_32x32x16_bf16 v[32:47], a[92:95], v[196:199], v[32:47]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[48:63], a[124:127], v[196:199], v[48:63]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[32:47], a[96:99], v[200:203], v[32:47]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[48:63], a[128:131], v[200:203], v[48:63]
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_mfma_f32_32x32x16_bf16 v[80:95], a[116:119], v[136:139], v[80:95]
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_mfma_f32_32x32x16_bf16 v[64:79], a[84:87], v[136:139], v[64:79]
		v_permlane32_swap_b32_e32 v148, v150
		v_permlane32_swap_b32_e32 v149, v151
		v_mfma_f32_32x32x16_bf16 v[80:95], a[120:123], v[140:143], v[80:95]
		v_permlane32_swap_b32_e32 v212, v214
		v_permlane32_swap_b32_e32 v213, v215
		v_mfma_f32_32x32x16_bf16 v[64:79], a[88:91], v[140:143], v[64:79]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[80:95], a[124:127], v[144:147], v[80:95]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[64:79], a[92:95], v[144:147], v[64:79]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[80:95], a[128:131], v[148:151], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[96:99], v[148:151], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[100:103], v[204:207], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[132:135], v[204:207], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[132:135], v[212:215], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[100:103], v[212:215], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[104:107], v[208:211], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[136:139], v[208:211], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[136:139], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[104:107], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[108:111], v[128:131], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[140:143], v[128:131], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[140:143], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[108:111], v[100:103], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[112:115], v[132:135], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[144:147], v[132:135], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[104:107], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[112:115], v[104:107], v[64:79]
		v_mov_b32_e32 v5, v28
		v_mov_b32_e32 v8, v29
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_3
.L_attn_fwd_persistent.loop_exit_3:
		s_mul_i32 s21, s21, 0x80
		v_accvgpr_read_b32 v4, a6
		s_nop 0
		v_readfirstlane_b32 s25, v4
		v_accvgpr_read_b32 v4, a15
		s_nop 0
		v_add_u32_e32 v4, s25, v4
		v_add_u32_e32 v4, s1, v4
		v_accvgpr_read_b32 v7, a6
		s_nop 0
		v_readfirstlane_b32 s25, v7
		v_accvgpr_read_b32 v7, a16
		s_nop 0
		v_add_u32_e32 v7, s25, v7
		v_add_u32_e32 v7, s1, v7
		v_xor_b32_e32 v9, 1, v6
		v_accvgpr_write_b32 a15, v9
		v_xor_b32_e32 v9, 2, v6
		v_accvgpr_write_b32 a16, v9
		v_xor_b32_e32 v9, 3, v6
		v_accvgpr_write_b32 a64, v9
		v_xor_b32_e32 v9, 8, v6
		v_accvgpr_write_b32 a65, v9
		v_xor_b32_e32 v9, 9, v6
		v_accvgpr_write_b32 a66, v9
		v_xor_b32_e32 v9, 10, v6
		v_accvgpr_write_b32 a67, v9
		v_xor_b32_e32 v9, 11, v6
		v_accvgpr_write_b32 a68, v9
		v_xor_b32_e32 v9, 16, v6
		v_accvgpr_write_b32 a69, v9
		v_xor_b32_e32 v9, 17, v6
		v_accvgpr_write_b32 a70, v9
		v_xor_b32_e32 v9, 18, v6
		v_accvgpr_write_b32 a71, v9
		v_xor_b32_e32 v9, 19, v6
		v_accvgpr_write_b32 a72, v9
		v_xor_b32_e32 v9, 24, v6
		v_accvgpr_write_b32 a73, v9
		v_xor_b32_e32 v9, 25, v6
		v_accvgpr_write_b32 a74, v9
		v_xor_b32_e32 v9, 26, v6
		v_accvgpr_write_b32 a75, v9
		v_xor_b32_e32 v9, 27, v6
		v_accvgpr_write_b32 a76, v9
		v_xor_b32_e32 v9, 32, v6
		v_accvgpr_write_b32 a77, v9
		v_xor_b32_e32 v9, 33, v6
		v_accvgpr_write_b32 a78, v9
		v_xor_b32_e32 v9, 34, v6
		v_accvgpr_write_b32 a79, v9
		v_xor_b32_e32 v9, 35, v6
		v_accvgpr_write_b32 a80, v9
		v_xor_b32_e32 v9, 40, v6
		v_accvgpr_write_b32 a81, v9
		v_xor_b32_e32 v9, 41, v6
		v_accvgpr_write_b32 a82, v9
		v_xor_b32_e32 v9, 42, v6
		v_accvgpr_write_b32 a83, v9
		v_xor_b32_e32 v9, 43, v6
		v_accvgpr_write_b32 a84, v9
		v_xor_b32_e32 v9, 48, v6
		v_accvgpr_write_b32 a85, v9
		v_xor_b32_e32 v9, 49, v6
		v_accvgpr_write_b32 a86, v9
		v_xor_b32_e32 v9, 50, v6
		v_accvgpr_write_b32 a87, v9
		v_xor_b32_e32 v9, 51, v6
		v_accvgpr_write_b32 a88, v9
		v_xor_b32_e32 v9, 56, v6
		v_accvgpr_write_b32 a89, v9
		v_xor_b32_e32 v9, 57, v6
		v_accvgpr_write_b32 a90, v9
		v_xor_b32_e32 v9, 58, v6
		v_accvgpr_write_b32 a91, v9
		v_xor_b32_e32 v9, 59, v6
		v_accvgpr_write_b32 a92, v9
		v_xor_b32_e32 v9, 64, v6
		v_accvgpr_write_b32 a93, v9
		v_xor_b32_e32 v9, 0x41, v6
		v_accvgpr_write_b32 a94, v9
		v_xor_b32_e32 v9, 0x42, v6
		v_accvgpr_write_b32 a95, v9
		v_xor_b32_e32 v9, 0x43, v6
		v_accvgpr_write_b32 a96, v9
		v_xor_b32_e32 v9, 0x48, v6
		v_accvgpr_write_b32 a97, v9
		v_xor_b32_e32 v9, 0x49, v6
		v_accvgpr_write_b32 a98, v9
		v_xor_b32_e32 v9, 0x4a, v6
		v_accvgpr_write_b32 a99, v9
		v_xor_b32_e32 v9, 0x4b, v6
		v_accvgpr_write_b32 a100, v9
		v_xor_b32_e32 v9, 0x50, v6
		v_accvgpr_write_b32 a101, v9
		v_xor_b32_e32 v9, 0x51, v6
		v_accvgpr_write_b32 a102, v9
		v_xor_b32_e32 v9, 0x52, v6
		v_accvgpr_write_b32 a103, v9
		v_xor_b32_e32 v9, 0x53, v6
		v_accvgpr_write_b32 a104, v9
		v_xor_b32_e32 v9, 0x58, v6
		v_accvgpr_write_b32 a105, v9
		v_xor_b32_e32 v9, 0x59, v6
		v_accvgpr_write_b32 a106, v9
		v_xor_b32_e32 v9, 0x5a, v6
		v_accvgpr_write_b32 a107, v9
		v_xor_b32_e32 v9, 0x5b, v6
		v_accvgpr_write_b32 a108, v9
		v_xor_b32_e32 v9, 0x60, v6
		v_accvgpr_write_b32 a109, v9
		v_xor_b32_e32 v9, 0x61, v6
		v_accvgpr_write_b32 a110, v9
		v_xor_b32_e32 v9, 0x62, v6
		v_accvgpr_write_b32 a111, v9
		v_xor_b32_e32 v9, 0x63, v6
		v_accvgpr_write_b32 a112, v9
		v_xor_b32_e32 v9, 0x68, v6
		v_accvgpr_write_b32 a113, v9
		v_xor_b32_e32 v9, 0x69, v6
		v_accvgpr_write_b32 a114, v9
		v_xor_b32_e32 v9, 0x6a, v6
		v_accvgpr_write_b32 a115, v9
		v_xor_b32_e32 v9, 0x6b, v6
		v_accvgpr_write_b32 a116, v9
		v_xor_b32_e32 v9, 0x70, v6
		v_accvgpr_write_b32 a117, v9
		v_xor_b32_e32 v9, 0x71, v6
		v_accvgpr_write_b32 a118, v9
		v_xor_b32_e32 v9, 0x72, v6
		v_accvgpr_write_b32 a119, v9
		v_xor_b32_e32 v9, 0x73, v6
		v_accvgpr_write_b32 a120, v9
		v_xor_b32_e32 v9, 0x78, v6
		v_accvgpr_write_b32 a121, v9
		v_xor_b32_e32 v9, 0x79, v6
		v_accvgpr_write_b32 a122, v9
		v_xor_b32_e32 v9, 0x7a, v6
		v_accvgpr_write_b32 a123, v9
		v_xor_b32_e32 v9, 0x7b, v6
		v_accvgpr_write_b32 a124, v9
		v_mov_b32_e32 v9, 0xff800000
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
		v_accvgpr_read_b32 v11, a62
		v_add_u32_e32 v11, s25, v11
		ds_read_b128 v[28:31], v11
		ds_read_b128 a[128:131], v11 offset:32
		ds_read_b128 a[132:135], v11 offset:64
		ds_read_b128 a[136:139], v11 offset:96
		ds_read_b128 a[140:143], v11 offset:256
		ds_read_b128 a[144:147], v11 offset:288
		ds_read_b128 a[148:151], v11 offset:320
		ds_read_b128 a[152:155], v11 offset:352
		ds_read_b128 a[156:159], v11 offset:128
		ds_read_b128 a[160:163], v11 offset:160
		ds_read_b128 a[164:167], v11 offset:192
		ds_read_b128 a[168:171], v11 offset:224
		ds_read_b128 v[96:99], v11 offset:384
		ds_read_b128 a[172:175], v11 offset:416
		ds_read_b128 a[176:179], v11 offset:448
		ds_read_b128 a[180:183], v11 offset:480
		s_mul_i32 s25, 0x4400, s37
		v_accvgpr_read_b32 v11, a63
		v_add_u32_e32 v11, s25, v11
		ds_read_b64_tr_b16 a[184:185], v11 offset:33264
		ds_read_b64_tr_b16 a[186:187], v11 offset:37616
		ds_read_b64_tr_b16 a[188:189], v11 offset:33392
		ds_read_b64_tr_b16 a[190:191], v11 offset:37744
		ds_read_b64_tr_b16 a[192:193], v11 offset:33520
		ds_read_b64_tr_b16 a[194:195], v11 offset:37872
		ds_read_b64_tr_b16 a[196:197], v11 offset:33648
		ds_read_b64_tr_b16 a[198:199], v11 offset:38000
		ds_read_b64_tr_b16 a[200:201], v11 offset:33776
		ds_read_b64_tr_b16 a[202:203], v11 offset:38128
		ds_read_b64_tr_b16 a[204:205], v11 offset:33904
		ds_read_b64_tr_b16 a[206:207], v11 offset:38256
		ds_read_b64_tr_b16 a[208:209], v11 offset:34032
		ds_read_b64_tr_b16 a[210:211], v11 offset:38384
		ds_read_b64_tr_b16 a[212:213], v11 offset:34160
		ds_read_b64_tr_b16 a[214:215], v11 offset:38512
		ds_read_b64_tr_b16 a[216:217], v11 offset:33328
		ds_read_b64_tr_b16 a[218:219], v11 offset:37680
		ds_read_b64_tr_b16 a[220:221], v11 offset:33456
		ds_read_b64_tr_b16 a[222:223], v11 offset:37808
		ds_read_b64_tr_b16 a[224:225], v11 offset:33584
		ds_read_b64_tr_b16 a[226:227], v11 offset:37936
		ds_read_b64_tr_b16 a[228:229], v11 offset:33712
		ds_read_b64_tr_b16 a[230:231], v11 offset:38064
		ds_read_b64_tr_b16 a[232:233], v11 offset:33840
		ds_read_b64_tr_b16 a[234:235], v11 offset:38192
		ds_read_b64_tr_b16 a[236:237], v11 offset:33968
		ds_read_b64_tr_b16 a[238:239], v11 offset:38320
		ds_read_b64_tr_b16 a[240:241], v11 offset:34096
		ds_read_b64_tr_b16 a[242:243], v11 offset:38448
		ds_read_b64_tr_b16 a[244:245], v11 offset:34224
		ds_read_b64_tr_b16 a[246:247], v11 offset:38576
		s_cmp_lt_i32 s1, s18
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_4
		v_accvgpr_read_b32 v11, a18
		v_add_u32_e32 v11, s1, v11
		v_cmp_lt_i32_e64 s[52:53], v11, s20
		v_accvgpr_read_b32 v11, a19
		v_add_u32_e32 v11, s1, v11
		v_cmp_lt_i32_e64 s[54:55], v11, s20
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s25, s15, s41
		s_lshl_b32 s25, s25, 1
		s_add_i32 s37, s23, s25
		v_add3_u32 v11, s37, v17, v19
		v_add3_u32 v11, v11, v21, v10
		v_cndmask_b32_e64 v11, v22, v11, s[52:53]
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
		v_accvgpr_read_b32 v12, a56
		v_add_u32_e32 v12, s1, v12
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[56:57], v12, s20
		s_add_i32 s37, s45, s25
		v_add3_u32 v11, s37, v17, v19
		v_add3_u32 v11, v11, v21, v10
		v_cndmask_b32_e64 v11, v22, v11, s[56:57]
		s_add_u32 s56, s58, 0x1040
		s_addc_u32 s57, s59, 0
		s_add_u32 s56, s56, s60
		s_addc_u32 s57, s57, s61
		s_add_u32 s62, s56, 0
		s_addc_u32 s63, s57, 0
		s_mov_b32 m0, s62
		v_accvgpr_read_b32 v12, a57
		v_add_u32_e32 v12, s1, v12
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[56:57], v12, s20
		s_add_i32 s37, s46, s25
		v_add3_u32 v11, s37, v17, v19
		v_add3_u32 v11, v11, v21, v10
		v_cndmask_b32_e64 v11, v22, v11, s[56:57]
		s_add_u32 s56, s58, 0x2080
		s_addc_u32 s57, s59, 0
		s_add_u32 s56, s56, s60
		s_addc_u32 s57, s57, s61
		s_add_u32 s62, s56, 0
		s_addc_u32 s63, s57, 0
		s_mov_b32 m0, s62
		v_accvgpr_read_b32 v12, a58
		v_add_u32_e32 v12, s1, v12
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[56:57], v12, s20
		s_add_i32 s25, s26, s25
		v_add3_u32 v11, s25, v17, v19
		v_add3_u32 v11, v11, v21, v10
		v_cndmask_b32_e64 v11, v22, v11, s[56:57]
		s_add_u32 s56, s58, 0x30c0
		s_addc_u32 s57, s59, 0
		s_add_u32 s56, s56, s60
		s_addc_u32 s57, s57, s61
		s_add_u32 s58, s56, 0
		s_addc_u32 s59, s57, 0
		s_mov_b32 m0, s58
		v_accvgpr_read_b32 v12, a59
		v_add_u32_e32 v12, s1, v12
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		s_mul_i32 s25, s17, s41
		s_lshl_b32 s25, s25, 1
		s_add_i32 s37, s39, s25
		v_add3_u32 v11, s37, v1, v14
		v_add3_u32 v11, v11, v23, v10
		v_cndmask_b32_e64 v11, v22, v11, s[54:55]
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
		v_accvgpr_read_b32 v13, a60
		v_add_u32_e32 v13, s1, v13
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[50:51], v12, s20
		s_add_i32 s37, s47, s25
		v_add3_u32 v11, s37, v1, v14
		v_add3_u32 v11, v11, v23, v10
		v_cndmask_b32_e64 v11, v22, v11, s[50:51]
		s_add_u32 s50, s56, 0x92f0
		s_addc_u32 s51, s57, 0
		s_add_u32 s50, s50, s58
		s_addc_u32 s51, s51, s59
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		v_accvgpr_read_b32 v12, a61
		v_add_u32_e32 v12, s1, v12
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[50:51], v13, s20
		s_add_i32 s37, s48, s25
		v_add3_u32 v11, s37, v1, v14
		v_add3_u32 v11, v11, v23, v10
		s_add_u32 s52, s56, 0xa3f0
		s_addc_u32 s53, s57, 0
		s_add_u32 s52, s52, s58
		s_addc_u32 s53, s53, s59
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v11, v22, v11, s[50:51]
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		s_add_i32 s25, s24, s25
		v_add3_u32 v11, s25, v1, v14
		v_cmp_lt_i32_e64 vcc, v12, s20
		v_add3_u32 v11, v11, v23, v10
		s_add_u32 s50, s56, 0xb4f0
		s_addc_u32 s51, s57, 0
		v_cndmask_b32_e32 v11, v22, v11, vcc
		s_add_u32 s50, s50, s58
		s_addc_u32 s51, s51, s59
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		s_nop 0
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
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
		v_mfma_f32_32x32x16_bf16 v[96:111], a[132:135], a[44:47], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[148:151], a[44:47], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[164:167], a[44:47], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[136:139], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[152:155], a[32:35], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[168:171], a[32:35], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[180:183], a[48:51], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[136:139], a[48:51], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[152:155], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[168:171], a[48:51], v[208:223]
		v_add_u32_e32 v11, s41, v6
		v_accvgpr_read_b32 v12, a15
		v_add_u32_e32 v12, s41, v12
		v_accvgpr_read_b32 v13, a16
		v_add_u32_e32 v13, s41, v13
		v_accvgpr_read_b32 v15, a64
		v_add_u32_e32 v15, s41, v15
		v_accvgpr_read_b32 v16, a67
		v_add_u32_e32 v16, s41, v16
		v_accvgpr_read_b32 v18, a68
		v_add_u32_e32 v18, s41, v18
		v_accvgpr_read_b32 v20, a71
		v_add_u32_e32 v20, s41, v20
		v_accvgpr_read_b32 v26, a72
		v_add_u32_e32 v26, s41, v26
		v_accvgpr_read_b32 v27, a75
		v_add_u32_e32 v27, s41, v27
		v_accvgpr_read_b32 v28, a76
		v_add_u32_e32 v28, s41, v28
		v_accvgpr_read_b32 v29, a79
		v_add_u32_e32 v29, s41, v29
		v_accvgpr_read_b32 v30, a80
		v_add_u32_e32 v30, s41, v30
		v_accvgpr_read_b32 v31, a83
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a125, v31
		v_accvgpr_read_b32 v31, a84
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a126, v31
		v_accvgpr_read_b32 v31, a87
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a127, v31
		v_accvgpr_read_b32 v31, a88
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a128, v31
		v_accvgpr_read_b32 v31, a91
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a129, v31
		v_accvgpr_read_b32 v31, a92
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a130, v31
		v_accvgpr_read_b32 v31, a95
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a131, v31
		v_accvgpr_read_b32 v31, a96
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a132, v31
		v_accvgpr_read_b32 v31, a99
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a133, v31
		v_accvgpr_read_b32 v31, a100
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a134, v31
		v_accvgpr_read_b32 v31, a103
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a135, v31
		v_accvgpr_read_b32 v31, a104
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a136, v31
		v_accvgpr_read_b32 v31, a107
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a137, v31
		v_accvgpr_read_b32 v31, a108
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a138, v31
		v_accvgpr_read_b32 v31, a111
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a139, v31
		v_accvgpr_read_b32 v31, a112
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a140, v31
		v_accvgpr_read_b32 v31, a115
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a141, v31
		v_accvgpr_read_b32 v31, a116
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a142, v31
		v_accvgpr_read_b32 v31, a119
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a143, v31
		v_accvgpr_read_b32 v31, a120
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a144, v31
		v_accvgpr_read_b32 v31, a123
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a145, v31
		v_accvgpr_read_b32 v31, a124
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_write_b32 a146, v31
		v_cmp_ge_i32_e64 s[50:51], v4, v11
		v_cmp_ge_i32_e64 s[52:53], v4, v12
		v_cmp_ge_i32_e64 s[54:55], v4, v13
		v_cmp_ge_i32_e64 vcc, v4, v15
		v_accvgpr_read_b32 v31, a65
		v_add_u32_e32 v31, s41, v31
		v_accvgpr_read_b32 v224, a66
		v_add_u32_e32 v224, s41, v224
		v_cndmask_b32_e32 v227, v9, v115, vcc
		v_cmp_ge_i32_e64 s[56:57], v4, v31
		v_cmp_ge_i32_e64 s[58:59], v4, v224
		v_cmp_ge_i32_e64 s[60:61], v4, v16
		v_cmp_ge_i32_e64 vcc, v4, v18
		v_accvgpr_read_b32 v115, a69
		v_add_u32_e32 v115, s41, v115
		v_accvgpr_read_b32 v225, a70
		v_add_u32_e32 v225, s41, v225
		v_cndmask_b32_e32 v229, v9, v119, vcc
		v_cmp_ge_i32_e64 s[62:63], v4, v115
		v_cmp_ge_i32_e64 s[64:65], v4, v225
		v_cmp_ge_i32_e64 s[66:67], v4, v20
		v_cmp_ge_i32_e64 vcc, v4, v26
		v_accvgpr_read_b32 v119, a73
		v_add_u32_e32 v119, s41, v119
		v_accvgpr_read_b32 v226, a74
		v_add_u32_e32 v230, s41, v226
		v_cndmask_b32_e32 v233, v9, v123, vcc
		v_cmp_ge_i32_e64 s[68:69], v4, v119
		v_cmp_ge_i32_e64 s[70:71], v4, v230
		v_cmp_ge_i32_e64 s[72:73], v4, v27
		v_cmp_ge_i32_e64 vcc, v4, v28
		v_accvgpr_read_b32 v123, a77
		v_add_u32_e32 v123, s41, v123
		v_accvgpr_read_b32 v226, a78
		v_add_u32_e32 v231, s41, v226
		v_cndmask_b32_e32 v235, v9, v127, vcc
		v_cmp_ge_i32_e64 s[74:75], v4, v123
		v_cmp_ge_i32_e64 s[76:77], v4, v231
		v_cmp_ge_i32_e64 s[78:79], v4, v29
		v_cmp_ge_i32_e64 vcc, v4, v30
		v_accvgpr_read_b32 v127, a81
		v_add_u32_e32 v127, s41, v127
		v_accvgpr_read_b32 v226, a82
		v_add_u32_e32 v226, s41, v226
		v_accvgpr_write_b32 a147, v226
		v_cndmask_b32_e32 v237, v9, v131, vcc
		v_cmp_ge_i32_e64 s[80:81], v4, v127
		v_accvgpr_read_b32 v131, a147
		v_cmp_ge_i32_e64 s[82:83], v4, v131
		v_accvgpr_read_b32 v131, a125
		v_cmp_ge_i32_e64 s[84:85], v4, v131
		v_accvgpr_read_b32 v131, a126
		v_cmp_ge_i32_e64 vcc, v4, v131
		v_accvgpr_read_b32 v131, a85
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a148, v131
		v_accvgpr_read_b32 v131, a86
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a149, v131
		v_cndmask_b32_e32 v239, v9, v135, vcc
		v_accvgpr_read_b32 v131, a148
		v_cmp_ge_i32_e64 s[86:87], v4, v131
		v_accvgpr_read_b32 v131, a128
		v_cmp_ge_i32_e64 vcc, v4, v131
		v_accvgpr_read_b32 v131, a89
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a150, v131
		v_accvgpr_read_b32 v131, a90
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a151, v131
		v_cndmask_b32_e32 v241, v9, v139, vcc
		v_accvgpr_read_b32 v131, a130
		v_cmp_ge_i32_e64 vcc, v4, v131
		v_accvgpr_read_b32 v131, a93
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a152, v131
		v_accvgpr_read_b32 v131, a94
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a153, v131
		v_cndmask_b32_e32 v243, v9, v143, vcc
		v_accvgpr_read_b32 v131, a132
		v_cmp_ge_i32_e64 vcc, v4, v131
		v_accvgpr_read_b32 v131, a97
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a154, v131
		v_accvgpr_read_b32 v131, a98
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a155, v131
		v_cndmask_b32_e32 v245, v9, v147, vcc
		v_accvgpr_read_b32 v131, a134
		v_cmp_ge_i32_e64 vcc, v4, v131
		v_accvgpr_read_b32 v131, a101
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a156, v131
		v_accvgpr_read_b32 v131, a102
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a157, v131
		v_cndmask_b32_e32 v247, v9, v151, vcc
		v_accvgpr_read_b32 v131, a136
		v_cmp_ge_i32_e64 vcc, v4, v131
		v_accvgpr_read_b32 v131, a105
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a158, v131
		v_accvgpr_read_b32 v131, a106
		v_add_u32_e32 v131, s41, v131
		v_accvgpr_write_b32 a159, v131
		v_cndmask_b32_e32 v249, v9, v155, vcc
		v_accvgpr_read_b32 v131, a138
		v_cmp_ge_i32_e64 vcc, v4, v131
		v_accvgpr_read_b32 v131, a149
		v_cmp_ge_i32_e64 s[88:89], v4, v131
		v_cndmask_b32_e64 v250, v9, v112, s[50:51]
		v_accvgpr_read_b32 v112, a127
		v_cmp_ge_i32_e64 s[50:51], v4, v112
		s_nop 1
		v_mov_b32_e32 v252, s50
		v_mov_b32_e32 v253, s51
		v_accvgpr_write_b32 a160, v252
		v_accvgpr_write_b32 a161, v253
		v_accvgpr_read_b32 v112, a150
		v_cmp_ge_i32_e64 s[50:51], v4, v112
		s_nop 1
		v_mov_b32_e32 v252, s50
		v_mov_b32_e32 v253, s51
		v_accvgpr_write_b32 a162, v252
		v_accvgpr_write_b32 a163, v253
		v_accvgpr_read_b32 v112, a151
		v_cmp_ge_i32_e64 s[50:51], v4, v112
		s_nop 1
		v_mov_b32_e32 v252, s50
		v_mov_b32_e32 v253, s51
		v_accvgpr_write_b32 a164, v252
		v_accvgpr_write_b32 a165, v253
		v_accvgpr_read_b32 v112, a129
		v_cmp_ge_i32_e64 s[50:51], v4, v112
		s_nop 1
		v_mov_b32_e32 v252, s50
		v_mov_b32_e32 v253, s51
		v_accvgpr_write_b32 a166, v252
		v_accvgpr_write_b32 a167, v253
		v_accvgpr_read_b32 v112, a152
		v_cmp_ge_i32_e64 s[50:51], v4, v112
		s_nop 1
		v_mov_b32_e32 v252, s50
		v_mov_b32_e32 v253, s51
		v_accvgpr_write_b32 a168, v252
		v_accvgpr_write_b32 a169, v253
		v_accvgpr_read_b32 v112, a153
		v_cmp_ge_i32_e64 s[50:51], v4, v112
		s_nop 1
		v_mov_b32_e32 v252, s50
		v_mov_b32_e32 v253, s51
		v_accvgpr_write_b32 a170, v252
		v_accvgpr_write_b32 a171, v253
		v_accvgpr_read_b32 v112, a131
		v_cmp_ge_i32_e64 s[50:51], v4, v112
		s_nop 1
		v_mov_b32_e32 v252, s50
		v_mov_b32_e32 v253, s51
		v_accvgpr_write_b32 a172, v252
		v_accvgpr_write_b32 a173, v253
		v_accvgpr_read_b32 v112, a154
		v_cmp_ge_i32_e64 s[50:51], v4, v112
		s_nop 1
		v_mov_b32_e32 v252, s50
		v_mov_b32_e32 v253, s51
		v_accvgpr_write_b32 a174, v252
		v_accvgpr_write_b32 a175, v253
		v_accvgpr_read_b32 v112, a155
		v_cmp_ge_i32_e64 s[50:51], v4, v112
		s_nop 1
		v_mov_b32_e32 v252, s50
		v_mov_b32_e32 v253, s51
		v_accvgpr_write_b32 a176, v252
		v_accvgpr_write_b32 a177, v253
		v_accvgpr_read_b32 v112, a133
		v_cmp_ge_i32_e64 s[50:51], v4, v112
		s_nop 1
		v_mov_b32_e32 v252, s50
		v_mov_b32_e32 v253, s51
		v_accvgpr_write_b32 a178, v252
		v_accvgpr_write_b32 a179, v253
		v_accvgpr_read_b32 v112, a156
		v_cmp_ge_i32_e64 s[50:51], v4, v112
		s_nop 1
		v_mov_b32_e32 v252, s50
		v_mov_b32_e32 v253, s51
		v_accvgpr_write_b32 a180, v252
		v_accvgpr_write_b32 a181, v253
		v_accvgpr_read_b32 v112, a157
		v_cmp_ge_i32_e64 s[50:51], v4, v112
		v_accvgpr_read_b32 v112, a135
		v_cmp_ge_i32_e64 s[90:91], v4, v112
		v_accvgpr_read_b32 v112, a158
		v_cmp_ge_i32_e64 s[92:93], v4, v112
		v_accvgpr_read_b32 v112, a159
		v_cmp_ge_i32_e64 s[94:95], v4, v112
		v_accvgpr_read_b32 v112, a137
		v_cmp_ge_i32_e64 s[96:97], v4, v112
		v_cndmask_b32_e32 v253, v9, v159, vcc
		v_cndmask_b32_e64 v255, v9, v157, s[94:95]
		v_cndmask_b32_e64 v252, v9, v158, s[96:97]
		v_accvgpr_read_b32 v112, a109
		v_add_u32_e32 v112, s41, v112
		v_accvgpr_read_b32 v131, a110
		v_add_u32_e32 v131, s41, v131
		v_cmp_ge_i32_e64 s[94:95], v4, v112
		v_cmp_ge_i32_e64 s[96:97], v4, v131
		v_accvgpr_read_b32 v135, a139
		v_cmp_ge_i32_e64 s[98:99], v4, v135
		v_cndmask_b32_e64 v158, v9, v160, s[94:95]
		v_cndmask_b32_e64 v159, v9, v161, s[96:97]
		v_cndmask_b32_e64 v160, v9, v162, s[98:99]
		v_accvgpr_read_b32 v135, a140
		v_cmp_ge_i32_e64 vcc, v4, v135
		v_accvgpr_read_b32 v135, a113
		v_add_u32_e32 v135, s41, v135
		v_accvgpr_read_b32 v139, a114
		v_add_u32_e32 v139, s41, v139
		v_cndmask_b32_e32 v161, v9, v163, vcc
		v_cmp_ge_i32_e64 s[94:95], v4, v135
		v_cmp_ge_i32_e64 s[96:97], v4, v139
		v_accvgpr_read_b32 v143, a141
		v_cmp_ge_i32_e64 s[98:99], v4, v143
		v_cndmask_b32_e64 v162, v9, v164, s[94:95]
		v_cndmask_b32_e64 v163, v9, v165, s[96:97]
		v_cndmask_b32_e64 v164, v9, v166, s[98:99]
		v_accvgpr_read_b32 v143, a142
		v_cmp_ge_i32_e64 vcc, v4, v143
		v_accvgpr_read_b32 v143, a117
		v_add_u32_e32 v143, s41, v143
		v_accvgpr_read_b32 v147, a118
		v_add_u32_e32 v147, s41, v147
		v_cndmask_b32_e32 v165, v9, v167, vcc
		v_cmp_ge_i32_e64 s[94:95], v4, v143
		v_cmp_ge_i32_e64 s[96:97], v4, v147
		v_accvgpr_read_b32 v151, a143
		v_cmp_ge_i32_e64 s[98:99], v4, v151
		v_cndmask_b32_e64 v166, v9, v168, s[94:95]
		v_cndmask_b32_e64 v167, v9, v169, s[96:97]
		v_cndmask_b32_e64 v168, v9, v170, s[98:99]
		v_accvgpr_read_b32 v151, a144
		v_cmp_ge_i32_e64 vcc, v4, v151
		v_accvgpr_read_b32 v151, a121
		v_add_u32_e32 v151, s41, v151
		v_accvgpr_read_b32 v155, a122
		v_add_u32_e32 v155, s41, v155
		v_cndmask_b32_e32 v169, v9, v171, vcc
		v_cmp_ge_i32_e64 s[94:95], v4, v151
		v_cmp_ge_i32_e64 s[96:97], v4, v155
		v_accvgpr_read_b32 v157, a145
		v_cmp_ge_i32_e64 s[98:99], v4, v157
		v_cndmask_b32_e64 v170, v9, v172, s[94:95]
		v_cndmask_b32_e64 v171, v9, v173, s[96:97]
		v_cndmask_b32_e64 v172, v9, v174, s[98:99]
		v_cndmask_b32_e64 v251, v9, v113, s[52:53]
		v_accvgpr_read_b32 v113, a146
		v_cmp_ge_i32_e64 vcc, v4, v113
		v_max3_f32 v113, v158, v159, v160
		v_max3_f32 v157, v162, v163, v164
		v_cndmask_b32_e32 v173, v9, v175, vcc
		v_cmp_ge_i32_e64 s[52:53], v7, v11
		v_cmp_ge_i32_e64 s[94:95], v7, v12
		v_cmp_ge_i32_e64 s[96:97], v7, v13
		v_max3_f32 v11, v166, v167, v168
		v_accvgpr_write_b32 a182, v11
		v_max3_f32 v11, v170, v171, v172
		v_cndmask_b32_e64 v12, v9, v98, s[96:97]
		v_cmp_ge_i32_e64 vcc, v7, v15
		v_cndmask_b32_e64 v226, v9, v114, s[54:55]
		v_cndmask_b32_e64 v174, v9, v116, s[56:57]
		v_cndmask_b32_e32 v13, v9, v99, vcc
		v_cmp_ge_i32_e64 s[54:55], v7, v31
		v_cmp_ge_i32_e64 s[56:57], v7, v224
		v_cmp_ge_i32_e64 s[96:97], v7, v16
		v_cndmask_b32_e64 v98, v9, v100, s[54:55]
		v_cndmask_b32_e64 v99, v9, v101, s[56:57]
		v_cndmask_b32_e64 v100, v9, v102, s[96:97]
		v_cmp_ge_i32_e64 vcc, v7, v18
		v_cndmask_b32_e64 v175, v9, v117, s[58:59]
		v_cndmask_b32_e64 v228, v9, v118, s[60:61]
		v_cndmask_b32_e64 v116, v9, v120, s[62:63]
		v_cndmask_b32_e32 v101, v9, v103, vcc
		v_cmp_ge_i32_e64 s[54:55], v7, v115
		v_cmp_ge_i32_e64 s[56:57], v7, v225
		v_cmp_ge_i32_e64 s[58:59], v7, v20
		v_cndmask_b32_e64 v102, v9, v104, s[54:55]
		v_cndmask_b32_e64 v103, v9, v105, s[56:57]
		v_cndmask_b32_e64 v104, v9, v106, s[58:59]
		v_cmp_ge_i32_e64 vcc, v7, v26
		v_cndmask_b32_e64 v117, v9, v121, s[64:65]
		v_max3_f32 v15, v250, v251, v226
		v_cndmask_b32_e32 v105, v9, v107, vcc
		v_cmp_ge_i32_e64 s[54:55], v7, v119
		v_cmp_ge_i32_e64 s[56:57], v7, v230
		v_cmp_ge_i32_e64 s[58:59], v7, v27
		v_cndmask_b32_e64 v26, v9, v108, s[54:55]
		v_cndmask_b32_e64 v27, v9, v109, s[56:57]
		v_cndmask_b32_e64 v106, v9, v110, s[58:59]
		v_cmp_ge_i32_e64 vcc, v7, v28
		v_cndmask_b32_e64 v232, v9, v122, s[66:67]
		v_cndmask_b32_e64 v108, v9, v124, s[68:69]
		v_cndmask_b32_e32 v107, v9, v111, vcc
		v_cmp_ge_i32_e64 s[54:55], v7, v123
		v_cmp_ge_i32_e64 s[56:57], v7, v231
		v_cmp_ge_i32_e64 s[58:59], v7, v29
		v_cndmask_b32_e64 v28, v9, v192, s[54:55]
		v_cndmask_b32_e64 v29, v9, v193, s[56:57]
		v_cndmask_b32_e64 v110, v9, v194, s[58:59]
		v_cmp_ge_i32_e64 vcc, v7, v30
		v_cndmask_b32_e64 v109, v9, v125, s[70:71]
		v_cndmask_b32_e64 v234, v9, v126, s[72:73]
		v_cndmask_b32_e64 v30, v9, v128, s[74:75]
		v_cndmask_b32_e32 v111, v9, v195, vcc
		v_cmp_ge_i32_e64 s[54:55], v7, v127
		v_accvgpr_read_b32 v16, a147
		v_cmp_ge_i32_e64 s[56:57], v7, v16
		v_accvgpr_read_b32 v16, a125
		v_cmp_ge_i32_e64 s[58:59], v7, v16
		v_cndmask_b32_e64 v114, v9, v196, s[54:55]
		v_cndmask_b32_e64 v115, v9, v197, s[56:57]
		v_cndmask_b32_e64 v118, v9, v198, s[58:59]
		v_accvgpr_read_b32 v16, a126
		v_cmp_ge_i32_e64 vcc, v7, v16
		v_cndmask_b32_e64 v31, v9, v129, s[76:77]
		v_max3_f32 v16, v174, v175, v228
		v_cndmask_b32_e32 v119, v9, v199, vcc
		v_accvgpr_read_b32 v18, a148
		v_cmp_ge_i32_e64 s[54:55], v7, v18
		v_accvgpr_read_b32 v18, a149
		v_cmp_ge_i32_e64 s[56:57], v7, v18
		v_accvgpr_read_b32 v18, a127
		v_cmp_ge_i32_e64 s[58:59], v7, v18
		v_cndmask_b32_e64 v120, v9, v200, s[54:55]
		v_cndmask_b32_e64 v121, v9, v201, s[56:57]
		v_cndmask_b32_e64 v122, v9, v202, s[58:59]
		v_accvgpr_read_b32 v18, a128
		v_cmp_ge_i32_e64 vcc, v7, v18
		v_cndmask_b32_e64 v236, v9, v130, s[78:79]
		v_cndmask_b32_e64 v124, v9, v132, s[80:81]
		v_cndmask_b32_e32 v123, v9, v203, vcc
		v_accvgpr_read_b32 v18, a150
		v_cmp_ge_i32_e64 s[54:55], v7, v18
		v_accvgpr_read_b32 v18, a151
		v_cmp_ge_i32_e64 s[56:57], v7, v18
		v_accvgpr_read_b32 v18, a129
		v_cmp_ge_i32_e64 s[58:59], v7, v18
		v_cndmask_b32_e64 v126, v9, v204, s[54:55]
		v_cndmask_b32_e64 v127, v9, v205, s[56:57]
		v_cndmask_b32_e64 v128, v9, v206, s[58:59]
		v_accvgpr_read_b32 v18, a130
		v_cmp_ge_i32_e64 vcc, v7, v18
		v_cndmask_b32_e64 v125, v9, v133, s[82:83]
		v_cndmask_b32_e64 v238, v9, v134, s[84:85]
		v_cndmask_b32_e32 v129, v9, v207, vcc
		v_accvgpr_read_b32 v18, a152
		v_cmp_ge_i32_e64 s[54:55], v7, v18
		v_accvgpr_read_b32 v18, a132
		v_cmp_ge_i32_e64 vcc, v7, v18
		v_cndmask_b32_e64 v132, v9, v136, s[86:87]
		v_accvgpr_read_b32 v18, a153
		v_cmp_ge_i32_e64 s[56:57], v7, v18
		v_accvgpr_read_b32 v18, a131
		v_cmp_ge_i32_e64 s[58:59], v7, v18
		v_cndmask_b32_e64 v192, v9, v208, s[54:55]
		v_cndmask_b32_e64 v193, v9, v209, s[56:57]
		v_cndmask_b32_e64 v194, v9, v210, s[58:59]
		v_cndmask_b32_e64 v133, v9, v137, s[88:89]
		v_cndmask_b32_e32 v195, v9, v211, vcc
		v_accvgpr_read_b32 v18, a154
		v_cmp_ge_i32_e64 s[54:55], v7, v18
		v_accvgpr_read_b32 v18, a155
		v_cmp_ge_i32_e64 s[56:57], v7, v18
		v_accvgpr_read_b32 v18, a133
		v_cmp_ge_i32_e64 s[58:59], v7, v18
		v_cndmask_b32_e64 v136, v9, v212, s[54:55]
		v_cndmask_b32_e64 v137, v9, v213, s[56:57]
		v_cndmask_b32_e64 v196, v9, v214, s[58:59]
		v_accvgpr_read_b32 v18, a134
		v_cmp_ge_i32_e64 vcc, v7, v18
		v_accvgpr_read_b32 v18, a160
		s_nop 0
		v_readfirstlane_b32 s54, v18
		v_accvgpr_read_b32 v18, a161
		s_nop 0
		v_readfirstlane_b32 s55, v18
		s_nop 1
		v_cndmask_b32_e64 v240, v9, v138, s[54:55]
		v_accvgpr_read_b32 v18, a162
		s_nop 0
		v_readfirstlane_b32 s54, v18
		v_accvgpr_read_b32 v18, a163
		s_nop 0
		v_readfirstlane_b32 s55, v18
		s_nop 1
		v_cndmask_b32_e64 v198, v9, v140, s[54:55]
		v_cndmask_b32_e32 v197, v9, v215, vcc
		v_accvgpr_read_b32 v18, a156
		v_cmp_ge_i32_e64 s[54:55], v7, v18
		v_accvgpr_read_b32 v18, a157
		v_cmp_ge_i32_e64 s[56:57], v7, v18
		v_accvgpr_read_b32 v18, a135
		v_cmp_ge_i32_e64 s[58:59], v7, v18
		v_cndmask_b32_e64 v200, v9, v216, s[54:55]
		v_cndmask_b32_e64 v201, v9, v217, s[56:57]
		v_cndmask_b32_e64 v202, v9, v218, s[58:59]
		v_accvgpr_read_b32 v18, a136
		v_cmp_ge_i32_e64 vcc, v7, v18
		v_accvgpr_read_b32 v18, a164
		s_nop 0
		v_readfirstlane_b32 s54, v18
		v_accvgpr_read_b32 v18, a165
		s_nop 0
		v_readfirstlane_b32 s55, v18
		s_nop 1
		v_cndmask_b32_e64 v199, v9, v141, s[54:55]
		v_accvgpr_read_b32 v18, a166
		s_nop 0
		v_readfirstlane_b32 s54, v18
		v_accvgpr_read_b32 v18, a167
		s_nop 0
		v_readfirstlane_b32 s55, v18
		s_nop 1
		v_cndmask_b32_e64 v242, v9, v142, s[54:55]
		v_cndmask_b32_e32 v203, v9, v219, vcc
		v_accvgpr_read_b32 v18, a158
		v_cmp_ge_i32_e64 s[54:55], v7, v18
		v_accvgpr_read_b32 v18, a159
		v_cmp_ge_i32_e64 s[56:57], v7, v18
		v_accvgpr_read_b32 v18, a137
		v_cmp_ge_i32_e64 s[58:59], v7, v18
		v_cndmask_b32_e64 v140, v9, v220, s[54:55]
		v_cndmask_b32_e64 v141, v9, v221, s[56:57]
		v_cndmask_b32_e64 v204, v9, v222, s[58:59]
		v_accvgpr_read_b32 v18, a138
		v_cmp_ge_i32_e64 vcc, v7, v18
		v_accvgpr_read_b32 v18, a168
		s_nop 0
		v_readfirstlane_b32 s54, v18
		v_accvgpr_read_b32 v18, a169
		s_nop 0
		v_readfirstlane_b32 s55, v18
		s_nop 1
		v_cndmask_b32_e64 v206, v9, v144, s[54:55]
		v_accvgpr_read_b32 v18, a170
		s_nop 0
		v_readfirstlane_b32 s54, v18
		v_accvgpr_read_b32 v18, a171
		s_nop 0
		v_readfirstlane_b32 s55, v18
		s_nop 1
		v_cndmask_b32_e64 v207, v9, v145, s[54:55]
		v_cndmask_b32_e32 v205, v9, v223, vcc
		v_cmp_ge_i32_e64 s[54:55], v7, v112
		v_cmp_ge_i32_e64 s[56:57], v7, v131
		v_accvgpr_read_b32 v18, a139
		v_cmp_ge_i32_e64 s[58:59], v7, v18
		v_cndmask_b32_e64 v130, v9, v176, s[54:55]
		v_cndmask_b32_e64 v131, v9, v177, s[56:57]
		v_cndmask_b32_e64 v144, v9, v178, s[58:59]
		v_accvgpr_read_b32 v18, a140
		v_cmp_ge_i32_e64 vcc, v7, v18
		v_accvgpr_read_b32 v18, a172
		s_nop 0
		v_readfirstlane_b32 s54, v18
		v_accvgpr_read_b32 v18, a173
		s_nop 0
		v_readfirstlane_b32 s55, v18
		s_nop 1
		v_cndmask_b32_e64 v244, v9, v146, s[54:55]
		v_accvgpr_read_b32 v18, a174
		s_nop 0
		v_readfirstlane_b32 s54, v18
		v_accvgpr_read_b32 v18, a175
		s_nop 0
		v_readfirstlane_b32 s55, v18
		s_nop 1
		v_cndmask_b32_e64 v176, v9, v148, s[54:55]
		v_cndmask_b32_e32 v145, v9, v179, vcc
		v_cmp_ge_i32_e64 s[54:55], v7, v135
		v_cmp_ge_i32_e64 s[56:57], v7, v139
		v_accvgpr_read_b32 v18, a141
		v_cmp_ge_i32_e64 s[58:59], v7, v18
		v_cndmask_b32_e64 v134, v9, v180, s[54:55]
		v_cndmask_b32_e64 v135, v9, v181, s[56:57]
		v_cndmask_b32_e64 v138, v9, v182, s[58:59]
		v_accvgpr_read_b32 v18, a142
		v_cmp_ge_i32_e64 vcc, v7, v18
		v_accvgpr_read_b32 v18, a176
		s_nop 0
		v_readfirstlane_b32 s54, v18
		v_accvgpr_read_b32 v18, a177
		s_nop 0
		v_readfirstlane_b32 s55, v18
		s_nop 1
		v_cndmask_b32_e64 v177, v9, v149, s[54:55]
		v_accvgpr_read_b32 v18, a178
		s_nop 0
		v_readfirstlane_b32 s54, v18
		v_accvgpr_read_b32 v18, a179
		s_nop 0
		v_readfirstlane_b32 s55, v18
		s_nop 1
		v_cndmask_b32_e64 v246, v9, v150, s[54:55]
		v_cndmask_b32_e32 v139, v9, v183, vcc
		v_cmp_ge_i32_e64 s[54:55], v7, v143
		v_cmp_ge_i32_e64 s[56:57], v7, v147
		v_accvgpr_read_b32 v18, a143
		v_cmp_ge_i32_e64 s[58:59], v7, v18
		v_cndmask_b32_e64 v142, v9, v184, s[54:55]
		v_cndmask_b32_e64 v143, v9, v185, s[56:57]
		v_cndmask_b32_e64 v146, v9, v186, s[58:59]
		v_accvgpr_read_b32 v18, a144
		v_cmp_ge_i32_e64 vcc, v7, v18
		v_accvgpr_read_b32 v18, a180
		s_nop 0
		v_readfirstlane_b32 s54, v18
		v_accvgpr_read_b32 v18, a181
		s_nop 0
		v_readfirstlane_b32 s55, v18
		s_nop 1
		v_cndmask_b32_e64 v148, v9, v152, s[54:55]
		v_cndmask_b32_e64 v149, v9, v153, s[50:51]
		v_cndmask_b32_e32 v147, v9, v187, vcc
		v_cmp_ge_i32_e64 s[50:51], v7, v151
		v_cmp_ge_i32_e64 s[54:55], v7, v155
		v_accvgpr_read_b32 v18, a145
		v_cmp_ge_i32_e64 s[56:57], v7, v18
		v_cndmask_b32_e64 v150, v9, v188, s[50:51]
		v_cndmask_b32_e64 v151, v9, v189, s[54:55]
		v_cndmask_b32_e64 v152, v9, v190, s[56:57]
		v_accvgpr_read_b32 v18, a146
		v_cmp_ge_i32_e64 vcc, v7, v18
		v_cndmask_b32_e64 v248, v9, v154, s[90:91]
		v_cndmask_b32_e64 v254, v9, v156, s[92:93]
		v_cndmask_b32_e32 v153, v9, v191, vcc
		v_max3_f32 v18, v116, v117, v232
		v_max3_f32 v20, v108, v109, v234
		v_max3_f32 v112, v30, v31, v236
		v_max3_f32 v154, v124, v125, v238
		v_max3_f32 v155, v132, v133, v240
		v_max3_f32 v156, v198, v199, v242
		v_max3_f32 v178, v206, v207, v244
		v_max3_f32 v179, v176, v177, v246
		v_max3_f32 v180, v148, v149, v248
		v_max3_f32 v181, v254, v255, v252
		v_max3_f32 v15, v15, v227, v16
		v_max3_f32 v16, v18, v233, v20
		v_max3_f32 v18, v112, v237, v154
		v_max3_f32 v20, v155, v241, v156
		v_max3_f32 v112, v178, v245, v179
		v_max3_f32 v154, v180, v249, v181
		v_max3_f32 v113, v113, v161, v157
		v_accvgpr_read_b32 v155, a182
		v_max3_f32 v11, v155, v169, v11
		v_max3_f32 v15, v15, v229, v16
		v_max3_f32 v16, v18, v239, v20
		v_max3_f32 v18, v112, v247, v154
		v_max3_f32 v11, v113, v165, v11
		v_max3_f32 v15, v15, v235, v16
		v_max3_f32 v11, v18, v253, v11
		v_max3_f32 v11, v15, v243, v11
		v_max_f32_e32 v112, v11, v173
		v_mov_b32_e32 v113, v112
		v_cndmask_b32_e64 v154, v9, v96, s[52:53]
		v_cndmask_b32_e64 v155, v9, v97, s[94:95]
		v_permlane32_swap_b32_e32 v112, v113
		v_max3_f32 v11, v154, v155, v12
		v_max3_f32 v15, v98, v99, v100
		v_max3_f32 v16, v102, v103, v104
		v_max3_f32 v18, v26, v27, v106
		v_max3_f32 v20, v28, v29, v110
		v_max3_f32 v96, v114, v115, v118
		v_max3_f32 v97, v120, v121, v122
		v_max3_f32 v156, v126, v127, v128
		v_max3_f32 v157, v192, v193, v194
		v_max3_f32 v178, v136, v137, v196
		v_max3_f32 v179, v200, v201, v202
		v_max3_f32 v180, v140, v141, v204
		v_max3_f32 v181, v130, v131, v144
		v_max3_f32 v182, v134, v135, v138
		v_max3_f32 v183, v142, v143, v146
		v_max3_f32 v184, v150, v151, v152
		v_max3_f32 v11, v11, v13, v15
		v_max3_f32 v15, v16, v105, v18
		v_max3_f32 v16, v20, v111, v96
		v_max3_f32 v18, v97, v123, v156
		v_max3_f32 v20, v157, v195, v178
		v_max3_f32 v96, v179, v203, v180
		v_max3_f32 v97, v181, v145, v182
		v_max3_f32 v156, v183, v147, v184
		v_max3_f32 v11, v11, v101, v15
		v_max3_f32 v15, v16, v119, v18
		v_max3_f32 v16, v20, v197, v96
		v_max3_f32 v18, v97, v139, v156
		v_max3_f32 v11, v11, v107, v15
		v_max3_f32 v15, v16, v205, v18
		v_max3_f32 v11, v11, v129, v15
		v_max_f32_e32 v96, v11, v153
		v_mov_b32_e32 v97, v96
		v_max_f32_e32 v156, v112, v113
		v_mov_b32_e32 v112, v5
		v_permlane32_swap_b32_e32 v96, v97
		v_max_f32_e32 v157, v96, v97
		v_pk_mul_f32 v[96:97], v[156:157], v[2:3]
		v_max_f32_e32 v156, v5, v96
		v_max_f32_e32 v157, v8, v97
		v_pk_fma_f32 v[96:97], v[250:251], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[226:227], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[174:175], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[228:229], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[116:117], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[232:233], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[108:109], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[234:235], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[30:31], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[236:237], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[124:125], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[238:239], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[132:133], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[240:241], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[198:199], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[242:243], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[206:207], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[244:245], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[176:177], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[246:247], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[148:149], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[248:249], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[254:255], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[218:219], v[252:253], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[220:221], v[158:159], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[160:161], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[162:163], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[164:165], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[166:167], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[168:169], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[170:171], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[172:173], v[2:3], v[156:157] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[154:155], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[12:13], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[12:13], v[98:99], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[26:27], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[106:107], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[28:29], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[110:111], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[114:115], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[118:119], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[120:121], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[122:123], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[126:127], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[128:129], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[192:193], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[194:195], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[136:137], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[196:197], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[200:201], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[202:203], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[140:141], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[204:205], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[130:131], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[144:145], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[134:135], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[138:139], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[142:143], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[146:147], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[150:151], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[2:3], v[156:157] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v152, v96
		v_exp_f32_e32 v222, v97
		v_exp_f32_e32 v96, v178
		v_exp_f32_e32 v224, v179
		v_exp_f32_e32 v178, v180
		v_exp_f32_e32 v226, v181
		v_exp_f32_e32 v180, v174
		v_exp_f32_e32 v228, v175
		v_exp_f32_e32 v174, v182
		v_exp_f32_e32 v230, v183
		v_exp_f32_e32 v182, v116
		v_exp_f32_e32 v232, v117
		v_exp_f32_e32 v116, v184
		v_exp_f32_e32 v234, v185
		v_exp_f32_e32 v184, v108
		v_exp_f32_e32 v236, v109
		v_exp_f32_e32 v108, v186
		v_exp_f32_e32 v238, v187
		v_exp_f32_e32 v186, v30
		v_exp_f32_e32 v240, v31
		v_exp_f32_e32 v30, v188
		v_exp_f32_e32 v242, v189
		v_exp_f32_e32 v188, v124
		v_exp_f32_e32 v244, v125
		v_exp_f32_e32 v124, v190
		v_exp_f32_e32 v246, v191
		v_exp_f32_e32 v190, v132
		v_exp_f32_e32 v248, v133
		v_exp_f32_e32 v132, v208
		v_exp_f32_e32 v250, v209
		v_exp_f32_e32 v208, v198
		v_exp_f32_e32 v252, v199
		v_exp_f32_e32 v153, v210
		v_exp_f32_e32 v223, v211
		v_exp_f32_e32 v97, v206
		v_exp_f32_e32 v225, v207
		v_exp_f32_e32 v179, v212
		v_exp_f32_e32 v227, v213
		v_exp_f32_e32 v181, v176
		v_exp_f32_e32 v229, v177
		v_exp_f32_e32 v175, v214
		v_exp_f32_e32 v231, v215
		v_exp_f32_e32 v183, v148
		v_exp_f32_e32 v233, v149
		v_exp_f32_e32 v117, v216
		v_exp_f32_e32 v235, v217
		v_exp_f32_e32 v185, v218
		v_exp_f32_e32 v237, v219
		v_exp_f32_e32 v109, v220
		v_exp_f32_e32 v239, v221
		v_exp_f32_e32 v187, v158
		v_exp_f32_e32 v241, v159
		v_exp_f32_e32 v31, v160
		v_exp_f32_e32 v243, v161
		v_exp_f32_e32 v189, v162
		v_exp_f32_e32 v245, v163
		v_exp_f32_e32 v125, v164
		v_exp_f32_e32 v247, v165
		v_exp_f32_e32 v191, v166
		v_exp_f32_e32 v249, v167
		v_exp_f32_e32 v133, v168
		v_exp_f32_e32 v251, v169
		v_exp_f32_e32 v209, v170
		v_exp_f32_e32 v253, v171
		v_exp_f32_e32 v148, v154
		v_exp_f32_e32 v158, v155
		v_exp_f32_e32 v154, v12
		v_exp_f32_e32 v160, v13
		v_exp_f32_e32 v12, v98
		v_exp_f32_e32 v162, v99
		v_exp_f32_e32 v98, v100
		v_exp_f32_e32 v164, v101
		v_exp_f32_e32 v100, v102
		v_exp_f32_e32 v166, v103
		v_exp_f32_e32 v102, v104
		v_exp_f32_e32 v168, v105
		v_exp_f32_e32 v104, v26
		v_exp_f32_e32 v170, v27
		v_exp_f32_e32 v26, v106
		v_exp_f32_e32 v176, v107
		v_exp_f32_e32 v106, v28
		v_exp_f32_e32 v198, v29
		v_exp_f32_e32 v28, v110
		v_exp_f32_e32 v206, v111
		v_exp_f32_e32 v110, v114
		v_exp_f32_e32 v210, v115
		v_exp_f32_e32 v114, v118
		v_exp_f32_e32 v212, v119
		v_exp_f32_e32 v118, v120
		v_exp_f32_e32 v214, v121
		v_exp_f32_e32 v120, v122
		v_exp_f32_e32 v216, v123
		v_exp_f32_e32 v122, v126
		v_exp_f32_e32 v218, v127
		v_exp_f32_e32 v127, v128
		v_exp_f32_e32 v221, v129
		v_exp_f32_e32 v149, v192
		v_exp_f32_e32 v159, v193
		v_exp_f32_e32 v155, v194
		v_exp_f32_e32 v161, v195
		v_exp_f32_e32 v13, v136
		v_exp_f32_e32 v163, v137
		v_exp_f32_e32 v99, v196
		v_exp_f32_e32 v165, v197
		v_exp_f32_e32 v101, v200
		v_exp_f32_e32 v167, v201
		v_exp_f32_e32 v103, v202
		v_exp_f32_e32 v169, v203
		v_exp_f32_e32 v105, v140
		v_exp_f32_e32 v171, v141
		v_exp_f32_e32 v27, v204
		v_exp_f32_e32 v177, v205
		v_exp_f32_e32 v107, v130
		v_exp_f32_e32 v199, v131
		v_exp_f32_e32 v29, v144
		v_exp_f32_e32 v207, v145
		v_exp_f32_e32 v111, v134
		v_exp_f32_e32 v211, v135
		v_exp_f32_e32 v115, v138
		v_exp_f32_e32 v213, v139
		v_exp_f32_e32 v119, v142
		v_exp_f32_e32 v215, v143
		v_exp_f32_e32 v121, v146
		v_exp_f32_e32 v217, v147
		v_exp_f32_e32 v123, v150
		v_exp_f32_e32 v219, v151
		v_pk_add_f32 v[128:129], v[152:153], v[222:223]
		v_pk_add_f32 v[130:131], v[96:97], v[224:225]
		v_pk_add_f32 v[134:135], v[178:179], v[226:227]
		v_pk_add_f32 v[136:137], v[180:181], v[228:229]
		v_pk_add_f32 v[138:139], v[174:175], v[230:231]
		v_pk_add_f32 v[140:141], v[182:183], v[232:233]
		v_pk_add_f32 v[142:143], v[116:117], v[234:235]
		v_pk_add_f32 v[144:145], v[184:185], v[236:237]
		v_pk_add_f32 v[146:147], v[108:109], v[238:239]
		v_pk_add_f32 v[150:151], v[186:187], v[240:241]
		v_pk_add_f32 v[192:193], v[30:31], v[242:243]
		v_pk_add_f32 v[194:195], v[188:189], v[244:245]
		v_pk_add_f32 v[196:197], v[124:125], v[246:247]
		v_pk_add_f32 v[200:201], v[190:191], v[248:249]
		v_pk_add_f32 v[202:203], v[132:133], v[250:251]
		v_pk_add_f32 v[204:205], v[208:209], v[252:253]
		v_pk_add_f32 v[128:129], v[128:129], v[130:131]
		v_pk_add_f32 v[130:131], v[134:135], v[136:137]
		v_pk_add_f32 v[134:135], v[138:139], v[140:141]
		v_pk_add_f32 v[136:137], v[142:143], v[144:145]
		v_pk_add_f32 v[138:139], v[146:147], v[150:151]
		v_pk_add_f32 v[140:141], v[192:193], v[194:195]
		v_pk_add_f32 v[142:143], v[196:197], v[200:201]
		v_pk_add_f32 v[144:145], v[202:203], v[204:205]
		v_pk_add_f32 v[128:129], v[128:129], v[130:131]
		v_pk_add_f32 v[130:131], v[134:135], v[136:137]
		v_pk_add_f32 v[134:135], v[138:139], v[140:141]
		v_pk_add_f32 v[136:137], v[142:143], v[144:145]
		v_pk_add_f32 v[128:129], v[128:129], v[130:131]
		v_pk_add_f32 v[130:131], v[134:135], v[136:137]
		v_pk_add_f32 v[134:135], v[128:129], v[130:131]
		v_add_f32_e32 v128, v134, v135
		v_mov_b32_e32 v129, v128
		v_exp_f32_e32 v126, v172
		v_exp_f32_e32 v220, v173
		v_permlane32_swap_b32_e32 v128, v129
		v_pk_add_f32 v[130:131], v[126:127], v[220:221]
		v_pk_add_f32 v[134:135], v[148:149], v[158:159]
		v_pk_add_f32 v[136:137], v[154:155], v[160:161]
		v_pk_add_f32 v[138:139], v[12:13], v[162:163]
		v_pk_add_f32 v[140:141], v[98:99], v[164:165]
		v_pk_add_f32 v[142:143], v[100:101], v[166:167]
		v_pk_add_f32 v[144:145], v[102:103], v[168:169]
		v_pk_add_f32 v[146:147], v[104:105], v[170:171]
		v_pk_add_f32 v[150:151], v[26:27], v[176:177]
		v_pk_add_f32 v[172:173], v[106:107], v[198:199]
		v_pk_add_f32 v[192:193], v[28:29], v[206:207]
		v_pk_add_f32 v[194:195], v[110:111], v[210:211]
		v_pk_add_f32 v[196:197], v[114:115], v[212:213]
		v_pk_add_f32 v[200:201], v[118:119], v[214:215]
		v_pk_add_f32 v[202:203], v[120:121], v[216:217]
		v_pk_add_f32 v[204:205], v[122:123], v[218:219]
		v_pk_add_f32 v[130:131], v[130:131], v[134:135]
		v_pk_add_f32 v[134:135], v[136:137], v[138:139]
		v_pk_add_f32 v[136:137], v[140:141], v[142:143]
		v_pk_add_f32 v[138:139], v[144:145], v[146:147]
		v_pk_add_f32 v[140:141], v[150:151], v[172:173]
		v_pk_add_f32 v[142:143], v[192:193], v[194:195]
		v_pk_add_f32 v[144:145], v[196:197], v[200:201]
		v_pk_add_f32 v[146:147], v[202:203], v[204:205]
		v_pk_add_f32 v[130:131], v[130:131], v[134:135]
		v_pk_add_f32 v[134:135], v[136:137], v[138:139]
		v_pk_add_f32 v[136:137], v[140:141], v[142:143]
		v_pk_add_f32 v[138:139], v[144:145], v[146:147]
		v_pk_add_f32 v[130:131], v[130:131], v[134:135]
		v_pk_add_f32 v[134:135], v[136:137], v[138:139]
		v_pk_add_f32 v[136:137], v[130:131], v[134:135]
		v_mov_b32_e32 v130, v129
		v_mov_b32_e32 v131, v137
		v_mov_b32_e32 v134, v128
		v_mov_b32_e32 v135, v136
		v_pk_add_f32 v[128:129], v[134:135], v[130:131]
		v_mov_b32_e32 v130, v129
		v_mov_b32_e32 v131, v129
		v_cvt_pk_bf16_f32 v136, v152, v222
		v_cvt_pk_bf16_f32 v137, v96, v224
		v_permlane32_swap_b32_e32 v130, v131
		v_add_f32_e32 v135, v130, v131
		v_mov_b32_e32 v113, v8
		v_pk_add_f32 v[130:131], v[112:113], v[156:157] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v112, v130
		v_exp_f32_e32 v113, v131
		v_cvt_pk_bf16_f32 v138, v178, v226
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
		v_mov_b32_e32 v134, v128
		v_mov_b64_e32 v[128:129], v[24:25]
		v_pk_fma_f32 v[24:25], v[128:129], v[112:113], v[134:135]
		v_cvt_pk_bf16_f32 v139, v180, v228
		v_cvt_pk_bf16_f32 v128, v174, v230
		v_cvt_pk_bf16_f32 v129, v182, v232
		v_cvt_pk_bf16_f32 v130, v116, v234
		v_cvt_pk_bf16_f32 v131, v184, v236
		v_cvt_pk_bf16_f32 v140, v108, v238
		v_cvt_pk_bf16_f32 v141, v186, v240
		v_cvt_pk_bf16_f32 v142, v30, v242
		v_cvt_pk_bf16_f32 v143, v188, v244
		v_cvt_pk_bf16_f32 v144, v124, v246
		v_cvt_pk_bf16_f32 v145, v190, v248
		v_cvt_pk_bf16_f32 v146, v132, v250
		v_cvt_pk_bf16_f32 v147, v208, v252
		v_cvt_pk_bf16_f32 v192, v153, v223
		v_cvt_pk_bf16_f32 v193, v97, v225
		v_cvt_pk_bf16_f32 v194, v179, v227
		v_cvt_pk_bf16_f32 v195, v181, v229
		v_cvt_pk_bf16_f32 v200, v175, v231
		v_cvt_pk_bf16_f32 v201, v183, v233
		v_cvt_pk_bf16_f32 v202, v117, v235
		v_cvt_pk_bf16_f32 v203, v185, v237
		v_cvt_pk_bf16_f32 v172, v109, v239
		v_cvt_pk_bf16_f32 v173, v187, v241
		v_cvt_pk_bf16_f32 v174, v31, v243
		v_cvt_pk_bf16_f32 v175, v189, v245
		v_cvt_pk_bf16_f32 v180, v125, v247
		v_cvt_pk_bf16_f32 v181, v191, v249
		v_cvt_pk_bf16_f32 v182, v133, v251
		v_cvt_pk_bf16_f32 v183, v209, v253
		v_cvt_pk_bf16_f32 v132, v126, v220
		v_cvt_pk_bf16_f32 v133, v148, v158
		v_cvt_pk_bf16_f32 v134, v154, v160
		v_cvt_pk_bf16_f32 v135, v12, v162
		v_cvt_pk_bf16_f32 v184, v98, v164
		v_cvt_pk_bf16_f32 v185, v100, v166
		v_cvt_pk_bf16_f32 v186, v102, v168
		v_cvt_pk_bf16_f32 v187, v104, v170
		v_cvt_pk_bf16_f32 v188, v26, v176
		v_cvt_pk_bf16_f32 v189, v106, v198
		v_cvt_pk_bf16_f32 v190, v28, v206
		v_cvt_pk_bf16_f32 v191, v110, v210
		v_cvt_pk_bf16_f32 v224, v114, v212
		v_cvt_pk_bf16_f32 v225, v118, v214
		v_cvt_pk_bf16_f32 v226, v120, v216
		v_cvt_pk_bf16_f32 v227, v122, v218
		v_cvt_pk_bf16_f32 v228, v127, v221
		v_cvt_pk_bf16_f32 v229, v149, v159
		v_cvt_pk_bf16_f32 v230, v155, v161
		v_cvt_pk_bf16_f32 v231, v13, v163
		v_cvt_pk_bf16_f32 v124, v99, v165
		v_cvt_pk_bf16_f32 v125, v101, v167
		v_cvt_pk_bf16_f32 v126, v103, v169
		v_cvt_pk_bf16_f32 v127, v105, v171
		v_cvt_pk_bf16_f32 v96, v27, v177
		v_cvt_pk_bf16_f32 v97, v107, v199
		v_cvt_pk_bf16_f32 v98, v29, v207
		v_cvt_pk_bf16_f32 v99, v111, v211
		v_cvt_pk_bf16_f32 v28, v115, v213
		v_cvt_pk_bf16_f32 v29, v119, v215
		v_cvt_pk_bf16_f32 v30, v121, v217
		v_cvt_pk_bf16_f32 v31, v123, v219
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[32:47], a[184:187], v[136:139], v[32:47]
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_mfma_f32_32x32x16_bf16 v[48:63], a[216:219], v[136:139], v[48:63]
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_mfma_f32_32x32x16_bf16 v[32:47], a[188:191], v[128:131], v[32:47]
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		s_waitcnt lgkmcnt(12)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[220:223], v[128:131], v[48:63]
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[140:143], v[32:47]
		v_permlane32_swap_b32_e32 v172, v174
		v_permlane32_swap_b32_e32 v173, v175
		s_waitcnt lgkmcnt(10)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[140:143], v[48:63]
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[144:147], v[32:47]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		s_waitcnt lgkmcnt(8)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[144:147], v[48:63]
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
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[188:191], v[80:95]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[188:191], v[64:79]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[224:227], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[224:227], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[192:195], v[32:47]
		s_waitcnt lgkmcnt(6)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[192:195], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[228:231], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[228:231], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[200:203], v[32:47]
		s_waitcnt lgkmcnt(4)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[200:203], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[124:127], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[124:127], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[172:175], v[32:47]
		s_waitcnt lgkmcnt(2)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[172:175], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[180:183], v[32:47]
		s_waitcnt lgkmcnt(0)
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[180:183], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[28:31], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[28:31], v[64:79]
		s_cselect_b32 s1, 1, 0
		s_add_i32 s25, s41, 0x80
		s_cmp_lg_u32 s1, 0
		s_mov_b32 s41, s25
		v_mov_b32_e32 v5, v156
		v_mov_b32_e32 v8, v157
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
		.amdhsa_next_free_vgpr 504
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
	.set .L_attn_fwd_persistent.num_agpr, 248
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
    .vgpr_count:     504
    .agpr_count:     248
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 395
    wave.regalloc.agpr.dwords: 769
    wave.regalloc.remat.dwords: 3
    wave.regalloc.sgpr_to_vgpr.dwords: 68
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
