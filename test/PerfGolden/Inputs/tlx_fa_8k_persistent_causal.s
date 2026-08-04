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
		v_accvgpr_write_b32 a5, 0
		s_and_b32 s0, s16, 7
		v_mov_b32_e32 v2, s0
		v_accvgpr_write_b32 a6, v2
		s_lshr_b32 s0, s16, 3
		v_accvgpr_read_b32 v2, a4
		s_nop 0
		v_readfirstlane_b32 s1, v2
		s_mul_i32 s1, s19, s1
		s_nop 0
		v_mov_b32_e32 v2, s1
		v_accvgpr_write_b32 a7, v2
		v_accvgpr_read_b32 v2, a7
		s_nop 0
		v_readfirstlane_b32 s1, v2
		s_add_i32 s1, s1, 7
		s_mov_b32 s16, 1
		s_mov_b32 s19, 7
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s19, s19, 0
		s_add_i32 s1, s1, s19
		s_ashr_i32 s1, s1, 3
		s_mul_i32 s1, s1, 16
		v_mov_b32_e32 v2, s1
		v_accvgpr_write_b32 a8, v2
		v_accvgpr_read_b32 v2, a8
		s_nop 0
		v_readfirstlane_b32 s1, v2
		s_cmp_lt_i32 s0, s1
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_0
.L_attn_fwd_persistent.loop_head_0:
		s_lshr_b32 s1, s0, 4
		s_and_b32 s19, s0, 15
		s_mul_i32 s1, s1, 8
		v_accvgpr_read_b32 v2, a6
		s_nop 0
		v_readfirstlane_b32 s22, v2
		s_add_i32 s1, s22, s1
		v_accvgpr_read_b32 v2, a7
		s_nop 0
		v_readfirstlane_b32 s22, v2
		s_cmp_lt_i32 s1, s22
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_0
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s22, 1, 0
		s_xor_b32 s23, s1, -1
		s_add_i32 s23, s23, 1
		s_cmp_lg_u32 s22, 0
		s_cselect_b32 s22, s23, s1
		s_cselect_b32 s23, 1, 0
		v_accvgpr_read_b32 v2, a4
		s_nop 0
		v_readfirstlane_b32 s24, v2
		s_xor_b32 s24, s24, -1
		s_add_i32 s24, s24, 1
		v_accvgpr_read_b32 v2, a4
		s_nop 0
		v_readfirstlane_b32 s25, v2
		s_cmp_lt_i32 s25, 0
		v_accvgpr_read_b32 v2, a4
		s_nop 0
		v_readfirstlane_b32 s25, v2
		s_cselect_b32 s24, s24, s25
		v_mov_b32_e32 v2, s24
		v_cvt_f32_u32_e32 v2, v2
		v_rcp_iflag_f32_e32 v2, v2
		v_mov_b32_e32 v3, 0x4f7ffffe
		v_mul_f32_e32 v2, v3, v2
		v_cvt_u32_f32_e32 v2, v2
		s_xor_b32 s25, s24, -1
		v_readfirstlane_b32 s26, v2
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
		v_accvgpr_read_b32 v2, a4
		s_nop 0
		v_readfirstlane_b32 s27, v2
		s_xor_b32 s1, s1, s27
		s_xor_b32 s27, s24, -1
		s_add_i32 s27, s27, 1
		s_cmp_lt_i32 s1, 0
		s_cselect_b32 s1, s27, s24
		v_mov_b32_e32 v2, s1
		s_add_i32 s24, s22, s25
		s_cmp_lg_u32 s26, 0
		s_cselect_b32 s22, s24, s22
		s_xor_b32 s24, s22, -1
		s_add_i32 s24, s24, 1
		s_cmp_lg_u32 s23, 0
		s_cselect_b32 s22, s24, s22
		v_mov_b32_e32 v3, s22
		s_mul_i32 s19, s19, 2
		s_cmp_lt_i32 s19, 32
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_1
		s_lshr_b32 s23, s19, 1
		s_and_b32 s19, s19, 1
		s_xor_b32 s24, s23, -1
		s_add_i32 s24, s24, 1
		s_add_i32 s24, s24, 31
		s_cmp_eq_u32 s19, 0
		s_cselect_b32 s19, s23, s24
		v_mov_b32_e32 v4, s19
		v_accvgpr_write_b32 a9, v4
		v_accvgpr_read_b32 v4, a9
		s_nop 0
		v_readfirstlane_b32 s19, v4
		s_mul_i32 s19, s19, 0x100
		v_and_b32_e32 v4, 1, v0
		v_lshrrev_b32_e32 v5, 1, v0
		v_and_b32_e32 v6, 1, v5
		v_mov_b32_e32 v7, 2
		v_mul_lo_u32 v7, v7, v6
		v_lshrrev_b32_e32 v6, 2, v0
		v_and_b32_e32 v8, 1, v6
		v_mov_b32_e32 v9, 4
		v_mul_lo_u32 v9, v9, v8
		v_bitop3_b32 v8, v4, v7, v9 bitop3:0x96
		v_lshrrev_b32_e32 v10, 3, v0
		v_and_b32_e32 v11, 1, v10
		v_mov_b32_e32 v12, 8
		v_mul_lo_u32 v12, v12, v11
		v_xor_b32_e32 v8, v8, v12
		v_lshrrev_b32_e32 v13, 4, v0
		v_and_b32_e32 v14, 1, v13
		v_mov_b32_e32 v15, 16
		v_mul_lo_u32 v15, v15, v14
		v_lshrrev_b32_e32 v16, 6, v0
		v_accvgpr_write_b32 a10, v16
		v_accvgpr_read_b32 v16, a10
		v_and_b32_e32 v16, 1, v16
		v_mov_b32_e32 v17, 32
		v_mul_lo_u32 v17, v17, v16
		v_bitop3_b32 v8, v8, v15, v17 bitop3:0x96
		v_lshrrev_b32_e32 v18, 7, v0
		v_and_b32_e32 v18, 1, v18
		v_mov_b32_e32 v19, 64
		v_mul_lo_u32 v19, v19, v18
		v_xor_b32_e32 v8, v8, v19
		v_accvgpr_write_b32 a11, v8
		v_xor_b32_e32 v4, 0x80, v4
		v_xor_b32_e32 v4, v4, v7
		v_xor_b32_e32 v4, v4, v9
		v_bitop3_b32 v4, v4, v12, v15 bitop3:0x96
		v_bitop3_b32 v4, v4, v17, v19 bitop3:0x96
		v_accvgpr_write_b32 a12, v4
		v_mov_b32_e32 v4, 2
		v_mul_lo_u32 v4, v4, v14
		v_lshrrev_b32_e32 v7, 5, v0
		v_and_b32_e32 v8, 1, v7
		v_mov_b32_e32 v9, 4
		v_mul_lo_u32 v9, v9, v8
		v_bitop3_b32 v12, v11, v4, v9 bitop3:0x96
		v_mov_b32_e32 v15, 8
		v_mul_lo_u32 v15, v15, v16
		v_xor_b32_e32 v12, v12, v15
		v_mov_b32_e32 v17, 16
		v_mul_lo_u32 v17, v17, v18
		v_xad_u32 v12, v12, v17, s19
		v_bitop3_b32 v19, 32, v11, v4 bitop3:0x96
		v_bitop3_b32 v19, v19, v9, v15 bitop3:0x96
		v_xad_u32 v19, v19, v17, s19
		v_bitop3_b32 v20, 64, v11, v4 bitop3:0x96
		v_bitop3_b32 v20, v20, v9, v15 bitop3:0x96
		v_xad_u32 v20, v20, v17, s19
		v_xor_b32_e32 v21, 0x60, v11
		v_xor_b32_e32 v21, v21, v4
		v_xor_b32_e32 v21, v21, v9
		v_xor_b32_e32 v21, v21, v15
		v_xad_u32 v21, v21, v17, s19
		v_xor_b32_e32 v22, 0x80, v11
		v_xor_b32_e32 v22, v22, v4
		v_xor_b32_e32 v22, v22, v9
		v_xor_b32_e32 v22, v22, v15
		v_xad_u32 v22, v22, v17, s19
		v_xor_b32_e32 v23, 0xa0, v11
		v_xor_b32_e32 v23, v23, v4
		v_xor_b32_e32 v23, v23, v9
		v_xor_b32_e32 v23, v23, v15
		v_xad_u32 v23, v23, v17, s19
		v_xor_b32_e32 v24, 0xc0, v11
		v_xor_b32_e32 v24, v24, v4
		v_xor_b32_e32 v24, v24, v9
		v_xor_b32_e32 v24, v24, v15
		v_xad_u32 v24, v24, v17, s19
		v_xor_b32_e32 v25, 0xe0, v11
		v_xor_b32_e32 v4, v25, v4
		v_xor_b32_e32 v4, v4, v9
		v_xor_b32_e32 v4, v4, v15
		v_xad_u32 v4, v4, v17, s19
		s_mov_b32 s26, 0x7fffffff
		s_mov_b32 s27, 0x31016000
		s_mov_b32 s24, s2
		s_mov_b32 s25, s3
		v_accvgpr_read_b32 v15, a5
		v_and_b32_e32 v15, 0xffff, v15
		v_lshlrev_b32_e32 v17, 16, v15
		v_or_b32_e32 v28, v15, v17
		v_mov_b32_e32 v29, v28
		v_mov_b32_e32 v30, v28
		v_mov_b32_e32 v31, v28
		v_accvgpr_read_b32 v15, a9
		s_nop 0
		v_readfirstlane_b32 s23, v15
		s_mul_i32 s23, s23, s12
		s_lshl_b32 s23, s23, 9
		v_readfirstlane_b32 s28, v2
		s_mul_i32 s28, s28, s10
		s_lshl_b32 s28, s28, 1
		s_add_i32 s29, s23, s28
		v_readfirstlane_b32 s30, v3
		s_mul_i32 s30, s30, s11
		s_lshl_b32 s30, s30, 1
		s_add_i32 s29, s29, s30
		v_mul_lo_u32 v15, s12, v10
		v_lshl_add_u32 v17, v15, 1, s29
		v_and_b32_e32 v25, 1, v0
		v_accvgpr_write_b32 a13, v25
		v_accvgpr_read_b32 v25, a13
		v_lshl_add_u32 v17, v25, 4, v17
		v_and_b32_e32 v25, 1, v6
		v_accvgpr_write_b32 a14, v25
		v_accvgpr_read_b32 v25, a14
		v_lshl_add_u32 v17, v25, 6, v17
		v_and_b32_e32 v5, 1, v5
		v_accvgpr_write_b32 a15, v5
		v_accvgpr_read_b32 v5, a15
		v_lshl_add_u32 v5, v5, 5, v17
		v_cmp_lt_i32_e64 vcc, v12, s20
		s_and_saveexec_b64 s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_0
		buffer_load_dwordx4 v[32:35], v5, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_0:
		s_andn2_b64 exec, s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_0
		v_mov_b32_e32 v32, v28
		v_mov_b32_e32 v33, v29
		v_mov_b32_e32 v34, v30
		v_mov_b32_e32 v35, v31
.L_attn_fwd_persistent.exec_endif_0:
		s_mov_b64 exec, s[92:93]
		s_lshl_b32 s29, s12, 6
		s_add_i32 s29, s29, s23
		s_add_i32 s29, s29, s28
		s_add_i32 s29, s29, s30
		v_lshl_add_u32 v5, v15, 1, s29
		v_accvgpr_read_b32 v12, a13
		v_lshl_add_u32 v5, v12, 4, v5
		v_accvgpr_read_b32 v12, a14
		v_lshl_add_u32 v5, v12, 6, v5
		v_accvgpr_read_b32 v12, a15
		v_lshl_add_u32 v5, v12, 5, v5
		v_cmp_lt_i32_e64 vcc, v19, s20
		s_and_saveexec_b64 s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_1
		buffer_load_dwordx4 v[36:39], v5, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_1:
		s_andn2_b64 exec, s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_1
		v_mov_b32_e32 v36, v28
		v_mov_b32_e32 v37, v29
		v_mov_b32_e32 v38, v30
		v_mov_b32_e32 v39, v31
.L_attn_fwd_persistent.exec_endif_1:
		s_mov_b64 exec, s[92:93]
		s_lshl_b32 s29, s12, 7
		s_add_i32 s29, s29, s23
		s_add_i32 s29, s29, s28
		s_add_i32 s29, s29, s30
		v_lshl_add_u32 v5, v15, 1, s29
		v_accvgpr_read_b32 v12, a13
		v_lshl_add_u32 v5, v12, 4, v5
		v_accvgpr_read_b32 v12, a14
		v_lshl_add_u32 v5, v12, 6, v5
		v_accvgpr_read_b32 v12, a15
		v_lshl_add_u32 v5, v12, 5, v5
		v_cmp_lt_i32_e64 vcc, v20, s20
		s_and_saveexec_b64 s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_2
		buffer_load_dwordx4 v[40:43], v5, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_2:
		s_andn2_b64 exec, s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_2
		v_mov_b32_e32 v40, v28
		v_mov_b32_e32 v41, v29
		v_mov_b32_e32 v42, v30
		v_mov_b32_e32 v43, v31
.L_attn_fwd_persistent.exec_endif_2:
		s_mov_b64 exec, s[92:93]
		s_mul_i32 s29, 0xc0, s12
		s_add_i32 s29, s29, s23
		s_add_i32 s29, s29, s28
		s_add_i32 s29, s29, s30
		v_lshl_add_u32 v5, v15, 1, s29
		v_accvgpr_read_b32 v12, a13
		v_lshl_add_u32 v5, v12, 4, v5
		v_accvgpr_read_b32 v12, a14
		v_lshl_add_u32 v5, v12, 6, v5
		v_accvgpr_read_b32 v12, a15
		v_lshl_add_u32 v5, v12, 5, v5
		v_cmp_lt_i32_e64 vcc, v21, s20
		s_and_saveexec_b64 s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_3
		buffer_load_dwordx4 v[44:47], v5, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_3:
		s_andn2_b64 exec, s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_3
		v_mov_b32_e32 v44, v28
		v_mov_b32_e32 v45, v29
		v_mov_b32_e32 v46, v30
		v_mov_b32_e32 v47, v31
.L_attn_fwd_persistent.exec_endif_3:
		s_mov_b64 exec, s[92:93]
		s_lshl_b32 s29, s12, 8
		s_add_i32 s29, s29, s23
		s_add_i32 s29, s29, s28
		s_add_i32 s29, s29, s30
		v_lshl_add_u32 v5, v15, 1, s29
		v_accvgpr_read_b32 v12, a13
		v_lshl_add_u32 v5, v12, 4, v5
		v_accvgpr_read_b32 v12, a14
		v_lshl_add_u32 v5, v12, 6, v5
		v_accvgpr_read_b32 v12, a15
		v_lshl_add_u32 v5, v12, 5, v5
		v_cmp_lt_i32_e64 vcc, v22, s20
		s_and_saveexec_b64 s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_4
		buffer_load_dwordx4 v[48:51], v5, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_4:
		s_andn2_b64 exec, s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_4
		v_mov_b32_e32 v48, v28
		v_mov_b32_e32 v49, v29
		v_mov_b32_e32 v50, v30
		v_mov_b32_e32 v51, v31
.L_attn_fwd_persistent.exec_endif_4:
		s_mov_b64 exec, s[92:93]
		s_mul_i32 s29, 0x140, s12
		s_add_i32 s29, s29, s23
		s_add_i32 s29, s29, s28
		s_add_i32 s29, s29, s30
		v_lshl_add_u32 v5, v15, 1, s29
		v_accvgpr_read_b32 v12, a13
		v_lshl_add_u32 v5, v12, 4, v5
		v_accvgpr_read_b32 v12, a14
		v_lshl_add_u32 v5, v12, 6, v5
		v_accvgpr_read_b32 v12, a15
		v_lshl_add_u32 v5, v12, 5, v5
		v_cmp_lt_i32_e64 vcc, v23, s20
		s_and_saveexec_b64 s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_5
		buffer_load_dwordx4 v[20:23], v5, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_5:
		s_andn2_b64 exec, s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_5
		v_mov_b32_e32 v20, v28
		v_mov_b32_e32 v21, v29
		v_mov_b32_e32 v22, v30
		v_mov_b32_e32 v23, v31
.L_attn_fwd_persistent.exec_endif_5:
		s_mov_b64 exec, s[92:93]
		s_mul_i32 s29, 0x180, s12
		s_add_i32 s29, s29, s23
		s_add_i32 s29, s29, s28
		s_add_i32 s29, s29, s30
		v_lshl_add_u32 v5, v15, 1, s29
		v_accvgpr_read_b32 v12, a13
		v_lshl_add_u32 v5, v12, 4, v5
		v_accvgpr_read_b32 v12, a14
		v_lshl_add_u32 v5, v12, 6, v5
		v_accvgpr_read_b32 v12, a15
		v_lshl_add_u32 v5, v12, 5, v5
		v_cmp_lt_i32_e64 vcc, v24, s20
		s_and_saveexec_b64 s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_6
		buffer_load_dwordx4 v[24:27], v5, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_6:
		s_andn2_b64 exec, s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_6
		v_mov_b32_e32 v24, v28
		v_mov_b32_e32 v25, v29
		v_mov_b32_e32 v26, v30
		v_mov_b32_e32 v27, v31
.L_attn_fwd_persistent.exec_endif_6:
		s_mov_b64 exec, s[92:93]
		s_mul_i32 s29, 0x1c0, s12
		s_add_i32 s23, s29, s23
		s_add_i32 s23, s23, s28
		s_add_i32 s23, s23, s30
		v_lshl_add_u32 v5, v15, 1, s23
		v_accvgpr_read_b32 v12, a13
		v_lshl_add_u32 v5, v12, 4, v5
		v_accvgpr_read_b32 v12, a14
		v_lshl_add_u32 v5, v12, 6, v5
		v_accvgpr_read_b32 v12, a15
		v_lshl_add_u32 v5, v12, 5, v5
		v_cmp_lt_i32_e64 vcc, v4, s20
		s_and_saveexec_b64 s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_7
		buffer_load_dwordx4 v[52:55], v5, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_7:
		s_andn2_b64 exec, s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_7
		v_mov_b32_e32 v52, v28
		v_mov_b32_e32 v53, v29
		v_mov_b32_e32 v54, v30
		v_mov_b32_e32 v55, v31
.L_attn_fwd_persistent.exec_endif_7:
		s_mov_b64 exec, s[92:93]
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
		v_and_b32_e32 v4, 1, v7
		v_accvgpr_write_b32 a16, v4
		v_accvgpr_read_b32 v4, a16
		v_lshlrev_b32_e32 v4, 1, v4
		v_accvgpr_read_b32 v5, a10
		v_and_b32_e32 v5, 1, v5
		v_lshlrev_b32_e32 v5, 2, v5
		v_and_b32_e32 v7, 1, v13
		v_accvgpr_write_b32 a17, v7
		v_accvgpr_read_b32 v7, a17
		v_xor_b32_e32 v5, v5, v7
		v_bitop3_b32 v4, v0, v4, v5 bitop3:0x96
		v_lshlrev_b32_e32 v4, 4, v4
		v_add_u32_e32 v4, 0x10000, v4
		ds_write_b128 v4, v[32:35] offset:2480
		ds_write_b128 v4, v[36:39] offset:6576
		ds_write_b128 v4, v[40:43] offset:10672
		ds_write_b128 v4, v[44:47] offset:14768
		v_accvgpr_read_b32 v5, a10
		v_lshlrev_b32_e32 v5, 12, v5
		v_add_u32_e32 v5, 0x10000, v5
		v_and_b32_e32 v7, 63, v0
		v_lshrrev_b32_e32 v12, 5, v7
		v_accvgpr_write_b32 a18, v12
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshrrev_b32_e32 v12, 4, v7
		v_and_b32_e32 v12, 1, v12
		v_lshlrev_b32_e32 v12, 7, v12
		v_accvgpr_read_b32 v13, a18
		v_add_u32_e32 v13, v13, v12
		v_lshrrev_b32_e32 v15, 3, v7
		v_and_b32_e32 v15, 1, v15
		v_lshlrev_b32_e32 v17, 6, v15
		v_lshrrev_b32_e32 v19, 2, v7
		v_and_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v28, 5, v19
		v_add3_u32 v13, v13, v17, v28
		v_lshrrev_b32_e32 v29, 1, v7
		v_and_b32_e32 v29, 1, v29
		v_lshlrev_b32_e32 v30, 4, v29
		v_and_b32_e32 v31, 1, v7
		v_lshlrev_b32_e32 v31, 3, v31
		v_add3_u32 v13, v13, v30, v31
		v_lshlrev_b32_e32 v19, 1, v19
		v_lshlrev_b32_e32 v15, 2, v15
		v_bitop3_b32 v15, v19, v15, v29 bitop3:0x96
		v_xor_b32_e32 v13, v13, v15
		v_lshl_add_u32 v13, v13, 4, v5
		ds_read_b128 a[20:23], v13 offset:2480
		v_accvgpr_read_b32 v19, a18
		v_add3_u32 v12, v19, v12, v17
		v_add3_u32 v12, v12, v28, v30
		v_add3_u32 v17, v31, v12, 2
		v_xor_b32_e32 v17, v17, v15
		v_lshl_add_u32 v17, v17, 4, v5
		ds_read_b128 a[24:27], v17 offset:2480
		v_add3_u32 v19, v31, v12, 4
		v_xor_b32_e32 v19, v19, v15
		v_lshl_add_u32 v19, v19, 4, v5
		ds_read_b128 a[28:31], v19 offset:2480
		v_add3_u32 v12, v31, v12, 6
		v_xor_b32_e32 v12, v12, v15
		v_lshl_add_u32 v5, v12, 4, v5
		ds_read_b128 a[32:35], v5 offset:2480
		v_accvgpr_read_b32 v12, a9
		s_nop 0
		v_readfirstlane_b32 s23, v12
		s_add_i32 s23, s23, 1
		s_mul_i32 s23, s23, 0x100
		s_mov_b32 s24, 0x7f
		v_mov_b32_e32 v12, 64
		v_mul_lo_u32 v12, v12, v11
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v4, v[48:51] offset:2480
		ds_write_b128 v4, v[20:23] offset:6576
		ds_write_b128 v4, v[24:27] offset:10672
		ds_write_b128 v4, v[52:55] offset:14768
		v_mov_b32_e32 v4, 32
		v_mul_lo_u32 v4, v4, v14
		v_mov_b32_e32 v14, 16
		v_mul_lo_u32 v14, v14, v8
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[36:39], v13 offset:2480
		ds_read_b128 a[40:43], v17 offset:2480
		ds_read_b128 a[44:47], v19 offset:2480
		ds_read_b128 a[48:51], v5 offset:2480
		v_readfirstlane_b32 s25, v1
		s_add_i32 s23, s23, s25
		s_cmp_lt_i32 s21, s23
		s_cselect_b32 s23, s21, s23
		s_add_i32 s25, s23, 0x7f
		s_cmp_lt_i32 s25, 0
		s_cselect_b32 s36, s24, 0
		s_add_i32 s25, s25, s36
		s_ashr_i32 s25, s25, 7
		v_readfirstlane_b32 s36, v1
		s_add_i32 s36, s19, s36
		s_cmp_lt_i32 s36, 0
		s_cselect_b32 s37, s24, 0
		s_add_i32 s36, s36, s37
		s_ashr_i32 s36, s36, 7
		s_cmp_lt_i32 s36, s25
		s_cselect_b32 s36, s36, s25
		s_cmp_gt_i32 s36, 0
		s_cselect_b32 s36, s36, 0
		v_bitop3_b32 v5, v12, v4, v14 bitop3:0x96
		v_mov_b32_e32 v13, 2
		v_mul_lo_u32 v13, v13, v18
		v_bitop3_b32 v5, v5, v16, v13 bitop3:0x96
		v_accvgpr_write_b32 a19, v5
		v_bitop3_b32 v5, 4, v12, v4 bitop3:0x96
		v_bitop3_b32 v15, 8, v12, v4 bitop3:0x96
		v_bitop3_b32 v12, 12, v12, v4 bitop3:0x96
		v_accvgpr_read_b32 v17, a19
		v_cmp_lt_i32_e64 s[38:39], v17, s21
		v_mov_b32_e32 v17, 16
		v_mul_lo_u32 v17, v17, v11
		v_mov_b32_e32 v11, 64
		v_mul_lo_u32 v11, v11, v8
		v_bitop3_b32 v8, v17, v4, v11 bitop3:0x96
		v_bitop3_b32 v8, v8, v16, v13 bitop3:0x96
		v_accvgpr_write_b32 a52, v8
		v_bitop3_b32 v8, 4, v17, v4 bitop3:0x96
		v_bitop3_b32 v18, 8, v17, v4 bitop3:0x96
		v_bitop3_b32 v4, 12, v17, v4 bitop3:0x96
		v_accvgpr_read_b32 v17, a52
		v_cmp_lt_i32_e64 vcc, v17, s21
		v_readfirstlane_b32 s40, v0
		v_accvgpr_read_b32 v17, a10
		v_mul_lo_u32 v17, s15, v17
		v_accvgpr_read_b32 v19, a16
		v_mul_lo_u32 v19, s15, v19
		v_lshlrev_b32_e32 v19, 5, v19
		v_lshl_add_u32 v17, v17, 1, v19
		v_accvgpr_read_b32 v19, a17
		v_mul_lo_u32 v19, s15, v19
		v_lshl_add_u32 v17, v19, 6, v17
		v_and_b32_e32 v10, 1, v10
		v_accvgpr_write_b32 a53, v10
		v_accvgpr_read_b32 v10, a53
		v_mul_lo_u32 v10, s15, v10
		v_lshlrev_b32_e32 v10, 7, v10
		v_accvgpr_read_b32 v19, a13
		v_lshlrev_b32_e32 v19, 4, v19
		v_add3_u32 v10, v17, v10, v19
		v_accvgpr_read_b32 v17, a14
		v_lshlrev_b32_e32 v17, 6, v17
		v_accvgpr_read_b32 v20, a15
		v_lshlrev_b32_e32 v20, 5, v20
		v_add3_u32 v10, v10, v17, v20
		v_readfirstlane_b32 s37, v2
		s_mul_i32 s37, s37, s13
		s_lshl_b32 s37, s37, 1
		v_readfirstlane_b32 s41, v3
		s_mul_i32 s41, s41, s14
		s_lshl_b32 s41, s41, 1
		s_add_i32 s42, s37, s41
		v_add_u32_e32 v21, s42, v10
		v_mov_b32_e32 v22, 0x80000000
		v_cndmask_b32_e64 v21, v22, v21, s[38:39]
		s_lshr_b32 s42, s40, 6
		s_mul_i32 s43, 0x410, s42
		s_mov_b32 m0, s43
		v_accvgpr_read_b32 v23, a11
		v_add_u32_e32 v23, s19, v23
		buffer_load_dwordx4 v21, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[44:45], v23, s20
		s_lshl_b32 s46, s15, 3
		s_add_i32 s46, s46, s37
		s_add_i32 s46, s46, s41
		v_add_u32_e32 v21, s46, v10
		v_cndmask_b32_e64 v21, v22, v21, s[38:39]
		s_add_i32 m0, m0, 0x1040
		v_accvgpr_read_b32 v23, a12
		v_add_u32_e32 v23, s19, v23
		buffer_load_dwordx4 v21, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[46:47], v23, s20
		s_nop 1
		v_mov_b32_e32 v24, s46
		v_mov_b32_e32 v25, s47
		v_accvgpr_write_b32 a54, v24
		v_accvgpr_write_b32 a55, v25
		s_lshl_b32 s46, s15, 4
		s_add_i32 s46, s46, s37
		s_add_i32 s46, s46, s41
		v_add_u32_e32 v21, s46, v10
		v_cndmask_b32_e64 v21, v22, v21, s[38:39]
		s_add_i32 m0, m0, 0x1040
		v_xor_b32_e32 v5, v5, v14
		buffer_load_dwordx4 v21, s[28:31], 0 offen lds
		v_bitop3_b32 v5, v5, v16, v13 bitop3:0x96
		v_accvgpr_write_b32 a56, v5
		s_mul_i32 s46, 24, s15
		s_add_i32 s46, s46, s37
		s_add_i32 s46, s46, s41
		v_add_u32_e32 v5, s46, v10
		v_cndmask_b32_e64 v5, v22, v5, s[38:39]
		s_add_i32 m0, m0, 0x1040
		v_xor_b32_e32 v15, v15, v14
		buffer_load_dwordx4 v5, s[28:31], 0 offen lds
		v_bitop3_b32 v5, v15, v16, v13 bitop3:0x96
		v_accvgpr_write_b32 a57, v5
		v_accvgpr_read_b32 v5, a10
		v_mul_lo_u32 v5, s17, v5
		v_accvgpr_read_b32 v15, a16
		v_mul_lo_u32 v15, s17, v15
		v_lshlrev_b32_e32 v15, 7, v15
		v_lshl_add_u32 v5, v5, 1, v15
		v_accvgpr_read_b32 v15, a17
		v_mul_lo_u32 v15, s17, v15
		v_lshl_add_u32 v5, v15, 6, v5
		v_accvgpr_read_b32 v15, a53
		v_mul_lo_u32 v15, s17, v15
		v_lshlrev_b32_e32 v15, 5, v15
		v_add3_u32 v5, v5, v15, v19
		v_add3_u32 v5, v5, v17, v20
		v_accvgpr_read_b32 v15, a0
		s_nop 0
		v_readfirstlane_b32 s38, v15
		v_readfirstlane_b32 s39, v2
		s_mul_i32 s38, s39, s38
		s_lshl_b32 s38, s38, 1
		v_accvgpr_read_b32 v2, a1
		s_nop 0
		v_readfirstlane_b32 s39, v2
		v_readfirstlane_b32 s46, v3
		s_mul_i32 s39, s46, s39
		s_lshl_b32 s39, s39, 1
		s_add_i32 s46, s38, s39
		v_add_u32_e32 v2, s46, v5
		v_cndmask_b32_e32 v2, v22, v2, vcc
		s_mul_i32 s42, 0x440, s42
		s_add_i32 m0, s42, 0x81f0
		v_xor_b32_e32 v12, v12, v14
		buffer_load_dwordx4 v2, s[32:35], 0 offen lds
		v_bitop3_b32 v2, v12, v16, v13 bitop3:0x96
		v_accvgpr_write_b32 a58, v2
		s_lshl_b32 s46, s17, 3
		s_add_i32 s46, s46, s38
		s_add_i32 s46, s46, s39
		v_add_u32_e32 v2, s46, v5
		v_cndmask_b32_e32 v2, v22, v2, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v8, v8, v11
		buffer_load_dwordx4 v2, s[32:35], 0 offen lds
		v_bitop3_b32 v2, v8, v16, v13 bitop3:0x96
		v_accvgpr_write_b32 a59, v2
		s_lshl_b32 s46, s17, 4
		s_add_i32 s46, s46, s38
		s_add_i32 s46, s46, s39
		v_add_u32_e32 v2, s46, v5
		v_cndmask_b32_e32 v2, v22, v2, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v8, v18, v11
		buffer_load_dwordx4 v2, s[32:35], 0 offen lds
		v_bitop3_b32 v2, v8, v16, v13 bitop3:0x96
		v_accvgpr_write_b32 a60, v2
		s_mul_i32 s46, 24, s17
		s_add_i32 s46, s46, s38
		s_add_i32 s46, s46, s39
		v_add_u32_e32 v2, s46, v5
		v_cndmask_b32_e32 v2, v22, v2, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v4, v4, v11
		buffer_load_dwordx4 v2, s[32:35], 0 offen lds
		v_bitop3_b32 v2, v4, v16, v13 bitop3:0x96
		v_accvgpr_write_b32 a61, v2
		s_mul_i32 s46, s36, 0x80
		v_mbcnt_lo_u32_b32 v2, -1, 0
		v_mbcnt_hi_u32_b32 v2, -1, v2
		v_and_b32_e32 v4, 1, v2
		v_lshrrev_b32_e32 v8, 4, v2
		v_and_b32_e32 v8, 1, v8
		v_lshlrev_b32_e32 v8, 4, v8
		v_lshrrev_b32_e32 v11, 3, v2
		v_and_b32_e32 v11, 1, v11
		v_lshlrev_b32_e32 v11, 3, v11
		v_add3_u32 v12, v4, v8, v11
		v_lshrrev_b32_e32 v13, 2, v2
		v_and_b32_e32 v13, 1, v13
		v_lshlrev_b32_e32 v13, 2, v13
		v_lshrrev_b32_e32 v2, 1, v2
		v_and_b32_e32 v2, 1, v2
		v_lshlrev_b32_e32 v2, 1, v2
		v_add3_u32 v12, v12, v13, v2
		v_add_u32_e32 v4, 32, v4
		v_bitop3_b32 v8, v13, v11, v8 bitop3:0x96
		v_bitop3_b32 v2, v4, v2, v8 bitop3:0x96
		v_mov_b32_e32 v14, 0x3e38aa3b
		v_mov_b32_e32 v15, 0x3e38aa3b
		s_mov_b32 s36, 0xff800000
		v_mov_b32_e32 v4, s36
		v_mov_b32_e32 v8, s36
		s_mov_b32 s36, 1.0
		v_mov_b32_e32 v16, s36
		v_mov_b32_e32 v17, s36
		s_mov_b32 s36, 0
		v_accvgpr_read_b32 v11, a18
		v_lshlrev_b32_e32 v11, 4, v11
		v_accvgpr_write_b32 a62, v11
		v_and_b32_e32 v7, 31, v7
		v_lshrrev_b32_e32 v11, 4, v7
		v_lshlrev_b32_e32 v11, 9, v11
		v_lshrrev_b32_e32 v13, 3, v7
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v18, 0x2080
		v_mul_lo_u32 v18, v18, v13
		v_accvgpr_write_b32 a63, v18
		v_lshrrev_b32_e32 v13, 2, v7
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v18, 0x1040
		v_mul_lo_u32 v18, v18, v13
		v_accvgpr_write_b32 a64, v18
		v_lshrrev_b32_e32 v13, 1, v7
		v_and_b32_e32 v13, 1, v13
		v_mov_b32_e32 v18, 0x820
		v_mul_lo_u32 v18, v18, v13
		v_accvgpr_write_b32 a65, v18
		v_and_b32_e32 v7, 1, v7
		v_mov_b32_e32 v13, 0x410
		v_mul_lo_u32 v13, v13, v7
		v_accvgpr_write_b32 a66, v13
		v_and_b32_e32 v7, 3, v0
		v_accvgpr_write_b32 a67, v7
		v_accvgpr_read_b32 v7, a67
		v_lshlrev_b32_e32 v7, 3, v7
		v_accvgpr_write_b32 a68, v7
		v_accvgpr_read_b32 v7, a16
		v_mov_b32_e32 v13, 0x2200
		v_mul_lo_u32 v13, v13, v7
		v_accvgpr_write_b32 a69, v13
		v_accvgpr_read_b32 v7, a17
		v_lshlrev_b32_e32 v7, 5, v7
		v_accvgpr_write_b32 a70, v7
		v_and_b32_e32 v6, 3, v6
		v_mov_b32_e32 v7, 0x440
		v_mul_lo_u32 v7, v7, v6
		v_accvgpr_write_b32 a71, v7
		s_lshl_b32 s47, s15, 8
		s_add_i32 s47, s47, s37
		s_add_i32 s47, s47, s41
		s_mul_i32 s48, 0x108, s15
		s_add_i32 s48, s48, s37
		s_add_i32 s48, s48, s41
		s_mul_i32 s49, 0x110, s15
		s_add_i32 s49, s49, s37
		s_add_i32 s49, s49, s41
		s_mul_i32 s50, 0x118, s15
		s_add_i32 s37, s50, s37
		s_add_i32 s37, s37, s41
		s_lshl_b32 s41, s17, 8
		s_add_i32 s41, s41, s38
		s_add_i32 s50, s41, s39
		s_mul_i32 s41, 0x108, s17
		s_add_i32 s41, s41, s38
		s_add_i32 s51, s41, s39
		s_mul_i32 s41, 0x110, s17
		s_add_i32 s41, s41, s38
		s_add_i32 s52, s41, s39
		s_mul_i32 s41, 0x118, s17
		s_add_i32 s38, s41, s38
		s_add_i32 s38, s38, s39
		v_lshlrev_b32_e32 v6, 2, v12
		v_accvgpr_write_b32 a72, v6
		v_lshlrev_b32_e32 v2, 2, v2
		v_accvgpr_write_b32 a73, v2
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
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_1
.L_attn_fwd_persistent.loop_head_1:
		s_waitcnt vmcnt(0)
		s_barrier
		s_lshr_b32 s39, s36, 7
		s_and_b32 s41, s39, 1
		s_mul_i32 s53, 0x4100, s41
		v_accvgpr_read_b32 v2, a62
		v_add3_u32 v2, s53, v2, v11
		v_accvgpr_read_b32 v6, a63
		v_accvgpr_read_b32 v7, a64
		v_add3_u32 v2, v2, v6, v7
		v_accvgpr_read_b32 v6, a65
		v_accvgpr_read_b32 v7, a66
		v_add3_u32 v2, v2, v6, v7
		ds_read_b128 v[24:27], v2
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
		s_mul_i32 s41, 0x4400, s41
		v_accvgpr_read_b32 v2, a68
		v_accvgpr_read_b32 v6, a69
		v_add3_u32 v2, s41, v2, v6
		v_accvgpr_read_b32 v6, a70
		v_accvgpr_read_b32 v7, a71
		v_add3_u32 v2, v2, v6, v7
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
		s_mul_i32 s41, s15, s36
		s_lshl_b32 s41, s41, 1
		s_add_i32 s53, s47, s41
		v_add_u32_e32 v2, s53, v10
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v6, s41, v10
		s_add_i32 s39, s39, 1
		v_add_u32_e32 v7, s48, v6
		s_and_b32 s39, s39, 1
		v_add_u32_e32 v12, s49, v6
		s_mul_i32 s41, 0x4100, s39
		v_add_u32_e32 v6, s37, v6
		s_add_i32 s41, s43, s41
		v_mfma_f32_32x32x16_bf16 v[112:127], v[24:27], a[20:23], 0
		s_mov_b32 m0, s41
		v_mfma_f32_32x32x16_bf16 v[128:143], v[28:31], a[20:23], 0
		s_mul_i32 s41, s17, s36
		v_mfma_f32_32x32x16_bf16 v[144:159], v[96:99], a[20:23], 0
		s_add_i32 s36, s36, 0x80
		v_mfma_f32_32x32x16_bf16 v[160:175], v[100:103], a[20:23], 0
		v_accvgpr_read_b32 v13, a19
		v_add_u32_e32 v13, s36, v13
		v_mfma_f32_32x32x16_bf16 v[176:191], v[100:103], a[36:39], 0
		v_accvgpr_read_b32 v18, a56
		v_add_u32_e32 v18, s36, v18
		v_mfma_f32_32x32x16_bf16 v[192:207], v[24:27], a[36:39], 0
		v_accvgpr_read_b32 v19, a57
		v_add_u32_e32 v19, s36, v19
		v_mfma_f32_32x32x16_bf16 v[208:223], v[28:31], a[36:39], 0
		v_accvgpr_read_b32 v20, a58
		v_add_u32_e32 v20, s36, v20
		v_mfma_f32_32x32x16_bf16 v[224:239], v[96:99], a[36:39], 0
		v_cmp_lt_i32_e64 s[54:55], v13, s21
		v_mfma_f32_32x32x16_bf16 v[112:127], a[76:79], a[24:27], v[112:127]
		v_accvgpr_read_b32 v13, a52
		v_add_u32_e32 v13, s36, v13
		v_mfma_f32_32x32x16_bf16 v[128:143], a[88:91], a[24:27], v[128:143]
		v_accvgpr_read_b32 v21, a59
		v_add_u32_e32 v21, s36, v21
		v_mfma_f32_32x32x16_bf16 v[144:159], a[100:103], a[24:27], v[144:159]
		v_accvgpr_read_b32 v23, a60
		v_add_u32_e32 v23, s36, v23
		v_mfma_f32_32x32x16_bf16 v[160:175], a[112:115], a[24:27], v[160:175]
		v_cmp_lt_i32_e64 s[56:57], v13, s21
		v_mfma_f32_32x32x16_bf16 v[176:191], a[112:115], a[40:43], v[176:191]
		v_cndmask_b32_e64 v2, v22, v2, s[54:55]
		buffer_load_dwordx4 v2, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[192:207], a[76:79], a[40:43], v[192:207]
		v_cmp_lt_i32_e64 s[54:55], v18, s21
		v_mfma_f32_32x32x16_bf16 v[208:223], a[88:91], a[40:43], v[208:223]
		s_nop 0
		v_cndmask_b32_e64 v2, v22, v7, s[54:55]
		v_cmp_lt_i32_e64 s[54:55], v19, s21
		s_add_i32 m0, m0, 0x1040
		s_nop 0
		v_cndmask_b32_e64 v7, v22, v12, s[54:55]
		buffer_load_dwordx4 v2, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v20, s21
		s_nop 1
		v_cndmask_b32_e64 v2, v22, v6, s[54:55]
		s_add_i32 m0, m0, 0x1040
		v_accvgpr_read_b32 v6, a61
		v_add_u32_e32 v6, s36, v6
		s_lshl_b32 s41, s41, 1
		buffer_load_dwordx4 v7, s[28:31], 0 offen lds
		s_add_i32 s53, s50, s41
		v_add_u32_e32 v7, s53, v5
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v7, v22, v7, s[56:57]
		s_mul_i32 s39, 0x4400, s39
		buffer_load_dwordx4 v2, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[54:55], v21, s21
		s_add_i32 s39, s42, s39
		v_add_u32_e32 v2, s41, v5
		s_add_i32 m0, s39, 0x81f0
		v_add_u32_e32 v12, s51, v2
		buffer_load_dwordx4 v7, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[224:239], a[100:103], a[40:43], v[224:239]
		v_cndmask_b32_e64 v7, v22, v12, s[54:55]
		v_cmp_lt_i32_e64 s[54:55], v23, s21
		s_add_i32 m0, m0, 0x1100
		v_add_u32_e32 v12, s52, v2
		buffer_load_dwordx4 v7, s[32:35], 0 offen lds
		v_cndmask_b32_e64 v7, v22, v12, s[54:55]
		v_cmp_lt_i32_e64 vcc, v6, s21
		s_add_i32 m0, m0, 0x1100
		v_add_u32_e32 v2, s38, v2
		v_cndmask_b32_e32 v2, v22, v2, vcc
		buffer_load_dwordx4 v7, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[112:127], a[80:83], a[28:31], v[112:127]
		s_add_i32 m0, m0, 0x1100
		s_cmp_lt_i32 s36, s46
		v_mfma_f32_32x32x16_bf16 v[128:143], a[92:95], a[28:31], v[128:143]
		buffer_load_dwordx4 v2, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[144:159], a[104:107], a[28:31], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[116:119], a[28:31], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[116:119], a[44:47], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[80:83], a[44:47], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[92:95], a[44:47], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[104:107], a[44:47], v[224:239]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[84:87], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[96:99], a[32:35], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[108:111], a[32:35], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[120:123], a[32:35], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[120:123], a[48:51], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[84:87], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[96:99], a[48:51], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[224:239], a[108:111], a[48:51], v[224:239]
		s_nop 4
		v_max3_f32 v2, v112, v113, v114
		v_max3_f32 v6, v116, v117, v118
		v_max3_f32 v7, v120, v121, v122
		v_max3_f32 v12, v124, v125, v126
		v_max3_f32 v13, v128, v129, v130
		v_max3_f32 v18, v132, v133, v134
		v_max3_f32 v19, v136, v137, v138
		v_max3_f32 v20, v140, v141, v142
		v_max3_f32 v21, v144, v145, v146
		v_max3_f32 v23, v148, v149, v150
		v_max3_f32 v24, v152, v153, v154
		v_max3_f32 v25, v156, v157, v158
		v_max3_f32 v26, v160, v161, v162
		v_max3_f32 v27, v164, v165, v166
		v_max3_f32 v28, v168, v169, v170
		v_max3_f32 v29, v172, v173, v174
		v_max3_f32 v2, v2, v115, v6
		v_max3_f32 v6, v7, v123, v12
		v_max3_f32 v7, v13, v131, v18
		v_max3_f32 v12, v19, v139, v20
		v_max3_f32 v13, v21, v147, v23
		v_max3_f32 v18, v24, v155, v25
		v_max3_f32 v19, v26, v163, v27
		v_max3_f32 v20, v28, v171, v29
		v_max3_f32 v2, v2, v119, v6
		v_max3_f32 v6, v7, v135, v12
		v_max3_f32 v7, v13, v151, v18
		v_max3_f32 v12, v19, v167, v20
		v_max3_f32 v2, v2, v127, v6
		v_max3_f32 v6, v7, v159, v12
		v_max3_f32 v2, v2, v143, v6
		v_max_f32_e32 v6, v2, v175
		v_mov_b32_e32 v7, v6
		v_max3_f32 v2, v192, v193, v194
		v_max3_f32 v12, v196, v197, v198
		v_max3_f32 v13, v200, v201, v202
		v_max3_f32 v18, v204, v205, v206
		v_max3_f32 v19, v208, v209, v210
		v_max3_f32 v20, v212, v213, v214
		v_max3_f32 v21, v216, v217, v218
		v_max3_f32 v23, v220, v221, v222
		v_max3_f32 v24, v224, v225, v226
		v_max3_f32 v25, v228, v229, v230
		v_max3_f32 v26, v232, v233, v234
		v_max3_f32 v27, v236, v237, v238
		v_max3_f32 v28, v176, v177, v178
		v_max3_f32 v29, v180, v181, v182
		v_max3_f32 v30, v184, v185, v186
		v_max3_f32 v31, v188, v189, v190
		v_permlane32_swap_b32_e32 v6, v7
		v_max3_f32 v2, v2, v195, v12
		v_max3_f32 v12, v13, v203, v18
		v_max3_f32 v13, v19, v211, v20
		v_max3_f32 v18, v21, v219, v23
		v_max3_f32 v19, v24, v227, v25
		v_max3_f32 v20, v26, v235, v27
		v_max3_f32 v21, v28, v179, v29
		v_max3_f32 v23, v30, v187, v31
		v_max3_f32 v2, v2, v199, v12
		v_max3_f32 v12, v13, v215, v18
		v_max3_f32 v13, v19, v231, v20
		v_max3_f32 v18, v21, v183, v23
		v_max3_f32 v2, v2, v207, v12
		v_max3_f32 v12, v13, v239, v18
		v_max3_f32 v2, v2, v223, v12
		v_max_f32_e32 v12, v2, v191
		v_mov_b32_e32 v13, v12
		v_max_f32_e32 v18, v6, v7
		v_mov_b32_e32 v6, v4
		v_permlane32_swap_b32_e32 v12, v13
		v_max_f32_e32 v19, v12, v13
		v_pk_mul_f32 v[12:13], v[18:19], v[14:15]
		v_max_f32_e32 v18, v4, v12
		v_max_f32_e32 v19, v8, v13
		v_pk_fma_f32 v[12:13], v[112:113], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[20:21], v[114:115], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[116:117], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[118:119], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[120:121], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[122:123], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[124:125], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[126:127], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[128:129], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[130:131], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[132:133], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[134:135], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[136:137], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[138:139], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[140:141], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[142:143], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[144:145], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[146:147], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[148:149], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[150:151], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[152:153], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[154:155], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[156:157], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[158:159], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[160:161], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[162:163], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[164:165], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[166:167], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[168:169], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[170:171], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[172:173], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[174:175], v[14:15], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[192:193], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[194:195], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[196:197], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[198:199], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[200:201], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[202:203], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[204:205], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[206:207], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[208:209], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[210:211], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[212:213], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[214:215], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[216:217], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[218:219], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[220:221], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[222:223], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[224:225], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[226:227], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[228:229], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[230:231], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[232:233], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[234:235], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[236:237], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[238:239], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[176:177], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[178:179], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[180:181], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[182:183], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[184:185], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[186:187], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[188:189], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[190:191], v[14:15], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v190, v12
		v_exp_f32_e32 v214, v13
		v_exp_f32_e32 v12, v20
		v_exp_f32_e32 v216, v21
		v_exp_f32_e32 v20, v24
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
		v_exp_f32_e32 v191, v116
		v_exp_f32_e32 v215, v117
		v_exp_f32_e32 v13, v118
		v_exp_f32_e32 v217, v119
		v_exp_f32_e32 v21, v120
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
		v_exp_f32_e32 v114, v148
		v_exp_f32_e32 v116, v149
		v_exp_f32_e32 v118, v150
		v_exp_f32_e32 v120, v151
		v_exp_f32_e32 v122, v152
		v_exp_f32_e32 v124, v153
		v_exp_f32_e32 v126, v154
		v_exp_f32_e32 v128, v155
		v_exp_f32_e32 v130, v156
		v_exp_f32_e32 v132, v157
		v_exp_f32_e32 v134, v158
		v_exp_f32_e32 v136, v159
		v_exp_f32_e32 v138, v160
		v_exp_f32_e32 v140, v161
		v_exp_f32_e32 v142, v162
		v_exp_f32_e32 v144, v163
		v_exp_f32_e32 v146, v164
		v_exp_f32_e32 v148, v165
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
		v_exp_f32_e32 v170, v192
		v_exp_f32_e32 v172, v193
		v_exp_f32_e32 v174, v194
		v_exp_f32_e32 v192, v195
		v_exp_f32_e32 v115, v196
		v_exp_f32_e32 v117, v197
		v_exp_f32_e32 v119, v198
		v_exp_f32_e32 v121, v199
		v_exp_f32_e32 v123, v200
		v_exp_f32_e32 v125, v201
		v_exp_f32_e32 v127, v202
		v_exp_f32_e32 v129, v203
		v_exp_f32_e32 v131, v204
		v_exp_f32_e32 v133, v205
		v_exp_f32_e32 v135, v206
		v_exp_f32_e32 v137, v207
		v_exp_f32_e32 v139, v208
		v_exp_f32_e32 v141, v209
		v_exp_f32_e32 v143, v210
		v_exp_f32_e32 v145, v211
		v_exp_f32_e32 v147, v212
		v_exp_f32_e32 v149, v213
		v_exp_f32_e32 v151, v176
		v_exp_f32_e32 v153, v177
		v_exp_f32_e32 v155, v178
		v_exp_f32_e32 v157, v179
		v_exp_f32_e32 v159, v180
		v_exp_f32_e32 v161, v181
		v_exp_f32_e32 v163, v182
		v_exp_f32_e32 v165, v183
		v_exp_f32_e32 v167, v184
		v_exp_f32_e32 v169, v185
		v_exp_f32_e32 v171, v186
		v_exp_f32_e32 v173, v187
		v_exp_f32_e32 v175, v188
		v_exp_f32_e32 v193, v189
		v_pk_add_f32 v[176:177], v[190:191], v[214:215]
		v_pk_add_f32 v[178:179], v[12:13], v[216:217]
		v_pk_add_f32 v[180:181], v[20:21], v[218:219]
		v_pk_add_f32 v[182:183], v[24:25], v[220:221]
		v_pk_add_f32 v[184:185], v[26:27], v[222:223]
		v_pk_add_f32 v[186:187], v[28:29], v[224:225]
		v_pk_add_f32 v[188:189], v[30:31], v[226:227]
		v_pk_add_f32 v[194:195], v[96:97], v[228:229]
		v_pk_add_f32 v[196:197], v[98:99], v[230:231]
		v_pk_add_f32 v[198:199], v[100:101], v[232:233]
		v_pk_add_f32 v[200:201], v[102:103], v[234:235]
		v_pk_add_f32 v[202:203], v[104:105], v[236:237]
		v_pk_add_f32 v[204:205], v[106:107], v[238:239]
		v_pk_add_f32 v[206:207], v[108:109], v[240:241]
		v_pk_add_f32 v[208:209], v[110:111], v[242:243]
		v_pk_add_f32 v[210:211], v[112:113], v[244:245]
		v_pk_add_f32 v[176:177], v[176:177], v[178:179]
		v_pk_add_f32 v[178:179], v[180:181], v[182:183]
		v_pk_add_f32 v[180:181], v[184:185], v[186:187]
		v_pk_add_f32 v[182:183], v[188:189], v[194:195]
		v_pk_add_f32 v[184:185], v[196:197], v[198:199]
		v_pk_add_f32 v[186:187], v[200:201], v[202:203]
		v_pk_add_f32 v[188:189], v[204:205], v[206:207]
		v_pk_add_f32 v[194:195], v[208:209], v[210:211]
		v_pk_add_f32 v[176:177], v[176:177], v[178:179]
		v_pk_add_f32 v[178:179], v[180:181], v[182:183]
		v_pk_add_f32 v[180:181], v[184:185], v[186:187]
		v_pk_add_f32 v[182:183], v[188:189], v[194:195]
		v_pk_add_f32 v[176:177], v[176:177], v[178:179]
		v_pk_add_f32 v[178:179], v[180:181], v[182:183]
		v_pk_add_f32 v[180:181], v[176:177], v[178:179]
		v_add_f32_e32 v2, v180, v181
		v_accvgpr_read_b32 v4, a72
		ds_bpermute_b32 v176, v4, v2
		v_accvgpr_read_b32 v4, a73
		ds_bpermute_b32 v178, v4, v2
		v_pk_add_f32 v[180:181], v[114:115], v[116:117]
		v_pk_add_f32 v[182:183], v[118:119], v[120:121]
		v_pk_add_f32 v[184:185], v[122:123], v[124:125]
		v_pk_add_f32 v[186:187], v[126:127], v[128:129]
		v_pk_add_f32 v[188:189], v[130:131], v[132:133]
		v_pk_add_f32 v[194:195], v[134:135], v[136:137]
		v_pk_add_f32 v[196:197], v[138:139], v[140:141]
		v_pk_add_f32 v[198:199], v[142:143], v[144:145]
		v_pk_add_f32 v[200:201], v[146:147], v[148:149]
		v_pk_add_f32 v[202:203], v[150:151], v[152:153]
		v_pk_add_f32 v[204:205], v[154:155], v[156:157]
		v_pk_add_f32 v[206:207], v[158:159], v[160:161]
		v_pk_add_f32 v[208:209], v[162:163], v[164:165]
		v_pk_add_f32 v[210:211], v[166:167], v[168:169]
		v_pk_add_f32 v[212:213], v[170:171], v[172:173]
		v_pk_add_f32 v[246:247], v[174:175], v[192:193]
		v_pk_add_f32 v[180:181], v[180:181], v[182:183]
		v_pk_add_f32 v[182:183], v[184:185], v[186:187]
		v_pk_add_f32 v[184:185], v[188:189], v[194:195]
		v_pk_add_f32 v[186:187], v[196:197], v[198:199]
		v_pk_add_f32 v[188:189], v[200:201], v[202:203]
		v_pk_add_f32 v[194:195], v[204:205], v[206:207]
		v_pk_add_f32 v[196:197], v[208:209], v[210:211]
		v_pk_add_f32 v[198:199], v[212:213], v[246:247]
		v_pk_add_f32 v[180:181], v[180:181], v[182:183]
		v_pk_add_f32 v[182:183], v[184:185], v[186:187]
		v_pk_add_f32 v[184:185], v[188:189], v[194:195]
		v_pk_add_f32 v[186:187], v[196:197], v[198:199]
		v_pk_add_f32 v[180:181], v[180:181], v[182:183]
		v_pk_add_f32 v[182:183], v[184:185], v[186:187]
		v_pk_add_f32 v[184:185], v[180:181], v[182:183]
		v_mov_b32_e32 v179, v185
		v_mov_b32_e32 v177, v184
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[180:181], v[176:177], v[178:179]
		v_mov_b32_e32 v176, v181
		v_mov_b32_e32 v177, v181
		v_cvt_pk_bf16_f32 v184, v190, v214
		v_cvt_pk_bf16_f32 v185, v12, v216
		v_permlane32_swap_b32_e32 v176, v177
		v_add_f32_e32 v179, v176, v177
		v_mov_b32_e32 v7, v8
		v_pk_add_f32 v[176:177], v[6:7], v[18:19] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v6, v176
		v_exp_f32_e32 v7, v177
		v_cvt_pk_bf16_f32 v186, v20, v218
		v_pk_mul_f32 v[34:35], v[34:35], v[6:7] op_sel_hi:[1,0]
		v_pk_mul_f32 v[36:37], v[36:37], v[6:7] op_sel_hi:[1,0]
		v_pk_mul_f32 v[38:39], v[38:39], v[6:7] op_sel_hi:[1,0]
		v_pk_mul_f32 v[40:41], v[40:41], v[6:7] op_sel_hi:[1,0]
		v_pk_mul_f32 v[42:43], v[42:43], v[6:7] op_sel_hi:[1,0]
		v_pk_mul_f32 v[44:45], v[44:45], v[6:7] op_sel_hi:[1,0]
		v_pk_mul_f32 v[46:47], v[46:47], v[6:7] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[48:49], v[6:7] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[50:51], v[6:7] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[52:53], v[6:7] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[54:55], v[6:7] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[56:57], v[6:7] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[58:59], v[6:7] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[60:61], v[6:7] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[62:63], v[6:7] op_sel_hi:[1,0]
		v_pk_mul_f32 v[32:33], v[32:33], v[6:7] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[64:65], v[6:7] op_sel:[0,1]
		v_pk_mul_f32 v[66:67], v[66:67], v[6:7] op_sel:[0,1]
		v_pk_mul_f32 v[68:69], v[68:69], v[6:7] op_sel:[0,1]
		v_pk_mul_f32 v[70:71], v[70:71], v[6:7] op_sel:[0,1]
		v_pk_mul_f32 v[72:73], v[72:73], v[6:7] op_sel:[0,1]
		v_pk_mul_f32 v[74:75], v[74:75], v[6:7] op_sel:[0,1]
		v_pk_mul_f32 v[76:77], v[76:77], v[6:7] op_sel:[0,1]
		v_pk_mul_f32 v[78:79], v[78:79], v[6:7] op_sel:[0,1]
		v_pk_mul_f32 v[80:81], v[80:81], v[6:7] op_sel:[0,1]
		v_pk_mul_f32 v[82:83], v[82:83], v[6:7] op_sel:[0,1]
		v_pk_mul_f32 v[84:85], v[84:85], v[6:7] op_sel:[0,1]
		v_pk_mul_f32 v[86:87], v[86:87], v[6:7] op_sel:[0,1]
		v_pk_mul_f32 v[88:89], v[88:89], v[6:7] op_sel:[0,1]
		v_pk_mul_f32 v[90:91], v[90:91], v[6:7] op_sel:[0,1]
		v_pk_mul_f32 v[92:93], v[92:93], v[6:7] op_sel:[0,1]
		v_pk_mul_f32 v[94:95], v[94:95], v[6:7] op_sel:[0,1]
		v_mov_b32_e32 v178, v180
		v_mov_b64_e32 v[176:177], v[16:17]
		v_pk_fma_f32 v[16:17], v[176:177], v[6:7], v[178:179]
		v_cvt_pk_bf16_f32 v187, v24, v220
		v_cvt_pk_bf16_f32 v176, v26, v222
		v_cvt_pk_bf16_f32 v177, v28, v224
		v_cvt_pk_bf16_f32 v178, v30, v226
		v_cvt_pk_bf16_f32 v179, v96, v228
		v_cvt_pk_bf16_f32 v180, v98, v230
		v_cvt_pk_bf16_f32 v181, v100, v232
		v_cvt_pk_bf16_f32 v182, v102, v234
		v_cvt_pk_bf16_f32 v183, v104, v236
		v_cvt_pk_bf16_f32 v196, v106, v238
		v_cvt_pk_bf16_f32 v197, v108, v240
		v_cvt_pk_bf16_f32 v198, v110, v242
		v_cvt_pk_bf16_f32 v199, v112, v244
		v_cvt_pk_bf16_f32 v200, v191, v215
		v_cvt_pk_bf16_f32 v201, v13, v217
		v_cvt_pk_bf16_f32 v202, v21, v219
		v_cvt_pk_bf16_f32 v203, v25, v221
		v_cvt_pk_bf16_f32 v188, v27, v223
		v_cvt_pk_bf16_f32 v189, v29, v225
		v_cvt_pk_bf16_f32 v190, v31, v227
		v_cvt_pk_bf16_f32 v191, v97, v229
		v_cvt_pk_bf16_f32 v24, v99, v231
		v_cvt_pk_bf16_f32 v25, v101, v233
		v_cvt_pk_bf16_f32 v26, v103, v235
		v_cvt_pk_bf16_f32 v27, v105, v237
		v_cvt_pk_bf16_f32 v28, v107, v239
		v_cvt_pk_bf16_f32 v29, v109, v241
		v_cvt_pk_bf16_f32 v30, v111, v243
		v_cvt_pk_bf16_f32 v31, v113, v245
		v_cvt_pk_bf16_f32 v96, v114, v116
		v_cvt_pk_bf16_f32 v97, v118, v120
		v_cvt_pk_bf16_f32 v98, v122, v124
		v_cvt_pk_bf16_f32 v99, v126, v128
		v_cvt_pk_bf16_f32 v100, v130, v132
		v_cvt_pk_bf16_f32 v101, v134, v136
		v_cvt_pk_bf16_f32 v102, v138, v140
		v_cvt_pk_bf16_f32 v103, v142, v144
		v_cvt_pk_bf16_f32 v104, v146, v148
		v_cvt_pk_bf16_f32 v105, v150, v152
		v_cvt_pk_bf16_f32 v106, v154, v156
		v_cvt_pk_bf16_f32 v107, v158, v160
		v_cvt_pk_bf16_f32 v108, v162, v164
		v_cvt_pk_bf16_f32 v109, v166, v168
		v_cvt_pk_bf16_f32 v110, v170, v172
		v_cvt_pk_bf16_f32 v111, v174, v192
		v_cvt_pk_bf16_f32 v204, v115, v117
		v_cvt_pk_bf16_f32 v205, v119, v121
		v_cvt_pk_bf16_f32 v206, v123, v125
		v_cvt_pk_bf16_f32 v207, v127, v129
		v_cvt_pk_bf16_f32 v112, v131, v133
		v_cvt_pk_bf16_f32 v113, v135, v137
		v_cvt_pk_bf16_f32 v114, v139, v141
		v_cvt_pk_bf16_f32 v115, v143, v145
		v_cvt_pk_bf16_f32 v116, v147, v149
		v_cvt_pk_bf16_f32 v117, v151, v153
		v_cvt_pk_bf16_f32 v118, v155, v157
		v_cvt_pk_bf16_f32 v119, v159, v161
		v_cvt_pk_bf16_f32 v120, v163, v165
		v_cvt_pk_bf16_f32 v121, v167, v169
		v_cvt_pk_bf16_f32 v122, v171, v173
		v_cvt_pk_bf16_f32 v123, v175, v193
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_permlane32_swap_b32_e32 v176, v178
		v_permlane32_swap_b32_e32 v177, v179
		s_nop 0
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
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[48:63], a[164:167], v[180:183], v[48:63]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[32:47], a[136:139], v[196:199], v[32:47]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[48:63], a[168:171], v[196:199], v[48:63]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[80:95], a[156:159], v[96:99], v[80:95]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[64:79], a[124:127], v[96:99], v[64:79]
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_mfma_f32_32x32x16_bf16 v[80:95], a[160:163], v[100:103], v[80:95]
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_mfma_f32_32x32x16_bf16 v[64:79], a[128:131], v[100:103], v[64:79]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[80:95], a[164:167], v[104:107], v[80:95]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[64:79], a[132:135], v[104:107], v[64:79]
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_mfma_f32_32x32x16_bf16 v[80:95], a[168:171], v[108:111], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[136:139], v[108:111], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[140:143], v[200:203], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[172:175], v[200:203], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[172:175], v[204:207], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[140:143], v[204:207], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[144:147], v[188:191], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[176:179], v[188:191], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[176:179], v[112:115], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[144:147], v[112:115], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[148:151], v[24:27], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[180:183], v[24:27], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[180:183], v[116:119], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[148:151], v[116:119], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[152:155], v[28:31], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[184:187], v[28:31], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[184:187], v[120:123], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[152:155], v[120:123], v[64:79]
		v_mov_b32_e32 v4, v18
		v_mov_b32_e32 v8, v19
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_1
.L_attn_fwd_persistent.loop_exit_1:
		s_mul_i32 s25, s25, 0x80
		v_accvgpr_read_b32 v2, a11
		v_readfirstlane_b32 s36, v1
		s_nop 1
		v_add_u32_e32 v2, s36, v2
		v_add_u32_e32 v2, s19, v2
		v_accvgpr_read_b32 v6, a12
		v_readfirstlane_b32 s36, v1
		s_nop 1
		v_add_u32_e32 v6, s36, v6
		v_add_u32_e32 v6, s19, v6
		v_xor_b32_e32 v7, 1, v9
		v_accvgpr_write_b32 a11, v7
		v_xor_b32_e32 v7, 2, v9
		v_accvgpr_write_b32 a12, v7
		v_xor_b32_e32 v7, 3, v9
		v_accvgpr_write_b32 a62, v7
		v_xor_b32_e32 v7, 8, v9
		v_accvgpr_write_b32 a68, v7
		v_xor_b32_e32 v7, 9, v9
		v_accvgpr_write_b32 a74, v7
		v_xor_b32_e32 v7, 10, v9
		v_accvgpr_write_b32 a75, v7
		v_xor_b32_e32 v7, 11, v9
		v_accvgpr_write_b32 a76, v7
		v_xor_b32_e32 v7, 16, v9
		v_accvgpr_write_b32 a77, v7
		v_xor_b32_e32 v7, 17, v9
		v_accvgpr_write_b32 a78, v7
		v_xor_b32_e32 v7, 18, v9
		v_accvgpr_write_b32 a79, v7
		v_xor_b32_e32 v7, 19, v9
		v_accvgpr_write_b32 a80, v7
		v_xor_b32_e32 v7, 24, v9
		v_accvgpr_write_b32 a81, v7
		v_xor_b32_e32 v7, 25, v9
		v_accvgpr_write_b32 a82, v7
		v_xor_b32_e32 v7, 26, v9
		v_accvgpr_write_b32 a83, v7
		v_xor_b32_e32 v7, 27, v9
		v_accvgpr_write_b32 a84, v7
		v_xor_b32_e32 v7, 32, v9
		v_accvgpr_write_b32 a85, v7
		v_xor_b32_e32 v7, 33, v9
		v_accvgpr_write_b32 a86, v7
		v_xor_b32_e32 v7, 34, v9
		v_accvgpr_write_b32 a87, v7
		v_xor_b32_e32 v7, 35, v9
		v_accvgpr_write_b32 a88, v7
		v_xor_b32_e32 v7, 40, v9
		v_accvgpr_write_b32 a89, v7
		v_xor_b32_e32 v7, 41, v9
		v_accvgpr_write_b32 a90, v7
		v_xor_b32_e32 v7, 42, v9
		v_accvgpr_write_b32 a91, v7
		v_xor_b32_e32 v7, 43, v9
		v_accvgpr_write_b32 a92, v7
		v_xor_b32_e32 v7, 48, v9
		v_accvgpr_write_b32 a93, v7
		v_xor_b32_e32 v7, 49, v9
		v_accvgpr_write_b32 a94, v7
		v_xor_b32_e32 v7, 50, v9
		v_accvgpr_write_b32 a95, v7
		v_xor_b32_e32 v7, 51, v9
		v_accvgpr_write_b32 a96, v7
		v_xor_b32_e32 v7, 56, v9
		v_accvgpr_write_b32 a97, v7
		v_xor_b32_e32 v7, 57, v9
		v_accvgpr_write_b32 a98, v7
		v_xor_b32_e32 v7, 58, v9
		v_accvgpr_write_b32 a99, v7
		v_xor_b32_e32 v7, 59, v9
		v_accvgpr_write_b32 a100, v7
		v_xor_b32_e32 v7, 64, v9
		v_accvgpr_write_b32 a101, v7
		v_xor_b32_e32 v7, 0x41, v9
		v_accvgpr_write_b32 a102, v7
		v_xor_b32_e32 v7, 0x42, v9
		v_accvgpr_write_b32 a103, v7
		v_xor_b32_e32 v7, 0x43, v9
		v_accvgpr_write_b32 a104, v7
		v_xor_b32_e32 v7, 0x48, v9
		v_accvgpr_write_b32 a105, v7
		v_xor_b32_e32 v7, 0x49, v9
		v_accvgpr_write_b32 a106, v7
		v_xor_b32_e32 v7, 0x4a, v9
		v_accvgpr_write_b32 a107, v7
		v_xor_b32_e32 v7, 0x4b, v9
		v_accvgpr_write_b32 a108, v7
		v_xor_b32_e32 v7, 0x50, v9
		v_accvgpr_write_b32 a109, v7
		v_xor_b32_e32 v7, 0x51, v9
		v_accvgpr_write_b32 a110, v7
		v_xor_b32_e32 v7, 0x52, v9
		v_accvgpr_write_b32 a111, v7
		v_xor_b32_e32 v7, 0x53, v9
		v_accvgpr_write_b32 a112, v7
		v_xor_b32_e32 v7, 0x58, v9
		v_accvgpr_write_b32 a113, v7
		v_xor_b32_e32 v7, 0x59, v9
		v_accvgpr_write_b32 a114, v7
		v_xor_b32_e32 v7, 0x5a, v9
		v_accvgpr_write_b32 a115, v7
		v_xor_b32_e32 v7, 0x5b, v9
		v_accvgpr_write_b32 a116, v7
		v_xor_b32_e32 v7, 0x60, v9
		v_accvgpr_write_b32 a117, v7
		v_xor_b32_e32 v7, 0x61, v9
		v_accvgpr_write_b32 a118, v7
		v_xor_b32_e32 v7, 0x62, v9
		v_accvgpr_write_b32 a119, v7
		v_xor_b32_e32 v7, 0x63, v9
		v_accvgpr_write_b32 a120, v7
		v_xor_b32_e32 v7, 0x68, v9
		v_accvgpr_write_b32 a121, v7
		v_xor_b32_e32 v7, 0x69, v9
		v_accvgpr_write_b32 a122, v7
		v_xor_b32_e32 v7, 0x6a, v9
		v_accvgpr_write_b32 a123, v7
		v_xor_b32_e32 v7, 0x6b, v9
		v_accvgpr_write_b32 a124, v7
		v_xor_b32_e32 v7, 0x70, v9
		v_accvgpr_write_b32 a125, v7
		v_xor_b32_e32 v7, 0x71, v9
		v_accvgpr_write_b32 a126, v7
		v_xor_b32_e32 v7, 0x72, v9
		v_accvgpr_write_b32 a127, v7
		v_xor_b32_e32 v7, 0x73, v9
		v_accvgpr_write_b32 a128, v7
		v_xor_b32_e32 v7, 0x78, v9
		v_accvgpr_write_b32 a129, v7
		v_xor_b32_e32 v7, 0x79, v9
		v_accvgpr_write_b32 a130, v7
		v_xor_b32_e32 v7, 0x7a, v9
		v_accvgpr_write_b32 a131, v7
		v_xor_b32_e32 v7, 0x7b, v9
		v_accvgpr_write_b32 a132, v7
		v_accvgpr_read_b32 v7, a18
		v_lshl_add_u32 v7, v7, 4, v11
		v_accvgpr_read_b32 v11, a63
		v_accvgpr_read_b32 v12, a64
		v_add3_u32 v7, v7, v11, v12
		v_accvgpr_read_b32 v11, a65
		v_accvgpr_read_b32 v12, a66
		v_add3_u32 v7, v7, v11, v12
		v_accvgpr_write_b32 a18, v7
		v_accvgpr_read_b32 v7, a67
		v_accvgpr_read_b32 v11, a69
		v_lshl_add_u32 v7, v7, 3, v11
		v_accvgpr_read_b32 v11, a70
		v_accvgpr_read_b32 v12, a71
		v_add3_u32 v7, v7, v11, v12
		v_accvgpr_write_b32 a63, v7
		v_mov_b32_e32 v7, 0xff800000
		s_cmp_lt_i32 s46, s25
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_2
.L_attn_fwd_persistent.loop_head_2:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s19, s46, 0x80
		s_cmp_lt_i32 s46, 0
		s_cselect_b32 s36, s24, 0
		s_add_i32 s36, s46, s36
		s_ashr_i32 s36, s36, 7
		s_cmp_lt_i32 s36, 0
		s_cselect_b32 s39, s16, 0
		s_add_i32 s39, s36, s39
		s_ashr_i32 s39, s39, 1
		s_lshl_b32 s39, s39, 1
		s_xor_b32 s39, s39, -1
		s_add_i32 s39, s39, 1
		s_add_i32 s39, s36, s39
		s_add_i32 s36, s36, 1
		s_cmp_lt_i32 s36, 0
		s_cselect_b32 s41, s16, 0
		s_add_i32 s41, s36, s41
		s_ashr_i32 s41, s41, 1
		s_lshl_b32 s41, s41, 1
		s_xor_b32 s41, s41, -1
		s_add_i32 s41, s41, 1
		s_add_i32 s42, s36, s41
		s_mul_i32 s36, 0x4100, s39
		v_accvgpr_read_b32 v11, a18
		v_add_u32_e32 v11, s36, v11
		ds_read_b128 a[64:67], v11
		ds_read_b128 a[136:139], v11 offset:32
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
		s_mul_i32 s36, 0x4400, s39
		v_accvgpr_read_b32 v11, a63
		v_add_u32_e32 v11, s36, v11
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
		s_cmp_lt_i32 s19, s23
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_2
		v_accvgpr_read_b32 v11, a19
		v_add_u32_e32 v11, s19, v11
		v_cmp_lt_i32_e64 s[54:55], v11, s21
		v_accvgpr_read_b32 v11, a52
		v_add_u32_e32 v11, s19, v11
		v_cmp_lt_i32_e64 s[56:57], v11, s21
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s36, s15, s46
		s_lshl_b32 s36, s36, 1
		s_add_i32 s39, s47, s36
		v_add_u32_e32 v11, s39, v10
		v_cndmask_b32_e64 v11, v22, v11, s[54:55]
		s_mov_b32 s54, 1
		s_mov_b32 s55, 0
		s_mov_b32 s41, 0
		s_mul_i32 s58, s54, s40
		s_mul_hi_u32 s59, s54, s40
		s_mul_i32 s39, s54, s41
		s_add_i32 s59, s59, s39
		s_mul_i32 s39, s55, s40
		s_add_i32 s59, s59, s39
		s_lshr_b64 s[54:55], s[58:59], 6
		s_mov_b32 s58, 0x410
		s_mov_b32 s59, 0
		s_mul_i32 s60, s58, s54
		s_mul_hi_u32 s61, s58, s54
		s_mul_i32 s39, s58, s55
		s_add_i32 s61, s61, s39
		s_mul_i32 s39, s59, s54
		s_add_i32 s61, s61, s39
		s_cmp_lt_i32 s42, 0
		s_cselect_b32 s43, -1, 0
		s_mov_b32 s58, 0x4100
		s_mov_b32 s59, 0
		s_mul_i32 s62, s58, s42
		s_mul_hi_u32 s63, s58, s42
		s_mul_i32 s39, s58, s43
		s_add_i32 s63, s63, s39
		s_mul_i32 s39, s59, s42
		s_add_i32 s63, s63, s39
		s_add_u32 s58, s60, s62
		s_addc_u32 s59, s61, s63
		s_add_u32 s64, s58, 0
		s_addc_u32 s65, s59, 0
		s_mov_b32 m0, s64
		v_accvgpr_read_b32 v12, a56
		v_add_u32_e32 v12, s19, v12
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[58:59], v12, s21
		s_add_i32 s39, s48, s36
		v_add_u32_e32 v11, s39, v10
		v_cndmask_b32_e64 v11, v22, v11, s[58:59]
		s_add_u32 s58, s60, 0x1040
		s_addc_u32 s59, s61, 0
		s_add_u32 s58, s58, s62
		s_addc_u32 s59, s59, s63
		s_add_u32 s64, s58, 0
		s_addc_u32 s65, s59, 0
		s_mov_b32 m0, s64
		v_accvgpr_read_b32 v12, a57
		v_add_u32_e32 v12, s19, v12
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[58:59], v12, s21
		s_add_i32 s39, s49, s36
		v_add_u32_e32 v11, s39, v10
		v_cndmask_b32_e64 v11, v22, v11, s[58:59]
		s_add_u32 s58, s60, 0x2080
		s_addc_u32 s59, s61, 0
		s_add_u32 s58, s58, s62
		s_addc_u32 s59, s59, s63
		s_add_u32 s64, s58, 0
		s_addc_u32 s65, s59, 0
		s_mov_b32 m0, s64
		v_accvgpr_read_b32 v12, a58
		v_add_u32_e32 v12, s19, v12
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[58:59], v12, s21
		s_add_i32 s36, s37, s36
		v_add_u32_e32 v11, s36, v10
		v_cndmask_b32_e64 v11, v22, v11, s[58:59]
		s_add_u32 s58, s60, 0x30c0
		s_addc_u32 s59, s61, 0
		s_add_u32 s58, s58, s62
		s_addc_u32 s59, s59, s63
		s_add_u32 s60, s58, 0
		s_addc_u32 s61, s59, 0
		s_mov_b32 m0, s60
		v_accvgpr_read_b32 v12, a59
		v_add_u32_e32 v12, s19, v12
		buffer_load_dwordx4 v11, s[28:31], 0 offen lds
		s_mul_i32 s36, s17, s46
		s_lshl_b32 s36, s36, 1
		s_add_i32 s39, s50, s36
		v_add_u32_e32 v11, s39, v5
		v_cndmask_b32_e64 v11, v22, v11, s[56:57]
		s_mov_b32 s56, 0x440
		s_mov_b32 s57, 0
		s_mul_i32 s58, s56, s54
		s_mul_hi_u32 s59, s56, s54
		s_mul_i32 s39, s56, s55
		s_add_i32 s59, s59, s39
		s_mul_i32 s39, s57, s54
		s_add_i32 s59, s59, s39
		s_add_u32 s54, s58, 0x81f0
		s_addc_u32 s55, s59, 0
		s_mov_b32 s56, 0x4400
		s_mov_b32 s57, 0
		s_mul_i32 s60, s56, s42
		s_mul_hi_u32 s61, s56, s42
		s_mul_i32 s39, s56, s43
		s_add_i32 s61, s61, s39
		s_mul_i32 s39, s57, s42
		s_add_i32 s61, s61, s39
		s_add_u32 s42, s54, s60
		s_addc_u32 s43, s55, s61
		s_add_u32 s54, s42, 0
		s_addc_u32 s55, s43, 0
		s_mov_b32 m0, s54
		v_accvgpr_read_b32 v13, a60
		v_add_u32_e32 v13, s19, v13
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[42:43], v12, s21
		s_add_i32 s39, s51, s36
		v_add_u32_e32 v11, s39, v5
		v_cndmask_b32_e64 v11, v22, v11, s[42:43]
		s_add_u32 s42, s58, 0x92f0
		s_addc_u32 s43, s59, 0
		s_add_u32 s42, s42, s60
		s_addc_u32 s43, s43, s61
		s_add_u32 s54, s42, 0
		s_addc_u32 s55, s43, 0
		s_mov_b32 m0, s54
		v_accvgpr_read_b32 v12, a61
		v_add_u32_e32 v12, s19, v12
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[42:43], v13, s21
		s_add_i32 s19, s52, s36
		v_add_u32_e32 v11, s19, v5
		s_add_u32 s54, s58, 0xa3f0
		s_addc_u32 s55, s59, 0
		s_add_u32 s54, s54, s60
		s_addc_u32 s55, s55, s61
		s_add_u32 s56, s54, 0
		s_addc_u32 s57, s55, 0
		s_mov_b32 m0, s56
		v_cndmask_b32_e64 v11, v22, v11, s[42:43]
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		s_add_i32 s19, s38, s36
		v_cmp_lt_i32_e64 vcc, v12, s21
		v_add_u32_e32 v11, s19, v5
		s_add_u32 s42, s58, 0xb4f0
		s_addc_u32 s43, s59, 0
		v_cndmask_b32_e32 v11, v22, v11, vcc
		s_add_u32 s42, s42, s60
		s_addc_u32 s43, s43, s61
		s_add_u32 s54, s42, 0
		s_addc_u32 s55, s43, 0
		s_mov_b32 m0, s54
		s_nop 0
		buffer_load_dwordx4 v11, s[32:35], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_2
.L_attn_fwd_persistent.if_else_2:
.L_attn_fwd_persistent.if_end_2:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[96:111], a[64:67], a[20:23], 0
		v_add_u32_e32 v11, s46, v9
		v_mfma_f32_32x32x16_bf16 v[112:127], a[148:151], a[20:23], 0
		v_accvgpr_read_b32 v12, a11
		v_add_u32_e32 v12, s46, v12
		v_mfma_f32_32x32x16_bf16 v[128:143], a[164:167], a[20:23], 0
		v_accvgpr_read_b32 v13, a12
		v_add_u32_e32 v13, s46, v13
		v_mfma_f32_32x32x16_bf16 v[144:159], v[24:27], a[20:23], 0
		v_accvgpr_read_b32 v18, a62
		v_add_u32_e32 v18, s46, v18
		v_mfma_f32_32x32x16_bf16 v[160:175], v[24:27], a[36:39], 0
		v_accvgpr_read_b32 v19, a75
		v_add_u32_e32 v19, s46, v19
		v_mfma_f32_32x32x16_bf16 v[176:191], a[64:67], a[36:39], 0
		v_accvgpr_read_b32 v20, a76
		v_add_u32_e32 v20, s46, v20
		v_mfma_f32_32x32x16_bf16 v[192:207], a[148:151], a[36:39], 0
		v_accvgpr_read_b32 v21, a79
		v_add_u32_e32 v21, s46, v21
		v_mfma_f32_32x32x16_bf16 v[208:223], a[164:167], a[36:39], 0
		v_accvgpr_read_b32 v23, a80
		v_add_u32_e32 v23, s46, v23
		v_mfma_f32_32x32x16_bf16 v[96:111], a[136:139], a[24:27], v[96:111]
		v_accvgpr_read_b32 v24, a83
		v_add_u32_e32 v24, s46, v24
		v_mfma_f32_32x32x16_bf16 v[112:127], a[152:155], a[24:27], v[112:127]
		v_accvgpr_read_b32 v25, a84
		v_add_u32_e32 v25, s46, v25
		v_mfma_f32_32x32x16_bf16 v[128:143], a[168:171], a[24:27], v[128:143]
		v_accvgpr_read_b32 v26, a87
		v_add_u32_e32 v26, s46, v26
		v_mfma_f32_32x32x16_bf16 v[144:159], a[180:183], a[24:27], v[144:159]
		v_accvgpr_read_b32 v27, a88
		v_add_u32_e32 v27, s46, v27
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[40:43], v[160:175]
		v_accvgpr_read_b32 v28, a91
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a64, v28
		v_mfma_f32_32x32x16_bf16 v[176:191], a[136:139], a[40:43], v[176:191]
		v_accvgpr_read_b32 v28, a92
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a65, v28
		v_mfma_f32_32x32x16_bf16 v[192:207], a[152:155], a[40:43], v[192:207]
		v_accvgpr_read_b32 v28, a95
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a66, v28
		v_mfma_f32_32x32x16_bf16 v[208:223], a[168:171], a[40:43], v[208:223]
		v_accvgpr_read_b32 v28, a96
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a67, v28
		v_mfma_f32_32x32x16_bf16 v[96:111], a[140:143], a[28:31], v[96:111]
		v_accvgpr_read_b32 v28, a99
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a69, v28
		v_mfma_f32_32x32x16_bf16 v[112:127], a[156:159], a[28:31], v[112:127]
		v_accvgpr_read_b32 v28, a100
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a70, v28
		v_mfma_f32_32x32x16_bf16 v[128:143], a[172:175], a[28:31], v[128:143]
		v_accvgpr_read_b32 v28, a103
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a71, v28
		v_mfma_f32_32x32x16_bf16 v[144:159], a[184:187], a[28:31], v[144:159]
		v_accvgpr_read_b32 v28, a104
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a133, v28
		v_mfma_f32_32x32x16_bf16 v[160:175], a[184:187], a[44:47], v[160:175]
		v_accvgpr_read_b32 v28, a107
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a134, v28
		v_mfma_f32_32x32x16_bf16 v[176:191], a[140:143], a[44:47], v[176:191]
		v_accvgpr_read_b32 v28, a108
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a135, v28
		v_mfma_f32_32x32x16_bf16 v[192:207], a[156:159], a[44:47], v[192:207]
		v_accvgpr_read_b32 v28, a111
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a136, v28
		v_mfma_f32_32x32x16_bf16 v[208:223], a[172:175], a[44:47], v[208:223]
		v_accvgpr_read_b32 v28, a112
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a137, v28
		v_mfma_f32_32x32x16_bf16 v[96:111], a[144:147], a[32:35], v[96:111]
		v_accvgpr_read_b32 v28, a115
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a138, v28
		v_mfma_f32_32x32x16_bf16 v[112:127], a[160:163], a[32:35], v[112:127]
		v_accvgpr_read_b32 v28, a116
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a139, v28
		v_mfma_f32_32x32x16_bf16 v[128:143], a[176:179], a[32:35], v[128:143]
		v_accvgpr_read_b32 v28, a119
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a140, v28
		v_mfma_f32_32x32x16_bf16 v[144:159], a[188:191], a[32:35], v[144:159]
		v_accvgpr_read_b32 v28, a120
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a141, v28
		v_mfma_f32_32x32x16_bf16 v[160:175], a[188:191], a[48:51], v[160:175]
		v_accvgpr_read_b32 v28, a123
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a142, v28
		v_mfma_f32_32x32x16_bf16 v[176:191], a[144:147], a[48:51], v[176:191]
		v_accvgpr_read_b32 v28, a124
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a143, v28
		v_mfma_f32_32x32x16_bf16 v[192:207], a[160:163], a[48:51], v[192:207]
		v_accvgpr_read_b32 v28, a127
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a144, v28
		v_mfma_f32_32x32x16_bf16 v[208:223], a[176:179], a[48:51], v[208:223]
		v_accvgpr_read_b32 v28, a128
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a145, v28
		v_accvgpr_read_b32 v28, a131
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a146, v28
		v_accvgpr_read_b32 v28, a132
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_write_b32 a147, v28
		v_cmp_ge_i32_e64 s[42:43], v2, v11
		v_cmp_ge_i32_e64 s[54:55], v2, v12
		v_cmp_ge_i32_e64 s[56:57], v2, v13
		v_cmp_ge_i32_e64 vcc, v2, v18
		v_accvgpr_read_b32 v28, a68
		v_add_u32_e32 v28, s46, v28
		v_accvgpr_read_b32 v29, a74
		v_add_u32_e32 v29, s46, v29
		v_cndmask_b32_e32 v31, v7, v99, vcc
		v_cmp_ge_i32_e64 s[58:59], v2, v28
		v_cmp_ge_i32_e64 s[60:61], v2, v29
		v_cmp_ge_i32_e64 s[62:63], v2, v19
		v_cmp_ge_i32_e64 vcc, v2, v20
		v_accvgpr_read_b32 v30, a77
		v_add_u32_e32 v99, s46, v30
		v_accvgpr_read_b32 v30, a78
		v_add_u32_e32 v224, s46, v30
		v_cndmask_b32_e32 v227, v7, v103, vcc
		v_cmp_ge_i32_e64 s[64:65], v2, v99
		v_cmp_ge_i32_e64 s[66:67], v2, v224
		v_cmp_ge_i32_e64 s[68:69], v2, v21
		v_cmp_ge_i32_e64 vcc, v2, v23
		v_accvgpr_read_b32 v30, a81
		v_add_u32_e32 v103, s46, v30
		v_accvgpr_read_b32 v30, a82
		v_add_u32_e32 v225, s46, v30
		v_cndmask_b32_e32 v229, v7, v107, vcc
		v_cmp_ge_i32_e64 s[70:71], v2, v103
		v_cmp_ge_i32_e64 s[72:73], v2, v225
		v_cmp_ge_i32_e64 s[74:75], v2, v24
		v_cmp_ge_i32_e64 vcc, v2, v25
		v_accvgpr_read_b32 v30, a85
		v_add_u32_e32 v107, s46, v30
		v_accvgpr_read_b32 v30, a86
		v_add_u32_e32 v230, s46, v30
		v_cndmask_b32_e32 v233, v7, v111, vcc
		v_cmp_ge_i32_e64 s[76:77], v2, v107
		v_cmp_ge_i32_e64 s[78:79], v2, v230
		v_cmp_ge_i32_e64 s[80:81], v2, v26
		v_cmp_ge_i32_e64 vcc, v2, v27
		v_accvgpr_read_b32 v30, a89
		v_add_u32_e32 v111, s46, v30
		v_accvgpr_read_b32 v30, a90
		v_add_u32_e32 v231, s46, v30
		v_cndmask_b32_e32 v235, v7, v115, vcc
		v_cmp_ge_i32_e64 s[82:83], v2, v111
		v_cmp_ge_i32_e64 s[84:85], v2, v231
		v_accvgpr_read_b32 v30, a64
		v_cmp_ge_i32_e64 s[86:87], v2, v30
		s_nop 1
		v_mov_b32_e32 v236, s86
		v_mov_b32_e32 v237, s87
		v_accvgpr_read_b32 v30, a65
		v_cmp_ge_i32_e64 vcc, v2, v30
		s_mov_b64 s[86:87], vcc
		v_mov_b32_e32 v238, s86
		v_mov_b32_e32 v239, s87
		v_accvgpr_read_b32 v30, a93
		v_add_u32_e32 v30, s46, v30
		v_accvgpr_write_b32 a148, v30
		v_accvgpr_read_b32 v30, a94
		v_add_u32_e32 v30, s46, v30
		v_accvgpr_write_b32 a149, v30
		v_cndmask_b32_e32 v239, v7, v119, vcc
		v_accvgpr_read_b32 v30, a148
		v_cmp_ge_i32_e64 s[86:87], v2, v30
		s_nop 1
		v_mov_b32_e32 v240, s86
		v_mov_b32_e32 v241, s87
		v_accvgpr_write_b32 a150, v240
		v_accvgpr_write_b32 a151, v241
		v_accvgpr_read_b32 v30, a149
		v_cmp_ge_i32_e64 s[86:87], v2, v30
		s_nop 1
		v_mov_b32_e32 v240, s86
		v_mov_b32_e32 v241, s87
		v_accvgpr_write_b32 a152, v240
		v_accvgpr_write_b32 a153, v241
		v_accvgpr_read_b32 v30, a66
		v_cmp_ge_i32_e64 s[86:87], v2, v30
		s_nop 1
		v_mov_b32_e32 v240, s86
		v_mov_b32_e32 v241, s87
		v_accvgpr_write_b32 a154, v240
		v_accvgpr_write_b32 a155, v241
		v_accvgpr_read_b32 v30, a67
		v_cmp_ge_i32_e64 vcc, v2, v30
		v_accvgpr_read_b32 v30, a97
		v_add_u32_e32 v30, s46, v30
		v_accvgpr_write_b32 a156, v30
		v_accvgpr_read_b32 v30, a98
		v_add_u32_e32 v30, s46, v30
		v_accvgpr_write_b32 a157, v30
		v_cndmask_b32_e32 v241, v7, v123, vcc
		v_accvgpr_read_b32 v30, a156
		v_cmp_ge_i32_e64 s[86:87], v2, v30
		s_nop 1
		v_mov_b32_e32 v242, s86
		v_mov_b32_e32 v243, s87
		v_accvgpr_write_b32 a158, v242
		v_accvgpr_write_b32 a159, v243
		v_accvgpr_read_b32 v30, a157
		v_cmp_ge_i32_e64 s[86:87], v2, v30
		s_nop 1
		v_mov_b32_e32 v242, s86
		v_mov_b32_e32 v243, s87
		v_accvgpr_write_b32 a160, v242
		v_accvgpr_write_b32 a161, v243
		v_accvgpr_read_b32 v30, a69
		v_cmp_ge_i32_e64 s[86:87], v2, v30
		s_nop 1
		v_mov_b32_e32 v242, s86
		v_mov_b32_e32 v243, s87
		v_accvgpr_write_b32 a162, v242
		v_accvgpr_write_b32 a163, v243
		v_accvgpr_read_b32 v30, a70
		v_cmp_ge_i32_e64 vcc, v2, v30
		s_mov_b64 s[86:87], vcc
		v_mov_b32_e32 v242, s86
		v_mov_b32_e32 v243, s87
		v_accvgpr_read_b32 v30, a101
		v_add_u32_e32 v30, s46, v30
		v_accvgpr_write_b32 a164, v30
		v_accvgpr_read_b32 v30, a102
		v_add_u32_e32 v30, s46, v30
		v_accvgpr_write_b32 a165, v30
		v_cndmask_b32_e32 v243, v7, v127, vcc
		v_accvgpr_read_b32 v30, a164
		v_cmp_ge_i32_e64 s[86:87], v2, v30
		s_nop 1
		v_mov_b32_e32 v244, s86
		v_mov_b32_e32 v245, s87
		v_accvgpr_write_b32 a166, v244
		v_accvgpr_write_b32 a167, v245
		v_accvgpr_read_b32 v30, a165
		v_cmp_ge_i32_e64 s[86:87], v2, v30
		s_nop 1
		v_mov_b32_e32 v244, s86
		v_mov_b32_e32 v245, s87
		v_accvgpr_write_b32 a168, v244
		v_accvgpr_write_b32 a169, v245
		v_accvgpr_read_b32 v30, a71
		v_cmp_ge_i32_e64 s[86:87], v2, v30
		s_nop 1
		v_mov_b32_e32 v244, s86
		v_mov_b32_e32 v245, s87
		v_accvgpr_write_b32 a170, v244
		v_accvgpr_write_b32 a171, v245
		v_accvgpr_read_b32 v30, a133
		v_cmp_ge_i32_e64 vcc, v2, v30
		v_accvgpr_read_b32 v30, a105
		v_add_u32_e32 v30, s46, v30
		v_accvgpr_write_b32 a172, v30
		v_accvgpr_read_b32 v30, a106
		v_add_u32_e32 v30, s46, v30
		v_accvgpr_write_b32 a173, v30
		v_cndmask_b32_e32 v245, v7, v131, vcc
		v_accvgpr_read_b32 v30, a172
		v_cmp_ge_i32_e64 s[86:87], v2, v30
		s_nop 1
		v_mov_b32_e32 v246, s86
		v_mov_b32_e32 v247, s87
		v_accvgpr_write_b32 a174, v246
		v_accvgpr_write_b32 a175, v247
		v_accvgpr_read_b32 v30, a173
		v_cmp_ge_i32_e64 s[86:87], v2, v30
		s_nop 1
		v_mov_b32_e32 v246, s86
		v_mov_b32_e32 v247, s87
		v_accvgpr_write_b32 a176, v246
		v_accvgpr_write_b32 a177, v247
		v_accvgpr_read_b32 v30, a134
		v_cmp_ge_i32_e64 s[86:87], v2, v30
		s_nop 1
		v_mov_b32_e32 v246, s86
		v_mov_b32_e32 v247, s87
		v_accvgpr_write_b32 a178, v246
		v_accvgpr_write_b32 a179, v247
		v_accvgpr_read_b32 v30, a135
		v_cmp_ge_i32_e64 vcc, v2, v30
		s_mov_b64 s[86:87], vcc
		v_mov_b32_e32 v246, s86
		v_mov_b32_e32 v247, s87
		v_accvgpr_read_b32 v30, a109
		v_add_u32_e32 v30, s46, v30
		v_accvgpr_write_b32 a180, v30
		v_accvgpr_read_b32 v30, a110
		v_add_u32_e32 v30, s46, v30
		v_accvgpr_write_b32 a181, v30
		v_cndmask_b32_e32 v247, v7, v135, vcc
		v_accvgpr_read_b32 v30, a180
		v_cmp_ge_i32_e64 s[86:87], v2, v30
		s_nop 1
		v_mov_b32_e32 v248, s86
		v_mov_b32_e32 v249, s87
		v_accvgpr_write_b32 a182, v248
		v_accvgpr_write_b32 a183, v249
		v_accvgpr_read_b32 v30, a181
		v_cmp_ge_i32_e64 s[86:87], v2, v30
		s_nop 1
		v_mov_b32_e32 v248, s86
		v_mov_b32_e32 v249, s87
		v_accvgpr_write_b32 a184, v248
		v_accvgpr_write_b32 a185, v249
		v_accvgpr_read_b32 v30, a136
		v_cmp_ge_i32_e64 s[86:87], v2, v30
		s_nop 1
		v_mov_b32_e32 v248, s86
		v_mov_b32_e32 v249, s87
		v_accvgpr_write_b32 a186, v248
		v_accvgpr_write_b32 a187, v249
		v_accvgpr_read_b32 v30, a137
		v_cmp_ge_i32_e64 vcc, v2, v30
		v_accvgpr_read_b32 v30, a113
		v_add_u32_e32 v30, s46, v30
		v_accvgpr_write_b32 a188, v30
		v_accvgpr_read_b32 v30, a114
		v_add_u32_e32 v30, s46, v30
		v_accvgpr_write_b32 a189, v30
		v_cndmask_b32_e32 v249, v7, v139, vcc
		v_accvgpr_read_b32 v30, a188
		v_cmp_ge_i32_e64 s[86:87], v2, v30
		s_nop 1
		v_mov_b32_e32 v250, s86
		v_mov_b32_e32 v251, s87
		v_accvgpr_write_b32 a190, v250
		v_accvgpr_write_b32 a191, v251
		v_accvgpr_read_b32 v30, a189
		v_cmp_ge_i32_e64 s[86:87], v2, v30
		v_accvgpr_read_b32 v30, a138
		v_cmp_ge_i32_e64 s[88:89], v2, v30
		v_cndmask_b32_e64 v251, v7, v141, s[86:87]
		s_nop 0
		v_cndmask_b32_e64 v252, v7, v142, s[88:89]
		v_accvgpr_read_b32 v30, a139
		v_cmp_ge_i32_e64 vcc, v2, v30
		v_accvgpr_read_b32 v30, a117
		v_add_u32_e32 v115, s46, v30
		v_accvgpr_read_b32 v30, a118
		v_add_u32_e32 v119, s46, v30
		v_cndmask_b32_e32 v253, v7, v143, vcc
		v_cmp_ge_i32_e64 s[86:87], v2, v115
		v_cmp_ge_i32_e64 s[88:89], v2, v119
		v_accvgpr_read_b32 v30, a140
		v_cmp_ge_i32_e64 s[90:91], v2, v30
		v_cndmask_b32_e64 v142, v7, v144, s[86:87]
		v_cndmask_b32_e64 v143, v7, v145, s[88:89]
		v_cndmask_b32_e64 v144, v7, v146, s[90:91]
		v_accvgpr_read_b32 v30, a141
		v_cmp_ge_i32_e64 vcc, v2, v30
		v_accvgpr_read_b32 v30, a121
		v_add_u32_e32 v123, s46, v30
		v_accvgpr_read_b32 v30, a122
		v_add_u32_e32 v127, s46, v30
		v_cndmask_b32_e32 v145, v7, v147, vcc
		v_cmp_ge_i32_e64 s[86:87], v2, v123
		v_cmp_ge_i32_e64 s[88:89], v2, v127
		v_accvgpr_read_b32 v30, a142
		v_cmp_ge_i32_e64 s[90:91], v2, v30
		v_cndmask_b32_e64 v146, v7, v148, s[86:87]
		v_cndmask_b32_e64 v147, v7, v149, s[88:89]
		v_cndmask_b32_e64 v148, v7, v150, s[90:91]
		v_accvgpr_read_b32 v30, a143
		v_cmp_ge_i32_e64 vcc, v2, v30
		v_accvgpr_read_b32 v30, a125
		v_add_u32_e32 v131, s46, v30
		v_accvgpr_read_b32 v30, a126
		v_add_u32_e32 v135, s46, v30
		v_cndmask_b32_e32 v149, v7, v151, vcc
		v_cmp_ge_i32_e64 s[86:87], v2, v131
		v_cmp_ge_i32_e64 s[88:89], v2, v135
		v_accvgpr_read_b32 v30, a144
		v_cmp_ge_i32_e64 s[90:91], v2, v30
		v_cndmask_b32_e64 v150, v7, v152, s[86:87]
		v_cndmask_b32_e64 v151, v7, v153, s[88:89]
		v_cndmask_b32_e64 v152, v7, v154, s[90:91]
		v_accvgpr_read_b32 v30, a145
		v_cmp_ge_i32_e64 vcc, v2, v30
		v_accvgpr_read_b32 v30, a129
		v_add_u32_e32 v139, s46, v30
		v_accvgpr_read_b32 v30, a130
		v_add_u32_e32 v141, s46, v30
		v_cndmask_b32_e32 v153, v7, v155, vcc
		v_cmp_ge_i32_e64 s[86:87], v2, v139
		v_cmp_ge_i32_e64 s[88:89], v2, v141
		v_accvgpr_read_b32 v30, a146
		v_cmp_ge_i32_e64 s[90:91], v2, v30
		v_cndmask_b32_e64 v154, v7, v156, s[86:87]
		v_cndmask_b32_e64 v155, v7, v157, s[88:89]
		v_cndmask_b32_e64 v156, v7, v158, s[90:91]
		v_accvgpr_read_b32 v30, a147
		v_cmp_ge_i32_e64 vcc, v2, v30
		v_cndmask_b32_e64 v254, v7, v96, s[42:43]
		v_cndmask_b32_e64 v255, v7, v97, s[54:55]
		v_cndmask_b32_e32 v157, v7, v159, vcc
		v_cmp_ge_i32_e64 s[42:43], v6, v11
		v_cmp_ge_i32_e64 s[54:55], v6, v12
		v_cmp_ge_i32_e64 s[86:87], v6, v13
		s_nop 1
		v_cndmask_b32_e64 v12, v7, v178, s[86:87]
		v_cmp_ge_i32_e64 vcc, v6, v18
		v_cndmask_b32_e64 v30, v7, v98, s[56:57]
		v_cndmask_b32_e64 v96, v7, v100, s[58:59]
		v_cndmask_b32_e32 v13, v7, v179, vcc
		v_cmp_ge_i32_e64 s[56:57], v6, v28
		v_cmp_ge_i32_e64 s[58:59], v6, v29
		v_cmp_ge_i32_e64 s[86:87], v6, v19
		v_cndmask_b32_e64 v18, v7, v180, s[56:57]
		v_cndmask_b32_e64 v19, v7, v181, s[58:59]
		v_cndmask_b32_e64 v28, v7, v182, s[86:87]
		v_cmp_ge_i32_e64 vcc, v6, v20
		v_cndmask_b32_e64 v97, v7, v101, s[60:61]
		v_cndmask_b32_e64 v226, v7, v102, s[62:63]
		v_cndmask_b32_e32 v29, v7, v183, vcc
		v_cmp_ge_i32_e64 s[56:57], v6, v99
		v_cmp_ge_i32_e64 s[58:59], v6, v224
		v_cmp_ge_i32_e64 s[60:61], v6, v21
		v_cndmask_b32_e64 v20, v7, v184, s[56:57]
		v_cndmask_b32_e64 v21, v7, v185, s[58:59]
		v_cndmask_b32_e64 v98, v7, v186, s[60:61]
		v_cmp_ge_i32_e64 vcc, v6, v23
		v_cndmask_b32_e64 v100, v7, v104, s[64:65]
		v_cndmask_b32_e64 v101, v7, v105, s[66:67]
		v_cndmask_b32_e32 v99, v7, v187, vcc
		v_cmp_ge_i32_e64 s[56:57], v6, v103
		v_cmp_ge_i32_e64 s[58:59], v6, v225
		v_cmp_ge_i32_e64 s[60:61], v6, v24
		v_cndmask_b32_e64 v102, v7, v188, s[56:57]
		v_cndmask_b32_e64 v103, v7, v189, s[58:59]
		v_cndmask_b32_e64 v104, v7, v190, s[60:61]
		v_cmp_ge_i32_e64 vcc, v6, v25
		v_cndmask_b32_e64 v228, v7, v106, s[68:69]
		v_cndmask_b32_e64 v24, v7, v108, s[70:71]
		v_cndmask_b32_e32 v105, v7, v191, vcc
		v_cmp_ge_i32_e64 s[56:57], v6, v107
		v_cmp_ge_i32_e64 s[58:59], v6, v230
		v_cmp_ge_i32_e64 s[60:61], v6, v26
		v_cndmask_b32_e64 v106, v7, v192, s[56:57]
		v_cndmask_b32_e64 v107, v7, v193, s[58:59]
		v_cndmask_b32_e64 v158, v7, v194, s[60:61]
		v_cmp_ge_i32_e64 vcc, v6, v27
		v_cndmask_b32_e64 v25, v7, v109, s[72:73]
		v_cndmask_b32_e64 v232, v7, v110, s[74:75]
		v_cndmask_b32_e32 v159, v7, v195, vcc
		v_cmp_ge_i32_e64 s[56:57], v6, v111
		v_cmp_ge_i32_e64 s[58:59], v6, v231
		v_accvgpr_read_b32 v11, a64
		v_cmp_ge_i32_e64 s[60:61], v6, v11
		v_cndmask_b32_e64 v26, v7, v196, s[56:57]
		v_cndmask_b32_e64 v27, v7, v197, s[58:59]
		v_cndmask_b32_e64 v108, v7, v198, s[60:61]
		v_accvgpr_read_b32 v11, a65
		v_cmp_ge_i32_e64 vcc, v6, v11
		v_cndmask_b32_e64 v110, v7, v112, s[76:77]
		v_cndmask_b32_e64 v111, v7, v113, s[78:79]
		v_cndmask_b32_e32 v109, v7, v199, vcc
		v_accvgpr_read_b32 v11, a148
		v_cmp_ge_i32_e64 s[56:57], v6, v11
		v_accvgpr_read_b32 v11, a149
		v_cmp_ge_i32_e64 s[58:59], v6, v11
		v_accvgpr_read_b32 v11, a66
		v_cmp_ge_i32_e64 s[60:61], v6, v11
		v_cndmask_b32_e64 v112, v7, v200, s[56:57]
		v_cndmask_b32_e64 v113, v7, v201, s[58:59]
		v_cndmask_b32_e64 v178, v7, v202, s[60:61]
		v_accvgpr_read_b32 v11, a67
		v_cmp_ge_i32_e64 vcc, v6, v11
		v_cndmask_b32_e64 v234, v7, v114, s[80:81]
		v_cndmask_b32_e64 v180, v7, v116, s[82:83]
		v_cndmask_b32_e32 v179, v7, v203, vcc
		v_accvgpr_read_b32 v11, a156
		v_cmp_ge_i32_e64 s[56:57], v6, v11
		v_accvgpr_read_b32 v11, a157
		v_cmp_ge_i32_e64 s[58:59], v6, v11
		v_accvgpr_read_b32 v11, a69
		v_cmp_ge_i32_e64 s[60:61], v6, v11
		v_cndmask_b32_e64 v182, v7, v204, s[56:57]
		v_cndmask_b32_e64 v183, v7, v205, s[58:59]
		v_cndmask_b32_e64 v184, v7, v206, s[60:61]
		v_accvgpr_read_b32 v11, a70
		v_cmp_ge_i32_e64 vcc, v6, v11
		v_cndmask_b32_e64 v181, v7, v117, s[84:85]
		v_readfirstlane_b32 s56, v236
		v_readfirstlane_b32 s57, v237
		s_nop 1
		v_cndmask_b32_e64 v238, v7, v118, s[56:57]
		v_cndmask_b32_e32 v185, v7, v207, vcc
		v_accvgpr_read_b32 v11, a164
		v_cmp_ge_i32_e64 s[56:57], v6, v11
		v_accvgpr_read_b32 v11, a165
		v_cmp_ge_i32_e64 s[58:59], v6, v11
		v_accvgpr_read_b32 v11, a71
		v_cmp_ge_i32_e64 s[60:61], v6, v11
		v_cndmask_b32_e64 v116, v7, v208, s[56:57]
		v_cndmask_b32_e64 v117, v7, v209, s[58:59]
		v_cndmask_b32_e64 v186, v7, v210, s[60:61]
		v_accvgpr_read_b32 v11, a133
		v_cmp_ge_i32_e64 vcc, v6, v11
		v_accvgpr_read_b32 v11, a150
		s_nop 0
		v_readfirstlane_b32 s56, v11
		v_accvgpr_read_b32 v11, a151
		s_nop 0
		v_readfirstlane_b32 s57, v11
		s_nop 1
		v_cndmask_b32_e64 v188, v7, v120, s[56:57]
		v_accvgpr_read_b32 v11, a152
		s_nop 0
		v_readfirstlane_b32 s56, v11
		v_accvgpr_read_b32 v11, a153
		s_nop 0
		v_readfirstlane_b32 s57, v11
		s_nop 1
		v_cndmask_b32_e64 v189, v7, v121, s[56:57]
		v_cndmask_b32_e32 v187, v7, v211, vcc
		v_accvgpr_read_b32 v11, a172
		v_cmp_ge_i32_e64 s[56:57], v6, v11
		v_accvgpr_read_b32 v11, a173
		v_cmp_ge_i32_e64 s[58:59], v6, v11
		v_accvgpr_read_b32 v11, a134
		v_cmp_ge_i32_e64 s[60:61], v6, v11
		v_cndmask_b32_e64 v120, v7, v212, s[56:57]
		v_cndmask_b32_e64 v121, v7, v213, s[58:59]
		v_cndmask_b32_e64 v190, v7, v214, s[60:61]
		v_accvgpr_read_b32 v11, a135
		v_cmp_ge_i32_e64 vcc, v6, v11
		v_accvgpr_read_b32 v11, a154
		s_nop 0
		v_readfirstlane_b32 s56, v11
		v_accvgpr_read_b32 v11, a155
		s_nop 0
		v_readfirstlane_b32 s57, v11
		s_nop 1
		v_cndmask_b32_e64 v240, v7, v122, s[56:57]
		v_accvgpr_read_b32 v11, a158
		s_nop 0
		v_readfirstlane_b32 s56, v11
		v_accvgpr_read_b32 v11, a159
		s_nop 0
		v_readfirstlane_b32 s57, v11
		s_nop 1
		v_cndmask_b32_e64 v192, v7, v124, s[56:57]
		v_cndmask_b32_e32 v191, v7, v215, vcc
		v_accvgpr_read_b32 v11, a180
		v_cmp_ge_i32_e64 s[56:57], v6, v11
		v_accvgpr_read_b32 v11, a181
		v_cmp_ge_i32_e64 s[58:59], v6, v11
		v_accvgpr_read_b32 v11, a136
		v_cmp_ge_i32_e64 s[60:61], v6, v11
		v_cndmask_b32_e64 v194, v7, v216, s[56:57]
		v_cndmask_b32_e64 v195, v7, v217, s[58:59]
		v_cndmask_b32_e64 v196, v7, v218, s[60:61]
		v_accvgpr_read_b32 v11, a137
		v_cmp_ge_i32_e64 vcc, v6, v11
		v_accvgpr_read_b32 v11, a160
		s_nop 0
		v_readfirstlane_b32 s56, v11
		v_accvgpr_read_b32 v11, a161
		s_nop 0
		v_readfirstlane_b32 s57, v11
		s_nop 1
		v_cndmask_b32_e64 v193, v7, v125, s[56:57]
		v_accvgpr_read_b32 v11, a162
		s_nop 0
		v_readfirstlane_b32 s56, v11
		v_accvgpr_read_b32 v11, a163
		s_nop 0
		v_readfirstlane_b32 s57, v11
		s_nop 1
		v_cndmask_b32_e64 v242, v7, v126, s[56:57]
		v_cndmask_b32_e32 v197, v7, v219, vcc
		v_accvgpr_read_b32 v11, a188
		v_cmp_ge_i32_e64 s[56:57], v6, v11
		v_accvgpr_read_b32 v11, a189
		v_cmp_ge_i32_e64 s[58:59], v6, v11
		v_accvgpr_read_b32 v11, a138
		v_cmp_ge_i32_e64 s[60:61], v6, v11
		v_cndmask_b32_e64 v124, v7, v220, s[56:57]
		v_cndmask_b32_e64 v125, v7, v221, s[58:59]
		v_cndmask_b32_e64 v198, v7, v222, s[60:61]
		v_accvgpr_read_b32 v11, a139
		v_cmp_ge_i32_e64 vcc, v6, v11
		v_accvgpr_read_b32 v11, a166
		s_nop 0
		v_readfirstlane_b32 s56, v11
		v_accvgpr_read_b32 v11, a167
		s_nop 0
		v_readfirstlane_b32 s57, v11
		s_nop 1
		v_cndmask_b32_e64 v200, v7, v128, s[56:57]
		v_accvgpr_read_b32 v11, a168
		s_nop 0
		v_readfirstlane_b32 s56, v11
		v_accvgpr_read_b32 v11, a169
		s_nop 0
		v_readfirstlane_b32 s57, v11
		s_nop 1
		v_cndmask_b32_e64 v201, v7, v129, s[56:57]
		v_cndmask_b32_e32 v199, v7, v223, vcc
		v_cmp_ge_i32_e64 s[56:57], v6, v115
		v_cmp_ge_i32_e64 s[58:59], v6, v119
		v_accvgpr_read_b32 v11, a140
		v_cmp_ge_i32_e64 s[60:61], v6, v11
		v_cndmask_b32_e64 v114, v7, v160, s[56:57]
		v_cndmask_b32_e64 v115, v7, v161, s[58:59]
		v_cndmask_b32_e64 v118, v7, v162, s[60:61]
		v_accvgpr_read_b32 v11, a141
		v_cmp_ge_i32_e64 vcc, v6, v11
		v_accvgpr_read_b32 v11, a170
		s_nop 0
		v_readfirstlane_b32 s56, v11
		v_accvgpr_read_b32 v11, a171
		s_nop 0
		v_readfirstlane_b32 s57, v11
		s_nop 1
		v_cndmask_b32_e64 v244, v7, v130, s[56:57]
		v_accvgpr_read_b32 v11, a174
		s_nop 0
		v_readfirstlane_b32 s56, v11
		v_accvgpr_read_b32 v11, a175
		s_nop 0
		v_readfirstlane_b32 s57, v11
		s_nop 1
		v_cndmask_b32_e64 v128, v7, v132, s[56:57]
		v_cndmask_b32_e32 v119, v7, v163, vcc
		v_cmp_ge_i32_e64 s[56:57], v6, v123
		v_cmp_ge_i32_e64 s[58:59], v6, v127
		v_accvgpr_read_b32 v11, a142
		v_cmp_ge_i32_e64 s[60:61], v6, v11
		v_cndmask_b32_e64 v122, v7, v164, s[56:57]
		v_cndmask_b32_e64 v123, v7, v165, s[58:59]
		v_cndmask_b32_e64 v126, v7, v166, s[60:61]
		v_accvgpr_read_b32 v11, a143
		v_cmp_ge_i32_e64 vcc, v6, v11
		v_accvgpr_read_b32 v11, a176
		s_nop 0
		v_readfirstlane_b32 s56, v11
		v_accvgpr_read_b32 v11, a177
		s_nop 0
		v_readfirstlane_b32 s57, v11
		s_nop 1
		v_cndmask_b32_e64 v129, v7, v133, s[56:57]
		v_accvgpr_read_b32 v11, a178
		s_nop 0
		v_readfirstlane_b32 s56, v11
		v_accvgpr_read_b32 v11, a179
		s_nop 0
		v_readfirstlane_b32 s57, v11
		s_nop 1
		v_cndmask_b32_e64 v246, v7, v134, s[56:57]
		v_cndmask_b32_e32 v127, v7, v167, vcc
		v_cmp_ge_i32_e64 s[56:57], v6, v131
		v_cmp_ge_i32_e64 s[58:59], v6, v135
		v_accvgpr_read_b32 v11, a144
		v_cmp_ge_i32_e64 s[60:61], v6, v11
		v_cndmask_b32_e64 v130, v7, v168, s[56:57]
		v_cndmask_b32_e64 v131, v7, v169, s[58:59]
		v_cndmask_b32_e64 v132, v7, v170, s[60:61]
		v_accvgpr_read_b32 v11, a145
		v_cmp_ge_i32_e64 vcc, v6, v11
		v_accvgpr_read_b32 v11, a182
		s_nop 0
		v_readfirstlane_b32 s56, v11
		v_accvgpr_read_b32 v11, a183
		s_nop 0
		v_readfirstlane_b32 s57, v11
		s_nop 1
		v_cndmask_b32_e64 v134, v7, v136, s[56:57]
		v_accvgpr_read_b32 v11, a184
		s_nop 0
		v_readfirstlane_b32 s56, v11
		v_accvgpr_read_b32 v11, a185
		s_nop 0
		v_readfirstlane_b32 s57, v11
		s_nop 1
		v_cndmask_b32_e64 v135, v7, v137, s[56:57]
		v_cndmask_b32_e32 v133, v7, v171, vcc
		v_cmp_ge_i32_e64 s[56:57], v6, v139
		v_cmp_ge_i32_e64 s[58:59], v6, v141
		v_accvgpr_read_b32 v11, a146
		v_cmp_ge_i32_e64 s[60:61], v6, v11
		v_cndmask_b32_e64 v136, v7, v172, s[56:57]
		v_cndmask_b32_e64 v137, v7, v173, s[58:59]
		v_cndmask_b32_e64 v160, v7, v174, s[60:61]
		v_accvgpr_read_b32 v11, a147
		v_cmp_ge_i32_e64 vcc, v6, v11
		v_accvgpr_read_b32 v11, a186
		s_nop 0
		v_readfirstlane_b32 s56, v11
		v_accvgpr_read_b32 v11, a187
		s_nop 0
		v_readfirstlane_b32 s57, v11
		s_nop 1
		v_cndmask_b32_e64 v248, v7, v138, s[56:57]
		v_accvgpr_read_b32 v11, a190
		s_nop 0
		v_readfirstlane_b32 s56, v11
		v_accvgpr_read_b32 v11, a191
		s_nop 0
		v_readfirstlane_b32 s57, v11
		s_nop 1
		v_cndmask_b32_e64 v250, v7, v140, s[56:57]
		v_cndmask_b32_e32 v161, v7, v175, vcc
		v_max3_f32 v11, v254, v255, v30
		v_max3_f32 v23, v96, v97, v226
		v_max3_f32 v138, v100, v101, v228
		v_max3_f32 v139, v24, v25, v232
		v_max3_f32 v140, v110, v111, v234
		v_max3_f32 v141, v180, v181, v238
		v_max3_f32 v162, v188, v189, v240
		v_max3_f32 v163, v192, v193, v242
		v_max3_f32 v164, v200, v201, v244
		v_max3_f32 v165, v128, v129, v246
		v_max3_f32 v166, v134, v135, v248
		v_max3_f32 v167, v250, v251, v252
		v_max3_f32 v168, v142, v143, v144
		v_max3_f32 v169, v146, v147, v148
		v_max3_f32 v170, v150, v151, v152
		v_max3_f32 v171, v154, v155, v156
		v_max3_f32 v11, v11, v31, v23
		v_max3_f32 v23, v138, v229, v139
		v_max3_f32 v138, v140, v235, v141
		v_max3_f32 v139, v162, v241, v163
		v_max3_f32 v140, v164, v245, v165
		v_max3_f32 v141, v166, v249, v167
		v_max3_f32 v162, v168, v145, v169
		v_max3_f32 v163, v170, v153, v171
		v_max3_f32 v11, v11, v227, v23
		v_max3_f32 v23, v138, v239, v139
		v_max3_f32 v138, v140, v247, v141
		v_max3_f32 v139, v162, v149, v163
		v_max3_f32 v11, v11, v233, v23
		v_max3_f32 v23, v138, v253, v139
		v_max3_f32 v11, v11, v243, v23
		v_max_f32_e32 v138, v11, v157
		v_mov_b32_e32 v139, v138
		v_cndmask_b32_e64 v140, v7, v176, s[42:43]
		v_cndmask_b32_e64 v141, v7, v177, s[54:55]
		v_permlane32_swap_b32_e32 v138, v139
		v_max3_f32 v11, v140, v141, v12
		v_max3_f32 v23, v18, v19, v28
		v_max3_f32 v162, v20, v21, v98
		v_max3_f32 v163, v102, v103, v104
		v_max3_f32 v164, v106, v107, v158
		v_max3_f32 v165, v26, v27, v108
		v_max3_f32 v166, v112, v113, v178
		v_max3_f32 v167, v182, v183, v184
		v_max3_f32 v168, v116, v117, v186
		v_max3_f32 v169, v120, v121, v190
		v_max3_f32 v170, v194, v195, v196
		v_max3_f32 v171, v124, v125, v198
		v_max3_f32 v172, v114, v115, v118
		v_max3_f32 v173, v122, v123, v126
		v_max3_f32 v174, v130, v131, v132
		v_max3_f32 v175, v136, v137, v160
		v_max3_f32 v11, v11, v13, v23
		v_max3_f32 v23, v162, v99, v163
		v_max3_f32 v162, v164, v159, v165
		v_max3_f32 v163, v166, v179, v167
		v_max3_f32 v164, v168, v187, v169
		v_max3_f32 v165, v170, v197, v171
		v_max3_f32 v166, v172, v119, v173
		v_max3_f32 v167, v174, v133, v175
		v_max3_f32 v11, v11, v29, v23
		v_max3_f32 v23, v162, v109, v163
		v_max3_f32 v162, v164, v191, v165
		v_max3_f32 v163, v166, v127, v167
		v_max3_f32 v11, v11, v105, v23
		v_max3_f32 v23, v162, v199, v163
		v_max3_f32 v11, v11, v185, v23
		v_max_f32_e32 v162, v11, v161
		v_mov_b32_e32 v163, v162
		v_max_f32_e32 v164, v138, v139
		s_add_i32 s19, s46, 0x80
		s_cmp_lt_i32 s19, s25
		v_permlane32_swap_b32_e32 v162, v163
		v_max_f32_e32 v165, v162, v163
		v_pk_mul_f32 v[138:139], v[164:165], v[14:15]
		v_max_f32_e32 v162, v4, v138
		v_max_f32_e32 v163, v8, v139
		v_pk_fma_f32 v[138:139], v[254:255], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[30:31], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[96:97], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[226:227], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[100:101], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[228:229], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[24:25], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[232:233], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[110:111], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[234:235], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[180:181], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[238:239], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[188:189], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[240:241], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[192:193], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[242:243], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[200:201], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[244:245], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[128:129], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[246:247], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[134:135], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[248:249], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[250:251], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[252:253], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[142:143], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[144:145], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[146:147], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[148:149], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[150:151], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[154:155], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[156:157], v[14:15], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[140:141], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[12:13], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[12:13], v[18:19], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[18:19], v[28:29], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[20:21], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[20:21], v[98:99], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[102:103], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[104:105], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[106:107], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[158:159], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[26:27], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[108:109], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[112:113], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[178:179], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[182:183], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[184:185], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[116:117], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[186:187], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[120:121], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[190:191], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[194:195], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[196:197], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[124:125], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[198:199], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[114:115], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[118:119], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[122:123], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[126:127], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[130:131], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[132:133], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[136:137], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[160:161], v[14:15], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v160, v138
		v_exp_f32_e32 v214, v139
		v_exp_f32_e32 v138, v164
		v_exp_f32_e32 v216, v165
		v_exp_f32_e32 v164, v30
		v_exp_f32_e32 v218, v31
		v_exp_f32_e32 v30, v96
		v_exp_f32_e32 v220, v97
		v_exp_f32_e32 v96, v166
		v_exp_f32_e32 v222, v167
		v_exp_f32_e32 v166, v100
		v_exp_f32_e32 v224, v101
		v_exp_f32_e32 v100, v168
		v_exp_f32_e32 v226, v169
		v_exp_f32_e32 v168, v24
		v_exp_f32_e32 v228, v25
		v_exp_f32_e32 v24, v170
		v_exp_f32_e32 v230, v171
		v_exp_f32_e32 v170, v110
		v_exp_f32_e32 v232, v111
		v_exp_f32_e32 v110, v172
		v_exp_f32_e32 v234, v173
		v_exp_f32_e32 v172, v174
		v_exp_f32_e32 v236, v175
		v_exp_f32_e32 v174, v176
		v_exp_f32_e32 v238, v177
		v_exp_f32_e32 v176, v180
		v_exp_f32_e32 v240, v181
		v_exp_f32_e32 v180, v188
		v_exp_f32_e32 v242, v189
		v_exp_f32_e32 v188, v192
		v_exp_f32_e32 v244, v193
		v_exp_f32_e32 v161, v202
		v_exp_f32_e32 v215, v203
		v_exp_f32_e32 v139, v200
		v_exp_f32_e32 v217, v201
		v_exp_f32_e32 v165, v204
		v_exp_f32_e32 v219, v205
		v_exp_f32_e32 v31, v128
		v_exp_f32_e32 v221, v129
		v_exp_f32_e32 v97, v206
		v_exp_f32_e32 v223, v207
		v_exp_f32_e32 v167, v134
		v_exp_f32_e32 v225, v135
		v_exp_f32_e32 v101, v208
		v_exp_f32_e32 v227, v209
		v_exp_f32_e32 v169, v210
		v_exp_f32_e32 v229, v211
		v_exp_f32_e32 v25, v212
		v_exp_f32_e32 v231, v213
		v_exp_f32_e32 v171, v142
		v_exp_f32_e32 v233, v143
		v_exp_f32_e32 v111, v144
		v_exp_f32_e32 v235, v145
		v_exp_f32_e32 v173, v146
		v_exp_f32_e32 v237, v147
		v_exp_f32_e32 v175, v148
		v_exp_f32_e32 v239, v149
		v_exp_f32_e32 v177, v150
		v_exp_f32_e32 v241, v151
		v_exp_f32_e32 v181, v152
		v_exp_f32_e32 v243, v153
		v_exp_f32_e32 v189, v154
		v_exp_f32_e32 v245, v155
		v_exp_f32_e32 v128, v156
		v_exp_f32_e32 v134, v157
		v_exp_f32_e32 v142, v140
		v_exp_f32_e32 v144, v141
		v_exp_f32_e32 v140, v12
		v_exp_f32_e32 v146, v13
		v_exp_f32_e32 v12, v18
		v_exp_f32_e32 v148, v19
		v_exp_f32_e32 v18, v28
		v_exp_f32_e32 v150, v29
		v_exp_f32_e32 v28, v20
		v_exp_f32_e32 v152, v21
		v_exp_f32_e32 v20, v98
		v_exp_f32_e32 v154, v99
		v_exp_f32_e32 v98, v102
		v_exp_f32_e32 v156, v103
		v_exp_f32_e32 v102, v104
		v_exp_f32_e32 v192, v105
		v_exp_f32_e32 v104, v106
		v_exp_f32_e32 v200, v107
		v_exp_f32_e32 v106, v158
		v_exp_f32_e32 v202, v159
		v_exp_f32_e32 v158, v26
		v_exp_f32_e32 v204, v27
		v_exp_f32_e32 v26, v108
		v_exp_f32_e32 v206, v109
		v_exp_f32_e32 v108, v112
		v_exp_f32_e32 v208, v113
		v_exp_f32_e32 v112, v178
		v_exp_f32_e32 v210, v179
		v_exp_f32_e32 v178, v182
		v_exp_f32_e32 v212, v183
		v_exp_f32_e32 v129, v184
		v_exp_f32_e32 v135, v185
		v_exp_f32_e32 v143, v116
		v_exp_f32_e32 v145, v117
		v_exp_f32_e32 v141, v186
		v_exp_f32_e32 v147, v187
		v_exp_f32_e32 v13, v120
		v_exp_f32_e32 v149, v121
		v_exp_f32_e32 v19, v190
		v_exp_f32_e32 v151, v191
		v_exp_f32_e32 v29, v194
		v_exp_f32_e32 v153, v195
		v_exp_f32_e32 v21, v196
		v_exp_f32_e32 v155, v197
		v_exp_f32_e32 v99, v124
		v_exp_f32_e32 v157, v125
		v_exp_f32_e32 v103, v198
		v_exp_f32_e32 v193, v199
		v_exp_f32_e32 v105, v114
		v_exp_f32_e32 v201, v115
		v_exp_f32_e32 v107, v118
		v_exp_f32_e32 v203, v119
		v_exp_f32_e32 v159, v122
		v_exp_f32_e32 v205, v123
		v_exp_f32_e32 v27, v126
		v_exp_f32_e32 v207, v127
		v_exp_f32_e32 v109, v130
		v_exp_f32_e32 v209, v131
		v_exp_f32_e32 v113, v132
		v_exp_f32_e32 v211, v133
		v_exp_f32_e32 v179, v136
		v_exp_f32_e32 v213, v137
		v_pk_add_f32 v[114:115], v[160:161], v[214:215]
		v_pk_add_f32 v[116:117], v[138:139], v[216:217]
		v_pk_add_f32 v[118:119], v[164:165], v[218:219]
		v_pk_add_f32 v[120:121], v[30:31], v[220:221]
		v_pk_add_f32 v[122:123], v[96:97], v[222:223]
		v_pk_add_f32 v[124:125], v[166:167], v[224:225]
		v_pk_add_f32 v[126:127], v[100:101], v[226:227]
		v_pk_add_f32 v[130:131], v[168:169], v[228:229]
		v_pk_add_f32 v[132:133], v[24:25], v[230:231]
		v_pk_add_f32 v[136:137], v[170:171], v[232:233]
		v_pk_add_f32 v[182:183], v[110:111], v[234:235]
		v_pk_add_f32 v[184:185], v[172:173], v[236:237]
		v_pk_add_f32 v[186:187], v[174:175], v[238:239]
		v_pk_add_f32 v[190:191], v[176:177], v[240:241]
		v_pk_add_f32 v[194:195], v[180:181], v[242:243]
		v_pk_add_f32 v[196:197], v[188:189], v[244:245]
		v_pk_add_f32 v[114:115], v[114:115], v[116:117]
		v_pk_add_f32 v[116:117], v[118:119], v[120:121]
		v_pk_add_f32 v[118:119], v[122:123], v[124:125]
		v_pk_add_f32 v[120:121], v[126:127], v[130:131]
		v_pk_add_f32 v[122:123], v[132:133], v[136:137]
		v_pk_add_f32 v[124:125], v[182:183], v[184:185]
		v_pk_add_f32 v[126:127], v[186:187], v[190:191]
		v_pk_add_f32 v[130:131], v[194:195], v[196:197]
		v_pk_add_f32 v[114:115], v[114:115], v[116:117]
		v_pk_add_f32 v[116:117], v[118:119], v[120:121]
		v_pk_add_f32 v[118:119], v[122:123], v[124:125]
		v_pk_add_f32 v[120:121], v[126:127], v[130:131]
		v_pk_add_f32 v[114:115], v[114:115], v[116:117]
		v_pk_add_f32 v[116:117], v[118:119], v[120:121]
		v_pk_add_f32 v[118:119], v[114:115], v[116:117]
		v_add_f32_e32 v11, v118, v119
		v_accvgpr_read_b32 v23, a72
		ds_bpermute_b32 v114, v23, v11
		v_accvgpr_read_b32 v23, a73
		ds_bpermute_b32 v116, v23, v11
		v_pk_add_f32 v[118:119], v[128:129], v[134:135]
		v_pk_add_f32 v[120:121], v[142:143], v[144:145]
		v_pk_add_f32 v[122:123], v[140:141], v[146:147]
		v_pk_add_f32 v[124:125], v[12:13], v[148:149]
		v_pk_add_f32 v[126:127], v[18:19], v[150:151]
		v_pk_add_f32 v[130:131], v[28:29], v[152:153]
		v_pk_add_f32 v[132:133], v[20:21], v[154:155]
		v_pk_add_f32 v[136:137], v[98:99], v[156:157]
		v_pk_add_f32 v[182:183], v[102:103], v[192:193]
		v_pk_add_f32 v[184:185], v[104:105], v[200:201]
		v_pk_add_f32 v[186:187], v[106:107], v[202:203]
		v_pk_add_f32 v[190:191], v[158:159], v[204:205]
		v_pk_add_f32 v[194:195], v[26:27], v[206:207]
		v_pk_add_f32 v[196:197], v[108:109], v[208:209]
		v_pk_add_f32 v[198:199], v[112:113], v[210:211]
		v_pk_add_f32 v[246:247], v[178:179], v[212:213]
		v_pk_add_f32 v[118:119], v[118:119], v[120:121]
		v_pk_add_f32 v[120:121], v[122:123], v[124:125]
		v_pk_add_f32 v[122:123], v[126:127], v[130:131]
		v_pk_add_f32 v[124:125], v[132:133], v[136:137]
		v_pk_add_f32 v[126:127], v[182:183], v[184:185]
		v_pk_add_f32 v[130:131], v[186:187], v[190:191]
		v_pk_add_f32 v[132:133], v[194:195], v[196:197]
		v_pk_add_f32 v[136:137], v[198:199], v[246:247]
		v_pk_add_f32 v[118:119], v[118:119], v[120:121]
		v_pk_add_f32 v[120:121], v[122:123], v[124:125]
		v_pk_add_f32 v[122:123], v[126:127], v[130:131]
		v_pk_add_f32 v[124:125], v[132:133], v[136:137]
		v_pk_add_f32 v[118:119], v[118:119], v[120:121]
		v_pk_add_f32 v[120:121], v[122:123], v[124:125]
		v_pk_add_f32 v[122:123], v[118:119], v[120:121]
		v_mov_b32_e32 v117, v123
		v_mov_b32_e32 v115, v122
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[118:119], v[114:115], v[116:117]
		v_mov_b32_e32 v114, v119
		v_mov_b32_e32 v115, v119
		v_cvt_pk_bf16_f32 v120, v160, v214
		v_cvt_pk_bf16_f32 v121, v138, v216
		v_permlane32_swap_b32_e32 v114, v115
		v_add_f32_e32 v117, v114, v115
		v_mov_b32_e32 v114, v4
		v_mov_b32_e32 v115, v8
		v_pk_add_f32 v[122:123], v[114:115], v[162:163] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v114, v122
		v_exp_f32_e32 v115, v123
		v_cvt_pk_bf16_f32 v122, v164, v218
		v_pk_mul_f32 v[32:33], v[32:33], v[114:115] op_sel_hi:[1,0]
		v_pk_mul_f32 v[34:35], v[34:35], v[114:115] op_sel_hi:[1,0]
		v_pk_mul_f32 v[36:37], v[36:37], v[114:115] op_sel_hi:[1,0]
		v_pk_mul_f32 v[38:39], v[38:39], v[114:115] op_sel_hi:[1,0]
		v_pk_mul_f32 v[40:41], v[40:41], v[114:115] op_sel_hi:[1,0]
		v_pk_mul_f32 v[42:43], v[42:43], v[114:115] op_sel_hi:[1,0]
		v_pk_mul_f32 v[44:45], v[44:45], v[114:115] op_sel_hi:[1,0]
		v_pk_mul_f32 v[46:47], v[46:47], v[114:115] op_sel_hi:[1,0]
		v_pk_mul_f32 v[48:49], v[48:49], v[114:115] op_sel_hi:[1,0]
		v_pk_mul_f32 v[50:51], v[50:51], v[114:115] op_sel_hi:[1,0]
		v_pk_mul_f32 v[52:53], v[52:53], v[114:115] op_sel_hi:[1,0]
		v_pk_mul_f32 v[54:55], v[54:55], v[114:115] op_sel_hi:[1,0]
		v_pk_mul_f32 v[56:57], v[56:57], v[114:115] op_sel_hi:[1,0]
		v_pk_mul_f32 v[58:59], v[58:59], v[114:115] op_sel_hi:[1,0]
		v_pk_mul_f32 v[60:61], v[60:61], v[114:115] op_sel_hi:[1,0]
		v_pk_mul_f32 v[62:63], v[62:63], v[114:115] op_sel_hi:[1,0]
		v_pk_mul_f32 v[64:65], v[64:65], v[114:115] op_sel:[0,1]
		v_pk_mul_f32 v[66:67], v[66:67], v[114:115] op_sel:[0,1]
		v_pk_mul_f32 v[68:69], v[68:69], v[114:115] op_sel:[0,1]
		v_pk_mul_f32 v[70:71], v[70:71], v[114:115] op_sel:[0,1]
		v_pk_mul_f32 v[72:73], v[72:73], v[114:115] op_sel:[0,1]
		v_pk_mul_f32 v[74:75], v[74:75], v[114:115] op_sel:[0,1]
		v_pk_mul_f32 v[76:77], v[76:77], v[114:115] op_sel:[0,1]
		v_pk_mul_f32 v[78:79], v[78:79], v[114:115] op_sel:[0,1]
		v_pk_mul_f32 v[80:81], v[80:81], v[114:115] op_sel:[0,1]
		v_pk_mul_f32 v[82:83], v[82:83], v[114:115] op_sel:[0,1]
		v_pk_mul_f32 v[84:85], v[84:85], v[114:115] op_sel:[0,1]
		v_pk_mul_f32 v[86:87], v[86:87], v[114:115] op_sel:[0,1]
		v_pk_mul_f32 v[88:89], v[88:89], v[114:115] op_sel:[0,1]
		v_pk_mul_f32 v[90:91], v[90:91], v[114:115] op_sel:[0,1]
		v_pk_mul_f32 v[92:93], v[92:93], v[114:115] op_sel:[0,1]
		v_pk_mul_f32 v[94:95], v[94:95], v[114:115] op_sel:[0,1]
		v_mov_b32_e32 v116, v118
		v_mov_b64_e32 v[118:119], v[16:17]
		v_pk_fma_f32 v[16:17], v[118:119], v[114:115], v[116:117]
		v_cvt_pk_bf16_f32 v123, v30, v220
		v_cvt_pk_bf16_f32 v116, v96, v222
		v_cvt_pk_bf16_f32 v117, v166, v224
		v_cvt_pk_bf16_f32 v118, v100, v226
		v_cvt_pk_bf16_f32 v119, v168, v228
		v_cvt_pk_bf16_f32 v124, v24, v230
		v_cvt_pk_bf16_f32 v125, v170, v232
		v_cvt_pk_bf16_f32 v126, v110, v234
		v_cvt_pk_bf16_f32 v127, v172, v236
		v_cvt_pk_bf16_f32 v184, v174, v238
		v_cvt_pk_bf16_f32 v185, v176, v240
		v_cvt_pk_bf16_f32 v186, v180, v242
		v_cvt_pk_bf16_f32 v187, v188, v244
		v_cvt_pk_bf16_f32 v196, v161, v215
		v_cvt_pk_bf16_f32 v197, v139, v217
		v_cvt_pk_bf16_f32 v198, v165, v219
		v_cvt_pk_bf16_f32 v199, v31, v221
		v_cvt_pk_bf16_f32 v136, v97, v223
		v_cvt_pk_bf16_f32 v137, v167, v225
		v_cvt_pk_bf16_f32 v138, v101, v227
		v_cvt_pk_bf16_f32 v139, v169, v229
		v_cvt_pk_bf16_f32 v164, v25, v231
		v_cvt_pk_bf16_f32 v165, v171, v233
		v_cvt_pk_bf16_f32 v166, v111, v235
		v_cvt_pk_bf16_f32 v167, v173, v237
		v_cvt_pk_bf16_f32 v168, v175, v239
		v_cvt_pk_bf16_f32 v169, v177, v241
		v_cvt_pk_bf16_f32 v170, v181, v243
		v_cvt_pk_bf16_f32 v171, v189, v245
		v_cvt_pk_bf16_f32 v172, v128, v134
		v_cvt_pk_bf16_f32 v173, v142, v144
		v_cvt_pk_bf16_f32 v174, v140, v146
		v_cvt_pk_bf16_f32 v175, v12, v148
		v_cvt_pk_bf16_f32 v180, v18, v150
		v_cvt_pk_bf16_f32 v181, v28, v152
		v_cvt_pk_bf16_f32 v182, v20, v154
		v_cvt_pk_bf16_f32 v183, v98, v156
		v_cvt_pk_bf16_f32 v188, v102, v192
		v_cvt_pk_bf16_f32 v189, v104, v200
		v_cvt_pk_bf16_f32 v190, v106, v202
		v_cvt_pk_bf16_f32 v191, v158, v204
		v_cvt_pk_bf16_f32 v216, v26, v206
		v_cvt_pk_bf16_f32 v217, v108, v208
		v_cvt_pk_bf16_f32 v218, v112, v210
		v_cvt_pk_bf16_f32 v219, v178, v212
		v_cvt_pk_bf16_f32 v220, v129, v135
		v_cvt_pk_bf16_f32 v221, v143, v145
		v_cvt_pk_bf16_f32 v222, v141, v147
		v_cvt_pk_bf16_f32 v223, v13, v149
		v_cvt_pk_bf16_f32 v128, v19, v151
		v_cvt_pk_bf16_f32 v129, v29, v153
		v_cvt_pk_bf16_f32 v130, v21, v155
		v_cvt_pk_bf16_f32 v131, v99, v157
		v_cvt_pk_bf16_f32 v28, v103, v193
		v_cvt_pk_bf16_f32 v29, v105, v201
		v_cvt_pk_bf16_f32 v30, v107, v203
		v_cvt_pk_bf16_f32 v31, v159, v205
		v_cvt_pk_bf16_f32 v96, v27, v207
		v_cvt_pk_bf16_f32 v97, v109, v209
		v_cvt_pk_bf16_f32 v98, v113, v211
		v_cvt_pk_bf16_f32 v99, v179, v213
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		v_permlane32_swap_b32_e32 v168, v170
		v_permlane32_swap_b32_e32 v169, v171
		v_permlane32_swap_b32_e32 v172, v174
		v_permlane32_swap_b32_e32 v173, v175
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		v_permlane32_swap_b32_e32 v188, v190
		v_permlane32_swap_b32_e32 v189, v191
		v_permlane32_swap_b32_e32 v216, v218
		v_permlane32_swap_b32_e32 v217, v219
		v_permlane32_swap_b32_e32 v220, v222
		v_permlane32_swap_b32_e32 v221, v223
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[120:123], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[120:123], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[172:175], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[172:175], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[116:119], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[116:119], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[180:183], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[180:183], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[124:127], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[124:127], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[188:191], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[188:191], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[184:187], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[184:187], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[216:219], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[216:219], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[196:199], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[196:199], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[220:223], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[220:223], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[136:139], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[136:139], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[128:131], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[128:131], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[216:219], v[164:167], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[248:251], v[164:167], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[248:251], v[28:31], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[216:219], v[28:31], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[220:223], v[168:171], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[252:255], v[168:171], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[252:255], v[96:99], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[220:223], v[96:99], v[64:79]
		s_mov_b32 s46, s19
		v_mov_b32_e32 v4, v162
		v_mov_b32_e32 v8, v163
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_2
.L_attn_fwd_persistent.loop_exit_2:
		s_mov_b32 s28, s8
		s_mov_b32 s29, s9
		s_mov_b32 s30, s26
		s_mov_b32 s31, s27
		v_rcp_f32_e32 v4, v16
		v_rcp_f32_e32 v6, v17
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
		v_accvgpr_read_b32 v2, a9
		s_nop 0
		v_readfirstlane_b32 s19, v2
		s_mul_i32 s19, s19, s18
		s_lshl_b32 s19, s19, 9
		v_accvgpr_read_b32 v2, a2
		s_nop 0
		v_readfirstlane_b32 s23, v2
		v_mov_b32_e32 v2, s1
		s_nop 0
		v_readfirstlane_b32 s24, v2
		s_mul_i32 s23, s24, s23
		s_lshl_b32 s23, s23, 1
		s_add_i32 s24, s19, s23
		v_accvgpr_read_b32 v2, a3
		s_nop 0
		v_readfirstlane_b32 s25, v2
		v_readfirstlane_b32 s26, v3
		s_mul_i32 s25, s26, s25
		s_lshl_b32 s25, s25, 1
		s_add_i32 s24, s24, s25
		v_accvgpr_read_b32 v2, a10
		v_mul_lo_u32 v2, s18, v2
		v_lshl_add_u32 v32, v2, 6, s24
		v_accvgpr_read_b32 v33, a13
		v_mul_lo_u32 v33, s18, v33
		v_lshl_add_u32 v32, v33, 1, v32
		v_accvgpr_read_b32 v34, a17
		v_mul_lo_u32 v34, s18, v34
		v_lshl_add_u32 v32, v34, 5, v32
		v_accvgpr_read_b32 v35, a53
		v_mul_lo_u32 v35, s18, v35
		v_lshl_add_u32 v32, v35, 4, v32
		v_accvgpr_read_b32 v36, a14
		v_mul_lo_u32 v36, s18, v36
		v_lshl_add_u32 v32, v36, 3, v32
		v_accvgpr_read_b32 v37, a15
		v_mul_lo_u32 v37, s18, v37
		v_lshl_add_u32 v32, v37, 2, v32
		v_accvgpr_read_b32 v38, a16
		v_lshl_add_u32 v32, v38, 4, v32
		v_mov_b32_e32 v38, s44
		v_mov_b32_e32 v39, s45
		s_nop 0
		v_readfirstlane_b32 s26, v38
		v_readfirstlane_b32 s27, v39
		s_and_saveexec_b64 s[92:93], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_8
		buffer_store_dwordx4 v[72:75], v32, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_8:
		s_andn2_b64 exec, s[92:93], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_8
.L_attn_fwd_persistent.exec_endif_8:
		s_mov_b64 exec, s[92:93]
		s_add_i32 s24, s19, 32
		s_add_i32 s24, s24, s23
		s_add_i32 s24, s24, s25
		v_lshl_add_u32 v32, v2, 6, s24
		v_lshl_add_u32 v32, v33, 1, v32
		v_lshl_add_u32 v32, v34, 5, v32
		v_lshl_add_u32 v32, v35, 4, v32
		v_lshl_add_u32 v32, v36, 3, v32
		v_lshl_add_u32 v32, v37, 2, v32
		v_accvgpr_read_b32 v40, a16
		v_lshl_add_u32 v32, v40, 4, v32
		v_readfirstlane_b32 s26, v38
		v_readfirstlane_b32 s27, v39
		s_and_saveexec_b64 s[92:93], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_9
		buffer_store_dwordx4 v[8:11], v32, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_9:
		s_andn2_b64 exec, s[92:93], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_9
.L_attn_fwd_persistent.exec_endif_9:
		s_mov_b64 exec, s[92:93]
		s_add_i32 s24, s19, 64
		s_add_i32 s24, s24, s23
		s_add_i32 s24, s24, s25
		v_lshl_add_u32 v8, v2, 6, s24
		v_lshl_add_u32 v8, v33, 1, v8
		v_lshl_add_u32 v8, v34, 5, v8
		v_lshl_add_u32 v8, v35, 4, v8
		v_lshl_add_u32 v8, v36, 3, v8
		v_lshl_add_u32 v8, v37, 2, v8
		v_accvgpr_read_b32 v9, a16
		v_lshl_add_u32 v8, v9, 4, v8
		v_readfirstlane_b32 s26, v38
		v_readfirstlane_b32 s27, v39
		s_and_saveexec_b64 s[92:93], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_10
		buffer_store_dwordx4 v[12:15], v8, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_10:
		s_andn2_b64 exec, s[92:93], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_10
.L_attn_fwd_persistent.exec_endif_10:
		s_mov_b64 exec, s[92:93]
		s_add_i32 s24, s19, 0x60
		s_add_i32 s24, s24, s23
		s_add_i32 s24, s24, s25
		v_lshl_add_u32 v8, v2, 6, s24
		v_lshl_add_u32 v8, v33, 1, v8
		v_lshl_add_u32 v8, v34, 5, v8
		v_lshl_add_u32 v8, v35, 4, v8
		v_lshl_add_u32 v8, v36, 3, v8
		v_lshl_add_u32 v8, v37, 2, v8
		v_accvgpr_read_b32 v9, a16
		v_lshl_add_u32 v8, v9, 4, v8
		v_readfirstlane_b32 s26, v38
		v_readfirstlane_b32 s27, v39
		s_and_saveexec_b64 s[92:93], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_11
		buffer_store_dwordx4 v[16:19], v8, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_11:
		s_andn2_b64 exec, s[92:93], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_11
.L_attn_fwd_persistent.exec_endif_11:
		s_mov_b64 exec, s[92:93]
		s_lshl_b32 s24, s18, 8
		s_add_i32 s26, s24, s19
		s_add_i32 s26, s26, s23
		s_add_i32 s26, s26, s25
		v_lshl_add_u32 v8, v2, 6, s26
		v_lshl_add_u32 v8, v33, 1, v8
		v_lshl_add_u32 v8, v34, 5, v8
		v_lshl_add_u32 v8, v35, 4, v8
		v_lshl_add_u32 v8, v36, 3, v8
		v_lshl_add_u32 v8, v37, 2, v8
		v_accvgpr_read_b32 v9, a16
		v_lshl_add_u32 v8, v9, 4, v8
		v_accvgpr_read_b32 v9, a54
		s_nop 0
		v_readfirstlane_b32 s26, v9
		v_accvgpr_read_b32 v9, a55
		s_nop 0
		v_readfirstlane_b32 s27, v9
		s_and_saveexec_b64 s[92:93], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_12
		buffer_store_dwordx4 v[20:23], v8, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_12:
		s_andn2_b64 exec, s[92:93], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_12
.L_attn_fwd_persistent.exec_endif_12:
		s_mov_b64 exec, s[92:93]
		s_add_i32 s26, s24, 32
		s_add_i32 s26, s26, s19
		s_add_i32 s26, s26, s23
		s_add_i32 s26, s26, s25
		v_lshl_add_u32 v8, v2, 6, s26
		v_lshl_add_u32 v8, v33, 1, v8
		v_lshl_add_u32 v8, v34, 5, v8
		v_lshl_add_u32 v8, v35, 4, v8
		v_lshl_add_u32 v8, v36, 3, v8
		v_lshl_add_u32 v8, v37, 2, v8
		v_accvgpr_read_b32 v9, a16
		v_lshl_add_u32 v8, v9, 4, v8
		v_accvgpr_read_b32 v9, a54
		s_nop 0
		v_readfirstlane_b32 s26, v9
		v_accvgpr_read_b32 v9, a55
		s_nop 0
		v_readfirstlane_b32 s27, v9
		s_and_saveexec_b64 s[92:93], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_13
		buffer_store_dwordx4 v[4:7], v8, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_13:
		s_andn2_b64 exec, s[92:93], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_13
.L_attn_fwd_persistent.exec_endif_13:
		s_mov_b64 exec, s[92:93]
		s_add_i32 s26, s24, 64
		s_add_i32 s26, s26, s19
		s_add_i32 s26, s26, s23
		s_add_i32 s26, s26, s25
		v_lshl_add_u32 v4, v2, 6, s26
		v_lshl_add_u32 v4, v33, 1, v4
		v_lshl_add_u32 v4, v34, 5, v4
		v_lshl_add_u32 v4, v35, 4, v4
		v_lshl_add_u32 v4, v36, 3, v4
		v_lshl_add_u32 v4, v37, 2, v4
		v_accvgpr_read_b32 v5, a16
		v_lshl_add_u32 v4, v5, 4, v4
		v_accvgpr_read_b32 v5, a54
		s_nop 0
		v_readfirstlane_b32 s26, v5
		v_accvgpr_read_b32 v5, a55
		s_nop 0
		v_readfirstlane_b32 s27, v5
		s_and_saveexec_b64 s[92:93], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_14
		buffer_store_dwordx4 v[24:27], v4, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_14:
		s_andn2_b64 exec, s[92:93], s[26:27]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_14
.L_attn_fwd_persistent.exec_endif_14:
		s_mov_b64 exec, s[92:93]
		s_add_i32 s24, s24, 0x60
		s_add_i32 s19, s24, s19
		s_add_i32 s19, s19, s23
		s_add_i32 s19, s19, s25
		v_lshl_add_u32 v2, v2, 6, s19
		v_lshl_add_u32 v2, v33, 1, v2
		v_lshl_add_u32 v2, v34, 5, v2
		v_lshl_add_u32 v2, v35, 4, v2
		v_lshl_add_u32 v2, v36, 3, v2
		v_lshl_add_u32 v2, v37, 2, v2
		v_accvgpr_read_b32 v4, a16
		v_lshl_add_u32 v2, v4, 4, v2
		v_accvgpr_read_b32 v4, a54
		s_nop 0
		v_readfirstlane_b32 s24, v4
		v_accvgpr_read_b32 v4, a55
		s_nop 0
		v_readfirstlane_b32 s25, v4
		s_and_saveexec_b64 s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_15
		buffer_store_dwordx4 v[28:31], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_15:
		s_andn2_b64 exec, s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_15
.L_attn_fwd_persistent.exec_endif_15:
		s_mov_b64 exec, s[92:93]
		s_branch .L_attn_fwd_persistent.if_end_1
.L_attn_fwd_persistent.if_else_1:
.L_attn_fwd_persistent.if_end_1:
		s_and_b32 s19, s0, 15
		s_mul_i32 s19, s19, 2
		s_add_i32 s19, s19, 1
		s_cmp_lt_i32 s19, 32
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_3
		s_lshr_b32 s23, s19, 1
		s_and_b32 s19, s19, 1
		s_xor_b32 s24, s23, -1
		s_add_i32 s24, s24, 1
		s_add_i32 s24, s24, 31
		s_cmp_eq_u32 s19, 0
		s_cselect_b32 s19, s23, s24
		v_mov_b32_e32 v2, s19
		v_accvgpr_write_b32 a9, v2
		v_accvgpr_read_b32 v2, a9
		s_nop 0
		v_readfirstlane_b32 s19, v2
		s_mul_i32 s19, s19, 0x100
		v_and_b32_e32 v2, 1, v0
		v_lshrrev_b32_e32 v4, 1, v0
		v_and_b32_e32 v5, 1, v4
		v_mov_b32_e32 v6, 2
		v_mul_lo_u32 v6, v6, v5
		v_lshrrev_b32_e32 v5, 2, v0
		v_and_b32_e32 v7, 1, v5
		v_mov_b32_e32 v8, 4
		v_mul_lo_u32 v8, v8, v7
		v_bitop3_b32 v7, v2, v6, v8 bitop3:0x96
		v_lshrrev_b32_e32 v9, 3, v0
		v_and_b32_e32 v10, 1, v9
		v_mov_b32_e32 v11, 8
		v_mul_lo_u32 v11, v11, v10
		v_xor_b32_e32 v7, v7, v11
		v_lshrrev_b32_e32 v12, 4, v0
		v_and_b32_e32 v13, 1, v12
		v_mov_b32_e32 v14, 16
		v_mul_lo_u32 v14, v14, v13
		v_lshrrev_b32_e32 v15, 6, v0
		v_accvgpr_write_b32 a10, v15
		v_accvgpr_read_b32 v15, a10
		v_and_b32_e32 v15, 1, v15
		v_mov_b32_e32 v16, 32
		v_mul_lo_u32 v16, v16, v15
		v_bitop3_b32 v7, v7, v14, v16 bitop3:0x96
		v_lshrrev_b32_e32 v17, 7, v0
		v_and_b32_e32 v17, 1, v17
		v_mov_b32_e32 v18, 64
		v_mul_lo_u32 v18, v18, v17
		v_xor_b32_e32 v7, v7, v18
		v_accvgpr_write_b32 a11, v7
		v_xor_b32_e32 v2, 0x80, v2
		v_xor_b32_e32 v2, v2, v6
		v_xor_b32_e32 v2, v2, v8
		v_bitop3_b32 v2, v2, v11, v14 bitop3:0x96
		v_bitop3_b32 v2, v2, v16, v18 bitop3:0x96
		v_accvgpr_write_b32 a12, v2
		v_mov_b32_e32 v2, 2
		v_mul_lo_u32 v2, v2, v13
		v_lshrrev_b32_e32 v6, 5, v0
		v_and_b32_e32 v7, 1, v6
		v_mov_b32_e32 v8, 4
		v_mul_lo_u32 v8, v8, v7
		v_bitop3_b32 v11, v10, v2, v8 bitop3:0x96
		v_mov_b32_e32 v14, 8
		v_mul_lo_u32 v14, v14, v15
		v_xor_b32_e32 v11, v11, v14
		v_mov_b32_e32 v16, 16
		v_mul_lo_u32 v16, v16, v17
		v_xad_u32 v11, v11, v16, s19
		v_bitop3_b32 v18, 32, v10, v2 bitop3:0x96
		v_bitop3_b32 v18, v18, v8, v14 bitop3:0x96
		v_xad_u32 v18, v18, v16, s19
		v_bitop3_b32 v19, 64, v10, v2 bitop3:0x96
		v_bitop3_b32 v19, v19, v8, v14 bitop3:0x96
		v_xad_u32 v19, v19, v16, s19
		v_xor_b32_e32 v20, 0x60, v10
		v_xor_b32_e32 v20, v20, v2
		v_xor_b32_e32 v20, v20, v8
		v_xor_b32_e32 v20, v20, v14
		v_xad_u32 v20, v20, v16, s19
		v_xor_b32_e32 v21, 0x80, v10
		v_xor_b32_e32 v21, v21, v2
		v_xor_b32_e32 v21, v21, v8
		v_xor_b32_e32 v21, v21, v14
		v_xad_u32 v21, v21, v16, s19
		v_xor_b32_e32 v22, 0xa0, v10
		v_xor_b32_e32 v22, v22, v2
		v_xor_b32_e32 v22, v22, v8
		v_xor_b32_e32 v22, v22, v14
		v_xad_u32 v22, v22, v16, s19
		v_xor_b32_e32 v23, 0xc0, v10
		v_xor_b32_e32 v23, v23, v2
		v_xor_b32_e32 v23, v23, v8
		v_xor_b32_e32 v23, v23, v14
		v_xad_u32 v23, v23, v16, s19
		v_xor_b32_e32 v24, 0xe0, v10
		v_xor_b32_e32 v2, v24, v2
		v_xor_b32_e32 v2, v2, v8
		v_xor_b32_e32 v2, v2, v14
		v_xad_u32 v2, v2, v16, s19
		s_mov_b32 s26, 0x7fffffff
		s_mov_b32 s27, 0x31016000
		s_mov_b32 s24, s2
		s_mov_b32 s25, s3
		v_accvgpr_read_b32 v14, a5
		v_and_b32_e32 v14, 0xffff, v14
		v_lshlrev_b32_e32 v16, 16, v14
		v_or_b32_e32 v24, v14, v16
		v_mov_b32_e32 v25, v24
		v_mov_b32_e32 v26, v24
		v_mov_b32_e32 v27, v24
		v_accvgpr_read_b32 v14, a9
		s_nop 0
		v_readfirstlane_b32 s23, v14
		s_mul_i32 s23, s23, s12
		s_lshl_b32 s23, s23, 9
		v_mov_b32_e32 v14, s1
		v_accvgpr_write_b32 a13, v14
		v_accvgpr_read_b32 v14, a13
		s_nop 0
		v_readfirstlane_b32 s1, v14
		s_mul_i32 s1, s1, s10
		s_lshl_b32 s1, s1, 1
		s_add_i32 s28, s23, s1
		v_readfirstlane_b32 s29, v3
		s_mul_i32 s29, s29, s11
		s_lshl_b32 s29, s29, 1
		s_add_i32 s28, s28, s29
		v_mul_lo_u32 v14, s12, v9
		v_lshl_add_u32 v16, v14, 1, s28
		v_and_b32_e32 v28, 1, v0
		v_accvgpr_write_b32 a14, v28
		v_accvgpr_read_b32 v28, a14
		v_lshl_add_u32 v16, v28, 4, v16
		v_and_b32_e32 v28, 1, v5
		v_accvgpr_write_b32 a15, v28
		v_accvgpr_read_b32 v28, a15
		v_lshl_add_u32 v16, v28, 6, v16
		v_and_b32_e32 v4, 1, v4
		v_accvgpr_write_b32 a16, v4
		v_accvgpr_read_b32 v4, a16
		v_lshl_add_u32 v4, v4, 5, v16
		v_cmp_lt_i32_e64 vcc, v11, s20
		s_and_saveexec_b64 s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_16
		buffer_load_dwordx4 v[28:31], v4, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_16:
		s_andn2_b64 exec, s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_16
		v_mov_b32_e32 v28, v24
		v_mov_b32_e32 v29, v25
		v_mov_b32_e32 v30, v26
		v_mov_b32_e32 v31, v27
.L_attn_fwd_persistent.exec_endif_16:
		s_mov_b64 exec, s[92:93]
		s_lshl_b32 s28, s12, 6
		s_add_i32 s28, s28, s23
		s_add_i32 s28, s28, s1
		s_add_i32 s28, s28, s29
		v_lshl_add_u32 v4, v14, 1, s28
		v_accvgpr_read_b32 v11, a14
		v_lshl_add_u32 v4, v11, 4, v4
		v_accvgpr_read_b32 v11, a15
		v_lshl_add_u32 v4, v11, 6, v4
		v_accvgpr_read_b32 v11, a16
		v_lshl_add_u32 v4, v11, 5, v4
		v_cmp_lt_i32_e64 vcc, v18, s20
		s_and_saveexec_b64 s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_17
		buffer_load_dwordx4 v[32:35], v4, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_17:
		s_andn2_b64 exec, s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_17
		v_mov_b32_e32 v32, v24
		v_mov_b32_e32 v33, v25
		v_mov_b32_e32 v34, v26
		v_mov_b32_e32 v35, v27
.L_attn_fwd_persistent.exec_endif_17:
		s_mov_b64 exec, s[92:93]
		s_lshl_b32 s28, s12, 7
		s_add_i32 s28, s28, s23
		s_add_i32 s28, s28, s1
		s_add_i32 s28, s28, s29
		v_lshl_add_u32 v4, v14, 1, s28
		v_accvgpr_read_b32 v11, a14
		v_lshl_add_u32 v4, v11, 4, v4
		v_accvgpr_read_b32 v11, a15
		v_lshl_add_u32 v4, v11, 6, v4
		v_accvgpr_read_b32 v11, a16
		v_lshl_add_u32 v4, v11, 5, v4
		v_cmp_lt_i32_e64 vcc, v19, s20
		s_and_saveexec_b64 s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_18
		buffer_load_dwordx4 v[36:39], v4, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_18:
		s_andn2_b64 exec, s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_18
		v_mov_b32_e32 v36, v24
		v_mov_b32_e32 v37, v25
		v_mov_b32_e32 v38, v26
		v_mov_b32_e32 v39, v27
.L_attn_fwd_persistent.exec_endif_18:
		s_mov_b64 exec, s[92:93]
		s_mul_i32 s28, 0xc0, s12
		s_add_i32 s28, s28, s23
		s_add_i32 s28, s28, s1
		s_add_i32 s28, s28, s29
		v_lshl_add_u32 v4, v14, 1, s28
		v_accvgpr_read_b32 v11, a14
		v_lshl_add_u32 v4, v11, 4, v4
		v_accvgpr_read_b32 v11, a15
		v_lshl_add_u32 v4, v11, 6, v4
		v_accvgpr_read_b32 v11, a16
		v_lshl_add_u32 v4, v11, 5, v4
		v_cmp_lt_i32_e64 vcc, v20, s20
		s_and_saveexec_b64 s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_19
		buffer_load_dwordx4 v[40:43], v4, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_19:
		s_andn2_b64 exec, s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_19
		v_mov_b32_e32 v40, v24
		v_mov_b32_e32 v41, v25
		v_mov_b32_e32 v42, v26
		v_mov_b32_e32 v43, v27
.L_attn_fwd_persistent.exec_endif_19:
		s_mov_b64 exec, s[92:93]
		s_lshl_b32 s28, s12, 8
		s_add_i32 s28, s28, s23
		s_add_i32 s28, s28, s1
		s_add_i32 s28, s28, s29
		v_lshl_add_u32 v4, v14, 1, s28
		v_accvgpr_read_b32 v11, a14
		v_lshl_add_u32 v4, v11, 4, v4
		v_accvgpr_read_b32 v11, a15
		v_lshl_add_u32 v4, v11, 6, v4
		v_accvgpr_read_b32 v11, a16
		v_lshl_add_u32 v4, v11, 5, v4
		v_cmp_lt_i32_e64 vcc, v21, s20
		s_and_saveexec_b64 s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_20
		buffer_load_dwordx4 v[44:47], v4, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_20:
		s_andn2_b64 exec, s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_20
		v_mov_b32_e32 v44, v24
		v_mov_b32_e32 v45, v25
		v_mov_b32_e32 v46, v26
		v_mov_b32_e32 v47, v27
.L_attn_fwd_persistent.exec_endif_20:
		s_mov_b64 exec, s[92:93]
		s_mul_i32 s28, 0x140, s12
		s_add_i32 s28, s28, s23
		s_add_i32 s28, s28, s1
		s_add_i32 s28, s28, s29
		v_lshl_add_u32 v4, v14, 1, s28
		v_accvgpr_read_b32 v11, a14
		v_lshl_add_u32 v4, v11, 4, v4
		v_accvgpr_read_b32 v11, a15
		v_lshl_add_u32 v4, v11, 6, v4
		v_accvgpr_read_b32 v11, a16
		v_lshl_add_u32 v4, v11, 5, v4
		v_cmp_lt_i32_e64 vcc, v22, s20
		s_and_saveexec_b64 s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_21
		buffer_load_dwordx4 v[48:51], v4, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_21:
		s_andn2_b64 exec, s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_21
		v_mov_b32_e32 v48, v24
		v_mov_b32_e32 v49, v25
		v_mov_b32_e32 v50, v26
		v_mov_b32_e32 v51, v27
.L_attn_fwd_persistent.exec_endif_21:
		s_mov_b64 exec, s[92:93]
		s_mul_i32 s28, 0x180, s12
		s_add_i32 s28, s28, s23
		s_add_i32 s28, s28, s1
		s_add_i32 s28, s28, s29
		v_lshl_add_u32 v4, v14, 1, s28
		v_accvgpr_read_b32 v11, a14
		v_lshl_add_u32 v4, v11, 4, v4
		v_accvgpr_read_b32 v11, a15
		v_lshl_add_u32 v4, v11, 6, v4
		v_accvgpr_read_b32 v11, a16
		v_lshl_add_u32 v4, v11, 5, v4
		v_cmp_lt_i32_e64 vcc, v23, s20
		s_and_saveexec_b64 s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_22
		buffer_load_dwordx4 v[20:23], v4, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_22:
		s_andn2_b64 exec, s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_22
		v_mov_b32_e32 v20, v24
		v_mov_b32_e32 v21, v25
		v_mov_b32_e32 v22, v26
		v_mov_b32_e32 v23, v27
.L_attn_fwd_persistent.exec_endif_22:
		s_mov_b64 exec, s[92:93]
		s_mul_i32 s28, 0x1c0, s12
		s_add_i32 s23, s28, s23
		s_add_i32 s1, s23, s1
		s_add_i32 s1, s1, s29
		v_lshl_add_u32 v4, v14, 1, s1
		v_accvgpr_read_b32 v11, a14
		v_lshl_add_u32 v4, v11, 4, v4
		v_accvgpr_read_b32 v11, a15
		v_lshl_add_u32 v4, v11, 6, v4
		v_accvgpr_read_b32 v11, a16
		v_lshl_add_u32 v4, v11, 5, v4
		v_cmp_lt_i32_e64 vcc, v2, s20
		s_and_saveexec_b64 s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_23
		buffer_load_dwordx4 v[52:55], v4, s[24:27], 0 offen
.L_attn_fwd_persistent.exec_else_23:
		s_andn2_b64 exec, s[92:93], vcc
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_23
		v_mov_b32_e32 v52, v24
		v_mov_b32_e32 v53, v25
		v_mov_b32_e32 v54, v26
		v_mov_b32_e32 v55, v27
.L_attn_fwd_persistent.exec_endif_23:
		s_mov_b64 exec, s[92:93]
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
		v_and_b32_e32 v2, 1, v6
		v_accvgpr_write_b32 a17, v2
		v_accvgpr_read_b32 v2, a17
		v_lshlrev_b32_e32 v2, 1, v2
		v_accvgpr_read_b32 v4, a10
		v_and_b32_e32 v4, 1, v4
		v_lshlrev_b32_e32 v4, 2, v4
		v_and_b32_e32 v6, 1, v12
		v_accvgpr_write_b32 a18, v6
		v_accvgpr_read_b32 v6, a18
		v_xor_b32_e32 v4, v4, v6
		v_bitop3_b32 v2, v0, v2, v4 bitop3:0x96
		v_lshlrev_b32_e32 v2, 4, v2
		v_add_u32_e32 v2, 0x10000, v2
		ds_write_b128 v2, v[28:31] offset:18864
		ds_write_b128 v2, v[32:35] offset:22960
		ds_write_b128 v2, v[36:39] offset:27056
		ds_write_b128 v2, v[40:43] offset:31152
		v_accvgpr_read_b32 v4, a10
		v_lshlrev_b32_e32 v4, 12, v4
		v_add_u32_e32 v4, 0x10000, v4
		v_and_b32_e32 v6, 63, v0
		v_lshrrev_b32_e32 v11, 5, v6
		v_accvgpr_write_b32 a19, v11
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_lshrrev_b32_e32 v11, 4, v6
		v_and_b32_e32 v11, 1, v11
		v_lshlrev_b32_e32 v11, 7, v11
		v_accvgpr_read_b32 v12, a19
		v_add_u32_e32 v12, v12, v11
		v_lshrrev_b32_e32 v14, 3, v6
		v_and_b32_e32 v14, 1, v14
		v_lshlrev_b32_e32 v16, 6, v14
		v_lshrrev_b32_e32 v18, 2, v6
		v_and_b32_e32 v18, 1, v18
		v_lshlrev_b32_e32 v19, 5, v18
		v_add3_u32 v12, v12, v16, v19
		v_lshrrev_b32_e32 v24, 1, v6
		v_and_b32_e32 v24, 1, v24
		v_lshlrev_b32_e32 v25, 4, v24
		v_and_b32_e32 v26, 1, v6
		v_lshlrev_b32_e32 v26, 3, v26
		v_add3_u32 v12, v12, v25, v26
		v_lshlrev_b32_e32 v18, 1, v18
		v_lshlrev_b32_e32 v14, 2, v14
		v_bitop3_b32 v14, v18, v14, v24 bitop3:0x96
		v_xor_b32_e32 v12, v12, v14
		v_lshl_add_u32 v12, v12, 4, v4
		ds_read_b128 a[20:23], v12 offset:18864
		v_accvgpr_read_b32 v18, a19
		v_add3_u32 v11, v18, v11, v16
		v_add3_u32 v11, v11, v19, v25
		v_add3_u32 v16, v26, v11, 2
		v_xor_b32_e32 v16, v16, v14
		v_lshl_add_u32 v16, v16, 4, v4
		ds_read_b128 a[24:27], v16 offset:18864
		v_add3_u32 v18, v26, v11, 4
		v_xor_b32_e32 v18, v18, v14
		v_lshl_add_u32 v18, v18, 4, v4
		ds_read_b128 a[28:31], v18 offset:18864
		v_add3_u32 v11, v26, v11, 6
		v_xor_b32_e32 v11, v11, v14
		v_lshl_add_u32 v4, v11, 4, v4
		ds_read_b128 a[32:35], v4 offset:18864
		v_accvgpr_read_b32 v11, a9
		s_nop 0
		v_readfirstlane_b32 s1, v11
		s_add_i32 s1, s1, 1
		s_mul_i32 s1, s1, 0x100
		s_mov_b32 s23, 0x7f
		v_mov_b32_e32 v11, 64
		v_mul_lo_u32 v11, v11, v10
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_write_b128 v2, v[44:47] offset:18864
		ds_write_b128 v2, v[48:51] offset:22960
		ds_write_b128 v2, v[20:23] offset:27056
		ds_write_b128 v2, v[52:55] offset:31152
		v_mov_b32_e32 v2, 32
		v_mul_lo_u32 v2, v2, v13
		v_mov_b32_e32 v13, 16
		v_mul_lo_u32 v13, v13, v7
		s_waitcnt lgkmcnt(0)
		s_barrier
		ds_read_b128 a[36:39], v12 offset:18864
		ds_read_b128 a[40:43], v16 offset:18864
		ds_read_b128 a[44:47], v18 offset:18864
		ds_read_b128 a[48:51], v4 offset:18864
		v_accvgpr_write_b32 a52, v1
		v_accvgpr_read_b32 v4, a52
		s_nop 0
		v_readfirstlane_b32 s24, v4
		s_add_i32 s1, s1, s24
		s_cmp_lt_i32 s21, s1
		s_cselect_b32 s1, s21, s1
		s_add_i32 s24, s1, 0x7f
		s_cmp_lt_i32 s24, 0
		s_cselect_b32 s25, s23, 0
		s_add_i32 s24, s24, s25
		s_ashr_i32 s24, s24, 7
		v_accvgpr_read_b32 v4, a52
		s_nop 0
		v_readfirstlane_b32 s25, v4
		s_add_i32 s25, s19, s25
		s_cmp_lt_i32 s25, 0
		s_cselect_b32 s36, s23, 0
		s_add_i32 s25, s25, s36
		s_ashr_i32 s25, s25, 7
		s_cmp_lt_i32 s25, s24
		s_cselect_b32 s25, s25, s24
		s_cmp_gt_i32 s25, 0
		s_cselect_b32 s25, s25, 0
		v_bitop3_b32 v4, v11, v2, v13 bitop3:0x96
		v_mov_b32_e32 v12, 2
		v_mul_lo_u32 v12, v12, v17
		v_bitop3_b32 v4, v4, v15, v12 bitop3:0x96
		v_accvgpr_write_b32 a53, v4
		v_bitop3_b32 v4, 4, v11, v2 bitop3:0x96
		v_bitop3_b32 v14, 8, v11, v2 bitop3:0x96
		v_bitop3_b32 v11, 12, v11, v2 bitop3:0x96
		v_accvgpr_read_b32 v16, a53
		v_cmp_lt_i32_e64 s[36:37], v16, s21
		v_mov_b32_e32 v16, 16
		v_mul_lo_u32 v16, v16, v10
		v_mov_b32_e32 v10, 64
		v_mul_lo_u32 v10, v10, v7
		v_bitop3_b32 v7, v16, v2, v10 bitop3:0x96
		v_bitop3_b32 v7, v7, v15, v12 bitop3:0x96
		v_accvgpr_write_b32 a54, v7
		v_bitop3_b32 v7, 4, v16, v2 bitop3:0x96
		v_bitop3_b32 v17, 8, v16, v2 bitop3:0x96
		v_bitop3_b32 v2, 12, v16, v2 bitop3:0x96
		v_accvgpr_read_b32 v16, a54
		v_cmp_lt_i32_e64 vcc, v16, s21
		v_readfirstlane_b32 s38, v0
		v_accvgpr_read_b32 v16, a10
		v_mul_lo_u32 v16, s15, v16
		v_accvgpr_read_b32 v18, a17
		v_mul_lo_u32 v18, s15, v18
		v_lshlrev_b32_e32 v18, 5, v18
		v_lshl_add_u32 v16, v16, 1, v18
		v_accvgpr_read_b32 v18, a18
		v_mul_lo_u32 v18, s15, v18
		v_lshl_add_u32 v16, v18, 6, v16
		v_and_b32_e32 v9, 1, v9
		v_accvgpr_write_b32 a55, v9
		v_accvgpr_read_b32 v9, a55
		v_mul_lo_u32 v9, s15, v9
		v_lshlrev_b32_e32 v9, 7, v9
		v_accvgpr_read_b32 v18, a14
		v_lshlrev_b32_e32 v18, 4, v18
		v_add3_u32 v9, v16, v9, v18
		v_accvgpr_read_b32 v16, a15
		v_lshlrev_b32_e32 v16, 6, v16
		v_accvgpr_read_b32 v19, a16
		v_lshlrev_b32_e32 v19, 5, v19
		v_add3_u32 v9, v9, v16, v19
		v_accvgpr_read_b32 v20, a13
		s_nop 0
		v_readfirstlane_b32 s39, v20
		s_mul_i32 s39, s39, s13
		s_lshl_b32 s39, s39, 1
		v_readfirstlane_b32 s40, v3
		s_mul_i32 s40, s40, s14
		s_lshl_b32 s40, s40, 1
		s_add_i32 s41, s39, s40
		v_add_u32_e32 v20, s41, v9
		v_mov_b32_e32 v21, 0x80000000
		v_cndmask_b32_e64 v20, v21, v20, s[36:37]
		s_lshr_b32 s41, s38, 6
		s_mul_i32 s42, 0x410, s41
		s_mov_b32 m0, s42
		v_accvgpr_read_b32 v22, a11
		v_add_u32_e32 v22, s19, v22
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[44:45], v22, s20
		s_lshl_b32 s43, s15, 3
		s_add_i32 s43, s43, s39
		s_add_i32 s43, s43, s40
		v_add_u32_e32 v20, s43, v9
		v_cndmask_b32_e64 v20, v21, v20, s[36:37]
		s_add_i32 m0, m0, 0x1040
		v_accvgpr_read_b32 v22, a12
		v_add_u32_e32 v22, s19, v22
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[46:47], v22, s20
		s_nop 1
		v_mov_b32_e32 v22, s46
		v_mov_b32_e32 v23, s47
		s_lshl_b32 s43, s15, 4
		s_add_i32 s43, s43, s39
		s_add_i32 s43, s43, s40
		v_add_u32_e32 v20, s43, v9
		v_cndmask_b32_e64 v20, v21, v20, s[36:37]
		s_add_i32 m0, m0, 0x1040
		v_xor_b32_e32 v4, v4, v13
		buffer_load_dwordx4 v20, s[28:31], 0 offen lds
		v_bitop3_b32 v4, v4, v15, v12 bitop3:0x96
		v_accvgpr_write_b32 a56, v4
		s_mul_i32 s43, 24, s15
		s_add_i32 s43, s43, s39
		s_add_i32 s43, s43, s40
		v_add_u32_e32 v4, s43, v9
		v_cndmask_b32_e64 v4, v21, v4, s[36:37]
		s_add_i32 m0, m0, 0x1040
		v_xor_b32_e32 v14, v14, v13
		buffer_load_dwordx4 v4, s[28:31], 0 offen lds
		v_bitop3_b32 v4, v14, v15, v12 bitop3:0x96
		v_accvgpr_write_b32 a57, v4
		v_accvgpr_read_b32 v4, a10
		v_mul_lo_u32 v4, s17, v4
		v_accvgpr_read_b32 v14, a17
		v_mul_lo_u32 v14, s17, v14
		v_lshlrev_b32_e32 v14, 7, v14
		v_lshl_add_u32 v4, v4, 1, v14
		v_accvgpr_read_b32 v14, a18
		v_mul_lo_u32 v14, s17, v14
		v_lshl_add_u32 v4, v14, 6, v4
		v_accvgpr_read_b32 v14, a55
		v_mul_lo_u32 v14, s17, v14
		v_lshlrev_b32_e32 v14, 5, v14
		v_add3_u32 v4, v4, v14, v18
		v_add3_u32 v4, v4, v16, v19
		v_accvgpr_read_b32 v14, a0
		s_nop 0
		v_readfirstlane_b32 s36, v14
		v_accvgpr_read_b32 v14, a13
		s_nop 0
		v_readfirstlane_b32 s37, v14
		s_mul_i32 s36, s37, s36
		s_lshl_b32 s36, s36, 1
		v_accvgpr_read_b32 v14, a1
		s_nop 0
		v_readfirstlane_b32 s37, v14
		v_readfirstlane_b32 s43, v3
		s_mul_i32 s37, s43, s37
		s_lshl_b32 s37, s37, 1
		s_add_i32 s43, s36, s37
		v_add_u32_e32 v3, s43, v4
		v_cndmask_b32_e32 v3, v21, v3, vcc
		s_mul_i32 s41, 0x440, s41
		s_add_i32 m0, s41, 0x81f0
		v_xor_b32_e32 v11, v11, v13
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
		v_bitop3_b32 v3, v11, v15, v12 bitop3:0x96
		v_accvgpr_write_b32 a58, v3
		s_lshl_b32 s43, s17, 3
		s_add_i32 s43, s43, s36
		s_add_i32 s43, s43, s37
		v_add_u32_e32 v3, s43, v4
		v_cndmask_b32_e32 v3, v21, v3, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v7, v7, v10
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
		v_bitop3_b32 v3, v7, v15, v12 bitop3:0x96
		v_accvgpr_write_b32 a59, v3
		s_lshl_b32 s43, s17, 4
		s_add_i32 s43, s43, s36
		s_add_i32 s43, s43, s37
		v_add_u32_e32 v3, s43, v4
		v_cndmask_b32_e32 v3, v21, v3, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v7, v17, v10
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
		v_bitop3_b32 v3, v7, v15, v12 bitop3:0x96
		v_accvgpr_write_b32 a60, v3
		s_mul_i32 s43, 24, s17
		s_add_i32 s43, s43, s36
		s_add_i32 s43, s43, s37
		v_add_u32_e32 v3, s43, v4
		v_cndmask_b32_e32 v3, v21, v3, vcc
		s_add_i32 m0, m0, 0x1100
		v_xor_b32_e32 v2, v2, v10
		buffer_load_dwordx4 v3, s[32:35], 0 offen lds
		v_bitop3_b32 v2, v2, v15, v12 bitop3:0x96
		v_accvgpr_write_b32 a61, v2
		s_mul_i32 s43, s25, 0x80
		v_mbcnt_lo_u32_b32 v2, -1, 0
		v_mbcnt_hi_u32_b32 v2, -1, v2
		v_and_b32_e32 v3, 1, v2
		v_lshrrev_b32_e32 v7, 4, v2
		v_and_b32_e32 v7, 1, v7
		v_lshlrev_b32_e32 v7, 4, v7
		v_lshrrev_b32_e32 v10, 3, v2
		v_and_b32_e32 v10, 1, v10
		v_lshlrev_b32_e32 v10, 3, v10
		v_add3_u32 v11, v3, v7, v10
		v_lshrrev_b32_e32 v12, 2, v2
		v_and_b32_e32 v12, 1, v12
		v_lshlrev_b32_e32 v12, 2, v12
		v_lshrrev_b32_e32 v2, 1, v2
		v_and_b32_e32 v2, 1, v2
		v_lshlrev_b32_e32 v2, 1, v2
		v_add3_u32 v11, v11, v12, v2
		v_add_u32_e32 v3, 32, v3
		v_bitop3_b32 v7, v12, v10, v7 bitop3:0x96
		v_bitop3_b32 v2, v3, v2, v7 bitop3:0x96
		v_mov_b32_e32 v12, 0x3e38aa3b
		v_mov_b32_e32 v13, 0x3e38aa3b
		s_mov_b32 s25, 0xff800000
		v_mov_b32_e32 v3, s25
		v_mov_b32_e32 v7, s25
		s_mov_b32 s25, 1.0
		v_mov_b32_e32 v14, s25
		v_mov_b32_e32 v15, s25
		s_mov_b32 s25, 0
		v_accvgpr_read_b32 v10, a19
		v_lshlrev_b32_e32 v10, 4, v10
		v_accvgpr_write_b32 a62, v10
		v_and_b32_e32 v6, 31, v6
		v_lshrrev_b32_e32 v10, 4, v6
		v_lshlrev_b32_e32 v10, 9, v10
		v_accvgpr_write_b32 a63, v10
		v_lshrrev_b32_e32 v10, 3, v6
		v_and_b32_e32 v10, 1, v10
		v_mov_b32_e32 v16, 0x2080
		v_mul_lo_u32 v16, v16, v10
		v_accvgpr_write_b32 a64, v16
		v_lshrrev_b32_e32 v10, 2, v6
		v_and_b32_e32 v10, 1, v10
		v_mov_b32_e32 v16, 0x1040
		v_mul_lo_u32 v16, v16, v10
		v_accvgpr_write_b32 a65, v16
		v_lshrrev_b32_e32 v10, 1, v6
		v_and_b32_e32 v10, 1, v10
		v_mov_b32_e32 v16, 0x820
		v_mul_lo_u32 v16, v16, v10
		v_accvgpr_write_b32 a66, v16
		v_and_b32_e32 v6, 1, v6
		v_mov_b32_e32 v10, 0x410
		v_mul_lo_u32 v10, v10, v6
		v_accvgpr_write_b32 a67, v10
		v_and_b32_e32 v6, 3, v0
		v_accvgpr_write_b32 a68, v6
		v_accvgpr_read_b32 v6, a68
		v_lshlrev_b32_e32 v6, 3, v6
		v_accvgpr_write_b32 a69, v6
		v_accvgpr_read_b32 v6, a17
		v_mov_b32_e32 v10, 0x2200
		v_mul_lo_u32 v10, v10, v6
		v_accvgpr_write_b32 a70, v10
		v_accvgpr_read_b32 v6, a18
		v_lshlrev_b32_e32 v6, 5, v6
		v_accvgpr_write_b32 a71, v6
		v_and_b32_e32 v5, 3, v5
		v_mov_b32_e32 v6, 0x440
		v_mul_lo_u32 v6, v6, v5
		v_accvgpr_write_b32 a72, v6
		s_lshl_b32 s46, s15, 8
		s_add_i32 s46, s46, s39
		s_add_i32 s46, s46, s40
		s_mul_i32 s47, 0x108, s15
		s_add_i32 s47, s47, s39
		s_add_i32 s47, s47, s40
		s_mul_i32 s48, 0x110, s15
		s_add_i32 s48, s48, s39
		s_add_i32 s48, s48, s40
		s_mul_i32 s49, 0x118, s15
		s_add_i32 s39, s49, s39
		s_add_i32 s40, s39, s40
		s_lshl_b32 s39, s17, 8
		s_add_i32 s39, s39, s36
		s_add_i32 s49, s39, s37
		s_mul_i32 s39, 0x108, s17
		s_add_i32 s39, s39, s36
		s_add_i32 s50, s39, s37
		s_mul_i32 s39, 0x110, s17
		s_add_i32 s39, s39, s36
		s_add_i32 s51, s39, s37
		s_mul_i32 s39, 0x118, s17
		s_add_i32 s36, s39, s36
		s_add_i32 s36, s36, s37
		v_lshlrev_b32_e32 v5, 2, v11
		v_accvgpr_write_b32 a73, v5
		v_lshlrev_b32_e32 v2, 2, v2
		v_accvgpr_write_b32 a74, v2
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
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_3
.L_attn_fwd_persistent.loop_head_3:
		s_waitcnt vmcnt(0)
		s_barrier
		s_lshr_b32 s37, s25, 7
		s_and_b32 s39, s37, 1
		s_mul_i32 s52, 0x4100, s39
		v_accvgpr_read_b32 v2, a62
		v_accvgpr_read_b32 v5, a63
		v_add3_u32 v2, s52, v2, v5
		v_accvgpr_read_b32 v5, a64
		v_accvgpr_read_b32 v6, a65
		v_add3_u32 v2, v2, v5, v6
		v_accvgpr_read_b32 v5, a66
		v_accvgpr_read_b32 v6, a67
		v_add3_u32 v2, v2, v5, v6
		ds_read_b128 v[16:19], v2
		ds_read_b128 a[76:79], v2 offset:32
		ds_read_b128 a[80:83], v2 offset:64
		ds_read_b128 a[84:87], v2 offset:96
		ds_read_b128 v[24:27], v2 offset:256
		ds_read_b128 a[88:91], v2 offset:288
		ds_read_b128 a[92:95], v2 offset:320
		ds_read_b128 a[96:99], v2 offset:352
		ds_read_b128 a[100:103], v2 offset:128
		ds_read_b128 a[104:107], v2 offset:160
		ds_read_b128 a[108:111], v2 offset:192
		ds_read_b128 a[112:115], v2 offset:224
		ds_read_b128 v[28:31], v2 offset:384
		ds_read_b128 a[116:119], v2 offset:416
		ds_read_b128 a[120:123], v2 offset:448
		ds_read_b128 a[124:127], v2 offset:480
		s_mul_i32 s39, 0x4400, s39
		v_accvgpr_read_b32 v2, a69
		v_accvgpr_read_b32 v5, a70
		v_add3_u32 v2, s39, v2, v5
		v_accvgpr_read_b32 v5, a71
		v_accvgpr_read_b32 v6, a72
		v_add3_u32 v2, v2, v5, v6
		ds_read_b64_tr_b16 a[128:129], v2 offset:33264
		ds_read_b64_tr_b16 a[130:131], v2 offset:37616
		ds_read_b64_tr_b16 a[132:133], v2 offset:33392
		ds_read_b64_tr_b16 a[134:135], v2 offset:37744
		ds_read_b64_tr_b16 a[136:137], v2 offset:33520
		ds_read_b64_tr_b16 a[138:139], v2 offset:37872
		ds_read_b64_tr_b16 a[140:141], v2 offset:33648
		ds_read_b64_tr_b16 a[142:143], v2 offset:38000
		ds_read_b64_tr_b16 a[144:145], v2 offset:33776
		ds_read_b64_tr_b16 a[146:147], v2 offset:38128
		ds_read_b64_tr_b16 a[148:149], v2 offset:33904
		ds_read_b64_tr_b16 a[150:151], v2 offset:38256
		ds_read_b64_tr_b16 a[152:153], v2 offset:34032
		ds_read_b64_tr_b16 a[154:155], v2 offset:38384
		ds_read_b64_tr_b16 a[156:157], v2 offset:34160
		ds_read_b64_tr_b16 a[158:159], v2 offset:38512
		ds_read_b64_tr_b16 a[160:161], v2 offset:33328
		ds_read_b64_tr_b16 a[162:163], v2 offset:37680
		ds_read_b64_tr_b16 a[164:165], v2 offset:33456
		ds_read_b64_tr_b16 a[166:167], v2 offset:37808
		ds_read_b64_tr_b16 a[168:169], v2 offset:33584
		ds_read_b64_tr_b16 a[170:171], v2 offset:37936
		ds_read_b64_tr_b16 a[172:173], v2 offset:33712
		ds_read_b64_tr_b16 a[174:175], v2 offset:38064
		ds_read_b64_tr_b16 a[176:177], v2 offset:33840
		ds_read_b64_tr_b16 a[178:179], v2 offset:38192
		ds_read_b64_tr_b16 a[180:181], v2 offset:33968
		ds_read_b64_tr_b16 a[182:183], v2 offset:38320
		ds_read_b64_tr_b16 a[184:185], v2 offset:34096
		ds_read_b64_tr_b16 a[186:187], v2 offset:38448
		ds_read_b64_tr_b16 a[188:189], v2 offset:34224
		ds_read_b64_tr_b16 a[190:191], v2 offset:38576
		s_mul_i32 s39, s15, s25
		s_lshl_b32 s39, s39, 1
		s_add_i32 s52, s46, s39
		v_add_u32_e32 v2, s52, v9
		s_waitcnt lgkmcnt(0)
		s_barrier
		v_add_u32_e32 v5, s39, v9
		s_add_i32 s37, s37, 1
		v_add_u32_e32 v6, s47, v5
		s_and_b32 s37, s37, 1
		v_add_u32_e32 v10, s48, v5
		s_mul_i32 s39, 0x4100, s37
		v_add_u32_e32 v5, s40, v5
		s_add_i32 s39, s42, s39
		v_mfma_f32_32x32x16_bf16 v[96:111], v[16:19], a[20:23], 0
		s_mov_b32 m0, s39
		v_mfma_f32_32x32x16_bf16 v[112:127], v[24:27], a[20:23], 0
		s_mul_i32 s39, s17, s25
		v_mfma_f32_32x32x16_bf16 v[128:143], a[100:103], a[20:23], 0
		s_add_i32 s25, s25, 0x80
		v_mfma_f32_32x32x16_bf16 v[144:159], v[28:31], a[20:23], 0
		v_accvgpr_read_b32 v11, a53
		v_add_u32_e32 v11, s25, v11
		v_mfma_f32_32x32x16_bf16 v[160:175], v[28:31], a[36:39], 0
		v_accvgpr_read_b32 v20, a56
		v_add_u32_e32 v20, s25, v20
		v_mfma_f32_32x32x16_bf16 v[176:191], v[16:19], a[36:39], 0
		v_accvgpr_read_b32 v16, a57
		v_add_u32_e32 v16, s25, v16
		v_mfma_f32_32x32x16_bf16 v[192:207], v[24:27], a[36:39], 0
		v_accvgpr_read_b32 v17, a58
		v_add_u32_e32 v17, s25, v17
		v_mfma_f32_32x32x16_bf16 v[208:223], a[100:103], a[36:39], 0
		v_cmp_lt_i32_e64 s[52:53], v11, s21
		v_mfma_f32_32x32x16_bf16 v[96:111], a[76:79], a[24:27], v[96:111]
		v_accvgpr_read_b32 v11, a54
		v_add_u32_e32 v11, s25, v11
		v_mfma_f32_32x32x16_bf16 v[112:127], a[88:91], a[24:27], v[112:127]
		v_accvgpr_read_b32 v18, a59
		v_add_u32_e32 v18, s25, v18
		v_mfma_f32_32x32x16_bf16 v[128:143], a[104:107], a[24:27], v[128:143]
		v_accvgpr_read_b32 v19, a60
		v_add_u32_e32 v19, s25, v19
		v_mfma_f32_32x32x16_bf16 v[144:159], a[116:119], a[24:27], v[144:159]
		v_cmp_lt_i32_e64 s[54:55], v11, s21
		v_mfma_f32_32x32x16_bf16 v[160:175], a[116:119], a[40:43], v[160:175]
		v_cndmask_b32_e64 v2, v21, v2, s[52:53]
		buffer_load_dwordx4 v2, s[28:31], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[176:191], a[76:79], a[40:43], v[176:191]
		v_cmp_lt_i32_e64 s[52:53], v20, s21
		v_mfma_f32_32x32x16_bf16 v[192:207], a[88:91], a[40:43], v[192:207]
		s_nop 0
		v_cndmask_b32_e64 v2, v21, v6, s[52:53]
		v_cmp_lt_i32_e64 s[52:53], v16, s21
		s_add_i32 m0, m0, 0x1040
		s_nop 0
		v_cndmask_b32_e64 v6, v21, v10, s[52:53]
		buffer_load_dwordx4 v2, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[52:53], v17, s21
		s_nop 1
		v_cndmask_b32_e64 v2, v21, v5, s[52:53]
		s_add_i32 m0, m0, 0x1040
		v_accvgpr_read_b32 v5, a61
		v_add_u32_e32 v5, s25, v5
		s_lshl_b32 s39, s39, 1
		buffer_load_dwordx4 v6, s[28:31], 0 offen lds
		s_add_i32 s52, s49, s39
		v_add_u32_e32 v6, s52, v4
		s_add_i32 m0, m0, 0x1040
		v_cndmask_b32_e64 v6, v21, v6, s[54:55]
		s_mul_i32 s37, 0x4400, s37
		buffer_load_dwordx4 v2, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[52:53], v18, s21
		s_add_i32 s37, s41, s37
		v_add_u32_e32 v2, s39, v4
		s_add_i32 m0, s37, 0x81f0
		v_add_u32_e32 v10, s50, v2
		buffer_load_dwordx4 v6, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[208:223], a[104:107], a[40:43], v[208:223]
		v_cndmask_b32_e64 v6, v21, v10, s[52:53]
		v_cmp_lt_i32_e64 s[52:53], v19, s21
		s_add_i32 m0, m0, 0x1100
		v_add_u32_e32 v10, s51, v2
		buffer_load_dwordx4 v6, s[32:35], 0 offen lds
		v_cndmask_b32_e64 v6, v21, v10, s[52:53]
		v_cmp_lt_i32_e64 vcc, v5, s21
		s_add_i32 m0, m0, 0x1100
		v_add_u32_e32 v2, s36, v2
		v_cndmask_b32_e32 v2, v21, v2, vcc
		buffer_load_dwordx4 v6, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[96:111], a[80:83], a[28:31], v[96:111]
		s_add_i32 m0, m0, 0x1100
		s_cmp_lt_i32 s25, s43
		v_mfma_f32_32x32x16_bf16 v[112:127], a[92:95], a[28:31], v[112:127]
		buffer_load_dwordx4 v2, s[32:35], 0 offen lds
		v_mfma_f32_32x32x16_bf16 v[128:143], a[108:111], a[28:31], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[120:123], a[28:31], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[120:123], a[44:47], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[80:83], a[44:47], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[92:95], a[44:47], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[108:111], a[44:47], v[208:223]
		v_mfma_f32_32x32x16_bf16 v[96:111], a[84:87], a[32:35], v[96:111]
		v_mfma_f32_32x32x16_bf16 v[112:127], a[96:99], a[32:35], v[112:127]
		v_mfma_f32_32x32x16_bf16 v[128:143], a[112:115], a[32:35], v[128:143]
		v_mfma_f32_32x32x16_bf16 v[144:159], a[124:127], a[32:35], v[144:159]
		v_mfma_f32_32x32x16_bf16 v[160:175], a[124:127], a[48:51], v[160:175]
		v_mfma_f32_32x32x16_bf16 v[176:191], a[84:87], a[48:51], v[176:191]
		v_mfma_f32_32x32x16_bf16 v[192:207], a[96:99], a[48:51], v[192:207]
		v_mfma_f32_32x32x16_bf16 v[208:223], a[112:115], a[48:51], v[208:223]
		s_nop 4
		v_max3_f32 v2, v96, v97, v98
		v_max3_f32 v5, v100, v101, v102
		v_max3_f32 v6, v104, v105, v106
		v_max3_f32 v10, v108, v109, v110
		v_max3_f32 v11, v112, v113, v114
		v_max3_f32 v16, v116, v117, v118
		v_max3_f32 v17, v120, v121, v122
		v_max3_f32 v18, v124, v125, v126
		v_max3_f32 v19, v128, v129, v130
		v_max3_f32 v20, v132, v133, v134
		v_max3_f32 v24, v136, v137, v138
		v_max3_f32 v25, v140, v141, v142
		v_max3_f32 v26, v144, v145, v146
		v_max3_f32 v27, v148, v149, v150
		v_max3_f32 v28, v152, v153, v154
		v_max3_f32 v29, v156, v157, v158
		v_max3_f32 v2, v2, v99, v5
		v_max3_f32 v5, v6, v107, v10
		v_max3_f32 v6, v11, v115, v16
		v_max3_f32 v10, v17, v123, v18
		v_max3_f32 v11, v19, v131, v20
		v_max3_f32 v16, v24, v139, v25
		v_max3_f32 v17, v26, v147, v27
		v_max3_f32 v18, v28, v155, v29
		v_max3_f32 v2, v2, v103, v5
		v_max3_f32 v5, v6, v119, v10
		v_max3_f32 v6, v11, v135, v16
		v_max3_f32 v10, v17, v151, v18
		v_max3_f32 v2, v2, v111, v5
		v_max3_f32 v5, v6, v143, v10
		v_max3_f32 v2, v2, v127, v5
		v_max_f32_e32 v10, v2, v159
		v_mov_b32_e32 v11, v10
		v_max3_f32 v2, v176, v177, v178
		v_max3_f32 v5, v180, v181, v182
		v_max3_f32 v6, v184, v185, v186
		v_max3_f32 v16, v188, v189, v190
		v_max3_f32 v17, v192, v193, v194
		v_max3_f32 v18, v196, v197, v198
		v_max3_f32 v19, v200, v201, v202
		v_max3_f32 v20, v204, v205, v206
		v_max3_f32 v24, v208, v209, v210
		v_max3_f32 v25, v212, v213, v214
		v_max3_f32 v26, v216, v217, v218
		v_max3_f32 v27, v220, v221, v222
		v_max3_f32 v28, v160, v161, v162
		v_max3_f32 v29, v164, v165, v166
		v_max3_f32 v30, v168, v169, v170
		v_max3_f32 v31, v172, v173, v174
		v_permlane32_swap_b32_e32 v10, v11
		v_max3_f32 v2, v2, v179, v5
		v_max3_f32 v5, v6, v187, v16
		v_max3_f32 v6, v17, v195, v18
		v_max3_f32 v16, v19, v203, v20
		v_max3_f32 v17, v24, v211, v25
		v_max3_f32 v18, v26, v219, v27
		v_max3_f32 v19, v28, v163, v29
		v_max3_f32 v20, v30, v171, v31
		v_max3_f32 v2, v2, v183, v5
		v_max3_f32 v5, v6, v199, v16
		v_max3_f32 v6, v17, v215, v18
		v_max3_f32 v16, v19, v167, v20
		v_max3_f32 v2, v2, v191, v5
		v_max3_f32 v5, v6, v223, v16
		v_max3_f32 v2, v2, v207, v5
		v_max_f32_e32 v16, v2, v175
		v_mov_b32_e32 v17, v16
		v_max_f32_e32 v18, v10, v11
		v_mov_b32_e32 v10, v3
		v_permlane32_swap_b32_e32 v16, v17
		v_max_f32_e32 v19, v16, v17
		v_pk_mul_f32 v[16:17], v[18:19], v[12:13]
		v_max_f32_e32 v18, v3, v16
		v_max_f32_e32 v19, v7, v17
		v_pk_fma_f32 v[2:3], v[96:97], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[16:17], v[98:99], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[100:101], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[102:103], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[104:105], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[106:107], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[108:109], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[110:111], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[112:113], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[114:115], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[116:117], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[118:119], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[120:121], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[122:123], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[124:125], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[126:127], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[128:129], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[130:131], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[132:133], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[134:135], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[136:137], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[138:139], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[140:141], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[142:143], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[144:145], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[146:147], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[148:149], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[138:139], v[150:151], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[152:153], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[154:155], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[156:157], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[158:159], v[12:13], v[18:19] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[176:177], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[178:179], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[180:181], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[182:183], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[184:185], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[186:187], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[188:189], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[190:191], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[192:193], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[194:195], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[196:197], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[198:199], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[200:201], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[202:203], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[204:205], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[206:207], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[208:209], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[210:211], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[212:213], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[214:215], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[216:217], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[218:219], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[220:221], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[222:223], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[160:161], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[160:161], v[162:163], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[162:163], v[164:165], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[166:167], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[168:169], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[170:171], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[172:173], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[174:175], v[12:13], v[18:19] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v174, v2
		v_exp_f32_e32 v214, v3
		v_exp_f32_e32 v2, v16
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
		v_exp_f32_e32 v175, v116
		v_exp_f32_e32 v215, v117
		v_exp_f32_e32 v3, v118
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
		v_exp_f32_e32 v114, v148
		v_exp_f32_e32 v116, v149
		v_exp_f32_e32 v118, v150
		v_exp_f32_e32 v120, v151
		v_exp_f32_e32 v122, v152
		v_exp_f32_e32 v124, v153
		v_exp_f32_e32 v126, v154
		v_exp_f32_e32 v128, v155
		v_exp_f32_e32 v130, v156
		v_exp_f32_e32 v132, v157
		v_exp_f32_e32 v134, v158
		v_exp_f32_e32 v136, v159
		v_exp_f32_e32 v138, v176
		v_exp_f32_e32 v140, v177
		v_exp_f32_e32 v142, v178
		v_exp_f32_e32 v144, v179
		v_exp_f32_e32 v146, v180
		v_exp_f32_e32 v148, v181
		v_exp_f32_e32 v150, v182
		v_exp_f32_e32 v152, v183
		v_exp_f32_e32 v154, v184
		v_exp_f32_e32 v156, v185
		v_exp_f32_e32 v158, v186
		v_exp_f32_e32 v176, v187
		v_exp_f32_e32 v178, v188
		v_exp_f32_e32 v180, v189
		v_exp_f32_e32 v182, v190
		v_exp_f32_e32 v184, v191
		v_exp_f32_e32 v186, v192
		v_exp_f32_e32 v188, v193
		v_exp_f32_e32 v190, v194
		v_exp_f32_e32 v192, v195
		v_exp_f32_e32 v115, v196
		v_exp_f32_e32 v117, v197
		v_exp_f32_e32 v119, v198
		v_exp_f32_e32 v121, v199
		v_exp_f32_e32 v123, v200
		v_exp_f32_e32 v125, v201
		v_exp_f32_e32 v127, v202
		v_exp_f32_e32 v129, v203
		v_exp_f32_e32 v131, v204
		v_exp_f32_e32 v133, v205
		v_exp_f32_e32 v135, v206
		v_exp_f32_e32 v137, v207
		v_exp_f32_e32 v139, v208
		v_exp_f32_e32 v141, v209
		v_exp_f32_e32 v143, v210
		v_exp_f32_e32 v145, v211
		v_exp_f32_e32 v147, v212
		v_exp_f32_e32 v149, v213
		v_exp_f32_e32 v151, v160
		v_exp_f32_e32 v153, v161
		v_exp_f32_e32 v155, v162
		v_exp_f32_e32 v157, v163
		v_exp_f32_e32 v159, v164
		v_exp_f32_e32 v177, v165
		v_exp_f32_e32 v179, v166
		v_exp_f32_e32 v181, v167
		v_exp_f32_e32 v183, v168
		v_exp_f32_e32 v185, v169
		v_exp_f32_e32 v187, v170
		v_exp_f32_e32 v189, v171
		v_exp_f32_e32 v191, v172
		v_exp_f32_e32 v193, v173
		v_pk_add_f32 v[160:161], v[174:175], v[214:215]
		v_pk_add_f32 v[162:163], v[2:3], v[216:217]
		v_pk_add_f32 v[164:165], v[16:17], v[218:219]
		v_pk_add_f32 v[166:167], v[24:25], v[220:221]
		v_pk_add_f32 v[168:169], v[26:27], v[222:223]
		v_pk_add_f32 v[170:171], v[28:29], v[224:225]
		v_pk_add_f32 v[172:173], v[30:31], v[226:227]
		v_pk_add_f32 v[194:195], v[96:97], v[228:229]
		v_pk_add_f32 v[196:197], v[98:99], v[230:231]
		v_pk_add_f32 v[198:199], v[100:101], v[232:233]
		v_pk_add_f32 v[200:201], v[102:103], v[234:235]
		v_pk_add_f32 v[202:203], v[104:105], v[236:237]
		v_pk_add_f32 v[204:205], v[106:107], v[238:239]
		v_pk_add_f32 v[206:207], v[108:109], v[240:241]
		v_pk_add_f32 v[208:209], v[110:111], v[242:243]
		v_pk_add_f32 v[210:211], v[112:113], v[244:245]
		v_pk_add_f32 v[160:161], v[160:161], v[162:163]
		v_pk_add_f32 v[162:163], v[164:165], v[166:167]
		v_pk_add_f32 v[164:165], v[168:169], v[170:171]
		v_pk_add_f32 v[166:167], v[172:173], v[194:195]
		v_pk_add_f32 v[168:169], v[196:197], v[198:199]
		v_pk_add_f32 v[170:171], v[200:201], v[202:203]
		v_pk_add_f32 v[172:173], v[204:205], v[206:207]
		v_pk_add_f32 v[194:195], v[208:209], v[210:211]
		v_pk_add_f32 v[160:161], v[160:161], v[162:163]
		v_pk_add_f32 v[162:163], v[164:165], v[166:167]
		v_pk_add_f32 v[164:165], v[168:169], v[170:171]
		v_pk_add_f32 v[166:167], v[172:173], v[194:195]
		v_pk_add_f32 v[160:161], v[160:161], v[162:163]
		v_pk_add_f32 v[162:163], v[164:165], v[166:167]
		v_pk_add_f32 v[164:165], v[160:161], v[162:163]
		v_add_f32_e32 v5, v164, v165
		v_accvgpr_read_b32 v6, a73
		ds_bpermute_b32 v160, v6, v5
		v_accvgpr_read_b32 v6, a74
		ds_bpermute_b32 v162, v6, v5
		v_pk_add_f32 v[164:165], v[114:115], v[116:117]
		v_pk_add_f32 v[166:167], v[118:119], v[120:121]
		v_pk_add_f32 v[168:169], v[122:123], v[124:125]
		v_pk_add_f32 v[170:171], v[126:127], v[128:129]
		v_pk_add_f32 v[172:173], v[130:131], v[132:133]
		v_pk_add_f32 v[194:195], v[134:135], v[136:137]
		v_pk_add_f32 v[196:197], v[138:139], v[140:141]
		v_pk_add_f32 v[198:199], v[142:143], v[144:145]
		v_pk_add_f32 v[200:201], v[146:147], v[148:149]
		v_pk_add_f32 v[202:203], v[150:151], v[152:153]
		v_pk_add_f32 v[204:205], v[154:155], v[156:157]
		v_pk_add_f32 v[206:207], v[158:159], v[176:177]
		v_pk_add_f32 v[208:209], v[178:179], v[180:181]
		v_pk_add_f32 v[210:211], v[182:183], v[184:185]
		v_pk_add_f32 v[212:213], v[186:187], v[188:189]
		v_accvgpr_write_b32 a76, v212
		v_accvgpr_write_b32 a77, v213
		v_pk_add_f32 v[212:213], v[190:191], v[192:193]
		v_pk_add_f32 v[164:165], v[164:165], v[166:167]
		v_pk_add_f32 v[166:167], v[168:169], v[170:171]
		v_pk_add_f32 v[168:169], v[172:173], v[194:195]
		v_pk_add_f32 v[170:171], v[196:197], v[198:199]
		v_pk_add_f32 v[172:173], v[200:201], v[202:203]
		v_pk_add_f32 v[194:195], v[204:205], v[206:207]
		v_pk_add_f32 v[196:197], v[208:209], v[210:211]
		v_accvgpr_read_b32 v198, a76
		v_accvgpr_read_b32 v199, a77
		v_pk_add_f32 v[198:199], v[198:199], v[212:213]
		v_pk_add_f32 v[164:165], v[164:165], v[166:167]
		v_pk_add_f32 v[166:167], v[168:169], v[170:171]
		v_pk_add_f32 v[168:169], v[172:173], v[194:195]
		v_pk_add_f32 v[170:171], v[196:197], v[198:199]
		v_pk_add_f32 v[164:165], v[164:165], v[166:167]
		v_pk_add_f32 v[166:167], v[168:169], v[170:171]
		v_pk_add_f32 v[168:169], v[164:165], v[166:167]
		v_mov_b32_e32 v163, v169
		v_mov_b32_e32 v161, v168
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[164:165], v[160:161], v[162:163]
		v_mov_b32_e32 v160, v165
		v_mov_b32_e32 v161, v165
		v_cvt_pk_bf16_f32 v168, v174, v214
		v_cvt_pk_bf16_f32 v169, v2, v216
		v_permlane32_swap_b32_e32 v160, v161
		v_add_f32_e32 v163, v160, v161
		v_mov_b32_e32 v11, v7
		v_pk_add_f32 v[6:7], v[10:11], v[18:19] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v10, v6
		v_exp_f32_e32 v11, v7
		v_cvt_pk_bf16_f32 v170, v16, v218
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
		v_pk_mul_f32 v[32:33], v[32:33], v[10:11] op_sel_hi:[1,0]
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
		v_mov_b32_e32 v162, v164
		v_mov_b64_e32 v[6:7], v[14:15]
		v_pk_fma_f32 v[14:15], v[6:7], v[10:11], v[162:163]
		v_cvt_pk_bf16_f32 v171, v24, v220
		v_cvt_pk_bf16_f32 v160, v26, v222
		v_cvt_pk_bf16_f32 v161, v28, v224
		v_cvt_pk_bf16_f32 v162, v30, v226
		v_cvt_pk_bf16_f32 v163, v96, v228
		v_cvt_pk_bf16_f32 v164, v98, v230
		v_cvt_pk_bf16_f32 v165, v100, v232
		v_cvt_pk_bf16_f32 v166, v102, v234
		v_cvt_pk_bf16_f32 v167, v104, v236
		v_cvt_pk_bf16_f32 v196, v106, v238
		v_cvt_pk_bf16_f32 v197, v108, v240
		v_cvt_pk_bf16_f32 v198, v110, v242
		v_cvt_pk_bf16_f32 v199, v112, v244
		v_cvt_pk_bf16_f32 v200, v175, v215
		v_cvt_pk_bf16_f32 v201, v3, v217
		v_cvt_pk_bf16_f32 v202, v17, v219
		v_cvt_pk_bf16_f32 v203, v25, v221
		v_cvt_pk_bf16_f32 v172, v27, v223
		v_cvt_pk_bf16_f32 v173, v29, v225
		v_cvt_pk_bf16_f32 v174, v31, v227
		v_cvt_pk_bf16_f32 v175, v97, v229
		v_cvt_pk_bf16_f32 v24, v99, v231
		v_cvt_pk_bf16_f32 v25, v101, v233
		v_cvt_pk_bf16_f32 v26, v103, v235
		v_cvt_pk_bf16_f32 v27, v105, v237
		v_cvt_pk_bf16_f32 v28, v107, v239
		v_cvt_pk_bf16_f32 v29, v109, v241
		v_cvt_pk_bf16_f32 v30, v111, v243
		v_cvt_pk_bf16_f32 v31, v113, v245
		v_cvt_pk_bf16_f32 v96, v114, v116
		v_cvt_pk_bf16_f32 v97, v118, v120
		v_cvt_pk_bf16_f32 v98, v122, v124
		v_cvt_pk_bf16_f32 v99, v126, v128
		v_cvt_pk_bf16_f32 v100, v130, v132
		v_cvt_pk_bf16_f32 v101, v134, v136
		v_cvt_pk_bf16_f32 v102, v138, v140
		v_cvt_pk_bf16_f32 v103, v142, v144
		v_cvt_pk_bf16_f32 v104, v146, v148
		v_cvt_pk_bf16_f32 v105, v150, v152
		v_cvt_pk_bf16_f32 v106, v154, v156
		v_cvt_pk_bf16_f32 v107, v158, v176
		v_cvt_pk_bf16_f32 v108, v178, v180
		v_cvt_pk_bf16_f32 v109, v182, v184
		v_cvt_pk_bf16_f32 v110, v186, v188
		v_cvt_pk_bf16_f32 v111, v190, v192
		v_cvt_pk_bf16_f32 v204, v115, v117
		v_cvt_pk_bf16_f32 v205, v119, v121
		v_cvt_pk_bf16_f32 v206, v123, v125
		v_cvt_pk_bf16_f32 v207, v127, v129
		v_cvt_pk_bf16_f32 v112, v131, v133
		v_cvt_pk_bf16_f32 v113, v135, v137
		v_cvt_pk_bf16_f32 v114, v139, v141
		v_cvt_pk_bf16_f32 v115, v143, v145
		v_cvt_pk_bf16_f32 v116, v147, v149
		v_cvt_pk_bf16_f32 v117, v151, v153
		v_cvt_pk_bf16_f32 v118, v155, v157
		v_cvt_pk_bf16_f32 v119, v159, v177
		v_cvt_pk_bf16_f32 v120, v179, v181
		v_cvt_pk_bf16_f32 v121, v183, v185
		v_cvt_pk_bf16_f32 v122, v187, v189
		v_cvt_pk_bf16_f32 v123, v191, v193
		v_permlane32_swap_b32_e32 v168, v170
		v_permlane32_swap_b32_e32 v169, v171
		v_permlane32_swap_b32_e32 v160, v162
		v_permlane32_swap_b32_e32 v161, v163
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[32:47], a[128:131], v[168:171], v[32:47]
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		v_mfma_f32_32x32x16_bf16 v[48:63], a[160:163], v[168:171], v[48:63]
		v_permlane32_swap_b32_e32 v196, v198
		v_permlane32_swap_b32_e32 v197, v199
		v_mfma_f32_32x32x16_bf16 v[32:47], a[132:135], v[160:163], v[32:47]
		v_permlane32_swap_b32_e32 v200, v202
		v_permlane32_swap_b32_e32 v201, v203
		v_mfma_f32_32x32x16_bf16 v[48:63], a[164:167], v[160:163], v[48:63]
		v_permlane32_swap_b32_e32 v172, v174
		v_permlane32_swap_b32_e32 v173, v175
		v_mfma_f32_32x32x16_bf16 v[32:47], a[136:139], v[164:167], v[32:47]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[48:63], a[168:171], v[164:167], v[48:63]
		v_permlane32_swap_b32_e32 v28, v30
		v_permlane32_swap_b32_e32 v29, v31
		v_mfma_f32_32x32x16_bf16 v[32:47], a[140:143], v[196:199], v[32:47]
		v_permlane32_swap_b32_e32 v96, v98
		v_permlane32_swap_b32_e32 v97, v99
		v_mfma_f32_32x32x16_bf16 v[48:63], a[172:175], v[196:199], v[48:63]
		v_permlane32_swap_b32_e32 v100, v102
		v_permlane32_swap_b32_e32 v101, v103
		v_mfma_f32_32x32x16_bf16 v[80:95], a[160:163], v[96:99], v[80:95]
		v_permlane32_swap_b32_e32 v104, v106
		v_permlane32_swap_b32_e32 v105, v107
		v_mfma_f32_32x32x16_bf16 v[64:79], a[128:131], v[96:99], v[64:79]
		v_permlane32_swap_b32_e32 v108, v110
		v_permlane32_swap_b32_e32 v109, v111
		v_mfma_f32_32x32x16_bf16 v[80:95], a[164:167], v[100:103], v[80:95]
		v_permlane32_swap_b32_e32 v204, v206
		v_permlane32_swap_b32_e32 v205, v207
		v_mfma_f32_32x32x16_bf16 v[64:79], a[132:135], v[100:103], v[64:79]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[80:95], a[168:171], v[104:107], v[80:95]
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		v_mfma_f32_32x32x16_bf16 v[64:79], a[136:139], v[104:107], v[64:79]
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_mfma_f32_32x32x16_bf16 v[80:95], a[172:175], v[108:111], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[140:143], v[108:111], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[144:147], v[200:203], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[176:179], v[200:203], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[176:179], v[204:207], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[144:147], v[204:207], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[148:151], v[172:175], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[180:183], v[172:175], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[180:183], v[112:115], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[148:151], v[112:115], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[152:155], v[24:27], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[184:187], v[24:27], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[184:187], v[116:119], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[152:155], v[116:119], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[156:159], v[28:31], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[188:191], v[28:31], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[188:191], v[120:123], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[156:159], v[120:123], v[64:79]
		v_mov_b32_e32 v3, v18
		v_mov_b32_e32 v7, v19
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_3
.L_attn_fwd_persistent.loop_exit_3:
		s_mul_i32 s24, s24, 0x80
		v_accvgpr_read_b32 v2, a52
		s_nop 0
		v_readfirstlane_b32 s25, v2
		v_accvgpr_read_b32 v2, a11
		s_nop 0
		v_add_u32_e32 v2, s25, v2
		v_add_u32_e32 v2, s19, v2
		v_accvgpr_read_b32 v5, a52
		s_nop 0
		v_readfirstlane_b32 s25, v5
		v_accvgpr_read_b32 v5, a12
		s_nop 0
		v_add_u32_e32 v5, s25, v5
		v_add_u32_e32 v5, s19, v5
		v_xor_b32_e32 v6, 1, v8
		v_accvgpr_write_b32 a11, v6
		v_xor_b32_e32 v6, 2, v8
		v_accvgpr_write_b32 a12, v6
		v_xor_b32_e32 v6, 3, v8
		v_accvgpr_write_b32 a52, v6
		v_xor_b32_e32 v6, 8, v8
		v_accvgpr_write_b32 a62, v6
		v_xor_b32_e32 v6, 9, v8
		v_accvgpr_write_b32 a69, v6
		v_xor_b32_e32 v6, 10, v8
		v_accvgpr_write_b32 a75, v6
		v_xor_b32_e32 v6, 11, v8
		v_accvgpr_write_b32 a76, v6
		v_xor_b32_e32 v6, 16, v8
		v_accvgpr_write_b32 a77, v6
		v_xor_b32_e32 v6, 17, v8
		v_accvgpr_write_b32 a78, v6
		v_xor_b32_e32 v6, 18, v8
		v_accvgpr_write_b32 a79, v6
		v_xor_b32_e32 v6, 19, v8
		v_accvgpr_write_b32 a80, v6
		v_xor_b32_e32 v6, 24, v8
		v_accvgpr_write_b32 a81, v6
		v_xor_b32_e32 v6, 25, v8
		v_accvgpr_write_b32 a82, v6
		v_xor_b32_e32 v6, 26, v8
		v_accvgpr_write_b32 a83, v6
		v_xor_b32_e32 v6, 27, v8
		v_accvgpr_write_b32 a84, v6
		v_xor_b32_e32 v6, 32, v8
		v_accvgpr_write_b32 a85, v6
		v_xor_b32_e32 v6, 33, v8
		v_accvgpr_write_b32 a86, v6
		v_xor_b32_e32 v6, 34, v8
		v_accvgpr_write_b32 a87, v6
		v_xor_b32_e32 v6, 35, v8
		v_accvgpr_write_b32 a88, v6
		v_xor_b32_e32 v6, 40, v8
		v_accvgpr_write_b32 a89, v6
		v_xor_b32_e32 v6, 41, v8
		v_accvgpr_write_b32 a90, v6
		v_xor_b32_e32 v6, 42, v8
		v_accvgpr_write_b32 a91, v6
		v_xor_b32_e32 v6, 43, v8
		v_accvgpr_write_b32 a92, v6
		v_xor_b32_e32 v6, 48, v8
		v_accvgpr_write_b32 a93, v6
		v_xor_b32_e32 v6, 49, v8
		v_accvgpr_write_b32 a94, v6
		v_xor_b32_e32 v6, 50, v8
		v_accvgpr_write_b32 a95, v6
		v_xor_b32_e32 v6, 51, v8
		v_accvgpr_write_b32 a96, v6
		v_xor_b32_e32 v6, 56, v8
		v_accvgpr_write_b32 a97, v6
		v_xor_b32_e32 v6, 57, v8
		v_accvgpr_write_b32 a98, v6
		v_xor_b32_e32 v6, 58, v8
		v_accvgpr_write_b32 a99, v6
		v_xor_b32_e32 v6, 59, v8
		v_accvgpr_write_b32 a100, v6
		v_xor_b32_e32 v6, 64, v8
		v_accvgpr_write_b32 a101, v6
		v_xor_b32_e32 v6, 0x41, v8
		v_accvgpr_write_b32 a102, v6
		v_xor_b32_e32 v6, 0x42, v8
		v_accvgpr_write_b32 a103, v6
		v_xor_b32_e32 v6, 0x43, v8
		v_accvgpr_write_b32 a104, v6
		v_xor_b32_e32 v6, 0x48, v8
		v_accvgpr_write_b32 a105, v6
		v_xor_b32_e32 v6, 0x49, v8
		v_accvgpr_write_b32 a106, v6
		v_xor_b32_e32 v6, 0x4a, v8
		v_accvgpr_write_b32 a107, v6
		v_xor_b32_e32 v6, 0x4b, v8
		v_accvgpr_write_b32 a108, v6
		v_xor_b32_e32 v6, 0x50, v8
		v_accvgpr_write_b32 a109, v6
		v_xor_b32_e32 v6, 0x51, v8
		v_accvgpr_write_b32 a110, v6
		v_xor_b32_e32 v6, 0x52, v8
		v_accvgpr_write_b32 a111, v6
		v_xor_b32_e32 v6, 0x53, v8
		v_accvgpr_write_b32 a112, v6
		v_xor_b32_e32 v6, 0x58, v8
		v_accvgpr_write_b32 a113, v6
		v_xor_b32_e32 v6, 0x59, v8
		v_accvgpr_write_b32 a114, v6
		v_xor_b32_e32 v6, 0x5a, v8
		v_accvgpr_write_b32 a115, v6
		v_xor_b32_e32 v6, 0x5b, v8
		v_accvgpr_write_b32 a116, v6
		v_xor_b32_e32 v6, 0x60, v8
		v_accvgpr_write_b32 a117, v6
		v_xor_b32_e32 v6, 0x61, v8
		v_accvgpr_write_b32 a118, v6
		v_xor_b32_e32 v6, 0x62, v8
		v_accvgpr_write_b32 a119, v6
		v_xor_b32_e32 v6, 0x63, v8
		v_accvgpr_write_b32 a120, v6
		v_xor_b32_e32 v6, 0x68, v8
		v_accvgpr_write_b32 a121, v6
		v_xor_b32_e32 v6, 0x69, v8
		v_accvgpr_write_b32 a122, v6
		v_xor_b32_e32 v6, 0x6a, v8
		v_accvgpr_write_b32 a123, v6
		v_xor_b32_e32 v6, 0x6b, v8
		v_accvgpr_write_b32 a124, v6
		v_xor_b32_e32 v6, 0x70, v8
		v_accvgpr_write_b32 a125, v6
		v_xor_b32_e32 v6, 0x71, v8
		v_accvgpr_write_b32 a126, v6
		v_xor_b32_e32 v6, 0x72, v8
		v_accvgpr_write_b32 a127, v6
		v_xor_b32_e32 v6, 0x73, v8
		v_accvgpr_write_b32 a128, v6
		v_xor_b32_e32 v6, 0x78, v8
		v_accvgpr_write_b32 a129, v6
		v_xor_b32_e32 v6, 0x79, v8
		v_accvgpr_write_b32 a130, v6
		v_xor_b32_e32 v6, 0x7a, v8
		v_accvgpr_write_b32 a131, v6
		v_xor_b32_e32 v6, 0x7b, v8
		v_accvgpr_write_b32 a132, v6
		v_accvgpr_read_b32 v6, a19
		v_accvgpr_read_b32 v10, a63
		v_lshl_add_u32 v6, v6, 4, v10
		v_accvgpr_read_b32 v10, a64
		v_accvgpr_read_b32 v11, a65
		v_add3_u32 v6, v6, v10, v11
		v_accvgpr_read_b32 v10, a66
		v_accvgpr_read_b32 v11, a67
		v_add3_u32 v6, v6, v10, v11
		v_accvgpr_write_b32 a19, v6
		v_accvgpr_read_b32 v6, a68
		v_accvgpr_read_b32 v10, a70
		v_lshl_add_u32 v6, v6, 3, v10
		v_accvgpr_read_b32 v10, a71
		v_accvgpr_read_b32 v11, a72
		v_add3_u32 v6, v6, v10, v11
		v_accvgpr_write_b32 a63, v6
		v_mov_b32_e32 v6, 0xff800000
		s_cmp_lt_i32 s43, s24
		s_cbranch_scc0 .L_attn_fwd_persistent.loop_exit_4
.L_attn_fwd_persistent.loop_head_4:
		s_waitcnt vmcnt(0)
		s_barrier
		s_add_i32 s19, s43, 0x80
		s_cmp_lt_i32 s43, 0
		s_cselect_b32 s25, s23, 0
		s_add_i32 s25, s43, s25
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
		s_cselect_b32 s39, s16, 0
		s_add_i32 s39, s25, s39
		s_ashr_i32 s39, s39, 1
		s_lshl_b32 s39, s39, 1
		s_xor_b32 s39, s39, -1
		s_add_i32 s39, s39, 1
		s_add_i32 s52, s25, s39
		s_mul_i32 s25, 0x4100, s37
		v_accvgpr_read_b32 v10, a19
		v_add_u32_e32 v10, s25, v10
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
		s_mul_i32 s25, 0x4400, s37
		v_accvgpr_read_b32 v10, a63
		v_add_u32_e32 v10, s25, v10
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
		s_cmp_lt_i32 s19, s1
		s_cbranch_scc0 .L_attn_fwd_persistent.if_else_4
		v_accvgpr_read_b32 v10, a53
		v_add_u32_e32 v10, s19, v10
		v_cmp_lt_i32_e64 s[54:55], v10, s21
		v_accvgpr_read_b32 v10, a54
		v_add_u32_e32 v10, s19, v10
		v_cmp_lt_i32_e64 s[56:57], v10, s21
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_mul_i32 s25, s15, s43
		s_lshl_b32 s25, s25, 1
		s_add_i32 s37, s46, s25
		v_add_u32_e32 v10, s37, v9
		v_cndmask_b32_e64 v10, v21, v10, s[54:55]
		s_mov_b32 s54, 1
		s_mov_b32 s55, 0
		s_mov_b32 s39, 0
		s_mul_i32 s58, s54, s38
		s_mul_hi_u32 s59, s54, s38
		s_mul_i32 s37, s54, s39
		s_add_i32 s59, s59, s37
		s_mul_i32 s37, s55, s38
		s_add_i32 s59, s59, s37
		s_lshr_b64 s[54:55], s[58:59], 6
		s_mov_b32 s58, 0x410
		s_mov_b32 s59, 0
		s_mul_i32 s60, s58, s54
		s_mul_hi_u32 s61, s58, s54
		s_mul_i32 s37, s58, s55
		s_add_i32 s61, s61, s37
		s_mul_i32 s37, s59, s54
		s_add_i32 s61, s61, s37
		s_cmp_lt_i32 s52, 0
		s_cselect_b32 s53, -1, 0
		s_mov_b32 s58, 0x4100
		s_mov_b32 s59, 0
		s_mul_i32 s62, s58, s52
		s_mul_hi_u32 s63, s58, s52
		s_mul_i32 s37, s58, s53
		s_add_i32 s63, s63, s37
		s_mul_i32 s37, s59, s52
		s_add_i32 s63, s63, s37
		s_add_u32 s58, s60, s62
		s_addc_u32 s59, s61, s63
		s_add_u32 s64, s58, 0
		s_addc_u32 s65, s59, 0
		s_mov_b32 m0, s64
		v_accvgpr_read_b32 v11, a56
		v_add_u32_e32 v11, s19, v11
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[58:59], v11, s21
		s_add_i32 s37, s47, s25
		v_add_u32_e32 v10, s37, v9
		v_cndmask_b32_e64 v10, v21, v10, s[58:59]
		s_add_u32 s58, s60, 0x1040
		s_addc_u32 s59, s61, 0
		s_add_u32 s58, s58, s62
		s_addc_u32 s59, s59, s63
		s_add_u32 s64, s58, 0
		s_addc_u32 s65, s59, 0
		s_mov_b32 m0, s64
		v_accvgpr_read_b32 v11, a57
		v_add_u32_e32 v11, s19, v11
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[58:59], v11, s21
		s_add_i32 s37, s48, s25
		v_add_u32_e32 v10, s37, v9
		v_cndmask_b32_e64 v10, v21, v10, s[58:59]
		s_add_u32 s58, s60, 0x2080
		s_addc_u32 s59, s61, 0
		s_add_u32 s58, s58, s62
		s_addc_u32 s59, s59, s63
		s_add_u32 s64, s58, 0
		s_addc_u32 s65, s59, 0
		s_mov_b32 m0, s64
		v_accvgpr_read_b32 v11, a58
		v_add_u32_e32 v11, s19, v11
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		v_cmp_lt_i32_e64 s[58:59], v11, s21
		s_add_i32 s25, s40, s25
		v_add_u32_e32 v10, s25, v9
		v_cndmask_b32_e64 v10, v21, v10, s[58:59]
		s_add_u32 s58, s60, 0x30c0
		s_addc_u32 s59, s61, 0
		s_add_u32 s58, s58, s62
		s_addc_u32 s59, s59, s63
		s_add_u32 s60, s58, 0
		s_addc_u32 s61, s59, 0
		s_mov_b32 m0, s60
		v_accvgpr_read_b32 v11, a59
		v_add_u32_e32 v11, s19, v11
		buffer_load_dwordx4 v10, s[28:31], 0 offen lds
		s_mul_i32 s25, s17, s43
		s_lshl_b32 s25, s25, 1
		s_add_i32 s37, s49, s25
		v_add_u32_e32 v10, s37, v4
		v_cndmask_b32_e64 v10, v21, v10, s[56:57]
		s_mov_b32 s56, 0x440
		s_mov_b32 s57, 0
		s_mul_i32 s58, s56, s54
		s_mul_hi_u32 s59, s56, s54
		s_mul_i32 s37, s56, s55
		s_add_i32 s59, s59, s37
		s_mul_i32 s37, s57, s54
		s_add_i32 s59, s59, s37
		s_add_u32 s54, s58, 0x81f0
		s_addc_u32 s55, s59, 0
		s_mov_b32 s56, 0x4400
		s_mov_b32 s57, 0
		s_mul_i32 s60, s56, s52
		s_mul_hi_u32 s61, s56, s52
		s_mul_i32 s37, s56, s53
		s_add_i32 s61, s61, s37
		s_mul_i32 s37, s57, s52
		s_add_i32 s61, s61, s37
		s_add_u32 s52, s54, s60
		s_addc_u32 s53, s55, s61
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		v_accvgpr_read_b32 v20, a60
		v_add_u32_e32 v20, s19, v20
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[52:53], v11, s21
		s_add_i32 s37, s50, s25
		v_add_u32_e32 v10, s37, v4
		v_cndmask_b32_e64 v10, v21, v10, s[52:53]
		s_add_u32 s52, s58, 0x92f0
		s_addc_u32 s53, s59, 0
		s_add_u32 s52, s52, s60
		s_addc_u32 s53, s53, s61
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		v_accvgpr_read_b32 v11, a61
		v_add_u32_e32 v11, s19, v11
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		v_cmp_lt_i32_e64 s[52:53], v20, s21
		s_add_i32 s19, s51, s25
		v_add_u32_e32 v10, s19, v4
		s_add_u32 s54, s58, 0xa3f0
		s_addc_u32 s55, s59, 0
		s_add_u32 s54, s54, s60
		s_addc_u32 s55, s55, s61
		s_add_u32 s56, s54, 0
		s_addc_u32 s57, s55, 0
		s_mov_b32 m0, s56
		v_cndmask_b32_e64 v10, v21, v10, s[52:53]
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		s_add_i32 s19, s36, s25
		v_cmp_lt_i32_e64 vcc, v11, s21
		v_add_u32_e32 v10, s19, v4
		s_add_u32 s52, s58, 0xb4f0
		s_addc_u32 s53, s59, 0
		v_cndmask_b32_e32 v10, v21, v10, vcc
		s_add_u32 s52, s52, s60
		s_addc_u32 s53, s53, s61
		s_add_u32 s54, s52, 0
		s_addc_u32 s55, s53, 0
		s_mov_b32 m0, s54
		s_nop 0
		buffer_load_dwordx4 v10, s[32:35], 0 offen lds
		s_branch .L_attn_fwd_persistent.if_end_4
.L_attn_fwd_persistent.if_else_4:
.L_attn_fwd_persistent.if_end_4:
		s_waitcnt lgkmcnt(14)
		v_mfma_f32_32x32x16_bf16 v[96:111], a[64:67], a[20:23], 0
		v_add_u32_e32 v10, s43, v8
		v_mfma_f32_32x32x16_bf16 v[112:127], a[148:151], a[20:23], 0
		v_accvgpr_read_b32 v11, a11
		v_add_u32_e32 v11, s43, v11
		v_mfma_f32_32x32x16_bf16 v[128:143], a[164:167], a[20:23], 0
		v_accvgpr_read_b32 v20, a12
		v_add_u32_e32 v20, s43, v20
		v_mfma_f32_32x32x16_bf16 v[144:159], v[16:19], a[20:23], 0
		v_accvgpr_read_b32 v24, a52
		v_add_u32_e32 v24, s43, v24
		v_mfma_f32_32x32x16_bf16 v[160:175], v[16:19], a[36:39], 0
		v_accvgpr_read_b32 v16, a75
		v_add_u32_e32 v16, s43, v16
		v_mfma_f32_32x32x16_bf16 v[176:191], a[64:67], a[36:39], 0
		v_accvgpr_read_b32 v17, a76
		v_add_u32_e32 v17, s43, v17
		v_mfma_f32_32x32x16_bf16 v[192:207], a[148:151], a[36:39], 0
		v_accvgpr_read_b32 v18, a79
		v_add_u32_e32 v18, s43, v18
		v_mfma_f32_32x32x16_bf16 v[208:223], a[164:167], a[36:39], 0
		v_accvgpr_read_b32 v19, a80
		v_add_u32_e32 v19, s43, v19
		v_mfma_f32_32x32x16_bf16 v[96:111], a[136:139], a[24:27], v[96:111]
		v_accvgpr_read_b32 v25, a83
		v_add_u32_e32 v25, s43, v25
		v_mfma_f32_32x32x16_bf16 v[112:127], a[152:155], a[24:27], v[112:127]
		v_accvgpr_read_b32 v26, a84
		v_add_u32_e32 v26, s43, v26
		v_mfma_f32_32x32x16_bf16 v[128:143], a[168:171], a[24:27], v[128:143]
		v_accvgpr_read_b32 v27, a87
		v_add_u32_e32 v27, s43, v27
		v_mfma_f32_32x32x16_bf16 v[144:159], a[180:183], a[24:27], v[144:159]
		v_accvgpr_read_b32 v28, a88
		v_add_u32_e32 v28, s43, v28
		v_mfma_f32_32x32x16_bf16 v[160:175], a[180:183], a[40:43], v[160:175]
		v_accvgpr_read_b32 v29, a91
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a64, v29
		v_mfma_f32_32x32x16_bf16 v[176:191], a[136:139], a[40:43], v[176:191]
		v_accvgpr_read_b32 v29, a92
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a65, v29
		v_mfma_f32_32x32x16_bf16 v[192:207], a[152:155], a[40:43], v[192:207]
		v_accvgpr_read_b32 v29, a95
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a66, v29
		v_mfma_f32_32x32x16_bf16 v[208:223], a[168:171], a[40:43], v[208:223]
		v_accvgpr_read_b32 v29, a96
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a67, v29
		v_mfma_f32_32x32x16_bf16 v[96:111], a[140:143], a[28:31], v[96:111]
		v_accvgpr_read_b32 v29, a99
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a68, v29
		v_mfma_f32_32x32x16_bf16 v[112:127], a[156:159], a[28:31], v[112:127]
		v_accvgpr_read_b32 v29, a100
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a70, v29
		v_mfma_f32_32x32x16_bf16 v[128:143], a[172:175], a[28:31], v[128:143]
		v_accvgpr_read_b32 v29, a103
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a71, v29
		v_mfma_f32_32x32x16_bf16 v[144:159], a[184:187], a[28:31], v[144:159]
		v_accvgpr_read_b32 v29, a104
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a72, v29
		v_mfma_f32_32x32x16_bf16 v[160:175], a[184:187], a[44:47], v[160:175]
		v_accvgpr_read_b32 v29, a107
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a133, v29
		v_mfma_f32_32x32x16_bf16 v[176:191], a[140:143], a[44:47], v[176:191]
		v_accvgpr_read_b32 v29, a108
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a134, v29
		v_mfma_f32_32x32x16_bf16 v[192:207], a[156:159], a[44:47], v[192:207]
		v_accvgpr_read_b32 v29, a111
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a135, v29
		v_mfma_f32_32x32x16_bf16 v[208:223], a[172:175], a[44:47], v[208:223]
		v_accvgpr_read_b32 v29, a112
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a136, v29
		v_mfma_f32_32x32x16_bf16 v[96:111], a[144:147], a[32:35], v[96:111]
		v_accvgpr_read_b32 v29, a115
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a137, v29
		v_mfma_f32_32x32x16_bf16 v[112:127], a[160:163], a[32:35], v[112:127]
		v_accvgpr_read_b32 v29, a116
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a138, v29
		v_mfma_f32_32x32x16_bf16 v[128:143], a[176:179], a[32:35], v[128:143]
		v_accvgpr_read_b32 v29, a119
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a139, v29
		v_mfma_f32_32x32x16_bf16 v[144:159], a[188:191], a[32:35], v[144:159]
		v_accvgpr_read_b32 v29, a120
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a140, v29
		v_mfma_f32_32x32x16_bf16 v[160:175], a[188:191], a[48:51], v[160:175]
		v_accvgpr_read_b32 v29, a123
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a141, v29
		v_mfma_f32_32x32x16_bf16 v[176:191], a[144:147], a[48:51], v[176:191]
		v_accvgpr_read_b32 v29, a124
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a142, v29
		v_mfma_f32_32x32x16_bf16 v[192:207], a[160:163], a[48:51], v[192:207]
		v_accvgpr_read_b32 v29, a127
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a143, v29
		v_mfma_f32_32x32x16_bf16 v[208:223], a[176:179], a[48:51], v[208:223]
		v_accvgpr_read_b32 v29, a128
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a144, v29
		v_accvgpr_read_b32 v29, a131
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a145, v29
		v_accvgpr_read_b32 v29, a132
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_write_b32 a146, v29
		v_cmp_ge_i32_e64 s[52:53], v2, v10
		v_cmp_ge_i32_e64 s[54:55], v2, v11
		v_cmp_ge_i32_e64 s[56:57], v2, v20
		v_cmp_ge_i32_e64 vcc, v2, v24
		v_accvgpr_read_b32 v29, a62
		v_add_u32_e32 v29, s43, v29
		v_accvgpr_read_b32 v30, a69
		v_add_u32_e32 v30, s43, v30
		v_cndmask_b32_e32 v225, v6, v99, vcc
		v_cmp_ge_i32_e64 s[58:59], v2, v29
		v_cmp_ge_i32_e64 s[60:61], v2, v30
		v_cmp_ge_i32_e64 s[62:63], v2, v16
		v_cmp_ge_i32_e64 vcc, v2, v17
		v_accvgpr_read_b32 v31, a77
		v_add_u32_e32 v31, s43, v31
		v_accvgpr_read_b32 v99, a78
		v_add_u32_e32 v99, s43, v99
		v_cndmask_b32_e32 v227, v6, v103, vcc
		v_cmp_ge_i32_e64 s[64:65], v2, v31
		v_cmp_ge_i32_e64 s[66:67], v2, v99
		v_cmp_ge_i32_e64 s[68:69], v2, v18
		v_cmp_ge_i32_e64 vcc, v2, v19
		v_accvgpr_read_b32 v103, a81
		v_add_u32_e32 v103, s43, v103
		v_accvgpr_read_b32 v224, a82
		v_add_u32_e32 v228, s43, v224
		v_cndmask_b32_e32 v231, v6, v107, vcc
		v_cmp_ge_i32_e64 s[70:71], v2, v103
		v_cmp_ge_i32_e64 s[72:73], v2, v228
		v_cmp_ge_i32_e64 s[74:75], v2, v25
		v_cmp_ge_i32_e64 vcc, v2, v26
		v_accvgpr_read_b32 v107, a85
		v_add_u32_e32 v107, s43, v107
		v_accvgpr_read_b32 v224, a86
		v_add_u32_e32 v229, s43, v224
		v_cndmask_b32_e32 v233, v6, v111, vcc
		v_cmp_ge_i32_e64 s[76:77], v2, v107
		v_cmp_ge_i32_e64 s[78:79], v2, v229
		v_cmp_ge_i32_e64 s[80:81], v2, v27
		v_cmp_ge_i32_e64 vcc, v2, v28
		v_accvgpr_read_b32 v111, a89
		v_add_u32_e32 v111, s43, v111
		v_accvgpr_read_b32 v224, a90
		v_add_u32_e32 v224, s43, v224
		v_accvgpr_write_b32 a147, v224
		v_cndmask_b32_e32 v235, v6, v115, vcc
		v_cmp_ge_i32_e64 s[82:83], v2, v111
		v_accvgpr_read_b32 v115, a147
		v_cmp_ge_i32_e64 s[84:85], v2, v115
		v_accvgpr_read_b32 v115, a64
		v_cmp_ge_i32_e64 s[86:87], v2, v115
		s_nop 1
		v_mov_b32_e32 v236, s86
		v_mov_b32_e32 v237, s87
		v_accvgpr_read_b32 v115, a65
		v_cmp_ge_i32_e64 vcc, v2, v115
		v_accvgpr_read_b32 v115, a93
		v_add_u32_e32 v115, s43, v115
		v_accvgpr_write_b32 a148, v115
		v_accvgpr_read_b32 v115, a94
		v_add_u32_e32 v115, s43, v115
		v_accvgpr_write_b32 a149, v115
		v_cndmask_b32_e32 v239, v6, v119, vcc
		v_accvgpr_read_b32 v115, a148
		v_cmp_ge_i32_e64 s[86:87], v2, v115
		s_nop 1
		v_mov_b32_e32 v240, s86
		v_mov_b32_e32 v241, s87
		v_accvgpr_write_b32 a150, v240
		v_accvgpr_write_b32 a151, v241
		v_accvgpr_read_b32 v115, a149
		v_cmp_ge_i32_e64 s[86:87], v2, v115
		s_nop 1
		v_mov_b32_e32 v240, s86
		v_mov_b32_e32 v241, s87
		v_accvgpr_write_b32 a152, v240
		v_accvgpr_write_b32 a153, v241
		v_accvgpr_read_b32 v115, a66
		v_cmp_ge_i32_e64 s[86:87], v2, v115
		s_nop 1
		v_mov_b32_e32 v240, s86
		v_mov_b32_e32 v241, s87
		v_accvgpr_write_b32 a154, v240
		v_accvgpr_write_b32 a155, v241
		v_accvgpr_read_b32 v115, a67
		v_cmp_ge_i32_e64 vcc, v2, v115
		v_accvgpr_read_b32 v115, a97
		v_add_u32_e32 v115, s43, v115
		v_accvgpr_write_b32 a156, v115
		v_accvgpr_read_b32 v115, a98
		v_add_u32_e32 v115, s43, v115
		v_accvgpr_write_b32 a157, v115
		v_cndmask_b32_e32 v241, v6, v123, vcc
		v_accvgpr_read_b32 v115, a156
		v_cmp_ge_i32_e64 s[86:87], v2, v115
		s_nop 1
		v_mov_b32_e32 v242, s86
		v_mov_b32_e32 v243, s87
		v_accvgpr_write_b32 a158, v242
		v_accvgpr_write_b32 a159, v243
		v_accvgpr_read_b32 v115, a157
		v_cmp_ge_i32_e64 s[86:87], v2, v115
		s_nop 1
		v_mov_b32_e32 v242, s86
		v_mov_b32_e32 v243, s87
		v_accvgpr_write_b32 a160, v242
		v_accvgpr_write_b32 a161, v243
		v_accvgpr_read_b32 v115, a68
		v_cmp_ge_i32_e64 s[86:87], v2, v115
		s_nop 1
		v_mov_b32_e32 v242, s86
		v_mov_b32_e32 v243, s87
		v_accvgpr_write_b32 a162, v242
		v_accvgpr_write_b32 a163, v243
		v_accvgpr_read_b32 v115, a70
		v_cmp_ge_i32_e64 vcc, v2, v115
		v_accvgpr_read_b32 v115, a101
		v_add_u32_e32 v115, s43, v115
		v_accvgpr_write_b32 a164, v115
		v_accvgpr_read_b32 v115, a102
		v_add_u32_e32 v115, s43, v115
		v_accvgpr_write_b32 a165, v115
		v_cndmask_b32_e32 v243, v6, v127, vcc
		v_accvgpr_read_b32 v115, a164
		v_cmp_ge_i32_e64 s[86:87], v2, v115
		s_nop 1
		v_mov_b32_e32 v244, s86
		v_mov_b32_e32 v245, s87
		v_accvgpr_write_b32 a166, v244
		v_accvgpr_write_b32 a167, v245
		v_accvgpr_read_b32 v115, a165
		v_cmp_ge_i32_e64 s[86:87], v2, v115
		s_nop 1
		v_mov_b32_e32 v244, s86
		v_mov_b32_e32 v245, s87
		v_accvgpr_write_b32 a168, v244
		v_accvgpr_write_b32 a169, v245
		v_accvgpr_read_b32 v115, a71
		v_cmp_ge_i32_e64 s[86:87], v2, v115
		s_nop 1
		v_mov_b32_e32 v244, s86
		v_mov_b32_e32 v245, s87
		v_accvgpr_write_b32 a170, v244
		v_accvgpr_write_b32 a171, v245
		v_accvgpr_read_b32 v115, a72
		v_cmp_ge_i32_e64 vcc, v2, v115
		v_accvgpr_read_b32 v115, a105
		v_add_u32_e32 v115, s43, v115
		v_accvgpr_write_b32 a172, v115
		v_accvgpr_read_b32 v115, a106
		v_add_u32_e32 v115, s43, v115
		v_accvgpr_write_b32 a173, v115
		v_cndmask_b32_e32 v245, v6, v131, vcc
		v_accvgpr_read_b32 v115, a172
		v_cmp_ge_i32_e64 s[86:87], v2, v115
		s_nop 1
		v_mov_b32_e32 v246, s86
		v_mov_b32_e32 v247, s87
		v_accvgpr_write_b32 a174, v246
		v_accvgpr_write_b32 a175, v247
		v_accvgpr_read_b32 v115, a173
		v_cmp_ge_i32_e64 s[86:87], v2, v115
		s_nop 1
		v_mov_b32_e32 v246, s86
		v_mov_b32_e32 v247, s87
		v_accvgpr_write_b32 a176, v246
		v_accvgpr_write_b32 a177, v247
		v_accvgpr_read_b32 v115, a133
		v_cmp_ge_i32_e64 s[86:87], v2, v115
		s_nop 1
		v_mov_b32_e32 v246, s86
		v_mov_b32_e32 v247, s87
		v_accvgpr_write_b32 a178, v246
		v_accvgpr_write_b32 a179, v247
		v_accvgpr_read_b32 v115, a134
		v_cmp_ge_i32_e64 vcc, v2, v115
		s_mov_b64 s[86:87], vcc
		v_mov_b32_e32 v246, s86
		v_mov_b32_e32 v247, s87
		v_accvgpr_read_b32 v115, a109
		v_add_u32_e32 v115, s43, v115
		v_accvgpr_write_b32 a180, v115
		v_accvgpr_read_b32 v115, a110
		v_add_u32_e32 v115, s43, v115
		v_accvgpr_write_b32 a181, v115
		v_cndmask_b32_e32 v247, v6, v135, vcc
		v_accvgpr_read_b32 v115, a180
		v_cmp_ge_i32_e64 s[86:87], v2, v115
		s_nop 1
		v_mov_b32_e32 v248, s86
		v_mov_b32_e32 v249, s87
		v_accvgpr_write_b32 a182, v248
		v_accvgpr_write_b32 a183, v249
		v_accvgpr_read_b32 v115, a181
		v_cmp_ge_i32_e64 s[86:87], v2, v115
		s_nop 1
		v_mov_b32_e32 v248, s86
		v_mov_b32_e32 v249, s87
		v_accvgpr_write_b32 a184, v248
		v_accvgpr_write_b32 a185, v249
		v_accvgpr_read_b32 v115, a135
		v_cmp_ge_i32_e64 s[86:87], v2, v115
		s_nop 1
		v_mov_b32_e32 v248, s86
		v_mov_b32_e32 v249, s87
		v_accvgpr_write_b32 a186, v248
		v_accvgpr_write_b32 a187, v249
		v_accvgpr_read_b32 v115, a136
		v_cmp_ge_i32_e64 vcc, v2, v115
		v_accvgpr_read_b32 v115, a113
		v_add_u32_e32 v115, s43, v115
		v_accvgpr_write_b32 a188, v115
		v_accvgpr_read_b32 v115, a114
		v_add_u32_e32 v115, s43, v115
		v_accvgpr_write_b32 a189, v115
		v_cndmask_b32_e32 v249, v6, v139, vcc
		v_accvgpr_read_b32 v115, a188
		v_cmp_ge_i32_e64 s[86:87], v2, v115
		s_nop 1
		v_mov_b32_e32 v250, s86
		v_mov_b32_e32 v251, s87
		v_accvgpr_write_b32 a190, v250
		v_accvgpr_write_b32 a191, v251
		v_accvgpr_read_b32 v115, a189
		v_cmp_ge_i32_e64 s[86:87], v2, v115
		v_accvgpr_read_b32 v115, a137
		v_cmp_ge_i32_e64 s[88:89], v2, v115
		v_cndmask_b32_e64 v251, v6, v141, s[86:87]
		s_nop 0
		v_cndmask_b32_e64 v252, v6, v142, s[88:89]
		v_accvgpr_read_b32 v115, a138
		v_cmp_ge_i32_e64 vcc, v2, v115
		v_accvgpr_read_b32 v115, a117
		v_add_u32_e32 v115, s43, v115
		v_accvgpr_read_b32 v119, a118
		v_add_u32_e32 v119, s43, v119
		v_cndmask_b32_e32 v253, v6, v143, vcc
		v_cmp_ge_i32_e64 s[86:87], v2, v115
		v_cmp_ge_i32_e64 s[88:89], v2, v119
		v_accvgpr_read_b32 v123, a139
		v_cmp_ge_i32_e64 s[90:91], v2, v123
		v_cndmask_b32_e64 v142, v6, v144, s[86:87]
		v_cndmask_b32_e64 v143, v6, v145, s[88:89]
		v_cndmask_b32_e64 v144, v6, v146, s[90:91]
		v_accvgpr_read_b32 v123, a140
		v_cmp_ge_i32_e64 vcc, v2, v123
		v_accvgpr_read_b32 v123, a121
		v_add_u32_e32 v123, s43, v123
		v_accvgpr_read_b32 v127, a122
		v_add_u32_e32 v127, s43, v127
		v_cndmask_b32_e32 v145, v6, v147, vcc
		v_cmp_ge_i32_e64 s[86:87], v2, v123
		v_cmp_ge_i32_e64 s[88:89], v2, v127
		v_accvgpr_read_b32 v131, a141
		v_cmp_ge_i32_e64 s[90:91], v2, v131
		v_cndmask_b32_e64 v146, v6, v148, s[86:87]
		v_cndmask_b32_e64 v147, v6, v149, s[88:89]
		v_cndmask_b32_e64 v148, v6, v150, s[90:91]
		v_accvgpr_read_b32 v131, a142
		v_cmp_ge_i32_e64 vcc, v2, v131
		v_accvgpr_read_b32 v131, a125
		v_add_u32_e32 v131, s43, v131
		v_accvgpr_read_b32 v135, a126
		v_add_u32_e32 v135, s43, v135
		v_cndmask_b32_e32 v149, v6, v151, vcc
		v_cmp_ge_i32_e64 s[86:87], v2, v131
		v_cmp_ge_i32_e64 s[88:89], v2, v135
		v_accvgpr_read_b32 v139, a143
		v_cmp_ge_i32_e64 s[90:91], v2, v139
		v_cndmask_b32_e64 v150, v6, v152, s[86:87]
		v_cndmask_b32_e64 v151, v6, v153, s[88:89]
		v_cndmask_b32_e64 v152, v6, v154, s[90:91]
		v_accvgpr_read_b32 v139, a144
		v_cmp_ge_i32_e64 vcc, v2, v139
		v_accvgpr_read_b32 v139, a129
		v_add_u32_e32 v139, s43, v139
		v_accvgpr_read_b32 v141, a130
		v_add_u32_e32 v141, s43, v141
		v_cndmask_b32_e32 v153, v6, v155, vcc
		v_cmp_ge_i32_e64 s[86:87], v2, v139
		v_cmp_ge_i32_e64 s[88:89], v2, v141
		v_accvgpr_read_b32 v154, a145
		v_cmp_ge_i32_e64 s[90:91], v2, v154
		v_cndmask_b32_e64 v154, v6, v156, s[86:87]
		v_cndmask_b32_e64 v155, v6, v157, s[88:89]
		v_cndmask_b32_e64 v156, v6, v158, s[90:91]
		v_accvgpr_read_b32 v157, a146
		v_cmp_ge_i32_e64 vcc, v2, v157
		v_cndmask_b32_e64 v254, v6, v96, s[52:53]
		v_cndmask_b32_e64 v255, v6, v97, s[54:55]
		v_cndmask_b32_e32 v157, v6, v159, vcc
		v_cmp_ge_i32_e64 s[52:53], v5, v10
		v_cmp_ge_i32_e64 s[54:55], v5, v11
		v_cmp_ge_i32_e64 s[86:87], v5, v20
		s_nop 1
		v_cndmask_b32_e64 v10, v6, v178, s[86:87]
		v_cmp_ge_i32_e64 vcc, v5, v24
		v_cndmask_b32_e64 v224, v6, v98, s[56:57]
		v_cndmask_b32_e64 v96, v6, v100, s[58:59]
		v_cndmask_b32_e32 v11, v6, v179, vcc
		v_cmp_ge_i32_e64 s[56:57], v5, v29
		v_cmp_ge_i32_e64 s[58:59], v5, v30
		v_cmp_ge_i32_e64 s[86:87], v5, v16
		v_cndmask_b32_e64 v158, v6, v180, s[56:57]
		v_cndmask_b32_e64 v159, v6, v181, s[58:59]
		v_cndmask_b32_e64 v178, v6, v182, s[86:87]
		v_cmp_ge_i32_e64 vcc, v5, v17
		v_cndmask_b32_e64 v97, v6, v101, s[60:61]
		v_cndmask_b32_e64 v226, v6, v102, s[62:63]
		v_cndmask_b32_e32 v179, v6, v183, vcc
		v_cmp_ge_i32_e64 s[56:57], v5, v31
		v_cmp_ge_i32_e64 s[58:59], v5, v99
		v_cmp_ge_i32_e64 s[60:61], v5, v18
		v_cndmask_b32_e64 v16, v6, v184, s[56:57]
		v_cndmask_b32_e64 v17, v6, v185, s[58:59]
		v_cndmask_b32_e64 v30, v6, v186, s[60:61]
		v_cmp_ge_i32_e64 vcc, v5, v19
		v_cndmask_b32_e64 v18, v6, v104, s[64:65]
		v_cndmask_b32_e64 v19, v6, v105, s[66:67]
		v_cndmask_b32_e32 v31, v6, v187, vcc
		v_cmp_ge_i32_e64 s[56:57], v5, v103
		v_cmp_ge_i32_e64 s[58:59], v5, v228
		v_cmp_ge_i32_e64 s[60:61], v5, v25
		v_cndmask_b32_e64 v24, v6, v188, s[56:57]
		v_cndmask_b32_e64 v25, v6, v189, s[58:59]
		v_cndmask_b32_e64 v98, v6, v190, s[60:61]
		v_cmp_ge_i32_e64 vcc, v5, v26
		v_cndmask_b32_e64 v230, v6, v106, s[68:69]
		v_cndmask_b32_e64 v100, v6, v108, s[70:71]
		v_cndmask_b32_e32 v99, v6, v191, vcc
		v_cmp_ge_i32_e64 s[56:57], v5, v107
		v_cmp_ge_i32_e64 s[58:59], v5, v229
		v_cmp_ge_i32_e64 s[60:61], v5, v27
		v_cndmask_b32_e64 v26, v6, v192, s[56:57]
		v_cndmask_b32_e64 v27, v6, v193, s[58:59]
		v_cndmask_b32_e64 v102, v6, v194, s[60:61]
		v_cmp_ge_i32_e64 vcc, v5, v28
		v_cndmask_b32_e64 v101, v6, v109, s[72:73]
		v_cndmask_b32_e64 v232, v6, v110, s[74:75]
		v_cndmask_b32_e32 v103, v6, v195, vcc
		v_cmp_ge_i32_e64 s[56:57], v5, v111
		v_accvgpr_read_b32 v20, a147
		v_cmp_ge_i32_e64 s[58:59], v5, v20
		v_accvgpr_read_b32 v20, a64
		v_cmp_ge_i32_e64 s[60:61], v5, v20
		v_cndmask_b32_e64 v28, v6, v196, s[56:57]
		v_cndmask_b32_e64 v29, v6, v197, s[58:59]
		v_cndmask_b32_e64 v104, v6, v198, s[60:61]
		v_accvgpr_read_b32 v20, a65
		v_cmp_ge_i32_e64 vcc, v5, v20
		v_cndmask_b32_e64 v106, v6, v112, s[76:77]
		v_cndmask_b32_e64 v107, v6, v113, s[78:79]
		v_cndmask_b32_e32 v105, v6, v199, vcc
		v_accvgpr_read_b32 v20, a148
		v_cmp_ge_i32_e64 s[56:57], v5, v20
		v_accvgpr_read_b32 v20, a149
		v_cmp_ge_i32_e64 s[58:59], v5, v20
		v_accvgpr_read_b32 v20, a66
		v_cmp_ge_i32_e64 s[60:61], v5, v20
		v_cndmask_b32_e64 v108, v6, v200, s[56:57]
		v_cndmask_b32_e64 v109, v6, v201, s[58:59]
		v_cndmask_b32_e64 v110, v6, v202, s[60:61]
		v_accvgpr_read_b32 v20, a67
		v_cmp_ge_i32_e64 vcc, v5, v20
		v_cndmask_b32_e64 v234, v6, v114, s[80:81]
		v_cndmask_b32_e64 v112, v6, v116, s[82:83]
		v_cndmask_b32_e32 v111, v6, v203, vcc
		v_accvgpr_read_b32 v20, a156
		v_cmp_ge_i32_e64 s[56:57], v5, v20
		v_accvgpr_read_b32 v20, a157
		v_cmp_ge_i32_e64 s[58:59], v5, v20
		v_accvgpr_read_b32 v20, a68
		v_cmp_ge_i32_e64 s[60:61], v5, v20
		v_cndmask_b32_e64 v180, v6, v204, s[56:57]
		v_cndmask_b32_e64 v181, v6, v205, s[58:59]
		v_cndmask_b32_e64 v182, v6, v206, s[60:61]
		v_accvgpr_read_b32 v20, a70
		v_cmp_ge_i32_e64 vcc, v5, v20
		v_cndmask_b32_e64 v113, v6, v117, s[84:85]
		v_readfirstlane_b32 s56, v236
		v_readfirstlane_b32 s57, v237
		s_nop 1
		v_cndmask_b32_e64 v238, v6, v118, s[56:57]
		v_cndmask_b32_e32 v183, v6, v207, vcc
		v_accvgpr_read_b32 v20, a164
		v_cmp_ge_i32_e64 s[56:57], v5, v20
		v_accvgpr_read_b32 v20, a165
		v_cmp_ge_i32_e64 s[58:59], v5, v20
		v_accvgpr_read_b32 v20, a71
		v_cmp_ge_i32_e64 s[60:61], v5, v20
		v_cndmask_b32_e64 v116, v6, v208, s[56:57]
		v_cndmask_b32_e64 v117, v6, v209, s[58:59]
		v_cndmask_b32_e64 v184, v6, v210, s[60:61]
		v_accvgpr_read_b32 v20, a72
		v_cmp_ge_i32_e64 vcc, v5, v20
		v_accvgpr_read_b32 v20, a150
		s_nop 0
		v_readfirstlane_b32 s56, v20
		v_accvgpr_read_b32 v20, a151
		s_nop 0
		v_readfirstlane_b32 s57, v20
		s_nop 1
		v_cndmask_b32_e64 v186, v6, v120, s[56:57]
		v_accvgpr_read_b32 v20, a152
		s_nop 0
		v_readfirstlane_b32 s56, v20
		v_accvgpr_read_b32 v20, a153
		s_nop 0
		v_readfirstlane_b32 s57, v20
		s_nop 1
		v_cndmask_b32_e64 v187, v6, v121, s[56:57]
		v_cndmask_b32_e32 v185, v6, v211, vcc
		v_accvgpr_read_b32 v20, a172
		v_cmp_ge_i32_e64 s[56:57], v5, v20
		v_accvgpr_read_b32 v20, a173
		v_cmp_ge_i32_e64 s[58:59], v5, v20
		v_accvgpr_read_b32 v20, a133
		v_cmp_ge_i32_e64 s[60:61], v5, v20
		v_cndmask_b32_e64 v120, v6, v212, s[56:57]
		v_cndmask_b32_e64 v121, v6, v213, s[58:59]
		v_cndmask_b32_e64 v188, v6, v214, s[60:61]
		v_accvgpr_read_b32 v20, a134
		v_cmp_ge_i32_e64 vcc, v5, v20
		v_accvgpr_read_b32 v20, a154
		s_nop 0
		v_readfirstlane_b32 s56, v20
		v_accvgpr_read_b32 v20, a155
		s_nop 0
		v_readfirstlane_b32 s57, v20
		s_nop 1
		v_cndmask_b32_e64 v240, v6, v122, s[56:57]
		v_accvgpr_read_b32 v20, a158
		s_nop 0
		v_readfirstlane_b32 s56, v20
		v_accvgpr_read_b32 v20, a159
		s_nop 0
		v_readfirstlane_b32 s57, v20
		s_nop 1
		v_cndmask_b32_e64 v190, v6, v124, s[56:57]
		v_cndmask_b32_e32 v189, v6, v215, vcc
		v_accvgpr_read_b32 v20, a180
		v_cmp_ge_i32_e64 s[56:57], v5, v20
		v_accvgpr_read_b32 v20, a181
		v_cmp_ge_i32_e64 s[58:59], v5, v20
		v_accvgpr_read_b32 v20, a135
		v_cmp_ge_i32_e64 s[60:61], v5, v20
		v_cndmask_b32_e64 v192, v6, v216, s[56:57]
		v_cndmask_b32_e64 v193, v6, v217, s[58:59]
		v_cndmask_b32_e64 v194, v6, v218, s[60:61]
		v_accvgpr_read_b32 v20, a136
		v_cmp_ge_i32_e64 vcc, v5, v20
		v_accvgpr_read_b32 v20, a160
		s_nop 0
		v_readfirstlane_b32 s56, v20
		v_accvgpr_read_b32 v20, a161
		s_nop 0
		v_readfirstlane_b32 s57, v20
		s_nop 1
		v_cndmask_b32_e64 v191, v6, v125, s[56:57]
		v_accvgpr_read_b32 v20, a162
		s_nop 0
		v_readfirstlane_b32 s56, v20
		v_accvgpr_read_b32 v20, a163
		s_nop 0
		v_readfirstlane_b32 s57, v20
		s_nop 1
		v_cndmask_b32_e64 v242, v6, v126, s[56:57]
		v_cndmask_b32_e32 v195, v6, v219, vcc
		v_accvgpr_read_b32 v20, a188
		v_cmp_ge_i32_e64 s[56:57], v5, v20
		v_accvgpr_read_b32 v20, a189
		v_cmp_ge_i32_e64 s[58:59], v5, v20
		v_accvgpr_read_b32 v20, a137
		v_cmp_ge_i32_e64 s[60:61], v5, v20
		v_cndmask_b32_e64 v124, v6, v220, s[56:57]
		v_cndmask_b32_e64 v125, v6, v221, s[58:59]
		v_cndmask_b32_e64 v196, v6, v222, s[60:61]
		v_accvgpr_read_b32 v20, a138
		v_cmp_ge_i32_e64 vcc, v5, v20
		v_accvgpr_read_b32 v20, a166
		s_nop 0
		v_readfirstlane_b32 s56, v20
		v_accvgpr_read_b32 v20, a167
		s_nop 0
		v_readfirstlane_b32 s57, v20
		s_nop 1
		v_cndmask_b32_e64 v198, v6, v128, s[56:57]
		v_accvgpr_read_b32 v20, a168
		s_nop 0
		v_readfirstlane_b32 s56, v20
		v_accvgpr_read_b32 v20, a169
		s_nop 0
		v_readfirstlane_b32 s57, v20
		s_nop 1
		v_cndmask_b32_e64 v199, v6, v129, s[56:57]
		v_cndmask_b32_e32 v197, v6, v223, vcc
		v_cmp_ge_i32_e64 s[56:57], v5, v115
		v_cmp_ge_i32_e64 s[58:59], v5, v119
		v_accvgpr_read_b32 v20, a139
		v_cmp_ge_i32_e64 s[60:61], v5, v20
		v_cndmask_b32_e64 v114, v6, v160, s[56:57]
		v_cndmask_b32_e64 v115, v6, v161, s[58:59]
		v_cndmask_b32_e64 v118, v6, v162, s[60:61]
		v_accvgpr_read_b32 v20, a140
		v_cmp_ge_i32_e64 vcc, v5, v20
		v_accvgpr_read_b32 v20, a170
		s_nop 0
		v_readfirstlane_b32 s56, v20
		v_accvgpr_read_b32 v20, a171
		s_nop 0
		v_readfirstlane_b32 s57, v20
		s_nop 1
		v_cndmask_b32_e64 v244, v6, v130, s[56:57]
		v_accvgpr_read_b32 v20, a174
		s_nop 0
		v_readfirstlane_b32 s56, v20
		v_accvgpr_read_b32 v20, a175
		s_nop 0
		v_readfirstlane_b32 s57, v20
		s_nop 1
		v_cndmask_b32_e64 v128, v6, v132, s[56:57]
		v_cndmask_b32_e32 v119, v6, v163, vcc
		v_cmp_ge_i32_e64 s[56:57], v5, v123
		v_cmp_ge_i32_e64 s[58:59], v5, v127
		v_accvgpr_read_b32 v20, a141
		v_cmp_ge_i32_e64 s[60:61], v5, v20
		v_cndmask_b32_e64 v122, v6, v164, s[56:57]
		v_cndmask_b32_e64 v123, v6, v165, s[58:59]
		v_cndmask_b32_e64 v126, v6, v166, s[60:61]
		v_accvgpr_read_b32 v20, a142
		v_cmp_ge_i32_e64 vcc, v5, v20
		v_accvgpr_read_b32 v20, a176
		s_nop 0
		v_readfirstlane_b32 s56, v20
		v_accvgpr_read_b32 v20, a177
		s_nop 0
		v_readfirstlane_b32 s57, v20
		s_nop 1
		v_cndmask_b32_e64 v129, v6, v133, s[56:57]
		v_accvgpr_read_b32 v20, a178
		s_nop 0
		v_readfirstlane_b32 s56, v20
		v_accvgpr_read_b32 v20, a179
		s_nop 0
		v_readfirstlane_b32 s57, v20
		s_nop 1
		v_cndmask_b32_e64 v246, v6, v134, s[56:57]
		v_cndmask_b32_e32 v127, v6, v167, vcc
		v_cmp_ge_i32_e64 s[56:57], v5, v131
		v_cmp_ge_i32_e64 s[58:59], v5, v135
		v_accvgpr_read_b32 v20, a143
		v_cmp_ge_i32_e64 s[60:61], v5, v20
		v_cndmask_b32_e64 v130, v6, v168, s[56:57]
		v_cndmask_b32_e64 v131, v6, v169, s[58:59]
		v_cndmask_b32_e64 v132, v6, v170, s[60:61]
		v_accvgpr_read_b32 v20, a144
		v_cmp_ge_i32_e64 vcc, v5, v20
		v_accvgpr_read_b32 v20, a182
		s_nop 0
		v_readfirstlane_b32 s56, v20
		v_accvgpr_read_b32 v20, a183
		s_nop 0
		v_readfirstlane_b32 s57, v20
		s_nop 1
		v_cndmask_b32_e64 v134, v6, v136, s[56:57]
		v_accvgpr_read_b32 v20, a184
		s_nop 0
		v_readfirstlane_b32 s56, v20
		v_accvgpr_read_b32 v20, a185
		s_nop 0
		v_readfirstlane_b32 s57, v20
		s_nop 1
		v_cndmask_b32_e64 v135, v6, v137, s[56:57]
		v_cndmask_b32_e32 v133, v6, v171, vcc
		v_cmp_ge_i32_e64 s[56:57], v5, v139
		v_cmp_ge_i32_e64 s[58:59], v5, v141
		v_accvgpr_read_b32 v20, a145
		v_cmp_ge_i32_e64 s[60:61], v5, v20
		v_cndmask_b32_e64 v136, v6, v172, s[56:57]
		v_cndmask_b32_e64 v137, v6, v173, s[58:59]
		v_cndmask_b32_e64 v160, v6, v174, s[60:61]
		v_accvgpr_read_b32 v20, a146
		v_cmp_ge_i32_e64 vcc, v5, v20
		v_accvgpr_read_b32 v20, a186
		s_nop 0
		v_readfirstlane_b32 s56, v20
		v_accvgpr_read_b32 v20, a187
		s_nop 0
		v_readfirstlane_b32 s57, v20
		s_nop 1
		v_cndmask_b32_e64 v248, v6, v138, s[56:57]
		v_accvgpr_read_b32 v20, a190
		s_nop 0
		v_readfirstlane_b32 s56, v20
		v_accvgpr_read_b32 v20, a191
		s_nop 0
		v_readfirstlane_b32 s57, v20
		s_nop 1
		v_cndmask_b32_e64 v250, v6, v140, s[56:57]
		v_cndmask_b32_e32 v161, v6, v175, vcc
		v_max3_f32 v20, v254, v255, v224
		v_max3_f32 v138, v96, v97, v226
		v_max3_f32 v139, v18, v19, v230
		v_max3_f32 v140, v100, v101, v232
		v_max3_f32 v141, v106, v107, v234
		v_max3_f32 v162, v112, v113, v238
		v_max3_f32 v163, v186, v187, v240
		v_max3_f32 v164, v190, v191, v242
		v_max3_f32 v165, v198, v199, v244
		v_max3_f32 v166, v128, v129, v246
		v_max3_f32 v167, v134, v135, v248
		v_max3_f32 v168, v250, v251, v252
		v_max3_f32 v169, v142, v143, v144
		v_max3_f32 v170, v146, v147, v148
		v_max3_f32 v171, v150, v151, v152
		v_max3_f32 v172, v154, v155, v156
		v_max3_f32 v20, v20, v225, v138
		v_max3_f32 v138, v139, v231, v140
		v_max3_f32 v139, v141, v235, v162
		v_max3_f32 v140, v163, v241, v164
		v_max3_f32 v141, v165, v245, v166
		v_max3_f32 v162, v167, v249, v168
		v_max3_f32 v163, v169, v145, v170
		v_max3_f32 v164, v171, v153, v172
		v_max3_f32 v20, v20, v227, v138
		v_max3_f32 v138, v139, v239, v140
		v_max3_f32 v139, v141, v247, v162
		v_max3_f32 v140, v163, v149, v164
		v_max3_f32 v20, v20, v233, v138
		v_max3_f32 v138, v139, v253, v140
		v_max3_f32 v20, v20, v243, v138
		v_max_f32_e32 v138, v20, v157
		v_mov_b32_e32 v139, v138
		v_cndmask_b32_e64 v140, v6, v176, s[52:53]
		v_cndmask_b32_e64 v141, v6, v177, s[54:55]
		v_permlane32_swap_b32_e32 v138, v139
		v_max3_f32 v20, v140, v141, v10
		v_max3_f32 v162, v158, v159, v178
		v_max3_f32 v163, v16, v17, v30
		v_max3_f32 v164, v24, v25, v98
		v_max3_f32 v165, v26, v27, v102
		v_max3_f32 v166, v28, v29, v104
		v_max3_f32 v167, v108, v109, v110
		v_max3_f32 v168, v180, v181, v182
		v_max3_f32 v169, v116, v117, v184
		v_max3_f32 v170, v120, v121, v188
		v_max3_f32 v171, v192, v193, v194
		v_max3_f32 v172, v124, v125, v196
		v_max3_f32 v173, v114, v115, v118
		v_max3_f32 v174, v122, v123, v126
		v_max3_f32 v175, v130, v131, v132
		v_max3_f32 v176, v136, v137, v160
		v_max3_f32 v20, v20, v11, v162
		v_max3_f32 v162, v163, v31, v164
		v_max3_f32 v163, v165, v103, v166
		v_max3_f32 v164, v167, v111, v168
		v_max3_f32 v165, v169, v185, v170
		v_max3_f32 v166, v171, v195, v172
		v_max3_f32 v167, v173, v119, v174
		v_max3_f32 v168, v175, v133, v176
		v_max3_f32 v20, v20, v179, v162
		v_max3_f32 v162, v163, v105, v164
		v_max3_f32 v163, v165, v189, v166
		v_max3_f32 v164, v167, v127, v168
		v_max3_f32 v20, v20, v99, v162
		v_max3_f32 v162, v163, v197, v164
		v_max3_f32 v20, v20, v183, v162
		v_max_f32_e32 v162, v20, v161
		v_mov_b32_e32 v163, v162
		v_max_f32_e32 v164, v138, v139
		s_add_i32 s19, s43, 0x80
		s_cmp_lt_i32 s19, s24
		v_permlane32_swap_b32_e32 v162, v163
		v_max_f32_e32 v165, v162, v163
		v_pk_mul_f32 v[138:139], v[164:165], v[12:13]
		v_max_f32_e32 v162, v3, v138
		v_max_f32_e32 v163, v7, v139
		v_pk_fma_f32 v[138:139], v[254:255], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[164:165], v[224:225], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[166:167], v[96:97], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[96:97], v[226:227], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[168:169], v[18:19], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[18:19], v[230:231], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[170:171], v[100:101], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[100:101], v[232:233], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[172:173], v[106:107], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[106:107], v[234:235], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[174:175], v[112:113], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[112:113], v[238:239], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[176:177], v[186:187], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[186:187], v[240:241], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[200:201], v[190:191], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[190:191], v[242:243], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[202:203], v[198:199], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[198:199], v[244:245], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[204:205], v[128:129], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[128:129], v[246:247], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[206:207], v[134:135], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[134:135], v[248:249], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[208:209], v[250:251], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[210:211], v[252:253], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[212:213], v[142:143], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[142:143], v[144:145], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[144:145], v[146:147], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[146:147], v[148:149], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[148:149], v[150:151], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[150:151], v[152:153], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[152:153], v[154:155], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[154:155], v[156:157], v[12:13], v[162:163] op_sel_hi:[1,1,0] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[156:157], v[140:141], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[140:141], v[10:11], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[10:11], v[158:159], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[158:159], v[178:179], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[178:179], v[16:17], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[16:17], v[30:31], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[30:31], v[24:25], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[24:25], v[98:99], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[98:99], v[26:27], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[26:27], v[102:103], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[102:103], v[28:29], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[28:29], v[104:105], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[104:105], v[108:109], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[108:109], v[110:111], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[110:111], v[180:181], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[180:181], v[182:183], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[182:183], v[116:117], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[116:117], v[184:185], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[184:185], v[120:121], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[120:121], v[188:189], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[188:189], v[192:193], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[192:193], v[194:195], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[194:195], v[124:125], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[124:125], v[196:197], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[196:197], v[114:115], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[114:115], v[118:119], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[118:119], v[122:123], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[122:123], v[126:127], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[126:127], v[130:131], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[130:131], v[132:133], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[132:133], v[136:137], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_pk_fma_f32 v[136:137], v[160:161], v[12:13], v[162:163] op_sel:[0,0,1] neg_lo:[0,0,1] neg_hi:[0,0,1]
		v_exp_f32_e32 v160, v138
		v_exp_f32_e32 v214, v139
		v_exp_f32_e32 v138, v164
		v_exp_f32_e32 v216, v165
		v_exp_f32_e32 v164, v166
		v_exp_f32_e32 v218, v167
		v_exp_f32_e32 v166, v96
		v_exp_f32_e32 v220, v97
		v_exp_f32_e32 v96, v168
		v_exp_f32_e32 v222, v169
		v_exp_f32_e32 v168, v18
		v_exp_f32_e32 v224, v19
		v_exp_f32_e32 v18, v170
		v_exp_f32_e32 v226, v171
		v_exp_f32_e32 v170, v100
		v_exp_f32_e32 v228, v101
		v_exp_f32_e32 v100, v172
		v_exp_f32_e32 v230, v173
		v_exp_f32_e32 v172, v106
		v_exp_f32_e32 v232, v107
		v_exp_f32_e32 v106, v174
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
		v_exp_f32_e32 v161, v202
		v_exp_f32_e32 v215, v203
		v_exp_f32_e32 v139, v198
		v_exp_f32_e32 v217, v199
		v_exp_f32_e32 v165, v204
		v_exp_f32_e32 v219, v205
		v_exp_f32_e32 v167, v128
		v_exp_f32_e32 v221, v129
		v_exp_f32_e32 v97, v206
		v_exp_f32_e32 v223, v207
		v_exp_f32_e32 v169, v134
		v_exp_f32_e32 v225, v135
		v_exp_f32_e32 v19, v208
		v_exp_f32_e32 v227, v209
		v_exp_f32_e32 v171, v210
		v_exp_f32_e32 v229, v211
		v_exp_f32_e32 v101, v212
		v_exp_f32_e32 v231, v213
		v_exp_f32_e32 v173, v142
		v_exp_f32_e32 v233, v143
		v_exp_f32_e32 v107, v144
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
		v_exp_f32_e32 v128, v156
		v_exp_f32_e32 v134, v157
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
		v_exp_f32_e32 v16, v30
		v_exp_f32_e32 v158, v31
		v_exp_f32_e32 v30, v24
		v_exp_f32_e32 v178, v25
		v_exp_f32_e32 v24, v98
		v_exp_f32_e32 v190, v99
		v_exp_f32_e32 v98, v26
		v_exp_f32_e32 v198, v27
		v_exp_f32_e32 v26, v102
		v_exp_f32_e32 v202, v103
		v_exp_f32_e32 v102, v28
		v_exp_f32_e32 v204, v29
		v_exp_f32_e32 v28, v104
		v_exp_f32_e32 v206, v105
		v_exp_f32_e32 v104, v108
		v_exp_f32_e32 v208, v109
		v_exp_f32_e32 v108, v110
		v_exp_f32_e32 v210, v111
		v_exp_f32_e32 v110, v180
		v_exp_f32_e32 v212, v181
		v_exp_f32_e32 v129, v182
		v_exp_f32_e32 v135, v183
		v_exp_f32_e32 v143, v116
		v_exp_f32_e32 v145, v117
		v_exp_f32_e32 v141, v184
		v_exp_f32_e32 v147, v185
		v_exp_f32_e32 v11, v120
		v_exp_f32_e32 v149, v121
		v_exp_f32_e32 v151, v188
		v_exp_f32_e32 v153, v189
		v_exp_f32_e32 v155, v192
		v_exp_f32_e32 v157, v193
		v_exp_f32_e32 v17, v194
		v_exp_f32_e32 v159, v195
		v_exp_f32_e32 v31, v124
		v_exp_f32_e32 v179, v125
		v_exp_f32_e32 v25, v196
		v_exp_f32_e32 v191, v197
		v_exp_f32_e32 v99, v114
		v_exp_f32_e32 v199, v115
		v_exp_f32_e32 v27, v118
		v_exp_f32_e32 v203, v119
		v_exp_f32_e32 v103, v122
		v_exp_f32_e32 v205, v123
		v_exp_f32_e32 v29, v126
		v_exp_f32_e32 v207, v127
		v_exp_f32_e32 v105, v130
		v_exp_f32_e32 v209, v131
		v_exp_f32_e32 v109, v132
		v_exp_f32_e32 v211, v133
		v_exp_f32_e32 v111, v136
		v_exp_f32_e32 v213, v137
		v_pk_add_f32 v[114:115], v[160:161], v[214:215]
		v_pk_add_f32 v[116:117], v[138:139], v[216:217]
		v_pk_add_f32 v[118:119], v[164:165], v[218:219]
		v_pk_add_f32 v[120:121], v[166:167], v[220:221]
		v_pk_add_f32 v[122:123], v[96:97], v[222:223]
		v_pk_add_f32 v[124:125], v[168:169], v[224:225]
		v_pk_add_f32 v[126:127], v[18:19], v[226:227]
		v_pk_add_f32 v[130:131], v[170:171], v[228:229]
		v_pk_add_f32 v[132:133], v[100:101], v[230:231]
		v_pk_add_f32 v[136:137], v[172:173], v[232:233]
		v_pk_add_f32 v[180:181], v[106:107], v[234:235]
		v_pk_add_f32 v[182:183], v[174:175], v[236:237]
		v_pk_add_f32 v[184:185], v[112:113], v[238:239]
		v_pk_add_f32 v[188:189], v[176:177], v[240:241]
		v_pk_add_f32 v[192:193], v[186:187], v[242:243]
		v_pk_add_f32 v[194:195], v[200:201], v[244:245]
		v_pk_add_f32 v[114:115], v[114:115], v[116:117]
		v_pk_add_f32 v[116:117], v[118:119], v[120:121]
		v_pk_add_f32 v[118:119], v[122:123], v[124:125]
		v_pk_add_f32 v[120:121], v[126:127], v[130:131]
		v_pk_add_f32 v[122:123], v[132:133], v[136:137]
		v_pk_add_f32 v[124:125], v[180:181], v[182:183]
		v_pk_add_f32 v[126:127], v[184:185], v[188:189]
		v_pk_add_f32 v[130:131], v[192:193], v[194:195]
		v_pk_add_f32 v[114:115], v[114:115], v[116:117]
		v_pk_add_f32 v[116:117], v[118:119], v[120:121]
		v_pk_add_f32 v[118:119], v[122:123], v[124:125]
		v_pk_add_f32 v[120:121], v[126:127], v[130:131]
		v_pk_add_f32 v[114:115], v[114:115], v[116:117]
		v_pk_add_f32 v[116:117], v[118:119], v[120:121]
		v_pk_add_f32 v[118:119], v[114:115], v[116:117]
		v_add_f32_e32 v20, v118, v119
		v_accvgpr_read_b32 v114, a73
		ds_bpermute_b32 v116, v114, v20
		v_accvgpr_read_b32 v114, a74
		ds_bpermute_b32 v118, v114, v20
		v_pk_add_f32 v[114:115], v[128:129], v[134:135]
		v_pk_add_f32 v[120:121], v[142:143], v[144:145]
		v_pk_add_f32 v[122:123], v[140:141], v[146:147]
		v_pk_add_f32 v[124:125], v[10:11], v[148:149]
		v_pk_add_f32 v[126:127], v[150:151], v[152:153]
		v_pk_add_f32 v[130:131], v[154:155], v[156:157]
		v_pk_add_f32 v[132:133], v[16:17], v[158:159]
		v_pk_add_f32 v[136:137], v[30:31], v[178:179]
		v_pk_add_f32 v[180:181], v[24:25], v[190:191]
		v_pk_add_f32 v[182:183], v[98:99], v[198:199]
		v_pk_add_f32 v[184:185], v[26:27], v[202:203]
		v_pk_add_f32 v[188:189], v[102:103], v[204:205]
		v_pk_add_f32 v[192:193], v[28:29], v[206:207]
		v_pk_add_f32 v[194:195], v[104:105], v[208:209]
		v_pk_add_f32 v[196:197], v[108:109], v[210:211]
		v_pk_add_f32 v[246:247], v[110:111], v[212:213]
		v_pk_add_f32 v[114:115], v[114:115], v[120:121]
		v_pk_add_f32 v[120:121], v[122:123], v[124:125]
		v_pk_add_f32 v[122:123], v[126:127], v[130:131]
		v_pk_add_f32 v[124:125], v[132:133], v[136:137]
		v_pk_add_f32 v[126:127], v[180:181], v[182:183]
		v_pk_add_f32 v[130:131], v[184:185], v[188:189]
		v_pk_add_f32 v[132:133], v[192:193], v[194:195]
		v_pk_add_f32 v[136:137], v[196:197], v[246:247]
		v_pk_add_f32 v[114:115], v[114:115], v[120:121]
		v_pk_add_f32 v[120:121], v[122:123], v[124:125]
		v_pk_add_f32 v[122:123], v[126:127], v[130:131]
		v_pk_add_f32 v[124:125], v[132:133], v[136:137]
		v_pk_add_f32 v[114:115], v[114:115], v[120:121]
		v_pk_add_f32 v[120:121], v[122:123], v[124:125]
		v_pk_add_f32 v[122:123], v[114:115], v[120:121]
		v_mov_b32_e32 v119, v123
		v_mov_b32_e32 v117, v122
		s_waitcnt lgkmcnt(0)
		v_pk_add_f32 v[114:115], v[116:117], v[118:119]
		v_mov_b32_e32 v116, v115
		v_mov_b32_e32 v117, v115
		v_cvt_pk_bf16_f32 v120, v160, v214
		v_cvt_pk_bf16_f32 v121, v138, v216
		v_permlane32_swap_b32_e32 v116, v117
		v_add_f32_e32 v119, v116, v117
		v_mov_b32_e32 v116, v3
		v_mov_b32_e32 v117, v7
		v_pk_add_f32 v[122:123], v[116:117], v[162:163] neg_lo:[0,1] neg_hi:[0,1]
		v_exp_f32_e32 v116, v122
		v_exp_f32_e32 v117, v123
		v_cvt_pk_bf16_f32 v122, v164, v218
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
		v_cvt_pk_bf16_f32 v123, v166, v220
		v_cvt_pk_bf16_f32 v116, v96, v222
		v_cvt_pk_bf16_f32 v117, v168, v224
		v_cvt_pk_bf16_f32 v118, v18, v226
		v_cvt_pk_bf16_f32 v119, v170, v228
		v_cvt_pk_bf16_f32 v124, v100, v230
		v_cvt_pk_bf16_f32 v125, v172, v232
		v_cvt_pk_bf16_f32 v126, v106, v234
		v_cvt_pk_bf16_f32 v127, v174, v236
		v_cvt_pk_bf16_f32 v180, v112, v238
		v_cvt_pk_bf16_f32 v181, v176, v240
		v_cvt_pk_bf16_f32 v182, v186, v242
		v_cvt_pk_bf16_f32 v183, v200, v244
		v_cvt_pk_bf16_f32 v192, v161, v215
		v_cvt_pk_bf16_f32 v193, v139, v217
		v_cvt_pk_bf16_f32 v194, v165, v219
		v_cvt_pk_bf16_f32 v195, v167, v221
		v_cvt_pk_bf16_f32 v136, v97, v223
		v_cvt_pk_bf16_f32 v137, v169, v225
		v_cvt_pk_bf16_f32 v138, v19, v227
		v_cvt_pk_bf16_f32 v139, v171, v229
		v_cvt_pk_bf16_f32 v164, v101, v231
		v_cvt_pk_bf16_f32 v165, v173, v233
		v_cvt_pk_bf16_f32 v166, v107, v235
		v_cvt_pk_bf16_f32 v167, v175, v237
		v_cvt_pk_bf16_f32 v168, v113, v239
		v_cvt_pk_bf16_f32 v169, v177, v241
		v_cvt_pk_bf16_f32 v170, v187, v243
		v_cvt_pk_bf16_f32 v171, v201, v245
		v_cvt_pk_bf16_f32 v112, v128, v134
		v_cvt_pk_bf16_f32 v113, v142, v144
		v_cvt_pk_bf16_f32 v114, v140, v146
		v_cvt_pk_bf16_f32 v115, v10, v148
		v_cvt_pk_bf16_f32 v172, v150, v152
		v_cvt_pk_bf16_f32 v173, v154, v156
		v_cvt_pk_bf16_f32 v174, v16, v158
		v_cvt_pk_bf16_f32 v175, v30, v178
		v_cvt_pk_bf16_f32 v184, v24, v190
		v_cvt_pk_bf16_f32 v185, v98, v198
		v_cvt_pk_bf16_f32 v186, v26, v202
		v_cvt_pk_bf16_f32 v187, v102, v204
		v_cvt_pk_bf16_f32 v216, v28, v206
		v_cvt_pk_bf16_f32 v217, v104, v208
		v_cvt_pk_bf16_f32 v218, v108, v210
		v_cvt_pk_bf16_f32 v219, v110, v212
		v_cvt_pk_bf16_f32 v220, v129, v135
		v_cvt_pk_bf16_f32 v221, v143, v145
		v_cvt_pk_bf16_f32 v222, v141, v147
		v_cvt_pk_bf16_f32 v223, v11, v149
		v_cvt_pk_bf16_f32 v128, v151, v153
		v_cvt_pk_bf16_f32 v129, v155, v157
		v_cvt_pk_bf16_f32 v130, v17, v159
		v_cvt_pk_bf16_f32 v131, v31, v179
		v_cvt_pk_bf16_f32 v16, v25, v191
		v_cvt_pk_bf16_f32 v17, v99, v199
		v_cvt_pk_bf16_f32 v18, v27, v203
		v_cvt_pk_bf16_f32 v19, v103, v205
		v_cvt_pk_bf16_f32 v24, v29, v207
		v_cvt_pk_bf16_f32 v25, v105, v209
		v_cvt_pk_bf16_f32 v26, v109, v211
		v_cvt_pk_bf16_f32 v27, v111, v213
		v_permlane32_swap_b32_e32 v120, v122
		v_permlane32_swap_b32_e32 v121, v123
		v_permlane32_swap_b32_e32 v116, v118
		v_permlane32_swap_b32_e32 v117, v119
		s_nop 0
		v_mfma_f32_32x32x16_bf16 v[32:47], a[192:195], v[120:123], v[32:47]
		v_permlane32_swap_b32_e32 v124, v126
		v_permlane32_swap_b32_e32 v125, v127
		v_mfma_f32_32x32x16_bf16 v[48:63], a[224:227], v[120:123], v[48:63]
		v_permlane32_swap_b32_e32 v180, v182
		v_permlane32_swap_b32_e32 v181, v183
		v_mfma_f32_32x32x16_bf16 v[32:47], a[196:199], v[116:119], v[32:47]
		v_permlane32_swap_b32_e32 v192, v194
		v_permlane32_swap_b32_e32 v193, v195
		v_mfma_f32_32x32x16_bf16 v[48:63], a[228:231], v[116:119], v[48:63]
		v_permlane32_swap_b32_e32 v136, v138
		v_permlane32_swap_b32_e32 v137, v139
		v_mfma_f32_32x32x16_bf16 v[32:47], a[200:203], v[124:127], v[32:47]
		v_permlane32_swap_b32_e32 v164, v166
		v_permlane32_swap_b32_e32 v165, v167
		v_mfma_f32_32x32x16_bf16 v[48:63], a[232:235], v[124:127], v[48:63]
		v_permlane32_swap_b32_e32 v168, v170
		v_permlane32_swap_b32_e32 v169, v171
		v_mfma_f32_32x32x16_bf16 v[32:47], a[204:207], v[180:183], v[32:47]
		v_permlane32_swap_b32_e32 v112, v114
		v_permlane32_swap_b32_e32 v113, v115
		v_mfma_f32_32x32x16_bf16 v[48:63], a[236:239], v[180:183], v[48:63]
		v_permlane32_swap_b32_e32 v172, v174
		v_permlane32_swap_b32_e32 v173, v175
		v_mfma_f32_32x32x16_bf16 v[80:95], a[224:227], v[112:115], v[80:95]
		v_permlane32_swap_b32_e32 v184, v186
		v_permlane32_swap_b32_e32 v185, v187
		v_mfma_f32_32x32x16_bf16 v[64:79], a[192:195], v[112:115], v[64:79]
		v_permlane32_swap_b32_e32 v216, v218
		v_permlane32_swap_b32_e32 v217, v219
		v_mfma_f32_32x32x16_bf16 v[80:95], a[228:231], v[172:175], v[80:95]
		v_permlane32_swap_b32_e32 v220, v222
		v_permlane32_swap_b32_e32 v221, v223
		v_mfma_f32_32x32x16_bf16 v[64:79], a[196:199], v[172:175], v[64:79]
		v_permlane32_swap_b32_e32 v128, v130
		v_permlane32_swap_b32_e32 v129, v131
		v_mfma_f32_32x32x16_bf16 v[80:95], a[232:235], v[184:187], v[80:95]
		v_permlane32_swap_b32_e32 v16, v18
		v_permlane32_swap_b32_e32 v17, v19
		v_mfma_f32_32x32x16_bf16 v[64:79], a[200:203], v[184:187], v[64:79]
		v_permlane32_swap_b32_e32 v24, v26
		v_permlane32_swap_b32_e32 v25, v27
		v_mfma_f32_32x32x16_bf16 v[80:95], a[236:239], v[216:219], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[204:207], v[216:219], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[208:211], v[192:195], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[240:243], v[192:195], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[240:243], v[220:223], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[208:211], v[220:223], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[212:215], v[136:139], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[244:247], v[136:139], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[244:247], v[128:131], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[212:215], v[128:131], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[216:219], v[164:167], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[248:251], v[164:167], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[248:251], v[16:19], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[216:219], v[16:19], v[64:79]
		v_mfma_f32_32x32x16_bf16 v[32:47], a[220:223], v[168:171], v[32:47]
		v_mfma_f32_32x32x16_bf16 v[48:63], a[252:255], v[168:171], v[48:63]
		v_mfma_f32_32x32x16_bf16 v[80:95], a[252:255], v[24:27], v[80:95]
		v_mfma_f32_32x32x16_bf16 v[64:79], a[220:223], v[24:27], v[64:79]
		s_mov_b32 s43, s19
		v_mov_b32_e32 v3, v162
		v_mov_b32_e32 v7, v163
		s_cbranch_scc1 .L_attn_fwd_persistent.loop_head_4
.L_attn_fwd_persistent.loop_exit_4:
		s_mov_b32 s28, s8
		s_mov_b32 s29, s9
		s_mov_b32 s30, s26
		s_mov_b32 s31, s27
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
		v_accvgpr_read_b32 v2, a9
		s_nop 0
		v_readfirstlane_b32 s1, v2
		s_mul_i32 s1, s1, s18
		s_lshl_b32 s1, s1, 9
		v_accvgpr_read_b32 v2, a2
		s_nop 0
		v_readfirstlane_b32 s19, v2
		v_accvgpr_read_b32 v2, a13
		s_nop 0
		v_readfirstlane_b32 s23, v2
		s_mul_i32 s19, s23, s19
		s_lshl_b32 s19, s19, 1
		s_add_i32 s23, s1, s19
		v_accvgpr_read_b32 v2, a3
		s_nop 0
		v_readfirstlane_b32 s24, v2
		v_mov_b32_e32 v2, s22
		s_nop 0
		v_readfirstlane_b32 s22, v2
		s_mul_i32 s22, s22, s24
		s_lshl_b32 s22, s22, 1
		s_add_i32 s23, s23, s22
		v_accvgpr_read_b32 v2, a10
		v_mul_lo_u32 v2, s18, v2
		v_lshl_add_u32 v3, v2, 6, s23
		v_accvgpr_read_b32 v20, a14
		v_mul_lo_u32 v20, s18, v20
		v_lshl_add_u32 v3, v20, 1, v3
		v_accvgpr_read_b32 v21, a18
		v_mul_lo_u32 v21, s18, v21
		v_lshl_add_u32 v3, v21, 5, v3
		v_accvgpr_read_b32 v36, a55
		v_mul_lo_u32 v36, s18, v36
		v_lshl_add_u32 v3, v36, 4, v3
		v_accvgpr_read_b32 v37, a15
		v_mul_lo_u32 v37, s18, v37
		v_lshl_add_u32 v3, v37, 3, v3
		v_accvgpr_read_b32 v38, a16
		v_mul_lo_u32 v38, s18, v38
		v_lshl_add_u32 v3, v38, 2, v3
		v_accvgpr_read_b32 v39, a17
		v_lshl_add_u32 v3, v39, 4, v3
		v_mov_b32_e32 v40, s44
		v_mov_b32_e32 v41, s45
		s_nop 0
		v_readfirstlane_b32 s24, v40
		v_readfirstlane_b32 s25, v41
		s_and_saveexec_b64 s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_24
		buffer_store_dwordx4 v[72:75], v3, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_24:
		s_andn2_b64 exec, s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_24
.L_attn_fwd_persistent.exec_endif_24:
		s_mov_b64 exec, s[92:93]
		s_add_i32 s23, s1, 32
		s_add_i32 s23, s23, s19
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v3, v2, 6, s23
		v_lshl_add_u32 v3, v20, 1, v3
		v_lshl_add_u32 v3, v21, 5, v3
		v_lshl_add_u32 v3, v36, 4, v3
		v_lshl_add_u32 v3, v37, 3, v3
		v_lshl_add_u32 v3, v38, 2, v3
		v_accvgpr_read_b32 v39, a17
		v_lshl_add_u32 v3, v39, 4, v3
		v_readfirstlane_b32 s24, v40
		v_readfirstlane_b32 s25, v41
		s_and_saveexec_b64 s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_25
		buffer_store_dwordx4 v[4:7], v3, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_25:
		s_andn2_b64 exec, s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_25
.L_attn_fwd_persistent.exec_endif_25:
		s_mov_b64 exec, s[92:93]
		s_add_i32 s23, s1, 64
		s_add_i32 s23, s23, s19
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v3, v2, 6, s23
		v_lshl_add_u32 v3, v20, 1, v3
		v_lshl_add_u32 v3, v21, 5, v3
		v_lshl_add_u32 v3, v36, 4, v3
		v_lshl_add_u32 v3, v37, 3, v3
		v_lshl_add_u32 v3, v38, 2, v3
		v_accvgpr_read_b32 v4, a17
		v_lshl_add_u32 v3, v4, 4, v3
		v_readfirstlane_b32 s24, v40
		v_readfirstlane_b32 s25, v41
		s_and_saveexec_b64 s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_26
		buffer_store_dwordx4 v[8:11], v3, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_26:
		s_andn2_b64 exec, s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_26
.L_attn_fwd_persistent.exec_endif_26:
		s_mov_b64 exec, s[92:93]
		s_add_i32 s23, s1, 0x60
		s_add_i32 s23, s23, s19
		s_add_i32 s23, s23, s22
		v_lshl_add_u32 v3, v2, 6, s23
		v_lshl_add_u32 v3, v20, 1, v3
		v_lshl_add_u32 v3, v21, 5, v3
		v_lshl_add_u32 v3, v36, 4, v3
		v_lshl_add_u32 v3, v37, 3, v3
		v_lshl_add_u32 v3, v38, 2, v3
		v_accvgpr_read_b32 v4, a17
		v_lshl_add_u32 v3, v4, 4, v3
		v_readfirstlane_b32 s24, v40
		v_readfirstlane_b32 s25, v41
		s_and_saveexec_b64 s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_27
		buffer_store_dwordx4 v[12:15], v3, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_27:
		s_andn2_b64 exec, s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_27
.L_attn_fwd_persistent.exec_endif_27:
		s_mov_b64 exec, s[92:93]
		s_lshl_b32 s23, s18, 8
		s_add_i32 s24, s23, s1
		s_add_i32 s24, s24, s19
		s_add_i32 s24, s24, s22
		v_lshl_add_u32 v3, v2, 6, s24
		v_lshl_add_u32 v3, v20, 1, v3
		v_lshl_add_u32 v3, v21, 5, v3
		v_lshl_add_u32 v3, v36, 4, v3
		v_lshl_add_u32 v3, v37, 3, v3
		v_lshl_add_u32 v3, v38, 2, v3
		v_accvgpr_read_b32 v4, a17
		v_lshl_add_u32 v3, v4, 4, v3
		v_readfirstlane_b32 s24, v22
		v_readfirstlane_b32 s25, v23
		s_and_saveexec_b64 s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_28
		buffer_store_dwordx4 v[16:19], v3, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_28:
		s_andn2_b64 exec, s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_28
.L_attn_fwd_persistent.exec_endif_28:
		s_mov_b64 exec, s[92:93]
		s_add_i32 s24, s23, 32
		s_add_i32 s24, s24, s1
		s_add_i32 s24, s24, s19
		s_add_i32 s24, s24, s22
		v_lshl_add_u32 v3, v2, 6, s24
		v_lshl_add_u32 v3, v20, 1, v3
		v_lshl_add_u32 v3, v21, 5, v3
		v_lshl_add_u32 v3, v36, 4, v3
		v_lshl_add_u32 v3, v37, 3, v3
		v_lshl_add_u32 v3, v38, 2, v3
		v_accvgpr_read_b32 v4, a17
		v_lshl_add_u32 v3, v4, 4, v3
		v_readfirstlane_b32 s24, v22
		v_readfirstlane_b32 s25, v23
		s_and_saveexec_b64 s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_29
		buffer_store_dwordx4 v[24:27], v3, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_29:
		s_andn2_b64 exec, s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_29
.L_attn_fwd_persistent.exec_endif_29:
		s_mov_b64 exec, s[92:93]
		s_add_i32 s24, s23, 64
		s_add_i32 s24, s24, s1
		s_add_i32 s24, s24, s19
		s_add_i32 s24, s24, s22
		v_lshl_add_u32 v3, v2, 6, s24
		v_lshl_add_u32 v3, v20, 1, v3
		v_lshl_add_u32 v3, v21, 5, v3
		v_lshl_add_u32 v3, v36, 4, v3
		v_lshl_add_u32 v3, v37, 3, v3
		v_lshl_add_u32 v3, v38, 2, v3
		v_accvgpr_read_b32 v4, a17
		v_lshl_add_u32 v3, v4, 4, v3
		v_readfirstlane_b32 s24, v22
		v_readfirstlane_b32 s25, v23
		s_and_saveexec_b64 s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_30
		buffer_store_dwordx4 v[28:31], v3, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_30:
		s_andn2_b64 exec, s[92:93], s[24:25]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_30
.L_attn_fwd_persistent.exec_endif_30:
		s_mov_b64 exec, s[92:93]
		s_add_i32 s23, s23, 0x60
		s_add_i32 s1, s23, s1
		s_add_i32 s1, s1, s19
		s_add_i32 s1, s1, s22
		v_lshl_add_u32 v2, v2, 6, s1
		v_lshl_add_u32 v2, v20, 1, v2
		v_lshl_add_u32 v2, v21, 5, v2
		v_lshl_add_u32 v2, v36, 4, v2
		v_lshl_add_u32 v2, v37, 3, v2
		v_lshl_add_u32 v2, v38, 2, v2
		v_accvgpr_read_b32 v3, a17
		v_lshl_add_u32 v2, v3, 4, v2
		v_readfirstlane_b32 s22, v22
		v_readfirstlane_b32 s23, v23
		s_and_saveexec_b64 s[92:93], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_else_31
		buffer_store_dwordx4 v[32:35], v2, s[28:31], 0 offen
.L_attn_fwd_persistent.exec_else_31:
		s_andn2_b64 exec, s[92:93], s[22:23]
		s_cbranch_execz .L_attn_fwd_persistent.exec_endif_31
.L_attn_fwd_persistent.exec_endif_31:
		s_mov_b64 exec, s[92:93]
		s_branch .L_attn_fwd_persistent.if_end_3
.L_attn_fwd_persistent.if_else_3:
.L_attn_fwd_persistent.if_end_3:
		s_branch .L_attn_fwd_persistent.if_end_0
.L_attn_fwd_persistent.if_else_0:
.L_attn_fwd_persistent.if_end_0:
		s_waitcnt lgkmcnt(0)
		s_barrier
		s_add_i32 s0, s0, 32
		v_accvgpr_read_b32 v2, a8
		s_nop 0
		v_readfirstlane_b32 s1, v2
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
		.amdhsa_next_free_sgpr 94
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
	.set .L_attn_fwd_persistent.numbered_sgpr, 94
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
    .sgpr_count:     94
    .sgpr_spill_count: 0
    .symbol:         _attn_fwd_persistent.kd
    .uses_dynamic_stack: false
    .vgpr_count:     512
    .agpr_count:     256
    .vgpr_spill_count: 0
    .wavefront_size: 64
    .workgroup_processor_mode: 1
    wave.regalloc.iterations: 458
    wave.regalloc.agpr.dwords: 881
    wave.regalloc.remat.dwords: 10
    wave.regalloc.sgpr_to_vgpr.dwords: 98
    wave.regalloc.lds.dwords: 0
    wave.regalloc.scratch.dwords: 0
amdhsa.target:   amdgcn-amd-amdhsa--gfx950
amdhsa.version:
  - 1
  - 2
...
	.end_amdgpu_metadata
