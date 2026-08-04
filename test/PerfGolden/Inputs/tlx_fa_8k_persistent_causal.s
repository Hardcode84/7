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
		s_xor_b32 s25, s24, -1
		v_readfirstlane_b32 s26, v1
		s_add_i32 s25, s25, 1
		s_mul_i32 s27, s25, s26
		s_mul_hi_u32 s27, s26, s27
		s_add_i32 s26, s26, s27
		s_mul_hi_u32 s26, s22, s26
		s_mul_i32 s27, s26, s24
		s_xor_b32 s27, s27, -1
		s_add_i32 s27, s27, 1
		s_add_i32 s22, s22, s27
		s_cmp_ge_u32 s22, s24
		s_cselect_b32 s27, 1, 0
		s_add_i32 s28, s26, 1
		s_cmp_lg_u32 s27, 0
		s_cselect_b32 s26, s28, s26
		s_cselect_b32 s27, 1, 0
		s_add_i32 s28, s22, s25
		s_cmp_lg_u32 s27, 0
		s_cselect_b32 s22, s28, s22
		s_cmp_ge_u32 s22, s24
		s_cselect_b32 s24, 1, 0
		s_add_i32 s27, s26, 1
		s_cmp_lg_u32 s24, 0
		s_cselect_b32 s24, s27, s26
		s_cselect_b32 s26, 1, 0
		v_accvgpr_read_b32 v1, a4
		s_nop 0
		v_readfirstlane_b32 s27, v1
		s_xor_b32 s1, s1, s27
		s_xor_b32 s27, s24, -1
		s_add_i32 s27, s27, 1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s1, s27, s24
		v_mov_b32_e32 v1, s1
		s_add_i32 s1, s22, s25
		s_cmp_lg_u32 s26, 0
		s_cselect_b32 s1, s1, s22
		s_xor_b32 s22, s1, -1
		s_add_i32 s22, s22, 1
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s1, s22, s1
		v_mov_b32_e32 v2, s1
		v_accvgpr_write_b32 a10, v2
		s_mul_i32 s1, s19, 2
		s_cmp_lt_i32 s1, 32
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_1
		s_lshr_b32 s19, s1, 1
		s_and_b32 s1, s1, 1
		s_xor_b32 s22, s19, -1
		s_add_i32 s22, s22, 1
		s_add_i32 s22, s22, 31
		s_cmp_eq_u32 s1, 0
		s_cselect_b32 s1, s19, s22
		v_mov_b32_e32 v2, s1
		v_accvgpr_write_b32 a11, v2
		v_accvgpr_read_b32 v2, a11
		s_nop 0
		v_readfirstlane_b32 s1, v2
		s_mul_i32 s1, s1, 0x100
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
		v_xad_u32 v10, v10, v15, s1
		v_bitop3_b32 v17, 32, v9, v2 bitop3:0x96
		v_bitop3_b32 v17, v17, v7, v13 bitop3:0x96
		v_xad_u32 v17, v17, v15, s1
		v_bitop3_b32 v18, 64, v9, v2 bitop3:0x96
		v_bitop3_b32 v18, v18, v7, v13 bitop3:0x96
		v_xad_u32 v18, v18, v15, s1
		v_xor_b32_e32 v19, 0x60, v9
		v_xor_b32_e32 v19, v19, v2
		v_xor_b32_e32 v19, v19, v7
		v_xor_b32_e32 v19, v19, v13
		v_xad_u32 v19, v19, v15, s1
		v_xor_b32_e32 v20, 0x80, v9
		v_xor_b32_e32 v20, v20, v2
		v_xor_b32_e32 v20, v20, v7
		v_xor_b32_e32 v20, v20, v13
		v_xad_u32 v20, v20, v15, s1
		v_xor_b32_e32 v21, 0xa0, v9
		v_xor_b32_e32 v21, v21, v2
		v_xor_b32_e32 v21, v21, v7
		v_xor_b32_e32 v21, v21, v13
		v_xad_u32 v21, v21, v15, s1
		v_xor_b32_e32 v22, 0xc0, v9
		v_xor_b32_e32 v22, v22, v2
		v_xor_b32_e32 v22, v22, v7
		v_xor_b32_e32 v22, v22, v13
		v_xad_u32 v22, v22, v15, s1
		v_xor_b32_e32 v23, 0xe0, v9
		v_xor_b32_e32 v2, v23, v2
		v_xor_b32_e32 v2, v2, v7
		v_xor_b32_e32 v2, v2, v13
		v_xad_u32 v2, v2, v15, s1
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
		v_readfirstlane_b32 s19, v10
		s_mul_i32 s19, s19, s12
		s_lshl_b32 s19, s19, 9
		v_readfirstlane_b32 s40, v1
		s_mul_i32 s40, s40, s10
		s_lshl_b32 s40, s40, 1
		s_add_i32 s41, s19, s40
		v_accvgpr_read_b32 v10, a10
		s_nop 0
		v_readfirstlane_b32 s42, v10
		s_mul_i32 s42, s42, s11
		s_lshl_b32 s42, s42, 1
		s_add_i32 s41, s41, s42
		v_mul_lo_u32 v10, s12, v8
		v_lshl_add_u32 v13, v10, 1, s41
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
		s_and_saveexec_b64 s[100:101], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_0
		buffer_load_dwordx4 v[24:27], v3, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_0:
		s_andn2_b64 exec, s[100:101], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_0
		v_mov_b32_e32 v24, v20
		v_mov_b32_e32 v25, v21
		v_mov_b32_e32 v26, v22
		v_mov_b32_e32 v27, v23
.L_attn_fwd_persistent.exec_endif_0:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s22, s12, 6
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s40
		s_add_i32 s22, s22, s42
		v_lshl_add_u32 v3, v10, 1, s22
		v_accvgpr_read_b32 v13, a15
		v_lshl_add_u32 v3, v13, 4, v3
		v_accvgpr_read_b32 v13, a16
		v_lshl_add_u32 v3, v13, 6, v3
		v_accvgpr_read_b32 v13, a17
		v_lshl_add_u32 v3, v13, 5, v3
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_1
		buffer_load_dwordx4 v[28:31], v3, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_1:
		s_andn2_b64 exec, s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_1
		v_mov_b32_e32 v28, v20
		v_mov_b32_e32 v29, v21
		v_mov_b32_e32 v30, v22
		v_mov_b32_e32 v31, v23
.L_attn_fwd_persistent.exec_endif_1:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s22, s12, 7
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s40
		s_add_i32 s22, s22, s42
		v_lshl_add_u32 v3, v10, 1, s22
		v_accvgpr_read_b32 v13, a15
		v_lshl_add_u32 v3, v13, 4, v3
		v_accvgpr_read_b32 v13, a16
		v_lshl_add_u32 v3, v13, 6, v3
		v_accvgpr_read_b32 v13, a17
		v_lshl_add_u32 v3, v13, 5, v3
		s_and_saveexec_b64 s[100:101], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_2
		buffer_load_dwordx4 v[32:35], v3, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_2:
		s_andn2_b64 exec, s[100:101], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_2
		v_mov_b32_e32 v32, v20
		v_mov_b32_e32 v33, v21
		v_mov_b32_e32 v34, v22
		v_mov_b32_e32 v35, v23
.L_attn_fwd_persistent.exec_endif_2:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s22, 0xc0, s12
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s40
		s_add_i32 s22, s22, s42
		v_lshl_add_u32 v3, v10, 1, s22
		v_accvgpr_read_b32 v13, a15
		v_lshl_add_u32 v3, v13, 4, v3
		v_accvgpr_read_b32 v13, a16
		v_lshl_add_u32 v3, v13, 6, v3
		v_accvgpr_read_b32 v13, a17
		v_lshl_add_u32 v3, v13, 5, v3
		s_and_saveexec_b64 s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_3
		buffer_load_dwordx4 v[36:39], v3, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_3:
		s_andn2_b64 exec, s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_3
		v_mov_b32_e32 v36, v20
		v_mov_b32_e32 v37, v21
		v_mov_b32_e32 v38, v22
		v_mov_b32_e32 v39, v23
.L_attn_fwd_persistent.exec_endif_3:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s22, s12, 8
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s40
		s_add_i32 s22, s22, s42
		v_lshl_add_u32 v3, v10, 1, s22
		v_accvgpr_read_b32 v13, a15
		v_lshl_add_u32 v3, v13, 4, v3
		v_accvgpr_read_b32 v13, a16
		v_lshl_add_u32 v3, v13, 6, v3
		v_accvgpr_read_b32 v13, a17
		v_lshl_add_u32 v3, v13, 5, v3
		s_and_saveexec_b64 s[100:101], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_4
		buffer_load_dwordx4 v[40:43], v3, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_4:
		s_andn2_b64 exec, s[100:101], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_4
		v_mov_b32_e32 v40, v20
		v_mov_b32_e32 v41, v21
		v_mov_b32_e32 v42, v22
		v_mov_b32_e32 v43, v23
.L_attn_fwd_persistent.exec_endif_4:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s22, 0x140, s12
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s40
		s_add_i32 s22, s22, s42
		v_lshl_add_u32 v3, v10, 1, s22
		v_accvgpr_read_b32 v13, a15
		v_lshl_add_u32 v3, v13, 4, v3
		v_accvgpr_read_b32 v13, a16
		v_lshl_add_u32 v3, v13, 6, v3
		v_accvgpr_read_b32 v13, a17
		v_lshl_add_u32 v3, v13, 5, v3
		s_and_saveexec_b64 s[100:101], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_5
		buffer_load_dwordx4 v[44:47], v3, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_5:
		s_andn2_b64 exec, s[100:101], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_5
		v_mov_b32_e32 v44, v20
		v_mov_b32_e32 v45, v21
		v_mov_b32_e32 v46, v22
		v_mov_b32_e32 v47, v23
.L_attn_fwd_persistent.exec_endif_5:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s22, 0x180, s12
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s40
		s_add_i32 s22, s22, s42
		v_lshl_add_u32 v3, v10, 1, s22
		v_accvgpr_read_b32 v13, a15
		v_lshl_add_u32 v3, v13, 4, v3
		v_accvgpr_read_b32 v13, a16
		v_lshl_add_u32 v3, v13, 6, v3
		v_accvgpr_read_b32 v13, a17
		v_lshl_add_u32 v3, v13, 5, v3
		s_and_saveexec_b64 s[100:101], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_6
		buffer_load_dwordx4 v[48:51], v3, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_6:
		s_andn2_b64 exec, s[100:101], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_6
		v_mov_b32_e32 v48, v20
		v_mov_b32_e32 v49, v21
		v_mov_b32_e32 v50, v22
		v_mov_b32_e32 v51, v23
.L_attn_fwd_persistent.exec_endif_6:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s22, 0x1c0, s12
		s_add_i32 s19, s22, s19
		s_add_i32 s19, s19, s40
		s_add_i32 s19, s19, s42
		v_lshl_add_u32 v3, v10, 1, s19
		v_accvgpr_read_b32 v10, a15
		v_lshl_add_u32 v3, v10, 4, v3
		v_accvgpr_read_b32 v10, a16
		v_lshl_add_u32 v3, v10, 6, v3
		v_accvgpr_read_b32 v10, a17
		v_lshl_add_u32 v3, v10, 5, v3
		v_cmp_lt_i32_e64 vcc, v2, s20
		s_and_saveexec_b64 s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_7
		buffer_load_dwordx4 v[52:55], v3, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_7:
		s_andn2_b64 exec, s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_7
		v_mov_b32_e32 v52, v20
		v_mov_b32_e32 v53, v21
		v_mov_b32_e32 v54, v22
		v_mov_b32_e32 v55, v23
.L_attn_fwd_persistent.exec_endif_7:
		s_mov_b64 exec, s[100:101]
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
		v_accvgpr_read_b32 v3, a12
		v_lshlrev_b32_e32 v3, 12, v3
		v_add_u32_e32 v3, 0x10000, v3
		v_and_b32_e32 v5, 63, v0
		v_lshrrev_b32_e32 v10, 5, v5
		v_accvgpr_write_b32 a20, v10
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshrrev_b32_e32 v10, 4, v5
		v_and_b32_e32 v10, 1, v10
		v_lshlrev_b32_e32 v10, 7, v10
		v_accvgpr_read_b32 v11, a20
		v_add_u32_e32 v11, v11, v10
		v_lshrrev_b32_e32 v13, 3, v5
		v_and_b32_e32 v13, 1, v13
		v_lshlrev_b32_e32 v15, 6, v13
		v_lshrrev_b32_e32 v17, 2, v5
		v_and_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v18, 5, v17
		v_add3_u32 v11, v11, v15, v18
		v_lshrrev_b32_e32 v19, 1, v5
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v20, 4, v19
		v_and_b32_e32 v21, 1, v5
		v_lshlrev_b32_e32 v21, 3, v21
		v_add3_u32 v11, v11, v20, v21
		v_lshlrev_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v13, 2, v13
		v_bitop3_b32 v13, v17, v13, v19 bitop3:0x96
		v_xor_b32_e32 v11, v11, v13
		v_lshl_add_u32 v11, v11, 4, v3
		ds_read_b128 a[24:27], v11 offset:2480
		v_accvgpr_read_b32 v17, a20
		v_add3_u32 v10, v17, v10, v15
		v_add3_u32 v10, v10, v18, v20
		v_add3_u32 v15, v21, v10, 2
		v_xor_b32_e32 v15, v15, v13
		v_lshl_add_u32 v15, v15, 4, v3
		ds_read_b128 a[28:31], v15 offset:2480
		v_add3_u32 v17, v21, v10, 4
		v_xor_b32_e32 v17, v17, v13
		v_lshl_add_u32 v17, v17, 4, v3
		ds_read_b128 a[32:35], v17 offset:2480
		v_add3_u32 v10, v21, v10, 6
		v_xor_b32_e32 v10, v10, v13
		v_lshl_add_u32 v3, v10, 4, v3
		ds_read_b128 a[36:39], v3 offset:2480
		v_accvgpr_read_b32 v10, a11
		s_nop 0
		v_readfirstlane_b32 s19, v10
		s_add_i32 s19, s19, 1
		s_mul_i32 s19, s19, 0x100
		s_mov_b32 s22, 0x7f
		v_mov_b32_e32 v10, 64
		v_mul_lo_u32 v10, v10, v9
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[40:43] offset:2480
		ds_write_b128 v2, v[44:47] offset:6576
		ds_write_b128 v2, v[48:51] offset:10672
		ds_write_b128 v2, v[52:55] offset:14768
		v_mov_b32_e32 v2, 32
		v_mul_lo_u32 v2, v2, v12
		v_mov_b32_e32 v12, 16
		v_mul_lo_u32 v12, v12, v6
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[40:43], v11 offset:2480
		ds_read_b128 a[44:47], v15 offset:2480
		ds_read_b128 a[48:51], v17 offset:2480
		ds_read_b128 a[52:55], v3 offset:2480
		v_accvgpr_read_b32 v3, a5
		s_nop 0
		v_readfirstlane_b32 s23, v3
		s_add_i32 s19, s19, s23
		s_cmp_lt_i32 s21, s19
		s_cselect_b32 s19, s21, s19
		s_add_i32 s23, s19, 0x7f
		s_cmp_lt_i32 s23, 0
		s_cselect_b32 s32, s22, 0
		s_add_i32 s23, s23, s32
		s_ashr_i32 s23, s23, 7
		v_accvgpr_read_b32 v3, a5
		s_nop 0
		v_readfirstlane_b32 s32, v3
		s_add_i32 s32, s1, s32
		s_cmp_lt_i32 s32, 0
		s_cselect_b32 s33, s22, 0
		s_add_i32 s32, s32, s33
		s_ashr_i32 s32, s32, 7
		s_cmp_lt_i32 s32, s23
		s_cselect_b32 s32, s32, s23
		s_cmp_gt_i32 s32, 0
		s_cselect_b32 s32, s32, 0
		v_bitop3_b32 v3, v10, v2, v12 bitop3:0x96
		v_mov_b32_e32 v11, 2
		v_mul_lo_u32 v11, v11, v16
		v_bitop3_b32 v3, v3, v14, v11 bitop3:0x96
		v_accvgpr_write_b32 a21, v3
		v_bitop3_b32 v3, 4, v10, v2 bitop3:0x96
		v_bitop3_b32 v13, 8, v10, v2 bitop3:0x96
		v_bitop3_b32 v10, 12, v10, v2 bitop3:0x96
		v_accvgpr_read_b32 v15, a21
		v_cmp_lt_i32_e64 s[34:35], v15, s21
		v_mov_b32_e32 v15, 16
		v_mul_lo_u32 v15, v15, v9
		v_mov_b32_e32 v9, 64
		v_mul_lo_u32 v9, v9, v6
		v_bitop3_b32 v6, v15, v2, v9 bitop3:0x96
		v_bitop3_b32 v6, v6, v14, v11 bitop3:0x96
		v_accvgpr_write_b32 a22, v6
		v_bitop3_b32 v6, 4, v15, v2 bitop3:0x96
		v_bitop3_b32 v16, 8, v15, v2 bitop3:0x96
		v_bitop3_b32 v2, 12, v15, v2 bitop3:0x96
		v_accvgpr_read_b32 v15, a22
		v_cmp_lt_i32_e64 vcc, v15, s21
		v_readfirstlane_b32 s36, v0
		v_accvgpr_read_b32 v15, a12
		v_mul_lo_u32 v15, s15, v15
		v_accvgpr_read_b32 v17, a18
		v_mul_lo_u32 v17, s15, v17
		v_lshlrev_b32_e32 v17, 5, v17
		v_lshl_add_u32 v15, v15, 1, v17
		v_accvgpr_read_b32 v17, a19
		v_mul_lo_u32 v17, s15, v17
		v_lshl_add_u32 v15, v17, 6, v15
		v_and_b32_e32 v8, 1, v8
		v_accvgpr_write_b32 a23, v8
		v_accvgpr_read_b32 v8, a23
		v_mul_lo_u32 v8, s15, v8
		v_lshlrev_b32_e32 v8, 7, v8
		v_accvgpr_read_b32 v17, a15
		v_lshlrev_b32_e32 v17, 4, v17
		v_add3_u32 v8, v15, v8, v17
		v_accvgpr_read_b32 v15, a16
		v_lshlrev_b32_e32 v15, 6, v15
		v_accvgpr_read_b32 v18, a17
		v_lshlrev_b32_e32 v18, 5, v18
		v_add3_u32 v8, v8, v15, v18
		v_readfirstlane_b32 s33, v1
		s_mul_i32 s33, s33, s13
		s_lshl_b32 s33, s33, 1
		v_accvgpr_read_b32 v19, a10
		s_nop 0
		v_readfirstlane_b32 s37, v19
		s_mul_i32 s37, s37, s14
		s_lshl_b32 s37, s37, 1
		s_add_i32 s40, s33, s37
		v_add_u32_e32 v19, s40, v8
		v_mov_b32_e32 v20, 0x80000000
		v_cndmask_b32_e64 v19, v20, v19, s[34:35]
		s_lshr_b32 s40, s36, 6
		s_mul_i32 s41, 0x410, s40
		s_mov_b32 m0, s41
		v_accvgpr_read_b32 v21, a13
		v_add_u32_e32 v21, s1, v21
		buffer_load_dwordx4 v19, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[42:43], v21, s20
		s_lshl_b32 s44, s15, 3
		s_add_i32 s44, s44, s33
		s_add_i32 s44, s44, s37
		v_add_u32_e32 v19, s44, v8
		v_cndmask_b32_e64 v19, v20, v19, s[34:35]
		s_add_i32 m0, m0, 0x1040
		v_accvgpr_read_b32 v21, a14
		v_add_u32_e32 v21, s1, v21
		buffer_load_dwordx4 v19, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[44:45], v21, s20
		s_nop 1
		v_mov_b32_e32 v22, s44
		v_mov_b32_e32 v23, s45
		s_lshl_b32 s44, s15, 4
		s_add_i32 s44, s44, s33
		s_add_i32 s44, s44, s37
		v_add_u32_e32 v19, s44, v8
		v_cndmask_b32_e64 v19, v20, v19, s[34:35]
		s_add_i32 m0, m0, 0x1040
		v_xor_b32_e32 v3, v3, v12
		buffer_load_dwordx4 v19, s[24:27], 0 offen lds
		v_bitop3_b32 v3, v3, v14, v11 bitop3:0x96
		v_accvgpr_write_b32 a56, v3
		s_mul_i32 s44, 24, s15
		s_add_i32 s44, s44, s33
		s_add_i32 s44, s44, s37
		v_add_u32_e32 v3, s44, v8
		v_cndmask_b32_e64 v3, v20, v3, s[34:35]
		s_add_i32 m0, m0, 0x1040
		v_xor_b32_e32 v13, v13, v12
		buffer_load_dwordx4 v3, s[24:27], 0 offen lds
		v_bitop3_b32 v3, v13, v14, v11 bitop3:0x96
		v_accvgpr_write_b32 a57, v3
		v_accvgpr_read_b32 v3, a12
		v_mul_lo_u32 v3, s17, v3
		v_accvgpr_read_b32 v13, a18
		v_mul_lo_u32 v13, s17, v13
		v_lshlrev_b32_e32 v13, 7, v13
		v_lshl_add_u32 v3, v3, 1, v13
		v_accvgpr_read_b32 v13, a19
		v_mul_lo_u32 v13, s17, v13
		v_lshl_add_u32 v3, v13, 6, v3
		v_accvgpr_read_b32 v13, a23
		v_mul_lo_u32 v13, s17, v13
		v_lshlrev_b32_e32 v13, 5, v13
		v_add3_u32 v3, v3, v13, v17
		v_add3_u32 v3, v3, v15, v18
		v_accvgpr_read_b32 v13, a0
		s_nop 0
		v_readfirstlane_b32 s34, v13
		v_readfirstlane_b32 s35, v1
		s_mul_i32 s34, s35, s34
		s_lshl_b32 s34, s34, 1
		v_accvgpr_read_b32 v13, a1
		s_nop 0
		v_readfirstlane_b32 s35, v13
		v_accvgpr_read_b32 v13, a10
		s_nop 0
		v_readfirstlane_b32 s44, v13
		s_mul_i32 s35, s44, s35
		s_lshl_b32 s35, s35, 1
		s_add_i32 s44, s34, s35
		v_add_u32_e32 v13, s44, v3
		v_cndmask_b32_e32 v13, v20, v13, vcc
		s_mul_i32 s40, 0x440, s40
		s_add_i32 m0, s40, 0x81f0
		v_xor_b32_e32 v10, v10, v12
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		v_bitop3_b32 v10, v10, v14, v11 bitop3:0x96
		v_accvgpr_write_b32 a58, v10
		s_lshl_b32 s44, s17, 3
		s_add_i32 s44, s44, s34
		s_add_i32 s44, s44, s35
		v_add_u32_e32 v10, s44, v3
		v_cndmask_b32_e32 v10, v20, v10, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v6, v6, v9
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		v_bitop3_b32 v6, v6, v14, v11 bitop3:0x96
		v_accvgpr_write_b32 a59, v6
		s_lshl_b32 s44, s17, 4
		s_add_i32 s44, s44, s34
		s_add_i32 s44, s44, s35
		v_add_u32_e32 v6, s44, v3
		v_cndmask_b32_e32 v6, v20, v6, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v10, v16, v9
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_bitop3_b32 v6, v10, v14, v11 bitop3:0x96
		v_accvgpr_write_b32 a60, v6
		s_mul_i32 s44, 24, s17
		s_add_i32 s44, s44, s34
		s_add_i32 s44, s44, s35
		v_add_u32_e32 v6, s44, v3
		v_cndmask_b32_e32 v6, v20, v6, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v2, v2, v9
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_bitop3_b32 v2, v2, v14, v11 bitop3:0x96
		v_accvgpr_write_b32 a61, v2
		s_mul_i32 s44, s32, 0x80
		v_mbcnt_lo_u32_b32 v2, -1, 0
		v_mbcnt_hi_u32_b32 v2, -1, v2
		v_and_b32_e32 v6, 1, v2
		v_lshrrev_b32_e32 v9, 4, v2
		v_and_b32_e32 v9, 1, v9
		v_lshlrev_b32_e32 v9, 4, v9
		v_lshrrev_b32_e32 v10, 3, v2
		v_and_b32_e32 v10, 1, v10
		v_lshlrev_b32_e32 v10, 3, v10
		v_add3_u32 v11, v6, v9, v10
		v_lshrrev_b32_e32 v12, 2, v2
		v_and_b32_e32 v12, 1, v12
		v_lshlrev_b32_e32 v12, 2, v12
		v_lshrrev_b32_e32 v2, 1, v2
		v_and_b32_e32 v2, 1, v2
		v_lshlrev_b32_e32 v2, 1, v2
		v_add3_u32 v11, v11, v12, v2
		v_add_u32_e32 v6, 32, v6
		v_bitop3_b32 v9, v12, v10, v9 bitop3:0x96
		v_bitop3_b32 v2, v6, v2, v9 bitop3:0x96
		v_mov_b32_e32 v12, 0x3e38aa3b
		v_mov_b32_e32 v13, 0x3e38aa3b
		s_mov_b32 s32, 0xff800000
		v_mov_b32_e32 v6, s32
		v_mov_b32_e32 v9, s32
		s_mov_b32 s32, 1.0
		v_mov_b32_e32 v14, s32
		v_mov_b32_e32 v15, s32
		s_mov_b32 s32, 0
		v_accvgpr_read_b32 v10, a20
		v_lshlrev_b32_e32 v10, 4, v10
		v_accvgpr_write_b32 a62, v10
		v_and_b32_e32 v5, 31, v5
		v_lshrrev_b32_e32 v10, 4, v5
		v_lshlrev_b32_e32 v10, 9, v10
		v_lshrrev_b32_e32 v16, 3, v5
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v17, 0x2080
		v_mul_lo_u32 v17, v17, v16
		v_accvgpr_write_b32 a63, v17
		v_lshrrev_b32_e32 v16, 2, v5
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v17, 0x1040
		v_mul_lo_u32 v17, v17, v16
		v_accvgpr_write_b32 a64, v17
		v_lshrrev_b32_e32 v16, 1, v5
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v17, 0x820
		v_mul_lo_u32 v17, v17, v16
		v_accvgpr_write_b32 a65, v17
		v_and_b32_e32 v5, 1, v5
		v_mov_b32_e32 v16, 0x410
		v_mul_lo_u32 v16, v16, v5
		v_accvgpr_write_b32 a66, v16
		v_and_b32_e32 v5, 3, v0
		v_accvgpr_write_b32 a67, v5
		v_accvgpr_read_b32 v5, a67
		v_lshlrev_b32_e32 v5, 3, v5
		v_accvgpr_write_b32 a68, v5
		v_accvgpr_read_b32 v5, a18
		v_mov_b32_e32 v16, 0x2200
		v_mul_lo_u32 v16, v16, v5
		v_accvgpr_write_b32 a69, v16
		v_accvgpr_read_b32 v5, a19
		v_lshlrev_b32_e32 v5, 5, v5
		v_accvgpr_write_b32 a70, v5
		v_and_b32_e32 v4, 3, v4
		v_mov_b32_e32 v5, 0x440
		v_mul_lo_u32 v5, v5, v4
		v_accvgpr_write_b32 a71, v5
		s_lshl_b32 s45, s15, 8
		s_add_i32 s45, s45, s33
		s_add_i32 s45, s45, s37
		s_mul_i32 s46, 0x108, s15
		s_add_i32 s46, s46, s33
		s_add_i32 s46, s46, s37
		s_mul_i32 s47, 0x110, s15
		s_add_i32 s47, s47, s33
		s_add_i32 s47, s47, s37
		s_mul_i32 s48, 0x118, s15
		s_add_i32 s33, s48, s33
		s_add_i32 s33, s33, s37
		s_lshl_b32 s37, s17, 8
		s_add_i32 s37, s37, s34
		s_add_i32 s48, s37, s35
		s_mul_i32 s37, 0x108, s17
		s_add_i32 s37, s37, s34
		s_add_i32 s49, s37, s35
		s_mul_i32 s37, 0x110, s17
		s_add_i32 s37, s37, s34
		s_add_i32 s50, s37, s35
		s_mul_i32 s37, 0x118, s17
		s_add_i32 s34, s37, s34
		s_add_i32 s34, s34, s35
		v_lshlrev_b32_e32 v4, 2, v11
		v_accvgpr_write_b32 a72, v4
		v_lshlrev_b32_e32 v2, 2, v2
		v_accvgpr_write_b32 a73, v2
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
		s_lshr_b32 s35, s32, 7
		s_and_b32 s37, s35, 1
		s_mul_i32 s51, 0x4100, s37
		v_accvgpr_read_b32 v2, a62
		v_add3_u32 v2, s51, v2, v10
		v_accvgpr_read_b32 v4, a63
		v_accvgpr_read_b32 v5, a64
		v_add3_u32 v2, v2, v4, v5
		v_accvgpr_read_b32 v4, a65
		v_accvgpr_read_b32 v5, a66
		v_add3_u32 v2, v2, v4, v5
		ds_read_b128 v[16:19], v2
		ds_read_b128 a[76:79], v2 offset:32
		ds_read_b128 a[80:83], v2 offset:64
		ds_read_b128 a[84:87], v2 offset:96
		ds_read_b128 v[24:27], v2 offset:256
		ds_read_b128 a[88:91], v2 offset:288
		ds_read_b128 a[92:95], v2 offset:320
		ds_read_b128 a[96:99], v2 offset:352
		ds_read_b128 v[28:31], v2 offset:128
		ds_read_b128 a[100:103], v2 offset:160
		ds_read_b128 a[104:107], v2 offset:192
		ds_read_b128 a[108:111], v2 offset:224
		ds_read_b128 v[96:99], v2 offset:384
		ds_read_b128 a[112:115], v2 offset:416
		ds_read_b128 a[116:119], v2 offset:448
		ds_read_b128 a[120:123], v2 offset:480
		s_mul_i32 s37, 0x4400, s37
		v_accvgpr_read_b32 v2, a68
		v_accvgpr_read_b32 v4, a69
		v_add3_u32 v2, s37, v2, v4
		v_accvgpr_read_b32 v4, a70
		v_accvgpr_read_b32 v5, a71
		v_add3_u32 v2, v2, v4, v5
		ds_read_b64_tr_b16 a[124:125], v2 offset:33264
		ds_read_b64_tr_b16 a[126:127], v2 offset:37616
		ds_read_b64_tr_b16 a[128:129], v2 offset:33392
		ds_read_b64_tr_b16 a[130:131], v2 offset:37744
		ds_read_b64_tr_b16 a[132:133], v2 offset:33520
		ds_read_b64_tr_b16 a[134:135], v2 offset:37872
		ds_read_b64_tr_b16 a[136:137], v2 offset:33648
		ds_read_b64_tr_b16 a[138:139], v2 offset:38000
		ds_read_b64_tr_b16 a[140:141], v2 offset:33776
		ds_read_b64_tr_b16 a[142:143], v2 offset:38128
		ds_read_b64_tr_b16 a[144:145], v2 offset:33904
		ds_read_b64_tr_b16 a[146:147], v2 offset:38256
		ds_read_b64_tr_b16 a[148:149], v2 offset:34032
		ds_read_b64_tr_b16 a[150:151], v2 offset:38384
		ds_read_b64_tr_b16 a[152:153], v2 offset:34160
		ds_read_b64_tr_b16 a[154:155], v2 offset:38512
		ds_read_b64_tr_b16 a[156:157], v2 offset:33328
		ds_read_b64_tr_b16 a[158:159], v2 offset:37680
		ds_read_b64_tr_b16 a[160:161], v2 offset:33456
		ds_read_b64_tr_b16 a[162:163], v2 offset:37808
		ds_read_b64_tr_b16 a[164:165], v2 offset:33584
		ds_read_b64_tr_b16 a[166:167], v2 offset:37936
		ds_read_b64_tr_b16 a[168:169], v2 offset:33712
		ds_read_b64_tr_b16 a[170:171], v2 offset:38064
		ds_read_b64_tr_b16 a[172:173], v2 offset:33840
		ds_read_b64_tr_b16 a[174:175], v2 offset:38192
		ds_read_b64_tr_b16 a[176:177], v2 offset:33968
		ds_read_b64_tr_b16 a[178:179], v2 offset:38320
		ds_read_b64_tr_b16 a[180:181], v2 offset:34096
		ds_read_b64_tr_b16 a[182:183], v2 offset:38448
		ds_read_b64_tr_b16 a[184:185], v2 offset:34224
		ds_read_b64_tr_b16 a[186:187], v2 offset:38576
		s_mul_i32 s37, s15, s32
		s_lshl_b32 s37, s37, 1
		s_add_i32 s51, s45, s37
		v_add_u32_e32 v2, s51, v8
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v4, s37, v8
		s_add_i32 s35, s35, 1
		v_add_u32_e32 v5, s46, v4
		s_and_b32 s35, s35, 1
		v_add_u32_e32 v11, s47, v4
		s_mul_i32 s37, 0x4100, s35
		v_add_u32_e32 v4, s33, v4
		s_add_i32 s37, s41, s37
		v_mfma_f32_32x32x16_bf16 v[112:127], v[16:19], a[24:27], 0
		s_mov_b32 m0, s37
		v_mfma_f32_32x32x16_bf16 v[128:143], v[24:27], a[24:27], 0
		s_mul_i32 s37, s17, s32
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[24:27], 0
		s_add_i32 s32, s32, 0x80
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], a[24:27], 0
		v_accvgpr_read_b32 v21, a21
		v_add_u32_e32 v21, s32, v21
		v_mfma_f32_32x32x16_bf16 v[176:191], v[96:99], a[40:43], 0
		v_accvgpr_read_b32 v96, a56
		v_add_u32_e32 v96, s32, v96
		v_mfma_f32_32x32x16_bf16 v[192:207], v[16:19], a[40:43], 0
		v_accvgpr_read_b32 v16, a57
		v_add_u32_e32 v16, s32, v16
		v_mfma_f32_32x32x16_bf16 v[208:223], v[24:27], a[40:43], 0
		v_accvgpr_read_b32 v17, a58
		v_add_u32_e32 v17, s32, v17
		v_mfma_f32_32x32x16_bf16 v[224:239], v[28:31], a[40:43], 0
		v_cmp_lt_i32_e64 s[52:53], v21, s21
		v_mfma_f32_32x32x16_bf16 v[112:127], a[76:79], a[28:31], v[112:127]
		v_accvgpr_read_b32 v18, a22
		v_add_u32_e32 v18, s32, v18
		v_mfma_f32_32x32x16_bf16 v[128:143], a[88:91], a[28:31], v[128:143]
		v_accvgpr_read_b32 v19, a59
		v_add_u32_e32 v19, s32, v19
		v_mfma_f32_32x32x16_bf16 v[144:159], a[100:103], a[28:31], v[144:159]
		v_accvgpr_read_b32 v21, a60
		v_add_u32_e32 v21, s32, v21
		v_mfma_f32_32x32x16_bf16 v[160:175], a[112:115], a[28:31], v[160:175]
		v_cmp_lt_i32_e64 s[54:55], v18, s21
		v_mfma_f32_32x32x16_bf16 v[176:191], a[112:115], a[44:47], v[176:191]
		v_cndmask_b32_e64 v2, v20, v2, s[52:53]
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[192:207], a[76:79], a[44:47], v[192:207]
		v_cmp_lt_i32_e64 s[52:53], v96, s21
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[56:57], v16, s21
		v_mfma_f32_32x32x16_bf16 v[208:223], a[88:91], a[44:47], v[208:223]
		v_cndmask_b32_e64 v2, v20, v5, s[52:53]
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], a[100:103], a[44:47], v[224:239]
		v_cndmask_b32_e64 v2, v20, v11, s[56:57]
		v_cmp_lt_i32_e64 s[52:53], v17, s21
		s_add_i32 m0, m0, 0x1040
		v_accvgpr_read_b32 v5, a61
		v_add_u32_e32 v5, s32, v5
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[112:127], a[80:83], a[32:35], v[112:127]
		v_cndmask_b32_e64 v2, v20, v4, s[52:53]
		v_cmp_lt_i32_e64 s[52:53], v19, s21
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s37, s37, 1
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		v_add_u32_e32 v2, s37, v3
		s_add_i32 s37, s48, s37
		v_mfma_f32_32x32x16_bf16 v[128:143], a[92:95], a[32:35], v[128:143]
		v_add_u32_e32 v4, s37, v3
		v_mfma_f32_32x32x16_bf16 v[144:159], a[104:107], a[32:35], v[144:159]
		v_cndmask_b32_e64 v4, v20, v4, s[54:55]
		v_add_u32_e32 v11, s49, v2
		s_mul_i32 s35, 0x4400, s35
		v_cndmask_b32_e64 v11, v20, v11, s[52:53]
		s_add_i32 s35, s40, s35
		v_cmp_lt_i32_e64 s[52:53], v21, s21
		s_add_i32 m0, s35, 0x81f0
		v_add_u32_e32 v16, s50, v2
		buffer_load_dwordx4 v4, s[28:31], 0 offen lds
		v_cndmask_b32_e64 v4, v20, v16, s[52:53]
		v_cmp_lt_i32_e64 vcc, v5, s21
		s_add_i32 m0, m0, 0x1100
		v_add_u32_e32 v2, s34, v2
		v_cndmask_b32_e32 v2, v20, v2, vcc
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[160:175], a[116:119], a[32:35], v[160:175]
		s_add_i32 m0, m0, 0x1100
		v_mfma_f32_32x32x16_bf16 v[176:191], a[116:119], a[48:51], v[176:191]
		buffer_load_dwordx4 v4, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[192:207], a[80:83], a[48:51], v[192:207]
		s_add_i32 m0, m0, 0x1100
		s_cmp_lt_i32 s32, s44
		v_mfma_f32_32x32x16_bf16 v[208:223], a[92:95], a[48:51], v[208:223]
		buffer_load_dwordx4 v2, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], a[104:107], a[48:51], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[84:87], a[36:39], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[96:99], a[36:39], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[108:111], a[36:39], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[120:123], a[36:39], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[120:123], a[52:55], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[84:87], a[52:55], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[96:99], a[52:55], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[108:111], a[52:55], v[224:239]
		s_nop 4
		v_max3_f32 v2, v112, v113, v114
		v_max3_f32 v4, v116, v117, v118
		v_max3_f32 v5, v120, v121, v122
		v_max3_f32 v11, v124, v125, v126
		v_max3_f32 v16, v128, v129, v130
		v_max3_f32 v17, v132, v133, v134
		v_max3_f32 v18, v136, v137, v138
		v_max3_f32 v19, v140, v141, v142
		v_max3_f32 v21, v144, v145, v146
		v_max3_f32 v24, v148, v149, v150
		v_max3_f32 v25, v152, v153, v154
		v_max3_f32 v26, v156, v157, v158
		v_max3_f32 v27, v160, v161, v162
		v_max3_f32 v28, v164, v165, v166
		v_max3_f32 v29, v168, v169, v170
		v_max3_f32 v30, v172, v173, v174
		v_max3_f32 v2, v2, v115, v4
		v_max3_f32 v4, v5, v123, v11
		v_max3_f32 v5, v16, v131, v17
		v_max3_f32 v11, v18, v139, v19
		v_max3_f32 v16, v21, v147, v24
		v_max3_f32 v17, v25, v155, v26
		v_max3_f32 v18, v27, v163, v28
		v_max3_f32 v19, v29, v171, v30
		v_max3_f32 v2, v2, v119, v4
		v_max3_f32 v4, v5, v135, v11
		v_max3_f32 v5, v16, v151, v17
		v_max3_f32 v11, v18, v167, v19
		v_max3_f32 v2, v2, v127, v4
		v_max3_f32 v4, v5, v159, v11
		v_max3_f32 v2, v2, v143, v4
		v_max_f32_e32 v4, v2, v175
		v_mov_b32_e32 v5, v4
		v_max3_f32 v2, v192, v193, v194
		v_max3_f32 v11, v196, v197, v198
		v_max3_f32 v16, v200, v201, v202
		v_max3_f32 v17, v204, v205, v206
		v_max3_f32 v18, v208, v209, v210
		v_max3_f32 v19, v212, v213, v214
		v_max3_f32 v21, v216, v217, v218
		v_max3_f32 v24, v220, v221, v222
		v_max3_f32 v25, v224, v225, v226
		v_max3_f32 v26, v228, v229, v230
		v_max3_f32 v27, v232, v233, v234
		v_max3_f32 v28, v236, v237, v238
		v_max3_f32 v29, v176, v177, v178
		v_max3_f32 v30, v180, v181, v182
		v_max3_f32 v31, v184, v185, v186
		v_max3_f32 v96, v188, v189, v190
		v_permlane32_swap_b32_e32 v4, v5
		v_max3_f32 v2, v2, v195, v11
		v_max3_f32 v11, v16, v203, v17
		v_max3_f32 v16, v18, v211, v19
		v_max3_f32 v17, v21, v219, v24
		v_max3_f32 v18, v25, v227, v26
		v_max3_f32 v19, v27, v235, v28
		v_max3_f32 v21, v29, v179, v30
		v_max3_f32 v24, v31, v187, v96
		v_max3_f32 v2, v2, v199, v11
		v_max3_f32 v11, v16, v215, v17
		v_max3_f32 v16, v18, v231, v19
		v_max3_f32 v17, v21, v183, v24
		v_max3_f32 v2, v2, v207, v11
		v_max3_f32 v11, v16, v239, v17
		v_max3_f32 v2, v2, v223, v11
		v_max_f32_e32 v16, v2, v191
		v_mov_b32_e32 v17, v16
		v_max_f32_e32 v18, v4, v5
		v_mov_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v16, v17
		v_max_f32_e32 v19, v16, v17
		v_pk_mul_f32 v[16:17], v[18:19], v[12:13]
		v_max_f32_e32 v18, v6, v16
		v_max_f32_e32 v19, v9, v17
		v_pk_fma_f32 v[16:17], v[112:113], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[114:115], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[116:117], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[118:119], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[120:121], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[122:123], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[124:125], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[126:127], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[128:129], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[130:131], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[132:133], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[134:135], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[136:137], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[138:139], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[140:141], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[142:143], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[144:145], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[146:147], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[148:149], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[150:151], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[152:153], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[154:155], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[156:157], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[158:159], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[160:161], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[162:163], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[164:165], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[166:167], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[168:169], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[170:171], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[172:173], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[174:175], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[192:193], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[194:195], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[196:197], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[198:199], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[200:201], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[202:203], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[204:205], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[206:207], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[208:209], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[210:211], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[212:213], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[214:215], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[216:217], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[218:219], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[220:221], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[222:223], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[224:225], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[226:227], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[228:229], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[230:231], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[232:233], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[234:235], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[236:237], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[238:239], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[176:177], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[178:179], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[180:181], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[182:183], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[184:185], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[186:187], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[188:189], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[190:191], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v190, v16
		v_exp_f32_e32 v216, v17
		v_exp_f32_e32 v16, v24
		v_exp_f32_e32 v218, v25
		v_exp_f32_e32 v24, v26
		v_exp_f32_e32 v220, v27
		v_exp_f32_e32 v26, v28
		v_exp_f32_e32 v222, v29
		v_exp_f32_e32 v28, v30
		v_exp_f32_e32 v224, v31
		v_exp_f32_e32 v30, v96
		v_exp_f32_e32 v226, v97
		v_exp_f32_e32 v96, v98
		v_exp_f32_e32 v228, v99
		v_exp_f32_e32 v98, v100
		v_exp_f32_e32 v230, v101
		v_exp_f32_e32 v100, v102
		v_exp_f32_e32 v232, v103
		v_exp_f32_e32 v102, v104
		v_exp_f32_e32 v234, v105
		v_exp_f32_e32 v104, v106
		v_exp_f32_e32 v236, v107
		v_exp_f32_e32 v106, v108
		v_exp_f32_e32 v238, v109
		v_exp_f32_e32 v108, v110
		v_exp_f32_e32 v240, v111
		v_exp_f32_e32 v110, v112
		v_exp_f32_e32 v242, v113
		v_exp_f32_e32 v112, v114
		v_exp_f32_e32 v244, v115
		v_exp_f32_e32 v114, v116
		v_exp_f32_e32 v246, v117
		v_exp_f32_e32 v191, v118
		v_exp_f32_e32 v217, v119
		v_exp_f32_e32 v17, v120
		v_exp_f32_e32 v219, v121
		v_exp_f32_e32 v25, v122
		v_exp_f32_e32 v221, v123
		v_exp_f32_e32 v27, v124
		v_exp_f32_e32 v223, v125
		v_exp_f32_e32 v29, v126
		v_exp_f32_e32 v225, v127
		v_exp_f32_e32 v31, v128
		v_exp_f32_e32 v227, v129
		v_exp_f32_e32 v97, v130
		v_exp_f32_e32 v229, v131
		v_exp_f32_e32 v99, v132
		v_exp_f32_e32 v231, v133
		v_exp_f32_e32 v101, v134
		v_exp_f32_e32 v233, v135
		v_exp_f32_e32 v103, v136
		v_exp_f32_e32 v235, v137
		v_exp_f32_e32 v105, v138
		v_exp_f32_e32 v237, v139
		v_exp_f32_e32 v107, v140
		v_exp_f32_e32 v239, v141
		v_exp_f32_e32 v109, v142
		v_exp_f32_e32 v241, v143
		v_exp_f32_e32 v111, v144
		v_exp_f32_e32 v243, v145
		v_exp_f32_e32 v113, v146
		v_exp_f32_e32 v245, v147
		v_exp_f32_e32 v115, v148
		v_exp_f32_e32 v247, v149
		v_exp_f32_e32 v116, v150
		v_exp_f32_e32 v118, v151
		v_exp_f32_e32 v120, v152
		v_exp_f32_e32 v122, v153
		v_exp_f32_e32 v124, v154
		v_exp_f32_e32 v126, v155
		v_exp_f32_e32 v128, v156
		v_exp_f32_e32 v130, v157
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
		v_exp_f32_e32 v168, v192
		v_exp_f32_e32 v170, v193
		v_exp_f32_e32 v172, v194
		v_exp_f32_e32 v174, v195
		v_exp_f32_e32 v192, v196
		v_exp_f32_e32 v194, v197
		v_exp_f32_e32 v117, v198
		v_exp_f32_e32 v119, v199
		v_exp_f32_e32 v121, v200
		v_exp_f32_e32 v123, v201
		v_exp_f32_e32 v125, v202
		v_exp_f32_e32 v127, v203
		v_exp_f32_e32 v129, v204
		v_exp_f32_e32 v131, v205
		v_exp_f32_e32 v133, v206
		v_exp_f32_e32 v135, v207
		v_exp_f32_e32 v137, v208
		v_exp_f32_e32 v139, v209
		v_exp_f32_e32 v141, v210
		v_exp_f32_e32 v143, v211
		v_exp_f32_e32 v145, v212
		v_exp_f32_e32 v147, v213
		v_exp_f32_e32 v149, v214
		v_exp_f32_e32 v151, v215
		v_exp_f32_e32 v153, v176
		v_exp_f32_e32 v155, v177
		v_exp_f32_e32 v157, v178
		v_exp_f32_e32 v159, v179
		v_exp_f32_e32 v161, v180
		v_exp_f32_e32 v163, v181
		v_exp_f32_e32 v165, v182
		v_exp_f32_e32 v167, v183
		v_exp_f32_e32 v169, v184
		v_exp_f32_e32 v171, v185
		v_exp_f32_e32 v173, v186
		v_exp_f32_e32 v175, v187
		v_exp_f32_e32 v193, v188
		v_exp_f32_e32 v195, v189
		v_pk_add_f32 v[176:177], v[190:191], v[216:217]
		v_pk_add_f32 v[178:179], v[16:17], v[218:219]
		v_pk_add_f32 v[180:181], v[24:25], v[220:221]
		v_pk_add_f32 v[182:183], v[26:27], v[222:223]
		v_pk_add_f32 v[184:185], v[28:29], v[224:225]
		v_pk_add_f32 v[186:187], v[30:31], v[226:227]
		v_pk_add_f32 v[188:189], v[96:97], v[228:229]
		v_pk_add_f32 v[196:197], v[98:99], v[230:231]
		v_pk_add_f32 v[198:199], v[100:101], v[232:233]
		v_pk_add_f32 v[200:201], v[102:103], v[234:235]
		v_pk_add_f32 v[202:203], v[104:105], v[236:237]
		v_pk_add_f32 v[204:205], v[106:107], v[238:239]
		v_pk_add_f32 v[206:207], v[108:109], v[240:241]
		v_pk_add_f32 v[208:209], v[110:111], v[242:243]
		v_pk_add_f32 v[210:211], v[112:113], v[244:245]
		v_pk_add_f32 v[212:213], v[114:115], v[246:247]
		v_pk_add_f32 v[176:177], v[176:177], v[178:179]
		v_pk_add_f32 v[178:179], v[180:181], v[182:183]
		v_pk_add_f32 v[180:181], v[184:185], v[186:187]
		v_pk_add_f32 v[182:183], v[188:189], v[196:197]
		v_pk_add_f32 v[184:185], v[198:199], v[200:201]
		v_pk_add_f32 v[186:187], v[202:203], v[204:205]
		v_pk_add_f32 v[188:189], v[206:207], v[208:209]
		v_pk_add_f32 v[196:197], v[210:211], v[212:213]
		v_pk_add_f32 v[176:177], v[176:177], v[178:179]
		v_pk_add_f32 v[178:179], v[180:181], v[182:183]
		v_pk_add_f32 v[180:181], v[184:185], v[186:187]
		v_pk_add_f32 v[182:183], v[188:189], v[196:197]
		v_pk_add_f32 v[176:177], v[176:177], v[178:179]
		v_pk_add_f32 v[178:179], v[180:181], v[182:183]
		v_pk_add_f32 v[180:181], v[176:177], v[178:179]
		v_add_f32_e32 v2, v180, v181
		v_accvgpr_read_b32 v5, a72
		ds_bpermute_b32 v176, v5, v2
		v_accvgpr_read_b32 v5, a73
		ds_bpermute_b32 v178, v5, v2
		v_pk_add_f32 v[180:181], v[116:117], v[118:119]
		v_pk_add_f32 v[182:183], v[120:121], v[122:123]
		v_pk_add_f32 v[184:185], v[124:125], v[126:127]
		v_pk_add_f32 v[186:187], v[128:129], v[130:131]
		v_pk_add_f32 v[188:189], v[132:133], v[134:135]
		v_pk_add_f32 v[196:197], v[136:137], v[138:139]
		v_pk_add_f32 v[198:199], v[140:141], v[142:143]
		v_pk_add_f32 v[200:201], v[144:145], v[146:147]
		v_pk_add_f32 v[202:203], v[148:149], v[150:151]
		v_pk_add_f32 v[204:205], v[152:153], v[154:155]
		v_pk_add_f32 v[206:207], v[156:157], v[158:159]
		v_pk_add_f32 v[208:209], v[160:161], v[162:163]
		v_pk_add_f32 v[210:211], v[164:165], v[166:167]
		v_pk_add_f32 v[212:213], v[168:169], v[170:171]
		v_pk_add_f32 v[214:215], v[172:173], v[174:175]
		v_pk_add_f32 v[248:249], v[192:193], v[194:195]
		v_pk_add_f32 v[180:181], v[180:181], v[182:183]
		v_pk_add_f32 v[182:183], v[184:185], v[186:187]
		v_pk_add_f32 v[184:185], v[188:189], v[196:197]
		v_pk_add_f32 v[186:187], v[198:199], v[200:201]
		v_pk_add_f32 v[188:189], v[202:203], v[204:205]
		v_pk_add_f32 v[196:197], v[206:207], v[208:209]
		v_pk_add_f32 v[198:199], v[210:211], v[212:213]
		v_pk_add_f32 v[200:201], v[214:215], v[248:249]
		v_pk_add_f32 v[180:181], v[180:181], v[182:183]
		v_pk_add_f32 v[182:183], v[184:185], v[186:187]
		v_pk_add_f32 v[184:185], v[188:189], v[196:197]
		v_pk_add_f32 v[186:187], v[198:199], v[200:201]
		v_pk_add_f32 v[180:181], v[180:181], v[182:183]
		v_pk_add_f32 v[182:183], v[184:185], v[186:187]
		v_pk_add_f32 v[184:185], v[180:181], v[182:183]
		v_mov_b32_e32 v179, v185
		v_mov_b32_e32 v177, v184
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[180:181], v[176:177], v[178:179]
		v_mov_b32_e32 v176, v181
		v_mov_b32_e32 v177, v181
		v_cvt_pk_bf16_f32 v184, v190, v216
		v_cvt_pk_bf16_f32 v185, v16, v218
		v_permlane32_swap_b32_e32 v176, v177
		v_add_f32_e32 v179, v176, v177
		v_mov_b32_e32 v5, v9
		v_pk_add_f32 v[176:177], v[4:5], v[18:19] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v4, v176
		v_exp_f32_e32 v5, v177
		v_cvt_pk_bf16_f32 v186, v24, v220
		v_pk_mul_f32 v[34:35], v[34:35], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[36:37], v[36:37], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[38:39], v[38:39], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[40:41], v[40:41], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[42:43], v[42:43], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[44:45], v[44:45], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[46:47], v[46:47], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[48:49], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[50:51], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[52:53], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[54:55], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[56:57], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[58:59], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[60:61], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[62:63], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[32:33], v[32:33], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[64:65], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[66:67], v[66:67], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[68:69], v[68:69], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[70:71], v[70:71], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[72:73], v[72:73], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[74:75], v[74:75], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[76:77], v[76:77], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[78:79], v[78:79], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[80:81], v[80:81], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[82:83], v[82:83], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[84:85], v[84:85], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[86:87], v[86:87], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[88:89], v[88:89], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[90:91], v[90:91], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[92:93], v[92:93], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[94:95], v[94:95], v[4:5] op_sel:[0,1]
		v_mov_b32_e32 v178, v180
		v_mov_b64_e32 v[176:177], v[14:15]
		v_pk_fma_f32 v[14:15], v[176:177], v[4:5], v[178:179]
		v_cvt_pk_bf16_f32 v187, v26, v222
		v_cvt_pk_bf16_f32 v176, v28, v224
		v_cvt_pk_bf16_f32 v177, v30, v226
		v_cvt_pk_bf16_f32 v178, v96, v228
		v_cvt_pk_bf16_f32 v179, v98, v230
		v_cvt_pk_bf16_f32 v180, v100, v232
		v_cvt_pk_bf16_f32 v181, v102, v234
		v_cvt_pk_bf16_f32 v182, v104, v236
		v_cvt_pk_bf16_f32 v183, v106, v238
		v_cvt_pk_bf16_f32 v196, v108, v240
		v_cvt_pk_bf16_f32 v197, v110, v242
		v_cvt_pk_bf16_f32 v198, v112, v244
		v_cvt_pk_bf16_f32 v199, v114, v246
		v_cvt_pk_bf16_f32 v200, v191, v217
		v_cvt_pk_bf16_f32 v201, v17, v219
		v_cvt_pk_bf16_f32 v202, v25, v221
		v_cvt_pk_bf16_f32 v203, v27, v223
		v_cvt_pk_bf16_f32 v24, v29, v225
		v_cvt_pk_bf16_f32 v25, v31, v227
		v_cvt_pk_bf16_f32 v26, v97, v229
		v_cvt_pk_bf16_f32 v27, v99, v231
		v_cvt_pk_bf16_f32 v28, v101, v233
		v_cvt_pk_bf16_f32 v29, v103, v235
		v_cvt_pk_bf16_f32 v30, v105, v237
		v_cvt_pk_bf16_f32 v31, v107, v239
		v_cvt_pk_bf16_f32 v96, v109, v241
		v_cvt_pk_bf16_f32 v97, v111, v243
		v_cvt_pk_bf16_f32 v98, v113, v245
		v_cvt_pk_bf16_f32 v99, v115, v247
		v_cvt_pk_bf16_f32 v100, v116, v118
		v_cvt_pk_bf16_f32 v101, v120, v122
		v_cvt_pk_bf16_f32 v102, v124, v126
		v_cvt_pk_bf16_f32 v103, v128, v130
		v_cvt_pk_bf16_f32 v104, v132, v134
		v_cvt_pk_bf16_f32 v105, v136, v138
		v_cvt_pk_bf16_f32 v106, v140, v142
		v_cvt_pk_bf16_f32 v107, v144, v146
		v_cvt_pk_bf16_f32 v108, v148, v150
		v_cvt_pk_bf16_f32 v109, v152, v154
		v_cvt_pk_bf16_f32 v110, v156, v158
		v_cvt_pk_bf16_f32 v111, v160, v162
		v_cvt_pk_bf16_f32 v112, v164, v166
		v_cvt_pk_bf16_f32 v113, v168, v170
		v_cvt_pk_bf16_f32 v114, v172, v174
		v_cvt_pk_bf16_f32 v115, v192, v194
		v_cvt_pk_bf16_f32 v188, v117, v119
		v_cvt_pk_bf16_f32 v189, v121, v123
		v_cvt_pk_bf16_f32 v190, v125, v127
		v_cvt_pk_bf16_f32 v191, v129, v131
		v_cvt_pk_bf16_f32 v116, v133, v135
		v_cvt_pk_bf16_f32 v117, v137, v139
		v_cvt_pk_bf16_f32 v118, v141, v143
		v_cvt_pk_bf16_f32 v119, v145, v147
		v_cvt_pk_bf16_f32 v120, v149, v151
		v_cvt_pk_bf16_f32 v121, v153, v155
		v_cvt_pk_bf16_f32 v122, v157, v159
		v_cvt_pk_bf16_f32 v123, v161, v163
		v_cvt_pk_bf16_f32 v124, v165, v167
		v_cvt_pk_bf16_f32 v125, v169, v171
		v_cvt_pk_bf16_f32 v126, v173, v175
		v_cvt_pk_bf16_f32 v127, v193, v195
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_permlane32_swap_b32_e32 v176, v178
		v_permlane32_swap_b32_e32 v177, v179
		v_mfma_f32_32x32x16_bf16 v[32:47], a[124:127], v[184:187], v[32:47]
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		v_mfma_f32_32x32x16_bf16 v[48:63], a[156:159], v[184:187], v[48:63]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[32:47], a[128:131], v[176:179], v[32:47]
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_mfma_f32_32x32x16_bf16 v[48:63], a[160:163], v[176:179], v[48:63]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[32:47], a[132:135], v[180:183], v[32:47]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[48:63], a[164:167], v[180:183], v[48:63]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[32:47], a[136:139], v[196:199], v[32:47]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[48:63], a[168:171], v[196:199], v[48:63]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], v[100:103], v[80:95]
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_mfma_f32_32x32x16_bf16 v[64:79], a[124:127], v[100:103], v[64:79]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[80:95], a[160:163], v[104:107], v[80:95]
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[64:79], a[128:131], v[104:107], v[64:79]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[80:95], a[164:167], v[108:111], v[80:95]
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_mfma_f32_32x32x16_bf16 v[64:79], a[132:135], v[108:111], v[64:79]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[80:95], a[168:171], v[112:115], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[136:139], v[112:115], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[140:143], v[200:203], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[172:175], v[200:203], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[172:175], v[188:191], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[140:143], v[188:191], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[144:147], v[24:27], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[176:179], v[24:27], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[176:179], v[116:119], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[144:147], v[116:119], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[148:151], v[28:31], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[180:183], v[28:31], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[180:183], v[120:123], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[148:151], v[120:123], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[152:155], v[96:99], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[184:187], v[96:99], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[184:187], v[124:127], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[152:155], v[124:127], v[64:79]
		v_mov_b32_e32 v6, v18
		v_mov_b32_e32 v9, v19
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_1
.L_attn_fwd_persistent.loop_exit_1:
		s_mul_i32 s23, s23, 0x80
		v_accvgpr_read_b32 v2, a13
		v_accvgpr_read_b32 v4, a5
		s_nop 0
		v_readfirstlane_b32 s32, v4
		s_nop 1
		v_add_u32_e32 v2, s32, v2
		v_add_u32_e32 v2, s1, v2
		v_accvgpr_read_b32 v4, a14
		v_accvgpr_read_b32 v5, a5
		s_nop 0
		v_readfirstlane_b32 s32, v5
		s_nop 1
		v_add_u32_e32 v4, s32, v4
		v_add_u32_e32 v4, s1, v4
		v_xor_b32_e32 v5, 1, v7
		v_accvgpr_write_b32 a13, v5
		v_xor_b32_e32 v5, 2, v7
		v_accvgpr_write_b32 a14, v5
		v_xor_b32_e32 v5, 3, v7
		v_accvgpr_write_b32 a62, v5
		v_xor_b32_e32 v5, 8, v7
		v_accvgpr_write_b32 a68, v5
		v_xor_b32_e32 v5, 9, v7
		v_accvgpr_write_b32 a74, v5
		v_xor_b32_e32 v5, 10, v7
		v_accvgpr_write_b32 a75, v5
		v_xor_b32_e32 v5, 11, v7
		v_accvgpr_write_b32 a76, v5
		v_xor_b32_e32 v5, 16, v7
		v_accvgpr_write_b32 a77, v5
		v_xor_b32_e32 v5, 17, v7
		v_accvgpr_write_b32 a78, v5
		v_xor_b32_e32 v5, 18, v7
		v_accvgpr_write_b32 a79, v5
		v_xor_b32_e32 v5, 19, v7
		v_accvgpr_write_b32 a80, v5
		v_xor_b32_e32 v5, 24, v7
		v_accvgpr_write_b32 a81, v5
		v_xor_b32_e32 v5, 25, v7
		v_accvgpr_write_b32 a82, v5
		v_xor_b32_e32 v5, 26, v7
		v_accvgpr_write_b32 a83, v5
		v_xor_b32_e32 v5, 27, v7
		v_accvgpr_write_b32 a84, v5
		v_xor_b32_e32 v5, 32, v7
		v_accvgpr_write_b32 a85, v5
		v_xor_b32_e32 v5, 33, v7
		v_accvgpr_write_b32 a86, v5
		v_xor_b32_e32 v5, 34, v7
		v_accvgpr_write_b32 a87, v5
		v_xor_b32_e32 v5, 35, v7
		v_accvgpr_write_b32 a88, v5
		v_xor_b32_e32 v5, 40, v7
		v_accvgpr_write_b32 a89, v5
		v_xor_b32_e32 v5, 41, v7
		v_accvgpr_write_b32 a90, v5
		v_xor_b32_e32 v5, 42, v7
		v_accvgpr_write_b32 a91, v5
		v_xor_b32_e32 v5, 43, v7
		v_accvgpr_write_b32 a92, v5
		v_xor_b32_e32 v5, 48, v7
		v_accvgpr_write_b32 a93, v5
		v_xor_b32_e32 v5, 49, v7
		v_accvgpr_write_b32 a94, v5
		v_xor_b32_e32 v5, 50, v7
		v_accvgpr_write_b32 a95, v5
		v_xor_b32_e32 v5, 51, v7
		v_accvgpr_write_b32 a96, v5
		v_xor_b32_e32 v5, 56, v7
		v_accvgpr_write_b32 a97, v5
		v_xor_b32_e32 v5, 57, v7
		v_accvgpr_write_b32 a98, v5
		v_xor_b32_e32 v5, 58, v7
		v_accvgpr_write_b32 a99, v5
		v_xor_b32_e32 v5, 59, v7
		v_accvgpr_write_b32 a100, v5
		v_xor_b32_e32 v5, 64, v7
		v_accvgpr_write_b32 a101, v5
		v_xor_b32_e32 v5, 0x41, v7
		v_accvgpr_write_b32 a102, v5
		v_xor_b32_e32 v5, 0x42, v7
		v_accvgpr_write_b32 a103, v5
		v_xor_b32_e32 v5, 0x43, v7
		v_accvgpr_write_b32 a104, v5
		v_xor_b32_e32 v5, 0x48, v7
		v_accvgpr_write_b32 a105, v5
		v_xor_b32_e32 v5, 0x49, v7
		v_accvgpr_write_b32 a106, v5
		v_xor_b32_e32 v5, 0x4a, v7
		v_accvgpr_write_b32 a107, v5
		v_xor_b32_e32 v5, 0x4b, v7
		v_accvgpr_write_b32 a108, v5
		v_xor_b32_e32 v5, 0x50, v7
		v_accvgpr_write_b32 a109, v5
		v_xor_b32_e32 v5, 0x51, v7
		v_accvgpr_write_b32 a110, v5
		v_xor_b32_e32 v5, 0x52, v7
		v_accvgpr_write_b32 a111, v5
		v_xor_b32_e32 v5, 0x53, v7
		v_accvgpr_write_b32 a112, v5
		v_xor_b32_e32 v5, 0x58, v7
		v_accvgpr_write_b32 a113, v5
		v_xor_b32_e32 v5, 0x59, v7
		v_accvgpr_write_b32 a114, v5
		v_xor_b32_e32 v5, 0x5a, v7
		v_accvgpr_write_b32 a115, v5
		v_xor_b32_e32 v5, 0x5b, v7
		v_accvgpr_write_b32 a116, v5
		v_xor_b32_e32 v5, 0x60, v7
		v_accvgpr_write_b32 a117, v5
		v_xor_b32_e32 v5, 0x61, v7
		v_accvgpr_write_b32 a118, v5
		v_xor_b32_e32 v5, 0x62, v7
		v_accvgpr_write_b32 a119, v5
		v_xor_b32_e32 v5, 0x63, v7
		v_accvgpr_write_b32 a120, v5
		v_xor_b32_e32 v5, 0x68, v7
		v_accvgpr_write_b32 a121, v5
		v_xor_b32_e32 v5, 0x69, v7
		v_accvgpr_write_b32 a122, v5
		v_xor_b32_e32 v5, 0x6a, v7
		v_accvgpr_write_b32 a123, v5
		v_xor_b32_e32 v5, 0x6b, v7
		v_accvgpr_write_b32 a124, v5
		v_xor_b32_e32 v5, 0x70, v7
		v_accvgpr_write_b32 a125, v5
		v_xor_b32_e32 v5, 0x71, v7
		v_accvgpr_write_b32 a126, v5
		v_xor_b32_e32 v5, 0x72, v7
		v_accvgpr_write_b32 a127, v5
		v_xor_b32_e32 v5, 0x73, v7
		v_accvgpr_write_b32 a128, v5
		v_xor_b32_e32 v5, 0x78, v7
		v_accvgpr_write_b32 a129, v5
		v_xor_b32_e32 v5, 0x79, v7
		v_accvgpr_write_b32 a130, v5
		v_xor_b32_e32 v5, 0x7a, v7
		v_accvgpr_write_b32 a131, v5
		v_xor_b32_e32 v5, 0x7b, v7
		v_accvgpr_write_b32 a132, v5
		v_accvgpr_read_b32 v5, a20
		v_lshl_add_u32 v5, v5, 4, v10
		v_accvgpr_read_b32 v10, a63
		v_accvgpr_read_b32 v11, a64
		v_add3_u32 v5, v5, v10, v11
		v_accvgpr_read_b32 v10, a65
		v_accvgpr_read_b32 v11, a66
		v_add3_u32 v5, v5, v10, v11
		v_accvgpr_write_b32 a20, v5
		v_accvgpr_read_b32 v5, a67
		v_accvgpr_read_b32 v10, a69
		v_lshl_add_u32 v5, v5, 3, v10
		v_accvgpr_read_b32 v10, a70
		v_accvgpr_read_b32 v11, a71
		v_add3_u32 v5, v5, v10, v11
		v_accvgpr_write_b32 a63, v5
		v_mov_b32_e32 v5, 0xff800000
		s_cmp_lt_i32 s44, s23
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_2
.L_attn_fwd_persistent.loop_head_2:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s1, s44, 0x80
		s_cmp_lt_i32 s44, 0
		s_cselect_b32 s32, s22, 0
		s_add_i32 s32, s44, s32
		s_ashr_i32 s32, s32, 7
		s_cmp_lt_i32 s32, 0
		s_cselect_b32 s35, s16, 0
		s_add_i32 s35, s32, s35
		s_ashr_i32 s35, s35, 1
		s_lshl_b32 s35, s35, 1
		s_xor_b32 s35, s35, -1
		s_add_i32 s35, s35, 1
		s_add_i32 s35, s32, s35
		s_add_i32 s32, s32, 1
		s_cmp_lt_i32 s32, 0
		s_cselect_b32 s37, s16, 0
		s_add_i32 s37, s32, s37
		s_ashr_i32 s37, s37, 1
		s_lshl_b32 s37, s37, 1
		s_xor_b32 s37, s37, -1
		s_add_i32 s37, s37, 1
		s_add_i32 s40, s32, s37
		s_mul_i32 s32, 0x4100, s35
		v_accvgpr_read_b32 v10, a20
		v_add_u32_e32 v10, s32, v10
		ds_read_b128 a[64:67], v10
		ds_read_b128 a[136:139], v10 offset:32
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
		ds_read_b128 v[16:19], v10 offset:384
		ds_read_b128 a[180:183], v10 offset:416
		ds_read_b128 a[184:187], v10 offset:448
		ds_read_b128 a[188:191], v10 offset:480
		s_mul_i32 s32, 0x4400, s35
		v_accvgpr_read_b32 v10, a63
		v_add_u32_e32 v10, s32, v10
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
		s_cmp_lt_i32 s1, s19
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_2
		v_accvgpr_read_b32 v10, a21
		v_add_u32_e32 v10, s1, v10
		v_cmp_lt_i32_e64 s[52:53], v10, s21
		v_accvgpr_read_b32 v10, a22
		v_add_u32_e32 v10, s1, v10
		v_cmp_lt_i32_e64 s[54:55], v10, s21
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s32, s15, s44
		s_lshl_b32 s32, s32, 1
		s_add_i32 s35, s45, s32
		v_add_u32_e32 v10, s35, v8
		v_cndmask_b32_e64 v10, v20, v10, s[52:53]
		s_mov_b32 s52, 1
		s_mov_b32 s53, 0
		s_mov_b32 s37, 0
		s_mul_i32 s56, s52, s36
		s_mul_hi_u32 s57, s52, s36
		s_mul_i32 s35, s52, s37
		s_add_i32 s57, s57, s35
		s_mul_i32 s35, s53, s36
		s_add_i32 s57, s57, s35
		s_lshr_b64 s[52:53], s[56:57], 6
		s_mov_b32 s56, 0x410
		s_mov_b32 s57, 0
		s_mul_i32 s58, s56, s52
		s_mul_hi_u32 s59, s56, s52
		s_mul_i32 s35, s56, s53
		s_add_i32 s59, s59, s35
		s_mul_i32 s35, s57, s52
		s_add_i32 s59, s59, s35
		s_cmp_lt_i32 s40, 0
		s_cselect_b32 s41, -1, 0
		s_mov_b32 s56, 0x4100
		s_mov_b32 s57, 0
		s_mul_i32 s60, s56, s40
		s_mul_hi_u32 s61, s56, s40
		s_mul_i32 s35, s56, s41
		s_add_i32 s61, s61, s35
		s_mul_i32 s35, s57, s40
		s_add_i32 s61, s61, s35
		s_add_u32 s56, s58, s60
		s_addc_u32 s57, s59, s61
		s_add_u32 s62, s56, 0
		s_addc_u32 s63, s57, 0
		s_mov_b32 m0, s62
		v_accvgpr_read_b32 v11, a56
		v_add_u32_e32 v11, s1, v11
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[56:57], v11, s21
		s_add_i32 s35, s46, s32
		v_add_u32_e32 v10, s35, v8
		v_cndmask_b32_e64 v10, v20, v10, s[56:57]
		s_add_u32 s56, s58, 0x1040
		s_addc_u32 s57, s59, 0
		s_add_u32 s56, s56, s60
		s_addc_u32 s57, s57, s61
		s_add_u32 s62, s56, 0
		s_addc_u32 s63, s57, 0
		s_mov_b32 m0, s62
		v_accvgpr_read_b32 v11, a57
		v_add_u32_e32 v11, s1, v11
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[56:57], v11, s21
		s_add_i32 s35, s47, s32
		v_add_u32_e32 v10, s35, v8
		v_cndmask_b32_e64 v10, v20, v10, s[56:57]
		s_add_u32 s56, s58, 0x2080
		s_addc_u32 s57, s59, 0
		s_add_u32 s56, s56, s60
		s_addc_u32 s57, s57, s61
		s_add_u32 s62, s56, 0
		s_addc_u32 s63, s57, 0
		s_mov_b32 m0, s62
		v_accvgpr_read_b32 v11, a58
		v_add_u32_e32 v11, s1, v11
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[56:57], v11, s21
		s_add_i32 s32, s33, s32
		v_add_u32_e32 v10, s32, v8
		v_cndmask_b32_e64 v10, v20, v10, s[56:57]
		s_add_u32 s56, s58, 0x30c0
		s_addc_u32 s57, s59, 0
		s_add_u32 s56, s56, s60
		s_addc_u32 s57, s57, s61
		s_add_u32 s58, s56, 0
		s_addc_u32 s59, s57, 0
		s_mov_b32 m0, s58
		v_accvgpr_read_b32 v11, a59
		v_add_u32_e32 v11, s1, v11
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		s_mul_i32 s32, s17, s44
		s_lshl_b32 s32, s32, 1
		s_add_i32 s35, s48, s32
		v_add_u32_e32 v10, s35, v3
		v_cndmask_b32_e64 v10, v20, v10, s[54:55]
		s_mov_b32 s54, 0x440
		s_mov_b32 s55, 0
		s_mul_i32 s56, s54, s52
		s_mul_hi_u32 s57, s54, s52
		s_mul_i32 s35, s54, s53
		s_add_i32 s57, s57, s35
		s_mul_i32 s35, s55, s52
		s_add_i32 s57, s57, s35
		s_add_u32 s52, s56, 0x81f0
		s_addc_u32 s53, s57, 0
		s_mov_b32 s54, 0x4400
		s_mov_b32 s55, 0
		s_mul_i32 s58, s54, s40
		s_mul_hi_u32 s59, s54, s40
		s_mul_i32 s35, s54, s41
		s_add_i32 s59, s59, s35
		s_mul_i32 s35, s55, s40
		s_add_i32 s59, s59, s35
		s_add_u32 s40, s52, s58
		s_addc_u32 s41, s53, s59
		s_add_u32 s52, s40, 0
		s_addc_u32 s53, s41, 0
		s_mov_b32 m0, s52
		v_accvgpr_read_b32 v21, a60
		v_add_u32_e32 v21, s1, v21
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[40:41], v11, s21
		s_add_i32 s35, s49, s32
		v_add_u32_e32 v10, s35, v3
		v_cndmask_b32_e64 v10, v20, v10, s[40:41]
		s_add_u32 s40, s56, 0x92f0
		s_addc_u32 s41, s57, 0
		s_add_u32 s40, s40, s58
		s_addc_u32 s41, s41, s59
		s_add_u32 s52, s40, 0
		s_addc_u32 s53, s41, 0
		s_mov_b32 m0, s52
		v_accvgpr_read_b32 v11, a61
		v_add_u32_e32 v11, s1, v11
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[40:41], v21, s21
		s_add_i32 s1, s50, s32
		v_add_u32_e32 v10, s1, v3
		s_add_u32 s52, s56, 0xa3f0
		s_addc_u32 s53, s57, 0
		s_add_u32 s52, s52, s58
		s_addc_u32 s53, s53, s59
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		v_cndmask_b32_e64 v10, v20, v10, s[40:41]
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		s_add_i32 s1, s34, s32
		v_cmp_lt_i32_e64 vcc, v11, s21
		v_add_u32_e32 v10, s1, v3
		s_add_u32 s40, s56, 0xb4f0
		s_addc_u32 s41, s57, 0
		v_cndmask_b32_e32 v10, v20, v10, vcc
		s_add_u32 s40, s40, s58
		s_addc_u32 s41, s41, s59
		s_add_u32 s52, s40, 0
		s_addc_u32 s53, s41, 0
		s_mov_b32 m0, s52
		s_nop 0
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_2
.L_attn_fwd_persistent.if_else_2:
.L_attn_fwd_persistent.if_end_2:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[96:111], a[64:67], a[24:27], 0
		v_add_u32_e32 v10, s44, v7
		v_mfma_f32_32x32x16_bf16 v[112:127], a[148:151], a[24:27], 0
		v_accvgpr_read_b32 v11, a13
		v_add_u32_e32 v11, s44, v11
		v_mfma_f32_32x32x16_bf16 v[128:143], a[164:167], a[24:27], 0
		v_accvgpr_read_b32 v21, a14
		v_add_u32_e32 v21, s44, v21
		v_mfma_f32_32x32x16_bf16 v[144:159], v[16:19], a[24:27], 0
		v_accvgpr_read_b32 v24, a62
		v_add_u32_e32 v24, s44, v24
		v_mfma_f32_32x32x16_bf16 v[160:175], v[16:19], a[40:43], 0
		v_accvgpr_read_b32 v16, a75
		v_add_u32_e32 v16, s44, v16
		v_mfma_f32_32x32x16_bf16 v[176:191], a[64:67], a[40:43], 0
		v_accvgpr_read_b32 v17, a76
		v_add_u32_e32 v17, s44, v17
		v_mfma_f32_32x32x16_bf16 v[192:207], a[148:151], a[40:43], 0
		v_accvgpr_read_b32 v18, a79
		v_add_u32_e32 v18, s44, v18
		v_mfma_f32_32x32x16_bf16 v[208:223], a[164:167], a[40:43], 0
		v_accvgpr_read_b32 v19, a80
		v_add_u32_e32 v19, s44, v19
		v_mfma_f32_32x32x16_bf16 v[96:111], a[136:139], a[28:31], v[96:111]
		v_accvgpr_read_b32 v25, a83
		v_add_u32_e32 v25, s44, v25
		v_mfma_f32_32x32x16_bf16 v[112:127], a[152:155], a[28:31], v[112:127]
		v_accvgpr_read_b32 v26, a84
		v_add_u32_e32 v26, s44, v26
		v_mfma_f32_32x32x16_bf16 v[128:143], a[168:171], a[28:31], v[128:143]
		v_accvgpr_read_b32 v27, a87
		v_add_u32_e32 v27, s44, v27
		v_mfma_f32_32x32x16_bf16 v[144:159], a[180:183], a[28:31], v[144:159]
		v_accvgpr_read_b32 v28, a88
		v_add_u32_e32 v28, s44, v28
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[44:47], v[160:175]
		v_accvgpr_read_b32 v29, a91
		v_add_u32_e32 v29, s44, v29
		v_mfma_f32_32x32x16_bf16 v[176:191], a[136:139], a[44:47], v[176:191]
		v_accvgpr_read_b32 v30, a92
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a64, v30
		v_mfma_f32_32x32x16_bf16 v[192:207], a[152:155], a[44:47], v[192:207]
		v_accvgpr_read_b32 v30, a95
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a65, v30
		v_mfma_f32_32x32x16_bf16 v[208:223], a[168:171], a[44:47], v[208:223]
		v_accvgpr_read_b32 v30, a96
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a66, v30
		v_mfma_f32_32x32x16_bf16 v[96:111], a[140:143], a[32:35], v[96:111]
		v_accvgpr_read_b32 v30, a99
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a67, v30
		v_mfma_f32_32x32x16_bf16 v[112:127], a[156:159], a[32:35], v[112:127]
		v_accvgpr_read_b32 v30, a100
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a69, v30
		v_mfma_f32_32x32x16_bf16 v[128:143], a[172:175], a[32:35], v[128:143]
		v_accvgpr_read_b32 v30, a103
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a70, v30
		v_mfma_f32_32x32x16_bf16 v[144:159], a[184:187], a[32:35], v[144:159]
		v_accvgpr_read_b32 v30, a104
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a71, v30
		v_mfma_f32_32x32x16_bf16 v[160:175], a[184:187], a[48:51], v[160:175]
		v_accvgpr_read_b32 v30, a107
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a133, v30
		v_mfma_f32_32x32x16_bf16 v[176:191], a[140:143], a[48:51], v[176:191]
		v_accvgpr_read_b32 v30, a108
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a134, v30
		v_mfma_f32_32x32x16_bf16 v[192:207], a[156:159], a[48:51], v[192:207]
		v_accvgpr_read_b32 v30, a111
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a135, v30
		v_mfma_f32_32x32x16_bf16 v[208:223], a[172:175], a[48:51], v[208:223]
		v_accvgpr_read_b32 v30, a112
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a136, v30
		v_mfma_f32_32x32x16_bf16 v[96:111], a[144:147], a[36:39], v[96:111]
		v_accvgpr_read_b32 v30, a115
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a137, v30
		v_mfma_f32_32x32x16_bf16 v[112:127], a[160:163], a[36:39], v[112:127]
		v_accvgpr_read_b32 v30, a116
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a138, v30
		v_mfma_f32_32x32x16_bf16 v[128:143], a[176:179], a[36:39], v[128:143]
		v_accvgpr_read_b32 v30, a119
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a139, v30
		v_mfma_f32_32x32x16_bf16 v[144:159], a[188:191], a[36:39], v[144:159]
		v_accvgpr_read_b32 v30, a120
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a140, v30
		v_mfma_f32_32x32x16_bf16 v[160:175], a[188:191], a[52:55], v[160:175]
		v_accvgpr_read_b32 v30, a123
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a141, v30
		v_mfma_f32_32x32x16_bf16 v[176:191], a[144:147], a[52:55], v[176:191]
		v_accvgpr_read_b32 v30, a124
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a142, v30
		v_mfma_f32_32x32x16_bf16 v[192:207], a[160:163], a[52:55], v[192:207]
		v_accvgpr_read_b32 v30, a127
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a143, v30
		v_mfma_f32_32x32x16_bf16 v[208:223], a[176:179], a[52:55], v[208:223]
		v_accvgpr_read_b32 v30, a128
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a144, v30
		v_accvgpr_read_b32 v30, a131
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a145, v30
		v_accvgpr_read_b32 v30, a132
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_write_b32 a146, v30
		v_cmp_ge_i32_e64 s[40:41], v2, v10
		v_cmp_ge_i32_e64 s[52:53], v2, v11
		v_cmp_ge_i32_e64 s[54:55], v2, v21
		v_cmp_ge_i32_e64 vcc, v2, v24
		v_accvgpr_read_b32 v30, a68
		v_add_u32_e32 v30, s44, v30
		v_accvgpr_read_b32 v31, a74
		v_add_u32_e32 v31, s44, v31
		v_cndmask_b32_e32 v225, v5, v99, vcc
		v_cmp_ge_i32_e64 s[56:57], v2, v30
		v_cmp_ge_i32_e64 s[58:59], v2, v31
		v_cmp_ge_i32_e64 s[60:61], v2, v16
		v_cmp_ge_i32_e64 vcc, v2, v17
		v_accvgpr_read_b32 v99, a77
		v_add_u32_e32 v99, s44, v99
		v_accvgpr_read_b32 v224, a78
		v_add_u32_e32 v226, s44, v224
		v_cndmask_b32_e32 v229, v5, v103, vcc
		v_cmp_ge_i32_e64 s[62:63], v2, v99
		v_cmp_ge_i32_e64 s[64:65], v2, v226
		v_cmp_ge_i32_e64 s[66:67], v2, v18
		v_cmp_ge_i32_e64 vcc, v2, v19
		v_accvgpr_read_b32 v103, a81
		v_add_u32_e32 v103, s44, v103
		v_accvgpr_read_b32 v224, a82
		v_add_u32_e32 v227, s44, v224
		v_cndmask_b32_e32 v231, v5, v107, vcc
		v_cmp_ge_i32_e64 s[68:69], v2, v103
		v_cmp_ge_i32_e64 s[70:71], v2, v227
		v_cmp_ge_i32_e64 s[72:73], v2, v25
		v_cmp_ge_i32_e64 vcc, v2, v26
		v_accvgpr_read_b32 v107, a85
		v_add_u32_e32 v107, s44, v107
		v_accvgpr_read_b32 v224, a86
		v_add_u32_e32 v232, s44, v224
		v_cndmask_b32_e32 v235, v5, v111, vcc
		v_cmp_ge_i32_e64 s[74:75], v2, v107
		v_cmp_ge_i32_e64 s[76:77], v2, v232
		v_cmp_ge_i32_e64 s[78:79], v2, v27
		v_cmp_ge_i32_e64 vcc, v2, v28
		v_accvgpr_read_b32 v111, a89
		v_add_u32_e32 v111, s44, v111
		v_accvgpr_read_b32 v224, a90
		v_add_u32_e32 v233, s44, v224
		v_cndmask_b32_e32 v237, v5, v115, vcc
		v_cmp_ge_i32_e64 s[80:81], v2, v111
		v_cmp_ge_i32_e64 s[82:83], v2, v233
		v_cmp_ge_i32_e64 s[84:85], v2, v29
		v_accvgpr_read_b32 v115, a64
		v_cmp_ge_i32_e64 vcc, v2, v115
		v_accvgpr_read_b32 v115, a93
		v_add_u32_e32 v115, s44, v115
		v_accvgpr_write_b32 a147, v115
		v_accvgpr_read_b32 v115, a94
		v_add_u32_e32 v115, s44, v115
		v_accvgpr_write_b32 a148, v115
		v_cndmask_b32_e32 v239, v5, v119, vcc
		v_accvgpr_read_b32 v115, a147
		v_cmp_ge_i32_e64 s[86:87], v2, v115
		v_accvgpr_read_b32 v115, a148
		v_cmp_ge_i32_e64 s[88:89], v2, v115
		v_accvgpr_read_b32 v115, a65
		v_cmp_ge_i32_e64 s[90:91], v2, v115
		s_nop 1
		v_mov_b32_e32 v240, s90
		v_mov_b32_e32 v241, s91
		v_accvgpr_write_b32 a150, v240
		v_accvgpr_write_b32 a151, v241
		v_accvgpr_read_b32 v115, a66
		v_cmp_ge_i32_e64 vcc, v2, v115
		v_accvgpr_read_b32 v115, a97
		v_add_u32_e32 v115, s44, v115
		v_accvgpr_write_b32 a149, v115
		v_accvgpr_read_b32 v115, a98
		v_add_u32_e32 v115, s44, v115
		v_accvgpr_write_b32 a152, v115
		v_cndmask_b32_e32 v241, v5, v123, vcc
		v_accvgpr_read_b32 v115, a149
		v_cmp_ge_i32_e64 s[90:91], v2, v115
		s_nop 1
		v_mov_b32_e32 v242, s90
		v_mov_b32_e32 v243, s91
		v_accvgpr_write_b32 a154, v242
		v_accvgpr_write_b32 a155, v243
		v_accvgpr_read_b32 v115, a152
		v_cmp_ge_i32_e64 s[90:91], v2, v115
		s_nop 1
		v_mov_b32_e32 v242, s90
		v_mov_b32_e32 v243, s91
		v_accvgpr_write_b32 a156, v242
		v_accvgpr_write_b32 a157, v243
		v_accvgpr_read_b32 v115, a67
		v_cmp_ge_i32_e64 s[90:91], v2, v115
		s_nop 1
		v_mov_b32_e32 v242, s90
		v_mov_b32_e32 v243, s91
		v_accvgpr_write_b32 a158, v242
		v_accvgpr_write_b32 a159, v243
		v_accvgpr_read_b32 v115, a69
		v_cmp_ge_i32_e64 vcc, v2, v115
		v_accvgpr_read_b32 v115, a101
		v_add_u32_e32 v115, s44, v115
		v_accvgpr_write_b32 a153, v115
		v_accvgpr_read_b32 v115, a102
		v_add_u32_e32 v115, s44, v115
		v_accvgpr_write_b32 a160, v115
		v_cndmask_b32_e32 v243, v5, v127, vcc
		v_accvgpr_read_b32 v115, a153
		v_cmp_ge_i32_e64 s[90:91], v2, v115
		s_nop 1
		v_mov_b32_e32 v244, s90
		v_mov_b32_e32 v245, s91
		v_accvgpr_write_b32 a162, v244
		v_accvgpr_write_b32 a163, v245
		v_accvgpr_read_b32 v115, a160
		v_cmp_ge_i32_e64 s[90:91], v2, v115
		s_nop 1
		v_mov_b32_e32 v244, s90
		v_mov_b32_e32 v245, s91
		v_accvgpr_write_b32 a164, v244
		v_accvgpr_write_b32 a165, v245
		v_accvgpr_read_b32 v115, a70
		v_cmp_ge_i32_e64 s[90:91], v2, v115
		s_nop 1
		v_mov_b32_e32 v244, s90
		v_mov_b32_e32 v245, s91
		v_accvgpr_write_b32 a166, v244
		v_accvgpr_write_b32 a167, v245
		v_accvgpr_read_b32 v115, a71
		v_cmp_ge_i32_e64 vcc, v2, v115
		v_accvgpr_read_b32 v115, a105
		v_add_u32_e32 v115, s44, v115
		v_accvgpr_write_b32 a161, v115
		v_accvgpr_read_b32 v115, a106
		v_add_u32_e32 v115, s44, v115
		v_accvgpr_write_b32 a168, v115
		v_cndmask_b32_e32 v245, v5, v131, vcc
		v_accvgpr_read_b32 v115, a161
		v_cmp_ge_i32_e64 s[90:91], v2, v115
		s_nop 1
		v_mov_b32_e32 v246, s90
		v_mov_b32_e32 v247, s91
		v_accvgpr_write_b32 a170, v246
		v_accvgpr_write_b32 a171, v247
		v_accvgpr_read_b32 v115, a168
		v_cmp_ge_i32_e64 s[90:91], v2, v115
		s_nop 1
		v_mov_b32_e32 v246, s90
		v_mov_b32_e32 v247, s91
		v_accvgpr_write_b32 a172, v246
		v_accvgpr_write_b32 a173, v247
		v_accvgpr_read_b32 v115, a133
		v_cmp_ge_i32_e64 s[90:91], v2, v115
		s_nop 1
		v_mov_b32_e32 v246, s90
		v_mov_b32_e32 v247, s91
		v_accvgpr_write_b32 a174, v246
		v_accvgpr_write_b32 a175, v247
		v_accvgpr_read_b32 v115, a134
		v_cmp_ge_i32_e64 vcc, v2, v115
		v_accvgpr_read_b32 v115, a109
		v_add_u32_e32 v115, s44, v115
		v_accvgpr_write_b32 a169, v115
		v_accvgpr_read_b32 v115, a110
		v_add_u32_e32 v115, s44, v115
		v_accvgpr_write_b32 a176, v115
		v_cndmask_b32_e32 v247, v5, v135, vcc
		v_accvgpr_read_b32 v115, a169
		v_cmp_ge_i32_e64 s[90:91], v2, v115
		s_nop 1
		v_mov_b32_e32 v248, s90
		v_mov_b32_e32 v249, s91
		v_accvgpr_write_b32 a178, v248
		v_accvgpr_write_b32 a179, v249
		v_accvgpr_read_b32 v115, a176
		v_cmp_ge_i32_e64 s[90:91], v2, v115
		s_nop 1
		v_mov_b32_e32 v248, s90
		v_mov_b32_e32 v249, s91
		v_accvgpr_write_b32 a180, v248
		v_accvgpr_write_b32 a181, v249
		v_accvgpr_read_b32 v115, a135
		v_cmp_ge_i32_e64 s[90:91], v2, v115
		s_nop 1
		v_mov_b32_e32 v248, s90
		v_mov_b32_e32 v249, s91
		v_accvgpr_write_b32 a182, v248
		v_accvgpr_write_b32 a183, v249
		v_accvgpr_read_b32 v115, a136
		v_cmp_ge_i32_e64 vcc, v2, v115
		v_accvgpr_read_b32 v115, a113
		v_add_u32_e32 v115, s44, v115
		v_accvgpr_write_b32 a177, v115
		v_accvgpr_read_b32 v115, a114
		v_add_u32_e32 v115, s44, v115
		v_accvgpr_write_b32 a184, v115
		v_cndmask_b32_e32 v249, v5, v139, vcc
		v_accvgpr_read_b32 v115, a177
		v_cmp_ge_i32_e64 s[90:91], v2, v115
		v_accvgpr_read_b32 v115, a184
		v_cmp_ge_i32_e64 s[92:93], v2, v115
		v_accvgpr_read_b32 v115, a137
		v_cmp_ge_i32_e64 s[94:95], v2, v115
		v_accvgpr_read_b32 v115, a138
		v_cmp_ge_i32_e64 vcc, v2, v115
		v_cndmask_b32_e64 v251, v5, v141, s[92:93]
		v_cndmask_b32_e64 v252, v5, v142, s[94:95]
		v_accvgpr_read_b32 v115, a117
		v_add_u32_e32 v115, s44, v115
		v_accvgpr_read_b32 v119, a118
		v_add_u32_e32 v119, s44, v119
		v_accvgpr_write_b32 a185, v119
		v_cndmask_b32_e32 v253, v5, v143, vcc
		v_cmp_ge_i32_e64 s[92:93], v2, v115
		v_accvgpr_read_b32 v119, a185
		v_cmp_ge_i32_e64 s[94:95], v2, v119
		v_accvgpr_read_b32 v119, a139
		v_cmp_ge_i32_e64 s[96:97], v2, v119
		v_cndmask_b32_e64 v142, v5, v144, s[92:93]
		v_cndmask_b32_e64 v143, v5, v145, s[94:95]
		v_cndmask_b32_e64 v144, v5, v146, s[96:97]
		v_accvgpr_read_b32 v119, a140
		v_cmp_ge_i32_e64 vcc, v2, v119
		v_accvgpr_read_b32 v119, a121
		v_add_u32_e32 v119, s44, v119
		v_accvgpr_write_b32 a186, v119
		v_accvgpr_read_b32 v119, a122
		v_add_u32_e32 v119, s44, v119
		v_accvgpr_write_b32 a187, v119
		v_cndmask_b32_e32 v145, v5, v147, vcc
		v_accvgpr_read_b32 v119, a186
		v_cmp_ge_i32_e64 s[92:93], v2, v119
		v_accvgpr_read_b32 v119, a187
		v_cmp_ge_i32_e64 s[94:95], v2, v119
		v_accvgpr_read_b32 v119, a141
		v_cmp_ge_i32_e64 s[96:97], v2, v119
		v_cndmask_b32_e64 v146, v5, v148, s[92:93]
		v_cndmask_b32_e64 v147, v5, v149, s[94:95]
		v_cndmask_b32_e64 v148, v5, v150, s[96:97]
		v_accvgpr_read_b32 v119, a142
		v_cmp_ge_i32_e64 vcc, v2, v119
		v_accvgpr_read_b32 v119, a125
		v_add_u32_e32 v119, s44, v119
		v_accvgpr_write_b32 a188, v119
		v_accvgpr_read_b32 v119, a126
		v_add_u32_e32 v119, s44, v119
		v_accvgpr_write_b32 a189, v119
		v_cndmask_b32_e32 v149, v5, v151, vcc
		v_accvgpr_read_b32 v119, a188
		v_cmp_ge_i32_e64 s[92:93], v2, v119
		v_accvgpr_read_b32 v119, a189
		v_cmp_ge_i32_e64 s[94:95], v2, v119
		v_accvgpr_read_b32 v119, a143
		v_cmp_ge_i32_e64 s[96:97], v2, v119
		v_cndmask_b32_e64 v150, v5, v152, s[92:93]
		v_cndmask_b32_e64 v151, v5, v153, s[94:95]
		v_cndmask_b32_e64 v152, v5, v154, s[96:97]
		v_accvgpr_read_b32 v119, a144
		v_cmp_ge_i32_e64 vcc, v2, v119
		v_accvgpr_read_b32 v119, a129
		v_add_u32_e32 v119, s44, v119
		v_accvgpr_write_b32 a190, v119
		v_accvgpr_read_b32 v119, a130
		v_add_u32_e32 v119, s44, v119
		v_accvgpr_write_b32 a191, v119
		v_cndmask_b32_e32 v153, v5, v155, vcc
		v_accvgpr_read_b32 v119, a190
		v_cmp_ge_i32_e64 s[92:93], v2, v119
		v_accvgpr_read_b32 v119, a191
		v_cmp_ge_i32_e64 s[94:95], v2, v119
		v_accvgpr_read_b32 v119, a145
		v_cmp_ge_i32_e64 s[96:97], v2, v119
		v_cndmask_b32_e64 v154, v5, v156, s[92:93]
		v_cndmask_b32_e64 v155, v5, v157, s[94:95]
		v_cndmask_b32_e64 v156, v5, v158, s[96:97]
		v_accvgpr_read_b32 v119, a146
		v_cmp_ge_i32_e64 vcc, v2, v119
		v_cndmask_b32_e64 v254, v5, v96, s[40:41]
		v_cndmask_b32_e64 v255, v5, v97, s[52:53]
		v_cndmask_b32_e32 v157, v5, v159, vcc
		v_cmp_ge_i32_e64 s[40:41], v4, v10
		v_cmp_ge_i32_e64 s[52:53], v4, v11
		v_cmp_ge_i32_e64 s[92:93], v4, v21
		v_cmp_ge_i32_e64 vcc, v4, v24
		v_cndmask_b32_e64 v224, v5, v98, s[54:55]
		v_cndmask_b32_e64 v10, v5, v178, s[92:93]
		v_cndmask_b32_e64 v96, v5, v100, s[56:57]
		v_cndmask_b32_e32 v11, v5, v179, vcc
		v_cmp_ge_i32_e64 s[54:55], v4, v30
		v_cmp_ge_i32_e64 s[56:57], v4, v31
		v_cmp_ge_i32_e64 s[92:93], v4, v16
		v_cndmask_b32_e64 v30, v5, v180, s[54:55]
		v_cndmask_b32_e64 v31, v5, v181, s[56:57]
		v_cndmask_b32_e64 v158, v5, v182, s[92:93]
		v_cmp_ge_i32_e64 vcc, v4, v17
		v_cndmask_b32_e64 v97, v5, v101, s[58:59]
		v_cndmask_b32_e64 v228, v5, v102, s[60:61]
		v_cndmask_b32_e32 v159, v5, v183, vcc
		v_cmp_ge_i32_e64 s[54:55], v4, v99
		v_cmp_ge_i32_e64 s[56:57], v4, v226
		v_cmp_ge_i32_e64 s[58:59], v4, v18
		v_cndmask_b32_e64 v16, v5, v184, s[54:55]
		v_cndmask_b32_e64 v17, v5, v185, s[56:57]
		v_cndmask_b32_e64 v98, v5, v186, s[58:59]
		v_cmp_ge_i32_e64 vcc, v4, v19
		v_cndmask_b32_e64 v18, v5, v104, s[62:63]
		v_cndmask_b32_e64 v19, v5, v105, s[64:65]
		v_cndmask_b32_e32 v99, v5, v187, vcc
		v_cmp_ge_i32_e64 s[54:55], v4, v103
		v_cmp_ge_i32_e64 s[56:57], v4, v227
		v_cmp_ge_i32_e64 s[58:59], v4, v25
		v_cndmask_b32_e64 v24, v5, v188, s[54:55]
		v_cndmask_b32_e64 v25, v5, v189, s[56:57]
		v_cndmask_b32_e64 v100, v5, v190, s[58:59]
		v_cmp_ge_i32_e64 vcc, v4, v26
		v_cndmask_b32_e64 v230, v5, v106, s[66:67]
		v_cndmask_b32_e64 v102, v5, v108, s[68:69]
		v_cndmask_b32_e32 v101, v5, v191, vcc
		v_cmp_ge_i32_e64 s[54:55], v4, v107
		v_cmp_ge_i32_e64 s[56:57], v4, v232
		v_cmp_ge_i32_e64 s[58:59], v4, v27
		v_cndmask_b32_e64 v26, v5, v192, s[54:55]
		v_cndmask_b32_e64 v27, v5, v193, s[56:57]
		v_cndmask_b32_e64 v104, v5, v194, s[58:59]
		v_cmp_ge_i32_e64 vcc, v4, v28
		v_cndmask_b32_e64 v103, v5, v109, s[70:71]
		v_cndmask_b32_e64 v234, v5, v110, s[72:73]
		v_cndmask_b32_e32 v105, v5, v195, vcc
		v_cmp_ge_i32_e64 s[54:55], v4, v111
		v_cmp_ge_i32_e64 s[56:57], v4, v233
		v_cmp_ge_i32_e64 s[58:59], v4, v29
		v_cndmask_b32_e64 v28, v5, v196, s[54:55]
		v_cndmask_b32_e64 v29, v5, v197, s[56:57]
		v_cndmask_b32_e64 v106, v5, v198, s[58:59]
		v_accvgpr_read_b32 v21, a64
		v_cmp_ge_i32_e64 vcc, v4, v21
		v_cndmask_b32_e64 v108, v5, v112, s[74:75]
		v_cndmask_b32_e64 v109, v5, v113, s[76:77]
		v_cndmask_b32_e32 v107, v5, v199, vcc
		v_accvgpr_read_b32 v21, a147
		v_cmp_ge_i32_e64 s[54:55], v4, v21
		v_accvgpr_read_b32 v21, a148
		v_cmp_ge_i32_e64 s[56:57], v4, v21
		v_accvgpr_read_b32 v21, a65
		v_cmp_ge_i32_e64 s[58:59], v4, v21
		v_cndmask_b32_e64 v110, v5, v200, s[54:55]
		v_cndmask_b32_e64 v111, v5, v201, s[56:57]
		v_cndmask_b32_e64 v112, v5, v202, s[58:59]
		v_accvgpr_read_b32 v21, a66
		v_cmp_ge_i32_e64 vcc, v4, v21
		v_cndmask_b32_e64 v236, v5, v114, s[78:79]
		v_cndmask_b32_e64 v178, v5, v116, s[80:81]
		v_cndmask_b32_e32 v113, v5, v203, vcc
		v_accvgpr_read_b32 v21, a149
		v_cmp_ge_i32_e64 s[54:55], v4, v21
		v_accvgpr_read_b32 v21, a152
		v_cmp_ge_i32_e64 s[56:57], v4, v21
		v_accvgpr_read_b32 v21, a67
		v_cmp_ge_i32_e64 s[58:59], v4, v21
		v_cndmask_b32_e64 v180, v5, v204, s[54:55]
		v_cndmask_b32_e64 v181, v5, v205, s[56:57]
		v_cndmask_b32_e64 v182, v5, v206, s[58:59]
		v_accvgpr_read_b32 v21, a69
		v_cmp_ge_i32_e64 vcc, v4, v21
		v_cndmask_b32_e64 v179, v5, v117, s[82:83]
		v_cndmask_b32_e64 v238, v5, v118, s[84:85]
		v_cndmask_b32_e32 v183, v5, v207, vcc
		v_accvgpr_read_b32 v21, a153
		v_cmp_ge_i32_e64 s[54:55], v4, v21
		v_accvgpr_read_b32 v21, a160
		v_cmp_ge_i32_e64 s[56:57], v4, v21
		v_accvgpr_read_b32 v21, a70
		v_cmp_ge_i32_e64 s[58:59], v4, v21
		v_cndmask_b32_e64 v116, v5, v208, s[54:55]
		v_cndmask_b32_e64 v117, v5, v209, s[56:57]
		v_cndmask_b32_e64 v118, v5, v210, s[58:59]
		v_accvgpr_read_b32 v21, a71
		v_cmp_ge_i32_e64 vcc, v4, v21
		v_cndmask_b32_e64 v184, v5, v120, s[86:87]
		v_cndmask_b32_e64 v185, v5, v121, s[88:89]
		v_cndmask_b32_e32 v119, v5, v211, vcc
		v_accvgpr_read_b32 v21, a161
		v_cmp_ge_i32_e64 s[54:55], v4, v21
		v_accvgpr_read_b32 v21, a168
		v_cmp_ge_i32_e64 s[56:57], v4, v21
		v_accvgpr_read_b32 v21, a133
		v_cmp_ge_i32_e64 s[58:59], v4, v21
		v_cndmask_b32_e64 v120, v5, v212, s[54:55]
		v_cndmask_b32_e64 v121, v5, v213, s[56:57]
		v_cndmask_b32_e64 v186, v5, v214, s[58:59]
		v_accvgpr_read_b32 v21, a134
		v_cmp_ge_i32_e64 vcc, v4, v21
		v_accvgpr_read_b32 v21, a150
		s_nop 0
		v_readfirstlane_b32 s54, v21
		v_accvgpr_read_b32 v21, a151
		s_nop 0
		v_readfirstlane_b32 s55, v21
		s_nop 1
		v_cndmask_b32_e64 v240, v5, v122, s[54:55]
		v_accvgpr_read_b32 v21, a154
		s_nop 0
		v_readfirstlane_b32 s54, v21
		v_accvgpr_read_b32 v21, a155
		s_nop 0
		v_readfirstlane_b32 s55, v21
		s_nop 1
		v_cndmask_b32_e64 v122, v5, v124, s[54:55]
		v_cndmask_b32_e32 v187, v5, v215, vcc
		v_accvgpr_read_b32 v21, a169
		v_cmp_ge_i32_e64 s[54:55], v4, v21
		v_accvgpr_read_b32 v21, a176
		v_cmp_ge_i32_e64 s[56:57], v4, v21
		v_accvgpr_read_b32 v21, a135
		v_cmp_ge_i32_e64 s[58:59], v4, v21
		v_cndmask_b32_e64 v188, v5, v216, s[54:55]
		v_cndmask_b32_e64 v189, v5, v217, s[56:57]
		v_cndmask_b32_e64 v190, v5, v218, s[58:59]
		v_accvgpr_read_b32 v21, a136
		v_cmp_ge_i32_e64 vcc, v4, v21
		v_accvgpr_read_b32 v21, a156
		s_nop 0
		v_readfirstlane_b32 s54, v21
		v_accvgpr_read_b32 v21, a157
		s_nop 0
		v_readfirstlane_b32 s55, v21
		s_nop 1
		v_cndmask_b32_e64 v123, v5, v125, s[54:55]
		v_accvgpr_read_b32 v21, a158
		s_nop 0
		v_readfirstlane_b32 s54, v21
		v_accvgpr_read_b32 v21, a159
		s_nop 0
		v_readfirstlane_b32 s55, v21
		s_nop 1
		v_cndmask_b32_e64 v242, v5, v126, s[54:55]
		v_cndmask_b32_e32 v191, v5, v219, vcc
		v_accvgpr_read_b32 v21, a177
		v_cmp_ge_i32_e64 s[54:55], v4, v21
		v_accvgpr_read_b32 v21, a184
		v_cmp_ge_i32_e64 s[56:57], v4, v21
		v_accvgpr_read_b32 v21, a137
		v_cmp_ge_i32_e64 s[58:59], v4, v21
		v_cndmask_b32_e64 v124, v5, v220, s[54:55]
		v_cndmask_b32_e64 v125, v5, v221, s[56:57]
		v_cndmask_b32_e64 v126, v5, v222, s[58:59]
		v_accvgpr_read_b32 v21, a138
		v_cmp_ge_i32_e64 vcc, v4, v21
		v_accvgpr_read_b32 v21, a162
		s_nop 0
		v_readfirstlane_b32 s54, v21
		v_accvgpr_read_b32 v21, a163
		s_nop 0
		v_readfirstlane_b32 s55, v21
		s_nop 1
		v_cndmask_b32_e64 v192, v5, v128, s[54:55]
		v_accvgpr_read_b32 v21, a164
		s_nop 0
		v_readfirstlane_b32 s54, v21
		v_accvgpr_read_b32 v21, a165
		s_nop 0
		v_readfirstlane_b32 s55, v21
		s_nop 1
		v_cndmask_b32_e64 v193, v5, v129, s[54:55]
		v_cndmask_b32_e32 v127, v5, v223, vcc
		v_cmp_ge_i32_e64 s[54:55], v4, v115
		v_accvgpr_read_b32 v21, a185
		v_cmp_ge_i32_e64 s[56:57], v4, v21
		v_accvgpr_read_b32 v21, a139
		v_cmp_ge_i32_e64 s[58:59], v4, v21
		v_cndmask_b32_e64 v114, v5, v160, s[54:55]
		v_cndmask_b32_e64 v115, v5, v161, s[56:57]
		v_cndmask_b32_e64 v128, v5, v162, s[58:59]
		v_accvgpr_read_b32 v21, a140
		v_cmp_ge_i32_e64 vcc, v4, v21
		v_accvgpr_read_b32 v21, a166
		s_nop 0
		v_readfirstlane_b32 s54, v21
		v_accvgpr_read_b32 v21, a167
		s_nop 0
		v_readfirstlane_b32 s55, v21
		s_nop 1
		v_cndmask_b32_e64 v244, v5, v130, s[54:55]
		v_accvgpr_read_b32 v21, a170
		s_nop 0
		v_readfirstlane_b32 s54, v21
		v_accvgpr_read_b32 v21, a171
		s_nop 0
		v_readfirstlane_b32 s55, v21
		s_nop 1
		v_cndmask_b32_e64 v130, v5, v132, s[54:55]
		v_cndmask_b32_e32 v129, v5, v163, vcc
		v_accvgpr_read_b32 v21, a186
		v_cmp_ge_i32_e64 s[54:55], v4, v21
		v_accvgpr_read_b32 v21, a187
		v_cmp_ge_i32_e64 s[56:57], v4, v21
		v_accvgpr_read_b32 v21, a141
		v_cmp_ge_i32_e64 s[58:59], v4, v21
		v_cndmask_b32_e64 v160, v5, v164, s[54:55]
		v_cndmask_b32_e64 v161, v5, v165, s[56:57]
		v_cndmask_b32_e64 v162, v5, v166, s[58:59]
		v_accvgpr_read_b32 v21, a142
		v_cmp_ge_i32_e64 vcc, v4, v21
		v_accvgpr_read_b32 v21, a172
		s_nop 0
		v_readfirstlane_b32 s54, v21
		v_accvgpr_read_b32 v21, a173
		s_nop 0
		v_readfirstlane_b32 s55, v21
		s_nop 1
		v_cndmask_b32_e64 v131, v5, v133, s[54:55]
		v_accvgpr_read_b32 v21, a174
		s_nop 0
		v_readfirstlane_b32 s54, v21
		v_accvgpr_read_b32 v21, a175
		s_nop 0
		v_readfirstlane_b32 s55, v21
		s_nop 1
		v_cndmask_b32_e64 v246, v5, v134, s[54:55]
		v_cndmask_b32_e32 v163, v5, v167, vcc
		v_accvgpr_read_b32 v21, a188
		v_cmp_ge_i32_e64 s[54:55], v4, v21
		v_accvgpr_read_b32 v21, a189
		v_cmp_ge_i32_e64 s[56:57], v4, v21
		v_accvgpr_read_b32 v21, a143
		v_cmp_ge_i32_e64 s[58:59], v4, v21
		v_cndmask_b32_e64 v132, v5, v168, s[54:55]
		v_cndmask_b32_e64 v133, v5, v169, s[56:57]
		v_cndmask_b32_e64 v134, v5, v170, s[58:59]
		v_accvgpr_read_b32 v21, a144
		v_cmp_ge_i32_e64 vcc, v4, v21
		v_accvgpr_read_b32 v21, a178
		s_nop 0
		v_readfirstlane_b32 s54, v21
		v_accvgpr_read_b32 v21, a179
		s_nop 0
		v_readfirstlane_b32 s55, v21
		s_nop 1
		v_cndmask_b32_e64 v164, v5, v136, s[54:55]
		v_accvgpr_read_b32 v21, a180
		s_nop 0
		v_readfirstlane_b32 s54, v21
		v_accvgpr_read_b32 v21, a181
		s_nop 0
		v_readfirstlane_b32 s55, v21
		s_nop 1
		v_cndmask_b32_e64 v165, v5, v137, s[54:55]
		v_cndmask_b32_e32 v135, v5, v171, vcc
		v_accvgpr_read_b32 v21, a190
		v_cmp_ge_i32_e64 s[54:55], v4, v21
		v_accvgpr_read_b32 v21, a191
		v_cmp_ge_i32_e64 s[56:57], v4, v21
		v_accvgpr_read_b32 v21, a145
		v_cmp_ge_i32_e64 s[58:59], v4, v21
		v_cndmask_b32_e64 v136, v5, v172, s[54:55]
		v_cndmask_b32_e64 v137, v5, v173, s[56:57]
		v_cndmask_b32_e64 v166, v5, v174, s[58:59]
		v_accvgpr_read_b32 v21, a146
		v_cmp_ge_i32_e64 vcc, v4, v21
		v_accvgpr_read_b32 v21, a182
		s_nop 0
		v_readfirstlane_b32 s54, v21
		v_accvgpr_read_b32 v21, a183
		s_nop 0
		v_readfirstlane_b32 s55, v21
		s_nop 1
		v_cndmask_b32_e64 v248, v5, v138, s[54:55]
		v_cndmask_b32_e64 v250, v5, v140, s[90:91]
		v_cndmask_b32_e32 v167, v5, v175, vcc
		v_max3_f32 v21, v254, v255, v224
		v_max3_f32 v138, v96, v97, v228
		v_max3_f32 v139, v18, v19, v230
		v_max3_f32 v140, v102, v103, v234
		v_max3_f32 v141, v108, v109, v236
		v_max3_f32 v168, v178, v179, v238
		v_max3_f32 v169, v184, v185, v240
		v_max3_f32 v170, v122, v123, v242
		v_max3_f32 v171, v192, v193, v244
		v_max3_f32 v172, v130, v131, v246
		v_max3_f32 v173, v164, v165, v248
		v_max3_f32 v174, v250, v251, v252
		v_max3_f32 v175, v142, v143, v144
		v_max3_f32 v194, v146, v147, v148
		v_max3_f32 v195, v150, v151, v152
		v_max3_f32 v196, v154, v155, v156
		v_max3_f32 v21, v21, v225, v138
		v_max3_f32 v138, v139, v231, v140
		v_max3_f32 v139, v141, v237, v168
		v_max3_f32 v140, v169, v241, v170
		v_max3_f32 v141, v171, v245, v172
		v_max3_f32 v168, v173, v249, v174
		v_max3_f32 v169, v175, v145, v194
		v_max3_f32 v170, v195, v153, v196
		v_max3_f32 v21, v21, v229, v138
		v_max3_f32 v138, v139, v239, v140
		v_max3_f32 v139, v141, v247, v168
		v_max3_f32 v140, v169, v149, v170
		v_max3_f32 v21, v21, v235, v138
		v_max3_f32 v138, v139, v253, v140
		v_max3_f32 v21, v21, v243, v138
		v_max_f32_e32 v138, v21, v157
		v_mov_b32_e32 v139, v138
		v_cndmask_b32_e64 v140, v5, v176, s[40:41]
		v_cndmask_b32_e64 v141, v5, v177, s[52:53]
		v_permlane32_swap_b32_e32 v138, v139
		v_max3_f32 v21, v140, v141, v10
		v_max3_f32 v168, v30, v31, v158
		v_max3_f32 v169, v16, v17, v98
		v_max3_f32 v170, v24, v25, v100
		v_max3_f32 v171, v26, v27, v104
		v_max3_f32 v172, v28, v29, v106
		v_max3_f32 v173, v110, v111, v112
		v_max3_f32 v174, v180, v181, v182
		v_max3_f32 v175, v116, v117, v118
		v_max3_f32 v176, v120, v121, v186
		v_max3_f32 v177, v188, v189, v190
		v_max3_f32 v194, v124, v125, v126
		v_max3_f32 v195, v114, v115, v128
		v_max3_f32 v196, v160, v161, v162
		v_max3_f32 v197, v132, v133, v134
		v_max3_f32 v198, v136, v137, v166
		v_max3_f32 v21, v21, v11, v168
		v_max3_f32 v168, v169, v99, v170
		v_max3_f32 v169, v171, v105, v172
		v_max3_f32 v170, v173, v113, v174
		v_max3_f32 v171, v175, v119, v176
		v_max3_f32 v172, v177, v191, v194
		v_max3_f32 v173, v195, v129, v196
		v_max3_f32 v174, v197, v135, v198
		v_max3_f32 v21, v21, v159, v168
		v_max3_f32 v168, v169, v107, v170
		v_max3_f32 v169, v171, v187, v172
		v_max3_f32 v170, v173, v163, v174
		v_max3_f32 v21, v21, v101, v168
		v_max3_f32 v168, v169, v127, v170
		v_max3_f32 v21, v21, v183, v168
		v_max_f32_e32 v168, v21, v167
		v_mov_b32_e32 v169, v168
		v_max_f32_e32 v170, v138, v139
		s_add_i32 s1, s44, 0x80
		s_cmp_lt_i32 s1, s23
		v_permlane32_swap_b32_e32 v168, v169
		v_max_f32_e32 v171, v168, v169
		v_pk_mul_f32 v[138:139], v[170:171], v[12:13]
		v_max_f32_e32 v168, v6, v138
		v_max_f32_e32 v169, v9, v139
		v_pk_fma_f32 v[138:139], v[254:255], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[224:225], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[96:97], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[228:229], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[18:19], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[18:19], v[230:231], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[102:103], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[234:235], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[108:109], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[236:237], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[178:179], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[238:239], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[184:185], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[240:241], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[122:123], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[242:243], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[192:193], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[244:245], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[130:131], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[246:247], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[164:165], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[248:249], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[250:251], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[252:253], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[142:143], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[144:145], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[146:147], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[148:149], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[150:151], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[154:155], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[156:157], v[12:13], v[168:169] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[140:141], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[10:11], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[10:11], v[30:31], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[158:159], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[16:17], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[16:17], v[98:99], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[24:25], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[100:101], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[26:27], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[104:105], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[28:29], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[106:107], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[110:111], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[112:113], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[180:181], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[182:183], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[116:117], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[118:119], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[120:121], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[186:187], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[188:189], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[190:191], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[124:125], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[126:127], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[114:115], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[128:129], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[160:161], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[162:163], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[132:133], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[134:135], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[136:137], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[166:167], v[12:13], v[168:169] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v166, v138
		v_exp_f32_e32 v214, v139
		v_exp_f32_e32 v138, v170
		v_exp_f32_e32 v216, v171
		v_exp_f32_e32 v170, v172
		v_exp_f32_e32 v218, v173
		v_exp_f32_e32 v172, v96
		v_exp_f32_e32 v220, v97
		v_exp_f32_e32 v96, v174
		v_exp_f32_e32 v222, v175
		v_exp_f32_e32 v174, v18
		v_exp_f32_e32 v224, v19
		v_exp_f32_e32 v18, v176
		v_exp_f32_e32 v226, v177
		v_exp_f32_e32 v176, v102
		v_exp_f32_e32 v228, v103
		v_exp_f32_e32 v102, v194
		v_exp_f32_e32 v230, v195
		v_exp_f32_e32 v194, v108
		v_exp_f32_e32 v232, v109
		v_exp_f32_e32 v108, v196
		v_exp_f32_e32 v234, v197
		v_exp_f32_e32 v196, v178
		v_exp_f32_e32 v236, v179
		v_exp_f32_e32 v178, v198
		v_exp_f32_e32 v238, v199
		v_exp_f32_e32 v198, v184
		v_exp_f32_e32 v240, v185
		v_exp_f32_e32 v184, v200
		v_exp_f32_e32 v242, v201
		v_exp_f32_e32 v200, v122
		v_exp_f32_e32 v244, v123
		v_exp_f32_e32 v167, v202
		v_exp_f32_e32 v215, v203
		v_exp_f32_e32 v139, v192
		v_exp_f32_e32 v217, v193
		v_exp_f32_e32 v171, v204
		v_exp_f32_e32 v219, v205
		v_exp_f32_e32 v173, v130
		v_exp_f32_e32 v221, v131
		v_exp_f32_e32 v97, v206
		v_exp_f32_e32 v223, v207
		v_exp_f32_e32 v175, v164
		v_exp_f32_e32 v225, v165
		v_exp_f32_e32 v19, v208
		v_exp_f32_e32 v227, v209
		v_exp_f32_e32 v177, v210
		v_exp_f32_e32 v229, v211
		v_exp_f32_e32 v103, v212
		v_exp_f32_e32 v231, v213
		v_exp_f32_e32 v195, v142
		v_exp_f32_e32 v233, v143
		v_exp_f32_e32 v109, v144
		v_exp_f32_e32 v235, v145
		v_exp_f32_e32 v197, v146
		v_exp_f32_e32 v237, v147
		v_exp_f32_e32 v179, v148
		v_exp_f32_e32 v239, v149
		v_exp_f32_e32 v199, v150
		v_exp_f32_e32 v241, v151
		v_exp_f32_e32 v185, v152
		v_exp_f32_e32 v243, v153
		v_exp_f32_e32 v201, v154
		v_exp_f32_e32 v245, v155
		v_exp_f32_e32 v122, v156
		v_exp_f32_e32 v130, v157
		v_exp_f32_e32 v142, v140
		v_exp_f32_e32 v144, v141
		v_exp_f32_e32 v140, v10
		v_exp_f32_e32 v146, v11
		v_exp_f32_e32 v10, v30
		v_exp_f32_e32 v148, v31
		v_exp_f32_e32 v30, v158
		v_exp_f32_e32 v150, v159
		v_exp_f32_e32 v152, v16
		v_exp_f32_e32 v154, v17
		v_exp_f32_e32 v16, v98
		v_exp_f32_e32 v156, v99
		v_exp_f32_e32 v98, v24
		v_exp_f32_e32 v158, v25
		v_exp_f32_e32 v24, v100
		v_exp_f32_e32 v164, v101
		v_exp_f32_e32 v100, v26
		v_exp_f32_e32 v192, v27
		v_exp_f32_e32 v26, v104
		v_exp_f32_e32 v202, v105
		v_exp_f32_e32 v104, v28
		v_exp_f32_e32 v204, v29
		v_exp_f32_e32 v28, v106
		v_exp_f32_e32 v206, v107
		v_exp_f32_e32 v106, v110
		v_exp_f32_e32 v208, v111
		v_exp_f32_e32 v110, v112
		v_exp_f32_e32 v210, v113
		v_exp_f32_e32 v112, v180
		v_exp_f32_e32 v212, v181
		v_exp_f32_e32 v123, v182
		v_exp_f32_e32 v131, v183
		v_exp_f32_e32 v143, v116
		v_exp_f32_e32 v145, v117
		v_exp_f32_e32 v141, v118
		v_exp_f32_e32 v147, v119
		v_exp_f32_e32 v11, v120
		v_exp_f32_e32 v149, v121
		v_exp_f32_e32 v31, v186
		v_exp_f32_e32 v151, v187
		v_exp_f32_e32 v153, v188
		v_exp_f32_e32 v155, v189
		v_exp_f32_e32 v17, v190
		v_exp_f32_e32 v157, v191
		v_exp_f32_e32 v99, v124
		v_exp_f32_e32 v159, v125
		v_exp_f32_e32 v25, v126
		v_exp_f32_e32 v165, v127
		v_exp_f32_e32 v101, v114
		v_exp_f32_e32 v193, v115
		v_exp_f32_e32 v27, v128
		v_exp_f32_e32 v203, v129
		v_exp_f32_e32 v105, v160
		v_exp_f32_e32 v205, v161
		v_exp_f32_e32 v29, v162
		v_exp_f32_e32 v207, v163
		v_exp_f32_e32 v107, v132
		v_exp_f32_e32 v209, v133
		v_exp_f32_e32 v111, v134
		v_exp_f32_e32 v211, v135
		v_exp_f32_e32 v113, v136
		v_exp_f32_e32 v213, v137
		v_pk_add_f32 v[114:115], v[166:167], v[214:215]
		v_pk_add_f32 v[116:117], v[138:139], v[216:217]
		v_pk_add_f32 v[118:119], v[170:171], v[218:219]
		v_pk_add_f32 v[120:121], v[172:173], v[220:221]
		v_pk_add_f32 v[124:125], v[96:97], v[222:223]
		v_pk_add_f32 v[126:127], v[174:175], v[224:225]
		v_pk_add_f32 v[128:129], v[18:19], v[226:227]
		v_pk_add_f32 v[132:133], v[176:177], v[228:229]
		v_pk_add_f32 v[134:135], v[102:103], v[230:231]
		v_pk_add_f32 v[136:137], v[194:195], v[232:233]
		v_pk_add_f32 v[160:161], v[108:109], v[234:235]
		v_pk_add_f32 v[162:163], v[196:197], v[236:237]
		v_pk_add_f32 v[180:181], v[178:179], v[238:239]
		v_pk_add_f32 v[182:183], v[198:199], v[240:241]
		v_pk_add_f32 v[186:187], v[184:185], v[242:243]
		v_pk_add_f32 v[188:189], v[200:201], v[244:245]
		v_pk_add_f32 v[114:115], v[114:115], v[116:117]
		v_pk_add_f32 v[116:117], v[118:119], v[120:121]
		v_pk_add_f32 v[118:119], v[124:125], v[126:127]
		v_pk_add_f32 v[120:121], v[128:129], v[132:133]
		v_pk_add_f32 v[124:125], v[134:135], v[136:137]
		v_pk_add_f32 v[126:127], v[160:161], v[162:163]
		v_pk_add_f32 v[128:129], v[180:181], v[182:183]
		v_pk_add_f32 v[132:133], v[186:187], v[188:189]
		v_pk_add_f32 v[114:115], v[114:115], v[116:117]
		v_pk_add_f32 v[116:117], v[118:119], v[120:121]
		v_pk_add_f32 v[118:119], v[124:125], v[126:127]
		v_pk_add_f32 v[120:121], v[128:129], v[132:133]
		v_pk_add_f32 v[114:115], v[114:115], v[116:117]
		v_pk_add_f32 v[116:117], v[118:119], v[120:121]
		v_pk_add_f32 v[118:119], v[114:115], v[116:117]
		v_add_f32_e32 v21, v118, v119
		v_accvgpr_read_b32 v114, a72
		ds_bpermute_b32 v116, v114, v21
		v_accvgpr_read_b32 v114, a73
		ds_bpermute_b32 v118, v114, v21
		v_pk_add_f32 v[114:115], v[122:123], v[130:131]
		v_pk_add_f32 v[120:121], v[142:143], v[144:145]
		v_pk_add_f32 v[124:125], v[140:141], v[146:147]
		v_pk_add_f32 v[126:127], v[10:11], v[148:149]
		v_pk_add_f32 v[128:129], v[30:31], v[150:151]
		v_pk_add_f32 v[132:133], v[152:153], v[154:155]
		v_pk_add_f32 v[134:135], v[16:17], v[156:157]
		v_pk_add_f32 v[136:137], v[98:99], v[158:159]
		v_pk_add_f32 v[160:161], v[24:25], v[164:165]
		v_pk_add_f32 v[162:163], v[100:101], v[192:193]
		v_pk_add_f32 v[180:181], v[26:27], v[202:203]
		v_pk_add_f32 v[182:183], v[104:105], v[204:205]
		v_pk_add_f32 v[186:187], v[28:29], v[206:207]
		v_pk_add_f32 v[188:189], v[106:107], v[208:209]
		v_pk_add_f32 v[190:191], v[110:111], v[210:211]
		v_pk_add_f32 v[246:247], v[112:113], v[212:213]
		v_pk_add_f32 v[114:115], v[114:115], v[120:121]
		v_pk_add_f32 v[120:121], v[124:125], v[126:127]
		v_pk_add_f32 v[124:125], v[128:129], v[132:133]
		v_pk_add_f32 v[126:127], v[134:135], v[136:137]
		v_pk_add_f32 v[128:129], v[160:161], v[162:163]
		v_pk_add_f32 v[132:133], v[180:181], v[182:183]
		v_pk_add_f32 v[134:135], v[186:187], v[188:189]
		v_pk_add_f32 v[136:137], v[190:191], v[246:247]
		v_pk_add_f32 v[114:115], v[114:115], v[120:121]
		v_pk_add_f32 v[120:121], v[124:125], v[126:127]
		v_pk_add_f32 v[124:125], v[128:129], v[132:133]
		v_pk_add_f32 v[126:127], v[134:135], v[136:137]
		v_pk_add_f32 v[114:115], v[114:115], v[120:121]
		v_pk_add_f32 v[120:121], v[124:125], v[126:127]
		v_pk_add_f32 v[124:125], v[114:115], v[120:121]
		v_mov_b32_e32 v119, v125
		v_mov_b32_e32 v117, v124
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[114:115], v[116:117], v[118:119]
		v_mov_b32_e32 v116, v115
		v_mov_b32_e32 v117, v115
		v_cvt_pk_bf16_f32 v124, v166, v214
		v_cvt_pk_bf16_f32 v125, v138, v216
		v_permlane32_swap_b32_e32 v116, v117
		v_add_f32_e32 v119, v116, v117
		v_mov_b32_e32 v116, v6
		v_mov_b32_e32 v117, v9
		v_pk_add_f32 v[120:121], v[116:117], v[168:169] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v116, v120
		v_exp_f32_e32 v117, v121
		v_cvt_pk_bf16_f32 v126, v170, v218
		v_pk_mul_f32 v[32:33], v[32:33], v[116:117] op_sel_hi:[1,0]
		v_pk_mul_f32 v[34:35], v[34:35], v[116:117] op_sel_hi:[1,0]
		v_pk_mul_f32 v[36:37], v[36:37], v[116:117] op_sel_hi:[1,0]
		v_pk_mul_f32 v[38:39], v[38:39], v[116:117] op_sel_hi:[1,0]
		v_pk_mul_f32 v[40:41], v[40:41], v[116:117] op_sel_hi:[1,0]
		v_pk_mul_f32 v[42:43], v[42:43], v[116:117] op_sel_hi:[1,0]
		v_pk_mul_f32 v[44:45], v[44:45], v[116:117] op_sel_hi:[1,0]
		v_pk_mul_f32 v[46:47], v[46:47], v[116:117] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[48:49], v[116:117] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[50:51], v[116:117] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[52:53], v[116:117] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[54:55], v[116:117] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[56:57], v[116:117] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[58:59], v[116:117] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[60:61], v[116:117] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[62:63], v[116:117] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[64:65], v[116:117] op_sel:[0,1]
		v_pk_mul_f32 v[66:67], v[66:67], v[116:117] op_sel:[0,1]
		v_pk_mul_f32 v[68:69], v[68:69], v[116:117] op_sel:[0,1]
		v_pk_mul_f32 v[70:71], v[70:71], v[116:117] op_sel:[0,1]
		v_pk_mul_f32 v[72:73], v[72:73], v[116:117] op_sel:[0,1]
		v_pk_mul_f32 v[74:75], v[74:75], v[116:117] op_sel:[0,1]
		v_pk_mul_f32 v[76:77], v[76:77], v[116:117] op_sel:[0,1]
		v_pk_mul_f32 v[78:79], v[78:79], v[116:117] op_sel:[0,1]
		v_pk_mul_f32 v[80:81], v[80:81], v[116:117] op_sel:[0,1]
		v_pk_mul_f32 v[82:83], v[82:83], v[116:117] op_sel:[0,1]
		v_pk_mul_f32 v[84:85], v[84:85], v[116:117] op_sel:[0,1]
		v_pk_mul_f32 v[86:87], v[86:87], v[116:117] op_sel:[0,1]
		v_pk_mul_f32 v[88:89], v[88:89], v[116:117] op_sel:[0,1]
		v_pk_mul_f32 v[90:91], v[90:91], v[116:117] op_sel:[0,1]
		v_pk_mul_f32 v[92:93], v[92:93], v[116:117] op_sel:[0,1]
		v_pk_mul_f32 v[94:95], v[94:95], v[116:117] op_sel:[0,1]
		v_mov_b32_e32 v118, v114
		v_mov_b64_e32 v[114:115], v[14:15]
		v_pk_fma_f32 v[14:15], v[114:115], v[116:117], v[118:119]
		v_cvt_pk_bf16_f32 v127, v172, v220
		v_cvt_pk_bf16_f32 v116, v96, v222
		v_cvt_pk_bf16_f32 v117, v174, v224
		v_cvt_pk_bf16_f32 v118, v18, v226
		v_cvt_pk_bf16_f32 v119, v176, v228
		v_cvt_pk_bf16_f32 v132, v102, v230
		v_cvt_pk_bf16_f32 v133, v194, v232
		v_cvt_pk_bf16_f32 v134, v108, v234
		v_cvt_pk_bf16_f32 v135, v196, v236
		v_cvt_pk_bf16_f32 v160, v178, v238
		v_cvt_pk_bf16_f32 v161, v198, v240
		v_cvt_pk_bf16_f32 v162, v184, v242
		v_cvt_pk_bf16_f32 v163, v200, v244
		v_cvt_pk_bf16_f32 v180, v167, v215
		v_cvt_pk_bf16_f32 v181, v139, v217
		v_cvt_pk_bf16_f32 v182, v171, v219
		v_cvt_pk_bf16_f32 v183, v173, v221
		v_cvt_pk_bf16_f32 v136, v97, v223
		v_cvt_pk_bf16_f32 v137, v175, v225
		v_cvt_pk_bf16_f32 v138, v19, v227
		v_cvt_pk_bf16_f32 v139, v177, v229
		v_cvt_pk_bf16_f32 v172, v103, v231
		v_cvt_pk_bf16_f32 v173, v195, v233
		v_cvt_pk_bf16_f32 v174, v109, v235
		v_cvt_pk_bf16_f32 v175, v197, v237
		v_cvt_pk_bf16_f32 v188, v179, v239
		v_cvt_pk_bf16_f32 v189, v199, v241
		v_cvt_pk_bf16_f32 v190, v185, v243
		v_cvt_pk_bf16_f32 v191, v201, v245
		v_cvt_pk_bf16_f32 v176, v122, v130
		v_cvt_pk_bf16_f32 v177, v142, v144
		v_cvt_pk_bf16_f32 v178, v140, v146
		v_cvt_pk_bf16_f32 v179, v10, v148
		v_cvt_pk_bf16_f32 v184, v30, v150
		v_cvt_pk_bf16_f32 v185, v152, v154
		v_cvt_pk_bf16_f32 v186, v16, v156
		v_cvt_pk_bf16_f32 v187, v98, v158
		v_cvt_pk_bf16_f32 v196, v24, v164
		v_cvt_pk_bf16_f32 v197, v100, v192
		v_cvt_pk_bf16_f32 v198, v26, v202
		v_cvt_pk_bf16_f32 v199, v104, v204
		v_cvt_pk_bf16_f32 v216, v28, v206
		v_cvt_pk_bf16_f32 v217, v106, v208
		v_cvt_pk_bf16_f32 v218, v110, v210
		v_cvt_pk_bf16_f32 v219, v112, v212
		v_cvt_pk_bf16_f32 v220, v123, v131
		v_cvt_pk_bf16_f32 v221, v143, v145
		v_cvt_pk_bf16_f32 v222, v141, v147
		v_cvt_pk_bf16_f32 v223, v11, v149
		v_cvt_pk_bf16_f32 v120, v31, v151
		v_cvt_pk_bf16_f32 v121, v153, v155
		v_cvt_pk_bf16_f32 v122, v17, v157
		v_cvt_pk_bf16_f32 v123, v99, v159
		v_cvt_pk_bf16_f32 v16, v25, v165
		v_cvt_pk_bf16_f32 v17, v101, v193
		v_cvt_pk_bf16_f32 v18, v27, v203
		v_cvt_pk_bf16_f32 v19, v105, v205
		v_cvt_pk_bf16_f32 v24, v29, v207
		v_cvt_pk_bf16_f32 v25, v107, v209
		v_cvt_pk_bf16_f32 v26, v111, v211
		v_cvt_pk_bf16_f32 v27, v113, v213
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_permlane32_swap_b32_e32 v160, v162
		v_permlane32_swap_b32_e32 v161, v163
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_permlane32_swap_b32_e32 v172, v174
		v_permlane32_swap_b32_e32 v173, v175
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_permlane32_swap_b32_e32 v176, v178
		v_permlane32_swap_b32_e32 v177, v179
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_permlane32_swap_b32_e32 v216, v218
		v_permlane32_swap_b32_e32 v217, v219
		v_permlane32_swap_b32_e32 v220, v222
		v_permlane32_swap_b32_e32 v221, v223
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[124:127], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[124:127], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[176:179], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[176:179], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[116:119], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[116:119], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[184:187], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[184:187], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[132:135], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[132:135], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[196:199], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[196:199], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[160:163], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[160:163], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[216:219], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[216:219], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[180:183], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[180:183], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[220:223], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[220:223], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[136:139], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[136:139], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[120:123], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[120:123], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[216:219], v[172:175], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[248:251], v[172:175], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[248:251], v[16:19], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[216:219], v[16:19], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[220:223], v[188:191], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[252:255], v[188:191], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[252:255], v[24:27], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[220:223], v[24:27], v[64:79]
		s_mov_b32 s44, s1
		v_mov_b32_e32 v6, v168
		v_mov_b32_e32 v9, v169
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_2
.L_attn_fwd_persistent.loop_exit_2:
		s_mov_b32 s24, s8
		s_mov_b32 s25, s9
		s_mov_b32 s26, s38
		s_mov_b32 s27, s39
		v_rcp_f32_e32 v2, v14
		v_rcp_f32_e32 v4, v15
		v_mov_b32_e32 v3, v2
		v_pk_mul_f32 v[6:7], v[32:33], v[2:3]
		v_pk_mul_f32 v[8:9], v[34:35], v[2:3]
		v_pk_mul_f32 v[10:11], v[36:37], v[2:3]
		v_pk_mul_f32 v[12:13], v[38:39], v[2:3]
		v_pk_mul_f32 v[14:15], v[40:41], v[2:3]
		v_pk_mul_f32 v[16:17], v[42:43], v[2:3]
		v_pk_mul_f32 v[18:19], v[44:45], v[2:3]
		v_pk_mul_f32 v[20:21], v[46:47], v[2:3]
		v_pk_mul_f32 v[24:25], v[48:49], v[2:3]
		v_pk_mul_f32 v[26:27], v[50:51], v[2:3]
		v_pk_mul_f32 v[28:29], v[52:53], v[2:3]
		v_pk_mul_f32 v[30:31], v[54:55], v[2:3]
		v_pk_mul_f32 v[32:33], v[56:57], v[2:3]
		v_pk_mul_f32 v[34:35], v[58:59], v[2:3]
		v_pk_mul_f32 v[36:37], v[60:61], v[2:3]
		v_pk_mul_f32 v[38:39], v[62:63], v[2:3]
		v_mov_b32_e32 v5, v4
		v_pk_mul_f32 v[2:3], v[64:65], v[4:5]
		v_pk_mul_f32 v[40:41], v[66:67], v[4:5]
		v_pk_mul_f32 v[42:43], v[68:69], v[4:5]
		v_pk_mul_f32 v[44:45], v[70:71], v[4:5]
		v_pk_mul_f32 v[46:47], v[72:73], v[4:5]
		v_pk_mul_f32 v[48:49], v[74:75], v[4:5]
		v_pk_mul_f32 v[50:51], v[76:77], v[4:5]
		v_pk_mul_f32 v[52:53], v[78:79], v[4:5]
		v_pk_mul_f32 v[54:55], v[80:81], v[4:5]
		v_pk_mul_f32 v[56:57], v[82:83], v[4:5]
		v_pk_mul_f32 v[58:59], v[84:85], v[4:5]
		v_pk_mul_f32 v[60:61], v[86:87], v[4:5]
		v_pk_mul_f32 v[62:63], v[88:89], v[4:5]
		v_pk_mul_f32 v[64:65], v[90:91], v[4:5]
		v_pk_mul_f32 v[66:67], v[92:93], v[4:5]
		v_pk_mul_f32 v[68:69], v[94:95], v[4:5]
		v_cvt_pk_bf16_f32 v72, v6, v7
		v_cvt_pk_bf16_f32 v73, v8, v9
		v_cvt_pk_bf16_f32 v74, v10, v11
		v_cvt_pk_bf16_f32 v75, v12, v13
		v_cvt_pk_bf16_f32 v4, v14, v15
		v_cvt_pk_bf16_f32 v5, v16, v17
		v_cvt_pk_bf16_f32 v6, v18, v19
		v_cvt_pk_bf16_f32 v7, v20, v21
		v_cvt_pk_bf16_f32 v8, v24, v25
		v_cvt_pk_bf16_f32 v9, v26, v27
		v_cvt_pk_bf16_f32 v10, v28, v29
		v_cvt_pk_bf16_f32 v11, v30, v31
		v_cvt_pk_bf16_f32 v12, v32, v33
		v_cvt_pk_bf16_f32 v13, v34, v35
		v_cvt_pk_bf16_f32 v14, v36, v37
		v_cvt_pk_bf16_f32 v15, v38, v39
		v_cvt_pk_bf16_f32 v16, v2, v3
		v_cvt_pk_bf16_f32 v17, v40, v41
		v_cvt_pk_bf16_f32 v18, v42, v43
		v_cvt_pk_bf16_f32 v19, v44, v45
		v_cvt_pk_bf16_f32 v24, v46, v47
		v_cvt_pk_bf16_f32 v25, v48, v49
		v_cvt_pk_bf16_f32 v26, v50, v51
		v_cvt_pk_bf16_f32 v27, v52, v53
		v_cvt_pk_bf16_f32 v28, v54, v55
		v_cvt_pk_bf16_f32 v29, v56, v57
		v_cvt_pk_bf16_f32 v30, v58, v59
		v_cvt_pk_bf16_f32 v31, v60, v61
		v_cvt_pk_bf16_f32 v32, v62, v63
		v_cvt_pk_bf16_f32 v33, v64, v65
		v_cvt_pk_bf16_f32 v34, v66, v67
		v_cvt_pk_bf16_f32 v35, v68, v69
		v_permlane32_swap_b32_e32 v72, v74
		v_permlane32_swap_b32_e32 v73, v75
		v_permlane32_swap_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v5, v7
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
		v_permlane32_swap_b32_e32 v12, v14
		v_permlane32_swap_b32_e32 v13, v15
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_permlane32_swap_b32_e32 v32, v34
		v_permlane32_swap_b32_e32 v33, v35
		v_accvgpr_read_b32 v2, a11
		s_nop 0
		v_readfirstlane_b32 s1, v2
		s_mul_i32 s1, s1, s18
		s_lshl_b32 s1, s1, 9
		v_accvgpr_read_b32 v2, a2
		s_nop 0
		v_readfirstlane_b32 s19, v2
		v_readfirstlane_b32 s22, v1
		s_mul_i32 s19, s22, s19
		s_lshl_b32 s19, s19, 1
		s_add_i32 s22, s1, s19
		v_accvgpr_read_b32 v2, a3
		s_nop 0
		v_readfirstlane_b32 s23, v2
		v_accvgpr_read_b32 v2, a10
		s_nop 0
		v_readfirstlane_b32 s28, v2
		s_mul_i32 s23, s28, s23
		s_lshl_b32 s23, s23, 1
		s_add_i32 s22, s22, s23
		v_accvgpr_read_b32 v2, a12
		v_mul_lo_u32 v2, s18, v2
		v_lshl_add_u32 v3, v2, 6, s22
		v_accvgpr_read_b32 v20, a15
		v_mul_lo_u32 v20, s18, v20
		v_lshl_add_u32 v3, v20, 1, v3
		v_accvgpr_read_b32 v21, a19
		v_mul_lo_u32 v21, s18, v21
		v_lshl_add_u32 v3, v21, 5, v3
		v_accvgpr_read_b32 v36, a23
		v_mul_lo_u32 v36, s18, v36
		v_lshl_add_u32 v3, v36, 4, v3
		v_accvgpr_read_b32 v37, a16
		v_mul_lo_u32 v37, s18, v37
		v_lshl_add_u32 v3, v37, 3, v3
		v_accvgpr_read_b32 v38, a17
		v_mul_lo_u32 v38, s18, v38
		v_lshl_add_u32 v3, v38, 2, v3
		v_accvgpr_read_b32 v39, a18
		v_lshl_add_u32 v3, v39, 4, v3
		v_mov_b32_e32 v40, s42
		v_mov_b32_e32 v41, s43
		s_nop 0
		v_readfirstlane_b32 s28, v40
		v_readfirstlane_b32 s29, v41
		s_and_saveexec_b64 s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_8
		buffer_store_dwordx4 v[72:75], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_8:
		s_andn2_b64 exec, s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_8
.L_attn_fwd_persistent.exec_endif_8:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s22, s1, 32
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s23
		v_lshl_add_u32 v3, v2, 6, s22
		v_lshl_add_u32 v3, v20, 1, v3
		v_lshl_add_u32 v3, v21, 5, v3
		v_lshl_add_u32 v3, v36, 4, v3
		v_lshl_add_u32 v3, v37, 3, v3
		v_lshl_add_u32 v3, v38, 2, v3
		v_accvgpr_read_b32 v39, a18
		v_lshl_add_u32 v3, v39, 4, v3
		v_readfirstlane_b32 s28, v40
		v_readfirstlane_b32 s29, v41
		s_and_saveexec_b64 s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_9
		buffer_store_dwordx4 v[4:7], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_9:
		s_andn2_b64 exec, s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_9
.L_attn_fwd_persistent.exec_endif_9:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s22, s1, 64
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s23
		v_lshl_add_u32 v3, v2, 6, s22
		v_lshl_add_u32 v3, v20, 1, v3
		v_lshl_add_u32 v3, v21, 5, v3
		v_lshl_add_u32 v3, v36, 4, v3
		v_lshl_add_u32 v3, v37, 3, v3
		v_lshl_add_u32 v3, v38, 2, v3
		v_accvgpr_read_b32 v4, a18
		v_lshl_add_u32 v3, v4, 4, v3
		v_readfirstlane_b32 s28, v40
		v_readfirstlane_b32 s29, v41
		s_and_saveexec_b64 s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_10
		buffer_store_dwordx4 v[8:11], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_10:
		s_andn2_b64 exec, s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_10
.L_attn_fwd_persistent.exec_endif_10:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s22, s1, 0x60
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s23
		v_lshl_add_u32 v3, v2, 6, s22
		v_lshl_add_u32 v3, v20, 1, v3
		v_lshl_add_u32 v3, v21, 5, v3
		v_lshl_add_u32 v3, v36, 4, v3
		v_lshl_add_u32 v3, v37, 3, v3
		v_lshl_add_u32 v3, v38, 2, v3
		v_accvgpr_read_b32 v4, a18
		v_lshl_add_u32 v3, v4, 4, v3
		v_readfirstlane_b32 s28, v40
		v_readfirstlane_b32 s29, v41
		s_and_saveexec_b64 s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_11
		buffer_store_dwordx4 v[12:15], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_11:
		s_andn2_b64 exec, s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_11
.L_attn_fwd_persistent.exec_endif_11:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s22, s18, 8
		s_add_i32 s28, s22, s1
		s_add_i32 s28, s28, s19
		s_add_i32 s28, s28, s23
		v_lshl_add_u32 v3, v2, 6, s28
		v_lshl_add_u32 v3, v20, 1, v3
		v_lshl_add_u32 v3, v21, 5, v3
		v_lshl_add_u32 v3, v36, 4, v3
		v_lshl_add_u32 v3, v37, 3, v3
		v_lshl_add_u32 v3, v38, 2, v3
		v_accvgpr_read_b32 v4, a18
		v_lshl_add_u32 v3, v4, 4, v3
		v_readfirstlane_b32 s28, v22
		v_readfirstlane_b32 s29, v23
		s_and_saveexec_b64 s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_12
		buffer_store_dwordx4 v[16:19], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_12:
		s_andn2_b64 exec, s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_12
.L_attn_fwd_persistent.exec_endif_12:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s28, s22, 32
		s_add_i32 s28, s28, s1
		s_add_i32 s28, s28, s19
		s_add_i32 s28, s28, s23
		v_lshl_add_u32 v3, v2, 6, s28
		v_lshl_add_u32 v3, v20, 1, v3
		v_lshl_add_u32 v3, v21, 5, v3
		v_lshl_add_u32 v3, v36, 4, v3
		v_lshl_add_u32 v3, v37, 3, v3
		v_lshl_add_u32 v3, v38, 2, v3
		v_accvgpr_read_b32 v4, a18
		v_lshl_add_u32 v3, v4, 4, v3
		v_readfirstlane_b32 s28, v22
		v_readfirstlane_b32 s29, v23
		s_and_saveexec_b64 s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_13
		buffer_store_dwordx4 v[24:27], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_13:
		s_andn2_b64 exec, s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_13
.L_attn_fwd_persistent.exec_endif_13:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s28, s22, 64
		s_add_i32 s28, s28, s1
		s_add_i32 s28, s28, s19
		s_add_i32 s28, s28, s23
		v_lshl_add_u32 v3, v2, 6, s28
		v_lshl_add_u32 v3, v20, 1, v3
		v_lshl_add_u32 v3, v21, 5, v3
		v_lshl_add_u32 v3, v36, 4, v3
		v_lshl_add_u32 v3, v37, 3, v3
		v_lshl_add_u32 v3, v38, 2, v3
		v_accvgpr_read_b32 v4, a18
		v_lshl_add_u32 v3, v4, 4, v3
		v_readfirstlane_b32 s28, v22
		v_readfirstlane_b32 s29, v23
		s_and_saveexec_b64 s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_14
		buffer_store_dwordx4 v[28:31], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_14:
		s_andn2_b64 exec, s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_14
.L_attn_fwd_persistent.exec_endif_14:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s22, s22, 0x60
		s_add_i32 s1, s22, s1
		s_add_i32 s1, s1, s19
		s_add_i32 s1, s1, s23
		v_lshl_add_u32 v2, v2, 6, s1
		v_lshl_add_u32 v2, v20, 1, v2
		v_lshl_add_u32 v2, v21, 5, v2
		v_lshl_add_u32 v2, v36, 4, v2
		v_lshl_add_u32 v2, v37, 3, v2
		v_lshl_add_u32 v2, v38, 2, v2
		v_accvgpr_read_b32 v3, a18
		v_lshl_add_u32 v2, v3, 4, v2
		v_readfirstlane_b32 s22, v22
		v_readfirstlane_b32 s23, v23
		s_and_saveexec_b64 s[100:101], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_15
		buffer_store_dwordx4 v[32:35], v2, s[24:27], 0 offen
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
		s_lshr_b32 s19, s1, 1
		s_and_b32 s1, s1, 1
		s_xor_b32 s22, s19, -1
		s_add_i32 s22, s22, 1
		s_add_i32 s22, s22, 31
		s_cmp_eq_u32 s1, 0
		s_cselect_b32 s1, s19, s22
		v_mov_b32_e32 v2, s1
		v_accvgpr_write_b32 a11, v2
		v_accvgpr_read_b32 v2, a11
		s_nop 0
		v_readfirstlane_b32 s1, v2
		s_mul_i32 s1, s1, 0x100
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
		v_xad_u32 v10, v10, v15, s1
		v_bitop3_b32 v17, 32, v9, v2 bitop3:0x96
		v_bitop3_b32 v17, v17, v7, v13 bitop3:0x96
		v_xad_u32 v17, v17, v15, s1
		v_bitop3_b32 v18, 64, v9, v2 bitop3:0x96
		v_bitop3_b32 v18, v18, v7, v13 bitop3:0x96
		v_xad_u32 v18, v18, v15, s1
		v_xor_b32_e32 v19, 0x60, v9
		v_xor_b32_e32 v19, v19, v2
		v_xor_b32_e32 v19, v19, v7
		v_xor_b32_e32 v19, v19, v13
		v_xad_u32 v19, v19, v15, s1
		v_xor_b32_e32 v20, 0x80, v9
		v_xor_b32_e32 v20, v20, v2
		v_xor_b32_e32 v20, v20, v7
		v_xor_b32_e32 v20, v20, v13
		v_xad_u32 v20, v20, v15, s1
		v_xor_b32_e32 v21, 0xa0, v9
		v_xor_b32_e32 v21, v21, v2
		v_xor_b32_e32 v21, v21, v7
		v_xor_b32_e32 v21, v21, v13
		v_xad_u32 v21, v21, v15, s1
		v_xor_b32_e32 v22, 0xc0, v9
		v_xor_b32_e32 v22, v22, v2
		v_xor_b32_e32 v22, v22, v7
		v_xor_b32_e32 v22, v22, v13
		v_xad_u32 v22, v22, v15, s1
		v_xor_b32_e32 v23, 0xe0, v9
		v_xor_b32_e32 v2, v23, v2
		v_xor_b32_e32 v2, v2, v7
		v_xor_b32_e32 v2, v2, v13
		v_xad_u32 v2, v2, v15, s1
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
		v_readfirstlane_b32 s19, v10
		s_mul_i32 s19, s19, s12
		s_lshl_b32 s19, s19, 9
		v_readfirstlane_b32 s40, v1
		s_mul_i32 s40, s40, s10
		s_lshl_b32 s40, s40, 1
		s_add_i32 s41, s19, s40
		v_accvgpr_read_b32 v10, a10
		s_nop 0
		v_readfirstlane_b32 s42, v10
		s_mul_i32 s42, s42, s11
		s_lshl_b32 s42, s42, 1
		s_add_i32 s41, s41, s42
		v_mul_lo_u32 v10, s12, v8
		v_lshl_add_u32 v13, v10, 1, s41
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
		s_and_saveexec_b64 s[100:101], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_16
		buffer_load_dwordx4 v[24:27], v3, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_16:
		s_andn2_b64 exec, s[100:101], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_16
		v_mov_b32_e32 v24, v20
		v_mov_b32_e32 v25, v21
		v_mov_b32_e32 v26, v22
		v_mov_b32_e32 v27, v23
.L_attn_fwd_persistent.exec_endif_16:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s22, s12, 6
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s40
		s_add_i32 s22, s22, s42
		v_lshl_add_u32 v3, v10, 1, s22
		v_accvgpr_read_b32 v13, a15
		v_lshl_add_u32 v3, v13, 4, v3
		v_accvgpr_read_b32 v13, a16
		v_lshl_add_u32 v3, v13, 6, v3
		v_accvgpr_read_b32 v13, a17
		v_lshl_add_u32 v3, v13, 5, v3
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_17
		buffer_load_dwordx4 v[28:31], v3, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_17:
		s_andn2_b64 exec, s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_17
		v_mov_b32_e32 v28, v20
		v_mov_b32_e32 v29, v21
		v_mov_b32_e32 v30, v22
		v_mov_b32_e32 v31, v23
.L_attn_fwd_persistent.exec_endif_17:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s22, s12, 7
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s40
		s_add_i32 s22, s22, s42
		v_lshl_add_u32 v3, v10, 1, s22
		v_accvgpr_read_b32 v13, a15
		v_lshl_add_u32 v3, v13, 4, v3
		v_accvgpr_read_b32 v13, a16
		v_lshl_add_u32 v3, v13, 6, v3
		v_accvgpr_read_b32 v13, a17
		v_lshl_add_u32 v3, v13, 5, v3
		s_and_saveexec_b64 s[100:101], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_18
		buffer_load_dwordx4 v[32:35], v3, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_18:
		s_andn2_b64 exec, s[100:101], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_18
		v_mov_b32_e32 v32, v20
		v_mov_b32_e32 v33, v21
		v_mov_b32_e32 v34, v22
		v_mov_b32_e32 v35, v23
.L_attn_fwd_persistent.exec_endif_18:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s22, 0xc0, s12
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s40
		s_add_i32 s22, s22, s42
		v_lshl_add_u32 v3, v10, 1, s22
		v_accvgpr_read_b32 v13, a15
		v_lshl_add_u32 v3, v13, 4, v3
		v_accvgpr_read_b32 v13, a16
		v_lshl_add_u32 v3, v13, 6, v3
		v_accvgpr_read_b32 v13, a17
		v_lshl_add_u32 v3, v13, 5, v3
		s_and_saveexec_b64 s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_19
		buffer_load_dwordx4 v[36:39], v3, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_19:
		s_andn2_b64 exec, s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_19
		v_mov_b32_e32 v36, v20
		v_mov_b32_e32 v37, v21
		v_mov_b32_e32 v38, v22
		v_mov_b32_e32 v39, v23
.L_attn_fwd_persistent.exec_endif_19:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s22, s12, 8
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s40
		s_add_i32 s22, s22, s42
		v_lshl_add_u32 v3, v10, 1, s22
		v_accvgpr_read_b32 v13, a15
		v_lshl_add_u32 v3, v13, 4, v3
		v_accvgpr_read_b32 v13, a16
		v_lshl_add_u32 v3, v13, 6, v3
		v_accvgpr_read_b32 v13, a17
		v_lshl_add_u32 v3, v13, 5, v3
		s_and_saveexec_b64 s[100:101], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_20
		buffer_load_dwordx4 v[40:43], v3, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_20:
		s_andn2_b64 exec, s[100:101], s[30:31]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_20
		v_mov_b32_e32 v40, v20
		v_mov_b32_e32 v41, v21
		v_mov_b32_e32 v42, v22
		v_mov_b32_e32 v43, v23
.L_attn_fwd_persistent.exec_endif_20:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s22, 0x140, s12
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s40
		s_add_i32 s22, s22, s42
		v_lshl_add_u32 v3, v10, 1, s22
		v_accvgpr_read_b32 v13, a15
		v_lshl_add_u32 v3, v13, 4, v3
		v_accvgpr_read_b32 v13, a16
		v_lshl_add_u32 v3, v13, 6, v3
		v_accvgpr_read_b32 v13, a17
		v_lshl_add_u32 v3, v13, 5, v3
		s_and_saveexec_b64 s[100:101], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_21
		buffer_load_dwordx4 v[44:47], v3, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_21:
		s_andn2_b64 exec, s[100:101], s[32:33]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_21
		v_mov_b32_e32 v44, v20
		v_mov_b32_e32 v45, v21
		v_mov_b32_e32 v46, v22
		v_mov_b32_e32 v47, v23
.L_attn_fwd_persistent.exec_endif_21:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s22, 0x180, s12
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s40
		s_add_i32 s22, s22, s42
		v_lshl_add_u32 v3, v10, 1, s22
		v_accvgpr_read_b32 v13, a15
		v_lshl_add_u32 v3, v13, 4, v3
		v_accvgpr_read_b32 v13, a16
		v_lshl_add_u32 v3, v13, 6, v3
		v_accvgpr_read_b32 v13, a17
		v_lshl_add_u32 v3, v13, 5, v3
		s_and_saveexec_b64 s[100:101], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_22
		buffer_load_dwordx4 v[48:51], v3, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_22:
		s_andn2_b64 exec, s[100:101], s[34:35]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_22
		v_mov_b32_e32 v48, v20
		v_mov_b32_e32 v49, v21
		v_mov_b32_e32 v50, v22
		v_mov_b32_e32 v51, v23
.L_attn_fwd_persistent.exec_endif_22:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s22, 0x1c0, s12
		s_add_i32 s19, s22, s19
		s_add_i32 s19, s19, s40
		s_add_i32 s19, s19, s42
		v_lshl_add_u32 v3, v10, 1, s19
		v_accvgpr_read_b32 v10, a15
		v_lshl_add_u32 v3, v10, 4, v3
		v_accvgpr_read_b32 v10, a16
		v_lshl_add_u32 v3, v10, 6, v3
		v_accvgpr_read_b32 v10, a17
		v_lshl_add_u32 v3, v10, 5, v3
		v_cmp_lt_i32_e64 vcc, v2, s20
		s_and_saveexec_b64 s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_23
		buffer_load_dwordx4 v[52:55], v3, s[36:39], 0 offen
.L_attn_fwd_persistent.exec_else_23:
		s_andn2_b64 exec, s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_23
		v_mov_b32_e32 v52, v20
		v_mov_b32_e32 v53, v21
		v_mov_b32_e32 v54, v22
		v_mov_b32_e32 v55, v23
.L_attn_fwd_persistent.exec_endif_23:
		s_mov_b64 exec, s[100:101]
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
		ds_write_b128 v2, v[24:27] offset:18864
		ds_write_b128 v2, v[28:31] offset:22960
		ds_write_b128 v2, v[32:35] offset:27056
		ds_write_b128 v2, v[36:39] offset:31152
		v_accvgpr_read_b32 v3, a12
		v_lshlrev_b32_e32 v3, 12, v3
		v_add_u32_e32 v3, 0x10000, v3
		v_and_b32_e32 v5, 63, v0
		v_lshrrev_b32_e32 v10, 5, v5
		v_accvgpr_write_b32 a20, v10
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshrrev_b32_e32 v10, 4, v5
		v_and_b32_e32 v10, 1, v10
		v_lshlrev_b32_e32 v10, 7, v10
		v_accvgpr_read_b32 v11, a20
		v_add_u32_e32 v11, v11, v10
		v_lshrrev_b32_e32 v13, 3, v5
		v_and_b32_e32 v13, 1, v13
		v_lshlrev_b32_e32 v15, 6, v13
		v_lshrrev_b32_e32 v17, 2, v5
		v_and_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v18, 5, v17
		v_add3_u32 v11, v11, v15, v18
		v_lshrrev_b32_e32 v19, 1, v5
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v20, 4, v19
		v_and_b32_e32 v21, 1, v5
		v_lshlrev_b32_e32 v21, 3, v21
		v_add3_u32 v11, v11, v20, v21
		v_lshlrev_b32_e32 v17, 1, v17
		v_lshlrev_b32_e32 v13, 2, v13
		v_bitop3_b32 v13, v17, v13, v19 bitop3:0x96
		v_xor_b32_e32 v11, v11, v13
		v_lshl_add_u32 v11, v11, 4, v3
		ds_read_b128 a[24:27], v11 offset:18864
		v_accvgpr_read_b32 v17, a20
		v_add3_u32 v10, v17, v10, v15
		v_add3_u32 v10, v10, v18, v20
		v_add3_u32 v15, v21, v10, 2
		v_xor_b32_e32 v15, v15, v13
		v_lshl_add_u32 v15, v15, 4, v3
		ds_read_b128 a[28:31], v15 offset:18864
		v_add3_u32 v17, v21, v10, 4
		v_xor_b32_e32 v17, v17, v13
		v_lshl_add_u32 v17, v17, 4, v3
		ds_read_b128 a[32:35], v17 offset:18864
		v_add3_u32 v10, v21, v10, 6
		v_xor_b32_e32 v10, v10, v13
		v_lshl_add_u32 v3, v10, 4, v3
		ds_read_b128 a[36:39], v3 offset:18864
		v_accvgpr_read_b32 v10, a11
		s_nop 0
		v_readfirstlane_b32 s19, v10
		s_add_i32 s19, s19, 1
		s_mul_i32 s19, s19, 0x100
		s_mov_b32 s22, 0x7f
		v_mov_b32_e32 v10, 64
		v_mul_lo_u32 v10, v10, v9
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[40:43] offset:18864
		ds_write_b128 v2, v[44:47] offset:22960
		ds_write_b128 v2, v[48:51] offset:27056
		ds_write_b128 v2, v[52:55] offset:31152
		v_mov_b32_e32 v2, 32
		v_mul_lo_u32 v2, v2, v12
		v_mov_b32_e32 v12, 16
		v_mul_lo_u32 v12, v12, v6
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[40:43], v11 offset:18864
		ds_read_b128 a[44:47], v15 offset:18864
		ds_read_b128 a[48:51], v17 offset:18864
		ds_read_b128 a[52:55], v3 offset:18864
		v_accvgpr_read_b32 v3, a5
		s_nop 0
		v_readfirstlane_b32 s23, v3
		s_add_i32 s19, s19, s23
		s_cmp_lt_i32 s21, s19
		s_cselect_b32 s19, s21, s19
		s_add_i32 s23, s19, 0x7f
		s_cmp_lt_i32 s23, 0
		s_cselect_b32 s32, s22, 0
		s_add_i32 s23, s23, s32
		s_ashr_i32 s23, s23, 7
		v_accvgpr_read_b32 v3, a5
		s_nop 0
		v_readfirstlane_b32 s32, v3
		s_add_i32 s32, s1, s32
		s_cmp_lt_i32 s32, 0
		s_cselect_b32 s33, s22, 0
		s_add_i32 s32, s32, s33
		s_ashr_i32 s32, s32, 7
		s_cmp_lt_i32 s32, s23
		s_cselect_b32 s32, s32, s23
		s_cmp_gt_i32 s32, 0
		s_cselect_b32 s32, s32, 0
		v_bitop3_b32 v3, v10, v2, v12 bitop3:0x96
		v_mov_b32_e32 v11, 2
		v_mul_lo_u32 v11, v11, v16
		v_bitop3_b32 v3, v3, v14, v11 bitop3:0x96
		v_accvgpr_write_b32 a21, v3
		v_bitop3_b32 v3, 4, v10, v2 bitop3:0x96
		v_bitop3_b32 v13, 8, v10, v2 bitop3:0x96
		v_bitop3_b32 v10, 12, v10, v2 bitop3:0x96
		v_accvgpr_read_b32 v15, a21
		v_cmp_lt_i32_e64 s[34:35], v15, s21
		v_mov_b32_e32 v15, 16
		v_mul_lo_u32 v15, v15, v9
		v_mov_b32_e32 v9, 64
		v_mul_lo_u32 v9, v9, v6
		v_bitop3_b32 v6, v15, v2, v9 bitop3:0x96
		v_bitop3_b32 v6, v6, v14, v11 bitop3:0x96
		v_accvgpr_write_b32 a22, v6
		v_bitop3_b32 v6, 4, v15, v2 bitop3:0x96
		v_bitop3_b32 v16, 8, v15, v2 bitop3:0x96
		v_bitop3_b32 v2, 12, v15, v2 bitop3:0x96
		v_accvgpr_read_b32 v15, a22
		v_cmp_lt_i32_e64 vcc, v15, s21
		v_readfirstlane_b32 s36, v0
		v_accvgpr_read_b32 v15, a12
		v_mul_lo_u32 v15, s15, v15
		v_accvgpr_read_b32 v17, a18
		v_mul_lo_u32 v17, s15, v17
		v_lshlrev_b32_e32 v17, 5, v17
		v_lshl_add_u32 v15, v15, 1, v17
		v_accvgpr_read_b32 v17, a19
		v_mul_lo_u32 v17, s15, v17
		v_lshl_add_u32 v15, v17, 6, v15
		v_and_b32_e32 v8, 1, v8
		v_accvgpr_write_b32 a23, v8
		v_accvgpr_read_b32 v8, a23
		v_mul_lo_u32 v8, s15, v8
		v_lshlrev_b32_e32 v8, 7, v8
		v_accvgpr_read_b32 v17, a15
		v_lshlrev_b32_e32 v17, 4, v17
		v_add3_u32 v8, v15, v8, v17
		v_accvgpr_read_b32 v15, a16
		v_lshlrev_b32_e32 v15, 6, v15
		v_accvgpr_read_b32 v18, a17
		v_lshlrev_b32_e32 v18, 5, v18
		v_add3_u32 v8, v8, v15, v18
		v_readfirstlane_b32 s33, v1
		s_mul_i32 s33, s33, s13
		s_lshl_b32 s33, s33, 1
		v_accvgpr_read_b32 v19, a10
		s_nop 0
		v_readfirstlane_b32 s37, v19
		s_mul_i32 s37, s37, s14
		s_lshl_b32 s37, s37, 1
		s_add_i32 s40, s33, s37
		v_add_u32_e32 v19, s40, v8
		v_mov_b32_e32 v20, 0x80000000
		v_cndmask_b32_e64 v19, v20, v19, s[34:35]
		s_lshr_b32 s40, s36, 6
		s_mul_i32 s41, 0x410, s40
		s_mov_b32 m0, s41
		v_accvgpr_read_b32 v21, a13
		v_add_u32_e32 v21, s1, v21
		buffer_load_dwordx4 v19, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[42:43], v21, s20
		s_nop 1
		v_mov_b32_e32 v22, s42
		v_mov_b32_e32 v23, s43
		s_lshl_b32 s42, s15, 3
		s_add_i32 s42, s42, s33
		s_add_i32 s42, s42, s37
		v_add_u32_e32 v19, s42, v8
		v_cndmask_b32_e64 v19, v20, v19, s[34:35]
		s_add_i32 m0, m0, 0x1040
		v_accvgpr_read_b32 v21, a14
		v_add_u32_e32 v21, s1, v21
		buffer_load_dwordx4 v19, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[42:43], v21, s20
		s_nop 1
		v_mov_b32_e32 v24, s42
		v_mov_b32_e32 v25, s43
		s_lshl_b32 s42, s15, 4
		s_add_i32 s42, s42, s33
		s_add_i32 s42, s42, s37
		v_add_u32_e32 v19, s42, v8
		v_cndmask_b32_e64 v19, v20, v19, s[34:35]
		s_add_i32 m0, m0, 0x1040
		v_xor_b32_e32 v3, v3, v12
		buffer_load_dwordx4 v19, s[24:27], 0 offen lds
		v_bitop3_b32 v3, v3, v14, v11 bitop3:0x96
		v_accvgpr_write_b32 a56, v3
		s_mul_i32 s42, 24, s15
		s_add_i32 s42, s42, s33
		s_add_i32 s42, s42, s37
		v_add_u32_e32 v3, s42, v8
		v_cndmask_b32_e64 v3, v20, v3, s[34:35]
		s_add_i32 m0, m0, 0x1040
		v_xor_b32_e32 v13, v13, v12
		buffer_load_dwordx4 v3, s[24:27], 0 offen lds
		v_bitop3_b32 v3, v13, v14, v11 bitop3:0x96
		v_accvgpr_write_b32 a57, v3
		v_accvgpr_read_b32 v3, a12
		v_mul_lo_u32 v3, s17, v3
		v_accvgpr_read_b32 v13, a18
		v_mul_lo_u32 v13, s17, v13
		v_lshlrev_b32_e32 v13, 7, v13
		v_lshl_add_u32 v3, v3, 1, v13
		v_accvgpr_read_b32 v13, a19
		v_mul_lo_u32 v13, s17, v13
		v_lshl_add_u32 v3, v13, 6, v3
		v_accvgpr_read_b32 v13, a23
		v_mul_lo_u32 v13, s17, v13
		v_lshlrev_b32_e32 v13, 5, v13
		v_add3_u32 v3, v3, v13, v17
		v_add3_u32 v3, v3, v15, v18
		v_accvgpr_read_b32 v13, a0
		s_nop 0
		v_readfirstlane_b32 s34, v13
		v_readfirstlane_b32 s35, v1
		s_mul_i32 s34, s35, s34
		s_lshl_b32 s34, s34, 1
		v_accvgpr_read_b32 v13, a1
		s_nop 0
		v_readfirstlane_b32 s35, v13
		v_accvgpr_read_b32 v13, a10
		s_nop 0
		v_readfirstlane_b32 s42, v13
		s_mul_i32 s35, s42, s35
		s_lshl_b32 s35, s35, 1
		s_add_i32 s42, s34, s35
		v_add_u32_e32 v13, s42, v3
		v_cndmask_b32_e32 v13, v20, v13, vcc
		s_mul_i32 s40, 0x440, s40
		s_add_i32 m0, s40, 0x81f0
		v_xor_b32_e32 v10, v10, v12
		buffer_load_dwordx4 v13, s[28:31], 0 offen lds
		v_bitop3_b32 v10, v10, v14, v11 bitop3:0x96
		v_accvgpr_write_b32 a58, v10
		s_lshl_b32 s42, s17, 3
		s_add_i32 s42, s42, s34
		s_add_i32 s42, s42, s35
		v_add_u32_e32 v10, s42, v3
		v_cndmask_b32_e32 v10, v20, v10, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v6, v6, v9
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		v_bitop3_b32 v6, v6, v14, v11 bitop3:0x96
		v_accvgpr_write_b32 a59, v6
		s_lshl_b32 s42, s17, 4
		s_add_i32 s42, s42, s34
		s_add_i32 s42, s42, s35
		v_add_u32_e32 v6, s42, v3
		v_cndmask_b32_e32 v6, v20, v6, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v10, v16, v9
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_bitop3_b32 v6, v10, v14, v11 bitop3:0x96
		v_accvgpr_write_b32 a60, v6
		s_mul_i32 s42, 24, s17
		s_add_i32 s42, s42, s34
		s_add_i32 s42, s42, s35
		v_add_u32_e32 v6, s42, v3
		v_cndmask_b32_e32 v6, v20, v6, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v2, v2, v9
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		v_bitop3_b32 v2, v2, v14, v11 bitop3:0x96
		v_accvgpr_write_b32 a61, v2
		s_mul_i32 s42, s32, 0x80
		v_mbcnt_lo_u32_b32 v2, -1, 0
		v_mbcnt_hi_u32_b32 v2, -1, v2
		v_and_b32_e32 v6, 1, v2
		v_lshrrev_b32_e32 v9, 4, v2
		v_and_b32_e32 v9, 1, v9
		v_lshlrev_b32_e32 v9, 4, v9
		v_lshrrev_b32_e32 v10, 3, v2
		v_and_b32_e32 v10, 1, v10
		v_lshlrev_b32_e32 v10, 3, v10
		v_add3_u32 v11, v6, v9, v10
		v_lshrrev_b32_e32 v12, 2, v2
		v_and_b32_e32 v12, 1, v12
		v_lshlrev_b32_e32 v12, 2, v12
		v_lshrrev_b32_e32 v2, 1, v2
		v_and_b32_e32 v2, 1, v2
		v_lshlrev_b32_e32 v2, 1, v2
		v_add3_u32 v11, v11, v12, v2
		v_add_u32_e32 v6, 32, v6
		v_bitop3_b32 v9, v12, v10, v9 bitop3:0x96
		v_bitop3_b32 v2, v6, v2, v9 bitop3:0x96
		v_mov_b32_e32 v12, 0x3e38aa3b
		v_mov_b32_e32 v13, 0x3e38aa3b
		s_mov_b32 s32, 0xff800000
		v_mov_b32_e32 v6, s32
		v_mov_b32_e32 v9, s32
		s_mov_b32 s32, 1.0
		v_mov_b32_e32 v14, s32
		v_mov_b32_e32 v15, s32
		s_mov_b32 s32, 0
		v_accvgpr_read_b32 v10, a20
		v_lshlrev_b32_e32 v10, 4, v10
		v_accvgpr_write_b32 a62, v10
		v_and_b32_e32 v5, 31, v5
		v_lshrrev_b32_e32 v10, 4, v5
		v_lshlrev_b32_e32 v10, 9, v10
		v_accvgpr_write_b32 a63, v10
		v_lshrrev_b32_e32 v10, 3, v5
		v_and_b32_e32 v10, 1, v10
		v_mov_b32_e32 v16, 0x2080
		v_mul_lo_u32 v16, v16, v10
		v_accvgpr_write_b32 a64, v16
		v_lshrrev_b32_e32 v10, 2, v5
		v_and_b32_e32 v10, 1, v10
		v_mov_b32_e32 v16, 0x1040
		v_mul_lo_u32 v16, v16, v10
		v_accvgpr_write_b32 a65, v16
		v_lshrrev_b32_e32 v10, 1, v5
		v_and_b32_e32 v10, 1, v10
		v_mov_b32_e32 v16, 0x820
		v_mul_lo_u32 v16, v16, v10
		v_accvgpr_write_b32 a66, v16
		v_and_b32_e32 v5, 1, v5
		v_mov_b32_e32 v10, 0x410
		v_mul_lo_u32 v10, v10, v5
		v_accvgpr_write_b32 a67, v10
		v_and_b32_e32 v5, 3, v0
		v_accvgpr_write_b32 a68, v5
		v_accvgpr_read_b32 v5, a68
		v_lshlrev_b32_e32 v5, 3, v5
		v_accvgpr_write_b32 a69, v5
		v_accvgpr_read_b32 v5, a18
		v_mov_b32_e32 v10, 0x2200
		v_mul_lo_u32 v10, v10, v5
		v_accvgpr_write_b32 a70, v10
		v_accvgpr_read_b32 v5, a19
		v_lshlrev_b32_e32 v5, 5, v5
		v_accvgpr_write_b32 a71, v5
		v_and_b32_e32 v4, 3, v4
		v_mov_b32_e32 v5, 0x440
		v_mul_lo_u32 v5, v5, v4
		v_accvgpr_write_b32 a72, v5
		s_lshl_b32 s43, s15, 8
		s_add_i32 s43, s43, s33
		s_add_i32 s43, s43, s37
		s_mul_i32 s44, 0x108, s15
		s_add_i32 s44, s44, s33
		s_add_i32 s44, s44, s37
		s_mul_i32 s45, 0x110, s15
		s_add_i32 s45, s45, s33
		s_add_i32 s45, s45, s37
		s_mul_i32 s46, 0x118, s15
		s_add_i32 s33, s46, s33
		s_add_i32 s33, s33, s37
		s_lshl_b32 s37, s17, 8
		s_add_i32 s37, s37, s34
		s_add_i32 s46, s37, s35
		s_mul_i32 s37, 0x108, s17
		s_add_i32 s37, s37, s34
		s_add_i32 s47, s37, s35
		s_mul_i32 s37, 0x110, s17
		s_add_i32 s37, s37, s34
		s_add_i32 s48, s37, s35
		s_mul_i32 s37, 0x118, s17
		s_add_i32 s34, s37, s34
		s_add_i32 s34, s34, s35
		v_lshlrev_b32_e32 v4, 2, v11
		v_accvgpr_write_b32 a73, v4
		v_lshlrev_b32_e32 v2, 2, v2
		v_accvgpr_write_b32 a74, v2
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
		s_lshr_b32 s35, s32, 7
		s_and_b32 s37, s35, 1
		s_mul_i32 s49, 0x4100, s37
		v_accvgpr_read_b32 v2, a62
		v_accvgpr_read_b32 v4, a63
		v_add3_u32 v2, s49, v2, v4
		v_accvgpr_read_b32 v4, a64
		v_accvgpr_read_b32 v5, a65
		v_add3_u32 v2, v2, v4, v5
		v_accvgpr_read_b32 v4, a66
		v_accvgpr_read_b32 v5, a67
		v_add3_u32 v2, v2, v4, v5
		ds_read_b128 v[16:19], v2
		ds_read_b128 a[76:79], v2 offset:32
		ds_read_b128 a[80:83], v2 offset:64
		ds_read_b128 a[84:87], v2 offset:96
		ds_read_b128 v[28:31], v2 offset:256
		ds_read_b128 a[88:91], v2 offset:288
		ds_read_b128 a[92:95], v2 offset:320
		ds_read_b128 a[96:99], v2 offset:352
		ds_read_b128 v[96:99], v2 offset:128
		ds_read_b128 a[100:103], v2 offset:160
		ds_read_b128 a[104:107], v2 offset:192
		ds_read_b128 a[108:111], v2 offset:224
		ds_read_b128 v[100:103], v2 offset:384
		ds_read_b128 a[112:115], v2 offset:416
		ds_read_b128 a[116:119], v2 offset:448
		ds_read_b128 a[120:123], v2 offset:480
		s_mul_i32 s37, 0x4400, s37
		v_accvgpr_read_b32 v2, a69
		v_accvgpr_read_b32 v4, a70
		v_add3_u32 v2, s37, v2, v4
		v_accvgpr_read_b32 v4, a71
		v_accvgpr_read_b32 v5, a72
		v_add3_u32 v2, v2, v4, v5
		ds_read_b64_tr_b16 a[124:125], v2 offset:33264
		ds_read_b64_tr_b16 a[126:127], v2 offset:37616
		ds_read_b64_tr_b16 a[128:129], v2 offset:33392
		ds_read_b64_tr_b16 a[130:131], v2 offset:37744
		ds_read_b64_tr_b16 a[132:133], v2 offset:33520
		ds_read_b64_tr_b16 a[134:135], v2 offset:37872
		ds_read_b64_tr_b16 a[136:137], v2 offset:33648
		ds_read_b64_tr_b16 a[138:139], v2 offset:38000
		ds_read_b64_tr_b16 a[140:141], v2 offset:33776
		ds_read_b64_tr_b16 a[142:143], v2 offset:38128
		ds_read_b64_tr_b16 a[144:145], v2 offset:33904
		ds_read_b64_tr_b16 a[146:147], v2 offset:38256
		ds_read_b64_tr_b16 a[148:149], v2 offset:34032
		ds_read_b64_tr_b16 a[150:151], v2 offset:38384
		ds_read_b64_tr_b16 a[152:153], v2 offset:34160
		ds_read_b64_tr_b16 a[154:155], v2 offset:38512
		ds_read_b64_tr_b16 a[156:157], v2 offset:33328
		ds_read_b64_tr_b16 a[158:159], v2 offset:37680
		ds_read_b64_tr_b16 a[160:161], v2 offset:33456
		ds_read_b64_tr_b16 a[162:163], v2 offset:37808
		ds_read_b64_tr_b16 a[164:165], v2 offset:33584
		ds_read_b64_tr_b16 a[166:167], v2 offset:37936
		ds_read_b64_tr_b16 a[168:169], v2 offset:33712
		ds_read_b64_tr_b16 a[170:171], v2 offset:38064
		ds_read_b64_tr_b16 a[172:173], v2 offset:33840
		ds_read_b64_tr_b16 a[174:175], v2 offset:38192
		ds_read_b64_tr_b16 a[176:177], v2 offset:33968
		ds_read_b64_tr_b16 a[178:179], v2 offset:38320
		ds_read_b64_tr_b16 a[180:181], v2 offset:34096
		ds_read_b64_tr_b16 a[182:183], v2 offset:38448
		ds_read_b64_tr_b16 a[184:185], v2 offset:34224
		ds_read_b64_tr_b16 a[186:187], v2 offset:38576
		s_mul_i32 s37, s15, s32
		s_lshl_b32 s37, s37, 1
		s_add_i32 s49, s43, s37
		v_add_u32_e32 v2, s49, v8
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v4, s37, v8
		s_add_i32 s35, s35, 1
		v_add_u32_e32 v5, s44, v4
		s_and_b32 s35, s35, 1
		v_add_u32_e32 v10, s45, v4
		s_mul_i32 s37, 0x4100, s35
		v_add_u32_e32 v4, s33, v4
		s_add_i32 s37, s41, s37
		v_mfma_f32_32x32x16_bf16 v[112:127], v[16:19], a[24:27], 0
		s_mov_b32 m0, s37
		v_mfma_f32_32x32x16_bf16 v[128:143], v[28:31], a[24:27], 0
		s_mul_i32 s37, s17, s32
		v_mfma_f32_32x32x16_bf16 v[144:159], v[96:99], a[24:27], 0
		s_add_i32 s32, s32, 0x80
		v_mfma_f32_32x32x16_bf16 v[160:175], v[100:103], a[24:27], 0
		v_accvgpr_read_b32 v11, a21
		v_add_u32_e32 v11, s32, v11
		v_mfma_f32_32x32x16_bf16 v[176:191], v[100:103], a[40:43], 0
		v_accvgpr_read_b32 v21, a56
		v_add_u32_e32 v21, s32, v21
		v_mfma_f32_32x32x16_bf16 v[192:207], v[16:19], a[40:43], 0
		v_accvgpr_read_b32 v16, a57
		v_add_u32_e32 v16, s32, v16
		v_mfma_f32_32x32x16_bf16 v[208:223], v[28:31], a[40:43], 0
		v_accvgpr_read_b32 v17, a58
		v_add_u32_e32 v17, s32, v17
		v_mfma_f32_32x32x16_bf16 v[224:239], v[96:99], a[40:43], 0
		v_cmp_lt_i32_e64 s[50:51], v11, s21
		v_mfma_f32_32x32x16_bf16 v[112:127], a[76:79], a[28:31], v[112:127]
		v_accvgpr_read_b32 v11, a22
		v_add_u32_e32 v11, s32, v11
		v_mfma_f32_32x32x16_bf16 v[128:143], a[88:91], a[28:31], v[128:143]
		v_accvgpr_read_b32 v18, a59
		v_add_u32_e32 v18, s32, v18
		v_mfma_f32_32x32x16_bf16 v[144:159], a[100:103], a[28:31], v[144:159]
		v_accvgpr_read_b32 v19, a60
		v_add_u32_e32 v19, s32, v19
		v_mfma_f32_32x32x16_bf16 v[160:175], a[112:115], a[28:31], v[160:175]
		v_cmp_lt_i32_e64 s[52:53], v11, s21
		v_mfma_f32_32x32x16_bf16 v[176:191], a[112:115], a[44:47], v[176:191]
		v_cndmask_b32_e64 v2, v20, v2, s[50:51]
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[192:207], a[76:79], a[44:47], v[192:207]
		v_cmp_lt_i32_e64 s[50:51], v21, s21
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[54:55], v16, s21
		v_mfma_f32_32x32x16_bf16 v[208:223], a[88:91], a[44:47], v[208:223]
		v_cndmask_b32_e64 v2, v20, v5, s[50:51]
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], a[100:103], a[44:47], v[224:239]
		v_cndmask_b32_e64 v2, v20, v10, s[54:55]
		v_cmp_lt_i32_e64 s[50:51], v17, s21
		s_add_i32 m0, m0, 0x1040
		v_accvgpr_read_b32 v5, a61
		v_add_u32_e32 v5, s32, v5
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[112:127], a[80:83], a[32:35], v[112:127]
		v_cndmask_b32_e64 v2, v20, v4, s[50:51]
		v_cmp_lt_i32_e64 s[50:51], v18, s21
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s37, s37, 1
		buffer_load_dwordx4 v2, s[24:27], 0 offen lds
		v_add_u32_e32 v2, s37, v3
		s_add_i32 s37, s46, s37
		v_mfma_f32_32x32x16_bf16 v[128:143], a[92:95], a[32:35], v[128:143]
		v_add_u32_e32 v4, s37, v3
		v_mfma_f32_32x32x16_bf16 v[144:159], a[104:107], a[32:35], v[144:159]
		v_cndmask_b32_e64 v4, v20, v4, s[52:53]
		v_add_u32_e32 v10, s47, v2
		s_mul_i32 s35, 0x4400, s35
		v_cndmask_b32_e64 v10, v20, v10, s[50:51]
		s_add_i32 s35, s40, s35
		v_cmp_lt_i32_e64 s[50:51], v19, s21
		s_add_i32 m0, s35, 0x81f0
		v_add_u32_e32 v11, s48, v2
		buffer_load_dwordx4 v4, s[28:31], 0 offen lds
		v_cndmask_b32_e64 v4, v20, v11, s[50:51]
		v_cmp_lt_i32_e64 vcc, v5, s21
		s_add_i32 m0, m0, 0x1100
		v_add_u32_e32 v2, s34, v2
		v_cndmask_b32_e32 v2, v20, v2, vcc
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[160:175], a[116:119], a[32:35], v[160:175]
		s_add_i32 m0, m0, 0x1100
		v_mfma_f32_32x32x16_bf16 v[176:191], a[116:119], a[48:51], v[176:191]
		buffer_load_dwordx4 v4, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[192:207], a[80:83], a[48:51], v[192:207]
		s_add_i32 m0, m0, 0x1100
		s_cmp_lt_i32 s32, s42
		v_mfma_f32_32x32x16_bf16 v[208:223], a[92:95], a[48:51], v[208:223]
		buffer_load_dwordx4 v2, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], a[104:107], a[48:51], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[84:87], a[36:39], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[96:99], a[36:39], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[108:111], a[36:39], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[120:123], a[36:39], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[120:123], a[52:55], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[84:87], a[52:55], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[96:99], a[52:55], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[108:111], a[52:55], v[224:239]
		s_nop 4
		v_max3_f32 v2, v112, v113, v114
		v_max3_f32 v4, v116, v117, v118
		v_max3_f32 v5, v120, v121, v122
		v_max3_f32 v10, v124, v125, v126
		v_max3_f32 v11, v128, v129, v130
		v_max3_f32 v16, v132, v133, v134
		v_max3_f32 v17, v136, v137, v138
		v_max3_f32 v18, v140, v141, v142
		v_max3_f32 v19, v144, v145, v146
		v_max3_f32 v21, v148, v149, v150
		v_max3_f32 v26, v152, v153, v154
		v_max3_f32 v27, v156, v157, v158
		v_max3_f32 v28, v160, v161, v162
		v_max3_f32 v29, v164, v165, v166
		v_max3_f32 v30, v168, v169, v170
		v_max3_f32 v31, v172, v173, v174
		v_max3_f32 v2, v2, v115, v4
		v_max3_f32 v4, v5, v123, v10
		v_max3_f32 v5, v11, v131, v16
		v_max3_f32 v10, v17, v139, v18
		v_max3_f32 v11, v19, v147, v21
		v_max3_f32 v16, v26, v155, v27
		v_max3_f32 v17, v28, v163, v29
		v_max3_f32 v18, v30, v171, v31
		v_max3_f32 v2, v2, v119, v4
		v_max3_f32 v4, v5, v135, v10
		v_max3_f32 v5, v11, v151, v16
		v_max3_f32 v10, v17, v167, v18
		v_max3_f32 v2, v2, v127, v4
		v_max3_f32 v4, v5, v159, v10
		v_max3_f32 v2, v2, v143, v4
		v_max_f32_e32 v4, v2, v175
		v_mov_b32_e32 v5, v4
		v_max3_f32 v2, v192, v193, v194
		v_max3_f32 v10, v196, v197, v198
		v_max3_f32 v11, v200, v201, v202
		v_max3_f32 v16, v204, v205, v206
		v_max3_f32 v17, v208, v209, v210
		v_max3_f32 v18, v212, v213, v214
		v_max3_f32 v19, v216, v217, v218
		v_max3_f32 v21, v220, v221, v222
		v_max3_f32 v26, v224, v225, v226
		v_max3_f32 v27, v228, v229, v230
		v_max3_f32 v28, v232, v233, v234
		v_max3_f32 v29, v236, v237, v238
		v_max3_f32 v30, v176, v177, v178
		v_max3_f32 v31, v180, v181, v182
		v_max3_f32 v96, v184, v185, v186
		v_max3_f32 v97, v188, v189, v190
		v_permlane32_swap_b32_e32 v4, v5
		v_max3_f32 v2, v2, v195, v10
		v_max3_f32 v10, v11, v203, v16
		v_max3_f32 v11, v17, v211, v18
		v_max3_f32 v16, v19, v219, v21
		v_max3_f32 v17, v26, v227, v27
		v_max3_f32 v18, v28, v235, v29
		v_max3_f32 v19, v30, v179, v31
		v_max3_f32 v21, v96, v187, v97
		v_max3_f32 v2, v2, v199, v10
		v_max3_f32 v10, v11, v215, v16
		v_max3_f32 v11, v17, v231, v18
		v_max3_f32 v16, v19, v183, v21
		v_max3_f32 v2, v2, v207, v10
		v_max3_f32 v10, v11, v239, v16
		v_max3_f32 v2, v2, v223, v10
		v_max_f32_e32 v10, v2, v191
		v_mov_b32_e32 v11, v10
		v_max_f32_e32 v16, v4, v5
		v_mov_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v10, v11
		v_max_f32_e32 v17, v10, v11
		v_pk_mul_f32 v[10:11], v[16:17], v[12:13]
		v_max_f32_e32 v16, v6, v10
		v_max_f32_e32 v17, v9, v11
		v_pk_fma_f32 v[10:11], v[112:113], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[18:19], v[114:115], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[116:117], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[118:119], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[120:121], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[122:123], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[124:125], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[126:127], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[128:129], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[130:131], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[132:133], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[134:135], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[136:137], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[138:139], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[140:141], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[142:143], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[144:145], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[146:147], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[148:149], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[150:151], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[152:153], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[154:155], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[156:157], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[158:159], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[160:161], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[162:163], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[164:165], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[166:167], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[168:169], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[170:171], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[172:173], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[174:175], v[12:13], v[16:17] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[192:193], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[194:195], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[196:197], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[198:199], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[200:201], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[202:203], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[204:205], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[206:207], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[208:209], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[210:211], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[212:213], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[214:215], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[216:217], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[218:219], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[220:221], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[222:223], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[224:225], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[226:227], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[228:229], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[230:231], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[232:233], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[234:235], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[236:237], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[238:239], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[176:177], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[178:179], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[180:181], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[182:183], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[184:185], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[186:187], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[188:189], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[190:191], v[12:13], v[16:17] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v190, v10
		v_exp_f32_e32 v216, v11
		v_exp_f32_e32 v10, v18
		v_exp_f32_e32 v218, v19
		v_exp_f32_e32 v18, v26
		v_exp_f32_e32 v220, v27
		v_exp_f32_e32 v26, v28
		v_exp_f32_e32 v222, v29
		v_exp_f32_e32 v28, v30
		v_exp_f32_e32 v224, v31
		v_exp_f32_e32 v30, v96
		v_exp_f32_e32 v226, v97
		v_exp_f32_e32 v96, v98
		v_exp_f32_e32 v228, v99
		v_exp_f32_e32 v98, v100
		v_exp_f32_e32 v230, v101
		v_exp_f32_e32 v100, v102
		v_exp_f32_e32 v232, v103
		v_exp_f32_e32 v102, v104
		v_exp_f32_e32 v234, v105
		v_exp_f32_e32 v104, v106
		v_exp_f32_e32 v236, v107
		v_exp_f32_e32 v106, v108
		v_exp_f32_e32 v238, v109
		v_exp_f32_e32 v108, v110
		v_exp_f32_e32 v240, v111
		v_exp_f32_e32 v110, v112
		v_exp_f32_e32 v242, v113
		v_exp_f32_e32 v112, v114
		v_exp_f32_e32 v244, v115
		v_exp_f32_e32 v114, v116
		v_exp_f32_e32 v246, v117
		v_exp_f32_e32 v191, v118
		v_exp_f32_e32 v217, v119
		v_exp_f32_e32 v11, v120
		v_exp_f32_e32 v219, v121
		v_exp_f32_e32 v19, v122
		v_exp_f32_e32 v221, v123
		v_exp_f32_e32 v27, v124
		v_exp_f32_e32 v223, v125
		v_exp_f32_e32 v29, v126
		v_exp_f32_e32 v225, v127
		v_exp_f32_e32 v31, v128
		v_exp_f32_e32 v227, v129
		v_exp_f32_e32 v97, v130
		v_exp_f32_e32 v229, v131
		v_exp_f32_e32 v99, v132
		v_exp_f32_e32 v231, v133
		v_exp_f32_e32 v101, v134
		v_exp_f32_e32 v233, v135
		v_exp_f32_e32 v103, v136
		v_exp_f32_e32 v235, v137
		v_exp_f32_e32 v105, v138
		v_exp_f32_e32 v237, v139
		v_exp_f32_e32 v107, v140
		v_exp_f32_e32 v239, v141
		v_exp_f32_e32 v109, v142
		v_exp_f32_e32 v241, v143
		v_exp_f32_e32 v111, v144
		v_exp_f32_e32 v243, v145
		v_exp_f32_e32 v113, v146
		v_exp_f32_e32 v245, v147
		v_exp_f32_e32 v115, v148
		v_exp_f32_e32 v247, v149
		v_exp_f32_e32 v116, v150
		v_exp_f32_e32 v118, v151
		v_exp_f32_e32 v120, v152
		v_exp_f32_e32 v122, v153
		v_exp_f32_e32 v124, v154
		v_exp_f32_e32 v126, v155
		v_exp_f32_e32 v128, v156
		v_exp_f32_e32 v130, v157
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
		v_exp_f32_e32 v168, v192
		v_exp_f32_e32 v170, v193
		v_exp_f32_e32 v172, v194
		v_exp_f32_e32 v174, v195
		v_exp_f32_e32 v192, v196
		v_exp_f32_e32 v194, v197
		v_exp_f32_e32 v117, v198
		v_exp_f32_e32 v119, v199
		v_exp_f32_e32 v121, v200
		v_exp_f32_e32 v123, v201
		v_exp_f32_e32 v125, v202
		v_exp_f32_e32 v127, v203
		v_exp_f32_e32 v129, v204
		v_exp_f32_e32 v131, v205
		v_exp_f32_e32 v133, v206
		v_exp_f32_e32 v135, v207
		v_exp_f32_e32 v137, v208
		v_exp_f32_e32 v139, v209
		v_exp_f32_e32 v141, v210
		v_exp_f32_e32 v143, v211
		v_exp_f32_e32 v145, v212
		v_exp_f32_e32 v147, v213
		v_exp_f32_e32 v149, v214
		v_exp_f32_e32 v151, v215
		v_exp_f32_e32 v153, v176
		v_exp_f32_e32 v155, v177
		v_exp_f32_e32 v157, v178
		v_exp_f32_e32 v159, v179
		v_exp_f32_e32 v161, v180
		v_exp_f32_e32 v163, v181
		v_exp_f32_e32 v165, v182
		v_exp_f32_e32 v167, v183
		v_exp_f32_e32 v169, v184
		v_exp_f32_e32 v171, v185
		v_exp_f32_e32 v173, v186
		v_exp_f32_e32 v175, v187
		v_exp_f32_e32 v193, v188
		v_exp_f32_e32 v195, v189
		v_pk_add_f32 v[176:177], v[190:191], v[216:217]
		v_pk_add_f32 v[178:179], v[10:11], v[218:219]
		v_pk_add_f32 v[180:181], v[18:19], v[220:221]
		v_pk_add_f32 v[182:183], v[26:27], v[222:223]
		v_pk_add_f32 v[184:185], v[28:29], v[224:225]
		v_pk_add_f32 v[186:187], v[30:31], v[226:227]
		v_pk_add_f32 v[188:189], v[96:97], v[228:229]
		v_pk_add_f32 v[196:197], v[98:99], v[230:231]
		v_pk_add_f32 v[198:199], v[100:101], v[232:233]
		v_pk_add_f32 v[200:201], v[102:103], v[234:235]
		v_pk_add_f32 v[202:203], v[104:105], v[236:237]
		v_pk_add_f32 v[204:205], v[106:107], v[238:239]
		v_pk_add_f32 v[206:207], v[108:109], v[240:241]
		v_pk_add_f32 v[208:209], v[110:111], v[242:243]
		v_pk_add_f32 v[210:211], v[112:113], v[244:245]
		v_pk_add_f32 v[212:213], v[114:115], v[246:247]
		v_pk_add_f32 v[176:177], v[176:177], v[178:179]
		v_pk_add_f32 v[178:179], v[180:181], v[182:183]
		v_pk_add_f32 v[180:181], v[184:185], v[186:187]
		v_pk_add_f32 v[182:183], v[188:189], v[196:197]
		v_pk_add_f32 v[184:185], v[198:199], v[200:201]
		v_pk_add_f32 v[186:187], v[202:203], v[204:205]
		v_pk_add_f32 v[188:189], v[206:207], v[208:209]
		v_pk_add_f32 v[196:197], v[210:211], v[212:213]
		v_pk_add_f32 v[176:177], v[176:177], v[178:179]
		v_pk_add_f32 v[178:179], v[180:181], v[182:183]
		v_pk_add_f32 v[180:181], v[184:185], v[186:187]
		v_pk_add_f32 v[182:183], v[188:189], v[196:197]
		v_pk_add_f32 v[176:177], v[176:177], v[178:179]
		v_pk_add_f32 v[178:179], v[180:181], v[182:183]
		v_pk_add_f32 v[180:181], v[176:177], v[178:179]
		v_add_f32_e32 v2, v180, v181
		v_accvgpr_read_b32 v5, a73
		ds_bpermute_b32 v176, v5, v2
		v_accvgpr_read_b32 v5, a74
		ds_bpermute_b32 v178, v5, v2
		v_pk_add_f32 v[180:181], v[116:117], v[118:119]
		v_pk_add_f32 v[182:183], v[120:121], v[122:123]
		v_pk_add_f32 v[184:185], v[124:125], v[126:127]
		v_pk_add_f32 v[186:187], v[128:129], v[130:131]
		v_pk_add_f32 v[188:189], v[132:133], v[134:135]
		v_pk_add_f32 v[196:197], v[136:137], v[138:139]
		v_pk_add_f32 v[198:199], v[140:141], v[142:143]
		v_pk_add_f32 v[200:201], v[144:145], v[146:147]
		v_pk_add_f32 v[202:203], v[148:149], v[150:151]
		v_pk_add_f32 v[204:205], v[152:153], v[154:155]
		v_pk_add_f32 v[206:207], v[156:157], v[158:159]
		v_pk_add_f32 v[208:209], v[160:161], v[162:163]
		v_pk_add_f32 v[210:211], v[164:165], v[166:167]
		v_pk_add_f32 v[212:213], v[168:169], v[170:171]
		v_pk_add_f32 v[214:215], v[172:173], v[174:175]
		v_pk_add_f32 v[248:249], v[192:193], v[194:195]
		v_pk_add_f32 v[180:181], v[180:181], v[182:183]
		v_pk_add_f32 v[182:183], v[184:185], v[186:187]
		v_pk_add_f32 v[184:185], v[188:189], v[196:197]
		v_pk_add_f32 v[186:187], v[198:199], v[200:201]
		v_pk_add_f32 v[188:189], v[202:203], v[204:205]
		v_pk_add_f32 v[196:197], v[206:207], v[208:209]
		v_pk_add_f32 v[198:199], v[210:211], v[212:213]
		v_pk_add_f32 v[200:201], v[214:215], v[248:249]
		v_pk_add_f32 v[180:181], v[180:181], v[182:183]
		v_pk_add_f32 v[182:183], v[184:185], v[186:187]
		v_pk_add_f32 v[184:185], v[188:189], v[196:197]
		v_pk_add_f32 v[186:187], v[198:199], v[200:201]
		v_pk_add_f32 v[180:181], v[180:181], v[182:183]
		v_pk_add_f32 v[182:183], v[184:185], v[186:187]
		v_pk_add_f32 v[184:185], v[180:181], v[182:183]
		v_mov_b32_e32 v179, v185
		v_mov_b32_e32 v177, v184
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[180:181], v[176:177], v[178:179]
		v_mov_b32_e32 v176, v181
		v_mov_b32_e32 v177, v181
		v_cvt_pk_bf16_f32 v184, v190, v216
		v_cvt_pk_bf16_f32 v185, v10, v218
		v_permlane32_swap_b32_e32 v176, v177
		v_add_f32_e32 v179, v176, v177
		v_mov_b32_e32 v5, v9
		v_pk_add_f32 v[176:177], v[4:5], v[16:17] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v4, v176
		v_exp_f32_e32 v5, v177
		v_cvt_pk_bf16_f32 v186, v18, v220
		v_pk_mul_f32 v[34:35], v[34:35], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[36:37], v[36:37], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[38:39], v[38:39], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[40:41], v[40:41], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[42:43], v[42:43], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[44:45], v[44:45], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[46:47], v[46:47], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[48:49], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[50:51], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[52:53], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[54:55], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[56:57], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[58:59], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[60:61], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[62:63], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[32:33], v[32:33], v[4:5] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[64:65], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[66:67], v[66:67], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[68:69], v[68:69], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[70:71], v[70:71], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[72:73], v[72:73], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[74:75], v[74:75], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[76:77], v[76:77], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[78:79], v[78:79], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[80:81], v[80:81], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[82:83], v[82:83], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[84:85], v[84:85], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[86:87], v[86:87], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[88:89], v[88:89], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[90:91], v[90:91], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[92:93], v[92:93], v[4:5] op_sel:[0,1]
		v_pk_mul_f32 v[94:95], v[94:95], v[4:5] op_sel:[0,1]
		v_mov_b32_e32 v178, v180
		v_mov_b64_e32 v[176:177], v[14:15]
		v_pk_fma_f32 v[14:15], v[176:177], v[4:5], v[178:179]
		v_cvt_pk_bf16_f32 v187, v26, v222
		v_cvt_pk_bf16_f32 v176, v28, v224
		v_cvt_pk_bf16_f32 v177, v30, v226
		v_cvt_pk_bf16_f32 v178, v96, v228
		v_cvt_pk_bf16_f32 v179, v98, v230
		v_cvt_pk_bf16_f32 v180, v100, v232
		v_cvt_pk_bf16_f32 v181, v102, v234
		v_cvt_pk_bf16_f32 v182, v104, v236
		v_cvt_pk_bf16_f32 v183, v106, v238
		v_cvt_pk_bf16_f32 v196, v108, v240
		v_cvt_pk_bf16_f32 v197, v110, v242
		v_cvt_pk_bf16_f32 v198, v112, v244
		v_cvt_pk_bf16_f32 v199, v114, v246
		v_cvt_pk_bf16_f32 v200, v191, v217
		v_cvt_pk_bf16_f32 v201, v11, v219
		v_cvt_pk_bf16_f32 v202, v19, v221
		v_cvt_pk_bf16_f32 v203, v27, v223
		v_cvt_pk_bf16_f32 v188, v29, v225
		v_cvt_pk_bf16_f32 v189, v31, v227
		v_cvt_pk_bf16_f32 v190, v97, v229
		v_cvt_pk_bf16_f32 v191, v99, v231
		v_cvt_pk_bf16_f32 v28, v101, v233
		v_cvt_pk_bf16_f32 v29, v103, v235
		v_cvt_pk_bf16_f32 v30, v105, v237
		v_cvt_pk_bf16_f32 v31, v107, v239
		v_cvt_pk_bf16_f32 v96, v109, v241
		v_cvt_pk_bf16_f32 v97, v111, v243
		v_cvt_pk_bf16_f32 v98, v113, v245
		v_cvt_pk_bf16_f32 v99, v115, v247
		v_cvt_pk_bf16_f32 v100, v116, v118
		v_cvt_pk_bf16_f32 v101, v120, v122
		v_cvt_pk_bf16_f32 v102, v124, v126
		v_cvt_pk_bf16_f32 v103, v128, v130
		v_cvt_pk_bf16_f32 v104, v132, v134
		v_cvt_pk_bf16_f32 v105, v136, v138
		v_cvt_pk_bf16_f32 v106, v140, v142
		v_cvt_pk_bf16_f32 v107, v144, v146
		v_cvt_pk_bf16_f32 v108, v148, v150
		v_cvt_pk_bf16_f32 v109, v152, v154
		v_cvt_pk_bf16_f32 v110, v156, v158
		v_cvt_pk_bf16_f32 v111, v160, v162
		v_cvt_pk_bf16_f32 v112, v164, v166
		v_cvt_pk_bf16_f32 v113, v168, v170
		v_cvt_pk_bf16_f32 v114, v172, v174
		v_cvt_pk_bf16_f32 v115, v192, v194
		v_cvt_pk_bf16_f32 v204, v117, v119
		v_cvt_pk_bf16_f32 v205, v121, v123
		v_cvt_pk_bf16_f32 v206, v125, v127
		v_cvt_pk_bf16_f32 v207, v129, v131
		v_cvt_pk_bf16_f32 v116, v133, v135
		v_cvt_pk_bf16_f32 v117, v137, v139
		v_cvt_pk_bf16_f32 v118, v141, v143
		v_cvt_pk_bf16_f32 v119, v145, v147
		v_cvt_pk_bf16_f32 v120, v149, v151
		v_cvt_pk_bf16_f32 v121, v153, v155
		v_cvt_pk_bf16_f32 v122, v157, v159
		v_cvt_pk_bf16_f32 v123, v161, v163
		v_cvt_pk_bf16_f32 v124, v165, v167
		v_cvt_pk_bf16_f32 v125, v169, v171
		v_cvt_pk_bf16_f32 v126, v173, v175
		v_cvt_pk_bf16_f32 v127, v193, v195
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_permlane32_swap_b32_e32 v176, v178
		v_permlane32_swap_b32_e32 v177, v179
		v_mfma_f32_32x32x16_bf16 v[32:47], a[124:127], v[184:187], v[32:47]
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		v_mfma_f32_32x32x16_bf16 v[48:63], a[156:159], v[184:187], v[48:63]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[32:47], a[128:131], v[176:179], v[32:47]
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_mfma_f32_32x32x16_bf16 v[48:63], a[160:163], v[176:179], v[48:63]
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[32:47], a[132:135], v[180:183], v[32:47]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[48:63], a[164:167], v[180:183], v[48:63]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[32:47], a[136:139], v[196:199], v[32:47]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[48:63], a[168:171], v[196:199], v[48:63]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], v[100:103], v[80:95]
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_mfma_f32_32x32x16_bf16 v[64:79], a[124:127], v[100:103], v[64:79]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[80:95], a[160:163], v[104:107], v[80:95]
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_mfma_f32_32x32x16_bf16 v[64:79], a[128:131], v[104:107], v[64:79]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[80:95], a[164:167], v[108:111], v[80:95]
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_mfma_f32_32x32x16_bf16 v[64:79], a[132:135], v[108:111], v[64:79]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[80:95], a[168:171], v[112:115], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[136:139], v[112:115], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[140:143], v[200:203], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[172:175], v[200:203], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[172:175], v[204:207], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[140:143], v[204:207], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[144:147], v[188:191], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[176:179], v[188:191], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[176:179], v[116:119], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[144:147], v[116:119], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[148:151], v[28:31], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[180:183], v[28:31], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[180:183], v[120:123], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[148:151], v[120:123], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[152:155], v[96:99], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[184:187], v[96:99], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[184:187], v[124:127], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[152:155], v[124:127], v[64:79]
		v_mov_b32_e32 v6, v16
		v_mov_b32_e32 v9, v17
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_3
.L_attn_fwd_persistent.loop_exit_3:
		s_mul_i32 s23, s23, 0x80
		v_accvgpr_read_b32 v2, a5
		s_nop 0
		v_readfirstlane_b32 s32, v2
		v_accvgpr_read_b32 v2, a13
		s_nop 0
		v_add_u32_e32 v2, s32, v2
		v_add_u32_e32 v2, s1, v2
		v_accvgpr_read_b32 v4, a5
		s_nop 0
		v_readfirstlane_b32 s32, v4
		v_accvgpr_read_b32 v4, a14
		s_nop 0
		v_add_u32_e32 v4, s32, v4
		v_add_u32_e32 v4, s1, v4
		v_xor_b32_e32 v5, 1, v7
		v_accvgpr_write_b32 a13, v5
		v_xor_b32_e32 v5, 2, v7
		v_accvgpr_write_b32 a14, v5
		v_xor_b32_e32 v5, 3, v7
		v_accvgpr_write_b32 a62, v5
		v_xor_b32_e32 v5, 8, v7
		v_accvgpr_write_b32 a69, v5
		v_xor_b32_e32 v5, 9, v7
		v_accvgpr_write_b32 a75, v5
		v_xor_b32_e32 v5, 10, v7
		v_accvgpr_write_b32 a76, v5
		v_xor_b32_e32 v5, 11, v7
		v_accvgpr_write_b32 a77, v5
		v_xor_b32_e32 v5, 16, v7
		v_accvgpr_write_b32 a78, v5
		v_xor_b32_e32 v5, 17, v7
		v_accvgpr_write_b32 a79, v5
		v_xor_b32_e32 v5, 18, v7
		v_accvgpr_write_b32 a80, v5
		v_xor_b32_e32 v5, 19, v7
		v_accvgpr_write_b32 a81, v5
		v_xor_b32_e32 v5, 24, v7
		v_accvgpr_write_b32 a82, v5
		v_xor_b32_e32 v5, 25, v7
		v_accvgpr_write_b32 a83, v5
		v_xor_b32_e32 v5, 26, v7
		v_accvgpr_write_b32 a84, v5
		v_xor_b32_e32 v5, 27, v7
		v_accvgpr_write_b32 a85, v5
		v_xor_b32_e32 v5, 32, v7
		v_accvgpr_write_b32 a86, v5
		v_xor_b32_e32 v5, 33, v7
		v_accvgpr_write_b32 a87, v5
		v_xor_b32_e32 v5, 34, v7
		v_accvgpr_write_b32 a88, v5
		v_xor_b32_e32 v5, 35, v7
		v_accvgpr_write_b32 a89, v5
		v_xor_b32_e32 v5, 40, v7
		v_accvgpr_write_b32 a90, v5
		v_xor_b32_e32 v5, 41, v7
		v_accvgpr_write_b32 a91, v5
		v_xor_b32_e32 v5, 42, v7
		v_accvgpr_write_b32 a92, v5
		v_xor_b32_e32 v5, 43, v7
		v_accvgpr_write_b32 a93, v5
		v_xor_b32_e32 v5, 48, v7
		v_accvgpr_write_b32 a94, v5
		v_xor_b32_e32 v5, 49, v7
		v_accvgpr_write_b32 a95, v5
		v_xor_b32_e32 v5, 50, v7
		v_accvgpr_write_b32 a96, v5
		v_xor_b32_e32 v5, 51, v7
		v_accvgpr_write_b32 a97, v5
		v_xor_b32_e32 v5, 56, v7
		v_accvgpr_write_b32 a98, v5
		v_xor_b32_e32 v5, 57, v7
		v_accvgpr_write_b32 a99, v5
		v_xor_b32_e32 v5, 58, v7
		v_accvgpr_write_b32 a100, v5
		v_xor_b32_e32 v5, 59, v7
		v_accvgpr_write_b32 a101, v5
		v_xor_b32_e32 v5, 64, v7
		v_accvgpr_write_b32 a102, v5
		v_xor_b32_e32 v5, 0x41, v7
		v_accvgpr_write_b32 a103, v5
		v_xor_b32_e32 v5, 0x42, v7
		v_accvgpr_write_b32 a104, v5
		v_xor_b32_e32 v5, 0x43, v7
		v_accvgpr_write_b32 a105, v5
		v_xor_b32_e32 v5, 0x48, v7
		v_accvgpr_write_b32 a106, v5
		v_xor_b32_e32 v5, 0x49, v7
		v_accvgpr_write_b32 a107, v5
		v_xor_b32_e32 v5, 0x4a, v7
		v_accvgpr_write_b32 a108, v5
		v_xor_b32_e32 v5, 0x4b, v7
		v_accvgpr_write_b32 a109, v5
		v_xor_b32_e32 v5, 0x50, v7
		v_accvgpr_write_b32 a110, v5
		v_xor_b32_e32 v5, 0x51, v7
		v_accvgpr_write_b32 a111, v5
		v_xor_b32_e32 v5, 0x52, v7
		v_accvgpr_write_b32 a112, v5
		v_xor_b32_e32 v5, 0x53, v7
		v_accvgpr_write_b32 a113, v5
		v_xor_b32_e32 v5, 0x58, v7
		v_accvgpr_write_b32 a114, v5
		v_xor_b32_e32 v5, 0x59, v7
		v_accvgpr_write_b32 a115, v5
		v_xor_b32_e32 v5, 0x5a, v7
		v_accvgpr_write_b32 a116, v5
		v_xor_b32_e32 v5, 0x5b, v7
		v_accvgpr_write_b32 a117, v5
		v_xor_b32_e32 v5, 0x60, v7
		v_accvgpr_write_b32 a118, v5
		v_xor_b32_e32 v5, 0x61, v7
		v_accvgpr_write_b32 a119, v5
		v_xor_b32_e32 v5, 0x62, v7
		v_accvgpr_write_b32 a120, v5
		v_xor_b32_e32 v5, 0x63, v7
		v_accvgpr_write_b32 a121, v5
		v_xor_b32_e32 v5, 0x68, v7
		v_accvgpr_write_b32 a122, v5
		v_xor_b32_e32 v5, 0x69, v7
		v_accvgpr_write_b32 a123, v5
		v_xor_b32_e32 v5, 0x6a, v7
		v_accvgpr_write_b32 a124, v5
		v_xor_b32_e32 v5, 0x6b, v7
		v_accvgpr_write_b32 a125, v5
		v_xor_b32_e32 v5, 0x70, v7
		v_accvgpr_write_b32 a126, v5
		v_xor_b32_e32 v5, 0x71, v7
		v_accvgpr_write_b32 a127, v5
		v_xor_b32_e32 v5, 0x72, v7
		v_accvgpr_write_b32 a128, v5
		v_xor_b32_e32 v5, 0x73, v7
		v_accvgpr_write_b32 a129, v5
		v_xor_b32_e32 v5, 0x78, v7
		v_accvgpr_write_b32 a130, v5
		v_xor_b32_e32 v5, 0x79, v7
		v_accvgpr_write_b32 a131, v5
		v_xor_b32_e32 v5, 0x7a, v7
		v_accvgpr_write_b32 a132, v5
		v_xor_b32_e32 v5, 0x7b, v7
		v_accvgpr_write_b32 a133, v5
		v_accvgpr_read_b32 v5, a20
		v_accvgpr_read_b32 v10, a63
		v_lshl_add_u32 v5, v5, 4, v10
		v_accvgpr_read_b32 v10, a64
		v_accvgpr_read_b32 v11, a65
		v_add3_u32 v5, v5, v10, v11
		v_accvgpr_read_b32 v10, a66
		v_accvgpr_read_b32 v11, a67
		v_add3_u32 v5, v5, v10, v11
		v_accvgpr_write_b32 a20, v5
		v_accvgpr_read_b32 v5, a68
		v_accvgpr_read_b32 v10, a70
		v_lshl_add_u32 v5, v5, 3, v10
		v_accvgpr_read_b32 v10, a71
		v_accvgpr_read_b32 v11, a72
		v_add3_u32 v5, v5, v10, v11
		v_accvgpr_write_b32 a63, v5
		v_mov_b32_e32 v5, 0xff800000
		s_cmp_lt_i32 s42, s23
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_4
.L_attn_fwd_persistent.loop_head_4:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s1, s42, 0x80
		s_cmp_lt_i32 s42, 0
		s_cselect_b32 s32, s22, 0
		s_add_i32 s32, s42, s32
		s_ashr_i32 s32, s32, 7
		s_cmp_lt_i32 s32, 0
		s_cselect_b32 s35, s16, 0
		s_add_i32 s35, s32, s35
		s_ashr_i32 s35, s35, 1
		s_lshl_b32 s35, s35, 1
		s_xor_b32 s35, s35, -1
		s_add_i32 s35, s35, 1
		s_add_i32 s35, s32, s35
		s_add_i32 s32, s32, 1
		s_cmp_lt_i32 s32, 0
		s_cselect_b32 s37, s16, 0
		s_add_i32 s37, s32, s37
		s_ashr_i32 s37, s37, 1
		s_lshl_b32 s37, s37, 1
		s_xor_b32 s37, s37, -1
		s_add_i32 s37, s37, 1
		s_add_i32 s40, s32, s37
		s_mul_i32 s32, 0x4100, s35
		v_accvgpr_read_b32 v10, a20
		v_add_u32_e32 v10, s32, v10
		ds_read_b128 a[64:67], v10
		ds_read_b128 a[136:139], v10 offset:32
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
		ds_read_b128 v[16:19], v10 offset:384
		ds_read_b128 a[180:183], v10 offset:416
		ds_read_b128 a[184:187], v10 offset:448
		ds_read_b128 a[188:191], v10 offset:480
		s_mul_i32 s32, 0x4400, s35
		v_accvgpr_read_b32 v10, a63
		v_add_u32_e32 v10, s32, v10
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
		s_cmp_lt_i32 s1, s19
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_4
		v_accvgpr_read_b32 v10, a21
		v_add_u32_e32 v10, s1, v10
		v_cmp_lt_i32_e64 s[50:51], v10, s21
		v_accvgpr_read_b32 v10, a22
		v_add_u32_e32 v10, s1, v10
		v_cmp_lt_i32_e64 s[52:53], v10, s21
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s32, s15, s42
		s_lshl_b32 s32, s32, 1
		s_add_i32 s35, s43, s32
		v_add_u32_e32 v10, s35, v8
		v_cndmask_b32_e64 v10, v20, v10, s[50:51]
		s_mov_b32 s50, 1
		s_mov_b32 s51, 0
		s_mov_b32 s37, 0
		s_mul_i32 s54, s50, s36
		s_mul_hi_u32 s55, s50, s36
		s_mul_i32 s35, s50, s37
		s_add_i32 s55, s55, s35
		s_mul_i32 s35, s51, s36
		s_add_i32 s55, s55, s35
		s_lshr_b64 s[50:51], s[54:55], 6
		s_mov_b32 s54, 0x410
		s_mov_b32 s55, 0
		s_mul_i32 s56, s54, s50
		s_mul_hi_u32 s57, s54, s50
		s_mul_i32 s35, s54, s51
		s_add_i32 s57, s57, s35
		s_mul_i32 s35, s55, s50
		s_add_i32 s57, s57, s35
		s_cmp_lt_i32 s40, 0
		s_cselect_b32 s41, -1, 0
		s_mov_b32 s54, 0x4100
		s_mov_b32 s55, 0
		s_mul_i32 s58, s54, s40
		s_mul_hi_u32 s59, s54, s40
		s_mul_i32 s35, s54, s41
		s_add_i32 s59, s59, s35
		s_mul_i32 s35, s55, s40
		s_add_i32 s59, s59, s35
		s_add_u32 s54, s56, s58
		s_addc_u32 s55, s57, s59
		s_add_u32 s60, s54, 0
		s_addc_u32 s61, s55, 0
		s_mov_b32 m0, s60
		v_accvgpr_read_b32 v11, a56
		v_add_u32_e32 v11, s1, v11
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v11, s21
		s_add_i32 s35, s44, s32
		v_add_u32_e32 v10, s35, v8
		v_cndmask_b32_e64 v10, v20, v10, s[54:55]
		s_add_u32 s54, s56, 0x1040
		s_addc_u32 s55, s57, 0
		s_add_u32 s54, s54, s58
		s_addc_u32 s55, s55, s59
		s_add_u32 s60, s54, 0
		s_addc_u32 s61, s55, 0
		s_mov_b32 m0, s60
		v_accvgpr_read_b32 v11, a57
		v_add_u32_e32 v11, s1, v11
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v11, s21
		s_add_i32 s35, s45, s32
		v_add_u32_e32 v10, s35, v8
		v_cndmask_b32_e64 v10, v20, v10, s[54:55]
		s_add_u32 s54, s56, 0x2080
		s_addc_u32 s55, s57, 0
		s_add_u32 s54, s54, s58
		s_addc_u32 s55, s55, s59
		s_add_u32 s60, s54, 0
		s_addc_u32 s61, s55, 0
		s_mov_b32 m0, s60
		v_accvgpr_read_b32 v11, a58
		v_add_u32_e32 v11, s1, v11
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v11, s21
		s_add_i32 s32, s33, s32
		v_add_u32_e32 v10, s32, v8
		v_cndmask_b32_e64 v10, v20, v10, s[54:55]
		s_add_u32 s54, s56, 0x30c0
		s_addc_u32 s55, s57, 0
		s_add_u32 s54, s54, s58
		s_addc_u32 s55, s55, s59
		s_add_u32 s56, s54, 0
		s_addc_u32 s57, s55, 0
		s_mov_b32 m0, s56
		v_accvgpr_read_b32 v11, a59
		v_add_u32_e32 v11, s1, v11
		buffer_load_dwordx4 v10, s[24:27], 0 offen lds
		s_mul_i32 s32, s17, s42
		s_lshl_b32 s32, s32, 1
		s_add_i32 s35, s46, s32
		v_add_u32_e32 v10, s35, v3
		v_cndmask_b32_e64 v10, v20, v10, s[52:53]
		s_mov_b32 s52, 0x440
		s_mov_b32 s53, 0
		s_mul_i32 s54, s52, s50
		s_mul_hi_u32 s55, s52, s50
		s_mul_i32 s35, s52, s51
		s_add_i32 s55, s55, s35
		s_mul_i32 s35, s53, s50
		s_add_i32 s55, s55, s35
		s_add_u32 s50, s54, 0x81f0
		s_addc_u32 s51, s55, 0
		s_mov_b32 s52, 0x4400
		s_mov_b32 s53, 0
		s_mul_i32 s56, s52, s40
		s_mul_hi_u32 s57, s52, s40
		s_mul_i32 s35, s52, s41
		s_add_i32 s57, s57, s35
		s_mul_i32 s35, s53, s40
		s_add_i32 s57, s57, s35
		s_add_u32 s40, s50, s56
		s_addc_u32 s41, s51, s57
		s_add_u32 s50, s40, 0
		s_addc_u32 s51, s41, 0
		s_mov_b32 m0, s50
		v_accvgpr_read_b32 v21, a60
		v_add_u32_e32 v21, s1, v21
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[40:41], v11, s21
		s_add_i32 s35, s47, s32
		v_add_u32_e32 v10, s35, v3
		v_cndmask_b32_e64 v10, v20, v10, s[40:41]
		s_add_u32 s40, s54, 0x92f0
		s_addc_u32 s41, s55, 0
		s_add_u32 s40, s40, s56
		s_addc_u32 s41, s41, s57
		s_add_u32 s50, s40, 0
		s_addc_u32 s51, s41, 0
		s_mov_b32 m0, s50
		v_accvgpr_read_b32 v11, a61
		v_add_u32_e32 v11, s1, v11
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[40:41], v21, s21
		s_add_i32 s1, s48, s32
		v_add_u32_e32 v10, s1, v3
		s_add_u32 s50, s54, 0xa3f0
		s_addc_u32 s51, s55, 0
		s_add_u32 s50, s50, s56
		s_addc_u32 s51, s51, s57
		s_add_u32 s52, s50, 0
		s_addc_u32 s53, s51, 0
		s_mov_b32 m0, s52
		v_cndmask_b32_e64 v10, v20, v10, s[40:41]
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		s_add_i32 s1, s34, s32
		v_cmp_lt_i32_e64 vcc, v11, s21
		v_add_u32_e32 v10, s1, v3
		s_add_u32 s40, s54, 0xb4f0
		s_addc_u32 s41, s55, 0
		v_cndmask_b32_e32 v10, v20, v10, vcc
		s_add_u32 s40, s40, s56
		s_addc_u32 s41, s41, s57
		s_add_u32 s50, s40, 0
		s_addc_u32 s51, s41, 0
		s_mov_b32 m0, s50
		s_nop 0
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_4
.L_attn_fwd_persistent.if_else_4:
.L_attn_fwd_persistent.if_end_4:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[96:111], a[64:67], a[24:27], 0
		v_add_u32_e32 v10, s42, v7
		v_mfma_f32_32x32x16_bf16 v[112:127], a[148:151], a[24:27], 0
		v_accvgpr_read_b32 v11, a13
		v_add_u32_e32 v11, s42, v11
		v_mfma_f32_32x32x16_bf16 v[128:143], a[164:167], a[24:27], 0
		v_accvgpr_read_b32 v21, a14
		v_add_u32_e32 v21, s42, v21
		v_mfma_f32_32x32x16_bf16 v[144:159], v[16:19], a[24:27], 0
		v_accvgpr_read_b32 v26, a62
		v_add_u32_e32 v26, s42, v26
		v_mfma_f32_32x32x16_bf16 v[160:175], v[16:19], a[40:43], 0
		v_accvgpr_read_b32 v16, a76
		v_add_u32_e32 v16, s42, v16
		v_mfma_f32_32x32x16_bf16 v[176:191], a[64:67], a[40:43], 0
		v_accvgpr_read_b32 v17, a77
		v_add_u32_e32 v17, s42, v17
		v_mfma_f32_32x32x16_bf16 v[192:207], a[148:151], a[40:43], 0
		v_accvgpr_read_b32 v18, a80
		v_add_u32_e32 v18, s42, v18
		v_mfma_f32_32x32x16_bf16 v[208:223], a[164:167], a[40:43], 0
		v_accvgpr_read_b32 v19, a81
		v_add_u32_e32 v19, s42, v19
		v_mfma_f32_32x32x16_bf16 v[96:111], a[136:139], a[28:31], v[96:111]
		v_accvgpr_read_b32 v27, a84
		v_add_u32_e32 v27, s42, v27
		v_mfma_f32_32x32x16_bf16 v[112:127], a[152:155], a[28:31], v[112:127]
		v_accvgpr_read_b32 v28, a85
		v_add_u32_e32 v28, s42, v28
		v_mfma_f32_32x32x16_bf16 v[128:143], a[168:171], a[28:31], v[128:143]
		v_accvgpr_read_b32 v29, a88
		v_add_u32_e32 v29, s42, v29
		v_mfma_f32_32x32x16_bf16 v[144:159], a[180:183], a[28:31], v[144:159]
		v_accvgpr_read_b32 v30, a89
		v_add_u32_e32 v30, s42, v30
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[44:47], v[160:175]
		v_accvgpr_read_b32 v31, a92
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a64, v31
		v_mfma_f32_32x32x16_bf16 v[176:191], a[136:139], a[44:47], v[176:191]
		v_accvgpr_read_b32 v31, a93
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a65, v31
		v_mfma_f32_32x32x16_bf16 v[192:207], a[152:155], a[44:47], v[192:207]
		v_accvgpr_read_b32 v31, a96
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a66, v31
		v_mfma_f32_32x32x16_bf16 v[208:223], a[168:171], a[44:47], v[208:223]
		v_accvgpr_read_b32 v31, a97
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a67, v31
		v_mfma_f32_32x32x16_bf16 v[96:111], a[140:143], a[32:35], v[96:111]
		v_accvgpr_read_b32 v31, a100
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a68, v31
		v_mfma_f32_32x32x16_bf16 v[112:127], a[156:159], a[32:35], v[112:127]
		v_accvgpr_read_b32 v31, a101
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a70, v31
		v_mfma_f32_32x32x16_bf16 v[128:143], a[172:175], a[32:35], v[128:143]
		v_accvgpr_read_b32 v31, a104
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a71, v31
		v_mfma_f32_32x32x16_bf16 v[144:159], a[184:187], a[32:35], v[144:159]
		v_accvgpr_read_b32 v31, a105
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a72, v31
		v_mfma_f32_32x32x16_bf16 v[160:175], a[184:187], a[48:51], v[160:175]
		v_accvgpr_read_b32 v31, a108
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a134, v31
		v_mfma_f32_32x32x16_bf16 v[176:191], a[140:143], a[48:51], v[176:191]
		v_accvgpr_read_b32 v31, a109
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a135, v31
		v_mfma_f32_32x32x16_bf16 v[192:207], a[156:159], a[48:51], v[192:207]
		v_accvgpr_read_b32 v31, a112
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a136, v31
		v_mfma_f32_32x32x16_bf16 v[208:223], a[172:175], a[48:51], v[208:223]
		v_accvgpr_read_b32 v31, a113
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a137, v31
		v_mfma_f32_32x32x16_bf16 v[96:111], a[144:147], a[36:39], v[96:111]
		v_accvgpr_read_b32 v31, a116
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a138, v31
		v_mfma_f32_32x32x16_bf16 v[112:127], a[160:163], a[36:39], v[112:127]
		v_accvgpr_read_b32 v31, a117
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a139, v31
		v_mfma_f32_32x32x16_bf16 v[128:143], a[176:179], a[36:39], v[128:143]
		v_accvgpr_read_b32 v31, a120
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a140, v31
		v_mfma_f32_32x32x16_bf16 v[144:159], a[188:191], a[36:39], v[144:159]
		v_accvgpr_read_b32 v31, a121
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a141, v31
		v_mfma_f32_32x32x16_bf16 v[160:175], a[188:191], a[52:55], v[160:175]
		v_accvgpr_read_b32 v31, a124
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a142, v31
		v_mfma_f32_32x32x16_bf16 v[176:191], a[144:147], a[52:55], v[176:191]
		v_accvgpr_read_b32 v31, a125
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a143, v31
		v_mfma_f32_32x32x16_bf16 v[192:207], a[160:163], a[52:55], v[192:207]
		v_accvgpr_read_b32 v31, a128
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a144, v31
		v_mfma_f32_32x32x16_bf16 v[208:223], a[176:179], a[52:55], v[208:223]
		v_accvgpr_read_b32 v31, a129
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a145, v31
		v_accvgpr_read_b32 v31, a132
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a146, v31
		v_accvgpr_read_b32 v31, a133
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_write_b32 a147, v31
		v_cmp_ge_i32_e64 s[40:41], v2, v10
		v_cmp_ge_i32_e64 s[50:51], v2, v11
		v_cmp_ge_i32_e64 s[52:53], v2, v21
		v_cmp_ge_i32_e64 vcc, v2, v26
		v_accvgpr_read_b32 v31, a69
		v_add_u32_e32 v31, s42, v31
		v_accvgpr_read_b32 v224, a75
		v_add_u32_e32 v224, s42, v224
		v_cndmask_b32_e32 v227, v5, v99, vcc
		v_cmp_ge_i32_e64 s[54:55], v2, v31
		v_cmp_ge_i32_e64 s[56:57], v2, v224
		v_cmp_ge_i32_e64 s[58:59], v2, v16
		v_cmp_ge_i32_e64 vcc, v2, v17
		v_accvgpr_read_b32 v99, a78
		v_add_u32_e32 v99, s42, v99
		v_accvgpr_read_b32 v225, a79
		v_add_u32_e32 v225, s42, v225
		v_cndmask_b32_e32 v229, v5, v103, vcc
		v_cmp_ge_i32_e64 s[60:61], v2, v99
		v_cmp_ge_i32_e64 s[62:63], v2, v225
		v_cmp_ge_i32_e64 s[64:65], v2, v18
		v_cmp_ge_i32_e64 vcc, v2, v19
		v_accvgpr_read_b32 v103, a82
		v_add_u32_e32 v103, s42, v103
		v_accvgpr_read_b32 v226, a83
		v_add_u32_e32 v230, s42, v226
		v_cndmask_b32_e32 v233, v5, v107, vcc
		v_cmp_ge_i32_e64 s[66:67], v2, v103
		v_cmp_ge_i32_e64 s[68:69], v2, v230
		v_cmp_ge_i32_e64 s[70:71], v2, v27
		v_cmp_ge_i32_e64 vcc, v2, v28
		v_accvgpr_read_b32 v107, a86
		v_add_u32_e32 v107, s42, v107
		v_accvgpr_read_b32 v226, a87
		v_add_u32_e32 v231, s42, v226
		v_cndmask_b32_e32 v235, v5, v111, vcc
		v_cmp_ge_i32_e64 s[72:73], v2, v107
		v_cmp_ge_i32_e64 s[74:75], v2, v231
		v_cmp_ge_i32_e64 s[76:77], v2, v29
		v_cmp_ge_i32_e64 vcc, v2, v30
		v_accvgpr_read_b32 v111, a90
		v_add_u32_e32 v111, s42, v111
		v_accvgpr_read_b32 v226, a91
		v_add_u32_e32 v226, s42, v226
		v_accvgpr_write_b32 a148, v226
		v_cndmask_b32_e32 v237, v5, v115, vcc
		v_cmp_ge_i32_e64 s[78:79], v2, v111
		v_accvgpr_read_b32 v115, a148
		v_cmp_ge_i32_e64 s[80:81], v2, v115
		v_accvgpr_read_b32 v115, a64
		v_cmp_ge_i32_e64 s[82:83], v2, v115
		v_accvgpr_read_b32 v115, a65
		v_cmp_ge_i32_e64 vcc, v2, v115
		v_accvgpr_read_b32 v115, a94
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a149, v115
		v_accvgpr_read_b32 v115, a95
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a150, v115
		v_cndmask_b32_e32 v239, v5, v119, vcc
		v_accvgpr_read_b32 v115, a149
		v_cmp_ge_i32_e64 s[84:85], v2, v115
		v_accvgpr_read_b32 v115, a150
		v_cmp_ge_i32_e64 s[86:87], v2, v115
		v_accvgpr_read_b32 v115, a66
		v_cmp_ge_i32_e64 s[88:89], v2, v115
		s_nop 1
		v_mov_b32_e32 v240, s88
		v_mov_b32_e32 v241, s89
		v_accvgpr_write_b32 a152, v240
		v_accvgpr_write_b32 a153, v241
		v_accvgpr_read_b32 v115, a67
		v_cmp_ge_i32_e64 vcc, v2, v115
		v_accvgpr_read_b32 v115, a98
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a151, v115
		v_accvgpr_read_b32 v115, a99
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a154, v115
		v_cndmask_b32_e32 v241, v5, v123, vcc
		v_accvgpr_read_b32 v115, a151
		v_cmp_ge_i32_e64 s[88:89], v2, v115
		s_nop 1
		v_mov_b32_e32 v242, s88
		v_mov_b32_e32 v243, s89
		v_accvgpr_write_b32 a156, v242
		v_accvgpr_write_b32 a157, v243
		v_accvgpr_read_b32 v115, a154
		v_cmp_ge_i32_e64 s[88:89], v2, v115
		s_nop 1
		v_mov_b32_e32 v242, s88
		v_mov_b32_e32 v243, s89
		v_accvgpr_write_b32 a158, v242
		v_accvgpr_write_b32 a159, v243
		v_accvgpr_read_b32 v115, a68
		v_cmp_ge_i32_e64 s[88:89], v2, v115
		s_nop 1
		v_mov_b32_e32 v242, s88
		v_mov_b32_e32 v243, s89
		v_accvgpr_write_b32 a160, v242
		v_accvgpr_write_b32 a161, v243
		v_accvgpr_read_b32 v115, a70
		v_cmp_ge_i32_e64 vcc, v2, v115
		v_accvgpr_read_b32 v115, a102
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a155, v115
		v_accvgpr_read_b32 v115, a103
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a162, v115
		v_cndmask_b32_e32 v243, v5, v127, vcc
		v_accvgpr_read_b32 v115, a155
		v_cmp_ge_i32_e64 s[88:89], v2, v115
		s_nop 1
		v_mov_b32_e32 v244, s88
		v_mov_b32_e32 v245, s89
		v_accvgpr_write_b32 a164, v244
		v_accvgpr_write_b32 a165, v245
		v_accvgpr_read_b32 v115, a162
		v_cmp_ge_i32_e64 s[88:89], v2, v115
		s_nop 1
		v_mov_b32_e32 v244, s88
		v_mov_b32_e32 v245, s89
		v_accvgpr_write_b32 a166, v244
		v_accvgpr_write_b32 a167, v245
		v_accvgpr_read_b32 v115, a71
		v_cmp_ge_i32_e64 s[88:89], v2, v115
		s_nop 1
		v_mov_b32_e32 v244, s88
		v_mov_b32_e32 v245, s89
		v_accvgpr_write_b32 a168, v244
		v_accvgpr_write_b32 a169, v245
		v_accvgpr_read_b32 v115, a72
		v_cmp_ge_i32_e64 vcc, v2, v115
		v_accvgpr_read_b32 v115, a106
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a163, v115
		v_accvgpr_read_b32 v115, a107
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a170, v115
		v_cndmask_b32_e32 v245, v5, v131, vcc
		v_accvgpr_read_b32 v115, a163
		v_cmp_ge_i32_e64 s[88:89], v2, v115
		s_nop 1
		v_mov_b32_e32 v246, s88
		v_mov_b32_e32 v247, s89
		v_accvgpr_write_b32 a172, v246
		v_accvgpr_write_b32 a173, v247
		v_accvgpr_read_b32 v115, a170
		v_cmp_ge_i32_e64 s[88:89], v2, v115
		s_nop 1
		v_mov_b32_e32 v246, s88
		v_mov_b32_e32 v247, s89
		v_accvgpr_write_b32 a174, v246
		v_accvgpr_write_b32 a175, v247
		v_accvgpr_read_b32 v115, a134
		v_cmp_ge_i32_e64 s[88:89], v2, v115
		s_nop 1
		v_mov_b32_e32 v246, s88
		v_mov_b32_e32 v247, s89
		v_accvgpr_write_b32 a176, v246
		v_accvgpr_write_b32 a177, v247
		v_accvgpr_read_b32 v115, a135
		v_cmp_ge_i32_e64 vcc, v2, v115
		v_accvgpr_read_b32 v115, a110
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a171, v115
		v_accvgpr_read_b32 v115, a111
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a178, v115
		v_cndmask_b32_e32 v247, v5, v135, vcc
		v_accvgpr_read_b32 v115, a171
		v_cmp_ge_i32_e64 s[88:89], v2, v115
		s_nop 1
		v_mov_b32_e32 v248, s88
		v_mov_b32_e32 v249, s89
		v_accvgpr_write_b32 a180, v248
		v_accvgpr_write_b32 a181, v249
		v_accvgpr_read_b32 v115, a178
		v_cmp_ge_i32_e64 s[88:89], v2, v115
		v_accvgpr_read_b32 v115, a136
		v_cmp_ge_i32_e64 s[90:91], v2, v115
		v_accvgpr_read_b32 v115, a137
		v_cmp_ge_i32_e64 vcc, v2, v115
		v_accvgpr_read_b32 v115, a114
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a179, v115
		v_accvgpr_read_b32 v115, a115
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a182, v115
		v_cndmask_b32_e32 v249, v5, v139, vcc
		v_accvgpr_read_b32 v115, a179
		v_cmp_ge_i32_e64 s[92:93], v2, v115
		v_accvgpr_read_b32 v115, a182
		v_cmp_ge_i32_e64 s[94:95], v2, v115
		v_accvgpr_read_b32 v115, a138
		v_cmp_ge_i32_e64 s[96:97], v2, v115
		v_accvgpr_read_b32 v115, a139
		v_cmp_ge_i32_e64 vcc, v2, v115
		v_cndmask_b32_e64 v251, v5, v141, s[94:95]
		v_cndmask_b32_e64 v252, v5, v142, s[96:97]
		v_accvgpr_read_b32 v115, a118
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a183, v115
		v_accvgpr_read_b32 v115, a119
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a184, v115
		v_cndmask_b32_e32 v253, v5, v143, vcc
		v_accvgpr_read_b32 v115, a183
		v_cmp_ge_i32_e64 s[94:95], v2, v115
		v_accvgpr_read_b32 v115, a184
		v_cmp_ge_i32_e64 s[96:97], v2, v115
		v_accvgpr_read_b32 v115, a140
		v_cmp_ge_i32_e64 s[98:99], v2, v115
		v_cndmask_b32_e64 v142, v5, v144, s[94:95]
		v_cndmask_b32_e64 v143, v5, v145, s[96:97]
		v_cndmask_b32_e64 v144, v5, v146, s[98:99]
		v_accvgpr_read_b32 v115, a141
		v_cmp_ge_i32_e64 vcc, v2, v115
		v_accvgpr_read_b32 v115, a122
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a185, v115
		v_accvgpr_read_b32 v115, a123
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a186, v115
		v_cndmask_b32_e32 v145, v5, v147, vcc
		v_accvgpr_read_b32 v115, a185
		v_cmp_ge_i32_e64 s[94:95], v2, v115
		v_accvgpr_read_b32 v115, a186
		v_cmp_ge_i32_e64 s[96:97], v2, v115
		v_accvgpr_read_b32 v115, a142
		v_cmp_ge_i32_e64 s[98:99], v2, v115
		v_cndmask_b32_e64 v146, v5, v148, s[94:95]
		v_cndmask_b32_e64 v147, v5, v149, s[96:97]
		v_cndmask_b32_e64 v148, v5, v150, s[98:99]
		v_accvgpr_read_b32 v115, a143
		v_cmp_ge_i32_e64 vcc, v2, v115
		v_accvgpr_read_b32 v115, a126
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a187, v115
		v_accvgpr_read_b32 v115, a127
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a188, v115
		v_cndmask_b32_e32 v149, v5, v151, vcc
		v_accvgpr_read_b32 v115, a187
		v_cmp_ge_i32_e64 s[94:95], v2, v115
		v_accvgpr_read_b32 v115, a188
		v_cmp_ge_i32_e64 s[96:97], v2, v115
		v_accvgpr_read_b32 v115, a144
		v_cmp_ge_i32_e64 s[98:99], v2, v115
		v_cndmask_b32_e64 v150, v5, v152, s[94:95]
		v_cndmask_b32_e64 v151, v5, v153, s[96:97]
		v_cndmask_b32_e64 v152, v5, v154, s[98:99]
		v_accvgpr_read_b32 v115, a145
		v_cmp_ge_i32_e64 vcc, v2, v115
		v_accvgpr_read_b32 v115, a130
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a189, v115
		v_accvgpr_read_b32 v115, a131
		v_add_u32_e32 v115, s42, v115
		v_accvgpr_write_b32 a190, v115
		v_cndmask_b32_e32 v153, v5, v155, vcc
		v_accvgpr_read_b32 v115, a189
		v_cmp_ge_i32_e64 s[94:95], v2, v115
		v_accvgpr_read_b32 v115, a190
		v_cmp_ge_i32_e64 s[96:97], v2, v115
		v_accvgpr_read_b32 v115, a146
		v_cmp_ge_i32_e64 s[98:99], v2, v115
		v_cndmask_b32_e64 v154, v5, v156, s[94:95]
		v_cndmask_b32_e64 v155, v5, v157, s[96:97]
		v_cndmask_b32_e64 v156, v5, v158, s[98:99]
		v_accvgpr_read_b32 v115, a147
		v_cmp_ge_i32_e64 vcc, v2, v115
		v_cndmask_b32_e64 v254, v5, v96, s[40:41]
		v_cndmask_b32_e64 v255, v5, v97, s[50:51]
		v_cndmask_b32_e32 v157, v5, v159, vcc
		v_cmp_ge_i32_e64 s[40:41], v4, v10
		v_cmp_ge_i32_e64 s[50:51], v4, v11
		v_cmp_ge_i32_e64 s[94:95], v4, v21
		v_cmp_ge_i32_e64 vcc, v4, v26
		v_cndmask_b32_e64 v226, v5, v98, s[52:53]
		v_cndmask_b32_e64 v10, v5, v178, s[94:95]
		v_cndmask_b32_e64 v96, v5, v100, s[54:55]
		v_cndmask_b32_e32 v11, v5, v179, vcc
		v_cmp_ge_i32_e64 s[52:53], v4, v31
		v_cmp_ge_i32_e64 s[54:55], v4, v224
		v_cmp_ge_i32_e64 s[94:95], v4, v16
		v_cndmask_b32_e64 v158, v5, v180, s[52:53]
		v_cndmask_b32_e64 v159, v5, v181, s[54:55]
		v_cndmask_b32_e64 v178, v5, v182, s[94:95]
		v_cmp_ge_i32_e64 vcc, v4, v17
		v_cndmask_b32_e64 v97, v5, v101, s[56:57]
		v_cndmask_b32_e64 v228, v5, v102, s[58:59]
		v_cndmask_b32_e32 v179, v5, v183, vcc
		v_cmp_ge_i32_e64 s[52:53], v4, v99
		v_cmp_ge_i32_e64 s[54:55], v4, v225
		v_cmp_ge_i32_e64 s[56:57], v4, v18
		v_cndmask_b32_e64 v16, v5, v184, s[52:53]
		v_cndmask_b32_e64 v17, v5, v185, s[54:55]
		v_cndmask_b32_e64 v98, v5, v186, s[56:57]
		v_cmp_ge_i32_e64 vcc, v4, v19
		v_cndmask_b32_e64 v18, v5, v104, s[60:61]
		v_cndmask_b32_e64 v19, v5, v105, s[62:63]
		v_cndmask_b32_e32 v99, v5, v187, vcc
		v_cmp_ge_i32_e64 s[52:53], v4, v103
		v_cmp_ge_i32_e64 s[54:55], v4, v230
		v_cmp_ge_i32_e64 s[56:57], v4, v27
		v_cndmask_b32_e64 v26, v5, v188, s[52:53]
		v_cndmask_b32_e64 v27, v5, v189, s[54:55]
		v_cndmask_b32_e64 v100, v5, v190, s[56:57]
		v_cmp_ge_i32_e64 vcc, v4, v28
		v_cndmask_b32_e64 v232, v5, v106, s[64:65]
		v_cndmask_b32_e64 v102, v5, v108, s[66:67]
		v_cndmask_b32_e32 v101, v5, v191, vcc
		v_cmp_ge_i32_e64 s[52:53], v4, v107
		v_cmp_ge_i32_e64 s[54:55], v4, v231
		v_cmp_ge_i32_e64 s[56:57], v4, v29
		v_cndmask_b32_e64 v28, v5, v192, s[52:53]
		v_cndmask_b32_e64 v29, v5, v193, s[54:55]
		v_cndmask_b32_e64 v104, v5, v194, s[56:57]
		v_cmp_ge_i32_e64 vcc, v4, v30
		v_cndmask_b32_e64 v103, v5, v109, s[68:69]
		v_cndmask_b32_e64 v234, v5, v110, s[70:71]
		v_cndmask_b32_e32 v105, v5, v195, vcc
		v_cmp_ge_i32_e64 s[52:53], v4, v111
		v_accvgpr_read_b32 v21, a148
		v_cmp_ge_i32_e64 s[54:55], v4, v21
		v_accvgpr_read_b32 v21, a64
		v_cmp_ge_i32_e64 s[56:57], v4, v21
		v_cndmask_b32_e64 v30, v5, v196, s[52:53]
		v_cndmask_b32_e64 v31, v5, v197, s[54:55]
		v_cndmask_b32_e64 v106, v5, v198, s[56:57]
		v_accvgpr_read_b32 v21, a65
		v_cmp_ge_i32_e64 vcc, v4, v21
		v_cndmask_b32_e64 v108, v5, v112, s[72:73]
		v_cndmask_b32_e64 v109, v5, v113, s[74:75]
		v_cndmask_b32_e32 v107, v5, v199, vcc
		v_accvgpr_read_b32 v21, a149
		v_cmp_ge_i32_e64 s[52:53], v4, v21
		v_accvgpr_read_b32 v21, a150
		v_cmp_ge_i32_e64 s[54:55], v4, v21
		v_accvgpr_read_b32 v21, a66
		v_cmp_ge_i32_e64 s[56:57], v4, v21
		v_cndmask_b32_e64 v110, v5, v200, s[52:53]
		v_cndmask_b32_e64 v111, v5, v201, s[54:55]
		v_cndmask_b32_e64 v112, v5, v202, s[56:57]
		v_accvgpr_read_b32 v21, a67
		v_cmp_ge_i32_e64 vcc, v4, v21
		v_cndmask_b32_e64 v236, v5, v114, s[76:77]
		v_cndmask_b32_e64 v114, v5, v116, s[78:79]
		v_cndmask_b32_e32 v113, v5, v203, vcc
		v_accvgpr_read_b32 v21, a151
		v_cmp_ge_i32_e64 s[52:53], v4, v21
		v_accvgpr_read_b32 v21, a154
		v_cmp_ge_i32_e64 s[54:55], v4, v21
		v_accvgpr_read_b32 v21, a68
		v_cmp_ge_i32_e64 s[56:57], v4, v21
		v_cndmask_b32_e64 v180, v5, v204, s[52:53]
		v_cndmask_b32_e64 v181, v5, v205, s[54:55]
		v_cndmask_b32_e64 v182, v5, v206, s[56:57]
		v_accvgpr_read_b32 v21, a70
		v_cmp_ge_i32_e64 vcc, v4, v21
		v_cndmask_b32_e64 v115, v5, v117, s[80:81]
		v_cndmask_b32_e64 v238, v5, v118, s[82:83]
		v_cndmask_b32_e32 v183, v5, v207, vcc
		v_accvgpr_read_b32 v21, a155
		v_cmp_ge_i32_e64 s[52:53], v4, v21
		v_accvgpr_read_b32 v21, a162
		v_cmp_ge_i32_e64 s[54:55], v4, v21
		v_accvgpr_read_b32 v21, a71
		v_cmp_ge_i32_e64 s[56:57], v4, v21
		v_cndmask_b32_e64 v116, v5, v208, s[52:53]
		v_cndmask_b32_e64 v117, v5, v209, s[54:55]
		v_cndmask_b32_e64 v118, v5, v210, s[56:57]
		v_accvgpr_read_b32 v21, a72
		v_cmp_ge_i32_e64 vcc, v4, v21
		v_cndmask_b32_e64 v184, v5, v120, s[84:85]
		v_cndmask_b32_e64 v185, v5, v121, s[86:87]
		v_cndmask_b32_e32 v119, v5, v211, vcc
		v_accvgpr_read_b32 v21, a163
		v_cmp_ge_i32_e64 s[52:53], v4, v21
		v_accvgpr_read_b32 v21, a170
		v_cmp_ge_i32_e64 s[54:55], v4, v21
		v_accvgpr_read_b32 v21, a134
		v_cmp_ge_i32_e64 s[56:57], v4, v21
		v_cndmask_b32_e64 v120, v5, v212, s[52:53]
		v_cndmask_b32_e64 v121, v5, v213, s[54:55]
		v_cndmask_b32_e64 v186, v5, v214, s[56:57]
		v_accvgpr_read_b32 v21, a135
		v_cmp_ge_i32_e64 vcc, v4, v21
		v_accvgpr_read_b32 v21, a152
		s_nop 0
		v_readfirstlane_b32 s52, v21
		v_accvgpr_read_b32 v21, a153
		s_nop 0
		v_readfirstlane_b32 s53, v21
		s_nop 1
		v_cndmask_b32_e64 v240, v5, v122, s[52:53]
		v_accvgpr_read_b32 v21, a156
		s_nop 0
		v_readfirstlane_b32 s52, v21
		v_accvgpr_read_b32 v21, a157
		s_nop 0
		v_readfirstlane_b32 s53, v21
		s_nop 1
		v_cndmask_b32_e64 v122, v5, v124, s[52:53]
		v_cndmask_b32_e32 v187, v5, v215, vcc
		v_accvgpr_read_b32 v21, a171
		v_cmp_ge_i32_e64 s[52:53], v4, v21
		v_accvgpr_read_b32 v21, a178
		v_cmp_ge_i32_e64 s[54:55], v4, v21
		v_accvgpr_read_b32 v21, a136
		v_cmp_ge_i32_e64 s[56:57], v4, v21
		v_cndmask_b32_e64 v188, v5, v216, s[52:53]
		v_cndmask_b32_e64 v189, v5, v217, s[54:55]
		v_cndmask_b32_e64 v190, v5, v218, s[56:57]
		v_accvgpr_read_b32 v21, a137
		v_cmp_ge_i32_e64 vcc, v4, v21
		v_accvgpr_read_b32 v21, a158
		s_nop 0
		v_readfirstlane_b32 s52, v21
		v_accvgpr_read_b32 v21, a159
		s_nop 0
		v_readfirstlane_b32 s53, v21
		s_nop 1
		v_cndmask_b32_e64 v123, v5, v125, s[52:53]
		v_accvgpr_read_b32 v21, a160
		s_nop 0
		v_readfirstlane_b32 s52, v21
		v_accvgpr_read_b32 v21, a161
		s_nop 0
		v_readfirstlane_b32 s53, v21
		s_nop 1
		v_cndmask_b32_e64 v242, v5, v126, s[52:53]
		v_cndmask_b32_e32 v191, v5, v219, vcc
		v_accvgpr_read_b32 v21, a179
		v_cmp_ge_i32_e64 s[52:53], v4, v21
		v_accvgpr_read_b32 v21, a182
		v_cmp_ge_i32_e64 s[54:55], v4, v21
		v_accvgpr_read_b32 v21, a138
		v_cmp_ge_i32_e64 s[56:57], v4, v21
		v_cndmask_b32_e64 v124, v5, v220, s[52:53]
		v_cndmask_b32_e64 v125, v5, v221, s[54:55]
		v_cndmask_b32_e64 v126, v5, v222, s[56:57]
		v_accvgpr_read_b32 v21, a139
		v_cmp_ge_i32_e64 vcc, v4, v21
		v_accvgpr_read_b32 v21, a164
		s_nop 0
		v_readfirstlane_b32 s52, v21
		v_accvgpr_read_b32 v21, a165
		s_nop 0
		v_readfirstlane_b32 s53, v21
		s_nop 1
		v_cndmask_b32_e64 v192, v5, v128, s[52:53]
		v_accvgpr_read_b32 v21, a166
		s_nop 0
		v_readfirstlane_b32 s52, v21
		v_accvgpr_read_b32 v21, a167
		s_nop 0
		v_readfirstlane_b32 s53, v21
		s_nop 1
		v_cndmask_b32_e64 v193, v5, v129, s[52:53]
		v_cndmask_b32_e32 v127, v5, v223, vcc
		v_accvgpr_read_b32 v21, a183
		v_cmp_ge_i32_e64 s[52:53], v4, v21
		v_accvgpr_read_b32 v21, a184
		v_cmp_ge_i32_e64 s[54:55], v4, v21
		v_accvgpr_read_b32 v21, a140
		v_cmp_ge_i32_e64 s[56:57], v4, v21
		v_cndmask_b32_e64 v128, v5, v160, s[52:53]
		v_cndmask_b32_e64 v129, v5, v161, s[54:55]
		v_cndmask_b32_e64 v160, v5, v162, s[56:57]
		v_accvgpr_read_b32 v21, a141
		v_cmp_ge_i32_e64 vcc, v4, v21
		v_accvgpr_read_b32 v21, a168
		s_nop 0
		v_readfirstlane_b32 s52, v21
		v_accvgpr_read_b32 v21, a169
		s_nop 0
		v_readfirstlane_b32 s53, v21
		s_nop 1
		v_cndmask_b32_e64 v244, v5, v130, s[52:53]
		v_accvgpr_read_b32 v21, a172
		s_nop 0
		v_readfirstlane_b32 s52, v21
		v_accvgpr_read_b32 v21, a173
		s_nop 0
		v_readfirstlane_b32 s53, v21
		s_nop 1
		v_cndmask_b32_e64 v130, v5, v132, s[52:53]
		v_cndmask_b32_e32 v161, v5, v163, vcc
		v_accvgpr_read_b32 v21, a185
		v_cmp_ge_i32_e64 s[52:53], v4, v21
		v_accvgpr_read_b32 v21, a186
		v_cmp_ge_i32_e64 s[54:55], v4, v21
		v_accvgpr_read_b32 v21, a142
		v_cmp_ge_i32_e64 s[56:57], v4, v21
		v_cndmask_b32_e64 v162, v5, v164, s[52:53]
		v_cndmask_b32_e64 v163, v5, v165, s[54:55]
		v_cndmask_b32_e64 v164, v5, v166, s[56:57]
		v_accvgpr_read_b32 v21, a143
		v_cmp_ge_i32_e64 vcc, v4, v21
		v_accvgpr_read_b32 v21, a174
		s_nop 0
		v_readfirstlane_b32 s52, v21
		v_accvgpr_read_b32 v21, a175
		s_nop 0
		v_readfirstlane_b32 s53, v21
		s_nop 1
		v_cndmask_b32_e64 v131, v5, v133, s[52:53]
		v_accvgpr_read_b32 v21, a176
		s_nop 0
		v_readfirstlane_b32 s52, v21
		v_accvgpr_read_b32 v21, a177
		s_nop 0
		v_readfirstlane_b32 s53, v21
		s_nop 1
		v_cndmask_b32_e64 v246, v5, v134, s[52:53]
		v_cndmask_b32_e32 v165, v5, v167, vcc
		v_accvgpr_read_b32 v21, a187
		v_cmp_ge_i32_e64 s[52:53], v4, v21
		v_accvgpr_read_b32 v21, a188
		v_cmp_ge_i32_e64 s[54:55], v4, v21
		v_accvgpr_read_b32 v21, a144
		v_cmp_ge_i32_e64 s[56:57], v4, v21
		v_cndmask_b32_e64 v132, v5, v168, s[52:53]
		v_cndmask_b32_e64 v133, v5, v169, s[54:55]
		v_cndmask_b32_e64 v134, v5, v170, s[56:57]
		v_accvgpr_read_b32 v21, a145
		v_cmp_ge_i32_e64 vcc, v4, v21
		v_accvgpr_read_b32 v21, a180
		s_nop 0
		v_readfirstlane_b32 s52, v21
		v_accvgpr_read_b32 v21, a181
		s_nop 0
		v_readfirstlane_b32 s53, v21
		s_nop 1
		v_cndmask_b32_e64 v166, v5, v136, s[52:53]
		v_cndmask_b32_e64 v167, v5, v137, s[88:89]
		v_cndmask_b32_e32 v135, v5, v171, vcc
		v_accvgpr_read_b32 v21, a189
		v_cmp_ge_i32_e64 s[52:53], v4, v21
		v_accvgpr_read_b32 v21, a190
		v_cmp_ge_i32_e64 s[54:55], v4, v21
		v_accvgpr_read_b32 v21, a146
		v_cmp_ge_i32_e64 s[56:57], v4, v21
		v_cndmask_b32_e64 v136, v5, v172, s[52:53]
		v_cndmask_b32_e64 v137, v5, v173, s[54:55]
		v_cndmask_b32_e64 v168, v5, v174, s[56:57]
		v_accvgpr_read_b32 v21, a147
		v_cmp_ge_i32_e64 vcc, v4, v21
		v_cndmask_b32_e64 v248, v5, v138, s[90:91]
		v_cndmask_b32_e64 v250, v5, v140, s[92:93]
		v_cndmask_b32_e32 v169, v5, v175, vcc
		v_max3_f32 v21, v254, v255, v226
		v_max3_f32 v138, v96, v97, v228
		v_max3_f32 v139, v18, v19, v232
		v_max3_f32 v140, v102, v103, v234
		v_max3_f32 v141, v108, v109, v236
		v_max3_f32 v170, v114, v115, v238
		v_max3_f32 v171, v184, v185, v240
		v_max3_f32 v172, v122, v123, v242
		v_max3_f32 v173, v192, v193, v244
		v_max3_f32 v174, v130, v131, v246
		v_max3_f32 v175, v166, v167, v248
		v_max3_f32 v194, v250, v251, v252
		v_max3_f32 v195, v142, v143, v144
		v_max3_f32 v196, v146, v147, v148
		v_max3_f32 v197, v150, v151, v152
		v_max3_f32 v198, v154, v155, v156
		v_max3_f32 v21, v21, v227, v138
		v_max3_f32 v138, v139, v233, v140
		v_max3_f32 v139, v141, v237, v170
		v_max3_f32 v140, v171, v241, v172
		v_max3_f32 v141, v173, v245, v174
		v_max3_f32 v170, v175, v249, v194
		v_max3_f32 v171, v195, v145, v196
		v_max3_f32 v172, v197, v153, v198
		v_max3_f32 v21, v21, v229, v138
		v_max3_f32 v138, v139, v239, v140
		v_max3_f32 v139, v141, v247, v170
		v_max3_f32 v140, v171, v149, v172
		v_max3_f32 v21, v21, v235, v138
		v_max3_f32 v138, v139, v253, v140
		v_max3_f32 v21, v21, v243, v138
		v_max_f32_e32 v138, v21, v157
		v_mov_b32_e32 v139, v138
		v_cndmask_b32_e64 v140, v5, v176, s[40:41]
		v_cndmask_b32_e64 v141, v5, v177, s[50:51]
		v_permlane32_swap_b32_e32 v138, v139
		v_max3_f32 v21, v140, v141, v10
		v_max3_f32 v170, v158, v159, v178
		v_max3_f32 v171, v16, v17, v98
		v_max3_f32 v172, v26, v27, v100
		v_max3_f32 v173, v28, v29, v104
		v_max3_f32 v174, v30, v31, v106
		v_max3_f32 v175, v110, v111, v112
		v_max3_f32 v176, v180, v181, v182
		v_max3_f32 v177, v116, v117, v118
		v_max3_f32 v194, v120, v121, v186
		v_max3_f32 v195, v188, v189, v190
		v_max3_f32 v196, v124, v125, v126
		v_max3_f32 v197, v128, v129, v160
		v_max3_f32 v198, v162, v163, v164
		v_max3_f32 v199, v132, v133, v134
		v_max3_f32 v200, v136, v137, v168
		v_max3_f32 v21, v21, v11, v170
		v_max3_f32 v170, v171, v99, v172
		v_max3_f32 v171, v173, v105, v174
		v_max3_f32 v172, v175, v113, v176
		v_max3_f32 v173, v177, v119, v194
		v_max3_f32 v174, v195, v191, v196
		v_max3_f32 v175, v197, v161, v198
		v_max3_f32 v176, v199, v135, v200
		v_max3_f32 v21, v21, v179, v170
		v_max3_f32 v170, v171, v107, v172
		v_max3_f32 v171, v173, v187, v174
		v_max3_f32 v172, v175, v165, v176
		v_max3_f32 v21, v21, v101, v170
		v_max3_f32 v170, v171, v127, v172
		v_max3_f32 v21, v21, v183, v170
		v_max_f32_e32 v170, v21, v169
		v_mov_b32_e32 v171, v170
		v_max_f32_e32 v172, v138, v139
		s_add_i32 s1, s42, 0x80
		s_cmp_lt_i32 s1, s23
		v_permlane32_swap_b32_e32 v170, v171
		v_max_f32_e32 v173, v170, v171
		v_pk_mul_f32 v[138:139], v[172:173], v[12:13]
		v_max_f32_e32 v170, v6, v138
		v_max_f32_e32 v171, v9, v139
		v_pk_fma_f32 v[138:139], v[254:255], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[226:227], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[96:97], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[228:229], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[18:19], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[18:19], v[232:233], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[102:103], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[234:235], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[108:109], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[236:237], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[114:115], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[238:239], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[184:185], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[240:241], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[122:123], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[242:243], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[192:193], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[244:245], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[130:131], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[246:247], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[166:167], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[248:249], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[250:251], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[252:253], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[142:143], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[144:145], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[146:147], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[148:149], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[150:151], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[154:155], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[156:157], v[12:13], v[170:171] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[140:141], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[10:11], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[10:11], v[158:159], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[178:179], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[16:17], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[16:17], v[98:99], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[26:27], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[100:101], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[28:29], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[104:105], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[30:31], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[106:107], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[110:111], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[112:113], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[180:181], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[182:183], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[116:117], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[118:119], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[120:121], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[186:187], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[188:189], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[190:191], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[124:125], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[126:127], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[128:129], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[160:161], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[162:163], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[164:165], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[132:133], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[134:135], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[136:137], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[168:169], v[12:13], v[170:171] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v168, v138
		v_exp_f32_e32 v216, v139
		v_exp_f32_e32 v138, v172
		v_exp_f32_e32 v218, v173
		v_exp_f32_e32 v172, v174
		v_exp_f32_e32 v220, v175
		v_exp_f32_e32 v174, v96
		v_exp_f32_e32 v222, v97
		v_exp_f32_e32 v96, v176
		v_exp_f32_e32 v224, v177
		v_exp_f32_e32 v176, v18
		v_exp_f32_e32 v226, v19
		v_exp_f32_e32 v18, v194
		v_exp_f32_e32 v228, v195
		v_exp_f32_e32 v194, v102
		v_exp_f32_e32 v230, v103
		v_exp_f32_e32 v102, v196
		v_exp_f32_e32 v232, v197
		v_exp_f32_e32 v196, v108
		v_exp_f32_e32 v234, v109
		v_exp_f32_e32 v108, v198
		v_exp_f32_e32 v236, v199
		v_exp_f32_e32 v198, v114
		v_exp_f32_e32 v238, v115
		v_exp_f32_e32 v114, v200
		v_exp_f32_e32 v240, v201
		v_exp_f32_e32 v200, v184
		v_exp_f32_e32 v242, v185
		v_exp_f32_e32 v184, v202
		v_exp_f32_e32 v244, v203
		v_exp_f32_e32 v202, v122
		v_exp_f32_e32 v246, v123
		v_exp_f32_e32 v169, v204
		v_exp_f32_e32 v217, v205
		v_exp_f32_e32 v139, v192
		v_exp_f32_e32 v219, v193
		v_exp_f32_e32 v173, v206
		v_exp_f32_e32 v221, v207
		v_exp_f32_e32 v175, v130
		v_exp_f32_e32 v223, v131
		v_exp_f32_e32 v97, v208
		v_exp_f32_e32 v225, v209
		v_exp_f32_e32 v177, v166
		v_exp_f32_e32 v227, v167
		v_exp_f32_e32 v19, v210
		v_exp_f32_e32 v229, v211
		v_exp_f32_e32 v195, v212
		v_exp_f32_e32 v231, v213
		v_exp_f32_e32 v103, v214
		v_exp_f32_e32 v233, v215
		v_exp_f32_e32 v197, v142
		v_exp_f32_e32 v235, v143
		v_exp_f32_e32 v109, v144
		v_exp_f32_e32 v237, v145
		v_exp_f32_e32 v199, v146
		v_exp_f32_e32 v239, v147
		v_exp_f32_e32 v115, v148
		v_exp_f32_e32 v241, v149
		v_exp_f32_e32 v201, v150
		v_exp_f32_e32 v243, v151
		v_exp_f32_e32 v185, v152
		v_exp_f32_e32 v245, v153
		v_exp_f32_e32 v203, v154
		v_exp_f32_e32 v247, v155
		v_exp_f32_e32 v122, v156
		v_exp_f32_e32 v130, v157
		v_exp_f32_e32 v142, v140
		v_exp_f32_e32 v144, v141
		v_exp_f32_e32 v140, v10
		v_exp_f32_e32 v146, v11
		v_exp_f32_e32 v10, v158
		v_exp_f32_e32 v148, v159
		v_exp_f32_e32 v150, v178
		v_exp_f32_e32 v152, v179
		v_exp_f32_e32 v154, v16
		v_exp_f32_e32 v156, v17
		v_exp_f32_e32 v16, v98
		v_exp_f32_e32 v158, v99
		v_exp_f32_e32 v98, v26
		v_exp_f32_e32 v166, v27
		v_exp_f32_e32 v26, v100
		v_exp_f32_e32 v178, v101
		v_exp_f32_e32 v100, v28
		v_exp_f32_e32 v192, v29
		v_exp_f32_e32 v28, v104
		v_exp_f32_e32 v204, v105
		v_exp_f32_e32 v104, v30
		v_exp_f32_e32 v206, v31
		v_exp_f32_e32 v30, v106
		v_exp_f32_e32 v208, v107
		v_exp_f32_e32 v106, v110
		v_exp_f32_e32 v210, v111
		v_exp_f32_e32 v110, v112
		v_exp_f32_e32 v212, v113
		v_exp_f32_e32 v112, v180
		v_exp_f32_e32 v214, v181
		v_exp_f32_e32 v123, v182
		v_exp_f32_e32 v131, v183
		v_exp_f32_e32 v143, v116
		v_exp_f32_e32 v145, v117
		v_exp_f32_e32 v141, v118
		v_exp_f32_e32 v147, v119
		v_exp_f32_e32 v11, v120
		v_exp_f32_e32 v149, v121
		v_exp_f32_e32 v151, v186
		v_exp_f32_e32 v153, v187
		v_exp_f32_e32 v155, v188
		v_exp_f32_e32 v157, v189
		v_exp_f32_e32 v17, v190
		v_exp_f32_e32 v159, v191
		v_exp_f32_e32 v99, v124
		v_exp_f32_e32 v167, v125
		v_exp_f32_e32 v27, v126
		v_exp_f32_e32 v179, v127
		v_exp_f32_e32 v101, v128
		v_exp_f32_e32 v193, v129
		v_exp_f32_e32 v29, v160
		v_exp_f32_e32 v205, v161
		v_exp_f32_e32 v105, v162
		v_exp_f32_e32 v207, v163
		v_exp_f32_e32 v31, v164
		v_exp_f32_e32 v209, v165
		v_exp_f32_e32 v107, v132
		v_exp_f32_e32 v211, v133
		v_exp_f32_e32 v111, v134
		v_exp_f32_e32 v213, v135
		v_exp_f32_e32 v113, v136
		v_exp_f32_e32 v215, v137
		v_pk_add_f32 v[116:117], v[168:169], v[216:217]
		v_pk_add_f32 v[118:119], v[138:139], v[218:219]
		v_pk_add_f32 v[120:121], v[172:173], v[220:221]
		v_pk_add_f32 v[124:125], v[174:175], v[222:223]
		v_pk_add_f32 v[126:127], v[96:97], v[224:225]
		v_pk_add_f32 v[128:129], v[176:177], v[226:227]
		v_pk_add_f32 v[132:133], v[18:19], v[228:229]
		v_pk_add_f32 v[134:135], v[194:195], v[230:231]
		v_pk_add_f32 v[136:137], v[102:103], v[232:233]
		v_pk_add_f32 v[160:161], v[196:197], v[234:235]
		v_pk_add_f32 v[162:163], v[108:109], v[236:237]
		v_pk_add_f32 v[164:165], v[198:199], v[238:239]
		v_pk_add_f32 v[180:181], v[114:115], v[240:241]
		v_pk_add_f32 v[182:183], v[200:201], v[242:243]
		v_pk_add_f32 v[186:187], v[184:185], v[244:245]
		v_pk_add_f32 v[188:189], v[202:203], v[246:247]
		v_pk_add_f32 v[116:117], v[116:117], v[118:119]
		v_pk_add_f32 v[118:119], v[120:121], v[124:125]
		v_pk_add_f32 v[120:121], v[126:127], v[128:129]
		v_pk_add_f32 v[124:125], v[132:133], v[134:135]
		v_pk_add_f32 v[126:127], v[136:137], v[160:161]
		v_pk_add_f32 v[128:129], v[162:163], v[164:165]
		v_pk_add_f32 v[132:133], v[180:181], v[182:183]
		v_pk_add_f32 v[134:135], v[186:187], v[188:189]
		v_pk_add_f32 v[116:117], v[116:117], v[118:119]
		v_pk_add_f32 v[118:119], v[120:121], v[124:125]
		v_pk_add_f32 v[120:121], v[126:127], v[128:129]
		v_pk_add_f32 v[124:125], v[132:133], v[134:135]
		v_pk_add_f32 v[116:117], v[116:117], v[118:119]
		v_pk_add_f32 v[118:119], v[120:121], v[124:125]
		v_pk_add_f32 v[120:121], v[116:117], v[118:119]
		v_add_f32_e32 v21, v120, v121
		v_accvgpr_read_b32 v116, a73
		ds_bpermute_b32 v118, v116, v21
		v_accvgpr_read_b32 v116, a74
		ds_bpermute_b32 v120, v116, v21
		v_pk_add_f32 v[116:117], v[122:123], v[130:131]
		v_pk_add_f32 v[124:125], v[142:143], v[144:145]
		v_pk_add_f32 v[126:127], v[140:141], v[146:147]
		v_pk_add_f32 v[128:129], v[10:11], v[148:149]
		v_pk_add_f32 v[132:133], v[150:151], v[152:153]
		v_pk_add_f32 v[134:135], v[154:155], v[156:157]
		v_pk_add_f32 v[136:137], v[16:17], v[158:159]
		v_pk_add_f32 v[160:161], v[98:99], v[166:167]
		v_pk_add_f32 v[162:163], v[26:27], v[178:179]
		v_pk_add_f32 v[164:165], v[100:101], v[192:193]
		v_pk_add_f32 v[180:181], v[28:29], v[204:205]
		v_pk_add_f32 v[182:183], v[104:105], v[206:207]
		v_pk_add_f32 v[186:187], v[30:31], v[208:209]
		v_pk_add_f32 v[188:189], v[106:107], v[210:211]
		v_pk_add_f32 v[190:191], v[110:111], v[212:213]
		v_pk_add_f32 v[248:249], v[112:113], v[214:215]
		v_pk_add_f32 v[116:117], v[116:117], v[124:125]
		v_pk_add_f32 v[124:125], v[126:127], v[128:129]
		v_pk_add_f32 v[126:127], v[132:133], v[134:135]
		v_pk_add_f32 v[128:129], v[136:137], v[160:161]
		v_pk_add_f32 v[132:133], v[162:163], v[164:165]
		v_pk_add_f32 v[134:135], v[180:181], v[182:183]
		v_pk_add_f32 v[136:137], v[186:187], v[188:189]
		v_pk_add_f32 v[160:161], v[190:191], v[248:249]
		v_pk_add_f32 v[116:117], v[116:117], v[124:125]
		v_pk_add_f32 v[124:125], v[126:127], v[128:129]
		v_pk_add_f32 v[126:127], v[132:133], v[134:135]
		v_pk_add_f32 v[128:129], v[136:137], v[160:161]
		v_pk_add_f32 v[116:117], v[116:117], v[124:125]
		v_pk_add_f32 v[124:125], v[126:127], v[128:129]
		v_pk_add_f32 v[126:127], v[116:117], v[124:125]
		v_mov_b32_e32 v121, v127
		v_mov_b32_e32 v119, v126
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[116:117], v[118:119], v[120:121]
		v_mov_b32_e32 v118, v117
		v_mov_b32_e32 v119, v117
		v_cvt_pk_bf16_f32 v124, v168, v216
		v_cvt_pk_bf16_f32 v125, v138, v218
		v_permlane32_swap_b32_e32 v118, v119
		v_add_f32_e32 v121, v118, v119
		v_mov_b32_e32 v118, v6
		v_mov_b32_e32 v119, v9
		v_pk_add_f32 v[126:127], v[118:119], v[170:171] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v118, v126
		v_exp_f32_e32 v119, v127
		v_cvt_pk_bf16_f32 v126, v172, v220
		v_pk_mul_f32 v[32:33], v[32:33], v[118:119] op_sel_hi:[1,0]
		v_pk_mul_f32 v[34:35], v[34:35], v[118:119] op_sel_hi:[1,0]
		v_pk_mul_f32 v[36:37], v[36:37], v[118:119] op_sel_hi:[1,0]
		v_pk_mul_f32 v[38:39], v[38:39], v[118:119] op_sel_hi:[1,0]
		v_pk_mul_f32 v[40:41], v[40:41], v[118:119] op_sel_hi:[1,0]
		v_pk_mul_f32 v[42:43], v[42:43], v[118:119] op_sel_hi:[1,0]
		v_pk_mul_f32 v[44:45], v[44:45], v[118:119] op_sel_hi:[1,0]
		v_pk_mul_f32 v[46:47], v[46:47], v[118:119] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[48:49], v[118:119] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[50:51], v[118:119] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[52:53], v[118:119] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[54:55], v[118:119] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[56:57], v[118:119] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[58:59], v[118:119] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[60:61], v[118:119] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[62:63], v[118:119] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[64:65], v[118:119] op_sel:[0,1]
		v_pk_mul_f32 v[66:67], v[66:67], v[118:119] op_sel:[0,1]
		v_pk_mul_f32 v[68:69], v[68:69], v[118:119] op_sel:[0,1]
		v_pk_mul_f32 v[70:71], v[70:71], v[118:119] op_sel:[0,1]
		v_pk_mul_f32 v[72:73], v[72:73], v[118:119] op_sel:[0,1]
		v_pk_mul_f32 v[74:75], v[74:75], v[118:119] op_sel:[0,1]
		v_pk_mul_f32 v[76:77], v[76:77], v[118:119] op_sel:[0,1]
		v_pk_mul_f32 v[78:79], v[78:79], v[118:119] op_sel:[0,1]
		v_pk_mul_f32 v[80:81], v[80:81], v[118:119] op_sel:[0,1]
		v_pk_mul_f32 v[82:83], v[82:83], v[118:119] op_sel:[0,1]
		v_pk_mul_f32 v[84:85], v[84:85], v[118:119] op_sel:[0,1]
		v_pk_mul_f32 v[86:87], v[86:87], v[118:119] op_sel:[0,1]
		v_pk_mul_f32 v[88:89], v[88:89], v[118:119] op_sel:[0,1]
		v_pk_mul_f32 v[90:91], v[90:91], v[118:119] op_sel:[0,1]
		v_pk_mul_f32 v[92:93], v[92:93], v[118:119] op_sel:[0,1]
		v_pk_mul_f32 v[94:95], v[94:95], v[118:119] op_sel:[0,1]
		v_mov_b32_e32 v120, v116
		v_mov_b64_e32 v[116:117], v[14:15]
		v_pk_fma_f32 v[14:15], v[116:117], v[118:119], v[120:121]
		v_cvt_pk_bf16_f32 v127, v174, v222
		v_cvt_pk_bf16_f32 v116, v96, v224
		v_cvt_pk_bf16_f32 v117, v176, v226
		v_cvt_pk_bf16_f32 v118, v18, v228
		v_cvt_pk_bf16_f32 v119, v194, v230
		v_cvt_pk_bf16_f32 v132, v102, v232
		v_cvt_pk_bf16_f32 v133, v196, v234
		v_cvt_pk_bf16_f32 v134, v108, v236
		v_cvt_pk_bf16_f32 v135, v198, v238
		v_cvt_pk_bf16_f32 v160, v114, v240
		v_cvt_pk_bf16_f32 v161, v200, v242
		v_cvt_pk_bf16_f32 v162, v184, v244
		v_cvt_pk_bf16_f32 v163, v202, v246
		v_cvt_pk_bf16_f32 v180, v169, v217
		v_cvt_pk_bf16_f32 v181, v139, v219
		v_cvt_pk_bf16_f32 v182, v173, v221
		v_cvt_pk_bf16_f32 v183, v175, v223
		v_cvt_pk_bf16_f32 v136, v97, v225
		v_cvt_pk_bf16_f32 v137, v177, v227
		v_cvt_pk_bf16_f32 v138, v19, v229
		v_cvt_pk_bf16_f32 v139, v195, v231
		v_cvt_pk_bf16_f32 v172, v103, v233
		v_cvt_pk_bf16_f32 v173, v197, v235
		v_cvt_pk_bf16_f32 v174, v109, v237
		v_cvt_pk_bf16_f32 v175, v199, v239
		v_cvt_pk_bf16_f32 v188, v115, v241
		v_cvt_pk_bf16_f32 v189, v201, v243
		v_cvt_pk_bf16_f32 v190, v185, v245
		v_cvt_pk_bf16_f32 v191, v203, v247
		v_cvt_pk_bf16_f32 v184, v122, v130
		v_cvt_pk_bf16_f32 v185, v142, v144
		v_cvt_pk_bf16_f32 v186, v140, v146
		v_cvt_pk_bf16_f32 v187, v10, v148
		v_cvt_pk_bf16_f32 v196, v150, v152
		v_cvt_pk_bf16_f32 v197, v154, v156
		v_cvt_pk_bf16_f32 v198, v16, v158
		v_cvt_pk_bf16_f32 v199, v98, v166
		v_cvt_pk_bf16_f32 v200, v26, v178
		v_cvt_pk_bf16_f32 v201, v100, v192
		v_cvt_pk_bf16_f32 v202, v28, v204
		v_cvt_pk_bf16_f32 v203, v104, v206
		v_cvt_pk_bf16_f32 v216, v30, v208
		v_cvt_pk_bf16_f32 v217, v106, v210
		v_cvt_pk_bf16_f32 v218, v110, v212
		v_cvt_pk_bf16_f32 v219, v112, v214
		v_cvt_pk_bf16_f32 v220, v123, v131
		v_cvt_pk_bf16_f32 v221, v143, v145
		v_cvt_pk_bf16_f32 v222, v141, v147
		v_cvt_pk_bf16_f32 v223, v11, v149
		v_cvt_pk_bf16_f32 v120, v151, v153
		v_cvt_pk_bf16_f32 v121, v155, v157
		v_cvt_pk_bf16_f32 v122, v17, v159
		v_cvt_pk_bf16_f32 v123, v99, v167
		v_cvt_pk_bf16_f32 v16, v27, v179
		v_cvt_pk_bf16_f32 v17, v101, v193
		v_cvt_pk_bf16_f32 v18, v29, v205
		v_cvt_pk_bf16_f32 v19, v105, v207
		v_cvt_pk_bf16_f32 v96, v31, v209
		v_cvt_pk_bf16_f32 v97, v107, v211
		v_cvt_pk_bf16_f32 v98, v111, v213
		v_cvt_pk_bf16_f32 v99, v113, v215
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[124:127], v[32:47]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[124:127], v[48:63]
		v_permlane32_swap_b32_e32 v160, v162
		v_permlane32_swap_b32_e32 v161, v163
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[116:119], v[32:47]
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[116:119], v[48:63]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[132:135], v[32:47]
		v_permlane32_swap_b32_e32 v172, v174
		v_permlane32_swap_b32_e32 v173, v175
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[132:135], v[48:63]
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[160:163], v[32:47]
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[160:163], v[48:63]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[184:187], v[80:95]
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[184:187], v[64:79]
		v_permlane32_swap_b32_e32 v216, v218
		v_permlane32_swap_b32_e32 v217, v219
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[196:199], v[80:95]
		v_permlane32_swap_b32_e32 v220, v222
		v_permlane32_swap_b32_e32 v221, v223
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[196:199], v[64:79]
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[200:203], v[80:95]
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[200:203], v[64:79]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[216:219], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[216:219], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[180:183], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[180:183], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[220:223], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[220:223], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[136:139], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[136:139], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[120:123], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[120:123], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[216:219], v[172:175], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[248:251], v[172:175], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[248:251], v[16:19], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[216:219], v[16:19], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[220:223], v[188:191], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[252:255], v[188:191], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[252:255], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[220:223], v[96:99], v[64:79]
		s_mov_b32 s42, s1
		v_mov_b32_e32 v6, v170
		v_mov_b32_e32 v9, v171
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_4
.L_attn_fwd_persistent.loop_exit_4:
		s_mov_b32 s24, s8
		s_mov_b32 s25, s9
		s_mov_b32 s26, s38
		s_mov_b32 s27, s39
		v_rcp_f32_e32 v2, v14
		v_rcp_f32_e32 v4, v15
		v_mov_b32_e32 v3, v2
		v_pk_mul_f32 v[6:7], v[32:33], v[2:3]
		v_pk_mul_f32 v[8:9], v[34:35], v[2:3]
		v_pk_mul_f32 v[10:11], v[36:37], v[2:3]
		v_pk_mul_f32 v[12:13], v[38:39], v[2:3]
		v_pk_mul_f32 v[14:15], v[40:41], v[2:3]
		v_pk_mul_f32 v[16:17], v[42:43], v[2:3]
		v_pk_mul_f32 v[18:19], v[44:45], v[2:3]
		v_pk_mul_f32 v[20:21], v[46:47], v[2:3]
		v_pk_mul_f32 v[26:27], v[48:49], v[2:3]
		v_pk_mul_f32 v[28:29], v[50:51], v[2:3]
		v_pk_mul_f32 v[30:31], v[52:53], v[2:3]
		v_pk_mul_f32 v[32:33], v[54:55], v[2:3]
		v_pk_mul_f32 v[34:35], v[56:57], v[2:3]
		v_pk_mul_f32 v[36:37], v[58:59], v[2:3]
		v_pk_mul_f32 v[38:39], v[60:61], v[2:3]
		v_pk_mul_f32 v[40:41], v[62:63], v[2:3]
		v_mov_b32_e32 v5, v4
		v_pk_mul_f32 v[2:3], v[64:65], v[4:5]
		v_pk_mul_f32 v[42:43], v[66:67], v[4:5]
		v_pk_mul_f32 v[44:45], v[68:69], v[4:5]
		v_pk_mul_f32 v[46:47], v[70:71], v[4:5]
		v_pk_mul_f32 v[48:49], v[72:73], v[4:5]
		v_pk_mul_f32 v[50:51], v[74:75], v[4:5]
		v_pk_mul_f32 v[52:53], v[76:77], v[4:5]
		v_pk_mul_f32 v[54:55], v[78:79], v[4:5]
		v_pk_mul_f32 v[56:57], v[80:81], v[4:5]
		v_pk_mul_f32 v[58:59], v[82:83], v[4:5]
		v_pk_mul_f32 v[60:61], v[84:85], v[4:5]
		v_pk_mul_f32 v[62:63], v[86:87], v[4:5]
		v_pk_mul_f32 v[64:65], v[88:89], v[4:5]
		v_pk_mul_f32 v[66:67], v[90:91], v[4:5]
		v_pk_mul_f32 v[68:69], v[92:93], v[4:5]
		v_pk_mul_f32 v[70:71], v[94:95], v[4:5]
		v_cvt_pk_bf16_f32 v72, v6, v7
		v_cvt_pk_bf16_f32 v73, v8, v9
		v_cvt_pk_bf16_f32 v74, v10, v11
		v_cvt_pk_bf16_f32 v75, v12, v13
		v_cvt_pk_bf16_f32 v4, v14, v15
		v_cvt_pk_bf16_f32 v5, v16, v17
		v_cvt_pk_bf16_f32 v6, v18, v19
		v_cvt_pk_bf16_f32 v7, v20, v21
		v_cvt_pk_bf16_f32 v8, v26, v27
		v_cvt_pk_bf16_f32 v9, v28, v29
		v_cvt_pk_bf16_f32 v10, v30, v31
		v_cvt_pk_bf16_f32 v11, v32, v33
		v_cvt_pk_bf16_f32 v12, v34, v35
		v_cvt_pk_bf16_f32 v13, v36, v37
		v_cvt_pk_bf16_f32 v14, v38, v39
		v_cvt_pk_bf16_f32 v15, v40, v41
		v_cvt_pk_bf16_f32 v16, v2, v3
		v_cvt_pk_bf16_f32 v17, v42, v43
		v_cvt_pk_bf16_f32 v18, v44, v45
		v_cvt_pk_bf16_f32 v19, v46, v47
		v_cvt_pk_bf16_f32 v28, v48, v49
		v_cvt_pk_bf16_f32 v29, v50, v51
		v_cvt_pk_bf16_f32 v30, v52, v53
		v_cvt_pk_bf16_f32 v31, v54, v55
		v_cvt_pk_bf16_f32 v32, v56, v57
		v_cvt_pk_bf16_f32 v33, v58, v59
		v_cvt_pk_bf16_f32 v34, v60, v61
		v_cvt_pk_bf16_f32 v35, v62, v63
		v_cvt_pk_bf16_f32 v36, v64, v65
		v_cvt_pk_bf16_f32 v37, v66, v67
		v_cvt_pk_bf16_f32 v38, v68, v69
		v_cvt_pk_bf16_f32 v39, v70, v71
		v_permlane32_swap_b32_e32 v72, v74
		v_permlane32_swap_b32_e32 v73, v75
		v_permlane32_swap_b32_e32 v4, v6
		v_permlane32_swap_b32_e32 v5, v7
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
		v_permlane32_swap_b32_e32 v12, v14
		v_permlane32_swap_b32_e32 v13, v15
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_permlane32_swap_b32_e32 v32, v34
		v_permlane32_swap_b32_e32 v33, v35
		v_permlane32_swap_b32_e32 v36, v38
		v_permlane32_swap_b32_e32 v37, v39
		v_accvgpr_read_b32 v2, a11
		s_nop 0
		v_readfirstlane_b32 s1, v2
		s_mul_i32 s1, s1, s18
		s_lshl_b32 s1, s1, 9
		v_accvgpr_read_b32 v2, a2
		s_nop 0
		v_readfirstlane_b32 s19, v2
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
		v_accvgpr_read_b32 v3, a15
		v_mul_lo_u32 v3, s18, v3
		v_lshl_add_u32 v2, v3, 1, v2
		v_accvgpr_read_b32 v20, a19
		v_mul_lo_u32 v20, s18, v20
		v_lshl_add_u32 v2, v20, 5, v2
		v_accvgpr_read_b32 v21, a23
		v_mul_lo_u32 v21, s18, v21
		v_lshl_add_u32 v2, v21, 4, v2
		v_accvgpr_read_b32 v26, a16
		v_mul_lo_u32 v26, s18, v26
		v_lshl_add_u32 v2, v26, 3, v2
		v_accvgpr_read_b32 v27, a17
		v_mul_lo_u32 v27, s18, v27
		v_lshl_add_u32 v2, v27, 2, v2
		v_accvgpr_read_b32 v40, a18
		v_lshl_add_u32 v2, v40, 4, v2
		v_readfirstlane_b32 s28, v22
		v_readfirstlane_b32 s29, v23
		s_and_saveexec_b64 s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_24
		buffer_store_dwordx4 v[72:75], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_24:
		s_andn2_b64 exec, s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_24
.L_attn_fwd_persistent.exec_endif_24:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s22, s1, 32
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s23
		v_lshl_add_u32 v2, v1, 6, s22
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v20, 5, v2
		v_lshl_add_u32 v2, v21, 4, v2
		v_lshl_add_u32 v2, v26, 3, v2
		v_lshl_add_u32 v2, v27, 2, v2
		v_accvgpr_read_b32 v40, a18
		v_lshl_add_u32 v2, v40, 4, v2
		v_readfirstlane_b32 s28, v22
		v_readfirstlane_b32 s29, v23
		s_and_saveexec_b64 s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_25
		buffer_store_dwordx4 v[4:7], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_25:
		s_andn2_b64 exec, s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_25
.L_attn_fwd_persistent.exec_endif_25:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s22, s1, 64
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s23
		v_lshl_add_u32 v2, v1, 6, s22
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v20, 5, v2
		v_lshl_add_u32 v2, v21, 4, v2
		v_lshl_add_u32 v2, v26, 3, v2
		v_lshl_add_u32 v2, v27, 2, v2
		v_accvgpr_read_b32 v4, a18
		v_lshl_add_u32 v2, v4, 4, v2
		v_readfirstlane_b32 s28, v22
		v_readfirstlane_b32 s29, v23
		s_and_saveexec_b64 s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_26
		buffer_store_dwordx4 v[8:11], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_26:
		s_andn2_b64 exec, s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_26
.L_attn_fwd_persistent.exec_endif_26:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s22, s1, 0x60
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s23
		v_lshl_add_u32 v2, v1, 6, s22
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v20, 5, v2
		v_lshl_add_u32 v2, v21, 4, v2
		v_lshl_add_u32 v2, v26, 3, v2
		v_lshl_add_u32 v2, v27, 2, v2
		v_accvgpr_read_b32 v4, a18
		v_lshl_add_u32 v2, v4, 4, v2
		v_readfirstlane_b32 s28, v22
		v_readfirstlane_b32 s29, v23
		s_and_saveexec_b64 s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_27
		buffer_store_dwordx4 v[12:15], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_27:
		s_andn2_b64 exec, s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_27
.L_attn_fwd_persistent.exec_endif_27:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s22, s18, 8
		s_add_i32 s28, s22, s1
		s_add_i32 s28, s28, s19
		s_add_i32 s28, s28, s23
		v_lshl_add_u32 v2, v1, 6, s28
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v20, 5, v2
		v_lshl_add_u32 v2, v21, 4, v2
		v_lshl_add_u32 v2, v26, 3, v2
		v_lshl_add_u32 v2, v27, 2, v2
		v_accvgpr_read_b32 v4, a18
		v_lshl_add_u32 v2, v4, 4, v2
		v_readfirstlane_b32 s28, v24
		v_readfirstlane_b32 s29, v25
		s_and_saveexec_b64 s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_28
		buffer_store_dwordx4 v[16:19], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_28:
		s_andn2_b64 exec, s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_28
.L_attn_fwd_persistent.exec_endif_28:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s28, s22, 32
		s_add_i32 s28, s28, s1
		s_add_i32 s28, s28, s19
		s_add_i32 s28, s28, s23
		v_lshl_add_u32 v2, v1, 6, s28
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v20, 5, v2
		v_lshl_add_u32 v2, v21, 4, v2
		v_lshl_add_u32 v2, v26, 3, v2
		v_lshl_add_u32 v2, v27, 2, v2
		v_accvgpr_read_b32 v4, a18
		v_lshl_add_u32 v2, v4, 4, v2
		v_readfirstlane_b32 s28, v24
		v_readfirstlane_b32 s29, v25
		s_and_saveexec_b64 s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_29
		buffer_store_dwordx4 v[28:31], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_29:
		s_andn2_b64 exec, s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_29
.L_attn_fwd_persistent.exec_endif_29:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s28, s22, 64
		s_add_i32 s28, s28, s1
		s_add_i32 s28, s28, s19
		s_add_i32 s28, s28, s23
		v_lshl_add_u32 v2, v1, 6, s28
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v20, 5, v2
		v_lshl_add_u32 v2, v21, 4, v2
		v_lshl_add_u32 v2, v26, 3, v2
		v_lshl_add_u32 v2, v27, 2, v2
		v_accvgpr_read_b32 v4, a18
		v_lshl_add_u32 v2, v4, 4, v2
		v_readfirstlane_b32 s28, v24
		v_readfirstlane_b32 s29, v25
		s_and_saveexec_b64 s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_30
		buffer_store_dwordx4 v[32:35], v2, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_30:
		s_andn2_b64 exec, s[100:101], s[28:29]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_30
.L_attn_fwd_persistent.exec_endif_30:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s22, s22, 0x60
		s_add_i32 s1, s22, s1
		s_add_i32 s1, s1, s19
		s_add_i32 s1, s1, s23
		v_lshl_add_u32 v1, v1, 6, s1
		v_lshl_add_u32 v1, v3, 1, v1
		v_lshl_add_u32 v1, v20, 5, v1
		v_lshl_add_u32 v1, v21, 4, v1
		v_lshl_add_u32 v1, v26, 3, v1
		v_lshl_add_u32 v1, v27, 2, v1
		v_accvgpr_read_b32 v2, a18
		v_lshl_add_u32 v1, v2, 4, v1
		v_readfirstlane_b32 s22, v24
		v_readfirstlane_b32 s23, v25
		s_and_saveexec_b64 s[100:101], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_31
		buffer_store_dwordx4 v[36:39], v1, s[24:27], 0 offen
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
    wave.regalloc.iterations: 455
    wave.regalloc.agpr.dwords: 871
    wave.regalloc.remat.dwords: 5
    wave.regalloc.sgpr_to_vgpr.dwords: 69
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
