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
		s_load_dword s19, s[0:1], 0x50
		s_load_dword s20, s[0:1], 0x54
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v1, s20
		v_accvgpr_write_b32 a4, v1
		s_load_dword s20, s[0:1], 0x58
		s_load_dword s21, s[0:1], 0x5c
		s_load_dword s22, s[0:1], 0x60
		s_waitcnt lgkmcnt(0)
		v_mov_b32_e32 v1, s22
		v_accvgpr_write_b32 a5, v1
		v_accvgpr_write_b32 a6, 0
		s_and_b32 s0, s16, 7
		v_mov_b32_e32 v1, s0
		v_accvgpr_write_b32 a7, v1
		s_lshr_b32 s0, s16, 3
		v_accvgpr_read_b32 v1, a4
		s_nop 0
		v_readfirstlane_b32 s1, v1
		s_mul_i32 s1, s19, s1
		s_nop 0
		v_mov_b32_e32 v1, s1
		v_accvgpr_write_b32 a8, v1
		v_accvgpr_read_b32 v1, a8
		s_nop 0
		v_readfirstlane_b32 s1, v1
		s_add_i32 s1, s1, 7
		s_mov_b32 s16, 1
		s_mov_b32 s19, 7
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s19, s19, 0
		s_add_i32 s1, s1, s19
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
		s_and_b32 s19, s0, 15
		s_mul_i32 s1, s1, 8
		v_accvgpr_read_b32 v1, a7
		s_nop 0
		v_readfirstlane_b32 s22, v1
		s_add_i32 s1, s22, s1
		v_accvgpr_read_b32 v1, a8
		s_nop 0
		v_readfirstlane_b32 s22, v1
		s_cmp_lt_i32 s1, s22
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_0
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s22, 1, 0
		s_xor_b32 s23, s1, -1
		s_add_i32 s23, s23, 1
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s22, s23, s1
		s_cselect_b32 s23, 1, 0
		v_accvgpr_read_b32 v1, a4
		s_nop 0
		v_readfirstlane_b32 s24, v1
		s_xor_b32 s24, s24, -1
		s_add_i32 s24, s24, 1
		v_accvgpr_read_b32 v1, a4
		s_nop 0
		v_readfirstlane_b32 s25, v1
		s_cmp_lt_i32 s25, 0
		v_accvgpr_read_b32 v1, a4
		s_nop 0
		v_readfirstlane_b32 s25, v1
		s_cselect_b32 s24, s24, s25
		v_mov_b32_e32 v1, s24
		v_cvt_f32_u32_e32 v1, v1
		v_rcp_iflag_f32_e32 v1, v1
		v_mov_b32_e32 v2, 0x4f7ffffe
		v_mul_f32_e32 v1, v2, v1
		v_cvt_u32_f32_e32 v1, v1
		s_mul_i32 s19, s19, 2
		v_readfirstlane_b32 s25, v1
		s_xor_b32 s26, s24, -1
		s_add_i32 s26, s26, 1
		s_mul_i32 s27, s26, s25
		s_mul_hi_u32 s27, s25, s27
		s_add_i32 s25, s25, s27
		s_mul_hi_u32 s25, s22, s25
		s_mul_i32 s27, s25, s24
		s_xor_b32 s27, s27, -1
		s_add_i32 s27, s27, 1
		s_add_i32 s22, s22, s27
		s_cmp_ge_u32 s22, s24
		s_cselect_b32 s27, 1, 0
		s_add_i32 s28, s25, 1
		s_cmp_lg_u32 s27, 0
		s_cselect_b32 s25, s28, s25
		s_cselect_b32 s27, 1, 0
		s_add_i32 s28, s22, s26
		s_cmp_lg_u32 s27, 0
		s_cselect_b32 s22, s28, s22
		s_cmp_ge_u32 s22, s24
		s_cselect_b32 s24, 1, 0
		s_add_i32 s27, s25, 1
		s_cmp_lg_u32 s24, 0
		s_cselect_b32 s24, s27, s25
		s_cselect_b32 s25, 1, 0
		v_accvgpr_read_b32 v1, a4
		s_nop 0
		v_readfirstlane_b32 s27, v1
		s_xor_b32 s1, s1, s27
		s_xor_b32 s27, s24, -1
		s_add_i32 s27, s27, 1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s1, s27, s24
		v_mov_b32_e32 v1, s1
		s_add_i32 s24, s22, s26
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s22, s24, s22
		s_xor_b32 s24, s22, -1
		s_add_i32 s24, s24, 1
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s22, s24, s22
		v_mov_b32_e32 v2, s22
		v_accvgpr_write_b32 a10, v2
		s_cmp_lt_i32 s19, 32
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_1
		s_lshr_b32 s22, s19, 1
		s_and_b32 s19, s19, 1
		s_xor_b32 s23, s22, -1
		s_add_i32 s23, s23, 1
		s_add_i32 s23, s23, 31
		s_cmp_eq_u32 s19, 0
		s_cselect_b32 s19, s22, s23
		v_mov_b32_e32 v2, s19
		v_accvgpr_write_b32 a11, v2
		v_accvgpr_read_b32 v2, a11
		s_nop 0
		v_readfirstlane_b32 s19, v2
		s_mul_i32 s19, s19, 0x100
		v_and_b32_e32 v2, 1, v0
		v_lshrrev_b32_e32 v3, 1, v0
		v_and_b32_e32 v4, 1, v3
		v_mov_b32_e32 v5, 2
		v_mul_lo_u32 v5, v5, v4
		v_lshrrev_b32_e32 v4, 2, v0
		v_and_b32_e32 v6, 1, v4
		v_mov_b32_e32 v7, 4
		v_mul_lo_u32 v7, v7, v6
		v_bitop3_b32 v6, v2, v5, v7 bitop3:0x96
		v_lshrrev_b32_e32 v8, 3, v0
		v_and_b32_e32 v9, 1, v8
		v_mov_b32_e32 v10, 8
		v_mul_lo_u32 v10, v10, v9
		v_xor_b32_e32 v6, v6, v10
		v_lshrrev_b32_e32 v11, 4, v0
		v_and_b32_e32 v12, 1, v11
		v_mov_b32_e32 v13, 16
		v_mul_lo_u32 v13, v13, v12
		v_lshrrev_b32_e32 v14, 6, v0
		v_accvgpr_write_b32 a12, v14
		v_accvgpr_read_b32 v14, a12
		v_and_b32_e32 v14, 1, v14
		v_mov_b32_e32 v15, 32
		v_mul_lo_u32 v15, v15, v14
		v_bitop3_b32 v6, v6, v13, v15 bitop3:0x96
		v_lshrrev_b32_e32 v16, 7, v0
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v17, 64
		v_mul_lo_u32 v17, v17, v16
		v_xor_b32_e32 v6, v6, v17
		v_accvgpr_write_b32 a13, v6
		v_xor_b32_e32 v2, 0x80, v2
		v_xor_b32_e32 v2, v2, v5
		v_xor_b32_e32 v2, v2, v7
		v_bitop3_b32 v2, v2, v10, v13 bitop3:0x96
		v_bitop3_b32 v2, v2, v15, v17 bitop3:0x96
		v_accvgpr_write_b32 a14, v2
		v_mov_b32_e32 v2, 2
		v_mul_lo_u32 v2, v2, v12
		v_lshrrev_b32_e32 v5, 5, v0
		v_and_b32_e32 v6, 1, v5
		v_mov_b32_e32 v7, 4
		v_mul_lo_u32 v7, v7, v6
		v_bitop3_b32 v10, v9, v2, v7 bitop3:0x96
		v_mov_b32_e32 v13, 8
		v_mul_lo_u32 v13, v13, v14
		v_xor_b32_e32 v10, v10, v13
		v_mov_b32_e32 v15, 16
		v_mul_lo_u32 v15, v15, v16
		v_xad_u32 v10, v10, v15, s19
		v_bitop3_b32 v17, 32, v9, v2 bitop3:0x96
		v_bitop3_b32 v17, v17, v7, v13 bitop3:0x96
		v_xad_u32 v17, v17, v15, s19
		v_bitop3_b32 v18, 64, v9, v2 bitop3:0x96
		v_bitop3_b32 v18, v18, v7, v13 bitop3:0x96
		v_xad_u32 v18, v18, v15, s19
		v_xor_b32_e32 v19, 0x60, v9
		v_xor_b32_e32 v19, v19, v2
		v_xor_b32_e32 v19, v19, v7
		v_xor_b32_e32 v19, v19, v13
		v_xad_u32 v19, v19, v15, s19
		v_xor_b32_e32 v20, 0x80, v9
		v_xor_b32_e32 v20, v20, v2
		v_xor_b32_e32 v20, v20, v7
		v_xor_b32_e32 v20, v20, v13
		v_xad_u32 v20, v20, v15, s19
		v_xor_b32_e32 v21, 0xa0, v9
		v_xor_b32_e32 v21, v21, v2
		v_xor_b32_e32 v21, v21, v7
		v_xor_b32_e32 v21, v21, v13
		v_xad_u32 v21, v21, v15, s19
		v_xor_b32_e32 v22, 0xc0, v9
		v_xor_b32_e32 v22, v22, v2
		v_xor_b32_e32 v22, v22, v7
		v_xor_b32_e32 v22, v22, v13
		v_xad_u32 v22, v22, v15, s19
		v_xor_b32_e32 v23, 0xe0, v9
		v_xor_b32_e32 v2, v23, v2
		v_xor_b32_e32 v2, v2, v7
		v_xor_b32_e32 v2, v2, v13
		v_xad_u32 v2, v2, v15, s19
		v_cmp_lt_i32_e64 s[22:23], v10, s20
		v_cmp_lt_i32_e64 s[24:25], v17, s20
		v_cmp_lt_i32_e64 s[26:27], v18, s20
		v_cmp_lt_i32_e64 s[28:29], v19, s20
		v_cmp_lt_i32_e64 s[30:31], v20, s20
		v_cmp_lt_i32_e64 s[32:33], v21, s20
		v_cmp_lt_i32_e64 s[34:35], v22, s20
		s_mov_b32 s38, 0x7fffffff
		s_mov_b32 s39, 0x31016000
		s_mov_b32 s36, s2
		s_mov_b32 s37, s3
		v_accvgpr_read_b32 v10, a6
		v_and_b32_e32 v10, 0xffff, v10
		v_lshlrev_b32_e32 v13, 16, v10
		v_or_b32_e32 v20, v10, v13
		v_mov_b32_e32 v21, v20
		v_mov_b32_e32 v22, v20
		v_mov_b32_e32 v23, v20
		v_accvgpr_read_b32 v10, a11
		s_nop 0
		v_readfirstlane_b32 s40, v10
		s_mul_i32 s40, s40, s12
		s_lshl_b32 s40, s40, 9
		v_readfirstlane_b32 s41, v1
		s_mul_i32 s41, s41, s10
		s_lshl_b32 s41, s41, 1
		s_add_i32 s42, s40, s41
		v_accvgpr_read_b32 v10, a10
		s_nop 0
		v_readfirstlane_b32 s43, v10
		s_mul_i32 s43, s43, s11
		s_lshl_b32 s43, s43, 1
		s_add_i32 s42, s42, s43
		v_mul_lo_u32 v10, s12, v8
		v_lshl_add_u32 v13, v10, 1, s42
		v_and_b32_e32 v15, 1, v0
		v_accvgpr_write_b32 a15, v15
		v_accvgpr_read_b32 v15, a15
		v_lshl_add_u32 v13, v15, 4, v13
		v_and_b32_e32 v15, 1, v4
		v_accvgpr_write_b32 a16, v15
		v_accvgpr_read_b32 v15, a16
		v_lshl_add_u32 v13, v15, 6, v13
		v_and_b32_e32 v3, 1, v3
		v_accvgpr_write_b32 a17, v3
		v_accvgpr_read_b32 v3, a17
		v_lshl_add_u32 v3, v3, 5, v13
		s_and_saveexec_b64 s[94:95], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_0
		buffer_load_dwordx4 v[24:27], v3, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_0:
		s_andn2_b64 exec, s[94:95], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_0
		v_mov_b32_e32 v24, v20
		v_mov_b32_e32 v25, v21
		v_mov_b32_e32 v26, v22
		v_mov_b32_e32 v27, v23
.L_attn_fwd_persistent.exec_endif_0:
		s_mov_b64 exec, s[94:95]
		s_lshl_b32 s22, s12, 6
		s_add_i32 s22, s22, s40
		s_add_i32 s22, s22, s41
		s_add_i32 s22, s22, s43
		v_lshl_add_u32 v3, v10, 1, s22
		v_accvgpr_read_b32 v13, a15
		v_lshl_add_u32 v3, v13, 4, v3
		v_accvgpr_read_b32 v13, a16
		v_lshl_add_u32 v3, v13, 6, v3
		v_accvgpr_read_b32 v13, a17
		v_lshl_add_u32 v3, v13, 5, v3
		s_and_saveexec_b64 s[94:95], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_1
		buffer_load_dwordx4 v[28:31], v3, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_1:
		s_andn2_b64 exec, s[94:95], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_1
		v_mov_b32_e32 v28, v20
		v_mov_b32_e32 v29, v21
		v_mov_b32_e32 v30, v22
		v_mov_b32_e32 v31, v23
.L_attn_fwd_persistent.exec_endif_1:
		s_mov_b64 exec, s[94:95]
		s_lshl_b32 s22, s12, 7
		s_add_i32 s22, s22, s40
		s_add_i32 s22, s22, s41
		s_add_i32 s22, s22, s43
		v_lshl_add_u32 v3, v10, 1, s22
		v_accvgpr_read_b32 v13, a15
		v_lshl_add_u32 v3, v13, 4, v3
		v_accvgpr_read_b32 v13, a16
		v_lshl_add_u32 v3, v13, 6, v3
		v_accvgpr_read_b32 v13, a17
		v_lshl_add_u32 v3, v13, 5, v3
		s_and_saveexec_b64 s[94:95], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_2
		buffer_load_dwordx4 v[32:35], v3, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_2:
		s_andn2_b64 exec, s[94:95], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_2
		v_mov_b32_e32 v32, v20
		v_mov_b32_e32 v33, v21
		v_mov_b32_e32 v34, v22
		v_mov_b32_e32 v35, v23
.L_attn_fwd_persistent.exec_endif_2:
		s_mov_b64 exec, s[94:95]
		s_mul_i32 s22, 0xc0, s12
		s_add_i32 s22, s22, s40
		s_add_i32 s22, s22, s41
		s_add_i32 s22, s22, s43
		v_lshl_add_u32 v3, v10, 1, s22
		v_accvgpr_read_b32 v13, a15
		v_lshl_add_u32 v3, v13, 4, v3
		v_accvgpr_read_b32 v13, a16
		v_lshl_add_u32 v3, v13, 6, v3
		v_accvgpr_read_b32 v13, a17
		v_lshl_add_u32 v3, v13, 5, v3
		s_and_saveexec_b64 s[94:95], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_3
		buffer_load_dwordx4 v[36:39], v3, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_3:
		s_andn2_b64 exec, s[94:95], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_3
		v_mov_b32_e32 v36, v20
		v_mov_b32_e32 v37, v21
		v_mov_b32_e32 v38, v22
		v_mov_b32_e32 v39, v23
.L_attn_fwd_persistent.exec_endif_3:
		s_mov_b64 exec, s[94:95]
		s_lshl_b32 s22, s12, 8
		s_add_i32 s22, s22, s40
		s_add_i32 s22, s22, s41
		s_add_i32 s22, s22, s43
		v_lshl_add_u32 v3, v10, 1, s22
		v_accvgpr_read_b32 v13, a15
		v_lshl_add_u32 v3, v13, 4, v3
		v_accvgpr_read_b32 v13, a16
		v_lshl_add_u32 v3, v13, 6, v3
		v_accvgpr_read_b32 v13, a17
		v_lshl_add_u32 v3, v13, 5, v3
		s_and_saveexec_b64 s[94:95], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_4
		buffer_load_dwordx4 v[40:43], v3, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_4:
		s_andn2_b64 exec, s[94:95], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_4
		v_mov_b32_e32 v40, v20
		v_mov_b32_e32 v41, v21
		v_mov_b32_e32 v42, v22
		v_mov_b32_e32 v43, v23
.L_attn_fwd_persistent.exec_endif_4:
		s_mov_b64 exec, s[94:95]
		s_mul_i32 s22, 0x140, s12
		s_add_i32 s22, s22, s40
		s_add_i32 s22, s22, s41
		s_add_i32 s22, s22, s43
		v_lshl_add_u32 v3, v10, 1, s22
		v_accvgpr_read_b32 v13, a15
		v_lshl_add_u32 v3, v13, 4, v3
		v_accvgpr_read_b32 v13, a16
		v_lshl_add_u32 v3, v13, 6, v3
		v_accvgpr_read_b32 v13, a17
		v_lshl_add_u32 v3, v13, 5, v3
		s_and_saveexec_b64 s[94:95], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_5
		buffer_load_dwordx4 v[44:47], v3, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_5:
		s_andn2_b64 exec, s[94:95], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_5
		v_mov_b32_e32 v44, v20
		v_mov_b32_e32 v45, v21
		v_mov_b32_e32 v46, v22
		v_mov_b32_e32 v47, v23
.L_attn_fwd_persistent.exec_endif_5:
		s_mov_b64 exec, s[94:95]
		s_mul_i32 s22, 0x180, s12
		s_add_i32 s22, s22, s40
		s_add_i32 s22, s22, s41
		s_add_i32 s22, s22, s43
		v_lshl_add_u32 v3, v10, 1, s22
		v_accvgpr_read_b32 v13, a15
		v_lshl_add_u32 v3, v13, 4, v3
		v_accvgpr_read_b32 v13, a16
		v_lshl_add_u32 v3, v13, 6, v3
		v_accvgpr_read_b32 v13, a17
		v_lshl_add_u32 v3, v13, 5, v3
		s_and_saveexec_b64 s[94:95], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_6
		buffer_load_dwordx4 v[48:51], v3, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_6:
		s_andn2_b64 exec, s[94:95], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_6
		v_mov_b32_e32 v48, v20
		v_mov_b32_e32 v49, v21
		v_mov_b32_e32 v50, v22
		v_mov_b32_e32 v51, v23
.L_attn_fwd_persistent.exec_endif_6:
		s_mov_b64 exec, s[94:95]
		s_mul_i32 s22, 0x1c0, s12
		s_add_i32 s22, s22, s40
		s_add_i32 s22, s22, s41
		s_add_i32 s22, s22, s43
		v_lshl_add_u32 v3, v10, 1, s22
		v_accvgpr_read_b32 v10, a15
		v_lshl_add_u32 v3, v10, 4, v3
		v_accvgpr_read_b32 v10, a16
		v_lshl_add_u32 v3, v10, 6, v3
		v_accvgpr_read_b32 v10, a17
		v_lshl_add_u32 v3, v10, 5, v3
		v_cmp_lt_i32_e64 vcc, v2, s20
		s_and_saveexec_b64 s[94:95], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_7
		buffer_load_dwordx4 v[52:55], v3, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_7:
		s_andn2_b64 exec, s[94:95], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_7
		v_mov_b32_e32 v52, v20
		v_mov_b32_e32 v53, v21
		v_mov_b32_e32 v54, v22
		v_mov_b32_e32 v55, v23
.L_attn_fwd_persistent.exec_endif_7:
		s_mov_b64 exec, s[94:95]
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
		v_and_b32_e32 v2, 1, v5
		v_accvgpr_write_b32 a18, v2
		v_accvgpr_read_b32 v2, a18
		v_lshlrev_b32_e32 v2, 1, v2
		v_accvgpr_read_b32 v3, a12
		v_and_b32_e32 v3, 1, v3
		v_lshlrev_b32_e32 v3, 2, v3
		v_and_b32_e32 v5, 1, v11
		v_accvgpr_write_b32 a19, v5
		v_accvgpr_read_b32 v5, a19
		v_xor_b32_e32 v3, v3, v5
		v_bitop3_b32 v2, v0, v2, v3 bitop3:0x96
		v_lshlrev_b32_e32 v2, 4, v2
		v_add_u32_e32 v2, 0x10000, v2
		ds_write_b128 v2, v[24:27] offset:2480
		ds_write_b128 v2, v[28:31] offset:6576
		ds_write_b128 v2, v[32:35] offset:10672
		ds_write_b128 v2, v[36:39] offset:14768
		v_mov_b32_e32 v3, 32
		v_mul_lo_u32 v3, v3, v12
		v_mov_b32_e32 v5, 2
		v_mul_lo_u32 v5, v5, v16
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v10, a12
		v_lshlrev_b32_e32 v10, 12, v10
		v_add_u32_e32 v10, 0x10000, v10
		v_and_b32_e32 v11, 63, v0
		v_lshrrev_b32_e32 v12, 5, v11
		v_accvgpr_write_b32 a20, v12
		v_lshrrev_b32_e32 v12, 4, v11
		v_and_b32_e32 v12, 1, v12
		v_lshlrev_b32_e32 v12, 7, v12
		v_accvgpr_read_b32 v13, a20
		v_add_u32_e32 v13, v13, v12
		v_lshrrev_b32_e32 v15, 3, v11
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v16, 6, v15
		v_lshrrev_b32_e32 v17, 2, v11
		v_and_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v18, 5, v17
		v_add3_u32 v13, v13, v16, v18
		v_lshrrev_b32_e32 v19, 1, v11
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v20, 4, v19
		v_and_b32_e32 v21, 1, v11
		v_lshlrev_b32_e32 v21, 3, v21
		v_add3_u32 v13, v13, v20, v21
		v_lshlrev_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v15, 2, v15
		v_bitop3_b32 v15, v17, v15, v19 bitop3:0x96
		v_xor_b32_e32 v13, v13, v15
		v_lshl_add_u32 v13, v13, 4, v10
		ds_read_b128 a[24:27], v13 offset:2480
		v_accvgpr_read_b32 v17, a20
		v_add3_u32 v12, v17, v12, v16
		v_add3_u32 v12, v12, v18, v20
		v_add3_u32 v16, v21, v12, 2
		v_xor_b32_e32 v16, v16, v15
		v_lshl_add_u32 v16, v16, 4, v10
		ds_read_b128 a[28:31], v16 offset:2480
		v_add3_u32 v17, v21, v12, 4
		v_xor_b32_e32 v17, v17, v15
		v_lshl_add_u32 v17, v17, 4, v10
		ds_read_b128 a[32:35], v17 offset:2480
		v_add3_u32 v12, v21, v12, 6
		v_xor_b32_e32 v12, v12, v15
		v_lshl_add_u32 v10, v12, 4, v10
		ds_read_b128 a[36:39], v10 offset:2480
		v_and_b32_e32 v8, 1, v8
		v_accvgpr_write_b32 a21, v8
		v_and_b32_e32 v4, 3, v4
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[40:43] offset:2480
		ds_write_b128 v2, v[44:47] offset:6576
		ds_write_b128 v2, v[48:51] offset:10672
		ds_write_b128 v2, v[52:55] offset:14768
		v_accvgpr_read_b32 v2, a11
		s_nop 0
		v_readfirstlane_b32 s22, v2
		s_add_i32 s22, s22, 1
		s_mul_i32 s22, s22, 0x100
		s_mov_b32 s23, 0x7f
		v_readfirstlane_b32 s32, v0
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[40:43], v13 offset:2480
		ds_read_b128 a[44:47], v16 offset:2480
		ds_read_b128 a[48:51], v17 offset:2480
		ds_read_b128 a[52:55], v10 offset:2480
		v_accvgpr_read_b32 v2, a5
		s_nop 0
		v_readfirstlane_b32 s33, v2
		s_add_i32 s22, s22, s33
		s_cmp_lt_i32 s21, s22
		s_cselect_b32 s22, s21, s22
		s_add_i32 s33, s22, 0x7f
		s_cmp_lt_i32 s33, 0
		s_cselect_b32 s34, s23, 0
		s_add_i32 s33, s33, s34
		s_ashr_i32 s33, s33, 7
		v_accvgpr_read_b32 v2, a5
		s_nop 0
		v_readfirstlane_b32 s34, v2
		s_add_i32 s34, s19, s34
		s_cmp_lt_i32 s34, 0
		s_cselect_b32 s35, s23, 0
		s_add_i32 s34, s34, s35
		s_ashr_i32 s34, s34, 7
		s_cmp_lt_i32 s34, s33
		s_cselect_b32 s34, s34, s33
		s_cmp_gt_i32 s34, 0
		s_cselect_b32 s34, s34, 0
		v_mov_b32_e32 v2, 64
		v_mul_lo_u32 v2, v2, v9
		v_mov_b32_e32 v8, 16
		v_mul_lo_u32 v8, v8, v6
		v_bitop3_b32 v10, v2, v3, v8 bitop3:0x96
		v_bitop3_b32 v10, v10, v14, v5 bitop3:0x96
		v_accvgpr_write_b32 a22, v10
		v_bitop3_b32 v10, 4, v2, v3 bitop3:0x96
		v_xor_b32_e32 v10, v10, v8
		v_bitop3_b32 v12, 8, v2, v3 bitop3:0x96
		v_xor_b32_e32 v12, v12, v8
		v_bitop3_b32 v2, 12, v2, v3 bitop3:0x96
		v_accvgpr_read_b32 v13, a22
		v_cmp_lt_i32_e64 s[36:37], v13, s21
		v_mov_b32_e32 v13, 16
		v_mul_lo_u32 v13, v13, v9
		v_mov_b32_e32 v9, 64
		v_mul_lo_u32 v9, v9, v6
		v_bitop3_b32 v6, v13, v3, v9 bitop3:0x96
		v_bitop3_b32 v6, v6, v14, v5 bitop3:0x96
		v_accvgpr_write_b32 a23, v6
		v_bitop3_b32 v6, 4, v13, v3 bitop3:0x96
		v_bitop3_b32 v15, 8, v13, v3 bitop3:0x96
		v_bitop3_b32 v3, 12, v13, v3 bitop3:0x96
		v_accvgpr_read_b32 v13, a23
		v_cmp_lt_i32_e64 vcc, v13, s21
		v_accvgpr_read_b32 v13, a12
		v_mul_lo_u32 v13, s15, v13
		v_accvgpr_read_b32 v16, a18
		v_mul_lo_u32 v16, s15, v16
		v_lshlrev_b32_e32 v16, 5, v16
		v_lshl_add_u32 v13, v13, 1, v16
		v_accvgpr_read_b32 v16, a19
		v_mul_lo_u32 v16, s15, v16
		v_lshl_add_u32 v13, v16, 6, v13
		v_accvgpr_read_b32 v16, a21
		v_mul_lo_u32 v16, s15, v16
		v_lshlrev_b32_e32 v16, 7, v16
		v_accvgpr_read_b32 v17, a15
		v_lshlrev_b32_e32 v17, 4, v17
		v_add3_u32 v13, v13, v16, v17
		v_accvgpr_read_b32 v16, a16
		v_lshlrev_b32_e32 v16, 6, v16
		v_accvgpr_read_b32 v18, a17
		v_lshlrev_b32_e32 v18, 5, v18
		v_add3_u32 v13, v13, v16, v18
		v_readfirstlane_b32 s35, v1
		s_mul_i32 s35, s35, s13
		s_lshl_b32 s35, s35, 1
		v_accvgpr_read_b32 v19, a10
		s_nop 0
		v_readfirstlane_b32 s40, v19
		s_mul_i32 s40, s40, s14
		s_lshl_b32 s40, s40, 1
		s_add_i32 s41, s35, s40
		v_add_u32_e32 v19, s41, v13
		v_mov_b32_e32 v20, 0x80000000
		v_cndmask_b32_e64 v19, v20, v19, s[36:37]
		s_lshr_b32 s41, s32, 6
		s_mul_i32 s42, 0x410, s41
		s_mov_b32 m0, s42
		v_accvgpr_read_b32 v21, a13
		v_add_u32_e32 v21, s19, v21
		buffer_load_dwordx4 v19, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[44:45], v21, s20
		s_nop 1
		v_mov_b32_e32 v22, s44
		v_mov_b32_e32 v23, s45
		v_accvgpr_write_b32 a56, v22
		v_accvgpr_write_b32 a57, v23
		s_lshl_b32 s43, s15, 3
		s_add_i32 s43, s43, s35
		s_add_i32 s43, s43, s40
		v_add_u32_e32 v19, s43, v13
		v_cndmask_b32_e64 v19, v20, v19, s[36:37]
		s_add_i32 m0, m0, 0x1040
		v_accvgpr_read_b32 v21, a14
		v_add_u32_e32 v21, s19, v21
		buffer_load_dwordx4 v19, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[44:45], v21, s20
		s_nop 1
		v_mov_b32_e32 v22, s44
		v_mov_b32_e32 v23, s45
		v_accvgpr_write_b32 a58, v22
		v_accvgpr_write_b32 a59, v23
		s_lshl_b32 s43, s15, 4
		s_add_i32 s43, s43, s35
		s_add_i32 s43, s43, s40
		v_add_u32_e32 v19, s43, v13
		v_cndmask_b32_e64 v19, v20, v19, s[36:37]
		s_add_i32 m0, m0, 0x1040
		v_and_b32_e32 v11, 31, v11
		buffer_load_dwordx4 v19, s[24:27], 0 offen lds
		v_bitop3_b32 v10, v10, v14, v5 bitop3:0x96
		v_accvgpr_write_b32 a60, v10
		s_mul_i32 s43, 24, s15
		s_add_i32 s43, s43, s35
		s_add_i32 s43, s43, s40
		v_add_u32_e32 v10, s43, v13
		v_cndmask_b32_e64 v10, v20, v10, s[36:37]
		s_add_i32 m0, m0, 0x1040
		v_mov_b32_e32 v19, 0x440
		v_mul_lo_u32 v19, v19, v4
		v_accvgpr_write_b32 a61, v19
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		v_bitop3_b32 v4, v12, v14, v5 bitop3:0x96
		v_accvgpr_write_b32 a62, v4
		v_accvgpr_read_b32 v4, a12
		v_mul_lo_u32 v4, s17, v4
		v_accvgpr_read_b32 v10, a18
		v_mul_lo_u32 v10, s17, v10
		v_lshlrev_b32_e32 v10, 7, v10
		v_lshl_add_u32 v4, v4, 1, v10
		v_accvgpr_read_b32 v10, a19
		v_mul_lo_u32 v10, s17, v10
		v_lshl_add_u32 v4, v10, 6, v4
		v_accvgpr_read_b32 v10, a21
		v_mul_lo_u32 v10, s17, v10
		v_lshlrev_b32_e32 v10, 5, v10
		v_add3_u32 v4, v4, v10, v17
		v_add3_u32 v4, v4, v16, v18
		v_accvgpr_read_b32 v10, a0
		s_nop 0
		v_readfirstlane_b32 s36, v10
		v_readfirstlane_b32 s37, v1
		s_mul_i32 s36, s37, s36
		s_lshl_b32 s36, s36, 1
		v_accvgpr_read_b32 v1, a1
		s_nop 0
		v_readfirstlane_b32 s37, v1
		v_accvgpr_read_b32 v1, a10
		s_nop 0
		v_readfirstlane_b32 s43, v1
		s_mul_i32 s37, s43, s37
		s_lshl_b32 s37, s37, 1
		s_add_i32 s43, s36, s37
		v_add_u32_e32 v1, s43, v4
		v_cndmask_b32_e32 v1, v20, v1, vcc
		s_mul_i32 s41, 0x440, s41
		s_add_i32 m0, s41, 0x81f0
		v_xor_b32_e32 v2, v2, v8
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_bitop3_b32 v1, v2, v14, v5 bitop3:0x96
		v_accvgpr_write_b32 a63, v1
		s_lshl_b32 s43, s17, 3
		s_add_i32 s43, s43, s36
		s_add_i32 s43, s43, s37
		v_add_u32_e32 v1, s43, v4
		v_cndmask_b32_e32 v1, v20, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v2, v6, v9
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_bitop3_b32 v1, v2, v14, v5 bitop3:0x96
		v_accvgpr_write_b32 a64, v1
		s_lshl_b32 s43, s17, 4
		s_add_i32 s43, s43, s36
		s_add_i32 s43, s43, s37
		v_add_u32_e32 v1, s43, v4
		v_cndmask_b32_e32 v1, v20, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v2, v15, v9
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_bitop3_b32 v1, v2, v14, v5 bitop3:0x96
		v_accvgpr_write_b32 a65, v1
		s_mul_i32 s43, 24, s17
		s_add_i32 s43, s43, s36
		s_add_i32 s43, s43, s37
		v_add_u32_e32 v1, s43, v4
		v_cndmask_b32_e32 v1, v20, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v2, v3, v9
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_bitop3_b32 v1, v2, v14, v5 bitop3:0x96
		v_accvgpr_write_b32 a66, v1
		s_mul_i32 s43, s34, 0x80
		v_mbcnt_lo_u32_b32 v1, -1, 0
		v_mbcnt_hi_u32_b32 v1, -1, v1
		v_and_b32_e32 v2, 1, v1
		v_lshrrev_b32_e32 v3, 4, v1
		v_and_b32_e32 v3, 1, v3
		v_lshlrev_b32_e32 v3, 4, v3
		v_lshrrev_b32_e32 v5, 3, v1
		v_and_b32_e32 v5, 1, v5
		v_lshlrev_b32_e32 v5, 3, v5
		v_add3_u32 v6, v2, v3, v5
		v_lshrrev_b32_e32 v8, 2, v1
		v_and_b32_e32 v8, 1, v8
		v_lshlrev_b32_e32 v8, 2, v8
		v_lshrrev_b32_e32 v1, 1, v1
		v_and_b32_e32 v1, 1, v1
		v_lshlrev_b32_e32 v1, 1, v1
		v_add3_u32 v6, v6, v8, v1
		v_add_u32_e32 v2, 32, v2
		v_bitop3_b32 v3, v8, v5, v3 bitop3:0x96
		v_bitop3_b32 v1, v2, v1, v3 bitop3:0x96
		v_mov_b32_e32 v2, 0x3e38aa3b
		v_mov_b32_e32 v3, 0x3e38aa3b
		s_mov_b32 s34, 0xff800000
		v_mov_b32_e32 v5, s34
		v_mov_b32_e32 v8, s34
		s_mov_b32 s34, 1.0
		v_mov_b32_e32 v14, s34
		v_mov_b32_e32 v15, s34
		s_mov_b32 s34, 0
		v_accvgpr_read_b32 v9, a20
		v_lshlrev_b32_e32 v9, 4, v9
		v_accvgpr_write_b32 a67, v9
		v_lshrrev_b32_e32 v9, 4, v11
		v_lshlrev_b32_e32 v9, 9, v9
		v_lshrrev_b32_e32 v10, 3, v11
		v_and_b32_e32 v10, 1, v10
		v_mov_b32_e32 v12, 0x2080
		v_mul_lo_u32 v12, v12, v10
		v_accvgpr_write_b32 a68, v12
		v_lshrrev_b32_e32 v10, 2, v11
		v_and_b32_e32 v10, 1, v10
		v_mov_b32_e32 v12, 0x1040
		v_mul_lo_u32 v12, v12, v10
		v_accvgpr_write_b32 a69, v12
		v_lshrrev_b32_e32 v10, 1, v11
		v_and_b32_e32 v10, 1, v10
		v_mov_b32_e32 v12, 0x820
		v_mul_lo_u32 v12, v12, v10
		v_accvgpr_write_b32 a70, v12
		v_and_b32_e32 v10, 1, v11
		v_mov_b32_e32 v11, 0x410
		v_mul_lo_u32 v11, v11, v10
		v_accvgpr_write_b32 a71, v11
		v_and_b32_e32 v10, 3, v0
		v_accvgpr_write_b32 a72, v10
		v_accvgpr_read_b32 v10, a72
		v_lshlrev_b32_e32 v10, 3, v10
		v_accvgpr_write_b32 a73, v10
		v_accvgpr_read_b32 v10, a18
		v_mov_b32_e32 v11, 0x2200
		v_mul_lo_u32 v11, v11, v10
		v_accvgpr_write_b32 a74, v11
		v_accvgpr_read_b32 v10, a19
		v_lshlrev_b32_e32 v10, 5, v10
		v_accvgpr_write_b32 a75, v10
		s_lshl_b32 s44, s15, 8
		s_add_i32 s44, s44, s35
		s_add_i32 s44, s44, s40
		s_mul_i32 s45, 0x108, s15
		s_add_i32 s45, s45, s35
		s_add_i32 s45, s45, s40
		s_mul_i32 s46, 0x110, s15
		s_add_i32 s46, s46, s35
		s_add_i32 s46, s46, s40
		s_mul_i32 s47, 0x118, s15
		s_add_i32 s35, s47, s35
		s_add_i32 s35, s35, s40
		s_lshl_b32 s40, s17, 8
		s_add_i32 s40, s40, s36
		s_add_i32 s40, s40, s37
		s_mul_i32 s47, 0x108, s17
		s_add_i32 s47, s47, s36
		s_add_i32 s47, s47, s37
		s_mul_i32 s48, 0x110, s17
		s_add_i32 s48, s48, s36
		s_add_i32 s48, s48, s37
		s_mul_i32 s49, 0x118, s17
		s_add_i32 s36, s49, s36
		s_add_i32 s36, s36, s37
		v_lshlrev_b32_e32 v6, 2, v6
		v_accvgpr_write_b32 a76, v6
		v_lshlrev_b32_e32 v1, 2, v1
		v_accvgpr_write_b32 a77, v1
		s_cmp_lt_i32 0, s43
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
		s_lshr_b32 s37, s34, 7
		s_and_b32 s49, s37, 1
		s_mul_i32 s50, 0x4100, s49
		v_accvgpr_read_b32 v1, a67
		v_add3_u32 v1, s50, v1, v9
		v_accvgpr_read_b32 v6, a68
		v_accvgpr_read_b32 v10, a69
		v_add3_u32 v1, v1, v6, v10
		v_accvgpr_read_b32 v6, a70
		v_accvgpr_read_b32 v10, a71
		v_add3_u32 v1, v1, v6, v10
		ds_read_b128 v[16:19], v1
		ds_read_b128 v[24:27], v1 offset:32
		ds_read_b128 v[28:31], v1 offset:64
		ds_read_b128 a[80:83], v1 offset:96
		ds_read_b128 v[96:99], v1 offset:256
		ds_read_b128 v[100:103], v1 offset:288
		ds_read_b128 v[104:107], v1 offset:320
		ds_read_b128 a[84:87], v1 offset:352
		ds_read_b128 v[108:111], v1 offset:128
		ds_read_b128 v[112:115], v1 offset:160
		ds_read_b128 v[116:119], v1 offset:192
		ds_read_b128 a[88:91], v1 offset:224
		ds_read_b128 v[120:123], v1 offset:384
		ds_read_b128 a[92:95], v1 offset:416
		ds_read_b128 a[96:99], v1 offset:448
		ds_read_b128 a[100:103], v1 offset:480
		s_mul_i32 s49, 0x4400, s49
		v_accvgpr_read_b32 v1, a73
		v_accvgpr_read_b32 v6, a74
		v_add3_u32 v1, s49, v1, v6
		v_accvgpr_read_b32 v6, a61
		v_accvgpr_read_b32 v10, a75
		v_add3_u32 v1, v1, v10, v6
		ds_read_b64_tr_b16 a[104:105], v1 offset:33264
		ds_read_b64_tr_b16 a[106:107], v1 offset:37616
		ds_read_b64_tr_b16 a[108:109], v1 offset:33392
		ds_read_b64_tr_b16 a[110:111], v1 offset:37744
		ds_read_b64_tr_b16 a[112:113], v1 offset:33520
		ds_read_b64_tr_b16 a[114:115], v1 offset:37872
		ds_read_b64_tr_b16 a[116:117], v1 offset:33648
		ds_read_b64_tr_b16 a[118:119], v1 offset:38000
		ds_read_b64_tr_b16 a[120:121], v1 offset:33776
		ds_read_b64_tr_b16 a[122:123], v1 offset:38128
		ds_read_b64_tr_b16 a[124:125], v1 offset:33904
		ds_read_b64_tr_b16 a[126:127], v1 offset:38256
		ds_read_b64_tr_b16 a[128:129], v1 offset:34032
		ds_read_b64_tr_b16 a[130:131], v1 offset:38384
		ds_read_b64_tr_b16 a[132:133], v1 offset:34160
		ds_read_b64_tr_b16 a[134:135], v1 offset:38512
		ds_read_b64_tr_b16 a[136:137], v1 offset:33328
		ds_read_b64_tr_b16 a[138:139], v1 offset:37680
		ds_read_b64_tr_b16 a[140:141], v1 offset:33456
		ds_read_b64_tr_b16 a[142:143], v1 offset:37808
		ds_read_b64_tr_b16 a[144:145], v1 offset:33584
		ds_read_b64_tr_b16 a[146:147], v1 offset:37936
		ds_read_b64_tr_b16 a[148:149], v1 offset:33712
		ds_read_b64_tr_b16 a[150:151], v1 offset:38064
		ds_read_b64_tr_b16 a[152:153], v1 offset:33840
		ds_read_b64_tr_b16 a[154:155], v1 offset:38192
		ds_read_b64_tr_b16 a[156:157], v1 offset:33968
		ds_read_b64_tr_b16 a[158:159], v1 offset:38320
		ds_read_b64_tr_b16 a[160:161], v1 offset:34096
		ds_read_b64_tr_b16 a[162:163], v1 offset:38448
		ds_read_b64_tr_b16 a[164:165], v1 offset:34224
		ds_read_b64_tr_b16 a[166:167], v1 offset:38576
		s_mul_i32 s49, s15, s34
		s_lshl_b32 s49, s49, 1
		s_add_i32 s50, s44, s49
		v_add_u32_e32 v1, s50, v13
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v6, s49, v13
		s_add_i32 s37, s37, 1
		v_add_u32_e32 v10, s45, v6
		s_and_b32 s37, s37, 1
		v_add_u32_e32 v11, s46, v6
		s_mul_i32 s49, 0x4100, s37
		v_add_u32_e32 v6, s35, v6
		s_add_i32 s49, s42, s49
		v_mfma_f32_32x32x16_bf16 v[128:143], v[16:19], a[24:27], 0
		s_mov_b32 m0, s49
		v_mfma_f32_32x32x16_bf16 v[128:143], v[24:27], a[28:31], v[128:143]
		s_mul_i32 s49, s17, s34
		v_mfma_f32_32x32x16_bf16 v[128:143], v[28:31], a[32:35], v[128:143]
		s_add_i32 s34, s34, 0x80
		v_mfma_f32_32x32x16_bf16 v[144:159], v[16:19], a[40:43], 0
		v_accvgpr_read_b32 v12, a22
		v_add_u32_e32 v12, s34, v12
		v_mfma_f32_32x32x16_bf16 v[144:159], v[24:27], a[44:47], v[144:159]
		v_accvgpr_read_b32 v16, a60
		v_add_u32_e32 v16, s34, v16
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[48:51], v[144:159]
		v_accvgpr_read_b32 v17, a62
		v_add_u32_e32 v17, s34, v17
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], a[24:27], 0
		v_accvgpr_read_b32 v18, a63
		v_add_u32_e32 v18, s34, v18
		v_mfma_f32_32x32x16_bf16 v[160:175], v[100:103], a[28:31], v[160:175]
		v_cmp_lt_i32_e64 s[50:51], v12, s21
		v_mfma_f32_32x32x16_bf16 v[160:175], v[104:107], a[32:35], v[160:175]
		v_accvgpr_read_b32 v12, a23
		v_add_u32_e32 v12, s34, v12
		v_mfma_f32_32x32x16_bf16 v[176:191], v[96:99], a[40:43], 0
		v_accvgpr_read_b32 v19, a64
		v_add_u32_e32 v19, s34, v19
		v_mfma_f32_32x32x16_bf16 v[176:191], v[100:103], a[44:47], v[176:191]
		v_accvgpr_read_b32 v21, a65
		v_add_u32_e32 v21, s34, v21
		v_mfma_f32_32x32x16_bf16 v[176:191], v[104:107], a[48:51], v[176:191]
		v_cmp_lt_i32_e64 s[52:53], v12, s21
		v_mfma_f32_32x32x16_bf16 v[192:207], v[108:111], a[24:27], 0
		v_cndmask_b32_e64 v1, v20, v1, s[50:51]
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[192:207], v[112:115], a[28:31], v[192:207]
		v_cmp_lt_i32_e64 s[50:51], v16, s21
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[54:55], v17, s21
		v_mfma_f32_32x32x16_bf16 v[192:207], v[116:119], a[32:35], v[192:207]
		v_cndmask_b32_e64 v1, v20, v10, s[50:51]
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[208:223], v[108:111], a[40:43], 0
		v_cndmask_b32_e64 v1, v20, v11, s[54:55]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[112:115], a[44:47], v[208:223]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_32x32x16_bf16 v[208:223], v[116:119], a[48:51], v[208:223]
		v_cmp_lt_i32_e64 s[50:51], v18, s21
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		v_accvgpr_read_b32 v1, a66
		v_add_u32_e32 v1, s34, v1
		v_mfma_f32_32x32x16_bf16 v[96:111], v[120:123], a[24:27], 0
		v_cndmask_b32_e64 v6, v20, v6, s[50:51]
		v_cmp_lt_i32_e64 s[50:51], v19, s21
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s49, s49, 1
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v21, s21
		s_add_i32 s56, s40, s49
		v_mfma_f32_32x32x16_bf16 v[96:111], a[92:95], a[28:31], v[96:111]
		v_add_u32_e32 v6, s56, v4
		v_mfma_f32_32x32x16_bf16 v[96:111], a[96:99], a[32:35], v[96:111]
		v_cndmask_b32_e64 v6, v20, v6, s[52:53]
		v_cmp_lt_i32_e64 vcc, v1, s21
		s_mul_i32 s37, 0x4400, s37
		v_add_u32_e32 v1, s49, v4
		s_add_i32 s37, s41, s37
		v_add_u32_e32 v10, s47, v1
		s_add_i32 m0, s37, 0x81f0
		v_cndmask_b32_e64 v10, v20, v10, s[50:51]
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_add_u32_e32 v6, s48, v1
		v_cndmask_b32_e64 v6, v20, v6, s[54:55]
		s_add_i32 m0, m0, 0x1100
		v_add_u32_e32 v1, s36, v1
		v_cndmask_b32_e32 v1, v20, v1, vcc
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], v[120:123], a[40:43], 0
		s_add_i32 m0, m0, 0x1100
		v_mfma_f32_32x32x16_bf16 v[224:239], a[92:95], a[44:47], v[224:239]
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], a[96:99], a[48:51], v[224:239]
		s_add_i32 m0, m0, 0x1100
		s_cmp_lt_i32 s34, s43
		v_mfma_f32_32x32x16_bf16 v[128:143], a[80:83], a[36:39], v[128:143]
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[160:175], a[84:87], a[36:39], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[88:91], a[36:39], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[100:103], a[36:39], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[100:103], a[52:55], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[80:83], a[52:55], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[84:87], a[52:55], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[88:91], a[52:55], v[208:223]
		s_nop 3
		v_max3_f32 v1, v128, v129, v130
		v_max3_f32 v6, v132, v133, v134
		v_max3_f32 v10, v136, v137, v138
		v_max3_f32 v11, v140, v141, v142
		v_max3_f32 v12, v160, v161, v162
		v_max3_f32 v16, v164, v165, v166
		v_max3_f32 v17, v168, v169, v170
		v_max3_f32 v18, v172, v173, v174
		v_max3_f32 v19, v192, v193, v194
		v_max3_f32 v21, v196, v197, v198
		v_max3_f32 v22, v200, v201, v202
		v_max3_f32 v23, v204, v205, v206
		v_max3_f32 v24, v96, v97, v98
		v_max3_f32 v25, v100, v101, v102
		v_max3_f32 v26, v104, v105, v106
		v_max3_f32 v27, v108, v109, v110
		v_max3_f32 v1, v1, v131, v6
		v_max3_f32 v6, v10, v139, v11
		v_max3_f32 v10, v12, v163, v16
		v_max3_f32 v11, v17, v171, v18
		v_max3_f32 v12, v19, v195, v21
		v_max3_f32 v16, v22, v203, v23
		v_max3_f32 v17, v24, v99, v25
		v_max3_f32 v18, v26, v107, v27
		v_max3_f32 v1, v1, v135, v6
		v_max3_f32 v6, v10, v167, v11
		v_max3_f32 v10, v12, v199, v16
		v_max3_f32 v11, v17, v103, v18
		v_max3_f32 v1, v1, v143, v6
		v_max3_f32 v6, v10, v207, v11
		v_max3_f32 v1, v1, v175, v6
		v_max_f32_e32 v10, v1, v111
		v_mov_b32_e32 v11, v10
		v_max3_f32 v1, v144, v145, v146
		v_max3_f32 v6, v148, v149, v150
		v_max3_f32 v12, v152, v153, v154
		v_max3_f32 v16, v156, v157, v158
		v_max3_f32 v17, v176, v177, v178
		v_max3_f32 v18, v180, v181, v182
		v_max3_f32 v19, v184, v185, v186
		v_max3_f32 v21, v188, v189, v190
		v_max3_f32 v22, v208, v209, v210
		v_max3_f32 v23, v212, v213, v214
		v_max3_f32 v24, v216, v217, v218
		v_max3_f32 v25, v220, v221, v222
		v_max3_f32 v26, v224, v225, v226
		v_max3_f32 v27, v228, v229, v230
		v_max3_f32 v28, v232, v233, v234
		v_max3_f32 v29, v236, v237, v238
		v_permlane32_swap_b32_e32 v10, v11
		v_max3_f32 v1, v1, v147, v6
		v_max3_f32 v6, v12, v155, v16
		v_max3_f32 v12, v17, v179, v18
		v_max3_f32 v16, v19, v187, v21
		v_max3_f32 v17, v22, v211, v23
		v_max3_f32 v18, v24, v219, v25
		v_max3_f32 v19, v26, v227, v27
		v_max3_f32 v21, v28, v235, v29
		v_max3_f32 v1, v1, v151, v6
		v_max3_f32 v6, v12, v183, v16
		v_max3_f32 v12, v17, v215, v18
		v_max3_f32 v16, v19, v231, v21
		v_max3_f32 v1, v1, v159, v6
		v_max3_f32 v6, v12, v223, v16
		v_max3_f32 v1, v1, v191, v6
		v_max_f32_e32 v16, v1, v239
		v_mov_b32_e32 v17, v16
		v_max_f32_e32 v18, v10, v11
		v_mov_b32_e32 v10, v5
		v_permlane32_swap_b32_e32 v16, v17
		v_max_f32_e32 v19, v16, v17
		v_pk_mul_f32 v[16:17], v[18:19], v[2:3]
		v_max_f32_e32 v18, v5, v16
		v_max_f32_e32 v19, v8, v17
		v_pk_fma_f32 v[16:17], v[128:129], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[22:23], v[130:131], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[132:133], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[134:135], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[136:137], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[138:139], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[140:141], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[142:143], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[160:161], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[162:163], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[164:165], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[166:167], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[168:169], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[170:171], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[172:173], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[174:175], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[192:193], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[194:195], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[196:197], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[198:199], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[200:201], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[202:203], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[204:205], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[206:207], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[96:97], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[98:99], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[108:109], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[110:111], v[2:3], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[144:145], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[146:147], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[148:149], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[150:151], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[154:155], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[156:157], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[158:159], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[176:177], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[178:179], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[180:181], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[182:183], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[184:185], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[186:187], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[188:189], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[190:191], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[208:209], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[210:211], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[212:213], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[214:215], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[216:217], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[218:219], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[220:221], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[222:223], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[224:225], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[226:227], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[228:229], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[230:231], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[232:233], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[234:235], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[236:237], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[238:239], v[2:3], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v212, v16
		v_exp_f32_e32 v214, v17
		v_exp_f32_e32 v16, v22
		v_exp_f32_e32 v216, v23
		v_exp_f32_e32 v22, v24
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
		v_exp_f32_e32 v213, v132
		v_exp_f32_e32 v215, v133
		v_exp_f32_e32 v17, v134
		v_exp_f32_e32 v217, v135
		v_exp_f32_e32 v23, v136
		v_exp_f32_e32 v219, v137
		v_exp_f32_e32 v25, v138
		v_exp_f32_e32 v221, v139
		v_exp_f32_e32 v27, v140
		v_exp_f32_e32 v223, v141
		v_exp_f32_e32 v29, v142
		v_exp_f32_e32 v225, v143
		v_exp_f32_e32 v31, v160
		v_exp_f32_e32 v227, v161
		v_exp_f32_e32 v113, v162
		v_exp_f32_e32 v229, v163
		v_exp_f32_e32 v115, v164
		v_exp_f32_e32 v231, v165
		v_exp_f32_e32 v117, v96
		v_exp_f32_e32 v233, v97
		v_exp_f32_e32 v119, v98
		v_exp_f32_e32 v235, v99
		v_exp_f32_e32 v121, v100
		v_exp_f32_e32 v237, v101
		v_exp_f32_e32 v123, v102
		v_exp_f32_e32 v239, v103
		v_exp_f32_e32 v125, v104
		v_exp_f32_e32 v241, v105
		v_exp_f32_e32 v127, v106
		v_exp_f32_e32 v243, v107
		v_exp_f32_e32 v129, v108
		v_exp_f32_e32 v245, v109
		v_exp_f32_e32 v96, v110
		v_exp_f32_e32 v98, v111
		v_exp_f32_e32 v100, v144
		v_exp_f32_e32 v102, v145
		v_exp_f32_e32 v104, v146
		v_exp_f32_e32 v106, v147
		v_exp_f32_e32 v108, v148
		v_exp_f32_e32 v110, v149
		v_exp_f32_e32 v130, v150
		v_exp_f32_e32 v132, v151
		v_exp_f32_e32 v134, v152
		v_exp_f32_e32 v136, v153
		v_exp_f32_e32 v138, v154
		v_exp_f32_e32 v140, v155
		v_exp_f32_e32 v142, v156
		v_exp_f32_e32 v144, v157
		v_exp_f32_e32 v146, v158
		v_exp_f32_e32 v148, v159
		v_exp_f32_e32 v150, v166
		v_exp_f32_e32 v152, v167
		v_exp_f32_e32 v154, v168
		v_exp_f32_e32 v156, v169
		v_exp_f32_e32 v158, v170
		v_exp_f32_e32 v160, v171
		v_exp_f32_e32 v162, v172
		v_exp_f32_e32 v164, v173
		v_exp_f32_e32 v166, v174
		v_exp_f32_e32 v168, v175
		v_exp_f32_e32 v170, v176
		v_exp_f32_e32 v172, v177
		v_exp_f32_e32 v174, v178
		v_exp_f32_e32 v176, v179
		v_exp_f32_e32 v97, v180
		v_exp_f32_e32 v99, v181
		v_exp_f32_e32 v101, v182
		v_exp_f32_e32 v103, v183
		v_exp_f32_e32 v105, v184
		v_exp_f32_e32 v107, v185
		v_exp_f32_e32 v109, v186
		v_exp_f32_e32 v111, v187
		v_exp_f32_e32 v131, v188
		v_exp_f32_e32 v133, v189
		v_exp_f32_e32 v135, v190
		v_exp_f32_e32 v137, v191
		v_exp_f32_e32 v139, v192
		v_exp_f32_e32 v141, v193
		v_exp_f32_e32 v143, v194
		v_exp_f32_e32 v145, v195
		v_exp_f32_e32 v147, v196
		v_exp_f32_e32 v149, v197
		v_exp_f32_e32 v151, v198
		v_exp_f32_e32 v153, v199
		v_exp_f32_e32 v155, v200
		v_exp_f32_e32 v157, v201
		v_exp_f32_e32 v159, v202
		v_exp_f32_e32 v161, v203
		v_exp_f32_e32 v163, v204
		v_exp_f32_e32 v165, v205
		v_exp_f32_e32 v167, v206
		v_exp_f32_e32 v169, v207
		v_exp_f32_e32 v171, v208
		v_exp_f32_e32 v173, v209
		v_exp_f32_e32 v175, v210
		v_exp_f32_e32 v177, v211
		v_pk_add_f32 v[178:179], v[212:213], v[214:215]
		v_pk_add_f32 v[180:181], v[16:17], v[216:217]
		v_pk_add_f32 v[182:183], v[22:23], v[218:219]
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
		v_pk_add_f32 v[178:179], v[178:179], v[180:181]
		v_pk_add_f32 v[180:181], v[182:183], v[184:185]
		v_pk_add_f32 v[182:183], v[186:187], v[188:189]
		v_pk_add_f32 v[184:185], v[190:191], v[192:193]
		v_pk_add_f32 v[186:187], v[194:195], v[196:197]
		v_pk_add_f32 v[188:189], v[198:199], v[200:201]
		v_pk_add_f32 v[190:191], v[202:203], v[204:205]
		v_pk_add_f32 v[192:193], v[206:207], v[208:209]
		v_pk_add_f32 v[178:179], v[178:179], v[180:181]
		v_pk_add_f32 v[180:181], v[182:183], v[184:185]
		v_pk_add_f32 v[182:183], v[186:187], v[188:189]
		v_pk_add_f32 v[184:185], v[190:191], v[192:193]
		v_pk_add_f32 v[178:179], v[178:179], v[180:181]
		v_pk_add_f32 v[180:181], v[182:183], v[184:185]
		v_pk_add_f32 v[182:183], v[178:179], v[180:181]
		v_add_f32_e32 v1, v182, v183
		v_accvgpr_read_b32 v5, a76
		ds_bpermute_b32 v178, v5, v1
		v_accvgpr_read_b32 v5, a77
		ds_bpermute_b32 v180, v5, v1
		v_pk_add_f32 v[182:183], v[96:97], v[98:99]
		v_pk_add_f32 v[184:185], v[100:101], v[102:103]
		v_pk_add_f32 v[186:187], v[104:105], v[106:107]
		v_pk_add_f32 v[188:189], v[108:109], v[110:111]
		v_pk_add_f32 v[190:191], v[130:131], v[132:133]
		v_pk_add_f32 v[192:193], v[134:135], v[136:137]
		v_pk_add_f32 v[194:195], v[138:139], v[140:141]
		v_pk_add_f32 v[196:197], v[142:143], v[144:145]
		v_pk_add_f32 v[198:199], v[146:147], v[148:149]
		v_pk_add_f32 v[200:201], v[150:151], v[152:153]
		v_pk_add_f32 v[202:203], v[154:155], v[156:157]
		v_pk_add_f32 v[204:205], v[158:159], v[160:161]
		v_pk_add_f32 v[206:207], v[162:163], v[164:165]
		v_pk_add_f32 v[208:209], v[166:167], v[168:169]
		v_pk_add_f32 v[210:211], v[170:171], v[172:173]
		v_pk_add_f32 v[246:247], v[174:175], v[176:177]
		v_pk_add_f32 v[182:183], v[182:183], v[184:185]
		v_pk_add_f32 v[184:185], v[186:187], v[188:189]
		v_pk_add_f32 v[186:187], v[190:191], v[192:193]
		v_pk_add_f32 v[188:189], v[194:195], v[196:197]
		v_pk_add_f32 v[190:191], v[198:199], v[200:201]
		v_pk_add_f32 v[192:193], v[202:203], v[204:205]
		v_pk_add_f32 v[194:195], v[206:207], v[208:209]
		v_pk_add_f32 v[196:197], v[210:211], v[246:247]
		v_pk_add_f32 v[182:183], v[182:183], v[184:185]
		v_pk_add_f32 v[184:185], v[186:187], v[188:189]
		v_pk_add_f32 v[186:187], v[190:191], v[192:193]
		v_pk_add_f32 v[188:189], v[194:195], v[196:197]
		v_pk_add_f32 v[182:183], v[182:183], v[184:185]
		v_pk_add_f32 v[184:185], v[186:187], v[188:189]
		v_pk_add_f32 v[186:187], v[182:183], v[184:185]
		v_mov_b32_e32 v181, v187
		v_mov_b32_e32 v179, v186
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[182:183], v[178:179], v[180:181]
		v_mov_b32_e32 v178, v183
		v_mov_b32_e32 v179, v183
		v_cvt_pk_bf16_f32 v184, v212, v214
		v_cvt_pk_bf16_f32 v185, v16, v216
		v_permlane32_swap_b32_e32 v178, v179
		v_add_f32_e32 v181, v178, v179
		v_mov_b32_e32 v11, v8
		v_pk_add_f32 v[178:179], v[10:11], v[18:19] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v10, v178
		v_exp_f32_e32 v11, v179
		v_cvt_pk_bf16_f32 v186, v22, v218
		v_mov_b32_e32 v180, v182
		v_mov_b64_e32 v[178:179], v[14:15]
		v_pk_fma_f32 v[14:15], v[178:179], v[10:11], v[180:181]
		v_cvt_pk_bf16_f32 v187, v24, v220
		v_cvt_pk_bf16_f32 v180, v26, v222
		v_cvt_pk_bf16_f32 v181, v28, v224
		v_cvt_pk_bf16_f32 v182, v30, v226
		v_cvt_pk_bf16_f32 v183, v112, v228
		v_cvt_pk_bf16_f32 v188, v114, v230
		v_cvt_pk_bf16_f32 v189, v116, v232
		v_cvt_pk_bf16_f32 v190, v118, v234
		v_cvt_pk_bf16_f32 v191, v120, v236
		v_cvt_pk_bf16_f32 v192, v122, v238
		v_cvt_pk_bf16_f32 v193, v124, v240
		v_cvt_pk_bf16_f32 v194, v126, v242
		v_cvt_pk_bf16_f32 v195, v128, v244
		v_cvt_pk_bf16_f32 v196, v213, v215
		v_pk_mul_f32 v[32:33], v[32:33], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[34:35], v[34:35], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[36:37], v[36:37], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[38:39], v[38:39], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[40:41], v[40:41], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[42:43], v[42:43], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[44:45], v[44:45], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[46:47], v[46:47], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[48:49], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[50:51], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[52:53], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[54:55], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[56:57], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[58:59], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[60:61], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[62:63], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[64:65], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[66:67], v[66:67], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[68:69], v[68:69], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[70:71], v[70:71], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[72:73], v[72:73], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[74:75], v[74:75], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[76:77], v[76:77], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[78:79], v[78:79], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[80:81], v[80:81], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[82:83], v[82:83], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[84:85], v[84:85], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[86:87], v[86:87], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[88:89], v[88:89], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[90:91], v[90:91], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[92:93], v[92:93], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[94:95], v[94:95], v[10:11] op_sel:[0,1]
		v_cvt_pk_bf16_f32 v197, v17, v217
		v_cvt_pk_bf16_f32 v198, v23, v219
		v_cvt_pk_bf16_f32 v199, v25, v221
		v_cvt_pk_bf16_f32 v200, v27, v223
		v_cvt_pk_bf16_f32 v201, v29, v225
		v_cvt_pk_bf16_f32 v202, v31, v227
		v_cvt_pk_bf16_f32 v203, v113, v229
		v_cvt_pk_bf16_f32 v24, v115, v231
		v_cvt_pk_bf16_f32 v25, v117, v233
		v_cvt_pk_bf16_f32 v26, v119, v235
		v_cvt_pk_bf16_f32 v27, v121, v237
		v_cvt_pk_bf16_f32 v28, v123, v239
		v_cvt_pk_bf16_f32 v29, v125, v241
		v_cvt_pk_bf16_f32 v30, v127, v243
		v_cvt_pk_bf16_f32 v31, v129, v245
		v_cvt_pk_bf16_f32 v112, v96, v98
		v_cvt_pk_bf16_f32 v113, v100, v102
		v_cvt_pk_bf16_f32 v114, v104, v106
		v_cvt_pk_bf16_f32 v115, v108, v110
		v_cvt_pk_bf16_f32 v116, v130, v132
		v_cvt_pk_bf16_f32 v117, v134, v136
		v_cvt_pk_bf16_f32 v118, v138, v140
		v_cvt_pk_bf16_f32 v119, v142, v144
		v_cvt_pk_bf16_f32 v120, v146, v148
		v_cvt_pk_bf16_f32 v121, v150, v152
		v_cvt_pk_bf16_f32 v122, v154, v156
		v_cvt_pk_bf16_f32 v123, v158, v160
		v_cvt_pk_bf16_f32 v124, v162, v164
		v_cvt_pk_bf16_f32 v125, v166, v168
		v_cvt_pk_bf16_f32 v126, v170, v172
		v_cvt_pk_bf16_f32 v127, v174, v176
		v_cvt_pk_bf16_f32 v204, v97, v99
		v_cvt_pk_bf16_f32 v205, v101, v103
		v_cvt_pk_bf16_f32 v206, v105, v107
		v_cvt_pk_bf16_f32 v207, v109, v111
		v_cvt_pk_bf16_f32 v96, v131, v133
		v_cvt_pk_bf16_f32 v97, v135, v137
		v_cvt_pk_bf16_f32 v98, v139, v141
		v_cvt_pk_bf16_f32 v99, v143, v145
		v_cvt_pk_bf16_f32 v100, v147, v149
		v_cvt_pk_bf16_f32 v101, v151, v153
		v_cvt_pk_bf16_f32 v102, v155, v157
		v_cvt_pk_bf16_f32 v103, v159, v161
		v_cvt_pk_bf16_f32 v104, v163, v165
		v_cvt_pk_bf16_f32 v105, v167, v169
		v_cvt_pk_bf16_f32 v106, v171, v173
		v_cvt_pk_bf16_f32 v107, v175, v177
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		v_mfma_f32_32x32x16_bf16 v[32:47], a[104:107], v[184:187], v[32:47]
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[48:63], a[136:139], v[184:187], v[48:63]
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_mfma_f32_32x32x16_bf16 v[32:47], a[108:111], v[180:183], v[32:47]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[48:63], a[140:143], v[180:183], v[48:63]
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_mfma_f32_32x32x16_bf16 v[32:47], a[112:115], v[188:191], v[32:47]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[48:63], a[144:147], v[188:191], v[48:63]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[32:47], a[116:119], v[192:195], v[32:47]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[48:63], a[148:151], v[192:195], v[48:63]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[80:95], a[136:139], v[112:115], v[80:95]
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_mfma_f32_32x32x16_bf16 v[64:79], a[104:107], v[112:115], v[64:79]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[80:95], a[140:143], v[116:119], v[80:95]
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_mfma_f32_32x32x16_bf16 v[64:79], a[108:111], v[116:119], v[64:79]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[120:123], v[80:95]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[64:79], a[112:115], v[120:123], v[64:79]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[80:95], a[148:151], v[124:127], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[116:119], v[124:127], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[120:123], v[196:199], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[152:155], v[196:199], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], v[204:207], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[120:123], v[204:207], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[124:127], v[200:203], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[156:159], v[200:203], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[124:127], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[128:131], v[24:27], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[160:163], v[24:27], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[160:163], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[128:131], v[100:103], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[132:135], v[28:31], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[164:167], v[28:31], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[164:167], v[104:107], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[132:135], v[104:107], v[64:79]
		v_mov_b32_e32 v5, v18
		v_mov_b32_e32 v8, v19
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_1
.L_attn_fwd_persistent.loop_exit_1:
		s_mul_i32 s34, s33, 0x80
		v_accvgpr_read_b32 v1, a13
		v_accvgpr_read_b32 v2, a5
		s_nop 0
		v_readfirstlane_b32 s33, v2
		s_nop 1
		v_add_u32_e32 v1, s33, v1
		v_add_u32_e32 v1, s19, v1
		v_accvgpr_read_b32 v2, a14
		v_accvgpr_read_b32 v3, a5
		s_nop 0
		v_readfirstlane_b32 s33, v3
		s_nop 1
		v_add_u32_e32 v2, s33, v2
		v_add_u32_e32 v2, s19, v2
		v_xor_b32_e32 v3, 1, v7
		v_accvgpr_write_b32 a13, v3
		v_xor_b32_e32 v3, 2, v7
		v_accvgpr_write_b32 a14, v3
		v_xor_b32_e32 v3, 3, v7
		v_accvgpr_write_b32 a67, v3
		v_xor_b32_e32 v3, 8, v7
		v_accvgpr_write_b32 a73, v3
		v_xor_b32_e32 v3, 9, v7
		v_accvgpr_write_b32 a78, v3
		v_xor_b32_e32 v3, 10, v7
		v_accvgpr_write_b32 a79, v3
		v_xor_b32_e32 v3, 11, v7
		v_accvgpr_write_b32 a80, v3
		v_xor_b32_e32 v3, 16, v7
		v_accvgpr_write_b32 a81, v3
		v_xor_b32_e32 v3, 17, v7
		v_accvgpr_write_b32 a82, v3
		v_xor_b32_e32 v3, 18, v7
		v_accvgpr_write_b32 a83, v3
		v_xor_b32_e32 v3, 19, v7
		v_accvgpr_write_b32 a84, v3
		v_xor_b32_e32 v3, 24, v7
		v_accvgpr_write_b32 a85, v3
		v_xor_b32_e32 v3, 25, v7
		v_accvgpr_write_b32 a86, v3
		v_xor_b32_e32 v3, 26, v7
		v_accvgpr_write_b32 a87, v3
		v_xor_b32_e32 v3, 27, v7
		v_accvgpr_write_b32 a88, v3
		v_xor_b32_e32 v3, 32, v7
		v_accvgpr_write_b32 a89, v3
		v_xor_b32_e32 v3, 33, v7
		v_accvgpr_write_b32 a90, v3
		v_xor_b32_e32 v3, 34, v7
		v_accvgpr_write_b32 a91, v3
		v_xor_b32_e32 v3, 35, v7
		v_accvgpr_write_b32 a92, v3
		v_xor_b32_e32 v3, 40, v7
		v_accvgpr_write_b32 a93, v3
		v_xor_b32_e32 v3, 41, v7
		v_accvgpr_write_b32 a94, v3
		v_xor_b32_e32 v3, 42, v7
		v_accvgpr_write_b32 a95, v3
		v_xor_b32_e32 v3, 43, v7
		v_accvgpr_write_b32 a96, v3
		v_xor_b32_e32 v3, 48, v7
		v_accvgpr_write_b32 a97, v3
		v_xor_b32_e32 v3, 49, v7
		v_accvgpr_write_b32 a98, v3
		v_xor_b32_e32 v3, 50, v7
		v_accvgpr_write_b32 a99, v3
		v_xor_b32_e32 v3, 51, v7
		v_accvgpr_write_b32 a100, v3
		v_xor_b32_e32 v3, 56, v7
		v_accvgpr_write_b32 a101, v3
		v_xor_b32_e32 v3, 57, v7
		v_accvgpr_write_b32 a102, v3
		v_xor_b32_e32 v3, 58, v7
		v_accvgpr_write_b32 a103, v3
		v_xor_b32_e32 v3, 59, v7
		v_accvgpr_write_b32 a104, v3
		v_xor_b32_e32 v3, 64, v7
		v_accvgpr_write_b32 a105, v3
		v_xor_b32_e32 v3, 0x41, v7
		v_accvgpr_write_b32 a106, v3
		v_xor_b32_e32 v3, 0x42, v7
		v_accvgpr_write_b32 a107, v3
		v_xor_b32_e32 v3, 0x43, v7
		v_accvgpr_write_b32 a108, v3
		v_xor_b32_e32 v3, 0x48, v7
		v_accvgpr_write_b32 a109, v3
		v_xor_b32_e32 v3, 0x49, v7
		v_accvgpr_write_b32 a110, v3
		v_xor_b32_e32 v3, 0x4a, v7
		v_accvgpr_write_b32 a111, v3
		v_xor_b32_e32 v3, 0x4b, v7
		v_accvgpr_write_b32 a112, v3
		v_xor_b32_e32 v3, 0x50, v7
		v_accvgpr_write_b32 a113, v3
		v_xor_b32_e32 v3, 0x51, v7
		v_accvgpr_write_b32 a114, v3
		v_xor_b32_e32 v3, 0x52, v7
		v_accvgpr_write_b32 a115, v3
		v_xor_b32_e32 v3, 0x53, v7
		v_accvgpr_write_b32 a116, v3
		v_xor_b32_e32 v3, 0x58, v7
		v_accvgpr_write_b32 a117, v3
		v_xor_b32_e32 v3, 0x59, v7
		v_accvgpr_write_b32 a118, v3
		v_xor_b32_e32 v3, 0x5a, v7
		v_accvgpr_write_b32 a119, v3
		v_xor_b32_e32 v3, 0x5b, v7
		v_accvgpr_write_b32 a120, v3
		v_xor_b32_e32 v3, 0x60, v7
		v_accvgpr_write_b32 a121, v3
		v_xor_b32_e32 v3, 0x61, v7
		v_accvgpr_write_b32 a122, v3
		v_xor_b32_e32 v3, 0x62, v7
		v_accvgpr_write_b32 a123, v3
		v_xor_b32_e32 v3, 0x63, v7
		v_accvgpr_write_b32 a124, v3
		v_xor_b32_e32 v3, 0x68, v7
		v_accvgpr_write_b32 a125, v3
		v_xor_b32_e32 v3, 0x69, v7
		v_accvgpr_write_b32 a126, v3
		v_xor_b32_e32 v3, 0x6a, v7
		v_accvgpr_write_b32 a127, v3
		v_xor_b32_e32 v3, 0x6b, v7
		v_accvgpr_write_b32 a128, v3
		v_xor_b32_e32 v3, 0x70, v7
		v_accvgpr_write_b32 a129, v3
		v_xor_b32_e32 v3, 0x71, v7
		v_accvgpr_write_b32 a130, v3
		v_xor_b32_e32 v3, 0x72, v7
		v_accvgpr_write_b32 a131, v3
		v_xor_b32_e32 v3, 0x73, v7
		v_accvgpr_write_b32 a132, v3
		v_xor_b32_e32 v3, 0x78, v7
		v_accvgpr_write_b32 a133, v3
		v_xor_b32_e32 v3, 0x79, v7
		v_accvgpr_write_b32 a134, v3
		v_xor_b32_e32 v3, 0x7a, v7
		v_accvgpr_write_b32 a135, v3
		v_xor_b32_e32 v3, 0x7b, v7
		v_accvgpr_write_b32 a136, v3
		v_accvgpr_read_b32 v3, a20
		v_lshl_add_u32 v3, v3, 4, v9
		v_accvgpr_read_b32 v6, a68
		v_accvgpr_read_b32 v9, a69
		v_add3_u32 v3, v3, v6, v9
		v_accvgpr_read_b32 v6, a70
		v_accvgpr_read_b32 v9, a71
		v_add3_u32 v3, v3, v6, v9
		v_accvgpr_write_b32 a20, v3
		v_accvgpr_read_b32 v3, a72
		v_accvgpr_read_b32 v6, a74
		v_lshl_add_u32 v3, v3, 3, v6
		v_accvgpr_read_b32 v6, a61
		v_accvgpr_read_b32 v9, a75
		v_add3_u32 v3, v3, v9, v6
		v_accvgpr_write_b32 a61, v3
		v_mov_b32_e32 v3, 0xff800000
		s_cmp_lt_i32 s43, s34
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_2
.L_attn_fwd_persistent.loop_head_2:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s19, s43, 0x80
		s_cmp_lt_i32 s43, 0
		s_cselect_b32 s33, s23, 0
		s_add_i32 s33, s43, s33
		s_ashr_i32 s33, s33, 7
		s_cmp_lt_i32 s33, 0
		s_cselect_b32 s37, s16, 0
		s_add_i32 s37, s33, s37
		s_ashr_i32 s37, s37, 1
		s_lshl_b32 s37, s37, 1
		s_xor_b32 s37, s37, -1
		s_add_i32 s37, s37, 1
		s_add_i32 s37, s33, s37
		s_add_i32 s33, s33, 1
		s_cmp_lt_i32 s33, 0
		s_cselect_b32 s41, s16, 0
		s_add_i32 s41, s33, s41
		s_ashr_i32 s41, s41, 1
		s_lshl_b32 s41, s41, 1
		s_xor_b32 s41, s41, -1
		s_add_i32 s41, s41, 1
		s_add_i32 s50, s33, s41
		s_mul_i32 s33, 0x4100, s37
		v_accvgpr_read_b32 v6, a20
		v_add_u32_e32 v6, s33, v6
		ds_read_b128 v[16:19], v6
		ds_read_b128 a[68:71], v6 offset:32
		ds_read_b128 a[140:143], v6 offset:64
		ds_read_b128 a[144:147], v6 offset:96
		ds_read_b128 a[148:151], v6 offset:256
		ds_read_b128 a[152:155], v6 offset:288
		ds_read_b128 a[156:159], v6 offset:320
		ds_read_b128 a[160:163], v6 offset:352
		ds_read_b128 a[164:167], v6 offset:128
		ds_read_b128 a[168:171], v6 offset:160
		ds_read_b128 a[172:175], v6 offset:192
		ds_read_b128 a[176:179], v6 offset:224
		ds_read_b128 v[24:27], v6 offset:384
		ds_read_b128 a[180:183], v6 offset:416
		ds_read_b128 a[184:187], v6 offset:448
		ds_read_b128 a[188:191], v6 offset:480
		s_mul_i32 s33, 0x4400, s37
		v_accvgpr_read_b32 v6, a61
		v_add_u32_e32 v6, s33, v6
		ds_read_b64_tr_b16 a[192:193], v6 offset:33264
		ds_read_b64_tr_b16 a[194:195], v6 offset:37616
		ds_read_b64_tr_b16 a[196:197], v6 offset:33392
		ds_read_b64_tr_b16 a[198:199], v6 offset:37744
		ds_read_b64_tr_b16 a[200:201], v6 offset:33520
		ds_read_b64_tr_b16 a[202:203], v6 offset:37872
		ds_read_b64_tr_b16 a[204:205], v6 offset:33648
		ds_read_b64_tr_b16 a[206:207], v6 offset:38000
		ds_read_b64_tr_b16 a[208:209], v6 offset:33776
		ds_read_b64_tr_b16 a[210:211], v6 offset:38128
		ds_read_b64_tr_b16 a[212:213], v6 offset:33904
		ds_read_b64_tr_b16 a[214:215], v6 offset:38256
		ds_read_b64_tr_b16 a[216:217], v6 offset:34032
		ds_read_b64_tr_b16 a[218:219], v6 offset:38384
		ds_read_b64_tr_b16 a[220:221], v6 offset:34160
		ds_read_b64_tr_b16 a[222:223], v6 offset:38512
		ds_read_b64_tr_b16 a[224:225], v6 offset:33328
		ds_read_b64_tr_b16 a[226:227], v6 offset:37680
		ds_read_b64_tr_b16 a[228:229], v6 offset:33456
		ds_read_b64_tr_b16 a[230:231], v6 offset:37808
		ds_read_b64_tr_b16 a[232:233], v6 offset:33584
		ds_read_b64_tr_b16 a[234:235], v6 offset:37936
		ds_read_b64_tr_b16 a[236:237], v6 offset:33712
		ds_read_b64_tr_b16 a[238:239], v6 offset:38064
		ds_read_b64_tr_b16 a[240:241], v6 offset:33840
		ds_read_b64_tr_b16 a[242:243], v6 offset:38192
		ds_read_b64_tr_b16 a[244:245], v6 offset:33968
		ds_read_b64_tr_b16 a[246:247], v6 offset:38320
		ds_read_b64_tr_b16 a[248:249], v6 offset:34096
		ds_read_b64_tr_b16 a[250:251], v6 offset:38448
		ds_read_b64_tr_b16 a[252:253], v6 offset:34224
		ds_read_b64_tr_b16 a[254:255], v6 offset:38576
		s_cmp_lt_i32 s19, s22
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_2
		v_accvgpr_read_b32 v6, a22
		v_add_u32_e32 v6, s19, v6
		v_cmp_lt_i32_e64 s[52:53], v6, s21
		v_accvgpr_read_b32 v6, a23
		v_add_u32_e32 v6, s19, v6
		v_cmp_lt_i32_e64 s[54:55], v6, s21
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s33, s15, s43
		s_lshl_b32 s37, s33, 1
		s_add_i32 s33, s44, s37
		v_add_u32_e32 v6, s33, v13
		v_cndmask_b32_e64 v6, v20, v6, s[52:53]
		s_mov_b32 s52, 1
		s_mov_b32 s53, 0
		s_mov_b32 s33, 0
		s_mul_i32 s56, s52, s32
		s_mul_hi_u32 s57, s52, s32
		s_mul_i32 s41, s52, s33
		s_add_i32 s57, s57, s41
		s_mul_i32 s41, s53, s32
		s_add_i32 s57, s57, s41
		s_lshr_b64 s[52:53], s[56:57], 6
		s_mov_b32 s56, 0x410
		s_mov_b32 s57, 0
		s_mul_i32 s58, s56, s52
		s_mul_hi_u32 s59, s56, s52
		s_mul_i32 s33, s56, s53
		s_add_i32 s59, s59, s33
		s_mul_i32 s33, s57, s52
		s_add_i32 s59, s59, s33
		s_cmp_lt_i32 s50, 0
		s_cselect_b32 s51, -1, 0
		s_mov_b32 s56, 0x4100
		s_mov_b32 s57, 0
		s_mul_i32 s60, s56, s50
		s_mul_hi_u32 s61, s56, s50
		s_mul_i32 s33, s56, s51
		s_add_i32 s61, s61, s33
		s_mul_i32 s33, s57, s50
		s_add_i32 s61, s61, s33
		s_add_u32 s56, s58, s60
		s_addc_u32 s57, s59, s61
		s_add_u32 s62, s56, 0
		s_addc_u32 s63, s57, 0
		s_mov_b32 m0, s62
		v_accvgpr_read_b32 v9, a60
		v_add_u32_e32 v9, s19, v9
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[56:57], v9, s21
		s_add_i32 s33, s45, s37
		v_add_u32_e32 v6, s33, v13
		v_cndmask_b32_e64 v6, v20, v6, s[56:57]
		s_add_u32 s56, s58, 0x1040
		s_addc_u32 s57, s59, 0
		s_add_u32 s56, s56, s60
		s_addc_u32 s57, s57, s61
		s_add_u32 s62, s56, 0
		s_addc_u32 s63, s57, 0
		s_mov_b32 m0, s62
		v_accvgpr_read_b32 v9, a62
		v_add_u32_e32 v9, s19, v9
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[56:57], v9, s21
		s_add_i32 s33, s46, s37
		v_add_u32_e32 v6, s33, v13
		v_cndmask_b32_e64 v6, v20, v6, s[56:57]
		s_add_u32 s56, s58, 0x2080
		s_addc_u32 s57, s59, 0
		s_add_u32 s56, s56, s60
		s_addc_u32 s57, s57, s61
		s_add_u32 s62, s56, 0
		s_addc_u32 s63, s57, 0
		s_mov_b32 m0, s62
		v_accvgpr_read_b32 v9, a63
		v_add_u32_e32 v9, s19, v9
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[56:57], v9, s21
		s_add_i32 s33, s35, s37
		v_add_u32_e32 v6, s33, v13
		v_cndmask_b32_e64 v6, v20, v6, s[56:57]
		s_add_u32 s56, s58, 0x30c0
		s_addc_u32 s57, s59, 0
		s_add_u32 s56, s56, s60
		s_addc_u32 s57, s57, s61
		s_add_u32 s58, s56, 0
		s_addc_u32 s59, s57, 0
		s_mov_b32 m0, s58
		v_accvgpr_read_b32 v9, a64
		v_add_u32_e32 v9, s19, v9
		buffer_load_dwordx4 v6, s[24:27], 0 offen lds
		s_mul_i32 s33, s17, s43
		s_lshl_b32 s33, s33, 1
		s_add_i32 s37, s40, s33
		v_add_u32_e32 v6, s37, v4
		v_cndmask_b32_e64 v6, v20, v6, s[54:55]
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
		v_accvgpr_read_b32 v10, a65
		v_add_u32_e32 v10, s19, v10
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[50:51], v9, s21
		s_add_i32 s37, s47, s33
		v_add_u32_e32 v6, s37, v4
		v_cndmask_b32_e64 v6, v20, v6, s[50:51]
		s_add_u32 s50, s56, 0x92f0
		s_addc_u32 s51, s57, 0
		s_add_u32 s50, s50, s58
		s_addc_u32 s51, s51, s59
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		v_accvgpr_read_b32 v9, a66
		v_add_u32_e32 v9, s19, v9
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[50:51], v10, s21
		s_add_i32 s37, s48, s33
		v_add_u32_e32 v6, s37, v4
		s_add_u32 s52, s56, 0xa3f0
		s_addc_u32 s53, s57, 0
		s_add_u32 s52, s52, s58
		s_addc_u32 s53, s53, s59
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v6, v20, v6, s[50:51]
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		s_add_i32 s33, s36, s33
		v_cmp_lt_i32_e64 vcc, v9, s21
		v_add_u32_e32 v6, s33, v4
		s_add_u32 s50, s56, 0xb4f0
		s_addc_u32 s51, s57, 0
		v_cndmask_b32_e32 v6, v20, v6, vcc
		s_add_u32 s50, s50, s58
		s_addc_u32 s51, s51, s59
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		s_nop 0
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_2
.L_attn_fwd_persistent.if_else_2:
.L_attn_fwd_persistent.if_end_2:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[96:111], v[16:19], a[24:27], 0
		s_cmp_lt_i32 s19, s34
		v_mfma_f32_32x32x16_bf16 v[112:127], a[148:151], a[24:27], 0
		v_mfma_f32_32x32x16_bf16 v[128:143], a[164:167], a[24:27], 0
		v_mfma_f32_32x32x16_bf16 v[144:159], v[24:27], a[24:27], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[24:27], a[40:43], 0
		v_mfma_f32_32x32x16_bf16 v[176:191], v[16:19], a[40:43], 0
		v_mfma_f32_32x32x16_bf16 v[192:207], a[148:151], a[40:43], 0
		v_mfma_f32_32x32x16_bf16 v[208:223], a[164:167], a[40:43], 0
		v_mfma_f32_32x32x16_bf16 v[96:111], a[68:71], a[28:31], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[152:155], a[28:31], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[168:171], a[28:31], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[180:183], a[28:31], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[44:47], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[68:71], a[44:47], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[152:155], a[44:47], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[168:171], a[44:47], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[140:143], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[156:159], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[172:175], a[32:35], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[184:187], a[32:35], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[184:187], a[48:51], v[160:175]
		v_add_u32_e32 v6, s43, v7
		v_mfma_f32_32x32x16_bf16 v[176:191], a[140:143], a[48:51], v[176:191]
		v_accvgpr_read_b32 v9, a13
		v_add_u32_e32 v9, s43, v9
		v_mfma_f32_32x32x16_bf16 v[192:207], a[156:159], a[48:51], v[192:207]
		v_accvgpr_read_b32 v10, a14
		v_add_u32_e32 v10, s43, v10
		v_mfma_f32_32x32x16_bf16 v[208:223], a[172:175], a[48:51], v[208:223]
		v_accvgpr_read_b32 v11, a67
		v_add_u32_e32 v11, s43, v11
		v_mfma_f32_32x32x16_bf16 v[96:111], a[144:147], a[36:39], v[96:111]
		v_cmp_ge_i32_e64 vcc, v1, v11
		v_mfma_f32_32x32x16_bf16 v[112:127], a[160:163], a[36:39], v[112:127]
		v_accvgpr_read_b32 v12, a79
		v_add_u32_e32 v12, s43, v12
		v_mfma_f32_32x32x16_bf16 v[128:143], a[176:179], a[36:39], v[128:143]
		v_accvgpr_read_b32 v16, a80
		v_add_u32_e32 v16, s43, v16
		v_mfma_f32_32x32x16_bf16 v[144:159], a[188:191], a[36:39], v[144:159]
		v_accvgpr_read_b32 v17, a83
		v_add_u32_e32 v17, s43, v17
		v_mfma_f32_32x32x16_bf16 v[160:175], a[188:191], a[52:55], v[160:175]
		v_accvgpr_read_b32 v18, a84
		v_add_u32_e32 v18, s43, v18
		v_mfma_f32_32x32x16_bf16 v[176:191], a[144:147], a[52:55], v[176:191]
		v_accvgpr_read_b32 v19, a87
		v_add_u32_e32 v19, s43, v19
		v_mfma_f32_32x32x16_bf16 v[192:207], a[160:163], a[52:55], v[192:207]
		v_cndmask_b32_e32 v23, v3, v99, vcc
		v_mfma_f32_32x32x16_bf16 v[208:223], a[176:179], a[52:55], v[208:223]
		v_accvgpr_read_b32 v21, a88
		v_add_u32_e32 v21, s43, v21
		v_accvgpr_read_b32 v22, a91
		v_add_u32_e32 v24, s43, v22
		v_accvgpr_read_b32 v22, a92
		v_add_u32_e32 v25, s43, v22
		v_accvgpr_read_b32 v22, a95
		v_add_u32_e32 v26, s43, v22
		v_accvgpr_read_b32 v22, a96
		v_add_u32_e32 v27, s43, v22
		v_accvgpr_read_b32 v22, a99
		v_add_u32_e32 v28, s43, v22
		v_accvgpr_read_b32 v22, a100
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_write_b32 a68, v22
		v_accvgpr_read_b32 v22, a103
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_write_b32 a69, v22
		v_accvgpr_read_b32 v22, a104
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_write_b32 a70, v22
		v_accvgpr_read_b32 v22, a107
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_write_b32 a71, v22
		v_accvgpr_read_b32 v22, a108
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_write_b32 a72, v22
		v_accvgpr_read_b32 v22, a111
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_write_b32 a74, v22
		v_accvgpr_read_b32 v22, a112
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_write_b32 a75, v22
		v_accvgpr_read_b32 v22, a115
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_write_b32 a137, v22
		v_accvgpr_read_b32 v22, a116
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_write_b32 a138, v22
		v_accvgpr_read_b32 v22, a119
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_write_b32 a139, v22
		v_accvgpr_read_b32 v22, a120
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_write_b32 a140, v22
		v_accvgpr_read_b32 v22, a123
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_write_b32 a141, v22
		v_accvgpr_read_b32 v22, a124
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_write_b32 a142, v22
		v_accvgpr_read_b32 v22, a127
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_write_b32 a143, v22
		v_accvgpr_read_b32 v22, a128
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_write_b32 a144, v22
		v_accvgpr_read_b32 v22, a131
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_write_b32 a145, v22
		v_accvgpr_read_b32 v22, a132
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_write_b32 a146, v22
		v_accvgpr_read_b32 v22, a135
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_write_b32 a147, v22
		v_accvgpr_read_b32 v22, a136
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_write_b32 a148, v22
		v_cmp_ge_i32_e64 s[50:51], v1, v6
		v_cmp_ge_i32_e64 s[52:53], v1, v9
		v_cmp_ge_i32_e64 s[54:55], v1, v10
		v_accvgpr_read_b32 v22, a73
		v_add_u32_e32 v29, s43, v22
		v_accvgpr_read_b32 v22, a78
		v_add_u32_e32 v30, s43, v22
		v_cmp_ge_i32_e64 s[56:57], v1, v29
		v_cmp_ge_i32_e64 s[58:59], v1, v30
		v_cmp_ge_i32_e64 s[60:61], v1, v12
		v_cmp_ge_i32_e64 vcc, v1, v16
		v_accvgpr_read_b32 v22, a81
		v_add_u32_e32 v31, s43, v22
		v_accvgpr_read_b32 v22, a82
		v_add_u32_e32 v99, s43, v22
		v_cndmask_b32_e32 v225, v3, v103, vcc
		v_cmp_ge_i32_e64 s[62:63], v1, v31
		v_cmp_ge_i32_e64 s[64:65], v1, v99
		v_cmp_ge_i32_e64 s[66:67], v1, v17
		v_cmp_ge_i32_e64 vcc, v1, v18
		v_accvgpr_read_b32 v22, a85
		v_add_u32_e32 v103, s43, v22
		v_accvgpr_read_b32 v22, a86
		v_add_u32_e32 v226, s43, v22
		v_cndmask_b32_e32 v229, v3, v107, vcc
		v_cmp_ge_i32_e64 s[68:69], v1, v103
		v_cmp_ge_i32_e64 s[70:71], v1, v226
		v_cmp_ge_i32_e64 s[72:73], v1, v19
		v_cmp_ge_i32_e64 vcc, v1, v21
		v_accvgpr_read_b32 v22, a89
		v_add_u32_e32 v107, s43, v22
		v_accvgpr_read_b32 v22, a90
		v_add_u32_e32 v227, s43, v22
		v_cndmask_b32_e32 v231, v3, v111, vcc
		v_cmp_ge_i32_e64 s[74:75], v1, v107
		v_cmp_ge_i32_e64 s[76:77], v1, v227
		v_cmp_ge_i32_e64 s[78:79], v1, v24
		v_cmp_ge_i32_e64 vcc, v1, v25
		v_accvgpr_read_b32 v22, a93
		v_add_u32_e32 v111, s43, v22
		v_accvgpr_read_b32 v22, a94
		v_add_u32_e32 v232, s43, v22
		v_cndmask_b32_e32 v235, v3, v115, vcc
		v_cmp_ge_i32_e64 s[80:81], v1, v111
		v_cmp_ge_i32_e64 s[82:83], v1, v232
		v_cmp_ge_i32_e64 s[84:85], v1, v26
		v_cmp_ge_i32_e64 vcc, v1, v27
		v_accvgpr_read_b32 v22, a97
		v_add_u32_e32 v115, s43, v22
		v_accvgpr_read_b32 v22, a98
		v_add_u32_e32 v233, s43, v22
		v_cndmask_b32_e32 v237, v3, v119, vcc
		v_cmp_ge_i32_e64 s[86:87], v1, v115
		s_nop 1
		v_mov_b32_e32 v238, s86
		v_mov_b32_e32 v239, s87
		v_accvgpr_write_b32 a150, v238
		v_accvgpr_write_b32 a151, v239
		v_cmp_ge_i32_e64 s[86:87], v1, v233
		s_nop 1
		v_mov_b32_e32 v238, s86
		v_mov_b32_e32 v239, s87
		v_accvgpr_write_b32 a152, v238
		v_accvgpr_write_b32 a153, v239
		v_accvgpr_read_b32 v22, a68
		v_cmp_ge_i32_e64 vcc, v1, v22
		v_accvgpr_read_b32 v22, a101
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_write_b32 a149, v22
		v_accvgpr_read_b32 v22, a102
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_write_b32 a154, v22
		v_cndmask_b32_e32 v239, v3, v123, vcc
		v_accvgpr_read_b32 v22, a70
		v_cmp_ge_i32_e64 vcc, v1, v22
		v_accvgpr_read_b32 v22, a105
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_write_b32 a155, v22
		v_accvgpr_read_b32 v22, a106
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_write_b32 a156, v22
		v_cndmask_b32_e32 v241, v3, v127, vcc
		v_accvgpr_read_b32 v22, a72
		v_cmp_ge_i32_e64 vcc, v1, v22
		v_accvgpr_read_b32 v22, a109
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_write_b32 a157, v22
		v_accvgpr_read_b32 v22, a110
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_write_b32 a158, v22
		v_cndmask_b32_e32 v243, v3, v131, vcc
		v_accvgpr_read_b32 v22, a75
		v_cmp_ge_i32_e64 vcc, v1, v22
		v_accvgpr_read_b32 v22, a113
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_write_b32 a159, v22
		v_accvgpr_read_b32 v22, a114
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_write_b32 a160, v22
		v_cndmask_b32_e32 v245, v3, v135, vcc
		v_accvgpr_read_b32 v22, a138
		v_cmp_ge_i32_e64 vcc, v1, v22
		v_accvgpr_read_b32 v22, a117
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_write_b32 a161, v22
		v_accvgpr_read_b32 v22, a118
		v_add_u32_e32 v22, s43, v22
		v_accvgpr_write_b32 a162, v22
		v_cndmask_b32_e32 v247, v3, v139, vcc
		v_accvgpr_read_b32 v22, a140
		v_cmp_ge_i32_e64 vcc, v1, v22
		v_cmp_ge_i32_e64 s[86:87], v1, v28
		s_nop 1
		v_mov_b32_e32 v248, s86
		v_mov_b32_e32 v249, s87
		v_accvgpr_write_b32 a164, v248
		v_accvgpr_write_b32 a165, v249
		v_cndmask_b32_e64 v248, v3, v96, s[50:51]
		v_accvgpr_read_b32 v22, a149
		v_cmp_ge_i32_e64 s[50:51], v1, v22
		s_nop 1
		v_mov_b32_e32 v250, s50
		v_mov_b32_e32 v251, s51
		v_accvgpr_write_b32 a166, v250
		v_accvgpr_write_b32 a167, v251
		v_accvgpr_read_b32 v22, a154
		v_cmp_ge_i32_e64 s[50:51], v1, v22
		s_nop 1
		v_mov_b32_e32 v250, s50
		v_mov_b32_e32 v251, s51
		v_accvgpr_write_b32 a168, v250
		v_accvgpr_write_b32 a169, v251
		v_accvgpr_read_b32 v22, a69
		v_cmp_ge_i32_e64 s[50:51], v1, v22
		s_nop 1
		v_mov_b32_e32 v250, s50
		v_mov_b32_e32 v251, s51
		v_accvgpr_write_b32 a170, v250
		v_accvgpr_write_b32 a171, v251
		v_accvgpr_read_b32 v22, a155
		v_cmp_ge_i32_e64 s[50:51], v1, v22
		s_nop 1
		v_mov_b32_e32 v250, s50
		v_mov_b32_e32 v251, s51
		v_accvgpr_write_b32 a172, v250
		v_accvgpr_write_b32 a173, v251
		v_accvgpr_read_b32 v22, a156
		v_cmp_ge_i32_e64 s[50:51], v1, v22
		s_nop 1
		v_mov_b32_e32 v250, s50
		v_mov_b32_e32 v251, s51
		v_accvgpr_write_b32 a174, v250
		v_accvgpr_write_b32 a175, v251
		v_accvgpr_read_b32 v22, a71
		v_cmp_ge_i32_e64 s[50:51], v1, v22
		s_nop 1
		v_mov_b32_e32 v250, s50
		v_mov_b32_e32 v251, s51
		v_accvgpr_write_b32 a176, v250
		v_accvgpr_write_b32 a177, v251
		v_accvgpr_read_b32 v22, a157
		v_cmp_ge_i32_e64 s[50:51], v1, v22
		s_nop 1
		v_mov_b32_e32 v250, s50
		v_mov_b32_e32 v251, s51
		v_accvgpr_write_b32 a178, v250
		v_accvgpr_write_b32 a179, v251
		v_accvgpr_read_b32 v22, a158
		v_cmp_ge_i32_e64 s[50:51], v1, v22
		s_nop 1
		v_mov_b32_e32 v250, s50
		v_mov_b32_e32 v251, s51
		v_accvgpr_write_b32 a180, v250
		v_accvgpr_write_b32 a181, v251
		v_accvgpr_read_b32 v22, a74
		v_cmp_ge_i32_e64 s[50:51], v1, v22
		s_nop 1
		v_mov_b32_e32 v250, s50
		v_mov_b32_e32 v251, s51
		v_accvgpr_write_b32 a182, v250
		v_accvgpr_write_b32 a183, v251
		v_accvgpr_read_b32 v22, a159
		v_cmp_ge_i32_e64 s[50:51], v1, v22
		s_nop 1
		v_mov_b32_e32 v250, s50
		v_mov_b32_e32 v251, s51
		v_accvgpr_write_b32 a184, v250
		v_accvgpr_write_b32 a185, v251
		v_accvgpr_read_b32 v22, a160
		v_cmp_ge_i32_e64 s[50:51], v1, v22
		s_nop 1
		v_mov_b32_e32 v250, s50
		v_mov_b32_e32 v251, s51
		v_accvgpr_write_b32 a186, v250
		v_accvgpr_write_b32 a187, v251
		v_accvgpr_read_b32 v22, a137
		v_cmp_ge_i32_e64 s[50:51], v1, v22
		s_nop 1
		v_mov_b32_e32 v250, s50
		v_mov_b32_e32 v251, s51
		v_accvgpr_write_b32 a188, v250
		v_accvgpr_write_b32 a189, v251
		v_accvgpr_read_b32 v22, a161
		v_cmp_ge_i32_e64 s[50:51], v1, v22
		s_nop 1
		v_mov_b32_e32 v250, s50
		v_mov_b32_e32 v251, s51
		v_accvgpr_write_b32 a190, v250
		v_accvgpr_write_b32 a191, v251
		v_accvgpr_read_b32 v22, a162
		v_cmp_ge_i32_e64 s[50:51], v1, v22
		v_accvgpr_read_b32 v22, a139
		v_cmp_ge_i32_e64 s[86:87], v1, v22
		v_cndmask_b32_e32 v251, v3, v143, vcc
		v_cndmask_b32_e64 v253, v3, v141, s[50:51]
		v_cndmask_b32_e64 v250, v3, v142, s[86:87]
		v_accvgpr_read_b32 v22, a121
		v_add_u32_e32 v96, s43, v22
		v_accvgpr_read_b32 v22, a122
		v_add_u32_e32 v119, s43, v22
		v_cmp_ge_i32_e64 s[50:51], v1, v96
		v_cmp_ge_i32_e64 s[86:87], v1, v119
		v_accvgpr_read_b32 v22, a141
		v_cmp_ge_i32_e64 s[88:89], v1, v22
		v_cndmask_b32_e64 v142, v3, v144, s[50:51]
		v_cndmask_b32_e64 v143, v3, v145, s[86:87]
		v_cndmask_b32_e64 v144, v3, v146, s[88:89]
		v_accvgpr_read_b32 v22, a142
		v_cmp_ge_i32_e64 vcc, v1, v22
		v_accvgpr_read_b32 v22, a125
		v_add_u32_e32 v123, s43, v22
		v_accvgpr_read_b32 v22, a126
		v_add_u32_e32 v127, s43, v22
		v_cndmask_b32_e32 v145, v3, v147, vcc
		v_cmp_ge_i32_e64 s[50:51], v1, v123
		v_cmp_ge_i32_e64 s[86:87], v1, v127
		v_accvgpr_read_b32 v22, a143
		v_cmp_ge_i32_e64 s[88:89], v1, v22
		v_cndmask_b32_e64 v146, v3, v148, s[50:51]
		v_cndmask_b32_e64 v147, v3, v149, s[86:87]
		v_cndmask_b32_e64 v148, v3, v150, s[88:89]
		v_accvgpr_read_b32 v22, a144
		v_cmp_ge_i32_e64 vcc, v1, v22
		v_accvgpr_read_b32 v22, a129
		v_add_u32_e32 v131, s43, v22
		v_accvgpr_read_b32 v22, a130
		v_add_u32_e32 v135, s43, v22
		v_cndmask_b32_e32 v149, v3, v151, vcc
		v_cmp_ge_i32_e64 s[50:51], v1, v131
		v_cmp_ge_i32_e64 s[86:87], v1, v135
		v_accvgpr_read_b32 v22, a145
		v_cmp_ge_i32_e64 s[88:89], v1, v22
		v_cndmask_b32_e64 v150, v3, v152, s[50:51]
		v_cndmask_b32_e64 v151, v3, v153, s[86:87]
		v_cndmask_b32_e64 v152, v3, v154, s[88:89]
		v_accvgpr_read_b32 v22, a146
		v_cmp_ge_i32_e64 vcc, v1, v22
		v_accvgpr_read_b32 v22, a133
		v_add_u32_e32 v139, s43, v22
		v_accvgpr_read_b32 v22, a134
		v_add_u32_e32 v141, s43, v22
		v_cndmask_b32_e32 v153, v3, v155, vcc
		v_cmp_ge_i32_e64 s[50:51], v1, v139
		v_cmp_ge_i32_e64 s[86:87], v1, v141
		v_accvgpr_read_b32 v22, a147
		v_cmp_ge_i32_e64 s[88:89], v1, v22
		v_cndmask_b32_e64 v154, v3, v156, s[50:51]
		v_cndmask_b32_e64 v155, v3, v157, s[86:87]
		v_cndmask_b32_e64 v156, v3, v158, s[88:89]
		v_cndmask_b32_e64 v249, v3, v97, s[52:53]
		v_accvgpr_read_b32 v22, a148
		v_cmp_ge_i32_e64 vcc, v1, v22
		v_max3_f32 v97, v142, v143, v144
		v_max3_f32 v158, v146, v147, v148
		v_cndmask_b32_e32 v157, v3, v159, vcc
		v_cmp_ge_i32_e64 s[50:51], v2, v6
		v_cmp_ge_i32_e64 s[52:53], v2, v9
		v_cmp_ge_i32_e64 s[86:87], v2, v10
		v_max3_f32 v6, v150, v151, v152
		v_accvgpr_write_b32 a163, v6
		v_max3_f32 v6, v154, v155, v156
		v_mov_b32_e32 v9, 0xff800000
		v_cndmask_b32_e64 v254, v9, v178, s[86:87]
		v_cmp_ge_i32_e64 vcc, v2, v11
		v_cndmask_b32_e64 v22, v9, v98, s[54:55]
		v_cndmask_b32_e64 v10, v9, v100, s[56:57]
		v_cndmask_b32_e32 v255, v9, v179, vcc
		v_cmp_ge_i32_e64 s[54:55], v2, v29
		v_cmp_ge_i32_e64 s[56:57], v2, v30
		v_cmp_ge_i32_e64 s[86:87], v2, v12
		v_cndmask_b32_e64 v178, v9, v180, s[54:55]
		v_cndmask_b32_e64 v179, v9, v181, s[56:57]
		v_cndmask_b32_e64 v180, v9, v182, s[86:87]
		v_cmp_ge_i32_e64 vcc, v2, v16
		v_cndmask_b32_e64 v11, v9, v101, s[58:59]
		v_cndmask_b32_e64 v224, v9, v102, s[60:61]
		v_cndmask_b32_e64 v100, v9, v104, s[62:63]
		v_cndmask_b32_e32 v181, v9, v183, vcc
		v_cmp_ge_i32_e64 s[54:55], v2, v31
		v_cmp_ge_i32_e64 s[56:57], v2, v99
		v_cmp_ge_i32_e64 s[58:59], v2, v17
		v_cndmask_b32_e64 v16, v9, v184, s[54:55]
		v_cndmask_b32_e64 v17, v9, v185, s[56:57]
		v_cndmask_b32_e64 v30, v9, v186, s[58:59]
		v_cmp_ge_i32_e64 vcc, v2, v18
		v_cndmask_b32_e64 v101, v9, v105, s[64:65]
		v_max3_f32 v12, v248, v249, v22
		v_cndmask_b32_e32 v31, v9, v187, vcc
		v_cmp_ge_i32_e64 s[54:55], v2, v103
		v_cmp_ge_i32_e64 s[56:57], v2, v226
		v_cmp_ge_i32_e64 s[58:59], v2, v19
		v_cndmask_b32_e64 v18, v9, v188, s[54:55]
		v_cndmask_b32_e64 v19, v9, v189, s[56:57]
		v_cndmask_b32_e64 v98, v9, v190, s[58:59]
		v_cmp_ge_i32_e64 vcc, v2, v21
		v_cndmask_b32_e64 v228, v9, v106, s[66:67]
		v_cndmask_b32_e64 v102, v9, v108, s[68:69]
		v_cndmask_b32_e32 v99, v9, v191, vcc
		v_cmp_ge_i32_e64 s[54:55], v2, v107
		v_cmp_ge_i32_e64 s[56:57], v2, v227
		v_cmp_ge_i32_e64 s[58:59], v2, v24
		v_cndmask_b32_e64 v104, v9, v192, s[54:55]
		v_cndmask_b32_e64 v105, v9, v193, s[56:57]
		v_cndmask_b32_e64 v106, v9, v194, s[58:59]
		v_cmp_ge_i32_e64 vcc, v2, v25
		v_cndmask_b32_e64 v103, v9, v109, s[70:71]
		v_cndmask_b32_e64 v230, v9, v110, s[72:73]
		v_cndmask_b32_e64 v24, v9, v112, s[74:75]
		v_cndmask_b32_e32 v107, v9, v195, vcc
		v_cmp_ge_i32_e64 s[54:55], v2, v111
		v_cmp_ge_i32_e64 s[56:57], v2, v232
		v_cmp_ge_i32_e64 s[58:59], v2, v26
		v_cndmask_b32_e64 v108, v9, v196, s[54:55]
		v_cndmask_b32_e64 v109, v9, v197, s[56:57]
		v_cndmask_b32_e64 v110, v9, v198, s[58:59]
		v_cmp_ge_i32_e64 vcc, v2, v27
		v_cndmask_b32_e64 v25, v9, v113, s[76:77]
		v_max3_f32 v21, v10, v11, v224
		v_cndmask_b32_e32 v111, v9, v199, vcc
		v_cmp_ge_i32_e64 s[54:55], v2, v115
		v_cmp_ge_i32_e64 s[56:57], v2, v233
		v_cmp_ge_i32_e64 s[58:59], v2, v28
		v_cndmask_b32_e64 v26, v9, v200, s[54:55]
		v_cndmask_b32_e64 v27, v9, v201, s[56:57]
		v_cndmask_b32_e64 v28, v9, v202, s[58:59]
		v_accvgpr_read_b32 v29, a68
		v_cmp_ge_i32_e64 vcc, v2, v29
		v_cndmask_b32_e64 v234, v9, v114, s[78:79]
		v_cndmask_b32_e64 v112, v9, v116, s[80:81]
		v_cndmask_b32_e32 v29, v9, v203, vcc
		v_accvgpr_read_b32 v113, a70
		v_cmp_ge_i32_e64 vcc, v2, v113
		v_accvgpr_read_b32 v113, a149
		v_cmp_ge_i32_e64 s[54:55], v2, v113
		v_accvgpr_read_b32 v113, a154
		v_cmp_ge_i32_e64 s[56:57], v2, v113
		v_accvgpr_read_b32 v113, a69
		v_cmp_ge_i32_e64 s[58:59], v2, v113
		v_cndmask_b32_e64 v114, v9, v204, s[54:55]
		v_cndmask_b32_e64 v115, v9, v205, s[56:57]
		v_cndmask_b32_e64 v182, v9, v206, s[58:59]
		v_cndmask_b32_e64 v113, v9, v117, s[82:83]
		v_cndmask_b32_e64 v236, v9, v118, s[84:85]
		v_cndmask_b32_e32 v183, v9, v207, vcc
		v_accvgpr_read_b32 v116, a155
		v_cmp_ge_i32_e64 s[54:55], v2, v116
		v_accvgpr_read_b32 v116, a156
		v_cmp_ge_i32_e64 s[56:57], v2, v116
		v_accvgpr_read_b32 v116, a72
		v_cmp_ge_i32_e64 vcc, v2, v116
		v_accvgpr_read_b32 v116, a71
		v_cmp_ge_i32_e64 s[58:59], v2, v116
		v_cndmask_b32_e64 v116, v9, v208, s[54:55]
		v_cndmask_b32_e64 v117, v9, v209, s[56:57]
		v_cndmask_b32_e64 v184, v9, v210, s[58:59]
		v_accvgpr_read_b32 v118, a150
		s_nop 0
		v_readfirstlane_b32 s54, v118
		v_accvgpr_read_b32 v118, a151
		s_nop 0
		v_readfirstlane_b32 s55, v118
		s_nop 1
		v_cndmask_b32_e64 v186, v9, v120, s[54:55]
		v_accvgpr_read_b32 v118, a152
		s_nop 0
		v_readfirstlane_b32 s54, v118
		v_accvgpr_read_b32 v118, a153
		s_nop 0
		v_readfirstlane_b32 s55, v118
		s_nop 1
		v_cndmask_b32_e64 v187, v9, v121, s[54:55]
		v_cndmask_b32_e32 v185, v9, v211, vcc
		v_accvgpr_read_b32 v118, a157
		v_cmp_ge_i32_e64 s[54:55], v2, v118
		v_accvgpr_read_b32 v118, a158
		v_cmp_ge_i32_e64 s[56:57], v2, v118
		v_accvgpr_read_b32 v118, a74
		v_cmp_ge_i32_e64 s[58:59], v2, v118
		v_cndmask_b32_e64 v120, v9, v212, s[54:55]
		v_cndmask_b32_e64 v121, v9, v213, s[56:57]
		v_cndmask_b32_e64 v188, v9, v214, s[58:59]
		v_accvgpr_read_b32 v118, a75
		v_cmp_ge_i32_e64 vcc, v2, v118
		v_accvgpr_read_b32 v118, a164
		s_nop 0
		v_readfirstlane_b32 s54, v118
		v_accvgpr_read_b32 v118, a165
		s_nop 0
		v_readfirstlane_b32 s55, v118
		s_nop 1
		v_cndmask_b32_e64 v238, v9, v122, s[54:55]
		v_accvgpr_read_b32 v118, a166
		s_nop 0
		v_readfirstlane_b32 s54, v118
		v_accvgpr_read_b32 v118, a167
		s_nop 0
		v_readfirstlane_b32 s55, v118
		s_nop 1
		v_cndmask_b32_e64 v190, v9, v124, s[54:55]
		v_cndmask_b32_e32 v189, v9, v215, vcc
		v_accvgpr_read_b32 v118, a159
		v_cmp_ge_i32_e64 s[54:55], v2, v118
		v_accvgpr_read_b32 v118, a160
		v_cmp_ge_i32_e64 s[56:57], v2, v118
		v_accvgpr_read_b32 v118, a137
		v_cmp_ge_i32_e64 s[58:59], v2, v118
		v_cndmask_b32_e64 v192, v9, v216, s[54:55]
		v_cndmask_b32_e64 v193, v9, v217, s[56:57]
		v_cndmask_b32_e64 v194, v9, v218, s[58:59]
		v_accvgpr_read_b32 v118, a138
		v_cmp_ge_i32_e64 vcc, v2, v118
		v_accvgpr_read_b32 v118, a168
		s_nop 0
		v_readfirstlane_b32 s54, v118
		v_accvgpr_read_b32 v118, a169
		s_nop 0
		v_readfirstlane_b32 s55, v118
		s_nop 1
		v_cndmask_b32_e64 v191, v9, v125, s[54:55]
		v_accvgpr_read_b32 v118, a170
		s_nop 0
		v_readfirstlane_b32 s54, v118
		v_accvgpr_read_b32 v118, a171
		s_nop 0
		v_readfirstlane_b32 s55, v118
		s_nop 1
		v_cndmask_b32_e64 v240, v9, v126, s[54:55]
		v_cndmask_b32_e32 v195, v9, v219, vcc
		v_accvgpr_read_b32 v118, a161
		v_cmp_ge_i32_e64 s[54:55], v2, v118
		v_accvgpr_read_b32 v118, a162
		v_cmp_ge_i32_e64 s[56:57], v2, v118
		v_accvgpr_read_b32 v118, a139
		v_cmp_ge_i32_e64 s[58:59], v2, v118
		v_cndmask_b32_e64 v124, v9, v220, s[54:55]
		v_cndmask_b32_e64 v125, v9, v221, s[56:57]
		v_cndmask_b32_e64 v196, v9, v222, s[58:59]
		v_accvgpr_read_b32 v118, a140
		v_cmp_ge_i32_e64 vcc, v2, v118
		v_accvgpr_read_b32 v118, a172
		s_nop 0
		v_readfirstlane_b32 s54, v118
		v_accvgpr_read_b32 v118, a173
		s_nop 0
		v_readfirstlane_b32 s55, v118
		s_nop 1
		v_cndmask_b32_e64 v198, v9, v128, s[54:55]
		v_accvgpr_read_b32 v118, a174
		s_nop 0
		v_readfirstlane_b32 s54, v118
		v_accvgpr_read_b32 v118, a175
		s_nop 0
		v_readfirstlane_b32 s55, v118
		s_nop 1
		v_cndmask_b32_e64 v199, v9, v129, s[54:55]
		v_cndmask_b32_e32 v197, v9, v223, vcc
		v_cmp_ge_i32_e64 s[54:55], v2, v96
		v_cmp_ge_i32_e64 s[56:57], v2, v119
		v_accvgpr_read_b32 v96, a141
		v_cmp_ge_i32_e64 s[58:59], v2, v96
		v_cndmask_b32_e64 v118, v9, v160, s[54:55]
		v_cndmask_b32_e64 v119, v9, v161, s[56:57]
		v_cndmask_b32_e64 v128, v9, v162, s[58:59]
		v_accvgpr_read_b32 v96, a142
		v_cmp_ge_i32_e64 vcc, v2, v96
		v_accvgpr_read_b32 v96, a176
		s_nop 0
		v_readfirstlane_b32 s54, v96
		v_accvgpr_read_b32 v96, a177
		s_nop 0
		v_readfirstlane_b32 s55, v96
		s_nop 1
		v_cndmask_b32_e64 v242, v9, v130, s[54:55]
		v_accvgpr_read_b32 v96, a178
		s_nop 0
		v_readfirstlane_b32 s54, v96
		v_accvgpr_read_b32 v96, a179
		s_nop 0
		v_readfirstlane_b32 s55, v96
		s_nop 1
		v_cndmask_b32_e64 v160, v9, v132, s[54:55]
		v_cndmask_b32_e32 v129, v9, v163, vcc
		v_cmp_ge_i32_e64 s[54:55], v2, v123
		v_cmp_ge_i32_e64 s[56:57], v2, v127
		v_accvgpr_read_b32 v96, a143
		v_cmp_ge_i32_e64 s[58:59], v2, v96
		v_cndmask_b32_e64 v122, v9, v164, s[54:55]
		v_cndmask_b32_e64 v123, v9, v165, s[56:57]
		v_cndmask_b32_e64 v126, v9, v166, s[58:59]
		v_accvgpr_read_b32 v96, a144
		v_cmp_ge_i32_e64 vcc, v2, v96
		v_accvgpr_read_b32 v96, a180
		s_nop 0
		v_readfirstlane_b32 s54, v96
		v_accvgpr_read_b32 v96, a181
		s_nop 0
		v_readfirstlane_b32 s55, v96
		s_nop 1
		v_cndmask_b32_e64 v161, v9, v133, s[54:55]
		v_accvgpr_read_b32 v96, a182
		s_nop 0
		v_readfirstlane_b32 s54, v96
		v_accvgpr_read_b32 v96, a183
		s_nop 0
		v_readfirstlane_b32 s55, v96
		s_nop 1
		v_cndmask_b32_e64 v244, v9, v134, s[54:55]
		v_cndmask_b32_e32 v127, v9, v167, vcc
		v_cmp_ge_i32_e64 s[54:55], v2, v131
		v_cmp_ge_i32_e64 s[56:57], v2, v135
		v_accvgpr_read_b32 v96, a145
		v_cmp_ge_i32_e64 s[58:59], v2, v96
		v_cndmask_b32_e64 v130, v9, v168, s[54:55]
		v_cndmask_b32_e64 v131, v9, v169, s[56:57]
		v_cndmask_b32_e64 v132, v9, v170, s[58:59]
		v_accvgpr_read_b32 v96, a146
		v_cmp_ge_i32_e64 vcc, v2, v96
		v_accvgpr_read_b32 v96, a184
		s_nop 0
		v_readfirstlane_b32 s54, v96
		v_accvgpr_read_b32 v96, a185
		s_nop 0
		v_readfirstlane_b32 s55, v96
		s_nop 1
		v_cndmask_b32_e64 v134, v9, v136, s[54:55]
		v_accvgpr_read_b32 v96, a186
		s_nop 0
		v_readfirstlane_b32 s54, v96
		v_accvgpr_read_b32 v96, a187
		s_nop 0
		v_readfirstlane_b32 s55, v96
		s_nop 1
		v_cndmask_b32_e64 v135, v9, v137, s[54:55]
		v_cndmask_b32_e32 v133, v9, v171, vcc
		v_cmp_ge_i32_e64 s[54:55], v2, v139
		v_cmp_ge_i32_e64 s[56:57], v2, v141
		v_accvgpr_read_b32 v96, a147
		v_cmp_ge_i32_e64 s[58:59], v2, v96
		v_cndmask_b32_e64 v136, v9, v172, s[54:55]
		v_cndmask_b32_e64 v137, v9, v173, s[56:57]
		v_cndmask_b32_e64 v162, v9, v174, s[58:59]
		v_accvgpr_read_b32 v96, a148
		v_cmp_ge_i32_e64 vcc, v2, v96
		v_accvgpr_read_b32 v96, a188
		s_nop 0
		v_readfirstlane_b32 s54, v96
		v_accvgpr_read_b32 v96, a189
		s_nop 0
		v_readfirstlane_b32 s55, v96
		s_nop 1
		v_cndmask_b32_e64 v246, v9, v138, s[54:55]
		v_accvgpr_read_b32 v96, a190
		s_nop 0
		v_readfirstlane_b32 s54, v96
		v_accvgpr_read_b32 v96, a191
		s_nop 0
		v_readfirstlane_b32 s55, v96
		s_nop 1
		v_cndmask_b32_e64 v252, v9, v140, s[54:55]
		v_cndmask_b32_e32 v163, v9, v175, vcc
		v_max3_f32 v96, v100, v101, v228
		v_max3_f32 v138, v102, v103, v230
		v_max3_f32 v139, v24, v25, v234
		v_max3_f32 v140, v112, v113, v236
		v_max3_f32 v141, v186, v187, v238
		v_max3_f32 v159, v190, v191, v240
		v_max3_f32 v164, v198, v199, v242
		v_max3_f32 v165, v160, v161, v244
		v_max3_f32 v166, v134, v135, v246
		v_max3_f32 v167, v252, v253, v250
		v_max3_f32 v12, v12, v23, v21
		v_max3_f32 v21, v96, v229, v138
		v_max3_f32 v96, v139, v235, v140
		v_max3_f32 v138, v141, v239, v159
		v_max3_f32 v139, v164, v243, v165
		v_max3_f32 v140, v166, v247, v167
		v_max3_f32 v97, v97, v145, v158
		v_accvgpr_read_b32 v141, a163
		v_max3_f32 v6, v141, v153, v6
		v_max3_f32 v12, v12, v225, v21
		v_max3_f32 v21, v96, v237, v138
		v_max3_f32 v96, v139, v245, v140
		v_max3_f32 v6, v97, v149, v6
		v_max3_f32 v12, v12, v231, v21
		v_max3_f32 v6, v96, v251, v6
		v_max3_f32 v6, v12, v241, v6
		v_max_f32_e32 v96, v6, v157
		v_mov_b32_e32 v97, v96
		v_cndmask_b32_e64 v138, v9, v176, s[50:51]
		v_cndmask_b32_e64 v139, v9, v177, s[52:53]
		v_permlane32_swap_b32_e32 v96, v97
		v_max3_f32 v6, v138, v139, v254
		v_max3_f32 v9, v178, v179, v180
		v_max3_f32 v12, v16, v17, v30
		v_max3_f32 v21, v18, v19, v98
		v_max3_f32 v140, v104, v105, v106
		v_max3_f32 v141, v108, v109, v110
		v_max3_f32 v158, v26, v27, v28
		v_max3_f32 v159, v114, v115, v182
		v_max3_f32 v164, v116, v117, v184
		v_max3_f32 v165, v120, v121, v188
		v_max3_f32 v166, v192, v193, v194
		v_max3_f32 v167, v124, v125, v196
		v_max3_f32 v168, v118, v119, v128
		v_max3_f32 v169, v122, v123, v126
		v_max3_f32 v170, v130, v131, v132
		v_max3_f32 v171, v136, v137, v162
		v_max3_f32 v6, v6, v255, v9
		v_max3_f32 v9, v12, v31, v21
		v_max3_f32 v12, v140, v107, v141
		v_max3_f32 v21, v158, v29, v159
		v_max3_f32 v140, v164, v185, v165
		v_max3_f32 v141, v166, v195, v167
		v_max3_f32 v158, v168, v129, v169
		v_max3_f32 v159, v170, v133, v171
		v_max3_f32 v6, v6, v181, v9
		v_max3_f32 v9, v12, v111, v21
		v_max3_f32 v12, v140, v189, v141
		v_max3_f32 v21, v158, v127, v159
		v_max3_f32 v6, v6, v99, v9
		v_max3_f32 v9, v12, v197, v21
		v_max3_f32 v6, v6, v183, v9
		v_max_f32_e32 v140, v6, v163
		v_mov_b32_e32 v141, v140
		v_max_f32_e32 v158, v96, v97
		v_mov_b32_e32 v96, v5
		v_permlane32_swap_b32_e32 v140, v141
		v_max_f32_e32 v159, v140, v141
		v_mov_b32_e32 v140, 0x3e38aa3b
		v_mov_b32_e32 v141, 0x3e38aa3b
		v_pk_mul_f32 v[164:165], v[158:159], v[140:141]
		v_max_f32_e32 v158, v5, v164
		v_max_f32_e32 v159, v8, v165
		v_pk_fma_f32 v[164:165], v[248:249], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[22:23], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[22:23], v[10:11], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[10:11], v[224:225], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[100:101], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[228:229], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[102:103], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[230:231], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[24:25], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[234:235], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[112:113], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[236:237], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[186:187], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[238:239], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[190:191], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[240:241], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[198:199], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[242:243], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[160:161], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[244:245], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[134:135], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[246:247], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[252:253], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[250:251], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[142:143], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[144:145], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[146:147], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[148:149], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[150:151], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[154:155], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[156:157], v[140:141], v[158:159] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[138:139], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[254:255], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[178:179], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[180:181], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[16:17], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[16:17], v[30:31], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[18:19], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[18:19], v[98:99], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[104:105], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[108:109], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[110:111], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[26:27], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[28:29], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[114:115], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[182:183], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[116:117], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[184:185], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[120:121], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[188:189], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[192:193], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[194:195], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[124:125], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[196:197], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[118:119], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[128:129], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[122:123], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[126:127], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[130:131], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[132:133], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[136:137], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[162:163], v[140:141], v[158:159] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v140, v164
		v_exp_f32_e32 v162, v165
		v_exp_f32_e32 v164, v166
		v_exp_f32_e32 v216, v167
		v_exp_f32_e32 v166, v22
		v_exp_f32_e32 v218, v23
		v_exp_f32_e32 v22, v10
		v_exp_f32_e32 v220, v11
		v_exp_f32_e32 v10, v168
		v_exp_f32_e32 v222, v169
		v_exp_f32_e32 v168, v100
		v_exp_f32_e32 v224, v101
		v_exp_f32_e32 v100, v170
		v_exp_f32_e32 v226, v171
		v_exp_f32_e32 v170, v102
		v_exp_f32_e32 v228, v103
		v_exp_f32_e32 v102, v172
		v_exp_f32_e32 v230, v173
		v_exp_f32_e32 v172, v24
		v_exp_f32_e32 v232, v25
		v_exp_f32_e32 v24, v174
		v_exp_f32_e32 v234, v175
		v_exp_f32_e32 v174, v112
		v_exp_f32_e32 v236, v113
		v_exp_f32_e32 v112, v176
		v_exp_f32_e32 v238, v177
		v_exp_f32_e32 v176, v186
		v_exp_f32_e32 v240, v187
		v_exp_f32_e32 v186, v200
		v_exp_f32_e32 v242, v201
		v_exp_f32_e32 v200, v190
		v_exp_f32_e32 v244, v191
		v_exp_f32_e32 v141, v202
		v_exp_f32_e32 v163, v203
		v_exp_f32_e32 v165, v198
		v_exp_f32_e32 v217, v199
		v_exp_f32_e32 v167, v204
		v_exp_f32_e32 v219, v205
		v_exp_f32_e32 v23, v160
		v_exp_f32_e32 v221, v161
		v_exp_f32_e32 v11, v206
		v_exp_f32_e32 v223, v207
		v_exp_f32_e32 v169, v134
		v_exp_f32_e32 v225, v135
		v_exp_f32_e32 v101, v208
		v_exp_f32_e32 v227, v209
		v_exp_f32_e32 v171, v210
		v_exp_f32_e32 v229, v211
		v_exp_f32_e32 v103, v212
		v_exp_f32_e32 v231, v213
		v_exp_f32_e32 v173, v142
		v_exp_f32_e32 v233, v143
		v_exp_f32_e32 v25, v144
		v_exp_f32_e32 v235, v145
		v_exp_f32_e32 v175, v146
		v_exp_f32_e32 v237, v147
		v_exp_f32_e32 v113, v148
		v_exp_f32_e32 v239, v149
		v_exp_f32_e32 v177, v150
		v_exp_f32_e32 v241, v151
		v_exp_f32_e32 v187, v152
		v_exp_f32_e32 v243, v153
		v_exp_f32_e32 v201, v154
		v_exp_f32_e32 v245, v155
		v_exp_f32_e32 v134, v156
		v_exp_f32_e32 v142, v157
		v_exp_f32_e32 v144, v138
		v_exp_f32_e32 v146, v139
		v_exp_f32_e32 v138, v214
		v_exp_f32_e32 v148, v215
		v_exp_f32_e32 v150, v178
		v_exp_f32_e32 v152, v179
		v_exp_f32_e32 v154, v180
		v_exp_f32_e32 v156, v181
		v_exp_f32_e32 v160, v16
		v_exp_f32_e32 v178, v17
		v_exp_f32_e32 v16, v30
		v_exp_f32_e32 v180, v31
		v_exp_f32_e32 v30, v18
		v_exp_f32_e32 v190, v19
		v_exp_f32_e32 v18, v98
		v_exp_f32_e32 v198, v99
		v_exp_f32_e32 v98, v104
		v_exp_f32_e32 v202, v105
		v_exp_f32_e32 v104, v106
		v_exp_f32_e32 v204, v107
		v_exp_f32_e32 v106, v108
		v_exp_f32_e32 v206, v109
		v_exp_f32_e32 v108, v110
		v_exp_f32_e32 v208, v111
		v_exp_f32_e32 v110, v26
		v_exp_f32_e32 v210, v27
		v_exp_f32_e32 v26, v28
		v_exp_f32_e32 v212, v29
		v_exp_f32_e32 v28, v114
		v_exp_f32_e32 v214, v115
		v_exp_f32_e32 v135, v182
		v_exp_f32_e32 v143, v183
		v_exp_f32_e32 v145, v116
		v_exp_f32_e32 v147, v117
		v_exp_f32_e32 v139, v184
		v_exp_f32_e32 v149, v185
		v_exp_f32_e32 v151, v120
		v_exp_f32_e32 v153, v121
		v_exp_f32_e32 v155, v188
		v_exp_f32_e32 v157, v189
		v_exp_f32_e32 v161, v192
		v_exp_f32_e32 v179, v193
		v_exp_f32_e32 v17, v194
		v_exp_f32_e32 v181, v195
		v_exp_f32_e32 v31, v124
		v_exp_f32_e32 v191, v125
		v_exp_f32_e32 v19, v196
		v_exp_f32_e32 v199, v197
		v_exp_f32_e32 v99, v118
		v_exp_f32_e32 v203, v119
		v_exp_f32_e32 v105, v128
		v_exp_f32_e32 v205, v129
		v_exp_f32_e32 v107, v122
		v_exp_f32_e32 v207, v123
		v_exp_f32_e32 v109, v126
		v_exp_f32_e32 v209, v127
		v_exp_f32_e32 v111, v130
		v_exp_f32_e32 v211, v131
		v_exp_f32_e32 v27, v132
		v_exp_f32_e32 v213, v133
		v_exp_f32_e32 v29, v136
		v_exp_f32_e32 v215, v137
		v_pk_add_f32 v[114:115], v[140:141], v[162:163]
		v_pk_add_f32 v[116:117], v[164:165], v[216:217]
		v_pk_add_f32 v[118:119], v[166:167], v[218:219]
		v_pk_add_f32 v[120:121], v[22:23], v[220:221]
		v_pk_add_f32 v[122:123], v[10:11], v[222:223]
		v_pk_add_f32 v[124:125], v[168:169], v[224:225]
		v_pk_add_f32 v[126:127], v[100:101], v[226:227]
		v_pk_add_f32 v[128:129], v[170:171], v[228:229]
		v_pk_add_f32 v[130:131], v[102:103], v[230:231]
		v_pk_add_f32 v[132:133], v[172:173], v[232:233]
		v_pk_add_f32 v[136:137], v[24:25], v[234:235]
		v_pk_add_f32 v[182:183], v[174:175], v[236:237]
		v_pk_add_f32 v[184:185], v[112:113], v[238:239]
		v_pk_add_f32 v[188:189], v[176:177], v[240:241]
		v_pk_add_f32 v[192:193], v[186:187], v[242:243]
		v_pk_add_f32 v[194:195], v[200:201], v[244:245]
		v_pk_add_f32 v[114:115], v[114:115], v[116:117]
		v_pk_add_f32 v[116:117], v[118:119], v[120:121]
		v_pk_add_f32 v[118:119], v[122:123], v[124:125]
		v_pk_add_f32 v[120:121], v[126:127], v[128:129]
		v_pk_add_f32 v[122:123], v[130:131], v[132:133]
		v_pk_add_f32 v[124:125], v[136:137], v[182:183]
		v_pk_add_f32 v[126:127], v[184:185], v[188:189]
		v_pk_add_f32 v[128:129], v[192:193], v[194:195]
		v_pk_add_f32 v[114:115], v[114:115], v[116:117]
		v_pk_add_f32 v[116:117], v[118:119], v[120:121]
		v_pk_add_f32 v[118:119], v[122:123], v[124:125]
		v_pk_add_f32 v[120:121], v[126:127], v[128:129]
		v_pk_add_f32 v[114:115], v[114:115], v[116:117]
		v_pk_add_f32 v[116:117], v[118:119], v[120:121]
		v_pk_add_f32 v[118:119], v[114:115], v[116:117]
		v_add_f32_e32 v5, v118, v119
		v_accvgpr_read_b32 v6, a76
		ds_bpermute_b32 v114, v6, v5
		v_accvgpr_read_b32 v6, a77
		ds_bpermute_b32 v116, v6, v5
		v_pk_add_f32 v[118:119], v[134:135], v[142:143]
		v_pk_add_f32 v[120:121], v[144:145], v[146:147]
		v_pk_add_f32 v[122:123], v[138:139], v[148:149]
		v_pk_add_f32 v[124:125], v[150:151], v[152:153]
		v_pk_add_f32 v[126:127], v[154:155], v[156:157]
		v_pk_add_f32 v[128:129], v[160:161], v[178:179]
		v_pk_add_f32 v[130:131], v[16:17], v[180:181]
		v_pk_add_f32 v[132:133], v[30:31], v[190:191]
		v_pk_add_f32 v[136:137], v[18:19], v[198:199]
		v_pk_add_f32 v[182:183], v[98:99], v[202:203]
		v_pk_add_f32 v[184:185], v[104:105], v[204:205]
		v_pk_add_f32 v[188:189], v[106:107], v[206:207]
		v_pk_add_f32 v[192:193], v[108:109], v[208:209]
		v_pk_add_f32 v[194:195], v[110:111], v[210:211]
		v_pk_add_f32 v[196:197], v[26:27], v[212:213]
		v_pk_add_f32 v[246:247], v[28:29], v[214:215]
		v_pk_add_f32 v[118:119], v[118:119], v[120:121]
		v_pk_add_f32 v[120:121], v[122:123], v[124:125]
		v_pk_add_f32 v[122:123], v[126:127], v[128:129]
		v_pk_add_f32 v[124:125], v[130:131], v[132:133]
		v_pk_add_f32 v[126:127], v[136:137], v[182:183]
		v_pk_add_f32 v[128:129], v[184:185], v[188:189]
		v_pk_add_f32 v[130:131], v[192:193], v[194:195]
		v_pk_add_f32 v[132:133], v[196:197], v[246:247]
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
		v_cvt_pk_bf16_f32 v120, v140, v162
		v_cvt_pk_bf16_f32 v121, v164, v216
		v_permlane32_swap_b32_e32 v114, v115
		v_add_f32_e32 v117, v114, v115
		v_mov_b32_e32 v97, v8
		v_pk_add_f32 v[8:9], v[96:97], v[158:159] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v96, v8
		v_exp_f32_e32 v97, v9
		v_cvt_pk_bf16_f32 v122, v166, v218
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
		v_mov_b64_e32 v[8:9], v[14:15]
		v_pk_fma_f32 v[14:15], v[8:9], v[96:97], v[116:117]
		v_cvt_pk_bf16_f32 v123, v22, v220
		v_cvt_pk_bf16_f32 v116, v10, v222
		v_cvt_pk_bf16_f32 v117, v168, v224
		v_cvt_pk_bf16_f32 v118, v100, v226
		v_cvt_pk_bf16_f32 v119, v170, v228
		v_cvt_pk_bf16_f32 v124, v102, v230
		v_cvt_pk_bf16_f32 v125, v172, v232
		v_cvt_pk_bf16_f32 v126, v24, v234
		v_cvt_pk_bf16_f32 v127, v174, v236
		v_cvt_pk_bf16_f32 v128, v112, v238
		v_cvt_pk_bf16_f32 v129, v176, v240
		v_cvt_pk_bf16_f32 v130, v186, v242
		v_cvt_pk_bf16_f32 v131, v200, v244
		v_cvt_pk_bf16_f32 v192, v141, v163
		v_cvt_pk_bf16_f32 v193, v165, v217
		v_cvt_pk_bf16_f32 v194, v167, v219
		v_cvt_pk_bf16_f32 v195, v23, v221
		v_cvt_pk_bf16_f32 v164, v11, v223
		v_cvt_pk_bf16_f32 v165, v169, v225
		v_cvt_pk_bf16_f32 v166, v101, v227
		v_cvt_pk_bf16_f32 v167, v171, v229
		v_cvt_pk_bf16_f32 v8, v103, v231
		v_cvt_pk_bf16_f32 v9, v173, v233
		v_cvt_pk_bf16_f32 v10, v25, v235
		v_cvt_pk_bf16_f32 v11, v175, v237
		v_cvt_pk_bf16_f32 v100, v113, v239
		v_cvt_pk_bf16_f32 v101, v177, v241
		v_cvt_pk_bf16_f32 v102, v187, v243
		v_cvt_pk_bf16_f32 v103, v201, v245
		v_cvt_pk_bf16_f32 v112, v134, v142
		v_cvt_pk_bf16_f32 v113, v144, v146
		v_cvt_pk_bf16_f32 v114, v138, v148
		v_cvt_pk_bf16_f32 v115, v150, v152
		v_cvt_pk_bf16_f32 v168, v154, v156
		v_cvt_pk_bf16_f32 v169, v160, v178
		v_cvt_pk_bf16_f32 v170, v16, v180
		v_cvt_pk_bf16_f32 v171, v30, v190
		v_cvt_pk_bf16_f32 v172, v18, v198
		v_cvt_pk_bf16_f32 v173, v98, v202
		v_cvt_pk_bf16_f32 v174, v104, v204
		v_cvt_pk_bf16_f32 v175, v106, v206
		v_cvt_pk_bf16_f32 v184, v108, v208
		v_cvt_pk_bf16_f32 v185, v110, v210
		v_cvt_pk_bf16_f32 v186, v26, v212
		v_cvt_pk_bf16_f32 v187, v28, v214
		v_cvt_pk_bf16_f32 v216, v135, v143
		v_cvt_pk_bf16_f32 v217, v145, v147
		v_cvt_pk_bf16_f32 v218, v139, v149
		v_cvt_pk_bf16_f32 v219, v151, v153
		v_cvt_pk_bf16_f32 v132, v155, v157
		v_cvt_pk_bf16_f32 v133, v161, v179
		v_cvt_pk_bf16_f32 v134, v17, v181
		v_cvt_pk_bf16_f32 v135, v31, v191
		v_cvt_pk_bf16_f32 v136, v19, v199
		v_cvt_pk_bf16_f32 v137, v99, v203
		v_cvt_pk_bf16_f32 v138, v105, v205
		v_cvt_pk_bf16_f32 v139, v107, v207
		v_cvt_pk_bf16_f32 v16, v109, v209
		v_cvt_pk_bf16_f32 v17, v111, v211
		v_cvt_pk_bf16_f32 v18, v27, v213
		v_cvt_pk_bf16_f32 v19, v29, v215
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
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[124:127], v[32:47]
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[124:127], v[48:63]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[128:131], v[32:47]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[128:131], v[48:63]
		v_permlane32_swap_b32_e32 v168, v170
		v_permlane32_swap_b32_e32 v169, v171
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[112:115], v[80:95]
		v_permlane32_swap_b32_e32 v172, v174
		v_permlane32_swap_b32_e32 v173, v175
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[112:115], v[64:79]
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[168:171], v[80:95]
		v_permlane32_swap_b32_e32 v216, v218
		v_permlane32_swap_b32_e32 v217, v219
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[168:171], v[64:79]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[172:175], v[80:95]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[172:175], v[64:79]
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[184:187], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[184:187], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[192:195], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[192:195], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[216:219], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[216:219], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[164:167], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[164:167], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[132:135], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[132:135], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[216:219], v[8:11], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[248:251], v[8:11], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[248:251], v[136:139], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[216:219], v[136:139], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[220:223], v[100:103], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[252:255], v[100:103], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[252:255], v[16:19], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[220:223], v[16:19], v[64:79]
		s_cselect_b32 s19, 1, 0
		s_add_i32 s33, s43, 0x80
		s_cmp_lg_u32 s19, 0
		s_mov_b32 s43, s33
		v_mov_b32_e32 v5, v158
		v_mov_b32_e32 v8, v159
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_2
.L_attn_fwd_persistent.loop_exit_2:
		s_mov_b32 s24, s8
		s_mov_b32 s25, s9
		s_mov_b32 s26, s38
		s_mov_b32 s27, s39
		v_rcp_f32_e32 v2, v14
		v_accvgpr_read_b32 v1, a11
		s_nop 0
		v_readfirstlane_b32 s19, v1
		s_mul_i32 s19, s19, s18
		v_mov_b32_e32 v3, v2
		v_pk_mul_f32 v[4:5], v[32:33], v[2:3]
		v_pk_mul_f32 v[6:7], v[34:35], v[2:3]
		v_pk_mul_f32 v[8:9], v[36:37], v[2:3]
		v_pk_mul_f32 v[10:11], v[38:39], v[2:3]
		v_pk_mul_f32 v[12:13], v[40:41], v[2:3]
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
		v_rcp_f32_e32 v2, v15
		v_cvt_pk_bf16_f32 v40, v4, v5
		v_mov_b32_e32 v3, v2
		v_pk_mul_f32 v[4:5], v[64:65], v[2:3]
		v_pk_mul_f32 v[14:15], v[66:67], v[2:3]
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
		v_cvt_pk_bf16_f32 v25, v14, v15
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
		s_lshl_b32 s19, s19, 9
		v_accvgpr_read_b32 v1, a2
		s_nop 0
		v_readfirstlane_b32 s22, v1
		v_mov_b32_e32 v1, s1
		s_nop 0
		v_readfirstlane_b32 s23, v1
		s_mul_i32 s22, s23, s22
		s_lshl_b32 s22, s22, 1
		s_add_i32 s23, s19, s22
		v_accvgpr_read_b32 v1, a3
		s_nop 0
		v_readfirstlane_b32 s28, v1
		v_accvgpr_read_b32 v1, a10
		s_nop 0
		v_readfirstlane_b32 s29, v1
		s_mul_i32 s28, s29, s28
		s_lshl_b32 s28, s28, 1
		s_add_i32 s23, s23, s28
		v_accvgpr_read_b32 v1, a12
		v_mul_lo_u32 v1, s18, v1
		v_lshl_add_u32 v2, v1, 6, s23
		v_accvgpr_read_b32 v3, a15
		v_mul_lo_u32 v3, s18, v3
		v_lshl_add_u32 v2, v3, 1, v2
		v_accvgpr_read_b32 v32, a19
		v_mul_lo_u32 v32, s18, v32
		v_lshl_add_u32 v2, v32, 5, v2
		v_accvgpr_read_b32 v33, a21
		v_mul_lo_u32 v33, s18, v33
		v_lshl_add_u32 v2, v33, 4, v2
		v_accvgpr_read_b32 v34, a16
		v_mul_lo_u32 v34, s18, v34
		v_lshl_add_u32 v2, v34, 3, v2
		v_accvgpr_read_b32 v35, a17
		v_mul_lo_u32 v35, s18, v35
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v36, a18
		v_lshl_add_u32 v2, v36, 4, v2
		v_accvgpr_read_b32 v36, a56
		s_nop 0
		v_readfirstlane_b32 s30, v36
		v_accvgpr_read_b32 v36, a57
		s_nop 0
		v_readfirstlane_b32 s31, v36
		s_and_saveexec_b64 s[94:95], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_8
		buffer_store_dwordx4 v[40:43], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_8:
		s_andn2_b64 exec, s[94:95], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_8
.L_attn_fwd_persistent.exec_endif_8:
		s_mov_b64 exec, s[94:95]
		s_add_i32 s23, s19, 32
		s_add_i32 s23, s23, s22
		s_add_i32 s23, s23, s28
		v_lshl_add_u32 v2, v1, 6, s23
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v36, a18
		v_lshl_add_u32 v2, v36, 4, v2
		v_accvgpr_read_b32 v36, a56
		s_nop 0
		v_readfirstlane_b32 s30, v36
		v_accvgpr_read_b32 v36, a57
		s_nop 0
		v_readfirstlane_b32 s31, v36
		s_and_saveexec_b64 s[94:95], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_9
		buffer_store_dwordx4 v[8:11], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_9:
		s_andn2_b64 exec, s[94:95], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_9
.L_attn_fwd_persistent.exec_endif_9:
		s_mov_b64 exec, s[94:95]
		s_add_i32 s23, s19, 64
		s_add_i32 s23, s23, s22
		s_add_i32 s23, s23, s28
		v_lshl_add_u32 v2, v1, 6, s23
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v8, a18
		v_lshl_add_u32 v2, v8, 4, v2
		v_accvgpr_read_b32 v8, a56
		s_nop 0
		v_readfirstlane_b32 s30, v8
		v_accvgpr_read_b32 v8, a57
		s_nop 0
		v_readfirstlane_b32 s31, v8
		s_and_saveexec_b64 s[94:95], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_10
		buffer_store_dwordx4 v[16:19], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_10:
		s_andn2_b64 exec, s[94:95], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_10
.L_attn_fwd_persistent.exec_endif_10:
		s_mov_b64 exec, s[94:95]
		s_add_i32 s23, s19, 0x60
		s_add_i32 s23, s23, s22
		s_add_i32 s23, s23, s28
		v_lshl_add_u32 v2, v1, 6, s23
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v8, a18
		v_lshl_add_u32 v2, v8, 4, v2
		v_accvgpr_read_b32 v8, a56
		s_nop 0
		v_readfirstlane_b32 s30, v8
		v_accvgpr_read_b32 v8, a57
		s_nop 0
		v_readfirstlane_b32 s31, v8
		s_and_saveexec_b64 s[94:95], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_11
		buffer_store_dwordx4 v[20:23], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_11:
		s_andn2_b64 exec, s[94:95], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_11
.L_attn_fwd_persistent.exec_endif_11:
		s_mov_b64 exec, s[94:95]
		s_lshl_b32 s23, s18, 8
		s_add_i32 s29, s23, s19
		s_add_i32 s29, s29, s22
		s_add_i32 s29, s29, s28
		v_lshl_add_u32 v2, v1, 6, s29
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v8, a18
		v_lshl_add_u32 v2, v8, 4, v2
		v_accvgpr_read_b32 v8, a58
		s_nop 0
		v_readfirstlane_b32 s30, v8
		v_accvgpr_read_b32 v8, a59
		s_nop 0
		v_readfirstlane_b32 s31, v8
		s_and_saveexec_b64 s[94:95], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_12
		buffer_store_dwordx4 v[24:27], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_12:
		s_andn2_b64 exec, s[94:95], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_12
.L_attn_fwd_persistent.exec_endif_12:
		s_mov_b64 exec, s[94:95]
		s_add_i32 s29, s23, 32
		s_add_i32 s29, s29, s19
		s_add_i32 s29, s29, s22
		s_add_i32 s29, s29, s28
		v_lshl_add_u32 v2, v1, 6, s29
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v8, a18
		v_lshl_add_u32 v2, v8, 4, v2
		v_accvgpr_read_b32 v8, a58
		s_nop 0
		v_readfirstlane_b32 s30, v8
		v_accvgpr_read_b32 v8, a59
		s_nop 0
		v_readfirstlane_b32 s31, v8
		s_and_saveexec_b64 s[94:95], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_13
		buffer_store_dwordx4 v[4:7], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_13:
		s_andn2_b64 exec, s[94:95], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_13
.L_attn_fwd_persistent.exec_endif_13:
		s_mov_b64 exec, s[94:95]
		s_add_i32 s29, s23, 64
		s_add_i32 s29, s29, s19
		s_add_i32 s29, s29, s22
		s_add_i32 s29, s29, s28
		v_lshl_add_u32 v2, v1, 6, s29
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v4, a18
		v_lshl_add_u32 v2, v4, 4, v2
		v_accvgpr_read_b32 v4, a58
		s_nop 0
		v_readfirstlane_b32 s30, v4
		v_accvgpr_read_b32 v4, a59
		s_nop 0
		v_readfirstlane_b32 s31, v4
		s_and_saveexec_b64 s[94:95], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_14
		buffer_store_dwordx4 v[12:15], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_14:
		s_andn2_b64 exec, s[94:95], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_14
.L_attn_fwd_persistent.exec_endif_14:
		s_mov_b64 exec, s[94:95]
		s_add_i32 s23, s23, 0x60
		s_add_i32 s19, s23, s19
		s_add_i32 s19, s19, s22
		s_add_i32 s19, s19, s28
		v_lshl_add_u32 v1, v1, 6, s19
		v_lshl_add_u32 v1, v3, 1, v1
		v_lshl_add_u32 v1, v32, 5, v1
		v_lshl_add_u32 v1, v33, 4, v1
		v_lshl_add_u32 v1, v34, 3, v1
		v_lshl_add_u32 v1, v35, 2, v1
		v_accvgpr_read_b32 v2, a18
		v_lshl_add_u32 v1, v2, 4, v1
		v_accvgpr_read_b32 v2, a58
		s_nop 0
		v_readfirstlane_b32 s22, v2
		v_accvgpr_read_b32 v2, a59
		s_nop 0
		v_readfirstlane_b32 s23, v2
		s_and_saveexec_b64 s[94:95], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_15
		buffer_store_dwordx4 v[28:31], v1, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_15:
		s_andn2_b64 exec, s[94:95], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_15
.L_attn_fwd_persistent.exec_endif_15:
		s_mov_b64 exec, s[94:95]
		s_branch .L_attn_fwd_persistent.if_end_1
.L_attn_fwd_persistent.if_else_1:
.L_attn_fwd_persistent.if_end_1:
		s_and_b32 s19, s0, 15
		s_mul_i32 s19, s19, 2
		s_add_i32 s19, s19, 1
		s_cmp_lt_i32 s19, 32
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_3
		s_lshr_b32 s22, s19, 1
		s_and_b32 s19, s19, 1
		s_xor_b32 s23, s22, -1
		s_add_i32 s23, s23, 1
		s_add_i32 s23, s23, 31
		s_cmp_eq_u32 s19, 0
		s_cselect_b32 s19, s22, s23
		v_mov_b32_e32 v1, s19
		v_accvgpr_write_b32 a11, v1
		v_accvgpr_read_b32 v1, a11
		s_nop 0
		v_readfirstlane_b32 s19, v1
		s_mul_i32 s19, s19, 0x100
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
		v_accvgpr_write_b32 a12, v13
		v_accvgpr_read_b32 v13, a12
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v14, 32
		v_mul_lo_u32 v14, v14, v13
		v_bitop3_b32 v5, v5, v12, v14 bitop3:0x96
		v_lshrrev_b32_e32 v15, 7, v0
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v16, 64
		v_mul_lo_u32 v16, v16, v15
		v_xor_b32_e32 v5, v5, v16
		v_accvgpr_write_b32 a13, v5
		v_xor_b32_e32 v1, 0x80, v1
		v_xor_b32_e32 v1, v1, v4
		v_xor_b32_e32 v1, v1, v6
		v_bitop3_b32 v1, v1, v9, v12 bitop3:0x96
		v_bitop3_b32 v1, v1, v14, v16 bitop3:0x96
		v_accvgpr_write_b32 a14, v1
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
		v_xad_u32 v9, v9, v14, s19
		v_bitop3_b32 v16, 32, v8, v1 bitop3:0x96
		v_bitop3_b32 v16, v16, v6, v12 bitop3:0x96
		v_xad_u32 v16, v16, v14, s19
		v_bitop3_b32 v17, 64, v8, v1 bitop3:0x96
		v_bitop3_b32 v17, v17, v6, v12 bitop3:0x96
		v_xad_u32 v17, v17, v14, s19
		v_xor_b32_e32 v18, 0x60, v8
		v_xor_b32_e32 v18, v18, v1
		v_xor_b32_e32 v18, v18, v6
		v_xor_b32_e32 v18, v18, v12
		v_xad_u32 v18, v18, v14, s19
		v_xor_b32_e32 v19, 0x80, v8
		v_xor_b32_e32 v19, v19, v1
		v_xor_b32_e32 v19, v19, v6
		v_xor_b32_e32 v19, v19, v12
		v_xad_u32 v19, v19, v14, s19
		v_xor_b32_e32 v20, 0xa0, v8
		v_xor_b32_e32 v20, v20, v1
		v_xor_b32_e32 v20, v20, v6
		v_xor_b32_e32 v20, v20, v12
		v_xad_u32 v20, v20, v14, s19
		v_xor_b32_e32 v21, 0xc0, v8
		v_xor_b32_e32 v21, v21, v1
		v_xor_b32_e32 v21, v21, v6
		v_xor_b32_e32 v21, v21, v12
		v_xad_u32 v21, v21, v14, s19
		v_xor_b32_e32 v22, 0xe0, v8
		v_xor_b32_e32 v1, v22, v1
		v_xor_b32_e32 v1, v1, v6
		v_xor_b32_e32 v1, v1, v12
		v_xad_u32 v1, v1, v14, s19
		v_cmp_lt_i32_e64 s[22:23], v9, s20
		v_cmp_lt_i32_e64 s[24:25], v16, s20
		v_cmp_lt_i32_e64 s[26:27], v17, s20
		v_cmp_lt_i32_e64 s[28:29], v18, s20
		v_cmp_lt_i32_e64 s[30:31], v19, s20
		v_cmp_lt_i32_e64 s[32:33], v20, s20
		v_cmp_lt_i32_e64 s[34:35], v21, s20
		s_mov_b32 s38, 0x7fffffff
		s_mov_b32 s39, 0x31016000
		s_mov_b32 s36, s2
		s_mov_b32 s37, s3
		v_accvgpr_read_b32 v9, a6
		v_and_b32_e32 v9, 0xffff, v9
		v_lshlrev_b32_e32 v12, 16, v9
		v_or_b32_e32 v16, v9, v12
		v_mov_b32_e32 v17, v16
		v_mov_b32_e32 v18, v16
		v_mov_b32_e32 v19, v16
		v_accvgpr_read_b32 v9, a11
		s_nop 0
		v_readfirstlane_b32 s40, v9
		s_mul_i32 s40, s40, s12
		s_lshl_b32 s40, s40, 9
		v_mov_b32_e32 v9, s1
		v_accvgpr_write_b32 a15, v9
		v_accvgpr_read_b32 v9, a15
		s_nop 0
		v_readfirstlane_b32 s1, v9
		s_mul_i32 s1, s1, s10
		s_lshl_b32 s1, s1, 1
		s_add_i32 s41, s40, s1
		v_accvgpr_read_b32 v9, a10
		s_nop 0
		v_readfirstlane_b32 s42, v9
		s_mul_i32 s42, s42, s11
		s_lshl_b32 s42, s42, 1
		s_add_i32 s41, s41, s42
		v_mul_lo_u32 v9, s12, v7
		v_lshl_add_u32 v12, v9, 1, s41
		v_and_b32_e32 v14, 1, v0
		v_accvgpr_write_b32 a16, v14
		v_accvgpr_read_b32 v14, a16
		v_lshl_add_u32 v12, v14, 4, v12
		v_and_b32_e32 v14, 1, v3
		v_accvgpr_write_b32 a17, v14
		v_accvgpr_read_b32 v14, a17
		v_lshl_add_u32 v12, v14, 6, v12
		v_and_b32_e32 v2, 1, v2
		v_accvgpr_write_b32 a18, v2
		v_accvgpr_read_b32 v2, a18
		v_lshl_add_u32 v2, v2, 5, v12
		s_and_saveexec_b64 s[94:95], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_16
		buffer_load_dwordx4 v[20:23], v2, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_16:
		s_andn2_b64 exec, s[94:95], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_16
		v_mov_b32_e32 v20, v16
		v_mov_b32_e32 v21, v17
		v_mov_b32_e32 v22, v18
		v_mov_b32_e32 v23, v19
.L_attn_fwd_persistent.exec_endif_16:
		s_mov_b64 exec, s[94:95]
		s_lshl_b32 s22, s12, 6
		s_add_i32 s22, s22, s40
		s_add_i32 s22, s22, s1
		s_add_i32 s22, s22, s42
		v_lshl_add_u32 v2, v9, 1, s22
		v_accvgpr_read_b32 v12, a16
		v_lshl_add_u32 v2, v12, 4, v2
		v_accvgpr_read_b32 v12, a17
		v_lshl_add_u32 v2, v12, 6, v2
		v_accvgpr_read_b32 v12, a18
		v_lshl_add_u32 v2, v12, 5, v2
		s_and_saveexec_b64 s[94:95], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_17
		buffer_load_dwordx4 v[24:27], v2, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_17:
		s_andn2_b64 exec, s[94:95], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_17
		v_mov_b32_e32 v24, v16
		v_mov_b32_e32 v25, v17
		v_mov_b32_e32 v26, v18
		v_mov_b32_e32 v27, v19
.L_attn_fwd_persistent.exec_endif_17:
		s_mov_b64 exec, s[94:95]
		s_lshl_b32 s22, s12, 7
		s_add_i32 s22, s22, s40
		s_add_i32 s22, s22, s1
		s_add_i32 s22, s22, s42
		v_lshl_add_u32 v2, v9, 1, s22
		v_accvgpr_read_b32 v12, a16
		v_lshl_add_u32 v2, v12, 4, v2
		v_accvgpr_read_b32 v12, a17
		v_lshl_add_u32 v2, v12, 6, v2
		v_accvgpr_read_b32 v12, a18
		v_lshl_add_u32 v2, v12, 5, v2
		s_and_saveexec_b64 s[94:95], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_18
		buffer_load_dwordx4 v[28:31], v2, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_18:
		s_andn2_b64 exec, s[94:95], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_18
		v_mov_b32_e32 v28, v16
		v_mov_b32_e32 v29, v17
		v_mov_b32_e32 v30, v18
		v_mov_b32_e32 v31, v19
.L_attn_fwd_persistent.exec_endif_18:
		s_mov_b64 exec, s[94:95]
		s_mul_i32 s22, 0xc0, s12
		s_add_i32 s22, s22, s40
		s_add_i32 s22, s22, s1
		s_add_i32 s22, s22, s42
		v_lshl_add_u32 v2, v9, 1, s22
		v_accvgpr_read_b32 v12, a16
		v_lshl_add_u32 v2, v12, 4, v2
		v_accvgpr_read_b32 v12, a17
		v_lshl_add_u32 v2, v12, 6, v2
		v_accvgpr_read_b32 v12, a18
		v_lshl_add_u32 v2, v12, 5, v2
		s_and_saveexec_b64 s[94:95], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_19
		buffer_load_dwordx4 v[32:35], v2, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_19:
		s_andn2_b64 exec, s[94:95], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_19
		v_mov_b32_e32 v32, v16
		v_mov_b32_e32 v33, v17
		v_mov_b32_e32 v34, v18
		v_mov_b32_e32 v35, v19
.L_attn_fwd_persistent.exec_endif_19:
		s_mov_b64 exec, s[94:95]
		s_lshl_b32 s22, s12, 8
		s_add_i32 s22, s22, s40
		s_add_i32 s22, s22, s1
		s_add_i32 s22, s22, s42
		v_lshl_add_u32 v2, v9, 1, s22
		v_accvgpr_read_b32 v12, a16
		v_lshl_add_u32 v2, v12, 4, v2
		v_accvgpr_read_b32 v12, a17
		v_lshl_add_u32 v2, v12, 6, v2
		v_accvgpr_read_b32 v12, a18
		v_lshl_add_u32 v2, v12, 5, v2
		s_and_saveexec_b64 s[94:95], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_20
		buffer_load_dwordx4 v[36:39], v2, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_20:
		s_andn2_b64 exec, s[94:95], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_20
		v_mov_b32_e32 v36, v16
		v_mov_b32_e32 v37, v17
		v_mov_b32_e32 v38, v18
		v_mov_b32_e32 v39, v19
.L_attn_fwd_persistent.exec_endif_20:
		s_mov_b64 exec, s[94:95]
		s_mul_i32 s22, 0x140, s12
		s_add_i32 s22, s22, s40
		s_add_i32 s22, s22, s1
		s_add_i32 s22, s22, s42
		v_lshl_add_u32 v2, v9, 1, s22
		v_accvgpr_read_b32 v12, a16
		v_lshl_add_u32 v2, v12, 4, v2
		v_accvgpr_read_b32 v12, a17
		v_lshl_add_u32 v2, v12, 6, v2
		v_accvgpr_read_b32 v12, a18
		v_lshl_add_u32 v2, v12, 5, v2
		s_and_saveexec_b64 s[94:95], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_21
		buffer_load_dwordx4 v[40:43], v2, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_21:
		s_andn2_b64 exec, s[94:95], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_21
		v_mov_b32_e32 v40, v16
		v_mov_b32_e32 v41, v17
		v_mov_b32_e32 v42, v18
		v_mov_b32_e32 v43, v19
.L_attn_fwd_persistent.exec_endif_21:
		s_mov_b64 exec, s[94:95]
		s_mul_i32 s22, 0x180, s12
		s_add_i32 s22, s22, s40
		s_add_i32 s22, s22, s1
		s_add_i32 s22, s22, s42
		v_lshl_add_u32 v2, v9, 1, s22
		v_accvgpr_read_b32 v12, a16
		v_lshl_add_u32 v2, v12, 4, v2
		v_accvgpr_read_b32 v12, a17
		v_lshl_add_u32 v2, v12, 6, v2
		v_accvgpr_read_b32 v12, a18
		v_lshl_add_u32 v2, v12, 5, v2
		s_and_saveexec_b64 s[94:95], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_22
		buffer_load_dwordx4 v[44:47], v2, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_22:
		s_andn2_b64 exec, s[94:95], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_22
		v_mov_b32_e32 v44, v16
		v_mov_b32_e32 v45, v17
		v_mov_b32_e32 v46, v18
		v_mov_b32_e32 v47, v19
.L_attn_fwd_persistent.exec_endif_22:
		s_mov_b64 exec, s[94:95]
		s_mul_i32 s22, 0x1c0, s12
		s_add_i32 s22, s22, s40
		s_add_i32 s1, s22, s1
		s_add_i32 s1, s1, s42
		v_lshl_add_u32 v2, v9, 1, s1
		v_accvgpr_read_b32 v9, a16
		v_lshl_add_u32 v2, v9, 4, v2
		v_accvgpr_read_b32 v9, a17
		v_lshl_add_u32 v2, v9, 6, v2
		v_accvgpr_read_b32 v9, a18
		v_lshl_add_u32 v2, v9, 5, v2
		v_cmp_lt_i32_e64 vcc, v1, s20
		s_and_saveexec_b64 s[94:95], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_23
		buffer_load_dwordx4 v[48:51], v2, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_23:
		s_andn2_b64 exec, s[94:95], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_23
		v_mov_b32_e32 v48, v16
		v_mov_b32_e32 v49, v17
		v_mov_b32_e32 v50, v18
		v_mov_b32_e32 v51, v19
.L_attn_fwd_persistent.exec_endif_23:
		s_mov_b64 exec, s[94:95]
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
		v_and_b32_e32 v1, 1, v4
		v_accvgpr_write_b32 a19, v1
		v_accvgpr_read_b32 v1, a19
		v_lshlrev_b32_e32 v1, 1, v1
		v_accvgpr_read_b32 v2, a12
		v_and_b32_e32 v2, 1, v2
		v_lshlrev_b32_e32 v2, 2, v2
		v_and_b32_e32 v4, 1, v10
		v_accvgpr_write_b32 a20, v4
		v_accvgpr_read_b32 v4, a20
		v_xor_b32_e32 v2, v2, v4
		v_bitop3_b32 v1, v0, v1, v2 bitop3:0x96
		v_lshlrev_b32_e32 v1, 4, v1
		v_add_u32_e32 v1, 0x10000, v1
		ds_write_b128 v1, v[20:23] offset:18864
		ds_write_b128 v1, v[24:27] offset:22960
		ds_write_b128 v1, v[28:31] offset:27056
		ds_write_b128 v1, v[32:35] offset:31152
		v_mov_b32_e32 v2, 32
		v_mul_lo_u32 v2, v2, v11
		v_mov_b32_e32 v4, 2
		v_mul_lo_u32 v4, v4, v15
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v9, a12
		v_lshlrev_b32_e32 v9, 12, v9
		v_add_u32_e32 v9, 0x10000, v9
		v_and_b32_e32 v10, 63, v0
		v_lshrrev_b32_e32 v11, 5, v10
		v_accvgpr_write_b32 a21, v11
		v_lshrrev_b32_e32 v11, 4, v10
		v_and_b32_e32 v11, 1, v11
		v_lshlrev_b32_e32 v11, 7, v11
		v_accvgpr_read_b32 v12, a21
		v_add_u32_e32 v12, v12, v11
		v_lshrrev_b32_e32 v14, 3, v10
		v_and_b32_e32 v14, 1, v14
		v_lshlrev_b32_e32 v15, 6, v14
		v_lshrrev_b32_e32 v16, 2, v10
		v_and_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v17, 5, v16
		v_add3_u32 v12, v12, v15, v17
		v_lshrrev_b32_e32 v18, 1, v10
		v_and_b32_e32 v18, 1, v18
		v_lshlrev_b32_e32 v19, 4, v18
		v_and_b32_e32 v20, 1, v10
		v_lshlrev_b32_e32 v20, 3, v20
		v_add3_u32 v12, v12, v19, v20
		v_lshlrev_b32_e32 v16, 1, v16
		v_lshlrev_b32_e32 v14, 2, v14
		v_bitop3_b32 v14, v16, v14, v18 bitop3:0x96
		v_xor_b32_e32 v12, v12, v14
		v_lshl_add_u32 v12, v12, 4, v9
		ds_read_b128 a[24:27], v12 offset:18864
		v_accvgpr_read_b32 v16, a21
		v_add3_u32 v11, v16, v11, v15
		v_add3_u32 v11, v11, v17, v19
		v_add3_u32 v15, v20, v11, 2
		v_xor_b32_e32 v15, v15, v14
		v_lshl_add_u32 v15, v15, 4, v9
		ds_read_b128 a[28:31], v15 offset:18864
		v_add3_u32 v16, v20, v11, 4
		v_xor_b32_e32 v16, v16, v14
		v_lshl_add_u32 v16, v16, 4, v9
		ds_read_b128 a[32:35], v16 offset:18864
		v_add3_u32 v11, v20, v11, 6
		v_xor_b32_e32 v11, v11, v14
		v_lshl_add_u32 v9, v11, 4, v9
		ds_read_b128 a[36:39], v9 offset:18864
		v_and_b32_e32 v7, 1, v7
		v_accvgpr_write_b32 a22, v7
		v_and_b32_e32 v3, 3, v3
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v1, v[36:39] offset:18864
		ds_write_b128 v1, v[40:43] offset:22960
		ds_write_b128 v1, v[44:47] offset:27056
		ds_write_b128 v1, v[48:51] offset:31152
		v_accvgpr_read_b32 v1, a11
		s_nop 0
		v_readfirstlane_b32 s1, v1
		s_add_i32 s1, s1, 1
		s_mul_i32 s1, s1, 0x100
		s_mov_b32 s22, 0x7f
		v_readfirstlane_b32 s32, v0
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[40:43], v12 offset:18864
		ds_read_b128 a[44:47], v15 offset:18864
		ds_read_b128 a[48:51], v16 offset:18864
		ds_read_b128 a[52:55], v9 offset:18864
		v_accvgpr_read_b32 v1, a5
		s_nop 0
		v_readfirstlane_b32 s23, v1
		s_add_i32 s1, s1, s23
		s_cmp_lt_i32 s21, s1
		s_cselect_b32 s1, s21, s1
		s_add_i32 s23, s1, 0x7f
		s_cmp_lt_i32 s23, 0
		s_cselect_b32 s33, s22, 0
		s_add_i32 s23, s23, s33
		s_ashr_i32 s23, s23, 7
		v_accvgpr_read_b32 v1, a5
		s_nop 0
		v_readfirstlane_b32 s33, v1
		s_add_i32 s33, s19, s33
		s_cmp_lt_i32 s33, 0
		s_cselect_b32 s34, s22, 0
		s_add_i32 s33, s33, s34
		s_ashr_i32 s33, s33, 7
		s_cmp_lt_i32 s33, s23
		s_cselect_b32 s33, s33, s23
		s_cmp_gt_i32 s33, 0
		s_cselect_b32 s33, s33, 0
		v_mov_b32_e32 v1, 64
		v_mul_lo_u32 v1, v1, v8
		v_mov_b32_e32 v7, 16
		v_mul_lo_u32 v7, v7, v5
		v_bitop3_b32 v9, v1, v2, v7 bitop3:0x96
		v_bitop3_b32 v9, v9, v13, v4 bitop3:0x96
		v_accvgpr_write_b32 a23, v9
		v_bitop3_b32 v9, 4, v1, v2 bitop3:0x96
		v_xor_b32_e32 v9, v9, v7
		v_bitop3_b32 v11, 8, v1, v2 bitop3:0x96
		v_xor_b32_e32 v11, v11, v7
		v_bitop3_b32 v1, 12, v1, v2 bitop3:0x96
		v_accvgpr_read_b32 v12, a23
		v_cmp_lt_i32_e64 s[34:35], v12, s21
		v_mov_b32_e32 v12, 16
		v_mul_lo_u32 v12, v12, v8
		v_mov_b32_e32 v8, 64
		v_mul_lo_u32 v8, v8, v5
		v_bitop3_b32 v5, v12, v2, v8 bitop3:0x96
		v_bitop3_b32 v5, v5, v13, v4 bitop3:0x96
		v_accvgpr_write_b32 a56, v5
		v_bitop3_b32 v5, 4, v12, v2 bitop3:0x96
		v_bitop3_b32 v14, 8, v12, v2 bitop3:0x96
		v_bitop3_b32 v2, 12, v12, v2 bitop3:0x96
		v_accvgpr_read_b32 v12, a56
		v_cmp_lt_i32_e64 vcc, v12, s21
		v_accvgpr_read_b32 v12, a12
		v_mul_lo_u32 v12, s15, v12
		v_accvgpr_read_b32 v15, a19
		v_mul_lo_u32 v15, s15, v15
		v_lshlrev_b32_e32 v15, 5, v15
		v_lshl_add_u32 v12, v12, 1, v15
		v_accvgpr_read_b32 v15, a20
		v_mul_lo_u32 v15, s15, v15
		v_lshl_add_u32 v12, v15, 6, v12
		v_accvgpr_read_b32 v15, a22
		v_mul_lo_u32 v15, s15, v15
		v_lshlrev_b32_e32 v15, 7, v15
		v_accvgpr_read_b32 v16, a16
		v_lshlrev_b32_e32 v16, 4, v16
		v_add3_u32 v12, v12, v15, v16
		v_accvgpr_read_b32 v15, a17
		v_lshlrev_b32_e32 v15, 6, v15
		v_accvgpr_read_b32 v17, a18
		v_lshlrev_b32_e32 v17, 5, v17
		v_add3_u32 v12, v12, v15, v17
		v_accvgpr_read_b32 v18, a15
		s_nop 0
		v_readfirstlane_b32 s36, v18
		s_mul_i32 s36, s36, s13
		s_lshl_b32 s36, s36, 1
		v_accvgpr_read_b32 v18, a10
		s_nop 0
		v_readfirstlane_b32 s37, v18
		s_mul_i32 s37, s37, s14
		s_lshl_b32 s37, s37, 1
		s_add_i32 s40, s36, s37
		v_add_u32_e32 v18, s40, v12
		v_mov_b32_e32 v19, 0x80000000
		v_cndmask_b32_e64 v18, v19, v18, s[34:35]
		s_lshr_b32 s40, s32, 6
		s_mul_i32 s41, 0x410, s40
		s_mov_b32 m0, s41
		v_accvgpr_read_b32 v20, a13
		v_add_u32_e32 v20, s19, v20
		buffer_load_dwordx4 v18, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[42:43], v20, s20
		s_nop 1
		v_mov_b32_e32 v20, s42
		v_mov_b32_e32 v21, s43
		s_lshl_b32 s42, s15, 3
		s_add_i32 s42, s42, s36
		s_add_i32 s42, s42, s37
		v_add_u32_e32 v18, s42, v12
		v_cndmask_b32_e64 v18, v19, v18, s[34:35]
		s_add_i32 m0, m0, 0x1040
		v_accvgpr_read_b32 v22, a14
		v_add_u32_e32 v22, s19, v22
		buffer_load_dwordx4 v18, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[42:43], v22, s20
		s_nop 1
		v_mov_b32_e32 v22, s42
		v_mov_b32_e32 v23, s43
		v_accvgpr_write_b32 a58, v22
		v_accvgpr_write_b32 a59, v23
		s_lshl_b32 s42, s15, 4
		s_add_i32 s42, s42, s36
		s_add_i32 s42, s42, s37
		v_add_u32_e32 v18, s42, v12
		v_cndmask_b32_e64 v18, v19, v18, s[34:35]
		s_add_i32 m0, m0, 0x1040
		v_and_b32_e32 v10, 31, v10
		buffer_load_dwordx4 v18, s[24:27], 0 offen lds
		v_bitop3_b32 v9, v9, v13, v4 bitop3:0x96
		v_accvgpr_write_b32 a57, v9
		s_mul_i32 s42, 24, s15
		s_add_i32 s42, s42, s36
		s_add_i32 s42, s42, s37
		v_add_u32_e32 v9, s42, v12
		v_cndmask_b32_e64 v9, v19, v9, s[34:35]
		s_add_i32 m0, m0, 0x1040
		v_mov_b32_e32 v18, 0x440
		v_mul_lo_u32 v18, v18, v3
		v_accvgpr_write_b32 a60, v18
		buffer_load_dwordx4 v9, s[24:27], 0 offen lds
		v_bitop3_b32 v3, v11, v13, v4 bitop3:0x96
		v_accvgpr_write_b32 a61, v3
		v_accvgpr_read_b32 v3, a12
		v_mul_lo_u32 v3, s17, v3
		v_accvgpr_read_b32 v9, a19
		v_mul_lo_u32 v9, s17, v9
		v_lshlrev_b32_e32 v9, 7, v9
		v_lshl_add_u32 v3, v3, 1, v9
		v_accvgpr_read_b32 v9, a20
		v_mul_lo_u32 v9, s17, v9
		v_lshl_add_u32 v3, v9, 6, v3
		v_accvgpr_read_b32 v9, a22
		v_mul_lo_u32 v9, s17, v9
		v_lshlrev_b32_e32 v9, 5, v9
		v_add3_u32 v3, v3, v9, v16
		v_add3_u32 v3, v3, v15, v17
		v_accvgpr_read_b32 v9, a0
		s_nop 0
		v_readfirstlane_b32 s34, v9
		v_accvgpr_read_b32 v9, a15
		s_nop 0
		v_readfirstlane_b32 s35, v9
		s_mul_i32 s34, s35, s34
		s_lshl_b32 s34, s34, 1
		v_accvgpr_read_b32 v9, a1
		s_nop 0
		v_readfirstlane_b32 s35, v9
		v_accvgpr_read_b32 v9, a10
		s_nop 0
		v_readfirstlane_b32 s42, v9
		s_mul_i32 s35, s42, s35
		s_lshl_b32 s35, s35, 1
		s_add_i32 s42, s34, s35
		v_add_u32_e32 v9, s42, v3
		v_cndmask_b32_e32 v9, v19, v9, vcc
		s_mul_i32 s40, 0x440, s40
		s_add_i32 m0, s40, 0x81f0
		v_xor_b32_e32 v1, v1, v7
		buffer_load_dwordx4 v9, s[28:31], 0 offen lds
		v_bitop3_b32 v1, v1, v13, v4 bitop3:0x96
		v_accvgpr_write_b32 a62, v1
		s_lshl_b32 s42, s17, 3
		s_add_i32 s42, s42, s34
		s_add_i32 s42, s42, s35
		v_add_u32_e32 v1, s42, v3
		v_cndmask_b32_e32 v1, v19, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v5, v5, v8
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_bitop3_b32 v1, v5, v13, v4 bitop3:0x96
		v_accvgpr_write_b32 a63, v1
		s_lshl_b32 s42, s17, 4
		s_add_i32 s42, s42, s34
		s_add_i32 s42, s42, s35
		v_add_u32_e32 v1, s42, v3
		v_cndmask_b32_e32 v1, v19, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v5, v14, v8
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_bitop3_b32 v1, v5, v13, v4 bitop3:0x96
		v_accvgpr_write_b32 a64, v1
		s_mul_i32 s42, 24, s17
		s_add_i32 s42, s42, s34
		s_add_i32 s42, s42, s35
		v_add_u32_e32 v1, s42, v3
		v_cndmask_b32_e32 v1, v19, v1, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v2, v2, v8
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_bitop3_b32 v1, v2, v13, v4 bitop3:0x96
		v_accvgpr_write_b32 a65, v1
		s_mul_i32 s42, s33, 0x80
		v_mbcnt_lo_u32_b32 v1, -1, 0
		v_mbcnt_hi_u32_b32 v1, -1, v1
		v_and_b32_e32 v2, 1, v1
		v_lshrrev_b32_e32 v4, 4, v1
		v_and_b32_e32 v4, 1, v4
		v_lshlrev_b32_e32 v4, 4, v4
		v_lshrrev_b32_e32 v5, 3, v1
		v_and_b32_e32 v5, 1, v5
		v_lshlrev_b32_e32 v5, 3, v5
		v_add3_u32 v7, v2, v4, v5
		v_lshrrev_b32_e32 v8, 2, v1
		v_and_b32_e32 v8, 1, v8
		v_lshlrev_b32_e32 v8, 2, v8
		v_lshrrev_b32_e32 v1, 1, v1
		v_and_b32_e32 v1, 1, v1
		v_lshlrev_b32_e32 v1, 1, v1
		v_add3_u32 v7, v7, v8, v1
		v_add_u32_e32 v2, 32, v2
		v_bitop3_b32 v4, v8, v5, v4 bitop3:0x96
		v_bitop3_b32 v1, v2, v1, v4 bitop3:0x96
		v_mov_b32_e32 v4, 0x3e38aa3b
		v_mov_b32_e32 v5, 0x3e38aa3b
		s_mov_b32 s33, 0xff800000
		v_mov_b32_e32 v2, s33
		v_mov_b32_e32 v8, s33
		s_mov_b32 s33, 1.0
		v_mov_b32_e32 v14, s33
		v_mov_b32_e32 v15, s33
		s_mov_b32 s33, 0
		v_accvgpr_read_b32 v9, a21
		v_lshlrev_b32_e32 v9, 4, v9
		v_accvgpr_write_b32 a66, v9
		v_lshrrev_b32_e32 v9, 4, v10
		v_lshlrev_b32_e32 v9, 9, v9
		v_lshrrev_b32_e32 v11, 3, v10
		v_and_b32_e32 v11, 1, v11
		v_mov_b32_e32 v13, 0x2080
		v_mul_lo_u32 v13, v13, v11
		v_accvgpr_write_b32 a67, v13
		v_lshrrev_b32_e32 v11, 2, v10
		v_and_b32_e32 v11, 1, v11
		v_mov_b32_e32 v13, 0x1040
		v_mul_lo_u32 v13, v13, v11
		v_accvgpr_write_b32 a68, v13
		v_lshrrev_b32_e32 v11, 1, v10
		v_and_b32_e32 v11, 1, v11
		v_mov_b32_e32 v13, 0x820
		v_mul_lo_u32 v13, v13, v11
		v_accvgpr_write_b32 a69, v13
		v_and_b32_e32 v10, 1, v10
		v_mov_b32_e32 v11, 0x410
		v_mul_lo_u32 v11, v11, v10
		v_accvgpr_write_b32 a70, v11
		v_and_b32_e32 v10, 3, v0
		v_accvgpr_write_b32 a71, v10
		v_accvgpr_read_b32 v10, a71
		v_lshlrev_b32_e32 v10, 3, v10
		v_accvgpr_write_b32 a72, v10
		v_accvgpr_read_b32 v10, a19
		v_mov_b32_e32 v11, 0x2200
		v_mul_lo_u32 v11, v11, v10
		v_accvgpr_write_b32 a73, v11
		v_accvgpr_read_b32 v10, a20
		v_lshlrev_b32_e32 v10, 5, v10
		v_accvgpr_write_b32 a74, v10
		s_lshl_b32 s43, s15, 8
		s_add_i32 s43, s43, s36
		s_add_i32 s43, s43, s37
		s_mul_i32 s44, 0x108, s15
		s_add_i32 s44, s44, s36
		s_add_i32 s44, s44, s37
		s_mul_i32 s45, 0x110, s15
		s_add_i32 s45, s45, s36
		s_add_i32 s45, s45, s37
		s_mul_i32 s46, 0x118, s15
		s_add_i32 s36, s46, s36
		s_add_i32 s36, s36, s37
		s_lshl_b32 s37, s17, 8
		s_add_i32 s37, s37, s34
		s_add_i32 s37, s37, s35
		s_mul_i32 s46, 0x108, s17
		s_add_i32 s46, s46, s34
		s_add_i32 s46, s46, s35
		s_mul_i32 s47, 0x110, s17
		s_add_i32 s47, s47, s34
		s_add_i32 s47, s47, s35
		s_mul_i32 s48, 0x118, s17
		s_add_i32 s34, s48, s34
		s_add_i32 s34, s34, s35
		v_lshlrev_b32_e32 v7, 2, v7
		v_accvgpr_write_b32 a75, v7
		v_lshlrev_b32_e32 v1, 2, v1
		v_accvgpr_write_b32 a76, v1
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
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_3
.L_attn_fwd_persistent.loop_head_3:
		s_waitcnt vmcnt(0)
		s_barrier
		s_lshr_b32 s35, s33, 7
		s_and_b32 s48, s35, 1
		s_mul_i32 s49, 0x4100, s48
		v_accvgpr_read_b32 v1, a66
		v_add3_u32 v1, s49, v1, v9
		v_accvgpr_read_b32 v7, a67
		v_accvgpr_read_b32 v10, a68
		v_add3_u32 v1, v1, v7, v10
		v_accvgpr_read_b32 v7, a69
		v_accvgpr_read_b32 v10, a70
		v_add3_u32 v1, v1, v7, v10
		ds_read_b128 v[24:27], v1
		ds_read_b128 v[28:31], v1 offset:32
		ds_read_b128 v[96:99], v1 offset:64
		ds_read_b128 a[80:83], v1 offset:96
		ds_read_b128 v[100:103], v1 offset:256
		ds_read_b128 v[104:107], v1 offset:288
		ds_read_b128 v[108:111], v1 offset:320
		ds_read_b128 a[84:87], v1 offset:352
		ds_read_b128 v[112:115], v1 offset:128
		ds_read_b128 v[116:119], v1 offset:160
		ds_read_b128 v[120:123], v1 offset:192
		ds_read_b128 a[88:91], v1 offset:224
		ds_read_b128 v[124:127], v1 offset:384
		ds_read_b128 a[92:95], v1 offset:416
		ds_read_b128 a[96:99], v1 offset:448
		ds_read_b128 a[100:103], v1 offset:480
		s_mul_i32 s48, 0x4400, s48
		v_accvgpr_read_b32 v1, a72
		v_accvgpr_read_b32 v7, a73
		v_add3_u32 v1, s48, v1, v7
		v_accvgpr_read_b32 v7, a60
		v_accvgpr_read_b32 v10, a74
		v_add3_u32 v1, v1, v10, v7
		ds_read_b64_tr_b16 a[104:105], v1 offset:33264
		ds_read_b64_tr_b16 a[106:107], v1 offset:37616
		ds_read_b64_tr_b16 a[108:109], v1 offset:33392
		ds_read_b64_tr_b16 a[110:111], v1 offset:37744
		ds_read_b64_tr_b16 a[112:113], v1 offset:33520
		ds_read_b64_tr_b16 a[114:115], v1 offset:37872
		ds_read_b64_tr_b16 a[116:117], v1 offset:33648
		ds_read_b64_tr_b16 a[118:119], v1 offset:38000
		ds_read_b64_tr_b16 a[120:121], v1 offset:33776
		ds_read_b64_tr_b16 a[122:123], v1 offset:38128
		ds_read_b64_tr_b16 a[124:125], v1 offset:33904
		ds_read_b64_tr_b16 a[126:127], v1 offset:38256
		ds_read_b64_tr_b16 a[128:129], v1 offset:34032
		ds_read_b64_tr_b16 a[130:131], v1 offset:38384
		ds_read_b64_tr_b16 a[132:133], v1 offset:34160
		ds_read_b64_tr_b16 a[134:135], v1 offset:38512
		ds_read_b64_tr_b16 a[136:137], v1 offset:33328
		ds_read_b64_tr_b16 a[138:139], v1 offset:37680
		ds_read_b64_tr_b16 a[140:141], v1 offset:33456
		ds_read_b64_tr_b16 a[142:143], v1 offset:37808
		ds_read_b64_tr_b16 a[144:145], v1 offset:33584
		ds_read_b64_tr_b16 a[146:147], v1 offset:37936
		ds_read_b64_tr_b16 a[148:149], v1 offset:33712
		ds_read_b64_tr_b16 a[150:151], v1 offset:38064
		ds_read_b64_tr_b16 a[152:153], v1 offset:33840
		ds_read_b64_tr_b16 a[154:155], v1 offset:38192
		ds_read_b64_tr_b16 a[156:157], v1 offset:33968
		ds_read_b64_tr_b16 a[158:159], v1 offset:38320
		ds_read_b64_tr_b16 a[160:161], v1 offset:34096
		ds_read_b64_tr_b16 a[162:163], v1 offset:38448
		ds_read_b64_tr_b16 a[164:165], v1 offset:34224
		ds_read_b64_tr_b16 a[166:167], v1 offset:38576
		s_mul_i32 s48, s15, s33
		s_lshl_b32 s48, s48, 1
		s_add_i32 s49, s43, s48
		v_add_u32_e32 v1, s49, v12
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v7, s48, v12
		s_add_i32 s35, s35, 1
		v_add_u32_e32 v10, s44, v7
		s_and_b32 s35, s35, 1
		v_add_u32_e32 v11, s45, v7
		s_mul_i32 s48, 0x4100, s35
		v_add_u32_e32 v7, s36, v7
		s_add_i32 s48, s41, s48
		v_mfma_f32_32x32x16_bf16 v[128:143], v[24:27], a[24:27], 0
		s_mov_b32 m0, s48
		v_mfma_f32_32x32x16_bf16 v[128:143], v[28:31], a[28:31], v[128:143]
		s_mul_i32 s48, s17, s33
		v_mfma_f32_32x32x16_bf16 v[128:143], v[96:99], a[32:35], v[128:143]
		s_add_i32 s33, s33, 0x80
		v_mfma_f32_32x32x16_bf16 v[144:159], v[24:27], a[40:43], 0
		v_accvgpr_read_b32 v13, a23
		v_add_u32_e32 v13, s33, v13
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[44:47], v[144:159]
		v_accvgpr_read_b32 v16, a57
		v_add_u32_e32 v16, s33, v16
		v_mfma_f32_32x32x16_bf16 v[144:159], v[96:99], a[48:51], v[144:159]
		v_accvgpr_read_b32 v17, a61
		v_add_u32_e32 v17, s33, v17
		v_mfma_f32_32x32x16_bf16 v[160:175], v[100:103], a[24:27], 0
		v_accvgpr_read_b32 v18, a62
		v_add_u32_e32 v18, s33, v18
		v_mfma_f32_32x32x16_bf16 v[160:175], v[104:107], a[28:31], v[160:175]
		v_cmp_lt_i32_e64 s[50:51], v13, s21
		v_mfma_f32_32x32x16_bf16 v[160:175], v[108:111], a[32:35], v[160:175]
		v_accvgpr_read_b32 v13, a56
		v_add_u32_e32 v13, s33, v13
		v_mfma_f32_32x32x16_bf16 v[176:191], v[100:103], a[40:43], 0
		v_accvgpr_read_b32 v22, a63
		v_add_u32_e32 v22, s33, v22
		v_mfma_f32_32x32x16_bf16 v[176:191], v[104:107], a[44:47], v[176:191]
		v_accvgpr_read_b32 v23, a64
		v_add_u32_e32 v23, s33, v23
		v_mfma_f32_32x32x16_bf16 v[176:191], v[108:111], a[48:51], v[176:191]
		v_cmp_lt_i32_e64 s[52:53], v13, s21
		v_mfma_f32_32x32x16_bf16 v[96:111], v[112:115], a[24:27], 0
		v_cndmask_b32_e64 v1, v19, v1, s[50:51]
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[96:111], v[116:119], a[28:31], v[96:111]
		v_cmp_lt_i32_e64 s[50:51], v16, s21
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[54:55], v17, s21
		v_mfma_f32_32x32x16_bf16 v[96:111], v[120:123], a[32:35], v[96:111]
		v_cndmask_b32_e64 v1, v19, v10, s[50:51]
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[192:207], v[112:115], a[40:43], 0
		v_cndmask_b32_e64 v1, v19, v11, s[54:55]
		v_mfma_f32_32x32x16_bf16 v[192:207], v[116:119], a[44:47], v[192:207]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_32x32x16_bf16 v[192:207], v[120:123], a[48:51], v[192:207]
		v_cmp_lt_i32_e64 s[50:51], v18, s21
		buffer_load_dwordx4 v1, s[24:27], 0 offen lds
		v_accvgpr_read_b32 v1, a65
		v_add_u32_e32 v1, s33, v1
		v_mfma_f32_32x32x16_bf16 v[208:223], v[124:127], a[24:27], 0
		v_cndmask_b32_e64 v7, v19, v7, s[50:51]
		v_cmp_lt_i32_e64 s[50:51], v22, s21
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s48, s48, 1
		buffer_load_dwordx4 v7, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v23, s21
		s_add_i32 s49, s37, s48
		v_mfma_f32_32x32x16_bf16 v[208:223], a[92:95], a[28:31], v[208:223]
		v_add_u32_e32 v7, s49, v3
		v_mfma_f32_32x32x16_bf16 v[208:223], a[96:99], a[32:35], v[208:223]
		v_cndmask_b32_e64 v7, v19, v7, s[52:53]
		v_cmp_lt_i32_e64 vcc, v1, s21
		s_mul_i32 s35, 0x4400, s35
		v_add_u32_e32 v1, s48, v3
		s_add_i32 s35, s40, s35
		v_add_u32_e32 v10, s46, v1
		s_add_i32 m0, s35, 0x81f0
		v_cndmask_b32_e64 v10, v19, v10, s[50:51]
		buffer_load_dwordx4 v7, s[28:31], 0 offen lds
		v_add_u32_e32 v7, s47, v1
		v_cndmask_b32_e64 v7, v19, v7, s[54:55]
		s_add_i32 m0, m0, 0x1100
		v_add_u32_e32 v1, s34, v1
		v_cndmask_b32_e32 v1, v19, v1, vcc
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], v[124:127], a[40:43], 0
		s_add_i32 m0, m0, 0x1100
		v_mfma_f32_32x32x16_bf16 v[224:239], a[92:95], a[44:47], v[224:239]
		buffer_load_dwordx4 v7, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], a[96:99], a[48:51], v[224:239]
		s_add_i32 m0, m0, 0x1100
		s_cmp_lt_i32 s33, s42
		v_mfma_f32_32x32x16_bf16 v[128:143], a[80:83], a[36:39], v[128:143]
		buffer_load_dwordx4 v1, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[160:175], a[84:87], a[36:39], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[88:91], a[36:39], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[100:103], a[36:39], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[100:103], a[52:55], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[80:83], a[52:55], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[84:87], a[52:55], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[88:91], a[52:55], v[192:207]
		s_nop 3
		v_max3_f32 v1, v128, v129, v130
		v_max3_f32 v7, v132, v133, v134
		v_max3_f32 v10, v136, v137, v138
		v_max3_f32 v11, v140, v141, v142
		v_max3_f32 v13, v160, v161, v162
		v_max3_f32 v16, v164, v165, v166
		v_max3_f32 v17, v168, v169, v170
		v_max3_f32 v18, v172, v173, v174
		v_max3_f32 v22, v96, v97, v98
		v_max3_f32 v23, v100, v101, v102
		v_max3_f32 v24, v104, v105, v106
		v_max3_f32 v25, v108, v109, v110
		v_max3_f32 v26, v208, v209, v210
		v_max3_f32 v27, v212, v213, v214
		v_max3_f32 v28, v216, v217, v218
		v_max3_f32 v29, v220, v221, v222
		v_max3_f32 v1, v1, v131, v7
		v_max3_f32 v7, v10, v139, v11
		v_max3_f32 v10, v13, v163, v16
		v_max3_f32 v11, v17, v171, v18
		v_max3_f32 v13, v22, v99, v23
		v_max3_f32 v16, v24, v107, v25
		v_max3_f32 v17, v26, v211, v27
		v_max3_f32 v18, v28, v219, v29
		v_max3_f32 v1, v1, v135, v7
		v_max3_f32 v7, v10, v167, v11
		v_max3_f32 v10, v13, v103, v16
		v_max3_f32 v11, v17, v215, v18
		v_max3_f32 v1, v1, v143, v7
		v_max3_f32 v7, v10, v111, v11
		v_max3_f32 v1, v1, v175, v7
		v_max_f32_e32 v10, v1, v223
		v_mov_b32_e32 v11, v10
		v_max3_f32 v1, v144, v145, v146
		v_max3_f32 v7, v148, v149, v150
		v_max3_f32 v13, v152, v153, v154
		v_max3_f32 v16, v156, v157, v158
		v_max3_f32 v17, v176, v177, v178
		v_max3_f32 v18, v180, v181, v182
		v_max3_f32 v22, v184, v185, v186
		v_max3_f32 v23, v188, v189, v190
		v_max3_f32 v24, v192, v193, v194
		v_max3_f32 v25, v196, v197, v198
		v_max3_f32 v26, v200, v201, v202
		v_max3_f32 v27, v204, v205, v206
		v_max3_f32 v28, v224, v225, v226
		v_max3_f32 v29, v228, v229, v230
		v_max3_f32 v30, v232, v233, v234
		v_max3_f32 v31, v236, v237, v238
		v_permlane32_swap_b32_e32 v10, v11
		v_max3_f32 v1, v1, v147, v7
		v_max3_f32 v7, v13, v155, v16
		v_max3_f32 v13, v17, v179, v18
		v_max3_f32 v16, v22, v187, v23
		v_max3_f32 v17, v24, v195, v25
		v_max3_f32 v18, v26, v203, v27
		v_max3_f32 v22, v28, v227, v29
		v_max3_f32 v23, v30, v235, v31
		v_max3_f32 v1, v1, v151, v7
		v_max3_f32 v7, v13, v183, v16
		v_max3_f32 v13, v17, v199, v18
		v_max3_f32 v16, v22, v231, v23
		v_max3_f32 v1, v1, v159, v7
		v_max3_f32 v7, v13, v207, v16
		v_max3_f32 v1, v1, v191, v7
		v_max_f32_e32 v16, v1, v239
		v_mov_b32_e32 v17, v16
		v_max_f32_e32 v22, v10, v11
		v_mov_b32_e32 v10, v2
		v_permlane32_swap_b32_e32 v16, v17
		v_max_f32_e32 v23, v16, v17
		v_pk_mul_f32 v[16:17], v[22:23], v[4:5]
		v_max_f32_e32 v22, v2, v16
		v_max_f32_e32 v23, v8, v17
		v_pk_fma_f32 v[16:17], v[128:129], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[130:131], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[132:133], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[134:135], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[136:137], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[138:139], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[140:141], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[142:143], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[160:161], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[162:163], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[164:165], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[166:167], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[168:169], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[170:171], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[172:173], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[174:175], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[96:97], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[98:99], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[108:109], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[110:111], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[208:209], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[210:211], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[212:213], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[214:215], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[216:217], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[218:219], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[220:221], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[222:223], v[4:5], v[22:23] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[144:145], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[146:147], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[148:149], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[150:151], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[154:155], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[156:157], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[158:159], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[176:177], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[178:179], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[180:181], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[182:183], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[184:185], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[186:187], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[188:189], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[190:191], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[192:193], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[194:195], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[196:197], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[198:199], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[200:201], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[202:203], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[204:205], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[206:207], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[224:225], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[226:227], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[228:229], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[230:231], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[232:233], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[234:235], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[236:237], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[238:239], v[4:5], v[22:23] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v214, v16
		v_exp_f32_e32 v216, v17
		v_exp_f32_e32 v16, v24
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
		v_exp_f32_e32 v17, v96
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
		v_exp_f32_e32 v127, v160
		v_exp_f32_e32 v243, v161
		v_exp_f32_e32 v129, v162
		v_exp_f32_e32 v245, v163
		v_exp_f32_e32 v131, v164
		v_exp_f32_e32 v247, v165
		v_exp_f32_e32 v96, v166
		v_exp_f32_e32 v98, v167
		v_exp_f32_e32 v100, v144
		v_exp_f32_e32 v102, v145
		v_exp_f32_e32 v104, v146
		v_exp_f32_e32 v106, v147
		v_exp_f32_e32 v108, v148
		v_exp_f32_e32 v110, v149
		v_exp_f32_e32 v132, v150
		v_exp_f32_e32 v134, v151
		v_exp_f32_e32 v136, v152
		v_exp_f32_e32 v138, v153
		v_exp_f32_e32 v140, v154
		v_exp_f32_e32 v142, v155
		v_exp_f32_e32 v144, v156
		v_exp_f32_e32 v146, v157
		v_exp_f32_e32 v148, v158
		v_exp_f32_e32 v150, v159
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
		v_pk_add_f32 v[182:183], v[16:17], v[218:219]
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
		v_accvgpr_read_b32 v2, a75
		ds_bpermute_b32 v180, v2, v1
		v_accvgpr_read_b32 v2, a76
		ds_bpermute_b32 v182, v2, v1
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
		v_cvt_pk_bf16_f32 v189, v16, v218
		v_permlane32_swap_b32_e32 v180, v181
		v_add_f32_e32 v183, v180, v181
		v_mov_b32_e32 v11, v8
		v_pk_add_f32 v[180:181], v[10:11], v[22:23] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v10, v180
		v_exp_f32_e32 v11, v181
		v_cvt_pk_bf16_f32 v190, v24, v220
		v_mov_b32_e32 v182, v184
		v_mov_b64_e32 v[180:181], v[14:15]
		v_pk_fma_f32 v[14:15], v[180:181], v[10:11], v[182:183]
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
		v_pk_mul_f32 v[32:33], v[32:33], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[34:35], v[34:35], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[36:37], v[36:37], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[38:39], v[38:39], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[40:41], v[40:41], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[42:43], v[42:43], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[44:45], v[44:45], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[46:47], v[46:47], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[48:49], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[50:51], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[52:53], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[54:55], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[56:57], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[58:59], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[60:61], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[62:63], v[10:11] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[64:65], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[66:67], v[66:67], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[68:69], v[68:69], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[70:71], v[70:71], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[72:73], v[72:73], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[74:75], v[74:75], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[76:77], v[76:77], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[78:79], v[78:79], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[80:81], v[80:81], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[82:83], v[82:83], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[84:85], v[84:85], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[86:87], v[86:87], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[88:89], v[88:89], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[90:91], v[90:91], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[92:93], v[92:93], v[10:11] op_sel:[0,1]
		v_pk_mul_f32 v[94:95], v[94:95], v[10:11] op_sel:[0,1]
		v_cvt_pk_bf16_f32 v197, v17, v219
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
		v_mfma_f32_32x32x16_bf16 v[32:47], a[104:107], v[188:191], v[32:47]
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_mfma_f32_32x32x16_bf16 v[48:63], a[136:139], v[188:191], v[48:63]
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_mfma_f32_32x32x16_bf16 v[32:47], a[108:111], v[180:183], v[32:47]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[48:63], a[140:143], v[180:183], v[48:63]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[32:47], a[112:115], v[184:187], v[32:47]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[48:63], a[144:147], v[184:187], v[48:63]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[32:47], a[116:119], v[192:195], v[32:47]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[48:63], a[148:151], v[192:195], v[48:63]
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_mfma_f32_32x32x16_bf16 v[80:95], a[136:139], v[116:119], v[80:95]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[64:79], a[104:107], v[116:119], v[64:79]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[80:95], a[140:143], v[120:123], v[80:95]
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_mfma_f32_32x32x16_bf16 v[64:79], a[108:111], v[120:123], v[64:79]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[80:95], a[144:147], v[124:127], v[80:95]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[64:79], a[112:115], v[124:127], v[64:79]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[80:95], a[148:151], v[128:131], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[116:119], v[128:131], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[120:123], v[196:199], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[152:155], v[196:199], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], v[200:203], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[120:123], v[200:203], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[124:127], v[24:27], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[156:159], v[24:27], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[124:127], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[128:131], v[28:31], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[160:163], v[28:31], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[160:163], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[128:131], v[100:103], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[132:135], v[112:115], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[164:167], v[112:115], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[164:167], v[104:107], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[132:135], v[104:107], v[64:79]
		v_mov_b32_e32 v2, v22
		v_mov_b32_e32 v8, v23
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_3
.L_attn_fwd_persistent.loop_exit_3:
		s_mul_i32 s23, s23, 0x80
		v_accvgpr_read_b32 v1, a5
		s_nop 0
		v_readfirstlane_b32 s33, v1
		v_accvgpr_read_b32 v1, a13
		s_nop 0
		v_add_u32_e32 v1, s33, v1
		v_add_u32_e32 v1, s19, v1
		v_accvgpr_read_b32 v7, a5
		s_nop 0
		v_readfirstlane_b32 s33, v7
		v_accvgpr_read_b32 v7, a14
		s_nop 0
		v_add_u32_e32 v7, s33, v7
		v_add_u32_e32 v7, s19, v7
		v_xor_b32_e32 v10, 1, v6
		v_accvgpr_write_b32 a13, v10
		v_xor_b32_e32 v10, 2, v6
		v_accvgpr_write_b32 a14, v10
		v_xor_b32_e32 v10, 3, v6
		v_accvgpr_write_b32 a66, v10
		v_xor_b32_e32 v10, 8, v6
		v_accvgpr_write_b32 a72, v10
		v_xor_b32_e32 v10, 9, v6
		v_accvgpr_write_b32 a77, v10
		v_xor_b32_e32 v10, 10, v6
		v_accvgpr_write_b32 a78, v10
		v_xor_b32_e32 v10, 11, v6
		v_accvgpr_write_b32 a79, v10
		v_xor_b32_e32 v10, 16, v6
		v_accvgpr_write_b32 a80, v10
		v_xor_b32_e32 v10, 17, v6
		v_accvgpr_write_b32 a81, v10
		v_xor_b32_e32 v10, 18, v6
		v_accvgpr_write_b32 a82, v10
		v_xor_b32_e32 v10, 19, v6
		v_accvgpr_write_b32 a83, v10
		v_xor_b32_e32 v10, 24, v6
		v_accvgpr_write_b32 a84, v10
		v_xor_b32_e32 v10, 25, v6
		v_accvgpr_write_b32 a85, v10
		v_xor_b32_e32 v10, 26, v6
		v_accvgpr_write_b32 a86, v10
		v_xor_b32_e32 v10, 27, v6
		v_accvgpr_write_b32 a87, v10
		v_xor_b32_e32 v10, 32, v6
		v_accvgpr_write_b32 a88, v10
		v_xor_b32_e32 v10, 33, v6
		v_accvgpr_write_b32 a89, v10
		v_xor_b32_e32 v10, 34, v6
		v_accvgpr_write_b32 a90, v10
		v_xor_b32_e32 v10, 35, v6
		v_accvgpr_write_b32 a91, v10
		v_xor_b32_e32 v10, 40, v6
		v_accvgpr_write_b32 a92, v10
		v_xor_b32_e32 v10, 41, v6
		v_accvgpr_write_b32 a93, v10
		v_xor_b32_e32 v10, 42, v6
		v_accvgpr_write_b32 a94, v10
		v_xor_b32_e32 v10, 43, v6
		v_accvgpr_write_b32 a95, v10
		v_xor_b32_e32 v10, 48, v6
		v_accvgpr_write_b32 a96, v10
		v_xor_b32_e32 v10, 49, v6
		v_accvgpr_write_b32 a97, v10
		v_xor_b32_e32 v10, 50, v6
		v_accvgpr_write_b32 a98, v10
		v_xor_b32_e32 v10, 51, v6
		v_accvgpr_write_b32 a99, v10
		v_xor_b32_e32 v10, 56, v6
		v_accvgpr_write_b32 a100, v10
		v_xor_b32_e32 v10, 57, v6
		v_accvgpr_write_b32 a101, v10
		v_xor_b32_e32 v10, 58, v6
		v_accvgpr_write_b32 a102, v10
		v_xor_b32_e32 v10, 59, v6
		v_accvgpr_write_b32 a103, v10
		v_xor_b32_e32 v10, 64, v6
		v_accvgpr_write_b32 a104, v10
		v_xor_b32_e32 v10, 0x41, v6
		v_accvgpr_write_b32 a105, v10
		v_xor_b32_e32 v10, 0x42, v6
		v_accvgpr_write_b32 a106, v10
		v_xor_b32_e32 v10, 0x43, v6
		v_accvgpr_write_b32 a107, v10
		v_xor_b32_e32 v10, 0x48, v6
		v_accvgpr_write_b32 a108, v10
		v_xor_b32_e32 v10, 0x49, v6
		v_accvgpr_write_b32 a109, v10
		v_xor_b32_e32 v10, 0x4a, v6
		v_accvgpr_write_b32 a110, v10
		v_xor_b32_e32 v10, 0x4b, v6
		v_accvgpr_write_b32 a111, v10
		v_xor_b32_e32 v10, 0x50, v6
		v_accvgpr_write_b32 a112, v10
		v_xor_b32_e32 v10, 0x51, v6
		v_accvgpr_write_b32 a113, v10
		v_xor_b32_e32 v10, 0x52, v6
		v_accvgpr_write_b32 a114, v10
		v_xor_b32_e32 v10, 0x53, v6
		v_accvgpr_write_b32 a115, v10
		v_xor_b32_e32 v10, 0x58, v6
		v_accvgpr_write_b32 a116, v10
		v_xor_b32_e32 v10, 0x59, v6
		v_accvgpr_write_b32 a117, v10
		v_xor_b32_e32 v10, 0x5a, v6
		v_accvgpr_write_b32 a118, v10
		v_xor_b32_e32 v10, 0x5b, v6
		v_accvgpr_write_b32 a119, v10
		v_xor_b32_e32 v10, 0x60, v6
		v_accvgpr_write_b32 a120, v10
		v_xor_b32_e32 v10, 0x61, v6
		v_accvgpr_write_b32 a121, v10
		v_xor_b32_e32 v10, 0x62, v6
		v_accvgpr_write_b32 a122, v10
		v_xor_b32_e32 v10, 0x63, v6
		v_accvgpr_write_b32 a123, v10
		v_xor_b32_e32 v10, 0x68, v6
		v_accvgpr_write_b32 a124, v10
		v_xor_b32_e32 v10, 0x69, v6
		v_accvgpr_write_b32 a125, v10
		v_xor_b32_e32 v10, 0x6a, v6
		v_accvgpr_write_b32 a126, v10
		v_xor_b32_e32 v10, 0x6b, v6
		v_accvgpr_write_b32 a127, v10
		v_xor_b32_e32 v10, 0x70, v6
		v_accvgpr_write_b32 a128, v10
		v_xor_b32_e32 v10, 0x71, v6
		v_accvgpr_write_b32 a129, v10
		v_xor_b32_e32 v10, 0x72, v6
		v_accvgpr_write_b32 a130, v10
		v_xor_b32_e32 v10, 0x73, v6
		v_accvgpr_write_b32 a131, v10
		v_xor_b32_e32 v10, 0x78, v6
		v_accvgpr_write_b32 a132, v10
		v_xor_b32_e32 v10, 0x79, v6
		v_accvgpr_write_b32 a133, v10
		v_xor_b32_e32 v10, 0x7a, v6
		v_accvgpr_write_b32 a134, v10
		v_xor_b32_e32 v10, 0x7b, v6
		v_accvgpr_write_b32 a135, v10
		v_accvgpr_read_b32 v10, a21
		v_lshl_add_u32 v9, v10, 4, v9
		v_accvgpr_read_b32 v10, a67
		v_accvgpr_read_b32 v11, a68
		v_add3_u32 v9, v9, v10, v11
		v_accvgpr_read_b32 v10, a69
		v_accvgpr_read_b32 v11, a70
		v_add3_u32 v9, v9, v10, v11
		v_accvgpr_write_b32 a21, v9
		v_accvgpr_read_b32 v9, a71
		v_accvgpr_read_b32 v10, a73
		v_lshl_add_u32 v9, v9, 3, v10
		v_accvgpr_read_b32 v10, a60
		v_accvgpr_read_b32 v11, a74
		v_add3_u32 v9, v9, v11, v10
		v_accvgpr_write_b32 a60, v9
		v_mov_b32_e32 v9, 0xff800000
		s_cmp_lt_i32 s42, s23
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_4
.L_attn_fwd_persistent.loop_head_4:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s19, s42, 0x80
		s_cmp_lt_i32 s42, 0
		s_cselect_b32 s33, s22, 0
		s_add_i32 s33, s42, s33
		s_ashr_i32 s33, s33, 7
		s_cmp_lt_i32 s33, 0
		s_cselect_b32 s35, s16, 0
		s_add_i32 s35, s33, s35
		s_ashr_i32 s35, s35, 1
		s_lshl_b32 s35, s35, 1
		s_xor_b32 s35, s35, -1
		s_add_i32 s35, s35, 1
		s_add_i32 s35, s33, s35
		s_add_i32 s33, s33, 1
		s_cmp_lt_i32 s33, 0
		s_cselect_b32 s40, s16, 0
		s_add_i32 s40, s33, s40
		s_ashr_i32 s40, s40, 1
		s_lshl_b32 s40, s40, 1
		s_xor_b32 s40, s40, -1
		s_add_i32 s40, s40, 1
		s_add_i32 s48, s33, s40
		s_mul_i32 s33, 0x4100, s35
		v_accvgpr_read_b32 v10, a21
		v_add_u32_e32 v10, s33, v10
		ds_read_b128 v[24:27], v10
		ds_read_b128 a[68:71], v10 offset:32
		ds_read_b128 a[136:139], v10 offset:64
		ds_read_b128 a[140:143], v10 offset:96
		ds_read_b128 a[144:147], v10 offset:256
		ds_read_b128 a[148:151], v10 offset:288
		ds_read_b128 a[152:155], v10 offset:320
		ds_read_b128 a[156:159], v10 offset:352
		ds_read_b128 a[160:163], v10 offset:128
		ds_read_b128 a[164:167], v10 offset:160
		ds_read_b128 a[168:171], v10 offset:192
		ds_read_b128 a[172:175], v10 offset:224
		ds_read_b128 v[28:31], v10 offset:384
		ds_read_b128 a[176:179], v10 offset:416
		ds_read_b128 a[180:183], v10 offset:448
		ds_read_b128 a[184:187], v10 offset:480
		s_mul_i32 s33, 0x4400, s35
		v_accvgpr_read_b32 v10, a60
		v_add_u32_e32 v10, s33, v10
		ds_read_b64_tr_b16 a[188:189], v10 offset:33264
		ds_read_b64_tr_b16 a[190:191], v10 offset:37616
		ds_read_b64_tr_b16 a[192:193], v10 offset:33392
		ds_read_b64_tr_b16 a[194:195], v10 offset:37744
		ds_read_b64_tr_b16 a[196:197], v10 offset:33520
		ds_read_b64_tr_b16 a[198:199], v10 offset:37872
		ds_read_b64_tr_b16 a[200:201], v10 offset:33648
		ds_read_b64_tr_b16 a[202:203], v10 offset:38000
		ds_read_b64_tr_b16 a[204:205], v10 offset:33776
		ds_read_b64_tr_b16 a[206:207], v10 offset:38128
		ds_read_b64_tr_b16 a[208:209], v10 offset:33904
		ds_read_b64_tr_b16 a[210:211], v10 offset:38256
		ds_read_b64_tr_b16 a[212:213], v10 offset:34032
		ds_read_b64_tr_b16 a[214:215], v10 offset:38384
		ds_read_b64_tr_b16 a[216:217], v10 offset:34160
		ds_read_b64_tr_b16 a[218:219], v10 offset:38512
		ds_read_b64_tr_b16 a[220:221], v10 offset:33328
		ds_read_b64_tr_b16 a[222:223], v10 offset:37680
		ds_read_b64_tr_b16 a[224:225], v10 offset:33456
		ds_read_b64_tr_b16 a[226:227], v10 offset:37808
		ds_read_b64_tr_b16 a[228:229], v10 offset:33584
		ds_read_b64_tr_b16 a[230:231], v10 offset:37936
		ds_read_b64_tr_b16 a[232:233], v10 offset:33712
		ds_read_b64_tr_b16 a[234:235], v10 offset:38064
		ds_read_b64_tr_b16 a[236:237], v10 offset:33840
		ds_read_b64_tr_b16 a[238:239], v10 offset:38192
		ds_read_b64_tr_b16 a[240:241], v10 offset:33968
		ds_read_b64_tr_b16 a[242:243], v10 offset:38320
		ds_read_b64_tr_b16 a[244:245], v10 offset:34096
		ds_read_b64_tr_b16 a[246:247], v10 offset:38448
		ds_read_b64_tr_b16 a[248:249], v10 offset:34224
		ds_read_b64_tr_b16 a[250:251], v10 offset:38576
		s_cmp_lt_i32 s19, s1
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_4
		v_accvgpr_read_b32 v10, a23
		v_add_u32_e32 v10, s19, v10
		v_cmp_lt_i32_e64 s[40:41], v10, s21
		v_accvgpr_read_b32 v10, a56
		v_add_u32_e32 v10, s19, v10
		v_cmp_lt_i32_e64 s[50:51], v10, s21
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s33, s15, s42
		s_lshl_b32 s35, s33, 1
		s_add_i32 s33, s43, s35
		v_add_u32_e32 v10, s33, v12
		v_cndmask_b32_e64 v10, v19, v10, s[40:41]
		s_mov_b32 s40, 1
		s_mov_b32 s41, 0
		s_mov_b32 s33, 0
		s_mul_i32 s52, s40, s32
		s_mul_hi_u32 s53, s40, s32
		s_mul_i32 s49, s40, s33
		s_add_i32 s53, s53, s49
		s_mul_i32 s49, s41, s32
		s_add_i32 s53, s53, s49
		s_lshr_b64 s[40:41], s[52:53], 6
		s_mov_b32 s52, 0x410
		s_mov_b32 s53, 0
		s_mul_i32 s54, s52, s40
		s_mul_hi_u32 s55, s52, s40
		s_mul_i32 s33, s52, s41
		s_add_i32 s55, s55, s33
		s_mul_i32 s33, s53, s40
		s_add_i32 s55, s55, s33
		s_cmp_lt_i32 s48, 0
		s_cselect_b32 s49, -1, 0
		s_mov_b32 s52, 0x4100
		s_mov_b32 s53, 0
		s_mul_i32 s56, s52, s48
		s_mul_hi_u32 s57, s52, s48
		s_mul_i32 s33, s52, s49
		s_add_i32 s57, s57, s33
		s_mul_i32 s33, s53, s48
		s_add_i32 s57, s57, s33
		s_add_u32 s52, s54, s56
		s_addc_u32 s53, s55, s57
		s_add_u32 s58, s52, 0
		s_addc_u32 s59, s53, 0
		s_mov_b32 m0, s58
		v_accvgpr_read_b32 v11, a57
		v_add_u32_e32 v11, s19, v11
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[52:53], v11, s21
		s_add_i32 s33, s44, s35
		v_add_u32_e32 v10, s33, v12
		v_cndmask_b32_e64 v10, v19, v10, s[52:53]
		s_add_u32 s52, s54, 0x1040
		s_addc_u32 s53, s55, 0
		s_add_u32 s52, s52, s56
		s_addc_u32 s53, s53, s57
		s_add_u32 s58, s52, 0
		s_addc_u32 s59, s53, 0
		s_mov_b32 m0, s58
		v_accvgpr_read_b32 v11, a61
		v_add_u32_e32 v11, s19, v11
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[52:53], v11, s21
		s_add_i32 s33, s45, s35
		v_add_u32_e32 v10, s33, v12
		v_cndmask_b32_e64 v10, v19, v10, s[52:53]
		s_add_u32 s52, s54, 0x2080
		s_addc_u32 s53, s55, 0
		s_add_u32 s52, s52, s56
		s_addc_u32 s53, s53, s57
		s_add_u32 s58, s52, 0
		s_addc_u32 s59, s53, 0
		s_mov_b32 m0, s58
		v_accvgpr_read_b32 v11, a62
		v_add_u32_e32 v11, s19, v11
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[52:53], v11, s21
		s_add_i32 s33, s36, s35
		v_add_u32_e32 v10, s33, v12
		v_cndmask_b32_e64 v10, v19, v10, s[52:53]
		s_add_u32 s52, s54, 0x30c0
		s_addc_u32 s53, s55, 0
		s_add_u32 s52, s52, s56
		s_addc_u32 s53, s53, s57
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		v_accvgpr_read_b32 v11, a63
		v_add_u32_e32 v11, s19, v11
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		s_mul_i32 s33, s17, s42
		s_lshl_b32 s33, s33, 1
		s_add_i32 s35, s37, s33
		v_add_u32_e32 v10, s35, v3
		v_cndmask_b32_e64 v10, v19, v10, s[50:51]
		s_mov_b32 s50, 0x440
		s_mov_b32 s51, 0
		s_mul_i32 s52, s50, s40
		s_mul_hi_u32 s53, s50, s40
		s_mul_i32 s35, s50, s41
		s_add_i32 s53, s53, s35
		s_mul_i32 s35, s51, s40
		s_add_i32 s53, s53, s35
		s_add_u32 s40, s52, 0x81f0
		s_addc_u32 s41, s53, 0
		s_mov_b32 s50, 0x4400
		s_mov_b32 s51, 0
		s_mul_i32 s54, s50, s48
		s_mul_hi_u32 s55, s50, s48
		s_mul_i32 s35, s50, s49
		s_add_i32 s55, s55, s35
		s_mul_i32 s35, s51, s48
		s_add_i32 s55, s55, s35
		s_add_u32 s40, s40, s54
		s_addc_u32 s41, s41, s55
		s_add_u32 s48, s40, 0
		s_addc_u32 s49, s41, 0
		s_mov_b32 m0, s48
		v_accvgpr_read_b32 v13, a64
		v_add_u32_e32 v13, s19, v13
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[40:41], v11, s21
		s_add_i32 s35, s46, s33
		v_add_u32_e32 v10, s35, v3
		v_cndmask_b32_e64 v10, v19, v10, s[40:41]
		s_add_u32 s40, s52, 0x92f0
		s_addc_u32 s41, s53, 0
		s_add_u32 s40, s40, s54
		s_addc_u32 s41, s41, s55
		s_add_u32 s48, s40, 0
		s_addc_u32 s49, s41, 0
		s_mov_b32 m0, s48
		v_accvgpr_read_b32 v11, a65
		v_add_u32_e32 v11, s19, v11
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[40:41], v13, s21
		s_add_i32 s35, s47, s33
		v_add_u32_e32 v10, s35, v3
		s_add_u32 s48, s52, 0xa3f0
		s_addc_u32 s49, s53, 0
		s_add_u32 s48, s48, s54
		s_addc_u32 s49, s49, s55
		s_add_u32 s50, s48, 0
		s_addc_u32 s51, s49, 0
		s_mov_b32 m0, s50
		v_cndmask_b32_e64 v10, v19, v10, s[40:41]
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		s_add_i32 s33, s34, s33
		v_cmp_lt_i32_e64 vcc, v11, s21
		v_add_u32_e32 v10, s33, v3
		s_add_u32 s40, s52, 0xb4f0
		s_addc_u32 s41, s53, 0
		v_cndmask_b32_e32 v10, v19, v10, vcc
		s_add_u32 s40, s40, s54
		s_addc_u32 s41, s41, s55
		s_add_u32 s48, s40, 0
		s_addc_u32 s49, s41, 0
		s_mov_b32 m0, s48
		s_nop 0
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_4
.L_attn_fwd_persistent.if_else_4:
.L_attn_fwd_persistent.if_end_4:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[96:111], v[24:27], a[24:27], 0
		s_cmp_lt_i32 s19, s23
		v_mfma_f32_32x32x16_bf16 v[112:127], a[144:147], a[24:27], 0
		v_mfma_f32_32x32x16_bf16 v[128:143], a[160:163], a[24:27], 0
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[24:27], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[28:31], a[40:43], 0
		v_mfma_f32_32x32x16_bf16 v[176:191], v[24:27], a[40:43], 0
		v_mfma_f32_32x32x16_bf16 v[192:207], a[144:147], a[40:43], 0
		v_mfma_f32_32x32x16_bf16 v[208:223], a[160:163], a[40:43], 0
		v_mfma_f32_32x32x16_bf16 v[96:111], a[68:71], a[28:31], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[148:151], a[28:31], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[164:167], a[28:31], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[176:179], a[28:31], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[176:179], a[44:47], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[68:71], a[44:47], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[148:151], a[44:47], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[164:167], a[44:47], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[136:139], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[152:155], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[168:171], a[32:35], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[180:183], a[32:35], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[48:51], v[160:175]
		v_add_u32_e32 v10, s42, v6
		v_mfma_f32_32x32x16_bf16 v[176:191], a[136:139], a[48:51], v[176:191]
		v_accvgpr_read_b32 v11, a13
		v_add_u32_e32 v11, s42, v11
		v_mfma_f32_32x32x16_bf16 v[192:207], a[152:155], a[48:51], v[192:207]
		v_accvgpr_read_b32 v13, a14
		v_add_u32_e32 v13, s42, v13
		v_mfma_f32_32x32x16_bf16 v[208:223], a[168:171], a[48:51], v[208:223]
		v_accvgpr_read_b32 v16, a66
		v_add_u32_e32 v16, s42, v16
		v_mfma_f32_32x32x16_bf16 v[96:111], a[140:143], a[36:39], v[96:111]
		v_cmp_ge_i32_e64 vcc, v1, v16
		v_mfma_f32_32x32x16_bf16 v[112:127], a[156:159], a[36:39], v[112:127]
		v_accvgpr_read_b32 v17, a78
		v_add_u32_e32 v17, s42, v17
		v_mfma_f32_32x32x16_bf16 v[128:143], a[172:175], a[36:39], v[128:143]
		v_accvgpr_read_b32 v18, a79
		v_add_u32_e32 v18, s42, v18
		v_mfma_f32_32x32x16_bf16 v[144:159], a[184:187], a[36:39], v[144:159]
		v_accvgpr_read_b32 v22, a82
		v_add_u32_e32 v22, s42, v22
		v_mfma_f32_32x32x16_bf16 v[160:175], a[184:187], a[52:55], v[160:175]
		v_accvgpr_read_b32 v23, a83
		v_add_u32_e32 v23, s42, v23
		v_mfma_f32_32x32x16_bf16 v[176:191], a[140:143], a[52:55], v[176:191]
		v_accvgpr_read_b32 v24, a86
		v_add_u32_e32 v24, s42, v24
		v_mfma_f32_32x32x16_bf16 v[192:207], a[156:159], a[52:55], v[192:207]
		v_cndmask_b32_e32 v27, v9, v99, vcc
		v_mfma_f32_32x32x16_bf16 v[208:223], a[172:175], a[52:55], v[208:223]
		v_accvgpr_read_b32 v25, a87
		v_add_u32_e32 v25, s42, v25
		v_accvgpr_read_b32 v26, a90
		v_add_u32_e32 v28, s42, v26
		v_accvgpr_read_b32 v26, a91
		v_add_u32_e32 v29, s42, v26
		v_accvgpr_read_b32 v26, a94
		v_add_u32_e32 v30, s42, v26
		v_accvgpr_read_b32 v26, a95
		v_add_u32_e32 v31, s42, v26
		v_accvgpr_read_b32 v26, a98
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a67, v26
		v_accvgpr_read_b32 v26, a99
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a68, v26
		v_accvgpr_read_b32 v26, a102
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a69, v26
		v_accvgpr_read_b32 v26, a103
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a70, v26
		v_accvgpr_read_b32 v26, a106
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a71, v26
		v_accvgpr_read_b32 v26, a107
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a73, v26
		v_accvgpr_read_b32 v26, a110
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a74, v26
		v_accvgpr_read_b32 v26, a111
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a136, v26
		v_accvgpr_read_b32 v26, a114
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a137, v26
		v_accvgpr_read_b32 v26, a115
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a138, v26
		v_accvgpr_read_b32 v26, a118
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a139, v26
		v_accvgpr_read_b32 v26, a119
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a140, v26
		v_accvgpr_read_b32 v26, a122
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a141, v26
		v_accvgpr_read_b32 v26, a123
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a142, v26
		v_accvgpr_read_b32 v26, a126
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a143, v26
		v_accvgpr_read_b32 v26, a127
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a144, v26
		v_accvgpr_read_b32 v26, a130
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a145, v26
		v_accvgpr_read_b32 v26, a131
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a146, v26
		v_accvgpr_read_b32 v26, a134
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a147, v26
		v_accvgpr_read_b32 v26, a135
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a148, v26
		v_cmp_ge_i32_e64 s[40:41], v1, v10
		v_cmp_ge_i32_e64 s[48:49], v1, v11
		v_cmp_ge_i32_e64 s[50:51], v1, v13
		v_accvgpr_read_b32 v26, a72
		v_add_u32_e32 v99, s42, v26
		v_accvgpr_read_b32 v26, a77
		v_add_u32_e32 v224, s42, v26
		v_cmp_ge_i32_e64 s[52:53], v1, v99
		v_cmp_ge_i32_e64 s[54:55], v1, v224
		v_cmp_ge_i32_e64 s[56:57], v1, v17
		v_cmp_ge_i32_e64 vcc, v1, v18
		v_accvgpr_read_b32 v26, a80
		v_add_u32_e32 v225, s42, v26
		v_accvgpr_read_b32 v26, a81
		v_add_u32_e32 v226, s42, v26
		v_cndmask_b32_e32 v229, v9, v103, vcc
		v_cmp_ge_i32_e64 s[58:59], v1, v225
		v_cmp_ge_i32_e64 s[60:61], v1, v226
		v_cmp_ge_i32_e64 s[62:63], v1, v22
		v_cmp_ge_i32_e64 vcc, v1, v23
		v_accvgpr_read_b32 v26, a84
		v_add_u32_e32 v103, s42, v26
		v_accvgpr_read_b32 v26, a85
		v_add_u32_e32 v227, s42, v26
		v_cndmask_b32_e32 v231, v9, v107, vcc
		v_cmp_ge_i32_e64 s[64:65], v1, v103
		v_cmp_ge_i32_e64 s[66:67], v1, v227
		v_cmp_ge_i32_e64 s[68:69], v1, v24
		v_cmp_ge_i32_e64 vcc, v1, v25
		v_accvgpr_read_b32 v26, a88
		v_add_u32_e32 v107, s42, v26
		v_accvgpr_read_b32 v26, a89
		v_add_u32_e32 v232, s42, v26
		v_cndmask_b32_e32 v235, v9, v111, vcc
		v_cmp_ge_i32_e64 s[70:71], v1, v107
		v_cmp_ge_i32_e64 s[72:73], v1, v232
		v_cmp_ge_i32_e64 s[74:75], v1, v28
		v_cmp_ge_i32_e64 vcc, v1, v29
		v_accvgpr_read_b32 v26, a92
		v_add_u32_e32 v111, s42, v26
		v_accvgpr_read_b32 v26, a93
		v_add_u32_e32 v233, s42, v26
		v_cndmask_b32_e32 v237, v9, v115, vcc
		v_cmp_ge_i32_e64 s[76:77], v1, v111
		v_cmp_ge_i32_e64 s[78:79], v1, v233
		v_cmp_ge_i32_e64 s[80:81], v1, v30
		v_cmp_ge_i32_e64 vcc, v1, v31
		v_accvgpr_read_b32 v26, a96
		v_add_u32_e32 v115, s42, v26
		v_accvgpr_read_b32 v26, a97
		v_add_u32_e32 v236, s42, v26
		v_cndmask_b32_e32 v239, v9, v119, vcc
		v_cmp_ge_i32_e64 s[82:83], v1, v115
		v_cmp_ge_i32_e64 s[84:85], v1, v236
		v_accvgpr_read_b32 v26, a68
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v26, a100
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a149, v26
		v_accvgpr_read_b32 v26, a101
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a150, v26
		v_cndmask_b32_e32 v241, v9, v123, vcc
		v_accvgpr_read_b32 v26, a70
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v26, a104
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a151, v26
		v_accvgpr_read_b32 v26, a105
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a152, v26
		v_cndmask_b32_e32 v243, v9, v127, vcc
		v_accvgpr_read_b32 v26, a73
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v26, a108
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a153, v26
		v_accvgpr_read_b32 v26, a109
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a154, v26
		v_cndmask_b32_e32 v245, v9, v131, vcc
		v_accvgpr_read_b32 v26, a136
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v26, a112
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a155, v26
		v_accvgpr_read_b32 v26, a113
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a156, v26
		v_cndmask_b32_e32 v247, v9, v135, vcc
		v_accvgpr_read_b32 v26, a138
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v26, a116
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a157, v26
		v_accvgpr_read_b32 v26, a117
		v_add_u32_e32 v26, s42, v26
		v_accvgpr_write_b32 a158, v26
		v_cndmask_b32_e32 v249, v9, v139, vcc
		v_accvgpr_read_b32 v26, a140
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v26, a67
		v_cmp_ge_i32_e64 s[86:87], v1, v26
		v_cndmask_b32_e64 v250, v9, v96, s[40:41]
		v_accvgpr_read_b32 v26, a149
		v_cmp_ge_i32_e64 s[40:41], v1, v26
		s_nop 1
		v_mov_b32_e32 v252, s40
		v_mov_b32_e32 v253, s41
		v_accvgpr_write_b32 a160, v252
		v_accvgpr_write_b32 a161, v253
		v_accvgpr_read_b32 v26, a150
		v_cmp_ge_i32_e64 s[40:41], v1, v26
		s_nop 1
		v_mov_b32_e32 v252, s40
		v_mov_b32_e32 v253, s41
		v_accvgpr_write_b32 a162, v252
		v_accvgpr_write_b32 a163, v253
		v_accvgpr_read_b32 v26, a69
		v_cmp_ge_i32_e64 s[40:41], v1, v26
		s_nop 1
		v_mov_b32_e32 v252, s40
		v_mov_b32_e32 v253, s41
		v_accvgpr_write_b32 a164, v252
		v_accvgpr_write_b32 a165, v253
		v_accvgpr_read_b32 v26, a151
		v_cmp_ge_i32_e64 s[40:41], v1, v26
		s_nop 1
		v_mov_b32_e32 v252, s40
		v_mov_b32_e32 v253, s41
		v_accvgpr_write_b32 a166, v252
		v_accvgpr_write_b32 a167, v253
		v_accvgpr_read_b32 v26, a152
		v_cmp_ge_i32_e64 s[40:41], v1, v26
		s_nop 1
		v_mov_b32_e32 v252, s40
		v_mov_b32_e32 v253, s41
		v_accvgpr_write_b32 a168, v252
		v_accvgpr_write_b32 a169, v253
		v_accvgpr_read_b32 v26, a71
		v_cmp_ge_i32_e64 s[40:41], v1, v26
		s_nop 1
		v_mov_b32_e32 v252, s40
		v_mov_b32_e32 v253, s41
		v_accvgpr_write_b32 a170, v252
		v_accvgpr_write_b32 a171, v253
		v_accvgpr_read_b32 v26, a153
		v_cmp_ge_i32_e64 s[40:41], v1, v26
		s_nop 1
		v_mov_b32_e32 v252, s40
		v_mov_b32_e32 v253, s41
		v_accvgpr_write_b32 a172, v252
		v_accvgpr_write_b32 a173, v253
		v_accvgpr_read_b32 v26, a154
		v_cmp_ge_i32_e64 s[40:41], v1, v26
		s_nop 1
		v_mov_b32_e32 v252, s40
		v_mov_b32_e32 v253, s41
		v_accvgpr_write_b32 a174, v252
		v_accvgpr_write_b32 a175, v253
		v_accvgpr_read_b32 v26, a74
		v_cmp_ge_i32_e64 s[40:41], v1, v26
		s_nop 1
		v_mov_b32_e32 v252, s40
		v_mov_b32_e32 v253, s41
		v_accvgpr_write_b32 a176, v252
		v_accvgpr_write_b32 a177, v253
		v_accvgpr_read_b32 v26, a155
		v_cmp_ge_i32_e64 s[40:41], v1, v26
		s_nop 1
		v_mov_b32_e32 v252, s40
		v_mov_b32_e32 v253, s41
		v_accvgpr_write_b32 a178, v252
		v_accvgpr_write_b32 a179, v253
		v_accvgpr_read_b32 v26, a156
		v_cmp_ge_i32_e64 s[40:41], v1, v26
		s_nop 1
		v_mov_b32_e32 v252, s40
		v_mov_b32_e32 v253, s41
		v_accvgpr_write_b32 a180, v252
		v_accvgpr_write_b32 a181, v253
		v_accvgpr_read_b32 v26, a137
		v_cmp_ge_i32_e64 s[40:41], v1, v26
		s_nop 1
		v_mov_b32_e32 v252, s40
		v_mov_b32_e32 v253, s41
		v_accvgpr_write_b32 a182, v252
		v_accvgpr_write_b32 a183, v253
		v_accvgpr_read_b32 v26, a157
		v_cmp_ge_i32_e64 s[40:41], v1, v26
		v_accvgpr_read_b32 v26, a158
		v_cmp_ge_i32_e64 s[88:89], v1, v26
		v_accvgpr_read_b32 v26, a139
		v_cmp_ge_i32_e64 s[90:91], v1, v26
		v_cndmask_b32_e32 v253, v9, v143, vcc
		v_cndmask_b32_e64 v255, v9, v141, s[88:89]
		v_cndmask_b32_e64 v252, v9, v142, s[90:91]
		v_accvgpr_read_b32 v26, a120
		v_add_u32_e32 v96, s42, v26
		v_accvgpr_read_b32 v26, a121
		v_add_u32_e32 v119, s42, v26
		v_cmp_ge_i32_e64 s[88:89], v1, v96
		v_cmp_ge_i32_e64 s[90:91], v1, v119
		v_accvgpr_read_b32 v26, a141
		v_cmp_ge_i32_e64 s[92:93], v1, v26
		v_cndmask_b32_e64 v142, v9, v144, s[88:89]
		v_cndmask_b32_e64 v143, v9, v145, s[90:91]
		v_cndmask_b32_e64 v144, v9, v146, s[92:93]
		v_accvgpr_read_b32 v26, a142
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v26, a124
		v_add_u32_e32 v123, s42, v26
		v_accvgpr_read_b32 v26, a125
		v_add_u32_e32 v127, s42, v26
		v_cndmask_b32_e32 v145, v9, v147, vcc
		v_cmp_ge_i32_e64 s[88:89], v1, v123
		v_cmp_ge_i32_e64 s[90:91], v1, v127
		v_accvgpr_read_b32 v26, a143
		v_cmp_ge_i32_e64 s[92:93], v1, v26
		v_cndmask_b32_e64 v146, v9, v148, s[88:89]
		v_cndmask_b32_e64 v147, v9, v149, s[90:91]
		v_cndmask_b32_e64 v148, v9, v150, s[92:93]
		v_accvgpr_read_b32 v26, a144
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v26, a128
		v_add_u32_e32 v131, s42, v26
		v_accvgpr_read_b32 v26, a129
		v_add_u32_e32 v135, s42, v26
		v_cndmask_b32_e32 v149, v9, v151, vcc
		v_cmp_ge_i32_e64 s[88:89], v1, v131
		v_cmp_ge_i32_e64 s[90:91], v1, v135
		v_accvgpr_read_b32 v26, a145
		v_cmp_ge_i32_e64 s[92:93], v1, v26
		v_cndmask_b32_e64 v150, v9, v152, s[88:89]
		v_cndmask_b32_e64 v151, v9, v153, s[90:91]
		v_cndmask_b32_e64 v152, v9, v154, s[92:93]
		v_accvgpr_read_b32 v26, a146
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_accvgpr_read_b32 v26, a132
		v_add_u32_e32 v139, s42, v26
		v_accvgpr_read_b32 v26, a133
		v_add_u32_e32 v141, s42, v26
		v_cndmask_b32_e32 v153, v9, v155, vcc
		v_cmp_ge_i32_e64 s[88:89], v1, v139
		v_cmp_ge_i32_e64 s[90:91], v1, v141
		v_accvgpr_read_b32 v26, a147
		v_cmp_ge_i32_e64 s[92:93], v1, v26
		v_cndmask_b32_e64 v154, v9, v156, s[88:89]
		v_cndmask_b32_e64 v155, v9, v157, s[90:91]
		v_cndmask_b32_e64 v156, v9, v158, s[92:93]
		v_cndmask_b32_e64 v251, v9, v97, s[48:49]
		v_accvgpr_read_b32 v26, a148
		v_cmp_ge_i32_e64 vcc, v1, v26
		v_max3_f32 v26, v142, v143, v144
		v_accvgpr_write_b32 a159, v26
		v_max3_f32 v97, v146, v147, v148
		v_cndmask_b32_e32 v157, v9, v159, vcc
		v_cmp_ge_i32_e64 s[48:49], v7, v10
		v_cmp_ge_i32_e64 s[88:89], v7, v11
		v_cmp_ge_i32_e64 s[90:91], v7, v13
		v_max3_f32 v10, v150, v151, v152
		v_accvgpr_write_b32 a184, v10
		v_max3_f32 v10, v154, v155, v156
		v_accvgpr_write_b32 a185, v10
		v_cndmask_b32_e64 v10, v9, v178, s[90:91]
		v_cmp_ge_i32_e64 vcc, v7, v16
		v_cndmask_b32_e64 v26, v9, v98, s[50:51]
		v_cndmask_b32_e64 v158, v9, v100, s[52:53]
		v_cndmask_b32_e32 v11, v9, v179, vcc
		v_cmp_ge_i32_e64 s[50:51], v7, v99
		v_cmp_ge_i32_e64 s[52:53], v7, v224
		v_cmp_ge_i32_e64 s[90:91], v7, v17
		v_cndmask_b32_e64 v16, v9, v180, s[50:51]
		v_cndmask_b32_e64 v17, v9, v181, s[52:53]
		v_cndmask_b32_e64 v98, v9, v182, s[90:91]
		v_cmp_ge_i32_e64 vcc, v7, v18
		v_cndmask_b32_e64 v159, v9, v101, s[54:55]
		v_cndmask_b32_e64 v228, v9, v102, s[56:57]
		v_cndmask_b32_e64 v100, v9, v104, s[58:59]
		v_cndmask_b32_e32 v99, v9, v183, vcc
		v_cmp_ge_i32_e64 s[50:51], v7, v225
		v_cmp_ge_i32_e64 s[52:53], v7, v226
		v_cmp_ge_i32_e64 s[54:55], v7, v22
		v_cndmask_b32_e64 v178, v9, v184, s[50:51]
		v_cndmask_b32_e64 v179, v9, v185, s[52:53]
		v_cndmask_b32_e64 v180, v9, v186, s[54:55]
		v_cmp_ge_i32_e64 vcc, v7, v23
		v_cndmask_b32_e64 v101, v9, v105, s[60:61]
		v_max3_f32 v13, v250, v251, v26
		v_cndmask_b32_e32 v181, v9, v187, vcc
		v_cmp_ge_i32_e64 s[50:51], v7, v103
		v_cmp_ge_i32_e64 s[52:53], v7, v227
		v_cmp_ge_i32_e64 s[54:55], v7, v24
		v_cndmask_b32_e64 v22, v9, v188, s[50:51]
		v_cndmask_b32_e64 v23, v9, v189, s[52:53]
		v_cndmask_b32_e64 v102, v9, v190, s[54:55]
		v_cmp_ge_i32_e64 vcc, v7, v25
		v_cndmask_b32_e64 v230, v9, v106, s[62:63]
		v_cndmask_b32_e64 v24, v9, v108, s[64:65]
		v_cndmask_b32_e32 v103, v9, v191, vcc
		v_cmp_ge_i32_e64 s[50:51], v7, v107
		v_cmp_ge_i32_e64 s[52:53], v7, v232
		v_cmp_ge_i32_e64 s[54:55], v7, v28
		v_cndmask_b32_e64 v104, v9, v192, s[50:51]
		v_cndmask_b32_e64 v105, v9, v193, s[52:53]
		v_cndmask_b32_e64 v106, v9, v194, s[54:55]
		v_cmp_ge_i32_e64 vcc, v7, v29
		v_cndmask_b32_e64 v25, v9, v109, s[66:67]
		v_cndmask_b32_e64 v234, v9, v110, s[68:69]
		v_cndmask_b32_e64 v28, v9, v112, s[70:71]
		v_cndmask_b32_e32 v107, v9, v195, vcc
		v_cmp_ge_i32_e64 s[50:51], v7, v111
		v_cmp_ge_i32_e64 s[52:53], v7, v233
		v_cmp_ge_i32_e64 s[54:55], v7, v30
		v_cndmask_b32_e64 v108, v9, v196, s[50:51]
		v_cndmask_b32_e64 v109, v9, v197, s[52:53]
		v_cndmask_b32_e64 v110, v9, v198, s[54:55]
		v_cmp_ge_i32_e64 vcc, v7, v31
		v_cndmask_b32_e64 v29, v9, v113, s[72:73]
		v_max3_f32 v18, v158, v159, v228
		v_cndmask_b32_e32 v111, v9, v199, vcc
		v_cmp_ge_i32_e64 s[50:51], v7, v115
		v_cmp_ge_i32_e64 s[52:53], v7, v236
		v_accvgpr_read_b32 v30, a67
		v_cmp_ge_i32_e64 s[54:55], v7, v30
		v_cndmask_b32_e64 v30, v9, v200, s[50:51]
		v_cndmask_b32_e64 v31, v9, v201, s[52:53]
		v_cndmask_b32_e64 v112, v9, v202, s[54:55]
		v_accvgpr_read_b32 v113, a68
		v_cmp_ge_i32_e64 vcc, v7, v113
		v_cndmask_b32_e64 v236, v9, v114, s[74:75]
		v_cndmask_b32_e64 v114, v9, v116, s[76:77]
		v_cndmask_b32_e32 v113, v9, v203, vcc
		v_accvgpr_read_b32 v115, a70
		v_cmp_ge_i32_e64 vcc, v7, v115
		v_accvgpr_read_b32 v115, a149
		v_cmp_ge_i32_e64 s[50:51], v7, v115
		v_accvgpr_read_b32 v115, a150
		v_cmp_ge_i32_e64 s[52:53], v7, v115
		v_accvgpr_read_b32 v115, a69
		v_cmp_ge_i32_e64 s[54:55], v7, v115
		v_cndmask_b32_e64 v182, v9, v204, s[50:51]
		v_cndmask_b32_e64 v183, v9, v205, s[52:53]
		v_cndmask_b32_e64 v184, v9, v206, s[54:55]
		v_cndmask_b32_e64 v115, v9, v117, s[78:79]
		v_cndmask_b32_e64 v238, v9, v118, s[80:81]
		v_cndmask_b32_e32 v185, v9, v207, vcc
		v_accvgpr_read_b32 v116, a151
		v_cmp_ge_i32_e64 s[50:51], v7, v116
		v_accvgpr_read_b32 v116, a152
		v_cmp_ge_i32_e64 s[52:53], v7, v116
		v_accvgpr_read_b32 v116, a73
		v_cmp_ge_i32_e64 vcc, v7, v116
		v_accvgpr_read_b32 v116, a71
		v_cmp_ge_i32_e64 s[54:55], v7, v116
		v_cndmask_b32_e64 v116, v9, v208, s[50:51]
		v_cndmask_b32_e64 v117, v9, v209, s[52:53]
		v_cndmask_b32_e64 v186, v9, v210, s[54:55]
		v_cndmask_b32_e64 v188, v9, v120, s[82:83]
		v_cndmask_b32_e64 v189, v9, v121, s[84:85]
		v_cndmask_b32_e32 v187, v9, v211, vcc
		v_accvgpr_read_b32 v118, a153
		v_cmp_ge_i32_e64 s[50:51], v7, v118
		v_accvgpr_read_b32 v118, a154
		v_cmp_ge_i32_e64 s[52:53], v7, v118
		v_accvgpr_read_b32 v118, a74
		v_cmp_ge_i32_e64 s[54:55], v7, v118
		v_cndmask_b32_e64 v120, v9, v212, s[50:51]
		v_cndmask_b32_e64 v121, v9, v213, s[52:53]
		v_cndmask_b32_e64 v190, v9, v214, s[54:55]
		v_accvgpr_read_b32 v118, a136
		v_cmp_ge_i32_e64 vcc, v7, v118
		v_cndmask_b32_e64 v240, v9, v122, s[86:87]
		v_accvgpr_read_b32 v118, a160
		s_nop 0
		v_readfirstlane_b32 s50, v118
		v_accvgpr_read_b32 v118, a161
		s_nop 0
		v_readfirstlane_b32 s51, v118
		s_nop 1
		v_cndmask_b32_e64 v192, v9, v124, s[50:51]
		v_cndmask_b32_e32 v191, v9, v215, vcc
		v_accvgpr_read_b32 v118, a155
		v_cmp_ge_i32_e64 s[50:51], v7, v118
		v_accvgpr_read_b32 v118, a156
		v_cmp_ge_i32_e64 s[52:53], v7, v118
		v_accvgpr_read_b32 v118, a137
		v_cmp_ge_i32_e64 s[54:55], v7, v118
		v_cndmask_b32_e64 v194, v9, v216, s[50:51]
		v_cndmask_b32_e64 v195, v9, v217, s[52:53]
		v_cndmask_b32_e64 v196, v9, v218, s[54:55]
		v_accvgpr_read_b32 v118, a138
		v_cmp_ge_i32_e64 vcc, v7, v118
		v_accvgpr_read_b32 v118, a162
		s_nop 0
		v_readfirstlane_b32 s50, v118
		v_accvgpr_read_b32 v118, a163
		s_nop 0
		v_readfirstlane_b32 s51, v118
		s_nop 1
		v_cndmask_b32_e64 v193, v9, v125, s[50:51]
		v_accvgpr_read_b32 v118, a164
		s_nop 0
		v_readfirstlane_b32 s50, v118
		v_accvgpr_read_b32 v118, a165
		s_nop 0
		v_readfirstlane_b32 s51, v118
		s_nop 1
		v_cndmask_b32_e64 v242, v9, v126, s[50:51]
		v_cndmask_b32_e32 v197, v9, v219, vcc
		v_accvgpr_read_b32 v118, a157
		v_cmp_ge_i32_e64 s[50:51], v7, v118
		v_accvgpr_read_b32 v118, a158
		v_cmp_ge_i32_e64 s[52:53], v7, v118
		v_accvgpr_read_b32 v118, a139
		v_cmp_ge_i32_e64 s[54:55], v7, v118
		v_cndmask_b32_e64 v124, v9, v220, s[50:51]
		v_cndmask_b32_e64 v125, v9, v221, s[52:53]
		v_cndmask_b32_e64 v198, v9, v222, s[54:55]
		v_accvgpr_read_b32 v118, a140
		v_cmp_ge_i32_e64 vcc, v7, v118
		v_accvgpr_read_b32 v118, a166
		s_nop 0
		v_readfirstlane_b32 s50, v118
		v_accvgpr_read_b32 v118, a167
		s_nop 0
		v_readfirstlane_b32 s51, v118
		s_nop 1
		v_cndmask_b32_e64 v200, v9, v128, s[50:51]
		v_accvgpr_read_b32 v118, a168
		s_nop 0
		v_readfirstlane_b32 s50, v118
		v_accvgpr_read_b32 v118, a169
		s_nop 0
		v_readfirstlane_b32 s51, v118
		s_nop 1
		v_cndmask_b32_e64 v201, v9, v129, s[50:51]
		v_cndmask_b32_e32 v199, v9, v223, vcc
		v_cmp_ge_i32_e64 s[50:51], v7, v96
		v_cmp_ge_i32_e64 s[52:53], v7, v119
		v_accvgpr_read_b32 v96, a141
		v_cmp_ge_i32_e64 s[54:55], v7, v96
		v_cndmask_b32_e64 v118, v9, v160, s[50:51]
		v_cndmask_b32_e64 v119, v9, v161, s[52:53]
		v_cndmask_b32_e64 v128, v9, v162, s[54:55]
		v_accvgpr_read_b32 v96, a142
		v_cmp_ge_i32_e64 vcc, v7, v96
		v_accvgpr_read_b32 v96, a170
		s_nop 0
		v_readfirstlane_b32 s50, v96
		v_accvgpr_read_b32 v96, a171
		s_nop 0
		v_readfirstlane_b32 s51, v96
		s_nop 1
		v_cndmask_b32_e64 v244, v9, v130, s[50:51]
		v_accvgpr_read_b32 v96, a172
		s_nop 0
		v_readfirstlane_b32 s50, v96
		v_accvgpr_read_b32 v96, a173
		s_nop 0
		v_readfirstlane_b32 s51, v96
		s_nop 1
		v_cndmask_b32_e64 v160, v9, v132, s[50:51]
		v_cndmask_b32_e32 v129, v9, v163, vcc
		v_cmp_ge_i32_e64 s[50:51], v7, v123
		v_cmp_ge_i32_e64 s[52:53], v7, v127
		v_accvgpr_read_b32 v96, a143
		v_cmp_ge_i32_e64 s[54:55], v7, v96
		v_cndmask_b32_e64 v122, v9, v164, s[50:51]
		v_cndmask_b32_e64 v123, v9, v165, s[52:53]
		v_cndmask_b32_e64 v126, v9, v166, s[54:55]
		v_accvgpr_read_b32 v96, a144
		v_cmp_ge_i32_e64 vcc, v7, v96
		v_accvgpr_read_b32 v96, a174
		s_nop 0
		v_readfirstlane_b32 s50, v96
		v_accvgpr_read_b32 v96, a175
		s_nop 0
		v_readfirstlane_b32 s51, v96
		s_nop 1
		v_cndmask_b32_e64 v161, v9, v133, s[50:51]
		v_accvgpr_read_b32 v96, a176
		s_nop 0
		v_readfirstlane_b32 s50, v96
		v_accvgpr_read_b32 v96, a177
		s_nop 0
		v_readfirstlane_b32 s51, v96
		s_nop 1
		v_cndmask_b32_e64 v246, v9, v134, s[50:51]
		v_cndmask_b32_e32 v127, v9, v167, vcc
		v_cmp_ge_i32_e64 s[50:51], v7, v131
		v_cmp_ge_i32_e64 s[52:53], v7, v135
		v_accvgpr_read_b32 v96, a145
		v_cmp_ge_i32_e64 s[54:55], v7, v96
		v_cndmask_b32_e64 v130, v9, v168, s[50:51]
		v_cndmask_b32_e64 v131, v9, v169, s[52:53]
		v_cndmask_b32_e64 v132, v9, v170, s[54:55]
		v_accvgpr_read_b32 v96, a146
		v_cmp_ge_i32_e64 vcc, v7, v96
		v_accvgpr_read_b32 v96, a178
		s_nop 0
		v_readfirstlane_b32 s50, v96
		v_accvgpr_read_b32 v96, a179
		s_nop 0
		v_readfirstlane_b32 s51, v96
		s_nop 1
		v_cndmask_b32_e64 v134, v9, v136, s[50:51]
		v_accvgpr_read_b32 v96, a180
		s_nop 0
		v_readfirstlane_b32 s50, v96
		v_accvgpr_read_b32 v96, a181
		s_nop 0
		v_readfirstlane_b32 s51, v96
		s_nop 1
		v_cndmask_b32_e64 v135, v9, v137, s[50:51]
		v_cndmask_b32_e32 v133, v9, v171, vcc
		v_cmp_ge_i32_e64 s[50:51], v7, v139
		v_cmp_ge_i32_e64 s[52:53], v7, v141
		v_accvgpr_read_b32 v96, a147
		v_cmp_ge_i32_e64 s[54:55], v7, v96
		v_cndmask_b32_e64 v136, v9, v172, s[50:51]
		v_cndmask_b32_e64 v137, v9, v173, s[52:53]
		v_cndmask_b32_e64 v162, v9, v174, s[54:55]
		v_accvgpr_read_b32 v96, a148
		v_cmp_ge_i32_e64 vcc, v7, v96
		v_accvgpr_read_b32 v96, a182
		s_nop 0
		v_readfirstlane_b32 s50, v96
		v_accvgpr_read_b32 v96, a183
		s_nop 0
		v_readfirstlane_b32 s51, v96
		s_nop 1
		v_cndmask_b32_e64 v248, v9, v138, s[50:51]
		v_cndmask_b32_e64 v254, v9, v140, s[40:41]
		v_cndmask_b32_e32 v163, v9, v175, vcc
		v_max3_f32 v96, v100, v101, v230
		v_max3_f32 v138, v24, v25, v234
		v_max3_f32 v139, v28, v29, v236
		v_max3_f32 v140, v114, v115, v238
		v_max3_f32 v141, v188, v189, v240
		v_max3_f32 v164, v192, v193, v242
		v_max3_f32 v165, v200, v201, v244
		v_max3_f32 v166, v160, v161, v246
		v_max3_f32 v167, v134, v135, v248
		v_max3_f32 v168, v254, v255, v252
		v_max3_f32 v13, v13, v27, v18
		v_max3_f32 v18, v96, v231, v138
		v_max3_f32 v96, v139, v237, v140
		v_max3_f32 v138, v141, v241, v164
		v_max3_f32 v139, v165, v245, v166
		v_max3_f32 v140, v167, v249, v168
		v_accvgpr_read_b32 v141, a159
		v_max3_f32 v97, v141, v145, v97
		v_accvgpr_read_b32 v141, a184
		v_accvgpr_read_b32 v164, a185
		v_max3_f32 v141, v141, v153, v164
		v_max3_f32 v13, v13, v229, v18
		v_max3_f32 v18, v96, v239, v138
		v_max3_f32 v96, v139, v247, v140
		v_max3_f32 v97, v97, v149, v141
		v_max3_f32 v13, v13, v235, v18
		v_max3_f32 v18, v96, v253, v97
		v_max3_f32 v13, v13, v243, v18
		v_max_f32_e32 v96, v13, v157
		v_mov_b32_e32 v97, v96
		v_cndmask_b32_e64 v138, v9, v176, s[48:49]
		v_cndmask_b32_e64 v139, v9, v177, s[88:89]
		v_permlane32_swap_b32_e32 v96, v97
		v_max3_f32 v13, v138, v139, v10
		v_max3_f32 v18, v16, v17, v98
		v_max3_f32 v140, v178, v179, v180
		v_max3_f32 v141, v22, v23, v102
		v_max3_f32 v164, v104, v105, v106
		v_max3_f32 v165, v108, v109, v110
		v_max3_f32 v166, v30, v31, v112
		v_max3_f32 v167, v182, v183, v184
		v_max3_f32 v168, v116, v117, v186
		v_max3_f32 v169, v120, v121, v190
		v_max3_f32 v170, v194, v195, v196
		v_max3_f32 v171, v124, v125, v198
		v_max3_f32 v172, v118, v119, v128
		v_max3_f32 v173, v122, v123, v126
		v_max3_f32 v174, v130, v131, v132
		v_max3_f32 v175, v136, v137, v162
		v_max3_f32 v13, v13, v11, v18
		v_max3_f32 v18, v140, v181, v141
		v_max3_f32 v140, v164, v107, v165
		v_max3_f32 v141, v166, v113, v167
		v_max3_f32 v164, v168, v187, v169
		v_max3_f32 v165, v170, v197, v171
		v_max3_f32 v166, v172, v129, v173
		v_max3_f32 v167, v174, v133, v175
		v_max3_f32 v13, v13, v99, v18
		v_max3_f32 v18, v140, v111, v141
		v_max3_f32 v140, v164, v191, v165
		v_max3_f32 v141, v166, v127, v167
		v_max3_f32 v13, v13, v103, v18
		v_max3_f32 v18, v140, v199, v141
		v_max3_f32 v13, v13, v185, v18
		v_max_f32_e32 v140, v13, v163
		v_mov_b32_e32 v141, v140
		v_max_f32_e32 v164, v96, v97
		v_mov_b32_e32 v96, v2
		v_permlane32_swap_b32_e32 v140, v141
		v_max_f32_e32 v165, v140, v141
		v_pk_mul_f32 v[140:141], v[164:165], v[4:5]
		v_max_f32_e32 v164, v2, v140
		v_max_f32_e32 v165, v8, v141
		v_pk_fma_f32 v[140:141], v[250:251], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[26:27], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[158:159], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[228:229], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[100:101], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[230:231], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[24:25], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[234:235], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[28:29], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[236:237], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[114:115], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[238:239], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[188:189], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[240:241], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[192:193], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[242:243], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[200:201], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[244:245], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[160:161], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[246:247], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[134:135], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[248:249], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[254:255], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[252:253], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[142:143], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[144:145], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[146:147], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[148:149], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[150:151], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[154:155], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[156:157], v[4:5], v[164:165] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[138:139], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[10:11], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[10:11], v[16:17], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[16:17], v[98:99], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[178:179], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[180:181], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[22:23], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[22:23], v[102:103], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[108:109], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[110:111], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[30:31], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[112:113], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[182:183], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[184:185], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[116:117], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[186:187], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[120:121], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[190:191], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[194:195], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[196:197], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[124:125], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[198:199], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[118:119], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[128:129], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[122:123], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[126:127], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[130:131], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[132:133], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[136:137], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[162:163], v[4:5], v[164:165] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v162, v140
		v_exp_f32_e32 v216, v141
		v_exp_f32_e32 v140, v166
		v_exp_f32_e32 v218, v167
		v_exp_f32_e32 v166, v26
		v_exp_f32_e32 v220, v27
		v_exp_f32_e32 v26, v158
		v_exp_f32_e32 v222, v159
		v_exp_f32_e32 v158, v168
		v_exp_f32_e32 v224, v169
		v_exp_f32_e32 v168, v100
		v_exp_f32_e32 v226, v101
		v_exp_f32_e32 v100, v170
		v_exp_f32_e32 v228, v171
		v_exp_f32_e32 v170, v24
		v_exp_f32_e32 v230, v25
		v_exp_f32_e32 v24, v172
		v_exp_f32_e32 v232, v173
		v_exp_f32_e32 v172, v28
		v_exp_f32_e32 v234, v29
		v_exp_f32_e32 v28, v174
		v_exp_f32_e32 v236, v175
		v_exp_f32_e32 v174, v114
		v_exp_f32_e32 v238, v115
		v_exp_f32_e32 v114, v176
		v_exp_f32_e32 v240, v177
		v_exp_f32_e32 v176, v188
		v_exp_f32_e32 v242, v189
		v_exp_f32_e32 v188, v202
		v_exp_f32_e32 v244, v203
		v_exp_f32_e32 v202, v192
		v_exp_f32_e32 v246, v193
		v_exp_f32_e32 v163, v204
		v_exp_f32_e32 v217, v205
		v_exp_f32_e32 v141, v200
		v_exp_f32_e32 v219, v201
		v_exp_f32_e32 v167, v206
		v_exp_f32_e32 v221, v207
		v_exp_f32_e32 v27, v160
		v_exp_f32_e32 v223, v161
		v_exp_f32_e32 v159, v208
		v_exp_f32_e32 v225, v209
		v_exp_f32_e32 v169, v134
		v_exp_f32_e32 v227, v135
		v_exp_f32_e32 v101, v210
		v_exp_f32_e32 v229, v211
		v_exp_f32_e32 v171, v212
		v_exp_f32_e32 v231, v213
		v_exp_f32_e32 v25, v214
		v_exp_f32_e32 v233, v215
		v_exp_f32_e32 v173, v142
		v_exp_f32_e32 v235, v143
		v_exp_f32_e32 v29, v144
		v_exp_f32_e32 v237, v145
		v_exp_f32_e32 v175, v146
		v_exp_f32_e32 v239, v147
		v_exp_f32_e32 v115, v148
		v_exp_f32_e32 v241, v149
		v_exp_f32_e32 v177, v150
		v_exp_f32_e32 v243, v151
		v_exp_f32_e32 v189, v152
		v_exp_f32_e32 v245, v153
		v_exp_f32_e32 v203, v154
		v_exp_f32_e32 v247, v155
		v_exp_f32_e32 v134, v156
		v_exp_f32_e32 v142, v157
		v_exp_f32_e32 v144, v138
		v_exp_f32_e32 v146, v139
		v_exp_f32_e32 v138, v10
		v_exp_f32_e32 v148, v11
		v_exp_f32_e32 v10, v16
		v_exp_f32_e32 v150, v17
		v_exp_f32_e32 v16, v98
		v_exp_f32_e32 v152, v99
		v_exp_f32_e32 v98, v178
		v_exp_f32_e32 v154, v179
		v_exp_f32_e32 v156, v180
		v_exp_f32_e32 v160, v181
		v_exp_f32_e32 v178, v22
		v_exp_f32_e32 v180, v23
		v_exp_f32_e32 v22, v102
		v_exp_f32_e32 v192, v103
		v_exp_f32_e32 v102, v104
		v_exp_f32_e32 v200, v105
		v_exp_f32_e32 v104, v106
		v_exp_f32_e32 v204, v107
		v_exp_f32_e32 v106, v108
		v_exp_f32_e32 v206, v109
		v_exp_f32_e32 v108, v110
		v_exp_f32_e32 v208, v111
		v_exp_f32_e32 v110, v30
		v_exp_f32_e32 v210, v31
		v_exp_f32_e32 v30, v112
		v_exp_f32_e32 v212, v113
		v_exp_f32_e32 v112, v182
		v_exp_f32_e32 v214, v183
		v_exp_f32_e32 v135, v184
		v_exp_f32_e32 v143, v185
		v_exp_f32_e32 v145, v116
		v_exp_f32_e32 v147, v117
		v_exp_f32_e32 v139, v186
		v_exp_f32_e32 v149, v187
		v_exp_f32_e32 v11, v120
		v_exp_f32_e32 v151, v121
		v_exp_f32_e32 v17, v190
		v_exp_f32_e32 v153, v191
		v_exp_f32_e32 v99, v194
		v_exp_f32_e32 v155, v195
		v_exp_f32_e32 v157, v196
		v_exp_f32_e32 v161, v197
		v_exp_f32_e32 v179, v124
		v_exp_f32_e32 v181, v125
		v_exp_f32_e32 v23, v198
		v_exp_f32_e32 v193, v199
		v_exp_f32_e32 v103, v118
		v_exp_f32_e32 v201, v119
		v_exp_f32_e32 v105, v128
		v_exp_f32_e32 v205, v129
		v_exp_f32_e32 v107, v122
		v_exp_f32_e32 v207, v123
		v_exp_f32_e32 v109, v126
		v_exp_f32_e32 v209, v127
		v_exp_f32_e32 v111, v130
		v_exp_f32_e32 v211, v131
		v_exp_f32_e32 v31, v132
		v_exp_f32_e32 v213, v133
		v_exp_f32_e32 v113, v136
		v_exp_f32_e32 v215, v137
		v_pk_add_f32 v[116:117], v[162:163], v[216:217]
		v_pk_add_f32 v[118:119], v[140:141], v[218:219]
		v_pk_add_f32 v[120:121], v[166:167], v[220:221]
		v_pk_add_f32 v[122:123], v[26:27], v[222:223]
		v_pk_add_f32 v[124:125], v[158:159], v[224:225]
		v_pk_add_f32 v[126:127], v[168:169], v[226:227]
		v_pk_add_f32 v[128:129], v[100:101], v[228:229]
		v_pk_add_f32 v[130:131], v[170:171], v[230:231]
		v_pk_add_f32 v[132:133], v[24:25], v[232:233]
		v_pk_add_f32 v[136:137], v[172:173], v[234:235]
		v_pk_add_f32 v[182:183], v[28:29], v[236:237]
		v_pk_add_f32 v[184:185], v[174:175], v[238:239]
		v_pk_add_f32 v[186:187], v[114:115], v[240:241]
		v_pk_add_f32 v[190:191], v[176:177], v[242:243]
		v_pk_add_f32 v[194:195], v[188:189], v[244:245]
		v_pk_add_f32 v[196:197], v[202:203], v[246:247]
		v_pk_add_f32 v[116:117], v[116:117], v[118:119]
		v_pk_add_f32 v[118:119], v[120:121], v[122:123]
		v_pk_add_f32 v[120:121], v[124:125], v[126:127]
		v_pk_add_f32 v[122:123], v[128:129], v[130:131]
		v_pk_add_f32 v[124:125], v[132:133], v[136:137]
		v_pk_add_f32 v[126:127], v[182:183], v[184:185]
		v_pk_add_f32 v[128:129], v[186:187], v[190:191]
		v_pk_add_f32 v[130:131], v[194:195], v[196:197]
		v_pk_add_f32 v[116:117], v[116:117], v[118:119]
		v_pk_add_f32 v[118:119], v[120:121], v[122:123]
		v_pk_add_f32 v[120:121], v[124:125], v[126:127]
		v_pk_add_f32 v[122:123], v[128:129], v[130:131]
		v_pk_add_f32 v[116:117], v[116:117], v[118:119]
		v_pk_add_f32 v[118:119], v[120:121], v[122:123]
		v_pk_add_f32 v[120:121], v[116:117], v[118:119]
		v_add_f32_e32 v2, v120, v121
		v_accvgpr_read_b32 v13, a75
		ds_bpermute_b32 v116, v13, v2
		v_accvgpr_read_b32 v13, a76
		ds_bpermute_b32 v118, v13, v2
		v_pk_add_f32 v[120:121], v[134:135], v[142:143]
		v_pk_add_f32 v[122:123], v[144:145], v[146:147]
		v_pk_add_f32 v[124:125], v[138:139], v[148:149]
		v_pk_add_f32 v[126:127], v[10:11], v[150:151]
		v_pk_add_f32 v[128:129], v[16:17], v[152:153]
		v_pk_add_f32 v[130:131], v[98:99], v[154:155]
		v_pk_add_f32 v[132:133], v[156:157], v[160:161]
		v_pk_add_f32 v[136:137], v[178:179], v[180:181]
		v_pk_add_f32 v[182:183], v[22:23], v[192:193]
		v_pk_add_f32 v[184:185], v[102:103], v[200:201]
		v_pk_add_f32 v[186:187], v[104:105], v[204:205]
		v_pk_add_f32 v[190:191], v[106:107], v[206:207]
		v_pk_add_f32 v[194:195], v[108:109], v[208:209]
		v_pk_add_f32 v[196:197], v[110:111], v[210:211]
		v_pk_add_f32 v[198:199], v[30:31], v[212:213]
		v_pk_add_f32 v[248:249], v[112:113], v[214:215]
		v_pk_add_f32 v[120:121], v[120:121], v[122:123]
		v_pk_add_f32 v[122:123], v[124:125], v[126:127]
		v_pk_add_f32 v[124:125], v[128:129], v[130:131]
		v_pk_add_f32 v[126:127], v[132:133], v[136:137]
		v_pk_add_f32 v[128:129], v[182:183], v[184:185]
		v_pk_add_f32 v[130:131], v[186:187], v[190:191]
		v_pk_add_f32 v[132:133], v[194:195], v[196:197]
		v_pk_add_f32 v[136:137], v[198:199], v[248:249]
		v_pk_add_f32 v[120:121], v[120:121], v[122:123]
		v_pk_add_f32 v[122:123], v[124:125], v[126:127]
		v_pk_add_f32 v[124:125], v[128:129], v[130:131]
		v_pk_add_f32 v[126:127], v[132:133], v[136:137]
		v_pk_add_f32 v[120:121], v[120:121], v[122:123]
		v_pk_add_f32 v[122:123], v[124:125], v[126:127]
		v_pk_add_f32 v[124:125], v[120:121], v[122:123]
		v_mov_b32_e32 v119, v125
		v_mov_b32_e32 v117, v124
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[120:121], v[116:117], v[118:119]
		v_mov_b32_e32 v116, v121
		v_mov_b32_e32 v117, v121
		v_cvt_pk_bf16_f32 v124, v162, v216
		v_cvt_pk_bf16_f32 v125, v140, v218
		v_permlane32_swap_b32_e32 v116, v117
		v_add_f32_e32 v119, v116, v117
		v_mov_b32_e32 v97, v8
		v_pk_add_f32 v[116:117], v[96:97], v[164:165] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v96, v116
		v_exp_f32_e32 v97, v117
		v_cvt_pk_bf16_f32 v126, v166, v220
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
		v_mov_b32_e32 v118, v120
		v_mov_b64_e32 v[116:117], v[14:15]
		v_pk_fma_f32 v[14:15], v[116:117], v[96:97], v[118:119]
		v_cvt_pk_bf16_f32 v127, v26, v222
		v_cvt_pk_bf16_f32 v116, v158, v224
		v_cvt_pk_bf16_f32 v117, v168, v226
		v_cvt_pk_bf16_f32 v118, v100, v228
		v_cvt_pk_bf16_f32 v119, v170, v230
		v_cvt_pk_bf16_f32 v120, v24, v232
		v_cvt_pk_bf16_f32 v121, v172, v234
		v_cvt_pk_bf16_f32 v122, v28, v236
		v_cvt_pk_bf16_f32 v123, v174, v238
		v_cvt_pk_bf16_f32 v128, v114, v240
		v_cvt_pk_bf16_f32 v129, v176, v242
		v_cvt_pk_bf16_f32 v130, v188, v244
		v_cvt_pk_bf16_f32 v131, v202, v246
		v_cvt_pk_bf16_f32 v184, v163, v217
		v_cvt_pk_bf16_f32 v185, v141, v219
		v_cvt_pk_bf16_f32 v186, v167, v221
		v_cvt_pk_bf16_f32 v187, v27, v223
		v_cvt_pk_bf16_f32 v196, v159, v225
		v_cvt_pk_bf16_f32 v197, v169, v227
		v_cvt_pk_bf16_f32 v198, v101, v229
		v_cvt_pk_bf16_f32 v199, v171, v231
		v_cvt_pk_bf16_f32 v168, v25, v233
		v_cvt_pk_bf16_f32 v169, v173, v235
		v_cvt_pk_bf16_f32 v170, v29, v237
		v_cvt_pk_bf16_f32 v171, v175, v239
		v_cvt_pk_bf16_f32 v24, v115, v241
		v_cvt_pk_bf16_f32 v25, v177, v243
		v_cvt_pk_bf16_f32 v26, v189, v245
		v_cvt_pk_bf16_f32 v27, v203, v247
		v_cvt_pk_bf16_f32 v172, v134, v142
		v_cvt_pk_bf16_f32 v173, v144, v146
		v_cvt_pk_bf16_f32 v174, v138, v148
		v_cvt_pk_bf16_f32 v175, v10, v150
		v_cvt_pk_bf16_f32 v188, v16, v152
		v_cvt_pk_bf16_f32 v189, v98, v154
		v_cvt_pk_bf16_f32 v190, v156, v160
		v_cvt_pk_bf16_f32 v191, v178, v180
		v_cvt_pk_bf16_f32 v216, v22, v192
		v_cvt_pk_bf16_f32 v217, v102, v200
		v_cvt_pk_bf16_f32 v218, v104, v204
		v_cvt_pk_bf16_f32 v219, v106, v206
		v_cvt_pk_bf16_f32 v220, v108, v208
		v_cvt_pk_bf16_f32 v221, v110, v210
		v_cvt_pk_bf16_f32 v222, v30, v212
		v_cvt_pk_bf16_f32 v223, v112, v214
		v_cvt_pk_bf16_f32 v224, v135, v143
		v_cvt_pk_bf16_f32 v225, v145, v147
		v_cvt_pk_bf16_f32 v226, v139, v149
		v_cvt_pk_bf16_f32 v227, v11, v151
		v_cvt_pk_bf16_f32 v132, v17, v153
		v_cvt_pk_bf16_f32 v133, v99, v155
		v_cvt_pk_bf16_f32 v134, v157, v161
		v_cvt_pk_bf16_f32 v135, v179, v181
		v_cvt_pk_bf16_f32 v96, v23, v193
		v_cvt_pk_bf16_f32 v97, v103, v201
		v_cvt_pk_bf16_f32 v98, v105, v205
		v_cvt_pk_bf16_f32 v99, v107, v207
		v_cvt_pk_bf16_f32 v100, v109, v209
		v_cvt_pk_bf16_f32 v101, v111, v211
		v_cvt_pk_bf16_f32 v102, v31, v213
		v_cvt_pk_bf16_f32 v103, v113, v215
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[32:47], a[188:191], v[124:127], v[32:47]
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_mfma_f32_32x32x16_bf16 v[48:63], a[220:223], v[124:127], v[48:63]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[116:119], v[32:47]
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[116:119], v[48:63]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[120:123], v[32:47]
		v_permlane32_swap_b32_e32 v168, v170
		v_permlane32_swap_b32_e32 v169, v171
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[120:123], v[48:63]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[128:131], v[32:47]
		v_permlane32_swap_b32_e32 v172, v174
		v_permlane32_swap_b32_e32 v173, v175
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[128:131], v[48:63]
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[80:95], a[220:223], v[172:175], v[80:95]
		v_permlane32_swap_b32_e32 v216, v218
		v_permlane32_swap_b32_e32 v217, v219
		v_mfma_f32_32x32x16_bf16 v[64:79], a[188:191], v[172:175], v[64:79]
		v_permlane32_swap_b32_e32 v220, v222
		v_permlane32_swap_b32_e32 v221, v223
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[188:191], v[80:95]
		v_permlane32_swap_b32_e32 v224, v226
		v_permlane32_swap_b32_e32 v225, v227
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[188:191], v[64:79]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[216:219], v[80:95]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[216:219], v[64:79]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[220:223], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[220:223], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[184:187], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[184:187], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[224:227], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[224:227], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[196:199], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[196:199], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[132:135], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[132:135], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[168:171], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[168:171], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[216:219], v[24:27], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[248:251], v[24:27], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[248:251], v[100:103], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[216:219], v[100:103], v[64:79]
		s_cselect_b32 s19, 1, 0
		s_add_i32 s33, s42, 0x80
		s_cmp_lg_u32 s19, 0
		s_mov_b32 s42, s33
		v_mov_b32_e32 v2, v164
		v_mov_b32_e32 v8, v165
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_4
.L_attn_fwd_persistent.loop_exit_4:
		s_mov_b32 s24, s8
		s_mov_b32 s25, s9
		s_mov_b32 s26, s38
		s_mov_b32 s27, s39
		v_rcp_f32_e32 v2, v14
		v_accvgpr_read_b32 v1, a11
		s_nop 0
		v_readfirstlane_b32 s1, v1
		s_mul_i32 s1, s1, s18
		v_mov_b32_e32 v3, v2
		v_pk_mul_f32 v[4:5], v[32:33], v[2:3]
		v_pk_mul_f32 v[6:7], v[34:35], v[2:3]
		v_pk_mul_f32 v[8:9], v[36:37], v[2:3]
		v_pk_mul_f32 v[10:11], v[38:39], v[2:3]
		v_pk_mul_f32 v[12:13], v[40:41], v[2:3]
		v_pk_mul_f32 v[16:17], v[42:43], v[2:3]
		v_pk_mul_f32 v[18:19], v[44:45], v[2:3]
		v_pk_mul_f32 v[22:23], v[46:47], v[2:3]
		v_pk_mul_f32 v[24:25], v[48:49], v[2:3]
		v_pk_mul_f32 v[26:27], v[50:51], v[2:3]
		v_pk_mul_f32 v[28:29], v[52:53], v[2:3]
		v_pk_mul_f32 v[30:31], v[54:55], v[2:3]
		v_pk_mul_f32 v[32:33], v[56:57], v[2:3]
		v_pk_mul_f32 v[34:35], v[58:59], v[2:3]
		v_pk_mul_f32 v[36:37], v[60:61], v[2:3]
		v_pk_mul_f32 v[38:39], v[62:63], v[2:3]
		v_rcp_f32_e32 v2, v15
		v_cvt_pk_bf16_f32 v40, v4, v5
		v_mov_b32_e32 v3, v2
		v_pk_mul_f32 v[4:5], v[64:65], v[2:3]
		v_pk_mul_f32 v[14:15], v[66:67], v[2:3]
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
		v_cvt_pk_bf16_f32 v9, v16, v17
		v_cvt_pk_bf16_f32 v10, v18, v19
		v_cvt_pk_bf16_f32 v11, v22, v23
		v_cvt_pk_bf16_f32 v16, v24, v25
		v_cvt_pk_bf16_f32 v17, v26, v27
		v_cvt_pk_bf16_f32 v18, v28, v29
		v_cvt_pk_bf16_f32 v19, v30, v31
		v_cvt_pk_bf16_f32 v24, v32, v33
		v_cvt_pk_bf16_f32 v25, v34, v35
		v_cvt_pk_bf16_f32 v26, v36, v37
		v_cvt_pk_bf16_f32 v27, v38, v39
		v_cvt_pk_bf16_f32 v28, v4, v5
		v_cvt_pk_bf16_f32 v29, v14, v15
		v_cvt_pk_bf16_f32 v30, v44, v45
		v_cvt_pk_bf16_f32 v31, v46, v47
		v_cvt_pk_bf16_f32 v4, v48, v49
		v_cvt_pk_bf16_f32 v5, v50, v51
		v_cvt_pk_bf16_f32 v6, v52, v53
		v_cvt_pk_bf16_f32 v7, v54, v55
		v_cvt_pk_bf16_f32 v12, v56, v57
		v_cvt_pk_bf16_f32 v13, v58, v59
		v_cvt_pk_bf16_f32 v14, v60, v61
		v_cvt_pk_bf16_f32 v15, v62, v63
		v_cvt_pk_bf16_f32 v32, v64, v65
		v_cvt_pk_bf16_f32 v33, v66, v67
		v_cvt_pk_bf16_f32 v34, v68, v69
		v_cvt_pk_bf16_f32 v35, v70, v71
		v_permlane32_swap_b32_e32 v40, v42
		v_permlane32_swap_b32_e32 v41, v43
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_permlane32_swap_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v5, v7
		v_permlane32_swap_b32_e32 v12, v14
		v_permlane32_swap_b32_e32 v13, v15
		v_permlane32_swap_b32_e32 v32, v34
		v_permlane32_swap_b32_e32 v33, v35
		s_lshl_b32 s1, s1, 9
		v_accvgpr_read_b32 v1, a2
		s_nop 0
		v_readfirstlane_b32 s19, v1
		v_accvgpr_read_b32 v1, a15
		s_nop 0
		v_readfirstlane_b32 s22, v1
		s_mul_i32 s19, s22, s19
		s_lshl_b32 s19, s19, 1
		s_add_i32 s22, s1, s19
		v_accvgpr_read_b32 v1, a3
		s_nop 0
		v_readfirstlane_b32 s23, v1
		v_accvgpr_read_b32 v1, a10
		s_nop 0
		v_readfirstlane_b32 s28, v1
		s_mul_i32 s23, s28, s23
		s_lshl_b32 s23, s23, 1
		s_add_i32 s22, s22, s23
		v_accvgpr_read_b32 v1, a12
		v_mul_lo_u32 v1, s18, v1
		v_lshl_add_u32 v2, v1, 6, s22
		v_accvgpr_read_b32 v3, a16
		v_mul_lo_u32 v3, s18, v3
		v_lshl_add_u32 v2, v3, 1, v2
		v_accvgpr_read_b32 v22, a20
		v_mul_lo_u32 v22, s18, v22
		v_lshl_add_u32 v2, v22, 5, v2
		v_accvgpr_read_b32 v23, a22
		v_mul_lo_u32 v23, s18, v23
		v_lshl_add_u32 v2, v23, 4, v2
		v_accvgpr_read_b32 v36, a17
		v_mul_lo_u32 v36, s18, v36
		v_lshl_add_u32 v2, v36, 3, v2
		v_accvgpr_read_b32 v37, a18
		v_mul_lo_u32 v37, s18, v37
		v_lshl_add_u32 v2, v37, 2, v2
		v_accvgpr_read_b32 v38, a19
		v_lshl_add_u32 v2, v38, 4, v2
		v_readfirstlane_b32 s28, v20
		v_readfirstlane_b32 s29, v21
		s_and_saveexec_b64 s[94:95], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_24
		buffer_store_dwordx4 v[40:43], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_24:
		s_andn2_b64 exec, s[94:95], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_24
.L_attn_fwd_persistent.exec_endif_24:
		s_mov_b64 exec, s[94:95]
		s_add_i32 s22, s1, 32
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s23
		v_lshl_add_u32 v2, v1, 6, s22
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v22, 5, v2
		v_lshl_add_u32 v2, v23, 4, v2
		v_lshl_add_u32 v2, v36, 3, v2
		v_lshl_add_u32 v2, v37, 2, v2
		v_accvgpr_read_b32 v38, a19
		v_lshl_add_u32 v2, v38, 4, v2
		v_readfirstlane_b32 s28, v20
		v_readfirstlane_b32 s29, v21
		s_and_saveexec_b64 s[94:95], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_25
		buffer_store_dwordx4 v[8:11], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_25:
		s_andn2_b64 exec, s[94:95], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_25
.L_attn_fwd_persistent.exec_endif_25:
		s_mov_b64 exec, s[94:95]
		s_add_i32 s22, s1, 64
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s23
		v_lshl_add_u32 v2, v1, 6, s22
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v22, 5, v2
		v_lshl_add_u32 v2, v23, 4, v2
		v_lshl_add_u32 v2, v36, 3, v2
		v_lshl_add_u32 v2, v37, 2, v2
		v_accvgpr_read_b32 v8, a19
		v_lshl_add_u32 v2, v8, 4, v2
		v_readfirstlane_b32 s28, v20
		v_readfirstlane_b32 s29, v21
		s_and_saveexec_b64 s[94:95], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_26
		buffer_store_dwordx4 v[16:19], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_26:
		s_andn2_b64 exec, s[94:95], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_26
.L_attn_fwd_persistent.exec_endif_26:
		s_mov_b64 exec, s[94:95]
		s_add_i32 s22, s1, 0x60
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s23
		v_lshl_add_u32 v2, v1, 6, s22
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v22, 5, v2
		v_lshl_add_u32 v2, v23, 4, v2
		v_lshl_add_u32 v2, v36, 3, v2
		v_lshl_add_u32 v2, v37, 2, v2
		v_accvgpr_read_b32 v8, a19
		v_lshl_add_u32 v2, v8, 4, v2
		v_readfirstlane_b32 s28, v20
		v_readfirstlane_b32 s29, v21
		s_and_saveexec_b64 s[94:95], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_27
		buffer_store_dwordx4 v[24:27], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_27:
		s_andn2_b64 exec, s[94:95], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_27
.L_attn_fwd_persistent.exec_endif_27:
		s_mov_b64 exec, s[94:95]
		s_lshl_b32 s22, s18, 8
		s_add_i32 s28, s22, s1
		s_add_i32 s28, s28, s19
		s_add_i32 s28, s28, s23
		v_lshl_add_u32 v2, v1, 6, s28
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v22, 5, v2
		v_lshl_add_u32 v2, v23, 4, v2
		v_lshl_add_u32 v2, v36, 3, v2
		v_lshl_add_u32 v2, v37, 2, v2
		v_accvgpr_read_b32 v8, a19
		v_lshl_add_u32 v2, v8, 4, v2
		v_accvgpr_read_b32 v8, a58
		s_nop 0
		v_readfirstlane_b32 s28, v8
		v_accvgpr_read_b32 v8, a59
		s_nop 0
		v_readfirstlane_b32 s29, v8
		s_and_saveexec_b64 s[94:95], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_28
		buffer_store_dwordx4 v[28:31], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_28:
		s_andn2_b64 exec, s[94:95], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_28
.L_attn_fwd_persistent.exec_endif_28:
		s_mov_b64 exec, s[94:95]
		s_add_i32 s28, s22, 32
		s_add_i32 s28, s28, s1
		s_add_i32 s28, s28, s19
		s_add_i32 s28, s28, s23
		v_lshl_add_u32 v2, v1, 6, s28
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v22, 5, v2
		v_lshl_add_u32 v2, v23, 4, v2
		v_lshl_add_u32 v2, v36, 3, v2
		v_lshl_add_u32 v2, v37, 2, v2
		v_accvgpr_read_b32 v8, a19
		v_lshl_add_u32 v2, v8, 4, v2
		v_accvgpr_read_b32 v8, a58
		s_nop 0
		v_readfirstlane_b32 s28, v8
		v_accvgpr_read_b32 v8, a59
		s_nop 0
		v_readfirstlane_b32 s29, v8
		s_and_saveexec_b64 s[94:95], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_29
		buffer_store_dwordx4 v[4:7], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_29:
		s_andn2_b64 exec, s[94:95], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_29
.L_attn_fwd_persistent.exec_endif_29:
		s_mov_b64 exec, s[94:95]
		s_add_i32 s28, s22, 64
		s_add_i32 s28, s28, s1
		s_add_i32 s28, s28, s19
		s_add_i32 s28, s28, s23
		v_lshl_add_u32 v2, v1, 6, s28
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v22, 5, v2
		v_lshl_add_u32 v2, v23, 4, v2
		v_lshl_add_u32 v2, v36, 3, v2
		v_lshl_add_u32 v2, v37, 2, v2
		v_accvgpr_read_b32 v4, a19
		v_lshl_add_u32 v2, v4, 4, v2
		v_accvgpr_read_b32 v4, a58
		s_nop 0
		v_readfirstlane_b32 s28, v4
		v_accvgpr_read_b32 v4, a59
		s_nop 0
		v_readfirstlane_b32 s29, v4
		s_and_saveexec_b64 s[94:95], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_30
		buffer_store_dwordx4 v[12:15], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_30:
		s_andn2_b64 exec, s[94:95], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_30
.L_attn_fwd_persistent.exec_endif_30:
		s_mov_b64 exec, s[94:95]
		s_add_i32 s22, s22, 0x60
		s_add_i32 s1, s22, s1
		s_add_i32 s1, s1, s19
		s_add_i32 s1, s1, s23
		v_lshl_add_u32 v1, v1, 6, s1
		v_lshl_add_u32 v1, v3, 1, v1
		v_lshl_add_u32 v1, v22, 5, v1
		v_lshl_add_u32 v1, v23, 4, v1
		v_lshl_add_u32 v1, v36, 3, v1
		v_lshl_add_u32 v1, v37, 2, v1
		v_accvgpr_read_b32 v2, a19
		v_lshl_add_u32 v1, v2, 4, v1
		v_accvgpr_read_b32 v2, a58
		s_nop 0
		v_readfirstlane_b32 s22, v2
		v_accvgpr_read_b32 v2, a59
		s_nop 0
		v_readfirstlane_b32 s23, v2
		s_and_saveexec_b64 s[94:95], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_31
		buffer_store_dwordx4 v[32:35], v1, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_31:
		s_andn2_b64 exec, s[94:95], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_31
.L_attn_fwd_persistent.exec_endif_31:
		s_mov_b64 exec, s[94:95]
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
		.amdhsa_next_free_sgpr 96
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
	.set .L_attn_fwd_persistent.numbered_sgpr, 96
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
    .sgpr_count:     96
    .sgpr_spill_count: 0
    .symbol:         _attn_fwd_persistent.kd
    .uses_dynamic_stack: false
    .vgpr_count:     512
    .agpr_count:     256
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 430
    wave.regalloc.agpr.dwords: 809
    wave.regalloc.remat.dwords: 7
    wave.regalloc.sgpr_to_vgpr.dwords: 77
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
