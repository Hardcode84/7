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
		s_add_i32 s1, s22, s26
		s_cmp_lg_u32 s25, 0
		s_cselect_b32 s1, s1, s22
		s_xor_b32 s22, s1, -1
		s_add_i32 s22, s22, 1
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s1, s22, s1
		v_mov_b32_e32 v2, s1
		v_accvgpr_write_b32 a10, v2
		s_cmp_lt_i32 s19, 32
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_1
		s_lshr_b32 s1, s19, 1
		s_and_b32 s19, s19, 1
		s_xor_b32 s22, s1, -1
		s_add_i32 s22, s22, 1
		s_add_i32 s22, s22, 31
		s_cmp_eq_u32 s19, 0
		s_cselect_b32 s1, s1, s22
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
		v_accvgpr_read_b32 v6, a13
		v_add_u32_e32 v6, s1, v6
		v_xor_b32_e32 v2, 0x80, v2
		v_xor_b32_e32 v2, v2, v5
		v_xor_b32_e32 v2, v2, v7
		v_bitop3_b32 v2, v2, v10, v13 bitop3:0x96
		v_bitop3_b32 v2, v2, v15, v17 bitop3:0x96
		v_accvgpr_write_b32 a14, v2
		v_accvgpr_read_b32 v2, a14
		v_add_u32_e32 v2, s1, v2
		v_mov_b32_e32 v5, 2
		v_mul_lo_u32 v5, v5, v12
		v_lshrrev_b32_e32 v7, 5, v0
		v_and_b32_e32 v10, 1, v7
		v_mov_b32_e32 v13, 4
		v_mul_lo_u32 v13, v13, v10
		v_bitop3_b32 v15, v9, v5, v13 bitop3:0x96
		v_mov_b32_e32 v17, 8
		v_mul_lo_u32 v17, v17, v14
		v_xor_b32_e32 v15, v15, v17
		v_mov_b32_e32 v18, 16
		v_mul_lo_u32 v18, v18, v16
		v_xad_u32 v15, v15, v18, s1
		v_bitop3_b32 v19, 32, v9, v5 bitop3:0x96
		v_bitop3_b32 v19, v19, v13, v17 bitop3:0x96
		v_xad_u32 v19, v19, v18, s1
		v_bitop3_b32 v20, 64, v9, v5 bitop3:0x96
		v_bitop3_b32 v20, v20, v13, v17 bitop3:0x96
		v_xad_u32 v20, v20, v18, s1
		v_xor_b32_e32 v21, 0x60, v9
		v_xor_b32_e32 v21, v21, v5
		v_xor_b32_e32 v21, v21, v13
		v_xor_b32_e32 v21, v21, v17
		v_xad_u32 v21, v21, v18, s1
		v_xor_b32_e32 v22, 0x80, v9
		v_xor_b32_e32 v22, v22, v5
		v_xor_b32_e32 v22, v22, v13
		v_xor_b32_e32 v22, v22, v17
		v_xad_u32 v22, v22, v18, s1
		v_xor_b32_e32 v23, 0xa0, v9
		v_xor_b32_e32 v23, v23, v5
		v_xor_b32_e32 v23, v23, v13
		v_xor_b32_e32 v23, v23, v17
		v_xad_u32 v23, v23, v18, s1
		v_xor_b32_e32 v24, 0xc0, v9
		v_xor_b32_e32 v24, v24, v5
		v_xor_b32_e32 v24, v24, v13
		v_xor_b32_e32 v24, v24, v17
		v_xad_u32 v24, v24, v18, s1
		v_xor_b32_e32 v25, 0xe0, v9
		v_xor_b32_e32 v5, v25, v5
		v_xor_b32_e32 v5, v5, v13
		v_xor_b32_e32 v5, v5, v17
		v_xad_u32 v5, v5, v18, s1
		s_mov_b32 s26, 0x7fffffff
		s_mov_b32 s27, 0x31016000
		s_mov_b32 s24, s2
		s_mov_b32 s25, s3
		v_accvgpr_read_b32 v17, a6
		v_and_b32_e32 v17, 0xffff, v17
		v_lshlrev_b32_e32 v18, 16, v17
		v_or_b32_e32 v28, v17, v18
		v_mov_b32_e32 v29, v28
		v_mov_b32_e32 v30, v28
		v_mov_b32_e32 v31, v28
		v_accvgpr_read_b32 v17, a11
		s_nop 0
		v_readfirstlane_b32 s19, v17
		s_mul_i32 s19, s19, s12
		s_lshl_b32 s19, s19, 9
		v_readfirstlane_b32 s22, v1
		s_mul_i32 s22, s22, s10
		s_lshl_b32 s22, s22, 1
		s_add_i32 s23, s19, s22
		v_accvgpr_read_b32 v17, a10
		s_nop 0
		v_readfirstlane_b32 s28, v17
		s_mul_i32 s28, s28, s11
		s_lshl_b32 s28, s28, 1
		s_add_i32 s23, s23, s28
		v_mul_lo_u32 v17, s12, v8
		v_lshl_add_u32 v18, v17, 1, s23
		v_and_b32_e32 v25, 1, v0
		v_accvgpr_write_b32 a15, v25
		v_accvgpr_read_b32 v25, a15
		v_lshl_add_u32 v18, v25, 4, v18
		v_and_b32_e32 v25, 1, v4
		v_accvgpr_write_b32 a16, v25
		v_accvgpr_read_b32 v25, a16
		v_lshl_add_u32 v18, v25, 6, v18
		v_and_b32_e32 v3, 1, v3
		v_accvgpr_write_b32 a17, v3
		v_accvgpr_read_b32 v3, a17
		v_lshl_add_u32 v3, v3, 5, v18
		v_cmp_lt_i32_e64 vcc, v15, s20
		s_and_saveexec_b64 s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_0
		buffer_load_dwordx4 v[32:35], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_0:
		s_andn2_b64 exec, s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_0
		v_mov_b32_e32 v32, v28
		v_mov_b32_e32 v33, v29
		v_mov_b32_e32 v34, v30
		v_mov_b32_e32 v35, v31
.L_attn_fwd_persistent.exec_endif_0:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s23, s12, 6
		s_add_i32 s23, s23, s19
		s_add_i32 s23, s23, s22
		s_add_i32 s23, s23, s28
		v_lshl_add_u32 v3, v17, 1, s23
		v_accvgpr_read_b32 v15, a15
		v_lshl_add_u32 v3, v15, 4, v3
		v_accvgpr_read_b32 v15, a16
		v_lshl_add_u32 v3, v15, 6, v3
		v_accvgpr_read_b32 v15, a17
		v_lshl_add_u32 v3, v15, 5, v3
		v_cmp_lt_i32_e64 vcc, v19, s20
		s_and_saveexec_b64 s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_1
		buffer_load_dwordx4 v[36:39], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_1:
		s_andn2_b64 exec, s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_1
		v_mov_b32_e32 v36, v28
		v_mov_b32_e32 v37, v29
		v_mov_b32_e32 v38, v30
		v_mov_b32_e32 v39, v31
.L_attn_fwd_persistent.exec_endif_1:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s23, s12, 7
		s_add_i32 s23, s23, s19
		s_add_i32 s23, s23, s22
		s_add_i32 s23, s23, s28
		v_lshl_add_u32 v3, v17, 1, s23
		v_accvgpr_read_b32 v15, a15
		v_lshl_add_u32 v3, v15, 4, v3
		v_accvgpr_read_b32 v15, a16
		v_lshl_add_u32 v3, v15, 6, v3
		v_accvgpr_read_b32 v15, a17
		v_lshl_add_u32 v3, v15, 5, v3
		v_cmp_lt_i32_e64 vcc, v20, s20
		s_and_saveexec_b64 s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_2
		buffer_load_dwordx4 v[40:43], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_2:
		s_andn2_b64 exec, s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_2
		v_mov_b32_e32 v40, v28
		v_mov_b32_e32 v41, v29
		v_mov_b32_e32 v42, v30
		v_mov_b32_e32 v43, v31
.L_attn_fwd_persistent.exec_endif_2:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s23, 0xc0, s12
		s_add_i32 s23, s23, s19
		s_add_i32 s23, s23, s22
		s_add_i32 s23, s23, s28
		v_lshl_add_u32 v3, v17, 1, s23
		v_accvgpr_read_b32 v15, a15
		v_lshl_add_u32 v3, v15, 4, v3
		v_accvgpr_read_b32 v15, a16
		v_lshl_add_u32 v3, v15, 6, v3
		v_accvgpr_read_b32 v15, a17
		v_lshl_add_u32 v3, v15, 5, v3
		v_cmp_lt_i32_e64 vcc, v21, s20
		s_and_saveexec_b64 s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_3
		buffer_load_dwordx4 v[44:47], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_3:
		s_andn2_b64 exec, s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_3
		v_mov_b32_e32 v44, v28
		v_mov_b32_e32 v45, v29
		v_mov_b32_e32 v46, v30
		v_mov_b32_e32 v47, v31
.L_attn_fwd_persistent.exec_endif_3:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s23, s12, 8
		s_add_i32 s23, s23, s19
		s_add_i32 s23, s23, s22
		s_add_i32 s23, s23, s28
		v_lshl_add_u32 v3, v17, 1, s23
		v_accvgpr_read_b32 v15, a15
		v_lshl_add_u32 v3, v15, 4, v3
		v_accvgpr_read_b32 v15, a16
		v_lshl_add_u32 v3, v15, 6, v3
		v_accvgpr_read_b32 v15, a17
		v_lshl_add_u32 v3, v15, 5, v3
		v_cmp_lt_i32_e64 vcc, v22, s20
		s_and_saveexec_b64 s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_4
		buffer_load_dwordx4 v[48:51], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_4:
		s_andn2_b64 exec, s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_4
		v_mov_b32_e32 v48, v28
		v_mov_b32_e32 v49, v29
		v_mov_b32_e32 v50, v30
		v_mov_b32_e32 v51, v31
.L_attn_fwd_persistent.exec_endif_4:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s23, 0x140, s12
		s_add_i32 s23, s23, s19
		s_add_i32 s23, s23, s22
		s_add_i32 s23, s23, s28
		v_lshl_add_u32 v3, v17, 1, s23
		v_accvgpr_read_b32 v15, a15
		v_lshl_add_u32 v3, v15, 4, v3
		v_accvgpr_read_b32 v15, a16
		v_lshl_add_u32 v3, v15, 6, v3
		v_accvgpr_read_b32 v15, a17
		v_lshl_add_u32 v3, v15, 5, v3
		v_cmp_lt_i32_e64 vcc, v23, s20
		s_and_saveexec_b64 s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_5
		buffer_load_dwordx4 v[20:23], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_5:
		s_andn2_b64 exec, s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_5
		v_mov_b32_e32 v20, v28
		v_mov_b32_e32 v21, v29
		v_mov_b32_e32 v22, v30
		v_mov_b32_e32 v23, v31
.L_attn_fwd_persistent.exec_endif_5:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s23, 0x180, s12
		s_add_i32 s23, s23, s19
		s_add_i32 s23, s23, s22
		s_add_i32 s23, s23, s28
		v_lshl_add_u32 v3, v17, 1, s23
		v_accvgpr_read_b32 v15, a15
		v_lshl_add_u32 v3, v15, 4, v3
		v_accvgpr_read_b32 v15, a16
		v_lshl_add_u32 v3, v15, 6, v3
		v_accvgpr_read_b32 v15, a17
		v_lshl_add_u32 v3, v15, 5, v3
		v_cmp_lt_i32_e64 vcc, v24, s20
		s_and_saveexec_b64 s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_6
		buffer_load_dwordx4 v[24:27], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_6:
		s_andn2_b64 exec, s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_6
		v_mov_b32_e32 v24, v28
		v_mov_b32_e32 v25, v29
		v_mov_b32_e32 v26, v30
		v_mov_b32_e32 v27, v31
.L_attn_fwd_persistent.exec_endif_6:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s23, 0x1c0, s12
		s_add_i32 s19, s23, s19
		s_add_i32 s19, s19, s22
		s_add_i32 s19, s19, s28
		v_lshl_add_u32 v3, v17, 1, s19
		v_accvgpr_read_b32 v15, a15
		v_lshl_add_u32 v3, v15, 4, v3
		v_accvgpr_read_b32 v15, a16
		v_lshl_add_u32 v3, v15, 6, v3
		v_accvgpr_read_b32 v15, a17
		v_lshl_add_u32 v3, v15, 5, v3
		v_cmp_lt_i32_e64 vcc, v5, s20
		s_and_saveexec_b64 s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_7
		buffer_load_dwordx4 v[52:55], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_7:
		s_andn2_b64 exec, s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_7
		v_mov_b32_e32 v52, v28
		v_mov_b32_e32 v53, v29
		v_mov_b32_e32 v54, v30
		v_mov_b32_e32 v55, v31
.L_attn_fwd_persistent.exec_endif_7:
		s_mov_b64 exec, s[100:101]
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
		v_accvgpr_read_b32 v3, a12
		v_and_b32_e32 v3, 1, v3
		v_lshlrev_b32_e32 v3, 2, v3
		v_and_b32_e32 v5, 1, v7
		v_accvgpr_write_b32 a18, v5
		v_accvgpr_read_b32 v5, a18
		v_lshlrev_b32_e32 v5, 1, v5
		v_and_b32_e32 v7, 1, v11
		v_accvgpr_write_b32 a19, v7
		v_accvgpr_read_b32 v7, a19
		v_xor_b32_e32 v7, v0, v7
		v_bitop3_b32 v3, v3, v5, v7 bitop3:0x96
		v_lshlrev_b32_e32 v3, 4, v3
		v_add_u32_e32 v3, 0x10000, v3
		ds_write_b128 v3, v[32:35] offset:2480
		ds_write_b128 v3, v[36:39] offset:6576
		ds_write_b128 v3, v[40:43] offset:10672
		ds_write_b128 v3, v[44:47] offset:14768
		v_mov_b32_e32 v5, 32
		v_mul_lo_u32 v5, v5, v12
		v_mov_b32_e32 v7, 2
		v_mul_lo_u32 v7, v7, v16
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v11, a12
		v_lshlrev_b32_e32 v11, 12, v11
		v_add_u32_e32 v11, 0x10000, v11
		v_and_b32_e32 v12, 63, v0
		v_lshrrev_b32_e32 v15, 3, v12
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v16, 6, v15
		v_add_u32_e32 v17, v11, v16
		v_lshrrev_b32_e32 v18, 2, v12
		v_and_b32_e32 v18, 1, v18
		v_lshlrev_b32_e32 v19, 5, v18
		v_add_u32_e32 v28, v17, v19
		v_lshrrev_b32_e32 v29, 5, v12
		v_accvgpr_write_b32 a20, v29
		v_lshrrev_b32_e32 v29, 4, v12
		v_and_b32_e32 v29, 1, v29
		v_lshlrev_b32_e32 v29, 7, v29
		v_lshrrev_b32_e32 v30, 1, v12
		v_and_b32_e32 v30, 1, v30
		v_lshlrev_b32_e32 v31, 4, v30
		v_and_b32_e32 v32, 1, v12
		v_lshlrev_b32_e32 v32, 3, v32
		v_accvgpr_read_b32 v33, a20
		v_add3_u32 v33, v33, v29, v16
		v_add3_u32 v33, v33, v19, v31
		v_add_u32_e32 v34, v32, v33
		v_xor_b32_e32 v34, v34, v30
		v_lshl_add_u32 v28, v34, 4, v28
		ds_read_b128 a[24:27], v28 offset:2480
		v_lshlrev_b32_e32 v18, 1, v18
		v_add3_u32 v34, v32, v33, 2
		v_bitop3_b32 v34, v18, v34, v30 bitop3:0x96
		v_lshl_add_u32 v17, v34, 4, v17
		ds_read_b128 a[28:31], v17 offset:2480
		v_add3_u32 v33, v32, v33, 4
		v_xad_u32 v33, v33, v30, v18
		v_lshlrev_b32_e32 v15, 2, v15
		v_xor_b32_e32 v33, v33, v15
		v_lshl_add_u32 v33, v33, 4, v11
		ds_read_b128 a[32:35], v33 offset:2480
		v_accvgpr_read_b32 v34, a20
		v_add3_u32 v29, 6, v34, v29
		v_add3_u32 v16, v29, v16, v19
		v_add3_u32 v16, v16, v31, v32
		v_xor_b32_e32 v16, v16, v30
		v_bitop3_b32 v15, v15, v18, v16 bitop3:0x96
		v_lshl_add_u32 v11, v15, 4, v11
		ds_read_b128 a[36:39], v11 offset:2480
		v_and_b32_e32 v8, 1, v8
		v_accvgpr_write_b32 a21, v8
		v_and_b32_e32 v8, 31, v12
		v_and_b32_e32 v4, 3, v4
		v_mov_b32_e32 v12, 0x440
		v_mul_lo_u32 v12, v12, v4
		v_accvgpr_write_b32 a22, v12
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v3, v[48:51] offset:2480
		ds_write_b128 v3, v[20:23] offset:6576
		ds_write_b128 v3, v[24:27] offset:10672
		ds_write_b128 v3, v[52:55] offset:14768
		v_accvgpr_read_b32 v3, a11
		s_nop 0
		v_readfirstlane_b32 s19, v3
		s_add_i32 s19, s19, 1
		s_mul_i32 s19, s19, 0x100
		s_mov_b32 s22, 0x7f
		v_readfirstlane_b32 s24, v0
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[40:43], v28 offset:2480
		ds_read_b128 a[44:47], v17 offset:2480
		ds_read_b128 a[48:51], v33 offset:2480
		ds_read_b128 a[52:55], v11 offset:2480
		v_cmp_lt_i32_e64 s[36:37], v6, s20
		s_nop 1
		v_mov_b32_e32 v16, s36
		v_mov_b32_e32 v17, s37
		v_accvgpr_write_b32 a56, v16
		v_accvgpr_write_b32 a57, v17
		v_cmp_lt_i32_e64 s[36:37], v2, s20
		s_nop 1
		v_mov_b32_e32 v2, s36
		v_mov_b32_e32 v3, s37
		v_accvgpr_write_b32 a58, v2
		v_accvgpr_write_b32 a59, v3
		v_accvgpr_read_b32 v2, a5
		s_nop 0
		v_readfirstlane_b32 s23, v2
		s_add_i32 s19, s19, s23
		s_cmp_lt_i32 s21, s19
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_cselect_b32 s19, s21, s19
		s_add_i32 s23, s19, 0x7f
		s_cmp_lt_i32 s23, 0
		s_cselect_b32 s25, s22, 0
		s_add_i32 s23, s23, s25
		s_ashr_i32 s23, s23, 7
		v_accvgpr_read_b32 v2, a5
		s_nop 0
		v_readfirstlane_b32 s25, v2
		s_add_i32 s25, s1, s25
		s_cmp_lt_i32 s25, 0
		s_cselect_b32 s36, s22, 0
		s_add_i32 s25, s25, s36
		s_ashr_i32 s25, s25, 7
		s_cmp_lt_i32 s25, s23
		s_cselect_b32 s25, s25, s23
		s_cmp_gt_i32 s25, 0
		s_cselect_b32 s25, s25, 0
		v_mov_b32_e32 v2, 64
		v_mul_lo_u32 v2, v2, v9
		v_mov_b32_e32 v3, 16
		v_mul_lo_u32 v3, v3, v10
		v_bitop3_b32 v4, v2, v5, v3 bitop3:0x96
		v_bitop3_b32 v4, v4, v14, v7 bitop3:0x96
		v_accvgpr_write_b32 a23, v4
		v_bitop3_b32 v4, 4, v2, v5 bitop3:0x96
		v_xor_b32_e32 v4, v4, v3
		v_bitop3_b32 v6, 8, v2, v5 bitop3:0x96
		v_xor_b32_e32 v6, v6, v3
		v_bitop3_b32 v2, 12, v2, v5 bitop3:0x96
		v_xor_b32_e32 v2, v2, v3
		v_accvgpr_read_b32 v3, a23
		v_cmp_lt_i32_e64 s[36:37], v3, s21
		v_mov_b32_e32 v3, 16
		v_mul_lo_u32 v3, v3, v9
		v_mov_b32_e32 v9, 64
		v_mul_lo_u32 v9, v9, v10
		v_bitop3_b32 v10, v3, v5, v9 bitop3:0x96
		v_bitop3_b32 v10, v10, v14, v7 bitop3:0x96
		v_accvgpr_write_b32 a60, v10
		v_bitop3_b32 v10, 4, v3, v5 bitop3:0x96
		v_xor_b32_e32 v10, v10, v9
		v_bitop3_b32 v11, 8, v3, v5 bitop3:0x96
		v_xor_b32_e32 v11, v11, v9
		v_bitop3_b32 v3, 12, v3, v5 bitop3:0x96
		v_xor_b32_e32 v3, v3, v9
		v_accvgpr_read_b32 v5, a60
		v_cmp_lt_i32_e64 vcc, v5, s21
		v_accvgpr_read_b32 v5, a12
		v_mul_lo_u32 v5, s15, v5
		v_accvgpr_read_b32 v9, a18
		v_mul_lo_u32 v9, s15, v9
		v_lshlrev_b32_e32 v9, 5, v9
		v_lshl_add_u32 v5, v5, 1, v9
		v_accvgpr_read_b32 v9, a19
		v_mul_lo_u32 v9, s15, v9
		v_lshl_add_u32 v5, v9, 6, v5
		v_accvgpr_read_b32 v9, a21
		v_mul_lo_u32 v9, s15, v9
		v_lshlrev_b32_e32 v9, 7, v9
		v_accvgpr_read_b32 v12, a15
		v_lshlrev_b32_e32 v12, 4, v12
		v_add3_u32 v5, v5, v9, v12
		v_accvgpr_read_b32 v9, a16
		v_lshlrev_b32_e32 v9, 6, v9
		v_accvgpr_read_b32 v15, a17
		v_lshlrev_b32_e32 v15, 5, v15
		v_add3_u32 v5, v5, v9, v15
		v_readfirstlane_b32 s38, v1
		s_mul_i32 s38, s38, s13
		s_lshl_b32 s38, s38, 1
		v_accvgpr_read_b32 v16, a10
		s_nop 0
		v_readfirstlane_b32 s39, v16
		s_mul_i32 s39, s39, s14
		s_lshl_b32 s39, s39, 1
		s_add_i32 s40, s38, s39
		v_add_u32_e32 v16, s40, v5
		v_mov_b32_e32 v17, 0x80000000
		v_cndmask_b32_e64 v16, v17, v16, s[36:37]
		s_lshr_b32 s40, s24, 6
		s_mul_i32 s41, 0x410, s40
		s_mov_b32 m0, s41
		v_bitop3_b32 v4, v4, v14, v7 bitop3:0x96
		v_accvgpr_write_b32 a61, v4
		buffer_load_dwordx4 v16, s[28:31], 0 offen lds
		s_lshl_b32 s42, s15, 3
		s_add_i32 s42, s42, s38
		s_add_i32 s42, s42, s39
		v_add_u32_e32 v4, s42, v5
		v_cndmask_b32_e64 v4, v17, v4, s[36:37]
		s_add_i32 m0, m0, 0x1040
		v_bitop3_b32 v6, v6, v14, v7 bitop3:0x96
		v_accvgpr_write_b32 a62, v6
		buffer_load_dwordx4 v4, s[28:31], 0 offen lds
		s_lshl_b32 s42, s15, 4
		s_add_i32 s42, s42, s38
		s_add_i32 s42, s42, s39
		v_add_u32_e32 v4, s42, v5
		v_cndmask_b32_e64 v4, v17, v4, s[36:37]
		s_add_i32 m0, m0, 0x1040
		s_mul_i32 s40, 0x440, s40
		buffer_load_dwordx4 v4, s[28:31], 0 offen lds
		s_mul_i32 s42, 24, s15
		s_add_i32 s42, s42, s38
		s_add_i32 s42, s42, s39
		v_add_u32_e32 v4, s42, v5
		v_cndmask_b32_e64 v4, v17, v4, s[36:37]
		s_add_i32 m0, m0, 0x1040
		v_bitop3_b32 v2, v2, v14, v7 bitop3:0x96
		v_accvgpr_write_b32 a63, v2
		buffer_load_dwordx4 v4, s[28:31], 0 offen lds
		v_accvgpr_read_b32 v2, a12
		v_mul_lo_u32 v2, s17, v2
		v_accvgpr_read_b32 v4, a18
		v_mul_lo_u32 v4, s17, v4
		v_lshlrev_b32_e32 v4, 7, v4
		v_lshl_add_u32 v2, v2, 1, v4
		v_accvgpr_read_b32 v4, a19
		v_mul_lo_u32 v4, s17, v4
		v_lshl_add_u32 v2, v4, 6, v2
		v_accvgpr_read_b32 v4, a21
		v_mul_lo_u32 v4, s17, v4
		v_lshlrev_b32_e32 v4, 5, v4
		v_add3_u32 v2, v2, v4, v12
		v_add3_u32 v2, v2, v9, v15
		v_accvgpr_read_b32 v4, a0
		s_nop 0
		v_readfirstlane_b32 s36, v4
		v_readfirstlane_b32 s37, v1
		s_mul_i32 s36, s37, s36
		s_lshl_b32 s36, s36, 1
		v_accvgpr_read_b32 v4, a1
		s_nop 0
		v_readfirstlane_b32 s37, v4
		v_accvgpr_read_b32 v4, a10
		s_nop 0
		v_readfirstlane_b32 s42, v4
		s_mul_i32 s37, s42, s37
		s_lshl_b32 s37, s37, 1
		s_add_i32 s42, s36, s37
		v_add_u32_e32 v4, s42, v2
		v_cndmask_b32_e32 v4, v17, v4, vcc
		s_add_i32 m0, s40, 0x81f0
		v_bitop3_b32 v6, v10, v14, v7 bitop3:0x96
		v_accvgpr_write_b32 a64, v6
		buffer_load_dwordx4 v4, s[32:35], 0 offen lds
		s_lshl_b32 s42, s17, 3
		s_add_i32 s42, s42, s36
		s_add_i32 s42, s42, s37
		v_add_u32_e32 v4, s42, v2
		v_cndmask_b32_e32 v4, v17, v4, vcc
		s_add_i32 m0, m0, 0x1100
		v_bitop3_b32 v6, v11, v14, v7 bitop3:0x96
		v_accvgpr_write_b32 a65, v6
		buffer_load_dwordx4 v4, s[32:35], 0 offen lds
		s_lshl_b32 s42, s17, 4
		s_add_i32 s42, s42, s36
		s_add_i32 s42, s42, s37
		v_add_u32_e32 v4, s42, v2
		v_cndmask_b32_e32 v4, v17, v4, vcc
		s_add_i32 m0, m0, 0x1100
		v_bitop3_b32 v3, v3, v14, v7 bitop3:0x96
		v_accvgpr_write_b32 a66, v3
		buffer_load_dwordx4 v4, s[32:35], 0 offen lds
		s_mul_i32 s42, 24, s17
		s_add_i32 s42, s42, s36
		s_add_i32 s42, s42, s37
		v_add_u32_e32 v3, s42, v2
		v_cndmask_b32_e32 v3, v17, v3, vcc
		s_add_i32 m0, m0, 0x1100
		s_mul_i32 s42, s25, 0x80
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
		v_mbcnt_lo_u32_b32 v3, -1, 0
		v_mbcnt_hi_u32_b32 v3, -1, v3
		v_and_b32_e32 v4, 1, v3
		v_lshrrev_b32_e32 v6, 4, v3
		v_and_b32_e32 v6, 1, v6
		v_lshlrev_b32_e32 v6, 4, v6
		v_lshrrev_b32_e32 v7, 3, v3
		v_and_b32_e32 v7, 1, v7
		v_lshlrev_b32_e32 v7, 3, v7
		v_add3_u32 v9, v4, v6, v7
		v_lshrrev_b32_e32 v10, 2, v3
		v_and_b32_e32 v10, 1, v10
		v_lshlrev_b32_e32 v10, 2, v10
		v_lshrrev_b32_e32 v3, 1, v3
		v_and_b32_e32 v3, 1, v3
		v_lshlrev_b32_e32 v3, 1, v3
		v_add3_u32 v9, v9, v10, v3
		v_add_u32_e32 v4, 32, v4
		v_bitop3_b32 v3, v10, v4, v3 bitop3:0x96
		v_bitop3_b32 v3, v6, v7, v3 bitop3:0x96
		v_mov_b32_e32 v6, 0x3e38aa3b
		v_mov_b32_e32 v7, 0x3e38aa3b
		s_mov_b32 s25, 0xff800000
		v_mov_b32_e32 v4, s25
		v_mov_b32_e32 v10, s25
		s_mov_b32 s25, 1.0
		v_mov_b32_e32 v14, s25
		v_mov_b32_e32 v15, s25
		s_mov_b32 s25, 0
		v_accvgpr_read_b32 v11, a20
		v_lshlrev_b32_e32 v11, 4, v11
		v_accvgpr_write_b32 a67, v11
		v_lshrrev_b32_e32 v11, 4, v8
		v_lshlrev_b32_e32 v11, 9, v11
		v_accvgpr_write_b32 a68, v11
		v_lshrrev_b32_e32 v11, 3, v8
		v_and_b32_e32 v11, 1, v11
		v_mov_b32_e32 v12, 0x2080
		v_mul_lo_u32 v12, v12, v11
		v_accvgpr_write_b32 a69, v12
		v_lshrrev_b32_e32 v11, 2, v8
		v_and_b32_e32 v11, 1, v11
		v_mov_b32_e32 v12, 0x1040
		v_mul_lo_u32 v12, v12, v11
		v_accvgpr_write_b32 a70, v12
		v_lshrrev_b32_e32 v11, 1, v8
		v_and_b32_e32 v11, 1, v11
		v_mov_b32_e32 v12, 0x820
		v_mul_lo_u32 v12, v12, v11
		v_accvgpr_write_b32 a71, v12
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v11, 0x410
		v_mul_lo_u32 v11, v11, v8
		v_accvgpr_write_b32 a72, v11
		v_and_b32_e32 v8, 3, v0
		v_accvgpr_write_b32 a73, v8
		v_accvgpr_read_b32 v8, a73
		v_lshlrev_b32_e32 v8, 3, v8
		v_accvgpr_write_b32 a74, v8
		v_accvgpr_read_b32 v8, a18
		v_mov_b32_e32 v11, 0x2200
		v_mul_lo_u32 v11, v11, v8
		v_accvgpr_write_b32 a75, v11
		v_accvgpr_read_b32 v8, a19
		v_lshlrev_b32_e32 v8, 5, v8
		v_accvgpr_write_b32 a76, v8
		s_lshl_b32 s43, s15, 8
		s_add_i32 s43, s43, s38
		s_add_i32 s43, s43, s39
		s_mul_i32 s44, 0x108, s15
		s_add_i32 s44, s44, s38
		s_add_i32 s44, s44, s39
		s_mul_i32 s45, 0x110, s15
		s_add_i32 s45, s45, s38
		s_add_i32 s45, s45, s39
		s_mul_i32 s46, 0x118, s15
		s_add_i32 s38, s46, s38
		s_add_i32 s38, s38, s39
		s_lshl_b32 s39, s17, 8
		s_add_i32 s39, s39, s36
		s_add_i32 s39, s39, s37
		s_mul_i32 s46, 0x108, s17
		s_add_i32 s46, s46, s36
		s_add_i32 s46, s46, s37
		s_mul_i32 s47, 0x110, s17
		s_add_i32 s47, s47, s36
		s_add_i32 s47, s47, s37
		s_mul_i32 s48, 0x118, s17
		s_add_i32 s36, s48, s36
		s_add_i32 s36, s36, s37
		v_lshlrev_b32_e32 v8, 2, v9
		v_accvgpr_write_b32 a77, v8
		v_lshlrev_b32_e32 v3, 2, v3
		v_accvgpr_write_b32 a78, v3
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
		s_lshr_b32 s37, s25, 7
		s_and_b32 s48, s37, 1
		s_mul_i32 s49, 0x4100, s48
		v_accvgpr_read_b32 v3, a67
		v_accvgpr_read_b32 v8, a68
		v_add3_u32 v3, s49, v3, v8
		v_accvgpr_read_b32 v8, a69
		v_accvgpr_read_b32 v9, a70
		v_add3_u32 v3, v3, v8, v9
		v_accvgpr_read_b32 v8, a71
		v_accvgpr_read_b32 v9, a72
		v_add3_u32 v3, v3, v8, v9
		ds_read_b128 v[20:23], v3
		ds_read_b128 v[24:27], v3 offset:32
		ds_read_b128 v[28:31], v3 offset:64
		ds_read_b128 a[80:83], v3 offset:96
		ds_read_b128 v[96:99], v3 offset:256
		ds_read_b128 v[100:103], v3 offset:288
		ds_read_b128 v[104:107], v3 offset:320
		ds_read_b128 a[84:87], v3 offset:352
		ds_read_b128 v[108:111], v3 offset:128
		ds_read_b128 v[112:115], v3 offset:160
		ds_read_b128 v[116:119], v3 offset:192
		ds_read_b128 a[88:91], v3 offset:224
		ds_read_b128 v[120:123], v3 offset:384
		ds_read_b128 a[92:95], v3 offset:416
		ds_read_b128 a[96:99], v3 offset:448
		ds_read_b128 a[100:103], v3 offset:480
		s_mul_i32 s48, 0x4400, s48
		v_accvgpr_read_b32 v3, a74
		v_accvgpr_read_b32 v8, a75
		v_add3_u32 v3, s48, v3, v8
		v_accvgpr_read_b32 v8, a22
		v_accvgpr_read_b32 v9, a76
		v_add3_u32 v3, v3, v9, v8
		ds_read_b64_tr_b16 a[104:105], v3 offset:33264
		ds_read_b64_tr_b16 a[106:107], v3 offset:37616
		ds_read_b64_tr_b16 a[108:109], v3 offset:33392
		ds_read_b64_tr_b16 a[110:111], v3 offset:37744
		ds_read_b64_tr_b16 a[112:113], v3 offset:33520
		ds_read_b64_tr_b16 a[114:115], v3 offset:37872
		ds_read_b64_tr_b16 a[116:117], v3 offset:33648
		ds_read_b64_tr_b16 a[118:119], v3 offset:38000
		ds_read_b64_tr_b16 a[120:121], v3 offset:33776
		ds_read_b64_tr_b16 a[122:123], v3 offset:38128
		ds_read_b64_tr_b16 a[124:125], v3 offset:33904
		ds_read_b64_tr_b16 a[126:127], v3 offset:38256
		ds_read_b64_tr_b16 a[128:129], v3 offset:34032
		ds_read_b64_tr_b16 a[130:131], v3 offset:38384
		ds_read_b64_tr_b16 a[132:133], v3 offset:34160
		ds_read_b64_tr_b16 a[134:135], v3 offset:38512
		ds_read_b64_tr_b16 a[136:137], v3 offset:33328
		ds_read_b64_tr_b16 a[138:139], v3 offset:37680
		ds_read_b64_tr_b16 a[140:141], v3 offset:33456
		ds_read_b64_tr_b16 a[142:143], v3 offset:37808
		ds_read_b64_tr_b16 a[144:145], v3 offset:33584
		ds_read_b64_tr_b16 a[146:147], v3 offset:37936
		ds_read_b64_tr_b16 a[148:149], v3 offset:33712
		ds_read_b64_tr_b16 a[150:151], v3 offset:38064
		ds_read_b64_tr_b16 a[152:153], v3 offset:33840
		ds_read_b64_tr_b16 a[154:155], v3 offset:38192
		ds_read_b64_tr_b16 a[156:157], v3 offset:33968
		ds_read_b64_tr_b16 a[158:159], v3 offset:38320
		ds_read_b64_tr_b16 a[160:161], v3 offset:34096
		ds_read_b64_tr_b16 a[162:163], v3 offset:38448
		ds_read_b64_tr_b16 a[164:165], v3 offset:34224
		ds_read_b64_tr_b16 a[166:167], v3 offset:38576
		s_mul_i32 s48, s15, s25
		s_lshl_b32 s48, s48, 1
		s_add_i32 s49, s43, s48
		v_add_u32_e32 v3, s49, v5
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v8, s48, v5
		s_add_i32 s37, s37, 1
		v_add_u32_e32 v9, s44, v8
		s_and_b32 s37, s37, 1
		v_add_u32_e32 v11, s45, v8
		s_mul_i32 s48, 0x4100, s37
		v_add_u32_e32 v8, s38, v8
		s_add_i32 s48, s41, s48
		v_mfma_f32_32x32x16_bf16 v[128:143], v[20:23], a[24:27], 0
		s_mov_b32 m0, s48
		v_mfma_f32_32x32x16_bf16 v[128:143], v[24:27], a[28:31], v[128:143]
		s_mul_i32 s48, s17, s25
		v_mfma_f32_32x32x16_bf16 v[128:143], v[28:31], a[32:35], v[128:143]
		s_add_i32 s25, s25, 0x80
		v_mfma_f32_32x32x16_bf16 v[144:159], v[20:23], a[40:43], 0
		v_accvgpr_read_b32 v12, a23
		v_add_u32_e32 v12, s25, v12
		v_mfma_f32_32x32x16_bf16 v[144:159], v[24:27], a[44:47], v[144:159]
		v_accvgpr_read_b32 v16, a61
		v_add_u32_e32 v16, s25, v16
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[48:51], v[144:159]
		v_accvgpr_read_b32 v18, a62
		v_add_u32_e32 v18, s25, v18
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], a[24:27], 0
		v_accvgpr_read_b32 v19, a63
		v_add_u32_e32 v19, s25, v19
		v_mfma_f32_32x32x16_bf16 v[160:175], v[100:103], a[28:31], v[160:175]
		v_cmp_lt_i32_e64 s[50:51], v12, s21
		v_mfma_f32_32x32x16_bf16 v[160:175], v[104:107], a[32:35], v[160:175]
		v_accvgpr_read_b32 v12, a60
		v_add_u32_e32 v12, s25, v12
		v_mfma_f32_32x32x16_bf16 v[176:191], v[96:99], a[40:43], 0
		v_accvgpr_read_b32 v20, a64
		v_add_u32_e32 v20, s25, v20
		v_mfma_f32_32x32x16_bf16 v[176:191], v[100:103], a[44:47], v[176:191]
		v_accvgpr_read_b32 v21, a65
		v_add_u32_e32 v21, s25, v21
		v_mfma_f32_32x32x16_bf16 v[176:191], v[104:107], a[48:51], v[176:191]
		v_cmp_lt_i32_e64 s[52:53], v12, s21
		v_mfma_f32_32x32x16_bf16 v[192:207], v[108:111], a[24:27], 0
		v_cndmask_b32_e64 v3, v17, v3, s[50:51]
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[192:207], v[112:115], a[28:31], v[192:207]
		v_cmp_lt_i32_e64 s[50:51], v16, s21
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[54:55], v18, s21
		v_mfma_f32_32x32x16_bf16 v[192:207], v[116:119], a[32:35], v[192:207]
		v_cndmask_b32_e64 v3, v17, v9, s[50:51]
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[208:223], v[108:111], a[40:43], 0
		v_cndmask_b32_e64 v3, v17, v11, s[54:55]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[112:115], a[44:47], v[208:223]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_32x32x16_bf16 v[208:223], v[116:119], a[48:51], v[208:223]
		v_cmp_lt_i32_e64 s[50:51], v19, s21
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_accvgpr_read_b32 v3, a66
		v_add_u32_e32 v3, s25, v3
		v_mfma_f32_32x32x16_bf16 v[96:111], v[120:123], a[24:27], 0
		v_cndmask_b32_e64 v8, v17, v8, s[50:51]
		v_cmp_lt_i32_e64 s[50:51], v20, s21
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s48, s48, 1
		buffer_load_dwordx4 v8, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v21, s21
		s_add_i32 s49, s39, s48
		v_mfma_f32_32x32x16_bf16 v[96:111], a[92:95], a[28:31], v[96:111]
		v_add_u32_e32 v8, s49, v2
		v_mfma_f32_32x32x16_bf16 v[96:111], a[96:99], a[32:35], v[96:111]
		v_cndmask_b32_e64 v8, v17, v8, s[52:53]
		v_cmp_lt_i32_e64 vcc, v3, s21
		s_mul_i32 s37, 0x4400, s37
		v_add_u32_e32 v3, s48, v2
		s_add_i32 s37, s40, s37
		v_add_u32_e32 v9, s46, v3
		s_add_i32 m0, s37, 0x81f0
		v_cndmask_b32_e64 v9, v17, v9, s[50:51]
		buffer_load_dwordx4 v8, s[32:35], 0 offen lds
		v_add_u32_e32 v8, s47, v3
		v_cndmask_b32_e64 v8, v17, v8, s[54:55]
		s_add_i32 m0, m0, 0x1100
		v_add_u32_e32 v3, s36, v3
		v_cndmask_b32_e32 v3, v17, v3, vcc
		buffer_load_dwordx4 v9, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], v[120:123], a[40:43], 0
		s_add_i32 m0, m0, 0x1100
		v_mfma_f32_32x32x16_bf16 v[224:239], a[92:95], a[44:47], v[224:239]
		buffer_load_dwordx4 v8, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], a[96:99], a[48:51], v[224:239]
		s_add_i32 m0, m0, 0x1100
		s_cmp_lt_i32 s25, s42
		v_mfma_f32_32x32x16_bf16 v[128:143], a[80:83], a[36:39], v[128:143]
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[160:175], a[84:87], a[36:39], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[88:91], a[36:39], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[100:103], a[36:39], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[100:103], a[52:55], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[80:83], a[52:55], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[84:87], a[52:55], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[88:91], a[52:55], v[208:223]
		s_nop 3
		v_max3_f32 v3, v128, v129, v130
		v_max3_f32 v8, v132, v133, v134
		v_max3_f32 v9, v136, v137, v138
		v_max3_f32 v11, v140, v141, v142
		v_max3_f32 v12, v160, v161, v162
		v_max3_f32 v16, v164, v165, v166
		v_max3_f32 v18, v168, v169, v170
		v_max3_f32 v19, v172, v173, v174
		v_max3_f32 v20, v192, v193, v194
		v_max3_f32 v21, v196, v197, v198
		v_max3_f32 v22, v200, v201, v202
		v_max3_f32 v23, v204, v205, v206
		v_max3_f32 v24, v96, v97, v98
		v_max3_f32 v25, v100, v101, v102
		v_max3_f32 v26, v104, v105, v106
		v_max3_f32 v27, v108, v109, v110
		v_max3_f32 v3, v3, v131, v8
		v_max3_f32 v8, v9, v139, v11
		v_max3_f32 v9, v12, v163, v16
		v_max3_f32 v11, v18, v171, v19
		v_max3_f32 v12, v20, v195, v21
		v_max3_f32 v16, v22, v203, v23
		v_max3_f32 v18, v24, v99, v25
		v_max3_f32 v19, v26, v107, v27
		v_max3_f32 v3, v3, v135, v8
		v_max3_f32 v8, v9, v167, v11
		v_max3_f32 v9, v12, v199, v16
		v_max3_f32 v11, v18, v103, v19
		v_max3_f32 v3, v3, v143, v8
		v_max3_f32 v8, v9, v207, v11
		v_max3_f32 v3, v3, v175, v8
		v_max_f32_e32 v8, v3, v111
		v_mov_b32_e32 v9, v8
		v_max3_f32 v3, v144, v145, v146
		v_max3_f32 v11, v148, v149, v150
		v_max3_f32 v12, v152, v153, v154
		v_max3_f32 v16, v156, v157, v158
		v_max3_f32 v18, v176, v177, v178
		v_max3_f32 v19, v180, v181, v182
		v_max3_f32 v20, v184, v185, v186
		v_max3_f32 v21, v188, v189, v190
		v_max3_f32 v22, v208, v209, v210
		v_max3_f32 v23, v212, v213, v214
		v_max3_f32 v24, v216, v217, v218
		v_max3_f32 v25, v220, v221, v222
		v_max3_f32 v26, v224, v225, v226
		v_max3_f32 v27, v228, v229, v230
		v_max3_f32 v28, v232, v233, v234
		v_max3_f32 v29, v236, v237, v238
		v_permlane32_swap_b32_e32 v8, v9
		v_max3_f32 v3, v3, v147, v11
		v_max3_f32 v11, v12, v155, v16
		v_max3_f32 v12, v18, v179, v19
		v_max3_f32 v16, v20, v187, v21
		v_max3_f32 v18, v22, v211, v23
		v_max3_f32 v19, v24, v219, v25
		v_max3_f32 v20, v26, v227, v27
		v_max3_f32 v21, v28, v235, v29
		v_max3_f32 v3, v3, v151, v11
		v_max3_f32 v11, v12, v183, v16
		v_max3_f32 v12, v18, v215, v19
		v_max3_f32 v16, v20, v231, v21
		v_max3_f32 v3, v3, v159, v11
		v_max3_f32 v11, v12, v223, v16
		v_max3_f32 v3, v3, v191, v11
		v_max_f32_e32 v18, v3, v239
		v_mov_b32_e32 v19, v18
		v_max_f32_e32 v20, v8, v9
		v_mov_b32_e32 v8, v4
		v_permlane32_swap_b32_e32 v18, v19
		v_max_f32_e32 v21, v18, v19
		v_pk_mul_f32 v[18:19], v[20:21], v[6:7]
		v_max_f32_e32 v20, v4, v18
		v_max_f32_e32 v22, v10, v19
		v_mov_b32_e32 v21, v20
		v_pk_fma_f32 v[18:19], v[128:129], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[130:131], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[132:133], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[134:135], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[136:137], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[138:139], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[140:141], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[142:143], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[160:161], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[162:163], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[164:165], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[166:167], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[168:169], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[170:171], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[172:173], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[174:175], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[192:193], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[194:195], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[196:197], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[198:199], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[200:201], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[202:203], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[204:205], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[206:207], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[96:97], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[98:99], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[108:109], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[110:111], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_mov_b32_e32 v23, v22
		v_pk_fma_f32 v[110:111], v[144:145], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[146:147], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[148:149], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[150:151], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[154:155], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[156:157], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[158:159], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[176:177], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[178:179], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[180:181], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[182:183], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[184:185], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[186:187], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[188:189], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[190:191], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[208:209], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[210:211], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[212:213], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[214:215], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[216:217], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[218:219], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[220:221], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[222:223], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[224:225], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[226:227], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[228:229], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[230:231], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[232:233], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[234:235], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[236:237], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[238:239], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
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
		v_exp_f32_e32 v19, v136
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
		v_exp_f32_e32 v117, v166
		v_exp_f32_e32 v233, v167
		v_exp_f32_e32 v119, v96
		v_exp_f32_e32 v235, v97
		v_exp_f32_e32 v121, v98
		v_exp_f32_e32 v237, v99
		v_exp_f32_e32 v123, v100
		v_exp_f32_e32 v239, v101
		v_exp_f32_e32 v125, v102
		v_exp_f32_e32 v241, v103
		v_exp_f32_e32 v127, v104
		v_exp_f32_e32 v243, v105
		v_exp_f32_e32 v129, v106
		v_exp_f32_e32 v245, v107
		v_exp_f32_e32 v131, v108
		v_exp_f32_e32 v247, v109
		v_exp_f32_e32 v96, v110
		v_exp_f32_e32 v98, v111
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
		v_add_f32_e32 v3, v184, v185
		v_accvgpr_read_b32 v4, a77
		ds_bpermute_b32 v180, v4, v3
		v_accvgpr_read_b32 v4, a78
		ds_bpermute_b32 v182, v4, v3
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
		v_mov_b32_e32 v180, v20
		v_mov_b32_e32 v181, v22
		v_mov_b32_e32 v9, v10
		v_pk_add_f32 v[10:11], v[8:9], v[180:181] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v8, v10
		v_exp_f32_e32 v180, v11
		v_mov_b32_e32 v9, v8
		v_pk_mul_f32 v[32:33], v[32:33], v[8:9]
		v_pk_mul_f32 v[34:35], v[34:35], v[8:9]
		v_pk_mul_f32 v[36:37], v[36:37], v[8:9]
		v_pk_mul_f32 v[38:39], v[38:39], v[8:9]
		v_pk_mul_f32 v[40:41], v[40:41], v[8:9]
		v_pk_mul_f32 v[42:43], v[42:43], v[8:9]
		v_pk_mul_f32 v[44:45], v[44:45], v[8:9]
		v_pk_mul_f32 v[46:47], v[46:47], v[8:9]
		v_pk_mul_f32 v[48:49], v[48:49], v[8:9]
		v_pk_mul_f32 v[50:51], v[50:51], v[8:9]
		v_pk_mul_f32 v[52:53], v[52:53], v[8:9]
		v_pk_mul_f32 v[54:55], v[54:55], v[8:9]
		v_pk_mul_f32 v[56:57], v[56:57], v[8:9]
		v_pk_mul_f32 v[58:59], v[58:59], v[8:9]
		v_pk_mul_f32 v[60:61], v[60:61], v[8:9]
		v_pk_mul_f32 v[62:63], v[62:63], v[8:9]
		v_mov_b32_e32 v181, v180
		v_pk_mul_f32 v[64:65], v[64:65], v[180:181]
		v_pk_mul_f32 v[66:67], v[66:67], v[180:181]
		v_pk_mul_f32 v[68:69], v[68:69], v[180:181]
		v_pk_mul_f32 v[70:71], v[70:71], v[180:181]
		v_pk_mul_f32 v[72:73], v[72:73], v[180:181]
		v_pk_mul_f32 v[74:75], v[74:75], v[180:181]
		v_pk_mul_f32 v[76:77], v[76:77], v[180:181]
		v_pk_mul_f32 v[78:79], v[78:79], v[180:181]
		v_pk_mul_f32 v[80:81], v[80:81], v[180:181]
		v_pk_mul_f32 v[82:83], v[82:83], v[180:181]
		v_pk_mul_f32 v[84:85], v[84:85], v[180:181]
		v_pk_mul_f32 v[86:87], v[86:87], v[180:181]
		v_pk_mul_f32 v[88:89], v[88:89], v[180:181]
		v_pk_mul_f32 v[90:91], v[90:91], v[180:181]
		v_pk_mul_f32 v[92:93], v[92:93], v[180:181]
		v_pk_mul_f32 v[94:95], v[94:95], v[180:181]
		v_mov_b32_e32 v10, v8
		v_mov_b32_e32 v11, v180
		v_mov_b32_e32 v182, v184
		v_mov_b64_e32 v[8:9], v[14:15]
		v_pk_fma_f32 v[14:15], v[8:9], v[10:11], v[182:183]
		v_cvt_pk_bf16_f32 v190, v24, v220
		v_cvt_pk_bf16_f32 v191, v26, v222
		v_cvt_pk_bf16_f32 v8, v28, v224
		v_cvt_pk_bf16_f32 v9, v30, v226
		v_cvt_pk_bf16_f32 v10, v112, v228
		v_cvt_pk_bf16_f32 v11, v114, v230
		v_cvt_pk_bf16_f32 v180, v116, v232
		v_cvt_pk_bf16_f32 v181, v118, v234
		v_cvt_pk_bf16_f32 v182, v120, v236
		v_cvt_pk_bf16_f32 v183, v122, v238
		v_cvt_pk_bf16_f32 v184, v124, v240
		v_cvt_pk_bf16_f32 v185, v126, v242
		v_cvt_pk_bf16_f32 v186, v128, v244
		v_cvt_pk_bf16_f32 v187, v130, v246
		v_cvt_pk_bf16_f32 v192, v215, v217
		v_cvt_pk_bf16_f32 v193, v19, v219
		v_cvt_pk_bf16_f32 v194, v25, v221
		v_cvt_pk_bf16_f32 v195, v27, v223
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
		v_cvt_pk_bf16_f32 v196, v97, v99
		v_cvt_pk_bf16_f32 v197, v101, v103
		v_cvt_pk_bf16_f32 v198, v105, v107
		v_cvt_pk_bf16_f32 v199, v109, v111
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
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[32:47], a[104:107], v[188:191], v[32:47]
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		v_mfma_f32_32x32x16_bf16 v[48:63], a[136:139], v[188:191], v[48:63]
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_mfma_f32_32x32x16_bf16 v[32:47], a[108:111], v[8:11], v[32:47]
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_mfma_f32_32x32x16_bf16 v[48:63], a[140:143], v[8:11], v[48:63]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[32:47], a[112:115], v[180:183], v[32:47]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[48:63], a[144:147], v[180:183], v[48:63]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[32:47], a[116:119], v[184:187], v[32:47]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[48:63], a[148:151], v[184:187], v[48:63]
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_mfma_f32_32x32x16_bf16 v[80:95], a[136:139], v[116:119], v[80:95]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[64:79], a[104:107], v[116:119], v[64:79]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[80:95], a[140:143], v[120:123], v[80:95]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
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
		v_mfma_f32_32x32x16_bf16 v[32:47], a[120:123], v[192:195], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[152:155], v[192:195], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], v[196:199], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[120:123], v[196:199], v[64:79]
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
		v_mov_b32_e32 v4, v20
		v_mov_b32_e32 v10, v22
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_1
.L_attn_fwd_persistent.loop_exit_1:
		s_mul_i32 s23, s23, 0x80
		v_accvgpr_read_b32 v3, a13
		v_accvgpr_read_b32 v8, a5
		s_nop 0
		v_readfirstlane_b32 s25, v8
		s_nop 1
		v_add_u32_e32 v3, s25, v3
		v_add_u32_e32 v3, s1, v3
		v_accvgpr_read_b32 v8, a14
		v_accvgpr_read_b32 v9, a5
		s_nop 0
		v_readfirstlane_b32 s25, v9
		s_nop 1
		v_add_u32_e32 v8, s25, v8
		v_add_u32_e32 v8, s1, v8
		v_xor_b32_e32 v9, 1, v13
		v_accvgpr_write_b32 a13, v9
		v_xor_b32_e32 v9, 2, v13
		v_accvgpr_write_b32 a14, v9
		v_xor_b32_e32 v9, 3, v13
		v_accvgpr_write_b32 a67, v9
		v_xor_b32_e32 v9, 8, v13
		v_accvgpr_write_b32 a74, v9
		v_xor_b32_e32 v9, 9, v13
		v_accvgpr_write_b32 a79, v9
		v_xor_b32_e32 v9, 10, v13
		v_accvgpr_write_b32 a80, v9
		v_xor_b32_e32 v9, 11, v13
		v_accvgpr_write_b32 a81, v9
		v_xor_b32_e32 v9, 16, v13
		v_accvgpr_write_b32 a82, v9
		v_xor_b32_e32 v9, 17, v13
		v_accvgpr_write_b32 a83, v9
		v_xor_b32_e32 v9, 18, v13
		v_accvgpr_write_b32 a84, v9
		v_xor_b32_e32 v9, 19, v13
		v_accvgpr_write_b32 a85, v9
		v_xor_b32_e32 v9, 24, v13
		v_accvgpr_write_b32 a86, v9
		v_xor_b32_e32 v9, 25, v13
		v_accvgpr_write_b32 a87, v9
		v_xor_b32_e32 v9, 26, v13
		v_accvgpr_write_b32 a88, v9
		v_xor_b32_e32 v9, 27, v13
		v_accvgpr_write_b32 a89, v9
		v_xor_b32_e32 v9, 32, v13
		v_accvgpr_write_b32 a90, v9
		v_xor_b32_e32 v9, 33, v13
		v_accvgpr_write_b32 a91, v9
		v_xor_b32_e32 v9, 34, v13
		v_accvgpr_write_b32 a92, v9
		v_xor_b32_e32 v9, 35, v13
		v_accvgpr_write_b32 a93, v9
		v_xor_b32_e32 v9, 40, v13
		v_accvgpr_write_b32 a94, v9
		v_xor_b32_e32 v9, 41, v13
		v_accvgpr_write_b32 a95, v9
		v_xor_b32_e32 v9, 42, v13
		v_accvgpr_write_b32 a96, v9
		v_xor_b32_e32 v9, 43, v13
		v_accvgpr_write_b32 a97, v9
		v_xor_b32_e32 v9, 48, v13
		v_accvgpr_write_b32 a98, v9
		v_xor_b32_e32 v9, 49, v13
		v_accvgpr_write_b32 a99, v9
		v_xor_b32_e32 v9, 50, v13
		v_accvgpr_write_b32 a100, v9
		v_xor_b32_e32 v9, 51, v13
		v_accvgpr_write_b32 a101, v9
		v_xor_b32_e32 v9, 56, v13
		v_accvgpr_write_b32 a102, v9
		v_xor_b32_e32 v9, 57, v13
		v_accvgpr_write_b32 a103, v9
		v_xor_b32_e32 v9, 58, v13
		v_accvgpr_write_b32 a104, v9
		v_xor_b32_e32 v9, 59, v13
		v_accvgpr_write_b32 a105, v9
		v_xor_b32_e32 v9, 64, v13
		v_accvgpr_write_b32 a106, v9
		v_xor_b32_e32 v9, 0x41, v13
		v_accvgpr_write_b32 a107, v9
		v_xor_b32_e32 v9, 0x42, v13
		v_accvgpr_write_b32 a108, v9
		v_xor_b32_e32 v9, 0x43, v13
		v_accvgpr_write_b32 a109, v9
		v_xor_b32_e32 v9, 0x48, v13
		v_accvgpr_write_b32 a110, v9
		v_xor_b32_e32 v9, 0x49, v13
		v_accvgpr_write_b32 a111, v9
		v_xor_b32_e32 v9, 0x4a, v13
		v_accvgpr_write_b32 a112, v9
		v_xor_b32_e32 v9, 0x4b, v13
		v_accvgpr_write_b32 a113, v9
		v_xor_b32_e32 v9, 0x50, v13
		v_accvgpr_write_b32 a114, v9
		v_xor_b32_e32 v9, 0x51, v13
		v_accvgpr_write_b32 a115, v9
		v_xor_b32_e32 v9, 0x52, v13
		v_accvgpr_write_b32 a116, v9
		v_xor_b32_e32 v9, 0x53, v13
		v_accvgpr_write_b32 a117, v9
		v_xor_b32_e32 v9, 0x58, v13
		v_accvgpr_write_b32 a118, v9
		v_xor_b32_e32 v9, 0x59, v13
		v_accvgpr_write_b32 a119, v9
		v_xor_b32_e32 v9, 0x5a, v13
		v_accvgpr_write_b32 a120, v9
		v_xor_b32_e32 v9, 0x5b, v13
		v_accvgpr_write_b32 a121, v9
		v_xor_b32_e32 v9, 0x60, v13
		v_accvgpr_write_b32 a122, v9
		v_xor_b32_e32 v9, 0x61, v13
		v_accvgpr_write_b32 a123, v9
		v_xor_b32_e32 v9, 0x62, v13
		v_accvgpr_write_b32 a124, v9
		v_xor_b32_e32 v9, 0x63, v13
		v_accvgpr_write_b32 a125, v9
		v_xor_b32_e32 v9, 0x68, v13
		v_accvgpr_write_b32 a126, v9
		v_xor_b32_e32 v9, 0x69, v13
		v_accvgpr_write_b32 a127, v9
		v_xor_b32_e32 v9, 0x6a, v13
		v_accvgpr_write_b32 a128, v9
		v_xor_b32_e32 v9, 0x6b, v13
		v_accvgpr_write_b32 a129, v9
		v_xor_b32_e32 v9, 0x70, v13
		v_accvgpr_write_b32 a130, v9
		v_xor_b32_e32 v9, 0x71, v13
		v_accvgpr_write_b32 a131, v9
		v_xor_b32_e32 v9, 0x72, v13
		v_accvgpr_write_b32 a132, v9
		v_xor_b32_e32 v9, 0x73, v13
		v_accvgpr_write_b32 a133, v9
		v_xor_b32_e32 v9, 0x78, v13
		v_accvgpr_write_b32 a134, v9
		v_xor_b32_e32 v9, 0x79, v13
		v_accvgpr_write_b32 a135, v9
		v_xor_b32_e32 v9, 0x7a, v13
		v_accvgpr_write_b32 a136, v9
		v_xor_b32_e32 v9, 0x7b, v13
		v_accvgpr_write_b32 a137, v9
		v_accvgpr_read_b32 v9, a20
		v_accvgpr_read_b32 v11, a68
		v_lshl_add_u32 v9, v9, 4, v11
		v_accvgpr_read_b32 v11, a69
		v_accvgpr_read_b32 v12, a70
		v_add3_u32 v9, v9, v11, v12
		v_accvgpr_read_b32 v11, a71
		v_accvgpr_read_b32 v12, a72
		v_add3_u32 v9, v9, v11, v12
		v_accvgpr_write_b32 a20, v9
		v_accvgpr_read_b32 v9, a73
		v_accvgpr_read_b32 v11, a75
		v_lshl_add_u32 v9, v9, 3, v11
		v_accvgpr_read_b32 v11, a22
		v_accvgpr_read_b32 v12, a76
		v_add3_u32 v9, v9, v12, v11
		v_accvgpr_write_b32 a22, v9
		v_mov_b32_e32 v9, 0xff800000
		s_cmp_lt_i32 s42, s23
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_2
.L_attn_fwd_persistent.loop_head_2:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s1, s42, 0x80
		s_cmp_lt_i32 s42, 0
		s_cselect_b32 s25, s22, 0
		s_add_i32 s25, s42, s25
		s_ashr_i32 s25, s25, 7
		s_cmp_lt_i32 s25, 0
		s_cselect_b32 s37, s16, 0
		s_add_i32 s37, s25, s37
		s_ashr_i32 s37, s37, 1
		s_lshl_b32 s37, s37, 1
		s_xor_b32 s37, s37, -1
		s_add_i32 s37, s37, 1
		s_add_i32 s37, s25, s37
		s_add_i32 s25, s25, 1
		s_cmp_lt_i32 s25, 0
		s_cselect_b32 s40, s16, 0
		s_add_i32 s40, s25, s40
		s_ashr_i32 s40, s40, 1
		s_lshl_b32 s40, s40, 1
		s_xor_b32 s40, s40, -1
		s_add_i32 s40, s40, 1
		s_add_i32 s48, s25, s40
		s_mul_i32 s25, 0x4100, s37
		v_accvgpr_read_b32 v11, a20
		v_add_u32_e32 v11, s25, v11
		ds_read_b128 v[20:23], v11
		ds_read_b128 a[68:71], v11 offset:32
		ds_read_b128 a[140:143], v11 offset:64
		ds_read_b128 a[144:147], v11 offset:96
		ds_read_b128 a[148:151], v11 offset:256
		ds_read_b128 a[152:155], v11 offset:288
		ds_read_b128 a[156:159], v11 offset:320
		ds_read_b128 a[160:163], v11 offset:352
		ds_read_b128 a[164:167], v11 offset:128
		ds_read_b128 a[168:171], v11 offset:160
		ds_read_b128 a[172:175], v11 offset:192
		ds_read_b128 a[176:179], v11 offset:224
		ds_read_b128 v[24:27], v11 offset:384
		ds_read_b128 a[180:183], v11 offset:416
		ds_read_b128 a[184:187], v11 offset:448
		ds_read_b128 a[188:191], v11 offset:480
		s_mul_i32 s25, 0x4400, s37
		v_accvgpr_read_b32 v11, a22
		v_add_u32_e32 v11, s25, v11
		ds_read_b64_tr_b16 a[192:193], v11 offset:33264
		ds_read_b64_tr_b16 a[194:195], v11 offset:37616
		ds_read_b64_tr_b16 a[196:197], v11 offset:33392
		ds_read_b64_tr_b16 a[198:199], v11 offset:37744
		ds_read_b64_tr_b16 a[200:201], v11 offset:33520
		ds_read_b64_tr_b16 a[202:203], v11 offset:37872
		ds_read_b64_tr_b16 a[204:205], v11 offset:33648
		ds_read_b64_tr_b16 a[206:207], v11 offset:38000
		ds_read_b64_tr_b16 a[208:209], v11 offset:33776
		ds_read_b64_tr_b16 a[210:211], v11 offset:38128
		ds_read_b64_tr_b16 a[212:213], v11 offset:33904
		ds_read_b64_tr_b16 a[214:215], v11 offset:38256
		ds_read_b64_tr_b16 a[216:217], v11 offset:34032
		ds_read_b64_tr_b16 a[218:219], v11 offset:38384
		ds_read_b64_tr_b16 a[220:221], v11 offset:34160
		ds_read_b64_tr_b16 a[222:223], v11 offset:38512
		ds_read_b64_tr_b16 a[224:225], v11 offset:33328
		ds_read_b64_tr_b16 a[226:227], v11 offset:37680
		ds_read_b64_tr_b16 a[228:229], v11 offset:33456
		ds_read_b64_tr_b16 a[230:231], v11 offset:37808
		ds_read_b64_tr_b16 a[232:233], v11 offset:33584
		ds_read_b64_tr_b16 a[234:235], v11 offset:37936
		ds_read_b64_tr_b16 a[236:237], v11 offset:33712
		ds_read_b64_tr_b16 a[238:239], v11 offset:38064
		ds_read_b64_tr_b16 a[240:241], v11 offset:33840
		ds_read_b64_tr_b16 a[242:243], v11 offset:38192
		ds_read_b64_tr_b16 a[244:245], v11 offset:33968
		ds_read_b64_tr_b16 a[246:247], v11 offset:38320
		ds_read_b64_tr_b16 a[248:249], v11 offset:34096
		ds_read_b64_tr_b16 a[250:251], v11 offset:38448
		ds_read_b64_tr_b16 a[252:253], v11 offset:34224
		ds_read_b64_tr_b16 a[254:255], v11 offset:38576
		s_cmp_lt_i32 s1, s19
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_2
		v_accvgpr_read_b32 v11, a23
		v_add_u32_e32 v11, s1, v11
		v_cmp_lt_i32_e64 s[40:41], v11, s21
		v_accvgpr_read_b32 v11, a60
		v_add_u32_e32 v11, s1, v11
		v_cmp_lt_i32_e64 s[50:51], v11, s21
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s25, s15, s42
		s_lshl_b32 s37, s25, 1
		s_add_i32 s25, s43, s37
		v_add_u32_e32 v11, s25, v5
		v_cndmask_b32_e64 v11, v17, v11, s[40:41]
		s_mov_b32 s40, 1
		s_mov_b32 s41, 0
		s_mov_b32 s25, 0
		s_mul_i32 s52, s40, s24
		s_mul_hi_u32 s53, s40, s24
		s_mul_i32 s49, s40, s25
		s_add_i32 s53, s53, s49
		s_mul_i32 s49, s41, s24
		s_add_i32 s53, s53, s49
		s_lshr_b64 s[40:41], s[52:53], 6
		s_mov_b32 s52, 0x410
		s_mov_b32 s53, 0
		s_mul_i32 s54, s52, s40
		s_mul_hi_u32 s55, s52, s40
		s_mul_i32 s25, s52, s41
		s_add_i32 s55, s55, s25
		s_mul_i32 s25, s53, s40
		s_add_i32 s55, s55, s25
		s_cmp_lt_i32 s48, 0
		s_cselect_b32 s49, -1, 0
		s_mov_b32 s52, 0x4100
		s_mov_b32 s53, 0
		s_mul_i32 s56, s52, s48
		s_mul_hi_u32 s57, s52, s48
		s_mul_i32 s25, s52, s49
		s_add_i32 s57, s57, s25
		s_mul_i32 s25, s53, s48
		s_add_i32 s57, s57, s25
		s_add_u32 s52, s54, s56
		s_addc_u32 s53, s55, s57
		s_add_u32 s58, s52, 0
		s_addc_u32 s59, s53, 0
		s_mov_b32 m0, s58
		v_accvgpr_read_b32 v12, a61
		v_add_u32_e32 v12, s1, v12
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[52:53], v12, s21
		s_add_i32 s25, s44, s37
		v_add_u32_e32 v11, s25, v5
		v_cndmask_b32_e64 v11, v17, v11, s[52:53]
		s_add_u32 s52, s54, 0x1040
		s_addc_u32 s53, s55, 0
		s_add_u32 s52, s52, s56
		s_addc_u32 s53, s53, s57
		s_add_u32 s58, s52, 0
		s_addc_u32 s59, s53, 0
		s_mov_b32 m0, s58
		v_accvgpr_read_b32 v12, a62
		v_add_u32_e32 v12, s1, v12
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[52:53], v12, s21
		s_add_i32 s25, s45, s37
		v_add_u32_e32 v11, s25, v5
		v_cndmask_b32_e64 v11, v17, v11, s[52:53]
		s_add_u32 s52, s54, 0x2080
		s_addc_u32 s53, s55, 0
		s_add_u32 s52, s52, s56
		s_addc_u32 s53, s53, s57
		s_add_u32 s58, s52, 0
		s_addc_u32 s59, s53, 0
		s_mov_b32 m0, s58
		v_accvgpr_read_b32 v12, a63
		v_add_u32_e32 v12, s1, v12
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[52:53], v12, s21
		s_add_i32 s25, s38, s37
		v_add_u32_e32 v11, s25, v5
		v_cndmask_b32_e64 v11, v17, v11, s[52:53]
		s_add_u32 s52, s54, 0x30c0
		s_addc_u32 s53, s55, 0
		s_add_u32 s52, s52, s56
		s_addc_u32 s53, s53, s57
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		v_accvgpr_read_b32 v12, a64
		v_add_u32_e32 v12, s1, v12
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		s_mul_i32 s25, s17, s42
		s_lshl_b32 s25, s25, 1
		s_add_i32 s37, s39, s25
		v_add_u32_e32 v11, s37, v2
		v_cndmask_b32_e64 v11, v17, v11, s[50:51]
		s_mov_b32 s50, 0x440
		s_mov_b32 s51, 0
		s_mul_i32 s52, s50, s40
		s_mul_hi_u32 s53, s50, s40
		s_mul_i32 s37, s50, s41
		s_add_i32 s53, s53, s37
		s_mul_i32 s37, s51, s40
		s_add_i32 s53, s53, s37
		s_add_u32 s40, s52, 0x81f0
		s_addc_u32 s41, s53, 0
		s_mov_b32 s50, 0x4400
		s_mov_b32 s51, 0
		s_mul_i32 s54, s50, s48
		s_mul_hi_u32 s55, s50, s48
		s_mul_i32 s37, s50, s49
		s_add_i32 s55, s55, s37
		s_mul_i32 s37, s51, s48
		s_add_i32 s55, s55, s37
		s_add_u32 s40, s40, s54
		s_addc_u32 s41, s41, s55
		s_add_u32 s48, s40, 0
		s_addc_u32 s49, s41, 0
		s_mov_b32 m0, s48
		v_accvgpr_read_b32 v16, a65
		v_add_u32_e32 v16, s1, v16
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[40:41], v12, s21
		s_add_i32 s37, s46, s25
		v_add_u32_e32 v11, s37, v2
		v_cndmask_b32_e64 v11, v17, v11, s[40:41]
		s_add_u32 s40, s52, 0x92f0
		s_addc_u32 s41, s53, 0
		s_add_u32 s40, s40, s54
		s_addc_u32 s41, s41, s55
		s_add_u32 s48, s40, 0
		s_addc_u32 s49, s41, 0
		s_mov_b32 m0, s48
		v_accvgpr_read_b32 v12, a66
		v_add_u32_e32 v12, s1, v12
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[40:41], v16, s21
		s_add_i32 s37, s47, s25
		v_add_u32_e32 v11, s37, v2
		s_add_u32 s48, s52, 0xa3f0
		s_addc_u32 s49, s53, 0
		s_add_u32 s48, s48, s54
		s_addc_u32 s49, s49, s55
		s_add_u32 s50, s48, 0
		s_addc_u32 s51, s49, 0
		s_mov_b32 m0, s50
		v_cndmask_b32_e64 v11, v17, v11, s[40:41]
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		s_add_i32 s25, s36, s25
		v_cmp_lt_i32_e64 vcc, v12, s21
		v_add_u32_e32 v11, s25, v2
		s_add_u32 s40, s52, 0xb4f0
		s_addc_u32 s41, s53, 0
		v_cndmask_b32_e32 v11, v17, v11, vcc
		s_add_u32 s40, s40, s54
		s_addc_u32 s41, s41, s55
		s_add_u32 s48, s40, 0
		s_addc_u32 s49, s41, 0
		s_mov_b32 m0, s48
		s_nop 0
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_2
.L_attn_fwd_persistent.if_else_2:
.L_attn_fwd_persistent.if_end_2:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[96:111], v[20:23], a[24:27], 0
		s_cmp_lt_i32 s1, s23
		v_mfma_f32_32x32x16_bf16 v[112:127], a[148:151], a[24:27], 0
		v_mfma_f32_32x32x16_bf16 v[128:143], a[164:167], a[24:27], 0
		v_mfma_f32_32x32x16_bf16 v[144:159], v[24:27], a[24:27], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[24:27], a[40:43], 0
		v_mfma_f32_32x32x16_bf16 v[176:191], v[20:23], a[40:43], 0
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
		v_add_u32_e32 v11, s42, v13
		v_accvgpr_read_b32 v12, a13
		v_add_u32_e32 v12, s42, v12
		v_accvgpr_read_b32 v16, a14
		v_add_u32_e32 v16, s42, v16
		v_mfma_f32_32x32x16_bf16 v[176:191], a[140:143], a[48:51], v[176:191]
		v_accvgpr_read_b32 v18, a67
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a68, v18
		v_mfma_f32_32x32x16_bf16 v[192:207], a[156:159], a[48:51], v[192:207]
		v_accvgpr_read_b32 v18, a80
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a69, v18
		v_mfma_f32_32x32x16_bf16 v[208:223], a[172:175], a[48:51], v[208:223]
		v_accvgpr_read_b32 v18, a81
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a70, v18
		v_mfma_f32_32x32x16_bf16 v[96:111], a[144:147], a[36:39], v[96:111]
		v_accvgpr_read_b32 v18, a84
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a71, v18
		v_mfma_f32_32x32x16_bf16 v[112:127], a[160:163], a[36:39], v[112:127]
		v_accvgpr_read_b32 v18, a85
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a72, v18
		v_mfma_f32_32x32x16_bf16 v[128:143], a[176:179], a[36:39], v[128:143]
		v_accvgpr_read_b32 v18, a88
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a73, v18
		v_mfma_f32_32x32x16_bf16 v[144:159], a[188:191], a[36:39], v[144:159]
		v_accvgpr_read_b32 v18, a89
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a75, v18
		v_mfma_f32_32x32x16_bf16 v[160:175], a[188:191], a[52:55], v[160:175]
		v_accvgpr_read_b32 v18, a92
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a76, v18
		v_mfma_f32_32x32x16_bf16 v[176:191], a[144:147], a[52:55], v[176:191]
		v_accvgpr_read_b32 v18, a93
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a138, v18
		v_mfma_f32_32x32x16_bf16 v[192:207], a[160:163], a[52:55], v[192:207]
		v_accvgpr_read_b32 v18, a96
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a139, v18
		v_mfma_f32_32x32x16_bf16 v[208:223], a[176:179], a[52:55], v[208:223]
		v_accvgpr_read_b32 v18, a97
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a140, v18
		v_accvgpr_read_b32 v18, a100
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a141, v18
		v_accvgpr_read_b32 v18, a101
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a142, v18
		v_accvgpr_read_b32 v18, a104
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a143, v18
		v_accvgpr_read_b32 v18, a105
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a144, v18
		v_accvgpr_read_b32 v18, a108
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a145, v18
		v_accvgpr_read_b32 v18, a109
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a146, v18
		v_accvgpr_read_b32 v18, a112
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a147, v18
		v_accvgpr_read_b32 v18, a113
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a148, v18
		v_accvgpr_read_b32 v18, a116
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a149, v18
		v_accvgpr_read_b32 v18, a117
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a150, v18
		v_accvgpr_read_b32 v18, a120
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a151, v18
		v_accvgpr_read_b32 v18, a121
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a152, v18
		v_accvgpr_read_b32 v18, a124
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a153, v18
		v_accvgpr_read_b32 v18, a125
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a154, v18
		v_accvgpr_read_b32 v18, a128
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a155, v18
		v_accvgpr_read_b32 v18, a129
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a156, v18
		v_accvgpr_read_b32 v18, a132
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a157, v18
		v_accvgpr_read_b32 v18, a133
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a158, v18
		v_accvgpr_read_b32 v18, a136
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a159, v18
		v_accvgpr_read_b32 v18, a137
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a160, v18
		v_cmp_ge_i32_e64 s[40:41], v3, v11
		v_cmp_ge_i32_e64 s[48:49], v3, v12
		v_cmp_ge_i32_e64 s[50:51], v3, v16
		v_accvgpr_read_b32 v18, a68
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_accvgpr_read_b32 v18, a74
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a161, v18
		v_accvgpr_read_b32 v18, a79
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a162, v18
		v_cndmask_b32_e32 v19, v9, v99, vcc
		v_accvgpr_read_b32 v18, a161
		v_cmp_ge_i32_e64 s[52:53], v3, v18
		v_accvgpr_read_b32 v18, a162
		v_cmp_ge_i32_e64 s[54:55], v3, v18
		v_accvgpr_read_b32 v18, a69
		v_cmp_ge_i32_e64 s[56:57], v3, v18
		v_accvgpr_read_b32 v18, a70
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_accvgpr_read_b32 v18, a82
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a163, v18
		v_accvgpr_read_b32 v18, a83
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a164, v18
		v_cndmask_b32_e32 v21, v9, v103, vcc
		v_accvgpr_read_b32 v18, a163
		v_cmp_ge_i32_e64 s[58:59], v3, v18
		v_accvgpr_read_b32 v18, a164
		v_cmp_ge_i32_e64 s[60:61], v3, v18
		v_accvgpr_read_b32 v18, a71
		v_cmp_ge_i32_e64 s[62:63], v3, v18
		v_accvgpr_read_b32 v18, a72
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_accvgpr_read_b32 v18, a86
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a165, v18
		v_accvgpr_read_b32 v18, a87
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a166, v18
		v_cndmask_b32_e32 v23, v9, v107, vcc
		v_accvgpr_read_b32 v18, a165
		v_cmp_ge_i32_e64 s[64:65], v3, v18
		v_accvgpr_read_b32 v18, a166
		v_cmp_ge_i32_e64 s[66:67], v3, v18
		v_accvgpr_read_b32 v18, a73
		v_cmp_ge_i32_e64 s[68:69], v3, v18
		v_accvgpr_read_b32 v18, a75
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_accvgpr_read_b32 v18, a90
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a167, v18
		v_accvgpr_read_b32 v18, a91
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a168, v18
		v_cndmask_b32_e32 v25, v9, v111, vcc
		v_accvgpr_read_b32 v18, a167
		v_cmp_ge_i32_e64 s[70:71], v3, v18
		v_accvgpr_read_b32 v18, a168
		v_cmp_ge_i32_e64 s[72:73], v3, v18
		v_accvgpr_read_b32 v18, a76
		v_cmp_ge_i32_e64 s[74:75], v3, v18
		v_accvgpr_read_b32 v18, a138
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_accvgpr_read_b32 v18, a94
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a169, v18
		v_accvgpr_read_b32 v18, a95
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a170, v18
		v_cndmask_b32_e32 v27, v9, v115, vcc
		v_accvgpr_read_b32 v18, a169
		v_cmp_ge_i32_e64 s[76:77], v3, v18
		v_accvgpr_read_b32 v18, a170
		v_cmp_ge_i32_e64 s[78:79], v3, v18
		v_accvgpr_read_b32 v18, a139
		v_cmp_ge_i32_e64 s[80:81], v3, v18
		v_accvgpr_read_b32 v18, a140
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_accvgpr_read_b32 v18, a98
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a171, v18
		v_accvgpr_read_b32 v18, a99
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a172, v18
		v_cndmask_b32_e32 v29, v9, v119, vcc
		v_accvgpr_read_b32 v18, a171
		v_cmp_ge_i32_e64 s[82:83], v3, v18
		v_accvgpr_read_b32 v18, a172
		v_cmp_ge_i32_e64 s[84:85], v3, v18
		v_accvgpr_read_b32 v18, a102
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a173, v18
		v_accvgpr_read_b32 v18, a103
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a174, v18
		v_accvgpr_read_b32 v18, a141
		v_cmp_ge_i32_e64 s[86:87], v3, v18
		v_cndmask_b32_e64 v30, v9, v96, s[40:41]
		v_accvgpr_read_b32 v18, a142
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_cndmask_b32_e64 v224, v9, v100, s[52:53]
		v_cndmask_b32_e64 v226, v9, v104, s[58:59]
		v_cndmask_b32_e32 v229, v9, v123, vcc
		v_accvgpr_read_b32 v18, a173
		v_cmp_ge_i32_e64 s[40:41], v3, v18
		v_accvgpr_read_b32 v18, a174
		v_cmp_ge_i32_e64 s[52:53], v3, v18
		v_accvgpr_read_b32 v18, a106
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a175, v18
		v_accvgpr_read_b32 v18, a107
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a176, v18
		v_accvgpr_read_b32 v18, a143
		v_cmp_ge_i32_e64 s[58:59], v3, v18
		v_accvgpr_read_b32 v18, a144
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_cndmask_b32_e64 v230, v9, v108, s[64:65]
		v_cndmask_b32_e64 v232, v9, v112, s[70:71]
		v_cndmask_b32_e32 v235, v9, v127, vcc
		v_accvgpr_read_b32 v18, a175
		v_cmp_ge_i32_e64 s[64:65], v3, v18
		v_accvgpr_read_b32 v18, a110
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a177, v18
		v_accvgpr_read_b32 v18, a111
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a178, v18
		v_accvgpr_read_b32 v18, a176
		v_cmp_ge_i32_e64 s[70:71], v3, v18
		v_accvgpr_read_b32 v18, a145
		v_cmp_ge_i32_e64 s[88:89], v3, v18
		v_accvgpr_read_b32 v18, a146
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_cndmask_b32_e64 v236, v9, v116, s[76:77]
		v_cndmask_b32_e64 v238, v9, v120, s[82:83]
		v_cndmask_b32_e32 v241, v9, v131, vcc
		v_accvgpr_read_b32 v18, a114
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a179, v18
		v_accvgpr_read_b32 v18, a115
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a180, v18
		v_accvgpr_read_b32 v18, a177
		v_cmp_ge_i32_e64 s[76:77], v3, v18
		v_accvgpr_read_b32 v18, a178
		v_cmp_ge_i32_e64 s[82:83], v3, v18
		v_accvgpr_read_b32 v18, a147
		v_cmp_ge_i32_e64 s[90:91], v3, v18
		v_accvgpr_read_b32 v18, a148
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_cndmask_b32_e64 v242, v9, v124, s[40:41]
		v_cndmask_b32_e64 v244, v9, v128, s[64:65]
		v_cndmask_b32_e32 v247, v9, v135, vcc
		v_accvgpr_read_b32 v18, a179
		v_cmp_ge_i32_e64 s[40:41], v3, v18
		v_accvgpr_read_b32 v18, a180
		v_cmp_ge_i32_e64 s[64:65], v3, v18
		v_accvgpr_read_b32 v18, a149
		v_cmp_ge_i32_e64 s[92:93], v3, v18
		v_accvgpr_read_b32 v18, a150
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_accvgpr_read_b32 v18, a118
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a181, v18
		v_accvgpr_read_b32 v18, a119
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a182, v18
		v_cndmask_b32_e32 v249, v9, v139, vcc
		v_accvgpr_read_b32 v18, a181
		v_cmp_ge_i32_e64 s[94:95], v3, v18
		v_accvgpr_read_b32 v18, a182
		v_cmp_ge_i32_e64 s[96:97], v3, v18
		v_accvgpr_read_b32 v18, a151
		v_cmp_ge_i32_e64 s[98:99], v3, v18
		v_cndmask_b32_e64 v250, v9, v132, s[76:77]
		v_cndmask_b32_e64 v253, v9, v141, s[96:97]
		v_cndmask_b32_e64 v254, v9, v142, s[98:99]
		v_accvgpr_read_b32 v18, a152
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_accvgpr_read_b32 v18, a122
		v_add_u32_e32 v96, s42, v18
		v_accvgpr_read_b32 v18, a123
		v_add_u32_e32 v99, s42, v18
		v_cndmask_b32_e32 v255, v9, v143, vcc
		v_cmp_ge_i32_e64 s[76:77], v3, v96
		v_cmp_ge_i32_e64 s[96:97], v3, v99
		v_accvgpr_read_b32 v18, a153
		v_cmp_ge_i32_e64 s[98:99], v3, v18
		v_cndmask_b32_e64 v142, v9, v144, s[76:77]
		v_cndmask_b32_e64 v143, v9, v145, s[96:97]
		v_cndmask_b32_e64 v144, v9, v146, s[98:99]
		v_accvgpr_read_b32 v18, a154
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_accvgpr_read_b32 v18, a126
		v_add_u32_e32 v100, s42, v18
		v_accvgpr_read_b32 v18, a127
		v_add_u32_e32 v103, s42, v18
		v_cndmask_b32_e32 v145, v9, v147, vcc
		v_cmp_ge_i32_e64 s[76:77], v3, v100
		v_cmp_ge_i32_e64 s[96:97], v3, v103
		v_accvgpr_read_b32 v18, a155
		v_cmp_ge_i32_e64 s[98:99], v3, v18
		v_cndmask_b32_e64 v146, v9, v148, s[76:77]
		v_cndmask_b32_e64 v147, v9, v149, s[96:97]
		v_cndmask_b32_e64 v148, v9, v150, s[98:99]
		v_accvgpr_read_b32 v18, a156
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_accvgpr_read_b32 v18, a130
		v_add_u32_e32 v104, s42, v18
		v_accvgpr_read_b32 v18, a131
		v_add_u32_e32 v107, s42, v18
		v_cndmask_b32_e32 v149, v9, v151, vcc
		v_cmp_ge_i32_e64 s[76:77], v3, v104
		v_cmp_ge_i32_e64 s[96:97], v3, v107
		v_accvgpr_read_b32 v18, a157
		v_cmp_ge_i32_e64 s[98:99], v3, v18
		v_cndmask_b32_e64 v150, v9, v152, s[76:77]
		v_cndmask_b32_e64 v151, v9, v153, s[96:97]
		v_cndmask_b32_e64 v152, v9, v154, s[98:99]
		v_accvgpr_read_b32 v18, a158
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_accvgpr_read_b32 v18, a134
		v_add_u32_e32 v108, s42, v18
		v_accvgpr_read_b32 v18, a135
		v_add_u32_e32 v111, s42, v18
		v_cndmask_b32_e32 v153, v9, v155, vcc
		v_cmp_ge_i32_e64 s[76:77], v3, v108
		v_cmp_ge_i32_e64 s[96:97], v3, v111
		v_accvgpr_read_b32 v18, a159
		v_cmp_ge_i32_e64 s[98:99], v3, v18
		v_cndmask_b32_e64 v154, v9, v156, s[76:77]
		v_cndmask_b32_e64 v155, v9, v157, s[96:97]
		v_cndmask_b32_e64 v156, v9, v158, s[98:99]
		v_cndmask_b32_e64 v31, v9, v97, s[48:49]
		v_accvgpr_read_b32 v18, a160
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_max3_f32 v97, v142, v143, v144
		v_max3_f32 v112, v146, v147, v148
		v_cndmask_b32_e32 v157, v9, v159, vcc
		v_cmp_ge_i32_e64 s[48:49], v8, v11
		v_cmp_ge_i32_e64 s[76:77], v8, v12
		v_cmp_ge_i32_e64 s[96:97], v8, v16
		v_max3_f32 v11, v150, v151, v152
		v_max3_f32 v12, v154, v155, v156
		v_cndmask_b32_e64 v158, v9, v178, s[96:97]
		v_accvgpr_read_b32 v16, a68
		v_cmp_ge_i32_e64 vcc, v8, v16
		v_cndmask_b32_e64 v18, v9, v98, s[50:51]
		v_max3_f32 v16, v30, v31, v18
		v_cndmask_b32_e32 v159, v9, v179, vcc
		v_accvgpr_read_b32 v20, a161
		v_cmp_ge_i32_e64 s[50:51], v8, v20
		v_accvgpr_read_b32 v20, a162
		v_cmp_ge_i32_e64 s[96:97], v8, v20
		v_accvgpr_read_b32 v20, a69
		v_cmp_ge_i32_e64 s[98:99], v8, v20
		v_cndmask_b32_e64 v178, v9, v180, s[50:51]
		v_cndmask_b32_e64 v179, v9, v181, s[96:97]
		v_cndmask_b32_e64 v180, v9, v182, s[98:99]
		v_accvgpr_read_b32 v20, a70
		v_cmp_ge_i32_e64 vcc, v8, v20
		v_cndmask_b32_e64 v225, v9, v101, s[54:55]
		v_cndmask_b32_e64 v20, v9, v102, s[56:57]
		v_cndmask_b32_e32 v181, v9, v183, vcc
		v_accvgpr_read_b32 v22, a163
		v_cmp_ge_i32_e64 s[50:51], v8, v22
		v_accvgpr_read_b32 v22, a164
		v_cmp_ge_i32_e64 s[54:55], v8, v22
		v_accvgpr_read_b32 v22, a71
		v_cmp_ge_i32_e64 s[56:57], v8, v22
		v_cndmask_b32_e64 v182, v9, v184, s[50:51]
		v_cndmask_b32_e64 v183, v9, v185, s[54:55]
		v_cndmask_b32_e64 v184, v9, v186, s[56:57]
		v_accvgpr_read_b32 v22, a72
		v_cmp_ge_i32_e64 vcc, v8, v22
		v_cndmask_b32_e64 v227, v9, v105, s[60:61]
		v_max3_f32 v98, v224, v225, v20
		v_cndmask_b32_e32 v185, v9, v187, vcc
		v_accvgpr_read_b32 v22, a165
		v_cmp_ge_i32_e64 s[50:51], v8, v22
		v_accvgpr_read_b32 v22, a166
		v_cmp_ge_i32_e64 s[54:55], v8, v22
		v_accvgpr_read_b32 v22, a73
		v_cmp_ge_i32_e64 s[56:57], v8, v22
		v_cndmask_b32_e64 v186, v9, v188, s[50:51]
		v_cndmask_b32_e64 v187, v9, v189, s[54:55]
		v_cndmask_b32_e64 v188, v9, v190, s[56:57]
		v_accvgpr_read_b32 v22, a75
		v_cmp_ge_i32_e64 vcc, v8, v22
		v_cndmask_b32_e64 v22, v9, v106, s[62:63]
		v_max3_f32 v101, v226, v227, v22
		v_cndmask_b32_e32 v189, v9, v191, vcc
		v_accvgpr_read_b32 v24, a167
		v_cmp_ge_i32_e64 s[50:51], v8, v24
		v_accvgpr_read_b32 v24, a168
		v_cmp_ge_i32_e64 s[54:55], v8, v24
		v_accvgpr_read_b32 v24, a76
		v_cmp_ge_i32_e64 s[56:57], v8, v24
		v_cndmask_b32_e64 v190, v9, v192, s[50:51]
		v_cndmask_b32_e64 v191, v9, v193, s[54:55]
		v_cndmask_b32_e64 v192, v9, v194, s[56:57]
		v_accvgpr_read_b32 v24, a138
		v_cmp_ge_i32_e64 vcc, v8, v24
		v_cndmask_b32_e64 v231, v9, v109, s[66:67]
		v_cndmask_b32_e64 v24, v9, v110, s[68:69]
		v_cndmask_b32_e32 v193, v9, v195, vcc
		v_accvgpr_read_b32 v26, a169
		v_cmp_ge_i32_e64 s[50:51], v8, v26
		v_accvgpr_read_b32 v26, a170
		v_cmp_ge_i32_e64 s[54:55], v8, v26
		v_accvgpr_read_b32 v26, a139
		v_cmp_ge_i32_e64 s[56:57], v8, v26
		v_cndmask_b32_e64 v194, v9, v196, s[50:51]
		v_cndmask_b32_e64 v195, v9, v197, s[54:55]
		v_cndmask_b32_e64 v196, v9, v198, s[56:57]
		v_accvgpr_read_b32 v26, a140
		v_cmp_ge_i32_e64 vcc, v8, v26
		v_cndmask_b32_e64 v233, v9, v113, s[72:73]
		v_max3_f32 v102, v230, v231, v24
		v_cndmask_b32_e32 v197, v9, v199, vcc
		v_accvgpr_read_b32 v26, a171
		v_cmp_ge_i32_e64 s[50:51], v8, v26
		v_accvgpr_read_b32 v26, a172
		v_cmp_ge_i32_e64 s[54:55], v8, v26
		v_accvgpr_read_b32 v26, a141
		v_cmp_ge_i32_e64 s[56:57], v8, v26
		v_cndmask_b32_e64 v198, v9, v200, s[50:51]
		v_cndmask_b32_e64 v199, v9, v201, s[54:55]
		v_cndmask_b32_e64 v200, v9, v202, s[56:57]
		v_accvgpr_read_b32 v26, a142
		v_cmp_ge_i32_e64 vcc, v8, v26
		v_cndmask_b32_e64 v26, v9, v114, s[74:75]
		v_max3_f32 v105, v232, v233, v26
		v_cndmask_b32_e32 v201, v9, v203, vcc
		v_accvgpr_read_b32 v28, a173
		v_cmp_ge_i32_e64 s[50:51], v8, v28
		v_accvgpr_read_b32 v28, a174
		v_cmp_ge_i32_e64 s[54:55], v8, v28
		v_accvgpr_read_b32 v28, a143
		v_cmp_ge_i32_e64 s[56:57], v8, v28
		v_cndmask_b32_e64 v114, v9, v204, s[50:51]
		v_cndmask_b32_e64 v115, v9, v205, s[54:55]
		v_cndmask_b32_e64 v202, v9, v206, s[56:57]
		v_accvgpr_read_b32 v28, a144
		v_cmp_ge_i32_e64 vcc, v8, v28
		v_cndmask_b32_e64 v237, v9, v117, s[78:79]
		v_cndmask_b32_e64 v28, v9, v118, s[80:81]
		v_cndmask_b32_e32 v203, v9, v207, vcc
		v_accvgpr_read_b32 v106, a175
		v_cmp_ge_i32_e64 s[50:51], v8, v106
		v_accvgpr_read_b32 v106, a176
		v_cmp_ge_i32_e64 s[54:55], v8, v106
		v_accvgpr_read_b32 v106, a145
		v_cmp_ge_i32_e64 s[56:57], v8, v106
		v_cndmask_b32_e64 v116, v9, v208, s[50:51]
		v_cndmask_b32_e64 v117, v9, v209, s[54:55]
		v_cndmask_b32_e64 v118, v9, v210, s[56:57]
		v_accvgpr_read_b32 v106, a146
		v_cmp_ge_i32_e64 vcc, v8, v106
		v_cndmask_b32_e64 v239, v9, v121, s[84:85]
		v_max3_f32 v106, v236, v237, v28
		v_cndmask_b32_e32 v119, v9, v211, vcc
		v_accvgpr_read_b32 v109, a177
		v_cmp_ge_i32_e64 s[50:51], v8, v109
		v_accvgpr_read_b32 v109, a178
		v_cmp_ge_i32_e64 s[54:55], v8, v109
		v_accvgpr_read_b32 v109, a147
		v_cmp_ge_i32_e64 s[56:57], v8, v109
		v_cndmask_b32_e64 v120, v9, v212, s[50:51]
		v_cndmask_b32_e64 v121, v9, v213, s[54:55]
		v_cndmask_b32_e64 v204, v9, v214, s[56:57]
		v_accvgpr_read_b32 v109, a148
		v_cmp_ge_i32_e64 vcc, v8, v109
		v_cndmask_b32_e64 v228, v9, v122, s[86:87]
		v_max3_f32 v109, v238, v239, v228
		v_cndmask_b32_e32 v205, v9, v215, vcc
		v_accvgpr_read_b32 v110, a179
		v_cmp_ge_i32_e64 s[50:51], v8, v110
		v_accvgpr_read_b32 v110, a180
		v_cmp_ge_i32_e64 s[54:55], v8, v110
		v_accvgpr_read_b32 v110, a149
		v_cmp_ge_i32_e64 s[56:57], v8, v110
		v_cndmask_b32_e64 v122, v9, v216, s[50:51]
		v_cndmask_b32_e64 v123, v9, v217, s[54:55]
		v_cndmask_b32_e64 v206, v9, v218, s[56:57]
		v_accvgpr_read_b32 v110, a150
		v_cmp_ge_i32_e64 vcc, v8, v110
		v_cndmask_b32_e64 v243, v9, v125, s[52:53]
		v_cndmask_b32_e64 v234, v9, v126, s[58:59]
		v_cndmask_b32_e32 v207, v9, v219, vcc
		v_accvgpr_read_b32 v110, a181
		v_cmp_ge_i32_e64 s[50:51], v8, v110
		v_accvgpr_read_b32 v110, a182
		v_cmp_ge_i32_e64 s[52:53], v8, v110
		v_accvgpr_read_b32 v110, a151
		v_cmp_ge_i32_e64 s[54:55], v8, v110
		v_cndmask_b32_e64 v124, v9, v220, s[50:51]
		v_cndmask_b32_e64 v125, v9, v221, s[52:53]
		v_cndmask_b32_e64 v126, v9, v222, s[54:55]
		v_accvgpr_read_b32 v110, a152
		v_cmp_ge_i32_e64 vcc, v8, v110
		v_cndmask_b32_e64 v245, v9, v129, s[70:71]
		v_max3_f32 v110, v242, v243, v234
		v_cndmask_b32_e32 v127, v9, v223, vcc
		v_cmp_ge_i32_e64 s[50:51], v8, v96
		v_cmp_ge_i32_e64 s[52:53], v8, v99
		v_accvgpr_read_b32 v96, a153
		v_cmp_ge_i32_e64 s[54:55], v8, v96
		v_cndmask_b32_e64 v128, v9, v160, s[50:51]
		v_cndmask_b32_e64 v129, v9, v161, s[52:53]
		v_cndmask_b32_e64 v160, v9, v162, s[54:55]
		v_accvgpr_read_b32 v96, a154
		v_cmp_ge_i32_e64 vcc, v8, v96
		v_cndmask_b32_e64 v240, v9, v130, s[88:89]
		v_max3_f32 v96, v244, v245, v240
		v_cndmask_b32_e32 v161, v9, v163, vcc
		v_cmp_ge_i32_e64 s[50:51], v8, v100
		v_cmp_ge_i32_e64 s[52:53], v8, v103
		v_accvgpr_read_b32 v99, a155
		v_cmp_ge_i32_e64 s[54:55], v8, v99
		v_cndmask_b32_e64 v130, v9, v164, s[50:51]
		v_cndmask_b32_e64 v131, v9, v165, s[52:53]
		v_cndmask_b32_e64 v162, v9, v166, s[54:55]
		v_accvgpr_read_b32 v99, a156
		v_cmp_ge_i32_e64 vcc, v8, v99
		v_cndmask_b32_e64 v251, v9, v133, s[82:83]
		v_cndmask_b32_e64 v246, v9, v134, s[90:91]
		v_cndmask_b32_e32 v163, v9, v167, vcc
		v_cmp_ge_i32_e64 s[50:51], v8, v104
		v_cmp_ge_i32_e64 s[52:53], v8, v107
		v_accvgpr_read_b32 v99, a157
		v_cmp_ge_i32_e64 s[54:55], v8, v99
		v_cndmask_b32_e64 v132, v9, v168, s[50:51]
		v_cndmask_b32_e64 v133, v9, v169, s[52:53]
		v_cndmask_b32_e64 v134, v9, v170, s[54:55]
		v_accvgpr_read_b32 v99, a158
		v_cmp_ge_i32_e64 vcc, v8, v99
		v_cndmask_b32_e64 v164, v9, v136, s[40:41]
		v_cndmask_b32_e64 v165, v9, v137, s[64:65]
		v_cndmask_b32_e32 v135, v9, v171, vcc
		v_cmp_ge_i32_e64 s[40:41], v8, v108
		v_cmp_ge_i32_e64 s[50:51], v8, v111
		v_accvgpr_read_b32 v99, a159
		v_cmp_ge_i32_e64 s[52:53], v8, v99
		v_cndmask_b32_e64 v136, v9, v172, s[40:41]
		v_cndmask_b32_e64 v137, v9, v173, s[50:51]
		v_cndmask_b32_e64 v166, v9, v174, s[52:53]
		v_accvgpr_read_b32 v99, a160
		v_cmp_ge_i32_e64 vcc, v8, v99
		v_cndmask_b32_e64 v248, v9, v138, s[92:93]
		v_cndmask_b32_e64 v252, v9, v140, s[94:95]
		v_cndmask_b32_e32 v167, v9, v175, vcc
		v_max3_f32 v99, v250, v251, v246
		v_max3_f32 v100, v164, v165, v248
		v_max3_f32 v103, v252, v253, v254
		v_max3_f32 v16, v16, v19, v98
		v_max3_f32 v98, v101, v23, v102
		v_max3_f32 v101, v105, v27, v106
		v_max3_f32 v102, v109, v229, v110
		v_max3_f32 v96, v96, v241, v99
		v_max3_f32 v99, v100, v249, v103
		v_max3_f32 v97, v97, v145, v112
		v_max3_f32 v11, v11, v153, v12
		v_max3_f32 v12, v16, v21, v98
		v_max3_f32 v16, v101, v29, v102
		v_max3_f32 v96, v96, v247, v99
		v_max3_f32 v11, v97, v149, v11
		v_max3_f32 v12, v12, v25, v16
		v_max3_f32 v11, v96, v255, v11
		v_max3_f32 v11, v12, v235, v11
		v_max_f32_e32 v96, v11, v157
		v_mov_b32_e32 v97, v96
		v_cndmask_b32_e64 v98, v9, v176, s[48:49]
		v_cndmask_b32_e64 v99, v9, v177, s[76:77]
		v_permlane32_swap_b32_e32 v96, v97
		v_max3_f32 v11, v98, v99, v158
		v_max3_f32 v12, v178, v179, v180
		v_max3_f32 v16, v182, v183, v184
		v_max3_f32 v100, v186, v187, v188
		v_max3_f32 v101, v190, v191, v192
		v_max3_f32 v102, v194, v195, v196
		v_max3_f32 v103, v198, v199, v200
		v_max3_f32 v104, v114, v115, v202
		v_max3_f32 v105, v116, v117, v118
		v_max3_f32 v106, v120, v121, v204
		v_max3_f32 v107, v122, v123, v206
		v_max3_f32 v108, v124, v125, v126
		v_max3_f32 v109, v128, v129, v160
		v_max3_f32 v110, v130, v131, v162
		v_max3_f32 v111, v132, v133, v134
		v_max3_f32 v112, v136, v137, v166
		v_max3_f32 v11, v11, v159, v12
		v_max3_f32 v12, v16, v185, v100
		v_max3_f32 v16, v101, v193, v102
		v_max3_f32 v100, v103, v201, v104
		v_max3_f32 v101, v105, v119, v106
		v_max3_f32 v102, v107, v207, v108
		v_max3_f32 v103, v109, v161, v110
		v_max3_f32 v104, v111, v135, v112
		v_max3_f32 v11, v11, v181, v12
		v_max3_f32 v12, v16, v197, v100
		v_max3_f32 v16, v101, v205, v102
		v_max3_f32 v100, v103, v163, v104
		v_max3_f32 v11, v11, v189, v12
		v_max3_f32 v12, v16, v127, v100
		v_max3_f32 v11, v11, v203, v12
		v_max_f32_e32 v100, v11, v167
		v_mov_b32_e32 v101, v100
		v_max_f32_e32 v102, v96, v97
		v_mov_b32_e32 v96, v4
		v_permlane32_swap_b32_e32 v100, v101
		v_max_f32_e32 v103, v100, v101
		v_pk_mul_f32 v[100:101], v[102:103], v[6:7]
		v_max_f32_e32 v102, v4, v100
		v_max_f32_e32 v104, v10, v101
		v_mov_b32_e32 v103, v102
		v_pk_fma_f32 v[100:101], v[30:31], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[18:19], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[18:19], v[224:225], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[20:21], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[20:21], v[226:227], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[22:23], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[22:23], v[230:231], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[24:25], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[232:233], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[26:27], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[236:237], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[28:29], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[238:239], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[228:229], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[242:243], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[234:235], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[244:245], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[240:241], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[250:251], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[246:247], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[164:165], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[248:249], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[252:253], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[254:255], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[142:143], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[144:145], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[146:147], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[148:149], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[150:151], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[154:155], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[156:157], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_mov_b32_e32 v105, v104
		v_pk_fma_f32 v[156:157], v[98:99], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[158:159], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[178:179], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[180:181], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[182:183], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[184:185], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[186:187], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[188:189], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[190:191], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[192:193], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[194:195], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[196:197], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[198:199], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[200:201], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[114:115], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[202:203], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[116:117], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[118:119], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[120:121], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[204:205], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[122:123], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[206:207], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[124:125], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[126:127], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[128:129], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[160:161], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[130:131], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[162:163], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[132:133], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[134:135], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[136:137], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[166:167], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v166, v100
		v_exp_f32_e32 v218, v101
		v_exp_f32_e32 v100, v30
		v_exp_f32_e32 v220, v31
		v_exp_f32_e32 v30, v18
		v_exp_f32_e32 v222, v19
		v_exp_f32_e32 v18, v106
		v_exp_f32_e32 v224, v107
		v_exp_f32_e32 v106, v20
		v_exp_f32_e32 v226, v21
		v_exp_f32_e32 v20, v108
		v_exp_f32_e32 v228, v109
		v_exp_f32_e32 v108, v22
		v_exp_f32_e32 v230, v23
		v_exp_f32_e32 v22, v110
		v_exp_f32_e32 v232, v111
		v_exp_f32_e32 v110, v24
		v_exp_f32_e32 v234, v25
		v_exp_f32_e32 v24, v112
		v_exp_f32_e32 v236, v113
		v_exp_f32_e32 v112, v26
		v_exp_f32_e32 v238, v27
		v_exp_f32_e32 v26, v138
		v_exp_f32_e32 v240, v139
		v_exp_f32_e32 v138, v28
		v_exp_f32_e32 v242, v29
		v_exp_f32_e32 v28, v140
		v_exp_f32_e32 v244, v141
		v_exp_f32_e32 v140, v168
		v_exp_f32_e32 v246, v169
		v_exp_f32_e32 v168, v170
		v_exp_f32_e32 v248, v171
		v_exp_f32_e32 v167, v172
		v_exp_f32_e32 v219, v173
		v_exp_f32_e32 v101, v174
		v_exp_f32_e32 v221, v175
		v_exp_f32_e32 v31, v176
		v_exp_f32_e32 v223, v177
		v_exp_f32_e32 v19, v208
		v_exp_f32_e32 v225, v209
		v_exp_f32_e32 v107, v210
		v_exp_f32_e32 v227, v211
		v_exp_f32_e32 v21, v164
		v_exp_f32_e32 v229, v165
		v_exp_f32_e32 v109, v212
		v_exp_f32_e32 v231, v213
		v_exp_f32_e32 v23, v214
		v_exp_f32_e32 v233, v215
		v_exp_f32_e32 v111, v216
		v_exp_f32_e32 v235, v217
		v_exp_f32_e32 v25, v142
		v_exp_f32_e32 v237, v143
		v_exp_f32_e32 v113, v144
		v_exp_f32_e32 v239, v145
		v_exp_f32_e32 v27, v146
		v_exp_f32_e32 v241, v147
		v_exp_f32_e32 v139, v148
		v_exp_f32_e32 v243, v149
		v_exp_f32_e32 v29, v150
		v_exp_f32_e32 v245, v151
		v_exp_f32_e32 v141, v152
		v_exp_f32_e32 v247, v153
		v_exp_f32_e32 v169, v154
		v_exp_f32_e32 v249, v155
		v_exp_f32_e32 v142, v156
		v_exp_f32_e32 v144, v157
		v_exp_f32_e32 v146, v98
		v_exp_f32_e32 v148, v99
		v_exp_f32_e32 v98, v158
		v_exp_f32_e32 v150, v159
		v_exp_f32_e32 v152, v178
		v_exp_f32_e32 v154, v179
		v_exp_f32_e32 v156, v180
		v_exp_f32_e32 v158, v181
		v_exp_f32_e32 v164, v182
		v_exp_f32_e32 v170, v183
		v_exp_f32_e32 v172, v184
		v_exp_f32_e32 v174, v185
		v_exp_f32_e32 v176, v186
		v_exp_f32_e32 v178, v187
		v_exp_f32_e32 v180, v188
		v_exp_f32_e32 v182, v189
		v_exp_f32_e32 v184, v190
		v_exp_f32_e32 v186, v191
		v_exp_f32_e32 v188, v192
		v_exp_f32_e32 v190, v193
		v_exp_f32_e32 v192, v194
		v_exp_f32_e32 v208, v195
		v_exp_f32_e32 v194, v196
		v_exp_f32_e32 v210, v197
		v_exp_f32_e32 v196, v198
		v_exp_f32_e32 v212, v199
		v_exp_f32_e32 v198, v200
		v_exp_f32_e32 v214, v201
		v_exp_f32_e32 v200, v114
		v_exp_f32_e32 v216, v115
		v_exp_f32_e32 v143, v202
		v_exp_f32_e32 v145, v203
		v_exp_f32_e32 v147, v116
		v_exp_f32_e32 v149, v117
		v_exp_f32_e32 v99, v118
		v_exp_f32_e32 v151, v119
		v_exp_f32_e32 v153, v120
		v_exp_f32_e32 v155, v121
		v_exp_f32_e32 v157, v204
		v_exp_f32_e32 v159, v205
		v_exp_f32_e32 v165, v122
		v_exp_f32_e32 v171, v123
		v_exp_f32_e32 v173, v206
		v_exp_f32_e32 v175, v207
		v_exp_f32_e32 v177, v124
		v_exp_f32_e32 v179, v125
		v_exp_f32_e32 v181, v126
		v_exp_f32_e32 v183, v127
		v_exp_f32_e32 v185, v128
		v_exp_f32_e32 v187, v129
		v_exp_f32_e32 v189, v160
		v_exp_f32_e32 v191, v161
		v_exp_f32_e32 v193, v130
		v_exp_f32_e32 v209, v131
		v_exp_f32_e32 v195, v162
		v_exp_f32_e32 v211, v163
		v_exp_f32_e32 v197, v132
		v_exp_f32_e32 v213, v133
		v_exp_f32_e32 v199, v134
		v_exp_f32_e32 v215, v135
		v_exp_f32_e32 v201, v136
		v_exp_f32_e32 v217, v137
		v_pk_add_f32 v[114:115], v[166:167], v[218:219]
		v_pk_add_f32 v[116:117], v[100:101], v[220:221]
		v_pk_add_f32 v[118:119], v[30:31], v[222:223]
		v_pk_add_f32 v[120:121], v[18:19], v[224:225]
		v_pk_add_f32 v[122:123], v[106:107], v[226:227]
		v_pk_add_f32 v[124:125], v[20:21], v[228:229]
		v_pk_add_f32 v[126:127], v[108:109], v[230:231]
		v_pk_add_f32 v[128:129], v[22:23], v[232:233]
		v_pk_add_f32 v[130:131], v[110:111], v[234:235]
		v_pk_add_f32 v[132:133], v[24:25], v[236:237]
		v_pk_add_f32 v[134:135], v[112:113], v[238:239]
		v_pk_add_f32 v[136:137], v[26:27], v[240:241]
		v_pk_add_f32 v[160:161], v[138:139], v[242:243]
		v_pk_add_f32 v[162:163], v[28:29], v[244:245]
		v_pk_add_f32 v[202:203], v[140:141], v[246:247]
		v_pk_add_f32 v[204:205], v[168:169], v[248:249]
		v_pk_add_f32 v[114:115], v[114:115], v[116:117]
		v_pk_add_f32 v[116:117], v[118:119], v[120:121]
		v_pk_add_f32 v[118:119], v[122:123], v[124:125]
		v_pk_add_f32 v[120:121], v[126:127], v[128:129]
		v_pk_add_f32 v[122:123], v[130:131], v[132:133]
		v_pk_add_f32 v[124:125], v[134:135], v[136:137]
		v_pk_add_f32 v[126:127], v[160:161], v[162:163]
		v_pk_add_f32 v[128:129], v[202:203], v[204:205]
		v_pk_add_f32 v[114:115], v[114:115], v[116:117]
		v_pk_add_f32 v[116:117], v[118:119], v[120:121]
		v_pk_add_f32 v[118:119], v[122:123], v[124:125]
		v_pk_add_f32 v[120:121], v[126:127], v[128:129]
		v_pk_add_f32 v[114:115], v[114:115], v[116:117]
		v_pk_add_f32 v[116:117], v[118:119], v[120:121]
		v_pk_add_f32 v[118:119], v[114:115], v[116:117]
		v_add_f32_e32 v4, v118, v119
		v_accvgpr_read_b32 v11, a77
		ds_bpermute_b32 v114, v11, v4
		v_accvgpr_read_b32 v11, a78
		ds_bpermute_b32 v116, v11, v4
		v_pk_add_f32 v[118:119], v[142:143], v[144:145]
		v_pk_add_f32 v[120:121], v[146:147], v[148:149]
		v_pk_add_f32 v[122:123], v[98:99], v[150:151]
		v_pk_add_f32 v[124:125], v[152:153], v[154:155]
		v_pk_add_f32 v[126:127], v[156:157], v[158:159]
		v_pk_add_f32 v[128:129], v[164:165], v[170:171]
		v_pk_add_f32 v[130:131], v[172:173], v[174:175]
		v_pk_add_f32 v[132:133], v[176:177], v[178:179]
		v_pk_add_f32 v[134:135], v[180:181], v[182:183]
		v_pk_add_f32 v[136:137], v[184:185], v[186:187]
		v_pk_add_f32 v[160:161], v[188:189], v[190:191]
		v_pk_add_f32 v[162:163], v[192:193], v[208:209]
		v_pk_add_f32 v[202:203], v[194:195], v[210:211]
		v_pk_add_f32 v[204:205], v[196:197], v[212:213]
		v_pk_add_f32 v[206:207], v[198:199], v[214:215]
		v_pk_add_f32 v[250:251], v[200:201], v[216:217]
		v_pk_add_f32 v[118:119], v[118:119], v[120:121]
		v_pk_add_f32 v[120:121], v[122:123], v[124:125]
		v_pk_add_f32 v[122:123], v[126:127], v[128:129]
		v_pk_add_f32 v[124:125], v[130:131], v[132:133]
		v_pk_add_f32 v[126:127], v[134:135], v[136:137]
		v_pk_add_f32 v[128:129], v[160:161], v[162:163]
		v_pk_add_f32 v[130:131], v[202:203], v[204:205]
		v_pk_add_f32 v[132:133], v[206:207], v[250:251]
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
		v_cvt_pk_bf16_f32 v120, v166, v218
		v_cvt_pk_bf16_f32 v121, v100, v220
		v_permlane32_swap_b32_e32 v114, v115
		v_add_f32_e32 v117, v114, v115
		v_mov_b32_e32 v114, v102
		v_mov_b32_e32 v115, v104
		v_mov_b32_e32 v97, v10
		v_pk_add_f32 v[10:11], v[96:97], v[114:115] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v96, v10
		v_exp_f32_e32 v114, v11
		v_mov_b32_e32 v97, v96
		v_pk_mul_f32 v[32:33], v[32:33], v[96:97]
		v_pk_mul_f32 v[34:35], v[34:35], v[96:97]
		v_pk_mul_f32 v[36:37], v[36:37], v[96:97]
		v_pk_mul_f32 v[38:39], v[38:39], v[96:97]
		v_pk_mul_f32 v[40:41], v[40:41], v[96:97]
		v_pk_mul_f32 v[42:43], v[42:43], v[96:97]
		v_pk_mul_f32 v[44:45], v[44:45], v[96:97]
		v_pk_mul_f32 v[46:47], v[46:47], v[96:97]
		v_pk_mul_f32 v[48:49], v[48:49], v[96:97]
		v_pk_mul_f32 v[50:51], v[50:51], v[96:97]
		v_pk_mul_f32 v[52:53], v[52:53], v[96:97]
		v_pk_mul_f32 v[54:55], v[54:55], v[96:97]
		v_pk_mul_f32 v[56:57], v[56:57], v[96:97]
		v_pk_mul_f32 v[58:59], v[58:59], v[96:97]
		v_pk_mul_f32 v[60:61], v[60:61], v[96:97]
		v_pk_mul_f32 v[62:63], v[62:63], v[96:97]
		v_mov_b32_e32 v115, v114
		v_pk_mul_f32 v[64:65], v[64:65], v[114:115]
		v_pk_mul_f32 v[66:67], v[66:67], v[114:115]
		v_pk_mul_f32 v[68:69], v[68:69], v[114:115]
		v_pk_mul_f32 v[70:71], v[70:71], v[114:115]
		v_pk_mul_f32 v[72:73], v[72:73], v[114:115]
		v_pk_mul_f32 v[74:75], v[74:75], v[114:115]
		v_pk_mul_f32 v[76:77], v[76:77], v[114:115]
		v_pk_mul_f32 v[78:79], v[78:79], v[114:115]
		v_pk_mul_f32 v[80:81], v[80:81], v[114:115]
		v_pk_mul_f32 v[82:83], v[82:83], v[114:115]
		v_pk_mul_f32 v[84:85], v[84:85], v[114:115]
		v_pk_mul_f32 v[86:87], v[86:87], v[114:115]
		v_pk_mul_f32 v[88:89], v[88:89], v[114:115]
		v_pk_mul_f32 v[90:91], v[90:91], v[114:115]
		v_pk_mul_f32 v[92:93], v[92:93], v[114:115]
		v_pk_mul_f32 v[94:95], v[94:95], v[114:115]
		v_mov_b32_e32 v10, v96
		v_mov_b32_e32 v11, v114
		v_mov_b32_e32 v116, v118
		v_mov_b64_e32 v[96:97], v[14:15]
		v_pk_fma_f32 v[14:15], v[96:97], v[10:11], v[116:117]
		v_cvt_pk_bf16_f32 v122, v30, v222
		v_cvt_pk_bf16_f32 v123, v18, v224
		v_cvt_pk_bf16_f32 v116, v106, v226
		v_cvt_pk_bf16_f32 v117, v20, v228
		v_cvt_pk_bf16_f32 v118, v108, v230
		v_cvt_pk_bf16_f32 v119, v22, v232
		v_cvt_pk_bf16_f32 v124, v110, v234
		v_cvt_pk_bf16_f32 v125, v24, v236
		v_cvt_pk_bf16_f32 v126, v112, v238
		v_cvt_pk_bf16_f32 v127, v26, v240
		v_cvt_pk_bf16_f32 v128, v138, v242
		v_cvt_pk_bf16_f32 v129, v28, v244
		v_cvt_pk_bf16_f32 v130, v140, v246
		v_cvt_pk_bf16_f32 v131, v168, v248
		v_cvt_pk_bf16_f32 v132, v167, v219
		v_cvt_pk_bf16_f32 v133, v101, v221
		v_cvt_pk_bf16_f32 v134, v31, v223
		v_cvt_pk_bf16_f32 v135, v19, v225
		v_cvt_pk_bf16_f32 v160, v107, v227
		v_cvt_pk_bf16_f32 v161, v21, v229
		v_cvt_pk_bf16_f32 v162, v109, v231
		v_cvt_pk_bf16_f32 v163, v23, v233
		v_cvt_pk_bf16_f32 v20, v111, v235
		v_cvt_pk_bf16_f32 v21, v25, v237
		v_cvt_pk_bf16_f32 v22, v113, v239
		v_cvt_pk_bf16_f32 v23, v27, v241
		v_cvt_pk_bf16_f32 v24, v139, v243
		v_cvt_pk_bf16_f32 v25, v29, v245
		v_cvt_pk_bf16_f32 v26, v141, v247
		v_cvt_pk_bf16_f32 v27, v169, v249
		v_cvt_pk_bf16_f32 v28, v142, v144
		v_cvt_pk_bf16_f32 v29, v146, v148
		v_cvt_pk_bf16_f32 v30, v98, v150
		v_cvt_pk_bf16_f32 v31, v152, v154
		v_cvt_pk_bf16_f32 v108, v156, v158
		v_cvt_pk_bf16_f32 v109, v164, v170
		v_cvt_pk_bf16_f32 v110, v172, v174
		v_cvt_pk_bf16_f32 v111, v176, v178
		v_cvt_pk_bf16_f32 v112, v180, v182
		v_cvt_pk_bf16_f32 v113, v184, v186
		v_cvt_pk_bf16_f32 v114, v188, v190
		v_cvt_pk_bf16_f32 v115, v192, v208
		v_cvt_pk_bf16_f32 v136, v194, v210
		v_cvt_pk_bf16_f32 v137, v196, v212
		v_cvt_pk_bf16_f32 v138, v198, v214
		v_cvt_pk_bf16_f32 v139, v200, v216
		v_cvt_pk_bf16_f32 v204, v143, v145
		v_cvt_pk_bf16_f32 v205, v147, v149
		v_cvt_pk_bf16_f32 v206, v99, v151
		v_cvt_pk_bf16_f32 v207, v153, v155
		v_cvt_pk_bf16_f32 v96, v157, v159
		v_cvt_pk_bf16_f32 v97, v165, v171
		v_cvt_pk_bf16_f32 v98, v173, v175
		v_cvt_pk_bf16_f32 v99, v177, v179
		v_cvt_pk_bf16_f32 v140, v181, v183
		v_cvt_pk_bf16_f32 v141, v185, v187
		v_cvt_pk_bf16_f32 v142, v189, v191
		v_cvt_pk_bf16_f32 v143, v193, v209
		v_cvt_pk_bf16_f32 v144, v195, v211
		v_cvt_pk_bf16_f32 v145, v197, v213
		v_cvt_pk_bf16_f32 v146, v199, v215
		v_cvt_pk_bf16_f32 v147, v201, v217
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[120:123], v[32:47]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[120:123], v[48:63]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[116:119], v[32:47]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[116:119], v[48:63]
		v_permlane32_swap_b32_e32 v160, v162
		v_permlane32_swap_b32_e32 v161, v163
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[124:127], v[32:47]
		v_permlane32_swap_b32_e32 v20, v22
		v_permlane32_swap_b32_e32 v21, v23
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[124:127], v[48:63]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[128:131], v[32:47]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[128:131], v[48:63]
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[28:31], v[80:95]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[28:31], v[64:79]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[108:111], v[80:95]
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[108:111], v[64:79]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[112:115], v[80:95]
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[112:115], v[64:79]
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[136:139], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[136:139], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[132:135], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[132:135], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[204:207], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[204:207], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[160:163], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[160:163], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[216:219], v[20:23], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[248:251], v[20:23], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[248:251], v[140:143], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[216:219], v[140:143], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[220:223], v[24:27], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[252:255], v[24:27], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[252:255], v[144:147], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[220:223], v[144:147], v[64:79]
		s_cselect_b32 s1, 1, 0
		s_add_i32 s25, s42, 0x80
		s_cmp_lg_u32 s1, 0
		s_mov_b32 s42, s25
		v_mov_b32_e32 v4, v102
		v_mov_b32_e32 v10, v104
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_2
.L_attn_fwd_persistent.loop_exit_2:
		s_mov_b32 s28, s8
		s_mov_b32 s29, s9
		s_mov_b32 s30, s26
		s_mov_b32 s31, s27
		v_rcp_f32_e32 v2, v14
		v_accvgpr_read_b32 v3, a11
		s_nop 0
		v_readfirstlane_b32 s1, v3
		s_mul_i32 s1, s1, s18
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
		v_readfirstlane_b32 s24, v2
		s_mul_i32 s23, s24, s23
		s_lshl_b32 s23, s23, 1
		s_add_i32 s22, s22, s23
		v_accvgpr_read_b32 v2, a12
		v_mul_lo_u32 v2, s18, v2
		v_lshl_add_u32 v3, v2, 6, s22
		v_accvgpr_read_b32 v32, a15
		v_mul_lo_u32 v32, s18, v32
		v_lshl_add_u32 v3, v32, 1, v3
		v_accvgpr_read_b32 v33, a19
		v_mul_lo_u32 v33, s18, v33
		v_lshl_add_u32 v3, v33, 5, v3
		v_accvgpr_read_b32 v34, a21
		v_mul_lo_u32 v34, s18, v34
		v_lshl_add_u32 v3, v34, 4, v3
		v_accvgpr_read_b32 v35, a16
		v_mul_lo_u32 v35, s18, v35
		v_lshl_add_u32 v3, v35, 3, v3
		v_accvgpr_read_b32 v36, a17
		v_mul_lo_u32 v36, s18, v36
		v_lshl_add_u32 v3, v36, 2, v3
		v_accvgpr_read_b32 v37, a18
		v_lshl_add_u32 v3, v37, 4, v3
		v_accvgpr_read_b32 v37, a56
		s_nop 0
		v_readfirstlane_b32 s24, v37
		v_accvgpr_read_b32 v37, a57
		s_nop 0
		v_readfirstlane_b32 s25, v37
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_8
		buffer_store_dwordx4 v[40:43], v3, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_8:
		s_andn2_b64 exec, s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_8
.L_attn_fwd_persistent.exec_endif_8:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s22, s1, 32
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s23
		v_lshl_add_u32 v3, v2, 6, s22
		v_lshl_add_u32 v3, v32, 1, v3
		v_lshl_add_u32 v3, v33, 5, v3
		v_lshl_add_u32 v3, v34, 4, v3
		v_lshl_add_u32 v3, v35, 3, v3
		v_lshl_add_u32 v3, v36, 2, v3
		v_accvgpr_read_b32 v37, a18
		v_lshl_add_u32 v3, v37, 4, v3
		v_accvgpr_read_b32 v37, a56
		s_nop 0
		v_readfirstlane_b32 s24, v37
		v_accvgpr_read_b32 v37, a57
		s_nop 0
		v_readfirstlane_b32 s25, v37
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_9
		buffer_store_dwordx4 v[8:11], v3, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_9:
		s_andn2_b64 exec, s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_9
.L_attn_fwd_persistent.exec_endif_9:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s22, s1, 64
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s23
		v_lshl_add_u32 v3, v2, 6, s22
		v_lshl_add_u32 v3, v32, 1, v3
		v_lshl_add_u32 v3, v33, 5, v3
		v_lshl_add_u32 v3, v34, 4, v3
		v_lshl_add_u32 v3, v35, 3, v3
		v_lshl_add_u32 v3, v36, 2, v3
		v_accvgpr_read_b32 v8, a18
		v_lshl_add_u32 v3, v8, 4, v3
		v_accvgpr_read_b32 v8, a56
		s_nop 0
		v_readfirstlane_b32 s24, v8
		v_accvgpr_read_b32 v8, a57
		s_nop 0
		v_readfirstlane_b32 s25, v8
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_10
		buffer_store_dwordx4 v[16:19], v3, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_10:
		s_andn2_b64 exec, s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_10
.L_attn_fwd_persistent.exec_endif_10:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s22, s1, 0x60
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s23
		v_lshl_add_u32 v3, v2, 6, s22
		v_lshl_add_u32 v3, v32, 1, v3
		v_lshl_add_u32 v3, v33, 5, v3
		v_lshl_add_u32 v3, v34, 4, v3
		v_lshl_add_u32 v3, v35, 3, v3
		v_lshl_add_u32 v3, v36, 2, v3
		v_accvgpr_read_b32 v8, a18
		v_lshl_add_u32 v3, v8, 4, v3
		v_accvgpr_read_b32 v8, a56
		s_nop 0
		v_readfirstlane_b32 s24, v8
		v_accvgpr_read_b32 v8, a57
		s_nop 0
		v_readfirstlane_b32 s25, v8
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_11
		buffer_store_dwordx4 v[20:23], v3, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_11:
		s_andn2_b64 exec, s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_11
.L_attn_fwd_persistent.exec_endif_11:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s22, s18, 8
		s_add_i32 s24, s22, s1
		s_add_i32 s24, s24, s19
		s_add_i32 s24, s24, s23
		v_lshl_add_u32 v3, v2, 6, s24
		v_lshl_add_u32 v3, v32, 1, v3
		v_lshl_add_u32 v3, v33, 5, v3
		v_lshl_add_u32 v3, v34, 4, v3
		v_lshl_add_u32 v3, v35, 3, v3
		v_lshl_add_u32 v3, v36, 2, v3
		v_accvgpr_read_b32 v8, a18
		v_lshl_add_u32 v3, v8, 4, v3
		v_accvgpr_read_b32 v8, a58
		s_nop 0
		v_readfirstlane_b32 s24, v8
		v_accvgpr_read_b32 v8, a59
		s_nop 0
		v_readfirstlane_b32 s25, v8
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_12
		buffer_store_dwordx4 v[24:27], v3, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_12:
		s_andn2_b64 exec, s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_12
.L_attn_fwd_persistent.exec_endif_12:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s24, s22, 32
		s_add_i32 s24, s24, s1
		s_add_i32 s24, s24, s19
		s_add_i32 s24, s24, s23
		v_lshl_add_u32 v3, v2, 6, s24
		v_lshl_add_u32 v3, v32, 1, v3
		v_lshl_add_u32 v3, v33, 5, v3
		v_lshl_add_u32 v3, v34, 4, v3
		v_lshl_add_u32 v3, v35, 3, v3
		v_lshl_add_u32 v3, v36, 2, v3
		v_accvgpr_read_b32 v8, a18
		v_lshl_add_u32 v3, v8, 4, v3
		v_accvgpr_read_b32 v8, a58
		s_nop 0
		v_readfirstlane_b32 s24, v8
		v_accvgpr_read_b32 v8, a59
		s_nop 0
		v_readfirstlane_b32 s25, v8
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_13
		buffer_store_dwordx4 v[4:7], v3, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_13:
		s_andn2_b64 exec, s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_13
.L_attn_fwd_persistent.exec_endif_13:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s24, s22, 64
		s_add_i32 s24, s24, s1
		s_add_i32 s24, s24, s19
		s_add_i32 s24, s24, s23
		v_lshl_add_u32 v3, v2, 6, s24
		v_lshl_add_u32 v3, v32, 1, v3
		v_lshl_add_u32 v3, v33, 5, v3
		v_lshl_add_u32 v3, v34, 4, v3
		v_lshl_add_u32 v3, v35, 3, v3
		v_lshl_add_u32 v3, v36, 2, v3
		v_accvgpr_read_b32 v4, a18
		v_lshl_add_u32 v3, v4, 4, v3
		v_accvgpr_read_b32 v4, a58
		s_nop 0
		v_readfirstlane_b32 s24, v4
		v_accvgpr_read_b32 v4, a59
		s_nop 0
		v_readfirstlane_b32 s25, v4
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_14
		buffer_store_dwordx4 v[12:15], v3, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_14:
		s_andn2_b64 exec, s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_14
.L_attn_fwd_persistent.exec_endif_14:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s22, s22, 0x60
		s_add_i32 s1, s22, s1
		s_add_i32 s1, s1, s19
		s_add_i32 s1, s1, s23
		v_lshl_add_u32 v2, v2, 6, s1
		v_lshl_add_u32 v2, v32, 1, v2
		v_lshl_add_u32 v2, v33, 5, v2
		v_lshl_add_u32 v2, v34, 4, v2
		v_lshl_add_u32 v2, v35, 3, v2
		v_lshl_add_u32 v2, v36, 2, v2
		v_accvgpr_read_b32 v3, a18
		v_lshl_add_u32 v2, v3, 4, v2
		v_accvgpr_read_b32 v3, a58
		s_nop 0
		v_readfirstlane_b32 s22, v3
		v_accvgpr_read_b32 v3, a59
		s_nop 0
		v_readfirstlane_b32 s23, v3
		s_and_saveexec_b64 s[100:101], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_15
		buffer_store_dwordx4 v[28:31], v2, s[28:31], 0 offen
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
		v_accvgpr_read_b32 v6, a13
		v_add_u32_e32 v6, s1, v6
		v_xor_b32_e32 v2, 0x80, v2
		v_xor_b32_e32 v2, v2, v5
		v_xor_b32_e32 v2, v2, v7
		v_bitop3_b32 v2, v2, v10, v13 bitop3:0x96
		v_bitop3_b32 v2, v2, v15, v17 bitop3:0x96
		v_accvgpr_write_b32 a14, v2
		v_accvgpr_read_b32 v2, a14
		v_add_u32_e32 v2, s1, v2
		v_mov_b32_e32 v5, 2
		v_mul_lo_u32 v5, v5, v12
		v_lshrrev_b32_e32 v7, 5, v0
		v_and_b32_e32 v10, 1, v7
		v_mov_b32_e32 v13, 4
		v_mul_lo_u32 v13, v13, v10
		v_bitop3_b32 v15, v9, v5, v13 bitop3:0x96
		v_mov_b32_e32 v17, 8
		v_mul_lo_u32 v17, v17, v14
		v_xor_b32_e32 v15, v15, v17
		v_mov_b32_e32 v18, 16
		v_mul_lo_u32 v18, v18, v16
		v_xad_u32 v15, v15, v18, s1
		v_bitop3_b32 v19, 32, v9, v5 bitop3:0x96
		v_bitop3_b32 v19, v19, v13, v17 bitop3:0x96
		v_xad_u32 v19, v19, v18, s1
		v_bitop3_b32 v20, 64, v9, v5 bitop3:0x96
		v_bitop3_b32 v20, v20, v13, v17 bitop3:0x96
		v_xad_u32 v20, v20, v18, s1
		v_xor_b32_e32 v21, 0x60, v9
		v_xor_b32_e32 v21, v21, v5
		v_xor_b32_e32 v21, v21, v13
		v_xor_b32_e32 v21, v21, v17
		v_xad_u32 v21, v21, v18, s1
		v_xor_b32_e32 v22, 0x80, v9
		v_xor_b32_e32 v22, v22, v5
		v_xor_b32_e32 v22, v22, v13
		v_xor_b32_e32 v22, v22, v17
		v_xad_u32 v22, v22, v18, s1
		v_xor_b32_e32 v23, 0xa0, v9
		v_xor_b32_e32 v23, v23, v5
		v_xor_b32_e32 v23, v23, v13
		v_xor_b32_e32 v23, v23, v17
		v_xad_u32 v23, v23, v18, s1
		v_xor_b32_e32 v24, 0xc0, v9
		v_xor_b32_e32 v24, v24, v5
		v_xor_b32_e32 v24, v24, v13
		v_xor_b32_e32 v24, v24, v17
		v_xad_u32 v24, v24, v18, s1
		v_xor_b32_e32 v25, 0xe0, v9
		v_xor_b32_e32 v5, v25, v5
		v_xor_b32_e32 v5, v5, v13
		v_xor_b32_e32 v5, v5, v17
		v_xad_u32 v5, v5, v18, s1
		s_mov_b32 s26, 0x7fffffff
		s_mov_b32 s27, 0x31016000
		s_mov_b32 s24, s2
		s_mov_b32 s25, s3
		v_accvgpr_read_b32 v17, a6
		v_and_b32_e32 v17, 0xffff, v17
		v_lshlrev_b32_e32 v18, 16, v17
		v_or_b32_e32 v28, v17, v18
		v_mov_b32_e32 v29, v28
		v_mov_b32_e32 v30, v28
		v_mov_b32_e32 v31, v28
		v_accvgpr_read_b32 v17, a11
		s_nop 0
		v_readfirstlane_b32 s19, v17
		s_mul_i32 s19, s19, s12
		s_lshl_b32 s19, s19, 9
		v_readfirstlane_b32 s22, v1
		s_mul_i32 s22, s22, s10
		s_lshl_b32 s22, s22, 1
		s_add_i32 s23, s19, s22
		v_accvgpr_read_b32 v17, a10
		s_nop 0
		v_readfirstlane_b32 s28, v17
		s_mul_i32 s28, s28, s11
		s_lshl_b32 s28, s28, 1
		s_add_i32 s23, s23, s28
		v_mul_lo_u32 v17, s12, v8
		v_lshl_add_u32 v18, v17, 1, s23
		v_and_b32_e32 v25, 1, v0
		v_accvgpr_write_b32 a15, v25
		v_accvgpr_read_b32 v25, a15
		v_lshl_add_u32 v18, v25, 4, v18
		v_and_b32_e32 v25, 1, v4
		v_accvgpr_write_b32 a16, v25
		v_accvgpr_read_b32 v25, a16
		v_lshl_add_u32 v18, v25, 6, v18
		v_and_b32_e32 v3, 1, v3
		v_accvgpr_write_b32 a17, v3
		v_accvgpr_read_b32 v3, a17
		v_lshl_add_u32 v3, v3, 5, v18
		v_cmp_lt_i32_e64 vcc, v15, s20
		s_and_saveexec_b64 s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_16
		buffer_load_dwordx4 v[32:35], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_16:
		s_andn2_b64 exec, s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_16
		v_mov_b32_e32 v32, v28
		v_mov_b32_e32 v33, v29
		v_mov_b32_e32 v34, v30
		v_mov_b32_e32 v35, v31
.L_attn_fwd_persistent.exec_endif_16:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s23, s12, 6
		s_add_i32 s23, s23, s19
		s_add_i32 s23, s23, s22
		s_add_i32 s23, s23, s28
		v_lshl_add_u32 v3, v17, 1, s23
		v_accvgpr_read_b32 v15, a15
		v_lshl_add_u32 v3, v15, 4, v3
		v_accvgpr_read_b32 v15, a16
		v_lshl_add_u32 v3, v15, 6, v3
		v_accvgpr_read_b32 v15, a17
		v_lshl_add_u32 v3, v15, 5, v3
		v_cmp_lt_i32_e64 vcc, v19, s20
		s_and_saveexec_b64 s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_17
		buffer_load_dwordx4 v[36:39], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_17:
		s_andn2_b64 exec, s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_17
		v_mov_b32_e32 v36, v28
		v_mov_b32_e32 v37, v29
		v_mov_b32_e32 v38, v30
		v_mov_b32_e32 v39, v31
.L_attn_fwd_persistent.exec_endif_17:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s23, s12, 7
		s_add_i32 s23, s23, s19
		s_add_i32 s23, s23, s22
		s_add_i32 s23, s23, s28
		v_lshl_add_u32 v3, v17, 1, s23
		v_accvgpr_read_b32 v15, a15
		v_lshl_add_u32 v3, v15, 4, v3
		v_accvgpr_read_b32 v15, a16
		v_lshl_add_u32 v3, v15, 6, v3
		v_accvgpr_read_b32 v15, a17
		v_lshl_add_u32 v3, v15, 5, v3
		v_cmp_lt_i32_e64 vcc, v20, s20
		s_and_saveexec_b64 s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_18
		buffer_load_dwordx4 v[40:43], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_18:
		s_andn2_b64 exec, s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_18
		v_mov_b32_e32 v40, v28
		v_mov_b32_e32 v41, v29
		v_mov_b32_e32 v42, v30
		v_mov_b32_e32 v43, v31
.L_attn_fwd_persistent.exec_endif_18:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s23, 0xc0, s12
		s_add_i32 s23, s23, s19
		s_add_i32 s23, s23, s22
		s_add_i32 s23, s23, s28
		v_lshl_add_u32 v3, v17, 1, s23
		v_accvgpr_read_b32 v15, a15
		v_lshl_add_u32 v3, v15, 4, v3
		v_accvgpr_read_b32 v15, a16
		v_lshl_add_u32 v3, v15, 6, v3
		v_accvgpr_read_b32 v15, a17
		v_lshl_add_u32 v3, v15, 5, v3
		v_cmp_lt_i32_e64 vcc, v21, s20
		s_and_saveexec_b64 s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_19
		buffer_load_dwordx4 v[44:47], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_19:
		s_andn2_b64 exec, s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_19
		v_mov_b32_e32 v44, v28
		v_mov_b32_e32 v45, v29
		v_mov_b32_e32 v46, v30
		v_mov_b32_e32 v47, v31
.L_attn_fwd_persistent.exec_endif_19:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s23, s12, 8
		s_add_i32 s23, s23, s19
		s_add_i32 s23, s23, s22
		s_add_i32 s23, s23, s28
		v_lshl_add_u32 v3, v17, 1, s23
		v_accvgpr_read_b32 v15, a15
		v_lshl_add_u32 v3, v15, 4, v3
		v_accvgpr_read_b32 v15, a16
		v_lshl_add_u32 v3, v15, 6, v3
		v_accvgpr_read_b32 v15, a17
		v_lshl_add_u32 v3, v15, 5, v3
		v_cmp_lt_i32_e64 vcc, v22, s20
		s_and_saveexec_b64 s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_20
		buffer_load_dwordx4 v[48:51], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_20:
		s_andn2_b64 exec, s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_20
		v_mov_b32_e32 v48, v28
		v_mov_b32_e32 v49, v29
		v_mov_b32_e32 v50, v30
		v_mov_b32_e32 v51, v31
.L_attn_fwd_persistent.exec_endif_20:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s23, 0x140, s12
		s_add_i32 s23, s23, s19
		s_add_i32 s23, s23, s22
		s_add_i32 s23, s23, s28
		v_lshl_add_u32 v3, v17, 1, s23
		v_accvgpr_read_b32 v15, a15
		v_lshl_add_u32 v3, v15, 4, v3
		v_accvgpr_read_b32 v15, a16
		v_lshl_add_u32 v3, v15, 6, v3
		v_accvgpr_read_b32 v15, a17
		v_lshl_add_u32 v3, v15, 5, v3
		v_cmp_lt_i32_e64 vcc, v23, s20
		s_and_saveexec_b64 s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_21
		buffer_load_dwordx4 v[20:23], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_21:
		s_andn2_b64 exec, s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_21
		v_mov_b32_e32 v20, v28
		v_mov_b32_e32 v21, v29
		v_mov_b32_e32 v22, v30
		v_mov_b32_e32 v23, v31
.L_attn_fwd_persistent.exec_endif_21:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s23, 0x180, s12
		s_add_i32 s23, s23, s19
		s_add_i32 s23, s23, s22
		s_add_i32 s23, s23, s28
		v_lshl_add_u32 v3, v17, 1, s23
		v_accvgpr_read_b32 v15, a15
		v_lshl_add_u32 v3, v15, 4, v3
		v_accvgpr_read_b32 v15, a16
		v_lshl_add_u32 v3, v15, 6, v3
		v_accvgpr_read_b32 v15, a17
		v_lshl_add_u32 v3, v15, 5, v3
		v_cmp_lt_i32_e64 vcc, v24, s20
		s_and_saveexec_b64 s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_22
		buffer_load_dwordx4 v[24:27], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_22:
		s_andn2_b64 exec, s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_22
		v_mov_b32_e32 v24, v28
		v_mov_b32_e32 v25, v29
		v_mov_b32_e32 v26, v30
		v_mov_b32_e32 v27, v31
.L_attn_fwd_persistent.exec_endif_22:
		s_mov_b64 exec, s[100:101]
		s_mul_i32 s23, 0x1c0, s12
		s_add_i32 s19, s23, s19
		s_add_i32 s19, s19, s22
		s_add_i32 s19, s19, s28
		v_lshl_add_u32 v3, v17, 1, s19
		v_accvgpr_read_b32 v15, a15
		v_lshl_add_u32 v3, v15, 4, v3
		v_accvgpr_read_b32 v15, a16
		v_lshl_add_u32 v3, v15, 6, v3
		v_accvgpr_read_b32 v15, a17
		v_lshl_add_u32 v3, v15, 5, v3
		v_cmp_lt_i32_e64 vcc, v5, s20
		s_and_saveexec_b64 s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_23
		buffer_load_dwordx4 v[52:55], v3, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_23:
		s_andn2_b64 exec, s[100:101], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_23
		v_mov_b32_e32 v52, v28
		v_mov_b32_e32 v53, v29
		v_mov_b32_e32 v54, v30
		v_mov_b32_e32 v55, v31
.L_attn_fwd_persistent.exec_endif_23:
		s_mov_b64 exec, s[100:101]
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
		v_accvgpr_read_b32 v3, a12
		v_and_b32_e32 v3, 1, v3
		v_lshlrev_b32_e32 v3, 2, v3
		v_and_b32_e32 v5, 1, v7
		v_accvgpr_write_b32 a18, v5
		v_accvgpr_read_b32 v5, a18
		v_lshlrev_b32_e32 v5, 1, v5
		v_and_b32_e32 v7, 1, v11
		v_accvgpr_write_b32 a19, v7
		v_accvgpr_read_b32 v7, a19
		v_xor_b32_e32 v7, v0, v7
		v_bitop3_b32 v3, v3, v5, v7 bitop3:0x96
		v_lshlrev_b32_e32 v3, 4, v3
		v_add_u32_e32 v3, 0x10000, v3
		ds_write_b128 v3, v[32:35] offset:18864
		ds_write_b128 v3, v[36:39] offset:22960
		ds_write_b128 v3, v[40:43] offset:27056
		ds_write_b128 v3, v[44:47] offset:31152
		v_mov_b32_e32 v5, 32
		v_mul_lo_u32 v5, v5, v12
		v_mov_b32_e32 v7, 2
		v_mul_lo_u32 v7, v7, v16
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_accvgpr_read_b32 v11, a12
		v_lshlrev_b32_e32 v11, 12, v11
		v_add_u32_e32 v11, 0x10000, v11
		v_and_b32_e32 v12, 63, v0
		v_lshrrev_b32_e32 v15, 3, v12
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v16, 6, v15
		v_add_u32_e32 v17, v11, v16
		v_lshrrev_b32_e32 v18, 2, v12
		v_and_b32_e32 v18, 1, v18
		v_lshlrev_b32_e32 v19, 5, v18
		v_add_u32_e32 v28, v17, v19
		v_lshrrev_b32_e32 v29, 5, v12
		v_accvgpr_write_b32 a20, v29
		v_lshrrev_b32_e32 v29, 4, v12
		v_and_b32_e32 v29, 1, v29
		v_lshlrev_b32_e32 v29, 7, v29
		v_lshrrev_b32_e32 v30, 1, v12
		v_and_b32_e32 v30, 1, v30
		v_lshlrev_b32_e32 v31, 4, v30
		v_and_b32_e32 v32, 1, v12
		v_lshlrev_b32_e32 v32, 3, v32
		v_accvgpr_read_b32 v33, a20
		v_add3_u32 v33, v33, v29, v16
		v_add3_u32 v33, v33, v19, v31
		v_add_u32_e32 v34, v32, v33
		v_xor_b32_e32 v34, v34, v30
		v_lshl_add_u32 v28, v34, 4, v28
		ds_read_b128 a[24:27], v28 offset:18864
		v_lshlrev_b32_e32 v18, 1, v18
		v_add3_u32 v34, v32, v33, 2
		v_bitop3_b32 v34, v18, v34, v30 bitop3:0x96
		v_lshl_add_u32 v17, v34, 4, v17
		ds_read_b128 a[28:31], v17 offset:18864
		v_add3_u32 v33, v32, v33, 4
		v_xad_u32 v33, v33, v30, v18
		v_lshlrev_b32_e32 v15, 2, v15
		v_xor_b32_e32 v33, v33, v15
		v_lshl_add_u32 v33, v33, 4, v11
		ds_read_b128 a[32:35], v33 offset:18864
		v_accvgpr_read_b32 v34, a20
		v_add3_u32 v29, 6, v34, v29
		v_add3_u32 v16, v29, v16, v19
		v_add3_u32 v16, v16, v31, v32
		v_xor_b32_e32 v16, v16, v30
		v_bitop3_b32 v15, v15, v18, v16 bitop3:0x96
		v_lshl_add_u32 v11, v15, 4, v11
		ds_read_b128 a[36:39], v11 offset:18864
		v_and_b32_e32 v8, 1, v8
		v_accvgpr_write_b32 a21, v8
		v_and_b32_e32 v8, 31, v12
		v_and_b32_e32 v4, 3, v4
		v_mov_b32_e32 v12, 0x440
		v_mul_lo_u32 v12, v12, v4
		v_accvgpr_write_b32 a22, v12
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v3, v[48:51] offset:18864
		ds_write_b128 v3, v[20:23] offset:22960
		ds_write_b128 v3, v[24:27] offset:27056
		ds_write_b128 v3, v[52:55] offset:31152
		v_accvgpr_read_b32 v3, a11
		s_nop 0
		v_readfirstlane_b32 s19, v3
		s_add_i32 s19, s19, 1
		s_mul_i32 s19, s19, 0x100
		s_mov_b32 s22, 0x7f
		v_readfirstlane_b32 s24, v0
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[40:43], v28 offset:18864
		ds_read_b128 a[44:47], v17 offset:18864
		ds_read_b128 a[48:51], v33 offset:18864
		ds_read_b128 a[52:55], v11 offset:18864
		v_cmp_lt_i32_e64 s[36:37], v6, s20
		s_nop 1
		v_mov_b32_e32 v16, s36
		v_mov_b32_e32 v17, s37
		v_accvgpr_write_b32 a56, v16
		v_accvgpr_write_b32 a57, v17
		v_cmp_lt_i32_e64 s[36:37], v2, s20
		s_nop 1
		v_mov_b32_e32 v2, s36
		v_mov_b32_e32 v3, s37
		v_accvgpr_write_b32 a58, v2
		v_accvgpr_write_b32 a59, v3
		v_accvgpr_read_b32 v2, a5
		s_nop 0
		v_readfirstlane_b32 s23, v2
		s_add_i32 s19, s19, s23
		s_cmp_lt_i32 s21, s19
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_cselect_b32 s19, s21, s19
		s_add_i32 s23, s19, 0x7f
		s_cmp_lt_i32 s23, 0
		s_cselect_b32 s25, s22, 0
		s_add_i32 s23, s23, s25
		s_ashr_i32 s23, s23, 7
		v_accvgpr_read_b32 v2, a5
		s_nop 0
		v_readfirstlane_b32 s25, v2
		s_add_i32 s25, s1, s25
		s_cmp_lt_i32 s25, 0
		s_cselect_b32 s36, s22, 0
		s_add_i32 s25, s25, s36
		s_ashr_i32 s25, s25, 7
		s_cmp_lt_i32 s25, s23
		s_cselect_b32 s25, s25, s23
		s_cmp_gt_i32 s25, 0
		s_cselect_b32 s25, s25, 0
		v_mov_b32_e32 v2, 64
		v_mul_lo_u32 v2, v2, v9
		v_mov_b32_e32 v3, 16
		v_mul_lo_u32 v3, v3, v10
		v_bitop3_b32 v4, v2, v5, v3 bitop3:0x96
		v_bitop3_b32 v4, v4, v14, v7 bitop3:0x96
		v_accvgpr_write_b32 a23, v4
		v_bitop3_b32 v4, 4, v2, v5 bitop3:0x96
		v_xor_b32_e32 v4, v4, v3
		v_bitop3_b32 v6, 8, v2, v5 bitop3:0x96
		v_xor_b32_e32 v6, v6, v3
		v_bitop3_b32 v2, 12, v2, v5 bitop3:0x96
		v_xor_b32_e32 v2, v2, v3
		v_accvgpr_read_b32 v3, a23
		v_cmp_lt_i32_e64 s[36:37], v3, s21
		v_mov_b32_e32 v3, 16
		v_mul_lo_u32 v3, v3, v9
		v_mov_b32_e32 v9, 64
		v_mul_lo_u32 v9, v9, v10
		v_bitop3_b32 v10, v3, v5, v9 bitop3:0x96
		v_bitop3_b32 v10, v10, v14, v7 bitop3:0x96
		v_accvgpr_write_b32 a60, v10
		v_bitop3_b32 v10, 4, v3, v5 bitop3:0x96
		v_xor_b32_e32 v10, v10, v9
		v_bitop3_b32 v11, 8, v3, v5 bitop3:0x96
		v_xor_b32_e32 v11, v11, v9
		v_bitop3_b32 v3, 12, v3, v5 bitop3:0x96
		v_xor_b32_e32 v3, v3, v9
		v_accvgpr_read_b32 v5, a60
		v_cmp_lt_i32_e64 vcc, v5, s21
		v_accvgpr_read_b32 v5, a12
		v_mul_lo_u32 v5, s15, v5
		v_accvgpr_read_b32 v9, a18
		v_mul_lo_u32 v9, s15, v9
		v_lshlrev_b32_e32 v9, 5, v9
		v_lshl_add_u32 v5, v5, 1, v9
		v_accvgpr_read_b32 v9, a19
		v_mul_lo_u32 v9, s15, v9
		v_lshl_add_u32 v5, v9, 6, v5
		v_accvgpr_read_b32 v9, a21
		v_mul_lo_u32 v9, s15, v9
		v_lshlrev_b32_e32 v9, 7, v9
		v_accvgpr_read_b32 v12, a15
		v_lshlrev_b32_e32 v12, 4, v12
		v_add3_u32 v5, v5, v9, v12
		v_accvgpr_read_b32 v9, a16
		v_lshlrev_b32_e32 v9, 6, v9
		v_accvgpr_read_b32 v15, a17
		v_lshlrev_b32_e32 v15, 5, v15
		v_add3_u32 v5, v5, v9, v15
		v_readfirstlane_b32 s38, v1
		s_mul_i32 s38, s38, s13
		s_lshl_b32 s38, s38, 1
		v_accvgpr_read_b32 v16, a10
		s_nop 0
		v_readfirstlane_b32 s39, v16
		s_mul_i32 s39, s39, s14
		s_lshl_b32 s39, s39, 1
		s_add_i32 s40, s38, s39
		v_add_u32_e32 v16, s40, v5
		v_mov_b32_e32 v17, 0x80000000
		v_cndmask_b32_e64 v16, v17, v16, s[36:37]
		s_lshr_b32 s40, s24, 6
		s_mul_i32 s41, 0x410, s40
		s_mov_b32 m0, s41
		v_bitop3_b32 v4, v4, v14, v7 bitop3:0x96
		v_accvgpr_write_b32 a61, v4
		buffer_load_dwordx4 v16, s[28:31], 0 offen lds
		s_lshl_b32 s42, s15, 3
		s_add_i32 s42, s42, s38
		s_add_i32 s42, s42, s39
		v_add_u32_e32 v4, s42, v5
		v_cndmask_b32_e64 v4, v17, v4, s[36:37]
		s_add_i32 m0, m0, 0x1040
		v_bitop3_b32 v6, v6, v14, v7 bitop3:0x96
		v_accvgpr_write_b32 a62, v6
		buffer_load_dwordx4 v4, s[28:31], 0 offen lds
		s_lshl_b32 s42, s15, 4
		s_add_i32 s42, s42, s38
		s_add_i32 s42, s42, s39
		v_add_u32_e32 v4, s42, v5
		v_cndmask_b32_e64 v4, v17, v4, s[36:37]
		s_add_i32 m0, m0, 0x1040
		s_mul_i32 s40, 0x440, s40
		buffer_load_dwordx4 v4, s[28:31], 0 offen lds
		s_mul_i32 s42, 24, s15
		s_add_i32 s42, s42, s38
		s_add_i32 s42, s42, s39
		v_add_u32_e32 v4, s42, v5
		v_cndmask_b32_e64 v4, v17, v4, s[36:37]
		s_add_i32 m0, m0, 0x1040
		v_bitop3_b32 v2, v2, v14, v7 bitop3:0x96
		v_accvgpr_write_b32 a63, v2
		buffer_load_dwordx4 v4, s[28:31], 0 offen lds
		v_accvgpr_read_b32 v2, a12
		v_mul_lo_u32 v2, s17, v2
		v_accvgpr_read_b32 v4, a18
		v_mul_lo_u32 v4, s17, v4
		v_lshlrev_b32_e32 v4, 7, v4
		v_lshl_add_u32 v2, v2, 1, v4
		v_accvgpr_read_b32 v4, a19
		v_mul_lo_u32 v4, s17, v4
		v_lshl_add_u32 v2, v4, 6, v2
		v_accvgpr_read_b32 v4, a21
		v_mul_lo_u32 v4, s17, v4
		v_lshlrev_b32_e32 v4, 5, v4
		v_add3_u32 v2, v2, v4, v12
		v_add3_u32 v2, v2, v9, v15
		v_accvgpr_read_b32 v4, a0
		s_nop 0
		v_readfirstlane_b32 s36, v4
		v_readfirstlane_b32 s37, v1
		s_mul_i32 s36, s37, s36
		s_lshl_b32 s36, s36, 1
		v_accvgpr_read_b32 v4, a1
		s_nop 0
		v_readfirstlane_b32 s37, v4
		v_accvgpr_read_b32 v4, a10
		s_nop 0
		v_readfirstlane_b32 s42, v4
		s_mul_i32 s37, s42, s37
		s_lshl_b32 s37, s37, 1
		s_add_i32 s42, s36, s37
		v_add_u32_e32 v4, s42, v2
		v_cndmask_b32_e32 v4, v17, v4, vcc
		s_add_i32 m0, s40, 0x81f0
		v_bitop3_b32 v6, v10, v14, v7 bitop3:0x96
		v_accvgpr_write_b32 a64, v6
		buffer_load_dwordx4 v4, s[32:35], 0 offen lds
		s_lshl_b32 s42, s17, 3
		s_add_i32 s42, s42, s36
		s_add_i32 s42, s42, s37
		v_add_u32_e32 v4, s42, v2
		v_cndmask_b32_e32 v4, v17, v4, vcc
		s_add_i32 m0, m0, 0x1100
		v_bitop3_b32 v6, v11, v14, v7 bitop3:0x96
		v_accvgpr_write_b32 a65, v6
		buffer_load_dwordx4 v4, s[32:35], 0 offen lds
		s_lshl_b32 s42, s17, 4
		s_add_i32 s42, s42, s36
		s_add_i32 s42, s42, s37
		v_add_u32_e32 v4, s42, v2
		v_cndmask_b32_e32 v4, v17, v4, vcc
		s_add_i32 m0, m0, 0x1100
		v_bitop3_b32 v3, v3, v14, v7 bitop3:0x96
		v_accvgpr_write_b32 a66, v3
		buffer_load_dwordx4 v4, s[32:35], 0 offen lds
		s_mul_i32 s42, 24, s17
		s_add_i32 s42, s42, s36
		s_add_i32 s42, s42, s37
		v_add_u32_e32 v3, s42, v2
		v_cndmask_b32_e32 v3, v17, v3, vcc
		s_add_i32 m0, m0, 0x1100
		s_mul_i32 s42, s25, 0x80
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
		v_mbcnt_lo_u32_b32 v3, -1, 0
		v_mbcnt_hi_u32_b32 v3, -1, v3
		v_and_b32_e32 v4, 1, v3
		v_lshrrev_b32_e32 v6, 4, v3
		v_and_b32_e32 v6, 1, v6
		v_lshlrev_b32_e32 v6, 4, v6
		v_lshrrev_b32_e32 v7, 3, v3
		v_and_b32_e32 v7, 1, v7
		v_lshlrev_b32_e32 v7, 3, v7
		v_add3_u32 v9, v4, v6, v7
		v_lshrrev_b32_e32 v10, 2, v3
		v_and_b32_e32 v10, 1, v10
		v_lshlrev_b32_e32 v10, 2, v10
		v_lshrrev_b32_e32 v3, 1, v3
		v_and_b32_e32 v3, 1, v3
		v_lshlrev_b32_e32 v3, 1, v3
		v_add3_u32 v9, v9, v10, v3
		v_add_u32_e32 v4, 32, v4
		v_bitop3_b32 v3, v10, v4, v3 bitop3:0x96
		v_bitop3_b32 v3, v6, v7, v3 bitop3:0x96
		v_mov_b32_e32 v6, 0x3e38aa3b
		v_mov_b32_e32 v7, 0x3e38aa3b
		s_mov_b32 s25, 0xff800000
		v_mov_b32_e32 v4, s25
		v_mov_b32_e32 v10, s25
		s_mov_b32 s25, 1.0
		v_mov_b32_e32 v14, s25
		v_mov_b32_e32 v15, s25
		s_mov_b32 s25, 0
		v_accvgpr_read_b32 v11, a20
		v_lshlrev_b32_e32 v11, 4, v11
		v_accvgpr_write_b32 a67, v11
		v_lshrrev_b32_e32 v11, 4, v8
		v_lshlrev_b32_e32 v11, 9, v11
		v_accvgpr_write_b32 a68, v11
		v_lshrrev_b32_e32 v11, 3, v8
		v_and_b32_e32 v11, 1, v11
		v_mov_b32_e32 v12, 0x2080
		v_mul_lo_u32 v12, v12, v11
		v_accvgpr_write_b32 a69, v12
		v_lshrrev_b32_e32 v11, 2, v8
		v_and_b32_e32 v11, 1, v11
		v_mov_b32_e32 v12, 0x1040
		v_mul_lo_u32 v12, v12, v11
		v_accvgpr_write_b32 a70, v12
		v_lshrrev_b32_e32 v11, 1, v8
		v_and_b32_e32 v11, 1, v11
		v_mov_b32_e32 v12, 0x820
		v_mul_lo_u32 v12, v12, v11
		v_accvgpr_write_b32 a71, v12
		v_and_b32_e32 v8, 1, v8
		v_mov_b32_e32 v11, 0x410
		v_mul_lo_u32 v11, v11, v8
		v_accvgpr_write_b32 a72, v11
		v_and_b32_e32 v8, 3, v0
		v_accvgpr_write_b32 a73, v8
		v_accvgpr_read_b32 v8, a73
		v_lshlrev_b32_e32 v8, 3, v8
		v_accvgpr_write_b32 a74, v8
		v_accvgpr_read_b32 v8, a18
		v_mov_b32_e32 v11, 0x2200
		v_mul_lo_u32 v11, v11, v8
		v_accvgpr_write_b32 a75, v11
		v_accvgpr_read_b32 v8, a19
		v_lshlrev_b32_e32 v8, 5, v8
		v_accvgpr_write_b32 a76, v8
		s_lshl_b32 s43, s15, 8
		s_add_i32 s43, s43, s38
		s_add_i32 s43, s43, s39
		s_mul_i32 s44, 0x108, s15
		s_add_i32 s44, s44, s38
		s_add_i32 s44, s44, s39
		s_mul_i32 s45, 0x110, s15
		s_add_i32 s45, s45, s38
		s_add_i32 s45, s45, s39
		s_mul_i32 s46, 0x118, s15
		s_add_i32 s38, s46, s38
		s_add_i32 s38, s38, s39
		s_lshl_b32 s39, s17, 8
		s_add_i32 s39, s39, s36
		s_add_i32 s39, s39, s37
		s_mul_i32 s46, 0x108, s17
		s_add_i32 s46, s46, s36
		s_add_i32 s46, s46, s37
		s_mul_i32 s47, 0x110, s17
		s_add_i32 s47, s47, s36
		s_add_i32 s47, s47, s37
		s_mul_i32 s48, 0x118, s17
		s_add_i32 s36, s48, s36
		s_add_i32 s36, s36, s37
		v_lshlrev_b32_e32 v8, 2, v9
		v_accvgpr_write_b32 a77, v8
		v_lshlrev_b32_e32 v3, 2, v3
		v_accvgpr_write_b32 a78, v3
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
		s_lshr_b32 s37, s25, 7
		s_and_b32 s48, s37, 1
		s_mul_i32 s49, 0x4100, s48
		v_accvgpr_read_b32 v3, a67
		v_accvgpr_read_b32 v8, a68
		v_add3_u32 v3, s49, v3, v8
		v_accvgpr_read_b32 v8, a69
		v_accvgpr_read_b32 v9, a70
		v_add3_u32 v3, v3, v8, v9
		v_accvgpr_read_b32 v8, a71
		v_accvgpr_read_b32 v9, a72
		v_add3_u32 v3, v3, v8, v9
		ds_read_b128 v[20:23], v3
		ds_read_b128 v[24:27], v3 offset:32
		ds_read_b128 v[28:31], v3 offset:64
		ds_read_b128 a[80:83], v3 offset:96
		ds_read_b128 v[96:99], v3 offset:256
		ds_read_b128 v[100:103], v3 offset:288
		ds_read_b128 v[104:107], v3 offset:320
		ds_read_b128 a[84:87], v3 offset:352
		ds_read_b128 v[108:111], v3 offset:128
		ds_read_b128 v[112:115], v3 offset:160
		ds_read_b128 v[116:119], v3 offset:192
		ds_read_b128 a[88:91], v3 offset:224
		ds_read_b128 v[120:123], v3 offset:384
		ds_read_b128 a[92:95], v3 offset:416
		ds_read_b128 a[96:99], v3 offset:448
		ds_read_b128 a[100:103], v3 offset:480
		s_mul_i32 s48, 0x4400, s48
		v_accvgpr_read_b32 v3, a74
		v_accvgpr_read_b32 v8, a75
		v_add3_u32 v3, s48, v3, v8
		v_accvgpr_read_b32 v8, a22
		v_accvgpr_read_b32 v9, a76
		v_add3_u32 v3, v3, v9, v8
		ds_read_b64_tr_b16 a[104:105], v3 offset:33264
		ds_read_b64_tr_b16 a[106:107], v3 offset:37616
		ds_read_b64_tr_b16 a[108:109], v3 offset:33392
		ds_read_b64_tr_b16 a[110:111], v3 offset:37744
		ds_read_b64_tr_b16 a[112:113], v3 offset:33520
		ds_read_b64_tr_b16 a[114:115], v3 offset:37872
		ds_read_b64_tr_b16 a[116:117], v3 offset:33648
		ds_read_b64_tr_b16 a[118:119], v3 offset:38000
		ds_read_b64_tr_b16 a[120:121], v3 offset:33776
		ds_read_b64_tr_b16 a[122:123], v3 offset:38128
		ds_read_b64_tr_b16 a[124:125], v3 offset:33904
		ds_read_b64_tr_b16 a[126:127], v3 offset:38256
		ds_read_b64_tr_b16 a[128:129], v3 offset:34032
		ds_read_b64_tr_b16 a[130:131], v3 offset:38384
		ds_read_b64_tr_b16 a[132:133], v3 offset:34160
		ds_read_b64_tr_b16 a[134:135], v3 offset:38512
		ds_read_b64_tr_b16 a[136:137], v3 offset:33328
		ds_read_b64_tr_b16 a[138:139], v3 offset:37680
		ds_read_b64_tr_b16 a[140:141], v3 offset:33456
		ds_read_b64_tr_b16 a[142:143], v3 offset:37808
		ds_read_b64_tr_b16 a[144:145], v3 offset:33584
		ds_read_b64_tr_b16 a[146:147], v3 offset:37936
		ds_read_b64_tr_b16 a[148:149], v3 offset:33712
		ds_read_b64_tr_b16 a[150:151], v3 offset:38064
		ds_read_b64_tr_b16 a[152:153], v3 offset:33840
		ds_read_b64_tr_b16 a[154:155], v3 offset:38192
		ds_read_b64_tr_b16 a[156:157], v3 offset:33968
		ds_read_b64_tr_b16 a[158:159], v3 offset:38320
		ds_read_b64_tr_b16 a[160:161], v3 offset:34096
		ds_read_b64_tr_b16 a[162:163], v3 offset:38448
		ds_read_b64_tr_b16 a[164:165], v3 offset:34224
		ds_read_b64_tr_b16 a[166:167], v3 offset:38576
		s_mul_i32 s48, s15, s25
		s_lshl_b32 s48, s48, 1
		s_add_i32 s49, s43, s48
		v_add_u32_e32 v3, s49, v5
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v8, s48, v5
		s_add_i32 s37, s37, 1
		v_add_u32_e32 v9, s44, v8
		s_and_b32 s37, s37, 1
		v_add_u32_e32 v11, s45, v8
		s_mul_i32 s48, 0x4100, s37
		v_add_u32_e32 v8, s38, v8
		s_add_i32 s48, s41, s48
		v_mfma_f32_32x32x16_bf16 v[128:143], v[20:23], a[24:27], 0
		s_mov_b32 m0, s48
		v_mfma_f32_32x32x16_bf16 v[128:143], v[24:27], a[28:31], v[128:143]
		s_mul_i32 s48, s17, s25
		v_mfma_f32_32x32x16_bf16 v[128:143], v[28:31], a[32:35], v[128:143]
		s_add_i32 s25, s25, 0x80
		v_mfma_f32_32x32x16_bf16 v[144:159], v[20:23], a[40:43], 0
		v_accvgpr_read_b32 v12, a23
		v_add_u32_e32 v12, s25, v12
		v_mfma_f32_32x32x16_bf16 v[144:159], v[24:27], a[44:47], v[144:159]
		v_accvgpr_read_b32 v16, a61
		v_add_u32_e32 v16, s25, v16
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[48:51], v[144:159]
		v_accvgpr_read_b32 v18, a62
		v_add_u32_e32 v18, s25, v18
		v_mfma_f32_32x32x16_bf16 v[160:175], v[96:99], a[24:27], 0
		v_accvgpr_read_b32 v19, a63
		v_add_u32_e32 v19, s25, v19
		v_mfma_f32_32x32x16_bf16 v[160:175], v[100:103], a[28:31], v[160:175]
		v_cmp_lt_i32_e64 s[50:51], v12, s21
		v_mfma_f32_32x32x16_bf16 v[160:175], v[104:107], a[32:35], v[160:175]
		v_accvgpr_read_b32 v12, a60
		v_add_u32_e32 v12, s25, v12
		v_mfma_f32_32x32x16_bf16 v[176:191], v[96:99], a[40:43], 0
		v_accvgpr_read_b32 v20, a64
		v_add_u32_e32 v20, s25, v20
		v_mfma_f32_32x32x16_bf16 v[176:191], v[100:103], a[44:47], v[176:191]
		v_accvgpr_read_b32 v21, a65
		v_add_u32_e32 v21, s25, v21
		v_mfma_f32_32x32x16_bf16 v[176:191], v[104:107], a[48:51], v[176:191]
		v_cmp_lt_i32_e64 s[52:53], v12, s21
		v_mfma_f32_32x32x16_bf16 v[192:207], v[108:111], a[24:27], 0
		v_cndmask_b32_e64 v3, v17, v3, s[50:51]
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[192:207], v[112:115], a[28:31], v[192:207]
		v_cmp_lt_i32_e64 s[50:51], v16, s21
		s_add_i32 m0, m0, 0x1040
		v_cmp_lt_i32_e64 s[54:55], v18, s21
		v_mfma_f32_32x32x16_bf16 v[192:207], v[116:119], a[32:35], v[192:207]
		v_cndmask_b32_e64 v3, v17, v9, s[50:51]
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[208:223], v[108:111], a[40:43], 0
		v_cndmask_b32_e64 v3, v17, v11, s[54:55]
		v_mfma_f32_32x32x16_bf16 v[208:223], v[112:115], a[44:47], v[208:223]
		s_add_i32 m0, m0, 0x1040
		v_mfma_f32_32x32x16_bf16 v[208:223], v[116:119], a[48:51], v[208:223]
		v_cmp_lt_i32_e64 s[50:51], v19, s21
		buffer_load_dwordx4 v3, s[28:31], 0 offen lds
		v_accvgpr_read_b32 v3, a66
		v_add_u32_e32 v3, s25, v3
		v_mfma_f32_32x32x16_bf16 v[96:111], v[120:123], a[24:27], 0
		v_cndmask_b32_e64 v8, v17, v8, s[50:51]
		v_cmp_lt_i32_e64 s[50:51], v20, s21
		s_add_i32 m0, m0, 0x1040
		s_lshl_b32 s48, s48, 1
		buffer_load_dwordx4 v8, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v21, s21
		s_add_i32 s49, s39, s48
		v_mfma_f32_32x32x16_bf16 v[96:111], a[92:95], a[28:31], v[96:111]
		v_add_u32_e32 v8, s49, v2
		v_mfma_f32_32x32x16_bf16 v[96:111], a[96:99], a[32:35], v[96:111]
		v_cndmask_b32_e64 v8, v17, v8, s[52:53]
		v_cmp_lt_i32_e64 vcc, v3, s21
		s_mul_i32 s37, 0x4400, s37
		v_add_u32_e32 v3, s48, v2
		s_add_i32 s37, s40, s37
		v_add_u32_e32 v9, s46, v3
		s_add_i32 m0, s37, 0x81f0
		v_cndmask_b32_e64 v9, v17, v9, s[50:51]
		buffer_load_dwordx4 v8, s[32:35], 0 offen lds
		v_add_u32_e32 v8, s47, v3
		v_cndmask_b32_e64 v8, v17, v8, s[54:55]
		s_add_i32 m0, m0, 0x1100
		v_add_u32_e32 v3, s36, v3
		v_cndmask_b32_e32 v3, v17, v3, vcc
		buffer_load_dwordx4 v9, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], v[120:123], a[40:43], 0
		s_add_i32 m0, m0, 0x1100
		v_mfma_f32_32x32x16_bf16 v[224:239], a[92:95], a[44:47], v[224:239]
		buffer_load_dwordx4 v8, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], a[96:99], a[48:51], v[224:239]
		s_add_i32 m0, m0, 0x1100
		s_cmp_lt_i32 s25, s42
		v_mfma_f32_32x32x16_bf16 v[128:143], a[80:83], a[36:39], v[128:143]
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[160:175], a[84:87], a[36:39], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[88:91], a[36:39], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[100:103], a[36:39], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[100:103], a[52:55], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[80:83], a[52:55], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[84:87], a[52:55], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[88:91], a[52:55], v[208:223]
		s_nop 3
		v_max3_f32 v3, v128, v129, v130
		v_max3_f32 v8, v132, v133, v134
		v_max3_f32 v9, v136, v137, v138
		v_max3_f32 v11, v140, v141, v142
		v_max3_f32 v12, v160, v161, v162
		v_max3_f32 v16, v164, v165, v166
		v_max3_f32 v18, v168, v169, v170
		v_max3_f32 v19, v172, v173, v174
		v_max3_f32 v20, v192, v193, v194
		v_max3_f32 v21, v196, v197, v198
		v_max3_f32 v22, v200, v201, v202
		v_max3_f32 v23, v204, v205, v206
		v_max3_f32 v24, v96, v97, v98
		v_max3_f32 v25, v100, v101, v102
		v_max3_f32 v26, v104, v105, v106
		v_max3_f32 v27, v108, v109, v110
		v_max3_f32 v3, v3, v131, v8
		v_max3_f32 v8, v9, v139, v11
		v_max3_f32 v9, v12, v163, v16
		v_max3_f32 v11, v18, v171, v19
		v_max3_f32 v12, v20, v195, v21
		v_max3_f32 v16, v22, v203, v23
		v_max3_f32 v18, v24, v99, v25
		v_max3_f32 v19, v26, v107, v27
		v_max3_f32 v3, v3, v135, v8
		v_max3_f32 v8, v9, v167, v11
		v_max3_f32 v9, v12, v199, v16
		v_max3_f32 v11, v18, v103, v19
		v_max3_f32 v3, v3, v143, v8
		v_max3_f32 v8, v9, v207, v11
		v_max3_f32 v3, v3, v175, v8
		v_max_f32_e32 v8, v3, v111
		v_mov_b32_e32 v9, v8
		v_max3_f32 v3, v144, v145, v146
		v_max3_f32 v11, v148, v149, v150
		v_max3_f32 v12, v152, v153, v154
		v_max3_f32 v16, v156, v157, v158
		v_max3_f32 v18, v176, v177, v178
		v_max3_f32 v19, v180, v181, v182
		v_max3_f32 v20, v184, v185, v186
		v_max3_f32 v21, v188, v189, v190
		v_max3_f32 v22, v208, v209, v210
		v_max3_f32 v23, v212, v213, v214
		v_max3_f32 v24, v216, v217, v218
		v_max3_f32 v25, v220, v221, v222
		v_max3_f32 v26, v224, v225, v226
		v_max3_f32 v27, v228, v229, v230
		v_max3_f32 v28, v232, v233, v234
		v_max3_f32 v29, v236, v237, v238
		v_permlane32_swap_b32_e32 v8, v9
		v_max3_f32 v3, v3, v147, v11
		v_max3_f32 v11, v12, v155, v16
		v_max3_f32 v12, v18, v179, v19
		v_max3_f32 v16, v20, v187, v21
		v_max3_f32 v18, v22, v211, v23
		v_max3_f32 v19, v24, v219, v25
		v_max3_f32 v20, v26, v227, v27
		v_max3_f32 v21, v28, v235, v29
		v_max3_f32 v3, v3, v151, v11
		v_max3_f32 v11, v12, v183, v16
		v_max3_f32 v12, v18, v215, v19
		v_max3_f32 v16, v20, v231, v21
		v_max3_f32 v3, v3, v159, v11
		v_max3_f32 v11, v12, v223, v16
		v_max3_f32 v3, v3, v191, v11
		v_max_f32_e32 v18, v3, v239
		v_mov_b32_e32 v19, v18
		v_max_f32_e32 v20, v8, v9
		v_mov_b32_e32 v8, v4
		v_permlane32_swap_b32_e32 v18, v19
		v_max_f32_e32 v21, v18, v19
		v_pk_mul_f32 v[18:19], v[20:21], v[6:7]
		v_max_f32_e32 v20, v4, v18
		v_max_f32_e32 v22, v10, v19
		v_mov_b32_e32 v21, v20
		v_pk_fma_f32 v[18:19], v[128:129], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[130:131], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[132:133], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[134:135], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[136:137], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[138:139], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[140:141], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[142:143], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[160:161], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[162:163], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[164:165], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[166:167], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[168:169], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[170:171], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[172:173], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[174:175], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[192:193], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[194:195], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[196:197], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[198:199], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[200:201], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[202:203], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[204:205], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[206:207], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[96:97], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[98:99], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[100:101], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[102:103], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[108:109], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[110:111], v[6:7], v[20:21] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_mov_b32_e32 v23, v22
		v_pk_fma_f32 v[110:111], v[144:145], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[146:147], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[148:149], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[150:151], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[154:155], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[156:157], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[158:159], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[176:177], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[178:179], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[180:181], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[182:183], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[184:185], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[186:187], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[188:189], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[190:191], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[208:209], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[210:211], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[212:213], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[214:215], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[216:217], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[218:219], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[220:221], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[222:223], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[224:225], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[226:227], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[228:229], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[230:231], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[232:233], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[234:235], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[236:237], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[238:239], v[6:7], v[22:23] neg_lo:[0,0,1] neg_hi:[0,0,1]
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
		v_exp_f32_e32 v19, v136
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
		v_exp_f32_e32 v117, v166
		v_exp_f32_e32 v233, v167
		v_exp_f32_e32 v119, v96
		v_exp_f32_e32 v235, v97
		v_exp_f32_e32 v121, v98
		v_exp_f32_e32 v237, v99
		v_exp_f32_e32 v123, v100
		v_exp_f32_e32 v239, v101
		v_exp_f32_e32 v125, v102
		v_exp_f32_e32 v241, v103
		v_exp_f32_e32 v127, v104
		v_exp_f32_e32 v243, v105
		v_exp_f32_e32 v129, v106
		v_exp_f32_e32 v245, v107
		v_exp_f32_e32 v131, v108
		v_exp_f32_e32 v247, v109
		v_exp_f32_e32 v96, v110
		v_exp_f32_e32 v98, v111
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
		v_add_f32_e32 v3, v184, v185
		v_accvgpr_read_b32 v4, a77
		ds_bpermute_b32 v180, v4, v3
		v_accvgpr_read_b32 v4, a78
		ds_bpermute_b32 v182, v4, v3
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
		v_accvgpr_write_b32 a80, v212
		v_accvgpr_write_b32 a81, v213
		v_pk_add_f32 v[212:213], v[176:177], v[178:179]
		v_pk_add_f32 v[184:185], v[184:185], v[186:187]
		v_pk_add_f32 v[186:187], v[188:189], v[190:191]
		v_pk_add_f32 v[188:189], v[192:193], v[194:195]
		v_pk_add_f32 v[190:191], v[196:197], v[198:199]
		v_pk_add_f32 v[192:193], v[200:201], v[202:203]
		v_pk_add_f32 v[194:195], v[204:205], v[206:207]
		v_pk_add_f32 v[196:197], v[208:209], v[210:211]
		v_accvgpr_read_b32 v198, a80
		v_accvgpr_read_b32 v199, a81
		v_pk_add_f32 v[198:199], v[198:199], v[212:213]
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
		v_mov_b32_e32 v180, v20
		v_mov_b32_e32 v181, v22
		v_mov_b32_e32 v9, v10
		v_pk_add_f32 v[10:11], v[8:9], v[180:181] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v8, v10
		v_exp_f32_e32 v180, v11
		v_mov_b32_e32 v9, v8
		v_pk_mul_f32 v[32:33], v[32:33], v[8:9]
		v_pk_mul_f32 v[34:35], v[34:35], v[8:9]
		v_pk_mul_f32 v[36:37], v[36:37], v[8:9]
		v_pk_mul_f32 v[38:39], v[38:39], v[8:9]
		v_pk_mul_f32 v[40:41], v[40:41], v[8:9]
		v_pk_mul_f32 v[42:43], v[42:43], v[8:9]
		v_pk_mul_f32 v[44:45], v[44:45], v[8:9]
		v_pk_mul_f32 v[46:47], v[46:47], v[8:9]
		v_pk_mul_f32 v[48:49], v[48:49], v[8:9]
		v_pk_mul_f32 v[50:51], v[50:51], v[8:9]
		v_pk_mul_f32 v[52:53], v[52:53], v[8:9]
		v_pk_mul_f32 v[54:55], v[54:55], v[8:9]
		v_pk_mul_f32 v[56:57], v[56:57], v[8:9]
		v_pk_mul_f32 v[58:59], v[58:59], v[8:9]
		v_pk_mul_f32 v[60:61], v[60:61], v[8:9]
		v_pk_mul_f32 v[62:63], v[62:63], v[8:9]
		v_mov_b32_e32 v181, v180
		v_pk_mul_f32 v[64:65], v[64:65], v[180:181]
		v_pk_mul_f32 v[66:67], v[66:67], v[180:181]
		v_pk_mul_f32 v[68:69], v[68:69], v[180:181]
		v_pk_mul_f32 v[70:71], v[70:71], v[180:181]
		v_pk_mul_f32 v[72:73], v[72:73], v[180:181]
		v_pk_mul_f32 v[74:75], v[74:75], v[180:181]
		v_pk_mul_f32 v[76:77], v[76:77], v[180:181]
		v_pk_mul_f32 v[78:79], v[78:79], v[180:181]
		v_pk_mul_f32 v[80:81], v[80:81], v[180:181]
		v_pk_mul_f32 v[82:83], v[82:83], v[180:181]
		v_pk_mul_f32 v[84:85], v[84:85], v[180:181]
		v_pk_mul_f32 v[86:87], v[86:87], v[180:181]
		v_pk_mul_f32 v[88:89], v[88:89], v[180:181]
		v_pk_mul_f32 v[90:91], v[90:91], v[180:181]
		v_pk_mul_f32 v[92:93], v[92:93], v[180:181]
		v_pk_mul_f32 v[94:95], v[94:95], v[180:181]
		v_mov_b32_e32 v10, v8
		v_mov_b32_e32 v11, v180
		v_mov_b32_e32 v182, v184
		v_mov_b64_e32 v[8:9], v[14:15]
		v_pk_fma_f32 v[14:15], v[8:9], v[10:11], v[182:183]
		v_cvt_pk_bf16_f32 v190, v24, v220
		v_cvt_pk_bf16_f32 v191, v26, v222
		v_cvt_pk_bf16_f32 v8, v28, v224
		v_cvt_pk_bf16_f32 v9, v30, v226
		v_cvt_pk_bf16_f32 v10, v112, v228
		v_cvt_pk_bf16_f32 v11, v114, v230
		v_cvt_pk_bf16_f32 v180, v116, v232
		v_cvt_pk_bf16_f32 v181, v118, v234
		v_cvt_pk_bf16_f32 v182, v120, v236
		v_cvt_pk_bf16_f32 v183, v122, v238
		v_cvt_pk_bf16_f32 v184, v124, v240
		v_cvt_pk_bf16_f32 v185, v126, v242
		v_cvt_pk_bf16_f32 v186, v128, v244
		v_cvt_pk_bf16_f32 v187, v130, v246
		v_cvt_pk_bf16_f32 v192, v215, v217
		v_cvt_pk_bf16_f32 v193, v19, v219
		v_cvt_pk_bf16_f32 v194, v25, v221
		v_cvt_pk_bf16_f32 v195, v27, v223
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
		v_cvt_pk_bf16_f32 v196, v97, v99
		v_cvt_pk_bf16_f32 v197, v101, v103
		v_cvt_pk_bf16_f32 v198, v105, v107
		v_cvt_pk_bf16_f32 v199, v109, v111
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
		v_permlane32_swap_b32_e32 v8, v10
		v_permlane32_swap_b32_e32 v9, v11
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[32:47], a[104:107], v[188:191], v[32:47]
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		v_mfma_f32_32x32x16_bf16 v[48:63], a[136:139], v[188:191], v[48:63]
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_mfma_f32_32x32x16_bf16 v[32:47], a[108:111], v[8:11], v[32:47]
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_mfma_f32_32x32x16_bf16 v[48:63], a[140:143], v[8:11], v[48:63]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[32:47], a[112:115], v[180:183], v[32:47]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[48:63], a[144:147], v[180:183], v[48:63]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[32:47], a[116:119], v[184:187], v[32:47]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[48:63], a[148:151], v[184:187], v[48:63]
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_mfma_f32_32x32x16_bf16 v[80:95], a[136:139], v[116:119], v[80:95]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[64:79], a[104:107], v[116:119], v[64:79]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[80:95], a[140:143], v[120:123], v[80:95]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
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
		v_mfma_f32_32x32x16_bf16 v[32:47], a[120:123], v[192:195], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[152:155], v[192:195], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[152:155], v[196:199], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[120:123], v[196:199], v[64:79]
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
		v_mov_b32_e32 v4, v20
		v_mov_b32_e32 v10, v22
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_3
.L_attn_fwd_persistent.loop_exit_3:
		s_mul_i32 s23, s23, 0x80
		v_accvgpr_read_b32 v3, a5
		s_nop 0
		v_readfirstlane_b32 s25, v3
		v_accvgpr_read_b32 v3, a13
		s_nop 0
		v_add_u32_e32 v3, s25, v3
		v_add_u32_e32 v3, s1, v3
		v_accvgpr_read_b32 v8, a5
		s_nop 0
		v_readfirstlane_b32 s25, v8
		v_accvgpr_read_b32 v8, a14
		s_nop 0
		v_add_u32_e32 v8, s25, v8
		v_add_u32_e32 v8, s1, v8
		v_xor_b32_e32 v9, 1, v13
		v_accvgpr_write_b32 a13, v9
		v_xor_b32_e32 v9, 2, v13
		v_accvgpr_write_b32 a14, v9
		v_xor_b32_e32 v9, 3, v13
		v_accvgpr_write_b32 a67, v9
		v_xor_b32_e32 v9, 8, v13
		v_accvgpr_write_b32 a74, v9
		v_xor_b32_e32 v9, 9, v13
		v_accvgpr_write_b32 a79, v9
		v_xor_b32_e32 v9, 10, v13
		v_accvgpr_write_b32 a80, v9
		v_xor_b32_e32 v9, 11, v13
		v_accvgpr_write_b32 a81, v9
		v_xor_b32_e32 v9, 16, v13
		v_accvgpr_write_b32 a82, v9
		v_xor_b32_e32 v9, 17, v13
		v_accvgpr_write_b32 a83, v9
		v_xor_b32_e32 v9, 18, v13
		v_accvgpr_write_b32 a84, v9
		v_xor_b32_e32 v9, 19, v13
		v_accvgpr_write_b32 a85, v9
		v_xor_b32_e32 v9, 24, v13
		v_accvgpr_write_b32 a86, v9
		v_xor_b32_e32 v9, 25, v13
		v_accvgpr_write_b32 a87, v9
		v_xor_b32_e32 v9, 26, v13
		v_accvgpr_write_b32 a88, v9
		v_xor_b32_e32 v9, 27, v13
		v_accvgpr_write_b32 a89, v9
		v_xor_b32_e32 v9, 32, v13
		v_accvgpr_write_b32 a90, v9
		v_xor_b32_e32 v9, 33, v13
		v_accvgpr_write_b32 a91, v9
		v_xor_b32_e32 v9, 34, v13
		v_accvgpr_write_b32 a92, v9
		v_xor_b32_e32 v9, 35, v13
		v_accvgpr_write_b32 a93, v9
		v_xor_b32_e32 v9, 40, v13
		v_accvgpr_write_b32 a94, v9
		v_xor_b32_e32 v9, 41, v13
		v_accvgpr_write_b32 a95, v9
		v_xor_b32_e32 v9, 42, v13
		v_accvgpr_write_b32 a96, v9
		v_xor_b32_e32 v9, 43, v13
		v_accvgpr_write_b32 a97, v9
		v_xor_b32_e32 v9, 48, v13
		v_accvgpr_write_b32 a98, v9
		v_xor_b32_e32 v9, 49, v13
		v_accvgpr_write_b32 a99, v9
		v_xor_b32_e32 v9, 50, v13
		v_accvgpr_write_b32 a100, v9
		v_xor_b32_e32 v9, 51, v13
		v_accvgpr_write_b32 a101, v9
		v_xor_b32_e32 v9, 56, v13
		v_accvgpr_write_b32 a102, v9
		v_xor_b32_e32 v9, 57, v13
		v_accvgpr_write_b32 a103, v9
		v_xor_b32_e32 v9, 58, v13
		v_accvgpr_write_b32 a104, v9
		v_xor_b32_e32 v9, 59, v13
		v_accvgpr_write_b32 a105, v9
		v_xor_b32_e32 v9, 64, v13
		v_accvgpr_write_b32 a106, v9
		v_xor_b32_e32 v9, 0x41, v13
		v_accvgpr_write_b32 a107, v9
		v_xor_b32_e32 v9, 0x42, v13
		v_accvgpr_write_b32 a108, v9
		v_xor_b32_e32 v9, 0x43, v13
		v_accvgpr_write_b32 a109, v9
		v_xor_b32_e32 v9, 0x48, v13
		v_accvgpr_write_b32 a110, v9
		v_xor_b32_e32 v9, 0x49, v13
		v_accvgpr_write_b32 a111, v9
		v_xor_b32_e32 v9, 0x4a, v13
		v_accvgpr_write_b32 a112, v9
		v_xor_b32_e32 v9, 0x4b, v13
		v_accvgpr_write_b32 a113, v9
		v_xor_b32_e32 v9, 0x50, v13
		v_accvgpr_write_b32 a114, v9
		v_xor_b32_e32 v9, 0x51, v13
		v_accvgpr_write_b32 a115, v9
		v_xor_b32_e32 v9, 0x52, v13
		v_accvgpr_write_b32 a116, v9
		v_xor_b32_e32 v9, 0x53, v13
		v_accvgpr_write_b32 a117, v9
		v_xor_b32_e32 v9, 0x58, v13
		v_accvgpr_write_b32 a118, v9
		v_xor_b32_e32 v9, 0x59, v13
		v_accvgpr_write_b32 a119, v9
		v_xor_b32_e32 v9, 0x5a, v13
		v_accvgpr_write_b32 a120, v9
		v_xor_b32_e32 v9, 0x5b, v13
		v_accvgpr_write_b32 a121, v9
		v_xor_b32_e32 v9, 0x60, v13
		v_accvgpr_write_b32 a122, v9
		v_xor_b32_e32 v9, 0x61, v13
		v_accvgpr_write_b32 a123, v9
		v_xor_b32_e32 v9, 0x62, v13
		v_accvgpr_write_b32 a124, v9
		v_xor_b32_e32 v9, 0x63, v13
		v_accvgpr_write_b32 a125, v9
		v_xor_b32_e32 v9, 0x68, v13
		v_accvgpr_write_b32 a126, v9
		v_xor_b32_e32 v9, 0x69, v13
		v_accvgpr_write_b32 a127, v9
		v_xor_b32_e32 v9, 0x6a, v13
		v_accvgpr_write_b32 a128, v9
		v_xor_b32_e32 v9, 0x6b, v13
		v_accvgpr_write_b32 a129, v9
		v_xor_b32_e32 v9, 0x70, v13
		v_accvgpr_write_b32 a130, v9
		v_xor_b32_e32 v9, 0x71, v13
		v_accvgpr_write_b32 a131, v9
		v_xor_b32_e32 v9, 0x72, v13
		v_accvgpr_write_b32 a132, v9
		v_xor_b32_e32 v9, 0x73, v13
		v_accvgpr_write_b32 a133, v9
		v_xor_b32_e32 v9, 0x78, v13
		v_accvgpr_write_b32 a134, v9
		v_xor_b32_e32 v9, 0x79, v13
		v_accvgpr_write_b32 a135, v9
		v_xor_b32_e32 v9, 0x7a, v13
		v_accvgpr_write_b32 a136, v9
		v_xor_b32_e32 v9, 0x7b, v13
		v_accvgpr_write_b32 a137, v9
		v_accvgpr_read_b32 v9, a20
		v_accvgpr_read_b32 v11, a68
		v_lshl_add_u32 v9, v9, 4, v11
		v_accvgpr_read_b32 v11, a69
		v_accvgpr_read_b32 v12, a70
		v_add3_u32 v9, v9, v11, v12
		v_accvgpr_read_b32 v11, a71
		v_accvgpr_read_b32 v12, a72
		v_add3_u32 v9, v9, v11, v12
		v_accvgpr_write_b32 a20, v9
		v_accvgpr_read_b32 v9, a73
		v_accvgpr_read_b32 v11, a75
		v_lshl_add_u32 v9, v9, 3, v11
		v_accvgpr_read_b32 v11, a22
		v_accvgpr_read_b32 v12, a76
		v_add3_u32 v9, v9, v12, v11
		v_accvgpr_write_b32 a22, v9
		v_mov_b32_e32 v9, 0xff800000
		s_cmp_lt_i32 s42, s23
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_4
.L_attn_fwd_persistent.loop_head_4:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s1, s42, 0x80
		s_cmp_lt_i32 s42, 0
		s_cselect_b32 s25, s22, 0
		s_add_i32 s25, s42, s25
		s_ashr_i32 s25, s25, 7
		s_cmp_lt_i32 s25, 0
		s_cselect_b32 s37, s16, 0
		s_add_i32 s37, s25, s37
		s_ashr_i32 s37, s37, 1
		s_lshl_b32 s37, s37, 1
		s_xor_b32 s37, s37, -1
		s_add_i32 s37, s37, 1
		s_add_i32 s37, s25, s37
		s_add_i32 s25, s25, 1
		s_cmp_lt_i32 s25, 0
		s_cselect_b32 s40, s16, 0
		s_add_i32 s40, s25, s40
		s_ashr_i32 s40, s40, 1
		s_lshl_b32 s40, s40, 1
		s_xor_b32 s40, s40, -1
		s_add_i32 s40, s40, 1
		s_add_i32 s48, s25, s40
		s_mul_i32 s25, 0x4100, s37
		v_accvgpr_read_b32 v11, a20
		v_add_u32_e32 v11, s25, v11
		ds_read_b128 v[20:23], v11
		ds_read_b128 a[68:71], v11 offset:32
		ds_read_b128 a[140:143], v11 offset:64
		ds_read_b128 a[144:147], v11 offset:96
		ds_read_b128 a[148:151], v11 offset:256
		ds_read_b128 a[152:155], v11 offset:288
		ds_read_b128 a[156:159], v11 offset:320
		ds_read_b128 a[160:163], v11 offset:352
		ds_read_b128 a[164:167], v11 offset:128
		ds_read_b128 a[168:171], v11 offset:160
		ds_read_b128 a[172:175], v11 offset:192
		ds_read_b128 a[176:179], v11 offset:224
		ds_read_b128 v[24:27], v11 offset:384
		ds_read_b128 a[180:183], v11 offset:416
		ds_read_b128 a[184:187], v11 offset:448
		ds_read_b128 a[188:191], v11 offset:480
		s_mul_i32 s25, 0x4400, s37
		v_accvgpr_read_b32 v11, a22
		v_add_u32_e32 v11, s25, v11
		ds_read_b64_tr_b16 a[192:193], v11 offset:33264
		ds_read_b64_tr_b16 a[194:195], v11 offset:37616
		ds_read_b64_tr_b16 a[196:197], v11 offset:33392
		ds_read_b64_tr_b16 a[198:199], v11 offset:37744
		ds_read_b64_tr_b16 a[200:201], v11 offset:33520
		ds_read_b64_tr_b16 a[202:203], v11 offset:37872
		ds_read_b64_tr_b16 a[204:205], v11 offset:33648
		ds_read_b64_tr_b16 a[206:207], v11 offset:38000
		ds_read_b64_tr_b16 a[208:209], v11 offset:33776
		ds_read_b64_tr_b16 a[210:211], v11 offset:38128
		ds_read_b64_tr_b16 a[212:213], v11 offset:33904
		ds_read_b64_tr_b16 a[214:215], v11 offset:38256
		ds_read_b64_tr_b16 a[216:217], v11 offset:34032
		ds_read_b64_tr_b16 a[218:219], v11 offset:38384
		ds_read_b64_tr_b16 a[220:221], v11 offset:34160
		ds_read_b64_tr_b16 a[222:223], v11 offset:38512
		ds_read_b64_tr_b16 a[224:225], v11 offset:33328
		ds_read_b64_tr_b16 a[226:227], v11 offset:37680
		ds_read_b64_tr_b16 a[228:229], v11 offset:33456
		ds_read_b64_tr_b16 a[230:231], v11 offset:37808
		ds_read_b64_tr_b16 a[232:233], v11 offset:33584
		ds_read_b64_tr_b16 a[234:235], v11 offset:37936
		ds_read_b64_tr_b16 a[236:237], v11 offset:33712
		ds_read_b64_tr_b16 a[238:239], v11 offset:38064
		ds_read_b64_tr_b16 a[240:241], v11 offset:33840
		ds_read_b64_tr_b16 a[242:243], v11 offset:38192
		ds_read_b64_tr_b16 a[244:245], v11 offset:33968
		ds_read_b64_tr_b16 a[246:247], v11 offset:38320
		ds_read_b64_tr_b16 a[248:249], v11 offset:34096
		ds_read_b64_tr_b16 a[250:251], v11 offset:38448
		ds_read_b64_tr_b16 a[252:253], v11 offset:34224
		ds_read_b64_tr_b16 a[254:255], v11 offset:38576
		s_cmp_lt_i32 s1, s19
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_4
		v_accvgpr_read_b32 v11, a23
		v_add_u32_e32 v11, s1, v11
		v_cmp_lt_i32_e64 s[40:41], v11, s21
		v_accvgpr_read_b32 v11, a60
		v_add_u32_e32 v11, s1, v11
		v_cmp_lt_i32_e64 s[50:51], v11, s21
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s25, s15, s42
		s_lshl_b32 s37, s25, 1
		s_add_i32 s25, s43, s37
		v_add_u32_e32 v11, s25, v5
		v_cndmask_b32_e64 v11, v17, v11, s[40:41]
		s_mov_b32 s40, 1
		s_mov_b32 s41, 0
		s_mov_b32 s25, 0
		s_mul_i32 s52, s40, s24
		s_mul_hi_u32 s53, s40, s24
		s_mul_i32 s49, s40, s25
		s_add_i32 s53, s53, s49
		s_mul_i32 s49, s41, s24
		s_add_i32 s53, s53, s49
		s_lshr_b64 s[40:41], s[52:53], 6
		s_mov_b32 s52, 0x410
		s_mov_b32 s53, 0
		s_mul_i32 s54, s52, s40
		s_mul_hi_u32 s55, s52, s40
		s_mul_i32 s25, s52, s41
		s_add_i32 s55, s55, s25
		s_mul_i32 s25, s53, s40
		s_add_i32 s55, s55, s25
		s_cmp_lt_i32 s48, 0
		s_cselect_b32 s49, -1, 0
		s_mov_b32 s52, 0x4100
		s_mov_b32 s53, 0
		s_mul_i32 s56, s52, s48
		s_mul_hi_u32 s57, s52, s48
		s_mul_i32 s25, s52, s49
		s_add_i32 s57, s57, s25
		s_mul_i32 s25, s53, s48
		s_add_i32 s57, s57, s25
		s_add_u32 s52, s54, s56
		s_addc_u32 s53, s55, s57
		s_add_u32 s58, s52, 0
		s_addc_u32 s59, s53, 0
		s_mov_b32 m0, s58
		v_accvgpr_read_b32 v12, a61
		v_add_u32_e32 v12, s1, v12
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[52:53], v12, s21
		s_add_i32 s25, s44, s37
		v_add_u32_e32 v11, s25, v5
		v_cndmask_b32_e64 v11, v17, v11, s[52:53]
		s_add_u32 s52, s54, 0x1040
		s_addc_u32 s53, s55, 0
		s_add_u32 s52, s52, s56
		s_addc_u32 s53, s53, s57
		s_add_u32 s58, s52, 0
		s_addc_u32 s59, s53, 0
		s_mov_b32 m0, s58
		v_accvgpr_read_b32 v12, a62
		v_add_u32_e32 v12, s1, v12
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[52:53], v12, s21
		s_add_i32 s25, s45, s37
		v_add_u32_e32 v11, s25, v5
		v_cndmask_b32_e64 v11, v17, v11, s[52:53]
		s_add_u32 s52, s54, 0x2080
		s_addc_u32 s53, s55, 0
		s_add_u32 s52, s52, s56
		s_addc_u32 s53, s53, s57
		s_add_u32 s58, s52, 0
		s_addc_u32 s59, s53, 0
		s_mov_b32 m0, s58
		v_accvgpr_read_b32 v12, a63
		v_add_u32_e32 v12, s1, v12
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[52:53], v12, s21
		s_add_i32 s25, s38, s37
		v_add_u32_e32 v11, s25, v5
		v_cndmask_b32_e64 v11, v17, v11, s[52:53]
		s_add_u32 s52, s54, 0x30c0
		s_addc_u32 s53, s55, 0
		s_add_u32 s52, s52, s56
		s_addc_u32 s53, s53, s57
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		v_accvgpr_read_b32 v12, a64
		v_add_u32_e32 v12, s1, v12
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		s_mul_i32 s25, s17, s42
		s_lshl_b32 s25, s25, 1
		s_add_i32 s37, s39, s25
		v_add_u32_e32 v11, s37, v2
		v_cndmask_b32_e64 v11, v17, v11, s[50:51]
		s_mov_b32 s50, 0x440
		s_mov_b32 s51, 0
		s_mul_i32 s52, s50, s40
		s_mul_hi_u32 s53, s50, s40
		s_mul_i32 s37, s50, s41
		s_add_i32 s53, s53, s37
		s_mul_i32 s37, s51, s40
		s_add_i32 s53, s53, s37
		s_add_u32 s40, s52, 0x81f0
		s_addc_u32 s41, s53, 0
		s_mov_b32 s50, 0x4400
		s_mov_b32 s51, 0
		s_mul_i32 s54, s50, s48
		s_mul_hi_u32 s55, s50, s48
		s_mul_i32 s37, s50, s49
		s_add_i32 s55, s55, s37
		s_mul_i32 s37, s51, s48
		s_add_i32 s55, s55, s37
		s_add_u32 s40, s40, s54
		s_addc_u32 s41, s41, s55
		s_add_u32 s48, s40, 0
		s_addc_u32 s49, s41, 0
		s_mov_b32 m0, s48
		v_accvgpr_read_b32 v16, a65
		v_add_u32_e32 v16, s1, v16
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[40:41], v12, s21
		s_add_i32 s37, s46, s25
		v_add_u32_e32 v11, s37, v2
		v_cndmask_b32_e64 v11, v17, v11, s[40:41]
		s_add_u32 s40, s52, 0x92f0
		s_addc_u32 s41, s53, 0
		s_add_u32 s40, s40, s54
		s_addc_u32 s41, s41, s55
		s_add_u32 s48, s40, 0
		s_addc_u32 s49, s41, 0
		s_mov_b32 m0, s48
		v_accvgpr_read_b32 v12, a66
		v_add_u32_e32 v12, s1, v12
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[40:41], v16, s21
		s_add_i32 s37, s47, s25
		v_add_u32_e32 v11, s37, v2
		s_add_u32 s48, s52, 0xa3f0
		s_addc_u32 s49, s53, 0
		s_add_u32 s48, s48, s54
		s_addc_u32 s49, s49, s55
		s_add_u32 s50, s48, 0
		s_addc_u32 s51, s49, 0
		s_mov_b32 m0, s50
		v_cndmask_b32_e64 v11, v17, v11, s[40:41]
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		s_add_i32 s25, s36, s25
		v_cmp_lt_i32_e64 vcc, v12, s21
		v_add_u32_e32 v11, s25, v2
		s_add_u32 s40, s52, 0xb4f0
		s_addc_u32 s41, s53, 0
		v_cndmask_b32_e32 v11, v17, v11, vcc
		s_add_u32 s40, s40, s54
		s_addc_u32 s41, s41, s55
		s_add_u32 s48, s40, 0
		s_addc_u32 s49, s41, 0
		s_mov_b32 m0, s48
		s_nop 0
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_4
.L_attn_fwd_persistent.if_else_4:
.L_attn_fwd_persistent.if_end_4:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[96:111], v[20:23], a[24:27], 0
		s_cmp_lt_i32 s1, s23
		v_mfma_f32_32x32x16_bf16 v[112:127], a[148:151], a[24:27], 0
		v_mfma_f32_32x32x16_bf16 v[128:143], a[164:167], a[24:27], 0
		v_mfma_f32_32x32x16_bf16 v[144:159], v[24:27], a[24:27], 0
		v_mfma_f32_32x32x16_bf16 v[160:175], v[24:27], a[40:43], 0
		v_mfma_f32_32x32x16_bf16 v[176:191], v[20:23], a[40:43], 0
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
		v_add_u32_e32 v11, s42, v13
		v_accvgpr_read_b32 v12, a13
		v_add_u32_e32 v12, s42, v12
		v_accvgpr_read_b32 v16, a14
		v_add_u32_e32 v16, s42, v16
		v_mfma_f32_32x32x16_bf16 v[176:191], a[140:143], a[48:51], v[176:191]
		v_accvgpr_read_b32 v18, a67
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a68, v18
		v_mfma_f32_32x32x16_bf16 v[192:207], a[156:159], a[48:51], v[192:207]
		v_accvgpr_read_b32 v18, a80
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a69, v18
		v_mfma_f32_32x32x16_bf16 v[208:223], a[172:175], a[48:51], v[208:223]
		v_accvgpr_read_b32 v18, a81
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a70, v18
		v_mfma_f32_32x32x16_bf16 v[96:111], a[144:147], a[36:39], v[96:111]
		v_accvgpr_read_b32 v18, a84
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a71, v18
		v_mfma_f32_32x32x16_bf16 v[112:127], a[160:163], a[36:39], v[112:127]
		v_accvgpr_read_b32 v18, a85
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a72, v18
		v_mfma_f32_32x32x16_bf16 v[128:143], a[176:179], a[36:39], v[128:143]
		v_accvgpr_read_b32 v18, a88
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a73, v18
		v_mfma_f32_32x32x16_bf16 v[144:159], a[188:191], a[36:39], v[144:159]
		v_accvgpr_read_b32 v18, a89
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a75, v18
		v_mfma_f32_32x32x16_bf16 v[160:175], a[188:191], a[52:55], v[160:175]
		v_accvgpr_read_b32 v18, a92
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a76, v18
		v_mfma_f32_32x32x16_bf16 v[176:191], a[144:147], a[52:55], v[176:191]
		v_accvgpr_read_b32 v18, a93
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a138, v18
		v_mfma_f32_32x32x16_bf16 v[192:207], a[160:163], a[52:55], v[192:207]
		v_accvgpr_read_b32 v18, a96
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a139, v18
		v_mfma_f32_32x32x16_bf16 v[208:223], a[176:179], a[52:55], v[208:223]
		v_accvgpr_read_b32 v18, a97
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a140, v18
		v_accvgpr_read_b32 v18, a100
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a141, v18
		v_accvgpr_read_b32 v18, a101
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a142, v18
		v_accvgpr_read_b32 v18, a104
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a143, v18
		v_accvgpr_read_b32 v18, a105
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a144, v18
		v_accvgpr_read_b32 v18, a108
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a145, v18
		v_accvgpr_read_b32 v18, a109
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a146, v18
		v_accvgpr_read_b32 v18, a112
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a147, v18
		v_accvgpr_read_b32 v18, a113
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a148, v18
		v_accvgpr_read_b32 v18, a116
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a149, v18
		v_accvgpr_read_b32 v18, a117
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a150, v18
		v_accvgpr_read_b32 v18, a120
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a151, v18
		v_accvgpr_read_b32 v18, a121
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a152, v18
		v_accvgpr_read_b32 v18, a124
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a153, v18
		v_accvgpr_read_b32 v18, a125
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a154, v18
		v_accvgpr_read_b32 v18, a128
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a155, v18
		v_accvgpr_read_b32 v18, a129
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a156, v18
		v_accvgpr_read_b32 v18, a132
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a157, v18
		v_accvgpr_read_b32 v18, a133
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a158, v18
		v_accvgpr_read_b32 v18, a136
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a159, v18
		v_accvgpr_read_b32 v18, a137
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a160, v18
		v_cmp_ge_i32_e64 s[40:41], v3, v11
		v_cmp_ge_i32_e64 s[48:49], v3, v12
		v_cmp_ge_i32_e64 s[50:51], v3, v16
		v_accvgpr_read_b32 v18, a68
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_accvgpr_read_b32 v18, a74
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a161, v18
		v_accvgpr_read_b32 v18, a79
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a162, v18
		v_cndmask_b32_e32 v19, v9, v99, vcc
		v_accvgpr_read_b32 v18, a161
		v_cmp_ge_i32_e64 s[52:53], v3, v18
		v_accvgpr_read_b32 v18, a162
		v_cmp_ge_i32_e64 s[54:55], v3, v18
		v_accvgpr_read_b32 v18, a69
		v_cmp_ge_i32_e64 s[56:57], v3, v18
		v_accvgpr_read_b32 v18, a70
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_accvgpr_read_b32 v18, a82
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a163, v18
		v_accvgpr_read_b32 v18, a83
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a164, v18
		v_cndmask_b32_e32 v21, v9, v103, vcc
		v_accvgpr_read_b32 v18, a163
		v_cmp_ge_i32_e64 s[58:59], v3, v18
		v_accvgpr_read_b32 v18, a164
		v_cmp_ge_i32_e64 s[60:61], v3, v18
		v_accvgpr_read_b32 v18, a71
		v_cmp_ge_i32_e64 s[62:63], v3, v18
		v_accvgpr_read_b32 v18, a72
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_accvgpr_read_b32 v18, a86
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a165, v18
		v_accvgpr_read_b32 v18, a87
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a166, v18
		v_cndmask_b32_e32 v23, v9, v107, vcc
		v_accvgpr_read_b32 v18, a165
		v_cmp_ge_i32_e64 s[64:65], v3, v18
		v_accvgpr_read_b32 v18, a166
		v_cmp_ge_i32_e64 s[66:67], v3, v18
		v_accvgpr_read_b32 v18, a73
		v_cmp_ge_i32_e64 s[68:69], v3, v18
		v_accvgpr_read_b32 v18, a75
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_accvgpr_read_b32 v18, a90
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a167, v18
		v_accvgpr_read_b32 v18, a91
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a168, v18
		v_cndmask_b32_e32 v25, v9, v111, vcc
		v_accvgpr_read_b32 v18, a167
		v_cmp_ge_i32_e64 s[70:71], v3, v18
		v_accvgpr_read_b32 v18, a168
		v_cmp_ge_i32_e64 s[72:73], v3, v18
		v_accvgpr_read_b32 v18, a76
		v_cmp_ge_i32_e64 s[74:75], v3, v18
		v_accvgpr_read_b32 v18, a138
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_accvgpr_read_b32 v18, a94
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a169, v18
		v_accvgpr_read_b32 v18, a95
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a170, v18
		v_cndmask_b32_e32 v27, v9, v115, vcc
		v_accvgpr_read_b32 v18, a169
		v_cmp_ge_i32_e64 s[76:77], v3, v18
		v_accvgpr_read_b32 v18, a170
		v_cmp_ge_i32_e64 s[78:79], v3, v18
		v_accvgpr_read_b32 v18, a139
		v_cmp_ge_i32_e64 s[80:81], v3, v18
		v_accvgpr_read_b32 v18, a140
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_accvgpr_read_b32 v18, a98
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a171, v18
		v_accvgpr_read_b32 v18, a99
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a172, v18
		v_cndmask_b32_e32 v29, v9, v119, vcc
		v_accvgpr_read_b32 v18, a171
		v_cmp_ge_i32_e64 s[82:83], v3, v18
		v_accvgpr_read_b32 v18, a172
		v_cmp_ge_i32_e64 s[84:85], v3, v18
		v_accvgpr_read_b32 v18, a102
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a173, v18
		v_accvgpr_read_b32 v18, a103
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a174, v18
		v_accvgpr_read_b32 v18, a141
		v_cmp_ge_i32_e64 s[86:87], v3, v18
		v_cndmask_b32_e64 v30, v9, v96, s[40:41]
		v_accvgpr_read_b32 v18, a142
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_cndmask_b32_e64 v224, v9, v100, s[52:53]
		v_cndmask_b32_e64 v226, v9, v104, s[58:59]
		v_cndmask_b32_e32 v229, v9, v123, vcc
		v_accvgpr_read_b32 v18, a173
		v_cmp_ge_i32_e64 s[40:41], v3, v18
		v_accvgpr_read_b32 v18, a174
		v_cmp_ge_i32_e64 s[52:53], v3, v18
		v_accvgpr_read_b32 v18, a106
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a175, v18
		v_accvgpr_read_b32 v18, a107
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a176, v18
		v_accvgpr_read_b32 v18, a143
		v_cmp_ge_i32_e64 s[58:59], v3, v18
		v_accvgpr_read_b32 v18, a144
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_cndmask_b32_e64 v230, v9, v108, s[64:65]
		v_cndmask_b32_e64 v232, v9, v112, s[70:71]
		v_cndmask_b32_e32 v235, v9, v127, vcc
		v_accvgpr_read_b32 v18, a175
		v_cmp_ge_i32_e64 s[64:65], v3, v18
		v_accvgpr_read_b32 v18, a110
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a177, v18
		v_accvgpr_read_b32 v18, a111
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a178, v18
		v_accvgpr_read_b32 v18, a176
		v_cmp_ge_i32_e64 s[70:71], v3, v18
		v_accvgpr_read_b32 v18, a145
		v_cmp_ge_i32_e64 s[88:89], v3, v18
		s_nop 1
		v_mov_b32_e32 v236, s88
		v_mov_b32_e32 v237, s89
		v_accvgpr_write_b32 a180, v236
		v_accvgpr_write_b32 a181, v237
		v_accvgpr_read_b32 v18, a146
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_cndmask_b32_e64 v236, v9, v116, s[76:77]
		v_cndmask_b32_e64 v238, v9, v120, s[82:83]
		v_cndmask_b32_e32 v241, v9, v131, vcc
		v_accvgpr_read_b32 v18, a114
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a179, v18
		v_accvgpr_read_b32 v18, a115
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a182, v18
		v_accvgpr_read_b32 v18, a177
		v_cmp_ge_i32_e64 s[76:77], v3, v18
		v_accvgpr_read_b32 v18, a178
		v_cmp_ge_i32_e64 s[82:83], v3, v18
		s_nop 1
		v_mov_b32_e32 v242, s82
		v_mov_b32_e32 v243, s83
		v_accvgpr_write_b32 a184, v242
		v_accvgpr_write_b32 a185, v243
		v_accvgpr_read_b32 v18, a147
		v_cmp_ge_i32_e64 s[82:83], v3, v18
		s_nop 1
		v_mov_b32_e32 v242, s82
		v_mov_b32_e32 v243, s83
		v_accvgpr_write_b32 a186, v242
		v_accvgpr_write_b32 a187, v243
		v_accvgpr_read_b32 v18, a148
		v_cmp_ge_i32_e64 vcc, v3, v18
		s_mov_b64 s[82:83], vcc
		v_mov_b32_e32 v242, s82
		v_mov_b32_e32 v243, s83
		v_cndmask_b32_e64 v242, v9, v124, s[40:41]
		v_cndmask_b32_e64 v244, v9, v128, s[64:65]
		v_cndmask_b32_e32 v247, v9, v135, vcc
		v_accvgpr_read_b32 v18, a179
		v_cmp_ge_i32_e64 s[40:41], v3, v18
		v_accvgpr_read_b32 v18, a182
		v_cmp_ge_i32_e64 s[64:65], v3, v18
		v_accvgpr_read_b32 v18, a149
		v_cmp_ge_i32_e64 s[82:83], v3, v18
		v_accvgpr_read_b32 v18, a150
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_accvgpr_read_b32 v18, a118
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a183, v18
		v_accvgpr_read_b32 v18, a119
		v_add_u32_e32 v18, s42, v18
		v_accvgpr_write_b32 a188, v18
		v_cndmask_b32_e32 v249, v9, v139, vcc
		v_accvgpr_read_b32 v18, a183
		v_cmp_ge_i32_e64 s[88:89], v3, v18
		v_accvgpr_read_b32 v18, a188
		v_cmp_ge_i32_e64 s[90:91], v3, v18
		v_accvgpr_read_b32 v18, a151
		v_cmp_ge_i32_e64 s[92:93], v3, v18
		v_cndmask_b32_e64 v250, v9, v132, s[76:77]
		v_cndmask_b32_e64 v253, v9, v141, s[90:91]
		v_cndmask_b32_e64 v254, v9, v142, s[92:93]
		v_accvgpr_read_b32 v18, a152
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_accvgpr_read_b32 v18, a122
		v_add_u32_e32 v96, s42, v18
		v_accvgpr_read_b32 v18, a123
		v_add_u32_e32 v99, s42, v18
		v_cndmask_b32_e32 v255, v9, v143, vcc
		v_cmp_ge_i32_e64 s[76:77], v3, v96
		v_cmp_ge_i32_e64 s[90:91], v3, v99
		v_accvgpr_read_b32 v18, a153
		v_cmp_ge_i32_e64 s[92:93], v3, v18
		v_cndmask_b32_e64 v142, v9, v144, s[76:77]
		v_cndmask_b32_e64 v143, v9, v145, s[90:91]
		v_cndmask_b32_e64 v144, v9, v146, s[92:93]
		v_accvgpr_read_b32 v18, a154
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_accvgpr_read_b32 v18, a126
		v_add_u32_e32 v100, s42, v18
		v_accvgpr_read_b32 v18, a127
		v_add_u32_e32 v103, s42, v18
		v_cndmask_b32_e32 v145, v9, v147, vcc
		v_cmp_ge_i32_e64 s[76:77], v3, v100
		v_cmp_ge_i32_e64 s[90:91], v3, v103
		v_accvgpr_read_b32 v18, a155
		v_cmp_ge_i32_e64 s[92:93], v3, v18
		v_cndmask_b32_e64 v146, v9, v148, s[76:77]
		v_cndmask_b32_e64 v147, v9, v149, s[90:91]
		v_cndmask_b32_e64 v148, v9, v150, s[92:93]
		v_accvgpr_read_b32 v18, a156
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_accvgpr_read_b32 v18, a130
		v_add_u32_e32 v104, s42, v18
		v_accvgpr_read_b32 v18, a131
		v_add_u32_e32 v107, s42, v18
		v_cndmask_b32_e32 v149, v9, v151, vcc
		v_cmp_ge_i32_e64 s[76:77], v3, v104
		v_cmp_ge_i32_e64 s[90:91], v3, v107
		v_accvgpr_read_b32 v18, a157
		v_cmp_ge_i32_e64 s[92:93], v3, v18
		v_cndmask_b32_e64 v150, v9, v152, s[76:77]
		v_cndmask_b32_e64 v151, v9, v153, s[90:91]
		v_cndmask_b32_e64 v152, v9, v154, s[92:93]
		v_accvgpr_read_b32 v18, a158
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_accvgpr_read_b32 v18, a134
		v_add_u32_e32 v108, s42, v18
		v_accvgpr_read_b32 v18, a135
		v_add_u32_e32 v111, s42, v18
		v_cndmask_b32_e32 v153, v9, v155, vcc
		v_cmp_ge_i32_e64 s[76:77], v3, v108
		v_cmp_ge_i32_e64 s[90:91], v3, v111
		v_accvgpr_read_b32 v18, a159
		v_cmp_ge_i32_e64 s[92:93], v3, v18
		v_cndmask_b32_e64 v154, v9, v156, s[76:77]
		v_cndmask_b32_e64 v155, v9, v157, s[90:91]
		v_cndmask_b32_e64 v156, v9, v158, s[92:93]
		v_cndmask_b32_e64 v31, v9, v97, s[48:49]
		v_accvgpr_read_b32 v18, a160
		v_cmp_ge_i32_e64 vcc, v3, v18
		v_max3_f32 v97, v142, v143, v144
		v_max3_f32 v112, v146, v147, v148
		v_cndmask_b32_e32 v157, v9, v159, vcc
		v_cmp_ge_i32_e64 s[48:49], v8, v11
		v_cmp_ge_i32_e64 s[76:77], v8, v12
		v_cmp_ge_i32_e64 s[90:91], v8, v16
		v_max3_f32 v11, v150, v151, v152
		v_max3_f32 v12, v154, v155, v156
		v_cndmask_b32_e64 v158, v9, v178, s[90:91]
		v_accvgpr_read_b32 v16, a68
		v_cmp_ge_i32_e64 vcc, v8, v16
		v_cndmask_b32_e64 v18, v9, v98, s[50:51]
		v_max3_f32 v16, v30, v31, v18
		v_cndmask_b32_e32 v159, v9, v179, vcc
		v_accvgpr_read_b32 v20, a161
		v_cmp_ge_i32_e64 s[50:51], v8, v20
		v_accvgpr_read_b32 v20, a162
		v_cmp_ge_i32_e64 s[90:91], v8, v20
		v_accvgpr_read_b32 v20, a69
		v_cmp_ge_i32_e64 s[92:93], v8, v20
		v_cndmask_b32_e64 v178, v9, v180, s[50:51]
		v_cndmask_b32_e64 v179, v9, v181, s[90:91]
		v_cndmask_b32_e64 v180, v9, v182, s[92:93]
		v_accvgpr_read_b32 v20, a70
		v_cmp_ge_i32_e64 vcc, v8, v20
		v_cndmask_b32_e64 v225, v9, v101, s[54:55]
		v_cndmask_b32_e64 v20, v9, v102, s[56:57]
		v_cndmask_b32_e32 v181, v9, v183, vcc
		v_accvgpr_read_b32 v22, a163
		v_cmp_ge_i32_e64 s[50:51], v8, v22
		v_accvgpr_read_b32 v22, a164
		v_cmp_ge_i32_e64 s[54:55], v8, v22
		v_accvgpr_read_b32 v22, a71
		v_cmp_ge_i32_e64 s[56:57], v8, v22
		v_cndmask_b32_e64 v182, v9, v184, s[50:51]
		v_cndmask_b32_e64 v183, v9, v185, s[54:55]
		v_cndmask_b32_e64 v184, v9, v186, s[56:57]
		v_accvgpr_read_b32 v22, a72
		v_cmp_ge_i32_e64 vcc, v8, v22
		v_cndmask_b32_e64 v227, v9, v105, s[60:61]
		v_max3_f32 v98, v224, v225, v20
		v_cndmask_b32_e32 v185, v9, v187, vcc
		v_accvgpr_read_b32 v22, a165
		v_cmp_ge_i32_e64 s[50:51], v8, v22
		v_accvgpr_read_b32 v22, a166
		v_cmp_ge_i32_e64 s[54:55], v8, v22
		v_accvgpr_read_b32 v22, a73
		v_cmp_ge_i32_e64 s[56:57], v8, v22
		v_cndmask_b32_e64 v186, v9, v188, s[50:51]
		v_cndmask_b32_e64 v187, v9, v189, s[54:55]
		v_cndmask_b32_e64 v188, v9, v190, s[56:57]
		v_accvgpr_read_b32 v22, a75
		v_cmp_ge_i32_e64 vcc, v8, v22
		v_cndmask_b32_e64 v22, v9, v106, s[62:63]
		v_max3_f32 v101, v226, v227, v22
		v_cndmask_b32_e32 v189, v9, v191, vcc
		v_accvgpr_read_b32 v24, a167
		v_cmp_ge_i32_e64 s[50:51], v8, v24
		v_accvgpr_read_b32 v24, a168
		v_cmp_ge_i32_e64 s[54:55], v8, v24
		v_accvgpr_read_b32 v24, a76
		v_cmp_ge_i32_e64 s[56:57], v8, v24
		v_cndmask_b32_e64 v190, v9, v192, s[50:51]
		v_cndmask_b32_e64 v191, v9, v193, s[54:55]
		v_cndmask_b32_e64 v192, v9, v194, s[56:57]
		v_accvgpr_read_b32 v24, a138
		v_cmp_ge_i32_e64 vcc, v8, v24
		v_cndmask_b32_e64 v231, v9, v109, s[66:67]
		v_cndmask_b32_e64 v24, v9, v110, s[68:69]
		v_cndmask_b32_e32 v193, v9, v195, vcc
		v_accvgpr_read_b32 v26, a169
		v_cmp_ge_i32_e64 s[50:51], v8, v26
		v_accvgpr_read_b32 v26, a170
		v_cmp_ge_i32_e64 s[54:55], v8, v26
		v_accvgpr_read_b32 v26, a139
		v_cmp_ge_i32_e64 s[56:57], v8, v26
		v_cndmask_b32_e64 v194, v9, v196, s[50:51]
		v_cndmask_b32_e64 v195, v9, v197, s[54:55]
		v_cndmask_b32_e64 v196, v9, v198, s[56:57]
		v_accvgpr_read_b32 v26, a140
		v_cmp_ge_i32_e64 vcc, v8, v26
		v_cndmask_b32_e64 v233, v9, v113, s[72:73]
		v_max3_f32 v102, v230, v231, v24
		v_cndmask_b32_e32 v197, v9, v199, vcc
		v_accvgpr_read_b32 v26, a171
		v_cmp_ge_i32_e64 s[50:51], v8, v26
		v_accvgpr_read_b32 v26, a172
		v_cmp_ge_i32_e64 s[54:55], v8, v26
		v_accvgpr_read_b32 v26, a141
		v_cmp_ge_i32_e64 s[56:57], v8, v26
		v_cndmask_b32_e64 v198, v9, v200, s[50:51]
		v_cndmask_b32_e64 v199, v9, v201, s[54:55]
		v_cndmask_b32_e64 v200, v9, v202, s[56:57]
		v_accvgpr_read_b32 v26, a142
		v_cmp_ge_i32_e64 vcc, v8, v26
		v_cndmask_b32_e64 v26, v9, v114, s[74:75]
		v_max3_f32 v105, v232, v233, v26
		v_cndmask_b32_e32 v201, v9, v203, vcc
		v_accvgpr_read_b32 v28, a173
		v_cmp_ge_i32_e64 s[50:51], v8, v28
		v_accvgpr_read_b32 v28, a174
		v_cmp_ge_i32_e64 s[54:55], v8, v28
		v_accvgpr_read_b32 v28, a143
		v_cmp_ge_i32_e64 s[56:57], v8, v28
		v_cndmask_b32_e64 v114, v9, v204, s[50:51]
		v_cndmask_b32_e64 v115, v9, v205, s[54:55]
		v_cndmask_b32_e64 v202, v9, v206, s[56:57]
		v_accvgpr_read_b32 v28, a144
		v_cmp_ge_i32_e64 vcc, v8, v28
		v_cndmask_b32_e64 v237, v9, v117, s[78:79]
		v_cndmask_b32_e64 v28, v9, v118, s[80:81]
		v_cndmask_b32_e32 v203, v9, v207, vcc
		v_accvgpr_read_b32 v106, a175
		v_cmp_ge_i32_e64 s[50:51], v8, v106
		v_accvgpr_read_b32 v106, a176
		v_cmp_ge_i32_e64 s[54:55], v8, v106
		v_accvgpr_read_b32 v106, a145
		v_cmp_ge_i32_e64 s[56:57], v8, v106
		v_cndmask_b32_e64 v116, v9, v208, s[50:51]
		v_cndmask_b32_e64 v117, v9, v209, s[54:55]
		v_cndmask_b32_e64 v118, v9, v210, s[56:57]
		v_accvgpr_read_b32 v106, a146
		v_cmp_ge_i32_e64 vcc, v8, v106
		v_cndmask_b32_e64 v239, v9, v121, s[84:85]
		v_max3_f32 v106, v236, v237, v28
		v_cndmask_b32_e32 v119, v9, v211, vcc
		v_accvgpr_read_b32 v109, a177
		v_cmp_ge_i32_e64 s[50:51], v8, v109
		v_accvgpr_read_b32 v109, a178
		v_cmp_ge_i32_e64 s[54:55], v8, v109
		v_accvgpr_read_b32 v109, a147
		v_cmp_ge_i32_e64 s[56:57], v8, v109
		v_cndmask_b32_e64 v120, v9, v212, s[50:51]
		v_cndmask_b32_e64 v121, v9, v213, s[54:55]
		v_cndmask_b32_e64 v204, v9, v214, s[56:57]
		v_accvgpr_read_b32 v109, a148
		v_cmp_ge_i32_e64 vcc, v8, v109
		v_cndmask_b32_e64 v228, v9, v122, s[86:87]
		v_max3_f32 v109, v238, v239, v228
		v_cndmask_b32_e32 v205, v9, v215, vcc
		v_accvgpr_read_b32 v110, a179
		v_cmp_ge_i32_e64 s[50:51], v8, v110
		v_accvgpr_read_b32 v110, a182
		v_cmp_ge_i32_e64 s[54:55], v8, v110
		v_accvgpr_read_b32 v110, a149
		v_cmp_ge_i32_e64 s[56:57], v8, v110
		v_cndmask_b32_e64 v122, v9, v216, s[50:51]
		v_cndmask_b32_e64 v123, v9, v217, s[54:55]
		v_cndmask_b32_e64 v206, v9, v218, s[56:57]
		v_accvgpr_read_b32 v110, a150
		v_cmp_ge_i32_e64 vcc, v8, v110
		v_cndmask_b32_e64 v243, v9, v125, s[52:53]
		v_cndmask_b32_e64 v234, v9, v126, s[58:59]
		v_cndmask_b32_e32 v207, v9, v219, vcc
		v_accvgpr_read_b32 v110, a183
		v_cmp_ge_i32_e64 s[50:51], v8, v110
		v_accvgpr_read_b32 v110, a188
		v_cmp_ge_i32_e64 s[52:53], v8, v110
		v_accvgpr_read_b32 v110, a151
		v_cmp_ge_i32_e64 s[54:55], v8, v110
		v_cndmask_b32_e64 v124, v9, v220, s[50:51]
		v_cndmask_b32_e64 v125, v9, v221, s[52:53]
		v_cndmask_b32_e64 v126, v9, v222, s[54:55]
		v_accvgpr_read_b32 v110, a152
		v_cmp_ge_i32_e64 vcc, v8, v110
		v_cndmask_b32_e64 v245, v9, v129, s[70:71]
		v_max3_f32 v110, v242, v243, v234
		v_cndmask_b32_e32 v127, v9, v223, vcc
		v_cmp_ge_i32_e64 s[50:51], v8, v96
		v_cmp_ge_i32_e64 s[52:53], v8, v99
		v_accvgpr_read_b32 v96, a153
		v_cmp_ge_i32_e64 s[54:55], v8, v96
		v_cndmask_b32_e64 v128, v9, v160, s[50:51]
		v_cndmask_b32_e64 v129, v9, v161, s[52:53]
		v_cndmask_b32_e64 v160, v9, v162, s[54:55]
		v_accvgpr_read_b32 v96, a154
		v_cmp_ge_i32_e64 vcc, v8, v96
		v_accvgpr_read_b32 v96, a180
		s_nop 0
		v_readfirstlane_b32 s50, v96
		v_accvgpr_read_b32 v96, a181
		s_nop 0
		v_readfirstlane_b32 s51, v96
		s_nop 1
		v_cndmask_b32_e64 v240, v9, v130, s[50:51]
		v_max3_f32 v96, v244, v245, v240
		v_cndmask_b32_e32 v161, v9, v163, vcc
		v_cmp_ge_i32_e64 s[50:51], v8, v100
		v_cmp_ge_i32_e64 s[52:53], v8, v103
		v_accvgpr_read_b32 v99, a155
		v_cmp_ge_i32_e64 s[54:55], v8, v99
		v_cndmask_b32_e64 v130, v9, v164, s[50:51]
		v_cndmask_b32_e64 v131, v9, v165, s[52:53]
		v_cndmask_b32_e64 v162, v9, v166, s[54:55]
		v_accvgpr_read_b32 v99, a156
		v_cmp_ge_i32_e64 vcc, v8, v99
		v_accvgpr_read_b32 v99, a184
		s_nop 0
		v_readfirstlane_b32 s50, v99
		v_accvgpr_read_b32 v99, a185
		s_nop 0
		v_readfirstlane_b32 s51, v99
		s_nop 1
		v_cndmask_b32_e64 v251, v9, v133, s[50:51]
		v_accvgpr_read_b32 v99, a186
		s_nop 0
		v_readfirstlane_b32 s50, v99
		v_accvgpr_read_b32 v99, a187
		s_nop 0
		v_readfirstlane_b32 s51, v99
		s_nop 1
		v_cndmask_b32_e64 v246, v9, v134, s[50:51]
		v_cndmask_b32_e32 v163, v9, v167, vcc
		v_cmp_ge_i32_e64 s[50:51], v8, v104
		v_cmp_ge_i32_e64 s[52:53], v8, v107
		v_accvgpr_read_b32 v99, a157
		v_cmp_ge_i32_e64 s[54:55], v8, v99
		v_cndmask_b32_e64 v132, v9, v168, s[50:51]
		v_cndmask_b32_e64 v133, v9, v169, s[52:53]
		v_cndmask_b32_e64 v134, v9, v170, s[54:55]
		v_accvgpr_read_b32 v99, a158
		v_cmp_ge_i32_e64 vcc, v8, v99
		v_cndmask_b32_e64 v164, v9, v136, s[40:41]
		v_cndmask_b32_e64 v165, v9, v137, s[64:65]
		v_cndmask_b32_e32 v135, v9, v171, vcc
		v_cmp_ge_i32_e64 s[40:41], v8, v108
		v_cmp_ge_i32_e64 s[50:51], v8, v111
		v_accvgpr_read_b32 v99, a159
		v_cmp_ge_i32_e64 s[52:53], v8, v99
		v_cndmask_b32_e64 v136, v9, v172, s[40:41]
		v_cndmask_b32_e64 v137, v9, v173, s[50:51]
		v_cndmask_b32_e64 v166, v9, v174, s[52:53]
		v_accvgpr_read_b32 v99, a160
		v_cmp_ge_i32_e64 vcc, v8, v99
		v_cndmask_b32_e64 v248, v9, v138, s[82:83]
		v_cndmask_b32_e64 v252, v9, v140, s[88:89]
		v_cndmask_b32_e32 v167, v9, v175, vcc
		v_max3_f32 v99, v250, v251, v246
		v_max3_f32 v100, v164, v165, v248
		v_max3_f32 v103, v252, v253, v254
		v_max3_f32 v16, v16, v19, v98
		v_max3_f32 v98, v101, v23, v102
		v_max3_f32 v101, v105, v27, v106
		v_max3_f32 v102, v109, v229, v110
		v_max3_f32 v96, v96, v241, v99
		v_max3_f32 v99, v100, v249, v103
		v_max3_f32 v97, v97, v145, v112
		v_max3_f32 v11, v11, v153, v12
		v_max3_f32 v12, v16, v21, v98
		v_max3_f32 v16, v101, v29, v102
		v_max3_f32 v96, v96, v247, v99
		v_max3_f32 v11, v97, v149, v11
		v_max3_f32 v12, v12, v25, v16
		v_max3_f32 v11, v96, v255, v11
		v_max3_f32 v11, v12, v235, v11
		v_max_f32_e32 v96, v11, v157
		v_mov_b32_e32 v97, v96
		v_cndmask_b32_e64 v98, v9, v176, s[48:49]
		v_cndmask_b32_e64 v99, v9, v177, s[76:77]
		v_permlane32_swap_b32_e32 v96, v97
		v_max3_f32 v11, v98, v99, v158
		v_max3_f32 v12, v178, v179, v180
		v_max3_f32 v16, v182, v183, v184
		v_max3_f32 v100, v186, v187, v188
		v_max3_f32 v101, v190, v191, v192
		v_max3_f32 v102, v194, v195, v196
		v_max3_f32 v103, v198, v199, v200
		v_max3_f32 v104, v114, v115, v202
		v_max3_f32 v105, v116, v117, v118
		v_max3_f32 v106, v120, v121, v204
		v_max3_f32 v107, v122, v123, v206
		v_max3_f32 v108, v124, v125, v126
		v_max3_f32 v109, v128, v129, v160
		v_max3_f32 v110, v130, v131, v162
		v_max3_f32 v111, v132, v133, v134
		v_max3_f32 v112, v136, v137, v166
		v_max3_f32 v11, v11, v159, v12
		v_max3_f32 v12, v16, v185, v100
		v_max3_f32 v16, v101, v193, v102
		v_max3_f32 v100, v103, v201, v104
		v_max3_f32 v101, v105, v119, v106
		v_max3_f32 v102, v107, v207, v108
		v_max3_f32 v103, v109, v161, v110
		v_max3_f32 v104, v111, v135, v112
		v_max3_f32 v11, v11, v181, v12
		v_max3_f32 v12, v16, v197, v100
		v_max3_f32 v16, v101, v205, v102
		v_max3_f32 v100, v103, v163, v104
		v_max3_f32 v11, v11, v189, v12
		v_max3_f32 v12, v16, v127, v100
		v_max3_f32 v11, v11, v203, v12
		v_max_f32_e32 v100, v11, v167
		v_mov_b32_e32 v101, v100
		v_max_f32_e32 v102, v96, v97
		v_mov_b32_e32 v96, v4
		v_permlane32_swap_b32_e32 v100, v101
		v_max_f32_e32 v103, v100, v101
		v_pk_mul_f32 v[100:101], v[102:103], v[6:7]
		v_max_f32_e32 v102, v4, v100
		v_max_f32_e32 v104, v10, v101
		v_mov_b32_e32 v103, v102
		v_pk_fma_f32 v[100:101], v[30:31], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[18:19], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[18:19], v[224:225], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[20:21], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[20:21], v[226:227], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[22:23], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[22:23], v[230:231], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[24:25], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[232:233], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[26:27], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[236:237], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[28:29], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[238:239], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[228:229], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[242:243], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[234:235], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[244:245], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[240:241], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[250:251], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[246:247], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[164:165], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[248:249], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[252:253], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[214:215], v[254:255], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[216:217], v[142:143], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[144:145], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[146:147], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[148:149], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[150:151], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[154:155], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[156:157], v[6:7], v[102:103] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_mov_b32_e32 v105, v104
		v_pk_fma_f32 v[156:157], v[98:99], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[158:159], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[178:179], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[180:181], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[182:183], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[184:185], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[186:187], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[188:189], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[190:191], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[192:193], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[194:195], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[196:197], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[198:199], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[200:201], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[114:115], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[202:203], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[116:117], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[118:119], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[120:121], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[204:205], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[122:123], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[206:207], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[124:125], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[126:127], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[128:129], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[160:161], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[130:131], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[162:163], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[132:133], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[134:135], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[136:137], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[166:167], v[6:7], v[104:105] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v166, v100
		v_exp_f32_e32 v218, v101
		v_exp_f32_e32 v100, v30
		v_exp_f32_e32 v220, v31
		v_exp_f32_e32 v30, v18
		v_exp_f32_e32 v222, v19
		v_exp_f32_e32 v18, v106
		v_exp_f32_e32 v224, v107
		v_exp_f32_e32 v106, v20
		v_exp_f32_e32 v226, v21
		v_exp_f32_e32 v20, v108
		v_exp_f32_e32 v228, v109
		v_exp_f32_e32 v108, v22
		v_exp_f32_e32 v230, v23
		v_exp_f32_e32 v22, v110
		v_exp_f32_e32 v232, v111
		v_exp_f32_e32 v110, v24
		v_exp_f32_e32 v234, v25
		v_exp_f32_e32 v24, v112
		v_exp_f32_e32 v236, v113
		v_exp_f32_e32 v112, v26
		v_exp_f32_e32 v238, v27
		v_exp_f32_e32 v26, v138
		v_exp_f32_e32 v240, v139
		v_exp_f32_e32 v138, v28
		v_exp_f32_e32 v242, v29
		v_exp_f32_e32 v28, v140
		v_exp_f32_e32 v244, v141
		v_exp_f32_e32 v140, v168
		v_exp_f32_e32 v246, v169
		v_exp_f32_e32 v168, v170
		v_exp_f32_e32 v248, v171
		v_exp_f32_e32 v167, v172
		v_exp_f32_e32 v219, v173
		v_exp_f32_e32 v101, v174
		v_exp_f32_e32 v221, v175
		v_exp_f32_e32 v31, v176
		v_exp_f32_e32 v223, v177
		v_exp_f32_e32 v19, v208
		v_exp_f32_e32 v225, v209
		v_exp_f32_e32 v107, v210
		v_exp_f32_e32 v227, v211
		v_exp_f32_e32 v21, v164
		v_exp_f32_e32 v229, v165
		v_exp_f32_e32 v109, v212
		v_exp_f32_e32 v231, v213
		v_exp_f32_e32 v23, v214
		v_exp_f32_e32 v233, v215
		v_exp_f32_e32 v111, v216
		v_exp_f32_e32 v235, v217
		v_exp_f32_e32 v25, v142
		v_exp_f32_e32 v237, v143
		v_exp_f32_e32 v113, v144
		v_exp_f32_e32 v239, v145
		v_exp_f32_e32 v27, v146
		v_exp_f32_e32 v241, v147
		v_exp_f32_e32 v139, v148
		v_exp_f32_e32 v243, v149
		v_exp_f32_e32 v29, v150
		v_exp_f32_e32 v245, v151
		v_exp_f32_e32 v141, v152
		v_exp_f32_e32 v247, v153
		v_exp_f32_e32 v169, v154
		v_exp_f32_e32 v249, v155
		v_exp_f32_e32 v142, v156
		v_exp_f32_e32 v144, v157
		v_exp_f32_e32 v146, v98
		v_exp_f32_e32 v148, v99
		v_exp_f32_e32 v98, v158
		v_exp_f32_e32 v150, v159
		v_exp_f32_e32 v152, v178
		v_exp_f32_e32 v154, v179
		v_exp_f32_e32 v156, v180
		v_exp_f32_e32 v158, v181
		v_exp_f32_e32 v164, v182
		v_exp_f32_e32 v170, v183
		v_exp_f32_e32 v172, v184
		v_exp_f32_e32 v174, v185
		v_exp_f32_e32 v176, v186
		v_exp_f32_e32 v178, v187
		v_exp_f32_e32 v180, v188
		v_exp_f32_e32 v182, v189
		v_exp_f32_e32 v184, v190
		v_exp_f32_e32 v186, v191
		v_exp_f32_e32 v188, v192
		v_exp_f32_e32 v190, v193
		v_exp_f32_e32 v192, v194
		v_exp_f32_e32 v208, v195
		v_exp_f32_e32 v194, v196
		v_exp_f32_e32 v210, v197
		v_exp_f32_e32 v196, v198
		v_exp_f32_e32 v212, v199
		v_exp_f32_e32 v198, v200
		v_exp_f32_e32 v214, v201
		v_exp_f32_e32 v200, v114
		v_exp_f32_e32 v216, v115
		v_exp_f32_e32 v143, v202
		v_exp_f32_e32 v145, v203
		v_exp_f32_e32 v147, v116
		v_exp_f32_e32 v149, v117
		v_exp_f32_e32 v99, v118
		v_exp_f32_e32 v151, v119
		v_exp_f32_e32 v153, v120
		v_exp_f32_e32 v155, v121
		v_exp_f32_e32 v157, v204
		v_exp_f32_e32 v159, v205
		v_exp_f32_e32 v165, v122
		v_exp_f32_e32 v171, v123
		v_exp_f32_e32 v173, v206
		v_exp_f32_e32 v175, v207
		v_exp_f32_e32 v177, v124
		v_exp_f32_e32 v179, v125
		v_exp_f32_e32 v181, v126
		v_exp_f32_e32 v183, v127
		v_exp_f32_e32 v185, v128
		v_exp_f32_e32 v187, v129
		v_exp_f32_e32 v189, v160
		v_exp_f32_e32 v191, v161
		v_exp_f32_e32 v193, v130
		v_exp_f32_e32 v209, v131
		v_exp_f32_e32 v195, v162
		v_exp_f32_e32 v211, v163
		v_exp_f32_e32 v197, v132
		v_exp_f32_e32 v213, v133
		v_exp_f32_e32 v199, v134
		v_exp_f32_e32 v215, v135
		v_exp_f32_e32 v201, v136
		v_exp_f32_e32 v217, v137
		v_pk_add_f32 v[114:115], v[166:167], v[218:219]
		v_pk_add_f32 v[116:117], v[100:101], v[220:221]
		v_pk_add_f32 v[118:119], v[30:31], v[222:223]
		v_pk_add_f32 v[120:121], v[18:19], v[224:225]
		v_pk_add_f32 v[122:123], v[106:107], v[226:227]
		v_pk_add_f32 v[124:125], v[20:21], v[228:229]
		v_pk_add_f32 v[126:127], v[108:109], v[230:231]
		v_pk_add_f32 v[128:129], v[22:23], v[232:233]
		v_pk_add_f32 v[130:131], v[110:111], v[234:235]
		v_pk_add_f32 v[132:133], v[24:25], v[236:237]
		v_pk_add_f32 v[134:135], v[112:113], v[238:239]
		v_pk_add_f32 v[136:137], v[26:27], v[240:241]
		v_pk_add_f32 v[160:161], v[138:139], v[242:243]
		v_pk_add_f32 v[162:163], v[28:29], v[244:245]
		v_pk_add_f32 v[202:203], v[140:141], v[246:247]
		v_pk_add_f32 v[204:205], v[168:169], v[248:249]
		v_pk_add_f32 v[114:115], v[114:115], v[116:117]
		v_pk_add_f32 v[116:117], v[118:119], v[120:121]
		v_pk_add_f32 v[118:119], v[122:123], v[124:125]
		v_pk_add_f32 v[120:121], v[126:127], v[128:129]
		v_pk_add_f32 v[122:123], v[130:131], v[132:133]
		v_pk_add_f32 v[124:125], v[134:135], v[136:137]
		v_pk_add_f32 v[126:127], v[160:161], v[162:163]
		v_pk_add_f32 v[128:129], v[202:203], v[204:205]
		v_pk_add_f32 v[114:115], v[114:115], v[116:117]
		v_pk_add_f32 v[116:117], v[118:119], v[120:121]
		v_pk_add_f32 v[118:119], v[122:123], v[124:125]
		v_pk_add_f32 v[120:121], v[126:127], v[128:129]
		v_pk_add_f32 v[114:115], v[114:115], v[116:117]
		v_pk_add_f32 v[116:117], v[118:119], v[120:121]
		v_pk_add_f32 v[118:119], v[114:115], v[116:117]
		v_add_f32_e32 v4, v118, v119
		v_accvgpr_read_b32 v11, a77
		ds_bpermute_b32 v114, v11, v4
		v_accvgpr_read_b32 v11, a78
		ds_bpermute_b32 v116, v11, v4
		v_pk_add_f32 v[118:119], v[142:143], v[144:145]
		v_pk_add_f32 v[120:121], v[146:147], v[148:149]
		v_pk_add_f32 v[122:123], v[98:99], v[150:151]
		v_pk_add_f32 v[124:125], v[152:153], v[154:155]
		v_pk_add_f32 v[126:127], v[156:157], v[158:159]
		v_pk_add_f32 v[128:129], v[164:165], v[170:171]
		v_pk_add_f32 v[130:131], v[172:173], v[174:175]
		v_pk_add_f32 v[132:133], v[176:177], v[178:179]
		v_pk_add_f32 v[134:135], v[180:181], v[182:183]
		v_pk_add_f32 v[136:137], v[184:185], v[186:187]
		v_pk_add_f32 v[160:161], v[188:189], v[190:191]
		v_pk_add_f32 v[162:163], v[192:193], v[208:209]
		v_pk_add_f32 v[202:203], v[194:195], v[210:211]
		v_pk_add_f32 v[204:205], v[196:197], v[212:213]
		v_pk_add_f32 v[206:207], v[198:199], v[214:215]
		v_pk_add_f32 v[250:251], v[200:201], v[216:217]
		v_pk_add_f32 v[118:119], v[118:119], v[120:121]
		v_pk_add_f32 v[120:121], v[122:123], v[124:125]
		v_pk_add_f32 v[122:123], v[126:127], v[128:129]
		v_pk_add_f32 v[124:125], v[130:131], v[132:133]
		v_pk_add_f32 v[126:127], v[134:135], v[136:137]
		v_pk_add_f32 v[128:129], v[160:161], v[162:163]
		v_pk_add_f32 v[130:131], v[202:203], v[204:205]
		v_pk_add_f32 v[132:133], v[206:207], v[250:251]
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
		v_cvt_pk_bf16_f32 v120, v166, v218
		v_cvt_pk_bf16_f32 v121, v100, v220
		v_permlane32_swap_b32_e32 v114, v115
		v_add_f32_e32 v117, v114, v115
		v_mov_b32_e32 v114, v102
		v_mov_b32_e32 v115, v104
		v_mov_b32_e32 v97, v10
		v_pk_add_f32 v[10:11], v[96:97], v[114:115] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v96, v10
		v_exp_f32_e32 v114, v11
		v_mov_b32_e32 v97, v96
		v_pk_mul_f32 v[32:33], v[32:33], v[96:97]
		v_pk_mul_f32 v[34:35], v[34:35], v[96:97]
		v_pk_mul_f32 v[36:37], v[36:37], v[96:97]
		v_pk_mul_f32 v[38:39], v[38:39], v[96:97]
		v_pk_mul_f32 v[40:41], v[40:41], v[96:97]
		v_pk_mul_f32 v[42:43], v[42:43], v[96:97]
		v_pk_mul_f32 v[44:45], v[44:45], v[96:97]
		v_pk_mul_f32 v[46:47], v[46:47], v[96:97]
		v_pk_mul_f32 v[48:49], v[48:49], v[96:97]
		v_pk_mul_f32 v[50:51], v[50:51], v[96:97]
		v_pk_mul_f32 v[52:53], v[52:53], v[96:97]
		v_pk_mul_f32 v[54:55], v[54:55], v[96:97]
		v_pk_mul_f32 v[56:57], v[56:57], v[96:97]
		v_pk_mul_f32 v[58:59], v[58:59], v[96:97]
		v_pk_mul_f32 v[60:61], v[60:61], v[96:97]
		v_pk_mul_f32 v[62:63], v[62:63], v[96:97]
		v_mov_b32_e32 v115, v114
		v_pk_mul_f32 v[64:65], v[64:65], v[114:115]
		v_pk_mul_f32 v[66:67], v[66:67], v[114:115]
		v_pk_mul_f32 v[68:69], v[68:69], v[114:115]
		v_pk_mul_f32 v[70:71], v[70:71], v[114:115]
		v_pk_mul_f32 v[72:73], v[72:73], v[114:115]
		v_pk_mul_f32 v[74:75], v[74:75], v[114:115]
		v_pk_mul_f32 v[76:77], v[76:77], v[114:115]
		v_pk_mul_f32 v[78:79], v[78:79], v[114:115]
		v_pk_mul_f32 v[80:81], v[80:81], v[114:115]
		v_pk_mul_f32 v[82:83], v[82:83], v[114:115]
		v_pk_mul_f32 v[84:85], v[84:85], v[114:115]
		v_pk_mul_f32 v[86:87], v[86:87], v[114:115]
		v_pk_mul_f32 v[88:89], v[88:89], v[114:115]
		v_pk_mul_f32 v[90:91], v[90:91], v[114:115]
		v_pk_mul_f32 v[92:93], v[92:93], v[114:115]
		v_pk_mul_f32 v[94:95], v[94:95], v[114:115]
		v_mov_b32_e32 v10, v96
		v_mov_b32_e32 v11, v114
		v_mov_b32_e32 v116, v118
		v_mov_b64_e32 v[96:97], v[14:15]
		v_pk_fma_f32 v[14:15], v[96:97], v[10:11], v[116:117]
		v_cvt_pk_bf16_f32 v122, v30, v222
		v_cvt_pk_bf16_f32 v123, v18, v224
		v_cvt_pk_bf16_f32 v116, v106, v226
		v_cvt_pk_bf16_f32 v117, v20, v228
		v_cvt_pk_bf16_f32 v118, v108, v230
		v_cvt_pk_bf16_f32 v119, v22, v232
		v_cvt_pk_bf16_f32 v124, v110, v234
		v_cvt_pk_bf16_f32 v125, v24, v236
		v_cvt_pk_bf16_f32 v126, v112, v238
		v_cvt_pk_bf16_f32 v127, v26, v240
		v_cvt_pk_bf16_f32 v128, v138, v242
		v_cvt_pk_bf16_f32 v129, v28, v244
		v_cvt_pk_bf16_f32 v130, v140, v246
		v_cvt_pk_bf16_f32 v131, v168, v248
		v_cvt_pk_bf16_f32 v132, v167, v219
		v_cvt_pk_bf16_f32 v133, v101, v221
		v_cvt_pk_bf16_f32 v134, v31, v223
		v_cvt_pk_bf16_f32 v135, v19, v225
		v_cvt_pk_bf16_f32 v160, v107, v227
		v_cvt_pk_bf16_f32 v161, v21, v229
		v_cvt_pk_bf16_f32 v162, v109, v231
		v_cvt_pk_bf16_f32 v163, v23, v233
		v_cvt_pk_bf16_f32 v20, v111, v235
		v_cvt_pk_bf16_f32 v21, v25, v237
		v_cvt_pk_bf16_f32 v22, v113, v239
		v_cvt_pk_bf16_f32 v23, v27, v241
		v_cvt_pk_bf16_f32 v24, v139, v243
		v_cvt_pk_bf16_f32 v25, v29, v245
		v_cvt_pk_bf16_f32 v26, v141, v247
		v_cvt_pk_bf16_f32 v27, v169, v249
		v_cvt_pk_bf16_f32 v28, v142, v144
		v_cvt_pk_bf16_f32 v29, v146, v148
		v_cvt_pk_bf16_f32 v30, v98, v150
		v_cvt_pk_bf16_f32 v31, v152, v154
		v_cvt_pk_bf16_f32 v108, v156, v158
		v_cvt_pk_bf16_f32 v109, v164, v170
		v_cvt_pk_bf16_f32 v110, v172, v174
		v_cvt_pk_bf16_f32 v111, v176, v178
		v_cvt_pk_bf16_f32 v112, v180, v182
		v_cvt_pk_bf16_f32 v113, v184, v186
		v_cvt_pk_bf16_f32 v114, v188, v190
		v_cvt_pk_bf16_f32 v115, v192, v208
		v_cvt_pk_bf16_f32 v136, v194, v210
		v_cvt_pk_bf16_f32 v137, v196, v212
		v_cvt_pk_bf16_f32 v138, v198, v214
		v_cvt_pk_bf16_f32 v139, v200, v216
		v_cvt_pk_bf16_f32 v204, v143, v145
		v_cvt_pk_bf16_f32 v205, v147, v149
		v_cvt_pk_bf16_f32 v206, v99, v151
		v_cvt_pk_bf16_f32 v207, v153, v155
		v_cvt_pk_bf16_f32 v96, v157, v159
		v_cvt_pk_bf16_f32 v97, v165, v171
		v_cvt_pk_bf16_f32 v98, v173, v175
		v_cvt_pk_bf16_f32 v99, v177, v179
		v_cvt_pk_bf16_f32 v140, v181, v183
		v_cvt_pk_bf16_f32 v141, v185, v187
		v_cvt_pk_bf16_f32 v142, v189, v191
		v_cvt_pk_bf16_f32 v143, v193, v209
		v_cvt_pk_bf16_f32 v144, v195, v211
		v_cvt_pk_bf16_f32 v145, v197, v213
		v_cvt_pk_bf16_f32 v146, v199, v215
		v_cvt_pk_bf16_f32 v147, v201, v217
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[120:123], v[32:47]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[120:123], v[48:63]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[116:119], v[32:47]
		v_permlane32_swap_b32_e32 v132, v134
		v_permlane32_swap_b32_e32 v133, v135
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[116:119], v[48:63]
		v_permlane32_swap_b32_e32 v160, v162
		v_permlane32_swap_b32_e32 v161, v163
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[124:127], v[32:47]
		v_permlane32_swap_b32_e32 v20, v22
		v_permlane32_swap_b32_e32 v21, v23
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[124:127], v[48:63]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[128:131], v[32:47]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[128:131], v[48:63]
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[28:31], v[80:95]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[28:31], v[64:79]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[108:111], v[80:95]
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[108:111], v[64:79]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[112:115], v[80:95]
		v_permlane32_swap_b32_e32 v140, v142
		v_permlane32_swap_b32_e32 v141, v143
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[112:115], v[64:79]
		v_permlane32_swap_b32_e32 v144, v146
		v_permlane32_swap_b32_e32 v145, v147
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[136:139], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[136:139], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[132:135], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[132:135], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[204:207], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[204:207], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[160:163], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[160:163], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[96:99], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[216:219], v[20:23], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[248:251], v[20:23], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[248:251], v[140:143], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[216:219], v[140:143], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[220:223], v[24:27], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[252:255], v[24:27], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[252:255], v[144:147], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[220:223], v[144:147], v[64:79]
		s_cselect_b32 s1, 1, 0
		s_add_i32 s25, s42, 0x80
		s_cmp_lg_u32 s1, 0
		s_mov_b32 s42, s25
		v_mov_b32_e32 v4, v102
		v_mov_b32_e32 v10, v104
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_4
.L_attn_fwd_persistent.loop_exit_4:
		s_mov_b32 s28, s8
		s_mov_b32 s29, s9
		s_mov_b32 s30, s26
		s_mov_b32 s31, s27
		v_rcp_f32_e32 v2, v14
		v_accvgpr_read_b32 v3, a11
		s_nop 0
		v_readfirstlane_b32 s1, v3
		s_mul_i32 s1, s1, s18
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
		v_readfirstlane_b32 s24, v1
		s_mul_i32 s23, s24, s23
		s_lshl_b32 s23, s23, 1
		s_add_i32 s22, s22, s23
		v_accvgpr_read_b32 v1, a12
		v_mul_lo_u32 v1, s18, v1
		v_lshl_add_u32 v2, v1, 6, s22
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
		v_readfirstlane_b32 s24, v36
		v_accvgpr_read_b32 v36, a57
		s_nop 0
		v_readfirstlane_b32 s25, v36
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_24
		buffer_store_dwordx4 v[40:43], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_24:
		s_andn2_b64 exec, s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_24
.L_attn_fwd_persistent.exec_endif_24:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s22, s1, 32
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s23
		v_lshl_add_u32 v2, v1, 6, s22
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v36, a18
		v_lshl_add_u32 v2, v36, 4, v2
		v_accvgpr_read_b32 v36, a56
		s_nop 0
		v_readfirstlane_b32 s24, v36
		v_accvgpr_read_b32 v36, a57
		s_nop 0
		v_readfirstlane_b32 s25, v36
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_25
		buffer_store_dwordx4 v[8:11], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_25:
		s_andn2_b64 exec, s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_25
.L_attn_fwd_persistent.exec_endif_25:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s22, s1, 64
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s23
		v_lshl_add_u32 v2, v1, 6, s22
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v8, a18
		v_lshl_add_u32 v2, v8, 4, v2
		v_accvgpr_read_b32 v8, a56
		s_nop 0
		v_readfirstlane_b32 s24, v8
		v_accvgpr_read_b32 v8, a57
		s_nop 0
		v_readfirstlane_b32 s25, v8
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_26
		buffer_store_dwordx4 v[16:19], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_26:
		s_andn2_b64 exec, s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_26
.L_attn_fwd_persistent.exec_endif_26:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s22, s1, 0x60
		s_add_i32 s22, s22, s19
		s_add_i32 s22, s22, s23
		v_lshl_add_u32 v2, v1, 6, s22
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v8, a18
		v_lshl_add_u32 v2, v8, 4, v2
		v_accvgpr_read_b32 v8, a56
		s_nop 0
		v_readfirstlane_b32 s24, v8
		v_accvgpr_read_b32 v8, a57
		s_nop 0
		v_readfirstlane_b32 s25, v8
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_27
		buffer_store_dwordx4 v[20:23], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_27:
		s_andn2_b64 exec, s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_27
.L_attn_fwd_persistent.exec_endif_27:
		s_mov_b64 exec, s[100:101]
		s_lshl_b32 s22, s18, 8
		s_add_i32 s24, s22, s1
		s_add_i32 s24, s24, s19
		s_add_i32 s24, s24, s23
		v_lshl_add_u32 v2, v1, 6, s24
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v8, a18
		v_lshl_add_u32 v2, v8, 4, v2
		v_accvgpr_read_b32 v8, a58
		s_nop 0
		v_readfirstlane_b32 s24, v8
		v_accvgpr_read_b32 v8, a59
		s_nop 0
		v_readfirstlane_b32 s25, v8
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_28
		buffer_store_dwordx4 v[24:27], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_28:
		s_andn2_b64 exec, s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_28
.L_attn_fwd_persistent.exec_endif_28:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s24, s22, 32
		s_add_i32 s24, s24, s1
		s_add_i32 s24, s24, s19
		s_add_i32 s24, s24, s23
		v_lshl_add_u32 v2, v1, 6, s24
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v8, a18
		v_lshl_add_u32 v2, v8, 4, v2
		v_accvgpr_read_b32 v8, a58
		s_nop 0
		v_readfirstlane_b32 s24, v8
		v_accvgpr_read_b32 v8, a59
		s_nop 0
		v_readfirstlane_b32 s25, v8
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_29
		buffer_store_dwordx4 v[4:7], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_29:
		s_andn2_b64 exec, s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_29
.L_attn_fwd_persistent.exec_endif_29:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s24, s22, 64
		s_add_i32 s24, s24, s1
		s_add_i32 s24, s24, s19
		s_add_i32 s24, s24, s23
		v_lshl_add_u32 v2, v1, 6, s24
		v_lshl_add_u32 v2, v3, 1, v2
		v_lshl_add_u32 v2, v32, 5, v2
		v_lshl_add_u32 v2, v33, 4, v2
		v_lshl_add_u32 v2, v34, 3, v2
		v_lshl_add_u32 v2, v35, 2, v2
		v_accvgpr_read_b32 v4, a18
		v_lshl_add_u32 v2, v4, 4, v2
		v_accvgpr_read_b32 v4, a58
		s_nop 0
		v_readfirstlane_b32 s24, v4
		v_accvgpr_read_b32 v4, a59
		s_nop 0
		v_readfirstlane_b32 s25, v4
		s_and_saveexec_b64 s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_30
		buffer_store_dwordx4 v[12:15], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_30:
		s_andn2_b64 exec, s[100:101], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_30
.L_attn_fwd_persistent.exec_endif_30:
		s_mov_b64 exec, s[100:101]
		s_add_i32 s22, s22, 0x60
		s_add_i32 s1, s22, s1
		s_add_i32 s1, s1, s19
		s_add_i32 s1, s1, s23
		v_lshl_add_u32 v1, v1, 6, s1
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
		s_and_saveexec_b64 s[100:101], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_31
		buffer_store_dwordx4 v[28:31], v1, s[28:31], 0 offen
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
    wave.regalloc.iterations: 445
    wave.regalloc.agpr.dwords: 807
    wave.regalloc.remat.dwords: 3
    wave.regalloc.sgpr_to_vgpr.dwords: 29
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
